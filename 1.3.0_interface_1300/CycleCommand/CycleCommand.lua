--[[
	Cycle Command

	By sarf

	This mod allows you to create commands that, when you execute it, will execute the current command then cycle to a new one.

	Thanks goes to Uranium - 235 on the CosmosUI forums for the idea.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=749

   ]]


-- Constants

-- Variables
CycleCommand_Enabled = 0;

CycleCommand_CommandsArray = {};
CycleCommand_CommandsIndex = {};

CycleCommand_Saved_Hooked_Function = nil;
CycleCommand_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function CycleCommand_OnLoad()
	CycleCommand_Register();
end

function CycleCommand_MeddleWithCommand(command, cycleCommands)
	if ( not command ) then return; end
	if ( CycleCommand_CommandsArray[command] ) then
		if ( ( not cycleCommands ) or ( getn(cycleCommands) <= 0 ) ) then
			CycleCommand_CommandsArray[command] = nil;
			CycleCommand_Print(format(CYCLECOMMAND_CHAT_COMMAND_REMOVED, command));
		else
			CycleCommand_CommandsArray[command] = cycleCommands;
			CycleCommand_Print(format(CYCLECOMMAND_CHAT_COMMAND_UPDATED, command));
		end
	else
		if ( ( cycleCommands ) and ( getn(cycleCommands) > 0 ) ) then
			CycleCommand_CommandsArray[command] = cycleCommands;
			CycleCommand_Print(format(CYCLECOMMAND_CHAT_COMMAND_CREATED, command));
		else
			CycleCommand_Print(CYCLECOMMAND_CHAT_CYCLE_NOCOMMANDS);
		end
	end
end

