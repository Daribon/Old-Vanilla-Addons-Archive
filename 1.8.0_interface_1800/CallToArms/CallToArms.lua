--[[	---------------------------------------------------------------
		Call To Arms
		---------------------------------------------------------------
		
		@Author: 		Sacha Beharry
		@DateCreated: 	26th May 2005
		@LastUpdate: 	13th July 2005
		@Release:		R6
		@Version: 		1.0.2.1600
		@Note:			Fifth revision
		]]

		CTA_RELEASEVERSION 	= "R6";
		CTA_RELEASENOTE 	= "R6 [1.0.2.1600]";
	
--[[	---------------------------------------------------------------
	
		Web: 			
	
		Filename: 		CallToArms.lua
	
		Project Name: 	Call To Arms
	
		Description:	Main Program
	
		Purpose:		
		]]




--[[	---------------------------------------------------------------
		Variables
		---------------------------------------------------------------
		]]

CTA_DEFAULT_RAID_CHANNEL				= "CTAChannel";
CTA_INVITE_MAGIC_WORD 					= "inviteme";
CTA_PLAYER								= "PLAYER";
CTA_MAX_RESULTS_ITEMS					= 9;
CTA_MAX_BLACKLIST_ITEMS					= 15;
CTA_ALLIANCE	    					= "Alliance";
CTA_HORDE								= "Horde";




CTA_SavedVariables = {
	
	runCount							= 0,

	GreyList 							= {},
	
	MinimapArcOffset					= 284,
	MinimapRadiusOffset					= 75,
	
	MinimapMsgArcOffset					= 296,
	MinimapMsgRadiusOffset				= 95
	
};

CTA_CommunicationChannel 				= "CTAChannel";
CTA_MyRaid 								= nil;
CTA_RaidList 							= {};
CTA_ResultsListOffset 					= 0;
CTA_BlackList 							= {};
CTA_PlayerListOffset 					= 0;
CTA_MyRaidIsOnline 						= nil;

CTA_IgnoreBlacklisted					= 1;



local CTA_RAID_TYPE_PVP 				= 1;
local CTA_RAID_TYPE_PVE 				= 0;
local CTA_GREYLISTED					= 0;
local CTA_BLACKLISTED					= 1;
local CTA_WHITELISTED					= 2;
local CTA_MESSAGE						= "M";
local CTA_GENERAL						= "I";
local CTA_GROUP_UPDATE					= "G";
local CTA_BLOCK							= "X";
local CTA_SEARCH						= "S";

local CTA_MESSAGE_COLOURS = {
	M = { r = 1,   b = 1,   g = 0.5 },
	I = { r = 1,   b = 0.5, g = 1   },
	G = { r = 0.5, b = 0.5, g = 1   },
	X = { r = 1,   b = 0.5, g = 0.5 },
	S = { r = 0.5, b = 1,   g = 0.5 }
};

local CTA_MyRaidPassword 				= nil;
local CTA_UpdateTicker 					= 0.0;
local CTA_SearchTimer 					= 0;
local CTA_SelectedResultListItem 		= 0;
local CTA_ChannelSpam 					= {};
local CTA_SpamTimer 					= 0;
local CTA_PendingMembers				= {};
local CTA_GraceTimer					= 0;
local CTA_HostingRaidGroup				= nil;
	  CTA_InvitationRequests			= {};
local CTA_OutstandingRequests			= 0;
local CTA_RequestTimer					= 0;




CTA_PollBroadcast 						= nil;
CTA_PollApplyFilters 					= nil;
CTA_TimeSinceLastBroadcast				= 0;
CTA_TimeSinceLastFilter					= 0
CTA_RawGroupList						= {};
CTA_JoinedChannel						= nil;
CTA_AcidSummary							= nil;
CTA_AnnounceTimer						= 0;

CTA_WhoName								= nil;


--[[	---------------------------------------------------------------
		OnLoad and Slash Commands
		---------------------------------------------------------------
		]]




--[[	CTA_OnLoad()
		---------------------------------------------------------------
		Register events and hook functions.
		]]

