-- Version : French ( Elzix, Sasmira )
-- Last Update : 03/24/2005

if ( GetLocale() == "frFR" ) then

-- Binding Configuration
BINDING_HEADER_ALTSELFCASTHEADER	= "Self Cast";
BINDING_NAME_ALTSELFCAST		= "Marche/Arr\195\170t Self Cast";
BINDING_NAME_ALTSELFCASTOVERRIDE	= "Self Cast Override";
BINDING_NAME_ALTSELFCASTTOGGLEOVERRIDE	= "Self Cast Continous Override";

-- UltimateUI Configuration
ALTSELFCAST_CONFIG_HEADER		= "Self Cast";
ALTSELFCAST_CONFIG_HEADER_INFO		= "Utiliser ce Mod pour configurer un raccourci afin de lancer des sorts sur soi-m\195\170me";
ALTSELFCAST_ENABLED			= "Activer Self Cast";
ALTSELFCAST_ENABLED_INFO		= "Active le Lancement des sorts sur soi-m\195\170me pour ce personnage.";
ALTSELFCAST_ALT_KEY			= "Utiliser la touche ALT pour Self Cast";
ALTSELFCAST_ALT_KEY_INFO		= "Si la touche ALT est maintenue, le Lancement des sorts sur soi-m\195\170me se produira.";
ALTSELFCAST_SHIFT_KEY			= "Utiliser la touche SHIFT pour Self Cast";
ALTSELFCAST_SHIFT_KEY_INFO		= "Si la touche SHIFT est maintenue, le Lancement des sorts sur soi-m\195\170me se produira.";
ALTSELFCAST_CTRL_KEY			= "Utiliser la touche CTRL pour Self Cast";
ALTSELFCAST_CTRL_KEY_INFO		= "Si la touche CTRL est maintenue, le Lancement des sorts sur soi-m\195\170me se produira.";
ALTSELFCAST_SMART			= "Self Cast Automatique";
ALTSELFCAST_SMART_INFO			= "En l\'activant, les sorts se feront sur vous-m\195\170me sii vous n\'avez pas de cible.";
ALTSELFCAST_SMART_NOGROUP		= "D\195\169sactiver 'Self Cast Rapide' en groupe.";
ALTSELFCAST_SMART_NOGROUP_INFO		= "D\195\169sactive 'Self Cast Rapide' quand vous \195\170tes en groupe.";
ALTSELFCAST_NODISPEL			= "Ne pas lancer Dissipation de la Magie en Self-Cast";
ALTSELFCAST_NODISPEL_INFO		= "Emp_195_170che les sorts de Dissipation de la Magie d\'\195\170tres automatiquement lanc\195\169s.";
ALTSELFCAST_OVERRIDE			= "R\195\169initialisation de Self Cast";
ALTSELFCAST_OVERRIDE_INFO		= "R\195\169initialise toutes les options de Self Cast";
ALTSELFCAST_OVERRIDE_NAME		= "R\195\169initialiser";

-- Chat Configuration
ALTSELFCAST_CHAT_ENABLED		= "Alt - Self-Cast activ\195\169.";
ALTSELFCAST_CHAT_DISABLED		= "Alt - Self-Cast d\195\169sactiv\195\169.";
ALTSELFCAST_CHAT_KEY_ALT		= "Alt";
ALTSELFCAST_CHAT_KEY_SHIFT		= "Shift";
ALTSELFCAST_CHAT_KEY_CTRL		= "Ctrl";
ALTSELFCAST_CHAT_KEY_ENABLED		= "Self-Cast - touche %s activ\195\169.";
ALTSELFCAST_CHAT_KEY_DISABLED		= "Self-Cast - touche %s d\195\169sactiv\195\169.";
ALTSELFCAST_CHAT_OVERRIDE_ENABLED	= "Self-Cast - R\195\169initialisation activ\195\169.";
ALTSELFCAST_CHAT_OVERRIDE_DISABLED	= "Self-Cast - R\195\169initialisation d\195\169sactiv\195\169.";
ALTSELFCAST_CHAT_SMART_ENABLED		= "Self-Cast - Self-Cast automatique activ\195\169";
ALTSELFCAST_CHAT_SMART_DISABLED		= "Self-Cast - Self-Cast automatique d\195\169sactiv\195\169";
ALTSELFCAST_CHAT_NODISPEL_ENABLED	= "Self-Cast - Dissipation de la Magie en Self Cast activ\195\169";
ALTSELFCAST_CHAT_NODISPEL_DISABLED	= "Self-Cast - Dissipation de la Magie en Self Cast d\195\169sactiv\195\169";


ALTSELFCAST_CHAT_COMMAND_INFO		= "Taper /altselfcast ou /asc pour plus de d\195\169tails.";
ALTSELFCAST_CHAT_COMMAND_HELP		= {};
ALTSELFCAST_CHAT_COMMAND_HELP[1]	= "Taper /altselfcast or /asc et une option suivi de ON/OFF.";
ALTSELFCAST_CHAT_COMMAND_HELP[2]	= "Exemple : /asc enable on";
ALTSELFCAST_CHAT_COMMAND_HELP[3]	= "enable - Active/D\195\169sactive Self Cast.";
ALTSELFCAST_CHAT_COMMAND_HELP[4]	= "alt - Active/D\195\169sactive le raccourci ALT requis pour Self Cast.";
ALTSELFCAST_CHAT_COMMAND_HELP[5]	= "shift - Active/D\195\169sactive le raccourci SHIFT requis pour Self Cast.";
ALTSELFCAST_CHAT_COMMAND_HELP[6]	= "ctrl (or control) - Active/D\195\169sactive le raccourci CTRL requis pour Self Cast.";
ALTSELFCAST_CHAT_COMMAND_HELP[7]	= "smart - Active/D\195\169sactive le Mode Self Cast Automatique.";
ALTSELFCAST_CHAT_COMMAND_HELP[8]	= "nogroup - Active/D\195\169sactive le Mode Self Cast Automatique en groupe.";
ALTSELFCAST_CHAT_COMMAND_HELP[9]	= "override - Active/D\195\169sactive la R\195\169initialisation des options.";
ALTSELFCAST_CHAT_COMMAND_HELP[10]	= "nodispel - Active/D\195\169sactive Dissipation de la Magie en Self Cast.";

-- Localisation Strings
ALTSELFCAST_DISPELMAGIC_NAME		= "Dissipation de la Magie";

end