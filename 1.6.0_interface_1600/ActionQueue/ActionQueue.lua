ACTIONQUEUE_MINIMUM_TIME_BETWEEN_UPDATES = 0.1;

ACTIONQUEUE_LOWEST_PRIORITY			= -1000;
ACTIONQUEUE_NORMAL_PRIORITY			= 0;
ACTIONQUEUE_HIGHEST_PRIORITY		= 5000;

ACTIONQUEUE_SHAPESHIFT_INHIBIT_TIME = 7;

ActionQueue_Options_Default = {
	range = {
		alwaysInRangeInInstances = false;
		opt = {
			checkPresentBuffsWhenNoRange = true;
			onlyBuffIfBuffsArePresent = false;
			overridePresentBuffsInInstances = false;
			ignoreRange = false;
			petAlwaysInRange = true;
			petNeverInRange = false;
		}
	};
	message = {
		scale = 1;
		dragButtonVisible = false;
	};
};

ActionQueue_Options = {
};


ActionQueue_LastUpdated = nil;

ActionQueue_Queue = {};

function ActionQueue_OnLoad()
	ActionQueue_Queue = {};
	local f = ActionQueueFrame;
	
	ActionQueue_Setup_Slash_Command();
	
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("UNIT_AURA");
	f:RegisterEvent("PLAYER_AURAS_CHANGED");
	
	if ( Smash ) and ( Smash.RegisterForKey ) then
		Smash.RegisterForKey("ActionQueue", 0, ActionQueue_OnUpdate, 0);
	end
end

function ActionQueue_UpdateShapeshift()
	ActionQueue_WasShapeshifted = ActionQueue_Shapeshifted;
	ActionQueue_Shapeshifted = ActionQueue_IsShapeshifted();
	if ( ActionQueue_Shapeshifted ) or ( ( ActionQueue_WasShapeshifted ) and ( not ActionQueue_Shapeshifted ) ) then
		ActionQueue_LastShapeshifted = curTime;
	end
end

function ActionQueue_OnEvent(event)
	local curTime = GetTime();
	if ( event == "VARIABLES_LOADED" ) then
		if ( ActionQueue_SetupOverrideBinding ) then
			ActionQueue_SetupOverrideBinding();
		end
		ActionQueue_LoadDefaults();
	end
	if ( event == "UNIT_AURA" ) then
		if ( arg1 == "player" ) then
			if ( ActionQueue_IsShapeshifter() ) then
				ActionQueue_UpdateShapeshift();
			end
		end
	end
	if ( event == "PLAYER_AURAS_CHANGED" ) then
		if ( ActionQueue_IsShapeshifter() ) then
			ActionQueue_UpdateShapeshift();
		end
	end
end


-- Cast as soon as possible. Never expires.
function ActionQueue_ShouldExecuteFunction_ASAP(t)
	return true;
end

-- Cast as soon as possible. Never expires.
function ActionQueue_ShouldExecuteFunction_SpellCooldown(t)
	local spellBook = t.spellBook;
	if ( not spellBook ) then spellBook = "spell"; end
	local start, duration, enable = GetSpellCooldown(t.spellId, spellBook);
	if ( start + duration > 0 ) or ( enable ~= 1 ) then
		return false;
	else
		return true;
	end
end

-- used to see if a certain time has passed and/or has yet to come.
function ActionQueue_ShouldExecuteFunction_Time(t)
	local curTime = GetTime();
	if ( ( not t.before ) or ( t.before < curTime ) ) and
		( ( not t.after ) or ( t.after > curTime ) ) then
		return true;
	else
		return false;
	end
end

-- Used to see if a certain time has passed and/or has yet to come.
function ActionQueue_ShouldBeRemovedFunction_Time(t)
	if ( not t.before ) and ( not t.after ) then
		return true;
	end
	local curTime = GetTime();
	if ( ( t.before ) and ( t.before >= t ) ) then
		return true;
	end
	return false;
end

-- Queues a spell. 
-- It defaults to using shouldExecuteFunc = ActionQueue_ShouldExecuteFunction_ASAP 
-- and executeFunc = ActionQueue_ExecuteFunction_Spell.
-- extraParams can contain a table with key => values to override the defaults.
function ActionQueue_QueueSpell(spellId, spellBook, target, extraParams)
	local t = {};
	t.spellId = spellId;
	t.spellBook = spellBook;
	t.shouldExecuteFunc = ActionQueue_ShouldExecuteFunction_ASAP;
	t.executeFunc = ActionQueue_ExecuteFunction_Spell;
	t.target = target;
	if ( DynamicData ) and ( DynamicData.spell ) and ( DynamicData.spell.getSpellInfo ) then
		t.nameFunc = ActionQueue_NameFunction_DDSpellName;
	else
		t.nameFunc = ActionQueue_NameFunction_SpellName;
	end
	if ( extraParams ) and ( type(extraParams) == "table" ) then
		for k, v in extraParams do
			t[k] = v;
		end
	end
	return ActionQueue_QueueSpellAdvanced(t);
