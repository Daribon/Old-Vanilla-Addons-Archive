--[[

	MonkeyBuddy:
	Helps you configure your MonkeyMods.
	
	Website:	http://wow.visualization.ca/
	Author:		Trentin (monkeymods@gmail.com)
	
	
	Contributors:
	Pkp
		- Some initial xml work.
		
	Grayhoof
		- I borrowed a lot of the techniques and some code used in the options
		frame of ScrollingCombatText. It was such an excellent implementation
		that I just had to use it.
	
	Juki
		- French translation

--]]


-- as good a place as any for default "constants"

-- English
MONKEYBUDDY_TITLE					= "MonkeyBuddy";
MONKEYBUDDY_VERSION					= "1.5";
MONKEYBUDDY_FRAME_TITLE				= MONKEYBUDDY_TITLE .. " v" .. MONKEYBUDDY_VERSION;
MONKEYBUDDY_DESCRIPTION				= "Helps you configure your MonkeyMods.";
MONKEYBUDDY_INFO_COLOUR				= "|cffffff00";
MONKEYBUDDY_LOADED_MSG				= MONKEYBUDDY_INFO_COLOUR .. MONKEYBUDDY_TITLE .. " v" .. MONKEYBUDDY_VERSION .. " loaded";

MONKEYBUDDY_TOOLTIP_CLOSE			= "Close";
MONKEYBUDDY_RESET_ALL				= "Reset All";
MONKEYBUDDY_RESET					= "Reset";

-- defs for MonkeyQuest
MONKEYBUDDY_QUEST_TITLE				= "MonkeyQuest";
MONKEYBUDDY_QUEST_OPEN				= "Open MonkeyQuest";
MONKEYBUDDY_QUEST_SHOWHIDDEN		= "Show hidden items";
MONKEYBUDDY_QUEST_USEOVERVIEWS		= "Use overviews when there's no objectives";
MONKEYBUDDY_QUEST_HIDEHEADERS		= "Hide zone headers if not showing hidden items";
MONKEYBUDDY_QUEST_HIDEBORDER		= "Hide the border";
MONKEYBUDDY_QUEST_GROWUP			= "Expand upwards";
MONKEYBUDDY_QUEST_SHOWNUMQUESTS		= "Show the number of quests";
MONKEYBUDDY_QUEST_LOCK				= "Lock the MonkeyQuest frame";
MONKEYBUDDY_QUEST_COLOURTITLEON		= "Colour the quest titles by difficulty";
MONKEYBUDDY_QUEST_HIDECOMPLETEDQUESTS	= "Hide completed quests";
MONKEYBUDDY_QUEST_HIDECOMPLETEDOBJECTIVES	= "Hide completed objectives";
MONKEYBUDDY_QUEST_SHOWTOOLTIPOBJECTIVES	= "Show objective completeness in tooltips";
MONKEYBUDDY_QUEST_ALLOWRIGHTCLICK	= "Allow right click to open MonkeyBuddy";
MONKEYBUDDY_QUEST_HIDETITLEBUTTONS	= "Hide the title buttons";


MONKEYBUDDY_QUEST_QUESTTITLECOLOUR			= "Quest Titles";
MONKEYBUDDY_QUEST_HEADEROPENCOLOUR			= "Open Zone Headers";
MONKEYBUDDY_QUEST_HEADERCLOSEDCOLOUR		= "Closed Zone Headers";
MONKEYBUDDY_QUEST_OVERVIEWCOLOUR			= "Quest Overviews";
MONKEYBUDDY_QUEST_SPECIALOBJECTIVECOLOUR	= "Special Objectives";
MONKEYBUDDY_QUEST_INITIALOBJECTIVECOLOUR	= "Objectives at 0%";
MONKEYBUDDY_QUEST_COMPLETEOBJECTIVECOLOUR	= "Objectives at 100%";

MONKEYBUDDY_QUEST_ALPHASLIDER				= "Frame Alpha";
MONKEYBUDDY_QUEST_WIDTHSLIDER				= "Frame Width";
MONKEYBUDDY_QUEST_FONTSLIDER				= "Font Size";

-- defs for MonkeySpeed
MONKEYBUDDY_SPEED_TITLE				= "MonkeySpeed";
MONKEYBUDDY_SPEED_OPEN				= "Open MonkeySpeed";
MONKEYBUDDY_SPEED_PERCENT			= "Show speed as a percent";
MONKEYBUDDY_SPEED_BAR				= "Show speed as a background colour";
MONKEYBUDDY_SPEED_LOCK				= "Lock the MonkeySpeed frame";

-- defs for MonkeyClock
MONKEYBUDDY_CLOCK_TITLE				= "MonkeyClock";
MONKEYBUDDY_CLOCK_OPEN				= "Open MonkeyClock";
MONKEYBUDDY_CLOCK_HIDEBORDER		= "Hide the border";
MONKEYBUDDY_CLOCK_USEMILITARYTIME	= "Use 24 hour clock";
MONKEYBUDDY_CLOCK_LOCK				= "Lock the MonkeyClock frame";

