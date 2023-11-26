-- Version : English (by Mugendai)
-- Last Update : 02/17/2005

-- <= == == == == == == == == == == == == =>
-- => Cosmos Configuration Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_CONFIG_SECTION		= "Tackle Box";
TACKLEBOX_CONFIG_SECTION_INFO		= "These options help to make fishing more intuitive by assigning hotkeys to common fishing activities.";
TACKLEBOX_CONFIG_EASYCAST_ONOFF		= "Easy Cast";
TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO	= "If enabled, then when a fishing pole is equipped and you right click, you will cast the line.";
TACKLEBOX_CONFIG_FASTCAST_ONOFF		= "Fast Cast";
TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO	= "If enabled, you can throw your line at the same time you click your bobber.";
TACKLEBOX_CONFIG_SWITCH_ONOFF		= "Easy Switch Macro";
TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO	= "A 'Tackle Box' macro to easily switch your equipment, will be added to your macros.";

-- <= == == == == == == == == == == == == =>
-- => Chat Command Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_CHAT_COMMAND_INFO		= "Type /tb or /tacklebox for usage info.";
TACKLEBOX_CHAT_COMMAND_HELP		= {};
TACKLEBOX_CHAT_COMMAND_HELP[1]		= "Type /tacklebox or /tb plus the option and then on/off";
TACKLEBOX_CHAT_COMMAND_HELP[2]		= "easycast - "..TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;
TACKLEBOX_CHAT_COMMAND_HELP[3]		= "fastcast - "..TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;
TACKLEBOX_CHAT_COMMAND_HELP[4]		= "switch - Makes it easy to switch to your pole and back.";
TACKLEBOX_CHAT_COMMAND_HELP[5]		= "Example: /tb easycast on";


-- <= == == == == == == == == == == == == =>
-- => Output Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_OUTPUT_SET_POLE		= "Fishing pole set to %s.";
TACKLEBOX_OUTPUT_SET_MAIN		= "Main hand set to %s.";
TACKLEBOX_OUTPUT_SET_SECONDARY		= "Secondary hand set to %s.";
TACKLEBOX_OUTPUT_SET_FISHING_HAT	= "Fishing hat set to %s.";
TACKLEBOX_OUTPUT_SET_HAT		= "Normal hat set to %s.";
TACKLEBOX_OUTPUT_NEED_SET_POLE		= "Please equip the fishing pole you want to use, then try again.";
TACKLEBOX_OUTPUT_NEED_SET_HAND		= "Please equip the weapons you want to use, then try again.";
TACKLEBOX_OUTPUT_ENABLED		= "%s Enabled";
TACKLEBOX_OUTPUT_DISABLED		= "%s Disabled";
TACKLEBOX_OUTPUT_EASYCAST		= "Easy Cast";
TACKLEBOX_OUTPUT_FASTCAST		= "Fast Cast";

-- <= == == == == == == == == == == == == =>
-- => Other Strings
-- <= == == == == == == == == == == == == =>
TACKLEBOX_MACRO_NAME			= "Tackle Box";


-- <= == == == == == == == == == == == == =>
-- => Bindings
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_TACKLEBOXHEADER		= "TackleBox";
BINDING_NAME_TACKLEBOX_THROW		= "Start Fishing";


-- <= == == == == == == == == == == == == =>
-- => Skill names
-- <= == == == == == == == == == == == == =>
TACKLEBOX_SKILL_FISHING_NAME		= "Fishing";	-- matched to the SKILL

-- <= == == == == == == == == == == == == =>
-- => Item names
-- <= == == == == == == == == == == == == =>
TACKLEBOX_ITEM_FISHING_NAME		= "Fishing";		-- matched to the item tooltip
TACKLEBOX_ITEM_FISHING_POLE_NAME	= "Pole";
TACKLEBOX_ITEM_FISHING_ROD_NAME		= "Rod";

TACKLEBOX_BOBBER_NAME			= "Fishing Bobber";