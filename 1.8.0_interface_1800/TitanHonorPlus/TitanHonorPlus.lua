-- Localisation
TITAN_HONORPLUS_BUTTON_LABEL_RANK = RANK..": ";
TITAN_HONORPLUS_BUTTON_LABEL_HK = "HK: ";
TITAN_HONORPLUS_BUTTON_LABEL_DK = "DK: ";
TITAN_HONORPLUS_TOOLTIP = "PVP Honor+ Info";
TITAN_HONORPLUS_MENU_TEXT = "Honor+";
TITAN_HONORPLUS_MENU_CALCTODAY = "Calculate today HK";
TITAN_HONORPLUS_ESTIMATED = "%s dies, [%d times today], Rank: %s. [Educated Honor: %d]";

if (GetLocale() == "deDE") then
	TITAN_HONORPLUS_BUTTON_LABEL_HK = "ES: ";
	TITAN_HONORPLUS_BUTTON_LABEL_DK = "RM: ";
	TITAN_HONORPLUS_TOOLTIP = "PvP Info zur Ehre+";
	TITAN_HONORPLUS_MENU_TEXT = "Ehre+";
	TITAN_HONORPLUS_ESTIMATED = "%s stirbt, [%d. mal heute], Rang: %s. [Errechnete Ehre: %d]";
end

-- Constants
TITAN_HONORPLUS_DEFAULTS = {
	['todaydk'] = 0,
	['todayhk'] = 0,
	['todaycp'] = 0,
	['todaycp2'] = 0,
	['yesterday'] = 0,
	['lastweek'] = 0,
	['weekdk'] = 0,
	['log'] = {},
};
local TITAN_HONORPLUS_ID = "HonorPlus";
local TITAN_HONORPLUS_ICON_PATH = "Interface\\PvPRankBadges\\PvPRank";
-- search string taken from Titan Session Honor.
local TITAN_HONORPLUS_SEARCH = string.gsub(COMBATLOG_HONORGAIN,'%(','%%(');
local TITAN_HONORPLUS_SEARCH = string.gsub(TITAN_HONORPLUS_SEARCH,'%)','%%)');
local TITAN_HONORPLUS_SEARCH = string.gsub(TITAN_HONORPLUS_SEARCH,'%%s','(.+)');
local TITAN_HONORPLUS_SEARCH = string.gsub(TITAN_HONORPLUS_SEARCH,'%%d','(%%d+)');

local vLoaded = nil;
local vC = nil;

CHAT_MSG_HONORPLUS = "Honor+";
ChatTypeGroup["HONORPLUS"] = {
	"CHAT_MSG_HONORPLUS"
};
ChatTypeInfo["HONORPLUS"] = { sticky = 0 };
tinsert(OtherMenuChatTypeGroups, "HONORPLUS");
CHAT_HONORPLUS_GET = "";
TITAN_HONORPLUS_CHATINFO = {
	["Default"] = {
		["r"] = 0.878,
		["g"] = 0.792,
		["b"] = 0.039,
		["show"] = {
			"ChatFrame1"
		}
	}
};
function TitanPanelHonorPlusButton_PrintMsg(msg)
	event = "CHAT_MSG_HONORPLUS";
	arg1 = msg;
	arg2, arg3, arg4, arg6 = "", "", "", "";
	local info = TITAN_HONORPLUS_CHATINFO["Default"];
	if ( TITAN_HONORPLUS_CHATINFO[UnitName("player")] ) then
		info = TITAN_HONORPLUS_CHATINFO[UnitName("player")];
	end
	for i = 1, 7, 1 do
		for k, v in info["show"] do
			if ( v == "ChatFrame" .. i ) then
				this = getglobal("ChatFrame" .. i);
				ChatFrame_OnEvent(event);
			end
		end
	end
end

TitanPanelHonorPlusButton_oldFCF_Tab_OnClick = FCF_Tab_OnClick;
function TitanPanelHonorPlusButton_newFCF_Tab_OnClick(button)
	TitanPanelHonorPlusButton_oldFCF_Tab_OnClick(button);
	if ( button == "RightButton" ) then
		local frame = getglobal("ChatFrame" .. this:GetID());
		local info = TITAN_HONORPLUS_CHATINFO["Default"];
		if ( TITAN_HONORPLUS_CHATINFO[UnitName("player")] ) then
			info = TITAN_HONORPLUS_CHATINFO[UnitName("player")];
		end
		for k, v in info["show"] do
			if ( v == "ChatFrame" .. this:GetID() ) then
				local y = 1;
				while ( frame.messageTypeList[y] ) do
					y = y + 1;
				end
				frame.messageTypeList[y] = "HONORPLUS";
			end
		end
	end
end
FCF_Tab_OnClick = TitanPanelHonorPlusButton_newFCF_Tab_OnClick;

