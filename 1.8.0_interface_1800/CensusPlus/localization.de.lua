-- Version : German (by MadMax-X, StarDust)
-- Last Update : 10/17/2005

if ( GetLocale() == "deDE" ) then
	
	-- Cosmos Configuration
	CENSUSPlus_BUTTON_TEXT		= "Census+"; 
	CENSUSPlus_BUTTON_SUBTEXT	= "Realm Census"; 
	CENSUSPlus_BUTTON_TIP		= "Hier klicken um Census+ anzuzeigen oder zu verstecken."; 
	CENSUSPlus_HELP			= " Benutze /censusplus um das Census+ Fenster zu \195\182ffnen."; 

	-- Chat Configuration
	CENSUSPlus_MSG1			= " Geladen - Benutze /censusplus or /census+ um das Hauptfenster zu \195\182ffnen."; 
	CENSUSPlus_MSG2			= "Mit /censusdate kann das aktuelle Datum im Format MM-DD-YYYY gesetzt werden, z.B. 12-25-2004"; 

	-- Interface Configuration
	CENSUSPlus_UPLOAD		= "Lade deine Census+ Daten bei www.WarcraftRealms.com hoch!"; 
	CENSUSPlus_SETTINGDATE		= "Datum wird gesetzt => "; 
	CENSUSPlus_PAUSE		= "Pause"; 
	CENSUSPlus_UNPAUSE		= "Weiter"; 
	CENSUSPlus_STOP			= "Stop";
	CENSUSPlus_PRUNE		= "Bereinigen";

	CENSUSPlus_TAKECENSUS		= "Z\195\164hle alle aktiven \nSpieler deiner Fraktion \nauf diesem Server."; 
	CENSUSPlus_PURGEDATABASE	= "L\195\182sche die Datenbank \nf\195\188r diesen Server \nund diese Fraktion."; 
	CENSUSPlus_PAUSECENSUS		= "Pausiere die laufende Z\195\164hlung.";
	CENSUSPlus_UNPAUSECENSUS	= "Setze die laufende Z\195\164hlung fort.";
	CENSUSPlus_STOPCENSUS		= "Stoppe die laufende Z\195\164hlung.";
	CENSUSPlus_PRUNECENSUS		= "Bereinigt die Datenbank, indem\nalle Charaktere entfernt werden\ndie l\195\164nger als 30 Tage nicht\nmehr online erfasst wurden.";

	CENSUSPlus_PURGEMSG		= "Charakterdatenbank wurde bereinigt."; 
	CENSUSPlus_ISINPROGRESS		= "Es l\195\164uft bereits eine Z\195\164hlung, versuch es bitte sp\195\164ter nochmal."; 
	CENSUSPlus_TAKINGONLINE		= "Z\195\164hlung der gerade aktiven Charaktere..."; 
	CENSUSPlus_PLZUPDATEDATE	= "Bitte benutze /censusdate um das aktuelle Datum zu setzen und somit die Auswertung genauer zu machen. (Format: /censusdate MM-DD-YYYY, z.B. /censusdate 12-25-2004"; 
	CENSUSPlus_NOCENSUS		= "Es l\195\164uft gerade keine Z\195\164hlung."; 
	CENSUSPlus_FINISHED		= "Z\195\164hlung beendet. %s neue Charaktere gefunden, %s aktualisiert."; 
	CENSUSPlus_TOOMANY		= "FEHLER: Zu viele \195\188bereinstimmende Charaktere: %s"; 
	CENSUSPlus_WAITING		= "Warte, um /who - Abfrage zu senden..."; 
	CENSUSPlus_SENDING		= "Sende /who %s"; 
	CENSUSPlus_PROCESSING		= "Verarbeite %s Charaktere."; 

	CENSUSPlus_REALMNAME		= "Server: %s"; 
	CENSUSPlus_REALMUNKNOWN		= "Server: Unbekannt"; 
	CENSUSPlus_FACTION		= "Fraktion: %s"; 
	CENSUSPlus_FACTIONUNKNOWN	= "Fraktion: Unbekannt";
	CENSUSPlus_LOCALE		= "Locale : %s";
	CENSUSPlus_LOCALEUNKNOWN	= "Locale : Unbekannt";
	CENSUSPlus_TOTALCHAR		= "Charaktere Gesamte : %d"; 
	CENSUSPlus_TOTALCHAR_0		= "Charaktere Gesamte : 0"; 
	CENSUSPlus_TOTALCHARXP		= "Charakter-XP Gesamte : %d"; 
	CENSUSPlus_TOTALCHARXP_0	= "Charakter-XP Gesamte : 0"; 
	CENSUSPlus_AUTOCLOSEWHO		= "Who autom. schlie\195\159en"; 
	CENSUSPlus_SHOWMINI		= "Mini-Button beim Start";
	CENSUSPlus_UNGUILDED		= "(ohne Gilde)";
	CENSUSPlus_TAKE			= "Z\195\164hlen";
	CENSUSPlus_TOPGUILD		= "Top Gilden nach XP";
	CENSUSPlus_RACE			= "Rassen";
	CENSUSPlus_CLASS		= "Klassen";
	CENSUSPlus_LEVEL		= "Level";
	CENSUSPlus_PURGE		= "L\195\182schen";

	CENSUSPlus_MAXIMIZE		= "Census+ Fenster maximieren.";
	CENSUSPlus_MINIMIZE		= "Census+ Fenster minimieren.";
	CENSUSPlus_BUTTON_MINIMIZE	= "Minimieren";

	CENSUSPlus_HORDE		= "Horde";
	CENSUSPlus_ALLIANCE		= "Allianz";

	CENSUSPlus_DRUID		= "Druide";
	CENSUSPlus_HUNTER		= "J\195\164ger";
	CENSUSPlus_MAGE			= "Magier";
	CENSUSPlus_PRIEST		= "Priester";
	CENSUSPlus_ROGUE		= "Schurke";
	CENSUSPlus_WARLOCK		= "Hexenmeister";
	CENSUSPlus_WARRIOR		= "Krieger";
	CENSUSPlus_SHAMAN		= "Schamane";
	CENSUSPlus_PALADIN		= "Paladin";

	CENSUSPlus_DWARF		= "Zwerg"; 
	CENSUSPlus_GNOME		= "Gnom"; 
	CENSUSPlus_HUMAN		= "Mensch"; 
	CENSUSPlus_NIGHTELF		= "Nachtelf"; 
	CENSUSPlus_ORC			= "Orc"; 
	CENSUSPlus_TAUREN		= "Tauren"; 
	CENSUSPlus_TROLL		= "Troll"; 
	CENSUSPlus_UNDEAD		= "Untoter";     

	CENSUSPLUS_US_LOCALE		= "Bitte gib an, ob du auf einem US-Server spielst.";
	CENSUSPLUS_EU_LOCALE		= "Bitte gib an, ob du auf einem EURO-Server spielst.";
	CENSUSPLUS_LOCALE_SELECT	= "Bitte gib an, ob du auf einem US- oder EURO-Server spielst.";

	CENSUSPlus_BUTTON_OPTIONS	= "Optionen";
	CENSUSPlus_OPTIONS_HEADER	= "Census+ Optionen";
	CENSUSPlus_ISINBG		= "Du befindest dich momentan auf einem Schalchtfeld und daher kann Census+ keine Abfrage duchf\195\188hren.";

	CENSUS_OPTIONS_BUTPOS		= "Button Position";
	CENSUS_OPTIONS_BUTSHOW		= "Minimap-Button";

	CENSUS_BUTTON_TOOLTIP		= "CensusPlus \195\182ffnen.";

end