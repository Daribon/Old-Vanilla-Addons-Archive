--[[

	InfoBar: a customizable information window
		copyright 2005 by Telo

	- Provides the user the ability to select and customize the information they want displayed
	- Exposes hooks that allow additional plugins to be added to the InfoBar by other AddOns
	- Includes eight sample plugins

]]

--------------------------------------------------------------------------------------------------
-- Localizable strings (note that there are more localizable strings in the sample plugins, below)
--------------------------------------------------------------------------------------------------

INFOBAR_SETUP_TT = "Configure InfoBar:";
INFOBAR_SETUP_TT_DETAIL = "- Left-click to setup plugins\n- Right-click to set InfoBar options";

INFOBARCONFIG_TITLE = "InfoBar Plugin Setup";
INFOBARCONFIG_DISPLAY = "Display on InfoBar";
INFOBARCONFIG_TOOLTIP = "Add Info to Tooltip";
INFOBARCONFIG_OPTIONS_TT = "Click to display options for this plugin";
INFOBARCONFIG_MOVEDOWN_TT = "Click to move this plugin down in the list";
INFOBARCONFIG_MOVEUP_TT = "Click to move this plugin up in the list";
INFOBARCONFIG_DISPLAY_TT = "If checked, this plugin will be displayed in the InfoBar";
INFOBARCONFIG_TOOLTIP_TT = "If checked, this plugin's tooltip information will be displayed in the InfoBar's ? tooltip";

INFOBAROPTIONS_TITLE = "InfoBar Options";
INFOBAROPTIONS_WIDTHLABEL = "Plugins Per Row:";
INFOBAROPTIONS_ALIGNMENTLABEL = "Plugin Alignment:";
INFOBAROPTIONS_BACKGROUNDLABEL = "Background:";
INFOBAROPTIONS_VISUALSLABEL = "Other Visuals:";
INFOBAROPTIONS_TOOLTIPSLABEL = "Tooltips:";
INFOBAROPTIONS_WIDTH_TT = "This is the number of plugins that can be displayed per row of the InfoBar.  Set this to 1 if you want a purely vertical bar.  If set to *, there is no limit, resulting in a purely horizontal bar.";
INFOBAROPTIONS_BORDERS = "Always show plugin borders";
INFOBAROPTIONS_CONTROLS = "Always show the InfoBar controls";
INFOBAROPTIONS_POSITION = "Auto-position the InfoBar";
INFOBAROPTIONS_TOOLTIPS = "InfoBar tooltips at top of screen";
INFOBAROPTIONS_MOUSEOVER = "Show tooltip on ? mouseover";
INFOBAROPTIONS_BORDERS_TT = "If checked, plugin borders are always shown";
INFOBAROPTIONS_CONTROLS_TT = "If checked, the InfoBar tooltip and setup buttons are always shown";
INFOBAROPTIONS_POSITION_TT = "If checked, the InfoBar is auto-centered at the top of the screen on load and whenever you change the displayed state of a plugin or the order of the plugin list";
INFOBAROPTIONS_TOOLTIPS_TT = "If checked, InfoBar tooltips are positioned at the top center of the screen, regardless of where the bar is";
INFOBAROPTIONS_MOUSEOVER_TT = "If checked, displays the InfoBar tooltip when you mouseover the InfoBar's ? button, otherwise you need to click the ? button to show the tooltip";

INFOBAR_OPTIONS_BACKGROUND_ALWAYS = "Show always";
INFOBAR_OPTIONS_BACKGROUND_MOUSEOVER = "Show on mouseover";
INFOBAR_OPTIONS_BACKGROUND_CONTROLMOUSEOVER = "Show on mouseover if Ctrl is held";

INFOBAR_OPTIONS_ALIGNMENT_LEFT = "Plugins left aligned";
INFOBAR_OPTIONS_ALIGNMENT_CENTER = "Plugins center aligned";
INFOBAR_OPTIONS_ALIGNMENT_RIGHT = "Plugins right aligned";

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- hooked functions
local lOriginalCloseAllWindows;
local lOriginalUIDropDownMenu_JustifyText;

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

-- Constants
local INFOBAR_OPTIONS_BACKGROUND_LIST = {
	{ name = INFOBAR_OPTIONS_BACKGROUND_ALWAYS },
	{ name = INFOBAR_OPTIONS_BACKGROUND_MOUSEOVER },
	{ name = INFOBAR_OPTIONS_BACKGROUND_CONTROLMOUSEOVER },
};

local INFOBAR_BACKGROUND_ALWAYS = 1;
local INFOBAR_BACKGROUND_MOUSEOVER = 2;
local INFOBAR_BACKGROUND_CONTROLMOUSEOVER = 3;

local INFOBAR_OPTIONS_ALIGNMENT_LIST = {
	{ name = INFOBAR_OPTIONS_ALIGNMENT_LEFT },
	{ name = INFOBAR_OPTIONS_ALIGNMENT_CENTER },
	{ name = INFOBAR_OPTIONS_ALIGNMENT_RIGHT },
};

local INFOBAR_ALIGNMENT_LEFT = 1;
local INFOBAR_ALIGNMENT_CENTER = 2;
local INFOBAR_ALIGNMENT_RIGHT = 3;

--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

INFOBAR_VERSION = 110;

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
		GameTooltip:SetPoint("TOP", "UIParent", "TOP", 0, -(InfoBarFrame:GetHeight() + 20));
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
	local controlOverhead = 58;
	local rowSize = 0;
	local maxRowSize = 0;
	local iPlugin = 0;
	local index, value;

	if( not lPluginOrder ) then
		return 58;
	end

	for index = 1, lPluginOrder.onePastEnd - 1 do
		value = lPlugins[lPluginOrder[index]];
		if( value.visible ) then
			iPlugin = iPlugin + 1;
			if( InfoBarState.pluginsPerRow and iPlugin > InfoBarState.pluginsPerRow ) then
				iPlugin = 1;
				if( rowSize > maxRowSize ) then
					maxRowSize = rowSize;
				end
				rowSize = 0;
			end
			rowSize = rowSize + 6 + value.frame:GetWidth();
		end
	end

	if( rowSize > maxRowSize ) then
		maxRowSize = rowSize;
	end

	return maxRowSize + controlOverhead;
