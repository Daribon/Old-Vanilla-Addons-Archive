-- Version : French ( Elzix, Sasmira )
-- Last Update : 03/23/2005

if ( GetLocale() == "frFR" ) then

-- Binding Configuration
	BINDING_HEADER_POPBARHEADER			= "Barre Apparente (lign/Col)";
	BINDING_NAME_TOGGLEPOPBAR			= "Marche/Arr\195\170t Barre Apparente";

-- Cosmos Configuration
	POPBAR_BINDING_BUTTON 				= "Barre Apparente";
	POPBAR_CONFIG_HEADER				= "Barre Apparente"
	POPBAR_CONFIG_HEADER_INFO			= "Ces options configurent la Barre Apparente.";
	POPBAR_CONFIG_ONOFF				= "Marche/Arr\195\170 Barre Apparente";
	POPBAR_CONFIG_ONOFF_INFO			= "Si activ\195\169, La Barre Apparente sera affich\195\169e.";
	POPBAR_CONFIG_PAGES				= "Tourner les pages"
	POPBAR_CONFIG_PAGES_INFO			= "Si activ\195\169, la Barre Apparente changera de page en m\195\170me temps que la barre principale."
	POPBAR_CONFIG_HIDEEMPTY				= "Cacher les boutons vides";
	POPBAR_CONFIG_HIDEEMPTY_INFO			= "Si activ\195\169, n\'affiche pas les emplacements vide dans la Barre Apparente";
	POPBAR_CONFIG_HIDEKEYS				= "Cacher les raccourcis clavier";
	POPBAR_CONFIG_HIDEKEYS_INFO			= "Si activ\195\169, les raccourcis clavier des boutons ne seront pas affich\195\169s.";
	POPBAR_CONFIG_HIDEKEYMOD			= "Cacher les combinaisons de touches";
	POPBAR_CONFIG_HIDEKEYMOD_INFO			= "Si activ\195\169, les raccourcis associ\195\169s ne seront pas affich\195\169s, exemple 'ALT-1' sera affich\195\169 simplement '1'";
	POPBAR_CONFIG_ORIENT				= "Barre \195\160 Horizontale";
	POPBAR_CONFIG_ORIENT_INFO			= "Si activ\195\169, la Barre Apparente sera affich\195\169e comme une barre de cot\195\169.";
	POPBAR_CONFIG_AREA				= "Affichage automatique";
	POPBAR_CONFIG_AREA_INFO				= "Rend la Barre Apparente visible quand vous passez la Souris dessus.";
	POPBAR_CONFIG_HANCHOR				= "Placer \195\160  droite";
	POPBAR_CONFIG_HANCHOR_INFO			= "Si activ\195\169, la Barre Apparente s'ouvrira \195\160 partir de la droite (au lieu de la gauche).";
	POPBAR_CONFIG_VANCHOR				= "Placer en haut";
	POPBAR_CONFIG_VANCHOR_INFO			= "Si activ\195\169, la Barre Apparente s\'ouvrira \195\160 partir du haut (au lieu du bas).";
	POPBAR_CONFIG_POPTIME				= "D\195\169lais d\'apparition";
	POPBAR_CONFIG_POPTIME_INFO			= "D\195\169lais d\'apparition de la Barre Apparente lorsque vous laissez la Souris dessus.";
	POPBAR_CONFIG_POPTIME_NAME			= "D\195\169lais d\'apparition";
	POPBAR_CONFIG_POPTIME_SUFFIX			= " seconde(s)";
	POPBAR_CONFIG_KNOBALPHA				= "Opacit\195\169 des Butons";
	POPBAR_CONFIG_KNOBALPHA_INFO			= "Modifie l\'opacit\195\169/la transparence des boutons";
	POPBAR_CONFIG_KNOBALPHA_NAME			= "Opacit\195\169";
	POPBAR_CONFIG_KNOBALPHA_SUFFIX			= "%";
	POPBAR_CONFIG_BARALPHA				= "Opacit\195\169 de la barre";
	POPBAR_CONFIG_BARALPHA_INFO			= "Modifie l\'opacit\195\169/la transparence de la barre.";
	POPBAR_CONFIG_BARALPHA_NAME			= "Opacit\195\169";
	POPBAR_CONFIG_BARALPHA_SUFFIX			= "%";
	POPBAR_CONFIG_ROWS				= "Nombre de lignes";
	POPBAR_CONFIG_ROWS_INFO				= "Nombre de ligne de la Barre Apparente, entre 1 et 12.";
	POPBAR_CONFIG_ROWS_NAME				= "Lignes";
	POPBAR_CONFIG_ROWS_SUFFIX			= " ligne(s)";
	POPBAR_CONFIG_COLS				= "Nombre de colonnes";
	POPBAR_CONFIG_COLS_INFO				= "Nombre de colonnes de la Barre Apparente, entre 1 et 12.";
	POPBAR_CONFIG_COLS_NAME				= "Colonnes";
	POPBAR_CONFIG_COLS_SUFFIX			= " colonne(s)";
	POPBAR_CONFIG_ROWSHOW				= "Lignes permanentes affich\195\169es";
	POPBAR_CONFIG_ROWSHOW_INFO			= "Nombre de lignes qui doivent toujours \195\170tres visibles.";
	POPBAR_CONFIG_ROWSHOW_NAME			= "Lignes";
	POPBAR_CONFIG_ROWSHOW_SUFFIX			= " ligne(s)";
	POPBAR_CONFIG_COLSHOW				= "Colonnes permanentes affich\195\169es";
	POPBAR_CONFIG_COLSHOW_INFO			= "Nombre de colonnes qui doivent toujours \195\170tres visibles.";
	POPBAR_CONFIG_COLSHOW_NAME			= "Colonnes";
	POPBAR_CONFIG_COLSHOW_SUFFIX			= " colonne(s)";
	POPBAR_CONFIG_RESET				= "Position par d\195\169faut";
	POPBAR_CONFIG_RESET_INFO			= "D\195\169place la Barre Apparente dans sa position d\'origine.";
	POPBAR_CONFIG_RESET_NAME			= "R\195\69initialiser";
	POPBAR_CONFIG_IDUP				= "Ordre des num\195\169ros des boutons";
	POPBAR_CONFIG_IDUP_INFO				= "Si activ\195\169, le num\195\169ro des boutons sera invers\195\169.";
	POPBAR_CONFIG_FLIPH				= "Inverser l\'axe horizontal";
	POPBAR_CONFIG_FLIPH_INFO			= "Inverse l\'ordre horizontal des boutons.";
	POPBAR_CONFIG_FLIPV				= "Inverser l\'axe vertical";
	POPBAR_CONFIG_FLIPV_INFO			= "Inverse l\'ordre vertical des boutons.";
	POPBAR_CONFIG_STARTPAGE				= "Num\195\169ro de la page de d\195\169part";
	POPBAR_CONFIG_STARTPAGE_INFO			= "Change la page utilis\195\169e en premier pour les boutons de la Barre Apparente.";
	POPBAR_CONFIG_STARTPAGE_NAME			= "Num\195\169ro de page";
	POPBAR_CONFIG_STARTPAGE_SUFFIX			= "";
	POPBAR_CONFIG_STARTBUTTON			= "Num\195\169ro du bouton de d\195\169part";
	POPBAR_CONFIG_STARTBUTTON_INFO			= "Change le num\195\169ro du premier bouton.";
	POPBAR_CONFIG_STARTBUTTON_NAME			= "Num\195\169ro du bouton";
	POPBAR_CONFIG_STARTBUTTON_SUFFIX		= "";

