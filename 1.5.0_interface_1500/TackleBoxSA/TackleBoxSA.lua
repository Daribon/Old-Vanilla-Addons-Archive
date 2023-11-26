local _DEBUG = false;
TBOX_DOWNWAIT = 0.2;
TBox_DownTime = nil;
local tb = nil;
local profile = nil;

local function Print(msg)
	if (not msg) then return; end
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg,1.0,1.0,1.0);
	end
end
local function Debug(msg)
	if (not _DEBUG) then return; end
	if (not msg) then return; end
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("TB: "..GetTime()..": "..msg,1.0,0.0,0.0);
	end
end


function TBox_OnLoad()

	NormTurnOrActionStart = TurnOrActionStart;
	TurnOrActionStart = TBox_TurnOrActionStart;
	NormTurnOrActionStop = TurnOrActionStop;
	TurnOrActionStop = TBox_TurnOrActionStop;

	-- create slash commands
	SlashCmdList["TBOXSLASH"] = TBox_ChatCommandHandler;
	SLASH_TBOXSLASH1 = "/tacklebox";
	SLASH_TBOXSLASH2 = "/tb";

	this:RegisterEvent("VARIABLES_LOADED");

end

-- temporary
local function TBox_CleanupVar(var)
	if (TackleBoxSA_Cfg[var]) then TackleBoxSA_Cfg[var] = nil; end
end

function TBox_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		if (not tb) then
			profile = UnitName("player").." of "..GetCVar("RealmName");
			if (not TackleBoxSA_Cfg) then
				TackleBoxSA_Cfg = {};
			end
			tb = TackleBoxSA_Cfg[profile];
			if (not TackleBoxSA_Cfg[profile]) then
				TackleBoxSA_Cfg[profile] = {
					['EasyCast'] = true,
					['FastCast'] = true,
				};
				Debug("Setting TackleBox defaults");
			end
			tb = TackleBoxSA_Cfg[profile];
		end

		-- Cleanup old saved variables (temporary)
		TBox_CleanupVar('EasyCast');
		TBox_CleanupVar('FastCast');
		TBox_CleanupVar('debug');
		TBox_CleanupVar('FishingPole');
		TBox_CleanupVar('FishingGloves');
		TBox_CleanupVar('NormalMainHand');
		TBox_CleanupVar('NormalSecondaryHand');
		TBox_CleanupVar('NormalGloves');

		Print(TBOX_OUT_LOADED);
	end
end


-- TackleBox command handler
function TBox_ChatCommandHandler(msg)
	if (not msg) then return; end
	local args = {};
	for arg in string.gfind(msg, "([%w]+)") do
		table.insert(args, arg);
	end
	if (not args[1]) then
		if (tb['EasyCast']) then
			Print(string.format(TBOX_OUT_ENABLED, TBOX_OUT_EASYCAST));
		else
			Print(string.format(TBOX_OUT_DISABLED, TBOX_OUT_EASYCAST));
		end
		if (tb['FastCast']) then
			Print(string.format(TBOX_OUT_ENABLED, TBOX_OUT_FASTCAST));
		else
			Print(string.format(TBOX_OUT_DISABLED, TBOX_OUT_FASTCAST));
		end
	elseif (args[1] and args[1] == TBOX_CMD_EASYCAST) then
		TBox_EasyCast_Toggle(args[2]);
	elseif (args[1] and args[1] == TBOX_CMD_FASTCAST) then
		TBox_FastCast_Toggle(args[2]);
	elseif (args[1] and args[1] == TBOX_CMD_SWITCH) then
		TBox_Switch();
	elseif (args[1] and args[1] == TBOX_CMD_RESET) then
		TBox_Reset();
	elseif (args[1] and args[1] == "debug") then
		TBox_ToggleDebug();
	else
		for index, value in TBOX_COMMAND_HELP do
			Print(value);
		end
	end
end

function TBox_EasyCast_Toggle(togVar)
	if (not togVar) then
		tb['EasyCast'] = not tb['EasyCast'];
	elseif (string.lower(togVar) == "on") then
		tb['EasyCast'] = true;
	elseif (togVar == "off") then
		tb['EasyCast'] = false;
	else
		Print(TBOX_SYNTAX_ERROR);
		Print(TBOX_SYNTAX_EASYCAST);
		return;
	end
	if (tb['EasyCast']) then
		Print(string.format(TBOX_OUT_ENABLED, TBOX_OUT_EASYCAST));
	else
		Print(string.format(TBOX_OUT_DISABLED, TBOX_OUT_EASYCAST));
	end
end

