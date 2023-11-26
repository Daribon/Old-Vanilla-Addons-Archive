--[[
--
--	Party Quests
--		By Marek Gorecki
--
--		Recode by
--			Alexander of Blackrock
--
--	"Secret Quests are no fun. Secret Quests are for everyone!"
--
--	Shares party member quests. 
--
--	$Author: AlexYoshi $
--	$Rev: 999 $
--	$Date: 2005-03-10 21:07:10 -0500 (Thu, 10 Mar 2005) $
--]]

-- Debug
PARTYQUESTS_DEBUG_MESSAGES = false;
PQ_DEBUG = "PARTYQUESTS_DEBUG_MESSAGES";

PARTYQUESTS_MAILCHECK_INTERVAL = 3; 	-- Check the mail every 4 seconds
PARTYQUESTS_BLOCK_UPDATES_OLDER_THAN = 180; -- Seconds
PARTYQUESTS_LOG_SEND_COOLDOWN = 60; 	-- Send broadcasts no more than once a minute
PARTYQUESTS_NEED_LOGS_DELAY = 3; 	-- Seconds
PARTYQUESTS_LOG_EXPIRATION = 300; 	-- Seconds
PARTYQUESTS_WAITING_UPDATE_DELAY = 1; 	-- Seconds
PARTYQUESTS_WAITING_FAILURE_DELAY = 70;	-- Seconds
PARTYQUESTS_GUI_REFRESH_DELAY = .1;	-- Seconds
PARTYQUESTS_TOOLTIP_MAX_CHAR_WIDTH = 32; -- Characters
-- Colors
PQ_BANNER_UPDATE_COLOR = {r=1,g=1,b=0}; -- Yellow
PQ_BANNER_COMPLETE_COLOR = {r=0,g=1,b=0}; -- Green

-- Command Constants

-- Broadcasts
PARTYQUESTS_ANNOUNCE = "ANN_";
PARTYQUESTS_ANNOUNCE_PROGRESS = "ANN_PROG";
PARTYQUESTS_ANNOUNCE_COMPLETE = "ANN_COMP";

-- Requests
PARTYQUESTS_REQUEST = "REQ_";
PARTYQUESTS_REQUEST_NEEDALL = "REQ_NEEDALL";
PARTYQUESTS_REQUEST_NEED    = "REQ_NEEDLOGS";
PARTYQUESTS_REQUEST_STATUS  = "REQ_STATUS";
PARTYQUESTS_REQUEST_DETAILS = "REQ_DETAILS";

-- Recording
PARTYQUESTS_RECORD = "REC_";
PARTYQUESTS_RECORD_DETAILS = "REC_DETAILS";
PARTYQUESTS_RECORD_LOG     = "REC_LOG";
PARTYQUESTS_RECORD_STATUS  = "REC_STATUS";
PARTYQUESTS_RECORD_DELETE  = "REC_DELETE";
PARTYQUESTS_RECORD_ADD	   = "REC_ADD";

-- Negative Acknowledgement
PARTYQUESTS_NACK = "NAK_";
PARTYQUESTS_NACK_STATUS   = "NAK_STATUS";
PARTYQUESTS_NACK_DETAILS  = "NAK_DETAILS";

-- Data Constants
PARTYQUESTS_NOSUCHQUEST = "NOSUCHQUEST"; 

-- States
PARTYQUESTS_WAITING = "WAITING";
PARTYQUESTS_FAILED = "FAILED";

-- Quests
PartyQuests_PartyQuests = {};
PartyQuests_PartyQuestsCache = {}; -- [PlayerName][QuestID]

-- Settings
PartyQuests_QuestSettings = {};
PartyQuests_QuestSettings.common = {sortMethod="level";showDetailedTooltip=true;};
PartyQuests_QuestSettings.player = {sortMethod="zone";zonesOn=true;showCompletedBanner=true;showDetailedTooltip=true;};
PartyQuests_QuestSettings.party = {sortMethod="level";zonesOn=false;showCompletedBanner=true;};

-- Strings
PartyQuests_SettingsString = {
	["player"] =  PARTYQUESTS_SETTING_PLAYER;
	["common"] =  PARTYQUESTS_SETTING_COMMON;
	["party"]  =  PARTYQUESTS_SETTING_PARTY;
};

-- Stored Gui
PartyQuests_OldSelf = nil;
PartyQuests_OldParty = nil;
PartyQuests_OldSelfTime = 0;
PartyQuests_OldPartyTime = 0;
PartyQuests_CurrentQuest = nil;
PartyQuests_LastUpdateTime = 0;
PartyQuests_JoinPartyAlert = nil;

-- Please don't ask
PartyQuests_WhoNeedsMyLog = {};
PartyQuests_Cooldown = 0;

-- Current log log
PartyQuests_MyCurrentLog = {};

--[[ Obtains the common quests and party quest tree or filler data ]]--
function PartyQuests_GetPartyQuestTree()
	-- Generate CommonQuests
	return PartyQuests_PartyQuests;
end

