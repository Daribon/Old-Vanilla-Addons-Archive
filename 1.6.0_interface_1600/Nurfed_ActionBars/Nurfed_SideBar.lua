--[[

	SideBar: Adds two twelve button sidebars that can be separated, moved, and resized
		copyright 2004 by Telo

	- There are hotkey bindings for each of the added buttons
	- Use << /sidebar help >> or just << /sb >> for a list of commands

]]

--------------------------------------------------------------------------------------------------
-- Localizable strings
--------------------------------------------------------------------------------------------------

BINDING_HEADER_SIDEBAR1 = "SideBar 1 Buttons";
BINDING_NAME_SIDEACTIONBUTTON1 = "SideBar 1 Button 1";
BINDING_NAME_SIDEACTIONBUTTON2 = "SideBar 1 Button 2";
BINDING_NAME_SIDEACTIONBUTTON3 = "SideBar 1 Button 3";
BINDING_NAME_SIDEACTIONBUTTON4 = "SideBar 1 Button 4";
BINDING_NAME_SIDEACTIONBUTTON5 = "SideBar 1 Button 5";
BINDING_NAME_SIDEACTIONBUTTON6 = "SideBar 1 Button 6";
BINDING_NAME_SIDEACTIONBUTTON7 = "SideBar 1 Button 7";
BINDING_NAME_SIDEACTIONBUTTON8 = "SideBar 1 Button 8";
BINDING_NAME_SIDEACTIONBUTTON9 = "SideBar 1 Button 9";
BINDING_NAME_SIDEACTIONBUTTON10 = "SideBar 1 Button 10";
BINDING_NAME_SIDEACTIONBUTTON11 = "SideBar 1 Button 11";
BINDING_NAME_SIDEACTIONBUTTON12 = "SideBar 1 Button 12";

BINDING_HEADER_SIDEBAR2 = "SideBar 2 Buttons";
BINDING_NAME_SIDEACTIONBUTTON13 = "SideBar 2 Button 1";
BINDING_NAME_SIDEACTIONBUTTON14 = "SideBar 2 Button 2";
BINDING_NAME_SIDEACTIONBUTTON15 = "SideBar 2 Button 3";
BINDING_NAME_SIDEACTIONBUTTON16 = "SideBar 2 Button 4";
BINDING_NAME_SIDEACTIONBUTTON17 = "SideBar 2 Button 5";
BINDING_NAME_SIDEACTIONBUTTON18 = "SideBar 2 Button 6";
BINDING_NAME_SIDEACTIONBUTTON19 = "SideBar 2 Button 7";
BINDING_NAME_SIDEACTIONBUTTON20 = "SideBar 2 Button 8";
BINDING_NAME_SIDEACTIONBUTTON21 = "SideBar 2 Button 9";
BINDING_NAME_SIDEACTIONBUTTON22 = "SideBar 2 Button 10";
BINDING_NAME_SIDEACTIONBUTTON23 = "SideBar 2 Button 11";
BINDING_NAME_SIDEACTIONBUTTON24 = "SideBar 2 Button 12";

SIDEBAR_HELP = "help";				-- must be lowercase; displays help
SIDEBAR_LOCK = "lock";				-- must be lowercase; locks buttons
SIDEBAR_UNLOCK = "unlock";			-- must be lowercase; unlocks buttons
SIDEBAR_STATUS = "status";			-- must be lowercase; shows status
SIDEBAR_HIDE_LABELS = "hidelabels";	-- must be lowercase; hides hotkey labels
SIDEBAR_SHOW_LABELS = "showlabels";	-- must be lowercase; shows hotkey labels
SIDEBAR_FREEZE = "freeze";			-- must be lowercase; freezes the sidebar in position
SIDEBAR_UNFREEZE = "unfreeze";		-- must be lowercase; unfreezes the sidebar so that it can be dragged
SIDEBAR_RESET = "reset";			-- must be lowercase; resets the sidebar to its default position
SIDEBAR_HIDE_GRID = "hidegrid";		-- must be lowercase; hides the grid of empty buttons
SIDEBAR_SHOW_GRID = "showgrid";		-- must be lowercase; shows the grid of empty buttons
SIDEBAR_LINK = "link";				-- must be lowercase; links the two columns together
SIDEBAR_UNLINK = "unlink";			-- must be lowercase; unlinks the two columns so that they can be moved separately
SIDEBAR_SIZE = "size";				-- must be lowercase, don't use lua search characters in this text; allows the size of the columns to be specified

