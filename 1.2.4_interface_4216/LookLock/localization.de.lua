-- Version : German (by pc, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- <= == == == == == == == == == == == == =>
	-- => Bindings Names
	-- <= == == == == == == == == == == == == =>
	BINDING_HEADER_LOOKLOCKHEADER           = "Sichtsperre";
	BINDING_NAME_LOOKLOCK                   = "Sichtsperre ein-/ausschalten";
	BINDING_NAME_LOOKLOCKPUSH               = "Sichtsperre Halten";
	BINDING_NAME_LOOKLOCKACTION             = "Sichtsperre Aktion";
	BINDING_NAME_LOOKLOCKCAMERA             = "Sichtsperre Kamera";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Configuration Strings
	-- <= == == == == == == == == == == == == =>
	LOOKLOCK_CONFIG_HEADER                  = "Sichtsperre";
	LOOKLOCK_CONFIG_HEADER_INFO             = "Diese Einstellungen erlauben die Konfiguration der Sichtsperre.";
	LOOKLOCK_CONFIG_REMAP_ONOFF             = "Maustasten in der Sichtsperre andere Funktione zuweisen";
	LOOKLOCK_CONFIG_REMAP_ONOFF_INFO        = "Verbessert die Benutzung der Maustasten bei Verwendung der Sichtsperre.";
	LOOKLOCK_CONFIG_STRAFE_ONOFF            = "Maustasten 'Strafe'";
	LOOKLOCK_CONFIG_STRAFE_ONOFF_INFO       = "Wenn die Sichtsperre aktivert ist, k\195\182nnen die Maustasten zum strafen benutzt werden.";
	LOOKLOCK_CONFIG_ALWAYS_ONOFF            = "Immer gesperrt (Hochgradig experimentell)";
	LOOKLOCK_CONFIG_ALWAYS_ONOFF_INFO       = "Hiermit wird die Maus st\195\164ndig im Sichtsperre-Modus gehalten. Rechtsklick stellt den normalen Modus wieder her.";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Chat Command Strings
	-- <= == == == == == == == == == == == == =>
	LOOKLOCK_CHAT_COMMAND_INFO		= "Gib /looklock oder /ll ein um eine Hilfe anzuzeigen.";
	LOOKLOCK_CHAT_COMMAND_HELP 		= {};
	LOOKLOCK_CHAT_COMMAND_HELP[1]           = "Gib /looklock oder /ll gefolgt von der Option, dann on/off ein.";
	LOOKLOCK_CHAT_COMMAND_HELP[2]           = "Beispiel: /ll remap on";
	LOOKLOCK_CHAT_COMMAND_HELP[3]           = "remap - Parameter: 1 um die Funktion der Maustasten f\195\188r die Sichtsperre zu ver\195\164ndern, 0 um die Ver\195\164nderung der Maustastenfunktion zu deaktiveren.";
	LOOKLOCK_CHAT_COMMAND_HELP[4]           = "strafe - Parameter: 1 um die Maustasten in der Sichtsperre als 'Strafe' zu benutzen, 0 um dies zu deaktiveren.";
	LOOKLOCK_CHAT_COMMAND_HELP[5]           = "reset - Setzt die Funktion der Maustasten zur\195\188ck auf Normal (behebt Fehler mit \195\164lteren Sichtsperre Versionen).";
	LOOKLOCK_CHAT_COMMAND_HELP[6]           = "always - Setzt die Maus dauerhaft in den Modus der Sichtsperre. Rechtsklick stellt den normalen Modus wieder her.";

	-- <= == == == == == == == == == == == == =>
	-- => Chat Strings
	-- <= == == == == == == == == == == == == =>
	LOOKLOCK_CHAT_REMAP_ON			= "Sichtsperre Maustasten Funktion ge\195\164ndert.";
	LOOKLOCK_CHAT_REMAP_OFF			= "Sichtsperre Maustasten Funktion zur\195\188ckgesetzt.";
	LOOKLOCK_CHAT_STRAFE_ON			= "Sichtsperre Maus 'Strafe' aktivert.";
	LOOKLOCK_CHAT_STRAFE_OFF		= "Sichtsperre Maus 'Strafe' deaktivert.";
	LOOKLOCK_CHAT_ALWAYS_ON			= "Sichtsperre dauerhaft aktiviert.";
	LOOKLOCK_CHAT_ALWAYS_OFF		= "Sichtsperredauerhaft deaktiviert.";
	LOOKLOCK_CHAT_FIX_DONE			= "Maustastenfunktion zur\195\188ckgesetzt.";

end