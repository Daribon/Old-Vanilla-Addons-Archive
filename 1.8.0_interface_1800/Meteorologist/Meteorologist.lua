--------------------------------------------------------------------------
-- Meteorologist.lua 
--------------------------------------------------------------------------
--[[
Meteorologist

-Color Sky users in FriendsFrame
-Track Sky Channels by SkyCloud Icon and menu.
-Track Sky Addons (and the Sky addons of other Meteorologist users) by SkyCloud menu.

By: AnduinLothar    <karlkfi@cosmosui.org>

Change Log:
	v1.0 (2/19/05)
		-Initial Rerelease in addon form.
		-Added Friend color change to blue for Sky users
	v1.1 (2/23/05)
		-Now shows what players are using Sky with a Cloud Icon.
		-Icon Mouseover shows what Sky channels they're in.
	v1.2 (3/5/05)
		-Changed Raid colors: Mage is now teal and Sky users' _names_ are blue.
		-Made all Sky users the same color blue
		-Changed tooltip to menu (Earth) with options to join/leave each sky channel
	v1.3 (3/6/05)
		-Added sky registering of addons to display in menu.
	v1.4 (3/11/05)
		-spelling error
		-changed addon registration format
	v1.5 (3/26/05)
		-Modified Chat Tab channel menus.
		-Filter -> Channels menu no longer shows sky channels.
		-"Join New Channel" menu now show all joined non-sky channels as well as the 5 default server channels.
		It also uses Sky commands on click so you can now correctly see what channels you are in and join/leave them
		by clicking on that channel in the menu.
		-Modified SkyCloud Menu to show warnings and join/leave messages
	v1.51
		-Fixed raid sky coloring
	v1.6
		-Optimized addon requests and sendign to cut down on Sky spam.
		-Minimzed excessive mailbox checking
	v1.7
		-Added "/Sky <username>" for checking if a user is a known Sky user
	v1.8
		-Fixed sky cloud icon not being hidden properly, so it appeared on mobs and player targets that don't have sky.
		-Updated TOC to 1700
	v1.9
		-Added option to auto join the Sky channel when you log in or reload. (default enabled)
		

	$Id: Meteorologist.lua 2582 2005-10-11 18:10:24Z sarf $
	$Rev: 2582 $
	$LastChangedBy: sarf $
	$Date: 2005-10-11 13:10:24 -0500 (Tue, 11 Oct 2005) $

]]--

RAID_CLASS_COLORS["MAGE"] = { r = 0.0, g = 1.0, b = 0.78 };
METEOROLOGIST_SKY_BLUE = { r = 0.0, g = 0.42, b = 1.0 };
Meteorologist_MenuOptions = {};
Meteorologist_RegisteredAddonUsers = {};
Meteorologist_RegisteredAddons = {};
Meteorologist_OutstandingAddonRequests = {};
METEOROLOGIST_ALERT_ID = "MS";
METEOROLOGIST_MAX_MAIL_CHECKS = 3; --number of checks before it gives up on a sky user not using meteor'
METEOROLOGIST_MAIL_CHECK_INTERVAL = 4; --seconds between checks
METEOROLOGIST_MAIL_SEND_INTERVAL = 4; --overflow timer. only send addon list every x seconds
METEOROLOGIST_ALERT_MSG_PREFIX = "Requesting Sky Addons from: " --used by sky alerts, user never sees it.
METEOROLOGIST_DEBUG = false;

ServerChannelList = {};
Meteorologist_AutoJoin = {};

local Meteorologist_RaidUI_Loaded = false;

