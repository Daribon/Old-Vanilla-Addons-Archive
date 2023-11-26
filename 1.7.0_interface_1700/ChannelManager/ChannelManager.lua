--------------------------------------------------------------------------
-- ChannelManager.lua 
--------------------------------------------------------------------------
--[[
Channel Manager 
	Managing your channels.
	
Features:
-ChannelVisibility remembers what chatframes your channels are visible in so that when you join a channel it is made visible in all the channels it was visible in before you left it.
-Safer Out-Of-Zone (OOZ) channels are left whenever you logout/quit/reload and reloaded when next you log in.
(note that if you crash or freeze while in an OOZ channel it will create an 'undead' channel (a channel that you can't talk in, leave or see but takes up a channel slot)
-Channel, Emote and Sticky Management Tabs and drawer attaches the side of ChatFrame1
-These tabs show using the same logic as the ChatFrame1 Tab. If you mouse over the tabs apear and the background texture alpha transparency is increased if lower than a set minimum.
-Channel Management Tab:
Button to print channel list or look for checked channels in the list,
Easily join common Out-Of-Zone Channels,
Custom channels and channel passwords are saved for future use
-Emote Management Tab:
Click to use any of the builtin emotes: Action, Voise or Text,
Specify and save a favorites list of emotes
-Sticky Management Tab:
Select what chat types you want to be sticky,
Click on any of availible chat types to send a message of that type or change the current message to that type
-Smart Tab/Drawer Positioning. The tabs will stay on the opposite side of the chat frame from the up/down/bottom scroll buttons. If you move the frame to the right side of the screen the ChannelManagerFrame and tabs will move to the left side and visa versa.

ToDo:
Make ChannelVisibility character specific.


By: AnduinLothar    <KarlKFI@cosmosui.org>

Change Log:
1.0
-Public Stand-alone Release seperate but dependant upon Sky
-Fixed sticky toggle tooltip
-Fixed Emote Favorites saving
-Channel Visibility should eb remembered across sessions
-Channels joined that weren't previously visible in any chatframes will automaticly be visible in the current chatframe.
(be aware that this can end up in your combatlog if you clicked on that frame last)

1.01
-Bug fix for clicking Join New Channel before using the chat tab menu.

1.1
-Updated TOC to 1500
-Fixed Tab offsets
-Updated german capitol cities
-Made CM tabs still appear when chat settings are locked
-Fixed emotes to work with targets with spaces in their names.

1.2
-Added French and German localizations
-Fixed an error with oversized trees maxing out EarthTree's alotted title frames.

1.3
-Fixed ChatTab MouseOver Visibility Functionality (I hate that 200 line function)
(Animation is smoother without the choppy showing, whisper tab flashing now works correctly)

	$Id$
	$Rev$
	$LastChangedBy$
	$Date$
]]--

-- Debug
CHANNEL_MANAGER_DEBUG = false;

-- Formatting
ZONE_CHANNEL_FORMAT = "%s - %s";

-- Saved Variables
ChannelManager_StickyChannels = false;
ChannelManager_SavedStickyTypes = {
	["SAY"] = ChatTypeInfo["SAY"].sticky,
	["PARTY"] = ChatTypeInfo["PARTY"].sticky,
	["RAID"] = ChatTypeInfo["RAID"].sticky,
	["GUILD"] = ChatTypeInfo["GUILD"].sticky,
	["OFFICER"] = ChatTypeInfo["OFFICER"].sticky,
	["YELL"] = ChatTypeInfo["YELL"].sticky,
	["WHISPER"] = ChatTypeInfo["WHISPER"].sticky,
	["REPLY"] = ChatTypeInfo["REPLY"].sticky,
	["EMOTE"] = ChatTypeInfo["EMOTE"].sticky
};
ChannelVisibility = {};
ChannelManager_CustomChannelPasswords = {};
ChannelManager_CustomChannels = {};
ChannelManager_FavoriteEmotes = {};

-- Standard Channel Order
STANDARD_CHANNEL_ORDER = {
	[SKY_GENERAL_ID] = 1,
	[SKY_TRADE_ID] = 2,
	[SKY_LFG_ID] = 3,
	[SKY_LOCALDEFENSE_ID] = 4,
	[SKY_WORLDDEFENSE_ID] = 5,
	[SKY_ZONE] = 6,
	[SKY_GUILD] = 7,
	[SKY_RAID] = 8,
	[SKY_PARTY] = 9,
	[SKY_CHANNEL] = 10
};

BOGUS_CHANNELS = {
	"morneusgbyfyh",
	"akufbhfeuinjke",
	"lkushawdewui",
	"auwdbadwwho",
	"uawhbliuernb",
	"nvcuoiisnejfk",
	"cmewhumimr",
	"cliuchbwubine",
	"omepwucbawy",
	"yuiwbefmopou"
};


ChannelManager = {
	
	DelayReloadUIBoolean = false;
	
	DelayReloadUIInterval = 1; -- second(s)
	
	trueReloadUI = nil;
	--Set OnLoad
	
	delayedReloadUI = function()
		if (ChannelManager.DelayReloadUIBoolean) then
			ChannelManager.leaveZonedChannels();
			Sea.io.printfc(SELECTED_CHAT_FRAME,  ChatTypeInfo["SYSTEM"], "ReloadUI in ",ChannelManager.DelayReloadUIInterval," sec.");
			Chronos.schedule(ChannelManager.DelayReloadUIInterval, ChannelManager.trueReloadUI);
		else
			ChannelManager.trueReloadUI()
		end
	end;
	
	--
	--	setChannelManagerSwitch (state)
	--		Put ChannelManager online or offline
	--
	--
	--	args:
	--		state - if nil, false, 0 or "off", turn it off. otherwise turn it on.
	--
	setChannelManagerSwitch = function ( state ) 
		--### Rename later

		if ( not state or state == 0 or state == "off" ) then 
			Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "ChannelManager Off");
			ChannelManager.online = false;
			ChannelManager.DelayReloadUIBoolean = false;
			
			Sea.util.unhook("ChatFrame_OnEvent", "ChannelManager_ChatFrame_OnEvent_After", "after");
			Sea.util.unhook("Logout", "ChannelManager.leaveZonedChannels", "before");
			--Sea.util.unhook("ForceLogout", "ChannelManager.leaveZonedChannels", "before");
			--Sea.util.unhook("ForceQuit", "ChannelManager.leaveZonedChannels", "before");
			Sea.util.unhook("Quit", "ChannelManager.leaveZonedChannels", "before");
			Sea.util.unhook("CancelLogout", "ChannelManager.joinSavedZonedChannels", "after");
			Sea.util.unhook("FCFDropDown_LoadServerChannels", "ChannelManager_FCFDropDown_LoadServerChannels_Override", "replace");
			Sea.util.unhook("FCFServerChannelsDropDown_OnClick", "ChannelManager_FCFServerChannelsDropDown_OnClick_Override", "replace");
			--Sea.util.unhook("SkyTrueJoinChannel", "ChannelManager.joinChannel", "before");
			Sea.util.unhook("JoinChannelByName", "ChannelManager.joinChannel", "after");
			Sea.util.unhook("AddChatWindowChannel", "ChannelManager_AddChatWindowChannel", "before");
			Sea.util.unhook("RemoveChatWindowChannel", "ChannelManager_RemoveChatWindowChannel", "before");
			
			Sea.util.unhook("FCF_SetWindowColor", "ChannelManager_FCF_SetWindowColor", "after");
			Sea.util.unhook("FCF_SetWindowAlpha", "ChannelManager_FCF_SetWindowAlpha", "after");
			Sea.util.unhook("FCF_SetButtonSide", "ChannelManager_FCF_SetButtonSide_before", "before");
			
			Sea.util.unhook("ChatEdit_UpdateHeader", "ChannelManager.updateChatHeader ", "after"); 
		else
			Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "ChannelManager On");
			ChannelManager.online = true;
			ChannelManager.DelayReloadUIBoolean = true;
			
			Sea.util.hook("ChatFrame_OnEvent", "ChannelManager_ChatFrame_OnEvent_After", "after");
			Sea.util.hook("Logout", "ChannelManager.leaveZonedChannels", "before");
			--Sea.util.hook("ForceLogout", "ChannelManager.leaveZonedChannels", "before");
			--Sea.util.hook("ForceQuit", "ChannelManager.leaveZonedChannels", "before");
			Sea.util.hook("Quit", "ChannelManager.leaveZonedChannels", "before");
			Sea.util.hook("CancelLogout", "ChannelManager.joinSavedZonedChannels", "after");
			Sea.util.hook("FCFDropDown_LoadServerChannels", "ChannelManager_FCFDropDown_LoadServerChannels_Override", "replace");
			Sea.util.hook("FCFServerChannelsDropDown_OnClick", "ChannelManager_FCFServerChannelsDropDown_OnClick_Override", "replace");
			--Sea.util.hook("SkyTrueJoinChannel", "ChannelManager.joinChannel", "before");
			Sea.util.hook("JoinChannelByName", "ChannelManager.joinChannel", "after");
			Sea.util.hook("AddChatWindowChannel", "ChannelManager_AddChatWindowChannel", "before");
			Sea.util.hook("RemoveChatWindowChannel", "ChannelManager_RemoveChatWindowChannel", "before");
			
			Sea.util.hook("FCF_SetWindowColor", "ChannelManager_FCF_SetWindowColor", "after");
			Sea.util.hook("FCF_SetWindowAlpha", "ChannelManager_FCF_SetWindowAlpha", "after");
			Sea.util.hook("FCF_SetButtonSide", "ChannelManager_FCF_SetButtonSide_before", "before");
			
			Sea.util.hook("ChatEdit_UpdateHeader", "ChannelManager.updateChatHeader ", "after"); 
		end
	end;
	
	--
	-- 	activate()
	--		Turns ChannelManager on 
	--
	activate = function()
		if ( not ChannelManager.online ) then 
			ChannelManager.setChannelManagerSwitch("on");
		end
	end;



	--
	--  initChannelVisibility()
	--      Used to setup the ChannelVisibility.
	--
	initChannelVisibility = function()
		Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "Initing ChannelVisibility");
		local noVisibleChannels = true;
		for channel, chanVisibility in ChannelVisibility do
			if (chanVisibility) then
				noVisibleChannels = false;
				break;
			end
		end

		local resettingChatFrame7 = false;
		local chatFrame;
		if (noVisibleChannels) then
			for chatFrameID = 1, NUM_CHAT_WINDOWS do
				chatFrame = getglobal("ChatFrame"..chatFrameID);
				for id, channelName in chatFrame.channelList do
					if (chatFrameID == 7) then
						resettingChatFrame7 = true;
					else
						-- Initializing ChannelVisibility with visible channels
						ChannelManager_AddChatWindowChannel(chatFrameID, channelName);
						Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "Initing ",channelName," on frame ",chatFrameID);
					end
				end
			end
		end

		if (resettingChatFrame7) then
			ChannelManager.resetChannelVisibility();
		end
	end;
	
	--
	--  resetChannelVisibility()
	--      resets the visibility of all the monitored channels in all the chat frames to the stored settings in ChannelVisibility
	--
	resetChannelVisibility = function()
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		local chatFrame;
		local tempChannelVisibility = Sea.table.copy(ChannelVisibility);
		for chatFrameID = 1, NUM_CHAT_WINDOWS do
			-- Remove all
			chatFrame = getglobal("ChatFrame"..chatFrameID);
			for id, channelName in chatFrame.channelList do
				ChatFrame_RemoveChannel(chatFrame, channelName);
			end
		end
		
		-- Re-add Stored values.
		for channel, chanVisibility in tempChannelVisibility do
			for chatFrameID, isVisible in chanVisibility do
				if (isVisible) then
					ChatFrame_AddChannel(getglobal("ChatFrame"..chatFrameID), channel);
				end
			end
		end
	end;
	
	-- 
	-- 	joinChannel ( channel, pass, chatFrameID, silent )
	--		intercepts joined channels and saves their password
	-- 	
	--	args:
	--		channel - the channel name
	--
	--		 Optional:
	--		pass - the channel's password
	--		index - the new channel /# 
	--		silent - doesn't print any extra messages (except default blizzard ones when the channel is visible in that chatframe)
	--		
	joinChannel = function(channel, pass, chatFrameID, silent)

		-- Invalid channel
		if ( not channel ) or (type(pass) ~= "string") then
			return;
		end
		
		-- Save/Update the password
		if (ChannelManager_CustomChannelPasswords) and (pass ~= ChannelManager_CustomChannelPasswords[channel]) then
			if ( not silent ) then Sea.io.printfc(SELECTED_CHAT_FRAME,  ChatTypeInfo["CHANNEL_NOTICE"], string.format(CHANNEL_PASSWORD_UPDATED, channel, pass) ) end;
			ChannelManager_CustomChannelPasswords[channel] = pass;
		end
		
		-- Save/Update custom channels
		if (SkyChannelManager.isCustomChannel(channel)) then
			ChannelManager_CustomChannels[channel] = time();
		end

	end;
	
	hideBogusChannelJoinLeaveAlerts = function ()
		for index, channel in BOGUS_CHANNELS do
			SkyChannelManager.hideJoinLeaveAlerts(channel);
		end
	end;
	
	showBogusChannelJoinLeaveAlerts = function ()
		for index, channel in BOGUS_CHANNELS do
			SkyChannelManager.showJoinLeaveAlerts(channel);
		end
	end;
	
	
	--
	--	reorderChannels()
	--		Stores current channels, Leaves all channels and then rejoins them in a standard ordering.
	--		
	--
	reorderChannels = function()
		if UnitOnTaxi("player") then
			Sea.io.printfc(SELECTED_CHAT_FRAME,  ChatTypeInfo["SYSTEM"], CHANNEL_REORDER_FLIGHT_FAIL);
			-- For some reason channels do not register join/leave in a reasonable amount of time while in transit.
			return;
		end
		local currIdentifier = nil;
		local newChannelOrder = {};
		local openChannelIndex = 1;
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		local simpleName = nil;
		
		-- Find current standard channels: store and leave
		for k,v in currChannelList do
			if (type(v) == "string") then
				currIdentifier = SkyChannelManager.convertToChannelIdentifier(v);
				simpleName = SkyChannelManager.convertToSimpleChannelName(v);
				if (STANDARD_CHANNEL_ORDER[currIdentifier]) then
					if ( SkyChannelManager.isSkyChannel(v) ) or (string.lower(v) == string.lower(simpleName)) then 
						newChannelOrder[STANDARD_CHANNEL_ORDER[currIdentifier]] = v;
						LeaveChannelByName(v, true);
						currChannelList[k] = nil;
					end
				end
			end
		end
		--Sea.io.printTable(currChannelList);
		-- Find current non-standard channels: store and leave
		for k,v in currChannelList do
			if (v) then
				while (newChannelOrder[openChannelIndex]) do
					openChannelIndex = openChannelIndex + 1;
				end
				newChannelOrder[openChannelIndex] = v;
				LeaveChannelByName(v, true);
				openChannelIndex = openChannelIndex + 1;
			end
		end
		
		--Sea.io.printTable(newChannelOrder);
		Sea.io.print(CHANNEL_REORDER_START);
		Chronos.schedule(.6, ChannelManager.joinChannelsInOrder, newChannelOrder);
		Chronos.schedule(1.2, function() Sea.io.print(CHANNEL_REORDER_END); end );
		Chronos.schedule(2, SkyChannelManager.printChatList );
	end;
	
	joinChannelsInOrder = function(newChannelOrder)
		
		local inACity = Sea.list.isInList(CAPITAL_CITIES, GetRealZoneText());
		
		-- Join channels in new order
		for i=1, 10 do
			if (newChannelOrder[i]) then
				if (ChannelManager_CustomChannelPasswords[newChannelOrder[i]]) then
					JoinChannelByName(newChannelOrder[i], ChannelManager_CustomChannelPasswords[newChannelOrder[i]], nil, true);
				else
					JoinChannelByName(newChannelOrder[i], nil, nil, true);
				end
			else
				-- Allow for hidden trade channel (Unfortunetly if you're not in a city and wasn't in trade then numbers will be slightly off)
				if ( inACity ) or (STANDARD_CHANNEL_ORDER[SKY_TRADE_ID] ~= i) then
					JoinChannelByName(BOGUS_CHANNELS[i], nil, nil, true);
				end
			end
		end
		Chronos.schedule(.6, ChannelManager.leaveExtraChannels, newChannelOrder );
	end;
	
	leaveExtraChannels = function(newChannelOrder)
	
		-- Leave the extra channels
		for i=1, 10 do
			if (not newChannelOrder[i]) then
				LeaveChannelByName(BOGUS_CHANNELS[i], true);
			end
		end

	end;
	
	
	leaveZonedChannels = function()
		local simple;
		local foundZoneChannel;
		ChannelManager_SavedZoneChannels = {};
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		for k,v in currChannelList do
			if (not SkyChannelManager.isSkyChannel(v)) then
				simple = SkyChannelManager.convertToSimpleChannelName(v);
				if (string.lower(simple) ~= string.lower(v)) then
					ChannelManager_SavedZoneChannels[k] = v;
					LeaveChannelByName(k);
					foundZoneChannel = true;
				end
			end
		end
		if (foundZoneChannel) then
			JoinChannelByName(BOGUS_CHANNELS[10], nil, nil, true);
			Chronos.schedule(.4, LeaveChannelByName, BOGUS_CHANNELS[10], true);
		end
	end;
	
	joinSavedZonedChannels = function()
		if ( type(ChannelManager_SavedZoneChannels) ~= "table" ) then
			return;
		end
		
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		local lastSavedIndex = 0;
		for k,v in ChannelManager_SavedZoneChannels do
			if (type(v) == "string")then
				lastSavedIndex = k;
			end
		end
		
		for i=1, 10 do
			if (ChannelManager_SavedZoneChannels[i]) then
				JoinChannelByName(ChannelManager_SavedZoneChannels[i], nil, nil, false);
				currChannelList[i] = ChannelManager_SavedZoneChannels[i];
			elseif (not currChannelList[i]) and (i <= lastSavedIndex) then
				JoinChannelByName(BOGUS_CHANNELS[i], nil, nil, true);
			end
		end
		
		Chronos.schedule(.4, ChannelManager.leaveExtraChannels, currChannelList);
		ChannelManager_SavedZoneChannels = nil;
	end;
	
	-- ctype is key in ChatTypeInfo
	-- state can be 1/true or 0/false
	setSticky = function(ctype, state)
		if (state == true) then
			state = 1;
		end
		if (ctype == "CHANNEL") then
			ChannelManager_StickyChannels = (state == 1);
			Sky.updateSlashCommand( { id = "SkyChannelManager", sticky = ChannelManager_StickyChannels } );
		elseif (ChatTypeInfo[ctype]) then
			ChatTypeInfo[ctype].sticky = state;
			ChannelManager_SavedStickyTypes[ctype] = state;
		end
		
		if (ChannelManager_DrawerState) and (ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].tree == "STICKY_TREE") then
			ChannelManagerGUI[ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].update]();
		end
	end;
	
	updateStickies = function()
		for ctype, state in ChannelManager_SavedStickyTypes do
			ChatTypeInfo[ctype].sticky = state;
		end
		Sky.updateSlashCommand( { id = "SkyChannelManager", sticky = ChannelManager_StickyChannels } );
	end;
	
	updateChatHeader = function(editBox)
		local type = editBox.chatType;
		if ( not type ) then return; end
		local header = getglobal(editBox:GetName().."Header");
		if ( not header ) then return; end
		if ( type == "CHANNEL" ) then
			local chanNum, channelName = Sky.isChannelActive(editBox.channelTarget);
			if (chanNum) and (channelName) then
				header:SetText(format(CHAT_CHANNEL_SEND, chanNum, channelName));
			end
		end
	end;
};



