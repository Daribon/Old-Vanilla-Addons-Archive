function AtlasOptions_Toggle()
	if(AtlasOptionsFrame:IsVisible()) then
		AtlasOptionsFrame:Hide();
	else
		AtlasOptionsFrame:Show();
	end
end

function AtlasOptions_OnLoad()
	UIPanelWindows['AtlasOptionsFrame'] = {area = 'center', pushable = 0};
end

function AtlasOptions_Init()
	AtlasOptionsFrameToggleButton:SetChecked(AtlasOptions.AtlasButtonShown);
	SliderButtonPos:SetValue(AtlasOptions.AtlasButtonPosition);
	SliderAlpha:SetValue(AtlasOptions.AtlasAlpha);
end

function AtlasOptions_OnHide()
	if(MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end
end