TitanPanelHonorPlusButton_oldFCF_SetChatTypeColor = FCF_SetChatTypeColor;
function TitanPanelHonorPlusButton_newFCF_SetChatTypeColor()
	TitanPanelHonorPlusButton_oldFCF_SetChatTypeColor();
	if ( UIDROPDOWNMENU_MENU_VALUE == "HONORPLUS" ) then
		local r,g,b = ColorPickerFrame:GetColorRGB();
		if ( not TITAN_HONORPLUS_CHATINFO[UnitName("player")] ) then
			TITAN_HONORPLUS_CHATINFO[UnitName("player")] = TITAN_HONORPLUS_CHATINFO["Default"];
		end
		TITAN_HONORPLUS_CHATINFO[UnitName("player")].r = r;
		TITAN_HONORPLUS_CHATINFO[UnitName("player")].g = g;
		TITAN_HONORPLUS_CHATINFO[UnitName("player")].b = b;
		ChatTypeInfo["HONORPLUS"].r = r;
		ChatTypeInfo["HONORPLUS"].g = g;
		ChatTypeInfo["HONORPLUS"].b = b;
	end
end
FCF_SetChatTypeColor = TitanPanelHonorPlusButton_newFCF_SetChatTypeColor;

TitanPanelHonorPlusButton_oldFCF_CancelFontColorSettings = FCF_CancelFontColorSettings;
function TitanPanelHonorPlusButton_newFCF_CancelFontColorSettings(prev)
	TitanPanelHonorPlusButton_oldFCF_CancelFontColorSettings(prev);
	if ( prev.r and UIDROPDOWNMENU_MENU_VALUE == "HONORPLUS" ) then
		if ( not TITAN_HONORPLUS_CHATINFO[UnitName("player")] ) then
			TITAN_HONORPLUS_CHATINFO[UnitName("player")] = TITAN_HONORPLUS_CHATINFO["Default"];
		end
		TITAN_HONORPLUS_CHATINFO[UnitName("player")].r = prev.r;
		TITAN_HONORPLUS_CHATINFO[UnitName("player")].g = prev.g;
		TITAN_HONORPLUS_CHATINFO[UnitName("player")].b = prev.b;
		ChatTypeInfo["HONORPLUS"].r = prev.r;
		ChatTypeInfo["HONORPLUS"].g = prev.g;
		ChatTypeInfo["HONORPLUS"].b = prev.b;
	end
end
FCF_CancelFontColorSettings = TitanPanelHonorPlusButton_newFCF_CancelFontColorSettings;

TitanPanelHonorPlusButton_oldFCFMessageTypeDropDown_OnClick = FCFMessageTypeDropDown_OnClick;
function TitanPanelHonorPlusButton_newFCFMessageTypeDropDown_OnClick()
	TitanPanelHonorPlusButton_oldFCFMessageTypeDropDown_OnClick();
	if ( not TITAN_HONORPLUS_CHATINFO[UnitName("player")] ) then
		TITAN_HONORPLUS_CHATINFO[UnitName("player")] = TITAN_HONORPLUS_CHATINFO["Default"];
	end
	if ( this.value == "HONORPLUS" ) then
		if ( UIDropDownMenuButton_GetChecked() ) then
			for k, v in TITAN_HONORPLUS_CHATINFO[UnitName("player")]["show"] do
				if ( v == FCF_GetCurrentChatFrame():GetName() ) then
					TITAN_HONORPLUS_CHATINFO[UnitName("player")]["show"][k] = nil;
					break;
				end
			end
		else
			tinsert(TITAN_HONORPLUS_CHATINFO[UnitName("player")]["show"], FCF_GetCurrentChatFrame():GetName());
		end
	end
end
FCFMessageTypeDropDown_OnClick = TitanPanelHonorPlusButton_newFCFMessageTypeDropDown_OnClick;


function TitanPanelHonorPlusButton_OnLoad()
	this.registry = {
		id = TITAN_HONORPLUS_ID,
		menuText = TITAN_HONORPLUS_MENU_TEXT,
		buttonTextFunction = "TitanPanelHonorPlusButton_GetButtonText", 
		tooltipTitle = TITAN_HONORPLUS_TOOLTIP, 
		tooltipTextFunction = "TitanPanelHonorPlusButton_GetTooltipText",
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			UseCalculatedToday = 0,
		}
	};	
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	this:RegisterEvent("PLAYER_PVP_RANK_CHANGED");
	this:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("VARIABLES_LOADED");
	--RegisterForSave("TITAN_HONORPLUS");
	--RegisterForSave("TITAN_HONORPLUS_CHATINFO");
end

