--[[
--	Lunar Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2476 2005-09-18 12:43:06Z mugendai $
--	$Rev: 2476 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-09-18 07:43:06 -0500 (Sun, 18 Sep 2005) $
--]]

--------------------------------------------------
--
-- UI Strings
--
--------------------------------------------------
LUNAR_CONFIG_HEADER = "Auto Hide Options";
LUNAR_CONFIG_HEADER_INFO = "These options configure auto hiding of several frames.";
LUNAR_CONFIG_SLIDER = "Hover Time to Popup";
LUNAR_CONFIG_SUFFIX = " second(s)";
LUNAR_CONFIG_LABEL = "%s";
LUNAR_CONFIG_INFO	= "Check this to make the %s only show when you move your mouse over it.";

--------------------------------------------------
--
-- Chat Strings
--
--------------------------------------------------
LUNAR_CHAT_COMMAND_INFO = "See /ahide for usage instructions";
LUNAR_CHAT_BOOL = "Auto Hide %s %%s";
LUNAR_CHAT_NUM = "Auto Hide %s Delay set to %%s";

LUNAR_CHAT_COMMAND_HELP = {	"The number portion of the command is optional.  "..
														"It sets the delay in seconds till a hovered "..
														"frame will show up.  Must be between 0 and 2, "..
														"but can be a fraction of a second, such as 0.4"; };
LUNAR_CHAT_SUBCOMMAND_INFO = "Enable to make the %s only show when you mouse over it.";