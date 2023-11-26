ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_DURATION_BASE = 30;
OneHitWonder_Ability_Demoralizing_Shout_Duration = ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_DURATION_BASE;
OneHitWonder_Ability_Hamstring_Duration = 15;
OneHitWonder_Ability_Thunder_Clap_Duration = 20;
ONEHITWONDER_WARRIOR_REND_OVERLAP = 0;


ONEHITWONDER_ABILITY_REND_TEXTURE = "Interface\\Icons\\Ability_Gouge";
ONEHITWONDER_ABILITY_BATTLESHOUT_TEXTURE = "Interface\\Icons\\Ability_Warrior_BattleShout";

-- needs to be modified by talents
ONEHITWONDER_ABILITY_RAGECOST = {
	[ONEHITWONDER_ABILITY_THUNDER_CLAP_NAME] = 20,
	[ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_NAME] = 10,
	[ONEHITWONDER_ABILITY_BATTLESHOUT_NAME] = 20,
	[ONEHITWONDER_ABILITY_HEROICSTRIKE_NAME] = 15,
	[ONEHITWONDER_ABILITY_PUMMEL_NAME] = 10,
	[ONEHITWONDER_ABILITY_REVENGE_NAME] = 5,
	[ONEHITWONDER_ABILITY_SHIELDBASH_NAME] = 10,
	[ONEHITWONDER_ABILITY_REND_NAME] = 10,
	[ONEHITWONDER_ABILITY_HAMSTRING_NAME] = 10,
	[ONEHITWONDER_ABILITY_MOCKINGBLOW_NAME] = 10,
	[ONEHITWONDER_ABILITY_OVERPOWER_NAME] = 5,
	[ONEHITWONDER_ABILITY_EXECUTE_NAME] = 15,
	[ONEHITWONDER_ABILITY_SUNDER_ARMOR_NAME] = 15,
	[ONEHITWONDER_ABILITY_CHARGE_NAME] = 0
};

function OneHitWonder_GetRageConsumption(abilityName)
	return ONEHITWONDER_ABILITY_RAGECOST[abilityName];
end

ONEHITWONDER_WARRIOR_TALENT_RAGE_REDUCERS = {
	{ 
		{ 1,1 },
		ONEHITWONDER_ABILITY_HEROICSTRIKE_NAME,
		{ 14, 13, 12 }
	},
	{ 
		{ 2,9 },
		ONEHITWONDER_ABILITY_REVENGE_NAME,
		{ 13, 10 }
	},
};

--[[
	{ 
		{ talent tab, talent },
		Ability index,
		{ rage cost at rank 1, rage cost at rank 2, ... }
	},
]]--

ONEHITWONDER_ABILITY_SUNDER_ARMOR = {
	90,
	180,
	270,
	360,
	450
};


ONEHITWONDER_MAXIMUM_NUMBER_OF_SUNDERS 		= 5;

OneHitWonder_Warrior_UseHamstring = 1;
OneHitWonder_Warrior_HamstringTargetHPPercentage = 8;
OneHitWonder_Warrior_UseRend = 1;
OneHitWonder_Warrior_RendTargetHPPercentage = 25;
OneHitWonder_Warrior_UseShieldBash = 1;
OneHitWonder_Warrior_UseHeroicStrike = 0;
OneHitWonder_Warrior_HeroicStrikeRage = 90;
OneHitWonder_Warrior_UseDemoralizingShout = 0;
OneHitWonder_Warrior_DemoralizingShoutRage = 0;
OneHitWonder_Warrior_UseThunderClap = 0;
OneHitWonder_Warrior_ThunderClapRage = 0;
OneHitWonder_Warrior_ShouldAutoExecute = 1;

OneHitWonder_Warrior_SundersApplied = {};
OneHitWonder_Warrior_TargetSundersApplied = { numberOfTimesApplied = 0, timeApplied = 0 };

function OneHitWonder_Warrior_SetHamstring(toggle, value)
	OneHitWonder_Warrior_UseHamstring = toggle;
	OneHitWonder_Warrior_HamstringTargetHPPercentage = value;
end

function OneHitWonder_Warrior_SetRend(toggle, value)
	OneHitWonder_Warrior_UseRend = toggle;
	OneHitWonder_Warrior_RendTargetHPPercentage = value;
end

function OneHitWonder_Warrior_GetShieldBash(unitName, spellName)
	local interruptId = -1;
	local abilityName = ONEHITWONDER_ABILITY_SHIELDBASH_NAME;
	if ( OneHitWonder_Warrior_UseShieldBash ~= 1 ) then
		abilityName = "";
	end
	if ( ( abilityName ) and 
		(strlen(abilityName) > 0) ) then
		interruptId = OneHitWonder_GetSpellId(abilityName);
		if ( not OneHitWonder_IsSpellAvailable(interruptId) ) then
			abilityName = "";
			interruptId = -1;
		end
	end
	return interruptId, abilityName;
