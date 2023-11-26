--[[
	Weapon Buttons

	By sarf

	This mod gives you a draggable window with the mainhand / offhand buttons. 
	This way you don't have to open the paperdoll to equip weapons anymore.

	Thanks goes to 
	
	UltimateUIUI URL:
	http://www.ultimateuiui.org/forums/viewtopic.php?t=
	
   ]]


-- Constants
WEAPONBUTTONS_MODE_MELEE = 1;
WEAPONBUTTONS_MODE_RANGED = 2;
WEAPONBUTTONS_MODE_TRINKET = 3;
WEAPONBUTTONS_MODE_MIN = WEAPONBUTTONS_MODE_MELEE;
WEAPONBUTTONS_MODE_MAX = WEAPONBUTTONS_MODE_TRINKET;

-- Variables
WeaponButtons_Enabled = 0;
WeaponButtons_DefaultMode = WEAPONBUTTONS_MODE_MELEE;
WeaponButtons_Mode = WEAPONBUTTONS_MODE_MELEE;
WeaponButtons_DisplayTooltips = 1;
WeaponButtons_LockPosition = 0;

WeaponButtons_UltimateUI_Registered = 0;

WeaponButtons_ModesComponents = {
	[WEAPONBUTTONS_MODE_MELEE] = {
		"WeaponButtonCharacterMainHandSlot", 
		"WeaponButtonCharacterSecondaryHandSlot"
	},
	[WEAPONBUTTONS_MODE_RANGED] = {
		"WeaponButtonCharacterRangedSlot", 
		"WeaponButtonCharacterAmmoSlot"
	},
	[WEAPONBUTTONS_MODE_TRINKET] = {
		"WeaponButtonCharacterTrinket0Slot", 
		"WeaponButtonCharacterTrinket1Slot"
	}
};

function WeaponButtons_ToggleMode()
	WeaponButtons_DoToggleMode();
end

function WeaponButtons_ToggleMode_NoChat()
	WeaponButtons_DoToggleMode(true);
end

function WeaponButtons_DoToggleMode(noChat)
	local mode = WeaponButtons_Mode;
	if ( mode < WEAPONBUTTONS_MODE_MAX ) then
		mode = mode + 1;
	else
		mode = 1;
	end
	if ( not noChat ) then
		WeaponButtons_Print(format(WEAPONBUTTONS_CHAT_SETMODE, WEAPONBUTTONS_CHAT_MODES[mode]));
	end
	WeaponButtons_ChangeMode(mode);
end

function WeaponButtons_SetDefaultMode(toggle, mode)
	WeaponButtons_DefaultMode = mode;
	RegisterForSave("WeaponButtons_DefaultMode");
	WeaponButtons_ChangeMode(mode);
end

function WeaponButtons_ChangeMode(mode)
	if ( ( mode >= WEAPONBUTTONS_MODE_MIN) and ( mode <= WEAPONBUTTONS_MODE_MAX) )then
		local obj = nil;
		for k, v in WeaponButtons_ModesComponents do
			for key, value in v do
				obj = getglobal(value);
				if ( k == mode ) then
					obj:Show();
				else
					obj:Hide();
				end
			end
		end
		WeaponButtons_Mode = mode;
	end
end

-- executed on load, calls general set-up functions
function WeaponButtons_OnLoad()
	WeaponButtonsFrame:SetBackdropColor(0, 0, 0, transparency);
	WeaponButtonsFrame:SetBackdropBorderColor(1, 1, 1, 1); --[[ mark ]]--
	WeaponButtons_Register();
end

