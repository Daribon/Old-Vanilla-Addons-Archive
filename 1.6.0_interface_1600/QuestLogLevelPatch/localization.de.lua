-- Version : German (by StarDust)
-- Last Update : 06/13/2005

if ( GetLocale ) and ( GetLocale() == "deDE" ) then

	QUESTLEVEL_CMDS				= {"/questloglevelpatch", "/questloglevel", "/ql", "/questlevel"};

	QUESTLEVEL_CONFIG_HEADER		= "Questlog Level";
	QUESTLEVEL_CONFIG_HEADER_INFO		= "F\195\164rbt die Questtitel im Questlog entsprechend ihrer Schwierigkeit ein und f\195\188gt dessen Level im Titel hinzu.";

	QUESTLEVEL_CONFIG_ENABLED		= "Level im Questlog anzeigen";
	QUESTLEVEL_CONFIG_ENABLED_INFO		= "Wenn aktiviert, wird der Level der Quest im Titel angezeigt und jener entsprechend seiner Schwierigkeit eingef\195\164rbt.";

	QUESTLEVEL_KHAOS_SET_EASY_ID		= "QuestLogLevelPatchEasyOptionID";
	QUESTLEVEL_KHAOS_EASYSET_TEXT		= "Questlog Level";
	QUESTLEVEL_KHAOS_EASYSET_HELP		= "Questlog Level anzeigen - F\195\188gt vor dem Questtitel dessen Level hinzu.";

	QUESTLEVEL_KHAOS_ENABLED_TEXT		= "Level im Questlog anzeigen";
	QUESTLEVEL_KHAOS_ENABLED_HELPTEXT	= "Wenn aktiviert, wird der Level der Quest im Titel angezeigt und jener entsprechend seiner Schwierigkeit eingef\195\164rbt.";

	QUESTLEVEL_KHAOS_STATE_TEXT		= "Anzeige der Questlevel ist";
	QUESTLEVEL_KHAOS_STATE_ENABLED		= "aktiviert";
	QUESTLEVEL_KHAOS_STATE_DISABLED		= "deaktiviert";

end
