ATLAS_BUTTON_TOOLTIP = "Toggle Atlas";

function AtlasButton_OnClick()
	Atlas_Toggle();
end

function AtlasButton_Init()
	if(Options.AtlasButtonShown) then
		AtlasButtonFrame:Show();
	else
		AtlasButtonFrame:Hide();
	end
end

function AtlasButton_Toggle()
	if(AtlasButtonFrame:IsVisible()) then
		AtlasButtonFrame:Hide();
		Options.AtlasButtonShown = false;
	else
		AtlasButtonFrame:Show();
		Options.AtlasButtonShown = true;
	end
end

function AtlasButton_UpdatePosition()
	AtlasButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		55 - (75 * cos(Options.AtlasButtonPosition)),
		(75 * sin(Options.AtlasButtonPosition)) - 55
	);
end