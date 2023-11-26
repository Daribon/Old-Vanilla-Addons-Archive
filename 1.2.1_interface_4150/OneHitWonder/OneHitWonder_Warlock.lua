ONEHITWONDER_WARLOCK_CURSE_EFFECTS = {
	ONEHITWONDER_EFFECT_CURSE_AGONY,
	ONEHITWONDER_EFFECT_CURSE_TONGUES,
	ONEHITWONDER_EFFECT_CURSE_RECKLESSNESS,
	ONEHITWONDER_EFFECT_CURSE_WEAKNESS
};

-- updated with new patch values
ONEHITWONDER_WARLOCK_CURSE_TIMES = {
	[ONEHITWONDER_SPELL_CURSE_AGONY] = 30,
	[ONEHITWONDER_SPELL_CURSE_DOOM] = 1*60,
	[ONEHITWONDER_SPELL_CURSE_ELEMENTS] = 5*60,	
	[ONEHITWONDER_SPELL_CURSE_RECKLESSNESS] = 5*60,
	[ONEHITWONDER_SPELL_CURSE_TONGUES] = 30,
	[ONEHITWONDER_SPELL_CURSE_WEAKNESS] = 2*60
};

OneHitWonder_Warlock_ShadowBurnPercentage = 2;
OneHitWonder_Warlock_SoulDrainPercentage = 20;
OneHitWonder_Warlock_ShardCount = 0;
OneHitWonder_Warlock_MinimumShards = 5;
OneHitWonder_Warlock_ImmolateIfTargetPercentage = 50;
OneHitWonder_Warlock_ImmolateIfSelfPercentage = 30;

OneHitWonder_Warlock_SmartCursing = 0;

OneHitWonder_Warlock_ShouldPetAttack = 0;

OneHitWonder_CursedTargetTime = 0;
OneHitWonder_CurrentCurseTime = 0;
OneHitWonder_LastCurse = nil;

function OneHitWonder_WillUnitGiveSoulShard(unit)
	if ( UnitIsPlayer(unit) ) then
		return false;
	else
		return OneHitWonder_WillUnitLevelGiveSoulShard(unit);
	end
end

function OneHitWonder_WillUnitLevelGiveSoulShard(unit)
	local playerLevel = UnitLevel("player");
	local unitsLevel = UnitLevel(unit);
	local levelDiff = 5;
	
	if (UnitClass(unit) == "elite") then
		levelDiff = 7;
	end
	
	if ( unitsLevel >= (playerLevel-levelDiff) ) then
		return true;
	else
		return false;
	end
end

function OneHitWonder_CastIfTargetNotHasEffect(spell, effect, stopCasting)
	return OneHitWonder_CastIfUnitNotHasEffect("target", spell, effect, stopCasting);
end

function OneHitWonder_CastIfUnitNotHasEffect(unit, spell, effect, stopCasting)
	if ( effect ) then
		local effects = {};
		if ( type(effect) ~= "table" ) then
			effects = { effect };
		else
			effects = effect;
		end
		for k, v in effects do
			if ( OneHitWonder_HasUnitEffect(unit, nil, v) ) then
				return false;
			end
		end
	end
	return OneHitWonder_CastSpellSpecial(spell, stopCasting);
end

function OneHitWonder_CastSpellSpecial(spell, stopCasting)
	local spellId = -1;
	if ( type(spell) == "string" ) then
		spellId = OneHitWonder_GetSpellId(spell);
	elseif ( type(spell) == "number" ) then
		spellId = spell;
	else
		return false;
	end
	if ( OneHitWonder_IsSpellAvailable(spellId) ) then
		if ( stopCasting ) then
			SpellStopCasting();
		end
		return OneHitWonder_CastSpell(spellId);
	else
		return false;
	end
end


function OneHitWonder_GetCurseForTarget()
	local spellName = ONEHITWONDER_SPELL_CURSE_AGONY;
	-- if caster
	if ( UnitPowerType("target") == 0 ) then
		spellName = ONEHITWONDER_SPELL_CURSE_TONGUES;
	end
	if ( OneHitWonder_GetSpellId(spellName) <= -1 ) or ( OneHitWonder_HasUnitEffect("target", nil, spellName) ) then
		spellName = ONEHITWONDER_SPELL_CURSE_WEAKNESS;
	end
	return spellName;
