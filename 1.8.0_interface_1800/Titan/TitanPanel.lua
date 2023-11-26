TITAN_PANEL_FRAME_SPACEING = 20;
TITAN_PANEL_ICON_SPACEING = 4;
TITAN_PANEL_BUTTON_WIDTH_CHANGE_TOLERANCE = 10;
TITAN_AUTOHIDE_WAIT_TIME = 0.5;
TITAN_PANEL_INITIAL_PLUGINS = {"Coords", "XP", "LootType", "Clock", "Volume", "UIScale", "Trans", "AutoHide", "HonorPlus", "Bag", "Money", "AuxAutoHide", "Repair", "ItemBonuses"};
TITAN_PANEL_INITIAL_PLUGIN_LOCATION = {"Bar", "Bar", "Bar", "Bar", "Bar", "Bar", "Bar", "Bar", "AuxBar", "AuxBar", "AuxBar", "AuxBar", "AuxBar", "AuxBar"};

TITAN_PANEL_BUTTONS_ALIGN_LEFT = 1;
TITAN_PANEL_BUTTONS_ALIGN_CENTER = 2;
TITAN_PANEL_BUTTONS_ALIGN_RIGHT = 3;

TITAN_PANEL_BARS_SINGLE = 1;
TITAN_PANEL_BARS_DOUBLE = 2;


TITAN_PANEL_BUTTONS_INIT_FLAG = nil;
TITAN_PANEL_SELECTED = "Bar";

TITAN_PANEL_SAVED_VARIABLES = {
	Buttons = TITAN_PANEL_INITIAL_PLUGINS,
	Location = TITAN_PANEL_INITIAL_PLUGIN_LOCATION,
	Transparency = 0.7,
	Scale = 1,
	FontScale = 1,
	ScreenAdjust = TITAN_NIL,
	AutoHide = TITAN_NIL,
	Position = TITAN_PANEL_PLACE_TOP;
	DoubleBar = TITAN_PANEL_BARS_SINGLE;
	ButtonAlign = TITAN_PANEL_BUTTONS_ALIGN_LEFT;
	BothBars = 1;
	AuxScreenAdjust = TITAN_NIL,
	AuxAutoHide = TITAN_NIL,
	AuxDoubleBar = TITAN_PANEL_BARS_SINGLE;
	AuxButtonAlign = TITAN_PANEL_BUTTONS_ALIGN_LEFT;
}

MenuPresent = 0;

