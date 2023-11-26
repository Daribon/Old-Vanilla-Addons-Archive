-- Version : German (by Merlin.KIS, StarDust)
-- Last Update : 03/02/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_PARTYQUESTS	= "Tastenbelegung der Gruppenquests";
	BINDING_NAME_TOGGLEPARTYQUESTS	= "Gruppenquests anzeigen";

	-- Cosmos Configuration
	PARTYQUESTS_COLOR		= "|cFF009955Gruppen|cFF995555Quests|r";
	PARTYQUESTS_TITLE_TEXT 		= "Gruppenquests";
	PARTYQUESTS_BUTTON_TEXT		= "Gruppe";
	PARTYQUESTS_BUTTON_TOOTIP	= "Erweitertes Questfenster mit \nQuests der Gruppe anzeigen.";
	PARTYQUESTS_BUTTON_PARTY_TEXT	= "Gruppe";
	PARTYQUESTS_BUTTON_ABANDON_TEXT = "Abbrechen";
	PARTYQUESTS_BUTTON_SHARE_TEXT	= "Teilen";
	PARTYQUESTS_QUESTINFO_TEXT	= "Quest Log";
	PARTYQUESTS_ALLQUESTS		= "Alle Quests";
	PARTYQUESTS_BUTTON_SUBTEXT	= "Gruppenquests teilen";

	PARTYQUESTS_VERSION		= "0.1";
	PARTYQUESTS_VERSION_TIP		= "Programmiert von:\n Marek Gorecki";

	-- Exit!
	GLOBAL_EXIT_TAG_C		= "Schlie\195\159en";

	PARTYQUESTS_QUEST_TITLE		= "\[%s\] %s";
	PARTYQUESTS_QUEST_TITLE_TAG	= "(%s)";
	PARTYQUESTS_LOG_ID_TEMPLATE	= "Quest ID: |cffffffff%d|r";

	-- Menu
	PARTYQUESTS_MENU_REFRESH		= "Aktualisieren";
	PARTYQUESTS_MENU_SHOWZONES		= "Zonen anzeigen";
	PARTYQUESTS_MENU_SHOWLEVEL		= "Questlevel anzeigen";
	PARTYQUESTS_MENU_SHOWCOMPLETEDBANNER	= "Bannermeldung wenn abgeschlossen";
	PARTYQUESTS_MENU_SHOWDETAILEDTIP	= "Questaufgaben als Tooltips anzeigen";
	PARTYQUESTS_MENU_SHOWINDENT		= "Einr\195\188ckung bei Quests entfernen";

	-- Tabs
	PARTYQUESTS_TAB_SELF		= "Eigene";
	PARTYQUESTS_TAB_PARTY		= "Gruppe";

	-- Types
	PARTYQUESTS_SETTING_PLAYER	= "Meine Questeinstellungen";
	PARTYQUESTS_SETTING_COMMON	= "Allgemeine Questeinstellungen";
	PARTYQUESTS_SETTING_PARTY	= "Gruppenquest Einstellungen";

	-- Sorts
	PARTYQUESTS_SORTING		= "Sortierung";
	PARTYQUESTS_SORT_LEVEL		= "nach Level sortieren";
	PARTYQUESTS_SORT_TITLE		= "nach Titel sortieren";
	PARTYQUESTS_SORT_ZONE		= "nach Zone sortieren";

	-- Notices
	PARTYQUESTS_QUESTSTATUS_WAITING = "Questinformationen von %s werden abgerufen.";
	PARTYQUESTS_QUESTSTATUS_FAILED	= "%s hat diese Quest nicht mehr.";
	PARTYQUESTS_LOCATINGPARTYMEMBERS= "Deine Liste wird nach Gruppenmitgliedern durchsucht...";
	PARTYQUESTS_NOPARTYMEMBERS	= "Du hast kein Gruppenmitglieder.";

	-- Waiting
	PARTYQUESTS_WAITING_0		= " abfragen";
	PARTYQUESTS_WAITING_1		= ". abfragen";
	PARTYQUESTS_WAITING_2		= ".. abfragen";
	PARTYQUESTS_WAITING_3		= "... abfragen";

	-- Building
	PARTYQUESTS_BUILDING_0		= " erstellen"; 
	PARTYQUESTS_BUILDING_1		= ". erstellen"; 
	PARTYQUESTS_BUILDING_2		= ".. erstellenn"; 
	PARTYQUESTS_BUILDING_3		= "... erstellen"; 

	-- Failed
	PARTYQUESTS_FAILED_TEXT		= "|cFFDD3333(Fehlgeschlagen)|r";
	PARTYQUESTS_NOTSKYUSER_TEXT	= "|cFF444433(ist kein Sky-Benutzer)|r";

	-- Bad Channel
	PARTYQUESTS_NEED_TO_JOIN_SKY_PARTY = PARTYQUESTS_COLOR..": Kann den "..SKY_PARTY_COLOR.." Kanal nicht finden. Bitte gib '/join SkyParty' ein um Gruppen-Questing zu verwenden. M\195\182glicherweise mu\195\159t du daf\195\188r einen anderen Kanal verlassen.";

	-- Format strings: 
	PQ_OBJCOMPLETED			= "%s\'s Questaufgabe erf\195\188llt! %s";
	PQ_QPROGRESS			= "%s\'s Questfortschtritt... %s";
	PQ_XHASCOMPLETED		= "%s hat %s abgeschlossen!";
	PQ_YOUHAVECOMPLETED		= "Du hast %s abgeschlossen!";
	PQ_QUEST_LEVEL			= " (Questlevel %d)";
	PQ_FILTERS			= "Filter";
	PQ_COMMONQUESTS			= "Gemeinsame Quests";
	PQ_MYQUESTREFRESH		= "Eigene Quests (List wird neu geladen...)";
	PQ_MYQUEST			= "Eigene Quests";
	PQ_XQUESTS			= "%s\' Quests";
	PQ_PARTYCOMPLETED		= "Die Gruppe hat %s abgeschlossen!";
	PQ_QSQUEST			= "- Gruppenquests -\n%s";
	PQ_XOBJ				= "|cFF000088 %s\'s Aufgaben:|r";
	PQ_NBOBJ			= "%d Aufgabe(e):";
	PQ_WHOELSE			= "Wer diese Quest noch hat:";
	PQ_STNOCOMPLETED		= "%s\n%d hat diese Quest abgeschlossen.";
	PQ_STNOONECOMPLETED		= "%s\nNiemand hat diese Quest abgeschlossen.";
	PQ_STALLCOMPLETED		= "%s\nAlle haben diese Quest abgeschlossen."
	PQ_STXCOMPLETED			= "%s\n%d haben diese Quest abgeschlossen."
	PQ_NUMQUESTS			= "%d Quests";
	PQ_REQUESTING			= "(Abfrage...)";

	PQ_SHOWXQUESTS			= "%s\'s Quests anzeigen";
	PQ_SHOWLOCQUESTS		= "%s Quests anzeigen";

	-- Checkboxes --
	PQ_FILTER_PROGNOTICES		= "Questfortschritte der Gruppe melden:";
	PQ_FILTER_PROGNOTICES_QUECOMP	= "Melden wenn Quest abgeschlossen";
	PQ_FILTER_PROGNOTICES_OBJCOMP	= "Melden wenn Questaufgabe abgeschlossen";
	PQ_FILTER_PROGNOTICES_OBJPROG	= "Fortschritt der Questgegenst\195\164nde/Kills melden";

end