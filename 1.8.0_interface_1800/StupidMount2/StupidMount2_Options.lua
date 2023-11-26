-- STUPIDMOUNT2_COMBAT START

STUPIDMOUNT2_KHAOS_SET_ID				= "StupidMount2SetID";

function StupidMount2_UpdateValue(name, value)
	StupidMount2_Options[name] = value;
end

function StupidMount2_Get_Khaos_CheckBox(pid, pkey, ptext, phelptext, pcheck, cb, fbFormat)
	local option1 = {
		id = pid;
		key = pkey;
		text = ptext;
		helptext = phelptext;
		check = true;
		callback = cb;
		type = K_TEXT;
		feedback = function(state) local s = STUPIDMOUNT2_STATE_ENABLED; if ( not state.checked ) then s = STUPIDMOUNT2_STATE_DISABLED; end return format(fbFormat, s); end;
		default = {
			checked = pcheck;
		};
		disabled = {
			checked = false;
		};
	};
	return option1;
end

function StupidMount2_Register_Khaos()
	if ( not Khaos ) then
		return false;
	end

	local optionSet = {
		id = STUPIDMOUNT2_KHAOS_SET_ID;
		text = STUPIDMOUNT2_KHAOS_SET_TEXT;
		helptext = STUPIDMOUNT2_KHAOS_SET_HELP;
		difficulty = 1;
		options = {};
		default = true;
	};

	local cb = function(state) StupidMount2_UpdateValue("enabled", state.checked); end;
	table.insert(optionSet.options, StupidMount2_Get_Khaos_CheckBox("CheckBoxEnabled", "enabled", STUPIDMOUNT2_KHAOS_ENABLE_TEXT, STUPIDMOUNT2_KHAOS_ENABLE_HELP, STUPIDMOUNT2_OPTIONS_DEFAULT.enabled, cb, STUPIDMOUNT2_CHAT_ENABLED));
	local cb2 = function(state) StupidMount2_UpdateValue("dismountInCombat", state.checked); end;
	table.insert(optionSet.options, StupidMount2_Get_Khaos_CheckBox("CheckBoxCombat", "dismountInCombat", STUPIDMOUNT2_KHAOS_COMBAT_TEXT, STUPIDMOUNT2_KHAOS_COMBAT_HELP, STUPIDMOUNT2_OPTIONS_DEFAULT.dismountInCombat, cb2, STUPIDMOUNT2_CHAT_COMBAT));

	Khaos.registerOptionSet( "other", optionSet );
	return true;
end

-- /script Old_StupidMount2_DoToggle_Checkbox = StupidMount2_DoToggle_Checkbox; StupidMount2_DoToggle_Checkbox = function(a, b, c, d, ...) PrintTable({a, b, d}); return Old_StupidMount2_DoToggle_Checkbox(a, b, c, d, unpack(arg)); end;
-- /script StupidMount2_DoToggle_Checkbox = Old_StupidMount2_DoToggle_Checkbox

function StupidMount2_DoToggle_Checkbox(cosName, varName, chatFormat, toggle, nochat)
	local newValue = nil;
	if ( toggle == 1 ) then
		newValue = true;
	else
		newValue = false;
	end
	StupidMount2_Options[varName] = newValue;
	if ( Khaos ) and ( varName ) then
		local v = Khaos.getSetKey(STUPIDMOUNT2_KHAOS_SET_ID, varName);
		if ( v ) then
			Khaos.setSetKeyParameter(STUPIDMOUNT2_KHAOS_SET_ID, varName, "checked", newValue);
		end
	end
	if ( not nochat ) then
		if ( StupidMount2_Options[varName] ) then
			AddOnHandler_Print(string.format(chatFormat), STUPIDMOUNT2_STATE_ENABLED);
		else
			AddOnHandler_Print(string.format(chatFormat), STUPIDMOUNT2_STATE_DISABLED);
		end
	end
	return newValue;
end

function StupidMount2_DoToggle_Enabled(toggle, nochat)
	return StupidMount2_DoToggle_Checkbox("COS_STUPIDMOUNT2_ENABLED", "enabled", STUPIDMOUNT2_CHAT_STATE, toggle, nochat);
end

function StupidMount2_Toggle_Enabled(toggle)
	return StupidMount2_DoToggle_Enabled(toggle);
end