end

function OneHitWonder_Warlock_SpellEnded()
	TargetFrame.isBeingSoulDrained = false;
end

OneHitWonder_Warlock_CommonSpellsInActionBar = {
	ONEHITWONDER_SPELL_IMMOLATE,
	ONEHITWONDER_SPELL_CORRUPTION,
	ONEHITWONDER_SPELL_SHADOW_BOLT,
	ONEHITWONDER_SPELL_CURSE_WEAKNESS,
	ONEHITWONDER_SPELL_CURSE_AGONY,
	ONEHITWONDER_SPELL_CURSE_DOOM,
	ONEHITWONDER_SPELL_CURSE_ELEMENTS,
	ONEHITWONDER_SPELL_CURSE_RECKLESSNESS,
	ONEHITWONDER_SPELL_CURSE_TONGUES,
	ONEHITWONDER_SPELL_DRAIN_SOUL,
	ONEHITWONDER_SPELL_CONFLAGRATE
};

function OneHitWonder_Warlock_IsInSpellRange()
	local spellId, actionId;
	for k, v in OneHitWonder_Warlock_CommonSpellsInActionBar do
		spellId = OneHitWonder_GetSpellId(v);
		if ( spellId ) and ( spellId > -1 ) then
			actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
			if ( actionId ) and ( actionId > -1 ) then
				return OneHitWonder_CheckIfInRangeActionId(actionId);
			end
		end
	end
	return true;
end

