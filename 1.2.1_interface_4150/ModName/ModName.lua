--[[
	Mod Name

	By sarf

	This mod ...

	Thanks goes to 
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

-- Variables
ModName_Enabled = 0;

ModName_Saved_Hooked_Function = nil;
ModName_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function ModName_OnLoad()
	ModName_Register();
end

-- registers the mod with Cosmos
function ModName_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( ModName_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_MODNAME",
			"SECTION",
			TEXT(MODNAME_CONFIG_HEADER),
			TEXT(MODNAME_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_MODNAME_HEADER",
			"SEPARATOR",
			TEXT(MODNAME_CONFIG_HEADER),
			TEXT(MODNAME_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_MODNAME_ENABLED",
			"CHECKBOX",
			TEXT(MODNAME_ENABLED),
			TEXT(MODNAME_ENABLED_INFO),
			ModName_Toggle_Enabled_NoChat,
			ModName_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local ModNameMainCommands = {"/modname","/mn"};
			Cosmos_RegisterChatCommand (
				"MODNAME_MAIN_COMMANDS", -- Some Unique Group ID
				ModNameMainCommands, -- The Commands
				ModName_Main_ChatCommandHandler,
				MODNAME_CHAT_COMMAND_INFO -- Description String
			);
		end
		ModName_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function ModName_Register()
	if ( Cosmos_RegisterConfiguration ) then
		ModName_Register_Cosmos();
	else
		SlashCmdList["MODNAMESLASHMAIN"] = ModName_Main_ChatCommandHandler;
		SLASH_MODNAMESLASHMAIN1 = "/modname";
		SLASH_MODNAMESLASHMAIN2 = "/mn";
		this:RegisterEvent("VARIABLES_LOADED");
	end
end

function ModName_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the ModName
function ModName_Main_ChatCommandHandler(msg)
	
	local func = ModName_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		ModName_Print(MODNAME_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = ModName_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = ModName_Toggle_Enabled;
	else
		ModName_Print(MODNAME_CHAT_COMMAND_USAGE);
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

-- Does things with the hooked function
function ModName_Hooked_Function()
	if ( ModName_Enabled == 1 ) then
	end
	ModName_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function ModName_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= ModName_Hooked_Function ) and (ModName_Saved_Hooked_Function == nil) ) then
			ModName_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = ModName_Hooked_Function;
		end
	else
		if ( Hooked_Function == ModName_Hooked_Function) then
			Hooked_Function = ModName_Saved_Hooked_Function;
			ModName_Saved_Hooked_Function = nil;
		end
	end
end

-- Handles events
function ModName_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( ModName_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_MODNAME_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			ModName_Toggle_Enabled(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ModName_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			ModName_Print(text);
		end
	end
	ModName_Register_Cosmos();
	if ( ModName_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		ModName_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		ModName_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- Sets the value of an option.
function ModName_Generic_Value(value, variableName, CVarName, message, formatValueMessage)
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
			ModName_Print(text);
		end
	end
	ModName_Register_Cosmos();
	if ( ModName_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		ModName_Generic_CosmosUpdateValue(CVarName, newvalue);
		ModName_Generic_CosmosUpdateValue(CosmosVarName, newvalue);
	end
	return newvalue;
end

function ModName_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function ModName_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the ModName
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ModName_Toggle_Enabled(toggle)
	ModName_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function ModName_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = ModName_Generic_Toggle(toggle, "ModName_Enabled", "COS_MODNAME_ENABLED_X", "MODNAME_CHAT_ENABLED", "MODNAME_CHAT_DISABLED");
	else
		newvalue = ModName_Generic_Toggle(toggle, "ModName_Enabled", "COS_MODNAME_ENABLED_X");
	end
	ModName_Setup_Hooks(newvalue);
end

-- toggling - no text
function ModName_Toggle_Enabled_NoChat(toggle)
	ModName_DoToggle_Enabled(toggle, false);
end

-- Prints out text to a chat box.
function ModName_Print(msg,r,g,b,frame,id,unknown4th)
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
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end
