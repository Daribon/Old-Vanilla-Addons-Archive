local WSC_UpdateRate = 0.1;
local WSC_TimeSinceLastUpdate = 0;
local WSC_PlayerFaction;
local WSC_AllianceFlagCarrier = "";
local WSC_HordeFlagCarrier = "";
local WSC_CurrentZone = "";
local WSC_PingX = 0;
local WSC_PingY = 0;
local WSC_NeedToJoinChan = false;
local WSC_OldChatFrameHandler;

WSC_Options = {
	Alpha = 1.0,
	Scale = 1.0,
	ShowBorders = true,
	AutoShow = false,
	posx = 0,
	posy = 0,
	Channel = "",
	EnablePings = true
};

function WSC_OnLoad()
	-- Register the slash command
	SLASH_WSC1 = "/wsc";
	SlashCmdList["WSC"] = function(msg)
		WSC_SlashCommand(msg);
	end
	
	WSC_PlayerFaction = UnitFactionGroup("player");
	
	this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	this:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	this:RegisterEvent("VARIABLES_LOADED");
	--this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	
	WSC_OldChatFrameHandler = ChatFrame_OnEvent;
	ChatFrame_OnEvent = WSC_NewChatFrameHandler;

end

function WSC_OnEvent()
	if ( event == "ZONE_CHANGED_NEW_AREA" ) then
		SetMapToCurrentZone(); -- hopefully this fixes the 'everything in right corner' bug
		
		WSC_CurrentZone = GetRealZoneText();

		if(WSC_Options.AutoShow == true) then
			--WSC_Print(WSC_CurrentZone .. " vs " .. WSC_Strings["zone"]);
			if(WSC_CurrentZone == WSC_Strings["zone"]) then
				--WSC_Print("showing");
				WSC_ShowFrame();
			else
				--WSC_Print("hiding");
				WSC_HideFrame();
			end
		end
	elseif (event == "CHAT_MSG_MONSTER_YELL" and WSC_Frame:IsVisible()) then
		if (arg2 == WSC_Strings["herald"]) then
			WSC_ParseHerald(arg1);
		end
	elseif ( event == "CHAT_MSG_CHANNEL" and WSC_Options.Channel and arg9 == WSC_Options.Channel ) then
		WSC_ParsePing(arg1);

	elseif(event == "VARIABLES_LOADED") then
		WSC_Options_Init();
		SetMapToCurrentZone();

		if(WSC_Options.ShowBorders == false) then
			WSC_BorderFrame:Hide();
		end

		-- myAddons support
 		if(myAddOnsList) then
			myAddOnsList.WarsongCommander = WSC_MyAddons;
		end

		WSC_CurrentZone = GetRealZoneText();
		--if(WSC_CurrentZone == WSC_Strings["zone"]) then
		--	if(WSC_Options.AutoShow == true) then
			--	WSC_Print("gonna show");
			--	WSC_ShowFrame();
		--	end
		--end
		ToggleWorldMap();
		ToggleWorldMap();
	elseif(event == "PLAYER_ENTERING_WORLD") then
		SetMapToCurrentZone();
	end
end

function WSC_SavePosition()
	--WSC_Print("saving position");
	if(WSC_Frame:GetLeft() == nil) then
		WSC_Options["posx"] = 0;
	else
		WSC_Options["posx"] = WSC_Frame:GetLeft();
	end
	if(WSC_Frame:GetBottom() == nil) then
		WSC_Options["posy"] = 0;
	else
		WSC_Options["posy"] = WSC_Frame:GetBottom();
	end
end

function WSC_RestorePosition()
	WSC_Frame:ClearAllPoints();
	WSC_Frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", WSC_Options["posx"],WSC_Options["posy"]);
end

function WSC_ShowFrame()
	WSC_UpdateAlpha();
	WSC_Frame:Show();
	WSC_UpdateScale();
	WSC_RestorePosition();
	
	-- leave/join the channel
	if(WSC_Options.EnablePings == true) then
		if ( WSC_Options.Channel ) then
			--WSC_Print("leaving channel " .. WSC_Options.Channel);

			LeaveChannelByName(WSC_Options.Channel);
		end
		WSC_NeedToJoinChan = true;
		--WSC_Options.Channel = nil;
	end

end

