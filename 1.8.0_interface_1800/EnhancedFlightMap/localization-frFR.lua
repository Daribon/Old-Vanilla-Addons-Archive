--[[

French localization file.

Special thanks go to :-
Corwin Whitehorn who did the initial french localisation.

Initial Unicode update by Khisanth.


]]

-- Begin French Localization --
if ( GetLocale() == "frFR" ) then
--EFM_DESC						= "Enhanced Flight Map";
--EFM_Version_String			= format("%s - Version %s", EFM_DESC, EFM_Version);
EFM_Loaded						= " charg\195\169e."

-- Slash Commands
--EFM_CMD_HELP					= "help";
--EFM_CMD_CLEAR					= "clear";
--EFM_CMD_CLEAR_ALL				= "clear all";
--EFM_CMD_LOAD_BASE				= "load ";
--EFM_CMD_LOAD_HORDE			= format("%s horde", EFM_CMD_LOAD_BASE);
--EFM_CMD_LOAD_ALLIANCE			= format("%s alliance", EFM_CMD_LOAD_BASE);
EFM_CMD_LOAD_DRUID				= format("%s druide", EFM_CMD_LOAD_BASE);
EFM_CMD_ENABLE					= "activer";
EFM_CMD_DISABLE					= "d\195\169sactiver";
EFM_CMD_DEFAULTS				= "options par d\195\169faut";
EFM_CMD_STATUS					= "statut";
--EFM_CMD_GUI					= "config";
--EFM_CMD_LOADMESSAGE			= "load message";
	
EFM_OPTIONS_TIMER				= "chronom\195\169trage";
EFM_OPTIONS_ZONEMARKER			= "zone";
EFM_OPTIONS_DRUIDPATHS			= "druide";

--EFM_SLASH1					= "/enhancedflightmap";
--EFM_SLASH2					= "/efm";

-- Help Text
EFM_HELP_TEXT0 					= "---";
EFM_HELP_TEXT1 					= format("%s%s Aides des commandes:%s", LYS_COLOURS.GREEN, EFM_DESC, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT2 					= format("%sTaper %s%s <commande>%s or %s%s <commande>%s pour effectuer les commandes suivantes:-%s",	LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, EFM_SLASH1, LYS_COLOURS.GREEN, LYS_COLOURS.WHITE, EFM_SLASH2, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT3 					= format("%s%s%s: Affiche ce message.%s",																LYS_COLOURS.WHITE, EFM_CMD_HELP, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
--EFM_HELP_TEXT4				= format("%s%s%s: Displays the options menu.%s",														LYS_COLOURS.WHITE, EFM_CMD_GUI, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_HELP_TEXT5 					= format("%s%s%s: Efface la liste des voies a\195\169riennes connues.%s",								LYS_COLOURS.WHITE, EFM_CMD_CLEAR, LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);

-- Other messages
EFM_CLEAR_HELP					= format("%sPour vraiment effacer la liste, vous devez taper %s %s C'est une s\195\169curit\195\169.", LYS_COLOURS.GREEN, EFM_SLASH1, EFM_CMD_CLEAR_ALL, LYS_COLOURS.NORMAL);
EFM_CLEAR_MESSAGE				= format("%sVoies a\195\169riennes effac\195\169es.%s", LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
EFM_DATA_LOAD_SUCCESS			= format("%sVoies a\195\169riennes de %%s charg\195\169es.%s", LYS_COLOURS.GREEN, LYS_COLOURS.NORMAL);
--EFM_NEW_NODE					= format("%s%s: %s %%s to %%s.%s", LYS_COLOURS.GREEN, EFM_DESC, ERR_NEWTAXIPATH, LYS_COLOURS.NORMAL);
	
-- Flight time messages
EFM_FT_FLIGHT_TIME				= "Temps de vol: ";
EFM_FT_DESTINATION				= "Vol vers ";
EFM_FT_ARRIVAL_TIME				= "Arriv\195\169e dans: ";
EFM_FT_INCORRECT				= "Temps de vol incorrect, les chronom\195\170trages seront mis a jour a l'atterissage.";

-- Map screen messages
EFM_MAP_PATHLIST				= "Destinations disponibles";

-- Options messages
--EFM_MSG_OPTIONS				= format("%s: Option ", EFM_DESC);
EFM_MSG_OPTIONS_LIST			= format("Les options du %s actuelles sont:-", EFM_DESC);
EFM_MSG_OPTIONS_ENABLED			= " activ\195\169.";
EFM_MSG_OPTIONS_DISABLED		= " d\195\169sactiv\195\169.";
EFM_MSG_OPTIONS_INFLIGHT		= format("%s chronom\195\169trage du temps de vol", EFM_MSG_OPTIONS);
EFM_MSG_OPTIONS_ZONEMARKER		= format("%s marqueur de zone", EFM_MSG_OPTIONS);
EFM_MSG_OPTIONS_DRUIDPATHS		= format("%s trajets a\195\169riens pour druides", EFM_MSG_OPTIONS);

-- GUI Options Screen
--EFM_GUITEXT_Header			= format("%s Options", EFM_DESC);
EFM_GUITEXT_Done				= "Termin\195\169";
EFM_GUITEXT_Defaults			= "D\195\169faut";
EFM_GUITEXT_Timer				= "Afficher les chronom\195\169trages des temps de vol";
EFM_GUITEXT_ShowTimerBar		= "Afficher la barre de d\195\169compte de temps";
EFM_GUITEXT_ShowLargeBar		= "Afficher une grande barre";
EFM_GUITEXT_ZoneMarker			= "Afficher les marqueurs de zone";
EFM_GUITEXT_DruidPaths			= "Afficher les trajets a\195\169riens pour druides";
EFM_GUITEXT_ShowAltPaths		= "Afficher les trajets des autres persos";
EFM_GUITEXT_ShowRemotePaths 	= "Afficher les trajets distants";
EFM_GUITEXT_ShowCheapestFlight	= "Afficher le trajet le moins cher";
EFM_GUITEXT_LoadHeader			= "Chargement BDD";
--EFM_GUITEXT_LoadAlliance		= "Alliance";
EFM_GUITEXT_LoadDruid			= "Druide";
--EFM_GUITEXT_LoadHorde			= "Horde";
end
-- End French Localization --