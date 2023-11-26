ONEHITWONDER_ABILITY_REND_TEXTURE = "Interface\\Icons\\Ability_Gouge";
ONEHITWONDER_ABILITY_BATTLESHOUT_TEXTURE = "Interface\\Icons\\Ability_Warrior_BattleShout";

-- needs to be modified by talents
ONEHITWONDER_ABILITY_RAGECOST = {
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
};

--[[
	{ 
		{ talent tab, talent },
		Ability index,
		{ rage cost at rank 1, rage cost at rank 2, ... }
	},
]]--


OneHitWonder_Warrior_UseShieldBash = 1;



function OneHitWonder_TryToInterruptSpell_Warrior(unitName, spellName)
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

function OneHitWonder_Warrior_SetUseShieldBash(toggle)
	OneHitWonder_Warrior_UseShieldBash = toggle;
end



function OneHitWonder_Warrior_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
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
		OneHitWonder_Warrior_BattleShoutRefresh();
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
		
		if ( chargeActionId > -1 ) then
			if ( OneHitWonder_CheckIfInRangeActionId(chargeActionId) ) then
				--Print("In range for Charge.");
				if ( OneHitWonder_CheckIfUsable(chargeActionId, chargeId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
					--Print("Charge!");
					CastSpell(chargeId, ONEHITWONDER_BOOK_TYPE_SPELL);
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
				return;
			end
		end
	end

	if ( PlayerFrame.inCombat ~= 1 ) then
		AttackTarget();
	end
	
	if ( OneHitWonder_Warrior_BattleShoutRefresh() ) then
		return;
	end

	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();

	if ( unitHPPercent >= 25 ) then
		if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
			if ( not OneHitWonder_HasTargetDebuffTexture(ONEHITWONDER_ABILITY_REND_TEXTURE) ) then
				if ( OneHitWonder_HasEnoughRage(ONEHITWONDER_ABILITY_REND_NAME) ) then
					local spellId = 0;
					spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_REND_NAME);
					if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
						return;
					end
				else
					return;
				end
			end
		end
	end	

	if ( stance == ONEHITWONDER_WARRIOR_STANCE_BATTLE ) then
		if ( OneHitWonder_HasEnoughRage(ONEHITWONDER_ABILITY_HEROICSTRIKE_NAME) ) then
			local spellId = 0;
			spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_HEROICSTRIKE_NAME);
			if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
				return;
			end
		else
			return;
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
				elseif ( name == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE_NAME ) then
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
		abilityName = ONEHITWONDER_ABILITY_OVERPOWER_NAME;
		counterId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_OVERPOWER_NAME);
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
		abilityName = ONEHITWONDER_ABILITY_REVENGE_NAME;
		counterId = OneHitWonder_GetSpellId(abilityName);
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_AGGRESSIVE ) then
	elseif ( stance == ONEHITWONDER_WARRIOR_STANCE_BERSERK ) then
	end
	return counterId, abilityName;
end


