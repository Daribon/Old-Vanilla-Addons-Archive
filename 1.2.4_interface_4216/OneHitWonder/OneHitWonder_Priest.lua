
OneHitWonder_Priest_AggressiveWonder = 0;

OneHitWonder_Priest_UseTouchOfWeakness = 1;

OneHitWonder_Priest_AutoBuffShadowProtection = 0;
OneHitWonder_Priest_KeepUpShadowguard = 1;
OneHitWonder_Priest_KeepUpShadowguardManaRequired = 60;

OneHitWonder_Priest_AutoBuffInnerFire = 1;
OneHitWonder_Priest_AutoBuffInnerFireInGroups = 1;

OneHitWonder_Options_Priest = {
	"OneHitWonder_Priest_AggressiveWonder",
	"OneHitWonder_Priest_UseTouchOfWeakness",
	"OneHitWonder_Priest_KeepUpShadowguard",
	"OneHitWonder_Priest_KeepUpShadowguardManaRequired",
	"OneHitWonder_Priest_AutoBuffShadowProtection",
	"OneHitWonder_Priest_AutoBuffInnerFire",
	"OneHitWonder_Priest_AutoBuffInnerFireInGroups",
};

function OneHitWonder_Priest_ShouldAutoBuffInnerFire()
	if ( ( OneHitWonder_Priest_AutoBuffInnerFire == 0 ) or (
		( OneHitWonder_IsInPartyOrRaid() ) and ( OneHitWonder_Priest_AutoBuffInnerFireInGroups == 0 ) )  
		) then
		return false;
	else
		return true;
	end
end

function OneHitWonder_Priest_SetAggressiveWonder(toggle)
	if ( OneHitWonder_Priest_AggressiveWonder ~= toggle ) then
		OneHitWonder_Priest_AggressiveWonder = toggle;
	end
end

function OneHitWonder_Priest_SetUseTouchOfWeakness(toggle)
	if ( OneHitWonder_Priest_UseTouchOfWeakness ~= toggle ) then
		OneHitWonder_Priest_UseTouchOfWeakness = toggle;
	end
end

function OneHitWonder_Priest_SetAutoBuffShadowProtection(toggle)
	if ( OneHitWonder_Priest_AutoBuffShadowProtection ~= toggle ) then
		OneHitWonder_Priest_AutoBuffShadowProtection = toggle;
		OneHitWonder_SetupStuffContinuously();
	end
end

function OneHitWonder_Priest_SetAutoBuffInnerFire(toggle)
	if ( OneHitWonder_Priest_AutoBuffInnerFire ~= toggle ) then
		OneHitWonder_Priest_AutoBuffInnerFire = toggle;
		OneHitWonder_SetupStuffContinuously();
	end
end

function OneHitWonder_Priest_SetAutoBuffInnerFireInGroups(toggle)
	if ( OneHitWonder_Priest_AutoBuffInnerFireInGroups ~= toggle ) then
		OneHitWonder_Priest_AutoBuffInnerFireInGroups = toggle;
		if ( OneHitWonder_IsInPartyOrRaid() ) then
			OneHitWonder_SetupStuffContinuously();
		end
	end
end

function OneHitWonder_Priest_SetKeepUpShadowguard(toggle, value)
	local hasChanged = false;
	if ( OneHitWonder_Priest_KeepUpShadowguard ~= toggle ) then
		OneHitWonder_Priest_KeepUpShadowguard = toggle;
		hasChanged = true;
	end
	if ( value ~= OneHitWonder_Priest_KeepUpShadowguardManaRequired ) then
		OneHitWonder_Priest_KeepUpShadowguardManaRequired = value;
		if ( OneHitWonder_Priest_KeepUpShadowguard == 1 ) then
			hasChanged = true;
		end
	end
	if ( hasChanged ) then
		OneHitWonder_SetupStuffContinuously();
	end
end

