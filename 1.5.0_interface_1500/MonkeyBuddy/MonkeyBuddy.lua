--[[

	MonkeyBuddy:
	Helps you configure your MonkeyMods.
	
	Website:	http://wow.visualization.ca/
	Author:		Trentin (monkeymods@gmail.com)
	
	
	Contributors:
	Pkp
		- Some initial xml work.
		
	Grayhoof
		- I "borrowed" a lot of the techniques and some code used in the options
		frame of ScrollingCombatText. It was such an excellent implementation
		that I just had to use it.
	
	Juki
		- French translation

--]]

-- *****************************************************************************
-- MonkeyQuest
-- *****************************************************************************

-- Set color functions
local MonkeyBuddyQuest_ColourCallback = {
	[1] = function(x) MonkeyBuddyQuest_SetColour(1) end,
	[2] = function(x) MonkeyBuddyQuest_SetColour(2) end,
	[3] = function(x) MonkeyBuddyQuest_SetColour(3) end,
	[4] = function(x) MonkeyBuddyQuest_SetColour(4) end,
	[5] = function(x) MonkeyBuddyQuest_SetColour(5) end,
	[6] = function(x) MonkeyBuddyQuest_SetColour(6) end,
	[7] = function(x) MonkeyBuddyQuest_SetColour(7) end,
	[8] = function(x) MonkeyBuddyQuest_SetColour(8) end,
	[9] = function(x) MonkeyBuddyQuest_SetColour(9) end,
	[10] = function(x) MonkeyBuddyQuest_SetColour(10) end,
	[11] = function(x) MonkeyBuddyQuest_SetColour(11) end,
	[12] = function(x) MonkeyBuddyQuest_SetColour(12) end
};

local MonkeyBuddyQuest_ColourCancleCallback = {
	[1] = function(x) MonkeyBuddyQuest_CancleColour(1) end,
	[2] = function(x) MonkeyBuddyQuest_CancleColour(2) end,
	[3] = function(x) MonkeyBuddyQuest_CancleColour(3) end,
	[4] = function(x) MonkeyBuddyQuest_CancleColour(4) end,
	[5] = function(x) MonkeyBuddyQuest_CancleColour(5) end,
	[6] = function(x) MonkeyBuddyQuest_CancleColour(6) end,
	[7] = function(x) MonkeyBuddyQuest_CancleColour(7) end,
	[8] = function(x) MonkeyBuddyQuest_CancleColour(8) end,
	[9] = function(x) MonkeyBuddyQuest_CancleColour(9) end,
	[10] = function(x) MonkeyBuddyQuest_CancleColour(10) end,
	[11] = function(x) MonkeyBuddyQuest_CancleColour(11) end,
	[12] = function(x) MonkeyBuddyQuest_CancleColour(12) end
};

