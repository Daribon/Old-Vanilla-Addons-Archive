--[[

SellValueAuto

 Automation of stuff, using SellValue.
 Currently, showing the SellValue InventoryList window on full inventory is supported, 
  as is destroying the cheapest item.
 

History:

v0.06 - 2005-07-09 - sarf

	- Fixed so that /il allows shift-clicked items.

v0.05 - 2005-07-01 - sarf

	- Added included items - items that are always destroyed.
	- Added option to ONLY destroy included items.

v0.04 - 2005-07-01 - sarf

	- Updated toc.
	- Fixed so that it will ONLY do stuff when the inventory is actually full.

v0.03 - 2005-07-01 - sarf

	- Added LootLink support (limited compared to SellValue).
	- Fixed so that SVA is not dependent so much on the SellValue options.
	- Added an emulated /inventorylist show/hide command. Access it by using /svail during normal operation.

v0.02 - 2005-06-28 - sarf

	- Tested with WoW.
	- Now actually loads with WoW! Aaaaamazing!
	- A few nil errors corrected. There is prolly some left, 
	but that is what users are here for, discovering bugs!
	- Button will not appear. All things considered, that is probably a good thing,
	since it would bug out and cause grief and so on. Bleh. I hate coding GUI stuff!
	- This thingy works!

v0.01 - 2005-06-27 - sarf

	- Created.
	- Dynamic slash command parameters.
	- Menu button added to SellValue for most important parameters.
	- Internal testing only. Lots of debugging done. Approximately 4 iterations.

]]--

SELLVALUE_AUTO_VERSION			= "v0.06";

SellValueAuto_Options_Default = {
	popup = false;
	destroyCheapest = false;
	destroyCheapestThreshold = 0;
	onlyDestroyIncluded = false;
	popupIfDestructionThresholdAborted = false;
	showDestruction = true;
	showDestructionLink = true;
	
	exemptItems = SELLVALUE_AUTO_DEFAULT_EXEMPT_ITEMS;
	includedItems = {};
};

SellValueAuto_Options = {
};


function SellValueAuto_OnLoad()
	local f = SellValueAutoFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("UI_ERROR_MESSAGE");

	local sName = "SELLVALUEAUTO";
	SlashCmdList[sName] = SellValueAuto_SlashCommand;
	for k, v in SELLVALUE_AUTO_SLASH_COMMANDS do
		setglobal("SLASH_"..sName..k, v);
	end
	
	sName = "SELLVALUEAUTO_INVENTORYLIST";
	SlashCmdList[sName] = SellValueAuto_SlashCommand_InventoryList;
	if ( not InvList_OnLoad ) then
		for k, v in SELLVALUE_AUTO_SLASH_COMMANDS_IL do
			setglobal("SLASH_"..sName..k, v);
		end
	end
	for k, v in SELLVALUE_AUTO_SLASH_COMMANDS_IL_P do
		setglobal("SLASH_"..sName..k, v);
	end
	
	sName = "SELLVALUEAUTO_INCLUDELIST";
	SlashCmdList[sName] = SellValueAuto_SlashCommand_IncludeList;
	for k, v in SELLVALUE_AUTO_SLASH_COMMANDS_INC_LIST do
		setglobal("SLASH_"..sName..k, v);
	end
	
	
	
	SellValueAuto_Print(SELLVALUE_AUTO_TITLE.." |c00FFFF10"..SELLVALUE_AUTO_VERSION.."|r");
end

function SellValueAuto_SlashCommand_Usage()
	for k, v in SELLVALUE_AUTO_SLASH_HELP do
		SellValueAuto_Print(v);
	end
	local value;
	for k, v in SellValueAuto_Options_Default do
		value = SellValueAuto_Options[k];
		if ( value == nil ) then
			SellValueAuto_Options[k] = v;
			value = v;
		end
		SellValueAuto_Print(string.format(SELLVALUE_AUTO_SLASH_PARAMETER_FORMAT, k, type(v), SellValueAuto_GetStringValue(v), SellValueAuto_GetStringValue(value)));
	end
end

