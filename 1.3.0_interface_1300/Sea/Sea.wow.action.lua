--[[
--
--	Sea.wow.spell
--
--	Action related wow functions
--
--	$LastChangedBy: AlexYoshi $
--	$Rev: 1142 $
--	$Date: 2005-03-22 17:20:48 +0100 (Tue, 22 Mar 2005) $
--]]

Sea.wow.action = {

	--
	-- getActionInfoStrings ( actionId [, tooltip] )
	--
	--    Obtains all information about an action by id and returns it as an array 	
	--
	-- Args:
	-- 	(int actionId, string tooltipbase )
	--
	-- Returns:
	-- 	(table[row][.left .right] strings)
	-- 	string - the string data of the tooltip
	-- 
	getActionInfoStrings = function (actionId, TooltipNameBase)
		if ( TooltipNameBase == nil ) then 
			TooltipNameBase = "GameTooltip";
		end

		Sea.wow.tooltip.clear(TooltipNameBase);
	
		local tooltip = getglobal(TooltipNameBase);
		
		-- Open tooltip & read contents
		Sea.wow.tooltip.protectTooltipMoney();
		tooltip:SetAction(actionId);
		Sea.wow.tooltip.unprotectTooltipMoney();
		local strings = Sea.wow.tooltip.scan(TooltipNameBase);

		-- Done our duty, send report
		return strings;
	end;
	
};
