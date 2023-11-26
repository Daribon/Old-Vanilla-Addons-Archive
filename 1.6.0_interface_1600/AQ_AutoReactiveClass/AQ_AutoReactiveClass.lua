-- CONSTANTS START

AUTOREACTIVECLASS_ACTIONQUEUE_ID = "AutoReactiveClass";
AUTOREACTIVECLASS_ACTIONQUEUE_INTERRUPT_ID = "AutoReactive Interrupt";

-- CONSTANTS END

-- SETTINGS START

-- how often it should check if a spell is usable (in seconds)
-- this could be subject to adjustment
AutoReactiveClass_UpdateDelay = 1;

-- SETTINGS END

-- VARIABLES START

AQ_AutoReactiveClass_Options_Default = {
	enabled = true;
	showMessage = true;
	showActionMessage = true;
	queueAction = true;
	shouldInterrupt = true;
	useHighestEarthShockAlways = false;
	useHighestEarthShockWhenClearcastingActive = true;
	doNotInterruptIfLowerLevel = 20;
};

AQ_AutoReactiveClass_Options = {
};

AutoReactiveClass_LastUpdate = 0;
AutoReactiveClass_LastId = nil;

-- SETTINGS END


-- FUNCTIONS START

-- entry to add to the ActionQueue. Prepared with some concern.
AutoReactiveClass_Queue_Entry = {
	id = AUTOREACTIVECLASS_ACTIONQUEUE_ID;
	spellId = nil; -- not known until we first try to cast it
	shouldExecuteFunc = ActionQueue_ShouldExecuteFunction_ASAP;
	executeFunc = ActionQueue_ExecuteFunction_Spell;
	name = AUTOREACTIVECLASS_ACTIONQUEUE_ID;
};

-- entry to add to the ActionQueue. Prepared with some concern.
AutoReactiveClass_Queue_Interrupt_Entry = {
	id = AUTOREACTIVECLASS_ACTIONQUEUE_INTERRUPT_ID;
	spellId = nil; -- not known until we first try to cast it
	shouldExecuteFunc = ActionQueue_ShouldExecuteFunction_SpellCooldown;
	executeFunc = ActionQueue_ExecuteFunction_Spell;
	priority = ACTIONQUEUE_HIGHEST_PRIORITY;
	name = AUTOREACTIVECLASS_ACTIONQUEUE_INTERRUPT_ID;
};


function AQ_AutoReactiveClass_OnLoad()
	if ( not AQ_AutoReactiveClass_Khaos() ) then
		AQ_AutoReactiveClass_Cosmos();
	end
	-- make sure we get to know when the client variables are all loaded in and pretty
	local frame = AQ_AutoReactiveClassFrame;
	frame:RegisterEvent("VARIABLES_LOADED");
	frame:RegisterEvent("SPELLS_CHANGED");
	frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	
	
	if ( EnemySpellDetector_AddListener ) then
		EnemySpellDetector_AddListener(EnemySpellDetector_Type_BeginCast, "AQ_AutoReactiveClass_HandleBeginAction_Cast");
		EnemySpellDetector_AddListener(EnemySpellDetector_Type_BeginPerform, "AQ_AutoReactiveClass_HandleBeginAction");
	end
end

function AQ_AutoReactiveClass_HandleBeginAction_Cast(performer, action, target, p1, p2, p3, p4, p5)
	return AQ_AutoReactiveClass_HandleBeginAction(performer, action, target, "cast", p1, p2, p3, p4, p5);
end

function AQ_AutoReactiveClass_HandleBeginAction_Perform(performer, action, target, p1, p2, p3, p4, p5)
	return AQ_AutoReactiveClass_HandleBeginAction(performer, action, target, "perform", p1, p2, p3, p4, p5);
end