SIDEBAR_STATUS_HEADER = "|cffffff00SideBar status:|r";
SIDEBAR_FROZEN = "SideBar: frozen in place";
SIDEBAR_UNFROZEN = "SideBar: unfrozen and can be dragged";
SIDEBAR_RESET_DONE = "SideBar: position reset to default";
SIDEBAR_LOCKED = "SideBar: buttons locked";
SIDEBAR_UNLOCKED = "SideBar: buttons unlocked";
SIDEBAR_LABELS_HIDDEN = "SideBar: hotkey labels hidden";
SIDEBAR_LABELS_SHOWN = "SideBar: hotkey labels shown";
SIDEBAR_GRID_HIDDEN = "SideBar: grid hidden";
SIDEBAR_GRID_SHOWN = "SideBar: grid shown";
SIDEBAR_LINKED = "SideBar: columns linked";
SIDEBAR_UNLINKED = "SideBar: columns unlinked";
SIDEBAR_SIZED = "SideBar: first column has %d buttons, second column has %d buttons";

SIDEBAR_HELP_TEXT0 = " ";
SIDEBAR_HELP_TEXT1 = "|cffffff00SideBar command help:|r";
SIDEBAR_HELP_TEXT2 = "|cff00ff00Use |r|cffffffff/sidebar <command>|r|cff00ff00 or |r|cffffffff/sb <command>|r|cff00ff00 to perform the following commands:|r";
SIDEBAR_HELP_TEXT3 = "|cffffffff"..SIDEBAR_HELP.."|r|cff00ff00: displays this message.|r";
SIDEBAR_HELP_TEXT4 = "|cffffffff"..SIDEBAR_STATUS.."|r|cff00ff00: displays status information about the current option settings.|r";
SIDEBAR_HELP_TEXT5 = "|cffffffff"..SIDEBAR_FREEZE.."|r|cff00ff00: freezes the SideBar so that it can't be dragged.|r";
SIDEBAR_HELP_TEXT6 = "|cffffffff"..SIDEBAR_UNFREEZE.."|r|cff00ff00: unfreezes the SideBar so that it can be dragged.|r";
SIDEBAR_HELP_TEXT7 = "|cffffffff"..SIDEBAR_RESET.."|r|cff00ff00: resets the SideBar to its default position.|r";
SIDEBAR_HELP_TEXT8 = "|cffffffff"..SIDEBAR_LOCK.."|r|cff00ff00: when locked, you have to shift-click to remove buttons from the bar.|r";
SIDEBAR_HELP_TEXT9 = "|cffffffff"..SIDEBAR_UNLOCK.."|r|cff00ff00: when unlocked, you can click and drag buttons from the bar.|r";
SIDEBAR_HELP_TEXT10 = "|cffffffff"..SIDEBAR_HIDE_LABELS.."|r|cff00ff00: hides the keyboard shortcut labels from the buttons.|r";
SIDEBAR_HELP_TEXT11 = "|cffffffff"..SIDEBAR_SHOW_LABELS.."|r|cff00ff00: shows the keyboard shortcut labels on the buttons.|r";
SIDEBAR_HELP_TEXT12 = "|cffffffff"..SIDEBAR_HIDE_GRID.."|r|cff00ff00: hides the grid of empty buttons, except when dragging.|r";
SIDEBAR_HELP_TEXT13 = "|cffffffff"..SIDEBAR_SHOW_GRID.."|r|cff00ff00: shows the grid of empty buttons always.|r";
SIDEBAR_HELP_TEXT14 = "|cffffffff"..SIDEBAR_LINK.."|r|cff00ff00: links the two SideBar columns together as a single unit.|r";
SIDEBAR_HELP_TEXT15 = "|cffffffff"..SIDEBAR_UNLINK.."|r|cff00ff00: unlinks the two SideBar columns so that they can be moved separately.|r";
SIDEBAR_HELP_TEXT16 = "|cffffffff"..SIDEBAR_SIZE.." <# of buttons>|r|cff00ff00: sets the number of buttons equally for both columns.|r";
SIDEBAR_HELP_TEXT17 = "|cffffffff"..SIDEBAR_SIZE.." <# of buttons>,<# of buttons>|r|cff00ff00: sets the number of buttons separately for each column; either can be left out to leave that column unchanged.|r";
SIDEBAR_HELP_TEXT18 = " ";
SIDEBAR_HELP_TEXT19 = "|cff00ff00For example: |r|cffffffff/sidebar freeze|r|cff00ff00 will prevent the SideBar from being dragged with the mouse.|r";

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local lOriginal_updateContainerFrameAnchors;

