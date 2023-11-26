OneHitWonder_Rogue_WeaponSwitching = 0;

ONEHITWONDER_ABILITY_EXPOSEARMOR_TEXTURE = "Interface\\Icons\\Ability_Warrior_Riposte";
ONEHITWONDER_ABILITY_SLICEDICE_TEXTURE = "Interface\\Icons\\Ability_Rogue_SliceDice";
ONEHITWONDER_ABILITY_STEALTH_TEXTURE = "Interface\\Icons\\Ability_Stealth";

ONEHITWONDER_ABILITY_STEALTH_EFFECTS = {
	ONEHITWONDER_ABILITY_STEALTH_EFFECT,
	ONEHITWONDER_ABILITY_VANISH_EFFECT
};


ONEHITWONDER_ABILITY_STEALTH_OPENERS = {
	ONEHITWONDER_ABILITY_GARROTTE_NAME, 
	ONEHITWONDER_ABILITY_AMBUSH_NAME,
	ONEHITWONDER_ABILITY_BACKSTAB_NAME,
	ONEHITWONDER_ABILITY_CHEAPSHOT_NAME
};

ONEHITWONDER_ABILITY_FINISHING_MOVES = {
	ONEHITWONDER_ABILITY_EXPOSEARMOR_NAME,
	ONEHITWONDER_ABILITY_EVISCERATE_NAME, 
	ONEHITWONDER_ABILITY_SLICEDICE_NAME, 
	ONEHITWONDER_ABILITY_RUPTURE_NAME,
	ONEHITWONDER_ABILITY_KIDNEYSHOT_NAME
};

ONEHITWONDER_ABILITY_ENERGYCOST = {
	[ONEHITWONDER_ABILITY_AMBUSH_NAME] = 60,
	[ONEHITWONDER_ABILITY_BACKSTAB_NAME] = 60,
	[ONEHITWONDER_ABILITY_EVISCERATE_NAME] = 35,
	[ONEHITWONDER_ABILITY_SLICEDICE_NAME] = 25,
	[ONEHITWONDER_ABILITY_SINISTERSTRIKE_NAME] = 45,
	[ONEHITWONDER_ABILITY_EXPOSEARMOR_NAME] = 25,
	[ONEHITWONDER_ABILITY_GOUGE_NAME] = 45,
	[ONEHITWONDER_ABILITY_KICK_NAME] = 25,
	[ONEHITWONDER_ABILITY_FEINT_NAME] = 20,
	[ONEHITWONDER_ABILITY_RUPTURE_NAME] = 25,
	[ONEHITWONDER_ABILITY_DISTRACT_NAME] = 30,
	[ONEHITWONDER_ABILITY_GARROTTE_NAME] = 50,
	[ONEHITWONDER_ABILITY_CHEAPSHOT_NAME] = 60,
	[ONEHITWONDER_ABILITY_KIDNEYSHOT_NAME] = 25,
	[ONEHITWONDER_TALENT_RIPOSTE_NAME] = 10,
	[ONEHITWONDER_ABILITY_PICKPOCKET_NAME] = 0
};

ONEHITWONDER_QUEUE_KICK_CHAT_TYPES_OLD = {
	"SPELL_HOSTILEPLAYER_DAMAGE",
	"SPELL_HOSTILEPLAYER_BUFF",
	"SPELL_CREATURE_VS_SELF_DAMAGE",
	"SPELL_CREATURE_VS_SELF_BUFF",
	"SPELL_CREATURE_VS_CREATURE_BUFF",
};

-- verify this
ONEHITWONDER_QUEUE_RIPOSTE_CHAT_TYPES = {
	"COMBAT_MISC_INFO"
};

function OneHitWonder_GetEnergyConsumption(abilityName)
	return ONEHITWONDER_ABILITY_ENERGYCOST[abilityName];
end


ONEHITWONDER_ROGUE_TALENT_ENERGY_REDUCERS = {
	{ 
		{ 2,2 },
		ONEHITWONDER_ABILITY_SINISTERSTRIKE_NAME,
		{ 42, 40 }
	},
};

-- Thanks to Verona, author of CustomTooltip, for introducing (inadvertently) me to UnitCreatureType.
function OneHitWonder_GetUnitType(unit)
	--[[
	if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
		DynamicData.util.protectTooltipMoney();
	end 
	OneHitWonderTooltip:SetUnit(unit);
	if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.unprotectTooltipMoney ) then
		DynamicData.util.unprotectTooltipMoney();
	end 
	local text = OneHitWonderTooltipTextLeft2:GetText();
	return text;
	]]--
	return UnitCreatureType(unit);
end

function OneHitWonder_UnitIsPickpocketable(unit)
	if ( UnitIsPlayer(unit) ) then
		return false;
	end
	if ( not UnitCanAttack(unit, "player") ) then
		return false;
	end
	local creatureType = OneHitWonder_GetUnitType(unit);
	if ( ( creatureType ) and ( strlen(creatureType) > 0 ) ) then
		for k, v in OneHitWonder_PickpocketableTypes do
			if ( creatureType == v) then
				return true;
			end
		end
		return false;
	else
		return true;
	end
end

function OneHitWonder_TargetIsPickpocketable()
	return OneHitWonder_UnitIsPickpocketable("target");