end


function OneHitWonder_TryToInterruptSpell_Warrior(unitName, spellName)
	local interruptId = -1;
	local abilityName = "";
	local stance = OneHitWonder_Warrior_GetStance();
	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
		interruptId, abilityName = OneHitWonder_Warrior_GetShieldBash(unitName, spellName);
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) then
		interruptId, abilityName = OneHitWonder_Warrior_GetShieldBash(unitName, spellName);
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
		local temp = ONEHITWONDER_ABILITY_PUMMEL_NAME;
		local tempId = OneHitWonder_GetSpellId(temp);
		if ( tempId > -1 ) and ( OneHitWonder_CheckIfUsableSpellId(tempId) ) then
			abilityName = temp;
			interruptId = tempId;
		end
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_BERSERK ) then
	end
	return interruptId, abilityName;
end

function OneHitWonder_Warrior_SetUseShieldBash(toggle)
	OneHitWonder_Warrior_UseShieldBash = toggle;
end

function OneHitWonder_Warrior_SetUseHeroicStrike(toggle, value)
	OneHitWonder_Warrior_UseHeroicStrike = toggle;
	OneHitWonder_Warrior_HeroicStrikeRage = value;
end

function OneHitWonder_Warrior_SetUseDemoralizingShout(toggle, value)
	OneHitWonder_Warrior_UseDemoralizingShout = toggle;
	OneHitWonder_Warrior_DemoralizingShoutRage = value;
end

function OneHitWonder_Warrior_SetUseThunderClap(toggle, value)
	OneHitWonder_Warrior_UseThunderClap = toggle;
	OneHitWonder_Warrior_ThunderClapRage = value;
end

function OneHitWonder_Warrior_Cosmos()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_WARRIOR_SEPARATOR),
			TEXT(ONEHITWONDER_WARRIOR_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_USE_SHIELD_BASH",
			"CHECKBOX",
			TEXT(ONEHITWONDER_WARRIOR_USE_SHIELD_BASH),
			TEXT(ONEHITWONDER_WARRIOR_USE_SHIELD_BASH_INFO),
			OneHitWonder_Warrior_SetUseShieldBash,
			OneHitWonder_Warrior_UseShieldBash
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_USE_HEROIC_STRIKE",
			"BOTH",
			TEXT(ONEHITWONDER_WARRIOR_USE_HEROIC_STRIKE),
			TEXT(ONEHITWONDER_WARRIOR_USE_HEROIC_STRIKE_INFO),
			OneHitWonder_Warrior_SetUseHeroicStrike,
			OneHitWonder_Warrior_UseHeroicStrike,
			OneHitWonder_Warrior_HeroicStrikeRage,
			0,
			100,
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARRIOR_USE_HEROIC_STRIKE_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_USE_DEMORALIZING_SHOUT",
			"BOTH",
			TEXT(ONEHITWONDER_WARRIOR_USE_DEMORALIZING_SHOUT),
			TEXT(ONEHITWONDER_WARRIOR_USE_DEMORALIZING_SHOUT_INFO),
			OneHitWonder_Warrior_SetUseDemoralizingShout,
			OneHitWonder_Warrior_UseDemoralizingShout,
			OneHitWonder_Warrior_DemoralizingShoutRage,
			0,
			100,
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARRIOR_USE_DEMORALIZING_SHOUT_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_USE_THUNDER_CLAP",
			"BOTH",
			TEXT(ONEHITWONDER_WARRIOR_USE_THUNDER_CLAP),
			TEXT(ONEHITWONDER_WARRIOR_USE_THUNDER_CLAP_INFO),
			OneHitWonder_Warrior_SetUseThunderClap,
			OneHitWonder_Warrior_UseThunderClap,
			OneHitWonder_Warrior_ThunderClapRage,
			0,
			100,
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARRIOR_USE_THUNDER_CLAP_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_USE_REND",
			"BOTH",
			TEXT(ONEHITWONDER_WARRIOR_USE_REND),
			TEXT(ONEHITWONDER_WARRIOR_USE_REND_INFO),
			OneHitWonder_Warrior_SetRend,
			OneHitWonder_Warrior_UseRend,
			OneHitWonder_Warrior_RendTargetHPPercentage,
			0,
			100,
			"",
			1,
			1,
			"%"
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARRIOR_USE_HAMSTRING",
			"BOTH",
			TEXT(ONEHITWONDER_WARRIOR_USE_HAMSTRING),
			TEXT(ONEHITWONDER_WARRIOR_USE_HAMSTRING_INFO),
			OneHitWonder_Warrior_SetHamstring,
			OneHitWonder_Warrior_UseHamstring,
			OneHitWonder_Warrior_HamstringTargetHPPercentage,
			0,
			100,
			"",
			1,
			1,
			"%"
		);
	end
end