function Meteorologist_OnLoad()
	
	if ( IsAddOnLoaded("Blizzard_RaidUI") ) then
		Meteorologist_RaidUI_Loaded = true;
	else
		Sea.util.hook("RaidFrame_LoadUI", "Meteorologist_RaidFrame_LoadUI", "after");
	end

	Sea.util.hook( "WhoList_Update", "Meteorologist_WhoList_Update", "after" );
	Sea.util.hook( "GuildStatus_Update", "Meteorologist_GuildStatus_Update", "after" );
	Sea.util.hook( "FriendsList_Update", "Meteorologist_FriendsList_Update", "after" );
	Sea.util.hook( "GuildPlayerStatus_Update", "Meteorologist_GuildPlayerStatus_Update", "after" );
	Sea.util.hook( "RaidFrame_Update", "Meteorologist_RaidFrame_Update", "after" );

	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	
	Meteorologist_RegisterForSkyMessages();
	Meteorologist_TrackSkyUsers();
	
	-- Register the SkyUser Command
	Sky.registerSlashCommand(
		{
			id="SkyUser";
			commands = METEOROLOGIST_SKY_USER_COMMANDS;
			onExecute = function(msg) 
				if ((not msg) or (msg == "")) and (UnitName("target")) then
					msg = UnitName("target")
				end
				if (Sky.isSkyUser(msg)) then
					Sea.io.printc(METEOROLOGIST_SKY_BLUE, string.format(METEOROLOGIST_SKY_USER_HAVE, msg));
				else
					Sea.io.printc(METEOROLOGIST_SKY_BLUE, string.format(METEOROLOGIST_SKY_USER_DONTHAVE, msg));
				end
			end;
			helpText = METEOROLOGIST_SKY_USER_HELP;
		}
	);
	
	Chronos.afterInit(
		function()
			if (Meteorologist_AutoJoin[GetRealmName()]) and (not Sky.isChannelActive(SKY_CHANNEL)) then
				JoinChannelByName(SKY_CHANNEL);
			end
		end
	)
	
end

function Meteorologist_RaidFrame_LoadUI()
	if ( IsAddOnLoaded("Blizzard_RaidUI") ) then
		Meteorologist_RaidUI_Loaded = true;
		Sea.util.unhook("RaidFrame_LoadUI", "Meteorologist_RaidFrame_LoadUI", "after");
	end
end



function Meteorologist_OnEvent(event)
	local partyIndex;
	if (event == "VARIABLES_LOADED") then
		if (Meteorologist_AutoJoin[GetRealmName()] == nil) then
			--Default to auto-join
			Meteorologist_AutoJoin[GetRealmName()] = true;
		end
		--if (Meteorologist_AutoJoin[GetRealmName()]) and (not Sky.isChannelActive(SKY_CHANNEL)) then
		--	JoinChannelByName(SKY_CHANNEL);
		--end
		Meteorologist_UpdatePlayerSkyIcon();
		if (GetNumPartyMembers() > 0) then
			Meteorologist_UpdatePartyMembersSkyIcons();
		end
		
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		if (GetNumPartyMembers() > 0) then
			Meteorologist_UpdatePartyMembersSkyIcons();
		end
	elseif (event == "PARTY_MEMBER_ENABLE") then
		if (GetNumPartyMembers() > 0) then
			partyIndex = Meteorologist_PartyIndexFromName(arg1);
			if partyIndex then
				Meteorologist_UpdatePartyMemberSkyIcon(partyIndex);
			end
		end
	elseif (event == "PARTY_MEMBER_DISABLE") then
		if (GetNumPartyMembers() > 0) then
			partyIndex = Meteorologist_PartyIndexFromName(arg1);
			if partyIndex then
				Meteorologist_UpdatePartyMemberSkyIcon(partyIndex);
			end
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		Meteorologist_UpdateTargetSkyIcon();
	end
end


-- <= == == == == == == == == == == == == =>
-- => Sky Addon Registration
-- <= == == == == == == == == == == == == =>


