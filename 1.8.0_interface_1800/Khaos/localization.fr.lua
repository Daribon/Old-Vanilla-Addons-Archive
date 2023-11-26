--[[
--	Khaos Localization
--		"Change."	 	
--	
--	French By: Sasmira
--	
--	$Id: localization.fr.lua 2462 2005-09-16 05:54:21Z sasmiraa $
--	$Rev: 2462 $ Initial translation
--	$LastChangedBy: sasmiraa $ Sasmira
--	$Date: 2005-09-16
--]]

if ( GetLocale() == "frFR" ) then

KHAOS_TITLE_TEXT = "Khaos";

KHAOS_TAB_CHANGECONFIGURATION_TEXT = "Changer la Configuration";
KHAOS_TAB_SELECTCONFIGURATION_TEXT = "Selectionner la Configuration";

KHAOS_CURRENT_CONFIGURATION_TEXT = "Configuration Courante : (%d) %s";

-- Binding
BINDING_HEADER_KHAOS		= "Configuration de Khaos";
BINDING_NAME_TOGGLEKHAOS	= "[ON/OFF] Panneau de Khaos";

-- Button
KHAOS_BUTTON_SUB = "Configuration";
KHAOS_BUTTON_TIP = "Configuration des AddOns";

KHAOS_OPTIONS_TEXT = "Configuration de Khaos";

-- Change Configuration
KHAOS_SELECT_CONFIGURATION_SETUP = "Menu des Options";

-- Default Configuration Tilt
KHAOS_DEFAULT_CONFIGURATION_NAME = "Configuration Initiale";
KHAOS_DEFAULT_COPY_APPEND = "(copie)";
KHAOS_EMPTY_CONFIGURATION_NAME = "Configuration vide";

-- Login Screen Selection
KHAOS_LOGIN_EDIT = "Editer";
KHAOS_LOGIN_USE = "Utiliser";
KHAOS_LOGIN_LOCK_MESSAGE = "Options par d\195\169faut pour %s.";
KHAOS_LOGIN_SELECT_MESSAGE = "Selectionner une configuration.";
KHAOS_LOGIN_SELECT_HELP_MESSAGE = "Les configurations sont des ensembles d\'options que vous pouvez \nadapter aux besoins du client en appuyant sur la touche d\'\195\169dition \ou aller dans le panneau de configuration de Khaos.\n\nCet \195\169cran ne devrait pas apparaitre, \nsi vous choisissez de bloquer la configuration \nd\'un personnage.";

-- Configuration Changer
KHAOS_SELECT_ALL = "G\195\169n\195\169ral";
KHAOS_SELECT_CHARACTERS = "Personnages";
KHAOS_SELECT_REALMS = "Royaumes";
KHAOS_SELECT_CLASSES = "Classes";
KHAOS_SELECT_DEFAULT = "D\195\169faut";

KHAOS_SELECT_ALL_HEADER = "G\195\169n\195\169ral";
KHAOS_SELECT_CHARACTERS_HEADER = "Personnage";
KHAOS_SELECT_REALMS_HEADER = "Royaume";
KHAOS_SELECT_CLASSES_HEADER = "Classe";
KHAOS_SELECT_DEFAULT_HEADER = "D\195\169faut";

KHAOS_SELECT_HEADER = "Configurations de %s";
KHAOS_SELECT_NONE_LOCKED = "-Aucune de verrouill\195\169e-";
KHAOS_OPTION_CHOOSE = "Choisissez :";

-- Side Buttons
KHAOS_SELECT_BUTTON_SAVE = "Sauvegarder";
KHAOS_SELECT_BUTTON_LOAD = "Lancer";
KHAOS_SELECT_BUTTON_DUPE = "Dupliquer";
KHAOS_SELECT_BUTTON_RENAME = "Renommer";
KHAOS_SELECT_BUTTON_EXPORT = "Exporter";
KHAOS_SELECT_BUTTON_IMPORT = "Importer";

-- Difficulty
KHAOS_SET_DIFFICULTY = "Difficult\195\169";

KHAOS_SET_DIFFICULTY_MENU_TITLE = "Niveau de Difficult\195\169";
KHAOS_SET_DIFFICULTY_MENU_FORMAT = "%d - %s";
KHAOS_SET_DIFFICULTY_DEFAULT = "(D\195\169faut)";

