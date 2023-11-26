--[[ 
	Author: 		Sacha
	Date Created: 	26th May 2005
	Last Update: 	13th June 2005
	Version: 		0.9.5.1500
	Note:			Functional, ready for public use and testing.
	Release:		R1
	
	-

	Web: 			

	-

	Filename: 		CallToArms.lua

	Project Name: 	Call To Arms

	Description:	Main Program

	Purpose:		
]]


CTA_RELEASEVERSION 				= "R1";
CTA_RELEASENOTE 				= "Functional, ready for public use and testing";

CTA_RAID_CHANNEL 				= "ctaqueries";
CTA_DEFAULT_RAID_CHANNEL		= "ctaqueries";

CTA_RAID_TYPE_PVP 				= 1;
CTA_RAID_TYPE_PVE 				= 0;

CTA_MyRaid 						= nil;
CTA_RaidList 					= {};
CTA_RaidListLength 				= 0;

CTA_MyRaidPassword 				= nil;
CTA_MyRaidIsOnline 				= nil;

CTA_UpdateTicker 				= 0.0;
CTA_SearchTimer 				= 0;

CTA_ResultsListOffset 			= 0;
CTA_SelectedResultListItem 		= 0;

CTA_WhoName 					= nil;
CTA_WhoBlock 					= 1;

CTA_BlackList 					= {};
CTA_ChannelSpam 				= {};
CTA_SpamTimer 					= 0;




-- Init --

	
function CTA_OnLoad()

	--Register Slash Command
	SlashCmdList["CallToArmsCOMMAND"] = CTA_SlashHandler;
	SLASH_CallToArmsCOMMAND1 = "/cta";
	
	--Register Event Listeners
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("RAID_ROSTER_UPDATE");
	this:RegisterEvent("WHO_LIST_UPDATE");
	 
	--Announce AddOn to user
	CTA_Println( CTA_CALL_TO_ARMS_LOADED );
	CTA_Error("-[ CTA "..CTA_RELEASEVERSION.." ]-");

	--Hook into ChatFrame to hide AddOn communication
	local old_ChatFrame_OnEvent = ChatFrame_OnEvent;
	function ChatFrame_OnEvent(event)
		if( arg1 and strsub(event, 1, 16) == "CHAT_MSG_WHISPER" and strsub(arg1, 1, 5) == "[CTA]" ) then
			CTA_IconMsg( "Message received from "..arg2 );
			if( arg2 and arg2 == UnitName("PLAYER") ) then
				return;
			end
		end
		if (strsub(event, 1, 16) ~= "CHAT_MSG_WHISPER" or strsub(arg1, 1, 5) ~= "/cta " ) then
			if( not CTA_MainFrame:IsVisible() or not string.find( arg1, "Away from Keyboard") ) then
				old_ChatFrame_OnEvent(event);
			end
		end
	end
	
	--Hook into WhoList
	local old_WhoList_Update = WhoList_Update;
	function WhoList_Update()
		if( not CTA_WhoBlock ) then
			old_WhoList_Update();
		end
	end
end

function CTA_SlashHandler(com)
	if( not com or  com=="" ) then
		CTA_Println( CTA_CALL_TO_ARMS.." "..CTA_RELEASEVERSION );
		CTA_Println( CTA_RELEASENOTE );		
		CTA_Println( CTA_COMMANDS..": "..CTA_HELP.." | "..CTA_TOGGLE.." | "..CTA_DEFAULT_CHANNEL.." | "..CTA_SET_CHANNEL.." "..CTA_CHANNEL_NAME.." | "..CTA_CLEAR_BLACKLIST.." | "..CTA_DISSOLVE_RAID );
		return;
	end

	if( com==CTA_HELP ) then
		CTA_Println( CTA_TOGGLE..": "..CTA_TOGGLE_HELP );
		CTA_Println( CTA_DEFAULT_CHANNEL..": "..CTA_DEFAULT_CHANNEL_HELP );
		CTA_Println( CTA_SET_CHANNEL.." "..CTA_CHANNEL_NAME..": "..CTA_SET_CHANNEL_HELP );
		CTA_Println( CTA_CLEAR_BLACKLIST..": "..CTA_CLEAR_BLACKLIST_HELP );
		CTA_Println( CTA_DISSOLVE_RAID..": "..CTA_DISSOLVE_RAID_HELP );
		return;
	end

	if( com==CTA_TOGGLE ) then
		if( CTA_MyMainFrame:IsVisible() ) then
			CTA_MyMainFrame:Hide();
		else
			CTA_MyMainFrame:Show();
		end
		return;
	end
	
	if( com==CTA_DEFAULT_CHANNEL ) then
		LeaveChannelByName( CTA_RAID_CHANNEL );	
		CTA_RAID_CHANNEL = CTA_DEFAULT_RAID_CHANNEL;
		JoinChannelByName( CTA_RAID_CHANNEL );
		CTA_IconMsg( CTA_QUERY_CHANNEL_IS.." \'"..CTA_RAID_CHANNEL.."\'" );
		return;
	end	
	
	if( com==CTA_CLEAR_BLACKLIST ) then
		CTA_BlackList = {};
		CTA_ChannelSpam = {};		
		CTA_IconMsg( CTA_BLACKLIST_CLEARED );
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
	
	for channelName in string.gfind( com, CTA_SET_CHANNEL.." (%w+)" ) do 
		local score = CTA_SearchScore( channelName, CTA_IllegalChannelWords );
		if( score == 0 ) then
			LeaveChannelByName( CTA_RAID_CHANNEL );
			CTA_RAID_CHANNEL = channelName;
			JoinChannelByName( CTA_RAID_CHANNEL );
			CTA_IconMsg( CTA_QUERY_CHANNEL_IS.." \'"..CTA_RAID_CHANNEL.."\'" );
		else
			CTA_IconMsg( CTA_ILLEGAL_CHANNEL_NAME );
		end
		return;
	end		