function Meteorologist_RegisterAddon( addonName, callback )
	--calls callback(unit) when u click on the option in the SkyCloud Menu
	if (not UnitName("player")) then
		Chronos.afterInit( Meteorologist_RegisterAddon, addonName, callback );
		return;
	end
	Meteorologist_RegisteredAddons[addonName] = {func = callback};
	if (not Meteorologist_RegisteredAddonUsers[UnitName("player")]) then
		Meteorologist_RegisteredAddonUsers[UnitName("player")] = {};
	end
	Meteorologist_RegisteredAddonUsers[UnitName("player")][addonName] = true;
	
	Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon Registered: " .. addonName );
end


function Meteorologist_RegisterForSkyMessages()
	
	Sky.registerMailbox( 
		{
			id = "Meteorologist",
			events = { SKY_CHANNEL },
			acceptTest = Meteorologist_SkyAcceptanceTest,
		}
	);
	
	Sky.registerAlert (
		{
			id = METEOROLOGIST_ALERT_ID, 
			func = Meteorologist_SendAddonList, 
			description = "Meteorologist Addon Request Listener", 
		}
	);
	
end


function Meteorologist_SkyAcceptanceTest( envelope ) 
	
	if ( type(envelope.msg) == "table" ) and ( envelope.target == "Meteorologist" ) then
		Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Recieved - "..envelope.sender..":" );
		if (METEOROLOGIST_DEBUG) then
			Sea.IO.printTable(envelope.msg);
		end
		if (not Chronos.isScheduledByName("Meteorologist_CheckMail") ) then
			Chronos.scheduleByName("Meteorologist_CheckMail", METEOROLOGIST_MAIL_CHECK_INTERVAL, Meteorologist_CheckSkyMailbox);
		end
		return true;
	else
		return false;
	end
end


function Meteorologist_SendAddonList( msg, sender, channel, timeRecieved )
	
	Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Alert Recieved - " .. sender .. ": " .. msg);
	Sea.io.dprint("METEOROLOGIST_DEBUG", msg);
	
	local minSize = string.len(METEOROLOGIST_ALERT_MSG_PREFIX);
	
	if (string.len(msg) >= minSize) then
		if ( strsub(msg, 0, minSize) ~= METEOROLOGIST_ALERT_MSG_PREFIX) then
			Sea.io.dprint("METEOROLOGIST_DEBUG", "incorrect prefix: \""..strsub(msg, 0, minSize).."\"");
			return;
		end
		if ( strsub(msg, minSize+1) ~= UnitName("player") ) then
			Sea.io.dprint("METEOROLOGIST_DEBUG", "alert not for you");
			return;
		end
	else
		Sea.io.dprint("METEOROLOGIST_DEBUG", "alert too short: "..string.len(msg).." < "..minSize);
		return;
	end
	
	if (sender == UnitName("player")) then
		--return;
	end
	
	--check spam timer
	if (not Chronos.isScheduledByName("Meteorologist_SendAddonListOverflowTimer")) then
		Chronos.scheduleByName("Meteorologist_SendAddonListOverflowTimer", METEOROLOGIST_MAIL_SEND_INTERVAL, function() end);
	end
	
	--get addon list
	local addonList = Sea.table.getKeyList(Meteorologist_RegisteredAddons);
	if (not addonList) then
		addonList = { };
	end
	
	--send addon list
	Sky.sendTable( addonList, SKY_CHANNEL, "Meteorologist" );
	
	Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Sent:" );
	if (METEOROLOGIST_DEBUG) then
		Sea.IO.printTable(addonList);
	end
	
end


