UIPanelWindows["AlarmClockFrame"] =		{ area = "left",	pushable = 10 };

-- Constants
AlarmClockState_Off     = 0;
AlarmClockState_On      = 1;
AlarmClockState_Ringing = 2;

MessageIntervals = {};
MessageIntervals[0] = { time =  30, text = ALARM_INTERVAL1	};
MessageIntervals[1] = { time =  60, text = ALARM_INTERVAL2	};
MessageIntervals[2] = { time = 120, text = ALARM_INTERVAL3	};
MessageIntervals[3] = { time = 300, text = ALARM_INTERVAL4	};
MessageIntervals[4] = { time = 600, text = ALARM_INTERVAL5	};
MessageIntervals[5] = { time = 900, text = ALARM_INTERVAL6 	};
MessageIntervalCount = 6;

-- Variables
AlarmState = AlarmClockState_Off;
AlarmHour = 0;
AlarmMinute = 0;

TimerState = AlarmClockState_Off;
TimerHours = 0;
TimerMinutes = 0;
TimerSeconds = 0;
LastTimerUpdate = 0;

RepeatMessages = 0;
RepeatMessageInterval = 3;
LastAlarmMessage = 0;
LastTimerMessage = 0;
TimerElapsed = 0;

-- CVars
AlarmClockCVar = "AlarmClockSettings";

-- Functions
function AlarmClock_SaveState()
    local settings = format(
        "A%1d_%02d:%02d_T%1d_%02d:%02d:%02d_Opt%1d%1d",
        AlarmState, AlarmHour, AlarmMinute,
        TimerState, TimerHours, TimerMinutes, TimerSeconds,
        RepeatMessages, RepeatMessageInterval
    );
    Cosmos_SetCVar(AlarmClockCVar, settings);
end

--[[ Useless ...
IntStrTable = {};
IntStrTable["0"] = 0;
IntStrTable["1"] = 1;
IntStrTable["2"] = 2;
IntStrTable["3"] = 3;
IntStrTable["4"] = 4;
IntStrTable["5"] = 5;
IntStrTable["6"] = 6;
IntStrTable["7"] = 7;
IntStrTable["8"] = 8;
IntStrTable["9"] = 9;

function AlarmClock_IntValFromSettings(text)
	local val = IntStrTable[text];
    if (val == nil) then
        val = 0;
    end
    return val;
]]
function AlarmClock_IntValFromSettings(text)
	return text * 1;
end

function AlarmClock_TimeValFromSettings(text)
    local ten = AlarmClock_IntValFromSettings(strsub(text, 1, 1));
    local one = AlarmClock_IntValFromSettings(strsub(text, 2, 2));
    return 10*ten + one;
end

function AlarmClock_LoadState()
    Cosmos_RegisterCVar(AlarmClockCVar, "");
    local settings = Cosmos_GetCVar(AlarmClockCVar);

    if ( not settings ) then return end
 
    local len = strlen(settings);
	if (not len) then
		return;
    elseif (len ~= 26) then
        return;
    end
    
    AlarmState   = AlarmClock_IntValFromSettings (strsub(settings,  2, 2));
    AlarmHour    = AlarmClock_TimeValFromSettings(strsub(settings,  4, 5));
    AlarmMinute  = AlarmClock_TimeValFromSettings(strsub(settings,  7, 8));
    
    TimerState   = AlarmClock_IntValFromSettings (strsub(settings, 11, 11));
    TimerHours   = AlarmClock_TimeValFromSettings(strsub(settings, 13, 14));
    TimerMinutes = AlarmClock_TimeValFromSettings(strsub(settings, 16, 17));
    TimerSeconds = AlarmClock_TimeValFromSettings(strsub(settings, 19, 20));
    
    RepeatMessages        = AlarmClock_IntValFromSettings(strsub(settings, 25, 25));
    RepeatMessageInterval = AlarmClock_IntValFromSettings(strsub(settings, 26, 26));
end

function ToggleAlarmClock()
	if ( AlarmClockFrame:IsVisible() ) then
		HideUIPanel(AlarmClockFrame);
	else
		ShowUIPanel(AlarmClockFrame);
	end
end

