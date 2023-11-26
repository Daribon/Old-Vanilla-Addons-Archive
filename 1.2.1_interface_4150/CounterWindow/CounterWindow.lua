--[[
	Counter Window

	By sarf

	This mod ...

	Thanks goes to 
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
COUNTERWINDOW_XPCOUNTERTYPE_RESTED = 1;
COUNTERWINDOW_XPCOUNTERTYPE_LEFT_TO_LEVEL = 2;
COUNTERWINDOW_XPCOUNTERTYPE_TOTAL = 3;

COUNTERWINDOW_XPCOUNTERTYPE_MIN = 1;
COUNTERWINDOW_XPCOUNTERTYPE_MAX = 3;

-- Variables
CounterWindow_Enabled = 0;
CounterWindow_CurrentXPCounterType = 1;

CounterWindow_Saved_Hooked_Function = nil;
CounterWindow_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function CounterWindow_OnLoad()
	CounterWindow_Register();
end

-- registers the mod with Cosmos
function CounterWindow_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( CounterWindow_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW",
			"SECTION",
			TEXT(COUNTERWINDOW_CONFIG_HEADER),
			TEXT(COUNTERWINDOW_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_HEADER",
			"SEPARATOR",
			TEXT(COUNTERWINDOW_CONFIG_HEADER),
			TEXT(COUNTERWINDOW_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_ENABLED",
			"CHECKBOX",
			TEXT(COUNTERWINDOW_ENABLED),
			TEXT(COUNTERWINDOW_ENABLED_INFO),
			CounterWindow_Toggle_Enabled,
			CounterWindow_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_MEMORYCOUNTER_TOGGLE",
			"BUTTON",
			TEXT(COUNTERWINDOW_MEMORYCOUNTER_TOGGLE),
			TEXT(COUNTERWINDOW_MEMORYCOUNTER_TOGGLE_INFO),
			CounterWindow_Toggle_MemoryCounter,
			0,
			0,
			0,
			0,
			COUNTERWINDOW_MEMORYCOUNTER_TOGGLE_NAME
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_XPCOUNTER_TOGGLE",
			"BUTTON",
			TEXT(COUNTERWINDOW_XPCOUNTER_TOGGLE),
			TEXT(COUNTERWINDOW_XPCOUNTER_TOGGLE_INFO),
			CounterWindow_Toggle_XPCounter,
			0,
			0,
			0,
			0,
			COUNTERWINDOW_XPCOUNTER_TOGGLE_NAME
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_XPCOUNTER_TYPE",
			"SLIDER",
			TEXT(COUNTERWINDOW_XPCOUNTER_TYPE),
			TEXT(COUNTERWINDOW_XPCOUNTER_TYPE_INFO),
			CounterWindow_XPCounterTypeHandler,
			1,
			COUNTERWINDOW_XPCOUNTERTYPE_MIN,
			COUNTERWINDOW_XPCOUNTERTYPE_MIN,
			COUNTERWINDOW_XPCOUNTERTYPE_MAX,
			"",
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_MEGA_XPCOUNTER_TOGGLE",
			"BUTTON",
			TEXT(COUNTERWINDOW_MEGA_XPCOUNTER_TOGGLE),
			TEXT(COUNTERWINDOW_MEGA_XPCOUNTER_TOGGLE_INFO),
			CounterWindow_Toggle_MegaXPCounter,
			0,
			0,
			0,
			0,
			COUNTERWINDOW_XPCOUNTER_TOGGLE_NAME
		);
		Cosmos_RegisterConfiguration(
			"COS_COUNTERWINDOW_REGENCOUNTER_TOGGLE",
			"BUTTON",
			TEXT(COUNTERWINDOW_REGENCOUNTER_TOGGLE),
			TEXT(COUNTERWINDOW_REGENCOUNTER_TOGGLE_INFO),
			CounterWindow_Toggle_RegenCounter,
			0,
			0,
			0,
			0,
			COUNTERWINDOW_XPCOUNTER_TOGGLE_NAME
		);
		CounterWindow_Cosmos_Registered = 1;
	end
end

function CounterWindow_XPCounterTypeHandler(toggle, value)
	CounterWindow_CurrentXPCounterType = value;
	XPCounterWindowFrame.timeLastUpdated = 0; -- force update
	XPCounterWindowFrame_Update(); -- show value :)
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function CounterWindow_Register()
	if ( Cosmos_RegisterConfiguration ) then
		CounterWindow_Register_Cosmos();
	else
		SlashCmdList["COUNTERWINDOWSLASHENABLE"] = CounterWindow_Main_ChatCommandHandler;
		SLASH_COUNTERWINDOWSLASHENABLE1 = "/counterwindow";
		SLASH_COUNTERWINDOWSLASHENABLE2 = "/cw";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local CounterWindowEnableCommands = {"/counterwindow","/cw"};
		Cosmos_RegisterChatCommand (
			"COUNTERWINDOW_ENABLE_COMMANDS", -- Some Unique Group ID
			CounterWindowEnableCommands, -- The Commands
			CounterWindow_Main_ChatCommandHandler,
			COUNTERWINDOW_CHAT_COMMAND_INFO -- Description String
		);
	end
end


function CounterWindow_Extract_NextParameter(msg)
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


-- Handles chat - e.g. slashcommands - enabling/disabling the CounterWindow
function CounterWindow_Main_ChatCommandHandler(msg)
	
	local func = CounterWindow_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		CounterWindow_Print(COUNTERWINDOW_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = CounterWindow_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "mem" ) ) then
		func = CounterWindow_Toggle_MemoryCounter;
	elseif ( strfind( commandName, "megaxp" ) ) then
		func = CounterWindow_Toggle_MegaXPCounter;
	elseif ( strfind( commandName, "xp" ) ) then
		func = CounterWindow_Toggle_XPCounter;
	elseif ( strfind( commandName, "regen" ) ) then
		func = CounterWindow_Toggle_RegenCounter;
	elseif ( ( strfind( commandName, "help" ) ) or ( strfind( commandName, "/?" ) ) or ( strfind( commandName, "-?" ) ) ) then
		CounterWindow_Print(COUNTERWINDOW_CHAT_COMMAND_USAGE);
		return;
	elseif ( ( not params ) or ( strlen(params) <= 0 ) ) then
		-- defaults to show command
		params = commandName;
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

-- Handles chat - e.g. slashcommands - enabling/disabling the CounterWindow
function CounterWindow_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		CounterWindow_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			CounterWindow_Toggle_Enabled(0);
		else
			CounterWindow_Toggle_Enabled(-1);
		end
	end
end

-- Does things with the hooked function
function CounterWindow_Hooked_Function()
	if ( CounterWindow_Enabled == 1 ) then
	end
	CounterWindow_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function CounterWindow_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= CounterWindow_Hooked_Function ) and (CounterWindow_Saved_Hooked_Function == nil) ) then
			CounterWindow_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = CounterWindow_Hooked_Function;
		end
	else
		if ( Hooked_Function == CounterWindow_Hooked_Function) then
			Hooked_Function = CounterWindow_Saved_Hooked_Function;
			CounterWindow_Saved_Hooked_Function = nil;
		end
	end
