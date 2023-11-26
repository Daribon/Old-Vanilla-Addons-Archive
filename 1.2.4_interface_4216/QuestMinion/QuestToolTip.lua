QuestToolTip_text = "";
QuestToolTip_List = { };
RegisterForSave("QuestToolTip_List");
QuestToolTip_Temp = 0;
QuestToolTip_LastSelect = 0;
QuestToolTip_Message = "";
QuestToolTip_Loaded = false;
QuestToolTip_FirstFixPos = true;

QuestToolTip_Colors = { };
QuestToolTip_Colors["impossible"] = { r = 1.00, g = 0.10, b = 0.10 };
QuestToolTip_Colors["verydifficult"] = { r = 1.00, g = 0.50, b = 0.25 };
QuestToolTip_Colors["difficult"] = { r = 1.00, g = 1.00, b = 0.00 };
QuestToolTip_Colors["standard"] = { r = 0.25, g = 0.75, b = 0.25 };
QuestToolTip_Colors["trivial"]	= { r = 0.50, g = 0.50, b = 0.50 };
QuestToolTip_Colors["header"]	= { r = 0.7, g = 0.7, b = 0.7 };

UIPanelWindows["QuestToolTip"] = { area = "left",	pushable = 0 };

-- Config
QMinionConfig = { };
RegisterForSave("QMinionConfig");

QMinionConfig.ColorTitle = 0;
QMinionConfig.ColorStatus = 1;
QMinionConfig.AutoAdd = 1;
QMinionConfig.Enabled = 0;
QMinionConfig.ShowLevel = 1;
QMinionConfig.Minimized = -1;
QMinionConfig.RemoveComplete = 1;
QMinionConfig.AutoHide = 0;
QMinionConfig.LastLeft = nil;
QMinionConfig.LastRight = nil;
QMinionConfig.LastTop = nil;
QMinionConfig.LastBottom = nil;
QMinionConfig.FadeObjectives = false;
QMinionConfig.LastUpdated = 0;
QMinionConfig.UpdateInterval = 0.25;
QMinionConfig.FadeObjectivesTime = 15;

function round(x)
  if(x - math.floor(x) > 0.5) then
    x = x + 0.5;
  end
  return math.floor(x);
end

function QuestToolTip_AddToTable(name)
	table.insert(QuestToolTip_List, name);
end

function QuestToolTip_RemoveFromTable(name)
	for i = 1, table.getn(QuestToolTip_List), 1 do
		if (QuestToolTip_List[i] == name) then
			table.remove(QuestToolTip_List, i);
		end
	end
end

function QuestMinion_ColorOptions_Title(checked)
	QMinionConfig.ColorTitle = checked;
	QuestToolTip_Show(3);
end

function QuestMinion_ColorOptions_Status(checked)
	QMinionConfig.ColorStatus = checked;
	QuestToolTip_Show(3);
end

function QuestMinion_AutoAdd_Status(checked)
	QMinionConfig.AutoAdd = checked;
	QuestToolTip_Show(3);
end

function QuestMinion_RemoveComplete_Status(checked)
	QMinionConfig.RemoveComplete = checked;
	QuestToolTip_Show(3);
end

function QuestMinion_AutoHide_Status(checked)
	QMinionConfig.AutoHide = checked;
	QuestToolTip_Show(3);
end

function QuestMinion_Fade_Objectives(checked)
	if ( checked == 1 ) then
		QMinionConfig.FadeObjectives = true;
	else
		QMinionConfig.FadeObjectives = false;
	end
end

-- will need to be have other options that want to update the QM independently.
function QuestToolTip_NeedToUpdate()
	if ( QMinionConfig.FadeObjectives ) then
		return true;
	else
		return false;
	end
end

