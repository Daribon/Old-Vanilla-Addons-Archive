EnemyBuffs_Options_Default = {
	enabled = true;
	targetPatch = true;
	useDefaultBuffs = true;
	useTempIconForUnknownBuffs = true;
	tempIconForUnknownBuffs = "Interface\\Icons\\INV_Misc_QuestionMark";
};

EnemyBuffs_Options = {};

EnemyBuffs_Buffs = {
};

EnemyBuffs_TargetBuffs = {
};

EnemyBuffs_TargetBuffTextures = {
};

function EnemyBuffs_IsEnemyUnit(unit)
	if ( not UnitExists(unit) ) then
		return false;
	end
	local reaction = UnitReaction(unit, "player");
	if ( reaction ) then
		if (reaction > 4) then
			return false;
		else
			return true;
		end
	end
end

function EnemyBuffs_UnitBuff(unit, index)
	if ( not unit ) or ( unit ~= "target" ) then
		return EnemyBuffs_Saved_UnitBuff(unit, index);
	end
	if ( not EnemyBuffs_IsEnemyUnit(unit) ) then
		return EnemyBuffs_Saved_UnitBuff(unit, index);
	end
	if ( EnemyBuffs_Options.enabled ) then
		return EnemyBuffs_TargetBuffTextures[index];
	end
	return nil;
end

function EnemyBuffs_TargetDebuffButton_Update()
	EnemyBuffs_Saved_TargetDebuffButton_Update();
	local shouldShow = true;
	if ( not EnemyBuffs_IsEnemyUnit("target") ) then
		shouldShow = false;
	end
	if ( not EnemyBuffs_Options.enabled ) then
		shouldShow = false;
	end

	local buff, buffButton;
	local button;
	for i=1, 15 do
		buff = EnemyBuffs_TargetBuffTextures[i];
		button = getglobal("TargetFrameEnemyBuff"..i);
		if ( buff ) and ( shouldShow ) then
			getglobal("TargetFrameEnemyBuff"..i.."Icon"):SetTexture(buff);
			button:Show();
			button.id = i;
		else
			button:Hide();
		end
	end
end


function EnemyBuffs_SetUnitBuff(tooltip, unit, index)
	if ( not tooltip ) or ( not unit ) or ( not index ) then
		return;
	end
	local buff = EnemyBuffs_TargetBuffs[index];
	if ( not buff ) then
		tooltip:Hide();
	else
		local obj = getglobal(tooltip:GetName().."TextLeft1");
		tooltip:SetText(" ");
		--tooltip:AddLine(" ");
		obj:SetText(buff);
		obj:SetTextColor(1, 1, 0.2);
		obj:Show();
		local bt = EnemyBuffs_BuffType[buff];
		obj = getglobal(tooltip:GetName().."TextRight1");
		if ( bt ) then
			obj:SetTextColor(1, 1, 0.2);
			obj:SetText(bt);
			obj:Show();
		else
			obj:Hide();
		end
		tooltip:Show();
	end
end

function EnemyBuffs_GameTooltip_SetUnitBuff(tooltip, unit, index)
	if ( not tooltip ) or ( not unit ) or ( not index ) then
		return EnemyBuffs_Saved_GameTooltip_SetUnitBuff(tooltip, unit, index);
	end
	if ( not EnemyBuffs_Options.enabled ) or ( not EnemyBuffs_Options.targetPatch ) then
		return EnemyBuffs_Saved_GameTooltip_SetUnitBuff(tooltip, unit, index);
	end
	if ( unit == "target" ) and ( EnemyBuffs_IsEnemyUnit(unit) ) then
		EnemyBuffs_SetUnitBuff(tooltip, unit, index);
	else
		EnemyBuffs_Saved_GameTooltip_SetUnitBuff(tooltip, unit, index);
	end
end

function EnemyBuffs_ResetBuffs()
	local cleanDownTo = 1;
	local name = UnitName("target");
	if ( name ) then 
		if ( EnemyBuffs_Buffs[name] ) then
			for k, v in EnemyBuffs_Buffs[name] do
				if ( cleanDownTo <= k ) then cleanDownTo = k+1; end
				EnemyBuffs_TargetBuffs[k] = v;
				EnemyBuffs_TargetBuffTextures[k] = EnemyBuffs_BuffMap[v];
			end
		end
		for i = 16, cleanDownTo, -1 do
			EnemyBuffs_TargetBuffs[i] = nil;
			EnemyBuffs_TargetBuffTextures[i] = nil;
		end
	else
		EnemyBuffs_TargetBuffs = {};
		EnemyBuffs_TargetBuffTextures = {};
	end
	TargetDebuffButton_Update();
