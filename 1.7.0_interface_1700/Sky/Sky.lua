--[[
--
--	Sky (Skylight)
--		A Communication Toolset
--
--	By Alexander Brazie, AnduinLothar
--
--	Special thanks to:
--		Vjeux
--		Mugendai
--
--
--	$Id: Sky.lua 2266 2005-08-09 04:18:40Z karlkfi $
--	$Rev: 2266 $
--	$LastChangedBy: karlkfi $
--	$Date: 2005-08-08 23:18:40 -0500 (Mon, 08 Aug 2005) $
--]]
 
-- Global Keywords
SKY_CHANNEL = "#Sky#";
SKY_ZONE = "#Zone#";
SKY_PARTY = "#Party#";
SKY_GUILD = "#Guild#";
SKY_RAID = "#Raid#";
SKY_PLAYER = "#Player#";

-- Pretty print for other channels
SKY_CHANNEL_PRETTYPRINT = "Sky";
SKY_PARTY_PRETTYPRINT = "SkyParty";
SKY_RAID_PRETTYPRINT = "SkyRaid";
SKY_ZONE_PRETTYPRINT = "SkyZone";
SKY_GUILD_PRETTYPRINT = "SkyGuild";

SKY_SERVER_CHANNELS = {
	SKY_GENERAL_ID;
	SKY_TRADE_ID;
	SKY_LFG_ID;
	SKY_LOCALDEFENSE_ID;
	SKY_WORLDDEFENSE_ID;
};

SKY_PRETTYPRINT = {
	[SKY_GENERAL_ID] = SKY_GENERAL_PRETTYPRINT;
	[SKY_TRADE_ID] = SKY_TRADE_PRETTYPRINT;
	[SKY_LFG_ID] = SKY_LFG_PRETTYPRINT;
	[SKY_LOCALDEFENSE_ID] = SKY_LOCALDEFENSE_PRETTYPRINT;
	[SKY_WORLDDEFENSE_ID] = SKY_WORLDDEFENSE_PRETTYPRINT;
};

-- Used for Ordering
SKY_CHANNELS = {
	SKY_CHANNEL,
	SKY_PARTY,
	SKY_GUILD,
	SKY_RAID,
	SKY_ZONE
};

SKY_CHANNELLIST_PRETTYPRINT = {
	[SKY_CHANNEL] = SKY_CHANNEL_PRETTYPRINT;
	[SKY_PARTY] = SKY_PARTY_PRETTYPRINT;
	[SKY_GUILD] = SKY_GUILD_PRETTYPRINT;
	[SKY_RAID] = SKY_RAID_PRETTYPRINT;
	[SKY_ZONE] = SKY_ZONE_PRETTYPRINT;
}


-- Constants
SKY_TIME_TO_LIVE	= 15; -- seconds (Might be a bit long)
SKY_MAX_DATAGRAM_LENGTH = 192;
SKY_MAX_ASSEMBLY_LENGTH = 1/30;
SKY_MAX_CLEANUP_LENGTH	= 1/30;
SKY_MAX_SORT_LENGTH	= 1/30;
SKY_MAX_MESSAGES_PER_RESET = 15;
SKY_DEFAULT_MAILBOX_MAX	= 100;
SKY_DELIVERY_MAX_LENGTH	= 1/30; -- 1/Desired FPS
SKY_BLOCK_MSG_DURATION	= 1; -- 1 Second
SKY_DEFAULT_WATCH_WEIGHT= 10; -- Kilograms
SKY_BANDWIDTH_RESET_TIME= 20; -- seconds
SKY_CHANNEL_MONITOR_TIME= 15;
SKY_DELIVERY_RESET_TIME	= 3;
SKY_SORT_RESET_TIME    	= 3;

-- Debug
SKY_DEBUG_MESSAGES = false;
SKY_DEBUG = "SKY_DEBUG_MESSAGES";
SKY_DEBUG_CHANNELMANAGER = false;
SKY_DEBUG_CM = "SKY_DEBUG_CHANNELMANAGER";
SKY_DEBUG_DELIVERY = false;
SKY_DEBUG_D = "SKY_DEBUG_DELIVERY";
SKY_DEBUG_CHATCOMMANDS = false;
SKY_DEBUG_CC = "SKY_DEBUG_CHATCOMMANDS";
SKY_DEBUG_POSTOFFICE = false;
SKY_DEBUG_PO = "SKY_DEBUG_POSTOFFICE";
SKY_DEBUG_SPAM = false;
SKY_DEBUG_S = "SKY_DEBUG_SPAM";

SKY_TESTER_MODE = false;

-- Zone Affected Channels
SKY_ZONE_AFFECTED_CHANNELS = {
	[SKY_GENERAL_ID] = true;
	[SKY_TRADE_ID] = true;
	[SKY_LFG_ID] = true;
	[SKY_LOCALDEFENSE_ID] = true;
};

-- Channel generating strings
SKY_CHANNEL_FORMATING_STRINGS = {
	[SKY_CHANNEL] = {prefix = SKY_CHANNEL_PRETTYPRINT, suffixToolFunc = "getEmptyString"};
	[SKY_PARTY] = {prefix = SKY_PARTY_PRETTYPRINT, suffixToolFunc = "getPartyLeaderName"};
	[SKY_GUILD] =  {prefix = SKY_GUILD_PRETTYPRINT, suffixToolFunc = "getGuildName"};
	[SKY_RAID] = {prefix = SKY_RAID_PRETTYPRINT, suffixToolFunc = "getRaidLeaderName"};
	[SKY_ZONE] = {prefix = SKY_ZONE_PRETTYPRINT, suffixToolFunc = "getZoneName"};
};

-- Channel Leave Warnings
SKY_LEAVE_WARNINGS = {
	[SKY_CHANNEL] = SKY_LEAVE_WARNING_SKY;
	[SKY_PARTY] = SKY_LEAVE_WARNING_PARTY;
	[SKY_GUILD] = SKY_LEAVE_WARNING_GUILD;
	[SKY_RAID] = SKY_LEAVE_WARNING_RAID;
	[SKY_ZONE] = SKY_LEAVE_WARNING_ZONE;
};

-- Channel Events for Hostesses
SKY_PLAYER_JOIN  = "PLAYER_JOIN";
SKY_PLAYER_LEAVE = "PLAYER_LEAVE";
SKY_CHANNEL_LIST = "CHANNEL_LIST";
SKY_CHANNEL_JOIN = "CHANNEL_JOIN";
SKY_CHANNEL_LEAVE= "CHANNEL_LEAVE";

-- Notices
SkyHiddenJoinLeaveAlerts = {};

SELECTED_CHAT_FRAME = DEFAULT_CHAT_FRAME;

