--[[

	Soon to be translation lua file

--]]

ACW_ACW = "Alarm Clock Wrangler";
ACW_DEFAULT_ALARMTEXT = "Alarm Text!";
ACW_DEFAULT_TIMEFORMAT = 12;
ACW_LOADED = "Alarm Clock Wrangler Loaded...";
ACW_HELP = "Help...";
ACW_ON = "Alarm Clock Wrangler is on...";
ACW_OFF = "Alarm Clock Wrangler is off...";
ACW_OFFSET_HOUR = " hour";
ACW_OFFSET_HOURS = " hours";
ACW_OFFSET_ERROR = "Alarm Clock Wrangler offset must be between -12 and +12";
ACW_RESET = "Alarm Clock Wrangler's default options have been reset...";
ACW_UNKNOWN = "Alarm Clock Wrangler:  Unknown message.  Type /acw help for a list of valid commands";
ACW_ALARM1_ON = "Alarm Clock Wrangler: Alarm 1 is on...";
ACW_ALARM1_OFF = "Alarm Clock Wrangler: Alarm 1 is off...";
ACW_SNOOZE = "Alarm Clock Wrangler: ";
ACW_STATUS = "Alarm Clock Wrangler Status";
ACW_CURRENTLY_ALARMING = "Currently Alarming: ";
ACW_CURRENTLY_SNOOZING = "Currently Snoozing: ";
ACW_ALARM_STATUS = "Alarm Status:";
ACW_ALARM1 = "Alarm 1";
ACW_ALARM2 = "Alarm 2";
ACW_ALARM3 = "Alarm 3";
ACW_SERVER_TIME_STATUS = "Server Time:";
ACW_TIME = "Time: ";
ACW_TOD = "TOD: ";
ACW_STR_OFF = "Off";
ACW_STR_ON = "On";
ACW_STR_NIGHT = "Night";
ACW_STR_DAY = "Day";
ACW_NONE = "None";
ACW_SNOOZING = "Snoozing...";
ACW_ALARMING = "Alarming...";
ACW_ACKNOWLEDGED = "Acknowledged...";
ACW_SNOOZE_BUTTON = "Snooze Button";
ACW_ACKNOWLEDGE_ALARMS_BUTTON = "Acknowledge Alarm(s)";
ACW_SNOOZE_TIME = "Snooze Time:";

ACW_OPTIONS_TITLE = "Alarm Clock Wrangler Options";
ACW_OPTIONS_TIMEFORMAT = "Time Format:";
ACW_OPTIONS_OFFSET = "Offset (Hours):";
ACW_OPTIONS_OFFSET_MIN = "Offset (Minutes):";
ACW_OPTIONS_LOCK = "Lock Position";
ACW_OPTIONS_TEXTURE = "Show Day/Night Texture";

ACW_OPTIONS_ON = "On/Off";
ACW_OPTIONS_HOURS = " Hour";
ACW_OPTIONS_ALARM1ON = "Alarm 1 On/Off";
ACW_OPTIONS_ALARM2ON = "Alarm 2 On/Off";
ACW_OPTIONS_ALARM3ON = "Alarm 3 On/Off";
ACW_OPTIONS_ALARM1TEXT = "Alarm 1 Text:";
ACW_OPTIONS_ALARM2TEXT = "Alarm 2 Text:";
ACW_OPTIONS_ALARM3TEXT = "Alarm 3 Text:";
ACW_OPTIONS_ALARM1TIME = "Alarm 1 Time:";
ACW_OPTIONS_ALARM1TIME = "Alarm 1 Time:";
ACW_OPTIONS_ALARM2TIME = "Alarm 2 Time:";
ACW_OPTIONS_ALARM3TIME = "Alarm 3 Time:";

ACW_ERROR_ALARMTIME = "ERROR: Invalid alarm time!";
ACW_ERROR_ALARMMESSAGE = "ERROR: Invalid alarm text entry!";
ACW_ERROR_SNOOZEMESSAGE = "ERROR: Invalid snooze time!";

ACW_PM = " PM";
ACW_AM = " AM";

