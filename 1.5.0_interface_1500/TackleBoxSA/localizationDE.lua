-- Version : German (thanks to Maischter)
-- Last Update : 05/19/2005




if ( GetLocale() == "deDE" ) then

-- Known Fishing Poles
TBOX_POLES = {
	[1] = {
		['name'] = 'Angel',
		['id'] = 6256,
	},
	[2] = {
		['name'] = 'Starke Angel',
		['id'] = 6365,
	},
	[3] = {
		['name'] = 'Darkwood Angel',
		['id'] = 6366,
	},
	[4] = {
		['name'] = 'Gro\195\159e Eisenangel',
		['id'] = 6367,
	},
	[5] = {
		['name'] = 'Angel der Familie Blump',
		['id'] = 12225,
	},
}

TBOX_FISHING_SKILL_NAME = "Angeln";
TBOX_BOBBER_NAME        = "Blinker";

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
TBOX_OUT_SET_POLE           = "Angel auf %s eingestellt.";
TBOX_OUT_SET_MAIN           = "Waffenhand auf %s eingestellt.";
TBOX_OUT_SET_SECONDARY      = "Schildhand auf %s eingestellt.";
TBOX_OUT_SET_FISHING_GLOVES = "Angelhandschuhe auf %s eingestellt.";
TBOX_OUT_SET_GLOVES         = "Normale Handschuhe auf %s eingestellt.";
TBOX_OUT_NEED_SET_POLE      = "Bitte die Angel, die benutzt werden soll, in die Hand nehmen und nochmal versuchen.";
TBOX_OUT_NEED_SET_NORMAL    = "Bitte die Waffe, die benutzt werden soll, in die Hand nehmen und nochmal versuchen.";
TBOX_OUT_ENABLED            = "%s aktiviert";
TBOX_OUT_DISABLED           = "%s deaktiviet";
TBOX_OUT_EASYCAST           = "Einfaches Werfen";
TBOX_OUT_FASTCAST           = "Schnelles Werfen";
TBOX_OUT_RESET              = "Your saved fishing gear sets have been reset.";

end