end


OneHitWonder_Rogue_ShouldPickPocket = 1;
OneHitWonder_Rogue_ShouldRiposte = 1;

OneHitWonder_Rogue_ShouldCheapShot = 1;
OneHitWonder_Rogue_ShouldAmbush = 1;
OneHitWonder_Rogue_ShouldBackstab = 1;

OneHitWonder_Rogue_AllowedBackstabAttempts = 3;

OneHitWonder_Rogue_ExposeArmorPercentage = 20;
OneHitWonder_Rogue_ExposeArmorComboPointsMin = 1;
OneHitWonder_Rogue_ExposeArmorComboPointsMax = 2;

OneHitWonder_Rogue_SliceDicePercentageDirection = 1;
OneHitWonder_Rogue_SliceDicePercentage = 60;
OneHitWonder_Rogue_SliceDiceComboPointsMin = 1;
OneHitWonder_Rogue_SliceDiceComboPointsMax = 2;

OneHitWonder_Rogue_UseNewEviscerateCode = 0;

OneHitWonder_Rogue_EviscerateNowPercentage = 10;
OneHitWonder_Rogue_EviscerateExtraComboPointPercentage = 60;
OneHitWonder_Rogue_EviscerateTwiceExtraComboPointPercentage = 80;
OneHitWonder_Rogue_EviscerateBaseComboPoints = 2;

OneHitWonder_Rogue_UseSmartExposeArmor = 0;

OneHitWonder_Rogue_UseSmartSliceDice = 1;

OneHitWonder_Rogue_ReactiveCastKick = 1;

OneHitWonder_Rogue_PlayerClassesToExpose = {
	ONEHITWONDER_CLASS_DRUID,
	ONEHITWONDER_CLASS_HUNTER,
	ONEHITWONDER_CLASS_PALADIN,
	ONEHITWONDER_CLASS_SHAMAN
};

function OneHitWonder_Rogue_ShouldExposeArmor(removeDefense)
	if ( not removeDefense ) then
		if ( OneHitWonder_Rogue_UseSmartExposeArmor == 1 ) then
			if ( UnitPowerType("target") == 0 ) then
				if ( UnitIsPlayer("target") ) then
					local class = UnitClass("target");
					for k, v in OneHitWonder_Rogue_PlayerClassesToExpose do
						if ( v == class ) then
							return true;
						end
					end
				end
				return false;
			else
				return true;
			end
		else
			return false;
		end
	else
		return true;
	end
end

function OneHitWonder_Rogue_ShouldSliceDice()
	if ( OneHitWonder_Rogue_UseSmartSliceDice == 1 ) then
		return true;
	else
		return false;
	end
end

function OneHitWonder_Rogue_ShouldGiveupBackstab()
	if ( ( OneHitWonder_Rogue_AllowedBackstabAttempts == 0 ) or 
		( OneHitWonder_Rogue_AllowedBackstabAttempts >= TargetFrame.attemptsToBackstab ) ) then
		return false;
	else
		return true;
	end
end

function OneHitWonder_Rogue_GetStealthOpeningAbilityId()
	local spellId = -1;
	if ( ( spellId <= -1 ) and ( OneHitWonder_Rogue_ShouldCheapShot == 1 ) ) then
		spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_CHEAPSHOT_NAME);
	end
	if ( ( spellId <= -1 ) and ( OneHitWonder_Rogue_ShouldAmbush == 1 ) ) then
		if ( OneHitWonder_Rogue_WeaponSwitching == 1 ) then
			OneHitWonder_Rogue_EquipDagger();
		end
		spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_AMBUSH_NAME);
	end
	if ( ( spellId <= -1 ) and ( OneHitWonder_Rogue_ShouldBackstab == 1 ) ) then
		if ( OneHitWonder_Rogue_WeaponSwitching == 1 ) then
			OneHitWonder_Rogue_EquipDagger();
		end
		spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_BACKSTAB_NAME);
	end
	return spellId;
end