KHAOS_SET_DIFFICULTY_1 = "D\195\169butant";
KHAOS_SET_DIFFICULTY_2 = "Expert";
KHAOS_SET_DIFFICULTY_3 = "Maitre";
KHAOS_SET_DIFFICULTY_4 = "D\195\169veloppeur";

-- Table of Contents
KHAOS_OPTION_TABLEOFCONTENTS = "Table des mati\195\168res";

KHAOS_OPTION_TABLEOFCONTENTS_MENU_TITLE = "Table des mati\195\168res";
KHAOS_OPTION_TABLEOFCONTENTS_MENU_FORMAT = "%d - %s";
KHAOS_OPTION_TABLEOFCONTENTS_MENU_TOP 	= "Haut";
KHAOS_OPTION_TABLEOFCONTENTS_MENU_BOTTOM = "Bas";

-- Menu
KHAOS_SET_MENU_ENABLE = "Actif";
KHAOS_SET_MENU_RESET = "Remise \195\160 Zero";

-- CFG Menu
KHAOS_CONFIG_MENU_NEW = "Nouvelle Configuration";
KHAOS_CONFIG_MENU_IMPORT = "Importer la Configuration";
KHAOS_CONFIG_MENU_CHANGE_DEFAULT = "Changer la configuration par D\195\169faut";
KHAOS_CONFIG_MENU_DELETE = "Supprimer \"%s\"";
KHAOS_CONFIG_MENU_COPY = "Copier \"%s\"";
KHAOS_CONFIG_MENU_RENAME = "Renommer \"%s\"";
KHAOS_CONFIG_MENU_EXPORT = "Exporter \"%s\"";
KHAOS_CONFIG_MENU_HELP = "Aide";
KHAOS_CONFIG_MENU_SETTINGS = "Configuration des Options";
KHAOS_CONFIG_MENU_SETTINGS_DEFAULT = "Par D\195\169faut";
KHAOS_CONFIG_MENU_SETTINGS_CLASSES = "Classes";
KHAOS_CONFIG_MENU_SETTINGS_REALM = "Royaumes";
KHAOS_CONFIG_MENU_SETTINGS_CHARACTERS = "Personnages";
KHAOS_CONFIG_MENU_SETTINGS_HELP = "Cliquer pour avoir l\'aide";

-- Configuration Tooltips
KHAOS_CONFIG_TOOLTIP_DEFAULT = "(D\195\169faut)";
KHAOS_CONFIG_TOOLTIP_CLASSES = "Classes: ";
KHAOS_CONFIG_TOOLTIP_REALMS = "Royaume: ";
KHAOS_CONFIG_TOOLTIP_CHARACTERS = "Personnage: ";

-- Configuration Prompts
KHAOS_CONFIG_PROMPT_NEW_TEXT = "Entrer le nom de la nouvelle configuration.";
KHAOS_CONFIG_PROMPT_NEW_ACCEPT = "Cr\195\169er";
KHAOS_CONFIG_PROMPT_NEW_CANCEL = "Annuler";

KHAOS_CONFIG_PROMPT_DELETE_TEXT = "Effacement D\195\169finitif\n\"%s\"?";
KHAOS_CONFIG_PROMPT_DELETE_ACCEPT = "Supprimer";
KHAOS_CONFIG_PROMPT_DELETE_CANCEL = "Garder";

KHAOS_CONFIG_PROMPT_COPY_TEXT = "Copie des configurations\n\"%s\"?";
KHAOS_CONFIG_PROMPT_COPY_ACCEPT = "Copier";
KHAOS_CONFIG_PROMPT_COPY_CANCEL = "Annuler";

KHAOS_CONFIG_PROMPT_RENAME_TEXT = "Renommer la configuration\n\"%s\".\n Entrer le nom ci-dessous et pressez Renommer.";
KHAOS_CONFIG_PROMPT_RENAME_ACCEPT = "Renommer";
KHAOS_CONFIG_PROMPT_RENAME_CANCEL = "Annuler";

-- Import/Export Window
KHAOS_IMPORT = "Importer";
KHAOS_SELECTALL = "Tout s\195\169lectionner";
KHAOS_CLOSE = "Fermer";
KHAOS_EXPORT_MESSAGE = "Copiez le texte ici de votre Editeur.";
KHAOS_IMPORT_MESSAGE = "Collez le texte que vous avez obtenu \195\160 partir de \nla fen\195\170tre d\'exportation de Khaos et coller la exactement ici.\nAlors presser "..KHAOS_IMPORT.." pour l\'ajouter \195\160 votre liste de configuration.";
KHAOS_IMPORT_ERROR_MESSAGE = "S\'il vous plait, collez le texte que vous avez obtenu \195\160 partir de \nla fen\195\170tre d\'exportation de Khaos et coller la exactement ici.\nAlors presser "..KHAOS_IMPORT.." pour l\'ajouter \195\160 votre liste de configuration.";

