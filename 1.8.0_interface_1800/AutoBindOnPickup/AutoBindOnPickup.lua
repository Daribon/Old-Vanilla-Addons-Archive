--[[
	Auto Bind on Pickup

	By sarf

	This mod will allow you to bypass the BoP popup box when not in a group.

	Thanks goes to johnwood for this one.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
AutoBindOnPickup_RightPopups = {
	"LOOT_BIND"
};


AUTOBINDONPICKUP_SCHEDULE_DELAY = 0.1;

-- Variables
AutoBindOnPickup_Enabled = 1;

AutoBindOnPickup_Saved_StaticPopup_Show = nil;
AutoBindOnPickup_Cosmos_Registered = 0;
AutoBindOnPickup_Khaos_Registered = 0;

-- executed on load, calls general set-up functions
function AutoBindOnPickup_OnLoad()
	AutoBindOnPickup_Register();
end

-- registers the mod with Cosmos
function AutoBindOnPickup_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( AutoBindOnPickup_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_AUTOBINDONPICKUP",
			"SECTION",
			TEXT(AUTOBINDONPICKUP_CONFIG_HEADER),
			TEXT(AUTOBINDONPICKUP_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_AUTOBINDONPICKUP_HEADER",
			"SEPARATOR",
			TEXT(AUTOBINDONPICKUP_CONFIG_HEADER),
			TEXT(AUTOBINDONPICKUP_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_AUTOBINDONPICKUP_ENABLED",
			"CHECKBOX",
			TEXT(AUTOBINDONPICKUP_ENABLED),
			TEXT(AUTOBINDONPICKUP_ENABLED_INFO),
			AutoBindOnPickup_Toggle_Enabled_NoChat,
			AutoBindOnPickup_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local AutoBindOnPickupMainCommands = {"/autobop","/autobindonpickup"};
			Cosmos_RegisterChatCommand (
				"AUTOBINDONPICKUP_MAIN_COMMANDS", -- Some Unique Group ID
				AutoBindOnPickupMainCommands, -- The Commands
				AutoBindOnPickup_Main_ChatCommandHandler,
				AUTOBINDONPICKUP_CHAT_COMMAND_INFO -- Description String
			);
		end
		AutoBindOnPickup_Cosmos_Registered = 1;
	end
end

function AutoBindOnPickup_Get_Khaos_CheckBox(pid, pkey, ptext, phelptext, pcheck, cb)
	local option1 = {
		id = pid;
		key = pkey;
		text = ptext;
		helptext = phelptext;
		check = true;
		callback = cb;
		type = K_TEXT;
		feedback = function(state) local s = AUTOBINDONPICKUP_STATE_ENABLED; if ( not state.checked ) then s = AUTOBINDONPICKUP_STATE_DISABLED; end return AUTOBINDONPICKUP_STATE_TEXT.." "..s; end;
		default = {
			checked = pcheck;
		};
		disabled = {
			checked = false;
		};
	};
	return option1;
end


AUTOBINDONPICKUP_KHAOS_SET_EASY_ID 			= "AutoBindOnPickupBasicSetID";

AUTOBINDONPICKUP_KHAOS_FOLDER_ID			= "frames";

AutoBindOnPickup_Folder = {
	id = AUTOBINDONPICKUP_KHAOS_FOLDER_ID;
	text = AUTOBINDONPICKUP_CONFIG_HEADER;
	helptext = AUTOBINDONPICKUP_CONFIG_HEADER_INFO;
	difficulty = 1;
	default = true;
};

function AutoBindOnPickup_GetStateAsToggleValue(newState)
	if ( newState ) then
		return 1;
	else
		return 0;
	end
end


function AutoBindOnPickup_Register_Khaos()
	if ( ( Khaos ) and ( AutoBindOnPickup_Khaos_Registered == 0 ) ) then
		--Khaos.registerFolder(AutoBindOnPickup_Folder);
		local optionSetEasy = {
			id = AUTOBINDONPICKUP_KHAOS_SET_EASY_ID;
			text = AUTOBINDONPICKUP_KHAOS_EASYSET_TEXT;
			helptext = AUTOBINDONPICKUP_KHAOS_EASYSET_HELP;
			difficulty = 1;
			options = {
				AutoBindOnPickup_Get_Khaos_CheckBox("CheckBoxEnabled", "enabled", 
					AUTOBINDONPICKUP_ENABLED, 
					AUTOBINDONPICKUP_ENABLED_INFO, 
					true, 
					function(state) AutoBindOnPickup_Toggle_Enabled_NoChat(AutoBindOnPickup_GetStateAsToggleValue(state.checked)); end
				),
			};
			default = true;
		};
		Khaos.registerOptionSet( AUTOBINDONPICKUP_KHAOS_FOLDER_ID, optionSetEasy );
		AutoBindOnPickup_Khaos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function AutoBindOnPickup_Register()
	if ( Khaos ) then
		AutoBindOnPickup_Register_Khaos();
	elseif ( Cosmos_RegisterConfiguration ) then
		AutoBindOnPickup_Register_Cosmos();
	else
		SlashCmdList["AUTOBINDONPICKUPSLASHMAIN"] = AutoBindOnPickup_Main_ChatCommandHandler;
		SLASH_AUTOBINDONPICKUPSLASHMAIN1 = "/autobindonpickup";
		SLASH_AUTOBINDONPICKUPSLASHMAIN2 = "/autobop";
		this:RegisterEvent("VARIABLES_LOADED");
	end
	this:RegisterEvent("LOOT_BIND_CONFIRM");
end

function AutoBindOnPickup_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the AutoBindOnPickup
function AutoBindOnPickup_Main_ChatCommandHandler(msg)
	
	local func = AutoBindOnPickup_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		AutoBindOnPickup_Print(AUTOBINDONPICKUP_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = AutoBindOnPickup_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = AutoBindOnPickup_Toggle_Enabled;
	else
		AutoBindOnPickup_Print(AUTOBINDONPICKUP_CHAT_COMMAND_USAGE);
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

function AutoBindOnPickup_IsRightPopup(which)
	local isRightPopup = false;
	for k, v in AutoBindOnPickup_RightPopups do
		if ( which == v ) then
			isRightPopup = true;
			break;
		end
	end
	return isRightPopup;
end

function AutoBindOnPickup_IsInPartyOrRaid()
	if ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0  ) ) then
		return true;
	else
		return false;
	end
end

function AutoBindOnPickup_GetStaticPopup(which)
	for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
		local frame = getglobal("StaticPopup"..index);
		if( frame:IsVisible() and (frame.which == which) ) then 
			return frame;
		end
	end
	return nil;
end


-- Does things with the hooked function
function AutoBindOnPickup_StaticPopup_Show(which, text_arg1, text_arg2)
	if ( ( AutoBindOnPickup_Enabled == 1 ) and ( AutoBindOnPickup_IsRightPopup(which) ) and ( not AutoBindOnPickup_IsInPartyOrRaid() ) ) then
		--[[
		local frame = AutoBindOnPickup_GetStaticPopup(which);
		local info = StaticPopupDialogs[which];
		if ( info ) and ( not info.OnAccept ) then
			info.OnAccept(frame.data);
		end
		--]]
		return nil;
	end
	return AutoBindOnPickup_Saved_StaticPopup_Show(which, text_arg1, text_arg2);
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function AutoBindOnPickup_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( StaticPopup_Show ~= AutoBindOnPickup_StaticPopup_Show ) and (AutoBindOnPickup_Saved_StaticPopup_Show == nil) ) then
			AutoBindOnPickup_Saved_StaticPopup_Show = StaticPopup_Show;
			StaticPopup_Show = AutoBindOnPickup_StaticPopup_Show;
		end
	else
		if ( StaticPopup_Show == AutoBindOnPickup_StaticPopup_Show) then
			StaticPopup_Show = AutoBindOnPickup_Saved_StaticPopup_Show;
			AutoBindOnPickup_Saved_StaticPopup_Show = nil;
		end
	end
end

-- Handles events
function AutoBindOnPickup_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( AutoBindOnPickup_Cosmos_Registered == 0 ) then
			local value = getglobal("AutoBindOnPickup_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AutoBindOnPickup_Toggle_Enabled(value);
		end
		return;
	end
	if ( event == "LOOT_BIND_CONFIRM" ) then
		if ( ( AutoBindOnPickup_Enabled == 1 ) and ( not AutoBindOnPickup_IsInPartyOrRaid() ) ) then
			AutoBindOnPickup_LootSlot(arg1);
			--LootSlot(arg1);
		end
		--AutoBindOnPickup_Print(format("Loot Slot : %d", arg1));
		return;
	end
end

function AutoBindOnPickup_LootSlot(slot)
	if ( Chronos ) and ( Chronos.schedule ) then
		Chronos.schedule(AUTOBINDONPICKUP_SCHEDULE_DELAY, LootSlot, slot);
	elseif ( Cosmos_Schedule ) then
		Cosmos_Schedule(AUTOBINDONPICKUP_SCHEDULE_DELAY, LootSlot, slot);
	else
		LootSlot(slot);
	end
end


-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AutoBindOnPickup_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			AutoBindOnPickup_Print(text);
		end
	end
	RegisterForSave(variableName);
	if ( AutoBindOnPickup_Cosmos_Registered == 1 ) then 
		AutoBindOnPickup_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		AutoBindOnPickup_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

function AutoBindOnPickup_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function AutoBindOnPickup_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the AutoBindOnPickup
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AutoBindOnPickup_Toggle_Enabled(toggle)
	AutoBindOnPickup_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function AutoBindOnPickup_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = AutoBindOnPickup_Generic_Toggle(toggle, "AutoBindOnPickup_Enabled", "COS_AUTOBINDONPICKUP_ENABLED_X", "AUTOBINDONPICKUP_CHAT_ENABLED", "AUTOBINDONPICKUP_CHAT_DISABLED");
	else
		newvalue = AutoBindOnPickup_Generic_Toggle(toggle, "AutoBindOnPickup_Enabled", "COS_AUTOBINDONPICKUP_ENABLED_X");
	end
	AutoBindOnPickup_Setup_Hooks(newvalue);
end

-- toggling - no text
function AutoBindOnPickup_Toggle_Enabled_NoChat(toggle)
	AutoBindOnPickup_DoToggle_Enabled(toggle, false);
end

-- Prints out text to a chat box.
function AutoBindOnPickup_Print(msg,r,g,b,frame,id,unknown4th)
	if ( Print ) then
		Print(msg, r, g, b, frame, id, unknown4th);
	end
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end
