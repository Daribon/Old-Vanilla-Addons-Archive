--[[
	File: QuestShareFrame.lua
	Author: mgorecki
	LastEdit: $Author: mgorecki $
	Date: $Date: 2004-07-30 00:09:36 -0800 (Fri, 30 Jul 2004) $
	Version: $Rev: 657 $

  ]]--
-----------------------------------------------
-- Quest Share v2.6							 --
-- by Marek Gorecki (4/2/04)				 --
-- Cosmos Version							 --
-- Lua Script File							 --
-----------------------------------------------

-- Latest Changes:
-- 7/30/04 - Moved to Cosmos Party Channel - mgorecki

UIPanelWindows["QuestShareFrame"] =		{ area = "left",	pushable = 10 };

local QUESTSHARE_AUTOREQUEST_ONJOIN = 1;

-- Globals
SHARE_QUESTS_DISPLAYED = 20;
MAX_SHARE_QUESTS = 128;
MAX_SHARE_OBJECTIVES = 10;
QUESTSHARE_QUEST_HEIGHT = 16;

QUESTSHARE_SCHEDULE_NAME = "QuestShare_SendMessage";

-- base delay between updates
QUESTSHARE_UPDATE_DELAY = 0.2;
-- base extra delay when a successful update occurs
QUESTSHARE_SUCCESSFUL_UPDATE_DELAY = 0.2;
-- variable extra delay when a successful update occurs
QUESTSHARE_SUCCESSFUL_UPDATE_DELAY_VARIABLE = 0.2;

QUESTSHARE_VERSION = 2;
QUESTSHARE_TAG = "<QS".. QUESTSHARE_VERSION..">";
QuestShare_QuestDetails_InProcess = false;
QuestShare_UpdateInProcess = false;
QuestShare_ModEnabled = true;
QuestShare_DebugMode = 0;
QuestShare_LastQuestSelected = 0;

-- First Time check
local QuestShareFirstLoad = 0;

-- Timer-based Instruction Queue
local TimePassed = 0;
local CommQueue = {};
local RefreshingPlayerData = false;
local PlayerChangesFlag = 0;
local LastSendLocation = "";
local LastUpdateLocation = "";
local LastSelfLocation = "";

-- Data
local TotalEntries = 0;
local QuestDataAll = { };
local QuestDataCommon = { };
local QuestDataPlayer = { };
QS_QuestDataParty1 = { };
QS_QuestDataParty2 = { };
QS_QuestDataParty3 = { };
QS_QuestDataParty4 = { };


-- specifies the last "completion" notification sent
local LastCompleteTitle = "";
local LastCompleteLevel = 0;

-- Party Names tracked
QS_PartyInfo1 = {};
QS_PartyInfo2 = {};
QS_PartyInfo3 = {};
QS_PartyInfo4 = {};

-- Expansion buttons on UI
local HeaderExpand = {};

-- indexes into the Expand array to track +/- expansion
local HEADER_FILTER = 1;
local HEADER_COMMON =  2;
local HEADER_PLAYER =  3;
local HEADER_PARTY1 =  4;
local HEADER_PARTY2 =  5;
local HEADER_PARTY3 =  6;
local HEADER_PARTY4 =  7;
local HEADER_LOCATION = 0;

HeaderExpand[HEADER_FILTER] = 0; -- filters
HeaderExpand[HEADER_COMMON] = 0; -- common
HeaderExpand[HEADER_PLAYER] = 0; -- player
HeaderExpand[HEADER_PARTY1] = 0; -- party 1
HeaderExpand[HEADER_PARTY2] = 0; -- party 2
HeaderExpand[HEADER_PARTY3] = 0; -- party 3
HeaderExpand[HEADER_PARTY4] = 0; -- party 4

-- Check if a line of UI is a header
local HeaderCheck = { };

-- Active Quest Detail
local DetailName = "";
local DetailLevel = 0;
local DetailTitle = "";
local DetailObjectivesText = "";
QS_DetailObjectivesList0 = {};
QS_DetailObjectivesList1 = {};
QS_DetailObjectivesList2 = {};
QS_DetailObjectivesList3 = {};
QS_DetailObjectivesList4 = {};

local oldDetailLevel = 0;
local oldDetailTitle = "";

local QuestLogShown = 0;

-- Filter System
-- filters table, containing: type, val, name
-- type can be:
--  "party" - show party members
--  "partymember" - show party member
--  "label" - just text separating filters
--  "loc" - individual location
--  "currloc" - current location (changes depending on where you are)
--  "showloc" - show locations (filters out location titles)
-- val (checkbox value) can be:
-- 1 - checked, 0 - unchecked
-- title is the title of the filter
-- The following are optional, based on filter type:
-- name - party member's name, or location if it's a location filter

local Filters = {}; 
local FilterMap = {}; -- mapping of enabled filters into an indexable list (for faster lookup)
local SHOW_PARTY_FILTER = 0; -- index into Filters for show all party members
local Locations = {}; -- lists out the current locations in the QS system, for filtering purposes
local ToggleCheckValue = nil; -- first toggle unchecks everything

local QuestShare_ShouldShowLevels = true; 
-- Functions

function QuestShare_ShowLevel(checked)
	if ( checked == 1 ) then
		QuestShare_ShouldShowLevels = true;
	else
		QuestShare_ShouldShowLevels = false;
	end
end

function QuestShare_Enable(checked)
	if (checked == 1) then
		QuestShare_DebugMessage("Enabling Quest Share");
		QuestShare_ModEnabled = true;
		QuestShare_EnableMod();
	else
		QuestShare_ModEnabled = false;
		QuestLogFrameShareButton:Hide();
		QuestLogFrameAbandonButton:SetWidth(125);
		QuestLogFrameAbandonButton:SetText(ABANDON_QUEST);
		
		QuestFramePushQuestButton:ClearAllPoints();
		QuestFramePushQuestButton:SetPoint("RIGHT","QuestFrameExitButton","LEFT",0,0);
		QuestFramePushQuestButton:SetWidth(123);
		QuestFramePushQuestButton:SetText(SHARE_QUEST);
	end
end

function QuestShare_DebugMessage(message)
	if (QuestShare_DebugMode == 1) then
		DEFAULT_CHAT_FRAME:AddMessage("<QSDebug> "..message,0,1,0);
	end
end

function QuestShare_EnableMod()
	QuestLogFrameShareButton:Show();
	--local AbsDim = getglobal("QuestLogFrameAbandonButtonAbsDimension");
	--AbsDim:SetSize(84,21);
	QuestLogFrameAbandonButton:SetWidth(84);
	QuestLogFrameAbandonButton:SetText(QUESTSHARE_LOG_ABANDON_BUTTON_TEXT);
	
	QuestFramePushQuestButton:ClearAllPoints();
	QuestFramePushQuestButton:SetPoint("LEFT","QuestLogFrameAbandonButton","RIGHT",-2,0);
	QuestFramePushQuestButton:SetWidth(84);
	QuestFramePushQuestButton:SetText(QUESTSHARE_LOG_SHARE_BUTTON_TEXT);
	
	QuestShareTitleText:SetText(QUESTSHARE_MAIN_TITLE);
	--getglobal("Sizex") = "84";
	if (QuestShareFirstLoad == 1) then
		QuestShare_Init();
	end
end

function ToggleQuestShare()

	if (not QuestShare_ModEnabled) then
		HideUIPanel(QuestShareFrame);
		QuestLogFrameShareButton:Hide();		
		return;
	else
		QuestLogFrameShareButton:Show();		
	end

	if ( QuestShareFrame:IsVisible() ) then
		HideUIPanel(QuestShareFrame);
		QuestShare_OnHide();
		if (QuestLogFrame:IsVisible()) then
			QuestLogShown = 1;		
			HideUIPanel(QuestLogFrame);
		else
			QuestLogShown = 0;
		end
	else
		QuestShare_OnShow();
		ShowUIPanel(QuestShareFrame);
		if (QuestLogShown == 1 and not QuestLogFrame:IsVisible()) then		
			ShowUIPanel(QuestLogFrame);
		end

		local firstButton = getglobal("QuestShareTitle1");
		if (not firstButton:IsVisible()) then
			QuestShare_DebugMessage("Setting refresh text");	
			local questButton = getglobal("QuestShareTitle10");
			questButton:SetText(QS_REFRESHING);					
			questButton:SetNormalTexture("");
			getglobal("QuestShareTitle10Highlight"):SetTexture("");
			questButton:Show();
		elseif (getglobal("QuestShareTitle10"):IsVisible() and getglobal("QuestShareTitle10"):GetText() == QS_REFRESHING) then
			QuestShare_DebugMessage("Clearing refresh text");	
			local questButton = getglobal("QuestShareTitle10");
			questButton:SetText("");					
			questButton:SetNormalTexture("");
			getglobal("QuestShareTitle10Highlight"):SetTexture("");
			questButton:Hide();		
		end
		
		
		
		if (QuestShare_QuestShare_LastQuestSelected ~= 0) then
			SelectQuestLogEntry(QuestShare_LastQuestSelected);
		else
			SelectQuestLogEntry(1);
		end

		QuestLog_UpdateQuestDetails();
	end
end

function QuestShareTitleButton_OnLoad()
		this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function QuestShare_OnLoad()
	Cosmos_RegisterButton ( 
		"QuestShare", 
		QS_BUTTON, 
		QS_BUTTON_INFO, 
		"Interface\\Icons\\INV_Misc_Book_04", 
		function() if (QuestShareFrame:IsVisible()) then HideUIPanel(QuestShareFrame); else ShowUIPanel(QuestShareFrame); end return; end
		);

	-- Register with CSM (Cosmos Master Configuration) --
	Cosmos_RegisterConfiguration("COS_QUESTSHARE","SECTION",QS_CONFIG_SEP,QS_CONFIG_SEP_INFO);
	Cosmos_RegisterConfiguration("COS_QUESTSHARE_SECTION","SEPARATOR",QS_CONFIG_SEP,QS_CONFIG_SEP_INFO);
	
	Cosmos_RegisterConfiguration(
		"COS_QUESTSHARE_ENABLEQUESTSHARE",
		"CHECKBOX",
		QS_CONFIG_OPT,
		QS_CONFIG_OPT_INFO,
		QuestShare_Enable,
		1,
		0,
		0,
		1,
		"",
		.01,
		1,
		"\%"
	);

	Cosmos_RegisterConfiguration(
		"COS_QUESTSHARE_SHOW_LEVEL",
		"CHECKBOX",
		QS_CONFIG_SHOW_LEVEL,
		QS_CONFIG_SHOW_LEVEL_INFO,
		QuestShare_ShowLevel,
		1
	);

	-- Register to listen to the Cosmos Party Channel	
	Cosmos_RegisterChatWatch("QS_COMM",{CHANNEL_PARTY},ProcessQuestShareCommand);
	Cosmos_RegisterChatWatch("QS_COMM_WHISPER",{"WHISPER"},ProcessQuestShareCommand);
	Cosmos_RegisterChatWatch("QS_COMM_WHISPER_INFORM",{"WHISPER_INFORM"},ProcessQuestShareCommand);

	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
    this:RegisterEvent("PARTY_MEMBERS_CHANGED");
    this:RegisterEvent("UI_INFO_MESSAGE");
end

function QuestShare_Init()
	
	local text = QuestShareShowFiltersCheckText;
	text:SetText('Show Filters');
	Cosmos_RegisterCVar("QuestShare_ShowFiltersCheck", 1);
	QuestShareShowFiltersCheck:SetChecked(Cosmos_GetCVar("QuestShare_ShowFiltersCheck"));
	
	QuestShare_InitializeFilters();

	-- Clear all data
	table.setn(QS_QuestDataParty1,0);
	table.setn(QS_QuestDataParty2,0);
	table.setn(QS_QuestDataParty3,0);
	table.setn(QS_QuestDataParty4,0);
	QS_PartyInfo1.name = "";
	QS_PartyInfo2.name = "";
	QS_PartyInfo3.name = "";
	QS_PartyInfo4.name = "";
	
	QuestShare_ClearPartyFilters();

	table.setn(Locations,0);	
	
	Cosmos_ScheduleByName(QUESTSHARE_SCHEDULE_NAME, QUESTSHARE_UPDATE_DELAY, QuestShare_DoScheduledUpdate);
	
	QuestShare_QueueCommCommand("PROCESS_GROUP_CHANGE");
	FillQuestDataPlayer();
	QuestShare_QueueCommCommand("SENDQREQUEST");
	QuestShare_SendAllQuestData();