function OneHitWonder_Warrior_IsUnitRendable(unit)
	return OneHitWonder_CanAbilityAffectUnit(ONEHITWONDER_ABILITY_REND_NAME, unit);
end

function OneHitWonder_Warrior_Powerup(ability)
	OneHitWonder_ShowInfoMessage(string.format(ONEHITWONDER_WARRIOR_INFO_POWERING_UP_FORMAT, ability));
end

function OneHitWonder_Target_Changed_Warrior()
	TargetFrame.rendEnds = nil;
end

OneHitWonder_Warrior_RendDurationByRank = {
	[1] = 9,
	[2] = 12,
	[3] = 15,
	[4] = 18,
	[5] = 21,
	[6] = 21,
	[7] = 21,
};

function OneHitWonder_Warrior_RetrieveRendDuration()
	local spellId = DynamicData.spell.getHighestSpellId(ONEHITWONDER_ABILITY_REND_NAME);
	local spellInfo = DynamicData.spell.getSpellInfo(spellId);
	if ( spellInfo.name == ONEHITWONDER_ABILITY_REND_NAME ) and ( spellInfo.realRank ) then
		local dur = OneHitWonder_Warrior_RendDurationByRank[spellInfo.realRank];
		if ( dur ) then
			return dur;
		else
			return -1;
		end
	else
		return -1;
	end
end

OneHitWonder_Warrior_RendDuration = nil;

function OneHitWonder_Warrior_GetRendDuration()
	if ( not OneHitWonder_Warrior_RendDuration ) then
		OneHitWonder_Warrior_RendDuration = OneHitWonder_Warrior_RetrieveRendDuration();
	end
	return OneHitWonder_Warrior_RendDuration;
end

function OneHitWonder_Warrior_ShouldRendUnit(unit)
	if ( not OneHitWonder_CanAbilityAffectUnit(ONEHITWONDER_ABILITY_REND_NAME, unit) ) then
		return false;
	end
	if ( not OneHitWonder_HasTargetMyAbility(ONEHITWONDER_ABILITY_REND_NAME, ONEHITWONDER_ABILITY_REND_EFFECT) ) then
		return true;
	else
		return false;
	end
end

function OneHitWonder_Warrior_ShouldRendTarget()
	return OneHitWonder_Warrior_ShouldRendUnit("target");
end

OneHitWonder_Warrior_LastAbility = nil;

function OneHitWonder_Warrior_WasLastAbility(ability)
	if ( not OneHitWonder_Warrior_LastAbility ) or ( OneHitWonder_Warrior_LastAbility ~= ability ) then
		return false;
	else
		return true;
	end
end

OneHitWonder_Warrior_BattleShoutRageReservation = 0;
OneHitWonder_Warrior_BattleShoutStartRageReservation = 30;

function OneHitWonder_Warrior_BattleShoutRefresh()
	local spellId = 0;
	spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_BATTLESHOUT_NAME);
	if ( spellId <= -1 ) then
		OneHitWonder_Warrior_BattleShoutRageReservation = 0;
		return false;
	end
	local timeLeft = OneHitWonder_GetTimeLeft(ONEHITWONDER_ABILITY_BATTLESHOUT_TEXTURE);
	OneHitWonder_RageReservation = OneHitWonder_RageReservation - OneHitWonder_Warrior_BattleShoutRageReservation;
	OneHitWonder_Warrior_BattleShoutRageReservation = 0;
	if ( timeLeft < OneHitWonder_Warrior_BattleShoutStartRageReservation ) then
		if ( OneHitWonder_HasEnoughRage(ONEHITWONDER_ABILITY_BATTLESHOUT_NAME, true) ) then
			OneHitWonder_DebugPrint(format("Battleshout id = %d", spellId));
			if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
				return true;
			end
		else
			OneHitWonder_DebugPrint("Not enough rage for BattleShout");
			OneHitWonder_DebugPrint("Allocating rage for BattleShout");
			OneHitWonder_Warrior_BattleShoutRageReservation = OneHitWonder_Warrior_BattleShoutStartRageReservation - timeLeft;
			local maxRageReserved = OneHitWonder_GetRageConsumption(ONEHITWONDER_ABILITY_BATTLESHOUT_NAME);
			if ( OneHitWonder_Warrior_BattleShoutRageReservation > maxRageReserved) then
				OneHitWonder_Warrior_BattleShoutRageReservation = maxRageReserved;
			end
			OneHitWonder_RageReservation = OneHitWonder_RageReservation + OneHitWonder_Warrior_BattleShoutRageReservation;
		end
	end
	return false;
end

function OneHitWonder_Warrior_ShouldHamstringTarget()
	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();
	if ( OneHitWonder_WillUnitRunAway("target") ) 
		and ( unitHPPercent <= OneHitWonder_Warrior_HamstringTargetHPPercentage ) then
		return true;
	else
		return false;
	end
end