-- The usable interface
Sky = {
	online = false;

	--[[
	--	isChannelActive(channelID)
	--
	--		Tells you if a channel is active 
	--		(meaning you can use it)
	--
	--		e.g. 
	--			Sky.isChannelActive(channelID) 
	--			will return the index and name if the channel
	--			exists in your channel list. Usable as a more
	--			predictable GetChannelName. 
	--
	--
	--	args:
	--		channelID - can be a string ("General"), index (1), index and string ("1. General - Ironforge"), or a SKY_IDENTIFIER (SKY_GENERAL_ID)
	--
	-- 	returns: 
	-- 		channelIndex, channelName
	--
	-- 		channelIndex - channel index (1-10), nil if not active
	-- 		channelName - name according to GetChannelList, nil if not active (should I return according to GetChannelName instead?)
	-- 
	--]]	
	isChannelActive = function (channelID)
		if ( not channelID ) then 
			return false;
		end
		
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		local channelIndex = tonumber(channelID);
		if ( type (channelIndex) == "number" ) then 
			if (currChannelList[channelIndex]) then
				return channelIndex, currChannelList[channelIndex];
			else
				return;
			end
		end
		
		local channelName, found = gsub(channelID, "%d+.%s(%w+)", "%1");
		if (found > 0) then
			channelID = channelName;
		end
		
		local identifier, specificID = SkyChannelManager.convertToChannelIdentifier(channelID);
		local tempIdentifier, tempZone;
		
		if (SKY_ZONE_AFFECTED_CHANNELS[identifier]) and (identifier ~= channelID) and ((not specificID) or (specificID == GetRealZoneText())) then
			-- Asked for a System/CurentZone channel
			for k,v in currChannelList do
				if (v == channelID) then
					return k, v;
				end
			end
		else
			for k,v in currChannelList do 
				tempIdentifier, tempSpecificID = SkyChannelManager.convertToChannelIdentifier(v);
				if (specificID) then
					-- Asked for specific Sky or Standard channel
					if (tempIdentifier == identifier) and (tempSpecificID == specificID) then
						return k, v;
					end
				elseif (tempIdentifier == identifier) and (not specificID) then
					-- Asked for a genaric or custom channel
					return k, v;
				end
			end
		end
		
		-- If we don't find it, its not active
		return;
	end;
	
	--[[
	--	isSkyUser ( username ) 
	--		Checks if a username is a known sky user. If they are not, you get nil.
	--		If they are, you get a list of the channels they have been seen in. 
	--
	--		Due to the way the SkyUserList updates, 
	--		You should do this 20 seconds after the party changes.
	--
	--	Returns:
	--		table - list of the channels they are in
	--		nil - they are not known to be a sky user. 
	--]]		
	isSkyUser = function ( username )
		local chanList = nil; 

		if ( type ( username ) ~= "string" ) then 
			Sea.io.error("Invalid username sent to Sky.isSkyUser: ", username, " from ", this:GetName());
			return;
		end

		for k,v in SKY_CHANNELS do 
			if ( SkyUserList[v] ) then 
				if ( SkyUserList[v][string.lower(username)] ) then 
					if ( chanList == nil ) then 
						chanList = {};
					end
					table.insert(chanList, v);
				end
			end
		end

		return chanList;
	end;

	--[[
	--	isSkySlashCommand(command)
	--		checks if a /command is a registered sky command.
	--
	--	args:
	--		command - string e.g. (/test)
	--
	--	returns:
	--		table - its a SkySlashCommand, here's the info
	--		false - tis not in SkySlashCommands
	--]]
	isSkySlashCommand = function(command) 
		-- Check all of the registered Sky Slash Commands
		for k,v in SkyChat.slashCommands do 
			for k2, cmd in v.commands do 
				-- We find a match?
				if ( string.lower(cmd) == string.lower(command) ) then 
					return v;
				end
			end
		end
	end;
	
	--[[
	--	setSkyStatus (state)
	--		Put Sky online or offline
	--
	--
	--	args:
	--		state - if nil, false, 0 or "off", turn it off. otherwise turn it on.
	--]]
	setSkyStatus = function ( state ) 

		if ( not state or state == 0 or state == "off" ) then 
			Sea.io.derror(SKY_DEBUG, "Sky Off");
			Sky.online = false;
	
			Sea.util.unhook("ChatFrame_OnEvent", "SkyPostOffice.processEvent", "replace");	
			Sea.util.unhook("JoinChannelByName", "SkyChannelManager.joinChannel", "replace");	
			Sea.util.unhook("LeaveChannelByName", "SkyChannelManager.leaveChannel", "replace");
			Sea.util.unhook("ListChannelByName", "SkyChannelManager.requestChannelList", "replace");		
			
			Sea.util.unhook("ChatEdit_SendText", "Sky_ChatEdit_SendText_Override", "replace");
			Sea.util.unhook("ChatEdit_ParseText", "Sky_ChatEdit_ParseText_Override", "replace");
			Sea.util.unhook("ChatEdit_UpdateHeader", "Sky_ChatEdit_UpdateHeader_Override", "replace");
			Sea.util.unhook("ChatEdit_OnTabPressed", "Sky_ChatEdit_OnTabPressed_Override", "replace");
			Sea.util.unhook("ChatEdit_OnEnterPressed", "Sky_ChatEdit_OnEnterPressed_Override", "replace");
			Sea.util.unhook("ChatEdit_OnEscapePressed", "Sky_ChatEdit_OnEscapePressed_Override", "replace");
			Sea.util.unhook("ChatEdit_OnSpacePressed", "Sky_ChatEdit_OnSpacePressed_Override", "replace");
			Sea.util.unhook("FCFDropDown_LoadChannels", "Sky_FCFDropDown_LoadChannels_Override", "replace");
		else
			Sea.io.derror(SKY_DEBUG, "Sky On");
			Sky.online = true;
			
			Sea.util.hook("ChatFrame_OnEvent", "SkyPostOffice.processEvent", "replace");
			Sea.util.hook("JoinChannelByName", "SkyChannelManager.joinChannel", "replace");
			Sea.util.hook("LeaveChannelByName", "SkyChannelManager.leaveChannel", "replace");
			Sea.util.hook("ListChannelByName", "SkyChannelManager.requestChannelList", "replace");	
			
			Sea.util.hook("ChatEdit_SendText", "Sky_ChatEdit_SendText_Override", "replace");
			Sea.util.hook("ChatEdit_ParseText", "Sky_ChatEdit_ParseText_Override", "replace");
			Sea.util.hook("ChatEdit_UpdateHeader", "Sky_ChatEdit_UpdateHeader_Override", "replace");
			Sea.util.hook("ChatEdit_OnTabPressed", "Sky_ChatEdit_OnTabPressed_Override", "replace");
			Sea.util.hook("ChatEdit_OnEnterPressed", "Sky_ChatEdit_OnEnterPressed_Override", "replace");
			Sea.util.hook("ChatEdit_OnEscapePressed", "Sky_ChatEdit_OnEscapePressed_Override", "replace");
			Sea.util.hook("ChatEdit_OnSpacePressed", "Sky_ChatEdit_OnSpacePressed_Override", "replace");
			Sea.util.hook("FCFDropDown_LoadChannels", "Sky_FCFDropDown_LoadChannels_Override", "replace");		
		end
	end;

	--[[
	--	resetTimers()
	--		Resets the system timers
	--]]
	resetTimers = function()
		Chronos.scheduleByName("SkyBandwidthReset", 2, SkyChannelManager.timedReset);
		Chronos.scheduleByName("SkyChannelMonitor", 2, SkyChannelManager.updateChannels);
		Chronos.scheduleByName("SkyDelivery", 	3, SkyDeliveryMan.doRoutine);
		Chronos.scheduleByName("SkyPostalSort",	3, SkyPostOffice.doRoutine);
	end;

	--[[
	--	flush()
	--		Forces all timers to go off
	--		(Don't use this, unless you really want lag)
	--
	--]]
	flush = function()
		Chronos.scheduleByName("SkyBandwidthReset", 0.03);
		Chronos.scheduleByName("SkyChannelMonitor", 0.06);
		Chronos.scheduleByName("SkyDelivery", 	0.09);
		Chronos.scheduleByName("SkyPostalSort",	0.12);		
	end;

	--[[
	-- 	activate()
	--		Turns Sky on 
	--]]
	activate = function()
		if ( not Sky.online ) then 
			Sky.InitLoaded = true;
			Sky.resetTimers(); 
			Sky.setSkyStatus("on");
		end
	end;

	--[[
	--	deactivate()
	--		Turns Sky off
	--]]		
	deactivate = function()
		if ( Sky.online ) then 
			Sky.setSkyStatus("off");
		end
	end;
};

-- Local Chat Handling
SkyChat =  {
	-- A list of the slash commands
	slashCommands = {};

	-- Event map
	eventMap = {};

	-- Join parser
	joinParser = function(msg) 
		
		local _, _, name, password, number = string.find(msg, "%s*([^%s]+)%s*([^%s]*)%s*(.*)");
		local chatFrame = SELECTED_CHAT_FRAME; --FCF_GetCurrentChatFrame();
		
		if (not name) or (strlen(name) <= 0) then
			local joinhelp = TEXT(getglobal("CHAT_JOIN_HELP"));
			local info = ChatTypeInfo["SYSTEM"];
			chatFrame:AddMessage(joinhelp, info.r, info.g, info.b, info.id);
		else
			local zoneChannel, channelName = JoinChannelByName(name, password, chatFrame:GetID());
			if ( channelName ) then
				name = channelName;
			end
			if ( zoneChannel ) and ( not SkyChannelManager.isSkyChannel(name) ) then
				ChatFrame_AddChannel(chatFrame, name);
			end
		end
		
		Chronos.scheduleByName("SkyChannelMonitor", 0);
	end;

	-- Leave parser
	leaveParser = function(msg) 
		local channel = gsub(msg, "%s*([^%s]+).*", "%1");
		local chatFrame = SELECTED_CHAT_FRAME; --FCF_GetCurrentChatFrame();
		if(string.len(channel) <= 0) then
			local joinhelp = TEXT(getglobal("SKY_LEAVE_HELP"));
			Sea.io.printfc(chatFrame,  ChatTypeInfo["SYSTEM"], joinhelp);
		else		

			Sea.io.dprint(SKY_DEBUG_CC, " Leave msg: ", msg, " n: ", channel);
			
			--if ( type (tonumber(channel)) == "number" ) then 
			--	channel = tonumber(channel);
			--end
			local identifier, specificID = SkyChannelManager.convertToChannelIdentifier(channel);
			-- Warn the user before they leave 
			if ( SKY_LEAVE_WARNINGS[identifier] ) then
				Sea.io.printfc(chatFrame,  ChatTypeInfo["SYSTEM"], SKY_LEAVE_WARNINGS[identifier] );
			end

			LeaveChannelByName(channel);
			Chronos.scheduleByName("SkyChannelMonitor", 0);
		end
	end;

	-- Chat Shortcut handler
	--
	chatShortcut = function( msg, command ) 
		local channel = nil;
		
		Sea.io.dprint(SKY_DEBUG_CC, "Call Shortcut: ", msg, " cmd:", command);
		if ( command and command ~= string.gsub(command, "/(%w+).*", "%1") ) then
			channel = string.gsub(command, "/(%w+).*", "%1");
			if ( tonumber(channel) ) then
				channel = tonumber(channel);
			end
	
			if ( Sky.isChannelActive(channel) ) then
				if ( not SkyChannelManager.isSkyChannel(channel) ) then
					SkyChannelManager.sendMessageToChannel(msg, channel);
				else
					Sea.io.dprint(SKY_DEBUG_CM,"Bad Boy! You can't exec chat on hidden sky channel ",channel);
				end
			end
		else
			Sea.io.printfc ( SELECTED_CHAT_FRAME, ChatTypeInfo["SYSTEM"], HELP_TEXT_SIMPLE);
		end;
	end;

	--
	-- Chat parser
	-- 
	channelParser = function ( msg, command )
		local channel = nil;
		if ( command and command ~= string.gsub(command, "/(%w+).*", "%1") ) then
			channel = string.gsub(command, "/(%w+).*", "%1");
			if ( tonumber(channel) ) then
				channel = tonumber(channel);
			end

			Sea.io.dprint(SKY_DEBUG_CC, "Channel Parser:  channel:", channel );
			
			-- Update the header
			Sky_ChatEdit_UpdateHeader_Override(this, channel);
		end;
	end;

	--
	--	channelListRequest
	--
	--		Shows Channel Listings.
	--		
	channelListRequest = function ( msg, command ) 
		local _, _, channel = string.find(msg, "^%s*(.*)%s*$");
		Sea.io.dprint(SKY_DEBUG_CC, "Requesting ", channel, " via " , command ); 
		channel = GetChannelName(channel);
		Sea.io.dprint(SKY_DEBUG_CC, "Channel User List Request: \"", channel, "\"" );
		if (channel ~= 0) then
			ListChannelByName(channel);
		else
			ListChannels();
		end
	end;

	--
	--	buildEventMap
	--		builds a map of events to ids
	--
	buildEventMap = function()
		SkyChat.eventMap = {};

		for k,v in SkyPostOffice.mailboxes do 
			for k2,v2 in v.events do 
				if ( not SkyChat.eventMap[v2] ) then
					SkyChat.eventMap[v2] = {};
				end

				-- Add k to the list
				table.insert(SkyChat.eventMap[v2], k);
			end

			for k2,v2 in v.events do 
				-- Sort by weight
				table.sort(SkyChat.eventMap[v2], function(a,b) return SkyPostOffice.mailboxes[a].weight < SkyPostOffice.mailboxes[b].weight; end );
			end
		end;
	end;
};

-- A list containing the known sky users and their locations
SkyUserList = {
};

-- Incoming message data
SkyPostOffice = {
	-- The messages waiting for someone to love them
	mailbox = {};
	
	-- The assembled envelopes awaiting sorting
	inbox = {};

	-- Incoming Pieces
	incomingDatagrams = {};

	-- Partial Envelopes
	partialEnvelopes = {};

	-- A list of the chat watching mods (data is not stored here)
	mailboxes = {};

	-- A list of the alerts
	alerts = {};
	
	-- Last packet
	lastMessage = {};

	-- Checklist for messages
	checklist = { "event", "arg1", "arg2", "arg3", "arg5", "arg6", "arg7", "arg8", "arg9", "time" };

	--
	--	unwrapDatagram(msg)
	--
	--		Creates a datagram from a text string
	--
	--	Returns:
	--		table - the datagram
	--
	unwrapDatagram = function(msg) 
		local datagram = {};
		
		-- Extract table
		local _, _, dtype, targetid, datagramid, sequenceNumber, sequenceCount, length, ttl, data = string.find(msg,
			"<Sky(%w-)> %[(%w*)%] (%d+) (%d+)%/(%d+) {(%d+)} %((%d+%.?%d+)%) (.*)"
			);

		-- Convert to Datagram
		datagram.id = tonumber(datagramid);
		datagram.target = targetid;
		datagram.sequenceNumber = tonumber(sequenceNumber);
		datagram.sequenceCount = tonumber(sequenceCount);
		datagram.length = tonumber(length);
		datagram.ttl = tonumber(ttl);
		datagram.data = data;

		if ( not datagram.ttl ) then
			datagram.ttl = SKY_TIME_TO_LIVE;
		end

		-- Set the expiration date
		datagram.expiration = GetTime() + datagram.ttl;
		
		if ( dtype == "" or dtype == "SM" ) then
			datagram.method = "text";
		elseif ( dtype == "ST" ) then
			datagram.method = "complex";
		elseif ( dtype == "SQ" ) then
			datagram.method = "request";
		elseif ( dtype == msg ) then
			datagram.method = "pure";
		else
			-- This should never happen, alerts should be taken 
			-- care of right away. But just in case:
			datagram.method = "alert";
			datagram.target = dtype;
		end			
		
		return datagram;
	end;
	
	--
	--	cacheDatagram
	--		Stores a datagram for later processing
	--
	cacheDatagram = function ( datagram ) 
		table.insert(SkyPostOffice.incomingDatagrams, datagram);
	end;
	
	--
	--	requestDatagram(player, datagramid, sequenceNumber)
	--		Requests a datagram if it is found to be missing. 
	--
	requestDatagram = function (player, datagramid, sequenceNumber, channel)
		
	end;
	
	--
	--	processEvent(event)
	--		processes an event.
	--		arg1, arg2, ... arg9 are all global values
	--
	--		For CHAT_MSG types: 
	--			arg1 - message 
	--			arg2 - player
	--			arg3 - language (or nil)
	--			arg4 - fancy channel name (5. General - Stormwind City)
	--				   *Zone is always current zone even if not the same as the channel name
	--			arg5 - Second player name when two users are passed for a CHANNEL_NOTICE_USER (E.G. x kicked y)
	--			arg6 - AFK/DND "CHAT_FLAG_"..arg6 flags
	--			arg7 - zone ID
	--				1 (2^0) - General
	--				2 (2^1) - Trade
	--				2097152 (2^21) - LocalDefense
	--				8388608 (2^23) - LookingForGroup
	--				(these numbers are added bitwise)
	--			arg8 - channel number (5)
	--			arg9 - Full channel name (General - Stormwind City)
	--				   *Not from GetChannelList
	--
	processEvent = function(event)
		local blocked = false;
		
		if ( not SkyPostOffice.lastMessage ) then 
			SkyPostOffice.lastMessage = {};
		end
		
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		local channelNumber = arg8;
		local channelIdentifier, specifier = SkyChannelManager.convertToChannelIdentifier(arg9);
		local zoneIdentifier = SkyChannelManager.convertToZonedChannelIdentifier(arg9);
		
		-- Bell conversion converts all incomming bells (\007) to line breaks since sending linebreaks causes disconnects.
		-- I don't think any localizations use this, but I'll change it if we find conflicts.
		if (type(arg1)=="string") then
			arg1 = string.gsub(arg1, "\007", "\n");
		end
		
		-- Wrap around the default channel system
		if ( Sea.string.startsWith(event, "CHAT_MSG_CHANNEL") ) then		

			-- Print the Chat list
			if ( string.sub(event,18) == "LIST" ) then
				
				if ( channelNumber == 0 ) then
					Sea.io.dprint(SKY_DEBUG_CM, "Sky Event - Full channel list.");

					arg1 = SkyChannelManager.makeChannelList();
					
					-- Send all the channel list notices
					if ( SkyChannelManager.hostMap[channelIdentifier] ) then
						for k,id in SkyChannelManager.hostMap[channelIdentifier] do 
							SkyChannelManager.hostesses[id].callback(SKY_CHANNEL_LIST, {channel=channelIdentifier;list=SkyUserList[channelIdentifier]} );
						end
					end
					
					return true;
				else
					Sea.io.dprint(SKY_DEBUG_CM, "Sky Event - Channel user list for ", zoneIdentifier);
					
					-- Parse the list
					SkyPostOffice.parseChannelList( arg1, zoneIdentifier );
					
					if ( SkyChannelManager.hideChannelLists[zoneIdentifier] ) then 
						return;
					else
						return true;
					end
					
				end
			-- Print the Chat list
			elseif ( string.sub(event,18) == "NOTICE" ) then
				-- YOU_JOINED or YOU_LEFT
				if (not strfind(arg4, "%d+%. .*")) then
					-- YOU_LEFT, quickly followed by a YOU_CHANGED
					return;
				end
				
				Sea.io.dprint(SKY_DEBUG_CM, "Sky Event - Channel Notice: "..arg1);
				
				local info;
				if (type(arg8) == "number") then
					info = ChatTypeInfo["CHANNEL"..arg8];
				else
					info = ChatTypeInfo["CHANNEL_NOTICE"];
				end
				
				if ( arg1 == "YOU_JOINED" ) then 
					-- If we are joining the channel then we should reset the user list as we don't know if the old stuff is valid
					SkyPostOffice.resetChannelUserList( zoneIdentifier );
					SkyPostOffice.addUserToChannelList( zoneIdentifier, UnitName("player") );
					ListChannelByName(arg9, true);
				elseif ( arg1 == "YOU_LEFT" ) then 
					SkyPostOffice.removeUserFromChannelList( zoneIdentifier, UnitName("player") );
				elseif ( arg1 == "YOU_CHANGED" ) then 
					SkyPostOffice.addUserToChannelList( zoneIdentifier, UnitName("player") );
					ListChannelByName(arg9, true);
				end
				
				-- Print Joined Channel message in current ChatFrame and block regular msg
				if (not SkyHiddenJoinLeaveAlerts[channelIdentifier]) then
					--Sea.io.printfc(SELECTED_CHAT_FRAME, info, string.format(TEXT(getglobal("CHAT_"..arg1.."_NOTICE")), arg4) );
					Sea.io.printc(info, string.format(TEXT(getglobal("CHAT_"..arg1.."_NOTICE")), arg4) );
					--Sea.io.print(string.format(TEXT(getglobal("CHAT_"..arg1.."_NOTICE")), arg4) );
				end
				blocked = true;
				
				if ( SkyChannelManager.hostMap[channelIdentifier] ) then
					for k,id in SkyChannelManager.hostMap[channelIdentifier] do 
						if ( arg1 == "YOU_JOINED" ) then 
							SkyChannelManager.hostesses[id].callback(SKY_CHANNEL_JOIN, {channel=channelIdentifier} );

						elseif ( arg1 == "YOU_LEFT" ) then 
							SkyChannelManager.hostesses[id].callback(SKY_CHANNEL_LEAVE, {channel=channelIdentifier} );
						end
					end
				end
			elseif ( string.sub(event,18) == "JOIN" ) then	
				-- Parse the list
				SkyPostOffice.addUserToChannelList( zoneIdentifier, arg2 );
				
				if ( SkyChannelManager.hostMap[channelIdentifier] ) then
					for k,id in SkyChannelManager.hostMap[channelIdentifier] do 
						SkyChannelManager.hostesses[id].callback(SKY_PLAYER_JOIN, {channel=channelIdentifier;username=arg2} );
					end
				end
			elseif ( string.sub(event,18) == "LEAVE" ) then
				-- Parse the list
				SkyPostOffice.removeUserFromChannelList( zoneIdentifier, arg2 );

				if ( SkyChannelManager.hostMap[channelIdentifier] ) then
					for k,id in SkyChannelManager.hostMap[channelIdentifier] do 
						SkyChannelManager.hostesses[id].callback(SKY_PLAYER_LEAVE, {channel=channelIdentifier;username=arg2} );
					end
				end
			end

			-- No longer needed since the number and names are correct.
			--local realChannelName = SkyChannelManager.convertToRealChannelName(channelIdentifier);
			--Sea.io.print("checking: ", " ", channelNumber, " ", realChannelName, " ", arg9);
			--[[
			if (channelNumber) and (not realChannelName) then
				local channelNumber, realChannelName = Sky.isChannelActive(channelNumber);
				if (channelNumber) then
					if (realChannelName) then
						arg4 = string.format(SKY_CHANNEL_FORMAT, channelNumber, realChannelName);
					elseif (arg9) then
						arg4 = string.format(SKY_CHANNEL_FORMAT, channelNumber, arg9);
					end
				else
					--channel is not active.
				end
			end
			]]--
		end

		-- Scan the last message to ensure we're not
		-- Parsing the same message twice.
		local matches = true;
		for k,v in SkyPostOffice.checklist do 
			if ( v == "time" ) then 
				-- Check the message delay
				if (SkyPostOffice.lastMessage[v] ) then 
					if ( GetTime() - SkyPostOffice.lastMessage[v] > SKY_BLOCK_MSG_DURATION ) then
						matches = false;
						break;
					end
				end
			elseif ( SkyPostOffice.lastMessage[v] ~= getglobal(v) ) then
				matches = false;
				break;
			end
		end

		-- If it matches, don't bother processing it again,
		-- just return the old blocked value
		if ( matches ) then 
			--Sea.io.error("COPY: " , SkyPostOffice.lastMessage.blocked);
			return (not SkyPostOffice.lastMessage.blocked);
		end

		if ( getglobal(SKY_DEBUG_S) ) then 
			Sea.io.printComma(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
		end
		
		-- Create this message's table
		-- Set the last message so we ignore duplicates
		local thisMessage = {
			event = event;
			arg1 = arg1;
			arg2 = arg2;
			arg3 = arg3;
			arg4 = arg4;
			arg5 = arg5;
			arg6 = arg6;
			arg7 = arg7;
			arg8 = arg8;
			arg9 = arg9;
			time = math.floor(GetTime());
			blocked = blocked;
		};

		-- First, handle the SkyChannel hiding
		if ( Sea.string.startsWith(event, "CHAT_MSG_CHANNEL") ) then
			-- Hide the #Iden# channels
			if ( SkyChannelManager.isSkyChannel(channelIdentifier) ) then 
				blocked = true;
				if ( arg1 ) then 
					-- Unwrap the datagram and stick it into the incoming folder
					local datagram = SkyPostOffice.unwrapDatagram(arg1);
					datagram.system = channelIdentifier; 		-- Set the channel it was sent on
					datagram.sender = arg2; 					-- Set the sender

					if ( datagram.method == "alert" ) then 
						SkyPostOffice.deliverAlert(datagram);
					else
						SkyPostOffice.cacheDatagram(datagram);
					end
				end
			end
			
		-- Check for Sky-based whispers
		elseif ( event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM" ) then 
			if ( Sea.string.startsWith(arg1, "<Sky") ) then 
				blocked = true;
				if ( event ~= "CHAT_MSG_WHISPER_INFORM" and arg1 ) then 
					-- Unwrap the datagram and stick it into the incoming folder
					local datagram = SkyPostOffice.unwrapDatagram(arg1);
					datagram.system = SKY_PLAYER; 		-- Set the channel it was sent on
					datagram.sender = arg2; 			-- Set the sender

					if ( datagram.method == "alert" ) then 
						SkyPostOffice.deliverAlert(datagram);
					else
						SkyPostOffice.cacheDatagram(datagram);
					end
				end
			end
		-- Check for non sky types
		elseif ( Sea.string.startsWith(event, "CHAT_MSG") ) then
			-- Remove the CHAT_MSG_ from events to make life easier
			thisMessage.type = string.sub(event, 10);
			thisMessage.msg = arg1;
			thisMessage.sender = arg2;
		
			-- Sort thisMessage into the appropriate mailboxes
			SkyPostOffice.scanEnvelope(thisMessage);

			if ( thisMessage.blocked ) then
				blocked = true;
			end
		else
			blocked = false;
		end

		-- Store the block
		thisMessage.blocked = blocked;

		-- Set the last message so we ignore duplicates
		SkyPostOffice.lastMessage = thisMessage;

		return (not blocked);

	end;

	-- 
	-- 	deliverAlert ( datagram ) 
	-- 		Treats the datagram as an envelope and delivers it
	-- 		to the associated alert if one exists
	--
	deliverAlert = function ( datagram )
		if ( SkyPostOffice.alerts[datagram.target] ) then 
			SkyPostOffice.alerts[datagram.target].func(datagram.data, datagram.sender, datagram.system, datagram.time);
		end
	end;
	
	--
	--	scanEnvelope (envelope)
	--		Scans an envelope, and put it in the appropriate mailbox if accepted
	--		
	--
	scanEnvelope = function ( envelope )	
		if ( not envelope or type(envelope) ~= "table" ) then return; end
		Sea.io.dprint(SKY_DEBUG, "Scanning Envelope ",envelope.type);
		-- Scan the event table
		if ( SkyChat.eventMap[envelope.type] ) then 
			for k, watchId in SkyChat.eventMap[envelope.type] do 
				-- Check if it was accepted
				if ( SkyPostOffice.mailboxes[watchId].acceptTest ) then
					Sea.io.dprint(SKY_DEBUG, "Attempting acceptance test for ",watchId);

					-- If accepted, add it to the mailbox
					if ( SkyPostOffice.mailboxes[watchId].acceptTest(envelope) )then
						if ( not SkyPostOffice.mailbox[watchId] ) then
							SkyPostOffice.mailbox[watchId] = {};
						end
						table.insert(SkyPostOffice.mailbox[watchId], envelope);
					end
				end
			end
		end
	end;
	
	--
	--	fillMailboxes()
	--		Moves completed inbox messages to the appropriate mailboxes
	--
	fillMailboxes = function () 
		Chronos.startTimer("SkyPostOfficeMailboxFilling");
		
		Sea.io.dprint(SKY_DEBUG_PO, "SkyPostOffice is filling mailboxes...");
		while ( SkyPostOffice.inbox[1] and 
			Chronos.getTimer("SkyPostOfficeMailboxFilling") < SKY_MAX_SORT_LENGTH ) do
			
			-- Take one down, scan it
			local envelope = table.remove(SkyPostOffice.inbox,1);	
			SkyPostOffice.scanEnvelope(envelope);
		end

		Chronos.endTimer("SkyPostOfficeMailboxFilling");
	end;

	--
	--	sortMail()
	--		Read through the messages and sort the datagrams. 
	--
	sortMail = function()

		Chronos.startTimer("SkyPostOfficeAssembly");
		
		-- Assemble the waiting datagrams in envelopes
		while ( SkyPostOffice.incomingDatagrams[1] and 
			Chronos.getTimer("SkyPostOfficeAssembly") < SKY_MAX_ASSEMBLY_LENGTH ) do
			datagram = SkyPostOffice.incomingDatagrams[1];

			-- Ensure we have a send and an ID
			if ( datagram.sender and datagram.id ) then 
				if ( not SkyPostOffice.partialEnvelopes[datagram.sender] ) then
					SkyPostOffice.partialEnvelopes[datagram.sender] = {};
				end
				if ( not SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id] ) then 
					SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id] = {};
					SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id].expiration = SKY_TIME_TO_LIVE;
				end
				
				local missing = false;
				
				-- Fill the pieces
				SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id][datagram.sequenceNumber] = datagram.data;
				SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id].expiration = GetTime() + datagram.ttl;

				--Sea.io.printTable( SkyPostOffice.partialEnvelopes );

				-- Check if we missed any
				if ( datagram.expiration > GetTime() ) then
					for i=1,datagram.sequenceNumber do 
						if ( not SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id][i] ) then
							Sea.io.derror(SKY_DEBUG, "Missing datagram: ",datagram.sender,", id:",datagram.id," segment: ",i);
							missing = true;
							-- NYI
							SkyPostOffice.requestDatagram(datagram.sender,datagram.id,i,datagram.system);
						end
					end
				end

				-- Check the sequence number, see if we are done 
				if ( datagram.sequenceNumber == datagram.sequenceCount ) then 
					local msg = "";
					for i=1,datagram.sequenceCount do 
						if ( not SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id][i] ) then
							Sea.io.derror(SKY_DEBUG, "Missing datagram: ",datagram.sender,", id:",datagram.id," segment: ",i);
							missing = true;
							-- NYI
							SkyPostOffice.requestDatagram(datagram.sender,datagram.id,i,datagram.system);
						else
							msg = msg..SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id][i];
						end
					end
					
					-- If its not missing, then store it away
					if ( not missing ) then
						if ( string.len(msg) == datagram.length ) then 
							-- If its a complex type, unserialize it!
							if ( datagram.method == "complex" ) then 
								msg = Sea.string.stringToObject(msg);
							end
							
							local envelope = {};
							envelope.type = datagram.system;
							envelope.expiration = datagram.ttl + GetTime();
							envelope.msg = msg;
							envelope.sender = datagram.sender;
							envelope.target = datagram.target;
							envelope.time = GetTime();

							--Sea.io.printTable(envelope);
	
							table.insert(SkyPostOffice.inbox, envelope);
						else
							-- Wipe out the pieces if the sum is invalid
							--Sea.io.derror(SKY_DEBUG, "Invalid envelope: id: ",datagram.id, " size: ", datagram.length, " actual: ", string.len(msg));
							-- Handled below now
							--SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id] = nil;
						end
						-- Data has been delt with, clean up the mess
						SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id] = nil;
					end
				end

				-- Expired
				if ( SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id] and
				     datagram.expiration < GetTime() ) then 
					Sea.io.derror(SKY_DEBUG, "Expired envelope: id: ",datagram.id, " size: ", datagram.length);
					SkyPostOffice.partialEnvelopes[datagram.sender][datagram.id] = nil;
				end
			end
			
			-- Remove this datagram
			table.remove(SkyPostOffice.incomingDatagrams, 1);
		end

		-- Fill the mailboxes with completed envelopes
		SkyPostOffice.fillMailboxes();		
	
		-- Post Office
		Chronos.endTimer("SkyPostOfficeAssembly");
	end;
	-- 
	--	trashExpiredMail()
	--		Destroys expired messages
	-- 
	trashExpiredMail = function()
		Chronos.startTimer("SkyPostOfficeCleanup");
		-- Clean out the inbox if nessecary
		for k,v in SkyPostOffice.inbox do
			if ( v.expiration < GetTime() ) then 
				Sea.io.dprint(SKY_DEBUG_PO, "Incoming envelope has expired: ", k);
				table.remove(SkyPostOffice.inbox,1);
			end

			if ( Chronos.getTimer("SkyPostOfficeCleanup") > SKY_MAX_CLEANUP_LENGTH ) then 
				break;
			end
		end

		local partialEmpty;
		-- Clean out the inbox if nessecary
		for username,partials in SkyPostOffice.partialEnvelopes do
			partialEmpty = true;
			for k,v in partials do 
				if ( v.expiration < GetTime() ) then 
					Sea.io.dprint(SKY_DEBUG_PO, "Incoming partial envelope has expired: ", k, " from user: ",username);
					SkyPostOffice.partialEnvelopes[username][k] = nil;
				else
					partialEmpty = false;
				end
			end

			if ( partialEmpty ) then
				SkyPostOffice.partialEnvelopes[username] = nil;
			end

			if ( Chronos.getTimer("SkyPostOfficeCleanup") > SKY_MAX_CLEANUP_LENGTH ) then 
				break;
			end
		end		

		Chronos.endTimer("SkyPostOfficeCleanup");
	end;

	--
	--	parseChannelList ( message, channel )
	--		Parses a message string to check the list of active users in the channel
	--
	parseChannelList = function ( msg, channel ) 
		local users = Sea.string.split(msg, ","); 
				
		if( not channel ) then 
			return; 
		end

		Sea.io.derror( SKY_DEBUG_CC,  "ChannelList: The channel being parsed is: ", channel);

		if ( not SkyUserList[channel] ) then 
			SkyUserList[channel] = {};
		end

		-- Strip out * and spaces
		for k,v in users do 
			k2 = string.gsub(v, "%s*%*?%@*(%a+).*", "%1");
			SkyPostOffice.addUserToChannelList(channel, k2);
		end
	end;
	
	--
	--	addUserToChannelList( channel, username)
	--	
	addUserToChannelList = function ( channel, username )
		if ( not SkyUserList[channel] ) then 
			SkyUserList[channel] = {};
		end
		
		SkyUserList[channel][string.lower(username)] = true;
	end;
	
	--
	--	removeUserFromChannelList( channel, username)
	--	
	removeUserFromChannelList = function ( channel, username )
		if ( not SkyUserList[channel] ) then 
			SkyUserList[channel] = {};
		end

		SkyUserList[channel][string.lower(username)] = nil;
	end;
	
	resetChannelUserList = function ( channel )
		SkyUserList[channel] = {};
	end;
	
	--
	--	doRoutine()
	--		Does its job and resets its timer
	--
	doRoutine = function()
		if ( Sky.online ) then
			Sea.io.dprint(SKY_DEBUG_PO, "SkyPostOffice is sorting the mail!");
			SkyPostOffice.sortMail();
			SkyPostOffice.trashExpiredMail();
		end
		Chronos.scheduleByName("SkyPostalSort", SKY_SORT_RESET_TIME, SkyPostOffice.doRoutine );
	end;
};

