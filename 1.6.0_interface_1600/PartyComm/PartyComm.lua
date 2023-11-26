-- If you're not familiar with the concept of function hooking and chaining, please
-- read the following document:
--
-- http://www.wowwiki.com/HOWTO:_Hook_a_Function
--
---------------------------------------------------------------------------------------
-- PartyComm is an AddOn designed to facilitate behind the scenes party communication
--
--   The functionality is nearly identical to the UltimateUI ZParty channel, but PartyComm
-- is designed to work as a standalone AddOn, usable by anyone.  PartyComm will attempt
-- to join the PartyComm channel for the current party leader.  For example, if a
-- player named "Bobafett" invited you to join his party and you accepted, PartyComm 
-- would automatically join the channel "PartyCommBobafett".  Any other members of that 
-- party that were using the PartyComm AddOn would also be in the channel.  Leaving a 
-- party will automatically reset your PartyComm channel to "PartyComm<YourName>".
--
--   You can use the PartyComm channel to transmit data between party members without
-- having it displayed to the chat windows.  The AddOn automatically filters out any
-- messages related to a "PartyComm*" channel and prevents them from being displayed.
--
--   It is recommended that you design a series of identifiers for your AddOn, so that 
-- you can indentify and parse only the messages you want.  For example, the PartyPets
-- AddOn prepends <PPClient> or <PPServer> to any message it sends to the PartyComm
-- channel.  It ignores any message which does not contain one of these identifiers.
--
-- This addon uses a rewritten version of UltimateUI_Schedule
-- Thanks to Thott for UltimateUI_Schedule
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
-- Include the following code in your AddOn to handle chat messages and all parameters
--
-- Rename "YourAddOn" to the name of your AddOn or something else of your choice.
---------------------------------------------------------------------------------------

