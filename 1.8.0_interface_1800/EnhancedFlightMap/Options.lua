--[[

Options.lua

This file contains all the options and the slash command handler

]]

-- Function: Slashcommand handler
function EFM_SlashCommandHandler(msg)
	if (msg == '') then msg = nil end

	if (msg) then
		msg = string.lower(msg);
		
		if (msg == EFM_CMD_CLEAR) then
			DEFAULT_CHAT_FRAME:AddMessage(EFM_CLEAR_HELP);
		elseif (msg == EFM_CMD_CLEAR_ALL) then
			EFM_Clear_Data();
		elseif (msg == EFM_CMD_LOAD_HORDE) then
			EFM_Load_Stored_Data("Horde");
			EFM_Timer_LoadData("Horde");
			EFM_MAP_LoadData("Horde");
		elseif (msg == EFM_CMD_LOAD_ALLIANCE) then
			EFM_Load_Stored_Data("Alliance");
			EFM_Timer_LoadData("Alliance");
			EFM_MAP_LoadData("Alliance");
		elseif (msg == EFM_CMD_LOAD_DRUID) then
			EFM_Load_Stored_Data("Druid");

		-- Handle various options when run from the command line...
		elseif (string.find(msg, EFM_CMD_STATUS) ~= nil) then		
			EnhancedFlightMap_Options("all", "status");
		elseif (string.find(msg, EFM_CMD_DEFAULTS) ~= nil) then
			EnhancedFlightMap_Options("all", "defaults");
		elseif (string.find(msg, EFM_CMD_ENABLE) ~= nil) then		
			value = string.sub(msg, (string.len(EFM_CMD_ENABLE) + 2));
			EnhancedFlightMap_Options(value, "enable");
		elseif (string.find(msg, EFM_CMD_DISABLE) ~= nil) then		
			value = string.sub(msg, (string.len(EFM_CMD_DISABLE) + 2));
			EnhancedFlightMap_Options(value, "disable");

		-- Options screen details
		elseif (msg == EFM_CMD_GUI) then		
			EFM_GUI_Toggle();

		-- End of basic slash commands, now just display help...
		else
			LYS_Display_Help("EFM_HELP_TEXT");
		end
	else
		LYS_Display_Help("EFM_HELP_TEXT");
	end
end

-- Function: Enable/Disable specific functions.
function EnhancedFlightMap_Options(option, value)
	if (value == "status") then
		if (EFM_Config.Timer) then
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_INFLIGHT..EFM_MSG_OPTIONS_ENABLED);
		else
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_INFLIGHT..EFM_MSG_OPTIONS_DISABLED);
		end

		if (EFM_Config.ZoneMarker) then
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_ZONEMARKER..EFM_MSG_OPTIONS_ENABLED);
		else
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_ZONEMARKER..EFM_MSG_OPTIONS_DISABLED);
		end

		if (EFM_Config.DruidPaths) then
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_DRUIDPATHS..EFM_MSG_OPTIONS_ENABLED);
		else
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_DRUIDPATHS..EFM_MSG_OPTIONS_DISABLED);
		end

		return;
	elseif (value == "defaults") then
		if (not EFM_Config) then
			EFM_Config = {};
		end

		-- Set Default Options
		EFM_Config.Timer		= true;
		EFM_Config.ZoneMarker	= true;
		EFM_Config.DruidPaths   = true;

		return;
	elseif (value == "enable") then
		if (string.lower(option) == EFM_OPTIONS_TIMER) then
			EFM_Config.Timer = true;
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_INFLIGHT..EFM_MSG_OPTIONS_ENABLED);
			return;
		end
		if (string.lower(option) == EFM_OPTIONS_ZONEMARKER) then
			EFM_Config.ZoneMarker = true;
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_ZONEMARKER..EFM_MSG_OPTIONS_ENABLED);
			return;
		end
		if (string.lower(option) == EFM_OPTIONS_DRUIDPATHS) then
			EFM_Config.DruidPaths = true;
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_DRUIDPATHS..EFM_MSG_OPTIONS_ENABLED);
			return;
		end
	elseif (value == "disable") then
		if (string.lower(option) == EFM_OPTIONS_TIMER) then
			EFM_Config.Timer = false;
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_INFLIGHT..EFM_MSG_OPTIONS_DISABLED);
			EFM_Timer_HideTimers();
			return;
		end
		if (string.lower(option) == EFM_OPTIONS_ZONEMARKER) then
			EFM_Config.ZoneMarker = false;
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_ZONEMARKER..EFM_MSG_OPTIONS_DISABLED);
			return;
		end
		if (string.lower(option) == EFM_OPTIONS_DRUIDPATHS) then
			EFM_Config.DruidPaths = false;
			DEFAULT_CHAT_FRAME:AddMessage(EFM_MSG_OPTIONS_DRUIDPATHS..EFM_MSG_OPTIONS_DISABLED);
			return;
		end
	end
end
