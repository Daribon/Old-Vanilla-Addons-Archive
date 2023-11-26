-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_WEAPONBUTTONSHEADER		= "Waffen Buttons";
	BINDING_NAME_WEAPONBUTTONS                      = "Waffen Buttons ein-/ausschalten";
	BINDING_NAME_WEAPONBUTTONS_CYCLE                = "Modus durchschalten";

	-- UltimateUI Configuration
	WEAPONBUTTONS_CONFIG_HEADER                     = "Waffen Buttons";
	WEAPONBUTTONS_CONFIG_HEADER_INFO                = "Enth\195\164lt Einstellungen f\195\188r Waffen Buttons, ein Addon mit dem man Zugriff auf die Waffenkn\195\188pfe aus dem Charkterfenster bekommt.\nSHIFT-Klick auf das Waffen Buttons Fenster um zwischen Nah- & Fernkampf umzuschalten.";
   
	WEAPONBUTTONS_ENABLED				= "Waffen Buttons Fenster anzeigen";
	WEAPONBUTTONS_ENABLED_INFO			= "Wenn aktiviert, wird das Waffen Buttons Fenster angezeigt.";
      
	WEAPONBUTTONS_DISPLAY_TOOLTIPS                  = "Tooltips auf den Waffen Buttons anzeigen";
	WEAPONBUTTONS_DISPLAY_TOOLTIPS_INFO             = "Wenn aktiviert, werden Tooltips auf den Waffen Buttons angezeigt wenn man den Mauszeiger \195\188ber die entsprechende Waffe bewegt.";
      
	WEAPONBUTTONS_LOCK_POSITION			= "Aktuelle Position einrasten";
	WEAPONBUTTONS_LOCK_POSITION_INFO                = "Wenn aktiviert, wird das Waffen Buttons Fenster an seiner momentanen Position eingerastet wodurch man es nicht mehr veschieben kann.";
   
	WEAPONBUTTONS_RESET				= "Position zur\195\188cksetzen";
	WEAPONBUTTONS_RESET_INFO			= "Setzt die Position des Waffen Buttons Fensters zur\195\164ck (z.B. falls diese vom Bildschirm geschoben wurden)";
	WEAPONBUTTONS_RESET_NAME			= "Zur\195\188cksetzen";

	WEAPONBUTTONS_DEFAULT_MODE			= "Standardmodus festlegen";
	WEAPONBUTTONS_DEFAULT_MODE_INFO			= "Der Standardmodus der Waffen Buttons.\n";
	WEAPONBUTTONS_DEFAULT_MODE_APPEND		= "";

	-- Chat Configuration
	WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_ENABLED	= "Tooltips f\195\188r Waffen Buttons aktiviert.";
	WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_DISABLED	= "Tooltips f\195\188r Waffen Buttons deaktiviert.";

	WEAPONBUTTONS_CHAT_ENABLED			= "Waffen Buttons aktiviert.";
	WEAPONBUTTONS_CHAT_DISABLED                     = "Waffen Buttons deaktiviert.";
   
	WEAPONBUTTONS_CHAT_COMMAND_ENABLE_INFO          = "Aktiviert/deaktiviert das Waffen Buttons Fenster.";	WEAPONBUTTONS_CHAT_COMMAND_DISPLAY_TOOLTIPS_INFO= "Aktiviert/deaktiviert die Anzeige von Tooltips, wenn der Mauszeiger \195\188ber die Buttons im Waffen Buttons Fenster bewegt wird.";
   
   	WEAPONBUTTONS_CHAT_LOCK_POSITION_ENABLED        = "Position des Waffen Buttons Fensters wurde eingerastet.";
	WEAPONBUTTONS_CHAT_LOCK_POSITION_DISABLED       = "Einrastsperre des Waffen Buttons Fensters wurde aufgehoben.";
	WEAPONBUTTONS_CHAT_COMMAND_LOCK_POSITION_INFO   = "Aktiviert/deaktiviert das Einrasten des Waffen Buttons Fensters an seiner aktuellen Position.";

	WEAPONBUTTONS_CHAT_COMMAND_RESET_INFO           = "Setzt die Position des Waffen Button Fensters auf seine Standard-Positon zur\195\164ck.";
   
	WEAPONBUTTONS_CHAT_COMMAND_INFO                 = "Steuert das Waffen Buttons Fenster per Kommandozeile. Geben Sie /weaponbutton ein um eine Hilfe zu bekommen.";
   
	WEAPONBUTTONS_CHAT_COMMAND_USAGE		= "Anwendung: /weaponbutton <show/tooltips/lock/mode> [on/off/toggle]\nBefehle:\nshow - gibt an, ob das Waffen Buttons Fenster angezeigt werden soll\ntooltips - ob Tooltips angezeigt werden sollen\nlock - ob das Fenster bewegt werden kann\nmode - \195\164ndert den Standardmodus auf Fern- oder Nahkampf\ntogglemode - schaltet den Modus der Waffen Buttons um (wie Rechtsklick)";
   
	WEAPONBUTTONS_CHAT_SETMODE			= "Modus der Waffen Buttons auf %s gesetzt.";
	WEAPONBUTTONS_CHAT_MODE_ILLEGAL			= "Unzul\195\164ssiger Modus der Waffen Buttons.";
	WEAPONBUTTONS_CHAT_MODE_MELEE			= "Nahkampf";
	WEAPONBUTTONS_CHAT_MODE_RANGED			= "Fernkampf";
	WEAPONBUTTONS_CHAT_MODE_TRINKETS		= "Schmuck";

	-- UltimateUI AddOn Mod Configuration
	WEAPONBUTTONS_CONFIG_TRANSNUI			= "Waffen Buttons";
	WEAPONBUTTONS_CONFIG_TRANSNUI_INFO              = "Ver\195\164ndert die Sichtbarkeit der Waffen Buttons.";
   
	WEAPONBUTTONS_CONFIG_POPNUI                     = "Waffen Buttons";
	WEAPONBUTTONS_CONFIG_POPNUI_INFO		= "Wenn aktiviert, wird das Fenster der Waffen Buttons nur sichtbar, wenn man den Mauszeiger \195\188ber jenes bewegt."; 

	-- Configuration Setup
	WEAPONBUTTONS_CHAT_MODES = {
		WEAPONBUTTONS_CHAT_MODE_MELEE,
		WEAPONBUTTONS_CHAT_MODE_RANGED,
		WEAPONBUTTONS_CHAT_MODE_TRINKETS
	};

end