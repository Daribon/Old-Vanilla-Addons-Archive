--[[
	Trinket Cycler v0.01-test-alpha

	By sarf

	This mod allows you to cycle Trinkets. Use a trinket, and it cycles to the next trinket.

	Thanks goes to sancus for the idea, and CapnBry for the Trinket placer frame.
	
   ]]


-- Constants
TRINKETCYCLER_TOGGLE_FUNC_NAME = "TrinketCycler_Toggle_Enabled";

-- Variables
TrinketCycler_Enabled = 1;
TrinketCycler_CycleIndividually = 0;

TrinketCycler_Saved_UseInventoryItem = nil;
TrinketCycler_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function TrinketCycler_OnLoad()
	TrinketCycler_Register();
end

-- registers the mod with Cosmos
function TrinketCycler_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( TrinketCycler_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_TRINKETCYCLER",
			"SECTION",
			TEXT(TRINKETCYCLER_CONFIG_HEADER),
			TEXT(TRINKETCYCLER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_TRINKETCYCLER_HEADER",
			"SEPARATOR",
			TEXT(TRINKETCYCLER_CONFIG_HEADER),
			TEXT(TRINKETCYCLER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_TRINKETCYCLER_ENABLED",
			"CHECKBOX",
			TEXT(TRINKETCYCLER_ENABLED),
			TEXT(TRINKETCYCLER_ENABLED_INFO),
			TrinketCycler_Toggle_Enabled_NoChat,
			TrinketCycler_Enabled
		);
		TrinketCycler_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function TrinketCycler_Register()
	AddOnHelper_AddSlashCommand("TRINKETCYCLERSLASHMAIN", TRINKETCYCLER_COMMANDS, 
		TrinketCycler_Main_ChatCommandHandler, TRINKETCYCLER_CHAT_COMMAND_INFO); 
	
	AddOnHelper_CreateToggleFunction(TRINKETCYCLER_TOGGLE_FUNC_NAME, "TrinketCycler_Enabled", 
		"TRINKETCYCLER_CHAT_ENABLED", "TRINKETCYCLER_CHAT_DISABLED", "COS_TRINKETCYCLER_ENABLED_X");

	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		TrinketCycler_Register_Cosmos();
	else
		this:RegisterEvent("VARIABLES_LOADED");
	end
	
end

TrinketCycler_Commands = {
	{ functionName = "TrinketCycler_Toggle_Enabled", listName = "TRINKETCYCLER_TOGGLE_COMMANDS" },
	{ functionName = "TrinketCycler_ShowSetupWindow", listName = "TRINKETCYCLER_SHOW_COMMANDS" },
};

function TrinketCycler_Choose_Right_Command(command, list, useExact)
	local func = nil;
	for k, v in list do
		for key, value in getglobal(v.listName) do
			if ( command == value) then
				func = v.functionName;
				break;
			end
			if (not useExact) then
				if ( strfind(command, value) ) then
					func = v.functionName;
					break;
				end
			end
		end
		if ( func ) then
			break;
		end
	end
	return func;
end


-- Handles chat - e.g. slashcommands - enabling/disabling the TrinketCycler
function TrinketCycler_Main_ChatCommandHandler(msg)
	
	local func = nil;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		AddOnHelper_Print(TRINKETCYCLER_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = AddOnHelper_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	func = TrinketCycler_Choose_Right_Command(commandName, TrinketCycler_Commands);
	
	if ( not func ) then
		AddOnHelper_Print(TRINKETCYCLER_CHAT_COMMAND_USAGE);
		return;
	end
	if ( type(func) == "string" ) then
		func = getglobal(func);
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

function TrinketCycler_CycleTrinket(id, loops)
	local ok = false;
	if ( CursorHasItem() ) then
		if ( loops ) and ( loops >= TRINKETCYCLER_MAX_LOOPS ) then
			AddOnHelper_Print(TRINKETCYCLER_MESSAGE_ITEM_ON_CURSOR_FOR_TOO_LONG);
			ok = true;
		end
	else
		local trinket = nil;
		if ( TrinketCycler_CycleIndividually == 1 ) then
			trinket = id;
		end
		if ( not loops ) then loops = 0; end
		local bag, slot;
		local nextTrinket = TrinketCyclerSetup_GetNextTrinket(trinket);
		local itemInfo = nil;
		if ( nextTrinket ) then
			itemInfo = DynamicData.item.getItemInfoByName(nextTrinket);
		end
		local ok = false;
		if ( nextTrinket ) and ( itemInfo ) then
			ok = true;
		end 
		if ( ok ) and ( ( itemInfo.name ) and ( strlen(itemInfo.name) > 0 ) and ( itemInfo.name == nextTrinket ) 
			and ( itemInfo.position ) and ( table.getn(itemInfo.position) > 0 ) ) then
			bag = -1;
			slot = -1;
			for k, v in itemInfo.position do
				if ( v.bag ~= -1 ) then
					bag = v.bag;
					slot = v.slot;
					break;
				end
			end
			if ( bag ~= -1 ) and ( slot ~= -1 ) then
				local start, duration, enable = GetContainerItemCooldown(bag, slot);
				if ( start == 0 ) and ( duration == 0 ) then
					PickupContainerItem(bag, slot);
					PickupInventoryItem(id);
					ok = true;
				end
			end
		end
	end
	if ( not ok ) then
		loops = loops + 1;
		Cosmos_Schedule(0.5, TrinketCycler_CycleTrinket, id, loops)
	end
end

-- Does things with the hooked function
function TrinketCycler_UseInventoryItem(id)
	local start, duration, enable = GetInventoryItemCooldown("player", id);
	TrinketCycler_Saved_UseInventoryItem(id);
	local isLocked = IsInventoryItemLocked(id);
	if ( TrinketCycler_Enabled == 1 ) and ( not isLocked ) then
		if ( id == TRINKET_CYCLER_FIRST_TRINKET_INDEX ) or ( id == TRINKET_CYCLER_SECOND_TRINKET_INDEX ) then
			if ( start == 0 ) and ( duration == 0 ) then
				local itemInfo = DynamicData.item.getEquippedSlotInfo(id);
				if ( itemInfo.name ) and ( strlen(itemInfo.name) > 0 ) then
					Cosmos_Schedule(0.5, TrinketCycler_CycleTrinket, id);
				end
			end
		end
	end
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function TrinketCycler_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( UseInventoryItem ~= TrinketCycler_UseInventoryItem ) and (TrinketCycler_Saved_UseInventoryItem == nil) ) then
			TrinketCycler_Saved_UseInventoryItem = UseInventoryItem;
			UseInventoryItem = TrinketCycler_UseInventoryItem;
		end
	else
		if ( UseInventoryItem == TrinketCycler_UseInventoryItem) then
			UseInventoryItem = TrinketCycler_Saved_UseInventoryItem;
			TrinketCycler_Saved_UseInventoryItem = nil;
		end
	end
end

-- Handles events
function TrinketCycler_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( TrinketCycler_Cosmos_Registered == 0 ) then
			local value = getglobal("TrinketCycler_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			TrinketCycler_Toggle_Enabled(value);
		end
	end
end

-- Toggles the enabled/disabled state of the TrinketCycler
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function TrinketCycler_Toggle_Enabled(toggle)
	local newValue = AddOnHelper_HandleToggleFunction(TRINKETCYCLER_TOGGLE_FUNC_NAME, toggle, true);
	TrinketCycler_Setup_Hooks(newValue);
end

-- toggling - no text
function TrinketCycler_Toggle_Enabled_NoChat(toggle)
	local newValue = AddOnHelper_HandleToggleFunction(TRINKETCYCLER_TOGGLE_FUNC_NAME, toggle, false);
	TrinketCycler_Setup_Hooks(newValue);
end

function TrinketCycler_ShowSetupWindow(toggle, loops)
	if ( not loops ) then
		loops = 0;
	end
	if ( not TrinketCyclerSetupFrame ) then
		if ( Cosmos_ScheduleByName ) then
			if ( loops < 10 ) then
				Cosmos_ScheduleByName("TC_SSW", 1, TrinketCycler_ShowSetupWindow, toggle, loops);
			end
			return;
		end
	end
	if ( not toggle ) or ( toggle == 1 ) then
		ShowUIPanel(TrinketCyclerSetupFrame);
	elseif ( toggle == -1 ) then
		if ( TrinketCyclerSetupFrame:IsVisible() ) then
			HideUIPanel(TrinketCyclerSetupFrame);
		else
			ShowUIPanel(TrinketCyclerSetupFrame);
		end
	else
		HideUIPanel(TrinketCyclerSetupFrame);
	end
end