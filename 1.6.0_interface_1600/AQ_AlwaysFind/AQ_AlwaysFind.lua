-- CONSTANTS START

ALWAYSFIND_ACTIONQUEUE_ID 			= "AlwaysFind";
ALWAYSFIND_ACTIONQUEUE_NAME			= "AlwaysFind";

-- CONSTANTS END

-- SETTINGS START

-- how often it should do round robin changes
AlwaysFind_RoundRobinDelay = 30;

-- SETTINGS END

-- VARIABLES START

AQ_AlwaysFind_Enabled		= true;

AlwaysFind_ListOfSpells = {
	ALWAYSFIND_FIND_HERBS_NAME,
	ALWAYSFIND_FIND_MINERALS_NAME,
	ALWAYSFIND_FIND_TREASURE_NAME
};
for k, v in ALWAYSFIND_TRACK_SKILLS do
	table.insert(AlwaysFind_ListOfSpells, v);
end

AlwaysFind_LastSpellName = nil;

AlwaysFind_LastUpdate = 0;

AlwaysFind_LastIdList = {};

AlwaysFind_RoundRobinIndex = 1;
AlwaysFind_RoundRobinLastTime = 0;

-- SETTINGS END

AQ_AlwaysFind_Options_Default = {
	enabled = true;
	roundRobin = false;
};

AQ_AlwaysFind_Options = {
};


-- FUNCTIONS START

function AQ_AlwaysFind_DoStuff(entry)
	if ( GetTrackingTexture() ) then
		return false;
	else
		return ActionQueue_ExecuteFunction_Spell(entry);
	end
end

-- entry to add to the ActionQueue. Prepared with some concern.
AlwaysFind_Queue_Entry = {
	id = ALWAYSFIND_ACTIONQUEUE_ID;
	shouldExecuteFunc = ActionQueue_ShouldExecuteFunction_ASAP;
	executeFunc = AQ_AlwaysFind_HandleRequeuing;
	priority = ACTIONQUEUE_LOWEST_PRIORITY;
	name = ALWAYSFIND_ACTIONQUEUE_NAME;
};


function AQ_AlwaysFind_OnLoad()
	-- make sure we get to know when the client variables are all loaded in and pretty
	local frame = AQ_AlwaysFindFrame;
	frame:RegisterEvent("VARIABLES_LOADED");
	frame:RegisterEvent("SPELLS_CHANGED");
	frame:RegisterEvent("LEARNED_SPELL_IN_TAB");
	
	AlwaysFind_Queue_Entry.executeFunc = AQ_AlwaysFind_HandleRequeuing;
	AQ_AlwaysFind_CheckForTracking();
end

function AQ_AlwaysFind_OnEvent(event)
	-- when client variables are loaded, start using Perception
	if ( event == "VARIABLES_LOADED" ) then
		local frame = AQ_AlwaysFindFrame;
		frame:UnregisterEvent(event);
		
		for k, v in AQ_AlwaysFind_Options_Default do
			if ( AQ_AlwaysFind_Options[k] == nil ) then
				AQ_AlwaysFind_Options[k] = v;
			end
		end
		
		AQ_AlwaysFind_Enable();
		return;
	end
	if ( event == "SPELLS_CHANGED" ) or ( event == "LEARNED_SPELL_IN_TAB" ) then
		AlwaysFind_LastSpellName = nil;
		local spellName = AQ_AlwaysFind_GetSpellName();
		if ( spellName ) then
			AQ_AlwaysFind_Enable();
		else
			AQ_AlwaysFind_Disable();
		end
	end
end

-- Enable AQ_AlwaysFind.
function AQ_AlwaysFind_Enable()
	AQ_AlwaysFind_Options.enabled = true;
	AQ_AlwaysFind_AddToQueue();
end

-- Disable AQ_AlwaysFind.
function AQ_AlwaysFind_Disable()
	AQ_AlwaysFind_Options.enabled = false;
end