-- Khaos Enabled List
KHAOS_FOLDER_ADDONS = "AddOns";
KHAOS_ENABLER_TITLE = "Liste tous les AddOns";
KHAOS_ENABLER_TOOLTIP = "Active/D\195\169sactive les AddOns";

KHAOS_ENABLE_UNLOADABLE = "%s Activ\195\169. Relancer votre UI pour activer les changements. < /script reloadui ou /rl >";
KHAOS_ENABLE_LOADABLE = "%s est activ\195\169. Cet addon peut \195\170tre lanc\195\169 dynamiquement. Aller dans la section D\195\169chargement de Khaos et v\195\169rifier la boite pour la charger maintenant.";
KHAOS_ENABLE_ALREADY = "%s est d\195\169j\195\162 activ\195\169.";
KHAOS_ENABLE_DISABLE = "%s est d\195\169sactiv\195\169. Ne devrait pas prendre effet tant que l\'UI n\'a pas \195\169t\195\169 relanc\195\169.";

KHAOS_ENABLER_DEPENDENCIES = "D\195\169pendences:\n";

-- Khaos AddOn Loader
KHAOS_LOADER_TITLE = "D\195\169charger";
KHAOS_LOADER_TOOLTIP = "AddOns qui ne sont pas actuellement charg\195\169s.";
KHAOS_LOADING_MESSAGE = "Chargement de %s ! dans %d secondes.";
KHAOS_LOADED_MESSAGE = "%s charg\195\169.";
KHAOS_NOTLOADED_MESSAGE = "Impossible de charger %s. Raison: %s";

-- Default Folder
KHAOS_FOLDER_DEFAULT = "Autres";
KHAOS_FOLDER_DEFAULT_HELP = "AddOns Divers";

KHAOS_FOLDER_BARS = "Barres";
KHAOS_FOLDER_BARS_HELP = "AddOns de Modification De Barres ";

KHAOS_FOLDER_CHAT = "Chat";
KHAOS_FOLDER_CHAT_HELP = "Options qui affectent la fen\195\170tre de Chat.";

KHAOS_FOLDER_COMBAT = "Combat";
KHAOS_FOLDER_COMBAT_HELP = "AddOns d\'Aide au Combat";

KHAOS_FOLDER_CLASS = "Classes";
KHAOS_FOLDER_CLASS_HELP = "AddOns par Classes";

KHAOS_FOLDER_COMM = "Communication";
KHAOS_FOLDER_COMM_HELP = "Options des AddOns de Communications";

KHAOS_FOLDER_FRAMES = "Fen\195\170tre";
KHAOS_FOLDER_FRAMES_HELP = "Organisation et Configuration des Fen\195\170tres";

KHAOS_FOLDER_INVENTORY = "Inventaire";
KHAOS_FOLDER_INVENTORY_HELP = "Sacs, Banques et Objets";

KHAOS_FOLDER_QUEST = "Qu\195\170tes";
KHAOS_FOLDER_QUEST_HELP = "Options des AddOns de Qu\195\170tes";

KHAOS_FOLDER_SOCIAL = "Social";
KHAOS_FOLDER_SOCIAL_HELP = "Addons de recherche sociale";

KHAOS_FOLDER_TOOLTIP = "Bulles d\'Aide";
KHAOS_FOLDER_TOOLTIP_HELP = "Options des AddOns pour les Bulles d\'Aide";

KHAOS_FOLDER_DEBUG = "Debug";
KHAOS_FOLDER_DEBUG_HELP = "Outils de Debugage";

KHAOS_FOLDER_MAPS = "Maps";
KHAOS_FOLDER_MAPS_HELP = "Configuration du Royaume & de la Minimap";

KHAOS_HELP_TIP = "Clic Gauche sur le carr\195\169 gauche pour acc\195\169der aux options de configuration.\nClic Gauche sur le carr\195\169 central pour acc\195\169der au Menu. \nPasser la Souris sur les Options pour voir la description. \n";

end