--[[

local Pre_PartyComm_OnPCChatEvent;

function YourAddOn_OnLoad()
	Pre_PartyComm_OnPCChatEvent = PartyComm_OnPCChatEvent;
	PartyComm_OnPCChatEvent = YourAddOn_OnPCChatEvent;
end

function YourAddOn_OnPCChatEvent(event, message, player, language, channel, arg5, arg6, arg7, channelNumber, channelNameWithoutNumber, loops, frame)
	-- your handling here

	Pre_PartyComm_OnPCChatEvent(event, message, player, language, channel, arg5, arg6, arg7, channelNumber, channelNameWithoutNumber, loops, frame);
end

]]--
---------------------------------------------------------------------------------------
-- The following are the more friendly versions of the of the various chat messages
-- Only relevant data for the type of function is passed.  If you're using these functions
-- you can skip using the code above.
--
-- Rename "YourAddOn" to the name of your AddOn or something else of your choice.
---------------------------------------------------------------------------------------
--[[
local Pre_PartyComm_OnPCSelfJoin;
local Pre_PartyComm_OnPCSelfLeave;
local Pre_PartyComm_OnPCOtherJoin;
local Pre_PartyComm_OnPCOtherLeave;
local Pre_PartyComm_OnPCChatMessage;

function YourAddOn_OnLoad()
	Pre_PartyComm_OnPCChatMessage = PartyComm_OnPCChatMessage;
	PartyComm_OnPCChatMessage = YourAddOn_OnPCChatMessage;

	Pre_PartyComm_OnPCSelfJoin = PartyComm_OnPCSelfJoin;
	PartyComm_OnPCSelfJoin = YourAddOn_OnPCSelfJoin;

	Pre_PartyComm_OnPCSelfLeave = PartyComm_OnPCSelfLeave;
	PartyComm_OnPCSelfLeave = YourAddOn_OnPCSelfLeave;

	Pre_PartyComm_OnPCOtherJoin = PartyComm_OnPCOtherJoin;
	PartyComm_OnPCOtherJoin = YourAddOn_OnPCOtherJoin;

	Pre_PartyComm_OnPCOtherLeave = PartyComm_OnPCOtherLeave;
	PartyComm_OnPCOtherLeave = YourAddOn_OnPCOtherLeave;
end

-- Send when a message is sent to a PartyComm channel
function YourAddOn_OnPCChatMessage(channelName, player, message)
	-- your handling here

	Pre_PartyComm_OnPCChatMessage(channelName, player, message);
end

-- Sent when you join a PartyComm channel
function YourAddOn_OnPCSelfJoin(channelName)
	-- your handling here

	Pre_PartyComm_OnPCSelfJoin(channelName);
end

-- Sent when you leave a PartyComm channel
function YourAddOn_OnPCSelfLeave(channelName)
	-- your handling here

	Pre_PartyComm_OnPCSelfLeave(channelName);
end

-- Send when someone else joins a PartyComm channel
function YourAddOn_OnPCOtherJoin(channelName, player)
	-- your handling here

	Pre_PartyComm_OnPCOtherJoin(channelName, player);
end

-- Send when someone else leaves a PartyComm channel
function YourAddOn_OnPCOtherLeave(channelName, player)
	-- your handling here

	Pre_PartyComm_OnPCOtherLeave(channelName, player);
end

]]--
---------------------------------------------------------------------------------------
-- The following are messages sent when PartyComm is enabled or disabled via slash
-- commands.  If your AddOn requires PartyComm to function is may require cleanup
-- if PartyComm is disabled.  This is the place to do that.
--
-- Rename "YourAddOn" to the name of your AddOn or something else of your choice.
---------------------------------------------------------------------------------------
--[[
local Pre_PartyComm_OnPCEnable;
local Pre_PartyComm_OnPCDisable;

function YourAddOn_OnLoad()
	Pre_PartyComm_OnPCEnable = PartyComm_OnPCEnable;
	PartyComm_OnPCEnable = YourAddOn_OnPCEnable;

	Pre_PartyComm_OnPCDisable = PartyComm_OnPCDisable;
	PartyComm_OnPCDisable = YourAddOn_OnPCDisable;
end

-- Send when PartyComm is enabled
function YourAddOn_OnPCEnable()
	-- your handling here

	Pre_PartyComm_OnPCEnable();
end

-- Send when PartyComm is disabled
function YourAddOn_OnPCDisable()
	-- your handling here

	Pre_PartyComm_OnPCDisable();
end
]]--

---------------------------------------------------------------------------------------
-- End of Documentation
---------------------------------------------------------------------------------------
PARTYCOMM_VERSION = "v1.1";

PartyComm_Config = {}
function PartyComm_ResetConfig()
	PartyComm_Config.Enabled = true;
	PartyComm_Config.ShowChatMessages = false;
	PartyComm_Config.Version = PARTYCOMM_VERSION;
end

PARTYCOMM_ENABLE 		= "enable";
PARTYCOMM_DISABLE 		= "disable";
PARTYCOMM_ON 			= "on";
PARTYCOMM_OFF 			= "off";

PARTYCOMM_CHANNELPREFIX	= "PartyComm";
 -- Why aren't these in GlobalStrings.lua??
PARTYCOMM_LEAVEGROUP = "You leave the group";
PARTYCOMM_REMOVEDFROMGROUP = "You have been removed from the group";
PARTYCOMM_GROUPDISBANDED = "Your group has been disbanded"

local doIt = 0;

-- Chat Frame Hook
local Pre_ChatFrame_OnEvent;

