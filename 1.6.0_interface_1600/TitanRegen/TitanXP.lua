TITAN_XP_ID = "XP";
TITAN_XP_FREQUENCY = 1;

function TitanPanelXPButton_OnLoad()
	this.registry = { 
		id = TITAN_XP_ID,
		menuText = TITAN_XP_MENU_TEXT, 
		buttonTextFunction = "TitanPanelXPButton_GetButtonText",
		tooltipTitle = TITAN_XP_TOOLTIP, 
		tooltipTextFunction = "TitanPanelXPButton_GetTooltipText",
		frequency = TITAN_XP_FREQUENCY, 
		savedVariables = {
			ShowXPPerHourSession = 1,
			ShowLabelText = 1,
		}
	};

	this.timer = 0;	
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("PLAYER_LEVEL_UP");
end

function TitanPanelXPButton_OnEvent()
	if (event == "PLAYER_ENTERING_WORLD") then		
		this.initXP = UnitXP("player");
		this.accumXP = 0;
		this.sessionXP = 0;
	elseif (event == "PLAYER_XP_UPDATE") then
		if (not this.initXP) then
			this.initXP = UnitXP("player");
			this.accumXP = 0;
			this.sessionXP = 0;
		end
		this.sessionXP = UnitXP("player") - this.initXP + this.accumXP;
	elseif (event == "PLAYER_LEVEL_UP") then
		this.accumXP = this.accumXP + UnitXPMax("player") - this.initXP;
		this.initXP = 0;
	end
end

function TitanPanelXPButton_GetButtonText(id)
	local button, id = TitanUtils_GetButton(id, true);
	local totalXP = UnitXPMax("player");
	local currentXP = UnitXP("player");
	local toLevelXP = totalXP - currentXP;	
	local sessionXP = button.sessionXP;
	local xpPerHour, xpPerHourText, timeToLevel, timeToLevelText;	
	local sessionTime = TitanUtils_GetSessionTime();
	local levelTime = TitanUtils_GetLevelTime();
	
	if (levelTime) then
		if (TitanGetVar(TITAN_XP_ID, "ShowXPPerHourSession")) then		
			xpPerHour = sessionXP / sessionTime * 3600;
			timeToLevel = TitanUtils_Ternary((sessionXP == 0), -1, toLevelXP / sessionXP * sessionTime);
		
			xpPerHourText = format(TITAN_XP_FORMAT, xpPerHour);
			timeToLevelText = TitanUtils_GetEstTimeText(timeToLevel)
		
			return "XP: ", TitanUtils_GetHighlightText(currentXP),
				" / ", TitanUtils_GetHighlightText(totalXP);
		else
			xpPerHour = currentXP / levelTime * 3600;
			timeToLevel = TitanUtils_Ternary((currentXP == 0), -1, toLevelXP / currentXP * levelTime);
		
			xpPerHourText = format(TITAN_XP_FORMAT, xpPerHour);
			timeToLevelText = TitanUtils_GetEstTimeText(timeToLevel)
		
			return TITAN_XP_BUTTON_LABEL_XPHR_LEVEL, TitanUtils_GetHighlightText(xpPerHourText),
				TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_LEVEL, TitanUtils_GetHighlightText(timeToLevelText);
		end
	end
end

