--[[

	MonkeyQuest:
	Displays your quests for quick viewing.
	
	Website:	http://wow.visualization.ca/
	Author:		Trentin (monkeymods@gmail.com)
	
	
	Contributors:
	Celdor
		- Help with the Quest Log Freeze bug
		
	Diungo
		- Toggle grow direction
		
	Pkp
		- Color Quest Titles the same as the quest level
	
	wowpendium.de
		- German translation
		
	MarsMod
		- Valid player name before the VARIABLES_LOADED event bug
		- Settings resetting bug

--]]


function MonkeyQuestInit_LoadConfig()
	
	-- double check that we aren't already loaded
	if (MonkeyQuest.m_bLoaded == true) then
		-- how did it even get here?
		return;
	end
	
	-- double check that variables loaded event triggered, if not, exit
	if (MonkeyQuest.m_bVariablesLoaded == false) then
		return;
	end
		
	-- add the realm to the "player's name" for the config settings
	MonkeyQuest.m_strPlayer = GetCVar("realmName").."|"..MonkeyQuest.m_strPlayer;
	
	-- check if the variable needs initializing
	if (not MonkeyQuestConfig) then
		MonkeyQuestConfig = {};
	end
	
	-- if there's not an entry for this
	if (not MonkeyQuestConfig[MonkeyQuest.m_strPlayer]) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer] = {};
	end	
	
	-- set the defaults if the variables don't exist
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDisplay == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDisplay = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strAnchor == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strAnchor = "ANCHOR_TOPLEFT";
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bObjectives == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bObjectives = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha = MONKEYQUEST_DEFAULT_ALPHA;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized == nil) then
		-- LedMirage 3/21/2005 default variable change
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList = {};
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameWidth == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameWidth = MONKEYQUEST_DEFAULT_WIDTH;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowHidden == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowHidden = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoHeaders == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoHeaders = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bGrowUp == nil) then
		-- LedMirage 3/21/2005 default variable change
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bGrowUp = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowNumQuests == nil) then
		-- LedMirage 3/21/2005 default variable change
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowNumQuests = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bLocked == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bLocked = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedQuests == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedQuests = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedObjectives == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedObjectives = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bAllowRightClick == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bAllowRightClick = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowTooltipObjectives == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowTooltipObjectives = true;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideTitleButtons == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideTitleButtons = false;
	end
	
	-- colour config vars
	-- Begin Pkp Changes
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bColourTitle == nil) then
		-- LedMirage 3/21/2005 default variable change
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bColourTitle = true;
	end
	-- end Pkp Changes
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strQuestTitleColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strQuestTitleColour = MONKEYQUEST_DEFAULT_QUESTTITLECOLOUR;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderOpenColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderOpenColour = MONKEYQUEST_DEFAULT_HEADEROPENCOLOUR;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderClosedColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderClosedColour = MONKEYQUEST_DEFAULT_HEADERCLOSEDCOLOUR;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strOverviewColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strOverviewColour = MONKEYQUEST_DEFAULT_OVERVIEWCOLOUR;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strSpecialObjectiveColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strSpecialObjectiveColour = MONKEYQUEST_DEFAULT_SPECIALOBJECTIVECOLOUR;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strInitialObjectiveColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strInitialObjectiveColour = MONKEYQUEST_DEFAULT_INITIALOBJECTIVECOLOUR;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strCompleteObjectiveColour == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strCompleteObjectiveColour = MONKEYQUEST_DEFAULT_COMPLETEOBJECTIVECOLOUR;
	end
	
	-- font configs
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFontHeight == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFontHeight = 12;
	end
	
	-- debugging
	
	-- special case, not using these vars anymore, delete them
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bKeepHeaders ~= nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bKeepHeaders = nil;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDefaultAnchor ~= nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDefaultAnchor = nil;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList ~= nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList = nil;
	end
	
	-- show or hide the main frame
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDisplay == true) then
		MonkeyQuestFrame:Show();
	else
		MonkeyQuestFrame:Hide();
	end
	
	-- make sure the minimize button has the right texture
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized == true) then
		MonkeyQuestMinimizeButton:SetNormalTexture("Interface\\AddOns\\MonkeyQuest\\MinimizeButton-Down");
	else
		MonkeyQuestMinimizeButton:SetNormalTexture("Interface\\AddOns\\MonkeyQuest\\MinimizeButton-Up");
	end
	
	-- show or hide the title buttons
	MonkeyQuestSlash_CmdHideTitleButtons(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideTitleButtons);
	
	-- set the alpha
	MonkeyQuest_SetAlpha(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha);
	
	-- set the border
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder == true) then
		MonkeyQuestFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0);
	else
		MonkeyQuestFrame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1.0);
	end

	-- set the width
	MonkeyQuestFrame:SetWidth(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameWidth);

	-- All variables are loaded now
	MonkeyQuest.m_bLoaded = true;

	MonkeyQuest_Refresh();

	-- Let the user know the mod is loaded
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(MONKEYQUEST_LOADED_MSG);
	end
end

