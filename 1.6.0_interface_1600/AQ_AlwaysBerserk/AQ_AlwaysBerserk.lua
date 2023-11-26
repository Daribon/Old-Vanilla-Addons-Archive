-- default options
AQ_AlwaysBerserk_Options = {
	["enabled"] = true,
	["doAction"] = true,
	["showMessage"] = true,
};

AQ_AlwaysBerserk_HasBerserking = true;

function AQ_AlwaysBerserk_SetNewState(enabled)
	AQ_AlwaysBerserk_Options.enabled = enabled;
end

function AQ_AlwaysBerserk_ActionQueueShouldBeRemovedCallback(entry)
	if ( AQ_AlwaysBerserk_Options.enabled ) then
		return false;
	else
		return true;
	end
end

function AQ_AlwaysBerserk_QueueAction()
	if ( AQ_AlwaysBerserk_HasBerserking ) then
		if ( AQ_AlwaysBerserk_Options.showMessage ) then
			ActionQueue_ShowMessage(AQALWAYSBERSERK_MESSAGE);
		end
		if ( AQ_AlwaysBerserk_Options.doAction ) then
			if ( not ActionQueue_IsQueued(AQ_AlwaysBerserk_Entry.id) ) then
				AQ_AlwaysBerserk_Entry.before = GetTime()+5;
				ActionQueue_QueueAction(AQ_AlwaysBerserk_Entry);
			end
		end
	end
end

function AQ_AlwaysBerserk_ActionQueueCallback(entry)
	if ( not AQ_AlwaysBerserk_Options.enabled ) or ( not AQ_AlwaysBerserk_HasBerserking ) then
		return false;
	else
		local ok = AQ_AlwaysBerserk_ActionQueueCallbackFunc(entry);
		if ( not ok ) and ( entry ) then
			ActionQueue_QueueAction(entry);
		end
		return ok;
	end
end

function AQ_AlwaysBerserk_ActionQueueCallbackFunc(entry)
	if ( not AQ_AlwaysBerserk_Options.enabled ) or ( not AQ_AlwaysBerserk_HasBerserking ) then
		return false;
	end
	if ( ActionQueue_IsAnySpellRunning() ) then
		return false;
	end
	if ( ActionQueue_IsMounted() ) or ( UnitOnTaxi("player") ) then
		return false;
	end
	local spellId = ActionQueue_FindSpellId(AQALWAYSBERSERK_BERSERKING_NAME);
	if ( spellId ) and ( spellId > -1 ) then
		CastSpell(spellId, "spell");
		return true;
	else
		AQ_AlwaysBerserk_HasBerserking = false;
		AQ_AlwaysBerserk_DoesNotHaveBerserking();
	end
	return false;
end

AQ_AlwaysBerserk_Entry = {
	["id"] = AQALWAYSBERSERK_ID,
	["name"] = AQALWAYSBERSERK_NAME,
	["shouldBeRemovedFunc"] = AQ_AlwaysBerserk_ActionQueueShouldBeRemovedCallback,
	["shouldExecuteFunc"] = ActionQueue_ShouldExecuteFunction_Time,
	["executeFunc"] = AQ_AlwaysBerserk_ActionQueueCallback,
	["priority"] = ACTIONQUEUE_HIGHEST_PRIORITY,
};

AQ_AlwaysBerserk_ParseEventsParams2 = {
	"CHAT_MSG_COMBAT_SELF_HITS",
};

AQ_AlwaysBerserk_ParseEventsParams3 = {
	"CHAT_MSG_COMBAT_PET_HITS",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS",
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS",
	"CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS",
};

function AQ_AlwaysBerserk_DoesNotHaveBerserking()
	local f = AQ_AlwaysBerserkFrame;
	for k, v in AQ_AlwaysBerserk_ParseEventsParams2 do
		f:UnregisterEvent(v);
	end
	for k, v in AQ_AlwaysBerserk_ParseEventsParams3 do
		f:UnregisterEvent(v);
	end
end

function AQ_AlwaysBerserk_OnLoad()
	--ActionQueue_QueueAction(AQ_AlwaysBerserk_Entry);
	local f = AQ_AlwaysBerserkFrame;
	for k, v in AQ_AlwaysBerserk_ParseEventsParams2 do
		f:RegisterEvent(v);
	end
	for k, v in AQ_AlwaysBerserk_ParseEventsParams3 do
		f:RegisterEvent(v);
	end
	for k, v in AQALWAYSBERSERK_CHAT_PATTERNS do
		for key, value in v.list do
			value.pattern = ActionQueue_GlobalStringTogfind(value.patternBase);
		end
	end
end

function AQ_AlwaysBerserk_OnEvent(event)
	if ( AQALWAYSBERSERK_CHAT_PATTERNS[2] ) then
		for k, v in AQ_AlwaysBerserk_ParseEventsParams2 do
			if ( event == v ) then
				for k, v in AQALWAYSBERSERK_CHAT_PATTERNS[2].list do
					local pattern = v.pattern;
					for param1, param2 in string.gfind(arg1, pattern) do
						return AQ_AlwaysBerserk_QueueAction();
					end
				end
			end
		end
	end
	if ( AQALWAYSBERSERK_CHAT_PATTERNS[3] ) then
		for k, v in AQ_AlwaysBerserk_ParseEventsParams3 do
			if ( event == v ) then
				for k, v in AQALWAYSBERSERK_CHAT_PATTERNS[3].list do
					local pattern = v.pattern;
					for param1, param2, param3 in string.gfind(arg1, pattern) do
						return AQ_AlwaysBerserk_QueueAction();
					end
				end
			end
		end
	end
end
