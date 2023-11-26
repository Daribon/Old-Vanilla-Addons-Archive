if( not ace:LoadTranslation("KC_Items_TooltipHooker") ) then

KC_TOOLTIPHOOKER_NAME          = "KC_TooltipHooker"
KC_TOOLTIPHOOKER_DESCRIPTION   = "This module handles conversion of IM and LL data."

KC_TOOLTIPHOOKER_TEXT_SEPERATED_TOOLTIP		= "Seperated tooltip";
KC_TOOLTIPHOOKER_TEXT_SEPERATOR_LINES		= "Seperator lines";
KC_TOOLTIPHOOKER_TEXT_SPLITING_OF_LINES		= "Spliting of lines";

KC_TOOLTIPHOOKER_CMD_OPTIONS = {
	option	= "tooltip",
	desc	= "Tooltip options.",
	args	= {
		{
			option = "mode",
			desc   = "Toggles tooltip mode between merged and seperated.",
			method = "modeswitch"
		},
		{
			option = "separator",
			desc   = "Toggles wether to include seperator lines.",
			method = "seperatortog"
		},
		{
			option = "splitline",
			desc   = "Toggles wether to use the split line display.",
			method = "splitline"
		},
	},
        
}

end