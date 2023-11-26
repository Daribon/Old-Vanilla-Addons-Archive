OneHitWonder_Shaman_KeepUpWeaponBuff = 0;
OneHitWonder_Shaman_WeaponScannedAtTime = nil;


OneHitWonder_Shaman_UseEarthShock = 1;
OneHitWonder_Shaman_UseCheapEarthShock = 1;

OneHitWonder_Shaman_UseGroundingTotemEarthShockBackup = 1;

function OneHitWonder_SetupStuffContinously_Shaman()
	--OneHitWonder_BuffTime[ONEHITWONDER_SPELL_LIGHTNING_SHIELD_NAME] = 9*60;
	OneHitWonder_AddStuffContinously(ONEHITWONDER_SPELL_LIGHTNING_SHIELD_NAME, true, true);
end

OneHitWonder_Shaman_WeaponSpellName = {
	ONEHITWONDER_SPELL_WINDFURY_WEAPON_NAME,
	ONEHITWONDER_SPELL_ROCKBITER_WEAPON_NAME,
	ONEHITWONDER_SPELL_FLAMETONGUE_WEAPON_NAME,
	ONEHITWONDER_SPELL_FROSTBRAND_WEAPON_NAME
};

OneHitWonder_Shaman_WeaponEffectName = {
	ONEHITWONDER_SPELL_WINDFURY_WEAPON_EFFECT,
	ONEHITWONDER_SPELL_ROCKBITER_WEAPON_EFFECT,
	ONEHITWONDER_SPELL_FLAMETONGUE_WEAPON_EFFECT,
	ONEHITWONDER_SPELL_FROSTBRAND_WEAPON_EFFECT
};

function OneHitWonder_Shaman_SetKeepUpWeaponBuff(checked, value)
	if ( OneHitWonder_Shaman_KeepUpWeaponBuff ~= value ) then
		OneHitWonder_Shaman_KeepUpWeaponBuff = value;
		OneHitWonder_Shaman_DoKeepUpWeaponBuff();
	end
end

function OneHitWonder_Shaman_DoKeepUpWeaponBuff()
	if ( OneHitWonder_Shaman_KeepUpWeaponBuff <= 0 ) then
		return false;
	end
	return OneHitWonder_Shaman_KeepUpWeaponSpell(OneHitWonder_Shaman_WeaponSpellName[OneHitWonder_Shaman_KeepUpWeaponBuff], OneHitWonder_Shaman_WeaponEffectName[OneHitWonder_Shaman_KeepUpWeaponBuff], 16);
end

function OneHitWonder_CheckEffects_Shaman(unit)
	local doneStuff = false;
	if ( unit == "player" ) then
		if ( OneHitWonder_Shaman_DoKeepUpWeaponBuff() ) then
			doneStuff = true;
		end
	end
	if ( unit ~= "target" ) then
		if ( OneHitWonder_ShouldRemoveDebuffs == 1 ) then
			local curePoisonId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_CURE_POISON_NAME);
			local cureDiseaseId = OneHitWonder_GetSpellId(ONEHITWONDER_SPELL_CURE_DISEASE_NAME);
			if ( curePoisonId > -1 ) or ( cureDiseaseId > -1 ) then
				local debuffsByType = OneHitWonder_GetDebuffsByType(unit);
				local hasDisease = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_DISEASE]) > 0 );
				local hasPoison = ( debuffsByType[ONEHITWONDER_DEBUFF_TYPE_POISON] ) and ( table.getn(debuffsByType[ONEHITWONDER_DEBUFF_TYPE_POISON]) > 0 );
				if ( hasDisease ) then
					local spellId = cureDiseaseId;
					if ( ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
						local parameters = { spellId, unit, UnitName(unit) };
						OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
						doneStuff = true;
					end
				end
				if ( hasPoison ) then
					local spellId = curePoisonId;
					if ( ( spellId > -1 ) and ( OneHitWonder_IsUnitInRange(unit) ) ) then
						local parameters = { spellId, unit, UnitName(unit) };
						OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TARGET, parameters);
						doneStuff = true;
					end
				end
			end
		end
	end
	return doneStuff;
end

function OneHitWonder_Shaman_KeepUpWeaponSpell(spellName, effectName, slotId)
	local spellId = OneHitWonder_GetSpellId(spellName);
	if( spellId <= -1 ) then
		return false;
	end
	local curTime = GetTime();
	if ( ( not OneHitWonder_Shaman_WeaponScannedAtTime ) or ( OneHitWonder_Shaman_WeaponScannedAtTime + 310 > curTime ) ) then
		DynamicData.item.scanItem(-1, slotId);
		OneHitWonder_Shaman_WeaponScannedAtTime = curTime;
	end
	local itemInfo = DynamicData.item.getEquippedSlotInfo(slotId);
	if ( ( itemInfo ) and ( strlen(itemInfo.name) > 0 ) ) then
		if ( itemInfo.itemType == "Shield" ) then
			return false;
		end
		local hasEffect = false;
		if ( itemInfo.strings ) then
			for k, v in itemInfo.strings do
				if ( v.left ) and ( strfind(v.left, effectName) ) then
					hasEffect = true;
					break;
				end
			end
		end
		if ( not hasEffect ) then
			OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL, spellId);
			return true;
		end

	end
	return false;