end

function CTA_Channel()
	if( CTA_MainFrame:IsVisible() or CTA_MyRaidIsOnline ) then
		JoinChannelByName( CTA_RAID_CHANNEL );
	else
		LeaveChannelByName( CTA_RAID_CHANNEL );
	end
end



-- Event Handling --


function CTA_OnUpdate(arg1)
	CTA_UpdateTicker = CTA_UpdateTicker + arg1;
	if( CTA_UpdateTicker > 1 ) then
		if( CTA_SearchTimer > 0  ) then
			CTA_SearchTimer = CTA_SearchTimer - CTA_UpdateTicker;
			if( CTA_SearchTimer <= 0 ) then
				CTA_SearchButton:Enable();
				SearchTimer = 0;
			end
		end

		CTA_SpamTimer = CTA_SpamTimer + CTA_UpdateTicker;
		if( CTA_SpamTimer > 10 ) then
			CTA_ChannelSpam = {};
			CTA_SpamTimer = 0;
		end
				
		CTA_UpdateTicker = 0;
	end
end

function CTA_OnEvent()

	-- Listen for Invitation requests and Raid information
  	if ( event == "CHAT_MSG_WHISPER" ) then
		if( strsub(arg1, 1, 6) == "/cta A" ) then
			CTA_ReceiveRaidInfo( arg1, arg2 );
		elseif( CTA_MyRaidIsOnline and string.lower( strsub(arg1, 1, 8) ) == CTA_INVITE_MAGIC_WORD ) then
			CTA_ReceiveRaidInvitationRequest( arg1, arg2 );	
		end	
	end
	
	-- Listen for Raid queries
  	if ( CTA_MyRaidIsOnline and CTA_MyRaid and event == "CHAT_MSG_CHANNEL" ) then
  		
  		if( arg9 == CTA_RAID_CHANNEL and strsub(arg1, 1, 6) == "/cta Q" ) then
  			
  			if( CTA_BlackList[arg2] == nil ) then
	  			if( CTA_ChannelSpam[arg2] == nil ) then
	  				CTA_ChannelSpam[arg2] = 0;
	  			end
	  			CTA_ChannelSpam[arg2] = CTA_ChannelSpam[arg2] + 1;
	  			if( CTA_ChannelSpam[arg2] > 4 ) then
	  				SendChatMessage("[CTA] "..arg2.." "..CTA_WAS_BLACKLISTED, "WHISPER", "COMMON", arg2);	
	  				CTA_IconMsg( arg2.." "..CTA_WAS_BLACKLISTED );
					CTA_BlackList[arg2] = 1;
				else
					CTA_ReceiveRaidQuery( arg1, arg2 );			
	  			end
  			end	
		end		
  	end

  	-- Listen for raid changes
	if ( event == "RAID_ROSTER_UPDATE" and CTA_MyRaid ) then
		if ( not IsRaidLeader() ) then
			CTA_MyRaid = nil;
		 	CTA_MyRaidIsOnline = nil;
			CTA_SearchFrame:Show();
			CTA_MyRaidFrame:Hide();
			CTA_StartRaidFrame:Hide();		 	
		else		
			if( CTA_MyRaid.size < GetNumRaidMembers() ) then
				PlaySound("TellMessage");
			end
			
			CTA_MyRaid.size = GetNumRaidMembers();
			CTA_IconMsg( CTA_RAID_UPDATE.." "..CTA_MyRaid.size.." "..CTA_MEMBERS );
			CTA_MyRaidInstantUpdate();
		end
	end  	
	
	if ( event == "WHO_LIST_UPDATE" and CTA_MyRaid ) then
		name, guild, level, race, class, zone, group = GetWhoInfo(1);
		if( name and name == CTA_WhoName and CTA_MyRaid ) then
			if( level >= CTA_MyRaid.minLevel and string.find( CTA_GetClassString(CTA_MyRaid.classes),class) ) then
				InviteByName( name );
				CTA_IconMsg( CTA_INVITATION_SENT_TO.." "..name );
				SendChatMessage( CTA_GetText_INVITATION_SENT( name ), "WHISPER",  "COMMON", name );					
			else
				SendChatMessage( CTA_WRONG_LEVEL_OR_CLASS, "WHISPER", "COMMON", name );	
			end
		end
		SetWhoToUI(0);
		CTA_WhoBlock = nil;
	end  		
