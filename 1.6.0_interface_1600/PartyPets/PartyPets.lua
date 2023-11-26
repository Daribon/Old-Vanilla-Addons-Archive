PARTYPETS_VERSION = "v0.94";

-- Config Options
PartyPets_Config = {};
function PartyPets_ResetConfig()
	PartyPets_Config.Enabled = true;
	PartyPets_Config.Hidden = false;
	PartyPets_Config.Layout = "vertical down";
	PartyPets_Config.OffsetX = 0;
	PartyPets_Config.Alpha = 1.0;
	PartyPets_Config.AllowServer = true;
	PartyPets_Config.AllowClient = true;
	PartyPets_Config.UsePlayer = false;
	PartyPets_Config.AllowFake = false;
	PartyPets_Config.Version = PARTYPETS_VERSION;
end

PartyPets_Vars = {};
PartyPets_Vars.ServerEnabled = false;
PartyPets_Vars.ClientEnabled = false;
PartyPets_Vars.ServerList = {};
PartyPets_Vars.BeingDragged = false;
PartyPets_Vars.LastHealthPercent = 0;
PartyPets_Vars.Buffs = {};
PartyPets_Vars.Debuffs = {};
PartyPets_Vars.LastSendTime = 0;

PartyPets_Pets = {};

-- Slash Commands
PARTYPETS_ENABLE 		= "enable";
PARTYPETS_DISABLE 		= "disable";
PARTYPETS_ON 			= "on";
PARTYPETS_OFF 			= "off";
PARTYPETS_CLIENTON		= "clienton";
PARTYPETS_CLIENTOFF		= "clientoff";
PARTYPETS_SERVERON		= "serveron";
PARTYPETS_SERVEROFF		= "serveroff";
PARTYPETS_REFRESH		= "refresh";
PARTYPETS_RESET			= "reset";
PARTYPETS_SHOW			= "show";
PARTYPETS_HIDE			= "hide";
PARTYPETS_LAYOUT		= "layout";
PARTYPETS_OFFSETX		= "offsetx";
PARTYPETS_ALPHA			= "alpha";

PARTYPETS_LAYOUTVU		= "vertical up";
PARTYPETS_LAYOUTVD		= "vertical down";
PARTYPETS_LAYOUTHL		= "horizontal left";
PARTYPETS_LAYOUTHR		= "horizontal right";
PARTYPETS_LAYOUTO		= "link to owner";

COLOR_RED = "|cffff0000";
COLOR_YELLOW = "|cffffff00";
COLOR_GREEN = "|cff00ff00";
COLOR_GREY = "|caaaaaaaa";
COLOR_WHITE = "|cffffffff";
COLOR_BLUE = "|cff3366ff";
COLOR_CLOSE = "|r";
COLOR_SEP = (COLOR_GREEN.."|"..COLOR_CLOSE);

-- General Protocol
PPP_SEPARATOR		= ";";
PPP_KEYVALUESEP		= ":";
PPP_BUFFSEP			= "#";
PPP_BUFFKEYSEP		= "|";
-- Client/Server Protocol
PPP_CLIENTMSG		= "<PPClient>";
PPP_UPDATEREQ		= "Update";
-- Server/Client Protocol
PPP_SERVERMSG		= "<PPServer>";
PPP_DISCONNECT		= "Disconnect";
PPP_PORTRAIT		= "Portrait";
PPP_NAME			= "Name";
PPP_LEVEL			= "Level";
PPP_HEALTH			= "Health";
PPP_HEALTHMAX		= "HealthMax";
PPP_MANA			= "Mana";
PPP_MANAMAX			= "ManaMax";
PPP_STATUS			= "Status";
	PPP_ALIVE		= "Alive";
	PPP_DEAD		= "Dead";
	PPP_GONE		= "Gone";
PPP_DEBUFF			= "DB";
PPP_BUFF			= "BB";
PPP_MANATYPE		= "ManaType";
	PPP_FOCUS		= FOCUS_POINTS;
	PPP_MANA		= MANA;

-- Compression
PPS_INTERFACEICON	= "Interface\\Icons\\";
PPC_INTERFACEICON	= "~II";

-- Misc
PartyPets_DEFAULT_PORTRAIT = "Interface\\CharacterFrame\\TemporaryPortrait-Monster";
HardTargets = {};
HardTargets[1] = "player";
HardTargets[2] = "party1";
HardTargets[3] = "party2";
HardTargets[4] = "party3";
HardTargets[5] = "party4";

-- PartyComm Hooks
local Pre_PartyComm_OnPCSelfJoin;
local Pre_PartyComm_OnPCSelfLeave;
local Pre_PartyComm_OnPCOtherJoin;
local Pre_PartyComm_OnPCOtherLeave;
local Pre_PartyComm_OnPCChatMessage;
local Pre_PartyComm_OnPCEnable;
local Pre_PartyComm_OnPCDisable;

-- Load Handler
function PartyPets_OnLoad()
	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_PET_CHANGED");
	this:RegisterForDrag("LeftButton");
	PartyPets_ResetConfig();
	
	-- Hook/Chain PartyComm messages
	Pre_PartyComm_OnPCSelfJoin = PartyComm_OnPCSelfJoin;
	PartyComm_OnPCSelfJoin = PartyPets_OnPCSelfJoin;

	Pre_PartyComm_OnPCSelfLeave = PartyComm_OnPCSelfLeave;
	PartyComm_OnPCSelfLeave = PartyPets_OnPCSelfLeave;

	Pre_PartyComm_OnPCOtherJoin = PartyComm_OnPCOtherJoin;
	PartyComm_OnPCOtherJoin = PartyPets_OnPCOtherJoin;

	Pre_PartyComm_OnPCOtherLeave = PartyComm_OnPCOtherLeave;
	PartyComm_OnPCOtherLeave = PartyPets_OnPCOtherLeave;

	Pre_PartyComm_OnPCChatMessage = PartyComm_OnPCChatMessage;
	PartyComm_OnPCChatMessage = PartyPets_OnPCChatMessage;
	
	Pre_PartyComm_OnPCEnable = PartyComm_OnPCEnable;
	PartyComm_OnPCEnable = PartyPets_OnPCEnable;

	Pre_PartyComm_OnPCDisable = PartyComm_OnPCDisable;
	PartyComm_OnPCDisable = PartyPets_OnPCDisable;

	-- Set Party Pet Button Text
	PartyPetsText:SetText("PartyPets");
	
	-- Setup Slash Commands
	SLASH_PARTYPETS1 = "/partypets";
	SLASH_PARTYPETS2 = "/pp";
	SlashCmdList["PARTYPETS"] = function(msg)
		PartyPets_OnSlashCommand(msg);
	end

	-- Load Inform
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage("PartyPets Loaded");
	end	
