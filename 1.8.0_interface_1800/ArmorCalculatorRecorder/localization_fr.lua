-- ACR_SUPPORTED_LOCALE["deDE"] = 1;

if ( GetLocale() == "deDE" ) then

ACR_LNG_PLAYER_HIT_REGEXP = "";
ACR_LNGOPT_PLAYER_SKILL_HIT_REGEXP = "";
ACR_LNGOPT_NAME_ARMOR_DEBUFFS = nil;
ACR_LNGOPT_RANGED_SKILLS = nil;
ACR_LNGOPT_EXTRA_SKILLS = nil;
ACR_LNGOPT_EXTRA_SKILLS_TOOLTIP_REGEXP = nil;

--- French version of ArmorCalculatorRecorder_InitiateLocalization
-- @see ArmorCalculatorRecorder_InitiateLocalization
function ArmorCalculatorRecorder_InitiateLocalization_French()
	return true;
end

ArmorCalculatorRecorder_InitiateLocalization = ArmorCalculatorRecorder_InitiateLocalization_French;

--- French version of ArmorCalculatorRecorder_InterpretHit.
-- @see ArmorCalculatorRecorder_InterpretHit
function ArmorCalculatorRecorder_InterpretHit_French(msg, event)
	if ( event == ACR_EVENT_MELEE_HIT_ENEMY ) then
		local damage, name = strfind(msg, ACR_LNG_PLAYER_HIT_REGEXP);
		return name, damage, ACR_ABILITY_MELEE;
	elseif ( event == ACR_EVENT_SKILL_HIT_ENEMY ) then
		local name, skill, damage = strfind(msg, ACR_LNG_PLAYER_SKILL_HIT_REGEXP);
		if ( ACR_LNG_RANGED_SKILLS[skill] ) then
			return name, damage, ACR_ABILITY_RANGED;
		end
	end
	return nil, nil, nil;
end

ArmorCalculatorRecorder_InterpretHit = ArmorCalculatorRecorder_InterpretHit_French;

end