function AlarmClock_OnLoad()
	Cosmos_RegisterButton(ALARM_BUTTON_TITLE, ALARM_BUTTON_SUBTITLE, ALARM_BUTTON_TIP, "Interface\\Icons\\INV_Misc_PocketWatch_01", ToggleAlarmClock);

    AlarmClockPortrait:SetTexture("Interface\\Icons\\INV_Misc_PocketWatch_01");
    
    AlarmClock_LoadState();
    LastTimerUpdate = GetTime();
    
    AlarmClock_UpdateAlarmTime();
    AlarmClock_UpdateAlarmState();
    AlarmClock_UpdateTimerTime();
    AlarmClock_UpdateTimerState();
    RepeatMessageCheck:SetChecked(RepeatMessages);
    AlarmClock_UpdateMessageRepeatTime();
end

function AlarmClock_OnShow()
	AlarmClock_UpdateAlarmTime();
    PlaySound("igMainMenuOpen");
end

function AlarmClock_OnHide()
    PlaySound("igMainMenuClose");
end

function AlarmClock_OnEvent(event)
end

function AlarmClock_OnUpdate()
    AlarmClock_UpdateTimer();
    AlarmClock_CheckAlarm();
    AlarmClock_CheckTimer();
end

function AlarmClock_OnUpdateFrame()
    AlarmClock_UpdateCurrentTime();
    AlarmClock_UpdateTimerTime();
end

function AlarmClock_GetTimeText(hour, minute)
	local pm;

	if( AlarmClock_GetMilitaryTime() == 1 ) then
		return format(TEXT(TIME_TWENTYFOURHOURS), hour, minute);
	else
		if( hour >= 12 ) then
			pm = 1;
			hour = hour - 12;
		else
			pm = 0;
		end
		if( hour == 0 ) then
			hour = 12;
		end
		if( pm == 1 ) then
			return format(TEXT(TIME_TWELVEHOURPM), hour, minute);
		else
			return format(TEXT(TIME_TWELVEHOURAM), hour, minute);
		end
	end
end

function AlarmClock_UpdateCurrentTime()
    local hour, minute = AlarmClock_GetGameTime();
	local time = (hour * 60) + minute;
	if (time ~= this.timeOfDay) then
        this.timeOfDay = time;
		ACTextCurTime:SetText(AlarmClock_GetTimeText(hour, minute));
    end
end

function AlarmClock_UpdateAlarmTime()
    ACTextAlarmTime:SetText(AlarmClock_GetTimeText(AlarmHour, AlarmMinute));
end

function AlarmClock_UpdateAlarmState()
    if (AlarmState == AlarmClockState_Off) then
        ACTextAlarmStatus:SetText(ALARM_OFF);
        AlarmStartButton:Enable();
        AlarmStopButton:Disable();
    elseif (AlarmState == AlarmClockState_On) then
        ACTextAlarmStatus:SetText(ALARM_ON);
        AlarmStartButton:Disable();
        AlarmStopButton:Enable();
    elseif (AlarmState == AlarmClockState_Ringing) then
        ACTextAlarmStatus:SetText(ALARM_RINGING);
        AlarmStartButton:Disable();
        AlarmStopButton:Enable();
    end
end

function AlarmClock_AlarmStart()
    AlarmState = AlarmClockState_On;
    AlarmClock_UpdateAlarmState();
    AlarmClock_SaveState();
end

function AlarmClock_AlarmStop()
    AlarmState = AlarmClockState_Off;
    AlarmClock_UpdateAlarmState();
    AlarmClock_SaveState();
end

function AlarmClock_AlarmHourChange(delta)
    AlarmHour = AlarmHour + delta;
    if (AlarmHour < 0) then
        AlarmHour = AlarmHour + 24;
    elseif (AlarmHour > 23) then
        AlarmHour = AlarmHour - 24;
    end
    AlarmClock_UpdateAlarmTime();
    AlarmClock_SaveState();
end

function AlarmClock_AlarmMinuteChange(delta)
    AlarmMinute = AlarmMinute + delta;
    if (AlarmMinute < 0) then
        AlarmMinute = AlarmMinute + 60;
    elseif (AlarmMinute > 59) then
        AlarmMinute = AlarmMinute - 60;
    end
    AlarmClock_UpdateAlarmTime();
    AlarmClock_SaveState();
end

function AlarmClock_UpdateTimerTime()
    local text = format("%02d:%02d:%02d", TimerHours, TimerMinutes, TimerSeconds);
    ACTextTimerTime:SetText(text);
