tinsert(UISpecialFrames, "CT_BarModOptionsFrame");
CT_BarModOptions_Options = { };

function CT_BarModOptions_Slider_OnShow(slider)
	if ( not slider ) then
		slider = this;
	end
	local names = {
		"Left Hotbar Scaling",
		"Right Hotbar Scaling",
		"Left Sidebar Scaling",
		"Right Sidebar Scaling",
		"Top Hotbar Scaling",
		"Main Bar Scaling"
	};
	getglobal(slider:GetName().."High"):SetText("150%");
	getglobal(slider:GetName().."Low"):SetText("50%")
	getglobal(slider:GetName() .. "Text"):SetText(names[slider:GetID()] .. " - " .. floor(CT_BarModOptions_Options[UnitName("player")][slider:GetID()]*100+0.5) .. "%");

	slider:SetMinMaxValues(0.5, 1.5);
	slider:SetValueStep(0.01);
	slider:SetValue(CT_BarModOptions_Options[UnitName("player")][slider:GetID()]);
	
	if ( slider:GetID() == 6 ) then
		slider.tooltipText = "Requires Main Bar's texture to be hidden using CT_BottomBar in order to take effect.";
	end
end

function CT_BarModOptions_Slider_OnValueChanged()
	local names = {
		"Left Hotbar Scaling",
		"Right Hotbar Scaling",
		"Left Sidebar Scaling",
		"Right Sidebar Scaling",
		"Top Hotbar Scaling",
		"Main Bar Scaling"
	};
	
	CT_BarModOptions_Options[UnitName("player")][this:GetID()] = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText(names[this:GetID()] .. " - " .. floor(this:GetValue()*100+0.5) .. "%");
	
	local prefix = "CT"..this:GetID() .. "_";
	if ( this:GetID() == 1 ) then
		prefix = "CT_"; -- First bar is prefixed CT and not CT1
	elseif ( this:GetID() == 6 ) then
		if ( not CT_BottomBar_HiddenFrames or not CT_BottomBar_HiddenFrames[UnitName("player")]["BarHotbarBackgroundLeft"] or not CT_BottomBar_Enabled[UnitName("player")] ) then
			return;
		end
		prefix = ""; -- Main bar has no prefix
	end
	
	for i = 1, 12, 1 do
		getglobal(prefix .. "ActionButton" .. i):SetScale(CT_BarModOptions_Options[UnitName("player")][this:GetID()]*UIParent:GetScale());
	end
end

function CT_BarModOptions_LoadOptions()
	if ( not CT_BarModOptions_Options[UnitName("player")] ) then
		CT_BarModOptions_Options[UnitName("player")] = { 1, 1, 1, 1, 1, 1 };
	else
		CT_BarModOptions_Slider_OnShow(CT_BarModOptionsFrameSliderHotbarLeft);
		CT_BarModOptions_Slider_OnShow(CT_BarModOptionsFrameSliderHotbarRight);
		CT_BarModOptions_Slider_OnShow(CT_BarModOptionsFrameSliderSidebarLeft);
		CT_BarModOptions_Slider_OnShow(CT_BarModOptionsFrameSliderSidebarRight);
		CT_BarModOptions_Slider_OnShow(CT_BarModOptionsFrameSliderHotbarTop);
		CT_BarModOptions_Slider_OnShow(CT_BarModOptionsFrameSliderMainBar);
	end
	CT_BarModOptions_RemoveSpaceBars(CT_BarModOptions_Options[UnitName("player")]["removeBars"]);
	CT_BarModOptions_RemoveSpaceBags(CT_BarModOptions_Options[UnitName("player")]["removeBags"]);
	CT_BarModOptions_RemoveSpaceSpecial(CT_BarModOptions_Options[UnitName("player")]["removeSpecial"]);
	CT_BarModOptionsFrameCheckButtonBars:SetChecked(CT_BarModOptions_Options[UnitName("player")]["removeBars"]);
	CT_BarModOptionsFrameCheckButtonBags:SetChecked(CT_BarModOptions_Options[UnitName("player")]["removeBags"]);
	CT_BarModOptionsFrameCheckButtonSpecial:SetChecked(CT_BarModOptions_Options[UnitName("player")]["removeSpecial"]);
end

function CT_BarModOptions_RemoveSpaceBars(checked)
	CT_BarModOptions_Options[UnitName("player")]["removeBars"] = checked;
	local offset, mainOffset = 6, 6;
	if ( checked ) then
		offset = 3;
	end
	if ( checked and CT_BottomBar_HiddenFrames and CT_BottomBar_HiddenFrames[UnitName("player")]["BarHotbarBackgroundLeft"] and CT_BottomBar_Enabled[UnitName("player")] ) then
		mainOffset = 3;
	end
	for i = 2, 12, 1 do
		for y = 1, 5, 1 do
			local prefix = "CT" .. y;
			if ( y == 1 ) then
				prefix = "CT";
			end
			if ( CT_SidebarAxis[y] == 2 ) then
				getglobal(prefix .. "_ActionButton" .. i):SetPoint("LEFT", prefix .. "_ActionButton" .. i-1, "RIGHT", offset, 0);
			else
				getglobal(prefix .. "_ActionButton" .. i):SetPoint("TOP", prefix .. "_ActionButton" .. i-1, "BOTTOM", 0, -offset);
			end
		end
		getglobal("ActionButton" .. i):ClearAllPoints();
		if ( CT_BottomBar_RotatedFrames and CT_BottomBar_RotatedFrames[UnitName("player")]["Bars"] and CT_BottomBar_Enabled[UnitName("player")] ) then
			getglobal("ActionButton" .. i):SetPoint("TOP", "ActionButton" .. i-1, "BOTTOM", 0, -mainOffset);
		elseif ( CT_BottomBar_HiddenFrames and CT_BottomBar_HiddenFrames[UnitName("player")]["BarHotbarBackgroundLeft"] and CT_BottomBar_Enabled[UnitName("player")] ) then
			getglobal("ActionButton" .. i):SetPoint("LEFT", "ActionButton" .. i-1, "RIGHT", mainOffset, 0);
		else
			getglobal("ActionButton" .. i):SetPoint("LEFT", "ActionButton" .. i-1, "RIGHT", 6, 0);
		end
	end