-- registers the mod with UltimateUI
function WeaponButtons_Register_UltimateUI()
	if ( ( UltimateUI_RegisterConfiguration ) and ( WeaponButtons_UltimateUI_Registered == 0 ) ) then
		UltimateUI_RegisterConfiguration(
			"UUI_WEAPONBUTTONS",
			"SECTION",
			TEXT(WEAPONBUTTONS_CONFIG_HEADER),
			TEXT(WEAPONBUTTONS_CONFIG_HEADER_INFO)
		);
		UltimateUI_RegisterConfiguration(
			"UUI_WEAPONBUTTONS_HEADER",
			"SEPARATOR",
			TEXT(WEAPONBUTTONS_CONFIG_HEADER),
			TEXT(WEAPONBUTTONS_CONFIG_HEADER_INFO)
		);
		UltimateUI_RegisterConfiguration(
			"UUI_WEAPONBUTTONS_ENABLED",
			"CHECKBOX",
			TEXT(WEAPONBUTTONS_ENABLED),
			TEXT(WEAPONBUTTONS_ENABLED_INFO),
			WeaponButtons_Toggle_Enabled_NoChat,
			WeaponButtons_Enabled
		);
		UltimateUI_RegisterConfiguration(
			"UUI_WEAPONBUTTONS_DISPLAY_TOOLTIPS",
			"CHECKBOX",
			TEXT(WEAPONBUTTONS_DISPLAY_TOOLTIPS),
			TEXT(WEAPONBUTTONS_DISPLAY_TOOLTIPS_INFO),
			WeaponButtons_Toggle_DisplayTooltips_NoChat,
			WeaponButtons_DisplayTooltips
		);
		UltimateUI_RegisterConfiguration(
			"UUI_WEAPONBUTTONS_LOCK_POSITION",
			"CHECKBOX",
			TEXT(WEAPONBUTTONS_LOCK_POSITION),
			TEXT(WEAPONBUTTONS_LOCK_POSITION_INFO),
			WeaponButtons_Toggle_LockPosition_NoChat,
			WeaponButtons_LockPosition
		);
		local defaultModeInfo = TEXT(WEAPONBUTTONS_DEFAULT_MODE_INFO);
		for k, v in WEAPONBUTTONS_CHAT_MODES do
			defaultModeInfo = defaultModeInfo..string.format(" %d = %s.", k, v);
		end
		UltimateUI_RegisterConfiguration(
			"UUI_WEAPONBUTTONS_DEFAULT_MODE",
			"SLIDER",
			TEXT(WEAPONBUTTONS_DEFAULT_MODE),
			defaultModeInfo,
			WeaponButtons_SetDefaultMode,
			1,
			WeaponButtons_DefaultMode,
			WEAPONBUTTONS_MODE_MIN,
			WEAPONBUTTONS_MODE_MAX,
			"",
			1,
			1,
			TEXT(WEAPONBUTTONS_DEFAULT_MODE_APPEND)
		);
		if ( UltimateUI_RegisterChatCommand ) then
			local WeaponButtonsMainCommands = {"/weaponbutton","/weaponbuttons","/wb"};
			UltimateUI_RegisterChatCommand (
				"WEAPONBUTTONS_MAIN_COMMANDS", -- Some Unique Group ID
				WeaponButtonsMainCommands, -- The Commands
				WeaponButtons_Main_ChatCommandHandler,
				WEAPONBUTTONS_CHAT_COMMAND_INFO -- Description String
			);
		end
		WeaponButtons_UltimateUI_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function WeaponButtons_Register()
	if ( UltimateUI_RegisterConfiguration ) then
		WeaponButtons_Register_UltimateUI();
	else
		SlashCmdList["WEAPONBUTTONSSLASHENABLE"] = WeaponButtons_Main_ChatCommandHandler;
		SLASH_WEAPONBUTTONSSLASHENABLE1 = "/weaponbuttons";
		SLASH_WEAPONBUTTONSSLASHENABLE2 = "/weaponbutton";
		SLASH_WEAPONBUTTONSSLASHENABLE3 = "/wb";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( TransNUI_RegisterUI ) then
		TransNUI_RegisterUI("WeaponButtonsFrame", { "weaponbuttons", "wb" }, WEAPONBUTTONS_CONFIG_TRANSNUI, WEAPONBUTTONS_CONFIG_TRANSNUI_INFO, 0);
	end
	if ( PopNUI_RegisterUI ) then
		PopNUI_RegisterUI("WeaponButtonsFrame", { "weaponbuttons", "wb" }, WeaponButtons_PopNUICallback, WEAPONBUTTONS_CONFIG_POPNUI, WEAPONBUTTONS_CONFIG_POPNUI_INFO);
	end