end

function AlarmClock_UpdateTimerState()
    if (TimerState == AlarmClockState_Off) then
        ACTextTimerStatus:SetText(ALARM_OFF);
        TimerStartButton:Enable();
        TimerStopButton:Disable();
    elseif (TimerState == AlarmClockState_On) then
        ACTextTimerStatus:SetText(ALARM_ON);
        TimerStartButton:Disable();
        TimerStopButton:Enable();
    elseif (TimerState == AlarmClockState_Ringing) then
        ACTextTimerStatus:SetText(ALARM_RINGING);
        TimerStartButton:Disable();
        TimerStopButton:Enable();
    end
end

function AlarmClock_TimerStart()
    TimerState = AlarmClockState_On;
    AlarmClock_UpdateTimerState();
    AlarmClock_SaveState();
end

function AlarmClock_TimerStop()
    TimerState = AlarmClockState_Off;
    AlarmClock_UpdateTimerState();
    AlarmClock_SaveState();
end

function AlarmClock_TimerHourChange(delta)
    TimerHours = TimerHours + delta;
    if (TimerHours < 0) then
        TimerHours = 0;
    end
    if (TimerHours > 99) then
        TimerHours = 99;
    end
    AlarmClock_UpdateTimerTime();
    AlarmClock_SaveState();
end

function AlarmClock_TimerMinuteChange(delta)
    TimerMinutes = TimerMinutes + delta;
    if (TimerMinutes < 0) then
        TimerMinutes = TimerMinutes + 60;
    elseif (TimerMinutes > 59) then
        TimerMinutes = TimerMinutes - 60;
    end
    AlarmClock_UpdateTimerTime();
    AlarmClock_SaveState();
end

function AlarmClock_TimerSecondChange(delta)
    TimerSeconds = TimerSeconds + delta;
    if (TimerSeconds < 0) then
        TimerSeconds = TimerSeconds + 60;
    elseif (TimerSeconds > 59) then
        TimerSeconds = TimerSeconds - 60;
    end
    AlarmClock_UpdateTimerTime();
    AlarmClock_SaveState();
end

function AlarmClock_GetHMS(totTime)
    local total = totTime;
    local hours = 0;
    while (total >= 3600) do
        hours = hours + 1;
        total = total - 3600;
    end
    
    local minutes = 0;
    while (total >= 60) do
        minutes = minutes + 1;
        total = total - 60;
    end
    
    local seconds = total;

    return hours, minutes, seconds;
end

function AlarmClock_UpdateTimer()
    local curTime = GetTime();
    local delta = curTime - LastTimerUpdate;
    if (delta < 1) then
        return;
    end
    
    LastTimerUpdate = curTime;
    if (TimerState ~= AlarmClockState_On) then
        return;
    end
    
    local totTime = TimerHours*3600 + TimerMinutes*60 + TimerSeconds;
    
    while (delta > 1) do
        totTime = totTime - 1;
        delta = delta - 1;
    end
    
    if (totTime < 0) then
        totTime = 0;
    end
    
    TimerHours, TimerMinutes, TimerSeconds = AlarmClock_GetHMS(totTime);
    AlarmClock_SaveState();
end

function AlarmClock_SetRepeatMessage(val)
    if (RepeatMessages == val) then
        return;
    end
    
    RepeatMessages = val;
    AlarmClock_SaveState();
end

function AlarmClock_UpdateMessageRepeatTime()
    ACTextRepeatTimeLabel:SetText(MessageIntervals[RepeatMessageInterval].text);
end

function AlarmClock_MessageRepeatTimeChange(delta)
    RepeatMessageInterval = RepeatMessageInterval + delta;
    if (RepeatMessageInterval < 0) then
        RepeatMessageInterval = RepeatMessageInterval + MessageIntervalCount;
    elseif (RepeatMessageInterval >= MessageIntervalCount) then
        RepeatMessageInterval = RepeatMessageInterval - MessageIntervalCount;
    end
    
    AlarmClock_UpdateMessageRepeatTime();
    AlarmClock_SaveState();
end

