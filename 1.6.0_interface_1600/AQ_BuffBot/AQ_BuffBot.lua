AQBUFFBOT_FISHING_POLE_TEXTURES = {
	"Interface\\Icons\\INV_Fishingpole_01",
	"Interface\\Icons\\INV_Fishingpole_02",
};

AQ_BUFFBOT_MAINHAND_SLOT = 16;
AQ_BuffBot_EmptyTable = {};
-- moved BuffBot specific code to seperate lua file

-- This table contains information about buff AddOns. 
AQ_BuffBot_SetupBuffAddOn_List = {
};

AQ_BuffBot_LinkTypeFunctionIndex = {
	buff = "buffFuncName";
	cure = "cureFuncName";
};


-- default options
AQ_BuffBot_Options_Default = {
	enabled = true;
	buffFuncName = "BuffBot_JustBuff";
	cureFuncName = "BuffBot_JustCure";
	links = {
		--[[
			allowed fields:
			health - decimal value, amount of current health that is required to trigger
			mana - decimal value, amount of current mana that is required to trigger
			healthPercentage - decimal value, percentage of total health that is required to trigger
			manaPercentage - decimal value, percentage of total mana that is required to trigger
			notInCombat - boolean, if true will not be triggered in combat
			onlyInCombat - boolean, if true will only be triggered in combat
			applyOncePerPartyMember - boolean, if true will execute funcName once per entry in AQ_BuffBot_applyOncePerPartyMemberList, with the entry as parameter
			iterativeParameters - will cause funcName to be called once per every table in it until it returns true
			default is simply to call function 
		]]--
		[1] = {
			linkType = "cure";
			manaPercentage = 5;
			healthPercentage = 10;
			applyOncePerPartyMember = false;
			onlySelf = false;
			notInCombat = false;
		},
		[2] = {
			linkType = "buff";
			manaPercentage = 10;
			healthPercentage = 15;
			applyOncePerPartyMember = false;
			onlySelf = false;
			notInCombat = true;
		},
	};
	applyOncePerPartyMemberRoundRobin = true;
	preventBuffingWhileFishing = false;
	preventBuffingWhileResting = true;
	doSelfCure = true;
	doSelfBuff = true;
	selfBuff = {
		notInCombat = false;
	};
	selfCure = {
		notInCombat = false;
	};
};

AQ_BuffBot_Options = {};

AQ_BuffBot_applyOncePerPartyMemberList = {
	"pet",
	"party1",
	"party2",
	"party3",
	"party4"
};

function AQ_BuffBot_SetNewState(enabled)
	local isQueued = ActionQueue_IsQueued(AQBUFFBOT_ID);
	if ( enabled ) then
		if ( not isQueued ) then
			ActionQueue_QueueSpellAdvanced(AQ_BuffBot_Entry);
		end
	end
	AQ_BuffBot_Options.enabled = enabled;
end

function AQ_BuffBot_ActionQueueShouldBeRemovedCallback(entry)
	if ( AQ_BuffBot_Options.checkClassAbleToBuffFunc ) then
		local class = UnitClass("player");
		if ( class ) and ( class ~= UKNOWNBEING ) and ( class ~= UNKNOWN ) and ( class ~= UNKNOWNOBJECT ) then
			local func = getglobal(AQ_BuffBot_Options.checkClassAbleToBuffFunc);
			if ( not func(class) ) then
				return true;
			end
		end
	end
	if ( AQ_BuffBot_Options.enabled ) then
		return false;
	else
		return true;
	end
end

function AQ_BuffBot_ExecuteFunction_Rebuff(unit)
	local list = Rebuff_Problem_Units[unit];
	if ( list ) then
		for k, v in list do
			if ( Rebuff_RebuffUnit(unit, v) ) then
				return true;
			end
		end
	end
	return false;
end

