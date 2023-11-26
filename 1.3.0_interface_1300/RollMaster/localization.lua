-- Version : English - sarf
-- Translation by : None

ROLLMASTER_CHAT_ASK_ROLL_FORMAT			= "RollMaster : Please use /random %d-%d";
ROLLMASTER_CHAT_ASK_ROLL_GSUB			= "RollMaster : Please use /random (%d+)-(%d+)";

ROLLMASTER_CHAT_START_ROLLS				= "RollMaster : === START ROLLS ===";
ROLLMASTER_CHAT_END_ROLLS				= "RollMaster : === ROLLS ENDED ===";

ROLLMASTER_CHAT_HIGH_ROLLER				= "RollMaster : %s won the roll with %d.";
ROLLMASTER_CHAT_NO_ONE_ROLLED			= "RollMaster : No one rolled.";

ROLLMASTER_CHAT_CMDS					= { "/rollmaster", "/rm"};
ROLLMASTER_CHAT_CMDS_INFO				= "Allows starting/stopping a RollMaster roll.";
ROLLMASTER_CHAT_CMDS_USAGE				= "Usage: /rollmaster <start/stop/roll/autoroll>\n autoroll toggles if you want RollMaster to roll whenever a roll is called.";
ROLLMASTER_CHAT_CMDS_START				= {"start"};
ROLLMASTER_CHAT_CMDS_STOP				= {"stop"};
ROLLMASTER_CHAT_CMDS_LIST				= {"list"};
ROLLMASTER_CHAT_CMDS_ROLL				= {"roll"};
ROLLMASTER_CHAT_CMDS_AUTOROLL			= {"autoroll"};


ROLLMASTER_CHAT_ROLL_GSUB				= "(.+) rolls (%d+) %((%d+)%-(%d+)%)";
ROLLMASTER_CHAT_LIST_HAS_NOT_ROLLED		= "RollMaster : The following players has not rolled:\n%s";
ROLLMASTER_CHAT_ROLL_REQUESTED			= "RollMaster : A roll has been requested. Use /rollmaster roll to roll.";
ROLLMASTER_CHAT_NO_PENDING_ROLL			= "RollMaster : There was no pending roll.";
ROLLMASTER_CHAT_AUTO_ROLL				= "RollMaster : Autoroll is %s.";
ROLLMASTER_CHAT_LIST_HAS_ROLLED_MORE	= "RollMaster : These following players attempted to roll more than once:\n%s";

ROLLMASTER_CHAT_STATE_ENABLED			= "enabled";
ROLLMASTER_CHAT_STATE_DISABLED			= "disabled";

ROLLMASTER_CHAT_STARTUP					= "RollMaster v%s loaded.";