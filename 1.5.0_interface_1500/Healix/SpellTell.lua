SpellTell_channelName = nil;
SPELLTELL_SERVERMSG = "<SpellTell>";
SpellTell_startTime = {nil,nil,nil,nil}; 
SpellTell_maxValue = {nil,nil,nil,nil};
SpellTell_casting = {nil,nil,nil,nil};

--OnLoad Event stuff
function SpellTell_OnLoad()
	this:RegisterEvent("SPELLCAST_START"); 
	this:RegisterEvent("SPELLCAST_STOP"); 
	this:RegisterEvent("SPELLCAST_DELAYED"); 
	this:RegisterEvent("SPELLCAST_FAILED");  
	this:RegisterEvent("SPELLCAST_INTERRUPTED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
end

function SpellTell_OnShow()
	local text; local bar; local frame;
	if (not PartyComm_OnPCChatEvent) then
		Hx_Print("SpellTell Disabled! You do not have PartyComm");
		SpellTellFrame:Hide();
		return;
	end
	if (HxToggle.SpellTell ~= 1)  then
		if (not SpellTellFrame:IsVisible()) then
			SpellTellFrame:Show();
		end
		for x=1, 4, 1 do 
			text = getglobal("STPartyFrame"..x.."Text"); text:SetText(UnitName("party"..x)); 
		end
		for x=1, 4, 1 do
			frame = getglobal("STPartyFrame"..x);
			if (GetNumPartyMembers() > x) then
				frame:Show();
			elseif (GetNumPartyMembers() == x) then
				frame:Show();
			else
				frame:Hide();
			end
		end
	else
		SpellTellFrame:Hide(); 
	end
	for x=1, 4, 1 do
		text = getglobal("STPartyFrame"..x.."Text"); 
		frame = getglobal("STPartyFrame"..x); 
		bar = getglobal("STPartyFrame"..x.."Bar");
		text:SetTextColor(1,1,1);
		bar:SetStatusBarColor(0.0, 0.0, 1.0);
		frame:SetAlpha(0.2);
	end
	-- PartyComm hooking:
	Hx_Hook("PartyComm_OnPCChatMessage","SpellTell_OnPCChatMessage","after");
end
function SpellTellOnSpellcast(target)
	-- LET PARTY KNOW WHAT YOU ARE DOING:
	if (not PartyComm_GetPCChannelIndex) then
		return;
	end
	index = PartyComm_GetPCChannelIndex();
	if (SpellTog[Class][SName] ~= 1 or not PartyComm_OnPCChatEvent) then return; end
	if (index and index > 0 and target) then
		if (UnitName("player") ~= nil) then
			local message = "Player=" .. UnitName("player") .."; Casting=".. SName .."; Duration=".. STime .. "; Target=" .. target;
			SendChatMessage(SPELLTELL_SERVERMSG .. message, "CHANNEL", nil, index);
		end
	end
end

-- Called on Event
function SpellTell_OnEvent()
	if (not PartyComm_GetPCChannelIndex) then
		return;
	end
	index =  PartyComm_GetPCChannelIndex();
	if (event == "PARTY_MEMBERS_CHANGED") then
		for x=1, 4, 1 do
			frame = getglobal("STPartyFrame"..x);
			if (GetNumPartyMembers() > x) then
				frame:Show();
			else
				frame:Hide();
			end
		end		
	elseif (event == "SPELLCAST_DELAYED" and index and index > 0) then
		-- thrown when you get interrupted while casting (you get hit and the spell takes longer)-- arg1 Disruption time
		-- LET PARTY KNOW WHAT YOU ARE DOING:
		if (UnitName("player") ~= nil) then
			local message = "Player=" .. UnitName("player") .."; Casting Delayed=" .. (arg1/1000);
			SendChatMessage(SPELLTELL_SERVERMSG .. message, "CHANNEL", nil, index);
		end
	elseif (event == "SPELLCAST_FAILED" and index and index > 0) then
		-- thrown when a spell fails (shield-bash or something?)
		-- LET PARTY KNOW WHAT YOU ARE DOING:
		if (UnitName("player") ~= nil) then
			local message = "Player=" .. UnitName("player") .."; Casting Failed";
			SendChatMessage(SPELLTELL_SERVERMSG .. message, "CHANNEL", nil, index);
		end
	elseif (event == "SPELLCAST_INTERRUPTED" and index and index > 0) then
		-- thrown when a spell is interrupted (moved or pressed esc or something?)
		-- LET PARTY KNOW WHAT YOU ARE DOING:
		local message = "Player=" .. UnitName("player") .."; Casting Interrupted";
		SendChatMessage(SPELLTELL_SERVERMSG .. message, "CHANNEL", nil, index);
	elseif (event == "SPELLCAST_STOPPED" and index and index > 0 ) then
		local message = "Player=" .. UnitName("player") .."; Casting Stopped";
		SendChatMessage(SPELLTELL_SERVERMSG .. message, "CHANNEL", nil, index);
	end
end

-- Called on Update
function SpellTell_OnUpdate()
	local time = GetTime();
	for x=1, 4, 1 do
		bar = getglobal("STPartyFrame"..x.."Bar");
		if ( SpellTell_casting[x] ) then
			if ( time > SpellTell_maxValue[x] ) then
				time = SpellTell_maxValue[x];
			end
			bar:SetValue(time);
		end
	end
	local now = GetTime();
	for x=1, 4, 1 do
		text = getglobal("STPartyFrame"..x.."Text");
		frame = getglobal("STPartyFrame"..x);
		bar = getglobal("STPartyFrame"..x.."Bar");
		if (bar:IsVisible() ) then
			if (SpellTell_maxValue[x] ~= nil) then
				if (now > SpellTell_maxValue[x]+2 ) then
					text:SetText("");
					frame:SetAlpha(0.2);
					SpellTell_maxValue[x] = nil;
					SpellTell_casting[x] = nil;
				end
			end
		end
	end
end

function SpellTell_GetPartyNrOfPlayer(playerName)
	for x=1, 4, 1 do
		if (UnitName("party"..x) == playerName) then return x; end
	end
	return nil;
end

function SpellTell_PlayerStartedCasting(partyNr, spell, duration, target)
	local bar = getglobal("STPartyFrame"..partyNr.."Bar");
	local frame = getglobal("STPartyFrame"..partyNr);
	local text = getglobal("STPartyFrame"..x.."Text");
	local down, up, lag = GetNetStats();			-- take lag into account (already subtracted sending player's lag)
	local duration = duration - (lag/1000);
	bar:SetStatusBarColor(0.0, 0.0, 1.0);
	SpellTell_startTime[partyNr] = GetTime();
	SpellTell_maxValue[partyNr] = SpellTell_startTime[partyNr] + duration ;
	bar:SetMinMaxValues(SpellTell_startTime[partyNr], SpellTell_maxValue[partyNr]);
	bar:SetValue(SpellTell_startTime[partyNr]);
	text:SetText("" .. spell .. " : " .. target);
	frame:SetAlpha(1.0);
	SpellTell_casting[partyNr] =  1;
	frame:Show();
end

function SpellTell_PlayerDelayed(partyNr, delay)
	SpellTell_startTime[partyNr] = SpellTell_startTime[partyNr] + delay;
	SpellTell_maxValue[partyNr] = SpellTell_maxValue[partyNr] + delay;
	getglobal("STPartyFrame"..partyNr.."Bar"):SetMinMaxValues(SpellTell_startTime[partyNr], SpellTell_maxValue[partyNr]);
end
function SpellTell_PlayerFailed(partyNr)
	getglobal("STPartyFrame"..partyNr.."Bar"):SetValue(SpellTell_startTime[partyNr]);
	getglobal("STPartyFrame"..partyNr.."Text"):SetText("Failed!");
	SpellTell_casting[partyNr] = nil;
	SpellTell_maxValue[partyNr] = GetTime();
end
function SpellTell_PlayerInterrupted(partyNr)
		getglobal("STPartyFrame"..partyNr.."Bar"):SetValue(SpellTell_startTime[partyNr] );
		getglobal("STPartyFrame"..partyNr.."Text"):SetText("Interrupted!");
		SpellTell_casting[partyNr] = nil;
		SpellTell_maxValue[partyNr] = GetTime();
end

-- PartyComm functions:
function SpellTell_OnPCChatMessage(channelName, player, message) -- Called when a message is sent to a PartyComm channel
	-- this is where I get info on what the other players in party are doing...
	if (strfind(message, SPELLTELL_SERVERMSG) ) then
		message = string.gsub(message, SPELLTELL_SERVERMSG, ""); -- remove SPELLTELL_SERVERMSG
		local iStart = string.find(message, "="); local iEnd = string.find(message, ";");
		local partyNr = SpellTell_GetPartyNrOfPlayer(player);
		if (player == UnitName("player") or partyNr == nil) then return; end --is from yourself or not in party...
		if (string.find(message, "=", iEnd) ) then
			-- either casting, or delayed
			if (string.find(message, "Delayed", iEnd) ) then
				-- delayed
				iStart = string.find(message, "=", iEnd); iEnd = string.len(message);
				local delayed = string.sub(message, iStart+1, iEnd);
				-- handle delayd for nr partyNr
				SpellTell_PlayerDelayed(partyNr, delayed);
			else
				-- casting
				iStart = string.find(message, "=", iEnd); iEnd = string.find(message, ";", iStart);
				local spell = string.sub(message, iStart+1, iEnd-1);
				iStart = string.find(message, "=", iEnd); iEnd = string.find(message, ";", iStart);
				local duration = string.sub(message, iStart+1, iEnd-1);
				iStart = string.find(message, "=", iEnd); iEnd = string.len(message);
				local target = string.sub(message, iStart+1, iEnd);	
				-- take lag into account
				local down, up, lag = GetNetStats();
				duration = duration - (lag/1000);
				-- handle casting for nr partyNr
				SpellTell_PlayerStartedCasting(partyNr, spell, duration, target);
			end
		else
			-- casting failed or interrupted or stopped
			if (string.find(message, "Failed", iEnd) ) then
				SpellTell_PlayerFailed(partyNr);-- failed. handle failed for nr partyNr
			elseif (string.find(message, "Stopped", iEnd) ) then
				getglobal("STPartyFrame"..partyNr.."Text"):SetText("");
				SpellTell_Casting[partyNr] = nil;
			else
				SpellTell_PlayerInterrupted(partyNr); -- interrupted. handle interrupted for nr partyNr
			end
		end
	end
end