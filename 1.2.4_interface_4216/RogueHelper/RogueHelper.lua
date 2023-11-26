--[[
	Rogue Helper

	By sarf

	This mod gives the user a little window to move around that contains energy and combo units.

	Thanks goes to 
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
ROGUEHELPER_MAX_COMBO_POINTS = MAX_COMBO_POINTS;

-- Variables
RogueHelper_Enabled = 0;
RogueHelper_Docked = 0;
RogueHelper_DockedFrame = "";

RogueHelper_Saved_Hooked_Function = nil;
RogueHelper_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function RogueHelper_OnLoad()
	RogueHelper_Register();
end

-- registers the mod with Cosmos
function RogueHelper_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( RogueHelper_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_ROGUEHELPER",
			"SECTION",
			TEXT(ROGUEHELPER_CONFIG_HEADER),
			TEXT(ROGUEHELPER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ROGUEHELPER_HEADER",
			"SEPARATOR",
			TEXT(ROGUEHELPER_CONFIG_HEADER),
			TEXT(ROGUEHELPER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_ROGUEHELPER_ENABLED",
			"CHECKBOX",
			TEXT(ROGUEHELPER_ENABLED),
			TEXT(ROGUEHELPER_ENABLED_INFO),
			RogueHelper_Toggle_Enabled_NoChat,
			RogueHelper_Enabled
		);
		if ( Cosmos_RegisterChatCommand ) then
			local RogueHelperEnableCommands = {"/roguehelper","/rh"};
			Cosmos_RegisterChatCommand (
				"ROGUEHELPER_ENABLE_COMMANDS", -- Some Unique Group ID
				RogueHelperEnableCommands, -- The Commands
				RogueHelper_Main_ChatCommandHandler,
				ROGUEHELPER_CHAT_COMMAND_INFO -- Description String
			);
		end
	
		RogueHelper_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function RogueHelper_Register()
	if ( Cosmos_RegisterConfiguration ) then
		RogueHelper_Register_Cosmos();
	else
		SlashCmdList["ROGUEHELPERSLASHENABLE"] = RogueHelper_Main_ChatCommandHandler;
		SLASH_ROGUEHELPERSLASHENABLE1 = "/roguehelper";
		SLASH_ROGUEHELPERSLASHENABLE2 = "/rh";
	end

	if ( TransNUI_RegisterUI ) then
		TransNUI_RegisterUI("RogueHelperFrame", { "roguehelper", "rh" }, ROGUEHELPER_CONFIG_TRANSNUI, ROGUEHELPER_CONFIG_TRANSNUI_INFO, 0);
	end
	if ( PopNUI_RegisterUI ) then
		PopNUI_RegisterUI("RogueHelperFrame", { "roguehelper", "rh" }, RogueHelper_PopNUICallback, ROGUEHELPER_CONFIG_POPNUI, ROGUEHELPER_CONFIG_POPNUI_INFO);
	end

	RegisterForSave("RogueHelper_Docked");
	RegisterForSave("RogueHelper_DockedFrame");

	this:RegisterEvent("VARIABLES_LOADED");

end

function RogueHelper_PopNUICallback(whichUI, isEnabled, xPos, yPos)
	if ( ( not RogueHelper_Enabled ) or ( RogueHelper_Enabled ~= 1 ) ) then
		if ( RogueHelperFrame:IsVisible() ) then
			RogueHelperFrame:Hide();
		end
	else
		PopNUI_CheckUI(whichUI, isEnabled, xPos, yPos);
	end
end




function RogueHelper_Extract_NextParameter(msg)
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


-- Handles chat - e.g. slashcommands - enabling/disabling the RogueHelper
function RogueHelper_Main_ChatCommandHandler(msg)
	
	local func = RogueHelper_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		RogueHelper_Print(ROGUEHELPER_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = RogueHelper_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "show" ) ) then
		func = RogueHelper_Toggle_Enabled;
	else 
		RogueHelper_Print(ROGUEHELPER_CHAT_COMMAND_USAGE);
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
function RogueHelper_Hooked_Function()
	if ( RogueHelper_Enabled == 1 ) then
	end
	RogueHelper_Saved_Hooked_Function();
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function RogueHelper_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( Hooked_Function ~= RogueHelper_Hooked_Function ) and (RogueHelper_Saved_Hooked_Function == nil) ) then
			RogueHelper_Saved_Hooked_Function = Hooked_Function;
			Hooked_Function = RogueHelper_Hooked_Function;
		end
	else
		if ( Hooked_Function == RogueHelper_Hooked_Function) then
			Hooked_Function = RogueHelper_Saved_Hooked_Function;
			RogueHelper_Saved_Hooked_Function = nil;
		end
	end
end

-- Handles events
function RogueHelper_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( RogueHelper_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_ROGUEHELPER_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			RogueHelper_Toggle_Enabled(value);
		end
		if ( RogueHelper_Docked == 1 ) then
			RogueHelper_DockToName(RogueHelper_DockedFrame);
		end
	end
end


function RogueHelper_UpdateWindow_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("RightButtonUp");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
end

function RogueHelper_FixColorValue(value)
	if ( value > 1 ) then
		value = 1;
	elseif ( value < 0 ) then
		value = 0;
	end
	return value;
end

function RogueHelper_IsDockedFrameDraggable()
	if ( RogueHelper_DockedFrame == "WeaponButtonsFrame" ) then
		return true;
	else
		return false;
	end
end

function RogueHelper_DockToName(name)
	local obj = getglobal(name);
	local x, y;
	if ( name == "UIParent" ) then
		if ( ( obj ) and ( obj:IsVisible() ) ) then
			x, y = obj:GetCenter();
			RogueHelperFrame:ClearAllPoints();
			RogueHelperFrame:SetPoint("TOPLEFT", name, "TOPLEFT", x-(RogueHelperFrame:GetWidth()/2), (y-(RogueHelperFrame:GetHeight()/2))*-1);
			RogueHelperFrame:SetFrameLevel(obj:GetFrameLevel()+1);
			RogueHelper_Docked = 0;
			RogueHelper_DockedFrame = name;
		end
	elseif ( name == "PlayerFrame" ) then
		if ( ( obj ) and ( obj:IsVisible() ) ) then
			RogueHelperFrame:ClearAllPoints();
			RogueHelperFrame:SetPoint("TOPLEFT", name, "TOPLEFT", 80, -80);
			RogueHelperFrame:SetFrameLevel(obj:GetFrameLevel()-2);
			RogueHelper_LockWindow();
			RogueHelper_Docked = 1;
			RogueHelper_DockedFrame = name;
		end
	elseif ( name == "WeaponButtonsFrame" ) then
		if ( ( obj ) and ( obj:IsVisible() ) ) then
			RogueHelperFrame:ClearAllPoints();
			RogueHelperFrame:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, 16);
			RogueHelperFrame:SetFrameLevel(obj:GetFrameLevel()-2);
			RogueHelper_LockWindow();
			RogueHelper_Docked = 1;
			RogueHelper_DockedFrame = name;
		end
	end
end


function RogueHelper_UpdateWindow_GetDragFrame()
	if( RogueHelper_Docked == 1 ) then
		if ( RogueHelper_IsDockedFrameDraggable() ) then
			return getglobal(RogueHelper_DockedFrame);
		else
			return nil;
		end
	else
		if ( ( not this.isLocked ) or ( this.isLocked == 0 ) ) then
			return this;
		else
			return nil;
		end
	end
end

function RogueHelper_UpdateWindow_OnDragStop()
	local dragFrame = RogueHelper_UpdateWindow_GetDragFrame();
	if ( dragFrame ) then
		dragFrame:StopMovingOrSizing();
		dragFrame.isMoving = false;
	end
	if ( ( this ) and ( this ~= dragFrame )) then
		this:StopMovingOrSizing();
		this.isMoving = false;
	end
end

function RogueHelper_UpdateWindow_OnDragStart()
	local dragFrame = RogueHelper_UpdateWindow_GetDragFrame();
	if ( dragFrame ) then
		dragFrame:StartMoving();
		dragFrame.isMoving = true;
		if ( dragFrame ~= this ) then
			this:StartMoving();
			this.isMoving = true;
		end
	end
end

function RogueHelper_HideMenus()
	for i = 1, 5 do
		local obj = getglobal("DropDownList"..i);
		if ( obj ) then
			obj:Hide();
		end
	end
end

function RogueHelper_CreateDockMenu()
	local menu = { };
	local index = 1;
	menu[index] = { text = TEXT(ROGUEHELPER_MENU_TITLE), isTitle = 1 };
	index = index + 1;
	if ( ( WeaponButtonsFrame ) and ( WeaponButtonsFrame:IsVisible() ) ) then
		local qwe = RogueHelper_GetDockMenuArray(TEXT(ROGUEHELPER_MENU_DOCK_OPTION_WEAPONBUTTONS), "WeaponButtonsFrame", RogueHelper_DockToWeaponButtonsFrame );
		if ( qwe ) then
			menu[index] = qwe;
			index = index + 1;
		end
	end
	local qwe = RogueHelper_GetDockMenuArray(TEXT(ROGUEHELPER_MENU_DOCK_OPTION_PLAYERFRAME), "PlayerFrame", RogueHelper_DockToPlayerFrame );
	if ( qwe ) then
		menu[index] = qwe;
		index = index + 1;
	end
	local qwe = RogueHelper_GetDockMenuArray(TEXT(ROGUEHELPER_MENU_DOCK_OPTION_UNDOCK), "UIParent", RogueHelper_DockToUIParent );
	if ( qwe ) then
		menu[index] = qwe;
		index = index + 1;
	end
	menu[index] = { text = TEXT(ROGUEHELPER_MENU_OPTION_SEPERATOR), disabled = 1, notClickable = 1 };
	index = index + 1;
	menu[index] = { text = TEXT(ROGUEHELPER_MENU_OPTION_CANCEL), func = function () end };
	index = index + 1;

	return menu;	
end

function RogueHelper_CreateDockMenuElement(element)
	local dockMenu = RogueHelper_CreateDockMenu();
	for k, v in dockMenu do
		element[k] = v;
	end
	return element;
end

function RogueHelper_MenuClick()
	CosmosDropDown:Hide();
	CosmosDropDownBis:Hide();
end


function RogueHelper_CreateMenu()
	local menu = { };
	menu[1] = { text = TEXT(ROGUEHELPER_MENU_TITLE), isTitle = 1 };
	if ( RogueHelper_GetLockWindowState() ) then
		menu[2] = { text = TEXT(ROGUEHELPER_MENU_OPTION_UNLOCK), func = RogueHelper_ToggleLockWindow };
	else
		menu[2] = { text = TEXT(ROGUEHELPER_MENU_OPTION_LOCK), func = RogueHelper_ToggleLockWindow };
	end
	menu[3] = { text = TEXT(ROGUEHELPER_MENU_OPTION_HIDE), func = RogueHelper_Toggle_Enabled };
	menu[4] = RogueHelper_CreateDockMenuElement({ text = TEXT(ROGUEHELPER_MENU_OPTION_DOCK), hasArrow = 1, func = function () end });
	menu[5] = { text = TEXT(ROGUEHELPER_MENU_OPTION_SEPERATOR), disabled = 1, notClickable = 1 };
	menu[6] = { text = TEXT(ROGUEHELPER_MENU_OPTION_CANCEL), func = function () end };
	return menu;
end

function RogueHelper_ShowMenu()
	local menu = RogueHelper_CreateMenu();
	
	if ( CosmosMaster_MenuOpen ) then
		CosmosMaster_MenuOpen(menu, 0, this:GetName(), 0, 0);
	end
end

function RogueHelper_DockToWeaponButtonsFrame()
	RogueHelper_DockToName("WeaponButtonsFrame");
end

function RogueHelper_DockToPlayerFrame()
	RogueHelper_DockToName("PlayerFrame");
end

function RogueHelper_DockToUIParent()
	RogueHelper_DockToName("UIParent");
end

function RogueHelper_DockToWeaponButtonsFrame_HideMenus()
	RogueHelper_DockToWeaponButtonsFrame();
	RogueHelper_HideMenus();
end

function RogueHelper_DockToPlayerFrame_HideMenus()
	RogueHelper_DockToPlayerFrame();
	RogueHelper_HideMenus();
end

function RogueHelper_DockToUIParent_HideMenus()
	RogueHelper_DockToUIParent();
	RogueHelper_HideMenus();
end

function RogueHelper_GetDockMenuArray(name, frameName, pFunc)
	if ( ( RogueHelper_Docked ~= 1 ) or ( RogueHelper_DockedFrame ~= frameName) ) then
		return { text = name, func = pFunc, hideAllParentsOnClick = 1 };
	else
		return nil;
	end
end

function RogueHelper_UpdateWindow_OnClick(button)
	if ( button == "RightButton" ) then
		RogueHelper_ShowMenu();
	end
end

function RogueHelper_GetEnergyTextColorFormatString(value)
	if ( value <= 0.5 ) then
		return RogueHelper_GetColorFormatString(RogueHelper_FixColorValue(1.0-value/1.5), 0.0, 0.0);
	else
		return RogueHelper_GetColorFormatString(RogueHelper_FixColorValue(0.4-value/2), RogueHelper_FixColorValue(value*1.25), 0.0);
	end
end

function RogueHelper_GetEnergyText()
	local text = "";
	local value = 0;
	local mana = UnitMana("player");
	local manaMax = UnitManaMax("player");
	if ( mana > 0  ) then
		value = mana / manaMax;
	end
	local valueText = mana.."/"..manaMax;
	text = format(RogueHelper_GetEnergyTextColorFormatString(value), valueText);
	return text;
end

function RogueHelper_GetComboPointsMax()
	return ROGUEHELPER_MAX_COMBO_POINTS;
end

function RogueHelper_GetComboPointsText()
	local text = "";
	text = GetComboPoints().."/"..RogueHelper_GetComboPointsMax();
	return text;
end

function RogueHelper_UpdateWindow_UpdateValues()
	local baseName = "RogueHelperFrameText";
	local name = baseName.."Upper";
	local obj = getglobal(name);
	if ( obj ) then
		obj:SetText(RogueHelper_GetEnergyText());
	end
	name = baseName.."Lower";
	obj = getglobal(name);
	if ( obj ) then
		obj:SetText(RogueHelper_GetComboPointsText());
	end
end

function RogueHelper_UpdateWindow_OnEvent(event)
	if ( ( event == "UNIT_ENERGY") or ( event == "UNIT_MAXENERGY") ) then
		if ( arg1 == "player" ) then
			RogueHelper_UpdateWindow_UpdateValues();
		end
	end
	if ( event == "PLAYER_COMBO_POINTS") then
		RogueHelper_UpdateWindow_UpdateValues();
	end
end

function RogueHelper_UpdateWindow_ToggleLockWindow()
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

function RogueHelper_GetLockWindowState()
	local obj = getglobal("RogueHelperFrame");
	if ( obj ) then
		if ( not obj.isLocked ) then
			return false;
		elseif ( obj.isLocked == 1 ) then
			return true;
		else
			return false;
		end
	end
	return false;
end

function RogueHelper_LockWindow()
	local obj = getglobal("RogueHelperFrame");
	if ( obj ) then
		obj.isLocked = 1;
	end
end

function RogueHelper_UnlockWindow()
	local obj = getglobal("RogueHelperFrame");
	if ( obj ) then
		obj.isLocked = 0;
	end
end

function RogueHelper_ToggleLockWindow()
	local obj = getglobal("RogueHelperFrame");
	if ( obj ) then
		if ( not obj.isLocked ) then
			obj.isLocked = 1;
		else
			if ( obj.isLocked == 1 ) then
				obj.isLocked = 0;
			else
				obj.isLocked = 1;
			end
		end
	end
end

function RogueHelper_UpdateWindow_LockWindow(value)
	if ( this ) then
		if ( not value ) then
			this.isLocked = 0;
		elseif ( value == 1 ) then
			this.isLocked = 1;
		else
			this.isLocked = 0;
		end
	end
end

function RogueHelper_GetByteValue(pValue)
	local value = tonumber(pValue);
	if ( value <= 0 ) then return 0; end
	if ( value >= 255 ) then return 255; end
	return value;
end

-- Yet another function from George Warner, modified a bit to fit my own nefarious purposes. 
-- It can now accept r, g and b specifications, too (leaving out a), as well as handle 255 255 255
-- Source : http://www.cosmosui.org/cgi-bin/bugzilla/show_bug.cgi?id=159
function RogueHelper_GetColorFormatString(a, r, g, b)
	local percent = false;
	if ( ( ( not b ) or ( b <= 1 ) ) and ( a <= 1 ) and ( r <= 1 ) and ( g <= 1) ) then percent = true; end
	if ( ( not b ) and ( a ) and ( r ) and ( g ) ) then b = g; g = r; r = a; if ( percent ) then a = 1; else a = 255; end end
	if ( percent ) then a = a * 255; r = r * 255; g = g * 255; b = b * 255; end
	a = RogueHelper_GetByteValue(a); r = RogueHelper_GetByteValue(r); g = RogueHelper_GetByteValue(g); b = RogueHelper_GetByteValue(b);
	
	return format("|c%02X%02X%02X%02X%%s|r", a, r, g, b);
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function RogueHelper_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, CosmosVarName)
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
			RogueHelper_Print(text);
		end
	end
	RogueHelper_Register_Cosmos();
	if ( RogueHelper_Cosmos_Registered == 0 ) then 
		RegisterForSave(variableName);
	else
		if ( CosmosVarName ) then
			Cosmos_UpdateValue(strsub(CosmosVarName, 1, strlen(CVarName)-2), CSM_CHECKONOFF, newvalue);
		else
			Cosmos_UpdateValue(strsub(CVarName, 1, strlen(CVarName)-2), CSM_CHECKONOFF, newvalue);
		end
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the RogueHelper
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function RogueHelper_DoToggle_Enabled(toggle, noChat)
	local newvalue = 0;
	if ( not noChat ) then
		newvalue = RogueHelper_Generic_Toggle(toggle, "RogueHelper_Enabled", "COS_ROGUEHELPER_ENABLED_X", "ROGUEHELPER_CHAT_ENABLED", "ROGUEHELPER_CHAT_DISABLED");
	else
		newvalue = RogueHelper_Generic_Toggle(toggle, "RogueHelper_Enabled", "COS_ROGUEHELPER_ENABLED_X");
	end
	RogueHelper_Setup_Hooks(newvalue);
	if ( newvalue == 1 ) then
		RogueHelperFrame:Show();
	else
		RogueHelperFrame:Hide();
	end
end
function RogueHelper_Toggle_Enabled_NoChat(toggle)
	RogueHelper_DoToggle_Enabled(toggle, true);
end

function RogueHelper_Toggle_Enabled(toggle)
	RogueHelper_DoToggle_Enabled(toggle, false);
end


-- Prints out text to a chat box.
function RogueHelper_Print(msg,r,g,b,frame,id,unknown4th)
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