function Meteorologist_InquireAboutSkyAddons(unit)
	local name = UnitName(unit);
	Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Inquiring About Addons: "..unit.. ": "..name);
	
	if ( UnitIsConnected(unit) ) then
		if (not Meteorologist_RegisteredAddonUsers[name]) then
			if ( Sky.isChannelActive(SKY_CHANNEL) ) then
				if (not Meteorologist_OutstandingAddonRequests[name]) then
					--ask unit for addon data
					Meteorologist_OutstandingAddonRequests[name] = GetTime();
					Sky.sendAlert(METEOROLOGIST_ALERT_MSG_PREFIX..name, SKY_CHANNEL, METEOROLOGIST_ALERT_ID);
					Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Alert Sent: Requesting Sky Addons from "..name);
					--set outstanding addon request timer
					Chronos.schedule(METEOROLOGIST_MAIL_CHECK_INTERVAL*METEOROLOGIST_MAX_MAIL_CHECKS+1, function(playername) Meteorologist_OutstandingAddonRequests[playername] = nil end, name);
					--set timer to check mailbox
					Chronos.scheduleByName("Meteorologist_CheckMail", METEOROLOGIST_MAIL_CHECK_INTERVAL, Meteorologist_CheckSkyMailbox, name);
				end
			else
				--ask player to join sky?
			end
		else
			Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Found in Memory: "..unit.. ": "..name);
		end
	elseif (Meteorologist_RegisteredAddonUsers[name]) then
		--erase recored on signoff
		Meteorologist_RegisteredAddonUsers[name] = nil;
		Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Found in Memory for Offline Player, Clearing Addon Info : "..unit.. ": "..name);
	end
	
end


function Meteorologist_CheckSkyMailbox(expectedSender)
	-- if expectedSender is nil it will only check once
	
	Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Checking mail..." );
	
	local mailTable = Sky.getAllMessages("Meteorologist");
	local sendAgain = true;
	
	if ( table.getn(mailTable) == 0 ) then
		Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Mailbox is Empty." );
	end
	
	for index, envelope in mailTable do
		Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Mail Read - "..envelope.sender..":" );
		if (METEOROLOGIST_DEBUG) then
			Sea.IO.printTable(envelope.msg);
		end
		--update Meteorologist_RegisteredAddonUsers
		if (not Meteorologist_RegisteredAddonUsers[envelope.sender]) then
			Meteorologist_RegisteredAddonUsers[envelope.sender] = { };
		end
		for index, value in envelope.msg do
			Meteorologist_RegisteredAddonUsers[envelope.sender][value] = true;
		end
		--check for expected sender
		if (envelope.sender == expectedSender) or (expectedSender == nil) then
			sendAgain = false;
		end
	end
	
	if (not Meteorologist_CurrentMailCheck) then
		Meteorologist_CurrentMailCheck = 0;
	end
	
	if (Meteorologist_CurrentMailCheck < METEOROLOGIST_MAX_MAIL_CHECKS) then
		if (sendAgain) then
			Meteorologist_CurrentMailCheck = Meteorologist_CurrentMailCheck + 1;
			Chronos.scheduleByName("Meteorologist_CheckMail", METEOROLOGIST_MAIL_CHECK_INTERVAL, Meteorologist_CheckSkyMailbox, expectedSender);
		else
			Meteorologist_CurrentMailCheck = nil;
		end
	else
		--Sky user probably not using Meteorologist
		Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Never Recieved: "..expectedSender.." is probably not a Meteorologist user." );
		Meteorologist_RegisteredAddonUsers[expectedSender] = { };
		Meteorologist_CurrentMailCheck = nil;
	end

end


-- <= == == == == == == == == == == == == =>
-- => ???
-- <= == == == == == == == == == == == == =>


function Meteorologist_PartyIndexFromName(name)
	for i=1, GetNumPartyMembers() do
		if ( name == UnitName("party"..i) ) then
			return i;
		end
	end
end


function Meteorologist_TrackSkyUsers()
	
	if ( not Sky.isHostingByID("SkyPartyWatch") ) then
		Sky.registerHostess( 
			{
				id = "SkyPartyWatch" ,
				callback = Meteorologist_SkyPartyWatchCallback,
				channels = { SKY_PARTY },
				description = "Whatches the SkyParty for join/leave messages.",
			}
			);
	end
	
	if ( not Sky.isHostingByID("SkyUserWatch") ) then
		Sky.registerHostess( 
			{
				id = "SkyUserWatch" ,
				callback = Meteorologist_SkyUserWatchCallback,
				channels = { SKY_CHANNEL },
				description = "Whatches the Sky for leave messages.",
			}
			);
	end
	
