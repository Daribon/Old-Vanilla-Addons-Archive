--[[

	SocialMods: Adds a "Send Message" button to the Social frames that do not have one.
	- by geowar 5 Sep, 2004.
	- added a "Send Page" button 6 Sep, 2004 - geowar
	- added SocialNotes 4 Feb, 2005 - GeoWar (Keep notes about players!)
	- added "note" icon's to Social frame listings. 14 Feb, 2005 - geowar
	- added auto-appending party messages to players notes
	- added auto-appending quest messages to players notes
	- added settings to enable/disable self, party & target notes
	- added settings to append date & time, /played or level time to quest logs & level up messages [NOT COMPLETE]
]]

-- Configuration variables

local COS_SSM_SEND_MESSAGE_ENABLE = 1;	-- enable the 'Send Message' button
local COS_SSM_SEND_PAGE_ENABLE = 0;		-- enable the 'Send Page' button

-- Constants

local SSM_UPDATE_RATE = 0.33;

-- external globals (exported)

-- local (non exported) globals

local SSM_TimeSinceLastUpdate = false;
local localCompletedQuestTable = {};

local localPlayerLevel = false;

-- fix for missing print functions
if (not Print) then
	setglobal("Print", function(msg, r, g, b, frame, id)
		if (not r) then r = 1.0; end
		if (not g) then g = 1.0; end
		if (not b) then b = 1.0; end
		if (not frame) then frame = DEFAULT_CHAT_FRAME; end
		if (frame) then
			if (not id) then
				frame:AddMessage(msg,r,g,b);
			else
				frame:AddMessage(msg,r,g,b,id);
			end
		end
	end);
end

if (not print1) then
	setglobal("print1", function(msg, r, g, b, frame, id)
		Print(join(arg,""), 1.0, 1.0, 0.0, ChatFrame1);
	end);
end

if (not print2) then
	setglobal("print2", function(msg, r, g, b, frame, id)
		Print(join(arg,""), 1.0, 1.0, 0.0, ChatFrame2);
	end);
end

-- local functions (only called internally)

local function SSM_Save()
	if (not Khaos and not Cosmos_RegisterConfiguration) then
		RegisterForSave("COS_SSM_SEND_MESSAGE_ENABLE");
		RegisterForSave("COS_SSM_SEND_PAGE_ENABLE");
	end
end

local function SSM_GetSelectedName()
	local selectedName = false;
	local selectedTab = PanelTemplates_GetSelectedTab(FriendsFrame);

	if (selectedTab == 1) then -- Friend
		if (FriendsListFrame:IsVisible()) then
			selectedName = GetFriendInfo(FriendsFrame.selectedFriend);
		elseif (IgnoreListFrame:IsVisible()) then
			selectedName = GetIgnoreName(FriendsFrame.selectedIgnore);
		end
	elseif (selectedTab == 2) then -- Who
		selectedName = WhoFrame.selectedName;
	elseif (selectedTab == 3) then -- Guild
		selectedName = GuildFrame.selectedName;
	elseif (selectedTab == 4) then -- Raid
		selectedName = RaidFrame.selectedName;
	end

	return selectedName;
end

local function SSM_Update()
	local selectedName = SSM_GetSelectedName();
	local isConnected = true;
--[[
	local isConnected = false;
	if ( UnitExists(selectedName) ) then
		if ( UnitIsPlayer(selectedName) ) then
			isConnected = UnitIsConnected(selectedName);
		end
	end
]]
	-- Print("this: "..asText(this)..".");

	if (COS_SSM_SEND_MESSAGE_ENABLE == 1 and not FriendsListFrame:IsVisible()) then
		if ( selectedName and isConnected) then
			SocialModsButton:Enable();
		else
			SocialModsButton:Disable();
		end
		SocialModsButton:Show();
	else
		SocialModsButton:Hide();
	end

	-- page doesn't work anymore...
	if (false and COS_SSM_SEND_PAGE_ENABLE == 1) then
		if ( selectedName and isConnected and Cosmos_IsCosmosUser and Cosmos_IsCosmosUser(selectedName)) then
			SocialSendPageButton:Enable();
		else
			SocialSendPageButton:Disable();
		end
		SocialSendPageButton:Show();
	else
		SocialSendPageButton:Hide();
	end
end

-- exported functions

function SSM_SendMessageEnable(toggle)
	if (toggle == 1) then 
		COS_SSM_SEND_MESSAGE_ENABLE = 1;
	else
		COS_SSM_SEND_MESSAGE_ENABLE = 0;
	end
	SSM_Save();
	SSM_Update();
end

function SSM_SendMessageEnableToggle()
	if (COS_SSM_SEND_MESSAGE_ENABLE == 1) then
		-- Print("SSM_SendMessageEnableToggle(0)");
		SSM_SendMessageEnable(0);
	else
		-- Print("SSM_SendMessageEnableToggle(1)");
		SSM_SendMessageEnable(1);
	end
end

function SSM_SendPageEnable(toggle)
	if (toggle == 1) then 
		COS_SSM_SEND_PAGE_ENABLE = 1;
	else
		COS_SSM_SEND_PAGE_ENABLE = 0;
	end
	SSM_Save();
	SSM_Update();
end

function SSM_SendPageEnableToggle()
	-- Print("SSM_SendPageEnableToggle");
	if (COS_SSM_SEND_PAGE_ENABLE == 1) then
		SSM_SendPageEnable(0);
	else
		SSM_SendPageEnable(1);
	end
end

-- OnFoo functions

local isLoaded = false;	-- This forces this code to only execute once since multiple buttons call it

function SocialMods_OnLoad()
	if (not isLoaded) then
		-- Print("SocialMods_OnLoad.");
	
		this:RegisterEvent("VARIABLES_LOADED");
	
		-- Register with the CosmosMaster
		if ( Khaos ) then 
			local optionSet = {};
			local commandSet = {};
			local configurationSet = {
				id="SocialMods";
				text=COS_SSM_SEP_TEXT;
				helptext=COS_SSM_SEP_INFO;
				difficulty=1;
				options=optionSet;
				commands=commandSet;
				default=false;
			}; 
			table.insert(
				optionSet,
				{
					id="Header";
					text=TEXT(COS_SSM_SEP_TEXT);
					helptext=TEXT(COS_SSM_SEP_INFO);
					difficulty=1;
					type=K_HEADER;
				}
			);
			table.insert(
				optionSet,
				{
					id="SendMessageEnable";
					text=TEXT(COS_SSM_SEND_MESSAGE_ENABLE_TEXT),
					helptext=TEXT(COS_SSM_SEND_MESSAGE_ENABLE_INFO),
					difficulty=1;
					callback=function(state) 
						if ( state.checked ) then
							SSM_SendMessageEnable(1);
						else
							SSM_SendMessageEnable(0);
						end
					end;
					feedback=function(state)
						if ( state.checked ) then
							return "SendMessage Enabled";
						else
							return "SendMessage Disabled";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};				
				}
			);
