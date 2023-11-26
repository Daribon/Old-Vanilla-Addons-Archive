-- Version : French (by Vjeux)
-- Last Update : 02/17/2005

if ( GetLocale() == "frFR" ) then

	-- <= == == == == == == == == == == == == =>
	-- => Bindings Names
	-- <= == == == == == == == == == == == == =>
	BINDING_NAME_ACTIONBUTTON1ALT = "Trigger action button 1 on next page";
	BINDING_NAME_ACTIONBUTTON2ALT = "Trigger action button 2 on next page";
	BINDING_NAME_ACTIONBUTTON3ALT = "Trigger action button 3 on next page";
	BINDING_NAME_ACTIONBUTTON4ALT = "Trigger action button 4 on next page";
	BINDING_NAME_ACTIONBUTTON5ALT = "Trigger action button 5 on next page";
	BINDING_NAME_ACTIONBUTTON6ALT = "Trigger action button 6 on next page";
	BINDING_NAME_ACTIONBUTTON7ALT = "Trigger action button 7 on next page";
	BINDING_NAME_ACTIONBUTTON8ALT = "Trigger action button 8 on next page";
	BINDING_NAME_ACTIONBUTTON9ALT = "Trigger action button 9 on next page";
	BINDING_NAME_ACTIONBUTTON10ALT		= "Trigger action button 10 on next page";
	BINDING_NAME_ACTIONBUTTON11ALT		= "Trigger action button 11 on next page";
	BINDING_NAME_ACTIONBUTTON12ALT		= "Trigger action button 12 on next page";

	BINDING_NAME_INSTANTACTIONBAR1 = "Aller � la Page 1";
	BINDING_NAME_INSTANTACTIONBAR2 = "Aller � la Page 2";
	BINDING_NAME_INSTANTACTIONBAR3 = "Aller � la Page 3";
	BINDING_NAME_INSTANTACTIONBAR4 = "Aller � la Page 4";
	BINDING_NAME_INSTANTACTIONBAR5 = "Aller � la Page 5";
	BINDING_NAME_INSTANTACTIONBAR6 = "Aller � la Page 6"; 

	BINDING_NAME_TOGGLECOSMOSFEATURES	= "Afficher les Fonctionnalit�s de Cosmos";
	BINDING_NAME_RELOADUI				= "Recharger l'Interface";

	-- <= == == == == == == == == == == == == =>
	-- => Global tags that appear in multiple places
	-- <= == == == == == == == == == == == == =>
	ALLIANCE					= "Alliance";
	HORDE						= "Horde";

	GLOBAL_AUCTION_TAG_L		= "ench�re";
	GLOBAL_AUCTION_TAG_C		= "Ench�re";

	GLOBAL_ZONE_TAG_L			= "zone";
	GLOBAL_ZONE_TAG_C			= "Zone";

	GLOBAL_ITEM_TAG_L			= "objet";
	GLOBAL_ITEM_TAG_C			= "Objet";

	GLOBAL_HELP_TAG_L			= "aide";
	GLOBAL_HELP_TAG_C			= "Aide";

	GLOBAL_REMOVE_TAG_L			= "enlever";
	GLOBAL_REMOVE_TAG_C			= "Enlever";

	GLOBAL_REFRESH_TAG_L		= "actualiser";
	GLOBAL_REFRESH_TAG_C		= "Actualiser";

	GLOBAL_RESET_TAG_L			= "reset";
	GLOBAL_RESET_TAG_C			= "Reset";

	GLOBAL_SORT_TAG_L			= "trier";
	GLOBAL_SORT_TAG_C			= "Trier";

	GLOBAL_CLEAR_TAG_L			= "effacer";
	GLOBAL_CLEAR_TAG_C			= "Effacer";

	GLOBAL_CANCEL_TAG_L			= "annuler";
	GLOBAL_CANCEL_TAG_C			= "Annuler";

	GLOBAL_EXIT_TAG_L			= "quitter";
	GLOBAL_EXIT_TAG_C			= "Quitter";

	GLOBAL_OK_TAG_C				= "OK";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos
	-- <= == == == == == == == == == == == == =>
	COSMOS_OPTIONS_TITLE		= "Cosmos Options";
	COSMOS_FEATURES_TOOLTIP		= "Cosmos";
	COSMOS_FEATURES_TITLE		= "Cosmos";

	-- <= == == == == == == == == == == == == =>
	-- => Cosmos Config
	-- <= == == == == == == == == == == == == =>
	COSMOS_CONFIG_SEP			= "Interface";
	COSMOS_CONFIG_SEP_INFO		= "Ici sont affich� toutes les options g�n�rales, ou concernant des points ne n�c�ssitant pas de cat�gories enti�res.";
	COSMOS_CONFIG_PLHPMPXP		= "Toujours afficher la vie, mana et exp�rience de votre personnage.";
	COSMOS_CONFIG_PLHPMPXP_INFO	= "Toujours afficher la vie, mana et exp�rience de votre personnage.\nIl vous faudra d�cocher cette case pour revenir dans le mode habituel.";
	COSMOS_CONFIG_PARTYHP		= "Toujours afficher la vie des membres de votre groupe.";
	COSMOS_CONFIG_PARTYHP_INFO	= "Toujours afficher la vie des membres de votre groupe.\nIl vous faudra d�cocher cette case pour revenir dans le mode habituel.";
	COSMOS_CONFIG_PARTYMANA		= "Toujours afficher la mana des membres de votre groupe";
	COSMOS_CONFIG_PARTYMANA_INFO	= "Toujours afficher la mana des membres de votre groupe.\nIl vous faudra d�cocher cette case pour revenir dans le mode habituel.";
	COSMOS_CONFIG_RELOCTT		= "Replacer la tooltip dans la coin inf�rieur droit.";
	COSMOS_CONFIG_RELOCTT_INFO	= "Si cette option est d�sactiv�e, la tooltip va �tre plac�e en haut de l'�cran.";
	COSMOS_CONFIG_RELOCTT_2M	= "Placer la tooltip sur le curseur.";
	COSMOS_CONFIG_RELOCTT_2M_INFO	= "Si cette option est activ�e, la tooltip va �tre plac�e sur le curseur.";
	COSMOS_CONFIG_RELOCTT_UBER	= "Replacer la SuperTooltip";
	COSMOS_CONFIG_RELOCTT_UBER_INFO = "Replace la SuperTooltip � sa position initiale. Elle affiche plus d'informations que la tooltip par d�faut.";
	COSMOS_CONFIG_DMGRED		= "Afficher le pourcentage de r�duction des dommages";
	COSMOS_CONFIG_DMGRED_INFO	= "Affiche dans la fen�tre de votre personnage le pourcentage de r�duction des dommages gr�ce � votre armure..";
	COSMOS_CONFIG_S2SELL		= "Utiliser la touche Shift pour vendre.";
	COSMOS_CONFIG_S2SELL_INFO	= "Avec cette options vous devrez maintenir le bouton shift activ� puis faire bouton droit pour vendre un objet.\nCela permet de ne pas vendre d'objets par erreur.";
	COSMOS_CONFIG_PARTYBUFF 	= "Cacher les buffs des membres de votre groupe.";
	COSMOS_CONFIG_PARTYBUFF_INFO= "Enl�ve les icones de buffs de l'avatar des membres de votre groupe si vous n'avez pas la souris dessus."
	COSMOS_BUTTON_COSMOS		= "Cosmos";
	COSMOS_BUTTON_COSMOS_SUB	= "Configuration";
	COSMOS_BUTTON_COSMOS_TIP	= "Configuration de Cosmos";
	COSMOS_BUTTON_BANK			= "Banque";
	COSMOS_BUTTON_BANK_SUB		= "Voir la Banque";
	COSMOS_BUTTON_BANK_TIP		= "Affiche la banque.\n Note: Vous ne pouvez pas utiliser les objets dans la banque.";
	COSMOS_CONFIG_QUESTSCROLL		= "Modifier la vitesse de d�filement des qu�tes.";
	COSMOS_CONFIG_QUESTSCROLL_INFO		= "Si cette option est activ�e, le d�filement du texte des qu�tes va �tre celui que vous avez d�fini.";
	COSMOS_CONFIG_QUESTSCROLL_CHARS		= "Caract�res";
	COSMOS_CONFIG_QUESTSCROLL_APPEND	= "C/s";
	COSMOS_CONFIG_MPP			= "Afficher la mana des membres de votre groupe en pourcentage.";
	COSMOS_CONFIG_MPP_INFO		= "Si cette option est activ�e vous verrez la mana des membres de votre groupe en pourcentage.";
	COSMOS_CONFIG_PETHP			= "Toujours afficher la vie de votre Pet";
	COSMOS_CONFIG_PETHP_INFO	= "Toujours afficher la vie de votre Pet.\nIl vous faudra d�cocher cette case pour revenir dans le mode habituel.";
	COSMOS_CONFIG_PETMANA		= "Toujours afficher l'humeur de votre Pet";
	COSMOS_CONFIG_PETMANA_INFO	= "Toujours afficher l'humeur de votre Pet.\nIl vous faudra d�cocher cette case pour revenir dans le mode habituel.";

	COSMOS_COMM				= {"/cosmos", "/cos"};
	COSMOS_DESC				= "/cosmos <joueur> - V�rifier si un joueur utilise Cosmos.";
	COSMOS_DONTHAVE			= "%s ne semble pas utiliser Cosmos.";
	COSMOS_HAVE				= "%s utilise Cosmos !";

	-- <= == == == == == == == == == == == == =>
	-- => Shapeshift Commands
	-- <= == == == == == == == == == == == == =>
	SHAPE_COMM1					= {"/pos", "/changepos", "/changeposture"};
	SHAPE_COMM1_INFO			= "Vous permet de changer de posture � partir du chat. Essayez /pos [battle|btl|def|bzrk] |cFF880088Note: Ne marche que dans les macros|r";
	SHAPE_COMM2					= {"/stealth"};
	SHAPE_COMM2_INFO			= "Vous permet de vous mettre invisible � partir du chat |c00880088Note: Ne marche que dans les macros|r";
	SHAPE_COMM3					= {"/forme", "/meta", "/metamorphose"};
	SHAPE_COMM3_INFO			= "Vous permet de vous m�tamorphoser � partir du chat. Essayez /forme [1-4|bear|seal|cat|travel] |cFF880088Note: Ne marche que dans les macros|r";

	-- <= == == == == == == == == == == == == =>
	-- => Language
	-- <= == == == == == == == == == == == == =>
	LANGUAGE_COMM				= {"/langage", "/lang"};
	LANGUAGE_COMM_INFO			= "Change le langage utilis� dans le chat";
	LANGUAGE_HELP1				= "Utilisation : /langage <langage>";
	LANGUAGE_HELP2				= "Langages connus :";
	LANGUAGE_NOWSPEAK			= "Vous parlez maintenant : %s";
	LANGUAGE_UNKNOWN			= "Langage \"%s\" inconnu !";

end