end

function EnemyBuffs_OnLoad()

	EnemyBuffs_MergeBuffMap(getglobal("EnemyBuffs_BuffMap_"..EnemyBuffs_Localization_Suffix));
	for k, v in getglobal("EnemyBuffs_BuffType_"..EnemyBuffs_Localization_Suffix) do
		EnemyBuffs_BuffType[k] = v;
	end
	for k, v in getglobal("EnemyBuffs_DefaultBuffs_"..EnemyBuffs_Localization_Suffix) do
		EnemyBuffs_DefaultBuffs[k] = v;
	end

	setglobal("EnemyBuffs_BuffMap_"..EnemyBuffs_Localization_Suffix, nil);
	setglobal("EnemyBuffs_BuffType_"..EnemyBuffs_Localization_Suffix, nil);
	setglobal("EnemyBuffs_DefaultBuffs_"..EnemyBuffs_Localization_Suffix, nil);

	local f = EnemyBuffsFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("PLAYER_TARGET_CHANGED");
	for k, v in EnemyBuffs_ChatMessages do
		f:RegisterEvent(k);
	end
	EnemySpellDetector_AddListener(EnemySpellDetector_Type_Gain, "EnemyBuffs_AddBuff");
	
	--[[
	EnemyBuffs_Saved_UnitBuff = UnitBuff;
	UnitBuff = EnemyBuffs_UnitBuff;
	
	EnemyBuffs_Saved_GameTooltip_SetUnitBuff = GameTooltip.SetUnitBuff;
	GameTooltip.SetUnitBuff = EnemyBuffs_GameTooltip_SetUnitBuff;
	]]--
	
	EnemyBuffs_Saved_TargetDebuffButton_Update = TargetDebuffButton_Update;
	TargetDebuffButton_Update = EnemyBuffs_TargetDebuffButton_Update;
	
	EnemyBuffs_PrepareForGFind();
end

function EnemyBuffs_OnEvent()
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		EnemyBuffs_TargetChanged();
		return;
	end
	if ( event == "VARIABLES_LOADED" ) then
		EnemyBuffs_HandleVariablesLoaded();
		return;
	end
	if ( EnemyBuffs_ChatMessages[event] ) then
		if ( EnemyBuffs_Options.enabled ) then
			EnemyBuffs_HandleEvent(event, arg1);
		end
		return;
	end
end

function EnemyBuffs_OnUpdate()
end

function EnemyBuffs_HandleVariablesLoaded()
	for k, v in EnemyBuffs_Options_Default do
		if ( EnemyBuffs_Options[k] == nil ) then
			EnemyBuffs_Options[k] = v;
		end
	end
	
	if ( EnemyBuffs_UserBuffs ) and ( type(EnemyBuffs_UserBuffs) == "table" ) then
		for k, v in EnemyBuffs_UserBuffs do
			EnemyBuffs_BuffMap[k] = v;
		end
	end
end

function EnemyBuffs_PrepareForGFind()
	for event, list in EnemyBuffs_ChatMessages do
		for key, value in list do
			if ( not value.pattern ) and ( value.msg ) then
				value.pattern = EnemySpellDetector_GlobalStringTogfind(getglobal(value.msg));
				if ( EnemySpellDetector_OptimizeMemory ) then
					value.msg = nil;
				end
			end
		end
	end
end

function EnemyBuffs_HandleEvent(event, msg)
	local value = EnemyBuffs_ChatMessages[event];
	if ( table.getn(value) <= 0 ) then
		return;
	end
	local performer = nil;
	local action = nil;
	local target = nil;

	for key, template in value do
		if ( template.pattern ) then
			for a1, a2, a3, a4, a5, a6, a7, a8, a9 in string.gfind(msg, template.pattern) do
				function getIndex(i) if ( not i ) then return nil; elseif (i == 1) then return a1; elseif (i == 2) then return a2; elseif (i == 3) then return a3; elseif (i == 4) then return a4; elseif (i == 5) then return a5; elseif (i == 6) then return a6; elseif (i == 7) then return a7; elseif (i == 8) then return a8; elseif (i == 9) then return a9; else return nil; end end
				if ( template.type == "death" ) then
					if ( performer ) and ( EnemyBuffs_Buffs[performer] ) then
						EnemyBuffs_Buffs[performer] = {};
						if ( UnitName("target") == performer ) then
							EnemyBuffs_ResetBuffs();
						end
					end
					return;
				else
					performer = getIndex(template.performerIndex);
					action = getIndex(template.actionIndex);
					target = getIndex(template.targetIndex);
					return EnemyBuffs_RemoveBuff(template.type, performer, action, target);
				end
			end
		end
	end