end

function CTAW( name )
	SetWhoToUI(1);
	CTA_WhoName = name;
	CTA_WhoBlock = 1;
	SendWho(name);
end



-- Main User Interface Function Calls -- 

function CTA_ShowSearchFrame()
	CTA_MainFrame:Show();
	CTA_Channel();						
	CTA_SearchFrame:Show();
	CTA_MyRaidFrame:Hide();
	CTA_StartRaidFrame:Hide();
end

function CTA_ShowMyRaidFrame() 
	CTA_Channel();						
	CTA_MainFrame:Show();
	CTA_SearchFrame:Hide();
	
	if( not CTA_MyRaid ) then
		CTA_MyRaid = {};
	 	CTA_SetRaidInfo( CTA_MyRaid,  UnitName( "PLAYER" ), 100, "", CTA_RAID_TYPE_PVE, GetNumRaidMembers(), 40, 1, 255, 0, CTA_GetTime(), 0 );	
	 	CTA_MyRaidIsOnline = 1;
	end	
	
	CTA_MyRaidFrameDescriptionEditBox:SetText(""..CTA_MyRaid.comment);
	
	local myRaidType = CTA_MyRaid.type;
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

	CTA_MyRaidInstantUpdate(); --CTA_AcidUpdate(); 
	CTA_MyRaidFrame:Show();
	CTA_StartRaidFrame:Hide();
end

function CTA_ShowStartRaidFrame() 
	CTA_MainFrame:Show();
	CTA_SearchFrame:Hide();
	CTA_StartRaidFrame:Show();
	CTA_MyRaidFrame:Hide();

	if ( IsRaidLeader() and GetNumRaidMembers()>0 ) then
		CTA_ShowMyRaidFrame();
	else
		CTA_StartRaidButton:Disable();
		local text = CTA_PLAYER_NOT_LEADER_OR_RAID_OR_PARTY;
		if ( IsPartyLeader() ) then
			text = CTA_PLAYER_IS_PARTY_LEADER;
			CTA_StartRaidButton:Enable();
		end		
		if ( GetNumRaidMembers() > 0 ) then
			text = CTA_PLAYER_IS_RAID_MEMBER_NOT_LEADER;
		end			
		CTA_StartRaidLabel:SetText( text );	
	end						
end

function CTA_StartRaid() -- Called by CTA_StartRaidButton Button
	if( IsPartyLeader() ) then
		ConvertToRaid();
		CTA_StartRaidFrame:Hide();
		CTA_ShowMyRaidFrame();
	end
end

function CTA_StartRaidSearch() -- Called by CTA_SearchButton 
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
		showMinLevel = UnitLevel("PLAYER");
	else
		showMinLevel = 60; 
	end
	
	CTA_SelectedResultListItem = 0;
	CTA_RequestInviteButton:Disable();
	
	CTA_SendRaidQuery( keywords, showClasses, showEmpty, showFull, showPVP, showPVE, showProtected, showMinLevel );
end	
							
function CTA_MyRaidInstantUpdate() -- Called by CTA_MyRaidFrame Components
	if( CTA_MyRaid == nil ) then return; end
	
	local myName = UnitName( "PLAYER" );
	
	local myComment = CTA_SafeSet( CTA_MyRaidFrameDescriptionEditBox:GetText(), CTA_NO_DESCRIPTION );
	
	local myRaidType = CTA_RAID_TYPE_PVE;
	if( CTA_MyRaidFramePVPCheckButton:GetChecked() ) then
		myRaidType = CTA_RAID_TYPE_PVP;
	end
	
	local mySize = GetNumRaidMembers();
	if( not mySize ) then
		mySize = 0;
	end

	CTA_AcidUpdate();		
	
	local myMaxSize = CTA_SafeSetNumber( CTA_MyRaidFrameMaxSizeEditBox:GetText(), 5, 40 ); 
	if( not myMaxSize ) then
		CTA_MyRaidFrameMaxSizeEditBox:SetText( CTA_MyRaid.maxSize );
		myMaxSize = CTA_MyRaid.maxSize;
	end
	
	local myMinLevel = CTA_SafeSetNumber( CTA_MyRaidFrameMinLevelEditBox:GetText(), 1, 60 ); 
	if( not myMinLevel ) then
		CTA_MyRaidFrameMinLevelEditBox:SetText( CTA_MyRaid.minLevel );
		myMinLevel = CTA_MyRaid.minLevel;
	end

	local myClasses = 0; 	-- FOR ACID IMPLEMENTATION 
	if( CTA_Acid0.cur < CTA_Acid0.val ) then
		myClasses = 255;
	else
		local num = 1;
		local b = 1;
		while( num < 9 ) do
			local item = getglobal( "CTA_Acid"..num );
			if( item.cur < item.val ) then
				myClasses = myClasses + b;
			end
			b = b * 2;			
			num = num + 1;
		end	
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
	
	
	local myName = UnitName("PLAYER");
	local myTime = CTA_MyRaid.creationTime;
	local myOptions = 0;
	
 	CTA_SetRaidInfo( CTA_MyRaid, myName, 100, myComment, myRaidType, mySize, myMaxSize, myMinLevel, myClasses, myUsePassword, myTime, myOptions );	
