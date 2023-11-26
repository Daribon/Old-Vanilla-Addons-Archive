--[[
	All In One Inventory

	By sarf

	This mod allows you to view and interact with your inventory without caring about bags.

	Thanks goes to SirBender for the background conversion and other stuff! :)
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
ALLINONEINVENTORY_MAX_ID = 109;
ALLINONEINVENTORY_WIDTH = 350;

ALLINONEINVENTORY_NUM_COLUMNS = 8;
ALLINONEINVENTORY_COLUMNS_MIN = 2;
ALLINONEINVENTORY_COLUMNS_MAX = 16;
ALLINONEINVENTORY_BASE_HEIGHT = 64;
ALLINONEINVENTORY_ROW_HEIGHT = 40;

ALLINONEINVENTORY_BASE_WIDTH = 26;
ALLINONEINVENTORY_COL_WIDTH = 40;

ALLINONEINVENTORY_SCHEDULENAME_UPDATE = "AllInOneInventory_UpdateBags";
ALLINONEINVENTORY_MAXIMUM_NUMBER_OF_BUTTONS = 109;
ALLINONEINVENTORY_MINIMUM_TIME_BETWEEN_UPDATES = 0.2;

-- Variables
AllInOneInventory_Enabled = 0;
AllInOneInventory_ReplaceBags = 0;
AllInOneInventory_IncludeShotBags = 1;

AllInOneInventory_Columns = ALLINONEINVENTORY_NUM_COLUMNS;

AllInOneInventory_Saved_UseContainerItem = nil;
AllInOneInventory_Saved_ToggleBag = nil;
AllInOneInventory_Saved_OpenBag = nil;
AllInOneInventory_Saved_CloseBag = nil;
AllInOneInventory_Saved_ToggleBackpack = nil;
AllInOneInventory_Saved_CloseBackpack = nil;
AllInOneInventory_Saved_OpenBackpack = nil;
AllInOneInventory_Saved_BagSlotButton_OnClick = nil;
AllInOneInventory_Saved_BagSlotButton_OnDrag = nil;
AllInOneInventory_Saved_BackpackButton_OnClick = nil;
AllInOneInventory_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function AllInOneInventoryScriptFrame_OnLoad()
	AllInOneInventory_Register();
	AllInOneInventory_Setup_Hooks(1);
end

-- registers the mod with Cosmos
function AllInOneInventory_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( AllInOneInventory_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY",
			"SECTION",
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER),
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_HEADER",
			"SEPARATOR",
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER),
			TEXT(ALLINONEINVENTORY_CONFIG_HEADER_INFO)
		);
		--[[
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_ENABLED",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_ENABLED),
			TEXT(ALLINONEINVENTORY_ENABLED_INFO),
			AllInOneInventory_Toggle_Enabled_NoChat,
			AllInOneInventory_Enabled
		);
		]]--
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_REPLACEBAGS",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_REPLACEBAGS),
			TEXT(ALLINONEINVENTORY_REPLACEBAGS_INFO),
			AllInOneInventory_Toggle_ReplaceBags_NoChat,
			AllInOneInventory_ReplaceBags
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_INCLUDE_SHOTBAGS",
			"CHECKBOX",
			TEXT(ALLINONEINVENTORY_INCLUDE_SHOTBAGS),
			TEXT(ALLINONEINVENTORY_INCLUDE_SHOTBAGS_INFO),
			AllInOneInventory_Toggle_IncludeShotBags_NoChat,
			AllInOneInventory_IncludeShotBags
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_RESETPOSITION",
			"BUTTON",
			TEXT(ALLINONEINVENTORY_RESETPOSITION),
			TEXT(ALLINONEINVENTORY_RESETPOSITION_INFO),
			AllInOneInventoryFrame_ResetButton,
			0,
			0,
			0,
			0,
			ALLINONEINVENTORY_RESETPOSITION_NAME
		);
		Cosmos_RegisterConfiguration(
			"COS_ALLINONEINVENTORY_COLUMNS",
			"SLIDER",
			TEXT(ALLINONEINVENTORY_COLUMNS),
			TEXT(ALLINONEINVENTORY_COLUMNS_INFO),
			AllInOneInventory_Change_Columns_NoChat,
			1,
			AllInOneInventory_Columns,
			ALLINONEINVENTORY_COLUMNS_MIN,
			ALLINONEINVENTORY_COLUMNS_MAX,
			"",
			1,
			1,
			TEXT(ALLINONEINVENTORY_COLUMNS_APPEND)
		);
		if ( Cosmos_RegisterChatCommand ) then
			local AllInOneInventoryMainCommands = {"/allinoneinventory","/aioi"};
			Cosmos_RegisterChatCommand (
				"ALLINONEINVENTORY_MAIN_COMMANDS", -- Some Unique Group ID
				AllInOneInventoryMainCommands, -- The Commands
				AllInOneInventory_Main_ChatCommandHandler,
				ALLINONEINVENTORY_CHAT_COMMAND_INFO -- Description String
			);
		end
		if ( Cosmos_RegisterButton ) then 
			Cosmos_RegisterButton(
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER),
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER_SHORT_INFO), 
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER_INFO), 
				TEXT(ALLINONEINVENTORY_CONFIG_HEADER_TEXTURE), 
				ToggleAllInOneInventoryFrame
			);
		end
		AllInOneInventory_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function AllInOneInventory_Register()
	if ( Cosmos_RegisterConfiguration ) then
		AllInOneInventory_Register_Cosmos();
	else
		SlashCmdList["ALLINONEINVENTORYSLASHMAIN"] = AllInOneInventory_Main_ChatCommandHandler;
		SLASH_ALLINONEINVENTORYSLASHMAIN1 = "/allinoneinventory";
		SLASH_ALLINONEINVENTORYSLASHMAIN2 = "/aioi";
		this:RegisterEvent("VARIABLES_LOADED");
	end
end

function AllInOneInventory_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end

function AllInOneInventory_GetItemInfo(id)
	local bag, slot = AllInOneInventory_GetIdAsBagSlot(id);
	return GetContainerItemInfo(bag, slot);
end

function AllInOneInventory_GetBags()
	local bag = 0;
	local bags = {};
	for bag = 0, 4 do
		if ( ( AllInOneInventory_IncludeShotBags == 1 ) or ( not AllInOneInventory_IsShotBag(bag) ) ) then
			bags[bag] = GetContainerNumSlots(bag);
		end
	end
	return bags;
