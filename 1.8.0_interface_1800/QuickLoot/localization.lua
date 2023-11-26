-- Version : English
-- Last Update : 02/17/2005

-- Cosmos Configuration
COSMOS_CONFIG_QLOOT_HEADER		= "Quick Loot";
COSMOS_CONFIG_QLOOT_HEADER_INFO		= "This section configures options for Quick Loot";
COSMOS_CONFIG_QLOOT			= "Check here to enable quick looting.";
COSMOS_CONFIG_QLOOT_INFO		= "This will automatically move the first non-empty item slot in the loot window under your cursor as you loot.";
COSMOS_CONFIG_QLOOT_HIDE		= "Auto close empty loot windows.";	
COSMOS_CONFIG_QLOOT_HIDE_INFO		= "If this is enabled and you loot a corpse with no items, the loot window will be closed immediately.";
COSMOS_CONFIG_QLOOT_ONSCREEN		= "Show loot completely on screen.";
COSMOS_CONFIG_QLOOT_ONSCREEN_INFO	= "If this is enabled loot window will remain open as coin/items are looted.";

COSMOS_CONFIG_QLOOT_MOVE_ONCE		= "Only move the window to the mouse.";
COSMOS_CONFIG_QLOOT_MOVE_ONCE_INFO	= "If this is enabled, QuickLoot will not move the window more than once.";

-- Chat Configuration
QLOOT_LOADED				= "Telo's QuickLoot loaded";
ERR_LOOT_NONE				= "There was no loot to get.";

QUICKLOOT_CHAT_COMMAND_INFO		= "Sets up Quick Loot from the command line. Try it without parameters to get usage help.";
QUICKLOOT_CHAT_COMMAND_USAGE		= "Usage: /quickloot <enable/autohide/onscreen/moveonce> [true/false]\nAll commands toggle the current state.\nCommands:\n enable - enables/disables Quick Loot\n autohide - whether Quick Loot should autohide empty loot windows or not\n onscreen - should Quick Loot keep the loot window on screen or not";
QUICKLOOT_CHAT_COMMAND_ENABLE		= COSMOS_CONFIG_QLOOT_HEADER;
QUICKLOOT_CHAT_COMMAND_HIDE		= COSMOS_CONFIG_QLOOT_HEADER.." hiding";
QUICKLOOT_CHAT_COMMAND_ONSCREEN		= COSMOS_CONFIG_QLOOT_HEADER.." keep on screen";
QUICKLOOT_CHAT_COMMAND_MOVE_ONCE	= COSMOS_CONFIG_QLOOT_HEADER.." move once";


QUICKLOOT_COMMANDS = {"/quickloot", "/ql"};
QUICKLOOT_COMMANDS_ENABLE = "enable";
QUICKLOOT_COMMANDS_AUTOHIDE = "autohide";
QUICKLOOT_COMMANDS_ONSCREEN = "onscreen";
QUICKLOOT_COMMANDS_MOVEONCE = "moveonce";

QUICKLOOT_COMMANDS_TRUE = "true";
QUICKLOOT_COMMANDS_FALSE = "false";

QUICKLOOT_CHAT_STATE_ENABLED		= " enabled";
QUICKLOOT_CHAT_STATE_DISABLED		= " disabled";

-- default feedback text for options
QUICKLOOT_KHAOS_OPTION_STATE_TEXT	= "Option is";
