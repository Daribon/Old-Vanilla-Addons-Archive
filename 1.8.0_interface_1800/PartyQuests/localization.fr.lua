-- Version : French ( by Sasmira )
-- Last Update : 08/08/2005

if ( GetLocale() == "frFR" ) then

PARTYQUESTS_COLOR = "|cFF009955Party|cFF995555Quests|r";
PARTYQUESTS_TITLE_TEXT 	= "Qu\195\170tes du groupe";
PARTYQUESTS_BUTTON_TEXT = "Groupe";
PARTYQUESTS_BUTTON_TOOTIP = "Affiche les Qu\195\170tes du groupe";
PARTYQUESTS_BUTTON_PARTY_TEXT = "Groupe";
PARTYQUESTS_BUTTON_ABANDON_TEXT = "Abandonner";
PARTYQUESTS_BUTTON_SHARE_TEXT = "Partager";
PARTYQUESTS_QUESTINFO_TEXT = "Journal des Qu\195\170tes";
PARTYQUESTS_ALLQUESTS = "Toutes les Qu\195\170tes";
PARTYQUESTS_BUTTON_SUBTEXT = "Partarger les Qu\195\170tes du groupe";
PARTYQUESTS_HELPTEXT = "Partarge de vos Qu\195\170tes avec votre groupe.";

BINDING_HEADER_PARTYQUESTS	= "Qu\195\170tes du groupe";
BINDING_NAME_TOGGLEPARTYQUESTS	= "Marche/Arr\195\170t Qu\195\170tes du groupe";

PARTYQUESTS_VERSION = "0.1";
PARTYQUESTS_VERSION_TIP = "Ecrit par :\n Marek Gorecki";
-- Exit!
GLOBAL_EXIT_TAG_C = "Fermer";

PARTYQUESTS_QUEST_TITLE = "\[%s\] %s";
PARTYQUESTS_QUEST_TITLE_TAG = "(%s)";
PARTYQUESTS_LOG_ID_TEMPLATE = "Qu\195\170tes: |cffffffff%d|r";

-- Menu
PARTYQUESTS_MENU_REFRESH 		= "Actualisation";
PARTYQUESTS_MENU_AUTOJOIN 		= "Joindre automatiquement SkyParty";
PARTYQUESTS_MENU_SHOWZONES 		= "Afficher les Zones";
PARTYQUESTS_MENU_SHOWLEVEL 		= "Afficher le niveau de la Qu\195\170te";
PARTYQUESTS_MENU_SHOWCOMPLETEDBANNER 	= "D\195\169rouler tous les menus";
PARTYQUESTS_MENU_SHOWDETAILEDTIP	= "Afficher les objectifs dans la bulle d\'aide";
PARTYQUESTS_MENU_SHOWINDENT		= "Enl\195\168ve l\'espacement devant le nom des qu\195\170tes";

-- Tabs
PARTYQUESTS_TAB_SELF	="Moi";
PARTYQUESTS_TAB_PARTY 	= "Groupe";

-- Types
PARTYQUESTS_SETTING_PLAYER = "Mon r\195\169glage de qu\195\170tes";
PARTYQUESTS_SETTING_COMMON = "R\195\169glage de qu\195\170tes communes";
PARTYQUESTS_SETTING_PARTY  = "R\195\169glage de qu\195\170tes\ du groupe";

-- Sorts
PARTYQUESTS_SORTING 	= "Trier";
PARTYQUESTS_SORT_LEVEL 	= "Par Niveau";
PARTYQUESTS_SORT_TITLE 	= "Par Titre";
PARTYQUESTS_SORT_ZONE 	= "Par Zone";

-- Notices
PARTYQUESTS_QUESTSTATUS_WAITING 	= "Requ\195\170te d\'information de qu\195\170te de %s.";
PARTYQUESTS_QUESTSTATUS_FAILED 		= "%s n\'a plus cette qu\195\170te.";
PARTYQUESTS_LOCATINGPARTYMEMBERS 	= "Fait la liste des membres de votre groupe...";
PARTYQUESTS_NOPARTYMEMBERS 		= "Vous n\'\195\170tes pas membre d\'un groupe.";

-- Waiting
PARTYQUESTS_WAITING_0 = " Requ\195\170te en attente";
PARTYQUESTS_WAITING_1 = ". Requ\195\170te en attente";
PARTYQUESTS_WAITING_2 = ".. Requ\195\170te en attente";
PARTYQUESTS_WAITING_3 = "... Requ\195\170te en attente";

