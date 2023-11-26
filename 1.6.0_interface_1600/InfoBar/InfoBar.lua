--[[

	InfoBar: a customizable information window
		copyright 2005 by Telo

	- Provides the user the ability to select and customize the information they want displayed
	- Exposes hooks that allow additional plugins to be added to the InfoBar by other AddOns
	- Includes eight sample plugins

]]

--------------------------------------------------------------------------------------------------
-- Localizable strings
--------------------------------------------------------------------------------------------------

INFOBAR_SETUP_TT = "Display InfoBar Setup";
INFOBARCONFIG_TITLE = "InfoBar Setup";
INFOBARCONFIG_DISPLAY = "Display on InfoBar";
INFOBARCONFIG_TOOLTIP = "Add Info to Tooltip";
INFOBARCONFIG_OPTIONS_TT = "Click to display options for this plugin";
INFOBARCONFIG_MOVEDOWN_TT = "Click to move this plugin down in the list";
INFOBARCONFIG_MOVEUP_TT = "Click to move this plugin up in the list";
INFOBARCONFIG_DISPLAY_TT = "If checked, this plugin will be displayed in the InfoBar";
INFOBARCONFIG_TOOLTIP_TT = "If checked, this plugin's tooltip information will be displayed in the InfoBar's ? tooltip";
INFOBARCONFIG_BORDERS = "Borders";
INFOBARCONFIG_BACKGROUND = "Background";
INFOBARCONFIG_POSITION = "Auto Position";
INFOBARCONFIG_CONTROLS = "Controls";
INFOBARCONFIG_MOUSEOVER = "Mouseover Tooltip";
INFOBARCONFIG_TOPTOOLTIP = "Top Tooltips";
INFOBARCONFIG_BORDERS_TT = "If checked, plugin borders are always shown";
INFOBARCONFIG_BACKGROUND_TT = "If checked, the InfoBar background is always shown";
INFOBARCONFIG_POSITION_TT = "If checked, the InfoBar is auto-centered at the top of the screen whenever you change the displayed state of a plugin or the order of the plugin list";
INFOBARCONFIG_CONTROLS_TT = "If checked, the InfoBar tooltip and setup buttons are always shown";
INFOBARCONFIG_MOUSEOVER_TT = "If checked, displays the InfoBar tooltip when you mouseover the InfoBar's ? button, otherwise you need to click the ? button to show the tooltip";
INFOBARCONFIG_TOPTOOLTIP_TT = "If checked, InfoBar tooltips are positioned at the top center of the screen, regardless of where the bar is";


--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- hooked functions
local lOriginalCloseAllWindows;

-- the registered plugin array and its order
local lPlugins = { };
local lPluginOrder;

-- timer state for update function
local lUpdateTimer = 0;
local INFOBAR_UPDATE_TIME = 0.5;

-- if non-nil, the bar's position will be reset during the next update
local lResetPosition;

-- the current server
local lServer;

-- whether or not we've been initialized
local lInitialized;


--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

INFOBAR_VERSION = 100;

INFOBARCONFIG_ITEM_HEIGHT = 33;
INFOBARCONFIG_ITEMS_SHOWN = 11;


--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function InfoBar_FormatVersion(version)
	if( type(version) ~= "number" ) then
		return "???";
	end
	return format("%0.2f", version / 100);
end

