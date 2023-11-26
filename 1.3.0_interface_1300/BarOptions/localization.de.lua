--[[
--	BarOptions Localization
--		"German Localization"
--	
--	German By: StarDust
--	
--	$Id: localization.de.lua 1441 2005-05-05 08:41:19Z Sinaloit $
--	$Rev: 1441 $ 1.0
--	$LastChangedBy: Sinaloit $ StarDust
--	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $ 03/31/2005
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- Binding Strings
	--
	--------------------------------------------------
	BINDING_HEADER_INSTANTACTIONBAR		= "Sofortzauber";

	BINDING_NAME_INSTANTACTIONBAR1		= "Sofortzauber/-aktion Seite 1";
	BINDING_NAME_INSTANTACTIONBAR2		= "Sofortzauber/-aktion Seite 2";
	BINDING_NAME_INSTANTACTIONBAR3		= "Sofortzauber/-aktion Seite 3";
	BINDING_NAME_INSTANTACTIONBAR4		= "Sofortzauber/-aktion Seite 4";
	BINDING_NAME_INSTANTACTIONBAR5		= "Sofortzauber/-aktion Seite 5";
	BINDING_NAME_INSTANTACTIONBAR6		= "Sofortzauber/-aktion Seite 6";

	--------------------------------------------------
	--
	-- Hotkey Constant
	--
	--------------------------------------------------
	--List of shortened names of hotkeys
	BO_SHORTHOTKEYS = {
		["Shift"]	= "S",
		["Alt"]		= "A",
		["Ctrl"]	= "C",
		["Control"]	= "C",
		["shift"]	= "S",
		["alt"]		= "A",
		["ctrl"]	= "C",
		["control"]	= "C",
		["SHIFT"]	= "S",
		["ALT"]		= "A",
		["CTRL"]	= "C",
		["CONTROL"]	= "C",
		["Num Pad"]	= "KP"
	};

	--------------------------------------------------
	--
	-- Cosmos Configuration
	--
	--------------------------------------------------
	BAROPTIONS_CONFIG_SECTION		= "Aktionsleisten";
	BAROPTIONS_CONFIG_SECTION_INFO		= "Diese Einstellungen ver\195\164ndern die Darstellung und das Verhalten der verschiedenen Aktionsleisten.";
	BAROPTIONS_CONFIG_BAR_HEADER		= "Einstellungen der Aktionsleisten";
	BAROPTIONS_CONFIG_BAR_HEADER_INFO	= "Diese Einstellungen ver\195\164ndern die Darstellung und das Verhalten der verschiedenen Aktionsleisten.";
	BAROPTIONS_CONFIG_DEFAULTSETUP		= "Standardeinstellung";
	BAROPTIONS_CONFIG_DEFAULTSETUP_NAME	= "Festlegen";
	BAROPTIONS_CONFIG_DEFAULTSETUP_INFO	= "Setzt alle Einstellungen der Aktionsleisten und Seitenleisten auf deren Standardvorgaben zur\195\188ck.";
	BAROPTIONS_CONFIG_SIDEBARSETUP		= "Seitenleisten Einstellung";
	BAROPTIONS_CONFIG_SIDEBARSETUP_NAME	= "Festlegen";
	BAROPTIONS_CONFIG_SIDEBARSETUP_INFO	= "Setzt alle Einstellungen der Aktionsleisten und Seitenleisten gem\195\164\195\159 der Standardvorgaben der Seitenleisten (AddOn).";
	BAROPTIONS_CONFIG_ALTERNATEIDS		= "Alternativen ID-Bereich verwenden";
	BAROPTIONS_CONFIG_ALTERNATEIDS_INFO	= "Wenn aktiviert, verwenden die Zusatzleisten \195\164hnliche ID-Bereiche wie die ehemaligen Cosmos eigenen Zusatzleisten.";
	BAROPTIONS_CONFIG_TURNPAGES		= "Seiten wechseln";
	BAROPTIONS_CONFIG_TURNPAGES_INFO	= "Wenn aktiviert, \195\164ndert die linke untere Zusatzleiste mit der Hauptaktionsleiste ihre Seiten. 'Alternativer ID-Bereich' mu\195\159 aktiviert sein.";
	BAROPTIONS_CONFIG_GROUPPAGES		= "Seiten gruppieren";
	BAROPTIONS_CONFIG_GROUPPAGES_INFO	= "Wenn aktiviert, wird die linke untere Zusatzleiste mit der Aktionsleiste gruppiert und verh\195\164lt sich als w\195\188rden sie sich 3 Seiten mit jeweils 24 Buttons teilen. 'Alternativer ID-Bereich' mu\195\159 aktiviert sein.";
	BAROPTIONS_CONFIG_STANCEBAR		= "Linke untere Zusatzleiste mit Haltung \195\164ndern";
	BAROPTIONS_CONFIG_STANCEBAR_INFO	= "Wenn aktiviert, \195\164ndert die linke untere Zusatzleiste ihren ID-Bereich entsprechend der momentane Haltung.\n'Seiten gruppieren' wird dadurch deaktiviert.";
	BAROPTIONS_CONFIG_HIDEEMPTY		= "Leere Buttons ausblenden";
	BAROPTIONS_CONFIG_HIDEEMPTY_INFO	= "Wenn aktiviert, werden leere Buttons ausgeblendet (Buttons auf denen keine Aktion zugewiesen wurde).";
	BAROPTIONS_CONFIG_HOTKEY_HEADER		= "Tastenk\195\188rzel";
	BAROPTIONS_CONFIG_HOTKEY_HEADER_INFO	= "Diese Einstellungen ver\195\164ndern die Anzeige der Tastenk\195\188rzel auf den Aktionsleisten.";
	BAROPTIONS_CONFIG_HIDEKEYS		= "Tastenk\195\188rzel ausblenden";
	BAROPTIONS_CONFIG_HIDEKEYS_INFO		= "Wenn aktiviert, werden keine Tastenk\195\188rzel mehr auf den Aktionsleisten angezeigt.";
	BAROPTIONS_CONFIG_MULTIKEYS		= "Zusatzleisten Tastenk\195\188rzel aktivieren";
	BAROPTIONS_CONFIG_MULTIKEYS_INFO	= "Wenn aktiviert, werden Tastenk\195\188rzel auf den Zusatzleisten angezeigt.";
	BAROPTIONS_CONFIG_SHORTKEYS		= "Zusatztasten der Tastenk\195\188rzel verk\195\188rzen";
	BAROPTIONS_CONFIG_SHORTKEYS_INFO	= "Wenn aktiviert, werden die Zusatztasten der Tastenk\195\188rzel verk\195\188rzt indem zum Beispiel statt 'Shift' nur noch 'S' angezeigt wird.";
	BAROPTIONS_CONFIG_HIDEKEYMOD		= "Zusatztasten der Tastenk\195\188rzel ausblenden";
	BAROPTIONS_CONFIG_HIDEKEYMOD_INFO	= "Wenn aktiviert, werden die Zusatztasten der Tastenk\195\188rzel (wie STRG, ALT, SHIFT) ausgeblendet.";
	BAROPTIONS_CONFIG_ART_HEADER		= "Grafische Darstellung der Aktionsleisten";
	BAROPTIONS_CONFIG_ART_HEADER_INFO	= "Diese Einstellungen ver\195\164ndern die grafische Darstellung der Aktionsleisten.";
	BAROPTIONS_CONFIG_MAINART		= "Grafischen Abschlu\195\159 der Hauptaktionsleiste anzeigen";
	BAROPTIONS_CONFIG_MAINART_INFO		= "Wenn aktiviert, wird der grafische Abschlu\195\159 der Hauptaktionsleiste (Drachen) angezeigt.";
	BAROPTIONS_CONFIG_BLART			= "Hintergrund auf der linken unteren Zusatzleiste verwenden";
	BAROPTIONS_CONFIG_BLART_INFO		= "Wenn aktiviert, wird ein grafischer Hintergrund auf der linken unteren Zusatzleiste angezeigt.";
	BAROPTIONS_CONFIG_BRART			= "Hintergrund auf der rechten unteren Zusatzleiste verwenden";
	BAROPTIONS_CONFIG_BRART_INFO		= "Wenn aktiviert, wird ein grafischer Hintergrund auf der rechten unteren Zusatzleiste angezeigt.";
	BAROPTIONS_CONFIG_RART			= "Hintergrund auf der rechten Zusatzleiste verwenden";
	BAROPTIONS_CONFIG_RART_INFO		= "Wenn aktiviert, wird ein grafischer Hintergrund auf der rechten Zusatzleiste angezeigt.";
	BAROPTIONS_CONFIG_LART			= "Hintergrund auf der zweiten rechten Zusatzleiste verwenden";
	BAROPTIONS_CONFIG_LART_INFO		= "Wenn aktiviert, wird ein grafischer Hintergrund auf der zweiten rechten Zusatzleiste angezeigt.";
	BAROPTIONS_CONFIG_COUNT_HEADER		= "Anzahl der Buttons";
	BAROPTIONS_CONFIG_COUNT_HEADER_INFO	= "Erlaubt es die Anzahl der angezeigten Buttons auf den Aktionsleisten einzustellen.";
	BAROPTIONS_CONFIG_COUNT_NAME		= "Buttons";
	BAROPTIONS_CONFIG_COUNT_SUFFIX		= "";
	BAROPTIONS_CONFIG_BLCOUNT		= "Linke untere Zusatzleiste";
	BAROPTIONS_CONFIG_BLCOUNT_INFO		= "Anzahl der Buttons auf der linken unteren Zusatzleiste.";
	BAROPTIONS_CONFIG_BRCOUNT		= "Rechte untere Zusatzleiste";
	BAROPTIONS_CONFIG_BRCOUNT_INFO		= "Anzahl der Buttons auf der rechten unteren Zusatzleiste.";
	BAROPTIONS_CONFIG_RCOUNT		= "Rechte Zusatzleiste";
	BAROPTIONS_CONFIG_RCOUNT_INFO		= "Anzahl der Buttons auf der rechten Zusatzleiste.";
	BAROPTIONS_CONFIG_LCOUNT		= "Zweite rechte Zusatzleiste";
	BAROPTIONS_CONFIG_LCOUNT_INFO		= "Anzahl der Buttons auf der zweiten rechten Zusatzleiste.";
	BAROPTIONS_CONFIG_RANGECOLOR_HEADER	= "'Au\195\159er Reichweite' Button-Einf\195\164rbung";
	BAROPTIONS_CONFIG_RANGECOLOR_HEADER_INFO= "Diese Einstellungen erm\195\182glichen es die Buttons einzuf\195\164rben sobald deren Aktion au\195\159er Reichweite des Ziels ist.";
	BAROPTIONS_CONFIG_RANGECOLOR		= "Button-Einf\195\164rbung aktivieren";
	BAROPTIONS_CONFIG_RANGECOLOR_INFO	= "Wenn aktiviert, wird ein Aktionsbutton entsprechend eingef\195\164rbt sobald dessen Aktion au\195\159er Reichweite des Ziels ist.\n(WoW Standard ist aktiviert!)";
	BAROPTIONS_CONFIG_RANGECOLORRED		= "Rotanteil";
	BAROPTIONS_CONFIG_RANGECOLORRED_INFO	= "Der Anteil an Rot bei der Einf\195\164rbung des Aktionsbutton.";
	BAROPTIONS_CONFIG_RANGECOLORGREEN	= "Gr\195\188nanteil";
	BAROPTIONS_CONFIG_RANGECOLORGREEN_INFO	= "Der Anteil an Gr\195\188n bei der Einf\195\164rbung des Aktionsbutton.";
	BAROPTIONS_CONFIG_RANGECOLORBLUE	= "Blauanteil";
	BAROPTIONS_CONFIG_RANGECOLORBLUE_INFO	= "Der Anteil an Blau bei der Einf\195\164rbung des Aktionsbutton.";
	BAROPTIONS_CONFIG_RANGECOLOR_NAME	= "Intensit\195\164t";
	BAROPTIONS_CONFIG_RANGECOLOR_SUFFIX	= "%";

	BAROPTIONS_CONFIG_STANCE_HEADER		= "Eigene Seiten f\195\188r unterschiedliche Haltungen";
	BAROPTIONS_CONFIG_STANCE_HEADER_INFO	= "Diese Einstellungen erm\195\182glichen es eine bestimmte Seite der Aktionsleiste mit einer bestimmten Haltung zu verbinden.";
	BAROPTIONS_CONFIG_STANCE_NAME		= "Seite";
	BAROPTIONS_CONFIG_STANCE_SUFFIX		= "";
	BAROPTIONS_CONFIG_CUSTOMSTANCES		= "Eigene Seiten f\195\188r Haltungen aktivieren";
	BAROPTIONS_CONFIG_CUSTOMSTANCES_INFO	= "Wenn aktiviert, kann f\195\188r jede Haltung eine bestimmte Seite der Aktionsleiste festgelegt werden.";
	BAROPTIONS_CONFIG_STANCE0		= "Seite wenn in keiner Haltung";
	BAROPTIONS_CONFIG_STANCE0_INFO		= "Legt fest welche Seite der Aktionsleiste verwendet wird wenn man sich in keiner bestimmten Haltung befindet.";
	BAROPTIONS_CONFIG_STANCE1		= "Seite f\195\188r Haltung 1\n(Kampfhaltung/Katzenform/Getarnt)";
	BAROPTIONS_CONFIG_STANCE1_INFO		= "Legt fest welche Seite der Aktionsleiste verwendet wird wenn man sich in der ersten Haltungsart befindet.";
	BAROPTIONS_CONFIG_STANCE2		= "Seite f\195\188r Haltung 2\n(Verteidigungshaltung/Schwimen)";
	BAROPTIONS_CONFIG_STANCE2_INFO		= "Legt fest welche Seite der Aktionsleiste verwendet wird wenn man sich in der zweiten Haltungsart befindet.";
	BAROPTIONS_CONFIG_STANCE3		= "Seite f\195\188r Haltung 3\n(Berserkerhaltung/B\195\164renform)";
	BAROPTIONS_CONFIG_STANCE3_INFO		= "Legt fest welche Seite der Aktionsleiste verwendet wird wenn man sich in der dritten Haltungsart befindet.";

	--------------------------------------------------
	--
	-- Chat Configuration
	--
	--------------------------------------------------
	BAROPTIONS_CHAT_DEFAULTSETUP		= "Standardeinstellungen der Aktionsleisten geladen.";
	BAROPTIONS_CHAT_SIDEBARSETUP		= "Einstellungen der Seitenleisten geladen.";
	BAROPTIONS_CHAT_ALTERNATEIDS		= "Benutze alternative ID-Bereiche %s";
	BAROPTIONS_CHAT_TURNPAGES		= "Seiten wechseln %s";
	BAROPTIONS_CHAT_GROUPPAGES		= "Seiten gruppieren %s";
	BAROPTIONS_CHAT_STANCEBAR		= "Haltungsabh\195\164ngige rechte zweite Zusatzleiste %s";
	BAROPTIONS_CHAT_HIDEEMPTY		= "Leere Aktionsbuttons verbergen %s";
	BAROPTIONS_CHAT_HIDEKEYS		= "Tastenk\195\188rzel verbergen %s";
	BAROPTIONS_CHAT_MULTIKEYS		= "Zusatzleisten Tastenk\195\188rzel anzeigen %s";
	BAROPTIONS_CHAT_SHORTKEYS		= "Verk\195\188rzte Zusatztasten der Tastenk\195\188rzel %s";
	BAROPTIONS_CHAT_HIDEKEYMOD		= "Zusatztasten der Tastenk\195\188rzel verbergen %s";
	BAROPTIONS_CHAT_MAINART			= "Abschlu\195\159grafiken der Hauptaktionsleiste %s%";
	BAROPTIONS_CHAT_BLART			= "Hintergrund der linken unteren Zusatzleiste %s%";
	BAROPTIONS_CHAT_BRART			= "Hintergrund der rechten unteren Zusatzleiste %s%";
	BAROPTIONS_CHAT_RART			= "Hintergrund der rechten Zusatzleiste %s%";
	BAROPTIONS_CHAT_LART			= "Hintergrund der zweiten rechten Zusatzleiste %s%";
	BAROPTIONS_CHAT_BLCOUNT			= "Anzahl der Buttons auf der linken unteren Zusatzleiste %s";
	BAROPTIONS_CHAT_BRCOUNT			= "Anzahl der Buttons auf der rechten unteren Zusatzleiste %s";
	BAROPTIONS_CHAT_RCOUNT			= "Anzahl der Buttons auf der rechten Zusatzleiste %s";
	BAROPTIONS_CHAT_LCOUNT			= "Anzahl der Buttons auf der zweiten rechten Zusatzleiste %s";
	BAROPTIONS_CHAT_RANGECOLOR_RANGE	= " Mu\195\159 zwischen 0 und 1 liegen, wie zum Beispiel 0.2";
	BAROPTIONS_CHAT_RANGECOLOR		= "Au\195\159er Reichweite Button-Einf\195\164rbung %s";
	BAROPTIONS_CHAT_RANGECOLORRED		= "Button-Einf\195\164rbung Rotanteil %s%";
	BAROPTIONS_CHAT_RANGECOLORGREEN		= "Button-Einf\195\164rbung Gr\195\188nanteil %s%";
	BAROPTIONS_CHAT_RANGECOLORBLUE		= "Button-Einf\195\164rbung Blauanteil %s%";
	BAROPTIONS_CHAT_CUSTOMSTANCES		= "Enable Custom Stance Pages %s";
	BAROPTIONS_CHAT_STANCE_RANGE		= " Mu\195\159 zwischen 1 und 10 liegen";
	BAROPTIONS_CHAT_STANCE0			= "Seite f\195\188r keine besondere Haltungen %s";
	BAROPTIONS_CHAT_STANCE1			= "Seite f\195\188r Haltung 1 (Kampfhaltung/Katzenform/Getarnt) %s";
	BAROPTIONS_CHAT_STANCE2			= "Seite f\195\188r Haltung 2 (Verteidigungshaltung/Schwimmen) %s";
	BAROPTIONS_CHAT_STANCE3			= "Seite f\195\188r Haltung 3 (Berserkerhaltung/B\195\164renform) %s";

end