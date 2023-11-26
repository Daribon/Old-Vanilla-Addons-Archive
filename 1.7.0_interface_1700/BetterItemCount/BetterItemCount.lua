--------------------------------------------------------------------------
-- BetterItemCount.lua 
--------------------------------------------------------------------------
--[[
Better Item Count 

author: AnduinLothar    <Anduin@cosmosui.org>

Replaces some old Cosmos FrameXML Hacks.
-Better Item Count displays #.#k instead of * for counts > 999

]]--


function BetterItemCount_OnLoad()
	
	Sea.util.hook( "SetItemButtonCount", "BetterItemCount_SetItemButtonCount", "replace" );
	
end


function BetterItemCount_SetItemButtonCount(button, count)
	-- orig by Miyke
	if ( not button ) then
		return;
	end

	if ( not count ) then
		count = 0;
	end

	button.count = count;
	if ( count > 1 or (button.isBag and count > 0) ) then
		if ( count > 999 ) then 
			local fixedCount = count+50;
			count = floor((fixedCount)/1000).."."..floor(((mod(fixedCount, 1000))/100)).."k";
		end 
		getglobal(button:GetName().."Count"):SetText(count);
		getglobal(button:GetName().."Count"):Show();
	else
		getglobal(button:GetName().."Count"):Hide();
	end
end

