TOOLTIP_IS_NEWBIE = nil;
TooltipsBase_Original_GameTooltip_ClearMoney = nil;

-- UnitFrame mouseover mod
function TooltipsBase_UnitFrame_OnEnter()
	TooltipsBase_UnitHandler(this.unit);
	TooltipsBase_MouseoverFixSize();
end

function TooltipsBase_OnEvent() 
	if ( event == "UPDATE_MOUSEOVER_UNIT" ) then
		TooltipsBase_UnitHandler("mouseover");
		TooltipsBase_MouseoverFixSize();
	end
end

function TooltipsBase_GameTooltip_OnHide()
	TOOLTIP_IS_NEWBIE = nil;
	-- fix for clear money
	TooltipsBase_Original_GameTooltip_ClearMoney();
end

function TooltipsBase_GameTooltip_ClearMoney()
	-- do nothing, this is handled in the onHide now!
end

-- Handler called when mouseing over a unit
-- Example usage:
-- HookFunction("TooltipsBase_UnitHandler","TooltipsMyName_UnitHandler","after");
function TooltipsBase_UnitHandler(type)
end

-- fix the size and remove blank lines
-- note that blank lines can still be created by setting the string to ""
function TooltipsBase_MouseoverFixSize()
	local newWidth = 0;
	local newHeight = 20;
	local lastValid = 0;
	for i = 1, 20 do
		local checkText = getglobal("GameTooltipTextLeft"..i);
		if (checkText and checkText:IsVisible()) then
			local width = checkText:GetWidth() + 24;
			if (width > newWidth) then
				newWidth = width;
			end
			newHeight = newHeight + checkText:GetHeight() + 2;
			lastValid = lastValid + 1;
			if (lastValid ~= i) then
				local moveText = getglobal("GameTooltipTextLeft"..lastValid);
				if (moveText ~= nil) then
					moveText:SetText(checkText:GetText());
					moveText:Show();
					checkText:SetText("");
					checkText:Hide();
				end
			end
		end
	end

	GameTooltip:SetWidth(newWidth);
	GameTooltip:SetHeight(newHeight);
end

function TooltipsBase_IsNewbieTip()
	return TOOLTIP_IS_NEWBIE ;
end

function TooltipsBase_GameTooltip_AddNewbieTip(normalText, r, g, b, newbieText, noNormalText)
	if ( SHOW_NEWBIE_TIPS == "1" ) then
		TOOLTIP_IS_NEWBIE = 1;
	else
		TOOLTIP_IS_NEWBIE = nil;
	end

end

function TooltipsBase_OnLoad()
	HookFunction("UnitFrame_OnEnter","TooltipsBase_UnitFrame_OnEnter","after");
	HookFunction("GameTooltip_OnHide","TooltipsBase_GameTooltip_OnHide","after");
	HookFunction("GameTooltip_AddNewbieTip","TooltipsBase_GameTooltip_AddNewbieTip","after");
	-- fix for clear money
	TooltipsBase_Original_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
	GameTooltip_ClearMoney = TooltipsBase_GameTooltip_ClearMoney;

	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
end