--[[
	Party Request Handler

	By sarf

	This mod allows you to accept (and deny) invites to groups automatically.

	Thanks goes to hctp|Kona for suggesting the idea.
	
   ]]


-- Constants
PARTYREQUESTHANDLER_TOGGLE_ENABLED_FUNC_NAME = "PartyRequestHandler_Toggle_Enabled";
PARTYREQUESTHANDLER_TOGGLE_ALLOW_FRIEND_FUNC_NAME = "PartyRequestHandler_Toggle_Allow_Friend";
PARTYREQUESTHANDLER_TOGGLE_ALLOW_GUILD_FUNC_NAME = "PartyRequestHandler_Toggle_Allow_Guild";
PARTYREQUESTHANDLER_TOGGLE_DENY_IGNORE_FUNC_NAME = "PartyRequestHandler_Toggle_Deny_Ignore";
PARTYREQUESTHANDLER_TOGGLE_SHOW_DENY_FUNC_NAME = "PartyRequestHandler_Toggle_Show_Deny";
PARTYREQUESTHANDLER_TOGGLE_ALLOW_BY_DEFAULT_FUNC_NAME = "PartyRequestHandler_Toggle_Allow_By_Default";
PARTYREQUESTHANDLER_TOGGLE_DENY_BY_DEFAULT_FUNC_NAME = "PartyRequestHandler_Toggle_Deny_By_Default";

PARTYREQUESTHANDLER_TOGGLE_IGNORE_NEXT_FUNC_NAME = "PartyRequestHandler_SetIgnoreNext";
PARTYREQUESTHANDLER_TOGGLE_ALLOWED_FUNC_NAME = "PartyRequestHandler_Toggle_Allowed";
PARTYREQUESTHANDLER_TOGGLE_DENIED_FUNC_NAME = "PartyRequestHandler_Toggle_Denied";

-- Variables
PartyRequestHandler_Enabled = 1;
PartyRequestHandler_Allow_Friend = 0;
PartyRequestHandler_Allow_Guild = 0;
PartyRequestHandler_Deny_Ignore = 0;
PartyRequestHandler_Allow_By_Default = 0;
PartyRequestHandler_Deny_By_Default = 0;
PartyRequestHandler_Show_Deny = 1;

PartyRequestHandler_List = {
};

PartyRequestHandler_GuildList = {};
PartyRequestHandler_FriendList = {};
PartyRequestHandler_IgnoreList = {};

PartyRequestHandler_IgnoreNextState = 0;

PartyRequestHandler_Saved_StaticPopup_Show = nil;
PartyRequestHandler_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function PartyRequestHandler_OnLoad()
	PartyRequestHandler_Register();
end

