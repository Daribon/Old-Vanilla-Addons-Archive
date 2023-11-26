
TargetRememberRestore_OldTarget = nil;

function TargetRememberRestore_Toggle()
	if ( ( TargetRememberRestore_OldTarget ) and ( strlen(TargetRememberRestore_OldTarget) > 0 ) ) then
		TargetRememberRestore_RestoreTarget();
		TargetRememberRestore_OldTarget = nil;
	else
		TargetRememberRestore_RememberTarget();
	end
end

function TargetRememberRestore_RememberTarget()
	TargetRememberRestore_OldTarget = UnitName("target");
end

function TargetRememberRestore_RestoreTarget()
	if ( ( TargetRememberRestore_OldTarget ) and ( strlen(TargetRememberRestore_OldTarget) > 0 ) ) then
		TargetByName(TargetRememberRestore_OldTarget);
	end
end