function CT_OptionButton_OnClick()
	if ( CT_CPFrame:IsVisible() ) then
		HideUIPanel(CT_CPFrame);
	else
		ShowUIPanel(CT_CPFrame);
	end
end

-- LedMirage 6/10/2005 Change Start [ 1 of 3]
CT_CPBPosition = 15;
-- LedMirage 6/10/2005 Change End [ 1 of 3]

function CT_OptionBar_MoveButton()
	-- LedMirage 6/10/2005 Change Start [ 2 of 3] x52,y52 to x57,y58
	CT_OptionButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 57 - (80 * cos(CT_CPBPosition)), (80 * sin(CT_CPBPosition)) - 58);
	-- LedMirage 6/10/2005 Change End [ 2 of 3]
end

CT_oldToggleMinimap = ToggleMinimap;
function CT_newToggleMinimap()
	CT_oldToggleMinimap();
	if ( Minimap:IsVisible() ) then
		-- LedMirage 6/10/2005 Change Start [ 3 of 3] x52,y52 to x57,y58
		CT_OptionButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 57 - (80 * cos(CT_CPBPosition)), (80 * sin(CT_CPBPosition)) - 58);
		-- LedMirage 6/10/2005 Change End [ 3 of 3]
	else
		CT_OptionButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 130, -31);
	end
end
ToggleMinimap = CT_newToggleMinimap;