LockBar_Locked = false;
RegisterForSave("LockBar_Locked");

old_PickupAction = PickupAction;
function PickupAction(id)
	if ( not LockBar_Locked ) then
		old_PickupAction(id);
	end
end