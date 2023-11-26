-- StupidMount2 options

--- Commandline

STUPIDMOUNT2_OPTIONS_CMD							= {
	"/stupidmount", "/stupidm", "/smount", "/sm",
	"/stupidmount2", "/stupidm2", "/smount2", "/sm2"
};
STUPIDMOUNT2_OPTIONS_CMD_DESC					= "controls StupidMount2 AddOn";

STUPIDMOUNT2_OPTIONS_SLASH_CMDS					= {};
STUPIDMOUNT2_OPTIONS_SLASH_CMDS["help"]			= {"help"};
STUPIDMOUNT2_OPTIONS_SLASH_CMDS["toggle"]		= {"toggle", "tg", "t"};
STUPIDMOUNT2_OPTIONS_SLASH_CMDS["enable"]		= {"enable", "en", "e"};
STUPIDMOUNT2_OPTIONS_SLASH_CMDS["disable"]		= {"disable", "di", "d"};
STUPIDMOUNT2_OPTIONS_SLASH_CMDS["set"]			= {"set"};

STUPIDMOUNT2_OPTIONS_SLASH_FEAT					= {};
STUPIDMOUNT2_OPTIONS_SLASH_FEAT["main"]			= {"", "main"};
STUPIDMOUNT2_OPTIONS_SLASH_FEAT["combat"]		= {"combat", "cb", "dismountincombat", "dismountcombat", "dc"};

-- provides a mapping between feature and StupidMount2_Options index (as well as Khaos index)
STUPIDMOUNT2_FEAT_OPTIONS_MAP						= {};
STUPIDMOUNT2_FEAT_OPTIONS_MAP["main"]				= "enabled";
STUPIDMOUNT2_FEAT_OPTIONS_MAP["combat"]				= "dismountInCombat";

STUPIDMOUNT2_SET_FEAT_VALID_VALUE				= {};
STUPIDMOUNT2_SET_FEAT_VALID_VALUE["toggle"]		= -1;
STUPIDMOUNT2_SET_FEAT_VALID_VALUE["enable"]		= 1;
STUPIDMOUNT2_SET_FEAT_VALID_VALUE["disable"]		= 0;

STUPIDMOUNT2_CMD_FEAT_VALID						= {};
STUPIDMOUNT2_CMD_FEAT_VALID["toggle"]				= {"main", "combat"};
STUPIDMOUNT2_CMD_FEAT_VALID["enable"]				= STUPIDMOUNT2_CMD_FEAT_VALID["toggle"];
STUPIDMOUNT2_CMD_FEAT_VALID["disable"]				= STUPIDMOUNT2_CMD_FEAT_VALID["toggle"];
STUPIDMOUNT2_CMD_FEAT_VALID["set"]					= {};

STUPIDMOUNT2_ERROR_ILLEGAL_FEAT						= "StupidMount2: the feature you specified does not exist.";
STUPIDMOUNT2_ERROR_WRONG_CMD_FEAT					= "StupidMount2: the feature you specified can not be %s.";
STUPIDMOUNT2_ERROR_NO_VALUE_TO_SET					= "StupidMount2: no value given to set.";

STUPIDMOUNT2_WRONG_CMD_FEAT_LIST					= {};
STUPIDMOUNT2_WRONG_CMD_FEAT_LIST["toggle"]			= "toggled";
STUPIDMOUNT2_WRONG_CMD_FEAT_LIST["enable"]			= "enabled";
STUPIDMOUNT2_WRONG_CMD_FEAT_LIST["disable"]		= "disabled";
STUPIDMOUNT2_WRONG_CMD_FEAT_LIST["set"]			= "set";


STUPIDMOUNT2_OPTIONS_CMD_USAGE						= {
	" Usage: /stupidmount2 <command> [parameters]";
	"",
	"Commands:",
	" toggle [feature] - toggle StupidMount2 or specified feature on/off",
	" enable [feature] - enable StupidMount2 or specified feature",
	" disable [feature] - disable StupidMount2 (or specified feature)",
	" set <feature> <value> - sets the feature to value",
	" help - displays this information",
	"",
	"Features:",
	" main - whether to dismount automatically at all",
	" dismountInCombat - whether to dismount automatically while in combat"

};

--- Khaos

STUPIDMOUNT2_KHAOS_SET_TEXT							= "Stupid Mount 2";
STUPIDMOUNT2_KHAOS_SET_HELP							= "Contains the options for StupidMount2 2, the auto-dismounting addon.";

STUPIDMOUNT2_KHAOS_ENABLE_TEXT						= "Enable StupidMount2";
STUPIDMOUNT2_KHAOS_ENABLE_HELP						= "Determines if StupidMount2 is allowed to do anything at all. If disabled, nothing will happen, though some code will still run.";

STUPIDMOUNT2_KHAOS_COMBAT_TEXT						= "Dismount in combat";
STUPIDMOUNT2_KHAOS_COMBAT_HELP						= "Whether to dismount in combat or not.";

STUPIDMOUNT2_STATE_ENABLED							= "enabled";
STUPIDMOUNT2_STATE_DISABLED							= "disabled";

STUPIDMOUNT2_CHAT_ENABLED							= "StupidMount2 %s.";

STUPIDMOUNT2_CHAT_COMBAT							= "StupidMount2 dismount in combat %s.";

-- these should be possible to just copy/paste into any localization... should actually not be here, buuut...

STUPIDMOUNT2_CMD_CHECKBOX_CHAT_STATE				= {};
STUPIDMOUNT2_CMD_CHECKBOX_CHAT_STATE["main"]		= STUPIDMOUNT2_CHAT_ENABLED;
STUPIDMOUNT2_CMD_CHECKBOX_CHAT_STATE["combat"]	= STUPIDMOUNT2_CHAT_COMBAT;

STUPIDMOUNT2_CMD_SET_CHAT_STATE					= {};

STUPIDMOUNT2_TOOLTIP_GFIND_PATTERN				= "Increases speed by (%d+)%%."; -- Thanks to IsMounted for this one.