-- Outgoing message data
SkyDeliveryMan = {
	-- Message IDs
	messageID = 0;

	-- Outgoing messages
	outbox = {};

	-- Outgoing Pieces
	outgoingDatagrams = {};

	-- Sent Pieces
	sentDatagrams = {};

	-- 
	-- Obtains the next message ID
	-- 
	getNextMessageID = function() 
		SkyDeliveryMan.messageID = SkyDeliveryMan.messageID + 1;
		return SkyDeliveryMan.messageID;
	end;

	--
	--	fragmentEnvelopes()
	--
	--		This function breaks envelopes into datagrams.
	--	
	fragmentEnvelopes = function () 
		Chronos.startTimer("SKY_FRAGMENTER");
		Sea.io.dprint(SKY_DEBUG_D, "Fragmenting Envelopes");
		-- Chop up those envelopes
		while ( SkyDeliveryMan.outbox[1] and Chronos.getTimer("SKY_FRAGMENTER") < (1/30) ) do
			local data = "";
			local datagram = nil;
			local envelope = table.remove(SkyDeliveryMan.outbox,1);
			local datagramCount = math.ceil(string.len(envelope.data)/SKY_MAX_DATAGRAM_LENGTH);
			
			local sent = envelope.sent;
			local piece = string.sub(envelope.data, SKY_MAX_DATAGRAM_LENGTH * sent + 1 );
			envelope.id = SkyDeliveryMan.getNextMessageID();
			
			while ( piece and piece ~= "" ) do
				sent = sent + 1;
				
				datagram = {};
			
				datagram.id = envelope.id;
				datagram.method = envelope.method;
				datagram.target = envelope.target;
				datagram.player = envelope.player;
				datagram.system = envelope.system;
				datagram.expiration = GetTime() + SKY_TIME_TO_LIVE;
				datagram.ttl = SKY_TIME_TO_LIVE;
				datagram.sequenceNumber = sent;
				datagram.sequenceCount = datagramCount;

				-- Break it out
				data = string.sub(piece, 1, SKY_MAX_DATAGRAM_LENGTH);
				piece = string.sub(piece, SKY_MAX_DATAGRAM_LENGTH+1);

				-- Fill the datagram
				datagram.data = data;
				datagram.length = envelope.size;

				-- Queue it up
				table.insert(SkyDeliveryMan.outgoingDatagrams, datagram);

				envelope.sent = sent;
			end

		end	

		local spent = Chronos.endTimer("SKY_FRAGMENTER");
		Sea.io.dprint(SKY_DEBUG_D, "Fragment Envelope time spent: ", spent);
	end;


	--
	--	deliverDatagram(datagram)
	--
	--		Sends the datagram passed
	--
	--	Returns: 
	--		true - datagram was delivered
	--		false - datagram was not sent (wait for later please)
	--
	deliverDatagram = function(datagram)
		local system = datagram.system; 

		-- Pack it up
		local package = SkyDeliveryMan.packageDatagram(datagram);

		-- Should we ignore bandwidth restraints?
		local shouldIgnoreBandwidth = false;
		if ( datagram.method == "alert" ) then
			shouldIgnoreBandwidth = true;
		end
		
		-- Ship it out
		for k,v in SKY_CHANNELLIST_PRETTYPRINT do
			if ( system == k ) then
				if ( Sky.isChannelActive(k) ) then
					return SkyChannelManager.sendMessageToChannel(package, k, shouldIgnoreBandwidth);
				else
					Sea.io.derror(SKY_DEBUG, v, " is not an active Channel." );
					return false;
				end
			end
		end
		
		if ( string.lower(system) == "global") then 
			if ( Sky.isChannelActive(SKY_CHANNEL) ) then
				return SkyChannelManager.sendMessageToChannel(package, SKY_CHANNEL, shouldIgnoreBandwidth);
			else
				Sea.io.derror(SKY_DEBUG, "Sky in SkyChannels." );
				return false;
			end
		elseif ( system == SKY_PLAYER or string.lower(system) == "player" ) then 
			return SkyChannelManager.sendPlayerMessage(package, datagram.player, shouldIgnoreBandwidth);
		elseif ( string.lower(system) == "whisper" ) then
			return SkyChannelManager.sendWhisper(package, datagram.player, shouldIgnoreBandwidth);
		elseif ( string.lower(system) == "channel" ) then
			return SkyChannelManager.sendMessageToChannel(package, datagram.player, shouldIgnoreBandwidth);
		elseif ( string.lower(system) == "raid" 
			or string.lower(system) == "say" 
			or string.lower(system) == "party" 
			 or string.lower(system) == "guild" ) then 
			Sea.io.derror(SKY_DEBUG, "Invalid system passed to deliverDatagram" );
			return SkyChannelManager.sendSpecial(package, system, shouldIgnoreBandwidth)
		end
	end;

	--
	--	packageDatagram(datagram)
	--
	--		Formats a datagram into a string
	--
	--	returns:
	--		string - the datagram as a string
	packageDatagram = function (datagram)
		--[[
			Message Size: 
				255-192 = 72 characters free

		 	Components:
		 		"<Sky??>" - 7
				space - 1
				"[" - 1
				target - 8
				"]" - 1
				id - 8
				space - 1
				sequenceNumber - 8
				"/" - 1
				sequenceCount - 8
				space - 1
				{length} - 10
				space - 1
				(ttl) - 10

				total: 66 (6 flex)			
		]]--
		local package = "";
		
		-- Bell conversion converts all outgoing linebreaks to Bells (\007) and then back again when recieved.
		datagram.data =  string.gsub(datagram.data, "\n", "\007");
		
		-- Allow "pure" (unserialized) messages to be sent
		if ( datagram.method == "pure" ) then 
			return datagram.data;
		elseif ( datagram.method == "text" ) then 
			package = "<SkySM>";
		elseif ( datagram.method == "complex" ) then
			package = "<SkyST>";
		elseif ( datagram.method == "request" ) then 
			package = "<SkyRQ>";
		elseif ( datagram.method == "alert" ) then
			package = "<Sky"..datagram.target..">"; -- Sky custom packet type
		else
			package = "<SkyCU>";
		end

		if ( not datagram.target ) then 
			package = package.." ".."[".."]";
		else
			package = package.." ".."["..datagram.target.."]";			
		end
		package = package.." "..datagram.id;
		package = package.." "..datagram.sequenceNumber.."/"..datagram.sequenceCount;
		package = package.." ".."{"..datagram.length.."}";
		package = package.." ".."("..datagram.ttl..")";
		package = package.." "..datagram.data;
		
		return package;
	end;

	--
	--	deliver()
	--		Attempts to break up messages in its outbox
	--		Begins delivering messages
	--		Collects delivered messages 
	--		Destroys expired deliveries
	--
	deliver = function()
		-- Attempt to fragment anything thats in your outbox
		SkyDeliveryMan.fragmentEnvelopes();
	
		Chronos.startTimer("SkyDeliveryRun");

		-- Failed messages
		local failed = {};
		
		-- Deliver the messages
		while ( SkyDeliveryMan.outgoingDatagrams[1] and
			Chronos.getTimer("SkyDeliveryRun") < SKY_DELIVERY_MAX_LENGTH ) do
			datagram = SkyDeliveryMan.outgoingDatagrams[1];

			-- Try to deliver
			if ( not SkyDeliveryMan.deliverDatagram(datagram) ) then 
				Sea.io.dprint(SKY_DEBUG, "Failed to deliver datagram: ", datagram.id, " (", datagram.sequenceNumber,"/", datagram.sequenceCount,")", " target: ", datagram.target, " system: ", datagram.system, " player: ", datagram.player);
				-- If you can't deliver, chuck it if its expired
				if ( GetTime() > datagram.expiration ) then 
					Sea.io.dprint(SKY_DEBUG, "Datagram Expired: ", datagram.id, " (", datagram.sequenceNumber,"/", datagram.sequenceCount,")");
					table.remove(SkyDeliveryMan.outgoingDatagrams, 1);
				else
					-- Move to the end of the queue if failed
					table.insert(failed, datagram);
					table.remove(SkyDeliveryMan.outgoingDatagrams, 1);
				end
				break;
			else
				Sea.io.dprint(SKY_DEBUG, "Delivered: ", datagram.id, " (", datagram.sequenceNumber,"/", datagram.sequenceCount,")");
				-- If you can deliver, collect it locally till it expires
				table.remove(SkyDeliveryMan.outgoingDatagrams,1);
				if ( GetTime() < datagram.expiration ) then 
					table.insert(SkyDeliveryMan.sentDatagrams, datagram);
				end
			end
		end;
		
		-- Add failed deliveries back into your sack
		for k,v in failed do 
			table.insert(SkyDeliveryMan.outgoingDatagrams, v);
		end
		
		-- Remove expired mail from your recently sent list
		for k,datagram in SkyDeliveryMan.sentDatagrams do 
			if ( GetTime() > datagram.expiration ) then 
				Sea.io.dprint(SKY_DEBUG, "Datagram Expired: ",  datagram.id, " (", datagram.sequenceNumber,"/", datagram.sequenceCount,")");
				table.remove(SkyDeliveryMan.sentDatagrams, k);
			end
		end
		
		local spent = Chronos.endTimer("SkyDeliveryRun");
		Sea.io.dprint ( SKY_DEBUG_D, "Delivery Time Spent: ", spent );
	end;


	-- 
	--	doRoutine()
	--		Delivers and resets its timer. 
	--
	doRoutine = function()
		if ( Sky.online ) then 
			Sea.io.dprint(SKY_DEBUG_D, "Sky Delivery Man is Delivering!");
			SkyDeliveryMan.deliver();
		end
		Chronos.scheduleByName("SkyDelivery", SKY_DELIVERY_RESET_TIME, SkyDeliveryMan.doRoutine);
	end;
};

