--[[
--	Lunar Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2102 2005-07-11 10:31:35Z mugendai $
--	$Rev: 2102 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-07-11 05:31:35 -0500 (Mon, 11 Jul 2005) $
--]]

--------------------------------------------------
--
-- Cosmos Configuration
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
-- Chat Configuration
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