function OneHitWonder_Warlock(removeDefense)
	local targetName = UnitName("target");

	if ( not removeDefense ) then removeDefense = false; end
	
	--if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
	if ( OneHitWonder_IsChannelSpellRunning() ) then
		return;
	end
	
	if ( (not targetName) or ( strlen(targetName) <= 0 ) ) then
		if ( not OneHitWonder_UseCountermeasures() ) then
			OneHitWonder_DoBuffs();
		end
		return;
	end
	
	if ( not UnitCanAttack("player", "target") ) then
		if ( not OneHitWonder_UseCountermeasures() ) then
			OneHitWonder_DoBuffs();
		end
		return;
	end
	
	OneHitWonder_CheckFriendlies();
	
	if ( OneHitWonder_HandleActionQueue() ) then
		return;
	end
	
	if (OneHitWonder_PetIsAttacking == false) and ( OneHitWonder_Warlock_IsInSpellRange() ) then
		OneHitWonder_Warlock_SmartPetAttack();
	end
	
	local curTime = GetTime();
		
	local timeSinceSpellStopped = curTime - OneHitWonder_TimeSpellStopped;
	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();

	if ( ( unitHPPercent <= OneHitWonder_Warlock_SoulDrainPercentage ) and ( OneHitWonder_WillUnitGiveSoulShard("target") ) )  then
		if (OneHitWonder_Warlock_ShardCount < OneHitWonder_Warlock_MinimumShards) then
			OneHitWonder_CastSpellSpecial(ONEHITWONDER_SPELL_DRAIN_SOUL, true);
			TargetFrame.isBeingSoulDrained = true;
			return;
		end
	end		

	local shadowBurnId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_SHADOWBURN);
	if ( ( shadowBurnId > -1 ) and ( not TargetFrame.isBeingSoulDrained ) and ( unitHPPercent <= OneHitWonder_Warlock_ShadowBurnPercentage ) and ( OneHitWonder_WillUnitGiveSoulShard("target") ) ) then 
		if ( OneHitWonder_CastSpell(shadowBurnId) ) then
			return;
		end
	end
	
	-- should be optional
	if ( OneHitWonder_ShouldMeleeAttack == 1 ) and ( OneHitWonder_Warlock_IsInSpellRange() ) then
		OneHitWonder_MeleeAttack();
	end

	if (timeSinceSpellStopped >= 0.9) then
		if ( OneHitWonder_CastIfTargetNotHasEffect(ONEHITWONDER_SPELL_CORRUPTION, ONEHITWONDER_EFFECT_CORRUPTION) ) then
			return;
		end
	
		if (unitHPPercent > OneHitWonder_Warlock_ImmolateIfTargetPercentage) then
			if (OneHitWonder_GetUnitHPPercentage("player") > OneHitWonder_Warlock_ImmolateIfSelfPercentage) then
				local immolateTimeLeft = 0;
				if ( OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_EFFECT_IMMOLATE) ) then
					if ( OneHitWonder_Warlock_ImmolateEndTime ) then
						immolateTimeLeft = OneHitWonder_Warlock_ImmolateEndTime - curTime;
					else
						immolateTimeLeft = 15;
					end
				else
					if ( (OneHitWonder_Warlock_ImmolateEndTime) and 
					( ( OneHitWonder_Warlock_ImmolateEndTime - curTime ) <= 10 ) ) then
						immolateTimeLeft = OneHitWonder_Warlock_ImmolateEndTime - curTime;
					end
				end
				local conflagrateId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_CONFLAGRATE);
				if ( conflagrateId > -1 ) then
					if ( ( immolateTimeLeft > 1.5 ) and ( immolateTimeLeft <= 3 ) and ( OneHitWonder_CastSpellSpecial(ONEHITWONDER_SPELL_CONFLAGRATE) )  )then
						OneHitWonder_Warlock_ImmolateEndTime = nil;
						return;
					end
				else
					if ( immolateTimeLeft <= 4 ) then
						if ( OneHitWonder_CastSpellSpecial(ONEHITWONDER_SPELL_IMMOLATE) ) then
							OneHitWonder_Warlock_ImmolateEndTime = curTime+17;
							return;
						end
					end
				end
			end
		end
		if ( OneHitWonder_Warlock_SmartCursing == 1 ) then
			--OneHitWonder_Print("Smart Cursing.");
			local effectName = ONEHITWONDER_WARLOCK_CURSE_EFFECTS;
			local spellName = nil;
			if ( OneHitWonder_IsInPartyOrRaid() ) then
				--OneHitWonder_Print("Group based Cursing.");
				local warlocks = OneHitWonder_GetNumberOfClassInGroup(ONEHITWONDER_CLASS_WARLOCK);
				local priests = OneHitWonder_GetNumberOfClassInGroup(ONEHITWONDER_CLASS_PRIEST);
				local mages = OneHitWonder_GetNumberOfClassInGroup(ONEHITWONDER_CLASS_MAGE);
				-- prevent running
				if ( unitHPPercent <= 5 ) then
					effectName = nil;
					spellName = ONEHITWONDER_SPELL_CURSE_RECKLESSNESS;
				elseif ( ( ( priests + warlocks ) > 1 ) and ( ( priests + warlocks ) >= mages ) ) then
					spellName = ONEHITWONDER_SPELL_CURSE_SHADOW;
				elseif ( mages > (priests+warlocks ) ) then
					spellName = ONEHITWONDER_SPELL_CURSE_ELEMENTS;
				end
			end
			if ( spellName == nil ) then
				spellName = ONEHITWONDER_SPELL_CURSE_AGONY;
				--OneHitWonder_Print("Defaulting to ."..spellName);
			elseif (not OneHitWonder_IsSpellAvailable(OneHitWonder_GetSpellId(spellName))) then
				spellName = ONEHITWONDER_SPELL_CURSE_AGONY;			
				--OneHitWonder_Print("Defaulting to ."..spellName);
			end
			if ( OneHitWonder_GetSpellId(spellName) <= -1 ) then
				--OneHitWonder_Print(spellName.." not found, using CoW");
				spellName = ONEHITWONDER_SPELL_CURSE_WEAKNESS;
				effectName = spellName;
			end
			OneHitWonder_CurrentCurseTime = ONEHITWONDER_WARLOCK_CURSE_TIMES[spellName];
			if ( not OneHitWonder_HasUnitEffect("target", nil, spellName ) ) then
				--OneHitWonder_Print("Did not have the spell");
				OneHitWonder_CurrentCurseTime = 0;
			end
			if ( GetTime()-OneHitWonder_CursedTargetTime >= OneHitWonder_CurrentCurseTime ) then
				--spellName = OneHitWonder_GetCurseForTarget();
				if ( OneHitWonder_CastSpellSpecial(spellName) ) then
					return;
				end
			end
			if ( OneHitWonder_CastIfTargetNotHasEffect(spellName,effectName) ) then
				return;
			end
		else
			local spellName = ONEHITWONDER_SPELL_CURSE_AGONY;
			if ( OneHitWonder_GetSpellId(spellName) <= -1 ) then
				spellName = ONEHITWONDER_SPELL_CURSE_WEAKNESS;
			end
			if ( OneHitWonder_CastIfTargetNotHasEffect(spellName, ONEHITWONDER_WARLOCK_CURSE_EFFECTS) ) then
				return;
			end
		end
	end
	

	if ( not OneHitWonder_DoBuffs() ) then
		if ( OneHitWonder_CastIfTargetNotHasEffect(ONEHITWONDER_ABILITY_SHOOT_NAME, ONEHITWONDER_ABILITY_SHOOT_EFFECT) ) then
			return;
		elseif ( OneHitWonder_CastSpellSpecial(ONEHITWONDER_ABILITY_SHADOW_BOLT_NAME) ) then
			return
		end
	end
	
