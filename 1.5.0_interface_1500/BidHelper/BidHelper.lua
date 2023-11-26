--[[
	BidHelper

	By sarf

	This mod helps keep track of bids.

	Thanks goes to 
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants

BIDHELPER_MAXIMUM_TIME_SAVED_SECONDS	= 12*60*60;

BIDHELPER_TYPE_GENERIC 					= "generic";
BIDHELPER_TYPE_SUCCESSFUL				= "successful";
BIDHELPER_TYPE_UNSUCCESSFUL				= "unsuccessful";

-- Variables
BidHelper_Bids = {};

BidHelper_Enabled = 1;
BidHelper_ShowGeneric = 1;
BidHelper_ShowSuccessful = 0;
BidHelper_ShowUnsuccessful = 1;

BidHelper_Saved_Hooked_Function = nil;
BidHelper_Cosmos_Registered = 0;
BidHelper_MessageFormats = {};

BidHelper_TooltipNumberOfBids = 5;



-- executed on load, calls general set-up functions
function BidHelper_OnLoad()
	BidHelper_Register();
end

-- registers the mod with Cosmos
function BidHelper_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( BidHelper_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_BIDHELPER",
			"SECTION",
			TEXT(BIDHELPER_CONFIG_HEADER),
			TEXT(BIDHELPER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_BIDHELPER_HEADER",
			"SEPARATOR",
			TEXT(BIDHELPER_CONFIG_HEADER),
			TEXT(BIDHELPER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_BIDHELPER_ENABLED",
			"CHECKBOX",
			TEXT(BIDHELPER_ENABLED),
			TEXT(BIDHELPER_ENABLED_INFO),
			BidHelper_Toggle_Enabled_NoChat,
			BidHelper_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_BIDHELPER_SHOW_SUCCESSFUL",
			"CHECKBOX",
			TEXT(BIDHELPER_SHOW_SUCCESSFUL),
			TEXT(BIDHELPER_SHOW_SUCCESSFUL_INFO),
			BidHelper_Toggle_ShowSuccessful_NoChat,
			BidHelper_ShowSuccessful
		);
		Cosmos_RegisterConfiguration(
			"COS_BIDHELPER_SHOW_UNSUCCESSFUL",
			"CHECKBOX",
			TEXT(BIDHELPER_SHOW_UNSUCCESSFUL),
			TEXT(BIDHELPER_SHOW_UNSUCCESSFUL_INFO),
			BidHelper_Toggle_ShowUnsuccessful_NoChat,
			BidHelper_ShowUnsuccessful
		);
		if ( Cosmos_RegisterChatCommand ) then
			local BidHelperMainCommands = {"/bidhelper","/bh"};
			Cosmos_RegisterChatCommand (
				"BIDHELPER_MAIN_COMMANDS", -- Some Unique Group ID
				BidHelperMainCommands, -- The Commands
				BidHelper_Main_ChatCommandHandler,
				BIDHELPER_CHAT_COMMAND_INFO -- Description String
			);
		end
		BidHelper_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function BidHelper_Register()
	RegisterForSave("BidHelper_Bids");
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		BidHelper_Register_Cosmos();
	else
		SlashCmdList["BIDHELPERSLASHMAIN"] = BidHelper_Main_ChatCommandHandler;
		SLASH_BIDHELPERSLASHMAIN1 = "/bidhelper";
		SLASH_BIDHELPERSLASHMAIN2 = "/bh";
	end
	for k, v in ChatTypeGroup["SYSTEM"] do
		this:RegisterEvent(v);
	end
	this:RegisterEvent("VARIABLES_LOADED");
end

function BidHelper_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the BidHelper
function BidHelper_Main_ChatCommandHandler(msg)
	
	local func = BidHelper_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		BidHelper_Print(BIDHELPER_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = BidHelper_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = BidHelper_Toggle_Enabled;
	elseif ( strfind( commandName, "successful" ) ) or ( strfind( commandName, "won" ) ) then
		func = BidHelper_Toggle_ShowSuccessful;
	elseif ( strfind( commandName, "unsuccessful" ) ) or ( strfind( commandName, "failed" ) ) then
		func = BidHelper_Toggle_ShowUnsuccessful;
	elseif ( strfind( commandName, "list" ) ) then
		func = BidHelper_ShowList;
		toggleFunc = false;
	elseif ( strfind( commandName, "clear" ) ) then
		BidHelper_Clear();
		BidHelper_Print(BIDHELPER_CHAT_CLEARED);
	else
		BidHelper_Print(BIDHELPER_CHAT_COMMAND_USAGE);
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
function BidHelper_Hooked_Function()
	if ( BidHelper_Enabled == 1 ) then
	end
	BidHelper_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function BidHelper_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= BidHelper_Hooked_Function ) and (BidHelper_Saved_Hooked_Function == nil) ) then
			BidHelper_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = BidHelper_Hooked_Function;
		end
	else
		if ( Hooked_Function == BidHelper_Hooked_Function) then
			Hooked_Function = BidHelper_Saved_Hooked_Function;
			BidHelper_Saved_Hooked_Function = nil;
		end
	end
end

-- Handles events
function BidHelper_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( BidHelper_Cosmos_Registered == 0 ) then
			local value = getglobal("BidHelper_Enabled");
			if (value == nil ) then
				-- defaults to on
				value = 1;
			end
			BidHelper_Toggle_Enabled(value);
		end
		BidHelper_CleanBids();
	end
	for k, v in ChatTypeGroup["SYSTEM"] do
		if ( event == v ) then
			BidHelper_OnSystemChatMessageEvent(arg1);
			return;
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function BidHelper_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			BidHelper_Print(text);
		end
	end
	BidHelper_Register_Cosmos();
	if ( BidHelper_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		BidHelper_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		BidHelper_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- Sets the value of an option.
function BidHelper_Generic_Value(value, variableName, CVarName, message, formatValueMessage)
	local oldvalue = getglobal(variableName);
	local newvalue = value;
	setglobal(variableName, newvalue);
	setglobal(CVarName, newvalue);
	if ( newvalue ~= oldvalue ) then
		local text = nil;
		if ( formatValueMessage ) then
			text = format(TEXT(getglobal(formatValueMessage)), newvalue);
		elseif ( message ) then
			text = TEXT(getglobal(formatValueMessage));
		end
		if ( text ) and ( strlen(text) > 0 ) then
			BidHelper_Print(text);
		end
	end
	BidHelper_Register_Cosmos();
	if ( BidHelper_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		BidHelper_Generic_CosmosUpdateValue(CVarName, newvalue);
		BidHelper_Generic_CosmosUpdateValue(CosmosVarName, newvalue);
	end
	return newvalue;
end

function BidHelper_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function BidHelper_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the BidHelper
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function BidHelper_Toggle_Enabled(toggle)
	BidHelper_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function BidHelper_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = BidHelper_Generic_Toggle(toggle, "BidHelper_Enabled", "COS_BIDHELPER_ENABLED_X", "BIDHELPER_CHAT_ENABLED", "BIDHELPER_CHAT_DISABLED");
	else
		newvalue = BidHelper_Generic_Toggle(toggle, "BidHelper_Enabled", "COS_BIDHELPER_ENABLED_X");
	end
	BidHelper_Setup_Hooks(newvalue);
	if ( newvalue == 1 ) then
		BidHelperMinimapButton:Show();
	else
		BidHelperMinimapButton:Hide();
	end
end

-- toggling - no text
function BidHelper_Toggle_Enabled_NoChat(toggle)
	BidHelper_DoToggle_Enabled(toggle, false);
end

-- Toggles the enabled/disabled state of the BidHelper
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function BidHelper_Toggle_ShowSuccessful(toggle)
	BidHelper_DoToggle_ShowSuccessful(toggle, true);
end

-- does the actual toggling
function BidHelper_DoToggle_ShowSuccessful(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = BidHelper_Generic_Toggle(toggle, "BidHelper_ShowSuccessful", "COS_BIDHELPER_SHOWSUCCESSFUL_X", "BIDHELPER_CHAT_SHOWSUCCESSFUL_ENABLED", "BIDHELPER_CHAT_SHOWUNSUCCESSFUL_DISABLED");
	else
		newvalue = BidHelper_Generic_Toggle(toggle, "BidHelper_ShowSuccessful", "COS_BIDHELPER_SHOWSUCCESSFUL_X");
	end
	BidHelper_Setup_Hooks(newvalue);
end

-- toggling - no text
function BidHelper_Toggle_ShowSuccessful_NoChat(toggle)
	BidHelper_DoToggle_ShowSuccessful(toggle, false);
end

-- Toggles the enabled/disabled state of the BidHelper
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function BidHelper_Toggle_ShowUnsuccessful(toggle)
	BidHelper_DoToggle_ShowUnsuccessful(toggle, true);
end

-- does the actual toggling
function BidHelper_DoToggle_ShowUnsuccessful(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = BidHelper_Generic_Toggle(toggle, "BidHelper_ShowUnsuccessful", "COS_BIDHELPER_SHOWUNSUCCESSFUL_X", "BIDHELPER_CHAT_SHOWUNSUCCESSFUL_ENABLED", "BIDHELPER_CHAT_SHOWUNSUCCESSFUL_DISABLED");
	else
		newvalue = BidHelper_Generic_Toggle(toggle, "BidHelper_ShowUnsuccessful", "COS_BIDHELPER_SHOWUNSUCCESSFUL_X");
	end
	BidHelper_Setup_Hooks(newvalue);
end

-- toggling - no text
function BidHelper_Toggle_ShowUnsuccessful_NoChat(toggle)
	BidHelper_DoToggle_ShowUnsuccessful(toggle, false);
end

-- Prints out text to a chat box.
function BidHelper_Print(msg,r,g,b,frame,id,unknown4th)
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

function BidHelper_GetTime()
	if ( Clock_GetTimeText ) then 
		return Clock_GetTimeText();
	end
	local hour, minute = GetGameTime();
	return format(TEXT(BIDHELPER_TIME_TWENTYFOURHOURS), hour, minute);
end

function BidHelper_Clear()
	BidHelper_Bids = {};
end

function BidHelper_AddBidString(bidString, msgType)
	if ( not msgType ) then
		msgType = BIDHELPER_TYPE_GENERIC;
	end
	local cTime = BidHelper_GetTime();
	local bidData = { time = GetTime(), clockTime = cTime, message = bidString, messageType = msgType };
	table.insert(BidHelper_Bids, bidData);
	
	local cooldownFrame = getglobal("BidHelperMinimapButtonCooldown");
	local start = GetTime();
	local duration = 5;
	local enable = 1;
	--CooldownFrame_SetTimer(cooldownFrame, start, duration, enable);
end

function BidHelper_GetEntryAsText(index)
	local data = BidHelper_Bids[index];
	if ( not data ) then
		return nil;
	end
	local formatStr = "%s %s";
	return format(formatStr, data.clockTime, data.message);
end

function BidHelper_IsValidMessageType(messageType)
	if ( messageType == BIDHELPER_TYPE_GENERIC ) and ( BidHelper_ShouldIncludeGenericMessages() ) then
		return true;
	elseif ( messageType == BIDHELPER_TYPE_UNSUCCESSFUL ) and ( BidHelper_ShouldIncludeFailedMessages() ) then
		return true;
	elseif ( messageType == BIDHELPER_TYPE_SUCCESSFUL ) and ( BidHelper_ShouldIncludeSuccessfulMessages() ) then
		return true;
	else
		return false;
	end
end

function BidHelper_GetEntriesAsTable(number)
	local index = table.getn(BidHelper_Bids);
	if ( not number ) then
		number = index;
	end
	local arr = {};
	local data = nil;
	local string = nil;
	while ( number > 0 ) and ( index >= 1 ) do
		data = BidHelper_Bids[index];
		if ( not data ) then
			break;
		else
			string = BidHelper_GetEntryAsText(index);
			if ( BidHelper_IsValidMessageType(data.messageType) ) then
				table.insert(arr, string);
				number = number - 1;
			end
		end
		index = index - 1;
	end
	return arr;
end

function BidHelper_GetEntriesAsText(number)
	local arr = BidHelper_GetEntriesAsTable(number);
	local string = "";
	for k, v in arr do
		string = string..v.."\n";
	end
	return string;
end

function BidHelper_ShowList()
	BidHelper_Print(BIDHELPER_LIST_HEADER);
	local entries = BidHelper_GetEntriesAsTable();
	if ( not entries ) or ( table.getn(entries) <= 0 ) then
		BidHelper_Print(TEXT(BIDHELPER_EMPTY_LIST));
	else
		for k, v in entries do
			BidHelper_Print(v);
		end
	end
end

function BidHelper_ShouldIncludeGenericMessages()
	return (BidHelper_ShowGeneric == 1);
end

function BidHelper_ShouldIncludeFailedMessages()
	return (BidHelper_ShowUnsuccessful == 1);
end

function BidHelper_ShouldIncludeSuccessfulMessages()
	return (BidHelper_ShowSuccessful == 1);
end

function BidHelper_GenerateValidMessageFormats(list)
	local validStrings = {};
	local validFormatStrings = {};
	for k, v in list do
		table.insert(validFormatStrings, v);
	end
	for k, v in validFormatStrings do
		str = v;
		index = strfind(str, "%%s");
		if ( index ) then
			--str = strsub(str, 1, index-1);
			str = string.gsub(str, "%%s", "%(%.%+%)");
		end
		validStrings[k] = str;
	end
	return validStrings;
end

function BidHelper_GenerateMessageFormats()
	local validStrings = { 
		[BIDHELPER_TYPE_GENERIC] = BidHelper_GenerateValidMessageFormats(BIDHELPER_GENERIC_MESSAGES),  
		[BIDHELPER_TYPE_SUCCESSFUL] = BidHelper_GenerateValidMessageFormats(BIDHELPER_SUCCESSFUL_MESSAGES),  
		[BIDHELPER_TYPE_UNSUCCESSFUL] = BidHelper_GenerateValidMessageFormats(BIDHELPER_FAILED_MESSAGES)
	};
	
	return validStrings;
end

function BidHelper_GetMessageFormats()
	if ( table.getn(BidHelper_MessageFormats) <= 0 ) then
		BidHelper_MessageFormats = BidHelper_GenerateMessageFormats();
	end
	return BidHelper_MessageFormats;
end

function BidHelper_OnSystemChatMessageEvent(msg)
	local messageTriggers = BidHelper_GetMessageFormats();
	if ( messageTriggers ) and ( type(messageTriggers) == "table" ) then
		for messageType, value in messageTriggers do
			for k, v in value do
				--if ( strfind(msg, v) ) then
				for itemName in string.gfind(msg, v) do
					BidHelper_AddBidString(msg, messageType);
					break;
				end
			end
		end
	end
end

function BidHelperMinimapButton_OnEnter()
	this.updateTooltip = TOOLTIP_UPDATE_TIME;
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText(BIDHELPER_TOOLTIP_HEADER);
	local arr = BidHelper_GetEntriesAsTable(BidHelper_TooltipNumberOfBids);
	if ( not arr ) or ( table.getn(arr) <= 0 ) then
		GameTooltip:AddLine(TEXT(BIDHELPER_EMPTY_LIST));
	else
		for k, v in arr do
			GameTooltip:AddLine(v);
		end
	end
	GameTooltip:Show();
end

function BidHelperMinimapButton_OnLeave()
	this.updateTooltip = nil;
	if ( GameTooltip:IsOwned(this) ) then
		GameTooltip:Hide();
	end
end

function BidHelperMinimapButton_OnUpdate(elapsed)
	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end
	if ( GameTooltip:IsOwned(this) ) then
		BidHelperMinimapButton_OnEnter();
	else
		this.updateTooltip = nil;
	end
end


function BidHelper_CleanBids()
	local i = 1;
	local data = nil;
	local curTime = GetTime();
	while ( getn(BidHelper_Bids) >= i ) do
		data = BidHelper_Bids[i];
		if ( not data ) then
			break;
		end
		if ( data.time > curTime ) or ( curTime - data.time > BIDHELPER_MAXIMUM_TIME_SAVED_SECONDS ) then
			table.remove(BidHelper_Bids, i);
		else
			i = i + 1;
		end
	end
end

function BidHelperMinimapButton_OnClick()
	BidHelper_ShowList();
end