function CTA_OnLoad()

	--Register Slash Command
	SlashCmdList["CallToArmsCOMMAND"] = CTA_SlashHandler;
	SLASH_CallToArmsCOMMAND1 = "/cta";
	
	--Register Event Listeners
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("RAID_ROSTER_UPDATE");
	this:RegisterEvent("WHO_LIST_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	 
	--Announce AddOn to user
	-- EDIT: no no, don't announce to user, no one wants to see that spam
	-- CTA_Println( CTA_CALL_TO_ARMS_LOADED );
	-- CTA_Error("-[ CTA "..CTA_RELEASEVERSION.." ]-");

	--Hook into ChatFrame to hide AddOn communication
	local old_ChatFrame_OnEvent = ChatFrame_OnEvent;
	function ChatFrame_OnEvent(event)

		-- R5 : effectively makes blacklist an extended ignore list as well
		if(  CTA_IgnoreBlacklisted and CTA_FindInList( arg2, CTA_BlackList ) ) then
			CTA_IconMsg( arg2, CTA_BLOCK ); -- left for testing
			return;
		end

		if( strsub(event, 1, 16) == "CHAT_MSG_WHISPER" ) then
			if( arg2 and arg1 and strsub(arg1, 1, 5) == "[CTA]" ) then
				CTA_IconMsg( arg2, CTA_MESSAGE );
				CTA_LogMsg( arg2..": "..arg1, CTA_MESSAGE );
				return; --R3
		  	end
		end

		if ( not arg1 or strsub(event, 1, 16) ~= "CHAT_MSG_WHISPER" or strsub(arg1, 1, 5) ~= "/cta " ) then -- not arg1: R3 bug fix
			if( not arg1 or not CTA_MainFrame:IsVisible() or not string.find( arg1, "Away from Keyboard") ) then -- not arg1: R3 bug fix
				old_ChatFrame_OnEvent(event);
			end
		end
	end
	
	--Hook into WhoList
	local old_WhoList_Update = WhoList_Update;
	function WhoList_Update()
		if( CTA_OutstandingRequests == 0 ) then
			old_WhoList_Update();
		end
	end
		
end




--[[	CTA_SlashHandler(com)
		---------------------------------------------------------------
		For Slash Commands (surprise)
		@arg The command String
		]]

function CTA_SlashHandler(com)
	if( not com or  com=="" ) then
		CTA_Println( CTA_CALL_TO_ARMS.." "..CTA_RELEASEVERSION );
		CTA_Println( CTA_COMMANDS..": "..CTA_HELP.." | "..CTA_TOGGLE.." | "..CTA_ANNOUNCE_GROUP.." |  "..CTA_DISSOLVE_RAID );
		return;
	end

	if( com==CTA_HELP ) then
		CTA_Println( CTA_TOGGLE..": "..CTA_TOGGLE_HELP );
		CTA_Println( CTA_ANNOUNCE_GROUP..": "..CTA_ANNOUNCE_GROUP_HELP );
		CTA_Println( CTA_DISSOLVE_RAID..": "..CTA_DISSOLVE_RAID_HELP );
		return;
	end

	if( com==CTA_TOGGLE ) then
		if( CTA_MainFrame:IsVisible() ) then
			CTA_MainFrame:Hide();
		else
			CTA_MainFrame:Show();
		end
		return;
	end
	
	if( com==CTA_DISSOLVE_RAID ) then
		if( IsRaidLeader() ) then
			CTA_DissolveRaid();
		else
			CTA_Println( CTA_MUST_BE_LEADER_TO_DISSOLVE_RAID );
		end
		return;
	end	
	
	for channelName in string.gfind( com, CTA_ANNOUNCE_GROUP.." (%w+)" ) do 
		if( CTA_AnnounceTimer == 0 ) then	
			if( CTA_AcidSummary ) then
				CTA_SendChatMessage( CTA_AcidSummary, "CHANNEL", channelName );
				CTA_AnnounceTimer = 200;
			end
		else
			CTA_Println( CTA_WAIT_TO_ANNOUNCE.." ("..CTA_AnnounceTimer.."s)" );
		end
		return;
	end	
	
	--[[
	if( com=="test" ) then
		CTA_SavedVariables.GreyList = {};
		return;
	end	
	]]	
end




--[[	---------------------------------------------------------------
		OnUpdate and OnEvent
		---------------------------------------------------------------
		]]



--[[	CTA_OnUpdate()
		---------------------------------------------------------------
		Keep the <var>CTA_UpdateTicker</var> running.
		@arg The time elapsed since the last call to this function
		]]

function CTA_OnUpdate( arg1 )
	CTA_UpdateTicker = CTA_UpdateTicker + arg1;
	if( CTA_UpdateTicker >= 1 ) then
	
		if( CTA_AnnounceTimer > 0 ) then
			CTA_AnnounceTimer = CTA_AnnounceTimer - 1;
		end
	
		CTA_TimeSinceLastBroadcast = CTA_TimeSinceLastBroadcast + 1;
		if( CTA_TimeSinceLastBroadcast > 15 ) then
			CTA_TimeSinceLastBroadcast = 0;
			if( CTA_MyRaidIsOnline and CTA_MyRaid ) then
				CTA_PollBroadcast = 1;
			end
		end
		
		CTA_TimeSinceLastFilter = CTA_TimeSinceLastFilter + 1;
		if( CTA_TimeSinceLastFilter > 30 ) then
			CTA_TimeSinceLastFilter = 0;
			CTA_PollApplyFilters = 1;
		end

		CTA_SpamTimer = CTA_SpamTimer + CTA_UpdateTicker;
		if( CTA_SpamTimer > 10 ) then
			CTA_ChannelSpam = {};
			CTA_SpamTimer = 0;
			

			
			-- Ok, piggybacking 10s SpamTimer to implement 
			-- Polled Broadcasting and
			-- Auto Search Updates.
			
			if( CTA_PollApplyFilters ) then
				CTA_TimeSinceLastFilter = 0;
				CTA_ApplyFiltersToGroupList();
			end
			
			
			if( CTA_PollBroadcast ) then
				CTA_TimeSinceLastBroadcast = 0;
				if( CTA_PollBroadcast == 2 ) then
					CTA_SendChatMessage("/cta A<>", "CHANNEL", GetChannelName( CTA_CommunicationChannel ) );
					CTA_PollBroadcast = nil;
				elseif( CTA_MyRaidIsOnline and CTA_MyRaid ) then
					CTA_BroadcastRaidInfo();
				end
			end				
		end
		
		if( CTA_GraceTimer > 0  ) then
			CTA_GraceTimer = CTA_GraceTimer - CTA_UpdateTicker;
			CTA_IconMsg( floor(CTA_GraceTimer) );
			if( CTA_GraceTimer <= 0 ) then
				if ( not CTA_PlayerCanHostGroup() ) then
					CTA_MyRaid = nil;
				 	CTA_MyRaidIsOnline = nil;
				 	CTA_HostingRaidGroup = nil;
					CTA_SearchFrame:Show();
					CTA_MyRaidFrame:Hide();
					CTA_StartRaidFrame:Hide();		 	
				else		
					CTA_MyRaidInstantUpdate();
				end					
			end
		end
				
		CTA_RequestTimer = CTA_RequestTimer + CTA_UpdateTicker;
		if( CTA_RequestTimer > 5 ) then
			if( CTA_OutstandingRequests > 0 ) then
				CTA_LogMsg( CTA_OutstandingRequests.." invitation request(s) outstanding" );	
				for name, data in CTA_InvitationRequests do
					if( data.status == 1 ) then
						SetWhoToUI(1);
						CTA_WhoName = name;
						SendWho(name);
						CTA_LogMsg( "Validating request from "..name );	
						break;
					end
				end
			end
			CTA_RequestTimer = 0;
		end
				
		CTA_UpdateTicker = 0;
	end
end




--[[	CTA_OnEvent()
		---------------------------------------------------------------
		Event handler.
		@arg The event to be handled
		]]

function CTA_OnEvent( event )

	if(event == "VARIABLES_LOADED") then
		CTA_MinimapArcSlider:SetValue( CTA_SavedVariables.MinimapArcOffset );
		CTA_MinimapRadiusSlider:SetValue( CTA_SavedVariables.MinimapRadiusOffset );
		CTA_MinimapMsgArcSlider:SetValue( CTA_SavedVariables.MinimapMsgArcOffset );
		CTA_MinimapMsgRadiusSlider:SetValue( CTA_SavedVariables.MinimapMsgRadiusOffset );
		CTA_UpdateMinimapIcon();	
		CTA_AddGreyToBlack();
		CTA_ImportIgnoreListToGreyList();	
		if( not CTA_SavedVariables.runCount or CTA_SavedVariables.runCount == 0 ) then
			CTA_SavedVariables.runCount = 0;
			CTA_MainFrame:Show();
			CTA_SearchFrame:Hide();
			CTA_MyRaidFrame:Hide();
			CTA_StartRaidFrame:Hide();
			CTA_SettingsFrame:Show();
			CTA_GreyListFrame:Hide();
			CTA_LogFrame:Hide();
		end
		CTA_SavedVariables.runCount = CTA_SavedVariables.runCount + 1;
	end

	-- for R2 to see if we can tell when a player does not accept your invitation to join the group
	if ( event == "CHAT_MSG_SYSTEM" ) then	
		if ( string.find( arg1, "declines your group invitation" ) or string.find( arg1, "is already in a group" ) ) then
			local name = string.gsub( arg1, "%s*([^%s]+).*", "%1" );
			CTA_RemoveRequest( name );
			CTA_LogMsg( name.." has declined the invitation - request removed" );	
			CTA_MyRaidInstantUpdate();
		end
	end	

	-- Listen for Invitation requests
  	if ( event == "CHAT_MSG_WHISPER" ) then
		if( CTA_MyRaidIsOnline and string.lower( strsub(arg1, 1, 8) ) == CTA_INVITE_MAGIC_WORD ) then
		
  			if( not CTA_FindInList( arg2, CTA_BlackList ) ) then -- R2
	  			if( CTA_ChannelSpam[arg2] == nil ) then
	  				CTA_ChannelSpam[arg2] = 0;
	  			end
	  			CTA_ChannelSpam[arg2] = CTA_ChannelSpam[arg2] + 1;
	  			if( CTA_ChannelSpam[arg2] > 4 ) then
	  				CTA_RemoveRequest( arg2 );
	  				CTA_SendAutoMsg(arg2.." "..CTA_WAS_BLACKLISTED, arg2);	
	  				CTA_IconMsg( arg2.." "..CTA_WAS_BLACKLISTED, CTA_BLOCK );
	  				CTA_AddPlayer( arg2, CTA_BLACKLISTED_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_BlackList )
				else
					CTA_ReceiveRaidInvitationRequest( arg1, arg2 );	
	  			end
  			end	
  					
		end	
	end
	
	-- Listen for Group information
  	if ( event == "CHAT_MSG_CHANNEL" ) then
		if( arg9 == CTA_CommunicationChannel and strsub(arg1, 1, 6) == "/cta A" ) then
			CTA_ReceiveRaidInfo( arg1, arg2 );
		elseif( CTA_MonitorChatCheckButton:GetChecked() ) then
  			local channel = arg8;
  			if( not channel ) then channel = "?"; end
  			local sco, hm = CTA_SearchScore(  arg1, "lfm lfg raid party quest instance group" );
	  		if( sco > 0 ) then
	  			sco, hm = CTA_SearchScore(  arg1, "lfm lfg raid party quest instance group", 1 );
	  			local msg = "[LFx "..sco.."% Ch"..channel.."]".."|cffccffff|Hplayer:"..arg2.."|h".."["..arg2.."]".."|h|r"..": "..hm;
		  		if( CTA_MyRaid and CTA_SearchScore(  arg1, CTA_MyRaid.comment ) > 40  ) then
		  			CTA_LogMsg( msg, CTA_GROUP_UPDATE );
		  		else  		
	  				CTA_LogMsg( msg, CTA_SEARCH );
	  			end
	  		end
  		end	
  		
		-- Use channel event to delay joining of CTAChannel
		if( not CTA_JoinedChannel ) then
		
			CTA_LogMsg( CTA_CALL_TO_ARMS_LOADED );
			--CTA_Println( "ch" );
			CTA_JoinChannel();
			CTA_JoinedChannel = 1;
		end  			
	end
			
	-- Listen for Who information
	if ( event == "WHO_LIST_UPDATE" and CTA_MyRaid ) then
		if( CTA_WhoName ) then
			local name, level, class, group = CTA_GetWhoInfo();
			--CTA_Println( "group: "..group );
			if( name ) then
				if( CTA_FindInList( name, CTA_BlackList ) ) then
					CTA_LogMsg( name.." has been blacklisted - Request denied and removed" );
					CTA_RemoveRequest(name);
				end
				
				if( group == "yes" ) then
					CTA_LogMsg( name.." is already in a group - Request denied and removed" );
					CTA_RemoveRequest(name);
				end
			
				if( CTA_InvitationRequests[name] and CTA_InvitationRequests[name].status == 1 and CTA_MyRaid ) then	
					CTA_OutstandingRequests = CTA_OutstandingRequests - 1;
					if( level >= CTA_MyRaid.minLevel and string.find( CTA_GetClassString(CTA_MyRaid.classes),class) ) then
						InviteByName( name );
						CTA_LogMsg( name.."\'s request processed: Valid player - Invitation sent" );	
						
						CTA_InvitationRequests[name].status = 2;
						CTA_InvitationRequests[name].class = class;
						CTA_InvitationRequests[name].level = level;
									
						CTA_IconMsg( CTA_INVITATION_SENT_TO.." "..name, CTA_GROUP_UPDATE );
						CTA_SendAutoMsg( CTA_INVITATION_SENT_MESSAGE, name );
						CTA_MyRaidInstantUpdate();
					else
						CTA_InvitationRequests[name] = nil;
						CTA_LogMsg( name.."\'s request processed: Invalid player - request removed" );	
						
						CTA_SendAutoMsg( CTA_WRONG_LEVEL_OR_CLASS, name );	
					end
				end
			else
				CTA_LogMsg( "Player "..CTA_WhoName.." could not be found. Removing from requests list." );	
				CTA_RemoveRequest(CTA_WhoName);
			end
			CTA_WhoName = nil;
		end
		SetWhoToUI(0);
	end  
			
	-- Group update
	if ( ( event == "RAID_ROSTER_UPDATE" or event == "PARTY_LEADER_CHANGED" or event == "PARTY_MEMBERS_CHANGED" ) and CTA_MyRaid ) then
		CTA_GraceTimer = 2;
	end
  		
end

function CTA_GetWhoInfo()
	local numWhos, totalCount = GetNumWhoResults();
	local name, guild, level, race, class, zone, group;
	for i=1, totalCount do
		name, guild, level, race, class, zone, group = GetWhoInfo(i);
		if( not name or name == CTA_WhoName ) then
			break;
		end
	end
	return name, level, class, group;
end


--[[	---------------------------------------------------------------
		Communication - System
		---------------------------------------------------------------
		]]




--[[	CTA_JoinChannel()
		---------------------------------------------------------------
		Attempts to join the <var>CTA_CommunicationChannel</var> 
		channel.
		]]

function CTA_JoinChannel()
	if( not CTA_CommunicationChannel or CTA_CommunicationChannel == "" ) then
		CTA_CommunicationChannel = CTA_DEFAULT_RAID_CHANNEL;
	end
	
	--if ( not CTA_ConnectedToChannel( CTA_CommunicationChannel ) ) then
		JoinChannelByName( CTA_CommunicationChannel );
		CTA_LogMsg( "Joined "..CTA_CommunicationChannel );
	--end
end




--[[	CTA_ConnectedToChannel() 
		---------------------------------------------------------------
		Determines whether the client has joined the specified channel.
		@arg The name of the channel
		@return nil, 1 if already connected to the channel
		]]

function CTA_ConnectedToChannel( channel ) 
	local DefaultChannels = { GetChatWindowChannels(DEFAULT_CHAT_FRAME:GetID()) };
	local connected = nil;
	if( DefaultChannels ) then 
		for item = 1, getn(DefaultChannels) do
			CTA_LogMsg( DefaultChannels[item] );
			if( DefaultChannels[item] == channel ) then
				connected = 1;
				break;
			end
		end
	end
	return connected;
end




--[[	CTA_SendAutoMsg()
		---------------------------------------------------------------
		Sends a chat message, by whisper, to the specified player.
		@arg The message to be sent
		@arg The recipient of the message
		]]

function CTA_SendAutoMsg( message, player )
	CTA_SendChatMessage( "[CTA] "..message, "WHISPER", player );
end




--[[	CTA_SendChatMessage()
		---------------------------------------------------------------
		Sends a chat message to the specified player or channel.
		@arg The message to be sent
		@arg The type of transmission eg. whisper, channel etc
		@arg The recipient player/channel of the message 
		]]

function CTA_SendChatMessage( message, messageType, channel ) 
	local language = CTA_COMMON;
	if( UnitFactionGroup(CTA_PLAYER) ~= CTA_ALLIANCE ) then
		language = CTA_ORCISH;
	end
	SendChatMessage( message, messageType, language, channel );
end




--[[	---------------------------------------------------------------
		Invitations
		---------------------------------------------------------------
		]]




--[[	CTA_SendPasswordRaidInvitationRequest()
		---------------------------------------------------------------
		Sends a request with a pasword for an invitation
		]]

function CTA_SendPasswordRaidInvitationRequest()
	local raid = CTA_RaidList[ CTA_SelectedResultListItem ];
	local password = CTA_SafeSet( CTA_JoinRaidWindowEditBox:GetText(), "" );
	if( password ~= "" ) then
		CTA_SendChatMessage( CTA_INVITE_MAGIC_WORD.." "..password, "WHISPER", raid.leader );	
		CTA_JoinRaidWindow:Hide();
	end
end




--[[	CTA_SendRaidInvitationRequest()
		---------------------------------------------------------------
		Sends a request for an invitation
		]]

function CTA_SendRaidInvitationRequest()
	local raid = CTA_RaidList[ CTA_SelectedResultListItem ];
	CTA_JoinRaidWindow:Hide();
	CTA_RequestInviteButton:Disable();
	
	if( raid.passwordProtected == 1 ) then
		CTA_JoinRaidWindow:Show();
	else
		CTA_SendChatMessage( CTA_INVITE_MAGIC_WORD, "WHISPER", raid.leader );		
	end
end




--[[	CTA_ReceiveRaidInvitationRequest()
		---------------------------------------------------------------
		Handles incoming invitation requests.
		@arg The invitation request with optional password
		@arg The name pf the player requesting the invitation
		]]

function CTA_ReceiveRaidInvitationRequest( msg, author )
	if( CTA_InvitationRequests[author] ) then return; end -- cheap short-circuit hack
	CTA_LogMsg( "Received invitation request from "..author );	
	if( CTA_MyRaid.size + getn(CTA_InvitationRequests) < CTA_MyRaid.maxSize ) then
		if( CTA_MyRaid.passwordProtected==1 ) then
			local password = string.gsub( string.sub( msg, 9 ), "%s*([^%s]+).*", "%1" );
			
			if( password and password==CTA_MyRaidPassword ) then
				CTA_AddRequest( author );
			else
				CTA_SendAutoMsg( CTA_INCORRECT_PASSWORD_MESSAGE, author);			
			end
		else
			CTA_AddRequest( author );
		end
	else
		CTA_SendAutoMsg( CTA_NO_SPACE_MESSAGE, author);	
	end
end




--[[	CTA_AddRequest()
		---------------------------------------------------------------
		Adds a player's request for an invitation to join the group.
		@arg The name of the player requesting an invitaion
		]]

function CTA_AddRequest( name )
	CTA_InvitationRequests[name] = {};
	CTA_InvitationRequests[name].status = 1;
	CTA_OutstandingRequests = CTA_OutstandingRequests + 1;
end




--[[	CTA_RemoveRequest()
		---------------------------------------------------------------
		Removes a player's request for an invitation to join the group.
		@arg The name of the player requesting an invitaion
		]]

function CTA_RemoveRequest( name )
	if( CTA_InvitationRequests[name] ) then
		if( CTA_InvitationRequests[name].status == 1 ) then
			CTA_OutstandingRequests = CTA_OutstandingRequests - 1;	
		end
		CTA_InvitationRequests[name] = nil;
	end
end


--[[	---------------------------------------------------------------
		Inter-AddOn Group Information Communication
		
					   a   b  c d e  f g
				       1234567890123
				/cta A<1200255808060|~|~>
				       ^   ^  ^ ^ ^  ^ ^
				       4   3  2 2 2  ? ?
		       
		      	a - time of transmission (HHMM 24HR format)
		       	b - lfm classes code (0 = none, .. , 255 = any class)
		       	c - current group size and pv? type 
		       	d - maximum group size and password protection
		       	e - minimum level to join group
		       	f - group description
		       	g - options (reserved for future releases)
		       
		       	NB: 'Encode' & 'Decode' used loosely below  ;)
		       
		       	CTA group information messages are encoded and 
		       	transmitted by CTA_BroadcastRaidInfo() and are
		       	received and decoded by CTA_ReceiveRaidInfo().

		---------------------------------------------------------------
		]]