function AQ_AutoReactiveClass_HandleBeginAction(performer, action, target, actionType, p1, p2, p3, p4, p5)
	if ( AQ_AutoReactiveClass_IsClass(AUTOREACTIVE_CLASS_ROGUE) ) then
		setglobal("AQ_AutoReactiveClass_HandleBeginAction", AQ_AutoReactiveClass_HandleBeginAction_Rogue);
	elseif ( AQ_AutoReactiveClass_IsClass(AUTOREACTIVE_CLASS_SHAMAN) ) then
		setglobal("AQ_AutoReactiveClass_HandleBeginAction", AQ_AutoReactiveClass_HandleBeginAction_Shaman);
	else
		--[[
		local class = UnitClass("player");
		if ( not class ) or ( class == UKNOWNBEING ) or ( class == UNKNOWN ) or ( class == UNKNOWNOBJECT ) then
			return false;
		else
			EnemySpellDetector_RemoveListener(EnemySpellDetector_Type_BeginCast, "AQ_AutoReactiveClass_HandleBeginAction_Cast");
			EnemySpellDetector_RemoveListener(EnemySpellDetector_Type_BeginPerform, "AQ_AutoReactiveClass_HandleBeginAction_Perform");
		end
		]]--
		--setglobal("AQ_AutoReactiveClass_HandleBeginAction", AQ_AutoReactiveClass_HandleBeginAction_ShowMessage);
		setglobal("AQ_AutoReactiveClass_HandleBeginAction", AQ_AutoReactiveClass_HandleBeginAction_Generic);
		
	end
	
	local func = getglobal("AQ_AutoReactiveClass_HandleBeginAction");
	if ( not arg ) then arg = {}; end
	return func(performer, action, target, actionType, p1, p2, p3, p4, p5);
end

function AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5)
	if ( not AQ_AutoReactiveClass_Options.showMessage ) then
		return;
	end
	if ( not AQ_AutoReactiveClass_Options.showActionMessage ) then
		return;
	end
	local msg = nil;
	local targetName = UnitName("target");
	if ( not targetName ) or ( strlen(targetName) <= 0 ) then
		return;
	end
	if ( ( performer ) and ( targetName == performer ) ) or ( ( target ) and ( targetName == target ) )  then
		if ( performer ) and ( action ) and ( target ) then
			if ( actionType == "perform" ) then
				msg = string.format(AUTOREACTIVECLASS_PERFORMED_BY_ON_FORMAT, performer, action, target);
			else
				msg = string.format(AUTOREACTIVECLASS_CAST_BY_ON_FORMAT, performer, action, target);
			end
		elseif ( performer ) and ( action ) then
			if ( actionType == "perform" ) then
				msg = string.format(AUTOREACTIVECLASS_PERFORMED_BY_FORMAT, performer, action);
			else
				msg = string.format(AUTOREACTIVECLASS_CAST_BY_FORMAT, performer, action);
			end
		elseif ( target ) and ( action ) then
			if ( actionType == "perform" ) then
				msg = string.format(AUTOREACTIVECLASS_INVOLVING_FORMAT, target, action);
			else
				msg = string.format(AUTOREACTIVECLASS_CAST_FORMAT, target, action);
			end
		end
		if ( msg ) then
			ActionQueue_ShowMessage(msg);
		end
	end
end

function AQ_AutoReactiveClass_HandleBeginAction_Generic(performer, action, target, actionType, p1, p2, p3, p4, p5)
	AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
end

function AQ_AutoReactiveClass_IsClass(classPlayer)
	local class = UnitClass("player");
	if ( not class ) or ( class == UKNOWNBEING ) or ( class == UNKNOWN ) or ( class == UNKNOWNOBJECT ) then
		return false;
	end
	if ( class == classPlayer ) then
		return true;
	else
		return false;
	end
end

AQ_AutoReactiveClass_Messages = {};

function AQ_AutoReactiveClass_GetMessage(spellName)
	if ( not spellName ) then
		return "";
	end
	local message = AQ_AutoReactiveClass_Messages[spellName];
	if ( not message ) then
		message = string.format(AUTOREACTIVECLASS_MESSAGE_FORMAT, spellName);
		AQ_AutoReactiveClass_Messages[spellName] = message;
	end
	return message;