-- Building
PARTYQUESTS_BUILDING_0 = " Construction"; 
PARTYQUESTS_BUILDING_1 = ". Construction"; 
PARTYQUESTS_BUILDING_2 = ".. Construction"; 
PARTYQUESTS_BUILDING_3 = "... Construction"; 

-- Failed
PARTYQUESTS_FAILED_TEXT 	= "|cFFDD3333(Echou\195\169)|r";
PARTYQUESTS_NOTSKYUSER_TEXT 	= "|cFF444433(Non utilisateur de Sky)|r";

-- Bad Channel
PARTYQUESTS_NEED_TO_JOIN_SKY_PARTY = PARTYQUESTS_COLOR..": Impossible de d\195\169tecter le canal de discussion "..SKY_PARTY_COLOR..". S\'il vous plait, taper /join SkyParty pour utiliser Qu\195\170tes du Groupe. Vous devez quitter un autre canal pour joindre celui-ci. ";

-- PartyQuests
PARTYQUESTS_HELP_TIP = "Clic Droit sur le Nom de la Qu\195\170te\nPour faire apparaitre le menu des Options.";

-- Format strings: 
PQ_OBJCOMPLETED					= "L\'objectif de Qu\195\170te de %s est compl\195\169t\195\169 %s";
PQ_QPROGRESS					= "Progression de %s dans la Qu\195\170te... %s";
PQ_XHASCOMPLETED				= "%s a termin\195\169 %s!";
PQ_YOUHAVECOMPLETED				= "Vous avez termin\195\169 %s!";
PQ_QUEST_LEVEL					= " ( Niveau de la qu\195\170te %d )";
PQ_FILTERS					= "Filtres";
PQ_COMMONQUESTS					= "Qu\195\170tes Communes";
PQ_MYQUESTREFRESH				= "Mes qu\195\170tes ( Actualisation de la Liste... )";
PQ_MYQUEST					= "Mes qu\195\170tes";
PQ_XQUESTS					= "Qu\195\170tes de %s";
PQ_PARTYCOMPLETED				= "Le groupe a termin\195\169 %s!";
PQ_QSQUEST					= "- Qu\195\170tes du Groupe -\n%s";
PQ_XOBJ						= "|cFF000088%s's objectifs:|r";
PQ_NBOBJ					= "%d Objectif(s):";
PQ_WHOELSE					= "Qui a cette qu\195\170te :";
PQ_STNOCOMPLETED				= "%s\n%d termin\195\169 cette qu\195\170te.";
PQ_STNOONECOMPLETED				= "%s\nPersonne a termin\195\169 cette qu\195\170te.";
PQ_STALLCOMPLETED				= "%s\nTout le monde a termin\195\169 cette qu\195\170te.";
PQ_STXCOMPLETED					= "%s\n%d a termin\195\169 cette qu\195\170te.";
PQ_NUMQUESTS					= "%d qu\195\170tes";
PQ_REQUESTING					= "( Requ\195\170te... )";

PQ_SHOWXQUESTS					= "Voir %s\'s qu\195\170tes";
PQ_SHOWLOCQUESTS				= "Voir %s qu\195\170tes";

-- Checkboxes --
PQ_FILTER_PROGNOTICES		= "Notices de progression de la qu\195\170te du groupe :";
PQ_FILTER_PROGNOTICES_QUECOMP	= "Notification quand les qu\195\170tes sont compl\195\168tes";
PQ_FILTER_PROGNOTICES_OBJCOMP	= "Notification quand les objectifs sont complets";
PQ_FILTER_PROGNOTICES_OBJPROG	= "Notification dans la progression des objets/morts";

-- Option regs
PQ_REPLACE_TEXT = "Remplace le journal par d\195\169faut des Qu\195\170tes ";
PQ_REPLACE_HELPTEXT = "Afficher les Qu\195\170tes du groupe lorsque vous cliquez sur les boutons du Journal des Qu\195\170tes.";
PQ_REPLACE_FEEDBACK_TRUE = "le journal normal des Qu\195\170tes a \195\169t\195\169 remplac\195\169.";
PQ_REPLACE_FEEDBACK_FALSE = "le journal normal des Qu\195\170tes est de retour.";

end