--[[	CTA_BroadcastRaidInfo()
		---------------------------------------------------------------
		Sends this group info to the CTA Channel.
		]]

function CTA_BroadcastRaidInfo()
	CTA_PollBroadcast = nil;	

	if( CTA_MyRaidIsOnline == nil ) then return; end -- short circuit hack for push changeover in R5

	local myName = UnitName( CTA_PLAYER );
	local myRaid = CTA_MyRaid;
	--local com = CTA_GetGroupType()..": [CTA R3 Pre-release Test Group] "..myRaid.comment;
	local com = myRaid.comment.." ("..CTA_GetGroupType()..")";
	local typ = myRaid.pvtype;
	local siz = myRaid.size;
	local max = myRaid.maxSize;
	local min = myRaid.minLevel;
	local cla = myRaid.classes;	
	local pro = myRaid.passwordProtected;
	local opt = myRaid.options;		
	--local tim = myRaid.creationTime; ListChannelByName
	
	local hour, minute = GetGameTime();
	local tim = hour;
	if( hour < 10 ) then tim = "0"..tim; end
	if( minute < 10 ) then tim = tim.."0"; end
	tim = tim..minute;	
	
	if( typ == CTA_RAID_TYPE_PVP ) then
		siz = siz + 40;
	end
	
	if( pro == 1 ) then
		max = max + 40;
	end
	
	while( string.len( cla ) < 3 ) do
		cla = "0"..cla;
	end

	while( string.len( siz ) < 2 ) do
		siz = "0"..siz;
	end
	while( string.len( max ) < 2 ) do
		max = "0"..max;
	end
	while( string.len( min ) < 2 ) do
		min = "0"..min;
	end
	
	local code = ""..tim..cla..siz..max..min;
	CTA_SendChatMessage("/cta A<"..code..":"..com..":"..opt..">", "CHANNEL", GetChannelName( CTA_CommunicationChannel ) );
	
	--CTA_IconMsg( "Broadcast Sent" );
end




--[[	CTA_ReceiveRaidInfo()
		---------------------------------------------------------------
		Decodes group information sent over the CTA Channel and adds/
		updates this information to the <var>CTA_RaidList</var>
		@arg The encoded group information message
		@arg The group leader who posted the information
		]]

function CTA_ReceiveRaidInfo( raidInfo, author )
	if( raidInfo == "/cta A<>" ) then
		CTA_RawGroupList[author] = nil;
		CTA_PollApplyFilters = 1;
		return;
	end

	for code, com, opt in string.gfind( raidInfo, "/cta A<(%d+):(.+):(.+)>" ) do 	
		local tim = string.sub( code,  1,  4 );
		local cla = tonumber( string.sub( code,  5,  7 ) );
		local siz = tonumber( string.sub( code,  8,  9 ) );
		local max = tonumber( string.sub( code, 10, 11 ) );
		local min = tonumber( string.sub( code, 12, 13 ) );
		local pro = 0;
		local typ = CTA_RAID_TYPE_PVE;
		
		if( siz > 40 ) then
			typ = CTA_RAID_TYPE_PVP;
			siz = siz - 40;
		end
		if( max > 40 ) then
			pro = 1;
			max = max - 40;
		end
		CTA_RawGroupList[author] = {};
		CTA_SetRaidInfo( CTA_RawGroupList[author], author, 0, com, typ, siz, max, min, cla, pro, tim, opt )
		CTA_PollApplyFilters = 1;
	end
end




--[[	---------------------------------------------------------------
		Functions Related To The Search Frame And The Group List
		--------------------------------------------------------------- 
		]]




--[[	CTA_ApplyFiltersToGroupList()
		---------------------------------------------------------------
		Applies filter settings to the group list and 
		updates the score for each one. This score will be used by the 
		<func>CTA_UpdateList()</func> function to refresh the results
		list with those groups with a score of at least 1.
		Called by CTA_SearchButton, will be renamed to ApplyFilters() 
		or something to that effect.
		]]
		
function CTA_ApplyFiltersToGroupList()
	local showClasses = CTA_SafeSet( CTA_SearchFrameShowClassCheckButton:GetChecked(), 0 );
	if( showClasses == 0 ) then 
		showClasses = CTA_MyClassCode();
	else
		showClasses = 0;
	end
	
	local showPVP = CTA_SafeSet( CTA_SearchFrameShowPVPCheckButton:GetChecked(), 0 );
	local showPVE = CTA_SafeSet( CTA_SearchFrameShowPVECheckButton:GetChecked(), 0 );
	local keywords = CTA_SafeSet( CTA_SearchFrameDescriptionEditBox:GetText(), "*" );
	local showEmpty = CTA_SafeSet( CTA_SearchFrameShowEmptyCheckButton:GetChecked(), 0 );
	local showFull = CTA_SafeSet( CTA_SearchFrameShowFullCheckButton:GetChecked(), 0 );
	local showProtected = CTA_SafeSet( CTA_SearchFrameShowPasswordCheckButton:GetChecked(), 0 );
	local showMinLevel = CTA_SafeSet( CTA_SearchFrameShowLevelCheckButton:GetChecked(), 0 );
	if( showMinLevel == 0 ) then 
		showMinLevel = UnitLevel(CTA_PLAYER);
	else
		showMinLevel = 60; 
	end
	
	CTA_RequestInviteButton:Disable();
	CTA_ResultsListOffset = 0;
	CTA_SelectedResultListItem = 0;	
	
	local oldListSize = 0;
	if( CTA_RaidList ) then
		oldListSize = getn( CTA_RaidList );
	end
	
	CTA_RaidList = nil;
	CTA_RaidList = {};
	
	--CTA_SearchButton:Disable();
	--CTA_SearchTimer = 5;
	
	local chr, cmn = GetGameTime();
	cmn = cmn + 1;
	local pruneCount = 0;

	for name, data in CTA_RawGroupList do
		local ok = 1;
	
		local rhr = tonumber( string.sub( data.creationTime,  1,  2 ) );
		local rmn = tonumber( string.sub( data.creationTime,  3,  4 ) );
		
		local dmn = cmn - rmn;
		if( dmn < 0 ) then
			dmn = dmn + 60;
		end
		
		if( dmn > 2 ) then
			CTA_RawGroupList[name] = nil;
			pruneCount = pruneCount + 1;
			--CTA_Println( "Pruned: "..cmn.." - "..rmn.." = "..dmn );
			ok = nil;
		end
		
		if( ok and showClasses > 0 and CTA_CheckClasses( data.classes, showClasses ) == 0 ) then ok = nil; end
		if( ok and showEmpty == 0 and data.size <= 1 ) then ok = nil; end
		if( ok and showFull == 0 and data.size == data.maxSize ) then ok = nil; end
		if( ok and showPVP == 0 and data.pvtype == CTA_RAID_TYPE_PVP ) then ok = nil; end
		if( ok and showPVE == 0 and data.pvtype == CTA_RAID_TYPE_PVE ) then ok = nil; end
		if( ok and showProtected == 0 and CTA_MyRaidPassword ) then ok = nil; end
		if( ok and showMinLevel < data.minLevel ) then ok = nil; end
		if( ok ) then
			data.score = 100;
			if( keywords and keywords~="*" ) then
				data.score = CTA_SearchScore( data.leader.." "..data.comment, keywords );
			end	
			if( data.score == 0 ) then ok = nil; end
		end
		if( ok ) then
			table.insert( CTA_RaidList, data );
			--CTA_Println( "Added" );
		else
			--CTA_Println( "Passed" );
		end
	end
	--[[
	if( oldListSize ~= getn( CTA_RaidList ) and getn( CTA_RaidList ) ~= 0 ) then
		--CTA_IconMsg( "List updated" ); 
		CTA_LogMsg( "List updated: "..CTA_getn(CTA_RawGroupList).." total, "..getn(CTA_RaidList).." matches, "..pruneCount.." were outdated and removed" );
	end
	]]	
	CTA_PollApplyFilters = nil;
	CTA_UpdateResults();
end




--[[	CTA_UpdateResults()								UPDATE FUNCTION
		---------------------------------------------------------------
		Updates the groups results list to show only those 
		groups with a score of at least 1. 
		Also updates the selected group as necessary.
		]]

function CTA_UpdateResults()
	local index = 1;
	local groupListLength = getn( CTA_RaidList );
	
	
	if( CTA_Header ) then
		CTA_HeaderNameLabel:SetText( CTA_HEADER_RAID_DESCRIPTION );
		CTA_HeaderTypeLabel:SetText( CTA_HEADER_TYPE );
		CTA_HeaderSizeLabel:SetText( CTA_HEADER_SIZE );
		CTA_HeaderMinLevelLabel:SetText( CTA_HEADER_MIN_LEVEL );
		CTA_HeaderPasswordLabel:Hide(); 
		
		if( groupListLength ~= 0 ) then
			CTA_MinimapIconTextLabel:SetText( groupListLength );
			CTA_MinimapIconTextLabel:Show();
		else
			CTA_MinimapIconTextLabel:Hide();
		end
		
		if( groupListLength ~= 1 ) then 
			CTA_ResultsLabel:SetText( CTA_RESULTS_FOUND.." "..groupListLength.."/"..CTA_getn( CTA_RawGroupList).." "..CTA_GROUPS );
		else
			CTA_ResultsLabel:SetText( CTA_RESULTS_FOUND.." "..groupListLength.." "..CTA_GROUP );
		end
	end
	

	CTA_PageLabel:Show();

	local cpage = floor( CTA_ResultsListOffset / CTA_MAX_RESULTS_ITEMS );
	local tpage = floor( groupListLength / CTA_MAX_RESULTS_ITEMS );
	if( cpage == 0 or cpage <= CTA_ResultsListOffset / CTA_MAX_RESULTS_ITEMS ) then cpage = cpage + 1; end
	if( tpage == 0 or tpage < groupListLength / CTA_MAX_RESULTS_ITEMS ) then tpage = tpage + 1; end
	CTA_PageLabel:SetText( CTA_PAGE.." "..cpage.." / "..tpage );

	
	while( index < CTA_MAX_RESULTS_ITEMS + 1 ) do
		local c = "CTA_NewItem"..index;
		if( getglobal( c ) ) then
			if( index+CTA_ResultsListOffset <= groupListLength ) then 
				local raid = CTA_RaidList[index+CTA_ResultsListOffset];

				local typeText = CTA_PVP;
				local passwordText = CTA_NO;
				if( raid.pvtype == CTA_RAID_TYPE_PVE ) then typeText = CTA_PVE; end
				if( raid.passwordProtected == 1 ) then passwordText = CTA_YES; end
				local name = raid.leader..": "..raid.comment;
				local tex = getglobal( c.."Texture");
				local texR = getglobal( c.."TextureRed");
				local texG = getglobal( c.."TextureGreen");
				local myClass = UnitClass( CTA_PLAYER );
				
				tex:Hide();
				texR:Hide();
				texG:Hide();
				if( raid.minLevel > UnitLevel(CTA_PLAYER) or not string.find(CTA_GetClassString(raid.classes),myClass)  ) then
					texR:Show();
				elseif( raid.passwordProtected == 1 ) then
					tex:Show();
				else
					texG:Show();
				end
				if( CTA_SelectedResultListItem == index+CTA_ResultsListOffset ) then
					getglobal( c.."TextureSelected"):Show();
					--tex:Hide();
					--texR:Hide();
					--texG:Hide();
				else
					getglobal( c.."TextureSelected"):Hide();
				end
				getglobal( c.."NameLabel"):SetText( name );
				getglobal( c.."TypeLabel"):SetText( typeText );
				getglobal( c.."SizeLabel"):SetText( raid.size.."/"..raid.maxSize );
				getglobal( c.."MinLevelLabel"):SetText( raid.minLevel );
				getglobal( c.."PasswordLabel"):SetText( passwordText );
				getglobal( c.."TimeLabel"):SetText( raid.creationTime );
				getglobal( c ):Show();	
			else	
				getglobal( c ):Hide();
			end
		end
		index = index + 1;
	end