function TBox_FastCast_Toggle(togVar)
	if (not togVar) then
		tb['FastCast'] = not tb['FastCast'];
	elseif (string.lower(togVar) == "on") then
		tb['FastCast'] = true;
	elseif (togVar == "off") then
		tb['FastCast'] = false;
	else
		Print(TBOX_SYNTAX_ERROR);
		Print(TBOX_SYNTAX_FASTCAST);
		return;
	end
	if (tb['FastCast']) then
		Print(string.format(TBOX_OUT_ENABLED, TBOX_OUT_FASTCAST));
	else
		Print(string.format(TBOX_OUT_DISABLED, TBOX_OUT_FASTCAST));
	end
end

function TBox_TurnOrActionStart(arg1)
	if (NormTurnOrActionStart) then
		NormTurnOrActionStart(arg1);
	end
	if (tb['EasyCast']) then
		if (not tb['FastCast'] and (GameTooltip:IsVisible() and (getglobal("GameTooltipTextLeft1"):GetText() == TBOX_BOBBER_NAME))) then
			TBox_DownTime = 0;
		else
			TBox_DownTime = GetTime();
		end
	end
end

function TBox_GetEquipped()
	local mainHandID = nil;
	local secondaryHandID = nil;
	local glovesID = nil;

	local slotID = GetInventorySlotInfo("MainHandSlot");
	local link = GetInventoryItemLink("player", slotID);
	local id = nil;
	if (link) then
		for id in string.gfind(link, "item:(%d+):") do
			mainHandID = tonumber(id);
		end
	end

	slotID = GetInventorySlotInfo("SecondaryHandSlot");
	link = GetInventoryItemLink("player", slotID);
	id = nil;
	if (link) then
		for id in string.gfind(link, "item:(%d+):") do
			secondaryHandID = tonumber(id);
		end
	end

	slotID = GetInventorySlotInfo("HandsSlot");
	link = GetInventoryItemLink("player", slotID);
	id = nil;
	if (link) then
		for id in string.gfind(link, "item:(%d+):") do
			glovesID = tonumber(id);
		end
	end

	return mainHandID, secondaryHandID, glovesID;
end

function TBox_IsFishingPole(itemID)
	if (not itemID) then
		-- get the itemID of the main hand slot
		mainHandID,_,_ = TBox_GetEquipped();
		if (not mainHandID) then return false; end
		-- recurse to this function
		return TBox_IsFishingPole(mainHandID);
	else
		-- check each known pole
		for i=1, table.getn(TBOX_POLES) do
			if (tonumber(itemID) == TBOX_POLES[i]['id']) then
				return true;
			end
		end
		return false;
	end
end

function TBox_TurnOrActionStop(arg1)
	if (NormTurnOrActionStop) then
		NormTurnOrActionStop(arg1);
	end
	if (tb['EasyCast']) then
		local pressTime = GetTime() - TBox_DownTime;
		if (TBOX_DOWNWAIT >= pressTime) then
			local fishID;
			for i = 1, MAX_SPELLS do
				TBoxTooltip:SetSpell(i, BOOKTYPE_SPELL);
				local field = getglobal("TBoxTooltipTextLeft1");
				local text = field:GetText();
				field:SetText("");
				if (text and (text == TBOX_FISHING_SKILL_NAME)) then
					fishID = i;
					field:SetText("");
					break;
				end
			end

			if (fishID) then
				if (IsShiftKeyDown()) then
					Debug("shift key is down");
				end
				if (TBox_IsFishingPole()) then
					CastSpell(fishID, SpellBookFrame.bookType);
				end
			end
		end
	end
end

function TBox_FindContainerItem(itemID)
	if (not itemID) then return nil,nil; end

	local foundBag = nil;
	local foundSlot = nil;
	local numSlots = 0;

	-- check each of the bags on the player
	for i=0, NUM_BAG_FRAMES do

		-- get the number of slots in the bag (0 if no bag)
		numSlots = GetContainerNumSlots(i);
		if (numSlots > 0) then

			-- check each slot in the bag
			for j=1, numSlots do

				itemLink = GetContainerItemLink(i,j);
				if (itemLink) then

					-- check for the specified itemID
					if (string.find(itemLink, "item:"..itemID..":")) then
						foundBag = i;
						foundSlot = j;
						Debug("Found "..itemLink.." at bag"..foundBag.." slot"..foundSlot);
						-- break out of the slot loop
						break;
					end

				end
			end

			-- break out of the bag loop if we found the item
			if (foundBag) then break; end
		end
	end

	return foundBag, foundSlot;
end

