--[[
--	Khaos Localization
--		"Change."	 	
--	
--	German By: StarDust
--	
--	$Id: localization.de.lua 2409 2005-09-09 06:39:02Z stardust $
--	$Rev: 2409 $
--	$LastChangedBy: stardust $
--	$Date: 2005-09-09 01:39:02 -0500 (Fri, 09 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	KHAOS_TITLE_TEXT			= "Khaos";

	KHAOS_TAB_CHANGECONFIGURATION_TEXT	= "Konfiguration \195\164ndern";
	KHAOS_TAB_SELECTCONFIGURATION_TEXT	= "Konfiguration w\195\164hlen";

	KHAOS_CURRENT_CONFIGURATION_TEXT	= "Momentane Konfiguration: (%d) %s";

	-- Binding
	BINDING_HEADER_KHAOS			= "Khaos Konfiguration";
	BINDING_NAME_TOGGLEKHAOS		= "Khaos Fenster anzeigen/verbergen";

	-- Button
	KHAOS_BUTTON_SUB			= "Einstellungen";
	KHAOS_BUTTON_TIP			= "AddOns und deren Optionen einstellen.";

	KHAOS_OPTIONS_TEXT			= "Khaos Einstellungen";

	-- Change Configuration
	KHAOS_SELECT_CONFIGURATION_SETUP	= "Setup Men\195\188";

	-- Default Configuration Tilt
	KHAOS_DEFAULT_CONFIGURATION_NAME	= "Ausgangskonfiguration";
	KHAOS_DEFAULT_COPY_APPEND		= "(Kopie)";
	KHAOS_EMPTY_CONFIGURATION_NAME		= "Leere Konfiguration";

	-- Login Screen Selection
	KHAOS_LOGIN_EDIT			= "Bearbeiten";
	KHAOS_LOGIN_USE				= "Verwenden";
	KHAOS_LOGIN_LOCK_MESSAGE		= "als Standard f\195\188r '%s' festlegen";
	KHAOS_LOGIN_SELECT_MESSAGE		= "Bitte eine Konfiguration ausw\195\164hlen:";
	KHAOS_LOGIN_SELECT_HELP_MESSAGE		= "Konfigurationen sind Gruppen von Einstellungen, welche\ndurch dr\195\188cken des Bearbeiten-Buttons oder \195\188ber das\nKhaos Konfigurationsmen\195\188 ver\195\164ndert werden k\195\182nnen.\n\nWenn du eine Konfiguration als Standard f\195\188r einen Charakter\nfestlegst so erscheint diese Auswahl beim Starten nichtmehr.";

	-- Configuration Changer
	KHAOS_SELECT_ALL			= "Alle";
	KHAOS_SELECT_CHARACTERS			= "Charaktere";
	KHAOS_SELECT_REALMS			= "Server";
	KHAOS_SELECT_CLASSES			= "Klassen";
	KHAOS_SELECT_DEFAULT			= "Standard";

	KHAOS_SELECT_ALL_HEADER			= "Alle";
	KHAOS_SELECT_CHARACTERS_HEADER		= "Charakter";
	KHAOS_SELECT_REALMS_HEADER		= "Server";
	KHAOS_SELECT_CLASSES_HEADER		= "Klasse";
	KHAOS_SELECT_DEFAULT_HEADER		= "Standard";

	KHAOS_SELECT_HEADER			= "%s Konfiguration";
	KHAOS_SELECT_NONE_LOCKED		= "-Keine Gelockt-";
	KHAOS_OPTION_CHOOSE			= "W\195\164hlen:";

	-- Side Buttons
	KHAOS_SELECT_BUTTON_SAVE		= "Speichern";
	KHAOS_SELECT_BUTTON_LOAD		= "Laden";
	KHAOS_SELECT_BUTTON_DUPE		= "Duplizieren";
	KHAOS_SELECT_BUTTON_RENAME		= "Umbenennen";
	KHAOS_SELECT_BUTTON_EXPORT		= "Exportieren";
	KHAOS_SELECT_BUTTON_IMPORT		= "Importieren";

	-- Difficulty
	KHAOS_SET_DIFFICULTY			= "Modus";

	KHAOS_SET_DIFFICULTY_MENU_TITLE		= "Erfahrungs Modus";
	KHAOS_SET_DIFFICULTY_MENU_FORMAT	= "%d - %s";
	KHAOS_SET_DIFFICULTY_DEFAULT		= "(Standard)";

	KHAOS_SET_DIFFICULTY_1			= "Anf\195\164nger";
	KHAOS_SET_DIFFICULTY_2			= "Fortgeschritten";
	KHAOS_SET_DIFFICULTY_3			= "Meister";
	KHAOS_SET_DIFFICULTY_4			= "Entwickler";

	-- Table of Contents
	KHAOS_OPTION_TABLEOFCONTENTS		= "Inhalt";

	KHAOS_OPTION_TABLEOFCONTENTS_MENU_TITLE = "Inhaltsverzeichnis";
	KHAOS_OPTION_TABLEOFCONTENTS_MENU_FORMAT= "%d - %s";
	KHAOS_OPTION_TABLEOFCONTENTS_MENU_TOP 	= "Oben";
	KHAOS_OPTION_TABLEOFCONTENTS_MENU_BOTTOM= "Unten";

	-- Menu
	KHAOS_SET_MENU_ENABLE			= "Aktivieren";
	KHAOS_SET_MENU_RESET			= "Auf Standard zur\195\188cksetzent";

	-- CFG Menu
	KHAOS_CONFIG_MENU_NEW			= "Neue Konfiguration";
	KHAOS_CONFIG_MENU_IMPORT		= "Konfiguration Importieren";
	KHAOS_CONFIG_MENU_CHANGE_DEFAULT	= "Standard \195\132ndern";
	KHAOS_CONFIG_MENU_DELETE		= "L\195\182sche \"%s\"";
	KHAOS_CONFIG_MENU_COPY			= "Kopiere \"%s\"";
	KHAOS_CONFIG_MENU_RENAME		= "Benenne \"%s\" um";
	KHAOS_CONFIG_MENU_EXPORT		= "Exportiere \"%s\"";
	KHAOS_CONFIG_MENU_HELP			= "Hilfe";
	KHAOS_CONFIG_MENU_SETTINGS		= "Einstellungen der Konfiguration";
	KHAOS_CONFIG_MENU_SETTINGS_DEFAULT	= "Ist Standard";
	KHAOS_CONFIG_MENU_SETTINGS_CLASSES	= "Klassen";
	KHAOS_CONFIG_MENU_SETTINGS_REALM	= "Server";
	KHAOS_CONFIG_MENU_SETTINGS_CHARACTERS	= "Charaktere";
	KHAOS_CONFIG_MENU_SETTINGS_HELP		= "Klicken f\195\188r Hilfe";

	-- Configuration Tooltips
	KHAOS_CONFIG_TOOLTIP_DEFAULT		= "(Standard)";
	KHAOS_CONFIG_TOOLTIP_CLASSES		= "Klassen: ";
	KHAOS_CONFIG_TOOLTIP_REALMS		= "Server: ";
	KHAOS_CONFIG_TOOLTIP_CHARACTERS		= "Charaktere: ";

	-- Configuration Prompts
	KHAOS_CONFIG_PROMPT_NEW_TEXT		= "Namen der neuen Konfiguration eingeben:";
	KHAOS_CONFIG_PROMPT_NEW_ACCEPT		= "Erstellen";
	KHAOS_CONFIG_PROMPT_NEW_CANCEL		= "Abbrechen";

	KHAOS_CONFIG_PROMPT_DELETE_TEXT		= "\"%s\"\nwirklich l\195\182schen ?";
	KHAOS_CONFIG_PROMPT_DELETE_ACCEPT	= "L\195\182schen";
	KHAOS_CONFIG_PROMPT_DELETE_CANCEL	= "Abbrechen";

	KHAOS_CONFIG_PROMPT_COPY_TEXT		= "\"%s\"\nwirklich kopieren ?";
	KHAOS_CONFIG_PROMPT_COPY_ACCEPT		= "Kopieren";
	KHAOS_CONFIG_PROMPT_COPY_CANCEL		= "Abbrechen";

	KHAOS_CONFIG_PROMPT_RENAME_TEXT		= "\"%s\"\n umbenennen.\n Den Namen unten eingeben und auf 'Umbenennen' klicken.";
	KHAOS_CONFIG_PROMPT_RENAME_ACCEPT	= "Umbenennen";
	KHAOS_CONFIG_PROMPT_RENAME_CANCEL	= "Abbrechen";

	-- Import/Export Window
	KHAOS_IMPORT				= "Importieren";
	KHAOS_SELECTALL				= "Alle Ausw\195\164hlen";
	KHAOS_CLOSE				= "Schlie\195\159en";
	KHAOS_EXPORT_MESSAGE			= "Bitte diesen Text hier in deinen bevorzugten Editor kopieren.";
	KHAOS_IMPORT_MESSAGE			= "Paste the text you obtained from the\nKhaos Export window and paste it here exactly.\nThen press "..KHAOS_IMPORT.." to add it to your configuration list.";
	KHAOS_IMPORT_ERROR_MESSAGE		= "Please paste the text you obtained from the Khaos Export window and paste it here exactly. Then press "..KHAOS_IMPORT.." to add it to your configuration list.";

	-- Khaos Enabled List
	KHAOS_FOLDER_ADDONS			= "AddOns";
	KHAOS_ENABLER_TITLE			= "Liste der AddOns";
	KHAOS_ENABLER_TOOLTIP			= "AddOns aktivieren/deaktivieren.";

	KHAOS_ENABLE_UNLOADABLE			= "%s Aktiviert. Bitte lade das UI neu um dieses Addon zu laden. < /console reloadui >";
	KHAOS_ENABLE_LOADABLE			= "%s Aktiviert. Dieses AddOn kann dynamisch geladen werden. Bitte begebe dich zur 'nicht geladen' Sektion von Khaos und hake die jeweilige Checkbox an um dieses Addon jetzt zu laden.";
	KHAOS_ENABLE_ALREADY			= "%s ist bereits aktiviert.";
	KHAOS_ENABLE_DISABLE			= "%s deaktiviert. Dies wird erst wirksam, wenn das UI neu geladen wurde.";

	KHAOS_ENABLER_DEPENDENCIES		= "Abh\195\164ngigkeiten:\n";

	-- Khaos AddOn Loader
	KHAOS_LOADER_TITLE			= "Entladen";
	KHAOS_LOADER_TOOLTIP			= "AddOns die momentan nicht geladen sind.";
	KHAOS_LOADING_MESSAGE			= "Lade AddOn %s in %d Sekunden.";
	KHAOS_LOADED_MESSAGE			= "AddOn %s geladen.";
	KHAOS_NOTLOADED_MESSAGE			= "Addon %s kann nicht geladen werden. Grund: %s";

	-- Default Folder
	KHAOS_FOLDER_DEFAULT			= "Sonstige";
	KHAOS_FOLDER_DEFAULT_HELP		= "Sonstige AddOns.";

	KHAOS_FOLDER_BARS			= "Leisten";
	KHAOS_FOLDER_BARS_HELP			= "AddOns, welche Leisten beeinflussen.";

	KHAOS_FOLDER_CHAT			= "Chat";
	KHAOS_FOLDER_CHAT_HELP			= "AddOns, welche die Chat-Fenster beeinflussen.";

	KHAOS_FOLDER_COMBAT			= "Kampf";
	KHAOS_FOLDER_COMBAT_HELP		= "AddOns, welche dich im Kampf unterst\195\188tzen.";

	KHAOS_FOLDER_CLASS			= "Klassen-Helfer";
	KHAOS_FOLDER_CLASS_HELP			= "Klassen-Spezifische AddOns.";

	KHAOS_FOLDER_COMM			= "Kommunikation";
	KHAOS_FOLDER_COMM_HELP			= "AddOns & Einstellungen zur Kommunikation mit Mitspielern.";

	KHAOS_FOLDER_FRAMES			= "Fenster";
	KHAOS_FOLDER_FRAMES_HELP		= "Positionierung von Fenstern.";

	KHAOS_FOLDER_INVENTORY			= "Inventar";
	KHAOS_FOLDER_INVENTORY_HELP		= "Taschen, Bank und Gegenst\195\164nde.";

	KHAOS_FOLDER_QUEST			= "Quests";
	KHAOS_FOLDER_QUEST_HELP			= "AddOns die dich beim Questen unterst\195\188tzen.";

	KHAOS_FOLDER_SOCIAL			= "Geselligkeit";
	KHAOS_FOLDER_SOCIAL_HELP		= "AddOns rund um die Geselligkeit.";

	KHAOS_FOLDER_TOOLTIP			= "Tooltips";
	KHAOS_FOLDER_TOOLTIP_HELP		= "AddOns, welche Tooltips erweitern und beeinflussen.";

	KHAOS_FOLDER_DEBUG			= "Fehleranalyse";
	KHAOS_FOLDER_DEBUG_HELP			= "Debugging Hilfsmittel.";

	KHAOS_FOLDER_MAPS			= "Karten";
	KHAOS_FOLDER_MAPS_HELP			= "AddOns, welche die Welt- & Minikarte beeinflussen.";

	KHAOS_HELP_TIP				= "Rechts-Klick auf das linke Panel um Optionen zur Konfiguration zu erhalten.\nRechts-Klick auf das zentrale Panel um ein Men\195\188 anzuzeigen.\nMausezeiger \195\188ber Optionen bewegen um eine Beschreibung jener anzuzeigen.\n";

end