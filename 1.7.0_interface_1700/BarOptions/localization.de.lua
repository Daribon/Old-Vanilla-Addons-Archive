--[[
--	BarOptions Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2409 2005-09-09 06:39:02Z stardust $
--	$Rev: 2409 $
--	$LastChangedBy StarDust $
--	$Date: 2005-09-09 01:39:02 -0500 (Fri, 09 Sep 2005) $
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
	BAROPTIONS_CONFIG_BAR_HEADER		= "Allgemeine Einstellungen";
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
	BAROPTIONS_CONFIG_HIDEEMPTY_INFO		= "Wenn aktiviert, werden leere Buttons ausgeblendet (Buttons auf denen keine Aktion zugewiesen wurde).";
	BAROPTIONS_CONFIG_MOVEMAINBAR_HEADER	= "Position der Hauptleiste";
	BAROPTIONS_CONFIG_MOVEMAINBAR_HEADER_INFO = "Erlaubt es die Hauptleiste an eine andere Position zu verschieben.\nNur eine Position m\195\182glich.";
	BAROPTIONS_CONFIG_MAINBARCENTER		= "Hauptleiste: unten zentrisch";
	BAROPTIONS_CONFIG_MAINBARCENTER_INFO	= "Wenn aktiviert, wird die Hauptleiste unten zentrisch angeordnet.";
	BAROPTIONS_CONFIG_MAINBARLEFT		= "Hauptleiste: unten links";
	BAROPTIONS_CONFIG_MAINBARLEFT_INFO	= "Wenn aktiviert, wird die Hauptleiste nach unten links verschoben.";
	BAROPTIONS_CONFIG_MAINBARRIGHT		= "Hauptleiste: unten rechts";
	BAROPTIONS_CONFIG_MAINBARRIGHT_INFO	= "Wenn aktiviert, wird die Hauptleiste nach unten rechts verschoben.";
	BAROPTIONS_CONFIG_HOTKEY_HEADER		= "Tastenk\195\188rzel";
	BAROPTIONS_CONFIG_HOTKEY_HEADER_INFO	= "Diese Einstellungen ver\195\164ndern die Anzeige der Tastenk\195\188rzel auf den Aktionsleisten.";
	BAROPTIONS_CONFIG_HIDEKEYS		= "Tastenk\195\188rzel ausblenden";
	BAROPTIONS_CONFIG_HIDEKEYS_INFO		= "Wenn aktiviert, werden keine Tastenk\195\188rzel mehr auf den Aktionsleisten angezeigt.";
	BAROPTIONS_CONFIG_MULTIKEYS		= "Zusatzleisten Tastenk\195\188rzel aktivieren";
	BAROPTIONS_CONFIG_MULTIKEYS_INFO		= "Wenn aktiviert, werden Tastenk\195\188rzel auf den Zusatzleisten angezeigt.";
	BAROPTIONS_CONFIG_SHORTKEYS		= "Zusatztasten der Tastenk\195\188rzel verk\195\188rzen";
	BAROPTIONS_CONFIG_SHORTKEYS_INFO		= "Wenn aktiviert, werden die Zusatztasten der Tastenk\195\188rzel verk\195\188rzt indem zum Beispiel statt 'Shift' nur noch 'S' angezeigt wird.";
	BAROPTIONS_CONFIG_HIDEKEYMOD		= "Zusatztasten der Tastenk\195\188rzel ausblenden";
	BAROPTIONS_CONFIG_HIDEKEYMOD_INFO	= "Wenn aktiviert, werden die Zusatztasten der Tastenk\195\188rzel (wie STRG, ALT, SHIFT) ausgeblendet.";
	BAROPTIONS_CONFIG_ART_HEADER		= "Grafische Darstellung";
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

	BAROPTIONS_CONFIG_STANCE_HEADER		= "Eigene Seiten f\195\188r versch. Haltungen";
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
	BAROPTIONS_CHAT_ALTERNATEIDS		= BAROPTIONS_CONFIG_ALTERNATEIDS;
	BAROPTIONS_CHAT_TURNPAGES		= BAROPTIONS_CONFIG_TURNPAGES;
	BAROPTIONS_CHAT_GROUPPAGES		= BAROPTIONS_CONFIG_GROUPPAGES;
	BAROPTIONS_CHAT_STANCEBAR		= BAROPTIONS_CONFIG_STANCEBAR;
	BAROPTIONS_CHAT_HIDEEMPTY		= BAROPTIONS_CONFIG_HIDEEMPTY;
	BAROPTIONS_CHAT_HIDEKEYS		= BAROPTIONS_CONFIG_HIDEKEYS;
	BAROPTIONS_CHAT_MULTIKEYS		= BAROPTIONS_CONFIG_MULTIKEYS;
	BAROPTIONS_CHAT_SHORTKEYS		= BAROPTIONS_CONFIG_SHORTKEYS;
	BAROPTIONS_CHAT_HIDEKEYMOD		= BAROPTIONS_CONFIG_HIDEKEYMOD;
	BAROPTIONS_CHAT_MAINART			= BAROPTIONS_CONFIG_MAINART;
	BAROPTIONS_CHAT_BLART			= BAROPTIONS_CONFIG_BLART;
	BAROPTIONS_CHAT_BRART			= BAROPTIONS_CONFIG_BRART;
	BAROPTIONS_CHAT_RART			= BAROPTIONS_CONFIG_RART;
	BAROPTIONS_CHAT_LART			= BAROPTIONS_CONFIG_LART;
	BAROPTIONS_CHAT_BLCOUNT			= BAROPTIONS_CONFIG_BLCOUNT.." Buttons";
	BAROPTIONS_CHAT_BRCOUNT			= BAROPTIONS_CONFIG_BRCOUNT.." Buttons";
	BAROPTIONS_CHAT_RCOUNT			= BAROPTIONS_CONFIG_RCOUNT.." Buttons";
	BAROPTIONS_CHAT_LCOUNT			= BAROPTIONS_CONFIG_LCOUNT.." Buttons";
	BAROPTIONS_CHAT_RANGECOLOR_RANGE	= " Mu\195\159 zwischen 1 und 100 liegen, wie zum Beispiel 22";
	BAROPTIONS_CHAT_RANGECOLOR		= BAROPTIONS_CONFIG_RANGECOLOR;
	BAROPTIONS_CHAT_CUSTOMSTANCES		= "Eigene Seiten f\195\188r Haltungen aktivieren %s";
	BAROPTIONS_CHAT_STANCE_RANGE		= " Mu\195\159 zwischen 1 und 10 liegen";
	BAROPTIONS_CHAT_STANCE0			= "Seite f\195\188r keine besondere Haltungen %s";
	BAROPTIONS_CHAT_STANCE1			= "Seite f\195\188r Haltung 1 (Kampfhaltung/Katzenform/Getarnt) %s";
	BAROPTIONS_CHAT_STANCE2			= "Seite f\195\188r Haltung 2 (Verteidigungshaltung/Schwimmen) %s";
	BAROPTIONS_CHAT_STANCE3			= "Seite f\195\188r Haltung 3 (Berserkerhaltung/B\195\164renform) %s";

	--------------------------------------------------
	--
	-- Help Text
	--
	--------------------------------------------------
	BAROPTIONS_CONFIG_INFOTEXT = {
		"    Aktionsleisten ist ein AddOn, welches es erlaubt das Verhalten der unterschiedlichen "..
		"Leisten im Spiel nachtr\195\164glich zu ver\195\164ndern. Es stellt dar\195\188ber hinaus eine "..
		"Bonus-Leiste zur verf\195\188gung (die Leiste, wenn der Spieler eine Haltung, Reisegestalt "..
		"oder Tarnung verwendet). Diese spezielle Version der Bonus-Leiste wird von anderen AddOns verwendet "..
		"um eine bessere Darstellung der Leiste zu erm\195\182glichen.\n\n"..
		"Siehe Seite 3 f\195\188r eine Liste der m\195\182glichen Optionen.",
		
		"Aktionsleisten Optionen\n"..
		"\n"..
		"Von: Mugendai\n"..
		"\n"..
		"Kontakt: mugekun@gmail.com"
	}

end