-- this array is used to init the check buttons
local MonkeyBuddyQuest_CheckButtons = { };
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_OPEN] = {
	id = 1,
	strVar = "m_bDisplay",
	pSlashCommand = MonkeyQuestSlash_CmdOpen
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_SHOWHIDDEN] = {
	id = 2, 
	strVar = "m_bShowHidden",
	pSlashCommand = MonkeyQuestSlash_CmdShowHidden
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_USEOVERVIEWS] = {
	id = 3, 
	strVar = "m_bObjectives",
	pSlashCommand = MonkeyQuestSlash_CmdUseOverviews
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_HIDEHEADERS] = {
	id = 4, 
	strVar = "m_bNoHeaders",
	pSlashCommand = MonkeyQuestSlash_CmdHideHeaders
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_HIDEBORDER] = {
	id = 5, 
	strVar = "m_bNoBorder",
	pSlashCommand = MonkeyQuestSlash_CmdHideBorder
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_GROWUP] = {
	id = 6, 
	strVar = "m_bGrowUp",
	pSlashCommand = MonkeyQuestSlash_CmdGrowUp
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_SHOWNUMQUESTS] = {
	id = 7, 
	strVar = "m_bShowNumQuests",
	pSlashCommand = MonkeyQuestSlash_CmdShowNumQuests
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_LOCK] = {
	id = 8, 
	strVar = "m_bLocked",
	pSlashCommand = MonkeyQuestSlash_CmdLock
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_COLOURTITLEON] = {
	id = 9, 
	strVar = "m_bColourTitle",
	pSlashCommand = MonkeyQuestSlash_CmdColourTitleOn
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_HIDECOMPLETEDQUESTS] = {
	id = 10, 
	strVar = "m_bHideCompletedQuests",
	pSlashCommand = MonkeyQuestSlash_CmdHideCompletedQuests
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_HIDECOMPLETEDOBJECTIVES] = {
	id = 11, 
	strVar = "m_bHideCompletedObjectives",
	pSlashCommand = MonkeyQuestSlash_CmdHideCompletedObjectives
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_SHOWTOOLTIPOBJECTIVES] = {
	id = 12, 
	strVar = "m_bShowTooltipObjectives",
	pSlashCommand = MonkeyQuestSlash_CmdShowTooltipObjectives
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_ALLOWRIGHTCLICK] = {
	id = 13, 
	strVar = "m_bAllowRightClick",
	pSlashCommand = MonkeyQuestSlash_CmdAllowRightClick
};
MonkeyBuddyQuest_CheckButtons[MONKEYBUDDY_QUEST_HIDETITLEBUTTONS] = {
	id = 14, 
	strVar = "m_bHideTitleButtons",
	pSlashCommand = MonkeyQuestSlash_CmdHideTitleButtons
};

-- this array is used to init the colour buttons
local MonkeyBuddyQuest_ColourButtons = { };
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_QUESTTITLECOLOUR] = { 
	id = 1,
	strVar = "m_strQuestTitleColour"
};
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_HEADEROPENCOLOUR] = { 
	id = 2,
	strVar = "m_strHeaderOpenColour"
};
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_HEADERCLOSEDCOLOUR] = { 
	id = 3,
	strVar = "m_strHeaderClosedColour"
};
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_OVERVIEWCOLOUR] = { 
	id = 4,
	strVar = "m_strOverviewColour"
};
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_SPECIALOBJECTIVECOLOUR] = { 
	id = 5,
	strVar = "m_strSpecialObjectiveColour"
};
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_INITIALOBJECTIVECOLOUR] = { 
	id = 6,
	strVar = "m_strInitialObjectiveColour"
};
MonkeyBuddyQuest_ColourButtons[MONKEYBUDDY_QUEST_COMPLETEOBJECTIVECOLOUR] = { 
	id = 7,
	strVar = "m_strCompleteObjectiveColour"
};


local MonkeyBuddyQuest_Sliders = { };
MonkeyBuddyQuest_Sliders[MONKEYBUDDY_QUEST_ALPHASLIDER] = {
	id = 1,
	strVar = "m_iAlpha",
	pSlashCommand = MonkeyQuest_SetAlpha,
	minValue = 0.0,
	maxValue = 1.0,
	valueStep = .01,
	minText="0%",
	maxText="100%",
};
MonkeyBuddyQuest_Sliders[MONKEYBUDDY_QUEST_WIDTHSLIDER] = {
	id = 2,
	strVar = "m_iFrameWidth",
	pSlashCommand = MonkeyQuestSlash_CmdWidth,
	minValue = 200,
	maxValue = 600,
	valueStep = 5,
	minText="200",
	maxText="600",
};
MonkeyBuddyQuest_Sliders[MONKEYBUDDY_QUEST_FONTSLIDER] = {
	id = 3,
	strVar = "m_iFontHeight",
	pSlashCommand = MonkeyQuestSlash_CmdFontHeight,
	minValue = 8,
	maxValue = 48,
	valueStep = 1,
	minText="8",
	maxText="48",
};

-- *****************************************************************************
-- MonkeySpeed
-- *****************************************************************************

-- this array is used to init the check buttons