function QuestToolTip_Update(elapsed)
	if ( not QMinionConfig ) then
		QMinionConfig = {};
	end
	if (not QMinionConfig.UpdateInterval) then QMinionConfig.UpdateInterval = 0.25; end
	if ( QMinionConfig.Enabled == 1 ) then
		local timeNow = GetTime();
		if (timeNow) then
			if ( not QMinionConfig.LastUpdated ) then
				QMinionConfig.LastUpdated = timeNow;
			elseif((QMinionConfig.LastUpdated + QMinionConfig.UpdateInterval) < timeNow) then
				QMinionConfig.LastUpdated = timeNow;
				if ( QuestToolTip_NeedToUpdate() ) then
					QuestMinion_DoScheduledUpdate();
				end
			end
		end
	end
end

function QuestMinion_Updater_Interval(checked, value)
	QMinionConfig.UpdateInterval = value;
end

function QuestMinion_DoScheduledUpdate() 
	if ( QMinionConfig.Enabled == 1 ) then
		if (not QuestLogFrame:IsVisible()) then 
			QuestToolTip_QuestSearch();
			if ( QuestTooltip:IsVisible() ) then
				Sea.io.print("QuestMinion - Update");
				QuestToolTip_Show(QMinionConfig.Minimized, true);
			end
		end
	end
	--Chronos.scheduleByName("QUESTMINION_UPDATE", 60, QuestMinion_DoScheduledUpdate);
end

function QuestMinion_ResetPos()
	QuestTooltip:ClearAllPoints();
	QuestTooltip:SetPoint("BOTTOM", "UIParent", "TOP", 0, -80);
	QuestToolTip_FixPos();
end

function QuestMinion_OnLoad()
	if (Cosmos_RegisterConfiguration) then
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION",
			"SECTION",
			QMINION_SEP,
			QMINION_SEP_INF0
		);
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_SECTION",
			"SEPARATOR",
			QMINION_SEP,
			QMINION_SEP_INF0
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_COLOROPTION_QUESTTITLE",
			"CHECKBOX",
			QMINION_CHECK1,
			QMINION_CHECK1_INF0,
			QuestMinion_ColorOptions_Title
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_COLOROPTION_QUESTSTATUS",
			"CHECKBOX",
			QMINION_CHECK2,
			QMINION_CHECK2_INF0,
			QuestMinion_ColorOptions_Status
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_AUTOADD",
			"CHECKBOX",
			QMINION_CHECK3,
			QMINION_CHECK3_INFO,
			QuestMinion_AutoAdd_Status
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_REMOVECOMPLETE",
			"CHECKBOX",
			QMINION_CHECK4,
			QMINION_CHECK4_INFO,
			QuestMinion_RemoveComplete_Status
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_AUTOHIDE",
			"CHECKBOX",
			QMINION_CHECK5,
			QMINION_CHECK5_INFO,
			QuestMinion_AutoHide_Status
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_FADEOBJECTIVE",
			"CHECKBOX",
			QMINION_FADE_OBJECTIVES,
			QMINION_FADE_OBJECTIVES_INFO,
			QuestMinion_Fade_Objectives,
			0
		);
		
		Cosmos_RegisterConfiguration(
			"COS_QUESTMINION_RESET",
			"BUTTON",
			QMINION_RESET,
			QMINION_RESET_INFO,
			QuestMinion_ResetPos,
			0,
			0,
			0,
			0,
			QMINION_RESET_NAME
		);
	end
	
	if(not Print) then
		function Print(msg, r, g, b, frame) 
			if (not r) then r = 1.0; end
			if (not g) then g = 1.0; end
			if (not b) then b = 1.0; end
			if ( frame ) then 
				frame:AddMessage(msg,r,g,b);
			else
				if ( DEFAULT_CHAT_FRAME ) then 
					DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
				end
			end
		end
	end
	
	this:RegisterEvent("UI_INFO_MESSAGE");
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

	QuestToolTip_QuestLog_Update = QuestLog_Update;
	function QuestLog_Update()
		QuestToolTip_QuestLog_Update();

		local numHeaders = 0;
		local numEntries = GetNumQuestLogEntries();
		
		for i=1, QUESTS_DISPLAYED, 1 do
			local questIndex = i + FauxScrollFrame_GetOffset(QuestLogListScrollFrame);
			local questLogTitle = getglobal("QuestLogTitle"..i);
			local questTitleTag = getglobal("QuestLogTitle"..i.."Tag");
			if ( questIndex <= numEntries ) then
				local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(questIndex);
				if (level and not isHeader and QMinionConfig.ShowLevel == 1) then
					questLogTitle:SetText("  ["..level.."] "..questLogTitleText);
				end
			end
		end
		for i=1, numEntries, 1 do
			local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(i);
			if ( questLogTitleText and isHeader ) then
				numHeaders = numHeaders + 1;
			end
		end
		
		if ( QuestLogCountText ) then
			QuestLogCountText:SetText((numEntries - numHeaders).."/"..MAX_QUESTS);
		end
	end

	QuestToolTip_QuestLogCollapseAllButton_OnClick = QuestLogCollapseAllButton_OnClick;
	function QuestLogCollapseAllButton_OnClick()
		QuestToolTip_QuestLogCollapseAllButton_OnClick();
		QuestToolTip_QuestSearch();
		QuestToolTip_Show(3);
	end

	QuestLog_FauxScrollFrame_OnVerticalScroll = FauxScrollFrame_OnVerticalScroll;
	function FauxScrollFrame_OnVerticalScroll(itemHeight, updateFunction)
		QuestLog_FauxScrollFrame_OnVerticalScroll(itemHeight, updateFunction);
		if (this:GetParent():GetName() == "QuestLogFrame") then
			QuestToolTip_QuestSearch();
			QuestToolTip_Show(3, true);
		end
	end
	
	QuestToolTip_QuestLogTitleButton_OnClick = QuestLogTitleButton_OnClick;
	function QuestLogTitleButton_OnClick(val)
		QuestToolTip_QuestLogTitleButton_OnClick(val);
		QuestToolTip_QuestSearch();
		QuestToolTip_Show(3);
	end
	
