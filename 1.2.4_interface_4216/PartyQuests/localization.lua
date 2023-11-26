--
--	Party Quest Localization
--	 English by Alexander
--

PARTYQUESTS_COLOR = "|cFF009955Party|cFF995555Quests|r";
PARTYQUESTS_TITLE_TEXT 	= "Party Quests";
PARTYQUESTS_BUTTON_TEXT = "Party";
PARTYQUESTS_BUTTON_TOOTIP = "View Party Quests";
PARTYQUESTS_BUTTON_PARTY_TEXT = "Party";
PARTYQUESTS_BUTTON_ABANDON_TEXT = "Abandon";
PARTYQUESTS_BUTTON_SHARE_TEXT = "Share";
PARTYQUESTS_QUESTINFO_TEXT = "Quest Log";
PARTYQUESTS_ALLQUESTS = "All Quests";
PARTYQUESTS_BUTTON_SUBTEXT = "Share Party Quests";

BINDING_HEADER_PARTYQUESTS	= "Party Quests Keys";
BINDING_NAME_TOGGLEPARTYQUESTS	= "Toggle Party Quests";

PARTYQUESTS_VERSION = "0.1";
PARTYQUESTS_VERSION_TIP = "Written By:\n Marek Gorecki";
-- Exit!
GLOBAL_EXIT_TAG_C = "Exit";

PARTYQUESTS_QUEST_TITLE = "\[%s\] %s";
PARTYQUESTS_QUEST_TITLE_TAG = "(%s)";
PARTYQUESTS_LOG_ID_TEMPLATE = "Quest ID: |cffffffff%d|r";

-- Menu
PARTYQUESTS_MENU_REFRESH = "Refresh";
PARTYQUESTS_MENU_SHOWZONES = "Show Zones";
PARTYQUESTS_MENU_SHOWLEVEL = "Show Quest Level";
PARTYQUESTS_MENU_SHOWCOMPLETEDBANNER = "Show Completed Banner";
PARTYQUESTS_MENU_SHOWDETAILEDTIP = "Show Objective Tooltips";
PARTYQUESTS_MENU_SHOWINDENT= "Remove Quest Indent";

-- Tabs
PARTYQUESTS_TAB_SELF ="Self";
PARTYQUESTS_TAB_PARTY = "Party";

-- Types
PARTYQUESTS_SETTING_PLAYER = "My Quest Settings";
PARTYQUESTS_SETTING_COMMON = "Common Quest Settings";
PARTYQUESTS_SETTING_PARTY  = "Party Quest Settings";

-- Sorts
PARTYQUESTS_SORTING = "Sorting";
PARTYQUESTS_SORT_LEVEL = "Sort by level";
PARTYQUESTS_SORT_TITLE = "Sort by title";
PARTYQUESTS_SORT_ZONE = "Sort by zone";

-- Notices
PARTYQUESTS_QUESTSTATUS_WAITING = "Requesting quest information from %s.";
PARTYQUESTS_QUESTSTATUS_FAILED = "%s does not have this quest anymore.";
PARTYQUESTS_LOCATINGPARTYMEMBERS = "Scanning your list for party members...";
PARTYQUESTS_NOPARTYMEMBERS = "You do not have any party members.";

-- Waiting
PARTYQUESTS_WAITING_0 = " Requesting";
PARTYQUESTS_WAITING_1 = ". Requesting";
PARTYQUESTS_WAITING_2 = ".. Requesting";
PARTYQUESTS_WAITING_3 = "... Requesting";

-- Building
PARTYQUESTS_BUILDING_0 = " Building"; 
PARTYQUESTS_BUILDING_1 = ". Building"; 
PARTYQUESTS_BUILDING_2 = ".. Building"; 
PARTYQUESTS_BUILDING_3 = "... Building"; 

-- Failed
PARTYQUESTS_FAILED_TEXT = "|cFFDD3333(Failed)|r";
PARTYQUESTS_NOTSKYUSER_TEXT = "|cFF444433(Not Sky User)|r";

-- Bad Channel
PARTYQUESTS_NEED_TO_JOIN_SKY_PARTY = PARTYQUESTS_COLOR..": Unable to detect the "..SKY_PARTY_COLOR.." channel. Please /join SkyParty to use PartyQuests. You may need to leave another channel to join this one. ";

-- Format strings: 
PQ_OBJCOMPLETED					= "%s\'s quest objective completed! %s";
PQ_QPROGRESS					= "%s\'s quest progress... %s";
PQ_XHASCOMPLETED				= "%s has completed %s!";
PQ_YOUHAVECOMPLETED				= "You have completed %s!";
PQ_QUEST_LEVEL					= " (Quest Level %d)";
PQ_FILTERS					= "Filters";
PQ_COMMONQUESTS					= "Common Quests";
PQ_MYQUESTREFRESH				= "My Quests (Refreshing List..)";
PQ_MYQUEST					= "My Quests";
PQ_XQUESTS					= "%s\'s Quests";
PQ_PARTYCOMPLETED				= "The party has completed %s!";
PQ_QSQUEST					= "- Party Quests-\n%s";
PQ_XOBJ						= "|cFF000088%s's objectives:|r";
PQ_NBOBJ					= "%d Objective(s):";
PQ_WHOELSE					= "Who else has this quest:";
PQ_STNOCOMPLETED				= "%s\n%d completed this quest.";
PQ_STNOONECOMPLETED				= "%s\nNo one completed this quest.";
PQ_STALLCOMPLETED				= "%s\nAll completed this quest."
PQ_STXCOMPLETED					= "%s\n%d have completed this quest."
PQ_NUMQUESTS					= "%d Quests";
PQ_REQUESTING					= "(Requesting...)";

PQ_SHOWXQUESTS					= "Show %s\'s quests";
PQ_SHOWLOCQUESTS				= "Show %s quests";

-- Checkboxes --
PQ_FILTER_PROGNOTICES		= "Party Quest Progress Notices:";
PQ_FILTER_PROGNOTICES_QUECOMP	= "Notify when Quest completes";
PQ_FILTER_PROGNOTICES_OBJCOMP	= "Notify when Objective completes";
PQ_FILTER_PROGNOTICES_OBJPROG	= "Notify of Quest Item/Kill progress";

