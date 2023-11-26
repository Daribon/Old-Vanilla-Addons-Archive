OneHitWonder_Paladin_UseHammerOfJustice = 1;

function OneHitWonder_PaladinMoreThanOnePaladinInGroup()
	local nr = OneHitWonder_GetNumberOfClassInGroup(ONEHITWONDER_CLASS_PALADIN);
	if ( ( nr ) and ( nr > 1 ) ) then
		return true;
	else
		return false;
	end
end

function OneHitWonder_GetCurrentSeal()
	for i = 0, MAX_PARTY_TOOLTIP_BUFFS do
		buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL|PASSIVE");
		if ( buffIndex >= 0 ) then
			buffName = OneHitWonder_GetBuffNameUsingBuffIndex("player", buffIndex);
			if ( strfind(buffName, "Seal") ) then
				return buffName;
			end
		end
	end
	return nil;
end

function OneHitWonder_Paladin_GetDesiredJugdementSealSpellName()
	local spellName = ONEHITWONDER_SPELL_SEAL_OF_RIGHTEOUSNESS_NAME;
	if ( 
		( OneHitWonder_PaladinMoreThanOnePaladinInGroup() ) 
		and ( not OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_SPELL_SEAL_OF_THE_CRUSADER_JUDGEMENT_EFFECT) ) ) then
		spellName = ONEHITWONDER_SPELL_SEAL_OF_THE_CRUSADER_NAME;
	end
	return spellName;
end

function OneHitWonder_Paladin_GetDesiredPoundingSealSpellName()
	local spellName = ONEHITWONDER_SPELL_SEAL_OF_THE_CRUSADER_NAME;
	if ( OneHitWonder_GetSpellId(spellName) <= -1 ) or ( OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_SPELL_SEAL_OF_THE_CRUSADER_JUDGEMENT_EFFECT) ) then
		spellName = ONEHITWONDER_SPELL_SEAL_OF_RIGHTEOUSNESS_NAME;
	end
	return spellName;
end

function OneHitWonder_Paladin(removeDefense)
	local targetName = UnitName("target");

	if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
		return;
	end
	
	if ( OneHitWonder_UseCountermeasures() ) then
		return;
	end
	
	if ( (not targetName) or ( strlen(targetName) <= 0 ) or ( ( not UnitCanAttack("target", "player") ) ) ) then
		if ( OneHitWonder_ShouldOverrideBindings ~= 1 ) then
			if ( not OneHitWonder_DoStuffContinuously() ) then
				OneHitWonder_DoBuffs();
			end
		end
		return;
	end

	if ( OneHitWonder_InitiateCombat == 0 ) and ( not OneHitWonder_IsInCombat() ) then
		return false;
	end

	OneHitWonder_MeleeAttack();
	local judgmentId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_JUDGEMENT_NAME);
	if ( judgmentId <= -1 ) then
		local spellName = ONEHITWONDER_SPELL_SEAL_OF_THE_CRUSADER_NAME;
		local spellId = OneHitWonder_GetSpellId(spellName);
		if ( spellId <= -1 ) then
			spellName = ONEHITWONDER_SPELL_SEAL_OF_RIGHTEOUSNESS_NAME; 
			spellId = OneHitWonder_GetSpellId(spellName);
		end
		if ( spellId > -1 ) then
			if ( not OneHitWonder_HasPlayerEffect(nil, spellName) ) then
				OneHitWonder_CastSpell(spellId);
				return;
			end
		end
	else
		local spellBook = OneHitWonder_GetSpellBook(spellBook);
		local isJudgementAvailable = OneHitWonder_IsSpellAvailable(judgmentId);
		local start, duration, enable = GetSpellCooldown(judgmentId, spellBook);
		local currentSeal = OneHitWonder_GetCurrentSeal();
		
		local spellName = ONEHITWONDER_SPELL_SEAL_OF_THE_CRUSADER_NAME;
		local spellId = -1;
		if ( not currentSeal ) then
			if ( start == 0 ) then
				spellName = OneHitWonder_Paladin_GetDesiredJugdementSealSpellName();
			else
				spellName = OneHitWonder_Paladin_GetDesiredPoundingSealSpellName();
			end
		elseif ( isJudgementAvailable ) then
			spellName = OneHitWonder_Paladin_GetDesiredJugdementSealSpellName();
			if ( spellName == currentSeal ) then
				spellName = ONEHITWONDER_SPELL_JUDGEMENT_NAME;
			end
		else
			spellName = nil;
		end
		if ( spellName ) then
			spellId = OneHitWonder_GetSpellId(spellName);
		end
		if ( spellId > -1 ) then
			OneHitWonder_CastSpellOnTarget(spellId);
			return;
		end
	end
	if ( not OneHitWonder_DoBuffs() ) then
		OneHitWonder_CheckFriendlies();
		OneHitWonder_HandleActionQueue();
	end
	return;
