-- Version : English (by AlexYoshi, Sarf, Mugendai, Vjeux ...)
-- Last Update : 02/17/2005

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_COSMOS		= "Cosmos Bindings";
BINDING_HEADER_COSMOSKEYS	= "Cosmos Key Bindings";

BINDING_NAME_ACTIONBUTTON1ALT	= "Trigger action button 1 on next page";
BINDING_NAME_ACTIONBUTTON2ALT	= "Trigger action button 2 on next page";
BINDING_NAME_ACTIONBUTTON3ALT	= "Trigger action button 3 on next page";
BINDING_NAME_ACTIONBUTTON4ALT	= "Trigger action button 4 on next page";
BINDING_NAME_ACTIONBUTTON5ALT	= "Trigger action button 5 on next page";
BINDING_NAME_ACTIONBUTTON6ALT	= "Trigger action button 6 on next page";
BINDING_NAME_ACTIONBUTTON7ALT	= "Trigger action button 7 on next page";
BINDING_NAME_ACTIONBUTTON8ALT	= "Trigger action button 8 on next page";
BINDING_NAME_ACTIONBUTTON9ALT	= "Trigger action button 9 on next page";
BINDING_NAME_ACTIONBUTTON10ALT	= "Trigger action button 10 on next page";
BINDING_NAME_ACTIONBUTTON11ALT	= "Trigger action button 11 on next page";
BINDING_NAME_ACTIONBUTTON12ALT	= "Trigger action button 12 on next page";

BINDING_NAME_INSTANTACTIONBAR1	= "Instant Action Page 1";
BINDING_NAME_INSTANTACTIONBAR2	= "Instant Action Page 2";
BINDING_NAME_INSTANTACTIONBAR3	= "Instant Action Page 3";
BINDING_NAME_INSTANTACTIONBAR4	= "Instant Action Page 4";
BINDING_NAME_INSTANTACTIONBAR5	= "Instant Action Page 5";
BINDING_NAME_INSTANTACTIONBAR6	= "Instant Action Page 6"; 

BINDING_NAME_TOGGLECOSMOSFEATURES	= "Toggle the Cosmos Features Frame";
BINDING_NAME_RELOADUI			= "Reload User Interface";

-- <= == == == == == == == == == == == == =>
-- => Global tags that appear in multiple places
-- <= == == == == == == == == == == == == =>
ALLIANCE			= "Alliance";
HORDE				= "Horde";

GLOBAL_AUCTION_TAG_L		= "auction";
GLOBAL_AUCTION_TAG_C		= "Auction";

GLOBAL_ZONE_TAG_L		= "zone";
GLOBAL_ZONE_TAG_C		= "Zone";

GLOBAL_ITEM_TAG_L		= "item";
GLOBAL_ITEM_TAG_C		= "Item";

GLOBAL_HELP_TAG_L		= "help";
GLOBAL_HELP_TAG_C		= "Help";

GLOBAL_REMOVE_TAG_L		= "remove";
GLOBAL_REMOVE_TAG_C		= "Remove";

GLOBAL_REFRESH_TAG_L		= "refresh";
GLOBAL_REFRESH_TAG_C		= "Refresh";

GLOBAL_RESET_TAG_L		= "reset";
GLOBAL_RESET_TAG_C		= "Reset";

GLOBAL_SORT_TAG_L		= "sort";
GLOBAL_SORT_TAG_C		= "Sort";

GLOBAL_CLEAR_TAG_L		= "clear";
GLOBAL_CLEAR_TAG_C		= "Clear";

GLOBAL_CANCEL_TAG_L		= "cancel";
GLOBAL_CANCEL_TAG_C		= "Cancel";

GLOBAL_EXIT_TAG_L		= "exit";
GLOBAL_EXIT_TAG_C		= "Exit";

GLOBAL_OK_TAG_C			= "OK";

