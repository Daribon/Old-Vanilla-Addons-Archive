--------------------------------------------------------------------------
-- FriendsFacts.lua 
--------------------------------------------------------------------------
--[[
FriendsFacts v1.0

author: AnduinLothar    <Anduin@cosmosui.org>

Replaces an old Cosmos FrameXML/FriendsFrame.lua Hack.

Remember friends level, class and location after they've logged off. Thanks to George Warner for this original hack.
TODO: check how old the data is and not display it if older than some arbitrary value
		
Change Log:
	v1.0 (2/19/05)
		-Rerelease in addon form.
		-Modified Width for offline overflow with long location names.
		

]]--


local SavedFriendsList_Update = nil;
FriendsFacts_Enabled = true;

function FriendsFacts_OnLoad()
	
	if ( FriendsFacts_Enabled ) then
		-- Hook the FriendsList_Update handler
		if (FriendsList_Update ~= SavedFriendsList_Update) then
			SavedFriendsList_Update = FriendsList_Update;
			FriendsList_Update = FriendsFacts_FriendsList_Update;
		end
	end
	
end


function FriendsFacts_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) and ( FriendsFacts_Enabled ) then
		
		if ( not FriendsFacts_Data ) then
			FriendsFacts_Data = {};
		end
		RegisterForSave("FriendsFacts_Data");
		
	end
end


function FriendsFacts_FriendsList_Update()
	SavedFriendsList_Update();
	
	local nameLocationText;
	local infoText;
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	local friendIndex;
	
	for i=1, FRIENDS_TO_DISPLAY do
		friendIndex = friendOffset + i;
		local name, level, class, area, connected = GetFriendInfo(friendIndex);
		nameLocationText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextNameLocation");
		infoText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextInfo");

		if ( connected ) then
			if ( not FriendsFacts_Data[name] ) and ( FriendsFacts_Enabled ) then
				FriendsFacts_Data[name] = {};
			end
			if ( FriendsFacts_Enabled ) then
				FriendsFacts_Data[name].level = level;
				FriendsFacts_Data[name].class = class;
				FriendsFacts_Data[name].area = area;
			end
		elseif (  ( name ) and ( FriendsFacts_Data[name] ) and ( FriendsFacts_Enabled ) ) then
			level = FriendsFacts_Data[name].level;
			class = FriendsFacts_Data[name].class;
			if ( not class ) then class = TEXT(UNKNOWN); end
			area = FriendsFacts_Data[name].area;
			if ( not area ) then area = TEXT(UNKNOWN); end
			nameLocationText:SetText(format(TEXT(FRIENDS_FACTS_OFFLINE_TEMPLATE), name, area));
			if ( nameLocationText:GetWidth() > 275 ) then
				nameLocationText:SetText(format(TEXT(FRIENDS_FACTS_OFFLINE_TEMPLATE_SHORT), name, area));
				nameLocationText:SetJustifyH("LEFT");
				nameLocationText:SetWidth(275);
			end
			if ( level ) and ( class ) then
				infoText:SetText(format(TEXT(FRIENDS_LEVEL_TEMPLATE), level, class));
			end
		end
	end
end

