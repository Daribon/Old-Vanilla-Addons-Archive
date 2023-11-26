
function KC_EnhancedTradesLocals_frFR()


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

KC_ENHANCEDTRADES_TEXT_DISPLAYS		= "affichage";
KC_ENHANCEDTRADES_TEXT_FILTERS		= "filtres";

-- Chat handler locals
KC_ENHANCEDTRADES_CHAT_COMMANDS = {"/KC_EnhancedTrades", "/KCET"};
KC_ENHANCEDTRADES_CHAT_OPTIONS  = {
	{
		option = KC_ENHANCEDTRADES_TEXT_DISPLAYS,
		desc   = "Affiche l’option d’affichage specifiée.",
	    method = "ToggleDisplay",
		args   = {
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V,
				desc = "Affiche les colonnes d’inventaire et vendeur.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_B,
				desc = "Affiche les colonnes d’inventaire et banque.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B,
				desc = "Affiche les colonnes d’inventaire, de vendeur et de banque. ",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B_A,
				desc = "Affiche la colonne d’inventaire, de vendeur, de banque, et des autres personnages du joueur.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_SMART,
				desc = "Affiche la reduction semi-intelligente de l’affichage des données repetitives.",
			},
		}
	},
	{
		option = KC_ENHANCEDTRADES_TEXT_FILTERS,
		desc   = "Affiche le filtre spécifié.",
        method = "ToggleFilter",
		args   = {
			{
				option = KC_ENHANCEDTRADES_TEXT_I,
				desc = "Affiche les objets que vous ne pouvez pas faire dans votre inventaire.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_B,
				desc = "Affiche les objets que vous ne pouvez pas faire dans votre inventaire + banque.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V,
				desc = "Affiche les objets que vous ne pouvez pas faire dans votre inventaire + vendeur. ",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B,
				desc = "Affiche les objets que vous ne pouvez pas faire dans votre inventaire + vendeur + banque.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_I_V_B_A,
				desc = "Affiche les objets que vous ne pouvez pas faire dans votre inventaire + vendeur + banque + autres personnages du joueur.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_TRIVIAL,
				desc = "Affiche les objets normaux.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_EASY,
				desc = "Affiche les objets faciles.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_MEDIUM,
				desc = "Affiche les objets moyens.",
			},
			{
				option = KC_ENHANCEDTRADES_TEXT_OPTIMAL,
				desc = "Affiche les objets optimum.",
			},
		}
	},
}

if (KC_Rundown) then
	KC_ENHANCEDTRADES_CHAT_OPTIONS[getn(KC_ENHANCEDTRADES_CHAT_OPTIONS) + 1] = {
		option = "rundown",
		desc   = "Lance la localisation d’objets. Utilisation /kcet rundown <paramètre>",
        method = "rundown",
	}
end

-- |cffffff78 is a color code please don't change it.
KC_ENHANCEDTRADES_DISPLAY_HEADER	= "|cffffff78The Display Options Are Set As Follows:";
KC_ENHANCEDTRADES_FILTER_HEADER		= "|cffffff78The Filter Options Are Set As Follows:";

KC_ENHANCEDTRADES_ENABLED_DISABLED = {  [0] = "désactivé",
										[1] = "activé",
									 };

KC_ENHANCEDTRADES_SHOWING_HIDING =   {  [0] = "masqué",
										[1] = "affiché",
									 };		
				     
-- the two %s here are important as they are special characters the first %s represents the name of the filter/display and the second one is going to be either enabled, disabled, hiding, showing

KC_ENHANCEDTRADES_FILTER_RESULT		= "Le filtre %s: a été fixé à %s.";
KC_ENHANCEDTRADES_DISPLAY_RESULT	= "L’affichage %s: a été fixé à %s.";

KC_ENHANCEDTRADES_TEXT_QUEUE		= "Queue";

KC_ENHANCEDTRADES_TEXT_BUYABLE		= "[Achetable]";

-- This is the text ontop of the beast training window for hunters.  If this isn't correct hunters cain't train their pets.
KC_ENHANCEDTRADES_TEXT_BEASTTRAIN	= "Entrainement des bêtes";

KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	= "Affiche les objets qui ne peuvent pas être faits avec: %s";
KC_ENHANCEDTRADES_TEXT_CBW_I		= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I);
KC_ENHANCEDTRADES_TEXT_CBW_I_V		= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_V);
KC_ENHANCEDTRADES_TEXT_CBW_I_B		= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_B);
KC_ENHANCEDTRADES_TEXT_CBW_I_V_B	= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_V_B);
KC_ENHANCEDTRADES_TEXT_CBW_I_V_B_A	= format(KC_ENHANCEDTRADES_TEXT_CANTBEMADEWITH_PATTERN	, KC_ENHANCEDTRADES_TEXT_I_V_B_A);

KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN		= "Affiche %s Objets";
KC_ENHANCEDTRADES_TEXT_SI_OPTIMAL	= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_OPTIMAL);
KC_ENHANCEDTRADES_TEXT_SI_MEDIUM	= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_MEDIUM);
KC_ENHANCEDTRADES_TEXT_SI_TRIVIAL	= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_TRIVIAL);
KC_ENHANCEDTRADES_TEXT_SI_EASY		= format(KC_ENHANCEDTRADES_TEXT_SHOWITEMS_PATTERN	, KC_ENHANCEDTRADES_TEXT_EASY);

KC_ENHANCEDTRADES_CONFIG_HEADER			= "KCET v";
KC_ENHANCEDTRADES_CONFIG_DISPLAY_HEADER = "Options d’affichage des colonnes";
KC_ENHANCEDTRADES_CONFIG_FILTER_HEADER	= "Options des filtres";
end