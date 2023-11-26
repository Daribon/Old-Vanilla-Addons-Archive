-- Translated by Sulwen.

if ( GetLocale() == "deDE" ) then
	TKill_Rank_String = "(Rank 1)";

	TKill_UnitIsMarkedForDeath_Data = {
		--[[
		["Priester"] = {
			{
				name = "Schattenwort: Schmerz",
				texture = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
			},
		},
		]]--
	};

	TKill_Spells = {
		["Druide"] = {
			{ name = "Mondfeuer", rank = TKill_Rank_String },
		},
		["J\195\164ger"] = {
			{ name = "Arcane Shot", rank = TKill_Rank_String },
			{ name = "Multi Shot", rank = TKill_Rank_String },
			{ name = "Serpent Sting", rank = TKill_Rank_String },
			{ action = PetAttack },
		},
		["Magier"] = {
			{ name = "Feuer-Knall", rank = TKill_Rank_String },
		},
		["Priester"] = {
			--{ name = "Schattenwort: Schmerz", rank = TKill_Rank_String },
		},
		["Schamane"] = {
			{ name = "Erdschock", rank = TKill_Rank_String },
		},
		["Hexenmeister"] = {
			{ action = PetAttack },
		-- "Fluch der Pein", rank = TKill_Rank_String }
		-- "Verderbnis", rank = TKill_Rank_String }
		-- "Leben abziehen", rank = TKill_Rank_String }
		}
	};

	TKill_TotemMoreHealthList = {
		["Steinklaue-Totem"] = {
		50,
		150,
		220,
		280,
		390,
		480
		},
		["Wachposten-Totem"] = {
		100,
		},
	};

	TKill_TotemList_PvP = {
		"Boden-Totem",
		"Erdbindungs-Totem",
		"Beben-Totem",
		"Windzorn-Totem",
		"Flammenzunge-Totem",
		"Windwall-Totem",
		"Feuernova-Totem",
		"Sengtotem",
		"Anmut der Luft-Totem",
		"Feuer-Widerstand-Totem",
		"Natur-Widerstand-Totem",
		"Manaflut-Totem",
		"Heilstrom-Totem",
		"Erdenkraft-Totem",
		"Magma-Totem",
		"Manaquell-Totem",
		"Frost-Widerstand-Totem",
		--"Steinhaut-Totem",
		--"Krankheitss\195\164uberung-Totem",
		--"Gifts\195\164uberungs-Totem"
		--"Steinklaue-Totem", -- this totem is PvE only, and can be ignored
		--"Wachposten-Totem", -- this totem does not do anything in combat and can be ignored
	};
	TKILL_ITEMS_LIFESPAN["Feuernova-Totem"] = 5;
	TKill_TotemList_PvE = TKill_TotemList_PvP;
	
	TKill_TotemList = {
		["PvE"] = TKill_TotemList_PvE,
		["PvP"] = TKill_TotemList_PvP,
		--["Dire Maul"] = TKill_TotemList_PvE_DireMaul, -- don't know zone names yet
		--["Uldaman"] = TKill_TotemList_PvE_Uldaman,
	};

end