end

-- Slash Command Handler
function PartyPets_OnSlashCommand(msg)
	if (not msg) then
		return;
	end

	local command = string.lower(msg);
	
	-- Enable/Disable
	if (command == PARTYPETS_ENABLE or command == PARTYPETS_ON) then
		PartyPets_Config.Enabled = true;
		PartyPets_AddInfoMessage("PartyPets: Enabled");
	elseif (command == PARTYPETS_DISABLE or command == PARTYPETS_OFF) then
		PartyPets_Config.Enabled = false;
		PartyPets_AddInfoMessage("PartyPets: Disabled");
	elseif (command == PARTYPETS_CLIENTON) then
		PartyPets_Config.AllowClient = true;
		PartyPets_Vars.ClientEnabled = true;
		PartyPets_AddInfoMessage("PartyPets: Client Enabled");
	elseif (command == PARTYPETS_CLIENTOFF) then
		PartyPets_Config.AllowClient = false;
		PartyPets_Vars.ClientEnabled = false;
		PPClient_VerifyServers();
		PartyPets_AddInfoMessage("PartyPets: Client Disabled");
	elseif (command == PARTYPETS_SERVERON) then
		if (UnitClass("player") == "Hunter" or UnitClass("player") == "Warlock") then
			PartyPets_Config.AllowServer = true;
			PartyPets_Vars.ServerEnabled = true;
			PartyPets_AddInfoMessage("PartyPets: Server Enabled");
		else
			PartyPets_AddInfoMessage("PartyPets: Only Hunters and Warlocks may enable the server");
		end
	elseif (command == PARTYPETS_REFRESH) then
		if (PartyPets_IsClientEnabled()) then
			local message = "";
			message = PartyPets_AddKey(message, PPP_UPDATEREQ);
			PPClient_SendChatMessage(message);
			PartyPets_AddInfoMessage("PartyPets: Sending request for update");
		end
	elseif (command == PARTYPETS_RESET) then
		if (PartyPets_IsClientEnabled()) then
			PPClient_VerifyServers(true);
			local message = "";
			message = PartyPets_AddKey(message, PPP_UPDATEREQ);
			GTimer_AddEvent(1.0, PPClient_SendChatMessage, message);
			PartyPets_AddInfoMessage("PartyPets: Resetting pets and sending request for update");
		end
		if (PartyPets_IsServerEnabled()) then
			PPServer_UpdateClients();
			PartyPets_AddInfoMessage("PartyPets: Server sending unit update.");
		end
	elseif (command == PARTYPETS_SERVEROFF) then
		PartyPets_Config.AllowServer = false;
		PartyPets_Vars.ServerEnabled = false;
		local message = PartyPets_AddKey("", PPP_DISCONNECT);
		PPServer_SendChatMessage("asdf", message);
		PartyPets_AddInfoMessage("PartyPets: Server Disabled");
	elseif (command == PARTYPETS_SHOW) then
		PartyPets_Config.Hidden = false;
		PartyPetsFrame:Show();
	elseif (command == PARTYPETS_HIDE) then
		PartyPets_Config.Hidden = true;
		PartyPetsFrame:Hide();
	elseif (strsub(command, 1, strlen(PARTYPETS_LAYOUT)) == PARTYPETS_LAYOUT) then
		if (strsub(command, strlen(PARTYPETS_LAYOUT)+2) == "vu") then
			PartyPets_Config.Layout = PARTYPETS_LAYOUTVU;
			PartyPetFrame_SetPositions();
		elseif (strsub(command, strlen(PARTYPETS_LAYOUT)+2) == "vd") then
			PartyPets_Config.Layout = PARTYPETS_LAYOUTVD;
			PartyPetFrame_SetPositions();
		elseif (strsub(command, strlen(PARTYPETS_LAYOUT)+2) == "hr") then
			PartyPets_Config.Layout = PARTYPETS_LAYOUTHR;
			PartyPetFrame_SetPositions();
		elseif (strsub(command, strlen(PARTYPETS_LAYOUT)+2) == "hl") then
			PartyPets_Config.Layout = PARTYPETS_LAYOUTHL;
			PartyPetFrame_SetPositions();
		elseif (strsub(command, strlen(PARTYPETS_LAYOUT)+2) == "owner") then
			PartyPets_Config.Layout = PARTYPETS_LAYOUTO;
			PartyPetFrame_SetPositions();
		else
			PartyPets_AddInfoMessage("Invalid Layout Type");
		end
		PartyPets_AddInfoMessage("PartyPets: Layout set to "..PartyPets_Config.Layout);
	elseif (strsub(command, 1, strlen(PARTYPETS_ALPHA)) == PARTYPETS_ALPHA) then
		firsti, lasti, value = strfind(command, "(%d+)");
		if (value and tonumber(value) > 0 and tonumber(value) <= 100) then
    		PartyPets_Config.Alpha = (tonumber(value) * 0.01);
    	else
    		PartyPets_Config.Alpha = 1.0;
    	end
		for i=1, MAX_PARTY_PETS, 1 do
			getglobal("PartyPetFrame"..i).alpha = PartyPets_Config.Alpha;
		end
		PartyPetsFrame:SetAlpha(PartyPets_Config.Alpha);
		PPClient_UpdatePartyPets(false);
		PartyPets_AddInfoMessage("PartyPets: Alpha set to "..(PartyPets_Config.Alpha * 100).."%");		
	elseif (strsub(command, 1, strlen(PARTYPETS_OFFSETX)) == PARTYPETS_OFFSETX) then
		firsti, lasti, value = strfind(command, "(%d+)");
		if (value) then
    		PartyPets_Config.OffsetX = tonumber(value);
    	else
    		PartyPets_Config.OffsetX = 0;
    	end
		PartyPetFrame_SetPositions();
		PartyPets_AddInfoMessage("PartyPets: Owner x offset set to "..PartyPets_Config.OffsetX);		
	else
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		PartyPets_AddInfoMessage("PartyPets Status:");
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_GREEN.."Use "..COLOR_CLOSE..COLOR_WHITE.."/partypets <command> "..COLOR_CLOSE..COLOR_GREEN.."or "..COLOR_CLOSE..COLOR_WHITE.."/pp <command> "..COLOR_CLOSE..COLOR_GREEN.."to perform the following commands:"..COLOR_CLOSE);
		PartyPets_AddHelpMessage(PARTYPETS_ON.." | "..PARTYPETS_OFF, "enables or disables PartyPets", nil, PartyPets_Config.Enabled);
		PartyPets_AddHelpMessage(PARTYPETS_CLIENTON.." | "..PARTYPETS_CLIENTOFF, "enables or disables PartyPets client", nil, (PartyPets_Config.AllowClient and PartyPets_Vars.ClientEnabled));
		if (UnitClass("player") == "Hunter" or UnitClass("player") == "Warlock") then
			PartyPets_AddHelpMessage(PARTYPETS_SERVERON.." | "..PARTYPETS_SERVEROFF, "enables or disables PartyPets server", nil, (PartyPets_Config.AllowServer and PartyPets_Vars.ServerEnabled));
		end
		PartyPets_AddHelpMessage(PARTYPETS_REFRESH, "requests current pet data from pet servers. If you are server this sends a pet update", nil, nil);
		PartyPets_AddHelpMessage(PARTYPETS_RESET, "resets all pets and requests current pet data from pet servers", nil, nil);
		PartyPets_AddHelpMessage(PARTYPETS_SHOW, "shows the PartyPets button and all pets", nil, nil);
		PartyPets_AddHelpMessage(PARTYPETS_HIDE, "hides the PartyPets button and all pets", nil, nil);
		PartyPets_AddHelpMessage(PARTYPETS_LAYOUT.." vu | vd | hr | hl | owner", "sets PartyPets layout (vertical/horizontal, up/down/left/right) ", "("..PartyPets_Config.Layout..")", true);
		PartyPets_AddHelpMessage(PARTYPETS_OFFSETX.." #", "allows you to add an additional offset to PartyPet frames when using owner mode. ", "("..PartyPets_Config.OffsetX..")", true);
		PartyPets_AddHelpMessage(PARTYPETS_ALPHA, "sets PartyPets pet frame alpha. This will change to 100% if the pet drops below 20% health. ", "("..(PartyPets_Config.Alpha * 100).."%)", true);
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_GREEN.."For example: "..COLOR_CLOSE..COLOR_WHITE.."/partypets clienton "..COLOR_CLOSE..COLOR_GREEN.."will allow you to see the pets of other PartyPets users in your party."..COLOR_CLOSE);
	end
