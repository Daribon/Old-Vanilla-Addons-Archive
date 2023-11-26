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
RogueHelper_StatusBars = 1;
RogueHelper_Docked = 0;
RogueHelper_DockedFrame = "";
RogueHelper_UseMobHealth = 1;

RogueHelper_Cosmos_Registered = 0;
RogueHelper_Slash_Registered = 0;

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
		Cosmos_RegisterConfiguration(
			"COS_ROGUEHELPER_STATUSBAR",
			"CHECKBOX",
			TEXT(ROGUEHELPER_STATUSBAR),
			TEXT(ROGUEHELPER_STATUSBAR_INFO),
			RogueHelper_StatusBar_Toggle,
			RogueHelper_StatusBars
		);
		if ( Cosmos_RegisterChatCommand ) then
			local RogueHelperEnableCommands = ROGUEHELPER_SLASH_CMDS;
			Cosmos_RegisterChatCommand (
				"ROGUEHELPER_ENABLE_COMMANDS", -- Some Unique Group ID
				RogueHelperEnableCommands, -- The Commands
				RogueHelper_Main_ChatCommandHandler,
				ROGUEHELPER_CHAT_COMMAND_INFO -- Description String
			);
			RogueHelper_Slash_Registered = 1;
		end
	
		RogueHelper_Cosmos_Registered = 1;
		return true;
	end
	return false;
end

function RogueHelper_Toggle_Enabled_Khaos(state)
	local value = 0;
	if ( state ) and ( state.checked ) then
		value = 1;
	end
	RogueHelper_Toggle_Enabled_NoChat(value);
end

function RogueHelper_StatusBar_Toggle_Khaos(state)
	local value = 0;
	if ( state ) and ( state.checked ) then
		value = 1;
	end
	RogueHelper_StatusBar_Toggle(value);
end

-- registers the mod with Khaos
function RogueHelper_Register_Khaos()
	if ( not Khaos ) then
		return false;
	end
	local optionSetEasy = {
		id = ROGUEHELPER_KHAOS_SET_ID;
		text = ROGUEHELPER_CONFIG_HEADER;
		helptext = ROGUEHELPER_CONFIG_HEADER_INFO;
		difficulty = 1;
		default = false;
		options = {
			[1] = {
				id = "RogueHelperCheckBoxEnabled";
				key = "enabled";
				text = ROGUEHELPER_ENABLED;
				helptext = ROGUEHELPER_ENABLED_INFO;
				check = true;
				callback = RogueHelper_Toggle_Enabled_Khaos;
				feedback = function(state) if ( state ) and ( state.enabled ) then return ROGUEHELPER_CHAT_ENABLED; else return ROGUEHELPER_CHAT_DISABLED; end; end;
				type = K_TEXT;
				default = {
					checked = true;
				};
				disabled = {
					checked = false;
				};
			};
			[2] = {
				id = "RogueHelperCheckBoxStatusBars";
				key = "statusbars";
				text = ROGUEHELPER_STATUSBAR;
				helptext = ROGUEHELPER_STATUSBAR_INFO;
				check = true;
				callback = RogueHelper_StatusBar_Toggle_Khaos;
				feedback = function(state) if ( state ) and ( state.enabled ) then return ROGUEHELPER_CHAT_STATUSBAR_ENABLED; else return ROGUEHELPER_CHAT_STATUSBAR_DISABLED; end; end;
				type = K_TEXT;
				default = {
					checked = true;
				};
				disabled = {
					checked = false;
				};
			};
		};
	};
	if ( Sky ) then
		RogueHelper_Slash_Registered = 1;
		local slashCommand = {
			id = "RogueHelperCommand";
			commands = ROGUEHELPER_SLASH_CMDS;
			parseTree = { 
				default = {
					callback = RogueHelper_Main_ChatCommandHandler;
				};
			};
			helpText = ROGUEHELPER_CHAT_COMMAND_INFO;
		};
		optionSetEasy.commands = {
			slashCommand;
		};
	end
	Khaos.registerOptionSet( "combat", optionSetEasy );
	return true;
end

RogueHelper_StatusBar_Toggle_Mutex = false;

