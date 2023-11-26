local init = false;

function CensusButton_OnClick()
	CensusPlus_Toggle();
end

function CensusButton_Init()
	if(CensusPlus_Database["Info"]["CensusButtonShown"] == 1 ) then
		CensusButtonFrame:Show();
	else
		CensusButtonFrame:Hide();
	end
	
	init = true;	
end

function CensusButton_Toggle()
	if(CensusButtonFrame:IsVisible()) then
		CensusButtonFrame:Hide();
		CensusPlus_Database["Info"]["CensusButtonShown"] = false;
	else
		CensusButtonFrame:Show();
		CensusPlus_Database["Info"]["CensusButtonShown"] = true;
	end
end

function CensusButton_UpdatePosition()
	CensusButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (78 * cos(CensusPlus_Database["Info"]["CensusButtonPosition"])),
		(78 * sin(CensusPlus_Database["Info"]["CensusButtonPosition"])) - 55
	);
end

function CensusButton_OnUpdate()
	if( init ) then
		CensusPlus_OnUpdate();
	end
end
