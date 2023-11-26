--[[
	Chat Traffic

	By sarf

	This mod allows the user to restrain the amount of chat traffic that his or her client sends.

	Thanks goes to the load of people who complained about getting disconnected. Whiners... ;)
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=1614
	
   ]]


-- Constants
CHATTRAFFIC_TIME_SAVED_MAX = 2;

CHATTRAFFIC_CHARACTERSPERSECOND_MIN = 30;
CHATTRAFFIC_CHARACTERSPERSECOND_MAX = 512;

CHATTRAFFIC_TRAFFIC_DELAY = 0.2;

-- how big a chunk of the "cps left" needs to be unused for big messages to be passed through
CHATTRAFFIC_TRAFFIC_BIG_MESSAGE_CHUNK = 0.9;

-- Variables
ChatTraffic_Enabled = 1;
ChatTraffic_CharactersPerSecond = 255;

-- contains the current traffic statistics
ChatTraffic_Traffic = {};

ChatTraffic_Saved_SendChatMessage = nil;
ChatTraffic_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function ChatTraffic_OnLoad()
	ChatTraffic_Register();
end

-- registers the mod with Cosmos
function ChatTraffic_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( ChatTraffic_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_CHATTRAFFIC",
			"SECTION",
			TEXT(CHATTRAFFIC_CONFIG_HEADER),
			TEXT(CHATTRAFFIC_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_CHATTRAFFIC_HEADER",
			"SEPARATOR",
			TEXT(CHATTRAFFIC_CONFIG_HEADER),
			TEXT(CHATTRAFFIC_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_CHATTRAFFIC_ENABLED",
			"CHECKBOX",
			TEXT(CHATTRAFFIC_ENABLED),
			TEXT(CHATTRAFFIC_ENABLED_INFO),
			ChatTraffic_Toggle_Enabled_NoChat,
			ChatTraffic_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_CHATTRAFFIC_CPS",
			"SLIDER",
			TEXT(CHATTRAFFIC_CHARACTERS_PER_SECOND),
			TEXT(CHATTRAFFIC_CHARACTERS_PER_SECOND_INFO),
			ChatTraffic_Change_CharactersPerSecond_NoChat,
			1,
			ChatTraffic_CharactersPerSecond,
			CHATTRAFFIC_CHARACTERSPERSECOND_MIN,
			CHATTRAFFIC_CHARACTERSPERSECOND_MAX,
			CHATTRAFFIC_CPS_SLIDER_DESCRIPTION,
			1,
			1,
			CHATTRAFFIC_CPS_SLIDER_APPEND,
			1
		);
		if ( Cosmos_RegisterChatCommand ) then
			local ChatTrafficMainCommands = {"/chattraffic","/ct"};
			Cosmos_RegisterChatCommand (
				"CHATTRAFFIC_MAIN_COMMANDS", -- Some Unique Group ID
				ChatTrafficMainCommands, -- The Commands
				ChatTraffic_Main_ChatCommandHandler,
				CHATTRAFFIC_CHAT_COMMAND_INFO -- Description String
			);
		end
		ChatTraffic_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function ChatTraffic_Register()
	if ( Cosmos_RegisterConfiguration ) then
		ChatTraffic_Register_Cosmos();
	else
		SlashCmdList["CHATTRAFFICSLASHMAIN"] = ChatTraffic_Main_ChatCommandHandler;
		SLASH_CHATTRAFFICSLASHMAIN1 = "/chattraffic";
		SLASH_CHATTRAFFICSLASHMAIN2 = "/ct";
		this:RegisterEvent("VARIABLES_LOADED");
	end
end

function ChatTraffic_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the ChatTraffic
function ChatTraffic_Main_ChatCommandHandler(msg)
	
	local func = ChatTraffic_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		ChatTraffic_Print(CHATTRAFFIC_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = ChatTraffic_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = ChatTraffic_Toggle_Enabled;
	elseif ( ( strfind( commandName, "cps" ) ) or ( strfind( commandName, "traffic" ) ) )then
		func = ChatTraffic_Change_CharactersPerSecond;
		toggleFunc = false;
		local cps = nil;
		cps, params = ChatTraffic_Extract_NextParameter(params);
		func(cps);
		return;
	else
		ChatTraffic_Print(CHATTRAFFIC_CHAT_COMMAND_USAGE);
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

function ChatTraffic_GetMaximumCharactersPerSecondLeft()
	return ( ChatTraffic_CharactersPerSecond * CHATTRAFFIC_TIME_SAVED_MAX );
end

function ChatTraffic_GetCharactersPerSecondLeft()
	ChatTraffic_UpdateTrafficSent();
	local i = 0;
	for k, v in ChatTraffic_Traffic do
		i = i + v.chars;
	end
	return ( ChatTraffic_GetMaximumCharactersPerSecondLeft() - i);
end

function ChatTraffic_ExemptFromTrafficLimitation(message)
	if ( ( not message ) or ( strlen(message) <= 0 ) or ( strsub(message, 1, 1) == "/") ) then
		return true;
	else
		return false;
	end
end

function ChatTraffic_AddTrafficSent(message)
	if ( ChatTraffic_ExemptFromTrafficLimitation(message) ) then
		return;
	end
	ChatTraffic_UpdateTrafficSent();
	table.insert(ChatTraffic_Traffic, { chars = strlen(message), time = GetTime() } );
end

function ChatTraffic_UpdateTrafficSent()
	local curTime = GetTime();
	local removeIndices = {};
	for k, v in ChatTraffic_Traffic do
		if ( curTime-v.time >= CHATTRAFFIC_TIME_SAVED_MAX ) then
			table.insert(removeIndices, k);
		end
	end
	for k, v in removeIndices do
		table.remove(ChatTraffic_Traffic, v);
	end
end

-- Does things with the hooked function
function ChatTraffic_SendChatMessage(message, ...)
	if ( ( ChatTraffic_Enabled == 1 ) and ( not ChatTraffic_ExemptFromTrafficLimitation(message) ) ) then
		local messageLen = strlen(message);
		local maxTraffic = ChatTraffic_GetMaximumCharactersPerSecondLeft();
		local currentTrafficLeft = ChatTraffic_GetCharactersPerSecondLeft();
		if ( messageLen >= maxTraffic ) then
			if ( currentTrafficLeft >= (maxTraffic*CHATTRAFFIC_TRAFFIC_BIG_MESSAGE_CHUNK) ) then
				ChatTraffic_Saved_SendChatMessage(message, unpack(arg));
				ChatTraffic_AddTrafficSent(message);
				return;
			end
		end
		if ( currentTrafficLeft < messageLen ) then
			Cosmos_Schedule(CHATTRAFFIC_TRAFFIC_DELAY, ChatTraffic_SendChatMessage, message, unpack(arg));
			return;
		else
			ChatTraffic_AddTrafficSent(message);
		end
	end
	ChatTraffic_Saved_SendChatMessage(message, unpack(arg));
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function ChatTraffic_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( SendChatMessage ~= ChatTraffic_SendChatMessage ) and (ChatTraffic_Saved_SendChatMessage == nil) ) then
			ChatTraffic_Saved_SendChatMessage = SendChatMessage;
			SendChatMessage = ChatTraffic_SendChatMessage;
		end
	else
		if ( SendChatMessage == ChatTraffic_SendChatMessage) then
			SendChatMessage = ChatTraffic_Saved_SendChatMessage;
			ChatTraffic_Saved_SendChatMessage = nil;
		end
	end
end

-- Handles events
function ChatTraffic_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( ChatTraffic_Cosmos_Registered == 0 ) then
			local value = getglobal("ChatTraffic_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			ChatTraffic_Toggle_Enabled(value);
			local value = getglobal("ChatTraffic_CharactersPerSecond");
			if (value == nil ) then
				-- defaults to 60
				value = 60;
			end
			ChatTraffic_Change_CharactersPerSecond(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ChatTraffic_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			ChatTraffic_Print(text);
		end
	end
	ChatTraffic_Register_Cosmos();
	if ( ChatTraffic_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		ChatTraffic_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		ChatTraffic_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

function ChatTraffic_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function ChatTraffic_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the ChatTraffic
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ChatTraffic_Toggle_Enabled(toggle)
	ChatTraffic_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function ChatTraffic_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = ChatTraffic_Generic_Toggle(toggle, "ChatTraffic_Enabled", "COS_CHATTRAFFIC_ENABLED_X", "CHATTRAFFIC_CHAT_ENABLED", "CHATTRAFFIC_CHAT_DISABLED");
	else
		newvalue = ChatTraffic_Generic_Toggle(toggle, "ChatTraffic_Enabled", "COS_CHATTRAFFIC_ENABLED_X");
	end
	ChatTraffic_Setup_Hooks(newvalue);
end

-- toggling - no text
function ChatTraffic_Toggle_Enabled_NoChat(toggle)
	ChatTraffic_DoToggle_Enabled(toggle, false);
end

function ChatTraffic_Change_CharactersPerSecond_NoChat(toggle, value)
	ChatTraffic_DoChange_CharactersPerSecond(value, "ChatTraffic_CharactersPerSecond", "COS_CHATTRAFFIC_CPS");
end

function ChatTraffic_Change_CharactersPerSecond(value)
	ChatTraffic_DoChange_CharactersPerSecond(value, "ChatTraffic_CharactersPerSecond", "COS_CHATTRAFFIC_CPS", "CHATTRAFFIC_CHAT_CHARACTERS_PER_SECOND");
end

function ChatTraffic_DoChange_CharactersPerSecond(value, variableName, CVarName, message, CosmosVarName)
	local oldvalue = getglobal(variableName);
	local newvalue = value;
	if ( newvalue <= CHATTRAFFIC_CHARACTERSPERSECOND_MIN ) then
		newvalue = CHATTRAFFIC_CHARACTERSPERSECOND_MIN;
	end
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		local text = "";
		if ( message ) then
			text = TEXT(getglobal(message));
		end
		if ( text ) and ( strlen(text) > 0 ) then
			ChatTraffic_Print(text);
		end
	end
	ChatTraffic_Register_Cosmos();
	if ( ChatTraffic_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		ChatTraffic_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		ChatTraffic_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- Prints out text to a chat box.
function ChatTraffic_Print(msg,r,g,b,frame,id,unknown4th)
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
	if (not b) then b = 0.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end