-- The system that tracks the channels
SkyChannelManager = {
	-- Messages Sent (In the last 60 seconds)
	messagesSent = 0;	

	-- A list of the channels whose listing is permitted
	-- comprised of full zoned system channel names, custom channels and sky identifiers
	hideChannelLists = {};

	-- A list of the hostesses registered
	hostesses = {};

	-- A map of channels to hosts
	hostMap = {};

	-- A number to allow particular actions to happen more rarely
	refreshCount = 0;
		
	getCurrentChannelTable = function ()
		local currentChannels = SkyTools.GetListFromIndexChannelArgList(GetChannelList());
		return currentChannels;
	end;
	
	--replaces GetListFromChannelArgList(EnumerateServerChannels()) because EnumerateServerChannels breaks on reload;
	getServerChannelTable = function ()
		local serverChannels = {};
		for k, v in SKY_SERVER_CHANNELS do
			table.insert(serverChannels, SKY_PRETTYPRINT[v]);
		end
		return serverChannels;
	end;
	
	getSkyChannelTable = function ()
		local skyChannels = {};
		for k, v in SKY_CHANNELS do
			table.insert(skyChannels, SKY_CHANNELLIST_PRETTYPRINT[v]);
		end
		return skyChannels;
	end;
	
	--name or number
	isSkyChannel = function (channel)
		if (not channel) then
			return;
		elseif ( SKY_CHANNELLIST_PRETTYPRINT[channel] ) then
			-- Given as SKY_IDENTIFIER
			return true;
		elseif (type(channel) == "number") then
			-- Given as number
			local currChannelList = SkyChannelManager.getCurrentChannelTable();
			channel = currChannelList[channel];
			if (not channel) then
				return;
			end
		end
		if ( SKY_CHANNELLIST_PRETTYPRINT[SkyChannelManager.convertToChannelIdentifier(channel)] ) then
			return true;
		end
		return;
	end;
	
	isSystemChannel = function(channel)
		for id, name in SKY_PRETTYPRINT do
			if (Sea.string.startsWith(strlower(channel), strlower(name))) then
				return true;
			end
		end
	end;
	
	isCustomChannel = function(channel)
		if (not SkyChannelManager.isSkyChannel(channel)) and (not SkyChannelManager.isSystemChannel(channel)) then
			return true;
		end
	end;
	
	-- Sky and SkyZone are always legal. The others depend on membership.
	isLegalSkyChannel = function (channel)
		local identifier, specialID = SkyChannelManager.convertToChannelIdentifier(channel);
		if ( SKY_CHANNELLIST_PRETTYPRINT[identifier] ) then
			if (identifier == SKY_PARTY) then
				if not (GetNumPartyMembers() > 0) then
					return false;
				end
			elseif (identifier == SKY_RAID) then
				if not (GetNumRaidMembers() > 0) then
					return false;
				end
			elseif (identifier == SKY_GUILD) then
				if (not GetGuildInfo("player")) then
					return false;
				end
			end
			return true;
		end
		return false;
	end;
	
	hideJoinLeaveAlerts = function (channel)
		local identifier, specialID = SkyChannelManager.convertToChannelIdentifier(channel);
		SkyHiddenJoinLeaveAlerts[identifier] = true;
	end;
	
	showJoinLeaveAlerts = function (channel)
		local identifier, specialID = SkyChannelManager.convertToChannelIdentifier(channel);
		SkyHiddenJoinLeaveAlerts[identifier] = nil;
	end;
	
	--
	--	updateChannelCommandList ()
	--		Updates the Sky Channel Manager slash commands. 
	--
	updateChannelCommandList = function()
		local newcommands = {};
		
		--[[
		-- Add /1 to /10
		for i=1,10 do
			table.insert(newcommands, "/"..i);
		end
		
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		-- All all custom commands if they are not already in there.
		for k,v in currChannelList do 
			if ( not Sea.table.isInTable(newcommands, "/"..k ) ) then
				table.insert(newcommands, string.lower("/"..k));
			end
		end
		]]--
		
		-- Make only Active Channels legal slash commands (must include all active channel indexes or they are are passed to the regular parser).
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		for k,v in currChannelList do 
			table.insert(newcommands, "/"..k);
			-- Add simple names of Non-Sky Channels
			if ( not SkyChannelManager.isSkyChannel(v) ) then
				table.insert(newcommands, "/"..string.lower(v));
			end
		end

		-- Update
		Sky.updateSlashCommand( { id = "SkyChannelManager", commands = newcommands } );
	end;
	

	--
	--	resetSkyUserList ( channel )
	--		Resets a channel listing
	--		
	resetSkyUserList = function ( channel ) 
		SkyUserList[channel] = {};
	end;

	
	-- 
	-- 	requestChannelList(channel, hidden)
	-- 		Requests a single channel's list of members
	--
	-- 	args:
	-- 		channel - the channel name
	-- 		hidden - if true it will hide the messages for this channel
	-- 		
	requestChannelList = function ( channel, hide )
		if ( not channel ) then 
			return;
		end
		
		--[[
		local index, channelName = Sky.isChannelActive(channel);
		if (not channelName) then
			Sea.io.dprint(SKY_DEBUG_CM, "Sky Hook - ListChannelByName called for inactive channel: ", channel);
			return true;
		end
		]]--
		zoneIdentifier = SkyChannelManager.convertToZonedChannelIdentifier(channel);
			
		-- Mark it as hidden or not
		if ( hide ) then 
			SkyChannelManager.hideChannelLists[zoneIdentifier] = true;
		else
			SkyChannelManager.hideChannelLists[zoneIdentifier] = nil;
		end
		
		Sea.io.dprint(SKY_DEBUG_CM, "Sky Hook - ListChannelByName requested channel list: ", zoneIdentifier);

		-- Clean the channel out
		-- ### Disabled on 2/21/05 due to not always getting the correct list
		--SkyChannelManager.resetSkyUserList(channel);
		
		-- Request the channel list
		return true;
	end;

	-- 
	-- 	joinChannel ( channel, pass, chatFrameID, silent )
	--		Joins a channel where message is of the format "ChannelName Password"
	-- 	
	--	args:
	--		channel - the channel name
	--
	--		 Optional:
	--		pass - the channel's password
	--		index - the new channel /# 
	--		silent - doesn't print any join messages (except default blizzard ones when the channel is visible in that chatframe)
	--		
	joinChannel = function(channel, pass, chatFrameID, silent)
		
		local zoneChannel = 0;
		local channelName = nil;
		
		-- Invalid channels 
		if ( not channel ) then
			return false, {zoneChannel, channelName};
		end
		
		-- Acocunt for empty string passwords
		if (pass == "") then
			pass = nil;
		end
		
		-- Catch "#. ChannelName" format
		local channelName, found = gsub(channel, "%d+.%s(%w+)", "%1");
		if (found > 0) then
			channel = channelName;
		end
		
		local chatFrame = SELECTED_CHAT_FRAME; --FCF_GetCurrentChatFrame();
		
		--[[
		-- Check if its already in the channel list
		if ( Sky.isChannelActive(channel) ) then
			if ( not silent ) then Sea.io.printfc(chatFrame,  ChatTypeInfo["SYSTEM"], string.format(SKY_CHANNEL_ALREADY_LISTED, SkyChannelManager.convertToRealChannelName(channel)) ) end;
			return false, {zoneChannel, channelName};
		end
		]]--

		-- add it
		if ( channel ) then 
			if ( SkyChannelManager.getChannelCount() > 9 ) then 
				if ( not silent ) then Sea.io.printfc(chatFrame,  ChatTypeInfo["SYSTEM"], string.format(SKY_CHANNEL_TOO_MANY_CHANNELS, channel) ) end;
			else
				if (SkyChannelManager.isSkyChannel(channel)) then
					if (SkyChannelManager.isLegalSkyChannel(channel)) then
						-- Avoids passwords and chat visibility
						-- Also forces joining the right Sky Channel so you can't join the channel for a zone, party, raid or guild that ur not in or a part of.
						local realName = SkyChannelManager.convertToRealChannelName(channel);
						zoneChannel, channelName = SkyChannelManager.trueJoin(realName);
					else
						local identifier, specialID = SkyChannelManager.convertToChannelIdentifier(channel);
						if ( identifier == SKY_RAID ) then
							Sea.io.printfc(SELECTED_CHAT_FRAME,  ChatTypeInfo["SYSTEM"], SKY_JOIN_WARNING_RAID );			
						elseif ( identifier == SKY_GUILD ) then
							Sea.io.printfc(SELECTED_CHAT_FRAME,  ChatTypeInfo["SYSTEM"], SKY_JOIN_WARNING_GUILD );
						elseif ( identifier == SKY_PARTY ) then 
							Sea.io.printfc(SELECTED_CHAT_FRAME,  ChatTypeInfo["SYSTEM"], SKY_JOIN_WARNING_PARTY );
						end
					end
				else
					zoneChannel, channelName = SkyChannelManager.trueJoin(channel, pass, chatFrameID);
				end					
			end				
		end

		return false, {zoneChannel, channelName};
	end;

	--
	--	leaveChannel ( channelOrIndex, silent ) 
	--		Leaves the channel.
	--  
	--	args:
	--		channelOrIndex - the channel name, short channel name, or channel identifier.
	--		silent - doesn't print any leave messages (except default blizzard ones when the channel is visible in that chatframe)
	--		
	--
	leaveChannel = function ( channelOrIndex, silent )

		--Sea.io.print("Attempting to Leave ", channelOrIndex);

		local departedChannelIndex, departedChannelName = Sky.isChannelActive(channelOrIndex);

		if ( departedChannelIndex ) then 
			-- Do the actual leaving
			SkyChannelManager.trueLeave(departedChannelName); -- return true?
			--Chronos.scheduleByName("SkyChannelMonitor", 0);

		else
			--channel not found? invalid
		end
		
	end;
		
	--
	--	getChannelCount()
	--		returns the number of channels you are currently in
	--
	getChannelCount = function()
		local count = 0;
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		
		for k,v in currChannelList do 
			count = count + 1;
		end
		
		--count hidden trade?
		
		return count;
	end;

	--
	--	makeChannelList()
	--		Returns a string that composes of the current channel list
	--
	makeChannelList = function ()
		local list = "";
		local skyList = {};
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		
		for k,v in currChannelList do	
			if ( SkyChannelManager.isSkyChannel(v) ) then
				--Sea.io.printComma("Found Sky Channel",v);
				table.insert(skyList, v);
			else
				list = list..string.format("["..SKY_CHANNEL_FORMAT.."]", k, v).." ";
			end
		end

		if (table.getn(skyList) > 0 ) then 
			local skyChans = "";
			local currIdentifier
			for k,v in skyList do
				if ( skyChans ~= "" ) then
					skyChans = skyChans..", ";
				end
				currIdentifier = SkyChannelManager.convertToChannelIdentifier(v);
				if ( SKY_CHANNELLIST_PRETTYPRINT[currIdentifier] ) then 
					skyChans = skyChans..SKY_CHANNELLIST_PRETTYPRINT[currIdentifier];
				end
				currIdentifier = nil
			end

			list = list..string.format(SKY_CHANNELS_LIST, skyChans);
		end
		return list;
	end;
	
	--	
	--	sendMessageToChannel(message, channelNameOrNumber)
	--		Send a message to the specified channel. 
	--
	--	Params: 
	--		message - some string
	--		channelNameOrNumber 
	--			- if a number, it selects the matching 
	--			channel name from SkyChannels
	--			- if a string, it selects the matching
	--			channel name
	--		ignoreBandwidth
	--			- if true, bandwidth restrictions are ignored
	--		
	--	Returns:
	--		true - channel was found, message was sent. 
	--		false - channel was not found, message was not sent.
	--
	sendMessageToChannel = function (message, channelNameOrNumber, ignoreBandwidth)
		if ( not message or message == "" ) then return true;end

		-- Check if the channel is OK and the bandwidth limit is ok
		local channelNumber, channelName = Sky.isChannelActive(channelNameOrNumber)
		if ( not channelNumber ) then 
			Sea.io.dprint(SKY_DEBUG, "sendMessageToChannel: ", number, " ", channelNameOrNumber, " unavailable");
			return false;
		elseif ( not ignoreBandwidth and SkyChannelManager.messagesSent > SKY_MAX_MESSAGES_PER_RESET ) then
			Sea.io.derror(SKY_DEBUG, "Exceeded the outgoing message bandwidth. ");
			return false;
		else
			Sea.io.dprint(SKY_DEBUG, "sendMessageToChannel: ", channelNumber, " ", channelName);
			
			SkyChannelManager.messagesSent = SkyChannelManager.messagesSent + 1;
			SendChatMessage(message, "CHANNEL", nil, channelNumber );
			return true;
		end;
	end;

	--
	--	sendWhisper(message, player, ignoreBandwidth)
	--		Sends a whisper to a player. Whispers are not hidden.
	--
	--	Params: 
	--		message - some string
	--		player - name of player to send message to
	--		ignoreBandwidth - if true, bandwidth restrictions are ignored
	--
	--	returns:
	--		true - message sent
	--		false - message not sent
	--	
	sendWhisper = function(message, player, ignoreBandwidth) 
		if ( not ignoreBandwidth and SkyChannelManager.messagesSent > SKY_MAX_MESSAGES_PER_RESET ) then
			Sea.io.derror(SKY_DEBUG, "Exceeded the outgoing message bandwidth. ");
			return false;
		else
			SkyChannelManager.messagesSent = SkyChannelManager.messagesSent + 1;
			SendChatMessage(message, "WHISPER", nil, player);
			return true;
		end		
	end;

	--
	--	sendSpecial(message, spec, ignoreBandwidth)
	--		Sends a whisper to a special channel, like party (/p) or raid (/ra) 
	--	args:
	--		message - message
	--		spec - the special type
	--		ignoreBandwidth - if true, bandwidth restrictions are ignored
	--
	--	returns:
	--		true - message sent
	--		false - message not sent
	--	
	sendSpecial = function(message, spec, ignoreBandwidth) 
		if ( not ignoreBandwidth and SkyChannelManager.messagesSent > SKY_MAX_MESSAGES_PER_RESET ) then
			Sea.io.derror(SKY_DEBUG, "Exceeded the outgoing message bandwidth. ");
			return false;
		else
			SkyChannelManager.messagesSent = SkyChannelManager.messagesSent + 1;
			SendChatMessage(message, string.upper(spec), nil, player);
			return true;
		end		
	end;	

	--
	--	sendPlayerMessage(message, player, ignoreBandwidth)
	--		Send a message to a player, checking if they have Sky first
	--		If they have sky, a sky encoded whisper is sent, which will
	--		be classified as a SKY_PLAYER message. 
	--
	--	Params: 
	--		message - some string
	--		player - name of player to send message to
	--		ignoreBandwidth - if true, bandwidth restrictions are ignored
	--
	--	returns:
	--		true - message sent, player online
	--		false - message not sent, player not sky user or is offline
	--
	sendPlayerMessage = function (message, player, ignoreBandwidth)
		local playerList = Sky.isSkyUser(player);
		
		if ( playerList ) then 
			return SkyChannelManager.sendWhisper(message, player, ignoreBandwidth);
		else
			Sea.io.derror(SKY_DEBUG, "Unable to find ", player, " in any Sky channels. ");
		end
		
		return false;
	end;
	
	--
	--
	--
	--	convertToRealChannelName ( channelNameOrNumber, specifier ) 
	--
	--		Takes a number, a channel name or a special "#SkyType#" and 
	--		converts it into the real channel name (correctly capitolized)
	--		Real: Current Zone (regardless of taxis), Raid Leader, Party Leader, Guild
	--
	--		e.g. SkyChannelManager.convertToRealChannelName("trade");
	--		  => "Trade - Orgrimmar"
	--
	--	returns:
	--		string - the current channel name
	--		
	convertToRealChannelName = function ( channelNameOrNumber, specifier )

		-- Strip the number if needed
		if ( type (channelNameOrNumber) == "number" ) then 
			local currChannelList = SkyChannelManager.getCurrentChannelTable();
			channelNameOrNumber = currChannelList[channelNameOrNumber];
		end
		
		if ( not channelNameOrNumber) then
			return;
		end
		
		local lowerChannelName = string.lower(channelNameOrNumber);
		
		if ( SKY_PRETTYPRINT[lowerChannelName] ) then
			channelNameOrNumber = SKY_PRETTYPRINT[lowerChannelName]
		end
		
		local suffix = "";
		
		if ( SKY_ZONE_AFFECTED_CHANNELS[lowerChannelName] ) then
			if (specifier) then
				suffix = " - "..specifier;
			else
				suffix = " - "..GetRealZoneText();
			end
		else
			for k,v in SKY_CHANNEL_FORMATING_STRINGS do
				-- Catch Sky Channel Identities or Anything Prefixed with a Sky Channel Short Name
				if  ( channelNameOrNumber == k ) or ( Sea.string.startsWith(lowerChannelName, string.lower(SKY_CHANNELLIST_PRETTYPRINT[k])) ) then
					channelNameOrNumber = v.prefix;
					if (specifier) then
						suffix = specifier;
					else
						suffix = SkyTools[v.suffixToolFunc]();
					end
					break;
				end
			end
		end
		
		return channelNameOrNumber..suffix;
	end;

	--
	--	convertToSimpleChannelName ( channelNameOrNumber )
	--		Takes a channel name like "General - Barrens" and turns it
	--		into "General". Or "SkyZoneIronforge" returns "SkyZone"
	--
	convertToSimpleChannelName = function ( channelName ) 
		local channelName = SkyChannelManager.convertToChannelIdentifier(channelName);

		if ( channelName ) then 
			if ( SKY_PRETTYPRINT[channelName] ) then
				return SKY_PRETTYPRINT[channelName];
			elseif ( SKY_CHANNELLIST_PRETTYPRINT[channelName] ) then
				return SKY_CHANNELLIST_PRETTYPRINT[channelName];
			else
				return channelName;
			end
		end
	end;
	
	--
	--	convertToZonedChannelIdentifier ( channelNameOrNumber )
	--		Takes a channel name like "General" and turns it
	--		into "General - Barrens". Or "SkyZone" returns "#Zone#""
	--
	convertToZonedChannelIdentifier = function ( channelName ) 
		
		local channelIdentifier, specifier = SkyChannelManager.convertToChannelIdentifier(channelName);
		if (SKY_ZONE_AFFECTED_CHANNELS[channelIdentifier]) and (not specifier) then
			-- System channel
			channelName = SkyChannelManager.convertToRealChannelName(channelIdentifier, specifier);
		elseif (SKY_CHANNELLIST_PRETTYPRINT[channelIdentifier]) then
			-- Sky Channel
			channelName = channelIdentifier;
		end
		
		return channelName;
	end;

	-- 
	-- 	convertToChannelIdentifier ( channel )
	-- 		Converts a channel into a channel identifier
	-- 		(e.g. 
	-- 			Sky => SKY_CHANNEL, 
	-- 			SkyPartySalamando => SKY_PARTY, "Salamando"
	-- 			General - Orgrimmar => SKY_GENERAL_ID )
	--	
	--	args:
	--		channel - channel name or number
	--
	-- 	returns: 
	-- 		nameOrId, identifierValue
	--
	-- 		nameOrId - either the channel name or the SKY_IDENTIFIER it matched
	-- 		identifierValue - either nil or the value of the identifier, 
	-- 		
	convertToChannelIdentifier = function ( channel )
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		if ( type ( tonumber(channel) ) == "number" ) then 
			channel = currChannelList[tonumber(channel)];
		end

		if ( not channel ) then 
			return nil;
		end
		
		if (SKY_CHANNELLIST_PRETTYPRINT[channel]) then
			-- Already a SKY_IDENTIFIER
			return channel;
		end
		
		local lowerChannelName = string.lower(channel);
		
		if ( SKY_PRETTYPRINT[lowerChannelName] ) then
			-- Short Standard Channel
			return lowerChannelName, nil;
		end
		
		for k,v in SKY_ZONE_AFFECTED_CHANNELS do
			if ( Sea.string.startsWith(lowerChannelName, k) ) then
				-- Long Standard Channel
				local channelZone = string.gsub(channel,"(%w+)%s?-%s?(%w+)", "%2");
				if (channelZone) then
					-- *capitalization of channelZone unchanged*
					return k, channelZone;
				end
			end
		end
		
		local lowerSkyPrefix;
		for k,v in SKY_CHANNELLIST_PRETTYPRINT do
			lowerSkyPrefix = string.lower(v);
			if (lowerChannelName == lowerSkyPrefix) then
				-- Short Sky Channel
				return k, nil;
			elseif (k ~= SKY_CHANNEL) and ( Sea.string.startsWith(lowerChannelName, lowerSkyPrefix) ) then
				-- Long Sky Channel (not applicable for SKY_CHANNEL)
				-- *capitalization of Sky Channel suffix unchanged*
				return k, strsub(channel, string.len(v)+1);
			end
		end
		
		return channel, nil;
			
	end;

	--
	--	buildHostMap()
	--		creates the host map for SkyChannelManager
	--
	buildHostMap = function()
		local map = {};

		for id, hostess in SkyChannelManager.hostesses do
			for k, channel in hostess.channels do
				if ( not map[channel] ) then
					map[channel] = {};
				end
				table.insert(map[channel],id);
			end
		end

		SkyChannelManager.hostMap = map;
	end;
	
	--	
	--	resetBandwidthLimit()
	--
	--		Please guess. Please? I'm begging you here.
	--
	resetBandwidthLimit = function()
		SkyChannelManager.messagesSent = 0;
	end;

	--
	--	timedReset()
	--
	--		Resets bandwidth every 60 seconds
	--		
	timedReset = function() 
		if ( Sky.online ) then
			Sea.io.dprint(SKY_DEBUG, "Bandwidth reset!");
			SkyChannelManager.resetBandwidthLimit();
		end
		Chronos.scheduleByName("SkyBandwidthReset", SKY_BANDWIDTH_RESET_TIME, SkyChannelManager.timedReset );
	end;

	--
	--	updateChannels()
	--		Removes old channels
	--		Joins all active channels in SkyChannels
	--
	updateChannels = function()
		if ( Sky.online ) then 
			Sea.io.dprint(SKY_DEBUG_CM, "Channel Refreshed!");
			--update hidden sky channels dependent upon changable values
			SkyChannelManager.updateActiveSkyChannels();
			SkyChannelManager.updateChannelCommandList();
		end
		Chronos.scheduleByName("SkyChannelMonitor", SKY_CHANNEL_MONITOR_TIME, SkyChannelManager.updateChannels );
	end;
	
	--
	--	updateActiveSkyChannels()
	--		Leaves old and unapplicable Sky channels and joins updated Sky Channels.
	--		SkyParty, SkyRaid, SkyZone, SkyGuild
	--
	updateActiveSkyChannels = function()
		--Sea.io.dprint(SKY_DEBUG_CM, "Sky Channels Updated!");
		local currenIdentifier = nil;
		local updatedChannel = nil;
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		for k,v in currChannelList do
			currenIdentifier = SkyChannelManager.convertToChannelIdentifier(v);
			if (SkyChannelManager.isSkyChannel(currenIdentifier)) then
				updatedChannel = SkyChannelManager.convertToRealChannelName(currenIdentifier);
				if ( v ~= updatedChannel ) then
					LeaveChannelByName(v, true);
					if (SkyChannelManager.isLegalSkyChannel(updatedChannel)) then
						JoinChannelByName(updatedChannel, nil, nil, true);
					end
				elseif (not SkyChannelManager.isLegalSkyChannel(currenIdentifier)) then
					LeaveChannelByName(v, true);
				end
			end
		end
	end;
	
	printChatList = function()
		local info = ChatTypeInfo["CHANNEL_LIST"];
		Sea.io.printfc(SELECTED_CHAT_FRAME, info, SkyChannelManager.makeChannelList());
	end;
	
};

