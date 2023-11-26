function AtlasButton_OnClick()
	Atlas_Toggle();
end

function AtlasButton_Init()
	if(AtlasOptions.AtlasButtonShown) then
		AtlasButtonFrame:Show();
	else
		AtlasButtonFrame:Hide();
	end
end

function AtlasButton_Toggle()
	if(AtlasButtonFrame:IsVisible()) then
		AtlasButtonFrame:Hide();
		AtlasOptions.AtlasButtonShown = false;
	else
		AtlasButtonFrame:Show();
		AtlasOptions.AtlasButtonShown = true;
	end
end

function AtlasButton_UpdatePosition()
	AtlasButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (78 * cos(AtlasOptions.AtlasButtonPosition)),
		(78 * sin(AtlasOptions.AtlasButtonPosition)) - 55
	);
end