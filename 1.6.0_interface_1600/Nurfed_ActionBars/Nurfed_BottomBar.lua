--[[

	BottomBar: Adds one twelve button bars to the bottom of the screen
		copyright 2004 by Telo

	- There are hotkey bindings for each of the added buttons

]]

--------------------------------------------------------------------------------------------------
-- Localizable strings
--------------------------------------------------------------------------------------------------

BINDING_HEADER_BOTTOMBAR = "BottomBar Buttons";
BINDING_NAME_BOTTOMACTIONBUTTON1 = "BottomBar Button 1";
BINDING_NAME_BOTTOMACTIONBUTTON2 = "BottomBar Button 2";
BINDING_NAME_BOTTOMACTIONBUTTON3 = "BottomBar Button 3";
BINDING_NAME_BOTTOMACTIONBUTTON4 = "BottomBar Button 4";
BINDING_NAME_BOTTOMACTIONBUTTON5 = "BottomBar Button 5";
BINDING_NAME_BOTTOMACTIONBUTTON6 = "BottomBar Button 6";
BINDING_NAME_BOTTOMACTIONBUTTON7 = "BottomBar Button 7";
BINDING_NAME_BOTTOMACTIONBUTTON8 = "BottomBar Button 8";
BINDING_NAME_BOTTOMACTIONBUTTON9 = "BottomBar Button 9";
BINDING_NAME_BOTTOMACTIONBUTTON10 = "BottomBar Button 10";
BINDING_NAME_BOTTOMACTIONBUTTON11 = "BottomBar Button 11";
BINDING_NAME_BOTTOMACTIONBUTTON12 = "BottomBar Button 12";

BOTTOMBAR_HELP = "help";				-- must be lowercase; displays help
BOTTOMBAR_STATUS = "status";			-- must be lowercase; shows status
BOTTOMBAR_HIDE_LABELS = "hidelabels";	-- must be lowercase; hides hotkey labels
BOTTOMBAR_SHOW_LABELS = "showlabels";	-- must be lowercase; shows hotkey labels
BOTTOMBAR_HIDE_GRID = "hidegrid";		-- must be lowercase; hides the grid of empty buttons
BOTTOMBAR_SHOW_GRID = "showgrid";		-- must be lowercase; shows the grid of empty buttons

BOTTOMBAR_STATUS_HEADER = "|cffffff00BottomBar status:|r";
BOTTOMBAR_ENDCAPS_HIDDEN = "BottomBar: endcap art hidden";
BOTTOMBAR_ENDCAPS_SHOWN = "BottomBar: endcap art shown";
BOTTOMBAR_LOCKED = "BottomBar: buttons locked";
BOTTOMBAR_UNLOCKED = "BottomBar: buttons unlocked";
BOTTOMBAR_LABELS_HIDDEN = "BottomBar: hotkey labels hidden";
BOTTOMBAR_LABELS_SHOWN = "BottomBar: hotkey labels shown";
BOTTOMBAR_GRID_HIDDEN = "BottomBar: grid hidden";
BOTTOMBAR_GRID_SHOWN = "BottomBar: grid shown";

