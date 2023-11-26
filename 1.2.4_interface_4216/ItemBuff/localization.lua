-- Version : English
-- Last Update : 02/17/2005

-- Cosmos Configuration
ITEMBUFF_SEP			= "Equipment Buff Display";
ITEMBUFF_CHECK			= "Check here to display timed buffs";
ITEMBUFF_CHECK_INFO		= "Checking this box will cause the Item Buff window to display.";
ITEMBUFF_CANTUPDATE		= "Can't update while shopping";

ITEMBUFF_SMALL_ICONS		= "Check here to use small icons";
ITEMBUFF_SMALL_ICONS_INFO	= "Checking this box will cause the Item Buff icons to be small.";

ITEMBUFF_DISPLAY_BUFFNAME	= "Check here to display buff name and time left";
ITEMBUFF_DISPLAY_BUFFNAME_INFO	= "Checking this box will cause to show the buff name and time left besides the buff icon.";

ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY			= "Check here to display buff time below buff name";
ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY_INFO	= "Checking this box will cause Item Buff to show the buff time left below the buff name.";


-- Chat Configuration
ITEMBUFF_CHAT_COMMAND_INFO	= "Controls the "..ITEMBUFF_SEP..".";

ITEMBUFF_HELP			= "help";		-- must be lowercase; displays help
ITEMBUFF_STATUS			= "status";		-- must be lowercase; shows status
ITEMBUFF_FREEZE			= "freeze";		-- must be lowercase; freezes the window in position
ITEMBUFF_UNFREEZE		= "unfreeze";		-- must be lowercase; unfreezes the window so that it can be dragged
ITEMBUFF_RESET			= "reset";		-- must be lowercase; resets the window to its default position

ITEMBUFF_STATUS_HEADER		= "|cffffff00ItemBuff status:|r";
ITEMBUFF_FROZEN			= "ItemBuff: frozen in place";
ITEMBUFF_UNFROZEN		= "ItemBuff: unfrozen and can be dragged";
ITEMBUFF_RESET_DONE		= "ItemBuff: position reset to default";

ITEMBUFF_HELP_TEXT0		= " ";
ITEMBUFF_HELP_TEXT1		= "|cffffff00ItemBuff command help:|r";
ITEMBUFF_HELP_TEXT2		= "|cff00ff00Use |r|cffffffff/itembuff <command>|r|cff00ff00 or |r|cffffffff/ib <command>|r|cff00ff00 to perform the following commands:|r";
ITEMBUFF_HELP_TEXT3		= "|cffffffff"..ITEMBUFF_HELP.."|r|cff00ff00: displays this message.|r";
ITEMBUFF_HELP_TEXT4		= "|cffffffff"..ITEMBUFF_STATUS.."|r|cff00ff00: displays status information about the current option settings.|r";
ITEMBUFF_HELP_TEXT5		= "|cffffffff"..ITEMBUFF_FREEZE.."|r|cff00ff00: freezes the window so that it can't be dragged.|r";
ITEMBUFF_HELP_TEXT6		= "|cffffffff"..ITEMBUFF_UNFREEZE.."|r|cff00ff00: unfreezes the window so that it can be dragged.|r";
ITEMBUFF_HELP_TEXT7		= "|cffffffff"..ITEMBUFF_RESET.."|r|cff00ff00: resets the window to its default position.|r";
ITEMBUFF_HELP_TEXT8		= " ";
ITEMBUFF_HELP_TEXT9		= "|cff00ff00For example: |r|cffffffff/itembuff freeze|r|cff00ff00 will prevent the window from being dragged with the mouse.|r";

-- Localisation Strings
ITEMBUFF_ENCHANT_TIME_LEFT_MINUTES	= "%(%d+ min%)";	-- Enchantment name, followed by the time left in minutes
ITEMBUFF_ENCHANT_TIME_LEFT_SECONDS	= "%((%d+) sec%)";	-- Enchantment name, followed by the time left in seconds

ItemBuff_HideBuffsFromTheseItems = {
	"Firestone",	
	"Greater Firestone",
	"Lesser Firestone",
	"Major Firestone",
	"Windfury Totem"
};

-- non localised strings
-- DO NOT TRANSLATE OR CHANGE
ITEMBUFF_HELP_TEXT = {
	ITEMBUFF_HELP_TEXT0,
	ITEMBUFF_HELP_TEXT1,
	ITEMBUFF_HELP_TEXT2,
	ITEMBUFF_HELP_TEXT3,
	ITEMBUFF_HELP_TEXT4,
	ITEMBUFF_HELP_TEXT5,
	ITEMBUFF_HELP_TEXT6,
	ITEMBUFF_HELP_TEXT7,
	ITEMBUFF_HELP_TEXT8,
	ITEMBUFF_HELP_TEXT9,
};