--[[
			table.insert(
				optionSet,
				{
					id="SendPageEnable";
					text=TEXT(COS_SSM_SEND_PAGE_ENABLE_TEXT),
					helptext=TEXT(COS_SSM_SEND_PAGE_ENABLE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SSM_SendPageEnable(1);
						else
							SSM_SendPageEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return "Send Page Enabled";
						else
							return "Send Page Disabled";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);
]]--
			Khaos.registerOptionSet("other",configurationSet);
			
			isLoaded = true;
		elseif (Cosmos_RegisterConfiguration ~= nil) then
			Cosmos_RegisterConfiguration(
				"COS_SSM",
				"SECTION",
				TEXT(COS_SSM_SEP_TEXT),
				TEXT(COS_SSM_SEP_INFO)
				);
			Cosmos_RegisterConfiguration(
				"COS_SSM_SEPARATOR",
				"SEPARATOR",
				TEXT(COS_SSM_SEP_TEXT),
				TEXT(COS_SSM_SEP_INFO)
				);
	
			Cosmos_RegisterConfiguration(
				"COS_SSM_SEND_MESSAGE_ENABLE",	--CVar
				"CHECKBOX",						--Things to use
				TEXT(COS_SSM_SEND_MESSAGE_ENABLE_TEXT),
				TEXT(COS_SSM_SEND_MESSAGE_ENABLE_INFO),
				SSM_SendMessageEnable,		--Callback
				1							--Default Checked/Unchecked
				);
--[[		
			Cosmos_RegisterConfiguration(
				"COS_SSM_SEND_PAGE_ENABLE",	--CVar
				"CHECKBOX",					--Things to use
				TEXT(COS_SSM_SEND_PAGE_ENABLE_TEXT),
				TEXT(COS_SSM_SEND_PAGE_ENABLE_INFO),
				SSM_SendPageEnable,			--Callback
				1							--Default Checked/Unchecked
				);
]]--
			isLoaded = true;
		end

		-- this makes the guild roster NOT show offline by default
		SetGuildRosterShowOffline(0);
		--this:SetChecked(GetGuildRosterShowOffline());

		-- Create slash commands (as defined in localization.lua):
		SlashCmdList["COS_SSM"] = SSM_SlashCommand;

	end
end	-- SocialMods_OnLoad

function SSM_SlashCommand(msg)
	local GREEN = GREEN_FONT_COLOR_CODE;
	local CLOSE = FONT_COLOR_CODE_CLOSE;
	local NORMAL = NORMAL_FONT_COLOR_CODE;

	-- Print(format("SSM_SlashCommand:(%s).", msg));
	if ( (not msg) or (strlen(msg) <= 0 ) or (msg == HELP_LABEL) ) then
		DEFAULT_CHAT_FRAME:AddMessage(NORMAL..COS_SSM_SEP_TEXT.." ".." usage:"..CLOSE);
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSM2.." ".. HELP_LABEL..CLOSE.." - This screen");
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSM2.." "..COS_SSM_SLASH_MESSAGE..CLOSE.." - "..COS_SSM_SEND_MESSAGE_TOGGLE_TEXT);
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSM2.." "..COS_SSM_SLASH_PAGE..CLOSE.." - "..COS_SSM_SEND_PAGE_TOGGLE_TEXT);
	elseif (msg == COS_SSM_SLASH_MESSAGE) then	
		SSM_SendMessageEnableToggle();
	elseif (msg == COS_SSM_SLASH_PAGE) then	
		SSM_SendPageEnableToggle();
	end
end