-- <= == == == == == == == == == == == == =>
-- => Cosmos
-- <= == == == == == == == == == == == == =>
COSMOS_OPTIONS_TITLE		= "Cosmos Options";
COSMOS_FEATURES_TOOLTIP		= "Cosmos";
COSMOS_FEATURES_TITLE		= "Cosmos";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Config
-- <= == == == == == == == == == == == == =>
COSMOS_CONFIG_SEP		= "Interface Settings";
COSMOS_CONFIG_SEP_INFO		= "These settings allow you to adjust the transparency of the chat window and the size of certain UI components.";
COSMOS_CONFIG_PLHPMPXP		= "Always Display Player HP, Mana and Experience";
COSMOS_CONFIG_PLHPMPXP_INFO	= "Turns on the number for the player's\n health, mana and experience bars.";
COSMOS_CONFIG_PARTYHP		= "Always Display Party HP";
COSMOS_CONFIG_PARTYHP_INFO	= "Turns on the number for the party's\n health bars.";
COSMOS_CONFIG_PARTYMANA		= "Always Display Party mana";
COSMOS_CONFIG_PARTYMANA_INFO	= "Turns on the number for the party's\n secondary bars.";
COSMOS_CONFIG_RELOCTT		= "Relocate the tooltip to the lower right corner.";
COSMOS_CONFIG_RELOCTT_INFO	= "This checkbox will put the tooltip back in its original location.";
COSMOS_CONFIG_RELOCTT_2M	= "Relocate the tooltip to the mouse. Overrides all anchors";
COSMOS_CONFIG_RELOCTT_2M_INFO	= "This checkbox will put the tooltip where the mouse is located";
COSMOS_CONFIG_RELOCTT_UBER	= "Relocate Uber Tooltips";
COSMOS_CONFIG_RELOCTT_UBER_INFO = "Relocate Uber tooltips to normal positions.";
COSMOS_CONFIG_S2SELL		= "Shift key to sell.";
COSMOS_CONFIG_S2SELL_INFO	= "If this checkbox is checked, you'll need to press the shift key and click on the right button to sell an object.";
COSMOS_CONFIG_PARTYBUFF 	= "Hide the party buffs ";
COSMOS_CONFIG_PARTYBUFF_INFO	= "Removes the party's spell buffs from view unless you mouse-over their portrait.";
COSMOS_CONFIG_QUESTSCROLL	= "Enable Quest Text Scroll";
COSMOS_CONFIG_QUESTSCROLL_INFO	= "Checking here will cause the quest text to scroll, rather than appear instantly.";
COSMOS_CONFIG_QUESTSCROLL_CHARS	= "Characters";
COSMOS_CONFIG_QUESTSCROLL_APPEND= "cps";
COSMOS_CONFIG_MPP		= "Percentage value on the Party Members Mana bar";
COSMOS_CONFIG_MPP_INFO		= "/";
COSMOS_CONFIG_PETHP		= "Always Display Pet HP";
COSMOS_CONFIG_PETHP_INFO	= "Turns on the number for the pet's\n health bar.";
COSMOS_CONFIG_PETMANA		= "Always Display Pet Focus";
COSMOS_CONFIG_PETMANA_INFO	= "Turns on the number for the pet's\n happiness meter.";
COSMOS_CONFIG_FPSMOVE		= "Move FPS to Top Left";
COSMOS_CONFIG_FPSMOVE_INFO	= "Moves the FPS display to the top left corner of the screen.";
COSMOS_CONFIG_USECHAN		= "Use Cosmos Channel Functionality";
COSMOS_CONFIG_USECHAN_INFO	= "Creates a Cosmos and a ZParty channel to allow communication between clients.  If this is disabled, QuestShare will not work.";
COSMOS_CONFIG_MWHEELCHAT	= "Mousewheel scrolls chat";
COSMOS_CONFIG_MWHEELCHAT_INFO	= "Allows you to use the mousewheel of your mouse to scroll the chat.";
COSMOS_CONFIG_DISTANCE		= "Increase targeting distance";
COSMOS_CONFIG_DISTANCE_INFO	= "Allows you to increase the distance at which you can target stuff using the script functions.";	-- NEW AND NOT TRANSLATED
COSMOS_CONFIG_DISTANCE_CHAT	= "You will need to restart WoW before the targeting distance change takes effect.";			-- NEW AND NOT TRANSLATED
COSMOS_CONFIG_SHORTCUT_NAMES	= "Use abbreviated button shortcut names";								-- NEW AND NOT TRANSLATED
COSMOS_CONFIG_SHORTCUT_NAMES_INFO	= "Will abbreviate button shortcuts, like Shift-Alt-A will be S-A-A";				-- NEW AND NOT TRANSLATED

COSMOS_CONFIG_RESET_PARTY_FRAMES		= "Reset party windows";								-- NEW AND NOT TRANSLATED
COSMOS_CONFIG_RESET_PARTY_FRAMES_INFO	= "Will reset party windows to the default positions";				-- NEW AND NOT TRANSLATED
COSMOS_CONFIG_RESET_PARTY_FRAMES_TEXT	= "Reset";								-- NEW AND NOT TRANSLATED


COSMOS_BUTTON_COSMOS		= "Cosmos";
COSMOS_BUTTON_COSMOS_SUB	= "Configure";
COSMOS_BUTTON_COSMOS_TIP	= "Configure Cosmos";

COSMOS_BUTTON_COSMOS_HELP	= "Cosmos Guide";
COSMOS_BUTTON_COSMOS_HELP_SUB	= "Information";
COSMOS_BUTTON_COSMOS_HELP_TIP	= "Open the Cosmos guide\n |cFFEE3333(Launches Browser)|r";

COSMOS_BUTTON_BANK		= "Bank";
COSMOS_BUTTON_BANK_SUB		= "Show Bank";
COSMOS_BUTTON_BANK_TIP		= "Displays the Bank contents.\n Note: You cannot pick up items.";

