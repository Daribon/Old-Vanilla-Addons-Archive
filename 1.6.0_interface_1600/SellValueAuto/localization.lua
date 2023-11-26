SELLVALUE_AUTO_BUTTON_TEXT				= "Auto...";


SELLVALUE_AUTO_MENU_TITLE				= "Options";

SELLVALUE_AUTO_MENU						= {
	popup = "Popup";
	destroyCheapest = "Destroy cheapest";
};

SELLVALUE_AUTO_DESTRUCT_COMPLETE		= "SellValueAuto: %s destroyed.";
SELLVALUE_AUTO_DESTRUCT_VALUE_ABORTED	= "SellValueAuto: Least expensive item %s exceeding money threshold.";
SELLVALUE_AUTO_DESTRUCT_ITEM_ABORTED	= "SellValueAuto: Item present on cursor - destruction aborted.";

SELLVALUE_AUTO_SLASH_VALUE_DEFAULT		= { "DEFAULT" };

SELLVALUE_AUTO_SLASH_HELP				= {
	"SellValueAuto slash command format:",
	" <parameter> <new value>",
	" if <new value> is DEFAULT, the parameter will be reset to its default.",
	" To retrieve parameter aliases, use /sva alias [parameter]",
	" All parameters have specific types.",
	"If type is boolean, allowed values are true and false.",
	"If type is number, allowed values are any number.",
	"List of parameters, their types and defaults:",
	""
};

SELLVALUE_AUTO_SLASH_PARAMETER_FORMAT	= " %s, %s, default |c001111FF%s|r - currently |c0011FF11%s|r";

SELLVALUE_AUTO_SLASH_PARAMETER_SET		= "SellValueAuto: %s set to |c0011FF11%s|r";

SELLVALUE_AUTO_SLASH_TYPE_BOOLEAN_TRUE	= { "t", "true", "1", 1, true };
SELLVALUE_AUTO_SLASH_TYPE_BOOLEAN_FALSE	= { "f", "false", "0", 0, false };


SELLVALUE_AUTO_SLASH_PARAM_INVALID_TYPE	= "SellValueAuto: Invalid type used.";

SELLVALUE_AUTO_SLASH_COMMANDS			= {"/sellvalueauto", "/sva" };

SELLVALUE_AUTO_SLASH_COMMANDS_IL		= {"/inventorylist", "/il" };

SELLVALUE_AUTO_SLASH_COMMANDS_IL_P		= {"/svai", "/svail", "/sellvalueautoitem", "/sellvalueautoitemlist", "/sellvalueautoinventorylist", "/sellvalueautoil" };

SELLVALUE_AUTO_SLASH_COMMANDS_IL_LIST_H	= { "hide" };
SELLVALUE_AUTO_SLASH_COMMANDS_IL_LIST_S	= { "show" };

SELLVALUE_AUTO_SLASH_COMMANDS_IL_USAGE	= {
	" Usage: /inventorylist <hide/show> <item name>",
	"hide means 'do not destroy item' and show means 'allow destruction of item'",
	"command aliases:",
	"/svail, /svai, /sellvalueautoinventorylist and some others."
};

SELLVALUE_AUTO_SLASH_COMMANDS_IL_SHOW	= "SellValueAuto: %s marked as eligible for auto-destruction.";
SELLVALUE_AUTO_SLASH_COMMANDS_IL_HIDE	= "SellValueAuto: %s not eligible for auto-destruction.";

SELLVALUE_AUTO_SLASH_COMMANDS_INC_LIST	= { "/svaincludelist", "/svainc" };

SELLVALUE_AUTO_SLASH_COMMANDS_INC_SHOW	= "SellValueAuto: %s marked as desireable for auto-destruction.";
SELLVALUE_AUTO_SLASH_COMMANDS_INC_HIDE	= "SellValueAuto: %s removed from auto-destruction list.";

SELLVALUE_AUTO_DEFAULT_EXEMPT_ITEMS		= {
	["Skinning Knife"] = 1;
	["Finkle's Skinner"] = 1;

	["Blacksmith's Hammer"] = 1;
	["Mining Pick"] = 1;

	["Big Iron Fishing Pole"] = 1;
	["Blump Family Fishing Pole"] = 1;
	["Fishing Pole"] = 1;
	["Lucky Fishing Hat"] = 1;
	["Strong Fishing Pole"] = 1;
	
	["Crystal Vial"] = 1;
	["Empty Vial"] = 1;
	["Imbued Vial"] = 1;
	["Leaded Vial"] = 1;
};

SELLVALUE_AUTO_TITLE					= "SellValueAuto";

SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS	= {"alias", "aliases"};

SELLVALUE_AUTO_SLASH_PARAMETER_ALIASES	= {
	dc = "destroyCheapest";
	destroy = "destroyCheapest";
	destroycheapest = "destroyCheapest";

	dct = "destroyCheapestThreshold";
	destroythreshold = "destroyCheapestThreshold";
	destroycheapestthreshold = "destroyCheapestThreshold";

	pa = "popupIfDestructionThresholdAborted";
	popupabort = "popupIfDestructionThresholdAborted";
	popupaborted = "popupIfDestructionThresholdAborted";
	popupifdestructionthresholdaborted = "popupIfDestructionThresholdAborted";

	sd = "showDestruction";
	showdestruction = "showDestruction";

	sdl = "showDestructionLink";
	showdestructionlink = "showDestructionLink";

	odi = "onlyDestroyIncluded";
	onlydestroyincluded = "onlyDestroyIncluded";
};

SELLVALUE_AUTO_SLASH_VALUE_BOOLEAN_TRUE = "true"; 
SELLVALUE_AUTO_SLASH_VALUE_BOOLEAN_FALSE = "false";

SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_TEXT = "SellValueAuto Aliases:";
SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_SPECIFIC_TEXT = "SellValueAuto Aliases for %s:";
SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_FORMAT = " |c001111FF%s|r => |c0011FF11%s|r";
SELLVALUE_AUTO_SLASH_PARAMETER_ALIAS_FORMAT_SINGLE = " |c001111FF%s|r";
