--[[

	SocialSendMessage: Adds a "Send Message" button to the Social frames that do not have one.
	- by geowar 5 Sep, 2004.
	- added a "Send Page" button 6 Sep, 2004 - geowar
	- added SocialNotes 4 Feb, 2005 - GeoWar (Keep notes about other players!)
	- added "note" icon's to Social frame listings. 14 Feb, 2005 - geowar
]]

-- Configuration variables

local UUI_SSM_SEND_MESSAGE_ENABLE = 1;	-- enable the 'Send Message' button
local UUI_SSM_SEND_PAGE_ENABLE = 1;		-- enable the 'Send Page' button

-- Constants

local SSM_UPDATE_RATE = 0.33;

-- external globals (exported)

-- local (non exported) globals

local SSM_TimeSinceLastUpdate = false;

-- local functions (only called internally)

local function SSM_Save()
	RegisterForSave("UUI_SSM_SEND_MESSAGE_ENABLE");
	RegisterForSave("UUI_SSM_SEND_PAGE_ENABLE");
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
	-- print1("this: "..asText(this)..".");

	if (UUI_SSM_SEND_MESSAGE_ENABLE == 1 and not FriendsListFrame:IsVisible()) then
		if ( selectedName and isConnected) then
			SocialSendMessageButton:Enable();
		else
			SocialSendMessageButton:Disable();
		end
		SocialSendMessageButton:Show();
	else
		SocialSendMessageButton:Hide();
	end

	if (UUI_SSM_SEND_PAGE_ENABLE == 1) then
		if ( selectedName and isConnected and UltimateUI_IsUltimateUIUser and UltimateUI_IsUltimateUIUser(selectedName)) then
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
		UUI_SSM_SEND_MESSAGE_ENABLE = 1;
	else
		UUI_SSM_SEND_MESSAGE_ENABLE = 0;
	end
	SSM_Save();
	SSM_Update();
end

function SSM_SendMessageEnableToggle()
	if (UUI_SSM_SEND_MESSAGE_ENABLE == 1) then
		SSM_SendMessageEnable(0);
	else
		SSM_SendMessageEnable(1);
	end
end

function SSM_SendPageEnable(toggle)
	if (toggle == 1) then 
		UUI_SSM_SEND_PAGE_ENABLE = 1;
	else
		UUI_SSM_SEND_PAGE_ENABLE = 0;
	end
	SSM_Save();
	SSM_Update();
end

function SSM_SendPageEnableToggle()
	if (UUI_SSM_SEND_PAGE_ENABLE == 1) then
		SSM_SendPageEnable(0);
	else
		SSM_SendPageEnable(1);
	end
end

-- OnFoo functions

local isLoaded = false;	-- This forces this code to only execute once since multiple buttons call it

function SocialSendMessage_OnLoad()
	if (not isLoaded) then
		-- print1("SocialSendMessage_OnLoad.");
	
		this:RegisterEvent("VARIABLES_LOADED");
	
		-- Register with the UltimateUIMaster
		if (UltimateUI_RegisterConfiguration ~= nil) then
			UltimateUI_RegisterConfiguration(
				"UUI_SSM",
				"SECTION",
				TEXT(UUI_SSM_SEP_TEXT),
				TEXT(UUI_SSM_SEP_INFO)
				);
			UltimateUI_RegisterConfiguration(
				"UUI_SSM_SEPARATOR",
				"SEPARATOR",
				TEXT(UUI_SSM_SEP_TEXT),
				TEXT(UUI_SSM_SEP_INFO)
				);
	
			UltimateUI_RegisterConfiguration(
				"UUI_SSM_SEND_MESSAGE_ENABLE",	--CVar
				"CHECKBOX",						--Things to use
				TEXT(UUI_SSM_SEND_MESSAGE_ENABLE_TEXT),
				TEXT(UUI_SSM_SEND_MESSAGE_ENABLE_INFO),
				SSM_SendMessageEnable,		--Callback
				1							--Default Checked/Unchecked
				);
		
			UltimateUI_RegisterConfiguration(
				"UUI_SSM_SEND_PAGE_ENABLE",	--CVar
				"CHECKBOX",					--Things to use
				TEXT(UUI_SSM_SEND_PAGE_ENABLE_TEXT),
				TEXT(UUI_SSM_SEND_PAGE_ENABLE_INFO),
				SSM_SendPageEnable,			--Callback
				1							--Default Checked/Unchecked
				);

			isLoaded = true;
		end
	
		-- this makes the guild roster NOT show offline by default
		SetGuildRosterShowOffline(0);
		--this:SetChecked(GetGuildRosterShowOffline());
	end