end

function QuestShare_QueueCommCommand(type,arg1,arg2,arg3,arg4,arg5)
	if ( not QuestShare_ModEnabled ) then
		return;
	end
	if (type == nil) then
		return;
	end

	local val = {};
	
	val.type = type;
	
	if (arg1 ~= nil) then
		arg1 = arg1.."";
		val.arg1 = arg1;
	end
	
	if (arg2 ~= nil) then
		arg2 = arg2.."";
		val.arg2 = arg2;
	end
	
	if (arg3 ~= nil) then
		arg3 = arg3.."";
		val.arg3 = arg3;
	end
	
	if (arg4 ~= nil) then
		arg4 = arg4.."";
		val.arg4 = arg4;
	end

	if (arg5 ~= nil) then
		arg5 = arg5.."";
		val.arg5 = arg5;
	end
	
	table.insert(CommQueue,val);
end

function QuestShare_SendNextUpdate()
	if ( not QuestShare_ModEnabled ) then
		return;
	end
	
	-- Go through the Queue
	
	
	if (table.getn(CommQueue) > 0) then
		
		if (CommQueue[1].type == "CHAT") then
			--SendChatMessage(CommQueue[1].arg1,CommQueue[1].arg2,DEFAULT_CHAT_FRAME.language,CommQueue[1].arg3);
			Cosmos_SendPartyMessage(CommQueue[1].arg1);
		elseif (CommQueue[1].type == "WHISPER") then		
			SendChatMessage(CommQueue[1].arg1,"WHISPER",DEFAULT_CHAT_FRAME.language,CommQueue[1].arg4);
		elseif (CommQueue[1].type == "SENDQINFO") then
			QuestShare_SendQuestInfo(CommQueue[1].arg1+0);
		elseif (CommQueue[1].type == "SENDQREQUEST") then
			QuestShare_DebugMessage("Sending Request to Comm Channel");			
			--SendChatMessage("<QS"..QUESTSHARE_VERSION.."> QREQUEST -=Quest Share v"..QUESTSHARE_VERSION.."=- See interface forum for details.","CHANNEL", DEFAULT_CHAT_FRAME.language, channelNum);			
			Cosmos_SendPartyMessage("<QS"..QUESTSHARE_VERSION.."> QREQUEST -=Quest Share v"..QUESTSHARE_VERSION.."=- See interface forum for details.");
		elseif (CommQueue[1].type == "SENDQDETAILS") then
			SendQuestDetails(CommQueue[1].arg1,CommQueue[1].arg2,CommQueue[1].arg3+0);
		elseif (CommQueue[1].type == "FILLPLAYERQUEST") then
			FillPlayerQuest(CommQueue[1].arg1+0);
		elseif (CommQueue[1].type == "FILLPLAYERQUEST_CHANGES") then
			if (PlayerChangesFlag == 1) then
				QuestShare_DebugMessage("Changes found, updating player log");
				FillQuestDataPlayer();
			end
		elseif (CommQueue[1].type == "QUESTSHAREUPDATE") then
			QuestShare_Update();
		elseif (CommQueue[1].type == "SENDQUPDATE") then
			QuestShare_SendSingleQuestUpdate(CommQueue[1].arg1+0);			
		elseif (CommQueue[1].type == "CLEARPLAYERDATA") then
			if (table.getn(QuestDataPlayer) == 0) then
				local questButton = getglobal("QuestShareTitle10");
				questButton:SetText(QS_REFRESHING);					
				questButton:SetNormalTexture("");
				getglobal("QuestShareTitle10Highlight"):SetTexture("");
				questButton:Show();
			end
				
			table.setn(QuestDataPlayer,0);
			RefreshingPlayerData = true;
		elseif (CommQueue[1].type == "ENDPLAYERDATAREFRESH") then
			RefreshingPlayerData = false;
		elseif (CommQueue[1].type == "SET_PLAYER_CHANGES_FLAG") then
			PlayerChangesFlag = CommQueue[1].arg1+0;
		elseif (CommQueue[1].type == "FILLPLAYERQUEST_FINISHED") then
			QuestShare_QueueCommCommand("FILLPLAYERQUEST_CHANGES");
			QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
		elseif (CommQueue[1].type == "SET_LAST_UPDATE_LOCATION") then
			LastUpdateLocation = CommQueue[1].arg1;
		elseif (CommQueue[1].type == "PROCESS_GROUP_CHANGE") then
			--QuestShare_ProcessGroupChange();
			QuestShare_Refresh();
		elseif (CommQueue[1].type == "SENDUPDATEMESSAGE") then
			QuestShare_DebugMessage("Sending: "..CommQueue[1].arg1.." arg2: "..CommQueue[1].arg2.. " arg3: "..CommQueue[1].arg3.." arg4: "..CommQueue[1].arg4);
			QuestShare_SendQuestUpdateMessage(CommQueue[1].arg1,CommQueue[1].arg2, CommQueue[1].arg3, CommQueue[1].arg4);
		end
		
				
		table.remove(CommQueue,1);
	end
end

function QuestShare_DoUpdate()
	if (QuestShare_UpdateInProcess == true) then
		return false;
	end
	QuestShare_UpdateInProcess = true;
	QuestShare_SendNextUpdate();
	QuestShare_UpdateInProcess = false;
	return true;
end

function QuestShare_HasGroup()
	return ( QuestShare_GetGroupMembers() > 1);
end

function QuestShare_GetGroupMembers()
	local mx = 4;
	for i = 1, mx do
		if (not UnitInParty("party"..i)) then
			return i;
		end
	end
	return mx+1;
end

function QuestShare_DoScheduledUpdate()
	local delay = QUESTSHARE_UPDATE_DELAY;
	if ( QuestShare_DoUpdate() ) then
		if ( QuestShare_HasGroup() ) then
			if ( not ChatTraffic_Enabled ) or ( ChatTraffic_Enabled ~= 1 ) then
				delay = delay + ( ( QUESTSHARE_SUCCESSFUL_UPDATE_DELAY + 
					( QUESTSHARE_SUCCESSFUL_UPDATE_DELAY_VARIABLE * math.random() ) ) * QuestShare_GetGroupMembers());
			else
				QUESTSHARE_UPDATE_DELAY = 0.1;
			end;
		end
	end
	Cosmos_ScheduleByName(QUESTSHARE_SCHEDULE_NAME, delay, QuestShare_DoScheduledUpdate);
end

function QuestShare_JoinedChan()
	QuestShare_QueueCommCommand("SENDQREQUEST");
end

function QuestShare_OnEvent(event, message)
	-- is Quest Share enabled?
	if (not QuestShare_ModEnabled) then
		return;
	end

	if (event == "UNIT_NAME_UPDATE" and QuestShareFirstLoad == 0) then
		if (arg1 == "player") then
			if (UnitName("player") ~= nil and UnitName("player") ~= "Unknown Being" and UnitName("player") ~= "") then
				QuestShareFirstLoad = 1;		
				QuestShare_Init();
			end
		end
	end

	if (QuestShareFirstLoad == 0) then
		return;
	end
	
	if ( event == "QUEST_LOG_UPDATE" ) then				
		-- Send changes to party members
		QuestShare_SendQuestUpdates();
		QuestShare_DebugMessage("Quest Log Update");			
	elseif (event == "PARTY_LEADER_CHANGED") then
			
		QuestShare_DebugMessage("Party Leader Change");			
		QuestShare_QueueCommCommand("SENDQREQUEST");
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		QuestShare_ProcessPartyMemberChange();

	elseif (event == "UI_INFO_MESSAGE") then
			-- Find Quest Update text
			if ( type (message) == "string" ) then
				QuestShare_DebugMessage("notif... "..message);
				local questUpdateText = gsub(message,"(.*): %d+/%d+","%1",1);
				if (questUpdateText ~= message) then
					QuestShare_SendQuestItemUpdateText(message);
				end
			end
	end
	

end

function QuestShare_OnShow()
	if (QuestShareFirstLoad == 0) then
		QuestShareFirstLoad = 1;	
		QuestShare_Init();
	end

	UpdateMicroButtons();
	PlaySound("igQuestShareOpen");
	QuestShareListScrollFrameScrollBar:SetValue(0);
	QuestShareListScrollFrameScrollBar:Show();

end

function QuestShare_OnHide()
	UpdateMicroButtons();
	PlaySound("igQuestLogClose");
end

function QuestShare_ProcessPartyMemberChange()
	-- Some change in the party, so lets refresh
	QuestShare_Refresh();
end

-- Clears all the people and quests
function QuestShare_ClearGroup()
		table.setn(QS_QuestDataParty1,0);
		table.setn(QS_QuestDataParty2,0);
		table.setn(QS_QuestDataParty3,0);
		table.setn(QS_QuestDataParty4,0);
		QS_PartyInfo1.name = "";
		QS_PartyInfo2.name = "";
		QS_PartyInfo3.name = "";
		QS_PartyInfo4.name = "";
		QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
end

-- Removes a player and their quests
function QuestShare_RemovePlayer(name)
	local memberId = 0;
	-- Find the player in our list
	for i=1, MAX_PARTY_MEMBERS, 1 do
		if ( getglobal("QS_PartyInfo"..i) ~= nil and getglobal("QS_PartyInfo"..i).name == name ) then
			-- Kill their data
			table.setn(getglobal("QS_QuestDataParty"..i),0);
			local partyInfo = getglobal("QS_PartyInfo"..i);
			partyInfo.name = "";
			QuestShare_RemoveFilterPlayer(i);
			QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
			break;
		end
	end
end

-- Refresh all data, sends requests to all party members
function QuestShare_Refresh()

	-- Clear all data
	table.setn(QS_QuestDataParty1,0);
	table.setn(QS_QuestDataParty2,0);
	table.setn(QS_QuestDataParty3,0);
	table.setn(QS_QuestDataParty4,0);
	QS_PartyInfo1.name = "";
	QS_PartyInfo2.name = "";
	QS_PartyInfo3.name = "";
	QS_PartyInfo4.name = "";
	
	QuestShare_ClearPartyFilters();

	table.setn(Locations,0);
	
	QuestShare_QueueCommCommand("SENDQREQUEST");

	FillQuestDataPlayer();
	QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
end