end

function WeaponButtons_PopNUICallback(whichUI, isEnabled, xPos, yPos)
	if ( ( not WeaponButtons_Enabled ) or ( WeaponButtons_Enabled ~= 1 ) ) then
		if ( WeaponButtonsFrame:IsVisible() ) then
			WeaponButtonsFrame:Hide();
		end
	else
		PopNUI_CheckUI(whichUI, isEnabled, xPos, yPos);
	end
end


function WeaponButtons_Extract_NextParameter(msg)
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



-- Handles chat - e.g. slashcommands - enabling/disabling the WeaponButtons
function WeaponButtons_Main_ChatCommandHandler(msg)
	
	local func = WeaponButtons_Toggle_Enabled;
	
	local toggleFunc = true;
	
	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		WeaponButtons_Print(WEAPONBUTTONS_CHAT_COMMAND_USAGE);
		return;
	end
	
	local commandName, params = WeaponButtons_Extract_NextParameter(msg);
	
	if ( ( commandName ) and ( strlen(commandName) > 0 ) ) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end
	
	if ( strfind( commandName, "tooltip" ) ) then
		func = WeaponButtons_Toggle_DisplayTooltips;
	elseif ( strfind( commandName, "lock" ) ) then
		func = WeaponButtons_Toggle_LockPosition;
	elseif ( strfind( commandName, "togglemode" ) ) then
		func = WeaponButtons_ToggleMode;
		toggleFunc = false;
	elseif ( strfind( commandName, "mode" ) ) then
		local modeStr;
		modeStr, params = WeaponButtons_Extract_NextParameter(params);
		local mode = tonumber(modeStr);
		if ( mode ) then
			modeStr = WEAPONBUTTONS_CHAT_MODES[mode];
			if ( modeStr ) then
				WeaponButtons_Print(string.format(WEAPONBUTTONS_CHAT_SETMODE, modeStr));
				if ( strfind( commandName, "default" ) ) then
					WeaponButtons_SetDefaultMode(1, mode);
				else
					WeaponButtons_ChangeMode(mode);
				end
			else
				WeaponButtons_Print(WEAPONBUTTONS_CHAT_MODE_ILLEGAL);
			end
		else
			WeaponButtons_Print(WEAPONBUTTONS_CHAT_COMMAND_USAGE);
		end
		return;
	elseif ( strfind( commandName, "show" ) ) then
		func = WeaponButtons_Toggle_Enabled;
	else
		WeaponButtons_Print(WEAPONBUTTONS_CHAT_COMMAND_USAGE);
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

-- Handles chat - e.g. slashcommands - enabling/disabling the WeaponButtons
function WeaponButtons_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		WeaponButtons_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			WeaponButtons_Toggle_Enabled(0);
		else
			WeaponButtons_Toggle_Enabled(-1);
		end
	end
end

