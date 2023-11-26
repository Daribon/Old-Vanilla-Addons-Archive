--[[
--	Lunar Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2025 2005-07-02 23:51:34Z Sinaloit $
--	$Rev: 2025 $
--	$LastChangedBy: Sinaloit $
--	$Date: 2005-07-02 18:51:34 -0500 (Sat, 02 Jul 2005) $
--]]

if ( GetLocale() == "deDE" ) then

	--------------------------------------------------
	--
	-- Cosmos Configuration
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
	-- Chat Configuration
	--
	--------------------------------------------------
	LUNAR_CHAT_COMMAND_INFO		= "Siehe /ahide f\195\188r Hilfe zur Benutzung.";
	LUNAR_CHAT_COMMAND_HELP		= {	"Die Angabe der Zahl beim Befehl ist optional.  "..
						"Setzt die Verz\195\182gerung in Sekunden fest, nachdem das jeweilige Fenster "..
						"angezeigt wird wenn der Mauszeiger \195\188ber jenes bewegt wurde. Mu\195\159 zwischen 0 und 2 liegen, "..
						"mu\195\159 aber keine Ganzzahl sein... kann also zum Beispiel 0.4 betragen."; };
	LUNAR_CHAT_SUBCOMMAND_INFO	= "Wenn aktiviert, wird das %s nur angezeigt wenn man den Mauszeiger \195\188ber jenes bewegt.";

end