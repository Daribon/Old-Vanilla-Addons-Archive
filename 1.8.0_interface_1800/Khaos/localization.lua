--[[
--	Khaos Localization
--		"Change."	 	
--	
--	English By: Alexander Brazie
--	
--	$Id: localization.lua 2520 2005-09-25 20:47:24Z AlexYoshi $
--	$Rev: 2520 $
--	$LastChangedBy: AlexYoshi $
--	$Date: 2005-09-25 15:47:24 -0500 (Sun, 25 Sep 2005) $
--]]

KHAOS_TITLE_TEXT = "Khaos";

KHAOS_TAB_CHANGECONFIGURATION_TEXT = "Change Configuration";
KHAOS_TAB_SELECTCONFIGURATION_TEXT = "Select Configuration";

KHAOS_CURRENT_CONFIGURATION_TEXT = "Current Configuration: (%d) %s";

-- Binding
BINDING_HEADER_KHAOS		= "Khaos Configuration";
BINDING_NAME_TOGGLEKHAOS	= "Toggle Khaos Panel";

-- Button
KHAOS_BUTTON_SUB = "Configure";
KHAOS_BUTTON_TIP = "Configure AddOns & Settings";

KHAOS_OPTIONS_TEXT = "Khaos Configure";

-- Change Configuration
KHAOS_SELECT_CONFIGURATION_SETUP = "Setup Menu";

-- Default Configuration Tilt
KHAOS_DEFAULT_CONFIGURATION_NAME = "Initial Configuration";
KHAOS_DEFAULT_COPY_APPEND = "(copy)";
KHAOS_EMPTY_CONFIGURATION_NAME = "Empty Configuration";

-- Login Screen Selection
KHAOS_LOGIN_EDIT = "Edit";
KHAOS_LOGIN_USE = "Use";
KHAOS_LOGIN_LOCK_MESSAGE = "Set this as the default for %s.";
KHAOS_LOGIN_SELECT_MESSAGE = "Please select a configuration.";
KHAOS_LOGIN_SELECT_HELP_MESSAGE = "Configurations are sets of options which\nyou can customize by pressing the edit key\nor going to the Khaos configuration screen.\n\nIf you choose to lock a configuration to the\ncurrent character, this screen will not appear.";

-- Configuration Changer
KHAOS_SELECT_ALL = "All";
KHAOS_SELECT_CHARACTERS = "Characters";
KHAOS_SELECT_REALMS = "Realms";
KHAOS_SELECT_CLASSES = "Classes";
KHAOS_SELECT_DEFAULT = "Default";

KHAOS_SELECT_ALL_HEADER = "All";
KHAOS_SELECT_CHARACTERS_HEADER = "Character";
KHAOS_SELECT_REALMS_HEADER = "Realm";
KHAOS_SELECT_CLASSES_HEADER = "Class";
KHAOS_SELECT_DEFAULT_HEADER = "Default";

KHAOS_SELECT_HEADER = "%s Configurations";
KHAOS_SELECT_NONE_LOCKED = "-None Locked-";
KHAOS_OPTION_CHOOSE = "Choose:";

-- Side Buttons
KHAOS_SELECT_BUTTON_SAVE = "Save";
KHAOS_SELECT_BUTTON_LOAD = "Load";
KHAOS_SELECT_BUTTON_DUPE = "Duplicate";
KHAOS_SELECT_BUTTON_RENAME = "Rename";
KHAOS_SELECT_BUTTON_EXPORT = "Export";
KHAOS_SELECT_BUTTON_IMPORT = "Import";

-- Difficulty
KHAOS_SET_DIFFICULTY = "User Skill";

KHAOS_SET_DIFFICULTY_MENU_TITLE = "User Level";
KHAOS_SET_DIFFICULTY_MENU_FORMAT = "%d - %s";
KHAOS_SET_DIFFICULTY_DEFAULT = "(Default)";

