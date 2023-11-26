--[[

Combat Caller v2.2*updated version number*
Alex Brazie (original creator)
Recreated localization.lua by Ascendant

]]
-- AddOn labels
IX_COMBATCALLER_VERSION_NUM			= "2.2";
IX_COMBATCALLER_DESC				= "IX Combat Caller (modified by Ascendant)";
IX_COMBATCALLER_VERSION				= IX_COMBATCALLER_DESC.." - Version "..IX_COMBATCALLER_VERSION_NUM;	
IX_COMBATCALLER_LOADED				= "Loaded";
HELP_FILE							= "Help File";
IX_HELP_FILE						= IX_COMBATCALLER_VERSION.." "..HELP_FILE;

--Variable default values
COMBAT_CALLER						= true;
HEALTH_RATIO						= .4;
MANA_RATIO							= .2;
COOL_DOWN							= 10;
HEALTH_WATCH						= true;
MANA_WATCH							= true;
HEALTH_CALL							= true;
HEALTH_CALL_CUSTOM_TEXT				= "";
MANA_CALL							= true;
MANA_CALL_CUSTOM_TEXT				= "";

--AddOn and Char status info
CC_SETTINGS_RESET		 			= "Settings have been reset to default for ";
CC_SETTINGS_LOADED					= "Combat Caller settings have been loaded for ";
CC_SETTINGS_ADDED					= " has been added.";

--Display current settings
DISPLAY_USER_SETTINGS				= "The following settings are for: ";
DISPLAY_COMBAT_CALLER				= "CombatCaller is enabled.";
DISPLAY_HEALTH_RATIO				= "Current health ratio setting is: ";
DISPLAY_MANA_RATIO					= "Current mana ratio setting is: ";
DISPLAY_COOL_DOWN					= "Current cooldown time is: ";
DISPLAY_HEALTH_WATCH				= "Health monitoring is currently: ";
DISPLAY_MANA_WATCH					= "Mana monitoring is currently: ";
DISPLAY_HEALTH_CALL					= "Default emote for 'low health' is currently ";
DISPLAY_HEALTH_CALL_CUSTOM_TEXT		= "Custom emote text for 'low health' is currently ";
DISPLAY_MANA_CALL					= "Default emote for 'low mana' is currently ";
DISPLAY_MANA_CALL_CUSTOM_TEXT		= "Custom emote text for 'low mana' is currently ";

-- Display default settings
DEFAULT_COMBAT_CALLER				= "The default values for CombatCaller are:";
DEFAULT_CC_ONOFF					= "CombatCaller is enabled by default.";
DEFAULT_HEALTH_RATIO				= "The default health ratio is: "..HEALTH_RATIO.." or "..(HEALTH_RATIO*100).."%.";
DEFAULT_MANA_RATIO					= "The default mana ratio is: "..MANA_RATIO.." or "..(MANA_RATIO*100).."%."
DEFAULT_COOL_DOWN					= "The default cooldown time is: "..COOL_DOWN.." seconds.";
DEFAULT_HEALTH_WATCH				= "By default health monitoring is enabled.";
DEFAULT_MANA_WATCH					= "By default mana montioring is enabled.";
DEFAULT_HEALTH_CALL					= "By default the \"HEALME\" emote will play.  This can be disabled.";
DEFAULT_HEALTH_CALL_CUSTOM_TEXT		= "By default there is no custom text emote to replace the \"HEALME\" emote.";
DEFAULT_MANA_CALL					= "By default the \"OOM\" emote will play.  This can be disabled.";
DEFAULT_MANA_CALL_CUSTOM_TEXT		= "By default there is no custom text emote to replace the \"OOM\" emote.";

--Variable command status info
ENABLE_BEFORE_CHANGE				= "CombatCaller is currently disabled.  Please enable it before attempting to change or view settings.";
COMBAT_CALLER_ENABLED				= "CombatCaller has been enabled.  Type '/combatcaller' for a list of commands.";
COMBAT_CALLER_DISABLED				= "CombatCaller has been disabled.  Current settings will be restored when CombatCaller is re-enabled.";
HEALTH_RATIO_UPDATE					= "Health Ratio has been set to ";
HEALTH_RATIO_RESET					= "Health Ratio has been reset to default value.";
MANA_RATIO_UPDATE					= "Mana Ratio has been set to ";
MANA_RATIO_RESET					= "Mana Ratio has been reset to default value.";
COOL_DOWN_UPDATE					= "Cooldown time has been set to ";
HEALTH_MONITOR_UPDATE				= "Health monitoring has been ";
MANA_MONITOR_UPDATE					= "Mana monitoring has been ";
HEALTH_EMOTE_STATUS					= "Health announcement has been reset to default.  \"HEALME\" emote will now play.";
MANA_EMOTE_STATUS					= "Mana announcement has been reset to default.  \"OOM\" emote will now play.";
HEALTH_CUSTOM_STATUS				= "Custom health announcement has been reset to default.  This will re-enable the default emote until you create a new custom one.";
MANA_CUSTOM_STATUS					= "Custom mana announcement has been reset to default.  This will re-enable the default emote until you create a new custom one.";
CUSTOM_CALL_RESET					= "Custom text emote and sound have been disabled.  Default emote status has been restored.";
CUSTOM_CALL_SOUND_ONLY_HEAL			= "Default emote has been disabled.  \"HEALME\" emote sound only will play, no text emote will be displayed.";
CUSTOM_CALL_SOUND_ONLY_MANA 		= "Default emote has been disabled.  \"OOM\" emote sound only will play, no text emote will be displayed.";
CUSTOM_CALL_SOUND_TEXT_HEAL			= "Default emote has been disabled.  \"HEALME\" sound will play and custom text emote will be displayed as follows:";
CUSTOM_CALL_SOUND_TEXT_MANA			= "Default emote has been disabled.  \"OOM\" sound will play and custom text emote will be displayed as follows:";
CUSTOM_CALL_TEXT_ONLY				= "Default emote has been disabled.  No sounds will play, only a text emote to be displayed as follows:";
VARIABLE_UPDATE						= "CombatCaller-> One or more variables have been added or reset to default values as they had been lost, corrupted, or were added in an update to the mod.  You do not need to do anything.";