function OneHitWonder_SetupStuffContinuously_Priest()
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_POWER_WORD_FORTITUDE_NAME] = 25*60;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_DIVINE_SPIRIT_NAME] = 25*60;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_PRAYER_OF_FORTITUDE_EFFECT] = 25*60;
	--OneHitWonder_BuffTime[ONEHITWONDER_SPELL_INNER_FIRE_NAME] = 5*60;
	OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_POWER_WORD_FORTITUDE_NAME, false, true, {effectName = {ONEHITWONDER_SPELL_POWER_WORD_FORTITUDE_EFFECT, ONEHITWONDER_SPELL_PRAYER_OF_FORTITUDE_EFFECT}, notInCombat = true, useWhenHigherManaPercentage=95});
	if ( OneHitWonder_AutoBuffShadowProtection == 1 ) then
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_SHADOW_PROTECTION_NAME, false, true, {effectName = {ONEHITWONDER_SPELL_SHADOW_PROTECTION_NAME, ONEHITWONDER_SPELL_SHADOW_RESISTANCE_AURA_NAME}, notInCombat = true, useWhenHigherManaPercentage=95});
	end
	OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_DIVINE_SPIRIT_NAME, false, true, {notInCombat = true});

	OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_FEAR_WARD_NAME, false, true, {notInCombat = true});

	if ( OneHitWonder_ShouldKeepBuffsUp == 1 ) then
		if ( OneHitWonder_Priest_KeepUpShadowguard == 1 ) then
			OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_SHADOWGUARD_NAME, true, true, {useWhenHigherManaPercentage = OneHitWonder_Priest_KeepUpShadowguardManaRequired});
		end
	end

	if ( OneHitWonder_Priest_ShouldAutoBuffInnerFire() ) and ( OneHitWonder_ShouldKeepBuffsUp == 1 ) then
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_INNER_FIRE_NAME, true, true, {requiresCombat = true, useWhenHigherManaPercentage = 25});
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_INNER_FIRE_NAME, true, true, {requiresCombat = true, onlyWhileHated = true, useWhenHigherManaPercentage = 50});
		OneHitWonder_AddStuffContinuously(ONEHITWONDER_SPELL_INNER_FIRE_NAME, true, true, {notInCombat = true, useWhenHigherManaPercentage = 95});
	end
end

function OneHitWonder_Priest_Cosmos()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_PRIEST_SEPARATOR),
			TEXT(ONEHITWONDER_PRIEST_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_AGGRESSIVE",
			"CHECKBOX",
			TEXT(ONEHITWONDER_PRIEST_AGGRESSIVE),
			TEXT(ONEHITWONDER_PRIEST_AGGRESSIVE_INFO),
			OneHitWonder_Priest_SetAggressiveWonder,
			OneHitWonder_Priest_AggressiveWonder
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_USE_TOUCH_OF_WEAKNESS",
			"CHECKBOX",
			TEXT(ONEHITWONDER_PRIEST_USE_TOUCH_OF_WEAKNESS),
			TEXT(ONEHITWONDER_PRIEST_USE_TOUCH_OF_WEAKNESS_INFO),
			OneHitWonder_Priest_SetUseTouchOfWeakness,
			OneHitWonder_Priest_UseTouchOfWeakness
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_BUFF_INNER_FIRE",
			"CHECKBOX",
			TEXT(ONEHITWONDER_PRIEST_BUFF_INNER_FIRE),
			TEXT(ONEHITWONDER_PRIEST_BUFF_INNER_FIRE_INFO),
			OneHitWonder_Priest_SetAutoBuffInnerFire,
			OneHitWonder_Priest_AutoBuffInnerFire
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_BUFF_INNER_FIRE_IN_GROUPS",
			"CHECKBOX",
			TEXT(ONEHITWONDER_PRIEST_BUFF_INNER_FIRE_IN_GROUPS),
			TEXT(ONEHITWONDER_PRIEST_BUFF_INNER_FIRE_IN_GROUPS_INFO),
			OneHitWonder_Priest_SetAutoBuffInnerFireInGroups,
			OneHitWonder_Priest_AutoBuffInnerFireInGroups
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_BUFF_SHADOW_PROTECTION",
			"CHECKBOX",
			TEXT(ONEHITWONDER_PRIEST_BUFF_SHADOW_PROTECTION),
			TEXT(ONEHITWONDER_PRIEST_BUFF_SHADOW_PROTECTION_INFO),
			OneHitWonder_Priest_SetAutoBuffShadowProtection,
			OneHitWonder_Priest_AutoBuffShadowProtection
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_SHADOWGUARD",
			"BOTH",
			TEXT(ONEHITWONDER_PRIEST_SHADOWGUARD),
			TEXT(ONEHITWONDER_PRIEST_SHADOWGUARD_INFO),
			OneHitWonder_Priest_SetKeepUpShadowguard,
			OneHitWonder_Priest_KeepUpShadowguard,  -- checked
			OneHitWonder_Priest_KeepUpShadowguardManaRequired, -- default value
			0, -- min value
			100, -- max value
			ONEHITWONDER_PRIEST_SHADOWGUARD_SLIDER, -- slider text
			1, 
			1, 
			ONEHITWONDER_PRIEST_SHADOWGUARD_APPEND, -- slider text append
			1 -- slider multiplier
		);
	end