-- A table of useful tools
SkyTools =  {
	
	getEmptyString = function ()
		return "";
	end;

	GetListFromIndexChannelArgList = function (...)
		local list = {};
		for i=1, arg.n, 2 do
			table.insert(list, tonumber(arg[i]), arg[i+1]);
		end
		return list;
	end;

	GetListFromChannelArgList = function (...)
		local list = {};
		for i=1, arg.n do
			table.insert(list, arg[i]);
		end
		return list;
	end;


	--
	--
	--	getPartyLeaderName()
	--
	--		Obtains the party leader's name in a party, 
	--		Obtains the subgroup leader's name in a raid,
	--		Obtains the player's name while alone
	--
	--	returns:
	--		string: the leader's name
	--		
	getPartyLeaderName = function ()
		local leaderName = UnitName("player");
				
		if ( GetNumRaidMembers() > 1 ) then
			-- If we are in a raid, pick the top-most player
			local groupLeaders = {};
			for i=1, GetNumRaidMembers(), 1 do
				local name, rank, subgroup = GetRaidRosterInfo(i);

				-- Store the names of the subgroup leaders
				-- Until we find the player
				if ( not groupLeaders[subgroup] ) then 
					groupLeaders[subgroup] = name;
				end
				
				-- If we find the player, return the leader of his
				-- Subgroup
				if ( name == UnitName("player") ) then
					leaderName = groupLeaders[subgroup];
					break;
				end
			end
		elseif ( GetNumPartyMembers() > 0 ) then 
			-- If we are in a party, pick the party leader
			if (GetPartyLeaderIndex() == 0) then
				leaderName = UnitName("player");
			else
				leaderName = UnitName("party"..GetPartyLeaderIndex());
			end				
		end

		if ( not leaderName or leaderName == "" ) then 
			leaderName = UnitName("player");
			if ( not leaderName ) then leaderName="ErrorOccurred"; end
		end
		return leaderName;
	end;

	--
	--	getRaidLeaderName()
	--
	--		Returns the name of the raid leader in a raid
	--		Returns the name of the player otherwise
	--		
	--
	getRaidLeaderName = function()
		local leaderName = UnitName("player");

		if ( GetNumRaidMembers() > 1 ) then
			if ( IsRaidLeader() ) then 
				leaderName = UnitName("player");
			else
				for i=1, GetNumRaidMembers(), 1 do
					local name, rank, subgroup = GetRaidRosterInfo(i);
					if (rank == 2) then
						leaderName = name;
						break;
					end
				end
			end
		end
		if ( leaderName == nil ) then 
			leaderName = "ErrorOccurred";
		end
		return leaderName;
	end;

	--
	--	getZoneName()
	--
	--		Returns the name of the current zone
	--		Will remove spaces and special characters
	--	
	getZoneName = function()
		local text = GetRealZoneText();

		text = string.gsub(text, "(%w+).*", "%1");

		return text;
	end;

	--
	--	getGuildName()
	--
	--		Returns the name of the current player's guild
	--		Will remove spaces and special characters
	--	
	getGuildName = function()
		local guildName = GetGuildInfo("player");

		if ( guildName ) then 
			guildName = string.gsub(guildName, "[^%w]", "");
			if ( string.len(guildName) > 20 ) then
				local ender = string.sub(guildName,20);
				guildName = string.sub(guildName,1,20);

				-- Make a short bytesum
				local num = Sea.string.byteSum(ender);				
				num = math.mod(num,10000);

				guildname = guildName..tostring(num);
			end
		else
			guildName = "Unguilded";
		end

		return guildName;
	end;
};

 --[[
 --	sendMessage(message [, channel, target, player])
 --
 --		Sends a simple text message to a 
 --		specified target using Sky. 
 --
 --	Args:
 --		message - the text to be delivered
 --
 --		optional:
 --		
 --		system - system used for transport 
 --			SKY_CHANNEL | "global" - sends to all Sky users
 --			SKY_PARTY  - sends to party members using Sky
 --			SKY_RAID - sends to all raid members using Sky
 --			SKY_GUILD - sends to all guild members using Sky
 --			SKY_PLAYER sends to a player using sky, hiding the message
 --			"SAY" sends to the world regardless of Sky usage
 --			"WHISPER" sends to a player regardless of Sky usage
 --			"PARTY" sends to a party regardless of Sky usage
 --			"GUILD" sends to a guild regardless of Sky usage
 --			"RAID" sends to a raid regardless of Sky usage
 --			"CHANNEL" sends to a particular channel (1, general, etc)
 --			
 --		target - destination mailboxid
 --
 --		player - 
 --			( nil for party/raid/zone )
 --			( channel identifier for channel )
 --			( playername for player/whisper )
 --
 --]]
