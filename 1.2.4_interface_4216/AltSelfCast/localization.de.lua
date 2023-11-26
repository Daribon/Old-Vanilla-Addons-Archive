-- Version : German (by DoctorVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_ALTSELFCASTHEADER        = "Selbstzauber";
	BINDING_NAME_ALTSELFCAST                = "Selbstzauber ein-/ausschalten";
	BINDING_NAME_ALTSELFCASTOVERRIDE        = "Selbstzauber \195\188berschreiben";
	BINDING_NAME_ALTSELFCASTTOGGLEOVERRIDE  = "Selbstzauber dauerhaft \195\188berschr.";

	-- Cosmos Configuration
	ALTSELFCAST_CONFIG_HEADER               = "Selbstzauber";
	ALTSELFCAST_CONFIG_HEADER_INFO          = "Hiermit kann per Tastenkombination automatisch der eigene Charakter als Ziel eines Zauber gew\195\164hlt werden";
	ALTSELFCAST_ENABLED                     = "Selbstzauber aktivieren";
	ALTSELFCAST_ENABLED_INFO                = "Aktiviert die Selbstzauber Optionen f\195\188r diesen Charakter.";
	ALTSELFCAST_ALT_KEY                     = "Benutzte 'Alt' f\195\188r Selbstzauber";
	ALTSELFCAST_ALT_KEY_INFO                = "Selbstzauber wird durch dr\195\188cken von 'Alt' aktiviert.";
	ALTSELFCAST_SHIFT_KEY                   = "Benutzte 'Shift' f\195\188r Selbstzauber";
	ALTSELFCAST_SHIFT_KEY_INFO              = "Selbstzauber wird durch dr\195\188cken von 'Shift' aktiviert.";
	ALTSELFCAST_CTRL_KEY                    = "Benutzte 'Strg' f\195\188r Selbstzaubert";
	ALTSELFCAST_CTRL_KEY_INFO               = "Selbstzauber wird durch dr\195\188cken von 'Strg' aktiviert.";
	ALTSELFCAST_SMART                       = "Intelligentes Selbstzaubern";
	ALTSELFCAST_SMART_INFO                  = "Wenn aktiviert, werden Zauberspr\195\188che automatisch auf einen selbst gesprochen sofern kein Ziel markiert ist.";
	ALTSELFCAST_SMART_NOGROUP		= "Intelligentes Selbstzaubern in Gruppen deaktivieren";
	ALTSELFCAST_SMART_NOGROUP_INFO		= "Intelligentes Selbstzaubern deaktivieren\nwenn man sich in einer Gruppe befindet.";
	ALTSELFCAST_NODISPEL			= "Selbstzauber nicht f\195\188r Magiebannung benutzen";
	ALTSELFCAST_NODISPEL_INFO		= "Wenn aktiviert, wird Magiebannung\nnicht mehr auf einen selbst gesprochen.";
	ALTSELFCAST_OVERRIDE                    = "\195\156berschreibung von\nSelbstzauber zur\195\188cksetzen";
	ALTSELFCAST_OVERRIDE_INFO               = "Setzt die \195\156berschreibung vom Selbstzauber zur\195\188ck, sollte es h\195\164ngen bleiben.";
	ALTSELFCAST_OVERRIDE_NAME               = "Zur\195\188cksetzen";

	-- Chat Configuration
	ALTSELFCAST_CHAT_ENABLED                = "Selbstzauber aktiviert.";
	ALTSELFCAST_CHAT_DISABLED               = "Selbstzauber deaktivert.";
	ALTSELFCAST_CHAT_KEY_ALT                = "Alt";
	ALTSELFCAST_CHAT_KEY_SHIFT              = "Shift";
	ALTSELFCAST_CHAT_KEY_CTRL               = "Strg";
	ALTSELFCAST_CHAT_KEY_ENABLED            = "Selbstzauber - %s Taste aktivert.";
	ALTSELFCAST_CHAT_KEY_DISABLED           = "Selbstzauber - %s Taste deaktivert.";
	ALTSELFCAST_CHAT_OVERRIDE_ENABLED       = "Selbstzauber - \195\156berschreibung aktiviert.";
	ALTSELFCAST_CHAT_OVERRIDE_DISABLED      = "Selbstzauber - \195\156berschreibung deaktiviert.";
	ALTSELFCAST_CHAT_SMART_ENABLED          = "Selbstzauber - Intelligentes Selbstzaubern aktiviert";
	ALTSELFCAST_CHAT_SMART_DISABLED         = "Selbstzauber - Intelligentes Selbstzaubern deaktiviert";
	ALTSELFCAST_CHAT_COMMAND_ENABLE_INFO    = "Aktiviert/Deaktiviert Selbstzaubern.";
	ALTSELFCAST_CHAT_COMMAND_ALT_INFO       = "Aktiviert/Deaktiviert die Alt-Taste f\195\188r Selbstzaubern.";
	ALTSELFCAST_CHAT_COMMAND_SHIFT_INFO     = "Aktiviert/Deaktiviert die Shift-Taste f\195\188r Selbstzaubern.";
	ALTSELFCAST_CHAT_COMMAND_CTRL_INFO      = "Aktiviert/Deaktiviert die Strg-Taste f\195\188r Selbstzaubern.";
	ALTSELFCAST_CHAT_COMMAND_SMART_INFO     = "Aktiviert/Deaktiviert intelligentes Selbstzaubern.";
	ALTSELFCAST_CHAT_COMMAND_OVERRIDE_INFO  = "Aktiviert/Deaktiviert die dauerhafte Selbstzauber \195\156berschreibung.";
	ALTSELFCAST_CHAT_NODISPEL_ENABLED       = "Selbstzauber - Magiebannung nicht mehr auf sich selbst zaubern";
	ALTSELFCAST_CHAT_NODISPEL_DISABLED      = "Selbstzauber - Magiebannung auf sich selbst zaubern";
    
	ALTSELFCAST_CHAT_COMMAND_INFO           = "/altselfcast oder /asc eingeben f\195\188r Parameterhilfe.";
	ALTSELFCAST_CHAT_COMMAND_HELP		= {};
	ALTSELFCAST_CHAT_COMMAND_HELP[1]	= "Eingabe: /altselfcast oder /asc gefolgt von der jeweiligen Einstellung, danach on/off.";
	ALTSELFCAST_CHAT_COMMAND_HELP[2]	= "Beispiel: /asc enable on";
	ALTSELFCAST_CHAT_COMMAND_HELP[3]	= "enable - Aktiviert/Deaktiviert Selbstzauber.";
	ALTSELFCAST_CHAT_COMMAND_HELP[4]	= "alt - Aktiviert/Deaktiviert die Alt-Taste als Benutzung f\195\188r Selbstzauber.";
	ALTSELFCAST_CHAT_COMMAND_HELP[5]	= "shift - Aktiviert/Deaktiviert die Shift-Taste als Benutzung f\195\188r Selbstzaubert.";
	ALTSELFCAST_CHAT_COMMAND_HELP[6]	= "ctrl (oder control) - Aktiviert/Deaktiviert die Strg-Taste als Benutzung f\195\188r Selbstzauber.";
	ALTSELFCAST_CHAT_COMMAND_HELP[7]	= "smart - Aktiviert/Deaktiviert intelligentes Selbstzaubern.";
	ALTSELFCAST_CHAT_COMMAND_HELP[8]	= "nogroup - Aktiviert/Deaktiviert intelligentes Selbstzaubern in Gruppen.";
	ALTSELFCAST_CHAT_COMMAND_HELP[9]	= "override - Aktiviert/Deaktiviert die dauerhaft \195\188berschreiben Einstellung.";
	ALTSELFCAST_CHAT_COMMAND_HELP[10]	= "nodispel - Aktiviert/Deaktiviert Selbstzauber f\195\188r Magiebannung.";

	-- Localisation Strings
	ALTSELFCAST_DISPELMAGIC_NAME		= "Magiebannung";

end