COSMOS_COMM			= {"/cosmos", "/cos"};
COSMOS_DESC			= "/cosmos <player> - Check if the player is using Cosmos.";
COSMOS_DONTHAVE			= "%s seems NOT to be a Cosmos user !";
COSMOS_HAVE			= "%s is a Cosmos user !";

-- <= == == == == == == == == == == == == =>
-- => Shapeshift Commands
-- <= == == == == == == == == == == == == =>
SHAPE_COMM1			= {"/stance", "/stnc", "/setstance"};
SHAPE_COMM1_INFO		= "Allows you to change stances from the macro box. Try /stance [battle|btl|def|bzrk] |cFF880022Note: Only works in macros|r";
SHAPE_COMM2			= {"/stealth"};
SHAPE_COMM2_INFO		= "Allows you to stealth from macros |c00880022Note: Only works in macros|r";
SHAPE_COMM3			= {"/shapeshift", "/shift", "/setshape"};
SHAPE_COMM3_INFO		= "Allows you to shapeshift from the macro box. Try /shift [1-4|bear|seal|cat|travel] |cFF880022Note: Only works in macros|r";

-- <= == == == == == == == == == == == == =>
-- => Language Commands
-- <= == == == == == == == == == == == == =>
LANGUAGE_COMM			= {"/language", "/lang"};
LANGUAGE_COMM_INFO		= "Changes the language used in the main chat box";
LANGUAGE_HELP1			= "Usage: /language <language>";
LANGUAGE_HELP2			= "Languages known:";
LANGUAGE_NOWSPEAK		= "Now speaking %s";
LANGUAGE_UNKNOWN		= "Language \"%s\" unknown!";

-- <= == == == == == == == == == == == == =>
-- => Chat string
-- <= == == == == == == == == == == == == =>
COSMOS_CHAT_DOING_REORDER	= "Reordering chat channels, please wait.";
COSMOS_CHAT_DONE_REORDER	= "Finished reordering chat channels.";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Help (by command line)
-- <= == == == == == == == == == == == == =>
COSMOS_HELP_COMM		= { "/chelp", "/esh", "/esmhelp", "/ehelp", "/cosmoshelp", "/eshelp", "/coshelp" };
COSMOS_HELP_COMM_INFO		= "Displays the list of commands registered via Cosmos";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Version (by command line)
-- <= == == == == == == == == == == == == =>
COSMOS_VERSION_COMM		= { "/cversion" };
COSMOS_VERSION_COMM_INFO	= "Shows the current revision number of Cosmos.";

-- <= == == == == == == == == == == == == =>
-- => Reload UI (by command line)
-- <= == == == == == == == == == == == == =>
COSMOS_RELOADUI_COMM		= {"/rl", "/reloadui"};
COSMOS_RELOADUI_COMM_INFO	= "Reload UI";

-- <= == == == == == == == == == == == == =>
-- => Stop (moving) command
-- <= == == == == == == == == == == == == =>
COSMOS_STOP_COMM		= {"/stop"};
COSMOS_STOP_COMM_INFO		= "Stop all movement";

-- <= == == == == == == == == == == == == =>
-- => Class Settings (by command line)
-- <= == == == == == == == == == == == == =>
COSMOS_CLASS_SETTINGS_COMM		= {"/settingsbyclass", "/classsettings", "/settingsclass"};
COSMOS_CLASS_SETTINGS_PARAM_SAVE	= "save"; -- must be lowercase to work
COSMOS_CLASS_SETTINGS_PARAM_LOAD	= "load"; -- must be lowercase to work
COSMOS_CLASS_SETTINGS_COMM_INFO		= "Load or save settings depending on your current class.\nUse '%s' as a parameter to save the settings, and '%s' to load the settings.";
COSMOS_CLASS_SETTINGS_HELP1		= "Usage: /settingsbyclass <%s|%s>";
COSMOS_CLASS_SETTINGS_HELP2		= "Unknown parameter for /settingsbyclass";
COSMOS_CLASS_SETTINGS_LOADED		= "Loaded settings by class from %s settings";
COSMOS_CLASS_SETTINGS_LOADED_ERROR	= "Error: Could not load settings by class from %s settings";
COSMOS_CLASS_SETTINGS_SAVED		= "Saved settings by class for %s";
COSMOS_CLASS_SETTINGS_SAVED_ERROR	= "Error: Could not save settings by class for %s";

-- <= == == == == == == == == == == == == =>
-- => Friend Commands
-- <= == == == == == == == == == == == == =>
FCOMMAND_COMM			= { "/f" };
FCOMMAND_COMM_INFO		= "/f [a|r|l|m] : /f add <player>, /f remove <player>, /f list, /f message <message>";
FCOMMAND_ONLINE			= "Online Friends:";
FCOMMAND_OFFLINE		= "Offline Friends:";