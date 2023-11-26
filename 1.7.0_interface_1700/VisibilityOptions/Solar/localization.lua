--[[
--	Solar Localization
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
SOLAR_CONFIG_HEADER = "Transparency Options";
SOLAR_CONFIG_HEADER_INFO = "These options configure transparency of several frames.";
SOLAR_CONFIG_SLIDER = "Opacity Percentage";
SOLAR_CONFIG_SUFFIX = "%";
SOLAR_CONFIG_LABEL = "%s";
SOLAR_CONFIG_INFO	= "Check this to change the transparency of the %s.";

--------------------------------------------------
--
-- Chat Configuration
--
--------------------------------------------------
SOLAR_CHAT_COMMAND_INFO = "See /trans for usage instructions";
SOLAR_CHAT = "%s Transparency";

SOLAR_CHAT_COMMAND_HELP = {	"The number portion of the command is optional.";
														"It sets the opacity/transparency of the frame.";
														"Must be between 0 and 100, value is percentage.";	};
SOLAR_CHAT_SUBCOMMAND_INFO = "Enable to make the %s partially transparent.";