function AQ_BuffBot_UnitCanBeBuffed(unit)
	
	if ( not UnitExists(unit) ) then
		return false
	end
	
	if ( not UnitIsFriend("player", unit) ) then
		return false
	end
	
	if ( UnitIsEnemy(unit, 'player') ) then
		return false
	end
	
	if ( UnitCanAttack(unit, 'player') ) then
		return false
	end
	
	if ( UnitCanAttack('player', unit) ) then
		return false
	end
	
	if ( unit ~= 'player' ) and ( not UnitCanCooperate('player', unit) ) then
		return false
	end

	if ( UnitCanAttack("player", unit) ) then
		return false;
	end
	if ( not UnitIsConnected(unit) ) then
		return false
	end
	
	if ( UnitIsDeadOrGhost(unit) ) then
		return false
	end
	
	return true
	
end

function AQ_BuffBot_DoExecute(entry, link)
	local func = nil;
	if ( link.funcName ) then
		func = getglobal(link.funcName);
	end
	if ( not func ) and ( link.linkType ) then
		local index = AQ_BuffBot_LinkTypeFunctionIndex[link.linkType];
		local funcName = AQ_BuffBot_Options[index];
		if ( funcName ) then
			func = getglobal(funcName);
		end
	end
	if ( func ) then
		if ( link.onlySelf ) then
			if ( func("player") ) then
				return true;
			end
		else
			if ( link.applyOncePerPartyMember ) then
				local key = nil;
				local unit = nil;
				local value = nil;
				local didIt = false;
				for key, value in AQ_BuffBot_applyOncePerPartyMemberList do
					if ( type(value) == "table" ) then
						unit = value[1];
					else
						unit = value;
					end
					if ( AQ_BuffBot_UnitCanBeBuffed(unit) ) then
						if ( ActionQueue_IsInRange(unit) ) then
							if ( type(value) == "table" ) then
								if ( func(unpack(value)) ) then
									didIt = true;
									break;
								end
							else
								if ( func(value) ) then
									didIt = true;
									break;
								end
							end
						end
					end
				end
				if ( didIt ) then
					if ( AQ_BuffBot_Options.applyOncePerPartyMemberRoundRobin ) then
						local last = table.getn(AQ_BuffBot_applyOncePerPartyMemberList);
						if ( last ~= key ) then
							AQ_BuffBot_applyOncePerPartyMemberList[key] = AQ_BuffBot_applyOncePerPartyMemberList[last];
							AQ_BuffBot_applyOncePerPartyMemberList[last] = value;
						end
					end
					return true;
				end
				return false;
			end
			if ( not link.iterativeParameters ) or ( table.getn(link.iterativeParameters) <= 0 ) then
				args = link.args;
				if ( not args ) then args = AQ_BuffBot_EmptyTable; end
				if ( func(unpack(args)) ) then
					return true;
				end
			else
				for key, value in link.iterativeParameters do
					args = value;
					if ( not args ) then args = AQ_BuffBot_EmptyTable; end
					if ( func(unpack(args)) ) then
						return true;
					end
				end
			end
		end
	end
	return false;
end

function AQ_BuffBot_IsBuffSelfBuff(spell)
	for k, v in AQ_BuffBot_SelfBuffs do
		if ( v == spell ) then
			return true;
		end
	end
	return false;
end



function AQ_BuffBot_CureSelf()
	if ( not AQ_BuffBot_Options.selfCure.canIgnoreFriendlyTarget ) and ( not AQ_BuffBot_CanBuffWithTarget() ) then
		return false;
	end
	if ( AQ_BuffBot_Options.selfCure.notInCombat ) and ( PlayerFrame.inCombat ) then
		return false;
	end
	local state = false;
	local name = AQ_BuffBot_Options.selfCureFuncName;
	if ( not name ) or ( not getglobal(name) ) then
		name = AQ_BuffBot_Options.cureFuncName;
	end
	if ( name ) then
		local func = getglobal(name);
		if ( func ) then
			local arg = nil;
			if ( AQ_BuffBot_Options.selfCure.arg ) then
				arg = AQ_BuffBot_Options.selfBuff.arg;
			else
				arg = AQ_BuffBot_EmptyTable;
			end
			state = func(unpack(arg));
		end
	end
	return state;