end

function AQ_AutoReactiveClass_OnEvent(event)
	-- when client variables are loaded, start using Perception
	if ( event == "VARIABLES_LOADED" ) then
		local frame = AQ_AutoReactiveClassFrame;
		frame:UnregisterEvent(event);
		AQ_AutoReactiveClass_EnableUpdate();
		for k, v in AQ_AutoReactiveClass_Options_Default do
			if ( AQ_AutoReactiveClass_Options[k] == nil ) then
				AQ_AutoReactiveClass_Options[k] = v;
			end
		end
		return;
	end
	if ( event == "SPELLS_CHANGED" ) then
		AQ_AutoReactiveClass_EnableUpdate();
		return;
	end
	if ( event == "UPDATE_BONUS_ACTIONBAR" ) then
		if ( AQ_AutoReactiveClass_IsClass(AUTOREACTIVE_CLASS_WARRIOR) ) then
			-- re-enables autoreactive if it should've been disabled 
			-- (as it is if you switch to a stance without having the associated skill)
			AQ_AutoReactiveClass_EnableUpdate();
		end
		return;
	end
end

-- Enable AQ_AutoReactiveClass.
function AQ_AutoReactiveClass_EnableUpdate()
	-- show the frame to allow OnUpdates to occur
	local frame = AQ_AutoReactiveClassFrame;
	frame:Show();
end

-- Disable AQ_AutoReactiveClass.
function AQ_AutoReactiveClass_DisableUpdate()
	-- hide the frame to prevent OnUpdates from occurring (saving a few cycles)
	local frame = AQ_AutoReactiveClassFrame;
	frame:Hide();
end

function AutoReactiveClass_GetActiveStance()
	local numForms = GetNumShapeshiftForms();
	local texture, name, isActive, isCastable;
	for i=1, NUM_SHAPESHIFT_SLOTS do
		if ( i <= numForms ) then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			if ( isActive ) then
				return name;
			end
		end
	end
	return nil;
end

function AQ_AutoReactiveClass_IsActionIdMappedToSpellId(actionId, spellId, spellBook)
	if ( not spellBook ) then spellBook = "spell"; end
	local spellTexture = GetSpellTexture(spellId, spellBook);
	local actionTexture = GetActionTexture(actionId);
	if ( spellTexture ) and ( actionTexture ) then
		if ( spellTexture == actionTexture ) then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function AQ_AutoReactiveClass_RetrieveActionIdFromSpellId(spellId, spellBook)
	if ( not spellBook ) then spellBook = "spell"; end
	local spellTexture = GetSpellTexture(spellId, spellBook);
	if ( DynamicData ) and ( DynamicData.action ) and ( DynamicData.action.getSpellAsActionId ) then
		local name = AutoReactiveClass_GetReactiveSpellName();
		local id = DynamicData.action.getSpellAsActionId(name, nil, spellTexture);
		if ( id ) and ( id > 0 ) then
			return id;
		else
			return nil;
		end
	end
	local actionTexture;
	for id = 1, 120 do 
		actionTexture = GetActionTexture(id);
		if ( actionTexture == spellTexture ) then
			return id;
		end
	end
	return nil;
end

function AutoReactiveClass_GetReactiveSpellName()
	local class = UnitClass("player");
	if ( not class ) or ( class == UKNOWNBEING ) or ( class == UNKNOWN ) or ( class == UNKNOWNOBJECT ) then
		return nil;
	end
	local spell = nil;
	if ( class == AUTOREACTIVE_CLASS_WARRIOR ) then
		local activeStance = AutoReactiveClass_GetActiveStance();
		if ( activeStance == AUTOREACTIVE_STANCE_BATTLE ) then
			spell = AUTOREACTIVECLASS_OVERPOWER_NAME;
		end
		if ( activeStance == AUTOREACTIVE_STANCE_DEFENSIVE ) then
			spell = AUTOREACTIVECLASS_REVENGE_NAME;
		end
		if ( activeStance == AUTOREACTIVE_STANCE_BERSERKER ) then
			spell = nil;
		end
	elseif ( class == AUTOREACTIVE_CLASS_HUNTER ) then
		spell = AUTOREACTIVECLASS_MONGOOSE_BITE_NAME;
	elseif ( class == AUTOREACTIVE_CLASS_ROGUE ) then
		spell = AUTOREACTIVECLASS_RIPOSTE_NAME;
	else
		AQ_AutoReactiveClass_DisableUpdate()
	end
	return spell;
