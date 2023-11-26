ACTIONQUEUE_SHAPESHIFT_ICONS		= {
	"Interface\\Icons\\Ability_Druid_CatForm",
	"Interface\\Icons\\Ability_Druid_TravelForm",
	"Interface\\Icons\\Ability_Racial_BearForm",
	"Interface\\Icons\\Ability_Druid_AquaticForm",
	"Interface\\Icons\\Spell_Nature_SpiritWolf",
};

ACTIONQUEUE_CLASS_SHAPESHIFTERS		= {
	ACTIONQUEUE_CLASS_DRUID,
	ACTIONQUEUE_CLASS_SHAMAN,
};

ACTIONQUEUE_STEALTH_TEXTURE			= "Interface\\Icons\\Ability_Stealth";
ACTIONQUEUE_SHADOWMELD_TEXTURE		= "Interface\\Icons\\Ability_Ambush";


ActionQueue_RegularSpellRunning = false;
ActionQueue_ChannelSpellRunningStarted = 0;
ActionQueue_ChannelSpellRunning = false;
ActionQueue_RegularSpellRunningStarted = 0;
ActionQueue_TimeSpellStopped = 0;

-- Returns the spell id or nil .
function ActionQueue_FindSpellId(spellName, spellRank, spellBook, startId)
	if ( not startId ) then
		startId = 1;
	end
	if ( not spellBook ) then
		spellBook = "spell";
	end
	if ( DynamicData ) and ( DynamicData.spell ) and ( DynamicData.spell.getMatchingSpellId ) then
		return DynamicData.spell.getMatchingSpellId(spellName, spellRank, spellBook, nil, startId);
	end
	spellName = string.lower(spellName);
	if ( spellRank ) then
		spellRank = string.lower(spellRank);
	end
	local ok = true;
	local name, rank;
	local i = startId;
	local tmp = nil;
	local highestId = nil;
	while ( ok ) do
		name, rank = GetSpellName(i, spellBook);
		if ( not name ) then
			break;
		end
		name = string.lower(name);
		if ( name == spellName ) then
			if ( spellRank ) then
				if ( rank ) then
					rank = string.lower(rank);
					if ( rank == spellRank ) then
						return i;
					end
				end
			else
				highestId = i;
			end	
		end
		i = i + 1;
	end
	return highestId;
end

function ActionQueue_GetHighestSpellRankId(spellName, spellBook, startId)
	local id = ActionQueue_FindSpellId(spellName, nil, spellBook, startId);
	if ( not id ) then
		return nil;
	end
	spellName = string.lower(spellName);
	local ok = true;
	local name, rank;
	local i = id+1;
	local tmp = nil;
	local highestId = id;
	while ( ok ) do
		name, rank = GetSpellName(i, spellBook);
		if ( not name ) then
			break;
		end
		if ( name ~= spellName ) then
			break;
		else
			highestId = i;
		end
		i = i + 1;
	end
	return highestId;
end

-- credits to the idea of this function
-- determines whether the global spell cooldown is in effect
-- optimized to not cause loads of spell id queries but will detect shifts in the balance of the force when they occur
function ActionQueue_IsGlobalSpellCooldown()
	local spellBook = "spell";
	local spellName = nil;
	if ( ActionQueue_GlobalSpellCooldown_Id ) then
		spellName = GetSpellName(ActionQueue_GlobalSpellCooldown_Id, spellBook);
		if ( ( not spellName ) or ( not ActionQueue_GlobalSpellCooldown_Name ) ) or ( spellName ~= ActionQueue_GlobalSpellCooldown_Name ) then
			ActionQueue_GlobalSpellCooldown_Id = nil;
		end
	end
	if ( not ActionQueue_GlobalSpellCooldown_Id ) then
		local index = UnitClass("player");
		if ( not index ) then
			return false;
		end
		spellName = ACTIONQUEUE_GLOBALSPELLCOOLDOWN_MAP[index];
		if ( not spellName ) then
			return false;
		end
		ActionQueue_GlobalSpellCooldown_Id = ActionQueue_FindSpellId(spellName);
		if ( not ActionQueue_GlobalSpellCooldown_Id ) then
			return false;
		end
		ActionQueue_GlobalSpellCooldown_Name = spellName;
	end
	if ( GetSpellCooldown(ActionQueue_GlobalSpellCooldown_Id, spellBook) > 0 ) then
		return true;
	else
		return false;
	end
end



function ActionQueue_IsSomeSpellRunning(name, maxTime)
	if ( not maxTime ) then
		maxTime = 15;
	end
	local boolName = format("ActionQueue_%sSpellRunning", name);
	local startedName = format("ActionQueue_%sSpellRunningStarted", name);
	local boolValue = getglobal(boolName);
	local startedValue = getglobal(startedName);
	if ( boolValue == true ) then
		local curTime = GetTime();
		if ( ( startedValue + 15 ) < curTime ) then
			boolValue = false;
			setglobal(boolName, false);
		end
	end
	return boolValue;