function RogueHelper_StatusBar_Toggle(toggle)
	if ( RogueHelper_StatusBar_Toggle_Mutex ) then return; end
	RogueHelper_StatusBar_Toggle_Mutex = true;
	if ( Khaos ) then
		local khaosKey = Khaos.getSetKey(ROGUEHELPER_KHAOS_SET_ID, "statusbars");
		if ( khaosKey ) then
			local bool = false;
			if ( toggle == 1 ) then
				bool = true;
			end
			Khaos.setSetKeyParameter(ROGUEHELPER_KHAOS_SET_ID, "statusbars", "checked", bool);
		end
	end

	if (toggle == 1) then 
		RogueHelper_StatusBars = 1;
		RogueHelper_ToggleStatusBars(true);
	else
		RogueHelper_StatusBars = 0;
		RogueHelper_ToggleStatusBars(false);
	end
	RogueHelper_StatusBar_Toggle_Mutex = false;
end

function RogueHelper_ToggleStatusBars(show)
	if (show) then
		RogueHelperFrameStatusBarHealth:Show();
		RogueHelperFrameStatusBarTargetHealth:Show();
	else
		RogueHelperFrameStatusBarHealth:Hide();
		RogueHelperFrameStatusBarTargetHealth:Hide();
	end
	RogueHelper_UpdateWindow_UpdateValues();
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function RogueHelper_Register_Eclipse()
	if ( Eclipse ) then
		--Set the ui section to be the Rogue Helper Khaos section
		local uisec = ROGUEHELPER_KHAOS_SET_ID;
		--If we don't have Khaos, then use the Cosmos section
		if (not Khaos) then
			uisec = "COS_ROGUEHELPER";
		end
		--Register with VisibilityOptions
		Eclipse.registerForVisibility( {
			name = "RogueHelperFrame";	--The name of the config, in this case also the name of the frame
			nototal = true;	--This addon has an option to hide the frame already, so we don't need to register with total
			uisec = uisec;	--This puts the options, in the Rogue Helper section, it is not neccisary but helps to keep VisOpts section cleaner
			uiname = BINDING_HEADER_ROGUEHELPERHEADER;	--This is the base name of this reg to display in the description and ui
			slashcom = ROGUEHELPER_NUI_ALIAS;	--These are the slash commands
		}	);
		return true;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function RogueHelper_Register()
	if ( not RogueHelper_Register_Khaos() ) then
		RogueHelper_Register_Cosmos();
	end
	if ( RogueHelper_Slash_Registered == 0 ) then
		local sName = "ROGUEHELPERSLASHENABLE";
		SlashCmdList[sName] = RogueHelper_Main_ChatCommandHandler;
		for k, v in ROGUEHELPER_SLASH_CMDS do
			setglobal("SLASH_"..sName..k, v);
		end
	end
	if ( not RogueHelper_Register_Eclipse() ) then
		if ( TransNUI_RegisterUI ) then
			TransNUI_RegisterUI("RogueHelperFrame",ROGUEHELPER_NUI_ALIAS, ROGUEHELPER_CONFIG_TRANSNUI, ROGUEHELPER_CONFIG_TRANSNUI_INFO, 0);
		end
		if ( PopNUI_RegisterUI ) then
			PopNUI_RegisterUI("RogueHelperFrame", ROGUEHELPER_NUI_ALIAS, RogueHelper_PopNUICallback, ROGUEHELPER_CONFIG_POPNUI, ROGUEHELPER_CONFIG_POPNUI_INFO);
		end
	end

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
	
	local func = nil;
	
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
	
	for k, v in ROGUEHELPER_CMD_SHOW do
		if ( strfind(commandName, v) ) then
			func = RogueHelper_Toggle_Enabled;
			break;
		end
	end
	if ( not func ) then
		for k, v in ROGUEHELPER_CMD_STATUSBAR do
			if ( strfind(commandName, v) ) then
				func = RogueHelper_StatusBar_Toggle;
				break;
			end
		end
	end
	if ( not func ) then
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
--	else
--		RogueHealer_UpdateWindow_UpdateValues();
	end
