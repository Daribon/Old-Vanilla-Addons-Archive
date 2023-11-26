--[[
Set all Global variables up here...  Mostly this is to allow some kind soul to assist with a future internationalisation effort... but it won't be me as English is the only language I know :-)

For those who would like to assist with localising this, please keep a few things in mind :-
1) If you are not modifying a variable, please don't include it in your localisation.
2) Do not modify those variables listed as "do not localise", I use those variables internal in the program, or in other ways, so it might cause problems if they are modified.

]]

-- NOT TO BE LOCALISED --
EFM_Version		= "1.2.4b";
-- NOT TO BE LOCALISED --

-- Begin English Localization --
EFM_DESC						= "Enhanced Flight Map";
EFM_Version_String				= format("%s - Version %s", EFM_DESC, EFM_Version);
EFM_Loaded						= " loaded."

-- Slash Commands
EFM_CMD_HELP					= "help";
EFM_CMD_CLEAR					= "clear";
EFM_CMD_CLEAR_ALL				= "clear all";
EFM_CMD_LOAD_BASE				= "load";
EFM_CMD_LOAD_HORDE				= format("%s horde", EFM_CMD_LOAD_BASE);
EFM_CMD_LOAD_ALLIANCE			= format("%s alliance", EFM_CMD_LOAD_BASE);
EFM_CMD_LOAD_DRUID				= format("%s druid", EFM_CMD_LOAD_BASE);
EFM_CMD_ENABLE					= "enable";
EFM_CMD_DISABLE					= "disable";
EFM_CMD_DEFAULTS				= "default options";
EFM_CMD_STATUS					= "status";
EFM_CMD_GUI						= "config";
EFM_CMD_LOADMESSAGE				= "load message";

EFM_OPTIONS_TIMER				= "timer";
EFM_OPTIONS_ZONEMARKER			= "zone marker";
EFM_OPTIONS_DRUIDPATHS			= "druid paths";

EFM_SLASH1						= "/enhancedflightmap";
EFM_SLASH2						= "/efm";

-- Help Text
EFM_HELP_TEXT0 					= "---";
EFM_HELP_TEXT1 					= format("%s%s command help:%s", LYS_COLOURS.GREEN, EFM_DESC, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT2 					= format("%sUse %s%s <command>%s or %s%s <command>%s to perform the following commands:-%s",	LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, EFM_SLASH1, LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, EFM_SLASH2, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT3 					= format("%s%s%s: Displays this message.%s",													LYS_COLOURS.WHITE, EFM_CMD_HELP, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT4					= format("%s%s%s: Displays the options menu.%s",												LYS_COLOURS.WHITE, EFM_CMD_GUI, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT5 					= format("%s%s%s: Clears the list of known routes and flight points.%s",						LYS_COLOURS.WHITE, EFM_CMD_CLEAR, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);

-- Other messages
EFM_CLEAR_HELP					= format("%sTo truly clear the list, you need to type %s %s this is a safety feature.", LYS_COLOURS.GREEN, EFM_SLASH1, EFM_CMD_CLEAR_ALL, LYS_COLOURS.NORMAL);
EFM_CLEAR_MESSAGE				= format("%sEntire flight path data cleared.%s", LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_DATA_LOAD_SUCCESS			= format("%sEntire flight path data for %%s loaded.%s", LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_NEW_NODE					= format("%s%s: %s %%s to %%s.%s", LYS_COLOURS.GREEN, EFM_DESC, ERR_NEWTAXIPATH, LYS_COLOURS.NORMAL);

-- Flight time messages
EFM_FT_FLIGHT_TIME				= "Flight Time: ";
EFM_FT_DESTINATION				= "Flying To ";
EFM_FT_ARRIVAL_TIME				= "Arriving in: ";
EFM_FT_INCORRECT				= "Flight time incorrect, timers will be updated upon landing.";

-- Map screen messages
EFM_MAP_PATHLIST				= "Available Flight Paths";

-- Options messages
EFM_MSG_OPTIONS					= format("%s: Option ", EFM_DESC);
EFM_MSG_OPTIONS_LIST			= format("Current %s options are:-", EFM_DESC);
EFM_MSG_OPTIONS_ENABLED			= " enabled.";
EFM_MSG_OPTIONS_DISABLED		= " disabled.";
EFM_MSG_OPTIONS_INFLIGHT		= format("%s In-Flight Timer", EFM_MSG_OPTIONS);
EFM_MSG_OPTIONS_ZONEMARKER		= format("%s Flightmaster Zone Marker", EFM_MSG_OPTIONS);
EFM_MSG_OPTIONS_DRUIDPATHS		= format("%s Display of Druid Paths", EFM_MSG_OPTIONS);

-- GUI Options Screen
EFM_GUITEXT_Header				= format("%s Options", EFM_DESC);
EFM_GUITEXT_Done				= "Done";
EFM_GUITEXT_Defaults			= "Defaults";
EFM_GUITEXT_Timer				= "Show In-Flight timers";
EFM_GUITEXT_ShowTimerBar		= "Show In-Flight timer status bar";
EFM_GUITEXT_ShowLargeBar		= "Show Large In-Flight timer status bar";
EFM_GUITEXT_ZoneMarker			= "Show Flightmaster locations on Zone Map";
EFM_GUITEXT_DruidPaths			= "Show the Druid-only flight paths";
EFM_GUITEXT_ShowAltPaths		= "Show paths known by alts";
EFM_GUITEXT_ShowRemotePaths		= "Show remote flight times and costs";
EFM_GUITEXT_ShowCheapestFlight	= "Show cheapest flight path";
EFM_GUITEXT_LoadHeader			= "Data Loading";
EFM_GUITEXT_LoadAlliance		= "Alliance";
EFM_GUITEXT_LoadDruid			= "Druid";
EFM_GUITEXT_LoadHorde			= "Horde";
-- End English Localization --