function OneHitWonder_Warrior(removeDefense)
	local targetName = UnitName("target");

	if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
		return;
	end
	
	if ( OneHitWonder_HandleActionQueue() ) then
		return;
	end

	if ( (not targetName) or ( strlen(targetName) <= 0 ) ) then
		if ( not OneHitWonder_Warrior_BattleShoutRefresh() ) then
			if ( OneHitWonder_ShouldOverrideBindings == 0 ) then
				OneHitWonder_DoStuffContinuously();
			end
		end
		return;
	end
	
	if ( not removeDefense ) then removeDefense = false; end
	
	local stance = OneHitWonder_Warrior_GetStance();

	OneHitWonder_DebugPrint(format("Current stance = %d", stance));

	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
		local chargeId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_CHARGE_NAME);
		
		local chargeActionId = -1;
		if ( chargeId > -1 ) then
			chargeActionId = OneHitWonder_GetActionIdFromSpellId(chargeId, ONEHITWONDER_BOOK_TYPE_SPELL);
		end
		
		if ( chargeActionId > -1 ) and ( OneHitWonder_CanSpellAffectUnit(ONEHITWONDER_ABILITY_CHARGE_NAME, "target") ) then
			if ( OneHitWonder_CheckIfInRangeActionId(chargeActionId) ) then
				--Print("In range for Charge.");
				if ( OneHitWonder_CheckIfUsable(chargeActionId, chargeId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
					--Print("Charge!");
					OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_CHARGE_NAME;
					OneHitWonder_CastSpell(chargeId, ONEHITWONDER_BOOK_TYPE_SPELL);
					return;
				else
					--Print("Charge not available.");
					return;
				end
			else
				--Print("Not in range for Charge.");
				local currentRange = OneHitWonder_Warrior_GetCurrentRange();
				if ( ( PlayerFrame.inCombat ~= 1 ) and (currentRange ~= ONEHITWONDER_WARRIOR_RANGE_MELEE) ) then
					--Print("Not in combat and not close enough - postponing attempt.");
					--Print("Range is "..currentRange);
					return;
				end
			end
		else
			if ( OneHitWonder_CastSpell(chargeId, ONEHITWONDER_BOOK_TYPE_SPELL ) ) then
				OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_CHARGE_NAME;
				return;
			end
		end
	end

	if ( stance == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
		local interceptId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_INTERCEPT_NAME);
		
		local interceptActionId = -1;
		if ( interceptId > -1 ) then
			interceptActionId = OneHitWonder_GetActionIdFromSpellId(interceptId, ONEHITWONDER_BOOK_TYPE_SPELL);
		end
		
		if ( OneHitWonder_CanSpellAffectUnit(ONEHITWONDER_ABILITY_INTERCEPT_NAME, "target") ) then
			if ( interceptActionId > -1 ) then
				if ( OneHitWonder_CheckIfInRangeActionId(interceptActionId) ) then
					--Print("In range for Intercept.");
					if ( OneHitWonder_CheckIfUsable(interceptActionId, interceptId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
						--Print("Intercept!");
						OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_INTERCEPT_NAME;
						CastSpell(interceptId, ONEHITWONDER_BOOK_TYPE_SPELL);
						return;
					else
						--Print("Intercept not available.");
						return;
					end
				else
					--Print("Not in range for Intercept.");
					local currentRange = OneHitWonder_Warrior_GetCurrentRange();
					if ( ( PlayerFrame.inCombat ~= 1 ) and (currentRange ~= ONEHITWONDER_WARRIOR_RANGE_MELEE) ) then
						--Print("Not in combat and not close enough - postponing attempt.");
						--Print("Range is "..currentRange);
						return;
					end
				end
			else
				if ( OneHitWonder_CastSpell(interceptId, ONEHITWONDER_BOOK_TYPE_SPELL ) ) then
					OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_INTERCEPT_NAME;
					return;
				end
			end
		end
	end

	OneHitWonder_MeleeAttack();


	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();
	if ( OneHitWonder_Warrior_UseHamstring == 1 ) 
		and ( stance ~= ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) 
		and ( OneHitWonder_Warrior_ShouldHamstringTarget() ) then
		
		local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_HAMSTRING_NAME);
		if ( spellId > -1 ) and ( OneHitWonder_Warrior_ShouldHamstringTarget() ) and ( not OneHitWonder_Warrior_WasLastAbility(ONEHITWONDER_ABILITY_HAMSTRING_NAME) ) then
			if ( OneHitWonder_HasEnoughRage(ONEHITWONDER_ABILITY_HAMSTRING_NAME, true) ) then
				if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
					OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_HAMSTRING_NAME;
					OneHitWonder_ApplyMyAbilityToTarget(ONEHITWONDER_ABILITY_HAMSTRING_NAME, OneHitWonder_Warrior_GetDuration(ONEHITWONDER_ABILITY_HAMSTRING_NAME));
					return;
				end
			else
				OneHitWonder_Warrior_Powerup(ONEHITWONDER_ABILITY_HAMSTRING_NAME);
				return;
			end
		end
	end

	if ( OneHitWonder_Warrior_BattleShoutRefresh() ) then
		OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_BATTLESHOUT_NAME;
		OneHitWonder_Warrior_Powerup(ONEHITWONDER_ABILITY_BATTLESHOUT_NAME);
		return;
	end

	if ( OneHitWonder_Warrior_UseRend == 1 ) and ( unitHPPercent >= OneHitWonder_Warrior_RendTargetHPPercentage ) then
		if ( stance ~= ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
			local ability = ONEHITWONDER_ABILITY_REND_NAME;
			local spellId = OneHitWonder_GetSpellId(ability);
			if ( spellId > -1 ) and ( OneHitWonder_Warrior_ShouldRendTarget() ) 
				and ( not OneHitWonder_Warrior_WasLastAbility(ability) ) then
				if ( OneHitWonder_HasEnoughRage(ability) ) then
					if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
						OneHitWonder_Warrior_LastAbility = ability;
						OneHitWonder_ApplyMyAbilityToTarget(ability, OneHitWonder_Warrior_GetDuration(ability));
						return;
					end
				else
					OneHitWonder_Warrior_Powerup(ability);
					return;
				end
			end
		end
	end	

	if ( OneHitWonder_Warrior_UseDemoralizingShout == 1 ) then
		local ability = ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_NAME;
		local spellId = OneHitWonder_GetSpellId(ability);
		if ( spellId > -1 ) 
		and ( not OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_EFFECT) )
		then
			if ( OneHitWonder_HasEnoughRage(ability, OneHitWonder_Warrior_DemoralizingShoutRage) ) then
				if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
					OneHitWonder_ApplyMyAbilityToTarget(ability, OneHitWonder_Warrior_GetDuration(ability));
					OneHitWonder_Warrior_LastAbility = ability;
					return true;
				end
			else
				OneHitWonder_Warrior_Powerup(ability);
				return false;
			end
		end
	end
	if ( OneHitWonder_Warrior_UseThunderClap == 1 ) then
		local ability = ONEHITWONDER_ABILITY_THUNDER_CLAP_NAME;
		local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_THUNDER_CLAP_NAME);
		if ( spellId > -1 ) 
			and ( not OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_ABILITY_THUNDER_CLAP_EFFECT) ) then
			if ( OneHitWonder_HasEnoughRage(ability, OneHitWonder_Warrior_ThunderClapRage) ) then
				if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
					OneHitWonder_ApplyMyAbilityToTarget(ability, OneHitWonder_Warrior_GetDuration(ability));
					OneHitWonder_Warrior_LastAbility = ability;
					return true;
				end
			else
				OneHitWonder_Warrior_Powerup(ability);
				return false;
			end
		end
	end
	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) and ( OneHitWonder_Warrior_UseHeroicStrike == 1 ) then
		local ability = ONEHITWONDER_ABILITY_HEROICSTRIKE_NAME;
		local spellId = OneHitWonder_GetSpellId(ability);
		if ( spellId > -1 ) then
			if ( OneHitWonder_HasEnoughRage(ability, OneHitWonder_Warrior_HeroicStrikeRage) ) then
				if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
					OneHitWonder_Warrior_LastAbility = ability;
					return true;
				end
			else
				OneHitWonder_Warrior_Powerup(ability);
				return false;
			end
		end
	end