-- Chat Configuration
POPBAR_CHAT_COMMAND_INFO		= "Utiliser la commande /pb ou /popbar pour les d\195\169tails d\'utilisation.";
POPBAR_CHAT_COMMAND_HELP		= {};
POPBAR_CHAT_COMMAND_HELP[1]		= "Toutes les commandes peuvent \195\170tre lanc\195\169es par /pb ou /popbar exemple : /pb enable or /popbar enable";
POPBAR_CHAT_COMMAND_HELP[2]		= "Vous pouvez ON/OFF, ou donner le nombre de lignes que vous souhaitez exemple.";
POPBAR_CHAT_COMMAND_HELP[3]		= "/pb enable on";
POPBAR_CHAT_COMMAND_HELP[4]		= "/pb enable off";
POPBAR_CHAT_COMMAND_HELP[5]		= "/pb rows 2";
POPBAR_CHAT_COMMAND_HELP[6]		= "Si c'est d\195\169j\195\60 ON et si vous passer en ON/OFF cela fera l\'effet inverse, si c\'est ON cela passera en OFF, si c\'est OFF cela passera en ON.\n";
POPBAR_CHAT_COMMAND_HELP[7]		= "enable - 'Marche/Arr\195\170 Barre Apparente, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[8]		= "pages - 'Set whether or not Barre Apparente changed buttons when the main bar does, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[9]		= "hideempty - 'Cache les emplacements vides, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[10]		= "hidekeys - 'N\'affiche pas les raccourcis sur les boutons, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[11]		= "hidekeymod - 'Affiche les raccourcis modifi\195\169s sur les boutons, ex. 'ALT-1' vous verrez '1', ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[12]		= "rows - 'Affiche le nombre de lignes'";
POPBAR_CHAT_COMMAND_HELP[13]		= "cols - 'Affiche le nombre de colones'";
POPBAR_CHAT_COMMAND_HELP[14]		= "area - 'Affiche la Barre Apparente visible quand vous passez la Souris dessus, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[15]		= "vanchor - 'la Barre Apparente s\'ouvrira \195\160 partir du haut ou du bas'";
POPBAR_CHAT_COMMAND_HELP[16]		= "hanchor - 'la Barre Apparente s'ouvrira \195\160 partir de la droite ou de la gauche'";
POPBAR_CHAT_COMMAND_HELP[17]		= "srows - 'Nombre de lignes toujours visible'";
POPBAR_CHAT_COMMAND_HELP[18]		= "scols - 'Nombre de colones toujours visible'";
POPBAR_CHAT_COMMAND_HELP[19]		= "orient - 'Orientation de la barre, h pour horizontal, v pour vertical ( par d\195\169faut )'";
POPBAR_CHAT_COMMAND_HELP[20]		= "knobalpha - 'Transparence des boutons, variable entre 0.00 to 1.00'";
POPBAR_CHAT_COMMAND_HELP[21]		= "alpha - 'Transparence de la barre, variable entre 0.00 to 1.00'";
POPBAR_CHAT_COMMAND_HELP[22]		= "idup - 'le num\195\169ro des boutons sera invers\195\169, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[23]		= "fliph - 'Inverse l\'ordre horizontal des boutons, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[24]		= "flipv - 'Inverse l\'ordre vertical des boutons, ON/OFF'";
POPBAR_CHAT_COMMAND_HELP[25]		= "startpage - 'Change la page utilis\195\169e en premier pour les boutons.'";
POPBAR_CHAT_COMMAND_HELP[26]		= "startbut - 'Change le num\195\169ro du premier bouton.'";
POPBAR_CHAT_COMMAND_HELP[27]		= "reset - 'R\195\169initialise l\'emplacement \195\160 son emplacement par d\195\169faut.'";

end