end

function Meteorologist_SkyPartyWatchCallback(action, actionData)

	local partyIndex;
	if ( action == SKY_PLAYER_JOIN ) then 
		Sea.io.dprint("METEOROLOGIST_DEBUG", actionData.username, " has joined Sky_Party" );
		partyIndex = Meteorologist_PartyIndexFromName(actionData.username);
		if partyIndex then
			Meteorologist_UpdatePartyMemberSkyIcon(partyIndex);
		end
	elseif ( action == SKY_PLAYER_LEAVE ) then
		Sea.io.dprint("METEOROLOGIST_DEBUG", actionData.username, " has left Sky_Party");
		partyIndex = Meteorologist_PartyIndexFromName(actionData.username);
		if partyIndex then
			Meteorologist_UpdatePartyMemberSkyIcon(partyIndex);
		end
	elseif ( action == SKY_CHANNEL_JOIN ) then
		if (actionData.channel == SKY_PARTY) then
			Sea.io.dprint("METEOROLOGIST_DEBUG", "You have joined Sky_Party");
			Meteorologist_UpdatePartyMembersSkyIcons();
			Meteorologist_UpdatePlayerSkyIcon();
		end	
	elseif ( action == SKY_CHANNEL_LEAVE ) then
		if (actionData.channel == SKY_PARTY) then
			Sea.io.dprint("METEOROLOGIST_DEBUG", "You have left Sky_Party");
			Meteorologist_UpdatePartyMembersSkyIcons();
			Meteorologist_UpdatePlayerSkyIcon();
		end	
	end
	
end

function Meteorologist_SkyUserWatchCallback(action, actionData)

	local partyIndex;
	if ( action == SKY_PLAYER_LEAVE ) then
		if (Meteorologist_RegisteredAddonUsers[actionData.username]) then
			--erase recored on signoff
			Meteorologist_RegisteredAddonUsers[actionData.username] = nil;
			Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Found in Memory for Offline Player, Clearing Addon Info : "..actionData.username);
		end
	elseif ( action == SKY_CHANNEL_LEAVE ) then
		if (actionData.channel == SKY_CHANNEL) then
			--erase all recored info when u leave sky
			Meteorologist_RegisteredAddonUsers = { };
			Sea.io.dprint("METEOROLOGIST_DEBUG", "Meteor' Addon List Wipe. (you left the sky channel)");
		end	
	end
	
end



function Meteorologist_WhoList_Update()
	
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame);
	local whoIndex;
	
	for i=1, WHOS_TO_DISPLAY do
		whoIndex = whoOffset + i;
		local name, guild, level, race, class, zone, group = GetWhoInfo(whoIndex);
		
		if ( Sky and name ) then
			if ( Sky.isSkyUser(name) ) then 
				getglobal("WhoFrameButton"..i.."Name"):SetTextColor(METEOROLOGIST_SKY_BLUE.r, METEOROLOGIST_SKY_BLUE.g, METEOROLOGIST_SKY_BLUE.b);
			else 
				getglobal("WhoFrameButton"..i.."Name"):SetTextColor(1.0, 0.82, 0.0);
			end
		end
	end
	
end


function Meteorologist_GuildStatus_Update()
	
	local guildOffset = FauxScrollFrame_GetOffset(GuildStatusScrollFrame);
	local guildIndex;
	
	for i=1, GUILDMEMBERS_TO_DISPLAY do
		guildIndex = guildOffset + i;
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(guildIndex);
		
		if ( online and name ) then
			if ( Sky.isSkyUser(name) ) then 
				getglobal("GuildFrameButton"..i.."Name"):SetTextColor(0.0, 0.32, 1.0);
			end
		end
	end
	
