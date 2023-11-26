-- Version : French  (thanks to Sylvaninox)
-- Last Update : 05/19/2005




if ( GetLocale() == "frFR" ) then

-- Known Fishing Poles
TBOX_POLES = {
	[1] = {
		['name'] = 'Canne \195\160 p\195\170che',
		['id'] = 6256,
	},
	[2] = {
		['name'] = 'Solide canne \195\160 p\195\170che',
		['id'] = 6365,
	},
	[3] = {
		['name'] = 'Darkwood Fishing Pole',
		['id'] = 6366,
	},
	[4] = {
		['name'] = 'Grande canne \195\160 p\195\170che en fer',
		['id'] = 6367,
	},
	[5] = {
		['name'] = 'Canne \195\160 p\195\170che de la famille Blump',
		['id'] = 12225,
	},
}

TBOX_FISHING_SKILL_NAME = "P\195\170che";
TBOX_BOBBER_NAME        = "Flotteur";

-- commands
TBOX_CMD_EASYCAST = "easycast";
TBOX_CMD_FASTCAST = "fastcast";
TBOX_CMD_SWITCH   = "switch";
TBOX_CMD_RESET    = "reset";

-- syntax
TBOX_SYNTAX_ERROR  = TBOX_ADDON_NAME.." Syntax Error: ";
TBOX_SYNTAX_EASYCAST = " |cff00ff00"..TBOX_CMD_EASYCAST.."|r [on|off] (Right clicking will cast while a fishing pole is equipped.)";
TBOX_SYNTAX_FASTCAST = " |cff00ff00"..TBOX_CMD_FASTCAST.."|r [on|off] (Automatically re-cast when you click the fishing bobber.)";
TBOX_SYNTAX_SWITCH   = " |cff00ff00"..TBOX_CMD_SWITCH.."|r (Switch between your fishing gear and regular gear.)";
TBOX_SYNTAX_RESET    = " |cff00ff00"..TBOX_CMD_RESET.."|r (Clears your saved gear sets.)";

-- Command Help
TBOX_COMMAND_HELP = {
	TBOX_ADDON_NAME.." Help:",
	"/tacklebox or /tb <command> [args] to perform the following commands:",
	TBOX_SYNTAX_EASYCAST,
	TBOX_SYNTAX_FASTCAST,
	TBOX_SYNTAX_SWITCH,
	TBOX_SYNTAX_RESET,
}

-- Output Strings
TBOX_OUT_LOADED             = TBOX_ADDON_TITLE.." Loaded (/tacklebox or /tb)";
TBOX_OUT_SET_POLE           = "Fishing pole set to %s.";
TBOX_OUT_SET_MAIN           = "Main hand set to %s.";
TBOX_OUT_SET_SECONDARY      = "Secondary hand set to %s.";
TBOX_OUT_SET_FISHING_GLOVES = "Fishing gloves set to %s.";
TBOX_OUT_SET_GLOVES         = "Normal gloves set to %s.";
TBOX_OUT_NEED_SET_POLE      = "Please equip the fishing pole and fishing gloves you want to use, then try again.";
TBOX_OUT_NEED_SET_NORMAL    = "Please equip your primary weapons and gloves, then try again.";
TBOX_OUT_ENABLED            = "%s is Enabled";
TBOX_OUT_DISABLED           = "%s is Disabled";
TBOX_OUT_EASYCAST           = "P\195\170che facile";
TBOX_OUT_FASTCAST           = "P\195\170che rapide";
TBOX_OUT_RESET              = "Your saved fishing gear sets have been reset.";

end