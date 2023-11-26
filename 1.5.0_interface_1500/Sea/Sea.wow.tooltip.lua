--[[
--
--	Sea.wow.tooltip
--
--
--	Tooltip related functions
--
--]]

Sea.wow.tooltip = {

	-- 
	-- clear( tooltipNameBase )
	--
	-- 	Clears out a tooltip
	--
	-- args
	--	(String tooltipNamebase)
	-- 	tooltipNameBase - the base name of the tooltip, like "GameTooltip"
	-- 
	clear = function ( tooltipBase )
		for i=1, 15, 1 do
			getglobal(tooltipBase.."TextLeft"..i):SetText("");
			getglobal(tooltipBase.."TextRight"..i):SetText("");
		end		
	end;

	-- 
	-- scan (tooltipNameBase)
	--
	-- 	Returns an associated array of the strings in a tooltip
	--
	-- args
	--	(String tooltipNamebase)
	-- 	tooltipBase - the base name of the tooltip, like "GameTooltip"
	--
	-- Returns:
	-- 	(table[id][.left .right] strings)
	--
	-- 	strings - all of the strings in the tooltip
	--	
	scan = function ( tooltipBase )
		if ( tooltipBase == nil ) then 
			tooltipBase = "GameTooltip";
		end
	
		local strings = {};
		for idx = 1, 10 do
			local textLeft = nil;
			local textRight = nil;
			ttext = getglobal(tooltipBase.."TextLeft"..idx);
			if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
			then
				textLeft = ttext:GetText();
			end
			ttext = getglobal(tooltipBase.."TextRight"..idx);
			if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
			then
				textRight = ttext:GetText();
			end
			if (textLeft or textRight)
			then
				strings[idx] = {};
				strings[idx].left = textLeft;
				strings[idx].right = textRight;
			end	
		end
	
		return strings;
	end;

	-- 
	-- compareTooltipScan(scanTable left, scanTable right)
	--
	-- 	compares the results of two tooltip scans
	--
	-- Args:
	-- 	left - the result of a scan or string (implies tooltip base to scan)
	-- 	right - the result of a scan or string (implies tooltip base to scan)
	-- 	      or nil (implies gametooltip)
	--
	-- Returns:
	-- 	(boolean, number)
	-- 	true if equal
	-- 	0 if equals, -1 if left is less, 1 if right is less
	--
	-- 	
	compareTooltipScan = function ( leftScan, rightScan ) 
		if ( type(leftScan) == "string" ) then
			leftScan = Sea.wow.tooltip.scan(leftScan);
		end
		if ( type(rightScan) == "string" ) then
			rightScan = Sea.wow.tooltip.scan(rightScan);
		end
		if ( type(leftScan) == "nil" ) then 
			leftScan = Sea.wow.tooltip.scan();
		end
		if ( type(rightScan) == "nil" ) then 
			rightScan = Sea.wow.tooltip.scan();
		end
			
		
		local result = 0;
		
		for i=1,10,1 do
			if ( leftScan[i] ) then
				if ( leftScan[i].left ~= nil ) then
					if ( rightScan[i] and (rightScan[i].left ~= nil) ) then
						if ( leftScan[i].left < rightScan[i].left ) then 
							result = -1;
							break;
						elseif ( leftScan[i].left > rightScan[i].left ) then 
							result = 1;
							break;
						end
					else
						result = 1;
						break;
					end
				end
				if ( leftScan[i].right ~= nil ) then
					if ( rightScan[i].right and (rightScan[i].right ~= nil) ) then
						if ( leftScan[i].right < rightScan[i].right ) then 
							result = -1;
							break;
						elseif ( leftScan[i].right > rightScan[i].right ) then 
							result = 1;
							break;
						end
					else
						result = 1;
						break;
					end
				end
			end
		end	

		return (result==0), result;
	end;

	--
	-- smartSetOwner (owner, tooltip, x, y)
	--
	-- Sets the tooltip relative to the owner in a position
	-- appropriate for where the owner is on the screen.
	-- owner - optional, the owner object, defaults to this
	-- tooltip, optional, the tooltip to set, defaults to GameTooltip
	-- setX, optional, sets the x offset(flipped based on screen corner)
	-- setY, optional, sets the y offset(flipped based on screen corner)
	--
	-- Args:
	-- 	(Frame owner, Tooltip tooltip, float x, float y)
	--
	-- 	owner - the new parent frame
	-- 	tooltip - the tooltip to relocate
	-- 	x - new x
	-- 	y - new y
	--
	smartSetOwner = function (owner, tooltip, setX, setY)
	 	if (not owner) then
 			owner = this;
	 	end
	 	if (not tooltip) then
 			tooltip = GameTooltip;
	 	end
 		if (not setX) then
	 		setX = 0;
 		end
	 	if (not setY) then
	 		setY = 0;
 		end
	 	if (owner) then
			local x,y = owner:GetCenter();
			local left = owner:GetLeft();
			local right = owner:GetRight();
			local top = owner:GetTop();
			local bottom = owner:GetBottom();
			local screenWidth = UIParent:GetWidth();
			local screenHeight = UIParent:GetHeight();
			local scale = owner:GetScale();
			if (x~=nil and y~=nil and left~=nil and right~=nil and top~=nil and bottom~=nil and screenWidth>0 and screenHeight>0) then
				setX = setX * scale;
				setY = setY * scale;
				x = x * scale;
				y = y * scale;
				left = left * scale;
				right = right * scale;
				width = right - left;
				top = top * scale;
				bottom = bottom * scale;
				local anchorPoint = "";
				if (y <= (screenHeight * (1/2))) then
					top = top + setY;
					anchorPoint = "TOP";
					if (top < 0) then
						setY = setY - top;
					end
				else
					setY = -setY;
					bottom = bottom + setY;
					anchorPoint = "BOTTOM";
					if (bottom > screenHeight) then
						setY = setY + (screenHeight - bottom);
					end
				end			
				if (x <= (screenWidth * (1/2))) then
					left = left + setX;
					if (anchorPoint == "BOTTOM") then
						anchorPoint = anchorPoint.."RIGHT";
						setX = setX - width;
						if (left < 0) then
							setX = setX - left;
						end
					else
						anchorPoint = anchorPoint.."LEFT";
						if (left < 0) then
							setX = setX - left;
						end
					end
				else
					setX = -setX;
					right = right + setX;
					if (anchorPoint == "BOTTOM") then
						anchorPoint = anchorPoint.."LEFT";
						setX = setX + width;
						if (right > screenWidth) then
							setX = setX - (right - screenWidth);
						end
					else
						anchorPoint = anchorPoint.."RIGHT";
						if (right > screenWidth) then
							setX = setX + (screenWidth - right);
						end
					end
				end
				
				if (anchorPoint == "") then
					anchorPoint = "TOPLEFT";
				end
				scale = tooltip:GetScale();
				if (scale) then
					setX = setX / scale;
					setY = setY / scale;
				end
				tooltip:SetOwner(owner, "ANCHOR_"..anchorPoint, setX, setY);
			end
		else
			tooltip:SetOwner(owner, "ANCHOR_TOPLEFT");
		end
	end;


	--
	-- protectTooltipMoney ()
	--
	-- Args:
	--  None.
	--
	-- Returns:
	--  Nothing.
	--
	--  Thanks to Telo for providing this solution!
	--  Prevents the clearing of money from tooltips. Changes GameTooltip_ClearMoney.
	--  USE WITH CAUTION! ALWAYS CALL unprotectMoneyTooltip() AFTER SETTING THE TOOLTIP!
	--
	protectTooltipMoney = function()
		if ( not Sea.wow.tooltip.saved_GameTooltip_ClearMoney ) then
			Sea.wow.tooltip.saved_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
			GameTooltip_ClearMoney = Sea.wow.tooltip.doNothingTooltipMoney;
		end
	end;

	--
	-- unprotectTooltipMoney ()
	--
	-- Args:
	--  None.
	--
	-- Returns:
	--  Nothing.
	--
	--  Thanks to Telo for providing this solution!
	--  Allows the clearing of money from tooltips. Changes GameTooltip_ClearMoney.
	--
	unprotectTooltipMoney = function()
		if ( Sea.wow.tooltip.saved_GameTooltip_ClearMoney ) then
			GameTooltip_ClearMoney = Sea.wow.tooltip.saved_GameTooltip_ClearMoney;
			Sea.wow.tooltip.saved_GameTooltip_ClearMoney = nil;
		end
	end;
	
	--
	-- unprotectTooltipMoney ()
	--
	-- Args:
	--  None.
	--
	-- Returns:
	--  Nothing.
	--
	--  Does nothing.
	--
	doNothingTooltipMoney = function()
	end;
	
	saved_GameTooltip_ClearMoney = nil;
};
