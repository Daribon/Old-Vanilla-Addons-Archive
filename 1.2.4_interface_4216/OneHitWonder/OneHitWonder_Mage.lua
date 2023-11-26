OneHitWonder_Mage_ShouldBuffNonCastersIntellect = 0;
OneHitWonder_Mage_ArcaneIntellectMana = 80;
OneHitWonder_Mage_ShouldReactiveCastFireWard = 1;
OneHitWonder_Mage_ShouldReactiveCastFrostWard = 1;
OneHitWonder_Mage_ShouldReactiveCastManaShield = 0;

OneHitWonder_Mage_ShouldBuffDampenMagicWhenNoHealer = 0;

OneHitWonder_Mage_ReactiveManaShieldHealthPercentage = 30;
OneHitWonder_Mage_ReactiveManaShieldManaPercentage = 70;

function OneHitWonder_Mage_SetShouldBuffNonCastersIntellect(toggle)
	OneHitWonder_Mage_ShouldBuffNonCastersIntellect = toggle;
	OneHitWonder_SetupStuffContinuously();
end

function OneHitWonder_Mage_SetArcaneIntellectMana(toggle, value)
	OneHitWonder_Mage_ArcaneIntellectMana = value;
	OneHitWonder_SetupStuffContinuously();
end

function OneHitWonder_Mage_SetShouldReactiveCastFireWard(toggle)
	OneHitWonder_Mage_ShouldReactiveCastFireWard = toggle;
end

function OneHitWonder_Mage_SetShouldReactiveCastFrostWard(toggle)
	OneHitWonder_Mage_ShouldReactiveCastFrostWard = toggle;
end

function OneHitWonder_Mage_SetShouldReactiveCastManaShield(toggle)
	OneHitWonder_Mage_ShouldReactiveCastManaShield = toggle;
end

function OneHitWonder_Mage_SetReactiveManaShieldHealthPercentage(toggle, value)
	OneHitWonder_Mage_ReactiveManaShieldHealthPercentage = value;
end

function OneHitWonder_Mage_SetReactiveManaShieldManaPercentage(toggle, value)
	OneHitWonder_Mage_ReactiveManaShieldManaPercentage = value;
end

function OneHitWonder_Mage_SetShouldBuffDampenMagicWhenNoHealer(toggle)
	OneHitWonder_Mage_ShouldBuffDampenMagicWhenNoHealer = toggle;
end

