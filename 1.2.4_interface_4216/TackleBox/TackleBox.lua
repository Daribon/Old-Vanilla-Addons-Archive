--[[
	Tackle Box

	By Mugendai

	This mod assists the fisherman by making it easy to cast,
	and easy to switch to the fishing poles and back.
	When a fishing pole is equipped, right clicking will cause
	the player to cast their line.
   ]]
   
TACKLEBOX_DOWNWAIT = 0.2;
TACKLEBOX_MACRO_BODY = "/script TackleBox_Switch();";

TackleBox_ChatHandlers = {};
TackleBox_DownTime = nil;
TackleBox_Config = {};
TackleBox_Config.EasyCast = 0;
TackleBox_Config.FastCast = 0;
TackleBox_Config.UsePole = {};
TackleBox_Config.UseMainHand = {};
TackleBox_Config.UseSecondaryHand = {};
TackleBox_Config.UseFishingHat = {};
TackleBox_Config.UseHat = {};

-- General Cosmos Registration Functions
function TackleBox_RegisterCosmos()

	--
	-- Check for the functions before calling them. 
	--
	-- This will make it possible to keep the add-on
	-- independent of Cosmos Core
	-- 
	--
	if ( Cosmos_RegisterConfiguration ) then 

		Cosmos_RegisterConfiguration(
			"COS_TACKLEBOX",
			"SECTION",
			TACKLEBOX_CONFIG_SECTION,
			TACKLEBOX_CONFIG_SECTION_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_TACKLEBOX_EASYCAST_TOGGLE", -- CVAr
			"CHECKBOX",
			TACKLEBOX_CONFIG_EASYCAST_ONOFF,
			TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO,
			TackleBox_EasyCast_Toggle,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_TACKLEBOX_FASTCAST_TOGGLE", -- CVAr
			"CHECKBOX",
			TACKLEBOX_CONFIG_FASTCAST_ONOFF,
			TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO,
			TackleBox_FastCast_Toggle,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_TACKLEBOX_SWITCH_TOGGLE",
			"CHECKBOX",
			TACKLEBOX_CONFIG_SWITCH_ONOFF,
			TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO,
			TackleBox_MakeMacro,
			0
			);
			
		local TackleBoxCommands = {"/tacklebox","/tb"};
		Cosmos_RegisterChatCommand (
			"TACKLEBOX_COMMANDS", -- Some Unique Group ID
			TackleBoxCommands, -- The Commands
			TackleBox_ChatCommandHandler,
			TACKLEBOX_CHAT_COMMAND_INFO -- Description String
		);
		
		Cosmos_RegisterVarsLoaded(TackleBox_LoadSettings);
	else
		SlashCmdList["TACKLEBOXSLASH"] = TackleBox_ChatCommandHandler;
		SLASH_TACKLEBOXSLASH1 = "/tacklebox";
		SLASH_TACKLEBOXSLASH2 = "/tb";
		PopBar_Loaded = true;
		
		TackleBox_MakeMacro(1);
	end
end

-- TackleBox command handler
function TackleBox_ChatCommandHandler(msg)
	if (msg) then
		msg = string.lower(msg);
		local command, setStr = unpack(Sea.string.split(msg, " "));
		if ((not command) and msg) then
			command = msg;
		end
		if (command) then
			if (setStr) then
				setStr = string.lower(setStr);
				if (string.find(setStr, 'on')) then
					setStr = 1;
				elseif (string.find(setStr, 'off')) then
					setStr = 0;
				end
			else
				setStr = -1;
			end
			for curCommand in TackleBox_ChatHandlers do
				if (command == curCommand) then
					TackleBox_ChatHandlers[curCommand](setStr);
					return;
				end
			end
		end
	end
	for i = 1, getn(TACKLEBOX_CHAT_COMMAND_HELP) do
		Sea.io.printc(ChatTypeInfo["SYSTEM"], TACKLEBOX_CHAT_COMMAND_HELP[i]);
	end
end