function SellValueAuto_SlashCommand_Alias(cmd)
	if ( not cmd ) or ( strlen(cmd) <= 0 ) then
		SellValueAuto_Print(SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_TEXT);
		for k, v in SELLVALUE_AUTO_SLASH_PARAMETER_ALIASES do
			SellValueAuto_Print(string.format(SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_FORMAT, k, v));
		end
		return;
	else
		local param = string.lower(cmd);
		local found = false;
		for k, v in SELLVALUE_AUTO_SLASH_PARAMETER_ALIASES do
			if ( param == k ) then
				param = v;
				found = true;
				break;
			end
			if ( param == v ) then
				found = true;
				break;
			end
		end
		if ( not found ) then
			SellValueAuto_SlashCommand_Alias();
			return;
		end
		SellValueAuto_Print(string.format(SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_SPECIFIC_TEXT, param));
		for k, v in SELLVALUE_AUTO_SLASH_PARAMETER_ALIASES do
			if ( v == param ) then
				SellValueAuto_Print(string.format(SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_FORMAT_SINGLE, k));
			end
		end
	end
end

function SellValueAuto_SlashCommand_InventoryList_Usage()
	for k, v in SELLVALUE_AUTO_SLASH_COMMANDS_IL_USAGE do
		SellValueAuto_Print(v);
	end
end

function SellValueAuto_SlashCommand_IncludeList(msg)
	if ( not SellValueAuto_Options.includedItems ) then
		SellValueAuto_Options.includedItems = {};
	end
	
	local fmt = SELLVALUE_AUTO_SLASH_COMMANDS_INC_HIDE;
	
	local name = msg;
	
	local linkName = SellValueAuto_GetNameFromString(name);
	if ( linkName ) then
		name = linkName;
	end

	if ( not hide ) then
		fmt = SELLVALUE_AUTO_SLASH_COMMANDS_INC_SHOW;
		SellValueAuto_Options.includedItems[name] = nil;
	else
		SellValueAuto_Options.includedItems[name] = 1;
	end
	
	SellValueAuto_Print(string.format(fmt, name));
end

function SellValueAuto_SlashCommand_InventoryList(msg)
	local hide = true;
	local index = nil;
	for k, v in SELLVALUE_AUTO_SLASH_COMMANDS_IL_LIST_H do
		index = string.find(msg, v);
		if ( index ) then index = index + strlen(v)+1; break; end
	end
	
	if ( not index ) then
		hide = false;
		for k, v in SELLVALUE_AUTO_SLASH_COMMANDS_IL_LIST_S do
			index = string.find(msg, v);
			if ( index ) then index = index + strlen(v)+1; break; end
		end
	end

	if ( not index ) then
		SellValueAuto_SlashCommand_InventoryList_Usage();
		return;
	end

	local name = strsub(msg, index);
	if ( not name ) or ( strlen(name) <= 0 ) then
		SellValueAuto_SlashCommand_InventoryList_Usage();
		return;
	end
	
	if ( not SellValueAuto_Options.exemptItems ) then
		SellValueAuto_Options.exemptItems = SELLVALUE_AUTO_DEFAULT_EXEMPT_ITEMS;
	end
	
	local fmt = SELLVALUE_AUTO_SLASH_COMMANDS_IL_HIDE;
	
	local linkName = SellValueAuto_GetNameFromString(name);
	if ( linkName ) then
		name = linkName;
	end
	
	if ( not hide ) then
		fmt = SELLVALUE_AUTO_SLASH_COMMANDS_IL_SHOW;
		SellValueAuto_Options.exemptItems[name] = nil;
	else
		SellValueAuto_Options.exemptItems[name] = 1;
	end
	
	SellValueAuto_Print(string.format(fmt, name));
end