KHAOS_SET_DIFFICULTY_1 = "Beginner";
KHAOS_SET_DIFFICULTY_2 = "Average";
KHAOS_SET_DIFFICULTY_3 = "Master";
KHAOS_SET_DIFFICULTY_4 = "Developer";

-- Table of Contents
KHAOS_OPTION_TABLEOFCONTENTS = "Table of Contents";

KHAOS_OPTION_TABLEOFCONTENTS_MENU_TITLE = "Table of Contents";
KHAOS_OPTION_TABLEOFCONTENTS_MENU_FORMAT = "%d - %s";
KHAOS_OPTION_TABLEOFCONTENTS_MENU_TOP 	= "Top";
KHAOS_OPTION_TABLEOFCONTENTS_MENU_BOTTOM = "Bottom";

-- Menu
KHAOS_SET_MENU_ENABLE = "Enable";
KHAOS_SET_MENU_RESET = "Reset to Default";

-- CFG Menu
KHAOS_CONFIG_MENU_NEW = "New Configuration";
KHAOS_CONFIG_MENU_IMPORT = "Import Configuration";
KHAOS_CONFIG_MENU_CHANGE_DEFAULT = "Change Default";
KHAOS_CONFIG_MENU_DELETE = "Delete \"%s\"";
KHAOS_CONFIG_MENU_COPY = "Copy \"%s\"";
KHAOS_CONFIG_MENU_RENAME = "Rename \"%s\"";
KHAOS_CONFIG_MENU_EXPORT = "Export \"%s\"";
KHAOS_CONFIG_MENU_HELP = "Help";
KHAOS_CONFIG_MENU_SETTINGS = "Configuration Settings";
KHAOS_CONFIG_MENU_SETTINGS_DEFAULT = "Is Default";
KHAOS_CONFIG_MENU_SETTINGS_CLASSES = "Classes";
KHAOS_CONFIG_MENU_SETTINGS_REALM = "Realms";
KHAOS_CONFIG_MENU_SETTINGS_CHARACTERS = "Characters";
KHAOS_CONFIG_MENU_SETTINGS_HELP = "Click for Help";

-- Configuration Tooltips
KHAOS_CONFIG_TOOLTIP_DEFAULT = "(Default)";
KHAOS_CONFIG_TOOLTIP_CLASSES = "Classes: ";
KHAOS_CONFIG_TOOLTIP_REALMS = "Realms: ";
KHAOS_CONFIG_TOOLTIP_CHARACTERS = "Characters: ";

-- Configuration Prompts
KHAOS_CONFIG_PROMPT_NEW_TEXT = "Enter the name of the new configuration.";
KHAOS_CONFIG_PROMPT_NEW_ACCEPT = "Create";
KHAOS_CONFIG_PROMPT_NEW_CANCEL = "Cancel";

KHAOS_CONFIG_PROMPT_DELETE_TEXT = "Truely delete\n\"%s\"?";
KHAOS_CONFIG_PROMPT_DELETE_ACCEPT = "Delete";
KHAOS_CONFIG_PROMPT_DELETE_CANCEL = "Keep";

KHAOS_CONFIG_PROMPT_COPY_TEXT = "Copy configuration\n\"%s\"?";
KHAOS_CONFIG_PROMPT_COPY_ACCEPT = "Copy";
KHAOS_CONFIG_PROMPT_COPY_CANCEL = "Cancel";

KHAOS_CONFIG_PROMPT_RENAME_TEXT = "Please rename the configuration\n\"%s\".\n Enter the name below and hit rename.";
KHAOS_CONFIG_PROMPT_RENAME_ACCEPT = "Rename";
KHAOS_CONFIG_PROMPT_RENAME_CANCEL = "Cancel";

