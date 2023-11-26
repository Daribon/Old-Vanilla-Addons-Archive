--** Localization **--

--Mana Color
Nurfed_ManaBarColor = {
	[0] = { r = 0.00, g = 1.00, b = 1.00 },
	[1] = { r = 1.00, g = 0.00, b = 0.00 },
	[2] = { r = 1.00, g = 0.50, b = 0.25 },
	[3] = { r = 1.00, g = 1.00, b = 0.00 },
	[4] = { r = 0.00, g = 1.00, b = 1.00 },
};

--Units
Nurfed_Units = {
	["Nurfed_player"] = "player",
	["Nurfed_pet"] = "pet",
	["Nurfed_target"] = "target",
	["Nurfed_party1"] = "party1",
	["Nurfed_party2"] = "party2",
	["Nurfed_party3"] = "party3",
	["Nurfed_party4"] = "party4",
	["Nurfed_partypet1"] = "partypet1",
	["Nurfed_partypet2"] = "partypet2",
	["Nurfed_partypet3"] = "partypet3",
	["Nurfed_partypet4"] = "partypet4",
	["Nurfed_pettarget"] = "pettarget",
	["Nurfed_targettarget"] = "targettarget",
	["Nurfed_targettargettarget"] = "targettargettarget",
};

Nurfed_UnitAuras = {
	["player"] = { buffs = 0, debuffs = 8 },
	["pet"] = { buffs = 8, debuffs = 8 },
	["target"] = { buffs = 8, debuffs = 8 },
	["party1"] = { buffs = 8, debuffs = 4 },
	["party2"] = { buffs = 8, debuffs = 4 },
	["party3"] = { buffs = 8, debuffs = 4 },
	["party4"] = { buffs = 8, debuffs = 4 },
	["partypet1"] = { buffs = 0, debuffs = 4 },
	["partypet2"] = { buffs = 0, debuffs = 4 },
	["partypet3"] = { buffs = 0, debuffs = 4 },
	["partypet4"] = { buffs = 0, debuffs = 4 },
};

NURFED_TOT_UPDATERATE = 0.2;

---------------------------------------------------------------------
--			French
---------------------------------------------------------------------

if ( GetLocale() == "frFR" ) then
	--Class colors
	Nurfed_UnitClass = {
		["Mage"] =		"00FFFF",
		["D\195\169moniste"] =	"8D54FB",
		["Pr\195\170tre"] =	"FFFFFF",
		["Druide"] =		"FF8A00",
		["Chaman"] =		"FF71A8",
		["Paladin"] =		"FF71A8",
		["Voleur"] =		"FFFF00",
		["Chasseur"] =		"00FF00",
		["Guerrier"] =		"B39442",
	};

	--Class textures
	Nurfed_UnitsClassIcon = {
		["Guerrier"] = { right = 0, left = 0.25, top = 0, bottom = 0.25 },
		["Mage"] = { right = 0.25, left = 0.5, top = 0, bottom = 0.25 },
		["Voleur"] = { right = 0.5, left = 0.75, top = 0, bottom = 0.25 },
		["Druide"] = { right = 0.75, left = 1, top = 0, bottom = 0.25 },
		["Chasseur"] = { right = 0, left = 0.25, top = 0.25, bottom = 0.5 },
		["Chaman"] = { right = 0.25, left = 0.5, top = 0.25, bottom = 0.5 },
		["Pr\195\170tre"] = { right = 0.5, left = 0.75, top = 0.25, bottom = 0.5 },
		["D\195\169moniste"] = { right = 0.75, left = 1, top = 0.25, bottom = 0.5 },
		["Paladin"] = { right = 0, left = 0.25, top = 0.5, bottom = 0.75 },
	};

	-- Tabs
	NURFEDUNITS_OPTIONS_TABS_GENERAL = "General";
	NURFEDUNITS_OPTIONS_TABS_PLAYER = "Player";
	NURFEDUNITS_OPTIONS_TABS_PARTY = "Party";
	NURFEDUNITS_OPTIONS_TABS_PET = "Pet";
	NURFEDUNITS_OPTIONS_TABS_TARGET = "Target";

	-- Status
	NURFED_UNIT_DEAD = "Mort";
	NURFED_UNIT_GHOST = "Fantome";
	NURFED_UNIT_OFFLINE = "Offline";

	NURFEDUNITFRAMES = "Nurfed Armatures D'Unite";
	RESET = "Remise";

---------------------------------------------------------------------
--			German
---------------------------------------------------------------------