function SocialMods_OnEvent()
--[[
	if (nil == arg1) then
		Print(format("SocialMods_OnEvent:%s: {}.", event));
	else
		if (nil == arg2) then
			Print(format("SocialMods_OnEvent:%s: {%s}.", event, arg1));
		else
			Print(format("SocialMods_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
]]
	if (event == "VARIABLES_LOADED") then
		if (COS_SSM_SEND_MESSAGE_ENABLE == nil) then
			COS_SSM_SEND_MESSAGE_ENABLE = 1;
		end
		SSM_SendMessageEnable(COS_SSM_SEND_MESSAGE_ENABLE);

		if (COS_SSM_SEND_PAGE_ENABLE == nil) then
			COS_SSM_SEND_PAGE_ENABLE = 1;
		end
		SSM_SendPageEnable(COS_SSM_SEND_PAGE_ENABLE);
		Sea.util.hook("UnitPopup_OnClick", "Social_UnitPopup_OnClick", "after");
		Sea.util.hook("UnitPopup_HideButtons", "Social_UnitPopup_HideButtons", "after");
	
		UnitPopupButtons["SOCIAL"] = { text = SN_ADD_SOCIAL_NOTE, dist = 0 };
		table.insert(UnitPopupShown,1);
		table.insert(UnitPopupMenus["PARTY"], table.getn(UnitPopupMenus["PARTY"]),"SOCIAL");
		table.insert(UnitPopupMenus["PLAYER"], table.getn(UnitPopupMenus["PLAYER"]),"SOCIAL");

		-- Added by Vicster to add an option to the target text menu to invite to guild 
		UnitPopupButtons["GUILDIN"] = { text = SN_INVITE_TO_GUILD, dist = 0 }; 
		table.insert(UnitPopupShown,1); 
		table.insert(UnitPopupMenus["PARTY"], table.getn(UnitPopupMenus["PARTY"]),"GUILDIN"); 
		table.insert(UnitPopupMenus["PLAYER"], table.getn(UnitPopupMenus["PLAYER"]),"GUILDIN"); 
	end
end	-- SocialMods_OnEvent

function SocialMods_OnUpdate()
	-- Print("SocialMods_OnUpdate.");

	if (not SSM_TimeSinceLastUpdate) then
		SSM_TimeSinceLastUpdate = SSM_UPDATE_RATE;
	end

	SSM_TimeSinceLastUpdate = SSM_TimeSinceLastUpdate + arg1;

	if ( SSM_TimeSinceLastUpdate > SSM_UPDATE_RATE ) then
		SSM_Update();
		SSM_TimeSinceLastUpdate = 0.0;
	end
end	-- SocialMods_OnUpdate

function SocialMods_SendMessage(name)
	if (not name) then
		name = SSM_GetSelectedName();
	end

	if ( name ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetText("/w "..name.." ");
		else
			ChatFrame_OpenChat("/w "..name.." ");
		end
		ChatEdit_ParseText(ChatFrame1.editBox, 0);
	end
end	-- SocialMods_SendMessage

function SocialMods_SendPage(name)
	if (not name) then
		name = SSM_GetSelectedName();
	end

	if ( name ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetText("/page "..name.." ");
		else
			ChatFrame_OpenChat("/page "..name.." ");
		end
		ChatEdit_ParseText(ChatFrame1.editBox, 0);
	end
end	-- SocialMods_SendPage

--[[

	SocialNotes: Adds a "Send Message" button to the Social frames that do not have one.
	- added SocialNotes 4 Feb, 2005 - GeoWar (Keep notes about players!)
	- added "note" icon's to Social frame listings. 14 Feb, 2005 - geowar
	- added auto-appending party messages to players notes
	- added auto-appending quest messages to players notes
]]

-- Configuration variables
local COS_SN_ENABLE = 1;						-- enable the Social Notes

local COS_SN_EDIT_NOTE_ENABLE = 1;				-- enable the 'Edit Note' button
local COS_SN_SELF_NOTE_ENABLE = 1;				-- enable player's note
local COS_SN_PARTY_NOTES_ENABLE = 1;			-- enable party member note's
local COS_SN_TARGET_NOTE_ENABLE = 1;			-- enable target's note

local COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE = 0;			-- enable appending party member changes to player's note
local COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE = 0;		-- enable appending party member changes to party notes

local COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE = 0;		-- enable appending quest completions to player's note
local COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE = 0;	-- enable appending quest completions to party notes

local COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE = 0;		-- enable appending quest finishes to player's note
local COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE = 0;		-- enable appending quest finishes to party notes

local COS_SN_QUEST_LOG_DATETIME_ENABLE = 0;					-- append date/time to quest conpletions & finishes

local COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE = 0;				-- enable appending level up's to player's note
local COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE = 0;				-- enable sending level up's to player's guild chat channel

local COS_SN_LEVEL_UP_DATETIME_ENABLE = 0;					-- include date & time with ding
local COS_SN_LEVEL_UP_DATE_ENABLE = 0;						-- include date with ding
local COS_SN_LEVEL_UP_LEVEL_TIME_ENABLE = 1;				-- include time to level with ding
local COS_SN_LEVEL_UP_PLAYED_ENABLE = 0;					-- include /played time with ding

-- Constants

local SN_UPDATE_RATE = 0.33;

-- external globals (exported)

-- local (non exported) globals

local SN_Ready = false;	-- only true after VARIABLES_LOADED event
local SN_TimeSinceLastUpdate = false;

local localTotalTimePlayed = false;
local localLevelTimePlayed = false;

local localTimeSinceLastPlayedMessage = 0;

-- local functions (only called internally)

local function SN_Save()
	if (not Khaos and not Cosmos_RegisterConfiguration) then
		RegisterForSave("COS_SN_ENABLE");

		RegisterForSave("COS_SN_EDIT_NOTE_ENABLE");
		RegisterForSave("COS_SN_SELF_NOTE_ENABLE");
		RegisterForSave("COS_SN_PARTY_NOTES_ENABLE");
		RegisterForSave("COS_SN_TARGET_NOTE_ENABLE");

		RegisterForSave("COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE");
		RegisterForSave("COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE");

		RegisterForSave("COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE");
		RegisterForSave("COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE");

		RegisterForSave("COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE");
		RegisterForSave("COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE");

		RegisterForSave("COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE");
		RegisterForSave("COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE");

		RegisterForSave("COS_SN_LEVEL_UP_DATETIME_ENABLE");
		RegisterForSave("COS_SN_LEVEL_UP_DATE_ENABLE");
		RegisterForSave("COS_SN_LEVEL_UP_LEVEL_TIME_ENABLE");
		RegisterForSave("COS_SN_LEVEL_UP_PLAYED_ENABLE");
	end
end

local function SN_GetTimeText()
	if (Clock_GetTimeText) then
		return Clock_GetTimeText();
	end

	local hour, minute = GetGameTime();

	return format("%02d:%02d", hour, minute);
end

local function SN_UpdateNote(button, name)
	if (button) then
		if (COS_SN_ENABLE == 1) then
			if ( not name ) then
				name = UNKNOWN;
			end

			button.title = name;
			button.tooltip = false;

			if (SocialNotes) then
				for key,value in SocialNotes do
					-- Print("key: "..asText(key)..", value: "..asText(value)..".");
					if (value and value.title and value.body) then
						if (value.title == name) then
							button.tooltip = value.body;
							break;
						end
					end
				end
			end

			if (COS_SN_EDIT_NOTE_ENABLE == 1) then
				if ( button.tooltip ) then
					button:Show();
					button:UnlockHighlight();
				else
					button:Hide();
				end
			else
				button:Show();
				if ( button.tooltip ) then
					button:LockHighlight();
				else
					button:UnlockHighlight();
				end
			end
		else
			button:Hide();
		end
	end
end

local function SN_Update()
	local selectedName = SSM_GetSelectedName();

	if (COS_SN_ENABLE == 1 and COS_SN_EDIT_NOTE_ENABLE == 1) then
		if ( selectedName ) then
			SocialEditNoteButton:Enable();
		else
			SocialEditNoteButton:Disable();
		end
		SocialEditNoteButton:Show();
	else
		SocialEditNoteButton:Hide();
	end

	local name = false;
	local button = false;

	if (FriendsFrameFriendButton1:IsVisible()) then
		local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);

		for i=1, FRIENDS_TO_DISPLAY, 1 do
			button = getglobal("FriendsFrameNoteButton"..i);
			name = GetFriendInfo(friendOffset + i);
			SN_UpdateNote(button, name)
		end
	end

	if (FriendsFrameIgnoreButton1:IsVisible()) then
		local ignoreOffset = FauxScrollFrame_GetOffset(FriendsFrameIgnoreScrollFrame);

		for i=1, IGNORES_TO_DISPLAY, 1 do
			button = getglobal("FriendsFrameIgnoreNoteButton"..i);
			name = GetIgnoreName(i + ignoreOffset);
			SN_UpdateNote(button, name)
		end
	end

	if (WhoFrameButton1:IsVisible()) then
		local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame);

		for i=1, WHOS_TO_DISPLAY, 1 do
			button = getglobal("WhoFrameNoteButton"..i);
			name = GetWhoInfo(i + whoOffset);
			SN_UpdateNote(button, name)
		end
	end

	if (GuildFrameButton1:IsVisible()) then
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame);

		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			button = getglobal("GuildFrameNoteButton"..i);
			name = GetGuildRosterInfo(i + guildOffset);
			SN_UpdateNote(button, name)
		end
	end

	if (RaidGroupButton1:IsVisible()) then
		for i=1, MAX_RAID_MEMBERS, 1 do
			button = getglobal("RaidGroupNoteButton"..i);
			name = GetRaidRosterInfo(i);
			SN_UpdateNote(button, name)
		end
	end

	if (PlayerFrame:IsVisible()) then
		button = getglobal("PlayerFrameNoteButton");
		name = UnitName("player")
		SN_UpdateNote(button, name)
		if ((0 == COS_SN_SELF_NOTE_ENABLE) and button:IsVisible()) then
			button:Hide();
		end
	end

	for i=1, MAX_PARTY_MEMBERS, 1 do
		local prefix = "PartyMemberFrame"..i;
		local frame = getglobal(prefix);
		if (frame and frame:IsVisible()) then
			button = getglobal(prefix.."NoteButton");
			name = UnitName("party"..i)
			SN_UpdateNote(button, name)
			if ((0 == COS_SN_PARTY_NOTES_ENABLE) and button:IsVisible()) then
				button:Hide();
			end
		end
	end

	if (TargetFrame:IsVisible()) then
		button = getglobal("TargetFrameNoteButton");
		name = UnitName("target")
		SN_UpdateNote(button, name)
		if ((0 == COS_SN_TARGET_NOTE_ENABLE) and button:IsVisible()) then
			button:Hide();
		end
	end
end

-- exported functions

function SN_NotesEnable(toggle)
	-- Print("SN_NotesEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_ENABLE = 1;
	else
		COS_SN_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_NotesEnableToggle()
	if (COS_SN_ENABLE == 1) then
		SN_NotesEnable(0);
	else
		SN_NotesEnable(1);
	end
end

function SN_EditNoteEnable(toggle)
	-- Print("SN_EditNoteEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_EDIT_NOTE_ENABLE = 1;
	else
		COS_SN_EDIT_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_EditNoteEnableToggle()
	-- Print("SN_EditNoteEnableToggle");
	if (COS_SN_EDIT_NOTE_ENABLE == 1) then
		SN_EditNoteEnable(0);
	else
		SN_EditNoteEnable(1);
	end
end

function SN_PartyChangesToSelfNoteEnable(toggle)
	-- Print("SN_PartyChangesToSelfNoteEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE = 1;
	else
		COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_PartyChangesToSelfNoteEnableToggle()
	-- Print("SN_PartyChangesToSelfNoteEnableToggle");
	if (COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE == 1) then
		SN_PartyChangesToSelfNoteEnable(0);
	else
		SN_PartyChangesToSelfNoteEnable(1);
	end
end

function SN_PartyChangesToPartyNotes(toggle)
	-- Print("SN_PartyChangesToPartyNotes("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE = 1;
	else
		COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_PartyChangesToPartyNotesToggle()
	-- Print("SN_PartyChangesToPartyNotesToggle");
	if (COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE == 1) then
		SN_PartyChangesToPartyNotes(0);
	else
		SN_PartyChangesToPartyNotes(1);
	end
end

function SN_QuestCompletionsToSelfNoteEnable(toggle)
	-- Print("SN_QuestCompletionsToSelfNoteEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE = 1;
	else
		COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_QuestCompletionsToSelfNoteEnableToggle()
	-- Print("SN_QuestCompletionsToSelfNoteEnableToggle");
	if (COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE == 1) then
		SN_QuestCompletionsToSelfNoteEnable(0);
	else
		SN_QuestCompletionsToSelfNoteEnable(1);
	end
end

function SN_QuestCompletionsToPartyNotesEnable(toggle)
	-- Print("SN_QuestCompletionsToPartyNotesEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE = 1;
	else
		COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_QuestCompletionsToPartyNotesEnableToggle()
	-- Print("SN_QuestCompletionsToPartyNotesEnableToggle");
	if (COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE == 1) then
		SN_QuestCompletionsToPartyNotesEnable(0);
	else
		SN_QuestCompletionsToPartyNotesEnable(1);
	end
end

function SN_QuestFinishesToSelfNote(toggle)
	-- Print("SN_QuestFinishesToSelfNote("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE = 1;
	else
		COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_QuestFinishesToSelfNoteToggle()
	-- Print("SN_QuestFinishesToSelfNoteToggle");
	if (COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE == 1) then
		SN_QuestFinishesToSelfNote(0);
	else
		SN_QuestFinishesToSelfNote(1);
	end
end

function SN_QuestFinishesToPartyNotesEnable(toggle)
	-- Print("SN_QuestFinishesToPartyNotesEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE = 1;
	else
		COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_QuestFinishesToPartyNotesEnableToggle()
	-- Print("SN_QuestFinishesToPartyNotesEnableToggle");
	if (COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE == 1) then
		SN_QuestFinishesToPartyNotesEnable(0);
	else
		SN_QuestFinishesToPartyNotesEnable(1);
	end
end

function SN_QuestLogDateTimeEnable(toggle)
	-- Print("SN_QuestLogDateTimeEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_QUEST_LOG_DATETIME_ENABLE = 1;
	else
		COS_SN_QUEST_LOG_DATETIME_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_QuestLogDateTimeEnableToggle()
	-- Print("SN_QuestLogDateTimeEnableToggle");
	if (COS_SN_QUEST_LOG_DATETIME_ENABLE == 1) then
		SN_QuestLogDateTimeEnable(0);
	else
		SN_QuestLogDateTimeEnable(1);
	end
end

function SN_SelfNoteEnable(toggle)
	-- Print("SN_SelfNoteEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_SELF_NOTE_ENABLE = 1;
	else
		COS_SN_SELF_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_SelfNoteEnableToggle()
	-- Print("SN_SelfNoteEnableToggle");
	if (COS_SN_SELF_NOTE_ENABLE == 1) then
		SN_SelfNoteEnable(0);
	else
		SN_SelfNoteEnable(1);
	end
end

function SN_PartyNotesEnable(toggle)
	-- Print("SN_PartyNotesEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_PARTY_NOTES_ENABLE = 1;
	else
		COS_SN_PARTY_NOTES_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_PartyNotesEnableToggle()
	-- Print("SN_PartyNotesEnableToggle");
	if (COS_SN_PARTY_NOTES_ENABLE == 1) then
		SN_PartyNotesEnable(0);
	else
		SN_PartyNotesEnable(1);
	end
end

function SN_TargetNoteEnable(toggle)
	-- Print("SN_TargetNoteEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_TARGET_NOTE_ENABLE = 1;
	else
		COS_SN_TARGET_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_TargetNoteEnableToggle()
	-- Print("SN_TargetNoteEnableToggle");
	if (COS_SN_TARGET_NOTE_ENABLE == 1) then
		SN_TargetNoteEnable(0);
	else
		SN_TargetNoteEnable(1);
	end
end

function SN_SelfDingEnable(toggle)
	-- Print("SN_SelfDingEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE = 1;
	else
		COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_SelfDingEnableToggle()
	-- Print("SN_SelfDingEnableToggle");
	if (COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE == 1) then
		SN_SelfDingEnable(0);
	else
		SN_SelfDingEnable(1);
	end
end

function SN_LevelUpToGuildChatEnable(toggle)
	-- Print("SN_LevelUpToGuildChatEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE = 1;
	else
		COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_LevelUpToGuildChatEnableToggle()
	-- Print("SN_LevelUpToGuildChatEnableToggle");
	if (COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE == 1) then
		SN_LevelUpToGuildChatEnable(0);
	else
		SN_LevelUpToGuildChatEnable(1);
	end
end

-- OnFoo functions

function SocialNotes_OnLoad()
	-- Print("SocialNotes_OnLoad");
	
	this:RegisterEvent("VARIABLES_LOADED");

	if ( Khaos ) then 
			local optionSet = {};
			local commandSet = {};
			local configurationSet = {
				id="SocialNotes";
				text=TEXT(COS_SN_SEP_TEXT);
				helptext=TEXT(COS_SN_SEP_INFO);
				difficulty=1;
				options=optionSet;
				commands=commandSet;
				default=false;
			}; 
			table.insert(
				optionSet,
				{
					id="Header";
					text=TEXT(COS_SN_SEP_TEXT);
					helptext=TEXT(COS_SN_SEP_INFO);
					difficulty=1;
					type=K_HEADER;
				}
			);

			table.insert(
				optionSet,
				{
					id="SocialNotesEnable";
					text=TEXT(COS_SN_ENABLE_TEXT),
					helptext=TEXT(COS_SN_ENABLE_INFO),
					difficulty=1;
					callback=function(state) 
						if ( state.checked ) then
							SN_NotesEnable(1);
						else
							SN_NotesEnable(0);
						end
					end;
					feedback=function(state)
						if ( state.checked ) then
							return COS_SN_SEP_TEXT.." "..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_SEP_TEXT.." "..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};				
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_EditNoteEnable";
					text=TEXT(COS_SN_EDIT_NOTE_ENABLE_TEXT),
					helptext=TEXT(COS_SN_EDIT_NOTE_ENABLE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_EditNoteEnable(1);
						else
							SN_EditNoteEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_EDIT_NOTE.." "..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_EDIT_NOTE.." "..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);
			table.insert(
				optionSet,
				{
					id="SN_SelfNoteEnable";
					text=TEXT(COS_SN_SELF_NOTE_TEXT),
					helptext=TEXT(COS_SN_SELF_NOTE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_SelfNoteEnable(1);
						else
							SN_SelfNoteEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_SELF_NOTE_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_SELF_NOTE_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);
			
			table.insert(
				optionSet,
				{
					id="SN_PartyNotesEnable";
					text=TEXT(COS_SN_PARTY_NOTES_TEXT),
					helptext=TEXT(COS_SN_PARTY_NOTES_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_PartyNotesEnable(1);
						else
							SN_PartyNotesEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_PARTY_NOTES_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_PARTY_NOTES_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_TargetNoteEnable";
					text=TEXT(COS_SN_TARGET_NOTE_TEXT),
					helptext=TEXT(COS_SN_TARGET_NOTE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_TargetNoteEnable(1);
						else
							SN_TargetNoteEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_TARGET_NOTE_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_TARGET_NOTE_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_PartyChangesToSelfNoteEnable";
					text=TEXT(COS_SN_PARTY_CHANGES_TO_SELF_NOTE_TEXT),
					helptext=TEXT(COS_SN_PARTY_CHANGES_TO_SELF_NOTE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_PartyChangesToSelfNoteEnable(1);
						else
							SN_PartyChangesToSelfNoteEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_PARTY_CHANGES_TO_SELF_NOTE_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_PARTY_CHANGES_TO_SELF_NOTE_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_PartyChangesToPartyNotes";
					text=TEXT(COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_TEXT),
					helptext=TEXT(COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_PartyChangesToPartyNotes(1);
						else
							SN_PartyChangesToPartyNotes(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_QuestCompletionsToSelfNote";
					text=TEXT(COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_TEXT),
					helptext=TEXT(COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_QuestCompletionsToSelfNoteEnable(1);
						else
							SN_QuestCompletionsToSelfNoteEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_QuestCompletionsToPartyNotesEnable";
					text=TEXT(COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_TEXT),
					helptext=TEXT(COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_QuestCompletionsToPartyNotesEnable(1);
						else
							SN_QuestCompletionsToPartyNotesEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);


			table.insert(
				optionSet,
				{
					id="SN_QuestFinishesToSelfNote";
					text=TEXT(COS_SN_QUEST_FINISHES_TO_SELF_NOTE_TEXT),
					helptext=TEXT(COS_SN_QUEST_FINISHES_TO_SELF_NOTE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_QuestFinishesToSelfNote(1);
						else
							SN_QuestFinishesToSelfNote(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_QUEST_FINISHES_TO_SELF_NOTE_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_QUEST_FINISHES_TO_SELF_NOTE_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SN_QuestFinishesToPartyNotesEnable";
					text=TEXT(COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_TEXT),
					helptext=TEXT(COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_QuestFinishesToPartyNotesEnable(1);
						else
							SN_QuestFinishesToPartyNotesEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_STAT..COS_SSN_ENABLED_TEXT..".";
						else
							return COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_STAT..COS_SSN_DISABLED_TEXT..".";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);

			table.insert(
				optionSet,
				{
					id="SocialNotesSelfDingEnable";
					text=TEXT(COS_SN_LEVEL_UP_TO_SELF_NOTE_TEXT),
					helptext=TEXT(COS_SN_LEVEL_UP_TO_SELF_NOTE_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_SelfDingEnable(1);
						else
							SN_SelfDingEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return "Self DING! Enabled";
						else
							return "Self DING! Disabled";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);
			table.insert(
				optionSet,
				{
					id="SocialNotesGuildDingEnable";
					text=TEXT(COS_SN_LEVEL_UP_TO_GUILD_CHAT_TEXT),
					helptext=TEXT(COS_SN_LEVEL_UP_TO_GUILD_CHAT_INFO),
					difficulty=1;
					callback=function(state)
						if( state.checked ) then
							SN_LevelUpToGuildChatEnable(1);
						else
							SN_LevelUpToGuildChatEnable(0);
						end
					end;
					feedback=function(state)
						if(state.checked) then
							return "Guild DING! Enabled";
						else
							return "Guild DING! Disabled";
						end
					end;
					check=true;
					type=K_TEXT;
					default={
						checked=true;
					};
					disabled={
						checked=false;
					};
				}
			);
			Khaos.registerOptionSet("other",configurationSet);
	elseif (Cosmos_RegisterConfiguration ~= nil) then
		Cosmos_RegisterConfiguration(
			"COS_SN",
			"SECTION",
			TEXT(COS_SN_SEP_TEXT),
			TEXT(COS_SN_SEP_INFO)
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_SEPARATOR",
			"SEPARATOR",
			TEXT(COS_SN_SEP_TEXT),
			TEXT(COS_SN_SEP_INFO)
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_ENABLE",			--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_ENABLE_TEXT),
			TEXT(COS_SN_ENABLE_INFO),
			SN_NotesEnable,				--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_EDIT_NOTE_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_EDIT_NOTE_ENABLE_TEXT),
			TEXT(COS_SN_EDIT_NOTE_ENABLE_INFO),
			SN_EditNoteEnable,			--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_SELF_NOTE_ENABLE",--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_SELF_NOTE_TEXT),
			TEXT(COS_SN_SELF_NOTE_INFO),
			SN_SelfNoteEnable,			--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_PARTY_NOTES_ENABLE",--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_PARTY_NOTES_TEXT),
			TEXT(COS_SN_PARTY_NOTES_INFO),
			SN_PartyNotesEnable,		--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_TARGET_NOTE_ENABLE",--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_TARGET_NOTE_TEXT),
			TEXT(COS_SN_TARGET_NOTE_INFO),
			SN_TargetNoteEnable,		--Callback
			1							--Default Checked/Unchecked
			);

		Cosmos_RegisterConfiguration(
			"COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_PARTY_CHANGES_TO_SELF_NOTE_TEXT),
			TEXT(COS_SN_PARTY_CHANGES_TO_SELF_NOTE_INFO),
			SN_PartyChangesToSelfNoteEnable,			--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_TEXT),
			TEXT(COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_INFO),
			SN_PartyChangesToPartyNotes,			--Callback
			1							--Default Checked/Unchecked
			);

		Cosmos_RegisterConfiguration(
			"COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_TEXT),
			TEXT(COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_INFO),
			SN_QuestCompletionsToSelfNoteEnable,			--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_PARTY_QUEST_COMPLETIONS_TEXT),
			TEXT(COS_SN_PARTY_QUEST_COMPLETIONS_INFO),
			SN_QuestCompletionsToPartyNotesEnable,			--Callback
			1							--Default Checked/Unchecked
			);

		Cosmos_RegisterConfiguration(
			"COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_QUEST_FINISHES_TO_SELF_NOTE_TEXT),
			TEXT(COS_SN_QUEST_FINISHES_TO_SELF_NOTE_INFO),
			SN_QuestFinishesToSelfNote,			--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_TEXT),
			TEXT(COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_INFO),
			SN_QuestFinishesToPartyNotesEnable,			--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_QUEST_LOG_DATETIME_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_QUEST_LOG_DATETIME_TEXT),
			TEXT(COS_SN_QUEST_LOG_DATETIME_INFO),
			SN_QuestLogDateTimeEnable,				--Callback
			1							--Default Checked/Unchecked
			);

		Cosmos_RegisterConfiguration(
			"COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE",--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_LEVEL_UP_TO_SELF_NOTE_TEXT),
			TEXT(COS_SN_LEVEL_UP_TO_SELF_NOTE_INFO),
			SN_SelfDingEnable,		--Callback
			1							--Default Checked/Unchecked
			);
		Cosmos_RegisterConfiguration(
			"COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE",--CVar
			"CHECKBOX",					--Things to use
			TEXT(COS_SN_LEVEL_UP_TO_GUILD_CHAT_TEXT),
			TEXT(COS_SN_LEVEL_UP_TO_GUILD_CHAT_INFO),
			SN_LevelUpToGuildChatEnable,		--Callback
			1							--Default Checked/Unchecked
			);
	end

	-- Create slash commands (as defined in localization.lua):
	SlashCmdList["COS_SSN"] = SSN_SlashCommand;
end

function SSN_SlashCommand(msg)
	local GREEN = GREEN_FONT_COLOR_CODE;
	local YELLOW = LIGHTYELLOW_FONT_COLOR_CODE;
	local CLOSE = FONT_COLOR_CODE_CLOSE;
	local NORMAL = NORMAL_FONT_COLOR_CODE;

	-- Print(format("SSN_SlashCommand:(%s).", msg));
	if ( (not msg) or (strlen(msg) <= 0 ) or (msg == HELP_LABEL) ) then
		local off_on_enable_disable_toggle = " "..YELLOW.."[ "..COS_SSN_SLASH_ON.." | "..COS_SSN_SLASH_OFF.." | "..COS_SSN_SLASH_ENABLE.." | "..COS_SSN_SLASH_DISABLE.." | "..COS_SSN_SLASH_TOGGLE.." ]"..CLOSE;

		DEFAULT_CHAT_FRAME:AddMessage(NORMAL..COS_SN_SEP_TEXT.." usage:"..CLOSE);
		-- /ssn help
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." ".. HELP_LABEL..CLOSE.." - This screen");
		-- /ssn [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2..off_on_enable_disable_toggle);
		-- /ssn button [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_BUTTON..off_on_enable_disable_toggle);
		-- /ssn self note [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_SELF.." "..COS_SSN_SLASH_NOTE..off_on_enable_disable_toggle);
		-- /ssn self note party [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_SELF.." "..COS_SSN_SLASH_NOTE.." "..COS_SSN_SLASH_PARTY..off_on_enable_disable_toggle);
		-- /ssn self note complete [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_SELF.." "..COS_SSN_SLASH_NOTE.." "..COS_SSN_SLASH_COMPLETE..off_on_enable_disable_toggle);
		-- /ssn self note finish [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_SELF.." "..COS_SSN_SLASH_NOTE.." "..COS_SSN_SLASH_FINISH..off_on_enable_disable_toggle);
		-- /ssn self note ding [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_SELF.." "..COS_SSN_SLASH_NOTE.." "..COS_SSN_SLASH_DING..off_on_enable_disable_toggle);
		-- /ssn party notes [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_PARTY.." "..COS_SSN_SLASH_NOTES..off_on_enable_disable_toggle);
		-- /ssn party notes party [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_PARTY.." "..COS_SSN_SLASH_NOTES.." "..COS_SSN_SLASH_PARTY..off_on_enable_disable_toggle);
		-- /ssn party notes complete [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_PARTY.." "..COS_SSN_SLASH_NOTES.." "..COS_SSN_SLASH_COMPLETE..off_on_enable_disable_toggle);
		-- /ssn party notes finish [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_PARTY.." "..COS_SSN_SLASH_NOTES.." "..COS_SSN_SLASH_FINISH..off_on_enable_disable_toggle);
		-- /ssn target note [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_TARGET.." "..COS_SSN_SLASH_NOTE..off_on_enable_disable_toggle);
		-- /ssn guild ding [on|off|enable|disable|toggle]
		DEFAULT_CHAT_FRAME:AddMessage(GREEN..SLASH_COS_SSN2.." "..COS_SSN_SLASH_GUILD.." "..COS_SSN_SLASH_DING..off_on_enable_disable_toggle);
	elseif (msg == COS_SSN_SLASH_ON) then	
		SN_NotesEnable(1);
	elseif (msg == COS_SSN_SLASH_OFF) then	
		SN_NotesEnable(0);
	end
end

local localPartyPeople = {};

function SocialNotes_OnEvent()
--[[
	if (nil == arg1) then
		Print(format("SocialNotes_OnEvent:%s: {}.", event));
	else
		if (nil == arg2) then
			Print(format("SocialNotes_OnEvent:%s: {%s}.", event, arg1));
		else
			Print(format("SocialNotes_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
]]
	if (event == "VARIABLES_LOADED") then
		-- Print(format("SocialNotes_OnEvent:%s: {}.", event));
		if (SN_Ready == false) then
			-- Print("SocialNotes_OnEvent: (SN_Ready == false).");
			if (COS_SN_ENABLE == nil) then
				COS_SN_ENABLE = 1;
			end
			SN_NotesEnable(COS_SN_ENABLE);
	
			if (COS_SN_EDIT_NOTE_ENABLE == nil) then
				COS_SN_EDIT_NOTE_ENABLE = 1;
			end
			SN_EditNoteEnable(COS_SN_EDIT_NOTE_ENABLE);

			if (COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE == nil) then
				COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE = 1;
			end
			SN_PartyChangesToSelfNoteEnable(COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE);
	
			if (COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE == nil) then
				COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE = 1;
			end
			SN_PartyChangesToPartyNotes(COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE);
	
			if (COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE == nil) then
				COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE = 1;
			end
			SN_QuestCompletionsToSelfNoteEnable(COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE);
	
			if (COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE == nil) then
				COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE = 1;
			end
			SN_QuestCompletionsToPartyNotesEnable(COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE);
	
			if (COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE == nil) then
				COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE = 1;
			end
			SN_QuestFinishesToSelfNote(COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE);
	
			if (COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE == nil) then
				COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE = 1;
			end
			SN_QuestFinishesToPartyNotesEnable(COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE);
	
			if (COS_SN_SELF_NOTE_ENABLE == nil) then
				COS_SN_SELF_NOTE_ENABLE = 1;
			end
			SN_SelfNoteEnable(COS_SN_SELF_NOTE_ENABLE);
	
			if (COS_SN_PARTY_NOTES_ENABLE == nil) then
				COS_SN_PARTY_NOTES_ENABLE = 1;
			end
			SN_PartyNotesEnable(COS_SN_PARTY_NOTES_ENABLE);
	
			if (COS_SN_TARGET_NOTE_ENABLE == nil) then
				COS_SN_TARGET_NOTE_ENABLE = 1;
			end
			SN_TargetNoteEnable(COS_SN_TARGET_NOTE_ENABLE);
	
			-- built the table of completed quests
			localCompletedQuestTable = {};	-- empty table
			local questIndex, questCount = GetNumQuestLogEntries();
			for questIndex = 1, questCount do
				local title, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questIndex);
				if (title and not isHeader and isComplete) then
					-- Print("Quest: "..title..".\n");
					table.insert(localCompletedQuestTable, title);
				end
			end
	
			this:RegisterEvent("PLAYER_ENTERING_WORLD");
			this:RegisterEvent("PLAYER_LEVEL_UP");		
			this:RegisterEvent("TIME_PLAYED_MSG");		

			this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	
			this:RegisterEvent("QUEST_COMPLETE");
			this:RegisterEvent("QUEST_FINISHED");
			this:RegisterEvent("QUEST_ITEM_UPDATE");
			this:RegisterEvent("QUEST_PROGRESS");
			this:RegisterEvent("QUEST_DETAIL");
			this:RegisterEvent("QUEST_LOG_UPDATE");		
	
			for idx = 1,4 do -- rebuild the list
			  localPartyPeople[idx] = UnitName("party"..idx);
			end
	
			SN_Ready = true;
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		localPlayerLevel = UnitLevel("player");
		RequestTimePlayed();
	elseif( event == "PLAYER_LEVEL_UP" ) then
		-- Print("SSM:PLAYER_LEVEL_UP, requesting time played.");
		localPlayerLevel = arg1;
			local string = format(TEXT(COS_SNE_DINGED_TEXT), localPlayerLevel);

			if (COS_SN_LEVEL_UP_DATETIME_ENABLE == 1) then			-- include date & time with ding
				string = string..format(TEXT(COS_SNE_DINGED_ON_DATETIME_TEXT), date, SN_GetTimeText());
			elseif (COS_SN_LEVEL_UP_DATE_ENABLE == 1) then			-- include date with ding
				string = string..format(TEXT(COS_SNE_DINGED_ON_DATE_TEXT), date());
			elseif (COS_SN_LEVEL_UP_LEVEL_TIME_ENABLE == 1) then	-- include time to level with ding
			local d, h, m, s = ChatFrame_TimeBreakDown(localLevelTimePlayed + localTimeSinceLastPlayedMessage);
				string = string..format(TEXT(COS_SNE_DINGED_IN_TEXT), d, h, m, s);
			elseif (COS_SN_LEVEL_UP_PLAYED_ENABLE == 1) then		-- include /played time with ding
				local d, h, m, s = ChatFrame_TimeBreakDown(localTotalTimePlayed);
				string = string..format(TEXT(COS_SNE_DINGED_AT_TEXT), d, h, m, s);
			end
			-- Print(format("SSM:PLAYER_LEVEL_UP:TIME_PLAYED_MSG, %s.", string));

			if (COS_SN_LEVEL_UP_TO_GUILD_CHAT_ENABLE == 1) then
				local text = ChatFrameEditBox:GetText();
				ChatFrameEditBox:SetText("/g "..string);
				ChatEdit_SendText(ChatFrameEditBox);
				ChatFrameEditBox:SetText(text);
			end
			
			if (COS_SN_LEVEL_UP_TO_SELF_NOTE_ENABLE == 1) then
				SNE_AppendToPlayerNote(UnitName("player"), string);
			end

		RequestTimePlayed();
		
	elseif( event == "TIME_PLAYED_MSG" ) then
		localTotalTimePlayed = arg1;
		localLevelTimePlayed = arg2;
		localTimeSinceLastPlayedMessage = 0;
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		-- Print(format("SocialNotes_OnEvent:%s: {}.", event));
		local didChange = false;
		local idx;
		for idx = 1,4 do
			local pname = UnitName("party"..idx);
	
			if (pname and not Sea.table.isInTable(localPartyPeople, pname)) then
				-- Print("SN-new party member: "..pname);
				if (COS_SN_PARTY_CHANGES_TO_SELF_NOTE_ENABLE == 1) then
					SNE_SelfAppendJoinedMessage(pname);
				end
				if (COS_SN_PARTY_CHANGES_TO_PARTY_NOTES_ENABLE == 1) then
					SNE_AppendJoinedMessage(pname);
				end
				didChange = true;
			end
		end
		if (didChange) then -- rebuild the list
			for idx = 1,4 do
			  localPartyPeople[idx] = UnitName("party"..idx);
			end
		end
		-- Print(format("localPartyPeople: %s.", asText(localPartyPeople)));
	elseif (event=="QUEST_COMPLETE" or event=="QUEST_FINISHED" or event=="QUEST_LOG_UPDATE" or event=="QUEST_ITEM_UPDATE" or event=="QUEST_DETAIL" or event=="QUEST_PROGRESS" ) then
		-- Print(format("SocialNotes_OnEvent:%s: {}.", event));

		-- look for any newly completed quests
		local newCompletedQuestTable = {};
		local numQuestEntries, questCount = GetNumQuestLogEntries();
		local questIndex;
		
		-- Print("numQuestEntries: "..numQuestEntries..", questCount: "..questCount..".");
		
		for questIndex = 1, numQuestEntries do
			local title, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questIndex);
			if (title and not isHeader) then
				-- Print("Quest: "..title..".");
				if (isComplete) then
					-- Print(title.." complete.");
					table.insert(newCompletedQuestTable, title);
					if ( not Sea.table.isInTable(localCompletedQuestTable, title)) then
						-- Print(format("newly completed quest: %s.", title));
						-- add it for next time
						table.insert(localCompletedQuestTable, title);
						if (COS_SN_QUEST_COMPLETIONS_TO_SELF_NOTE_ENABLE == 1) then
							SNE_AppendCompletedMessage(UnitName("player"), title);
						end
						if (COS_SN_QUEST_COMPLETIONS_TO_PARTY_NOTES_ENABLE == 1) then
							-- and append the completed message to the notes of everyone in our party
							for idx = 1,4 do
								local pname = UnitName("party"..idx);
								if (pname) then
									SNE_AppendCompletedMessage(pname, title);
								end
							end
						end
					end
				else
					-- Print(title.." not complete.");
				end
			end
		end

		-- if this quest is now finished
		if (event == "QUEST_FINISHED") then
			-- Print(format("localCompletedQuestTable: %s.", asText(localCompletedQuestTable)));
			-- Print(format("newCompletedQuestTable: %s.", asText(newCompletedQuestTable)));
			-- find any that have dissappeared from the list
			for key,value in localCompletedQuestTable do
				if (not Sea.table.isInTable(newCompletedQuestTable, value)) then
					-- Print(format("finished quest: %s.", value));
					if (COS_SN_QUEST_FINISHES_TO_SELF_NOTE_ENABLE == 1) then
						SNE_AppendFinishedMessage(UnitName("player"), value);
					end
					if (COS_SN_QUEST_FINISHES_TO_PARTY_NOTES_ENABLE == 1) then
						-- and append the finished message to the notes of everyone in our party
						for idx = 1,4 do
							local pname = UnitName("party"..idx);
							if (pname) then
								SNE_AppendFinishedMessage(pname, value);
							end
						end
					end
				else
					-- Print(title.." not finished.");
				end
			end
			localCompletedQuestTable = newCompletedQuestTable;
		end
		-- Print(format("Number of completed quests: %d of %d.", table.getn(localCompletedQuestTable), questCount));
	end
end

local SN_FN_TimeSinceLastUpdate = false;

function SocialNotes_OnUpdate()
	if (not SN_FN_TimeSinceLastUpdate) then
		SN_FN_TimeSinceLastUpdate = SN_UPDATE_RATE;
	end

	SN_FN_TimeSinceLastUpdate = SN_FN_TimeSinceLastUpdate + arg1;

	if ( SN_FN_TimeSinceLastUpdate > SN_UPDATE_RATE ) then
		-- Print("SocialNotes_OnUpdate");
		SN_Update();

		SN_FN_TimeSinceLastUpdate = 0.0;
	end
end

function SocialNotes_OnClick(arg1)
	-- Print("SocialNotes_OnClick("..asText(arg1)..").");

	local name = this.title;

	if (not name) then
		name = SSM_GetSelectedName();
	end
	
	if (name) then
		SocialNotesEditor_EditPlayerNote(name);
	end
end

function SocialNotes_OnEnter()
	-- Print("SocialNotes_OnEnter");

	GameTooltip_AddNewbieTip(COS_SN_NOTES, 1.0, 1.0, 1.0, COS_SN_NOTES_NEWBIE_TOOLTIP, 1);

	if (this.tooltip) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		GameTooltip:SetText(this.tooltip);
	end
end

function Social_UnitPopup_OnClick()
	local index = this.value;
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button = UnitPopupMenus[this.owner][index];
	local name = dropdownFrame.name;
	if (button == "SOCIAL" ) then
		SocialNotesEditor_EditPlayerNote(name); 
	end
	-- Added by Vicster to listen for event when the button is click and invite the targeted member to the guild 
	if (button == "GUILDIN" ) then 
		GuildInviteByName(UnitName('target')); 
	end 
end

function Social_UnitPopup_HideButtons()
	local dropdownMenu = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local dropdownFrame = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	for index, value in UnitPopupMenus[dropdownFrame.which] do
		if ( UnitPopupShown[index] == 1 ) then
			if ( value == "SOCIAL" ) then
				if (SN_HasNote(dropdownMenu.name)) then
					UnitPopupShown[index] = 0;
				end
			end
		end
	end
end

function SN_HasNote(name)
	if (SocialNotes) then
		for key,value in SocialNotes do
			-- Print("key: "..asText(key)..", value: "..asText(value)..".");
			if (value and value.title and value.body) then
				if (value.title == name) then
					return true;
				end
			end
		end
	end
end

function SNF_OnUpdate()
	--Print("SNF_OnUpdate");
	localTimeSinceLastPlayedMessage = localTimeSinceLastPlayedMessage + arg1;
	-- SocialMods_OnUpdate();
end

function SN_Test()
	Print(format("SN_Test, localLevelTimePlayed: %s, ", asText(localLevelTimePlayed)));
	Print(format("SN_Test: localTimeSinceLastPlayedMessage: %d, ", asText(localTimeSinceLastPlayedMessage)));
	Print(format("SN_Test: Time played at this level: %d, ", localLevelTimePlayed + localTimeSinceLastPlayedMessage));
	RequestTimePlayed();
end

--Print("SocialMods loaded!");
