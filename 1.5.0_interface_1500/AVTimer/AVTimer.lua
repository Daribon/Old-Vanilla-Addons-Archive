--[[
	Title:	Alterac Valley Timer

	Author:	Darjk

	Usage:	No usage - currently always enabled.

	Version:	1.00 (1/07/05)

	Notes:	Dispalys a simple timer of when the next resurrections are.  Hides when you leave Alterac Valley.
	
	Todo: 		* Put in a toggle to turn it on and off.
						
	Changed:		
			
]]

local AV_timeleft = 0;
local AV_StartTime = 0;
local AV_IsVisible = false;

function AVTimer_OnLoad()
	this:RegisterEvent("AREA_SPIRIT_HEALER_IN_RANGE");
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");

end

function AVTimer_OnUpdate()
	local curTime = GetTime();
	local Delta = curTime - AV_StartTime;
	Delta = floor(Delta);
	local Seconds = floor(math.mod(Delta, 60));

	local timeleft = AV_timeleft - Seconds;
	if( timeleft < 0) then
		AV_timeleft = timeleft + 33;
		AV_StartTime = curTime;
	end

	AVTimerButtonText:SetText(timeleft.." secs left until res");
end

function AVTimer_OnEvent(event)
	
	if ( event == "AREA_SPIRIT_HEALER_IN_RANGE" ) then
		
		AV_timeleft = GetAreaSpiritHealerTime();
		AV_StartTime = GetTime();
		
		if (AV_IsVisible == false) then
			ShowUIPanel(AVTimerFrame);
			AV_IsVisible = true;
		end
	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		local zone = GetRealZoneText();
		
		if (zone ~= "Alterac Valley") then
			HideUIPanel(AVTimerFrame);
			AV_IsVisible = false;
		end
	end
end

function AVTimer_OnShow()
	
end

function AVTimer_OnHide()
	
end