-- QuestLogLevelPatch localization information
-- French Locale
-- Translation by Sasmira
-- Last Update 06/11/2005

if ( GetLocale ) and ( GetLocale() == "frFR" ) then


	QuestLogLevelPatch_Format_Tags.Donjon = "[%d+] %s";

QUESTLEVEL_CMDS				= {"/questloglevelpatch", "/questloglevel", "/ql", "/questlevel"};

QUESTLEVEL_CONFIG_HEADER		= "Niveau des Qu\195\170tes";
QUESTLEVEL_CONFIG_HEADER_INFO		= "Ajoute une indication du niveau des Qu\195\170tes dans le journal des Qu\195\170tes.";

QUESTLEVEL_CONFIG_ENABLED		= "Activ\195\169";
QUESTLEVEL_CONFIG_ENABLED_INFO		= "Active/D\195\169sactive l\'ajout d\'indication de niveau dans le journal des Qu\195\170tes.";

QUESTLEVEL_KHAOS_SET_EASY_ID		= "QuestLogLevelPatchEasyOptionID";
QUESTLEVEL_KHAOS_EASYSET_TEXT		= "Niveau des Qu\195\170tes";
QUESTLEVEL_KHAOS_EASYSET_HELP		= "Ajoute une indication du niveau des Qu\195\170tes dans le journal des Qu\195\170tes.";

QUESTLEVEL_KHAOS_ENABLED_TEXT		= "Activ\195\169";
QUESTLEVEL_KHAOS_ENABLED_HELPTEXT	= "Whether to patch the QuestLog levels or not.";


QUESTLEVEL_KHAOS_STATE_TEXT		= "L'ajout du Niveau des Qu\195\170tes est ";
QUESTLEVEL_KHAOS_STATE_ENABLED		= "Activ\195\169";
QUESTLEVEL_KHAOS_STATE_DISABLED		= "D\195\169sactiv\195\169";

end
