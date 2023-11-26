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
		
		
		this.editBox:SetText(arg1);
		ChatEdit_SendText(this.editBox);
		ChatEdit_OnEscapePressed(this.editBox);
		return;
	end
	ImprovedMacro_Saved_ChatFrame_OnEvent(event);
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
	if ( Cosmos_RegisterChatCommand ) then
		IMCMD_OnLoad();
	end
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

------------------------------------------
-----
----- /Commands
-----
------------------------------------------

EquipmentSets = { };
RegisterForSave("EquipmentSets");

function IMCMD_OnLoad()
	id = "TEQUIP";
	func = function(msg)
		Equip(msg);
	end
	Cosmos_RegisterChatCommand ( id, IMCMD_EQUIP_COMM, func, IMCMD_EQUIP_COMM_INFO );
	id = "TUNEQUIP";
	func = function(msg)
		Unequip(msg);
	end
	Cosmos_RegisterChatCommand ( id, IMCMD_UNEQUIP_COMM, func, IMCMD_UNEQUIP_COMM_INFO );
	id = "TUSE";
	func = function(msg)
		UseItem(msg);
	end
	Cosmos_RegisterChatCommand ( id, IMCMD_USE_COMM, func, IMCMD_USE_COMM_INFO );
	id = "TUSETYPE";
	func = function(msg)
		UseItemByType(msg);
	end
	Cosmos_RegisterChatCommand ( id, IMCMD_USETYPE_COMM, func, IMCMD_USETYPE_COMM_INFO );
	id = "TSEQUIP";
	func = function(msg)
		SaveSet(msg);
	end
	Cosmos_RegisterChatCommand ( id, IMCMD_SSET_COMM, func, IMCMD_SSET_COMM_INFO );
	id = "TLEQUIP";
	func = function(msg)
		LoadSet(msg);
	end
	Cosmos_RegisterChatCommand ( id, IMCMD_LSET_COMM, func, IMCMD_LSET_COMM_INFO );
end

function UseItem(msg, numberOfTimes)
	if ( ( not msg ) or ( strlen(msg) == 0 ) ) then
		Print(IMCMD_USE_COMM_INFO);
		return;
	end
	local usedNumberOfTimes = 0;
	if ( not numberOfTimes ) then
		numberOfTimes = 1;
	end
	for i = 1, 19, 1 do
		if (strupper(GetItemName(-1, i)) == strupper(msg)) then
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
			if (strupper(GetItemName(i, y)) == strupper(msg)) then
				UseContainerItem(i, y);
				usedNumberOfTimes = usedNumberOfTimes + 1;
				if ( usedNumberOfTimes >= numberOfTimes ) then
					return true;
				end
			end
		end
	end
	Print(format(IMCMD_ERROR_UNKITEM, msg));
	return false;
end

function UseItemByType(msg, numberOfTimes)
	if ( ( not msg ) or ( strlen(msg) == 0 ) ) then
		Print(IMCMD_USETYPE_COMM_INFO);
		return;
	end
	local usedNumberOfTimes = 0;
	if ( not numberOfTimes ) then
		numberOfTimes = 1;
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(ClassifyItem(i, y)) == strupper(msg)) then
				UseContainerItem(i, y);
				usedNumberOfTimes = usedNumberOfTimes + 1;
				if ( usedNumberOfTimes >= numberOfTimes ) then
					return true;
				end
			end
		end
	end
	Print(format(IMCMD_ERROR_NOITEM, msg));
	return false;
end

function GetCurrentSet()
	local table = { };
	for i = 1, 19, 1 do
		table[i] = GetItemName(-1, i);
	end
	return table;
end

function SaveSet(msg)
	msg = msg + 0;
	if (type(msg) == "number" and msg >= 1 and msg <= 4) then
		if (EquipmentSets[UnitName("player")] == nil ) then 
			EquipmentSets[UnitName("player")] = { };
		end
		EquipmentSets[UnitName("player")][msg] = GetCurrentSet();
		Print(format(IMCMD_ERROR_SAVED, msg));
	else
		Print(IMCMD_SSET_COMM_INFO);
	end
end

function LoadSet(msg)
	msg = msg + 0;
	local playername = UnitName("player");
	if (type(msg) == "number" and msg >= 1 and msg <= 4) then
		for i = 1, 19, 1 do
			if (not EquipmentSets[playername][msg][i] or EquipmentSets[playername][msg][i] == "") then 
				PickupInventoryItem(i);
				BagItem();
			elseif (EquipmentSets[playername][msg][i] ~= GetItemName(-1, i)) then
				Equip(EquipmentSets[playername][msg][i]);
			end
		end
		Print(format(IMCMD_ERROR_LOADED, msg));
	else
		Print(IMCMD_LSET_COMM_INFO);
	end
end

function Equip(msg, quiet)
	if(not msg or msg == "") then
		if (not quiet) then
			Print(IMCMD_EQUIP_COMM_INFO);
		end
		return;
	end
	if(CursorHasItem()) then
		if (not quiet) then
			Print(IMCMD_ERROR_HOLDING);
		end
		return;
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(GetItemName(i, y)) == strupper(msg)) then
				PickupContainerItem(i,y);
				AutoEquipCursorItem();
				return true;
			end
		end
	end
	
	if (not quiet) then
		Print(format(IMCMD_ERROR_UNKITEM, msg));
	end
	return;
end

function Unequip(msg)
	if(not msg or msg == "") then
		Print(IMCMD_UNEQUIP_COMM_INFO);
		return false;
	end
	if(CursorHasItem()) then
		Print(IMCMD_ERROR_HOLDING);
		return false;
	end
	for i = 1, 19, 1 do
		if (strupper(GetItemName(-1, i)) == strupper(msg)) then
			PickupInventoryItem(i);
			BagItem();
			return;
		end
	end
	if(not quiet) then
		Print(format(IMCMD_ERROR_UNKITEM, msg));
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
	Print(IMCMD_ERROR_SPACE);
	AutoEquipCursorItem();
	return false;
end
