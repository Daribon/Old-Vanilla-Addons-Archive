ImprovedMacro_Saved_ChatFrame_OnEvent = nil;
ImprovedMacro_Saved_PaperDollItemSlotButton = nil;
ImprovedMacro_Saved_ContainerFrameItemButton_OnClick = nil;
ImprovedMacro_Saved_Cosmos_ContainerFrameItemButton_OnClick = nil;

--[[
Allow you to use more keywords in the macros : 

-- -- -- Names -->

	%pet => Pet Name
	%me, %p1 => Player Name
	%t => Target Name
	%p2 => Party Member 1 Name
	%p3 => Party Member 2 Name
	%p4 => Party Member 3 Name
	%p5 => Party Member 4 Name

-- -- -- Levels -->

	%petl => Pet Level
	%mel, %pl1 => Player Level
	%tl => Target Level
	%pl2 => Party Member 1 Level
	%pl3 => Party Member 2 Level
	%pl4 => Party Member 3 Level
	%pl5 => Party Member 4 Level
]]

function ImprovedMacro_ChatFrame_OnEvent(event)
	if ( event == "EXECUTE_CHAT_LINE" ) then
		
		local p0 = UnitName("pet"); if (not UnitName("pet")) then p0 = "<error:p0>" end
		local p1 = UnitName("player"); if (not UnitName("player")) then p1 = "<error:p1>" end
		local p2 = UnitName("party1"); if (not UnitName("party1")) then p2 = "<error:p2>" end
		local p3 = UnitName("party2"); if (not UnitName("party2")) then p3 = "<error:p3>" end
		local p4 = UnitName("party3"); if (not UnitName("party3")) then p4 = "<error:p4>" end
		local p5 = UnitName("party4"); if (not UnitName("party4")) then p5 = "<error:p5>" end
		
		local pl0 = UnitLevel("pet"); if (not UnitLevel("pet")) then pl0 = "<error:p0>" end
		local pl1 = UnitLevel("player"); if (not UnitLevel("player")) then pl1 = "<error:pl1>" end
		local pl2 = UnitLevel("party1"); if (not UnitLevel("party1")) then pl2 = "<error:pl2>" end
		local pl3 = UnitLevel("party2"); if (not UnitLevel("party2")) then pl3 = "<error:pl3>" end
		local pl4 = UnitLevel("party3"); if (not UnitLevel("party3")) then pl4 = "<error:pl4>" end
		local pl5 = UnitLevel("party4"); if (not UnitLevel("party4")) then pl5 = "<error:pl5>" end
		local tl = UnitLevel("target"); if (not UnitLevel("target")) then tl = "<error:tl>" end

		arg1 = string.gsub (arg1, "%%pl0", pl0); -- %pl0
		arg1 = string.gsub (arg1, "%%petl", pl0); -- %plet
		arg1 = string.gsub (arg1, "%%mel", pl1); -- %mel
		arg1 = string.gsub (arg1, "%%pl1", pl1); -- %pl1
		arg1 = string.gsub (arg1, "%%pl2", pl2); -- %pl2
		arg1 = string.gsub (arg1, "%%pl3", pl3); -- %pl3
		arg1 = string.gsub (arg1, "%%pl4", pl4); -- %pl4
		arg1 = string.gsub (arg1, "%%pl5", pl5); -- %pl5
		arg1 = string.gsub (arg1, "%%tl", tl); -- %tl

		arg1 = string.gsub (arg1, "%%p0", p0); -- %p0
		arg1 = string.gsub (arg1, "%%pet", p0); -- %pet
		arg1 = string.gsub (arg1, "%%me", p1); -- %me
		arg1 = string.gsub (arg1, "%%p1", p1); -- %p1
		arg1 = string.gsub (arg1, "%%p2", p2); -- %p2
		arg1 = string.gsub (arg1, "%%p3", p3); -- %p3
		arg1 = string.gsub (arg1, "%%p4", p4); -- %p4
		arg1 = string.gsub (arg1, "%%p5", p5); -- %p5
		
		
		ChatFrame1.editBox:SetText(arg1);
		ChatEdit_SendText(ChatFrame1.editBox);
		ChatEdit_OnEscapePressed(ChatFrame1.editBox);
		return;
	end
	ImprovedMacro_Saved_ChatFrame_OnEvent(event);
end