end

function AllInOneInventory_GetBagsTotalSlots()
	local slots = 0;
	for bag = 0, 4 do
		if ( ( AllInOneInventory_IncludeShotBags == 1 ) or ( not AllInOneInventory_IsShotBag(bag) ) ) then
			slots = slots + GetContainerNumSlots(bag);
		end
	end
	return slots;
end

function AllInOneInventory_GetIdAsBagSlot(id)
	local bagSlots = AllInOneInventory_GetBags();
	local leftId = id;
	local curSlots = 0;
	for bag = 0, 4 do
		curSlots = bagSlots[bag];
		if ( not curSlots ) then
			curSlots = 0;
		end
		if ( leftId - curSlots <= 0 ) then
			return bag, leftId;
		else
			leftId = leftId - curSlots;
		end
	end
	return -1, -1;
end

-- Handles chat - e.g. slashcommands - enabling/disabling the AllInOneInventory
function AllInOneInventory_Main_ChatCommandHandler(msg)
	
	local func = AllInOneInventory_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		AllInOneInventory_Print(ALLINONEINVENTORY_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = AllInOneInventory_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = AllInOneInventory_Toggle_Enabled;
	elseif ( ( ( strfind( commandName, "toggle" ) ) ) ) then
		func = ToggleAllInOneInventoryFrame;
		toggleFunc = false;
	elseif ( ( strfind( commandName, "show" ) ) ) then
		func = OpenAllInOneInventoryFrame;
		toggleFunc = false;
	elseif ( ( strfind( commandName, "hide" ) ) ) then
		func = CloseAllInOneInventoryFrame;
		toggleFunc = false;
	elseif ( ( strfind( commandName, "replacebag" ) ) or ( ( strfind( commandName, "hijackbag" ) ) ) ) then
		func = AllInOneInventory_Toggle_ReplaceBags;
	elseif ( strfind( commandName, "include" ) ) then
		func = AllInOneInventory_Toggle_IncludeShotBags;
	elseif ( strfind( commandName, "reset" ) ) then
		func = AllInOneInventoryFrame_ResetButton;
		func();
		AllInOneInventory_Print(TEXT(ALLINONEINVENTORY_CHAT_RESETPOSITION));
		return;
	elseif ( ( strfind( commandName, "setcols" ) ) or ( ( strfind( commandName, "cols" ) ) ) or ( ( strfind( commandName, "column" ) ) ) ) then
		func = AllInOneInventory_Change_Columns;
		toggleFunc = false;
		local cols = 0;
		cols, params = AllInOneInventory_Extract_NextParameter(params);
		if ( ( not cols ) or ( strlen(cols) <= 0 ) ) then
			AllInOneInventory_Print(ALLINONEINVENTORY_CHAT_COMMAND_USAGE);
			return;
		else
			return func(1, cols);
		end
	else
		AllInOneInventory_Print(ALLINONEINVENTORY_CHAT_COMMAND_USAGE);
		return;
	end
	
	if ( toggleFunc ) then
		-- Toggle appropriately
		if ( (string.find(params, 'on')) or ((string.find(params, '1')) and (not string.find(params, '-1')) ) ) then
			func(1);
		else
			if ( (string.find(params, 'off')) or (string.find(params, '0')) ) then
				func(0);
			else
				func(-1);
			end
		end
	else
		func();
	end
end

function UseAllInOneInventoryItem(id)
	local b,s = AllInOneInventory_GetIdAsBagSlot(bag);
	if ( ( b > -1 ) and ( s > -1 ) ) then
		return AllInOneInventory_Saved_UseContainerItem(b, s);
	end
	return false;
end

-- Does things with the hooked function
function AllInOneInventory_UseContainerItem(bag, slot)
	if ( not slot ) then
		local b,s = AllInOneInventory_GetIdAsBagSlot(bag);
		if ( ( b > -1 ) and ( s > -1 ) ) then
			return AllInOneInventory_Saved_UseContainerItem(b, s);
		end
	end
	return AllInOneInventory_Saved_UseContainerItem(bag, slot);
end

function AllInOneInventory_ToggleBackpack()
	if ( AllInOneInventory_ReplaceBags == 1 ) then
		ToggleAllInOneInventoryFrame();
		return;
	end
	AllInOneInventory_Saved_ToggleBackpack()
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventory_BagSlotButton_OnClick()
	AllInOneInventory_Saved_BagSlotButton_OnClick()
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventory_BagSlotButton_OnDrag()
	AllInOneInventory_Saved_BagSlotButton_OnDrag()
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventory_BackpackButton_OnClick()
	AllInOneInventory_Saved_BackpackButton_OnClick()
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventory_OpenBackpack()
	if ( AllInOneInventory_ReplaceBags == 1 ) then
		OpenAllInOneInventoryFrame();
		return;
	end
	AllInOneInventory_Saved_OpenBackpack();
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventory_CloseBackpack()
	if ( AllInOneInventory_ReplaceBags == 1 ) then
		CloseAllInOneInventoryFrame();
		return;
	end
	AllInOneInventory_Saved_CloseBackpack();
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventory_IsShotBag(bag) 
	if ( bag < 0 ) or ( bag > 4 ) then
		return false;
	end
	local name = "MainMenuBarBackpackButton";
	if ( bag > 0 ) then
		name = "CharacterBag"..(bag-1).."Slot";
	end
	local objCount = getglobal(name.."Count");
	if ( objCount ) then
		local tmp = objCount:GetText();
		if ( ( tmp ) and ( strlen(tmp) > 0) ) then
			return true;
		end
	end
	return false;
end

function AllInOneInventory_ShouldOverrideBag(bag)
	if ( AllInOneInventory_ReplaceBags == 1 ) then
		if ( ( bag >= 0 ) and ( bag <= 4 ) ) then
			if ( ( AllInOneInventory_IncludeShotBags == 1 ) or ( not AllInOneInventory_IsShotBag(bag) ) ) then
				return true;
			else
				return false;
			end
		else
			return false;
		end
	else
		return false;
	end
end

function AllInOneInventory_ToggleBag(bag)
	if ( AllInOneInventory_ShouldOverrideBag(bag) ) then
		ToggleAllInOneInventoryFrame();
		return;
	else
		AllInOneInventory_Saved_ToggleBag(bag);
		AllInOneInventory_UpdateBagState();
	end
end

function AllInOneInventory_CloseBag(bag)
	if ( AllInOneInventory_ShouldOverrideBag(bag) ) then
		return;
	else
		AllInOneInventory_Saved_CloseBag(bag);
		AllInOneInventory_UpdateBagState();
	end
end

function AllInOneInventory_OpenBag(bag)
	if ( AllInOneInventory_ShouldOverrideBag(bag) ) then
		return;
	else
		AllInOneInventory_Saved_OpenBag(bag)
		AllInOneInventory_UpdateBagState();
	end
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function AllInOneInventory_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( UseContainerItem ~= AllInOneInventory_UseContainerItem ) and (AllInOneInventory_Saved_UseContainerItem == nil) ) then
			AllInOneInventory_Saved_UseContainerItem = UseContainerItem;
			UseContainerItem = AllInOneInventory_UseContainerItem;
		end
		if ( ( ToggleBag ~= AllInOneInventory_ToggleBag ) and (AllInOneInventory_Saved_ToggleBag == nil) ) then
			AllInOneInventory_Saved_ToggleBag = ToggleBag;
			ToggleBag = AllInOneInventory_ToggleBag;
		end
		if ( ( CloseBag ~= AllInOneInventory_CloseBag ) and (AllInOneInventory_Saved_CloseBag == nil) ) then
			AllInOneInventory_Saved_CloseBag = CloseBag;
			CloseBag = AllInOneInventory_CloseBag;
		end
		if ( ( OpenBag ~= AllInOneInventory_OpenBag ) and (AllInOneInventory_Saved_OpenBag == nil) ) then
			AllInOneInventory_Saved_OpenBag = OpenBag;
			OpenBag = AllInOneInventory_OpenBag;
		end
		if ( ( ToggleBackpack ~= AllInOneInventory_ToggleBackpack ) and (AllInOneInventory_Saved_ToggleBackpack == nil) ) then
			AllInOneInventory_Saved_ToggleBackpack = ToggleBackpack;
			ToggleBackpack = AllInOneInventory_ToggleBackpack;
		end
		if ( ( CloseBackpack ~= AllInOneInventory_CloseBackpack ) and (AllInOneInventory_Saved_CloseBackpack == nil) ) then
			AllInOneInventory_Saved_CloseBackpack = CloseBackpack;
			CloseBackpack = AllInOneInventory_CloseBackpack;
		end
		if ( ( OpenBackpack ~= AllInOneInventory_OpenBackpack ) and (AllInOneInventory_Saved_OpenBackpack == nil) ) then
			AllInOneInventory_Saved_OpenBackpack = OpenBackpack;
			OpenBackpack = AllInOneInventory_OpenBackpack;
		end
		if ( ( BagSlotButton_OnClick ~= AllInOneInventory_BagSlotButton_OnClick ) and (AllInOneInventory_Saved_BagSlotButton_OnClick == nil) ) then
			AllInOneInventory_Saved_BagSlotButton_OnClick = BagSlotButton_OnClick;
			BagSlotButton_OnClick = AllInOneInventory_BagSlotButton_OnClick;
		end
		if ( ( BagSlotButton_OnDrag ~= AllInOneInventory_BagSlotButton_OnDrag ) and (AllInOneInventory_Saved_BagSlotButton_OnDrag == nil) ) then
			AllInOneInventory_Saved_BagSlotButton_OnDrag = BagSlotButton_OnDrag;
			BagSlotButton_OnDrag = AllInOneInventory_BagSlotButton_OnDrag;
		end
		if ( ( BackpackButton_OnClick ~= AllInOneInventory_BackpackButton_OnClick ) and (AllInOneInventory_Saved_BackpackButton_OnClick == nil) ) then
			AllInOneInventory_Saved_BackpackButton_OnClick = BackpackButton_OnClick;
			BackpackButton_OnClick = AllInOneInventory_BackpackButton_OnClick;
		end
	else
		if ( UseContainerItem == AllInOneInventory_UseContainerItem) then
			UseContainerItem = AllInOneInventory_Saved_UseContainerItem;
			AllInOneInventory_Saved_UseContainerItem = nil;
		end
		if ( ToggleBag == AllInOneInventory_ToggleBag) then
			ToggleBag = AllInOneInventory_Saved_ToggleBag;
			AllInOneInventory_Saved_ToggleBag = nil;
		end
		if ( CloseBag == AllInOneInventory_CloseBag) then
			CloseBag = AllInOneInventory_Saved_CloseBag;
			AllInOneInventory_Saved_CloseBag = nil;
		end
		if ( OpenBag == AllInOneInventory_OpenBag) then
			OpenBag = AllInOneInventory_Saved_OpenBag;
			AllInOneInventory_Saved_OpenBag = nil;
		end
		if ( ToggleBackpack == AllInOneInventory_ToggleBackpack) then
			ToggleBackpack = AllInOneInventory_Saved_ToggleBackpack;
			AllInOneInventory_Saved_ToggleBackpack = nil;
		end
		if ( CloseBackpack == AllInOneInventory_CloseBackpack) then
			CloseBackpack = AllInOneInventory_Saved_CloseBackpack;
			AllInOneInventory_Saved_CloseBackpack = nil;
		end
		if ( OpenBackpack == AllInOneInventory_OpenBackpack) then
			OpenBackpack = AllInOneInventory_Saved_OpenBackpack;
			AllInOneInventory_Saved_OpenBackpack = nil;
		end
		if ( BagSlotButton_OnClick == AllInOneInventory_BagSlotButton_OnClick) then
			BagSlotButton_OnClick = AllInOneInventory_Saved_BagSlotButton_OnClick;
			AllInOneInventory_Saved_BagSlotButton_OnClick = nil;
		end
		if ( BagSlotButton_OnDrag == AllInOneInventory_BagSlotButton_OnDrag) then
			BagSlotButton_OnDrag = AllInOneInventory_Saved_BagSlotButton_OnDrag;
			AllInOneInventory_Saved_BagSlotButton_OnDrag = nil;
		end
		if ( BackpackButton_OnClick == AllInOneInventory_BackpackButton_OnClick) then
			BackpackButton_OnClick = AllInOneInventory_Saved_BackpackButton_OnClick;
			AllInOneInventory_Saved_BackpackButton_OnClick = nil;
		end
	end