function TitanPanelXPButton_GetTooltipText()
	local totalTime = TitanUtils_GetTotalTime();
	local sessionTime = TitanUtils_GetSessionTime();
	local levelTime = TitanUtils_GetLevelTime();
	local totalXP = UnitXPMax("player");
	local currentXP = UnitXP("player");
	local toLevelXP = totalXP - currentXP;
	local currentXPPercent = currentXP / totalXP * 100;
	local toLevelXPPercent = toLevelXP / totalXP * 100;
	local xpPerHourThisLevel = currentXP / levelTime * 3600;
	local xpPerHourThisSession = this.sessionXP / sessionTime * 3600;
	local estTimeToLevelThisLevel = TitanUtils_Ternary((currentXP == 0), -1, toLevelXP / currentXP * levelTime);
	local estTimeToLevelThisSession = TitanUtils_Ternary((this.sessionXP == 0), -1, toLevelXP / this.sessionXP * sessionTime);
	if (not RestToGo or RestToGo <= 0) then
		RestToGo = 0;
	end
	
	return ""..
		TITAN_XP_TOOLTIP_TOTAL_TIME.."\t"..TitanUtils_GetHighlightText(TitanUtils_GetAbbrTimeText(totalTime)).."\n"..
		TITAN_XP_TOOLTIP_LEVEL_TIME.."\t"..TitanUtils_GetHighlightText(TitanUtils_GetAbbrTimeText(levelTime)).."\n"..
		TITAN_XP_TOOLTIP_SESSION_TIME.."\t"..TitanUtils_GetHighlightText(TitanUtils_GetAbbrTimeText(sessionTime)).."\n"..
		"\n"..		
		TITAN_XP_TOOLTIP_TOTAL_XP.."\t"..TitanUtils_GetHighlightText(totalXP).."\n".. 
		TITAN_XP_TOOLTIP_LEVEL_XP.."\t"..TitanUtils_GetHighlightText(format(TITAN_XP_PERCENT_FORMAT, currentXP, currentXPPercent)).."\n".. 
		TITAN_XP_TOOLTIP_TOLEVEL_XP.."\t"..TitanUtils_GetHighlightText(format(TITAN_XP_PERCENT_FORMAT, toLevelXP, toLevelXPPercent)).."\n"..
		TITAN_XP_TOOLTIP_SESSION_XP.."\t"..TitanUtils_GetHighlightText(this.sessionXP).."\n"..
		"\n"..
		TITAN_XP_TOOLTIP_XPHR_LEVEL.."\t"..TitanUtils_GetHighlightText(format(TITAN_XP_FORMAT, xpPerHourThisLevel)).."\n"..
		TITAN_XP_TOOLTIP_XPHR_SESSION.."\t"..TitanUtils_GetHighlightText(format(TITAN_XP_FORMAT, xpPerHourThisSession)).."\n"..
		TITAN_XP_TOOLTIP_TOLEVEL_LEVEL.."\t"..TitanUtils_GetHighlightText(TitanUtils_GetAbbrTimeText(estTimeToLevelThisLevel)).."\n"..
		TITAN_XP_TOOLTIP_TOLEVEL_SESSION.."\t"..TitanUtils_GetHighlightText(TitanUtils_GetAbbrTimeText(estTimeToLevelThisSession)).."\n"..
		format("Rest XP remaining: \t%s", TitanUtils_GetHighlightText(RestToGo));
end

function TitanPanelRightClickMenu_PrepareXPMenu()
	local info;

	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_XP_ID].menuText);

	info = {};
	info.text = TITAN_XP_MENU_SHOW_XPHR_THIS_SESSION;
	info.func = TitanPanelXPButton_ShowXPPerHourSession;
	info.checked = TitanGetVar(TITAN_XP_ID, "ShowXPPerHourSession");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_XP_MENU_SHOW_XPHR_THIS_LEVEL;
	info.func = TitanPanelXPButton_ShowXPPerHourLevel
	info.checked = TitanUtils_Toggle(TitanGetVar(TITAN_XP_ID, "ShowXPPerHourSession"));
	UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_XP_ID);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_XP_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelXPButton_ShowXPPerHourSession()
	TitanSetVar(TITAN_XP_ID, "ShowXPPerHourSession", 1);
	TitanPanelButton_UpdateButton(TITAN_XP_ID);
end

function TitanPanelXPButton_ShowXPPerHourLevel()
	TitanSetVar(TITAN_XP_ID, "ShowXPPerHourSession", nil);
	TitanPanelButton_UpdateButton(TITAN_XP_ID);
end