function OneHitWonder_Rogue(removeDefense)
	local targetName = UnitName("target");

	if ( not removeDefense ) then removeDefense = false; end
	
	if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
		return;
	end
	
	if ( OneHitWonder_HandleActionQueue() ) then
		return;
	end
	
	if ( ( (not targetName) or ( strlen(targetName) <= 0 ) ) or ( not UnitCanAttack("player", "target") ) ) then
		OneHitWonder_DoBuffs();
		return;
	end
	
	if ( ( OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_ABILITY_STEALTH_EFFECT) ) or ( OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_ABILITY_VANISH_EFFECT) ) ) then
		local spellId = 0;
		local pickPockId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_PICKPOCKET_NAME);

		actionId = 0;

		if ( ( not TargetFrame.hasBeenPickPocketed ) and ( pickPockId > -1 ) and (OneHitWonder_TargetIsPickpocketable() ) and ( OneHitWonder_Rogue_ShouldPickPocket == 1 ) ) then
			spellId = pickPockId;
			actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
			if ( OneHitWonder_CheckIfInRangeAndUsableInActionBarByActionId(actionId) ) then
				if ( OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL ) ) then
					-- should be replaced for check for "No pockets to pick" and "You loot XYZ Copper" at a latter stage
					TargetFrame.hasBeenPickPocketed = true;
				end
			end
			return;
		else
			spellId = OneHitWonder_Rogue_GetStealthOpeningAbilityId();
			actionId = OneHitWonder_GetActionIdFromSpellId(spellId);
			if ( actionId ) and ( actionId > -1 ) then
				if ( OneHitWonder_CheckIfInRangeActionId(actionId) ) then
					TargetFrame.attemptsToBackstab = TargetFrame.attemptsToBackstab + 1;
				end
			else
				TargetFrame.attemptsToBackstab = TargetFrame.attemptsToBackstab + 1;
			end
		end
		if ( OneHitWonder_Rogue_ShouldGiveupBackstab() ) then
			OneHitWonder_Rogue_IncreaseComboPoints();
			return;
		end
		if ( spellId > 0 ) then
			if ( not OneHitWonder_CheckIfUsableActionId(actionId) ) then
				if ( not OneHitWonder_CheckIfSpellIsCoolingdownById(spellId) ) then
					-- we don't have a Dagger in our hand
					OneHitWonder_Rogue_IncreaseComboPoints();
					return;
				end
			end
		else
			OneHitWonder_Rogue_IncreaseComboPoints();
			return;
		end
		OneHitWonder_CastSpell(spellId, ONEHITWONDER_BOOK_TYPE_SPELL);
		return;
	else
		TargetFrame.attemptsToBackstab = 0;
		OneHitWonder_MeleeAttack();
	end

	local comboPoints = GetComboPoints();
	
	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();

	local comboPointsNeeded = OneHitWonder_GetComboPointsNeededToEviscerate();

	if ( ( unitHPPercent >= OneHitWonder_Rogue_ExposeArmorPercentage ) and ( OneHitWonder_Rogue_ShouldExposeArmor(removeDefense) ) and ( not OneHitWonder_HasUnitEffect("target", nil, ONEHITWONDER_ABILITY_EXPOSEARMOR_EFFECT) ) ) then
		local tmp = ONEHITWONDER_ABILITY_EXPOSEARMOR_NAME;
		local tmpId = OneHitWonder_GetSpellId(tmp);

		if ( tmpId > -1 ) then
			--comboPointsNeeded = OneHitWonder_GetComboPointsNeededToExposeArmor();
			--if ( comboPoints >= comboPointsNeeded ) then
			if ( ( comboPoints >= OneHitWonder_Rogue_ExposeArmorComboPointsMin ) and ( comboPoints <= OneHitWonder_Rogue_ExposeArmorComboPointsMax ) ) then
				if ( OneHitWonder_CastSpell(tmpId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
				end
				return;
			end
			OneHitWonder_Rogue_IncreaseComboPoints();
			return;
		end
	end
	
	if ( OneHitWonder_Rogue_ShouldSliceDice() ) then
		if ( ( ( OneHitWonder_Rogue_SliceDicePercentageDirection == 1 ) and 
				( unitHPPercent >= OneHitWonder_Rogue_SliceDicePercentage ) ) or
				( 
				( OneHitWonder_Rogue_SliceDicePercentageDirection == 0 ) and 
				( unitHPPercent <= OneHitWonder_Rogue_SliceDicePercentage ) ) ) then
			if ( ( comboPoints >= OneHitWonder_Rogue_SliceDiceComboPointsMin ) and ( comboPoints <= OneHitWonder_Rogue_SliceDiceComboPointsMax ) ) then
				if ( not OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_ABILITY_SLICEDICE_EFFECT) ) then
					if ( OneHitWonder_CastSpell(OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_SLICEDICE_NAME), ONEHITWONDER_BOOK_TYPE_SPELL) ) then
						return;
					end
				end
			end
		end
	end	
	
	local abilityName = ONEHITWONDER_ABILITY_EVISCERATE_NAME;

	local abilityId = OneHitWonder_GetSpellId(abilityName);
	
	if ( comboPoints >= comboPointsNeeded ) then
		if ( OneHitWonder_CastSpell(abilityId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
			return;
		end
	end
	OneHitWonder_Rogue_IncreaseComboPoints();
end

function OneHitWonder_Rogue_IncreaseComboPoints()
	local sinisterStrikeId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_SINISTERSTRIKE_NAME);
	if ( OneHitWonder_IsSpellAvailable(sinisterStrikeId, ONEHITWONDER_BOOK_TYPE_SPELL) ) then
		if ( OneHitWonder_Rogue_WeaponSwitching == 1 ) then
			OneHitWonder_Rogue_EquipNonDagger();
		end
		return OneHitWonder_CastSpell(sinisterStrikeId, ONEHITWONDER_BOOK_TYPE_SPELL);
	else
		return false;
	end
end

function OneHitWonder_GetComboPointsNeededToExposeArmor()
	local combo = OneHitWonder_GetComboPointsNeededToEviscerate();
	if ( combo < 5 ) then
		combo = combo + 1;
	end
	return combo;
end

function OneHitWonder_GetComboPointsNeededToEviscerate(avoidHealth)
	if ( not avoidHealth ) then
		local needed = OneHitWonder_GetComboPointsNeededToEviscerateMobHealth();
		if ( needed > -1 ) then
			return needed;
		end
	end
	if ( OneHitWonder_Rogue_UseNewEviscerateCode ~= 1 ) then
		return OneHitWonder_GetComboPointsNeededToEviscerateOld();
	end
	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();
	local comboPoints = 0;
	if ( unitHPPercent <= OneHitWonder_Rogue_EviscerateNowPercentage ) then
		comboPoints = 1;
	elseif ( unitHPPercent >= OneHitWonder_Rogue_EviscerateExtraComboPointPercentage ) then
		comboPoints = OneHitWonder_Rogue_EviscerateBaseComboPoints+1;
	elseif ( unitHPPercent >= OneHitWonder_Rogue_EviscerateTwiceExtraComboPointPercentage ) then
		comboPoints = OneHitWonder_Rogue_EviscerateBaseComboPoints+1;
	end
	if ( comboPoints > 5 ) then
		comboPoints = 5;
	end
	return comboPoints;
end

function OneHitWonder_GetUnitHealthLeft(unit)
	if ( not UnitIsPlayer(unit) ) then 
		if ( unit == "pet" ) then
			return UnitHealth(unit);
		end
		if ( MobHealthDB ) then
			local name = UnitName(unit);
			local level = UnitLevel(unit);
			local index = name..":"..level;
			local data = MobHealthDB[index];
			if ( data ) then
				local health = UnitHealth(unit);
				return (data.damPts/data.damPct*health);
			else
				return -1;
			end
		else
			return -1;
		end
	else
		if ( unit == "player") or ( strfind(unit, "party") ) then
			return UnitHealth(unit);
		else
			return -1;
		end
	end
end

ONEHITWONDER_ROGUE_EVISCERATE_POINT			= "%d point";
ONEHITWONDER_ROGUE_EVISCERATE_POINT_SEP		= ": ";
ONEHITWONDER_ROGUE_EVISCERATE_LINE_END		= " damage";
ONEHITWONDER_ROGUE_EVISCERATE_DAMAGE_SEP	= "-";

function OneHitWonder_GetEviscerateDataFromTooltip(strings)
	local list = {};
	if ( strings[5] ) and ( strings[5].left ) then
		local index = 1;
		local strIndex = 0;
		local strOldIndex = 0;
		local str = strings[5].left;
		local tmpStr = nil;
		local ok = false;
		while ( index <= 5 ) do
			ok = false;
			tmpStr = format(ONEHITWONDER_ROGUE_EVISCERATE_POINT, index);
			strIndex = strfind(str, tmpStr);
			if ( strIndex ) then
				strIndex = strIndex+strlen(tmpStr);
				strOldIndex = strIndex;
				strIndex = strfind(str, ONEHITWONDER_ROGUE_EVISCERATE_LINE_END, strOldIndex);
				if ( strIndex ) then
					tmpStr = strsub(str, strOldIndex, strIndex);
					strIndex = strfind(tmpStr, ONEHITWONDER_ROGUE_EVISCERATE_POINT_SEP);
					if ( strIndex ) then
						tmpStr = strsub(tmpStr, strIndex+strlen(ONEHITWONDER_ROGUE_EVISCERATE_POINT_SEP));
					end
					strIndex = strfind(tmpStr, ONEHITWONDER_ROGUE_EVISCERATE_DAMAGE_SEP);
					if ( strIndex ) then
						local minDamage = tonumber(strsub(tmpStr, 1, strIndex-1));
						local maxDamage = tonumber(strsub(tmpStr, strIndex+1));
						if ( minDamage ) and ( maxDamage ) then
							local element = {};
							element.minDamage = minDamage;
							element.maxDamage = maxDamage;
							list[index] = element;
							ok = true;
						end
					end
				end
			end
			if ( not ok ) then
				break;
			end
			index = index + 1;
		end
	end
	return list;
end

function OneHitWonder_GetMaximumEviscerateDamage(eviscerateDamageData)
	local data = eviscerateDamageData[5];
	if ( data ) then
		return data.maxDamage;
	else
		return -1;
	end
end

function OneHitWonder_GetComboPointsNeededToEviscerateMobHealth()
	local healthLeft = OneHitWonder_GetUnitHealthLeft("target");
	if ( healthLeft <= -1 ) then
		return -1;
	end
	local eviscerateId = DynamicData.spell.getMatchingSpellId(ONEHITWONDER_ABILITY_EVISCERATE_NAME);
	if ( eviscerateId > -1 ) then
		local eviscerateData = DynamicData.spell.getSpellInfo(eviscerateId);
		local eviscerateDamageData = OneHitWonder_GetEviscerateDataFromTooltip(eviscerateData.strings);
		local data = nil;
		for comboPoints, data in eviscerateDamageData do
			if ( healthLeft >= data.minDamage ) and ( healthLeft <= data.maxDamage ) then
				return comboPoints;
			end
		end
		data = eviscerateDamageData[1];
		if ( data ) then
			if ( healthLeft < data.minDamage ) then
				return 1;
			else
				local exceeded = healthLeft / OneHitWonder_GetMaximumEviscerateDamage(eviscerateDamageData);
				if ( exceeded > 2 ) then
					return OneHitWonder_GetComboPointsNeededToEviscerate(true);
				else
					return 5;
				end
			end
		else
			return 1;
		end
	else
		return -1;
	end
end

function OneHitWonder_GetComboPointsNeededToEviscerateOld()
	local unitHPPercent = OneHitWonder_GetTargetHPPercentage();

	local playerLevel = UnitLevel("player");
	local targetLevel = UnitLevel("target");
	if ( targetLevel - playerLevel > 5 ) then
		-- does not matter, you're not going to do something good with it anyhow
		return 1;
	end
	if ( playerLevel - targetLevel >= 10 ) then
		-- will prolly kill it quick
		return 1;
	end
	if ( playerLevel - targetLevel >= 5 ) then
		if ( unitHPPercent <= 15 ) then
			return 1;
		elseif ( unitHPPercent <= 50 ) then
			return 2;
		else
			return 4;
		end
	end
	if ( playerLevel - targetLevel >= 3 ) then
		if ( unitHPPercent <= 20 ) then
			return 1;
		elseif ( unitHPPercent <= 50 ) then
			return 2;
		else
			return 4;
		end
	end
	if ( playerLevel - targetLevel >= -1 ) then
		if ( unitHPPercent <= 25 ) then
			return 1;
		elseif ( unitHPPercent <= 40 ) then
			return 3;
		elseif ( unitHPPercent <= 50 ) then
			return 4;
		else
			return 5;
		end
	else
		if ( unitHPPercent <= 10 ) then
			return 2;
		elseif ( unitHPPercent <= 25 ) then
			return 3;
		elseif ( unitHPPercent <= 50 ) then
			return 4;
		else
			return 5;
		end
	end
end



function OneHitWonder_Rogue_SetShouldPickPocket(toggle)
	OneHitWonder_Rogue_ShouldPickPocket = toggle;
end

function OneHitWonder_Rogue_SetShouldRiposte(toggle)
	OneHitWonder_Rogue_ShouldRiposte = toggle;
end

function OneHitWonder_Rogue_SetShouldCheapShot(toggle)
	OneHitWonder_Rogue_ShouldCheapShot = toggle;
end

function OneHitWonder_Rogue_SetShouldAmbush(toggle)
	OneHitWonder_Rogue_ShouldAmbush = toggle;
end

function OneHitWonder_Rogue_SetShouldBackstab(toggle)
	OneHitWonder_Rogue_ShouldBackstab = toggle;
end

function OneHitWonder_Rogue_SetUseSmartExposeArmor(toggle)
	OneHitWonder_Rogue_UseSmartExposeArmor = toggle;
end

function OneHitWonder_Rogue_SetUseSmartSliceDice(toggle)
	OneHitWonder_Rogue_UseSmartSliceDice = toggle;
end

function OneHitWonder_Rogue_SetSliceDicePercentage(toggle, value)
	OneHitWonder_Rogue_SliceDicePercentageDirection = toggle;
	OneHitWonder_Rogue_SliceDicePercentage = value;
end

function OneHitWonder_Rogue_SetSliceDiceComboPointsMin(toggle, value)
	OneHitWonder_Rogue_SliceDiceComboPointsMin = value;
end

function OneHitWonder_Rogue_SetSliceDiceComboPointsMax(toggle, value)
	OneHitWonder_Rogue_SliceDiceComboPointsMax = value;
end

function OneHitWonder_Rogue_SetExposeArmorPercentage(toggle, value)
	OneHitWonder_Rogue_ExposeArmorPercentage = value;
end

function OneHitWonder_Rogue_SetExposeArmorComboPointsMin(toggle, value)
	OneHitWonder_Rogue_ExposeArmorComboPointsMin = value;
end

function OneHitWonder_Rogue_SetExposeArmorComboPointsMax(toggle, value)
	OneHitWonder_Rogue_ExposeArmorComboPointsMax = value;
end

function OneHitWonder_Rogue_SetUseNewEviscerateCode(toggle)
	OneHitWonder_Rogue_UseNewEviscerateCode = toggle;
end

function OneHitWonder_Rogue_SetEviscerateNowPercentage(toggle, value)
	OneHitWonder_Rogue_EviscerateNowPercentage = value;
end

function OneHitWonder_Rogue_SetEviscerateExtraComboPointPercentage(toggle, value)
	OneHitWonder_Rogue_EviscerateExtraComboPointPercentage = value;
end

function OneHitWonder_Rogue_SetEviscerateTwiceExtraComboPointPercentage(toggle, value)
	OneHitWonder_Rogue_EviscerateTwiceExtraComboPointPercentage = value;
end

function OneHitWonder_Rogue_SetEviscerateBaseComboPoints(toggle, value)
	OneHitWonder_Rogue_EviscerateBaseComboPoints = value;
end

function OneHitWonder_Rogue_SetReactiveCastKick(toggle)
	OneHitWonder_Rogue_ReactiveCastKick = toggle;
end

function OneHitWonder_Rogue_SetAllowedBackstabAttempts(toggle, value)
	OneHitWonder_Rogue_AllowedBackstabAttempts = value;
end

function OneHitWonder_Rogue_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_ROGUE_SEPARATOR),
			TEXT(ONEHITWONDER_ROGUE_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_PICK_POCKET",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_PICK_POCKET),
			TEXT(ONEHITWONDER_ROGUE_USE_PICK_POCKET_INFO),
			OneHitWonder_Rogue_SetShouldPickPocket,
			OneHitWonder_Rogue_ShouldPickPocket
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_RIPOSTE",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_RIPOSTE),
			TEXT(ONEHITWONDER_ROGUE_USE_RIPOSTE_INFO),
			OneHitWonder_Rogue_SetShouldRiposte,
			OneHitWonder_Rogue_ShouldRiposte
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_REACTIVE_CAST_KICK",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_REACTIVE_CAST_KICK),
			TEXT(ONEHITWONDER_ROGUE_REACTIVE_CAST_KICK_INFO),
			OneHitWonder_Rogue_SetReactiveCastKick,
			OneHitWonder_Rogue_ReactiveCastKick
		);
		--[[
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_STEALTH_ATTACK_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_ROGUE_STEALTH_ATTACK_SEPARATOR),
			TEXT(ONEHITWONDER_ROGUE_STEALTH_ATTACK_SEPARATOR_INFO)
		);
		]]--
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_ALLOWED_STEALTH_ATTACK_ATTEMPTS",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_ALLOWED_STEALTH_ATTACK_ATTEMPTS),
			TEXT(ONEHITWONDER_ROGUE_ALLOWED_STEALTH_ATTACK_ATTEMPTS_INFO),
			OneHitWonder_Rogue_SetAllowedBackstabAttempts,
			1,
			OneHitWonder_Rogue_AllowedBackstabAttempts, -- default
			0, -- min
			10, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_ALLOWED_STEALTH_ATTACK_ATTEMPTS_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_CHEAP_SHOT",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_CHEAP_SHOT),
			TEXT(ONEHITWONDER_ROGUE_USE_CHEAP_SHOT_INFO),
			OneHitWonder_Rogue_SetShouldCheapShot,
			OneHitWonder_Rogue_ShouldCheapShot
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_AMBUSH",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_AMBUSH),
			TEXT(ONEHITWONDER_ROGUE_USE_AMBUSH_INFO),
			OneHitWonder_Rogue_SetShouldAmbush,
			OneHitWonder_Rogue_ShouldAmbush
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_BACKSTAB",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_BACKSTAB),
			TEXT(ONEHITWONDER_ROGUE_USE_BACKSTAB_INFO),
			OneHitWonder_Rogue_SetShouldBackstab,
			OneHitWonder_Rogue_ShouldBackstab
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EXPOSE_ARMOR_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_SEPARATOR),
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_SMART_EXPOSE_ARMOR",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_SMART_EXPOSE_ARMOR),
			TEXT(ONEHITWONDER_ROGUE_USE_SMART_EXPOSE_ARMOR_INFO),
			OneHitWonder_Rogue_SetUseSmartExposeArmor,
			OneHitWonder_Rogue_UseSmartExposeArmor
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EXPOSE_ARMOR",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR),
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_INFO),
			OneHitWonder_Rogue_SetExposeArmorPercentage,
			1,
			OneHitWonder_Rogue_ExposeArmorPercentage, -- default
			0, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MIN",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MIN),
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MIN_INFO),
			OneHitWonder_Rogue_SetExposeArmorComboPointsMin,
			1,
			OneHitWonder_Rogue_ExposeArmorComboPointsMin, -- default
			1, -- min
			5, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MIN_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MAX",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MAX),
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MAX_INFO),
			OneHitWonder_Rogue_SetExposeArmorComboPointsMax,
			1,
			OneHitWonder_Rogue_ExposeArmorComboPointsMax, -- default
			1, -- min
			5, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EXPOSE_ARMOR_COMBO_POINTS_MAX_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_SLICE_DICE_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_SEPARATOR),
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_USE_SMART_SLICE_DICE",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_USE_SMART_SLICE_DICE),
			TEXT(ONEHITWONDER_ROGUE_USE_SMART_SLICE_DICE_INFO),
			OneHitWonder_Rogue_SetUseSmartSliceDice,
			OneHitWonder_Rogue_UseSmartSliceDice
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_SLICE_DICE",
			"BOTH",
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE),
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_INFO),
			OneHitWonder_Rogue_SetSliceDicePercentage,
			OneHitWonder_Rogue_SliceDicePercentageDirection,
			OneHitWonder_Rogue_SliceDicePercentage, -- default
			0, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MIN",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MIN),
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MIN_INFO),
			OneHitWonder_Rogue_SetSliceDiceComboPointsMin,
			1,
			OneHitWonder_Rogue_SliceDiceComboPointsMin, -- default
			1, -- min
			5, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MIN_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MAX",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MAX),
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MAX_INFO),
			OneHitWonder_Rogue_SetSliceDiceComboPointsMax,
			1,
			OneHitWonder_Rogue_SliceDiceComboPointsMax, -- default
			1, -- min
			5, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_SLICE_DICE_COMBO_POINTS_MAX_APPEND)
		);
		--[[
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EVISCERATE_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_SEPARATOR),
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EVISCERATE_USE_NEW",
			"CHECKBOX",
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_USE_NEW),
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_USE_NEW_INFO),
			OneHitWonder_Rogue_SetUseNewEviscerateCode,
			OneHitWonder_Rogue_UseNewEviscerateCode
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EVISCERATE_NOW",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_NOW),
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_NOW_INFO),
			OneHitWonder_Rogue_SetEviscerateNowPercentage,
			1,
			OneHitWonder_Rogue_EviscerateNowPercentage, -- default
			0, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_NOW_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EVISCERATE_BASE_COMBO_POINTS",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_BASE_COMBO_POINTS),
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_BASE_COMBO_POINTS_INFO),
			OneHitWonder_Rogue_SetEviscerateBaseComboPoints,
			1,
			OneHitWonder_Rogue_EviscerateBaseComboPoints, -- default
			1, -- min
			5, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_BASE_COMBO_POINTS_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINT",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINT),
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINT_INFO),
			OneHitWonder_Rogue_SetEviscerateExtraComboPointPercentage,
			1,
			OneHitWonder_Rogue_EviscerateExtraComboPointPercentage, -- default
			1, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINT_APPEND)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINTS",
			"SLIDER",
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINTS),
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINTS_INFO),
			OneHitWonder_Rogue_SetEviscerateTwiceExtraComboPointPercentage,
			1,
			OneHitWonder_Rogue_EviscerateTwiceExtraComboPointPercentage, -- default
			1, -- min
			100, -- max
			"",
			1,
			1,
			TEXT(ONEHITWONDER_ROGUE_EVISCERATE_EXTRA_COMBO_POINTS_APPEND)
		);
		]]--
	end
	