function ImprovedMacro_RunMacro(id) -- Doesn't work with /cast :(
	local name, texture, body, isLocal = GetMacroInfo(id);
	if (body) then
		for v in string.gfind(body,"[^\n]+") do
			arg1 = v;
			ChatFrame_OnEvent("EXECUTE_CHAT_LINE");
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_MACRO, id));
	end
end

function ImprovedMacro_RunMacro(id)
	if (not GetMacroInfo(id)) then
		DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_MACRO, id));
	end
	
	for i = 1, 120, 1 do
		if (HasAction(i)) then
			PickupMacro(id);
			PlaceAction(i);
			UseAction(i);
			PickupAction(i);
			PickupSpell(124, SpellBookFrame.bookType);
			return;
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(IMCMD_ERROR_MACRO1);
end

function ImprovedMacro_GetItemNameFromLink(itemLink)
	if ( ( itemLink ) and ( strlen(itemLink) > 0 ) ) then
		local itemNameIndex1, itemNameIndex2 = string.find(itemLink, "%[.*%]");
		if ( ( itemNameIndex1 ) and ( itemNameIndex2 ) ) then
			local itemName = strsub(itemLink, itemNameIndex1+1, itemNameIndex2-1);
			if ( itemName ) then
				return itemName;
			end
		end
	end
	return nil;
end

function ImprovedMacro_ContainerFrameItemButton_DoStuff(button, ignoreShift)
	if ( button == "LeftButton" ) then
		if ( IsShiftKeyDown() and not ignoreShift ) then
			if ( MacroFrame:IsVisible() ) then
				local itemLink = GetContainerItemLink(this:GetParent():GetID(), this:GetID());
				local itemName = ImprovedMacro_GetItemNameFromLink(itemLink);
				if ( itemName ) then
					MacroFrame_AddMacroLine(itemName);
				end
			end
		end
	end
end

function ImprovedMacro_ContainerFrameItemButton_OnClick(button, ignoreShift)
	ImprovedMacro_ContainerFrameItemButton_DoStuff(button, ignoreShift);
	ImprovedMacro_Saved_ContainerFrameItemButton_OnClick(button, ignoreShift);
end

function ImprovedMacro_Cosmos_ContainerFrameItemButton_OnClick(button, ignoreShift)
	ImprovedMacro_ContainerFrameItemButton_DoStuff(button, ignoreShift);
	return ImprovedMacro_Saved_Cosmos_ContainerFrameItemButton_OnClick(button, ignoreShift);
end

function ImprovedMacro_PaperDollItemSlotButton_OnClick(button, ignoreShift)
	if ( button == "LeftButton" ) then
		if ( IsShiftKeyDown() and not ignoreShift ) then
			if ( MacroFrame:IsVisible() ) then
				local itemLink = GetInventoryItemLink("player", this:GetID());
				local itemName = ImprovedMacro_GetItemNameFromLink(itemLink);
				if ( itemName ) then
					MacroFrame_AddMacroLine(itemName);
				end
				return;
			end
		end
	end
	ImprovedMacro_Saved_PaperDollItemSlotButton_OnClick(button, ignoreShift);
end

function ImprovedMacro_HookFunction(func, newFunc)
	local oldValue = getglobal(func);
	if ( oldValue ~= getglobal(newFunc) ) then
		setglobal(func, getglobal(newFunc));
		return true;
	end
	return false;
end

function ImprovedMacro_HookFunctions()
	local temp = PaperDollItemSlotButton_OnClick;
	if ( ImprovedMacro_HookFunction("PaperDollItemSlotButton_OnClick" , "ImprovedMacro_PaperDollItemSlotButton_OnClick") ) then
		ImprovedMacro_Saved_PaperDollItemSlotButton_OnClick = temp;
	end
	local temp = ContainerFrameItemButton_OnClick;
	if ( ImprovedMacro_HookFunction("ContainerFrameItemButton_OnClick" , "ImprovedMacro_ContainerFrameItemButton_OnClick") ) then
		ImprovedMacro_Saved_ContainerFrameItemButton_OnClick = temp;
	end
	local temp = ChatFrame_OnEvent;
	if ( ImprovedMacro_HookFunction("ChatFrame_OnEvent" , "ImprovedMacro_ChatFrame_OnEvent") ) then
		ImprovedMacro_Saved_ChatFrame_OnEvent = temp;
	end
