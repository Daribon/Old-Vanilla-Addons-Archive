-- CONSTANTS START

ALWAYSPERCEPTION_ACTIONQUEUE_ID = "AlwaysPerception";

-- CONSTANTS END

-- SETTINGS START

-- how often it should check if Perception has cooled down (in seconds)
-- this could be subject to adjustment
AlwaysPerception_UpdateDelay = 1;

-- SETTINGS END

-- VARIABLES START

AlwaysPerception_LastUpdate = 0;
AlwaysPerception_LastId = nil;

-- SETTINGS END


-- FUNCTIONS START

-- entry to add to the ActionQueue. Prepared with some concern.
AlwaysPerception_Queue_Entry = {
	id = ALWAYSPERCEPTION_ACTIONQUEUE_ID;
	spellId = nil; -- not known until we first try to cast it
	shouldExecuteFunc = ActionQueue_ShouldExecuteFunction_ASAP;
	executeFunc = ActionQueue_ExecuteFunction_Spell;
	name = ALWAYSPERCEPTION_PERCEPTION_NAME;
};


function AQ_AlwaysPerception_OnLoad()
	-- make sure we get to know when the client variables are all loaded in and pretty
	local frame = AQ_AlwaysPerceptionFrame;
	frame:RegisterEvent("VARIABLES_LOADED");
end

function AQ_AlwaysPerception_OnEvent(event)
	-- when client variables are loaded, start using Perception
	if ( event == "VARIABLES_LOADED" ) then
		local frame = AQ_AlwaysPerceptionFrame;
		frame:UnregisterEvent(event);
		AQ_AlwaysPerception_Enable();
		return;
	end
end

-- Enable AQ_AlwaysPerception.
function AQ_AlwaysPerception_Enable()
	-- show the frame to allow OnUpdates to occur
	local frame = AQ_AlwaysPerceptionFrame;
	frame:Show();
end

-- Disable AQ_AlwaysPerception.
function AQ_AlwaysPerception_Disable()
	-- hide the frame to prevent OnUpdates from occurring (saving a few cycles)
	local frame = AQ_AlwaysPerceptionFrame;
	frame:Hide();
end

function AQ_AlwaysPerception_OnUpdate(elapsed)
	local curTime = GetTime();
	-- if more than AlwaysPerception_UpdateDelay seconds has passed
	if ( ( curTime - AlwaysPerception_LastUpdate ) > AlwaysPerception_UpdateDelay ) then
		AlwaysPerception_LastUpdate = curTime;
		-- skill not in queue: see if it's time to re-queue it
		if ( not ActionQueue_IsQueued(ALWAYSPERCEPTION_ACTIONQUEUE_ID) ) and ( not ActionQueue_IsMounted() ) then
			local id = nil;
			-- optimization: if we retrieved the id before and it has not changed, why re-retrive it?
			if ( AlwaysPerception_LastId ) then
				local name = GetSpellName(AlwaysPerception_LastId, "spell");
				if ( name == ALWAYSPERCEPTION_PERCEPTION_NAME ) then
					id = AlwaysPerception_LastId;
				end
			end
			if ( not id ) then 
				id = ActionQueue_FindSpellId(ALWAYSPERCEPTION_PERCEPTION_NAME); 
			end
			-- OK, did we find a valid id?
			if ( id ) and ( id > 0 ) then
				-- make sure we cache the found spell
				AlwaysPerception_LastId = id;
				-- skill found: queue it up
				AlwaysPerception_Queue_Entry.spellId = id;
				local start, duration, enable = GetSpellCooldown(id, "spell");
				if ( start + duration <= 0 ) then
					ActionQueue_QueueAction(AlwaysPerception_Queue_Entry);
				end
			else
				-- skill not found: disable the addon
				AQ_AlwaysPerception_Disable()
			end
		end
	end
end

-- FUNCTIONS END
