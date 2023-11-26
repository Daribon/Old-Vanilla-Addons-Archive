--[[

	MonkeyBuddy:
	Helps you configure your MonkeyMods.
	
	Website:	http://wow.visualization.ca/
	Author:		Trentin (monkeymods@gmail.com)
	
	
	Contributors:
	Pkp
		- Some initial xml work.
		
	Grayhoof
		- I "borrowed" a lot of the techniques and some code used in the options
		frame of ScrollingCombatText. It was such an excellent implementation
		that I just had to use it.

--]]


-- as good a place as any for default "constants"

-- English
MONKEYBUDDY_TITLE					= "MonkeyBuddy";
MONKEYBUDDY_VERSION					= "1.3.1";
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


MONKEYBUDDY_QUEST_QUESTTITLECOLOUR			= "Quest Titles";
MONKEYBUDDY_QUEST_HEADEROPENCOLOUR			= "Open Zone Headers";
MONKEYBUDDY_QUEST_HEADERCLOSEDCOLOUR		= "Closed Zone Headers";
MONKEYBUDDY_QUEST_OVERVIEWCOLOUR			= "Quest Overviews";
MONKEYBUDDY_QUEST_SPECIALOBJECTIVECOLOUR	= "Special Objectives";
MONKEYBUDDY_QUEST_INITIALOBJECTIVECOLOUR	= "Objectives at 0%";
MONKEYBUDDY_QUEST_COMPLETEOBJECTIVECOLOUR	= "Objectives at 100%";

MONKEYBUDDY_QUEST_ALPHASLIDER				= "Frame Alpha";

-- defs for MonkeySpeed
MONKEYBUDDY_SPEED_TITLE				= "MonkeySpeed";
MONKEYBUDDY_SPEED_OPEN				= "Open MonkeySpeed";
MONKEYBUDDY_SPEED_PERCENT			= "Show speed as a percent";
MONKEYBUDDY_SPEED_BAR				= "Show speed as a background colour";

-- defs for MonkeyClock
MONKEYBUDDY_CLOCK_TITLE				= "MonkeyClock";
MONKEYBUDDY_CLOCK_OPEN				= "Open MonkeyClock";
MONKEYBUDDY_CLOCK_HIDEBORDER		= "Hide the border";
MONKEYBUDDY_CLOCK_USEMILITARYTIME	= "Use 24 hour clock";

MONKEYBUDDY_CLOCK_MINUTESLIDER		= "Minute Offset";
MONKEYBUDDY_CLOCK_HOURSLIDER		= "Hour Offset";

-- bindings
BINDING_HEADER_MONKEYBUDDY 			= MONKEYBUDDY_TITLE;
BINDING_NAME_MONKEYBUDDY_OPEN 		= "Open/Close the config frame";
