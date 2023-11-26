-- Version : English - sarf
-- Translation by : None

BINDING_HEADER_ALTSELFCASTHEADER		= "Self Cast";
BINDING_NAME_ALTSELFCAST				= "Self Cast Toggle";
BINDING_NAME_ALTSELFCASTOVERRIDE		= "Self Cast Override";
BINDING_NAME_ALTSELFCASTTOGGLEOVERRIDE	= "Self Cast Continous Override";

ALTSELFCAST_CONFIG_HEADER				= "Self Cast";
ALTSELFCAST_CONFIG_HEADER_INFO			= "Setting to let you self cast spells with key combinations";
ALTSELFCAST_ENABLED						= "Enable Self Cast";
ALTSELFCAST_ENABLED_INFO				= "Enables Self Casting options.";
ALTSELFCAST_ALT_KEY						= "Allow Alt for Self Cast";
ALTSELFCAST_ALT_KEY_INFO				= "If Alt key is held down self cast will occur.";
ALTSELFCAST_SHIFT_KEY					= "Allow Shift for Self Cast";
ALTSELFCAST_SHIFT_KEY_INFO				= "If Alt key is held down self cast will occur.";
ALTSELFCAST_CTRL_KEY					= "Allow Ctrl for Self Cast";
ALTSELFCAST_CTRL_KEY_INFO				= "If Alt key is held down self cast will occur.";
ALTSELFCAST_SMART						= "Smart Self Cast";
ALTSELFCAST_SMART_INFO					= "If enabled, spells will always be self cast if you have no target.";
ALTSELFCAST_SMART_NOGROUP				= "Disables Smart Self Casting in groups.";
ALTSELFCAST_SMART_NOGROUP_INFO			= "Will disable Smart Self Casting when you are in a group.";
ALTSELFCAST_NODISPEL					= "Do not Self-Cast Dispel Magic";
ALTSELFCAST_NODISPEL_INFO				= "If enabled this will prevent Dispel-Magic from being self-cast.";
ALTSELFCAST_OVERRIDE					= "Resets the self-cast override";
ALTSELFCAST_OVERRIDE_INFO				= "Resets the self-cast override to off, in case it gets stuck.";
ALTSELFCAST_OVERRIDE_NAME				= "Reset";
ALTSELFCAST_CHAT_ENABLED				= "Alt-Self Casting enabled.";
ALTSELFCAST_CHAT_DISABLED				= "Alt-Self Casting disabled.";
ALTSELFCAST_CHAT_KEY_ALT				= "Alt";
ALTSELFCAST_CHAT_KEY_SHIFT				= "Shift";
ALTSELFCAST_CHAT_KEY_CTRL				= "Ctrl";
ALTSELFCAST_CHAT_KEY_ENABLED			= "AltSelfCast - %s key enabled.";
ALTSELFCAST_CHAT_KEY_DISABLED			= "AltSelfCast - %s key disabled.";
ALTSELFCAST_CHAT_OVERRIDE_ENABLED		= "AltSelfCast - overriding enabled.";
ALTSELFCAST_CHAT_OVERRIDE_DISABLED		= "AltSelfCast - overriding disabled.";
ALTSELFCAST_CHAT_SMART_ENABLED			= "AltSelfCast - smart self casting enabled";
ALTSELFCAST_CHAT_SMART_DISABLED			= "AltSelfCast - smart self casting disabled";
ALTSELFCAST_CHAT_NODISPEL_ENABLED		= "AltSelfCast - Dispel Magic will no longer be self-cast";
ALTSELFCAST_CHAT_NODISPEL_DISABLED		= "AltSelfCast - Dispel Magic will be self-cast";

ALTSELFCAST_CHAT_COMMAND_INFO			= "Type /altselfcast or /asc for usage info.";
ALTSELFCAST_CHAT_COMMAND_HELP = {};
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "Type /altselfcast or /asc and then the option, and then on/off.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "Example: /asc enable on");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "enable - Enables/disables Alt-Self Casting.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "alt - Enables/disables the Alt-key requirement for Self Casting.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "shift - Enables/disables the Shift-key requirement for Self Casting.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "ctrl (or control) - Enables/disables the Ctrl-key requirement for Self Casting.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "smart - Enables/disables the Smart Self casting mode.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "nogroup - Enables/disables Smart Self casting in groups.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "override - Enables/disables the continous self-cast overriding.");
table.insert(ALTSELFCAST_CHAT_COMMAND_HELP, "nodispel - Enables/disables the self-casting of Dispel Magic.");


if ( GetLocale() == "deDE" ) then
	-- Translation by DoctorVanGogh

