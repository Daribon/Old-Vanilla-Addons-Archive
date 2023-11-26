--[[
This is the basic template for adding a variable:

["variable"] = { func = function(text, unit)
		code that creates the value that replaces your variable
		text = TipBuddy_gsub(text, 'variable', value);
		return text;
	end,
	events = {"event", "event2", ...} },

variable - Can be anything you want and doesn't necessarily have to be preceded with a $.
func - This is the function called when the variable needs to be updated.
	text - This is the entire text of the TextBox and must be returned after it is modified.
	unit - This is the unit ID (party1, player, target, etc.) that the TextBox refers to.
	No other parameters will be passed to your function and those 2 will always be passed.
	text = TipBuddy_gsub(text, 'variable', value) - This line is used to replace the variable 
	with the value you generated in the preceding code.  It handles trimming leading spaces 
	if value is nil or false.
events - List all the events here that will cause the variable to update.  You can enter as many 
	as you want.  Variables are only updated when event's unit is the same as the TextBox's unit.  
	PARTY_MEMBERS_CHANGED and PLAYER_TARGET_CHANGED are registered automatically and appropriately 
	for each textbox and need not be defined as events.
--]]

TB_VARIABLE_FUNCTIONS = {
	-- New Line
	["$nl"] = { func = function(text, unit)
				text = string.gsub(text, '$nl', "\n");
				return text;
		end,
		},

	-- Name
	["$nm"] = { func = function(text, unit)
				local unitname = TipBuddy.gtt_name;
				if (not unitname) then unitname = unit; end
				text = TipBuddy_gsub(text, '$nm', unitname);
				return text;
		end,
		},

	-- Level
	["$lv"] = { func = function(text, unit)
				local level = TipBuddy.gtt_level;
				text = TipBuddy_gsub(text, '$lv', level);
				return text;
		end,
		},

	-- Player Class
	["$cl"] = { func = function(text, unit)
			local class = TipBuddy.gtt_class;
			if (class == "") then class = "class"; end
			return text;
		end,
		},

	-- Current Health
	["$hc"] = { func = function(text, unit)
			local health = TipBuddy_Get_Health(unit);
			text = TipBuddy_gsub(text, '$hc', health);
			return text;
		end,
		},

	-- Max Health
	["$hm"] = { func = function(text, unit)
			local healthmax = TipBuddy_Get_MaxHealth(unit);
			text = TipBuddy_gsub(text, '$hm', healthmax);
			return text;
		end,
		},

	-- Health as a percent
	["$hp"] = { func = function(text, unit)
			local percent = 0;
			local health = TipBuddy_Get_Health(unit);
			local healthmax = TipBuddy_Get_MaxHealth(unit);
			if (healthmax > 0) then
				percent = math.floor(health/healthmax * 100);
			else
				percent = 0;
			end
			text = TipBuddy_gsub(text, '$hp', percent);
			return text;
		end,
		},

	-- Current Mana
	["$mc"] = { func = function(text, unit)
			local mana = UnitMana(unit);
			text = TipBuddy_gsub(text, '$mc', mana, 1);
			return text;
		end,
		},

	-- Max Mana
	["$mm"] = { func = function(text, unit)
			local manamax = UnitManaMax(unit);
			if (not manamax) then
				manamax = 0;
			end
			text = TipBuddy_gsub(text, '$mm', manamax, 1);
			return text;
		end,
		},

	-- Mana as a percent
	["$mp"] = { func = function(text, unit)
			local mana = UnitMana(unit);
			local manamax = UnitManaMax(unit);
			local percent = 0;
			if (manamax == 0) then
				percent = 0;
			else
				percent = math.floor(mana/manamax * 100);
			end
			text = TipBuddy_gsub(text, '$mp', percent, 1);
			return text;
		end,
		},


	-- Race
	["$rc"] = { func = function(text, unit)
			local race = UnitRace(unit);
			if (not UnitName(unit)) then race = "race"; end
			text = TipBuddy_gsub(text, '$rc', race);
			return text;
		end,
		},

	--[[ Death Status - DEAD, GHOST, or nothing
	["$ds"] = { func = function(text, unit)
			local value;
			if (UnitIsGhost(unit)) then
				value = TipBuddy_TEXT.Ghost;
			elseif (UnitIsDead(unit)) then
				value = TipBuddy_TEXT.Dead;
			elseif (not UnitName(unit)) then
				value = TipBuddy_TEXT.Dead;
			else
				value = "";
			end
			text = TipBuddy_gsub(text, '$ds', value);
			return text;
		end,
		},]]

	-- Faction - Horde, Alliance, or nothing
	["$fa"] = { func = function(text, unit)
			local value = UnitFactionGroup(unit);
			if (not UnitName(unit)) then value = "faction"; end
			text = TipBuddy_gsub(text, '$fa', value);
			return text;
		end,
		},

	--[[In Combat - COMBAT or nothing
	["$ic"] = { func = function(text, unit)
			local value = "";
			if (UnitAffectingCombat(unit) or (not UnitName(unit))) then
				value = TipBuddy_TEXT.Combat;
			end
			text = TipBuddy_gsub(text, '$ic', value);
			return text;
		end,
		},]]

	-- Creature Classification - Elite, Boss, etc.
	["$cc"] = { func = function(text, unit)
			local value = UnitClassification(unit);
			if (value == "normal") then
				value = "";
			elseif (value == "elite" or (not UnitName(unit))) then
				value = tb_translate_elite;
			elseif (value == "worldboss") then
				value = tb_translate_worldboss;
			elseif (value == "rare") then
				value = tb_translate_rare;
			elseif (value == "rareelite") then
				value = tb_translate_rareelite;
			end
			text = TipBuddy_gsub(text, '$cc', value);
			return text;
		end,
		},

	-- Creature Type - Beast, Humanoid, Undead, etc.
	["$ct"] = { func = function(text, unit)
			local value = UnitCreatureType(unit);
			if (UnitIsPlayer(unit)) then value = nil; end
			if (not UnitName(unit)) then value = "beast"; end
			text = TipBuddy_gsub(text, '$ct', value);
			return text;
		end,
		},

	-- Creature Family - Bear, Crab, Cat, etc.
	["$cf"] = { func = function(text, unit)
			local value = UnitCreatureFamily(unit);
			if (not UnitName(unit)) then value = "cat"; end
			text = TipBuddy_gsub(text, '$cf', value);
			return text;
		end,
		},

	-- Tapped - TAPPED or nothing
	["$do"] = { func = function(text, unit)
			local value;
			if (UnitIsTapped(unit) and (not UnitIsTappedByPlayer(unit))) then
				value = TipBuddy_TEXT.Tapped
			end
			text = TipBuddy_gsub(text, '$do', value);
			return text;
		end,
		},

	-- Unit Reaction - Hostile, Neutral, Friendly
	["$re"] = { func = function(text, unit)
			local value = UnitReaction("player", unit);
			if (value) then
				if (value < 4) then
					value = TipBuddy_TEXT.Hostile;
				elseif (value == 4) then
					value = TipBuddy_TEXT.Neutral;
				else
					value = TipBuddy_TEXT.Friendly;
				end
			end
			text = TipBuddy_gsub(text, '$re', value);
			return text;
		end,
		},

	--PVP Rank
	["$pr"] = { func = function(text, unit)
			local value = GetPVPRankInfo(UnitPVPRank(unit), unit);
			text = TipBuddy_gsub(text, '$pr', value);
			return text;
		end,
		},

	--PVP Rank Number
	["$pn"] = { func = function(text, unit)
			local value = UnitPVPRank(unit);
			if (value > 0) then
				value = value - 4;
			else
				value = nil;
			end
			text = TipBuddy_gsub(text, '$pn', value);
			return text;
		end,
		},

	--PVP Tagged - PvP or PvP Free For All
	["$pt"] = { func = function(text, unit)
			local value;
			if (UnitIsPVPFreeForAll(unit)) then
				value = "FFA";
			elseif (UnitIsPVP(unit)) then
				value = PVP_ENABLED;
			end
			text = TipBuddy_gsub(text, '$pt', value);
			return text;
		end,
		},

	--Mana Label - Mana, Energy, Rage, Focus
	["$ml"] = { func = function(text, unit)
			local value = UnitPowerType(unit);
			if (value == 0) then
				value = MANA;
			elseif (value == 1) then
				value = RAGE;
			elseif (value == 2) then
				value = FOCUS;
			elseif (value == 3) then
				value = ENERGY;
			end
			text = TipBuddy_gsub(text, '$ml', value);
			return text;
		end,
		},

	--Creature Difficulty - Trivial, Minor, Suicide, etc.
	["$cd"] = { func = function(text, unit)
			local _, value = TipBuddy_GetDifficultyColor(TipBuddy.gtt_level);
			text = TipBuddy_gsub(text, '$cd', value);
			return text;
		end,
		},

	--Guild
	["$gu"] = { func = function(text, unit)
			local value = TipBuddy.gtt_guild;
			text = TipBuddy_gsub(text, '$gu', value);
			return text;
		end,
		},

	-- Unit Target's Name
	["$tn"] = { func = function(text, unit)
			local value = this.targetname;
			if (not value) then
				value = TipBuddy_TEXT.NoTarget;
			elseif (UnitIsUnit(unit.."target", "player")) then
				value = TipBuddy_TEXT.You;
			elseif (UnitIsUnit(unit.."target", "target")) then
				value = TipBuddy_TEXT.YourTarget;
			end
			text = TipBuddy_gsub(text, '$tn', value);
			return text;
		end,
		},


	-- NPC
	["$np"] = { func = function(text, unit)
		local value;
		if (not UnitIsPlayer(unit)) then
			value = "NPC";
		end
		text = TipBuddy_gsub(text, '$np', value);
		return text;
		end,
		},

	-- Civilian
	["$cv"] = { func = function(text, unit)
		local value;
		if (UnitIsCivilian(unit)) then
			value = "Civilian";
		end
		text = TipBuddy_gsub(text, '$cv', value);
		return text;
		end,
		},

	-- Shorthand Elite Text
	["$cx"] = { func = function(text, unit)
			local value = UnitClassification(unit);
			if (value == "normal") then
				value = nil;
			elseif (value == "elite" or (not UnitName(unit))) then
				value = "+";
			elseif (value == "worldboss") then
				value = "++";
			elseif (value == "rare") then
				value = "(R)";
			elseif (value == "rareelite") then
				value = "(R)+";
			end
			text = TipBuddy_gsub(text, '$cx', value);
			return text;
		end,
		},

	---- COLORS ----
	-- Reaction Name
	["[Crn]"] = { func = function(text, unit)
		local value = getglobal("tbcolor_nam_"..TipBuddy_GetUnitReaction( unit ));
		text = TipBuddy_gsub(text, '[Crn]', value);
		return text;
		end,
		},

	-- Reaction Guild
	["[Crg]"] = { func = function(text, unit)
		local value = getglobal("tbcolor_gld_"..TipBuddy_GetUnitReaction( unit ));
		text = TipBuddy_gsub(text, '[Crg]', value);
		return text;
		end,
		},

	-- Difficulty
	["[Cdf]"] = { func = function(text, unit)
		local value = getglobal(TipBuddy_GetDifficultyColor(TipBuddy.gtt_level));
		text = TipBuddy_gsub(text, '[Cdf]', value);
		return text;
		end,
		},

	-- Class Color
	["[Ccl]"] = { func = function(text, unit)
		local value = TipBuddy.gtt_classcolor;
		text = TipBuddy_gsub(text, '[Ccl]', value);
		return text;
		end,
		},

	-- Corpse Color
	-- Will only color text if unit is a corpse
	["[Ccp]"] = { func = function(text, unit)
		local value;
		if (UnitHealth(unit) <= 0) then
			value = tbcolor_corpse;
			--TipBuddy.gtt_classlvlcolor = tbcolor_corpse;
			--TipBuddy.gtt_classcorpse = " "..tb_translate_corpse;
		else
			value = "";
		end
		text = TipBuddy_gsub(text, '[Ccp]', value);
		return text;
		end,
		},
};

function TipBuddy_gsub(text, variable, value)
	if (value) then
		text = string.gsub(text, variable, value);
	elseif (string.find(text, " "..variable)) then
		text = string.gsub(text, " "..variable, "");
	else
		text = string.gsub(text, variable, "");
	end
	return text;
end