end

function CT_BarModOptions_RemoveSpaceBags(checked)
	CT_BarModOptions_Options[UnitName("player")]["removeBags"] = checked;
	local enabled;
	if ( ( CT_BottomBar_HiddenFrames[UnitName("player")]["BagsBackground"] or CT_BottomBar_RotatedFrames[UnitName("player")]["Bags"] ) and CT_BottomBar_Enabled[UnitName("player")] ) then
		enabled = 1;
		local offset = 5;
		if ( checked ) then
			offset = 2;
		end
		local tbl = {
			[0] = "MainMenuBarBackpackButton",
			"CharacterBag0Slot",
			"CharacterBag1Slot",
			"CharacterBag2Slot",
			"CharacterBag3Slot"
		};
		for i = 1, 4, 1 do
			getglobal(tbl[i]):ClearAllPoints();
			if ( CT_BottomBar_RotatedFrames[UnitName("player")]["Bags"] ) then
				getglobal(tbl[i]):SetPoint("TOP", tbl[i-1], "BOTTOM", 0, -offset);
			else
				getglobal(tbl[i]):SetPoint("RIGHT", tbl[i-1], "LEFT", -offset, 0);
			end
		end
	end
	if ( CT_BottomBar_Enabled[UnitName("player")] ) then
		if ( CT_BottomBar_RotatedFrames[UnitName("player")]["Bags"]) then
			MainMenuBarBackpackButton:ClearAllPoints();
			MainMenuBarBackpackButton:SetPoint("TOPLEFT", "CT_BottomBarFrameBags", "TOPLEFT", 7, -4);
		elseif ( checked and enabled ) then
			MainMenuBarBackpackButton:ClearAllPoints();
			MainMenuBarBackpackButton:SetPoint("TOPRIGHT", "CT_BottomBarFrameBags", "TOPRIGHT", -24, -4);
		else
			MainMenuBarBackpackButton:ClearAllPoints();
			MainMenuBarBackpackButton:SetPoint("TOPRIGHT", "CT_BottomBarFrameBags", "TOPRIGHT", -8, -4);
		end
	else
		MainMenuBarBackpackButton:ClearAllPoints();
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -6, 2);
		local tbl = {
			[0] = "MainMenuBarBackpackButton",
			"CharacterBag0Slot",
			"CharacterBag1Slot",
			"CharacterBag2Slot",
			"CharacterBag3Slot"
		};
		for i = 1, 4, 1 do
			getglobal(tbl[i]):ClearAllPoints();
			getglobal(tbl[i]):SetPoint("RIGHT", tbl[i-1], "LEFT", -5, 0);
		end
	end
end

function CT_BarModOptions_RemoveSpaceSpecial(checked)
	CT_BarModOptions_Options[UnitName("player")]["removeSpecial"] = checked;
	local offset, offsetss = 8, 6;
	if ( checked and CT_BottomBar_Enabled and CT_BottomBar_Enabled[UnitName("player")] ) then
		if ( CT_BABar_DragFrame_Orientation == "V" or CT_BottomBar_HiddenFrames[UnitName("player")]["ClassBackground"] ) then
			offsetss = 3;
		end
		if ( CT_PetBar_DragFrame_Orientation == "V" or CT_BottomBar_HiddenFrames[UnitName("player")]["ClassBackground"] ) then
			offset = 3;
		end
	end
	for i = 2, 10, 1 do
		getglobal("ShapeshiftButton" .. i):ClearAllPoints();
		if ( CT_BABar_DragFrame_Orientation and CT_BABar_DragFrame_Orientation == "V" ) then
			getglobal("ShapeshiftButton" .. i):SetPoint("TOP", "ShapeshiftButton" .. i-1, "BOTTOM", 0, -offsetss);
		else
			getglobal("ShapeshiftButton" .. i):SetPoint("LEFT", "ShapeshiftButton" .. i-1, "RIGHT", offsetss, 0);
		end
		getglobal("PetActionButton" .. i):ClearAllPoints();
		if ( CT_PetBar_DragFrame_Orientation and CT_PetBar_DragFrame_Orientation == "V" ) then
			getglobal("PetActionButton" .. i):SetPoint("TOP", "PetActionButton" .. i-1, "BOTTOM", 0, -offset);
		else
			getglobal("PetActionButton" .. i):SetPoint("LEFT", "PetActionButton" .. i-1, "RIGHT", offset, 0);
		end
	end
end

function CT_BarModOptions_OpenFrame()
	if ( CT_BarModOptionsFrame:IsVisible() ) then
		CT_BarModOptionsFrame:Hide();
	else
		CT_BarModOptionsFrame:Show();
	end
end
CT_RegisterMod("Bar Scaling", "Open Options", 2, "Interface\\Icons\\Ability_Rogue_Ambush", "Opens the Scaling Options frame, where you\ncan scale the hotbars and remove the space inbetween them.", "switch", nil, CT_BarModOptions_OpenFrame);