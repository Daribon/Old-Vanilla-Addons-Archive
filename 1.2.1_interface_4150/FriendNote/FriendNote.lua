--[[
	FriendNote

	By sarf

	This mod allows you to add notes to friends.

	Thanks goes to Bhaerau for suggesting this!
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]

FriendNote_AllowedToDoStuff = 0;

FriendNote_Data = {};
FriendNote_Saved_FriendsList_Update = nil;

function FriendNote_GetData(friendName)
	local serverName = GetCVar("realmName");
	local playerName = UnitName("player");
	if ( ( FriendNote_Data ) and ( FriendNote_Data[serverName] ) and ( FriendNote_Data[serverName][playerName] ) ) then
		local data = FriendNote_Data[serverName][playerName][friendName];
		return data;
	else
		return nil;
	end
end

function FriendNote_SetData(friendName, data)
	local serverName = GetCVar("realmName");
	local playerName = UnitName("player");
	if ( not FriendNote_Data ) then
		FriendNote_Data = {};
	end
	if ( not FriendNote_Data[serverName] ) then
		FriendNote_Data[serverName] = {};
	end
	if ( not FriendNote_Data[serverName][playerName] ) then
		FriendNote_Data[serverName][playerName] = {};
	end
	FriendNote_Data[serverName][playerName][friendName] = data;
end

function FriendNote_UpdateFriends()
	if ( FriendNote_AllowedToDoStuff ~= 1 ) then
		return;
	end
	if ( not FauxScrollFrame_GetOffset ) or ( not FriendsFrameFriendsScrollFrame ) then
		return;
	end
	local numFriends = GetNumFriends();
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	local friendIndex;
	local buttonBaseName = "FriendsFrameFriendButton%d";
	local buttonName;
	local button;
	local name, level, class, area, connected;
	local infoText;
	local maxIndex = FRIENDS_TO_DISPLAY;
	if ( ( friendOffset + maxIndex ) > numFriends ) then
		maxIndex = numFriends;
	end
	for i=1, maxIndex, 1 do
		buttonName = format(buttonBaseName, i);
		button = getglobal(buttonName);
		if ( button ) then
			friendIndex = friendOffset + i;
			name, level, class, area, connected = GetFriendInfo(friendIndex);
			--nameLocationText = getglobal(buttonName.."ButtonTextNameLocation");
			if ( ( name ) and ( button:IsVisible() ) ) then
				infoText = getglobal(buttonName.."ButtonTextInfo");
				local data = FriendNote_GetData(name);
				if ( data ) then
					local oldText = infoText:GetText();
					if ( not infoText.oldName ) or ( infoText.oldName ~= name ) then
						infoText.oldName = name;
						infoText.oldText = oldText;
					else
						oldText = infoText.oldText;
					end
					if ( data.note ) then
						local newText = oldText;
						if ( strlen(newText) > 0 ) then
							newText = newText..format(" - %s", data.note);
						else
							newText = data.note;
						end
						infoText:SetText(newText);
					end
				end
			end
		end
	end
end	

function FriendNote_FriendsList_Update()
	FriendNote_Saved_FriendsList_Update();
	FriendNote_UpdateFriends();
end

function FriendNote_OnLoad()
	if ( Cosmos_RegisterChatCommand ) then
		Cosmos_RegisterChatCommand (
			"FRIENDNOTE_MAIN_COMMAND", -- Some Unique Group ID
			FRIENDNOTE_CHAT_FRIENDNOTE_COMMANDS, -- The Commands
			FriendNote_Main_ChatCommandHandler,
			FRIENDNOTE_CHAT_FRIENDNOTE_COMMAND_INFO -- Description String
		);
	else
		SlashCmdList["FRIENDNOTESLASHMAIN"] = FriendNote_Main_ChatCommandHandler;
		for k, v in FRIENDNOTE_CHAT_FRIENDNOTE_COMMANDS do
			setglobal("SLASH_FRIENDNOTESLASHMAIN"..k, v);
		end
	end
	RegisterForSave("FriendNote_Data");
	this:RegisterEvent("VARIABLES_LOADED");
	--[[
	this:RegisterEvent("FRIENDLIST_SHOW");
	this:RegisterEvent("FRIENDLIST_UPDATE");
	]]--
end

function FriendNote_Hook_Functions()
	if ( not FriendNote_Saved_FriendsList_Update ) then
		FriendNote_Saved_FriendsList_Update = FriendsList_Update;
		FriendsList_Update = FriendNote_FriendsList_Update;
	end
end


function FriendNote_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end

function FriendNote_Main_ChatCommandHandler(msg)
	if ( not msg ) or ( strlen(msg) <= 0 ) then
		FriendNote_Print(FRIENDNOTE_CHAT_FRIENDNOTE_COMMAND_USAGE);
	end
	
	local name, params = FriendNote_Extract_NextParameter(msg);
	if ( strlen(name) > 0 ) then
		local data = {};
		if ( strlen(params) > 0 ) then
			data.note = params;
		else
			data = nil;
		end
		FriendNote_SetData(name, data);
		FriendNote_UpdateFriends();
		FriendNote_Print(format(FRIENDNOTE_CHAT_FRIENDNOTE_UPDATED, name));
	else
		FriendNote_Print(FRIENDNOTE_CHAT_FRIENDNOTE_COMMAND_USAGE);
	end
end

function FriendNote_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		FriendNote_Hook_Functions();
		FriendNote_AllowedToDoStuff = 1;
		FriendNote_UpdateFriends();
	end
	if ( event == "FRIENDLIST_SHOW" ) then
		FriendNote_UpdateFriends();
	end
	if ( event == "FRIENDLIST_UPDATE" ) then
		FriendNote_UpdateFriends();
	end
end

-- Prints out text to a chat box.
function FriendNote_Print(msg,r,g,b,frame,id,unknown4th)
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 0.0; end
	if ( Print ) then
		Print(msg, r, g, b, frame, id, unknown4th);
		return;
	end
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