end

function OneHitWonder_TryToInterruptSpell_Rogue(unitName, spellName)
	local interruptId = -1;
	local abilityName = "";
	abilityName = ONEHITWONDER_ABILITY_KICK_NAME;
	if ( OneHitWonder_Rogue_ReactiveCastKick ~= 1 ) then
		abilityName = "";
	end
	if ( ( abilityName ) and 
		(strlen(abilityName) > 0) ) then
		interruptId = OneHitWonder_GetSpellId(abilityName);
		--[[
		if ( OneHitWonder_GetSpellCooldown(interruptId) <= 3 ) then
			abilityName = "";
			interruptId = -1;
		end
		]]--
	end
	return interruptId, abilityName;
end



function OneHitWonder_ShouldHandleActionQueue_Rogue()
	if ( OneHitWonder_HasPlayerEffect(nil, ONEHITWONDER_ABILITY_STEALTH_EFFECTS) ) then
		return false;
	else
		return true;
	end
end


function OneHitWonder_GetParryCounter_Rogue()
	local abilityName = "";
	local counterId = -1;
	if ( OneHitWonder_Rogue_ShouldRiposte == 1 ) then
		local spellId = OneHitWonder_GetSpellId(ONEHITWONDER_ABILITY_RIPOSTE_NAME);
		if ( spellId > -1 ) then
			local targetName = UnitName("target");
			local creatureType = UnitCreatureType("target");
			local found = false;
			if ( creatureType ) and ( strlen(creatureType) > 0 ) and ( not found ) then
				for k, v in OneHitWonder_NonDisarmableMobTypes do
					if ( v == creatureType ) then
						found = true;
						break;
					end
				end
				if ( not found ) then
					for k, v in OneHitWonder_NonDisarmableMobTypes do
						if ( strfind(v, creatureType) ) then
							found = true;
							break;
						end
					end
				end
			end
			if ( targetName ) and ( strlen(targetName) > 0 ) and ( not found ) then
				for k, v in OneHitWonder_NonDisarmableMobs do
					if ( v == targetName ) then
						found = true;
						break;
					end
				end
				if ( not found ) then
					abilityName = ONEHITWONDER_ABILITY_RIPOSTE_NAME;
					counterId = spellId;
				end
			end
		end
	end
	return counterId, abilityName;