end

function QuestToolTip_OnEvent(event, message)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		QuestMinion_StartLoadedChecking();
		--QuestToolTip_Loaded = true;
	end
	if ( not QuestToolTip_Loaded ) then
		return;
	end
	if ( event == "UI_INFO_MESSAGE" ) then
		local questUpdateText = gsub(message,"(.*): %d+/%d+","%1",1);
		local questUpdateText1 = gsub(message,"(.*): %d+ / %d+","%1",1);
		if ( questUpdateText ~= message or questUpdateText1 ~= message) then
			QuestToolTip_Message = message;
			QuestToolTip_QuestSearch(message, nil, 1)
			if ((QuestToolTip_text == QMINION_NOQUEST) and (QMinionConfig.AutoHide == 1)) then
				QuestToolTip_Hide();
			end
		end
	elseif ( event == "QUEST_LOG_UPDATE" ) then
		if ( QuestTooltip:IsVisible() ) then
			QuestToolTip_QuestSearch(nil, nil, 1);
			QuestToolTip_Show(3);
			if ((QuestToolTip_text == QMINION_NOQUEST) and (QMinionConfig.AutoHide == 1)) then
				QuestToolTip_Hide();
			end
		end
	elseif ( event == "VARIABLES_LOADED" ) then
		if (QMinionConfig.Enabled == 1) then
			QMinionConfig.Enabled = 0;
			QuestCompanionCheckButton:SetChecked(0);
			--[[
			QuestCompanionCheckButton:SetChecked(1);
			if ( Cosmos_AfterInit ) then
				Cosmos_AfterInit(QuestTooltip_AfterInit);
			else
				QuestToolTip_Show(QMinionConfig.Minimized);
			end
			]]--
		end
	end	
end

function QuestMinion_LoadedCheck()
	if ( UnitName("player") == TEXT(UKNOWNBEING) ) then
		return false;
	else
		return true;
	end
end