local lUpdateTimer = 0;
local SIDEBAR_UPDATE_TIME = 0.5;

--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function SideBar_MouseIsOver(frame)
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
	
	if( (x > left and x < right) and (y > bottom and y < top) ) then
		return 1;
	else
		return nil;
	end
end

local function SideBar_FixupUnlinked()
	local sbTop = SideBar:GetTop();
	local sbLeft = SideBar:GetLeft();
	local top;
	local left;
	
	top = SideBar1:GetTop();
	left = SideBar1:GetLeft();
	
	if( sbTop and sbLeft and top and left ) then
		SideBar1:ClearAllPoints();
		SideBar1:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", -9 + left - sbLeft, 8 + top - sbTop);
	end

	SideBarButton1:SetPoint("TOPLEFT", "SideBar1", "TOPLEFT", 9, -8);
	
	top = SideBar2:GetTop();
	left = SideBar2:GetLeft();
	
	if( sbTop and sbLeft and top and left ) then
		SideBar2:ClearAllPoints();
		SideBar2:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", -9 + left - sbLeft, 8 + top - sbTop);
	end
	
	SideBarButton13:SetPoint("TOPLEFT", "SideBar2", "TOPLEFT", 9, -8);
end

local function SideBar1_ShowWidgets()
	SideBar1:EnableMouse(1);
	SideBar1Backdrop:Show();
	SideBar1Add:Show();
	if( not Nurfed_SideBarState or Nurfed_SideBarState.Buttons1 == 12 ) then
		SideBar1Add:Disable();
	else
		SideBar1Add:Enable();
	end
	SideBar1Sub:Show();
	if( Nurfed_SideBarState and Nurfed_SideBarState.Buttons1 == 0 ) then
		SideBar1Sub:Disable();
	else
		SideBar1Sub:Enable();
	end
end

local function SideBar1_HideWidgets()
	SideBar1:EnableMouse(nil);
	SideBar1Backdrop:Hide();
	SideBar1Add:Hide();
	SideBar1Sub:Hide();
end

local function SideBar2_ShowWidgets()
	SideBar2:EnableMouse(1);
	SideBar2Backdrop:Show();
	SideBar2Add:Show();
	if( not Nurfed_SideBarState or Nurfed_SideBarState.Buttons2 == 12 ) then
		SideBar2Add:Disable();
	else
		SideBar2Add:Enable();
	end
	SideBar2Sub:Show();
	if( Nurfed_SideBarState and Nurfed_SideBarState.Buttons2 == 0 ) then
		SideBar2Sub:Disable();
	else
		SideBar2Sub:Enable();
	end
end

local function SideBar2_HideWidgets()
	SideBar2:EnableMouse(nil);
	SideBar2Backdrop:Hide();
	SideBar2Add:Hide();
	SideBar2Sub:Hide();
end

local function SideBar_ShowWidgets()
	SideBar:EnableMouse(1);
	SideBarBackdrop:Show();
	SideBarAdd:Show();
	if( not Nurfed_SideBarState or (Nurfed_SideBarState.Buttons1 == 12 and Nurfed_SideBarState.Buttons2 == 12) ) then
		SideBarAdd:Disable();
	else
		SideBarAdd:Enable();
	end
	if( Nurfed_SideBarState and Nurfed_SideBarState.Buttons1 == 0 and Nurfed_SideBarState.Buttons2 == 0 ) then
		SideBarSub:Disable();
	else
		SideBarSub:Enable();
	end
	SideBarSub:Show();
end

local function SideBar_HideWidgets()
	SideBar:EnableMouse(nil);
	SideBarBackdrop:Hide();
	SideBarAdd:Hide();
	SideBarSub:Hide();
end

