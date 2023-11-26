function CT_Timer_OnMouseOver()
	this.step = 0.01;
end

function CT_Timer_OnMouseOut()
	this.step = -0.01;
end

function CT_Timer_OnUpdate(elapsed)
	if ( this.step ) then
		this.alpha = this.alpha + this.step;
		if ( this.alpha > 1 ) then
			this.alpha = 1;
			this.step = nil;
		elseif ( this.alpha < 0.35 ) then
			this.alpha = 0.35;
			this.step = nil;
		end
		getglobal(this:GetParent():GetName() .. "Reset"):SetAlpha(this.alpha);
	end
end

function CT_Timer_Toggle(btn)
	if ( not btn ) then btn = this:GetParent(); end
	if (btn.status and btn.status == 1 ) then
		btn.status = 0;
		getglobal(btn:GetName() .. "Time"):SetTextColor(1, 0.5, 0);
	else
		if ( not btn.status ) then
			if ( btn.time > 0 ) then
				btn.countfrom = CT_Timer_GetTimeString(btn.time);
				btn.step = -1;
			else
				btn.step = 1;
			end
		end
		getglobal(btn:GetName() .. "Time"):SetTextColor(0, 1, 0);
		btn.status = 1;
	end
end

function CT_Timer_UpdateTime(elapsed)
	if ( not CT_TimerFrame.status or CT_TimerFrame.status == 0 ) then return; end
	if ( not CT_TimerFrame.update ) then
		CT_TimerFrame.update = elapsed;
	else
		CT_TimerFrame.update = CT_TimerFrame.update + elapsed;
	end

	if ( CT_TimerFrame.update > 1 ) then
		CT_TimerFrame.time = CT_TimerFrame.time + CT_TimerFrame.step;
		if ( CT_TimerFrame.time == 0 ) then
			DEFAULT_CHAT_FRAME:AddMessage(string.gsub(CT_TIMER_FINISHCOUNT, "'<time>'", CT_TimerFrame.countfrom), 1, 0.5, 0);
			PlaySound("TellMessage");
			CT_Timer_Reset();
		else
			CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
		end
		CT_TimerFrame.update = 1 - CT_TimerFrame.update;
	end
end

function CT_Timer_SetTime(num, field)
	if ( not num ) then return; end
	local hours, mins, secs, temp;

	if ( num >= 3600 ) then
		hours = floor(num / 3600);
		temp = num - (hours*3600);
		mins = floor(temp / 60);
		secs = temp - (mins*60);
	elseif ( num >= 60 ) then
		hours = 0;
		mins = floor(num / 60);
		secs = num - (mins*60);
	else
		hours = 0;
		mins = 0;
		secs = num;
	end
	if ( not field.showsecs ) then
		getglobal(field:GetName() .. "Time"):SetText(CT_Timer_AddZeros(hours) .. ":" .. CT_Timer_AddZeros(mins));
	else
		getglobal(field:GetName() .. "Time"):SetText(CT_Timer_AddZeros(hours) .. ":" .. CT_Timer_AddZeros(mins) .. ":" .. CT_Timer_AddZeros(secs));
	end
	if ( CT_TimerFrame.time < 60 ) then
		CT_TimerFrameScrollDownMin:Disable();
		CT_TimerFrameScrollDownHour:Disable();
	elseif ( CT_TimerFrame.time < 3600 ) then
		CT_TimerFrameScrollDownHour:Disable();
		CT_TimerFrameScrollDownMin:Enable();
	else
		CT_TimerFrameScrollDownMin:Enable();
		CT_TimerFrameScrollDownHour:Enable();
	end
end

function CT_Timer_GetTimeString(num)

	local hours, mins, secs;

	if ( num >= 3600 ) then
		hours = floor(num / 3600);
		mins = floor(mod(num, 3600) / 60);
	else
		hours = 0;
		mins = floor(num / 60);
	end

	if ( hours == 0 ) then
		if ( mins == 1 ) then
			return "1 " .. CT_TIMER_MIN;
		else
			return mins .. " " .. CT_TIMER_MINS;
		end
	else
		local str;
		if ( hours == 1 ) then
			str = "1 " .. CT_TIMER_HOUR;
		else
			str = hours .. " " .. CT_TIMER_HOURS;
		end
		if ( mins == 0 ) then
			return str;
		elseif ( mins == 1 ) then
			return str .. " and 1 " .. CT_TIMER_MIN;
		else
			return str .. " and " .. mins .. CT_TIMER_MINS;
		end
	end
end

function CT_Timer_AddZeros(num)
	if ( strlen(num) == 1 ) then
		return "0" .. num;
	elseif ( strlen(num) == 2 ) then
		return num;
	else
		return "--";
	end
end

function CT_Timer_ModTime(num)
	this:GetParent().time = this:GetParent().time + num;
	if ( this:GetParent().time < 0 ) then
		this:GetParent().time = 0;
	end
	CT_Timer_SetTime(this:GetParent().time, this:GetParent());