end


function Meteorologist_FriendsList_Update()
	
	local nameLocationText;
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	local friendIndex;
	
	for i=1, FRIENDS_TO_DISPLAY do
		friendIndex = friendOffset + i;
		local name, level, class, area, connected = GetFriendInfo(friendIndex);
		nameLocationText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextNameLocation");
		
		if ( connected and name ) then
			nameLocationText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
			if ( Sky.isSkyUser(name) ) then 
				nameLocationText:SetTextColor(METEOROLOGIST_SKY_BLUE.r, METEOROLOGIST_SKY_BLUE.g, METEOROLOGIST_SKY_BLUE.b);
			end
		end
	end
	
end


function Meteorologist_GuildPlayerStatus_Update()
	
	local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame);
	local guildIndex;
	
	for i=1, GUILDMEMBERS_TO_DISPLAY do
		guildIndex = guildOffset + i;
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(guildIndex);
		
		if ( online and name ) then
			if ( Sky.isSkyUser(name) ) then 
				getglobal("GuildFrameButton"..i.."Name"):SetTextColor(METEOROLOGIST_SKY_BLUE.r, METEOROLOGIST_SKY_BLUE.g, METEOROLOGIST_SKY_BLUE.b);
			end
		end
	end
	
end


function Meteorologist_RaidFrame_Update()
	if ( Meteorologist_RaidUI_Loaded ) then
		local name, rank, subgroup, level, class, fileName, zone, online ;
		
		for i=1, GetNumRaidMembers() do
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( online ) and ( Sky.isSkyUser(name) ) then
				raidGroup = getglobal("RaidGroup"..subgroup);
				if ( raidGroup.nextIndex <= MEMBERS_PER_RAID_GROUP + 1 ) then
					buttonName = getglobal("RaidGroupButton"..i.."Name");
					buttonName:SetVertexColor(METEOROLOGIST_SKY_BLUE.r, METEOROLOGIST_SKY_BLUE.g, METEOROLOGIST_SKY_BLUE.b);
				end
			end
		end
	end

end


function Meteorologist_UpdatePartyMemberSkyIcon(i)
    local name = UnitName("party"..i);
	local skyIcon = getglobal("PartyMemberFrame"..i.."SkyIcon");
	if ( skyIcon and name ) then
		if ( Sky.isSkyUser(name) ) then
			skyIcon:Show();
			
			Meteorologist_InquireAboutSkyAddons("party"..i);
			
		else    
			skyIcon:Hide();
		end
	end
end


function Meteorologist_UpdatePartyMembersSkyIcons()
	for i=1, GetNumPartyMembers() do
		Meteorologist_UpdatePartyMemberSkyIcon(i);
	end
end


function Meteorologist_UpdatePlayerSkyIcon()
    local name = UnitName("player");
	local skyIcon = getglobal("PlayerFrameSkyIcon");
	if ( skyIcon and name ) then
		skyIcon:Show();
		--[[
		if ( Sky.isSkyUser(name) ) then
			skyIcon:Show();
		else    
			skyIcon:Hide();
		end
		]]--
	end
end

function Meteorologist_UpdateTargetSkyIcon()
    local name = UnitName("target");
	local skyIcon = getglobal("TargetFrameSkyIcon");
	if ( skyIcon and name ) then
		if ( UnitIsPlayer("target") ) then
			if ( Sky.isSkyUser(name) ) then
				skyIcon:Show();
				
				Meteorologist_InquireAboutSkyAddons("target");
				
				return;
			end
		end
		skyIcon:Hide();
	end
end


function Meteorologist_SkyIcon_OnLoad()
	this:SetFrameLevel(this:GetFrameLevel()+2);
	this.texture = getglobal(this:GetName().."Texture");
	local id = this:GetID();
	if (id ~= 0) then
		this.unit = "party"..id;
	end
