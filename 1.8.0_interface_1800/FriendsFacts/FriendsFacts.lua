--------------------------------------------------------------------------
-- FriendsFacts.lua 
--------------------------------------------------------------------------
--[[
FriendsFacts

author: AnduinLothar    <karlkfi@cosmosui.org>

Replaces and builds on an old Cosmos FrameXML/FriendsFrame.lua Hack.

Records and displays friend level, class, location, pvpname, sex, race, and guild. 
TODO: check how old the data is and not display it if older than some arbitrary value
		
Change Log:
v1.0 (2/19/05)
-Rerelease in addon form.
-Modified Width for offline overflow with long location names.
v1.1 (4/29/05)
-Friend info now stored for all friends and not just the ones you look at.
-nil index bug fixed.
v1.2 (8/17/05)
-Added Mouseover Data to Friends List. 
If you've ever seen a tooltip of that player it will record and show their pvpname, sex, race, and guild.
-Made Friend List Realm Specific (Warning! All old friend data will be lost).
If you are planning on moving from one faction to another you should clear the list for that realm:
/script FriendsFacts_Data[GetRealmName()] = {};
-Added auto-truncation for strings that would extend past the edge of the frame.
v1.3 (9/6/05)
-Added Khaos Options for FriendsFacts_Enabled and FriendsFacts_PVPName booleans
-To disable PVPName manually use "/script FriendsFacts_PVPName=nil"
v1.31 (9/19/05)
-Fixed FriendsFacts_Data nil error
]]--


local SavedFriendsList_Update = nil;
FriendsFacts_Enabled = true;
FriendsFacts_PVPName = true;
FriendsFacts_Data = {};

function FriendsFacts_OnLoad()
	
	if ( FriendsFacts_Enabled ) then
		-- Hook the FriendsList_Update handler
		if (FriendsList_Update ~= SavedFriendsList_Update) then
			SavedFriendsList_Update = FriendsList_Update;
			FriendsList_Update = FriendsFacts_FriendsList_Update;
		end
	end
	-- Hook GameTooltip.SetUnit to gather friend info whenever the tooltip is updated
	if (GameTooltip.SetUnit ~= SavedGameTooltip_SetUnit) then
		SavedGameTooltip_SetUnit = GameTooltip.SetUnit;
		GameTooltip.SetUnit = FriendsFacts_SetUnit;
	end
	
	if (Khaos) then
		FriendsFacts_Register_Khaos();
	end
end


function FriendsFacts_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) and ( FriendsFacts_Enabled ) then
		
		if ( not FriendsFacts_Data ) then
			FriendsFacts_Data = {};
		end
		if (not FriendsFacts_Data[GetRealmName()]) then
			FriendsFacts_Data[GetRealmName()] = {};
		end
	end
end