function TackleBox_EasyCast_Toggle(checked)
	if (checked and (checked == -1)) then
		if (TackleBox_Config.EasyCast == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked~=TackleBox_Config.EasyCast)) then
		TackleBox_Config.EasyCast = checked;
		if (Cosmos_UpdateValue) then
			Cosmos_UpdateValue("COS_TACKLEBOX_EASYCAST_TOGGLE", CSM_CHECKONOFF, checked);
		else
			TackleBox_SaveSettings();
			local outString = string.format(TACKLEBOX_OUTPUT_ENABLED, TACKLEBOX_OUTPUT_EASYCAST);
			if (checked == 0) then
				outString = string.format(TACKLEBOX_OUTPUT_DISABLED, TACKLEBOX_OUTPUT_EASYCAST);
			end
			Sea.io.printc(ChatTypeInfo["SYSTEM"], outString);
		end
	end
end
TackleBox_ChatHandlers["easycast"] = TackleBox_EasyCast_Toggle;

function TackleBox_FastCast_Toggle(checked)
	if (checked and (checked == -1)) then
		if (TackleBox_Config.FastCast == 1) then
			checked = 0;
		else
			checked = 1;
		end
	end
	if (checked and (checked~=TackleBox_Config.FastCast)) then
		TackleBox_Config.FastCast = checked;
		if (Cosmos_UpdateValue) then
			Cosmos_UpdateValue("COS_TACKLEBOX_FASTCAST_TOGGLE", CSM_CHECKONOFF, checked);
		else
			TackleBox_SaveSettings();
			local outString = string.format(TACKLEBOX_OUTPUT_ENABLED, TACKLEBOX_OUTPUT_FASTCAST);
			if (checked == 0) then
				outString = string.format(TACKLEBOX_OUTPUT_DISABLED, TACKLEBOX_OUTPUT_FASTCAST);
			end
			Sea.io.printc(ChatTypeInfo["SYSTEM"], outString);
		end
	end
end
TackleBox_ChatHandlers["fastcast"] = TackleBox_FastCast_Toggle;

-- OnFoo Functions
function TackleBox_OnLoad()	
	Sea.util.hook("TurnOrActionStart", "TackleBox_TurnOrActionStart", "after");
	Sea.util.hook("TurnOrActionStop", "TackleBox_TurnOrActionStop", "after");
	TackleBox_RegisterCosmos();
end

function TackleBox_ThrowStart()
	if ((TackleBox_Config.FastCast ~= 1) and (GameTooltip:IsVisible() and (getglobal("GameTooltipTextLeft1"):GetText() == TACKLEBOX_BOBBER_NAME))) then
		TackleBox_DownTime = 0;
	else
		TackleBox_DownTime = GetTime();
	end
end

function TackleBox_ThrowStop()
	local pressTime = GetTime() - TackleBox_DownTime;
	if ((TackleBox_DownTime > 0) and (TACKLEBOX_DOWNWAIT >= pressTime)) then
		local fishID = nil;
		local fishingSkillName = TEXT(TACKLEBOX_SKILL_FISHING_NAME);
		for i = 1, MAX_SPELLS do
			Sea.wow.tooltip.protectTooltipMoney();
			TackleTooltip:SetSpell(i, BOOKTYPE_SPELL);				
			Sea.wow.tooltip.unprotectTooltipMoney();
			local texts = Sea.wow.tooltip.scan("TackleTooltip");
			local text = "";
			if ( ( texts ) and ( texts[1] ) ) then
				text = texts[1]["left"];
			end
			Sea.wow.tooltip.clear("TackleTooltip");
			if (text and (text == fishingSkillName)) then
				fishID = i;
				break;
			end
		end
		
		if (fishID) then
			if (TackleBox_IsFishingPole()) then
				CastSpell(fishID, SpellBookFrame.bookType);
			end
		end
	end
end

function TackleBox_TurnOrActionStart(arg1)
	if (TackleBox_Config.EasyCast == 1) then
		TackleBox_ThrowStart();
	end
end

function TackleBox_TurnOrActionStop(arg1)
	if (TackleBox_Config.EasyCast == 1) then
		TackleBox_ThrowStop();
	end
end

