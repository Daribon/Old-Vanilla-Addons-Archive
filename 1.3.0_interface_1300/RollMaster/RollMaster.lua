--[[
	RollMaster

	By sarf

	This mod will keep track of rolls.

	Thanks goes to krawz for this one.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

ROLLMASTER_VERSION		= "0.03-alpha";

-- Variables



RollMaster_CurrentRoll = nil;
RollMaster_IsStarter = false;

RollMaster_ShouldAutoRoll = 1;
RollMaster_ShouldReportAttemptedExtraRolls = 1;


RollMaster_RollMin = 1;
RollMaster_RollMax = 100;

RollMaster_Rolls = {};

function RollMaster_OnLoad()
	RegisterForSave("RollMaster_ShouldAutoRoll");
	SlashCmdList["ROLLMASTERSLASHMAIN"] = RollMaster_Main_ChatCommandHandler;
	for k, v in ROLLMASTER_CHAT_CMDS do
		setglobal("SLASH_ROLLMASTERSLASHMAIN"..k, v);
	end
	for k, v in ChatTypeGroup["SYSTEM"] do
		this:RegisterEvent(v);
	end
	for k, v in ChatTypeGroup["SAY"] do
		this:RegisterEvent(v);
	end
	for k, v in ChatTypeGroup["PARTY"] do
		this:RegisterEvent(v);
	end
	
	RollMaster_ReportVersion()
	RollMaster_ReportAutoRoll();
end

function RollMaster_ReportVersion()
	RollMaster_Print(format(ROLLMASTER_CHAT_STARTUP, ROLLMASTER_VERSION));
end

function RollMaster_OnEvent(event)
	if ( RollMaster_IsInList(event, ChatTypeGroup["SYSTEM"]) ) then
		RollMaster_OnSystemChatMessageEvent(arg1);
		return;
	end
	if ( RollMaster_IsInList(event, ChatTypeGroup["SAY"]) ) or
		( RollMaster_IsInList(event, ChatTypeGroup["PARTY"]) ) then
		RollMaster_OnNormalChatMessageEvent(arg1);
		return;
	end
end

function RollMaster_IsInRaid()
	return ( GetNumRaidMembers() > 0 );
end

function RollMaster_IsInParty()
	return ( GetNumPartyMembers() > 0 );
end


function RollMaster_SendChatMessage(message)
	local messageType = "SAY";
	if ( RollMaster_IsInRaid() ) then
		messageType = "RAID";
	elseif ( RollMaster_IsInParty() ) then
		messageType = "PARTY";
	end
	SendChatMessage(message, messageType, DEFAULT_CHAT_FRAME.defaultLanguage);
end

function RollMaster_StartRolls()
	RollMaster_IsStarter = true;
	RollMaster_Rolls = {};
	
	RollMaster_HandleString(ROLLMASTER_CHAT_START_ROLLS);
	RollMaster_HandleString(format(ROLLMASTER_CHAT_ASK_ROLL_FORMAT, RollMaster_RollMin, RollMaster_RollMax));
end

function RollMaster_HandleString(str)
	RollMaster_SendChatMessage(str);
end

function RollMaster_IsInList(value, list)
	for k, v in list do
		if ( v == value ) then
			return true;
		end
	end
	return false;
end

function RollMaster_GetNumberOfNonRollers()
	local players = RollMaster_GetPlayerList();
	local notRolledPlayers = {};
	for k, v in players do
		if ( not RollMaster_Rolls[v] ) then
			table.insert(notRolledPlayers, v);
		end
	end
	return table.getn(notRolledPlayers);
end

function RollMaster_ListRolls()
	local players = RollMaster_GetPlayerList();
	local notRolledPlayers = {};
	local highRoll = -1;
	local highRollData = nil;
	for k, v in players do
		if ( not RollMaster_Rolls[v] ) then
			table.insert(notRolledPlayers, v);
		else
			if ( RollMaster_Rolls[v].rollResult > highRoll ) then
				highRollData = RollMaster_Rolls[v];
				highRoll = highRollData.rollResult;
			end
		end
	end
	if ( not highRollData ) then
		RollMaster_HandleString(ROLLMASTER_CHAT_NO_ONE_ROLLED);
		return;
	else
		RollMaster_HandleString(format(ROLLMASTER_CHAT_HIGH_ROLLER, highRollData.playerName, highRollData.rollResult));
		local str = "";
		local size = table.getn(notRolledPlayers);
		if ( size > 0 ) then
			for i = 1, size do
				if ( i ~= 1 ) then
					str = str..", "..notRolledPlayers[i];
				else
					str = notRolledPlayers[i];
				end
			end
			RollMaster_HandleString(format(ROLLMASTER_CHAT_LIST_HAS_NOT_ROLLED, str));
		end
		if ( RollMaster_ShouldReportAttemptedExtraRolls == 1 ) then
			local timeRollers = {};
			for k, v in RollMaster_Rolls do
				if ( v.rolls > 1 ) then
					local element = {};
					element.name = k;
					element.rolls = v;
					table.insert(timeRollers, element);
				end
			end
			size = table.getn(timeRollers);
			if ( size > 0 ) then
				str = "";
				for i = 1, size do
					if ( i ~= 1 ) then
						str = str..format(", %s (%d)", timeRollers[i].name, timeRollers[i].rolls);
					else
						str = format("%s (%d)", timeRollers[i].name, timeRollers[i].rolls);
					end
				end
				RollMaster_HandleString(format(ROLLMASTER_CHAT_LIST_HAS_ROLLED_MORE, str));
			end
		end
	end
end

function RollMaster_StopRolls()
	RollMaster_HandleString(ROLLMASTER_CHAT_END_ROLLS);
	RollMaster_ListRolls();
	RollMaster_IsStarter = false;
end

RollMaster_PartyUnits = {
		[1] = "party1",
		[2] = "party2",
		[3] = "party3",
		[4] = "party4",
};

function RollMaster_GetPlayerList()
	local list = {};
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local raidSize = GetNumRaidMembers();
	local partySize = GetNumPartyMembers();
	if ( raidSize > 0 ) then
		for i = 1, raidSize do
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			table.insert(list, name);
		end
	elseif ( partySize > 0 ) then
		for i = 1, partySize do
			table.insert(list, UnitName(RollMaster_PartyUnits[i]));
		end
		table.insert(list, UnitName("player"));
	else
		table.insert(list, UnitName("player"));
	end
	return list;
end

function RollMaster_UseRollResult(playerName, rollResult, rollMin, rollMax)
	local element = {};
	if ( RollMaster_Rolls[playerName] ) then
		element = RollMaster_Rolls[playerName];
	else
		element.rolls = 1;
	end
	element.playerName = playerName;
	element.rollResult = rollResult;
	element.rollMin = rollMin;
	element.rollMax = rollMax;
	RollMaster_Rolls[playerName] = element;
end

function RollMaster_HandleRollResult(playerName, rollResult, rollMin, rollMax)
	if ( not RollMaster_IsInList(playerName, RollMaster_GetPlayerList() ) ) then
		return false;
	end
	if ( type(rollResult) == "string" ) then
		rollResult = tonumber(rollResult);
	end
	if ( type(rollMin) == "string" ) then
		rollMin = tonumber(rollMin);
	end
	if ( type(rollMax) == "string" ) then
		rollMax = tonumber(rollMax);
	end
	if ( RollMaster_Rolls[playerName] ) then
		if ( not RollMaster_Rolls[playerName].rolls ) then
			RollMaster_Rolls[playerName].rolls = 1;
		end
		RollMaster_Rolls[playerName].rolls = RollMaster_Rolls[playerName].rolls + 1;
		if ( rollMin == RollMaster_RollMin ) and ( rollMax == RollMaster_RollMax ) then
			if ( RollMaster_Rolls[playerName].rollMin ~= RollMaster_RollMin ) or ( RollMaster_Rolls[playerName].rollMax ~= RollMaster_RollMax ) then
				RollMaster_UseRollResult(playerName, rollResult, rollMin, rollMax);
			end
		end
	else
		if ( rollMin == RollMaster_RollMin ) and ( rollMax == RollMaster_RollMax ) then
			RollMaster_UseRollResult(playerName, rollResult, rollMin, rollMax);
		end
	end
	if ( RollMaster_GetNumberOfNonRollers() <= 0 ) and ( RollMaster_IsStarter ) then
		RollMaster_StopRolls();
	end
end

function RollMaster_OnSystemChatMessageEvent(message)
	for playerName, rollResult, rollMin, rollMax in string.gfind(message, ROLLMASTER_CHAT_ROLL_GSUB) do
		RollMaster_HandleRollResult(playerName, rollResult, rollMin, rollMax);
		break;
	end
end


function RollMaster_Print(message, r, g, b)
	if ( not r ) then r = 1; end
	if ( not g ) then g = 1; end
	if ( not b ) then b = 0; end
	if ( Print ) then
		Print(message, r, g, b);
		return;
	end
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(message, r, g, b);
	end
end

function RollMaster_RequestRandomRoll(rollMin, rollMax)
	if ( RollMaster_ShouldAutoRoll == 1 ) then
		RollMaster_DoRandomRoll(rollMin, rollMax);
	else
		RollMaster_CurrentRoll = { rollMin, rollMax };
		RollMaster_Print(TEXT(ROLLMASTER_CHAT_ROLL_REQUESTED));
	end
end

function RollMaster_DoRandomRoll(rollMin, rollMax)
	RandomRoll(rollMin, rollMax);
end

function RollMaster_OnNormalChatMessageEvent(message)
	for rollMin, rollMax in string.gfind(message, ROLLMASTER_CHAT_ASK_ROLL_GSUB) do
		RollMaster_RequestRandomRoll(rollMin, rollMax);
		break;
	end
end

function RollMaster_Main_ChatCommandHandler(param)
	if ( not param ) then
		RollMaster_Print(ROLLMASTER_CHAT_CMDS_USAGE);
		return;
	end
	if ( RollMaster_IsInList(param, ROLLMASTER_CHAT_CMDS_START) ) then
		RollMaster_StartRolls();
		return;
	elseif ( RollMaster_IsInList(param, ROLLMASTER_CHAT_CMDS_STOP) ) then
		RollMaster_StopRolls();
		return;
	elseif ( RollMaster_IsInList(param, ROLLMASTER_CHAT_CMDS_LIST) ) then
		local tmpFunc = RollMaster_HandleString;
		RollMaster_HandleString = RollMaster_Print;
		RollMaster_ListRolls();
		RollMaster_HandleString = tmpFunc;
		return;
	elseif ( RollMaster_IsInList(param, ROLLMASTER_CHAT_CMDS_ROLL) ) then
		if ( RollMaster_CurrentRoll ) then
			RollMaster_DoRandomRoll(unpack(RollMaster_CurrentRoll));
			RollMaster_CurrentRoll = nil;
		else
			RollMaster_Print(TEXT(ROLLMASTER_CHAT_NO_PENDING_ROLL));
		end
		return;
	elseif ( RollMaster_IsInList(param, ROLLMASTER_CHAT_CMDS_AUTOROLL) ) then
		if ( RollMaster_ShouldAutoRoll == 1 ) then
			RollMaster_ShouldAutoRoll = 0;
		else
			RollMaster_ShouldAutoRoll = 1;
		end
		RollMaster_ReportAutoRoll();
		return;
	else
		RollMaster_Print(ROLLMASTER_CHAT_CMDS_USAGE);
		return;
	end
end

function RollMaster_ReportAutoRoll()
	local value = ROLLMASTER_CHAT_STATE_ENABLED;
	if ( RollMaster_ShouldAutoRoll ~= 1 ) then
		value = ROLLMASTER_CHAT_STATE_DISABLED;
	end
	RollMaster_Print(format(ROLLMASTER_CHAT_AUTO_ROLL, value));
end