function QuestMinion_DoLoadedChecking()
	QuestToolTip_Loaded = QuestMinion_LoadedCheck();
	if ( not QuestToolTip_Loaded ) then
		Chronos.scheduleByName("QM_LOADED", 5, QuestMinion_DoLoadedChecking);
	end
end

function QuestMinion_StartLoadedChecking()
	if ( Chronos.scheduleByName ) then
		Chronos.scheduleByName("QM_LOADED", 10, QuestMinion_DoLoadedChecking);
	else
		QuestToolTip_Loaded = true;
	end
end



function QuestTooltip_AfterInit()
	if ( Chronos.scheduleByName ) then
		Chronos.scheduleByName("QuestTooltip_AfterInit_Delay", 60, QuestToolTip_Show, QMinionConfig.Minimized)
	else
		QuestToolTip_Show(QMinionConfig.Minimized);
	end
end

function QuestToolTip_OnHide()
	QuestCompanionCheckButton:SetChecked(QMinionConfig.Enabled);
end

function QuestToolTip_OnShow()
	QMinionConfig.Enabled = 1;
	QuestCompanionCheckButton:SetChecked(QMinionConfig.Enabled);
end

function QuestToolTip_Button_OnClick()
	QMinionConfig.Enabled = QuestCompanionCheckButton:GetChecked();
	if (QMinionConfig.Enabled == 1) then
		QuestToolTip_Show(QMinionConfig.Minimized);
	else
		HideUIPanel(QuestTooltip);
	end
end

function QuestToolTip_Toggle()
	-- Print("QuestToolTip_Toggle")
	if (QMinionConfig.Enabled == 1) then
		QuestToolTip_Hide();
	else
		QuestToolTip_Show(QMinionConfig.Minimized);
	end
end

function QuestToolTip_Hide()
	QMinionConfig.Enabled = 0;
	HideUIPanel(QuestTooltip);
	QMinionConfig.Minimized = -1;
end

function QuestToolTip_MinionCheckButton_OnClick()
	local id = string.gsub(this:GetName(), "QuestLogTitle(%d+)MinionCheckButton", "%1") + FauxScrollFrame_GetOffset(QuestLogListScrollFrame);
	local questTitle = GetQuestLogTitle(id);
	if (this:GetChecked()) then
		QuestToolTip_AddToTable(questTitle);
	else
		QuestToolTip_RemoveFromTable(questTitle);
	end
	QuestToolTip_Show(3);
end

function QuestToolTip_Minimize()
	if (QMinionConfig.Minimized == 1) then
		QuestToolTip_Show(0)
	elseif (QMinionConfig.Minimized == 0) then
		QuestToolTip_Show(1)
	end
end

-- tooltip helper function
QUESTTOOLTIP_TOOLTIPS_UNSAFE_FRAMES = { 
   "TaxiFrame", "MerchantFrame", "TradeSkillFrame", "SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
   }; 

-- use this to add unsafe frames 
function QuestToolTip_TooltipsCanNotBeUsedWithFrame(frame) 
   table.insert(QUESTTOOLTIP_TOOLTIPS_UNSAFE_FRAMES, frame); 
end 


-- will return 1 if it is "safe" to use tooltips, otherwise 0 
function QuestToolTip_TooltipsCanBeUsed() 
   local frame = nil; 
   for k, v in QUESTTOOLTIP_TOOLTIPS_UNSAFE_FRAMES do 
      frame = getglobal(v); 
      if ( ( frame ) and ( frame:IsVisible() ) ) then 
         return false; 
      end 
   end 
   return true; 
end

function QuestToolTip_MakeSureSizerIsGone()
	QuestTooltipSizer:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0-UIParent:GetHeight());
	QuestTooltipSizer:Hide();
end