function FriendsFacts_FriendsList_Update()
	SavedFriendsList_Update();
	
	local nameLocationText, infoText, friendIndex;
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	local numFriends = GetNumFriends();
	local realm = GetRealmName();
	
	for i=1, numFriends do
		local name, level, class, area, connected = GetFriendInfo(i);
		local PVPName, race, sex, guild;
		if (name) then
			if (connected) then
				if ( not FriendsFacts_Data[realm][name] ) and ( FriendsFacts_Enabled ) then
					FriendsFacts_Data[realm][name] = {};
				end
				if ( FriendsFacts_Enabled ) then
					FriendsFacts_Data[realm][name].level = level;
					FriendsFacts_Data[realm][name].class = class;
					FriendsFacts_Data[realm][name].area = area;
				end
			end
			if (FriendsFacts_Enabled) and (i > friendOffset) and (i <= friendOffset+FRIENDS_TO_DISPLAY) and (FriendsFacts_Data[realm][name]) then
			
				nameLocationText = getglobal("FriendsFrameFriendButton"..(i-friendOffset).."ButtonTextNameLocation");
				infoText = getglobal("FriendsFrameFriendButton"..(i-friendOffset).."ButtonTextInfo");
				
				if (area == TEXT(UNKNOWN)) then 
					area = FriendsFacts_Data[realm][name].area;
				end
				--if ( not area ) then area = TEXT(UNKNOWN); end
				PVPName = FriendsFacts_Data[realm][name].PVPName;
				
				if (connected) then
					if (PVPName) and (FriendsFacts_PVPName) then
						nameLocationText:SetText(format(TEXT(FRIENDS_LIST_TEMPLATE), PVPName, area));
					else
						nameLocationText:SetText(format(TEXT(FRIENDS_LIST_TEMPLATE), name, area));
					end
				else
					if (PVPName) and (FriendsFacts_PVPName) then
						nameLocationText:SetText(format(TEXT(FRIENDS_LIST_OFFLINE_TEMPLATE), PVPName.." - "..area));
					else
						nameLocationText:SetText(format(TEXT(FRIENDS_LIST_OFFLINE_TEMPLATE), name.." - "..area));
					end
				end
				
				if ( nameLocationText:GetWidth() > 275 ) then
					--Auto-truncate long strings
					nameLocationText:SetJustifyH("LEFT");
					nameLocationText:SetWidth(275);
					nameLocationText:SetHeight(14);
				end
				
				if (level == 0) and (FriendsFacts_Data[realm][name].level) then
					level = FriendsFacts_Data[realm][name].level;
				end
				if (class == TEXT(UNKNOWN)) and (FriendsFacts_Data[realm][name].class) then 
					class = FriendsFacts_Data[realm][name].class;
				end
				race = FriendsFacts_Data[realm][name].race;
				if (race) then class = race.." "..class; end
				sex = FriendsFacts_Data[realm][name].sex;
				if (sex) then class = sex.." "..class; end
				guild = FriendsFacts_Data[realm][name].guild;
				if (guild) then class = class.." <"..guild..">"; end
				
				infoText:SetText(format(TEXT(FRIENDS_LEVEL_TEMPLATE), level, class));
				
				if ( infoText:GetWidth() > 275 ) then
					--Auto-truncate long strings
					infoText:SetJustifyH("LEFT");
					infoText:SetWidth(275);
					infoText:SetHeight(10);
				end
			end
		end
	end
end


function FriendsFacts_SetUnit(self, unit)
	SavedGameTooltip_SetUnit(self, unit);
	if (type(unit) ~= "string") then
		return;
	end
	if ( UnitIsPlayer(unit) ) then
		local realm = GetRealmName();
		local name = UnitName(unit);
		if (not FriendsFacts_Data[realm][name]) then
			return;
		end

		FriendsFacts_Data[realm][name].PVPName = UnitPVPName(unit);
		FriendsFacts_Data[realm][name].race = UnitRace(unit);
		if (UnitSex(unit) == 1) then
			FriendsFacts_Data[realm][name].sex = FEMALE;
		else
			FriendsFacts_Data[realm][name].sex = MALE;
		end
		FriendsFacts_Data[realm][name].guild, FriendsFacts_Data[realm][name].guildRankName = GetGuildInfo(unit);
	end
end

function FriendsFacts_Register_Khaos()
	local optionSet = {
		id="FriendsFacts";
		text=FRIENDSFACTS_CONFIG_HEADER;
		helptext=FRIENDSFACTS_CONFIG_HEADER_INFO;
		difficulty=1;
		default={checked=true};
		options={
			{
				id="Header";
				text=FRIENDSFACTS_CONFIG_HEADER;
				helptext=FRIENDSFACTS_CONFIG_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="FriendsFactsEnable";
				type=K_TEXT;
				text=FRIENDSFACTS_ENABLED;
				helptext=FRIENDSFACTS_ENABLED_INFO;
				callback=function(state)
					if (state.checked) then
						FriendsFacts_Enabled = true;
					else
						FriendsFacts_Enabled = nil;
					end
				end;
				feedback=function(state) return FRIENDSFACTS_ENABLED_INFO; end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="FriendsFactsPVPName";
				type=K_TEXT;
				text=FRIENDSFACTS_PVPNAME;
				helptext=FRIENDSFACTS_PVPNAME_INFO;
				callback=function(state)
					if (state.checked) then
						FriendsFacts_PVPName = true;
					else
						FriendsFacts_PVPName = nil;
					end
				end;
				feedback=function(state) return FRIENDSFACTS_PVPNAME_INFO; end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"other",
		optionSet
	);
end