end

function OneHitWonder_SetMinimumShards(toggle, value)
	OneHitWonder_Warlock_MinimumShards = value;
end

function OneHitWonder_SetSoulDrainPercentage(toggle, value)
	OneHitWonder_Warlock_SoulDrainPercentage = value;
end

function OneHitWonder_SetImmolateIfTargetPercentage(toggle, value)
	OneHitWonder_Warlock_ImmolateIfTargetPercentage = value;
end

function OneHitWonder_SetImmolateIfSelfPercentage(toggle, value)
	OneHitWonder_Warlock_ImmolateIfSelfPercentage = value;
end

function OneHitWonder_Warlock_SetShouldPetAttack(toggle)
	OneHitWonder_Warlock_ShouldPetAttack = toggle;
end

function OneHitWonder_Warlock_SetSmartCursing(toggle)
	OneHitWonder_Warlock_SmartCursing = toggle;
end


function OneHitWonder_Warlock_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_WARLOCK_SEPARATOR),
			TEXT(ONEHITWONDER_WARLOCK_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_USE_SMART_PET_ATTACK",
			"CHECKBOX",
			TEXT(ONEHITWONDER_WARLOCK_USE_SMART_PET_ATTACK),
			TEXT(ONEHITWONDER_WARLOCK_USE_SMART_PET_ATTACK_INFO),
			OneHitWonder_Warlock_SetShouldPetAttack,
			OneHitWonder_Warlock_ShouldPetAttack
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_USE_SMART_CURSING",
			"CHECKBOX",
			TEXT(ONEHITWONDER_WARLOCK_USE_SMART_CURSING),
			TEXT(ONEHITWONDER_WARLOCK_USE_SMART_CURSING_INFO),
			OneHitWonder_Warlock_SetSmartCursing,
			OneHitWonder_Warlock_SmartCursing
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_MINIMUM_SHARDS",
			"SLIDER",
			TEXT(ONEHITWONDER_WARLOCK_MINIMUM_SHARDS),
			TEXT(ONEHITWONDER_WARLOCK_MINIMUM_SHARDS_INFO),
			OneHitWonder_SetMinimumShards,
			1,
			OneHitWonder_Warlock_MinimumShards, -- default
			0, -- min
			40, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARLOCK_MINIMUM_SHARDS_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_SOUL_DRAIN",
			"SLIDER",
			TEXT(ONEHITWONDER_WARLOCK_SOUL_DRAIN),
			TEXT(ONEHITWONDER_WARLOCK_SOUL_DRAIN_INFO),
			OneHitWonder_SetSoulDrainPercentage,
			1,
			OneHitWonder_Warlock_SoulDrainPercentage, -- default
			0, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARLOCK_SOUL_DRAIN_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_IMMOLATE_IFTARGET",
			"SLIDER",
			TEXT(ONEHITWONDER_WARLOCK_IMMOLATE_IFTARGET),
			TEXT(ONEHITWONDER_WARLOCK_IMMOLATE_IFTARGET_INFO),
			OneHitWonder_SetImmolateIfTargetPercentage,
			1,
			OneHitWonder_Warlock_ImmolateIfTargetPercentage, -- default
			0, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARLOCK_IMMOLATE_IFTARGET_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_WARLOCK_IMMOLATE_IFSELF",
			"SLIDER",
			TEXT(ONEHITWONDER_WARLOCK_IMMOLATE_IFSELF),
			TEXT(ONEHITWONDER_WARLOCK_IMMOLATE_IFSELF_INFO),
			OneHitWonder_SetImmolateIfSelfPercentage,
			1,
			OneHitWonder_Warlock_ImmolateIfSelfPercentage, -- default
			0, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_WARLOCK_IMMOLATE_IFSELF_APPEND)
		);
		
	end
	
