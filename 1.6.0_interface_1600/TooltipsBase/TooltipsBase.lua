TooltipsBase_ENABLE = 1;
TOOLTIP_IS_NEWBIE = nil;
TooltipsBase_Original_GameTooltip_ClearMoney = nil;
TooltipsBase_Original_GameTooltip_SetUnit = nil;

-- UnitFrame mouseover mod
-- Older functions. No longer used.
--function TooltipsBase_UnitFrame_OnEnter()
--	TooltipsBase_UnitHandler(this.unit);
--	TooltipsBase_MouseoverFixSize();
--end

--function TooltipsBase_OnEvent() 
--	if ( event == "UPDATE_MOUSEOVER_UNIT" ) then
--		TooltipsBase_UnitHandler("mouseover");
--		TooltipsBase_MouseoverFixSize();
--	end
--end

function TooltipsBase_GameTooltip_SetUnit(this,unit)
	TooltipsBase_Original_GameTooltip_SetUnit(this,unit);
	TooltipsBase_UnitHandler(unit);
	TooltipsBase_MouseoverFixSize();
end

function TooltipsBase_GameTooltip_OnHide()
	TOOLTIP_IS_NEWBIE = nil;
	-- fix for clear money
	if (TooltipsBase_ENABLE == 1) then
		TooltipsBase_Original_GameTooltip_ClearMoney();
	end
end

function TooltipsBase_GameTooltip_ClearMoney()
	if (TooltipsBase_ENABLE == 1) then
	   -- do nothing, this is handled in the onHide now!
	else
		TooltipsBase_Original_GameTooltip_ClearMoney();
	end
end

-- Handler called when mouseing over a unit
-- Example usage:
-- Sea.util.hook("TooltipsBase_UnitHandler","TooltipsMyName_UnitHandler","after");
function TooltipsBase_UnitHandler(type)
end

-- fix the size and remove blank lines
-- note that blank lines can still be created by setting the string to ""
function TooltipsBase_MouseoverFixSize()
	local tooltipName = "GameTooltip";
	local newWidth = 0;
	local newHeight = 20;
	local lastValid = 0;
	for i = 1, 20 do
		local checkText = getglobal(tooltipName.."TextLeft"..i);
		if (checkText and checkText:IsVisible()) then
			local width = checkText:GetWidth() + 24;
			if (width > newWidth) then
				newWidth = width;
			end
			newHeight = newHeight + checkText:GetHeight() + 2;
			lastValid = lastValid + 1;
			if (lastValid ~= i) then
				local moveText = getglobal(tooltipName.."TextLeft"..lastValid);
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
--	Sea.util.hook("UnitFrame_OnEnter","TooltipsBase_UnitFrame_OnEnter","after");
	Sea.util.hook("GameTooltip_OnHide","TooltipsBase_GameTooltip_OnHide","after");
	Sea.util.hook("GameTooltip_AddNewbieTip","TooltipsBase_GameTooltip_AddNewbieTip","after");
	-- fix for clear money
	TooltipsBase_Original_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
	GameTooltip_ClearMoney = TooltipsBase_GameTooltip_ClearMoney;
	-- Sea.util.hook doesnt handle GameTooltip:SetUnit
	-- however this doesnt seem to be working right?
	TooltipsBase_Original_GameTooltip_SetUnit	= GameTooltip.SetUnit;
	GameTooltip.SetUnit = TooltipsBase_GameTooltip_SetUnit;

	
	
	if(UltimateUI_RegisterConfiguration) then
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPSBASE",
			"SECTION",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPSBASE_SEP",
			"SEPARATOR",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPS_BASE_C",
			"CHECKBOX",
			TOOLTIPSBASE_ENABLE,
			TOOLTIPSBASE_ENABLE_INFO,
			TooltipsBase_Toggle,
			1
			);
	end

--	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
end
function TooltipsBase_Toggle(toggle)
	if(toggle == 1) then
		TooltipsBase_ENABLE = 1;
	else
		TooltipsBase_ENABLE = nil;
	end
end