local function SideBar_HandleWidgets()
	local unlinked;
	local frozen;
	local buttons1;
	local buttons2;
	local buttonsMax;
	
	if( Nurfed_SideBarState ) then
		unlinked = Nurfed_SideBarState.Unlinked;
		frozen = Nurfed_SideBarState.Freeze;
		buttons1 = Nurfed_SideBarState.Buttons1;
		buttons2 = Nurfed_SideBarState.Buttons2;
	else
		buttons1 = 12;
		buttons2 = 12;
	end
	
	if( buttons1 > buttons2 ) then
		buttonsMax = buttons1;
	else
		buttonsMax = buttons2;
	end
	
	if( unlinked ) then
		SideBar_HideWidgets();
		if( not frozen ) then
			if( SideBar1 ) then
				SideBar1:SetHeight( buttons1 * 38 + 30);
				--SideBar1:SetWidth(56*scale);
				if( (SideBar_MouseIsOver(SideBar1) or SideBar1.BeingDragged) and NURFED_LOCKALL == 0 ) then
					SideBar1_ShowWidgets();
				else
					SideBar1_HideWidgets();
				end
			end
			SideBar2:SetHeight( buttons2 * 38 + 30);
			--SideBar2:SetWidth(56*scale);
			if( (SideBar_MouseIsOver(SideBar2) or SideBar2.BeingDragged) and NURFED_LOCKALL == 0 ) then
				SideBar2_ShowWidgets();
			else
				SideBar2_HideWidgets();
			end
		else
			if( SideBar1 ) then
				--SideBar1:SetHeight( (buttons1 * 38)*scale - 4);
				--SideBar1:SetWidth(38*scale);
				SideBar1_HideWidgets();
			end
			--SideBar2:SetHeight( (buttons2 * 38)*scale - 4);
			--SideBar2:SetWidth(38*scale);
			SideBar2_HideWidgets();
		end
	else
		if( SideBar1 ) then
			--SideBar1:SetHeight( (buttons1 * 38)*scale - 4);
			--SideBar1:SetWidth(38*scale);
			SideBar1_HideWidgets();
		end
		--SideBar2:SetHeight( (buttons2 * 38)*scale - 4);
		--SideBar2:SetWidth(38*scale);
		SideBar2_HideWidgets();
		if( not frozen ) then
			SideBar:SetHeight( buttonsMax * 38 + 30);
			if( (SideBar_MouseIsOver(SideBar) or SideBar.BeingDragged) and NURFED_LOCKALL == 0 ) then
				SideBar_ShowWidgets();
			else
				SideBar_HideWidgets();
			end
		else
			--SideBar:SetHeight( buttonsMax * 38 + 4);
			SideBar_HideWidgets();
		end
	end
end

function SideBar_SetState(unlinked)
	if( Nurfed_SideBarState ) then
		if( not Nurfed_SideBarState.Unlinked ) then
			-- Link the pieces together
			SideBar1:ClearAllPoints();
			SideBar1:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 9, -8);
			SideBar2:ClearAllPoints();
			SideBar2:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 51, -8);

			SideBarButton1:SetPoint("TOPLEFT", "SideBar1", "TOPLEFT", 0, 0);
			SideBarButton13:SetPoint("TOPLEFT", "SideBar2", "TOPLEFT", 0, 0);
		else
			-- Linked before this, fix up the positions
			if( not unlinked ) then
				SideBar_FixupUnlinked();
			end
		end
		local iButton;
		local label;
		local button;
		for iButton = 1, 24 do
			label = getglobal("SideBarButton"..iButton.."HotKey");
			if( Nurfed_SideBarState.HideLabels ) then
				label:Hide();
			else
				label:Show();
			end
			button = getglobal("SideBarButton"..iButton);
			if( Nurfed_SideBarState.HideGrid and button.showgrid - 1 == 0 and not HasAction(SideBarButton_GetID(button)) ) then
				button:Hide();
			else
				if( iButton > 12 ) then
					if( (iButton - 12) > Nurfed_SideBarState.Buttons2 ) then
						button:Hide();
						button.Hidden = 1;
					else
						button:Show();
						button.Hidden = nil;
					end
				else
					if( iButton > Nurfed_SideBarState.Buttons1 ) then
						button:Hide();
						button.Hidden = 1;
					else
						button:Show();
						button.Hidden = nil;
					end
				end
			end
		end
	end
	SideBar_HandleWidgets();
end

local function SideBar_Status()
	DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_STATUS_HEADER);
	if( Nurfed_SideBarState ) then
		if( Nurfed_SideBarState.Freeze ) then
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_FROZEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNFROZEN);
		end
		if( Nurfed_SideBarState.Lock ) then
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LOCKED);
		else
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNLOCKED);
		end
		if( Nurfed_SideBarState.HideLabels ) then
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LABELS_HIDDEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LABELS_SHOWN);
		end
		if( Nurfed_SideBarState.HideGrid ) then
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_GRID_HIDDEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_GRID_SHOWN);
		end
		if( Nurfed_SideBarState.Unlinked ) then
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNLINKED);
		else
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LINKED);
		end
		DEFAULT_CHAT_FRAME:AddMessage(format(SIDEBAR_SIZED, Nurfed_SideBarState.Buttons1, Nurfed_SideBarState.Buttons2));
	else
		DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNFROZEN);
		DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNLOCKED);
		DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LABELS_SHOWN);
		DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_GRID_SHOWN);
		DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LINKED);
		DEFAULT_CHAT_FRAME:AddMessage(format(SIDEBAR_SIZED, 12, 12));
	end