BOTTOMBAR_HELP_TEXT0 = " ";
BOTTOMBAR_HELP_TEXT1 = "|cffffff00BottomBar command help:|r";
BOTTOMBAR_HELP_TEXT2 = "|cff00ff00Use |r|cffffffff/bottombar <command>|r|cff00ff00 or |r|cffffffff/bb <command>|r|cff00ff00 to perform the following commands:|r";
BOTTOMBAR_HELP_TEXT3 = "|cffffffff"..BOTTOMBAR_HELP.."|r|cff00ff00: displays this message.|r";
BOTTOMBAR_HELP_TEXT4 = "|cffffffff"..BOTTOMBAR_STATUS.."|r|cff00ff00: displays status information about the current option settings.|r";
BOTTOMBAR_HELP_TEXT9 = "|cffffffff"..BOTTOMBAR_HIDE_LABELS.."|r|cff00ff00: hides the keyboard shortcut labels from the buttons.|r";
BOTTOMBAR_HELP_TEXT10 = "|cffffffff"..BOTTOMBAR_SHOW_LABELS.."|r|cff00ff00: shows the keyboard shortcut labels on the buttons.|r";
BOTTOMBAR_HELP_TEXT11 = "|cffffffff"..BOTTOMBAR_HIDE_GRID.."|r|cff00ff00: hides the grid of empty buttons, except when dragging.|r";
BOTTOMBAR_HELP_TEXT12 = "|cffffffff"..BOTTOMBAR_SHOW_GRID.."|r|cff00ff00: shows the grid of empty buttons always.|r";
BOTTOMBAR_HELP_TEXT13 = " ";
BOTTOMBAR_HELP_TEXT14 = "|cff00ff00For example: |r|cffffffff/bottombar hidecaps|r|cff00ff00 will turn off the eagle interface art from the main bar.|r";

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local lOriginal_updateContainerFrameAnchors;
local lOriginal_ShapeshiftBar_Update;
local lOriginal_PetActionBarFrame_OnUpdate;
local lOriginal_ShowPetActionBar;
local lOriginal_HidePetActionBar;
local lOriginal_FCF_UpdateDockPosition;
local lOriginal_FCF_Set_SimpleChat;
local lOriginal_SetItemRef;
local lOriginal_PetActionBar_UpdatePosition;
local lOriginal_ShapeshiftBar_UpdatePosition;
local lOriginal_CastingBarFrame_UpdatePosition;
local lOriginal_UIParent_ManageRightSideFrames;

local lOriginal_ActionButton_UpdateHotkeys;

--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

-- A few globals
BOTTOMBAR_OFFSET_Y = 36;
BOTTOMBAR_PETFIX_Y = 15;

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function BottomBar_SetState()
	if( Nurfed_BottomBarState ) then
		local iButton;
		local label;
		local button;
		for iButton = 1, 12 do
			label = getglobal("BottomBarButton"..iButton.."HotKey");
			if( Nurfed_BottomBarState.HideLabels ) then
				label:Hide();
			else
				label:Show();
			end
			button = getglobal("BottomBarButton"..iButton);
			if( not HasAction(BottomBarButton_GetID(button)) ) then
				button:Hide();
			else
				button:Show();
			end
		end
	end
end

local function BottomBar_Status()
	DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_STATUS_HEADER);
	if( Nurfed_BottomBarState ) then
		if( Nurfed_BottomBarState.HideEndCaps ) then
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_ENDCAPS_HIDDEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_ENDCAPS_SHOWN);
		end
		if( Nurfed_BottomBarState.Lock ) then
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_LOCKED);
		else
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_UNLOCKED);
		end
		if( Nurfed_BottomBarState.HideLabels ) then
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_LABELS_HIDDEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_LABELS_SHOWN);
		end
		if( Nurfed_BottomBarState.HideGrid ) then
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_GRID_HIDDEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_GRID_SHOWN);
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_ENDCAPS_SHOWN);
		DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_UNLOCKED);
		DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_LABELS_SHOWN);
		DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_GRID_SHOWN);
	end
end

