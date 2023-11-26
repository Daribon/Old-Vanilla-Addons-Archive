PopupHandler_GuildList = {};
PopupHandler_FriendList = {};
PopupHandler_IgnoreList = {};

PopupHandler_UnitsInParty = {
};


function PopupHandler_Util_OnLoad()
	PopupHandler_UpdateGuildList();
	PopupHandler_UpdateFriendsList();
	PopupHandler_UpdateIgnoreList();
	
	for i = 1, 4 do
		table.insert(PopupHandler_UnitsInParty, "party"..i);
	end
	for i = 1, 40 do
		table.insert(PopupHandler_UnitsInParty, "raid"..i);
	end
	
	PopupHandler_AddEventListener("FRIENDLIST_SHOW", PopupHandler_UpdateFriendsList);
	PopupHandler_AddEventListener("FRIENDLIST_UPDATE", PopupHandler_UpdateFriendsList);

	PopupHandler_AddEventListener("GUILD_ROSTER_SHOW", PopupHandler_UpdateGuildList);
	PopupHandler_AddEventListener("GUILD_ROSTER_UPDATE", PopupHandler_UpdateGuildList);
	PopupHandler_AddEventListener("PLAYER_GUILD_UPDATE", PopupHandler_UpdateGuildList);

	PopupHandler_AddEventListener("IGNORELIST_UPDATE", PopupHandler_UpdateIgnoreList);
end

function PopupHandler_UpdateFriendsList()
	local numFriends = GetNumFriends();
	local name, level, class, area, connected;
	local size = table.getn(PopupHandler_FriendList);
	local entry = 1;
	for friendIndex = 1, numFriends do
		name, level, class, area, connected = GetFriendInfo(friendIndex);
		if ( connected ) then
			PopupHandler_FriendList[entry] = name;
			entry = entry + 1;
		end
	end
	for i = size, entry, -1 do
		PopupHandler_FriendList[i] = nil;
	end
end

function PopupHandler_UpdateIgnoreList()
	local numIgnores = GetNumIgnores();
	local name;
	local size = table.getn(PopupHandler_IgnoreList);
	for ignoreIndex = 1, numIgnores do
		name = GetIgnoreName(ignoreIndex);
		PopupHandler_IgnoreList[ignoreIndex] = name;
	end
	for i = size, numIgnores, -1 do
		PopupHandler_IgnoreList[i] = nil;
	end
end

function PopupHandler_UpdateGuildList()
	if ( IsInGuild() ) then
		local numGuildMembers = GetNumGuildMembers();
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online;
		local size = table.getn(PopupHandler_GuildList);
		local entry = 1;
		
		for guildIndex = 1, numGuildMembers do
			name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(guildIndex);
			if ( online ) then
				PopupHandler_GuildList[entry] = name;
				entry = entry + 1;
			end
		end
		for i = size, entry, -1 do
			PopupHandler_GuildList[i] = nil;
		end
	end
end



table.insert(PopupHandler_HandlersOnLoad, PopupHandler_Util_OnLoad);
