--[[

This is the default localization file for the library.

This is for english translations, or items that are not modified by other locales.

]]

-- Localisation strings...
LYS_DESC		= "Lysidia's Library";
LYS_VERS_NUM	= 1.01;
LYS_VERS		= format("%s - Version %.1f", LYS_DESC, LYS_VERS_NUM);

LYS_MONEYTEXT_GOLD		= "g";
LYS_MONEYTEXT_SILVER	= "s";
LYS_MONEYTEXT_COPPER	= "c";

LYS_CMD_HELP			= "help";
LYS_CMD_LOADMESSAGE		= "load message";
LYS_CMD_ENABLE			= "enable";
LYS_CMD_DISABLE			= "disable";
LYS_CMD_LINEWIDTH		= "line width";

LYS_MSG_ENABLED			= "enabled";
LYS_MSG_DISABLED		= "disabled";
LYS_MSG_LOADMESSAGE		= LYS_DESC..": Load Message %s.";
LYS_MSG_LINEWIDTH		= LYS_DESC..": Line width set to %d pixel(s).";
LYS_MSG_LOADED			= " loaded.";

LYS_SLASH1		= "/lyslib";
LYS_SLASH2		= "/ll";

-- Help Text
LYS_HELP_TEXT0	= "---";
LYS_HELP_TEXT1	= format("%s%s command help: %s", LYS_COLOURS.YELLOW, LYS_DESC, LYS_COLOURS.NORMAL);
LYS_HELP_TEXT2	= format("%sUse %s%s <command>%s or %s%s <command>%s to perform the following commands:-%s",					LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, LYS_SLASH1, LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, LYS_SLASH2, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
LYS_HELP_TEXT3	= format("%s%s%s: Displays this help screen.%s",																LYS_COLOURS.WHITE, LYS_CMD_HELP, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
LYS_HELP_TEXT4	= format("%s%s <%s|%s>%s: Enable/Disable addon loading message.%s",												LYS_COLOURS.WHITE, LYS_CMD_LOADMESSAGE, LYS_CMD_ENABLE, LYS_CMD_DISABLE, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
LYS_HELP_TEXT5	= format("%s%s <width>%s: Sets the minimum drawn line width to <width>.  Width must be between 1 and 20.%s",	LYS_COLOURS.WHITE, LYS_CMD_LINEWIDTH, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