function StupidMount2_Toggle_Enabled_NoChat(toggle)
	return StupidMount2_DoToggle_Enabled(toggle, true);
end

function StupidMount2_DoToggle_Gathering(toggle, nochat)
	return StupidMount2_DoToggle_Checkbox("COS_STUPIDMOUNT2_GATHERING", "handleGathering", STUPIDMOUNT2_CHAT_GATHERING, toggle, nochat);
end

function StupidMount2_Toggle_Gathering(toggle)
	return StupidMount2_DoToggle_Gathering(toggle);
end

function StupidMount2_Toggle_Gathering_NoChat(toggle)
	return StupidMount2_DoToggle_Gathering(toggle, true);
end

function StupidMount2_DoToggle_Mailbox(toggle, nochat)
	return StupidMount2_DoToggle_Checkbox("COS_STUPIDMOUNT2_MAILBOX", "handleMailbox", STUPIDMOUNT2_CHAT_MAILBOX, toggle, nochat);
end

function StupidMount2_Toggle_Mailbox(toggle)
	return StupidMount2_DoToggle_Mailbox(toggle);
end

function StupidMount2_Toggle_Mailbox_NoChat(toggle)
	return StupidMount2_DoToggle_Mailbox(toggle, true);
end

function StupidMount2_DoToggle_Combat(toggle, nochat)
	return StupidMount2_DoToggle_Checkbox("COS_STUPIDMOUNT2_COMBAT", "mountAfterCombat", STUPIDMOUNT2_CHAT_COMBAT, toggle, nochat);
end

function StupidMount2_Toggle_Combat(toggle)
	return StupidMount2_DoToggle_Combat(toggle);
end

function StupidMount2_Toggle_Combat_NoChat(toggle)
	return StupidMount2_DoToggle_Combat(toggle, true);
end

function StupidMount2_Usage()
	for k, v in STUPIDMOUNT2_OPTIONS_CMD_USAGE do
		StupidMount2_Print(v);
	end
end

function StupidMount2_SlashCommand_Set(msg)
	local featString, params = StupidMount2_Extract_NextParameter(msg);
	local feat = nil;
	for k, v in STUPIDMOUNT2_OPTIONS_SLASH_FEAT do
		for key, value in v do
			if ( value == featString ) then
				feat = k;
				break;
			end
		end
	end
	if ( not feat ) then
		StupidMount2_Print(STUPIDMOUNT2_ERROR_ILLEGAL_FEAT, 1, 0.2, 0.2);
		StupidMount2_Usage()
		return false;
	end
	local valueString;
	valueString, params = StupidMount2_Extract_NextParameter(params);
	local value = tonumber(valueString);
	if ( not value ) then
		StupidMount2_Print(STUPIDMOUNT2_ERROR_NO_VALUE_TO_SET);
		return false;
	end
	
	local wasValid = false;
	for key, value in STUPIDMOUNT2_CMD_FEAT_VALID[cmd] do
		if ( value == feat ) then
			wasValid = true;
			break;
		end
	end
	if ( not wasValid ) then
		for k, v in STUPIDMOUNT2_SET_FEAT_VALID_VALUE do
			if ( value == v ) then
				local featFunc = StupidMount2_SlashCommandArray[k];
				if ( featFunc ) then
					return featFunc(msg);
				end
			end
		end
		StupidMount2_Print(string.format(STUPIDMOUNT2_ERROR_WRONG_CMD_FEAT, STUPIDMOUNT2_WRONG_CMD_FEAT[cmd]));
		return false;
	end
	StupidMount2_Options[optionsPtr] = newState;
	if ( Khaos ) then
		local v = Khaos.getSetKey(STUPIDMOUNT2_KHAOS_SET_ID, optionsPtr);
		if ( v ) then
			Khaos.setSetKeyParameter(STUPIDMOUNT2_KHAOS_SET_ID, optionsPtr, "value", value);
		end
	end

	StupidMount2_Print(string.format(STUPIDMOUNT2_CMD_SET_CHAT_STATE[feat], value));
	return true;
end

