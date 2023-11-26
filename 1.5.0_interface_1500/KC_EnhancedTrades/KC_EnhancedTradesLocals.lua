-- This statement will load any translation that is present or default to English.
local loader = getglobal("KC_EnhancedTrades_Locals_"..GetLocale());
if ( loader ) then loader();
else

KC_ENHANCEDTRADES_NAME          = "KC_EnhancedTrades";
KC_ENHANCEDTRADES_DESCRIPTION   = "Displays additional tradeskill info.";

-- Chat handler locals
KC_ENHANCEDTRADES_CHAT_COMMANDS = {"/KC_EnhancedTrades", "/KCET"};
KC_ENHANCEDTRADES_CHAT_OPTIONS  = {
	display = {
		desc   = "Toggles the specified display option.",
	        method = "ToggleDisplay",
		args   = {
			["i+v"]	= {
				desc = "Toggles the display of the inventory + vendor column.",
			},
			["i+b"]	= {
				desc = "Toggles the display of the inventory + bank column.",
			},
			["i+v+b"] = {
				desc = "Toggles the display of the inventory + vendor + bank column.",
			},
			["i+v+b+alts"] = {
				desc = "Toggles the display of the inventory + vendor + bank + alts column.",
			},
			["smart"] = {
				desc = "Toggles the semi-intellegent reduction of displaying repetitive data.",
			},
		}
	},
	filters = {
		desc   = "Toggles the specified filter.",
	        method = "ToggleFilter",
		args   = {
			["i"] = {
				desc = "Toggles the display of items you can't make from your inventory.",
			},
			["i+b"]	= {
				desc = "Toggles the display of items you can't make from your inventory + bank.",
			},
			["i+v"]	= {
				desc = "Toggles the display of items you can't make from your inventory + vendor.",
			},
			["i+v+b"] = {
				desc = "Toggles the display of items you can't make from your inventory + vendor + bank.",
			},
			["i+v+b+alts"] = {
				desc = "Toggles the display of items you can't make from your inventory + vendor + bank + alts.",
			},
			["trivial"] = {
				desc = "Toggles the display of trivial difficulity items.",
			},
			["easy"] = {
				desc = "Toggles the display of easy difficulity items.",
			},
			["medium"] = {
				desc = "Toggles the display of medium difficulity items.",
			},
			["optimal"] = {
				desc = "Toggles the display of optimal difficulity items.",
			},
		}
	}
}

KC_ENHANCEDTRADES_DISPLAY_HEADER	= "|cffffff78The Display Options Are Set As Follows:";
KC_ENHANCEDTRADES_FILTER_HEADER		= "|cffffff78The Filter Options Are Set As Follows:";

KC_ENHANCEDTRADES_ENABLED_DISABLED = {  [0] = "disabled",
					[1] = "enabled",
				     };

KC_ENHANCEDTRADES_SHOWING_HIDING =   {  [0] = "hiding",
					[1] = "showing",
				     };		
				     
KC_ENHANCEDTRADES_FILTER_RESULT		= "Filter %s: has been set to %s."
KC_ENHANCEDTRADES_DISPLAY_RESULT	= "Display %s: has been set to %s."
end


loader = nil;