end

function OneHitWonder_Priest(removeDefense)
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
	
	if ( not UnitCanAttack("player", "target") ) then
		if ( not OneHitWonder_UseCountermeasures() ) then
			if ( not OneHitWonder_DoBuffs() ) then
			end
		end
		return;
	end
	
	if ( OneHitWonder_HandleActionQueue() ) then
		return;
	end

	if ( OneHitWonder_Priest_AggressiveWonder == 1 ) then
		if ( OneHitWonder_Priest_UseTouchOfWeakness == 1 ) then
			local touchOfWeaknessId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_TOUCH_OF_WEAKNESS_NAME);
			if ( touchOfWeaknessId > -1 ) and ( not OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_SPELL_TOUCH_OF_WEAKNESS_NAME ) ) then
				if ( not OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_SPELL_TOUCH_OF_WEAKNESS_NAME ) ) then
					if ( OneHitWonder_CastSpellOnTarget(touchOfWeaknessId) ) then
						return;
					end
				end
			end
		end
		OneHitWonder_MeleeAttack();
		-- TODO: estimate if the damage done is likely using Estimated Time to Death
		if ( OneHitWonder_CastIfTargetNotHasEffect(ONEHITWONDER_SPELL_SHADOW_WORD_PAIN_NAME, ONEHITWONDER_SPELL_SHADOW_WORD_PAIN_NAME) ) then
			return;
		end
	end

	if ( not OneHitWonder_DoBuffs() ) then
		if ( OneHitWonder_Priest_AggressiveWonder == 1 ) then
			local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_SHOOT);
			if ( spellId > -1 ) and ( OneHitWonder_IsSpellAvailable(spellId) ) then
				if ( OneHitWonder_CastSpell(spellId) ) then
					return;
				end
			end
			if ( OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_SPELL_FEEDBACK_EFFECT) ) then
				return;
			else
				spellId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_FEEDBACK_NAME);
				if ( spellId > -1 ) and ( OneHitWonder_IsSpellAvailable(spellId) ) then
					if ( OneHitWonder_CastSpellOnTarget(spellId) ) then
						return;
					end
				end
			end
			spellId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_SMITE_NAME);
			if ( spellId > -1 ) and ( OneHitWonder_IsSpellAvailable(spellId) ) then
				if ( OneHitWonder_CastSpellOnTarget(spellId) ) then
					return;
				end
			end
		end
	end
end

