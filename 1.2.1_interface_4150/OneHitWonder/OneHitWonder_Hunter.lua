OneHitWonder_Hunter_ShouldPetAttack = 0;


function OneHitWonder_Hunter(removeDefense)
	local targetName = UnitName("target");

	if ( (not targetName) or ( strlen(targetName) <= 0 ) ) then
		return;
	end
	
	if ( not removeDefense ) then removeDefense = false; end
	
	if ( OneHitWonder_IsChannelSpellRunning() ) or ( OneHitWonder_IsRegularSpellRunning() ) then
		return;
	end
	
	if ( OneHitWonder_HandleActionQueue() ) then
		return;
	end
	
	if ( not UnitCanAttack("player", "target") ) then
		OneHitWonder_DoBuffs();
		return;
	end
	
	if (OneHitWonder_PetIsAttacking == false) then
		OneHitWonder_Hunter_SmartPetAttack();
	end
end		


function OneHitWonder_Hunter_SetShouldPetAttack(toggle)
	OneHitWonder_Hunter_ShouldPetAttack = toggle;
end


function OneHitWonder_Hunter_Cosmos()
	if ( Cosmos_RegisterConfiguration ) then
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_HUNTER_SEPARATOR",
			"SEPARATOR",
			TEXT(ONEHITWONDER_HUNTER_SEPARATOR),
			TEXT(ONEHITWONDER_HUNTER_SEPARATOR_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONEHITWONDER_HUNTER_USE_SMART_PET_ATTACK",
			"CHECKBOX",
			TEXT(ONEHITWONDER_HUNTER_USE_SMART_PET_ATTACK),
			TEXT(ONEHITWONDER_HUNTER_USE_SMART_PET_ATTACK_INFO),
			OneHitWonder_Hunter_SetShouldPetAttack,
			OneHitWonder_Hunter_ShouldPetAttack
		);
		
	end
	
end



function OneHitWonder_Hunter_SmartPetAttack()
	return OneHitWonder_SmartPetAttack(OneHitWonder_Hunter_ShouldPetAttack);
end

function OneHitWonder_SetupStuffContinously_Hunter()
	--OneHitWonder_BuffTime[ONEHITWONDER_ABILITY_] = 5*60;
end


function OneHitWonder_GetParryCounter_Hunter()
	local counterId = -1;
	local abilityName = "";
	abilityName = ONEHITWONDER_ABILITY_COUNTERATTACK_NAME;
	counterId = OneHitWonder_GetSpellId(abilityName);
	return counterId, abilityName;
end

function OneHitWonder_GetDodgeCounter_Hunter()
	local counterId = -1;
	local abilityName = "";
	abilityName = ONEHITWONDER_ABILITY_MONGOOSE_BITE_NAME;
	counterId = OneHitWonder_GetSpellId(abilityName);
	return counterId, abilityName;
end


function OneHitWonder_DoStuffContinously_Hunter()
	if ( not OneHitWonder_IsEnabled() ) then return false; end
	local hasAnyAspect = false;
	if ( ( AuraAspects_Enabled ) and (  AuraAspects_Enabled == 1 ) ) then
		OneHitWonder_HasAnActiveWhatever(ONEHITWONDER_SPELL_ASPECT_SUBSTRING, true);
	else
		hasAnyAspect = OneHitWonder_HasPlayerEffect(nil, OneHitWonder_HunterAspects);
	end
	local buffIndex, untilCancelled;
	if ( ( not hasAnyAspect ) and ( not OneHitWonder_IsPlayerDead() ) and ( not OneHitWonder_IsPlayerOnTaxi() ) ) then
		local aspectId = nil;
		for k, v in OneHitWonder_HunterAspects do
			aspectId = OneHitWonder_GetSpellId(v);
			if ( ( OneHitWonder_IsSpellAvailable(aspectId) ) and ( not OneHitWonder_HasPlayerEffect(nil, v) ) ) then
				OneHitWonder_CastSpell(aspectId);
				return true;
			end
		end
	end
	return false;
end