function TitanPanelBarButton_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("TIME_PLAYED_MSG");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("CVAR_UPDATE");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TitanPanelBarButton_OnEvent(frame)
	if frame == "TitanPanelBarButton" then
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
	
			-- Set initial Panel AutoHide
			if (TitanPanelGetVar("AutoHide")) then
				TitanPanelBarButton_Hide("TitanPanelBarButton", TitanPanelGetVar("Position"));
			end
			if (TitanPanelGetVar("AuxAutoHide")) then
				TitanPanelBarButton_Hide("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
			end		
	
			TitanPanel_SetTransparent("TitanPanelBarButtonHider", TitanPanelGetVar("Position"));
			
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
end

function TitanPanelBarButtonHider_OnUpdate(elapsed)
	local x, y = GetCursorPosition(UIParent);

	if (TitanPanelGetVar("AutoHide") or TitanPanelGetVar("AuxAutoHide")) then
		TITAN_PANEL_SELECTED = TitanUtils_GetButtonID(this:GetName())
		-- Toggle menu
		if (TitanPanelRightClickMenu_IsVisible()) then
			--Menu present do not close bar
		else
			if TITAN_PANEL_SELECTED == "Bar" and TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_TOP then
				if y < TitanPanelBarButtonHider:GetBottom() and TitanPanelBarButtonHider.isCounting == nil then
					TitanUtils_StartAutoHideCounting("TitanPanelBarButtonHider");
				end
			elseif TITAN_PANEL_SELECTED == "Bar" and TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_BOTTOM then
				if y > TitanPanelBarButtonHider:GetTop() and TitanPanelBarButtonHider.isCounting == nil then
					TitanUtils_StartAutoHideCounting("TitanPanelBarButtonHider");
				end
			elseif TITAN_PANEL_SELECTED == "AuxBar" then
				if y > TitanPanelAuxBarButtonHider:GetTop() and TitanPanelAuxBarButtonHider.isCounting == nil then
					TitanUtils_StartAutoHideCounting("TitanPanelAuxBarButtonHider");
				end
			end
		end
	end

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

function TitanPanelBarButtonHider_OnEnter(frame)
	if (TitanPanelGetVar("AutoHide") or TitanPanelGetVar("AuxAutoHide")) then
		TitanUtils_StopAutoHideCounting(frame);

		if (frame == "TitanPanelBarButtonHider") then
			if (TitanPanelBarButton.hide) then
				TitanPanelBarButton_Show("TitanPanelBarButton", TitanPanelGetVar("Position"));
			end
		else
			if (TitanPanelAuxBarButton.hide) then
				if TitanPanelGetVar("BothBars") then
					TitanPanelBarButton_Show("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
				end
			end
		end
	end
end

function TitanPanelBarButtonHider_OnLeave(frame)
  --Removed
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

function TitanPanelBarButton_ToggleAuxAlign()
	if ( TitanPanelGetVar("AuxButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER ) then
		TitanPanelSetVar("AuxButtonAlign", TITAN_PANEL_BUTTONS_ALIGN_LEFT);
	else
		TitanPanelSetVar("AuxButtonAlign", TITAN_PANEL_BUTTONS_ALIGN_CENTER);
	end
	
	-- Justify button position
	TitanPanelButton_Justify();
end

function TitanPanelBarButton_ToggleDoubleBar()
	if ( TitanPanelGetVar("DoubleBar") == TITAN_PANEL_BARS_SINGLE ) then
		TitanPanelSetVar("DoubleBar", TITAN_PANEL_BARS_DOUBLE);
		TitanPanelBarButtonHider:SetHeight(48);
	else
		TitanPanelSetVar("DoubleBar", TITAN_PANEL_BARS_SINGLE);
		TitanPanelBarButtonHider:SetHeight(24);
	end
	
	TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
	TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"), TitanPanelGetVar("DoubleBar"));
	TitanMovableFrame_AdjustBlizzardFrames();
	TitanPanel_InitPanelBarButton();
	TitanPanel_InitPanelButtons();		
	TitanPanel_SetTransparent("TitanPanelBarButtonHider", TitanPanelGetVar("Position"));

	if (TitanPanelGetVar("AutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelBarButton", TitanPanelGetVar("Position"));
	end
	if (TitanPanelGetVar("AuxAutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
	end		

end

function TitanPanelBarButton_ToggleAuxDoubleBar()
	if ( TitanPanelGetVar("AuxDoubleBar") == TITAN_PANEL_BARS_SINGLE ) then
		TitanPanelSetVar("AuxDoubleBar", TITAN_PANEL_BARS_DOUBLE);
		TitanPanelAuxBarButtonHider:SetHeight(48);
	else
		TitanPanelSetVar("AuxDoubleBar", TITAN_PANEL_BARS_SINGLE);
		TitanPanelAuxBarButtonHider:SetHeight(24);
	end
	TitanMovableFrame_CheckFrames(TITAN_PANEL_PLACE_BOTTOM);
	TitanMovableFrame_MoveFrames(TITAN_PANEL_PLACE_BOTTOM, 1);
	TitanMovableFrame_AdjustBlizzardFrames();
	TitanPanel_InitPanelBarButton();
	TitanPanel_InitPanelButtons();		
	TitanPanel_SetTransparent("TitanPanelAuxBarButtonHider", TITAN_PANEL_PLACE_BOTTOM);

	if (TitanPanelGetVar("AutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelBarButton", TitanPanelGetVar("Position"));
	end
	if (TitanPanelGetVar("AuxAutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelAuxBarButton", TitanPanelGetVar("Position"));
	end		

end

function TitanPanelBarButton_ToggleAutoHide()
	TitanPanelToggleVar("AutoHide");
	if (TitanPanelGetVar("AutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelBarButton", TitanPanelGetVar("Position"));
	else
		TitanPanelBarButton_Show("TitanPanelBarButton", TitanPanelGetVar("Position"));
	end
	TitanPanelAutoHideButton_SetIcon();
end

function TitanPanelBarButton_ToggleAuxAutoHide()
	TitanPanelToggleVar("AuxAutoHide");
	if (TitanPanelGetVar("AuxAutoHide")) then
		if TitanPanelGetVar("BothBars") then
			TitanPanelBarButton_Hide("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
		end
	else
		if TitanPanelGetVar("BothBars") then
			TitanPanelBarButton_Show("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
		end
	end
	--Needs changing!
	TitanPanelAuxAutoHideButton_SetIcon();
end

function TitanPanelBarButton_ToggleScreenAdjust()
	TitanPanelToggleVar("ScreenAdjust");
	TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
	TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"), TitanPanelGetVar("ScreenAdjust"));
	TitanMovableFrame_AdjustBlizzardFrames();
end

function TitanPanelBarButton_ToggleAuxScreenAdjust()
	TitanPanelToggleVar("AuxScreenAdjust");
	TitanMovableFrame_CheckFrames(TITAN_PANEL_PLACE_BOTTOM);
	TitanMovableFrame_MoveFrames(TITAN_PANEL_PLACE_BOTTOM, TitanPanelGetVar("AuxScreenAdjust"));
	TitanMovableFrame_AdjustBlizzardFrames();
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
	TitanPanel_SetPosition("TitanPanelBarButton", TitanPanelGetVar("Position"));
	TitanPanel_SetTexture("TitanPanelBarButton", TitanPanelGetVar("Position"));
	TitanPanel_SetTransparent("TitanPanelBarButtonHider", TitanPanelGetVar("Position"));
	
	-- Adjust frame positions
	TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));
	TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
	TitanMovableFrame_AdjustBlizzardFrames();
end

function TitanPanelBarButton_ToggleBarsShown()
	TitanPanelToggleVar("BothBars");
	TitanPanelBarButton_DisplayBarsWanted();
end
	
function TitanPanelBarButton_DisplayBarsWanted()
	--Need to handle top & bottom
	if (TitanPanelGetVar("BothBars")) then
		if (TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_BOTTOM) then
			TitanPanelBarButton_TogglePosition();
		end

		TitanMovableFrame_CheckFrames(TITAN_PANEL_PLACE_TOP);
		TitanMovableFrame_MoveFrames(TITAN_PANEL_PLACE_BOTTOM);

		-- Set panel position and texture
		TitanPanel_SetPosition("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
		TitanPanel_SetTexture("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
	
		-- Adjust frame positions
		TitanMovableFrame_CheckFrames(TITAN_PANEL_PLACE_BOTTOM);
		TitanMovableFrame_MoveFrames(TITAN_PANEL_PLACE_BOTTOM);
		TitanMovableFrame_AdjustBlizzardFrames();
		
	else
		TitanPanelBarButton_TogglePosition();
		TitanPanelBarButton_Hide("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM)
		TitanPanelBarButton_TogglePosition();
	end
end

function TitanPanelBarButton_Show(frame, position)
	local frName = getglobal(frame);
	local barnumber = TitanUtils_GetDoubleBar(TitanPanelGetVar("BothBars"), position);

	if (position == TITAN_PANEL_PLACE_TOP) then
		frName:ClearAllPoints();	
		frName:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
		frName:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -24); 
	else
		frName:ClearAllPoints();
		frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24); 
	end
	
	frName.hide = nil;
end

function TitanPanelBarButton_Hide(frame, position)
	local frName = getglobal(frame);
	local barnumber = TitanUtils_GetDoubleBar(TitanPanelGetVar("BothBars"), position);

	if frName ~= nil then

		if (position == TITAN_PANEL_PLACE_TOP) then
			frName:ClearAllPoints();
			frName:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, (35*barnumber)); 
			frName:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -3);
			
		elseif  (position == TITAN_PANEL_PLACE_BOTTOM) and frame == "TitanPanelBarButton" then
			frName:ClearAllPoints();
			frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, -35); 
			frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 3);
		
		else
			if TitanPanelGetVar("BothBars") == nil and frame == "TitanPanelAuxBarButton" then
				frName:ClearAllPoints();
				frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, (-35*barnumber)); 
				frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, -35);
			else
				frName:ClearAllPoints();
				frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, (-35*barnumber)); 
				frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, -35);
			end
		end
	
		frName.hide = 1;
	end
end

function TitanPanel_InitPanelBarButton()
	-- Set Titan Panel position/textures
	TitanPanel_SetPosition("TitanPanelBarButton", TitanPanelGetVar("Position"));
	TitanPanel_SetTexture("TitanPanelBarButton", TitanPanelGetVar("Position"));

	-- Set initial Panel Scale
	TitanPanel_SetScale();		

	-- Set initial Panel Transparency
	TitanPanelBarButton:SetAlpha(TitanPanelGetVar("Transparency"));		
	TitanPanelAuxBarButton:SetAlpha(TitanPanelGetVar("Transparency"));		
end

function TitanPanel_SetPosition(frame, position)
	local frName = getglobal(frame);
	if (position == TITAN_PANEL_PLACE_TOP) then
		frName:ClearAllPoints();
		frName:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
		frName:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -24);
	else
		frName:ClearAllPoints();
		frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24); 
	end
end

function TitanPanel_SetTransparent(frame, position)
	local frName = getglobal(frame);
	local topBars = TitanUtils_GetDoubleBar(TitanPanelGetVar("BothBars"), TITAN_PANEL_PLACE_TOP);
	local bottomBars = TitanUtils_GetDoubleBar(TitanPanelGetVar("BothBars"), TITAN_PANEL_PLACE_BOTTOM);
	
	if (position == TITAN_PANEL_PLACE_TOP) then
		frName:ClearAllPoints();
		frName:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
		frName:SetPoint("BOTTOMRIGHT", "UIParent", "TOPRIGHT", 0, -24 * topBars);
		TitanPanelAuxBarButtonHider:ClearAllPoints();
		TitanPanelAuxBarButtonHider:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		TitanPanelAuxBarButtonHider:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24 * bottomBars); 
	elseif position == TITAN_PANEL_PLACE_BOTTOM and frame == "TitanPanelBarButtonHider" then
		frName:ClearAllPoints();
		frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24 * bottomBars); 
		TitanPanelAuxBarButtonHider:ClearAllPoints();
		TitanPanelAuxBarButtonHider:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		TitanPanelAuxBarButtonHider:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 0); 
	else
		frName:ClearAllPoints();
		frName:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 0, 0); 
		frName:SetPoint("TOPRIGHT", "UIParent", "BOTTOMRIGHT", 0, 24 * bottomBars); 
	end