function WSC_HideFrame()
	WSC_Frame:Hide();
	
	if(WSC_Options.EnablePings == true) then
		if ( WSC_Options.Channel ) then
			LeaveChannelByName(WSC_Options.Channel);
		end
	end
end

function WSC_ToggleFrame()
	if(WSC_Frame:IsShown()) then
		--WSC_Print(WSC_Frame:GetLeft());
		--WSC_Print(WSC_Frame:GetBottom());
		--WSC_Print("hidinging");
		WSC_HideFrame();
	elseif(GetRealZoneText() == WSC_Strings["zone"]) then
	--WSC_Print("showinging");
		WSC_ShowFrame();
	else
		WSC_Print("Warsong Commander will only be displayed while in " .. WSC_Strings["zone"] .. ".");
	end
end

function WSC_UpdateAlpha()
	WSC_BorderFrame:SetAlpha(WSC_Options.Alpha);
	WSC_WrapperFrame:SetAlpha(WSC_Options.Alpha);
end

function WSC_ToggleBorders()
	if(WSC_BorderFrame:IsVisible()) then
		WSC_BorderFrame:Hide();
		WSC_Options.ShowBorders = false;
	else
		WSC_BorderFrame:Show();
		WSC_Options.ShowBorders = true;
	end
end

function WSC_TogglePing()
	if(WSC_Options.EnablePings == true) then
		WSC_Options.EnablePings = false;
	else
		WSC_Options.EnablePings = true;
	end
end

function WSC_ToggleAutoShow()
	if(WSC_Options.AutoShow == true) then
		WSC_Options.AutoShow = false;
	else
		WSC_Options.AutoShow = true;
	end
end

function WSC_UpdateScale()
	local x, y, halfx, halfy, newx, newy, old;
	x = WSC_Frame:GetLeft();
	y = WSC_Frame:GetBottom();

	WSC_Frame:ClearAllPoints();
	WSC_Frame:SetPoint("CENTER", "UIParent", "CENTER");

	halfx = (WSC_Frame:GetLeft() * 2);
	halfy = (WSC_Frame:GetBottom() * 2);
	
	old = WSC_Frame:GetScale();
	WSC_Frame:SetScale(WSC_Options.Scale);
	WSC_Options.Scale = WSC_Frame:GetScale();
	old = old - WSC_Frame:GetScale();
	if old ~= 0 then
		WSC_Frame:ClearAllPoints();
		WSC_Frame:SetPoint("CENTER", "UIParent", "CENTER");

		newx = (WSC_Frame:GetLeft() * 2);
		newy = (WSC_Frame:GetBottom() * 2);

		x = ((newx / halfx) * x);
		y = ((newy / halfy) * y);
		WSC_Frame:ClearAllPoints();
		WSC_Frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x, y);
	else
		WSC_Frame:ClearAllPoints();
		WSC_Frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x, y);
	end

end

function WSC_ResetPos()
	WSC_Frame:ClearAllPoints();
	WSC_Frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
end

function WSC_SlashCommand(msg)
	if(msg == "config") then
		WSC_Options_Toggle();
	elseif(msg == "reset") then
		WSC_ResetPos();
	else
		WSC_ToggleFrame();
	end
end

function WSC_ParsePing(msg)
	if(string.sub(msg, 0, 4) ~= "PING") then return end
	
	msg = string.sub(msg, 6);
	local comma,_ = string.find(msg, ",");
	local x = string.sub(msg, 0, comma-1);
	local y = string.sub(msg, comma + 1);

	if(not tonumber(x)) then
		WSC_Print("bad x (" .. x .. ")");
		return;
	end
	
	if(not tonumber(y)) then
		WSC_Print("bad y (" .. y .. ")");
		return;
	end
	
	WSC_PingX = tonumber(x);
	WSC_PingY = tonumber(y);
	WSC_DrawPing(WSC_PingX, WSC_PingY, true);
	WSC_Ping.timer = MINIMAPPING_TIMER;
end

function WSC_PingMap(arg1)
	if(WSC_Options.EnablePings == false) then return end
	
	local x, y = GetCursorPosition();
	local centerX, centerY = this:GetCenter();
	x = x / this:GetScale();
	y = y / this:GetScale();

	
	local width = WSC_Frame:GetWidth();
	local height = WSC_Frame:GetHeight();

	x = (x - (centerX - (width/2))) / width;
	y = (centerY + (height/2) - y) / height;

	-- broadcast to channel
	if ( WSC_Options.Channel and GetChannelName(WSC_Options.Channel)) then
		SendChatMessage("PING " .. x .. "," .. y, "CHANNEL", nil, GetChannelName(WSC_Options.Channel));
	end
