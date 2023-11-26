-- Version : German (by pc, StarDust)
-- Last Update : 09/27/2005

if ( GetLocale() == "deDE" ) then

	BINDING_HEADER_RELOADUI		= "Interface Neu Laden";
	BINDING_NAME_UIRELOAD		= "L\195\164dt das Benutzerinterface neu";

	-- Chat Configuration
	RELOAD_COMMANDS			= {"/rl", "/reloadui", "/reload", "/rel", "/reboot", "/neuladen", "/uineu", "/uineuladen"};
	RELOAD_COMMANDS_DESC		= "/uineuladen - Ladet das Benutzerinterface neu. Toll wenn du zum Beispiel deinen Leichnam nicht finden kannst.";
	RELOAD_CANCEL_COMMANDS		= {"/reloadcancel", "/reloaduicancel", "/rlc", "/relc", "/rebootcancel", "/neuladenabbrechen", "/nabbr"};
	RELOAD_CANCEL_COMMANDS_DESC	= "/neuladenabbrechen (/nabbr) - bricht das Neuladen des UI ab. Funktioniert nur wenn inerhalb von 1 Sekunde nach eingene von /uineuladen eingegeben wird.";

	RELOAD_WARNING			= "Lade das Interface in %d Sekunden neu. Gib /nabbr zum Abbruch ein.";
	RELOAD_MESSAGE			= "Das Benutzerinterface wird neu geladen."
	RELOAD_CANCEL			= "Neuladen abgebrochen.";

end