end


function OneHitWonder_SetupStuffContinously_Rogue()
	OneHitWonder_AddStuffContinously(ONEHITWONDER_ABILITY_DETECT_TRAPS_NAME, true, true);
end

function OneHitWonder_Rogue_EquipItem(itemName, slot)
	if ( not itemName ) or ( not slot ) then
		return true;
	end
	local itemInfo = DynamicData.item.getItemByName(itemName);
	if ( ( itemInfo.position ) and ( getn(itemInfo.position) > 0 ) ) then
		for k, pos in itemInfo.position do
			if ( ( pos.bag == -1 ) and ( pos.slot == slot ) ) then
				return true;
			end
		end
		local pos = itemInfo.position[1];
		PickupContainerItem(pos.bag, pos.slot);
		PickupInventoryItem(slot);
	end
	return false;
end


function OneHitWonder_Rogue_EquipWeapons(mainHand, offHand)
	if ( Equip ) then
		Equip(mainHand);
	else
		OneHitWonder_Rogue_EquipItem(offHand, 16);
	end
	if ( EquipOffhand ) then
		EquipOffhand(offHand);
	else
		OneHitWonder_Rogue_EquipItem(offHand, 17);
	end
end

function OneHitWonder_Rogue_SwitchBackWeapons()
	PickupInventoryItem(17);
	PickupInventoryItem(16);