end

function OneHitWonder_Paladin_GetCasterBuffName(unit)
	local buffList = { ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
	if ( UnitLevel(unit) > UnitLevel("player") ) then
		if ( OneHitWonder_IsUnitTeamMember(unit) ) then
			buffList = { ONEHITWONDER_SPELL_BLESSING_OF_SALVATION_NAME, ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
		end
	end
	return buffList;
end

ONEHITWONDER_PALADIN_SEQUENCE_BLESSING = "BLESSING";

function OneHitWonder_SetupSequenceContinuously_Paladin()
	OneHitWonder_AddContinuousSequence(ONEHITWONDER_PALADIN_SEQUENCE_BLESSING);
end

function OneHitWonder_GetBuffName_Paladin(sequenceId, unit)
	if ( sequenceId == ONEHITWONDER_PALADIN_SEQUENCE_BLESSING ) then
		local ohwClass = OneHitWonder_GetUnitClass(unit);
		if ( OneHitWonder_Paladin_PreferredBlessingList ) then
			RegisterForSave("OneHitWonder_Paladin_PreferredBlessingList");
			local index = ohwClass;
			if ( not OneHitWonder_Paladin_PreferredBlessingList[index] ) then
				index = UnitClass(unit);
			end
			if ( OneHitWonder_Paladin_PreferredBlessingList[index] ) then
				return OneHitWonder_Paladin_PreferredBlessingList[index];
			end
		end
		if ( ohwClass == ONEHITWONDER_CLASS_DRUID ) then
			local pt = UnitPowerType(unit);
			local buffList = { ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME };
			if ( UnitLevel(unit) > UnitLevel("player") ) then
				if ( OneHitWonder_IsUnitTeamMember(unit) ) then
					buffList = { ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_SALVATION_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
				end
			end
			if (pt == ONEHITWONDER_POWERTYPE_MANA ) then
				buffList = OneHitWonder_Paladin_GetCasterBuffName(unit);
			end
			return buffList;
		end
		if ( unit == "player" ) or ( ohwClass == ONEHITWONDER_CLASS_PALADIN ) then
			return { ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME, ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME };
		end
		if ( OneHitWonder_IsStringInList(ohwClass, OneHitWonder_CasterClassesArray) ) then
			return OneHitWonder_Paladin_GetCasterBuffName(unit);
		end
		if ( ohwClass == ONEHITWONDER_CLASS_ROGUE ) or ( ohwClass == ONEHITWONDER_CLASS_WARRIOR ) then
			return { ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
		end
	
	end
	return nil;
end


function OneHitWonder_SetupStuffContinuously_Paladin()
	local fiveMin = math.floor(4.5*60);
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME] = fiveMin;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_PROTECTION_NAME] = 7;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_FREEDOM_NAME] = 11;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_SALVATION_NAME] = fiveMin;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_SANCTUARY_NAME] = fiveMin;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_LIGHT_NAME] = fiveMin;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_SACRIFICE_NAME] = 30;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME] = fiveMin;
	--[[
	local wisdomId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME);
	local salvationId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_BLESSING_OF_SALVATION_NAME);
	]]--
	
	local bestMeleeBlessing = { ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME };
	local bestCasterBlessing = ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME;
	local bestCasterBlessingTarget = ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME;
	local bestDruidCasterBlessing = ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME;
	local bestDruidTankBlessing = ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME;
	local bestDruidDPSBlessing = ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME;
	
	if ( OneHitWonder_IsUnitTeamMember(unit) ) then
		bestCasterBlessing = { ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_SALVATION_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
		bestDruidCasterBlessing = { ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_SALVATION_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
	else
		bestCasterBlessing = { ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
		bestDruidCasterBlessing = { ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME, ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME };
	end
	
	--[[
	
	OneHitWonder_AddStuffContinuously(bestMeleeBlessing, false, true, {onlyBuffClass = { ONEHITWONDER_CLASS_WARRIOR }, canOverrideEffect=true});
	OneHitWonder_AddStuffContinuously(bestMeleeBlessing, false, true, {onlyBuffClass = {ONEHITWONDER_CLASS_ROGUE}, canOverrideEffect=true});
	OneHitWonder_AddStuffContinuously({ ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME, ONEHITWONDER_SPELL_BLESSING_OF_WISDOM_NAME, ONEHITWONDER_SPELL_BLESSING_OF_KINGS_NAME }, false, true, {onlyBuffClass = {ONEHITWONDER_CLASS_PALADIN}, canOverrideEffect=true});
	OneHitWonder_AddStuffContinuously(bestDruidCasterBlessing, false, true, {onlyBuffClass = {ONEHITWONDER_CLASS_DRUID}, powerType = { ONEHITWONDER_POWERTYPE_MANA }, canOverrideEffect=true });
	OneHitWonder_AddStuffContinuously(bestDruidDPSBlessing, false, true, {onlyBuffClass = {ONEHITWONDER_CLASS_DRUID}, powerType = { ONEHITWONDER_POWERTYPE_ENERGY}, canOverrideEffect=true });
	OneHitWonder_AddStuffContinuously(bestDruidTankBlessing, false, true, {onlyBuffClass = {ONEHITWONDER_CLASS_DRUID}, powerType = { ONEHITWONDER_POWERTYPE_RAGE}, canOverrideEffect=true });
	OneHitWonder_AddStuffContinuously(bestCasterBlessing, false, true, {onlyBuffClass = OneHitWonder_CasterClassesArray, invalidUnit = {"target"}, canOverrideEffect=true });
	OneHitWonder_AddStuffContinuously(bestCasterBlessingTarget, false, true, {onlyBuffClass = OneHitWonder_CasterClassesArray, validUnit = {"target"}, canOverrideEffect=true});
	]]--
end

function OneHitWonder_Paladin_GetHighestStunSpellName()
	return ONEHITWONDER_SPELL_HAMMER_OF_JUSTICE_NAME;
end

function OneHitWonder_TryToInterruptSpell_Paladin(unitName, spellName)
	local interruptId = -1;
	local abilityName = "";
	abilityName = OneHitWonder_Paladin_GetHighestStunSpellName();
	if ( OneHitWonder_Paladin_UseHammerOfJustice ~= 1 ) then
		abilityName = "";
	end
	if ( ( abilityName ) and 
		(strlen(abilityName) > 0) ) then
		interruptId = OneHitWonder_GetSpellId(abilityName, "highest");
		if ( not OneHitWonder_IsSpellAvailable(interruptId) ) then
			abilityName = "";
			interruptId = -1;
		end
	end
	return interruptId, abilityName;
end

function OneHitWonder_Paladin_SetUseHammerOfJustice(toggle)
	OneHitWonder_Paladin_UseHammerOfJustice = toggle;
end


function OneHitWonder_Paladin_Cosmos()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PALADIN_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_PALADIN_SEPARATOR),
			TEXT(ONEHITWONDER_PALADIN_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PALADIN_USE_HAMMER_OF_JUSTICE",
			"CHECKBOX",
			TEXT(ONEHITWONDER_PALADIN_USE_HAMMER_OF_JUSTICE),
			TEXT(ONEHITWONDER_PALADIN_USE_HAMMER_OF_JUSTICE_INFO),
			OneHitWonder_Paladin_SetUseHammerOfJustice,
			OneHitWonder_Paladin_UseHammerOfJustice
		);
	end
end

function OneHitWonder_Paladin_RetrieveCleansingSpellId(unit)
	if ( OneHitWonder_IsUnitValidToClean(unit) ) then
		if ( OneHitWonder_ShouldRemoveDebuffs == 1 ) then
			local purifyId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_PURIFY_NAME);
			local cleanseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_CLEANSE_NAME);
			if ( cleanseId > -1 ) or ( purifyId > -1 ) then
				local debuffsByType = OneHitWonder_GetDebuffsByType(unit);
				local hasDisease = (( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE]) > 0 ));
				local hasPoison = (( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_POISON] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_POISON]) > 0 ));
				local hasMagic = (( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC]) > 0 ));
				local spellId = -1;
				if ( not hasMagic ) then
					if ( hasDisease ) or ( hasPoison ) then
						spellId = purifyId;
					end
				else
					spellId = cleanseId;
					if ( spellId <= -1 ) then
						if ( hasDisease ) or ( hasPoison ) then
							spellId = purifyId;
						end
					end
				end
				if ( spellId > -1 ) then
					return spellId;
				end
			end
		end
	end
	return -1;