end

function EnemyBuffs_RemoveBuff(type, performer, action, target)
	local name = target;
	if ( not name ) then
		name = performer;
	end
	if ( not name ) then
		return false;
	end
	local foundPos = nil;
	local shouldNotify = false;
	if ( EnemyBuffs_Buffs[name] ) then
		for k, v in EnemyBuffs_Buffs[name] do
			if ( v == action ) then
				foundPos = k;
				break;
			end
		end
		if ( foundPos ) then
			table.remove(EnemyBuffs_Buffs[name], foundPos);
			shouldNotify = true;
		end
	end
	if ( name == UnitName("target") ) then
		for k, v in EnemyBuffs_TargetBuffs do
			if ( v == action ) then
				foundPos = k;
				break;
			end
		end
		if ( foundPos ) then
			table.remove(EnemyBuffs_TargetBuffs, foundPos);
			table.remove(EnemyBuffs_TargetBuffTextures, foundPos);
			shouldNotify = true;
		end
	end
	if ( shouldNotify ) then
		EnemyBuffs_BuffsRemoved(action, name);
	end
	return true;
end

function EnemyBuffs_AddBuff(performer, action, target)
	if ( not EnemyBuffs_Options.enabled ) then
		return;
	end
	local name = target;
	if ( not name ) then
		name = performer;
	end
	if ( not name ) then
		return false;
	end
	local texture = EnemyBuffs_BuffMap[action];
	if ( texture == nil ) and ( EnemyBuffs_Options.useTempIconForUnknownBuffs ) then
		texture = EnemyBuffs_Options.tempIconForUnknownBuffs;
	end
	if ( not texture ) then
		return;
	end
	if ( type(texture) == "table" ) then
		texture = texture.t;
		if ( not texture ) then
			return;
		end
	end
	if ( not EnemyBuffs_Buffs[name] ) then
		EnemyBuffs_Buffs[name] = {};
	else
		for k, v in EnemyBuffs_Buffs[name] do
			if ( v == action ) then
				EnemyBuffs_BuffsAdded(action);
				return;
			end
		end
	end
	table.insert(EnemyBuffs_Buffs[name], action);
	if ( name == UnitName("target") ) then
		table.insert(EnemyBuffs_TargetBuffs, action);
		table.insert(EnemyBuffs_TargetBuffTextures, texture);
	end
	EnemyBuffs_BuffsAdded(action, name);
end

-- feel free to hook me! :)
function EnemyBuffs_BuffsAdded(buffName, target)
	if ( EnemyBuffs_Options.targetPatch ) then
		TargetDebuffButton_Update();
	end
end

-- feel free to hook me! :)
function EnemyBuffs_TargetChanged()
	EnemyBuffs_ResetBuffs();
	EnemyBuffs_SetupDefaultBuffsForTarget();
	if ( EnemyBuffs_Options.targetPatch ) then
		TargetDebuffButton_Update();
	end
end

-- feel free to hook me! :)
function EnemyBuffs_BuffsRemoved(buffName, target)
	if ( EnemyBuffs_Options.targetPatch ) then
		TargetDebuffButton_Update();
	end
end


function EnemyBuffs_SetupDefaultBuffsForTarget()
	if ( not EnemyBuffs_Options.useDefaultBuffs ) then
		return;
	end
	if ( not EnemyBuffs_IsEnemyUnit("target") ) then
		return;
	end
	if ( UnitIsDeadOrGhost("target") ) then
		return;
	end
	local name = UnitName("target");
	if ( name ) then
		local defaultList = EnemyBuffs_DefaultBuffs[name];
		if ( defaultList ) then
			for k, v in defaultList do
				EnemyBuffs_AddBuff(name, v);
			end
		end
	end
end