-- registers the mod with Cosmos
function PartyRequestHandler_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( PartyRequestHandler_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER",
			"SECTION",
			TEXT(PARTYREQUESTHANDLER_CONFIG_HEADER),
			TEXT(PARTYREQUESTHANDLER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_HEADER",
			"SEPARATOR",
			TEXT(PARTYREQUESTHANDLER_CONFIG_HEADER),
			TEXT(PARTYREQUESTHANDLER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_ENABLED",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_ENABLED),
			TEXT(PARTYREQUESTHANDLER_ENABLED_INFO),
			PartyRequestHandler_Toggle_Enabled_NoChat,
			PartyRequestHandler_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_SHOW_DENY",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_SHOW_DENY),
			TEXT(PARTYREQUESTHANDLER_SHOW_DENY_INFO),
			PartyRequestHandler_Toggle_Show_Deny_NoChat,
			PartyRequestHandler_Show_Deny
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_ALLOW_BY_DEFAULT",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_ALLOW_BY_DEFAULT),
			TEXT(PARTYREQUESTHANDLER_ALLOW_BY_DEFAULT_INFO),
			PartyRequestHandler_Toggle_Allow_By_Default_NoChat,
			PartyRequestHandler_Allow_By_Default
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_DENY_BY_DEFAULT",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_DENY_BY_DEFAULT),
			TEXT(PARTYREQUESTHANDLER_DENY_BY_DEFAULT_INFO),
			PartyRequestHandler_Toggle_Deny_By_Default_NoChat,
			PartyRequestHandler_Deny_By_Default
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_ALLOW_FRIEND",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_ALLOW_FRIEND),
			TEXT(PARTYREQUESTHANDLER_ALLOW_FRIEND_INFO),
			PartyRequestHandler_Toggle_Allow_Friend_NoChat,
			PartyRequestHandler_Allow_Friend
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_ALLOW_GUILD",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_ALLOW_GUILD),
			TEXT(PARTYREQUESTHANDLER_ALLOW_GUILD_INFO),
			PartyRequestHandler_Toggle_Allow_Guild_NoChat,
			PartyRequestHandler_Allow_Guild
		);
		Cosmos_RegisterConfiguration(
			"COS_PARTYREQUESTHANDLER_DENY_IGNORE",
			"CHECKBOX",
			TEXT(PARTYREQUESTHANDLER_DENY_IGNORE),
			TEXT(PARTYREQUESTHANDLER_DENY_IGNORE_INFO),
			PartyRequestHandler_Toggle_Deny_Ignore_NoChat,
			PartyRequestHandler_Deny_Ignore
		);
		PartyRequestHandler_Cosmos_Registered = 1;
	end
end

local PRH_Commands = {
	{ commands = PARTYREQUESTHANDLER_COMMAND_STATE, func = PARTYREQUESTHANDLER_TOGGLE_ENABLED_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_ALLOW_FRIEND, func = PARTYREQUESTHANDLER_TOGGLE_ALLOW_FRIEND_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_ALLOW_GUILD, func = PARTYREQUESTHANDLER_TOGGLE_ALLOW_GUILD_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_DENY_IGNORE, func = PARTYREQUESTHANDLER_TOGGLE_DENY_IGNORE_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_SHOW_DENY, func = PARTYREQUESTHANDLER_TOGGLE_SHOW_DENY_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_DENY_BY_DEFAULT, func = PARTYREQUESTHANDLER_TOGGLE_DENY_BY_DEFAULT_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_ALLOW_BY_DEFAULT, func = PARTYREQUESTHANDLER_TOGGLE_ALLOW_BY_DEFAULT_FUNC_NAME, toggle = true},
	{ commands = PARTYREQUESTHANDLER_COMMAND_IGNORE_NEXT, func = PARTYREQUESTHANDLER_TOGGLE_IGNORE_NEXT_FUNC_NAME},
	{ commands = PARTYREQUESTHANDLER_COMMAND_TOGGLE_ALLOWED, func = PARTYREQUESTHANDLER_TOGGLE_ALLOWED_FUNC_NAME},
	{ commands = PARTYREQUESTHANDLER_COMMAND_TOGGLE_DENIED, func = PARTYREQUESTHANDLER_TOGGLE_DENIED_FUNC_NAME},
};

function PartyRequestHandler_ShowUsage()
	if ( type(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE) == "table" ) then
		for k, v in PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE do
			AddOnHelper_Print(v);
		end
	else
		AddOnHelper_Print(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE);
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the PartyRequestHandler
function PartyRequestHandler_Main_ChatCommandHandler(msg)
	
	local func = nil;
	
	local toggleFunc = false;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		PartyRequestHandler_ShowUsage();
		return;
	end
	
	local commandName, params = AddOnHelper_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end

	for k, v in PRH_Commands do
		for key, command in v.commands do
			if ( strfind( commandName, command ) ) then
				func = getglobal(v.func);
				toggleFunc = v.toggle;
				break;
			end
		end
		if ( func ) then break; end
	end
	
	if ( func ) then
		if ( toggleFunc ) then
			-- Toggle appropriately
			if ( (string.find(params, 'on')) or ((string.find(params, '1')) and (not string.find(params, '-1')) ) ) then
				func(1);
			else
				if ( (string.find(params, 'off')) or (string.find(params, '0')) ) then
					func(0);
				else
					func(-1);
				end
			end
		else
			func(params);
		end
	else
		PartyRequestHandler_ShowUsage();
		return;
	end
end

function PartyRequestHandler_GetIndex()
	local name = UnitName("player");
	if ( not name ) then name = "Unknown"; end
	local str = string.format("%s_%s", GetCVar("realmList"), name);
	if ( not PartyRequestHandler_List[str] ) then
		PartyRequestHandler_List[str] = {};
	end
	if ( not PartyRequestHandler_List[str].allow ) then
		PartyRequestHandler_List[str].allow = {};
	end
	if ( not PartyRequestHandler_List[str].deny ) then
		PartyRequestHandler_List[str].deny = {};
	end
	return str;
end

function PartyRequestHandler_ShowDeny(name)
	AddOnHelper_Print(string.format(PARTYREQUESTHANDLER_CHAT_DENIED_MESSAGE, name));
end

function PartyRequestHandler_AcceptGroup()
	AcceptGroup();
end

function PartyRequestHandler_DeclineGroup(name)
	DeclineGroup();
	if ( PartyRequestHandler_Show_Deny == 1 ) then
		PartyRequestHandler_ShowDeny(name);
	end
end


-- Does things with the hooked function
function PartyRequestHandler_StaticPopup_Show(which, text_arg1, text_arg2, ...)
	if ( PartyRequestHandler_Enabled == 1 ) then
		if ( which == "PARTY_INVITE" ) then
			if ( PartyRequestHandler_IgnoreNextState ~= 1 ) then
				local state = PartyRequestHandler_GetState(text_arg1);
				if ( state == 1 ) then
					PartyRequestHandler_AcceptGroup();
					return;
				elseif ( state == 0 ) then
					PartyRequestHandler_DeclineGroup();
					return;
				end
			else
				PartyRequestHandler_IgnoreNextState = 0;
			end
		end
	end
	if ( not arg ) then 
		arg = {};
	end
	return PartyRequestHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2, unpack(arg));
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function PartyRequestHandler_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( StaticPopup_Show ~= PartyRequestHandler_StaticPopup_Show ) and (PartyRequestHandler_Saved_StaticPopup_Show == nil) ) then
			PartyRequestHandler_Saved_StaticPopup_Show = StaticPopup_Show;
			StaticPopup_Show = PartyRequestHandler_StaticPopup_Show;
		end
	else
		if ( StaticPopup_Show == PartyRequestHandler_StaticPopup_Show) then
			StaticPopup_Show = PartyRequestHandler_Saved_StaticPopup_Show;
			PartyRequestHandler_Saved_StaticPopup_Show = nil;
		end
	end
