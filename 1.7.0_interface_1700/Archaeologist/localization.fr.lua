-- Version : French ( by Sasmira )
-- Last Update : 07/01/2005

if ( GetLocale() == "frFR" ) then

	PLAYER_GHOST 					= "Fant\195\180me";
	PLAYER_WISP 					= "Feu Follet";

	ARCHAEOLOGIST_CONFIG_SEP			= "Archaeologist";
	ARCHAEOLOGIST_CONFIG_SEP_INFO			= "Archaeologist Configuration de la Fen\195\170tre du Joueur";

-- <= == == == == == == == == == == == == =>
-- => Player Options
-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PLAYER_SEP			= "Configuration: Barres du Joueur";
	ARCHAEOLOGIST_CONFIG_PLAYER_SEP_INFO		= "Par D\195\169faut : toutes les valeurs visibles en passant la Souris dessus.";
			
	ARCHAEOLOGIST_CONFIG_PLAYERHP			= "Toujours voir la Vie";
	ARCHAEOLOGIST_CONFIG_PLAYERHP_INFO		= "Affiche les points de Vie dans la barre du joueur.";
	ARCHAEOLOGIST_CONFIG_PLAYERMP			= "Toujours voir la Mana";
	ARCHAEOLOGIST_CONFIG_PLAYERMP_INFO		= "Affiche les points de Mana dans la barre du joueur.";
	ARCHAEOLOGIST_CONFIG_PLAYERXP			= "Toujours voir l\'Exp\195\169rience";
	ARCHAEOLOGIST_CONFIG_PLAYERXP_INFO		= "Affiche les points d\'Exp\195\169rience dans la barre du joueur.";
	ARCHAEOLOGIST_CONFIG_PLAYERHPP			= "La Vie en Pourcentage";
	ARCHAEOLOGIST_CONFIG_PLAYERHPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PLAYERMPP			= "La Mana en Pourcentage";
	ARCHAEOLOGIST_CONFIG_PLAYERMPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PLAYERXPP			= "L\'Exp\195\169rience en Pourcentage";
	ARCHAEOLOGIST_CONFIG_PLAYERXPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE		= "Cacher le pr\195\169fixe : Vie";
	ARCHAEOLOGIST_CONFIG_PLAYERHPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Vie' dans la barre du joueur.";
	ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE		= "Cacher le pr\195\169fixe : Mana/Rage/Energie";
	ARCHAEOLOGIST_CONFIG_PLAYERMPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Mana/Rage/Energie' dans la barre du joueur.";
	ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE		= "Cacher le pr\195\169fixe : XP";
	ARCHAEOLOGIST_CONFIG_PLAYERXPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'XP' dans la barre du joueur.";
	ARCHAEOLOGIST_CONFIG_PLAYERCLASSICON		= "Icone de la Classe du Joueur";
	ARCHAEOLOGIST_CONFIG_PLAYERCLASSICON_INFO	= "Affiche l\icone de Classe dans la fen\195\170tre du Joueur.";


-- <= == == == == == == == == == == == == =>
-- => Party Options
-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PARTY_SEP			= "Configuration: Barres du Groupe";
	ARCHAEOLOGIST_CONFIG_PARTY_SEP_INFO		= "Par D\195\169faut : toutes les valeurs visibles en passant la Souris dessus.";

	ARCHAEOLOGIST_CONFIG_PARTYHP			= "Toujours voir la Vie";
	ARCHAEOLOGIST_CONFIG_PARTYHP_INFO		= "Affiche les points de Vie dans la barre du Groupe.";
	ARCHAEOLOGIST_CONFIG_PARTYMP			= "Toujours voir la Mana";
	ARCHAEOLOGIST_CONFIG_PARTYMP_INFO		= "Affiche les points de Mana dans la barre du Groupe.";
	ARCHAEOLOGIST_CONFIG_PARTYHPP			= "La Vie en Pourcentage";
	ARCHAEOLOGIST_CONFIG_PARTYHPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PARTYMPP			= "La Mana en Pourcentage";
	ARCHAEOLOGIST_CONFIG_PARTYMPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE		= "Cacher le pr\195\169fixe : Vie";
	ARCHAEOLOGIST_CONFIG_PARTYHPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Vie' dans la barre du Groupe.";
	ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE		= "Cacher le pr\195\169fixe : Mana/Rage/Energie";
	ARCHAEOLOGIST_CONFIG_PARTYMPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Mana/Rage/Energie' dans la barre du Groupe.";
	ARCHAEOLOGIST_CONFIG_PARTYCLASSICON			= "Icones des Classes du Groupe";
	ARCHAEOLOGIST_CONFIG_PARTYCLASSICON_INFO	= "Affiche les icones de Classes dans la fen\195\170tre de Groupe.";


