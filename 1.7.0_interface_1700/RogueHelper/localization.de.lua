-- Version : German (by StaDust)
-- Last Update : 07/11/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_ROGUEHELPERHEADER			= "Schurkengehilfe";
	BINDING_NAME_ROGUEHELPER				= "Schurkengehilfe ein-/ausschalten";

	-- Cosmos Configuration
	ROGUEHELPER_CONFIG_HEADER				= "Schurkengehilfe";
	ROGUEHELPER_CONFIG_HEADER_INFO				= "Konfiguriert den Schurkengehilfe, ein AddOn welches in einem eigenen Fenster die Energie und Combopunkte anzeigt.";

	ROGUEHELPER_ENABLED					= "Schurkengehilfe aktivieren";
	ROGUEHELPER_ENABLED_INFO				= "Wenn aktiviert, wird ein eigenes Fenster mit der Energie sowie den Combopunkten angezeigt.";

	ROGUEHELPER_STATUSBAR					= "Statusleisten anzeigen";
	ROGUEHELPER_STATUSBAR_INFO				= "Wenn aktiviert, wird eine Statusleiste mit der eigenen Gesundheit und jener des Ziels im Fenster des SchurkenGehilfe angezeigt.";

	-- Chat Configuration
	ROGUEHELPER_CHAT_ENABLED				= "Schurkengehilfe aktiviert.";
	ROGUEHELPER_CHAT_DISABLED				= "Schurkengehilfe deaktiviert.";

	ROGUEHELPER_CHAT_STATUSBAR_ENABLED			= "Schurkengehilfe: Statusleiste aktiviert.";
	ROGUEHELPER_CHAT_STATUSBAR_DISABLED			= "Schurkengehilfe: Statusleiste deaktiviert.";

	ROGUEHELPER_CHAT_COMMAND_USAGE				= "Benutzung: /schurkengehilfe <anzeigen> on|off] - zeigt den Schurkengehilfe an oder blendet das Fenster aus.\nBefehle:\n anzeigen - zeigt das Fenster des Schurkengehilfe an oder blendet es aus";

	-- Interface Configuration
	ROGUEHELPER_MENU_TITLE					= "Schurkengehilfe";
	ROGUEHELPER_MENU_OPTION_LOCK				= "Fixieren";
	ROGUEHELPER_MENU_OPTION_UNLOCK				= "Freilassen";
	ROGUEHELPER_MENU_OPTION_HIDE				= "Verbergen";
	ROGUEHELPER_MENU_OPTION_DOCK				= "Docken";
	ROGUEHELPER_MENU_OPTION_SEPERATOR			= "|cFFCCCCCC------------|r";
	ROGUEHELPER_MENU_OPTION_CANCEL				= "Abbrechen";

	ROGUEHELPER_MENU_DOCK_OPTION_WEAPONBUTTONS		= "Spezialleiste";
	ROGUEHELPER_MENU_DOCK_OPTION_PLAYERFRAME		= "Charakterportrait";
	ROGUEHELPER_MENU_DOCK_OPTION_UNDOCK			= "Hauptfenster";

	-- *NUI/Eclipse AddOn Mod Configuration
	ROGUEHELPER_CONFIG_TRANSNUI				= "Schurkengehilfe";
	ROGUEHELPER_CONFIG_TRANSNUI_INFO			= "Ver\195\164ndert die Sichtbarkeit des Fensters des Schurkengehilfen.";

	ROGUEHELPER_CONFIG_POPNUI				= "Schurkengehilfe";
	ROGUEHELPER_CONFIG_POPNUI_INFO				= "Wenn aktiviert, wird das Fenster des Schurkengehilfen nur angezeigt wenn man den Mauszeiger \195\188ber jenes bewegt.";

	ROGUEHELPER_CONFIG_ECLIPSE_TOTAL			= "Schurkengehilfe deaktivieren";
	ROGUEHELPER_CONFIG_ECLIPSE_TOTAL_INFO			= "Zeigt oder verbirgt das Fenster des Schurkengehilfen.";

	-- Trans/PopNUI aliases
	ROGUEHELPER_NUI_ALIAS					= {"roguehelper","rh","schurkengehilfe","sg"};

	-- Khaos AddOn Configuration
	ROGUEHELPER_KHAOS_SET_ID				= "SchurkenGehilfe";

	-- Slash Configuration
	ROGUEHELPER_SLASH_CMDS					= {"/roguehelper","/rh","/schurkengehilfe","/sg"};
	ROGUEHELPER_CMD_SHOW					= {"show","anzeigen"};
	ROGUEHELPER_CMD_STATUSBAR				= {"statusbar","statusleiste"};

end