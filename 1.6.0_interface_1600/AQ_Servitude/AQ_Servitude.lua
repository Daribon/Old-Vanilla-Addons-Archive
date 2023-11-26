AQ_Servitude_PetAction = nil;

AQ_Servitude_Options_Default = {
	["enabled"] = true;
};

AQ_Servitude_Options = {};

AQ_ServitudeID = "[AQ] Servitude";

function AQ_Servitude_ActionQueueShouldBeRemovedCallback()
	if ( AQ_Servitude_Options.enabled ) then
		return false;
	else
		return true;
	end
end

function AQ_Servitude_ActionQueueCallback(entry)
	if ( AQ_Servitude_Options.enabled ) then
		ActionQueue_QueueSpellAdvanced(AQ_Servitude_Entry);
	end
	AQ_Servitude_PetAction = nil;
	CastPetActionQueue();
	if ( AQ_Servitude_PetAction ) then
		AQ_Servitude_PetAction = nil;
		return true;
	else
		return false;
	end
end

function AQ_Servitude_OnLoad()
	AQ_Servitude_Saved_CastPetActionByName = CastPetActionByName;
	CastPetActionByName = AQ_Servitude_CastPetActionByName;
	
	local f = AQ_ServitudeFrame;
	f:RegisterEvent("VARIABLES_LOADED");
end

function AQ_Servitude_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in AQ_Servitude_Options_Default do
			if ( AQ_Servitude_Options[k] == nil ) then
				AQ_Servitude_Options[k] = v;
			end
		end
		ActionQueue_QueueSpellAdvanced(AQ_Servitude_Entry);
	end
end

function AQ_Servitude_CastPetActionByName(name, p1, p2, p3, p4, p5)
	AQ_Servitude_PetAction = name;
	return AQ_Servitude_Saved_CastPetActionByName(name, p1, p2, p3, p4, p5);
end


AQ_Servitude_Entry = {
	["id"] = AQ_ServitudeID;
	["name"] = "[AQ] Servitude";
	["shouldBeRemovedFunc"] = AQ_Servitude_ActionQueueShouldBeRemovedCallback;
	["shouldExecuteFunc"] = ActionQueue_ShouldExecuteFunction_ASAP;
	["executeFunc"] = AQ_Servitude_ActionQueueCallback;
	["priority"] = ACTIONQUEUE_LOWEST_PRIORITY;
};