end

function ActionQueue_QueueSpellTable(t)
	return ActionQueue_QueueSpellAdvanced(t);
end

function ActionQueue_NameFunction_DDSpellName(t)
	if ( DynamicData ) and ( DynamicData.spell ) and ( DynamicData.spell.getSpellInfo ) then
		local info = DynamicData.spell.getSpellInfo(t.spellId, t.spellBook);
		if ( info ) and ( info.name ) and ( strlen(info.name) > 0 ) then
			return info.name;
		end
	end
	return nil;
end

function ActionQueue_NameFunction_SpellName(t)
	local id = t.spellId;
	if ( not id ) then
		return nil;
	end
	local spellBook = t.spellBook;
	if ( not spellBook ) then spellBook = "spell"; end
	local name, rank = GetSpellName(id, spellBook);
	return name;
end

function ActionQueue_NameFunction_SpellNameAndRank(t)
	local id = t.spellId;
	if ( not id ) then
		return nil;
	end
	local spellBook = t.spellBook;
	if ( not spellBook ) then spellBook = "spell"; end
	local name, rank = GetSpellName(id, spellBook);
	if ( name ) and ( rank ) and ( strlen(rank) > 0 ) then
		return name.." "..rank;
	else
		return name;
	end
end

function ActionQueue_OnUpdate()
	if ( ATStatus ) then
		if ( ATStatus.path ) and ( not ATStatus.paused ) then
			return false;
		end
	end
	if ( Smash ) and ( Smash.RegisterForKey ) then
		Smash.RegisterForKey("ActionQueue", 1, ActionQueue_OnUpdate, 0);
	end
	local curTime = GetTime();
	if ( not ActionQueue_LastUpdated ) or ( curTime - ActionQueue_LastUpdated >= ACTIONQUEUE_MINIMUM_TIME_BETWEEN_UPDATES ) then
		ActionQueue_LastUpdated = curTime;
		return ActionQueue_DoUpdate();
	else
		return false;
	end
end

function ActionQueue_GetEntryName(entry)
	if ( not entry ) then
		return nil;
	end
	if ( entry.name ) then
		return entry.name;
	end
	local name = nil;
	if ( entry.nameFunc ) then
		name = entry.nameFunc(entry);
		if ( name ) then
			return name;
		end
	end
	if ( entry.spellId ) then
		name = ActionQueue_NameFunction_DDSpellName(entry);
		if ( not name ) then
			name = ActionQueue_NameFunction_SpellName(entry)
		end
		if ( name ) then
			entry.name = name;
			return name;
		end
	end
	return TEXT(ACTIONQUEUE_UNKNOWN_ENTRY_NAME);
end


-- Not yet used. 
-- Meant to remove "expired" entries.
-- if brief is not nil, it will only remove one expired entry.
function ActionQueue_DoMaintenence(brief)
	local ok = true;
	local keyValue = nil;
	while ( ok ) do
		ok = false;
		for k, v in ActionQueue_Queue do
			if ( v.shouldBeRemovedFunc ) and ( v.shouldBeRemovedFunc(v) ) then
				keyValue = k;
			end
		end
		if ( keyValue ) then
			table.remove(ActionQueue_Queue, keyValue);
			if ( not brief ) then
				ok = true;
			end
		end
	end
end

function ActionQueue_ExecuteFunction_Spell(t)
	local spellBook = "spell";
	if ( t.spellBook ) then
		spellBook = t.spellBook;
	end
	if ( t.spellId ) then
		local s, d, e = GetSpellCooldown(t.spellId, spellBook);
		if ( s + d > 0 ) or ( e == 0 ) then
			return false;
		end
		CastSpell(t.spellId, spellBook);
		if ( t.target ) then
			SpellTargetUnit(t.target);
		end
		return true;
	end
	return false;
end

-- Whether AQ should execute. Mostly for overload purposes, but contains a check for dead/ghosthood
function ActionQueue_ShouldExecute()
	if ( UnitIsDeadOrGhost("player") ) then
		return false;
	end
	return true;
end


ACTIONQUEUE_MAX_ITERATIONS_PER_UPDATE = 100;