function QuestToolTip_Show(minimized, noSetTitle)

	if ( not QuestToolTip_TooltipsCanBeUsed() ) then
		if ( Chronos.scheduleByName ) then
			Chronos.scheduleByName("QuestToolTip_Show_Delayed", 1, QuestToolTip_Show, minimized, noSetTitle);
		end
		return;
	end	

	if (not minimized) then minimized = 0; end
	if (minimized == 0) then
		QuestToolTip_FixPos();
		if ( not QuestTooltip:IsVisible() ) then
			ShowUIPanel(QuestTooltip);
			QuestTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
		end
		QMinionConfig.Minimized = 0;
		QuestToolTip_text = "";
		QuestToolTip_QuestSearch();
		if (QuestToolTip_text == "") then QuestToolTip_text = QMINION_NOQUEST; end
		QuestTooltipSizer:SetOwner(UIParent, "ANCHOR_PRESERVE");
		Sea.wow.tooltip.protectTooltipMoney();
		QuestTooltipSizer:SetText(QuestToolTip_text);
		Sea.wow.tooltip.unprotectTooltipMoney();
		QuestToolTip_MakeSureSizerIsGone();
		width = QuestTooltipSizer:GetWidth() * 12 / 14;
		height = QuestTooltipSizer:GetHeight() * 12 / 14 + 16;
		if (width < 160) then width = 160; end
		if (QuestTooltipTextLeft1:GetText() ~= QMINION_TITLE) then
			Sea.wow.tooltip.protectTooltipMoney();
			QuestTooltip:SetText(QMINION_TITLE);
			Sea.wow.tooltip.unprotectTooltipMoney();
		end
		if (not noSetTitle) then 
			Sea.wow.tooltip.protectTooltipMoney();
			QuestTooltip:SetText(QMINION_TITLE); 
			Sea.wow.tooltip.unprotectTooltipMoney();
		end
		QuestTooltipTextLeft2:SetText(QuestToolTip_text);
		QuestTooltipTextLeft2:Show();
		QuestTooltip:SetWidth(width);
		QuestTooltip:SetHeight(height);
	elseif (minimized == 1) then
		QuestToolTip_FixPos();
		if ( not QuestTooltip:IsVisible() ) then
			ShowUIPanel(QuestTooltip);
			QuestTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
		end
		if (not noSetTitle) then 
			Sea.wow.tooltip.protectTooltipMoney();
			QuestTooltip:SetText(QMINION_TITLE); 
			Sea.wow.tooltip.unprotectTooltipMoney();
		end
		local width = QuestTooltip:GetWidth();
		local height = QuestTooltip:GetHeight();
		if (width < 160) then width = 160; end
		QuestTooltipTextLeft2:Hide();
		QuestTooltip:SetWidth(width);
		if (not noSetTitle) then height = height - 3; end
		QuestTooltip:SetHeight(height);
		QMinionConfig.Minimized = 1;
	elseif (minimized == 3) then
		if ( QuestTooltip:IsVisible() ) then
			if ( QMinionConfig.Minimized ~= 3 ) then
				QuestToolTip_Show(QMinionConfig.Minimized, noSetTitle);
			end
		end
	elseif (minimized == -1) then
		QuestToolTip_Show(0);
	end
end

