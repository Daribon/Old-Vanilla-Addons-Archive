-- ACR_SUPPORTED_LOCALE["deDE"] = 1;

if ( GetLocale() == "deDE" ) then

ACR_LNG_PLAYER_HIT_REGEXP = "Du trefft (.+) für (.+) schade.";
ACR_LNGOPT_PLAYER_SKILL_HIT_REGEXP = "Du trefft (.+) mit (.+) für (.+) schade.";
ACR_LNGOPT_NAME_DMG_REL_DEBUFFS = nil;
ACR_LNGOPT_RANGED_SKILLS = nil;
ACR_LNGOPT_EXTRA_SKILLS = nil;
ACR_LNGOPT_EXTRA_SKILLS_TOOLTIP_REGEXP = nil;
ACR_SKILL_TRANSLATE = nil;

function ArmorCalculatorRecorder_InitiateLocalization_German()
	return true;
end

ArmorCalculatorRecorder_InitiateLocalization = ArmorCalculatorRecorder_InitiateLocalization_German;

--- German version of ArmorCalculatorRecorder_InterpretHit.
-- @see ArmorCalculatorRecorder_InterpretHit
function ArmorCalculatorRecorder_InterpretHit_German(msg, event)
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

ArmorCalculatorRecorder_InterpretHit = ArmorCalculatorRecorder_InterpretHit_German;

end