end

function PartyPets_SetClientServerStates()
	if (UnitName("player")) then
		if (not PartyComm_Config.Enabled) then
			PartyPets_AddInfoMessage("PartyPets: PartyComm is disabled.  PartyPets will not function without it.");
		end

		-- Enable the server for pet classes
		if ((UnitClass("player") == "Hunter" or UnitClass("player") == "Warlock") and PartyPets_Config.AllowServer and PartyComm_Config.Enabled) then
			PartyPets_AddInfoMessage("PartyPets: Enabling Server");
			PartyPets_Vars.ServerEnabled = true;
		end
		-- Enable the client for all classes
		if (PartyPets_Config.AllowClient and PartyComm_Config.Enabled) then
			PartyPets_AddInfoMessage("PartyPets: Enabling Client");
			PartyPets_Vars.ClientEnabled = true;
		end
	else
		GTimer_AddEventByName("SetCSState", 0.2, PartyPets_SetClientServerStates);
	end
end
-- Main Event Handler
function PartyPets_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (not PartyPets_Config.Version or PartyPets_Config.Version ~= PARTYPETS_VERSION) then
			PartyPets_AddInfoMessage("PartyPets: Version changed, resetting all variables to default.");
			PartyPets_ResetConfig();
		end
		if (PartyPets_Config.Hidden) then
			PartyPetsFrame:Hide();
		else
			PartyPetsFrame:Show();
		end
		RegisterForSave("PartyPets_Config");
		PartyPetsFrame:SetAlpha(PartyPets_Config.Alpha);
		PartyPets_SetClientServerStates();
	end

	if (PartyPets_IsServerEnabled()) then
		-- Pet changes in a major way so update our clients
		if (event == "PLAYER_PET_CHANGED") then
			PPServer_ClearBuffs();
			PPServer_ClearDebuffs();
			GTimer_AddEvent(1.0, PPServer_UpdateClients, "UNIT_UPDATE");
		-- Pet health changed so update our clients if needed
		elseif (event == "UNIT_HEALTH" and arg1 == "pet") then
			local HealthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
			-- Health is going up
			if (PartyPets_Vars.LastHealthPercent < HealthPercent) then
				if (HealthPercent - PartyPets_Vars.LastHealthPercent > 10) then
					PartyPets_Vars.LastHealthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
					PPServer_UpdateClients("UNIT_HEALTH");
				elseif (HealthPercent == 100) then
					PartyPets_Vars.LastHealthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
					PPServer_UpdateClients("UNIT_HEALTH");
				end
			-- Health is going down
			elseif (PartyPets_Vars.LastHealthPercent > HealthPercent) then
				local minIncrement = 10;
				if (HealthPercent < 30) then
					minIncrement = 1;
				elseif (HealthPercent < 50) then
					minIncrement = 5;
				elseif (HealthPercent < 100) then
					minIncrement = 10;
				end
				if (PartyPets_Vars.LastHealthPercent - HealthPercent > minIncrement) then
					PartyPets_Vars.LastHealthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
					PPServer_UpdateClients("UNIT_HEALTH");
				elseif (HealthPercent == 100) then
					PartyPets_Vars.LastHealthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
					PPServer_UpdateClients("UNIT_HEALTH");
				end
			end
		elseif (event == "UNIT_HEALTHMAX" and arg1 == "pet") then
			PPServer_UpdateClients("UNIT_HEALTHMAX");
		elseif (event == "UNIT_AURA" and arg1 == "pet") then
			PPServer_UpdateClients("UNIT_BUFFS");
		end
	end
