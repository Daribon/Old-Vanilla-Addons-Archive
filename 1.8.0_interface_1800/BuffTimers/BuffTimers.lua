--[[

	BuffTimers: Mini timers for the top right buff icons
		copyright 2004 by Telo
	
	- Displays small timer text below each of the top right buff and debuff icons
	- Now simplified substantially by using the Blizzard interface elements to present the
	  timer information in the original BuffTimers format
	
]]

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hook
local lOriginal_BuffFrame_UpdateDuration;


--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function lSetTimeText(button, time)
	local d, h, m, s;
	local text;
	
	if( time <= 0 ) then
		text = "";
	elseif( time < 3600 ) then
		d, h, m, s = ChatFrame_TimeBreakDown(time);
		text = format("%02d:%02d", m, s);
	else
		text = "1 hr+";
	end
	
	button:SetText(text);
end


--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function BuffTimers_OnLoad()
	-- Hook the button functions we need to override
	lOriginal_BuffFrame_UpdateDuration = BuffFrame_UpdateDuration;
	BuffFrame_UpdateDuration = BuffTimers_BuffFrame_UpdateDuration;
end

function BuffTimers_BuffFrame_UpdateDuration(buffButton, timeLeft)
	lOriginal_BuffFrame_UpdateDuration(buffButton, timeLeft);

	local duration = getglobal(buffButton:GetName().."Duration");
	if( timeLeft ) then
		lSetTimeText(duration, timeLeft);
		duration:Show();
	else
		duration:Hide();
	end
end