end

function WSC_DrawPing(x,y, playsound)
	if(not WSC_Frame:IsShown()) then return end
	WSC_Ping:ClearAllPoints();
	WSC_Ping:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", x * WSC_WrapperFrame:GetWidth(), -y * WSC_WrapperFrame:GetHeight());
	WSC_Ping:SetAlpha(255);
	WSC_Ping:Show();
	
	if(playsound) then
		PlaySound("MapPing");
	end
end

-- based on code from the BGFlag mod
function WSC_ParseHerald(text)

	local player
	local faction
	local flagStatus
	
	--first get flag status
	if(strfind(text, WSC_Strings["picked"])) then
		flagStatus = WSC_Strings["picked"];
	elseif(strfind(text, WSC_Strings["captured"])) then
		flagStatus = WSC_Strings["captured"];
	elseif(strfind(text, WSC_Strings["wins"])) then
		flagStatus = WSC_Strings["wins"];
	elseif(strfind(text, WSC_Strings["returned"])) then
		flagStatus = WSC_Strings["returned"];
	elseif(strfind(text, WSC_Strings["dropped"])) then
		flagStatus = WSC_Strings["dropped"];
	else
		flagStatus = "";
	end
	
	--faction is going to be Alliance or Horde
	index = strfind(text, WSC_Strings["horde"]);
	if(strfind(text, WSC_Strings["horde"])) then
		faction = WSC_Strings["horde"];
	elseif(strfind(text, WSC_Strings["alliance"])) then
		faction = WSC_Strings["alliance"];
	end

	--get the player who has the flag, only if the status is picked
	if (flagStatus == WSC_Strings["picked"] ) then
		--to be added for localization (blatantly stolen from BGFlag)
		if ( GetLocale() == "frFR") then
			if (strfind(text, " par ")) then
				player = strsub(text, strfind(text, " par ")+5, strlen(text)-2);
			end
		elseif ( GetLocale() == "deDE") then
			if (strfind(text, WSC_Strings["picked"])) then
				_,_,player = strfind(text, "(%w+) hat die Flagge");
			end
		else
			WSC_Print("waspicked");
			if (strfind(text, " by ")) then
				player = strsub(text, strfind(text, " by ")+4, strlen(text)-1);
				WSC_Print("by " .. player);
			end
		end
	elseif (flagStatus == WSC_Strings["dropped"] ) then
		player = WSC_Strings["dropped"];
	elseif (flagStatus == WSC_Strings["captured"] or flagStatus == WSC_Strings["returned"] or flagStatus == "") then
		player = WSC_Strings["atbase"];
	end
	
	if(faction == WSC_Strings["alliance"]) then
		WSC_AllianceFlagCarrier = player;
		WSG_AllianceCarrier:SetText(WSC_AllianceFlagCarrier);
	elseif (faction == WSC_Strings["horde"]) then
		WSC_HordeFlagCarrier = player;
		WSG_HordeCarrier:SetText(WSC_HordeFlagCarrier);
	end

end

function WSC_CorrectXCoord(x)
	local width = WSC_WrapperFrame:GetWidth();

	x = x * width * 2;

	if(x < width / 2) then
		x = 0;
	else
		x = x - width / 2;
	end
	
	if(x > width) then
		x = width;
	end
	
	return x;
end

