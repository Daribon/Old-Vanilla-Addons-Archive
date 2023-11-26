-- Version : English - Telo

CLOCK								= "Clock";
BINDING_HEADER_CLOCK				= "Clock Keys";
BINDING_NAME_TOGGLECLOCK			= "Toggle Clock";
TIME_PLAYED_SESSION					= "Time played this session: %s"; -- The amount of time played this session
CLOCK_TIME_DAY						= "%d day";
CLOCK_TIME_HOUR						= "%d hour";
CLOCK_TIME_MINUTE					= "%d minute";
CLOCK_TIME_SECOND					= "%d second";
EXP_PER_HOUR_LEVEL					= "Experience per hour this level: %.2f";
EXP_PER_HOUR_SESSION				= "Experience per hour this session: %.2f";
EXP_TO_LEVEL						= "Experience to level: %d (%.2f%% to go)";
TIME_TO_LEVEL_LEVEL					= "Time to level at this level's rate: %s";
TIME_TO_LEVEL_SESSION				= "Time to level at this session's rate: %s";
TIME_INFINITE						= "infinite";
HEALTH_PER_SECOND					= "Health regenerated per second: %d";
MANA_PER_SECOND						= "Mana regenerated per second: %d";
NONCOMBAT_TRAVEL_PERCENTAGE			= "Time spent traveling this session: %.2f%%";
NONCOMBAT_TRAVEL_DISTANCE			= "Distance traveled this session: %.2f";
TRAVEL_SPEED						= "Travel speed as a percentage of run speed: %.2f%%";

-- all options called CLOCK_OPTION_* were added 2004-10-20 by sarf - they'll need to be translated.

CLOCK_OPTION_HEADER					= "Clock";
CLOCK_OPTION_HEADER_INFO			= "This is an in-game clock.";

CLOCK_OPTION_ENABLE					= "Enable the clock";
CLOCK_OPTION_ENABLE_INFO			= "This will display the in-game clock with a nice mouseover.\nThe mouseover contains lots of interesting data and info.";

CLOCK_OPTION_TIME_OFFSET			= "Game time offset";
CLOCK_OPTION_TIME_OFFSET_INFO		= "This is the offset from the server time\nto your local time.";
CLOCK_OPTION_TIME_OFFSET_SLID_1		= "Offset";
CLOCK_OPTION_TIME_OFFSET_SLID_2		= " hour(s)";

CLOCK_OPTION_TWENTYFOUR_HOURS		= "Use 24-hour time format";
CLOCK_OPTION_TWENTYFOUR_HOURS_INFO	= "If checked, time will be displayed\nin twenty-four hour format (also called military time by some).";

CLOCK_OPTION_RESET_POSITION			= "Reset clock position";
CLOCK_OPTION_RESET_POSITION_INFO	= "Resets the position of the clock to its default.";
CLOCK_OPTION_RESET_POSITION_NAME	= "Reset";

CLOCK_OPTION_RESET_DATA				= "Reset the clock data";
CLOCK_OPTION_RESET_DATA_INFO		= "Resets the data gathered by the clock.";
CLOCK_OPTION_RESET_DATA_NAME		= "Reset";

-- added 2004-12-12 by sarf

CLOCK_OPTION_POPUPONMOUSEOVER		= "Popup info on mouse-over clock";
CLOCK_OPTION_POPUPONMOUSEOVER_INFO	= "If enabled, info will be displayed when you mouse-over the clock. If disabled, you'll need to to click the clock.";

-- added 2005-01-08 by JoeFaust

CLOCK_OPTION_HIDE_EXP = "Hide EXP stats";
CLOCK_OPTION_HIDE_EXP_INFO = "If checked, EXP/Hour and Time-to-level statistics will be hidden.";

-- added 2005-01-13 by arys

CLOCK_OPTION_ROUNDTRAVELSPEED		= "Round Travel Speed to nearest whole number";
CLOCK_OPTION_ROUNDTRAVELSPEED_INFO	= "There is a very slight variance in actual travel speed from moment to moment.  Enabling this option will round it off.";

-- added 2005-01-21 by sarf

CLOCK_MONEY							= "Money earned per hour this session: %s";
CLOCK_MONEY_PER_HOUR				= "%s / hour";
CLOCK_MONEY_PER_MINUTE				= "%s / minute";
CLOCK_MONEY_UNAVAILABLE				= "Unavailable";

