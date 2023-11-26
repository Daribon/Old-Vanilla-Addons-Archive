-- Version : German (by pc, StarDust)
-- Last Update : 08/16/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_CLOCK			= "Uhr";
	BINDING_NAME_TOGGLECLOCK		= "Uhr anzeigen/verbergen";
	
	-- Cosmos Configuration
	CLOCK_OPTION_HEADER			= "Uhr";
	CLOCK_OPTION_HEADER_INFO		= "Dies ist eine Uhr innerhalb von World of Warcraft.";

	CLOCK_OPTION_ENABLE			= "Uhr aktivieren";
	CLOCK_OPTION_ENABLE_INFO		= "Dies zeigt die Uhr im Spiel an und aktiviert erweiterte Statistiken\nzu deinem Charakter im Spiel wenn du den Mauszeiger\n\195\188ber die Uhr bewegst.";

	CLOCK_OPTION_TIME_OFFSET		= "Zeitverschiebung";
	CLOCK_OPTION_TIME_OFFSET_INFO		= "Dies ist die Zeitverschiebung zwischen der Serverzeit und deiner lokalen Uhrzeit, angegeben in Stunden.";
	CLOCK_OPTION_TIME_OFFSET_SLID_1		= "Verschiebung";
	CLOCK_OPTION_TIME_OFFSET_SLID_2		= " Std.";

	CLOCK_OPTION_TWENTYFOUR_HOURS		= "24 Stunden-Zeitformat verwenden";
	CLOCK_OPTION_TWENTYFOUR_HOURS_INFO	= "Wenn aktiviert, wird die Uhrzeit im 24 Stunden-Zeiformat angezeigt.";

	CLOCK_OPTION_RESET_POSITION		= "Position der Uhr zur\195\188cksetzen";
	CLOCK_OPTION_RESET_POSITION_INFO	= "Die Position der Uhr auf ihre Standardwerte zur\195\188cksetzen.";
	CLOCK_OPTION_RESET_POSITION_NAME	= "Zur\195\188cksetzen";

	CLOCK_OPTION_RESET_DATA			= "Uhr-Daten zur\195\188cksetzen";
	CLOCK_OPTION_RESET_DATA_INFO		= "Setzt die gesammelten Daten der Uhr f\195\188r die Statistiken zur\195\188ck.";
	CLOCK_OPTION_RESET_DATA_NAME		= "Zur\195\188cksetzen";

	CLOCK_OPTION_POPUPONMOUSEOVER		= "Statistiken anzeigen, wenn Mauszeiger \195\188ber Uhr";
	CLOCK_OPTION_POPUPONMOUSEOVER_INFO	= "Wenn aktiviert, werden einige Statistiken \195\188ber den Charaker angezeigt, falls der Mauszeiger \195\188ber die Uhr bewegt wird.";
	
	CLOCK_OPTION_HIDE_EXP			= "Statistiken zur Erfahrung verbergen";
	CLOCK_OPTION_HIDE_EXP_INFO		= "Wenn aktiviert, werden die Angaben zu Erfahrung/Stunde sowie\nverbleibende Erfahrung bis Levelanstieg nicht angezeigt.";

	CLOCK_OPTION_ROUNDTRAVELSPEED		= "Reisegeschwindigkeit auf die n\195\164chste ganze Zahl runden";
	CLOCK_OPTION_ROUNDTRAVELSPEED_INFO	= "Die momentane Reisegeschwindigkeit ver\195\164ndert sich st\195\164ndig, auch wenn sie scheinbar gleich bleibt. Aktiviere diese Option um die angezeigte Reisegeschwindigkeit zu runden.";

	CLOCK_OPTION_MONEY	 		= "Eingenommenes Geld pro Stunde anzeigen";
	CLOCK_OPTION_MONEY_INFO			= "Wenn aktiviert, werden die Einnahmen pro Stunde angezeigt.\nAusgaben werden bei dieser Berechnung NICHT ber\195\188cksichtigt.";

	CLOCK_OPTION_SECONDS 			= "Sekunden aktivieren (Experimentell)";
	CLOCK_OPTION_SECONDS_INFO		= "Wenn aktiviert, wird die Uhrzeit als HH:MM:SS\nsowie alle Zeitstempel angezeigt.\nExperimentell: M\195\182glicherweise gehen einige Sekunden verloren.";

	-- Interface Configuration
	CLOCK					= "Uhr";
	TIME_PLAYED_SESSION			= "Spielzeit diese Sitzung: %s";
	TIME_PLAYED_TOTAL			= "Spielzeit Gesamt: %s";
	TIME_PLAYED_LEVEL			= "Spielzeit dieser Level: %s";
	CLOCK_TIME_DAY				= "%d Tag";
	CLOCK_TIME_HOUR				= "%d Stunde";
	CLOCK_TIME_MINUTE			= "%d Minute";
	CLOCK_TIME_SECOND			= "%d Sekunde";
	EXP_PER_HOUR_LEVEL			= "Erfahrung pro Stunde (Level): %.2f";
	EXP_PER_HOUR_SESSION			= "Erfahrung pro Stunde (Sitzung): %.2f";
	EXP_TO_LEVEL				= "Erfahrung (Level): %d (noch %.2f%% bis Aufstieg)";
	TIME_TO_LEVEL_LEVEL			= "Zeit bis Levelaufstieg (Level): %s";
	TIME_TO_LEVEL_SESSION			= "Zeit bis Levelaufstieg (Sitzung): %s";
	TIME_INFINITE				= "unendlich";
	HEALTH_PER_SECOND			= "Gesundheits-Regeneration pro Sekunde: %d";
	MANA_PER_SECOND				= "Mana-Regeneration pro Sekunde: %d";
	NONCOMBAT_TRAVEL_PERCENTAGE		= "Verbrachte Zeit auf Reisen (Sitzung): %.2f%%";
	NONCOMBAT_TRAVEL_DISTANCE		= "Zur\195\188ckgelegte Enfernung (Sitzung): %.2f";
	TRAVEL_SPEED				= "Reisegeschwindigkeit (Prozent der Laufgeschw.): %.2f%%";

	CLOCK_MONEY				= "Geld eingenommen pro Stunde (Sitzung): %s";
	CLOCK_MONEY_PER_HOUR			= "%s / Stunde";
	CLOCK_MONEY_PER_MINUTE			= "%s / Minute";
	CLOCK_MONEY_UNAVAILABLE			= "Nicht verf\195\188gbar";
	CLOCK_MONEY_SEPERATOR			= ", ";
	CLOCK_MONEY_GOLD			= "%d Gold";
	CLOCK_MONEY_SILVER			= "%d Silber";
	CLOCK_MONEY_COPPER			= "%d Kupfer";
	CLOCK_MONEY_GOLD_SHORT			= "%d G";
	CLOCK_MONEY_SILVER_SHORT		= "%d S";
	CLOCK_MONEY_COPPER_SHORT		= "%d K";

	CLOCK_TIME_TWENTYFOURHOURS		= "%02d:%02d";
	CLOCK_TIME_TWENTYFOURHOURSSECONDS	= "%02d:%02d:%02d";
	CLOCK_TIME_TWELVEHOURSECONDSPM		= "%d:%02d:%02d PM";
	CLOCK_TIME_TWELVEHOURSECONDSAM		= "%d:%02d:%02d AM";

	CLOCK_PART_PLURAL			= "n";

	CLOCK_BORDER_OPTION_HEADER		= "Uhr Rahmen";

end