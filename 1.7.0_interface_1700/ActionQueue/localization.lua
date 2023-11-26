BINDING_HEADER_ACTIONQUEUE			= "ActionQueue";
BINDING_NAME_DOACTION				= "Execute action(s)";


ACTIONQUEUE_UNKNOWN_ENTRY_NAME		= "Unknown";


ACTIONQUEUE_CLASS_DRUID				= "Druid";
ACTIONQUEUE_CLASS_SHAMAN			= "Shaman";

-- credits to the idea of this array ( and most of the data ) to BuffBot
-- this array should be <name of class> = "<spellname>";
ACTIONQUEUE_GLOBALSPELLCOOLDOWN_MAP = {
	Druid = "Rejuvenation";
	Hunter = "Aspect of the Monkey";
	Mage  = "Arcane Intellect";
	Paladin = "Devotion Aura";
	Priest  = "Power Word: Fortitude";
	Rogue = "Sinister Strike";
	Shaman = "Rockbiter Weapon";
	Warlock = "Demon Skin";
	Warrior = "Heroic Strike";
};


ACTIONQUEUE_SLASH_CMD				= {"/actionqueue", "/aq"};

ACTIONQUEUE_CMD_MESSAGE_SCALE		= {"messagescale", "ms", "scale"};

ACTIONQUEUE_CMD_MESSAGE_SCALE_SET	= "AQ: Message scale set to %3f";
ACTIONQUEUE_CMD_MESSAGE_SCALE_ERROR	= "AQ: Message scale not changed.";

ACTIONQUEUE_CMD_ACTION_REMOVE		= {"remove", "unqueue", "del", "erase", "delete"};

ACTIONQUEUE_CMD_ACTION_REMOVE_OK	= "AQ: Action removed.";
ACTIONQUEUE_CMD_ACTION_REMOVE_FAIL	= "AQ: Action not found and thus not removed.";

ACTIONQUEUE_CMD_ACTION_LIST			= {"list", "smurf"};
ACTIONQUEUE_CMD_ACTION_LIST_START	= "ActionQueue Pending Actions:";
ACTIONQUEUE_CMD_ACTION_LIST_FMT		= "%d => %s";
ACTIONQUEUE_CMD_ACTION_LIST_EMPTY	= "None.";

ACTIONQUEUE_SLASH_CMD_USAGE			= {
	"Usage: /actionqueue <command> [parameters...]",
	" Commands:",
	"scale X - changes the scale of the message to X",
	"remove X - removes pending action X",
	"list - shows pending actions",
};


