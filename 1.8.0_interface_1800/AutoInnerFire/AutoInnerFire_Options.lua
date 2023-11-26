--[[
	AutoInnerFire 1.33
	base by Gello
	mod by deto
	
	Minimap-Button & Option-Menu functions
	
	basement by myClock & Atlas
]]

--------------------------------------------------------------------------------------------------
-- Initialize functions
--------------------------------------------------------------------------------------------------

-- Initialize the threshold dropdown menu
function AutoInnerFireOptionsFrameThresholdDropDown_Initialize()

	local info;

	for i=0, 100, 10 do
		info = {};
		info.text = tostring(i.."%");
		info.func = AutoInnerFireOptionsFrameThresholdDropDown_OnClick;
		info.value = i;
		UIDropDownMenu_AddButton(info);
	end

end


--------------------------------------------------------------------------------------------------
-- Event functions
--------------------------------------------------------------------------------------------------

-- OnLoad Event
function AutoInnerFireOptionsFrame_OnLoad()

	-- Add AutoInnerFireOptionsFrame to the UIPanelWindows list
	UIPanelWindows["AutoInnerFireOptionsFrame"] = {area = "center", pushable = 0};
	
	-- Check Buttons
	AutoInnerFireOptionsFrameCheckButton1Text:SetText(AIF_OPTIONS_ON);
	AutoInnerFireOptionsFrameCheckButton2Text:SetText(AIF_OPTIONS_BUTTON);
	AutoInnerFireOptionsFrameCheckButton3Text:SetText(AIF_OPTIONS_COMBAT);
	
	-- Threshold Dropdown Menu
	UIDropDownMenu_Initialize(AutoInnerFireOptionsFrameThresholdDropDown, AutoInnerFireOptionsFrameThresholdDropDown_Initialize);
	UIDropDownMenu_SetWidth(80, AutoInnerFireOptionsFrameThresholdDropDown);
	
	-- Minimap Button Position
	AutoInnerFireSliderButtonPos:SetValue(AutoInnerFireButtonPosition);

end

-- OnShow Event
function AutoInnerFireOptionsFrame_OnShow()

	-- Use smaller font for dropdown menus
	MYUIDROPDOWNMENU_BUTTON_HEIGHT = UIDROPDOWNMENU_BUTTON_HEIGHT;
	UIDROPDOWNMENU_BUTTON_HEIGHT = 12;

	-- Update the display
	AutoInnerFireOptionsFrame_Update();

end

-- OnHide Event
function AutoInnerFireOptionsFrame_OnHide()

	-- Restore standard font for dropdown menus
	UIDROPDOWNMENU_BUTTON_HEIGHT = MYUIDROPDOWNMENU_BUTTON_HEIGHT;

	-- Check if the options frame was opened by myAddOns
	if (MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end
	
end

-- Checkbuttons' OnClick Event
function AutoInnerFireOptionsCheckButton_OnClick()

	-- Check which checkbutton was clicked
	if ( this == AutoInnerFireOptionsFrameCheckButton1 ) then
		AutoInnerFire = this:GetChecked();
	elseif ( this == AutoInnerFireOptionsFrameCheckButton2 ) then
		AutoInnerFireButtonShown = this:GetChecked();
	elseif ( this == AutoInnerFireOptionsFrameCheckButton3 ) then
		AutoInnerFireCombat = this:GetChecked();
	end

	-- Play sound
	if (this:GetChecked()) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end
	
	-- Update display
	AutoInnerFireOptionsFrame_Update();
	
end

-- Theshold dropdown menu OnClick Event
function AutoInnerFireOptionsFrameThresholdDropDown_OnClick()

	UIDropDownMenu_SetSelectedValue(AutoInnerFireOptionsFrameThresholdDropDown, this.value);
	AutoInnerFireThreshold = this.value;
	
	AutoInnerFireOptionsFrame_Update();
	
end


--------------------------------------------------------------------------------------------------
-- Update functions
--------------------------------------------------------------------------------------------------

-- Update display
function AutoInnerFireOptionsFrame_Update()
	
	-- On/Off Button
	AutoInnerFireOptionsFrameCheckButton1:SetChecked(AutoInnerFire);
	
	-- Minimap Button On/Off Button
	AutoInnerFireOptionsFrameCheckButton2:SetChecked(AutoInnerFireButtonShown);
	AutoInnerFireButton_Init();
	
	-- BuffinCombat On/Off Button
	AutoInnerFireOptionsFrameCheckButton3:SetChecked(AutoInnerFireCombat);
		
	-- Threshold Dropdown
	UIDropDownMenu_SetSelectedValue(AutoInnerFireOptionsFrameThresholdDropDown, AutoInnerFireThreshold);
	UIDropDownMenu_SetText(AutoInnerFireThreshold.."%", AutoInnerFireOptionsFrameThresholdDropDown);
		
	-- Position Button
	AutoInnerFireSliderButtonPos:SetValue(AutoInnerFireButtonPosition);
	
	-- Save the Settings
	if ( AutoInnerFireOptionsFrameCheckButton1:GetChecked() ) then AutoInnerFire = 1; else AutoInnerFire = 0; end
	if ( AutoInnerFireOptionsFrameCheckButton2:GetChecked() ) then AutoInnerFireButtonShown = 1; else AutoInnerFireButtonShown = 0; end
	if ( AutoInnerFireOptionsFrameCheckButton3:GetChecked() ) then AutoInnerFireCombat = 1; else AutoInnerFireCombat = 0; end
	
	AutoInnerFire_SaveVar("AutoInnerFire", AutoInnerFire);
	AutoInnerFire_SaveVar("AutoInnerFireButtonShown", AutoInnerFireButtonShown);
	AutoInnerFire_SaveVar("AutoInnerFireCombat", AutoInnerFireCombat);
	AutoInnerFire_SaveVar("AutoInnerFireThreshold", AutoInnerFireThreshold);
	AutoInnerFire_SaveVar("AutoInnerFireButtonPosition", AutoInnerFireButtonPosition);
	
end

-- Reset options to defaults
function AutoInnerFireOptionsFrame_SetDefaults()

	-- Reset myClock options to defaults
	AutoInnerFire = 1;
	AutoInnerFireThreshold = 20;
	AutoInnerFireCombat = 0;
	AutoInnerFireButtonShown = 1;
	AutoInnerFireButtonPosition = 325;
		
	-- Update the display
	AutoInnerFireOptionsFrame_Update();
end

--------------------------------------------------------------------------------------------------
-- Minimap Functions
--------------------------------------------------------------------------------------------------
function AutoInnerFireButton_OnClick()
	if(AutoInnerFireOptionsFrame:IsVisible()) then
		HideUIPanel(AutoInnerFireOptionsFrame);
	else
		ShowUIPanel(AutoInnerFireOptionsFrame);
	end
end

function AutoInnerFireButton_Init()
	if(AutoInnerFireButtonShown == 1) then
		AutoInnerFireButtonFrame:Show();
	else
		AutoInnerFireButtonFrame:Hide();
	end
end

function AutoInnerFireButton_Toggle()
	if(AutoInnerFireButtonFrame:IsVisible()) then
		AutoInnerFireButtonFrame:Hide();
	else
		AutoInnerFireButtonFrame:Show();
	end
end

function AutoInnerFireButton_UpdatePosition()
	AutoInnerFireButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (78 * cos( AutoInnerFireButtonPosition )),
		(78 * sin( AutoInnerFireButtonPosition )) - 55
	);
end

--------------------------------------------------------------------------------------------------
-- AutoInnerFire - END OF FILE
--------------------------------------------------------------------------------------------------