end	




-- Send/Receive Invitation Request --

function CTA_SendPasswordRaidInvitationRequest()
	local raid = CTA_RaidList[ CTA_SelectedResultListItem ];
	local password = CTA_SafeSet( CTA_JoinRaidPasswordEditBox:GetText(), "" );
	if( password ~= "" ) then
		SendChatMessage( CTA_INVITE_MAGIC_WORD.." "..password, "WHISPER",  "COMMON", raid.leader );	
		CTA_JoinRaidWindow:Hide();
		CTA_SearchFrame:Show();
	end
end

function CTA_SendRaidInvitationRequest()
	local raid = CTA_RaidList[ CTA_SelectedResultListItem ];
	CTA_JoinRaidWindow:Hide();
	
	if( raid.passwordProtected == 1 ) then
		CTA_JoinRaidLabel:SetText( CTA_GetText_PASSWORD_REQURED_TO_JOIN( raid.leader ) );
		CTA_JoinRaidWindow:Show();
		CTA_SearchFrame:Hide();
	else
		SendChatMessage(CTA_INVITE_MAGIC_WORD, "WHISPER",  "COMMON", raid.leader);			
	end
end

function CTA_ReceiveRaidInvitationRequest( msg, author )
	if( CTA_MyRaid.size < CTA_MyRaid.maxSize ) then
		if( CTA_MyRaid.passwordProtected==1 ) then
			local password = string.sub( msg, 9 );
			for word in string.gfind( password, "([^%s]+)" ) do -- password revision, under review
				--CTA_Println( word );
				password = word;
			end
			
			if( password and password==CTA_MyRaidPassword ) then
				CTAW( author );
			else
				SendChatMessage(CTA_GetText_INCORRECT_PASSWORD( CTA_MyRaid.leader ), "WHISPER",  "COMMON", author);			
			end
		else
			CTAW( author );
		end
	else
		SendChatMessage(CTA_GetText_NO_SPACE( CTA_MyRaid.leader ), "WHISPER",  "COMMON", author);	
	end
end




-- Send/Receive Query --


function CTA_SendRaidQuery( keywords, showAllClasses, showEmpty, showFull, showPVP, showPVE, showProtected, showMinLevel )
	local size = 0;
	if( showEmpty==1 ) then size = size + 1; end 
	if( showFull==1 ) then size = size + 2; end
	
	local type = 0;
	if( showPVP==1 ) then type = type + 1; end
	if( showPVE==1 ) then type = type + 2; end
	
	type = type + (showProtected*3);
	
	local clevel = showMinLevel;
	if( clevel < 10 ) then
		clevel = "0"..clevel;
	end
	
	CTA_ClearRaidList();
	CTA_UpdateResults();
	CTA_SearchButton:Disable();
	CTA_SearchTimer = 5;
	CTA_ResultsListOffset = 0;
	CTA_SelectedResultListItem = 0;	
	SendChatMessage("/cta Q k<"..keywords..">c<"..showAllClasses..type..size..clevel..">", "CHANNEL",  "COMMON", GetChannelName( CTA_RAID_CHANNEL ) );
end

function CTA_ReceiveRaidQuery( query, author )
	for keywords, code in string.gfind( query, "/cta Q k<(.+)>c<(%d+)>" ) do 
		local class = tonumber( string.sub( code, 1, 1 ) );
		local type = tonumber( string.sub( code, 2, 2 ) );
		local size = tonumber( string.sub( code,  3, 3 ) );
		local minLevel = tonumber( string.sub( code,  4, 5 ) );	
		
		local protected = 0;
		if( type > 3 ) then 
			protected = 1;
			type = type-3;
		end
		
		if( class > 0 and CTA_CheckClasses( CTA_MyRaid.classes, class ) == 0 ) then return; end
		
		if( size == 2 and CTA_MyRaid.size <= 5 ) then return; end
		if( size == 1 and CTA_MyRaid.size == CTA_MyRaid.maxSize ) then return; end
		if( size == 0 and ( CTA_MyRaid.size <= 5 or CTA_MyRaid.size == CTA_MyRaid.maxSize ) ) then return; end
		
		if( type == 2 and CTA_MyRaid.type == CTA_RAID_TYPE_PVP ) then return; end
		if( type == 1 and CTA_MyRaid.type == CTA_RAID_TYPE_PVE ) then return; end
		
		if( protected == 0 and CTA_MyRaidPassword ) then return; end
		if( minLevel < CTA_MyRaid.minLevel ) then return; end
		
		local score = 100;
		if( keywords and keywords~="*" ) then
			score = CTA_SearchScore( CTA_MyRaid.leader.." "..CTA_MyRaid.comment, keywords );
			if( score == 0 ) then return; end
		end

		CTA_SendRaidInfo( author, score );
	end