local MonkeyBuddySpeed_CheckButtons = { };
MonkeyBuddySpeed_CheckButtons[MONKEYBUDDY_SPEED_OPEN] = {
	id = 1,
	strVar = "m_bDisplay",
	pSlashCommand = MonkeySpeedSlash_CmdOpen
};
MonkeyBuddySpeed_CheckButtons[MONKEYBUDDY_SPEED_PERCENT] = {
	id = 2,
	strVar = "m_bDisplayPercent",
	pSlashCommand = MonkeySpeedSlash_CmdShowPercent
};
MonkeyBuddySpeed_CheckButtons[MONKEYBUDDY_SPEED_BAR] = {
	id = 3,
	strVar = "m_bDisplayBar",
	pSlashCommand = MonkeySpeedSlash_CmdShowBar
};
MonkeyBuddySpeed_CheckButtons[MONKEYBUDDY_SPEED_LOCK] = {
	id = 4,
	strVar = "m_bLocked",
	pSlashCommand = MonkeySpeedSlash_CmdLock
};

-- *****************************************************************************
-- MonkeyClock
-- *****************************************************************************

-- this array is used to init the check buttons

local MonkeyBuddyClock_CheckButtons = { };
MonkeyBuddyClock_CheckButtons[MONKEYBUDDY_CLOCK_OPEN] = {
	id = 1,
	strVar = "m_bDisplay",
	pSlashCommand = MonkeyClockSlash_CmdOpen
};
MonkeyBuddyClock_CheckButtons[MONKEYBUDDY_CLOCK_HIDEBORDER] = {
	id = 2,
	strVar = "m_bNoBorder",
	pSlashCommand = MonkeyClockSlash_CmdHideBorder
};
MonkeyBuddyClock_CheckButtons[MONKEYBUDDY_CLOCK_USEMILITARYTIME] = {
	id = 3,
	strVar = "m_bMilitaryTime",
	pSlashCommand = MonkeyClockSlash_CmdUseMilitaryTime
};
MonkeyBuddyClock_CheckButtons[MONKEYBUDDY_CLOCK_LOCK] = {
	id = 4,
	strVar = "m_bLocked",
	pSlashCommand = MonkeyClockSlash_CmdLock
};

local MonkeyBuddyClock_Sliders = { };
MonkeyBuddyClock_Sliders[MONKEYBUDDY_CLOCK_MINUTESLIDER] = {
	id = 1,
	strVar = "m_iOffsetMinute",
	pSlashCommand = MonkeyClockSlash_CmdSetMinute,
	minValue = -30,
	maxValue = 30,
	valueStep = 1,
	minText="-30",
	maxText="+30",
};
MonkeyBuddyClock_Sliders[MONKEYBUDDY_CLOCK_HOURSLIDER] = {
	id = 2,
	strVar = "m_iOffsetHour",
	pSlashCommand = MonkeyClockSlash_CmdSetHour,
	minValue = -12,
	maxValue = 12,
	valueStep = 1,
	minText="-12",
	maxText="+12",
};

function MonkeyBuddy_OnLoad()
	
	-- Add myCockOptionsFrame to the UIPanelWindows list
	UIPanelWindows["MonkeyBuddyFrame"] = {area = "center", pushable = 0};
	
	-- register events
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- register chat slash commands
	
	-- this command hides the MonkeyBuddy Icon
	SlashCmdList["MONKEYBUDDY_DISMISS"] = MonkeyBuddySlash_CmdDismiss;
	SLASH_MONKEYBUDDY_DISMISS1 = "/monkeybuddydismiss";
	SLASH_MONKEYBUDDY_DISMISS2 = "/mbdismiss";
	
	-- this command shows the MonkeyBuddy Icon
	SlashCmdList["MONKEYBUDDY_CALL"] = MonkeyBuddySlash_CmdCall;
	SLASH_MONKEYBUDDY_CALL1 = "/monkeybuddycall";
	SLASH_MONKEYBUDDY_CALL2 = "/mbcall";
	
	MonkeyBuddyFrame_TitleText:SetTextColor(ITEM_QUALITY6_TOOLTIP_COLOR.r, ITEM_QUALITY6_TOOLTIP_COLOR.g, ITEM_QUALITY6_TOOLTIP_COLOR.b);
	
	MonkeyBuddyQuestTab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1.0);
	MonkeyBuddySpeedTab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1.0);
	MonkeyBuddyClockTab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1.0);
