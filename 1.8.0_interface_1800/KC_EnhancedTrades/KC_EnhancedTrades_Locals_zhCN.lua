
function KC_EnhancedTradesLocals_zhCN()

KC_ENHANCEDTRADES_NAME          = "KC_EnhancedTrades";
KC_ENHANCEDTRADES_DESCRIPTION   = "Displays additional tradeskill info.";

--[[
	these letters are the initals for various words and should be the initals of the corresponding words in any translation.
	
	i = inventory
	v = vendor
	b = bank
	a = alts (as in alternitve characters)
]]--

KC_ENHANCEDTRADES_TEXT_I			= "i";
KC_ENHANCEDTRADES_TEXT_I_V			= "i+v";
KC_ENHANCEDTRADES_TEXT_I_B			= "i+b";
KC_ENHANCEDTRADES_TEXT_I_V_B		= "i+v+b";
KC_ENHANCEDTRADES_TEXT_I_V_B_A		= "i+v+b+a";

KC_ENHANCEDTRADES_TEXT_SMART		= "smart";

-- these four are the different difficulties of a craft.
KC_ENHANCEDTRADES_TEXT_OPTIMAL		= "optimal";
KC_ENHANCEDTRADES_TEXT_MEDIUM		= "medium";
KC_ENHANCEDTRADES_TEXT_TRIVIAL		= "trivial";
KC_ENHANCEDTRADES_TEXT_EASY			= "easy";

KC_ENHANCEDTRADES_TEXT_DISPLAYS		= "display";
KC_ENHANCEDTRADES_TEXT_FILTERS		= "filters";

-- Chat handler locals
KC_ENHANCEDTRADES_CHAT_COMMANDS = {"/KC_EnhancedTrades", "/KCET"};
KC_ENHANCEDTRADES_CHAT_OPTIONS  = {
	{
		option = KC_ENHANCEDTRADES_TEXT_DISPLAYS,
		desc   = "Toggles the specified display option.",
		method = "ToggleDisplay",
		args   = {
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V,
				desc = "Toggles the display of the inventory + vendor column.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_B,
				desc = "Toggles the display of the inventory + bank column.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B,
				desc = "Toggles the display of the inventory + vendor + bank column.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B_A,
				desc = "Toggles the display of the inventory + vendor + bank + alts column.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_SMART,
				desc = "Toggles the semi-intellegent reduction of displaying repetitive data.",
			},
		}
	},
	{
		option = KC_ENHANCEDTRADES_TEXT_FILTERS,
		desc   = "Toggles the specified filter.",
        method = "ToggleFilter",
		args   = {
			{
				option = KC_ENHANCEDTRADES_TEXT_I,
				desc = "Toggles the display of items you can't make from your inventory.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_B,
				desc = "Toggles the display of items you can't make from your inventory + bank.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V,
				desc = "Toggles the display of items you can't make from your inventory + vendor.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B,
				desc = "Toggles the display of items you can't make from your inventory + vendor + bank.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B_A,
				desc = "Toggles the display of items you can't make from your inventory + vendor + bank + alts.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_TRIVIAL,
				desc = "Toggles the display of trivial difficulity items.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_EASY,
				desc = "Toggles the display of easy difficulity items.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_MEDIUM,
				desc = "Toggles the display of medium difficulity items.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_OPTIMAL,
				desc = "Toggles the display of optimal difficulity items.",
			},
		}
	},
}

if (KC_Rundown) then
	KC_ENHANCEDTRADES_CHAT_OPTIONS[getn(KC_ENHANCEDTRADES_CHAT_OPTIONS) + 1] = {
		option = "rundown",
		desc   = "Rundowns item locations.  Usage /kcet rundown <pattern>",
        method = "rundown",
	}
end

-- |cffffff78 is a color code please don't change it.
KC_ENHANCEDTRADES_DISPLAY_HEADER	= "|cffffff78The Display Options Are Set As Follows:";
KC_ENHANCEDTRADES_FILTER_HEADER		= "|cffffff78The Filter Options Are Set As Follows:";

KC_ENHANCEDTRADES_ENABLED_DISABLED = {  [0] = "disabled",
										[1] = "enabled",
									 };

KC_ENHANCEDTRADES_SHOWING_HIDING =   {  [0] = "hiding",
										[1] = "showing",
									 };		
				     
-- the two %s here are important as they are special characters the first %s represents the name of the filter/display and the second one is going to be either enabled, disabled, hiding, showing

KC_ENHANCEDTRADES_FILTER_RESULT		= "Filter %s: has been set to %s.";
KC_ENHANCEDTRADES_DISPLAY_RESULT	= "Display %s: has been set to %s.";

KC_ENHANCEDTRADES_TEXT_QUEUE		= "Queue";

KC_ENHANCEDTRADES_TEXT_BUYABLE		= "[Buyable]";

-- This is the text ontop of the beast training window for hunters.  If this isn't correct hunters cain't train their pets.
KC_ENHANCEDTRADES_TEXT_BEASTTRAIN	= "Beast Training";

KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	= "Show Items That Can't Be Made With: %s";
KC_ENHANCEDTRADES_TEXT_CBW_I		= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I);
KC_ENHANCEDTRADES_TEXT_CBW_I_V		= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_V);
KC_ENHANCEDTRADES_TEXT_CBW_I_B		= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_B);
KC_ENHANCEDTRADES_TEXT_CBW_I_V_B	= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_V_B);
KC_ENHANCEDTRADES_TEXT_CBW_I_V_B_A	= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_V_B_A);

KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN		= "Show %s Items";
KC_ENHANCEDTRADES_TEXT_SI_OPTIMAL	= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_OPTIMAL);
KC_ENHANCEDTRADES_TEXT_SI_MEDIUM	= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_MEDIUM);
KC_ENHANCEDTRADES_TEXT_SI_TRIVIAL	= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_TRIVIAL);
KC_ENHANCEDTRADES_TEXT_SI_EASY		= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_EASY);

KC_ENHANCEDTRADES_CONFIG_HEADER			= "KCET v";
KC_ENHANCEDTRADES_CONFIG_DISPLAY_HEADER = "Column Display Options";
KC_ENHANCEDTRADES_CONFIG_FILTER_HEADER	= "Filter Options";
end