end

function CT_Timer_Reset()
	CT_TimerFrameTime:SetTextColor(1, 0, 0);
	CT_TimerFrame.status = nil;
	CT_TimerFrame.time = 0;
	CT_TimerFrame.countfrom = nil;
	CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
end

if ( CT_RegisterMod ) then
	local function func(modId)
		local val = CT_Mods[modId]["modStatus"];
		if ( val == "on" ) then
			CT_Print("<CTMod> " .. CT_TIMER_SHOWSECS_ON, 1, 1, 0);
			CT_TimerFrame.showsecs = 1;
		else
			CT_Print("<CTMod> " .. CT_TIMER_SHOWSECS_OFF, 1, 1, 0);
			CT_TimerFrame.showsecs = nil;
		end
		CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
	end
	local function initfunc(modId)
		local val = CT_Mods[modId]["modStatus"];
		if ( val == "on" ) then
			CT_TimerFrame.showsecs = 1;
		else
			CT_TimerFrame.showsecs = nil;
		end
		CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
	end
	local function modfunc(modId)
		local val = CT_Mods[modId]["modStatus"];
		if ( val == "on" ) then
			CT_Print("<CTMod> " .. CT_TIMER_SHOW_ON, 1, 1, 0);
			CT_TimerFrame:Show();
		else
			CT_Print("<CTMod> " .. CT_TIMER_SHOW_OFF, 1, 1, 0);
			CT_TimerFrame:Hide();
		end
	end
	local function modinitfunc(modId)
		local val = CT_Mods[modId]["modStatus"];
		if ( val == "on" ) then
			CT_TimerFrame:Show();
		else
			CT_TimerFrame:Hide();
		end
	end

	CT_RegisterMod(	CT_TIMER_MODNAME,
					CT_TIMER_SUBNAME,
					5,
					"Interface\\Icons\\INV_Misc_Key_02",
					CT_TIMER_TOOLTIP,
					"off",
					nil,
					modfunc,
					modinitfunc
	);

	CT_RegisterMod(	CT_TIMERSECS_MODNAME,
					CT_TIMERSECS_SUBNAME,
					5,
					"Interface\\Icons\\INV_Misc_Key_01",
					CT_TIMERSECS_TOOLTIP,
					"on",
					nil,
					func,
					initfunc
	);
end

CT_Timer_ShowTimer = 1;
CT_Timer_ShowSeconds = 1;
RegisterForSave("CT_Timer_ShowTimer");
RegisterForSave("CT_Timer_ShowSeconds");

SlashCmdList["TIMER"] = function(msg)
	if ( msg == "" ) then
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_HELP[1], 1, 1, 0);
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_HELP[2], 1, 1, 0);
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_HELP[3], 1, 1, 0);
	elseif ( msg == "show" ) then
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_SHOW_ON, 1, 1, 0);
		CT_TimerFrame:Show();
		if ( CT_RegisterMod ) then
			CT_SetModStatus("Timer Mod", "on");
		end
		CT_Timer_ShowTimer = 1;
	elseif ( msg == "hide" ) then
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_SHOW_OFF, 1, 1, 0);
		CT_TimerFrame:Hide();
		if ( CT_RegisterMod ) then
			CT_SetModStatus("Timer Mod", "off");
		end
		CT_Timer_ShowTimer = 0;
	elseif ( msg == "secs on" ) then
		CT_TimerFrame.showsecs = 1;
		if ( CT_RegisterMod ) then
			CT_SetModStatus("Timer Seconds", "on");
		end
		CT_Timer_ShowSeconds = 1;
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_SHOWSECS_ON, 1, 1, 0);
		CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
	elseif ( msg == "secs off" ) then
		CT_TimerFrame.showsecs = nil;
		DEFAULT_CHAT_FRAME:AddMessage("<CTMod> " .. CT_TIMER_SHOWSECS_OFF, 1, 1, 0);
		if ( CT_RegisterMod ) then
			CT_SetModStatus("Timer Seconds", "off");
		end
		CT_Timer_ShowSeconds = 0;
		CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
	else
		SlashCmdList["TIMER"]("");
	end
end

SLASH_TIMER1 = "/timer";
SLASH_TIMER2 = "/tr";

function CT_Timer_OnEvent(event)
	if ( event == "VARIABLES_LOADED" and not CT_RegisterMod ) then
		if ( CT_Timer_ShowTimer == 1 ) then
			CT_TimerFrame:Show();
		else
			CT_TimerFrame:Hide();
		end
		if ( CT_Timer_ShowSeconds == 1 ) then
			CT_TimerFrame.showsecs = 1;
		else
			CT_TimerFrame.showsecs = nil;
		end
		CT_Timer_SetTime(CT_TimerFrame.time, CT_TimerFrame);
	end
end