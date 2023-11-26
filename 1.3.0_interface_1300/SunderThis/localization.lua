--=============================================================================
-- Variables
SUNDER_THIS_S = "~s";
SUNDER_THIS_N = "~n";
SUNDER_THIS_T = "~t";
SUNDER_THIS_DEF_FORMAT = SUNDER_THIS_N .. " " .. SUNDER_THIS_T .. "s";
--=============================================================================

--=============================================================================
-- Locale variables
if GetLocale() == "deDE" then
	SUNDER_ARMOR = "R\195\188stung zerrei\195\159en";
	SUNDER_ARMOR_DESC = "R\195\188stung um (%d+) verringert\.$";

	SUNDER_THIS_RESET_MSG = "SunderThis reset.";
	SUNDER_THIS_USAGE_MSG = "Usage: /sunderthis [reset||lock||format <format string>||help]";
	SUNDER_THIS_LOCKED_MSG = "SunderThis locked.";
	SUNDER_THIS_UNLOCKED_MSG = "SunderThis unlocked.";
	SUNDER_THIS_FORMAT_MSG = "SunderThis format set: ";

	SUNDER_THIS_HELP_MSG_TEXT0 = "SunderThis Help:";
	SUNDER_THIS_HELP_MSG_TEXT1 = SUNDER_THIS_USAGE_MSG;
	SUNDER_THIS_HELP_MSG_TEXT2 = "reset: Reset SunderThis' position to the top left of the target frame.";
	SUNDER_THIS_HELP_MSG_TEXT3 = "lock: Toggle the ability to drag SunderThis.";
	SUNDER_THIS_HELP_MSG_TEXT4 = "format <format string>: Set SunderThis' display format. Multiple options and other text can be used at once in the format. The default format is \"" .. SUNDER_THIS_DEF_FORMAT .. "\"";
	SUNDER_THIS_HELP_MSG_TEXT5 = "  ~s: Display the amount of armor sundered.";
	SUNDER_THIS_HELP_MSG_TEXT6 = "  ~n: Display the number of Sunder Armors applied.";
	SUNDER_THIS_HELP_MSG_TEXT7 = "  ~t: Display the |cff00ff00approximate|r time remaining.";
	SUNDER_THIS_HELP_MSG_TEXT8 = "help: Display this message";
	SUNDER_THIS_HELP_MSG = {
		SUNDER_THIS_HELP_MSG_TEXT0,
		SUNDER_THIS_HELP_MSG_TEXT1,
		SUNDER_THIS_HELP_MSG_TEXT2,
		SUNDER_THIS_HELP_MSG_TEXT3,
		SUNDER_THIS_HELP_MSG_TEXT4,
		SUNDER_THIS_HELP_MSG_TEXT5,
		SUNDER_THIS_HELP_MSG_TEXT6,
		SUNDER_THIS_HELP_MSG_TEXT7,
		SUNDER_THIS_HELP_MSG_TEXT8,
	};

	SUNDER_THIS_RESET = "reset";
	SUNDER_THIS_LOCK = "lock";
	SUNDER_THIS_FORMAT = "format";
	SUNDER_THIS_HELP = "help";
else --GetLocale() == "enUS", "frFR", ...
	SUNDER_ARMOR = "Sunder Armor";
	SUNDER_ARMOR_DESC = "Armor decreased by (%d+)\.$";

	SUNDER_THIS_RESET_MSG = "SunderThis reset.";
	SUNDER_THIS_USAGE_MSG = "Usage: /sunderthis [reset||lock||format <format string>||help]";
	SUNDER_THIS_LOCKED_MSG = "SunderThis locked.";
	SUNDER_THIS_UNLOCKED_MSG = "SunderThis unlocked.";
	SUNDER_THIS_FORMAT_MSG = "SunderThis format set: ";

	SUNDER_THIS_HELP_MSG_TEXT0 = "SunderThis Help:";
	SUNDER_THIS_HELP_MSG_TEXT1 = SUNDER_THIS_USAGE_MSG;
	SUNDER_THIS_HELP_MSG_TEXT2 = "reset: Reset SunderThis' position to the top left of the target frame.";
	SUNDER_THIS_HELP_MSG_TEXT3 = "lock: Toggle the ability to drag SunderThis.";
	SUNDER_THIS_HELP_MSG_TEXT4 = "format <format string>: Set SunderThis' display format. Multiple options and other text can be used at once in the format. The default format is \"" .. SUNDER_THIS_DEF_FORMAT .. "\"";
	SUNDER_THIS_HELP_MSG_TEXT5 = "  ~s: Display the amount of armor sundered.";
	SUNDER_THIS_HELP_MSG_TEXT6 = "  ~n: Display the number of Sunder Armors applied.";
	SUNDER_THIS_HELP_MSG_TEXT7 = "  ~t: Display the |cff00ff00approximate|r time remaining.";
	SUNDER_THIS_HELP_MSG_TEXT8 = "help: Display this message";
	SUNDER_THIS_HELP_MSG = {
		SUNDER_THIS_HELP_MSG_TEXT0,
		SUNDER_THIS_HELP_MSG_TEXT1,
		SUNDER_THIS_HELP_MSG_TEXT2,
		SUNDER_THIS_HELP_MSG_TEXT3,
		SUNDER_THIS_HELP_MSG_TEXT4,
		SUNDER_THIS_HELP_MSG_TEXT5,
		SUNDER_THIS_HELP_MSG_TEXT6,
		SUNDER_THIS_HELP_MSG_TEXT7,
		SUNDER_THIS_HELP_MSG_TEXT8,
	};

	SUNDER_THIS_RESET = "reset";
	SUNDER_THIS_LOCK = "lock";
	SUNDER_THIS_FORMAT = "format";
	SUNDER_THIS_HELP = "help";
end
--=============================================================================
