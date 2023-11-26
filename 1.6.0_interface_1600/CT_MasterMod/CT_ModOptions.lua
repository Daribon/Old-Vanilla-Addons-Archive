function CT_OptionButton_OnClick()
	if ( CT_CPFrame:IsVisible() ) then
		HideUIPanel(CT_CPFrame);
	else
		ShowUIPanel(CT_CPFrame);
	end
end

CT_CPBPosition = 256;

function CT_OptionBar_MoveButton()
	CT_OptionButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(CT_CPBPosition)), (80 * sin(CT_CPBPosition)) - 52);
end

CT_oldToggleMinimap = ToggleMinimap;
function CT_newToggleMinimap()
	CT_oldToggleMinimap();
	if ( Minimap:IsVisible() ) then
		CT_OptionButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(CT_CPBPosition)), (80 * sin(CT_CPBPosition)) - 52);
	else
		CT_OptionButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 130, -31);
	end
end
ToggleMinimap = CT_newToggleMinimap;