if ( GetLocale() == "frFR" ) then
	ACW_ACW = "Alarm Clock Wrangler";
	ACW_DEFAULT_ALARMTEXT = "Alarm Text!";
	ACW_DEFAULT_TIMEFORMAT = 24;
	ACW_LOADED = "Alarm Clock Wrangler Loaded...";
	ACW_HELP = "Help...";
	ACW_ON = "Alarm Clock Wrangler is on...";
	ACW_OFF = "Alarm Clock Wrangler is off...";
	ACW_OFFSET_HOUR = " hour";
	ACW_OFFSET_HOURS = " hours";
	ACW_OFFSET_ERROR = "Alarm Clock Wrangler offset must be between -12 and +12";
	ACW_RESET = "Alarm Clock Wrangler's default options have been reset...";
	ACW_UNKNOWN = "Alarm Clock Wrangler:  Unknown message.  Type /acw help for a list of valid commands";
	ACW_ALARM1_ON = "Alarm Clock Wrangler: Alarm 1 is on...";
	ACW_ALARM1_OFF = "Alarm Clock Wrangler: Alarm 1 is off...";
	ACW_SNOOZE = "Alarm Clock Wrangler: ";
	ACW_STATUS = "Alarm Clock Wrangler Status";
	ACW_CURRENTLY_ALARMING = "Currently Alarming: ";
	ACW_CURRENTLY_SNOOZING = "Currently Snoozing: ";
	ACW_ALARM_STATUS = "Alarm Status:";
	ACW_ALARM1 = "Alarm 1";
	ACW_ALARM2 = "Alarm 2";
	ACW_ALARM3 = "Alarm 3";
	ACW_SERVER_TIME_STATUS = "Server Time:";
	ACW_TIME = "Time: ";
	ACW_TOD = "TOD: ";
	ACW_STR_OFF = "Off";
	ACW_STR_ON = "On";
	ACW_STR_NIGHT = "Night";
	ACW_STR_DAY = "Day";
	ACW_NONE = "None";
	ACW_SNOOZING = "Snoozing...";
	ACW_ALARMING = "Alarming...";
	ACW_ACKNOWLEDGED = "Acknowledged...";
	ACW_SNOOZE_BUTTON = "Snooze Button";
	ACW_ACKNOWLEDGE_ALARMS_BUTTON = "Acknowledge Alarm(s)";
	ACW_SNOOZE_TIME = "Snooze Time:";

	ACW_OPTIONS_TITLE = "Alarm Clock Wrangler Options";
	ACW_OPTIONS_TIMEFORMAT = "Time Format:";
	ACW_OPTIONS_OFFSET = "Offset (Hours):";
	ACW_OPTIONS_OFFSET_MIN = "Offset (Minutes):";
	ACW_OPTIONS_LOCK = "Lock Position";
	ACW_OPTIONS_TEXTURE = "Show Day/Night Texture";

	ACW_OPTIONS_ON = "On/Off";
	ACW_OPTIONS_HOURS = " Hour";

	ACW_OPTIONS_ALARM1ON = "Alarm 1 On/Off";
	ACW_OPTIONS_ALARM2ON = "Alarm 2 On/Off";
	ACW_OPTIONS_ALARM3ON = "Alarm 3 On/Off";
	ACW_OPTIONS_ALARM1TEXT = "Alarm 1 Text:";
	ACW_OPTIONS_ALARM2TEXT = "Alarm 2 Text:";
	ACW_OPTIONS_ALARM3TEXT = "Alarm 3 Text:";
	ACW_OPTIONS_ALARM1TIME = "Alarm 1 Time:";
	ACW_OPTIONS_ALARM1TIME = "Alarm 1 Time:";
	ACW_OPTIONS_ALARM2TIME = "Alarm 2 Time:";
	ACW_OPTIONS_ALARM3TIME = "Alarm 3 Time:";

	ACW_ERROR_ALARMTIME = "ERROR: Invalid alarm time!";
	ACW_ERROR_ALARMMESSAGE = "ERROR: Invalid alarm text entry!";
	ACW_ERROR_SNOOZEMESSAGE = "ERROR: Invalid snooze time!";

	ACW_PM = " PM";
	ACW_AM = " AM";
