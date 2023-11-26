--[[
--	BarOptions Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2167 2005-07-24 05:01:45Z mugendai $
--	$Rev: 2167 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-07-24 00:01:45 -0500 (Sun, 24 Jul 2005) $
--]]

--------------------------------------------------
--
-- Binding Strings
--
--------------------------------------------------
BINDING_HEADER_INSTANTACTIONBAR = "Instant Action Bar Pages";

BINDING_NAME_INSTANTACTIONBAR1 = "Instant Action Page 1";
BINDING_NAME_INSTANTACTIONBAR2 = "Instant Action Page 2";
BINDING_NAME_INSTANTACTIONBAR3 = "Instant Action Page 3";
BINDING_NAME_INSTANTACTIONBAR4 = "Instant Action Page 4";
BINDING_NAME_INSTANTACTIONBAR5 = "Instant Action Page 5";
BINDING_NAME_INSTANTACTIONBAR6 = "Instant Action Page 6";

--------------------------------------------------
--
-- Hotkey Constant
--
--------------------------------------------------
--List of shortened names of hotkeys
BO_SHORTHOTKEYS = {
	["Shift"] = "S",
	["Alt"] = "A",
	["Ctrl"] = "C",
	["Control"] = "C",
	["shift"] = "S",
	["alt"] = "A",
	["ctrl"] = "C",
	["control"] = "C",
	["SHIFT"] = "S",
	["ALT"] = "A",
	["CTRL"] = "C",
	["CONTROL"] = "C",
	["Num Pad"] = "KP"
};

