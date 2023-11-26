--[[
	Extra common usage commands not significant enough for a new module.
	--Thott
	
	Refactored it so that it uses the localization.lua. Added save settings by class.
	--sarf
]]

function Cosmos_RegisterCosmosChatCommands()
	--------------------------------------------------------------------------------
	-- Register the help command.
	local comlist = COSMOS_HELP_COMM;
	local desc = COSMOS_HELP_COMM_INFO;
	local id = "COSMOSHELP";
	local func = function (msg) CosmosMaster_ChatCommandsHelpDisplay(); end
	Cosmos_RegisterChatCommand ( id, comlist, func, desc, CSM_CHAINNONE );
	-- Overwrite old help command.
	Cosmos_RegisterChatCommand ( "HELP", comlist, func, "", CSM_CHAINPRE );
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- Register the version command.
	comlist = COSMOS_VERSION_COMM;
	desc = COSMOS_VERSION_COMM_INFO;
	id = "COSMOSVERSION";
	func = function (msg) CosmosMaster_ChatVersionDisplay(); end
	Cosmos_RegisterChatCommand ( id, comlist, func, desc, CSM_CHAINNONE );
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- Register the reload ui command.
	comlist = COSMOS_RELOADUI_COMM;
	desc	= COSMOS_RELOADUI_COMM_INFO;
	id = "RELOADUI";
	func = function()
		ReloadUI();
	end
	Cosmos_RegisterChatCommand ( id, comlist, func, desc );
	--------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------
	-- Register (and setup) /stop
	CosmosStop_OnLoad();
	comlist = COSMOS_STOP_COMM;
	desc	= COSMOS_STOP_COMM_INFO;
	id = "STOP";
	func = function()
		Cosmos_Stop();
	end
	Cosmos_RegisterChatCommand ( id, comlist, func, desc );
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- Register the class CVar settings commands.
	comlist = COSMOS_CLASS_SETTINGS_COMM;
	desc	= format(COSMOS_CLASS_SETTINGS_COMM_INFO, COSMOS_CLASS_SETTINGS_PARAM_SAVE, COSMOS_CLASS_SETTINGS_PARAM_LOAD);
	id = "SETTINGSBYCLASS";
	func = function(msg)
		if ( ( not msg ) or ( strlen(msg) <= 0 ) ) then
			Sea.io.print(format(COSMOS_CLASS_SETTINGS_HELP1, COSMOS_CLASS_SETTINGS_PARAM_LOAD, COSMOS_CLASS_SETTINGS_PARAM_SAVE));
			return;
		end
		local command = strlower(msg);
		local class = UnitClass("player");
		if( strfind("save", command) ) then
			CosmosMaster_StoreVariables()
			if ( Cosmos_SaveDefaultSettingsForClass(class) ) then
				Sea.io.print(format(COSMOS_CLASS_SETTINGS_SAVED, class));
			else
				Sea.io.print(format(COSMOS_CLASS_SETTINGS_SAVED_ERROR, class));
			end
		elseif( strfind("load", command) ) then
			if ( Cosmos_LoadDefaultSettingsForClass(class) ) then
				CosmosMaster_LoadVariables();
				Sea.io.print(format(COSMOS_CLASS_SETTINGS_LOADED, class));
			else
				Sea.io.print(format(COSMOS_CLASS_SETTINGS_LOADED_ERROR, class));
			end
		else
			Sea.io.print(COSMOS_CLASS_SETTINGS_HELP2);
		end
	end
	Cosmos_RegisterChatCommand ( id, comlist, func, desc );
	--------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------
	-- Register the /f x command
	if (SLASH_FOLLOW4 == "/f") then
		SLASH_FOLLOW1 = "/fol";
		SLASH_FOLLOW4 = "/fol";
	end

	comlist = FCOMMAND_COMM;
	desc	= FCOMMAND_COMM_INFO;
	id = "FRIENDSCOMMAND";
	func = function(msg)
		local tbl = split(msg, " ");
		if (not tbl[1]) then return; end

		if (tbl[1] == "l" or tbl[1] == "list") then
			local m = ""
			local bool = 0;
			local numFriends = GetNumFriends();
			for i = 1, numFriends, 1 do
				local name, level, class, area, connected = GetFriendInfo(i);
				if (not connected) then
					if (bool == 0) then
						bool = 1;
						print1(FCOMMAND_ONLINE);
						print1(m);
						m = "";
					end
					m = m..MakeHyperLink("Player:"..name, name, "FF0000").." ";
				else
					m = m..MakeHyperLink("Player:"..name, name, "00FF00").." ";
				end
			end
			print1(FCOMMAND_OFFLINE);
			print1(m);
		elseif (tbl[1] == "a" or tbl[1] == "add") then
			if (tbl[2]) then
				AddFriend(tbl[2]);
			end
		elseif (tbl[1] == "r" or tbl[1] == "remove") then
			if (tbl[2]) then
				RemoveFriend(tbl[2]);
			end
		elseif (tbl[1] == "m" or tbl[1] == "message") then
			local m = strsub(msg, strlen(tbl[1]) + 1);
			if (not m or strlen(m) < 1) then return; end
			local numFriends = GetNumFriends();
			for i = 1, numFriends, 1 do
				local name, level, class, area, connected = GetFriendInfo(i);
				if (not connected) then
					break;
				end
				SendChatMessage(m, "WHISPER", this.language, name);
			end
		end
	end
	Cosmos_RegisterChatCommand ( id, comlist, func, desc );
	--------------------------------------------------------------------------------
end

-- Cosmos /stop command functions.  This command is obviously for macros.
function CosmosStop_OnLoad()
  HookFunction("MoveForwardStop","CosmosStop_AutoStop");
  HookFunction("MoveBackwardStop","CosmosStop_AutoStop");
  HookFunction("ToggleAutoRun","CosmosStop_AutoToggle");
end
function CosmosStop_AutoStop()
  CosmosStopAuto = false;
end
function CosmosStop_AutoToggle()
  CosmosStopAuto = not CosmosStopAuto;
end
function Cosmos_Stop()
  if(CosmosStopAuto) then
    CosmosStopAuto = false;
    ToggleAutoRun();
  end
  MoveForwardStop();
  MoveBackwardStop();
  TurnLeftStop();
  TurnRightStop();
end