end




-- Send/Receive Info --


function CTA_ReceiveRaidInfo( raidInfo, author )
	for score, class, size, max, com, type, min, pro, tim, opt in string.gfind( raidInfo, "/cta A s<(%d+)>c<(%d+)>s<(%d+)>m<(%d+)>c<(.+)>t<(%d+)>m<(%d+)>p<(%d+)>t<(.+)>o<(.+)>" ) do 		
		CTA_AddRaid( author, score, com, type, size, max, min, class, pro, tim, opt );
	end
end

function CTA_SendRaidInfo( playerName, sco )
	local myName = UnitName( "PLAYER" );
	local myRaid = CTA_MyRaid;
	local com = myRaid.comment;
	local typ = myRaid.type;
	local siz = myRaid.size;
	local max = myRaid.maxSize;
	local min = myRaid.minLevel;
	local cla = myRaid.classes;	
	local pro = myRaid.passwordProtected;
	local opt = myRaid.options;		
	local tim = myRaid.creationTime;
	SendChatMessage("/cta A s<"..sco..">c<"..cla..">s<"..siz..">m<"..max..">c<"..com..">t<"..typ..">m<"..min..">p<"..pro..">t<"..tim..">o<"..opt..">", "WHISPER",  "COMMON", playerName);
end




-- Raid List Operations --


function CTA_SetRaidInfo( raid, name, score, comment, type, size, maxSize, minLevel, classes, passwordProtected, creationTime, options )
	raid.leader = name;
	raid.score = tonumber(score);	
	raid.comment = comment;
	raid.type = tonumber(type);
	raid.size = tonumber(size);
	raid.maxSize = tonumber(maxSize);
	raid.minLevel = tonumber(minLevel);
	raid.classes = tonumber(classes);
	raid.passwordProtected = tonumber(passwordProtected);
	raid.creationTime = creationTime;
	raid.options = options;
end

function CTA_AddRaid( name, score, comment, type, size, maxSize, minLevel, classes, passwordProtected, creationTime, options )
	local index = CTA_GetRaidListPosition( name );
	CTA_RaidList[index] = {};
	CTA_SetRaidInfo( CTA_RaidList[index], name, score, comment, type, size, maxSize, minLevel, classes, passwordProtected, creationTime, options )
	if( index > CTA_RaidListLength ) then CTA_RaidListLength = CTA_RaidListLength + 1; end
	CTA_UpdateResults();
end

function CTA_GetRaidListPosition( name )
	local index = 1;
	while( index <= CTA_RaidListLength ) do
		if( CTA_RaidList[index].leader == name ) then
			return index;
		end
		index = index + 1;
	end
	return index;
end

function CTA_ClearRaidList()
	CTA_RaidList = {};
	CTA_RaidListLength = 0;
end




-- Results --

function CTA_UpdateResults()
	local index = 1;
	if( CTA_Header ) then
		CTA_HeaderNameLabel:SetText( CTA_HEADER_RAID_DESCRIPTION );
		CTA_HeaderTypeLabel:SetText( CTA_HEADER_TYPE );
		CTA_HeaderSizeLabel:SetText( CTA_HEADER_SIZE );
		CTA_HeaderMinLevelLabel:SetText( CTA_HEADER_MIN_LEVEL );
		CTA_HeaderPasswordLabel:Hide(); 
	
		if( CTA_RaidListLength > 1 ) then 
			CTA_ResultsLabel:SetText( CTA_RESULTS_FOUND.." "..CTA_RaidListLength.." "..CTA_RAIDS );
		else
			CTA_ResultsLabel:SetText( CTA_RESULTS_FOUND.." "..CTA_RaidListLength.." "..CTA_RAID );
		end
	end
	if( CTA_RaidListLength > 0 ) then
		CTA_PageLabel:Show();
		CTA_PageLabel:SetText( CTA_GetText_PAGE_N_OF_M( (CTA_ResultsListOffset/10)+1, floor(CTA_RaidListLength/10)+1 ) );
	else
		CTA_PageLabel:Hide();
	end
	
	while( index < 11 ) do
		local c = "CTA_NewItem"..index;
		if( getglobal( c ) ) then
			if( index+CTA_ResultsListOffset <= CTA_RaidListLength ) then 
				local raid = CTA_RaidList[index+CTA_ResultsListOffset];
				local typeText = CTA_PVP;
				local passwordText = CTA_NO;
				if( raid.type == CTA_RAID_TYPE_PVE ) then typeText = CTA_PVE; end
				if( raid.passwordProtected == 1 ) then passwordText = CTA_YES; end
				local name = CTA_GetText_LEADERS_RAID( raid.leader )..": "..raid.comment;
				
				local tex = getglobal( c.."Texture");
				local texR = getglobal( c.."TextureRed");
				local texG = getglobal( c.."TextureGreen");
				local myClass = UnitClass( "PLAYER" );
				
				
				if( raid.minLevel > UnitLevel("PLAYER") or not string.find(CTA_GetClassString(raid.classes),myClass)  ) then
					tex:Hide();
					texR:Show();
					texG:Hide();
				elseif( raid.passwordProtected == 1 ) then
					tex:Show();
					texR:Hide();
					texG:Hide();				
				else
					tex:Hide();
					texR:Hide();
					texG:Show();
				end
				
				if( CTA_SelectedResultListItem == index+CTA_ResultsListOffset ) then
					getglobal( c.."TextureSelected"):Show();
				else
					getglobal( c.."TextureSelected"):Hide();
				end
				
				getglobal( c ).raidId = index+CTA_ResultsListOffset;
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