end

-- Handles events
function AllInOneInventoryScriptFrame_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( AllInOneInventory_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_ALLINONEINVENTORY_ENABLED_X");
			if (value == nil ) then getglobal("AllInOneInventory_Enabled"); end
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AllInOneInventory_Toggle_Enabled(value);
			local value = getglobal("COS_ALLINONEINVENTORY_REPLACEBAGS_X");
			if (value == nil ) then getglobal("AllInOneInventory_ReplaceBags"); end
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AllInOneInventory_Toggle_ReplaceBags(value);
			local value = getglobal("COS_ALLINONEINVENTORY_INCLUDE_SHOTBAGS_X");
			if (value == nil ) then getglobal("AllInOneInventory_IncludeShotBags"); end
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AllInOneInventory_Toggle_IncludeShotBags(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AllInOneInventory_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
	local oldvalue = getglobal(variableName);
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		local text = "";
		if ( newvalue == 1 ) then
			if ( enableMessage ) then
				text = TEXT(getglobal(enableMessage));
			end
		else
			if ( disableMessage ) then
				text = TEXT(getglobal(disableMessage));
			end
		end
		if ( text ) and ( strlen(text) > 0 ) then
			AllInOneInventory_Print(text);
		end
	end
	AllInOneInventory_Register_Cosmos();
	if ( AllInOneInventory_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		AllInOneInventory_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		AllInOneInventory_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

function AllInOneInventory_Generic_CosmosUpdateCheckOnOff(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_CHECKONOFF, value);
	end
end

function AllInOneInventory_Generic_CosmosUpdateValue(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_SLIDERVALUE, value);
	end
end



-- Toggles the enabled/disabled state of the AllInOneInventory
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AllInOneInventory_Toggle_Enabled(toggle)
	AllInOneInventory_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function AllInOneInventory_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = AllInOneInventory_Generic_Toggle(toggle, "AllInOneInventory_Enabled", "COS_ALLINONEINVENTORY_ENABLED_X", "ALLINONEINVENTORY_CHAT_ENABLED", "ALLINONEINVENTORY_CHAT_DISABLED");
	else
		newvalue = AllInOneInventory_Generic_Toggle(toggle, "AllInOneInventory_Enabled", "COS_ALLINONEINVENTORY_ENABLED_X");
	end
end

-- toggling - no text
function AllInOneInventory_Toggle_Enabled_NoChat(toggle)
	AllInOneInventory_DoToggle_Enabled(toggle, false);
end

function AllInOneInventory_Toggle_Enabled(toggle)
	AllInOneInventory_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function AllInOneInventory_DoToggle_ReplaceBags(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = AllInOneInventory_Generic_Toggle(toggle, "AllInOneInventory_ReplaceBags", "COS_ALLINONEINVENTORY_REPLACEBAGS_X", "ALLINONEINVENTORY_CHAT_REPLACEBAGS_ENABLED", "ALLINONEINVENTORY_CHAT_REPLACEBAGS_DISABLED");
	else
		newvalue = AllInOneInventory_Generic_Toggle(toggle, "AllInOneInventory_ReplaceBags", "COS_ALLINONEINVENTORY_REPLACEBAGS_X");
	end
	if ( newvalue == 1 ) then
		AllInOneInventory_Saved_CloseBackpack();
	end
end

-- toggling - no text
function AllInOneInventory_Toggle_ReplaceBags_NoChat(toggle)
	AllInOneInventory_DoToggle_ReplaceBags(toggle, false);
end

function AllInOneInventory_Toggle_ReplaceBags(toggle)
	AllInOneInventory_DoToggle_ReplaceBags(toggle, true);
end

-- does the actual toggling
function AllInOneInventory_DoToggle_IncludeShotBags(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = AllInOneInventory_Generic_Toggle(toggle, "AllInOneInventory_IncludeShotBags", "COS_ALLINONEINVENTORY_INCLUDE_SHOTBAGS_X", "ALLINONEINVENTORY_CHAT_INCLUDE_SHOTBAGS_ENABLED", "ALLINONEINVENTORY_CHAT_INCLUDE_SHOTBAGS_DISABLED");
	else
		newvalue = AllInOneInventory_Generic_Toggle(toggle, "AllInOneInventory_IncludeShotBags", "COS_ALLINONEINVENTORY_INCLUDE_SHOTBAGS_X");
	end
end

-- toggling - no text
function AllInOneInventory_Toggle_IncludeShotBags_NoChat(toggle)
	AllInOneInventory_DoToggle_IncludeShotBags(toggle, false);
end

function AllInOneInventory_Toggle_IncludeShotBags(toggle)
	AllInOneInventory_DoToggle_IncludeShotBags(toggle, true);
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AllInOneInventory_Generic_Value(value, variableName, CVarName, message, formatValueMessage)
	local oldvalue = getglobal(variableName);
	local newvalue = value;
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		local text = nil;
		if ( formatValueMessage ) then
			text = format(TEXT(getglobal(formatValueMessage)), newvalue);
		elseif ( message ) then
			text = TEXT(getglobal(formatValueMessage));
		end
		if ( text ) and ( strlen(text) > 0 ) then
			AllInOneInventory_Print(text);
		end
	end
	AllInOneInventory_Register_Cosmos();
	if ( AllInOneInventory_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		AllInOneInventory_Generic_CosmosUpdateValue(CVarName, newvalue);
		AllInOneInventory_Generic_CosmosUpdateValue(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- does the actual setting
function AllInOneInventory_DoChange_Columns(value, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = AllInOneInventory_Generic_Value(value, "AllInOneInventory_Columns", "COS_ALLINONEINVENTORY_COLUMNS", nil, "ALLINONEINVENTORY_CHAT_COLUMNS_FORMAT");
	else
		newvalue = AllInOneInventory_Generic_Value(value, "AllInOneInventory_Columns", "COS_ALLINONEINVENTORY_COLUMNS");
	end
	AllInOneInventoryFrame_SetColumns(newvalue);
end

-- toggling - no text
function AllInOneInventory_Change_Columns_NoChat(toggle, value)
	AllInOneInventory_DoChange_Columns(value, false);
end

function AllInOneInventory_Change_Columns(toggle, value)
	AllInOneInventory_DoChange_Columns(value, true);
end



-- Prints out text to a chat box.
function AllInOneInventory_Print(msg,r,g,b,frame,id,unknown4th)
	if ( Print ) then
		Print(msg, r, g, b, frame, id, unknown4th);
		return;
	end
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 0.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

function AllInOneInventory_IsBagOpen(id)
	local formatStr = "ContainerFrame%d";
	local frame = nil;
	for i = 1, NUM_CONTAINER_FRAMES do
		frame = getglobal(format(formatStr, i));
		if ( ( frame ) and ( frame:IsVisible() ) and ( frame:GetID() == id ) ) then
			return true;
		end
	end
	return false;
end

function AllInOneInventory_GetBagState(bag, baseToggle)
	if ( AllInOneInventory_ShouldOverrideBag(bag) ) then
		local toggle = (AllInOneInventory_IsBagOpen(bag) or baseToggle);
		if ( ( toggle == true ) or ( toggle == 1 ) ) then
			return 1;
		else
			return 0;
		end
	else
		if ( AllInOneInventory_IsBagOpen(bag) ) then
			return 1;
		else
			return 0;
		end
	end
end

function AllInOneInventory_UpdateBagState()
	local shouldBeChecked = AllInOneInventoryFrame:IsVisible();
	MainMenuBarBackpackButton:SetChecked(AllInOneInventory_GetBagState(0, shouldBeChecked));
	local bagButton = nil;
	local formatStr = "CharacterBag%dSlot";
	for i = 0, 3 do 
		bagButton = getglobal(format(formatStr, i));
		if ( bagButton ) then
			bagButton:SetChecked(AllInOneInventory_GetBagState(i+1, shouldBeChecked));
		end
	end
end

function ToggleAllInOneInventoryFrame()
	if ( AllInOneInventoryFrame:IsVisible() ) then
		CloseAllInOneInventoryFrame();
	else
		OpenAllInOneInventoryFrame();
	end
	AllInOneInventory_UpdateBagState();
end

function CloseAllInOneInventoryFrame()
	if ( AllInOneInventoryFrame:IsVisible() ) then
		AllInOneInventoryFrame:Hide();
	end
	AllInOneInventory_UpdateBagState();
end

function OpenAllInOneInventoryFrame()
	local frame = getglobal("AllInOneInventoryFrame");
	AllInOneInventoryFrame_Update(frame);
	frame:Show();
	AllInOneInventory_UpdateBagState();
end

function AllInOneInventoryFrame_OnLoad()
	DynamicData.item.addOnInventoryUpdateHandler(AllInOneInventoryFrame_OnInventoryUpdate);
	--DynamicData.item.addOnInventoryCooldownUpdateHandler(AllInOneInventoryFrame_OnInventoryCooldownUpdate);
end

function AllInOneInventoryFrame_OnInventoryUpdate(bag, scanType)
	local frame = getglobal("AllInOneInventoryFrame");
	local func = nil;
	if ( scanType ) then
		if ( ( scanType and DYNAMICDATA_ITEM_SCAN_TYPE_COOLDOWN ) > 0 ) then
			func = getglobal("AllInOneInventoryFrame_UpdateAllCooldowns");
		end
		if ( ( scanType and DYNAMICDATA_ITEM_SCAN_TYPE_ITEMINFO ) > 0 ) then
			func = getglobal("AllInOneInventoryFrame_Update");
		end
	else
		func = getglobal("AllInOneInventoryFrame_Update");
	end
	if ( ( frame ) and ( frame:IsVisible() ) ) then
		if ( func ) then
			func(frame);
		end
	end
end

function AllInOneInventoryFrame_OnInventoryCooldownUpdate()
	local frame = getglobal("AllInOneInventoryFrame");
	if ( frame ) then
		AllInOneInventoryFrame_UpdateAllCooldowns(frame);
		if ( frame:IsVisible() ) then
			--AllInOneInventoryFrame_Update(frame);
		end
	end
end


function AllInOneInventoryFrame_OnEvent(event)
end

function AllInOneInventoryFrame_OnHide()
	PlaySound("igBackPackClose");
end

function AllInOneInventoryFrame_OnShow()
	AllInOneInventoryFrame_Update(this);
	PlaySound("igBackPackOpen");
end

function AllInOneInventoryFrame_UpdateAllCooldowns(frame)
	local name = frame:GetName();
	local itemInfo;
	local itemButton;
	local bag, slot;
	for buttonID = 1, ALLINONEINVENTORY_MAXIMUM_NUMBER_OF_BUTTONS do
		itemButton = getglobal(name.."Item"..buttonID);
		if ( itemButton ) then
			bag, slot = AllInOneInventory_GetIdAsBagSlot(itemButton:GetID());
			itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
			if ( ( itemInfo ) and ( itemInfo.texture ) and ( strlen(itemInfo.texture) > 0 ) ) then
				AllInOneInventoryFrame_UpdateCooldown(itemButton);
			end
		end
	end
end

function AllInOneInventoryFrame_UpdateButton(frame, buttonID)
	local name = frame:GetName();
	local itemButton = getglobal(name.."Item"..buttonID);

	if ( not itemButton ) then
		return;
	end
	
	local bag, slot = AllInOneInventory_GetIdAsBagSlot(itemButton:GetID());

	local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
	
	if ( not itemInfo ) then
		return;
	end
	
	SetItemButtonTexture(itemButton, itemInfo.texture);
	SetItemButtonCount(itemButton, itemInfo.count);

	SetItemButtonDesaturated(itemButton, itemInfo.locked, 0.5, 0.5, 0.5);
	
	if ( ( itemInfo.texture ) and ( strlen(itemInfo.texture) > 0 ) ) then
		AllInOneInventoryFrame_UpdateCooldown(itemButton);
	else
		local cooldownFrame = getglobal(itemButton:GetName().."Cooldown");
		if ( cooldownFrame ) then
			cooldownFrame:Hide();
		end
	end

	local readable = itemInfo.readable;
	--local normalTexture = getglobal(name.."Item"..j.."NormalTexture");
	--if ( quality and quality ~= -1) then
	--	local color = getglobal("ITEM_QUALITY".. quality .."_COLOR");
	--	normalTexture:SetVertexColor(color.r, color.g, color.b);
	--else
	--	normalTexture:SetVertexColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	--end
	local showSell = nil;
	if ( GameTooltip:IsOwned(itemButton) ) then
		if ( itemInfo.texture ) and ( strlen(itemInfo.texture) > 0 ) then
			DynamicData.util.protectTooltipMoney();
			local hasCooldown, repairCost = GameTooltip:SetBagItem(bag, slot);
			DynamicData.util.unprotectTooltipMoney();
			if ( hasCooldown ) then
				itemButton.updateTooltip = TOOLTIP_UPDATE_TIME;
			else
				itemButton.updateTooltip = nil;
			end
			if ( ( InRepairMode() ) and ( repairCost ) and (repairCost > 0) ) then
				GameTooltip:AddLine(TEXT(REPAIR_COST), "", 1, 1, 1);
				SetTooltipMoney(GameTooltip, repairCost);
				GameTooltip:Show();
			elseif ( MerchantFrame:IsVisible() and not locked) then
				showSell = 1;
			end
			AllInOneInventory_ModifyItemTooltip(bag, slot, "GameTooltip");
		else
			GameTooltip:Hide();
		end
		if ( showSell ) then
			ShowContainerSellCursor(bag, slot);
		elseif ( readable ) then
			ShowInspectCursor();
		else
			ResetCursor();
		end
	end
end

function AllInOneInventoryFrame_Update(frame)
	if ( not AllInOneInventoryFrame_UpdateLookIfNeeded() ) then
		for j=1, frame.size, 1 do
			AllInOneInventoryFrame_UpdateButton(frame, j);
		end
	end
end

function AllInOneInventoryFrame_UpdateCooldown(button)
	local bag, slot = AllInOneInventory_GetIdAsBagSlot(button:GetID());
	
	local cooldownFrame = getglobal(button:GetName().."Cooldown");
	local start, duration, enable = DynamicData.item.getInventoryCooldown(bag, slot);
	CooldownFrame_SetTimer(cooldownFrame, start, duration, enable);
	if ( ( duration > 0 ) and ( enable == 0 ) ) then
		SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4);
	end
end

function AllInOneInventoryFrameItemButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterForDrag("LeftButton");

	this.SplitStack = function(button, split)
		SplitContainerItem(button:GetParent():GetID(), button:GetID(), split);
	end
end

function AllInOneInventoryFrameItemButton_OnClick(button, ignoreShift)
	local bag, slot = AllInOneInventory_GetIdAsBagSlot(this:GetID());
	if ( button == "LeftButton" ) then
		if ( IsShiftKeyDown() and not ignoreShift ) then
			if ( ChatFrameEditBox:IsVisible() ) then
				ChatFrameEditBox:Insert(GetContainerItemLink(bag, slot));
			else
				local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
				if ( not itemInfo.locked ) then
					this.SplitStack = function(button, split)
						SplitContainerItem(bag, slot, split);
					end
					OpenStackSplitFrame(this.count, this, "BOTTOMRIGHT", "TOPRIGHT");
				end
			end
		else
			PickupContainerItem(bag, slot);
		end
	elseif ( button == "RightButton" ) then
		if ( Cosmos_ShiftToSell == true ) then
			if ( MerchantFrame:IsVisible() ) then
				if ( IsShiftKeyDown() ) then
					UseContainerItem(bag, slot);
				end
			else
				UseContainerItem(bag, slot);
			end
		else 
			if ( IsShiftKeyDown() and MerchantFrame:IsVisible() and not ignoreShift ) then
				this.SplitStack = function(button, split)
					SplitContainerItem(button:GetParent():GetID(), button:GetID(), split);
					MerchantItemButton_OnClick("LeftButton");
				end
				OpenStackSplitFrame(this.count, this, "BOTTOMRIGHT", "TOPRIGHT");
			else
				UseContainerItem(bag, slot);
			end
		end
	end
end

function AllInOneInventoryFrameItemButton_OnEnter()
	local bag, slot = AllInOneInventory_GetIdAsBagSlot(this:GetID());

	local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
	if ( ( not itemInfo ) or ( not itemInfo.texture ) or ( strlen(itemInfo.texture) <= 0 ) ) then
		DynamicData.util.clearTooltipStrings("GameTooltip"); -- unnecessary?
		GameTooltip:Hide();
		return;
	end
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	local hasCooldown, repairCost = GameTooltip:SetBagItem(bag, slot);
	if ( hasCooldown ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
	if ( InRepairMode() and (repairCost and repairCost > 0) ) then
		GameTooltip:AddLine(TEXT(REPAIR_COST), "", 1, 1, 1);
		SetTooltipMoney(GameTooltip, repairCost);
		GameTooltip:Show();
	elseif ( MerchantFrame:IsVisible() ) then
		ShowContainerSellCursor(bag, slot);
	elseif ( this.readable ) then
		ShowInspectCursor();
	end

	AllInOneInventory_ModifyItemTooltip(bag, slot, "GameTooltip");
end

function AllInOneInventoryFrameItemButton_OnLeave()
	this.updateTooltip = nil;
	if ( GameTooltip:IsOwned(this) ) then
		GameTooltip:Hide();
		ResetCursor();
	end
end

-- modifies the tooltip
function AllInOneInventory_ModifyItemTooltip(bag, slot, tooltipName)
	if ( not tooltipName ) then
		tooltipName = "GameTooltip";
	end
	AllInOneInventory_ReagentHelper_ModifyItemTooltip(bag, slot, tooltipName);
	AllInOneInventory_LootLink_ModifyItemTooltip(bag, slot, tooltipName);
	--AllInOneInventory_SellValue_ModifyItemTooltip(bag, slot, tooltipName);

end

function AllInOneInventory_SellValue_ModifyItemTooltip(bag, slot, tooltipName)
	local tooltip = getglobal(tooltipName);
	if ( not tooltip ) then	
		return;
	end
	if ( not SellValue_AddMoneyToTooltip ) then
		return;
	end
	local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);

	if ( not SellValues ) or ( MerchantFrame:IsVisible() ) then
		return;
	end

	local itemName = nil;
	if ( itemInfo ) and ( itemInfo.name ) then
		itemName = itemInfo.name;
	end
	if ( not itemName ) or ( strlen(itemName) <= 0 ) then
		return;
	end
	-- Don't add a tooltip for hidden items
	if ( not InvList_TooltipMode ) or
		( ( InvList_TooltipMode == 1 ) and ( InvList_HiddenItems ) and ( InvList_HiddenItems[itemName] ) ) then
		return;
	end
	
	local price = SellValues[itemName];
  
	if ( price ) then
		local linesAdded = 0;
		if ( price == 0 ) then
			tooltip:AddLine("No sell price", 1.0, 1.0, 0);
			linesAdded = 1;
		else
			tooltip:AddLine("Sells for (each):", 1.0, 1.0, 0);
			SetTooltipMoney(tooltip, price);
			linesAdded = 2
		end  -- if price > 0

		-- Adjust width and height to account for new lines
		tooltip:SetHeight(tooltip:GetHeight() + (14 * linesAdded));
		if ( tooltip:GetWidth() < 120 ) then tooltip:SetWidth(120); end
	end  -- if price
end

function AllInOneInventory_LootLink_ModifyItemTooltip(bag, slot, tooltipName)
	if ( ( LootLink_Tooltip_Hook ) and ( ( not InRepairMode() ) and ( not MerchantFrame:IsVisible() ) ) ) then
		local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
		local name = DynamicData.util.getNameFromTooltip(tooltipName);
		if ( ( itemInfo ) and ( name ) and ( strlen(name) > 0 ) and ( ItemLinks[name] ) ) then
			local data = ItemLinks[name];
			local money = 0;
			if ( data.price ) then
				money = data.price;
			end
			local tooltip = getglobal(tooltipName);
			if ( not tooltip ) then	
				return;
			end
			LootLink_Tooltip_Hook(tooltip, name, money, itemInfo.count, data);
			tooltip:Show();
		end
	end
end

function AllInOneInventory_ReagentHelper_ModifyItemTooltip(bag, slot, tooltipName)
	if ( ( COS_RH_TOOLTIP_ENABLE ) and ( ReagentHelper_FindProfessions ) ) then
		local tooltip = getglobal(tooltipName);
		if ( not tooltip ) then	
			return;
		end
		local name = DynamicData.util.getNameFromTooltip(tooltipName);
		if ( ( not name ) or ( strlen(name) <= 0 ) ) then 
			return;
		end
		local professionList = ReagentHelper_FindProfessions(name);
		if (professionList) then
			for professionIndex, professionName in professionList do
				tooltip:AddLine(professionName, "", 1, 1, 1);
			end
			tooltip:Show();
		end
	else
		-- No Labels
	end
end

function AllInOneInventoryFrameItemButton_OnUpdate(elapsed)
	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		AllInOneInventoryFrameItemButton_OnEnter();
	else
		this.updateTooltip = nil;
	end
end

function AllInOneInventoryFrame_UpdateLookIfNeeded()
	local slots = AllInOneInventory_GetBagsTotalSlots();
	local frame = getglobal("AllInOneInventoryFrame");
	if ( ( not frame.size ) or ( slots ~= frame.size ) ) then
		AllInOneInventoryFrame_UpdateLook(frame, slots);
		return true;
	end
	return false;
end

function AllInOneInventoryFrame_SetColumns(col)
	if ( type(col) ~= "number" ) then
		col = tonumber(col);
	end
	if ( ( col >= ALLINONEINVENTORY_COLUMNS_MIN ) 
		and ( col <= ALLINONEINVENTORY_COLUMNS_MAX ) 
		) then
		AllInOneInventory_Columns = col;
		AllInOneInventoryFrame_UpdateLook(getglobal("AllInOneInventoryFrame"), AllInOneInventory_GetBagsTotalSlots());
	end
end

function AllInOneInventoryFrame_GetAppropriateHeight(rows)
	return ALLINONEINVENTORY_BASE_HEIGHT + ( ALLINONEINVENTORY_ROW_HEIGHT * rows );
end

function AllInOneInventoryFrame_GetAppropriateWidth(cols)
	return ALLINONEINVENTORY_BASE_WIDTH + ( ALLINONEINVENTORY_COL_WIDTH * cols );
end


AllInOneInventoryFrame_AnchorWidgetList = { "MainMenuBar"};

function AllInOneInventoryFrame_AddAnchorWidget(widgetName)
	table.insert(AllInOneInventoryFrame_AnchorWidgetList, widgetName);
end

function AllInOneInventoryFrame_GetAnchorWidget()
	local obj = nil;
	for k, v in AllInOneInventoryFrame_AnchorWidgetList do
		obj = getglobal(v);
		if ( obj ) and ( obj:IsVisible() ) then
			return v;
		end
	end
	return "UIParent";
end

function AllInOneInventoryFrame_ResetButton()
	AllInOneInventoryFrame_ResetPosition(AllInOneInventoryFrame);
end

function AllInOneInventoryFrame_ResetPosition(frame)
	local anchorWidgetName = AllInOneInventoryFrame_GetAnchorWidget();
	local anchorWidget = getglobal(anchorWidgetName);
	local anchorWidgetYOffset = 5;
	
	if ( anchorWidgetName == "UIParent" ) then
		anchorWidgetYOffset = 54;
	end

	local xPos = -17;

	if ( SideBarLeft_ShouldShiftBagFramesLeftOnShow ) then
		if ( ( SideBarLeft_ShouldShiftBagFramesLeftOnShow() ) and ( SideBar:IsVisible() ) ) then
			local temp = UIParent:GetWidth() - anchorWidget:GetWidth();
			xPos = temp + SideBarLeft_GetSafeOffset();
			if ( xPos > 0 ) then
				xPos = 1-xPos;
			end
		end
	end

	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMRIGHT", anchorWidgetName, "TOPRIGHT", xPos, anchorWidgetYOffset);
end

function AllInOneInventoryFrame_UpdateLook(frame, frameSize)
	frame.size = frameSize;
	
	local name = frame:GetName();
--	local bgTexture = getglobal(name.."BackgroundTexture");
	getglobal(name.."MoneyFrame"):Show();
	local columns = AllInOneInventory_Columns;
	if (columns > frame.size) then columns = frame.size; end -- doesn't make sense to have more columns than slots, just in case sarf decides to increase the upper limit
	local rows = ceil(frame.size / columns);
	-- Added a short name, in case the long name doesn't fit ;)
	if (columns <= 4) then
		getglobal(name.."Name"):SetText("AIOI");
	else
		getglobal(name.."Name"):SetText("All in One Inventory");
	end
	
	local oldHeight = frame:GetHeight();
	local height = AllInOneInventoryFrame_GetAppropriateHeight(rows);
	frame:SetHeight(height);

	local oldWidth = frame:GetWidth();
	local width = AllInOneInventoryFrame_GetAppropriateWidth(columns);
	frame:SetWidth(width);
	
--	bgTexture:Hide();
	
	local diffHeight = ceil(height - oldHeight);
	local diffWidth = ceil(width - oldWidth);
	
	if ( ( ( diffHeight > 1 ) or ( diffHeight < -1 ) ) or ( ( diffWidth > 1 ) or ( diffWidth < -1 ) ) ) then
		--AllInOneInventoryFrame_ResetPosition(frame);
	end
	
	-- texture code to make it look like a normal bag...
	local lastColumnIsComplete = false;
	if (rows == floor(frame.size / columns)) then lastColumnIsComplete = true; end

	-- set textures for moneyframe:
	getglobal(name.."TextureBottomMiddle"):SetWidth((columns - 2) * 42 + 70);
	
	-- show the first row (assumes that columns < frame.size)
	local texture = getglobal(name.."ItemTexture1");
	texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\first_right");
	texture:SetPoint("TOPLEFT", name.."TextureBottomRight", "TOPLEFT", -35, 43);
	texture:Show();
	for i=2, (columns-1), 1 do
		local texture = getglobal(name.."ItemTexture"..i);
		texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\first_middle");
		texture:SetPoint("TOPLEFT", name.."ItemTexture"..(i - 1), "TOPLEFT", -42, 0);
		texture:Show();
	end
	local texture = getglobal(name.."ItemTexture"..columns);
	texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\first_left");
	texture:SetPoint("TOPLEFT", name.."ItemTexture"..(columns - 1), "TOPLEFT", -47, 0);
	texture:Show(); 
	
	-- show the other rows
	for j=1, (rows - 1), 1 do
		local texture = getglobal(name.."ItemTexture"..(j * columns + 1));
		texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\second_right");
		local textureOffsetX = 0; if (j == 1) then textureOffsetX = -3; end
		texture:SetPoint("TOPLEFT", name.."ItemTexture"..((j - 1) * columns + 1), "TOPLEFT", textureOffsetX, 41);
		texture:Show();
		local slotsInRow = columns;
		if ((j + 1) * columns > frame.size) then slotsInRow = frame.size - (j * columns); end
		for i=2, (slotsInRow - 1), 1 do
			local texture = getglobal(name.."ItemTexture"..(j * columns + i));
			texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\second_middle");
			texture:SetPoint("TOPLEFT", name.."ItemTexture"..(j * columns + i - 1), "TOPLEFT", -42, 0);
			texture:Show();
		end
		if (slotsInRow == columns) then
			local texture = getglobal(name.."ItemTexture"..(j * columns + slotsInRow));
			texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\second_left");
			texture:SetPoint("TOPLEFT", name.."ItemTexture"..(j * columns + slotsInRow - 1), "TOPLEFT", -44, 0);
			texture:Show();
		elseif (slotsInRow > 1) then
			local texture = getglobal(name.."ItemTexture"..(j * columns + slotsInRow));
			texture:SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\second_middle");
			texture:SetPoint("TOPLEFT", name.."ItemTexture"..(j * columns + slotsInRow - 1), "TOPLEFT", -42, 0);
			texture:Show();
		end
	end
	
	getglobal(name.."TextureTopMiddle"):SetWidth((columns - 2) * 42 + 22);
	if (lastColumnIsComplete) then
		local textureOffsetX = 0; if (frame.size == columns) then textureOffsetX = -3; end
		getglobal(name.."TextureTopRight"):SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\top_right_large");
		getglobal(name.."TextureTopRight"):SetPoint("BOTTOMLEFT", name.."ItemTexture"..((rows - 1) * columns + 1), "TOPLEFT", 19 + textureOffsetX, 0);
		getglobal(name.."TextureTopMiddle"):SetPoint("BOTTOMRIGHT", name.."TextureTopRight", "BOTTOMLEFT", 0, -34);
		getglobal(name.."CloseButton"):SetPoint("BOTTOMLEFT", name.."TextureTopRight", "BOTTOMLEFT", 4, 12);
	else
		getglobal(name.."TextureTopRight"):SetTexture("Interface\\AddOns\\AllInOneInventory\\Skin\\top_right_small");
		getglobal(name.."TextureTopRight"):SetPoint("BOTTOMLEFT", name.."ItemTexture"..((rows - 1) * columns + 1), "TOPLEFT", 19, 0);
		getglobal(name.."TextureTopMiddle"):SetPoint("BOTTOMRIGHT", name.."TextureTopRight", "BOTTOMLEFT", 0, -51);
		getglobal(name.."CloseButton"):SetPoint("BOTTOMLEFT", name.."TextureTopRight", "BOTTOMLEFT", 4, -5);
	end
	
	for j=0, (frame.size - 1), 1 do
		local itemButton = getglobal(name.."Item"..(frame.size - j));
		itemButton:SetID(frame.size - j);
		itemButton:ClearAllPoints();
		-- Set first button
		if ( j == 0 ) then
			itemButton:SetPoint("TOPLEFT", name.."ItemTexture1", "TOPLEFT", 4, -1);
		else
			if ( mod(j, columns) == 0 ) then
				itemButton:SetPoint("TOPLEFT", name.."Item"..(frame.size - j + columns), "TOPLEFT", 0, 41);	
			else
				itemButton:SetPoint("TOPLEFT", name.."Item"..(frame.size - j + 1), "TOPLEFT", -42, 0);	
			end
		end
		itemButton:Show();

		AllInOneInventoryFrame_UpdateButton(frame, (frame.size - j));
	end
	local button = nil;
	local texture = nil;
	for i = frame.size+1, ALLINONEINVENTORY_MAX_ID do
		button = getglobal(name.."Item"..i);
		if ( button ) then
			button:Hide();
		end
		texture = getglobal(name.."ItemTexture"..i); -- hide the textures, that are not needed
		if ( texture ) then
			texture:Hide();
		end
	end
end