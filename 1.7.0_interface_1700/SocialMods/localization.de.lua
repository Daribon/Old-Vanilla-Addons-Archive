-- Version : German (by pc, StarDust)
-- Last Update : 09/09/2005

if ( GetLocale() == "deDE" ) then

	-- Slash commands:
	-- SLASH_COS_SSM1				= "/COS_SSM";
	-- SLASH_COS_SSM2				= "/ssm";

	COS_SSM_SLASH_MESSAGE				= "nachricht";
	COS_SSM_SLASH_PAGE				= "seite";

	-- Binding Configuration
	BINDING_HEADER_COS_SSM				= "Geselligkeit-Fenster";

	BINDING_NAME_COS_SSM_SEND_MESSAGE_ENABLE_TOGGLE	= "'Nachricht senden' Button anzeigen/verbergen";
	BINDING_NAME_COS_SSM_SEND_PAGE_ENABLE_TOGGLE	= "'Nachricht pagen' Button anzeigen/verbergen";
	BINDING_NAME_COS_SN_ENABLE_TOGGLE		= "Spielernotizen anzeigen/verbergen";
	BINDING_NAME_COS_SN_EDITOR_OPEN			= "Fenster mit Spielernotizen anzeigen";
	BINDING_NAME_COS_SSM_EDIT_NOTE_ENABLE_TOGGLE	= "'Notiz bearbeiten' Button anzeigen/verbergen";

	BINDING_NAME_COS_SN_PARTY_NOTES_ENABLE_TOGGLE	= "Button im Gruppenfenster anzeigen/verbergen";
	BINDING_NAME_COS_SN_TARGET_NOTE_ENABLE_TOGGLE	= "Button im Zielfenster anzeigen/verbergen";

	-- Cosmos Configuration
	COS_SSM_SEP_TEXT					= "Geselligkeit-Fenster";
	COS_SSM_SEP_INFO				= "Diese Einstellungen erweitern das Geselligkeit-Fenster um weitere Funktionen.";

	COS_SSM_SEND_MESSAGE_ENABLE_TEXT			= "'Nachricht senden' Button aktivieren";
	COS_SSM_SEND_MESSAGE_ENABLE_INFO		= "Wenn aktiviert, ist der 'Nachricht senden' Button im Geselligkeit-Fenster verf\195\188gbar um Nachrichten an Mitspieler zu senden.";
	COS_SSM_SEND_MESSAGE_TOGGLE_TEXT			= "'Nachricht senden' Button wechseln";

	COS_SSM_SEND_PAGE_ENABLE_TEXT			= "'Nachricht pagen' Button aktivieren";
	COS_SSM_SEND_PAGE_ENABLE_INFO			= "Wenn aktiviert, ist der 'Nachricht pagen' Button im Geselligkeit-Fenster verf\195\188gbar um Nachrichten an Mitspieler zu pagen.";
	COS_SSM_SEND_PAGE_TOGGLE_TEXT			= "'Nachricht pagen' Button wechseln";

	COS_SSM_SEND_PAGE				= "Nachricht pagen";
	COS_SSM_SENDPAGE_NEWBIE_TOOLTIP			= "Sendet eine Bannernachricht (pagen) an den Mitspieler.";

	COS_SN_ENABLE_TEXT				= "Spielernotizen aktivieren";
	COS_SN_ENABLE_INFO				= "Wenn aktiviert, k\195\182nnen zu jedem Spieler in der Liste Notizen hinzugef\195\188gt und bearbeitet werden.";

	COS_SSM_EDIT_NOTE_ENABLE_TEXT			= "'Notiz Bearbeiten' Button aktivieren";
	COS_SSM_EDIT_NOTE_ENABLE_INFO			= "Wenn aktiviert, ist der 'Notiz bearbeiten' Button im Geselligkeit-Fenster verf\195\188gbar um Notizen zu Mitspielern zu bearbeiten.";
	
	-- Slash commands:
	-- SLASH_COS_SSN1				= "/COS_SSN";
	-- SLASH_COS_SSN2				= "/ssn";

	-- /ssn [on|off|enable|disable|toggle|help]
	-- /ssn button [on|off|enable|disable|toggle]
	-- /ssn self note [on|off|enable|disable|toggle]
	-- /ssn self note party [on|off|enable|disable|toggle]
	-- /ssn self note complete [on|off|enable|disable|toggle]
	-- /ssn self note finish [on|off|enable|disable|toggle]
	-- /ssn self note ding [on|off|enable|disable|toggle]
	-- /ssn party notes [on|off|enable|disable|toggle]
	-- /ssn party notes [party|complete|finish]
	-- /ssn target note [on|off|enable|disable|toggle]
	-- /ssn guild ding [on|off|enable|disable|toggle]

	COS_SSN_SLASH_SELF				= "selbst";
	COS_SSN_SLASH_PARTY				= "gruppe";
	COS_SSN_SLASH_TARGET				= "ziel";
	COS_SSN_SLASH_GUILD				= "gilde";
	COS_SSN_SLASH_BUTTON				= "button";
	COS_SSN_SLASH_NOTE				= "notiz";
	COS_SSN_SLASH_NOTES				= "notizen";
	COS_SSN_SLASH_PARTY				= "gruppe";
	COS_SSN_SLASH_COMPLETE				= "fertig";
	COS_SSN_SLASH_FINISH				= "abgeschlossen";
	COS_SSN_SLASH_DING				= "ding";

	COS_SSN_SLASH_ON				= "ein";
	COS_SSN_SLASH_OFF				= "aus";
	COS_SSN_SLASH_ENABLE				= "aktivieren";
	COS_SSN_SLASH_DISABLET				= "deaktivieren";
	COS_SSN_SLASH_TOGGLE				= "wechseln";

	COS_SSN_ENABLED_TEXT				= "aktiviert";
	COS_SSN_DISABLED_TEXT				= "deaktiviert";

	-- Interface Configuration
	COS_SN_SEP_TEXT					= "Spielernotiz";
	COS_SN_SEP_INFO					= "Dieser Abschnitt erlaubt es die Spielernotizen zu konfigurieren.";

	COS_SN_EDIT_NOTE_ENABLE_TEXT			= "'Notiz Bearbeiten' Button anzeigen";
	COS_SN_EDIT_NOTE_ENABLE_INFO			= "Wenn aktiviert, wird im Geselligkeit-Fenster neben jedem Spieler ein Button zum Speichern eigener Notizen zu diesem Spieler angezeigt.";

	COS_SN_EDIT_NOTE				= "Notiz Bearbeiten";

	COS_SN_NOTES					= "Spielernotiz bearbeiten";
	COS_SN_NOTES_NEWBIE_TOOLTIP			= "Bearbeitet Notizen zu Mitspielern.";

	COS_SN_SELF_NOTE_TEXT				= "Button der Spielernotizen f\195\188r sich selbst anzeigen";
	COS_SN_SELF_NOTE_INFO				= "Wenn aktiviert, wird der Button f\195\188r die eigene Spielernotiz angezeigt.";
	COS_SN_SELF_NOTE_STAT				= "Eigene Spielernotizen sind ";	-- "enabled." / "disabled."

	COS_SN_PARTY_NOTES_TEXT				= "Button der Spielernotizen f\195\188r Gruppenmitglieder anzeigen";
	COS_SN_PARTY_NOTES_INFO				= "Wenn aktiviert, wird der Button der Spielernotiz im Gruppenfenster neben dem jeweiligen Portrait angezeigt.";
	COS_SN_PARTY_NOTES_STAT				= "Spielernotizen der Gruppe sind ";	-- "enabled." / "disabled."
	
	COS_SN_TARGET_NOTE_TEXT				= "Button der Spielernotizen im Zielfenster anzeigen";
	COS_SN_TARGET_NOTE_INFO				= "Wenn aktiviert, wird der Button der Spielernotiz im Zielfenster neben dem Zielportrait angezeigt.";
	COS_SN_TARGET_NOTE_STAT				= "Spielernotizen des Ziels sind ";	-- "enabled." / "disabled."

	COS_SN_PARTY_CHANGES_TO_SELF_NOTE_TEXT		= "\195\132nderungen der Gruppezusammenstellung\nzur eigenen Notiz hinzuf\195\188gen";
	COS_SN_PARTY_CHANGES_TO_SELF_NOTE_INFO		= "Wenn aktiviert, werden \195\132nderungen in der Gruppenzusammenstellung zur eigenen Notiz hinzugef\195\188gt.";
	COS_SN_PARTY_CHANGES_TO_SELF_NOTE_STAT		= "\195\132nderungen der Gruppenzusammenstellung zur eigenen Notiz hinzugef\195\188gen ist ";

	COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_TEXT		= "\195\132nderungen der Gruppezusammenstellung\nzu den Gruppennotizen hinzuf\195\188gen";
	COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_INFO		= "Wenn aktiviert, werden \195\132nderungen in der Gruppenzusammenstellung zu den Notizen aller Spieler in der Gruppe hinzugef\195\188gt.";
	COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_STAT		= "\195\132nderungen der Gruppenzusammenstellung zu den Gruppennotizen hinzugef\195\188gen ist ";

	COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_TEXT	= "'Questaufgabe abgeschlossen'\nzur eigenen Notiz hinzuf\195\188gen";
	COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_INFO	= "Wenn aktiviert, wird ein entsprechender Hinweis zur eigenen Notiz hinzugef\195\188gt, sobald eine Questaufgabe erledigt wurde.";
	COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_STAT	= "'Questaufgabe abgeschlossen' zur eigenen Notiz hinzuf\195\188gen ist ";

	COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_TEXT	= "'Questaufgabe abgeschlossen'\nzu den Gruppennotizen hinzuf\195\188gen";
	COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_INFO	= "Wenn aktiviert, wird ein entsprechender Hinweis zu den Notizen aller Spieler in der Gruppe hinzugef\195\188gt, sobald eine Questaufgabe erledigt wurde.";
	COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_STAT	= "'Questaufgabe abgeschlossen' zu den Gruppennotizen hinzuf\195\188gen ist ";

	COS_SN_QUEST_FINISHES_TO_SELF_NOTE_TEXT		= "'Quest abgeschlossen' zur eigenen Notiz hinzuf\195\188gen";
	COS_SN_QUEST_FINISHES_TO_SELF_NOTE_INFO		= "Wenn aktiviert, wird ein entsprechender Hinweis zur eigenen Notiz hinzugef\195\188gt, sobald eine Quest abgegeben (beim NSC eingel\195\182st) wurde.";
	COS_SN_QUEST_FINISHES_TO_SELF_NOTE_STAT		= "'Quest abgeschlossen' zur eigenen Notiz hinzuf\195\188gen ist ";

	COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_TEXT		= "'Quest abgeschlossen' zu Gruppennotizen hinzuf\195\188gen";
	COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_INFO	= "Wenn aktiviert, wird ein entsprechender Hinweis zu den Notizen aller Spieler in der Gruppe hinzugef\195\188gt, sobald eine Quest abgegeben (beim NSC eingel\195\182st) wurde.";
	COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_STAT	= "'Quest abgeschlossen' zu den Gruppennotizen hinzuf\195\188gen ist ";

	COS_SN_LEVEL_UP_TO_SELF_NOTE_TEXT		= "Levelaufstieg zur eigenen Notiz hinzuf\195\188gen";
	COS_SN_LEVEL_UP_TO_SELF_NOTE_INFO		= "Wenn aktiviert, wird ein Hinweis bei jedem Levelaufstieg zur eigenen Notiz hinzugef\195\188gt.";
	COS_SN_LEVEL_UP_TO_SELF_NOTE_STAT		= "Levelaufstieg zur eigenen Notiz hinzuf\195\188gen ist ";

	COS_SN_LEVEL_UP_TO_GUILD_CHAT_TEXT		= "Levelaufstieg im Gildenchat melden";
	COS_SN_LEVEL_UP_TO_GUILD_CHAT_INFO		= "Wenn aktiviert, wird eine entsprechende Nachricht im Gildenchat angezeigt sobald ein neuer Charakterlevel erreicht wird.";
	COS_SN_LEVEL_UP_TO_GUILD_CHAT_STAT		= "Levelaufstieg im Gildenchat melden ist ";		

	-- Social Note Editor strings
	COS_SNE_CLEAR_NOTE				= "Notiz Leeren";
	COS_SNE_DELETE_NOTE				= "Notiz L\195\182schen";
	COS_SNE_ADD_TIMESTAMP				= "Uhrzeit Hinzuf.";
	COS_SNE_ADD_PARTY				= "Gruppe Hinzuf.";
	COS_SNE_ADD_LOCATION				= "Position Hinzuf.";

	COS_SNE_SELF_JOINED_NOTE			= "ist Gruppe beigetreten am: ";
	COS_SNE_JOINED_NOTE				= "Gruppe beigetreten am: ";
	COS_SNE_SELF_COMPLETED_NOTE			= "Questaufgabe '%s' abgeschlossen am: ";
	COS_SNE_COMPLETED_NOTE				= "Questaufgabe '%s' mit mir abgeschlossen am: ";
	COS_SNE_SELF_FINISHED_NOTE			= "Quest '%s' abgeschlossen am: ";
	COS_SNE_FINISHED_NOTE				= "Quest '%s' mit mir abgeschlossen: ";

	COS_SNE_DINGED_TEXT				= "Aufstieg zum Level %d";
	COS_SNE_DINGED_AT_TEXT				= " nach %d Tagen %02d:%02d:%02d Spielzeit.";
	COS_SNE_DINGED_IN_TEXT				= " in %d Tagen %02d:%02d:%02d.";
	COS_SNE_DINGED_ON_DATE_TEXT			= " am %s.";
	COS_SNE_DINGED_ON_DATETIME_TEXT			= " am %s um %s.";

	SN_ADD_SOCIAL_NOTE				= "Geselligkeit-Notiz Hinzuf\195\188gen";

end