end

OneHitWonder_Rogue_Equipping = {};

function OneHitWonder_Rogue_DoEquipping()
	if ( not OneHitWonder_Rogue_Equipping ) then
		OneHitWonder_Rogue_Equipping = {};
	else
		if ( table.getn( OneHitWonder_Rogue_Equipping ) > 0 ) then
			local equipInfo = OneHitWonder_Rogue_Equipping[1];
			table.remove(OneHitWonder_Rogue_Equipping, 1);
			local hasEquippedAHand = false;
			for k, v in equipInfo do
				if ( ( v.slot ~= 16 ) and ( v.slot ~= 17 ) ) or ( not hasEquippedAHand ) then
					OneHitWonder_Rogue_EquipItem(v.name, v.slot);
					if ( v.slot == 16 ) or ( v.slot == 17 ) then
						hasEquippedAHand = true;
					end
				end
			end
		end
	end
	DynamicItem.item.removeOnInventoryUpdate(OneHitWonder_Rogue_DoEquipping);
end

function OneHitWonder_Rogue_FindBestDagger(daggers)
	local highestDPS = 0;
	local highestDPSIndex = 1;
	local dps = nil;
	for k, v in daggers do
		if ( v.strings ) then
			if ( DynamicData.util.isItemNotBindOnAnything(v.strings) ) then
				dps = DynamicData.util.getDPS(v.strings);
				if ( dps ) and ( dps > highestDPS ) then
					highestDPS = dps;
					highestDPSIndex = k;
				end
			end
		end
	end
	return daggers[highestDPSIndex];