function TitanPanelHonorPlusButton_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (TITAN_HONORPLUS == nil) then TITAN_HONORPLUS = { }; end
		vLoaded = true;
	elseif (event == "UNIT_NAME_UPDATE" and arg1 == "player") or (event == "PLAYER_ENTERING_WORLD") then
		if (vC == nil) and (vLoaded) then
			vC = UnitName("player").."|"..GetCVar("realmName");
			if (TITAN_HONORPLUS[vC] == nil) then TITAN_HONORPLUS[vC] = { }; end
			for iName, xName in TITAN_HONORPLUS_DEFAULTS do
				if (TITAN_HONORPLUS[vC][iName] == nil) then TITAN_HONORPLUS[vC][iName] = xName;
			end
			info = TITAN_HONORPLUS_CHATINFO["Default"];
			if (TITAN_HONORPLUS_CHATINFO[UnitName("Player")]) then info = TITAN_HONORPLUS_CHATINFO[UnitName("Player")]; end
			ChatTypeInfo["HONORPLUS"] = info;
		end

		end
	elseif (event == "CHAT_MSG_COMBAT_HONOR_GAIN") then
		local x, p, h, s ,e, f;
		local s, e, name, rank, honor = string.find(arg1, TITAN_HONORPLUS_SEARCH);
		if (TITAN_HONORPLUS[vC]['log'][name] == nil) then TITAN_HONORPLUS[vC]['log'][name] = 0; end
		TITAN_HONORPLUS[vC]['todayhk'] = TITAN_HONORPLUS[vC]['todayhk'] +1;
		TITAN_HONORPLUS[vC]['log'][name] = TITAN_HONORPLUS[vC]['log'][name] +1;
		x = TITAN_HONORPLUS[vC]['log'][name];
		if (x == 1) then p = 1;
		elseif (x == 2) then p = 0.75;
		elseif (x == 3) then p = 0.5;
		elseif (x == 4) then p = 0.25;
		else p = 0; end
		h = honor * p;
		TITAN_HONORPLUS[vC]['todaycp'] = TITAN_HONORPLUS[vC]['todaycp'] + h;
		TITAN_HONORPLUS[vC]['todaycp2'] = TITAN_HONORPLUS[vC]['todaycp2'] + honor;
		local text = string.format(TITAN_HONORPLUS_ESTIMATED,name, x, rank, TitanPanelHonorPlusRound(h));
		TitanPanelHonorPlusButton_PrintMsg(text);	
	else
		TitanPanelButton_UpdateButton(TITAN_HONORPLUS_ID);
	end
	TitanPanelButton_UpdateTooltip();
end

function TitanPanelHonorPlusButton_OnShow()
	TitanPanelHonorPlusButton_SetPVPHonorIcon();
end

function TitanPanelHonorPlusButton_GetButtonText(id)
	if (not vLoaded) then return "Loading.."; end
	
	local rankName, rankNumber, todayHK, todayDK = TitanPanelHonorPlusGetPVPData();
	
	return ""..
		TITAN_HONORPLUS_BUTTON_LABEL_RANK, TitanUtils_GetHighlightText(rankNumber),
		TITAN_HONORPLUS_BUTTON_LABEL_HK, TitanUtils_GetGreenText(todayHK),
		TITAN_HONORPLUS_BUTTON_LABEL_DK, TitanUtils_GetRedText(todayDK);
end

function TitanPanelHonorPlusGetPVPData()
	-- Current rank
	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));	
	if (not rankName) then
		rankName = NONE;
	end

	-- This session's values
	local todayHK, todayDK = GetPVPSessionStats();
	
	-- Yesterday's values
	local ydayHK, ydayDK, ydayCP = GetPVPYesterdayStats();

	-- This Week's values
	local weekHK, weekCP = GetPVPThisWeekStats();
	
	-- Last Week's values
	local lastweekHK, lastweekDK, lastweekCP, lastweekRank = GetPVPLastWeekStats();
	
	-- Lifetime stats
	local lifetimeHK, lifetimeDK, highestRank = GetPVPLifetimeStats();	
	local highestRankName, highestRankNumber = GetPVPRankInfo(highestRank);
	if ( not highestRankName ) then
		highestRankName = NONE;
	end
	
	if (ydayCP ~= TITAN_HONORPLUS[vC]['yesterday']) then
		-- Yesterday has been updated.
		TITAN_HONORPLUS[vC]['yesterday'] = ydayCP;
		TITAN_HONORPLUS[vC]['weekdk'] = TITAN_HONORPLUS[vC]['weekdk'] + ydayDK;
		TITAN_HONORPLUS[vC]['log'] = { };
		TITAN_HONORPLUS[vC]['todayhk'] = 0;
		TITAN_HONORPLUS[vC]['todaydk'] = 0;
		TITAN_HONORPLUS[vC]['todaycp'] = 0;
	end
	if (TitanGetVar(TITAN_HONORPLUS_ID, "UseCalculatedToday") == 1) then local todayHK = TITAN_HONORPLUS[vC]['todayhk']; end
	local todayCP = TitanPanelHonorPlusRound(TITAN_HONORPLUS[vC]['todaycp']);
	
	-- reset if new week
	if (lastweekContribution ~= TITAN_HONORPLUS[vC]['lastweek']) then
		TITAN_HONORPLUS[vC]['lastweek'] = lastweekContribution;
		TITAN_HONORPLUS[vC]['weekcp'] = 0;
	end
	local weekDK = TITAN_HONORPLUS[vC]['weekdk'];
		
	return rankName, rankNumber, todayHK, todayDK, todayCP, ydayHK, ydayDK, ydayCP,
		weekHK, weekDK, weekCP, lastweekHK, lastweekDK, lastweekCP, lastweekRank,
		lifetimeHK, lifetimeDK, highestRankName, highestRankNumber;