end




--[[	CTA_ListItem_OnMouseUp()
		---------------------------------------------------------------
		Sets the caller item as the selected group and updates the
		<ui>CTA_RequestInviteButton</ui> button as necessary, then
		calls the <func>CTA_UpdateResults()</func> afterwards.
		]]

function CTA_ListItem_OnMouseUp()
	local value = string.gsub( this:GetName(), "CTA_NewItem(%d+)", "%1" ); 
	if( CTA_SelectedResultListItem == CTA_ResultsListOffset + value ) then
		CTA_SelectedResultListItem = 0;
		CTA_RequestInviteButton:Disable();
	else
		CTA_SelectedResultListItem = CTA_ResultsListOffset + value;
		
		local raid = CTA_RaidList[ CTA_ResultsListOffset + value ];
		
		local myClass = UnitClass( CTA_PLAYER );
		if( raid.minLevel > UnitLevel (CTA_PLAYER ) or not string.find( CTA_GetClassString( raid.classes ),myClass ) ) then
			CTA_RequestInviteButton:Disable();
		else
			CTA_RequestInviteButton:Enable();
		end
	end
	CTA_UpdateResults();
end




--[[	CTA_ListItem_ShowTooltip()
		---------------------------------------------------------------
		Set up and show the tooltip for the calling group list item.
		]]

function CTA_ListItem_ShowTooltip()
	GameTooltip:ClearLines();
	local value = CTA_ResultsListOffset + string.gsub( this:GetName(), "CTA_NewItem(%d+)", "%1" );
	
	local raid = CTA_RaidList[value];
	GameTooltip:SetOwner( this, "ANCHOR_BOTTOMLEFT" );
	GameTooltip:ClearAllPoints();
	GameTooltip:SetPoint("BOTTOMLEFT", this:GetName(), "TOPLEFT", 0, 8);
	
	if( raid == nil ) then return; end
	GameTooltip:AddLine( CTA_DESCRIPTION );

	GameTooltip:AddLine( raid.comment, 0.9, 0.9, 1.0, 1, 1 );
	if( raid.classes == 255 ) then
		GameTooltip:AddLine( CTA_LFM_ANY_CLASS, 0.1, 0.9, 0.1 );	
	else 
		local myClass = UnitClass( CTA_PLAYER );
		local classList = CTA_GetClassString(raid.classes);

		if( string.find(classList, myClass) ) then
			GameTooltip:AddLine( CTA_LFM_CLASSLIST..classList, 0.1, 0.9, 0.1 );	
		else
			if( not classList or classList == "" ) then
				GameTooltip:AddLine( CTA_NO_MORE_PLAYERS_NEEDED, 0.9, 0.1, 0.1 );	
			else
				GameTooltip:AddLine( CTA_LFM_CLASSLIST..classList, 0.9, 0.1, 0.1 );	
			end
		end
	end

	if( raid.minLevel <= UnitLevel(CTA_PLAYER) ) then
		GameTooltip:AddLine( CTA_MIN_LEVEL_TO_JOIN_RAID..": "..raid.minLevel, 0.1, 0.9, 0.1 );	
	else
		GameTooltip:AddLine( CTA_MIN_LEVEL_TO_JOIN_RAID..": "..raid.minLevel, 0.9, 0.1, 0.1 );	
	end	
	
	if( raid.passwordProtected == 1 ) then 
		GameTooltip:AddLine( CTA_RAID_REQUIRES_PASSWORD ); 
	end

	GameTooltip:AddDoubleLine( CTA_LAST_UPDATE..": ", ""..raid.creationTime, 0.9, 0.9, 0.1, 0.1, 0.9, 0.1 );
	GameTooltip:AddDoubleLine( CTA_SEARCH_MATCH..": ", ""..raid.score, 0.9, 0.9, 0.1, 0.1, 0.9, 0.1 );
	GameTooltip:Show();
end




--[[	CTA_SetRaidInfo()
		---------------------------------------------------------------
		Set group information for the specified group.
		]]

function CTA_SetRaidInfo( raid, name, score, comment, groupType, size, maxSize, minLevel, classes, passwordProtected, creationTime, options )
	raid.leader = name;
	raid.score = tonumber(score);	
	raid.comment = comment;
	raid.pvtype = tonumber(groupType);
	raid.size = tonumber(size);
	raid.maxSize = tonumber(maxSize);
	raid.minLevel = tonumber(minLevel);
	raid.classes = tonumber(classes);
	raid.passwordProtected = tonumber(passwordProtected);
	raid.creationTime = creationTime;
	raid.options = options;
end





--[[	---------------------------------------------------------------
		Functions Related To Hosting A Group And The Acid Items	
		--------------------------------------------------------------- 
		]]




--[[	CTA_MyRaidInstantUpdate()						UPDATE FUNCTION
		---------------------------------------------------------------
		Called by CTA_MyRaidFrame Components.
		This is the longest, most elaborate and buggy function and has
		been hacked and updated far too many times. 
		Todo: A complete rewrite of the function.
		]]