-- This function takes a line of text and parses out quest commands
function ProcessQuestShareCommand(type, info, text, arg2, arg3, arg4)

	if (arg4 ~= nil) then
		QuestShare_DebugMessage("Processing: type - "..type.." arg1 - "..text..", arg2 - "..arg2..", arg3 - "..arg3..", arg4 - "..arg4);
	end
	
	local info = ChatTypeInfo["SYSTEM"];

	local command = gsub(text,".*<QS%d+>%s+(%w+).*","%1",1);
	local name = arg2;

	if (command == "") then
		return 1;
	end
	
	if (name == UnitName("player")) then
		return 1;
	end

	if (command == "QPROGRESSUPDATE") then
		--local level = gsub(text,".*%[(%d+)%].*","%1",1);
		--local title = gsub(text,".*%[%d+%]%s*(.*),.*","%1",1);
		local updateMessage = gsub(text,".*QPROGRESSUPDATE%s(.*)","%1",1);
		
		if (updateMessage == text) then
			return 1;
		end
		
		local numItems = gsub(updateMessage,".*: (%d+)/%d+","%1",1);
		local totalItems = gsub(updateMessage,".*: %d+/(%d+)","%1",1);
		
		if (numItems == updateMessage) then
			numItems = "";
		end
		
		if (totalItems == updateMessage) then
			totalItems = "";
		end
		
		if (numItems ~= "" and totalItems ~= "" and numItems == totalItems) then
			if (QuestShare_GetQuestNotifyFilter("objective")) then
				DEFAULT_CHAT_FRAME:AddMessage(format(QS_OBJCOMPLETED, name, updateMessage));
				UIErrorsFrame:AddMessage(format(QS_OBJCOMPLETED, name, updateMessage), 0.9, 0.9, 0.0, 1.0, UIERRORS_HOLD_TIME);			  					
			end
		else
			if (QuestShare_GetQuestNotifyFilter("count")) then
				DEFAULT_CHAT_FRAME:AddMessage(format(QS_QPROGRESS, name, updateMessage));
				UIErrorsFrame:AddMessage(format(QS_QPROGRESS, name, updateMessage), 0.9, 0.9, 0.0, 1.0, UIERRORS_HOLD_TIME);			  		
			end
		end
		
	-- QINFO is data for one Quest	
	elseif (command == "QINFO") then			
		-- Strip out level,title,completion flag		
		local level = gsub(text,".*%[(%d+)%].*","%1",1);
		local title = gsub(text,".*%[%d+%]%s*(.*),,.*","%1",1);
		local isCompleted = string.find(text,"complete");
		local location = gsub(text,".+,complete,(.*)","%1",1);

		if (title == text) then
			title = gsub(text,".*%[%d+%]%s*(.*),complete,.*","%1",1);
			
			if (title == text) then
				title = gsub(text,".*%[%d+%]%s*(.*),complete","%1",1);

				if (title == text) then
					title = gsub(text,".*%[%d+%]%s*(.*),","%1",1);
				end						
			end
		end

		if (location == text) then
			location = gsub(text,".+,,(.*)","%1",1);
			if (location == text) then
				location = "";
			end
		end
		
		level = level + 0;		
		
		if (isCompleted == nil) then
			isCompleted = 0;
		else
			isCompleted = 1;
		end
		
		-- Error check
		if (name == text or level == text or title == text) then
			DEFAULT_CHAT_FRAME:AddMessage("<QS> Error parsing command! Quest Share Version mismatch? Version is "..QUESTSHARE_VERSION,info.r,info.g,info.b,info.id);	
			return 1;	
		end
		
		-- Complex process to add a person because IDs don't necessarily sync up
		local memberId = 0;
		local isPartyMember = false;
		
		-- Find out if we've already added them so we can update their quest
		for i=1, MAX_PARTY_MEMBERS, 1 do
				local tempPartyInfo = getglobal("QS_PartyInfo"..i);
				if (tempPartyInfo.name ~= nil and tempPartyInfo.name == name) then
						memberId  = i;
						break;
					end
				end

		-- Make sure they're a real party member
		for i=1, MAX_PARTY_MEMBERS, 1 do
					if ( UnitName("party"..i) == name ) then
						isPartyMember = true;
						break;
					end
				end

		local questData = QuestDataPlayer;

		-- Add a new player if necessary
		if (isPartyMember == true and memberId == 0) then
			for i=1, MAX_PARTY_MEMBERS, 1 do			
					local tempPartyInfo = getglobal("QS_PartyInfo"..i);
					if (tempPartyInfo.name == nil or tempPartyInfo.name == "") then										
						tempPartyInfo.name = name;
						memberId = i;
						QuestShare_UpdatePartyFilter(i);												
						break;
					end
			end
		end
		
		-- If person isn't in the party, throw an error!
		if (memberId > 0) then
			questData = getglobal("QS_QuestDataParty"..memberId);			
		elseif (UnitName("player") ~= name) then
			--DEFAULT_CHAT_FRAME:AddMessage("<QS> Error: Request from "..name.." not sent from party member!",info.r,info.g,info.b,info.id);				
			return 0;
		end
		
		local count = table.getn(questData);
		local found = 0;
		local locationSet = false;
		local locStart = 0;

		-- v2.4 - Lets see if we already have the location set
		if (location ~= "") then		
			for i=1,count,1 do
			
				-- Check the first index where we insert a new quest
				if (locationSet) then
					if (questData[i].location ~= nil and questData[i].location ~= location) then
						locStart = i;
					end 
				end
				
				if (questData[i].level == 0 and questData[i].location ~= nil and location == questData[i].location) then
					locationSet = true;
				end			
			end		
		end
		
		-- Look for dupes
		for i=1,count,1 do
			if (questData[i].title == title and questData[i].level == level) then
			  questData[i].level = level;
			  if (questData[i].completed == 0 and isCompleted == 1) then
				if (QuestShare_GetQuestNotifyFilter("quest")) then
					local str = format(QS_XHASCOMPLETED, name, title);
					if ( QuestShare_ShouldShowLevels ) then
						str = str..format(QS_QUEST_LEVEL, level);
					end
					DEFAULT_CHAT_FRAME:AddMessage(str);
					UIErrorsFrame:AddMessage(str, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);			  
				end
				LastCompleteTitle = title;
				LastCompleteLevel = level;
			  end
			  questData[i].completed = isCompleted;
			  found = 1;
			  break;
			 end
		end
		
		-- Add new quest entry
		if (found ~= 1) then
			
			if (not locationSet and location ~= "") then
				-- v2.4 - Lets add a location	
				local loc = {};
				loc.level = 0;
				loc.title = location;
				loc.location = location;
				table.insert(questData,loc);	
				-- new location
				local locFound = false;
				for j=1,table.getn(Locations),1 do
					if (Locations[j].name ~= nil and Locations[j].name == location) then
						locFound = true;
					end
				end			
				
				if (locFound == false) then
					local newloc = {};
					newloc.name = location;
					table.insert(Locations,newloc);
					QuestShare_UpdateLocationFilters();
				end
			end			
			
			local value = {};
			value.title = title;
			value.level = level;
			value.completed = isCompleted;
			if (location ~= nil and location ~= "") then
				value.location = location;
			else
				value.location = nil;
			end
					
			if (locationSet and locStart ~= 0) then
				table.insert(questData,locStart,value);
			else			
				table.insert(questData,value);
			end
		end
		
		QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
		
		-- Delete a quest from your list
	elseif (command == "QDELETE") then		
		local level = gsub(text,".*%[(%d+)%].*","%1",1);
		local title = gsub(text,".*%[%d+%]%s*(.*),.*","%1",1);
		local isCompleted = string.find(text,"complete");

		level = level + 0;		

		if (isCompleted == nil) then
			isCompleted = 0;
		else
			isCompleted = 1;
		end

		if (name == text or level == text or title == text) then
			DEFAULT_CHAT_FRAME:AddMessage("<QS> Error parsing command! Quest Share Version mismatch? Version is "..QUESTSHARE_VERSION,info.r,info.g,info.b,info.id);	
			return 1;	
		end
		
		local memberId = 0;
		
		for i=1, MAX_PARTY_MEMBERS, 1 do
				local tempPartyInfo = getglobal("QS_PartyInfo"..i);
				if (tempPartyInfo.name ~= nil and tempPartyInfo.name == name) then
						memberId  = i;
						break;
					end
				end

		local questData = QuestDataPlayer;
		
		if (memberId > 0) then
			questData = getglobal("QS_QuestDataParty"..memberId);
		elseif (UnitName("player") ~= name) then
			--DEFAULT_CHAT_FRAME:AddMessage("<QS> Error: Request from "..name.." not sent from party member!",info.r,info.g,info.b,info.id);				
			return 0;
		end
		
		-- Remove if found
		local found = 0;
		for i=1,table.getn(questData),1 do
			if (questData[i].title == title and questData[i].level == level) then
				found = i;
			 end
		end

		if (found > 0) then
		  table.remove(questData,found);
		 end
		
		QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
		
		return 0;
		-- Ask for a list of quests from someone
	elseif (command == "QREQUEST") then
		QuestShare_DebugMessage("Sending QINFO to Channel");
		QuestShare_SendAllQuestData();
		return 0;
	elseif (command == "QGETDETAIL") then
		local level = gsub(text,".*%[(%d+)%].*","%1",1);
		local title = gsub(text,".*%[%d+%]%s*(.*),.*","%1",1);
		-- make sure it's an int
		level = level + 0;

		if (name == text or level == text or title == text) then
			DEFAULT_CHAT_FRAME:AddMessage("<QS> Error parsing QGETDETAIL! Quest Share Version mismatch? Version is "..QUESTSHARE_VERSION,info.r,info.g,info.b,info.id);	
			return 1;	
		end
		
		QuestShare_QueueCommCommand("SENDQDETAILS",name,title,level);
		return 0;
	elseif (command == "QDETAILS") then
		local detailType = gsub(text,".*QDETAILS (%w+):.*","%1",1);
		
		if (detailType == text) then
			DEFAULT_CHAT_FRAME:AddMessage("<QS> Invalid QDETAILS command! Quest Share Version mismatch? Version is: "..QUESTSHARE_VERSION,info.r,info.g,info.b,info.id);	
		end
		
		
		if (detailType == "title") then
			oldDetailTitle = DetailTitle;
			DetailName = name;
			DetailTitle = gsub(text,".*title:(.*)","%1",1);
		elseif (detailType == "level") then
			DetailLevel = DetailLevel + 0;
			oldDetailLevel = DetailLevel;
			
			DetailLevel = gsub(text,".*level:(%d+)","%1",1);
			
			if (DetailLevel == text) then
			 return 1;
			end	
								 
			-- make sure it's an int :)
			DetailLevel = DetailLevel + 0;

			if (DetailTitle ~= oldDetailTitle or (DetailLevel ~= oldDetailLevel and DetailTitle == oldDetailTitle)) then
				--SendChatMessage("From: "..name.." oldName: "..oldDetailTitle.." new: "..DetailTitle.." oldlevel: "..oldDetailLevel.." new: "..DetailLevel,"SAY",DEFAULT_CHAT_FRAME.language,"");
				for i=1,MAX_PARTY_MEMBERS,1 do
					local partyInfo = getglobal("QS_PartyInfo"..i);
					if (partyInfo.name ~= nil and partyInfo.name ~= "" and partyInfo.name == name) then
						local objectivesList = getglobal("QS_DetailObjectivesList"..i);
						table.setn(objectivesList,0);
					end
				end
				DetailObjectiveText = "";			
			end			
		elseif (detailType == "objectivetext") then
			DetailObjectivesText = gsub(text,".*objectivetext:(.+)","%1",1);
		elseif (detailType == "objective") then			
			local objective = gsub(text,".*objective:(.+)","%1",1);
			
			
			if (name == UnitName("player")) then
				table.insert(QS_DetailObjectivesList0,objective);
				--SendChatMessage("Adding "..objective.." for player","SAY",DEFAULT_CHAT_FRAME.language,"");
			else
				for i=1,MAX_PARTY_MEMBERS,1 do
					local partyInfo = getglobal("QS_PartyInfo"..i);
					if (partyInfo.name ~= nil and partyInfo.name ~= "" and partyInfo.name == name) then
						
						local objectivesList = getglobal("QS_DetailObjectivesList"..i);
						table.insert(objectivesList,objective);					
--						SendChatMessage("Adding "..objective.." for "..name,"SAY",DEFAULT_CHAT_FRAME.language,"");
					end
				end
			end
			
		elseif (detailType == "enddetails") then
			QuestShare_UpdateQuestDetails();
		end
	
		return 0;			
	end
end

-- Send specific quest data
function QuestShare_SendQuestInfo(id)
	if (id == nil or id > GetNumQuestLogEntries()) then
		return;
	end
	
	local questIndex = id + FauxScrollFrame_GetOffset(QuestLogListScrollFrame);
	local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(id);
	local questTitle = GetQuestLogTitle(id);
	if (isHeader) then
				if ( questLogTitleText ) then
					LastSendLocation = questLogTitleText;				
				else
					LastSendLocation = nil;
				end
	else
			local isCompleted = "";
			if (QuestShare_GetQuestCompleted(id) == 1) then
				isCompleted = "complete";
			end
			
			Cosmos_SendPartyMessage("<QS"..QUESTSHARE_VERSION.."> QINFO ["..level.."] "..questTitle..","..isCompleted..","..LastSendLocation);
	end