function QuestToolTip_FixPos()
	if (QuestToolTip_Loaded == true) then
		local x,y = QuestTooltip:GetCenter();
		local right = QuestTooltip:GetRight();
		local left = QuestTooltip:GetLeft();
		local top = QuestTooltip:GetTop();
		local bottom = QuestTooltip:GetBottom();
		local thisWidth = QuestTooltip:GetWidth();
		local thisHeight = QuestTooltip:GetHeight();
		local screenWidth = UIParent:GetWidth();
		local screenHeight = UIParent:GetHeight();
		local scale = QuestTooltip:GetScale();
		if (screenWidth>0 and screenHeight>0 and scale~=nil) then
			local relativePoint = "BOTTOMLEFT"
			local anchorPoint = "";
			local doSet = true;
			if (x~=nil and y~=nil and left~=nil and right~=nil and top~=nil and bottom~=nil and thisWidth~=nil and thisHeight~=nil) then
				left = left * scale;
				right = right * scale;
				top = top * scale;
				bottom = bottom * scale;
				thisWidth = thisWidth * scale;
				thisHeight = thisHeight * scale;
				x = x * scale;
				y = y * scale;
				if (QuestToolTip_FirstFixPos == true) then
					QuestToolTip_FirstFixPos = false;
					if (QMinionConfig.LastLeft~=nil and QMinionConfig.LastRight~=nil and QMinionConfig.LastTop~=nil and QMinionConfig.LastBottom~=nil) then
						left = QMinionConfig.LastLeft * scale;
						right = QMinionConfig.LastRight * scale;
						top = QMinionConfig.LastTop * scale;
						bottom = QMinionConfig.LastBottom * scale;
						thisWidth = right - left;
						thisHeight = top - bottom;
						x = right - (thisWidth/2);
						y = top - (thisHeight/2);
					end
				end
			else
				if (QMinionConfig.LastLeft~=nil and QMinionConfig.LastRight~=nil and QMinionConfig.LastTop~=nil and QMinionConfig.LastBottom~=nil) then
					left = QMinionConfig.LastLeft * scale;
					right = QMinionConfig.LastRight * scale;
					top = QMinionConfig.LastTop * scale;
					bottom = QMinionConfig.LastBottom * scale;
					thisWidth = right - left;
					thisHeight = top - bottom;
					x = right - (thisWidth/2);
					y = top - (thisHeight/2);
				else
					x = 0;
					y = 80;
					anchorPoint = "BOTTOM";
					relativePoint = "BOTTOM";
					doSet = false;
				end
			end
			
			if (doSet == true) then
				if ((right<10) or (top<10) or ((left+10)>screenWidth) or ((bottom+10)>screenHeight)) then
					x = 0;
					y = 80;
					anchorPoint = "BOTTOM";
					relativePoint = "BOTTOM";
					doSet = false;
				end
			end
			
			if (doSet == true) then
				if (y < (screenHeight * (2/5))) then
					y = bottom;
					anchorPoint = "BOTTOM";
					if (y < -thisHeight) then
						doSet = false;
					end
				elseif (y > (screenHeight * (3/5))) then
					y = top;
					anchorPoint = "TOP";
					if (y-thisHeight > screenHeight) then
						doSet = false;
					end
				end
				if (x < (screenWidth * (2/5))) then
					x = left;
					anchorPoint = anchorPoint.."LEFT";
					if (x < -thisWidth) then
						doSet = false;
					end
				elseif (x > (screenWidth * (3/5))) then
					x = right;
					anchorPoint = anchorPoint.."RIGHT";
					if (x-thisWidth > screenWidth) then
						doSet = false;
					end
				end
				
				if (anchorPoint == "") then
					anchorPoint = "CENTER";
				end
				
				if (doSet) then
					QMinionConfig.LastLeft = left / scale;
					QMinionConfig.LastRight = right / scale;
					QMinionConfig.LastTop = top / scale;
					QMinionConfig.LastBottom = bottom / scale;
					RegisterForSave("QMinionConfig.LastLeft");
					RegisterForSave("QMinionConfig.LastRight");
					RegisterForSave("QMinionConfig.LastTop");
					RegisterForSave("QMinionConfig.LastBottom");
				end
			else
				doSet = true;
			end
			
			if (doSet) then
				--Print("Set - X: "..x..", Y: "..y..", anchorPoint: "..anchorPoint);
				QuestTooltip:ClearAllPoints();
				QuestTooltip:SetPoint(anchorPoint, "UIParent", relativePoint, x / scale, y / scale);
			end
		end
	end
end

