TITAN_PANEL_FRAME_SPACEING = 20;
TITAN_PANEL_ICON_SPACEING = 4;
TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE = 10;
TITAN_AUTOHIDE_WAIT_TIME = 0.5;
TITAN_PANEL_INITIAL_PLUGINS = {"Honor", "XP", "Coords", "Bag", "Money", "Clock", "Volume", "UIScale", "Trans", "AutoHide"};

TITAN_PANEL_BUTTONS_ALIGN_LEFT = 1;
TITAN_PANEL_BUTTONS_ALIGN_CENTER = 2;
TITAN_PANEL_BUTTONS_ALIGN_RIGHT = 3;

TITAN_PANEL_BUTTONS_INIT_FLAG = nil;

TITAN_PANEL_SAVED_VARIABLES = {
	Buttons = TITAN_PANEL_INITIAL_PLUGINS,
	Transparency = 0.7,
	Scale = 1,
	AutoHide = TITAN_NIL,
	Position = TITAN_PANEL_PLACE_TOP;
	ButtonAlign = TITAN_PANEL_BUTTONS_ALIGN_LEFT;
}

function TitanPanelBarButton_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("TIME_PLAYED_MSG");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("CVAR_UPDATE");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TitanPanelBarButton_OnEvent()
	if (event == "VARIABLES_LOADED") then
		TitanVariables_InitTitanSettings();	
		
	elseif (event == "UNIT_NAME_UPDATE") then
		TitanVariables_InitDetailedSettings();
		
	elseif (event == "PLAYER_ENTERING_WORLD") then
		TitanVariables_InitDetailedSettings();
		
		-- Initial session time 
		if (not this.sessionTime) then
			this.sessionTime = 0;
			RequestTimePlayed();
		end
		
	elseif (event == "TIME_PLAYED_MSG") then
		-- Remember play time
		this.totalTime = arg1;
		this.levelTime = arg2;		

		-- Move frames
		TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
		TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
		TitanMovableFrame_AdjustBlizzardFrames();
		
		-- Init panel buttons
		TitanPanel_InitPanelBarButton();
		TitanPanel_InitPanelButtons();		
		
	elseif (event == "PLAYER_LEVEL_UP") then
		-- Reset level time
		this.levelTime = 0;
		
	elseif (event == "CVAR_UPDATE") then
		if (arg1 == "USE_UISCALE" or arg1 == "WINDOWED_MODE") then
			if (TitanPlayerSettings and TitanPanelGetVar("Scale")) then
				TitanPanel_SetScale();
				TitanPanel_RefreshPanelButtons();

				-- Adjust frame positions
				TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
				TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
				TitanMovableFrame_AdjustBlizzardFrames();
			end
		end
	end
end

function TitanPanelBarButton_OnUpdate(elapsed)
	-- Check AutoHide
	TitanUtils_CheckAutoHideCounting(elapsed);

	-- Update play time
	if (this.totalTime) then
		this.totalTime = this.totalTime + elapsed;
		this.sessionTime = this.sessionTime + elapsed;
		this.levelTime = this.levelTime + elapsed;
	end
end

function TitanPanelBarButton_OnClick(button)
	if (button == "LeftButton") then
		TitanUtils_CloseAllControlFrames();	
		TitanUtils_CloseRightClickMenu();		
	elseif (button == "RightButton") then
		TitanUtils_CloseAllControlFrames();			
		-- Show RightClickMenu anyway
		if (TitanPanelRightClickMenu_IsVisible()) then
			TitanPanelRightClickMenu_Close();
		end
		TitanPanelRightClickMenu_Toggle();		
	end
end

function TitanPanelBarButton_OnEnter()
	if (not TitanPanelGetVar("AutoHide")) then
		return;
	else 
		TitanUtils_StopAutoHideCounting();
		if (TitanPanelBarButton.hide) then
			TitanPanelBarButton_Show(TitanPanelGetVar("Position"));
		end
	end
end

function TitanPanelBarButton_OnLeave()
	if (not TitanPanelGetVar("AutoHide")) then
		return;
	else
		TitanUtils_StartAutoHideCounting();
	end
end

