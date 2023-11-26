--[[
	Cast Timer 1.4r2
		Adds a timer (in seconds) to the casting bar.
		Provides a moveable timer, too.

	By: Moof (Jim Drey, moof@videogamemaps.net) - www.videogamemaps.net
	reworked by exi (exi@stc2.ath.cx)
	added moveable textsupport

	Converted to Khaos by <zespri@mail.ru>

	french translation by Veve (dominique@prevot.nom.fr)

	Just like the short desc says, short sweet and simple
	but now better

	V1.4r2
	 - Added Inline option
	 - fixed some minor bugs
	 - Changed some internals so it should work together with ArcaneBar now
	 - Now supplies a changed CastingBarFrame.xml, if you want you can put it to <wow>\Interface\FrameXML\CastingBarFrame.xml
	   This is a workaround for the progressbar displacement.
	
	$Id$
	$Rev 1.4$
	$LastChangedBy exi 20-08-2005 18:10 GMT+1$
	$Date$
]]--

-- initialise all variables
CastTime = { };
CastTime.delaySum = 0;
CastTime.endTime = 0;
CastTime.startTime = 0;
CastTime.sign = "+";
CastTime.print = 0;
CastTime.display = 1;
CastTime.delay = 1;
CastTime.hun = 1;
CastTime.flock = 0;
CastTime.outline = 1;
CastTime.mf = 0;
CastTime.spellname = "";
CastTime.inline = 0;

function CastTime_OnLoad()
	--Register events and all that good stuff.
	this:RegisterEvent("SPELLCAST_START");
	this:RegisterEvent("SPELLCAST_STOP");
	this:RegisterEvent("SPELLCAST_FAILED");
	this:RegisterEvent("SPELLCAST_INTERRUPTED");
	this:RegisterEvent("SPELLCAST_DELAYED");
	this:RegisterEvent("SPELLCAST_CHANNEL_START");
	this:RegisterEvent("SPELLCAST_CHANNEL_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	CastTimeFrame:Hide();
	if (CastTime_Register) then
		CastTime_Register();
	end	
end

function CastTime_OnEnter()
	if ( CastTime.flock == 0 ) then
		if ( this:GetCenter() < UIParent:GetCenter() ) then
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		else
			GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		end
		GameTooltip:SetText(CASTTIME_MF_TOOLTIP);
	end
end

function CastTime_OnEvent()
	--If beginning a spell, show the frame and reset the delaycount.
	if (event == "SPELLCAST_START") then
		CastTime.delaySum = 0;
		CastTime.spellname = arg1;
		CastTime.startTime = GetTime();
		CastTime.maxValue = CastTime.startTime + (arg2 / 1000);
		CastTimeFrame:Show();
	elseif (event == "SPELLCAST_CHANNEL_START") then
		CastTime.delaySum = 0;
		CastTime.spellname = arg2;
		CastTime.startTime = GetTime();
		CastTime.endTime = CastTime.startTime + (arg1 / 1000);
		CastTime.channeling = 1;
		CastTimeFrame:Show();
	elseif (event == "SPELLCAST_DELAYED") then
		CastTime.startTime = CastTime.startTime + (arg1 / 1000);
		CastTime.maxValue = CastTime.maxValue + (arg1 / 1000);
		CastTime.delaySum = CastTime.delaySum + arg1;
	elseif (event == "SPELLCAST_CHANNEL_UPDATE") then
		if ( arg1 == 0 or CastTime.endTime == nil ) then
			CastTime.delaySum = 0;
			CastTimeFrame:Hide();
			CastTimeText:SetText("");
			CastTimeMFText:SetText("");
		else
			local origDuration = CastTime.endTime - CastTime.startTime;
			local elapsedTime = GetTime() - CastTime.startTime;
			local losttime = origDuration*1000 - elapsedTime*1000 - arg1;
			CastTime.delaySum = CastTime.delaySum + losttime;
			CastTime.endTime = CastingBarFrame.endTime;
			CastTime.startTime = CastingBarFrame.startTime;
		end
	elseif (event == "SPELLCAST_STOP") then
		CastTime.delaySum = 0;
		CastTime.sign = "+";
		CastTime.channeling = false;
		CastTimeFrame:Hide();
		CastTimeText:SetText("");
		CastTimeMFText:SetText("");
	-- failed/interrupted
	else
		CastTime.delaySum = 0;
		CastTime.sign = "+";
		CastTime.channeling = false;
		CastTimeFrame:Hide();
		CastTimeText:SetText("");
		CastTimeMFText:SetText("");
	end
end

function CastTime_OnUpdate()
	--Set the timer to the current time, max 4 chars. > 100 sec, seconds
	--  only; > 10 sec, tenths; < 10 sec hundredths. Max is present to
	--  prevent timer from showing negative if UI is slow on updating the hide.

	if (CastTime.display == 0) then
		CastTimeText:SetText("");
		CastTimeMFText:SetText("");
		CastTimeFrame:Hide();
		return;
	end

	local current_time = CastTime.maxValue - GetTime();
	if (CastTime.channeling) then
		current_time = CastTime.endTime - GetTime();
	end

	local subto = 4;
	if (current_time < 10 and CastTime.hun == 0) then
		subto = 3;
	end

	if (current_time <= 0) then
		CastTimeText:SetText("");
		CastTimeMFText:SetText("");
		CastingBarText:SetText(CastTime.spellname);
		return;
	end
	local text = string.sub(math.max(current_time,0)+0.001, 1, subto);
	if (CastTime.delaySum ~= 0) then
		local delay = string.sub(math.max(CastTime.delaySum/1000, 0)+0.001, 1, subto);

		if (CastingBarFrame.channeling == 1) then
			CastTime.sign = "-";
		end
		if (delay ~= "0.00" and delay ~= "0.0") then
			text = "|cffcc0000"..CastTime.sign..delay.."|r "..text;
		end
	end
	if (CastTime.mf == 1) then
		CastTimeMFText:SetText(text);
	end
	if (CastTime.outline == 1) then
		CastTimeText:SetText(text);
	end
	if (CastTime.inline == 1) then
		CastingBarText:SetText(CastTime.spellname.." ("..text..")");
	end
end