function OneHitWonder_Priest_RetrieveCleansingSpellId(unit)
	if ( unit ~= "target" ) and ( unit ~= "pet" )  then
		if ( OneHitWonder_ShouldRemoveDebuffs == 1 ) then
			local dispelMagicId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_DISPEL_MAGIC_NAME);
			local abolishDiseaseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_ABOLISH_DISEASE_NAME);
			local cureDiseaseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_CURE_DISEASE_NAME);
			if ( dispelMagicId > -1 ) or ( abolishDiseaseId > -1 ) or ( cureDiseaseId > -1 ) then
				local debuffOptions = {
					minimumDuration = {
						[ONEHITWONDER_DEBUFF_TYPE_DISEASE] = 5,
					}
				};
				local debuffsByType = OneHitWonder_GetDebuffsByType(unit, debuffOptions);
				local hasDisease = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE]) > 0 );
				local hasMagic = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC]) > 0 );
				if ( hasMagic ) then
					--OneHitWonder_Print("Found magic debuff.");
					local spellId = dispelMagicId;
					-- use rank 1 of the dispel magic spell if only one magic debuff
					if ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC]) == 1 ) then
						local spellInfo = DynamicData.spell.getSpellInfo(spellId);
						if ( spellInfo.realRank > 1 ) then
							spellId = DynamicData.spell.getMatchingSpellId(ONEHITWONDER_SPELL_DISPEL_MAGIC_NAME, 1);
						end
					end
					if ( ( spellId ) and ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
						local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
						if ( ( not actionId ) or ( actionId <= -1 ) ) and ( dispelMagicId > -1 ) and ( dispelMagicId ~= spellId ) then
							spellId = dispelMagicId;
							actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
						end
						return spellId;
					end
				end
				if ( hasDisease ) then
					--OneHitWonder_Print("Disease found.");
					if ( not OneHitWonder_HasUnitEffect(unit, nil, ONEHITWONDER_SPELL_ABOLISH_DISEASE_EFFECT ) ) then
						local spellId = -1;
						--if ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE]) > 1 ) then
						if ( abolishDiseaseId > -1 ) then
							spellId = abolishDiseaseId;
						end
						if ( spellId <= -1 ) then
							spellId = cureDiseaseId;
						end
						if ( ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
							local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
							if ( ( not actionId ) or ( actionId <= -1 ) ) and ( abolishDiseaseId ) and ( abolishDiseaseId > -1 ) and ( abolishDiseaseId ~= spellId ) then
								spellId = abolishDiseaseId;
								actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
							end
							return spellId;
						end
					else
						--OneHitWonder_Print("Abolish Disease already underway.");
					end
				end
			end
		end
	end
	return -1;
end

function OneHitWonder_CheckEffect_Priest(unit)
	local doneStuff = false;
	local spellId = -1;
	if ( PlayerFrame.inCombat == 1 ) then
		spellId = OneHitWonder_Priest_RetrieveCleansingSpellId(unit);
	end
	if ( spellId ) and ( spellId > -1 ) then
		local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
		if ( unit == "player" ) and ( actionId ) and ( actionId > -1 ) then
			local parameters = { actionId, spellId };
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_ACTION_SELF, parameters);
			doneStuff = true;
		elseif ( not OneHitWonder_HasTarget() ) or ( UnitName("target") == UnitName(unit) ) then
			local parameters = { spellId, unit };
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
			doneStuff = true;
		end
	end
	return doneStuff;
end