end

function PartyRequestHandler_UpdateFriendsList()
	PartyRequestHandler_FriendList = {};
	local numFriends = GetNumFriends();
	local name, level, class, area, connected;
	for friendIndex = 1, numFriends do
		name, level, class, area, connected = GetFriendInfo(friendIndex);
		table.insert(PartyRequestHandler_FriendList, name);
	end
end

function PartyRequestHandler_UpdateIgnoreList()
	PartyRequestHandler_IgnoreList = {};
	local numIgnores = GetNumIgnores();
	local name;
	for ignoreIndex = 1, numIgnores do
		name = GetIgnoreName(ignoreIndex);
		table.insert(PartyRequestHandler_IgnoreList, name);
	end
end

function PartyRequestHandler_UpdateGuildList()
	PartyRequestHandler_GuildList = {};
	if ( IsInGuild() ) then
		PartyRequestHandler_GuildList = {};
		local numGuildMembers = GetNumGuildMembers();
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online;
		
		for guildIndex = 1, numGuildMembers do
			name, rank, rankIndex, level, class, zone, group, note, officernote, online = GetGuildRosterInfo(guildIndex);
			table.insert(PartyRequestHandler_GuildList, name);
		end
	end
end

-- Toggles the enabled/disabled state of the PartyRequestHandler
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function PartyRequestHandler_Toggle_Enabled(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ENABLED_FUNC_NAME, toggle, true);
end

-- toggling - no text
function PartyRequestHandler_Toggle_Enabled_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ENABLED_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_Toggle_Allow_Friend(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_FRIEND_FUNC_NAME, toggle, true);
end

function PartyRequestHandler_Toggle_Allow_Friend_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_FRIEND_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_Toggle_Allow_Guild(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_GUILD_FUNC_NAME, toggle, true);
end

function PartyRequestHandler_Toggle_Allow_Guild_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_GUILD_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_Toggle_Deny_Ignore(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_DENY_IGNORE_FUNC_NAME, toggle, true);
end

function PartyRequestHandler_Toggle_Deny_Ignore_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_DENY_IGNORE_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_Toggle_Show_Deny(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_SHOW_DENY_FUNC_NAME, toggle, true);
end

function PartyRequestHandler_Toggle_Show_Deny_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_SHOW_DENY_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_Toggle_Deny_By_Default(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_DENY_BY_DEFAULT_FUNC_NAME, toggle, true);
end

function PartyRequestHandler_Toggle_Deny_By_Default_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_DENY_BY_DEFAULT_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_Toggle_Allow_By_Default(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_BY_DEFAULT_FUNC_NAME, toggle, true);
end