-- <= == == == == == == == == == == == == =>
-- => Pet Options
-- <= == == == == == == == == == == == == =>
	ARCHAEOLOGIST_CONFIG_PET_SEP			= "Configuration: Barres du Familier";
	ARCHAEOLOGIST_CONFIG_PET_SEP_INFO		= "Par D\195\169faut : toutes les valeurs visibles en passant la Souris dessus.";

	ARCHAEOLOGIST_CONFIG_PETHP			= "Toujours voir la Vie.";
	ARCHAEOLOGIST_CONFIG_PETHP_INFO			= "Affiche les points de Vie dans la barre du Familier.";
	ARCHAEOLOGIST_CONFIG_PETMP			= "Toujours voir la Mana";
	ARCHAEOLOGIST_CONFIG_PETMP_INFO			= "Affiche les points de Mana dans la barre du Familier.";
	ARCHAEOLOGIST_CONFIG_PETHPP			= "La Vie en Pourcentage.";
	ARCHAEOLOGIST_CONFIG_PETHPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PETMPP			= "La Mana en Pourcentage.";
	ARCHAEOLOGIST_CONFIG_PETMPP_INFO		= "";
	ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE		= "Cacher le pr\195\169fixe : Vie";
	ARCHAEOLOGIST_CONFIG_PETHPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Vie' dans la barre du Familier.";
	ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE		= "Cacher le pr\195\169fixe : Mana/Rage/Energie";
	ARCHAEOLOGIST_CONFIG_PETMPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Mana/Rage/Energie' dans la barre du Familier.";

-- <= == == == == == == == == == == == == =>
-- => Target Options
-- <= == == == == == == == == == == == == =>
	
ARCHAEOLOGIST_CONFIG_TARGET_SEP			= "Configuration: Barres de la Cible";
ARCHAEOLOGIST_CONFIG_TARGET_SEP_INFO		= "Par D\195\169faut : toutes les valeurs visibles en passant la Souris dessus.";

ARCHAEOLOGIST_CONFIG_TARGETHP			= "Toujours voir la Vie ( En pourcentage seulement )";
ARCHAEOLOGIST_CONFIG_TARGETHP_INFO		= "Affiche les points de Vie dans la barre de la Cible.";
ARCHAEOLOGIST_CONFIG_TARGETMP			= "Toujours voir la Mana";
ARCHAEOLOGIST_CONFIG_TARGETMP_INFO		= "Affiche les points de Mana dans la barre de la Cible.";
ARCHAEOLOGIST_CONFIG_TARGETHPP			= "La Vie en Pourcentage";
ARCHAEOLOGIST_CONFIG_TARGETHPP_INFO		= "";
ARCHAEOLOGIST_CONFIG_TARGETMPP			= "La Mana en Pourcentage";
ARCHAEOLOGIST_CONFIG_TARGETMPP_INFO		= "";
ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE		= "Cacher le pr\195\169fixe : Vie";
ARCHAEOLOGIST_CONFIG_TARGETHPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Vie' dans la barre de la Cible.";
ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE		= "Cacher le pr\195\169fixe : Mana/Rage/Energie";
ARCHAEOLOGIST_CONFIG_TARGETMPJUSTVALUE_INFO	= "Cache le pr\195\169fixe 'Mana/Rage/Energie' dans la barre de la Cible.";
ARCHAEOLOGIST_CONFIG_TARGETCLASSICON		= "Icone de la Classe de la Cible";
ARCHAEOLOGIST_CONFIG_TARGETCLASSICON_INFO	= "Affiche l\icone de Classe dans la fen\195\170tre de Cible.";

-- <= == == == == == == == == == == == == =>
-- => Alternate Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP		= "Options Alternatives";
ARCHAEOLOGIST_CONFIG_ALTOPTS_SEP_INFO		= "Options Alternatives";

ARCHAEOLOGIST_CONFIG_HPCOLOR			= "Afficher les changements de couleur de la Barre de Vie";
ARCHAEOLOGIST_CONFIG_HPCOLOR_INFO		= "Affiche les changements de couleur de la Barre de Vie quand la Vie baisse.";

ARCHAEOLOGIST_CONFIG_DEBUFFALT			= "Position Alternative des D\195\169buffs";
ARCHAEOLOGIST_CONFIG_DEBUFFALT_INFO		= "Affiche les D\195\169buffs du Familier et du Groupe sous les Buffs.\nPar d\195\169faut les debuffs apparaissent \195\160 Droite de la Fen\195\170tre.";

ARCHAEOLOGIST_CONFIG_HPMPALT			= "Position Alternative du Texte";
ARCHAEOLOGIST_CONFIG_HPMPALT_INFO		= "Affiche tous les Points de Vie et Mana \195\160 l\'ext\195\169rieur de la barre.";

ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE		= "Taille du Texte Joueur/Cible.";
ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE_INFO = " ";
ARCHAEOLOGIST_CONFIG_HPMPLARGESIZE_SLIDERTEXT   = "Taille de la Police";

ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE		= "Taille du Texte Familier/Groupe";
ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE_INFO = " ";
ARCHAEOLOGIST_CONFIG_HPMPSMALLSIZE_SLIDERTEXT   = "Taille de la Police";

ARCHAEOLOGIST_CONFIG_MOBHEALTH			= "Utiliser MobHealth2 pour voir les PV de la Cible";
ARCHAEOLOGIST_CONFIG_MOBHEALTH_INFO		= "Cache le texte d\'origine de MobHealth2 et l\'emploie \195\160 la place du texte des Points de Vie de la \195\170tre de Cible.";