--Error strings
ERROR_WRONG_VALUE					= "Wrong value.  Parameter must be greater than 0 and less than or equal to 1.";
ERROR_DECIMAL_VALUE					= "Parameter must be less than or equal to 1, but greater than 0.\nAll decimal fractions will be truncated to 1 digit after the decimal point (i.e. 0.22 will become 0.2).";
ERROR_COOLDOWN						= "Cooldown Count must be between 5 and 30 seconds.";
ERROR_HEALTH_MANA_MONITOR			= "Invalid response.  Only valid responses are: on, off, enable, or disable.";
ERROR_RANDOM_FAILED					= "You should not see this message.  Random call failed.";
ERROR_GENERAL						= "Invalid response.  Please try again.";

-- Help File
HELP_COMBAT_CALLER					= "/combatcaller <\"help\" | \"enable\" | \"disable\"> - example: \"/combatcaller help\" - displays this message (<help> will work with all 'slash' commands";
HELP_HEALTH_RATIO					= "/hr or /healthratio <decimal value between 0 and 1> - example: \"/combatcaller hr 0.8\"";
HELP_MANA_RATIO						= "/mr or /manaratio <decimal value between 0 and 1> - example: \"/combatcaller mr 0.6\"";
HELP_COOL_DOWN						= "/cd or /cooldown or /cooldowntime <whole number between 5 and 30> - example: \"/combatcaller cooldown 20\"";
HELP_HEALTH_WATCH					= "/healthwatch <on, off, enable, disable> - sets whether or not CombatCaller should monitor your health - example: \"/combatcaller healthwatch disable\"";
HELP_MANA_WATCH						= "/manawatch <on, off, enable, disable> - sets whether or not CombatCaller should monitor your mana - example: \"/combatcaller manawatch on\"";
HELP_HEALTH_CALL					= "/healthcall <reset or default> - resets to default \"HEALME\" emote - \"example: /combatcaller healthcall default\"";
HELP_HEALTH_CALL_CUSTOM_TEXT		= "/healthcall <customcall>|<reset, soundonly, soundtext, (any custom emote text you like)> - allows user control over how alerts are to happen";
HELP_HEALTH_CALL_CUSTOM_TEXT1		= "example: \"/combatcaller healthcall soundonly\" - will play just the sound associated with the \"HEALME\" emote, also";
HELP_HEALTH_CALL_CUSTOM_TEXT2		= "\"/combatcaller healthcall is dying\" - will display: \"<your name here> is dying\" as a text emote\n\"/combatcaller healthcall soundtext is dying\" - will combine the custom text emote with the default sound";
HELP_MANA_CALL						= "/manacall <reset or default> - resets to default \"HEALME\" emote - \"example: /combatcaller manacall default\"";
HELP_MANA_CALL_CUSTOM_TEXT			= "/manacall <customcall>|<reset, soundonly, soundtext, (any custom emote text you like)> - allows user control over how alerts are to happen";
HELP_MANA_CALL_CUSTOM_TEXT1			= "example: \"/combatcaller manacall soundonly\" - will play just the sound associated with the \"OOM\" emote, also";
HELP_MANA_CALL_CUSTOM_TEXT2			= "\"/combatcaller manacall is dying\" - will display: \"<your name here> is dying\" as a text emote\n\"/combatcaller manacall soundtext is dying\" - will combine the custom text emote with the default sound";
HELP_RESET							= "/reset - resets all CombatCaller settings to default - example: \"/combatcaller reset\"";
HELP_DEFAULT						= "/default - displays default values for CombatCaller settings - example: \"/combatcaller default\"";
HELP_DISPLAY						= "/display - displays current user's settings - example: \"/combatcaller display\"";