function CTA_ListItemClicked( item )
	for value in string.gfind( item:GetName(), "CTA_NewItem(%d+)" ) do 
		if( CTA_SelectedResultListItem == CTA_ResultsListOffset + value ) then
			CTA_SelectedResultListItem = 0;
			CTA_RequestInviteButton:Disable();
		else
			CTA_SelectedResultListItem = CTA_ResultsListOffset + value;
			CTA_RequestInviteButton:Enable();
		end
		CTA_UpdateResults();
	end
end

function CTA_ShowListItemTooltip(item)
	GameTooltip:ClearLines();
	
	local raid = CTA_RaidList[getglobal(item:GetName()).raidId];
	GameTooltip:SetOwner( getglobal(item:GetName()), "ANCHOR_BOTTOMLEFT" );
	GameTooltip:ClearAllPoints();
	GameTooltip:SetPoint("BOTTOMLEFT", item:GetName(), "TOPLEFT", 0, 8);
	
	if( raid == nil ) then return; end

	GameTooltip:AddDoubleLine( CTA_RAID_LEADER..": "..raid.leader, ""..raid.score, 0.0, 0.9, 0.0, 0.9, 0.7, 0.0 );
	GameTooltip:AddLine( CTA_DESCRIPTION..": "..raid.comment );
	if( raid.classes == 255 ) then
		GameTooltip:AddLine( CTA_GetText_LFM_ANY_CLASS( (raid.maxSize-raid.size) ), 0.1, 0.9, 0.1 );	
	else 
		local myClass = UnitClass( "PLAYER" );
		local classList = CTA_GetClassString(raid.classes);
		if( string.find(classList, myClass) ) then
			GameTooltip:AddLine( CTA_GetText_LFM_CLASSLIST( (raid.maxSize-raid.size), classList ), 0.1, 0.9, 0.1 );	
		else
			GameTooltip:AddLine( CTA_GetText_LFM_CLASSLIST( (raid.maxSize-raid.size), classList ), 0.9, 0.1, 0.1 );	
		end
	end

	if( raid.minLevel <= UnitLevel("PLAYER") ) then
		GameTooltip:AddLine( CTA_MIN_LEVEL_TO_JOIN_RAID..": "..raid.minLevel, 0.1, 0.9, 0.1 );	
	else
		GameTooltip:AddLine( CTA_MIN_LEVEL_TO_JOIN_RAID..": "..raid.minLevel, 0.9, 0.1, 0.1 );	
	end	
	
	if( raid.passwordProtected == 1 ) then 
		GameTooltip:AddLine( CTA_RAID_REQUIRES_PASSWORD ); 
	end

	GameTooltip:AddDoubleLine( CTA_RAID_CREATED..": ", ""..raid.creationTime, 0.9, 0.9, 0.1, 0.1, 0.9, 0.1 );

	raid.type = tonumber(type);

	GameTooltip:Show();
end




-- Acid --


function CTA_ACID()
	local classes = { };
	classes[1] = CTA_PRIEST;
	classes[2] = CTA_MAGE;
	classes[3] = CTA_WARLOCK;
	classes[4] = CTA_DRUID;
	classes[5] = CTA_HUNTER;
	classes[6] = CTA_ROGUE;
	classes[7] = CTA_WARRIOR;
	classes[8] = CTA_PALADIN;
	classes[9] = CTA_SHAMAN;
	
	local num = 0;
	while( num < 9 ) do
		local item = getglobal( "CTA_Acid"..num );
		local class = getglobal( "CTA_Acid"..num.."ClassNameLabel" );
		
		if( num > 0 ) then
			if( UnitFactionGroup("PLAYER") ~= CTA_ALLIANCE and num==8 ) then
				class:SetText( classes[num+1] );
			else
				class:SetText( classes[num] );
			end				
			item.val = 0;
			item.cur = 0;
		else
			class:SetText( CTA_ANY_CLASS );
			item.val = CTA_MyRaid.maxSize;
			getglobal( "CTA_Acid"..num.."LessButton"):Hide();
			getglobal( "CTA_Acid"..num.."MoreButton"):Hide();			
		end
			
		num = num + 1;
	end

end