function TackleBox_GetEquipped()
	local mainHand = nil;
	local secondaryHand = nil;
	local hat = nil;
	local mainHandSlot, secondaryHandSlot, headSlot;
	mainHandSlot = GetInventorySlotInfo("MainHandSlot");
	secondaryHandSlot = GetInventorySlotInfo("SecondaryHandSlot");
	headSlot = GetInventorySlotInfo("HeadSlot");
	
	if ( DynamicData ) and ( DynamicData.item ) and ( DynamicData.item.getInventoryInfo ) then
		local itemInfo = nil;
		itemInfo = DynamicData.item.getInventoryInfo(-1, mainHandSlot);
		if ( itemInfo ) then
			mainHand = itemInfo.strings;
		end
		itemInfo = DynamicData.item.getInventoryInfo(-1, secondaryHandSlot);
		if ( itemInfo ) then
			secondaryHand = itemInfo.strings;
		end
		itemInfo = DynamicData.item.getInventoryInfo(-1, headSlot);
		if ( itemInfo ) then
			hat = itemInfo.strings;
		end
		return mainHand, secondaryHand, hat;
	end
	
	Sea.wow.tooltip.protectTooltipMoney();
	local hasItem = TackleTooltip:SetInventoryItem("player", mainHandSlot);
	Sea.wow.tooltip.unprotectTooltipMoney();
	if (hasItem) then
		local itemTip = Sea.wow.tooltip.scan("TackleTooltip");
		Sea.wow.tooltip.clear("TackleTooltip");
		if (itemTip) then
			mainHand = itemTip;
		end
	end
	
	Sea.wow.tooltip.protectTooltipMoney();
	hasItem = TackleTooltip:SetInventoryItem("player", secondaryHandSlot);
	Sea.wow.tooltip.unprotectTooltipMoney();
	if (hasItem) then
		local itemTip = Sea.wow.tooltip.scan("TackleTooltip");
		Sea.wow.tooltip.clear("TackleTooltip");
		if (itemTip) then
			secondaryHand = itemTip;
		end
	end
	
	Sea.wow.tooltip.protectTooltipMoney();
	hasItem = TackleTooltip:SetInventoryItem("player", headSlot);
	Sea.wow.tooltip.unprotectTooltipMoney();
	if (hasItem) then
		local itemTip = Sea.wow.tooltip.scan("TackleTooltip");
		Sea.wow.tooltip.clear("TackleTooltip");
		if (itemTip) then
			hat = itemTip;
		end
	end

	return mainHand, secondaryHand, hat;
end

function TackleBox_IsFishingPole(itemTip)
	local name = nil;
	if (itemTip and itemTip[1] and itemTip[1]["left"]) then
		name = itemTip[1]["left"];
	end
	if (not name) then
		mainHand = TackleBox_GetEquipped();
		if (mainHand and TackleBox_IsFishingPole(mainHand)) then
			return true;
		end
	elseif (string.find(name, TEXT(TACKLEBOX_ITEM_FISHING_NAME)) and (string.find(name, TEXT(TACKLEBOX_ITEM_FISHING_POLE_NAME)) or string.find(name, TEXT(TACKLEBOX_ITEM_FISHING_ROD_NAME)))) then
		return true;
	end
	return nil;
end

function TackleBox_CompareItem(itemTip, itemTip2)
	if (not itemTip2) then
		itemTip2 = Sea.wow.tooltip.scan("TackleTooltip");
	end
	
	if (itemTip and itemTip2) then
		if (type(itemTip) ~= "table") then
			if (type(itemTip2) ~= "table") then
				if (itemTip == itemTip2) then
					return true;
				end
				return false;
			else
				for curText = 1, table.getn(itemTip) do
					if (itemTip2[curText] and itemTip2[curText]["left"] and (itemTip == itemTip2[curText]["left"])) then
						return true;
					end
					if (itemTip2[curText] and itemTip2[curText]["right"] and (itemTip == itemTip2[curText]["right"])) then
						return true;
					end
				end
				return false;
			end
		else
			if (type(itemTip2) ~= "table") then
				return false;
			end
			if ((getn(itemTip) == 0) or (getn(itemTip2) == 0)) then
				return false;
			end
			return Sea.wow.tooltip.compareTooltipScan(itemTip, itemTip2);
		end
	end
	return false;
end