function BottomBar_SlashCommandHandler(msg)
	if( msg ) then
		local command = string.lower(msg);
		if( command == "" or command == BOTTOMBAR_HELP ) then
			local index = 0;
			local value = getglobal("BOTTOMBAR_HELP_TEXT"..index);
			while( value ) do
				DEFAULT_CHAT_FRAME:AddMessage(value);
				index = index + 1;
				value = getglobal("BOTTOMBAR_HELP_TEXT"..index);
			end
		elseif( command == BOTTOMBAR_STATUS ) then
			BottomBar_Status();
		elseif( command == BOTTOMBAR_HIDE_LABELS ) then
			Nurfed_BottomBarState.HideLabels = 1;
			BottomBar_SetState();
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_LABELS_HIDDEN);
		elseif( command == BOTTOMBAR_SHOW_LABELS ) then
			Nurfed_BottomBarState.HideLabels = nil;
			BottomBar_SetState();
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_LABELS_SHOWN);
		elseif( command == BOTTOMBAR_HIDE_GRID ) then
			Nurfed_BottomBarState.HideGrid = 1;
			BottomBar_SetState();
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_GRID_HIDDEN);
		elseif( command == BOTTOMBAR_SHOW_GRID ) then
			Nurfed_BottomBarState.HideGrid = nil;
			BottomBar_SetState();
			DEFAULT_CHAT_FRAME:AddMessage(BOTTOMBAR_GRID_SHOWN);
		end
	end
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function BottomBar_OnLoad()
	RegisterForSave("Nurfed_BottomBarState");
	
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register our slash command
	SLASH_BOTTOMBAR1 = "/bottombar";
	SLASH_BOTTOMBAR2 = "/bb";
	SlashCmdList["BOTTOMBAR"] = function(msg)
		BottomBar_SlashCommandHandler(msg);
	end
	
	-- Hook updateContainerFrameAnchors
	lOriginal_updateContainerFrameAnchors = updateContainerFrameAnchors;
	updateContainerFrameAnchors = BottomBar_updateContainerFrameAnchors;
	
	-- Hook ShapeshiftBar_Update
	lOriginal_ShapeshiftBar_Update = ShapeshiftBar_Update;
	ShapeshiftBar_Update = BottomBar_ShapeshiftBar_Update;
	
	-- Hook PetActionBarFrame_OnUpdate, ShowPetActionBar and HidePetActionBar
	lOriginal_PetActionBarFrame_OnUpdate = PetActionBarFrame_OnUpdate;
	PetActionBarFrame_OnUpdate = BottomBar_PetActionBarFrame_OnUpdate;
	lOriginal_ShowPetActionBar = ShowPetActionBar;
	ShowPetActionBar = BottomBar_ShowPetActionBar;
	lOriginal_HidePetActionBar = HidePetActionBar;
	HidePetActionBar = BottomBar_HidePetActionBar;
	
	-- Hook things that now move due to MultiBarBottomLeft
	lOriginal_PetActionBar_UpdatePosition = PetActionBar_UpdatePosition;
	PetActionBar_UpdatePosition = BottomBar_PetActionBar_UpdatePosition;
	lOriginal_ShapeshiftBar_UpdatePosition = ShapeshiftBar_UpdatePosition;
	ShapeshiftBar_UpdatePosition = BottomBar_ShapeshiftBar_UpdatePosition;
	lOriginal_CastingBarFrame_UpdatePosition = CastingBarFrame_UpdatePosition;
	CastingBarFrame_UpdatePosition = BottomBar_CastingBarFrame_UpdatePosition;
	lOriginal_UIParent_ManageRightSideFrames = UIParent_ManageRightSideFrames;
	UIParent_ManageRightSideFrames = BottomBar_UIParent_ManageRightSideFrames;
	
	-- Hook FCF_UpdateDockPosition and FCF_Set_SimpleChat
	lOriginal_FCF_UpdateDockPosition = FCF_UpdateDockPosition;
	FCF_UpdateDockPosition = BottomBar_FCF_UpdateDockPosition;
	lOriginal_FCF_Set_SimpleChat = FCF_Set_SimpleChat;
	FCF_Set_SimpleChat = BottomBar_FCF_Set_SimpleChat;
	
	-- Hook SetItemRef
	lOriginal_SetItemRef = SetItemRef;
	SetItemRef = BottomBar_SetItemRef;

	lOriginal_ActionButton_UpdateHotkeys = ActionButton_UpdateHotkeys;
	ActionButton_UpdateHotkeys = BottomBar_ActionButton_UpdateHotkeys;

	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("Telo's BottomBar AddOn loaded");
	end
	UIErrorsFrame:AddMessage("Telo's BottomBar AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function BottomBar_ActionButton_UpdateHotkeys(actionButtonType)

	if ( not actionButtonType ) then
		actionButtonType = "ACTIONBUTTON";
	end
	local hotkey = getglobal(this:GetName().."HotKey");
	local action = actionButtonType..this:GetID();
	if ( action ) then
		hotkey:SetText(KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_"));
	else

		local name = this:GetName();
		local hotkey = getglobal(name.."HotKey");
		local s, e, id = string.find(name, "^BottomBarButton(%d+)$");
		local action = "BOTTOMACTIONBUTTON"..id;
		local text = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
	
		text = string.gsub(text, "CTRL%-", "C-");
		text = string.gsub(text, "ALT%-", "A-");
		text = string.gsub(text, "SHIFT%-", "S-");
		text = string.gsub(text, "Num Pad", "NP");
		text = string.gsub(text, "Backspace", "Bksp");
		text = string.gsub(text, "Spacebar", "Space");
		text = string.gsub(text, "Page", "Pg");
		text = string.gsub(text, "Down", "Dn");
		text = string.gsub(text, "Arrow", "");
		text = string.gsub(text, "Insert", "Ins");
		text = string.gsub(text, "Delete", "Del");
	
		hotkey:SetText(text);
	end
end

function BottomBar_OnShow()
	-- Move the ShapeshiftBarFrame
	--ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", this:GetName(), "TOPLEFT", 30, -3);
	
	-- Move the CastingBarFrame
	--[[
	if( PetHasActionBar() ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 100 + BOTTOMBAR_OFFSET_Y);
	elseif( GetNumShapeshiftForms() > 0 ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83 + BOTTOMBAR_OFFSET_Y);
	else
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60 + BOTTOMBAR_OFFSET_Y);
	end
]]
	BottomBar_SetState();
end

function BottomBar_OnHide()
	-- Move the ShapeshiftBarFrame
	--[[
	if( Nurfed_ActionBars.HotBar == 1 ) then
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, -9);
	else
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
	end
	
	-- Move the CastingBarFrame
	if( PetHasActionBar() ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 100);
	elseif( GetNumShapeshiftForms() > 0 ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83);
	else
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60);
	end
]]
	BottomBar_SetState();
