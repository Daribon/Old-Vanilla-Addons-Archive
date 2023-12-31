TITAN_PANEL_MENU_POPUP_IND = "...";
TITAN_PANEL_MENU_FUNC_HIDE = "TitanPanelRightClickMenu_Hide";
TITAN_PANEL_MENU_FUNC_CUSTOMIZE = "TitanPanelRightClickMenu_Customize";

function TitanRightClickMenu_OnLoad()
	local id = TitanUtils_GetButtonIDFromMenu();
	if (id) then
		local prepareFunction = getglobal("TitanPanelRightClickMenu_Prepare"..id.."Menu");
		if (prepareFunction) then
			UIDropDownMenu_Initialize(this, prepareFunction, "MENU");
		end
	end
end

function TitanPanelRightClickMenu_Toggle()
	local position = TitanPanelGetVar("Position");
	local x, y = GetCursorPosition(UIParent); 

	-- Toggle menu
	local menu = getglobal(this:GetName().."RightClickMenu");
	if ( position == TITAN_PANEL_PLACE_TOP ) then 
		menu.point = "TOPLEFT";
		menu.relativePoint = "BOTTOMLEFT";
	else
		menu.point = "BOTTOMLEFT";
		menu.relativePoint = "TOPLEFT";
	end	
	ToggleDropDownMenu(1, nil, menu, "TitanPanelBarButton", TitanUtils_Max(x - 40, 0), 0);
	
	-- Adjust menu position if it's off the screen
	local listFrame = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL);	
	local offscreenX, offscreenY = TitanUtils_GetOffscreen(listFrame);
	if ( offscreenX == 1 ) then
		if ( position == TITAN_PANEL_PLACE_TOP ) then 
			listFrame:ClearAllPoints();
			listFrame:SetPoint("TOPRIGHT", "TitanPanelBarButton", "BOTTOMLEFT", x, 0);
		else
			listFrame:ClearAllPoints();
			listFrame:SetPoint("BOTTOMRIGHT", "TitanPanelBarButton", "TOPLEFT", x, 0);
		end
	end	
end

function TitanPanelRightClickMenu_IsVisible()
	return DropDownList1:IsVisible();
end

function TitanPanelRightClickMenu_Close()
	DropDownList1:Hide();
end

function TitanPanelRightClickMenu_AddTitle(title, level)
	if (title) then
		local info = {};
		info.text = title;
		info.notClickable = 1;
		info.isTitle = 1;
		UIDropDownMenu_AddButton(info, level);
	end
end

function TitanPanelRightClickMenu_AddCommand(text, value, functionName, level)
	local info = {};
	info.text = text;
	info.value = value;
	info.func = getglobal(functionName);
	--info.notCheckable = 1;
	UIDropDownMenu_AddButton(info, level);
end

function TitanPanelRightClickMenu_AddSpacer(level)
	local info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info, level);
end

function TitanPanelRightClickMenu_Hide() 
	TitanPanel_RemoveButton(this.value);
end

function TitanPanelRightClickMenu_AddToggleVar(text, id, var, toggleTable)
	local info = {};
	info.text = text;
	info.value = {id, var, toggleTable};
	info.func = TitanPanelRightClickMenu_ToggleVar;
	info.checked = TitanGetVar(id, var);
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);
end

function TitanPanelRightClickMenu_AddToggleIcon(id)
	TitanPanelRightClickMenu_AddToggleVar(TITAN_PANEL_MENU_SHOW_ICON, id, "ShowIcon");
end

function TitanPanelRightClickMenu_AddToggleLabelText(id)
	TitanPanelRightClickMenu_AddToggleVar(TITAN_PANEL_MENU_SHOW_LABEL_TEXT, id, "ShowLabelText");
end

function TitanPanelRightClickMenu_AddToggleColoredText(id)
	TitanPanelRightClickMenu_AddToggleVar(TITAN_PANEL_MENU_SHOW_COLORED_TEXT, id, "ShowColoredText");
end

function TitanPanelRightClickMenu_ToggleVar()
	local id = this.value[1];
	local var = this.value[2];
	local toggleTable = this.value[3];

	-- Toggle var
	TitanToggleVar(id, var);
	
	if ( TitanPanelRightClickMenu_AllVarNil(id, toggleTable) ) then
		-- Undo if all vars in toggle table nil
		TitanToggleVar(id, var);
	else
		-- Otherwise continue and update the button
		TitanPanelButton_UpdateButton(id, 1);
	end
end

function TitanPanelRightClickMenu_AllVarNil(id, toggleTable)
	if ( toggleTable ) then
		for i, v in toggleTable do
			if ( TitanGetVar(id, v) ) then
				return;
			end
		end	
		return 1;
	end	
end

function TitanPanelRightClickMenu_ToggleColoredText()
	TitanToggleVar(this.value, "ShowColoredText");
	TitanPanelButton_UpdateButton(this.value, 1);
end