end

function TitanPanel_SetTexture(frame, position)
	local frName = getglobal(frame);
	local barnumber = TitanUtils_GetDoubleBar(TitanPanelGetVar("BothBars"), position);
	
	if frame == "TitanPanelBarButton" then
		local pos = TitanUtils_Ternary(position == TITAN_PANEL_PLACE_TOP, "Top", "Bottom");
		for i = 0, 11 do
			getglobal("TitanPanelBackground"..i):SetTexture(TITAN_ARTWORK_PATH.."TitanPanelBackground"..pos..math.mod(i, 2));
		end
		for i = 12, 22 do
			if barnumber == 2 then
				TitanPanelBarButtonHider:SetHeight(48);
				getglobal("TitanPanelBackground"..i):SetTexture(TITAN_ARTWORK_PATH.."TitanPanelBackground"..pos..math.mod(i, 2));
			else
				TitanPanelBarButtonHider:SetHeight(24);
				getglobal("TitanPanelBackground"..i):SetTexture();
			end
		end
	else
		local pos = TitanUtils_Ternary(position == TITAN_PANEL_PLACE_BOTTOM, "Top", "Bottom");
		for i = 0, 11 do
			getglobal("TitanPanelBackgroundAux"..i):SetTexture(TITAN_ARTWORK_PATH.."TitanPanelBackground".."Bottom"..math.mod(i, 2));
		end
		for i = 12, 22 do
			if barnumber == 2 then
				TitanPanelAuxBarButtonHider:SetHeight(48);
				getglobal("TitanPanelBackgroundAux"..i):SetTexture(TITAN_ARTWORK_PATH.."TitanPanelBackground".."Bottom"..math.mod(i, 2));
			else
				TitanPanelAuxBarButtonHider:SetHeight(24);
				getglobal("TitanPanelBackgroundAux"..i):SetTexture();
			end
		end
	end