end


function RogueHelper_UpdateWindow_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("RightButtonUp");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("VARIABLES_LOADED");
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

function RogueHelper_GetHealthTextColorFormatString(value, min, max)
	if (RogueHelper_StatusBars == 1) then
		return RogueHelper_GetColorFormatString(1.0, 1.0, 1.0);
	else
		return RogueHelper_GetColorFormatString(RogueHelper_GetHealthColor(value, min, max));
	end
end

function RogueHelper_GetHealthColor(value, min, max)
	if ( not value ) then
		return 1.0, 0.0, 0.0;
	end

	local r, g, b;
	if ( (value < min) or (value > max) ) then
		return 1.0, 0.0, 0.0;
	end
	if ( (max - min) > 0 ) then
		value = (value - min) / (max - min);
	else
		value = 0;
	end

	if(value > 0.5) then
		r = (1.0 - value) * 2;
		g = 1.0;
	else
		r = 1.0;
		g = value * 2;
	end
	b = 0.0;
	return r, g, b;
end

function RogueHelper_GetHealthText()
	local text = "";
      local health = UnitHealth("player");
	local healthMin = 0.0;
      local healthMax = UnitHealthMax("player");
	local valueText = health.."/"..healthMax;
	text = format(RogueHelper_GetHealthTextColorFormatString(health, healthMin, healthMax), valueText);
	return text;
end

function RogueHelper_UpdateStatusBarHealth()
	name = "RogueHelperFrameStatusBarHealth";
	obj = getglobal(name);
	if (obj) then
		local health = UnitHealth("player");
		local healthMin = 0.0;
		local healthMax = UnitHealthMax("player");
		obj:SetMinMaxValues(healthMin, healthMax);
		obj:SetValue(health);
		obj:SetStatusBarColor(RogueHelper_GetHealthColor(health, healthMin, healthMax));
		local string = obj.TextString;
		if (string) then
			string:SetText(RogueHelper_GetHealthText());
		end
	end
end

function RogueHelper_GetTargetHealthText()
	if ( MobHealthText ) and ( RogueHelper_UseMobHealth == 1 ) then
		return MobHealthText:GetText();
	end
	local text = "";
    local health = UnitHealth("target");
	local healthMin = 0.0;
    local healthMax = UnitHealthMax("target");
	local valueText = health.."/"..healthMax;
	text = format(RogueHelper_GetHealthTextColorFormatString(health, healthMin, healthMax), valueText);
	return text;
end

function RogueHelper_GetMobHealthIndex(unit)
	local level = UnitLevel(unit);
	local name = UnitName(unit);
	if ( not name ) then name = "nil"; end
	if ( not level ) then level = "nil"; end
	return string.format("%s:%d", name, level);
end

function RogueHelper_GetMobHealthPPP(unit)
	local index = RogueHelper_GetMobHealthIndex(unit);
	if( index and MobHealthDB[index] ) then
		local s, e;
		local pts;
		local pct;
		
		s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
		if( pts and pct ) then
			pts = pts + 0;
			pct = pct + 0;
			if( pct ~= 0 ) then
				return pts / pct;
			end
		end
	end
	return 0;
end

function RogueHelper_UpdateStatusBarTargetHealth()
	name = "RogueHelperFrameStatusBarTargetHealth";
	obj = getglobal(name);
	if (obj) then
		local health = UnitHealth("target");
      	local healthMin = 0.0;
		local healthMax = UnitHealthMax("target");
		if ( MobHealthText ) and ( RogueHelper_UseMobHealth == 1 ) then
			local ppp = RogueHelper_GetMobHealthPPP("target");
			if ( ppp > 0 ) then
				healthMax = ppp;
				health = ppp * health;
			end
		end
		obj:SetMinMaxValues(healthMin, healthMax);
	    obj:SetValue(health);
      	obj:SetStatusBarColor(RogueHelper_GetHealthColor(health, healthMin, healthMax));
		local string = obj.TextString;
		if (string) then
			string:SetText(RogueHelper_GetTargetHealthText());
        end
      end
end