function CTA_MyRaidInstantUpdate()
	if( CTA_MyRaid == nil ) then return; end
	
	local myName = UnitName( CTA_PLAYER );
	
	local myComment = CTA_SafeSet( CTA_MyRaidFrameDescriptionEditBox:GetText(), CTA_NO_DESCRIPTION );
	
	local myRaidType = CTA_RAID_TYPE_PVE;
	if( CTA_MyRaidFramePVPCheckButton:GetChecked() ) then
		myRaidType = CTA_RAID_TYPE_PVP;
	end
		
	-- Advanced Class Integration and Distribution
	-- ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID 
	-- ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID 
	
	--[[	------------------------------------
			[Setup Acid Items]
			
			If the acid item has no class list
			then it is hidden.
			------------------------------------
			]]
	if( not CTA_Acid0.val ) then
		local classes = { };
		classes[1] = CTA_PRIEST;
		classes[2] = CTA_MAGE;
		classes[3] = CTA_WARLOCK;
		classes[4] = CTA_DRUID;
		classes[5] = CTA_HUNTER;
		classes[6] = CTA_ROGUE;
		classes[7] = CTA_WARRIOR;
		if( UnitFactionGroup(CTA_PLAYER) == CTA_ALLIANCE ) then
			classes[8] = CTA_PALADIN;
		else
			classes[8] = CTA_SHAMAN;
		end				
		
		local num = 0;
		while( num < 9 ) do
			local item = getglobal( "CTA_Acid"..num );
			local class = getglobal( "CTA_Acid"..num.."ClassNameLabel" );
			
			if( num > 0 ) then
				item.val = 0;
				item.cur = 0;
			else
				class:SetText( CTA_ANY_CLASS );
				item.val = CTA_MyRaid.maxSize;
				getglobal( "CTA_Acid"..num.."LessButton"):Hide();
				getglobal( "CTA_Acid"..num.."MoreButton"):Hide();			
				--getglobal( "CTA_Acid"..num.."EditButton"):Hide();			
				getglobal( "CTA_Acid"..num.."DeleteButton"):Hide();
			end
				
			num = num + 1;
		end
	end
	

	--[[	------------------------------------
			[Update the Max Size]
			
			If the and sets up certain features
			for raid / party
			------------------------------------
			]]

	local myOldMax = CTA_MyRaid.maxSize;
	if( not myOldMax ) then myOldMax = 40; end
	
	if ( IsRaidLeader() and GetNumRaidMembers() > 0 ) then CTA_HostingRaidGroup = 1; end
	local maxSizeLimit = 5;	           					-- R2
	CTA_ConvertToRaidButton:Hide();
	CTA_MaxSizeHelpLabel:SetText( CTA_MAXIMUM_PLAYERS_HELP2 );
	if( IsPartyLeader() and GetNumRaidMembers() == 0  ) then
		CTA_ConvertToRaidButton:Show();
	else
		CTA_ConvertToRaidButton:Hide();
	end
	if( CTA_HostingRaidGroup ) then
		maxSizeLimit = 40;		
		CTA_MaxSizeHelpLabel:SetText( CTA_MAXIMUM_PLAYERS_HELP );	
	end
	if( IsRaidLeader() and GetNumRaidMembers() > 0 and GetNumRaidMembers() < 6 ) then
		CTA_ConvertToPartyButton:Show();	
	else
		CTA_ConvertToPartyButton:Hide();	
	end

	if( CTA_MyRaid.maxSize > maxSizeLimit ) then
		CTA_MyRaid.maxSize = maxSizeLimit;
	end
	
	local myMaxSize = CTA_SafeSetNumber( CTA_MyRaidFrameMaxSizeEditBox:GetText(), 5, maxSizeLimit ); 
	if( not myMaxSize ) then
		myMaxSize = CTA_MyRaid.maxSize;
	else
		CTA_MyRaid.maxSize = tonumber(myMaxSize);
	end
	CTA_MyRaidFrameMaxSizeEditBox:SetText(""..myMaxSize);
	

	--[[	------------------------------------
			[Update ACID Scale]
			
			According to the max size
			------------------------------------
			]]

	--if( myMaxSize ~= myOldMax ) then
		local num = 0;
		local cval = 0;
		while( num < 9 ) do	
			local item = getglobal( "CTA_Acid"..num );
			local ratio = item.val/myOldMax;
			item.val = floor(myMaxSize*ratio);
			cval = cval+item.val;
			num = num + 1;
		end
		if( cval < myMaxSize ) then
			CTA_Acid0.val = CTA_Acid0.val + (myMaxSize-cval);
		end
		num = 0;
		while( num < 9 and cval > myMaxSize ) do
			local item = getglobal( "CTA_Acid"..num );
			if( item.val > 0 ) then
				item.val = item.val - 1;
				cval = cval - 1;
			else
				num = num + 1;
			end
		end
	--end
	--CTA_LogMsg( "Adjusted ACID Size ("..cval..")", CTA_GENERAL );


	--[[	------------------------------------
			[Reset Acid item current size]
			
			Set the current players in each rule 
			to 0
			------------------------------------
			]]


	local num = 0;
	while( num < 9 ) do
		local item = getglobal( "CTA_Acid"..num );
		item.cur = 0;
		num = num + 1;
	end	
	
	
	--[[	------------------------------------
			[Update ACID items current size]
			
			Big change here now
			------------------------------------
			]]

	
	local name, level, class;
	local over = 0;
	num = 1;
	while ( num <= 40 ) do	
		name, level, class = CTA_GetGroupMemberInfo( num );
		if( name == nil ) then break; end
		local index = CTA_GetClassCode(class);
		
		local bestItem = nil;
		for i = 1, 8 do
			local item = getglobal( "CTA_Acid"..i );
			if( item.classes and item.classes[class] ) then
				if( not bestItem or CTA_getn(bestItem.classes) > CTA_getn(item.classes) ) then
					if( item.cur < item.val ) then
						bestItem = item;
					end
				end
			end
		end
		
		if( not bestItem ) then
			over = over + 1;
		else
			bestItem.cur = bestItem.cur + 1;
		end
		--if( item.cur > item.val ) then over = over + 1; end
		
		if( CTA_InvitationRequests[name] ) then
			CTA_RemoveRequest( name ); -- R2: Remove pending member if in raid
			CTA_LogMsg( name.." has joined the group - request removed" );	
			CTA_SendAutoMsg( CTA_PROMO, name );
		end

		num = num+1;
	end	


	--[[	------------------------------------
			[Update the Group Size]
			
			Take pendings into account etc
			------------------------------------
			]]


	local pendingSize = 0; 
	for name, data in CTA_InvitationRequests do
		if( name and data.status == 2 ) then 	-- R2: pending members
			--CTA_Println( name..": "..class );
			local index = CTA_GetClassCode( data.class);
			local item = getglobal( "CTA_Acid"..index );
			item.cur = item.cur + 1;
			pendingSize = pendingSize + 1;			
			if( item.cur > item.val ) then over = over + 1; end
		end		
	end
		
	CTA_Acid0.cur = over;
	
	--[[
	local oldSize = CTA_MyRaid.size;
	CTA_MyRaid.size = CTA_GetNumGroupMembers() + pendingSize;
	local mySize = CTA_MyRaid.size;

	if ( ( IsRaidLeader() and GetNumRaidMembers() > 0 ) ) then
		CTA_RaidSizeLabel:SetText( CTA_SIZE..": "..CTA_MyRaid.size.." ("..CTA_RAID..") ("..CTA_CURRENT..": "..CTA_GetNumGroupMembers().." "..CTA_PENDING..": "..pendingSize..")" );
	
	elseif( IsPartyLeader() and GetNumRaidMembers() == 0 ) then
		CTA_RaidSizeLabel:SetText( CTA_SIZE..": "..CTA_MyRaid.size.." ("..CTA_PARTY..") ("..CTA_CURRENT..": "..CTA_GetNumGroupMembers().." "..CTA_PENDING..": "..pendingSize..")" );
	
	end]]
	
	local oldSize = CTA_MyRaid.size;
	CTA_MyRaid.size = CTA_GetNumGroupMembers();
	local mySize = CTA_MyRaid.size;
	CTA_RaidSizeLabel:SetText( CTA_SIZE..": "..CTA_MyRaid.size.." ("..CTA_CURRENT..": "..CTA_GetNumGroupMembers().." "..CTA_PENDING..": "..CTA_getn(CTA_InvitationRequests)..")" );


	if( CTA_MyRaid.size > oldSize ) then
		PlaySound("TellMessage");
	end
	CTA_IconMsg( CTA_GROUP_MEMBERS..CTA_MyRaid.size, CTA_GROUP_UPDATE);
	
	
	--[[	------------------------------------
			[Update the Acid Items]
			
			Accordingly
			------------------------------------
			]]

	
	num = 0;
	
	CTA_AcidSummary = CTA_LFM..": "..CTA_MyRaid.comment.." ("..CTA_MyRaid.size.."/"..CTA_MyRaid.maxSize..") - ";
	
	while( num < 9 ) do
		local item = getglobal( "CTA_Acid"..num );
		
		if( item.classes or item:GetName()=="CTA_Acid0" ) then
		

			
			local nam = getglobal( "CTA_Acid"..num.."ClassNameLabel" );
			
			
			if( item:GetName()~="CTA_Acid0" ) then
				getglobal( "CTA_Acid"..num.."ClassNameLabel" ):Show();
				--getglobal( "CTA_Acid"..num.."ClassPercentLabel" ):Show();
				getglobal( "CTA_Acid"..num.."ClassAbsoluteLabel" ):Show();
				getglobal( "CTA_Acid"..num.."ClassCurrentLabel" ):Show();
				
				getglobal( "CTA_Acid"..num.."LessButton"):Show();
				getglobal( "CTA_Acid"..num.."MoreButton"):Show();			
				--getglobal( "CTA_Acid"..num.."EditButton"):Show();			
				getglobal( "CTA_Acid"..num.."DeleteButton"):SetText( "Edit" );			
			
				nam:SetText( "" );
				for key, val in item.classes do
					if( nam:GetText() ) then
						nam:SetText( nam:GetText()..key.."\n" );
					else
						nam:SetText( key.."\n" );
					end
				end
			end
			
			local percent = getglobal( "CTA_Acid"..num.."ClassPercentLabel" );
			local current = getglobal( "CTA_Acid"..num.."ClassAbsoluteLabel" );
			local absolute = getglobal( "CTA_Acid"..num.."ClassCurrentLabel" );
			local percentTex = getglobal( "CTA_Acid"..num.."PercentTexture" );
			local currentTex = getglobal( "CTA_Acid"..num.."CurrentTexture" );
	
			local pval = floor(50*item.val/CTA_MyRaid.maxSize); --80 changed to 50 R5
			if( pval > 50 ) then pval = 50; end -- cheapo fix
			local percentage = floor(100*item.val/CTA_MyRaid.maxSize);
			
			percent:SetText( percentage.."%" );
			absolute:SetText( "/"..item.val );
			
			if( item.val == 0)  then
				percentTex:Hide();
				absolute:SetTextColor( 0.5, 0.5, 0.5 );
			else
				percentTex:SetHeight( pval );
				absolute:SetTextColor( 1.0, 0.82, 0.0 );
				percentTex:Show();
			end
	
			local cval = item.cur;
			local cpval = floor(50*cval/CTA_MyRaid.maxSize); --80 -> 50 R5
			if( cpval > 50 ) then cpval = 50; end -- cheapo fix
			current:SetText( cval );
			
			if( cval == 0)  then
				currentTex:Hide();
				current:SetTextColor( 0.5, 0.5, 0.5 );
			else
				current:SetTextColor( 1.0, 0.82, 0.0 );
				currentTex:SetHeight( cpval );
				currentTex:Show();
			end
			if( cval > item.val and CTA_Acid0.cur > CTA_Acid0.val ) then
				current:SetTextColor( 1.0, 0.0, 0.0 );			
			end		
			
			local lfm = item.val-item.cur;
			if( lfm > 0 ) then
				if( num == 0 ) then
					CTA_AcidSummary = CTA_AcidSummary..(lfm).." "..CTA_ANY_CLASS..", ";
				else
					CTA_AcidSummary = CTA_AcidSummary..(lfm).." ";
					local f = nil;
					for k,v in item.classes do
						if( f ) then
							CTA_AcidSummary = CTA_AcidSummary.."/";
						else
							f = 1;
						end
						CTA_AcidSummary = CTA_AcidSummary..k;

					end
					CTA_AcidSummary = CTA_AcidSummary..", ";
				end
			end
		else

			getglobal( "CTA_Acid"..num.."ClassNameLabel" ):Hide();

			--getglobal( "CTA_Acid"..num.."ClassPercentLabel" ):Hide();
			getglobal( "CTA_Acid"..num.."ClassAbsoluteLabel" ):Hide();
			getglobal( "CTA_Acid"..num.."ClassCurrentLabel" ):Hide();

			getglobal( "CTA_Acid"..num.."PercentTexture" ):Hide();
			getglobal( "CTA_Acid"..num.."CurrentTexture" ):Hide();

			getglobal( "CTA_Acid"..num.."LessButton"):Hide();
			getglobal( "CTA_Acid"..num.."MoreButton"):Hide();			
			--getglobal( "CTA_Acid"..num.."EditButton"):Hide();			
			getglobal( "CTA_Acid"..num.."DeleteButton"):SetText( "Add" );			

		
			--item:Hide();
		end
							
		num = num + 1;
	end
	
	CTA_AcidSummary = CTA_AcidSummary.." [CTA]";
	
	
	CTA_AcidNote:SetText( CTA_AcidSummary );

	if( CTA_HostingRaidGroup and IsPartyLeader() and GetNumRaidMembers() == 0 ) then
 		CTA_ConvertToRaid();
	end
	
	-- ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID 
	-- ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID 
	-- ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID ACID 
	
	local myMinLevel = CTA_SafeSetNumber( CTA_MyRaidFrameMinLevelEditBox:GetText(), 1, 60 ); 
	if( not myMinLevel ) then
		CTA_MyRaidFrameMinLevelEditBox:SetText( CTA_MyRaid.minLevel );
		myMinLevel = CTA_MyRaid.minLevel;
	end

	local myClasses = 0; 
	if( CTA_Acid0.cur < CTA_Acid0.val ) then
		myClasses = 255;
	else
		local num = 1;
		local b = 1;
		local combinedClasses = {};
		for i = 1, 8 do
			local item = getglobal( "CTA_Acid"..i );
			if( item.classes and item.cur < item.val ) then
				for k, v in item.classes do
					combinedClasses[ k ] = 1;
				end
			end
		end
		
		for k,v in combinedClasses do
			local index = CTA_GetClassCode( k );
			myClasses = myClasses + (2^(index - 1 ));
		end
		--[[
		while( num < 9 ) do
			local item = getglobal( "CTA_Acid"..num );
			if( item.cur < item.val ) then
				myClasses = myClasses + b;
			end
			b = b * 2;			
			num = num + 1;
		end	]]
	end
	
	local myUsePassword = 1;
	local oldPassword = CTA_MyRaidPassword;
	CTA_MyRaidPassword = CTA_MyRaidFramePasswordEditBox:GetText(); 
	for space in string.gfind( CTA_MyRaidPassword, "(%s)" ) do 
		CTA_MyRaidPassword = oldPassword;
	end
	if( not CTA_MyRaidPassword or CTA_MyRaidPassword== "" ) then 
		myUsePassword = 0; 
		CTA_MyRaidPassword = nil;
		CTA_MyRaidFramePasswordEditBox:SetText( "" );

	else
		CTA_MyRaidFramePasswordEditBox:SetText( CTA_MyRaidPassword );
	end
	
	local myName = UnitName(CTA_PLAYER);
	local myTime = CTA_MyRaid.creationTime;
	local myOptions = 0;
	
 	CTA_SetRaidInfo( CTA_MyRaid, myName, 100, myComment, myRaidType, mySize, myMaxSize, myMinLevel, myClasses, myUsePassword, myTime, myOptions );	
 	CTA_PollBroadcast = 1;
 	--CTA_IconMsg( "Broadcast Polled" );
end	

function CTA_AcidItemButton_OnClick()
	local item = getglobal( this:GetParent():GetName() );
	
	if( string.find( this:GetName(), "Delete" ) ) then
		CTA_StartEditAcidItem( item );
		--[[
		if( item.classes == nil ) then
			CTA_AddAcidItem( item );
		else
			CTA_StartEditAcidItem(item);
		end]]
	elseif( string.find( this:GetName(), "Less" ) ) then
		if( item.val > 0 ) then
			item.val = item.val - 1;
			CTA_Acid0.val = CTA_Acid0.val + 1;
		end
		CTA_MyRaidInstantUpdate();
	else
		if( CTA_Acid0.val > 0 ) then
			item.val = item.val + 1;
			CTA_Acid0.val = CTA_Acid0.val - 1;
		end
		CTA_MyRaidInstantUpdate();
	end
