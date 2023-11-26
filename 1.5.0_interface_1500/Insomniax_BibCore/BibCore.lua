
function EventIsPlayerNameLoaded(event)
	if (event == "UNIT_NAME_UPDATE") then
		-- LedMirage 5/02/2005
		-- if(this.got_unit_name_update or UnitName("player") == "Unknown Entity") then
		if(this.got_unit_name_update or UnitName("player") == UNKNOWNOBJECT) then
			return false;
		elseif(this.got_unit_name_update or UnitName("player") == "Unknown Entity") then
			return false;
		end
		this.got_unit_name_update = true;
		return true;
	end
	return false;
end

function AddBibControlButton(button)
	if(BibMenu.button_offset == nil) then
		BibMenu.button_offset = 0;
	end
	button:SetWidth(32);
	button:SetHeight(32);
	button:SetPoint("TOPLEFT", "BibMenuBar", "TOPLEFT", BibMenu.button_offset, 0);
	BibMenu.button_offset = BibMenu.button_offset + 32;
	BibMenu:SetWidth(BibMenu.button_offset+16);
end

function UpdateBibMenuFoldState()
	local PlayerString = UnitName("player");
	if(BibMenuFolded[PlayerString]) then
		BibMenuBar:Hide();
		BibMenu:SetWidth(16);
		BibMenuToggle:SetNormalTexture("Interface\\AddOns\\Insomniax_BibCore\\Images\\UnfoldBibMenu");
	else
		BibMenuBar:Show();
		BibMenu:SetWidth(BibMenu.button_offset+16);
		BibMenuToggle:SetNormalTexture("Interface\\AddOns\\Insomniax_BibCore\\Images\\FoldBibMenu");
	end
end

function BibMenu_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(BibMenuFolded[PlayerString]) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Unfold BibMod Menu Bar");
		GameTooltip:SetText("Insomniax BibMenu v3.3", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Left-click to unfold the menu bar", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Using the BibMenu you can configure the", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbar mod and which of the original", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("menu elements are displayed. Mouse over", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("the different buttons to find out what", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("each of them does.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Fold BibMod Menu Bar");
		GameTooltip:SetText("Insomniax BibMenu v3.3", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Left-click to fold the menu bar", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Using the BibMenu you can configure the", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbar mod and which of the original", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("menu elements are displayed. Mouse over", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("the different buttons to find out what", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("each of them does.", 80/255, 143/255, 148/255);
		GameTooltip:Show();		
	end
end