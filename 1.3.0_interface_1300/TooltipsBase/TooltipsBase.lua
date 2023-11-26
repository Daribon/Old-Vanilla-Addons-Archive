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
--	for i = 1, 20 do
--		local checkText = getglobal("GameTooltipTextLeft"..i);
--		checkText:SetText("");
--		checkText:Hide();
--	end
end

-- Handler called when mouseing over a unit
-- Example usage:
-- HookFunction("TooltipsBase_UnitHandler","TooltipsMyName_UnitHandler","after");
function TooltipsBase_UnitHandler(type)
end

-- fix the size and remove blank lines
-- note that blank lines can still be created by setting the string to ""
function	TooltipsBase_MouseoverFixSize()
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


function TooltipsBase_OnLoad()
	HookFunction("UnitFrame_OnEnter","TooltipsBase_UnitFrame_OnEnter","after");
	HookFunction("GameTooltip_OnHide","TooltipsBase_GameTooltip_OnHide","after");
	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
end