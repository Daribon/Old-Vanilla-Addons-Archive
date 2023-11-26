-- Version : English - ?????
	
COSMOS_CONFIG_QLOOT_HEADER			= "Quick Loot";
COSMOS_CONFIG_QLOOT_HEADER_INFO		= "This section configures options for Quick Loot";
COSMOS_CONFIG_QLOOT					= "Check here to enable quick looting.";
COSMOS_CONFIG_QLOOT_INFO			= "This will automatically move the first non-empty item slot in the loot window under your cursor as you loot.";
COSMOS_CONFIG_QLOOT_HIDE			= "Auto close empty loot windows.";	
COSMOS_CONFIG_QLOOT_HIDE_INFO		= "If this is enabled and you go to loot a corpse with no items, the loot window will be closed immediately.";
COSMOS_CONFIG_QLOOT_ONSCREEN		= "Show loot completely on screen.";
COSMOS_CONFIG_QLOOT_ONSCREEN_INFO	= "If this is enabled then when the loot windows is open, none of it will be off the screen.";

COSMOS_CONFIG_QLOOT_MOVE_ONCE		= "Only move the window to the mouse.";
COSMOS_CONFIG_QLOOT_MOVE_ONCE_INFO	= "If this is enabled, QuickLoot will not move the window more than once.";


QLOOT_LOADED						= "Telo's QuickLoot loaded";
ERR_LOOT_NONE						= "There was no loot to get.";

QUICKLOOT_CHAT_COMMAND_INFO			= "Sets up Quick Loot from the command line. Try it without parameters to get usage help.";
QUICKLOOT_CHAT_COMMAND_USAGE		= "Usage: /quickloot <enable/autohide/onscreen/moveonce>\nAll commands toggle the current state.\nCommands:\n enable - enables/disables Quick Loot\n autohide - whether Quick Loot should autohide empty loot windows or not\n onscree - should Quick Loot keep the loot window on screen or not";
QUICKLOOT_CHAT_COMMAND_ENABLE		= COSMOS_CONFIG_QLOOT_HEADER;
QUICKLOOT_CHAT_COMMAND_HIDE			= COSMOS_CONFIG_QLOOT_HEADER.." hiding";
QUICKLOOT_CHAT_COMMAND_ONSCREEN		= COSMOS_CONFIG_QLOOT_HEADER.." keep on screen";
QUICKLOOT_CHAT_COMMAND_MOVE_ONCE	= COSMOS_CONFIG_QLOOT_HEADER.." move once";

QUICKLOOT_CHAT_STATE_ENABLED		= " enabled";
QUICKLOOT_CHAT_STATE_DISABLED		= " disabled";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Vjeux

	COSMOS_CONFIG_QLOOT_HEADER			= "Loot Facile";
	COSMOS_CONFIG_QLOOT_HEADER_INFO		= "Le Loot Facile va déplacer la fenêtre de loot sous votre curseur lorsqu'elle s'ouvre, et elle se déplace à chaque fois que vous prennez un objet.";
	COSMOS_CONFIG_QLOOT					= "Cliquer ici pour activer le Loot Facile.";
	COSMOS_CONFIG_QLOOT_INFO			= "Le Loot Facile va déplacer la fenêtre de loot sous votre curseur lorsqu'elle s'ouvre, et elle se déplace à chaque fois que vous prennez un objet.";
	COSMOS_CONFIG_QLOOT_HIDE			= "Fermer automatiquement la fenêtre quand vide.";	
	COSMOS_CONFIG_QLOOT_HIDE_INFO		= "Si il n'y a aucun objets dans la fenêtre de loots, celle-ci va être automatiquement fermée si cette option est activée.";
	COSMOS_CONFIG_QLOOT_ONSCREEN		= "Toujours afficher la fenêtre de loot même si elle est en dehors de l'écran.";
	COSMOS_CONFIG_QLOOT_ONSCREEN_INFO	= "Si cette option est activée, la fenêtre de loot ne sortira plus jamais de l'écran.";
	ERR_LOOT_NONE						= "Il n'y avait aucun objet !.";	

elseif ( GetLocale() == "deDE" ) then
	-- Translation by pc

	COSMOS_CONFIG_QLOOT_HEADER			= "QuickLoot";
	COSMOS_CONFIG_QLOOT_HEADER_INFO		= "Diese Einstellungen ermöglichen die Anpassung von QuickLoot";
	COSMOS_CONFIG_QLOOT					= "Aktiviere schnelles looten";
	COSMOS_CONFIG_QLOOT_INFO			= "Wenn aktiviert, wandert der Mauszeiger sofort auf den ersten Gegenstand im Loot-Fenster.";
	COSMOS_CONFIG_QLOOT_HIDE			= "Schließe leere Loot-Fenster automatisch";
	COSMOS_CONFIG_QLOOT_HIDE_INFO		= "Wenn aktiviert, wird beim Versuch einen leeren Corpse zu looten das Loot-Fenster automatisch geschlossen.";
	COSMOS_CONFIG_QLOOT_ONSCREEN		= "Zeige den gesammten Loot";
	COSMOS_CONFIG_QLOOT_ONSCREEN_INFO	= "Wenn aktiviert, werden alle Loot-Fenster vollständig auf dem Bilschirm gezeigt.";
	QLOOT_LOADED						= "QuickLoot geladen";
	ERR_LOOT_NONE						= "Es gab nichts zu looten.";

end
