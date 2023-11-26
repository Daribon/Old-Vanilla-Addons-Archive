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
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList = {};
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
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bGrowUp = false;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowNumQuests == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowNumQuests = false;
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
	
	-- colour config vars
	-- Begin Pkp Changes
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bColourTitle == nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bColourTitle = false;
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
	
	
	-- special case, not using these vars anymore, delete them
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bKeepHeaders ~= nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bKeepHeaders = nil;
	end
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDefaultAnchor ~= nil) then
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDefaultAnchor = nil;
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
	
	-- set the alpha
	MonkeyQuest_SetAlpha(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha);
	
	-- set the border
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder == true) then
		MonkeyQuestFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0);
	else
		MonkeyQuestFrame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1.0);
	end

	-- All variables are loaded now
	MonkeyQuest.m_bLoaded = true;

	-- Let the user know the mod is loaded
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(MONKEYQUEST_LOADED_MSG);
	end
	
	-- refresh the MonkeyQuest so it shows the proper info
	--MonkeyQuest_Refresh();
end

function MonkeyQuestInit_CleanHiddenList()
	-- make sure the hidden array is ready to go
	local iNumEntries, iNumQuests = GetNumQuestLogEntries();
	

	MonkeyQuest.m_iNumEntries = iNumEntries;

	-- go through the quest list and m_abHiddenList is initialized
	for i = 1, iNumEntries, 1 do
		-- strQuestLogTitleText		the title text of the quest, may be a header (ex. Wetlands)
		-- strQuestLevel			the level of the quest
		-- strQuestTag				the tag on the quest (ex. COMPLETED)
		local strQuestLogTitleText, strQuestLevel, strQuestTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		
		MonkeyQuest.m_abHiddenList[strQuestLogTitleText] = {};
		
		-- put the entry in the hidden list if it's not there already
		if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList[strQuestLogTitleText] == nil) then
			MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList[strQuestLogTitleText] = {};
			MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList[strQuestLogTitleText].m_bChecked = true;
		end
			
		MonkeyQuest.m_abHiddenList[strQuestLogTitleText].m_bChecked = 
			MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList[strQuestLogTitleText].m_bChecked;
	end
	
	-- clean up the config hidden list
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList = nil;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList = {};
	
	-- go through the quest list one more time and copy the entries from the temp list to the real list.
	--  this gets rid of any list entries for quests the user doesn't have
	for i = 1, iNumEntries, 1 do
		-- strQuestLogTitleText		the title text of the quest, may be a header (ex. Wetlands)
		-- strQuestLevel			the level of the quest
		-- strQuestTag				the tag on the quest (ex. COMPLETED)
		local strQuestLogTitleText, strQuestLevel, strQuestTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList[strQuestLogTitleText] = {};
		MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList[strQuestLogTitleText].m_bChecked = 
			MonkeyQuest.m_abHiddenList[strQuestLogTitleText].m_bChecked;
	end
end

function MonkeyQuestInit_ResetConfig()

	-- reset all the config variables to the defaults, but keep the hidden list intact
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDisplay = true;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bDefaultAnchor = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strAnchor = "ANCHOR_TOPLEFT";
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bObjectives = true;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha = MONKEYQUEST_DEFAULT_ALPHA;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bMinimized = false;
	--MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_abHiddenList = {};
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameWidth = MONKEYQUEST_DEFAULT_WIDTH;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowHidden = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoHeaders = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bGrowUp = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameLeft = MONKEYQUEST_DEFAULT_LEFT;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameTop = MONKEYQUEST_DEFAULT_TOP;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iFrameBottom = MONKEYQUEST_DEFAULT_BOTTOM;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowNumQuests = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bLocked = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedQuests = false;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bHideCompletedObjectives = false;
	
	-- colours
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strQuestTitleColour = MONKEYQUEST_DEFAULT_QUESTTITLECOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderOpenColour = MONKEYQUEST_DEFAULT_HEADEROPENCOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strHeaderClosedColour = MONKEYQUEST_DEFAULT_HEADERCLOSEDCOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strOverviewColour = MONKEYQUEST_DEFAULT_OVERVIEWCOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strSpecialObjectiveColour = MONKEYQUEST_DEFAULT_SPECIALOBJECTIVECOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strInitialObjectiveColour = MONKEYQUEST_DEFAULT_INITIALOBJECTIVECOLOUR;
	MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_strCompleteObjectiveColour = MONKEYQUEST_DEFAULT_COMPLETEOBJECTIVECOLOUR;
	
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
	
	-- set the alpha
	MonkeyQuest_SetAlpha(MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_iAlpha);
	
	-- set the border
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bNoBorder == true) then
		MonkeyQuestFrame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0);
	else
		MonkeyQuestFrame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1.0);
	end
		
	MonkeyQuest_Refresh();
	
	-- check for MonkeyBuddy
	if (MonkeyBuddyQuestFrame_Refresh ~= nil) then
		MonkeyBuddyQuestFrame_Refresh();
	end
end