end

local function InfoBar_GetHeight()
	local cRows = 1;
	local iPlugin = 0;
	local index, value;

	if( not lPluginOrder ) then
		return 58;
	end

	for index = 1, lPluginOrder.onePastEnd - 1 do
		value = lPlugins[lPluginOrder[index]];
		if( value.visible ) then
			iPlugin = iPlugin + 1;
			if( InfoBarState.pluginsPerRow and iPlugin > InfoBarState.pluginsPerRow ) then
				iPlugin = 1;
				cRows = cRows + 1;
			end
		end
	end

	return 28 * cRows;
end

local function InfoBar_HandleWidgets()
	local index, value;

	InfoBarFrame:SetWidth(InfoBar_GetWidth());
	InfoBarFrame:SetHeight(InfoBar_GetHeight());
	if( InfoBar_GetWidth() == 58 or
		(InfoBar_MouseIsOver(InfoBarFrame) and
			(InfoBarState.background ~= INFOBAR_BACKGROUND_CONTROLMOUSEOVER or IsControlKeyDown())) ) then
		InfoBarBackdrop:Show();
		InfoBarExpand:Show();
		InfoBarTooltip:Show();
		for index, value in lPlugins do
			if( value.visible ) then
				getglobal(index.."Backdrop"):Show();
			end
		end
	else
		if( InfoBarState.background == INFOBAR_BACKGROUND_ALWAYS ) then
			InfoBarBackdrop:Show();
		else
			InfoBarBackdrop:Hide();
		end
		if( InfoBarState.controls ) then
			InfoBarExpand:Show();
			InfoBarTooltip:Show();
		else
			if( InfoBarState.background == INFOBAR_BACKGROUND_ALWAYS ) then
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
	lOriginalUIDropDownMenu_JustifyText = UIDropDownMenu_JustifyText;
	UIDropDownMenu_JustifyText = InfoBar_UIDropDownMenu_JustifyText;

	-- If the control key is down on load, reset the bar's position;
	-- this is provided so that the bar can be recovered if offscreen
	if( IsControlKeyDown() ) then
		lResetPosition = 1;
	end

	-- if( DEFAULT_CHAT_FRAME ) then
	--	DEFAULT_CHAT_FRAME:AddMessage("Telo's InfoBar AddOn loaded");
	-- end
	-- UIErrorsFrame:AddMessage("Telo's InfoBar AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
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
		if( not InfoBarState.background ) then
			InfoBarState.background = INFOBAR_BACKGROUND_MOUSEOVER;
		end
		if( not InfoBarState.alignment ) then
			InfoBarState.alignment = INFOBAR_ALIGNMENT_CENTER;
		end

		lServer = GetCVar("realmName");
		if( not InfoBarState.Servers[lServer] ) then
			InfoBarState.Servers[lServer] = { };
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

function InfoBar_UIDropDownMenu_JustifyText(justification, frame)
	lOriginalUIDropDownMenu_JustifyText(justification, frame);

	-- UIDropDownMenu_JustifyText moves the text field, but doesn't set justification on it
	if ( not frame ) then
		frame = this;
	end
	local text = getglobal(frame:GetName().."Text");
	if ( justification == "LEFT" ) then
		text:SetJustifyH("LEFT");
	elseif ( justification == "RIGHT" ) then
		text:SetJustifyH("RIGHT");
	elseif ( justification == "CENTER" ) then
		text:SetJustifyH("CENTER");
	end
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

		InfoBarConfigurationFrame.optionsFrame = nil;
		InfoBarConfigurationFrame.optionsState = nil;

		InfoBarConfigurationFrame:Show();
	else
		InfoBarOptions_Okay();
		InfoBarOptionsFrame:Hide();
	end
end

function InfoBarConfig_OptionsCancel()
	local frame = InfoBarConfigurationFrame.optionsFrame;

	if( frame ) then
		frame:Hide();

		InfoBarConfigurationFrame:Show();

		InfoBarConfigurationFrame.optionsFrame = nil;
		InfoBarConfigurationFrame.optionsState = nil;
	else
		InfoBarOptionsFrame:Hide();
	end
end

-- InfoBar options dialog
function InfoBarOptionsAlignmentDropDown_OnLoad()
	UIDropDownMenu_SetWidth(200);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", this);
end

function InfoBarOptionsAlignmentDropDown_Initialize()
	local info;
	for i = 1, getn(INFOBAR_OPTIONS_ALIGNMENT_LIST) do
		info = { };
		info.text = INFOBAR_OPTIONS_ALIGNMENT_LIST[i].name;
		info.func = InfoBarOptionsAlignmentDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function InfoBarOptionsAlignmentDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(InfoBarOptionsAlignmentDropDown, this:GetID());
end

function InfoBarOptionsBackgroundDropDown_OnLoad()
	UIDropDownMenu_SetWidth(200);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", this);
end

function InfoBarOptionsBackgroundDropDown_Initialize()
	local info;
	for i = 1, getn(INFOBAR_OPTIONS_BACKGROUND_LIST) do
		info = { };
		info.text = INFOBAR_OPTIONS_BACKGROUND_LIST[i].name;
		info.func = InfoBarOptionsBackgroundDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function InfoBarOptionsBackgroundDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(InfoBarOptionsBackgroundDropDown, this:GetID());
end

function InfoBarOptions_OnShow()
	if( InfoBarState.pluginsPerRow ) then
		InfoBarOptionsWidthEditBox:SetText(InfoBarState.pluginsPerRow);
	else
		InfoBarOptionsWidthEditBox:SetText("*");
	end

	UIDropDownMenu_Initialize(InfoBarOptionsAlignmentDropDown, InfoBarOptionsAlignmentDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(InfoBarOptionsAlignmentDropDown, InfoBarState.alignment);

	UIDropDownMenu_Initialize(InfoBarOptionsBackgroundDropDown, InfoBarOptionsBackgroundDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(InfoBarOptionsBackgroundDropDown, InfoBarState.background);

	if( InfoBarState.borders ) then
		InfoBarOptionsBordersCheckBox:SetChecked(1);
	else
		InfoBarOptionsBordersCheckBox:SetChecked(0);
	end

	if( InfoBarState.controls ) then
		InfoBarOptionsControlsCheckBox:SetChecked(1);
	else
		InfoBarOptionsControlsCheckBox:SetChecked(0);
	end

	if( InfoBarState.autoPosition ) then
		InfoBarOptionsPositionCheckBox:SetChecked(1);
	else
		InfoBarOptionsPositionCheckBox:SetChecked(0);
	end

	if( InfoBarState.tooltipAtTop ) then
		InfoBarOptionsTooltipsCheckBox:SetChecked(1);
	else
		InfoBarOptionsTooltipsCheckBox:SetChecked(0);
	end

	if( InfoBarState.mouseoverTooltip ) then
		InfoBarOptionsMouseoverCheckBox:SetChecked(1);
	else
		InfoBarOptionsMouseoverCheckBox:SetChecked(0);
	end
end

function InfoBarOptions_Okay()
	local needLayout;
	local orig = InfoBarState.pluginsPerRow;
	local text = InfoBarOptionsWidthEditBox:GetText();
	if( text == "*" ) then
		InfoBarState.pluginsPerRow = nil;
	elseif( string.find(text, "^[0-9]+$") ) then
		local count = text + 0;
		if( count > 0 ) then
			InfoBarState.pluginsPerRow = count;
		end
	end
	if( orig ~= InfoBarState.pluginsPerRow ) then
		needLayout = 1;
	end

	orig = InfoBarState.alignment;
	InfoBarState.alignment = UIDropDownMenu_GetSelectedID(InfoBarOptionsAlignmentDropDown);
	if( orig ~= InfoBarState.alignment ) then
		needLayout = 1;
	end
	InfoBarState.background = UIDropDownMenu_GetSelectedID(InfoBarOptionsBackgroundDropDown);

	InfoBarState.borders = InfoBarOptionsBordersCheckBox:GetChecked();
	InfoBarState.controls = InfoBarOptionsControlsCheckBox:GetChecked();
	InfoBarState.autoPosition = InfoBarOptionsPositionCheckBox:GetChecked();
	InfoBarState.tooltipAtTop = InfoBarOptionsTooltipsCheckBox:GetChecked();
	InfoBarState.mouseoverTooltip = InfoBarOptionsMouseoverCheckBox:GetChecked();

	if( needLayout ) then
		InfoBar_LayoutPlugins();
	end
end

-- Functions to show the configuration and options dialogs
function InfoBar_ShowConfig()
	InfoBarOptionsFrame:Hide();
	InfoBarConfigurationFrame:Show();
end

function InfoBar_ShowOptions()
	local frame = InfoBarConfigurationFrame.optionsFrame;

	if( frame ) then
		frame:Hide();

		InfoBarConfigurationFrame.optionsFrame = nil;
		InfoBarConfigurationFrame.optionsState = nil;
	end
	InfoBarConfigurationFrame:Hide();
	InfoBarOptionsFrame:Show();
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

function InfoBar_LayoutPlugins()
	local rowSize;
	local maxRowSize = 0;
	local iPlugin;
	local xPos;
	local iRow = 1;
	local rowSizes = { };
	local width;
	local index, value;

	-- First pass: figure out the widths of everything
	rowSize = 0;
	iPlugin = 0;
	iRow = 1;
	for index = 1, lPluginOrder.onePastEnd - 1 do
		value = lPlugins[lPluginOrder[index]];
		if( value.visible ) then
			iPlugin = iPlugin + 1;
			if( InfoBarState.pluginsPerRow and iPlugin > InfoBarState.pluginsPerRow ) then
				iPlugin = 1;
				if( rowSize > maxRowSize ) then
					maxRowSize = rowSize;
				end
				rowSizes[iRow] = rowSize;
				iRow = iRow + 1;
				rowSize = 0;
			end
			rowSize = rowSize + 6 + value.frame:GetWidth();
		end
	end

	rowSizes[iRow] = rowSize;
	if( rowSize > maxRowSize ) then
		maxRowSize = rowSize;
	end

	InfoBarFrame:SetWidth(58 + maxRowSize);
	InfoBarFrame:SetHeight(28 * iRow);

	-- Second pass: layout everything
	rowSize = 0;
	iPlugin = 0;
	iRow = 1;
	for index = 1, lPluginOrder.onePastEnd - 1 do
		value = lPlugins[lPluginOrder[index]];
		if( value.visible ) then
			iPlugin = iPlugin + 1;
			if( InfoBarState.pluginsPerRow and iPlugin > InfoBarState.pluginsPerRow ) then
				iPlugin = 1;
				iRow = iRow + 1;
				rowSize = 0;
			end

			width = value.frame:GetWidth();
			if( InfoBarState.alignment == INFOBAR_ALIGNMENT_LEFT ) then
				xPos = 6 + rowSize;
			elseif( InfoBarState.alignment == INFOBAR_ALIGNMENT_RIGHT ) then
				xPos = 6 + maxRowSize - rowSizes[iRow] + rowSize;
			else
				xPos = 6 + (maxRowSize - rowSizes[iRow]) / 2 + rowSize;
			end
			rowSize = rowSize + 6 + width;

			value.frame:Show();
			value.frame:ClearAllPoints();
			value.frame:SetPoint("TOPLEFT", "InfoBarFrame", "TOPLEFT", xPos, -6 - (28 * (iRow - 1)));
		else
			value.frame:Hide();
		end
	end

	if( InfoBarState.autoPosition ) then
		InfoBar_Center();
	end
end


--------------------------------------------------------------------------------------------------
-- Sample plugin functions
--------------------------------------------------------------------------------------------------

-- BagSpace -------------------------------------------------------------------

IB_BAGSPACE_OPTIONS_TITLE = "Bag Options";
IB_BAGSPACE_OPTIONS_STYLELABEL = "Display Style:";
IB_BAGSPACE_USEDTOTAL = "used / total";
IB_BAGSPACE_FREETOTAL = "free / total";

local IB_BAGSPACE_STYLE_FREETOTAL = 2;
local IB_BAGSPACE_STYLE_LIST =  {
	{ name = IB_BAGSPACE_USEDTOTAL },
	{ name = IB_BAGSPACE_FREETOTAL },
};

local lIB_BagSpace_state;

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
		if( i == 0 or GetInventoryItemCount("player", 19 + i) == 0 ) then
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
	end

	IB_BagSpaceBar:SetMinMaxValues(0, total);
	IB_BagSpaceBar:SetValue(used);
	if( lIB_BagSpace_state and lIB_BagSpace_state.style == IB_BAGSPACE_STYLE_FREETOTAL ) then
		IB_BagSpaceText:SetText((total - used).." / "..total);
	else
		IB_BagSpaceText:SetText(used.." / "..total);
	end
end

local function IB_BagSpace_StyleDropDown_Initialize()
	local info;
	for i = 1, getn(IB_BAGSPACE_STYLE_LIST) do
		info = { };
		info.text = IB_BAGSPACE_STYLE_LIST[i].name;
		info.func = IB_BagSpace_StyleDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function IB_BagSpace_StyleDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", this);
end

function IB_BagSpace_StyleDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(IB_BagSpace_StyleDropDown, this:GetID());
end

function IB_BagSpace_Load(state)
	lIB_BagSpace_state = state;

	if( not lIB_BagSpace_state.style ) then
		lIB_BagSpace_state.style = 1;
	end

	IB_BagSpace_OptionsTitle:SetText(TEXT(IB_BAGSPACE_OPTIONS_TITLE));

	UIDropDownMenu_Initialize(IB_BagSpace_StyleDropDown, IB_BagSpace_StyleDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(IB_BagSpace_StyleDropDown, lIB_BagSpace_state.style);
	UIDropDownMenu_SetText(IB_BAGSPACE_STYLE_LIST[lIB_BagSpace_state.style].name, IB_BagSpace_StyleDropDown);
end

function IB_BagSpace_Save(state)
	state.style = UIDropDownMenu_GetSelectedID(IB_BagSpace_StyleDropDown);
	IB_BagSpace_SetValues();
end

function IB_BagSpace_Restore(state)
	lIB_BagSpace_state = state;
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

function IB_Money_Reset()
	lIB_Money_initial = GetMoney();
	lIB_Money_time = 0;
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
EXP_THIS_SESSION = "Experience this session: %d";
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
			text = text.."\n\n"..format(TEXT(EXP_TO_LEVEL), xpToLevel, (xpToLevel / xpTotal) * 100);
			text = text.."\n"..format(TEXT(EXP_THIS_SESSION), lIB_Clock_sessionXP);
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

function IB_Clock_Reset()
	lIB_Clock_totalTimePlayed = floor(lIB_Clock_totalTimePlayed);
	lIB_Clock_levelTimePlayed = floor(lIB_Clock_levelTimePlayed);
	lIB_Clock_sessionTimePlayed = 0;
	lIB_Clock_initialXP = UnitXP("player");
	lIB_Clock_sessionXP = 0;
	lIB_Clock_rolloverXP = 0;
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

	if( zoneData and not WorldMapFrame:IsVisible() ) then
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


-- DPS -----------------------------------------------------------------------

IB_DPS_OPTIONS_TITLE = "DPS Options";
IB_DPS_OPTIONS_MEASURELABEL = "Measure DPS:";
IB_DPS_OPTIONS_PARTYLABEL = "Party Options:";
IB_DPS_OPTIONS_PARTYCHECK = "Display party DPS onscreen";

IB_DPS_CALCULATING = "Calculating...";
IB_DPS_TOOLTIP_NOPET_BASE = "Last damage per second: %.1f\nHighest damage per second: %.1f";
IB_DPS_TOOLTIP_PET_BASE = "Last damage per second: %.1f\nPet's last DPS: %.1f (%.1f%% of total)\nHighest sustained damage per second: %.1f\nPet's highest sustained DPS: %.1f (%.1f%% of total)";
IB_DPS_TOOLTIP_NOPET_HEAL = "\n\nLast healing per second: %.1f\nHighest sustained healing per second: %.1f";
IB_DPS_TOOLTIP_PET_HEAL = "\n\nLast healing per second: %.1f\nPet's last HPS: %.1f (%.1f%% of total)\nHighest sustained healing per second: %.1f\nPet's highest sustained HPS: %.1f (%.1f%% of total)";
IB_DPS_TOOLTIP_NOPET_TOTAL = "\n\nSession average damage per second: %.1f";
IB_DPS_TOOLTIP_PET_TOTAL = "\n\nSession average damage per second: %.1f\nPet's session average DPS: %.1f (%.1f%% of total)";
IB_DPS_TOOLTIP_NOPET_HEAL_TOTAL = "\nSession average healing per second: %.1f";
IB_DPS_TOOLTIP_PET_HEAL_TOTAL = "\nSession average healing per second: %.1f\nPet's average session HPS: %.1f (%.1f%% of total)";

IB_DPS_PERCOMBAT = "Per Combat";
IB_DPS_PERTARGET = "Per Target";

local lIB_DPS_MatchData = {
	-- Your damage or healing
	{ pattern = "Your (.+) hits (.+) for (%d+)", spell = 0, mob = 1, pts = 2 },
	{ pattern = "Your (.+) crits (.+) for (%d+)", spell = 0, mob = 1, pts = 2 },
	{ pattern = "You drain (%d+) (.+) from (.+)", mob = 2, pts = 0, stat = 1 },
	{ pattern = "Your (.+) causes (.+) (%d+) damage", spell = 0, mob = 1, pts = 2 },
	{ pattern = "You reflect (%d+) (.+) damage to (.+)", mob = 2, pts = 0, type = 1 },
	{ pattern = "(.+) suffer[s]? (%d+) (.+) damage from your (.+)", spell = 3, mob = 0, pts = 1, type = 2 },
	{ pattern = "Your (.+) heals (.+) for (%d+)", mob = 1, spell = 0, pts = 2, heal = 1 },
	{ pattern = "Your (.+) critically heals (.+) for (%d+)", mob = 1, spell = 0, pts = 2, heal = 1 },
	{ pattern = "(.+) gain[s]? (%d+) health from your (.+)", spell = 2, mob = 0, pts = 1, heal = 1 },
	{ pattern = "You hit (.+) for (%d+)", mob = 0, pts = 1 },
	{ pattern = "You crit (.+) for (%d+)", mob = 0, pts = 1 },

	-- Other damage or healing
	{ pattern = "(.+)'s (.+) hits (.+) for (%d+)", spell = 1, mob = 2, pts = 3, cause = 0 },
	{ pattern = "(.+)'s (.+) crits (.+) for (%d+)", spell = 1, mob = 2, pts = 3, cause = 0 },
	{ pattern = "(.+) drains (%d+) (.+) from (.+)", mob = 3, pts = 1, stat = 2, cause = 0 },
	{ pattern = "(.+)'s (.+) causes (.+) (%d+) damage", spell = 1, mob = 2, pts = 3, cause = 0 },
	{ pattern = "(.+) reflects (%d+) (.+) damage to (.+)", mob = 3, pts = 1, type = 2, cause = 0 },
	{ pattern = "(.+) suffer[s]? (%d+) (.+) damage from (.+)'s (.+)", spell = 4, mob = 0, pts = 1, type = 2, cause = 3 },
	{ pattern = "(.+)'s (.+) heals (.+) for (%d+)", mob = 2, spell = 1, pts = 3, cause = 0, heal = 1 },
	{ pattern = "(.+)'s (.+) critically heals (.+) for (%d+)", mob = 2, spell = 1, pts = 3, cause = 0, heal = 1 },
	{ pattern = "(.+) gain[s]? (%d+) health from (.+)'s (.+)", spell = 3, mob = 0, pts = 1, cause = 2, heal = 1 },
	{ pattern = "(.+) hits (.+) for (%d+)", mob = 1, pts = 2, cause = 0 },
	{ pattern = "(.+) crits (.+) for (%d+)", mob = 1, pts = 2, cause = 0 },
};

-- Do not localize the lIB_DPS_CombatEvents array
local lIB_DPS_CombatEvents = {
	--[[
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS",
	]]

	"CHAT_MSG_COMBAT_SELF_HITS",
	"CHAT_MSG_COMBAT_PET_HITS",
	"CHAT_MSG_COMBAT_PARTY_HITS",
	"CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS",
	"CHAT_MSG_SPELL_SELF_DAMAGE",
	"CHAT_MSG_SPELL_SELF_BUFF",
	"CHAT_MSG_SPELL_PET_DAMAGE",
	"CHAT_MSG_SPELL_PET_BUFF",
	"CHAT_MSG_SPELL_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PARTY_BUFF",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF",
	"CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS",
	"CHAT_MSG_SPELL_ITEM_ENCHANTMENTS",
	"CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE",
	"CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS",
};

local IB_DPS_MEASURE_PERTARGET = 2;
local IB_DPS_MEASURE_LIST = {
	{ name = IB_DPS_PERCOMBAT  },
	{ name = IB_DPS_PERTARGET },
};

local lIB_DPS_state;

local lIB_DPS_inCombat;
local lIB_DPS_timeStart;

local lIB_DPS_playerDamage = 0;
local lIB_DPS_petDamage = 0;
local lIB_DPS_playerHeal = 0;
local lIB_DPS_petHeal = 0;

local lIB_DPS_lastDPS = 0;
local lIB_DPS_lastPetDPS = 0;
local lIB_DPS_maxDPS = 0;
local lIB_DPS_maxPetDPS = 0;
local lIB_DPS_lastHPS = 0;
local lIB_DPS_lastPetHPS = 0;
local lIB_DPS_maxHPS = 0;
local lIB_DPS_maxPetHPS = 0;

local lIB_DPS_totalPlayerDamage = 0;
local lIB_DPS_totalPetDamage = 0;
local lIB_DPS_totalPlayerHeal = 0;
local lIB_DPS_totalPetHeal = 0;
local lIB_DPS_totalTime = 0;

local lIB_DPS_purgeTime;
local lIB_DPS_partyData = { };

local function IB_DPS_GetStats(elapsed)
	local dps, hps, petdps, pethps;

	if( not elapsed or elapsed == 0 ) then
		dps = 0;
		hps = 0;
		petdps = 0;
		pethps = 0;
	else
		dps = (lIB_DPS_playerDamage + lIB_DPS_petDamage) / elapsed;
		hps = (lIB_DPS_playerHeal + lIB_DPS_petHeal) / elapsed;
		petdps = lIB_DPS_petDamage / elapsed;
		pethps = lIB_DPS_petHeal / elapsed;
	end

	return dps, hps, petdps, pethps;
end

local function IB_DPS_UpdateStats(elapsed, dps, hps, petdps, pethps)
	lIB_DPS_lastDPS	= dps;
	lIB_DPS_lastPetDPS = petdps;
	lIB_DPS_lastHPS = hps;
	lIB_DPS_lastPetHPS = pethps;

	if( elapsed >= 10 ) then
		if( lIB_DPS_lastDPS > lIB_DPS_maxDPS ) then
			lIB_DPS_maxDPS = lIB_DPS_lastDPS;
		end
		if( lIB_DPS_lastPetDPS > lIB_DPS_maxPetDPS ) then
			lIB_DPS_maxPetDPS = lIB_DPS_lastPetDPS;
		end
		if( lIB_DPS_lastHPS > lIB_DPS_maxHPS ) then
			lIB_DPS_maxHPS = lIB_DPS_lastHPS;
		end
		if( lIB_DPS_lastPetHPS > lIB_DPS_maxPetHPS ) then
			lIB_DPS_maxPetHPS = lIB_DPS_lastPetHPS;
		end
	end
end

local function IB_DPS_EndCombat()
	local elapsed = GetTime() - lIB_DPS_timeStart;
	local dps, hps, petdps, pethps = IB_DPS_GetStats(elapsed);

	if( dps == 0 and hps == 0 and petdps == 0 and pethps == 0 ) then
		return;
	end

	IB_DPS_UpdateStats(elapsed, dps, hps, petdps, pethps);

	lIB_DPS_totalTime = lIB_DPS_totalTime + elapsed;
	lIB_DPS_totalPlayerDamage = lIB_DPS_totalPlayerDamage + lIB_DPS_playerDamage;
	lIB_DPS_totalPetDamage = lIB_DPS_totalPetDamage + lIB_DPS_petDamage;
	lIB_DPS_totalPlayerHeal = lIB_DPS_totalPlayerHeal + lIB_DPS_playerHeal;
	lIB_DPS_totalPetHeal = lIB_DPS_totalPetHeal + lIB_DPS_petHeal;

	lIB_DPS_playerDamage = 0;
	lIB_DPS_petDamage = 0;
	lIB_DPS_playerHeal = 0;
	lIB_DPS_petHeal = 0;
end

local function IB_DPS_Update()
	local text;
	local elapsed;
	local dps;
	local hps;

	if( lIB_DPS_timeStart ) then
		elapsed = GetTime() - lIB_DPS_timeStart;
	end

	if( not elapsed ) then
		dps = lIB_DPS_lastDPS;
		hps = lIB_DPS_lastHPS;
	elseif( elapsed < 1 ) then
		IB_DPSCenteredText:SetText(TEXT(IB_DPS_CALCULATING));
		return;
	else
		dps = (lIB_DPS_playerDamage + lIB_DPS_petDamage) / elapsed;
		hps = (lIB_DPS_playerHeal + lIB_DPS_petHeal) / elapsed;
	end

	if( hps > 0 ) then
		IB_DPSCenteredText:SetText(format("|cffff0000%.1f|r / |cff00ff00%.1f|r", dps, hps));
	else
		IB_DPSCenteredText:SetText(format("|cffff0000%.1f|r", dps));
	end
end

local function IB_DPS_UpdateParty(unit, name, now)
	if( not lIB_DPS_state or lIB_DPS_state.partyDPS ) then
		local elapsed;
		local dps;
		local hps;

		if( lIB_DPS_partyData[name].timeStart ) then
			elapsed = now - lIB_DPS_partyData[name].timeStart;
		else
			elapsed = lIB_DPS_partyData[name].elapsed;
		end

		if( not elapsed ) then
			dps = 0;
			hps = 0;
		elseif( elapsed < 1 ) then
			getglobal("IB_DPS_"..unit.."Current"):SetText(TEXT(IB_DPS_CALCULATING));
			return;
		else
			dps = lIB_DPS_partyData[name].damage / elapsed;
			hps = lIB_DPS_partyData[name].heal / elapsed;
		end

		if( hps > 0 ) then
			getglobal("IB_DPS_"..unit.."Current"):SetText(format("|cffff0000%.1f|r / |cff00ff00%.1f|r", dps, hps));
		else
			getglobal("IB_DPS_"..unit.."Current"):SetText(format("|cffff0000%.1f|r", dps));
		end

		if( lIB_DPS_partyData[name].totalTime > 0 ) then
			dps = lIB_DPS_partyData[name].totalDamage / lIB_DPS_partyData[name].totalTime;
			hps = lIB_DPS_partyData[name].totalHeal / lIB_DPS_partyData[name].totalTime;

			if( hps > 0 ) then
				getglobal("IB_DPS_"..unit.."Total"):SetText(format("|cffcf0000%.1f|r / |cff00cf00%.1f|r", dps, hps));
			else
				getglobal("IB_DPS_"..unit.."Total"):SetText(format("|cffcf0000%.1f|r", dps));
			end
		else
			getglobal("IB_DPS_"..unit.."Total"):SetText("");
		end
	else
		getglobal("IB_DPS_"..unit.."Current"):SetText("");
		getglobal("IB_DPS_"..unit.."Total"):SetText("");
	end
end

local function IB_DPS_ParseEvent(event)
	local index, value;

--	DEFAULT_CHAT_FRAME:AddMessage(event.." >> "..string.sub(arg1, 1, 40));

	for index, value in lIB_DPS_MatchData do
		local s, e;
		local results = { };
		s, e, results[0], results[1], results[2], results[3], results[4] = string.find(arg1, value.pattern);
		if( results[value.mob] ) then
			-- Only count heals done in combat; we allow damage because it starts combat
			if( value.heal and not lIB_DPS_inCombat ) then
				return;
			end

			if( value.cause ) then
				if( not results[value.cause] ) then
					return;
				end

				local cause = results[value.cause];

				if( cause == UnitName("pet") or string.lower(cause) == "your pet" ) then
					if( value.heal ) then
						lIB_DPS_petHeal = lIB_DPS_petHeal + results[value.pts];
					else
						lIB_DPS_petDamage = lIB_DPS_petDamage + results[value.pts];
					end
				else
					if( lIB_DPS_partyData[cause] ) then
						if( value.heal ) then
							lIB_DPS_partyData[cause].heal = lIB_DPS_partyData[cause].heal + results[value.pts];
						else
							lIB_DPS_partyData[cause].damage = lIB_DPS_partyData[cause].damage + results[value.pts];
						end
					end
				end
			else
				if( value.heal ) then
					lIB_DPS_playerHeal = lIB_DPS_playerHeal + results[value.pts];
				else
					lIB_DPS_playerDamage = lIB_DPS_playerDamage + results[value.pts];
				end
			end

			IB_DPS_Update();

			-- Matched one pattern, don't bother checking others
			return;
		end
	end
end

function IB_DPS_OnLoad()
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");

	local index, value;
	for index, value in lIB_DPS_CombatEvents do
		this:RegisterEvent(value);
	end

	local iMember;
	local cMembers = GetNumPartyMembers();

	for iMember = 1, cMembers do
		local name = UnitName("party"..iMember);
		lIB_DPS_partyData[name] = { damage = 0, heal = 0, totalDamage = 0, totalHeal = 0, totalTime = 0 };
	end
end

function IB_DPS_OnEvent()
	if( event == "PLAYER_TARGET_CHANGED" ) then
		if( lIB_DPS_inCombat and lIB_DPS_state and lIB_DPS_state.measure == IB_DPS_MEASURE_PERTARGET ) then
			IB_DPS_EndCombat();
			if( UnitCanAttack("player", "target") ) then
				lIB_DPS_timeStart = GetTime();
			else
				lIB_DPS_timeStart = nil;
				lIB_DPS_inCombat = nil;
			end
		end
	elseif( event == "PARTY_MEMBERS_CHANGED" ) then
		local iMember;
		local cMembers = GetNumPartyMembers();
		local name;

		for iMember = 1, cMembers do
			name = UnitName("party"..iMember);
			if( name ) then
				if( not lIB_DPS_partyData[name] ) then
					lIB_DPS_partyData[name] = { damage = 0, heal = 0, totalDamage = 0, totalHeal = 0, totalTime = 0 };
				end
				-- Mark this person as part of a recent party
				lIB_DPS_partyData[name]._ = 1;
			end
		end

		-- Schedule a purge of old data to happen five minutes from now; this is necessary because of how
		-- PARTY_MEMBERS_CHANGED events work.  If you have two additional people in your party and remove
		-- one, you'll get two PARTY_MEMBERS_CHANGED events: one for zero members, then one for the
		-- member that you didn't remove.  Obviously, purging people in response to the first event is
		-- going to lose all of the data for the person that you kept.  This also has the advantage of
		-- allowing you to add back in the removed person within the next five minutes and keep their data.
		lIB_DPS_purgeTime = GetTime() + 300;
	else
		IB_DPS_ParseEvent(event);
	end
end

function IB_DPS_OnUpdate(elapsed)
	local now = GetTime();

	-- Catch combat transitions every frame
	if( not lIB_DPS_inCombat ) then
		if( UnitAffectingCombat("player") and UnitCanAttack("player", "target") ) then
			lIB_DPS_inCombat = 1;
			lIB_DPS_timeStart = now;
		end
	else
		if( not UnitAffectingCombat("player") ) then
			IB_DPS_EndCombat();
			lIB_DPS_timeStart = nil;
			lIB_DPS_inCombat = nil;
		end
	end

	-- Perform relatively frequent updates of our DPS and party members' DPS
	if( not this.updateTimer ) then
		this.updateTimer = 0;
	else
		this.updateTimer = this.updateTimer - elapsed;
	end
	if( this.updateTimer <= 0 ) then
		local iMember;
		local cMembers = GetNumPartyMembers();

		for iMember = 1, cMembers do
			local unit = "party"..iMember;
			local name = UnitName(unit);

			if( name ) then
				-- If there's a timing issue in between PARTY_MEMBERS_CHANGED events...
				if( not lIB_DPS_partyData[name] ) then
					lIB_DPS_partyData[name] = { damage = 0, heal = 0, totalDamage = 0, totalHeal = 0, totalTime = 0, _ = 1 };
				end

				if( not lIB_DPS_partyData[name].inCombat ) then
					if( UnitAffectingCombat(unit) ) then
						lIB_DPS_partyData[name].damage = 0;
						lIB_DPS_partyData[name].heal = 0;
						lIB_DPS_partyData[name].elapsed = nil;
						lIB_DPS_partyData[name].inCombat = 1;
						lIB_DPS_partyData[name].timeStart = now;
					end
				else
					if( not UnitAffectingCombat(unit) ) then
						lIB_DPS_partyData[name].elapsed = now - lIB_DPS_partyData[name].timeStart;
						lIB_DPS_partyData[name].totalDamage = lIB_DPS_partyData[name].totalDamage + lIB_DPS_partyData[name].damage;
						lIB_DPS_partyData[name].totalHeal = lIB_DPS_partyData[name].totalHeal + lIB_DPS_partyData[name].heal;
						lIB_DPS_partyData[name].totalTime = lIB_DPS_partyData[name].totalTime + lIB_DPS_partyData[name].elapsed;
						lIB_DPS_partyData[name].inCombat = nil;
						lIB_DPS_partyData[name].timeStart = nil;
					end
				end

				IB_DPS_UpdateParty(unit, name, now);
			end
		end

		IB_DPS_Update();
		this.updateTimer = 0.25;
	end

	-- Purge old party data if necessary
	if( lIB_DPS_purgeTime and now >= lIB_DPS_purgeTime ) then
		local index, value;
		for index, value in lIB_DPS_partyData do
			if( not value._ ) then
				lIB_DPS_partyData[index] = nil;
			else
				value._ = nil;
			end
		end
		lIB_DPS_purgeTime = nil;
	end
end

function IB_DPS_Tooltip()
	local text;

	if( lIB_DPS_lastPetDPS > 0 ) then
		text = format(TEXT(IB_DPS_TOOLTIP_PET_BASE),
			lIB_DPS_lastDPS, lIB_DPS_lastPetDPS, (lIB_DPS_lastPetDPS / lIB_DPS_lastDPS) * 100,
			lIB_DPS_maxDPS, lIB_DPS_maxPetDPS, (lIB_DPS_maxPetDPS / lIB_DPS_maxDPS) * 100);
	else
		text = format(TEXT(IB_DPS_TOOLTIP_NOPET_BASE), lIB_DPS_lastDPS, lIB_DPS_maxDPS);
	end

	if( lIB_DPS_lastHPS > 0 or lIB_DPS_maxHPS > 0 ) then
		if( lIB_DPS_lastPetHPS > 0 or lIB_DPS_maxPetHPS > 0 ) then
			text = text..format(TEXT(IB_DPS_TOOLTIP_PET_HEAL),
				lIB_DPS_lastHPS, lIB_DPS_lastPetHPS, (lIB_DPS_lastPetHPS / lIB_DPS_lastHPS) * 100,
				lIB_DPS_maxHPS, lIB_DPS_maxPetHPS, (lIB_DPS_maxPetHPS / lIB_DPS_maxHPS) * 100);
		else
			text = text..format(TEXT(IB_DPS_TOOLTIP_NOPET_HEAL), lIB_DPS_lastHPS, lIB_DPS_maxHPS);
		end
	end

	if( lIB_DPS_totalTime > 0 ) then
		local totalDPS = (lIB_DPS_totalPlayerDamage + lIB_DPS_totalPetDamage) / lIB_DPS_totalTime;
		local totalPetDPS = lIB_DPS_totalPetDamage / lIB_DPS_totalTime;
		local totalHPS = (lIB_DPS_totalPlayerHeal + lIB_DPS_totalPetHeal) / lIB_DPS_totalTime;
		local totalPetHPS = lIB_DPS_totalPetHeal / lIB_DPS_totalTime;

		if( totalPetDPS > 0 ) then
			text = text..format(TEXT(IB_DPS_TOOLTIP_PET_TOTAL),
				totalDPS, totalPetDPS, (totalPetDPS / totalDPS) * 100);
		else
			text = text..format(TEXT(IB_DPS_TOOLTIP_NOPET_TOTAL), totalDPS);
		end

		if( totalHPS > 0 ) then
			if( totalPetHPS > 0 ) then
				text = text..format(TEXT(IB_DPS_TOOLTIP_PET_HEAL_TOTAL),
					totalHPS, totalPetHPS, (totalPetHPS / totalHPS) * 100);
			else
				text = text..format(TEXT(IB_DPS_TOOLTIP_NOPET_HEAL_TOTAL), totalHPS);
			end
		end
	end

	return text;
end

function IB_DPS_Reset()
	lIB_DPS_lastDPS = 0;
	lIB_DPS_lastPetDPS = 0;
	lIB_DPS_maxDPS = 0;
	lIB_DPS_maxPetDPS = 0;
	lIB_DPS_lastHPS = 0;
	lIB_DPS_lastPetHPS = 0;
	lIB_DPS_maxHPS = 0;
	lIB_DPS_maxPetHPS = 0;

	lIB_DPS_totalPlayerDamage = 0;
	lIB_DPS_totalPetDamage = 0;
	lIB_DPS_totalPlayerHeal = 0;
	lIB_DPS_totalPetHeal = 0;
	lIB_DPS_totalTime = 0;

	local index, value;
	for index, value in lIB_DPS_partyData do
		lIB_DPS_partyData[index] = { damage = 0, heal = 0, totalDamage = 0, totalHeal = 0, totalTime = 0 };
	end
end

local function IB_DPS_MeasureDropDown_Initialize()
	local info;
	for i = 1, getn(IB_DPS_MEASURE_LIST) do
		info = { };
		info.text = IB_DPS_MEASURE_LIST[i].name;
		info.func = IB_DPS_MeasureDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function IB_DPS_MeasureDropDown_OnLoad()
	UIDropDownMenu_SetWidth(90);
	UIDropDownMenu_SetButtonWidth(24);
	UIDropDownMenu_JustifyText("LEFT", this);
end

function IB_DPS_MeasureDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(IB_DPS_MeasureDropDown, this:GetID());
end

function IB_DPS_Load(state)
	lIB_DPS_state = state;

	if( not lIB_DPS_state.measure ) then
		lIB_DPS_state.measure = 1;
	end

	IB_DPS_OptionsTitle:SetText(TEXT(IB_DPS_OPTIONS_TITLE));

	UIDropDownMenu_Initialize(IB_DPS_MeasureDropDown, IB_DPS_MeasureDropDown_Initialize);
	UIDropDownMenu_SetSelectedID(IB_DPS_MeasureDropDown, lIB_DPS_state.measure);
	UIDropDownMenu_SetText(IB_DPS_MEASURE_LIST[lIB_DPS_state.measure].name, IB_DPS_MeasureDropDown);

	if( lIB_DPS_state.partyDPS ) then
		IB_DPS_PartyCheckBox:SetChecked(1);
	else
		IB_DPS_PartyCheckBox:SetChecked(0);
	end
end

function IB_DPS_Save(state)
	state.measure = UIDropDownMenu_GetSelectedID(IB_DPS_MeasureDropDown);
	state.partyDPS = IB_DPS_PartyCheckBox:GetChecked();
end

function IB_DPS_Restore(state)
	lIB_DPS_state = state;
end