end

-- Send all current personal quest data to target
function QuestShare_SendAllQuestData()
			local numEntries = GetNumQuestLogEntries();

			for i=1, numEntries, 1 do
				QuestShare_QueueCommCommand("SENDQINFO",i);
			end	 
end

function SendQuestDetails(name,askTitle,askLevel)

	local questID = 0;
	
	for i=1,GetNumQuestLogEntries(),1 do		
		local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(i);
		if (askTitle == GetQuestLogTitle(i) and askLevel == level) then
			questID = i;
		end
	end
		 
	if (questID == 0) then
		return;
	end

	local questTitle = GetQuestLogTitle(questID);
	SelectQuestLogEntry(questID);	
	
	
	if ( not questTitle ) then
		questTitle = "";
	end
	if ( IsCurrentQuestFailed() ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end

	QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QDETAILS title:"..questTitle, "WHISPER", DEFAULT_CHAT_FRAME.language,name);
	QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QDETAILS level:"..askLevel, "WHISPER", DEFAULT_CHAT_FRAME.language, name);
	
	local questDescription;
	local questObjectives;

	questDescription, questObjectives = GetQuestLogQuestText();

	local fullObjectivesText = "<QS"..QUESTSHARE_VERSION.."> QDETAILS objectivetext:"..questObjectives;

	-- Chat length has to be under 256	
	if (string.len(fullObjectivesText) > 220) then
		fullObjectivesText = string.sub(fullObjectivesText,1,220);
	end
	
	QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QDETAILS objectivetext:"..fullObjectivesText, "WHISPER", DEFAULT_CHAT_FRAME.language,name);
	
	local numObjectives = GetNumQuestLeaderBoards();
	for i=1, numObjectives, 1 do
		local text;
		local type;
		local finished;
		text, type, finished = GetQuestLogLeaderBoard(i);
		if ( not text or strlen(text) == 0 ) then
			text = type;
		end
		
		if ( finished ) then
			text = text.." ("..TEXT(COMPLETE)..")";
		end
		
			QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QDETAILS objective:"..text, "WHISPER", DEFAULT_CHAT_FRAME.language, name);
	end

	QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QDETAILS enddetails:", "WHISPER", DEFAULT_CHAT_FRAME.language, name);
	
	SelectQuestLogEntry(QuestShare_LastQuestSelected);	
end

function QuestShare_SendQuestItemUpdateText(message)
	--QuestShare_QueueCommCommand("CHAT", "<QS"..QUESTSHARE_VERSION.."> QPROGRESSUPDATE "..message);
	-- Vjeux : Removed because of spam ... Was it usefull ?
end

function QuestShare_SendQuestUpdateMessage(type, level, questTitle, isCompleted)
	level = level + 0;
	isCompleted = isCompleted + 0;
	
	local completeText = "";
	if (isCompleted == 1) then
	completeText = "complete";
	end
	
	if (type == "update") then
		QuestShare_QueueCommCommand("CHAT", "<QS"..QUESTSHARE_VERSION.."> QINFO ["..level.."] "..questTitle..","..completeText..","..LastUpdateLocation);
	elseif (type == "delete") then
	for i=1,MAX_PARTY_MEMBERS,1 do
		local partyInfo = getglobal("QS_PartyInfo"..i);
		if (partyInfo.name ~= nil and partyInfo.name ~= "") then
				QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QDELETE ["..level.."] "..questTitle..","..completeText, "WHISPER", DEFAULT_CHAT_FRAME.language, partyInfo.name);		  
		end
	end
	end
end

function QuestShare_SendSingleQuestUpdate(id)
	if (id == nil or id > GetNumQuestLogEntries()) then
		return;
	end

	SelectQuestLogEntry(id);						
	local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(id);
	local questTitle = GetQuestLogTitle(id);
	if (isHeader) then
		if ( questLogTitleText ) then
			QuestShare_QueueCommCommand("SET_LAST_UPDATE_LOCATION",questLogTitleText);
		else
			QuestShare_QueueCommCommand("SET_LAST_UPDATE_LOCATION","");
		end
	else
		local isCompleted = QuestShare_GetQuestCompleted(id);
		local found = 0;
		for j=1,table.getn(QuestDataPlayer),1 do
			if (questTitle == QuestDataPlayer[j].title and level == QuestDataPlayer[j].level) then				
				found = 1;
				-- Compare Completion
				if (isCompleted ~= QuestDataPlayer[j].completed) then
					if (isCompleted == 1) then
						if (QuestDataPlayer[j].completeCheck == nil) then
							if (QuestShare_GetQuestNotifyFilter("quest")) then
								local str = format(QS_YOUHAVECOMPLETED, questTitle);
								if ( QuestShare_ShouldShowLevels ) then
									str = str..format(QS_QUEST_LEVEL, level);
								end
								DEFAULT_CHAT_FRAME:AddMessage(str);
								UIErrorsFrame:AddMessage(str, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);			  
							end
							QuestDataPlayer[j].completeCheck = true;
						end
												
						LastCompleteTitle = questTitle;
						LastCompleteLevel = level;							
					end
					
					QuestShare_QueueCommCommand("SET_PLAYER_CHANGES_FLAG",1);	
					QuestShare_QueueCommCommand("SENDUPDATEMESSAGE","update",level,questTitle,isCompleted);				
				end				
			end
		end

		-- Do we have a new quest?
		if (found == 0) then
			QuestShare_QueueCommCommand("SET_PLAYER_CHANGES_FLAG",1);
			QuestShare_QueueCommCommand("SENDUPDATEMESSAGE","update",level,questTitle,isCompleted);	
			--QuestShare_SendQuestUpdateMessage("update",level,questTitle,isCompleted);
		end
	end				
	
	SelectQuestLogEntry(QuestShare_LastQuestSelected);
end

-- This looks for changes in the player's quest data and sends updates to the party
function QuestShare_SendQuestUpdates()

	-- Clear the flag that detects if there are any quest changes
	QuestShare_QueueCommCommand("SET_PLAYER_CHANGES_FLAG",0);
	
	-- look for changes so we don't spam the party with crap :)
	
	local numEntries = GetNumQuestLogEntries();

	for i=1, numEntries, 1 do
		QuestShare_QueueCommCommand("SENDQUPDATE",i);
	end	

	-- Now find quests we've removed
	for j=1,table.getn(QuestDataPlayer),1 do
		local found = 0;
		for i=1, numEntries, 1 do
			local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(i);
			local questTitle = GetQuestLogTitle(i);
			if (isHeader) then
				--
			else
				if (questTitle == QuestDataPlayer[j].title and level == QuestDataPlayer[j].level) then
					found = 1;
				end				
			end	
		end
		
		-- old things to delete... but don't delete locations here
		if (found == 0 and QuestDataPlayer[j].level ~= 0) then
			QuestShare_QueueCommCommand("SET_PLAYER_CHANGES_FLAG",1);
			--QuestShare_SendQuestUpdateMessage("delete",QuestDataPlayer[j].level,QuestDataPlayer[j].title,QuestDataPlayer[j].completed);
			QuestShare_QueueCommCommand("SENDUPDATEMESSAGE","delete",QuestDataPlayer[j].level,QuestDataPlayer[j].title,QuestDataPlayer[j].completed);				
		end		
	end	

	QuestShare_QueueCommCommand("FILLPLAYERQUEST_FINISHED");
end

function FillPlayerQuest(id)
	if (id == nil or id > GetNumQuestLogEntries()) then
		return;
	end
	
	SelectQuestLogEntry(id);						
	local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(id);
	local questTitle = GetQuestLogTitle(id);
	if (isHeader) then
		if ( questLogTitleText ) then
			LastSelfLocation = questLogTitleText;
		else
			LastSelfLocation = nil;
		end
		
		-- Fill location tag
		local loc = {};
		loc.level = 0;
		loc.title = LastSelfLocation;
		loc.completed = 0;
		loc.location = LastSelfLocation;
		table.insert(QuestDataPlayer,loc);
		
		local locFound = false
		for i=1,table.getn(Locations),1 do
			if (Locations[i].name ~= nil and Locations[i].name == LastSelfLocation) then
				locFound = true;
			end
		end
		
		if (locFound == false) then
			local newloc = {};
			newloc.name = LastSelfLocation;
			table.insert(Locations,newloc);
			QuestShare_UpdateLocationFilters();
		end
		
	else
		local value = {};
		value.title = questTitle;
		value.level = level;
		value.completed = QuestShare_GetQuestCompleted(id);
		value.location = LastSelfLocation;
		table.insert(QuestDataPlayer,value);
	end				
	
	SelectQuestLogEntry(QuestShare_LastQuestSelected);
end

-- This fills out the player's quests in the quest share UI
function FillQuestDataPlayer()
	local numEntries = GetNumQuestLogEntries();

	QuestShare_DebugMessage("Refreshing Player Quest Data");

	QuestShare_QueueCommCommand("CLEARPLAYERDATA");		
	
	for i=1, numEntries, 1 do
		QuestShare_QueueCommCommand("FILLPLAYERQUEST",i);
	end			
	
	QuestShare_QueueCommCommand("ENDPLAYERDATAREFRESH");
	QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
end

-- Create the common list, or a list of quests that everyone in the party has
function MakeCommonList()
	-- Go through all lists and find common quests by name
	local QuestDataTemp = {};
	table.setn(QuestDataTemp,0);

	-- First we make a temporary array
	for i=1,table.getn(QuestDataPlayer),1 do
		local val = {};
		val.title = QuestDataPlayer[i].title;
		val.level = QuestDataPlayer[i].level;
		val.completed = QuestDataPlayer[i].completed;
		val.location = QuestDataPlayer[i].location;
		val.filter = QuestDataPlayer[i].filter;
		table.insert(QuestDataTemp,val);
	end
	
	local found = 0;
	local totalQuests = 0;
	local numPartyQuests = 0;
	local completedNum = 0;
	for i=1,table.getn(QuestDataPlayer),1 do
		if (QuestDataPlayer[i].completed == 1) then
			completedNum = 1;
		else
			completedNum = 0;
		end
		
		found = 0;

		for k=1,4,1 do
			local partyName = getglobal("QS_PartyInfo"..k);
			if (partyName.filter == nil or (partyName.filter ~= nil and partyName.filter ~= 0)) then			
				-- Run through the quests to see if we have a match
				numPartyQuests = table.getn(getglobal("QS_QuestDataParty"..k));
				--SendPublishChat(k.." "..numPartyQuests);
				for j=1,numPartyQuests,1 do
					local questData = {};
					questData = getglobal("QS_QuestDataParty"..k);
					if (QuestDataPlayer[i].title == questData[j].title and QuestDataPlayer[i].level == questData[j].level and questData[j].filter == 1) then
						if (questData[j].completed == 1) then
							completedNum = completedNum + 1;
						end

						if (QuestDataTemp[i].commonPeople == nil) then
							QuestDataTemp[i].commonPeople = {};
						end							
						table.insert(QuestDataTemp[i].commonPeople,partyName.name);
						
						found = found + 1;
					end
				end		
				
				-- Don't treat your own quests as group quests if you're solo			
				totalQuests = numPartyQuests + totalQuests;
			end
		end	

		-- if we haven't found a quest at all that's common
		-- then we don't put it in the list
		if (found == 0 and QuestDataPlayer[i].level ~= 0) then
			QuestDataTemp[i].title = "empty";
		end

		QuestDataTemp[i].commonNum = found+1;
		QuestDataTemp[i].completedNum = completedNum;

	end
	
	table.setn(QuestDataCommon,0);

	-- Copy back over
	if (totalQuests > 0) then
		for i=1,table.getn(QuestDataPlayer),1 do
			if (QuestDataTemp[i].title ~= "empty") then
				local val = {};
				val.title = QuestDataTemp[i].title;
				val.level = QuestDataTemp[i].level;
				val.completed = QuestDataTemp[i].completed;
				val.completedNum = QuestDataTemp[i].completedNum;
				val.commonNum = QuestDataTemp[i].commonNum;
				val.location = QuestDataTemp[i].location;
				val.filter = QuestDataTemp[i].filter;
				val.commonPeople = QuestDataTemp[i].commonPeople;
				table.insert(QuestDataCommon,val);	
			end
		end
	end
end

function QuestShare_CountTotalQuests()
	local totalCount = 0;
	if (QuestShareShowFiltersCheck:GetChecked()) then	
		if (HeaderExpand[HEADER_FILTER] == 1 and table.getn(Filters) > 0) then
			totalCount = totalCount + table.getn(Filters) + 1;
		elseif (HeaderExpand[HEADER_FILTER] == 0 and table.getn(Filters) > 0) then
			totalCount = totalCount + 1;
		end
	end
	
	-- Lets count up the total number of things we're gonna show
	if (HeaderExpand[HEADER_COMMON] == 1 and table.getn(QuestDataCommon) > 0) then
		for i=1,table.getn(QuestDataCommon),1 do
			if (QuestDataCommon[i].filter == 1) then
				totalCount = totalCount + 1;
			end			
		end
		totalCount = totalCount + 1;
	elseif (HeaderExpand[HEADER_COMMON] == 0 and table.getn(QuestDataCommon) > 0) then
		totalCount = totalCount + 1;
	end
	
	if (HeaderExpand[HEADER_PLAYER] == 1 and table.getn(QuestDataPlayer) > 0) then
		for i=1,table.getn(QuestDataPlayer),1 do
			if (QuestDataPlayer[i].filter == 1) then
				totalCount = totalCount + 1;
			end
		end
		totalCount = totalCount + 1;
	elseif (HeaderExpand[HEADER_PLAYER] == 0 and table.getn(QuestDataPlayer) > 0) then
		totalCount = totalCount + 1;
	end

		for i=1,4,1 do	
			questData = getglobal("QS_QuestDataParty"..i);
			if  (HeaderExpand[i+HEADER_PLAYER] == 1 and table.getn(questData) > 0) then
				for j=1,table.getn(questData),1 do					
					if (questData[j].filter == 1 or Filters[SHOW_PARTY_FILTER].val ~= nil) then
						totalCount = totalCount + 1;
					end
				end
				totalCount = totalCount + 1;
			elseif (HeaderExpand[i+HEADER_PLAYER] == 0 and table.getn(questData) > 0) then
				totalCount = totalCount + 1;
			end		
		end
	
	return totalCount;
end

-- Main Update loop... lots of nasty logic in here
function QuestShare_Update()
	local numEntries = 0;
	QuestShareExpandButtonFrame:Show();

	-- Update the quest listing
	QuestShareHighlightFrame:Hide();

	if (getglobal("QuestShareTitle1"):IsVisible()) then
		-- Clear our list
		for i=1,SHARE_QUESTS_DISPLAYED,1 do
			local questButton = getglobal("QuestShareTitle"..i);
			questButton:Hide();		
		end
	else
		for i=1,SHARE_QUESTS_DISPLAYED,1 do
			if (i ~= 10) then
				local questButton = getglobal("QuestShareTitle"..i);
				questButton:Hide();		
			end
		end		
	end

	for i=1,SHARE_QUESTS_DISPLAYED,1 do
		local filterCheckButton = getglobal("QuestShareTitleCheck"..i);
		filterCheckButton:Hide();		
	end


	-- Get number of players in party
	local numPlayers = 1;
	
	for i=1,4,1 do
		local partyInfo = getglobal("QS_PartyInfo"..i);
		if (partyInfo.name ~= nil and partyInfo.name ~= "") then
			numPlayers = numPlayers + 1;
		end
	end

	-- Process the filters
	QuestShare_ProcessFilters();
	
	-- Create Common List
	MakeCommonList();

	-- Builds an indexed representation of the UI
	BuildFilterMap();

	-- ScrollFrame update
	
	local totalCount = QuestShare_CountTotalQuests();

	FauxScrollFrame_Update(QuestShareListScrollFrame, totalCount, SHARE_QUESTS_DISPLAYED, QUESTSHARE_QUEST_HEIGHT, QuestShareHighlightFrame, 293, 316 )
	
	local scrollOffset = FauxScrollFrame_GetOffset(QuestShareListScrollFrame);	
	
	local count = 1;
	local color;
	-- Clear the ui list
	table.setn(HeaderCheck,0);
	local playerLevel = UnitLevel("player");
	local showHighlight = false;
	local lastEntry = table.getn(FilterMap);
	local questData;
	local memberName = "";

	if (scrollOffset + 20 < table.getn(FilterMap)) then
		lastEntry = scrollOffset + 20;
	end
	
	for i=scrollOffset+1,lastEntry,1 do
		visIndex = i - scrollOffset; -- visual index into List Box: 1 to 20
		
		-- Index 0 means we're looking at a header
		if (FilterMap[i].index == 0) then
			local questButton = getglobal("QuestShareTitle"..visIndex);

			if (FilterMap[i].type == HEADER_FILTER) then
				questButton:SetText(QS_FILTERS);				
			elseif (FilterMap[i].type == HEADER_COMMON) then
				questButton:SetText(QS_COMMONQUESTS);
			elseif (FilterMap[i].type == HEADER_PLAYER) then
				if (RefreshingPlayerData == true) then
					questButton:SetText(QS_MYQUESTREFRESH);
				else
					questButton:SetText(QS_MYQUEST);
				end
			else
				for j=1,MAX_PARTY_MEMBERS,1 do
					if (FilterMap[i].type == HEADER_PLAYER+j) then
						local partyInfo = getglobal("QS_PartyInfo"..j);						
						memberName = partyInfo.name;
						questButton:SetText(format(QS_XQUESTS,memberName));
					end
				end			
			end
			
			if (HeaderExpand[FilterMap[i].type] == 1) then
				questButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
			else
				questButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
			end
			
			local headerValue = {};
			headerValue.isHeader = 1;
			headerValue.expanded = HeaderExpand[FilterMap[i].type];
			headerValue.headerIndex = FilterMap[i].type;
			table.insert(HeaderCheck,headerValue);

			getglobal("QuestShareTitle"..visIndex.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
			color = QuestDifficultyColor["header"];
			questButton:SetTextColor(color.r, color.g, color.b);
			questButton:Show();
		elseif (FilterMap[i].type == HEADER_FILTER) then
			-- This is an item in the Filters list
				local filter = Filters[FilterMap[i].index];
				
				local headerValue = {};
				headerValue.isHeader = 0;
				headerValue.expanded = 1;
				headerValue.headerIndex = HEADER_FILTER;
				headerValue.dataIndex = FilterMap[i].index;
				table.insert(HeaderCheck,headerValue);

				local filterButton = {};
				
				if (filter.type ~= "label") then
					color = QuestDifficultyColor["header"];

					if (filter.name ~= nil) then
						if (filter.name == "easydiff") then
							color = QuestDifficultyColor["trivial"];
						elseif (filter.name == "standarddiff") then 
							color = QuestDifficultyColor["standard"];
						elseif (filter.name == "harddiff") then 
							color = QuestDifficultyColor["difficult"];
						elseif (filter.name == "veryharddiff") then 
							color = QuestDifficultyColor["verydifficult"];
						elseif (filter.name == "impossiblediff") then 
							color = QuestDifficultyColor["impossible"];
						end					
					end					

					filterButton = getglobal("QuestShareTitle"..visIndex);
					filterButton:SetText(filter.title);
					filterButton:SetNormalTexture("");
					getglobal("QuestShareTitle"..visIndex.."Highlight"):SetTexture("");					
					checkButton = getglobal("QuestShareTitleCheck"..visIndex);
					checkButton:SetChecked(filter.val);
					checkButton:Show();			
				else
					color = { r=0.7, g=0.7, b=1.0 };
					
					filterButton = getglobal("QuestShareTitle"..visIndex);
					filterButton:SetText("-- "..filter.title.." --");					
					filterButton:SetNormalTexture("");
					getglobal("QuestShareTitle"..visIndex.."Highlight"):SetTexture("");					
				end					
				
				filterButton:SetTextColor(color.r, color.g, color.b);
				filterButton:Show();				
			
		else
			-- First lets get the quest we're looking at:		
			if (FilterMap[i].type == HEADER_COMMON) then
				questData = QuestDataCommon[FilterMap[i].index];
			elseif (FilterMap[i].type == HEADER_PLAYER) then			
				-- This is an item in the Player's list
				questData = QuestDataPlayer[FilterMap[i].index];
			else
				-- This is an item in the Party List
				for j=1,MAX_PARTY_MEMBERS,1 do
					if (FilterMap[i].type == HEADER_PLAYER+j) then
						local partyList = getglobal("QS_QuestDataParty"..j);
						questData = partyList[FilterMap[i].index];
					end
				end
			end
			
			-- Now lets process it
			local level = questData.level;
			local playerLevel = UnitLevel("player");
			local levelDiff = level - playerLevel;
			if ( isHeader ) then
				color = QuestDifficultyColor["header"];
			elseif ( levelDiff >= 5 ) then
				color = QuestDifficultyColor["impossible"];
			elseif ( levelDiff >= 3 ) then
				color = QuestDifficultyColor["verydifficult"];
			elseif ( levelDiff >= -2 ) then
				color = QuestDifficultyColor["difficult"];
			elseif ( level >= (playerLevel * 0.75) ) then
				color = QuestDifficultyColor["standard"];
			else
				color = QuestDifficultyColor["trivial"];
			end

			-- Special case for Common Quests (show completion message)
			if (FilterMap[i].type == HEADER_COMMON and questData.completedNum == numPlayers) then
				if (questData.level == LastCompleteLevel and questData.title == LastCompleteTitle) then
					if (QuestShare_GetQuestNotifyFilter("quest")) then
						DEFAULT_CHAT_FRAME:AddMessage(format(QS_PARTYCOMPLETED, LastCompleteTitle, LastCompleteLevel));
						UIErrorsFrame:AddMessage(format(QS_PARTYCOMPLETED, LastCompleteTitle, LastCompleteLevel), 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);			  
					end
					LastCompleteLevel = 0;
					LastCompleteTitle = "";
				end
			end
							
			-- We're showing a location
			if (questData.level == 0 and questData.location ~= nil) then
				questButton = getglobal("QuestShareTitle"..visIndex);
				questButton:SetText(questData.location..":");					
				questButton:SetNormalTexture("");
				questButton:SetTextColor(0.5,0.5,0.5);
				questButton:Show();
				
				lastLocation = questData.location;
				
				local itemValue = {};
				itemValue.isHeader = 1;
				itemValue.expanded = 1;
				itemValue.headerIndex = HEADER_LOCATION;
				table.insert(HeaderCheck,itemValue);									
			else
			
			-- Here we show a regular quest item
				local itemValue = {};
				itemValue.isHeader = 0;
				itemValue.expanded = 1;
				itemValue.headerIndex = FilterMap[i].type;
				table.insert(HeaderCheck,itemValue);

				-- Common Quests
				if (FilterMap[i].type == HEADER_COMMON) then
					questButton = getglobal("QuestShareTitle"..visIndex);
					questButton:SetText("  ["..questData.level.."] "..questData.title.." ("..questData.completedNum.."/"..questData.commonNum..")");					
					questButton:SetNormalTexture("");
					getglobal("QuestShareTitle"..visIndex.."Highlight"):SetTexture("");
				else
					questButton = getglobal("QuestShareTitle"..visIndex);
					if (questData.completed == 1) then					
						questButton:SetText("  ["..questData.level.."] "..questData.title.." ("..TEXT(COMPLETE)..")");
					else
						questButton:SetText("  ["..questData.level.."] "..questData.title);
					end
				end
				
				questButton:SetNormalTexture("");
				getglobal("QuestShareTitle"..visIndex.."Highlight"):SetTexture("");
				questButton:SetTextColor(color.r, color.g, color.b);
				questButton:Show();
				if ( QuestShareFrame.selectedButtonID == visIndex ) then
					QuestShareHighlightFrame:SetPoint("TOPLEFT", "QuestShareTitle"..visIndex, "TOPLEFT", 0, 0);
					QuestShareHighlight:SetVertexColor(color.r,color.g,color.b);
					QuestShareHighlightFrame:Show();		
					questButton:LockHighlight();
					showHighlight = true;
				else
					questButton:UnlockHighlight();
				end
			end
			
		end
	end
	
	if (showHighlight == false) then
		QuestShareHighlightFrame:Hide();		
	end
	-- Set the expand/collapse all button texture
	-- If all headers are not expanded then show collapse button, otherwise show the expand button
	local allCollapsed = true;
	
	for i=1,table.getn(HeaderExpand),1 do
		if (HeaderExpand[i] ~= 0) then
			allCollapsed = false;
		end
	end
	
	if ( allCollapsed ) then
		QuestShareCollapseAllButton.collapsed = 1;
		QuestShareCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	else
		QuestShareCollapseAllButton.collapsed = nil;
		QuestShareCollapseAllButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	end

end


-- QuestPublisher v2 - mgorecki 3/6/04
-- This function sends a Quest info to specific channels/whispers/party/guildsay
function SendPublishChat(text)
		if ( DEFAULT_CHAT_FRAME.editBox.allStickyType == "WHISPER") then
			SendChatMessage(text, DEFAULT_CHAT_FRAME.editBox.allStickyType, DEFAULT_CHAT_FRAME.language, DEFAULT_CHAT_FRAME.editBox.tellTarget);
		elseif ( DEFAULT_CHAT_FRAME.editBox.allStickyType  == "CHANNEL") then
			SendChatMessage(text, DEFAULT_CHAT_FRAME.editBox.allStickyType, DEFAULT_CHAT_FRAME.language, DEFAULT_CHAT_FRAME.editBox.channelTarget);
		else
			SendChatMessage(text, DEFAULT_CHAT_FRAME.editBox.allStickyType, DEFAULT_CHAT_FRAME.language);
		end
end

function QuestShare_FilterClick()
	Filters[HeaderCheck[this:GetID()].dataIndex].val = this:GetChecked();
	if (Filters[HeaderCheck[this:GetID()].dataIndex].type ~= "partymember" and Filters[HeaderCheck[this:GetID()].dataIndex].type ~= "loc") then
		Cosmos_RegisterCVar(Filters[HeaderCheck[this:GetID()].dataIndex].name, 1);
		Cosmos_SetCVar(Filters[HeaderCheck[this:GetID()].dataIndex].name,Filters[HeaderCheck[this:GetID()].dataIndex].val);
	end
	QuestShare_Update();
end

function QuestShare_SetSelection(id, button)
	-- If no quest selected choose first available
	local selectedQuest;

	-- Set newly selected quest and highlight it
	QuestShareFrame.selectedButtonID = id;

	-- Add offset to the id
	local questID = id + FauxScrollFrame_GetOffset(QuestShareListScrollFrame);
	local questButton = getglobal("QuestShareTitle"..id);
	
	-- Clicked on Filter name, so lets set check box
	if (table.getn(HeaderCheck) >= id and HeaderCheck[id].isHeader == 0) then
		if (HeaderCheck[id].headerIndex == HEADER_FILTER) then
			if (Filters[HeaderCheck[id].dataIndex].type == "label") then
				QuestShare_ToggleFilterSection(id);
				return;
			end
			
			-- Lets set the checkbox
			local checkButton = getglobal("QuestShareTitleCheck"..id);
			if (checkButton:GetChecked()) then
				checkButton:SetChecked(nil);
				Filters[HeaderCheck[id].dataIndex].val = nil;
			else
				checkButton:SetChecked(1);
				Filters[HeaderCheck[id].dataIndex].val = 1;
			end
			
			if (Filters[HeaderCheck[id].dataIndex].type ~= "partymember" and Filters[HeaderCheck[id].dataIndex].type ~= "loc") then
				Cosmos_RegisterCVar(Filters[HeaderCheck[id].dataIndex].name, 1);
				Cosmos_SetCVar(Filters[HeaderCheck[id].dataIndex].name,Filters[HeaderCheck[id].dataIndex].val);
			end
			
			return;
		end
	end
	
	if (table.getn(HeaderCheck) >= id and HeaderCheck[id].isHeader == 1) then
	
		-- Clicked on a location
		if (HeaderCheck[id].headerIndex == HEADER_LOCATION) then
			return;
		end
			
		local expand = 0;
		if (HeaderCheck[id].expanded == 0) then
			expand = 1;
		end

		HeaderExpand[HeaderCheck[id].headerIndex] = expand;		
		
	elseif ( id <= SHARE_QUESTS_DISPLAYED) then
			questButton:LockHighlight();
			local color = QuestDifficultyColor["difficult"];
			QuestShareHighlightFrame:Show();
			QuestShareHighlight:SetVertexColor(color.r,color.g,color.b);
			QuestShare_ProcessSelectedQuest(button);
			ShowUIPanel(QuestLogFrame);
			--QuestShareHighlightFrame:SetPoint("TOPLEFT", "QuestShareTitle"..id, "TOPLEFT", 5, 0);
	end
	
	QuestShare_QueueCommCommand("QUESTSHAREUPDATE");
end

function QuestShareTitleButton_OnClick(button)
		QuestShare_SetSelection(this:GetID(),button)
		QuestShare_Update();
end

function QuestShareCollapseAllButton_OnClick(button)
		if (this.collapsed) then
			this.collapsed = nil;
			for i=1,table.getn(HeaderExpand),1 do
				HeaderExpand[i] = 1;
			end
		else
			this.collapsed = 1;
			QuestShareListScrollFrameScrollBar:SetValue(0);
			for i=1,table.getn(HeaderExpand),1 do
				HeaderExpand[i] = 0;
			end
		end

	QuestShare_Update();
end

function QuestShare_GetFirstSelectableQuest()
	return 1;
end

function QuestShareTitleCheck_OnLoad()
	-- Set the CVar for this filter
end

function GetNumQuestShareEntries()
	local count = table.getn(QuestShareData);
	return count;
end

function QuestShare_GetQuestCompleted(id)

	-- Stop collisions
	if (QuestShare_QuestDetails_InProcess == true) then	
		return 0;
	end	

	-- Make sure QS is loaded before doing completion updates
	if (QuestShareFirstLoad == 0) then
		return 0;
	end
	
	-- SelectQuestLogEntry() is a global function, so we need to encase it in a check
	QuestShare_QuestDetails_InProcess = true;
	
	SelectQuestLogEntry(id);						
	local questTitle = GetQuestLogTitle(id);
	local numObjectives = GetNumQuestLeaderBoards();
	local i = 0;
	
	local allFinished = 1;

	if (numObjectives == 0) then
		QuestShare_QuestDetails_InProcess = false;
		SelectQuestLogEntry(QuestShare_LastQuestSelected);
		return 0;
	end
	
	for i=1, numObjectives, 1 do
		local text = "";
		local type = "";
		local finished = false;
		text, type, finished = GetQuestLogLeaderBoard(i);

		if (not finished ) then
			allFinished = 0;
		end
	end
	

	QuestShare_QuestDetails_InProcess = false;
	
	SelectQuestLogEntry(QuestShare_LastQuestSelected);
	return allFinished;
end

function QuestShare_UpdateQuestDetails()

	if (DetailTitle == "") then
	 return;
	end

	local questTitle = DetailTitle;
	QuestLogHighlightFrame:Hide();

	QuestLogQuestTitle:SetText(format(QS_QSQUEST, questTitle));

	local questDescription;
	local questObjectives;
	questObjectives = DetailObjectivesText;
	
	QuestLogObjectivesText:SetText(questObjectives);
	
	local questTimer = 0;
	QuestLogFrame.hasTimer = nil;
	QuestLogTimerText:Hide();
	QuestLogObjective1:SetPoint("TOPLEFT", "QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
	
	local count = 0;	

	--SendChatMessage(MAX_OBJECTIVES.." max","SAY",DEFAULT_CHAT_FRAME.language,"");
	
	for i=0,MAX_PARTY_MEMBERS,1 do
		-- player first
		if (i == 0 and table.getn(QS_DetailObjectivesList0) > 0 and count < MAX_OBJECTIVES) then
			count = 1;
			local objectivesList = QS_DetailObjectivesList0;
			local numObjectives = table.getn(objectivesList);
			local string = getglobal("QuestLogObjective"..count);
			local text = format(QS_XOBJ, UnitName("player"));
			string:SetTextColor(0.0, 0, 0.5);
--			SendChatMessage(count.." player","SAY",DEFAULT_CHAT_FRAME.language,"");

			string:SetText(text);
			string:Show();
			QuestFrame_SetAsLastShown(string);
			
			for j=1, numObjectives, 1 do
				count=count+1;
				
--				SendChatMessage(count.." playerObj","SAY",DEFAULT_CHAT_FRAME.language,"");
				if (count > MAX_OBJECTIVES) then
					break;
				end
				
				local string = getglobal("QuestLogObjective"..count);
				local text;
				local finished = false;
				text = objectivesList[j];

				string:SetTextColor(0, 0, 0);

				string:SetText(text);
				string:Show();
				QuestFrame_SetAsLastShown(string);				
			end			
		else
			objectivesList = getglobal("QS_DetailObjectivesList"..i);
--			SendChatMessage("Party member "..i.." has "..table.getn(objectivesList).." objectives","SAY",DEFAULT_CHAT_FRAME.language,"")
			if (table.getn(objectivesList) > 0 and count < MAX_OBJECTIVES) then
				count = count + 1;
				local partyInfo = getglobal("QS_PartyInfo"..i);
				if (partyInfo.name ~= nil and partyInfo.name ~= "") then
					--local objectivesList = getglobal("QS_DetailObjectivesList"..i);
					
--					SendChatMessage(count.." party","SAY",DEFAULT_CHAT_FRAME.language,"");
					local string = getglobal("QuestLogObjective"..count);
					local text = format(partyInfo.name, UnitName("player"));
					string:SetTextColor(0.0, 0, 0.5);

					string:SetText(text);
					string:Show();
					QuestFrame_SetAsLastShown(string);
					
					
					local numObjectives = table.getn(objectivesList);
					for j=1, numObjectives, 1 do
						count=count+1;
						
--						SendChatMessage(count.." partyObj","SAY",DEFAULT_CHAT_FRAME.language,"");
						if (count > MAX_OBJECTIVES) then
							break;
						end
						local string = getglobal("QuestLogObjective"..count);
						local text;
						local finished = false;
						text = objectivesList[j];

						string:SetTextColor(0, 0, 0);

						string:SetText(text);
						string:Show();
						QuestFrame_SetAsLastShown(string);
					end
				end			
			end
		end
	end

	for i=count+1, MAX_OBJECTIVES, 1 do
		getglobal("QuestLogObjective"..i):Hide();
	end
	
	if ( count > 0 and count <= MAX_OBJECTIVES) then
			QuestLogDescriptionTitle:SetPoint("TOPLEFT", "QuestLogObjective"..count, "BOTTOMLEFT", 0, -10);
	else
		if ( questTimer ) then
			QuestLogDescriptionTitle:SetPoint("TOPLEFT", "QuestLogTimerText", "BOTTOMLEFT", 0, -10);
		else
			QuestLogDescriptionTitle:SetPoint("TOPLEFT", "QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
	end
	QuestLogDescriptionTitle:Hide();
	QuestLogQuestDescription:SetText("");
	QuestFrame_SetAsLastShown(QuestLogQuestDescription);

	QuestLogRewardTitleText:Hide();
	
	QuestFrameItems_Update("QuestLog");
	QuestLogDetailScrollFrameScrollBar:SetValue(0);
	QuestLogDetailScrollFrame:UpdateScrollChildRect();
end

function QuestShare_PublishQuest(title, level, button)
		local id = FindMyQuestIndex(title,level);
		
		if (button == "RightButton") then
			local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(id);

			local questTitle = GetQuestLogTitle(id);
			
			SendPublishChat("[".. level .. "]" .. questTitle);

			if (questTag) then
				SendPublishChat(" ("..questTag..")");
			end
	
			if ( IsShiftKeyDown()) then
				local numObjectives = GetNumQuestLeaderBoards();
				SendPublishChat(format(QS_NBOBJ, numObjectives));
				
				for j=1, numObjectives, 1 do
					local string = getglobal("QuestLogObjective"..j);
					local text;
					local type;
					local finished;
					text, type, finished = GetQuestLogLeaderBoard(j);
					if ( not text or strlen(text) == 0 ) then
						text = type;
					end
					if ( finished ) then
						string:SetTextColor(0.2, 0.2, 0.2);
						text = text.." ("..TEXT(COMPLETE)..")";
					else
						string:SetTextColor(0, 0, 0);
					end
					
					SendPublishChat(text);
				end
			end
					
		end

		return;
end

function QuestShare_ProcessSelectedQuest(button)
	-- First we need to find out which section the quest is in
	index = QuestShareFrame.selectedButtonID + FauxScrollFrame_GetOffset(QuestShareListScrollFrame);
		
	local questData = {};
	local found = 0;
	local count = 0;
	local name = "";
	
	--QuestShare_DebugMessage("Selecting Vis index: "..index.." Quest Type: "..FilterMap[index].type.." Index: "..FilterMap[index].index);
	
	if (FilterMap[index].type == HEADER_FILTER) then
		found = 1;
		questData = Filters[FilterMap[index].index];
		name = "";
	elseif (FilterMap[index].type == HEADER_COMMON) then
		found = 1;
		questData = QuestDataCommon[FilterMap[index].index];
		name = "common";
		QuestShare_PublishQuest(questData.title,questData.level,button);
	elseif (FilterMap[index].type == HEADER_PLAYER) then
		-- Find Quest Index in personal log
		found = 1;
		questData = QuestDataPlayer[FilterMap[index].index];
		QuestLogHighlightFrame:Hide();
		
		local id = FindMyQuestIndex(questData.title,questData.level);
		
		SelectQuestLogEntry(id);
		QuestLog_SetSelection(id);
		QuestLog_UpdateQuestDetails();
		QuestLog_Update();
		
		QuestShare_PublishQuest(questData.title,questData.level,button);
		return;
	else
		for i=1,MAX_PARTY_MEMBERS,1 do
			if (FilterMap[index].type == HEADER_PLAYER+i) then
				partyData = getglobal("QS_QuestDataParty"..i);
				questData = partyData[FilterMap[index].index];
				found = 1;
				partyInfo = getglobal("QS_PartyInfo"..i);
				name = partyInfo.name;
			end
		end		
	end
	
	if (found == 0) then
		return;
	end
	
	local isComplete = "";
	
	if (questData.completed == 1) then
		isComplete = "complete";
	end

	if (name ~= "") then
		DetailName = "";
		DetailLevel = 0;
		DetailObjectiveText = "";			
		table.setn(QS_DetailObjectivesList0,0);
		for i=1,MAX_PARTY_MEMBERS,1 do
			local partyInfo = getglobal("QS_PartyInfo"..i);
			if (partyInfo.name ~= nil and partyInfo.name ~= "") then
				local objectivesList = getglobal("QS_DetailObjectivesList"..i);
				table.setn(objectivesList,0);
			end
		end

		QuestLogDescriptionTitle:Hide();
		QuestLogQuestDescription:SetText("");
		QuestFrame_SetAsLastShown(QuestLogQuestDescription);

		QuestLogRewardTitleText:Hide();

		--QuestFrameItems_Update("QuestLog");
		QuestLogDetailScrollFrameScrollBar:SetValue(0);
		QuestLogDetailScrollFrame:UpdateScrollChildRect();
	end
	
	if (name == "common") then

		QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QGETDETAIL ["..questData.level.."] "..questData.title..","..isComplete, "WHISPER", DEFAULT_CHAT_FRAME.language, UnitName("player"));				
	
		for i=1, MAX_PARTY_MEMBERS, 1 do
				local tempPartyInfo = getglobal("QS_PartyInfo"..i);
				if (tempPartyInfo.name ~= nil and tempPartyInfo.name ~= "") then
					QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QGETDETAIL ["..questData.level.."] "..questData.title..","..isComplete, "WHISPER", DEFAULT_CHAT_FRAME.language, tempPartyInfo.name);				
				end
		end	
	elseif (name ~= "") then
	
		QuestShare_QueueCommCommand("WHISPER","<QS"..QUESTSHARE_VERSION.."> QGETDETAIL ["..questData.level.."] "..questData.title..","..isComplete, "WHISPER", DEFAULT_CHAT_FRAME.language, name);
	end
	
end

function QuestShare_SetItemToolTip(item)
	local index = item:GetID() + FauxScrollFrame_GetOffset(QuestShareListScrollFrame);

	if (index == nil) then
		return;
	end
	
	if (HeaderExpand[HEADER_COMMON] == 0 or table.getn(QuestDataCommon) == 0) then
		return;
	end

	if (FilterMap[index].type ~= HEADER_COMMON) then
		return;
	end
	
	if (FilterMap[index].index == 0) then
		return;
	end	
	
	local questData = QuestDataCommon[FilterMap[index].index];

	if (questData.commonPeople == nil) then
		return;
	end
	
	if (questData.level == 0) then
		return;
	end
	
	local status = QS_WHOELSE;
	
	for i=1,table.getn(questData.commonPeople),1 do
		status = status.."\n"..questData.commonPeople[i];
	end
	
	if (questData.completedNum == 1) then
		status = format(QS_STNOCOMPLETED, status, questData.completedNum);
	elseif (questData.completedNum == 0) then
		status = format(QS_STNOONECOMPLETED, status);
	elseif (questData.completedNum == questData.commonNum) then
		status = format(QS_STALLCOMPLETED, status);
	else
		status = format(QS_STXCOMPLETED, status, questData.completedNum);
	end

	
	CosmosTooltip:SetOwner(item,"ANCHOR_RIGHT");	
	CosmosTooltip:SetText(status, 0.8, 0.8, 1.0);
end

function FindMyQuestIndex(askTitle, askLevel)
	local numEntries = GetNumQuestLogEntries();
	local playerLevel = UnitLevel("player");
	for i=1, numEntries, 1 do
		SelectQuestLogEntry(i);						
		local questLogTitleText, level, questTag, isHeader, isCollapsed = GetQuestLogTitle(i);
		local questTitle = GetQuestLogTitle(i);
		if (isHeader) then
				--SendPublishChat("All Quests in ".. questTitle.. ": ");
		else
			if (askTitle == questTitle and askLevel == level) then
				SelectQuestLogEntry(QuestShare_LastQuestSelected);
				return i;
			end
		end
	end				
 
end

-- Filters (Quest Share v2.5)
function QuestShare_ToggleFilterSection(id)
	local foundEnd = false;
	local x = id;
	for i=HeaderCheck[id].dataIndex,table.getn(Filters),1 do
		x=x+1;
		if (i~=HeaderCheck[id].dataIndex) then
			if (foundEnd == false and Filters[i].type ~= "label") then		
				checkButton = getglobal("QuestShareTitleCheck"..x);
				checkButton:SetChecked(ToggleCheckValue);
				Filters[i].val = ToggleCheckValue;
				if (Filters[i].type ~= "partymember" and Filters[i].type ~= "loc") then
					Cosmos_RegisterCVar(Filters[i].name, 1);
					Cosmos_SetCVar(Filters[i].name,Filters[i].val);
					QuestShare_DebugMessage("Filter name: "..Filters[i].name.. " set to: "..Filters[i].val);
				end
			elseif (foundEnd == false) then
				foundEnd = true;
			end
		end
	end
	
	if (ToggleCheckValue == nil) then
		ToggleCheckValue = 1;
	else
		ToggleCheckValue = nil;
	end

	QuestShare_Update();			
end

-- Fills up the Filters data structure with values
function QuestShare_InitializeFilters()
	-- Clear the table
	table.setn(Filters,0);

	-- Party Filter Header
	local newFilter = {};
	newFilter.type = "label";
	newFilter.val = 1;
	newFilter.title = QS_FILTER_PARTY;
	table.insert(Filters,newFilter);
	
	-- Add Show all party members filter
	local newFilter = {};
	newFilter.type = "party";
	newFilter.name = "showpartymembers";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	
	newFilter.title = QS_FILTER_ALLPARTY;
	
	table.insert(Filters,newFilter);	

	-- Location Filter Header
	local newFilter = {};
	newFilter.type = "label";
	newFilter.val = 1;
	newFilter.title = QS_FILTER_LOCATION;
	table.insert(Filters,newFilter);

	-- Add Show location titles filter
	local newFilter = {};
	newFilter.type = "showloc";
	newFilter.name = "showloctitles";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_SHOWLOCATION;
	
	table.insert(Filters,newFilter);	

	-- Add Filter Header for Quest Difficulty
	local newFilter = {};
	newFilter.type = "label";
	newFilter.val = 1;
	newFilter.title = QS_FILTER_DIFF;	
	table.insert(Filters,newFilter);	

	-- Add Easy Difficulty checkbox
	local newFilter = {};
	newFilter.type = "diff";
	newFilter.name = "easydiff";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_DIFFTRIVIAL;	
	table.insert(Filters,newFilter);	

	-- Add standard Difficulty checkbox
	local newFilter = {};
	newFilter.type = "diff";
	newFilter.name = "standarddiff";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_DIFFSTANDART;	
	table.insert(Filters,newFilter);	

	-- Add Hard Difficulty checkbox
	local newFilter = {};
	newFilter.type = "diff";
	newFilter.name = "harddiff";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_DIFFDIFF;
	table.insert(Filters,newFilter);	

	-- Add Very Hard Difficulty checkbox
	local newFilter = {};
	newFilter.type = "diff";
	newFilter.name = "veryharddiff";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_DIFFVERYDIFF;	
	table.insert(Filters,newFilter);	

	-- Add Impossible Difficulty checkbox
	local newFilter = {};
	newFilter.type = "diff";
	newFilter.name = "impossiblediff";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_DIFFIMPOSSIBLE;	
	table.insert(Filters,newFilter);	

	-- Add Filter Header for Completion Notices
	local newFilter = {};
	newFilter.type = "label";
	newFilter.val = 1;
	newFilter.title = QS_FILTER_PROGNOTICES;
	table.insert(Filters,newFilter);	

	-- Add Quest Completion checkbox
	local newFilter = {};
	newFilter.type = "progress";
	newFilter.name = "quest";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_PROGNOTICES_QUECOMP;
	table.insert(Filters,newFilter);	

	-- Add Objective Completion checkbox
	local newFilter = {};
	newFilter.type = "progress";
	newFilter.name = "objective";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_PROGNOTICES_OBJCOMP;	
	table.insert(Filters,newFilter);	

	-- Add Objective Count checkbox
	local newFilter = {};
	newFilter.type = "progress";
	newFilter.name = "count";
	Cosmos_RegisterCVar(newFilter.name, 1);
	local checkboxVal = Cosmos_GetCVar(newFilter.name);
	if (checkboxVal == "0") then
		newFilter.val = nil;
	else
		newFilter.val = 1;
	end
	newFilter.title = QS_FILTER_PROGNOTICES_OBJPROG;	
	table.insert(Filters,newFilter);	

	-- Add Filter Header for end of filters
	local newFilter = {};
	newFilter.type = "label";
	newFilter.val = 1;
	newFilter.title = QS_FILTER_EOF;
	table.insert(Filters,newFilter);		
end

function QuestShare_GetQuestNotifyFilter(name)
	for i=1,table.getn(Filters),1 do
		if (Filters[i].type == "progress" and Filters[i].name == name) then
			return Filters[i].val;			
		end
	end
	
	return nil;
end

-- Updates filters for party members
function QuestShare_UpdatePartyFilter(playerid)
	if (Filters == nil or table.getn(Filters) == 0) then
		return;
	end
	
	local startParty = 0;
	for i=1,table.getn(Filters),1 do
		if (Filters[i].type == "party") then
			startParty = i;
		end
	end
	
	-- Lets go through the party and add/remove filters as necessary
	partyMember = getglobal("QS_PartyInfo"..playerid);
	if (partyMember.name ~= nil and partyMember.name ~= "") then
		if (table.getn(Filters) >= startParty+playerid) then
			if (Filters[startParty+playerid].type == "partymember" and Filters[startParty+playerid].name ~= partyMember.name) then
				local val = Filters[startParty+playerid];
				val.type = "partymember";
				val.val = Filters[SHOW_PARTY_FILTER].val;
				val.name = partyMember.name;
				val.title = format(QS_SHOWXQUESTS, partyMember.name);
			elseif (Filters[startParty+playerid].type ~= "partymember") then
				local val = {};
				val.type = "partymember";
				if (SHOW_PARTY_FILTER > 0) then
					val.val = Filters[SHOW_PARTY_FILTER].val;
				else
					val.val = 1;
				end
				val.name = partyMember.name;
				val.title = format(QS_SHOWXQUESTS, partyMember.name);
				table.insert(Filters,startParty+playerid,val);
			end			
		else
				local val = {};
				val.type = "partymember";
				val.val = Filters[SHOW_PARTY_FILTER].val;
				val.name = partyMember.name;
				val.title = format(QS_SHOWXQUESTS, partyMember.name);
				table.insert(Filters,val);		
		end
	end
end

-- Clears filters for party members
function QuestShare_ClearPartyFilters()
	local startParty = 0;
	local i = 1;
	while (i <= table.getn(Filters)) do
		if (Filters[i] ~= nil and Filters[i].type ~= nil and Filters[i].type == "partymember") then
			table.remove(Filters,i);
		else
			i = i + 1;
		end
	end	
end

function QuestShare_RemoveFilterPlayer(playerid)
	local startParty = 0;
	for i=1,table.getn(Filters),1 do
		if (Filters[i].type == "party") then
			startParty = i;
		end
	end
	
	-- Lets go through the party and add/remove filters as necessary
	partyMember = getglobal("QS_PartyInfo"..playerid);
	if (partyMember.name ~= nil and partyMember.name ~= "") then
		if (table.getn(Filters) >= startParty+playerid) then
			if (Filters[startParty+playerid].type == "partymember" and Filters[startParty+playerid].name ~= partyMember.name) then
				table.remove(Filters,startParty+playerid);
			end			
		end
	end	
end

-- Updates filters for locations
function QuestShare_UpdateLocationFilters()
	if (Filters == nil or table.getn(Filters) == 0) then
		return;
	end

	local startLocation = 0;
	for i=1,table.getn(Filters),1 do
		if (Filters[i].type == "showloc") then
			startLocation = i+1;
		end
	end

	for i=1,table.getn(Locations),1 do
		local locFound = false;
		local endLocation = startLocation;
		local doneLocs = false;
		
		-- go through filters looking for new locations to add
		for j=startLocation,table.getn(Filters),1 do
			if (Filters[j].type == "loc" and Filters[j].name == Locations[i].name) then
				locFound = true;
			elseif (Filters[j].type ~= "loc" and doneLocs == false) then
				endLocation = j;
				doneLocs = true;
			end	
		end
		
		-- add a new location to the filter
		if (locFound == false) then
			local loc = {};
			loc.name = Locations[i].name;
			loc.type = "loc";
			loc.title = format(QS_SHOWLOCQUESTS, Locations[i].name);
			loc.val = 1; -- default to showing location
			
			table.insert(Filters,endLocation,loc);
		end
	end	
	
	-- delete old locations
	for i=startLocation,table.getn(Filters),1 do
		if (Filters[i].type == "loc") then		
			local locFound = false;
			for j=1,table.getn(Locations),1 do
					if (Filters[i].name == Locations[j].name) then
						locFound = true;
					end
			end	
			
			if (locFound == false) then
				Filters[i].name = "old";
			end
		end
	end
	
	local j = 1;
	while (j <= table.getn(Filters)) do
		if (Filters[j].name == "old") then
			table.remove(Filters,j);
		else
			j = j + 1;
		end
	end
end

-- Processes the Quest Data through the filters (Happens every QuestShare_Update())
function QuestShare_ProcessFilters()
	if (QuestShareFirstLoad == 0) then
	return;
	end
	
	-- Run through each list
	-- first we clear everyone's filter flags
	for i=1,7,1 do
		local questData;
		local numQuests = 0;
		local name;
		
		if (i==1) then
			-- Do nothing for filters
		elseif (i==2) then
			-- For common quests		
			questData = QuestDataCommon;
			numQuests = table.getn(questData);
			name = "common";
		elseif (i==3) then
			questData = QuestDataPlayer;
			numQuests = table.getn(questData);
			name = UnitName("player");			
		else
			-- For party quests
			questData = getglobal("QS_QuestDataParty"..i-3);
			numQuests = table.getn(questData);
			local partyName = getglobal("QS_PartyInfo"..i-3);
			name = partyName.name;
			-- clear party member filters		
			partyName.filter = 0;
		end
	
		if (numQuests > 0 and name ~= nil and name ~= "") then		
			for j=1,numQuests,1 do					
				questData[j].filter = 0; -- turn off filter
			end
		end
	end

	for filtNum=1,table.getn(Filters),1 do
		
		if (Filters[filtNum].type == "party") then
			SHOW_PARTY_FILTER = filtNum;
		end

		if (Filters[filtNum].type ~= "label") then
			for i=1,7,1 do
				local questData;
				local numQuests = 0;
				local name;
				
				if (i==1) then
					-- Do nothing for filters
				elseif (i==2) then
					-- For common quests		
					questData = QuestDataCommon;
					numQuests = table.getn(questData);
					name = "common";
				elseif (i==3) then
					-- For player quests
					questData = QuestDataPlayer;
					numQuests = table.getn(questData);
					name = UnitName("player");			
				else
					-- For party quests
					questData = getglobal("QS_QuestDataParty"..i-3);
					numQuests = table.getn(questData);
					local partyName = getglobal("QS_PartyInfo"..i-3);
					name = partyName.name;
					
					if (partyName ~= nil and partyName.name ~= nil and partyName.name ~= "") then
						-- show all party members
						if (Filters[SHOW_PARTY_FILTER].val ~= nil) then
							partyName.filter = 1;
						end
						
						if (Filters[filtNum].type == "partymember" and Filters[filtNum].val ~= nil and Filters[filtNum].name == name) then
							partyName.filter = 1;
						end
					end
				end
			
				if (numQuests > 0 and name ~= nil and name ~= "") then
					for j=1,numQuests,1 do					
						
						if (questData[j].level ~= 0) then
						
							-- lets check difficulty
							-- 1 = easy, 2 = standard, 3 = hard, 4 = very hard
							local diff = "easydiff";							
							local level = questData[j].level;
							local playerLevel = UnitLevel("player");

							local levelDiff = level - playerLevel;
							if ( levelDiff >= 5 ) then
								diff = "impossiblediff";
							elseif ( levelDiff >= 3 ) then
								diff = "veryharddiff";
							elseif ( levelDiff >= -2 ) then
								diff = "harddiff";
							elseif ( level >= (playerLevel * 0.75) ) then
								diff = "standarddiff";
							else
								diff = "easydiff";
							end
							
							-- for now, show all common and player quests
							--if (i == 3 or i == 2) then
							--	questData[j].filter = 1;
							--end					
							
							if ((i == 3) and Filters[filtNum].type == "loc" and Filters[filtNum].val ~= nil and questData[j].location ~= nil and questData[j].location == Filters[filtNum].name) then
								questData[j].filter = 1;
							end
						
							-- Always show all common quests
							if (i == 2) then
									questData[j].filter = 1;								
							end
							
							-- show all party members
							if (filtNum == SHOW_PARTY_FILTER and Filters[SHOW_PARTY_FILTER].val ~= nil and i > 3) then
								questData[j].filter = 1; -- make it visible
							end					
							
							if (Filters[filtNum].val ~= nil and Filters[filtNum].type == "partymember" and Filters[filtNum].name == name) then
							-- show party member X
								questData[j].filter = 1; -- make it visible						
							end	
							
							-- don't show this difficulty
							if (Filters[filtNum].type == "diff" and Filters[filtNum].val == nil and Filters[filtNum].name == diff) then
								questData[j].filter = 0;
							end
							
						elseif (Filters[filtNum].val ~= nil and Filters[filtNum].type == "showloc") then
								questData[j].filter = 1;
						end
						
						if (Filters[filtNum].type == "loc" and Filters[filtNum].val == nil and questData[j].location ~= nil and questData[j].location == Filters[filtNum].name) then
								questData[j].filter = 0;
						end

						
					end -- for j=1,numQuests ...				
				end	-- if (numQuests > 0 ...
				
			end -- for i=1,7 ...
		end -- if Filters[filtNum].type ...
	end -- for filtNum ...	
	
end

function BuildFilterMap()
	-- clean
	table.setn(FilterMap,0);
	
	-- filters first
	if (QuestShareShowFiltersCheck:GetChecked() ~= nil) then
		local val = {};
		val.type = 1;
		val.index = 0; -- 0 is the header value
		table.insert(FilterMap,val);

		if (HeaderExpand[HEADER_FILTER] == 1) then
			for i=1,table.getn(Filters),1 do
				local val = {};
				val.type = 1;
				val.index = i;	
				table.insert(FilterMap,val);								
			end
		end
	end

	-- Common Quests
	if (table.getn(QuestDataCommon) > 0) then
		local val = {};
		val.type = HEADER_COMMON;
		val.index = 0; -- 0 is the header value
		table.insert(FilterMap,val);
	end
	
	if (HeaderExpand[HEADER_COMMON] == 1) then
		for i=1,table.getn(QuestDataCommon),1 do
			if (QuestDataCommon[i].filter == 1) then
				local val = {};
				val.type = HEADER_COMMON;
				val.index = i;	
				table.insert(FilterMap,val);		
			end						
		end
	end

	-- Player Quests
	if (table.getn(QuestDataPlayer) > 0) then
		local val = {};
		val.type = HEADER_PLAYER;
		val.index = 0; -- 0 is the header value
		table.insert(FilterMap,val);
	end

	if (HeaderExpand[HEADER_PLAYER] == 1) then
		for i=1,table.getn(QuestDataPlayer),1 do
			if (QuestDataPlayer[i].filter == 1) then
				local val = {};
				val.type = HEADER_PLAYER;
				val.index = i;	
				table.insert(FilterMap,val);			
			end					
		end
	end

	-- Party Quests
	for j=1,MAX_PARTY_MEMBERS,1 do
		local questData = getglobal("QS_QuestDataParty"..j);

		if (table.getn(questData) > 0) then
			local val = {};
			val.type = HEADER_PLAYER+j;
			val.index = 0; -- 0 is the header value
			table.insert(FilterMap,val);
		end
		
		if (HeaderExpand[HEADER_PLAYER+j] == 1) then
			for i=1,table.getn(questData),1 do
				if (questData[i].filter == 1) then
					local val = {};
					val.type = HEADER_PLAYER+j;
					val.index = i;	
					table.insert(FilterMap,val);			
				end					
			end
		end
	end
	
end

function QuestShare_SetFilterCheckBox()
	QuestShare_Update();	
end

