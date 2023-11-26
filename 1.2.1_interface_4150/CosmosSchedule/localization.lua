-- Version : English - Thott

SCHEDULE_COMM				= {"/in","/pause","/delay"};
SCHEDULE_DESC				= "/in <seconds> <command> [<args> ...] |cFFCC9966[Note: /in CANNOT cast spells to prevent creation of bots]|r";
SCHEDULE_USAGE1				= "Usage: /in <seconds> <command> [<args> ...]";
SCHEDULE_USAGE2				= "Runs <command> with arguments <args> after <seconds> seconds pass.";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Vjeux

	SCHEDULE_COMM				= {"/dans","/pause"};
	SCHEDULE_DESC				= "/dans <secondes> <commande> [<args> ...]";
	SCHEDULE_USAGE1				= "Utilisation : /dans <secondes> <commande> [<args> ...]";
	SCHEDULE_USAGE2				= "Lance la <commande> avec les arguments <args> après <secondes> secondes.";

elseif ( GetLocale() == "deDE" ) then
	-- Translation by ??? and pc

	SCHEDULE_COMM		= {"/in","/pause","/verzögern"};
	SCHEDULE_DESC		= "/in <Sekunden> <Befehl> [<args> ...]";
	SCHEDULE_USAGE1		= "Funktionsweise: /in <Sekunden> <Befehl> [<args> ...]";
	SCHEDULE_USAGE2		= "Startet den <Befehl> mit den Argumenten <args> nach <Sekunden> Sekunden.";

end
