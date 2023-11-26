-- 
CT_RAA_Options_Default	= {
	showAggroMessage = true;
	playSound = true;
	doNotWarnIfTank = true;
};

CT_RAA_Options = {};

CT_RAA_AGGRO_LAST		= nil;

function CT_RAA_UpdateInfoBox()
	local curTime = GetTime();
	if ( ( not CT_RAA_AGGRO_LAST ) or ( curTime - CT_RAA_AGGRO_LAST > 3 ) ) and ( UnitInRaid("player") ) then
		local playerName = UnitName("player");
		local gotAggro = nil;
		for k, v in pairs(CT_RATarget.MainTanks) do
			if ( UnitName("raid"..v[1].."target") == playerName ) then
				gotAggro = k;
				break;
			end
		end
		if ( gotAggro ) then
			CT_RAA_AGGRO_LAST = curTime;
			if ( CT_RAA_Options.showAggroMessage ) then
				local _, class = UnitClass("player");
				local skill = CT_RAA_AGGRO_SKILL[class];
				local message = CT_RAA_AGGRO_MESSAGE;
				if ( skill ) then
					message = format(CT_RAA_AGGRO_MESSAGE_SKILL, skill);
				end
				UIErrorsFrame_OnEvent("UI_ERROR_MESSAGE", message);
			end
			if ( CT_RAA_Options.playSound ) then
				PlaySoundFile(CT_RAA_AGGROSOUND);
			end
		end
	end
	return CT_RAA_CT_RATarget_UpdateInfoBox_Original(arg1, arg2, arg3)
end

function CT_RaidAssist_Aggro_Patch()
	CT_RAA_CT_RATarget_UpdateInfoBox_Original = CT_RATarget_UpdateInfoBox;
	CT_RATarget_UpdateInfoBox = CT_RAA_UpdateInfoBox;
end

function CT_RaidAssist_Aggro_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

function CT_RaidAssist_Aggro_ShouldPatch()
	if ( CT_RAA_Options.doNotWarnIfTank ) then
		local _, class = UnitClass("player");
		for k, v in pairs(CT_RAA_TANKCLASSES) do
			if ( v == class ) then
				return false;
			end
		end
	end
	return true;
end

function CT_RaidAssist_Aggro_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		if ( not CT_RAA_Options ) then
			CT_RAA_Options = {};
		end
		for k, v in pairs(CT_RAA_Options_Default) do
			if ( CT_RAA_Options[k] == nil ) then
				CT_RAA_Options[k] = v;
			end
		end
		
		if ( CT_RaidAssist_Aggro_ShouldPatch() ) then
			CT_RaidAssist_Aggro_Patch();
		end
		
	end
end
