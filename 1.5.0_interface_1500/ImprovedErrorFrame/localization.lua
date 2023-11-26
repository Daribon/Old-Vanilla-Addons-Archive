-- Version : English (by Vjeux, Mugendai)
-- $LastChangedBy: Sinaloit $
-- $Date: 2005-05-16 20:27:49 -0500 (Mon, 16 May 2005) $

-- Interface Configuration
IEF_FILE		= "File: ";
IEF_STRING		= "String: ";
IEF_LINE		= "Line: ";
IEF_COUNT		= "Count: ";
IEF_ERROR		= "Error: ";

IEF_CANCEL		= "Cancel";
IEF_CLOSE		= "Close";
IEF_REPORT		= "Report";

IEF_INFINITE		= "Infinite";

-- Slash command strings
IEF_NOTIFY_ON		= "ImprovedErrorFrame: Alert delay notification enabled.";
IEF_NOTIFY_OFF		= "ImprovedErrorFrame: Errors reported as they occur.";
IEF_BLINK_ON		= "ImprovedErrorFrame: Blink with pending errors.";
IEF_BLINK_OFF		= "ImprovedErrorFrame: Button will not blink.";
IEF_COUNT_ON		= "ImprovedErrorFrame: Display count of pending errors.";
IEF_COUNT_OFF		= "ImprovedErrorFrame: No pending error count.";
IEF_ALWAYS_ON		= "ImprovedErrorFrame: Always show error button.";
IEF_ALWAYS_OFF		= "ImprovedErrorFrame: Button shown upon notification.";
IEF_SOUND_ON		= "ImprovedErrorFrame: Sound played upon notification.";
IEF_SOUND_OFF		= "ImprovedErrorFrame: No sounds will be played.";
IEF_FORMAT_STR		= "Format: /ief <NOTIFY|BLINK|COUNT|ALWAYS|SOUND> <ON|OFF>";
IEF_FORMAT_STR_NOCHRON	= "Format: /ief <NOTIFY|COUNT|ALWAYS|SOUND> <ON|OFF>";
IEF_CURRENT_SETTINGS	= "Current Settings:";
IEF_BLINK_OPT		= "blink";
IEF_NOTIFY_OPT		= "notify";
IEF_COUNT_OPT		= "count";
IEF_ALWAYS_OPT		= "always";
IEF_SOUND_OPT		= "sound";
IEF_ON			= "on";
IEF_OFF			= "off";
IEF_HELP_TEXT		= "/ief - Improved Error Frame Configuration";

-- Tooltip Text
IEF_TOOLTIP		= "Click to view errors.";
-- Header Text
IEF_TITLE_TEXT		= "Queued Errors";
IEF_ERROR_TEXT		= "Realtime Errors";

-- Khaos/Cosmos descriptions
IEF_OPTION_TEXT		= "Improved Error Frame";
IEF_OPTION_HELP		= "Allows you to set Error Reporting Options.";
IEF_HEADER_TEXT		= "Improved Error Frame";
IEF_HEADER_HELP		= "The various options to configure your error reporting needs.";
IEF_NOTIFY_TEXT		= "Queue Errors";
IEF_NOTIFY_HELP		= "If checked, errors will be queued to be displayed later.";
IEF_BLINK_TEXT		= "Blinking Button";
IEF_BLINK_HELP		= "If checked, button will blink when errors are pending view.";
IEF_COUNT_TEXT		= "Display error count on button";
IEF_COUNT_HELP		= "If checked, error count will be displayed on button.";
IEF_ALWAYS_TEXT		= "Always show error button";
IEF_ALWAYS_HELP		= "If checked, button will always be present on the screen.";
IEF_SOUND_TEXT		= "Play notification sound";
IEF_SOUND_HELP		= "If checked, sound will be played upon initial error event.";