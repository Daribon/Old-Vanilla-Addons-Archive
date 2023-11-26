--[[
	SpellChecker

	By sarf

	This mod allows you to spellcheck and auto-correct messages that you send.
	Currently, it completely ignores slash-commands.

	Thanks goes to Bhaerau for suggesting it.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=N/A
	
   ]]


-- Constants

-- Variables
SpellChecker_Words = {};
SpellChecker_Enabled = 0;

SpellChecker_Saved_ChatEdit_ParseText = nil;
--ChatEdit_OnEnterPressed
SpellChecker_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function SpellChecker_OnLoad()
	SpellChecker_Register();
end

-- registers the mod with Cosmos
function SpellChecker_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( SpellChecker_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_SPELLCHECKER",
			"SECTION",
			TEXT(SPELLCHECKER_CONFIG_HEADER),
			TEXT(SPELLCHECKER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_SPELLCHECKER_HEADER",
			"SEPARATOR",
			TEXT(SPELLCHECKER_CONFIG_HEADER),
			TEXT(SPELLCHECKER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_SPELLCHECKER_ENABLED",
			"CHECKBOX",
			TEXT(SPELLCHECKER_ENABLED),
			TEXT(SPELLCHECKER_ENABLED_INFO),
			SpellChecker_Toggle_Enabled_NoChat,
			SpellChecker_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local SpellCheckerMainCommands = {"/spellchecker","/spellcheck","/sc"};
			Cosmos_RegisterChatCommand (
				"SPELLCHECKER_MAIN_COMMANDS", -- Some Unique Group ID
				SpellCheckerMainCommands, -- The Commands
				SpellChecker_Main_ChatCommandHandler,
				SPELLCHECKER_CHAT_COMMAND_INFO -- Description String
			);
		end
		SpellChecker_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function SpellChecker_Register()
	if ( Cosmos_RegisterConfiguration ) then
		SpellChecker_Register_Cosmos();
	else
		SlashCmdList["SPELLCHECKERSLASHMAIN"] = SpellChecker_Main_ChatCommandHandler;
		SLASH_SPELLCHECKERSLASHMAIN1 = "/spellchecker";
		SLASH_SPELLCHECKERSLASHMAIN2 = "/spellcheck";
		SLASH_SPELLCHECKERSLASHMAIN3 = "/sc";
	end
	RegisterForSave("SpellChecker_Words");
	this:RegisterEvent("VARIABLES_LOADED");
end

function SpellChecker_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the SpellChecker
function SpellChecker_Main_ChatCommandHandler(msg)
	
	local func = SpellChecker_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		SpellChecker_Print(SPELLCHECKER_CHAT_COMMAND_USAGE);
		SpellChecker_Print(SPELLCHECKER_CHAT_COMMAND_USAGE_EXAMPLE);
		return;
	end
	
	local commandName, params = SpellChecker_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = SpellChecker_Toggle_Enabled;
	elseif ( ( strfind( commandName, "add" ) ) or ( strfind( commandName, "modify" ) ) or ( strfind( commandName, "delete" ) ) ) then
		local firstWord, secondWord;
		firstWord, params = SpellChecker_Extract_NextParameter(params);
		secondWord, params = SpellChecker_Extract_NextParameter(params);
		SpellChecker_Modify_Word(firstWord, secondWord);
		return;
	elseif ( ( strfind( commandName, "show" ) ) or ( strfind( commandName, "list" ) ) ) then
		local firstWord;
		firstWord, params = SpellChecker_Extract_NextParameter(params);
		SpellChecker_Show_Word(firstWord);
		return;
	else
		SpellChecker_Print(SPELLCHECKER_CHAT_COMMAND_USAGE);
		SpellChecker_Print(SPELLCHECKER_CHAT_COMMAND_USAGE_EXAMPLE);
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
function SpellChecker_ChatEdit_ParseText(editBox, send)
	if ( ( SpellChecker_Enabled == 1 ) and ( send == 1 ) ) then
		local text = editBox:GetText();
		text = SpellChecker_Translate(text);
		editBox:SetText(text);
	end
	SpellChecker_Saved_ChatEdit_ParseText(editBox, send);
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function SpellChecker_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( ChatEdit_ParseText ~= SpellChecker_ChatEdit_ParseText ) and (SpellChecker_Saved_ChatEdit_ParseText == nil) ) then
			SpellChecker_Saved_ChatEdit_ParseText = ChatEdit_ParseText;
			ChatEdit_ParseText = SpellChecker_ChatEdit_ParseText;
		end
	else
		if ( ChatEdit_ParseText == SpellChecker_ChatEdit_ParseText) then
			ChatEdit_ParseText = SpellChecker_Saved_ChatEdit_ParseText;
			SpellChecker_Saved_ChatEdit_ParseText = nil;
		end
	end
end

-- Handles events
function SpellChecker_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( SpellChecker_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_SPELLCHECKER_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			SpellChecker_Toggle_Enabled(value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function SpellChecker_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			SpellChecker_Print(text);
		end
	end
	SpellChecker_Register_Cosmos();
	if ( SpellChecker_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		SpellChecker_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		SpellChecker_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- Sets the value of an option.
function SpellChecker_Generic_Value(value, variableName, CVarName, message, formatValueMessage)
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
			SpellChecker_Print(text);
		end
	end
	SpellChecker_Register_Cosmos();
	if ( SpellChecker_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		SpellChecker_Generic_CosmosUpdateValue(CVarName, newvalue);
		SpellChecker_Generic_CosmosUpdateValue(CosmosVarName, newvalue);
	end
	return newvalue;
end

function SpellChecker_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function SpellChecker_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the SpellChecker
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function SpellChecker_Toggle_Enabled(toggle)
	SpellChecker_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function SpellChecker_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = SpellChecker_Generic_Toggle(toggle, "SpellChecker_Enabled", "COS_SPELLCHECKER_ENABLED_X", "SPELLCHECKER_CHAT_ENABLED", "SPELLCHECKER_CHAT_DISABLED");
	else
		newvalue = SpellChecker_Generic_Toggle(toggle, "SpellChecker_Enabled", "COS_SPELLCHECKER_ENABLED_X");
	end
	SpellChecker_Setup_Hooks(newvalue);
end

-- toggling - no text
function SpellChecker_Toggle_Enabled_NoChat(toggle)
	SpellChecker_DoToggle_Enabled(toggle, false);
end

-- Prints out text to a chat box.
function SpellChecker_Print(msg,r,g,b,frame,id,unknown4th)
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

--
-- snagged from Sea.util.split - all credit to Sea!
--
function SpellChecker_Split( text, separator ) 
	local t = {};
	t.n = 0;
	for value in string.gfind(text,"[^"..separator.."]+") do
		t.n = t.n + 1;
		t[t.n] = value;
	end
	return t;
end;

--
-- some code snagged from Sea - Sea.string.capitalizeWords. Much credit to Sea!
--
function SpellChecker_Translate(message)
	if ( ( not message ) or ( strlen(message) <= 0 ) ) then
		return "";
	end
	if ( strsub(message, 1, 1) == "/" ) then
		return message;
	end

	local words = SpellChecker_Split(message, " ");
	local translatedPhrase = "";

	local trans = nil;
	for i=1,words.n do 
		local v = words[i];
		if ( i ~= 1 ) then
			translatedPhrase = translatedPhrase.." ";
		end
		local trans = SpellChecker_Words[v];
		if ( trans ) then
			v = trans;
		end
		translatedPhrase = translatedPhrase..v;
	end

	return translatedPhrase;
end

function SpellChecker_Modify_Word(firstWord, secondWord)
	if ( ( not firstWord ) or ( strlen(firstWord) <= 0 ) ) then
		SpellChecker_Print(SPELLCHECKER_CHAT_WORD_NOT_SPECIFIED);
	else
		local oldCorr = SpellChecker_Words[firstWord];
		if ( ( not secondWord ) or ( strlen(secondWord) <= 0 ) ) then
			if ( ( not oldCorr ) or ( strlen(oldCorr) <= 0 ) ) then
				SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_DELETED_NONE, firstWord));
			else
				SpellChecker_Words[firstWord] = nil;
				SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_DELETED, firstWord));
			end
		else
			SpellChecker_Words[firstWord] = secondWord;
			if ( ( not oldCorr ) or ( strlen(oldCorr) <= 0 ) ) then
				SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_ADDED, firstWord, secondWord));
			else
				SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_MODIFIED, firstWord, secondWord));
			end
		end
	end
	
end

function SpellChecker_Show_Word(firstWord)
	if ( ( not firstWord ) or ( strlen(firstWord) <= 0 ) ) then
		SpellChecker_Print(SPELLCHECKER_CHAT_WORD_SHOW_LIST);
		for k, v in SpellChecker_Words do
			SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_SHOW_LIST_FORMAT, k, v));
		end
	else
		local corr = SpellChecker_Words[firstWord];
		if ( corr ) then
			SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_SHOW, firstWord, corr));
		else
			SpellChecker_Print(format(SPELLCHECKER_CHAT_WORD_SHOW_NONE, firstWord));
		end
	end
end