end

function MonkeyBuddySlash_CmdDismiss()
	MonkeyBuddyConfig.m_bDismissed = true;
	MonkeyBuddyIconButton:Hide();
end

function MonkeyBuddySlash_CmdCall()
	MonkeyBuddyConfig.m_bDismissed = false;
	MonkeyBuddyIconButton:Show();
end

function MonkeyBuddy_OnEvent(event)
	
	if (event == "VARIABLES_LOADED") then
		-- Add MonkeyBuddy to myAddOns
		if (myAddOnsList) then
			myAddOnsList[MONKEYBUDDY_TITLE] = {name = MONKEYBUDDY_TITLE, description = MONKEYBUDDY_DESCRIPTION, version = MONKEYBUDDY_VERSION, frame = "MonkeyBuddyIconButton", optionsframe = "MonkeyBuddyFrame"};
		end
		
		if (MonkeyBuddyConfig == nil) then
			MonkeyBuddyConfig = {};
			MonkeyBuddyConfig.m_bDismissed = false;
		end
		
		if (MonkeyBuddyConfig.m_bDismissed == true) then
			MonkeyBuddyIconButton:Hide();
		else
			-- LedMirage 4/19/2005 always hide it
			-- MonkeyBuddyIconButton:Show();
			MonkeyBuddyIconButton:Hide();
		end
		
		-- print out a nice message letting the user know the addon loaded
		if (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(MONKEYBUDDY_LOADED_MSG);
		end
	end
end

function MonkeyBuddyIconButton_OnClick()
	ShowUIPanel(MonkeyBuddyFrame);
end

function MonkeyBuddy_ToggleDisplay()
	if (MonkeyBuddyFrame:IsVisible()) then
		HideUIPanel(MonkeyBuddyFrame);
	else
		ShowUIPanel(MonkeyBuddyFrame);
	end
end

function MonkeyBuddyQuestTab_OnClick()
	if (MonkeyQuest ~= nil) then
		if (MonkeyQuest.m_bLoaded == true) then
			MonkeyBuddySpeedFrame:Hide();
			MonkeyBuddyClockFrame:Hide();
	
			MonkeyBuddyQuestFrame:Show();
			PlaySound("igMainMenuOptionCheckBoxOn");
		end
	end
end

function MonkeyBuddySpeedTab_OnClick()
	if (MonkeySpeed ~= nil) then
		if (MonkeySpeed.m_bLoaded == true) then
			MonkeyBuddyQuestFrame:Hide();
			MonkeyBuddyClockFrame:Hide();
		
			MonkeyBuddySpeedFrame:Show();
			PlaySound("igMainMenuOptionCheckBoxOn");
		end
	end
end

function MonkeyBuddyClockTab_OnClick()
	if (MonkeyClock ~= nil) then
		if (MonkeyClock.m_bLoaded == true) then
			MonkeyBuddyQuestFrame:Hide();
			MonkeyBuddySpeedFrame:Hide();
			
			MonkeyBuddyClockFrame:Show();
			PlaySound("igMainMenuOptionCheckBoxOn");
		end
	end
end

function MonkeyBuddyQuestFrame_OnShow()
	if (MonkeyQuest ~= nil) then
		if (MonkeyQuest.m_bLoaded == true) then
			MonkeyBuddyQuestTabTexture:Show();
			MonkeyBuddyQuestTab:SetBackdropBorderColor(1, 1, 1, 1);
			MonkeyBuddyQuestFrame_Refresh();
		else
			MonkeyBuddyQuestTabTexture:Hide();
			MonkeyBuddyQuestFrame:Hide();
		end
	else
		MonkeyBuddyQuestTabTexture:Hide();
		MonkeyBuddyQuestFrame:Hide();
	end
end

function MonkeyBuddySpeedFrame_OnShow()
	if (MonkeySpeed ~= nil) then
		if (MonkeySpeed.m_bLoaded == true) then
			MonkeyBuddySpeedTabTexture:Show();
			MonkeyBuddySpeedTab:SetBackdropBorderColor(1, 1, 1, 1);
			MonkeyBuddySpeedFrame_Refresh();
		else
			MonkeyBuddySpeedTabTexture:Hide();
			MonkeyBuddySpeedFrame:Hide();
		end
	else
		MonkeyBuddySpeedTabTexture:Hide();
		MonkeyBuddySpeedFrame:Hide();
	end
end

function MonkeyBuddyClockFrame_OnShow()
	if (MonkeyClock ~= nil) then
		if (MonkeyClock.m_bLoaded == true) then
			MonkeyBuddyClockTabTexture:Show();
			MonkeyBuddyClockTab:SetBackdropBorderColor(1, 1, 1, 1);
			MonkeyBuddyClockFrame_Refresh();
		else
			MonkeyBuddyClockTabTexture:Hide();
			MonkeyBuddyClockFrame:Hide();
		end
	else
		MonkeyBuddyClockTabTexture:Hide();
		MonkeyBuddyClockFrame:Hide();
	end
end

function MonkeyBuddyQuestFrame_OnHide()
	MonkeyBuddyQuestTabTexture:Hide();
	MonkeyBuddyQuestTab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1.0);