end

function OneHitWonder_CheckEffect_Paladin(unit)
	if ( UnitCanAttack("player", unit) ) then
		return false;
	end
	local doneStuff = false;
	local spellId = OneHitWonder_Paladin_RetrieveCleansingSpellId(unit);
	if ( spellId ) and ( spellId > -1 ) then
		local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
		if ( unit == "player" ) and ( actionId ) and ( actionId > -1 ) then
			local parameters = { actionId, spellId };
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_ACTION_SELF, parameters);
			doneStuff = true;
		elseif ( not OneHitWonder_HasTarget() ) or ( UnitName("target") == UnitName(unit) ) or ( UnitCanAttack("target", "player") ) then
			local parameters = { spellId, unit };
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
			doneStuff = true;
		end
	end
	return doneStuff;
end

function OneHitWonder_DoStuffContinuously_Paladin()
	if ( not OneHitWonder_IsEnabled() ) then return false; end

	if ( OneHitWonder_ShouldKeepBuffsUp == 0 ) then
		return false;
	end

	local hasAnyAura = false;
	local anyAuras = {};
	local hasAnyBlessing = false;
	local anyBlessings = {};
	local buffIndex, untilCancelled;
	for i = 0, MAX_PARTY_TOOLTIP_BUFFS do
		buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL|PASSIVE");
		if ( buffIndex >= 0 ) then
			buffName = OneHitWonder_GetBuffNameUsingBuffIndex("player", buffIndex);
			if ( strfind(buffName, ONEHITWONDER_SPELL_AURA_SUBSTRING) ) then
				hasAnyAura = true;
				table.insert(anyAuras, buffName);
			end
			if ( strfind(buffName, ONEHITWONDER_SPELL_BLESSING_SUBSTRING) ) then
				hasAnyBlessing = true;
				table.insert(anyBlessings, buffName);
			end
		end
	end
	local hasActiveAura = OneHitWonder_HasAnActiveWhatever(ONEHITWONDER_SPELL_AURA_SUBSTRING, false);
	local auraToTryAndCast = ONEHITWONDER_SPELL_DEVOTION_AURA_NAME;
	if ( OneHitWonder_ShouldTryToCastABuff() ) then
		if ( not hasActiveAura ) and ( OneHitWonder_IsStringInList(auraToTryAndCast, anyAuras) ) then
			local auraId = OneHitWonder_GetSpellId(auraToTryAndCast);
			if ( OneHitWonder_IsSpellAvailable(auraId) ) then
				if ( OneHitWonder_CastSpell(auraId) ) then
					return true;
				end
				--[[
				local castBuff, shouldQuit = OneHitWonder_CastBuff(auraToTryAndCast, nil, "player");
				if ( castBuff or shouldQuit ) then
					return true;
				end
				]]--
			end
		end
		if ( not hasAnyBlessing ) then
			local blessingId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME);
			if ( OneHitWonder_IsSpellAvailable(blessingId) ) then
				local castBuff, shouldQuit = OneHitWonder_CastBuff(ONEHITWONDER_SPELL_BLESSING_OF_MIGHT_NAME, nil, "player");
				if ( castBuff or shouldQuit ) then
					return true;
				end
			end
		end
	end
	
	if ( OneHitWonder_CleanSelf() ) then
		return true;
	end
	
	return false;
end

