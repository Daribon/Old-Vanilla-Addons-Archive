UIPanelWindows["CosmosFeatureFrame"] = { area = "left",	pushable = 10 };

COSMOSFEATUREFRAME_PAGESIZE = 14;

CosmosFeatureFrame_Offset = 0;

function ToggleCosmosFeatureFrame()
	if (CosmosFeatureFrame:IsVisible()) then
		HideUIPanel(CosmosFeatureFrame);
	else
		ShowUIPanel(CosmosFeatureFrame);
	end
end

function CosmosButton_OnHide()
	UpdateMicroButtons();
	PlaySound("igSpellBookClose");
end

function CosmosButtons_UpdateColor()
	local value = nil;
	for id = 1, 14 do
		value = CosmosMaster_Buttons[id+CosmosFeatureFrame_Offset];
		if ( value ) then
			local test_function = value[CSM_TESTFUNCTION];
			if (test_function ~= nil) then
				local icon = getglobal("CosmosFeaturesButton"..id);
				local iconTexture = getglobal("CosmosFeaturesButton"..id.."IconTexture");
				
				if (test_function() == false) then
					icon:Disable();
					iconTexture:SetVertexColor(1.00, 0.00, 0.00);
				else
					icon:Enable();
					iconTexture:SetVertexColor(1.00, 1.00, 1.00);
				end
			end
		end
	end
end

function CosmosButton_OnShow()
	UpdateMicroButtons();
	CosmosFeaturesTitleText:SetText(TEXT(COSMOS_FEATURES_TITLE));
	PlaySound("igSpellBookOpen");
	CosmosButtons_UpdateColor();
end

function CosmosButton_OnEnter()	
	local value = CosmosMaster_Buttons[this:GetID()+CosmosFeatureFrame_Offset];
	if (value) then
		CosmosTooltip:SetOwner(this, "ANCHOR_RIGHT");
		CosmosTooltip:SetText(value[CSM_LONGDESCRIPTION], 1.0, 1.0, 1.0);
		return;
	end
end

function CosmosButton_OnClick()	
	local value = CosmosMaster_Buttons[this:GetID()+CosmosFeatureFrame_Offset];
	if (value) then
		local f = value[CSM_CALLBACK];
		this:SetChecked(0);
		f();
		return;
	end
end

function CosmosButton_UpdateButton()
	for i = 1, 14, 1 do
		local icon = getglobal("CosmosFeaturesButton"..i);
		local iconTexture = getglobal("CosmosFeaturesButton"..i.."IconTexture");
		local iconName = getglobal("CosmosFeaturesButton"..i.."Name");
		local iconDescription = getglobal("CosmosFeaturesButton"..i.."OtherName");
		
		icon:Hide();
		iconTexture:Hide();
		iconName:Hide();
		iconDescription:Hide();
	end
	local id = 0;
	local value = 0;
	for i = 1, 14 do
		id = i + CosmosFeatureFrame_Offset;
		
		value = CosmosMaster_Buttons[id];
		if ( not value ) then
			break;
		end
		
		local icon = getglobal("CosmosFeaturesButton"..i);
		local iconTexture = getglobal("CosmosFeaturesButton"..i.."IconTexture");
		local iconName = getglobal("CosmosFeaturesButton"..i.."Name");
		local iconDescription = getglobal("CosmosFeaturesButton"..i.."OtherName");
		
		icon:Show();
		icon:Enable();
		iconTexture:Show();
		iconTexture:SetTexture(value[CSM_ICON]);
		iconName:Show();
		iconName:SetText(value[CSM_NAME]);
		iconDescription:Show();
		iconDescription:SetText(value[CSM_DESCRIPTION]);

	end
	CosmosFeatureFrame_UpdatePageArrows();
end

function CosmosFeatureFrame_UpdatePageArrows()
	local numValues = 0;
	if ( CosmosMaster_Buttons ) then
		numValues = table.getn(CosmosMaster_Buttons);
	end
	if ( CosmosFeatureFrame_Offset <= 0 ) then
		CosmosFeatureFramePrevPageButton:Disable();
	else
		CosmosFeatureFramePrevPageButton:Enable();
	end
	if ( ( CosmosFeatureFrame_Offset + COSMOSFEATUREFRAME_PAGESIZE ) >= numValues ) then
		CosmosFeatureFrameNextPageButton:Disable();
	else
		CosmosFeatureFrameNextPageButton:Enable();
	end
end

function CosmosFeatureFrame_PrevPageButton_OnClick()
	if ( ( CosmosFeatureFrame_Offset - COSMOSFEATUREFRAME_PAGESIZE ) >= 0 ) then
		CosmosFeatureFrame_Offset = CosmosFeatureFrame_Offset - COSMOSFEATUREFRAME_PAGESIZE;
	end
	CosmosButton_UpdateButton();
end

function CosmosFeatureFrame_NextPageButton_OnClick()
	local numValues = table.getn(CosmosMaster_Buttons);
	if ( ( CosmosFeatureFrame_Offset + COSMOSFEATUREFRAME_PAGESIZE ) < numValues ) then
		CosmosFeatureFrame_Offset = CosmosFeatureFrame_Offset + COSMOSFEATUREFRAME_PAGESIZE;
	end
	CosmosButton_UpdateButton();
end