end

-- Main Update Handler
function PartyPets_OnUpdate(elapsed)
end

function PPAddFake(index)
	PartyPets_OnPCChatMessage("PartyCommDreyruugr", "PPFake"..index, "<PPServer>;Name:PPFake"..index.."Pet;Health:800;HealthMax:1000;Status:Alive");
end

function PPFakeGone(index)
	PartyPets_OnPCChatMessage("PartyCommDreyruugr", "PPFake"..index, "<PPServer>;Status:Gone");
end

function PPFakeBack(index)
	PartyPets_OnPCChatMessage("PartyCommDreyruugr", "PPFake"..index, "<PPServer>;Name:PPFake"..index.."Pet;Health:1000;HealthMax:1000;Status:Alive");
end

function PPFakeHealth(index, health)
	PartyPets_OnPCChatMessage("PartyCommDreyruugr", "PPFake"..index, "<PPServer>;Name:PPFake"..index.."Pet;Health:"..health..";HealthMax:1000;Status:Alive");
end

function PPFakePort(index)
	SetPortraitTexture(getglobal("PartyPetFrame"..index).portrait, "player");
end

-- Send when a message is sent to a PartyComm channel
function PartyPets_OnPCChatMessage(channelName, player, message)
--	DEFAULT_CHAT_FRAME:AddMessage(channelName.." "..player..": "..message);
	-- Got a PartyPets server message
	if (PartyPets_IsClientEnabled() and strfind(message, PPP_SERVERMSG)) then
		if (PartyPets_IsInParty(player)) then	-- verify that they're in our party
			-- if they're not already a server, add them
			if (not PPClient_IsServer(player)) then
				if (PPClient_AddServer(player)) then
					-- Process the incoming message
					PPClient_OnServerMessage(player, message);
				end
			else
				PPClient_OnServerMessage(player, message);
			end
		elseif (PPClient_IsServer(player)) then -- server not in the party, remove it
			PPClient_RemoveServer(player);
		end
	elseif (PartyPets_IsServerEnabled() and strfind(message, PPP_CLIENTMSG)) then
		if (PartyPets_IsInParty(player)) then	-- verify that they're in our party
			-- Process the incoming message
			PPServer_OnClientMessage(message);
		end
	end
	
	Pre_PartyComm_OnPCChatMessage(channelName, player, message);
end

-- Sent when you join a PartyComm channel
function PartyPets_OnPCSelfJoin(channelName)
--	DEFAULT_CHAT_FRAME:AddMessage("PartyPets_OnPCSelfJoin");
	if (PartyPets_IsClientEnabled()) then
		local message = "";
		message = PartyPets_AddKey(message, PPP_UPDATEREQ);
		PPClient_SendChatMessage(message);
	end
	if (PartyPets_IsServerEnabled()) then
		PPServer_UpdateClients("UNIT_UPDATE");
	end
	Pre_PartyComm_OnPCSelfJoin(channelName);
end

-- Sent when you leave a PartyComm channel
function PartyPets_OnPCSelfLeave(channelName)
--	DEFAULT_CHAT_FRAME:AddMessage("PartyPets_OnPCSelfLeave");
	if (PartyPets_IsClientEnabled()) then
		PPClient_VerifyServers(); -- should be remove all servers
	end
	Pre_PartyComm_OnPCSelfLeave(channelName);
end

-- Send when someone else joins a PartyComm channel
function PartyPets_OnPCOtherJoin(channelName, player)
--	DEFAULT_CHAT_FRAME:AddMessage("PartyPets_OnPCOtherJoin");
	Pre_PartyComm_OnPCOtherJoin(channelName, player);
end

-- Send when someone else leaves a PartyComm channel
function PartyPets_OnPCOtherLeave(channelName, player)
--	DEFAULT_CHAT_FRAME:AddMessage("PartyPets_OnPCOtherLeave");
	if (PartyPets_IsClientEnabled()) then
		if (PPClient_IsServer(player)) then
			PPClient_RemoveServer(player);
		end
	end
	Pre_PartyComm_OnPCOtherLeave(channelName, player);
end

-- Send when PartyComm is enabled
function PartyPets_OnPCEnable()
	PartyPets_SetClientServerStates();
	
	Pre_PartyComm_OnPCEnable();
end

-- Send when PartyComm is disabled
function PartyPets_OnPCDisable()
	PartyPets_SetClientServerStates();
--	PartyPets_Vars.ClientEnabled = false;
--	PartyPets_Vars.ServerEnabled = false;
	PPClient_VerifyServers();
	
	Pre_PartyComm_OnPCDisable();
end

-- Send a message to the PartyPets channel
function PPServer_SendChatMessage(event, message)
	if (not PartyPets_IsServerEnabled()) then
		return;
	end
	
	index = PartyComm_GetPCChannelIndex();
	if (index and index > 0) then
		-- Overflow protection
		if (PartyPets_Vars.LastSendTime + 0.25 > GetTime()) then