end




--[[	CTA_StartEditAcidItem()
		---------------------------------------------------------------
		Called by CTA_Acid(0-8) AddButton Components.
		All this function really does is set up the check buttons
		in the <ui>CTA_AcidEditDialog</ui> Frame before showing it 
		to the user.
		]]
		
function CTA_StartEditAcidItem( item ) 
	for i = 1, 8 do
		getglobal( "CTA_AcidClassCheckButton"..i ):SetChecked( 0 );
	end
	
	if( UnitFactionGroup(CTA_PLAYER) == CTA_ALLIANCE ) then
		CTA_AcidClassCheckButton8TextLabel:SetText( CTA_PALADIN );
	else
		CTA_AcidClassCheckButton8TextLabel:SetText( CTA_SHAMAN );
	end	
	
	if( item.classes ) then
		for key, val in item.classes do
		
	    	for i = 1, 8 do
 				if ( getglobal( "CTA_AcidClassCheckButton"..i.."TextLabel" ):GetText() == key ) then
 					getglobal( "CTA_AcidClassCheckButton"..i ):SetChecked( 1 );
 				end
			end
		end
	else
		item.classes = {};	
	end
	 
	CTA_AcidEditDialogHeadingLabel:SetText( CTA_EDIT_ACID_CLASSES );
	CTA_AcidEditDialog.target = item:GetName();	    	
				
	CTA_AcidEditDialog:Show();
end




--[[	CTA_EditAcidItem()
		---------------------------------------------------------------
		Called by the <ui>CTA_AcidEditDialog</ui>'s OKButton Component.
		Sets the Acid item's class list to what classes were checked
		by the user in the edit dialog.
		]]
		
function CTA_EditAcidItem()
	local acidItem = getglobal( CTA_AcidEditDialog.target );
	local checkCount = 0;
	acidItem.classes = {};
	for i = 1, 8 do
		local checked =  getglobal( "CTA_AcidClassCheckButton"..i ):GetChecked();
		if( checked ) then
			acidItem.classes[ getglobal( "CTA_AcidClassCheckButton"..i.."TextLabel" ):GetText() ] = 0;
			checkCount = checkCount + 1;
		end
	end
	
	if( checkCount == 0 or checkCount == 8 ) then
		acidItem.classes = nil;
		if( acidItem.val ) then
			CTA_Acid0.val = CTA_Acid0.val + acidItem.val;
		end
		acidItem.val = 0;
	end
	
	CTA_AcidEditDialog:Hide();
	CTA_MyRaidInstantUpdate();
	
end




--[[	CTA_getn()
		---------------------------------------------------------------
		Utility function that returns the length of a list.
		@arg the list 
		@return the length of the list 
		]]

function CTA_getn( list ) 
	local c = 0;
	for i, j in list do
		c = c + 1;
	end
	return c;
end




--[[	CTA_StartAParty()
		---------------------------------------------------------------
		Starts a party group.
		Called by StartARaidFrame's StartAPartyButton 
		]]
		
function CTA_StartAParty()
	CTA_HostingRaidGroup = nil;
	CTA_MyRaid = {};
 	CTA_SetRaidInfo( CTA_MyRaid,  UnitName( CTA_PLAYER ), 100, "", CTA_RAID_TYPE_PVE, GetNumPartyMembers()+1, 5, 1, 255, 0, CTA_GetTime(), 0 );	
 	CTA_MyRaidIsOnline = 1;
	CTA_ShowStartRaidFrame();
end




--[[	CTA_StartARaid
		---------------------------------------------------------------
		Starts a raid group.
		Called by StartARaidFrame's StartARaidButton
		]]
		
function CTA_StartARaid()
	CTA_HostingRaidGroup = 1;
	CTA_MyRaid = {};
 	CTA_SetRaidInfo( CTA_MyRaid,  UnitName( CTA_PLAYER ), 100, "", CTA_RAID_TYPE_PVE, GetNumRaidMembers(), 10, 1, 255, 0, CTA_GetTime(), 0 );	
 	CTA_MyRaidIsOnline = 1;
	CTA_ShowStartRaidFrame();
end




--[[	CTA_StopHosting()
		---------------------------------------------------------------
		Stops hosting a group with CTA. 
		]]
		
function CTA_StopHosting()
	CTA_HostingRaidGroup = nil;
	CTA_MyRaid = nil;
 	CTA_MyRaidIsOnline = nil;
	CTA_PollBroadcast = 2;
 	
	CTA_SearchFrame:Hide();
	CTA_MyRaidFrame:Hide();
	CTA_SettingsFrame:Hide();
	CTA_GreyListFrame:Hide();
	CTA_LogFrame:Hide();
 	
	CTA_ShowStartRaidFrame();
end




--[[	CTA_ShowStartRaidFrame()
		---------------------------------------------------------------
		Prompts the user to start hosting a group with CTA or
		tells the user that s/he cannot currently host a group or
		shows the group information frame if user is already using
		CTA to host a group.
		]]

function CTA_ShowStartRaidFrame() 
	CTA_StartRaidFrame:Show();
	
	if( CTA_MyRaid ) then
		CTA_StartRaidFrame:Hide();
		
		if( CTA_ToggleViewableButton:GetText() ==  CTA_GO_OFFLINE ) then
			CTA_MyRaidIsOnline = 1;
		end
		
		CTA_MyRaidFrameDescriptionEditBox:SetText(""..CTA_MyRaid.comment);
		
		local myRaidType = CTA_MyRaid.pvtype;
		if( myRaidType == CTA_RAID_TYPE_PVP ) then
			CTA_MyRaidFramePVPCheckButton:SetChecked(1)
			CTA_MyRaidFramePVECheckButton:SetChecked(0)
		else
			CTA_MyRaidFramePVPCheckButton:SetChecked(0)
			CTA_MyRaidFramePVECheckButton:SetChecked(1)
		end
		
		CTA_MyRaidFrameMaxSizeEditBox:SetText(""..CTA_MyRaid.maxSize);
		CTA_MyRaidFrameMinLevelEditBox:SetText(""..CTA_MyRaid.minLevel); 
		
		if( CTA_MyRaidPassword ) then
			CTA_MyRaidFramePasswordEditBox:SetText(CTA_MyRaidPassword); 
		else 
			CTA_MyRaidFramePasswordEditBox:SetText(""); 
		end	
	
		CTA_MyRaidInstantUpdate(); 
		CTA_MyRaidFrame:Show();
	end

	CTA_StartARaidButton:Hide();
	CTA_StartAPartyButton:Hide();	

	if ( CTA_PlayerCanHostGroup() ) then
		CTA_StartRaidLabel:SetText( CTA_PLAYER_CAN_START_A_GROUP );	

		if( not CTA_MyRaid and IsRaidLeader() and GetNumRaidMembers() > 0 ) then
			CTA_StartARaidButton:Show();
		elseif( not CTA_MyRaid and IsPartyLeader() and GetNumRaidMembers() == 0 ) then
			CTA_StartAPartyButton:Show();	
			CTA_StartARaidButton:Show();
		else
			CTA_StartAPartyButton:Show();	
			CTA_StartARaidButton:Show();
		end
	else
		CTA_StartRaidLabel:SetText( CTA_PLAYER_IS_RAID_MEMBER_NOT_LEADER );	
	end						
end




--[[	CTA_AcidItem_ShowTooltip()
		---------------------------------------------------------------
		Shows tooltip for acid items.
		]]

function CTA_AcidItem_ShowTooltip()
	GameTooltip:SetOwner( this, "ANCHOR_TOP" );
	GameTooltip:ClearLines();
	GameTooltip:ClearAllPoints();
	GameTooltip:SetPoint("TOPLEFT", this:GetName(), "BOTTOMLEFT", 0, -8);	
		
	local acidItem = this;
	if( not acidItem.classes and acidItem:GetName() ~= "CTA_Acid0" ) then 
		GameTooltip:AddLine( CTA_NO_CLASSES_TOOLTIP );		
		GameTooltip:AddLine( CTA_NO_CLASSES_TOOLTIP2, 1, 1, 1, 1, 1 );		
		return; 
	end
	
	local needed = acidItem.val - acidItem.cur;
	if( needed < 0 ) then needed = 0; end
	
	if( this:GetName() == "CTA_Acid0" ) then
		GameTooltip:AddDoubleLine( CTA_MAXIMUM_PLAYERS_ALLOWED..":", ""..this.val );
		GameTooltip:AddDoubleLine( CTA_PLAYERS_IN_RAID..":", ""..this.cur );
		GameTooltip:AddDoubleLine( CTA_NUMBER_OF_PLAYERS_NEEDED..":", ""..needed );
		GameTooltip:AddLine( CTA_ANY_CLASS_TOOLTIP, 1, 1, 1, 1, 1 );		
	else
		GameTooltip:AddDoubleLine( CTA_MINIMUM_PLAYERS_WANTED..":", ""..this.val );
		GameTooltip:AddDoubleLine( CTA_PLAYERS_IN_RAID..":", ""..this.cur );
		GameTooltip:AddDoubleLine( CTA_NUMBER_OF_PLAYERS_NEEDED..":", ""..needed );
		GameTooltip:AddLine( CTA_CLASS_TOOLTIP, 1, 1, 1, 1, 1 );				
	end
	
	GameTooltip:Show();
end




--[[	CTA_GetGroupMemberInfo()
		---------------------------------------------------------------
		Returns information about a group member. 
		@arg the index of the group member
		@return the name, level, class of the player.
		]]

function CTA_GetGroupMemberInfo( index )
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	if ( IsRaidLeader() and GetNumRaidMembers() > 0 ) then
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(index);	
	elseif ( IsPartyLeader() and GetNumPartyMembers() > 0 ) then
		local target = CTA_PLAYER;
		if( index > 1 and index < 6 ) then
			target = "PARTY"..(index-1);
		end
		name = UnitName(target);
		level = UnitLevel(target);
		class = UnitClass(target);
	elseif( GetNumRaidMembers() == 0  and GetNumPartyMembers() == 0 and index == 1 ) then
		local target = CTA_PLAYER;
		name = UnitName(target);
		level = UnitLevel(target);
		class = UnitClass(target);
	end
	return name, level, class;
end




--[[	CTA_GetNumGroupMembers()
		---------------------------------------------------------------
		Returns information about a group member. 
		@arg the index of the group member
		@return the name, level, class of the player.
		]]

function CTA_GetNumGroupMembers()
	if( IsPartyLeader() ) then
		return GetNumPartyMembers() + 1;
	elseif( IsRaidLeader() ) then
		return GetNumRaidMembers();
	else
		return 1;
	end
end




--[[	CTA_DissolveRaid()
		---------------------------------------------------------------
		Dissolves the group by removing each member.
		]]

function CTA_DissolveRaid()
	CTA_IconMsg( CTA_DISSOLVING_RAID, CTA_GROUP_UPDATE );
	num = 1;
	local numRaidMembers = GetNumRaidMembers();
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local over = 0;
	while ( num <= numRaidMembers ) do	
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(num);
		if( name ~= UnitName(CTA_PLAYER) ) then
			UninviteByName( name );
			CTA_SendAutoMsg( CTA_DISSOLVING_THE_RAID_CHAT_MESSAGE, name);					
		end
		num = num+1;
	end	
	CTA_IconMsg( CTA_RAID_DISSOLVED, CTA_GROUP_UPDATE );
end




--[[	CTA_ConvertToParty()
		---------------------------------------------------------------
		convert your raid to a party.
		]]

