-- Version : French ( by Sasmira )
-- Last Update : 03/22/2005

if ( GetLocale() == "frFR" ) then

-- Binding Configuration
BINDING_HEADER_WEAPONBUTTONSHEADER			= "Options des Armes";
BINDING_NAME_WEAPONBUTTONS				= "Marche/Arr\195\170t des Options des Armes";
BINDING_NAME_WEAPONBUTTONS_CYCLE			= "Choix du Mode";

-- UltimateUI Configuration
WEAPONBUTTONS_CONFIG_HEADER				= "Options des Armes";
WEAPONBUTTONS_CONFIG_HEADER_INFO			= "Affiche les armes \195\169quip\195\169es sur le personnage.\nUn Clique droit sur la fen\195\170tre, bascule entre les modes d\'attaque Corps \195\160 Corps et Distance";

WEAPONBUTTONS_ENABLED					= "Activer les Options des Armes";
WEAPONBUTTONS_ENABLED_INFO				= "Affiche la fen\195\170tre des armes \195\169quip\195\169es sur le personnage.";

WEAPONBUTTONS_DISPLAY_TOOLTIPS				= "Afficher les bulles d\'aide";
WEAPONBUTTONS_DISPLAY_TOOLTIPS_INFO			= "Affiche les bulles d\'aide sur les armes \195\169quip\195\169es.";

WEAPONBUTTONS_LOCK_POSITION				= "Verrouiller la position actuelle";
WEAPONBUTTONS_LOCK_POSITION_INFO			= "Interdit le d\195\169placement de la fen\195\170tre.";

WEAPONBUTTONS_RESET					= "R\195\169initialiser la position";
WEAPONBUTTONS_RESET_INFO				= "R\195\169initialisation \195\160 la position par d\195\169faut \ndans le cas ou la fen\195\170tre disparait de l\'ecran.";
WEAPONBUTTONS_RESET_NAME				= "R\195\169initialisation";

WEAPONBUTTONS_DEFAULT_MODE				= "S\195\169lection du Mode par d\195\169faut";
WEAPONBUTTONS_DEFAULT_MODE_INFO				= "Choix du Mode S\195\169lectionn\195\169 :.";
WEAPONBUTTONS_DEFAULT_MODE_APPEND			= "";

-- Chat Configuration
WEAPONBUTTONS_CHAT_COMMAND_INFO				= "Controle des Options des Armes par ligne de commandes. Utiliser /weaponbutton pour plus de d\169\169tails.";
WEAPONBUTTONS_CHAT_COMMAND_USAGE			= "Utilisation : /weaponbutton <show/tooltips/lock/mode> [on/off/toggle]\nCommandes :\n show - d\195\169termine la visibilit\195\169 de la fen\195\170tre\n tooltips - Affiche la bulle d\'aide lors du passage de la Souris\n lock - Verrouille la fen\195\170tre\n mode - S\195\169lection du mode par d\195\169faut  Corps \195\160 Corps ou Distance\n togglemode - Marche/Arr\195\170t de la S\195\169lection par d\195\169faut";

WEAPONBUTTONS_CHAT_ENABLED				= "Options des Armes activ\195\169es.";
WEAPONBUTTONS_CHAT_DISABLED				= "Options des Armes d\195\169activ\195\169es.";
WEAPONBUTTONS_CHAT_COMMAND_ENABLE_INFO			= "Activer/d\195\169activer les Options des Armes.";

WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_ENABLED		= "Affichage des bulles d\'aide dans les Options des Armes activ\195\169es.";
WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_DISABLED		= "Affichage des bulles d\'aide dans les Options des Armes d\195\169activ\195\169es.";
WEAPONBUTTONS_CHAT_COMMAND_DISPLAY_TOOLTIPS_INFO	= "Activer/d\195\169activer des bulles d\'aide dans les Options des Armes quand vous passez la Souris dessus.";

WEAPONBUTTONS_CHAT_LOCK_POSITION_ENABLED		= "Verrouillage de la fen\195\170tre dans la position actuelle.";
WEAPONBUTTONS_CHAT_LOCK_POSITION_DISABLED		= "D\195\169verrouillage de la fen\195\170tre de sa position actuelle.";
WEAPONBUTTONS_CHAT_COMMAND_LOCK_POSITION_INFO		= "Verrouiller/D\195\169verrouiller la fen\195\170tre des Options des Armes de sa position actuelle.";

WEAPONBUTTONS_CHAT_COMMAND_RESET_INFO			= "R\195\169initialisation de la fen\195\170tre des Options des Armes \195\160 sa position d\'origine.";

WEAPONBUTTONS_CHAT_SETMODE				= "S\195\169lection des Options des armes \195\160 %s.";
WEAPONBUTTONS_CHAT_MODE_ILLEGAL				= "Choix Ill\195\169gal";
WEAPONBUTTONS_CHAT_MODE_MELEE				= "Corps \195\160 Corps";
WEAPONBUTTONS_CHAT_MODE_RANGED				= "Distance";
WEAPONBUTTONS_CHAT_MODE_TRINKETS			= "Bijou";

-- UltimateUI AddOn Mod Configuration
WEAPONBUTTONS_CONFIG_TRANSNUI				= "Transparence Options des Armes";
WEAPONBUTTONS_CONFIG_TRANSNUI_INFO			= "Permet de rentre plus ou moins transparente la fen\195\170tre Options des Armes";

WEAPONBUTTONS_CONFIG_POPNUI				= "Cacher auto. Options des Armes";
WEAPONBUTTONS_CONFIG_POPNUI_INFO			= "Affiche la fen\195\170tre Options des Armes lorsque vous passez la Souris dessus.";

-- Configuration Setup
WEAPONBUTTONS_CHAT_MODES = {
	WEAPONBUTTONS_CHAT_MODE_MELEE,
	WEAPONBUTTONS_CHAT_MODE_RANGED,
	WEAPONBUTTONS_CHAT_MODE_TRINKETS
};

end