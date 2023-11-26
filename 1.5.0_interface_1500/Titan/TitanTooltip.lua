-- Set both the parent and the position of GameTooltip
function TitanTooltip_SetOwnerPosition(parent, anchorPoint, relativeToFrame, relativePoint, xOffset, yOffset)
	GameTooltip:SetOwner(parent, "ANCHOR_NONE");
	GameTooltip:SetPoint(anchorPoint, relativeToFrame, relativePoint, xOffset, yOffset);
end

function TitanTooltip_SetGameTooltip()
	if ( this.tooltipCustomFunction ) then
		this.tooltipCustomFunction();
	elseif ( this.tooltipTitle ) then
		GameTooltip:SetText(this.tooltipTitle, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);	
		if ( this.tooltipText ) then
			TitanTooltip_AddTooltipText(this.tooltipText);
		end
	end
	GameTooltip:Show();
end

function TitanTooltip_SetPanelTooltip(id)
	if ( not this.tooltipCustomFunction and not this.tooltipTitle ) then
		return;
	end
	
	-- Set GameTooltip
	local button = TitanUtils_GetButton(id);
	local position = TitanPanelGetVar("Position");
	local scale = TitanPanelGetVar("Scale");	
	local offscreenX, offscreenY;
	if (position == TITAN_PANEL_PLACE_TOP) then 
		TitanTooltip_SetOwnerPosition(button, "TOPLEFT", button:GetName(), "BOTTOMLEFT", -10, -4 * scale);
		TitanTooltip_SetGameTooltip();
	
		-- Adjust GameTooltip position if it's off the screen
		offscreenX, offscreenY = TitanUtils_GetOffscreen(GameTooltip);
		if ( offscreenX == -1 ) then
			TitanTooltip_SetOwnerPosition(button, "TOPLEFT", "TitanPanelBarButton", "BOTTOMLEFT", 0, 0);
			TitanTooltip_SetGameTooltip();	
		elseif ( offscreenX == 1 ) then
			TitanTooltip_SetOwnerPosition(button, "TOPRIGHT", "TitanPanelBarButton", "BOTTOMRIGHT", 0, 0);
			TitanTooltip_SetGameTooltip();	
		end		
	else
		TitanTooltip_SetOwnerPosition(button, "BOTTOMLEFT", button:GetName(), "TOPLEFT", -10, 4 * scale);
		TitanTooltip_SetGameTooltip();
	
		-- Adjust GameTooltip position if it's off the screen
		offscreenX, offscreenY = TitanUtils_GetOffscreen(GameTooltip);
		if ( offscreenX == -1 ) then
			TitanTooltip_SetOwnerPosition(button, "BOTTOMLEFT", "TitanPanelBarButton", "TOPLEFT", 0, 0);
			TitanTooltip_SetGameTooltip();	
		elseif ( offscreenX == 1 ) then
			TitanTooltip_SetOwnerPosition(button, "BOTTOMRIGHT", "TitanPanelBarButton", "TOPRIGHT", 0, 0);
			TitanTooltip_SetGameTooltip();	
		end
	end
end

function TitanTooltip_AddTooltipText(text)
	if ( text ) then
		-- Append a "\n" to the end 
		if ( string.sub(text, -1, -1) ~= "\n" ) then
			text = text.."\n";
		end
		
		for text1, text2 in string.gfind(text, "([^\t\n]*)\t?([^\t\n]*)\n") do
			if ( text2 ~= "" ) then
				GameTooltip:AddDoubleLine(text1, text2);
			elseif ( text1 ~= "" ) then
				GameTooltip:AddLine(text1);
			else
				GameTooltip:AddLine("\n");
			end			
		end
	end
end
