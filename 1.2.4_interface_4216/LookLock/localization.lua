-- Version : English (by Mugendai)
-- Last Update : 02/17/2005

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>
BINDING_HEADER_LOOKLOCKHEADER		= "Look Lock";
BINDING_NAME_LOOKLOCK			= "Look Lock On/Off";
BINDING_NAME_LOOKLOCKPUSH		= "Look Lock Hold";
BINDING_NAME_LOOKLOCKACTION		= "Look Lock Action";
BINDING_NAME_LOOKLOCKCAMERA		= "Look Lock Camera";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Configuration Strings
-- <= == == == == == == == == == == == == =>
LOOKLOCK_CONFIG_HEADER			= "Look Lock";
LOOKLOCK_CONFIG_HEADER_INFO		= "These options configure Look Lock ";
LOOKLOCK_CONFIG_REMAP_ONOFF		= "Remap mouse buttons for Look Lock.";
LOOKLOCK_CONFIG_REMAP_ONOFF_INFO	= "Allows better behavior of mouse buttons when using Look Lock.";
LOOKLOCK_CONFIG_STRAFE_ONOFF		= "Mouse Button Strafe.";
LOOKLOCK_CONFIG_STRAFE_ONOFF_INFO	= "Makes the left and right mouse buttons strafe left and right when in look lock mode.";
LOOKLOCK_CONFIG_ALWAYS_ONOFF		= "Always Locked(Highly Experimental)";
LOOKLOCK_CONFIG_ALWAYS_ONOFF_INFO	= "This will make your mouse always be in Look Lock mode, right clicking will return to normal mode.";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Chat Command Strings
-- <= == == == == == == == == == == == == =>
LOOKLOCK_CHAT_COMMAND_INFO		= "Type /looklock or /ll for usage info.";
LOOKLOCK_CHAT_COMMAND_HELP		= {};
LOOKLOCK_CHAT_COMMAND_HELP[1]		= "Type /looklock or /ll then the option, then on/off";
LOOKLOCK_CHAT_COMMAND_HELP[2]		= "Example: /ll remap on";
LOOKLOCK_CHAT_COMMAND_HELP[3]		= "remap - Pass 1 to remap mouse buttons for LookLock, or 0 to disable remapping these buttons.";
LOOKLOCK_CHAT_COMMAND_HELP[4]		= "strafe - Pass 1 to make the left/right buttons strafe while looklocked, pass 0 to disable this.";
LOOKLOCK_CHAT_COMMAND_HELP[5]		= "reset - This will reset your mouse buttons to their defaults and save the changes(used to fix problems caused by older Look Locks).";
LOOKLOCK_CHAT_COMMAND_HELP[6]		= "always - This will make your mouse always be in Look Lock mode, right clicking will return to normal mode.";

-- <= == == == == == == == == == == == == =>
-- => Chat Strings
-- <= == == == == == == == == == == == == =>
LOOKLOCK_CHAT_REMAP_ON			= "Look Lock Remap, Enabled.";
LOOKLOCK_CHAT_REMAP_OFF			= "Look Lock Remap, Disabled.";
LOOKLOCK_CHAT_STRAFE_ON			= "Look Lock Strafe, Enabled.";
LOOKLOCK_CHAT_STRAFE_OFF		= "Look Lock Strafe, Disabled.";
LOOKLOCK_CHAT_ALWAYS_ON			= "Look Lock Always, Enabled.";
LOOKLOCK_CHAT_ALWAYS_OFF		= "Look Lock Always, Disabled.";
LOOKLOCK_CHAT_FIX_DONE			= "Reset mouse buttons to defaults.";