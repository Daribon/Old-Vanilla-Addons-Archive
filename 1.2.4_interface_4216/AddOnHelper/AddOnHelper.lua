--[[
	AddOnHelper

	By sarf

	This mod is meant to give some helping functions for AddOns.

   ]]


-- Constants

-- Variables

AddOnHelper_ToggleFunctions = {};

-- executed on load, calls general set-up functions
function AddOnHelper_OnLoad()
end

function AddOnHelper_AddSlashCommand(identifier, slashcommands, func, description)
	if ( not description ) then description = ""; end
	if ( type(identifier) == "table" ) then
		return AddOnHelper_AddSlashCommandTable(identifier);
	else
		local arr = {};
		arr.identifier = identifier;
		arr.slashcommands = slashcommands;
		arr.func = func;
		arr.description = description;
		return AddOnHelper_AddSlashCommandTable(arr);
	end
end

function AddOnHelper_AddSlashCommandTable(values)
	if ( not values) or ( type(values) ~= "table" ) then
		return false;
	end
	if ( not values.slashcommands ) then return false; end
	if ( type(values.slashcommands) ~= "table" ) then values.slashcommands = { values.slashcommands }; end
	if ( not values.description ) then values.description = ""; end
	if ( Sky ) and ( Sky.registerSlashCommand ) then
		Sky.registerSlashCommand({ 
			id = values.identifier,
			commands = values.slashcommands,
			onExecute = values.func,
			helpText = values.description,
			action = "before",
		});
	elseif ( Cosmos_RegisterChatCommand ) then
		Cosmos_RegisterChatCommand (
			values.identifier, -- Some Unique Group ID
			values.slashcommands, -- The Commands
			values.func,
			values.description -- Description String
		);
	else
		SlashCmdList[values.identifier] = values.func;
		local i = 1;
		for k, v in values.slashcommands do
			setglobal(string.format(ADDONHELPER_SLASHFORMAT, values.identifier, i), string.lower(v));
			i = i + 1;
		end
	end
	return true;
end

function AddOnHelper_Extract_NextParameter(msg)
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

-- Handles events
function AddOnHelper_OnEvent(event)
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AddOnHelper_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			AddOnHelper_Print(text);
		end
	end
	RegisterForSave(variableName);
	if ( AddOnHelper_Cosmos_Registered == 1 ) then 
		AddOnHelper_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		AddOnHelper_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- Sets the value of an option.
function AddOnHelper_Generic_Value(value, variableName, CVarName, message, formatValueMessage)
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
			AddOnHelper_Print(text);
		end
	end
	AddOnHelper_Register_Cosmos();
	RegisterForSave(variableName);
	if ( AddOnHelper_Cosmos_Registered == 1 ) then 
		AddOnHelper_Generic_CosmosUpdateValue(CVarName, newvalue);
		AddOnHelper_Generic_CosmosUpdateValue(CosmosVarName, newvalue);
	end
	return newvalue;
end

function AddOnHelper_Generic_CosmosUpdateCheckOnOff(varName, value)
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
	if ( CosmosMaster_DrawData ) then
		CosmosMaster_DrawData();
	end
end

function AddOnHelper_Generic_CosmosUpdateValue(varName, value)
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
		Cosmos_UpdateValue(name.."_X", CSM_SLIDERVALUE, value);
	end
	if ( CosmosMaster_DrawData ) then
		CosmosMaster_DrawData();
	end
end


function AddOnHelper_CreateToggleFunction(functionName, variableName, chatEnabled, chatDisabled, cosmosVariableName)
	if ( variableName ) and ( type(variableName) == "table" ) then 
		return AddOnHelper_CreateToggleFunctionTable(variableName); 
	end
	if ( not cosmosVariableName ) then cosmosVariableName = ""; end
	local arr = {};
	arr.functionName = functionName;
	arr.variableName = variableName;
	arr.chatEnabled = chatEnabled;
	arr.chatDisabled = chatDisabled;
	arr.cosmosVariableName = cosmosVariableName;
	return AddOnHelper_CreateToggleFunctionTable(arr);
end

function AddOnHelper_CreateToggleFunctionTable(values)
	if ( not values ) or ( type(values) ~= "table" ) then return false; end
	if ( not values.functionName ) then return false; end
	if ( not values.cosmosVariableName ) then values.cosmosVariableName = ""; end
	if ( AddOnHelper_ToggleFunctions[values.functionName] ) then
		AddOnHelper_Print(string.format(ADDONHELPER_TOGGLEFUNCOVERWRITE, values.functionName));
		return false;
	end
	AddOnHelper_ToggleFunctions[values.functionName] = values;
	return true;
end

function AddOnHelper_HandleToggleFunction(functionName, toggle, showText)
	local arr = AddOnHelper_ToggleFunctions[functionName];
	if ( not arr ) then
		local str = ADDONHELPER_NOTOGGLEFUNC;
		if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
			str = str..ADDONHELPER_NOTOGGLEFUNC_COSMOS;
		end
		AddOnHelper_Print(string.format(str, functionName));
		return nil;
	end
	local newvalue = 0;
	if ( showText ) then
		newvalue = AddOnHelper_Generic_Toggle(toggle, arr.variableName, arr.variableName, arr.chatEnabled, arr.chatDisabled);
	else
		newvalue = AddOnHelper_Generic_Toggle(toggle, arr.variableName, arr.cosmosVariableName);
	end
	return newvalue;
end

-- Prints out text to a chat box.
function AddOnHelper_Print(msg,r,g,b,frame,id,unknown4th)
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
