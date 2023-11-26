-- Version : German (by pc, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_POPNUIHEADER		= "Interface Sichtbarkeit";
	BINDING_NAME_TOGGLEPOPNUI		= "Sichtbarkeit ein-/ausschalten";

	-- Cosmos Configuration
	POPNUI_CONFIG_SECTION			= "Interface Sichtbarkeit";
	POPNUI_CONFIG_SECTION_INFO		= "Konfiguriert die Sichtbarkeit von zahlreichen Komponenten des Benutzerinterfaces.";
	POPNUI_CONFIG_HEADER			= "Interface Sichtbarkeit";
	POPNUI_CONFIG_HEADER_INFO		= "Konfiguriert die Sichtbarkeit von zahlreichen Komponenten des Benutzerinterfaces.";
	POPNUI_CONFIG_MAINBAR			= "Aktionsleiste";
	POPNUI_CONFIG_MAINBAR_INFO		= "Wenn aktiviert, wird die Aktionsleiste nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt (die Aktionsleiste bleibt immer sichtbar).";
	POPNUI_CONFIG_ACTIONBAR			= "Aktionsleiste";
	POPNUI_CONFIG_ACTIONBAR_INFO		= "Wenn aktiviert, werden die Buttons der Aktionsleiste nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_SHAPEBAR			= "Spezialleiste";
	POPNUI_CONFIG_SHAPEBAR_INFO		= "Wenn aktiviert, wird die Spezialleiste f\195\188r Gestaltwandel/Haltung/Tarnung/Auren nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_PETBAR			= "Pet-Leiste";
	POPNUI_CONFIG_PETBAR_INFO		= "Wenn aktiviert, wird die Pet-Leiste nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_SECONDBAR			= "Zweite Aktionsleiste";
	POPNUI_CONFIG_SECONDBAR_INFO		= "Wenn aktiviert, wird die zweite Aktionsleiste nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_LEFTSIDEBAR		= "Linke Seitenleiste";
	POPNUI_CONFIG_LEFTSIDEBAR_INFO		= "Wenn aktiviert, wird die linke Seitenleiste nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_RIGHTSIDEBAR		= "Rechte Seitenleiste";
	POPNUI_CONFIG_RIGHTSIDEBAR_INFO		= "Wenn aktiviert, wird die rechte Seitenleiste nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_MINIMAP			= "Mini Map";
	POPNUI_CONFIG_MINIMAP_INFO		= "Wenn aktiviert, wird die Mini Map nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_BUFFS			= "Buff Iconsn";
	POPNUI_CONFIG_BUFFS_INFO		= "Wenn aktiviert, werden die Buff Icons nur angezeigt wenn man den Mauszeiger \195\188ber jene bewegt.";
	POPNUI_CONFIG_STATS			= "Charakterportrait";
	POPNUI_CONFIG_STATS_INFO		= "Wenn aktiviert, wird das eigene Charakterportrait nur angezeigt wenn man den Mauszeiger \195\188ber jenes bewegt.";
	POPNUI_CONFIG_SLIDER			= "Zeitverz\195\182gerung";
	POPNUI_CONFIG_SUFFIX			= " Sek.";

	-- Chat Configuration
	POPNUI_CHAT_COMMAND_INFO 		= "Gib /pui ein um Hilfe zur Benutzung zu erhalten.";
	POPNUI_CHAT_COMMAND_HELP		= {};
	POPNUI_CHAT_COMMAND_HELP[1]		= "Jeder Befehl schaltet das automatische Ausblenden des entsprechenden Interfaces ein oder aus.";
	POPNUI_CHAT_COMMAND_HELP[2]		= "Es kann auch /pui anstelle von /popnui benutzt werden.";
	POPNUI_CHAT_COMMAND_HELP[3]		= "Zu jedem Interface kann on oder off angegeben werden... gefolgt von einer Nummer zwischen 0 und 2, welche die Popup Verz\195\182gerung angibt.";
	POPNUI_CHAT_COMMAND_HELP[4]		= "Interfaces: %s";
	POPNUI_CHAT_COMMAND_HELP[5]		= "Beispiel: /pui pet on";
	POPNUI_CHAT_COMMAND_HELP[6]		= "----Aktiviert das automatische Ausblenden der Pet-Leiste.";
	POPNUI_CHAT_COMMAND_HELP[7]		= "Beispiel: /pui pet on 0.3";
	POPNUI_CHAT_COMMAND_HELP[8]		= "----Aktiviert das automatische Ausblenden der Pet-Leiste und setzt die Verz\195\182gerung sodass die Maus 0.3 Sekunden auf jener verweilen mu\195\159, damit die Pet-Leister erscheint.";

end