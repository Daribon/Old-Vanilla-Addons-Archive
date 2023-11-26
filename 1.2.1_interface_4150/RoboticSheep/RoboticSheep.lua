--[[
	Robotic Sheep

	By sarf

	This mod makes it easier to resheep enemies. Hopefully. :)

	Thanks goes to sancus for suggesting this.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
ROBOTICSHEEP_MAXIMUMNUMBEROFCYCLEDTARGETS_MIN = 5;
ROBOTICSHEEP_MAXIMUMNUMBEROFCYCLEDTARGETS_MAX = 50;
ROBOTICSHEEP_MAX_SHEEP_TIME = 30;

-- Variables
RoboticSheep_Enabled = 1;

RoboticSheep_CurrentNumberOfCycledTargets = 10;
RoboticSheep_ShouldRestoreOldTarget = 1;
RoboticSheep_LastDitchAttemptToReSheep = 0;

RoboticSheep_Saved_Hooked_Function = nil;
RoboticSheep_Cosmos_Registered = 0;
OneHitWonder_LastSheep = nil;
OneHitWonder_LastSheeped = nil;

RoboticSheep_OldTarget = nil;
RoboticSheep_ShouldSheepNextSheep = false;
RoboticSheep_SheepSearching = false;
RoboticSheep_CurrentSheepSearch = 0;

-- executed on load, calls general set-up functions
function RoboticSheep_OnLoad()
	RoboticSheep_Register();
end

-- registers the mod with Cosmos
function RoboticSheep_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( RoboticSheep_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_ROBOTICSHEEP",
			"SECTION",
			TEXT(ROBOTICSHEEP_CONFIG_HEADER),
			TEXT(ROBOTICSHEEP_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ROBOTICSHEEP_HEADER",
			"SEPARATOR",
			TEXT(ROBOTICSHEEP_CONFIG_HEADER),
			TEXT(ROBOTICSHEEP_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ROBOTICSHEEP_ENABLED",
			"CHECKBOX",
			TEXT(ROBOTICSHEEP_ENABLED),
			TEXT(ROBOTICSHEEP_ENABLED_INFO),
			RoboticSheep_Toggle_Enabled_NoChat,
			RoboticSheep_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS",
			"SLIDER",
			TEXT(ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS),
			TEXT(ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS_INFO),
			RoboticSheep_Change_CurrentNumberOfCycledTargets_NoChat,
			1,
			RoboticSheep_CurrentNumberOfCycledTargets,
			ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS_MIN,
			ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS_MAX,
			"",
			1,
			1,
			TEXT(ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS_APPEND)
		);
		if ( Cosmos_RegisterChatCommand ) then
			local RoboticSheepMainCommands = {"/roboticsheep","/robosheep"};
			Cosmos_RegisterChatCommand (
				"ROBOTICSHEEP_MAIN_COMMANDS", -- Some Unique Group ID
				RoboticSheepMainCommands, -- The Commands
				RoboticSheep_Main_ChatCommandHandler,
				ROBOTICSHEEP_CHAT_COMMAND_INFO -- Description String
			);
		end
		RoboticSheep_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function RoboticSheep_Register()
	if ( Cosmos_RegisterConfiguration ) then
		RoboticSheep_Register_Cosmos();
	else
		SlashCmdList["ROBOTICSHEEPSLASHMAIN"] = RoboticSheep_Main_ChatCommandHandler;
		SLASH_ROBOTICSHEEPSLASHMAIN1 = "/roboticsheep";
		SLASH_ROBOTICSHEEPSLASHMAIN2 = "/robosheep";
		this:RegisterEvent("VARIABLES_LOADED");
	end
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
end

function RoboticSheep_Extract_NextParameter(msg)
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

-- Handles chat - e.g. slashcommands - enabling/disabling the RoboticSheep
function RoboticSheep_Main_ChatCommandHandler(msg)
	
	local func = RoboticSheep_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		RoboticSheep_Print(ROBOTICSHEEP_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = RoboticSheep_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "state" ) ) then
		func = RoboticSheep_Toggle_Enabled;
	elseif ( strfind( commandName, "find" ) ) then
		func = RoboticSheep_FindSheep;
		toggleFunc = false;
	else
		RoboticSheep_Print(ROBOTICSHEEP_CHAT_COMMAND_USAGE);
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
function RoboticSheep_Hooked_Function()
	if ( RoboticSheep_Enabled == 1 ) then
	end
	RoboticSheep_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function RoboticSheep_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= RoboticSheep_Hooked_Function ) and (RoboticSheep_Saved_Hooked_Function == nil) ) then
			RoboticSheep_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = RoboticSheep_Hooked_Function;
		end
	else
		if ( Hooked_Function == RoboticSheep_Hooked_Function) then
			Hooked_Function = RoboticSheep_Saved_Hooked_Function;
			RoboticSheep_Saved_Hooked_Function = nil;
		end
	end