end

function Meteorologist_SkyIcon_OnEnter()
	this.texture:SetTexture("Interface\\AddOns\\Meteorologist\\Skin\\SkyCloudBlue");
	this.MouseIsOver = true;
	if (this.unit) then
		--Meteorologist_OpenMenu(this.unit);
		--[[
		local tooltip = Meteorologist_GetTooltip(this.unit);
		if (tooltip) then
			MeteorologistTooltip:SetOwner(this, "ANCHOR_RIGHT");
			MeteorologistTooltip:SetText(tooltip);
		else
			Meteorologist_UpdateUnitSkyIcon(this.unit)
		end
		]]--
	end
end

function Meteorologist_SkyIcon_OnLeave()
	this.texture:SetTexture("Interface\\AddOns\\Meteorologist\\Skin\\SkyCloud");
	this.MouseIsOver = false;
	if ( MeteorologistTooltip:IsOwned(this) ) then
		MeteorologistTooltip:Hide();
	end
end

function Meteorologist_SkyIcon_OnMouseDown()
	this.texture:SetTexture("Interface\\AddOns\\Meteorologist\\Skin\\SkyCloudBlueDown");
end

function Meteorologist_SkyIcon_OnMouseUp()
	if (this.MouseIsOver) then
		this.texture:SetTexture("Interface\\AddOns\\Meteorologist\\Skin\\SkyCloudBlue");
		if (this.unit) then
			Meteorologist_OpenMenu(this.unit);
		end
	end
end

function Meteorologist_PlayerFrameSkyIcon_OnLoad()
	this:ClearAllPoints();
	this:SetPoint("TOPLEFT", this:GetParent():GetName(),"BOTTOMLEFT", 58, 32);
	this.unit = "player";
	Meteorologist_SkyIcon_OnLoad(this);
end

function Meteorologist_TargetFrameSkyIcon_OnLoad()
	this:ClearAllPoints();
	this:SetPoint("BOTTOMRIGHT", this:GetParent():GetName(),"BOTTOMRIGHT", -90, 20);
	this.unit = "target";
	Meteorologist_SkyIcon_OnLoad(this);
end

function Meteorologist_Tooltip_OnLoad()
	this:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	this:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
end

function Meteorologist_GetTooltip(unit)
	local tooptipText = nil;
	if (unit) then
		if ( UnitIsPlayer(unit) ) then
			tooptipText = UnitName(unit)..METEOROLOGIST_SKY_CHANNELS
			local skyChannels = Sky.isSkyUser(UnitName(unit));
			if (type(skyChannels) == "table") then
				--list players channels
				for index, value in skyChannels do
					tooptipText = tooptipText..SKY_CHANNELLIST_PRETTYPRINT[value]..",";
				end
				--remove trailing comma
				tooptipText = strsub(tooptipText, 0, string.len(tooptipText)-1);
			end
		end
	end
	return tooptipText;
end


function Meteorologist_UpdateUnitSkyIcon(unit)
	local partyMembers = {"party1", "party2", "party3", "party4"};
	if ( type(unit) == "string" ) then
		if ( unit == "player" ) then
			Meteorologist_UpdatePlayerSkyIcon();
		elseif ( unit == "target" ) then
			Meteorologist_UpdateTargetSkyIcon();
		elseif ( Sea.list.isInList(partyMembers, unit) ) then
			foreach(
				partyMembers,
				function(index,value) if (unit == value) then Meteorologist_UpdatePartyMemberSkyIcon(index); end end 
			);
		end
	end
end