function WSC_OnUpdate(arg1)
	WSC_TimeSinceLastUpdate = WSC_TimeSinceLastUpdate + arg1;
	if(WSC_TimeSinceLastUpdate < WSC_UpdateRate) then return end
	
	if(WSC_NeedToJoinChan == true) then
		local status, mapName, instanceID = GetBattlefieldStatus();
		if(instanceID == nil) then
			instanceID = 0;
		end
		local channame = "WSCWG" .. instanceID;
	
		if(WSC_Options.Channel and GetChannelName(WSC_Options.Channel) ~= 0) then
			WSC_NeedToJoinChan = false;
		end

		WSC_Options.Channel = 0;
		
		--WSC_Print("WSC auto-joining channel: " .. channame);
	
		if (WSC_Options.Channel == nil or GetChannelName(WSC_Options.Channel) == 0 ) then
			local zoneChannel, channelName = JoinChannelByName(channame, nil, DEFAULT_CHAT_FRAME:GetID());
			
			WSC_Options.Channel = channame;

			if ( channelName ) then
				channame = channelName;
			end
			if ( not zoneChannel ) then
				return;
			end
			
			local i = 1;
	
			while ( DEFAULT_CHAT_FRAME.channelList[i] ) do
				i = i + 1;
			end
			DEFAULT_CHAT_FRAME.channelList[i] = channame;
			DEFAULT_CHAT_FRAME.zoneChannelList[i] = zoneChannel;
		else
			WSC_Print("already in channel " .. WSC_Options.Channel);
		end
	end
	
	local width = WSC_WrapperFrame:GetWidth();
	local height = WSC_WrapperFrame:GetHeight();
	local x, y = GetPlayerMapPosition("player");

	x = WSC_CorrectXCoord(x);
	y = y * height;
	
	WSC_Player:ClearAllPoints();
	WSC_Player:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", x, -y);

	
	local playerCount = 0;
	if ( GetNumRaidMembers() > 0 ) then
		for i=1, MAX_PARTY_MEMBERS do
			partyMemberFrame = getglobal("WSC_Party"..i);
			partyMemberFrame:Hide();
		end
		for i=1, MAX_RAID_MEMBERS do
			partyX, partyY = GetPlayerMapPosition("raid"..i);
			partyMemberFrame = getglobal("WSC_Raid"..playerCount + 1);
			if ( (partyX ~= 0 or partyY ~= 0) and not UnitIsUnit("raid"..i, "player") ) then
				partyX = WSC_CorrectXCoord(partyX);
				partyY = -partyY * height;
				partyMemberFrame:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", partyX, partyY);
				partyMemberFrame.name = nil;
				partyMemberFrame:Show();
				playerCount = playerCount + 1;
			end
		end
	else
		for i=1, MAX_PARTY_MEMBERS do
			partyX, partyY = GetPlayerMapPosition("party"..i);
			partyMemberFrame = getglobal("WSC_Party"..i);
			if ( partyX == 0 and partyY == 0 ) then
				partyMemberFrame:Hide();
			else
				partyX = WSC_CorrectXCoord(partyX);
				partyY = -partyY * height;
				partyMemberFrame:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", partyX, partyY);
				partyMemberFrame:Show();
			end
		end
	end
	-- Position Team Members
	local numTeamMembers = GetNumBattlefieldPositions();
	--for i=playerCount+1, MAX_RAID_MEMBERS do
	for i=playerCount+1, 20 do
		partyX, partyY, name = GetBattlefieldPosition(i - playerCount);
		partyMemberFrame = getglobal("WSC_Raid"..i);
		if ( partyX == 0 and partyY == 0 ) then
			partyMemberFrame:Hide();
		else
			partyX = WSC_CorrectXCoord(partyX);
			partyY = -partyY * height;
			partyMemberFrame:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", partyX, partyY);
			partyMemberFrame.name = name;
			partyMemberFrame:Show();
		end
	end

	-- Position flags
	local flagX, flagY, flagToken, flagFrame, flagTexture;
	local numFlags = GetNumBattlefieldFlagPositions();
	for i=1, numFlags do
		flagX, flagY, flagToken = GetBattlefieldFlagPosition(i);
		flagFrame = getglobal("WSC_Flag"..i);
		flagTexture = getglobal("WSC_Flag"..i.."Texture");
		if ( flagX == 0 and flagY == 0 ) then
			flagFrame:Hide();
		else
			flagX = WSC_CorrectXCoord(flagX);
			flagY = -flagY * height;
			flagFrame:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", flagX, flagY);
			flagTexture:SetTexture("Interface\\WorldStateFrame\\"..flagToken);
			flagFrame:Show();
		end
	end
	for i=numFlags+1, NUM_WORLDMAP_FLAGS do
		flagFrame = getglobal("WSC_Flag"..i);
		flagFrame:Hide();
	end

	-- Position corpse
	local corpseX, corpseY = GetCorpseMapPosition();
	if ( corpseX == 0 and corpseY == 0 ) then
		WSC_Corpse:Hide();
	else
		corpseX = WSC_CorrectXCoord(corpseX);
		corpseY = -corpseY * height;
		
		WSC_Corpse:SetPoint("CENTER", "WSC_WrapperFrame", "TOPLEFT", corpseX, corpseY);
		WSC_Corpse:Show();
	end

	WSC_TimeSinceLastUpdate = 0;