function OneHitWonder_Mage_Cosmos()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_MAGE_SEPARATOR),
			TEXT(ONEHITWONDER_MAGE_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_BUFF_NON_CASTERS_INTELLECT",
			"CHECKBOX",
			TEXT(ONEHITWONDER_MAGE_BUFF_NON_CASTERS_INTELLECT),
			TEXT(ONEHITWONDER_MAGE_BUFF_NON_CASTERS_INTELLECT_INFO),
			OneHitWonder_Mage_SetShouldBuffNonCastersIntellect,
			OneHitWonder_Mage_ShouldBuffNonCastersIntellect
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_ARCANE_INTELLECT_MANA",
			"SLIDER",
			TEXT(ONEHITWONDER_MAGE_ARCANE_INTELLECT_MANA),
			TEXT(ONEHITWONDER_MAGE_ARCANE_INTELLECT_MANA_INFO),
			OneHitWonder_Mage_SetArcaneIntellectMana,
			1,
			OneHitWonder_Mage_ArcaneIntellectMana,
			0,
			101,
			"",
			1,
			1,
			TEXT(ONEHITWONDER_MAGE_ARCANE_INTELLECT_MANA_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_BUFF_DAMPEN_MAGIC_WHEN_NO_HEALERS",
			"CHECKBOX",
			TEXT(ONEHITWONDER_MAGE_BUFF_DAMPEN_MAGIC_WHEN_NO_HEALERS),
			TEXT(ONEHITWONDER_MAGE_BUFF_DAMPEN_MAGIC_WHEN_NO_HEALERS_INFO),
			OneHitWonder_Mage_SetShouldBuffDampenMagicWhenNoHealer,
			OneHitWonder_Mage_ShouldBuffDampenMagicWhenNoHealer
		);
		
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_REACTIVE_CAST_FIRE_WARD",
			"CHECKBOX",
			TEXT(ONEHITWONDER_MAGE_REACTIVE_CAST_FIRE_WARD),
			TEXT(ONEHITWONDER_MAGE_REACTIVE_CAST_FIRE_WARD_INFO),
			OneHitWonder_Mage_SetShouldReactiveCastFireWard,
			OneHitWonder_Mage_ShouldReactiveCastFireWard
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_REACTIVE_CAST_FROST_WARD",
			"CHECKBOX",
			TEXT(ONEHITWONDER_MAGE_REACTIVE_CAST_FROST_WARD),
			TEXT(ONEHITWONDER_MAGE_REACTIVE_CAST_FROST_WARD_INFO),
			OneHitWonder_Mage_SetShouldReactiveCastFrostWard,
			OneHitWonder_Mage_ShouldReactiveCastFrostWard
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_REACTIVE_CAST_MANA_SHIELD",
			"CHECKBOX",
			TEXT(ONEHITWONDER_MAGE_REACTIVE_CAST_MANA_SHIELD),
			TEXT(ONEHITWONDER_MAGE_REACTIVE_CAST_MANA_SHIELD_INFO),
			OneHitWonder_Mage_SetShouldReactiveCastManaShield,
			OneHitWonder_Mage_ShouldReactiveCastManaShield
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_HEALTH",
			"SLIDER",
			TEXT(ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_HEALTH),
			TEXT(ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_HEALTH_INFO),
			OneHitWonder_Mage_SetReactiveManaShieldHealthPercentage,
			1,
			OneHitWonder_Mage_ReactiveManaShieldHealthPercentage,
			0,
			100,
			"",
			1,
			1,
			TEXT(ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_HEALTH_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_MANA",
			"SLIDER",
			TEXT(ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_MANA),
			TEXT(ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_MANA_INFO),
			OneHitWonder_Mage_SetReactiveManaShieldManaPercentage,
			1,
			OneHitWonder_Mage_ReactiveManaShieldManaPercentage,
			1,
			100,
			"",
			1,
			1,
			TEXT(ONEHITWONDER_MAGE_REACTIVE_MANA_SHIELD_MANA_APPEND)
		);
	end
end


function OneHitWonder_SetupStuffContinuously_Mage()
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_ARCANE_INTELLECT_NAME] = 29*60;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_DAMPEN_MAGIC_NAME] = 4.5*60;
	if ( OneHitWonder_Mage_ShouldBuffNonCastersIntellect == 1 ) then
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_ARCANE_INTELLECT_NAME, false, true, { useWhenHigherManaPercentage=OneHitWonder_Mage_ArcaneIntellectMana });
	else
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_ARCANE_INTELLECT_NAME, false, true, {useWhenHigherManaPercentage=OneHitWonder_Mage_ArcaneIntellectMana, powerType = { ONEHITWONDER_POWERTYPE_MANA } });
		--OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_ARCANE_INTELLECT_NAME, false, true, {onlyBuffClass = {ONEHITWONDER_CLASS_DRUID}, powerType = { ONEHITWONDER_POWERTYPE_MANA } });
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_ARCANE_INTELLECT_NAME, false, true, {useWhenHigherManaPercentage=OneHitWonder_Mage_ArcaneIntellectMana, onlyBuffClass = {ONEHITWONDER_CLASS_DRUID}});
	end
	if ( OneHitWonder_ShouldKeepBuffsUp == 1 ) then
		local armorName = ONEHITWONDER_SPELL_ICE_ARMOR_NAME;
		if ( OneHitWonder_GetSpellId(armorName) <= 0 ) then
			armorName = ONEHITWONDER_SPELL_FROST_ARMOR_NAME;
		end
		OneHitWonder_AddStuffContinuously(armorName, true, true);
	end
	if ( ( OneHitWonder_Mage_ShouldBuffDampenMagicWhenNoHealer == 1 ) and ( OneHitWonder_GetNumberOfClassInParty(OneHitWonder_HealerClassesArray) <= 0 ) ) then
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_DAMPEN_MAGIC_NAME, false, true, {invalidTarget={"target"},useWhenHigherManaPercentage=50, validTarget={"player","party1","party2","party3","party4","pet"}});
	end
end

function OneHitWonder_TryToInterruptSpell_Mage(unitName, spellName)
	local interruptId = -1;
	local abilityName = "";
	if ( ( OneHitWonder_IsSpellFireBased(spellName) ) and ( OneHitWonder_Mage_ShouldReactiveCastFireWard == 1 ) ) then
		abilityName = ONEHITWONDER_SPELL_FIRE_WARD_NAME;
	elseif ( ( OneHitWonder_IsSpellFrostBased(spellName) ) and ( OneHitWonder_Mage_ShouldReactiveCastFrostWard == 1 ) ) then
		abilityName = ONEHITWONDER_SPELL_FROST_WARD_NAME;
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

function OneHitWonder_Mage_AddManaShield()
	local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_MANA_SHIELD_NAME);
	local parameters = { spellId, ( GetTime() + 2 ) };
	OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TIMEOUT, parameters);
end

function OneHitWonder_Mage_CastManaShield()
	local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_MANA_SHIELD_NAME);
	return OneHitWonder_CastSpell(spellId);
end