function CTA_ConvertToParty() --R2 (suggested by Sadris)
	CTA_IconMsg( CTA_CONVERTING_TO_PARTY, CTA_GROUP_UPDATE );
	num = 1;
	local numRaidMembers = GetNumRaidMembers();
	if( numRaidMembers > 5 ) then
		CTA_Println( CTA_CANNOT_CONVERT_TO_PARTY );
		return;
	end
	local memberList = {};
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local over = 0;
	while ( num <= numRaidMembers ) do	
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(num);
		if( name ~= UnitName(CTA_PLAYER) ) then
			memberList[num] = name;
			UninviteByName( name );
			CTA_MyRaidInstantUpdate();
			
			CTA_SendAutoMsg( CTA_CONVERTING_TO_PARTY_MESSAGE, name);					
		end
		num = num+1;
	end	
	for i = 1, numRaidMembers - 1 do
		InviteByName( memberList[i] );
	end
	CTA_IconMsg( CTA_CONVERTING_TO_PARTY_DONE, CTA_GROUP_UPDATE );
	CTA_HostingRaidGroup = nil;
end




--[[	CTA_GetGroupType()
		---------------------------------------------------------------
		Returns a String representation of the type of group
		currently being hosted.
		@return CTA_GROUP or CTA_PARTY 
		]]

function CTA_GetGroupType()
	if ( CTA_HostingRaidGroup ) then
		return CTA_RAID;
	end
	return CTA_PARTY;
end





--[[	CTA_ConvertToParty()
		---------------------------------------------------------------
		Converts the raid to a party
		]]
		
function CTA_ConvertToRaid()
	if( IsPartyLeader() ) then
		CTA_HostingRaidGroup = 1;
		ConvertToRaid();
	end
end




--[[	CTA_PlayerCanHostGroup()
		---------------------------------------------------------------
		Indicates whether a player can start hosting a group according
		to CTA logic.
		returns 1 if can host, nil if not
		]]
	
function CTA_PlayerCanHostGroup()
	if ( ( IsRaidLeader() and GetNumRaidMembers() > 0 ) or 
		 ( IsPartyLeader() and GetNumRaidMembers() == 0 ) or
		 ( GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 ) ) then
		return 1;
	else
		return nil;
	end
end




--[[	---------------------------------------------------------------
		Functions Related To The Blacklist	
		--------------------------------------------------------------- 
		]]




--[[	CTA_UpdateGreyListItems()     					UPDATE FUNCTION
		---------------------------------------------------------------
		Updates the list of blacklisted players.										   
		]]

function CTA_UpdateGreyListItems()
	CTA_GreyListItem0NameLabel:SetText( CTA_NAME );
	CTA_GreyListItem0NoteLabel:SetText( CTA_PLAYER_NOTE );
	CTA_GreyListItem0StatusLabel:SetText( "" );
	CTA_GreyListItem0:Show();
		
	local gls = getn(CTA_BlackList);
	if( not gls ) then
		gls = 0;
	end
	CTA_GreyListFramePageLabel:Show();
	local cpage = floor( CTA_PlayerListOffset / CTA_MAX_BLACKLIST_ITEMS );
	local tpage = floor( gls / CTA_MAX_BLACKLIST_ITEMS );
	if( cpage == 0 or cpage <= CTA_PlayerListOffset / CTA_MAX_BLACKLIST_ITEMS ) then cpage = cpage + 1; end
	if( tpage == 0 or tpage < gls / CTA_MAX_BLACKLIST_ITEMS ) then tpage = tpage + 1; end
	CTA_GreyListFramePageLabel:SetText( CTA_PAGE.." "..cpage.." / "..tpage );
	
	
	for index = 1, CTA_MAX_BLACKLIST_ITEMS do
		local item = getglobal( "CTA_GreyListItem"..index );
		if( index + CTA_PlayerListOffset <= gls  ) then 
			local data = CTA_BlackList[ index + CTA_PlayerListOffset ];
			getglobal( "CTA_GreyListItem"..index.."NameLabel" ):SetText( data.name );
			local i = CTA_FindInList( data.name, CTA_SavedVariables.GreyList );
			if( i ) then
				getglobal( "CTA_GreyListItem"..index.."NoteLabel" ):SetTextColor( 1, 1, 1 );
			else
				getglobal( "CTA_GreyListItem"..index.."NoteLabel" ):SetTextColor( 1, 0, 0 );
			end
			getglobal( "CTA_GreyListItem"..index.."NoteLabel" ):SetText( data.note );
			getglobal( "CTA_GreyListItem"..index.."RatingLabel" ):SetText( data.rating );
			getglobal( "CTA_GreyListItem"..index ):Show();
		else
			item:Hide();
		end
	end
end




--[[	CTA_ShowGreyListFrame()
		---------------------------------------------------------------
		Show the Greylist frame
		]]
		
function CTA_ShowGreyListFrame()
	CTA_SearchFrame:Hide();
	CTA_MyRaidFrame:Hide();
	CTA_StartRaidFrame:Hide();
	CTA_SettingsFrame:Hide();
	CTA_LogFrame:Hide();
	CTA_GreyListFrame:Show();
	CTA_UpdateGreyListItems();	
end




--[[	CTA_EditGreyListItem()
		---------------------------------------------------------------
		Shows the Edit frame for the selected Greylist item 
		]]
		
function CTA_EditGreyListItem()
	local listItem = getglobal( this:GetName() );
	CTA_GreyListItemEditFrame.name = getglobal( listItem:GetName().."NameLabel" ):GetText();
	if( not CTA_FindInList( CTA_GreyListItemEditFrame.name, CTA_SavedVariables.GreyList ) ) then
		CTA_AddPlayer( CTA_GreyListItemEditFrame.name, CTA_DEFAULT_PLAYER_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_SavedVariables.GreyList );
	end
	CTA_GreyListItemEditFrameEditBox:SetText( CTA_SavedVariables.GreyList[ CTA_FindInList( CTA_GreyListItemEditFrame.name, CTA_SavedVariables.GreyList ) ].note );
	CTA_GreyListItemEditFrameTitleLabel:SetText( CTA_EDIT_PLAYER..": "..CTA_GreyListItemEditFrame.name );
	CTA_GreyListItemEditFrame:Show();
end




--[[	CTA_GreyListItemSaveChanges()
		---------------------------------------------------------------
		Commits changes made to the selected Greylist item 
		]]
		
function CTA_GreyListItemSaveChanges()
	CTA_SavedVariables.GreyList[CTA_FindInList( CTA_GreyListItemEditFrame.name, CTA_SavedVariables.GreyList )].note = CTA_GreyListItemEditFrameEditBox:GetText();
	CTA_BlackList[CTA_FindInList( CTA_GreyListItemEditFrame.name, CTA_BlackList )].note = CTA_GreyListItemEditFrameEditBox:GetText();
	
	CTA_GreyListItemEditFrame:Hide();
	CTA_ShowGreyListFrame();
end




--[[	CTA_DeletePlayer()
		---------------------------------------------------------------
		Removes the player from the Greylist
		]]
		
function CTA_DeletePlayer()
	table.remove( CTA_BlackList , CTA_FindInList( CTA_GreyListItemEditFrame.name, CTA_BlackList ) );
	table.remove( CTA_SavedVariables.GreyList , CTA_FindInList( CTA_GreyListItemEditFrame.name, CTA_SavedVariables.GreyList ) );
	CTA_GreyListItemEditFrame:Hide();
	CTA_ShowGreyListFrame();
end




--[[	
function CTA_ImportFriendsToGreyList()
	numFriends = GetNumFriends();
	for i=1,numFriends do
		local name, level, class, area, connected = GetFriendInfo(i);
		if( not CTA_SavedVariables.GreyList[name] ) then
			CTA_AddPlayer( name, CTA_DEFAULT_PLAYER_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_SavedVariables.GreyList );
		end
	end		
end
]]




--[[	CTA_ImportIgnoreListToGreyList()
		---------------------------------------------------------------
		Adds players from the ignore list to the Greylist
		]]
		
function CTA_ImportIgnoreListToGreyList()
	local numIgnores = GetNumIgnores();
	for i = 1, numIgnores do
		local name = GetIgnoreName(i);
		CTA_AddPlayer( name, CTA_DEFAULT_IMPORTED_IGNORED_PLAYER_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_SavedVariables.GreyList );
		CTA_AddPlayer( name, CTA_DEFAULT_IMPORTED_IGNORED_PLAYER_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_BlackList );
	end
end





--[[	CTA_AddGreyToBlack()
		---------------------------------------------------------------
		Updates the Blacklist by adding Greylist entries to it.
		]]
		
function CTA_AddGreyToBlack()
	for i = 1, getn(CTA_SavedVariables.GreyList) do
		CTA_AddToList( CTA_SavedVariables.GreyList[i], CTA_BlackList );
	end
end





--[[	CTA_AddPlayer()
		---------------------------------------------------------------
		Adds a new player to the Greylist.
		@arg the name of the player 
		@arg the note to be added 
		@arg the status of the player 
		@arg the rating of the player 
		@arg the list in which to enter the data
		]]
		
function CTA_AddPlayer( name, note, status, rating, list )
	local data = { name=name, note=note, status=status, rating=rating };
	CTA_AddToList( data, list );
	CTA_UpdateGreyListItems();
end


--[[	CTA_AddToList()
		---------------------------------------------------------------
		Add data to list only if the name is not already in the List
		@arg the data to be added
		@arg the list in which to enter the data
		]]

function CTA_AddToList( data, list )
	if( not CTA_FindInList( data.name, list ) ) then
		table.insert( list, data ); 
	end
end




--[[	CTA_FindInList()
		---------------------------------------------------------------
		Returns the index of the data which has a name field that
		matches the name provided
		@arg the name to search for
		@arg the list in which to search for the data
		@return index if found, nil if not found
		]]
		
function CTA_FindInList( name, list )
	for i = 1, getn(list) do
		if( list[i].name == name ) then
			return i;
		end
	end
	return nil;
end




--[[	---------------------------------------------------------------
		Generic Functions Driven Directly By User Interface Events
		---------------------------------------------------------------
		]]
	
	

	
--[[	CTA_ToggleMainFrame()
		---------------------------------------------------------------
		Show/hide the Main Frame. If the search frame is visible
		and the main frame is opened the results list is automatically
		refreshed.  
		Called by the minimap icon and the main frame's close button. 
		]]
		
function CTA_ToggleMainFrame()
	PlaySound("igCharacterInfoTab");
	if( CTA_MainFrame:IsVisible() ) then
		CTA_MainFrame:Hide();
	else
		CTA_MainFrame:Show();
		--[[if( CTA_SearchFrame:IsVisible() ) then
			CTA_ApplyFiltersToGroupList();
		end	]]	
	end
end




--[[	CTA_Tab_OnCLick()
		---------------------------------------------------------------
		Switches visibility of the frames in the main frame.
		Called by all tab buttons under the main frame. 
		]]

function CTA_Tab_OnCLick()
	PlaySound("igCharacterInfoTab");
	CTA_SearchFrame:Hide();
	CTA_StartRaidFrame:Hide();
	CTA_MyRaidFrame:Hide();
	CTA_SettingsFrame:Hide();
	CTA_GreyListFrame:Hide();
	CTA_LogFrame:Hide();
	
	
	CTA_ShowSearchButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() - 1);	
	CTA_ShowMyRaidButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() - 1);	
	CTA_ShowPlayerListButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() - 1);	
	CTA_ShowSettingsButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() - 1);	
	CTA_ShowLogButton:SetFrameLevel(CTA_MainFrame:GetFrameLevel() - 1);	
	this:SetFrameLevel(CTA_MainFrame:GetFrameLevel() + 1);	
	
	if( this:GetName() == "CTA_ShowSearchButton" ) then
		CTA_SearchFrame:Show();	
		--[[CTA_ApplyFiltersToGroupList();]]
	elseif( this:GetName() == "CTA_ShowMyRaidButton" ) then
		CTA_ShowStartRaidFrame();
	elseif( this:GetName() == "CTA_ShowPlayerListButton" ) then
		CTA_ShowGreyListFrame();
	elseif( this:GetName() == "CTA_ShowSettingsButton" ) then
		CTA_SettingsFrame:Show();
	elseif( this:GetName() == "CTA_ShowLogButton" ) then
		CTA_LogFrame:Show();
	end