elseif (GetLocale() == "deDE") then
	ACW_ACW = "Zankender Wecker";
	ACW_DEFAULT_ALARMTEXT = "Weckruf Nachricht!";
	ACW_DEFAULT_TIMEFORMAT = 24;
	ACW_LOADED = "Zankender Wecker geladen...";
	ACW_HELP = "Hilfe...";
	ACW_ON = "Zankender Wecker ist an...";
	ACW_OFF = "Zankender Wecker ist aus...";
	ACW_OFFSET_HOUR = " Stunden";
	ACW_OFFSET_HOURS = " Stunden";
	ACW_OFFSET_ERROR = "Der Versatz f�r Zankender Wecker mu� zwischen -12 und +12 liegen";
	ACW_RESET = "Einstellungen vom zankenden Wecker zur�ckgesetzt...";
	ACW_UNKNOWN = "Zankender Wecker:  Unbekannter Befehl.  Gebe /acw help f�r eine Liste g�ltiger Befehle ein.";
	ACW_ALARM1_ON = "Zankender Wecker: Weckruf 1 ist an...";
	ACW_ALARM1_OFF = "Zankender Wecker: Weckruf 1 ist aus...";
	ACW_SNOOZE = "Zankender Wecker: ";
	ACW_STATUS = "Zankender Wecker Status";
	ACW_CURRENTLY_ALARMING = "Verbreite Weckruf: ";
	ACW_CURRENTLY_SNOOZING = "Schlummere bei: ";
	ACW_ALARM_STATUS = "Weckruf Status:";
	ACW_ALARM1 = "Weckruf 1";
	ACW_ALARM2 = "Weckruf 2";
	ACW_ALARM3 = "Weckruf 3";
	ACW_SERVER_TIME_STATUS = "Server Zeit:";
	ACW_TIME = "Zeit: ";
	ACW_TOD = "Tageszeit: ";
	ACW_STR_OFF = "Aus";
	ACW_STR_ON = "An";
	ACW_STR_NIGHT = "Nacht";
	ACW_STR_DAY = "Tag";
	ACW_NONE = "Keine";
	ACW_SNOOZING = "schlummernd...";
	ACW_ALARMING = "weckend...";
	ACW_ACKNOWLEDGED = "best�tigt...";
	ACW_SNOOZE_BUTTON = "Schlummerknopf";
	ACW_ACKNOWLEDGE_ALARMS_BUTTON = "Best�tige Weckruf(e)";
	ACW_SNOOZE_TIME = "Schlummerzeit:";

	ACW_OPTIONS_TITLE = "Einstellungen zankender Wecker";
	ACW_OPTIONS_TIMEFORMAT = "Zeit Format:";
	ACW_OPTIONS_OFFSET = "Versatz (Stunden):";
	ACW_OPTIONS_OFFSET_MIN = "Versatz (Minuten):";
	ACW_OPTIONS_LOCK = "Position fixiert";
	ACW_OPTIONS_TEXTURE = "Zeige Tag/Nacht Bild";

	ACW_OPTIONS_ON = "An/Aus";
	ACW_OPTIONS_HOURS = " Stunde";
	ACW_OPTIONS_ALARM1ON = "Weckruf 1 An/Aus";
	ACW_OPTIONS_ALARM2ON = "Weckruf 2 An/Aus";
	ACW_OPTIONS_ALARM3ON = "Weckruf 3 An/Aus";
	ACW_OPTIONS_ALARM1TEXT = "Weckruf 1 Nachricht:";
	ACW_OPTIONS_ALARM2TEXT = "Weckruf 2 Nachricht:";
	ACW_OPTIONS_ALARM3TEXT = "Weckruf 3 Nachricht:";
	ACW_OPTIONS_ALARM1TIME = "Weckruf 1 Zeit:";
	ACW_OPTIONS_ALARM2TIME = "Weckruf 2 Zeit:";
	ACW_OPTIONS_ALARM3TIME = "Weckruf 3 Zeit:";

	ACW_ERROR_ALARMTIME = "FEHLER: Ung�ltige Weckzeit!";
	ACW_ERROR_ALARMMESSAGE = "FEHLER: Ung�ltige Wecknachricht!";
	ACW_ERROR_SNOOZEMESSAGE = "FEHLER: Ung�ltige Schlummerzeit!";

	ACW_PM = "";
	ACW_AM = "";
end