--			GTimer_AddEvent(0.1, PPServer_SendChatMessage, event, message);
			GTimer_AddEventByName(event, 0.25, PPServer_SendChatMessage, event, message);
		else
			SendChatMessage(PPP_SERVERMSG..message, "CHANNEL", nil, index);
			PartyPets_Vars.LastSendTime = GetTime();
		end
	end	
end

function PartyPets_IsServerEnabled()
	if (not PartyComm_Config.Enabled) then
		--DEFAULT_CHAT_FRAME:AddMessage("Enabled false");
		return false;
	elseif (not PartyPets_Vars.ServerEnabled) then
		--DEFAULT_CHAT_FRAME:AddMessage("ServerEnabled false");
		return false;
	elseif (not PartyPets_Config.AllowServer) then
		--DEFAULT_CHAT_FRAME:AddMessage("AllowServer false");
		return false;
	end
	return true;
end

function PartyPets_IsClientEnabled()
	if (not PartyComm_Config.Enabled) then
		--DEFAULT_CHAT_FRAME:AddMessage("Enabled false");
		return false;
	elseif (not PartyPets_Vars.ClientEnabled) then
		--DEFAULT_CHAT_FRAME:AddMessage("ClientEnabled false");
		return false;
	elseif (not PartyPets_Config.AllowClient) then
		--DEFAULT_CHAT_FRAME:AddMessage("AllowClient false");
		return false;
	end
	return true;
end

-- Update passed client based on event
function PPServer_UpdateClients(event)
	local message = "";
	-- Send health update
	if (event == "UNIT_HEALTH") then
		message = PartyPets_AddKeyValue(message, PPP_HEALTH, UnitHealth("pet"));
		message = PartyPets_AddKeyValue(message, PPP_HEALTHMAX, UnitHealthMax("pet"));
		PPServer_SendChatMessage(event, message);
	-- Send healthmax update
	elseif (event == "UNIT_HEALTHMAX") then
		message = PartyPets_AddKeyValue(message, PPP_HEALTH, UnitHealth("pet"));
		message = PartyPets_AddKeyValue(message, PPP_HEALTHMAX, UnitHealthMax("pet"));
		PPServer_SendChatMessage(event, message);
	-- Send buffs update
	elseif (event == "UNIT_BUFFS") then
		local index;
		for index=1, MAX_PARTYPET_TOOLTIP_BUFFS, 4 do
			message = PPServer_DiffBuffs(index);
			if (message ~= "") then
				message = PartyPets_AddKeyValue("", PPP_BUFF..index, message)
				message = string.gsub(message, PPS_INTERFACEICON, PPC_INTERFACEICON);
				PPServer_SendChatMessage("UNIT_BUFFS"..index, message);
			end
		end

		for index=1, MAX_PARTYPET_TOOLTIP_DEBUFFS, 4 do
			message = PPServer_DiffDebuffs(index);
			if (message ~= "") then
				message = PartyPets_AddKeyValue("", PPP_DEBUFF..index, message)
				message = string.gsub(message, PPS_INTERFACEICON, PPC_INTERFACEICON);
				PPServer_SendChatMessage("UNIT_DEBUFFS"..index, message);
			end
		end
	-- Send full unit update
	elseif (event == "UNIT_UPDATE") then
		if (not UnitExists("pet")) then
			message = PartyPets_AddKeyValue(message, PPP_STATUS, PPP_GONE);
			--PPServer_SendChatMessage(event, message);
			GTimer_AddEventByName(event, 2.0, PPServer_SendChatMessage, event, message);
		elseif (UnitIsDead("pet")) then
			message = PartyPets_AddKeyValue(message, PPP_HEALTH, UnitHealth("pet"));
			message = PartyPets_AddKeyValue(message, PPP_HEALTHMAX, UnitHealthMax("pet"));
			message = PartyPets_AddKeyValue(message, PPP_STATUS, PPP_DEAD);
			message = PartyPets_AddKey(message, PPP_PORTRAIT);
			--PPServer_SendChatMessage(event, message);
			GTimer_AddEventByName(event, 2.0, PPServer_SendChatMessage, event, message);
		else
			message = PartyPets_AddKeyValue(message, PPP_NAME, UnitName("pet"));
			message = PartyPets_AddKeyValue(message, PPP_LEVEL, UnitLevel("pet"));
			message = PartyPets_AddKeyValue(message, PPP_HEALTH, UnitHealth("pet"));
			message = PartyPets_AddKeyValue(message, PPP_HEALTHMAX, UnitHealthMax("pet"));
			message = PartyPets_AddKeyValue(message, PPP_STATUS, PPP_ALIVE);
			message = PartyPets_AddKey(message, PPP_PORTRAIT);
			--PPServer_SendChatMessage(event, message);
			GTimer_AddEventByName(event, 2.0, PPServer_SendChatMessage, event, message);
		end
	end
end

-- Process client messages
function PPServer_OnClientMessage(message)
	commands = PartyPets_GetCommands(message);
	if (not commands) then
		return;
	end
	
	for index, value in commands do
		PPServer_ProcessClientCommand(value);
	end
end

-- Process commands from clients
function PPServer_ProcessClientCommand(command)
	if (command == PPP_UPDATEREQ) then
		PPServer_UpdateClients("UNIT_UPDATE");
	end
end

--------------------------------------------
--
-- Client Functions (Server List Management)
--
--------------------------------------------