function SellValueAuto_SlashCommand(msg)
	if ( not msg ) or ( strlen(msg) <= 0 ) then
		SellValueAuto_SlashCommand_Usage();
		return;
	end
	local lmsg = string.lower(msg);
	local index = nil;
	local index2 = nil;
	for k, v in SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS do
		index = string.find(lmsg, v);
		if ( index ) then
			index2 = string.find(msg, " ");
			if ( not index2 ) then
				SellValueAuto_SlashCommand_Alias();
				return;
			else
				if ( index2 > index ) then
					SellValueAuto_SlashCommand_Alias(strsub(msg, index2+1));
					return;
				else
					break;
				end
			end
		end
	end
	index = string.find(msg, " ");
	if ( not index ) then
		SellValueAuto_SlashCommand_Usage();
		return;
	end
	local cmd = strsub(msg, 1, index-1);
	if ( not cmd ) or ( strlen(cmd) <= 0 ) then
		SellValueAuto_SlashCommand_Usage();
		return;
	end
	local lcmd = string.lower(cmd);
	for k, v in SELLVALUE_AUTO_SLASH_PARAMETER_ALIASES do
		if ( lcmd == k ) then
			cmd = v;
			break;
		end
	end
	if ( SellValueAuto_Options_Default[cmd] == nil ) and ( SellValueAuto_Options[cmd] == nil ) then
		SellValueAuto_SlashCommand_Usage();
		return;
	end
	local param = strsub(msg, index+1);
	if ( not param ) or ( strlen(param) <= 0 ) then
		SellValueAuto_SlashCommand_Usage();
		return;
	end
	for k, v in SELLVALUE_AUTO_SLASH_VALUE_DEFAULT do
		if ( param == v ) then
			param = SellValueAuto_Options_Default[cmd];
			break;
		end
	end
	local curType = type(SellValueAuto_Options_Default[cmd]);
	if ( curType == "boolean" ) then
		if ( type(param) ~= curType ) then
			local lparam = string.lower(param);
			local value = nil;
			for k, v in SELLVALUE_AUTO_SLASH_TYPE_BOOLEAN_TRUE do
				if ( lparam == v ) then
					value = true;
					break;
				end
			end
			if ( value == nil ) then
				for k, v in SELLVALUE_AUTO_SLASH_TYPE_BOOLEAN_FALSE do
					if ( lparam == v ) then
						value = false;
						break;
					end
				end
			end
			if ( value == nil ) then
				SellValueAuto_Print(SELLVALUE_AUTO_SLASH_PARAM_INVALID_TYPE);
				return;
			else
				param = value;
			end
		end
	elseif ( curType == "number" ) then
		if ( type(param) ~= curType ) then
			local value = tonumber(param);
			if ( value == nil ) then
				SellValueAuto_Print(SELLVALUE_AUTO_SLASH_PARAM_INVALID_TYPE);
				return;
			else
				param = value;
			end
		end
	elseif ( curType == "string" ) then
		if ( type(param) ~= curType ) then
			SellValueAuto_Print(SELLVALUE_AUTO_SLASH_PARAM_INVALID_TYPE);
			return;
		end
	else
		if ( curType == nil ) then curType = "<nil>"; end
		SellValueAuto_Print(SELLVALUE_AUTO_SLASH_PARAM_INVALID_TYPE.." DBG: "..curType);
		return;
	end
	SellValueAuto_Options[cmd] = param;
	SellValueAuto_Print(string.format(SELLVALUE_AUTO_SLASH_PARAMETER_SET, cmd, SellValueAuto_GetStringValue(param)));
end

function SellValueAuto_GetStringValue(value)
	if ( type(value) == "boolean" ) then
		if ( value ) then
			value = SELLVALUE_AUTO_SLASH_VALUE_BOOLEAN_TRUE;
		else
			value = SELLVALUE_AUTO_SLASH_VALUE_BOOLEAN_FALSE;
		end
	elseif ( type(value) == "number" ) then
		value = value.."";
	elseif ( type(value) == "userdata" ) then
		value = "<userdata>";
	elseif ( type(value) == "nil" ) then
		value = "<nil>";
	end
	return value;
end

function SellValueAuto_ShouldShow()
	if ( SellValueAuto_Options.popup ) then
		return true;
	end
	return false;
end

function SellValueAuto_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in SellValueAuto_Options_Default do
			if ( SellValueAuto_Options[k] == nil ) then
				SellValueAuto_Options[k] = v;
			end
		end
		SellValueAutoButtonText:SetText(SELLVALUE_AUTO_BUTTON_TEXT);
		return;
	end
	if ( event == "UI_ERROR_MESSAGE" ) then
		local shouldShow = SellValueAuto_ShouldShow();
		if ( arg1 == ERR_INV_FULL ) then
			if ( not SellValueAuto_IsOutOfSpace() ) then
				return;
			end
			if ( SellValueAuto_Options.destroyCheapest ) then
				if ( SellValueAuto_DestroyCheapest() == -1 ) then
					if ( SellValueAuto_Options.popupIfDestructionThresholdAborted ) then
						shouldShow = true;
					end
				end
			end
			if ( shouldShow ) then
				SellValueAuto_ShowInventoryList();
			end
		end
		return;
	end
end

function SellValueAuto_ShowInventoryList()
	if ( InvListFrame ) and ( InvListFrame.IsVisible ) and ( InvListFrame:IsVisible() ) then
		if ( InvList_Toggle ) then
			InvList_Toggle();
		end
	end
	if ( InvList_Toggle ) then
		InvList_Toggle();
	end
