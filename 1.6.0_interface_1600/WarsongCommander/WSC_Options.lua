function WSC_Options_Toggle()
	if(WSC_OptionsFrame:IsVisible()) then
		WSC_OptionsFrame:Hide();
	else
		WSC_OptionsFrame:Show();
	end
end

function WSC_Options_OnLoad()
	UIPanelWindows['WSC_OptionsFrame'] = {area = 'center', pushable = 0};
end

function WSC_Options_Init()
	WSC_SliderAlpha:SetValue(WSC_Options.Alpha);
	WSC_SliderScale:SetValue(WSC_Options.Scale);
	WSC_BorderToggle:SetChecked(WSC_Options.ShowBorders);
	WSC_AutoShowToggle:SetChecked(WSC_Options.AutoShow);
	WSC_PingToggle:SetChecked(WSC_Options.EnablePings);
end

function WSC_Options_OnHide()
	if(MYADDONS_ACTIVE_OPTIONSFRAME == this) then
		ShowUIPanel(myAddOnsFrame);
	end
end