end

function MonkeyBuddySpeedFrame_OnHide()
	MonkeyBuddySpeedTabTexture:Hide();
	MonkeyBuddySpeedTab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1.0);
end

function MonkeyBuddyClockFrame_OnHide()
	MonkeyBuddyClockTabTexture:Hide();
	MonkeyBuddyClockTab:SetBackdropBorderColor(0.25, 0.25, 0.25, 1.0);
end

--Called when option page loads
function MonkeyBuddyQuestFrame_Refresh()
	-- Initial Values
	local button, string, checked, swatch, border, iAlpha, iRed, iGreen, iBlue;
	
	-- Setup check buttons
	for key, value in MonkeyBuddyQuest_CheckButtons do
		button = getglobal("MonkeyBuddyQuestCheck" .. value.id);
		string = getglobal("MonkeyBuddyQuestCheck" .. value.id .. "Text");
		checked = nil;
		button.disabled = nil;
		
		--Check Box
		if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer][value.strVar] == true) then
			checked = 1;
		else
			checked = 0;
		end
		
		button:SetChecked(checked);
		string:SetText(key);
		button.pSlashCommand = value.pSlashCommand;
		button.strModName = "MonkeyQuest";
	end
	
	-- Setup colour buttons
	for key, value in MonkeyBuddyQuest_ColourButtons do
		button = getglobal("MonkeyBuddyQuestColour" .. value.id);
		swatch = getglobal("MonkeyBuddyQuestColour" .. value.id .. "_SwatchTexture");
		border = getglobal("MonkeyBuddyQuestColour" .. value.id .. "_BorderTexture");
		string = getglobal("MonkeyBuddyQuestColour" .. value.id .. "Text");
		
		button.disabled = nil;
		
		--Color Swatch
		iAlpha, iRed, iGreen, iBlue = MonkeyBuddy_ColourStrToARGB(MonkeyQuestConfig[MonkeyQuest.m_strPlayer][value.strVar]);
		
		button.a = iAlpha;
		button.r = iRed;
		button.g = iGreen;
		button.b = iBlue;
		button.swatchFunc = MonkeyBuddyQuest_ColourCallback[value.id];
		button.cancelFunc = MonkeyBuddyQuest_ColourCancleCallback[value.id];
		
		swatch:SetVertexColor(iRed, iGreen, iBlue);
		border:SetVertexColor(iRed, iGreen, iBlue);
		
		button.id = value.id;
		button.strVar = value.strVar;
		string:SetText(key);
		
		button.strModName = "MonkeyQuest";
	end
	
	local slider, string, low, high;

	-- Setup Sliders
	for key, value in MonkeyBuddyQuest_Sliders do
		slider = getglobal("MonkeyBuddyQuestSlider"..value.id);
		string = getglobal("MonkeyBuddyQuestSlider"..value.id.."Text");
		low = getglobal("MonkeyBuddyQuestSlider"..value.id.."Low");
		high = getglobal("MonkeyBuddyQuestSlider"..value.id.."High");
		
		slider.id = value.id;
		slider.strVar = value.strVar;
		slider.pSlashCommand = value.pSlashCommand;
		
		--OptionsFrame_EnableSlider(slider);
		slider:SetMinMaxValues(value.minValue, value.maxValue);
		slider:SetValueStep(value.valueStep);
		slider:SetValue(MonkeyQuestConfig[MonkeyQuest.m_strPlayer][value.strVar]);
		string:SetText(key);
		low:SetText(value.minText);
		high:SetText(value.maxText);
		
		slider.strModName = "MonkeyQuest";
	end