function TitanPanelRightClickMenu_BarOnClick()
	if (UIDropDownMenuButton_GetChecked()) then
		TitanPanel_RemoveButton(this.value);
	else
		TitanPanel_AddButton(this.value);
	end
end

function TitanPanelBarButton_ToggleAlign()
	if ( TitanPanelGetVar("ButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER ) then
		TitanPanelSetVar("ButtonAlign", TITAN_PANEL_BUTTONS_ALIGN_LEFT);
	else
		TitanPanelSetVar("ButtonAlign", TITAN_PANEL_BUTTONS_ALIGN_CENTER);
	end
	
	-- Justify button position
	TitanPanelButton_Justify();
end

function TitanPanelBarButton_ToggleAutoHide()
	TitanPanelToggleVar("AutoHide");
	if (TitanPanelGetVar("AutoHide")) then
		TitanPanelBarButton_Hide(TitanPanelGetVar("Position"));
	else
		TitanPanelBarButton_Show(TitanPanelGetVar("Position"));
	end
	TitanPanelAutoHideButton_SetIcon();
end

function TitanPanelBarButton_TogglePosition()
	if (TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_TOP) then
		TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
		TitanPanelSetVar("Position", TITAN_PANEL_PLACE_BOTTOM);
		TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
	else
		TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
		TitanPanelSetVar("Position", TITAN_PANEL_PLACE_TOP);
		TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
	end
	
	-- Set panel position and texture
	TitanPanel_SetPosition(TitanPanelGetVar("Position"));
	TitanPanel_SetTexture(TitanPanelGetVar("Position"));
	
	-- Adjust frame positions
	TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
	TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
	TitanMovableFrame_AdjustBlizzardFrames();
end

function TitanPanelBarButton_Show(position)
	if (position == TITAN_PANEL_PLACE_TOP) then
		TitanPanelBarButton:ClearAllPoints();	
		TitanPanelBarButton:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0); 
		TitanPanelBarButton:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -24); 
	else
		TitanPanelBarButton:ClearAllPoints();	
		TitanPanelBarButton:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		TitanPanelBarButton:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24); 
	end
	
	TitanPanelBarButton.hide = nil;
end

function TitanPanelBarButton_Hide(position)
	if (position == TITAN_PANEL_PLACE_TOP) then
		TitanPanelBarButton:ClearAllPoints();
		TitanPanelBarButton:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 21); 
		TitanPanelBarButton:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -3); 
	else
		TitanPanelBarButton:ClearAllPoints();
		TitanPanelBarButton:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, -21); 
		TitanPanelBarButton:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 3); 
	end
	
	TitanPanelBarButton.hide = 1;
end

function TitanPanel_InitPanelBarButton()
	-- Set Titan Panel position/textures
	TitanPanel_SetPosition(TitanPanelGetVar("Position"));
	TitanPanel_SetTexture(TitanPanelGetVar("Position"));

	-- Set initial Panel Scale
	TitanPanel_SetScale();		

	-- Set initial Panel Transparency
	TitanPanelBarButton:SetAlpha(TitanPanelGetVar("Transparency"));		

	-- Set initial Panel AutoHide
	if (TitanPanelGetVar("AutoHide")) then
		TitanPanelBarButton_Hide(TitanPanelGetVar("Position"));
	end		
end

function TitanPanel_SetPosition(position)
	if (position == TITAN_PANEL_PLACE_TOP) then
		TitanPanelBarButton:ClearAllPoints();
		TitanPanelBarButton:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
		TitanPanelBarButton:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -24);
	else
		TitanPanelBarButton:ClearAllPoints();
		TitanPanelBarButton:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0);
		TitanPanelBarButton:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24);
	end
end

function TitanPanel_SetTexture(position)
	local pos = TitanUtils_Ternary(position == TITAN_PANEL_PLACE_TOP, "Top", "Bottom");
	for i = 0, 11 do 
		getglobal("TitanPanelBackground"..i):SetTexture(TITAN_ARTWORK_PATH.."TitanPanelBackground"..pos..math.mod(i, 2));
	end
end

