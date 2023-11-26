-- Version : French ( by Elzix, Sasmira )
-- Last Update : 03/22/2005

if ( GetLocale() == "frFR" ) then

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>

BINDING_HEADER_TOTEMSTOMPER = "Totem Stomper";
	
BINDING_NAME_TOTEMSET1 	= "Pose les totems du groupe A";
BINDING_NAME_TOTEMSET2 	= "Pose les totems du groupe B";
BINDING_NAME_TOTEMSET3 	= "Pose les totems du groupe C";
BINDING_NAME_TOTEMSET4 	= "Pose les totems du groupe D";
BINDING_NAME_TOTEMSET5 	= "Pose les totems du groupe E";

BINDING_NAME_TOTEMSHOW 	= "Afficher/Masquer Totem Stomper";
	
-- <= == == == == == == == == == == == == =>
-- => Cosmos Settings
-- <= == == == == == == == == == == == == =>
COS_TS_SEPARATOR_TEXT 	= "Totem Stomper";
COS_TS_SEPARATOR_INFO 	= "Totem Stomper permet a un Chaman de poser diff\195\169rents totems en un seul clic.";
COS_TS_ENABLE_TEXT 	= "Activer les raccourcis clavier de Totem Stomper";
COS_TS_ENABLE_INFO 	= "Permet d'activer Totem Stomper par le clavier.";
COS_TS_DELAY_TEXT 	= "Modifier le d\195\169lais de pose";
COS_TS_DELAY_INFO 	= "Permet de modifier le d\195\169lais entre chaque pose de groupe de totems. Par d\195\169faut le temps sera calcul\195\169 sur le temps de recharge des totems.";
-- <= == == == == == == == == == == == == =>
-- => International Language Code
-- <= == == == == == == == == == == == == =>

TOTEMSTOMPER_HELP 			= " Utiliser la commande /stomp A-E ou 1-5 (exemple: /stomp 2) pour poser ce groupe de totem. |cFFAA3333[Macro Only]|r";
TOTEMSTOMPER_INSTRUCTION 		= "D\195\169placer vos sorts de totem de votre Grimoire dans une case.\n Configurer le raccourci clavier quatre fois";
TOTEMSTOMPER_PARTY_INSTRUCTION 		= "Affiche les totems utilis\195\169s dans le groupe.\nLes emplacements resteront vide jusqu'\169\160 l\'utilisation d\'un groupe de totems.";
TOTEMSTOMPER_FULL_INSTRUCTIONS 		= "Utilisation:\nOuvrir l\'interface de TotemStomper depuis le menu de Cosmos, ouvrir votre livre de sort et d\195\169placer ( ou shift+clic ) les sorts de totems dans les diff\195\169rents emplacements du groupe \195\160 configurer. Ensuite ouvrir le panneau de raccourcis clavier et attribuer une touche pour les groupes de totems A-E. Appuyer sur la touche pr\195\169c\195\169demment configur\195\169e pour poser les totems du groupe correspondant. (Pour mieux comprendre le fonctionnement, ouvrir l\'interface de Totem Stomper et observer ce qui se passe quand une touche de raccourci est appuy\195\169e)\nPar d\195\169faut vous devrez attendre le d\195\169lais de recharge des totems pour reposer un groupe, d\195\169sactiver l\'option 'Attente' pour poser le groupe sans les totems non recharg\195\169s\nTotem Stomper peut \195\170tre inclue dans une macro par la commande /stomp."
TOTEMSTOMPER_TOTEMSHARE_INSTRUCTIONS 	= "Partage de totem:\nPartage le contenu de votre groupe de totem actif avec les joueurs de votre partie. Par des comparaisons de totems des joueurs, le joueur avec le meilleur totem d'un certain type aura sa couleur modifi\195\169e en vert, le joueurs utilisant des totems identiques et de m\195\170me niveaux seront affich\195\169s en rouge, et ceux utilisant des totems de niveaux inf\195\169rieurs seront en grise.\nCela fonctionnera uniquement si vous posez vos totems par la commande /stomp ou par les touches de raccourcis des groupes de totems.";
TOTEMSTOMPER_VERSION_TIP 		= "Par AlexYoshi";
TOTEMSTOMPER_VERSION 			= "1.0";
	
TOTEMSTOMPER_WAIT_TIP 			= "Activer l\'option pour attendre la recharge des totems avant de poser le groupe de totem";
TOTEMSTOMPER_SKIP_TIP 			= "Activer l\'option pour poser le groupe de totem sans attendre la recharge de tout les totems";

VERSIONLABEL 				= "Version";
RESET 					= "R\195\169initialiser";

VERSIONLABEL				= "Version";
RESET					= "R\195\169initialiser";

TOTEMSTOMPER_BUTTON_TITLE		= "Totem Stomper";
TOTEMSTOMPER_BUTTON_SUBTITLE		= "Configuration";
TOTEMSTOMPER_BUTTON_TIP			= "Totem Stomper permet \195\160 un Chaman de poser diff\195\169rents totems en un seul clic.";

end