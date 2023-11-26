-- The ace:LoadTranslation() method looks for a specific translation function for
-- the addon. If it finds one, that translation is loaded. See AceHelloLocals_xxXX.lua
-- for an example and description of function naming.
if( not ace:LoadTranslation("ManaSave") ) then

-- All text that is translated is placed in quotes in this template.

ace:RegisterGlobals({
    -- Match this version to the library version you are pulling from.
    version = 1.0,

    -- Place any AceUtil globals your addon needs here.
    ACE_MAP_ONOFF = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r"},
})

-- classes
CLASS_WARRIOR = "Warrior";
CLASS_MAGE    = "Mage";
CLASS_ROGUE   = "Rogue";
CLASS_DRUID   = "Druid";
CLASS_HUNTER  = "Hunter";
CLASS_SHAMAN  = "Shaman";
CLASS_PRIEST  = "Priest";
CLASS_WARLOCK = "Warlock";
CLASS_PALADIN = "Paladin";

-- priest heals
GREATER_HEAL    = 'Greater Heal';
FLASH_HEAL      = 'Flash Heal';
HEAL 		= 'Heal';

-- shami heals
LESSER_HEAL     = 'Lesser Healing Wave';
HEALING_WAVE    = 'Healing Wave';

-- druid heals
HEALING_TOUCH	= 'Healing Touch';
REGROWTH 	= 'Regrowth';

-- "i make no dmg and use hearthstone" heals
HOLY_LIGHT	= 'Holy Light';
FLASH_OF_LIGHT	= 'Flash of Light';

MANASAVE_NAME		= "ManaSave"
MANASAVE_DESCRIPTION	= "ManaSave - The modern way of Manasaving while Healing"
MANASAVE_VERSION           = "0.06"
MANASAVE_RELEASEDATE       = "16.08.2005"

-- Chat handler locals
MANASAVE_COMMANDS	 = {"/ms"}
MANASAVE_CMD_OPTIONS	 = {
	{
		option	= "checktime",
		desc	= "sets the time before healcast on which health status gets checked",
		method	= "SetCheckTime"
	},
	{
		option	= "usepercent",
		desc	= "makes ManaSave use percent values for the heal abort check",
		method	= "SetUsePercent"
	},
	{
		option	= "useabsolute",
		desc	= "makes ManaSave use absolute values for the heal abort check",
		method	= "SetUseAbsolute"
	},
	{
		option	= "report",
		desc	= "reports the settings of your ManaSave Installation",
		method	= "ReportSettings"
	},
	{
		option	= "setpercent",
		desc	= "set the percent value where the healspell doesn't abort anymore, e.g. /ms setpercent Flash Heal=85",
		method	= "setPercentValue"
	},
	{
		option	= "setabsolute",
		desc	= "set the maximum absolute value of health deficite to abort for a heal, e.g. /ms setabsolute Flash Heal=950",
		method	= "setAbsoluteValue"
	},
	{
		option	= "selfcheck",
		desc	= "disable or enables ManaSave to check health status when a player targets himself",
		method	= "ToggleSelfCheck"
	},
	{
		option	= "setmulti",
		desc	= "sets the multiplicator for absolute values, default=1",
		method	= "SetMulti"
	},
	{
		option	= "reset",
		desc	= "reload default ManaSave Settings",
		method	= "reset"
	},
	{
		option	= "debug",
		desc	= "toggles debug messages on/off",
		method	= "ToggleDebug"
	}
	
}

MS_VAR_CHKTIME_TEXT = "Checktime"
MS_VAR_MULTI_TEXT = "Multiplicator"
MS_VAR_USEPERC_TEXT = "Use percent values"
MS_VAR_DEBUG_TEXT = "Debug mode"
MS_VAR_SELFCHECK_TEXT = "Selfcheck"
MS_VAR_VERSION_TXT = "Version"

end
