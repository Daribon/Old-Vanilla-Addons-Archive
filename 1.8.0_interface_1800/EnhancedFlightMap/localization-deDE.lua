--[[

German Localization file

Special thanks go to
Gazzis who did the initial german localisation.
Elkano for updating the german translation.

Initial Unicode update by Khisanth.

]]

-- Begin German Localization --
if ( GetLocale() == "deDE" ) then
--EFM_DESC						= "Enhanced Flight Map";
--EFM_Version_String			= format("%s - Version %s", EFM_DESC, EFM_Version);
EFM_Loaded						= " geladen."

-- Slash Commands
EFM_CMD_HELP					= "hilfe";
EFM_CMD_CLEAR					= "l\195\182schen";
EFM_CMD_CLEAR_ALL				= "alle l\195\182schen";
EFM_CMD_LOAD_BASE				= "laden ";
--EFM_CMD_LOAD_HORDE			= format("%s horde", EFM_CMD_LOAD_BASE);
EFM_CMD_LOAD_ALLIANCE			= format("%s allianz", EFM_CMD_LOAD_BASE);
EFM_CMD_LOAD_DRUID				= format("%s druide", EFM_CMD_LOAD_BASE);
EFM_CMD_ENABLE					= "aktiviere";
EFM_CMD_DISABLE					= "deaktiviere";
EFM_CMD_DEFAULTS				= "einstellungen zur\195\188cksetzen";
--EFM_CMD_STATUS				= "status";
--EFM_CMD_GUI					= "config";
--EFM_CMD_LOADMESSAGE			= "load message";

EFM_OPTIONS_TIMER				= "flugzeitanzeige";
EFM_OPTIONS_ZONEMARKER			= "zonenmarkierungen";
EFM_OPTIONS_DRUIDPATHS			= "druidenrouten";

--EFM_SLASH1					= "/enhancedflightmap";
--EFM_SLASH2					= "/efm";

-- Help Text
EFM_HELP_TEXT0 					= "---";
EFM_HELP_TEXT1 					= format("%s%s Hilfe / Beschreibung der Befehle:%s", LYS_COLOURS.GREEN, EFM_DESC, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT2 					= format("%sBenutze %s%s <Befehl>%s oder %s%s <Befehl>%s um die folgenden Befehle auszuf\195\188hren:-%s",	LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, EFM_SLASH1, LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, EFM_SLASH2, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT3 					= format("%s%s%s: zeigt diese Hilfe an.%s",																	LYS_COLOURS.WHITE, EFM_CMD_HELP, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
--EFM_HELP_TEXT4				= format("%s%s%s: Displays the options menu.%s",															LYS_COLOURS.WHITE, EFM_CMD_GUI, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT5 					= format("%s%s%s: l\195\182scht die Liste der bekannten Flugpunkte und -routen.%s",							LYS_COLOURS.WHITE, EFM_CMD_CLEAR, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);

-- Other messages
EFM_CLEAR_HELP					= format("%sUm die Liste wirklich zu l\195\182schen %s %s eintippen. Dies ist ein Sicherheitsfeature :).", LYS_COLOURS.GREEN, EFM_SLASH1, EFM_CMD_CLEAR_ALL, LYS_COLOURS.NORMAL);
EFM_CLEAR_MESSAGE				= format("%sAlle Flugdaten gel\195\182scht.%s", LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_DATA_LOAD_SUCCESS			= format("%sFlugdaten f\195\188r %%s geladen.%s", LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
--EFM_NEW_NODE					= format("%s%s: %s %%s to %%s.%s", LYS_COLOURS.GREEN, EFM_DESC, ERR_NEWTAXIPATH, LYS_COLOURS.NORMAL);

-- Flight time messages
EFM_FT_FLIGHT_TIME				= "Flugzeit: ";
EFM_FT_DESTINATION				= "Ziel: ";
EFM_FT_ARRIVAL_TIME				= "Ankunft: ";
EFM_FT_INCORRECT				= "Flugzeit inkorrekt, Zeiten werden bei der Landung aktualisiert.";

-- Map screen messages
EFM_MAP_PATHLIST				= "Verf\195\188gbare Flugrouten";

-- Options messages
EFM_MSG_OPTIONS					= format("%s: Einstellung ", EFM_DESC);
EFM_MSG_OPTIONS_LIST			= format("Derzeitige %s Einstellungen sind:-", EFM_DESC);
EFM_MSG_OPTIONS_ENABLED			= " aktiviert.";
EFM_MSG_OPTIONS_DISABLED		= " deaktiviert.";
EFM_MSG_OPTIONS_INFLIGHT		= format("%s Flugzeit-Anzeige", EFM_MSG_OPTIONS);
EFM_MSG_OPTIONS_ZONEMARKER		= format("%s Flugpunkt-Zonenmarkierungen", EFM_MSG_OPTIONS);
EFM_MSG_OPTIONS_DRUIDPATHS		= format("%s Anzeige der Druidenrouten", EFM_MSG_OPTIONS);

-- GUI Options Screen
--EFM_GUITEXT_Header				= format("%s Options", EFM_DESC);
--EFM_GUITEXT_Done					= "Done";
--EFM_GUITEXT_Defaults				= "Defaults";
--EFM_GUITEXT_Timer					= "Show In-Flight timers";
--EFM_GUITEXT_ShowTimerBar			= "Show In-Flight timer status bar";
--EFM_GUITEXT_ShowLargeBar			= "Show Large In-Flight timer status bar";
--EFM_GUITEXT_ZoneMarker			= "Show Flightmaster locations on Zone Map";
--EFM_GUITEXT_DruidPaths			= "Show the Druid-only flight paths";
--EFM_GUITEXT_ShowAltPaths			= "Show paths known by alts";
--EFM_GUITEXT_ShowRemotePaths		= "Show remote flight times and costs";
--EFM_GUITEXT_ShowCheapestFlight	= "Show cheapest flight path";
--EFM_GUITEXT_LoadHeader			= "Data Loading";
--EFM_GUITEXT_LoadAlliance			= "Alliance";
--EFM_GUITEXT_LoadDruid				= "Druid";
--EFM_GUITEXT_LoadHorde				= "Horde";
end
-- End German Localization --