function PartyRequestHandler_Toggle_Allow_By_Default_NoChat(toggle)
	AddOnHelper_HandleToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_BY_DEFAULT_FUNC_NAME, toggle, false);
end

function PartyRequestHandler_SetIgnoreNext()
	PartyRequestHandler_IgnoreNextState = 1;
	AddOnHelper_Print(PARTYREQUESTHANDLER_CHAT_IGNORE_NEXT);
end

function PartyRequestHandler_Toggle_Allowed(params)
	local stateStr = PARTYREQUESTHANDLER_CHAT_TOGGLE_ADDED;
	local index = nil;
	for k, v in PartyRequestHandler_List.allow do
		if ( v == params ) then
			stateStr = PARTYREQUESTHANDLER_CHAT_TOGGLE_REMOVED;
			index = k;
		end
	end
	if ( index ) then
		table.remove(PartyRequestHandler_List.allow, index);
	else
		table.insert(PartyRequestHandler_List.allow, params);
	end
	AddOnHelper_Print(string.format(PARTYREQUESTHANDLER_CHAT_TOGGLE_ALLOWED, stateStr, params));
end

function PartyRequestHandler_Toggle_Denied(params)
	local stateStr = PARTYREQUESTHANDLER_CHAT_TOGGLE_ADDED;
	local index = nil;
	for k, v in PartyRequestHandler_List.deny do
		if ( v == params ) then
			stateStr = PARTYREQUESTHANDLER_CHAT_TOGGLE_REMOVED;
			index = k;
		end
	end
	if ( index ) then
		table.remove(PartyRequestHandler_List.deny, index);
	else
		table.insert(PartyRequestHandler_List.deny, params);
	end
	AddOnHelper_Print(string.format(PARTYREQUESTHANDLER_CHAT_TOGGLE_DENIED, stateStr, params));
end

function PartyRequestHandler_IsNameInFriendsList(name)
	for k, v in PartyRequestHandler_FriendList do
		if ( v == name ) then
			return true;
		end
	end
	return false;
end

function PartyRequestHandler_IsNameInGuildList(name)
	for k, v in PartyRequestHandler_GuildList do
		if ( v == name ) then
			return true;
		end
	end
	return false;
end

function PartyRequestHandler_IsNameInIgnoreList(name)
	for k, v in PartyRequestHandler_IgnoreList do
		if ( v == name ) then
			return true;
		end
	end
	return false;
end



-- THIS IS THE FUNCTION THAT SHOULD BE OVERLOADED IF NECESSARY
-- returns 1 if allowed, 0 if not explicitly allowed
function PartyRequestHandler_IsNameAllowed(name)
	return 0;
end

-- THIS IS THE FUNCTION THAT SHOULD BE OVERLOADED IF NECESSARY
-- returns 1 if denied, 0 if not explicitly denied
function PartyRequestHandler_IsNameDenied(name)
	return 0;
end