end


function OneHitWonder_Warrior_GetStance()
	local numForms = GetNumShapeshiftForms();
	local texture, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;
	for i=1, NUM_SHAPESHIFT_SLOTS do
		if ( i <= numForms ) then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			if ( isActive ) then
				if ( name == ONEHITWONDER_WARRIOR_STANCE_BATTLE_NAME ) then
					return ONEHITWONDER_WARRIOR_STANCE_BATTLE;
				elseif ( name == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE_NAME ) then
					return ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE;
				elseif ( name == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE_NAME ) then
					return ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE;
				elseif ( name == ONEHITWONDER_WARRIOR_STANCE_BERZERK_NAME ) then
					return ONEHITWONDER_WARRIOR_STANCE_BERSERK;
				else
					return -1;
				end
			end
		end
	end
	return -1;
end

function OneHitWonder_Warrior_GetStanceOld()
	local numForms = GetNumShapeshiftForms();
	local texture, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;
	for i=1, NUM_SHAPESHIFT_SLOTS do
		if ( i <= numForms ) then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			if ( isActive ) then
				if ( numForms == 1 ) then
					return ONEHITWONDER_WARRIOR_STANCE_BATTLE;
				elseif ( numForms == 2 ) then
					if ( i == 2 ) then
						return ONEHITWONDER_WARRIOR_STANCE_BATTLE;
					else
						return ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE;
					end
				elseif ( numForms == 3 ) then
					if ( i == 3 ) then	
						return ONEHITWONDER_WARRIOR_STANCE_BATTLE;
					elseif ( i == 2 ) then
						return ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE;
					else
						return ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE;
					end
				elseif ( numForms == 4 ) then
					if ( i == 4 ) then
						return ONEHITWONDER_WARRIOR_STANCE_BATTLE;
					elseif ( i == 3 ) then
						return ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE;
					elseif ( i == 2 ) then
						return ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE;
					else
						return ONEHITWONDER_WARRIOR_STANCE_BERSERK;
					end
				end
			end
		end
	end
	return -1;