function CTA_AcidUpdate()
	if( not CTA_MyRaid ) then
		local num = 0;
		while( num < 9 ) do
			getglobal( "CTA_Acid"..num ):Hide();
			num = num + 1;
		end	
		return;
	end

	if( not CTA_Acid0.val ) then
		CTA_ACID();
	end
	
	local myOldMax = CTA_MyRaid.maxSize;
	local myMaxSize = CTA_SafeSetNumber( CTA_MyRaidFrameMaxSizeEditBox:GetText(), 5, 40 ); 
	if( not myMaxSize ) then
		myMaxSize = CTA_MyRaid.maxSize;
	else
		CTA_MyRaid.maxSize = tonumber(myMaxSize);
	end
	CTA_MyRaidFrameMaxSizeEditBox:SetText(""..myMaxSize);
	
	if( myMaxSize ~= myOldMax ) then
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
			CTA_Println( "CTA cval too high... adjusting" );
			local item = getglobal( "CTA_Acid"..num );
			if( item.val > 0 ) then
				item.val = item.val - 1;
				cval = cval - 1;
			else
				num = num + 1;
			end
		end
	end
	
	local num = 0;
	while( num < 9 ) do
		local item = getglobal( "CTA_Acid"..num );
		item.cur = 0;
		num = num + 1;
	end	
	
	num = 1;
	local numRaidMembers = GetNumRaidMembers();
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local over = 0;
	while ( num <= numRaidMembers ) do	
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(num);
		local index = CTA_GetClassCode(class);
		local item = getglobal( "CTA_Acid"..index );
		item.cur = item.cur + 1;
		if( item.cur > item.val ) then over = over + 1; end
		num = num+1;
	end	
	CTA_Acid0.cur = over;
	
	num = 0;
	local ant = "ACID ("..CTA_MyRaid.maxSize..") LFM: ";
	while( num < 9 ) do
		local item = getglobal( "CTA_Acid"..num );
		item:Show();
		local percent = getglobal( "CTA_Acid"..num.."ClassPercentLabel" );
		local current = getglobal( "CTA_Acid"..num.."ClassAbsoluteLabel" );
		local absolute = getglobal( "CTA_Acid"..num.."ClassCurrentLabel" );
		local percentTex = getglobal( "CTA_Acid"..num.."PercentTexture" );
		local currentTex = getglobal( "CTA_Acid"..num.."CurrentTexture" );

		local pval = floor(80*item.val/CTA_MyRaid.maxSize);
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
		local cpval = floor(80*cval/CTA_MyRaid.maxSize);
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
		if( lfm < 0 ) then lfm = 0; end
		if( num == 0 ) then
			ant = ant..(lfm).." of "..getglobal( "CTA_Acid"..num.."ClassNameLabel" ):GetText()..", ";
		else
			ant = ant..(lfm).." "..getglobal( "CTA_Acid"..num.."ClassNameLabel" ):GetText();
			if( item.val ~= 1 ) then
				ant = ant.."s"		
			end
			if( num < 8 ) then
				ant = ant..", ";
			end
		end
							
		num = num + 1;
	end
	CTA_AcidNote:SetText( ant );
end

function CTA_AcidItemClick( btn )
	local item = getglobal( btn:GetParent():GetName() );
	if( string.find( btn:GetName(), "Less" ) ) then
		if( item.val > 0 ) then
			item.val = item.val - 1;
			CTA_Acid0.val = CTA_Acid0.val + 1;
		end
	else
		if( CTA_Acid0.val > 0 ) then
			item.val = item.val + 1;
			CTA_Acid0.val = CTA_Acid0.val - 1;
		end
	end
	CTA_MyRaidInstantUpdate();
end

function CTA_ShowAcidItemTooltip(item)
	GameTooltip:SetOwner( getglobal(item:GetName()), "ANCHOR_TOP" );
	GameTooltip:ClearLines();
	GameTooltip:ClearAllPoints();
	GameTooltip:SetPoint("TOPLEFT", item:GetName(), "BOTTOMLEFT", 0, -8);	
		
	local acidItem = getglobal(item:GetName());
	local className = getglobal(item:GetName().."ClassNameLabel"):GetText();	
	GameTooltip:AddLine( className );
	local needed = acidItem.val - acidItem.cur;
	if( needed < 0 ) then needed = 0; end
	
	if( item:GetName() == "CTA_Acid0" ) then
		GameTooltip:AddDoubleLine( CTA_MAXIMUM_PLAYERS_ALLOWED..":", ""..item.val );
		GameTooltip:AddDoubleLine( CTA_PLAYERS_IN_RAID..":", ""..item.cur );
		GameTooltip:AddDoubleLine( CTA_NUMBER_OF_PLAYERS_NEEDED..":", ""..needed );
		GameTooltip:AddLine( CTA_ANY_CLASS_TOOLTIP, 1, 1, 1, 1, 1 );		
	else
		GameTooltip:AddDoubleLine( CTA_MINIMUM_PLAYERS_WANTED..":", ""..item.val );
		GameTooltip:AddDoubleLine( CTA_PLAYERS_IN_RAID..":", ""..item.cur );
		GameTooltip:AddDoubleLine( CTA_NUMBER_OF_PLAYERS_NEEDED..":", ""..needed );
		GameTooltip:AddLine( CTA_GetText_CLASS_TOOLTIP( className ), 1, 1, 1, 1, 1 );				
	end
	
	GameTooltip:Show();