end

function ImprovedMacro_OnLoad()
	ImprovedMacro_HookFunctions();
	IMCMD_OnLoad();
end

function ImprovedMacro_OnEvent(event)
end

function ImprovedMacro_OnUpdate(elapsed)
	if ( ContainerFrameItemButton_OnClick ~= ImprovedMacro_Saved_ContainerFrameItemButton_OnClick ) then
		-- retake control from whomever
		if ( ( Cosmos_ContainerFrameItemButton_OnClick ) and ( not ImprovedMacro_Saved_Cosmos_ContainerFrameItemButton_OnClick ) ) then
			-- handle cosmos here
			if ( ( Hooks ) and ( Hooks["ContainerFrameItemButton_OnClick"] ) and ( Hooks["ContainerFrameItemButton_OnClick"]["hide"] ) ) then
				ImprovedMacro_Saved_Cosmos_ContainerFrameItemButton_OnClick = Hooks["ContainerFrameItemButton_OnClick"]["hide"][1];
				Hooks["ContainerFrameItemButton_OnClick"]["hide"][1] = ImprovedMacro_Cosmos_ContainerFrameItemButton_OnClick;
			end
		end
	end
end


------------------------------------------
-----
----- Macros
-----
------------------------------------------

function MakeMacro(macro_name, macro_func)
	local numMacros	= GetNumMacros();
	local name = nil;
	local id = nil;
	for i=1, numMacros do
		name = GetMacroInfo(i);
		if (name == macro_name) then
			id = i;
			break;
		end
	end
	
	if (name and id) then
		EditMacro(id, macro_name, 8, macro_func, 1);
	else
		CreateMacro(macro_name, 8, macro_func, 1);
	end
end

function ImprovedMacro_GetItemName(bag, slot)
	local bagNumber = bag;
	if ( type(bagNumber) ~= "number" ) then
		bagNumber = tonumber(bag);
	end
	if (bagNumber <= -1) then
		GameTooltip:SetInventoryItem("player", slot);
	else
		GameTooltip:SetBagItem(bag, slot);
	end
	return GameTooltipTextLeft1:GetText();
end

------------------------------------------
-----
----- /Commands
-----
------------------------------------------

EquipmentSets = { };
RegisterForSave("EquipmentSets");

function IMCMD_OnLoad()
	local tableCommands = {
		{ name = "EQUIP", func = Equip, cmd = IMCMD_EQUIP_COMM, info = IMCMD_EQUIP_COMM_INFO },
		{ name = "EQUIP_OFFHAND", func = EquipOffhand, cmd = IMCMD_EQUIP_OH_COMM, info = IMCMD_EQUIP_OH_COMM_INFO },
		{ name = "UNEQUIP", func = Unequip, cmd = IMCMD_UNEQUIP_COMM, info = IMCMD_UNEQUIP_COMM_INFO },
		{ name = "USE", func = UseItem, cmd = IMCMD_USE_COMM, info = IMCMD_EQUIP_USE_INFO },
		{ name = "USETYPE", func = UseItemByType, cmd = IMCMD_USETYPE_COMM, info = IMCMD_USETYPE_COMM_INFO },
		{ name = "USECLASSIFICATION", func = UseItemByClassification, cmd = IMCMD_USECLASSIFICATION_COMM, info = IMCMD_USECLASSIFICATION_COMM_INFO },
		{ name = "SSET", func = SaveSet, cmd = IMCMD_SSET_COMM, info = IMCMD_SSET_COMM_INFO },
		{ name = "LSET", func = LoadSet, cmd = IMCMD_LSET_COMM, info = IMCMD_LSET_COMM_INFO },
		{ name = "RUNMACRO", func = ImprovedMacro_RunMacro, cmd = IMCMD_RUNMACRO_COMM, info = IMCMD_RUNMACRO_COMM_INFO },
--		{ name = "EQUIP", func = Equip, cmd = IMCMD_EQUIP_COMM, info = IMCMD_EQUIP_COMM_INFO },
	};
	
	for k, v in tableCommands do
		IMCMD_AddCmdTable(v);
	end
end

function IMCMD_DefaultFunction(...)
	local args = "";
	for k, v in arg do
		args = args..arg.." ";
	end
	if ( strlen(args) > 0 ) then
		args = string.format(" - arguments : %s", args);
	end
	DEFAULT_CHAT_FRAME:AddMessage("slash-command function not implemented"..args, 1, 1, 0);