Sky.sendMessage = function( message, system, target, player )
	if ( not message ) then 
		Sea.io.error("No message sent to Sky by: ",this:GetName());
		return;
	end

	if ( type(message) ~= "string" and type(message) ~= "number" ) then
		Sea.io.error("Invalid message sent to Sky.sendMessage by : ",this:GetName(), " type: ", type(message));
		return;

	end

	if ( not system or system == "" ) then 
		system = "global";
	end

	if ( system == SKY_PLAYER or system == "whisper" or system == "channel" ) then
		if ( not player or player == "" ) then
			Sea.io.error("No player sent for message to Sky by: ", this:GetName());
			return;
		end
	end

	if ( target == "" ) then 
		target = nil;
	end

	-- Fill the envelope
	envelope = {};
	envelope.system = system;
	envelope.method = "text";
	envelope.data = message;
	envelope.target = target;
	envelope.player = player;
	envelope.ttl = SKY_TIME_TO_LIVE;
	envelope.size = string.len(message);
	envelope.sent = 0;

	-- Add it to the outbox
	table.insert(SkyDeliveryMan.outbox, envelope);

	-- Fragment the Envelopes
	SkyDeliveryMan.fragmentEnvelopes();
end

 --[[
 --	sendAlert (message [, system, alertid, player])
 --
 --		Sends a message instantly through Sky. 
 --		Alerts cannot be longer than SKY_MAX_DATAGRAM_LENGTH
 --		and cannot contain anything but text.
 --
 --	Args:
 --		message - message to be sent
 --		system - SKY_CHANNEL|SKY_PARTY|SKY_PLAYER|SKY_ZONE
 --		alertid - 2 character code to indicate who gets alerted
 --		player - player whispered
 --
 --	Returns:
 --		true - message parsed and sent
 --		false - unable to parse or unable to send
 --		
 --]]
Sky.sendAlert = function (message, system, alertid, player)
	if ( not message ) then 
		Sea.io.error("No message sent to Sky by: ",this:GetName());
		return;
	end
	
	if ( string.len(message) > SKY_MAX_DATAGRAM_LENGTH ) then 
		Sea.io.error("Message too long for sendAlert, sent from: ", this:GetName());
	end

	if ( type(message) ~= "string" and type(message) ~= "number" ) then
		Sea.io.error("Invalid message sent to Sky.sendAlert by : ",this:GetName(), " type: ", type(message));
		return;

	end

	if ( not system or system == "" ) then 
		system = "global";
	end

	if ( not alertid or alertid == "" ) then
		Sea.io.error("No target sent for alert message to Sky by: ", this:GetName());
		return;
	end

	-- Fill the envelope
	envelope = {};
	envelope.id = SkyDeliveryMan.getNextMessageID();	
	envelope.system = system;
	envelope.method = "alert";
	envelope.data = message;
	envelope.target = alertid;
	envelope.player = player;
	envelope.ttl = SKY_TIME_TO_LIVE;
	envelope.size = string.len(message);
	envelope.sent = 1;

	-- Create a datagram
	datagram = {};	
	datagram.id = envelope.id;
	datagram.method = envelope.method;
	datagram.target = envelope.target;
	datagram.player = envelope.player;
	datagram.system = envelope.system;
	datagram.expiration = GetTime() + SKY_TIME_TO_LIVE;
	datagram.ttl = SKY_TIME_TO_LIVE;
	datagram.sequenceNumber = 1;
	datagram.sequenceCount = 1;
	datagram.data = message;
	datagram.length = envelope.size;

	-- Attempt to send
	if ( not SkyDeliveryMan.deliverDatagram(datagram) ) then 
		Sea.io.dprint(SKY_DEBUG, "Failed to deliver fast datagram: ", datagram.id, " target: ", datagram.target);
		return false;
	else
		return true;
	end	
end;

--[[
--	sendTable( table [, method, target, playername])
--	
--		Sends a lua object to the target using Sky.
--		See sendMessage for argument details
--
--]]
Sky.sendTable = function ( complex, system, target, player ) 

	if ( not complex ) then 
		Sea.io.error("No message sent to Sky by: ",this:GetName());
		return;
	end

	local serialized = Sea.string.objectToString(complex);
	
	if ( not system or system == "" ) then 
		system = "global";
	end

	if ( system == SKY_PLAYER or system == "whisper" or system == "channel" ) then
		if ( not player or player == "" ) then
			Sea.io.error("No player sent for private tell to Sky by: ", this:GetName());
			return;
		end
	end

	if ( target == "" ) then
		target = nil;
	end

	-- Fill the envelope
	envelope = {};
	envelope.system = system;
	envelope.method = "complex";
	envelope.data = serialized;
	envelope.target = target;
	envelope.player = player;
	envelope.ttl = SKY_TIME_TO_LIVE;
	envelope.size = string.len(serialized);
	envelope.sent = 0;

	-- Add it to the outbox
	table.insert(SkyDeliveryMan.outbox, envelope);
	
	-- Fragment the Envelopes
	SkyDeliveryMan.fragmentEnvelopes();
	
end

--[[
--
--	sendPure( message [, channel, target] );
--		Sends a pure-text message to the specified target. 
--		Pure messages will be ignored by Sky clients.
--		
--
--	args:
--		See sendMessage for argument details.
--
--]]
Sky.sendPure = function( message, system, target, player )
	if ( not message ) then 
		Sea.io.error("No message sent to Sky by: ",this:GetName());
		return;
	end

	if ( type(message) ~= "string" and type(message) ~= "number" ) then
		Sea.io.error("Invalid message sent to Sky.sendMessage by : ",this:GetName(), " type: ", type(message));
		return;

	end

	if ( not system or system == "") then 
		system = "global";
	end

	if ( system == SKY_PLAYER or system == "whisper" or system == "channel" ) then
		if ( not player or player == "" ) then
			Sea.io.error("No target sent for message to Sky by: ", this:GetName());
			return;
		end
	end

	-- Fill the envelope
	envelope = {};
	envelope.system = system;
	envelope.method = "pure";
	envelope.data = message;
	envelope.target = target;
	envelope.player = player;
	envelope.ttl = SKY_TIME_TO_LIVE;
	envelope.size = string.len(message);
	envelope.sent = 0;

	-- Add it to the outbox
	table.insert(SkyDeliveryMan.outbox, envelope);

	-- Fragment the Envelopes
	SkyDeliveryMan.fragmentEnvelopes();
end


 --[[
 --
 --	registerMailbox({mailboxRegistrant}, ...)
 --
 --		Registers a mailbox which will drop messages into a 
 --		mailbox matching id, if acceptTest(message) returns true. 
 --
 --		See the mailboxRegistrant definition for more details
 --		
 --	Returns:
 --		true if successful
 --		false if unable to register
 --]]

Sky.registerMailbox = function (...)
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];

		if ( Sky.validateMailbox(v) ) then 
			SkyPostOffice.mailboxes[v.id] = v;
			SkyPostOffice.mailbox[v.id] = {};
		else 
			noproblems = false;
		end
	end

	-- Build the map to save time while processing
	SkyChat.buildEventMap();
	
	return noproblems;	
end

 --[[
 --	unregisterMailbox(id)
 --		unregisters the mailbox with the specified id
 --
 --	args:
 --		id - string id of the mailbox
 --]]
Sky.unregisterMailbox = function(id)
	SkyPostOffice.mailboxes[id] = nil;
	SkyPostOffice.mailbox[id] = nil;
	
	-- Build the map to save time while processing
	SkyChat.buildEventMap();	
end;

--[[ Validates a single chat watch ]]--
Sky.validateMailbox = function (v)
	local valid = true;
	if ( not v.id ) then 
		Sea.io.error("Invalid id passed for chat watch from ",this:GetName());
		return false;
	end

	if ( not v.acceptTest ) then
		Sea.io.error("No acceptTest function specified for ChatWatch: ", v.id);
		return false;
	end

	if ( not v.lifespan ) then 
		v.lifespan = SKY_TIME_TO_LIVE;
	end

	if ( not v.mailboxLimit ) then
		v.mailboxLimit = SKY_DEFAULT_MAILBOX_MAX;
	end

	if ( not v.weight ) then
		v.weight = SKY_DEFAULT_WATCH_WEIGHT;
	end

	if ( not v.events ) then 
		Sea.io.error("No Events specified for ChatWatch: ",v.id);
		return false;
	end

	-- Check the ID
	if ( v.id ) then 
		if ( SkyPostOffice.mailboxes[v.id] ) then 
			Sea.io.error("Duplicate watch Mailbox ID, ",v.id," from ",this:GetName());
			return false;
		end
	end
	
	
	-- Validate each part
	for k2,v2 in v do 
		if ( k2 ~= "id" ) then
			if ( not Sky.validateMailboxMember(k2,v2, v.id) ) then
				valid = false;
			end
		end
	end
	
	return valid;
	
end

--[[ Validate a member of the chat watch ]]--
Sky.validateMailboxMember = function (member, value, id ) 
	-- Check the events
	if ( member == "events" ) then 
		if ( type(value) ~= "table" ) then 
			if ( type(value) == "string" ) then 
				Sea.io.error("Event list sent to registerMailbox is specified a string, not a table. Please enclose in {}. [Event passed was ", event, " for id: ", id);
				return false;
			else
				Sea.io.error("Invalid event list sent to registerMailbox. id:",id );
				return false;
			end
		else
			for k,v in value do
				if ( type ( v ) ~= "string" ) then
					Sea.io.error ( "Invalid event type passed for id: ",id);
					return false;
				end
			end
		end
	end

	-- Check the acceptance Test
	--
	if ( member == "acceptTest" ) then
		if ( type(value) ~= "function" ) then 
			Sea.io.error("Invalid acceptTest sent to registerMailbox for id:",id, " from ", this:GetName());
			return false;
		end
	end

	-- Check the message lifespan
	--
	if ( member == "lifespan" ) then
		if ( type(value) ~= "number" ) then 
			Sea.io.error("Invalid lifespan sent to registerMailbox for id: ",id," from ", this:GetName(),". Must be a number!");
			return false;
		end
	end

	-- Check the mailbox limit
	--
	if ( member == "mailboxLimit" ) then
		if ( type(value) ~= "number" ) then 
			Sea.io.error("Invalid mailboxLimit sent to registerMailbox for id: ",id," from ", this:GetName(),". Must be a number!");
			return false;
		end
	end

	-- Check the weight
	--
	if ( member == "weight" ) then 
		if ( type ( value ) ~= "number" or value <= 1 ) then 
			Sea.io.error("Invalid weight sent to registerMailbox for id: ",id," from ", this:GetName(),". Must be a number and greater than 1! ", value);
			return false;
		end
	end

	-- No problems. 
	return true;
end

--[[
--	updateMailbox({mailboxUpdate});
--		
--		Updates the values in a particular mailbox. 
--
--		e.g. 
--			Sky.updateMailbox({id="MyMailbox",events={SKY_CHANNEL, SKY_PARTY} });
--
--			Will cause MyMailbox to recieve only SKY_CHANNEL and SKY_PARTY events. 
--	Args:
--		See mailbox definition for more information. 
--		(Usually at the end of this file)
--
--	Returns: 
--		true - it updated successfully
--		false - it failed to validate
--	
--]]
Sky.updateMailbox = function(...)
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];
		local valid = true;

		-- Ensure the ID is valid and already exists.
		if ( not v.id or not SkyPostOffice.mailboxes[v.id]) then noproblems = false; break; end
		
		-- Check Members
		for k2,v2 in v do 
			if ( not Sky.validateMailboxMember(k2,v2,v.id) ) then
				valid = false;
			else
				SkyPostOffice.mailboxes[v.id][k2] = v2;
			end
		end

		if ( not valid ) then 
			noproblems = false;
		end
	end

	-- Build Event Map
	SkyChat.buildEventMap();

	return noproblems;