end

function SellValueAuto_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0.1);
end

function SellValueAutoButton_OnClick()
	ToggleDropDownMenu(1, nil, SellValueAutoDropDown);
end

-- My attempt to make it somewhat independent of the SellValue item format.
-- will return nil (no item found) or a table.
--  Table has 4 values - n (name), b (bag), s (slot) and v (value - optional)
function SellValueAuto_GetCheapestItem()
	if ( SellValues ) then
		return SellValueAuto_GetCheapestItem_SellValue();
	elseif ( ItemLinks ) then
		return SellValueAuto_GetCheapestItem_LootLink();
	else
		return nil;
	end
end


-- Stolen from LootLink.
function SellValueAuto_LootLink_NameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end

function SellValueAuto_GetNameFromString(str)
	local name = SellValueAuto_LootLink_NameFromLink(str);
	if ( name ) then
		return name;
	end
	if ( type(str) == "string" ) then
		if ( strsub(str, 1, 1) == "[" ) then
			str = strsub(str, 2);
		end
		local len = strlen(str);
		if ( strsub(str, len, 1) == "]" ) then
			str = strsub(str, 1, len-1);
		end
		return str;
	else
		return nil;
	end
end


function SellValueAuto_IsOutOfSpace()
	for bag=0,NUM_BAG_FRAMES,1 do
		for slot=1,GetContainerNumSlots(bag),1 do
			link = GetContainerItemLink(bag, slot);
			name = SellValueAuto_LootLink_NameFromLink(link);
			if ( not name ) or ( strlen(name) <= 0 ) then
				return false;
			end
		end
	end
	return true;
end

function SellValueAuto_GetCheapestItem_LootLink()
	local cheapestItem = nil;
	local cheapestItemBag, cheapestItemSlot = nil, nil;
	local cheapestItemPrice = -1;
	local arr = nil;
	
	local link, name = nil, nil;
	local arrData = nil;

	local itemName, itemMoney, stackCount, quality;
	for bag=0,NUM_BAG_FRAMES,1 do
		for slot=1,GetContainerNumSlots(bag),1 do
			link = GetContainerItemLink(bag, slot);
			name = SellValueAuto_LootLink_NameFromLink(link);
			if ( name ) and ( name ~= "" ) then
				if ( SellValueAuto_Options.includedItems[name] ) then
				    if ItemLinks then 
						arrData = ItemLinks[name];
						if ( arrData ) then
				    		cheapestItem = arrData;
				    		cheapestItem.n = name;
				    		cheapestItemBag = bag;
				    		cheapestItemSlot = slot;
				    		cheapestItemPrice = 1;
				    		break;
						end
					end
				end
			  	_,stackCount,_,quality = GetContainerItemInfo(bag,slot);
				
				if ( not SellValueAuto_Options.onlyDestroyIncluded ) then
				    if ItemLinks then 
				    	arrData = ItemLinks[name];
				    	if ( arrData ) then
				    		itemMoney = arrData.p;
				    	end
				    else
				    	arrData = nil;
				    	itemMoney = nil;
				    end
				else
					itemMoney = nil;
				end
			    if ( SellValueAuto_Options.exemptItems ) and ( SellValueAuto_Options.exemptItems[name] ) then
			    	itemMoney = nil;
			    end
			            
			    if itemMoney then
			    	itemMoney = itemMoney * stackCount;
			    end
			        
			    if (itemMoney and itemMoney > 0) then
			    	if ( not cheapestItem ) or ( cheapestItemPrice > itemMoney ) then
			    		cheapestItem = arrData;
			    		cheapestItem.n = name;
			    		cheapestItemBag = bag;
			    		cheapestItemSlot = slot;
			    		cheapestItemPrice = itemMoney;
			    	end
				end
			end  -- if itemname
		end  -- for slot
	end  -- for bag
	
	if ( cheapestItem ) then
		arr = {};
		arr.n = cheapestItem.n;
		arr.b = cheapestItemBag;
		arr.s = cheapestItemSlot;
		arr.v = cheapestItem.p;
	end
	return arr;
end

