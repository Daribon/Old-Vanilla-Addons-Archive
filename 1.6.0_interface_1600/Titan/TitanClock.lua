-- Constants
TITAN_CLOCK_ID = "Clock";
TITAN_CLOCK_FORMAT_12H = "12H";
TITAN_CLOCK_FORMAT_24H = "24H";
TITAN_CLOCK_FREQUENCY = 0.5;
TITAN_CLOCK_FRAME_SHOW_TIME = 0.5;

--Nurfed Additions (based on Sudo's Changes to other clocks)
local Nurfed_lastmin = 0;
NURFED_TIME = 0;
local Nurfed_TIME_TWENTYFOURHOURS = "%d:%02d:%02d";
local Nurfed_TIME_TWELVEHOURAM = "%d:%02d:%02d AM";
local Nurfed_TIME_TWELVEHOURPM = "%d:%02d:%02d PM";

function TitanPanelClockButton_OnLoad()
	this.registry = {
		id = TITAN_CLOCK_ID,
		builtIn = 1,
		menuText = TITAN_CLOCK_MENU_TEXT, 
		buttonTextFunction = "TitanPanelClockButton_GetButtonText",
		tooltipTitle = TITAN_CLOCK_TOOLTIP, 
		tooltipTextFunction = "TitanPanelClockButton_GetTooltipText", 
		frequency = TITAN_CLOCK_FREQUENCY, 
		updateType = TITAN_PANEL_UPDATE_BUTTON,
		savedVariables = {
			OffsetHour = 0,
			Format = TITAN_CLOCK_FORMAT_12H,
			DisplayOnRightSide = 1,
		}
	};
end

function TitanPanelClockButton_GetButtonText()
	-- Calculate the hour/minutes considering the offset
	local hour, minute = GetGameTime();

	-- Nurfed
	if (minute ~= Nurfed_lastmin) then
		NURFED_TIME = GetTime();
		Nurfed_lastmin = minute;
	end
	-- Nurfed

	hour = hour + TitanGetVar(TITAN_CLOCK_ID, "OffsetHour");
	if( hour > 23 ) then
		hour = hour - 24;
	elseif( hour < 0 ) then
		hour = 24 + hour;
	end
	
	-- Calculate the display text based on format 12H/24H 
	if (TitanGetVar(TITAN_CLOCK_ID, "Format") == TITAN_CLOCK_FORMAT_12H) then
		local isAM;
		if (hour >= 12) then
			isAM = false;
			hour = hour - 12;
		else
			isAM = true;
		end
		if (hour == 0) then
			hour = 12;
		end
		if (isAM) then
			return format(TEXT(Nurfed_TIME_TWELVEHOURAM), hour, minute, GetTime() - NURFED_TIME);
			--return nil, format(TEXT(TIME_TWELVEHOURAM), hour, minute);
		else
			return format(TEXT(Nurfed_TIME_TWELVEHOURPM), hour, minute, GetTime() - NURFED_TIME);
			--return nil, format(TEXT(TIME_TWELVEHOURPM), hour, minute);
		end
	else
		return format(TEXT(Nurfed_TIME_TWENTYFOURHOURS), hour, minute, GetTime() - NURFED_TIME);
		--return nil, format(TEXT(TIME_TWENTYFOURHOURS), hour, minute);
	end
	
end

function TitanPanelClockButton_GetTooltipText()
	local clockText = TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"));	
	return ""..
		TITAN_CLOCK_TOOLTIP_VALUE.."\t"..TitanUtils_GetHighlightText(clockText).."\n"..
		TitanUtils_GetGreenText(TITAN_CLOCK_TOOLTIP_HINT1).."\n"..
		TitanUtils_GetGreenText(TITAN_CLOCK_TOOLTIP_HINT2);
end

function TitanPanelClockControlSlider_OnEnter()
	this.tooltipText = TitanOptionSlider_TooltipText(TITAN_CLOCK_CONTROL_TOOLTIP, TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(this:GetParent());
end

function TitanPanelClockControlSlider_OnLeave()
	this.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(this:GetParent(), TITAN_CLOCK_FRAME_SHOW_TIME);
end

function TitanPanelClockControlSlider_OnShow()
	getglobal(this:GetName().."Text"):SetText(TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
	getglobal(this:GetName().."High"):SetText(TITAN_CLOCK_CONTROL_LOW);
	getglobal(this:GetName().."Low"):SetText(TITAN_CLOCK_CONTROL_HIGH);
	this:SetMinMaxValues(-12, 12);
	this:SetValueStep(1);
	this:SetValue(0 - TitanGetVar(TITAN_CLOCK_ID, "OffsetHour"));
end

function TitanPanelClockControlSlider_OnValueChanged()
	getglobal(this:GetName().."Text"):SetText(TitanPanelClock_GetOffsetText(0 - this:GetValue()));
	TitanSetVar(TITAN_CLOCK_ID, "OffsetHour", 0 - this:GetValue())
	TitanPanelButton_UpdateButton(TITAN_CLOCK_ID);

	-- Update GameTooltip
	if (this.tooltipText) then
		this.tooltipText = TitanOptionSlider_TooltipText(TITAN_CLOCK_CONTROL_TOOLTIP, TitanPanelClock_GetOffsetText(TitanGetVar(TITAN_CLOCK_ID, "OffsetHour")));
		GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
	end
end

function TitanPanelClockControlCheckButton_OnShow()	
	TitanPanelClockControlCheckButtonText:SetText(TITAN_CLOCK_CHECKBUTTON);
	
	if (TitanGetVar(TITAN_CLOCK_ID, "Format") == TITAN_CLOCK_FORMAT_24H) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
	end
end

function TitanPanelClockControlCheckButton_OnClick()
	if (this:GetChecked()) then
		TitanSetVar(TITAN_CLOCK_ID, "Format", TITAN_CLOCK_FORMAT_24H);
	else
		TitanSetVar(TITAN_CLOCK_ID, "Format", TITAN_CLOCK_FORMAT_12H);
	end
	TitanPanelButton_UpdateButton(TITAN_CLOCK_ID);
end

function TitanPanelClockControlCheckButton_OnEnter()
	this.tooltipText = TITAN_CLOCK_CHECKBUTTON_TOOLTIP;
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(this:GetParent());
end

function TitanPanelClockControlCheckButton_OnLeave()
	this.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(this:GetParent(), TITAN_CLOCK_FRAME_SHOW_TIME);
end

function TitanPanelClock_GetOffsetText(offset)
	if (offset > 0) then
		return "+" .. tostring(offset);
	else
		return tostring(offset);
	end
end

function TitanPanelClockControlFrame_OnLoad()
	getglobal(this:GetName().."Title"):SetText(TITAN_CLOCK_CONTROL_TITLE);
	this:SetBackdropBorderColor(1, 1, 1);
	this:SetBackdropColor(0, 0, 0, 1);
end

function TitanPanelClockControlFrame_OnUpdate(elapsed)
	TitanUtils_CheckFrameCounting(this, elapsed);
end

function TitanPanelRightClickMenu_PrepareClockMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_CLOCK_ID].menuText);
	
	info = {};
	info.text = TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE;
	info.func = TitanPanelClockButton_ToggleRightSideDisplay;
	info.checked = TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide");
	UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();	
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_CLOCK_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelClockButton_ToggleRightSideDisplay()
	TitanPanel_RemoveButton(TITAN_CLOCK_ID);
	TitanToggleVar(TITAN_CLOCK_ID, "DisplayOnRightSide");
	TitanPanel_AddButton(TITAN_CLOCK_ID);
--	TitanPanelButton_UpdateButton(TITAN_BAG_ID);
end