-- Load Handler
function PartyComm_OnLoad()
	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("CHAT_MSG_CHANNEL_JOIN");
	this:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE");
	this:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	PartyComm_ResetConfig();

	PartyComm_Config.ShowChatMessages = false;

	-- Hook chat message
	Pre_ChatFrame_OnEvent = ChatFrame_OnEvent;
	ChatFrame_OnEvent = PartyComm_ChatFrame_OnEvent;
	
	-- OnUpdate
	doIt = GetTime();

	-- Setup Slash Commands
	SLASH_PARTYCOMM1 = "/partycomm";
	SLASH_PARTYCOMM2 = "/pc";
	SlashCmdList["PARTYCOMM"] = function(msg)
		PartyComm_OnSlashCommand(msg);
	end
	
	-- Load Inform
	if (DEFAULT_CHAT_FRAME) then 
		DEFAULT_CHAT_FRAME:AddMessage("PartyComm Loaded");
	end	
end

-- Slash Command Handler
function PartyComm_OnSlashCommand(msg)
	if (not msg) then
		return;
	end

	local command = string.lower(msg);
	
	-- Enable/Disable
	if (command == PARTYCOMM_ENABLE or command == PARTYCOMM_ON) then
		PartyComm_Config.Enabled = true;
		PartyComm_OnPCEnable();
		PartyComm_RejoinPCChannel();
		PartyComm_AddInfoMessage("PartyComm: Enabled");
	elseif (command == PARTYCOMM_DISABLE or command == PARTYCOMM_OFF) then
		PartyComm_Config.Enabled = false;
		PartyComm_OnPCDisable();
		PartyComm_LeaveAllPCChannels();
		PartyComm_AddInfoMessage("PartyComm: Disabled");
	else
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		PartyComm_AddInfoMessage("PartyComm Status:");
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_GREEN.."Use "..COLOR_CLOSE..COLOR_WHITE.."/partycomm <command> "..COLOR_CLOSE..COLOR_GREEN.."or "..COLOR_CLOSE..COLOR_WHITE.."/pc <command> "..COLOR_CLOSE..COLOR_GREEN.."to perform the following commands:"..COLOR_CLOSE);
		PartyComm_AddHelpMessage(PARTYCOMM_ON.."|"..PARTYCOMM_OFF, "enables or disables PartyComm", nil, PartyComm_Config.Enabled);
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_GREEN.."For example: "..COLOR_CLOSE..COLOR_WHITE.."/partycomm on "..COLOR_CLOSE..COLOR_GREEN.."will enable PartyComm."..COLOR_CLOSE);
	end
end

-- Main Event Handler
function PartyComm_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (not PartyComm_Config.Version or PartyComm_Config.Version ~= PARTYCOMM_VERSION) then
			PartyComm_AddInfoMessage("PartyComm: Version changed, resetting all variables to default.");
			PartyComm_ResetConfig();
		end
		RegisterForSave("PartyComm_Config");
	end
	
	if (not PartyComm_Config.Enabled) then
		PartyComm_LeaveAllPCChannels();
		return;
	end

	if (event == "PARTY_LEADER_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
		local leaderName = PartyComm_GetPartyLeader();
		if (leaderName and leaderName ~= "Unknown Entity") then
			if (PartyComm_GetPCChannelName() == nil or leaderName ~= strsub(PartyComm_GetPCChannelName(), strlen(PARTYCOMM_CHANNELPREFIX)+1)) then
				GTimer_AddEvent(2.0, PartyComm_RejoinPCChannel);
			end
		else
			GTimer_AddEvent(2.0, PartyComm_RejoinPCChannel);
		end
	end
end

function PartyComm_RejoinPCChannel()
	PartyComm_LeaveAllPCChannels();
	GTimer_AddEvent(0.25, PartyComm_JoinPCChannel);
end

function PartyComm_OnUpdate(elapsed)
	-- 1 second update timer
	doIt = doIt + elapsed;
	if (doIt > 1.0) then
		--update code here

		doIt = 0;
	end
end

function PartyComm_ChatFrame_OnEvent(event)
	-- Hack since leaving a party doesn't send a PARTY_LEADER_CHANGED event
	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		if (type == "SYSTEM") then
			if (strfind(arg1, PARTYCOMM_LEAVEGROUP) or strfind(arg1,PARTYCOMM_REMOVEDFROMGROUP) or strfind(arg1,PARTYCOMM_GROUPDISBANDED)) then
				PartyComm_RejoinPCChannel();
			end
		end
	end
	-- End hack

	if (strsub(event, 1, 16) == "CHAT_MSG_CHANNEL" and (strsub(arg9, 1, strlen(PARTYCOMM_CHANNELPREFIX)) == PARTYCOMM_CHANNELPREFIX)) then
		-- filter here based on ID to remove redundant chat messages
		if (this:GetID() ~= 1 and (not PartyComm_Config.ShowChatMessages)) then
			return;
		end

		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		
		-- Generic handler, passes all data
		PartyComm_OnPCChatEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, loops, frame);
		
		-- The following are more user friendly handlers to hook.
		-- Self joined handler
		if (type == "CHANNEL_NOTICE" and arg1 == "YOU_JOINED") then
			PartyComm_OnPCSelfJoin(arg9);
		-- Self left handler
		elseif (type == "CHANNEL_NOTICE" and arg1 == "YOU_LEFT") then
			PartyComm_OnPCSelfLeave(arg9);
		-- Other joined handler
		elseif (type == "CHANNEL_JOIN") then
			PartyComm_OnPCOtherJoin(arg9, arg2);
		-- Other left handler
		elseif (type == "CHANNEL_LEAVE") then
			PartyComm_OnPCOtherLeave(arg9, arg2);
		-- Chat message handler
		elseif (type == "CHANNEL") then
			PartyComm_OnPCChatMessage(arg9, arg2, arg1);
		end
		if (not PartyComm_Config.ShowChatMessages) then
			return;
		end
	end
	Pre_ChatFrame_OnEvent(event);