function AlarmClock_CheckAlarm()
    if (AlarmState == AlarmClockState_On) then
        local hour, minute = AlarmClock_GetGameTime();
        if (hour == AlarmHour and minute == AlarmMinute) then
            AlarmState = AlarmClockState_Ringing;
            LastAlarmMessage = 0;
            AlarmClock_UpdateAlarmState();
        end
    end
    
    if (AlarmState == AlarmClockState_Ringing) then
        if (LastAlarmMessage == 0) then
            AlarmClock_SendAlarmMessage();
            LastAlarmMessage = GetTime();
        elseif (RepeatMessages == 1) then
            local interval = MessageIntervals[RepeatMessageInterval].time;
            if (interval > 0) then
                local time = GetTime();
                if (time - LastAlarmMessage > interval) then
                    AlarmClock_SendAlarmMessage();
                    LastAlarmMessage = GetTime();
                end
            end
        end
    end
end

function AlarmClock_CheckTimer()
    if (TimerState == AlarmClockState_On) then
        local totTime = TimerHours*3600 + TimerMinutes*60 + TimerSeconds;
        if (totTime == 0) then
            TimerState = AlarmClockState_Ringing;
            LastTimerMessage = 0;
            AlarmClock_UpdateTimerState();
        end
    end
    
    if (TimerState == AlarmClockState_Ringing) then
        if (LastTimerMessage == 0) then
            AlarmClock_SendTimerMessage(0);
            LastTimerMessage = GetTime();
            TimerElapsed = 0;
        elseif (RepeatMessages == 1) then
            local interval = MessageIntervals[RepeatMessageInterval].time;
            if (interval > 0) then
                local time = GetTime();
                if (time - LastTimerMessage >= interval) then
                    TimerElapsed = TimerElapsed + interval;
                    AlarmClock_SendTimerMessage(TimerElapsed);
                    LastTimerMessage = GetTime();
                end
            end
        end
    end
end

function AlarmClock_SendAlarmMessage()
    local hour, minute = AlarmClock_GetGameTime();
    local timeText = AlarmClock_GetTimeText(hour, minute);
    AlarmClock_SendMessage(format(ALARM_TIMENOW, timeText));
end

function AlarmClock_SendTimerMessage(elapsed)
    local h, m, s = AlarmClock_GetHMS(elapsed);
    local timeText = "";
    
    if (h > 0) then
        timeText = format(" (+%02d:%02d:%02d)", h, m, s);
    elseif (m > 0 or s > 0) then
        timeText = format(" (+%02d:%02d)", m, s);
    end
	
	if (elapsed == 0) then
	    AlarmClock_SendMessage(ALARM_TIMEREXPIRED1);
	else
	    AlarmClock_SendMessage(format(ALARM_TIMEREXPIRED, timeText));
	end
end

function AlarmClock_SendMessage(msg)
    local info = ChatTypeInfo["SYSTEM"];
	ChatFrame1:AddMessage(msg, info.r, info.g, info.b, info.id);
    PlaySound("TellMessage");
end


-- thanks to Telo for his Clock AddOn!
function AlarmClock_GetOffsetTime()
	local value = false;
	if ( Cosmos_GetCVar ) then
		value = Cosmos_GetCVar("COS_CLOCK_OFFSET");
	end
	local OffsetHour = 0;
	local OffsetMinute = 0;
	if ( value ) then
		OffsetHour = value;
		if( OffsetHour > 0 ) then
			OffsetHour = math.floor(value);
		else
			OffsetHour = math.ceil(value);
		end
		OffsetMinute = (value - OffsetHour) * 60;
	end
	return OffsetHour, OffsetMinute;
end

function AlarmClock_GetMilitaryTime()
	local militaryTime = 0;
	if ( Cosmos_GetCVar ) then
		militaryTime = Cosmos_GetCVar("COS_CLOCK_TWENTYFOUR_HOURS_X");
		if ( militaryTime == nil ) then
			militaryTime = 0;
		end
	end
	return militaryTime;
end

function AlarmClock_GetGameTime()
	local OffsetHour, OffsetMinute = AlarmClock_GetOffsetTime();
	local hour, minute = GetGameTime();

	hour = hour + OffsetHour;
	minute = minute + OffsetMinute;
	if( minute > 59 ) then
		minute = minute - 60;
		hour = hour + 1;
	elseif( minute < 0 ) then
		minute = 60 + minute;
		hour = hour - 1;
	end
	if( hour > 23 ) then
		hour = hour - 24;
	elseif( hour < 0 ) then
		hour = 24 + hour;
	end
	
	return hour, minute;
end