end

function IMCMD_AddCmdTable(value)
	if ( value ) then
		if ( value.func ) and ( type(value.func) == "string" ) then
			value.func = getglobal(value.func);
		end
		local func = value.func;
		if ( not func ) then
			func = IMCMD_DefaultFunction;
		end
		if ( Cosmos_RegisterChatCommand ) then
			Cosmos_RegisterChatCommand ( "T"..value.name, value.cmd, func, value.info );
		else
			SlashCmdList["IM_"..value.name] = value.func;
			if ( type(value.cmd) ~= "table" ) then
				local tmp = {};
				table.insert(tmp, value.cmd);
				cmd = tmp;
			end
			for k, v in value.cmd do
				setglobal(format("SLASH_IM_%s%d", value.name, k), v);
			end
		end
	end
end

function UseItem(msg, numberOfTimes)
	if ( ( not msg ) or ( strlen(msg) == 0 ) ) then
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_USE_COMM_INFO);
		return;
	end
	local usedNumberOfTimes = 0;
	if ( not numberOfTimes ) then
		numberOfTimes = 1;
	end
	for i = 1, 19, 1 do
		if (strupper(ImprovedMacro_GetItemName(-1, i)) == strupper(msg)) then
			UseInventoryItem(y);
			usedNumberOfTimes = usedNumberOfTimes + 1;
			if ( usedNumberOfTimes >= numberOfTimes ) then
				return true;
			end
		end
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(ImprovedMacro_GetItemName(i, y)) == strupper(msg)) then
				UseContainerItem(i, y);
				usedNumberOfTimes = usedNumberOfTimes + 1;
				if ( usedNumberOfTimes >= numberOfTimes ) then
					return true;
				end
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_UNKITEM, msg));
	return false;
end

function UseItemByType(msg, numberOfTimes)
	if ( ( not msg ) or ( strlen(msg) == 0 ) ) then
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_USETYPE_COMM_INFO);
		return;
	end
	local usedNumberOfTimes = 0;
	if ( not numberOfTimes ) then
		numberOfTimes = 1;
	end
	local str = msg;
	if ( type(msg) == "table" ) then
		str = msg[1];
	end
	str = strupper(str);
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(Sea.wow.item.classifyInventoryItem(i, y)) == str) then
				UseContainerItem(i, y);
				usedNumberOfTimes = usedNumberOfTimes + 1;
				if ( usedNumberOfTimes >= numberOfTimes ) then
					return true;
				end
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_NOITEM, msg));
	return false;
end

function UseItemByClassification(msg, numberOfTimes)
	if ( ( not msg ) or ( strlen(msg) == 0 ) ) then
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_USECLASSIFICATION_COMM_INFO);
		return;
	end
	local usedNumberOfTimes = 0;
	if ( not numberOfTimes ) then
		numberOfTimes = 1;
	end
	local str = msg;
	if ( type(msg) == "table" ) then
		str = msg[1];
	end
	local classification = strupper(str);
	local tmp = nil;
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			tmp = Sea.wow.item.classifyInventoryItem(i, y);
			if ( tmp ) and ( tmp.classification ) and ( strupper(tmp.classification) == classification ) then
				UseContainerItem(i, y);
				usedNumberOfTimes = usedNumberOfTimes + 1;
				if ( usedNumberOfTimes >= numberOfTimes ) then
					return true;
				end
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_NOITEM, msg));
	return false;
end

function GetCurrentSet()
	local table = { };
	for i = 1, 19, 1 do
		table[i] = ImprovedMacro_GetItemName(-1, i);
	end
	return table;
end

function SaveSet(msg)
	msg = msg + 0;
	if (msg and strlen(msg) > 0 and type(tonumber(msg)) == "number") then
		if (msg >= 1 and msg <= 9) then
			msg = tonumber(msg);
			if (EquipmentSets[UnitName("player")] == nil ) then 
				EquipmentSets[UnitName("player")] = { };
			end
			EquipmentSets[UnitName("player")][msg] = GetCurrentSet();
			DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_SAVED, msg));
		else
			DEFAULT_CHAT_FRAME:AddMessage(IMCMD_SSET_COMM_INFO);
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_SSET_COMM_INFO);
	end