-- Adds a server
function PPClient_AddServer(name)
	local i = 1;
	while ( PartyPets_Vars.ServerList[i] ) do
		i = i + 1;
	end
	
	if (i > MAX_PARTY_PETS) then
		return false;
	end
	
	PartyPets_Vars.ServerList[i] = name
	
	PartyPets_Pets[name] = {}
	PartyPets_Pets[name].Status = PPP_GONE;
	PartyPets_Pets[name].Name = "";
	PartyPets_Pets[name].Level = 0;
	PartyPets_Pets[name].Health = 0;
	PartyPets_Pets[name].HealthMax = 0;
	PartyPets_Pets[name].Mana = 0;
	PartyPets_Pets[name].ManaMax = 0;
	PartyPets_Pets[name].ManaType = "";
	PartyPets_Pets[name].Buffs = {};
	for j=1, MAX_PARTYPET_TOOLTIP_BUFFS do
		PartyPets_Pets[name].Buffs[j] = "nil";	
	end
	PartyPets_Pets[name].Debuffs = {};
	for j=1, MAX_PARTYPET_TOOLTIP_BUFFS do
		PartyPets_Pets[name].Debuffs[j] = "nil";	
	end

	DEFAULT_CHAT_FRAME:AddMessage("Added Server: "..name);
	PPClient_UpdatePartyPets(true);
	return true;
end

-- Removes a server
function PPClient_RemoveServer(name)
	-- hide gui
	local id = PPClient_GetServerID(name);
	if (id < 1) then
		return;
	end

	PartyPets_Pets[name] = nil;
	
	local NewServerList = {};
	for index, value in PartyPets_Vars.ServerList do
		if (value ~= name) then
			local i = 1;
			while ( NewServerList[i] ) do
				i = i + 1;
			end
			NewServerList[i] = value
		end
	end	
--	PartyPets_Vars.ServerList = NewServerList;

	PartyPets_Vars.ServerList[id] = nil;	
	DEFAULT_CHAT_FRAME:AddMessage("Removed Server: "..name);
	PPClient_UpdatePartyPets(true);
end

-- Gets a server ID by name
function PPClient_GetServerID(name)
	for index, value in PartyPets_Vars.ServerList do
		if (value == name) then
			return index;
		end
	end
	return 0;
end

-- Check if named player is a server
function PPClient_IsServer(name)
	for index, value in PartyPets_Vars.ServerList do
		if (name == value) then
			return true;
		end
	end
	return false;
end

-- Disconnects any servers no longer in the party
function PPClient_VerifyServers(removeAll)
	for index, value in PartyPets_Vars.ServerList do
		local serverFound = false;
		for i=1, MAX_PARTY_MEMBERS, 1 do
			if (UnitName("party"..i) == value) then
				serverFound = true;
				break;
			end
		end
		if (not serverFound or not PartyPets_IsClientEnabled() or removeAll) then
			PPClient_RemoveServer(value);
		end
	end
end

-- Send a message to PartyPets channel
function PPClient_SendChatMessage(message)
	if (not PartyPets_IsClientEnabled()) then
		return;
	end

	index = PartyComm_GetPCChannelIndex();
	if (index > 0) then
		SendChatMessage(PPP_CLIENTMSG..message, "CHANNEL", nil, index);
	end
end

-- Process server messages
function PPClient_OnServerMessage(server, message)
	commands = PartyPets_GetCommands(message);
	if (not commands) then
		return;
	end
	
	for index, value in commands do
		PPClient_ProcessServerCommand(server, value);
	end
	PPClient_UpdatePartyPets(false);
end

-- Process commands from servers
function PPClient_ProcessServerCommand(server, command)
	if (strfind(command, PPP_KEYVALUESEP)) then
		local pair = GetArgs(command, ":");
		local key = pair[1];
		local value = pair[2];
		
		-- Update this servers pet health
		if (key == PPP_HEALTH) then
			PartyPets_Pets[server].Health = value;
		-- Update this servers pet health max
		elseif (key == PPP_HEALTHMAX) then
			PartyPets_Pets[server].HealthMax = value;
		-- Update this servers pet name
		elseif (key == PPP_NAME) then
			PartyPets_Pets[server].Name = value;
		-- Update this servers pet level
		elseif (key == PPP_LEVEL) then
			PartyPets_Pets[server].Level = value;
		-- Update this servers pet status
		elseif (key == PPP_STATUS) then
			PartyPets_Pets[server].Status = value;
		-- Update this servers pet debuff
		elseif (strsub(key, 1, strlen(PPP_DEBUFF)) == PPP_DEBUFF) then
			value = string.gsub(value, PPC_INTERFACEICON, PPS_INTERFACEICON);
			local firsti, lasti, buffIndex = strfind(key, "(%d+)");
			local buffKeys = GetArgs(value, PPP_BUFFSEP);
			for index, buffName in buffKeys do
				PartyPets_Pets[server].Debuffs[tonumber(buffIndex) + (index - 1)] = buffName;
			end			
		-- Update this servers pet buff
		elseif (strsub(key, 1, strlen(PPP_BUFF)) == PPP_BUFF) then
			value = string.gsub(value, PPC_INTERFACEICON, PPS_INTERFACEICON);
			local firsti, lasti, buffIndex = strfind(key, "(%d+)");
			local buffKeys = GetArgs(value, PPP_BUFFSEP);
			for index, buffName in buffKeys do
				PartyPets_Pets[server].Buffs[tonumber(buffIndex) + (index - 1)] = buffName;
			end			
		end
	else
		if (command == PPP_DISCONNECT) then
			PPClient_RemoveServer(server);
		elseif (command == PPP_PORTRAIT) then
			PPClient_UpdatePortrait(server);
		end
	end
end

--------------------------------------------
--
-- Client Functions (PartyPet Management)
--
--------------------------------------------

-- Hide/Show PartyPetFrames
function PPClient_UpdatePartyPets(updatePortrait)
	for i=1, MAX_PARTY_PETS, 1 do
		if (not PartyPets_Vars.ServerList[i]) then
			getglobal("PartyPetFrame"..i):Hide();
		else
			local server = PartyPets_Vars.ServerList[i];
			if (PartyPets_Pets[server].Status == PPP_GONE) then
				getglobal("PartyPetFrame"..i):Hide();	
			else
				getglobal("PartyPetFrame"..i):Show();
				getglobal("PartyPetFrame"..i).needsUpdate = true;
				if (updatePortrait) then
					getglobal("PartyPetFrame"..i).portraitNeedsUpdate = true;
				end
			end				
		end
		getglobal("PartyPetFrame"..i).alpha = PartyPets_Config.Alpha;
	end