MONKEYBUDDY_CLOCK_MINUTESLIDER		= "Minute Offset";
MONKEYBUDDY_CLOCK_HOURSLIDER		= "Hour Offset";

-- bindings
BINDING_HEADER_MONKEYBUDDY 			= MONKEYBUDDY_TITLE;
BINDING_NAME_MONKEYBUDDY_OPEN 		= "Open/Close the config frame";

if ( GetLocale() == "frFR" ) then
    -- Traduit par Juki <Unskilled>
    
    MONKEYBUDDY_DESCRIPTION				= "Vous aide à configurer vos MonkeyMods.";
    MONKEYBUDDY_LOADED_MSG				= MONKEYBUDDY_INFO_COLOUR .. MONKEYBUDDY_TITLE .. " v" .. MONKEYBUDDY_VERSION .. " chargé";
    
    MONKEYBUDDY_TOOLTIP_CLOSE			= "Fermer";
    MONKEYBUDDY_RESET_ALL				= "Mettre tout à zero";
    MONKEYBUDDY_RESET					= "Mettre à zero";
    
    -- defs for MonkeyQuest
    MONKEYBUDDY_QUEST_TITLE				= "MonkeyQuest";
    MONKEYBUDDY_QUEST_OPEN				= "Ouvrir MonkeyQuest";
    MONKEYBUDDY_QUEST_SHOWHIDDEN		= "Montrer les quêtes cachées";
    MONKEYBUDDY_QUEST_USEOVERVIEWS		= "Utiliser la description quand il n'y a pas d'objectifs";
    MONKEYBUDDY_QUEST_HIDEHEADERS		= "Cacher les noms de zone";
    MONKEYBUDDY_QUEST_HIDEBORDER		= "Cacher les bords";
    MONKEYBUDDY_QUEST_GROWUP			= "Augmenter la fenêtre MonkeyQuest vers le haut";
    MONKEYBUDDY_QUEST_SHOWNUMQUESTS		= "Montrer le nombre de quêtes";
    MONKEYBUDDY_QUEST_LOCK				= "Bloquer la fenêtre MonkeyQuest";
    MONKEYBUDDY_QUEST_COLOURTITLEON		= "Colorer les titres de quêtes selon la difficulté";
    MONKEYBUDDY_QUEST_HIDECOMPLETEDQUESTS	= "Cacher les quêtes terminées";
    MONKEYBUDDY_QUEST_HIDECOMPLETEDOBJECTIVES	= "Cacher les objectifs terminés";
    
    
    MONKEYBUDDY_QUEST_QUESTTITLECOLOUR			= "Titres Quêtes";
    MONKEYBUDDY_QUEST_HEADEROPENCOLOUR			= "Nom de Zone Ouvert";
    MONKEYBUDDY_QUEST_HEADERCLOSEDCOLOUR		= "Nom de Zone Fermé";
    MONKEYBUDDY_QUEST_OVERVIEWCOLOUR			= "Descriptions Quêtes";
    MONKEYBUDDY_QUEST_SPECIALOBJECTIVECOLOUR	= "Objectifs Speciaux";
    MONKEYBUDDY_QUEST_INITIALOBJECTIVECOLOUR	= "Objectifs à 0%";
    MONKEYBUDDY_QUEST_COMPLETEOBJECTIVECOLOUR	= "Objectifs à 100%";
    
    MONKEYBUDDY_QUEST_ALPHASLIDER				= "Alpha Fenêtre";
    
    -- defs for MonkeySpeed
    MONKEYBUDDY_SPEED_TITLE				= "MonkeySpeed";
    MONKEYBUDDY_SPEED_OPEN				= "Ouvrir MonkeySpeed";
    MONKEYBUDDY_SPEED_PERCENT			= "Montrer la vitesse comme un pourcentage";
    MONKEYBUDDY_SPEED_BAR				= "Montrer la vitesse comme une couleur de fond";
    
    -- defs for MonkeyClock
    MONKEYBUDDY_CLOCK_TITLE				= "MonkeyClock";
    MONKEYBUDDY_CLOCK_OPEN				= "Ouvrir MonkeyClock";
    MONKEYBUDDY_CLOCK_HIDEBORDER		= "Cacher les bords";
    MONKEYBUDDY_CLOCK_USEMILITARYTIME	= "Utiliser le format 24 heures";
    
    MONKEYBUDDY_CLOCK_MINUTESLIDER		= "Réglage Minute";
    MONKEYBUDDY_CLOCK_HOURSLIDER		= "Réglage Heure";
    
    -- bindings
    BINDING_HEADER_MONKEYBUDDY 			= MONKEYBUDDY_TITLE;
    BINDING_NAME_MONKEYBUDDY_OPEN 		= "Ouvrir/Fermer la fenêtre de configuration";
    
end    