end


function AQ_BuffBot_CanBuffWithTarget()
	if ( UnitExists("target") ) then
		if ( not UnitPlayerControlled("target") ) then
			local reaction = UnitReaction("target", "player");
			if ( reaction ) then
				if (reaction > 2) then
					return false;
				end
			else
				return false;
			end
		else
			if ( not UnitCanAttack("target", "player" ) ) then
				return false;
			end
		end
	end
	return true;
end

function AQ_BuffBot_BuffSelf()
	if ( not AQ_BuffBot_Options.selfBuff.canIgnoreFriendlyTarget ) and ( not AQ_BuffBot_CanBuffWithTarget() ) then
		return false;
	end
	if ( AQ_BuffBot_Options.selfBuff.notInCombat ) and ( PlayerFrame.inCombat ) then
		return false;
	end
	local state = false;
	local name = AQ_BuffBot_Options.selfBuffFuncName;
	if ( not name ) or ( not getglobal(name) ) then
		name = AQ_BuffBot_Options.buffFuncName;
	end
	if ( name ) then
		local func = getglobal(name);
		if ( func ) then
			local arg = nil;
			if ( AQ_BuffBot_Options.selfBuff.arg ) then
				arg = AQ_BuffBot_Options.selfBuff.arg;
			else
				arg = AQ_BuffBot_EmptyTable;
			end
			state = func(unpack(arg));
		end
	end
	return state;
end

function AQ_BuffBot_OldBuffSelf()
	local _class = UnitClass("player");
	local buffs = BuffBot_Data.spell_predata[_class];
	if ( not buffs ) then
		return false;
	end
	local selfBuffs = buffs['Self Buffs'];
	if ( not selfBuffs ) then
		return false;
	end
	local tmpBuff = nil;
	local lesserOf = nil;
	local Buff_Duration = nil;
	local Buff_Refresh  = nil;
	local Time_Since_Buff = nil;
	local buff_id = nil;
	local shouldContinue = true;
	for k, v in selfBuffs do
		shouldContinue = true;
		if ( v ~= 1 ) then
			shouldContinue = false;
		end
		if ( shouldContinue ) then
			tmpBuff = buffs[k];
			if ( not AQ_BuffBot_IsBuffSelfBuff(k) ) then
				shouldContinue = false;
			end
		end
		if ( shouldContinue ) then
			lesserOf = buffs[k]['Lesser of'];
			if ( lesserOf ) then
				buff_id = Spell_ID_By_Level(lesserOf,UnitLevel("player"));
				if ( buff_id ) then
					shouldContinue = false;
				end
			end
		end
		if ( shouldContinue ) then
			local shouldBuff = false;
			if ( not Find_Buff(buff, "player") ) then
				shouldBuff = true;
			else
				Time_Since_Buff = GetTime() - buffs_cast["player"][k];
				Buff_Duration = buffs[k]['Duration'];
				Buff_Refresh  = buffs[k]['Refresh'];
				if (Buff_Duration - Time_Since_Buff < Buff_Refresh  ) then
					shouldBuff = true;
				end
			end
			if ( shouldBuff ) then
				buff_id = Spell_ID_By_Level(k,UnitLevel("player"));
				if ( buff_id ) then
					CastSpell(buff_id, SpellBookFrame.bookType);
					Casting_Buff = true
					Casting_Buff_Unit = "player";
					Casting_Buff_Buff = k;
					return true;
				end
			end
		end
	end
	-- handle weapon buffs
	if buffs['Weapon Buffs'] then
		for buff,data in buffs['Weapon Buffs'] do
			if Apply_Buff("player",buff) then return true end
		end
	end
	return false;
