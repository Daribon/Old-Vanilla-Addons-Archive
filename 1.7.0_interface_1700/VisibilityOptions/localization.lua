--[[
--	Eclipse Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2148 2005-07-21 01:09:35Z mugendai $
--	$Rev: 2148 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-07-20 20:09:35 -0500 (Wed, 20 Jul 2005) $
--]]

--------------------------------------------------
--
-- Binding Strings
--
--------------------------------------------------
BINDING_HEADER_ECLIPSEHEADER		= "Visibility Options";
BINDING_NAME_TOGGLETOTAL				= "Toggle UI Hiding";
BINDING_NAME_TOGGLELUNAR				= "Toggle UI Autohide";
BINDING_NAME_TOGGLESOLAR				= "Toggle UI Transparency";

--------------------------------------------------
--
-- Cosmos Configuration
--
--------------------------------------------------
ECLIPSE_CONFIG_SECTION				= "Visibility Options";
ECLIPSE_CONFIG_SECTION_INFO		= "Configures visibility options for many parts of the user interface.";

--------------------------------------------------
--
-- Cosmos Configuration
--
--------------------------------------------------
ECLIPSE_CONFIG_GLOBAL				= "Global UI";
ECLIPSE_CONFIG_MAINBAR			= "Main Bar";
ECLIPSE_CONFIG_ACTIONBAR		= "Main Action Bar";
ECLIPSE_CONFIG_MENUBUTTONS	= "Main Bar Buttons";
ECLIPSE_CONFIG_BAGBUTTONS		= "Bag Buttons";
ECLIPSE_CONFIG_SHAPEBAR			= "Stance/Shape/Aura Bar";
ECLIPSE_CONFIG_PETBAR				= "Pet Bar";
ECLIPSE_CONFIG_MULTIBL			= "Bottom Left Multibar";
ECLIPSE_CONFIG_MULTIBR			= "Bottom Right Multibar";
ECLIPSE_CONFIG_MULTIR				= "Right Multibar";
ECLIPSE_CONFIG_MULTIL				= "Left Multibar";
ECLIPSE_CONFIG_MINIMAP			= "Mini Map";
ECLIPSE_CONFIG_BUFFS				= "Buffs";
ECLIPSE_CONFIG_STATS				= "Character Stats";
ECLIPSE_CONFIG_PARTY				= "Party Members";
ECLIPSE_CONFIG_CHATBUTTONS	= "Chat Frame Buttons";

--------------------------------------------------
--
-- Error Messages
--
--------------------------------------------------
ECLIPSE_ERROR_XUI = "PopNUI or TransNUI found, disabling VisibilityOptions";
ECLIPSE_ERROR_XUI_INFO = "VisibilityOptions is a replacement of PopNUI and TransNUI, and these addons can not be used at the same time.  Please delete PopNUI and TransNUI.  VisibilityOptions will not function until you do.";

--------------------------------------------------
--
-- Help Text
--
--------------------------------------------------
ECLIPSE_CONFIG_INFOTEXT = {
	"[NOTE: If you are using Khaos, you may not be "..
	"seeing all of the options available.  For more "..
	"advanced options, increase the difficulty setting.]\n"..
	"\n"..
	"    Visibility Options is an addon that allows you to hide, "..
	"autohide, or make transparent several of the frames in the "..
	"game.  By hide, I mean to complete make it gone.  By autohide "..
	"I mean, it will only show, if you move your mouse over it.  And "..
	"by make transparent, I mean you can make the verying frames "..
	"partially see-thru.\n"..
	"\n"..
	"    The usage of the varying options is pretty self explainatory. "..
	"But I will go ahead and explain a couple of things.  Frames that "..
	"can be hidden, are simply on/off options.\n"..
	"    Autohiden frames have "..
	"both an option to enable/disable autohiding of the frame, and an "..
	"option to set the amount of time that the mouse needs to hover "..
	"over the frame before it will show.\n"..
	"    Transparent frames also have an option to turn on/off making "..
	"them transparent.  But they also have an option to set just how "..
	"transparent the frame should be.\n"..
	"\n"..
	"See pages 3, 4, and 5 for a list of slash commands.",
	
	"Cast Options\n"..
	"\n"..
	"By: Mugendai\n"..
	"\n"..
	"Contact: mugekun@gmail.com"
}