function StupidMount2_SlashCommand_CheckBox(msg, cmd, newValue)
	local featString, params = StupidMount2_Extract_NextParameter(msg);
	local feat = nil;
	for k, v in STUPIDMOUNT2_OPTIONS_SLASH_FEAT do
		if ( featString[k] == v ) then
			feat = k;
			break;
		end
	end
	if ( not feat ) and ( strlen(featString) <= 0 ) then
		feat = "main";
	end
	if ( not feat ) then
		StupidMount2_Print(STUPIDMOUNT2_ERROR_ILLEGAL_FEAT, 1, 0.2, 0.2);
		StupidMount2_Usage()
		return false;
	end
	local wasValid = false;
	for key, value in STUPIDMOUNT2_CMD_FEAT_VALID[cmd] do
		if ( value == feat ) then
			wasValid = true;
			break;
		end
	end
	if ( not wasValid ) then
		StupidMount2_Print(string.format(STUPIDMOUNT2_ERROR_WRONG_CMD_FEAT, STUPIDMOUNT2_WRONG_CMD_FEAT[cmd]));
		return false;
	end
	
	local optionsPtr = STUPIDMOUNT2_FEAT_OPTIONS_MAP[feat];
	local oldState = StupidMount2_Options[optionsPtr];
	local newState = true;
	if ( newValue == -1 ) then
		if ( oldState ) then
			newState = false;
		end
	elseif( newValue == 0 ) then
		newState = false;
	end
	StupidMount2_Options[optionsPtr] = newState;
	if ( Khaos ) then
		local v = Khaos.getSetKey(STUPIDMOUNT2_KHAOS_SET_ID, optionsPtr);
		if ( v ) then
			Khaos.setSetKeyParameter(STUPIDMOUNT2_KHAOS_SET_ID, optionsPtr, "checked", newValue);
		end
	end
	local stateStr = STUPIDMOUNT2_STATE_ENABLED;
	if ( not newState ) then
		stateStr = STUPIDMOUNT2_STATE_DISABLED;
	end
	StupidMount2_Print(string.format(STUPIDMOUNT2_CMD_CHECKBOX_CHAT_STATE[feat], stateStr));
	return true;
end

function StupidMount2_SlashCommand_Toggle(msg)
	return StupidMount2_SlashCommand_CheckBox(msg, "toggle", -1);
end

function StupidMount2_SlashCommand_Enable(msg)
	return StupidMount2_SlashCommand_CheckBox(msg, "enable", 1);
end

function StupidMount2_SlashCommand_Disable(msg)
	return StupidMount2_SlashCommand_CheckBox(msg, "disable", 0);
end

StupidMount2_SlashCommandArray = {};
StupidMount2_SlashCommandArray["help"] = StupidMount2_Usage;
StupidMount2_SlashCommandArray["toggle"] = StupidMount2_SlashCommand_Toggle;
StupidMount2_SlashCommandArray["enable"] = StupidMount2_SlashCommand_Enable;
StupidMount2_SlashCommandArray["disable"] = StupidMount2_SlashCommand_Disable;
StupidMount2_SlashCommandArray["set"] = StupidMount2_SlashCommand_Set;

function StupidMount2_Extract_NextParameter(msg)
	local i = strfind(msg, " ");
	if ( not i ) then 
		return msg, "";
	end
	return strsub(msg, 1, i-1), strsub(msg, i+1);
end

function StupidMount2_SlashCommand(msg)
	if ( not msg ) or ( strlen(msg) <= 0 ) then
		StupidMount2_Usage();
		return false;
	end
	local cmd, params = StupidMount2_Extract_NextParameter(msg);
	if ( not cmd ) or ( strlen(cmd) <= 0 ) then
		StupidMount2_Usage();
		return false;
	else
		local lcmd = string.lower(cmd);
		for k, v in StupidMount2_SlashCommandArray do
			for key, value in STUPIDMOUNT2_OPTIONS_SLASH_CMDS[k] do
				if ( lcmd == value ) then
					return v(params);
				end
			end
		end
		StupidMount2_Usage();
		return false;
	end
end

function StupidMount2_Register_SlashCommands()
	local cmd = "STUPIDMOUNT2SLASHCMD";
	SlashCmdList[cmd] = StupidMount2_SlashCommand;
	for k, v in STUPIDMOUNT2_OPTIONS_CMD do
		setglobal(cmd..k, v);
	end
end


function StupidMount2_Options_OnLoad()
	StupidMount2_Register_SlashCommands();
	StupidMount2_Register_Khaos();
end

function StupidMount2_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
end