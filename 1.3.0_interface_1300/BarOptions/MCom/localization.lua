--[[
--	FileName Localization
--		"English Localization"
--	
--	English By: 
--	
--	$Id: localization.lua 1441 2005-05-05 08:41:19Z Sinaloit $
--	$Rev: 1441 $
--	$LastChangedBy: Sinaloit $
--	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $
--]]

--------------------------------------------------
--
-- MCom types
--
--------------------------------------------------
MCOM_BOOLT = "B";
MCOM_NUMT = "N";
MCOM_MULTIT = "M";
MCOM_STRINGT = "S";
MCOM_SIMPLET = "E";

--------------------------------------------------
--
-- MCom help text
--
--------------------------------------------------
MCOM_CHAT_COMMAND_ALIAS			= "Command aliases: %s";
MCOM_CHAT_COMMAND_COMMANDS		= "Commands: [command] - [type] - [details]";
MCOM_CHAT_COMMAND_SUBCOMMAND		= "%s - %s - %s";
MCOM_CHAT_COMMAND_NOINFO = "No additonal info available.";
MCOM_CHAT_COMMAND_USAGE		= "When using commands don't include the parenthesis or brackets, or the letter between the parenthesis.";
MCOM_CHAT_COMMAND_USAGE_S_E		= "Usage %s";
MCOM_CHAT_COMMAND_USAGE_S_B		= "Usage %s [on/off]";
MCOM_CHAT_COMMAND_USAGE_S_N		= "Usage %s [number]";
MCOM_CHAT_COMMAND_USAGE_S_M		= "Usage %s [on/off] [number]";
MCOM_CHAT_COMMAND_USAGE_S_S		= "Usage %s somestring";
MCOM_CHAT_COMMAND_USAGE_E		= "Usage for ("..MCOM_SIMPLET..") %s [option]";
MCOM_CHAT_COMMAND_USAGE_B		= "Usage for ("..MCOM_BOOLT..") %s [option] [on/off]";
MCOM_CHAT_COMMAND_USAGE_N		= "Usage for ("..MCOM_NUMT..") %s [option] [number]";
MCOM_CHAT_COMMAND_USAGE_M		= "Usage for ("..MCOM_MULTIT..") %s [option] [on/off] [number]";
MCOM_CHAT_COMMAND_USAGE_S		= "Usage for ("..MCOM_STRINGT..") %s [option] [string]";
MCOM_CHAT_COMMAND_EXAMPLE	=	"Example Usage:";
MCOM_CHAT_COMMAND_EXAMPLE_S_E		= "%s";
MCOM_CHAT_COMMAND_EXAMPLE_S_B		= "%s on";
MCOM_CHAT_COMMAND_EXAMPLE_S_N		= "%s 1";
MCOM_CHAT_COMMAND_EXAMPLE_S_M		= "%s on 1";
MCOM_CHAT_COMMAND_EXAMPLE_S_S		= "%s somestring";
MCOM_CHAT_COMMAND_EXAMPLE_E		= "%s %s";
MCOM_CHAT_COMMAND_EXAMPLE_B		= "%s %s on";
MCOM_CHAT_COMMAND_EXAMPLE_N		= "%s %s 1";
MCOM_CHAT_COMMAND_EXAMPLE_M		= "%s %s on 1";
MCOM_CHAT_COMMAND_EXAMPLE_S		= "%s %s somestring";
MCOM_CHAT_ENABLED = "Enabled";
MCOM_CHAT_DISABLED = "Disabled";