end

function OneHitWonder_Warrior_GetGameStanceId(stanceId)
	local numForms = GetNumShapeshiftForms();
	if ( numForms == 1 ) then
		if ( stanceId == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
			return 1;
		end
	elseif ( numForms == 2 ) then
		if ( stanceId == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
			return 2;
		elseif ( stanceId == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) then
			return 1;
		end
	elseif ( numForms == 3 ) then
		if ( stanceId == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
			return 3;
		elseif ( stanceId == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) then
			return 2;
		elseif ( stanceId == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
			return 1;
		end
	elseif ( numForms == 4 ) then
		if ( stanceId == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
			return 4;
		elseif ( stanceId == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) then
			return 3;
		elseif ( stanceId == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
			return 2;
		elseif ( stanceId == ONEHITWONDER_WARRIOR_STANCE_BERSERK ) then
			return 1;
		end
	end
	return -1;
end

ONEHITWONDER_WARRIOR_RANGE_UNKNOWN = 0;
ONEHITWONDER_WARRIOR_RANGE_MELEE = 1;
ONEHITWONDER_WARRIOR_RANGE_CHARGE = 2;
ONEHITWONDER_WARRIOR_RANGE_RANGED = 3;
ONEHITWONDER_WARRIOR_RANGE_BEYOND = 4;

function OneHitWonder_Warrior_GetCurrentRange()
	local stance = OneHitWonder_Warrior_GetStance();
	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
		local chargeId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_CHARGE_NAME);
		local rangedId = -1;
		local meleeRangeId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_REND_NAME);
		if ( meleeRangeId <= -1 ) then OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_HAMSTRING_NAME); end

		if ( not OneHitWonder_CheckIfInRangeSpellId(chargeId) ) then
			if (not OneHitWonder_CheckIfInRangeSpellId(meleeRangeId)) then
				if ( rangedId > -1 ) then
					if (not OneHitWonder_CheckIfInRangeSpellId(rangedId)) then
						return ONEHITWONDER_WARRIOR_RANGE_BEYOND;
					else
						return ONEHITWONDER_WARRIOR_RANGE_RANGED;
					end
				else
					return ONEHITWONDER_WARRIOR_RANGE_BEYOND;
				end
			else
				return ONEHITWONDER_WARRIOR_RANGE_MELEE;
			end
		else
			return ONEHITWONDER_WARRIOR_RANGE_CHARGE;
		end
	end
	return ONEHITWONDER_WARRIOR_RANGE_UNKNOWN;
end



function OneHitWonder_GetBlockCounter_Warrior()
	return OneHitWonder_GetWarriorBlockDodgeParryCounter();
end

function OneHitWonder_GetDodgeCounter_Warrior()
	return OneHitWonder_GetWarriorBlockDodgeParryCounter();
end

function OneHitWonder_GetParryCounter_Warrior()
	return OneHitWonder_GetWarriorBlockDodgeParryCounter();
end

function OneHitWonder_GetTargetDodgeCounter_Warrior()
	local counterId = -1;
	local abilityName = "";
	local stance = OneHitWonder_Warrior_GetStance();
	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
		local temp = ONEHITWONDER_ABILITY_OVERPOWER_NAME;
		local tempId = OneHitWonder_GetSpellId(temp);
		if ( tempId > -1 ) and ( OneHitWonder_CheckIfUsableSpellId(tempId) ) then
			abilityName = temp;
			counterId = tempId;
		end
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) then
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_BERSERK ) then
	end
	return counterId, abilityName;
end



function OneHitWonder_GetWarriorBlockDodgeParryCounter()
	local counterId = -1;
	local abilityName = "";
	local stance = OneHitWonder_Warrior_GetStance();
	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_DEFENSIVE ) then
		local temp = ONEHITWONDER_ABILITY_REVENGE_NAME;
		local tempId = OneHitWonder_GetSpellId(temp);
		if ( tempId > -1 ) and ( OneHitWonder_CheckIfUsableSpellId(tempId) ) then
			abilityName = temp;
			counterId = tempId;
		end
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_BERSERK ) then
	end
	return counterId, abilityName;
end


