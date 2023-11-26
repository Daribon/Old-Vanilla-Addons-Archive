-- include_once("constants.lua")

ACR_OPTION_RECORD_PLAYER = false;

function ArmorCalculatorRecorder_OnLoad()
	ArmorCalculatorRecorder_InitiateLocalization();
	if ( ACR_SUPPORTED_LOCALE[GetLocale()] ) then
		this:RegisterEvent("SKILLS_CHANGED");
		this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
		if ( ACR_LNGOPT_PLAYER_SKILL_HIT_REGEXP ) then
			this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
		end
	else
		ChatFrame1:AddMessage(ACR_MSG_UNSUPPORTED_LOCALE);
	end
end

function ArmorCalculatorRecorder_OnEvent(msg)
	ChatMessage1:AddMessage("OnEvent!");
	if ( msg ) then
		ChatMessage1:AddMessage("Message was: "..msg);
	end
	if ( event == ACR_EVENT_SKILLS_CHANGED ) then
		if ( ArmorCalculatorRecorder_SkillCache ) then
			for k, v in pairs(ArmorCalculatorRecorder_SkillCache) do
				ArmorCalculatorRecorder_SkillCache[k] = -2;
			end
		else
			ArmorCalculatorRecorder_SkillCache = {};
		end
	elseif ( event == "CHAT_MSG_COMBAT_SELF_HITS" ) or ( event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
		ArmorCalculatorRecorder_RegisterHit(msg);
	else
		if ( not ArmorCalculatorRecorder_StrangeEvents ) then	
			ArmorCalculatorRecorder_StrangeEvents = {};
		end
		if ( not ArmorCalculatorRecorder_StrangeEvents[event] ) then
			ChatFrame1:AddMessage("Strange and wonderful event sent to ACR!", 1, 0.1, 0.1, 1);
			ArmorCalculatorRecorder_StrangeEvents[event] = 1;
		end
	end
end

function ArmorCalculatorRecorder_GetExtraDamage_Tooltip(skillIndex, pattern, match)
	ArmorCalculatorRecorderTooltip:SetSpell(skillIndex);
	local objName = "ArmorCalculatorRecorderTooltipTextLeft";
	local text, str;
	local obj = nil;
	for i = 2, 8 do
		obj = getglobal(objName..i);
		if ( obj ) then
			text = obj:GetText();
			for str in string.gfind(text, pattern) do
				str = tonumber(str);
				if ( str ) then
					return str;
				end
			end
		end
	end
	return nil;
end

--- Retrieves the amount of extra damage
function ArmorCalculatorRecorder_GetExtraDamage(ability)
	if ( ACR_SKILL_TRANSLATE ) then
		local index = ACR_SKILL_TRANSLATE[ability];
		local _, class = UnitClass("player");
		local arr = ACR_SKILL_EXTRA_DAMAGE[class];
		if ( arr ) then
			arr = arr[index];
			if ( arr ) then
				local level = UnitLevel("player");
				local highestLevel = -1;
				local extraDamage = nil;
				for key, value in pairs(arr) do
					if ( value.l > highestLevel ) and ( value.l <= level ) then
						extraDamage = value.e;
					end
				end
				return extraDamage;
			end
		end
	end
	local cache = ArmorCalculatorRecorder_SkillCache[ability];
	if ( cache ~= nil ) and ( cache ~= -2 ) then
		if ( cache == -1 ) then
			return nil;
		else
			return cache;
		end
	end
	local i = 1;
	local name = GetSkillName(i);
	local lastMatchingIndex = nil;
	while ( name ) do
		if ( name == ability ) then
			lastMatchingIndex = i;
		-- optimization
		elseif ( lastMatchingIndex ) then 
			break;
		end
		i = i + 1;
		name = GetSkillName(i);
	end
	if ( lastMatchingIndex ) then
		-- semi-generic damage extractor. Searches for the first number.
		local regexp = "([0-9]+)";
		local match = 1;
		local result = nil;
		local func = ArmorCalculatorRecorder_GetExtraDamage_Tooltip;
		if ( ACR_LNGOPT_EXTRA_SKILLS_TOOLTIP_REGEXP ) then
			local arr = ACR_LNGOPT_EXTRA_SKILLS_TOOLTIP_REGEXP[ability];
			if ( arr ) then
				if ( arr.func ) then
					func = arr.func;
				end
				if ( arr.pattern ) then 
					regexp = arr.pattern;
				end
				if ( arr.match ) then 
					regexp = arr.match;
				end
			end
		end
		local result = arr.func(lastMatchingIndex, regexp, match, ability);
		if ( result ) and ( ACR_OPTION_CACHE_SKILL_DAMAGE ) then
			ArmorCalculatorRecorder_SkillCache[ability] = str;
		end
		return result;

	end
	ArmorCalculatorRecorder_SkillCache[ability] = -1;
	return nil;
end

function ArmorCalculatorRecorder_GetBaseDamage(ability, unit)
	if ( not unit ) then
		unit = "player";
	end
	local minDamage;
	local maxDamage; 
	local minOffHandDamage;
	local maxOffHandDamage; 
	local physicalBonusPos;
	local physicalBonusNeg;
	local percent;

	if ( ability == ACR_ABILITY_MELEE ) then
		minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage(unit);
		local speed, offhandSpeed = UnitAttackSpeed(unit);
		if ( offhandSpeed ) then
			minDamage = ( minDamage + minOffHandDamage );
			maxDamage = ( maxDamage + maxOffHandDamage );
			physicalBonusPos = physicalBonusPos * 2;
			physicalBonusNeg = physicalBonusNeg * 2;
		end
	elseif ( ability == ACR_ABILITY_RANGED ) then
		local temp1, temp2, temp3, temp4;
		temp1, temp2, temp3, temp4, physicalBonusPos, physicalBonusNeg, percent = UnitDamage(unit);
		local rangedAttackSpeed; 
		rangedAttackSpeed, minDamage, maxDamage = UnitRangedDamage(unit);
	else
		return nil;
	end

	minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
	maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;
	local baseDamage = (minDamage + maxDamage) * 0.5;
	return baseDamage;
end	


--- Calculates the average damage of the specified ability.
-- Requires ACR_LNGOPT_EXTRA_SKILLS for non-melee/ranged abilities
-- @param ability what ability to get the average damage from
function ArmorCalculatorRecorder_GetAverageDamage(ability)
	local baseDamage, extraDamage;
	if ( ability == ACR_ABILITY_MELEE ) then
		baseDamage = ArmorCalculatorRecorder_GetBaseDamage(ability);
	elseif ( ability == ACR_ABILITY_RANGED ) then
		baseDamage = ArmorCalculatorRecorder_GetBaseDamage(ability);
	else
		if ( not ACR_LNGOPT_EXTRA_SKILLS ) then
			return nil;
		end
		if ( ACR_LNGOPT_EXTRA_SKILLS[ACR_ABILITY_MELEE] ) 
		and ( ACR_LNGOPT_EXTRA_SKILLS[ACR_ABILITY_MELEE][ability] ) then
			baseDamage = ArmorCalculatorRecorder_GetBaseDamage(ACR_ABILITY_MELEE);
		elseif ( ACR_LNGOPT_EXTRA_SKILLS[ACR_ABILITY_RANGED] ) 
		and ( ACR_LNGOPT_EXTRA_SKILLS[ACR_ABILITY_RANGED][ability] ) then
			baseDamage = ArmorCalculatorRecorder_GetBaseDamage(ACR_ABILITY_RANGED);
		else
			return nil;
		end
		if ( baseDamage ) then
			extraDamage = ArmorCalculatorRecorder_GetExtraDamage(ability);
			if ( extraDamage ) then
				baseDamage = baseDamage + extraDamage;
			end
		end
	end
	return baseDamage;
end


--- Checks for damage related debuffs by seeing if the unit has any debuffs.
-- This is a very restrictive check, but it should give good data.
-- Note that the unit can still buff itself and thereby get a changed 
-- damage value.
-- @param unit The unit ID to check.
function ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs_Any(unit)
	local i = 1;
	if ( UnitDebuff(unit, 1) ) then
		return true;
	end
	return false;
end

--- Checks for damage related debuffs by debuff icon.
-- @param unit The unit ID to check.
function ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs_Icons(unit)
	local i = 1;
	local debuff = UnitDebuff(unit, i);
	while ( debuff ) do
		if ( ACR_ICON_DMG_REL_DEBUFFS[debuff] ) then
			return true;
		end
		i = i + 1;
		debuff = UnitDebuff(unit, i);
	end
	return false;
end

--- Checks for damage related debuffs by debuff name.
-- @param unit The unit ID to check.
function ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs_Names(unit)
	if ( not ACR_LNGOPT_NAME_DMG_REL_DEBUFFS ) then
		return false;
	end
	local i = 1;
	local debuff = UnitDebuff(unit, i);
	local name;
	while ( debuff ) do
		ArmorCalculatorRecorderTooltip:SetUnitDebuff(unit, i);
		name = ArmorCalculatorRecorderTooltipTextLeft1:GetText();
		if ( name ) and ( ACR_LNGOPT_NAME_DMG_REL_DEBUFFS[name] ) then
			return true;
		end
		i = i + 1;
		debuff = UnitDebuff(unit, i);
	end
	return false;
end

-- dirty fix to make the check a bit faster.
if ( ACR_LNGOPT_NAME_DMG_REL_DEBUFFS ) then
	ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs = ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs_Names;
else
	ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs = ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs_Icons;
end

--- Handles a hit event, recording it in the database.
-- @see ArmorCalculator_AddData
function ArmorCalculatorRecorder_RegisterHit(message)
	local name, damage, ability = ArmorCalculatorRecorder_InterpretHit(message, event);
	if ( not ACR_OPTION_RECORD_PLAYER ) and ( UnitPlayer("target") ) then
		return false;
	end
	if ( name ) and ( name == UnitName("target") ) then
		-- if the unit has armor/damage debuffs
		if ( not ArmorCalculatorRecorder_HasUnitDamageRelatedDebuffs("target") ) then
			local avgDamage = ArmorCalculatorRecorder_GetAverageDamage(ability);
			if ( avgDamage ) and ( avgDamage > 0 ) then
				ArmorCalculator_AddData(name, UnitLevel("target"), avgDamage, damage);
				return true;
			end
		end
	else
		return false;
	end
end

