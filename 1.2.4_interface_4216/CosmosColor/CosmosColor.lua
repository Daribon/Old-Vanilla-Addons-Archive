--------------------------------------------------------------------------
-- CosmosColor.lua 
--------------------------------------------------------------------------
--[[
CosmosColor v1.0

author: AnduinLothar    <Anduin@cosmosui.org>

Replaces an old Cosmos FrameXML/FriendsFrame.lua Hacks.
-Color Cosmos users in FriendsFrame

Change Log:
	v1.0 (2/19/05)
		-Initial Rerelease in addon form.
		-Added Friend color change to blue for cosmos users
		

]]--


local SavedWhoList_Update = nil;
local SavedGuildStatus_Update = nil;
local SavedFriendsList_Update = nil;
local SavedGuildPlayerStatus_Update = nil;
local SavedGuildStatus_Update = nil;


function CosmosColor_OnLoad()
	
	-- Hook the WhoList_Update handler
	if (WhoList_Update ~= SavedWhoList_Update) then
		SavedWhoList_Update = WhoList_Update;
		WhoList_Update = CosmosColor_WhoList_Update;
	end
	
	-- Hook the GuildStatus_Update handler
	if (GuildStatus_Update ~= SavedGuildStatus_Update) then
		SavedGuildStatus_Update = GuildStatus_Update;
		GuildStatus_Update = CosmosColor_GuildStatus_Update;
	end
	
	-- Hook the FriendsList_Update handler
	if (FriendsList_Update ~= SavedFriendsList_Update) then
		SavedFriendsList_Update = FriendsList_Update;
		FriendsList_Update = CosmosColor_FriendsList_Update;
	end
	
	-- Hook the GuildPlayerStatus_Update handler
	if (GuildPlayerStatus_Update ~= SavedGuildPlayerStatus_Update) then
		SavedGuildPlayerStatus_Update = GuildPlayerStatus_Update;
		GuildPlayerStatus_Update = CosmosColor_GuildPlayerStatus_Update;
	end
	
end


function CosmosColor_WhoList_Update()
	SavedWhoList_Update();
	
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame);
	local whoIndex;
	
	for i=1, WHOS_TO_DISPLAY do
		whoIndex = whoOffset + i;
		local name, guild, level, race, class, zone, group = GetWhoInfo(whoIndex);
		
		-- CosmosColor Start
		if ( Sky and name ) then
			if ( Sky.isSkyUser(name) ) then 
				getglobal("WhoFrameButton"..i.."Name"):SetTextColor(0.0, 0.22, 1.0);
			else 
				getglobal("WhoFrameButton"..i.."Name"):SetTextColor(1.0, 0.82, 0.0);
			end
		end
		-- CosmosColor end
	end
end


function CosmosColor_GuildStatus_Update()
	SavedGuildStatus_Update();
	
	local guildOffset = FauxScrollFrame_GetOffset(GuildStatusScrollFrame);
	local guildIndex;
	
	for i=1, GUILDMEMBERS_TO_DISPLAY do
		guildIndex = guildOffset + i;
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(guildIndex);
		
		-- CosmosColor Start
		if ( online and name ) then
			if ( Sky ) then
				if ( Sky.isSkyUser(name) ) then 
					getglobal("GuildFrameButton"..i.."Name"):SetTextColor(0.0, 0.32, 1.0);
				end
			end
		end
		-- CosmosColor end
	end
end


function CosmosColor_FriendsList_Update()
	SavedFriendsList_Update();
	
	local nameLocationText;
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	local friendIndex;
	
	for i=1, FRIENDS_TO_DISPLAY do
		friendIndex = friendOffset + i;
		local name, level, class, area, connected = GetFriendInfo(friendIndex);
		nameLocationText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextNameLocation");
		
		-- CosmosColor Start
		if ( connected and name ) then
			nameLocationText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
			if ( Sky ) then
				if ( Sky.isSkyUser(name) ) then 
					nameLocationText:SetTextColor(0.0, 0.32, 1.0);
				end
			end
		end
		-- CosmosColor end
		
	end
	
end


function CosmosColor_GuildPlayerStatus_Update()
	SavedGuildPlayerStatus_Update();
	
	local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame);
	local guildIndex;
	
	for i=1, GUILDMEMBERS_TO_DISPLAY do
		guildIndex = guildOffset + i;
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(guildIndex);
		
		-- CosmosColor Start
		if ( online and name ) then
			if ( Sky ) then
				if ( Sky.isSkyUser(name) ) then 
					getglobal("GuildFrameButton"..i.."Name"):SetTextColor(0.0, 0.42, 1.0);
				end
			end
		end
		-- CosmosColor end
	end
end