function PartyRequestHandler_GetState(name)
	if ( PartyRequestHandler_IsNameAllowed(name) == 1 ) then
		return 1;
	end
	if ( PartyRequestHandler_IsNameDenied(name) == 1 ) then
		return 0;
	end
	local index = PartyRequestHandler_GetIndex();
	for k, v in PartyRequestHandler_List[index].deny do
		if ( v == name ) then
			return 0;
		end
	end
	for k, v in PartyRequestHandler_List[index].allow do
		if ( v == name ) then
			return 1;
		end
	end
	if ( PartyRequestHandler_Allow_Friend == 1 ) then
		if ( PartyRequestHandler_IsNameInFriendsList(name) ) then
			return 1;
		end
	end
	if ( PartyRequestHandler_Allow_Guild == 1 ) then
		if ( PartyRequestHandler_IsNameInGuildList(name) ) then
			return 1;
		end
	end
	if ( PartyRequestHandler_Deny_Ignore == 1 ) then
		if ( PartyRequestHandler_IsNameInIgnoreList(name) ) then
			return 0;
		end
	end
	if ( PartyRequestHandler_Allow_By_Default == 1 ) then
		return 1;
	end
	if ( PartyRequestHandler_Deny_By_Default == 1 ) then
		return 0;
	end
	return -1;
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function PartyRequestHandler_Register()
	PartyRequestHandler_Setup_Hooks(1);
	
	AddOnHelper_AddSlashCommand("PARTYREQUESTHANDLERSLASHMAIN", PARTYREQUESTHANDLER_COMMANDS, 
		PartyRequestHandler_Main_ChatCommandHandler, PARTYREQUESTHANDLER_CHAT_COMMAND_INFO); 
	
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ENABLED_FUNC_NAME, "PartyRequestHandler_Enabled", 
		"PARTYREQUESTHANDLER_CHAT_ENABLED", "PARTYREQUESTHANDLER_CHAT_DISABLED", "COS_PARTYREQUESTHANDLER_ENABLED_X");
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_FRIEND_FUNC_NAME, "PartyRequestHandler_Allow_Friend", 
		"PARTYREQUESTHANDLER_CHAT_ALLOW_FRIEND_ENABLED", "PARTYREQUESTHANDLER_CHAT_ALLOW_FRIEND_DISABLED", "COS_PARTYREQUESTHANDLER_ALLOW_FRIEND_X");
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_GUILD_FUNC_NAME, "PartyRequestHandler_Allow_Guild", 
		"PARTYREQUESTHANDLER_CHAT_ALLOW_GUILD_ENABLED", "PARTYREQUESTHANDLER_CHAT_ALLOW_GUILD_DISABLED", "COS_PARTYREQUESTHANDLER_ALLOW_GUILD_X");
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_DENY_IGNORE_FUNC_NAME, "PartyRequestHandler_Deny_Ignore", 
		"PARTYREQUESTHANDLER_CHAT_DENY_IGNORE_ENABLED", "PARTYREQUESTHANDLER_CHAT_DENY_IGNORE_DISABLED", "COS_PARTYREQUESTHANDLER_DENY_IGNORE_X");
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_SHOW_DENY_FUNC_NAME, "PartyRequestHandler_Show_Deny", 
		"PARTYREQUESTHANDLER_CHAT_SHOW_DENY_ENABLED", "PARTYREQUESTHANDLER_CHAT_SHOW_DENY_DISABLED", "COS_PARTYREQUESTHANDLER_SHOW_DENY_X");
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_DENY_BY_DEFAULT_FUNC_NAME, "PartyRequestHandler_Deny_By_Default", 
		"PARTYREQUESTHANDLER_CHAT_DENY_BY_DEFAULT_ENABLED", "PARTYREQUESTHANDLER_CHAT_DENY_BY_DEFAULT_DISABLED", "COS_PARTYREQUESTHANDLER_DENY_BY_DEFAULT_X");
	AddOnHelper_CreateToggleFunction(PARTYREQUESTHANDLER_TOGGLE_ALLOW_BY_DEFAULT_FUNC_NAME, "PartyRequestHandler_Allow_By_Default", 
		"PARTYREQUESTHANDLER_CHAT_ALLOW_BY_DEFAULT_ENABLED", "PARTYREQUESTHANDLER_CHAT_ALLOW_BY_DEFAULT_DISABLED", "COS_PARTYREQUESTHANDLER_ALLOW_BY_DEFAULT_X");

	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		PartyRequestHandler_Register_Cosmos();
	else
		this:RegisterEvent("VARIABLES_LOADED");
	end
	this:RegisterEvent("FRIENDLIST_SHOW");
	this:RegisterEvent("FRIENDLIST_UPDATE");
	this:RegisterEvent("IGNORELIST_UPDATE");
	this:RegisterEvent("GUILD_ROSTER_SHOW");
	this:RegisterEvent("GUILD_ROSTER_UPDATE");
	this:RegisterEvent("PLAYER_GUILD_UPDATE");
end

-- Handles events
function PartyRequestHandler_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( PartyRequestHandler_Cosmos_Registered == 0 ) then
			local value = getglobal("PartyRequestHandler_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			PartyRequestHandler_Toggle_Enabled(value);
		end
		GuildRoster();
		PartyRequestHandler_UpdateGuildList();
		PartyRequestHandler_UpdateFriendsList();
		PartyRequestHandler_UpdateIgnoreList();
	end
	if ( event == "FRIENDLIST_SHOW" ) or ( event == "FRIENDLIST_UPDATE" ) then
		PartyRequestHandler_UpdateFriendsList();
	end
	if ( event == "GUILD_ROSTER_SHOW" ) or ( event == "GUILD_ROSTER_UPDATE" ) then
		PartyRequestHandler_UpdateGuildList();
	end
	if ( event == "IGNORELIST_UPDATE" ) then
		PartyRequestHandler_UpdateIgnoreList();
	end
	if ( event == "PLAYER_GUILD_UPDATE" ) then
		PartyRequestHandler_UpdateGuildList();
	end
end