function TitanPanel_InitPanelButtons()
	local button, leftButton, rightButton;
	local newButtons = {};
	local scale = TitanPanelGetVar("Scale");
	local isClockOnRightSide;

	-- Position Clock first if it's displayed on the far right side
	if ( TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, TITAN_CLOCK_ID) and
			TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		isClockOnRightSide = 1;
		button = TitanUtils_GetButton(TITAN_CLOCK_ID);
		button:SetPoint("RIGHT", "TitanPanelBarButton", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
		rightButton = button;
	end
	
	-- Position all the buttons 
	for index, id in TitanPanelSettings.Buttons do 
		if ( TitanUtils_IsPluginRegistered(id) ) then
			button = TitanUtils_GetButton(id);

			if ( id == TITAN_CLOCK_ID and isClockOnRightSide ) then
				-- Do nothing, since it's already positioned
			elseif ( TitanPanelButton_IsIcon(id) ) then
				if ( not rightButton ) then
					button:SetPoint("RIGHT", "TitanPanelBarButton", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
				else
					button:SetPoint("RIGHT", rightButton:GetName(), "LEFT", -TITAN_PANEL_ICON_SPACEING * scale, 0); 
				end
				rightButton = button;
			else			
				if ( not leftButton ) then
					button:SetPoint("LEFT", "TitanPanelBarButton", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
				else
					button:SetPoint("LEFT", leftButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0); 
				end
				leftButton = button;
			end
			
			table.insert(newButtons, id);
			button:Show();
		end
	end
	
	-- Set TitanPanelSettings.Buttons
	TitanPanelSettings.Buttons = newButtons;	
	
	-- Set panel button init flag
	TITAN_PANEL_BUTTONS_INIT_FLAG = 1;
	TitanPanelButton_Justify();
end

function TitanPanel_RemoveButton(id)
	if ( not TitanPanelSettings ) then
		return;
	end 
	
	-- Check if clock displayed on the far right side
	local isClockOnRightSide;
	if ( TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, TITAN_CLOCK_ID) and
			TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		isClockOnRightSide = 1;
	end

	local scale = TitanPanelGetVar("Scale");
	local currentButton = TitanUtils_GetButton(id);
	local previousButton = TitanUtils_GetPreviousButton(TitanPanelSettings.Buttons, id, 1, isClockOnRightSide);
	local nextButton = TitanUtils_GetNextButton(TitanPanelSettings.Buttons, id, 1, isClockOnRightSide);
					
	if ( id == TITAN_CLOCK_ID and isClockOnRightSide ) then
		-- Get the first icon button
		local firstButton = TitanUtils_GetFirstButton(TitanPanelSettings.Buttons, 1, 1);
		if ( not firstButton ) then
			currentButton:Hide();
		else
			firstButton:ClearAllPoints();
			firstButton:SetPoint("RIGHT", "TitanPanelBarButton", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
			currentButton:Hide();			
		end		
	elseif ( TitanPanelButton_IsIcon(id) ) then
		if ( not nextButton ) then
			currentButton:Hide();
		elseif ( not previousButton ) then
			if (isClockOnRightSide) then
				nextButton:ClearAllPoints();
				nextButton:SetPoint("RIGHT", "TitanPanelClockButton", "LEFT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 			
			else
				nextButton:ClearAllPoints();
				nextButton:SetPoint("RIGHT", "TitanPanelBarButton", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
			end
			currentButton:Hide();
		else
			nextButton:ClearAllPoints();
			nextButton:SetPoint("RIGHT", previousButton:GetName(), "LEFT", -TITAN_PANEL_ICON_SPACEING * scale, 0); 
			currentButton:Hide();
		end	
	else
		if ( not nextButton ) then
			currentButton:Hide();
		elseif ( not previousButton ) then
			nextButton:ClearAllPoints();
			nextButton:SetPoint("LEFT", "TitanPanelBarButton", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
			currentButton:Hide();
		else
			nextButton:ClearAllPoints();
			nextButton:SetPoint("LEFT", previousButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0); 
			currentButton:Hide();
		end	
	end
				
	table.remove(TitanPanelSettings.Buttons, TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, id));

	TitanPanelButton_Justify();
end

function TitanPanel_AddButton(id)
	if (not TitanPanelSettings) then
		return;
	end 

	-- Check if clock displayed on the far right side
	local isClockOnRightSide;
	if ( TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, TITAN_CLOCK_ID) and
			TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		isClockOnRightSide = 1;
	end

	local scale = TitanPanelGetVar("Scale");
	local currentButton = TitanUtils_GetButton(id);
	local lastButton = TitanUtils_GetLastButton(TitanPanelSettings.Buttons, 1, TitanPanelButton_IsIcon(id), isClockOnRightSide);
	
	if ( id == TITAN_CLOCK_ID and TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		-- Clock button on the far right side anyway
		currentButton:ClearAllPoints();
		currentButton:SetPoint("RIGHT", "TitanPanelBarButton", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 

		-- Adjust first icon button position
		local firstButton = TitanUtils_GetFirstButton(TitanPanelSettings.Buttons, 1, 1);
		if ( firstButton ) then
			firstButton:ClearAllPoints();
			firstButton:SetPoint("RIGHT", "TitanPanelClockButton", "LEFT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 			
		end		
	
	elseif ( TitanPanelButton_IsIcon(id) ) then
		if ( lastButton ) then
			currentButton:ClearAllPoints();
			currentButton:SetPoint("RIGHT", lastButton:GetName(), "LEFT", -TITAN_PANEL_ICON_SPACEING * scale, 0); 
		else
			if (isClockOnRightSide) then
				currentButton:ClearAllPoints();
				currentButton:SetPoint("RIGHT", "TitanPanelClockButton", "LEFT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 			
			else
				currentButton:ClearAllPoints();
				currentButton:SetPoint("RIGHT", "TitanPanelBarButton", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
			end
		end
	else
		if ( lastButton ) then
			currentButton:ClearAllPoints();
			currentButton:SetPoint("LEFT", lastButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0); 
		else
			currentButton:ClearAllPoints();
			currentButton:SetPoint("LEFT", "TitanPanelBarButton", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
		end
	end
		
	table.insert(TitanPanelSettings.Buttons, id);		

	currentButton:Show();	
	TitanPanelButton_Justify();	
end

function TitanPanel_RefreshPanelButtons()
	if (TitanPanelSettings) then
		for i = 1, table.getn(TitanPanelSettings.Buttons) do		
			TitanPanelButton_UpdateButton(TitanPanelSettings.Buttons[i], 1);		
		end
	end
end

function TitanPanelButton_Justify()	
	if ( not TITAN_PANEL_BUTTONS_INIT_FLAG or not TitanPanelSettings ) then
		return;
	end

	-- Check if clock displayed on the far right side
	local isClockOnRightSide;
	if ( TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, TITAN_CLOCK_ID) and
			TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		isClockOnRightSide = 1;
	end
	
	local firstLeftButton = TitanUtils_GetFirstButton(TitanPanelSettings.Buttons, 1, nil, isClockOnRightSide);	
	local scale = TitanPanelGetVar("Scale");
	if ( firstLeftButton ) then
		if ( TitanPanelGetVar("ButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_LEFT ) then
			firstLeftButton:ClearAllPoints();
			firstLeftButton:SetPoint("LEFT", "TitanPanelBarButton", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
		
		elseif ( TitanPanelGetVar("ButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER ) then
			local leftWidth = 0;
			local rightWidth = 0;
			for index, id in TitanPanelSettings.Buttons do 
				local button = TitanUtils_GetButton(id);
				if ( not button:GetWidth() ) then 
					return; 
				end
				
				if ( TitanPanelButton_IsIcon(id) or (id == TITAN_CLOCK_ID and isClockOnRightSide) ) then
					rightWidth = rightWidth + TITAN_PANEL_ICON_SPACEING + button:GetWidth();
				else
					leftWidth = leftWidth + TITAN_PANEL_FRAME_SPACEING + button:GetWidth();
				end
			end

			firstLeftButton:ClearAllPoints();
			firstLeftButton:SetPoint("LEFT", "TitanPanelBarButton", "CENTER", 0 - leftWidth / 2, 0); 
		end
	end
end

function TitanPanel_SetScale()
	local scale = UIParent:GetScale() * TitanPanelGetVar("Scale");
	TitanPanelBarButton:SetScale(scale);
	for index, value in TitanPlugins do
		TitanUtils_GetButton(index):SetScale(scale);
	end
end

function TitanPanelRightClickMenu_Customize() 
	StaticPopupDialogs["CUSTOMIZATION_FEATURE_COMING_SOON"] = {
		text = TEXT(CUSTOMIZATION_FEATURE_COMING_SOON),
		button1 = TEXT(OKAY),
		showAlert = 1,
		timeout = 0,
	};
	StaticPopup_Show("CUSTOMIZATION_FEATURE_COMING_SOON");
end

function TitanPanelRightClickMenu_PrepareBarMenu()
	local info = {};
	local checked;
	local plugin;

	-- Level 2
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		if ( UIDROPDOWNMENU_MENU_VALUE == "Builtins" ) then
			TitanPanelRightClickMenu_AddTitle(TITAN_PANEL_MENU_LEFT_SIDE, UIDROPDOWNMENU_MENU_LEVEL);
			
			for index, id in TitanPluginsIndex do
				plugin = TitanUtils_GetPlugin(id);
				if ( plugin.builtIn and ( TitanPanel_GetPluginSide(id) == "Left") ) then
					checked = nil;
					if ( TitanPanel_IsPluginShown(id) ) then
						checked = 1;
					end
			
					info = {};
					info.text = plugin.menuText;
					info.value = id;
					info.func = TitanPanelRightClickMenu_BarOnClick;
					info.checked = checked;
					info.keepShownOnClick = 1;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
			
			TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);	

			TitanPanelRightClickMenu_AddTitle(TITAN_PANEL_MENU_RIGHT_SIDE, UIDROPDOWNMENU_MENU_LEVEL);

			for index, id in TitanPluginsIndex do
				plugin = TitanUtils_GetPlugin(id);
				if ( plugin.builtIn and ( TitanPanel_GetPluginSide(id) == "Right") ) then
					checked = nil;
					if ( TitanPanel_IsPluginShown(id) ) then
						checked = 1;
					end
			
					info = {};
					info.text = plugin.menuText;
					info.value = id;
					info.func = TitanPanelRightClickMenu_BarOnClick;
					info.checked = checked;
					info.keepShownOnClick = 1;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
		end		
		return;
	end

	-- Level 1
	TitanPanelRightClickMenu_AddTitle(TITAN_PANEL_MENU_TITLE);

	info = {};
	info.text = TITAN_PANEL_MENU_BUILTINS;
	info.value = "Builtins";
	info.hasArrow = 1;
	UIDropDownMenu_AddButton(info);

	for index, id in TitanPluginsIndex do
		plugin = TitanUtils_GetPlugin(id);
		if (not plugin.builtIn) then
			checked = nil;
			if ( TitanPanel_IsPluginShown(id) ) then
				checked = 1;
			end
			
			info = {};
			info.text = plugin.menuText;
			info.value = id;
			info.func = TitanPanelRightClickMenu_BarOnClick;
			info.checked = checked;
			info.keepShownOnClick = 1;
			UIDropDownMenu_AddButton(info);
		end
	end

	TitanPanelRightClickMenu_AddSpacer();	

	info = {};
	info.text = TITAN_PANEL_MENU_AUTOHIDE;
	info.func = TitanPanelBarButton_ToggleAutoHide;
	info.checked = TitanPanelGetVar("AutoHide");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_PANEL_MENU_CENTER_TEXT;
	info.func = TitanPanelBarButton_ToggleAlign;
	info.checked = (TitanPanelGetVar("ButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER);
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_PANEL_MENU_DISPLAY_ONTOP;
	info.func = TitanPanelBarButton_TogglePosition;
	info.checked = (TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_TOP);
	UIDropDownMenu_AddButton(info);
end

function TitanPanel_IsPluginShown(id)
	if ( id and TitanPanelSettings ) then
		return TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, id);
	end
end

function TitanPanel_GetPluginSide(id)
	if ( id == TITAN_CLOCK_ID and TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		return "Right";
	elseif ( TitanPanelButton_IsIcon(id) ) then
		return "Right";
	else
		return "Left";
	end
end