end

function ActionQueue_IsChannelSpellRunning()
	return ActionQueue_IsSomeSpellRunning("Channel");
end

function ActionQueue_IsRegularSpellRunning()
	return ActionQueue_IsSomeSpellRunning("Regular");
end

function ActionQueue_IsAnySpellRunning()
	if ( ActionQueue_IsSomeSpellRunning("Channel") ) then
		return true;
	elseif ( ActionQueue_IsSomeSpellRunning("Regular") ) then
		return true;
	else
		return false;
	end
end

function ActionQueueUtil_OnLoad()
	local f = ActionQueueUtilFrame;
	f:RegisterEvent("PLAYER_DEAD");
	f:RegisterEvent("SPELLCAST_STOP");
	f:RegisterEvent("SPELLCAST_START");
	f:RegisterEvent("SPELLCAST_CHANNEL_START");
	f:RegisterEvent("SPELLCAST_INTERRUPTED");
	f:RegisterEvent("SPELLCAST_FAILED");
end

function ActionQueueUtil_OnEvent(event)
	if ( event == "PLAYER_DEAD" ) then
		ActionQueue_ChannelSpellRunning = false;
		ActionQueue_ChannelSpellRunningStarted = 0;
		ActionQueue_RegularSpellRunning = false;
		ActionQueue_TimeSpellStopped = GetTime();
	end
	if ( event == "SPELLCAST_STOP" ) then
		ActionQueue_ChannelSpellRunning = false;
		ActionQueue_ChannelSpellRunningStarted = 0;
		ActionQueue_RegularSpellRunning = false;
		ActionQueue_RegularSpellRunningStarted = 0;
		ActionQueue_TimeSpellStopped = GetTime();	
	end
	if ( event == "SPELLCAST_START" ) then
		ActionQueue_RegularSpellRunning = true;	
		ActionQueue_RegularSpellRunningStarted = GetTime();
	end
	if ( event == "SPELLCAST_CHANNEL_START") then
		ActionQueue_ChannelSpellRunning = true;
		ActionQueue_ChannelSpellRunningStarted = GetTime();
	end
	if ( event == "SPELLCAST_INTERRUPTED" ) or ( event == "SPELLCAST_FAILED" ) then
		ActionQueue_RegularSpellRunning = false;
		ActionQueue_RegularSpellRunningStarted = 0;
		ActionQueue_ChannelSpellRunning = false;	
		ActionQueue_ChannelSpellRunningStarted = 0;
	end	
end

ActionQueue_GlobalStringTranslated = {
};

ActionQueue_GlobalStringTranslations = {
	["%%s"] = "%(%.+%)",
	["%%d"] = "%(%%d%)",
};
function ActionQueue_GlobalStringTogfind(str)
	if ( not str ) then
		return nil;
	end
	if ( ActionQueue_GlobalStringTranslated[str] ) then
		return ActionQueue_GlobalStringTranslated[str];
	end
	local retStr = str;
	for k, v in ActionQueue_GlobalStringTranslations do
		retStr = string.gsub(retStr, k, v);
	end
	ActionQueue_GlobalStringTranslated[str] = retStr;
	return retStr;
end

ActionQueue_ShowMessageDefaultParams = {
	r = 1.0,
	g = 0.2,
	b = 0.2,
	sound = "MapPing",
};

ActionQueue_ShowMessageParams = {
};

function ActionQueue_ShowMessage(msg, r, g, b, extraParams)
	local oldMsg = ActionQueueMessageFrameText:GetText();
	if ( oldMsg ) and ( oldMsg == msg ) and ( ActionQueueMessageFrame:IsVisible() ) then
		return;
	end
	local params = ActionQueue_ShowMessageParams;
	for k, v in ActionQueue_ShowMessageDefaultParams do
		params[k] = v;
	end
	if ( r ) and ( type(r) == "table" ) and ( not extraParams ) then
		extraParams = r;
		r = nil;
	end
	if ( r ) and ( g ) and ( b ) then
		params.r = r;
		params.g = g;
		params.b = b;
	end
	if ( extraParams ) then
		for k, v in extraParams do
			params[k] = v;
		end
	end
	ActionQueueMessageFrameText:SetTextColor(params.r, params.g, params.b);
	ActionQueueMessageFrameText:SetText(msg);
    ActionQueueMessageFrame.startTime = GetTime();
	PlaySound(params.sound);
    ActionQueueMessageFrame:Show();
end

ActionQueue_IsShapeshifter_Value = nil;