end

-- Empty functions for AddOn's to hook
function PartyComm_OnPCChatEvent(event, message, player, language, channel, arg5, arg6, arg7, channelNumber, channelNameWithoutNumber, loops, frame)
end

function PartyComm_OnPCSelfJoin(channelName)
end

function PartyComm_OnPCSelfLeave(channelName)
end

function PartyComm_OnPCOtherJoin(channelName, player)
end

function PartyComm_OnPCOtherLeave(channelName, player)
end

function PartyComm_OnPCChatMessage(channelName, player, message)
end

function PartyComm_OnPCEnable()
end

function PartyComm_OnPCDisable()
end

-- Channel functionality
function PartyComm_JoinPCChannel()
	if (PartyComm_Config.ShowChatMessages) then
		JoinChannelByName((PARTYCOMM_CHANNELPREFIX..PartyComm_GetPartyLeader()), nil, DEFAULT_CHAT_FRAME:GetID());
	else
		JoinChannelByName((PARTYCOMM_CHANNELPREFIX..PartyComm_GetPartyLeader()), nil, nil);
	end
end

function PartyComm_LeaveAllPCChannels()
	for i=1, 10 do
		local channelNumber, channelName = GetChannelName(i);
		if (channelName and strsub(channelName, 1, strlen(PARTYCOMM_CHANNELPREFIX)) == PARTYCOMM_CHANNELPREFIX) then
			LeaveChannelByName(channelName);
		end
	end
end

function oldPartyComm_LeaveAllPCChannels()
	PCChannels = PartyComm_GetAllChannels(GetChannelList());
	for index, value in PCChannels do
		LeaveChannelByName(value);
	end
end

function PartyComm_GetPCChannelName()
	return (PartyComm_ParseChannels(false, GetChannelList()));
end

-- Return the channel number of the PartyComm channel
function PartyComm_GetPCChannelIndex()
	return (PartyComm_ParseChannels(true, GetChannelList()));
end

function PartyComm_ParseChannels(useIndex, ...)
	for i=1, arg.n do
		if (strsub(arg[i], 1, strlen(PARTYCOMM_CHANNELPREFIX)) == PARTYCOMM_CHANNELPREFIX) then
			if (useIndex) then
				return (arg[i-1]);
			else
				return (arg[i]);
			end
		end
	end
	return nil;