function QuestToolTip_AddLine(type, comment, level)
	if (not QuestToolTip_text) then QuestToolTip_text = ""; end
	if (type == 0) then -- Title
		if (QMinionConfig.ColorTitle == 1) then
			local playerLevel = UnitLevel("player");
			local levelDiff = level - playerLevel;
			
			local coloration_co = "";
			if ( levelDiff >= 5 ) then
				coloration_co = "impossible";
			elseif ( levelDiff >= 3 ) then
				coloration_co = "verydifficult";
			elseif ( levelDiff >= -2 ) then
				coloration_co = "difficult";
			elseif ( level >= (playerLevel * 0.75) ) then
				coloration_co = "standard";
			else
				coloration_co = "trivial";
			end
			
			local red = round(QuestToolTip_Colors[coloration_co].r * 255);
			local green = round(QuestToolTip_Colors[coloration_co].g * 255);
			local blue = round(QuestToolTip_Colors[coloration_co].b * 255);
			local levelStr = "";
			if (QMinionConfig.ShowLevel == 1) then
				levelStr = "["..level.."] ";
			end
			QuestToolTip_text = QuestToolTip_text..format("|c%02X%02X%02X%02X%s%s|r\n", 255, red, green, blue, levelStr, comment);
		else
			local levelStr = "";
			if (QMinionConfig.ShowLevel == 1) then
				levelStr = "["..level.."] ";
			end
			QuestToolTip_text = QuestToolTip_text..format("|c%02X%02X%02X%02X%s%s|r\n", 255, 255, 255, 255, levelStr, comment);
		end
	elseif (type == 1) then -- Require Line
		if (QMinionConfig.ColorStatus == 1) then
			local i,j,itemname,numberitemsgot,numberitemsneeded = string.find(comment, "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$");
			if (itemname == comment) then
				local itemname = comment;
				local numberitemsgot = 0;
				local numberitemsneeded = 1;
			end
			if (not itemname) then return; end
			if (strlen(itemname) > 0 and QuestToolTip_Message ~= comment and itemname == string.gsub(QuestToolTip_Message, "([^:]+): (%d+)/(%d+)", "%1")) then
				QuestToolTip_AddLine(1, QuestToolTip_Message);
				QuestToolTip_Message = "";
				return;
			end
			if (numberitemsneeded + 0 < 1) then numberitemsneeded = 1; end
			if (numberitemsgot + 0 > numberitemsneeded + 0) then numberitemsneeded = 1; numberitemsgot = 1; end
			local green = round(255 * numberitemsgot / numberitemsneeded);
			local red = 255 - green;
			if ( (QMinionConfig.FadeObjectives) and (numberitemsgot + 0 >= numberitemsneeded + 0) ) then 
				local fadeOutTime = QMinionConfig.FadeObjectivesTime;
				if ( not fadeOutTime ) then
					fadeOutTime = 15;
				end
				local colorCutOff = 70;
				if ( not QuestToolTip_Fade ) then
					QuestToolTip_Fade = {};
				end
				if ( not QuestToolTip_Fade[comment] ) then
					QuestToolTip_Fade[comment] = GetTime();
				end
				if ( QuestToolTip_Fade[comment] == -1 ) then
					return;
				end
				local startTime = QuestToolTip_Fade[comment];
				if ( GetTime() > startTime + fadeOutTime ) then
					QuestToolTip_Fade[comment] = -1;
					return;
				end
				local diff = GetTime() - startTime;
				green = round( (255-colorCutOff) * ( ( fadeOutTime - diff ) / fadeOutTime) + colorCutOff);
				red = 5;
			end
			QuestToolTip_text = QuestToolTip_text..format(" |c%02X%02X%02X%02X- %s|r\n", 255, red, green, 0, comment);
		else
			QuestToolTip_text = QuestToolTip_text..format(" |c%02X%02X%02X%02X- %s|r\n", 255, 170, 170, 170, comment);
		end
	end
end