BINDING_HEADER_ALTSELFCASTHEADER        = "Self Cast";
    BINDING_NAME_ALTSELFCAST                = "Self Cast ein-/ausschalten";
    BINDING_NAME_ALTSELFCASTOVERRIDE        = "Self Cast überschreiben";
    BINDING_NAME_ALTSELFCASTTOGGLEOVERRIDE  = "Self Cast dauerhaft überschreiben";

    ALTSELFCAST_CONFIG_HEADER               = "Self Cast";
    ALTSELFCAST_CONFIG_HEADER_INFO          = "Hiermit kann  per Tastenkombination automatisch der eigene Charakter als Ziel eines Zauber gewählt werden";
    ALTSELFCAST_ENABLED                     = "Aktiviere Self Cast";
    ALTSELFCAST_ENABLED_INFO                = "Aktiviert die Self Cast Optionen.";
    ALTSELFCAST_ALT_KEY                     = "Benutzte 'Alt' für Self Cast";
    ALTSELFCAST_ALT_KEY_INFO                = "Self Cast wird durch das Drücken von Alt aktiviert.";
    ALTSELFCAST_SHIFT_KEY                   = "Benutzte 'Shift' für Self Cast";
    ALTSELFCAST_SHIFT_KEY_INFO              = "Self Cast wird durch das Drücken von Shift aktiviert.";
    ALTSELFCAST_CTRL_KEY                    = "Benutzte 'Strg' für Self Cast";
    ALTSELFCAST_CTRL_KEY_INFO               = "Self Cast wird durch das Drücken von Strg aktiviert.";
    ALTSELFCAST_SMART                       = "Intelligentes Self Cast";
    ALTSELFCAST_SMART_INFO                  = "Wenn aktiviert, werden Zaubersprüche automatisch auf einen Selbst gesprochen sofern kein Ziel markiert ist.";
    ALTSELFCAST_OVERRIDE                    = "Setze Überschreibung von Self Cast zurück";
    ALTSELFCAST_OVERRIDE_INFO               = "Setzt die Überschreibung von Self Cast zurück, sollte es hängen bleiben.";
    ALTSELFCAST_OVERRIDE_NAME               = "Zurücksetzen";
    ALTSELFCAST_CHAT_ENABLED                = "AltSelfCast aktiviert.";
    ALTSELFCAST_CHAT_DISABLED               = "AltSelfCast deaktivert.";
    ALTSELFCAST_CHAT_KEY_ALT                = "Alt";
    ALTSELFCAST_CHAT_KEY_SHIFT              = "Shift";
    ALTSELFCAST_CHAT_KEY_CTRL               = "Strg";
    ALTSELFCAST_CHAT_KEY_ENABLED            = "AltSelfCast - %s Taste aktivert.";
    ALTSELFCAST_CHAT_KEY_DISABLED           = "AltSelfCast - %s Taste deaktivert.";
    ALTSELFCAST_CHAT_OVERRIDE_ENABLED       = "AltSelfCast - Überschreibung aktiviert.";
    ALTSELFCAST_CHAT_OVERRIDE_DISABLED      = "AltSelfCast - Überschreibung deaktiviert.";
    ALTSELFCAST_CHAT_SMART_ENABLED          = "AltSelfCast - Intelligentes Self Cast aktiviert";
    ALTSELFCAST_CHAT_SMART_DISABLED         = "AltSelfCast - Intelligentes Self Cast deaktiviert";


    ALTSELFCAST_CHAT_COMMAND_ENABLE_INFO    = "Aktiviert/Deaktiviert AltSelfCast.";
    ALTSELFCAST_CHAT_COMMAND_ALT_INFO       = "Aktiviert/Deaktiviert die Alt-Taste für Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_SHIFT_INFO     = "Aktiviert/Deaktiviert die Shift-Taste für Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_CTRL_INFO      = "Aktiviert/Deaktiviert die Strg-Taste für Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_SMART_INFO     = "Aktiviert/Deaktiviert intelligentes Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_OVERRIDE_INFO  = "Aktiviert/Deaktiviert die dauerhafte Self Cast Überschreibung.";

    ALTSELFCAST_CHAT_NODISPEL_ENABLED       = "AltSelfCast - Magie Bannen nicht mehr auf sich selbst zaubern";      -- CHECK: Has 'Dispel Magic' been translated to 'Magie Bannen' ???
    ALTSELFCAST_CHAT_NODISPEL_DISABLED      = "AltSelfCast - Magie Bannen auf sich selbst zaubern";                 -- CHECK: Has 'Dispel Magic' been translated to 'Magie Bannen' ???
    
    ALTSELFCAST_CHAT_COMMAND_INFO           = "/altselfcast oder /asc eingeben für Parameterhilfe.";

	ALTSELFCAST_CHAT_COMMAND_HELP = {};

    ALTSELFCAST_CHAT_COMMAND_HELP[1]= "Eingabe: /altselfcast oder /asc gefolgt von der jeweiligen Einstellung, danach on/off.";
    ALTSELFCAST_CHAT_COMMAND_HELP[2]= "Beispiel: /asc enable on";
    ALTSELFCAST_CHAT_COMMAND_HELP[3]= "enable - Aktiviert/Deaktiviert Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_HELP[4]= "alt - Aktiviert/Deaktiviert die Alt-Taste als Einstellung für Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_HELP[5]= "shift - Aktiviert/Deaktiviert die Shift-Taste als Einstellung für Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_HELP[6]= "ctrl (oder control) - Aktiviert/Deaktiviert die Strg-Taste als Einstellung für Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_HELP[7]= "smart - Aktiviert/Deaktiviert intelligentes Self Cast.";
    ALTSELFCAST_CHAT_COMMAND_HELP[8]= "nogroup - Aktiviert/Deaktiviert intelligentes Self Cast in Gruppen.";
    ALTSELFCAST_CHAT_COMMAND_HELP[9]= "override - Aktiviert/Deaktiviert die dauerhaft überschreiben Einstellung.";
    ALTSELFCAST_CHAT_COMMAND_HELP[10]= "nodispel - Aktiviert/Deaktiviert Self Cast für Magie Bannen.";  -- CHECK: Has 'Dispel Magic' been translated to 'Magie Bannen' ???
end