-- Import/Export Window
KHAOS_IMPORT = "Import";
KHAOS_SELECTALL = "Select All";
KHAOS_CLOSE = "Close";
KHAOS_EXPORT_MESSAGE = "Please copy the text here to your favourite editor.";
KHAOS_IMPORT_MESSAGE = "Paste the text you obtained from the\nKhaos Export window and paste it here exactly.\nThen press "..KHAOS_IMPORT.." to add it to your configuration list.";
KHAOS_IMPORT_ERROR_MESSAGE = "Please paste the text you obtained from the Khaos Export window and paste it here exactly. Then press "..KHAOS_IMPORT.." to add it to your configuration list.";

-- Khaos Enabled List
KHAOS_FOLDER_ADDONS = "AddOns";
KHAOS_ENABLER_TITLE = "AddOn List";
KHAOS_ENABLER_TOOLTIP = "Enable/Disable AddOns";

KHAOS_ENABLE_UNLOADABLE = "Enabled %s. Please reload your ui to load it. < /console reloadui >";
KHAOS_ENABLE_LOADABLE = "Enabled %s. This addon can be dynamically loaded. Please go to the Unloaded section of Khaos and check the box to load it now.";
KHAOS_ENABLE_ALREADY = "%s is already enabled.";
KHAOS_ENABLE_DISABLE = "Disabled %s. This will not take effect until the UI has been reloaded.";

KHAOS_ENABLER_DEPENDENCIES = "Dependencies:\n";

-- Khaos AddOn Loader
KHAOS_LOADER_TITLE = "Unloaded";
KHAOS_LOADER_TOOLTIP = "AddOns which are not currently loaded.";
KHAOS_LOADING_MESSAGE = "Loading %s! in %d seconds.";
KHAOS_LOADED_MESSAGE = "Loaded %s.";
KHAOS_NOTLOADED_MESSAGE = "Unabled to load %s. Reason: %s";

-- Default Folder
KHAOS_FOLDER_DEFAULT = "Other";
KHAOS_FOLDER_DEFAULT_HELP = "Miscellaneous AddOns";

KHAOS_FOLDER_BARS = "Bars";
KHAOS_FOLDER_BARS_HELP = "Bar Modifying AddOns";

KHAOS_FOLDER_CHAT = "Chat";
KHAOS_FOLDER_CHAT_HELP = "These are options which affect the chat window.";

KHAOS_FOLDER_COMBAT = "Combat";
KHAOS_FOLDER_COMBAT_HELP = "Combat assisting AddOns";

KHAOS_FOLDER_CLASS = "Class Helpers";
KHAOS_FOLDER_CLASS_HELP = "Class-specific AddOns";

KHAOS_FOLDER_COMM = "Communication";
KHAOS_FOLDER_COMM_HELP = "Communications AddOns & Settings";

KHAOS_FOLDER_FRAMES = "Frames";
KHAOS_FOLDER_FRAMES_HELP = "Frame placement and customization";

KHAOS_FOLDER_INVENTORY = "Inventory";
KHAOS_FOLDER_INVENTORY_HELP = "Bags, Banks and Item Pickup";

KHAOS_FOLDER_QUEST = "Quests";
KHAOS_FOLDER_QUEST_HELP = "Questing AddOns & Settings";

KHAOS_FOLDER_SOCIAL = "Social";
KHAOS_FOLDER_SOCIAL_HELP = "Social Tracking AddOns";

KHAOS_FOLDER_TOOLTIP = "Tooltips";
KHAOS_FOLDER_TOOLTIP_HELP = "Tooltip AddOns & Settings";

KHAOS_FOLDER_DEBUG = "Debug";
KHAOS_FOLDER_DEBUG_HELP = "Debugging Tools";

KHAOS_FOLDER_MAPS = "Maps";
KHAOS_FOLDER_MAPS_HELP = "World & Minimap Settings";

KHAOS_HELP_TIP = "Right-click on the left pane for configuration options.\nRight-click on the central pane for menu. \nMouse-over options to see a description. \n";