end




-- Other Functions Not Yet Categorized In Code --


--	Searches a specified String (source) for a keyword String (search)
--	String patterns are not allowed - simple search keywords are used
--	Returns a number representing the degree to which the search string 
--	was found in the specified string using a custom scoring system.
--	Number ( 0 - 100 )
--
function CTA_SearchScore( source, search )
	local ad = string.lower( source );
	local query = string.lower( search );
				
	if( string.find( ad, query ) ) then
		return 100;
	else			
		local score = 0;
		local total = 0;
		for word in string.gfind(query, "%w+") do
			total = total + 1;
			if( string.find( ad, word ) ) then
				score = score + 1;
			end
		end
		
		if( score > 0 ) then 
			return floor(99*score/total);	
		else
			return 0;
		end
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
function CTA_ShowError( title, text, buttonText )
	CTA_ErrorWindowTitleLabel:SetText( title );
	CTA_ErrorWindowErrorLabel:SetText( text );
	CTA_ErrorWindowCloseButton:SetText( buttonText );
	CTA_ErrorWindow:Show();
end


--	Returns the class code for this player.
--	Number ( 1 - 8 )
--
function CTA_MyClassCode()
	local myClass = UnitClass("PLAYER");
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
	classes[CTA_SHAMAN] = 9;
	
	local val = classes[name];
	if( val == 9 ) then val = 8; end
	return val;
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
	classes[8] = CTA_PALADIN;
	classes[9] = CTA_SHAMAN;
	
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
function CTA_ShowTooltip(item)
	GameTooltip:SetOwner( getglobal(item:GetName()), "ANCHOR_TOP" );
	GameTooltip:ClearLines();
	GameTooltip:ClearAllPoints();
	GameTooltip:SetPoint("TOPLEFT", item:GetName(), "BOTTOMLEFT", 0, -2);		
	GameTooltip:AddLine( CTA_Strings[item:GetName()].tooltip1 );
	GameTooltip:AddLine( CTA_Strings[item:GetName()].tooltip2, 1, 1, 1, 1, 1 );
	GameTooltip:Show();
end




-- DEBUG / PROVING GROUNDS--


function CTA_PositionIcon() -- crashes!

	local screenHeight = GetScreenHeight();
	local screenWidth = (screenHeight*4)/3;	-- for most resolutions...
	
	local x = CTA_MyMainFrame:GetLeft();
	local y = CTA_MyMainFrame:GetTop();
	
	--CTA_IconMsg( ": "..x..", "..y.." / "..screenWidth..", "..screenHeight ); -- ok
	
	-- code below causes crash
	if( x < screenWidth/2 ) then
		CTA_InfoLabel:SetJustifyH("LEFT")
		CTA_InfoLabel:SetPoint("LEFT", getglobal("CTA_MyMainFrame"):GetName(), "RIGHT", 0, 0);
		CTA_MessageFrame:SetPoint("LEFT", getglobal("CTA_MyMainFrame"):GetName(), "RIGHT", 0, 0);
	else
		CTA_InfoLabel:SetJustifyH("RIGHT")
		CTA_InfoLabel:SetPoint("RIGHT", getglobal("CTA_MyMainFrame"):GetName(), "LEFT", 0, 0);
		CTA_MessageFrame:SetPoint("RIGHT", getglobal("CTA_MyMainFrame"):GetName(), "LEFT", 0, 0);
	end
end

function CTA_DissolveRaid()
	CTA_IconMsg( CTA_DISSOLVING_RAID );
	num = 1;
	local numRaidMembers = GetNumRaidMembers();
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local over = 0;
	while ( num <= numRaidMembers ) do	
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(num);
		if( name ~= UnitName("PLAYER") ) then
			UninviteByName( name );
			SendChatMessage( CTA_DISSOLVING_THE_RAID_CHAT_MESSAGE, "WHISPER",  "COMMON", name);					
		end
		num = num+1;
	end	
	CTA_IconMsg( CTA_RAID_DISSOLVED );
end

function CTA_Error( s )
	UIErrorsFrame:AddMessage(s, 0.75, 0.75, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function CTA_Println( s )
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( s, 1, 1, 0.5);
	end		
end

function CTA_IconMsg( s )
	if( CTA_MessageFrame ) then
		CTA_InfoLabel:Hide();
		CTA_MessageFrame:Show();
		--PlaySound("TellMessage");

		CTA_MessageFrame:AddMessage(s, 1, 1, 1, 1.0, UIERRORS_HOLD_TIME);
		--CTA_Println( s );
	end		
end



-- TRASH --