end

-- Update PartyPetFrame portrait if possible
function PPClient_UpdatePortrait(server)
	local unit = PPClient_GetPartyUnit(server);
	local id = PPClient_GetServerID(server);
	
	-- Portrait is up to date
	if (not getglobal("PartyPetFrame"..id).portraitNeedsUpdate) then
		return;
	end
	
	local result = PartyPets_ActionOnTargetPet(unit, SetPortraitTexture, getglobal("PartyPetFrame"..id).portrait);
	-- Portrait update successful
	if (result) then
		getglobal("PartyPetFrame"..id).portraitNeedsUpdate = false;
	-- Portrait update failed
	else
		getglobal("PartyPetFrame"..id).portraitNeedsUpdate = true;
		getglobal("PartyPetFrame"..id.."Portrait"):SetTexture(PartyPets_DEFAULT_PORTRAIT);
	end
end

-- Return the hardcoded name for server (i.e. "party1", "party2", etc...)
function PPClient_GetPartyUnit(server)
	if (PartyPets_Config.UsePlayer) then
		if (UnitName("player") == server) then
			return ("player");
		end
	end
	
	if (PartyPets_Config.AllowFake) then
        firsti, lasti, value = strfind(server, "(%d+)");
        if (value) then
        	return ("party"..value);
    	else
			return ("player");
    	end		
	end

	for i=1, MAX_PARTY_MEMBERS, 1 do
		name = UnitName("party"..i);
		if (name and (name == server)) then
			return ("party"..i);
		end
	end
end

-- Return the server name for hardcoded name (i.e. "partypet1", "partypet2", etc...)
function PPClient_GetServerByPartyPet(unit)
	local server = nil;
	if (unit == "partypet1") then
		server = PartyPets_Vars.ServerList[1];
	elseif (unit == "partypet2") then
		server = PartyPets_Vars.ServerList[2];
	elseif (unit == "partypet3") then
		server = PartyPets_Vars.ServerList[3];
	elseif (unit == "partypet4") then
		server = PartyPets_Vars.ServerList[4];
	end
	return server;
end

--------------------------------------------
--
-- PartyPets Functions ()
--
--------------------------------------------

function PartyPets_IsInParty(name)
	if (PartyPets_Config.AllowFake) then
		if (strfind(name, "PPFake")) then
			return true;
		else
			return false;
		end
	end
	
	if (PartyPets_Config.UsePlayer) then
		if (name == UnitName("player")) then
			return true;
		else
			return false;
		end
	end
	
	for i=1, MAX_PARTY_MEMBERS, 1 do
		if (UnitName("party"..i) == name) then
			return true;
		end
	end
	return false;
end

function PPServer_ClearBuffs()
	for i=1, MAX_PARTYPET_TOOLTIP_BUFFS do
		PartyPets_Vars.Buffs[i] = "nil";
	end
end

function PPServer_ClearDebuffs()
	for i=1, MAX_PARTYPET_TOOLTIP_DEBUFFS do
		PartyPets_Vars.Debuffs[i] = "nil";
	end
end

function PPServer_InitBuffs()
	for i=1, MAX_PARTYPET_TOOLTIP_BUFFS do
		if (UnitExists("pet")) then
			PartyPets_Vars.Buffs[i] = UnitBuff("pet", i);
		else
			PartyPets_Vars.Buffs[i] = "nil";
		end
	end
end

function PPServer_InitDebuffs()
	for i=1, MAX_PARTYPET_TOOLTIP_DEBUFFS do
		if (UnitExists("pet")) then
			PartyPets_Vars.Debuffs[i] = UnitDebuff("pet", i);
		else
			PartyPets_Vars.Debuffs[i] = "nil";
		end
	end
end

function PPServer_DiffBuffs(block)
	local buffsDiffer = false;
	local message = "";
	for i=block, (block+3) do
		local buff;
		if (UnitExists("pet")) then
			buff = UnitBuff("pet", i);
			if (not buff) then
				buff = "nil";
			end
		else
			buff = "nil";
		end
		if (buff ~= PartyPets_Vars.Buffs[i]) then
			buffsDiffer = true;
			PartyPets_Vars.Buffs[i] = buff;
		end
		message = PartyPets_AddBuffKey(message, buff);
	end
	if (buffsDiffer) then
		return (message);
	else
		return ("");
	end
end

function PPServer_DiffDebuffs(block)
	local buffsDiffer = false;
	local message = "";
	for i=block, (block+3) do
		local buff;
		if (UnitExists("pet")) then
			buff = UnitDebuff("pet", i);
			if (not buff) then
				buff = "nil";
			end
		else
			buff = "nil";
		end
		if (buff ~= PartyPets_Vars.Debuffs[i]) then
			buffsDiffer = true;
			PartyPets_Vars.Debuffs[i] = buff;
		end
		message = PartyPets_AddBuffKey(message, buff);
	end
	if (buffsDiffer) then
		return (message);
	else
		return ("");
	end
end

--------------------------------
--
-- PartyPets Functions (Protocol)
--
--------------------------------

-- Add a key/value pair to message
function PartyPets_AddKeyValue(message, key, value)
	return (message..PPP_SEPARATOR..key..PPP_KEYVALUESEP..value);
end

-- Add a key/value pair to message
function PartyPets_AddBuffKeyValue(message, key, value)
	return (message..PPP_BUFFSEP..key..PPP_BUFFKEYSEP..value);
end

-- Add a key/value pair to message
function PartyPets_AddBuffKey(message, key)
	return (message..PPP_BUFFSEP..key);
end

-- Add a key pair to message
function PartyPets_AddKey(message, key)
	return (message..PPP_SEPARATOR..key);