end

function BottomBar_OnEvent()
	if( event == "VARIABLES_LOADED" ) then
		if( not Nurfed_BottomBarState ) then
			Nurfed_BottomBarState = { };
		else
			BottomBar_SetState();
		end
	end
end

function BottomBar_GameTooltip_SetPoint()
	-- Intentionally empty -- don't touch my tooltips!!
end

function BottomBar_updateContainerFrameAnchors()
	-- Don't move my tooltips!!
	local lOriginal_GameTooltip_SetPoint = GameTooltip.SetPoint;
	GameTooltip.SetPoint = BottomBar_GameTooltip_SetPoint;
	lOriginal_updateContainerFrameAnchors();
	GameTooltip.SetPoint = lOriginal_GameTooltip_SetPoint;

	-- Move the player's bags off of the bar
	local iBag = 1;
	local lastRight;
	local iColumn = 0;
	while ContainerFrame1.bags[iBag] do
		local frame = getglobal(ContainerFrame1.bags[iBag]);
		local bottom = string.format("%d", frame:GetBottom() + 0.5) + 0;
		local right = string.format("%d", frame:GetRight() + 0.5) + 0;

		right = right - GetScreenWidth();
		bottom = bottom + BOTTOMBAR_OFFSET_Y;

		if( not lastRight or right ~= lastRight ) then
			lastRight = right;
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", right, bottom);
			iColumn = iColumn + 1;
		end
		
		iBag = iBag + 1;
	end
end

function BottomBar_ShapeshiftBar_Update()
	lOriginal_ShapeshiftBar_Update();
--[[
	if( GetNumShapeshiftForms() > 0 ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 83 + BOTTOMBAR_OFFSET_Y);
	elseif( not PetHasActionBar() ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60 + BOTTOMBAR_OFFSET_Y);
	end
]]
end