function QuestToolTip_QuestSearch(line, update, allowHide)
	QuestToolTip_LastSelect = GetQuestLogSelection();
	local want_quest = 0;
	local runAgain = 1;
	for y=1, GetNumQuestLogEntries(), 1 do
		local QText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(y);
		want_quest = 0;
		if (QuestToolTip_List and not update) then
			for z=1, table.getn(QuestToolTip_List) do
				if (QText == QuestToolTip_List[z]) then
					want_quest = 1;
				end
			end
		end
		SelectQuestLogEntry(y);
		local QDescription, QObjectives = GetQuestLogQuestText();
		local questMinionCheckbox;
		local i = y - FauxScrollFrame_GetOffset(QuestLogListScrollFrame);
		if (i <= 6 and i >= 1) then
			questMinionCheckbox = getglobal("QuestLogTitle"..i.."MinionCheckButton");
			questMinionCheckbox:Hide();
		end

		if (not isHeader) then
			if (i <= 6 and i >= 1) then
				if (y ~= QuestLogFrame.selectedButtonID) then
					local r,g,b = GetColor(level);
					getglobal("QuestLogTitle"..i.."HighlightText"):Hide();
					getglobal("QuestLogTitle"..i.."NormalText"):Show();
				end
				questMinionCheckbox:Show();
				questMinionCheckbox:SetChecked(0);
				if (QuestToolTip_List) then
					for i = 1, table.getn(QuestToolTip_List), 1 do
						if (QuestToolTip_List[i] == QText) then
							questMinionCheckbox:SetChecked(1);
						end
					end
				end
			end
			if (want_quest == 1) then
				QuestToolTip_AddLine(0, QText, level);
			end
			if (GetNumQuestLeaderBoards() > 0) then 
				local allDone = true;
				for i=1, GetNumQuestLeaderBoards(), 1 do --Objectives
					local string = getglobal("QuestLogObjective"..i);
					local text, type, finished = GetQuestLogLeaderBoard(i);
					if ( not text or strlen(text) == 0 ) then 
						text = type; 
					end
					
					-- TODO: allow check for if the objectives are complete, setting finished to true
					-- TODO: allow the fadeout timer to interfere with removing quests
					if (finished ~= 1) then
						allDone = false;
					end
					
					if (want_quest == 1) then -- Quest that i want
						QuestToolTip_AddLine(1, text);
					end
					if (line and QMinionConfig.AutoAdd == 1) then
						if (gsub(line,"(.*): %d+/%d+","%1",1) == gsub(text,"(.*): %d+/%d+","%1",1)) then
							QuestToolTip_AddToTable(QText);
							QuestToolTip_Show();
							return;
						end
					end
				end

				if ((allDone == true) and (QMinionConfig.RemoveComplete == 1) and (allowHide == 1)) then
					for i = 1, table.getn(QuestToolTip_List), 1 do
						if (QuestToolTip_List[i] == QText) then
							QuestToolTip_RemoveFromTable(QText);
							runAgain = true;
						end
					end
				end
			end
		end
	end
	QuestLog_SetSelection(QuestToolTip_LastSelect);
	
	if (QMinionConfig.RemoveComplete == 1 and runAgain == true) then
		QuestToolTip_text = "";
		QuestToolTip_QuestSearch(nil,nil,1);
	end

	if (QuestLogFrame:IsVisible()) then
		if (GetNumQuestLogEntries() < 6) then
			for i = GetNumQuestLogEntries()+1, 6, 1 do
				if (i > 0 and i < 7) then
					getglobal("QuestLogTitle"..i.."MinionCheckButton"):Hide();
				end
			end
		end
	end
end

function GetColor(level)
	local playerLevel = UnitLevel("player");
	local levelDiff = level - playerLevel;
	local coloration_co = "";
	if ( levelDiff >= 5 ) then
		coloration_co = "impossible";
	elseif ( levelDiff >= 3 ) then
		coloration_co = "verydifficult";
	elseif ( levelDiff >= -2 ) then
		coloration_co = "difficult";
	elseif ( level >= (playerLevel * 0.75) ) then
		coloration_co = "standard";
	else
		coloration_co = "trivial";
	end
	return QuestToolTip_Colors[coloration_co].r, QuestToolTip_Colors[coloration_co].g, QuestToolTip_Colors[coloration_co].b;
end

function QuestToolTip_GetTooltip()
	local tooltip = getglobal("CosmosTooltip");
	if ( not tooltip ) then
		tooltip = getglobal("GameTooltip");
	end
	return tooltip;
end
