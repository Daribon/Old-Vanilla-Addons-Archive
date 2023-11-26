-- Version : German (by StarDust)
-- Last Update : 07/11/2005

if ( GetLocale() == "deDE" ) then

	-- Commands
	MAPNOTES_ENABLE_COMMANDS	= { "/mapnote", "/kartennotiz" };
	MAPNOTES_ONEOTE_COMMANDS	= { "/onenote", "/allowonenote", "/aon", "/kurznotiz" };
	MAPNOTES_MININOTE_COMMANDS	= { "/nextmininote", "/nmn", "/nkn", "/n\195\164chstekurznotiz" };
	MAPNOTES_MININOTEONLY_COMMANDS	= { "/nextmininoteonly", "/nmno", "/nknn" };
	MAPNOTES_MININOTEOFF_COMMANDS	= { "/mininoteoff", "/mno", "/kkn", "/keinekurznotiz" };
	MAPNOTES_MNTLOC_COMMANDS	= { "/mntloc" };
	MAPNOTES_QUICKNOTE_COMMANDS	= { "/quicknote", "/qnote", "/schnellnotiz", "/snotiz" };
	MAPNOTES_QUICKTLOC_COMMANDS	= { "/quicktloc", "/qtloc", "/spos", "/schnellpos" };

	-- Inteface Configuration
	MAPNOTES_WORLDMAPHELP		= "Auf die Karte Doppelklicken um das Men\195\188 der Karten Notizen zu \195\182ffnen.";
	MAPNOTES_CLICK_ON_SECOND_NOTE	= "|cFFFF0000Karten Notizen:|r W\195\164hle eine zweite Notiz um jene\ndurch eine Linie zu verbinden/Linie wieder zu l\195\182schen.";

	MAPNOTES_NEW_MENU		= "Karten Notizen";
	MAPNOTES_NEW_NOTE		= "Notiz erstellen";
	MAPNOTES_MININOTE_OFF		= "Kurz-Notizen aussch.";
	MAPNOTES_OPTIONS		= "Einstellungen";
	MAPNOTES_CANCEL			= "Abbrechen";

	MAPNOTES_POI_MENU		= "Karten Notizen";
	MAPNOTES_EDIT_NOTE		= "Notiz bearbeiten";
	MAPNOTES_MININOTE_ON		= "Als Kurz-Notiz";
	MAPNOTES_SPECIAL_ACTIONS	= "Spezielle Aktionen";
	MAPNOTES_SEND_NOTE		= "Notiz senden";

	MAPNOTES_SPECIALACTION_MENU	= "Spezielle Aktionen";
	MAPNOTES_TOGGLELINE		= "Notizen verbinden";
	MAPNOTES_DELETE_NOTE		= "Notiz l\195\182schen";

	MAPNOTES_EDIT_MENU		= "Notiz Bearbeiten";
	MAPNOTES_SAVE_NOTE		= "Speichern";
	MAPNOTES_EDIT_TITLE		= "Titel (mu\195\159 angegeben werden):";
	MAPNOTES_EDIT_INFO1		= "Info-Zeile 1 (optional):";
	MAPNOTES_EDIT_INFO2		= "Info-Zeile 2 (optional):";

	MAPNOTES_SEND_MENU		= "Notiz Senden";
	MAPNOTES_SLASHCOMMAND		= "Modus wechseln";
	MAPNOTES_SEND_COSMOSTITLE	= "Notiz senden:";
	MAPNOTES_SEND_COSMOSTIP		= "Diese Notiz kann von allen Benutzern der Karten Notizen (Map Notes) empfangen werden.\n('an Gruppe senden' funktioniert nur mit Cosmos)";
	MAPNOTES_SEND_PLAYER		= "Spielername eingeben:";
	MAPNOTES_SENDTOPLAYER		= "An Spieler senden";
	MAPNOTES_SENDTOPARTY		= "An Gruppe senden";
	MAPNOTES_SHOWSEND		= "Modus wechseln";
	MAPNOTES_SEND_SLASHTITLE	= "Slash-Befehle:";
	MAPNOTES_SEND_SLASHTIP		= "Dies markieren und STRG+C dr\195\188cken um in die Zwischenablage zu kopieren.\n(dann kann es zum Beispiel in einem Forum ver\195\182ffentlicht werden)";
	MAPNOTES_SEND_SLASHCOMMAND	= "/Befehl:";

	MAPNOTES_OPTIONS_MENU		= "Einstellungen";
	MAPNOTES_SAVE_OPTIONS		= "Speichern";
	MAPNOTES_OWNNOTES		= "Notizen anzeigen, die von diesem Charakter erstellt wurden";
	MAPNOTES_OTHERNOTES		= "Notizen anzeigen, die von anderen Spielern empfangen wurden";
	MAPNOTES_HIGHLIGHT_LASTCREATED	= "Zuletzt erstellte Notiz in |cFFFF0000rot|r hervorheben";
	MAPNOTES_HIGHLIGHT_MININOTE	= "Notizen die als Kurz-Notiz markiert wurden in |cFF6666FFblau|r hervorheben";
	MAPNOTES_ACCEPTINCOMING		= "Ankommende Notizen von anderen Spielern akzeptieren";
	MAPNOTES_INCOMING_CAP		= "Ankommende Notizen ablehnen wenn\nweniger als 5 freie Notizen \195\188brig bleiben";
	MAPNOTES_AUTOPARTYASMININOTE	= "Markiere Gruppen-Notizen automatisch als Kurz-Notiz"

	MAPNOTES_CREATEDBY			= "Erstellt von";
	MAPNOTES_CHAT_COMMAND_ENABLE_INFO	= "Dieser Befehl erlaubt es zum Beispiel Notizen, die von einer Webseite empfangen wurden, einzuf\195\188gen.";
	MAPNOTES_CHAT_COMMAND_ONENOTE_INFO	= "\195\156bergeht die Einstellungen, wodurch die n\195\164chste empfangene Notiz in jedem Fall akzeptiert wird.";
	MAPNOTES_CHAT_COMMAND_MININOTE_INFO	= "Markiert die n\195\164chste empfangene Notiz direkt als Kurz-Notiz (und f\195\188gt jene auf der Karte ein).";
	MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO = "Markiert die n\195\164chste empfangene Notiz nur als Kurz-Notiz (und f\195\188gt jene nicht auf der Karte ein).";
	MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO	= "Kurz-Notizen nicht mehr anzeigen.";
	MAPNOTES_CHAT_COMMAND_MNTLOC_INFO	= "Setzt eine tloc auf der Karte.";
	MAPNOTES_CHAT_COMMAND_QUICKNOTE		= "F\195\188gt auf der momentanen Position auf der Karte eine Notiz ein.";
	MAPNOTES_CHAT_COMMAND_QUICKTLOC		= "F\195\188gt auf der angegebenen tloc Position auf der Karte, in der momentanen Zone, eine Notiz ein.";
	MAPNOTES_MAPNOTEHELP			= "Dieser Befehl kann nur zum Einf\195\188gen einer Notiz benutzt werden.";
	MAPNOTES_ONENOTE_OFF			= "Eine Notiz zulassen: AUS";
	MAPNOTES_ONENOTE_ON			= "Eine Notiz zulassen: AN";
	MAPNOTES_MININOTE_SHOW_0		= "N\195\164chste als Kurz-Notiz: AUS";
	MAPNOTES_MININOTE_SHOW_1		= "N\195\164chste als Kurz-Notiz: AN";
	MAPNOTES_MININOTE_SHOW_2		= "N\195\164chste als Kurz-Notiz: IMMER";
	MAPNOTES_DECLINE_SLASH			= "Notiz kann nicht hinzugef\195\188gt werden, zuviele Notizen in |cFFFFD100%s|r.";
	MAPNOTES_DECLINE_SLASH_NEAR		= "Notiz kann nicht hinzugef\195\188gt werden, sie befindet sich zu nahe an |cFFFFD100%q|r in |cFFFFD100%s|r.";
	MAPNOTES_DECLINE_GET			= "Notiz von |cFFFFD100%s|r konnte nicht empfangen werden: zu viele Notizen in |cFFFFD100%s|r, oder Empfang in den Einstellungen deaktiviert.";
	MAPNOTES_ACCEPT_SLASH			= "Notiz auf der Karte von |cFFFFD100%s|r hinzugef\195\188gt.";
	MAPNOTES_ACCEPT_GET			= "Notiz von |cFFFFD100%s|r in |cFFFFD100%s|r empfangen.";
	MAPNOTES_PARTY_GET			= "|cFFFFD100%s|r hat eine neue Gruppen-Notiz in |cFFFFD100%s|r hinzugef\195\188gt.";
	MAPNOTES_DECLINE_NOTETONEAR		= "|cFFFFD100%s|r hat versucht dir in |cFFFFD100%s|r eine Notiz zu senden, aber jene war zu nahe bei |cFFFFD100%q|r.";
	MAPNOTES_QUICKNOTE_NOTETONEAR		= "Notiz konnte nicht erstellt werden: Du befindest dich zu nahe bei |cFFFFD100%s|r.";
	MAPNOTES_QUICKNOTE_NOPOSITION		= "Notiz konnte nicht erstellt werden: momentane Position konnte nicht ermittelt werden.";
	MAPNOTES_QUICKNOTE_DEFAULTNAME		= "Schnell-Notiz";
	MAPNOTES_QUICKNOTE_OK			= "Notiz auf der Karte in |cFFFFD100%s|r erstellt.";
	MAPNOTES_QUICKNOTE_TOOMANY		= "Es befinden sich bereits zu viele Notizen auf der Karte von |cFFFFD100%s|r.";
	MAPNOTES_QUICKTLOC_NOTETONEAR		= "Notiz konnte nicht erstellt werden: Die Position ist zu nahe bei |cFFFFD100%s|r.";
	MAPNOTES_QUICKTLOC_NOZONE		= "Notiz konnte nicht erstellt werden: momentane Zone konnte nicht ermittelt werden.";
	MAPNOTES_QUICKTLOC_NOARGUMENT		= "Benutzung: '/quicktloc xx,yy [Icon] [Title]'.";
	MAPNOTES_SETMININOTE			= "Setzt die Notiz als neue Kurz-Notiz.";
	MAPNOTES_THOTTBOTLOC			= "Thottbot Ortsangabe";
	MAPNOTES_PARTYNOTE			= "Gruppen-Notiz";

	-- Drop Down Menu
	MAPNOTES_SHOWNOTES		= "Notizen anzeigen";
	MAPNOTES_DROPDOWNTITLE		= "Karten Notizen";
	MAPNOTES_DROPDOWNMENUTEXT	= "Optionen";

	MapNotes_ZoneShift = {
		[0] = { [0] = 0 },
		[1] = { 1, 2, 3, 4, 17, 14, 20, 5, 7, 6, 8, 9, 10, 11, 12, 13, 15, 16, 18, 19, 21 },
		[2] = { 1, 2, 20, 14, 25, 3, 6, 16, 10, 15, 19, 5, 4, 23, 9, 7, 8, 11, 12, 13, 17, 18, 21, 22, 24 },
	};

	MapNotes_ZoneShift[1][0] = 0;
	MapNotes_ZoneShift[2][0] = 0;

	MapNotes_Const = {};
	MapNotes_Const["Warsongschlucht"] = { scale = 0.035, xoffset = 0.41757282062541, 
                         yoffset = 0.33126468682991, xscale = 12897.3, yscale = 8638.1 };
	MapNotes_Const["Alteractal"] = { scale = 0.035, xoffset = 0.41757282062541, 
                         yoffset = 0.33126468682991, xscale = 12897.3, yscale = 8638.1 };

end