-- Handles chat - e.g. slashcommands - enabling/disabling the tooltips of the WeaponButtons
function WeaponButtons_DisplayTooltips_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		WeaponButtons_Toggle_DisplayTooltips(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			WeaponButtons_Toggle_DisplayTooltips(0);
		else
			WeaponButtons_Toggle_DisplayTooltips(-1);
		end
	end
end

-- Handles chat - e.g. slashcommands - locking/unlocking the position of the WeaponButtons
function WeaponButtons_LockPosition_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		WeaponButtons_Toggle_LockPosition(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			WeaponButtons_Toggle_LockPosition(0);
		else
			WeaponButtons_Toggle_LockPosition(-1);
		end
	end
end

-- Handles events
function WeaponButtons_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( WeaponButtons_UltimateUI_Registered == 0 ) then
			local value = getglobal("WeaponButtons_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			WeaponButtons_Toggle_Enabled(value);
			value = getglobal("WeaponButtons_DisplayTooltips");
			if (value == nil ) then
				-- defaults to on
				value = 1;
			end
			WeaponButtons_Toggle_DisplayTooltips(value);
			value = getglobal("WeaponButtons_LockPosition");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			WeaponButtons_Toggle_LockPosition(value);
			value = getglobal("WeaponButtons_DefaultMode");
			if (value == nil ) then
				-- defaults to melee
				value = WEAPONBUTTONS_MODE_MELEE;
			end
			WeaponButtons_SetDefaultMode(1, value);
		end
	end
end

-- Toggles the enabled/disabled state of an option and returns the new state
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function WeaponButtons_Generic_Toggle(toggle, variableName, CVarName, enableMessage, disableMessage, UltimateUIVarName)
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
	if ( ( newvalue ~= oldvalue ) ) then
		local text = "";
		if ( newvalue == 1 ) then
			text = TEXT(getglobal(enableMessage));
		else
			text = TEXT(getglobal(disableMessage));
		end
		if ( ( text ) and ( strlen(text) > 0 ) ) then
			WeaponButtons_Print(text);
		end
	end
	WeaponButtons_Register_UltimateUI();
	RegisterForSave(variableName);
	if ( WeaponButtons_UltimateUI_Registered == 0 ) then 
		RegisterForSave(CVarName);
	else
		local varName = UltimateUIVarName;
		if ( not varName ) then
			varName = strsub(CVarName, 1, strlen(CVarName)-2);
		end
		UltimateUI_UpdateValue(varName, CSM_CHECKONOFF, newvalue);
		UltimateUI_UpdateValue(CVarName, CSM_CHECKONOFF, newvalue);
		UltimateUI_SetCVar(CVarName, newvalue);
	end
	return newvalue;
end

-- Toggles the enabled/disabled state of the WeaponButtons
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function WeaponButtons_DoToggle_Enabled(toggle, noChat)
	local newValue = 0;
	if ( noChat ) then
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_Enabled", "UUI_WEAPONBUTTONS_ENABLED_X");
	else
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_Enabled", "UUI_WEAPONBUTTONS_ENABLED_X", "WEAPONBUTTONS_CHAT_ENABLED", "WEAPONBUTTONS_CHAT_DISABLED");
	end
	if ( newValue == 1 ) then
		WeaponButtonsFrame:Show();
	else
		WeaponButtonsFrame:Hide();
	end
end

function WeaponButtons_Toggle_Enabled(toggle)
	WeaponButtons_DoToggle_Enabled(toggle);
end

function WeaponButtons_Toggle_Enabled_NoChat(toggle)
	WeaponButtons_DoToggle_Enabled(toggle, true);
end

-- Toggles whether tooltips are displayed on mousing over of the WeaponButtons
--  if toggle is 1, they are displayed
--  if toggle is 0, they are not displayed
--   otherwise, they are toggled
function WeaponButtons_DoToggle_DisplayTooltips(toggle, noChat)
	local newvalue = 0;
	if ( noChat ) then
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_DisplayTooltips", "UUI_WEAPONBUTTONS_DISPLAY_TOOLTIPS_X");
	else
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_DisplayTooltips", "UUI_WEAPONBUTTONS_DISPLAY_TOOLTIPS_X", "WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_ENABLED", "WEAPONBUTTONS_CHAT_DISPLAY_TOOLTIPS_DISABLED");
	end
end

function WeaponButtons_Toggle_DisplayTooltips(toggle)
	WeaponButtons_DoToggle_DisplayTooltips(toggle);
end

function WeaponButtons_Toggle_DisplayTooltips_NoChat(toggle)
	WeaponButtons_DoToggle_DisplayTooltips(toggle, true);
end

-- Toggles whether the window is locked to its current position or not.
--  if toggle is 1, they are displayed
--  if toggle is 0, they are not displayed
--   otherwise, they are toggled
function WeaponButtons_DoToggle_LockPosition(toggle, noChat)
	local newvalue = 0;
	if ( noChat ) then
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_LockPosition", "UUI_WEAPONBUTTONS_LOCK_POSITION_X");
	else
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_LockPosition", "UUI_WEAPONBUTTONS_LOCK_POSITION_X", "WEAPONBUTTONS_CHAT_LOCK_POSITION_ENABLED", "WEAPONBUTTONS_CHAT_LOCK_POSITION_DISABLED");
	end
end

function WeaponButtons_Toggle_LockPosition(toggle)
	WeaponButtons_DoToggle_LockPosition(toggle);
end

function WeaponButtons_Toggle_LockPosition_NoChat(toggle)
	WeaponButtons_DoToggle_LockPosition(toggle, true);
end

-- Toggles whether the window is locked to its current position or not.
--  if toggle is 1, they are displayed
--  if toggle is 0, they are not displayed
--   otherwise, they are toggled
function WeaponButtons_DoToggle_DefaultModeRanged(toggle, noChat)
	local newvalue = 0;
	if ( noChat ) then
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_DefaultModeRanged", "UUI_WEAPONBUTTONS_DEFAULT_MODE_RANGED_X");
	else
		newValue = WeaponButtons_Generic_Toggle(toggle, "WeaponButtons_DefaultModeRanged", "UUI_WEAPONBUTTONS_DEFAULT_MODE_RANGED_X", "WEAPONBUTTONS_CHAT_DEFAULT_MODE_RANGED_ENABLED", "WEAPONBUTTONS_CHAT_DEFAULT_MODE_RANGED_DISABLED");
	end
	if ( newvalue == 1 ) then
		WeaponButtons_ChangeMode(WEAPONBUTTONS_MODE_RANGED);
	else
		WeaponButtons_ChangeMode(WEAPONBUTTONS_MODE_MELEE);
	end
end

function WeaponButtons_Toggle_DefaultModeRanged(toggle)
	WeaponButtons_DoToggle_DefaultModeRanged(toggle);
end

function WeaponButtons_Toggle_DefaultModeRanged_NoChat(toggle)
	WeaponButtons_DoToggle_DefaultModeRanged(toggle, true);
end

-- Prints out text to a chat box.
function WeaponButtons_Print(msg,r,g,b,frame,id,unknown4th)
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

function WeaponButton_GetInventoryInfoSlotName(slotName)
	local inventorySlotInfoName = slotName;
	local charIndex = strfind(inventorySlotInfoName, "Character");
	if ( charIndex ) then inventorySlotInfoName = strsub(inventorySlotInfoName, charIndex); end
	inventorySlotInfoName = strsub(inventorySlotInfoName,10);
	return inventorySlotInfoName;
end

function WeaponButtonPaperDollItemSlotButton_OnLoad()
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("CURSOR_UPDATE");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("SHOW_COMPARE_TOOLTIP");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	local slotName = this:GetName();
	local id;
	local textureName;

	id, textureName = GetInventorySlotInfo(WeaponButton_GetInventoryInfoSlotName(slotName));
	
	this:SetID(id);
	local texture = getglobal(slotName.."IconTexture");
	texture:SetTexture(textureName);
	this.backgroundTextureName = textureName;
	PaperDollItemSlotButton_Update();
end


function WeaponButtonPaperDollItemSlotButton_OnEnter()
	if ( WeaponButtons_DisplayTooltips == 1 ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		local hasItem, hasCooldown, repairCost = GameTooltip:SetInventoryItem("player", this:GetID());
	    if ( not hasItem ) then
			GameTooltip:SetText(TEXT(getglobal(strupper(WeaponButton_GetInventoryInfoSlotName(this:GetName())))));
		end
		if ( hasCooldown ) then
			this.updateTooltip = TOOLTIP_UPDATE_TIME;
		else
			this.updateTooltip = nil;
		end
	--	if ( MerchantFrame:IsVisible() ) then
	--		ShowInventorySellCursor(this:GetID());
	--	end
		if ( InRepairMode() and repairCost and (repairCost > 0) ) then
			GameTooltip:AddLine(TEXT(REPAIR_COST), "", 1, 1, 1);
			SetTooltipMoney(GameTooltip, repairCost);
			GameTooltip:Show();
		end
	end
end

function WeaponButtons_OnClick(button)
	if ( button == "RightButton" ) then
		WeaponButtons_ToggleMode_NoChat();
	end
end