--[[ Creates a Menu ]]--
function Meteorologist_CreateMenu(unit)
	local info = { };
	if ( not UnitIsPlayer(unit) ) then
		return info;
	end

	info[1] = { text = "--"..UnitName(unit)..METEOROLOGIST_SKY_FORECAST.."--", keepShownOnClick = 1, isTitle = true, justifyH = "CENTER" };
	info[2] = { text = METEOROLOGIST_SKY_CHANNELS_HEADER, notClickable = 1, textR = METEOROLOGIST_SKY_BLUE.r, textG = METEOROLOGIST_SKY_BLUE.g, textB = METEOROLOGIST_SKY_BLUE.b };
	
	local i = 3;
	local skyChannels = Sky.isSkyUser(UnitName(unit));
	
	if(unit == "player") then
		for chanName, prettyName in SKY_CHANNELLIST_PRETTYPRINT do
			info[i] = { text = prettyName, keepShownOnClick = 1 };
			Meteorologist_MenuOptions[i] = chanName;
			--Sea.io.dprint("METEOROLOGIST_DEBUG", Meteorologist_MenuOptions[i]);
			info[i].func = function (checked) if(checked) then JoinChannelByName(Meteorologist_MenuOptions[this:GetID()]); else LeaveChannelByName(Meteorologist_MenuOptions[this:GetID()]) end end;
			info[i].checked = Sky.isChannelActive(chanName);
			i = i + 1;
		end
	elseif (type(skyChannels) == "table") then
		for index, chanName in skyChannels do
			info[i] = { text = SKY_CHANNELLIST_PRETTYPRINT[chanName], notClickable = 1 };
			i = i + 1;
		end
	else
		info[i] = { text = METEOROLOGIST_SKY_NONE, disabled = 1 };
		i = i + 1;
	end
	
	
	info[i] = { text = "", notClickable = 1 };
	i = i + 1;
	
	info[i] = { text = METEOROLOGIST_SKY_ADDONS_HEADER, notClickable = 1 };
	i = i + 1;
	local tempi = i;
	
	if ( table.getn(Meteorologist_RegisteredAddons) >= 0 ) then
		for name, data in Meteorologist_RegisteredAddons do
			local callback = data.func;
			--[[
			if Meteorologist_RegisteredAddonUsers[UnitName(unit)] then
				info[i] = { text = name };
				info[i].func = function () callback(unit) end;
				i = i + 1;
			end
			]]--
			if ( Meteorologist_RegisteredAddonUsers[UnitName(unit)] ) then
				if( Meteorologist_RegisteredAddonUsers[UnitName(unit)][name] ) then
					info[i] = { text = name };
					info[i].func = function () callback(unit) end;
					i = i + 1;
				end
			end
		end
	end
	
	if (tempi == i) then
		info[i] = { text = METEOROLOGIST_SKY_NONE, disabled = 1 };
		i = i + 1;
	end
	
	info[i] = { text = "", notClickable = 1 };
	i = i + 1;
	
	info[i] = { text = METEOROLOGIST_SKY_OPTIONS_HEADER, notClickable = 1 };
	i = i + 1;
	
	info[i] = { 
		text = METEOROLOGIST_AUTOJOIN;
		func = function (checked)
			if(checked) then
				Meteorologist_AutoJoin[GetRealmName()] = true
				if (not Sky.isChannelActive(SKY_CHANNEL)) then
					JoinChannelByName(SKY_CHANNEL);
				end
			else
				Meteorologist_AutoJoin[GetRealmName()] = false
			end
		end;
		checked = Meteorologist_AutoJoin[GetRealmName()];
	};
	i = i + 1;
	
	info[i] = { text = "", notClickable = 1 };
	i = i + 1;
	
	info[i] = { text = "|cFFCCCCCC------------|r", disabled = 1, notClickable = 1 };
	i = i + 1;
	info[i] = { text = METEOROLOGIST_MENU_CLOSE, func = function () end; };
	i = i + 1;
	
	return info;
end

--[[ Opens a Menu ]]--
function Meteorologist_OpenMenu(unit)
	local menulist = Meteorologist_CreateMenu(unit);
	EarthMenu_MenuOpen(menulist, this:GetName(), 0, 0, "MENU");
end