end

function TitanPanelHonorPlusButton_GetTooltipText()
	if (not vLoaded) then return "Loading.."; end
	local rankName, rankNumber, todayHK, todayDK, todayCP, ydayHK, ydayDK, ydayCP,
		weekHK, weekDK, weekCP, lastweekHK, lastweekDK, lastweekCP, lastweekRank,
		lifetimeHK, lifetimeDK, highestRankName, highestRankNumber = TitanPanelHonorPlusGetPVPData();
	
	local todaycp2 = TitanPanelHonorPlusRound(TITAN_HONORPLUS[vC]['todaycp2']);
	local progress = TitanPanelHonorPlusRound(GetPVPRankProgress() *100);

	return ""..
		RANK..": "..TitanUtils_GetHighlightText(rankName.." ("..RANK.." "..rankNumber..")").."\n"..
		"Progress: "..TitanUtils_GetHighlightText(progress.."%").."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_THIS_SESSION).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(todayHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(todayDK).."\n"..
		HONOR_CONTRIBUTION_POINTS..": \t"..TitanUtils_GetHighlightText(todayCP).."\n"..
		"\n"..
		TitanUtils_GetHighlightText("This Week ("..HONOR_YESTERDAY..")").."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(weekHK)..TitanUtils_GetHighlightText(" (")..TitanUtils_GetGreenText(ydayHK)..TitanUtils_GetHighlightText(")").."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(weekDK)..TitanUtils_GetHighlightText(" (")..TitanUtils_GetRedText(ydayDK)..TitanUtils_GetHighlightText(")").."\n"..
		HONOR_CONTRIBUTION_POINTS..": \t"..TitanUtils_GetHighlightText(weekCP.." ("..ydayCP..")").."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_LASTWEEK).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(lastweekHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(lastweekDK).."\n"..
		HONOR_CONTRIBUTION_POINTS..": \t"..TitanUtils_GetHighlightText(lastweekCP).."\n"..
		HONOR_STANDING..": \t"..TitanUtils_GetHighlightText(lastweekRank).."\n"..
		"\n"..
		TitanUtils_GetHighlightText(HONOR_LIFETIME).."\n"..
		HONORABLE_KILLS..": \t"..TitanUtils_GetGreenText(lifetimeHK).."\n"..
		DISHONORABLE_KILLS..": \t"..TitanUtils_GetRedText(lifetimeDK).."\n"..
		HONOR_HIGHEST_RANK..": \t"..TitanUtils_GetHighlightText(highestRankName);
end

-- toggle using calculated today
function TitanPanelHonorPlusButton_ToggleUseCalculatedToday()
	TitanToggleVar(TITAN_HONORPLUS_ID, "UseCalculatedToday");
	TitanPanelButton_UpdateButton(TITAN_HONORPLUS_ID);
end

function TitanPanelHonorPlusButton_SetPVPHonorIcon()
	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));	
	if (rankNumber > 0) then
		TitanPanelHonorPlusButtonIcon:SetTexture(format("%s%02d", TITAN_HONORPLUS_ICON_PATH, rankNumber));
		TitanPanelHonorPlusButtonIcon:SetWidth(16);
	end
end

function TitanPanelRightClickMenu_PrepareHonorPlusMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_HONORPLUS_ID].menuText);
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_HONORPLUS_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_HONORPLUS_ID);
	TitanPanelRightClickMenu_AddSpacer();
	
	-- Add toggle for calculating today's values
	info = {};
	info.text = TITAN_HONORPLUS_MENU_CALCTODAY;
	info.func = TitanPanelHonorPlusButton_ToggleUseCalculatedToday
	info.checked = TitanGetVar(TITAN_HONORPLUS_ID, "UseCalculatedToday");
	UIDropDownMenu_AddButton(info);
	
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_HONORPLUS_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

function TitanPanelHonorPlusRound(x)
	if(x - math.floor(x) > 0.5) then
		x = x + 0.5;
	end
	return math.floor(x);
end