end

function SocialSendMessage_OnEvent()
--[[
	if (nil == arg1) then
		print1(format("SocialSendMessage_OnEvent:%s: {}.", event));
	else
		if (nil == arg2) then
			print1(format("SocialSendMessage_OnEvent:%s: {%s}.", event, arg1));
		else
			print1(format("SocialSendMessage_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
]]
	if (event == "VARIABLES_LOADED") then
		if (UUI_SSM_SEND_MESSAGE_ENABLE == nil) then
			UUI_SSM_SEND_MESSAGE_ENABLE = 1;
		end
		SSM_SendMessageEnable(UUI_SSM_SEND_MESSAGE_ENABLE);

		if (UUI_SSM_SEND_PAGE_ENABLE == nil) then
			UUI_SSM_SEND_PAGE_ENABLE = 1;
		end
		SSM_SendPageEnable(UUI_SSM_SEND_PAGE_ENABLE);
	end
end

function SocialSendMessage_OnUpdate()
	-- print1("SocialSendMessage_OnUpdate.");

	if (not SSM_TimeSinceLastUpdate) then
		SSM_TimeSinceLastUpdate = SSM_UPDATE_RATE;
	end

	SSM_TimeSinceLastUpdate = SSM_TimeSinceLastUpdate + arg1;

	if ( SSM_TimeSinceLastUpdate > SSM_UPDATE_RATE ) then
		SSM_Update();
		SSM_TimeSinceLastUpdate = 0.0;
	end
end

function SocialSendMessage_SendMessage(name)
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
end

function SocialSendMessage_SendPage(name)
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
end

--[[

	SocialSendMessage: Adds a "Send Message" button to the Social frames that do not have one.
	- by geowar 5 Sep, 2004.
	- added a "Send Page" button 6 Sep, 2004 - geowar
	- added SocialNotes 4 Feb, 2005 - GeoWar (Keep notes about other players!)
]]

-- Configuration variables
local UUI_SN_ENABLE = 1;				-- enable the Social Notes
local UUI_SN_EDIT_NOTE_ENABLE = 1;		-- enable the 'Edit Note' button

-- Constants

local SN_UPDATE_RATE = 0.33;

-- external globals (exported)

--SocialNotes = {}; -- These are now in <SocialNotesEditor.lua>

-- local (non exported) globals

local SN_Ready = false;	-- only true after VARIABLES_LOADED event
local SN_TimeSinceLastUpdate = false;

-- local functions (only called internally)

local function SN_Save()
	RegisterForSave("UUI_SN_ENABLE");
	RegisterForSave("UUI_SN_EDIT_NOTE_ENABLE");
	--RegisterForSave("SocialNotes");
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
		if (UUI_SN_ENABLE == 1) then
			if ( not name ) then
				name = UNKNOWN;
			end
		
			button.title = name;
			button.tooltip = false;

			if (SocialNotes) then
				for key,value in SocialNotes do
					-- print1("key: "..asText(key)..", value: "..asText(value)..".");
					if (value and value.title and value.body) then
						if (value.title == name) then
							button.tooltip = value.body;
							break;
						end
					end
				end
			end
		
			if (UUI_SN_EDIT_NOTE_ENABLE == 1) then
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
	local isConnected = true; -- UnitIsConnected(selectedName);

	if (UUI_SN_EDIT_NOTE_ENABLE == 1) then
		if ( selectedName and isConnected) then
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
end

-- exported functions

function SN_NotesEnable(toggle)
	-- print1("SN_NotesEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		UUI_SN_ENABLE = 1;
	else
		UUI_SN_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_NotesEnableToggle()
	if (UUI_SN_ENABLE == 1) then
		SN_NotesEnable(0);
	else
		SN_NotesEnable(1);
	end
end

function SN_EditNoteEnable(toggle)
	-- print1("SN_EditNoteEnable("..asText(toggle)..")");
	if (toggle == 1) then 
		UUI_SN_EDIT_NOTE_ENABLE = 1;
	else
		UUI_SN_EDIT_NOTE_ENABLE = 0;
	end
	SN_Save();
	SN_Update();
end

function SN_EditNoteEnableToggle()
	-- print1("SN_EditNoteEnableToggle");
	if (UUI_SN_EDIT_NOTE_ENABLE == 1) then
		SN_EditNoteEnable(0);
	else
		SN_EditNoteEnable(1);
	end
end

-- OnFoo functions

function SocialNotes_OnLoad()
	-- print1("SocialNotes_OnLoad");
	
	this:RegisterEvent("VARIABLES_LOADED");

	if (UltimateUI_RegisterConfiguration ~= nil) then
		UltimateUI_RegisterConfiguration(
			"UUI_SSM",
			"SECTION",
			TEXT(UUI_SSM_SEP_TEXT),
			TEXT(UUI_SSM_SEP_INFO)
			);
		UltimateUI_RegisterConfiguration(
			"UUI_SN_ENABLE",			--CVar
			"CHECKBOX",					--Things to use
			TEXT(UUI_SN_ENABLE_TEXT),
			TEXT(UUI_SN_ENABLE_INFO),
			SN_NotesEnable,				--Callback
			1							--Default Checked/Unchecked
			);
		UltimateUI_RegisterConfiguration(
			"UUI_SN_EDIT_NOTE_ENABLE",	--CVar
			"CHECKBOX",					--Things to use
			TEXT(UUI_SSM_EDIT_NOTE_ENABLE_TEXT),
			TEXT(UUI_SSM_EDIT_NOTE_ENABLE_INFO),
			SN_EditNoteEnable,			--Callback
			1							--Default Checked/Unchecked
			);
	end
end

function SocialNotes_OnEvent()
--[[
	if (nil == arg1) then
		print1(format("SocialNotes_OnEvent:%s: {}.", event));
	else
		if (nil == arg2) then
			print1(format("SocialNotes_OnEvent:%s: {%s}.", event, arg1));
		else
			print1(format("SocialNotes_OnEvent:%s: {%s, %s}.", event, arg1, arg2));
		end
	end
]]
	if (event == "VARIABLES_LOADED") then
		if (UUI_SN_ENABLE == nil) then
			UUI_SN_ENABLE = 1;
		end
		SN_NotesEnable(UUI_SN_ENABLE);

		if (UUI_SN_EDIT_NOTE_ENABLE == nil) then
			UUI_SN_EDIT_NOTE_ENABLE = 1;
		end
		SN_EditNoteEnable(UUI_SN_EDIT_NOTE_ENABLE);

		SN_Ready = true;
	end
end

local SN_FN_TimeSinceLastUpdate = false;

function SocialNotes_OnUpdate()
	if (not SN_FN_TimeSinceLastUpdate) then
		SN_FN_TimeSinceLastUpdate = SN_UPDATE_RATE;
	end

	SN_FN_TimeSinceLastUpdate = SN_FN_TimeSinceLastUpdate + arg1;

	if ( SN_FN_TimeSinceLastUpdate > SN_UPDATE_RATE ) then
		-- print1("SocialNotes_OnUpdate");
		SN_Update();

		SN_FN_TimeSinceLastUpdate = 0.0;
	end
end

function SocialNotes_OnClick(arg1)
	-- print1("SocialNotes_OnClick("..asText(name)..").");

	local name = this.title;

	if (not name) then
		name = SSM_GetSelectedName();
	end
	
	if (name) then
		SocialNotesEditor_EditPlayerNote(name);
	end
end

function SocialNotes_OnEnter()
	-- print1("SocialNotes_OnEnter");

	GameTooltip_AddNewbieTip(UUI_SN_NOTES, 1.0, 1.0, 1.0, UUI_SN_NOTES_NEWBIE_TOOLTIP, 1);

	if (this.tooltip) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		GameTooltip:SetText(this.tooltip);
	end
end