end

function LoadSet(msg)
	local playername = UnitName("player");
	if (msg and strlen(msg) > 0 and type(tonumber(msg)) == "number") then
		msg = tonumber(msg);
		if (msg >= 1 and msg <= 9) then
			if (not EquipmentSets[playername][msg]) then
				DEFAULT_CHAT_FRAME:AddMessage1(format(IMCMD_ERROR_UNKSET, msg));
				return;
			end
			if (EquipmentSets[playername][msg][16] == ImprovedMacro_GetItemName(-1, 17) and EquipmentSets[playername][msg][17] ~= ImprovedMacro_GetItemName(-1, 16)) then
				PickupInventoryItem(16);
				BagItem();
				PickupInventoryItem(17);
				PickupInventoryItem(16);
			elseif (EquipmentSets[playername][msg][16] == ImprovedMacro_GetItemName(-1, 17)) then
				PickupInventoryItem(17);
				PickupInventoryItem(16);
			elseif (EquipmentSets[playername][msg][17] == ImprovedMacro_GetItemName(-1, 16)) then
				PickupInventoryItem(16);
				PickupInventoryItem(17);
			end
			
			for i = 1, 19, 1 do
				if (not EquipmentSets[playername][msg][i] or EquipmentSets[playername][msg][i] == "") then
					PickupInventoryItem(i);
					BagItem();
				elseif (EquipmentSets[playername][msg][i] ~= ImprovedMacro_GetItemName(-1, i)) then
					if (i == 17) then
						EquipOffhand(EquipmentSets[playername][msg][i], 1);
					else
						Equip(EquipmentSets[playername][msg][i]);
					end
				end
			end
			DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_LOADED, msg));
		else
			DEFAULT_CHAT_FRAME:AddMessage(IMCMD_LSET_COMM_INFO);
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_LSET_COMM_INFO);
	end
end

function Equip(msg, quiet)
	if(not msg or msg == "") then
		if (not quiet) then
			DEFAULT_CHAT_FRAME:AddMessage(IMCMD_EQUIP_COMM_INFO);
		end
		return;
	end
	if(CursorHasItem()) then
		if (not quiet) then
			DEFAULT_CHAT_FRAME:AddMessage(IMCMD_ERROR_HOLDING);
		end
		return;
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(ImprovedMacro_GetItemName(i, y)) == strupper(msg)) then
				PickupContainerItem(i,y);
				AutoEquipCursorItem();
				return true;
			end
		end
	end
	
	if (not quiet) then
		DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_UNKITEM, msg));
	end
	return;
end

function EquipOffhand(msg, quiet)
	if(not msg or msg == "") then
		if (not quiet) then
			DEFAULT_CHAT_FRAME:AddMessage(IMCMD_EQUIP_COMM_INFO);
		end
		return;
	end
	if(CursorHasItem()) then
		if (not quiet) then
			DEFAULT_CHAT_FRAME:AddMessage(IMCMD_ERROR_HOLDING);
		end
		return;
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(ImprovedMacro_GetItemName(i, y)) == strupper(msg)) then
				PickupContainerItem(i,y);
				PickupInventoryItem(17);
				if(CursorHasItem()) then
					PickupContainerItem(i,y);
				end
				return true;
			end
		end
	end
	
	if (not quiet) then
		DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_UNKITEM, msg));
	end
	return;
end

function Unequip(msg)
	if(not msg or msg == "") then
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_UNEQUIP_COMM_INFO);
		return false;
	end
	if(CursorHasItem()) then
		DEFAULT_CHAT_FRAME:AddMessage(IMCMD_ERROR_HOLDING);
		return false;
	end
	for i = 1, 19, 1 do
		if (strupper(ImprovedMacro_GetItemName(-1, i)) == strupper(msg)) then
			PickupInventoryItem(i);
			BagItem();
			return;
		end
	end
	if(not quiet) then
		DEFAULT_CHAT_FRAME:AddMessage(format(IMCMD_ERROR_UNKITEM, msg));
	end
end

function BagItem()
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			local texture, itemCount, locked = GetContainerItemInfo(i, y);
			if (not texture) then
				PickupContainerItem(i,y);
				return true;
			end
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(IMCMD_ERROR_SPACE);
	AutoEquipCursorItem();
	return false;
end
