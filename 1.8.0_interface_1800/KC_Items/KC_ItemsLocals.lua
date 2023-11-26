-- This statement will load any translation that is present or default to English.
if( not ace:LoadTranslation("KC_Items") ) then

ace:RegisterGlobals({
	version	= 1.01,

	ACEG_TEXT_NOW_SET_TO = "now set to",
	ACEG_TEXT_DEFAULT	 = "default",

	ACEG_DISPLAY_OPTION  = "[|cfff5f530%s|r]",

    ACEG_MAP_ONOFF		 = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r"},
    ACEG_MAP_ENABLED	 = {[0]="|cffff5050Disabled|r",[1]="|cff00ff00Enabled|r"},
})

KC_ITEMS_DISPLAY_OPTION	= "[|cfff5f530%s|cff0099CC]";

KC_ITEMS_NAME			= "KC_Items"
KC_ITEMS_DESCRIPTION	= "A centralized repository for item, bank, and inventory data."

KC_ITEMS_MSG_COLOR		= "|cff0099CC";

KC_ITEMS_COLORS	= {
	["grey"]	= 0,
	["white"]	= 1,
	["green"]	= 2,
	["blue"]	= 3,
	["purple"]	= 4
}

KC_ITEMS_TEXT_NO_MODULES	= "No modules installed"
KC_ITEMS_RPT_HDR_MODULES	= "----- Installed Modules -----"
KC_ITEMS_ERR_MOD_ENABLE		= "Cannot enable %s. Dependencies are missing or disabled."

-- Chat handler locals
KC_ITEMS_COMMANDS		= {"/kcitems", "/kci"}
KC_ITEMS_CMD_OPTIONS	= {
    {
		option = "core",
        desc   = "Core functionality related commands.",
		args = {
			{
				option = "clear",
				desc   = "Clears common data reguarding items.",
				method = "clear"
			},
		},
    },
	{
		option	= "prune",
		method	= "prune",
		desc	= "Bulk removal of links.",
		input	= TRUE,
		args	= {
				{
					option	= "dblName",
					desc	= "Removes extra items that share the same name.",
					method	= "pruneDblName",
				},
				{
					option	= "grey",
					desc	= "Removes all grey items.",
				},
				{
					option	= "white",
					desc	= "Removes all white items.",
				},
				{
					option	= "green",
					desc	= "Removes all green items.",
				},
				{
					option	= "blue",
					desc	= "Removes all blue items.",
				},
				{
					option	= "purple",
					desc	= "Removes all purple items.",
				},
		},
	},
}

-- Chat command options for modules
KC_ITEMS_CMD_TOGGLE	= {
	option = "toggle",
	desc   = "Toggles this module on or off.",
	method = "Toggle"
}

end

KC_Items_Colors = {
	["FF8000"] = 5,
	["a335ee"] = 4,
	["0070dd"] = 3, 
	["1eff00"] = 2,
	["ffffff"] = 1,
	["9d9d9d"] = 0,
			
	[-1] = "fff68f",
	[0] = "9d9d9d", 
	[1] = "ffffff",
	[2] = "1eff00", 
	[3] = "0070dd",
	[4] = "a335ee",
	[5] = "FF8000",};