-- registers the mod with Cosmos
function CycleCommand_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( CycleCommand_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_CYCLECOMMAND",
			"SECTION",
			TEXT(CYCLECOMMAND_CONFIG_HEADER),
			TEXT(CYCLECOMMAND_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_CYCLECOMMAND_HEADER",
			"SEPARATOR",
			TEXT(CYCLECOMMAND_CONFIG_HEADER),
			TEXT(CYCLECOMMAND_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_CYCLECOMMAND_ENABLED",
			"CHECKBOX",
			TEXT(CYCLECOMMAND_ENABLED),
			TEXT(CYCLECOMMAND_ENABLED_INFO),
			CycleCommand_Toggle_Enabled,
			CycleCommand_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local CycleCommandEnableCommands = {"/cyclecommandtoggle","/cctoggle","/cyclecommandenable","/ccenable","/cyclecommanddisable","/ccdisable"};
			Cosmos_RegisterChatCommand (
				"CYCLECOMMAND_ENABLE_COMMANDS", -- Some Unique Group ID
				CycleCommandEnableCommands, -- The Commands
				CycleCommand_Enable_ChatCommandHandler,
				CYCLECOMMAND_CHAT_COMMAND_ENABLE_INFO -- Description String
			);
			local CycleCommandCycleCommands = {"/cyclecommand","/cc"};
			Cosmos_RegisterChatCommand (
				"CYCLECOMMAND_CYCLE_COMMANDS", -- Some Unique Group ID
				CycleCommandCycleCommands, -- The Commands
				CycleCommand_Cycle_ChatCommandHandler,
				CYCLECOMMAND_CHAT_COMMAND_CYCLE_INFO -- Description String
			);
		end
		CycleCommand_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function CycleCommand_Register()
	if ( Cosmos_RegisterConfiguration ) then
		CycleCommand_Register_Cosmos();
	else
		SlashCmdList["CYCLECOMMANDSLASHENABLE"] = CycleCommand_Enable_ChatCommandHandler;
		SLASH_CYCLECOMMANDSLASHENABLE1 = "/cyclecommandtoggle";
		SLASH_CYCLECOMMANDSLASHENABLE2 = "/cctoggle";
		SLASH_CYCLECOMMANDSLASHENABLE3 = "/cyclecommandenable";
		SLASH_CYCLECOMMANDSLASHENABLE4 = "/ccenable";
		SLASH_CYCLECOMMANDSLASHENABLE5 = "/cyclecommanddisable";
		SLASH_CYCLECOMMANDSLASHENABLE6 = "/ccdisable";
		SlashCmdList["CYCLECOMMANDSLASHCYCLE"] = CycleCommand_Cycle_ChatCommandHandler;
		SLASH_CYCLECOMMANDSLASHCYCLE1 = "/cyclecommand";
		SLASH_CYCLECOMMANDSLASHCYCLE2 = "/cc";
	end

	RegisterForSave("CycleCommand_CommandsArray");
	this:RegisterEvent("VARIABLES_LOADED");

end

function CycleCommand_Cycle_Usage()
	CycleCommand_Print(CYCLECOMMAND_CHAT_CYCLE_USAGE, 1.0, 1.0, 0);
end

function CycleCommand_GetCommands(str)
    local commands = {};
    local index = 0;
    while ( strlen(str) > 0 ) do
    	index = strfind(str, "##");
    	if ( index ) then
			table.insert(commands, strsub(str, 1, index-1));
			str = strsub(str, index+2);
		else
			table.insert(commands, str);
			str = "";
		end
	end
	return commands;
end

function CycleCommand_Extract_NextParameter(msg)
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

function CycleCommand_Cycle_ChatCommandHandler(msg)
	if ( ( not msg ) or ( strlen(msg) <= 0 ) ) then
		CycleCommand_Cycle_Usage();
		return;
	end
	local command, params = CycleCommand_Extract_NextParameter(msg);
	command = strlower(command);
	if ( ( not command ) or ( strlen(command) <= 0 ) ) then
		CycleCommand_Cycle_Usage();
		return;
	elseif ( ( command == "add" ) or ( command == "create" ) or ( command == "new" ) or ( command == "change" ) or ( command == "update" ) or ( command == "edit" ) ) then
		if ( ( not params ) or ( strlen(params) <= 0 ) ) then
			CycleCommand_Cycle_Usage();
			return;
		end
		local commandName;
		commandName, params = CycleCommand_Extract_NextParameter(params);
		if ( ( not commandName ) or ( strlen(commandName) <= 0 ) or (not params) or (strlen(params) <= 0) ) then
			CycleCommand_Cycle_Usage();
			return;
		end
		local commands = CycleCommand_GetCommands(params);
		
		CycleCommand_MeddleWithCommand(commandName, commands);
		return
	elseif ( ( command == "remove" ) or ( command == "delete" ) or ( command == "destroy" ) ) then
		if ( ( not params ) or ( strlen(params) <= 0 ) ) then
			CycleCommand_Cycle_Usage();
			return;
		end
		local commandName;
		commandName, params = CycleCommand_Extract_NextParameter(params);
		if ( ( not commandName ) or ( strlen(commandName) <= 0 ) ) then
			CycleCommand_Cycle_Usage();
			return;
		end
		CycleCommand_MeddleWithCommand(commandName, nil);
		return
	elseif ( ( command == "reset" ) ) then
		if ( ( not params ) or ( strlen(params) <= 0 ) ) then
			CycleCommand_Cycle_Usage();
			return;
		end
		local commandName;
		commandName, params = CycleCommand_Extract_NextParameter(params);
		if ( ( not commandName ) or ( strlen(commandName) <= 0 ) ) then
			CycleCommand_Cycle_Usage();
			return;
		end
		if ( not CycleCommand_CommandsArray[commandName] ) then
			CycleCommand_Print(format(CYCLECOMMAND_CHAT_NOSUCHCOMMAND, commandName));
			return;
		end
		CycleCommand_CommandsIndex[commandName] = 1;
		CycleCommand_Print(format(CYCLECOMMAND_CHAT_RESET, commandName));
		return;
	elseif ( ( command == "list" ) or ( command == "show" ) ) then
		local noParam = false;
		if ( ( not params ) or ( strlen(params) <= 0 ) ) then
			noParam = true;
		end
		if ( not noParam ) then
			local commandName;
			commandName, params = CycleCommand_Extract_NextParameter(params);
			if ( ( commandName ) and ( CycleCommand_CommandsArray[commandName] ) ) then
				CycleCommand_Print(commandName.." : "..CycleCommand_CommandsArray[commandName]);
			end
		end
		if ( noParam ) then
			for k, v in CycleCommand_CommandsArray do
				CycleCommand_Print(k);
			end
		end
		return;
	elseif ( ( command == "toggle" ) ) then
		if ( (string.find(params, 'on')) or ((string.find(params, '1')) and (not string.find(params, '-1')) ) ) then
			CycleCommand_Toggle_Enabled(1);
		else
			if ( (string.find(params, 'off')) or (string.find(params, '0')) ) then
				CycleCommand_Toggle_Enabled(0);
			else
				CycleCommand_Toggle_Enabled(-1);
			end
		end
		return;
	elseif ( ( command == "enable" ) or ( command == "on" ) ) then
		CycleCommand_Toggle_Enabled(1);
		return;
	elseif ( ( command == "disable" ) or ( command == "off" ) ) then
		CycleCommand_Toggle_Enabled(0);
		return;
	else
		local commandName = command;
		if ( command == "run" ) then
			if ( ( not params ) or ( strlen(params) <= 0 ) ) then
				CycleCommand_Cycle_Usage();
				return;
			end
			commandName, params = CycleCommand_Extract_NextParameter(params);
			if ( ( not commandName ) or ( strlen(commandName) <= 0 ) ) then
				CycleCommand_Cycle_Usage();
				return;
			end
			CycleCommand_Run(commandName);
			return;
		end
	end
end	

function CycleCommand_Run(commandName)
	if ( not CycleCommand_CommandsArray[commandName] ) then
		CycleCommand_Print(format(CYCLECOMMAND_CHAT_NOSUCHCOMMAND, commandName));
		return;
	end
	
	if ( CycleCommand_Enabled == 0 ) then
		CycleCommand_Print(CYCLECOMMAND_CHAT_IS_DISABLED);
		return
	end
	
	local currentIndex;
	if ( not CycleCommand_CommandsIndex[commandName] ) then
		CycleCommand_CommandsIndex[commandName] = 1;
	end
	currentIndex = CycleCommand_CommandsIndex[commandName];
	local maxIndex = getn(CycleCommand_CommandsArray[commandName]);
	if ( currentIndex > maxIndex ) then
		CycleCommand_CommandsIndex[commandName] = 1;
		currentIndex = 1;
	end
	local currentCommand = CycleCommand_CommandsArray[commandName][currentIndex];
	currentIndex = currentIndex + 1;
	if ( currentIndex > maxIndex ) then
		currentIndex = 1;
	end
	CycleCommand_CommandsIndex[commandName] = currentIndex;
	
	local str = "";
	local index = 0;
	while ( ( currentCommand ) and ( strlen(currentCommand) > 0 ) ) do
		index = strfind(currentCommand, "#CC#");
		if ( index ) then
			str = strsub(currentCommand, 1, index-1);
			currentCommand = strsub(currentCommand, index+4);
		else
			str = currentCommand;
			currentCommand = "";
		end
		CycleCommand_Execute(str);
	end
	
	return;
end

function CycleCommand_Execute(command)
	local editBox = ChatFrameEditBox;
	editBox:SetText(command);
	ChatEdit_SendText(editBox);
	ChatEdit_OnEscapePressed(editBox);
end


-- Handles chat - e.g. slashcommands - enabling/disabling the CycleCommand
function CycleCommand_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		CycleCommand_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			CycleCommand_Toggle_Enabled(0);
		else
			CycleCommand_Toggle_Enabled(-1);
		end
	end
end

-- Handles events
function CycleCommand_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( CycleCommand_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_CYCLECOMMAND_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			CycleCommand_Toggle_Enabled(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function CycleCommand_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
	if ( ( newvalue ~= oldvalue ) and ( TellTrack_Cosmos_Registered == 0 ) )  then
		if ( newvalue == 1 ) then
			CycleCommand_Print(TEXT(getglobal(enableMessage)));
		else
			CycleCommand_Print(TEXT(getglobal(disableMessage)));
		end
	end
	CycleCommand_Register_Cosmos();
	if ( CycleCommand_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		if ( CosmosVarName ) then
			Cosmos_UpdateValue(strsub(CosmosVarName, 1, strlen(CVarName)-2), CSM_CHECKONOFF, newvalue);
		else
			Cosmos_UpdateValue(strsub(CVarName, 1, strlen(CVarName)-2), CSM_CHECKONOFF, newvalue);
		end
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the CycleCommand
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function CycleCommand_Toggle_Enabled(toggle)
	local newvalue = CycleCommand_Generic_Toggle(toggle, "CycleCommand_Enabled", "COS_CYCLECOMMAND_ENABLED_X", "CYCLECOMMAND_CHAT_ENABLED", "CYCLECOMMAND_CHAT_DISABLED");
end

-- Prints out text to a chat box.
function CycleCommand_Print(msg,r,g,b,frame,id,unknown4th)
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