end

AQ_BuffBot_ActionQueueCallback_AllowedUnits = {
	"player",
	"pet"
};

function AQ_BuffBot_GenerateAllowedUnits()
	for i = 1, 4 do
		table.insert(AQ_BuffBot_ActionQueueCallback_AllowedUnits, "party"..i);
	end
	for i = 1, 40 do
		--table.insert(AQ_BuffBot_ActionQueueCallback_AllowedUnits, "raid"..i);
	end
end

AQ_BuffBot_ActionQueueCallback_ItemTexture = nil;

function AQ_BuffBot_ActionQueueCallback(entry)
	if ( not AQ_BuffBot_Options.enabled ) then
		return false;
	end
	ActionQueue_QueueSpellAdvanced(AQ_BuffBot_Entry);
	if ( ActionQueue_IsAnySpellRunning() ) then
		return false;
	end
	if ( AQ_BuffBot_Options.preventBuffingWhileResting ) then
		if ( IsResting() ) and ( not UnitIsPVPFreeForAll("player") ) and ( not UnitIsPVP("player") ) and ( not PlayerFrame.inCombat ) then
			return false;
		end
	end
	if ( AQ_BuffBot_Options.preventBuffingWhileFishing ) then
		AQ_BuffBot_ActionQueueCallback_ItemTexture = GetInventoryItemTexture("player", AQ_BUFFBOT_MAINHAND_SLOT);
		local texture = AQ_BuffBot_ActionQueueCallback_ItemTexture;
		if ( texture ) then
			for k, v in AQBUFFBOT_FISHING_POLE_TEXTURES do
				if ( v == texture ) then
					return false;
				end
			end
		end
	end
	if ( ActionQueue_IsGlobalSpellCooldown() ) then
		return false;
	end
	if ( ActionQueue_IsShadowmelded() ) then
		return false;
	end
	if ( ActionQueue_IsShapeshifter() ) then
		if ( ActionQueue_Shapeshifted ) then
			return false;
		end
		if ( ActionQueue_LastShapeshifted ) and ( curTime - ActionQueue_LastShapeshifted < ACTIONQUEUE_SHAPESHIFT_INHIBIT_TIME ) then
			return false;
		else
			ActionQueue_LastShapeshifted = nil;
		end
	end
	if ( ActionQueue_IsMounted() ) or ( UnitOnTaxi("player") ) then
		return false;
	end
	local name = AQ_BuffBot_Options.buffFuncName;
	if ( not name ) then
		return false;
	end
	local func = getglobal(name);
	if ( not func ) then
		return false;
	end
	if ( AQ_BuffBot_Options.doSelfCure ) then
		if ( AQ_BuffBot_CureSelf() ) then
			return true;
		end
	end
	if ( AQ_BuffBot_Options.doSelfBuff ) then
		if ( AQ_BuffBot_BuffSelf() ) then
			return true;
		end
	end
	if( not AQ_BuffBot_CanBuffWithTarget() ) then
		return false;
	end
	if ( UnitExists("target") ) then
		if ( UnitCanCooperate("player", "target") ) then
			return false;
		end
		if ( not UnitCanAttack("player", "target") ) then
			return false;
		end
		if ( not UnitCanAttack("target", "player") ) then
			return false;
		end
		if ( UnitIsFriend("player", "target") ) then
			return false
		end
		if ( not UnitIsEnemy("player", "target") ) then
			return false
		end
	end
	local playerHealth = UnitHealth("player");
	local playerHealthPercentage = (UnitHealth("player")/UnitHealthMax("player"))*100;
	local playerMana = UnitMana("player");
	local playerManaPercentage = (UnitMana("player")/UnitManaMax("player"))*100;
	local executeFunc = false;
	local isInCombat = false;
	if ( PlayerFrame.inCombat ) then
		isInCombat = true;
	end
	for k, v in AQ_BuffBot_Options.links do
		executeFunc = true;
		if ( v.notInCombat ) and ( isInCombat ) then
			executeFunc = false;
		end
		if ( v.onlyInCombat ) and ( not isInCombat ) then
			executeFunc = false;
		end
		if ( v.health ) and ( playerHealth < v.health ) then
			executeFunc = false;
		end
		if ( v.healthPercentage ) and ( playerHealthPercentage < v.healthPercentage ) then
			executeFunc = false;
		end
		if ( v.mana ) and ( playerMana < v.mana ) then
			executeFunc = false;
		end
		if ( v.manaPercentage ) and ( playerManaPercentage < v.manaPercentage ) then
			executeFunc = false;
		end
		if ( executeFunc ) then
			if ( AQ_BuffBot_DoExecute(entry, v) ) then
				return true;
			end
		end
	end
	return false;