ARCHAEOLOGIST_CONFIG_CLASSPORTRAIT		= "Portrait des Classes";
ARCHAEOLOGIST_CONFIG_CLASSPORTRAIT_INFO = "Remplace le Portrait par l\'Icone de Classe.";

-- <= == == == == == == == == == == == == =>
-- => Party Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP		= "Configuration: Buff Du Groupe";
ARCHAEOLOGIST_CONFIG_PARTYBUFFS_SEP_INFO	= "Par D\195\169faut : Douze Duffs et Douze D\195\169buffs sont visibles.";

ARCHAEOLOGIST_CONFIG_PBUFFS			= "Cacher les Buffs";
ARCHAEOLOGIST_CONFIG_PBUFFS_INFO		= "Les Buffs du Groupe apparaissent en passant la Souris sur le portrait.";

ARCHAEOLOGIST_CONFIG_PBUFF_NUM			= "Nombre de Buffs";
ARCHAEOLOGIST_CONFIG_PBUFF_NUM_INFO		= "Affiche le nombre de Buffs du Groupe.";
ARCHAEOLOGIST_CONFIG_PBUFF_NUM_SLIDER_TEXT  	= "Buffs Visibles";

ARCHAEOLOGIST_CONFIG_PDEBUFFS			= "Cacher les D\195\169buffs";
ARCHAEOLOGIST_CONFIG_PDEBUFFS_INFO		= "Les D\195\169buffs du Groupe apparaissent en passant la Souris sur le portrait.";

ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM		= "Nombre de D\195\169buffs";
ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM_INFO		= "Affiche le nombre de Buffs du Groupe.";
ARCHAEOLOGIST_CONFIG_PDEBUFF_NUM_SLIDER_TEXT 	= "D\195\169buffs Visibles";

-- <= == == == == == == == == == == == == =>
-- => Pet Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP		= "Configuration: Buff du Familier";
ARCHAEOLOGIST_CONFIG_PETBUFFS_SEP_INFO		= "Par D\195\169faut : Douze Buffs et Douze D\195\169buffs sont visibles.";

ARCHAEOLOGIST_CONFIG_PTBUFFS			= "Cacher les Buffs";
ARCHAEOLOGIST_CONFIG_PTBUFFS_INFO		= "Les Buffs du Familier apparaissent en passant la Souris sur le portrait.";

ARCHAEOLOGIST_CONFIG_PTBUFFNUM			= "Nombre de Buffs";
ARCHAEOLOGIST_CONFIG_PTBUFFNUM_INFO		= "Affiche le nombre de Buffs du Familier";
ARCHAEOLOGIST_CONFIG_PTBUFFNUM_SLIDER_TEXT 	 = "Buffs Visibles";

ARCHAEOLOGIST_CONFIG_PTDEBUFFS			= "Cacher les D\195\169buffs";
ARCHAEOLOGIST_CONFIG_PTDEBUFFS_INFO		= "Les D\195\169buffs du Familier apparaissent en passant la Souris sur le portrait.";

ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM		= "Nombre de D\195\169buffs";
ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM_INFO		= "Affiche le nombre de Buffs du Familier.";
ARCHAEOLOGIST_CONFIG_PTDEBUFFNUM_SLIDER_TEXT 	= "D\195\169buffs Visibles";

-- <= == == == == == == == == == == == == =>
-- => Target Buff Options
-- <= == == == == == == == == == == == == =>

ARCHAEOLOGIST_CONFIG_TARGETBUFFS_SEP		= "Configuration: Buff de la Cible";
ARCHAEOLOGIST_CONFIG_TARGETBUFFS_SEP_INFO   	= "Par D\195\169faut : Huit Buffs et Huit D\195\169buffs sont visibles.";

ARCHAEOLOGIST_CONFIG_TBUFFS			= "Cacher les Buffs";
ARCHAEOLOGIST_CONFIG_TBUFFS_INFO		= "Cache les Buffs de la Cible.";

ARCHAEOLOGIST_CONFIG_TBUFFNUM			= "Nombre de Buffs";
ARCHAEOLOGIST_CONFIG_TBUFFNUM_INFO		= "Affiche le nombre de Buffs de la Cible.";
ARCHAEOLOGIST_CONFIG_TBUFFNUM_SLIDER_TEXT   	= "Buffs Visible";

ARCHAEOLOGIST_CONFIG_TDEBUFFS			= "Cacher les D\195\169buffs";
ARCHAEOLOGIST_CONFIG_TDEBUFFS_INFO		= "Cache les D\195\169buffs de la Cible.";

ARCHAEOLOGIST_CONFIG_TDEBUFFNUM			= "Nombre de D\195\169buffs";
ARCHAEOLOGIST_CONFIG_TDEBUFFNUM_INFO		= "Affiche le nombre de Buffs de la Cible.";
ARCHAEOLOGIST_CONFIG_TDEBUFFNUM_SLIDER_TEXT 	= "D\195\169buffs Visibles";

end