AQ_BUFFBOT_ADDON_BUFFBOT = "BuffBot 1.0->1.1 Beta";

AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT] = {
		detectionName = "BuffBot_JustBuff";
		buffFuncName = "BuffBot_JustBuff";
		cureFuncName = "BuffBot_JustCure";
		
		-- will check if our current class can buff
		-- the function gets the current class as an argument
		checkClassAbleToBuffFunc = "AQ_BuffBot_BuffBotAddOn_CanClassBuff";

		-- optional, defaults to buffFuncName if not present
		-- but allows for different functions to be used if selfbuffing is handled differently
		selfBuffFuncName = "BuffBot_JustBuff";
		-- optional, defaults to cureFuncName if not present
		selfCureFuncName = "BuffBot_JustCure";

		-- overrides defaults
		selfBuff = {
			arg = { "player" };
			canIgnoreFriendlyTarget = false;
		};
		selfCure = {
			arg = { "player" };
			canIgnoreFriendlyTarget = false;
		};
	};


function AQ_BuffBot_BuffBotAddOn_CanClassBuff(class)
	-- code to detect and disable itself if no buffs exist for our current class
	if ( BuffBot_Data ) and ( BuffBot_Data.spell_predata ) then
		if ( not BuffBot_Data.spell_predata[class] ) then
			return false;
		end
	end
	return true;
end

-- Patch for BBs lousy RangeToUnit function
-- if not present will default to applyOncePerPartyMember

if ( RangeToUnit ) then
	Old_RangeToUnit = RangeToUnit;
	RangeToUnit = ActionQueue_RangeToUnit;
else
	if ( not AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links ) then
		AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links = {};
	end
	if ( not AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links[1] ) then
		AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links[1] = {};
	end
	if ( not AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links[2] ) then
		AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links[2] = {};
	end
	AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links[1].applyOncePerPartyMember = true;
	AQ_BuffBot_SetupBuffAddOn_List[AQ_BUFFBOT_ADDON_BUFFBOT].links[2].applyOncePerPartyMember = true;
end