function RogueHelper_GetEnergyTextColorFormatString(value)
	if ( not value ) then
		return RogueHelper_GetColorFormatString(1.0, 0.0, 0.0);
	end

      -- Sinister Strike 40 energy
	if ( value >= 40 ) then
		return RogueHelper_GetColorFormatString(0.0, 1.0, 0.0);
      -- Evicerate 35 energy
	elseif ( value >= 35 ) then
		return RogueHelper_GetColorFormatString(1.0, 1.0, 0.0);
	else
		return RogueHelper_GetColorFormatString(1.0, 0.0, 0.0);
	end
end

function RogueHelper_GetEnergyText()
	local text = "";
	local mana = 0;
	mana = UnitMana("player");
	local manaMax = UnitManaMax("player");
	local valueText = mana.."/"..manaMax;
	text = format(RogueHelper_GetEnergyTextColorFormatString(mana), valueText);
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
	local baseTextName = "RogueHelperFrameText";

      -- Player Health Info
	name = baseTextName.."Health";
	obj = getglobal(name);
	if (obj) then
		obj:SetText(RogueHelper_GetHealthText());
	end
	RogueHelper_UpdateStatusBarHealth();

      -- Player Energy Info
	name = baseTextName.."Energy";
	local obj = getglobal(name);
	if ( obj ) then
		obj:SetText(RogueHelper_GetEnergyText());
	end

      -- Player Combo Point Info
	name = baseTextName.."Combo";
	obj = getglobal(name);
	if ( obj ) then
		obj:SetText(RogueHelper_GetComboPointsText());
	end

	-- Target Health Info
	name = baseTextName.."TargetHealth";
	obj = getglobal(name);
	if (obj) then
		obj:SetText(RogueHelper_GetTargetHealthText());
	end
	RogueHelper_UpdateStatusBarTargetHealth();
end

function RogueHelper_UpdateWindow_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		RogueHelper_UpdateWindow_UpdateValues();
		RogueHelperFrameStatusBarHealth:SetFrameLevel(2);
		RogueHelperFrameStatusBarTargetHealth:SetFrameLevel(2);
	end

	if (( event == "UNIT_HEALTH") or ( event == "UNIT_MAXHEALTH") ) then
		if (( arg1 == "target" ) or ( arg1 == "player" )) then
			RogueHelper_UpdateWindow_UpdateValues();
		end
	end
	if (( event == "UNIT_ENERGY") or ( event == "UNIT_MAXENERGY") ) then
		if ( arg1 == "player" ) then
			RogueHelper_UpdateWindow_UpdateValues();
		end
	end
	if (( event == "PLAYER_COMBO_POINTS" ) or ( event == "PLAYER_TARGET_CHANGED" )) then
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

RogueHelper_DoToggle_Enabled_Mutex = false;

function RogueHelper_DoToggle_Enabled(toggle, noChat)
	if ( RogueHelper_DoToggle_Enabled_Mutex ) then
		return;
	end;
	RogueHelper_DoToggle_Enabled_Mutex = true;
	local newvalue = 0;
	if ( not noChat ) then
		newvalue = RogueHelper_Generic_Toggle(toggle, "RogueHelper_Enabled", "COS_ROGUEHELPER_ENABLED_X", "ROGUEHELPER_CHAT_ENABLED", "ROGUEHELPER_CHAT_DISABLED");
	else
		newvalue = RogueHelper_Generic_Toggle(toggle, "RogueHelper_Enabled", "COS_ROGUEHELPER_ENABLED_X");
	end

	if ( Khaos ) then
		local khaosKey = Khaos.getSetKey(ROGUEHELPER_KHAOS_SET_ID, "enabled");
		if ( khaosKey ) then
			local bool = false;
			if ( newvalue == 1 ) then
				bool = true;
			end
			Khaos.setSetKeyParameter(ROGUEHELPER_KHAOS_SET_ID, "enabled", "checked", bool);
		end
	end

	if ( newvalue == 1 ) then
		RogueHelperFrame:Show();
	else
		RogueHelperFrame:Hide();
	end
	RogueHelper_DoToggle_Enabled_Mutex = false;
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