end

function MonkeyBuddySpeedFrame_Refresh()
	
	-- Initial Values
	local button, string, checked;
	
	-- Setup check buttons
	for key, value in MonkeyBuddySpeed_CheckButtons do
		button = getglobal("MonkeyBuddySpeedCheck" .. value.id);
		string = getglobal("MonkeyBuddySpeedCheck" .. value.id .. "Text");
		checked = nil;
		button.disabled = nil;
		
		--Check Box
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer][value.strVar] == true) then
			checked = 1;
		else
			checked = 0;
		end
		
		button:SetChecked(checked);
		string:SetText(key);
		button.pSlashCommand = value.pSlashCommand;
		button.strModName = "MonkeySpeed";
	end
end

function MonkeyBuddyClockFrame_Refresh()
	
	-- Initial Values
	local button, string, checked;
	
	-- Setup check buttons
	for key, value in MonkeyBuddyClock_CheckButtons do
		button = getglobal("MonkeyBuddyClockCheck" .. value.id);
		string = getglobal("MonkeyBuddyClockCheck" .. value.id .. "Text");
		checked = nil;
		button.disabled = nil;
		
		--Check Box
		if (MonkeyClockConfig[MonkeyClock.m_strPlayer][value.strVar] == true) then
			checked = 1;
		else
			checked = 0;
		end
		
		button:SetChecked(checked);
		string:SetText(key);
		button.pSlashCommand = value.pSlashCommand;
		button.strModName = "MonkeyClock";
	end
	
	-- Setup Sliders
	for key, value in MonkeyBuddyClock_Sliders do
		slider = getglobal("MonkeyBuddyClockSlider"..value.id);
		string = getglobal("MonkeyBuddyClockSlider"..value.id.."Text");
		low = getglobal("MonkeyBuddyClockSlider"..value.id.."Low");
		high = getglobal("MonkeyBuddyClockSlider"..value.id.."High");
		
		slider.id = value.id;
		slider.strVar = value.strVar;
		slider.pSlashCommand = value.pSlashCommand;
		
		--OptionsFrame_EnableSlider(slider);
		slider:SetMinMaxValues(value.minValue, value.maxValue);
		slider:SetValueStep(value.valueStep);
		slider:SetValue(MonkeyClockConfig[MonkeyClock.m_strPlayer][value.strVar]);
		string:SetText(key);
		low:SetText(value.minText);
		high:SetText(value.maxText);
		
		slider.strModName = "MonkeyClock";
	end
end

function MonkeyBuddyCheckButton_OnClick()
	local	bChecked;
	
	if (this:GetChecked()) then
		bChecked = true;
	else
		bChecked = false;
	end
	
	this.pSlashCommand(bChecked);
end

function MonkeyBuddy_ColourStrToARGB(strColour)
	-- "|cFF9F9FFF"
	local i = 3;
	
	local iAlpha = tonumber(string.sub(strColour, i, i + 1), 16);
	local iRed = tonumber(string.sub(strColour, i + 2, i + 3), 16);
	local iGreen = tonumber(string.sub(strColour, i + 4, i + 5), 16);
	local iBlue = tonumber(string.sub(strColour, i + 6, i + 7), 16);
	
	iAlpha = iAlpha / 255;
	iRed = iRed / 255;
	iGreen = iGreen / 255;
	iBlue = iBlue / 255;
	
	--DEFAULT_CHAT_FRAME:AddMessage("A = "..iAlpha.." R = "..iRed.." G = "..iGreen.." B = "..iBlue);
	
	return iAlpha, iRed, iGreen, iBlue;
