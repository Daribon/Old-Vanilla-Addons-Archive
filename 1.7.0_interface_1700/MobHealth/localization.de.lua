-- Version: German
-- $Id: localization.de.lua 2271 2005-08-10 01:59:01Z sasmiraa $
-- By StarDust

if ( GetLocale() == "deDE" ) then

	MOBHEALTH_CONFIG_HEADER			= "Mob Gesundheit";
	MOBHEALTH_CONFIG_HEADER_INFO            = "Einstellungen f\195\188r das AddOn 'Mob Gesundheit', welches die Gesundheit des Ziels berechnet.";

	MOBHEALTH_ENABLED                       = "Mob Gesundheit verwenden";
	MOBHEALTH_ENABLED_INFO                  = "Wenn aktiviert, wird nach dem ersten Treffer die Gesundheit des Ziels berechnet und im Zielfenster angezeigt.";

	MOBHEALTH_POSITION_SLIDER               = "";
	MOBHEALTH_POSITION_SLIDER_DESC          = "Position von Mob Gesundheit";
	MOBHEALTH_POSITION_SLIDER_INFO          = "Benutze den Schieberegler um die Position von Mob Gesundheit im Zielfenster festzulegen.";

	MOBHEALTH_STABLEMAX			= "St\195\164ndige Aktualisierung der Gesundheit";
	MOBHEALTH_STABLEMAX_INFO		= "Wenn aktiviert, wird die Gesundheit des Ziels fortlaufend neu berechnet.";

	MOBHEALTH_RESET_ALL			= "Gesamte Datenbank l\195\182schen";
	MOBHEALTH_RESET_ALL_INFO		= "L\195\182scht die gesamte bisher gespeicherte Datenbank.";
	MOBHEALTH_RESET_ALL_BUTTON		= "L\195\182schen";

	MOBHEALTH_RESET_TARGET			= "Zieldaten l\195\182schen";
	MOBHEALTH_RESET_TARGET_INFO		= "L\195\182scht die gespeicherten Daten des momentanen Ziels.";
	MOBHEALTH_RESET_TARGET_BUTTON		= "L\195\182schen";

	MOBHEALTH_CHAT_COMMAND_INFO             = "Mob Gesundheit aktivieren/deaktivieren";
	MOBHEALTH_CHAT_COMMAND_STABLEMAX	= " verwende stabile Max. Anzeige der Gesundheit";
	MOBHEALTH_CHAT_COMMAND_UNSTABLEMAX	= " verwende unsichere Max. Anzeige der Gesundheit";
	MOBHEALTH_CHAT_COMMAND_HELP_POS		= "Du musst die Position angeben: /mobhealth pos [Position]";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_1	= " Befehle:";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_2	= "  /mobhealth pos [Position]";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_3	= "    setzt die Position auf [Position]";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_4	= "    (relativ zum Zielfenster, Standard 22, negative Werte sind zul\195\164ssig)";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_5	= "  /mobhealth stablemax";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_6	= "    aktualisiert die Max. Anzeige der Gesundheit weniger oft (nur beim ersten Kampf mit";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_7	= "    diesem Gegner und zwischen K\195\164mpfen)";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_8	= "  /mobhealth unstablemax";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_9	= "    aktualisiert fortlaufend die Max. Anzeige der Gesundheit";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_10	= "  /mobhealth reset all";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_11	= "    l\195\182scht die gesamte Datenbank!";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_12	= "  /mobhealth reset/del/delete/rem/remove/clear";
	MOBHEALTH_CHAT_COMMAND_HELPTEXT_13	= "    l\195\182scht die Datenbank des momentanen Ziels";
	MOBHEALTH_CHAT_COMMAND_RESETDB		= " Datenbank wird zur\195\188ckgesetzt.";
	MOBHEALTH_CHAT_COMMAND_RESETTARGET	= " setze Daten zur\195\188ck f\195\188r ";
	MOBHEALTH_CHAT_COMMAND_SETPOS		= " Position gesetzt auf ";

end