function BottomBar_PetActionBarFrame_OnUpdate(elapsed)
	-- Replace the original function; it's no longer called

	local yPos;
	if ( this.slideTimer and (this.slideTimer < this.timeToSlide) ) then
		this.completed = nil;
		if ( this.mode == "show" ) then
			yPos = (this.slideTimer/this.timeToSlide) * this.yTarget;
			this:SetPoint("TOPLEFT", "BottomBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, yPos - BOTTOMBAR_PETFIX_Y);
			this.state = "showing";
			this:Show();
		elseif ( this.mode == "hide" ) then
			yPos = (1 - (this.slideTimer/this.timeToSlide)) * this.yTarget;
			this:SetPoint("TOPLEFT", "BottomBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, yPos - BOTTOMBAR_PETFIX_Y);
			this.state = "hiding";
		end
		this.slideTimer = this.slideTimer + elapsed;
	else
		this.completed = 1;
		if ( this.mode == "show" ) then
			this:SetPoint("TOPLEFT", "BottomBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, this.yTarget - BOTTOMBAR_PETFIX_Y);
			this.state = "top";
		elseif ( this.mode == "hide" ) then
			this:SetPoint("TOPLEFT", "BottomBar", "BOTTOMLEFT", PETACTIONBAR_XPOS, 0 - BOTTOMBAR_PETFIX_Y);
			this.state = "bottom";
			this:Hide();
		end
		this.mode = "none";
	end
end

function BottomBar_ShowPetActionBar()
	lOriginal_ShowPetActionBar();
	
	--CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 100 + BOTTOMBAR_OFFSET_Y);
end

function BottomBar_HidePetActionBar()
	lOriginal_HidePetActionBar();
--[[
	if( GetNumShapeshiftForms() == 0 ) then
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 60 + BOTTOMBAR_OFFSET_Y);
	end
]]
end

-- MultiBar repositioning; these also reset things to their default position if the bottom
-- left multibar isn't visible, which is not something we want happening
function BottomBar_PetActionBar_UpdatePosition()
end

function BottomBar_ShapeshiftBar_UpdatePosition()
end

function BottomBar_CastingBarFrame_UpdatePosition()
end

function BottomBar_UIParent_ManageRightSideFrames()
	lOriginal_UIParent_ManageRightSideFrames();

	TutorialFrameParent:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 94);
	FramerateLabel:SetPoint("BOTTOM", "WorldFrame", "BOTTOM", 0, 104);
end

function BottomBar_FCF_UpdateDockPosition()
	-- Replace the original function; it's no longer called
	
	if ( DEFAULT_CHAT_FRAME:IsUserPlaced() ) then
		if ( SIMPLE_CHAT ~= "1" ) then
			return;
		end
	end
	
	if ( GetNumShapeshiftForms() > 0 or HasPetUI() or PetHasActionBar() ) then
		DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 100 + BOTTOMBAR_OFFSET_Y);
	else
		DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 85 + BOTTOMBAR_OFFSET_Y);
	end
end

function BottomBar_FCF_Set_SimpleChat()
	lOriginal_FCF_Set_SimpleChat();
	
	ChatFrame2:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -32, 85 + BOTTOMBAR_OFFSET_Y);
end

function BottomBar_SetItemRef(link)
	lOriginal_SetItemRef(link);
	
	if( ItemRefTooltip:IsVisible() ) then
		ItemRefTooltip:ClearAllPoints();
		ItemRefTooltip:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 105 + BOTTOMBAR_OFFSET_Y);
	end
end

