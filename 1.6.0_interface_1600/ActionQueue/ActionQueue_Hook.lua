ActionQueue_Override_Binding_Pointers = {
	--"MoveForwardStart",
	"MoveForwardStop",
	--"MoveBackwardStart",
	"MoveBackwardStop",
	--"TurnLeftStart",
	"TurnLeftStop",
	--"TurnRightStart",
	"TurnRightStop",
	--"StrafeLeftStart",
	"StrafeLeftStop",
	--"StrafeRightStart",
	"StrafeRightStop",
	--"ActionButtonDown",
	--"ActionButtonUp",
	--"BonusActionButtonDown",
	--"BonusActionButtonUp",
	--"CameraOrSelectOrMoveStart",
	"CameraOrSelectOrMoveStop",
	--"TurnOrActionStart",
	"TurnOrActionStop",
	--"PitchUpStart",
	"PitchUpStop",
	--"PitchDownStart",
	"PitchDownStop"
};
ActionQueue_Saved_Binding_Pointers = {};
-- /script ActionQueue_SetupOverrideBinding();
ActionQueue_ShouldOverrideBindings = 1;
function ActionQueue_SetupOverrideBinding()
	if ( ActionQueue_ShouldOverrideBindings == 1 ) then
		for k, v in ActionQueue_Override_Binding_Pointers do
			if ( not ActionQueue_Saved_Binding_Pointers[v] ) then
				ActionQueue_Saved_Binding_Pointers[v] = getglobal(v);
				setglobal(v, getglobal("ActionQueue_"..v));
			end
		end
	else
		for k, v in ActionQueue_Override_Binding_Pointers do
			if ( ActionQueue_Saved_Binding_Pointers[v] ) then
				setglobal(v, ActionQueue_Saved_Binding_Pointers[v]);
				ActionQueue_Saved_Binding_Pointers[v] = nil;
			end
		end
	end
end

function ActionQueue_MoveForwardStart(param1)
	ActionQueue_Saved_Binding_Pointers["MoveForwardStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_MoveForwardStop(param1)
	ActionQueue_Saved_Binding_Pointers["MoveForwardStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_MoveBackwardStart(param1)
	ActionQueue_Saved_Binding_Pointers["MoveBackwardStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_MoveBackwardStop(param1)
	ActionQueue_Saved_Binding_Pointers["MoveBackwardStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_TurnLeftStart(param1)
	ActionQueue_Saved_Binding_Pointers["TurnLeftStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_TurnLeftStop(param1)
	ActionQueue_Saved_Binding_Pointers["TurnLeftStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_TurnRightStart(param1)
	ActionQueue_Saved_Binding_Pointers["TurnRightStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_TurnRightStop(param1)
	ActionQueue_Saved_Binding_Pointers["TurnRightStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_StrafeLeftStart(param1)
	ActionQueue_Saved_Binding_Pointers["StrafeLeftStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_StrafeLeftStop(param1)
	ActionQueue_Saved_Binding_Pointers["StrafeLeftStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_StrafeRightStart(param1)
	ActionQueue_Saved_Binding_Pointers["StrafeRightStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_StrafeRightStop(param1)
	ActionQueue_Saved_Binding_Pointers["StrafeRightStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_ActionButtonDown(param1)
	ActionQueue_Saved_Binding_Pointers["ActionButtonDown"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_ActionButtonUp(param1)
	ActionQueue_Saved_Binding_Pointers["ActionButtonUp"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_BonusActionButtonDown(param1)
	ActionQueue_Saved_Binding_Pointers["BonusActionButtonDown"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_BonusActionButtonUp(param1)
	ActionQueue_Saved_Binding_Pointers["BonusActionButtonUp"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_CameraOrSelectOrMoveStart(param1)
	ActionQueue_Saved_Binding_Pointers["CameraOrSelectOrMoveStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_CameraOrSelectOrMoveStop(param1)
	ActionQueue_Saved_Binding_Pointers["CameraOrSelectOrMoveStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_TurnOrActionStart(param1)
	ActionQueue_Saved_Binding_Pointers["TurnOrActionStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_TurnOrActionStop(param1)
	ActionQueue_Saved_Binding_Pointers["TurnOrActionStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_PitchUpStart(param1)
	ActionQueue_Saved_Binding_Pointers["PitchUpStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_PitchUpStop(param1)
	ActionQueue_Saved_Binding_Pointers["PitchUpStop"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_PitchDownStart(param1)
	ActionQueue_Saved_Binding_Pointers["PitchDownStart"](param1);
	ActionQueue_OnUpdate();
end

function ActionQueue_PitchDownStop(param1)
	ActionQueue_Saved_Binding_Pointers["PitchDownStop"](param1);
	ActionQueue_OnUpdate();
end