end
	

 --[[
 --	registerAlert ( {alertRegistrant} [, {alertRegistrant} ] ... )
 --
 --		Registers an alert watcher with Sky. 
 --		Alerts are called immediately, rather than stored. 
 --		This can cause lag if too many are sent. 
 --		You are warned!
 --]]
Sky.registerAlert = function (...)
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];

		if ( Sky.validateAlert(v) ) then 
			SkyPostOffice.alerts[v.id] = v;
		else 
			noproblems = false;
		end
	end

	return noproblems;
end;

 --[[
 --	unregisterAlert(id)
 --		Unregisters an alert by its id
 --
 --	args:
 --		id - string id
 --
 --]]
Sky.unregisterAlert = function(id)
	SkyPostOffice.alerts[id] = nil;
end;
 
--[[ Validates an Alert ]]--
Sky.validateAlert = function (alert)
	if ( not alert.id ) then 
		Sea.io.error ( "You must have a 2 character ID for registerAlert! ", this:GetName() );
		return false;
	end

	if ( string.len(alert.id) ~= 2 ) then 
		Sea.io.error ( "Your alert ID must be exactly 2 characters! ", alert.id, " from ", this:GetName() );
		return false;
	end
	
	if ( SkyPostOffice.alerts[alert.id] ) then
		Sea.io.error ( "Your alert ID is already in use: ", alert.id, " from ", this:GetName() );
		return false;
	else
		valid = true;
		
		-- Check Members
		-- 
		for k2,v2 in alert do 
			if ( not Sky.validateAlertMember(k2,v2,alert.id) ) then
				valid = false;
			end
		end		

		return valid;
	end
end;

--[[ Validates a single member of an alert ]]--
Sky.validateAlertMember = function ( key, value, id ) 
	if ( key == "func" ) then 
		if ( type ( value ) ~= "function" ) then 
			Sea.io.error ("Invalid function passed for Alert ID: ", id );
			return false;
		end
	end
	
	if ( key == "description" ) then 
		if ( type ( value ) ~= "string" ) then 
			Sea.io.error ("Invalid description passed for Alert ID: ", id );
			return false;
		end
	end

	return true;
end;

 --[[
 --	registerHostess( {skyHostess} [, {skyHostess}] )
 --		Registers a hostess who gets informed as channels are made available,
 --		removed, or when players are joined/added. 
 --
 --	args:
 --		skyHostess - table
 --			{
 --				id - unique id for the hostess
 --				callback - function called when a channel event occurs
 --					(action, actionData)
 --					action - string containing 
 --						SKY_PLAYER_JOIN|SKY_PLAYER_LEAVE|SKY_CHANNEL_LIST|SKY_CHANNEL_JOIN|SKY_CHANNEL_LEFT
 --					actionData - table
 --						{
 --							channel - channel name (SKY_CHANNEL or whatever)
 --							
 --						(action dependent:)
 --							username - string - username of the player who joined/left
 --							list - table - users in channel
 --						}
 --					
 --				channels - table containing channels
 --					SKY_CHANNEL, SKY_PARTY, "general", etc
 --				description - short string describing the addon
 --			}
 --]]
Sky.registerHostess = function ( ... ) 
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];
		
		local valid = true;
		if ( not v.id ) then 
			Sea.io.error("Nil id passed to registerHostess from ", this:GetName());
			valid = false;
		else
			-- Check ids
			if ( SkyChannelManager.hostesses [v.id] ) then
				Sea.io.error("Duplicate hostess ID: ", v.id, " sent from ", this:GetName() );
				valid = false;
			end
		end

		
		if ( valid and Sky.validateHostess(v) ) then 
			SkyChannelManager.hostesses[v.id] = v;
		else 
			noproblems = false;
		end
	end

	SkyChannelManager.buildHostMap();	
	return noproblems;
end;

--[[ Validates a Hostess ]]--
Sky.validateHostess = function (h)
	local valid = true;

	if ( not h.id ) then 
		Sea.io.error("Nil id passed to registerHostess from ", this:GetName());
		valid = false;
	end

	if ( type(h.callback) ~= "function" ) then 
		Sea.io.error("Invalid callpack passed to registerHostess for id ", h.id, " from ", this:GetName() );
		valid = false;
	end

	-- Be nice to users
	if ( type(h.channel) == "string" ) then 
		h.channels = { h.channel };
	end
	if ( type(h.channels) == "string" ) then 
		h.channels = { h.channels };
	end

	if ( type(h.channels) ~= "table" ) then 
		Sea.io.error("Invalid channels sent to registerHostess for id ", h.id, " from ", this:GetName() );
		valid = false;
	else
		for k,v in h.channels do 
			if ( type (v) ~= "string" ) then 
				Sea.io.error("Invalid channel sent to registerHostess for id ", h.id, " :  ", v , " from ", this:GetName());
				valid = false;
			end
		end
	end

	return valid;
end;

 --[[
 --	updateHostess ( {skyHostess} [, {skyHostess}] )
 --		Updates a hostess to have new values
 --
 --	args: 
 --		See registerHostess
 --
 --	returns:
 --		true - success
 --		false - failed to register
 --]]
Sky.updateHostess = function (...)
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];
		local valid = true;

		-- Ensure the ID is valid and already exists.
		if ( not v.id or not SkyChannelManager.hostesses[v.id]) then noproblems = false; end
		
		-- Check Members
		if ( Sky.validateHostess(v) ) then 
			SkyChannelManager.hostesses[v.id] = v;
		else 
			noproblems = false;
		end
	end

	return noproblems;
end
	
 --[[
 --	unregisterHostess(id)
 --		unregisters the specified hostess by id
 --
 --	args:
 --		id - string id
 --]]
Sky.unregisterHostess = function (id)
	SkyChannelManager.hostesses[id] = nil;
end;


 --[[
 --	isHostingByID(id)
 --		returns true if the id is already in use
 --		by a hostess
 --
 --	args:
 --		id - string id
 --
 --	returns:
 --		true - it exists
 --		false - not exists
 --]]
Sky.isHostingByID = function (id)
	return (SkyChannelManager.hostesses[id] ~= nil);
end;


--[[
--	registerSlashCommand ( {slashCommand} [, {slashCommand}] ...)
--
--		See the slashCommand definition for more information. 
--
--	(Should be at the end of this file)
--		
--	Example:
--		Sky.registerSlashCommand(
--			{
--				id = "SnoopyCommand";
--				commands = {"/snoop", "/snoopy"};
--				onExecute = function( msg, cmd ) Sea.io.print("You're snoopy, ", msg , "! You used: ", cmd ); end;
--				action = "before";
--				sticky = false;
--				helpText = "Shows the world you're nuts!"
--			}
--		);
--
--		/snoop Belldandy
--
--		Would print "You're snoopy, Belldandy! You used /snoop"
--
--		Action:
--			"hide"
--			If you return true from the slash command, it will attempt to 
--			call the default or previous slash command.
--
--			"before"
--			It will call your new function before the default command.
--
--			"after"
--			It will cally our new function after the default command.
--
--      Sticky:
--          true - The command will be saved so that when you bring up the
--                 edit box the next time the command will already be loaded
--          false or nil - The command will not be saved.
--
--	Returns:
--		true - success!
--		false - a command failed!
--
--]]
Sky.registerSlashCommand = function (...)
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];

		if ( Sky.validateSlashCommand(v) ) then 
			SkyChat.slashCommands[v.id] = v;
		else 
			noproblems = false;
		end
	end

	return noproblems;
end
 --[[
 --	unregisterSlashCommand(id)
 --		Removes the slash commands associated with that id
 --
 --	args:
 --		id - string id
 --
 --]]
Sky.unregisterSlashCommand = function (id)
	SkyChat.slashCommands[id] = nil;
end;

--[[
--	updateSlashCommand ( {slashCommandParts}, ... )
--
--		Updates a /command member if its valid.
--
--		e.g.
--			updateSlashCommand({id="myID";onExecute = fooFunc; } );
--
--			will change the onExecute function for myID.
--
--	arg members:
--		id - the ID matching the old slashCommand
--		member - onExecute | onSpace | onTab | commands | action | helpText | sticky
--		newvalue - the new value. 
--
--	returns:
--		true - successfully replace.
--		false - validation failed
--]]

Sky.updateSlashCommand = function ( ... ) 
	local noproblems = true;

	-- Quality checks first
	for i=1,table.getn(arg) do		
		local v = arg[i];
		local valid = true;

		-- Ensure the ID is valid and already exists.
		if ( not v.id or not SkyChat.slashCommands[v.id]) then noproblems = false; break; end
		
		-- Check Members
		for k2,v2 in v do 
			if ( not Sky.validateSlashMember(k2,v2,v.id) ) then
				valid = false;
			else
				SkyChat.slashCommands[v.id][k2] = v2;
			end
		end

		if ( not valid ) then 
			noproblems = false;
		end
	end

	return noproblems;
end

--[[ Validates a Slash Command ]]--
Sky.validateSlashCommand = function (v)
	local valid = true;
	if ( v.id == nil ) then 
		Sea.io.error("Nil id passed to registerSlashCommand from ", this:GetName());
		valid = false;
	else
		-- Check IDs
		if (SkyChat.slashCommands [v.id] ) then
			Sea.io.error ("Duplicate slash command ID: ", id, " Sent from: ", this:GetName());				
			valid = false;
		end

		-- Check Members
		for k2,v2 in v do 
			if ( not Sky.validateSlashMember(k2,v2,v.id) ) then
				valid = false;
			end
		end
	end

	return valid;
end;

--[[ Validates members individually ]]--
Sky.validateSlashMember = function ( member, value, id ) 
	if ( member ) then
	elseif ( member == "commands" ) then
		if ( type (value) ~= "table" ) then 
			Sea.io.error("Invalid command list passed for id (", id,") from ", this:GetName() );
			return false;
		else
			-- Ensure commands follow the format /cmd
			for k2,command in value do
				if ( string.gsub(command, "(/%w+)", "%1") ~= command ) then
					Sea.io.error("Invalid command: \"", command, "\" in ID: ", id);
					return false;				
				end
				if ( command ) then 
					local commandRegistered = Sky.isSkySlashCommand(command);
					if ( commandRegistered and commandRegistered.id ~= id ) then 
						Sea.io.error("Already registered: ", command, " by ", commandRegistered.id );
					end
				end
			end
			
		end	
	elseif ( member == "onExecute" ) then
		if ( type(v.onExecute) ~= "function" ) then
			Sea.io.error("Invalid or missing onExecute value for id ", id);
			return false;
		end
	
	elseif ( member == "onTab" ) then 
		if ( type(value) ~= "function" or type(value) ~= "nil" ) then
			Sea.io.error("Invalid onTab value for id ", id);
			return false;
		end
	elseif ( member == "onSpace" ) then 
		if ( type(value) ~= "function" or type(value) ~= "nil" ) then
			Sea.io.error("Invalid onTab value for id ", id);
			return false;
		end
	elseif ( member == "helpText" ) then
		if ( type(value) ~= "string" or type(value) ~= "nil" ) then
			Sea.io.error("Invalid helpText value for id ", id);
			return false;
		end
	-- Tuatara (March 9, 2005): Added sticky member so created check to make sure that it is boolean
	elseif ( member == "sticky" ) then
		if ( type(value) ~= "boolean" or type(value) ~= "nil" ) then
			Sea.io.error("Invalid sticky value for id ", id);
			return false;
		end
	end		
	return true;
end;

--[[
--	getNextMessage(mailboxID)
--		Returns a table containing the next message in that mailbox, or nil if no message exists
--		The message returns is removed from the mailbox.
--	
--		See the SkyEnvelope definition for more information
--			
--	returns:
--		table - the next message
--		nil - no message
--]]
function Sky.getNextMessage(mailboxID)
	if ( SkyPostOffice.mailbox[mailboxID] ) then 
		if ( table.getn(SkyPostOffice.mailbox[mailboxID]) > 0 ) then
			return table.remove(SkyPostOffice.mailbox[mailboxID],1);
		end
	else
		Sea.io.error("Empty mailbox ID: ",mailboxID, " from ",this:GetName());
		return false;
	end
end

--[[
--	getAllMessages(mailboxID)
--		Returns a table containing all of the messages in the mailbox. 
--		It will then empty the mailbox.
--
--	returns:
--		table of mailbox entries
--]]
function Sky.getAllMessages(mailboxID)
	if ( SkyPostOffice.mailbox[mailboxID] ) then 
		local messages = {};		
		local message = Sky.getNextMessage(mailboxID);

		-- Empty the mailbox
		while ( message ) do
			table.insert(messages, message);
			message = Sky.getNextMessage(mailboxID)
		end
		
		return messages;
	else
		Sea.io.error("Empty mailbox ID: ",mailboxID, " from ",this:GetName());
		return {}; 
	end
end

--[[
--
--	emptyMailbox(mailboxID)
--		Empties a mailbox with id mailboxID
--
--	args:
--		mailboxID - string which is the mailbox's ID defined in Sky.registerChatWatch
--
--	returns: 
--		nil
--]]
function Sky.emptyMailbox(mailboxID)
	if ( SkyPostOffice.mailbox[mailboxID] ) then 
		SkyPostOffice.mailbox[mailboxID] = {};
	end
end

--[[
--	checkBandwidth()
--		Check the status of the bandwidth limit.
--	returns:
--		A positive or negative number, the size of which indicates how
--		much over (positive) or under (negative) the client is relative
--		to the bandwidth limit.
--]]
function Sky.checkBandwidth()
	return SkyChannelManager.messagesSent - SKY_MAX_MESSAGES_PER_RESET;
end

--[[ SkyPostalSort Handlers ]]--

function SkyNothing()
end

