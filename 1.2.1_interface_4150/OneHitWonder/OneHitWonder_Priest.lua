
OneHitWonder_Priest_AutoBuffShadowProtection = 0;

OneHitWonder_Priest_AutoBuffInnerFire = 1;
OneHitWonder_Priest_AutoBuffInnerFireInGroups = 1;

function OneHitWonder_Priest_ShouldAutoBuffInnerFire()
	if ( ( OneHitWonder_Priest_AutoBuffInnerFire == 0 ) or (
		( OneHitWonder_IsInPartyOrRaid() ) and ( OneHitWonder_Priest_AutoBuffInnerFireInGroups == 0 ) )  
		) then
		return false;
	else
		return true;
	end
end

function OneHitWonder_Priest_SetAutoBuffShadowProtection(toggle)
	if ( OneHitWonder_Priest_AutoBuffShadowProtection ~= toggle ) then
		OneHitWonder_Priest_AutoBuffShadowProtection = toggle;
		OneHitWonder_SetupStuffContinously();
	end
end

function OneHitWonder_Priest_SetAutoBuffInnerFire(toggle)
	if ( OneHitWonder_Priest_AutoBuffInnerFire ~= toggle ) then
		OneHitWonder_Priest_AutoBuffInnerFire = toggle;
		OneHitWonder_SetupStuffContinously();
	end
end

function OneHitWonder_Priest_SetAutoBuffInnerFireInGroups(toggle)
	if ( OneHitWonder_Priest_AutoBuffInnerFireInGroups ~= toggle ) then
		OneHitWonder_Priest_AutoBuffInnerFireInGroups = toggle;
		if ( OneHitWonder_IsInPartyOrRaid() ) then
			OneHitWonder_SetupStuffContinously();
		end
	end
end

function OneHitWonder_SetupStuffContinously_Priest()
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_POWER_WORD_FORTITUDE_NAME] = 25*60;
	OneHitWonder_BuffTime[ONEHITWONDER_SPELL_DIVINE_SPIRIT_NAME] = 25*60;
	--OneHitWonder_BuffTime[ONEHITWONDER_SPELL_INNER_FIRE_NAME] = 5*60;
	OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_POWER_WORD_FORTITUDE_NAME, false, true, {notInCombat = true, useWhenHigherManaPercentage=95});
	if ( OneHitWonder_AutoBuffShadowProtection == 1 ) then
		OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_SHADOW_PROTECTION_NAME, false, true, {effectName = {ONEHITWONDER_SPELL_SHADOW_PROTECTION_NAME, ONEHITWONDER_SPELL_SHADOW_RESISTANCE_AURA_NAME}, notInCombat = true, useWhenHigherManaPercentage=95});
	end
	OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_DIVINE_SPIRIT_NAME, false, true, {notInCombat = true});
	if ( OneHitWonder_Priest_ShouldAutoBuffInnerFire() ) then
		OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_INNER_FIRE_NAME, true, true, {requiresCombat = true, useWhenHigherManaPercentage = 25});
		OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_INNER_FIRE_NAME, true, true, {requiresCombat = true, onlyWhileHated = true, useWhenHigherManaPercentage = 50});
		OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_INNER_FIRE_NAME, true, true, {notInCombat = true, useWhenHigherManaPercentage = 95});
	end
end

function OneHitWonder_Priest_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_PRIEST_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_PRIEST_SEPARATOR),
			TEXT(ONEHITWONDER_PRIEST_SEPARATOR_INFO)
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

	if ( PlayerFrame.inCombat ~= 1 ) then
		--AttackTarget();
	end

	if ( not OneHitWonder_DoBuffs() ) then
		--[[
		if ( OneHitWonder_CastIfTargetNotHasEffect(ONEHITWONDER_ABILITY_SHOOT, ONEHITWONDER_ABILITY_SHOOT) ) then
			return;
		end
		]]--
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
					if ( ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
						local actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
						if ( ( not actionId ) or ( actionId <= -1 ) ) and ( dispelMagicId > -1 ) and ( dispelMagicId ~= spellId ) then
							spellId = dispelMagicId;
							actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
						end
						return spellId;
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
					if ( ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
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
	if ( spellId <= -1 ) then
		return;
	end
	if ( PlayerFrame.inCombat ~= 1 ) then
		return;
	end
	
	for k, v in OneHitWonder_DispelSpells do
		if ( v == spellName ) then
			--OneHitWonder_Print(format("Found exact matching spell [%s], initiating dispel.", v));
			local parameters = { spellId, "target" };
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
			return;
		end
	end
	for k, v in OneHitWonder_DispelSpells do
		if ( strfind(spellName, v) ) then
			--OneHitWonder_Print(format("Found good matching spell [%s], initiating dispel.", spellName));
			local parameters = { spellId, "target" };
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
			return;
		end
	end
end