end

AQ_BuffBot_Entry = {
	["id"] = AQBUFFBOT_ID,
	["name"] = AQBUFFBOT_NAME,
	["shouldBeRemovedFunc"] = AQ_BuffBot_ActionQueueShouldBeRemovedCallback,
	["shouldExecuteFunc"] = ActionQueue_ShouldExecuteFunction_ASAP,
	["executeFunc"] = AQ_BuffBot_ActionQueueCallback,
	["priority"] = ACTIONQUEUE_LOWEST_PRIORITY,
};

function AQ_BuffBot_OnLoad()
	AQ_BuffBot_GenerateAllowedUnits();
	ActionQueue_QueueSpellAdvanced(AQ_BuffBot_Entry);
	
	local f = AQ_BuffBotFrame;
	--f:RegisterEvent("ZONE_CHANGED");
	f:RegisterEvent("VARIABLES_LOADED");
	
	if ( not AQ_BuffBot_SetupBuffAddOn() ) then
		ChatFrame1:AddMessage(AQBUFFBOT_NO_BUFF_ADDON, 1, 0, 0);
		local buffAddOnNames = "";
		local first = true;
		for k, v in AQ_BuffBot_SetupBuffAddOn_List do
			if( not first ) then
				buffAddOnNames = buffAddOnNames..", "..k;
			else
				buffAddOnNames = k;
				first = false;
			end
		end
		ChatFrame1:AddMessage(buffAddOnNames, 1, 0, 0);
	end
end

function AQ_BuffBot_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		AQ_BuffBotFrame:UnregisterEvent(event);
		AQ_BuffBot_SetupOptions();
	end
end

function AQ_BuffBot_SetupBuffAddOn()
	for k, v in AQ_BuffBot_SetupBuffAddOn_List do
		if ( getglobal(v.detectionName) ) then
			AQ_BuffBot_Options.currentBuffAddon = k;
			for key, value in v do
				if ( type(value) == "table" ) and ( AQ_BuffBot_Options[key] ) and ( type(AQ_BuffBot_Options[key]) == "table" ) then
					local innerTmp = AQ_BuffBot_Options[key];
					for innerKey, innerValue in value do
						if ( innerTmp[innerKey] == nil ) then
							innerTmp[innerKey] = innerValue;
						end
					end
					AQ_BuffBot_Options[key] = innerTmp;
				else
					AQ_BuffBot_Options[key] = value;
				end
			end
			return true;
		end
	end
	return false;
end



function AQ_BuffBot_SetupOptions()
	local tmp = nil;
	for k, v in AQ_BuffBot_Options_Default do
		tmp = AQ_BuffBot_Options[k];
		if ( tmp == nil ) then
			AQ_BuffBot_Options[k] = v;
		else
			if ( type(v) == "table" ) then
				if ( type(tmp) ~= "table" ) then
					tmp = AQ_BuffBot_EmptyTable;
				end
				for key, value in v do
					if ( tmp[key] == nil ) then
						tmp[key] = value;
					end
				end
				AQ_BuffBot_Options[k] = tmp;
			end
		end
	end
end