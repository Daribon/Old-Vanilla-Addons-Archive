--[[
	Cast Timer 1.0
		Adds a timer (in seconds) to the casting bar.

	By: Moof (Jim Drey, moof@videogamemaps.net) - www.videogamemaps.net

	Just like the short desc says, short sweet and simple. Maybe more to come later.
	Note: The spell channeling events were broken in the 1.2.1 patch. Thus, it
		is disabled for now.

	$Id: CastTime.lua 999 2005-03-11 02:07:10Z AlexYoshi $
	$Rev: 999 $
	$LastChangedBy: AlexYoshi $
	$Date: 2005-03-10 21:07:10 -0500 (Thu, 10 Mar 2005) $
]]--

maxT = 0;

function CastTime_OnLoad()
	--Register events and all that good stuff.
	this:RegisterEvent("SPELLCAST_START");
	this:RegisterEvent("SPELLCAST_STOP");
	this:RegisterEvent("SPELLCAST_FAILED");
	this:RegisterEvent("SPELLCAST_INTERRUPTED");
	CastTimeFrame:Hide();
end

function CastTime_OnEvent()
	--If beginning a spell, show the frame and set the count. Else, hide the
	--  frame and zero it (the zeroing is just a paranoia check).
	if (event == "SPELLCAST_START") then
		maxT = getglobal("CastingBarFrame").maxValue;
		CastTimeFrame:Show();
	else
		maxT = 0;
		CastTimeFrame:Hide();
	end
end

function CastTime_OnUpdate()
	--Set the timer to the current time, max 4 chars. > 100 sec, seconds
	--  only; > 10 sec, tenths; < 10 sec hundredths. Max is present to
	--  prevent timer from showing negative if UI is slow on updating the hide.
	CastTimeText:SetText(string.sub(math.max(getglobal("CastingBarFrame").maxValue - GetTime(),0.00),1,4));
end