end

function PartyComm_GetAllChannels(...)
	local channels = {};
	for i=1, arg.n do
		if (strsub(arg[i], 1, strlen(PARTYCOMM_CHANNELPREFIX)) == PARTYCOMM_CHANNELPREFIX) then
			local j = 1;
			while (channels[j] ) do
				j = j + 1;
			end
			channels[j] = arg[i];
		end
	end
	return (channels);
end

function PartyComm_GetPartyLeader()
	local leaderIndex = GetPartyLeaderIndex();
	if (leaderIndex == 0 or not GetPartyMember(leaderIndex)) then
		return UnitName("player");
	else
		return UnitName("party"..leaderIndex);
	end
end

-- Adds a formatted informational message
function PartyComm_AddInfoMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(COLOR_YELLOW..message..COLOR_CLOSE);
end

-- Adds a formatted help message
function PartyComm_AddHelpMessage(command, detail, status, enabled)
	message = COLOR_WHITE..command..": "..COLOR_CLOSE..COLOR_GREEN..detail..COLOR_CLOSE;

	if (enabled == nil) then
		DEFAULT_CHAT_FRAME:AddMessage(message);
		return;
	end
	
	if (status == "" or status == nil) then
		if (enabled) then
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_WHITE.." (enabled)"..COLOR_CLOSE);
		else
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_GREY.." (disabled)"..COLOR_CLOSE);
		end
	else
		if (enabled) then
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_WHITE..status..COLOR_CLOSE);
		else
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_GREY..status..COLOR_CLOSE);
		end		
	end
end


----------------------------------------------
--
-- Generic Timer - Based on UltimateUI_Schedule
--
----------------------------------------------

GTimer = {};

function GTimer_AddEvent(delay, handler, ...)
	local newEvent = {};
	newEvent.time = (GetTime() + delay);
	newEvent.handler = handler
	newEvent.args = arg;
	
	local i = 1;
	while(GTimer.PendingEvents[i] and GTimer.PendingEvents[i].time < newEvent.time) do
		i = i + 1;
	end
	table.insert(GTimer.PendingEvents, i, newEvent);
end

function GTimer_AddEventByName(name, delay, handler, ...)
	local i;
	for i=1, GTimer.PendingEvents.n, 1 do
		if (GTimer.PendingEvents[i].name and GTimer.PendingEvents[i].name == name) then
			table.remove(GTimer.PendingEvents, i);
			break;
		end
	end
	local newEvent = {};
	newEvent.time = (GetTime() + delay);
	newEvent.handler = handler
	newEvent.name = name;
	newEvent.args = arg;

	local i = 1;
	while(GTimer.PendingEvents[i] and GTimer.PendingEvents[i].time < newEvent.time) do
		i = i + 1;
	end
	table.insert(GTimer.PendingEvents, i, newEvent);
end

function GTimer_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");

	GTimer = {};
	GTimer.Initialized = false;
	GTimer.PendingEvents = {};
	GTimer.PendingEvents.n = 0;
end

function GTimer_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		GTimer_Initialize();
	end
end

function GTimer_Initialize()
	GTimer.Initializing = true;
	if (UnitName("player") and UnitName("player") ~= "Unknown Being") then
		GTimer.Initialized = true;
	else
		GTimer_AddEvent(0.2, GTimer_Initialize);
	end
end

function GTimer_OnUpdate()
	while (GTimer.PendingEvents[1] and GTimer.PendingEvents[1].time <= GetTime()) do
		if (not GTimer.Initialized) then
			GTimer_Initialize();
			return;
		end
		
		local curEvent = table.remove(GTimer.PendingEvents, 1);
		if (curEvent.args) then
			curEvent.handler(unpack(curEvent.args));
		else
			curEvent.handler();
		end
	end
end
