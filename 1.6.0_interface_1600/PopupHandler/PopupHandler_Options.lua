PopupHandler_Cosmos_Options = {};

PopupHandler_Khaos_Options_Easy = {};

PopupHandler_Keys_To_Cosmos = {
	enabled = "COS_POPUPHANDLER_ENABLED";
};


function PopupHandler_Get_Khaos_CheckBox(pid, pkey, ptext, phelptext, pcheck, cb)
	local keyName = pkey;
	if ( not cb ) then
		cb = function(state) PopupHandler_UpdateBooleanOption(keyName, state.checked, "Khaos"); end
	end
	local ltext = ptext;
	local option1 = {
		id = pid;
		key = pkey;
		text = ptext;
		helptext = phelptext;
		check = true;
		callback = cb;
		type = K_TEXT;
		feedback = function(state) local s = POPUPHANDLER_STATE_ENABLED; if ( not state.checked ) then s = POPUPHANDLER_STATE_DISABLED; end return ltext.." "..s; end;
		default = {
			checked = pcheck;
		};
		disabled = {
			checked = false;
		};
	};
	return option1;
end


PopupHandler_ToggleSlashCommands = {
};

PopupHandler_OptionSet_Easy = {
	id = POPUPHANDLER_KHAOS_SET_EASY_ID;
	text = POPUPHANDLER_CONFIG_NAME;
	helptext = POPUPHANDLER_CONFIG_INFO;
	difficulty = 1;
	default = true;
};


function PopupHandler_CosmosBooleanOptionUpdate(key, toggle)
	local newState = false;
	if ( toggle ) and ( toggle == 1 ) then
		newState = true;
	end
	PopupHandler_UpdateBooleanOption(key, newState, "Cosmos");
end

function PopupHandler_AddCosmosBooleanOption(key, defaultToggle, name, info, func)
end

function PopupHandler_AddCosmosBooleanOptionReal(key, defaultToggle, name, info, func)
	local defaultValue = 0;
	if ( defaultToggle ) then
		defaultValue = 1;
	end
	local cosmosName = PopupHandler_Keys_To_Cosmos[key];
	if ( not func ) then
		-- WHEEEEEEEEEEEEEEEEEEE
		local keyName = key;
		func = function(toggle) PopupHandler_CosmosBooleanOptionUpdate(keyName, toggle); end;
	end
	table.insert(PopupHandler_Cosmos_Options, {
		cosmosName,
		"CHECKBOX",
		name,
		info,
		func,
		defaultValue
	});
end