--------------------------------------------------
--
-- Cosmos Configuration
--
--------------------------------------------------
BAROPTIONS_CONFIG_SECTION = "Bar Options";
BAROPTIONS_CONFIG_SECTION_INFO = "Configures various options for the various bars.";
BAROPTIONS_CONFIG_BAR_HEADER = "Bar Options";
BAROPTIONS_CONFIG_BAR_HEADER_INFO = "Options related to the behavior of all the bars.";
BAROPTIONS_CONFIG_DEFAULTSETUP = "Default Setup";
BAROPTIONS_CONFIG_DEFAULTSETUP_NAME = "Default Setup";
BAROPTIONS_CONFIG_DEFAULTSETUP_INFO = "Sets all options, and side bar positions to their defaults.";
BAROPTIONS_CONFIG_SIDEBARSETUP = "SideBar Setup";
BAROPTIONS_CONFIG_SIDEBARSETUP_NAME = "SideBar Setup";
BAROPTIONS_CONFIG_SIDEBARSETUP_INFO = "Sets up options, and side bar positions, to classic SideBar style.";
BAROPTIONS_CONFIG_ALTERNATEIDS = "Use Alternate ID Ranges";
BAROPTIONS_CONFIG_ALTERNATEIDS_INFO = "If enabled, the multi bars will use ID ranges similar to what the old Cosmos bars did.";
BAROPTIONS_CONFIG_TURNPAGES = "Turn Pages";
BAROPTIONS_CONFIG_TURNPAGES_INFO = "If enabled, bottom left multi bar will change pages when the main bar changes pages.  Requires Alternate ID's enabled.";
BAROPTIONS_CONFIG_GROUPPAGES = "Group Pages";
BAROPTIONS_CONFIG_GROUPPAGES_INFO = "If enabled, bottom left multi bar and the main bar will act as if they are sharing 3 pages of 24 buttons.  Requires Turn Pages enabled.";
BAROPTIONS_CONFIG_STANCEBAR = "Stance Based Bottom Left Bar";
BAROPTIONS_CONFIG_STANCEBAR_INFO = "If enabled, the bottom left multibar will change it's ID range based on what stance you are in.  Disables bottom left bar paging.";
BAROPTIONS_CONFIG_HIDEEMPTY = "Hide Empty Buttons";
BAROPTIONS_CONFIG_HIDEEMPTY_INFO = "If enabled, the bars will hide buttons when they have no action in them.";
BAROPTIONS_CONFIG_MOVEMAINBAR_HEADER = "Main Bar Position";
BAROPTIONS_CONFIG_MOVEMAINBAR_HEADER_INFO = "Options for moving the main bar, only one will work at a time.";
BAROPTIONS_CONFIG_MAINBARCENTER = "Move to Center";
BAROPTIONS_CONFIG_MAINBARCENTER_INFO = "If this is enabled the main bar will be moved to the bottom center.";
BAROPTIONS_CONFIG_MAINBARLEFT = "Move to Left";
BAROPTIONS_CONFIG_MAINBARLEFT_INFO = "If this is enabled the main bar will be moved to the bottom left.";
BAROPTIONS_CONFIG_MAINBARRIGHT = "Move to Right";
BAROPTIONS_CONFIG_MAINBARRIGHT_INFO = "If this is enabled the main bar will be moved to the bottom right.";
BAROPTIONS_CONFIG_HOTKEY_HEADER = "Hotkeys";
BAROPTIONS_CONFIG_HOTKEY_HEADER_INFO = "Options related to the hotkey text on the various bars.";
BAROPTIONS_CONFIG_HIDEKEYS = "Hide Hotkeys";
BAROPTIONS_CONFIG_HIDEKEYS_INFO = "If enabled, will hide the hotkeys on all bars.";
BAROPTIONS_CONFIG_MULTIKEYS = "Enable Multi Bar Hotkeys";
BAROPTIONS_CONFIG_MULTIKEYS_INFO = "If enabled, will allow hotkeys on the multi bars to be shown.";
BAROPTIONS_CONFIG_SHORTKEYS = "Shorten Key Modifiers";
BAROPTIONS_CONFIG_SHORTKEYS_INFO = "If enabled, will shorten the key modifiers so instead of for instance 'Shift', it will say 'S'";
BAROPTIONS_CONFIG_HIDEKEYMOD = "Hide Key Modifiers";
BAROPTIONS_CONFIG_HIDEKEYMOD_INFO = "If enabled, will hide the hotkey modifiers like CTRL ALT and SHIFT.";
BAROPTIONS_CONFIG_ART_HEADER = "Bar Artwork";
BAROPTIONS_CONFIG_ART_HEADER_INFO = "Options related to showing artwork on the various bars.";
BAROPTIONS_CONFIG_MAINART = "Main Bar Artwork";
BAROPTIONS_CONFIG_MAINART_INFO = "If enabled, will show the dragon art at the ends of the Main Bar.";
BAROPTIONS_CONFIG_BLART = "Bottom Left Bar Artwork";
BAROPTIONS_CONFIG_BLART_INFO = "If enabled, will show the background art on the bottom left multi bar.";
BAROPTIONS_CONFIG_BRART = "Bottom Right Bar Artwork";
BAROPTIONS_CONFIG_BRART_INFO = "If enabled, will show the background art on the bottom right multi bar.";
BAROPTIONS_CONFIG_RART = "Right Bar Artwork";
BAROPTIONS_CONFIG_RART_INFO = "If enabled, will show the background art on the right multi bar.";
BAROPTIONS_CONFIG_LART = "Left Bar Artwork";
BAROPTIONS_CONFIG_LART_INFO = "If enabled, will show the background art on the left multi bar.";
BAROPTIONS_CONFIG_COUNT_HEADER = "Number of Buttons";
BAROPTIONS_CONFIG_COUNT_HEADER_INFO = "Controls the number of buttons on the multi bars.";
BAROPTIONS_CONFIG_COUNT_NAME = "Buttons";
BAROPTIONS_CONFIG_COUNT_SUFFIX = "";
BAROPTIONS_CONFIG_BLCOUNT = "Bottom Left Bar";
BAROPTIONS_CONFIG_BLCOUNT_INFO = "The number of buttons to show on the bottom left multi bar";
BAROPTIONS_CONFIG_BRCOUNT = "Bottom Right Bar";
BAROPTIONS_CONFIG_BRCOUNT_INFO = "The number of buttons to show on the bottom right multi bar";
BAROPTIONS_CONFIG_RCOUNT = "Right Bar";
BAROPTIONS_CONFIG_RCOUNT_INFO = "The number of buttons to show on the right multi bar";
BAROPTIONS_CONFIG_LCOUNT = "Left Bar";
BAROPTIONS_CONFIG_LCOUNT_INFO = "The number of buttons to show on the left multi bar";
BAROPTIONS_CONFIG_RANGECOLOR_HEADER = "Range Coloring";
BAROPTIONS_CONFIG_RANGECOLOR_HEADER_INFO = "Options related to out of range coloring.";
BAROPTIONS_CONFIG_RANGECOLOR = "Out of Range Coloring";
BAROPTIONS_CONFIG_RANGECOLOR_INFO = "Colors an action button when it is out of range of the target.";
BAROPTIONS_CONFIG_RANGECOLORRED = "Range Color Red";
BAROPTIONS_CONFIG_RANGECOLORRED_INFO = "Amount of red to show when coloring out of range buttons.";
BAROPTIONS_CONFIG_RANGECOLORGREEN = "Range Color Green";
BAROPTIONS_CONFIG_RANGECOLORGREEN_INFO = "Amount of green to show when coloring out of range buttons.";
BAROPTIONS_CONFIG_RANGECOLORBLUE = "Range Color Blue";
BAROPTIONS_CONFIG_RANGECOLORBLUE_INFO = "Amount of blue to show when coloring out of range buttons.";
BAROPTIONS_CONFIG_RANGECOLOR_NAME = "Intensity";
BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX = "%";