end

function OneHitWonder_Rogue_FindBestNonDagger(weapons)
	local highestAverageDamage = 0;
	local highestIndex = 1;
	local damageMin, damageMax = nil, nil;
	local averageDamage = 0;
	for k, v in weapons do
		if ( v.strings ) then
			if ( DynamicData.util.isItemNotBindOnAnything(v.strings) ) then
				damageMin, damageMax = DynamicData.util.getDamage(v.strings);
				if ( damageMin ) and ( damageMax ) then
					averageDamage = ( damageMax + damageMin ) / 2;
					if ( averageDamage > highestAverageDamage ) then
						highestAverageDamage = averageDamage;
						highestIndex = k;
					end
				end
			end
		end
	end
	return weapons[highestIndex];
end

function OneHitWonder_Rogue_EquipDagger()
	local itemInfoMainHand = DynamicData.item.getEquippedSlotInfo(16);
	if ( itemInfoMainHand.itemType == ONEHITWONDER_ITEM_TYPE_DAGGER ) then
		return true;
	end
	if ( CursorHasItem() ) then
		return false;
	end
	local itemInfoOffHand = DynamicData.item.getEquippedSlotInfo(17);
	if ( itemInfoOffHand.itemType == ONEHITWONDER_ITEM_TYPE_DAGGER ) then
		PickupInventoryItem(17);
		PickupInventoryItem(16);
		local data = {};
		data[1] = { itemInfoMainHand.name, 16 };
		data[2] = { itemInfoOffHand.name, 17 };
		table.insert(OneHitWonder_Rogue_Equipping, data);
	else
		local daggers = DynamicData.item.getItemInfoByType(ONEHITWONDER_ITEM_TYPE_DAGGER);
		if ( getn(daggers) > 0 ) then
			local itemInfo = OneHitWonder_Rogue_FindBestDagger(daggers);
			local data = {};
			data[1] = { itemInfoMainHand.name, 16 };
			table.insert(OneHitWonder_Rogue_Equipping, data);
		end
	end
	DynamicItem.item.addOnInventoryUpdate(OneHitWonder_Rogue_DoEquipping);
