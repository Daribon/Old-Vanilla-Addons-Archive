if( not ace:LoadTranslation("KC_Items_SellValue") ) then

KC_SELLVALUE_NAME			= "KC_SellValue";
KC_SELLVALUE_DESCRIPTION	= "Handles vendor buy/sell values.";

KC_SELLVALUE_TEXT_SELLS_FOR_LONG	= "|cffffff78Vendor pays (|r%s|cffffff78)|r";
KC_SELLVALUE_TEXT_BUYS_FOR_LONG		= "|cffffff78Vendor charges (|r%s|cffffff78)|r";

KC_SELLVALUE_TEXT_SELLS_FOR_SHORT	= "|cffffff78Sells (|r%s|cffffff78)|r";
KC_SELLVALUE_TEXT_BUYS_FOR_SHORT	= "|cffffff78Buys (|r%s|cffffff78)|r";

KC_SELLVALUE_TEXT_EACH	= "|cffff3333(each)|r"

KC_SELLVALUE_TEXT_SHORT_DISPLAY_MODE	= "Short display mode";
KC_SELLVALUE_TEXT_DISPLAY_OF_SINGLE		= "Display of single prices";

KC_SELLVALUE_TEXT_SEP = "-";
KC_SELLVALUE_SEPCOLOR = "|cffffff78";

KC_SELLVALUE_CMD_OPTIONS = {
	option	= "sellvalue",
	desc	= "Active link gathering related commands.",
	args	= {
		{
			option = "short",
			desc   = "Toggles use of the short display mode.",
			method = "short"
		},
		{
			option = "single",
			desc   = "Toggles display of the single price.",
			method = "single"
		},
	},    
}

end