function ActionQueue_DoUpdate()
	local curTime = GetTime();
	if ( not ActionQueue_ShouldExecute() ) then
		return false;
	end
	local ok = true;
	local iters = 0;
	local maxIters = ACTIONQUEUE_MAX_ITERATIONS_PER_UPDATE;
	local n = table.getn(ActionQueue_Queue);
	if ( maxIters > n ) then
		maxIters = n;
	end
	while ( ok ) and ( iters < maxIters ) do
		ok = false;
		local keyValue = nil;
		for k, v in ActionQueue_Queue do
			if ( not v.shouldExecuteFunc ) or ( v.shouldExecuteFunc(v) ) then
				keyValue = k;
				break;
			end
		end
		if ( keyValue ) then
			local spellBook = "spell";
			local tmp = ActionQueue_Queue[keyValue];
			table.remove(ActionQueue_Queue, keyValue);
			if ( tmp.spellBook ) then
				spellBook = tmp.spellBook;
			end
			if ( tmp.executeFunc ) then
				tmp.lastExecuted = curTime;
				local retVal, timeFix = tmp.executeFunc(tmp);
				if ( retVal ) then
					if ( timeFix ) then
						ActionQueue_LastUpdated = curTime+timeFix;
					end
					return true;
				else
					ok = true;
				end
			elseif ( tmp.spellId ) then
				tmp.lastExecuted = curTime;
				if ( ActionQueue_ExecuteFunction_Spell(tmp) ) then
					return true;
				end
			else
				-- do nothing as it does not have recognized parameters.
			end
		end
		iters = iters + 1;
	end
	return false;
end

function ActionQueue_QueueItemComparator(item1, item2)
	if ( not item1 ) and ( not item2 ) then
		return true;
	elseif ( not item1 ) then
		return false;
	elseif ( not item2 ) then
		return true;
	end
	if ( item1.lastExecuted ) and ( item2.lastExecuted ) then
		if ( item1.lastExecuted < item2.lastExecuted ) then
			return true;
		else
			return false;
		end
	elseif ( item1.lastExecuted ) then
		return false;
	elseif ( item2.lastExecuted ) then
		return true;
	end
	if ( not item1.priority ) then item1.priority = ACTIONQUEUE_NORMAL_PRIORITY; end
	if ( not item2.priority ) then item2.priority = ACTIONQUEUE_NORMAL_PRIORITY; end
	if ( item1.priority == item2.priority ) then
	end
	if ( item1.priority > item2.priority ) then
		return true;
	else
		return false;
	end
end

function ActionQueue_QueueSpellAdvanced(info)
	if ( not info ) or ( not info.executeFunc ) then
		return false;
	end
	if ( not info.shouldBeRemovedFunc ) then
		if ( info.shouldExecuteFunc == ActionQueue_ShouldExecuteFunction_Time ) then
			info.shouldBeRemovedFunc = ActionQueue_ShouldBeRemovedFunction_Time;
		end
	end
	if ( info.priority ) then
		if ( info.priority > ACTIONQUEUE_HIGHEST_PRIORITY ) then
			info.priority = ACTIONQUEUE_HIGHEST_PRIORITY;
		elseif ( info.priority < ACTIONQUEUE_LOWEST_PRIORITY ) then
			info.priority = ACTIONQUEUE_LOWEST_PRIORITY;
		end
	else
		info.priority = ACTIONQUEUE_NORMAL_PRIORITY;
	end
	if ( not info.priority ) or ( info.priority <= ACTIONQUEUE_LOWEST_PRIORITY ) then
		table.insert(ActionQueue_Queue, info);
	else
		local pri = info.priority;
		local lastEqualOrHigherIndex = nil;
		for k, v in ActionQueue_Queue do
			if ( v.priority >= pri ) then
				lastEqualOrHigherIndex = k;
			else
				break;
			end
		end
		if ( lastEqualOrHigherIndex ) then
			table.insert(ActionQueue_Queue, lastEqualOrHigherIndex+1, info);
		else
			table.insert(ActionQueue_Queue, 1, info);
		end
--[[
		table.insert(ActionQueue_Queue, info);
		table.sort(ActionQueue_Queue, ActionQueue_QueueItemComparator);
]]--
	end
	return true;
end
ActionQueue_QueueAction = ActionQueue_QueueSpellAdvanced;