function OneHitWonder_CheckEffect_Priest_Old(unit)
	local doneStuff = false;
	local spellId = -1;
	if ( unit ~= "target" ) and ( unit ~= "pet" )  then
		if ( OneHitWonder_ShouldRemoveDebuffs == 1 ) then
			local dispelMagicId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_DISPEL_MAGIC_NAME);
			local abolishDiseaseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_ABOLISH_DISEASE_NAME);
			local cureDiseaseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_CURE_DISEASE_NAME);
			if ( dispelMagicId > -1 ) or ( abolishDiseaseId > -1 ) or ( cureDiseaseId > -1 ) then
				local debuffOptions = {
					minimumDuration = {
						[ONEHITWONDER_DEBUFF_TYPE_DISEASE] = 5,
					}
				};
				local debuffsByType = OneHitWonder_GetDebuffsByType(unit, debuffOptions);
				local hasDisease = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE]) > 0 );
				local hasMagic = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC]) > 0 );
				if ( hasDisease ) then
					--OneHitWonder_Print("Disease found.");
					if ( not OneHitWonder_HasUnitEffect(unit, nil, ONEHITWONDER_SPELL_ABOLISH_DISEASE_EFFECT ) ) then
						local spellId = -1;
						--if ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE]) > 1 ) then
						if ( abolishDiseaseId > -1 ) then
							spellId = abolishDiseaseId;
						end
						if ( spellId <= -1 ) then
							spellId = cureDiseaseId;
						end
						if ( ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
							local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
							if ( ( not actionId ) or ( actionId <= -1 ) ) and ( abolishDiseaseId ) and ( abolishDiseaseId > -1 ) and ( abolishDiseaseId ~= spellId ) then
								spellId = abolishDiseaseId;
								actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
							end
							if ( unit == "player" ) and ( actionId ) and ( actionId > -1 ) then
								local parameters = { actionId, spellId };
								OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_ACTION_SELF, parameters);
								--OneHitWonder_Print("Queueing Disease Removal - Action!");
								doneStuff = true;
							else
								local parameters = { spellId, unit };
								OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
								doneStuff = true;
								--OneHitWonder_Print("Queueing Disease Removal.");
							end
						end
					else
						--OneHitWonder_Print("Abolish Disease already underway.");
					end
				end
				if ( hasMagic ) then
					--OneHitWonder_Print("Found magic debuff.");
					local spellId = dispelMagicId;
					-- use rank 1 of the dispel magic spell if only one magic debuff
					if ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_MAGIC]) == 1 ) then
						local spellInfo = DynamicData.spell.getSpellInfo(spellId);
						if ( spellInfo.realRank > 1 ) then
							spellId = DynamicData.spell.getMatchingSpellId(ONEHITWONDER_SPELL_DISPEL_MAGIC_NAME, 1);
						end
					end
					if ( ( spellId ) and ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
						local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
						if ( ( not actionId ) or ( actionId <= -1 ) ) and ( dispelMagicId > -1 ) and ( dispelMagicId ~= spellId ) then
							spellId = dispelMagicId;
							actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
						end
						if ( unit == "player" ) and ( actionId ) and ( actionId > -1 ) then
							local parameters = { actionId, spellId };
							OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_ACTION_SELF, parameters);
							--OneHitWonder_Print("Queueing Magic Debuff Removal - Action!");
							doneStuff = true;
						elseif ( not OneHitWonder_HasTarget() ) or ( UnitName("target") == UnitName(unit) ) then
							local parameters = { spellId, unit };
							OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
							--OneHitWonder_Print("Queueing Magic Debuff Removal.");
							doneStuff = true;
						else
							--OneHitWonder_Print("Queueing Magic Debuff - nope, action.");
						end
					end
				end
			end
		end
	end
	return doneStuff;
end

function OneHitWonder_UnitHasGainedSpell_Priest(unitName, spellName)
	if ( not spellName ) then
		return;
	end
	local spellId = -1;
	spellId = DynamicData.spell.getMatchingSpellId(ONEHITWONDER_SPELL_DISPEL_MAGIC_NAME, 1);
	if ( not spellId ) or ( spellId <= -1 ) then
		return;
	end
	if ( PlayerFrame.inCombat ~= 1 ) then
		return;
	end
	
	if ( OneHitWonder_IsStringInListLoose(spellName, OneHitWonder_DispelSpells, true) ) then
		local parameters = { spellId, "target" };
		OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
		return;
	end
end


function OneHitWonder_ShouldTryToCastABuff_Priest(ignoreCloakEffects)
	if ( OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_SPELL_INNER_FOCUS_EFFECT) ) then
		return false;
	else
		return true;
	end
end