ChannelManagerGUI = {
	
	BG_TEXTURES = {
		"Background",
		"ResizeTopRightTexture",
		"ResizeBottomRightTexture",
		"ResizeRightTexture",
		"ResizeTopTexture",
		"ResizeBottomTexture",
		"ResizeLeftTexture",
		"ResizeBottomLeftTexture",
		"ResizeTopLeftTexture"
	};
	
	DRAWER_TAB_INFO = {
		{
			tree = "CHANNEL_TREE",
			update = "updateChannelTree",
			textureUp = "Interface\\AddOns\\ChannelManager\\Skin\\UI-MicroButton-TownWatch-Up",
			textureDown = "Interface\\AddOns\\ChannelManager\\Skin\\UI-MicroButton-TownWatch-Down",
			openTooltip = string.format(CHANNEL_MANAGER_HIDE_X_DRAWER, CHANNELS),
			closedTooltip = string.format(CHANNEL_MANAGER_SHOW_X_DRAWER, CHANNELS)
		},
		{
			tree = "EMOTE_TREE",
			update = "updateEmoteTree",
			textureUp = "Interface\\AddOns\\ChannelManager\\Skin\\UI-MicroButton-BattleShout-Up",
			textureDown = "Interface\\AddOns\\ChannelManager\\Skin\\UI-MicroButton-BattleShout-Down",
			openTooltip = string.format(CHANNEL_MANAGER_HIDE_X_DRAWER, CHAT_MSG_EMOTE),
			closedTooltip = string.format(CHANNEL_MANAGER_SHOW_X_DRAWER, CHAT_MSG_EMOTE)
		},
		{
			tree = "STICKY_TREE",
			update = "updateStickyTree",
			textureUp = "Interface\\AddOns\\ChannelManager\\Skin\\UI-MicroButton-Marksmanship-Up",
			textureDown = "Interface\\AddOns\\ChannelManager\\Skin\\UI-MicroButton-Marksmanship-Down",
			openTooltip = string.format(CHANNEL_MANAGER_HIDE_X_DRAWER, TEXT_STICKY),
			closedTooltip = string.format(CHANNEL_MANAGER_SHOW_X_DRAWER, TEXT_STICKY)
		},
	};
	
	STICKY_TREE = {
		{ title=CHANNEL_MANAGER_STICKY_OPTIONS, titleColor=GRAY_FONT_COLOR, disabled=true },
		{ title=CHAT_MSG_SAY, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_SAY), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_SAY), check=true, checked=(ChatTypeInfo["SAY"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("SAY", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "SAY"); end },
		{ title=CHAT_MSG_PARTY, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_PARTY), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_PARTY), check=true, checked=(ChatTypeInfo["PARTY"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("PARTY", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "PARTY"); end },
		{ title=CHAT_MSG_RAID, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_RAID), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_RAID), check=true, checked=(ChatTypeInfo["RAID"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("RAID", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "RAID"); end },
		{ title=CHAT_MSG_GUILD, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_GUILD), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_GUILD), check=true, checked=(ChatTypeInfo["GUILD"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("GUILD", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "GUILD"); end },
		{ title=CHAT_MSG_OFFICER, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_OFFICER), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_OFFICER), check=true, checked=(ChatTypeInfo["OFFICER"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("OFFICER", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "OFFICER"); end },
		{ title=YELL_MESSAGE, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, YELL_MESSAGE), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, YELL_MESSAGE), check=true, checked=(ChatTypeInfo["YELL"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("YELL", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "YELL"); end },
		{ title=CHAT_MSG_WHISPER_INFORM, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_WHISPER_INFORM), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_WHISPER_INFORM), check=true, checked=(ChatTypeInfo["WHISPER"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("WHISPER", check) end, onClick=function() if (UnitName("target")) and (UnitIsPlayer("target")) then ChatFrame_SendTell(UnitName("target"), ChannelManagerFrame:GetParent()) end end },
		{ title=REPLY_MESSAGE, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, REPLY_MESSAGE), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, REPLY_MESSAGE), check=true, checked=(ChatTypeInfo["REPLY"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("REPLY", check) end, onClick=function() ChatFrame_ReplyTell(ChannelManagerFrame:GetParent()) end },
		{ title=CHAT_MSG_EMOTE, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHAT_MSG_EMOTE), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHAT_MSG_EMOTE), check=true, checked=(ChatTypeInfo["EMOTE"].sticky == 1), onCheck=function(check) ChannelManager.setSticky("EMOTE", check) end, onClick=function() ChatMenu_SetChatType(ChannelManagerFrame:GetParent(), "EMOTE") end },
		{ title=CHANNELS, tooltip=string.format(CHANNEL_MANAGER_SEND_X_MESSAGE, CHANNELS), checkTooltip=string.format(CHANNEL_MANAGER_TOGGLE_X_STICKY_STATUS, CHANNELS), check=true, checked=(ChannelManager_StickyChannels), onCheck=function(check) ChannelManager.setSticky("CHANNEL", check) end }
	};
	
	EMOTE_TREE = {
		{ title=TEXT_FAVORITE_EMOTES, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
		{ title=TEXT_ACTION_EMOTES, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
		{ title=TEXT_VOICE_EMOTES, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
		{ title=TEXT_TEXT_EMOTES, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
	};
	
	CHANNEL_TREE = {
		{ title=JOIN_NEW_CHANNEL, onClick=FCF_JoinNewChannel },
		{ title=PRINT_CHAT_LIST, onClick=ListChannels },
		{ title=REORDER_CHANNELS, onClick=ChannelManager.reorderChannels },
		{ title=SERVER_CHANNELS, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
		{ title=TEXT_ZONE_CHANNELS, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
		{ title=TEXT_SKY_CHANNELS, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
		{ title=TEXT_CUSTOM_CHANNELS, titleColor=GRAY_FONT_COLOR, disabled=true, children={} },
	};
	
	updateStickyTree = function()
		local capsTitle;
		for index, info in ChannelManagerGUI.STICKY_TREE do
			if (info.title) then
				capsTitle = strupper(info.title);
				if (capsTitle == "CHANNEL") then
					ChannelManagerGUI.STICKY_TREE[index].checked=(ChannelManager_StickyChannels);
				elseif (ChatTypeInfo[capsTitle]) then
					ChannelManagerGUI.STICKY_TREE[index].checked=(ChatTypeInfo[capsTitle].sticky == 1);
				end
			end
		end
		
		EarthTree_LoadEnhanced(ChannelManagerFrameContainerTree, ChannelManagerGUI.STICKY_TREE );
		EarthTree_UpdateFrame(ChannelManagerFrameContainerTree);
	end;
	
	updateEmoteTree = function()
		ChannelManagerGUI.EMOTE_TREE[1].children = {};
		for key, value in ChannelManager_FavoriteEmotes do
			local emote = key;
			table.insert(ChannelManagerGUI.EMOTE_TREE[1].children, 
				{
					title=emote,
					tooltip=string.format(CHANNEL_MANAGER_USE_X_EMOTE, emote).."\n"..CHANNEL_MANAGER_REMOVE_RECORD,
					onClick=function()
						if (arg1 == "RightButton") then
							ChannelManager_FavoriteEmotes[emote]=nil;
							ChannelManagerGUI.updateEmoteTree();
						else
							DoEmote(emote)
						end
					end
				}
			);
		end
		
		ChannelManagerGUI.EMOTE_TREE[2].children = {};
		for key, value in EmoteList do
			local emote = value;
			table.insert(ChannelManagerGUI.EMOTE_TREE[2].children, 
				{
					title=emote,
					check=true,
					checked=(ChannelManager_FavoriteEmotes[emote]),
					checkTooltip=string.format(CHANNEL_MANAGER_ADD_REMOVE_X_FAVORITE, emote),
					onCheck=function(check)
						if (check) then
							ChannelManager_FavoriteEmotes[emote] = GetTime();
						else
							ChannelManager_FavoriteEmotes[emote] = nil;
						end
						ChannelManagerGUI.updateEmoteTree();
					end,
					tooltip=string.format(CHANNEL_MANAGER_USE_X_EMOTE, emote),
					onClick=function()
						DoEmote(emote)
					end
				}
			);
		end
		
		ChannelManagerGUI.EMOTE_TREE[3].children = {};
		for key, value in TextEmoteSpeechList do
			local emote = value;
			table.insert(ChannelManagerGUI.EMOTE_TREE[3].children, 
				{
					title=emote,
					check=true,
					checked=(ChannelManager_FavoriteEmotes[emote]),
					checkTooltip=string.format(CHANNEL_MANAGER_ADD_REMOVE_X_FAVORITE, emote),
					onCheck=function(check)
						if (check) then
							ChannelManager_FavoriteEmotes[emote] = GetTime();
						else
							ChannelManager_FavoriteEmotes[emote] = nil;
						end
						ChannelManagerGUI.updateEmoteTree();
					end,
					tooltip=string.format(CHANNEL_MANAGER_USE_X_EMOTE, emote),
					onClick=function()
						DoEmote(emote)
					end
				}
			);
		end
		
		ChannelManagerGUI.EMOTE_TREE[4].children = {};
		local i = 1;
		while getglobal("EMOTE"..i.."_TOKEN") do
			local emote = getglobal("EMOTE"..i.."_TOKEN");
			table.insert(ChannelManagerGUI.EMOTE_TREE[4].children, 
				{
					title=emote,
					check=true,
					checked=(ChannelManager_FavoriteEmotes[emote]),
					checkTooltip=string.format(CHANNEL_MANAGER_ADD_REMOVE_X_FAVORITE, emote),
					onCheck=function(check)
						if (check) then
							ChannelManager_FavoriteEmotes[emote] = GetTime();
						else
							ChannelManager_FavoriteEmotes[emote] = nil;
						end
						ChannelManagerGUI.updateEmoteTree();
					end,
					tooltip=string.format(CHANNEL_MANAGER_USE_X_EMOTE, emote),
					onClick=function()
						DoEmote(emote)
					end
				}
			);
			i = i+1;
		end
		
		EarthTree_LoadEnhanced(ChannelManagerFrameContainerTree, ChannelManagerGUI.EMOTE_TREE );
		EarthTree_UpdateFrame(ChannelManagerFrameContainerTree);
	end;
	
	updateChannelTree = function()
		ChannelManagerGUI.CHANNEL_TREE[4].children = {};
		for key, value in SKY_SERVER_CHANNELS do
			local channel = SKY_PRETTYPRINT[value];
			table.insert(ChannelManagerGUI.CHANNEL_TREE[4].children, 
				{
					title=channel,
					check=true,
					checkDisabled=true,
					checked=Sky.isChannelActive(channel),
					tooltip=string.format(CHANNEL_MANAGER_JOIN_LEAVE_X_CHANNEL, channel),
					onClick=function()
						if (Sky.isChannelActive(channel)) then
							LeaveChannelByName(channel);
						else
							JoinChannelByName(channel);
						end
					end
				}
			);
		end
		
		ChannelManagerGUI.CHANNEL_TREE[5].children = {};
		local zoneChannels;
		if (UnitFactionGroup("player") == "Alliance") then
			zoneChannels = CAPITAL_CITIES_ALLIANCE;
		else
			zoneChannels = CAPITAL_CITIES_HORDE;
		end
		local zoneNumber = 0;
		for key, zone in zoneChannels do
			-- Don't display zone channels for the zone you're currently in.
			if (GetRealZoneText() ~= zone) then
				zoneNumber = zoneNumber+1;
				table.insert(ChannelManagerGUI.CHANNEL_TREE[5].children, 
					{ title=zone, titleColor=GRAY_FONT_COLOR, disabled=true, children={} }
				);
				for title, affected in SKY_ZONE_AFFECTED_CHANNELS do
					local channel = string.format(ZONE_CHANNEL_FORMAT, SKY_PRETTYPRINT[title], zone);
					table.insert(ChannelManagerGUI.CHANNEL_TREE[5].children[zoneNumber].children, 
						{ 
							title=SKY_PRETTYPRINT[title],
							check=true,
							checkDisabled=true,
							checked=Sky.isChannelActive(channel),
							tooltip=string.format(CHANNEL_MANAGER_JOIN_LEAVE_X_CHANNEL, channel),
							onClick=function() 
								if (Sky.isChannelActive(channel)) then
									LeaveChannelByName(channel);
								else
									JoinChannelByName(channel);
								end
							end
						}
					);
				end
			end
		end
		
		ChannelManagerGUI.CHANNEL_TREE[6].children = {};
		for key, value in SKY_CHANNELS do
			local channel = SKY_CHANNELLIST_PRETTYPRINT[value];
			table.insert(ChannelManagerGUI.CHANNEL_TREE[6].children, 
				{
					title=channel,
					check=true,
					checkDisabled=true,
					checked=Sky.isChannelActive(channel),
					tooltip=string.format(CHANNEL_MANAGER_JOIN_LEAVE_X_CHANNEL, channel),
					onClick=function()
						if (Sky.isChannelActive(channel)) then
							LeaveChannelByName(channel);
						else
							JoinChannelByName(channel);
						end
					end
				}
			);
		end
		
		ChannelManagerGUI.CHANNEL_TREE[7].children = {};
		for key, value in ChannelManager_CustomChannels do
			local channel = key;
			local pass = ChannelManager_CustomChannelPasswords[key];
			table.insert(ChannelManagerGUI.CHANNEL_TREE[7].children, 
				{ 
					title=channel,
					right=pass,
					rightColor=GREEN_FONT_COLOR,
					check=true,
					checkDisabled=true,
					checked=Sky.isChannelActive(channel),
					tooltip=string.format(CHANNEL_MANAGER_JOIN_LEAVE_X_CHANNEL, channel).."\n"..CHANNEL_MANAGER_REMOVE_RECORD,
					onClick=function()
						if (arg1 == "RightButton") then
							ChannelManager_CustomChannels[channel]=nil;
							ChannelManager_CustomChannelPasswords[channel]=nil;
							ChannelManagerGUI.updateChannelTree();
						elseif (Sky.isChannelActive(channel)) then
							LeaveChannelByName(channel);
						else
							JoinChannelByName(channel, pass);
						end
					end
				}
			);
		end
		
		EarthTree_LoadEnhanced(ChannelManagerFrameContainerTree, ChannelManagerGUI.CHANNEL_TREE );
		EarthTree_UpdateFrame(ChannelManagerFrameContainerTree);
	end;
	
	updateBGColors = function()
		local chatFrame = ChannelManagerFrame:GetParent();
		local name, fontSize, r, g, b, a, shown, locked, docked = GetChatWindowInfo(chatFrame:GetID());

		-- Set Frame Color and Alpha
		ChannelManager_FCF_SetWindowColor(chatFrame, r, g, b);
		ChannelManager_FCF_SetWindowAlpha(chatFrame, a);
	end;
	
	setDrawerSide = function(side, force)
		if (side == "right") and (not ChannelManager_RightDrawer or force) then
			local frame = ChannelManagerFrame;
			local parent = frame:GetParent();
			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", parent:GetName(), "TOPRIGHT", 0, 0);
			frame:SetPoint("BOTTOMLEFT", parent:GetName(), "BOTTOMRIGHT", 0, 0);
			
			ChannelManagerFrameResizeRight:Show();
			ChannelManagerFrameResizeBottomRight:Show();
			ChannelManagerFrameResizeTopRight:Show()
			ChannelManagerFrameResizeTop:SetPoint("RIGHT", "ChannelManagerFrameResizeTopRight", "LEFT", 0, 0);
			ChannelManagerFrameResizeBottom:SetPoint("RIGHT", "ChannelManagerFrameResizeBottomRight", "LEFT", 0, 0);
			
			ChannelManagerFrameResizeLeft:Hide();
			ChannelManagerFrameResizeBottomLeft:Hide();
			ChannelManagerFrameResizeTopLeft:Hide()
			ChannelManagerFrameResizeTop:SetPoint("LEFT", "ChannelManagerFrameResizeTopLeft", "RIGHT", -10, 0);
			ChannelManagerFrameResizeBottom:SetPoint("LEFT", "ChannelManagerFrameResizeBottomLeft", "RIGHT", -10, 0);
			
			local currTab;
			for index, tabInfo in ChannelManagerGUI.DRAWER_TAB_INFO do
				currTab = getglobal(parent:GetName().."Tab"..index);
				if (currTab:IsVisible()) then
					getglobal(parent:GetName().."TabRight"..index):Show();
					getglobal(parent:GetName().."Tab"..index):Hide();
				end
			end
			
			ChannelManager_RightDrawer = true;
			ChannelManagerGUI.setDrawerState(ChannelManager_DrawerState);
		elseif (side == "left") and (ChannelManager_RightDrawer or force) then
			local frame = ChannelManagerFrame;
			local parent = frame:GetParent();
			frame:ClearAllPoints();
			frame:SetPoint("TOPRIGHT", parent:GetName(), "TOPLEFT", 0, 0);
			frame:SetPoint("BOTTOMRIGHT", parent:GetName(), "BOTTOMLEFT", 0, 0);
			
			ChannelManagerFrameResizeLeft:Show();
			ChannelManagerFrameResizeBottomLeft:Show();
			ChannelManagerFrameResizeTopLeft:Show()
			ChannelManagerFrameResizeTop:SetPoint("LEFT", "ChannelManagerFrameResizeTopLeft", "RIGHT", 0, 0);
			ChannelManagerFrameResizeBottom:SetPoint("LEFT", "ChannelManagerFrameResizeBottomLeft", "RIGHT", 0, 0);
			
			ChannelManagerFrameResizeRight:Hide();
			ChannelManagerFrameResizeBottomRight:Hide();
			ChannelManagerFrameResizeTopRight:Hide()
			ChannelManagerFrameResizeTop:SetPoint("RIGHT", "ChannelManagerFrameResizeTopRight", "LEFT", 10, 0);
			ChannelManagerFrameResizeBottom:SetPoint("RIGHT", "ChannelManagerFrameResizeBottomRight", "LEFT", 10, 0);
			
			local currTab;
			for index, tabInfo in ChannelManagerGUI.DRAWER_TAB_INFO do
				currTab = getglobal(parent:GetName().."TabRight"..index);
				if (currTab:IsVisible()) then
					getglobal(parent:GetName().."Tab"..index):Show();
					getglobal(parent:GetName().."TabRight"..index):Hide();
				end
			end
			
			ChannelManager_RightDrawer = false;
			ChannelManagerGUI.setDrawerState(ChannelManager_DrawerState);
		end
	end;

	updateTree = function()
		if (ChannelManagerFrameContainerTree:GetTop()) then
			ChannelManagerFrameContainerTree.titleCount = math.floor(GetResizedHeight(ChannelManagerFrameContainerTree) / EARTHTREE_TITLE_HEIGHT);
			if (ChannelManagerFrameContainerTree.titleCount > EARTHTREE_MAXTITLE_COUNT) then
				ChannelManagerFrameContainerTree.titleCount = EARTHTREE_MAXTITLE_COUNT;
			end
		end
		EarthTree_UpdateFrame(ChannelManagerFrameContainerTree);
	end;
	
	updateTabs = function()
		local tab;
		local bottom = ChannelManagerFrame:GetParent():GetBottom();
		for index, tabInfo in ChannelManagerGUI.DRAWER_TAB_INFO do
			if (ChannelManager_RightDrawer) then
				tab = getglobal(ChannelManagerFrame:GetParent():GetName().."TabRight"..index);
			else
				tab = getglobal(ChannelManagerFrame:GetParent():GetName().."Tab"..index);
			end
			if (tab) and (bottom) and (tab:GetBottom()) then
				if (tab:GetBottom() < bottom) then
					tab:Hide();
				else
					tab:Show();
				end
			else
				break;
			end
		end
	end;
	
	-- (state == true) is open
	setDrawerState = function(state)
		if (state) and (not ChannelManagerGUI.DRAWER_TAB_INFO[state]) then
			state = 1;
		end
		if (state) then
			ChannelManagerFrame:Show();
			if (ChannelManager_RightDrawer) then
				getglobal(ChannelManagerFrame:GetParent():GetName().."TabRight3"):SetPoint("BOTTOMLEFT", "ChannelManagerFrame", "BOTTOMRIGHT", 4, -14);
			else
				getglobal(ChannelManagerFrame:GetParent():GetName().."Tab3"):SetPoint("BOTTOMRIGHT", "ChannelManagerFrame", "BOTTOMLEFT", -4, -14);
			end
			for id, currTab in ChannelManagerGUI.DRAWER_TAB_INFO do
				if (state == id) then
					EarthTree_LoadEnhanced(ChannelManagerFrameContainerTree, ChannelManagerGUI[currTab.tree] );
					ChannelManagerGUI[currTab.update]();
					ChannelManager_DrawerState = id;
					break;
				end
			end
		else
			ChannelManagerFrame:Hide();
			if (ChannelManager_RightDrawer) then
				getglobal(ChannelManagerFrame:GetParent():GetName().."TabRight3"):SetPoint("BOTTOMLEFT", ChannelManagerFrame:GetParent():GetName(), "BOTTOMRIGHT", 4, -14);
			else
				getglobal(ChannelManagerFrame:GetParent():GetName().."Tab3"):SetPoint("BOTTOMRIGHT", ChannelManagerFrame:GetParent():GetName(), "BOTTOMLEFT", -4, -14);
			end
			ChannelManager_DrawerState = nil;
		end
	end;
	
	toggleDrawer = function()
		ChannelManagerGUI.setDrawerState(not ChannelManager_DrawerState);
	end;
	
};

function ChannelManager_Tab_OnEnter()
	--GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	if (ChannelManager_DrawerState == this:GetID()) then
		GameTooltip:SetText(ChannelManagerGUI.DRAWER_TAB_INFO[this:GetID()].openTooltip, 1.0,1.0,1.0 );
	else
		GameTooltip:SetText(ChannelManagerGUI.DRAWER_TAB_INFO[this:GetID()].closedTooltip, 1.0,1.0,1.0 );
	end
end

function ChannelManager_Tab_OnLeave()
	GameTooltip:Hide();
end

function GetResizedHeight(frame) 
	return (frame:GetTop() - frame:GetBottom());
end

function GetResizedWidth(frame) 
	return (frame:GetRight() - frame:GetLeft());
end

function ChannelManager_Tab_ButtonDown(tab)
	if (not tab) then
		tab = this;
	end
	local id = tab:GetID();
	local textureFrame = getglobal(tab:GetName().."Icon");
	local texture = ChannelManagerGUI.DRAWER_TAB_INFO[id].textureDown;
	if (textureFrame) and (texture) then 
		textureFrame:SetTexture(texture);
		textureFrame:SetTexCoord(6/32,26/32,32/64,58/64);
	end
end

function ChannelManager_Tab_ButtonUp(tab)
	if (not tab) then
		tab = this;
	end
	local id = tab:GetID();
	local textureFrame = getglobal(tab:GetName().."Icon");
	local texture = ChannelManagerGUI.DRAWER_TAB_INFO[id].textureUp;
	if (textureFrame) and (texture) then 
		textureFrame:SetTexture(texture);
		textureFrame:SetTexCoord(6/32,26/32,32/64,58/64);
	end
end

function ChannelManager_Tab_OnClick()
	if (ChannelManager_DrawerState ~= this:GetID()) then
		ChannelManagerGUI.setDrawerState(this:GetID());
	else
		ChannelManagerGUI.toggleDrawer();
	end
end

function ChannelManager_FCF_SetWindowColor(frame, r, g, b, doNotSave)
	if (frame == ChannelManagerFrame:GetParent()) and ( not doNotSave ) then
		for index, value in ChannelManagerGUI.BG_TEXTURES do
			getglobal("ChannelManagerFrame"..value):SetVertexColor(r,g,b);
		end
	end
end

function ChannelManager_FCF_SetWindowAlpha(frame, alpha, doNotSave)
	if (frame == ChannelManagerFrame:GetParent()) and ( not doNotSave ) then
		for index, value in ChannelManagerGUI.BG_TEXTURES do
			getglobal("ChannelManagerFrame"..value):SetAlpha(alpha);
		end
	end
end

function ChannelManager_Resize(anchorPoint)
	local frame = this:GetParent();
	if ( frame.isLocked) then
		return;
	end
	frame.resizing = 1;
	frame:SetHeight(frame:GetParent():GetHeight());
	frame:StartSizing(anchorPoint);
end

function ChannelManager_StopResize()
	local frame = this:GetParent();
	frame:StopMovingOrSizing();
	if (ChannelManager_RightDrawer) then
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", frame:GetParent():GetName(), "TOPRIGHT", 0, 0);
		frame:SetPoint("BOTTOMLEFT", frame:GetParent():GetName(), "BOTTOMRIGHT", 0, 0);
	else
		frame:ClearAllPoints();
		frame:SetPoint("TOPRIGHT", frame:GetParent():GetName(), "TOPLEFT", 0, 0);
		frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMLEFT", 0, 0);
	end
	frame.resizing = nil;
end

function ChannelManager_FCF_GetCurrentChatFrame()
	local currentChatFrame = getglobal("ChatFrame"..UIDropDownMenu_GetCurrentDropDown():GetParent():GetID());
	if ( not currentChatFrame ) then
		currentChatFrame = getglobal("ChatFrame"..this:GetParent():GetID());
	end
	if ( not currentChatFrame ) then
		currentChatFrame = DEFAULT_CHAT_FRAME;
	end
	return currentChatFrame;
end

function ChannelManager_AddChatWindowChannel(chatFrameID, channelName)
	Sea.IO.dprint("CHANNEL_MANAGER_DEBUG", "ChannelManager_AddChatWindowChannel(", chatFrameID, ",", channelName, ")");
	if (type(ChannelVisibility) ~= "table") then
		ChannelVisibility = {};
	end
	
	if (ChannelVisibility[channelName] == nil) then
		ChannelVisibility[channelName] = {};
	end
	ChannelVisibility[channelName][chatFrameID] = true;
end


function ChannelManager_RemoveChatWindowChannel(chatFrameID, channelName)
	Sea.IO.dprint("CHANNEL_MANAGER_DEBUG", "ChannelManager_RemoveChatWindowChannel(", chatFrameID, ",", channelName, ")");
	
	if (ChannelVisibility) and (ChannelVisibility[channelName]) and (ChannelVisibility[channelName][chatFrameID]) then
		ChannelVisibility[channelName][chatFrameID] = nil;
	end
end


function ChannelManager_FCFDropDown_LoadServerChannels_Override(...)
	--arg list is ignored
	local serverChannelList = SkyChannelManager.getServerChannelTable();
	
	local nonSkyChannelList = {};
	local currChannelList = SkyChannelManager.getCurrentChannelTable();
	
	for i, channelName in serverChannelList do
		table.insert(nonSkyChannelList, channelName);
	end
	for i, channelName in currChannelList do
		if  (channelName) and
			not ( SkyChannelManager.isSkyChannel(channelName) ) and
			not ( Sea.table.isInTable(serverChannelList, channelName) ) then
			
			table.insert(nonSkyChannelList, channelName);
		end
	end
	
	--Sea.io.printTable(nonSkyChannelList);
	
	local checked;
	local info;
	local number;

	-- Server Channels header
	info = {};
	info.text = CHAT_MSG_CHANNEL_LIST;
	info.notClickable = 1;
	info.isTitle = 1;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	for i, channelName in nonSkyChannelList do
		checked = nil;
		info = {};
		number = Sea.table.getValueIndex(currChannelList, channelName);
		if ( Sky.isChannelActive(number) ) then
			checked = 1;
			info.text = format(SKY_CHANNEL_FORMAT, number, channelName);
		else
			info.text = channelName;
		end

		info.value = channelName;
		info.func = FCFServerChannelsDropDown_OnClick;
		info.checked = checked;
		info.keepShownOnClick = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	end
	
	-- Spacer
	info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	local skyChannelList = SkyChannelManager.getSkyChannelTable();
	
	-- Sky Channels header
	info = {};
	info.text = SKY_CHANNELS_MENU_TITLE;
	info.notClickable = 1;
	info.isTitle = 1;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	for i, channelName in skyChannelList do
		checked = nil;
		info = {};
		number = Sea.table.getValueIndex(currChannelList, SkyChannelManager.convertToRealChannelName(channelName));
		if ( Sky.isChannelActive(number) ) then
			checked = 1;
			info.text = format(SKY_CHANNEL_FORMAT, number, channelName);
		else
			info.text = channelName;
		end

		info.value = channelName;
		info.func = FCFServerChannelsDropDown_OnClick;
		info.checked = checked;
		info.keepShownOnClick = 1;
		UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	end
end

function ChannelManager_FCFServerChannelsDropDown_OnClick_Override()
	local channelName = UIDropDownMenuButton_GetName();
	local tempChannelName, found = gsub(channelName, "%d+.%s(%w+)", "%1");
	if (found > 0) then
		channelName = tempChannelName;
	end
	
	if ( UIDropDownMenuButton_GetChecked() ) then
		LeaveChannelByName(channelName);
	else
		JoinChannelByName(channelName, nil, FCF_GetCurrentChatFrameID());
		ChatFrame_AddChannel(FCF_GetCurrentChatFrame(), channelName);
	end
end


-- <= == == == == == == == == == == == == =>
-- => FCF Alpha Hijack
-- <= == == == == == == == == == == == == =>

function ChannelManager_FCF_OnUpdate(elapsed)

	-- Detect if mouse is over any chat frames and if so show their tabs, if not hide them
	local chatFrame, chatTab;
	
	-- Moved ChannelManager_FCF_DefineDockRegions to onload
	-- Moved ChannelManager_FCF_UpdateAllButtonSides to onInit
	
	if ( MOVING_CHATFRAME ) then
		ChannelManager_FCF_UpdateChatFramesWhileMoving();
	end
	
	-- Handle hiding and showing chat tabs
	local showAllDockTabs = nil;
	local xPos, yPos = GetCursorPosition();
	local isChannelManagerParentFrame;
	
	-- Add Zone space for the ChannelManager Tabs
	local leftZone = -5;
	local rightZone = 5;
	if (ChannelManager_RightDrawer) then
		rightZone = rightZone + 40;
	else
		leftZone = leftZone - 40;
	end
	local topZone = 45;
	if (CHAT_LOCKED == "1") then
		topZone = 10;
	end
	
	for j=1, NUM_CHAT_WINDOWS do
		chatFrame = getglobal("ChatFrame"..j);
		chatTab = getglobal("ChatFrame"..j.."Tab");
		isChannelManagerParentFrame = (chatFrame == ChannelManagerFrame:GetParent());
		
		-- New version of the crazy function
		--if ( FCF_IsValidChatFrame(chatFrame) ) then
		if  not (chatFrame == MOVING_CHATFRAME) and 
			(chatFrame:IsVisible() or chatFrame.isDocked) and
			not (SIMPLE_CHAT == "1") then
			if  ( 
					(not UIOptionsFrame:IsVisible()) and
					(
						(chatFrame.resizing) or
						(
							(isChannelManagerParentFrame) and
							(   
								(MouseIsOver(chatFrame, topZone, -10, leftZone, rightZone)) or
								(
									(ChannelManagerFrame:IsVisible()) and
									(MouseIsOver(ChannelManagerFrame, topZone, -10, leftZone, rightZone))
								)
							) 
						) or
						(MouseIsOver(chatFrame, topZone, -10, -5, 5))
					)
				) then
				-- If mouse is hovering don't show the tab until the elapsed time reaches the tab show delay
				if ( chatFrame.hover ) then
					if ( (chatFrame.oldX == xPos and chatFrame.oldy == yPos) or REMOVE_CHAT_DELAY == "1" ) then
						chatFrame.hoverTime = chatFrame.hoverTime + elapsed;
					else
						chatFrame.hoverTime = 0;
						chatFrame.oldX = xPos;
						chatFrame.oldy = yPos;
					end
					-- If the hover delay has been reached or the user is dragging a chat frame over the dock show the tab
					if ( (chatFrame.hoverTime > CHAT_TAB_SHOW_DELAY) or (MOVING_CHATFRAME and (chatFrame == DEFAULT_CHAT_FRAME)) ) then
						-- If the chatframe's alpha is less than the current default, then fade it in 
						if ( not chatFrame.hasBeenFaded and (chatFrame.oldAlpha and chatFrame.oldAlpha < DEFAULT_CHATFRAME_ALPHA) ) then
							if not (CHAT_LOCKED == "1") then
								for index, value in CHAT_FRAME_TEXTURES do
									UIFrameFadeIn(getglobal(chatFrame:GetName()..value), CHAT_FRAME_FADE_TIME, chatFrame.oldAlpha, DEFAULT_CHATFRAME_ALPHA);
								end
							end
							
							if (isChannelManagerParentFrame) then
								for index, value in ChannelManagerGUI.BG_TEXTURES do
									UIFrameFadeIn(getglobal("ChannelManagerFrame"..value), CHAT_FRAME_FADE_TIME, chatFrame.oldAlpha, DEFAULT_CHATFRAME_ALPHA);
								end
							end
							
							-- Set the fact that the chatFrame has been faded so we don't try to fade it again
							chatFrame.hasBeenFaded = 1;
						end
						-- Fadein to different values depending on the selected tab
						if ( not chatTab.hasBeenFaded ) then
							if not (CHAT_LOCKED == "1") then
								if ( SELECTED_DOCK_FRAME:GetID() == chatTab:GetID() or not chatFrame.isDocked) then
									UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME);
									chatTab.oldAlpha = 1;
								else
									UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME, 0, 0.5);
									chatTab.oldAlpha = 0.5;
								end
							end
							
							chatTab.hasBeenFaded = 1;

							-- If this is the default chat tab fading in then fade in all the docked tabs
							if ( chatFrame == DEFAULT_CHAT_FRAME ) and not (CHAT_LOCKED == "1") then
								--showAllDockTabs = 1;
							end
						end
						if (isChannelManagerParentFrame) and (chatFrame == SELECTED_DOCK_FRAME) then
							local CMtab;
							for index, tabInfo in ChannelManagerGUI.DRAWER_TAB_INFO do
								if (ChannelManager_RightDrawer) then
									CMtab = getglobal(chatFrame:GetName().."TabRight"..index);
								else
									CMtab = getglobal(chatFrame:GetName().."Tab"..index);
								end
								if (not CMtab.hasBeenFaded) then
									UIFrameFadeIn(CMtab, CHAT_FRAME_FADE_TIME);
									CMtab.hasBeenFaded = 1;
								end
							end
						end
					end
				else
					-- Start hovering counter
					chatFrame.hover = 1;
					chatFrame.hoverTime = 0;
					chatFrame.hasBeenFaded = nil;
					CURSOR_OLD_X, CURSOR_OLD_Y = GetCursorPosition();
					-- Remember the oldAlpha so we can return to it later
					if ( not chatFrame.oldAlpha ) then
						chatFrame.oldAlpha = getglobal(chatFrame:GetName().."Background"):GetAlpha();
					end
				end
			else
				if (ChannelManager_NoDockedTabsAreFlashing()) then
					-- If the chatframe's alpha was less than the current default, then fade it back out to the oldAlpha
					if ( chatFrame.hasBeenFaded and chatFrame.oldAlpha and chatFrame.oldAlpha < DEFAULT_CHATFRAME_ALPHA ) then
						if not (CHAT_LOCKED == "1") then
							for index, value in CHAT_FRAME_TEXTURES do
								UIFrameFadeOut(getglobal(chatFrame:GetName()..value), CHAT_FRAME_FADE_TIME, DEFAULT_CHATFRAME_ALPHA, chatFrame.oldAlpha);
							end
						end
						
						if (isChannelManagerParentFrame) then
							for index, value in ChannelManagerGUI.BG_TEXTURES do
								UIFrameFadeOut(getglobal("ChannelManagerFrame"..value), CHAT_FRAME_FADE_TIME, DEFAULT_CHATFRAME_ALPHA, chatFrame.oldAlpha);
							end
						end
						
						chatFrame.hover = nil;
						chatFrame.hasBeenFaded = nil;
					end
					if ( chatTab.hasBeenFaded ) then					
						if not (CHAT_LOCKED == "1") then
							--UIFrameFade(chatTab, fadeInfo);
							UIFrameFadeOut(chatTab, CHAT_FRAME_FADE_TIME, chatTab.oldAlpha);
						end

						chatFrame.hover = nil;
						chatTab.hasBeenFaded = nil;
					end
				end
				if (isChannelManagerParentFrame) then
					local CMtab;
					for index, tabInfo in ChannelManagerGUI.DRAWER_TAB_INFO do
						if (ChannelManager_RightDrawer) then
							CMtab = getglobal(chatFrame:GetName().."TabRight"..index);
						else
							CMtab = getglobal(chatFrame:GetName().."Tab"..index);
						end
						if (CMtab.hasBeenFaded) then
							UIFrameFadeOut(CMtab, CHAT_FRAME_FADE_TIME, chatTab.oldAlpha);
							CMtab.hasBeenFaded = nil;
						end
					end
				end
				chatFrame.hoverTime = 0;
			end
		end
		
		-- See if any of the tabs are flashing
		if ( UIFrameIsFlashing(getglobal("ChatFrame"..j.."TabFlash")) and chatFrame.isDocked ) and not (CHAT_LOCKED == "1") then
			showAllDockTabs = 1;
		end
	end
	-- If one tab is flashing, show all the docked tabs
	if ( showAllDockTabs ) then
		for index, value in DOCKED_CHAT_FRAMES do
			chatTab = getglobal(value:GetName().."Tab");
			if ( not chatTab.hasBeenFaded ) then
				if ( SELECTED_DOCK_FRAME:GetID() == chatTab:GetID() ) then
					UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME);
					chatTab.oldAlpha = 1;
				else
					UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME, 0, 0.5);
					chatTab.oldAlpha = 0.5;
				end
				chatTab.hasBeenFaded = 1;
			end
		end
	end
		
	-- If the default chat frame is resizing, then resize the dock
	if ( DEFAULT_CHAT_FRAME.resizing ) then
		FCF_DockUpdate();
	end
end

function ChannelManager_NoDockedTabsAreFlashing()
	if (CHAT_LOCKED == "1") then
		return true;
	end
	for index, value in DOCKED_CHAT_FRAMES do
		if ( UIFrameIsFlashing(getglobal(value:GetName().."TabFlash")) ) then
			return false;
		end
	end
	return true;
end

function ChannelManager_FCF_DefineDockRegions()
	-- Need to draw the dock regions for a frame to define their rects
	for i=1, NUM_CHAT_WINDOWS do
		getglobal("ChatFrame"..i.."TabDockRegion"):Show();
	end
	for i=1, NUM_CHAT_WINDOWS do
		getglobal("ChatFrame"..i.."TabDockRegion"):Hide();
	end
end

function ChannelManager_FCF_UpdateAllButtonSides()
	for i=1, NUM_CHAT_WINDOWS do
		FCF_UpdateButtonSide(getglobal("ChatFrame"..i));
	end
end

function ChannelManager_FCF_SetButtonSide_before(chatFrame, buttonSide)
	if (chatFrame ~= ChannelManagerFrame:GetParent()) or (chatFrame.buttonSide == buttonSide) then
		return;
	end
	if ( buttonSide == "left" ) then
		ChannelManagerGUI.setDrawerSide("right");
	elseif ( buttonSide == "right" ) then
		ChannelManagerGUI.setDrawerSide("left");
	end
end

function ChannelManager_FCF_UpdateChatFramesWhileMoving()
	-- Set buttons to the left or right side of the frame
	-- If the the side of the buttons changes and the frame is the default frame, then set every docked frames buttons to the same side
	local updateAllButtons = nil;
	if (FCF_UpdateButtonSide(MOVING_CHATFRAME) and MOVING_CHATFRAME == DEFAULT_CHAT_FRAME ) then
		updateAllButtons = 1;
	end
	local dockRegion;
	for index, value in DOCKED_CHAT_FRAMES do
		if ( updateAllButtons ) then
			FCF_UpdateButtonSide(value);
		end
		
		dockRegion = getglobal(value:GetName().."TabDockRegion");
		if ( MouseIsOver(dockRegion) and MOVING_CHATFRAME ~= DEFAULT_CHAT_FRAME and not UIOptionsFrame:IsVisible() ) then
			dockRegion:Show();
		else
			dockRegion:Hide();
		end
	end
end


-- <= == == == == == == == == == == == == =>
-- => OnLoad and Event Functions
-- <= == == == == == == == == == == == == =>

function ChannelManager_OnLoad()
	
	ChannelManager_FCF_DefineDockRegions();
	
	this:RegisterEvent("VARIABLES_LOADED");
	
	--setglobal("SkyTrueJoinChannel", SkyChannelManager.trueJoin );
	
	if ( ReloadUI ~= ChannelManager.delayedReloadUI ) then 
		--Sea.util.hook("ReloadUI", "LeaveZonedChannels", "before");
		-- Time Delay Manual Hook
		ChannelManager.trueReloadUI = ReloadUI;
		ReloadUI = ChannelManager.delayedReloadUI;
	end
	
	if ( FCF_OnUpdate ~= ChannelManager_FCF_OnUpdate ) then 
		-- Manual Hook for OnUpdate to avoid Sea hook lag
		ChannelManager_Saved_FCF_OnUpdate = FCF_OnUpdate;
		FCF_OnUpdate = ChannelManager_FCF_OnUpdate;
	end
	
	ChannelManager.activate();
	Chronos.afterInit(ChannelManager_AfterInit);
	
	-- Register the channel reorder
	Sky.registerSlashCommand(
		{
			id="ChannelReorder";
			commands = CHANNEL_REORDER_COMMANDS;
			onExecute = ChannelManager.reorderChannels;
			helpText = CHANNEL_REORDER_HELP;
		}
	);
	
	Sky.registerSlashCommand(
		{
			id="SkyChannelStickyToggle";
			commands = CHANNEL_STICKY_TOGGLE_COMMANDS;
			onExecute=function(msg) 
				ChannelManager_StickyChannels = (not ChannelManager_StickyChannels);
				Sky.updateSlashCommand( { id = "SkyChannelManager", sticky = ChannelManager_StickyChannels } );
			end;
			helpText = CHANNEL_STICKY_TOGGLE_HELP;
		}
	);
	
end

function ChannelManager_Tree_OnLoad()
	this.titleCount=5;
	this.tooltip = "GameTooltip";
	this.tooltipPlacement = "frame";
	this.tooltipAnchor = "ANCHOR_TOPLEFT";
	this.collapseAllButton = true;
	this.highlight = false;
	--this.highlightSize = "long";
end

function ChannelManager_AfterInit()
	ChannelManagerGUI.setDrawerSide("right", true);
	ChannelManager_FCF_UpdateAllButtonSides();
	
	--Join Saved Zone Channels (wait .5 sec for GetChannelList to init)
	Chronos.schedule(.5, ChannelManager.joinSavedZonedChannels);
	-- Visibility Initialize
	Chronos.schedule( 1, ChannelManager.initChannelVisibility);
	ChannelManagerGUI.updateBGColors();
	--ChannelManagerGUI.updateTabs();
end

function ChannelManager_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		ChannelManager.hideBogusChannelJoinLeaveAlerts();
		ChannelManager.updateStickies();
		ChannelManagerGUI.updateBGColors();
		--Chronos.schedule( 1, ChannelManagerGUI.setDrawerState, ChannelManager_DrawerState);
		ChannelManagerGUI.setDrawerState(ChannelManager_DrawerState);
	end
end

function ChannelManager_ChatFrame_OnEvent_After(event)
	if ( string.sub(event,18) == "NOTICE" ) and ( arg1 == "YOU_JOINED" ) then
		--for out of zone channels arg9 == ""?
		local channelIndex, channel = Sky.isChannelActive(arg8);
		
		if (channel) then
			Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "Join Event: ",arg8," -> ",channel);
			if  (not SkyChannelManager.isSkyChannel(channel)) and (channel ~= BOGUS_CHANNELS[arg8]) then
				-- Make the channel visible on the ChatFrame's that were saved
				if (not ChannelVisibility[channel]) then
					Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "Channel \""..channel.."\" is not in ChannelVisibility.");
					ChatFrame_AddChannel(SELECTED_CHAT_FRAME, channel);
					--ChannelVisibility = {};
					--ChannelManager.initChannelVisibility();
				else
					for chatFrameID, isVisible in ChannelVisibility[channel] do
						if (isVisible) then
							ChatFrame_AddChannel(getglobal("ChatFrame"..chatFrameID), channel);
						end
					end
				end
			end
		elseif (arg8) then
			Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "Warning: join chat event but bhannel \""..arg8.."\" is not active.");
		else
			Sea.io.dprint("CHANNEL_MANAGER_DEBUG", "Warning: join chat event but no channel arg8 passed.");
		end
		
		if (ChannelManager_DrawerState) and (ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].tree == "CHANNEL_TREE") then
			ChannelManagerGUI[ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].update]();
		end
	end
	if ( string.sub(event,18) == "NOTICE" ) and ( arg1 == "YOU_LEFT" ) then
		if (ChannelManager_DrawerState) and (ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].tree == "CHANNEL_TREE") then
			--leaving has a delay
			Chronos.schedule(.5, ChannelManagerGUI[ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].update]);
		end
	end
	if  (event == "ZONE_CHANGED_NEW_AREA") then
		if (ChannelManager_DrawerState) and (ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].tree == "CHANNEL_TREE") then
			ChannelManagerGUI[ChannelManagerGUI.DRAWER_TAB_INFO[ChannelManager_DrawerState].update]();
		end
	end
end

-- Fixes for FCF_GetCurrentChatFrame not working until a chat tab menu is openned

StaticPopupDialogs["JOIN_CHANNEL"].OnAccept = function()
	local channel = getglobal(this:GetParent():GetName().."EditBox"):GetText();
	JoinChannelByName(channel, nil, ChannelManager_FCF_GetCurrentChatFrame());
	ChatFrame_AddChannel(ChannelManager_FCF_GetCurrentChatFrame(), channel);
	getglobal(this:GetParent():GetName().."EditBox"):SetText("");
end

StaticPopupDialogs["JOIN_CHANNEL"].EditBoxOnEnterPressed = function()
	local channel = getglobal(this:GetParent():GetName().."EditBox"):GetText();
	JoinChannelByName(channel, nil, ChannelManager_FCF_GetCurrentChatFrame());
	ChatFrame_AddChannel(ChannelManager_FCF_GetCurrentChatFrame(), channel);
	getglobal(this:GetParent():GetName().."EditBox"):SetText("");
	this:GetParent():Hide();
end

