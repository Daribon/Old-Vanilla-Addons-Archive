-- Version : English (by Sarf)
-- Last Update : 02/17/2005

-- Binding Configuration
BINDING_HEADER_WEAPONBUTTONSHEADER			= "Weapon Buttons";
BINDING_NAME_WEAPONBUTTONS				= "Weapon Buttons Toggle";
BINDING_NAME_WEAPONBUTTONS_CYCLE			= "Cycle WeaponButtons mode";

-- UltimateUI Configuration
WEAPONBUTTONS_CONFIG_HEADER				= "Weapon Buttons";
WEAPONBUTTONS_CONFIG_HEADER_INFO			= "Contains settings for the Weapon Buttons,\nan AddOn which allows you to get access to just the weapon buttons of the character window.\nShift click on the WeaponButton window to toggle between melee/ranged";

WEAPONBUTTONS_ENABLED					= "Enable Weapon Buttons";
WEAPONBUTTONS_ENABLED_INFO				= "Enables Weapon Buttons, which means that the Weapon Buttons window will be displayed.";

WEAPONBUTTONS_DISPLAY_TOOLTIPS				= "Show tooltips on Weapon Buttons";
WEAPONBUTTONS_DISPLAY_TOOLTIPS_INFO			= "Determines whether tooltips should be shown on mousing over the WeaponButtons.";

WEAPONBUTTONS_LOCK_POSITION				= "Lock current position";
WEAPONBUTTONS_LOCK_POSITION_INFO			= "Prevents the user from dragging the WeaponButtons window from its current position.";

WEAPONBUTTONS_RESET					= "Reset position";
WEAPONBUTTONS_RESET_INFO				= "Resets the WeaponButtons position in case it's disappeared from the screen.";
WEAPONBUTTONS_RESET_NAME				= "Reset";

WEAPONBUTTONS_DEFAULT_MODE				= "Set default mode to...";
WEAPONBUTTONS_DEFAULT_MODE_INFO				= "The default mode of WeaponButtons.";
WEAPONBUTTONS_DEFAULT_MODE_APPEND			= "";

-- Chat Configuration
WEAPONBUTTONS_CHAT_COMMAND_INFO				= "Controls the weapon buttons by the command line. Use /weaponbutton to get usage help.";
WEAPONBUTTONS_CHAT_COMMAND_USAGE			= "Usage: /weaponbutton <show/tooltips/lock/mode> [on/off/toggle]\nCommands:\n show - determines whether the WeaponButton window should be visible\n tooltips - whether tooltips should be shown on mouseover\n lock - whether the window can be moved or not\n mode - sets the default mode to ranged or melee \n togglemode - toggles the mode of the Weapon Buttons (like right-clicking)";

WEAPONBUTTONS_CHAT_ENABLED				= "Weapon Buttons enabled.";
WEAPONBUTTONS_CHAT_DISABLED				= "Weapon Buttons disabled.";
WEAPONBUTTONS_CHAT_COMMAND_ENABLE_INFO			= "Enables/disables Weapon Buttons.";

WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_ENABLED		= "Weapon Buttons display of tooltips enabled.";
WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_DISABLED		= "Weapon Buttons display of tooltips disabled.";
WEAPONBUTTONS_CHAT_COMMAND_DISPLAY_TOOLTIPS_INFO	= "Enables/disables the showing of tooltips when mousing over Weapon Buttons.";

WEAPONBUTTONS_CHAT_LOCK_POSITION_ENABLED		= "Weapon Buttons have been locked to the current position.";
WEAPONBUTTONS_CHAT_LOCK_POSITION_DISABLED		= "Weapon Buttons have been unlocked from the current position.";
WEAPONBUTTONS_CHAT_COMMAND_LOCK_POSITION_INFO		= "Locks/unlocks the WeaponButtons to/from their current position.";

WEAPONBUTTONS_CHAT_COMMAND_RESET_INFO			= "Resets the position of the Weapon Buttons frame.";

WEAPONBUTTONS_CHAT_SETMODE				= "WeaponButtons mode set to %s.";
WEAPONBUTTONS_CHAT_MODE_ILLEGAL				= "Illegal WeaponButtons mode";
WEAPONBUTTONS_CHAT_MODE_MELEE				= "Melee";
WEAPONBUTTONS_CHAT_MODE_RANGED				= "Ranged";
WEAPONBUTTONS_CHAT_MODE_TRINKETS			= "Trinkets";

-- UltimateUI AddOn Mod Configuration
WEAPONBUTTONS_CONFIG_TRANSNUI				= "Transparent WeaponButtons";
WEAPONBUTTONS_CONFIG_TRANSNUI_INFO			= "Allows you to make WeaponButtons transparent";

WEAPONBUTTONS_CONFIG_POPNUI				= "Autohide WeaponButtons";
WEAPONBUTTONS_CONFIG_POPNUI_INFO			= "Check this to make WeaponButtons only show when you move your mouse over it.";

-- Configuration Setup
WEAPONBUTTONS_CHAT_MODES = {
	WEAPONBUTTONS_CHAT_MODE_MELEE,
	WEAPONBUTTONS_CHAT_MODE_RANGED,
	WEAPONBUTTONS_CHAT_MODE_TRINKETS
};