end

-- Split a message into it's component parts
function PartyPets_GetCommands(message)
	commands = StripMessage(message);
	if (commands) then
		commands = GetArgs(commands, ";");
	end
	return commands;
end

-- Strip the <PP*> identifiers from the message
function StripMessage(message)
	if (not strfind(message, ">")) then
		return message;
	else
		stripped = GetArgs(message, ">");
		return stripped[2];
	end
end

-- Support function for message splitting
function GetArgs(message, separator)
	local args = {};
	i = 0;
	for value in string.gfind(message, "[^"..separator.."]+") do
		i = i + 1;
		args[i] = value;
	end
	return args;
end

--------------------------------
--
-- PartyPets Functions (Frame)
--
--------------------------------

-- Start dragging PartyPetsFrame
function PartyPets_OnDragStart()
	PartyPetsFrame:StartMoving()
	PartyPets_Vars.BeingDragged = true;
end

-- Stop dragging PartyPetsFrame
function PartyPets_OnDragStop()
	if(PartyPets_Vars.BeingDragged) then
		PartyPetsFrame:StopMovingOrSizing()
		PartyPets_Vars.BeingDragged = false;
	end
end


----------------------------------------------
--
-- PartyPets Functions (Externals and Wrappers)
--
----------------------------------------------

-- Replacement for UnitHealth()
function PetHealth(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server == nil) then
		return (1);
	else
		return (PartyPets_Pets[server].Health);
	end
end

-- Replacement for UnitHealthMax()
function PetHealthMax(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server == nil) then
		return (1);
	else
		return (PartyPets_Pets[server].HealthMax);
	end
end

-- Replacement for UnitName()
function PetUnitName(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server == nil) then
		return ("NoPet");
	else
		return (PartyPets_Pets[server].Name);
	end
end

function PetUnitLevel(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server == nil) then
		return ("NoPet");
	else
		return (PartyPets_Pets[server].Level);
	end
end

function PetUnitOwner(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server == nil) then
		return ("NoOwner");
	else
		return (server);
	end
end

-- Replacement for UnitIsDead()
function PetUnitIsDead(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server ~= nil) then
		if (PartyPets_Pets[server].Status == PPP_DEAD) then
			return true;
		else
			return false;
		end
	end
	return nil;
end

-- Replacement for UnitDebuff()
function PetUnitDebuff(unit, index)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server ~= nil) then
		if (PartyPets_Pets[server].Debuffs[index] ~= "nil") then
			return (PartyPets_Pets[server].Debuffs[index]);
		end
	end
	return nil;
end

-- Replacement for UnitBuff()
function PetUnitBuff(unit, index)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server ~= nil) then
		if (PartyPets_Pets[server].Buffs[index] ~= "nil") then
			return (PartyPets_Pets[server].Buffs[index]);
		end
	end
	return nil;
end

-- Replacement for UnitPowerType()
function PetUnitPowerType(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server ~= nil) then
		
	end
	return nil;
end

-- Replacement for SetPortraitTexture()
function PetSetPortraitTexture(partypetframe, unit)
	if (not partypetframe.portraitNeedsUpdate or not partypetframe:IsShown()) then
		return;
	end

	local server = PPClient_GetServerByPartyPet(unit);
	if (server ~= nil) then
		PPClient_UpdatePortrait(server);
	end
end

-- Replacement for SpellCanTargetUnit()
function PetSpellCanTargetUnit(unit)
	local server = PPClient_GetServerByPartyPet(unit);
	if (server ~= nil) then
		return SpellCanTargetUnit(PPClient_GetPartyUnit(server));
	end
	return false;
end

-- Replacement for GetPartyMember()
function GetPartyPet(id)
	if (PartyPets_Vars.ServerList[id]) then
		server = PartyPets_Vars.ServerList[id];
		if (PartyPets_Pets[server].Status ~= PPP_GONE) then
			return true;
		end
	end
	return false;
end

-- Magic Function: Calls function passed as handler: handler([arg1], "target")
-- Before doing so, sets "target" as the pet of owner
-- Resets target back to old target if needed
function PartyPets_ActionOnTargetPet(owner, handler, arg1)
	local oldTarget = nil;
	local hardTarget = false;

	if (UnitExists("target")) then
		for index, value in HardTargets do
			if (UnitIsUnit("target", value)) then
				oldTarget = value;
				hardTarget = true;
			end
		end
		if (not hardTarget) then
			oldTarget = UnitName("target");
		end
	end

	TargetUnitsPet(owner);
	
	-- Target failure check
	if (UnitExists("target")) then
		if (hardTarget and UnitIsUnit("target", oldTarget)) then
			return false;
		elseif (UnitName("target") == oldTarget) then
			return false;
		end
	else
		return false;
	end

	if (arg1) then
		handler(arg1, "target");
	else
		handler("target");
	end
	
	if (oldTarget) then
		if (hardTarget) then
			TargetUnit(oldTarget);
		else
			TargetByName(oldTarget);
		end
	else
		ClearTarget();
	end
	
	return true;
end

-- Adds a formatted informational message
function PartyPets_AddInfoMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(COLOR_YELLOW..message..COLOR_CLOSE);
end

-- Adds a formatted help message
function PartyPets_AddHelpMessage(command, detail, status, enabled)
	message = COLOR_WHITE..command..": "..COLOR_CLOSE..COLOR_GREEN..detail..COLOR_CLOSE;

	if (enabled == nil) then
		DEFAULT_CHAT_FRAME:AddMessage(message);
		return;
	end
	
	if (status == "" or status == nil) then
		if (enabled) then
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_WHITE.." (enabled)"..COLOR_CLOSE);
		else
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_GREY.." (disabled)"..COLOR_CLOSE);
		end
	else
		if (enabled) then
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_WHITE..status..COLOR_CLOSE);
		else
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_GREY..status..COLOR_CLOSE);
		end		
	end
end
