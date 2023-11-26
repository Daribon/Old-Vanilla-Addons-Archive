--[[
--	BarOptions Localization
--		"English Localization"
--	
--	English By: Mugendai
--	
--	$Id: localization.lua 1441 2005-05-05 08:41:19Z Sinaloit $
--	$Rev: 1441 $
--	$LastChangedBy: Sinaloit $
--	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $
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
BAROPTIONS_CONFIG_BLCOUNT = "Bottom Left Bar Buttons";
BAROPTIONS_CONFIG_BLCOUNT_INFO = "The number of buttons to show on the bottom left multi bar";
BAROPTIONS_CONFIG_BRCOUNT = "Bottom Right Bar Buttons";
BAROPTIONS_CONFIG_BRCOUNT_INFO = "The number of buttons to show on the bottom right multi bar";
BAROPTIONS_CONFIG_RCOUNT = "Right Bar Buttons";
BAROPTIONS_CONFIG_RCOUNT_INFO = "The number of buttons to show on the right multi bar";
BAROPTIONS_CONFIG_LCOUNT = "Left Bar Buttons";
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
BAROPTIONS_CONFIG_STANCE1 = "Stance 1 Page(Battle/Cat/Stealth)";
BAROPTIONS_CONFIG_STANCE1_INFO = "What page to use when in the first stance.";
BAROPTIONS_CONFIG_STANCE2 = "Stance 2 Page(Deffensive)";
BAROPTIONS_CONFIG_STANCE2_INFO = "What page to use when in the second stance.";
BAROPTIONS_CONFIG_STANCE3 = "Stance 3 Page(Berserker/Bear)";
BAROPTIONS_CONFIG_STANCE3_INFO = "What page to use when in the third stance.";

--------------------------------------------------
--
-- Chat Configuration
--
--------------------------------------------------
BAROPTIONS_CHAT_DEFAULTSETUP = "Default BarOptions Settings Loaded";
BAROPTIONS_CHAT_SIDEBARSETUP = "SideBar Settings Loaded";
BAROPTIONS_CHAT_ALTERNATEIDS = "Use Alternate ID Ranges %s";
BAROPTIONS_CHAT_TURNPAGES = "Turn Pages %s";
BAROPTIONS_CHAT_GROUPPAGES = "Group Pages %s";
BAROPTIONS_CHAT_STANCEBAR = "Stance Based Bottom Left Bar %s";
BAROPTIONS_CHAT_HIDEEMPTY = "Hide Empty Buttons %s";
BAROPTIONS_CHAT_HIDEKEYS = "Hide Hotkeys %s";
BAROPTIONS_CHAT_MULTIKEYS = "Enable Multi Bar Hotkeys %s";
BAROPTIONS_CHAT_SHORTKEYS = "Shorten Key Modifiers %s";
BAROPTIONS_CHAT_HIDEKEYMOD = "Hide Key Modifiers %s";
BAROPTIONS_CHAT_MAINART = "Main Bar Artwork %s%";
BAROPTIONS_CHAT_BLART = "Bottom Left Bar Artwork %s%";
BAROPTIONS_CHAT_BRART = "Bottom Right Bar Artwork %s%";
BAROPTIONS_CHAT_RART = "Right Bar Artwork %s%";
BAROPTIONS_CHAT_LART = "Left Bar Artwork %s%";
BAROPTIONS_CHAT_BLCOUNT = "Bottom Left Bar Buttons %s";
BAROPTIONS_CHAT_BRCOUNT = "Bottom Right Bar Buttons %s";
BAROPTIONS_CHAT_RCOUNT = "Right Bar Buttons %s";
BAROPTIONS_CHAT_LCOUNT = "Left Bar Buttons %s";
BAROPTIONS_CHAT_RANGECOLOR_RANGE = " Must be between 1 and 0, like 0.2";
BAROPTIONS_CHAT_RANGECOLOR = "Out of Range Coloring %s";
BAROPTIONS_CHAT_RANGECOLORRED = "Range Color Red set to %s%";
BAROPTIONS_CHAT_RANGECOLORGREEN = "Range Color Green set to %s%";
BAROPTIONS_CHAT_RANGECOLORBLUE = "Range Color Blue set to %s%";
BAROPTIONS_CHAT_CUSTOMSTANCES = "Custom Stance Pages %s";
BAROPTIONS_CHAT_STANCE_RANGE = " Must be between 1 and 10";
BAROPTIONS_CHAT_STANCE0 = "No Stance Page set to %s";
BAROPTIONS_CHAT_STANCE1 = "Stance 1 Page(Battle/Cat) set to %s";
BAROPTIONS_CHAT_STANCE2 = "Stance 2 Page(Deffensive/Aquatic) set to %s";
BAROPTIONS_CHAT_STANCE3 = "Stance 3 Page(Berserker/Bear) set to %s";