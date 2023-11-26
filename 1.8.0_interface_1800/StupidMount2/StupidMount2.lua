StupidMount2_Options = {};

function StupidMount2_OnLoad()
	StupidMount2_Options_OnLoad();
	
	local f = StupidMount2Frame;
	f:RegisterEvent("VARIABLES_LOADED");
	f:RegisterEvent("ADDON_LOADED");
	f:RegisterEvent("UI_ERROR_MESSAGE");
end


-- Lots of credits to IsMounted code for this one!
function StupidMount2_GetMountBuffIndex()
	local i;
	for i = 1, 24 do
		local buffIndex, untilCancelled = GetPlayerBuff(i, "HELPFUL|PASSIVE");
		-- TODO: this may be changed in some patch, far far away
		if ( untilCancelled ) and ( buffIndex >= 0 ) then
			StupidMount2Tooltip:SetPlayerBuff(buffIndex);
			if (StupidMount2TooltipTextLeft2:IsVisible()) then
				text = StupidMount2TooltipTextLeft2:GetText();
				if (text) then
					for speed in gfind(text, STUPIDMOUNT2_TOOLTIP_GFIND_PATTERN) do
						return buffIndex;
					end
				end
			end
		end
	end
	return nil;
end

function StupidMount2_HandleDismount()
	if ( UnitOnTaxi("player") ) then
		return;
	end
	if ( not StupidMount2_Options.enabled ) then
		return;
	end
	if ( not StupidMount2_Options.dismountInCombat ) and ( PlayerFrame.inCombat ) then
		return;
	end
	local index = StupidMount2_GetMountBuffIndex();
	if ( index ) then
		CancelPlayerBuff(index);
	end
end

function StupidMount2_IsMounted_GetMountBuffIndex()
	return IsMounted.GetMountBuffInfo("player");
end

StupidMount2_AddOnFuncFixList = {
	"GetMountBuffIndex"
};

StupidMount2_AddOnFuncFixed = {
};


function StupidMount2_FixAddOns_GetMountBuffIndex()
	if ( IsAddOnLoaded("IsMounted") ) then
		StupidMount2_GetMountBuffIndex = StupidMount2_IsMounted_GetMountBuffIndex;
		return true;
	end
	if ( IsAddOnLoaded("AutoMount") ) then
		StupidMount2_GetMountBuffIndex = AutoMount_GetMountBuffPosition;
		return true;
	end
	return false;
end

function StupidMount2_FixAddOns()
	for k, v in StupidMount2_AddOnFuncFixList do
		if ( not StupidMount2_AddOnFuncFixed[v] ) then
			local func = getglobal("StupidMount2_FixAddOns_"..v);
			if ( func ) then
				StupidMount2_AddOnFuncFixed[v] = func;
			end
		end
	end
end

function StupidMount2_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in STUPIDMOUNT2_OPTIONS_DEFAULT do
			if ( StupidMount2_Options[k] == nil ) then
				StupidMount2_Options[k] = v;
			end
		end
		StupidMount2_FixAddOns();
		return;
	end
	if ( event == "ADDON_LOADED" ) then
		StupidMount2_FixAddOns();
		return;
	end
	if ( event == "UI_ERROR_MESSAGE" ) then
		if ( arg1 == SPELL_FAILED_NOT_MOUNTED ) then
			StupidMount2_HandleDismount();
		end
		return;
	end
end