elseif ( GetLocale() == "deDE" ) then
	--Class colors
	Nurfed_UnitClass = {
		["Magier"] =		"00FFFF",
		["Hexenmeister"] =	"8D54FB",
		["Priester"] =		"FFFFFF",
		["Druide"] =		"FF8A00",
		["Schamane"] =		"FF71A8",
		["Paladin"] =		"FF71A8",
		["Schurke"] =		"FFFF00",
		["J\195\164ger"] =	"00FF00",
		["Krieger"] =		"B39442",
	};

	--Class textures
	Nurfed_UnitsClassIcon = {
		["Krieger"] = { right = 0, left = 0.25, top = 0, bottom = 0.25 },
		["Magier"] = { right = 0.25, left = 0.5, top = 0, bottom = 0.25 },
		["Schurke"] = { right = 0.5, left = 0.75, top = 0, bottom = 0.25 },
		["Druide"] = { right = 0.75, left = 1, top = 0, bottom = 0.25 },
		["J\195\164ger"] = { right = 0, left = 0.25, top = 0.25, bottom = 0.5 },
		["Schamane"] = { right = 0.25, left = 0.5, top = 0.25, bottom = 0.5 },
		["Priester"] = { right = 0.5, left = 0.75, top = 0.25, bottom = 0.5 },
		["Hexenmeister"] = { right = 0.75, left = 1, top = 0.25, bottom = 0.5 },
		["Paladin"] = { right = 0, left = 0.25, top = 0.5, bottom = 0.75 },
	};

	-- Tabs
	NURFEDUNITS_OPTIONS_TABS_GENERAL = "General";
	NURFEDUNITS_OPTIONS_TABS_PLAYER = "Player";
	NURFEDUNITS_OPTIONS_TABS_PARTY = "Partei";
	NURFEDUNITS_OPTIONS_TABS_PET = "Pet";
	NURFEDUNITS_OPTIONS_TABS_TARGET = "Target";

	-- Status
	NURFED_UNIT_DEAD = "Tot";
	NURFED_UNIT_GHOST = "Geist";
	NURFED_UNIT_OFFLINE = "Offline";

	NURFEDUNITFRAMES = "Nurfed MaBeinheit Rahmen";
	RESET = "Zuruckstellen";

---------------------------------------------------------------------
--			English
---------------------------------------------------------------------

else
	--Class colors
	Nurfed_UnitClass = {
		["Mage"] =	"00FFFF",
		["Warlock"] =	"8D54FB",
		["Priest"] =	"FFFFFF",
		["Druid"] =	"FF8A00",
		["Shaman"] =	"FF71A8",
		["Paladin"] =	"FF71A8",
		["Rogue"] =	"FFFF00",
		["Hunter"] =	"00FF00",
		["Warrior"] =	"B39442",
	};

	--Class textures
	Nurfed_UnitsClassIcon = {
		["Warrior"] = { right = 0, left = 0.25, top = 0, bottom = 0.25 },
		["Mage"] = { right = 0.25, left = 0.5, top = 0, bottom = 0.25 },
		["Rogue"] = { right = 0.5, left = 0.75, top = 0, bottom = 0.25 },
		["Druid"] = { right = 0.75, left = 1, top = 0, bottom = 0.25 },
		["Hunter"] = { right = 0, left = 0.25, top = 0.25, bottom = 0.5 },
		["Shaman"] = { right = 0.25, left = 0.5, top = 0.25, bottom = 0.5 },
		["Priest"] = { right = 0.5, left = 0.75, top = 0.25, bottom = 0.5 },
		["Warlock"] = { right = 0.75, left = 1, top = 0.25, bottom = 0.5 },
		["Paladin"] = { right = 0, left = 0.25, top = 0.5, bottom = 0.75 },
	};

	-- Tabs
	NURFEDUNITS_OPTIONS_TABS_GENERAL = "General";
	NURFEDUNITS_OPTIONS_TABS_PLAYER = "Player";
	NURFEDUNITS_OPTIONS_TABS_PARTY = "Party";
	NURFEDUNITS_OPTIONS_TABS_PET = "Pet";
	NURFEDUNITS_OPTIONS_TABS_TARGET = "Target";

	-- Status
	NURFED_UNIT_DEAD = "Dead";
	NURFED_UNIT_GHOST = "Ghost";
	NURFED_UNIT_OFFLINE = "Offline";

	NURFEDUNITFRAMES = "Nurfed Unit Frames";
	RESET = "Reset";
end