function Sky_OnLoad()
	
	this:RegisterEvent("ZONE_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("RAID_ROSTER_UPDATE");
	this:RegisterEvent("GUILD_ROSTER_UPDATE");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	
	-- The real channel joining function
	Sea.util.hook("JoinChannelByName", "SkyNothing", "after");
	Sea.util.unhook("JoinChannelByName", "SkyNothing", "after");
	SkyChannelManager.trueJoin = Sea.util.Hooks["JoinChannelByName"].orig;

	-- The real channel leaving function
	Sea.util.hook("LeaveChannelByName", "SkyNothing", "after");
	Sea.util.unhook("LeaveChannelByName", "SkyNothing", "after");
	SkyChannelManager.trueLeave = Sea.util.Hooks["LeaveChannelByName"].orig;
			
	-- Start Sky
	--Chronos.afterInit(function() Sky.activate();  end );
	Sky.activate();

	-- Register Join/Leave
	Sky.registerSlashCommand(
		{
			id="JoinChannel";
			commands= SKY_JOIN_COMMANDS;
			onExecute=SkyChat.joinParser;
		},
		{
			id="LeaveChannel";
			commands= SKY_LEAVE_COMMANDS;
			onExecute=SkyChat.leaveParser;
		},
		{
			id="ListChannel";
			commands= SKY_LIST_COMMANDS;
			onExecute=SkyChat.channelListRequest;
		}
	);
	
	-- Register the Extended Channels
	-- Tuatara (March 9, 2005): Slash commands are now sticky
	Sky.registerSlashCommand(
		{
			id="SkyChannelManager";
			commands = {"/1", "/2", "/3", "/4", "/5", "/6", "/7", "/8", "/9", "/10"};
			onExecute=SkyChat.chatShortcut;
			onSpace=SkyChat.channelParser;
		}
	);
	
	
	-- Register the Script shortcut
	Sky.registerSlashCommand(
		{
			id="ScriptExecute";
			commands = {"/z"};
			onExecute=function(msg) RunScript(msg) end;
			helpText = SKY_Z_HELP;
		}
	);
	
	-- Register the Help Command
	Sky.registerSlashCommand(
		{
			id="SkyHelp";
			commands = SKY_HELP_COMMANDS;
			onExecute=function(msg) 
				local info = ChatTypeInfo["SYSTEM"];
				local i = 1;
				local text = TEXT(getglobal("CHAT_HELP_TEXT_LINE"..i));
				while text do
					Sea.io.printfc(ChatFrame1, info, text);
					i = i + 1;
					text = TEXT(getglobal("CHAT_HELP_TEXT_LINE"..i));
				end

				for id,sComm in SkyChat.slashCommands do 
					if ( sComm.helpText ) then 
						Sea.io.print( sComm.commands[1], " - ", sComm.helpText );
					end
				end
			end;
		}
	);
	
	-- Register the Print Command, useful for code testing
	Sky.registerSlashCommand(
		{
			id="SkyPrint";
			commands = SKY_PRINT_COMMANDS;
			onExecute = function(msg) 
				RunScript('Sea.io.printf(SELECTED_CHAT_FRAME, '..msg..')');
			end;
			helpText = SKY_PRINT_HELP;
		}
	);
	
	if ( SKY_TESTER_MODE ) then 

		-- Register the Test function
		Sky.registerSlashCommand(
			{
				id="SkyTest";
				commands = {"/skytest"};
				onExecute=function( a ) Sky.sendTable({abig="abcdfef",[3]=333,{"asdf",["65"]="shey",{a=1,b=2,c=3,d=4,e=5,f=6,g=7,h=8,i=9}}}, unpack(Sea.string.split(a," "))) end;
			}
		);


		-- Register a test program
		Sky.registerMailbox(
			{
				id="SkyTester";
				events = { SKY_RAID, SKY_CHANNEL, SKY_PARTY, SKY_ZONE, SKY_GUILD };
				acceptTest = function(e) Sea.io.printTable(e); Sea.io.printc({r=0,g=1,b=1}, "Got a message! Event:", e.type);  return true; end;
				weight = 5;
			}
		);		
		
	end

end

function Sky_OnEvent(event)
	
	if (not Sky.online) then
		return;
	end
	if (event == "VARIABLES_LOADED") then
		--nothing atm
	elseif (event == "ZONE_CHANGED") then
		Chronos.scheduleByName("SkyChannelMonitor", .5);
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		Chronos.scheduleByName("SkyChannelMonitor", .5);
	elseif (event == "RAID_ROSTER_UPDATE") then
		Chronos.scheduleByName("SkyChannelMonitor", .5);
	elseif (event == "GUILD_ROSTER_UPDATE") then
		Chronos.scheduleByName("SkyChannelMonitor", .5);
	elseif (event == "UNIT_NAME_UPDATE") then
		Chronos.scheduleByName("SkyChannelMonitor", .5);
	end
	
end

--[[ Overloaders for Sky ]]--
function Sky_ChatEdit_ParseText_Override (editBox, send)
	if ( not Sky.online ) then
		return true;
	end

	local text = editBox:GetText();
	if ( string.len(text) <= 0 ) then
		return;
	end
	
	if ( string.sub(text, 1, 1) ~= "/" ) then
		return;
	end	

	local command, msg = Sky_ChatEdit_ReadEdit(editBox);
	
	if ( not command ) then
		return true;
	end

	local continue = true;
	-- Check all of the registered Sky Slash Commands
	local slashCommand = Sky.isSkySlashCommand(command);
	
	if ( slashCommand ) then 
		if ( slashCommand.onSpace ) then
			continue = slashCommand.onSpace(msg, command);
		end
	end

	return continue;

end

function Sky_ChatEdit_OnTabPressed_Override()
	if ( not Sky.online ) then
		return true;
	end
	
	local command, msg = Sky_ChatEdit_ReadEdit(this);
	
	-- If there is not a /command behave normally
	if ( not command ) then
		return true;
	end

	local continue = true;
	-- Check all of the registered Sky Slash Commands
	local slashCommand = Sky.isSkySlashCommand(command);
	-- We find a match?
	if ( slashCommand ) then 
		if ( slashCommand.onTab ) then 
			if ( not slashCommand.onTab(msg, command) ) then
				continue = false;
			end
		end
	end


	-- If we didn't return anything yet, return true;
	return continue;
end

function Sky_ChatEdit_OnSpacePressed_Override()
	if ( not Sky.online ) then
		return true;
	end

	ChatEdit_ParseText(this, 0);
end

function Sky_ChatEdit_OnEnterPressed_Override()
	if ( not Sky.online ) then
		return true;
	end

	-- Read it
	local command, msg = Sky_ChatEdit_ReadEdit(this);

	-- Send it
	ChatEdit_SendText(this, 1);	

	-- If its sticky, save the hidden command...
	local ctype = this.chatType;
	if ( ctype == "CUSTOM" ) then
		-- Tuatara (March 9, 2005): If it is a CUSTOM command then check if the commandInfo.sticky is true
		-- AnduinLothar (April 7, 2005): added check for active, non-sky channels
		local channel = string.gsub(command, "/(.*)", "%1");
		if ( tonumber(channel) ) then
			channel = tonumber(channel);
		end
		Sea.io.dprint(SKY_DEBUG_CM, "Channel is: ", channel);
		-- Not sure if isSkyChannel is in standard build of Sky. I built it into SkyLight
		if ( Sky.isChannelActive(channel) ) and ( not SkyChannelManager.isSkyChannel(channel) ) then
			Sea.io.dprint(SKY_DEBUG_CM, "Is active, non-sky channel: ", channel, command);
			commandInfo = Sky.isSkySlashCommand(command);
			if( command and commandInfo ) then
				if (commandInfo.sticky == true) or (ChatTypeInfo["CHANNEL"].sticky == 1) then
					Sea.io.dprint(SKY_DEBUG_CM, "Saving hidden command as: "..command);
					this.savedHiddenCommand = command;
					this.stickyType = "CUSTOM";
				end
			end
		end
	elseif ( ChatTypeInfo[ctype].sticky == 1 ) then
	    -- If it is not a custom command then check the WoW sticky tag for the chat type
		this.stickyType = ctype;
		--this.hiddenCommand = nil;
		this.savedHiddenCommand = nil;
	end
	ChatEdit_OnEscapePressed(this);
end

function Sky_ChatEdit_OnEscapePressed_Override(editBox)
	editBox.chatType = editBox.stickyType;
	if ( editBox.chatType == "CUSTOM" ) then 
		editBox.hiddenCommand = editBox.savedHiddenCommand;
	end;
	editBox:SetText("");
	editBox:Hide();
end


function Sky_ChatEdit_SendText_Override(editBox, addHistory)
	if ( not Sky.online ) then
		return true;
	end

	local command, msg = Sky_ChatEdit_ReadEdit(editBox);

	local continue = true;
	local matched = false;
	-- If there is not a /command
	if ( command ) then	
		-- Check all of the registered Sky Slash Commands
		local slashCommand = Sky.isSkySlashCommand(command);		
		if ( slashCommand ) then 
			if ( slashCommand.onExecute ) then 
				if ( not slashCommand.onExecute(msg, command) ) then
					 continue = false;
				end
				matched = true;
			end
		end
	end

	if ( not continue or matched ) then
		-- Store the line as history
		editBox:AddHistoryLine(command.." "..msg);
	end

	return continue;
end

--
-- Hides the Sky Channels in the channel filter menu
--
function Sky_FCFDropDown_LoadChannels_Override(...)
	local checked;
	local channelList = FCF_GetCurrentChatFrame().channelList;
	local zoneChannelList = FCF_GetCurrentChatFrame().zoneChannelList;
	local info;
	local channelIndex = 1;
	local channelName;
	for i=1, arg.n, 2 do
		channelName = arg[i+1];
		if (not channelName) then
			break;
		end
		if  not ( SkyChannelManager.isSkyChannel(channelName) ) then

			checked = nil;
			if ( channelList ) then
				for index, value in channelList do
					if ( value == arg[i+1] ) then
						checked = 1;
					end
				end
			end
			if ( zoneChannelList ) then
				for index, value in zoneChannelList do
					if ( value == arg[i+1] ) then
						checked = 1;
					end
				end
			end
			info = {};
			info.text = channelName;
			info.value = "CHANNEL"..channelIndex;
			info.func = FCFChannelDropDown_OnClick;
			info.checked = checked;
			info.keepShownOnClick = 1;
			-- Color the chat channel
			local color = ChatTypeInfo["CHANNEL"..channelIndex];
			info.hasColorSwatch = 1;
			info.r = color.r;
			info.g = color.g;
			info.b = color.b;
			-- Set the function the color picker calls
			info.swatchFunc = FCF_SetChatTypeColor;
			info.cancelFunc = FCF_CancelFontColorSettings;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			channelIndex = channelIndex + 1;
		end
	end
end


--
-- Obtains a command, message pair from an EditBox's text
-- 
function Sky_ChatEdit_ReadEdit(editBox)
	if ( not editBox) then
		editBox = this;
	end

	local text = editBox:GetText();
	if ( strlen(text) <= 0 ) then
		return Sky_ChatEdit_CheckForHiddenCommand(editBox), text;
	end

	if ( strsub(text, 1, 1) ~= "/" ) then
		return Sky_ChatEdit_CheckForHiddenCommand(editBox), text;
	end

	-- If the string is in the format "/cmd blah", command will be "cmd"
	local _, _, command, msg = string.find(text, "(/[^%s]+)%s*(.*)");

	if ( msg == text ) then 
		msg = "";
	end

	return command, msg;
end

function Sky_ChatEdit_CheckForHiddenCommand(editBox)
	if ( editBox.hiddenCommand ) then 
		return editBox.hiddenCommand;
	else
		return nil;
	end
end

--
-- Updates a ChatEdit header based on SkyChannel number
--
function Sky_ChatEdit_UpdateHeader_Override(editBox, skyChannelNum)
	if ( not Sky.online ) then
		return true;
	end
	
	--Sea.io.printComma("Sky_ChatEdit_UpdateHeader_Override",editBox.channelTarget,skyChannelNum,editBox.chatType);
	
	local header = getglobal(editBox:GetName().."Header");
	if ( not header ) then
		return;
	end
	
	-- Tuatara (March 9, 2005): If we are coming in here without providing a skyChannelNum
	--		then update the header to correspond to the stickied command instead of the
	--		previous header text. This has been tested but not thoroughly.
	if (header:GetText() ~= nil and editBox.chatType == "CUSTOM" and skyChannelNum == nil ) then
		header:SetText("");
		if ( editBox.hiddenCommand ) then 
			editBox:SetText(editBox.hiddenCommand);
		end
		editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0);
	end
	
	local currChannelList = SkyChannelManager.getCurrentChannelTable();
	
	if ( currChannelList[skyChannelNum] ) then --fast isChannelActive
		local ctype = "CHANNEL";
		local info = ChatTypeInfo[ctype];
		local currChannelList = SkyChannelManager.getCurrentChannelTable();
		--local channelName = SkyChannelManager.convertToRealChannelName(skyChannelNum);
		local channelName = currChannelList[skyChannelNum];
		local number = skyChannelNum; -- save, maybe modify index later? GetChannelName(channelName);
		--Sea.io.printComma(number, channelName);

		local command, msg = Sky_ChatEdit_ReadEdit(editBox);
		
		if ( command and Sky.isSkySlashCommand(command) ) then
			editBox.hiddenCommand = command;
			editBox.chatType = "CUSTOM";
		end
		
		-- Ignore Hidden Sky Channels
		if ( SkyChannelManager.isSkyChannel(channelName) ) then
			Sea.io.dprint(SKY_DEBUG_CM, "Bad Boy! You can't parse chat on hidden sky channel ", channelName);
			return;
		end
		
		--editBox.channelTarget = nil;
		editBox:SetText(msg);		

		-- Try to color it pretty
		if ( number and ChatTypeInfo["CHANNEL"..number] ) then 
			info = ChatTypeInfo["CHANNEL"..number];

			-- Set the color and insets
			header:SetTextColor(info.r, info.g, info.b);
			editBox:SetTextColor(info.r, info.g, info.b);
		end
		
		header:SetText(format(TEXT(getglobal("CHAT_CHANNEL_SEND")), number, channelName));

		editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0);
	end
	
	if ( editBox.chatType ~= "CUSTOM" ) then 
		editBox.hiddenCommand = nil;
		return true;			
	end	
end


--[[
	Dataobject Definitions:

	
	datagram:
	{
		id = envelope.id;
		method = envelope.method;
		target = envelope.target;
		sender = username;
		system = envelope.system;
		expiration = GetTime() + SKY_TIME_TO_LIVE;
		ttl = SKY_TIME_TO_LIVE;
		sequenceNumber = sent;
		sequenceCount = datagramCount;
		length = envelope.size;
	}

-------------------------------------------------------------------------------

	chatWatchObject:
		{
			id = MailboxIdentifier, 
			events = { "EVENT1", "EVENT2" }, 
			acceptTest = functionHere, 
			blockTest = functionHere2,
			lifespan = 120,		-- Seconds 
			mailboxLimit = 10,	-- messages
			weight = 10
		};
	Params:

			id - the unique mailboxID which will be used to store acceptedTests
			events - a list of events which will be checked. 
				** Add SKY_CHANNEL, SKY_RAID, SKY_GUILD, SKY_PARTY, SKY_PLAYER to access those special types **

			acceptTest - a function which will be passed a SkyEnvelope for the event
				If it returns true, the message will be place in mailbox matching id. 

			Optional:
			blockTest - a function which will be passed a SkyEnveloper for the event
				If it returns true, the chat message will be hidden. 
			lifespan - the number of seconds a message may remain in the inbox before being removed
			mailboxLimit - the maximum number of messages the mailbox can contain. 
			weight - heavier objects go last

-------------------------------------------------------------------------------
		slashCommand:
		 	{
		 		id = Identifier;
		 		commands = { "/command1", "/command2" };
		 		onExecute = SomeFunction;
		 		onSpace = SomeFunction;
		 		action = "before" or "after" or "hide";
		 		helpText = "This does something cool.";
		 		sticky = false;
		 	}
		 		
		Allows you to register one or more /commands

		Arg Members:
			ID - some unique ID (mostly for unregistering later)
			slashCommands - a table of /commands to check for
			onExecute - a function which is called when the user runs the command
		
		   Optional:
			onSpace - a function called when a spacebar is pressed		
			onTab - a function call when a tab key is pressed
			action - useful only if it replaces a default function
				(before|after|hide) 
			helpText - a string explaining what the command does
			sticky - boolean value determining if the command should be sticky
		

-------------------------------------------------------------------------------		

		SkyEnvelope:
				{
				event = event,
				arg1 = message, 
				arg2 = player, 
				arg3 = language, 
				arg4 = channelTag, 
				arg5 = ???, 
				arg6 = ???, 
				arg7 = ???, 
				arg8 = channelNumber,
				arg9 = channelName,
				blocked = true|false,
				time = timeMessageWasProcessed
				}

			The reason the args are specified by arg# rather than by name is that
			they may change based on the event. CHAT_MSG wil use message/player, etc
			However, UNIT_HEALTH_UPDATE might use targetname/hp/maxhp. 	

			Furthermore, SkyEnvelopes passed through the SkyComm system will
			only have event, arg1 (message) and arg2 (player).

]]--