function BottomBarButtonDown(id)
	local button = getglobal("BottomBarButton"..id);
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function BottomBarButtonUp(id)
	local button = getglobal("BottomBarButton"..id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction(BottomBarButton_GetID(button), 0);
		if ( IsCurrentAction(BottomBarButton_GetID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function BottomBarButton_OnLoad()
	this.showgrid = 1;
	this.flashing = 0;
	this.flashtime = 0;
	BottomBarButton_Update();
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("ACTIONBAR_SHOWGRID");
	this:RegisterEvent("ACTIONBAR_HIDEGRID");
	this:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("ACTIONBAR_UPDATE_STATE");
	this:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	this:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	this:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("UNIT_AURASTATE");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("CRAFT_SHOW");
	this:RegisterEvent("CRAFT_CLOSE");
	this:RegisterEvent("TRADE_SKILL_SHOW");
	this:RegisterEvent("TRADE_SKILL_CLOSE");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterEvent("START_AUTOREPEAT_SPELL");
	this:RegisterEvent("STOP_AUTOREPEAT_SPELL");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	BottomBarButton_UpdateHotkeys();
end

function BottomBarButton_UpdateHotkeys()
	local name = this:GetName();
	local hotkey = getglobal(name.."HotKey");
	local s, e, id = string.find(name, "^BottomBarButton(%d+)$");
	local action = "BOTTOMACTIONBUTTON"..id;
	local text = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
	
	text = string.gsub(text, "CTRL%-", "C-");
	text = string.gsub(text, "ALT%-", "A-");
	text = string.gsub(text, "SHIFT%-", "S-");
	text = string.gsub(text, "Num Pad", "NP");
	text = string.gsub(text, "Backspace", "Bksp");
	text = string.gsub(text, "Spacebar", "Space");
	text = string.gsub(text, "Page", "Pg");
	text = string.gsub(text, "Down", "Dn");
	text = string.gsub(text, "Arrow", "");
	text = string.gsub(text, "Insert", "Ins");
	text = string.gsub(text, "Delete", "Del");
	
	hotkey:SetText(text);
end

function BottomBarButton_Update()
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local buttonID = BottomBarButton_GetID(this);
	if ( IsAttackAction(buttonID) and IsCurrentAction(buttonID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(buttonID);
	
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(BottomBarButton_GetID(this));
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		this.rangeTimer = TOOLTIP_UPDATE_TIME;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
	else
		icon:Hide();
		buttonCooldown:Hide();
		this.rangeTimer = nil;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
		getglobal(this:GetName().."HotKey"):SetVertexColor(0.6, 0.6, 0.6);
	end
	BottomBarButton_UpdateCount();
	if ( HasAction(BottomBarButton_GetID(this)) ) then
		this:Show();
		BottomBarButton_UpdateUsable();
		BottomBarButton_UpdateCooldown();
	else
		local showgrid = this.showgrid;
		if( Nurfed_BottomBarState and Nurfed_BottomBarState.HideGrid ) then
			showgrid = showgrid - 1;
		end
		if ( showgrid == 0 ) then
			this:Hide();
		else
			getglobal(this:GetName().."Cooldown"):Hide();
		end
	end
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		BottomBarButton_StartFlash();
	else
		BottomBarButton_StopFlash();
	end
	if ( GameTooltip:IsOwned(this) ) then
		BottomBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	macroName:SetText(GetActionText(BottomBarButton_GetID(this)));
end

function BottomBarButton_ShowGrid()
	this.showgrid = this.showgrid+1;
	getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
	this:Show();
end

function BottomBarButton_HideGrid()	
	this.showgrid = this.showgrid-1;
	local showgrid = this.showgrid;
	if( Nurfed_BottomBarState and Nurfed_BottomBarState.HideGrid ) then
		showgrid = showgrid - 1;
	end
	if ( showgrid == 0 and not HasAction(BottomBarButton_GetID(this)) ) then
		this:Hide();
	end
end

function BottomBarButton_UpdateState()
	if ( IsCurrentAction(BottomBarButton_GetID(this)) or IsAutoRepeatAction(BottomBarButton_GetID(this)) ) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
	end
end

function BottomBarButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(BottomBarButton_GetID(this));
	local count = getglobal(this:GetName().."HotKey");
	local text = count:GetText();
	local inRange = IsActionInRange(BottomBarButton_GetID(this));
	if( inRange == 0 ) then
		count:SetVertexColor(1.0, 0.1, 0.1);
	else
		count:SetVertexColor(0.6, 0.6, 0.6);
	end
	if ( isUsable ) then
		if ( (not text or text == "" or not count:IsVisible()) and inRange == 0 ) then
			icon:SetVertexColor(1.0, 0.1, 0.1);
			normalTexture:SetVertexColor(1.0, 0.1, 0.1);
		else
			icon:SetVertexColor(1.0, 1.0, 1.0);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		end
	elseif ( notEnoughMana ) then
		icon:SetVertexColor(0.5, 0.5, 1.0);
		normalTexture:SetVertexColor(0.5, 0.5, 1.0);
	else
		icon:SetVertexColor(0.4, 0.4, 0.4);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function BottomBarButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local count = GetActionCount(BottomBarButton_GetID(this));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function BottomBarButton_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(BottomBarButton_GetID(this));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function BottomBarButton_OnEvent(event)
	if( event == "PLAYER_ENTERING_WORLD" ) then
		local id = BottomBarButton_GetID(this);
		if(  id >= 73 and id <= 84  ) then
			if( UnitClass("player") == "Druid" ) then
				this:SetID(id - 36);
			elseif( UnitClass("player") == "Warrior" ) then
				this:SetID(id - 48);
			elseif( UnitClass("player") == "Rogue") then
				this:SetID(id - 12);
			end
		end
		return;
	end
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == BottomBarButton_GetID(this) ) then
			BottomBarButton_Update();
		end
		return;
	end
	if ( event == "PLAYER_AURAS_CHANGED") then
		BottomBarButton_Update();
		BottomBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		BottomBarButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		BottomBarButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		BottomBarButton_UpdateHotkeys();
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not this:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		BottomBarButton_UpdateUsable();
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			BottomBarButton_UpdateUsable();
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			BottomBarButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		BottomBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" or event == "UPDATE_INVENTORY_ALERTS" or event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		BottomBarButton_UpdateUsable();
		BottomBarButton_UpdateCooldown();
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		BottomBarButton_UpdateState();
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		BottomBarButton_UpdateUsable();
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(BottomBarButton_GetID(this)) ) then
			BottomBarButton_StartFlash();
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = 0;
		if ( IsAttackAction(BottomBarButton_GetID(this)) ) then
			BottomBarButton_StopFlash();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		BottomBarButton_UpdateUsable();
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(BottomBarButton_GetID(this)) ) then
			BottomBarButton_StartFlash();
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( BottomBarButton_IsFlashing() and not IsAttackAction(BottomBarButton_GetID(this)) ) then
			BottomBarButton_StopFlash();
		end
		return;
	end
end

function BottomBarButton_OnDragStart()
	if( not Nurfed_BottomBarState or not Nurfed_BottomBarState.Lock ) then
		PickupAction(BottomBarButton_GetID(this));
		BottomBarButton_UpdateState();
	end
end

function BottomBarButton_SetTooltip()
	local s, e, num = string.find(this:GetName(), "^BottomBarButton(%d+)$");
	if( (num + 0) > 12 ) then
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	else
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	end
		
	if ( GameTooltip:SetAction(BottomBarButton_GetID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function BottomBarButton_OnUpdate(elapsed)
	if ( BottomBarButton_IsFlashing() ) then
		this.flashtime = this.flashtime - elapsed;
		if ( this.flashtime <= 0 ) then
			local overtime = -this.flashtime;
			if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
				overtime = 0;
			end
			this.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;

			local flashTexture = getglobal(this:GetName().."Flash");
			if ( flashTexture:IsVisible() ) then
				flashTexture:Hide();
			else
				flashTexture:Show();
			end
		end
	end

	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			BottomBarButton_UpdateUsable();
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	end

	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		BottomBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function BottomBarButton_GetID(button)
	if ( button == nil ) then
		message("nil button passed into BottomBarButton_GetID(), contact Jeff");
		return 0;
	end
	return (button:GetID())
end

function BottomBarButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	BottomBarButton_UpdateState();
end

function BottomBarButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	BottomBarButton_UpdateState();
end

function BottomBarButton_IsFlashing()
	if ( this.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end
