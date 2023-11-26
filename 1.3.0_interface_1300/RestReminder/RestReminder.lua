--[[
	Rest Reminder

	By sarf

	This mod will remind you to get to a rest place when you try to log out.

	Thanks goes to krawz for this one.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

RestReminder_RightPopups = {
	"CAMP",
	"QUIT"
};


-- Variables
RestReminder_Enabled = 1;

RestReminder_Saved_StaticPopup_Show = nil;
RestReminder_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function RestReminder_OnLoad()
	RestReminder_Register();
end

-- registers the mod with Cosmos
function RestReminder_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( RestReminder_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_RESTREMINDER",
			"SECTION",
			TEXT(RESTREMINDER_CONFIG_HEADER),
			TEXT(RESTREMINDER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_RESTREMINDER_HEADER",
			"SEPARATOR",
			TEXT(RESTREMINDER_CONFIG_HEADER),
			TEXT(RESTREMINDER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_RESTREMINDER_ENABLED",
			"CHECKBOX",
			TEXT(RESTREMINDER_ENABLED),
			TEXT(RESTREMINDER_ENABLED_INFO),
			RestReminder_Toggle_Enabled_NoChat,
			RestReminder_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local RestReminderMainCommands = {"/restreminder","/rm"};
			Cosmos_RegisterChatCommand (
				"RESTREMINDER_MAIN_COMMANDS", -- Some Unique Group ID
				RestReminderMainCommands, -- The Commands
				RestReminder_Main_ChatCommandHandler,
				RESTREMINDER_CHAT_COMMAND_INFO -- Description String
			);
		end
		RestReminder_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function RestReminder_Register()
	if ( Cosmos_RegisterConfiguration ) then
		RestReminder_Register_Cosmos();
	else
		SlashCmdList["RESTREMINDERSLASHMAIN"] = RestReminder_Main_ChatCommandHandler;
		SLASH_RESTREMINDERSLASHMAIN1 = "/restreminder";
		SLASH_RESTREMINDERSLASHMAIN2 = "/rm";
		this:RegisterEvent("VARIABLES_LOADED");
	end
end

function RestReminder_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the RestReminder
function RestReminder_Main_ChatCommandHandler(msg)
	
	local func = RestReminder_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		RestReminder_Print(RESTREMINDER_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = RestReminder_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = RestReminder_Toggle_Enabled;
	else
		RestReminder_Print(RESTREMINDER_CHAT_COMMAND_USAGE);
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

function RestReminder_Warning(message)
	RestReminderTextFrameText:SetTextColor(1.0, 0.1, 0.1);
	RestReminderTextFrameText:SetText(message);
    RestReminderTextFrame.startTime = GetTime();
	PlaySound("AuctionWindowOpen");
    RestReminderTextFrame:Show();
end

function RestReminder_IsRightPopup(which)
	local isRightPopup = false;
	for k, v in RestReminder_RightPopups do
		if ( which == v ) then
			isRightPopup = true;
			break;
		end
	end
	return isRightPopup;
end

-- Does things with the hooked function
function RestReminder_StaticPopup_Show(which, ...)
	if ( ( RestReminder_Enabled == 1 ) and ( RestReminder_IsRightPopup(which) ) ) then
		if ( not IsResting() ) then
			RestReminder_Warning(TEXT(RESTREMINDER_WARNING));
		end
	end
	return RestReminder_Saved_StaticPopup_Show(which, unpack(arg));
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function RestReminder_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( StaticPopup_Show ~= RestReminder_StaticPopup_Show ) and (RestReminder_Saved_StaticPopup_Show == nil) ) then
			RestReminder_Saved_StaticPopup_Show = StaticPopup_Show;
			StaticPopup_Show = RestReminder_StaticPopup_Show;
		end
	else
		if ( StaticPopup_Show == RestReminder_StaticPopup_Show) then
			StaticPopup_Show = RestReminder_Saved_StaticPopup_Show;
			RestReminder_Saved_StaticPopup_Show = nil;
		end
	end
end

-- Handles events
function RestReminder_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( RestReminder_Cosmos_Registered == 0 ) then
			local value = getglobal("RestReminder_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			RestReminder_Toggle_Enabled(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function RestReminder_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			RestReminder_Print(text);
		end
	end
	RestReminder_Register_Cosmos();
	RegisterForSave(variableName);
	if ( RestReminder_Cosmos_Registered == 1 ) then 
		RestReminder_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		RestReminder_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

function RestReminder_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function RestReminder_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the RestReminder
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function RestReminder_Toggle_Enabled(toggle)
	RestReminder_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function RestReminder_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = RestReminder_Generic_Toggle(toggle, "RestReminder_Enabled", "COS_RESTREMINDER_ENABLED_X", "RESTREMINDER_CHAT_ENABLED", "RESTREMINDER_CHAT_DISABLED");
	else
		newvalue = RestReminder_Generic_Toggle(toggle, "RestReminder_Enabled", "COS_RESTREMINDER_ENABLED_X");
	end
	RestReminder_Setup_Hooks(newvalue);
end

-- toggling - no text
function RestReminder_Toggle_Enabled_NoChat(toggle)
	RestReminder_DoToggle_Enabled(toggle, false);
end

-- Prints out text to a chat box.
function RestReminder_Print(msg,r,g,b,frame,id,unknown4th)
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