CLOCK_MONEY_SEPERATOR				= ", ";
CLOCK_MONEY_GOLD					= "%d gold";
CLOCK_MONEY_SILVER					= "%d silver";
CLOCK_MONEY_COPPER					= "%d copper";
CLOCK_MONEY_GOLD_SHORT				= "%d g";
CLOCK_MONEY_SILVER_SHORT			= "%d s";
CLOCK_MONEY_COPPER_SHORT			= "%d c";

CLOCK_TIME_TWENTYFOURHOURS			= "%02d:%02d";
CLOCK_TIME_TWENTYFOURHOURSSECONDS	= "%02d:%02d:%02d";
CLOCK_TIME_TWELVEHOURSECONDSPM		= "%d:%02d:%02d PM";
CLOCK_TIME_TWELVEHOURSECONDSAM		= "%d:%02d:%02d AM";


CLOCK_OPTION_MONEY	 				= "Show money earned / hour";
CLOCK_OPTION_MONEY_INFO				= "Will show money earned per hour.\nThis does NOT take into consideration any expenses.";

CLOCK_OPTION_SECONDS 				= "Enable seconds (Experimental)";
CLOCK_OPTION_SECONDS_INFO			= "Will show HH:MM:SS on the clock as well as all timestamps.\nExperimental: May loose some seconds.";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Vjeux
	BINDING_NAME_TOGGLECLOCK			= "Afficher l'Horloge";

	CLOCK								= "Horloge";
	TIME_PLAYED_SESSION					= "Temps joué sur cette session : %s";
	CLOCK_TIME_DAY						= "%d jour";
	CLOCK_TIME_HOUR						= "%d heure";
	CLOCK_TIME_MINUTE					= "%d minute";
	CLOCK_TIME_SECOND					= "%d seconde";
	EXP_PER_HOUR_LEVEL					= "Expérience/heure ce niveau : %.2f";
	EXP_PER_HOUR_SESSION				= "Expérience/heure sur cette session : %.2f";
	HEALTH_PER_SECOND					= "Régénération de vie/seconde : %d";
	MANA_PER_SECOND						= "Régénération de mana/seconde : %d";
	EXP_TO_LEVEL						= "Expérience pour monter de niveau : %d (%.2f%% restants)";
	TIME_TO_LEVEL_LEVEL					= "Temps pour monter à la vitesse de ce niveau : %s";
	TIME_TO_LEVEL_SESSION				= "Temps pour monter à la vitesse de cette session : %s";
	TIME_INFINITE						= "infini";
	NONCOMBAT_TRAVEL_PERCENTAGE			= "Temps passé à voyager cette session : %.2f%%";
	NONCOMBAT_TRAVEL_DISTANCE			= "Distance parcourue cette session : %.2f";
	TRAVEL_SPEED						= "Vitesse actuelle : %.2f%%";	

elseif ( GetLocale() == "deDE" ) then
	-- Translation by ???? and pc

	BINDING_NAME_TOGGLECLOCK				= "Uhr Umschalter";
	CLOCK									= "Uhr";
	TIME_PLAYED_SESSION						= "Gespielte Zeit diese Sitzung %s";
	CLOCK_TIME_DAY							= "%d tag";
	CLOCK_TIME_HOUR							= "%d stunde";
	CLOCK_TIME_MINUTE						= "%d minute";
	CLOCK_TIME_SECOND						= "%d sekunde";
	EXP_PER_HOUR_LEVEL						= "Erfahrung pro Stunde dieses Level : %.2f";
	EXP_PER_HOUR_SESSION					= "Erfahrung pro Stunde diese Sitzung: %.2f";
	HEALTH_PER_SECOND						= "Leben regeneriert pro Sekunde : %d";
	MANA_PER_SECOND							= "Mana regeneriert pro Sekunde: %d";
	EXP_TO_LEVEL							= "Erfahrung pro Level: %d (noch %.2f%%)";
	TIME_TO_LEVEL_LEVEL						= "Zeit um Level aufzusteigen (unter Beibehaltung der Aufstiegsgeschwindigkeit des aktuellen Levels): %s";
	TIME_TO_LEVEL_SESSION					= "Zeit um Level auzusteigen (unter Beibehaltung der Aufstiegsgeschwindigkeit dieser Sitzung): %s";
	TIME_INFINITE							= "Unedlich";
	NONCOMBAT_TRAVEL_PERCENTAGE				= "Verbrachte Zeit auf Reise: %.2f%%";
	NONCOMBAT_TRAVEL_DISTANCE				= "Zurückgelegte Enfernung diese Sitzung: %.2f";
	TRAVEL_SPEED							= "Reisegeschwindigkeit (in Prozent von Renngeschwindigkeit): %.2f%%";


end
