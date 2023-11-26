--[[
--	Eclipse Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2499 2005-09-20 12:12:31Z stardust $
--	$Rev: 2499 $
--	$LastChangedBy StarDust $
--	$Date: 2005-09-20 07:12:31 -0500 (Tue, 20 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- Binding Strings
	--
	--------------------------------------------------
	BINDING_HEADER_ECLIPSEHEADER		= "Interface Sichtbarkeit";
	BINDING_NAME_TOGGLETOTAL		= "Wechsle Verbergen des UI";
	BINDING_NAME_TOGGLELUNAR		= "Wechsle AutoVerbergen des UI";
	BINDING_NAME_TOGGLESOLAR		= "Wechsle Transparenz des UI";

	--------------------------------------------------
	--
	-- UI Strings
	--
	--------------------------------------------------
	ECLIPSE_CONFIG_SECTION			= "Interface Sichtbarkeit";
	ECLIPSE_CONFIG_SECTION_INFO		= "Konfiguriert die Sichtbarkeit von zahlreichen Komponenten des Benutzerinterfaces.";

	--------------------------------------------------
	--
	-- Registered Frames Names
	--
	--------------------------------------------------
	ECLIPSE_CONFIG_GLOBAL			= "Globales UI";
	ECLIPSE_CONFIG_MAINBAR			= "Hauptleiste";
	ECLIPSE_CONFIG_ACTIONBAR		= "Aktionsleiste";
	ECLIPSE_CONFIG_MENUBUTTONS		= "Men\195\188leiste";
	ECLIPSE_CONFIG_BAGBUTTONS		= "Taschen";
	ECLIPSE_CONFIG_SHAPEBAR			= "Haltung/Form/Aura Leiste";
	ECLIPSE_CONFIG_PETBAR			= "Pet-Leiste";
	ECLIPSE_CONFIG_MULTIBL			= "Linke untere Zusatzleiste";
	ECLIPSE_CONFIG_MULTIBR			= "Rechte untere Zusatzleiste";
	ECLIPSE_CONFIG_MULTIR			= "Rechte Zusatzleiste";
	ECLIPSE_CONFIG_MULTIL			= "Zweite rechte Zusatzleiste";
	ECLIPSE_CONFIG_MINIMAP			= "Minikarte";
	ECLIPSE_CONFIG_BUFFS			= "Buffs";
	ECLIPSE_CONFIG_STATS			= "Charakterportrait";
	ECLIPSE_CONFIG_TARGET			= "Zielportrait";
	ECLIPSE_CONFIG_PARTY			= "Gruppenmitglieder";
	ECLIPSE_CONFIG_CHATBUTTONS		= "Chatfenster Buttons";

	--------------------------------------------------
	--
	-- Error Messages
	--
	--------------------------------------------------
	ECLIPSE_ERROR_XUI			= "PopNUI oder TransNUI entdeckt, Optionen zur Sichtbarkeit deaktiviert.";
	ECLIPSE_ERROR_XUI_INFO			= "Optionen zur Sichtbarkeit ersetzt die AddOns PopNUI sowie TransNUI und kann daher nicht mit jenen zur gleichen Zeit verwendet werden. Bitte entferne PopNUI und TransNUI oder die Optionen zur Sichtbarkeit des Interfaces stehen nicht zur Verfügung.";

	--------------------------------------------------
	--
	-- Help Text
	--
	--------------------------------------------------
	ECLIPSE_CONFIG_INFOTEXT = {
		"   Interface Sichtbarkeit ist ein AddOn, welches es erlaubt zahlreiche Komponenten "..
		"des Benutzerinterfaces zu verbergen, automatisch auszublenden oder transparent zu machen. "..
		"Verbergen bedeutet komplett ausblenden. Automatisch ausblenden bedeutet, da\195\159 jenes Fenster "..
		"nur angezeigt wird, wenn der Mauszeiger \195\188ber jenes bewegt wird. Transparent bedeutet, "..
		"da\195\159 jenes Fenster durchsichtig wird.\n"..
		"\n"..
		"    Die Benutzung der verschiedenen Optionen ist weitestgehend selbsterkl\195\164rend. "..
		"Dennoch m\195\182chte ich hier noch ein paar Angaben dazu machen. Bei Fenstern, welche "..
		"ausgeblendet werden, handelt es sich um einfache anzeigen/verbergen Optionen.\n"..
		"    Bei Fenstern, welche automatisch ausgeblendet werden, gibt es eine Option zum "..
		"aktivieren/deaktivieren dieser Funktion sowie einen Regler zur Einstellung der "..
		"Zeitverz\195\182gerung wielange sich die Maus \195\188ber dem Fenster befinden mu\195\159 bis "..
		"das Fenster angezeigt wird.\n"..
		"    Bei Fenstern, welche transparent werden, gibt es eine Option zum "..
		"aktivieren/deaktivieren dieser Funktion sowie einen Regler zur Einstellung der "..
		"Transparenz.\n"..
		"\n"..
		"Siehe Seite 3, 4 und 5 f\195\188r eine Liste der m\195\182glichen Optionen.",
		
		"Interface Sichtbarkeit\n"..
		"\n"..
		"Von: Mugendai\n"..
		"\n"..
		"Kontakt: mugekun@gmail.com"
	}

end