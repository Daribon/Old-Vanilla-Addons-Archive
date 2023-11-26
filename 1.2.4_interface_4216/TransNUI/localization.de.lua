-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_TRANSNUIHEADER		= "Interface Transparenz";
	BINDING_NAME_TOGGLETRANSNUI		= "Transparenz ein-/ausschalten";

	-- Cosmos Configuration
	TRANSNUI_CONFIG_SECTION			= "Interface Transparenz";
	TRANSNUI_CONFIG_SECTION_INFO		= "Konfiguriert die Transparenz von zahlreichen Komponenten des Benutzerinterfaces.";
	TRANSNUI_CONFIG_HEADER			= "Interface Transparenz";
	TRANSNUI_CONFIG_HEADER_INFO		= "Konfiguriert die Transparenz von zahlreichen Komponenten des Benutzerinterfaces.";
	TRANSNUI_CONFIG_SLIDER			= "Opazit\195\164t";
	TRANSNUI_CONFIG_SUFFIX			= " %";
	TRANSNUI_CONFIG_GLOBAL			= "Interfaces Allgemein";
	TRANSNUI_CONFIG_GLOBAL_INFO		= "Erlaubt es alle Interfaces auf einmal transparent zu machen.";
	TRANSNUI_CONFIG_MAINBAR			= "Aktionsleiste";
	TRANSNUI_CONFIG_MAINBAR_INFO		= "Ver\195\164ndert die Transparenz der Aktionsleiste.";
	TRANSNUI_CONFIG_SHAPEBAR		= "Spezial-Leiste";
	TRANSNUI_CONFIG_SHAPEBAR_INFO		= "Ver\195\164ndert die Sichtbarkeit der Gestaltwandel/Haltung/Tarnung/Auren-Leiste.";
	TRANSNUI_CONFIG_PETBAR			= "Pet-Leiste";
	TRANSNUI_CONFIG_PETBAR_INFO		= "Ver\195\164ndert die Sichtbarkeit der Pet-Leiste.";
	TRANSNUI_CONFIG_SECONDBAR		= "Zweite Aktionsleiste";
	TRANSNUI_CONFIG_SECONDBAR_INFO		= "Ver\195\164ndert die Sichtbarkeit der zweiten Aktionsleiste.";
	TRANSNUI_CONFIG_LEFTSIDEBAR		= "Linke Seitenleiste";
	TRANSNUI_CONFIG_LEFTSIDEBAR_INFO	= "Ver\195\164ndert die Sichtbarkeit der linken Seitenleiste.";
	TRANSNUI_CONFIG_RIGHTSIDEBAR		= "Rechte Seitenleiste";
	TRANSNUI_CONFIG_RIGHTSIDEBAR_INFO	= "Ver\195\164ndert die Sichtbarkeit der rechten Seitenleiste.";
	TRANSNUI_CONFIG_MINIMAP			= "Mini Map";
	TRANSNUI_CONFIG_MINIMAP_INFO		= "Ver\195\164ndert die Sichtbarkeit der Mini Map.";
	TRANSNUI_CONFIG_BUFFS			= "Buffs";
	TRANSNUI_CONFIG_BUFFS_INFO		= "Ver\195\164ndert die Sichtbarkeit der Buff-Anzeige.";
	TRANSNUI_CONFIG_STATS			= "Statuswerte";
	TRANSNUI_CONFIG_STATS_INFO		= "Ver\195\164ndert die Sichtbarkeit der Statuswerte.";
	TRANSNUI_CONFIG_MINION			= "Quest-Gef\195\164hrte";
	TRANSNUI_CONFIG_MINION_INFO		= "Ver\195\164ndert die Sichtbarkeit des Quest-Gef\195\164hrtens.";

	-- Chat Configuration
	TRANSNUI_CHAT_COMMAND_HELP		= {};
	TRANSNUI_CHAT_COMMAND_HELP[1]		= "Jeder Befehl setzt die Transparenz des Interfaces auf Werte zwischen '0.00' und '1.00', oder '-1' bzw. 'off' f\195\188r keine Transparenz.";
	TRANSNUI_CHAT_COMMAND_HELP[2]		= "Man kann auch /tui statt /transnui benutzen.";
	TRANSNUI_CHAT_COMMAND_HELP[3]		= "Interfaceelement: %s";
	TRANSNUI_CHAT_COMMAND_HELP[4]		= "Beispiel (stellt PetBar auf 40% Transparenz): /tui pet .4"; 

end