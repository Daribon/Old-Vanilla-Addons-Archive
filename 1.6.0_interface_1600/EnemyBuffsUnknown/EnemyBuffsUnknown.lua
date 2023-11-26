EnemyBuffsUnknown_Options = {
	enabled = true;
};

EnemyBuffsUnknown_Buffs = {
};

function EnemyBuffsUnknown_OnLoad()
	local f = EnemyBuffsUnknownFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	EnemySpellDetector_AddListener(EnemySpellDetector_Type_Gain, "EnemyBuffsUnknown_AddBuff");
end

function EnemyBuffsUnknown_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		EnemyBuffsUnknown_RemoveDuplicates();
	end
end

function EnemyBuffsUnknown_OnUpdate()
end

function EnemyBuffsUnknown_RemoveDuplicates()
	for k, v in EnemyBuffsUnknown_Buffs do
		if ( v ) and ( EnemyBuffs_BuffMap[k] ) then
			EnemyBuffsUnknown_Buffs[k] = nil;
		end
	end
end

function EnemyBuffsUnknown_AddBuff(performer, action, target)
	if ( not EnemyBuffsUnknown_Options.enabled ) then
		return;
	end
	local texture = EnemyBuffs_BuffMap[action];
	if ( texture == nil ) then
		EnemyBuffsUnknown_Buffs[action] = 1;
	end
end

