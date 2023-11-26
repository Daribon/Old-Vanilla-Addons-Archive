-------------------------------------------------------------------------------
-- English/Default
-------------------------------------------------------------------------------

WSC_Strings = {
	zone = "Warsong Gulch",
	herald = "Warsong Gulch Herald",
	alliance = "Alliance",
	horde = "Horde",
	atbase = "At base",
	picked = "picked",
	captured = "captured",
	wins = "wins",
	returned = "returned",
	dropped = "dropped",
	unknown = "Unknown"
};

WSC_MyAddons = {
	name = "Warsong Commander",
	description = "A warsong gulch awareness tool",
	version = "Beta 2",
	author = "Vallerius",
	category = MYADDONS_CATEGORY_MAP,
	frame = "WSC_Frame",
	optionsframe = "WSC_OptionsFrame"
};

-------------------------------------------------------------------------------
-- German (Thanks Dorn7/Taé Shala)
-------------------------------------------------------------------------------
if ( GetLocale() == "deDE" ) then
WSC_Strings = {
	zone = "Warsongschlucht",
	herald = "Herold der Warsongschlucht",
	alliance = "Allianz",
	horde = "Horde",
	atbase = "In der Basis",
	picked = "aufgenommen",
	captured = "errungen",
	wins = "siegt",
	returned = "zur\195\188ckgebracht",
	dropped = "verloren",
	unknown = "Unbekannt..."
};

-------------------------------------------------------------------------------
-- French (Thanks Nyllin/Minsonganger)
-------------------------------------------------------------------------------
elseif ( GetLocale() == "frFR" ) then
WSC_Strings = {
	zone = "Goulet des Warsong",
	herald = "H\195\169raut du Goulet des Warsong",
	alliance = "l'Alliance",
	horde = "la Horde",
	atbase = "A la Base",
	picked = "ramass\195\169",
	captured = "a pris",
	wins = "victoire",
	returned = "ramen\195\169",
	dropped = "l\195\162ch\195\169",
	unknown = "Inconnu..."
};

end
