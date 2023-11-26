--[[

	MonkeyQuest:
	Displays your quests for quick viewing.
	
	Website:	http://wow.visualization.ca/
	Author:		Trentin (monkeymods@gmail.com)
	
	
	Contributors:
	Celdor
		- Help with the Quest Log Freeze bug
		
	Diungo
		- Toggle grow direction
		
	Pkp
		- Color Quest Titles the same as the quest level
	
	wowpendium.de
		- German translation
		
	MarsMod
		- Valid player name before the VARIABLES_LOADED event bug
		- Settings resetting bug

--]]


function MonkeyQuest_NEW_GameTooltip_OnEvent()
	
	-- call the old (probably blizzard's) GameTooltip_OnEvent()
	MonkeyQuest_OLD_GameTooltip_OnEvent();
	
	if (event ~= nil) then
		if (event == "CLEAR_TOOLTIP") then
			return;
		end
	end
	
	-- check if this is a quest item
	MonkeyQuest_SearchTooltip();
end

function MonkeyQuest_NEW_ContainerFrameItemButton_OnEnter()
	-- call the old (probably blizzard's) GameTooltip_OnEvent()
	MonkeyQuest_OLD_ContainerFrameItemButton_OnEnter();
	
	MonkeyQuest_SearchTooltip();
end

function MonkeyQuest_SearchTooltip()
	local ii, jj;
	
	
	-- does the user not want this feature?
	if (MonkeyQuestConfig[MonkeyQuest.m_strPlayer].m_bShowTooltipObjectives == false) then
		return false;
	end
	
	if (GameTooltip == nil) then
		return false;
	end
	
	if (not GameTooltip:IsVisible()) then
		return false;
	end
	
	-- first loop through look for MONKEYQUEST_TOOLTIP_QUESTITEM, if it's there then we are outtie
	for i = 1, 30, 1 do
		if (not getglobal("GameTooltipTextLeft" .. i):IsVisible()) then
			-- no more tooltip text, on to the next loop
			break;
		end
		
		-- check the string isn't nil
		if (getglobal("GameTooltipTextLeft" .. i):GetText() ~= nil) then
			
			ii, jj = string.find(getglobal("GameTooltipTextLeft" .. i):GetText(), MONKEYQUEST_TOOLTIP_QUESTITEM);
			if (ii ~= nil) then
				return false;
			end
		end
	end
	
	-- second loop through see if it's a quest item
	for i = 1, 30, 1 do
		if (not getglobal("GameTooltipTextLeft" .. i):IsVisible()) then
			-- no more tooltip text, get out
			return false;
		end
		
		-- check the string isn't nil
		if (getglobal("GameTooltipTextLeft" .. i):GetText() ~= nil) then
			if (MonkeyQuest_SearchQuestListItem(getglobal("GameTooltipTextLeft" .. i):GetText()) == true) then
				return true;
			end
		end
	end
	
	-- didn't find an item needing the MonkeyQuest tooltip
	return false;
end

function MonkeyQuest_SearchQuestListItem(strSearch)
	local i, j, length, iStrKeySize, iStrSearchSize;

	
	-- super double check for nil string
	if (strSearch == nil) then
		return false;
	end

	--DEFAULT_CHAT_FRAME:AddMessage("Searching: " .. strSearch);
	
	for key, value in MonkeyQuest.m_aQuestItemList do
		i, j = string.find(key, strSearch);

		iStrKeySize = string.len(key);
		iStrSearchSize = string.len(strSearch);

		--DEFAULT_CHAT_FRAME:AddMessage(key .. " == " .. strSearch);
		
		if (i ~= nil and i ~= j and iStrSearchSize == iStrKeySize) then
			-- found it!
			-- DEFAULT_CHAT_FRAME:AddMessage(key .. " == " .. strSearch .. " i= " .. i .. " j= " .. j);
			
			GameTooltip:AddLine(MONKEYQUEST_TOOLTIP_QUESTITEM .. " " .. value.m_iNumItems .. "/" .. value.m_iNumNeeded,
				ITEM_QUALITY6_TOOLTIP_COLOR.r, ITEM_QUALITY6_TOOLTIP_COLOR.g, ITEM_QUALITY6_TOOLTIP_COLOR.b, 1);
				
			-- resize the tootip (thanks Turan's AuctionIt)
			length = getglobal(GameTooltip:GetName() .. "TextLeft" .. GameTooltip:NumLines()):GetStringWidth();
			-- Give the text some border space on the right side of the tooltip.
			length = length + 22;
		
			GameTooltip:SetHeight(GameTooltip:GetHeight() + 14);
			if ( length > GameTooltip:GetWidth() ) then
				GameTooltip:SetWidth(length);
			end
			
			return true;
		end
	end

	return false;
end