function TackleBox_FindContainerItem(itemTip)
	local foundBag = nil;
	local foundSlot = nil;
	Sea.wow.tooltip.clear("TackleTooltip");
	if (itemTip) then
		for bag = 0, NUM_CONTAINER_FRAMES, 1 do
			local frame = getglobal("ContainerFrame"..bag);
			for slot = 1, GetContainerNumSlots(bag) do
				Sea.wow.tooltip.protectTooltipMoney();
				TackleTooltip:SetBagItem( bag, slot );
				Sea.wow.tooltip.unprotectTooltipMoney();
				if (TackleBox_CompareItem(itemTip)) then
					foundBag = bag;
					foundSlot = slot;
					break;
				end
				Sea.wow.tooltip.clear("TackleTooltip");
			end
			if (foundBag and foundSlot) then
				break;
			end
		end
	end
	return foundBag, foundSlot;
end

function TackleBox_Equip(itemTip, equipSlot)
	if (CursorHasItem()) then
		return false;
	end
	local bag, slot = TackleBox_FindContainerItem(itemTip);
	if (bag and slot) then
		PickupContainerItem(bag, slot);
		if (equipSlot) then
			PickupInventoryItem(equipSlot);
		else
			AutoEquipCursorItem();
		end
		return true;
	end
	return false;
end

function TackleBox_SaveSettings()
	if (Cosmos_SetCVar) then
		Cosmos_SetCVar("COS_TACKLEBOX_CONFIG", TackleBox_Config);
	else
		RegisterForSave("TackleBox_Config");
	end
end

function TackleBox_LoadSettings()
	if (Cosmos_GetCVar) then
		local TackleBox_TempConfig = Cosmos_GetCVar("COS_TACKLEBOX_CONFIG");
		if (TackleBox_TempConfig) then
			if (TackleBox_TempConfig.UsePole) then
				TackleBox_Config.UsePole = TackleBox_TempConfig.UsePole;
			end
			if (TackleBox_TempConfig.UseMainHand) then
				TackleBox_Config.UseMainHand = TackleBox_TempConfig.UseMainHand;
			end
			if (TackleBox_TempConfig.UseSecondaryHand) then
				TackleBox_Config.UseSecondaryHand = TackleBox_TempConfig.UseSecondaryHand;
			end
			if (TackleBox_TempConfig.UseFishingHat) then
				TackleBox_Config.UseFishingHat = TackleBox_TempConfig.UseFishingHat;
			end
			if (TackleBox_TempConfig.UseHat) then
				TackleBox_Config.UseHat = TackleBox_TempConfig.UseHat;
			end
			
			if (type(TackleBox_Config.UsePole) ~= "table") then
				TackleBox_Config.UsePole = {};
			end
			if (type(TackleBox_Config.UseMainHand) ~= "table") then
				TackleBox_Config.UseMainHand = {};
			end
			if (type(TackleBox_Config.UseSecondaryHand) ~= "table") then
				TackleBox_Config.UseSecondaryHand = {};
			end
			if (type(TackleBox_Config.UseFishingHat) ~= "table") then
				TackleBox_Config.UseFishingHat = {};
			end
			if (type(TackleBox_Config.UseHat) ~= "table") then
				TackleBox_Config.UseHat = {};
			end
		end
	end
end