end

function TitanPanel_InitPanelButtons()
	local button, leftButton, rightButton, leftAuxButton, rightAuxButton, leftDoubleButton, rightDoubleButton, leftAuxDoubleButton, rightAuxDoubleButton;
	local nextLeft, nextAuxLeft
	local newButtons = {};
	local scale = TitanPanelGetVar("Scale");
	local isClockOnRightSide;

	TitanPanelBarButton_DisplayBarsWanted();
	-- Position Clock first if it's displayed on the far right side
	if ( TitanUtils_TableContainsValue(TitanPanelSettings.Buttons, TITAN_CLOCK_ID) and TitanGetVar(TITAN_CLOCK_ID, "DisplayOnRightSide") ) then
		isClockOnRightSide = 1;
		button = TitanUtils_GetButton(TITAN_CLOCK_ID);
		local i = TitanPanel_GetButtonNumber(TITAN_CLOCK_ID)
		if TitanPanelSettings.Location[i] == nil then
			TitanPanelSettings.Location[i] = "Bar";
		end
		button:SetPoint("RIGHT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0);
		if TitanPanelSettings.Location[i] == "AuxBar" then
			rightAuxButton = button;
		else
			rightButton = button;
		end
	end
	
	-- Position all the buttons 
	for index, id in TitanPanelSettings.Buttons do 
		if ( TitanUtils_IsPluginRegistered(id) ) then
		
			local i = TitanPanel_GetButtonNumber(id);
			if(TitanPanelSettings.Location[i] == nil) then
				if id ~= "AuxAutoHide" then
					TitanPanelSettings.Location[i] = "Bar";
				else
					TitanPanelSettings.Location[i] = "AuxBar";
				end
			end
		
			button = TitanUtils_GetButton(id);

			if ( id == TITAN_CLOCK_ID and isClockOnRightSide ) then
				-- Do nothing, since it's already positioned
			elseif ( TitanPanelButton_IsIcon(id) ) then	
			
				if ( rightAuxButton and TitanPanelSettings.Location[i] == "AuxBar" ) then
					button:SetPoint("RIGHT", rightAuxButton:GetName(), "LEFT", -TITAN_PANEL_ICON_SPACEING * scale, 0); 
				elseif ( not rightButton ) then
					button:SetPoint("RIGHT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
				else
					if ( not rightAuxButton and TitanPanelSettings.Location[i] == "AuxBar") then
						button:SetPoint("RIGHT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "RIGHT", -TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
					elseif TitanPanelSettings.Location[i] == "AuxBar" then
						button:SetPoint("RIGHT", rightAuxButton:GetName(), "LEFT", -TITAN_PANEL_ICON_SPACEING * scale, 0); 
					else
						button:SetPoint("RIGHT", rightButton:GetName(), "LEFT", -TITAN_PANEL_ICON_SPACEING * scale, 0); 
					end
				end

				if TitanPanelSettings.Location[i] == "AuxBar" then
					rightAuxButton = button;
				else
					rightButton = button;
				end
			else			
				if ( TitanPanelSettings.Location[i] == "AuxBar" ) then
					if (nextAuxLeft == "Double") then
						button:SetPoint("LEFT", leftAuxDoubleButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0);
						nextAuxLeft = "Main"
						leftAuxDoubleButton = button;
					elseif (nextAuxLeft == "DoubleFirst") then
						button:SetPoint("LEFT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 25);
						nextAuxLeft = "Main"
						leftAuxDoubleButton = button;
					elseif (nextAuxLeft == "Main") then
						button:SetPoint("LEFT", leftAuxButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0);
						nextAuxLeft = TitanPanel_Nextbar("AuxDoubleBar");
						leftAuxButton = button;
					else
						button:SetPoint("LEFT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0);
						nextAuxLeft = TitanPanel_Nextbar("AuxDoubleBar");
						if nextAuxLeft == "Double" then
							nextAuxLeft = "DoubleFirst";
						end
						leftAuxButton = button;
					end
				else	
					if (nextLeft == "Double") then
						button:SetPoint("LEFT", leftDoubleButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0);
						nextLeft = "Main"
						leftDoubleButton = button;
					elseif (nextLeft == "DoubleFirst") then
						button:SetPoint("LEFT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, -25);
						nextLeft = "Main"
						leftDoubleButton = button;
					elseif (nextLeft == "Main") then
						button:SetPoint("LEFT", leftButton:GetName(), "RIGHT", TITAN_PANEL_FRAME_SPACEING * scale, 0);
						nextLeft = TitanPanel_Nextbar("DoubleBar");
						leftButton = button;
					else
						button:SetPoint("LEFT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0);
						nextLeft = TitanPanel_Nextbar("DoubleBar");
						if nextLeft == "Double" then
							nextLeft = "DoubleFirst";
						end
						leftButton = button;
					end
				end
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

function TitanPanel_Nextbar(var)
	if TitanPanelGetVar(var) == TITAN_PANEL_BARS_DOUBLE then
		return "Double";
	else
		return "Main";
	end
end

function TitanPanel_RemoveButton(id)
	if ( not TitanPanelSettings ) then
		return;
	end 
	
	local i = TitanPanel_GetButtonNumber(id)
	local currentButton = TitanUtils_GetButton(id);
	currentButton:Hide();					

	TitanPanel_ReOrder(i);
	table.remove(TitanPanelSettings.Buttons, TitanUtils_GetCurrentIndex(TitanPanelSettings.Buttons, id));
	TitanPanel_InitPanelButtons();
end

function TitanPanel_AddButton(id)
	if (not TitanPanelSettings) then
		return;
	end 

	local i = TitanPanel_GetButtonNumber(id)
	TitanPanelSettings.Location[i] = TITAN_PANEL_SELECTED;

	table.insert(TitanPanelSettings.Buttons, id);	

	TitanPanel_InitPanelButtons();
end

function TitanPanel_ReOrder(index)
	for i = index, table.getn(TitanPanelSettings.Buttons) do		
		TitanPanelSettings.Location[i] = TitanPanelSettings.Location[i+1]
	end
end

function TitanPanel_GetButtonNumber(id)
	if (TitanPanelSettings) then
		for i = 1, table.getn(TitanPanelSettings.Buttons) do		
			if(TitanPanelSettings.Buttons[i] == id) then
				return i;
			end	
		end
		return table.getn(TitanPanelSettings.Buttons)+1;
	else
		return 0;
	end
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

				if TitanUtils_GetWhichBar(id) == "Bar" then
					if ( TitanPanelButton_IsIcon(id) or (id == TITAN_CLOCK_ID and isClockOnRightSide) ) then
						rightWidth = rightWidth + TITAN_PANEL_ICON_SPACEING + button:GetWidth();
					else
						leftWidth = leftWidth + TITAN_PANEL_FRAME_SPACEING + button:GetWidth();
					end
				end
			end

			firstLeftButton:ClearAllPoints();
			firstLeftButton:SetPoint("LEFT", "TitanPanelBarButton", "CENTER", 0 - leftWidth / 2, 0); 
		end
	end

	local firstLeftButton = TitanUtils_GetFirstAuxButton(TitanPanelSettings.Buttons, 1, nil, isClockOnRightSide);	
	if ( firstLeftButton ) then
		if ( TitanPanelGetVar("AuxButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_LEFT ) then
			firstLeftButton:ClearAllPoints();
			firstLeftButton:SetPoint("LEFT", "TitanPanelAuxBarButton", "LEFT", TITAN_PANEL_FRAME_SPACEING / 2 * scale, 0); 
		
		elseif ( TitanPanelGetVar("AuxButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER ) then
			local leftWidth = 0;
			local rightWidth = 0;
			for index, id in TitanPanelSettings.Buttons do
				local button = TitanUtils_GetButton(id);
				if ( not button:GetWidth() ) then 
					return; 
				end

				if TitanUtils_GetWhichBar(id) == "AuxBar" then
					if ( TitanPanelButton_IsIcon(id) or (id == TITAN_CLOCK_ID and isClockOnRightSide) ) then
						rightWidth = rightWidth + TITAN_PANEL_ICON_SPACEING + button:GetWidth();
					else
						leftWidth = leftWidth + TITAN_PANEL_FRAME_SPACEING + button:GetWidth();
					end
				end
			end

			firstLeftButton:ClearAllPoints();
			firstLeftButton:SetPoint("LEFT", "TitanPanelAuxBarButton", "CENTER", 0 - leftWidth / 2, 0); 
		end
	end

end

function TitanPanel_SetScale()
	local scale = UIParent:GetScale() * TitanPanelGetVar("Scale");
	local fontscale = UIParent:GetScale() * TitanPanelGetVar("FontScale");
	TitanPanelBarButton:SetScale(scale);
	GameTooltip:SetScale(fontscale);
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
	local frame = this:GetName();
	local frname = getglobal(frame);

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
			
					if id ~= "AuxAutoHide" then
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
		if ( UIDROPDOWNMENU_MENU_VALUE == "BuiltinsAux" ) then
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
			
					if id ~= "AutoHide" then
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
		
		if ( UIDROPDOWNMENU_MENU_VALUE == "Settings" ) then
			for index, id in TitanSettings.Players do
				info = {};
				info.text = index;
				info.value = index;
				info.func = TitanVariables_UseSettings;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;
		end
	end

	-- Level 1
	TitanPanelRightClickMenu_AddTitle(TITAN_PANEL_MENU_TITLE);

	if frame == "TitanPanelBarButton" then
		info = {};
		info.text = TITAN_PANEL_MENU_BUILTINS;
		info.value = "Builtins";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
	else
		info = {};
		info.text = TITAN_PANEL_MENU_BUILTINS;
		info.value = "BuiltinsAux";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
	end

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

	if frame == "TitanPanelBarButton" then
		info = {};
		info.text = TITAN_PANEL_MENU_AUTOHIDE;
		info.func = TitanPanelBarButton_ToggleAutoHide;
		info.checked = TitanPanelGetVar("AutoHide");
		UIDropDownMenu_AddButton(info);
	else
		info = {};
		info.text = TITAN_PANEL_MENU_AUTOHIDE;
		info.func = TitanPanelBarButton_ToggleAuxAutoHide;
		info.checked = TitanPanelGetVar("AuxAutoHide");
		UIDropDownMenu_AddButton(info);
	end

	if frame == "TitanPanelBarButton" then
		info = {};
		info.text = TITAN_PANEL_MENU_CENTER_TEXT;
		info.func = TitanPanelBarButton_ToggleAlign;
		info.checked = (TitanPanelGetVar("ButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER);
		UIDropDownMenu_AddButton(info);
	else
		info = {};
		info.text = TITAN_PANEL_MENU_CENTER_TEXT;
		info.func = TitanPanelBarButton_ToggleAuxAlign;
		info.checked = (TitanPanelGetVar("AuxButtonAlign") == TITAN_PANEL_BUTTONS_ALIGN_CENTER);
		UIDropDownMenu_AddButton(info);
	end

	info = {};
	info.text = TITAN_PANEL_MENU_DISPLAY_ONTOP;
	info.func = TitanPanelBarButton_TogglePosition;
	info.checked = (TitanPanelGetVar("Position") == TITAN_PANEL_PLACE_TOP);
	info.disabled = TitanPanelGetVar("BothBars")
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_PANEL_MENU_DISPLAY_BOTH;
	info.func = TitanPanelBarButton_ToggleBarsShown;
	info.checked = TitanPanelGetVar("BothBars");
	UIDropDownMenu_AddButton(info);

	if frame == "TitanPanelBarButton" then
		info = {};
		info.text = TITAN_PANEL_MENU_DISABLE_PUSH;
		info.func = TitanPanelBarButton_ToggleScreenAdjust;
		info.checked = TitanPanelGetVar("ScreenAdjust");
		UIDropDownMenu_AddButton(info);
	else
		info = {};
		info.text = TITAN_PANEL_MENU_DISABLE_PUSH;
		info.func = TitanPanelBarButton_ToggleAuxScreenAdjust;
		info.checked = TitanPanelGetVar("AuxScreenAdjust");
		UIDropDownMenu_AddButton(info);
	end

	if frame == "TitanPanelBarButton" then
		info = {};
		info.text = TITAN_PANEL_MENU_DOUBLE_BAR;
		info.func = TitanPanelBarButton_ToggleDoubleBar;
		info.checked = TitanPanelGetVar("DoubleBar") == TITAN_PANEL_BARS_DOUBLE;
		UIDropDownMenu_AddButton(info);
	else
		info = {};
		info.text = TITAN_PANEL_MENU_DOUBLE_BAR;
		info.func = TitanPanelBarButton_ToggleAuxDoubleBar;
		info.checked = TitanPanelGetVar("AuxDoubleBar") == TITAN_PANEL_BARS_DOUBLE;
		UIDropDownMenu_AddButton(info);
	end

	info = {};
	info.text = TITAN_PANEL_MENU_LOAD_SETTINGS;
	info.value = "Settings";
	info.hasArrow = 1;
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

TitanPanelDetails = {
	name = "Titan Panel (Multibar)",
	description = "Adds a control panel/info box at the top and bottom of the screen.",
	version = TITAN_VERSION,
	releaseDate = TITAN_LAST_UPDATED,
	author = "TitanMod/Adsertor",
	email = "TitanMod@gmail.com",
	website = "http://ui.worldofwar.net/ui.php?id=576",
	category = MYADDONS_CATEGORY_BARS,
	frame = "TitanPanel",
	optionsframe = "",
};

TitanPanelHelp = {};
TitanPanelHelp[1] = "Titan Panel adds a control panel/info box at the top and bottom of the screen.\n\nFeatures include:\n1. Ammo/Thrown counter\n2. Bag\n3. Experience (XP)\n4. FPS\n5. Latency\n6. Location\n7. Loot Type\n8. Memory\n9. Money\n10. PvP Honor\n11. Clock\n\nAlso build-in controls allow you to:\n1. Adjust master sound volume\n2. Adjust UI Scale\n3. Adjust panel transparency\n4. Toggle auto-hide on/off\n\nFully support plug-ins system. All modules on the panel are plug-n-play. Allows other developers to create plugins to import the new features.\n\n\nThanks go to\n- Sotakone, for providing a bug fix for German clients\n- Kilan, for submitting code which makes Titan Panel save per-realm-per-character";

function TitanPanelFrame_OnLoad()
	-- Register the events that need to be watched
	this:RegisterEvent("VARIABLES_LOADED");
end

function TitanPanelFrame_OnEvent()
	if(event == "VARIABLES_LOADED") then
		-- Check if myAddOns is loaded
		if(myAddOnsFrame_Register) then
			-- Register the addon in myAddOns
			myAddOnsFrame_Register(TitanPanelDetails, TitanPanelHelp);
		end
	end
end