local function InfoBar_PositionTooltip(frame)
	if( InfoBarState.tooltipAtTop ) then
		GameTooltip:SetOwner(InfoBarFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("TOP", "UIParent", "TOP", 0, -48);
	else
		local uiScale = GetCVar("uiscale") + 0;
		local screenHeight = 768;
		local screenWidth = 1024;
		local anchor;
		local x, y = frame:GetCenter();
		
		if( GetCVar("useUiScale") == "1" ) then
			screenHeight = 768 / uiScale;
			screenWidth = 1024 / uiScale;
		end

		if( y < screenHeight / 2 ) then
			if( x < screenWidth / 2 ) then
				anchor = "ANCHOR_TOPLEFT";
			else
				anchor = "ANCHOR_TOPRIGHT";
			end
		else
			if( x < screenWidth / 2 ) then
				anchor = "ANCHOR_BOTTOMRIGHT";
			else
				anchor = "ANCHOR_BOTTOMLEFT";
			end
		end
		
		GameTooltip:SetOwner(frame, anchor);
	end
end

local function InfoBar_MouseIsOver(frame)
	local x, y = GetCursorPosition();
	
	if( not frame ) then
		return nil;
	end
	
	x = x / frame:GetScale();
	y = y / frame:GetScale();

	local left = frame:GetLeft();
	local right = frame:GetRight();
	local top = frame:GetTop();
	local bottom = frame:GetBottom();
	
	if( not left or not right or not top or not bottom ) then
		return nil;
	end
	
	if( (x >= left and x <= right) and (y >= bottom and y <= top) ) then
		return 1;
	else
		return nil;
	end
end

local function InfoBar_GetWidth()
	local totalSize = 58;
	local index, value;
	
	for index, value in lPlugins do
		if( value.visible ) then
			local width = value.frame:GetWidth()
			totalSize = totalSize + 6 + width;
		end
	end
	
	return totalSize;
end

local function InfoBar_HandleWidgets()
	local index, value;

	InfoBarFrame:SetWidth(InfoBar_GetWidth());
	if( InfoBar_GetWidth() == 58 or InfoBar_MouseIsOver(InfoBarFrame) ) then
		InfoBarBackdrop:Show();
		InfoBarExpand:Show();
		InfoBarTooltip:Show();
		for index, value in lPlugins do
			if( value.visible ) then
				getglobal(index.."Backdrop"):Show();
			end
		end
	else
		if( InfoBarState.background ) then
			InfoBarBackdrop:Show();
		else
			InfoBarBackdrop:Hide();
		end
		if( InfoBarState.controls ) then
			InfoBarExpand:Show();
			InfoBarTooltip:Show();
		else
			if( InfoBarState.background ) then
				InfoBarFrame:SetWidth(InfoBar_GetWidth() - 52);
			end
			InfoBarExpand:Hide();
			InfoBarTooltip:Hide();
		end
		for index, value in lPlugins do
			if( value.visible ) then
				if( InfoBarState.borders or value.frame.info.forceBorder ) then
					getglobal(index.."Backdrop"):Show();
				else
					getglobal(index.."Backdrop"):Hide();
				end
			end
		end
	end
end

local function InfoBar_Center()
	local totalSize = InfoBar_GetWidth();
	local offset;
	
	if( totalSize > 58 ) then
		offset = 29;
	else
		offset = 0;
	end

	InfoBarFrame:ClearAllPoints();
	InfoBarFrame:SetPoint("TOP", "UIParent", "TOP", offset, 0);
end

local function InfoBar_Comparison(elem1, elem2)
	return lPlugins[elem1].order < lPlugins[elem2].order;
end

local function InfoBar_LayoutPlugins()
	local iItem = 1;
	local value;
	local width;
	local totalWidth = 58;
	local xPos = 6;
	
	for iItem = 1, lPluginOrder.onePastEnd - 1 do
		value = lPlugins[lPluginOrder[iItem]];
		if( value.visible ) then
			width = value.frame:GetWidth()
			totalWidth = totalWidth + 6 + width;
			value.frame:SetPoint("TOPLEFT", "InfoBarFrame", "TOPLEFT", xPos, -6);
			value.frame:Show();
			xPos = xPos + 6 + width;
		else
			value.frame:Hide();
		end
	end

	InfoBarFrame:SetWidth(totalWidth);
	
	if( InfoBarState.autoPosition ) then
		InfoBar_Center();
	end
end

local function InfoBar_CheckPlayerName()
	local name = UnitName("player");
	
	if( not name or name == UNKNOWNOBJECT or name == UKNOWNBEING ) then
		return nil;
	end
	
	return 1;
end

local function InfoBar_GetState(characterName, frame)
	local state;
	
	if( frame ) then
		local frameName = frame:GetName();
		if( not InfoBarState.Servers[lServer].Characters[characterName].State[frameName] ) then
			InfoBarState.Servers[lServer].Characters[characterName].State[frameName] = { };
		end
		state = InfoBarState.Servers[lServer].Characters[characterName].State[frameName];
	end
	
	return state;
end

local function InfoBar_SaveOrder()
	local name = UnitName("player");
	local index, value;

	for index, value in lPlugins do
		local state = InfoBar_GetState(name, value.frame);
		if( state ) then
			state.order = value.order;
		end
	end
end

local function InfoBar_BuildOrder()
	local iNew = 1;
	local index;
	local value;
	
	lPluginOrder = { };
	for index, value in lPlugins do
		lPluginOrder[iNew] = index;
		iNew = iNew + 1;
	end
	table.sort(lPluginOrder, InfoBar_Comparison);
	lPluginOrder.onePastEnd = iNew;
	
	InfoBar_SaveOrder();
end

local function InfoBar_RestoreState()
	local name = UnitName("player");
	local index, value;
	local ordered = { };
	local iItem = 1;
	local oldThis;
	
	if( not InfoBarState.Servers[lServer].Characters ) then
		InfoBarState.Servers[lServer].Characters = { };
	end
	if( not InfoBarState.Servers[lServer].Characters[name] ) then
		InfoBarState.Servers[lServer].Characters[name] = { };
	end
	if( not InfoBarState.Servers[lServer].Characters[name].State ) then
		InfoBarState.Servers[lServer].Characters[name].State = { };
	end
	
	lPluginOrder = { };
	
	oldThis = this;
	for index, value in lPlugins do
		local state = InfoBar_GetState(name, value.frame);
		if( state ) then
			value.order = state.order;
			value.visible = state.visible;
			value.tooltip = state.tooltip;
			if( type(value.frame.info.restore) == "function" ) then
				if( state.state ) then
					this = value.frame;
					value.frame.info.restore(state.state);
				else
					state.state = { };
				end
			end
			if( state.order ) then
				lPluginOrder[iItem] = index;
				ordered[index] = 1;
				iItem = iItem + 1;
			end
		end
	end
	this = oldThis;
	
	if( iItem > 1 ) then
		-- Compress the order numbers so that they go from 1 to n
		local iTemp;
		table.sort(lPluginOrder, InfoBar_Comparison);
		for iTemp = 1, iItem - 1 do
			lPlugins[lPluginOrder[iTemp]].order = iTemp;
		end
	end
	
	-- Now add the remaining plugins to the order array and set their order fields
	for index, value in lPlugins do
		if( not ordered[index] ) then
			lPluginOrder[iItem] = index;
			value.order = iItem;
			iItem = iItem + 1;
		end
	end
	lPluginOrder.onePastEnd = iItem;
	
	-- Finally, remove saved order state from missing plugins
	for index, value in InfoBarState.Servers[lServer].Characters[name].State do
		if( not lPlugins[index] ) then
			value.order = nil;
		end
	end
	
	InfoBar_SaveOrder();
	InfoBar_LayoutPlugins();
end

local function InfoBar_Initialize()
	local oldThis;
	
	InfoBar_RestoreState();

	oldThis = this;
	for index, value in lPlugins do
		if( type(value.frame.info.init) == "function" ) then
			this = value.frame;
			value.frame.info.init();
		end
	end
	this = oldThis;

	lInitialized = 1;
end


--------------------------------------------------------------------------------------------------
-- Global functions
--------------------------------------------------------------------------------------------------

-- InfoBar
function InfoBar_OnLoad()
	RegisterForSave("InfoBarState");
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("WORLD_MAP_UPDATE");
	this:RegisterEvent("UPDATE_TICKET");
	this:RegisterEvent("MEETINGSTONE_CHANGED");
	this:RegisterEvent("UPDATE_PENDING_MAIL");
	
	lOriginalCloseAllWindows = CloseAllWindows;
	CloseAllWindows = InfoBar_CloseAllWindows;

	-- If the control key is down on load, reset the bar's position;
	-- this is provided so that the bar can be recovered if offscreen
	if( IsControlKeyDown() ) then
		lResetPosition = 1;
	end

	if( DEFAULT_CHAT_FRAME ) then
		--DEFAULT_CHAT_FRAME:AddMessage("Telo's InfoBar AddOn loaded");
	end
	--UIErrorsFrame:AddMessage("Telo's InfoBar AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function InfoBar_OnEvent()
	if( event == "VARIABLES_LOADED" ) then
		if( not InfoBarState ) then
			InfoBarState = { };
			InfoBarState.mouseoverTooltip = 1;
		end
		if( not InfoBarState.Servers ) then
			InfoBarState.Servers = { };
		end

		lServer = GetCVar("realmName");
		if( not InfoBarState.Servers[lServer] ) then
			InfoBarState.Servers[lServer] = { };
		end
		
		if( InfoBarState.borders ) then
			InfoBarConfigBorders:SetChecked(1);
		end
		if( InfoBarState.background ) then
			InfoBarConfigBackground:SetChecked(1);
		end
		if( InfoBarState.autoPosition ) then
			InfoBarConfigPosition:SetChecked(1);
		end
		if( InfoBarState.controls ) then
			InfoBarConfigControls:SetChecked(1);
		end
		if( InfoBarState.mouseoverTooltip ) then
			InfoBarConfigMouseover:SetChecked(1);
		end
		if( InfoBarState.tooltipAtTop ) then
			InfoBarConfigTooltip:SetChecked(1);
		end
	elseif( event == "PLAYER_XP_UPDATE" or event == "WORLD_MAP_UPDATE" or event == "UPDATE_TICKET" or
			event == "MEETINGSTONE_CHANGED" or event == "UPDATE_PENDING_MAIL" ) then
		-- These events generally occur just before the player gets control and everything is initialized
		if( not lInitialized and InfoBarState and InfoBar_CheckPlayerName() ) then
			InfoBar_Initialize();
		end
		if( lInitialized ) then
			this:UnregisterEvent(event);
		end
	end
end

function InfoBar_OnUpdate(elapsed)
	local index, value;
	local oldThis;

	if( lResetPosition ) then
		InfoBar_Center();
		lResetPosition = nil;
	end
	
	lUpdateTimer = lUpdateTimer + elapsed;
	if( lUpdateTimer >= INFOBAR_UPDATE_TIME ) then
		if( GameTooltip:IsOwned(InfoBarFrame) ) then
			if( not InfoBarFrame.tooltipOwner ) then
				InfoBar_ShowTooltip();
			else
				InfoBar_ShowPluginTooltip(InfoBarFrame.tooltipOwner);
			end
		elseif( GameTooltip:IsOwned(InfoBarTooltip) ) then
			InfoBar_ShowTooltip();
		elseif( InfoBarFrame.tooltipOwner and GameTooltip:IsOwned(InfoBarFrame.tooltipOwner) ) then
			InfoBar_ShowPluginTooltip(InfoBarFrame.tooltipOwner);
		else
			InfoBarFrame.tooltipOwner = nil;
		end
		InfoBar_HandleWidgets();
	end

	-- Call plugin update functions; this way they can update data even if not visible	
	oldThis = this;
	for index, value in lPlugins do
		if( type(value.frame.info.update) == "function" ) then
			this = value.frame;
			value.frame.info.update(elapsed);
		end
	end
	this = oldThis;
end

function InfoBar_ShowTooltip()
	local iItem;
	local value;
	local lines;
	local oldThis;
	
	InfoBar_PositionTooltip(InfoBarTooltip);
	
	GameTooltip:SetText("Telo's InfoBar (v"..InfoBar_FormatVersion(INFOBAR_VERSION)..")", 0.9569, 0.9176, 0.4078);
	lines = 1;
	
	oldThis = this;
	for iItem = 1, lPluginOrder.onePastEnd - 1 do
		if( lines >= 15 ) then
			break;
		end
		
		value = lPlugins[lPluginOrder[iItem]];
		if( value.tooltip and type(value.frame.info.tooltip) == "function" ) then
			local text;
			
			this = value.frame;
			text = value.frame.info.tooltip();
			
			-- Surround the tooltip string with blank lines so that it
			-- stands out and the plugin's name is correctly centered
			if( string.sub(text, -1) == "\n" ) then
				GameTooltip:AddLine("\n"..text.."\n");
			else
				GameTooltip:AddLine("\n"..text.."\n\n");
			end
			lines = lines + 1;
			
			getglobal("GameTooltipTextRight"..lines):SetText(value.frame.info.name);
			getglobal("GameTooltipTextRight"..lines):SetTextColor(0.2784, 0.7333, 0.8627);
			getglobal("GameTooltipTextRight"..lines):Show();
		end
	end
	this = oldThis;

	GameTooltip:Show();
end

function InfoBar_CloseAllWindows(ignoreCenter)
	local closed = lOriginalCloseAllWindows(ignoreCenter);
	
	if( InfoBarConfigurationFrame:IsVisible() ) then
		InfoBarConfigurationFrame:Hide();
		closed = 1;
	end
	
	return closed;
end


-- InfoBar setup dialog
function InfoBarConfig_Update()
	local iItem;
	
	FauxScrollFrame_Update(InfoBarConfigurationListScrollFrame, lPluginOrder.onePastEnd - 1, INFOBARCONFIG_ITEMS_SHOWN, INFOBARCONFIG_ITEM_HEIGHT);
	for iItem = 1, INFOBARCONFIG_ITEMS_SHOWN do
		local itemIndex = iItem + FauxScrollFrame_GetOffset(InfoBarConfigurationListScrollFrame);
		local configItem = getglobal("InfoBarConfigurationItem"..iItem);
		if( itemIndex < lPluginOrder.onePastEnd ) then
			local plugin = lPlugins[lPluginOrder[itemIndex]];

			getglobal("InfoBarConfigurationItem"..iItem.."Name"):SetText(plugin.frame.info.name);
			getglobal("InfoBarConfigurationItem"..iItem.."Version"):SetText(InfoBar_FormatVersion(plugin.frame.info.version));
			if( math.mod(itemIndex, 2) == 1 ) then
				getglobal("InfoBarConfigurationItem"..iItem.."Name"):SetTextColor(1, 0.82, 0);
				getglobal("InfoBarConfigurationItem"..iItem.."Version"):SetTextColor(1, 0.82, 0);
				getglobal("InfoBarConfigurationItem"..iItem.."DisplayLabel"):SetTextColor(1, 0.82, 0);
				getglobal("InfoBarConfigurationItem"..iItem.."TooltipLabel"):SetTextColor(1, 0.82, 0);
			else
				getglobal("InfoBarConfigurationItem"..iItem.."Name"):SetTextColor(0, 0.82, 1);
				getglobal("InfoBarConfigurationItem"..iItem.."Version"):SetTextColor(0, 0.82, 1);
				getglobal("InfoBarConfigurationItem"..iItem.."DisplayLabel"):SetTextColor(0, 0.82, 1);
				getglobal("InfoBarConfigurationItem"..iItem.."TooltipLabel"):SetTextColor(0, 0.82, 1);
			end
			if( itemIndex > 1 ) then
				getglobal("InfoBarConfigurationItem"..iItem.."MoveUp"):Show();
			else
				getglobal("InfoBarConfigurationItem"..iItem.."MoveUp"):Hide();
			end
			if( itemIndex < lPluginOrder.onePastEnd - 1 ) then
				getglobal("InfoBarConfigurationItem"..iItem.."MoveDown"):Show();
			else
				getglobal("InfoBarConfigurationItem"..iItem.."MoveDown"):Hide();
			end
			if( plugin.visible ) then
				getglobal("InfoBarConfigurationItem"..iItem.."Display"):SetChecked(1);
			else
				getglobal("InfoBarConfigurationItem"..iItem.."Display"):SetChecked(0);
			end
			if( type(plugin.frame.info.tooltip) == "function" ) then
				getglobal("InfoBarConfigurationItem"..iItem.."Tooltip"):Show();
				if( plugin.tooltip ) then
					getglobal("InfoBarConfigurationItem"..iItem.."Tooltip"):SetChecked(1);
				else
					getglobal("InfoBarConfigurationItem"..iItem.."Tooltip"):SetChecked(0);
				end
			else
				getglobal("InfoBarConfigurationItem"..iItem.."Tooltip"):Hide();
			end
			if( type(plugin.frame.info.options) == "table" and type(plugin.frame.info.options.GetName) == "function" ) then
				getglobal("InfoBarConfigurationItem"..iItem.."Options"):Show();
			else
				getglobal("InfoBarConfigurationItem"..iItem.."Options"):Hide();
			end
			
			configItem:Show();
		else
			configItem:Hide();
		end
	end
end

function InfoBarConfig_MoveUp()
	local iItem;
	local itemIndex;
	local s, e;
	
	s, e, iItem = string.find(this:GetName(), "InfoBarConfigurationItem(%d+)");
	if( iItem ) then
		local plugin;
		local oldOrder;
		local index, value;
	
		iItem = iItem + 0;
		itemIndex = iItem + FauxScrollFrame_GetOffset(InfoBarConfigurationListScrollFrame);
		
		plugin = lPlugins[lPluginOrder[itemIndex]];
		oldOrder = plugin.order;
		
		for index, value in lPlugins do
			if( value.order == oldOrder - 1 ) then
				value.order = value.order + 1;
			end
		end
		
		plugin.order = oldOrder - 1;
		
		InfoBar_BuildOrder();
		InfoBar_LayoutPlugins();
		InfoBarConfig_Update();
	end
end

function InfoBarConfig_MoveDown()
	local iItem;
	local itemIndex;
	local s, e;
	
	s, e, iItem = string.find(this:GetName(), "InfoBarConfigurationItem(%d+)");
	if( iItem ) then
		local plugin;
		local oldOrder;
		local index, value;
	
		iItem = iItem + 0;
		itemIndex = iItem + FauxScrollFrame_GetOffset(InfoBarConfigurationListScrollFrame);
		
		plugin = lPlugins[lPluginOrder[itemIndex]];
		oldOrder = plugin.order;
		
		for index, value in lPlugins do
			if( value.order == oldOrder + 1 ) then
				value.order = value.order - 1;
			end
		end
		
		plugin.order = oldOrder + 1;
		
		InfoBar_BuildOrder();
		InfoBar_LayoutPlugins();
		InfoBarConfig_Update();
	end
end

function InfoBarConfig_Display()
	local iItem;
	local itemIndex;
	local s, e;
	
	s, e, iItem = string.find(this:GetName(), "InfoBarConfigurationItem(%d+)");
	if( iItem ) then
		local plugin;
		local state;

		iItem = iItem + 0;
		itemIndex = iItem + FauxScrollFrame_GetOffset(InfoBarConfigurationListScrollFrame);
		
		plugin = lPlugins[lPluginOrder[itemIndex]];
		plugin.visible = this:GetChecked();
		
		state = InfoBar_GetState(UnitName("player"), plugin.frame);
		if( state ) then
			state.visible = plugin.visible;
		end
		
		InfoBar_LayoutPlugins();
	end
end

function InfoBarConfig_Tooltip()
	local iItem;
	local itemIndex;
	local s, e;
	
	s, e, iItem = string.find(this:GetName(), "InfoBarConfigurationItem(%d+)");
	if( iItem ) then
		local plugin;
		local state;

		iItem = iItem + 0;
		itemIndex = iItem + FauxScrollFrame_GetOffset(InfoBarConfigurationListScrollFrame);
		
		plugin = lPlugins[lPluginOrder[itemIndex]];
		plugin.tooltip = this:GetChecked();

		state = InfoBar_GetState(UnitName("player"), plugin.frame);
		if( state ) then
			state.tooltip = plugin.tooltip;
		end
	end
end

function InfoBarConfig_Options()
	local iItem;
	local itemIndex;
	local s, e;
	
	s, e, iItem = string.find(this:GetName(), "InfoBarConfigurationItem(%d+)");
	if( iItem ) then
		local plugin;
		local state;

		iItem = iItem + 0;
		itemIndex = iItem + FauxScrollFrame_GetOffset(InfoBarConfigurationListScrollFrame);
		
		plugin = lPlugins[lPluginOrder[itemIndex]];
		state = InfoBar_GetState(UnitName("player"), plugin.frame);

		if( state ) then
			local frame = plugin.frame.info.options;
			
			InfoBarConfig_OptionsCancel();
			
			InfoBarConfigurationFrame.optionsFrame = frame;
			InfoBarConfigurationFrame.optionsState = state.state;
			
			InfoBarConfigurationFrame:Hide();
			
			frame:Show();
			if( frame.info and type(frame.info.load) == "function" ) then
				local oldThis = this;
				this = frame;
				frame.info.load(InfoBarConfigurationFrame.optionsState);
				this = oldThis;
			end
		end
	end
end

function InfoBarConfig_OptionsOkay()
	local frame = InfoBarConfigurationFrame.optionsFrame;
	
	if( frame ) then
		if( frame.info and type(frame.info.save) == "function" ) then
			local oldThis = this;
			this = frame;
			frame.info.save(InfoBarConfigurationFrame.optionsState);
			this = oldThis;
		end
		frame:Hide();
		
		InfoBarConfigurationFrame:Show();
	end
	
	InfoBarConfigurationFrame.optionsFrame = nil;
	InfoBarConfigurationFrame.optionsState = nil;
end

function InfoBarConfig_OptionsCancel()
	local frame = InfoBarConfigurationFrame.optionsFrame;
	
	if( frame ) then
		frame:Hide();
		
		InfoBarConfigurationFrame:Show();
	end
	
	InfoBarConfigurationFrame.optionsFrame = nil;
	InfoBarConfigurationFrame.optionsState = nil;
end


--------------------------------------------------------------------------------------------------
-- Interface functions
--------------------------------------------------------------------------------------------------

function InfoBar_RegisterFrame(frame)
	if( frame ) then
		local name = frame:GetName();
	
		if( lPlugins[name] ) then
			return;
		end
		
		-- Set up the plugin data for this frame
		lPlugins[name] = { };
		lPlugins[name].frame = frame;

		-- If we've already done our general setup, do this one
		if( lPluginOrder ) then
			if( type(frame.info.restore) == "function" ) then
				local state = InfoBar_GetState(name, frame);
				if( state ) then
					state.state = { };
				end
			end
			lPlugins[name].order = lPluginOrder.onePastEnd;
			InfoBar_BuildOrder();
		end
	end
end

function InfoBar_ShowPluginTooltip(frame)
	if( frame ) then
		local name = frame:GetName();
		local plugin = lPlugins[name];

		if( type(plugin.frame.info.tooltip) == "function" ) then
			InfoBar_PositionTooltip(frame);
			GameTooltip:SetText(plugin.frame.info.name, 0.2784, 0.7333, 0.8627);
			local oldThis = this;
			this = plugin.frame;
			GameTooltip:AddLine(plugin.frame.info.tooltip());
			this = oldThis;
			GameTooltip:Show();
			
			InfoBarFrame.tooltipOwner = frame;
		end
	end
end

function InfoBar_HidePluginTooltip()
	InfoBarFrame.tooltipOwner = nil;
	GameTooltip:Hide();
end

function InfoBar_ShouldUpdateTooltip(frame)
	if( GameTooltip:IsOwned(InfoBarFrame) ) then
		if( frame and InfoBarFrame.tooltipOwner == frame ) then
			return 1;
		end
	elseif( frame and GameTooltip:IsOwned(frame) ) then
		return 1;
	end
	return nil;
end


--------------------------------------------------------------------------------------------------
-- Sample plugin functions
--------------------------------------------------------------------------------------------------

-- BagSpace -------------------------------------------------------------------

function IB_BagSpace_OnLoad()
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("BAG_UPDATE_COOLDOWN");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	IB_BagSpaceBar:SetWidth(this:GetWidth());
end

function IB_BagSpace_Init()
	IB_BagSpace_SetValues();
end

function IB_BagSpace_SetValues()
	local i, j;
	local size;
	local total = 0;
	local used = 0;
	for i = 0, 4 do
		size = GetContainerNumSlots(i);
		if( size and size > 0 ) then
			total = total + size;
			for j = 1, size do
				if( GetContainerItemInfo(i, j) ) then
					used = used + 1;
				end
			end
		end
	end
	
	IB_BagSpaceBar:SetMinMaxValues(0, total);
	IB_BagSpaceBar:SetValue(used);
	IB_BagSpaceText:SetText(used.." / "..total);
end


-- Money ----------------------------------------------------------------------

IB_MONEY_TOOLTIP_FORMAT = "Average amount %s per hour: %s\nCurrent amount: %s\nInitial amount: %s";
IB_MONEY_LOST = "lost";
IB_MONEY_EARNED = "earned";
IB_MONEY_GOLD = "%dg ";
IB_MONEY_SILVER = "%s%ds ";
IB_MONEY_COPPER = "%s%dc";
IB_MONEY_INITIALIZING = "Initializing...";

local lIB_Money_initial;
local lIB_Money_time = 0;

function IB_Money_Init()
	local money = GetMoney();
	lIB_Money_initial = money;
	MoneyFrame_Update("IB_MoneyMoney", money);
end

function IB_Money_OnUpdate(elapsed)
	lIB_Money_time = lIB_Money_time + elapsed;
end

local function IB_Money_Format(amount)
	local g, s, c;
	local text = "";
	local force;
	
	amount = math.floor(amount + 0.5);
	
	g = math.floor(amount / COPPER_PER_GOLD);
	s = math.floor((amount - g * COPPER_PER_GOLD) / COPPER_PER_SILVER);
	c = math.mod(amount, COPPER_PER_SILVER);
	
	if( g > 0 ) then
		text = format(TEXT(IB_MONEY_GOLD), g);
		force = 1;
	end
	if( force or s > 0 ) then
		text = format(TEXT(IB_MONEY_SILVER), text, s);
	end
	text = format(TEXT(IB_MONEY_COPPER), text, c);
	
	return text;
end

function IB_Money_Tooltip()
	local money = GetMoney();
	local moneyPerHour;
	
	if( not lIB_Money_initial ) then
		return TEXT(IB_MONEY_INITIALIZING);
	end

	if( money < lIB_Money_initial ) then
		moneyPerHour = (lIB_Money_initial - money) / (lIB_Money_time / 3600);
		return format(TEXT(IB_MONEY_TOOLTIP_FORMAT), TEXT(IB_MONEY_LOST),
			IB_Money_Format(moneyPerHour),
			IB_Money_Format(money),
			IB_Money_Format(lIB_Money_initial));
	else
		moneyPerHour = (money - lIB_Money_initial) / (lIB_Money_time / 3600);
		return format(TEXT(IB_MONEY_TOOLTIP_FORMAT), TEXT(IB_MONEY_EARNED),
			IB_Money_Format(moneyPerHour),
			IB_Money_Format(money),
			IB_Money_Format(lIB_Money_initial));
	end	 
end


-- Clock ----------------------------------------------------------------------

IB_CLOCK_OPTIONS_TITLE = "Clock Options";
IB_CLOCK_OPTIONS_FORMAT = "Clock format:";
IB_CLOCK_OPTIONS_TOOLTIP = "Tooltip settings:";
IB_CLOCK_OPTIONS_DISABLESECONDS = "Don't display seconds";
IB_CLOCK_FORMATEXPLANATION = "This is the format string that is used to construct the displayed time. Some useful items:\n\n%H is the hour in 24-hour format\n%I is the hour in 12-hour format\n%M is the minute\n%S is seconds\n%p is the AM/PM indicator"

TIME_PLAYED_SESSION = "Time played this session: %s";
CLOCK_TIME_DAY = "%d day";
CLOCK_TIME_HOUR = "%d hour";
CLOCK_TIME_MINUTE = "%d minute";
CLOCK_TIME_SECOND = "%d second";
EXP_PER_HOUR_LEVEL = "Experience per hour this level: %.2f";
EXP_PER_HOUR_SESSION = "Experience per hour this session: %.2f";
EXP_TO_LEVEL = "Experience to level: %d (%.2f%% to go)";
TIME_TO_LEVEL_LEVEL = "Time to level at this level's rate: %s";
TIME_TO_LEVEL_SESSION = "Time to level at this session's rate: %s";
TIME_INFINITE = "infinite";

IB_CLOCK_DEFAULT_FORMAT = "%I:%M %p";

local lIB_Clock_state;
local lIB_Clock_totalTimePlayed = 0;
local lIB_Clock_levelTimePlayed = 0;
local lIB_Clock_sessionTimePlayed = 0;
local lIB_Clock_elapsedSinceLastPlayedMessage = 0;
local lIB_Clock_requestedPlayedMessage;
local lIB_Clock_needPlayedMessage = 1;
local lIB_Clock_initialXP;
local lIB_Clock_sessionXP = 0;
local lIB_Clock_rolloverXP = 0;

function IB_Clock_OnLoad()
	this:RegisterEvent("TIME_PLAYED_MSG");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_XP_UPDATE");
end

function IB_Clock_OnEvent()
	if( event == "TIME_PLAYED_MSG" ) then
		lIB_Clock_totalTimePlayed = arg1;
		lIB_Clock_levelTimePlayed = arg2;
		lIB_Clock_elapsedSinceLastPlayedMessage = 0;
		lIB_Clock_needPlayedMessage = nil;
		
		-- Sync up all of the times to the session time; this makes
		-- the tooltip look nicer as everything changes all at once
		local fraction = lIB_Clock_sessionTimePlayed - floor(lIB_Clock_sessionTimePlayed);
		lIB_Clock_totalTimePlayed = floor(lIB_Clock_totalTimePlayed) + fraction;
		lIB_Clock_levelTimePlayed = floor(lIB_Clock_levelTimePlayed) + fraction;
	elseif( event == "PLAYER_LEVEL_UP" ) then
		lIB_Clock_levelTimePlayed = lIB_Clock_sessionTimePlayed - floor(lIB_Clock_sessionTimePlayed);
		lIB_Clock_rolloverXP = lIB_Clock_rolloverXP + lIB_Clock_sessionXP;
		lIB_Clock_initialXP = 0;
	elseif( event == "PLAYER_ENTERING_WORLD" ) then
		if( not lIB_Clock_initialXP ) then
			lIB_Clock_initialXP = UnitXP("player");
		end
	elseif( event == "PLAYER_XP_UPDATE" ) then
		if( lIB_Clock_initialXP ) then
			lIB_Clock_sessionXP = UnitXP("player") - lIB_Clock_initialXP + lIB_Clock_rolloverXP;
		end
	end
end

--@todo Telo: compatibility with 1.2.4...
function IB_Clock_GetTimeText()
	local hour, minute = GetGameTime();
	local pm;

	if( hour >= 12 ) then
		pm = 1;
		hour = hour - 12;
	end
	if( hour == 0 ) then
		hour = 12;
	end
	if( pm ) then
		return format(TEXT(TIME_TWELVEHOURPM), hour, minute);
	else
		return format(TEXT(TIME_TWELVEHOURAM), hour, minute);
	end
end

function IB_Clock_OnUpdate(elapsed)
	lIB_Clock_sessionTimePlayed = lIB_Clock_sessionTimePlayed + elapsed;
	lIB_Clock_elapsedSinceLastPlayedMessage = lIB_Clock_elapsedSinceLastPlayedMessage + elapsed;

	if( not this.updateTimer ) then
		this.updateTimer = 0;
	else
		this.updateTimer = this.updateTimer - elapsed;
	end
	if( this.updateTimer <= 0 ) then
		--@todo Telo: compatibility with 1.2.4...
		if( type(date) == "function" ) then
			if( lIB_Clock_state and lIB_Clock_state.format ) then
				IB_ClockCenteredText:SetText(date(lIB_Clock_state.format));
			else
				IB_ClockCenteredText:SetText(date(IB_CLOCK_DEFAULT_FORMAT));
			end
		else
			IB_ClockCenteredText:SetText(IB_Clock_GetTimeText());
		end
		this.updateTimer = 0.25;
	end
end

local function IB_Clock_FormatPart(fmt, val)
	local part;
	
	part = format(TEXT(fmt), val);
	if( val ~= 1 ) then
		part = part.."s";
	end
	
	return part;
end

local function IB_Clock_FormatTime(time)
	local d, h, m, s;
	local text = "";
	local force;
	
	local noSeconds;
	if( lIB_Clock_state and lIB_Clock_state.noSeconds ) then
		noSeconds = 1;
	end

	d, h, m, s = ChatFrame_TimeBreakDown(time);
	if( d > 0 ) then
		text = text..IB_Clock_FormatPart(CLOCK_TIME_DAY, math.floor(d))..", ";
		force = 1;
	end
	if( force or h > 0 ) then
		text = text..IB_Clock_FormatPart(CLOCK_TIME_HOUR, math.floor(h))..", ";
		force = 1;
	end
	if( force or m > 0 or noSeconds ) then
		text = text..IB_Clock_FormatPart(CLOCK_TIME_MINUTE, math.floor(m));
		if( not noSeconds ) then
			text = text..", ";
		end
	end
	if( not noSeconds ) then
		text = text..IB_Clock_FormatPart(CLOCK_TIME_SECOND, math.floor(s));
	end
	
	return text;
end

function IB_Clock_Tooltip()
	local total, level, session;
	local xpPerHourLevel, xpPerHourSession;
	local xpTotal, xpCurrent, xpToLevel;
	local text;
	
	total = format(TEXT(TIME_PLAYED_TOTAL), IB_Clock_FormatTime(lIB_Clock_totalTimePlayed + lIB_Clock_elapsedSinceLastPlayedMessage));
	level = format(TEXT(TIME_PLAYED_LEVEL), IB_Clock_FormatTime(lIB_Clock_levelTimePlayed + lIB_Clock_elapsedSinceLastPlayedMessage));
	session = format(TEXT(TIME_PLAYED_SESSION), IB_Clock_FormatTime(lIB_Clock_sessionTimePlayed));
	
	if( lIB_Clock_needPlayedMessage ) then
		if( not lIB_Clock_requestedPlayedMessage ) then
			RequestTimePlayed();
			lIB_Clock_requestedPlayedMessage = 1;
		end
		text = session;
	else
		text = total.."\n"..level.."\n"..session;
	end

	if( (lIB_Clock_levelTimePlayed + lIB_Clock_elapsedSinceLastPlayedMessage > 0) or lIB_Clock_sessionTimePlayed > 0 ) then
		text = text.."\n";
	end
	if( lIB_Clock_levelTimePlayed + lIB_Clock_elapsedSinceLastPlayedMessage > 0 ) then
		xpPerHourLevel = UnitXP("player") / ((lIB_Clock_levelTimePlayed + lIB_Clock_elapsedSinceLastPlayedMessage) / 3600);
		text = text.."\n"..format(TEXT(EXP_PER_HOUR_LEVEL), xpPerHourLevel);
	else
		xpPerHourLevel = 0;
	end
	if( lIB_Clock_sessionTimePlayed > 0 ) then
		xpPerHourSession = lIB_Clock_sessionXP / (lIB_Clock_sessionTimePlayed / 3600);
		text = text.."\n"..format(TEXT(EXP_PER_HOUR_SESSION), xpPerHourSession);
	else
		xpPerHourSession = 0;
	end
	
	if( UnitLevel("player") < 60 ) then
		xpTotal = UnitXPMax("player");
		xpCurrent = UnitXP("player");
		if( xpCurrent < xpTotal ) then
			xpToLevel = xpTotal - xpCurrent;
			text = text.."\n"..format(TEXT(EXP_TO_LEVEL), xpToLevel, (xpToLevel / xpTotal) * 100);
			if( xpPerHourLevel > 0 ) then
				text = text.."\n\n"..format(TEXT(TIME_TO_LEVEL_LEVEL), IB_Clock_FormatTime((xpToLevel / xpPerHourLevel) * 3600));
			else
				text = text.."\n\n"..format(TEXT(TIME_TO_LEVEL_LEVEL), TEXT(TIME_INFINITE));
			end
			if( xpPerHourSession > 0 ) then
				text = text.."\n"..format(TEXT(TIME_TO_LEVEL_SESSION), IB_Clock_FormatTime((xpToLevel / xpPerHourSession) * 3600));
			else
				text = text.."\n"..format(TEXT(TIME_TO_LEVEL_SESSION), TEXT(TIME_INFINITE));
			end
		end
	end
	
	return text;
end

function IB_Clock_Load(state)
	lIB_Clock_state = state;

	IB_Clock_OptionsTitle:SetText(TEXT(IB_CLOCK_OPTIONS_TITLE));
	if( lIB_Clock_state.format ) then
		IB_CO_FormatEditBox:SetText(lIB_Clock_state.format);
	else
		IB_CO_FormatEditBox:SetText(IB_CLOCK_DEFAULT_FORMAT);
	end
	if( lIB_Clock_state.noSeconds ) then
		IB_CO_SecondsCheckBox:SetChecked(1);
	else
		IB_CO_SecondsCheckBox:SetChecked(0);
	end
end

function IB_Clock_Save(state)
	local value;
	
	value = IB_CO_FormatEditBox:GetText();
	if( value and value ~= "" ) then
		state.format = value;
	end
	
	state.noSeconds = IB_CO_SecondsCheckBox:GetChecked();
end

function IB_Clock_Restore(state)
	lIB_Clock_state = state;
end


-- FrameRate ------------------------------------------------------------------

IB_FRAMERATE_TOOLTIP_FORMAT = "Current %s %.1f\nAverage %s %.1f\nMinimum %s %.1f\nMaximum %s %.1f";

local lIB_FrameRate_min;
local lIB_FrameRate_max;
local lIB_FrameRate_avg = 0;
local lIB_FrameRate_samples = 0;

function IB_FrameRate_OnUpdate(elapsed)
	if( not this.updateTimer ) then
		this.updateTimer = 0;
	else
		this.updateTimer = this.updateTimer - elapsed;
	end
	if( this.updateTimer <= 0 ) then
		local rate = GetFramerate();
		
		if( not lIB_FrameRate_min or rate < lIB_FrameRate_min ) then
			lIB_FrameRate_min = rate;
		end
		if( not lIB_FrameRate_max or rate > lIB_FrameRate_max ) then
			lIB_FrameRate_max = rate;
		end
		lIB_FrameRate_avg = ((lIB_FrameRate_avg * lIB_FrameRate_samples) + rate) / (lIB_FrameRate_samples + 1);
		lIB_FrameRate_samples = lIB_FrameRate_samples + 1;

		IB_FrameRateCenteredText:SetText(format("%s %.f", TEXT(FRAMERATE_LABEL), rate));
		this.updateTimer = 0.25;
	end
end

function IB_FrameRate_Tooltip()
	return format(TEXT(IB_FRAMERATE_TOOLTIP_FORMAT),
		TEXT(FRAMERATE_LABEL), GetFramerate(),
		TEXT(FRAMERATE_LABEL), lIB_FrameRate_avg,
		TEXT(FRAMERATE_LABEL), lIB_FrameRate_min,
		TEXT(FRAMERATE_LABEL), lIB_FrameRate_max);
end


-- Network --------------------------------------------------------------------

IB_NETWORK_TOOLTIP_FORMAT = "Current latency: %d %s\nAverage latency: %.1f %s\nMinimum latency: %d %s\nMaximum latency: %d %s";

local lIB_Network_min;
local lIB_Network_max;
local lIB_Network_avg = 0;
local lIB_Network_samples = 0;

function IB_Network_OnUpdate(elapsed)
	if( not this.updateTimer ) then
		this.updateTimer = 0;
	else
		this.updateTimer = this.updateTimer - elapsed;
	end
	if( this.updateTimer <= 0 ) then
		local bandwidthIn, bandwidthOut, latency = GetNetStats();

		if( not lIB_Network_min or latency < lIB_Network_min ) then
			lIB_Network_min = latency;
		end
		if( not lIB_Network_max or latency > lIB_Network_max ) then
			lIB_Network_max = latency;
		end
		lIB_Network_avg = ((lIB_Network_avg * lIB_Network_samples) + latency) / (lIB_Network_samples + 1);
		lIB_Network_samples = lIB_Network_samples + 1;

		IB_NetworkCenteredText:SetText(latency.." "..MILLISECONDS_ABBR);
		this.updateTimer = 0.25;
	end
end

function IB_Network_Tooltip()
	local bandwidthIn, bandwidthOut, latency = GetNetStats();
	return format(TEXT(IB_NETWORK_TOOLTIP_FORMAT),
		latency, TEXT(MILLISECONDS_ABBR),
		lIB_Network_avg, TEXT(MILLISECONDS_ABBR),
		lIB_Network_min, TEXT(MILLISECONDS_ABBR),
		lIB_Network_max, TEXT(MILLISECONDS_ABBR));
end


-- HealthRegen ----------------------------------------------------------------

IB_HEALTHREGEN_TOOLTIP_FORMAT = "Average health %s over the last %d second%s: %.1f / sec";
IB_HEALTHREGEN_GAINED = "gained";
IB_HEALTHREGEN_LOST = "lost";
IB_HEALTHREGEN_NODATA = "Collecting data...";

local lIB_HealthRegen_inCombat;
local lIB_HealthRegen_time;
local lIB_HealthRegen_samples = { };
local lIB_HealthRegen_avg;
local lIB_HealthRegen_sec;

local function IB_HealthRegen_Reset()
	local i;
	local v = UnitHealth("player");
	lIB_HealthRegen_time = 0;
	for i = 0, 10 do
		lIB_HealthRegen_samples[i] = v;
	end
end

function IB_HealthRegen_OnLoad()
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	IB_HealthRegenCenteredText:SetTextColor(0.0, 1.0, 0.0);
	IB_HealthRegen_Reset();
end

function IB_HealthRegen_OnEvent()
	if( event == "PLAYER_REGEN_DISABLED" ) then
		lIB_HealthRegen_inCombat = 1;
	elseif( event == "PLAYER_REGEN_ENABLED" ) then
		lIB_HealthRegen_inCombat = nil;
	end
	IB_HealthRegen_Reset();
end

function IB_HealthRegen_OnUpdate(elapsed)
	local last = math.floor(lIB_HealthRegen_time);
	local curr;
	
	curr = math.floor(lIB_HealthRegen_time + elapsed);
	
	if( last == 0 and curr > (last + 1) ) then
		return;
	end
	
	if( curr > last ) then
		local max;
		local index;
		local change = 0;
		local i;
		
		if( curr > 10 ) then
			max = 10;
			index = math.mod(curr + 1, 11);
		else
			max = curr;
			index = 0;
		end
		
		curr = math.mod(curr, 11);
		lIB_HealthRegen_samples[curr] = UnitHealth("player");

		prior = lIB_HealthRegen_samples[index];
		for i = 1, max do
			index = math.mod(index + 1, 11);
			change = change + lIB_HealthRegen_samples[index] - prior;
			prior = lIB_HealthRegen_samples[index];
		end
		
		lIB_HealthRegen_sec = max;
		lIB_HealthRegen_avg = change / lIB_HealthRegen_sec;
		IB_HealthRegenCenteredText:SetText(format("%.1f", lIB_HealthRegen_avg));
	elseif( lIB_HealthRegen_time == 0 ) then
		lIB_HealthRegen_sec = nil;
		lIB_HealthRegen_avg = nil;
		IB_HealthRegenCenteredText:SetText("-----");
	end

	lIB_HealthRegen_time = lIB_HealthRegen_time + elapsed;
end

function IB_HealthRegen_Tooltip()
	local text;
	
	if( lIB_HealthRegen_sec and lIB_HealthRegen_avg ) then
		if( lIB_HealthRegen_avg < 0 ) then
			if( lIB_HealthRegen_sec == 1 ) then
				text = format(TEXT(IB_HEALTHREGEN_TOOLTIP_FORMAT),
					TEXT(IB_HEALTHREGEN_LOST),
					lIB_HealthRegen_sec, "",
					-lIB_HealthRegen_avg);
			else
				text = format(TEXT(IB_HEALTHREGEN_TOOLTIP_FORMAT),
					TEXT(IB_HEALTHREGEN_LOST),
					lIB_HealthRegen_sec, "s",
					-lIB_HealthRegen_avg);
			end
		else
			if( lIB_HealthRegen_sec == 1 ) then
				text = format(TEXT(IB_HEALTHREGEN_TOOLTIP_FORMAT),
					TEXT(IB_HEALTHREGEN_GAINED),
					lIB_HealthRegen_sec, "",
					lIB_HealthRegen_avg);
			else
				text = format(TEXT(IB_HEALTHREGEN_TOOLTIP_FORMAT),
					TEXT(IB_HEALTHREGEN_GAINED),
					lIB_HealthRegen_sec, "s",
					lIB_HealthRegen_avg);
			end
		end
	else
		text = IB_HEALTHREGEN_NODATA;
	end
	if( lIB_HealthRegen_inCombat ) then
		text = text.."\n Currently in combat";
	end
	
	return text;
end


-- ManaRegen -----------------------------------------------------------------

IB_MANAREGEN_TOOLTIP_FORMAT = "Average mana %s over the last %d second%s: %.1f / sec";
IB_MANAREGEN_GAINED = "gained";
IB_MANAREGEN_LOST = "lost";
IB_MANAREGEN_NODATA = "Collecting data...";

local lIB_ManaRegen_inCombat;
local lIB_ManaRegen_time;
local lIB_ManaRegen_samples = { };
local lIB_ManaRegen_avg;
local lIB_ManaRegen_sec;

local function IB_ManaRegen_Reset()
	local i;
	local v = UnitMana("player");
	lIB_ManaRegen_time = 0;
	for i = 0, 10 do
		lIB_ManaRegen_samples[i] = v;
	end
end

function IB_ManaRegen_OnLoad()
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	IB_ManaRegen_Reset();
end

function IB_ManaRegen_OnEvent()
	if( event == "PLAYER_REGEN_DISABLED" ) then
		lIB_ManaRegen_inCombat = 1;
	elseif( event == "PLAYER_REGEN_ENABLED" ) then
		lIB_ManaRegen_inCombat = nil;
	elseif( event == "PLAYER_ENTERING_WORLD") then
		local info = ManaBarColor[UnitPowerType("player")];
		IB_ManaRegenCenteredText:SetTextColor(info.r, info.g, info.b);
	end
	IB_ManaRegen_Reset();
end

function IB_ManaRegen_OnUpdate(elapsed)
	local last = math.floor(lIB_ManaRegen_time);
	local curr;
	
	curr = math.floor(lIB_ManaRegen_time + elapsed);
	
	if( last == 0 and curr > (last + 1) ) then
		return;
	end
	
	if( curr > last ) then
		local max;
		local index;
		local change = 0;
		local i;
		
		if( curr > 10 ) then
			max = 10;
			index = math.mod(curr + 1, 11);
		else
			max = curr;
			index = 0;
		end
		
		curr = math.mod(curr, 11);
		lIB_ManaRegen_samples[curr] = UnitMana("player");

		prior = lIB_ManaRegen_samples[index];
		for i = 1, max do
			index = math.mod(index + 1, 11);
			change = change + lIB_ManaRegen_samples[index] - prior;
			prior = lIB_ManaRegen_samples[index];
		end
		
		lIB_ManaRegen_sec = max;
		lIB_ManaRegen_avg = change / lIB_ManaRegen_sec;
		IB_ManaRegenCenteredText:SetText(format("%.1f", lIB_ManaRegen_avg));
	elseif( lIB_ManaRegen_time == 0 ) then
		lIB_ManaRegen_sec = nil;
		lIB_ManaRegen_avg = nil;
		IB_ManaRegenCenteredText:SetText("-----");
	end

	lIB_ManaRegen_time = lIB_ManaRegen_time + elapsed;
end

function IB_ManaRegen_Tooltip()
	local text;
	
	if( lIB_ManaRegen_sec and lIB_ManaRegen_avg ) then
		if( lIB_ManaRegen_avg < 0 ) then
			if( lIB_ManaRegen_sec == 1 ) then
				text = format(TEXT(IB_MANAREGEN_TOOLTIP_FORMAT),
					TEXT(IB_MANAREGEN_LOST),
					lIB_ManaRegen_sec, "",
					-lIB_ManaRegen_avg);
			else
				text = format(TEXT(IB_MANAREGEN_TOOLTIP_FORMAT),
					TEXT(IB_MANAREGEN_LOST),
					lIB_ManaRegen_sec, "s",
					-lIB_ManaRegen_avg);
			end
		else
			if( lIB_ManaRegen_sec == 1 ) then
				text = format(TEXT(IB_MANAREGEN_TOOLTIP_FORMAT),
					TEXT(IB_MANAREGEN_GAINED),
					lIB_ManaRegen_sec, "",
					lIB_ManaRegen_avg);
			else
				text = format(TEXT(IB_MANAREGEN_TOOLTIP_FORMAT),
					TEXT(IB_MANAREGEN_GAINED),
					lIB_ManaRegen_sec, "s",
					lIB_ManaRegen_avg);
			end
		end
	else
		text = IB_MANAREGEN_NODATA;
	end
	if( lIB_ManaRegen_inCombat ) then
		text = text.."\n Currently in combat";
	end
	
	return text;
end


-- Coords ---------------------------------------------------------------------

local lIB_Coords_zones;
local lIB_Coords_currentZoneText;

local function IB_Coords_LoadZoneData(continent, ...)
	local iItem;
	for iItem = 1, arg.n do
		lIB_Coords_zones[arg[iItem]] = { };
		lIB_Coords_zones[arg[iItem]].cont = continent;
		lIB_Coords_zones[arg[iItem]].zone = iItem;
	end
end

local function IB_Coords_LoadMapData(...)
	local iItem;
	for iItem = 1, arg.n do
		IB_Coords_LoadZoneData(iItem, GetMapZones(iItem));
	end
end

local function IB_Coords_GetLoc()
	local currZoneText = GetRealZoneText();
	local zoneData = lIB_Coords_zones[currZoneText];
	
	if( zoneData ) then
		local mapCont = GetCurrentMapContinent();
		local mapZone = GetCurrentMapZone();
		
		if( lIB_Coords_currentZoneText ~= currZoneText or mapCont ~= zoneData.cont or mapZone ~= zoneData.zone ) then
			SetMapZoom(zoneData.cont, zoneData.zone);
			lIB_Coords_currentZoneText = currZoneText;
		end
		
		return GetPlayerMapPosition("player");
	end
	
	return 0, 0;
end

function IB_Coords_OnLoad()
	lIB_Coords_zones = { };
	IB_Coords_LoadMapData(GetMapContinents());
end

function IB_Coords_OnUpdate(elapsed)
	if( not this.updateTimer ) then
		this.updateTimer = 0;
	else
		this.updateTimer = this.updateTimer - elapsed;
	end
	if( this.updateTimer <= 0 ) then
		local x, y = IB_Coords_GetLoc();
		
		if( not x or not y or (x == 0 and y == 0) ) then
			IB_CoordsCenteredText:SetText("??.?, ??.?");
		else
			IB_CoordsCenteredText:SetText(format("%.1f, %.1f", x * 100, y * 100));
		end
		this.updateTimer = 0.25;
	end
end

function IB_Coords_Tooltip()
	local x, y = IB_Coords_GetLoc();
	local zoneText = GetZoneText();
	local minimapZoneText = GetMinimapZoneText();
	local pvpType, factionName, isArena = GetZonePVPInfo();
	local text;
	
	text = zoneText;
	if( zoneText ~= minimapZoneText ) then
		text = text.." ["..minimapZoneText.."]";
	end
	if( not x or not y or (x == 0 and y == 0) ) then
		text = text.."\n  ??.?, ??.?";
	else
		text = text..format("\n  %.1f, %.1f", x * 100, y * 100);
	end
	if( pvpType == "friendly" ) then
		text = text.."\n  "..format(FACTION_CONTROLLED_TERRITORY, factionName);
	elseif( pvpType == "hostile" ) then
		text = text.."\n  "..format(FACTION_CONTROLLED_TERRITORY, factionName);
	elseif( pvpType == "contested" ) then
		text = text.."\n  "..CONTESTED_TERRITORY;
	end
	if ( isArena ) then
		text = text.."\n  "..FREE_FOR_ALL_TERRITORY;
	end
	
	return text;
end