function MonkeyQuestInit_CleanQuestList()
	-- make sure the hidden array is ready to go
	local iNumEntries, iNumQuests = GetNumQuestLogEntries();

	-- Remember the currently selected quest log entry
	local tmpQuestLogSelection = GetQuestLogSelection();	

	MonkeyQuest.m_iNumEntries = iNumEntries;

	-- go through the quest list and m_aQuestList is initialized
	for i = 1, iNumEntries, 1 do
		-- strQuestLogTitleText		the title text of the quest, may be a header (ex. Wetlands)
		-- strQuestLevel			the level of the quest
		-- strQuestTag				the tag on the quest (ex. COMPLETED)
		local strQuestLogTitleText, strQuestLevel, strQuestTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		
		MonkeyQuest.m_aQuestList[strQuestLogTitleText] = {};
		
		-- put the entry in the hidden list if it's not there already
		if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList[strQuestLogTitleText] == nil) then
			MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList[strQuestLogTitleText] = {};
			MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList[strQuestLogTitleText].m_bChecked = true;
		end
			
		MonkeyQuest.m_aQuestList[strQuestLogTitleText].m_bChecked = 
			MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList[strQuestLogTitleText].m_bChecked;
	end
	
	-- clean up the config hidden list
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList = nil;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList = {};
	
	
	-- delete the objective list, we're about to rebuild it
	MonkeyQuest.m_aQuestItemList = nil;
	MonkeyQuest.m_aQuestItemList = {};
	
	
	-- go through the quest list one more time and copy the entries from the temp list to the real list.
	--  this gets rid of any list entries for quests the user doesn't have
	for i = 1, iNumEntries, 1 do
		-- strQuestLogTitleText		the title text of the quest, may be a header (ex. Wetlands)
		-- strQuestLevel			the level of the quest
		-- strQuestTag				the tag on the quest (ex. COMPLETED)
		local strQuestLogTitleText, strQuestLevel, strQuestTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList[strQuestLogTitleText] = {};
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList[strQuestLogTitleText].m_bChecked = 
			MonkeyQuest.m_aQuestList[strQuestLogTitleText].m_bChecked;
			
		
		-- Select the quest log entry for other functions like GetNumQuestLeaderBoards()
		SelectQuestLogEntry(i);
		
		-- here's a good place to create the objective list
		if (GetNumQuestLeaderBoards() > 0) then
			for ii = 1, GetNumQuestLeaderBoards(), 1 do
				--local string = getglobal("QuestLogObjective"..ii);
				local strLeaderBoardText, strType, iFinished = GetQuestLogLeaderBoard(ii);
				
				MonkeyQuest_AddQuestItemToList(strLeaderBoardText);
			end
		end
	end
	
	-- Restore the currently quest log selection
	SelectQuestLogEntry(tmpQuestLogSelection);
	
	-- kill it
	MonkeyQuest.m_aQuestList = nil;
end

function MonkeyQuestInit_ResetConfig()

	-- reset all the config variables to the defaults, but keep the hidden list intact
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDisplay = true;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDefaultAnchor = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strAnchor = "ANCHOR_TOPLEFT";
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bObjectives = true;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha = MONKEYQUEST_DEFAULT_ALPHA;
	-- LedMirage 3/21/2005 default variable change
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized = true;
	--MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_aQuestList = {};
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameWidth = MONKEYQUEST_DEFAULT_WIDTH;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowHidden = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoHeaders = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder = false;
	-- LedMirage 3/21/2005 default variable change
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bGrowUp = true;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameLeft = MONKEYQUEST_DEFAULT_LEFT;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameTop = MONKEYQUEST_DEFAULT_TOP;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameBottom = MONKEYQUEST_DEFAULT_BOTTOM;
	-- LedMirage 3/21/2005 default variable change
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowNumQuests = true;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bLocked = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedQuests = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedObjectives = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bAllowRightClick = true;
	-- LedMirage 3/21/2005 default variable change
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowTooltipObjectives = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideTitleButtons = false;
	
	-- colours
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strQuestTitleColour = MONKEYQUEST_DEFAULT_QUESTTITLECOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderOpenColour = MONKEYQUEST_DEFAULT_HEADEROPENCOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderClosedColour = MONKEYQUEST_DEFAULT_HEADERCLOSEDCOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strOverviewColour = MONKEYQUEST_DEFAULT_OVERVIEWCOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strSpecialObjectiveColour = MONKEYQUEST_DEFAULT_SPECIALOBJECTIVECOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strInitialObjectiveColour = MONKEYQUEST_DEFAULT_INITIALOBJECTIVECOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strCompleteObjectiveColour = MONKEYQUEST_DEFAULT_COMPLETEOBJECTIVECOLOUR;
	
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFontHeight = 12;
	
	-- show or hide the main frame
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDisplay == true) then
		MonkeyQuestFrame:Show();
	else
		MonkeyQuestFrame:Hide();
	end
	
	-- make sure the minimize button has the right texture
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized == true) then
		MonkeyQuestMinimizeButton:SetNormalTexture("Interface\\AddOns\\MonkeyQuest\\MinimizeButton-Down");
	else
		MonkeyQuestMinimizeButton:SetNormalTexture("Interface\\AddOns\\MonkeyQuest\\MinimizeButton-Up");
	end
	
	-- show or hide the title buttons
	MonkeyQuestSlash_CmdHideTitleButtons(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideTitleButtons);
	
	-- set the alpha
	MonkeyQuest_SetAlpha(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha);
	
	-- set the border
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder == true) then
		MonkeyQuestFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0);
	else
		MonkeyQuestFrame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1.0);
	end

	-- set the width
	MonkeyQuestFrame:SetWidth(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameWidth);
	
	MonkeyQuest_Refresh();
	
	-- check for MonkeyBuddy
	if (MonkeyBuddyQuestFrame_Refresh ~= nil) then
		MonkeyBuddyQuestFrame_Refresh();
	end
end