end

function WSC_OnEnter()
	-- Adjust the tooltip based on which side the unit button is on
	local x, y = this:GetCenter();
	local parentX, parentY = this:GetParent():GetCenter();
	if ( x > parentX ) then
		WSC_Tooltip:SetOwner(this, "ANCHOR_LEFT");
	else
		WSC_Tooltip:SetOwner(this, "ANCHOR_RIGHT");
	end
	
	-- See which POI's are in the same region and include their names in the tooltip
	local unitButton;
	local newLineString = "";
	local tooltipText = "";
	
	-- Check player
	if ( MouseIsOver(WSC_Player) ) then
		tooltipText = UnitName(WSC_Player.unit);
		newLineString = "\n";
	end
	-- Check party
	for i=1, MAX_PARTY_MEMBERS do
		unitButton = getglobal("WSC_Party"..i);
		if ( unitButton:IsVisible() and MouseIsOver(unitButton) and UnitName(unitButton.unit)) then
			tooltipText = tooltipText..newLineString..UnitName(unitButton.unit);
			newLineString = "\n";
		end
	end
	--Check Raid
	for i=1, 15 do -- or i=1, MAX_RAID_MEMBERS do
		unitButton = getglobal("WSC_Raid"..i);
		if ( unitButton:IsVisible() and MouseIsOver(unitButton) ) then
			-- Handle players not in your raid or party, but on your team
			if ( unitButton.name ) then
				tooltipText = tooltipText..newLineString..unitButton.name;		
			else
				if(UnitName(unitButton.unit) == nil) then
					WSC_Print("unit was " .. unitButton.unit);
				else
					tooltipText = tooltipText..newLineString..UnitName(unitButton.unit);
				end
			end
			newLineString = "\n";
		end
	end
	WSC_Tooltip:SetText(tooltipText);
	WSC_Tooltip:Show();
end

function WSC_POI_OnClick(arg1)
	TargetUnit(this.unit);
end

function WSC_Flag_OnClick(arg1)
	if(WSC_FlagCarrier == "") then return end
	
	if(WSC_PlayerFaction == WSC_Strings["alliance"]) then
		TargetByName(WSC_AllianceFlagCarrier);
	elseif(WSC_PlayerFaction == WSC_Strings["horde"]) then
		TargetByName(WSC_HordeFlagCarrier);
	end
end

function WSC_Print(msg)
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

-- mostly based on the stock minimap ping code
function WSC_Ping_OnLoad()
	WSC_Ping.fadeOut = nil;
	this:SetSequence(0);
end

function WSC_Ping_OnUpdate(elapsed)
	if ( WSC_Ping.timer > 0 ) then
		WSC_Ping.timer = WSC_Ping.timer - elapsed;
		if (WSC_Ping.timer <= 0 ) then
			WSC_Ping_FadeOut();
		else
			WSC_DrawPing(WSC_PingX, WSC_PingY);
		end
	elseif ( WSC_Ping.fadeOut ) then
		WSC_Ping.fadeOutTimer = WSC_Ping.fadeOutTimer - elapsed;
		if ( WSC_Ping.fadeOutTimer > 0 ) then
			WSC_Ping:SetAlpha(255 * (WSC_Ping.fadeOutTimer/MINIMAPPING_FADE_TIMER))
		else
			WSC_Ping.fadeOut = nil;
			WSC_Ping:Hide();
		end
	end
 end

function WSC_Ping_FadeOut()
	WSC_Ping.fadeOut = 1;
	WSC_Ping.fadeOutTimer = MINIMAPPING_FADE_TIMER;
end

-- Override the chat frame handler to hide ping events
function WSC_NewChatFrameHandler(event)
	-- There is a channel
	if ( WSC_Options.EnablePings == true and strsub(event, 1, 16) == "CHAT_MSG_CHANNEL" and WSC_Options.Channel and arg9 and strlower(arg9) == strlower(WSC_Options.Channel)) then
		--WSC_Print("suppressing chat message: " .. arg1);
		return;
	end
	WSC_OldChatFrameHandler(event);
end