--[[ Generates the current player's quest list ]]--
function PartyQuests_GetPlayerQuestTree()
	PartyQuests_MyCurrentLog = Libram.requestHistory();
	return PartyQuests_MyCurrentLog;
end

--[[ Determines which quests are common with other players ]]--
function PartyQuests_GetCommonQuestsTree()
	local myQuests =  PartyQuests_GetPlayerQuestTree();
	local partyQuests = PartyQuests_GetPartyQuestTree();
	local commonQuests = {};

	for zone,quests in myQuests do 
		if (type (quests) == "table" ) then
			for k,quest in quests do 
				if ( type ( quest ) == "table" ) then 
				local added = false;
				for ally,allyData in partyQuests do 
					if ( allyData.quests ) then 
						if ( allyData.quests[zone] ) then 
							for k2,allyQuest in allyData.quests[zone] do
								if ( type (allyQuest) == "table" ) then 
								if ( quest.title == allyQuest.title and quest.level == allyQuest.level ) then
									if ( not quest.allies ) then 
										-- You minimally should have this quest, or its not common, duh
										quest.allies = {UnitName("player")};
									else
										if ( not Sea.list.isInList(quest.allies, ally) ) then 
											table.insert(quest.allies, ally);
										end
									end
	
									if ( not quest.completeCount ) then
										quest.completeCount = 0;
										if ( quest.complete ) then
											quest.completeCount = 1;
										end
									end
									
									-- Increment the completed counter
									if ( allyQuest.complete ) then 
										quest.completeCount = quest.completeCount+1;
									end
								
									-- Determine if everyone is done
									if ( quest.completeCount == table.getn(quest.allies) ) then 
										quest.complete = true;
									else 
										quest.complete = false;
									end

									-- List the number of complete out of alies so far
									quest.tag = string.format("%d/%d", quest.completeCount, table.getn(quest.allies));
									
									if ( not quest.objectives ) then
										quest.objectives = {};
									end

									if ( allyQuest.status ) then
										local found = false;
										for k4, allyStatus in quest.objectives do 
											if ( allyStatus.name == ally ) then found = true; end
										end
										if ( not found ) then 
											table.insert(quest.objectives, {name=ally,status=allyQuest.status} );
										end
									end
								
									if ( not added ) then
										added = true;
										if ( not commonQuests[zone] ) then
											commonQuests[zone] = {};
										end
										table.insert(commonQuests[zone], quest);
									end
								end
								end
							end
						end
					end
				end
				end
			end
		end
	end

	return commonQuests;
end

--[[ Converts Quest Trees into Enhanced Tree ]]--
function PartyQuests_ConvertQuestTreeToEnhancedTree(questTree, funcList)
	local enhancedTree = {};

	-- Loop through the zone list
	for zone,questList in questTree do
		if ( type(questList) == "table" ) then 
			
			local zoneQuests = {};
			zoneQuests.title = zone;
			zoneQuests.zone = zone;
			zoneQuests.collapsed = questList.collapsed;
			zoneQuests.children = {};
		
			-- Loop through the quest list
			for i=1,table.getn(questList) do 
				quest = questList[i];
				if ( type ( quest ) == "table" ) then 
					local entry = {};
					local id = quest.flatid;			

					-- Format it into [12] Quest of Danger
					if ( questList.showLevel ) then 
						entry.title = string.format(PARTYQUESTS_QUEST_TITLE, quest.level, quest.title); 
					else
						entry.title = quest.title;
					end
					entry.level = quest.level;
					entry.questTitle = quest.title;
					entry.zone = zone;

					-- The important value is the id
					entry.value = {id=id, title=quest.title, level=quest.level, zone=zone};

					-- Pretty up the (Elite)
					if ( quest.tag ) then 
						entry.right = string.format(PARTYQUESTS_QUEST_TITLE_TAG, quest.tag); 
					end
					if ( quest.complete ) then 
						entry.right = string.format(PARTYQUESTS_QUEST_TITLE_TAG, TEXT(COMPLETE)); 
					end

					-- Lets add some color
					entry.titleColor = GetDifficultyColor(quest.level);
			
					-- Add the event handlers
					if ( funcList ) then 
						local title = quest.title;
						local level = quest.level;
						local onClick = funcList.onClick;
						if ( onClick ) then 
							entry.onClick = onClick;
						end
						if ( funcList.tooltipFunc ) then 
							entry.tooltip = funcList.tooltipFunc;
						end
					end					
			
					table.insert(zoneQuests.children,entry);
				end		
			end

			zoneQuests.right = string.format(PQ_NUMQUESTS,table.getn(zoneQuests.children));
			zoneQuests.rightColor = GRAY_FONT_COLOR;
			zoneQuests.value = {zone=zone};

			-- Add the event handlers
			if ( funcList ) then
				local onClick = funcList.onZoneClick;
				if ( onClick ) then 
					zoneQuests.onClick = onClick;
				end
				local onCollapseClick = funcList.onCollapseClick;
				if ( onCollapseClick ) then 
					zoneQuests.onCollapseClick = onCollapseClick;
				end
				local tooltipFunc = funcList.zoneTooltipFunc;
				if ( tooltipFunc ) then 
					zoneQuests.tooltip = tooltipFunc(zone, questList);
				end
			end
			table.insert(enhancedTree,zoneQuests);
		end
	end

	return enhancedTree;
end

--[[ Converts the player's quest tree to an enhanced tree ]]--
function PartyQuests_ConvertPlayerQuestTreeToEnhancedTree(tree)
	local playerTree= {};
	-- Set title
	playerTree.title = PQ_MYQUEST;

	-- Add Collapsed state
	if ( PartyQuests_QuestSettings.player.collapsed == nil ) then 
		PartyQuests_QuestSettings.player.collapsed = true;
	else
		playerTree.collapsed = PartyQuests_QuestSettings.player.collapsed;
	end
	-- Collapsed Handler
	playerTree.onCollapseClick = PartyQuests_StorePlayerCollapsed;
	
	if ( tree ) then 
		local funcList = {
			onClick=PartyQuests_OnPlayerQuestClick;
			onZoneClick=PartyQuests_OnPlayerQuestClick;
			onCollapseClick=PartyQuests_StorePlayerZoneCollapsed;
			tooltipFunc=PartyQuests_CreatePlayerTooltip;
		};

		-- Collapse the player's quests
		for zone,questList in tree do 
			if ( PartyQuests_QuestSettings.player[zone] ) then 
				if ( PartyQuests_QuestSettings.player[zone] ) then 
					tree[zone].collapsed = PartyQuests_QuestSettings.player[zone].collapsed;
				end
			end	
			-- Show the title
			if ( PartyQuests_QuestSettings.player.showLevel ~= nil ) then 
				questList.showLevel = PartyQuests_QuestSettings.player.showLevel
			else
				questList.showLevel = true;
			end
		end
		
		local eTree = PartyQuests_ConvertQuestTreeToEnhancedTree(tree, funcList);

		if ( table.getn(eTree) > 0 ) then
			-- Sort the eTree
			eTree = PartyQuests_SortQuestTree(eTree, "player");

			playerTree.children = eTree;
		end
	end
	
	return playerTree;
end	

--[[ Sets the collapsed value for a player's tree ]]--
function PartyQuests_StorePlayerCollapsed( collapsed ) 
		if ( not PartyQuests_QuestSettings.player ) then 
			PartyQuests_QuestSettings.player = {};
		end
		PartyQuests_QuestSettings.player.collapsed = collapsed;
end;

--[[ Sets the collapsed value for a player's zone tree ]]--
function PartyQuests_StorePlayerZoneCollapsed( collapsed, value ) 
		if ( not PartyQuests_QuestSettings.player[value.zone] ) then 
			PartyQuests_QuestSettings.player[value.zone] = {};
		end
		PartyQuests_QuestSettings.player[value.zone].collapsed = collapsed;
end;

--[[ Converts the common quest tree into an enhanced tree ]]--
function PartyQuests_ConvertCommonQuestTreeToEnhancedTree(tree)
	local commonTree = {};
	commonTree.title = PQ_COMMONQUESTS;

	-- Set collapsed state
	if ( PartyQuests_QuestSettings.common.collapsed == nil ) then 
		commonTree.collapsed = true;
	else
		commonTree.collapsed = PartyQuests_QuestSettings.common.collapsed;
	end	
	commonTree.onCollapseClick = function ( collapsed ) 
		if ( not PartyQuests_QuestSettings.common ) then 
			PartyQuests_QuestSettings.common = {};
		end
		PartyQuests_QuestSettings.common.collapsed = collapsed;
	end;
	
	if ( tree ) then
		local funcList = {
			onClick=PartyQuests_OnCommonQuestClick;
			onZoneClick=PartyQuests_OnCommonQuestClick;
			onCollapseClick=PartyQuests_StoreCommonZoneCollapse;
			tooltipFunc = PartyQuests_CreateCommonTooltip; 
		};

		-- Load the collapse structure
		for zone,list in tree do 
			if ( PartyQuests_QuestSettings.common[zone] ) then 
				if ( PartyQuests_QuestSettings.common[zone].collapsed ) then 
					tree[zone].collapsed = PartyQuests_QuestSettings.common[zone].collapsed;
				end
			end
			if ( PartyQuests_QuestSettings.common.showLevel ~= nil ) then 
				list.showLevel = PartyQuests_QuestSettings.common.showLevel;
			else
				list.showLevel = true;
			end

		end
		
		local eTree = PartyQuests_ConvertQuestTreeToEnhancedTree(tree, funcList);

		-- Sort the eTree
		eTree = PartyQuests_SortQuestTree(eTree, "common");

		if ( table.getn(eTree) > 0 ) then 
			commonTree.children = eTree;
		end
	end

	commonTree.right = PartyQuests_GetCommonTreeTag;
	commonTree.rightColor = BLUE_FONT_COLOR;

	return commonTree;
end

--[[ Returns a string saying if the common tree is waiting ]]--
function PartyQuests_GetCommonTreeTag()
	-- Am I waiting on anything
	if ( PartyQuests_AmIWaiting() ) then 
		if ( not PartyQuests_QuestSettings.common.waitCount ) then
			PartyQuests_QuestSettings.common.waitCount = 0;
		end

		PartyQuests_QuestSettings.common.waitCount = math.mod(PartyQuests_QuestSettings.common.waitCount+1, 4);
		
		return getglobal("PARTYQUESTS_BUILDING_"..PartyQuests_QuestSettings.common.waitCount);
	end
end

--[[ Converts the specified ally's quest tree to an enhanced tree ]]--
function PartyQuests_ConvertAllyQuestTreeToEnhancedTree(username, allyData)
	local allyTree = {};
	allyTree.title = string.format(PQ_XQUESTS, username);
	
	if ( allyData.quests ) then 
		-- Check if collapsed
		if ( not PartyQuests_QuestSettings.party[username] ) then
			PartyQuests_QuestSettings.party[username] = {};
		end
		if (PartyQuests_QuestSettings.party[username].collapsed == nil ) then
			allyTree.collapsed = true;
		else
			allyTree.collapsed = PartyQuests_QuestSettings.party[username].collapsed;
		end
		allyTree.onCollapseClick = function ( collapsed ) 
			if ( not PartyQuests_QuestSettings.party[username] ) then
				PartyQuests_QuestSettings.party[username] = {};
			end
			PartyQuests_QuestSettings.party[username].collapsed = collapsed;
		end;
		
		-- Do Something
		local funcList = {};
		funcList.onClick = function(value)
			PartyQuests_OnPartyQuestClick(username, value.title, value.level);
		end;
		funcList.onZoneClick = function(value)
			PartyQuests_OnPartyQuestClick(username, value.title, value.level);
		end;
		funcList.onCollapseClick = function ( collapsed, value ) 
			if ( not value.zone ) then 
				return;
			end
			if ( PartyQuests_QuestSettings.party[username] ) then
				if ( not  PartyQuests_QuestSettings.party[username][value.zone] ) then
					PartyQuests_QuestSettings.party[username][value.zone] = {};
				end
				if ( PartyQuests_QuestSettings.party[username][value.zone] ) then
					PartyQuests_QuestSettings.party[username][value.zone].collapsed = collapsed;
				end
			end
			if ( PartyQuests_QuestSettings.party.showLevel ~= nil ) then 
				list.showLevel = PartyQuests_QuestSettings.party.showLevel;
			else
				list.showLevel = true;
			end
			
		end;

		-- Collapse the ally's quests
		for zone,questList in tree do 
			if ( PartyQuests_QuestSettings.party[username][zone] ) then 
				if ( PartyQuests_QuestSettings.party[username][zone] ) then 
					tree[zone].collapsed = PartyQuests_QuestSettings.party[username][zone].collapsed;
				end
			end
			if ( PartyQuests_QuestSettings.party.showLevel ~= nil ) then 
				questList.showLevel = PartyQuests_QuestSettings.party.showLevel;
			else
				questList.showLevel = true;
			end

		end		
		
		-- Convert the quests over
		local eTree = PartyQuests_ConvertQuestTreeToEnhancedTree(allyData.quests, funcList);
		-- Sort the eTree
		eTree = PartyQuests_SortQuestTree(eTree, "party", username);

		-- Strip out All Quests for party members.=
		if ( eTree[1] ) then 
			if ( table.getn(eTree) == 1 and eTree[1].title == PARTYQUESTS_ALLQUESTS ) then 
				eTree = eTree[1].children;
			end
		end
		allyTree.children = eTree;
	end
		
	allyTree.right = function() return PartyQuests_GetAllyTreeTag ( username ); end;
	allyTree.rightColor = BLUE_FONT_COLOR;

	return allyTree;
end

--[[ Gets the tag for the allyTree ]]--
function PartyQuests_GetAllyTreeTag(username)
	local allyData = PartyQuests_PartyQuests[username];
	if ( allyData ) then 
		if ( allyData.waiting ) then	
			if ( allyData.waiting == PARTYQUESTS_FAILED ) then 
				return PARTYQUESTS_FAILED_TEXT, RED_FONT_COLOR;
			else
				if ( not allyData.waitCount ) then
					allyData.waitCount = 0;
				end
				
				allyData.waitCount = math.mod(allyData.waitCount+1, 4);				
				return getglobal("PARTYQUESTS_WAITING_"..allyData.waitCount);		
			end
		elseif ( allyData.noSky == false ) then 
			return PARTYQUESTS_NOTSKYUSER_TEXT;
		end
	end
end

--[[ Create the Player Tooltip ]]--
function PartyQuests_CreatePlayerTooltip(quest)
	local tooltip = nil;
	if ( type( quest ) == "table" and PartyQuests_QuestSettings.player.showDetailedTooltip ) then 
		if ( quest.id ) then 
			local questInfo = PartyQuests_GetPlayerQuestInfo(quest.id);

			-- An un-nessecarily long block of text 
			if ( questInfo.objective ) then
				local text = questInfo.objective;
				tooltip = "";
				if ( string.len(text) > PARTYQUESTS_TOOLTIP_MAX_CHAR_WIDTH ) then 
					local i = 1;
					while ( text and text ~= "" and i < 30) do
						local e = 1;
						if ( string.find(text, " ",  PARTYQUESTS_TOOLTIP_MAX_CHAR_WIDTH ) ) then 
							e = string.find(text, " ",  PARTYQUESTS_TOOLTIP_MAX_CHAR_WIDTH );
						else
							e = string.len(text);
						end
						
						local small = string.sub(text, 1, e);
						if ( small ) then 
							tooltip = tooltip..small.."\n";
						else
							tooltip = tooltip..text.."\n";
						end
						text = string.sub(text, e+1 );
						i = i + 1;
					end
				else
					tooltip = text;
				end
			end
			if ( questInfo.objectives and table.getn(questInfo.objectives) > 0 ) then
				if ( not tooltip ) then tooltip = ""; end 
				tooltip = tooltip..string.format(PQ_NBOBJ, table.getn(questInfo.objectives) );
				for k,v in questInfo.objectives do
					tooltip = tooltip.."\n"..v.text;

					if ( v.finished ) then 
						tooltip = tooltip.." "..string.format(PARTYQUESTS_QUEST_TITLE_TAG,COMPLETE);
					end
				end	
			end
		end
	end				
	return tooltip;
end
--[[ Create the Common Tooltip ]]--
function PartyQuests_CreateCommonTooltip(quest)
	if ( 	type( quest ) == "table" 
		and type( quest.allies ) == "table"
		and PartyQuests_QuestSettings.common.showDetailedTooltip ) then 
		
		local tooltip = "";
		local allies = "";
		local count = 2;

		tooltip = tooltip..PQ_WHOELSE;

		for k,ally in quest.allies do 
			if ( count == 2 ) then 
				tooltip = tooltip.."\n";
				count = 0;
			elseif ( count == 1 ) then
				tooltip = tooltip.."    ";
			end
			tooltip = tooltip..ally;
			count = count + 1;
		end

		-- Format it nicely
		if (quest.completeCount == 1) then
			tooltip = format(PQ_STNOCOMPLETED, tooltip, quest.completeCount);
		elseif (quest.completeCount == 0) then
			tooltip = format(PQ_STNOONECOMPLETED, tooltip);
		elseif (quest.completeCount == table.getn(quest.allies) ) then
			tooltip = format(PQ_STALLCOMPLETED, tooltip);
		elseif (type(quest.completeCount) == "number" ) then
			tooltip = format(PQ_STXCOMPLETED, tooltip, quest.completeCount);
		else
			return;
		end	
		
		return tooltip;
	end				
end

--[[ Store the collapsed zones ]]--
function PartyQuests_StoreCommonZoneCollapse (collapsed, value)
	if ( not value.zone ) then return; end
	if ( not PartyQuests_QuestSettings.common ) then
		PartyQuests_QuestSettings.common = {};
	end;
	if ( not PartyQuests_QuestSettings.common[value.zone] ) then 
		PartyQuests_QuestSettings.common[value.zone] = {};
	end
	PartyQuests_QuestSettings.common[value.zone].collapsed = collapsed;
end;

--[[ Store the collapsed zones ]]--
function PartyQuests_StorePlayerZoneCollapse (collapsed, zone)
	if ( not PartyQuests_QuestSettings.player ) then
		PartyQuests_QuestSettings.player = {};
	end;
	if ( not PartyQuests_QuestSettings.player[zone] ) then 
		PartyQuests_QuestSettings.player[zone] = {};
	end
	PartyQuests_QuestSettings.player[zone].collapsed = collapsed;
end;	

--[[ Set the Sort Method ]]--
function PartyQuests_ChooseSortMethod(method, mtype) 
	if ( type(method) == "string" ) then 
		PartyQuests_QuestSettings[mtype].sortMethod = method;
		PartyQuests_LastUpdateTime = GetTime();
	end
end

--[[ Set the Zone display ]]--
function PartyQuests_SetZoneDisplay(checked, mtype)
	PartyQuests_QuestSettings[mtype].zonesOn = checked;
end

--[[ Set the Complete banner display ]]--
function PartyQuests_SetCompletedBannerDisplay(checked, mtype)
	PartyQuests_QuestSettings[mtype].showCompletedBanner = checked;
end

--[[ Set the Detailed tooltip display ]]--
function PartyQuests_SetDetailedTooltipDisplay(checked, mtype)
	PartyQuests_QuestSettings[mtype].showDetailedTooltip = checked;
end

--[[ Set the Indent display ]]--
function PartyQuests_SetIndentDisplay(checked, mtype)
	PartyQuests_QuestSettings[mtype].indentOff = checked;
end


--[[ Set the Level display ]]--
function PartyQuests_SetLevelDisplay(checked, mtype)
	PartyQuests_QuestSettings[mtype].showLevel = checked;
end

--[[ Sort the Quest Tree ]]--
function PartyQuests_SortQuestTree(enhancedTree, mtype)
	-- Sort Off
	local sort = nil;

	-- Determine if the quests are flat
	if ( PartyQuests_QuestSettings[mtype].indentOff == true ) then
		for k,v in enhancedTree do
			for k2,v2 in v.children do 
				v2.noTextIndent = true;
			end
		end
	end
	
	-- Determine if Zones are On
	if ( not PartyQuests_QuestSettings[mtype].zonesOn ) then 

		-- Flatten the Tree
		local temp = {};
		for k,v in enhancedTree do
			for k2,v2 in v.children do 
				table.insert(temp,v2);
			end
		end

		-- Replace the old tree		
		enhancedTree = temp;
	end

	-- Sort by Zone
	local zoneSorter = function(a,b) return a.zone < b.zone; end;
	
	-- Sort by Quest
	local titleSorter = function(a,b) return a.questTitle < b.questTitle; end;

	-- Sort by Level
	local levelSorter = function(a,b) return a.level < b.level; end;

	-- Sort Zones by First Quest Name
	local childTitleSorter = function(a,b) 		
		if ( a.children and b.children ) then
			table.sort(a.children, function(a,b) return a.questTitle < b.questTitle end );
			table.sort(b.children, function(a,b) return a.questTitle < b.questTitle end );
			return a.children[1].questTitle < b.children[1].questTitle;
		end			
	end;
	
	-- Sort Zones By Quest Level
	local childLevelSorter = function(a,b)
		if ( a.children and b.children ) then
			table.sort(a.children, function(a,b) return a.level < b.level end );
			table.sort(b.children, function(a,b) return a.level < b.level end );
			return a.children[1].level < b.children[1].level;
		end		
	end;
	
	-- Choose the sort method
	if ( PartyQuests_QuestSettings[mtype].sortMethod ) then 
		if ( PartyQuests_QuestSettings[mtype].zonesOn ) then 
			if ( PartyQuests_QuestSettings[mtype].sortMethod == "level" ) then 
				sort = childLevelSorter; 
			elseif ( PartyQuests_QuestSettings[mtype].sortMethod == "title" ) then 
				sort = childTitleSorter;
			elseif ( PartyQuests_QuestSettings[mtype].sortMethod == "zone" ) then 
				sort = zoneSorter;
			end
		else
			if ( PartyQuests_QuestSettings[mtype].sortMethod == "level" ) then 
				sort = levelSorter; 
			elseif ( PartyQuests_QuestSettings[mtype].sortMethod == "title" ) then 
				sort = titleSorter;
			elseif ( PartyQuests_QuestSettings[mtype].sortMethod == "zone" ) then 
				sort = zoneSorter;
			end
		end
	end
	
	-- Check if we're sorting
	if ( sort ) then 
		-- Perform Sort
		table.sort(enhancedTree,sort);
	end

	-- Wrap it in an AllQuests tag
	if ( not PartyQuests_QuestSettings[mtype].zonesOn ) then 
		enhancedTree = {{title=PARTYQUESTS_ALLQUESTS;children=enhancedTree}};
	end

	return enhancedTree;
end

-- [[ Attempts to open a cached quest ]]--
function PartyQuests_OnPartyQuestClick(username, questTitle, questLevel) 
	local button = arg1;

	if ( button == "LeftButton" ) then
		if ( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert(this:GetText());
		else
		
			-- Set the active quest ID #
			PartyQuestsLogFrameQuestCount:SetText(username);
			PartyQuestsLogFrameCountMiddle:SetWidth(PartyQuestsLogFrameQuestCount:GetWidth());

			PartyQuests_CurrentQuest_SetFromCache (username, questTitle, questLevel);
			-- Show the current quest
			PartyQuests_ShowCurrentQuest();
		end
	elseif ( button == "RightButton" ) then 
		PartyQuests_OpenMenu("party");
	end
end

--[[ Attempts to open a Common Quest ]]--
function PartyQuests_OnCommonQuestClick(value)
	local id = nil;
	if ( type (value) == "table" ) then 
		id = value.id;
	end
	if ( id and id > GetNumQuestLogEntries() ) then
	else
		local button = arg1;
		if ( button == "LeftButton" ) then
			if ( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
				ChatFrameEditBox:Insert(this:GetText());
			elseif ( id ) then 
				local numEntries, numQuests = GetNumQuestLogEntries();
			
				-- Set the active quest ID #
				PartyQuestsLogFrameQuestCount:SetText(string.format(PARTYQUESTS_LOG_ID_TEMPLATE, id));
				PartyQuestsLogFrameCountMiddle:SetWidth(PartyQuestsLogFrameQuestCount:GetWidth());
		
				-- Update the log frame
				PartyQuests_CurrentQuest_SetFromID(id, true);

				-- Mark this as shared
				if ( PartyQuests_CurrentQuest ) then 
					PartyQuests_CurrentQuest.shared = true;
					PartyQuests_AddSharedStatusToCurrentQuest();
				end

				-- Show the current quest
				PartyQuests_ShowCurrentQuest();
			end
		elseif ( button == "RightButton" ) then 
			PartyQuests_OpenMenu("common");
		end
	end
end

-- Adds shared quest statuses to current quest 
function PartyQuests_AddSharedStatusToCurrentQuest ()
	-- Add the party statuses to the Common Quest log!
	if ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.quest ) then 
		for player,quests in PartyQuests_PartyQuests do 
			local questData = PartyQuests_GetQuestData(player, PartyQuests_CurrentQuest.quest.title, PartyQuests_CurrentQuest.quest.level ); 
			
			if ( questData and questData.status ) then 
				if ( not PartyQuests_CurrentQuest.quest.objectives ) then 
					PartyQuests_CurrentQuest.quest.objectives = {};
				end
				
				table.insert(PartyQuests_CurrentQuest.quest.objectives, {text="\n"..string.format(PQ_XOBJ,player)});
				for k,objective in questData.status do
					table.insert(PartyQuests_CurrentQuest.quest.objectives, objective);
				end
			elseif ( questData ) then
				-- Insert Dummy Data
				table.insert(PartyQuests_CurrentQuest.quest.objectives, {text="\n"..string.format(PQ_XOBJ,player)});
				table.insert(PartyQuests_CurrentQuest.quest.objectives, {text=PQ_REQUESTING});

				-- If they have this quest, ask them for their status
				if ( not PartyQuests_PartyQuests[player].waitingStatus ) then 
					PartyQuests_RequestQuestStatusFromPlayer(player, PartyQuests_CurrentQuest.quest.title, PartyQuests_CurrentQuest.quest.level );
					PartyQuests_StartWaiting(player);
					PartyQuests_CurrentQuest.waitingStatus = true;
				end
				Sea.io.dprint(PQ_DEBUG, "Requested status on ", PartyQuests_CurrentQuest.quest.title, " ", PartyQuests_CurrentQuest.quest.level, " from ", player, ".");
			end
		end
	end

	-- Start Refreshing
	PartyQuests_RefreshPartyGuiIfWaiting();	
end

-- Open the specified quest log
function PartyQuests_OnPlayerQuestClick(value) 
	local id = nil;
	if ( type (value) == "table" ) then 
		id = value.id;
	end
	if ( id and id > GetNumQuestLogEntries() ) then
	else
		local button = arg1;
		if ( button == "LeftButton" ) then
			if ( IsShiftKeyDown() and ChatFrameEditBox:IsVisible() ) then
				ChatFrameEditBox:Insert(this:GetText());
			elseif ( id ) then 
				local numEntries, numQuests = GetNumQuestLogEntries();
			
				-- Set the active quest ID #
				PartyQuestsLogFrameQuestCount:SetText(string.format(PARTYQUESTS_LOG_ID_TEMPLATE, id));
				PartyQuestsLogFrameCountMiddle:SetWidth(PartyQuestsLogFrameQuestCount:GetWidth());
		
				-- Update the log frame
				PartyQuests_CurrentQuest_SetFromID(id, true);

				-- Show the current quest
				PartyQuests_ShowCurrentQuest();
			end
		elseif ( button == "RightButton" ) then 
			PartyQuests_OpenMenu("player");
		end
	end
end

--[[ Get Quest Information ]]--
function PartyQuests_GetPlayerQuestInfo(questID)
	local myQuestRecord = {};
	local realRecord = Libram.requestRecord(questID);

	if ( not realRecord ) then 
		return;
	end
	-- Duplicate the record to prevent tampering. 
	for k,v in realRecord do 
		if ( type(v) ~= "table" ) then 
			myQuestRecord[k] = v;
		else
			myQuestRecord[k] = {};

			for k2,v2 in v do 
				myQuestRecord[k][k2] = v2;
			end
		end	
	end

	return myQuestRecord;
end

--[[ Finds a QuestID Matching Title and Level Specified ]]--
function PartyQuests_MatchQuestToPlayerQuestID(questTitle, questLevel ) 
	local id = nil;
	local log = PartyQuests_GetPlayerQuestTree();
	
	Sea.io.dprint(PQ_DEBUG, "Matching ", questTitle, " ", questLevel );
	for zone, questList in log do
		for k2, quest in questList do
			if ( type ( quest ) == "table" ) then 
			if ( quest.title == questTitle and quest.level == questLevel ) then 
				id = quest.id;
				break;
			end
			end
		end
	end

	return id;
end


--[[ Load a Single Quest Log From Cache ]]--
function PartyQuests_CurrentQuest_SetFromCache (username, questTitle, questLevel, shared)
	PartyQuests_InitializeUser(username);

	local ally = PartyQuests_PartyQuests[username];
	local quest = PartyQuests_GetCachedQuest(questTitle, questLevel);

	if ( not quest ) then 
		quest = {};
		PartyQuests_RequestQuestDetailsFromPlayer(username, questTitle, questLevel);
		PartyQuests_StartWaiting(username);
		Sea.io.dprint(PQ_DEBUG, "Requested details on ", questTitle, " ", questLevel, " from ", username, ".");
		quest.title = questTitle; 
		quest.level = questLevel; 
		quest.description = string.format(PARTYQUESTS_QUESTSTATUS_WAITING, username);

		-- Mark as waiting for a username
		quest.waitingDetails = true;
		quest.username = username;
	end
	
	if ( ally.quests ) then
		questData = PartyQuests_GetQuestData(username, questTitle, questLevel ); 

		if ( not questData or not questData.status ) then 

			-- Mark as waiting for a username
			quest.waitingStatus = true;
			quest.username = username;
			quest.title = questTitle; 
			quest.level = questLevel; 
			PartyQuests_RequestQuestStatusFromPlayer(username, questTitle, questLevel);
			Sea.io.dprint(PQ_DEBUG, "Requested status on ", questTitle, " ", questLevel, " from ", username, ".");
		else
			quest.objectives = questData.status;
		end
	elseif ( ally.waiting ) then
		Sea.io.dprint(PQ_DEBUG, "Ally is waiting or failed on ", questTitle, " ", questLevel, " from ", username, ".");

		if ( ally.waiting == PARTYQUESTS_WAITING ) then 
			-- Show Waiting message 
			quest.description = string.format(PARTYQUESTS_QUESTSTATUS_WAITING, username);
		elseif ( ally.waiting == PARTYQUESTS_FAILED ) then 
			-- Show Failed message
			quest.description = string.format(PARTYQUESTS_QUESTSTATUS_FAILED, username);
		end
	else
		-- If we have no quest log for that user (How did we get here??)
		-- Ask them for that log
		PartyQuests_StartWaiting(username);
		quest.title = string.format(PARTYQUESTS_QUESTSTATUS_WAITING, username);
		
		PartyQuests_RequestLogFromPlayer(username);	
	end

	-- Determine if we're going to load the quest or hide the frame
	if ( not  PartyQuests_CurrentQuest
		or not PartyQuests_CurrentQuest.quest
		or PartyQuests_CurrentQuest.quest.waitingDetails
		or PartyQuests_CurrentQuest.quest.waitingStatus
		or not ( PartyQuests_CurrentQuest.quest.title == quest.title)
		or not (getglobal("PartyQuestsLogFrame"):IsVisible()) ) then

		PartyQuests_CurrentQuest = {
			questType = "cache";
			quest = quest;
			visible = true;
		};
	else
		PartyQuests_CurrentQuest = nil;
	end

	if ( shared ) then 
		PartyQuests_AddSharedStatusToCurrentQuest ();
	end

	-- Start Refreshing
	PartyQuests_RefreshPartyGuiIfWaiting();
end

function PartyQuests_CurrentQuest_UpdateFromCache (username, questTitle, questLevel, shared)
	PartyQuests_InitializeUser(username);

	local ally = PartyQuests_PartyQuests[username];
	local quest = PartyQuests_GetCachedQuest(questTitle, questLevel);

	if ( quest ) then 
		PartyQuests_CurrentQuest.quest = quest;
		PartyQuests_CurrentQuest.visible = true;
		PartyQuests_CurrentQuest.waitingDetails = nil;
	end
	
	if ( ally.quests ) then
		questData = PartyQuests_GetQuestData(username, questTitle, questLevel ); 

		if ( not questData or not questData.status ) then 
			return;
		else
			PartyQuests_CurrentQuest.quest.objectives = questData.status;
			PartyQuests_CurrentQuest.visible = true;
			PartyQuests_CurrentQuest.quest.waitingStatus = nil;
			-- Add the prefix for that player
			table.insert(PartyQuests_CurrentQuest.quest.objectives, 1 , {text=string.format(PQ_XOBJ,username);finished=questData.complete});
		end
	end

	if ( shared ) then 
		PartyQuests_AddSharedStatusToCurrentQuest ();
	end
end

function PartyQuests_CurrentQuest_SetFromID ( id, toggle )
	local questInfo = PartyQuests_GetPlayerQuestInfo(id);

	if ( questInfo ) then 
		if ( toggle ) then 
			if ( not PartyQuests_CurrentQuest ) then 
				PartyQuests_CurrentQuest = {};
				PartyQuests_CurrentQuest.visible = true;
			elseif ( PartyQuests_CurrentQuest.quest ) then
				if ( questInfo.title == PartyQuests_CurrentQuest.quest.title and questInfo.level == PartyQuests_CurrentQuest.quest.level ) then 
					PartyQuests_CurrentQuest.visible = not PartyQuests_CurrentQuest.visible;
				end
			end

			PartyQuests_CurrentQuest.quest = questInfo;
		else
			if ( not PartyQuests_CurrentQuest ) then 
				PartyQuests_CurrentQuest = {};
			end
			PartyQuests_CurrentQuest.quest = questInfo;
			PartyQuests_CurrentQuest.visible = true;			
		end
	end
end

--[[ Creates a Menu ]]--
function PartyQuests_CreateMenu(mtype)
	
	local info = { };
	info[1] = { text = TEXT(CANCEL), func = function () end; };
	info[2] = { text = TEXT(PARTYQUESTS_MENU_REFRESH), func = PartyQuests_Refresh; };
	info[3] = { text = "|cFFCCCCCC------------|r", disabled = 1, notClickable = 1 };

	info[4] = { text = PartyQuests_SettingsString[mtype], isTitle = true};
	
	info[5] = { text = TEXT(PARTYQUESTS_MENU_SHOWZONES), keepShownOnClick = 1 };
	info[5].func = function (checked) PartyQuests_LastUpdateTime=GetTime(); PartyQuests_SetZoneDisplay(checked,mtype); PartyQuests_LoadGui(); end
	
	if ( PartyQuests_QuestSettings[mtype].zonesOn ) then 
		info[5].checked = true;
	else
		info[5].checked = false;
	end
	
	info[6] = { text = TEXT(PARTYQUESTS_MENU_SHOWLEVEL), keepShownOnClick = 1 };
	info[6].func = function (checked) PartyQuests_LastUpdateTime=GetTime(); PartyQuests_SetLevelDisplay(checked,mtype); PartyQuests_LoadGui(); end
	
	if ( PartyQuests_QuestSettings[mtype].showLevel ~= nil) then 
		info[6].checked = PartyQuests_QuestSettings[mtype].showLevel;
	else
		info[6].checked = true;
	end
	

	info[7] = { text = TEXT(PARTYQUESTS_MENU_SHOWINDENT), keepShownOnClick = 1 };
	info[7].func = function (checked) PartyQuests_LastUpdateTime=GetTime(); PartyQuests_SetIndentDisplay(checked,mtype); PartyQuests_LoadGui(); end
	
	if ( PartyQuests_QuestSettings[mtype].indentOff ~= nil) then 
		info[7].checked = PartyQuests_QuestSettings[mtype].indentOff;
	else
		info[7].checked = false;
	end

	info[8] = { text = TEXT(PARTYQUESTS_MENU_SHOWCOMPLETEDBANNER), keepShownOnClick = 1 };
	info[8].func = function (checked) PartyQuests_LastUpdateTime=GetTime(); PartyQuests_SetCompletedBannerDisplay(checked,mtype); PartyQuests_LoadGui(); end
	
	if ( PartyQuests_QuestSettings[mtype].showCompletedBanner ~= nil) then 
		info[8].checked = PartyQuests_QuestSettings[mtype].showCompletedBanner;
	else
		info[8].checked = true;
	end
	

	info[9] = { text = TEXT(PARTYQUESTS_MENU_SHOWDETAILEDTIP), keepShownOnClick = 1 };
	info[9].func = function (checked) PartyQuests_LastUpdateTime=GetTime(); PartyQuests_SetDetailedTooltipDisplay(checked,mtype); PartyQuests_LoadGui(); end
	
	if ( PartyQuests_QuestSettings[mtype].showDetailedTooltip ~= nil) then 
		info[9].checked = PartyQuests_QuestSettings[mtype].showDetailedTooltip;
	else
		info[9].checked = true;
	end
	

	-- Submenu 
	info[10] = { text = TEXT(PARTYQUESTS_SORTING), hasArrow = 1, value = 1};
	info[10][1] = { text = TEXT(PARTYQUESTS_SORTING), isTitle = 1 };
	info[10][2] = { text = TEXT(PARTYQUESTS_SORT_LEVEL), keepShownOnClick = false, func = function() PartyQuests_ChooseSortMethod("level", mtype); PartyQuests_LastUpdateTime=GetTime();PartyQuests_LoadGui(); end };
	info[10][3] = { text = TEXT(PARTYQUESTS_SORT_TITLE), keepShownOnClick = false, func = function() PartyQuests_ChooseSortMethod("title", mtype); PartyQuests_LastUpdateTime=GetTime();PartyQuests_LoadGui(); end };
	info[10][4] = { text = TEXT(PARTYQUESTS_SORT_ZONE), keepShownOnClick = false, func = function() PartyQuests_ChooseSortMethod("zone", mtype); PartyQuests_LastUpdateTime=GetTime();PartyQuests_LoadGui(); end };

	--[[
	if ( PartyQuestsFrame.sortMethod == "level" ) then 
		info[4].value = 2;
	elseif ( PartyQuestsFrame.sortMethod == "title" ) then 
		info[4].value = 3;
	elseif ( PartyQuestsFrame.sortMethod == "zone" ) then 
		info[4].value = 4;
	end
	]]
	
	return info;
end

--[[ Opens a Menu ]]--
--
function PartyQuests_OpenMenu(mtype)
	local menulist = PartyQuests_CreateMenu(mtype);
	EarthMenu_MenuOpen(menulist, this:GetName(), 0, 0, "MENU");
end


--[[ Process PartyMember Changes ]]--
function PartyQuests_ProcessPartyMembersChanged()
	PartyQuests_LastUpdateTime = GetTime();
	if ( Chronos.isScheduledByName("PartyQuestsNeedLogsCheck" ) ) then 
		return; 
	end
	PartyQuests_LoadGui ();
	Chronos.scheduleByName("PartyQuestsNeedLogsCheck", PARTYQUESTS_NEED_LOGS_DELAY, PartyQuests_RequestNeededLogs );
end

--[[ Process PartyLeader Changes ]]--
function PartyQuests_ProcessPartyLeaderChanged()
	PartyQuests_LastUpdateTime = GetTime();
	if ( Chronos.isScheduledByName("PartyQuestsNeedLogsCheck" ) ) then 
		return; 
	end
	PartyQuests_LoadGui ();
	Chronos.scheduleByName("PartyQuestsNeedLogsCheck", PARTYQUESTS_NEED_LOGS_DELAY, PartyQuests_RequestNeededLogs );
end

--[[ Process PartyMember Changes ]]--
function PartyQuests_Refresh()
	PartyQuests_PartyQuests = {};
	if ( Chronos.isScheduledByName("PartyQuestsNeedLogsCheck" ) ) then 
		return; 
	end
	PartyQuests_LoadGui ();
	Chronos.scheduleByName("PartyQuestsNeedLogsCheck", PARTYQUESTS_NEED_LOGS_DELAY, PartyQuests_RequestNeededLogs );
end

--[[ Periodically Update the Gui If Waiting ]]--
function PartyQuests_RefreshPartyGuiIfWaiting() 
	if ( Chronos.isScheduledByName("PartyQuestsWaitingUpdate" ) ) then 
		return; 
	end
	
	if ( PartyQuestsFrame.display and PartyQuestsFrame.display == "party" ) then 
		-- All this does right now is power the waiting spinner!
		PartyQuests_LoadGui ();
	end
	
	if ( PartyQuests_AmIWaiting() ) then 
		Chronos.scheduleByName("PartyQuestsWaitingUpdate", PARTYQUESTS_WAITING_UPDATE_DELAY, PartyQuests_RefreshPartyGuiIfWaiting );
	end
end

--[[ Check the mailbox every few seconds ]]--
function PartyQuests_PeriodicMailCheck()
	Sea.io.dprint(PQ_DEBUG, "PartyQuests is checking its mailbox.");
	PartyQuests_ReadMail();
	Chronos.scheduleByName("PartyQuestsMailCheck", PARTYQUESTS_MAILCHECK_INTERVAL, PartyQuests_PeriodicMailCheck ); 
end


--[[ Detects if you're waiting for anyone ]]--
function PartyQuests_AmIWaiting()
	local waiting = false;
	for username,memberData in PartyQuests_PartyQuests do
		if ( memberData.waiting and memberData.waiting == PARTYQUESTS_WAITING ) then 
			waiting = true;
		end
	end

	return waiting;
end

--[[ Start Waiting ]]--
function PartyQuests_StartWaiting(username)
	PartyQuests_PartyQuests[username].waiting = PARTYQUESTS_WAITING;

	if ( Chronos.isScheduledByName( "PartyQuestsWaitingOn"..username ) ) then 
		return; 
	end
	
	-- Register a failure timer
	Chronos.scheduleByName(
		"PartyQuestsWaitingOn"..username, 
		PARTYQUESTS_WAITING_FAILURE_DELAY,
		function() 
			if ( PartyQuests_PartyQuests[username] and
				PartyQuests_PartyQuests[username].waiting and
				PartyQuests_PartyQuests[username].waiting == PARTYQUESTS_WAITING ) then 
				PartyQuests_PartyQuests[username].waiting = PARTYQUESTS_FAILED;
			end
		end
		);
end

--[[ Mark as a no-sky player ]]--
function PartyQuests_MarkSky(username, state)
	PartyQuests_PartyQuests[username].noSky = state;
	
	-- Register a failure timer
	Chronos.scheduleByName(
		"PartyQuestsSkyCheckOn"..username, 
		PARTYQUESTS_WAITING_FAILURE_DELAY,
		function() 
			if ( PartyQuests_PartyQuests[username].noSky ) then
				if ( Sky.isSkyUser("username") ) then 
					PartyQuests_PartyQuests[username].noSky = nil;
				end
			end
		end
		);
end

--[[
--	Configuration Stuff
--
--
--]]
function PartyQuests_RegisterWithEarth()
	if ( Cosmos_RegisterButton ) then 
	Cosmos_RegisterButton (
		PARTYQUESTS_COLOR,
		PARTYQUESTS_BUTTON_SUBTEXT,
		PARTYQUESTS_BUTTON_TOOTIP,
		"Interface\\Icons\\INV_Misc_Book_04", 
		TogglePartyQuests
		);
	end
end
--[[
--
--	Communications Stuff
--
--
--
--]]
function PartyQuests_RegisterWithSky()
	-- Register a test program
	Sky.registerMailbox(
		{
			id="PartyQuests";
			events = { SKY_RAID, SKY_PARTY, SKY_PLAYER };
			acceptTest = PartyQuests_AcceptSkyMessage;
			weight = 5;
		}
	);	
end

--[[ Accept Sky Messages ]]--
function PartyQuests_AcceptSkyMessage(e)
	if ( type (e.msg) == "table" ) then
		if ( e.msg.partyQuests ) then 
			return true;
		end
	end
	return false; 
end

--[[ Scan the mailbox ]]--
function PartyQuests_ReadMail()
	local recordCount = 0;
	local allMail = Sky.getAllMessages("PartyQuests"); 

	for k,envelope in allMail do 
		local data = envelope.msg;
		local username = envelope.sender;

		if ( type(data) == "table" ) then 
			-- Its really a partyQuests packet
			if ( data.partyQuests ) then 
				-- Announce the existence of an update
				PartyQuests_LastUpdateTime = GetTime();

				if not ( username == UnitName("player") ) then 				
					if ( string.find(data.action, PARTYQUESTS_ANNOUNCE ) == 1 ) then 
						PartyQuests_RecordData ( data, username, envelope.time ); 
						PartyQuests_ReportAnnouncement ( data, username, envelope.time ); 
						recordCount = recordCount + 1;
					elseif ( string.find(data.action, PARTYQUESTS_RECORD ) == 1 ) then 
						recordCount = recordCount + 1;
						PartyQuests_RecordData ( data, username, envelope.time ); 
					elseif ( string.find(data.action, PARTYQUESTS_REQUEST ) == 1 ) then 
						PartyQuests_HandleRequest ( data, username, envelope.time ); 
					elseif ( string.find(data.action, PARTYQUESTS_NACK ) == 1 ) then 
						recordCount = recordCount + 1;
						PartyQuests_StopWaiting ( data, username, envelope.time );
					end
				end
			end
		end
	end
	
	local count = 0;
	for k,v in PartyQuests_WhoNeedsMyLog do
		count = count + 1;
	end
	if ( count < 3 ) then 
		for k,v in PartyQuests_WhoNeedsMyLog do
			PartyQuests_SendQuestLogToPlayer(k);
			PartyQuests_WhoNeedsMyLog[k] = nil;
		end
	else
		if ( GetTime() - PartyQuests_Cooldown > PARTYQUESTS_LOG_SEND_COOLDOWN ) then 
			PartyQuests_SendQuestLogToParty();
			PartyQuests_Cooldown = GetTime();
		end
	end

	if ( recordCount > 0 ) then 
		PartyQuests_LoadGui();
	end
end

--[[ Report Announcements ]]-- 
function PartyQuests_ReportAnnouncement(data, username, time)
	if ( (GetTime() - time) > PARTYQUESTS_BLOCK_UPDATES_OLDER_THAN ) then
		return;
	end

	-- Announce Status Updates
	if ( data.action == PARTYQUESTS_ANNOUNCE_PROGRESS ) then 
		Sea.io.bannerc( PQ_BANNER_UPDATE_COLOR, string.format(PQ_QPROGRESS, username, data.info) ); 

		-- Erase status
		local qData = PartyQuests_GetQuestData(username, data.questTitle, data.questLevel ); 
		if ( qData ) then 
			qData.status = nil;
		end
	-- Announce Completions
	elseif ( data.action == PARTYQUESTS_ANNOUNCE_COMPLETE ) then 
		if ( data.questTitle and data.questLevel ) then
			if ( PartyQuests_QuestSettings.party.showCompletedBanner ) then 
				Sea.io.bannerc( PQ_BANNER_COMPLETE_COLOR, 
					string.format( PQ_XHASCOMPLETED, username, data.questTitle )
					);
				Sea.io.bannerc( PQ_BANNER_COMPLETE_COLOR, 
					string.format( PQ_QUEST_LEVEL, data.questLevel )
					);
			end
			-- Check for completed
			local total = 0;
			local completed = 0;
			for player,v in PartyQuests_PartyQuests do 
				local data = PartyQuests_GetQuestData(player, data.questTitle, data.questLevel );

				if ( data ) then 
					total = total + 1;
					if ( data.complete ) then
						completed = completed + 1; 
					end
				end
			end

			--Sea.io.printComma(total, completed);
			-- If everyone is done, announce it
			if ( total == completed and completed > 0 ) then 
				Sea.io.bannerc( PQ_BANNER_COMPLETE_COLOR, string.format(PQ_PARTYCOMPLETED, data.questTitle) );					
			end
		elseif ( data.objective ) then 
			Sea.io.bannerc( PQ_BANNER_COMPLETE_COLOR, string.format ( PQ_OBJCOMPLETED, username, data.objectiveName ) );			
		end
	end
end

--[[ Record Data ]]--
function PartyQuests_RecordData(data, username, time)
	Sea.io.dprint(PQ_DEBUG, "Recording data from ", username, " at ", time);
	if ( string.find(data.action, PARTYQUESTS_ANNOUNCE) == 1 ) then 
		if ( data.action == PARTYQUESTS_ANNOUNCE_COMPLETE ) then 
			if ( data.questTitle and data.questLevel ) then 
				local questData = PartyQuests_GetQuestData(username, data.questTitle, data.questLevel ); 
				if ( questData ) then 
					questData.complete = true;
				end
			end
				
		end
	elseif ( string.find(data.action, PARTYQUESTS_RECORD) == 1 ) then 
		if ( data.action == PARTYQUESTS_RECORD_LOG ) then
			if ( data.log ) then 
				PartyQuests_RecordQuestLog (username, data.log, time);
			end
		elseif ( data.action == PARTYQUESTS_RECORD_DETAILS ) then 
			if ( data.questTitle and data.questLevel ) then 
				if ( data.details ) then 
					PartyQuests_RecordQuestDetails (username, data.questTitle, data.questLevel, data.details);
				end			
			end
		elseif ( data.action == PARTYQUESTS_RECORD_ADD ) then 
			if ( data.quest and data.zone ) then 
				PartyQuests_RecordQuestAddition (username, data.zone, data.quest);
			end
		elseif ( data.action == PARTYQUESTS_RECORD_DELETE ) then 
			if ( data.questTitle and data.questLevel ) then 
				PartyQuests_RecordQuestDeletion (username, data.questTitle, data.questLevel);
			end
		elseif ( data.action == PARTYQUESTS_RECORD_STATUS ) then 
			if ( data.questTitle and data.questLevel and data.status ) then 
				PartyQuests_RecordQuestStatus (username, data.questTitle, data.questLevel, data.status);
			end			
		end
	end
end

--[[ Handle Request ]]--
function PartyQuests_HandleRequest(data, username, time)
	if ( data.action == PARTYQUESTS_REQUEST_NEEDALL ) then 
		PartyQuests_WhoNeedsMyLog[username] = true;
	elseif ( data.action == PARTYQUESTS_REQUEST_NEED ) then 
		if ( Sea.list.isInList(data.need, UnitName("player") ) ) then
			PartyQuests_WhoNeedsMyLog[username] = true;
		end
	elseif ( data.action == PARTYQUESTS_REQUEST_STATUS ) then 
		if ( data.questTitle and data.questLevel ) then 
			PartyQuests_SendQuestStatusToPlayer(username, data.questTitle, data.questLevel );
		end
	elseif ( data.action == PARTYQUESTS_REQUEST_DETAILS ) then 
		if ( data.questTitle and data.questLevel ) then 
			PartyQuests_SendQuestDetailsToPlayer(username, data.questTitle, data.questLevel );
		end
	end			
end

--[[ Stop Waiting for Data ]]--
function PartyQuests_StopWaiting(data, username, time)
	if ( not PartyQuests_PartyQuests[username] ) then
		PartyQuests_PartyQuests[username] = {};
	end
	PartyQuests_PartyQuests[username].waiting = PARTYQUESTS_FAILED;

	
	-- If we got naked, kill the quest
	if ( data.details == PARTYQUESTS_NOSUCHQUEST or data.status == PARTYQUESTS_NOSUCHQUEST ) then 
		local data = PartyQuests_GetQuestData(username, data.questTitle, data.questLevel );
		if ( data ) then 
			local zoneQuests = PartyQuests_PartyQuests[username].quests[data.zone];

			if ( zoneQuests ) then 
				for k,v in zoneQuests do
					if ( v.title == data.questTitle and v.level == data.questLevel ) then 
						zoneQuests[k] = nil;
					end
				end
			end
		end
	end

	Sea.io.dprint(PQ_DEBUG, "Nack: User ", username, " does not have ", data.questTitle, " lvl ", data.questLevel );
end


--[[ Request Needed Logs ]]--
function PartyQuests_RequestNeededLogs()
	local numParty = GetNumPartyMembers();	
	local needed = {};
		
	if ( not Sky.isChannelActive(SKY_PARTY) ) then 
		if ( not PartyQuests_JoinPartyAlert ) then 
			Sea.io.print(PARTYQUESTS_NEED_TO_JOIN_SKY_PARTY); 
			PartyQuests_JoinPartyAlert = true;
		end
		return;
	end
	
	-- Debug only
	numParty = numParty ;

	for i=1,numParty do 
		local username = UnitName("player");
		if ( i <= GetNumPartyMembers() ) then 
			username = UnitName("party"..i);
		end
		PartyQuests_InitializeUser(username);				

		if ((GetTime() - PartyQuests_PartyQuests[username].time > PARTYQUESTS_LOG_EXPIRATION  ) ) then 	
			-- Scan if they're in the party channel or not
			local channelList = Sky.isSkyUser(username);
			if ( channelList and Sea.list.isInList( channelList, SKY_PARTY )  ) then
				PartyQuests_MarkSky(username, true);
				if ( not PartyQuests_PartyQuests[username].waiting or PartyQuests_PartyQuests[username].waiting == PARTYQUESTS_FAILED ) then 
					PartyQuests_StartWaiting(username);
					table.insert(needed, username);
				end
			else
				PartyQuests_MarkSky(username, false);
			end
		end
	end

	-- Request those logs
	if ( table.getn(needed) > 3 ) then 
		data = {};
		data.partyQuests = true;
		data.action = PARTYQUESTS_REQUEST_NEEDALL;

		-- Broadcast it
		Sky.sendTable( data, SKY_PARTY, "PartyQuests" );

		-- Start Refreshing
		PartyQuests_RefreshPartyGuiIfWaiting();
	elseif ( table.getn(needed) > 0 ) then 
		data = {};
		data.partyQuests = true;
		data.action = PARTYQUESTS_REQUEST_NEED;
		data.need = needed;

		-- Broadcast it
		Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
		
		-- Start Refreshing
		PartyQuests_RefreshPartyGuiIfWaiting();
	end
end

--[[ Request a single player's quest log ]]--
function PartyQuests_RequestLogFromPlayer(player)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_REQUEST_NEED;
	data.need = {player};
	
	-- Whisper it
	Sky.sendTable( data, SKY_PLAYER, "PartyQuests", player );
end

--[[ Request Quest Details from a Player ]]--
function PartyQuests_RequestQuestDetailsFromPlayer(player, questTitle, questLevel)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_REQUEST_DETAILS;
	data.questTitle = questTitle;
	data.questLevel = questLevel;

	-- Whisper it
	Sky.sendTable( data, SKY_PLAYER, "PartyQuests", player );
end

--[[ Request Quest Status From a Player ]]--
function PartyQuests_RequestQuestStatusFromPlayer(player, questTitle, questLevel)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_REQUEST_STATUS;
	data.questTitle = questTitle;
	data.questLevel = questLevel;

	-- Whisper it
	Sky.sendTable( data, SKY_PLAYER, "PartyQuests", player );	
end

--[[
--
--	Communications Database Tools
--
--
--
--
--]]

--[[ Initializes a user if needed, otherwise does nothing ]]--
function PartyQuests_InitializeUser(username)
	if ( not PartyQuests_PartyQuests ) then 
		PartyQuests_PartyQuests = {};
	end
	if ( not PartyQuests_PartyQuests[username] ) then 
		PartyQuests_PartyQuests[username]  = {};
		PartyQuests_PartyQuests[username].time = 0;				
	end
end

--[[ Get a quest table ]]--
function PartyQuests_GetQuestData(username, questTitle, level ) 
	PartyQuests_InitializeUser(username);

	if ( not PartyQuests_PartyQuests[username].quests ) then 
		PartyQuests_PartyQuests[username].quests = {};
	end

	for zone,questList in PartyQuests_PartyQuests[username].quests do
		-- Check, it might be collapsed, not a zone
		if ( type ( questList ) == "table" ) then 
			for i=1,table.getn(questList) do 
				quest = questList[i];
				if ( type (quest) == "table" ) then 
					if ( quest.title == questTitle and quest.level == level ) then 
						return quest;
					end
				end
			end
		end
	end

	return nil;
end

--[[ Get a cached quest ]]--
function PartyQuests_GetCachedQuest(quest, level )
	if ( PartyQuests_PartyQuestsCache[quest] ) then 
		return PartyQuests_PartyQuestsCache[quest][level];
	end
	return nil;
end

--[[ Store a quest log ]]--
function PartyQuests_RecordQuestLog (username, questLog, time ) 
	PartyQuests_InitializeUser(username);

	if ( questLog ) then 
		PartyQuests_PartyQuests[username].quests = questLog;
		PartyQuests_PartyQuests[username].time = time;
		PartyQuests_PartyQuests[username].waiting = nil;
	end
	
	Sea.io.derror(PQ_DEBUG, "Recorded log for ", username);
end

--[[ Store a quest data cache ]]--
function PartyQuests_RecordQuestDetails (username, questTitle, questLevel, details)
	if ( not PartyQuests_PartyQuestsCache[questTitle] ) then 
		PartyQuests_PartyQuestsCache[questTitle] = {};
	end
	if ( not PartyQuests_PartyQuestsCache[questTitle][questLevel] ) then 
		PartyQuests_PartyQuestsCache[questTitle][questLevel] = {};
	end
	
	if ( details.objectives ) then 
		PartyQuests_RecordQuestStatus (username, questTitle, questLevel, details.objectives );
		details.objectives = nil;
	end
	
	-- Records the details
	PartyQuests_PartyQuestsCache[questTitle][questLevel] = details;
	PartyQuests_PartyQuestsCache[questTitle][questLevel].username = username;

	Sea.io.dprint(PQ_DEBUG, "Recorded Quest Details for ", questTitle, " (",questLevel,") from ", username);
end


--[[ Store a quest data cache ]]--
function PartyQuests_RecordQuestAddition (username, questZone, quest)
	-- Erase the quest from their record
	PartyQuests_InitializeUser(username);

	if ( not PartyQuests_PartyQuests[username]["quests"] ) then 
		PartyQuests_PartyQuests[username]["quests"] = {};
	end

	if ( not PartyQuests_PartyQuests[username]["quests"][questZone] ) then 
		PartyQuests_PartyQuests[username]["quests"][questZone] = {};
	end

	table.insert(PartyQuests_PartyQuests[username]["quests"][questZone], quest);

	Sea.io.dprint(PQ_DEBUG, "Recorded Quest Addition for ", quest.title, " (",quest.level,") from ", username);
end

--[[ Delete a quest record ]]--
function PartyQuests_RecordQuestDeletion (username, questTitle, questLevel ) 
	-- Wipe out any details sent by that person
	if ( not PartyQuests_PartyQuestsCache ) then 
		PartyQuests_PartyQuestsCache = {};
	end
	if ( not PartyQuests_PartyQuestsCache[questTitle] ) then 
		PartyQuests_PartyQuestsCache[questTitle] = {};
	end
	if ( PartyQuests_PartyQuestsCache[questTitle][questLevel] ) then 
		if ( PartyQuests_PartyQuestsCache[questTitle][questLevel].username == username ) then 
			PartyQuests_PartyQuestsCache[questTitle][questLevel] = nil;
		end
		if ( table.getn(PartyQuests_PartyQuestsCache[questTitle]) == 0 ) then 
			PartyQuests_PartyQuestsCache[questTitle] = nil;
		end
	end

	-- Erase the quest from their record
	PartyQuests_InitializeUser(username);

	if ( not PartyQuests_PartyQuests[username]["quests"] ) then 
		PartyQuests_PartyQuests[username]["quests"] = {};
	end

	-- Wipe out the quest entry
	for zone,questList in PartyQuests_PartyQuests[username].quests do
		for i=1,table.getn(questList) do 
			if ( type (questList[i]) == "table" ) then 
				if ( questList[i].title == questTitle and questList[i].level == questLevel ) then 
					questList[i] = nil;
				end
			end
		end
	end

	Sea.io.dprint(PQ_DEBUG, "Deleted Quest for ", questTitle, " (",questLevel,") from ", username);
end

--[[ Record Quest Status ]]--
function PartyQuests_RecordQuestStatus (username, questTitle, questLevel, status ) 
	PartyQuests_InitializeUser(username);

	if ( not PartyQuests_PartyQuests[username].quests ) then 
		PartyQuests_PartyQuests[username].quests = {};
	end

	local recorded = false;

	-- Scan their quests
	for zone,questList in PartyQuests_PartyQuests[username].quests do
		if ( type ( questList ) == "table" ) then 
			for i=1,table.getn(questList) do 
				quest = questList[i];
				if ( type (quest) == "table" ) then 
					if ( quest.title == questTitle and quest.level == questLevel ) then 
						questList[i].status = status;
						recorded = true;
						break;
					end
				end
			end
		end
	end
	
	-- Clear the waiting flag
	PartyQuests_PartyQuests[username].waiting = nil;
	
	Sea.io.dprint(PQ_DEBUG, "Recorded Quest Status for ", questTitle, " (",questLevel,") from ", username, " ? ", recorded);
end

--
-- Outgoing
-- 

--[[ Send an update on all objectives for that quest ]]--
function PartyQuests_SendQuestStatusToPlayer(username, questTitle, questLevel )
	local id = PartyQuests_MatchQuestToPlayerQuestID(questTitle, questLevel );
	local details = PartyQuests_GetPlayerQuestInfo(id);

	local data = {};
	data.partyQuests = true;
	
	-- If such a quest exists, send only objectives
	if ( details ) then 
		data.action = PARTYQUESTS_RECORD_STATUS;
		data.questTitle = details.title;
		data.questLevel = details.level;
		data.status = details.objectives; 
	else
		data.action = PARTYQUESTS_NACK_STATUS;
		data.questTitle = questTitle;
		data.questLevel = questLevel; 
		data.status = PARTYQUESTS_NOSUCHQUEST;
	end
	
	-- Queue it up
	Sky.sendTable( data, SKY_PLAYER, "PartyQuests", username );
end

--[[ Send an update on all objectives for that quest ]]--
function PartyQuests_SendQuestStatusToParty(questTitle, questLevel )
	local id = PartyQuests_MatchQuestToPlayerQuestID(questTitle, questLevel );
	local details = PartyQuests_GetPlayerQuestInfo(id);

	local data = {};
	data.partyQuests = true;
	
	-- If such a quest exists, send only objectives
	if ( details ) then 
		data.action = PARTYQUESTS_RECORD_STATUS;
		data.questTitle = details.title;
		data.questLevel = details.level;
		data.status = details.objectives; 
	else
		data.action = PARTYQUESTS_NACK_STATUS;
		data.questTitle = questTitle;
		data.questLevel = questLevel; 
		data.status = PARTYQUESTS_NOSUCHQUEST;
	end
	
	-- Queue it up
	Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
end



--[[ Send a full list of the details required to display that quest ]]-- 
function PartyQuests_SendQuestDetailsToPlayer(username, questTitle, questLevel )
	local id = PartyQuests_MatchQuestToPlayerQuestID(questTitle, questLevel );
	local details = PartyQuests_GetPlayerQuestInfo(id);
	
	local data = {};
	data.partyQuests = true;
	
	-- If such a quest exists, send only objectives
	if ( details ) then 
		data.action = PARTYQUESTS_RECORD_DETAILS;
		data.questTitle = details.title;
		data.questLevel = details.level;
		data.details = details; 
	else
		data.action = PARTYQUESTS_NACK_DETAILS;
		data.questTitle = questTitle;
		data.questLevel = questLevel; 
		data.details = PARTYQUESTS_NOSUCHQUEST;
	end
	
	
	-- Queue it up
	Sky.sendTable( data, SKY_PLAYER, "PartyQuests", username );	
end

--[[ Send a full quest log to the specified player ]]--
function PartyQuests_SendQuestLogToPlayer(username)
	local log = PartyQuests_GetPlayerQuestTree();

	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_RECORD_LOG;
	data.log = log;

	-- Whisper it
	Sky.sendTable( data, SKY_PLAYER, "PartyQuests", username );
end


--[[ Send a full quest log to the party ]]--
function PartyQuests_SendQuestLogToParty()
	local log = PartyQuests_GetPlayerQuestTree();

	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_RECORD_LOG;
	data.log = log;

	-- Broadcast it
	Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
end

--[[ Send Quest Progress Updates ]]--
function PartyQuests_SendQuestProgressUpdateToParty(updateText)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_ANNOUNCE_PROGRESS;
	data.info = updateText;

	-- Broadcast it
	Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
end

--[[ Send Quest Completion Notice ]]-- 
function PartyQuests_SendQuestCompleteUpdateToParty(questTitle, questLevel)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_ANNOUNCE_COMPLETE;
	data.questTitle = questTitle;
	data.questLevel = questLevel;

	-- Broadcast it
	Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
end

--[[ Send Quest Deletion Notice ]]-- 
function PartyQuests_SendQuestDeletionUpdateToParty(questTitle, questLevel)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_RECORD_DELETE;
	data.questTitle = questTitle;
	data.questLevel = questLevel;

	-- Broadcast it
	Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
end

--[[ Send Quest Deletion Notice ]]-- 
function PartyQuests_SendQuestAdditionUpdateToParty(zone, quest)
	local data = {};
	data.partyQuests = true;
	data.action = PARTYQUESTS_RECORD_ADD;
	data.quest = quest;
	data.zone = zone;

	-- Broadcast it
	Sky.sendTable( data, SKY_PARTY, "PartyQuests" );
end

--
--
--	Gui Updating Functions Here
--
--
--

function PartyQuests_SetQuestCount()
	-- Set the total quests
	local numEntries, numQuests = GetNumQuestLogEntries();
	PartyQuestsFrameQuestCount:SetText(string.format(QUEST_LOG_COUNT_TEMPLATE, numQuests, MAX_QUESTLOG_QUESTS));
	PartyQuestsFrameCountMiddle:SetWidth(PartyQuestsFrameQuestCount:GetWidth());
end

function PartyQuests_ShowCurrentQuest()
	if ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.visible ) then 
		if ( PartyQuests_CurrentQuest.quest) then 
			if ( not PartyQuests_CurrentQuest.quest.id ) then 
				PartyQuestsLogFrameAbandonButton:Disable();
			else
				PartyQuestsLogFrameAbandonButton:Enable();
			end
			
			Sea.io.dprint(PQ_DEBUG, "Reloading Quest...");

			-- Load the quest and update
			EarthQuestLog_LoadQuest("PartyQuestsLog", PartyQuests_CurrentQuest.quest);
			EarthQuestLog_Update("PartyQuestsLog");
			-- Show the other frame
			ShowUIPanel(getglobal("PartyQuestsLogFrame"));
		else
			EarthQuestLog_Clear("PartyQuestsLog");
		end
	else
		EarthQuestLog_Clear("PartyQuestsLog");
		HideUIPanel(getglobal("PartyQuestsLogFrame"));
	end
end

function PartyQuests_ScholarCall ( action, questInfo, updateInfo ) 
	--Sea.io.error(action);

	local updateTree = false;
	
	if ( action == LIBRAM_QUEST_INIT ) then 
		updateTree = true;
	elseif ( action == LIBRAM_QUEST_COMPLETED ) then
		PartyQuests_SendQuestCompleteUpdateToParty(questInfo.title, questInfo.level);
		
		-- Show "You have completed Quest Of Doom" messages
		if ( PartyQuests_QuestSettings.player.showCompletedBanner ) then 
			Sea.io.bannerc( PQ_BANNER_COMPLETE_COLOR, 
				string.format( PQ_YOUHAVECOMPLETED,  questInfo.title )
				);
			Sea.io.bannerc( PQ_BANNER_COMPLETE_COLOR, 
				string.format( PQ_QUEST_LEVEL, questInfo.level )
				);
		end
		
		updateTree = true;		
	elseif ( action == LIBRAM_QUEST_ADD ) then 
		PartyQuests_SendQuestAdditionUpdateToParty(updateInfo.zone, questInfo);

		updateTree = true;		
	elseif ( action == LIBRAM_QUEST_REMOVE ) then 
		PartyQuests_SendQuestDeletionUpdateToParty(questInfo.title, questInfo.level);
		if ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.quest) then 
			if ( PartyQuests_CurrentQuest.quest.id == questInfo.id ) then 
				PartyQuests_CurrentQuest.quest = nil;
				updateCurrentQuest = true;
			end
		end
		
		updateTree = true;
	elseif ( action == LIBRAM_QUEST_UPDATE ) then 
		PartyQuests_SendQuestStatusToParty(questInfo.title, questInfo.level );

		if ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.quest) then
			if ( PartyQuests_CurrentQuest.quest.id == questInfo.id ) then 
				PartyQuests_CurrentQuest.quest = questInfo;
				updateCurrentQuest = true;
			end
		end
	elseif ( action == LIBRAM_QUEST_TIMER ) then 
		updateCurrentQuest = true;
	elseif ( action == LIBRAM_QUEST_CHANGED ) then 
		if ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.quest) then 
			if ( PartyQuests_CurrentQuest.quest.id == updateInfo.oldid ) then 
				PartyQuests_CurrentQuest.quest.id = updateInfo.newid;
			end
		end
		updateTree = true;		
	end

	if ( updateTree ) then
		if ( not Chronos.isScheduledByName("PartyQuestScholarQuestLogRefresh") ) then
			Chronos.scheduleByName(
				"PartyQuestScholarQuestLogRefresh", 
				PARTYQUESTS_GUI_REFRESH_DELAY, 
				PartyQuests_ShowQuestLog
			);
		end
	end
	if ( updateCurrentQuest ) then 
		if ( not Chronos.isScheduledByName("PartyQuestScholarQuestRefresh") ) then
			Chronos.scheduleByName(
				"PartyQuestScholarQuestRefresh", 
				PARTYQUESTS_GUI_REFRESH_DELAY, 
				PartyQuests_ShowCurrentQuest
			);
		end
	end
end

--[[ Calls when the hostess informs of channel events ]]--
function PartyQuests_HostessCall( action, actionData )
	if ( action == SKY_PLAYER_JOIN ) then 
	elseif ( action == SKY_PLAYER_LEAVE ) then 
	elseif ( action == SKY_CHANNEL_JOIN ) then 
	elseif ( action == SKY_CHANNEL_LEFT ) then 
	elseif ( action == SKY_CHANNEL_LIST ) then 
	end
end

--[[ Update the gui's tree ]]--
function PartyQuests_UpdateQuestLog(display)
	if ( display == "self" ) then
			local tree = PartyQuests_GetPlayerQuestTree();		
			local eTree = PartyQuests_ConvertPlayerQuestTreeToEnhancedTree(tree);
			
			Sea.io.dprint(PQ_DEBUG, "Loading self data... ");
		
			-- Update the live tree
			if ( eTree.children ) then 
				EarthTree_LoadEnhanced(PartyQuestsFrameTree, eTree.children);
			else
				EarthTree_LoadEnhanced(PartyQuestsFrameTree, {});
			end
	elseif ( display == "party" ) then 
			local ctree = nil; 
			local ecTree = nil;
			local fullTree = {};

			-- Add Common
			ctree = PartyQuests_GetCommonQuestsTree();		
			ecTree = PartyQuests_ConvertCommonQuestTreeToEnhancedTree(ctree);
		
			table.insert(fullTree, ecTree );

			-- Add Player
			local ptree = PartyQuests_GetPlayerQuestTree();		
			local epTree = PartyQuests_ConvertPlayerQuestTreeToEnhancedTree(ptree);
		
			table.insert(fullTree, epTree );

		
			Sea.io.dprint(PQ_DEBUG, "Loading party data...");
			
			-- Get all party member quests
			tree = PartyQuests_GetPartyQuestTree();	
			if ( not tree ) then
			
			else	
				-- Make eTrees for everyone
				for k,partyMember in tree do
					if ( type (partyMember) == "table" ) then 
						local eat = PartyQuests_ConvertAllyQuestTreeToEnhancedTree( k, partyMember );
						if ( eat ) then 
							table.insert(fullTree, eat);
						end
					end
				end
			end

			-- Update the live tree
			EarthTree_LoadEnhanced(PartyQuestsFrameTree, fullTree);
	end
end

--[[ Shows the Quest Log ]]--
function PartyQuests_ShowQuestLog()
	PartyQuests_SetQuestCount();
	PartyQuests_UpdateQuestLog(PartyQuestsFrame.display);
	EarthTree_UpdateFrame(PartyQuestsFrameTree);
end


--[[ Refreshes the Gui ]]--
function PartyQuests_LoadGui ()
	PartyQuests_ShowQuestLog();
end

--[[ Refreshes the Gui ]]--
function PartyQuests_OldLoadGui ()
	local frame = PartyQuestsFrame;		
	local eTree = nil;

	if ( true ) then 
		return;
	end
	
	-- Make sure we're not updating during a load
	if ( not Sea.wow.questLog.protectQuestLog() ) then 
		return; 
	else
		-- All clear, continue
		Sea.wow.questLog.unprotectQuestLog();
	end

	
	-- Update the Gui's tree
	PartyQuests_UpdateQuestLog(PartyQuestsFrame.display);
	
	-- Draw the data
	EarthTree_UpdateFrame(
		getglobal(frame:GetName().."Tree")
		); 

	-- If its an ID'd quest, check if the quest was changed or abandoned
	if ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.id ) then
		PartyQuests_CurrentQuest_SetFromID ( PartyQuests_CurrentQuest.id );
	-- If its a cached quest, check if its been updated
	elseif ( PartyQuests_CurrentQuest and PartyQuests_CurrentQuest.quest ) then
		if ( PartyQuests_CurrentQuest.quest.waitingDetails or
			PartyQuests_CurrentQuest.quest.waitingStatus ) then 
			

			Sea.io.dprint(PQ_DEBUG, "Current quest is being updated from cache...");

			-- Updates from the cache if the data is available
			PartyQuests_CurrentQuest_UpdateFromCache(
				PartyQuests_CurrentQuest.quest.username, 
				PartyQuests_CurrentQuest.quest.title, 
				PartyQuests_CurrentQuest.quest.level,
				PartyQuests_CurrentQuest.shared
				);
		end
	end

	-- Show the current quest
	PartyQuests_ShowCurrentQuest();
end



























--[[
--
--	XML Event Handlers Below this point
--
--	Do Not Enter!
--
--]]

--[[ Initialize ]]--
function PartyQuests_Frame_Initialize()
	PartyQuestsFrame.hasInit = true;

	local ebf = getglobal("PartyQuestsFrame".."Tree".."Expand");
	ebf:SetPoint("TOPLEFT", ebf:GetParent():GetName(), "TOPLEFT", 50, 1);

	getglobal("PartyQuestsFrame".."ExitButton"):Hide();
	getglobal("PartyQuestsFrame".."TitleText"):SetText(PARTYQUESTS_TITLE_TEXT);
	getglobal("PartyQuestsFrame".."MainIcon"):SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon");

	PartyQuests_AddPartyButton();
 	PartyQuests_PeriodicMailCheck();
	PartyQuests_LoadGui();	
end

-- Register with Cosmos
function PartyQuests_RegisterCosmos()
	if ( Cosmos_RegisterButton ) then
		Cosmos_RegisterButton ( 
			"PartyQuests", 
			PARTYQUESTS_TITLE_TEXT, 
			PARTYQUESTS_BUTTON_TOOTIP, 
			"Interface\\Icons\\INV_Misc_Book_04", 
			TogglePartyQuests
		);
	end
end

		

--[[ Event Handlers ]]--
function PartyQuests_Frame_OnLoad()
	-- Register for Updates
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("UI_INFO_MESSAGE");
	
	-- Queue a Gui Refresh
	Chronos.afterInit(PartyQuests_Frame_Initialize);
	
	-- Register with Cosmos (Earth in the future)
	PartyQuests_RegisterWithEarth();
	
	-- Register with Sky
	PartyQuests_RegisterWithSky();

	-- Register the scholar
	Libram.registerScholar({id="PartyQuestScholar";callback=PartyQuests_ScholarCall;description="PartyQuest's scholar - informs PQ when the gui is in need of changing. "} );
	
	-- Register the scholar
	Sky.registerHostess({id="PartyQuestHostess";callback=PartyQuests_HostessCall;channels={SKY_PARTY};description="PartyQuest's hostess - informs PQ when a player join/leaves on the SkyParty channel. "} );
	
	-- Add ourself to the standard windows
	UIPanelWindows[this:GetName()] = { area = "left", pushable = 2 };

	-- Replace the old QuestLog *** Make Optional Later ***
	ToggleQuestLog = TogglePartyQuests;
	
	--
	-- Set the frame values
	-- 
	PartyQuestsFrame.display = "self";
	PartyQuestsFrame.hasInit = false;
	PartyQuestsFrameTree.tooltipPlacement = "frame";
	PartyQuestsFrameTree.tooltipAnchor = "ANCHOR_TOPRIGHT";

	--
	-- onEvent
	--
	this.onEvent = PartyQuests_Frame_OnEvent;
	this.onShow = PartyQuests_Frame_OnShow;
	this.onHide = PartyQuests_Frame_OnHide;
end

--[[ Resizes the default log buttons ]]--
function PartyQuests_AddPartyButton()
	QuestLogFramePartyButton:Show();
	--local AbsDim = getglobal("QuestLogFrameAbandonButtonAbsDimension");
	--AbsDim:SetSize(84,21);
	QuestLogFrameAbandonButton:SetWidth(84);
	QuestLogFrameAbandonButton:SetText(PARTYQUESTS_BUTTON_ABANDON_TEXT);
	
	QuestFramePushQuestButton:ClearAllPoints();
	QuestFramePushQuestButton:SetPoint("LEFT","QuestLogFrameAbandonButton","RIGHT",-2,0);
	QuestFramePushQuestButton:SetWidth(84);
	QuestFramePushQuestButton:SetText(PARTYQUESTS_BUTTON_SHARE_TEXT);
end

--[[ Removes the Party log button ]]--
function PartyQuests_RemovePartyButton()
	QuestLogFramePartyButton:Hide();
	QuestLogFrameAbandonButton:SetWidth(125);
	QuestLogFrameAbandonButton:SetText(ABANDON_QUEST);
		
	QuestFramePushQuestButton:ClearAllPoints();
	QuestFramePushQuestButton:SetPoint("RIGHT","QuestFrameExitButton","LEFT",0,0);
	QuestFramePushQuestButton:SetWidth(123);
	QuestFramePushQuestButton:SetText(SHARE_QUEST);
end

-- Event!
function PartyQuests_Frame_OnEvent()
	if ( not PartyQuestsFrame.hasInit ) then 
		return;
	end

	--Sea.io.printComma(event,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9);
	
	if ( event == "PARTY_LEADER_CHANGED" ) then
		PartyQuests_ProcessPartyLeaderChanged();
	elseif ( event == "PARTY_MEMBERS_CHANGED" ) then 
		PartyQuests_ProcessPartyMembersChanged();
	elseif ( event == "UI_INFO_MESSAGE" ) then
		local questUpdateText = gsub(arg1,"(.*): %d+/%d+","%1",1);
		if (questUpdateText ~= arg1) then
			PartyQuests_SendQuestProgressUpdateToParty(arg1);
		end

	end
end

-- Show
function PartyQuests_Frame_OnShow()
	PartyQuests_RequestNeededLogs ();
	PartyQuests_LoadGui();
	-- Show the current quest
	PartyQuests_ShowCurrentQuest();
end

--[[ Tabs ]]--
function PartyQuests_SelectTab(id)
	if ( id == 1 ) then 
		PartyQuests_DisplayPlayerQuests();
	else
		PartyQuests_DisplayPartyQuests();
	end
end
function PartyQuests_DisplayPartyQuests()
	PartyQuestsFrame.display = "party";
	PartyQuests_RequestNeededLogs ();
	PartyQuests_LoadGui ();
end
function PartyQuests_DisplayPlayerQuests()
	PartyQuestsFrame.display = "self";
	PartyQuests_LoadGui ();
end

-- Set the Icon for the Log Frame
function PartyQuests_LogFrame_OnLoad()
	-- Save the log when you close it.
	this.onHide = function() 
		if ( PartyQuestsFrame:IsVisible() ) then 
			PartyQuests_CurrentQuest = nil; 
		end
	end;
	
	-- Make us pushable
	UIPanelWindows[this:GetName()] =		{ area = "left",	pushable = 5 };

	--
	-- Set the icon to a boring default
	-- 
	getglobal(this:GetName().."MainIcon"):SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon");
	getglobal(this:GetName().."TitleText"):SetText(PARTYQUESTS_QUESTINFO_TEXT);
end

--[[ Log Frame Abandon Button ]]--
function PartyQuests_LogFrame_Abandon_OnLoad()
	this.onClick = PartyQuests_LogFrame_Abandon_OnClick;
end
function PartyQuests_LogFrame_Abandon_OnClick()
	if ( not Sea.wow.questLog.protectQuestLog() ) then 
		return false; 
	end

	-- Expand everything
	ExpandQuestHeader(0);

	if ( PartyQuestsLog.questInfo ) then 	
		-- Select it
		SelectQuestLogEntry(PartyQuestsLog.questInfo.id);	
	
		SetAbandonQuest();
		StaticPopup_Show("ABANDON_QUEST", GetAbandonQuestName());
	end

	-- Unprotect
	Sea.wow.questLog.unprotectQuestLog();
end

--[[ Log Frame Share Button ]]--
function PartyQuests_LogFrame_Share_OnLoad()
	this.onClick = PartyQuests_LogFrame_Share_OnClick;
end
function PartyQuests_LogFrame_Share_OnClick()
	if ( not Sea.wow.questLog.protectQuestLog() ) then 
		return false; 
	end

	-- Expand everything
	ExpandQuestHeader(0);

	if ( PartyQuestsLog.questInfo ) then 	
		-- Select it
		SelectQuestLogEntry(PartyQuestsLog.questInfo.id);	
	
		QuestLogPushQuest();
	end

	-- Unprotect
	Sea.wow.questLog.unprotectQuestLog();
end

--[[ Old Log Frame Party Button ]]--
function PartyQuests_QuestLogFramePartyButton_OnLoad()
	this.onEnter = PartyQuests_QuestLogFramePartyButton_OnEnter;
	this.onLeave = PartyQuests_QuestLogFramePartyButton_OnLeave;
	this.onClick = PartyQuests_QuestLogFramePartyButton_OnClick;
end

function PartyQuests_QuestLogFramePartyButton_OnEnter()
	Sea.wow.tooltip.protectTooltipMoney();
	GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
	GameTooltip:SetText(TEXT(PARTYQUESTS_BUTTON_TOOTIP), 1.0, 1.0, 1.0);
	Sea.wow.tooltip.unprotectTooltipMoney();
end
function PartyQuests_QuestLogFramePartyButton_OnLeave()
	GameTooltip:Hide();
end
function PartyQuests_QuestLogFramePartyButton_OnClick()
	TogglePartyQuests();
end

--[[ On and off ]]--
function TogglePartyQuests() 
	if ( PartyQuestsFrame:IsVisible() ) then 
		HideUIPanel(PartyQuestsFrame);
		if ( PartyQuestsLogFrame:IsVisible() ) then 
			PartyQuestsLogFrame:Hide(); 
		end
	else
		ShowUIPanel(PartyQuestsFrame);
	end		
end

