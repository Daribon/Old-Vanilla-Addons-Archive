--[[
-- 
-- GuildedTradersGUI is the Guilded Traders sub-frame user interface
--
--]]
GUILDED_TRADERS_CRAFT_LIST_MEMBERS_TO_DISPLAY = 20;
GUILDED_TRADERS_CRAFT_LIST_FRAME_HEIGHT = 80;

GUILDED_TRADERS_ITEMS_TO_DISPLAY = 8;
GUILDED_TRADERS_ITEMS_FRAME_HEIGHT = 32;

GUILDED_TRADERS_ITEM_PATTERN = "|c(%x+)|H(item:%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r";

MoneyTypeInfo["GUILDED"] = {
	UpdateFunc = function()
		return this.staticMoney;
	end,
	showSmallerCoins = 1,
	collapse = nil,
	truncateSmallCoins = nil,
};

GuildedTradersGUI = {
    containerItemClickedOriginal = nil;
	merchantItemClickedOriginal = nil;
	inventoryItemClickedOriginal = nil;
	inspectInventoryItemClickedOriginal = nil;
	bankItemButtonClickedOriginal = nil;

    --[[
    -- onLoad()
    --     OnLoad initialisation function
    --]]
    onLoad = function()
		GuildedTraders.onLoad();

    	PanelTemplates_SetNumTabs(this, 4);
		GuildedTradersFrame.selectedTab = 4;
		
		-- Still under construction
--	    PanelTemplates_DisableTab(GuildedTradersFrame, 1);
--	    PanelTemplates_DisableTab(GuildedTradersFrame, 2);
--	    PanelTemplates_DisableTab(GuildedTradersFrame, 3);

	    PanelTemplates_UpdateTabs(GuildedTradersFrame);
		
        -- Hook ContainerFrameItemButton_OnClick
		GuildedTradersGUI.containerItemClickedOriginal = ContainerFrameItemButton_OnClick;
		ContainerFrameItemButton_OnClick = GuildedTradersGUI.containerItemClicked;

        -- Hook MerchantItemButton_OnClick
		GuildedTradersGUI.merchantItemClickedOriginal = MerchantItemButton_OnClick;
		MerchantItemButton_OnClick = GuildedTradersGUI.merchantItemClicked;

        -- Hook PaperDollItemSlotButton_OnClick
		GuildedTradersGUI.inventoryItemClickedOriginal = PaperDollItemSlotButton_OnClick;
		PaperDollItemSlotButton_OnClick = GuildedTradersGUI.inventoryItemClicked;

        -- Hook PaperDollItemSlotButton_OnClick
		GuildedTradersGUI.inspectInventoryItemClickedOriginal = InspectPaperDollItemSlotButton_OnClick;
		InspectPaperDollItemSlotButton_OnClick = GuildedTradersGUI.inspectInventoryItemClicked;

        -- Hook BankFrameItemButtonGeneric_OnClick
		GuildedTradersGUI.bankItemButtonClickedOriginal = BankFrameItemButtonGeneric_OnClick;
		BankFrameItemButtonGeneric_OnClick = GuildedTradersGUI.bankItemButtonClicked;

	end;


    --[[
    -- onUpdate()
    --     Update the Traders sub-frame display
    --]]
    onUpdate = function()
	    if ( (GuildedTradersFrame.selectedTab == 1)
	      or (GuildedTradersFrame.selectedTab == 2) ) then
            GuildedTradersFrameCraft:Hide();
            GuildedTradersFrameStock:Hide();
            GuildedTradersFrameBuySell:Show();
    	    GuildedTradersFrameRemoveButton:Disable();
            GuildedTradersGUI.onUpdateBuySell();
		elseif (GuildedTradersFrame.selectedTab == 3) then
            GuildedTradersFrameCraft:Hide();
            GuildedTradersFrameBuySell:Hide();
            GuildedTradersFrameStock:Show();
    	    GuildedTradersFrameWhisperButton:Disable();
            GuildedTradersGUI.onUpdateStock();
		elseif (GuildedTradersFrame.selectedTab == 4) then
            GuildedTradersFrameBuySell:Hide();
            GuildedTradersFrameStock:Hide();
            GuildedTradersFrameCraft:Show();
    	    GuildedTradersFrameRemoveButton:Disable();
            GuildedTradersGUI.onUpdateCrafts();
		end
	end;


    --[[
    -- onUpdateBuySell()
    --     Update the Traders Buy/Sell sub-frame display
    --]]
    onUpdateBuySell = function()
    	local button;
    	local buySellListOffset = FauxScrollFrame_GetOffset(GuildedTradersFrameBuySellScroll);
    	local index;
		local stockTable;
		
	    if (GuildedTradersFrame.selectedTab == 1) then
		    stockTable = GuildedData.getItemTable("WTB");
		elseif (GuildedTradersFrame.selectedTab == 2) then
		    stockTable = GuildedData.getItemTable("WTS");
		else
		    return;
		end

		-- Check if selected item has been removed.
		if ( GuildedData.findItem(GuildedTradersFrameBuySell.selectedLink, GuildedTradersFrameBuySell.selectedOwner) < 0 ) then
		    GuildedTradersFrameBuySell.selectedLink = nil;
    	    GuildedTradersFrameBuySell.selectedOwner = nil;
		end
		GuildedTradersFrameBuySell.selectedMember = nil;
		
		local i = 1;
    	for index = 1 + buySellListOffset, buySellListOffset + GUILDED_TRADERS_ITEMS_TO_DISPLAY do
		    if ( index > table.getn(stockTable) ) then
			    break;
			end
		    item = stockTable[index];

			local button = getglobal("GuildedTradersFrameBuySellButton"..i);
    		button.index = index;
			button.link = item.link;
			button.owner = item.owner;

			local itemButton = getglobal("GuildedTradersFrameBuySellButton"..i.."Item");
			SetItemButtonCount(itemButton, item.itemCount);
			SetItemButtonTexture(itemButton, item.texture);

			local itemText = getglobal("GuildedTradersFrameBuySellButton"..i.."Name");
			itemText:SetText(string.gsub(item.link, GUILDED_TRADERS_ITEM_PATTERN, "|c%1%3"));
			
			local itemOwner = getglobal("GuildedTradersFrameBuySellButton"..i.."Owner");
			itemOwner:SetText(item.owner);
			
			local itemCash = getglobal("GuildedTradersFrameBuySellButton"..i.."MoneyFrame");
			MoneyFrame_Update(itemCash:GetName(), item.price);
			
    		-- Highlight the correct who
			if ( ( GuildedTradersFrameBuySell.selectedLink == item.link ) 
			 and ( GuildedTradersFrameBuySell.selectedOwner == item.owner ) ) then
			    GuildedTradersFrameBuySell.selectedMember = index;
			end

	    	if ( GuildedTradersFrameBuySell.selectedMember == index ) then
		    	button:LockHighlight();
    		else
	    		button:UnlockHighlight();
		    end
		
   			button:Show();
			
			i = i + 1;
			if (i > GUILDED_TRADERS_ITEMS_TO_DISPLAY) then
			    break;
		    end
		end
		
		while ( i <= GUILDED_TRADERS_ITEMS_TO_DISPLAY ) do
		    getglobal("GuildedTradersFrameBuySellButton"..i):Hide();
			i = i + 1;
		end

    	if ( not GuildedTradersFrameBuySell.selectedMember ) then
		    GuildedTradersFrameWhisperButton:Disable();
	    else
		    GuildedTradersFrameWhisperButton:Enable();
	    end

    	-- ScrollFrame update
		if (table.getn(stockTable) <= GUILDED_TRADERS_ITEMS_TO_DISPLAY) then
    	    FauxScrollFrame_Update(GuildedTradersFrameBuySellScroll, 1, 0, 0 );
		else
    	    FauxScrollFrame_Update(GuildedTradersFrameBuySellScroll, table.getn(stockTable), GUILDED_TRADERS_ITEMS_TO_DISPLAY, GUILDED_TRADERS_ITEMS_FRAME_HEIGHT );
		end
	end;


    --[[
    -- onUpdateStock()
    --     Update the Traders Stock sub-frame display
    --]]
    onUpdateStock = function()
    	local button;
    	local stockListOffset = FauxScrollFrame_GetOffset(GuildedTradersFrameItemScroll);
    	local index;

		-- Check if selected member has left.
		if ( GuildedConfig.findItem(GuildedTradersFrameStock.selectedLink) < 0 ) then
		    GuildedTradersFrameStock.selectedLink = nil;
    	    GuildedTradersFrameStock.selectedOwner = nil;
		end
		GuildedTradersFrameStock.selectedMember = nil;
		
		local i = 1;
    	for index = 1 + stockListOffset, stockListOffset + GUILDED_TRADERS_ITEMS_TO_DISPLAY do
		    if ( index > GuildedConfig.numStock ) then
			    break;
			end
		    item = GuildedConfig.stock[index];

			local button = getglobal("GuildedTradersFrameItemButton"..i);
    		button.index = index;
			button.link = item.link;
			button.owner = UnitName("player");

			local itemButton = getglobal("GuildedTradersFrameItemButton"..i.."Item");
			SetItemButtonCount(itemButton, item.itemCount);
			SetItemButtonTexture(itemButton, item.texture);

			local itemText = getglobal("GuildedTradersFrameItemButton"..i.."Name");
			itemText:SetText(string.gsub(item.link, GUILDED_TRADERS_ITEM_PATTERN, "|c%1%3"));
			
			local itemOwner = getglobal("GuildedTradersFrameItemButton"..i.."Owner");
			itemOwner:SetText(UnitName("player"));
			
			local itemCash = getglobal("GuildedTradersFrameItemButton"..i.."MoneyFrame");
			MoneyFrame_Update(itemCash:GetName(), item.price);

			local itemOwner = getglobal("GuildedTradersFrameItemButton"..i.."WTSTickboxTickbox");
			itemOwner:SetChecked(item.wts);
			
			local itemOwner = getglobal("GuildedTradersFrameItemButton"..i.."WTBTickboxTickbox");
			itemOwner:SetChecked(item.wtb);
			
    		-- Highlight the correct who
			if ( GuildedTradersFrameStock.selectedLink == item.link ) then
			    GuildedTradersFrameStock.selectedMember = index;
			end

	    	if ( GuildedTradersFrameStock.selectedMember == index ) then
		    	button:LockHighlight();
    		else
	    		button:UnlockHighlight();
		    end
		
   			button:Show();
			
			i = i + 1;
			if (i > GUILDED_TRADERS_ITEMS_TO_DISPLAY) then
			    break;
		    end
		end
		
		while ( i <= GUILDED_TRADERS_ITEMS_TO_DISPLAY ) do
		    getglobal("GuildedTradersFrameItemButton"..i):Hide();
			i = i + 1;
		end

    	if ( not GuildedTradersFrameStock.selectedMember ) then
		    GuildedTradersFrameRemoveButton:Disable();
	    else
		    GuildedTradersFrameRemoveButton:Enable();
	    end

    	-- ScrollFrame update
		if (GuildedConfig.numStock <= GUILDED_TRADERS_ITEMS_TO_DISPLAY) then
    	    FauxScrollFrame_Update(GuildedTradersFrameItemScroll, 1, 0, 0 );
		else
    	    FauxScrollFrame_Update(GuildedTradersFrameItemScroll, GuildedConfig.numStock, GUILDED_TRADERS_ITEMS_TO_DISPLAY, GUILDED_TRADERS_ITEMS_FRAME_HEIGHT );
		end
	end;


    --[[
    -- onUpdateCrafts()
    --     Update the Traders Craft sub-frame display
    --]]
    onUpdateCrafts = function()
    	local button;
    	local craftersListOffset = FauxScrollFrame_GetOffset(GuildedTradersFrameCraftScroll);
    	local index;
    	local showScrollBar = nil;
    	if ( GuildedData.numCrafters > GUILDED_TRADERS_CRAFT_LIST_MEMBERS_TO_DISPLAY ) then
	    	showScrollBar = 1;
	    end

		-- Check if selected member has left.
		if ( GuildedData.findCrafter(GuildedTradersFrameCraft.selectedName) < 0 ) then
		    GuildedTradersFrameCraft.selectedName = nil;
		end
	    GuildedTradersFrameCraft.selectedMember = nil;
		
		local i = 1;
    	for index = 1 + craftersListOffset, craftersListOffset + GUILDED_TRADERS_CRAFT_LIST_MEMBERS_TO_DISPLAY do
		    if ( index > GuildedData.numCrafters ) then
			    break;
			end
		    crafter = GuildedData.crafters[index];
    		button = getglobal("GuildedTradersFrameButton"..i);
    		button.index = index;
    		getglobal("GuildedTradersFrameButton"..i.."Name"):SetText(crafter.name);
	    	getglobal("GuildedTradersFrameButton"..i.."Prof"):SetText(crafter.prof);
		    getglobal("GuildedTradersFrameButton"..i.."Level"):SetText(crafter.level);
	    	getglobal("GuildedTradersFrameButton"..i.."Cat"):SetText(crafter.cat);
		
    		-- If need scrollbar resize columns
	    	if ( showScrollBar ) then
		    	getglobal("GuildedTradersFrameButton"..i.."Prof"):SetWidth(95);
    		else
	    		getglobal("GuildedTradersFrameButton"..i.."Prof"):SetWidth(110);
		    end
			
			if ( ( GuildedTradersFrameCraft.selectedName == crafter.name ) 
			 and ( GuildedTradersFrameCraft.selectedProf == crafter.prof ) ) then
			    GuildedTradersFrameCraft.selectedMember = index;
			end

    		-- Highlight the correct who
	    	if ( GuildedTradersFrameCraft.selectedMember == index ) then
		    	button:LockHighlight();
    		else
	    		button:UnlockHighlight();
		    end
		
   			button:Show();
			
			i = i + 1;
			if (i > GUILDED_TRADERS_CRAFT_LIST_MEMBERS_TO_DISPLAY) then
			    break;
		    end
		end
		
		while ( i <= GUILDED_TRADERS_CRAFT_LIST_MEMBERS_TO_DISPLAY ) do
		    getglobal("GuildedTradersFrameButton"..i):Hide();
			i = i + 1;
		end

    	if ( not GuildedTradersFrameCraft.selectedMember ) then
		    GuildedTradersFrameWhisperButton:Disable();
	    else
	    	GuildedTradersFrameWhisperButton:Enable();
	    end

    	-- If need scrollbar resize column headers
    	if ( showScrollBar ) then
	    	GuildedSetColumnWidth(105, GuildedTradersFrameCraftColumnHeader2);
    	else
	    	GuildedSetColumnWidth(120, GuildedTradersFrameCraftColumnHeader2);
    	end

    	-- ScrollFrame update
	    FauxScrollFrame_Update(GuildedTradersFrameCraftScroll, GuildedData.numCrafters, GUILDED_TRADERS_CRAFT_LIST_MEMBERS_TO_DISPLAY, 1 );
	end;


    --[[
    -- itemButtonOnClick()
    --     Click the stock item button
    --]]
    itemButtonOnClick = function(button, frame)
		if ( IsShiftKeyDown() ) then
        	if ( ChatFrameEditBox:IsVisible() ) then
        		ChatFrameEditBox:Insert(this.link);
	        end
		else
			frame.selectedLink = this:GetParent().link;
			frame.selectedOwner = this:GetParent().owner;
   		    GuildedTradersGUI.onUpdate();
		end
    end;


    --[[
    -- itemButtonOnEnter()
    --     Show the item tooltip
    --]]
    itemButtonOnEnter = function()
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		GameTooltip:SetHyperlink(string.gsub(this:GetParent().link, GUILDED_TRADERS_ITEM_PATTERN, "%2"));
		GameTooltip:Show();
    end;


    --[[
    -- onCraftButtonClick()
    --     Select the Guilded crafter that has been clicked on
    --]]
    onCraftButtonClick = function()
    	GuildedTradersFrameCraft.selectedMember = getglobal("GuildedTradersFrameButton"..this:GetID()).index;
	    GuildedTradersFrameCraft.selectedName = getglobal("GuildedTradersFrameButton"..this:GetID().."Name"):GetText();
	    GuildedTradersFrameCraft.selectedProf = getglobal("GuildedTradersFrameButton"..this:GetID().."Prof"):GetText();
    	GuildedTradersGUI.onUpdate();
    end;


    --[[
    -- whisperButtonOnClick()
    --     Click the whisper item button
    --]]
    whisperButtonOnClick = function()
	    local name;
		local msg = "";
	    if (GuildedTradersFrame.selectedTab == 1) then
		      name = GuildedTradersFrameBuySell.selectedOwner;
			  msg = format(GUILDED_TRADERS_WHISPER_ITEM_WTB, GuildedTradersFrameBuySell.selectedLink);
		elseif (GuildedTradersFrame.selectedTab == 2) then
		      name = GuildedTradersFrameBuySell.selectedOwner;
			  msg = format(GUILDED_TRADERS_WHISPER_ITEM_WTS, GuildedTradersFrameBuySell.selectedLink);
		elseif (GuildedTradersFrame.selectedTab == 3) then
		    return;
		elseif (GuildedTradersFrame.selectedTab == 4) then
		      name = GuildedTradersFrameCraft.selectedName;
			  msg = GUILDED_TRADERS_WHISPER_CRAFTER;
		end

	    if ( not name ) then
		    return;
		end
       	if ( not ChatFrameEditBox:IsVisible() ) then
       		ChatFrame_OpenChat("/w "..name.." "..msg);
        else
            ChatFrameEditBox:SetText("/w "..name.." "..msg);
        end
        ChatEdit_ParseText(ChatFrame1.editBox, 0);
    end;


    --[[
    -- removeButtonOnClick()
    --     Click the remove item button
    --]]
    removeButtonOnClick = function()
		if (GuildedTradersFrameStock.selectedLink) then
		    GuildedConfig.flagItem(GuildedTradersFrameStock.selectedLink, "WTS", false);
   		    GuildedTraders.sendBuySellItem(GuildedTradersFrameStock.selectedLink, "WTS");
		    GuildedConfig.flagItem(GuildedTradersFrameStock.selectedLink, "WTB", false);
   		    GuildedTraders.sendBuySellItem(GuildedTradersFrameStock.selectedLink, "WTB");
		    GuildedConfig.delItem(GuildedTradersFrameStock.selectedLink);
		    GuildedTradersFrameRemoveButton:Disable();
			GuildedTradersGUI.onUpdateStock();
		end
    end;

	
    --[[
    -- containerItemClicked(button, ignoreShift)
    --     Hook function for ContainerFrameItemButton_OnClick
    --]]
    containerItemClicked = function(button, ignoreShift)
    	if ( IsControlKeyDown() ) and ( GuildedTradersFrame:IsVisible() ) then
        	if ( button == "LeftButton" ) then
			    local texture, itemCount, locked, quality = GetContainerItemInfo(this:GetParent():GetID(), this:GetID());
				local link = GetContainerItemLink(this:GetParent():GetID(), this:GetID());
				GuildedConfig.addItem(link, texture, itemCount, locked, quality, 1);
				GuildedTradersGUI.onUpdateStock();
				return;
			end
		end
	
    	GuildedTradersGUI.containerItemClickedOriginal(button, ignoreShift);
    end;


    --[[
    -- merchantItemClicked(button)
    --     Hook function for MerchantItemButton_OnClick
    --]]
    merchantItemClicked = function(button)
    	if ( IsControlKeyDown() ) and ( GuildedTradersFrame:IsVisible() ) then
        	if ( button == "LeftButton" ) then
			
			    local name, texture, price, itemCount, numAvailable, isUsable = GetMerchantItemInfo(this:GetID());
				local link = GetMerchantItemLink(this:GetID());
				GuildedConfig.addItem(link, texture, itemCount, 0, 0, price);
				GuildedTradersGUI.onUpdateStock();
				return;
			end
		end
	
    	GuildedTradersGUI.merchantItemClickedOriginal(button);
    end;


    --[[
    -- inventoryItemClicked(button, ignoreShift)
    --     Hook function for PaperDollItemSlotButton_OnClick
    --]]
    inventoryItemClicked = function(button, ignoreShift)
    	if ( IsControlKeyDown() ) and ( GuildedTradersFrame:IsVisible() ) then
        	if ( button == "LeftButton" ) then
			    local texture = GetInventoryItemTexture("player", this:GetID());
				local link = GetInventoryItemLink("player", this:GetID());
				GuildedConfig.addItem(link, texture, 1, 0, 0, 1);
				GuildedTradersGUI.onUpdateStock();
				return;
			end
		end
	
    	GuildedTradersGUI.inventoryItemClickedOriginal(button, ignoreShift);
    end;


    --[[
    -- inspectInventoryItemClicked(button, ignoreShift)
    --     Hook function for InspectPaperDollItemSlotButton_OnClick
    --]]
    inspectInventoryItemClicked = function(button, ignoreShift)
    	if ( IsControlKeyDown() ) and ( GuildedTradersFrame:IsVisible() ) then
        	if ( button == "LeftButton" ) then
			    local texture = GetInventoryItemTexture(InspectFrame.unit, this:GetID());
				local link = GetInventoryItemLink(InspectFrame.unit, this:GetID());
				GuildedConfig.addItem(link, texture, 1, 0, 0, 1);
				GuildedTradersGUI.onUpdateStock();
				return;
			end
		end
	
    	GuildedTradersGUI.inspectInventoryItemClickedOriginal(button, ignoreShift);
    end;


    --[[
    -- bankItemButtonClicked(button)
    --     Hook function for BankFrameItemButtonGeneric_OnClick
    --]]
    bankItemButtonClicked = function(button)
    	if ( IsControlKeyDown() ) and ( GuildedTradersFrame:IsVisible() ) then
        	if ( button == "LeftButton" ) then
			    local texture, itemCount, locked, quality = GetContainerItemInfo(BANK_CONTAINER, this:GetID());
				local link = GetContainerItemLink(BANK_CONTAINER, this:GetID());
				GuildedConfig.addItem(link, texture, itemCount, locked, quality, 1);
				GuildedTradersGUI.onUpdateStock();
				return;
			end
		end
	
    	GuildedTradersGUI.bankItemButtonClickedOriginal(button);
    end;
};
