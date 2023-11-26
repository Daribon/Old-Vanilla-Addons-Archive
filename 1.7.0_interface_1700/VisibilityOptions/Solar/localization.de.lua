--[[
--	Solar Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2025 2005-07-02 23:51:34Z Sinaloit $
--	$Rev: 2025 $
--	$LastChangedBy StarDust $
--	$Date: 2005-07-02 18:51:34 -0500 (Sat, 02 Jul 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- Cosmos Configuration
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
	-- Chat Configuration
	--
	--------------------------------------------------
	SOLAR_CHAT_COMMAND_INFO		= "Siehe /trans f\195\188r Hilfe zur Benutzung.";
	SOLAR_CHAT_COMMAND_HELP		= {	"Die Angabe der Zahl beim Befehl ist optional.  "..
						"Legt die Opazit\195\164t des Fensters fest. "..
						"Mu\195\159 zwischen 0 und 100 liegen und gibt den Wert in Prozent an. "; };
	SOLAR_CHAT_SUBCOMMAND_INFO	= "Wenn aktiviert, wird die Transparenz von %s ver\195\164ndert.";

end