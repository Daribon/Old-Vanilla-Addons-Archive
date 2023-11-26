--[[
--	Solar Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2476 2005-09-18 12:43:06Z mugendai $
--	$Rev: 2476 $
--	$LastChangedBy StarDust $
--	$Date: 2005-09-18 07:43:06 -0500 (Sun, 18 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- UI Strings
	--
	--------------------------------------------------
	SOLAR_CONFIG_HEADER		= "Interface Transparenz";
	SOLAR_CONFIG_HEADER_INFO	= "Konfiguriert die Transparenz von zahlreichen Komponenten des Benutzerinterfaces.";
	SOLAR_CONFIG_SLIDER		= "Opazit\195\164t";
	SOLAR_CONFIG_SUFFIX		= "%";
	SOLAR_CONFIG_LABEL		= "%s";
	SOLAR_CONFIG_INFO		= "Wenn aktiviert, wird die Transparenz von %s ver\195\164ndert.";

	--------------------------------------------------
	--
	-- Chat Strings
	--
	--------------------------------------------------
	SOLAR_CHAT_COMMAND_INFO		= "Siehe /trans f\195\188r Hilfe zur Benutzung.";
	SOLAR_CHAT_COMMAND_HELP		= {	"Die Angabe der Zahl beim Befehl ist optional.  "..
						"Legt die Opazit\195\164t des Fensters fest. "..
						"Mu\195\159 zwischen 0 und 100 liegen und gibt den Wert in Prozent an. "; };
	SOLAR_CHAT_SUBCOMMAND_INFO	= "Wenn aktiviert, wird die Transparenz von %s ver\195\164ndert.";

end