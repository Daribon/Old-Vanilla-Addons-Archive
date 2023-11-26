
function AQ_AutoReactiveClass_HandleBeginAction_Shaman(performer, action, target, actionType, p1, p2, p3, p4, p5)
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
	local canUseEarthShock = true;
	for k, v in AutoReactiveClass_Rogue_SpellsThatCanNotBeKickInterrupted do
		if ( v == action ) then
			canUseEarthShock = false;
			break;
		end
	end
	
	if ( canUseEarthShock ) then
		local skillName = AUTOREACTIVECLASS_EARTH_SHOCK_NAME;
		local skillId = AutoReactiveClass_Shaman_Earth_Shock_LastId;
		local id = nil;
		if ( skillId ) then
			local name = GetSpellName(skillId, "spell");
			if ( name == skillName ) then
				id = skillId;
			end
		end
		if ( not id ) then
			if ( AQ_AutoReactiveClass_Options.useHighestEarthShockAlways ) then
				id = ActionQueue_GetHighestSpellRankId(skillName);
			else
				id = ActionQueue_FindSpellId(skillName); 
			end
		end
		if ( id ) then
			AutoReactiveClass_Shaman_Earth_Shock_LastId = id;
			if ( not AQ_AutoReactiveClass_Options.useHighestEarthShockAlways ) 
				and ( AQ_AutoReactiveClass_Options.useHighestEarthShockWhenClearcastingActive ) then
				if ( ActionQueue_GetBuffPosition(
					AUTOREACTIVECLASS_SHAMAN_CLEARCAST_TEXTURE, 
					AUTOREACTIVECLASS_SHAMAN_CLEARCAST_NAME) 
					) then
					local highestES = ActionQueue_GetHighestSpellRankId(skillName, nil, id);
					if ( highestES ) then 
						id = highestES;
					end
				end
			end
			AutoReactiveClass_Queue_Interrupt_Entry.spellId = id;
			ActionQueue_QueueAction(AutoReactiveClass_Queue_Interrupt_Entry);
		end
	end

	AQ_AutoReactiveClass_HandleBeginAction_ShowMessage(performer, action, target, actionType, p1, p2, p3, p4, p5);
end

