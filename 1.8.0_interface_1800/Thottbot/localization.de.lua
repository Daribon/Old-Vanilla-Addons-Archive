-- Version : German
-- $LastChangedBy: stardust $
-- $Date: 2005-09-09 01:39:02 -0500 (Fri, 09 Sep 2005) $

if ( GetLocale() == "deDE" ) then

	--[[ Cosmos/Khaos Config Strings ]]--
	T_HEADER_HELP		= "Einstellungen bez\195\188glich Thottbot Profilen und Datensammlung\nhttp://www.thottbot.com/";

	T_PROFILE_TEXT		= "Profil der eigenen Ausr\195\188stung sammeln";
	T_PROFILE_HELP		= "Aktiviert die Datensammlung der eigenen Ausr\195\188stung. Starte Cosmos.exe um die Daten hochzuladen.\nNach dem Hochladen ist dein Profile hier sichtbar:\n";
	T_PROFILE_ENABLED	= "Sammlung der eigene Ausr\195\188stung aktiviert. Bitte starte Cosmos.exe um die Daten hochzuladen!\nNach dem Hochladen ist dein Profile hier sichtbar:\n";
	T_PROFILE_DISABLED	= "Sammlung der eigene Ausr\195\188stung deaktiviert.";
	T_PROFILE_TEXT1		= "Informationen zu allen Fertigkeiten und jeglicher Ausr\195\188stung aller Charaktere die du spielst werden jetzt gesammelt und lokal gespeichert. Starte Cosmos.exe um diese Daten hochzuladen und dein Profil wird sofort aktualisiert.";
	T_PROFILE_TEXT2		= "Dein profil wird immer gesammelt wenn du diese Option aktivierts, du dich im Spiel anmeldest oder du den /tprofil [Option] Befehl verwendest.";
	T_PROFILE_TEXT3		= "Nach dem Hochladen ist dein Profile hier im Internet sichtbar:";

	T_TARGET_PROFILE_TEXT	= "Profil der Ausr\195\188stung des Ziels sammeln";
	T_TARGET_PROFILE_HELP	= "Aktiviert die Datensammlung der Ausr\195\188stung der Ziele die du anw\195\164hlst. Dies hilft vorallem Spielern die kein Cosmos verwenden.";
	T_TARGET_PROFILE_ENABLED = "Sammlung der Ausr\195\188stung des Ziels aktiviert.";
	T_TARGET_PROFILE_DISABLED= "Sammlung der Ausr\195\188stung des Ziels aktiviert.";

	T_DATA_TEXT		= "Thottbot Datensammlung aktivieren";
	T_DATA_HELP		= "Hilf Thottbot! Diese Option aktiviert die Datensammlung von Thottbot wobei zum Beispiel Informationen wie Position von NSC und deren Dropps gesammelt werden. Diese Sammlung ist sehr sicher; es werden keinerlei pers\195\182nliche Informationen versendet. Starte Cosmos.exe um diese Daten hochzuladen.";
	T_DATA_ENABLED		= "Thottbot Datensammlung aktiviert.";
	T_DATA_DISABLED		= "Thottbot Datensammlung deaktiviert.";

	T_HEAVY_TEXT		= "Umfangreiche Thottbot Datensammlung aktivieren";
	T_HEAVY_HELP		= "Die umfangreiche Datensammlung speichert mehr Informationen als normal. So z.B. Handwerksfertigkeiten und erweiterte NSC Informationen. Als Nachteil kann deswegen manchmal die Geschwindigkeit des Spiels beeintr\195\164chtigt werden.";
	T_HEAVY_ENABLED		= "Umfangreiche Thottbot Datensammlung aktiviert.";
	T_HEAVY_DISABLED	= "Umfangreiche Thottbot Datensammlung deaktiviert.";
	T_HEAVY_TEXT1		= "Die umfangreiche Datensammlung speichert neben den normalen Informationen noch folgendes:";
	T_HEAVY_TEXT2		= "- alle Handwerksfertigkeiten";
	T_HEAVY_TEXT3		= "- Trainerinformationen";
	T_HEAVY_TEXT4		= "- Positionen von NSC wenn der Mauszeiger \195\188ber jene bewegt und nicht nur wenn jener als Ziel angew\195\164hlt wird.";
	T_HEAVY_TEXT5		= "For those that don't have new tradeskill recipes and aren't in a rarely visited zone, Heavy mode is overkill.";

	T_STATE_TEXT		= "Thottbot Status beim Start anzeigen";
	T_STATE_HELP		= "Wenn aktiviert, werden beim Start Informationen zu den Einstellungen von THOTTBOT [Ein/Aus] angezeigt.";
	T_STATE_ENABLED		= "Thottbot Statusanzeige aktiviert.";
	T_STATE_DISABLED	= "Thottbot Statusanzeige deaktiviert.";

	T_SET_DESC		= "Einstellungen zur Thottbot Profil-/Daten-Sammlung";
	T_SECTION_DESC		= "Diese Einstellungen konfigurieren das Thottbot AddOn.\n http://www.thottbot.com/";

	--[[ Slash Command Related Strings ]]--
	T_CMD_SIZE_COMLIST	= {"/tsize", "/thottbotsize", "/tgr\195\182\195\159e", "/thottbotgr\195\182\195\159e"};
	T_CMD_SIZE_HELP		= "zeigt die Gr\195\182\195\159e der bisher gesammelten Daten zu Thottbot an";

	T_CMD_STATE_COMLIST	= {"/tstate", "/thottbotstate", "/tstatus", "/thottbotstatus"};
	T_CMD_STATE_HELP	= "zeigt den Status von Thottbot an";

	T_CMD_RESET_COMLIST	= {"/treset", "/thottbotreset", "/tr\195\188cksetzen", "/thottbotr\195\188cksetzen"};
	T_CMD_RESET_HELP	= "setzt alle bisher gesammelten Daten zu Thottbot zur\195\188ck";

	T_CMD_LOC_COMLIST	= {"/tloc", "/thottbotloc", "/tpos", "/thottbotpos"};
	T_CMD_LOC_HELP		= "zeigt die momentanen Thottbot Postionskoordinaten an";
	T_CMD_LOC_MINIMAP	= "Momentane Thottbot Position ist auf der Minikarte.";
	T_CMD_LOC_ZONEMAP	= "Position des Thottbot Ziels ist auf der Zonenkarte.";
	T_CMD_LOC_USAGE		= "Benutzung /tpos x,y";
	T_CMD_LOC_NOTE		= "Hinweis: /tpos x,y zeigt die Koordinaten auf der Karte.";
	T_CMD_LOC_NOTE2		= "Hinweis2: /goto x,y versucht dich dorthin zu bringen! Verwendung auf eigene Gefahr!";

	T_CMD_PROFILE_COMLIST	= {"/tprofile", "/thottbotprofile"};
	T_CMD_PROFILE_HELP	= "sammel Thottbot Profil";

	T_CMD_GCINFO_COMLIST	= {"/gcinfo"};
	T_CMD_GCINFO_HELP	= "Abfallsammler Informationen (Technische Info f\195\188r AddOn Autoren)";
	T_CMD_GCINFO_FORMAT	= "%d/%d\n+%d\n+%dk pro Sek";
	T_CMD_GCINFO_FORMAT_WINDOW = "%d/%d\n+%d\n+%dk pro Sek\n%d Sek Fenster";

	T_CMD_VER_COMLIST	= {"/tver", "/thottbotversion"};
	T_CMD_VER_HELP		= "Thottbot Version";
	T_CMD_VER_VERSION	= "Thottbot Code Version: ";

	--[[ Miscellaneous Strings ]]--
	T_SK			= "H\195\164uten";

	T_RACE_HUMAN		= "Mensch";
	T_RACE_DWARF		= "Zwerg";
	T_RACE_NELF		= "Nachtelf";
	T_RACE_GNOME		= "Gnom";
	T_RACE_UNDEAD		= "Untoter";
	T_RACE_TAUREN		= "Taure";
	T_RACE_ORC		= "Ork";
	T_RACE_TROLL		= "Troll";

	T_SERVER_UNKNOWN	= "<FEHLER: Dein Server ist unbekannt!>"
	T_IS_DISABLED		= "Thottbot ist deaktiviert.";
	T_DISABLED		= "Thottbot deaktiviert.";
	T_ENABLED		= "Thottbot aktiviert.";
	T_RESET			= "Thottbot zur\195\188ckgesetzt.";

	T_STATE_PROFILE		= "Profil";
	T_STATE_TARGET		= "Ziel Profil";
	T_STATE_DATA		= "Daten";
	T_STATE_HEAVY		= "Stark";

	T_LANGUAGE_COMM		= {"/lang","/language","/sprache"};
	T_LANGUAGE_COMM_INFO	= "\195\132ndert die Sprache welche du sprichst.";
	T_LANGUAGE_UNKNOWN	= "Du verstehst die Sprache %s nicht.";
	T_LANGUAGE_NOWSPEAK	= "Du sprichst jetzt %s.";
	T_LANGUAGE_HELP1	= "Gib /sprache Darnassian ein um eine andere Sprache zu sprechen.";
	T_LANGUAGE_HELP2	= "";

	--[[ Thottbot Engine Strings ]]--
	T_ENGINE_SIZE		= "Thottbot Gr\195\182\195\159e: ";
	T_ENGINE_SLEEP		= "Thottbot ist voll! Thottbot ist m\195\188de. Thottbot schl\195\164ft ein Weilchen.";
	T_ENGINE_BYTES		= " Bytes";
	T_ENGINE_NEW_ABIL	= "Du hast eine neue F\195\164higkeit erlernt: %s.";
	T_ENGINE_NEW_SPELL	= "DU hast einen neuen Zauber erlernt: %s.";
	T_ENGINE_SIZE_LIMIT	= "Thottbot Limit des Ziel-Profil erreicht, benutze /treset um r\195\188ckzusetzen.";
	T_ENGINE_EXP_GAIN	= "Erfahrung erhalten: %d.";
	T_ENGINE_FULL		= "Thottbot ist voll!";
	T_ENGINE_REALLY_FULL	= "Boss, ich kann wirklich nicht noch mehr hinein quetschen. Auch wenn wir das Fundament weiter ausbauen geht nicht mehr hinein. Es ist alles voll - der Flu\195\159 geht schon \195\188ber.";
	T_ENGINE_MEMORY		= "Thottbot Speicherstatistik";
	T_ENGINE_PCOLLECT	= "Sammle Thottbot Profil...";
	T_ENGINE_PCOMPLETE	= "Thottbot Profil vollst\195\164ndig!";
	T_ENGINE_PABORT		= "Profil abgebrochen";
	T_ENGINE_CONTINENT	= "Kontinent ";
	--[[ Please be careful if you translate these, verify thottbot still works after translation before commiting ]]--
	T_ENGINE_LEARNED_NEW	= "Ihr habt eine neue (%w+): (.*)";
	T_ENGINE_REQ_POINT	= "^Erfordert %d+ Punkte in ";
	T_ENGINE_REQ		= "Ben\195\182tigt (%d+)";
	T_ENGINE_CORPSE		= "Kadaver von %s";
	T_ENGINE_PET		= "Begleiter von %s";
	T_ENGINE_QUEST_REQ	= "Erfordert (.*)";
	T_ENGINE_QUEST_OBJ_COMP = "%s (Fertig)";
	T_ENGINE_QUEST_COMPLETE = "%s abgeschlossen.";
	T_ENGINE_HEARTHSTONE	= "Ruhestein";
	T_ENGINE_CREATED_BY	= "|cff00ff00<Hergestellt von %s>|r";
	T_ENGINE_REPUTATION	= "Euer Ruf mit der Fraktion '([%w%s]+)([%w]+)' hat sich (%d+)";

end