end




--[[	CTA_DialogOKButton_OnCLick()
		---------------------------------------------------------------
		Handles all 'Ok button' events generated by dialogs. 
		]]

function CTA_DialogOKButton_OnCLick()
	local item = this:GetParent();
	if( item:GetName() == "CTA_AddPlayerFrame" ) then
		local name = CTA_AddPlayerFrameEditBox:GetText();
		if( name and name ~= "" ) then
			CTA_AddPlayer( name, CTA_DEFAULT_PLAYER_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_SavedVariables.GreyList );
			CTA_AddPlayer( name, CTA_DEFAULT_PLAYER_NOTE, CTA_DEFAULT_STATUS, CTA_DEFAULT_RATING, CTA_BlackList );
		end
		CTA_AddPlayerFrame:Hide();
	end
	
	if( item:GetName() == "CTA_JoinRaidWindow" ) then
		CTA_SendPasswordRaidInvitationRequest();
	end	
	
	if( item:GetName() == "CTA_AcidEditDialog" ) then
		CTA_EditAcidItem();
	end	

end




--[[	CTA_UpdateMinimapIcon()
		---------------------------------------------------------------
		Adjusts the minimap icon position. 
		]]

function CTA_UpdateMinimapIcon()
	CTA_MinimapIcon:SetPoint( "TOPLEFT", "Minimap", "TOPLEFT",
		55 - ( ( CTA_SavedVariables.MinimapRadiusOffset ) * cos( CTA_SavedVariables.MinimapArcOffset ) ),
		( ( CTA_SavedVariables.MinimapRadiusOffset ) * sin( CTA_SavedVariables.MinimapArcOffset ) ) - 55
	);
	CTA_MinimapMessageFrame:SetPoint( "TOPRIGHT", "Minimap", "TOPRIGHT",
		( 0 - ( ( CTA_SavedVariables.MinimapMsgRadiusOffset ) * cos( CTA_SavedVariables.MinimapMsgArcOffset ) ) ) - 55,
		( ( CTA_SavedVariables.MinimapMsgRadiusOffset ) * sin (CTA_SavedVariables.MinimapMsgArcOffset ) ) - 55
	);

end




--[[	---------------------------------------------------------------
		Utility Functions	
		--------------------------------------------------------------- 
		]]


-- Other Functions --

--	Searches a specified String (source) for a keyword String (search)
--	String patterns are not allowed - simple search keywords are used
--	Returns a number representing the degree to which the search string 
--	was found in the specified string using my own scoring system.
--	Number ( 0 - 100 )
--
function CTA_SearchScore( source, search, show )
	local ad = string.lower( source );
	local query = string.lower( search );
		
	if( string.find( ad, query ) ) then
		return 100, "|cff33ff33"..source.."|r";
	else
		local sourceWords = {};
		for word in string.gfind( ad, "%w+" ) do
			sourceWords[word] = word;
		end
		
		local highlighted = source;	
				
		local score = 0;
		local total = 0;
		for word in string.gfind(query, "%w+") do
			total = total + 1;
			if( sourceWords[word] ) then
				score = score + 1;
				
				if( show ) then
					local s, e = string.find( string.lower( highlighted ), word );
					highlighted = string.sub( highlighted, 1, s-1 ).."|cff99ff33"..string.sub( highlighted, s, e ).."|r"..string.sub( highlighted, e+1 );
				end
			elseif( string.find( ad, word ) ) then
				score = score + 0.9;
				
				if( show ) then
					local s, e = string.find( string.lower( highlighted ), word );
					highlighted = string.sub( highlighted, 1, s-1 ).."|cffccff33"..string.sub( highlighted, s, e ).."|r"..string.sub( highlighted, e+1 );
				end
			end
		end
		
		if( score > 0 ) then 
			score = floor(99*score/total);	
		end
		
		return score, highlighted;
	end
end


-- 	Returns a String representation of the current time
--	String ( eg. "14:40" )
function CTA_GetTime()
	local hour, minute = GetGameTime();
	local t = hour;
	if( hour < 10 ) then t = "0"..t; end
	t = t..":";
	if( minute < 10 ) then t = t.."0"; end
	t = t..minute;
	return t;
end


--	Returns a String from the specified textfield (uiVal)
--	If the String is Nil, then (defaultVal) is returned
--	String / defaultVal
--
function CTA_SafeSet( uiVal, defaultVal )
	if( not uiVal or uiVal=="" ) then 
		return defaultVal;
	else
		return uiVal;
	end
end


--	Returns the number entered into the textfield (uiValue),
--	if the number is valid, is no less than (min) and is no more then (max)
-- 	Number / Nil
--
function CTA_SafeSetNumber( uiValue, min, max )
	for value in string.gfind( uiValue, "(%d+)" ) do 
		if( value and value ~= "" and tonumber(value) >=min and tonumber(value) <= max ) then
			return tonumber(value);
		end
	end
	return nil;
end


--	Shows an error dialog with a title, text and close button
--
function CTA_ShowError( title, text )
    CTA_InformationDialogHeadingLabel:SetText( title );
    CTA_InformationDialogContentLabel:SetText( text );
	CTA_InformationDialog:Show();
end


--	Returns the class code for this player.
--	Number ( 1 - 8 )
--
function CTA_MyClassCode()
	local myClass = UnitClass(CTA_PLAYER);
	return CTA_GetClassCode(myClass);
end


--	Returns a String representaion of a class code
--	String ( eg. "Priest" )
--
function CTA_GetClassCode( name )
	local classes = { };
	classes[CTA_PRIEST] = 1;
	classes[CTA_MAGE] = 2;
	classes[CTA_WARLOCK] = 3;
	classes[CTA_DRUID] = 4;
	classes[CTA_HUNTER] = 5;
	classes[CTA_ROGUE] = 6;
	classes[CTA_WARRIOR] = 7;
	classes[CTA_PALADIN] = 8;
	classes[CTA_SHAMAN] = 8;

	return classes[name];
end


--	Returns whether the class code (value) is in a class set (classSet)
--	Number ( 1 / 0 )
--
function CTA_CheckClasses( classSet, value )
	local b = "";
	local c = classSet;

	while( c > 0 ) do
		local d = mod(c, 2);
		b = d..b;
		c = floor(c/2);
	end
	while(string.len(b) < 8 ) do
		b = "0"..b;
	end
	
	return tonumber( string.sub(b, 9-value, 9-value ) );
end


--	Returns a String with all the class names represented by the class set
--	String ( eg. "Priest Druid Warlock" )
--
function CTA_GetClassString( classSet )
	local b = "";
	local c = classSet;
	
	local classes = { };
	classes[1] = CTA_PRIEST;
	classes[2] = CTA_MAGE;
	classes[3] = CTA_WARLOCK;
	classes[4] = CTA_DRUID;
	classes[5] = CTA_HUNTER;
	classes[6] = CTA_ROGUE;
	classes[7] = CTA_WARRIOR;
	if( UnitFactionGroup(CTA_PLAYER) == CTA_ALLIANCE ) then
		classes[8] = CTA_PALADIN;
	else
		classes[8] = CTA_SHAMAN;
	end				
	
	while( c > 0 ) do
		local d = mod(c, 2);
		b = d..b;
		c = floor(c/2);
	end
	while(string.len(b) < 8 ) do
		b = "0"..b;
	end
	
	local pos = 8;
	local t = "";
	while( pos > 0 ) do
		if( string.sub(b, pos, pos) == "1" ) then 	
			t = t..classes[9-pos].." ";
		end
		pos = pos - 1;
	end
	return t;
end


--	Generic Tooltip Function
--
function CTA_ShowTooltip()
	if( CTA_GenTooltips[this:GetName()] ) then
		GameTooltip:SetOwner( getglobal(this:GetName()), "ANCHOR_TOP" );
		GameTooltip:ClearLines();
		GameTooltip:ClearAllPoints();
		GameTooltip:SetPoint("TOPLEFT", this:GetName(), "BOTTOMLEFT", 0, -2);		
		GameTooltip:AddLine( CTA_GenTooltips[this:GetName()].tooltip1 );
		GameTooltip:AddLine( CTA_GenTooltips[this:GetName()].tooltip2, 1, 1, 1, 1, 1 );
		GameTooltip:Show();
	end
end




--[[	---------------------------------------------------------------
		DEBUG / PROVING GROUNDS
		---------------------------------------------------------------
		]]
		
function CTA_Error( s )
	UIErrorsFrame:AddMessage(s, 0.75, 0.75, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function CTA_Println( s )
	local m = s;
	if( not m ) then
		m = "nil";
	end

	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( m, 1, 1, 0.5);
	end		
end

function CTA_IconMsg( s, t )
	local m = s;
	if( not m ) then
		m = "nil";
	end
	
	if( not t ) then
		CTA_MinimapMessageFrame:AddMessage(m, 1.0, 1.0, 0.5, 1.0, UIERRORS_HOLD_TIME);
	else
		local r = CTA_MESSAGE_COLOURS[t].r;
		local g = CTA_MESSAGE_COLOURS[t].g;
		local b = CTA_MESSAGE_COLOURS[t].b;

		CTA_MinimapMessageFrame:AddMessage(m, r, g, b, 1.0, UIERRORS_HOLD_TIME);
	end
end

function CTA_LogMsg( s, t )
	local m = s;
	if( not m ) then
		m = "nil";
	end
	m = "["..CTA_GetTime().."] "..m;
	
	
	if( not t ) then
		CTA_Log:AddMessage( m, 1.0, 1.0, 0.5 );	
	else
		local r = CTA_MESSAGE_COLOURS[t].r;
		local g = CTA_MESSAGE_COLOURS[t].g;
		local b = CTA_MESSAGE_COLOURS[t].b;

		CTA_Log:AddMessage( m, r, g, b );	
	end
end


	
	
--[[	CTA_ShowRaidMambers()
		---------------------------------------------------------------
		
		]]
		
function CTA_ShowRaidMembers()
	--[[
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local members = GetNumRaidMembers();
	for i = 1, 40 do
		if( i <= members ) then
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			getglobal( "CTA_Member"..i.."Name" ):SetText( name );
			getglobal( "CTA_Member"..i.."Rank" ):SetText( rank );
			getglobal( "CTA_Member"..i.."Ssubgroup" ):SetText( subgroup );
			getglobal( "CTA_Member"..i.."Level" ):SetText( level );
			getglobal( "CTA_Member"..i.."Class" ):SetText( class );
			getglobal( "CTA_Member"..i.."FileName" ):SetText( fileName );
			getglobal( "CTA_Member"..i.."Zone" ):SetText( zone );
			getglobal( "CTA_Member"..i.."Online" ):SetText( online );
			getglobal( "CTA_Member"..i.."IsDead" ):SetText( isDead );
		else
			getglobal( "CTA_Member"..i.."Name" ):SetText( "Player Name" );
			getglobal( "CTA_Member"..i.."Rank" ):SetText( "Default Rank" );
			getglobal( "CTA_Member"..i.."Subgroup" ):SetText( "Sub Group" );
			getglobal( "CTA_Member"..i.."Level" ):SetText( "Level" );
			getglobal( "CTA_Member"..i.."Class" ):SetText( "Class" );
			getglobal( "CTA_Member"..i.."FileName" ):SetText( "File Name" );
			getglobal( "CTA_Member"..i.."Zone" ):SetText( "Current Zone" );
			getglobal( "CTA_Member"..i.."Online" ):SetText( "Online" );
			getglobal( "CTA_Member"..i.."IsDead" ):SetText( "Dead" );
		end
	end]]
		
end
		
		
		
		





-- TRASH/DEPRECATED --
