--[[
--	Tackle Box Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2513 2005-09-23 02:07:13Z mugendai $
--	$Rev: 2513 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-09-22 21:07:13 -0500 (Thu, 22 Sep 2005) $
--]]

--------------------------------------------------
--
-- Binding Strings
--
--------------------------------------------------
BINDING_HEADER_TACKLEBOXHEADER		= "Tackle Box";
BINDING_NAME_TACKLEBOX_THROW		= "Start Fishing";
BINDING_NAME_TACKLEBOX_SWITCH		= "Switch Fishing Gear";

--------------------------------------------------
--
-- UI Strings
--
--------------------------------------------------
TACKLEBOX_CONFIG_SECTION		= "Tackle Box";
TACKLEBOX_CONFIG_SECTION_INFO		= "These options help to make fishing more intuitive by assigning hotkeys to common fishing activities.";
TACKLEBOX_CONFIG_EASYCAST_ONOFF		= "Easy Cast";
TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO	= "If enabled, then when a fishing pole is equipped and you right click, you will cast the line.";
TACKLEBOX_CONFIG_FASTCAST_ONOFF		= "Fast Cast";
TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO	= "If enabled, you can throw your line again while fishing or clicking the bobber.";
TACKLEBOX_CONFIG_EASYLURE_ONOFF		= "Easy Lure";
TACKLEBOX_CONFIG_EASYLURE_ONOFF_INFO	= "If enabled, and you have a lure, and your pole doesn't have one, then it will be put on your pole, instead of casting.";
TACKLEBOX_CONFIG_ALT_ONOFF		= "Alt for Easy Cast";
TACKLEBOX_CONFIG_ALT_ONOFF_INFO	= "If enabled, you will have to be pressing alt when you right click, to easy cast.";
TACKLEBOX_CONFIG_CTRL_ONOFF		= "Control for Easy Cast";
TACKLEBOX_CONFIG_CTRL_ONOFF_INFO	= "If enabled, you will have to be pressing control when you right click, to easy cast.";
TACKLEBOX_CONFIG_SHIFT_ONOFF		= "Shift for Easy Cast";
TACKLEBOX_CONFIG_SHIFT_ONOFF_INFO	= "If enabled, you will have to be pressing shift when you right click, to easy cast.";
TACKLEBOX_CONFIG_SWITCH_ONOFF		= "Easy Switch Macro";
TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO	= "A 'Tackle Box' macro, to easily switch your equipment, will be added to your macros.";

--------------------------------------------------
--
-- Chat Strings
--
--------------------------------------------------
TACKLEBOX_OUTPUT_SET_POLE		= "Fishing pole set to %s.";
TACKLEBOX_OUTPUT_SET_MAIN		= "Main hand set to %s.";
TACKLEBOX_OUTPUT_SET_SECONDARY		= "Secondary hand set to %s.";
TACKLEBOX_OUTPUT_SET_FISHING_HAT	= "Fishing hat set to %s.";
TACKLEBOX_OUTPUT_SET_FISHING_GLOVE	= "Fishing glove set to %s.";
TACKLEBOX_OUTPUT_SET_FISHING_BOOTS	= "Fishing boots set to %s.";
TACKLEBOX_OUTPUT_SET_HAT		= "Normal hat set to %s.";
TACKLEBOX_OUTPUT_SET_GLOVE		= "Normal glove set to %s.";
TACKLEBOX_OUTPUT_SET_BOOTS		= "Normal boots set to %s.";
TACKLEBOX_OUTPUT_NEED_SET_POLE		= "Please equip the fishing pole you want to use, then try again.";
TACKLEBOX_OUTPUT_NEED_SET_HAND		= "Please equip the weapon(s) you want to use, then try again.";
TACKLEBOX_OUTPUT_EASYCAST		= TACKLEBOX_CONFIG_EASYCAST_ONOFF;
TACKLEBOX_OUTPUT_FASTCAST		= TACKLEBOX_CONFIG_FASTCAST_ONOFF;
TACKLEBOX_OUTPUT_EASYLURE		= TACKLEBOX_CONFIG_EASYLURE_ONOFF;
TACKLEBOX_OUTPUT_SWITCH		= "Macro Creation";
TACKLEBOX_CHAT_SWITCH		= "Will switch between your fishing, and normal equipment.";
TACKLEBOX_OUTPUT_ALT		= TACKLEBOX_CONFIG_ALT_ONOFF;
TACKLEBOX_OUTPUT_CTRL		= TACKLEBOX_CONFIG_CTRL_ONOFF;
TACKLEBOX_OUTPUT_SHIFT		= TACKLEBOX_CONFIG_SHIFT_ONOFF;
TACKLEBOX_OUTPUT_OLD_SWITCH_WARN		= 'You are using an old format switch macro.  Please use "/tb sw" instead, or enable Make Macro option.';