-- Retrive the desired spell name.
function AQ_AlwaysFind_GetSpellName()
	if ( AQ_AlwaysFind_Options.roundRobin ) then
		local curTime = GetTime();
		if ( AlwaysFind_RoundRobinLastTime - curTime > AlwaysFind_RoundRobinDelay ) then
			local retrieveInfo = true;
			local tmp = nil;
			for k, spellName in AlwaysFind_ListOfSpells do
				retrieveInfo = true;
				if ( AlwaysFind_LastIdList[spellName] ) then
					tmp = GetSpellName(AlwaysFind_LastIdList[spellName]);
					if ( tmp == spellName ) then
						retrieveInfo = false;
					end
				end
				if ( retrieveInfo ) then
					id = ActionQueue_FindSpellId(spellName); 
					if ( id ) and ( id > 0 ) then
						AlwaysFind_LastIdList[spellName] = id;
					end
				end
			end
			tmp = nil;
			local size = table.getn(AlwaysFind_ListOfSpells);
			for i = AlwaysFind_RoundRobinIndex+1, size do
				tmp = AlwaysFind_ListOfSpells[i];
				if ( AlwaysFind_LastIdList[tmp] ) then
					AlwaysFind_RoundRobinIndex = i;
					AlwaysFind_LastSpellName = tmp;
					return tmp;
				end
			end
			for i = 1, AlwaysFind_RoundRobinIndex do
				tmp = AlwaysFind_ListOfSpells[i];
				if ( AlwaysFind_LastIdList[tmp] ) then
					AlwaysFind_RoundRobinIndex = i;
					AlwaysFind_LastSpellName = tmp;
					return tmp;
				end
			end
		end
	end
	if ( not AlwaysFind_LastSpellName ) then
		local id = nil;
		for k, spellName in AlwaysFind_ListOfSpells do
			id = ActionQueue_FindSpellId(spellName); 
			if ( id ) and ( id > 0 ) then
				AlwaysFind_LastIdList[spellName] = id;
				AlwaysFind_LastSpellName = spellName;
				break;
			end
		end
	end
	return AlwaysFind_LastSpellName;
end

function AQ_AlwaysFind_AddToQueue()
	if ( not ActionQueue_IsQueued(AlwaysFind_Queue_Entry.id ) ) then 
		ActionQueue_QueueAction(AlwaysFind_Queue_Entry);
	end
end

function AQ_AlwaysFind_HandleRequeuing()
	local ok = AQ_AlwaysFind_CheckForTracking();
	if ( AQ_AlwaysFind_Enabled ) then
		AQ_AlwaysFind_AddToQueue();
	end
	return ok;
end

function AQ_AlwaysFind_CheckForTracking()
	-- tracking is already present
	if ( GetTrackingTexture() ) then
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
	if ( PlayerFrame.inCombat ) then
		return false;
	end
	local id = nil;
	local spellName = AQ_AlwaysFind_GetSpellName();
	if ( not spellName ) then
		AQ_AlwaysFind_Disable();
		return false;
	end
	-- optimization: if we retrieved the id before and it has not changed, why re-retrive it?
	local lastId = AlwaysFind_LastIdList[spellName];
	if ( lastId ) then
		local name = GetSpellName(lastId, "spell");
		if ( name == spellName ) then
			id = lastId;
		end
	end
	if ( not id ) then 
		id = ActionQueue_FindSpellId(spellName); 
	end
	-- OK, did we find a valid id?
	if ( id ) and ( id > 0 ) then
		-- make sure we cache the found spell
		AlwaysFind_LastIdList[spellName] = id;
		-- skill found: cast it
		local start, duration, enable = GetSpellCooldown(id, "spell");
		if ( start + duration <= 0 ) then
			CastSpell(id, "spell");
			return true;
		end
	else
		-- skill not found: disable the addon
		AQ_AlwaysFind_Disable()
	end
	return false;
end

-- FUNCTIONS END