end


function OneHitWonder_TryToInterruptSpell_Shaman(unitName, spellName)
	local interruptId = -1;
	local abilityName = "";
	abilityName = ONEHITWONDER_SPELL_EARTHSHOCK_NAME;
	if ( OneHitWonder_Shaman_UseEarthShock ~= 1 ) then
		abilityName = "";
	end
	if ( ( abilityName ) and 
		(strlen(abilityName) > 0) ) then
		local rankName = nil;
		if ( ( abilityName == ONEHITWONDER_SPELL_EARTHSHOCK_NAME ) and ( OneHitWonder_Shaman_UseCheapEarthShock == 1 ) ) then
			rankName = 1;
		end
		interruptId = DynamicData.spell.getMatchingSpellId(abilityName, rankName);--OneHitWonder_GetSpellId(abilityName, rankName);
		if ( interruptId <= -1) or ( not OneHitWonder_IsSpellAvailable(interruptId) ) then
			if ( OneHitWonder_Shaman_UseGroundingTotemEarthShockBackup == 1 ) then
				local name = ONEHITWONDER_SPELL_GROUNDING_TOTEM_NAME;
				interruptId = OneHitWonder_GetSpellId(name);
				if ( interruptId > -1 ) then
					if ( not OneHitWonder_IsSpellAvailable(interruptId ) ) then
						interruptId = -1;
					else
						abilityName = name;
					end
				end
			end
		end
		if ( interruptId <= -1 ) then
			abilityName = "";
			interruptId = -1;
		end
	end
	return interruptId, abilityName;
end

function OneHitWonder_Shaman_SetUseEarthShock(toggle)
	OneHitWonder_Shaman_UseEarthShock = toggle;
end

function OneHitWonder_Shaman_SetUseCheapEarthShock(toggle)
	OneHitWonder_Shaman_UseCheapEarthShock = toggle;
end

function OneHitWonder_Shaman_SetUseGroundingTotemEarthShockBackup(toggle)
	OneHitWonder_Shaman_UseGroundingTotemEarthShockBackup = toggle;
end

function OneHitWonder_Shaman_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_SHAMAN_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_SHAMAN_SEPARATOR),
			TEXT(ONEHITWONDER_SHAMAN_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_SHAMAN_USE_EARTH_SHOCK",
			"CHECKBOX",
			TEXT(ONEHITWONDER_SHAMAN_USE_EARTH_SHOCK),
			TEXT(ONEHITWONDER_SHAMAN_USE_EARTH_SHOCK_INFO),
			OneHitWonder_Shaman_SetUseEarthShock,
			OneHitWonder_Shaman_UseEarthShock
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_SHAMAN_USE_CHEAP_EARTH_SHOCK",
			"CHECKBOX",
			TEXT(ONEHITWONDER_SHAMAN_USE_CHEAP_EARTH_SHOCK),
			TEXT(ONEHITWONDER_SHAMAN_USE_CHEAP_EARTH_SHOCK_INFO),
			OneHitWonder_Shaman_SetUseCheapEarthShock,
			OneHitWonder_Shaman_UseCheapEarthShock
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_SHAMAN_USE_GROUNDING_TOTEM_ES_BACKUP",
			"CHECKBOX",
			TEXT(ONEHITWONDER_SHAMAN_USE_GROUNDING_TOTEM_ES_BACKUP),
			TEXT(ONEHITWONDER_SHAMAN_USE_GROUNDING_TOTEM_ES_BACKUP_INFO),
			OneHitWonder_Shaman_SetUseGroundingTotemEarthShockBackup,
			OneHitWonder_Shaman_UseGroundingTotemEarthShockBackup
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_SHAMAN_KEEP_UP_WEAPON_BUFF",
			"SLIDER",
			TEXT(ONEHITWONDER_SHAMAN_KEEP_UP_WEAPON_BUFF),
			TEXT(ONEHITWONDER_SHAMAN_KEEP_UP_WEAPON_BUFF_INFO),
			OneHitWonder_Shaman_SetKeepUpWeaponBuff,
			1,  -- checked
			OneHitWonder_Shaman_KeepUpWeaponBuff, -- default value
			0, -- min value
			4, -- max value
			ONEHITWONDER_SHAMAN_KEEP_UP_WEAPON_BUFF_SLIDER, -- slider text
			1, 
			0, 
			"", -- slider text append
			1 -- slider multiplier
		);
	end
end

function OneHitWonder_Shaman(removeDefense)
	local targetName = UnitName("target");

	if ( not removeDefense ) then removeDefense = false; end
	
	if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
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

	if ( PlayerFrame.inCombat ~= 1 ) then
		AttackTarget();
	end

	if ( not OneHitWonder_DoBuffs() ) then
		if ( OneHitWonder_CastIfTargetNotHasEffect(ONEHITWONDER_ABILITY_SHOOT, ONEHITWONDER_ABILITY_SHOOT) ) then
			return;
		end
	end
end


function OneHitWonder_UnitHasGainedSpell_Shaman(unitName, spellName)
	if ( not spellName ) then
		return;
	end
	local spellId = -1;
	spellId = DynamicData.spell.getMatchingSpellId(ONEHITWONDER_SPELL_PURGE_NAME, 1);
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