end

-- Handles events
function RoboticSheep_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( RoboticSheep_Cosmos_Registered == 0 ) then
			local value = 0;
			if ( not RoboticSheep_Enabled ) then
				value = getglobal("COS_ROBOTICSHEEP_ENABLED_X");
				if (value == nil ) then
					-- defaults to off
					value = 0;
				end
			else
				value = RoboticSheep_Enabled;
			end
			RoboticSheep_Toggle_Enabled(value);
			if ( not RoboticSheep_CurrentNumberOfCycledTargets ) then
				value = getglobal("COS_ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS");
				if (value == nil ) then
					-- defaults to 10
					value = 10;
				end
			else
				value = RoboticSheep_CurrentNumberOfCycledTargets;
			end
			RoboticSheep_Change_CurrentNumberOfCycledTargets(value);
		end
	end
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		RoboticSheep_SheepSearch();
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function RoboticSheep_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			RoboticSheep_Print(text);
		end
	end
	RoboticSheep_Register_Cosmos();
	if ( RoboticSheep_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		RoboticSheep_Generic_CosmosUpdateCheckOnOff(CVarName, newvalue);
		RoboticSheep_Generic_CosmosUpdateCheckOnOff(CosmosVarName, newvalue);
	end
	return newvalue;
end

-- Sets the value of an option.
function RoboticSheep_Generic_Value(value, variableName, CVarName, message, formatValueMessage)
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
			RoboticSheep_Print(text);
		end
	end
	RoboticSheep_Register_Cosmos();
	if ( RoboticSheep_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		RoboticSheep_Generic_CosmosUpdateValue(CVarName, newvalue);
		RoboticSheep_Generic_CosmosUpdateValue(CosmosVarName, newvalue);
	end
	return newvalue;
end

function RoboticSheep_Generic_CosmosUpdateCheckOnOff(varName, value)
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

function RoboticSheep_Generic_CosmosUpdateValue(varName, value)
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



-- Toggles the enabled/disabled state of the RoboticSheep
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function RoboticSheep_Toggle_Enabled(toggle)
	RoboticSheep_DoToggle_Enabled(toggle, true);
end

-- does the actual toggling
function RoboticSheep_DoToggle_Enabled(toggle, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = RoboticSheep_Generic_Toggle(toggle, "RoboticSheep_Enabled", "COS_ROBOTICSHEEP_ENABLED_X", "ROBOTICSHEEP_CHAT_ENABLED", "ROBOTICSHEEP_CHAT_DISABLED");
	else
		newvalue = RoboticSheep_Generic_Toggle(toggle, "RoboticSheep_Enabled", "COS_ROBOTICSHEEP_ENABLED_X");
	end
	RoboticSheep_Setup_Hooks(newvalue);
end

-- toggling - no text
function RoboticSheep_Toggle_Enabled_NoChat(toggle)
	RoboticSheep_DoToggle_Enabled(toggle, false);
end

-- Values the enabled/disabled state of the RoboticSheep
--  if value is 1, it's enabled
--  if value is 0, it's disabled
--   otherwise, it's valued
function RoboticSheep_Change_CurrentNumberOfCycledTargets(toggle, value)
	RoboticSheep_DoChange_CurrentNumberOfCycledTargets(value, true);
end

-- does the actual toggling
function RoboticSheep_DoChange_CurrentNumberOfCycledTargets(value, showText)
	local newvalue = 0;
	if ( showText ) then
		newvalue = RoboticSheep_Generic_Value(value, "RoboticSheep_CurrentNumberOfCycledTargets", "COS_ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS", nil, "ROBOTICSHEEP_CHAT_NUMBEROFCYCLEDTARGETS_CHANGED");
	else
		newvalue = RoboticSheep_Generic_Value(value, "RoboticSheep_CurrentNumberOfCycledTargets", "COS_ROBOTICSHEEP_NUMBEROFCYCLEDTARGETS");
	end
	RoboticSheep_Setup_Hooks(newvalue);
end

-- toggling - no text
function RoboticSheep_Change_CurrentNumberOfCycledTargets_NoChat(toggle, value)
	RoboticSheep_DoChange_CurrentNumberOfCycledTargets(value, false);
end

-- Prints out text to a chat box.
function RoboticSheep_Print(msg,r,g,b,frame,id,unknown4th)
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


-- stolen from OHW
function RoboticSheep_HasUnitEffect(unitName, texture, name)
	local id = 1;
	local i, buffName;
	local buffIndex, untilCancelled;
	local textureList = {};
	if ( type(texture) == "table" ) then
		textureList = texture;
	else
		textureList = { texture };
	end
	local nameList = {};
	if ( type(name) == "table" ) then
		nameList = name;
	else
		nameList = { name };
	end
	if ( name ) then
		for i = 0, MAX_PARTY_TOOLTIP_BUFFS do
			buffName = OneHitWonder_GetBuffNameUsingBuffIndex(unitName, i);
			if ( OneHitWonder_IsStringInList(buffName, nameList) ) then
				return true;
			end
		end
		for i = 0, MAX_PARTY_TOOLTIP_DEBUFFS do
			buffName = OneHitWonder_GetBuffNameUsingBuffIndex(unitName, i, true);
			if ( OneHitWonder_IsStringInList(buffName, nameList) ) then
				return true;
			end
		end
	end
	if ( texture ) then
		local buffTexture = nil;
		for i = 0, MAX_PARTY_TOOLTIP_BUFFS do
			buffTexture = UnitBuff(unitName, i);
			if ( OneHitWonder_IsStringInList(buffTexture, textureList) ) then
				return true;
			end
		end
		for i = 0, MAX_PARTY_TOOLTIP_DEBUFFS do
			buffTexture = UnitDebuff(unitName, i);
			if ( OneHitWonder_IsStringInList(buffTexture, textureList) ) then
				return true;
			end
		end
	end
	return false;
end

-- also snitched from OHW
function RoboticSheep_ShowBigMessage(msg, r, g, b)
	if ( not r ) then
		r = 1.0;
	end
	if ( not g ) then
		g = 0.2;
	end
	if ( not b ) then
		b = 0.2;
	end
    ZoneTextString:SetText(msg);
    ZoneTextString:SetTextColor(1.0, 0.2, 0.2);
    ZoneTextFrame.startTime = GetTime();
    ZoneTextFrame:Show();
    PlaySound("MapPing");
end



function RoboticSheep_GetSheepSpellName(rank)
	if ( ( rank ) and ( rank > 0 ) ) then
		return ROBOTICSHEEP_SHEEP_SPELL_NAME..format(ROBOTICSHEEP_RANK_FORMAT, rank);
	else
		return nil;
	end
end

function RoboticSheep_CastSheep()
	if ( OneHitWonder_GetSpellId ) then
		if ( OneHitWonder_CastSpell ) then
			OneHitWonder_CastSpell(OneHitWonder_GetSpellId(ROBOTICSHEEP_SHEEP_SPELL_NAME));
			return;
		end
	end
	-- use ugly solution
	local rank = nil;
	local spellName = nil;
	for rank = 9, 1, -1 do
		spellName = RoboticSheep_GetSheepSpellName(rank);
		if ( spellName ) then
			CastSpellByName(spellName);
		end
	end
end

function RoboticSheep_FoundSheep()
	local unitName = UnitName("target");
	if ( ( unitName ) and ( strlen(unitName) <= 0 ) ) then
		unitName = nil;
	end
	if ( ( unitName ) and ( not strfind(unitName, ROBOTICSHEEP_REAL_SHEEP_NAME ) ) ) then
		if ( RoboticSheep_HasUnitEffect("target", ROBOTICSHEEP_SHEEP_SPELL_TEXTURE_EFFECT, ROBOTICSHEEP_SHEEP_SPELL_NAME) ) then
			return true;
		end
	end
	return false;
end

-- nothing naughty!
function RoboticSheep_DoSheep(override)
	if ( not override) and ( OneHitWonder_AddActionToQueue ) then
		local parameters = { OneHitWonder_GetSpellId(ROBOTICSHEEP_SHEEP_SPELL_NAME), GetTime() + timeout};
		OneHitWonder_AddActionToQueue(ONEHITWONDER_ACTIONID_SPELL_TIMEOUT, parameters);
		RoboticSheep_ShowBigMessage(TEXT(ROBOTICSHEEP_FOUND_SHEEP_OHW));
	else
		RoboticSheep_CastSheep();
		RoboticSheep_ShowBigMessage(TEXT(ROBOTICSHEEP_FOUND_SHEEP));
	end
	OneHitWonder_LastSheep = UnitName("target");
	OneHitWonder_LastSheeped = GetTime();
end


function RoboticSheep_SheepSearch(override)
	if ( ( not RoboticSheep_SheepSearching ) and ( not override ) ) then
		return false;
	end
	local foundSheep = RoboticSheep_FoundSheep();
	if ( foundSheep ) then
		RoboticSheep_SheepSearching = false;
		if ( RoboticSheep_ShouldSheepNextSheep ) then
			RoboticSheep_DoSheep(override);
		else
			RoboticSheep_ShowBigMessage(TEXT(ROBOTICSHEEP_FOUND_SHEEP));
		end
		RoboticSheep_ShouldSheepNextSheep = false;
		RoboticSheep_CurrentSheepSearch = 0;
		return true;
	end
	RoboticSheep_CurrentSheepSearch = RoboticSheep_CurrentSheepSearch + 1;
	if ( ( not override) and ( RoboticSheep_CurrentSheepSearch > RoboticSheep_CurrentNumberOfCycledTargets ) ) then
		if ( ( RoboticSheep_LastDitchAttemptToReSheep == 1 ) and ( not foundSheep ) and ( OneHitWonder_LastSheep ) ) then
			local unitName = UnitName("target");
			if ( ( unitName == OneHitWonder_LastSheep ) and ( UnitHealth("target") == UnitHealthMax("target") ) ) then
				RoboticSheep_DoSheep(override);
			else
				if ( GetTime()-OneHitWonder_LastSheeped <= ROBOTICSHEEP_MAX_SHEEP_TIME ) then
					TargetByName(OneHitWonder_LastSheep);
					RoboticSheep_DoSheep(override);
				end
			end
		end
		RoboticSheep_SheepSearching = false;
		RoboticSheep_RestoreOldTarget();
	else
		RoboticSheep_FindNextSheep();
	end
	return false;
end

function RoboticSheep_FindNextSheep()
	TargetNearestEnemy();
end

function RoboticSheep_FindSheep()
	RoboticSheep_OldTarget = nil;
	if ( RoboticSheep_ShouldRestoreOldTarget == 1 ) then
		RoboticSheep_OldTarget = UnitName("target");
	end
	if ( ( RoboticSheep_OldTarget ) and ( strlen(RoboticSheep_OldTarget) <= 0 ) ) then
		RoboticSheep_OldTarget = nil;
	end
	ClearTarget();
	RoboticSheep_StartSheepSearch();
	--RoboticSheep_SheepSearch();
end

function RoboticSheep_RestoreOldTarget()
	if ( RoboticSheep_ShouldRestoreOldTarget == 1 ) then
		if ( ( RoboticSheep_OldTarget ) and ( strlen(RoboticSheep_OldTarget) > 0 ) ) then
			TargetByName(RoboticSheep_OldTarget);
			RoboticSheep_OldTarget = nil;
		else
			ClearTarget();
		end
	end
end

function RoboticSheep_StartSheepSearch()
	RoboticSheep_CurrentSheepSearch = 0;
	RoboticSheep_SheepSearching = true;
	RoboticSheep_FindNextSheep();
end

function RoboticSheep_Binding_FindSheep()
	if ( not RoboticSheep_IsEnabled() ) then
		return;
	end
	RoboticSheep_FindSheep();
end

function RoboticSheep_Binding_FindSheepAndResheepify()
	RoboticSheep_ShouldSheepNextSheep = true;
	RoboticSheep_Binding_FindSheep();
end


function RoboticSheep_Binding_CycleSheep()
	if ( RoboticSheep_SheepSearch(true) ) then
		ClearTarget();
	end
end

function RoboticSheep_IsEnabled()
	if ( RoboticSheep_Enabled == 1 ) then
		if ( OneHitWonder_GetPlayerClass ) then
			if( OneHitWonder_GetPlayerClass() == ONEHITWONDER_CLASS_MAGE ) then
				return true;
			end
		else
			return true;
		end
	end
	return false;
end