-- Retrieves the current number of armor sundered from a tooltip strings.
function OneHitWonder_Warrior_RetrieveCurrentSunderedArmor(strings)
	local index = nil;
	local tmpStr = nil;
	local armor = nil;
	for k, v in strings do 
		if (v.left) then
			index = strfind(v.left, ONEHITWONDER_ABILITY_SUNDER_ARMOR_TOOLTIP);
			if ( index ) then
				index = index + strlen(ONEHITWONDER_ABILITY_SUNDER_ARMOR_TOOLTIP);
				tmpStr = strsub(v.left, index);
				armor = findpattern(tmpStr, ONEHITWONDER_ABILITY_SUNDER_ARMOR_NUMBER_STRING);
				if ( armor ) then
					return armor;
				else
					tmpStr = strings[k+1];
					if ( tmpStr ) then
						armor = findpattern(tmpStr.left, ONEHITWONDER_ABILITY_SUNDER_ARMOR_NUMBER_STRING); 
						if ( armor ) then
							return armor;
						end
					end
				end
			end
		end
	end
	return 0;
end

-- what this does is check the mouseover and see if our current sunder can be the one that 
-- caused the sundered effect on the poor unit (if any). It does this by checking how much armor 
-- we can sunder and how much armor is currently sundered (I don't know if that tooltip is visible)
-- and dividing the two values. If we end up with a value that is "not allowed", 
-- then we check for another effect (since 2 warriors generate two sunder armor effects AFAIK).
function OneHitWonder_Warrior_RetrieveCurrentSunderNumber(unit, index)
	local effectInfos = DynamicData.effect.getEffectInfos(unit);
	local tmpEffectInfo = nil;
	local effectInfo = nil;
	if ( not index ) then index = 1; end
	local j = 1;
	local i = index;
	while ( i > 1 ) do
		tmpEffectInfo = effectInfos.buffs[j];
		if ( tmpEffectInfo ) then
			if ( tmpEffectInfo.name == ONEHITWONDER_ABILITY_SUNDER_ARMOR_EFFECT ) then
				effectInfo = tmpEffectInfo;
				i = i - 1;
			end
		end
		j = j + 1;
	end
	if ( effectInfo ) then
		local appliedValue = 1;
		
		local sunderValue = OneHitWonder_Warrior_RetrieveCurrentSunderedArmor(effectInfo.strings);
		if ( sunderValue > 0 ) then
			local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_SUNDER_ARMOR_NAME, ONEHITWONDER_BOOK_TYPE_SPELL);
			local spellInfo = DynamicData.spell.getSpellInfo(spellId, ONEHITWONDER_BOOK_TYPE_SPELL);
			if ( spellInfo ) then
				local armorPerSunder = ONEHITWONDER_ABILITY_SUNDER_ARMOR[spellInfo.realRank];
				local numberOfTimesApplied = ( sunderValue / armorPerSunder );
				if ( numberOfTimesApplied > ONEHITWONDER_MAXIMUM_NUMBER_OF_SUNDERS ) then
					if ( i <= 0 ) then
						return OneHitWonder_Warrior_RetrieveCurrentSunderNumber(unit, index + 1);
					end
				elseif ( numberOfTimesApplied < 0 ) then
					if ( i <= 0 ) then
						return OneHitWonder_Warrior_RetrieveCurrentSunderNumber(unit, index + 1);
					end
				elseif ( math.floor(numberOfTimesApplied) ~= numberOfTimesApplied  ) then
					if ( i <= 0 ) then
						return OneHitWonder_Warrior_RetrieveCurrentSunderNumber(unit, index + 1);
					end
				end
				appliedValue = numberOfTimesApplied;
			end
		end
		
		return appliedValue;
	else
		return 0;
	end
end