function TackleBox_Switch()
	local MainHandSlot = GetInventorySlotInfo("MainHandSlot");
	local SecondaryHandSlot = GetInventorySlotInfo("SecondaryHandSlot");
	local HeadSlot = GetInventorySlotInfo("HeadSlot");

	local mainHand, secondaryHand, hat = TackleBox_GetEquipped();
	if (TackleBox_IsFishingPole(mainHand)) then
		if (not TackleBox_CompareItem(TackleBox_Config.UsePole, mainHand)) then
			TackleBox_Config.UsePole = mainHand;
			if (mainHand and mainHand[1] and mainHand[1]["left"]) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], format(TACKLEBOX_OUTPUT_SET_POLE, mainHand[1]["left"]));
			end
			TackleBox_SaveSettings();
		end
		if (not TackleBox_CompareItem(TackleBox_Config.UseFishingHat, hat)) then
			TackleBox_Config.UseFishingHat = hat;
			if (hat and hat[1] and hat[1]["left"]) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], format(TACKLEBOX_OUTPUT_SET_FISHING_HAT, hat[1]["left"]));
			end
			TackleBox_SaveSettings();
		end
		
		if (TackleBox_Config.UseMainHand and (getn(TackleBox_Config.UseMainHand) > 0)) then
			if (not TackleBox_Equip(TackleBox_Config.UseMainHand, MainHandSlot)) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], TACKLEBOX_OUTPUT_NEED_SET_HAND);
				TackleBox_Config.UseMainHand = {};
				TackleBox_SaveSettings();
			end
		else
			Sea.io.printc(ChatTypeInfo["SYSTEM"], TACKLEBOX_OUTPUT_NEED_SET_HAND);
		end
		if (TackleBox_Config.UseSecondaryHand and (getn(TackleBox_Config.UseSecondaryHand) > 0)) then
			if (not TackleBox_Equip(TackleBox_Config.UseSecondaryHand, SecondaryHandSlot)) then
				TackleBox_Config.UseSecondaryHand = {};
				TackleBox_SaveSettings();
			end
		end
		if (TackleBox_Config.UseHat and (getn(TackleBox_Config.UseHat) > 0) and (not TackleBox_CompareItem(TackleBox_Config.UseHat, hat))) then
			if (not TackleBox_Equip(TackleBox_Config.UseHat, HeadSlot)) then
				TackleBox_Config.UseHat = {};
				TackleBox_SaveSettings();
			end
		end
	else
		if (not TackleBox_CompareItem(TackleBox_Config.UseMainHand, mainHand)) then
			TackleBox_Config.UseMainHand = mainHand;
			if (mainHand and mainHand[1] and mainHand[1]["left"]) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], format(TACKLEBOX_OUTPUT_SET_MAIN, mainHand[1]["left"]));
			end
			TackleBox_SaveSettings();
		end
		if (not TackleBox_CompareItem(TackleBox_Config.UseSecondaryHand, secondaryHand)) then
			TackleBox_Config.UseSecondaryHand = secondaryHand;
			if (secondaryHand and secondaryHand[1] and secondaryHand[1]["left"]) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], format(TACKLEBOX_OUTPUT_SET_SECONDARY, secondaryHand[1]["left"]));
			end
			TackleBox_SaveSettings();
		end
		if (not TackleBox_CompareItem(TackleBox_Config.UseHat, hat)) then
			TackleBox_Config.UseHat = hat;
			if (hat and hat[1] and hat[1]["left"]) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], format(TACKLEBOX_OUTPUT_SET_HAT, hat[1]["left"]));
			end
			TackleBox_SaveSettings();
		end
		if (TackleBox_Config.UsePole and (getn(TackleBox_Config.UsePole) > 0)) then
			if (not TackleBox_Equip(TackleBox_Config.UsePole, MainHandSlot)) then
				Sea.io.printc(ChatTypeInfo["SYSTEM"], TACKLEBOX_OUTPUT_NEED_SET_POLE);
				TackleBox_Config.UsePole = {};
				TackleBox_SaveSettings();
			end
		else
			Sea.io.printc(ChatTypeInfo["SYSTEM"], TACKLEBOX_OUTPUT_NEED_SET_POLE);
		end
		if (TackleBox_Config.UseFishingHat and (getn(TackleBox_Config.UseFishingHat) > 0) and (not TackleBox_CompareItem(TackleBox_Config.UseFishingHat, hat))) then
			if (not TackleBox_Equip(TackleBox_Config.UseFishingHat, HeadSlot)) then
				TackleBox_Config.UseFishingHat = {};
				TackleBox_SaveSettings();
			end
		end
	end
end
TackleBox_ChatHandlers["switch"] = TackleBox_Switch;

function TackleBox_MakeMacro(checked)
	if (checked ~= 0) then
		local numMacros	= GetNumMacros();
		local name = nil;
		local id = nil;
		for i=1, numMacros do
			name = GetMacroInfo(i);
			if (name == TACKLEBOX_MACRO_NAME) then
				id = i;
				break;
			end
		end
		
		if (name and id) then
			EditMacro(id, TACKLEBOX_MACRO_NAME, 8, TACKLEBOX_MACRO_BODY, 1);	
		else
			CreateMacro(TACKLEBOX_MACRO_NAME, 8, TACKLEBOX_MACRO_BODY, 1);
		end
	end
end