end

function MonkeyBuddy_ARGBToColourStr(iAlpha, iRed, iGreen, iBlue)
	-- "|cFF9F9FFF"
	local strColour;
	
	iAlpha = floor(iAlpha * 255);
	iRed = floor(iRed * 255);
	iGreen = floor(iGreen * 255);
	iBlue = floor(iBlue * 255);
	
	strColour = format("|c%2x%2x%2x%2x", iAlpha, iRed, iGreen, iBlue);
	
	--DEFAULT_CHAT_FRAME:AddMessage("A = "..iAlpha.." R = "..iRed.." G = "..iGreen.." B = "..iBlue);
	
	return strColour;
end

function MonkeyBuddyQuest_SetColour(id)
	local iRed, iGreen, iBlue = ColorPickerFrame:GetColorRGB();
	local swatch, button, border;
	
	
	button = getglobal("MonkeyBuddyQuestColour" .. id);
	swatch = getglobal("MonkeyBuddyQuestColour" .. id .. "_SwatchTexture");
	border = getglobal("MonkeyBuddyQuestColour" .. id .. "_BorderTexture");
	
	swatch:SetVertexColor(iRed, iGreen, iBlue);
	border:SetVertexColor(iRed, iGreen, iBlue);
	button.r = iRed;
	button.g = iGreen;
	button.b = iBlue;
	
	-- update MonkeyQuest
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer][button.strVar] = MonkeyBuddy_ARGBToColourStr(1.0, iRed, iGreen, iBlue);
	
	MonkeyQuest_Refresh();
end

function MonkeyBuddyQuest_CancleColour(id)
	local iRed = ColorPickerFrame.previousValues.r;
	local iGreen = ColorPickerFrame.previousValues.g;
	local iBlue = ColorPickerFrame.previousValues.b;
	
	local swatch, button, border;
	
	
	button = getglobal("MonkeyBuddyQuestColour" .. id);
	swatch = getglobal("MonkeyBuddyQuestColour" .. id .. "_SwatchTexture");
	border = getglobal("MonkeyBuddyQuestColour" .. id .. "_BorderTexture");
	
	swatch:SetVertexColor(iRed, iGreen, iBlue);
	border:SetVertexColor(iRed, iGreen, iBlue);
	button.r = iRed;
	button.g = iGreen;
	button.b = iBlue;
	
	-- update MonkeyQuest
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer][button.strVar] = MonkeyBuddy_ARGBToColourStr(1.0, iRed, iGreen, iBlue);
	
	MonkeyQuest_Refresh();
end

function MonkeyBuddySlider_OnValueChanged()

	-- update MonkeyMod
	if (this.strModName == "MonkeyQuest") then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer][this.strVar] = this:GetValue();
	end
	if (this.strModName == "MonkeySpeed") then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer][this.strVar] = this:GetValue();
	end
	if (this.strModName == "MonkeyClock") then
		MonkeyClockConfig[MonkeyClock.m_strPlayer][this.strVar] = this:GetValue();
	end
	
	this.pSlashCommand(this:GetValue());
	
	-- set the tool tip text
	if (this:GetValue() == floor(this:GetValue())) then
		GameTooltip:SetText(format("%d", this:GetValue()));
	else
		GameTooltip:SetText(format("%.2f", this:GetValue()));
	end
end

function MonkeyBuddySlider_OnEnter()
	-- put the tool tip in the default position
	GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
	
	-- set the tool tip text
	if (this:GetValue() == floor(this:GetValue())) then
		GameTooltip:SetText(format("%d", this:GetValue()));
	else
		GameTooltip:SetText(format("%.2f", this:GetValue()));
	end
	
	GameTooltip:Show();
end

function MonkeyBuddySlider_OnLeave()
	GameTooltip:Hide();
end