--------------------------------------------------
--
-- Other Strings
--
--------------------------------------------------
TACKLEBOX_MACRO_NAME			= "Tackle Box";
TACKLEBOX_LOG_HEADER			= "Fishing Log";

--------------------------------------------------
--
-- Help Text
--
--------------------------------------------------
TACKLEBOX_CONFIG_INFOTEXT = {
	"[NOTE: If you are using Khaos, you may not be "..
	"seeing all of the options available.  For more "..
	"advanced options, increase the difficulty setting.]\n"..
	"\n"..
	"    Tackle Box is an addon that makes fishing much easier.  "..
	"It gives you a command to easily switch back and forth "..
	"between your fishing gear, and your normal gear.  To use "..
	"this command, you can either type /tb switch, or enable "..
	"the easy switch macro option which will add a macro that "..
	"you can drag to one of your action bars.\n\n"..
	"    It also allows you to simply, right click while you have a "..
	"fishing pole equipped, to cast your line.  You can choose to "..
	"only allow this when one of the system keys is allowed."..
	"\n\n"..
	"Easy Switch Usage:\n"..
	"-Put on your normal equipment, and then use the switch macro/command.\n"..
	"-Next put on your fishing equipment. (Including hat, gloves, and boots if you have them.)\n"..
	"-Use the switch macro/command again, and you are good to go.\n\n"..
	"Options Explainations:\n"..
	"Easy Cast - If this is enabled, then when you right click your "..
	"mouse while you have a fishing pole selected, the line will be "..
	"cast.  Fast Cast, and Easy Lure will only have an effect if this "..
	"is enabled.\n"..
	"\n"..
	"Fast Cast - Normally Tackle Box won't easy cast again until you "..
	"have finished fishing your current throw.  If this is enabled "..
	"then you easy cast your line while you are still fishing.  Doing "..
	"this will of course reset your current try.  This has the added "..
	"bonus of making it so that as soon as you right click the bobber "..
	"you will cast your line again.\n"..
	"\n"..
	"Easy Lure - This will put a lure on your pole if it needs one.  "..
	"If the pole doesn't have a lure on it, and you have a lure that "..
	"you can use, then the highest power lure will be applied to your pole, "..
	"instead of casting the line.  Once it is applied to your pole, just "..
	"right-click again to cast your line.\n"..
	"\n"..
	"Alt/Control/Shift for Easy Cast - If any of these are enabled "..
	"then you will have to be holding on of them when you right click "..
	"to do your easy cast.\n"..
	"\n"..
	"Easy Switch Macro - If this is enabled, then Tackle Box will make "..
	"a macro for you that you can drag into one of your bars, and "..
	"simply click to switch your equipment.  You can find the macro by "..
	"opening the main menu, then clicking on Macros.\n"..
	"\n"..
	"See page 3 for a list of slash commands.",
	
	"Tackle Box\n"..
	"\n"..
	"By: Mugendai\n"..
	"Special Thanks:\n"..
	"    Sinaloit: Origional use of textures to determine fishing skill and equipment.\n"..
	"    Aalny: Origional use of ItemLink's to store/recognize equipment.  As well as "..
			"a few tweaks and fixes.  Oh and the Shift click option.  Aalny did a "..
			"fair amount of good work.\n"..
	"    Groll: For asking for the Easy Lure feature\n"..
	"\n"..
	"Contact: mugekun@gmail.com"
}