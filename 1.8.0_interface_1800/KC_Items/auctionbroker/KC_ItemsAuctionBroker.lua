
KC_ItemsAuctionBroker = KC_ItemsModuleClass:new({
	type		 = "broker",
	name		 = KC_AuctionBrokerLocals.name,
	desc		 = KC_AuctionBrokerLocals.desc,
	cmdOptions	 = KC_AuctionBrokerLocals.cmds,
    db           = AceDbClass:new("KC_AuctionBrokerDB"),
	optPath		 = {"options"},
})

function KC_ItemsAuctionBroker:Enable()
	self:Hook("ContainerFrameItemButton_OnClick", "BagClick");
	self:Hook("OpenMail_Update", "OpenMail");
	
	self.undercut = tonumber(self:GetOpt("cut", optPath)) or 1;
	self:RegisterEvent("AUCTION_HOUSE_SHOW", "HookAuctionFrame");
end

function KC_ItemsAuctionBroker:HookAuctionFrame()
	self:hookAutofill(self:GetOpt("autofill", optPath));
	self:UnregisterEvent("AUCTION_HOUSE_SHOW");
end

function KC_ItemsAuctionBroker:hookAutofill(state)
	if (state) then
		self:RegisterEvent("NEW_AUCTION_UPDATE", "autofill");
		self:HookScript(AuctionsCreateAuctionButton, "OnClick", "CreateAuction");
	else
		self:UnregisterEvent("NEW_AUCTION_UPDATE");
		self:UnhookScript(AuctionsCreateAuctionButton, "OnClick");
	end
end

function KC_ItemsAuctionBroker:autofill()
	local factionID = self:GetRealmFactionID();

	local name, texture, qty, quality, canUse, price = GetAuctionSellItemInfo();
	if (not name) then return; end	
	
	local code = self:GetCodeByName(name);
	
	local min, buy = self:GetLastPrices(code, factionID);

	if (not min or not buy and self.app.auction) then
		_, _, min, _, _, _, buy = self.app.auction:getItemData(code)
		if (buy and min) then
			min = min and (min * self.undercut);
			buy = buy and (buy * self.undercut);			
		end
	end

	if (self.app.sellvalue) then
		local vsell, vbuy = self:GetItemPrices(code);		
		if (not min or not buy) then
			min = vsell * 2.5;
			buy = vsell * 3.5;
		elseif (min < vsell) then
			min = vsell * 1.05;
		elseif (buy < vsell) then
			min = vsell * 1.5;
			buy = vsell * 1.75;
		end
	end
	
	if (buy < min) then
		buy = min * 1.05
	end

	if (min) then
		MoneyInputFrame_SetCopper(StartPrice, min * qty);		
	end
	if (buy) then
		MoneyInputFrame_SetCopper(BuyoutPrice, buy * qty);			
	end
end

function KC_ItemsAuctionBroker:GetLastPrices(code, factionID)
	return (self.db:get({factionID, "min"}, code)), (self.db:get({factionID, "buy"}, code));
end

function KC_ItemsAuctionBroker:CreateAuction()
	local name, texture, qty, quality, canUse, price = GetAuctionSellItemInfo();
	local min = floor(MoneyInputFrame_GetCopper(StartPrice) / qty);
	local buy = floor(MoneyInputFrame_GetCopper(BuyoutPrice) / qty);
	
	local code = self:GetCodeByName(name);
	
	local factionID = self:GetRealmFactionID();

	self.db:set({factionID, "min"}, code, min);
	self.db:set({factionID, "buy"}, code, buy);

	self:CallScript(AuctionsCreateAuctionButton, "OnClick");
end

function KC_ItemsAuctionBroker:BagClick(button, ignore)
	if (AuctionFrame and AuctionFrame:IsVisible()) then
		local link = GetContainerItemLink(this:GetParent():GetID(), this:GetID());

		if (button == "LeftButton" and IsAltKeyDown() and link) then
			self.oneclick = TRUE;
			PickupContainerItem(this:GetParent():GetID(), this:GetID());
			ClickAuctionSellItemButton();
			if (not self:GetOpt("autofill", optPath)) then
				self:autofill();
			end
			if (self.oneclick) then
				self:CallScript(AuctionsCreateAuctionButton, "OnClick");
				self.oneclick = FALSE;			
			end
		end
	end
	self:CallHook("ContainerFrameItemButton_OnClick", button, ignore);
end

function KC_ItemsAuctionBroker:OpenMail()
	self:CallHook("OpenMail_Update");

	if ( not InboxFrame.openMailID ) then return; end

	local _, _, _, subject, money, _, _, hasItem= GetInboxHeaderInfo(InboxFrame.openMailID);
	if ((not hasItem and not money) or (not subject)) then return; end

	local expired	= format(AUCTION_EXPIRED_MAIL_SUBJECT, "");
	local outbid	= format(AUCTION_OUTBID_MAIL_SUBJECT, "");
	local cancled	= format(AUCTION_REMOVED_MAIL_SUBJECT, "");
	local sold		= format(AUCTION_SOLD_MAIL_SUBJECT, "");
	local won		= format(AUCTION_WON_MAIL_SUBJECT, "");
	
	if (money) then
		TakeInboxMoney(InboxFrame.openMailID)
	end
	if (strfind(subject, expired)) then
		TakeInboxItem(InboxFrame.openMailID);
	elseif (strfind(subject, sold)) then
		TakeInboxItem(InboxFrame.openMailID);
	elseif (strfind(subject, won)) then
		TakeInboxItem(InboxFrame.openMailID);	
	elseif (strfind(subject, cancled)) then
		TakeInboxItem(InboxFrame.openMailID);
	elseif (strfind(subject, outbid)) then
		TakeInboxItem(InboxFrame.openMailID);		
	end

end

function KC_ItemsAuctionBroker:GetRealmFactionID()
	local faction = UnitFactionGroup("player");
	if (GetMinimapZoneText() == "Gadgetzan") then
		faction = "Gadgetzan";
	end
	return ace.char.realm .. "|" .. faction;
end

-- Chat Commands

function KC_ItemsAuctionBroker:togAutofill()
	local status = self:TogOpt("autofill", optPath);
	self:hookAutofill(status);
	self:Result(KC_AucitonBrokerStringTable.autofillstate, status, ACEG_MAP_ENABLED);
end

function KC_ItemsAuctionBroker:setcut(amount)
	if (tonumber(amount) and tonumber(amount) > 0) then
		self:SetOpt("cut", optPath, amount);
		self:Result(KC_AucitonBrokerStringTable.cutset, amount);
	else
		self:Msg(KC_AucitonBrokerStringTable.amountError)
	end
end

-- Registering with KCI
KC_Items:Register(KC_ItemsAuctionBroker)