-- Version : English
-- Last Update : 09/26/2005

BINDING_HEADER_RELOADUI   = "Reload Interface";
BINDING_NAME_UIRELOAD   = "Reload User Interface";

-- Chat Configuration
RELOAD_COMMANDS      = {"/rl", "/reloadui", "/reload", "/rel", "/reboot"};
RELOAD_COMMANDS_DESC   = "/reloadui - Reloads the user interface. Great for when you can't find your corpse.";
RELOAD_CANCEL_COMMANDS   = {"/reloadcancel", "/reloaduicancel", "/rlc", "/relc", "/rebootcancel"};
RELOAD_CANCEL_COMMANDS_DESC = "/reloaduicancel (/rlc) - cancels a UI reload. Only works if done within 1 second of typing /reloadui.";

RELOAD_WARNING = "Reloading the user interface in %d seconds. Type /rlc to cancel.";
RELOAD_MESSAGE = "Reloading the user interface."
RELOAD_CANCEL = "Reload cancelled."; 