function OneHitWonder_Warrior_ApplySunderArmor()
	local curTime = GetTime();
	if ( OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied < curTime ) then
		Print("HELLO SIR1!");
		OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied = OneHitWonder_Warrior_RetrieveCurrentSunderNumber("target");
	end
			Print("HELLO SIR3!");
	if ( OneHitWonder_HasEnoughRage(ONEHITWONDER_ABILITY_SUNDER_ARMOR_NAME) ) then
		local spellId = 0;
		Print("HELLO SIR2!");
		spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_SUNDER_ARMOR_NAME, ONEHITWONDER_BOOK_TYPE_SPELL);
		if ( not OneHitWonder_IsSpellAvailable(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) and ( not OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
			return;
		end
		OneHitWonder_Warrior_LastAbility = ONEHITWONDER_ABILITY_SUNDER_ARMOR_NAME;
	else
		return;
	end
	Print("HELLO SIR4!");
	if ( not OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied ) then
		OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied = 1;
	else
		OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied = OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied + 1;
	end
	if ( OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied > ONEHITWONDER_MAXIMUM_NUMBER_OF_SUNDERS ) then
		OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied = ONEHITWONDER_MAXIMUM_NUMBER_OF_SUNDERS;
	end
	OneHitWonder_Warrior_TargetSundersApplied.timeApplied = curTime;
end

-- place any nice logic here
function OneHitWonder_Warrior_GetNumberOfSundersToApply(unit)
	return ONEHITWONDER_MAXIMUM_NUMBER_OF_SUNDERS;
end

function OneHitWonder_Warrior_ShouldApplySunderArmor()
	local data = OneHitWonder_Warrior_TargetSundersApplied;
	local curTime = GetTime();
	if ( data.numberOfTimesApplied < OneHitWonder_Warrior_GetNumberOfSundersToApply() ) then
		return true;
	end
	-- if the effect expires within 5 seconds, suggest that we reapply it
	if ( data.timeApplied < ( curTime + 5 ) ) then
		return true;
	else
		return false;
	end
end

-- is it this advanced?
function OneHitWonder_Warrior_CleanSunderArmors()
	local unitName = UnitName("target");
	if ( not OneHitWonder_Warrior_SundersApplied[unitName] ) then
		OneHitWonder_Warrior_SundersApplied[unitName] = {};
		return;
	end
	local i = 1;
	local data = nil;
	local curTime = GetTime();
	while ( i < table.getn(OneHitWonder_Warrior_SundersApplied[unitName] ) ) do
		data = OneHitWonder_Warrior_SundersApplied[unitName][i];
		if ( data ) then
			if ( data.time < curTime ) then
				table.remove(OneHitWonder_Warrior_SundersApplied[unitName], i);
			else
				i = i + 1;
			end
		else
			break;
		end
	end
end

function OneHitWonder_UnitHealthCheck_Warrior(unit)

	-- Do the execute check.
	if ( PlayerFrame.inCombat == 1 ) and (( OneHitWonder_HasTarget() ) and ( UnitCanAttack("target", "player") ) and ( unit == "target" ) ) then
		local unitHPPercent = OneHitWonder_GetTargetHPPercentage();
		local stance = OneHitWonder_Warrior_GetStance();

		--Do the Execute Holler. 
		if ( unitHPPercent <= 20 ) then	
			if (( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) or ( stance == ONEHITWONDER_WARRIOR_STANCE_BERZERK_NAME)) then
				if ( OneHitWonder_HasEnoughRage(ONEHITWONDER_ABILITY_EXECUTE_NAME, true) ) then
					local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_EXECUTE_NAME);
					if ( spellId > -1 ) and ( OneHitWonder_IsSpellAvailable(spellId) ) then
						OneHitWonder_ShowImperativeMessage(ONEHITWONDER_ABILITY_EXECUTE_NAME);
						if ( OneHitWonder_Warrior_ShouldAutoExecute == 1 ) then
							local parameters = { spellId, "target", ( GetTime() + 2 ) };
							OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
						end
						return;
						--local spellId = 0;
						--spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_EXECUTE_NAME);
						--if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
						--	return;
						--end
					end
				end
			end
		end
	end
end



function OneHitWonder_Target_Changed_Warrior()
	local unitName = UnitName("target");

	OneHitWonder_Warrior_TargetSundersApplied.numberOfTimesApplied = OneHitWonder_Warrior_RetrieveCurrentSunderNumber("target");
	OneHitWonder_Warrior_TargetSundersApplied.timeApplied = curTime;
	--OneHitWonder_Warrior_SundersApplied[unitName] = {};

end

function OneHitWonder_Warrior_GetDuration(ability)
	if ( ability == ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_NAME ) then
		return OneHitWonder_Ability_Demoralizing_Shout_Duration;
	elseif ( ability == ONEHITWONDER_ABILITY_HAMSTRING_NAME ) then
		return OneHitWonder_Ability_Hamstring_Duration;
	elseif ( ability == ONEHITWONDER_ABILITY_REND_NAME ) then
		return OneHitWonder_Warrior_GetRendDuration();
	elseif ( ability == ONEHITWONDER_ABILITY_THUNDER_CLAP_NAME ) then
		return OneHitWonder_Ability_Thunder_Clap_Duration;
	else
		return -1;
	end
end

OneHitWonder_Warrior_Talent_ShoutDurationIncreaseTab = 2;
OneHitWonder_Warrior_Talent_ShoutDurationIncreaseTalent = 1;

function OneHitWonder_TalentPointsUpdated_Warrior()
	OneHitWonder_UpdateRageConsumptionWithTalents("ONEHITWONDER_ABILITY_ENERGYCOST", ONEHITWONDER_ROGUE_TALENT_ENERGY_REDUCERS);
	local name, _, tier, column, rank, maxRank = GetTalentInfo(OneHitWonder_Warrior_Talent_ShoutDurationIncreaseTab, OneHitWonder_Warrior_Talent_ShoutDurationIncreaseTalent);
	local modifier = 1;
	if ( rank > 0 ) then
		modifier = 1+(rank/10);
	end
	OneHitWonder_Ability_Demoralizing_Shout_Duration = ONEHITWONDER_ABILITY_DEMORALIZING_SHOUT_DURATION_BASE*modifier;
end