function PopupHandler_AddOptions()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		Cosmos_RegisterConfiguration(
			"COS_POPUPHANDLER",
			"SECTION",
			TEXT(POPUPHANDLER_CONFIG_NAME),
			TEXT(POPUPHANDLER_CONFIG_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_POPUPHANDLER_HEADER",
			"SEPARATOR",
			TEXT(POPUPHANDLER_CONFIG_NAME),
			TEXT(POPUPHANDLER_CONFIG_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_POPUPHANDLER_ENABLED",
			"CHECKBOX",
			TEXT(POPUPHANDLER_OPTION_ENABLED_NAME),
			TEXT(POPUPHANDLER_OPTION_ENABLED_INFO),
			function(toggle) PopupHandler_CosmosBooleanOptionUpdate("enabled", toggle) end,
			1
		);
		local cosmosType = "CHECKBOX";
		for k, v in PopupHandler_Khaos_Options_Easy do
			local name = v.text;
			local info = v.helptext;
			local keyName = v.key;
			local value = 1;
			local func = function(toggle) PopupHandler_CosmosBooleanOptionUpdate(keyName, toggle); end;
			if ( v.check ) and ( keyName ~= "enabled" ) then
				if ( not v.default ) or ( not v.default.checked ) then
					value = 0;
				end
				Cosmos_RegisterConfiguration(
					PopupHandler_Keys_To_Cosmos[v.key], 
					"CHECKBOX",
					name,
					info,
					func,
					value
				);
			end
		end
	else
		PopupHandler_Cosmos_Options = {};
	end
	if ( Khaos ) then
		PopupHandler_OptionSet_Easy.options = PopupHandler_Khaos_Options_Easy;
		Khaos.registerOptionSet( "other", PopupHandler_OptionSet_Easy );
	else
		PopupHandler_Khaos_Options_Easy = {};
	end
	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ENABLED_CMDS, "enabled", POPUPHANDLER_CHAT_ENABLED_FORMAT, POPUPHANDLER_OPTION_ENABLED_NAME, POPUPHANDLER_OPTION_ENABLED_INFO);
	local name = "POPUPHANDLERSLASHTOGGLE";
	SlashCmdList[name] = PopupHandler_ToggleSlashCommand;
	for k, v in POPUPHANDLER_SLASHCOMMANDS do
		setglobal(name..k, v);
	end
end


function PopupHandler_AddSlashCommand(cmds, key, chat, name, info, func)
	local arr = nil;
	arr = {};
	arr.optionKey = key;
	arr.chat = chat;
	arr.name = name;
	arr.info = info;
	arr.func = func;
	if ( type(cmds) == "table" ) then
		for k, v in cmds do
			PopupHandler_ToggleSlashCommands[v] = arr;
		end
	else
		PopupHandler_ToggleSlashCommands[cmds] = arr;
	end
end

function PopupHandler_ToggleKey(optionKey)
	local newState = false;
	if ( not PopupHandler_Options[optionKey] ) then
		newState = true;
	end
	PopupHandler_UpdateBooleanOption(optionKey, newState, "Slash");
end

function PopupHandler_ShowToggleState(optionKey, chatFormat)
	local state = POPUPHANDLER_STATE_ENABLED;
	if ( not PopupHandler_Options[optionKey] ) then
		state = POPUPHANDLER_STATE_ENABLED;
	end
	PopupHandler_Print(string.format(chatFormat, state));
end


function PopupHandler_ShowUsageForEntry(entry)
	local arr = PopupHandler_ToggleSlashCommands[entry];
	local name = arr.name;
	if ( not name ) then
		name = arr.entry;
	end
	if ( not name ) then 
		return;
	end
	local info = arr.info;
	if ( not info ) then
		return;
	end
	PopupHandler_Print(entry.." - "..name);
	PopupHandler_Print(info);
end

function PopupHandler_ShowUsage(msg)
	PopupHandler_Print(POPUPHANDLER_CHAT_USAGE);
	if ( msg ) and ( strlen(msg) > 0 ) then
		for k, v in PopupHandler_ToggleSlashCommands do
			if ( string.find(msg, k) ) then
				PopupHandler_ShowUsageForEntry(k);
				return;
			end
		end
	end
	local arr = {};
	local shouldShowUsage = false;
	for k, v in PopupHandler_ToggleSlashCommands do
		shouldShowUsage = true;
		for key, value in arr do
			if ( value == v.optionKey ) then
				shouldShowUsage = false;
				break;
			end
		end
		if ( shouldShowUsage ) then
			PopupHandler_ShowUsageForEntry(k);
			table.insert(arr, v.optionKey);
		end
	end
end

function PopupHandler_ToggleSlashCommand(msg)
	local index = 1;
	for k, v in POPUPHANDLER_CHAT_HELP_CMDS do
		index = string.find(msg, v);
		if ( index ) then
			PopupHandler_ShowUsage(string.sub(msg, index+strlen(v)+1));
			return;
		end
	end
	local func = nil;
	local rest = nil;
	for k, v in PopupHandler_ToggleSlashCommands do
		index = string.find(msg, k);
		if ( index ) then
			if( not v.func ) then
				PopupHandler_ToggleKey(v.optionKey);
				PopupHandler_ShowToggleState(v.optionKey, v.chat);
				return;
			else
				rest = string.sub(msg, index+strlen(k)+1);
				func = v.func;
				if ( type(func) == "string" ) then
					func = getglobal(func);
				end
				func(rest);
				return;
			end
		end
	end
	PopupHandler_ShowUsage();
end

-- prevents recursive hang (reentry)
PopupHandler_UpdateBooleanOption_Active = {};

function PopupHandler_UpdateBooleanOption(key, newState, from)
	if ( not key ) then
		return;
	end
	if ( not from ) then
		from = "";
	end
	if ( PopupHandler_UpdateBooleanOption_Active[key] ) then
		return;
	end
	PopupHandler_UpdateBooleanOption_Active[key] = true;
	if ( Khaos ) and ( from ~= "Khaos" ) then
		local khaosKey = Khaos.getSetKey(PopupHandler_OptionSet_Easy.id, key);
		if ( not khaosKey ) then
			Khaos.setSetKey(PopupHandler_OptionSet_Easy.id, key, {});
		end
		Khaos.setSetKeyParameter(PopupHandler_OptionSet_Easy.id, key, "checked", newState);
		if ( Khaos.updateOptionSet ) then
			Khaos.updateOptionSet(PopupHandler_OptionSet_Easy.id);
		end
	end
	if ( Cosmos_UpdateValue ) and ( from ~= "Cosmos" ) then
		local cosmosName = PopupHandler_Keys_To_Cosmos[key];
		if ( cosmosName ) then
			local value = 0;
			if ( newState ) then
				value = 1;
			end
			Cosmos_UpdateValue(cosmosName, CSM_CHECKONOFF, value);
			if ( CosmosMaster_DrawData ) then
				CosmosMaster_DrawData();
			end
		end
	end
	PopupHandler_Options[key] = newState;
	PopupHandler_UpdateBooleanOption_Active[key] = false;
end

local option = PopupHandler_Get_Khaos_CheckBox("enabledCheckBox", "enabled", 
	POPUPHANDLER_OPTION_ENABLED_NAME, 
	POPUPHANDLER_OPTION_ENABLED_INFO, 
	true, 
	function(state) PopupHandler_UpdateBooleanOption("enabled", state.checked); end
);

table.insert(PopupHandler_Khaos_Options_Easy, option);