function SellValueAuto_GetCheapestItem_SellValue()
	local myList = {};
	local arr = nil;

	local itemName, itemMoney, stackCount, quality;
	for bag=0,NUM_BAG_FRAMES,1 do
		for slot=1,GetContainerNumSlots(bag),1 do
		  itemName = InvList_GetItemName(bag, slot);
		  if itemName ~= "" then              
		  	_,stackCount,_,quality = GetContainerItemInfo(bag,slot);
		
		    if SellValues then 
		    	itemMoney = SellValues[InvList_ShortenItemName(itemName)];
		    else
		      itemMoney = nil;
		    end
		            
		    if itemMoney then
		      itemMoney = itemMoney * stackCount;
		    end
		        
		        --[[ Test width code 
		        if itemName == "Fishing Pole" then
		            itemName = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ";
		            itemMoney = 99999;
		        end
		        --]]

			if ( SellValueAuto_Options.exemptItems ) and ( SellValueAuto_Options.exemptItems[itemName] ) then
				itemMoney = nil;
			end
		        
		    if (itemMoney and itemMoney > 0) and 
		      not (InvList_HiddenItems and InvList_HiddenItems[itemName]) then
		      table.insert(myList, { name = itemName, money = itemMoney, 
		        bag = bag, slot = slot, count = stackCount, quality = quality });
		    end
		  end  -- if itemname
		end  -- for slot
	end  -- for bag
	
	table.sort(myList, InvList_SortByMoneyASC);

	local cheapestItem = myList[1];
	if ( cheapestItem ) then
		arr = {};
		arr.n = cheapestItem.name;
		arr.b = cheapestItem.bag;
		arr.s = cheapestItem.slot;
		arr.v = cheapestItem.money;
	end
	return arr;
end

-- Will destroy the cheapest item UNLESS a) an item is held in the cursor 
--  or b) a destruction threshold has been specified and the value of the 
--   item exceeds the threshold
function SellValueAuto_DestroyCheapest()
	local item = SellValueAuto_GetCheapestItem();
	if ( item ) and ( item.n ) and ( item.b ) and ( item.s ) then
		str = nil;
		if ( SellValueAuto_Options.showDestruction ) then
			str = item.n;
			if ( SellValueAuto_Options.showDestructionLink ) then
				local link = GetContainerItemLink(item.b, item.s);
				if ( link ) then
					str = link;
				end
			end
		end
		if ( item.v ) and ( SellValueAuto_Options.destroyCheapestThreshold ) and ( SellValueAuto_Options.destroyCheapestThreshold > 0 ) then
			if ( item.v > SellValueAuto_Options.destroyCheapestThreshold ) then
				if ( str ) then
					SellValueAuto_Print(string.format(SELLVALUE_AUTO_DESTRUCT_VALUE_ABORTED, str));
				end
				return -1;
			end
		end
		if ( CursorHasItem() ) then
			if ( str ) then
				SellValueAuto_Print(string.format(SELLVALUE_AUTO_DESTRUCT_ITEM_ABORTED, str));
			end
			return 0;
		end
		PickupContainerItem(item.b, item.s);
		DeleteCursorItem();
		if ( str ) then
			SellValueAuto_Print(string.format(SELLVALUE_AUTO_DESTRUCT_COMPLETE, str));
		end
		return 1;
	end
	return 0;
end

function SellValueAutoButton_OnLoad()
end

function SellValueAutoDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, SellValueAutoDropDown_Initialize, "MENU");
end

function SellValueAutoDropDown_MenuItemOnClick()
	local value = this.value;
	if ( value ) then
		local currentType = type(SellValueAuto_Options_Default[value]);
		if ( currentType == "boolean" ) then
			if ( SellValueAuto_Options[value] ) then
				SellValueAuto_Options[value] = false;
			else
				SellValueAuto_Options[value] = true;
			end
		end
	end
end

function SellValueAutoDropDown_Initialize()
	UIDropDownMenu_SetText(SELLVALUE_AUTO_MENU_TITLE, SellValueAutoDropDown);
	local info = {};
	local currentValue = nil;

	for index, value in SELLVALUE_AUTO_MENU do
		info.text = value;
		info.value = index;
		info.func = SellValueAutoDropDown_MenuItemOnClick;
		
		info.keepShownOnClick = nil;
		
		currentType = type(SellValueAuto_Options_Default[index]);
		currentValue = SellValueAuto_Options[index];
		
		if ( currentType == "boolean" ) then
			if ( currentValue == true ) then
				info.checked = 1;
			else
				info.checked = nil;
			end
		else
			info.checked = nil;
		end
		info.textR = 1;
		info.textG = 1;
		info.textB = 1;
		
		UIDropDownMenu_AddButton(info);
	end
end
