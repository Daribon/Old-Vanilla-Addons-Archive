-- The ace:LoadTranslation() method looks for a specific translation function for
-- the addon. If it finds one, that translation is loaded. See AceHelloLocals_xxXX.lua
-- for an example and description of function naming.
function ManaSave_Locals_deDE()

-- All text that is translated is placed in quotes in this template.

ace:RegisterGlobals({
    -- Match this version to the library version you are pulling from.
    version = 1.0,

    -- Place any AceUtil globals your addon needs here.
    ACE_MAP_ONOFF = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r"},
})

CLASS_WARRIOR  = "Krieger";
CLASS_MAGE     = "Magier";
CLASS_ROGUE    = "Schurke";
CLASS_DRUID    = "Druide";
CLASS_HUNTER   = "J\195\164ger";
CLASS_SHAMAN   = "Schamane";
CLASS_PRIEST   = "Priester";
CLASS_WARLOCK  = "Hexenmeister";
CLASS_PALADIN  = "Paladin";

-- priest heals
GREATER_HEAL    = 'Gro\195\159e Heilung';
FLASH_HEAL      = 'Blitzheilung';
HEAL 		= 'Heilen';

-- shami heals
LESSER_HEAL     = 'Geringe Welle der Heilung';
HEALING_WAVE    = 'Welle der Heilung';

-- druid heals
HEALING_TOUCH	= 'Heilende Ber\195\188hrung';
REGROWTH 	= 'Nachwachsen';

-- "i make no dmg and use hearthstone" heals
HOLY_LIGHT	= 'Heiliges Licht';
FLASH_OF_LIGHT	= 'Lichtblitz';

MANASAVE_NAME		= "ManaSave"
MANASAVE_DESCRIPTION	= "ManaSave - The modern way of Manasaving while Healing"
MANASAVE_VERSION           = "0.06"
MANASAVE_RELEASEDATE       = "16.08.2005"

-- Chat handler locals
MANASAVE_COMMANDS	 = {"/ms"}
MANASAVE_CMD_OPTIONS	 = {
	{
		option	= "checktime",
		desc	= "Stetzt die Zeit vor Spruchausführung bei der ManaSave den Abbruch überprüft",
		method	= "SetCheckTime"
	},
	{
		option	= "usepercent",
		desc	= "Stellt ManaSave auf die Nutzung von prozentualen Werten beim Spruchabbruch ein",
		method	= "SetUsePercent"
	},
	{
		option	= "useabsolute",
		desc	= "Stellt ManaSave auf die Nutzung von absoluten Werten beim Spruchabbruch ein",
		method	= "SetUseAbsolute"
	},
	{
		option	= "report",
		desc	= "Gibt alle Einstellungen aus",
		method	= "ReportSettings"
	},
	{
		option	= "setpercent",
		desc	= "Setzt den Prozentsatz vom Leben fest, ab dem ein Heal nicht mehr abgebrochen wird, z.B.. /ms setpercent Blitzheilung=85",
		method	= "setPercentValue"
	},
	{
		option	= "setabsolute",
		desc	= "Setzt den max zulässigen Lebensverlust, bei dem ein Heal abbricht, z.B. /ms setabsolute Blitzheilung=950",
		method	= "setAbsoluteValue"
	},
	{
		option	= "selfcheck",
		desc	= "schaltet ManaSave ein/aus wenn man auf sich selbst castet",
		method	= "ToggleSelfCheck"
	},
	{
		option	= "setmulti",
		desc	= "setzt den Multiplikator für die absolut Werte, empfohlener Wert = 1",
		method	= "SetMulti"
	},
	{
		option	= "reset",
		desc	= "stellt die standard ManaSave Einstellungen wieder her",
		method	= "reset"
	},
	{
		option	= "debug",
		desc	= "Schaltet Debug Nachrichten ein/aus",
		method	= "ToggleDebug"
	}
	
}

MS_VAR_CHKTIME_TEXT = "Checktime"
MS_VAR_MULTI_TEXT = "Multiplicator"
MS_VAR_USEPERC_TEXT = "Nutzung von Prozentwerten"
MS_VAR_DEBUG_TEXT = "Debug Modus"
MS_VAR_SELFCHECK_TEXT = "Selfcheck"
MS_VAR_VERSION_TXT = "Version"

end