end

local function SideBar_Reset()
	SideBar:ClearAllPoints();
	SideBar:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", 0, -450);
	if( Nurfed_SideBarState.Unlinked ) then
		SideBar1:ClearAllPoints();
		SideBar1:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 0, 0);
		SideBar2:ClearAllPoints();
		SideBar2:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 42, 0);
	else
		SideBar1:ClearAllPoints();
		SideBar1:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 9, -8);
		SideBar2:ClearAllPoints();
		SideBar2:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 51, -8);
	end
end

function SideBar_SlashCommandHandler(msg)
	if( msg ) then
		local command = string.lower(msg);
		if( command == "" or command == SIDEBAR_HELP ) then
			local index = 0;
			local value = getglobal("SIDEBAR_HELP_TEXT"..index);
			while( value ) do
				DEFAULT_CHAT_FRAME:AddMessage(value);
				index = index + 1;
				value = getglobal("SIDEBAR_HELP_TEXT"..index);
			end
		elseif( command == SIDEBAR_STATUS ) then
			SideBar_Status();
		elseif( command == SIDEBAR_FREEZE ) then
			Nurfed_SideBarState.Freeze = 1;
			SideBar_OnDragStop(SideBar);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_FROZEN);
		elseif( command == SIDEBAR_UNFREEZE ) then
			Nurfed_SideBarState.Freeze = nil;
			SideBar_HandleWidgets();
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNFROZEN);
		elseif( command == SIDEBAR_RESET ) then
			SideBar_Reset();
			SideBar_OnDragStop(SideBar);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_RESET_DONE);
		elseif( command == SIDEBAR_LOCK ) then
			Nurfed_SideBarState.Lock = 1;
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LOCKED);
		elseif( command == SIDEBAR_UNLOCK ) then
			Nurfed_SideBarState.Lock = nil;
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNLOCKED);
		elseif( command == SIDEBAR_HIDE_LABELS ) then
			Nurfed_SideBarState.HideLabels = 1;
			SideBar_SetState(Nurfed_SideBarState.Unlinked);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LABELS_HIDDEN);
		elseif( command == SIDEBAR_SHOW_LABELS ) then
			Nurfed_SideBarState.HideLabels = nil;
			SideBar_SetState(Nurfed_SideBarState.Unlinked);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LABELS_SHOWN);
		elseif( command == SIDEBAR_HIDE_GRID ) then
			Nurfed_SideBarState.HideGrid = 1;
			SideBar_SetState(Nurfed_SideBarState.Unlinked);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_GRID_HIDDEN);
		elseif( command == SIDEBAR_SHOW_GRID ) then
			Nurfed_SideBarState.HideGrid = nil;
			SideBar_SetState(Nurfed_SideBarState.Unlinked);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_GRID_SHOWN);
		elseif( command == SIDEBAR_LINK ) then
			local previous = Nurfed_SideBarState.Unlinked;
			Nurfed_SideBarState.Unlinked = nil;
			SideBar_SetState(previous);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_LINKED);
		elseif( command == SIDEBAR_UNLINK ) then
			local previous = Nurfed_SideBarState.Unlinked;
			Nurfed_SideBarState.Unlinked = 1;
			SideBar_SetState(previous);
			DEFAULT_CHAT_FRAME:AddMessage(SIDEBAR_UNLINKED);
		elseif( string.find(command, "^"..SIDEBAR_SIZE.." ") ) then
			local s, e, one, two;
			s, e, one, two = string.find(command, "^"..SIDEBAR_SIZE.."%s+(%d+)%s*,%s*(%d+)%s*$");
			if( two ) then
				one = one + 0;
				two = two + 0;
				if( one >= 0 and one <= 12 ) then
					Nurfed_SideBarState.Buttons1 = one;
				end
				if( two >= 0 and two <= 12 ) then
					Nurfed_SideBarState.Buttons2 = two;
				end
			else
				s, e, one = string.find(command, "^"..SIDEBAR_SIZE.."%s+(%d+)%s*$");
				if( one ) then
					one = one + 0;
					if( one >= 0 and one <= 12 ) then
						Nurfed_SideBarState.Buttons1 = one;
						Nurfed_SideBarState.Buttons2 = one;
					end
				else
					s, e, one = string.find(command, "^"..SIDEBAR_SIZE.."%s+(%d+),%s*$");
					if( one ) then
						one = one + 0;
						if( one >= 0 and one <= 12 ) then
							Nurfed_SideBarState.Buttons1 = one;
						end
					else
						s, e, two = string.find(command, "^"..SIDEBAR_SIZE.."%s+,%s*(%d+)%s*$");
						if( two ) then
							two = two + 0;
							if( two >= 0 and two <= 12 ) then
								Nurfed_SideBarState.Buttons2 = two;
							end
						else
							return;
						end
					end
				end
			end
			SideBar_SetState(Nurfed_SideBarState.Unlinked);
			DEFAULT_CHAT_FRAME:AddMessage(format(SIDEBAR_SIZED, Nurfed_SideBarState.Buttons1, Nurfed_SideBarState.Buttons2));
		end
	end
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function SideBar_OnLoad()
	SideBar:RegisterForDrag("LeftButton");
	SideBar1:RegisterForDrag("LeftButton");
	SideBar2:RegisterForDrag("LeftButton");

	RegisterForSave("Nurfed_SideBarState");
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

	-- Register our slash command
	SLASH_SIDEBAR1 = "/sidebar";
	SLASH_SIDEBAR2 = "/sb";
	SlashCmdList["SIDEBAR"] = function(msg)
		SideBar_SlashCommandHandler(msg);
	end
	
	-- Hook updateContainerFrameAnchors
	lOriginal_updateContainerFrameAnchors = updateContainerFrameAnchors;
	updateContainerFrameAnchors = SideBar_updateContainerFrameAnchors;

	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("Telo's SideBar AddOn loaded");
	end
	UIErrorsFrame:AddMessage("Telo's SideBar AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
end

function SideBar_OnShow()
	if( not Nurfed_SideBarState ) then
		SideBar_SetState(nil);
	else
		SideBar_SetState(Nurfed_SideBarState.Unlinked);
	end
end

function SideBar_OnEvent()
	if( event == "VARIABLES_LOADED" ) then
		if( not Nurfed_SideBarState ) then
			Nurfed_SideBarState = { };
			Nurfed_SideBarState.Buttons1 = 12;
			Nurfed_SideBarState.Buttons2 = 12;
		else
			if( not Nurfed_SideBarState.Buttons1 ) then
				Nurfed_SideBarState.Buttons1 = 12;
			end
			if( not Nurfed_SideBarState.Buttons2 ) then
				Nurfed_SideBarState.Buttons2 = 12;
			end
			SideBar_SetState(nil);
		end
	elseif( event == "PLAYER_ENTERING_WORLD" ) then
		SideBar_OnShow();
	end
end

function SideBar_OnUpdate(elapsed)
	lUpdateTimer = lUpdateTimer + elapsed;
	if( lUpdateTimer >= SIDEBAR_UPDATE_TIME ) then
		SideBar_HandleWidgets();
	end
end

function SideBar_OnDragStart(frame)
	if( not Nurfed_SideBarState ) then
		if( frame ~= SideBar ) then
			return;
		end
	else
		if( NURFED_LOCKALL == 1 or (Nurfed_SideBarState.Unlinked and frame == SideBar) ) then
			return;
		end
	end
	frame.BeingDragged = 1;
	SideBar_HandleWidgets();
	frame:StartMoving();
	if( frame == SideBar ) then
		SideBar1:StartMoving();
		SideBar1.BeingDragged = 1;
		SideBar2:StartMoving();
		SideBar2.BeingDragged = 1;
	end
end

function SideBar_OnDragStop(frame)
	frame:StopMovingOrSizing();
	frame.BeingDragged = nil;
	if( frame == SideBar ) then
		SideBar1:StopMovingOrSizing();
		SideBar1.BeingDragged = nil;
		SideBar2:StopMovingOrSizing();
		SideBar2.BeingDragged = nil;
	end
	SideBar_HandleWidgets();
end

function SideBar_Add(frame)
	local buttons1;
	local buttons2;
	if( frame == SideBar ) then
		buttons1 = Nurfed_SideBarState.Buttons1 + 1;
		buttons2 = Nurfed_SideBarState.Buttons2 + 1;
	elseif( frame == SideBar1 ) then
		buttons1 = Nurfed_SideBarState.Buttons1 + 1;
	else
		buttons2 = Nurfed_SideBarState.Buttons2 + 1;
	end
	if( buttons1 and buttons1 <= 12 ) then
		Nurfed_SideBarState.Buttons1 = buttons1;
	end
	if( buttons2 and buttons2 <= 12 ) then
		Nurfed_SideBarState.Buttons2 = buttons2;
	end
	SideBar_SetState(Nurfed_SideBarState.Unlinked);
end

function SideBar_Sub(frame)
	local buttons1;
	local buttons2;
	if( frame == SideBar ) then
		buttons1 = Nurfed_SideBarState.Buttons1 - 1;
		buttons2 = Nurfed_SideBarState.Buttons2 - 1;
	elseif( frame == SideBar1 ) then
		buttons1 = Nurfed_SideBarState.Buttons1 - 1;
	else
		buttons2 = Nurfed_SideBarState.Buttons2 - 1;
	end
	if( buttons1 and buttons1 >= 0 ) then
		Nurfed_SideBarState.Buttons1 = buttons1;
	end
	if( buttons2 and buttons2 >= 0 ) then
		Nurfed_SideBarState.Buttons2 = buttons2;
	end
	SideBar_SetState(Nurfed_SideBarState.Unlinked);
end

function SideBar_GameTooltip_SetPoint()
	-- Intentionally empty -- don't move the tooltip
end

function SideBar_updateContainerFrameAnchors()
	-- Don't move the tooltip
	local lOriginal_GameTooltip_SetPoint = GameTooltip.SetPoint;
	GameTooltip.SetPoint = SideBar_GameTooltip_SetPoint;
	lOriginal_updateContainerFrameAnchors();
	GameTooltip.SetPoint = lOriginal_GameTooltip_SetPoint;
	
	-- Move the player's bags off of the sidebar pieces
	local left1 = floor(SideBar1:GetLeft() + 0.5);
	local right1 = floor(SideBar1:GetRight() + 0.5);
	local left2 = floor(SideBar2:GetLeft() + 0.5);
	local right2 = floor(SideBar2:GetRight() + 0.5);
	local temp;
	local iBag;
	local lastLeft;
	local columnBagIndices = { };
	local totalColumns = 0;
	local iColumn;
	local columnBottom;
	
	-- Sort the sidebar columns so that 1 is to the left of 2
	if( left2 < left1 ) then
		temp = left1;
		left1 = left2;
		left2 = temp;
		temp = right1;
		right1 = right2;
		right2 = temp;
	end

	-- Scan the bags and find the ones that start columns
	iBag = 1;
	while ContainerFrame1.bags[iBag] do
		local frame = getglobal(ContainerFrame1.bags[iBag]);
		if( not frame ) then
			break;
		end
		local bottom = floor(frame:GetBottom() + 0.5);
		if( not columnBottom or bottom == columnBottom ) then
			columnBottom = bottom;
			columnBagIndices[totalColumns] = iBag;
			totalColumns = totalColumns + 1;
		end
		iBag = iBag + 1;
	end
	
	-- Now move the column-starting bags
	iColumn = 0;
	while iColumn < totalColumns do
		local frame = getglobal(ContainerFrame1.bags[columnBagIndices[iColumn]]);
		local bottom = frame:GetBottom();
		local left = floor(frame:GetLeft() + 0.5);
		local right = floor(frame:GetRight() + 0.5);

		-- First, move this bag so that its right is equal to the last one's left
		if( lastLeft ) then
			right = lastLeft;
			left = right - CONTAINER_WIDTH;
		end
		
		-- Overlaps the right bar?			
		if( left < right2 and right > left2 ) then
			-- Move it off the right bar
			right = left2 - 5;
			left = right - CONTAINER_WIDTH;
		end
		
		-- Overlaps the left bar?
		if( left < right1 and right > left1 ) then
			-- Move it off the left bar
			right = left1 - 5;
			left = right - CONTAINER_WIDTH;
		end

		-- Now move it...
		right = right - GetScreenWidth();
		frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", right, bottom);

		lastLeft = left;
		iColumn = iColumn + 1;
	end
end

function SideBarButtonDown(id)
	local button = getglobal("SideBarButton"..id);
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function SideBarButtonUp(id)
	local button = getglobal("SideBarButton"..id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction(SideBarButton_GetID(button), 0);
		if ( IsCurrentAction(SideBarButton_GetID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function SideBarButton_OnLoad()
	this.showgrid = 1;
	this.flashing = 0;
	this.flashtime = 0;
	SideBarButton_Update();
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
	SideBarButton_UpdateHotkeys();
end

function SideBarButton_UpdateHotkeys()
	local name = this:GetName();
	local hotkey = getglobal(name.."HotKey");
	local s, e, id = string.find(name, "^SideBarButton(%d+)$");
	local action = "SIDEACTIONBUTTON"..id;
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

function SideBarButton_Update()
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local buttonID = SideBarButton_GetID(this);
	if ( IsAttackAction(buttonID) and IsCurrentAction(buttonID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(buttonID);
	
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(SideBarButton_GetID(this));
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
	SideBarButton_UpdateCount();
	if ( HasAction(SideBarButton_GetID(this)) ) then
		if( not this.Hidden ) then
			this:Show();
		end
		SideBarButton_UpdateUsable();
		SideBarButton_UpdateCooldown();
	else
		local showgrid = this.showgrid;
		if( Nurfed_SideBarState and Nurfed_SideBarState.HideGrid ) then
			showgrid = showgrid - 1;
		end
		if ( showgrid == 0 ) then
			this:Hide();
		else
			getglobal(this:GetName().."Cooldown"):Hide();
		end
	end
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		SideBarButton_StartFlash();
	else
		SideBarButton_StopFlash();
	end
	if ( GameTooltip:IsOwned(this) ) then
		SideBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	macroName:SetText(GetActionText(SideBarButton_GetID(this)));
end

function SideBarButton_ShowGrid()
	this.showgrid = this.showgrid+1;
	getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
	if( not this.Hidden ) then
		this:Show();
	end
end

function SideBarButton_HideGrid()	
	this.showgrid = this.showgrid-1;
	local showgrid = this.showgrid;
	if( Nurfed_SideBarState and Nurfed_SideBarState.HideGrid ) then
		showgrid = showgrid - 1;
	end
	if ( showgrid == 0 and not HasAction(SideBarButton_GetID(this)) ) then
		this:Hide();
	end
end

function SideBarButton_UpdateState()
	if ( IsCurrentAction(SideBarButton_GetID(this)) or IsAutoRepeatAction(SideBarButton_GetID(this)) ) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
	end
end

function SideBarButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(SideBarButton_GetID(this));
	local count = getglobal(this:GetName().."HotKey");
	local text = count:GetText();
	local inRange = IsActionInRange(SideBarButton_GetID(this));
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

function SideBarButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local count = GetActionCount(SideBarButton_GetID(this));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function SideBarButton_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(SideBarButton_GetID(this));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function SideBarButton_OnEvent(event)
	if( event == "PLAYER_ENTERING_WORLD" ) then
		local id = SideBarButton_GetID(this);
		if( id >= 97 and id <= 108 ) then
			if( UnitClass("player") == "Druid" ) then
				this:SetID(id - 12);
			elseif( UnitClass("player") == "Warrior" ) then
				this:SetID(id - 36);
			end
		end
		return;
	end
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == SideBarButton_GetID(this) ) then
			SideBarButton_Update();
		end
		return;
	end
	if ( event == "PLAYER_AURAS_CHANGED") then
		SideBarButton_Update();
		SideBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		SideBarButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		SideBarButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		SideBarButton_UpdateHotkeys();
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not this:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			SideBarButton_UpdateUsable();
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			SideBarButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		SideBarButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" or event == "UPDATE_INVENTORY_ALERTS" or event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		SideBarButton_UpdateUsable();
		SideBarButton_UpdateCooldown();
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		SideBarButton_UpdateState();
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StartFlash();
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = 0;
		if ( IsAttackAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StopFlash();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		SideBarButton_UpdateUsable();
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StartFlash();
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( SideBarButton_IsFlashing() and not IsAttackAction(SideBarButton_GetID(this)) ) then
			SideBarButton_StopFlash();
		end
		return;
	end
end

function SideBarButton_OnDragStart()
	if( not Nurfed_SideBarState or not Nurfed_SideBarState.Lock ) then
		PickupAction(SideBarButton_GetID(this));
		SideBarButton_UpdateState();
	end
end

function SideBarButton_SetTooltip()
	if( this:GetCenter() < GetScreenWidth() / 2 ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	else
		GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	end

	if ( GameTooltip:SetAction(SideBarButton_GetID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function SideBarButton_OnUpdate(elapsed)
	if ( SideBarButton_IsFlashing() ) then
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
			SideBarButton_UpdateUsable();
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
		SideBarButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function SideBarButton_GetID(button)
	if ( button == nil ) then
		message("nil button passed into SideBarButton_GetID(), contact Jeff");
		return 0;
	end
	return (button:GetID())
end

function SideBarButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	SideBarButton_UpdateState();
end

function SideBarButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	SideBarButton_UpdateState();
end

function SideBarButton_IsFlashing()
	if ( this.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end
