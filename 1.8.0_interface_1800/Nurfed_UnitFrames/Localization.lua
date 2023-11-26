
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

NURFED_TOT_UPDATERATE = 0.2;

---------------------------------------------------------------------
--			French
---------------------------------------------------------------------

if ( GetLocale() == "frFR" ) then
	--Class colors
	Nurfed_UnitClass = {
		["Mage"] = "00FFFF",
		["D\195\169moniste"] = "8D54FB",
		["Pr\195\170tre"] = "FFFFFF",
		["Druide"] = "FF8A00",
		["Chaman"] = "FF71A8",
		["Paladin"] = "FF71A8",
		["Voleur"] = "FFFF00",
		["Chasseur"] = "00FF00",
		["Guerrier"] = "B39442",
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

	--Class buffs
	Nurfed_UnitBuffs = {
		["Pr\195\170tre"] = {
			["Mot de pouvoir : Robustesse"] = true,
			["Pri\195\168re de robustesse"] = true,
			["Mot de pouvoir : Bouclier"] = true,
			["R\195\169novation"] = true,
			["Protection contre l\'ombre"] = true,
			["Abolir Maladie"] = true,
			["Esprit divin"] = true,
			["Gardien de peur"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["Mage"] = {
			["Intelligence des arcanes"] = true,
			["Illumination des arcanes"] = true,
			["Dampen Magic"] = true,
			["Amplify Magic"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["Druide"] = {
			["R\195\169cup\195\169ration"] = true,
			["Epines"] = true,
			["Marque de la nature"] = true,
			["Cadeau de la nature"] = true,
			["R\195\169tablissement"] = true,
			["Abolir le Poison"] = true,
			["Innervate"] = true,
			["Tranquility"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["Chaman"] = {
			["de Force de la Terre"] = true,
			["de Peau de pierre"] = true,
			["de S\195\169isme"] = true,
			["Poison Cleansing"] = true,
			["de r\195\169sistance au givre"] = true,
			["Fontaine de mana"] = true,
			["de r\195\169sistance au feu"] = true,
			["de Gl\195\168be"] = true,
			["gu\195\169risseur"] = true,
			["de R\195\169sistance \195\160 la nature"] = true,
			["de Vague de mana"] = true,
			["de Gr\195\162ce a\195\169rienne"] = true,
			["de Mur des vents"] = true,
			["Water Breathing"] = true,
			["Water Walking"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["Paladin"] = {
			["Divine Intervention"] = true,
			["Devotion Aura"] = true,
			["Retribution Aura"] = true,
			["Concentration Aura"] = true,
			["Shadow Resistance Aura"] = true,
			["Frost Resistance Aura"] = true,
			["Fire Resistance Aura"] = true,
			["Sanctity Aura"] = true,
			["B\195\169n\195\169diction de puissance"] = true,
			["Blessing of Protection"] = true,
			["B\195\169n\195\169diction de sagesse"] = true,
			["Blessing of Freedom"] = true,
			["B\195\169n\195\169diction du Sanctuaire"] = true,
			["B\195\169n\195\169diction de salut"] = true,
			["B\195\169n\195\169diction des rois"] = true,
			["B\195\169n\195\169diction de lumi\195\168re"] = true,
			["Blessing of Sacrifice"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["Chasseur"] = {
			["Aspect of the Wild"] = true,
			["Aspect of the Pack"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["D\195\169moniste"] = {
			["Blood Pact"] = true,
			["Unending Breath"] = true,
			["R\195\169surrection de Pierre d\'\195\162me"] = true,
			["Chapeau d\'amiral"] = true,
		},
		["Guerrier"] = {
			["Chapeau d\'amiral"] = true,
		},
		["Voleur"] = {
			["Chapeau d\'amiral"] = true,
		},
	};

	-- Tabs
	NURFEDUNITS_OPTIONS_TABS_GENERAL = "G\195\169n\195\169ral";
	NURFEDUNITS_OPTIONS_TABS_PLAYER = "Joueur";
	NURFEDUNITS_OPTIONS_TABS_PARTY = "Groupe";
	NURFEDUNITS_OPTIONS_TABS_PET = "Familier";
	NURFEDUNITS_OPTIONS_TABS_TARGET = "Cible";

	-- Status
	NURFED_UNIT_DEAD = "Mort";
	NURFED_UNIT_GHOST = "Fant\195\180me";
	NURFED_UNIT_OFFLINE = "Hors Ligne";

	NURFEDUNITFRAMES = "Nurfed Fen\195\170tre D\'Unit\195\169";
	RESET = "R.\195\160.Z.";

	NURFEDUNITFONT = "Fonts\\FRIZQT__.TTF"; 

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

	--Class buffs
	Nurfed_UnitBuffs = {
		["Priester"] = {
			["Machtwort: Seelenst\195\164rke"] = true,
			["Gebet der Seelenst\195\164rke"] = true,
			["Machtwort: Schild"] = true,
			["Erneuerung"] = true,
			["Schattenschutz"] = true,
			["Krankheit aufheben"] = true,
			["G\195\182ttlicher Willen"] = true,
			["Furchtbarriere"] = true,
			["Admiralshut"] = true,
		},
		["Magier"] = {
			["Arkane Intelligenz"] = true,
			["Arkane Brillanz"] = true,
			["Dampen Magic"] = true,
			["Amplify Magic"] = true,
			["Admiralshut"] = true,
		},
		["Druide"] = {
			["Verj\195\188ngung"] = true,
			["Dornen"] = true,
			["Mal der Wildnis"] = true,
			["Gabe der Wildnis"] = true,
			["Nachwachsen"] = true,
			["Vergiftung aufheben"] = true,
			["Anregen"] = true,
			["Gelassenheit"] = true,
			["Admiralshut"] = true,
		},
		["Schamane"] = {
			["der Erdst\195\164rke"] = true,
			["der Steinhaut"] = true,
			["des Erdsto\195\159es"] = true,
			["Poison Cleansing"] = true,
			["des Frostwiderstands"] = true,
			["der Manaquelle"] = true,
			["des Feuerwiderstands"] = true,
			["Grounding Totem Effect"] = true,
			["des heilenden Flusses"] = true,
			["des Naturwiderstands"] = true,
			["der Manaflut"] = true,
			["der luftgleichen Anmut"] = true,
			["der Windmauer"] = true,
			["Water Breathing"] = true,
			["Water Walking"] = true,
			["Admiralshut"] = true,
		},
		["Paladin"] = {
			["Divine Intervention"] = true,
			["Devotion Aura"] = true,
			["Retribution Aura"] = true,
			["Concentration Aura"] = true,
			["Shadow Resistance Aura"] = true,
			["Frost Resistance Aura"] = true,
			["Fire Resistance Aura"] = true,
			["Sanctity Aura"] = true,
			["Segen der Macht"] = true,
			["Blessing of Protection"] = true,
			["Segen der Weisheit"] = true,
			["Blessing of Freedom"] = true,
			["Segen des Refugiums"] = true,
			["Segen der Rettung"] = true,
			["Segen der K\195\182nige"] = true,
			["Segen des Lichts"] = true,
			["Blessing of Sacrifice"] = true,
			["Admiralshut"] = true,
		},
		["J\195\164ger"] = {
			["Aspect of the Wild"] = true,
			["Aspect of the Pack"] = true,
			["Admiralshut"] = true,
		},
		["Hexenmeister"] = {
			["Blood Pact"] = true,
			["Unending Breath"] = true,
			["Seelenstein-Auferstehung"] = true,
			["Admiralshut"] = true,
		},
		["Krieger"] = {
			["Admiralshut"] = true,
		},
		["Schurke"] = {
			["Admiralshut"] = true,
		},
	};

	-- Tabs
	NURFEDUNITS_OPTIONS_TABS_GENERAL = "Allgemein";
	NURFEDUNITS_OPTIONS_TABS_PLAYER = "Spieler";
	NURFEDUNITS_OPTIONS_TABS_PARTY = "Gruppe";
	NURFEDUNITS_OPTIONS_TABS_PET = "Begleiter";
	NURFEDUNITS_OPTIONS_TABS_TARGET = "Ziel";

	-- Status
	NURFED_UNIT_DEAD = "Tot";
	NURFED_UNIT_GHOST = "Geist";
	NURFED_UNIT_OFFLINE = "Offline";

	NURFEDUNITFRAMES = "Nurfed Unit Frame";
	RESET = "Reset";

	NURFEDUNITFONT = "Fonts\\FRIZQT__.TTF";

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

	--Class buffs
	Nurfed_UnitBuffs = {
		["Priest"] = {
			["Power Word: Fortitude"] = true,
			["Prayer of Fortitude"] = true,
			["Power Word: Shield"] = true,
			["Renew"] = true,
			["Shadow Protection"] = true,
			["Abolish Disease"] = true,
			["Divine Spirit"] = true,
			["Fear Ward"] = true,
			["Admiral's Hat"] = true,
		},
		["Mage"] = {
			["Arcane Intellect"] = true,
			["Arcane Brilliance"] = true,
			["Dampen Magic"] = true,
			["Amplify Magic"] = true,
			["Admiral's Hat"] = true,
		},
		["Druid"] = {
			["Rejuvenation"] = true,
			["Thorns"] = true,
			["Mark of the Wild"] = true,
			["Gift of the Wild"] = true,
			["Regrowth"] = true,
			["Abolish Poison"] = true,
			["Innervate"] = true,
			["Tranquility"] = true,
			["Admiral's Hat"] = true,
		},
		["Shaman"] = {
			["Strength of Earth"] = true,
			["Stoneskin"] = true,
			["Tremor Totem Effect"] = true,
			["Poison Cleansing"] = true,
			["Frost Resistance"] = true,
			["Mana Spring"] = true,
			["Fire Resistance"] = true,
			["Grounding Totem Effect"] = true,
			["Healing Stream"] = true,
			["Nature Resistance"] = true,
			["Stoneskin"] = true,
			["Disease Cleansing"] = true,
			["Mana Tide"] = true,
			["Grace of Air"] = true,
			["Windwall"] = true,
			["Water Breathing"] = true,
			["Water Walking"] = true,
			["Admiral's Hat"] = true,
		},
		["Paladin"] = {
			["Divine Intervention"] = true,
			["Devotion Aura"] = true,
			["Retribution Aura"] = true,
			["Concentration Aura"] = true,
			["Shadow Resistance Aura"] = true,
			["Frost Resistance Aura"] = true,
			["Fire Resistance Aura"] = true,
			["Sanctity Aura"] = true,
			["Blessing of Might"] = true,
			["Blessing of Protection"] = true,
			["Blessing of Wisdom"] = true,
			["Blessing of Freedom"] = true,
			["Blessing of Sanctuary"] = true,
			["Blessing of Salvation"] = true,
			["Blessing of Kings"] = true,
			["Blessing of Light"] = true,
			["Blessing of Sacrifice"] = true,
			["Admiral's Hat"] = true,
		},
		["Hunter"] = {
			["Aspect of the Wild"] = true,
			["Aspect of the Pack"] = true,
			["Admiral's Hat"] = true,
		},
		["Warlock"] = {
			["Blood Pact"] = true,
			["Unending Breath"] = true,
			["Soulstone Resurrection"] = true,
			["Admiral's Hat"] = true,
		},
		["Warrior"] = {
			["Admiral's Hat"] = true,
		},
		["Rogue"] = {
			["Admiral's Hat"] = true,
		},
	};

	Nurfed_UnitDeBuffs = {
		["Priest"] = {
			["Magic"] = true,
			["Disease"] = true,
		},
		["Mage"] = {
			["Curse"] = true,
		},
		["Druid"] = {
			["Curse"] = true,
			["Poison"] = true,
		},
		["Shaman"] = {
			["Poison"] = true,
			["Disease"] = true,
		},
		["Paladin"] = {
			["Poison"] = true,
			["Disease"] = true,
			["Magic"] = true,
		},
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

	NURFEDUNITFONT = "Interface\\AddOns\\Nurfed_UnitFrames\\fonts\\SOULPAPA.TTF";
end
