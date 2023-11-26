--[[
	On Screen Alert

	By sarf

	This mod allows the user to choose certain events that he wants to be alerted to when they occur.

	Thanks goes to everyone who suggested this and "Earl Grey Cream Tea" which allowed me to finish it.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
ONSCREENALERT_RACE_TROLL = "Troll";

ONSCREENALERT_CLASS_PALADIN = "Paladin";
ONSCREENALERT_CLASS_WARLOCK = "Warlock";
ONSCREENALERT_CLASS_WARRIOR = "Warrior";

ONSCREENALERT_CLEARCAST_CHAT_MESSAGE = "Clearcast";
ONSCREENALERT_CLEARCAST = "Clearcast";

ONSCREENALERT_ELEMENTAL_FOCUS_CHAT_MESSAGE = "Elemental Focus";
ONSCREENALERT_ELEMENTAL_FOCUS = "Elemental Focus";

ONSCREENALERT_NIGHTFALL_CHAT_MESSAGE = "Nightfall";
ONSCREENALERT_NIGHTFALL = "Nightfall";
ONSCREENALERT_BERSERK_ABILITY_LIMIT = 0.2;
ONSCREENALERT_BERSERK = "Berserk";
ONSCREENALERT_EXECUTE_ABILITY_LIMIT = 0.2;
ONSCREENALERT_EXECUTE = "Execute";
ONSCREENALERT_DIVINEPROTECTION_ABILITY_LIMIT = 0.2;
ONSCREENALERT_DIVINEPROTECTION = "Divine Protection";
ONSCREENALERT_PARTY_MEMBER_HEALTH_LIMIT = 0.5;
ONSCREENALERT_PARTY_MEMBER_HEALTH = "PartyMemberHealth";


OnScreenAlert_ActiveAlerts = {};

OnScreenAlert_AlertQueue = {};
OnScreenAlert_LastAlert = 0;
OnScreenAlert_TimeBetweenAlerts = 1;
OnScreenAlert_PartyHealthNotification = 1;

OnScreenAlert_DefaultSettings = {
	["lastAlertTime"] = 0,
	["minimumTimeBetweenAlerts"] = 5,
	["alertSound"] = "TellMessage",
	["alertMessage"] = nil
};


-- Variables
OnScreenAlert_Enabled = 0;

OnScreenAlert_Saved_Hooked_Function = nil;
OnScreenAlert_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function OnScreenAlert_OnLoad()
	OnScreenAlert_Register();
end

-- registers the mod with Cosmos
function OnScreenAlert_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( OnScreenAlert_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_ONSCREENALERT",
			"SECTION",
			TEXT(ONSCREENALERT_CONFIG_HEADER),
			TEXT(ONSCREENALERT_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONSCREENALERT_HEADER",
			"SEPARATOR",
			TEXT(ONSCREENALERT_CONFIG_HEADER),
			TEXT(ONSCREENALERT_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ONSCREENALERT_ENABLED",
			"CHECKBOX",
			TEXT(ONSCREENALERT_ENABLED),
			TEXT(ONSCREENALERT_ENABLED_INFO),
			OnScreenAlert_Toggle_Enabled_NoChat,
			OnScreenAlert_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_ONSCREENALERT_PARTYHEALTH_NOTIFICATION",
			"BOTH",
			TEXT(ONSCREENALERT_PARTYHEALTH_NOTIFICATION),
			TEXT(ONSCREENALERT_PARTYHEALTH_NOTIFICATION_INFO),
			OnScreenAlert_Toggle_PartyHealthNotification_NoChat,
			OnScreenAlert_PartyHealthNotification,
			ONSCREENALERT_PARTY_MEMBER_HEALTH_LIMIT,
			0,
			1,
			ONSCREENALERT_PARTYHEALTH_NOTIFICATION_SUBSTRING,
			0.01,
			1,
			ONSCREENALERT_PARTYHEALTH_NOTIFICATION_APPEND,
			100
		);
		if ( Cosmos_RegisterChatCommand ) then
			local OnScreenAlertMainCommands = {"/onscreenalert","/osa"};
			Cosmos_RegisterChatCommand (
				"ONSCREENALERT_MAIN_COMMANDS", -- Some Unique Group ID
				OnScreenAlertMainCommands, -- The Commands
				OnScreenAlert_Main_ChatCommandHandler,
				ONSCREENALERT_CHAT_COMMAND_INFO -- Description String
			);
		end
		OnScreenAlert_Cosmos_Registered = 1;
	end
end

function OnScreenAlert_RegisterChatMessages()
	local chatList = {
		"SPELL_SELF_DAMAGE",
		"SPELL_SELF_BUFF",
		"SPELL_PET_DAMAGE",
		"SPELL_PET_BUFF",
		"SPELL_PARTY_DAMAGE",
		"SPELL_PARTY_BUFF",
		"SPELL_FRIENDLYPLAYER_DAMAGE",
		"SPELL_FRIENDLYPLAYER_BUFF"
	};
	for k, v in chatList do
		this:RegisterEvent("CHAT_MSG"..v);
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function OnScreenAlert_Register()
	if ( Cosmos_RegisterConfiguration ) then
		OnScreenAlert_Register_Cosmos();
	else
		SlashCmdList["ONSCREENALERTSLASHMAIN"] = OnScreenAlert_Main_ChatCommandHandler;
		SLASH_ONSCREENALERTSLASHMAIN1 = "/onscreenalert";
		SLASH_ONSCREENALERTSLASHMAIN2 = "/osa";
		this:RegisterEvent("VARIABLES_LOADED");
	end
	this:RegisterEvent("UNIT_HEALTH");
end

function OnScreenAlert_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the OnScreenAlert
function OnScreenAlert_Main_ChatCommandHandler(msg)
	
	local func = OnScreenAlert_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		OnScreenAlert_Print(ONSCREENALERT_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = OnScreenAlert_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "party" ) ) then
		func = OnScreenAlert_Toggle_PartyHealthNotification;
		local param;
		param, params = OnScreenAlert_Extract_NextParameter(params);
		
		local paramNumber = tonumber(param);
		
		if ( ( paramNumber ) and ( paramNumber > 0 ) and ( paramNumber < 1 ) ) then
			func(OnScreenAlert_PartyHealthNotification, paramNumber);
		elseif ( ( param == "off" ) or ( param == "0" ) ) then
			local param2;
			param2, params = OnScreenAlert_Extract_NextParameter(params)
			if ( ( not param2 ) or (strlen(param2) == 0) ) then
				func(0);
			else
				local value = tonumber(param2);
				if ( ( value > 1 ) and (value <= 100) ) then
					value = value / 100;
				end
				func(0, value);
			end
		elseif ( ( param == "on" ) or ( param == "1" ) ) then
			local param2;
			param2, params = OnScreenAlert_Extract_NextParameter(params)
			if ( ( not param2 ) or (strlen(param2) == 0) ) then
				func(1);
			else
				local value = tonumber(param2);
				if ( ( value > 1 ) and (value <= 100) ) then
					value = value / 100;
				end
				func(1, value);
			end
		elseif ( ( param == "toggle" ) or ( param == "-1" ) ) then
			local param2;
			param2, params = OnScreenAlert_Extract_NextParameter(params)
			if ( ( not param2 ) or (strlen(param2) == 0) ) then
				func(-1);
			else
				local value = tonumber(param2);
				if ( ( value > 1 ) and (value <= 100) ) then
					value = value / 100;
				end
				func(-1, value);
			end
		else
			OnScreenAlert_Print(ONSCREENALERT_CHAT_COMMAND_USAGE);
		end
		return;
	elseif ( ( strfind( commandName, "state" ) ) or ( strfind( commandName, "show" ) ) or ( strfind( commandName, "toggle" ) ) ) then
		func = OnScreenAlert_Toggle_Enabled;
	else
		OnScreenAlert_Print(ONSCREENALERT_CHAT_COMMAND_USAGE);
		return;
	end
	
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
		func();
	end
end

-- Does things with the hooked function
function OnScreenAlert_Hooked_Function()
	if ( OnScreenAlert_Enabled == 1 ) then
	end
	OnScreenAlert_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function OnScreenAlert_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= OnScreenAlert_Hooked_Function ) and (OnScreenAlert_Saved_Hooked_Function == nil) ) then
			OnScreenAlert_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = OnScreenAlert_Hooked_Function;
		end
	else
		if ( Hooked_Function == OnScreenAlert_Hooked_Function) then
			Hooked_Function = OnScreenAlert_Saved_Hooked_Function;
			OnScreenAlert_Saved_Hooked_Function = nil;
		end
	end
end

function OnScreenAlert_ChatMessage(msg)
	if ( strfind(msg, ONSCREENALERT_NIGHTFALL_CHAT_MESSAGE) ) then
		if ( UnitClass("player") == ONSCREENALERT_CLASS_WARLOCK ) then
			OnScreenAlert_Alert(ONSCREENALERT_NIGHTFALL);
		end
	end
	if ( strfind(msg, ONSCREENALERT_CLEARCAST_CHAT_MESSAGE) ) then
		if ( UnitClass("player") == ONSCREENALERT_CLASS_MAGE ) then
			OnScreenAlert_Alert(ONSCREENALERT_CLEARCAST);
		end
		if ( UnitClass("player") == ONSCREENALERT_CLASS_SHAMAN ) then
			OnScreenAlert_Alert(ONSCREENALERT_CLEARCAST);
		end
	end
	if ( strfind(msg, ONSCREENALERT_ELEMENTAL_FOCUS_CHAT_MESSAGE) ) then
		if ( UnitClass("player") == ONSCREENALERT_CLASS_SHAMAN ) then
			OnScreenAlert_Alert(ONSCREENALERT_ELEMENTAL_FOCUS);
		end
	end
end

-- Handles events
function OnScreenAlert_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( OnScreenAlert_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_ONSCREENALERT_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			OnScreenAlert_Toggle_Enabled(value);
		end
	end
	if ( event == "UNIT_HEALTH" ) then
		OnScreenAlert_HealthUpdated(arg1);
	end
	if ( strfind(event, "CHAT_MSG" ) ) then
		OnScreenAlert_ChatMessage(arg1);
	end
end

function OnScreenAlert_GetCurrentPercentageHealth(unit)
	local health = UnitHealth(unit);
	local maxHealth = UnitHealthMax(unit);
	if ( ( not health ) or ( not maxHealth ) ) then
		return 0;
	end
	return (health / maxHealth);
end

function OnScreenAlert_PlayerHealthUpdated()
	local currentValue = OnScreenAlert_GetCurrentPercentageHealth("player");
	if ( ( currentValue > 0 ) and ( UnitRace("player") == ONSCREENALERT_RACE_TROLL ) ) then
		if ( currentValue <= ONSCREENALERT_BERSERK_ABILITY_LIMIT ) then
			OnScreenAlert_Alert(ONSCREENALERT_BERSERK);
		end
	end
	if ( ( currentValue > 0 ) and ( UnitClass("player") == ONSCREENALERT_CLASS_PALADIN ) ) then
		if ( currentValue <= ONSCREENALERT_DIVINEPROTECTION_ABILITY_LIMIT ) then
			OnScreenAlert_Alert(ONSCREENALERT_DIVINEPROTECTION);
		end
	end
end	

function OnScreenAlert_TargetHealthUpdated()
	local currentValue = OnScreenAlert_GetCurrentPercentageHealth("target");
	if ( ( currentValue > 0 ) and ( currentValue <= ONSCREENALERT_EXECUTE_ABILITY_LIMIT ) and ( UnitClass("player") == ONSCREENALERT_CLASS_WARRIOR ) ) then
		OnScreenAlert_Alert(ONSCREENALERT_EXECUTE);
	end
end	

function OnScreenAlert_PartyHealthUpdated(unit)
	local currentValue = OnScreenAlert_GetCurrentPercentageHealth(unit);
	if ( ( currentValue > 0 ) and ( currentValue <= ONSCREENALERT_PARTY_MEMBER_HEALTH_LIMIT ) ) then
		local number = strsub(unit, 6);
		if ( number ) then
			OnScreenAlert_Alert(ONSCREENALERT_PARTY_MEMBER_HEALTH..number);
		end
	end
end	

function OnScreenAlert_HealthUpdated(unit)
	if ( unit == "player" ) then
		OnScreenAlert_PlayerHealthUpdated();
	elseif ( unit == "target" ) then
		OnScreenAlert_TargetHealthUpdated();
	elseif ( strfind(unit, "party") ) then
		OnScreenAlert_PartyHealthUpdated(unit);
	end
end

function OnScreenAlert_AddAlert(alert, options)
	OnScreenAlert_ActiveAlerts[alert] = {};
	if ( options ) then
		for k, v in options do
			OnScreenAlert_ActiveAlerts[alert][k] = v;
		end
	end
end

function OnScreenAlert_RemoveAlert(alert)
	OnScreenAlert_ActiveAlerts[alert] = nil;
end

function OnScreenAlert_Alert(alert)
	local curTime = GetTime();
	local element = OnScreenAlert_DefaultSettings;
	if ( not OnScreenAlert_ActiveAlerts[alert] ) then
		return;
	else
		for k, v in OnScreenAlert_ActiveAlerts[alert] do
			element[k] = v;
		end
		local timeNeeded = element.lastAlertTime;
		if ( not timeNeeded ) then
			timeNeeded = 0;
		end
		local addTime = element.minimumTimeBetweenAlerts;
		if ( not addTime ) then
			addTime = 5;
		end
		timeNeeded = timeNeeded + addTime;
		if ( timeNeeded < curTime ) then
			OnScreenAlert_QueueAlert(alert);
		end
	end
end

function OnScreenAlert_ExecuteAlert(alert)
	local element = OnScreenAlert_DefaultSettings;
	if ( type(alert) == "table" ) then
		alert = alert[1];
	end
	if ( not OnScreenAlert_ActiveAlerts[alert] ) then
		return;
	else
		OnScreenAlert_ActiveAlerts[alert].lastAlertTime = GetTime();
		for k, v in OnScreenAlert_ActiveAlerts[alert] do
			element[k] = v;
		end
		if ( element.alertSound ) then PlaySound(element.alertSound) end;
		if ( element.alertMessage ) then OnScreenAlert_ShowMessage(element.alertMessage); end;
	end
end

function OnScreenAlert_GetName(str)
	if ( not str ) then
		return "<not set>";
	else
		return str;
	end
end

function OnScreenAlert_PrepareMessage(msg)
	for i = 1, 4 do
		msg = string.gsub(msg, "_PM"..i.."_", OnScreenAlert_GetName(UnitName("party"..i)));
	end
	return msg;
end

function OnScreenAlert_OnUpdate()
	if ( not OnScreenAlert_Enabled ) or ( OnScreenAlert_Enabled ~= 1 ) then
		return;
	end
	if ( getn(OnScreenAlert_AlertQueue) <= 0 ) then
		return;
	end
	local curTime = GetTime();
	if ( OnScreenAlert_LastAlert + OnScreenAlert_TimeBetweenAlerts ) then
		OnScreenAlert_LastAlert = curTime;
		OnScreenAlert_ExecuteAlert(table.remove(OnScreenAlert_AlertQueue));
	end
end

function OnScreenAlert_QueueAlert(alert)
	if ( not OnScreenAlert_Enabled ) or ( OnScreenAlert_Enabled ~= 1 ) then
		return;
	end
	table.insert(OnScreenAlert_AlertQueue, alert);
end

function OnScreenAlert_ShowMessage(msg)
    ZoneTextString:SetText(msg);
    SubZoneTextString:SetText("");
    PVPInfoTextString:SetText("");
    ZoneTextString:SetTextColor(1.0, 0.2, 0.2);
    ZoneTextFrame.startTime = GetTime();
    ZoneTextFrame:Show();
    OnScreenAlert_Print("OSA: "..msg);
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function OnScreenAlert_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
	local oldvalue = getglobal(variableName);
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		local text = "";
		if ( newvalue == 1 ) then
			if ( enableMessage ) then
				text = TEXT(getglobal(enableMessage));
			end
		else
			if ( disableMessage ) then
				text = TEXT(getglobal(disableMessage));
			end
		end
		if ( text ) and ( strlen(text) > 0 ) then
			OnScreenAlert_Print(text);
		end
	end
	OnScreenAlert_Register_Cosmos();
	if ( OnScreenAlert_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		OnScreenAlert_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		OnScreenAlert_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

function OnScreenAlert_Generic_CosmosUpdateCheckOnOff(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_CHECKONOFF, value);
	end
end

function OnScreenAlert_Generic_CosmosUpdateValue(varName, value)
	if ( not Cosmos_UpdateValue ) then
		return;
	end
	local name = varName;
	if ( ( not name ) or ( strlen(name) <= 0 ) ) then
		return
	end
	if ( strfind(name, "_X" ) ) then
		name = strsub(name, 1, strlen(name)-2);
	end
	if ( ( name ) and ( strlen(name) > 0 ) ) then
		Cosmos_UpdateValue(name, CSM_SLIDERVALUE, value);
	end
end

-- Toggles the enabled/disabled state of the OnScreenAlert
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function OnScreenAlert_Toggle_Enabled(toggle)
	OnScreenAlert_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function OnScreenAlert_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = OnScreenAlert_Generic_Toggle(toggle, "OnScreenAlert_Enabled", "COS_ONSCREENALERT_ENABLED_X", "ONSCREENALERT_CHAT_ENABLED", "ONSCREENALERT_CHAT_DISABLED");
	else
		newvalue = OnScreenAlert_Generic_Toggle(toggle, "OnScreenAlert_Enabled", "COS_ONSCREENALERT_ENABLED_X");
	end
	if ( newvalue == 1 ) then
		OnScreenAlert_AddSelfHealthAlerts();
		OnScreenAlert_AddTargetHealthAlerts();
		OnScreenAlert_AddChatAlerts();
	else
		OnScreenAlert_RemoveSelfHealthAlerts();
		OnScreenAlert_RemoveTargetHealthAlerts();
		OnScreenAlert_RemoveChatAlerts();
	end
	OnScreenAlert_Setup_Hooks(newvalue);
end

-- toggling - no text
function OnScreenAlert_Toggle_Enabled_NoChat(toggle)
	OnScreenAlert_DoToggle_Enabled(toggle, false);
end

--   otherwise, it's toggled
function OnScreenAlert_Toggle_PartyHealthNotification(toggle, value)
	OnScreenAlert_DoToggle_PartyHealthNotification(toggle, value, true);
end

-- does the actual toggling
function OnScreenAlert_DoToggle_PartyHealthNotification(toggle, value, showText)
	local oldvalue = OnScreenAlert_PartyHealthNotification;
	local newvalue = 0;
	if ( showText ) then
		newvalue = OnScreenAlert_Generic_Toggle(toggle, "OnScreenAlert_PartyHealthNotification", "COS_ONSCREENALERT_PARTYHEALTH_NOTIFICATION_X");
	else
		newvalue = OnScreenAlert_Generic_Toggle(toggle, "OnScreenAlert_PartyHealthNotification", "COS_ONSCREENALERT_PARTYHEALTH_NOTIFICATION_X");
	end
	if ( value ) then
		OnScreenAlert_Generic_CosmosUpdateValue("COS_ONSCREENALERT_PARTYHEALTH_NOTIFICATION", value);
		ONSCREENALERT_PARTY_MEMBER_HEALTH_LIMIT = value;
		if ( ( newvalue == oldvalue) and ( showText ) ) then
			OnScreenAlert_Print(format(TEXT(ONSCREENALERT_CHAT_PARTYHEALTH_NOTIFICATION_CHANGED), ONSCREENALERT_PARTY_MEMBER_HEALTH_LIMIT*100));
		end
	end
	if ( ( newvalue ~= oldvalue) and ( showText ) ) then
		if ( newvalue == 1 ) then
			OnScreenAlert_Print(format(TEXT(ONSCREENALERT_CHAT_PARTYHEALTH_NOTIFICATION_ENABLED), ONSCREENALERT_PARTY_MEMBER_HEALTH_LIMIT*100));
		else
			OnScreenAlert_Print(TEXT(ONSCREENALERT_CHAT_PARTYHEALTH_NOTIFICATION_DISABLED));
		end
	end
	if ( newvalue == 1 ) then
		OnScreenAlert_AddPartyHealthAlerts();
	else
		OnScreenAlert_RemovePartyHealthAlerts();
	end
end

-- toggling - no text
function OnScreenAlert_Toggle_PartyHealthNotification_NoChat(toggle, value)
	OnScreenAlert_DoToggle_PartyHealthNotification(toggle, value, false);
end

-- Prints out text to a chat box.
function OnScreenAlert_Print(msg,r,g,b,frame,id,unknown4th)
	if ( Print ) then
		Print(msg, r, g, b, frame, id, unknown4th);
		return;
	end
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

function OnScreenAlert_AddSelfHealthAlerts()
	OnScreenAlert_AddAlert(ONSCREENALERT_BERSERK, { alertMessage = "Berserk!", minimumTimeBetweenAlerts = 121 } );
	OnScreenAlert_AddAlert(ONSCREENALERT_DIVINEPROTECTION, { alertMessage = "Use Divine Protection!", minimumTimeBetweenAlerts = 301 } );
end

function OnScreenAlert_AddTargetHealthAlerts()
	OnScreenAlert_AddAlert(ONSCREENALERT_EXECUTE, { alertMessage = "Finish it!", minimumTimeBetweenAlerts = 10 } );
end

function OnScreenAlert_AddPartyHealthAlerts()
	OnScreenAlert_AddAlert(ONSCREENALERT_PARTY_MEMBER_HEALTH.."1", { alertMessage = "_PM1_ is wounded", minimumTimeBetweenAlerts = 15 } );
	OnScreenAlert_AddAlert(ONSCREENALERT_PARTY_MEMBER_HEALTH.."2", { alertMessage = "_PM2_ is wounded", minimumTimeBetweenAlerts = 15 } );
	OnScreenAlert_AddAlert(ONSCREENALERT_PARTY_MEMBER_HEALTH.."3", { alertMessage = "_PM3_ is wounded", minimumTimeBetweenAlerts = 15 } );
	OnScreenAlert_AddAlert(ONSCREENALERT_PARTY_MEMBER_HEALTH.."4", { alertMessage = "_PM4_ is wounded", minimumTimeBetweenAlerts = 15 } );
end

function OnScreenAlert_AddChatAlerts()
	OnScreenAlert_AddAlert(ONSCREENALERT_NIGHTFALL, { alertMessage = "Nightfall!", alertSound = "gsCharacterSelectionEnterWorld", minimumTimeBetweenAlerts = 10 } );
	OnScreenAlert_AddAlert(ONSCREENALERT_CLEARCAST, { alertMessage = "Clearcast!", alertSound = "gsCharacterSelectionEnterWorld", minimumTimeBetweenAlerts = 0 } );
	OnScreenAlert_AddAlert(ONSCREENALERT_ELEMENTAL_FOCUS, { alertMessage = "Elemental Focus!", alertSound = "gsCharacterSelectionEnterWorld", minimumTimeBetweenAlerts = 0 } );
end

function OnScreenAlert_RemoveSelfHealthAlerts()
	OnScreenAlert_RemoveAlert(ONSCREENALERT_BERSERK);
	OnScreenAlert_RemoveAlert(ONSCREENALERT_DIVINEPROTECTION);
end

function OnScreenAlert_RemoveTargetHealthAlerts()
	OnScreenAlert_RemoveAlert(ONSCREENALERT_EXECUTE);
end

function OnScreenAlert_RemovePartyHealthAlerts()
	for i = 1, 4 do
		OnScreenAlert_RemoveAlert(ONSCREENALERT_PARTY_MEMBER_HEALTH..i);
	end
end

function OnScreenAlert_RemoveChatAlerts()
	OnScreenAlert_RemoveAlert(ONSCREENALERT_NIGHTFALL);
	OnScreenAlert_RemoveAlert(ONSCREENALERT_CLEARCAST);
	OnScreenAlert_RemoveAlert(ONSCREENALERT_ELEMENTAL_FOCUS);
end