BAROPTIONS_CONFIG_STANCE_HEADER = "Custom Stance Pages";
BAROPTIONS_CONFIG_STANCE_HEADER_INFO = "Allows you to customize which page of buttons to use for stances";
BAROPTIONS_CONFIG_STANCE_NAME = "Page";
BAROPTIONS_CONFIG_STANCE_SUFFIX = "";
BAROPTIONS_CONFIG_CUSTOMSTANCES = "Enable Custom Stance Pages";
BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO = "If enabled, the custom stance page settings will be used to determine which page of buttons to use per stance.";
BAROPTIONS_CONFIG_STANCE0 = "No Stance Page";
BAROPTIONS_CONFIG_STANCE0_INFO = "What page to use when not in a particular stance.";
BAROPTIONS_CONFIG_STANCE1 = "Stance 1 Page";
BAROPTIONS_CONFIG_STANCE1_INFO = "What page to use when in the first stance(Battle/Cat/Stealth).";
BAROPTIONS_CONFIG_STANCE2 = "Stance 2 Page";
BAROPTIONS_CONFIG_STANCE2_INFO = "What page to use when in the second stance(Deffensive).";
BAROPTIONS_CONFIG_STANCE3 = "Stance 3 Page";
BAROPTIONS_CONFIG_STANCE3_INFO = "What page to use when in the third stance(Berserker/Bear).";

--------------------------------------------------
--
-- Chat Configuration
--
--------------------------------------------------
BAROPTIONS_CHAT_DEFAULTSETUP = "Default BarOptions Settings Loaded";
BAROPTIONS_CHAT_SIDEBARSETUP = "SideBar Settings Loaded";
BAROPTIONS_CHAT_ALTERNATEIDS = BAROPTIONS_CONFIG_ALTERNATEIDS;
BAROPTIONS_CHAT_TURNPAGES = BAROPTIONS_CONFIG_TURNPAGES;
BAROPTIONS_CHAT_GROUPPAGES = BAROPTIONS_CONFIG_GROUPPAGES;
BAROPTIONS_CHAT_STANCEBAR = BAROPTIONS_CONFIG_STANCEBAR;
BAROPTIONS_CHAT_HIDEEMPTY = BAROPTIONS_CONFIG_HIDEEMPTY;
BAROPTIONS_CHAT_HIDEKEYS = BAROPTIONS_CONFIG_HIDEKEYS;
BAROPTIONS_CHAT_MULTIKEYS = BAROPTIONS_CONFIG_MULTIKEYS;
BAROPTIONS_CHAT_SHORTKEYS = BAROPTIONS_CONFIG_SHORTKEYS;
BAROPTIONS_CHAT_HIDEKEYMOD = BAROPTIONS_CONFIG_HIDEKEYMOD;
BAROPTIONS_CHAT_MAINART = BAROPTIONS_CONFIG_MAINART;
BAROPTIONS_CHAT_BLART = BAROPTIONS_CONFIG_BLART;
BAROPTIONS_CHAT_BRART = BAROPTIONS_CONFIG_BRART;
BAROPTIONS_CHAT_RART = BAROPTIONS_CONFIG_RART;
BAROPTIONS_CHAT_LART = BAROPTIONS_CONFIG_LART;
BAROPTIONS_CHAT_BLCOUNT = BAROPTIONS_CONFIG_BLCOUNT.." Buttons";
BAROPTIONS_CHAT_BRCOUNT = BAROPTIONS_CONFIG_BRCOUNT.." Buttons";
BAROPTIONS_CHAT_RCOUNT = BAROPTIONS_CONFIG_RCOUNT.." Buttons";
BAROPTIONS_CHAT_LCOUNT = BAROPTIONS_CONFIG_LCOUNT.." Buttons";
BAROPTIONS_CHAT_RANGECOLOR_RANGE = " Must be between 1 and 100, like 22";
BAROPTIONS_CHAT_RANGECOLOR = BAROPTIONS_CONFIG_RANGECOLOR;
BAROPTIONS_CHAT_CUSTOMSTANCES = "Custom Stance Pages";
BAROPTIONS_CHAT_STANCE_RANGE = " Must be between 1 and 10";
BAROPTIONS_CHAT_STANCE0 = "No Stance Page";
BAROPTIONS_CHAT_STANCE1 = "Stance 1 Page(Battle/Cat)";
BAROPTIONS_CHAT_STANCE2 = "Stance 2 Page(Deffensive/Aquatic)";
BAROPTIONS_CHAT_STANCE3 = "Stance 3 Page(Berserker/Bear)";

--------------------------------------------------
--
-- Help Text
--
--------------------------------------------------
BAROPTIONS_CONFIG_INFOTEXT = {
	"[NOTE: If you are using Khaos, you may not be "..
	"seeing all of the options available.  For more "..
	"advanced options, increase the difficulty setting.]\n"..
	"\n"..
	"    BarOptions is an addon that allows you to reconfigure the "..
	"behavior of the varying action bars in the game.  It also "..
	"provides a bonus action bar(the bar used when a player is "..
	"using a stance, shapeshift, or stealth mode.  This special "..
	"version of the bonus bar is needed by other mods to better "..
	"control the appearance of the bar.\n\n"..
	"See page 3 for a list of options.",
	
	"Bar Options\n"..
	"\n"..
	"By: Mugendai\n"..
	"\n"..
	"Contact: mugekun@gmail.com"
}