end

function OneHitWonder_Rogue_EquipNonDagger()
	local itemInfoMainHand = DynamicData.item.getEquippedSlotInfo(16);
	if ( itemInfoMainHand.itemType ~= ONEHITWONDER_ITEM_TYPE_DAGGER ) then
		return true;
	end
	if ( CursorHasItem() ) then
		return false;
	end
	local itemInfoOffHand = DynamicData.item.getEquippedSlotInfo(17);
	if ( itemInfoOffHand.itemType ~= ONEHITWONDER_ITEM_TYPE_DAGGER ) then
		PickupInventoryItem(17);
		PickupInventoryItem(16);
		local data = {};
		data[1] = { itemInfoMainHand.name, 16 };
		data[2] = { itemInfoOffHand.name, 17 };
		table.insert(OneHitWonder_Rogue_Equipping, data);
	else
		local maces = DynamicData.item.getItemInfoByType(ONEHITWONDER_ITEM_TYPE_MACES);
		local swords = DynamicData.item.getItemInfoByType(ONEHITWONDER_ITEM_TYPE_SWORDS);
		local weapons = {};
		if ( maces ) then
			for k, v in maces do
				table.insert(weapons, v);
			end
		end
		if ( swords ) then
			for k, v in swords do
				table.insert(weapons, v);
			end
		end
		if ( getn(weapons) > 0 ) then
			local itemInfo = OneHitWonder_Rogue_FindBestNonDagger(weapons);
			local data = {};
			data[1] = { itemInfoMainHand.name, 16 };
			table.insert(OneHitWonder_Rogue_Equipping, data);
		end
	end
	DynamicItem.item.addOnInventoryUpdate(OneHitWonder_Rogue_DoEquipping);
end