end

function OneHitWonder_Warlock_CountShards()
	OneHitWonder_Warlock_ShardCount = 0;
	if ( ( DynamicData ) and ( DynamicData.item ) and ( DynamicData.item.getItemInfoByName ) ) then
		--OneHitWonder_Print("Counting shards");
		local itemInfo = DynamicData.item.getItemInfoByName(ONEHITWONDER_WARLOCK_ITEM_SOUL_SHARD);
		if ( itemInfo ) then
			OneHitWonder_Warlock_ShardCount = itemInfo.count;
		end
	end
end

function OneHitWonder_Warlock_SmartPetAttack()
	return OneHitWonder_SmartPetAttack(OneHitWonder_Warlock_ShouldPetAttack);
end


function OneHitWonder_SetupStuffContinously_Warlock()
	--OneHitWonder_BuffTime[highestDemonBuffName] = 25*60;
	--OneHitWonder_BuffTime[highestDetectInvisibilityBuffName] = 9*60;

	local highestDemonBuffName = OneHitWonder_GetHighestBuffName(OneHitWonder_WarlockDemonBuffNames);
	if ( highestDemonBuffName ) then
		OneHitWonder_AddStuffContinously(highestDemonBuffName, true, true);
	end
	local highestDetectInvisibilityBuffName = OneHitWonder_GetHighestBuffName(OneHitWonder_WarlockDetectInvisibilityBuffNames);
	if ( highestDetectInvisibilityBuffName ) then
		OneHitWonder_AddStuffContinously(highestDetectInvisibilityBuffName, true, true);
	end
end


function OneHitWonder_TryToInterruptSpell_Warlock(unitName, spellName)
	local interruptId = -1;
	local abilityName = "";
	if ( OneHitWonder_IsSpellShadowBased(spellName) ) then
		abilityName = ONEHITWONDER_SPELL_SHADOW_WARD_NAME;
	end
	if ( ( abilityName ) and 
		(strlen(abilityName) > 0) and ( not OneHitWonder_HasPlayerEffect(nil, abilityName) ) ) then
		interruptId = OneHitWonder_GetSpellId(abilityName);
		if ( OneHitWonder_CheckIfSpellIsCoolingdownById(interruptId) ) then
			abilityName = "";
			interruptId = -1;
		end
	end
	return interruptId, abilityName;
end


function OneHitWonder_HandleSpellCast_Warlock(spellName)
	if ( ( spellName ) and ( strfind(spellName, "Curse") ) ) then
		OneHitWonder_CurrentCurseTime = ONEHITWONDER_WARLOCK_CURSE_TIMES[spellName];
		if ( not OneHitWonder_CurrentCurseTime ) then
			-- change this?
			OneHitWonder_CurrentCurseTime = 0;
		end
		OneHitWonder_LastCurse = spellName;
		OneHitWonder_CursedTargetTime = GetTime();
	end
end

function OneHitWonder_CheckEffect_Warlock(unit)
	local curTime = GetTime();
	if ( unit == "target" ) then
		if ( UnitCanAttack(unit, "player" ) ) then
			if ( OneHitWonder_HasUnitEffect(unit, nil, ONEHITWONDER_EFFECT_IMMOLATE) ) then
				if ( not OneHitWonder_Warlock_ImmolateEndTime ) then
					OneHitWonder_Warlock_ImmolateEndTime = curTime + 15;
				end
			end
		end
	end
end