function ActionQueue_IsShapeshifter()
	if ( ActionQueue_IsShapeshifter_Value ~= nil ) then
		return ActionQueue_IsShapeshifter_Value;
	end
	ActionQueue_IsShapeshifter_Value = ActionQueue_IsUnitShapeshifter("player");
	return ActionQueue_IsShapeshifter_Value;
end

function ActionQueue_IsUnitShapeshifter(unit)
	local class = UnitClass(unit);
	if ( not class ) or ( class == UKNOWNBEING ) or ( class == UNKNOWN ) or ( class == UNKNOWNOBJECT ) then
		return nil;
	end
	for k, v in ACTIONQUEUE_CLASS_SHAPESHIFTERS do
		if ( v == class ) then
			return true;
		end
	end
	return false;
end



function ActionQueue_IsShapeshifted_BlizzardFunction()
	local numForms = GetNumShapeshiftForms();
	local texture, name, isActive, isCastable;
	
	for i = 1, numForms do
		texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
		if ( isActive ) then
			return true;
		end
	end
	return false;
end


ActionQueue_IsShapeshifted_Effects_List = {};

function ActionQueue_IsShapeshifted_Effects()
	local list = ActionQueue_IsShapeshifted_Effects_List;
	for i = 0, 15 do
		list[i] = GetPlayerBuffTexture(i);
	end
	for k, v in ACTIONQUEUE_SHAPESHIFT_ICONS do
		for key, effect in list do
			if ( effect == v ) then
				return true;
			end
		end
	end
	return false;
end

ActionQueue_IsShapeshifted = ActionQueue_IsShapeshifted_Effects;

function ActionQueue_GetBuffTextureIndex(buffTexture)
	local texture = nil;
	for i = 0, 15 do
		texture = GetPlayerBuffTexture(i);
		if ( texture ) then
			if ( texture == buffTexture ) then
				return i;
			end
		end
	end
	return nil;
end

function ActionQueue_GetBuffPosition(pTexture, pName)
	if ( not pTexture ) and ( not pName ) then
		return nil;
	end
	local name = nil;
	local texture = nil;
	for i = 0, 15 do
		texture = GetPlayerBuffTexture(i);
		if ( texture ) then
			if ( not pTexture ) or ( texture == pTexture ) then
				if ( pName ) then
					ActionQueue_protectTooltipMoney();
					ActionQueueTooltip:SetPlayerBuff(i);
					ActionQueue_unprotectTooltipMoney();
					name = ActionQueueTooltipTextLeft1:GetText();
					if ( name ) and ( name == pName ) then
						return i;
					end
				else
					return i;
				end
			end
		end
	end
	return nil;
end

function ActionQueue_IsShadowmelded()
	if ( ActionQueue_GetBuffTextureIndex(ACTIONQUEUE_SHADOWMELD_TEXTURE) ) then
		return true;
	else
		return false;
	end
end

function ActionQueue_IsStealthed()
	if ( ActionQueue_GetBuffTextureIndex(ACTIONQUEUE_STEALTH_TEXTURE) ) then
		return true;
	else
		return false;
	end
end


ActionQueue_AutoMount_Mount_List={
"Spell_Nature_Swiftness",
"Ability_Mount",
"INV_Misc_Foot_Kodo",
}
function ActionQueue_AutoMount_GetMountBuffPosition()
	for i = 0, 15 do
		if not AutoMount_Texture then
			for k, v in ActionQueue_AutoMount_Mount_List do
				if GetPlayerBuffTexture(i) ~= nil then
					if (string.find(GetPlayerBuffTexture(i),v)) then
						AutoMount_Texture = GetPlayerBuffTexture(i);
						return i;
					end
				end
			end
		else
			if GetPlayerBuffTexture(i) == AutoMount_Texture then
				return i;
			end
		end
	end
	return -1;
end

function ActionQueue_IsMounted()
	if ( ActionQueue_AutoMount_GetMountBuffPosition() > -1 ) then
		return true;
	else
		return false;
	end
end

-- Stolen from Sea

ActionQueue_protectTooltipMoney = function()
	if ( not ActionQueue_Saved_GameTooltip_ClearMoney ) then
		ActionQueue_Saved_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = ActionQueue_doNothingTooltipMoney;
	end
end;

ActionQueue_unprotectTooltipMoney = function()
	if ( ActionQueue_Saved_GameTooltip_ClearMoney ) then
		GameTooltip_ClearMoney = ActionQueue_Saved_GameTooltip_ClearMoney;
		ActionQueue_Saved_GameTooltip_ClearMoney = nil;
	end
end;
	
ActionQueue_doNothingTooltipMoney = function()
end;
	
ActionQueue_Saved_GameTooltip_ClearMoney = nil;
