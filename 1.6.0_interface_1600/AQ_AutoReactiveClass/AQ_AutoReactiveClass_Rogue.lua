function AQ_AutoReactiveClass_HandleBeginAction_Rogue(performer, action, target, actionType, p1, p2, p3, p4, p5)
	if ( not AQ_AutoReactiveClass_Options.shouldInterrupt ) then
		return AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
	end
	if ( not arg ) then arg = {}; end
	local name = performer;
	if ( not name ) then name = target; end
	if ( UnitExists("target") ) then
		if ( UnitName("target") ~= name ) then
			return AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
		end
	end
	if ( AQ_AutoReactiveClass_Options.doNotInterruptIfLowerLevel ) then
		if ( UnitLevel("player") - UnitLevel("target") >= AQ_AutoReactiveClass_Options.doNotInterruptIfLowerLevel ) then
			return AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
		end
	end
	if ( ActionQueue_IsStealthed() ) then
		return AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
	end
	if ( ActionQueue_IsShadowmelded() ) then
		return AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
	end
	
	if ( ActionQueue_IsQueued(AUTOREACTIVECLASS_ACTIONQUEUE_INTERRUPT_ID) ) then
		AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
		return false;
	end
	
		
	for k, v in AutoReactiveClass_SpellsThatShouldNotBeInterrupted do
		if ( v == action ) then
			AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
			return false;
		end
	end
	local canUseKick = true;
	for k, v in AutoReactiveClass_Rogue_SpellsThatCanNotBeKickInterrupted do
		if ( v == action ) then
			canUseKick = false;
			break;
		end
	end

	local skillName = AUTOREACTIVECLASS_KICK_NAME;
	local skillId = AutoReactiveClass_Rogue_Kick_LastId;
	if ( not canUseKick ) then
		skillName = AUTOREACTIVECLASS_KIDNEY_SHOT_NAME;
		skillId = AutoReactiveClass_Rogue_Kidney_Shot_LastId;
	end
	local id = nil;
	if ( skillId ) then
		local name = GetSpellName(skillId, "spell");
		if ( name == skillName ) then
			id = skillId;
		end
	end
	if ( not id ) then 
		id = ActionQueue_FindSpellId(skillName); 
	end
	-- OK, did we find a valid id?
	if ( id ) and ( id > 0 ) then
		local start, duration, enable = GetSpellCooldown(id, "spell");
		if ( start+duration > 0 ) or ( enable ~= 1 ) then
			local left = start+duration-GetTime();
			if ( skillName == AUTOREACTIVECLASS_KICK_NAME ) and (left>3) then
				canUseKick = false;
				skillName = AUTOREACTIVECLASS_KIDNEY_SHOT_NAME;
				skillId = AutoReactiveClass_Rogue_Kidney_Shot_LastId;
				if ( skillId ) then
					local name = GetSpellName(skillId, "spell");
					if ( name == skillName ) then
						id = skillId;
					else
						id = nil;
					end
				end
				if ( not id ) then 
					id = ActionQueue_FindSpellId(skillName); 
				end
				if ( not id ) then
					AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
					return false;
				end
				start, duration, enable = GetSpellCooldown(id, "spell");
				if ( start+duration > 0 ) or ( enable ~= 1 ) then
					AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
					return false;
				end
			end
		end
		if ( not canUseKick ) then
			AutoReactiveClass_Rogue_Kidney_Shot_LastId = id;
		else
			AutoReactiveClass_Rogue_Kick_LastId = id;
		end

		if ( not ActionQueue_IsQueued(AUTOREACTIVECLASS_ACTIONQUEUE_INTERRUPT_ID) ) then
		-- skill found: queue it up
			AutoReactiveClass_Queue_Interrupt_Entry.spellId = id;
			ActionQueue_QueueAction(AutoReactiveClass_Queue_Interrupt_Entry);
		end
	end
	AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
end