function TBox_Equip(itemID, equipSlot)
	-- fail if something's on the cursor
	if (CursorHasItem()) then
		return false;
	end
	-- make sure it's not already equipped
	local currentLink = GetInventoryItemLink("player",equipSlot);
	if (currentLink and string.find(currentLink, "item:"..itemID..":")) then
		return true;
	end
	-- try to find the item in their bags
	local bag, slot = TBox_FindContainerItem(itemID);
	if (bag and slot) then
		PickupContainerItem(bag, slot);
		if (equipSlot) then
			PickupInventoryItem(bag, slot);
		else
			AutoEquipCursorItem();
		end
		return true;
	end
	return false;
end

function TBox_Switch()
	local MainHandSlot = GetInventorySlotInfo("MainHandSlot");
	local SecondaryHandSlot = GetInventorySlotInfo("SecondaryHandSlot");
	local HandsSlot = GetInventorySlotInfo("HandsSlot");


	local mainHandID, secondaryHandID, glovesID = TBox_GetEquipped();
	if (TBox_IsFishingPole(mainHandID)) then
		-- switch from Fishing Gear to Normal Gear

		-- if our fishing gear doesn't match what's saved, then save them
		if (mainHandID ~= tb['FishingPole']) then
			-- save the new fishing pole
			tb['FishingPole'] = mainHandID;
			if (mainHandID) then
				Print(string.format(TBOX_OUT_SET_POLE,GetInventoryItemLink("player",MainHandSlot)));
			end
		end

		-- if the gloves we have are not what's saved, save them
		if (glovesID ~= tb['FishingGloves']) then
			-- save the new fishing gloves
			tb['FishingGloves'] = glovesID;
			if (glovesID) then
				Print(string.format(TBOX_OUT_SET_FISHING_GLOVES,GetInventoryItemLink("player",HandsSlot)));
			end
		end

		-- swap to our saved main hand
		if (tb['NormalMainHand']) then
			if (not TBox_Equip(tb['NormalMainHand'], MainHandSlot)) then
				-- couldn't equip saved main hand item
				Print(TBOX_OUT_NEED_SET_NORMAL);
				tb['NormalMainHand'] = nil;
			end
		else
			-- there's no saved main hand item
			Print(TBOX_OUT_NEED_SET_NORMAL);
		end
		if (tb['NormalSecondaryHand']) then
			if (not TBox_Equip(tb['NormalSecondaryHand'], SecondaryHandSlot)) then
				-- couldn't equip saved secondary hand item
				tb['NormalSecondaryHand'] = nil;
			end
		end
		if (tb['NormalGloves']) then
			if (not TBox_Equip(tb['NormalGloves'], HandsSlot)) then
				-- couldn't equip saved gloves item
				tb['NormalGloves'] = nil;
			end
		end
	else
		-- switch from whatever we're wearing to Fishing Gear

		-- if our current gear doesn't match what's saved, then save them
		if (mainHandID ~= tb['NormalMainHand']) then
			-- save the new main hand item
			tb['NormalMainHand'] = mainHandID;
			if (mainHandID) then
				Print(string.format(TBOX_OUT_SET_MAIN,GetInventoryItemLink("player",MainHandSlot)));
			end
		end
		if (secondaryHandID ~= tb['NormalSecondaryHand']) then
			-- save the new secondary hand item
			tb['NormalSecondaryHand'] = secondaryHandID;
			if (secondaryHandID) then
				Print(string.format(TBOX_OUT_SET_SECONDARY,GetInventoryItemLink("player",SecondaryHandSlot)));
			end
		end
		if (glovesID ~= tb['NormalGloves']) then
			-- save the new gloves
			tb['NormalGloves'] = glovesID;
			if (glovesID) then
				Print(string.format(TBOX_OUT_SET_GLOVES,GetInventoryItemLink("player",HandsSlot)));
			end
		end

		-- swap to our saved pole if we have one
		if (tb['FishingPole']) then
			if (not TBox_Equip(tb['FishingPole'],MainHandSlot)) then
				-- couldn't equip saved pole
				Print(TBOX_OUT_NEED_SET_POLE);
				tb['FishingPole'] = nil;
			end
		else
			-- there's no saved pole
			Print(TBOX_OUT_NEED_SET_POLE);
		end
		if (tb['FishingGloves']) then
			if (not TBox_Equip(tb['FishingGloves'],HandsSlot)) then
				-- couldn't equip saved fishing gloves
				tb['FishingGloves'] = nil;
			end
		end

	end
end


function TBox_Reset()
	tb['NormalMainHand'] = nil;
	tb['NormalSecondaryHand'] = nil;
	tb['NormalGloves'] = nil;
	tb['FishingPole'] = nil;
	tb['FishingGloves'] = nil;
	Print(TBOX_OUT_RESET);
end

function TBox_ToggleDebug()
	_DEBUG = not _DEBUG;
	if (_DEBUG) then
		Print("Debug output is now on.");
	else
		Print("Debug output is now off.");
	end
end

