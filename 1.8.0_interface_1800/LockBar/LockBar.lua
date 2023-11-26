LockBar_Locked = true;
RegisterForSave("LockBar_Locked");

old_PickupAction = PickupAction;
function PickupAction(id)
	if ( not LockBar_Locked ) then
		old_PickupAction(id);
	end
end