--[[
--	Lunar Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2476 2005-09-18 12:43:06Z mugendai $
--	$Rev: 2476 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-09-18 07:43:06 -0500 (Sun, 18 Sep 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- UI Strings
	--
	--------------------------------------------------
	LUNAR_CONFIG_HEADER		= "Automatisches Ausblenden";
	LUNAR_CONFIG_HEADER_INFO	= "Das jeweilige Fenster wird nur angezeigt wenn man den Mauszeiger \195\188ber jenes bewegt.";
	LUNAR_CONFIG_SLIDER		= "Zeitverz\195\182gerung";
	LUNAR_CONFIG_SUFFIX		= " Sek.";
	LUNAR_CONFIG_LABEL		= "%s";
	LUNAR_CONFIG_INFO		= "Wenn aktiviert, wird das %s nur angezeigt wenn man den Mauszeiger \195\188ber jenes bewegt.";

	--------------------------------------------------
	--
	-- Chat Strings
	--
	--------------------------------------------------
	LUNAR_CHAT_COMMAND_INFO		= "Siehe /ahide f\195\188r Hilfe zur Benutzung.";
	LUNAR_CHAT_COMMAND_HELP		= {	"Die Angabe der Zahl beim Befehl ist optional.  "..
						"Setzt die Verz\195\182gerung in Sekunden fest, nachdem das jeweilige Fenster "..
						"angezeigt wird wenn der Mauszeiger \195\188ber jenes bewegt wurde. Mu\195\159 zwischen 0 und 2 liegen, "..
						"mu\195\159 aber keine Ganzzahl sein... kann also zum Beispiel 0.4 betragen."; };
	LUNAR_CHAT_SUBCOMMAND_INFO	= "Wenn aktiviert, wird das %s nur angezeigt wenn man den Mauszeiger \195\188ber jenes bewegt.";

end