end

function AQ_AutoReactiveClass_OnUpdate(elapsed)
	if ( not AQ_AutoReactiveClass_Options.enabled ) then
		AQ_AutoReactiveClass_DisableUpdate();
		return;
	end
	local curTime = GetTime();
	-- if more than AutoReactiveClass_UpdateDelay seconds has passed
	if ( ( curTime - AutoReactiveClass_LastUpdate ) > AutoReactiveClass_UpdateDelay ) then
		AutoReactiveClass_LastUpdate = curTime;
		if ( ActionQueue_IsMounted() ) then
			return false;
		end
		if ( ActionQueue_IsShadowmelded() ) then	
			return false;
		end
		if ( ActionQueue_IsGlobalSpellCooldown() ) then
			return false;
		end
		if ( not UnitExists("target") ) or ( not UnitCanAttack("player", "target") ) or ( UnitIsDeadOrGhost("target") ) then
			return false;
		end
		local reactiveSpellName = AutoReactiveClass_GetReactiveSpellName();
		if ( not reactiveSpellName ) then
			return false;
		end
		-- skill not in queue: see if it's time to re-queue it
		local id = nil;
		-- optimization: if we retrieved the id before and it has not changed, why re-retreive it?
		if ( AutoReactiveClass_LastId ) then
			local name = GetSpellName(AutoReactiveClass_LastId, "spell");
			if ( name == reactiveSpellName ) then
				id = AutoReactiveClass_LastId;
			end
		end
		if ( not id ) then 
			id = ActionQueue_FindSpellId(reactiveSpellName); 
		end
		-- OK, did we find a valid id?
		if ( id ) and ( id > 0 ) then
			-- make sure we cache the found spell
			AutoReactiveClass_LastId = id;
			-- skill found: queue it up
			AutoReactiveClass_Queue_Entry.spellId = id;
			local start, duration, enable = GetSpellCooldown(id, "spell");
			if ( start + duration <= 0 ) and ( enable == 1 ) then
				local actionId = AutoReactiveClass_LastActionId;
				if ( actionId ) then
					if ( not AQ_AutoReactiveClass_IsActionIdMappedToSpellId(actionId, id) ) then
						actionId = nil;
					end
				end
				if ( not actionId ) then
					actionId = AQ_AutoReactiveClass_RetrieveActionIdFromSpellId(id);
					AutoReactiveClass_LastActionId = actionId;
				end
				if ( actionId ) then
					local isUsable, notEnoughMana = IsUsableAction(actionId);
					if ( not isUsable ) or ( notEnoughMana ) then
						return false;
					end
				else
					return false;
				end
				if ( AQ_AutoReactiveClass_Options.showMessage ) then
					ActionQueue_ShowMessage(AQ_AutoReactiveClass_GetMessage(reactiveSpellName));
				end
				if ( AQ_AutoReactiveClass_Options.queueAction ) then
					AutoReactiveClass_Queue_Entry.spellId = id;
					if ( not ActionQueue_IsQueued(AUTOREACTIVECLASS_ACTIONQUEUE_ID) ) then
						ActionQueue_QueueAction(AutoReactiveClass_Queue_Entry);
					end
				end
			end
		else
			-- skill not found: disable the addon
			AQ_AutoReactiveClass_DisableUpdate()
		end
	end
end

-- FUNCTIONS END