end

-- Handles events
function CounterWindow_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( CounterWindow_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_COUNTERWINDOW_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			CounterWindow_Toggle_Enabled(value);
			local value = getglobal("COS_COUNTERWINDOW_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			CounterWindow_Toggle_Enabled(value);
		end
	end
end


function CounterWindow_UpdateWindow_OnLoad()
	this:RegisterForDrag("LeftButton");
	this.timeBetweenUpdates = 0.5;
	this.timeLastUpdated = GetTime() + 10;
end

function CounterWindow_Toggle_MemoryCounter()
	if ( not UIMemoryCounterWindowFrame ) then
		return;
	end
	if ( UIMemoryCounterWindowFrame:IsVisible() ) then
		UIMemoryCounterWindowFrame:Hide();
	else
		UIMemoryCounterWindowFrame:Show();
	end
end

function CounterWindow_Toggle_XPCounter()
	if ( not XPCounterWindowFrame ) then
		return;
	end
	if ( XPCounterWindowFrame:IsVisible() ) then
		XPCounterWindowFrame:Hide();
	else
		XPCounterWindowFrame:Show();
	end
end

function CounterWindow_Toggle_RegenCounter()
	if ( not RegenCounterWindowFrame ) then
		return;
	end
	if ( RegenCounterWindowFrame:IsVisible() ) then
		RegenCounterWindowFrame:Hide();
	else
		RegenCounterWindowFrame:Show();
		RegenCounterWindowFrame_Update();
	end
end

function XPCounterWindow_OnEnter()
	CounterWindowTooltip:SetOwner(this, "ANCHOR_RIGHT");
	local str = "";
	str = str.."Rested XP : "..XPCounterWindowFrame_GetRestedXP();
	str = str.."\nXP left to level : "..XPCounterWindowFrame_GetXPLeft();
	str = str.."\nTotal XP : "..XPCounterWindowFrame_GetXPTotal();
	if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
		DynamicData.util.protectTooltipMoney();
	end 
	CounterWindowTooltip:SetText(str);
	if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
		DynamicData.util.unprotectTooltipMoney();
	end 
	CounterWindowTooltip:Show();
end

function CounterWindow_UpdateWindow_OnLeave()
	if ( CounterWindowTooltip:IsOwned(this) ) then
		CounterWindowTooltip:Hide();
	end
end

function CounterWindow_Toggle_MegaXPCounter()
	if ( not XPMegaCounterWindowFrame ) then
		return;
	end
	if ( XPMegaCounterWindowFrame:IsVisible() ) then
		XPMegaCounterWindowFrame:Hide();
	else
		XPMegaCounterWindowFrame:Show();
	end
end

function CounterWindow_UpdateWindow_OnUpdate(elapsed)
	if ( not this.timeLastUpdated ) then
		this.timeLastUpdated = 0;
	end
	if ( not this.timeBetweenUpdates ) then
		this.timeBetweenUpdates = 0.5;
	end
	local curTime = GetTime();
	if ( ( this.timeLastUpdated + this.timeBetweenUpdates ) < curTime ) then
		if ( ( CounterWindow_Enabled == 1 ) and ( this:IsVisible() ) ) then
			this.timeLastUpdated = curTime;
			if ( this.updateFunction ) then
				this.updateFunction();
			end
		end
	end
end

function CounterWindow_UpdateWindow_OnEvent(event)
end

function CounterWindow_UpdateWindow_ToggleLockWindow()
	if ( this ) then
		if ( not this.isLocked ) then
			this.isLocked = 1;
		else
			if ( this.isLocked == 1 ) then
				this.isLocked = 0;
			else
				this.isLocked = 1;
			end
		end
	end
end

function CounterWindow_UpdateWindow_LockWindow(value)
	if ( this ) then
		if ( not value ) then
			CounterWindow_UpdateWindow_ToggleLockWindow();
		elseif ( value == 1 ) then
			this.isLocked = 1;
		elseif ( value == 1 ) then
			this.isLocked = 1;
		else
			CounterWindow_UpdateWindow_ToggleLockWindow();
		end
	end
end

function CounterWindow_UpdateWindow_SetText(text, window)
	if ( window ) then
		local fontString = getglobal(window:GetName().."Text");
		if ( not fontString ) then
			return;
		end
		if ( not text ) then
			fontString:SetText("");
		else
			fontString:SetText(text);
		end
	end
end

function UIMemoryCounterWindowFrame_OnLoad()
	this.timeBetweenUpdates = 1;
	this.updateFunction = UIMemoryCounterWindowFrame_Update;
end

function XPCounterWindow_OnLoad()
	this.timeBetweenUpdates = 1;
	this.updateFunction = XPCounterWindowFrame_Update;
end

function XPMegaCounterWindow_OnLoad()
	this.timeBetweenUpdates = 1;
	this.updateFunction = XPMegaCounterWindowFrame_Update;
end

function RegenCounterWindow_OnLoad()
	this.timeBetweenUpdates = 1;
	this.updateFunction = nil; -- updates handled by events
	--RegenCounterWindowFrame_Update;
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_HAPPINESS");
end

function XPCounterWindowFrame_GetRestedXP()
	local restedXPLeft = GetXPExhaustion();
	local restedXPLeftStr = restedXPLeft;
	if ( ( not restedXPLeft ) or ( restedXPLeft <= 0 ) ) then
		restedXPLeftStr = COUNTERWINDOW_DISPLAY_XPCOUNTER_ZERO;
	end
	local formatStr = CounterWindow_GetColorFormatString(0.0, 1.0, 0);
	return format(formatStr, restedXPLeftStr);
end

function XPCounterWindowFrame_GetXPLeft()
	local currentXP = UnitXP("player");
	local nextXP = UnitXPMax("player");
	local value = 1.0;
	if ( ( not nextXP ) or ( nextXP == 0 ) ) then
		value = 1.0;
	elseif ( currentXP > 0 ) then
		value = currentXP / nextXP;
	else
		value = 1.0;
	end
	return format(CounterWindow_GetColorFormatString(0, (0.5+(value/2)), 0), nextXP-currentXP);
end

function XPCounterWindowFrame_GetXPTotal()
	local currentXP = UnitXP("player");
	return format(CounterWindow_GetColorFormatString(0.0, 1.0, 0.0), currentXP);
end

function XPCounterWindowFrame_Update()
	local str = "";
	if ( CounterWindow_CurrentXPCounterType == COUNTERWINDOW_XPCOUNTERTYPE_RESTED ) then
		str = XPCounterWindowFrame_GetRestedXP();
	elseif ( CounterWindow_CurrentXPCounterType == COUNTERWINDOW_XPCOUNTERTYPE_LEFT_TO_LEVEL ) then
		str = XPCounterWindowFrame_GetXPLeft();
	elseif ( CounterWindow_CurrentXPCounterType == COUNTERWINDOW_XPCOUNTERTYPE_TOTAL ) then
		str = XPCounterWindowFrame_GetXPTotal();
	end
	CounterWindow_UpdateWindow_SetText(str, this);
end

function XPMegaCounterWindowFrame_Update()
	XPMegaCounterWindowFrameTextUpper:SetText(XPCounterWindowFrame_GetRestedXP());
	XPMegaCounterWindowFrameTextMiddle:SetText(XPCounterWindowFrame_GetXPLeft());
	XPMegaCounterWindowFrameTextLower:SetText(XPCounterWindowFrame_GetXPTotal());
end

function RegenCounterWindow_HandleHealthUpdate()
	if ( this.health ) then
		if ( this.health == UnitHealth("player") ) then
			return;
		end
		this.oldHealth = this.health;
	end
	this.health = UnitHealth("player");
	RegenCounterWindowFrame_Update();
end

function RegenCounterWindow_HandleManaUpdate()
	if ( this.mana ) then
		this.oldMana = this.mana;
	end
	this.mana = UnitMana("player");
	RegenCounterWindowFrame_Update();
end


function RegenCounterWindow_OnEvent(event)
	if ( event == "UNIT_HEALTH" ) then
		if( arg1 == "player" ) then
			RegenCounterWindow_HandleHealthUpdate();
		end
		return;
	end
	if ( event == "UNIT_MANA" ) then
		if( arg1 == "player" ) then
			RegenCounterWindow_HandleManaUpdate();
		end
		return;
	end
	if ( event == "UNIT_RAGE" ) then
		if( arg1 == "player" ) then
			RegenCounterWindow_HandleManaUpdate();
		end
		return;
	end
	if ( event == "UNIT_FOCUS" ) then
		if( arg1 == "player" ) then
			RegenCounterWindow_HandleManaUpdate();
		end
		return;
	end
	if ( event == "UNIT_ENERGY" ) then
		if( arg1 == "player" ) then
			RegenCounterWindow_HandleManaUpdate();
		end
		return;
	end
	if ( event == "UNIT_HAPPINESS" ) then
		if( arg1 == "player" ) then
			RegenCounterWindow_HandleManaUpdate();
		end
		return;
	end
end

function RegenCounterWindowFrame_GetHealthRegen()
	local value = COUNTERWINDOW_REGEN_HEALTH_NOTAVAILABLE;
	if ( ( not this.oldHealth ) or ( not this.health ) or ( this.health == UnitHealthMax("player") ) ) then
		value = COUNTERWINDOW_REGEN_HEALTH_NOTAVAILABLE;
	else
		local diff = this.health - this.oldHealth;
		if ( diff > 0 ) then
			value = diff.."";
		end
	end
	return format(COUNTERWINDOW_REGEN_HEALTH_FORMAT, value);
end

function RegenCounterWindowFrame_GetManaRegen()
	local value = COUNTERWINDOW_REGEN_MANA_NOTAVAILABLE;
	if ( ( not this.oldMana ) or ( not this.mana ) or ( this.mana == UnitManaMax("player") ) ) then
		value = COUNTERWINDOW_REGEN_MANA_NOTAVAILABLE;
	else
		local diff = this.mana - this.oldMana;
		if ( diff > 0 ) then
			value = diff.."";
		end
	end
	return format(COUNTERWINDOW_REGEN_MANA_FORMAT, value);
end

function RegenCounterWindowFrame_Update()
	local name = "RegenCounterWindowFrame";
	local obj = getglobal(name.."TextUpper");
	if ( obj ) then
		obj:SetText(RegenCounterWindowFrame_GetHealthRegen());
	end
	local obj = getglobal(name.."TextLower");
	if ( obj ) then
		obj:SetText(RegenCounterWindowFrame_GetManaRegen());
	end
end

COUNTERWINDOW_MEMORYUSAGE_LOW = 16384;
COUNTERWINDOW_MEMORYUSAGE_MAX = 32768;

function CounterWindow_GetByteValue(pValue)
	local value = tonumber(pValue);
	if ( value <= 0 ) then return 0; end
	if ( value >= 255 ) then return 255; end
	return value;
end

-- Yet another function from George Warner, modified a bit to fit my own nefarious purposes. 
-- It can now accept r, g and b specifications, too (leaving out a), as well as handle 255 255 255
-- Source : http://www.cosmosui.org/cgi-bin/bugzilla/show_bug.cgi?id=159
function CounterWindow_GetColorFormatString(a, r, g, b)
	local percent = false;
	if ( ( ( not b ) or ( b <= 1 ) ) and ( a <= 1 ) and ( r <= 1 ) and ( g <= 1) ) then percent = true; end
	if ( ( not b ) and ( a ) and ( r ) and ( g ) ) then b = g; g = r; r = a; if ( percent ) then a = 1; else a = 255; end end
	if ( percent ) then a = a * 255; r = r * 255; g = g * 255; b = b * 255; end
	a = CounterWindow_GetByteValue(a); r = CounterWindow_GetByteValue(r); g = CounterWindow_GetByteValue(g); b = CounterWindow_GetByteValue(b);
	
	return format("|c%02X%02X%02X%02X%%s|r", a, r, g, b);
end

function UIMemoryCounterWindowFrame_Update()
	local memoryUsed, memoryUsedFormatStr;
	memoryUsed = gcinfo();
	if ( ( not this.oldMemoryUsed ) or ( this.oldMemoryUsed ~= memoryUsed ) ) then
		this.oldMemoryUsed = memoryUsed;
	else
		return;
	end
	if ( memoryUsed <= COUNTERWINDOW_MEMORYUSAGE_LOW ) then
		memoryUsedFormatStr = CounterWindow_GetColorFormatString(0.0, 1.0, 0);
	else
		local value = memoryUsed / COUNTERWINDOW_MEMORYUSAGE_MAX;
		memoryUsedFormatStr = CounterWindow_GetColorFormatString(value, (1.0-value), 0);
	end
	CounterWindow_UpdateWindow_SetText(format(memoryUsedFormatStr, memoryUsed), UIMemoryCounterWindowFrame);
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function CounterWindow_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
	if ( ( newvalue ~= oldvalue ) and ( TellTrack_Cosmos_Registered == 0 ) ) then
		if ( newvalue == 1 ) then
			CounterWindow_Print(TEXT(getglobal(enableMessage)));
		else
			CounterWindow_Print(TEXT(getglobal(disableMessage)));
		end
	end
	CounterWindow_Register_Cosmos();
	if ( CounterWindow_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		if ( CosmosVarName ) then
			Cosmos_UpdateValue(strsub(CVarName, 1, strlen(CVarName)-2), CSM_CHECKONOFF, newvalue);
		end
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the CounterWindow
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function CounterWindow_Toggle_Enabled(toggle)
	local newvalue = CounterWindow_Generic_Toggle(toggle, "CounterWindow_Enabled", "COS_COUNTERWINDOW_ENABLED_X", "COUNTERWINDOW_CHAT_ENABLED", "COUNTERWINDOW_CHAT_DISABLED");
	CounterWindow_Setup_Hooks(newvalue);
end

-- Prints out text to a chat box.
function CounterWindow_Print(msg,r,g,b,frame,id,unknown4th)
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