function ActionQueue_ListActions()
	local name = nil;
	ActionQueue_Print(ACTIONQUEUE_CMD_ACTION_LIST_START);
	local hasAction = false;
	for k, v in ActionQueue_Queue do
		hasAction = true;
		name = v.name;
		if ( not name ) then
			name = ActionQueue_GetEntryName(v);
		end
		if ( not name ) then
			name = k;
		elseif ( name == ACTIONQUEUE_UNKNOWN_ENTRY_NAME ) then
			name = k;
		end
		ActionQueue_Print(string.format(ACTIONQUEUE_CMD_ACTION_LIST_FMT, k, name));
	end
	if ( not hasAction ) then
		ActionQueue_Print(ACTIONQUEUE_CMD_ACTION_LIST_EMPTY);
	end
end

function ActionQueue_RemoveAction(actionId)
	local name = nil;
	local index = nil;
	local num = tonumber(actionId);
	if ( num ) then
		for k, v in ActionQueue_Queue do
			if ( num == k ) then
				index = k;
				break;
			end
		end
	end
	if ( not index ) then
		for k, v in ActionQueue_Queue do
			name = v.name;
			if ( not name ) then
				name = ActionQueue_GetEntryName(v);
			end
			if ( name ) then
				if ( name == actionId ) then
					index = k;
					break;
				end
			end
		end
	end
	if ( index ) then
		table.remove(ActionQueue_Queue, index);
		return true;
	else
		return false;
	end
end
ActionQueue_UnqueueAction = ActionQueue_RemoveAction;

function ActionQueue_IsQueued(identifier)
	local lId = identifier;
	if ( not lId ) then
		return false;
	end
	for k, v in ActionQueue_Queue do
		if ( v.id ) then
			if ( v.id == lId ) then
				return true;
			end
		end
	end
	return false;
end

function ActionQueue_LoadDefaultsHandleArray(source, destination)
	if ( type(source) == "table" ) then
		for k, v in source do
			if ( type(v) == "table" ) then
				if ( not destination[k] ) then
					destination[k] = {};
				end
				if ( type(destination[k]) ~= "table" ) then
					destination[k] = {};
				end
				ActionQueue_LoadDefaultsHandleArray(v, destination[k]);
			else
				if ( destination[k] == nil ) then
					destination[k] = v;
				end
			end
		end
	end
end

function ActionQueue_LoadDefaults()
	ActionQueue_LoadDefaultsHandleArray(ActionQueue_Options_Default, ActionQueue_Options);
end


function ActionQueue_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end

function ActionQueue_Setup_Slash_Command()
	local sName = "ACTIONQUEUE";
	SlashCmdList[sName] = ActionQueue_Slash_Command;
	for k, v in ACTIONQUEUE_SLASH_CMD do
		setglobal("SLASH_"..sName..k, v);
	end
end

function ActionQueue_Print(msg)
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
	end
end

function ActionQueue_Slash_Command_Usage()
	for k, v in ACTIONQUEUE_SLASH_CMD_USAGE do
		ActionQueue_Print(v);
	end
end

function ActionQueue_Slash_Command(msg)
	if ( not msg ) then
		ActionQueue_Slash_Command_Usage();
		return;
	end
	local command, params = ActionQueue_Extract_NextParameter(msg);
	if ( not command ) or ( strlen(command) <= 0 ) then
		ActionQueue_Slash_Command_Usage();
		return;
	end
	local lcommand = string.lower(command);
	for k, v in ACTIONQUEUE_CMD_MESSAGE_SCALE do
		if ( lcommand == v ) then
			local newScale = ActionQueue_SetMessageScale(params);
			if ( newScale ) then
				ActionQueue_Print(string.format(ACTIONQUEUE_CMD_MESSAGE_SCALE_SET, newScale));
			else
				ActionQueue_Print(ACTIONQUEUE_CMD_MESSAGE_SCALE_ERROR);
			end
			return;
		end
	end
	for k, v in ACTIONQUEUE_CMD_ACTION_REMOVE do
		if ( lcommand == v ) then
			if ( ActionQueue_RemoveAction(params) ) then
				ActionQueue_Print(ACTIONQUEUE_CMD_ACTION_REMOVE_OK);
			else
				ActionQueue_Print(ACTIONQUEUE_CMD_ACTION_REMOVE_FAIL);
			end
			return;
		end
	end
	for k, v in ACTIONQUEUE_CMD_ACTION_LIST do
		if ( lcommand == v ) then
			ActionQueue_ListActions();
			return;
		end
	end
	ActionQueue_Slash_Command_Usage();
	return;
end

function ActionQueue_SetMessageScale(scale)
	if ( not scale ) then
		return;
	end
	local n = tonumber(scale);
	if ( not n ) then
		return;
	else
		scale = n;
	end
	if ( scale <= 0 ) then
		return;
	end
	ActionQueue_Options.message.scale = scale;
	ActionQueueMessageFrame:SetScale(scale);
	return scale;
end