function OneHitWonder_Mage_ManaShieldCheck()
	if ( OneHitWonder_Mage_ShouldReactiveCastManaShield == 1 ) then
		local playerHPPercent = OneHitWonder_GetPlayerHPPercentage();
		local playerManaPercent = OneHitWonder_GetPlayerManaPercentage();
		--OneHitWonder_Print(format("OK, loaded up values. Current HP : %d   Current Mana : %d", playerHPPercent, playerManaPercent));
		if ( ( ( OneHitWonder_Mage_ReactiveManaShieldHealthPercentage >= 100 ) or ( playerHPPercent <= OneHitWonder_Mage_ReactiveManaShieldHealthPercentage ) )
			and ( ( OneHitWonder_Mage_ReactiveManaShieldManaPercentage <= 1 ) or ( playerManaPercent >= OneHitWonder_Mage_ReactiveManaShieldManaPercentage ) ) ) then
			local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_MANA_SHIELD_NAME);
			--OneHitWonder_Print(format("OK, we were authorized to GO. SpellId = %d", spellId));
			if ( 
			( spellId > -1 ) and 
			( OneHitWonder_IsSpellAvailable(spellId) ) and 
			( not OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_SPELL_MANA_SHIELD_EFFECT ) ) ) then
				--OneHitWonder_Print(format("OK, adding to queue..."));
				local parameters = { spellId, ( GetTime() + 2 ) };
				OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TIMEOUT, parameters);
				return true;
			else
				--[[
				local available = OneHitWonder_IsSpellAvailable(spellId);
				if ( not available ) then available = "false"; else available = "true"; end
				local present = OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_SPELL_MANA_SHIELD_EFFECT );
				if ( not present ) then present = "false"; else present = "true"; end
				OneHitWonder_Print(format("We were not authorized to go. Available = %s    Present = %s", available, present));
				]]--
			end
		end
	end
	return false;
end

function OneHitWonder_UnitHealthCheck_Mage(unit)
	if ( unit == "player" ) and ( OneHitWonder_Mage_ManaShieldCheck() ) then
		OneHitWonder_Mage_AddManaShield();
	end
end


function OneHitWonder_Mage(removeDefense)
	local targetName = UnitName("target");

	if ( not removeDefense ) then removeDefense = false; end
	
	if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
		return;
	end
	
	if ( (not targetName) or ( strlen(targetName) <= 0 ) ) then
		if ( not OneHitWonder_UseCountermeasures() ) then
			if ( not OneHitWonder_DoBuffs() ) then
				if ( OneHitWonder_ShouldOverrideBindings ~= 1 ) then
					return OneHitWonder_DoStuffContinuously();
				end
			end
		end
		return;
	end
	
	if ( not UnitCanAttack("target", "player") ) then
		if ( not OneHitWonder_UseCountermeasures() ) then
			OneHitWonder_DoBuffs();
		end
		return;
	end
	
	OneHitWonder_CheckFriendlies();
	
	if ( OneHitWonder_HandleActionQueue() ) then
		return;
	end

	-- check fire ball range, use that, default to frost bolt if necessary, AM

	if ( not OneHitWonder_DoBuffs() ) then
		local attackSpellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_ATTACK);
		local attackActionId = OneHitWonder_GetActionIdFromSpellId(attackSpellId);
		if ( attackActionId == -1 ) or ( not OneHitWonder_CheckIfInRangeAndUsableInActionBarByActionId(attackActionId) ) then
			local shootSpellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_SHOOT);
			local shootActionId = OneHitWonder_GetActionIdFromSpellId(shootSpellId);
			if ( OneHitWonder_CheckIfInRangeAndUsableInActionBarByActionId(shootActionId) ) then
				if ( OneHitWonder_CastSpell(shootSpellId) ) then	
					return;
				end
			end
		else
			OneHitWonder_MeleeAttack();
		end
	end
end

function OneHitWonder_Mage_IsEffectLesserCurse(effect)
	if ( strfind(effect.name, ONEHITWONDER_DEBUFF_TYPE_CURSE_LESSER ) ) then
		return true;
	end
	for k, v in ONEHITWONDER_LESSER_CURSE_NAMES do
		if ( v == effect.name ) then
			return true;
		end
	end
	return false;
end

function OneHitWonder_Mage_RetrieveCleansingSpellId(unit)
	if ( ( strfind(unit, "party" ) ) or ( unit == "player" ) ) then
		if ( OneHitWonder_ShouldRemoveDebuffs == 1 ) then
			local removeCurseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_REMOVE_LESSER_CURSE_NAME);
			if ( removeCurseId > -1 ) then
				local debuffsByType = OneHitWonder_GetDebuffsByType(unit);
				local hasCurse = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_CURSE] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_CURSE]) > 0 );
				local hasLesserCurse = false;
				if ( hasCurse ) then
					for k, v in debuffsByType[ONEHITWONDER_DEBUFF_TYPE_CURSE] do
						if ( OneHitWonder_Mage_IsEffectLesserCurse(v) ) then
							hasLesserCurse = true;
							break;
						end
					end
				end
				if ( hasLesserCurse ) then
					return removeCurseId;
				end
			end
		end
	end
	return -1;
end

function OneHitWonder_CheckEffect_Mage(unit)
	local doneStuff = false;
	local spellId = OneHitWonder_Mage_RetrieveCleansingSpellId(unit);
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


function OneHitWonder_DoStuffContinuously_Mage()
	if ( not OneHitWonder_IsEnabled() ) then return false; end
	if ( OneHitWonder_Mage_ManaShieldCheck() ) then
		return OneHitWonder_Mage_CastManaShield();
	end
end