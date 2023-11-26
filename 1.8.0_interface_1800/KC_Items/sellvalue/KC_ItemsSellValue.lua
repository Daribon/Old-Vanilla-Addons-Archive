
KC_ItemsSellValueClass = KC_ItemsModuleClass:new({
	type		 = "sellvalue",
	name		 = KC_SELLVALUE_NAME,
	desc		 = KC_SELLVALUE_DESCRIPTION,
	cmdOptions	 = KC_SELLVALUE_CMD_OPTIONS,
	--dependencies = {"test"},
	optPath		 = {"sellvalue", "options"},
})

function KC_ItemsSellValueClass:Enable()
	self:RegisterEvent("MERCHANT_SHOW"		, "MerchantOpen")
	self:RegisterEvent("MERCHANT_UPDATE"	, "GetBuyPrices");

	if (self.app.tooltip) then
		self.app.tooltip:RegisterFunc(self, "DisplayInfo");
	end
end

function KC_ItemsSellValueClass:MerchantOpen()
	self:GetSellPrices();
	self:GetBuyPrices();
end

function KC_ItemsSellValueClass:GetSellPrices()
	self:Hook("SetTooltipMoney")
	self._itemPrice = nil

	local itemPrice, bag, slot, qty

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			textlink = GetContainerItemLink(bag, slot);
			if(textlink) then
				id = self:GetCode(textlink);
				GameTooltip:SetBagItem(bag, slot)
				if(self._itemPrice) then
					_, qty = GetContainerItemInfo(bag, slot)
					self:UpdatePrices(id, self._itemPrice/qty, nil)
					self._itemPrice = nil
				end
			end
		end
	end
	self:Unhook("SetTooltipMoney")
end

function KC_ItemsSellValueClass:SetTooltipMoney(obj, money)
	self._itemPrice = money
	self:CallHook("SetTooltipMoney", obj, money)
end

function KC_ItemsSellValueClass:GetBuyPrices()
	local numMerchantItems = GetMerchantNumItems();
	local name, texture, price, quantity, numAvailable, isUsable;
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i);
		if ( index <= numMerchantItems ) then
			name, texture, price, qty, numAvailable, isUsable = GetMerchantItemInfo(index);
			code = self:GetCode(GetMerchantItemLink(index));
			self:UpdatePrices(code, nil, price/qty);
		end
	end
end

function KC_ItemsSellValueClass:UpdatePrices(code, sell, buy)
	if (code) then	
		local oSell, oBuy = self:GetItemPrices(code)
		local nSell = oSell;
		local nBuy = oBuy;
		if (oSell and sell and oSell ~= sell) then
			nSell = sell;
			if (oSell == 0) then self.app:incSell(); end
		end
		if (oBuy and buy and oBuy ~= buy) then
			nBuy = buy;
			if (oBuy == 0) then	self.app:incCost();	end
		end
		self:SetItemPrices(code, nSell, nBuy);
	end
end

function KC_ItemsSellValueClass:DisplayInfo(tooltip, code, qty, hooker)
	local sell, buy = self:GetItemPrices(code)
	local showsingle = self:GetOpt("single", self.optPath);

	if (self:GetOpt("short", self.optPath)) then
		if (sell and sell > 0 and qty) then
			local label = format(KC_SELLVALUE_TEXT_SELLS_FOR_SHORT, qty);
			local label = (showsingle and qty > 1) and label .. KC_SELLVALUE_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and sell;
			hooker:AddPriceLine(tooltip, sell * qty, label, single, KC_SELLVALUE_TEXT_SEP, KC_SELLVALUE_SEPCOLOR);
		end	
		if (buy and buy > 0 and qty) then
			local label = format(KC_SELLVALUE_TEXT_BUYS_FOR_SHORT, qty);
			local label = (showsingle and qty > 1) and label .. KC_SELLVALUE_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and buy;
			hooker:AddPriceLine(tooltip, buy * qty, label, single, KC_SELLVALUE_TEXT_SEP, KC_SELLVALUE_SEPCOLOR);
		end	
	else
		if (sell and sell > 0 and qty) then
			local label = format(KC_SELLVALUE_TEXT_SELLS_FOR_LONG, qty);
			local label = (showsingle and qty > 1) and label .. KC_SELLVALUE_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and sell;
			hooker:AddPriceLine(tooltip, sell * qty, label, single, KC_SELLVALUE_TEXT_SEP, KC_SELLVALUE_SEPCOLOR);
		end	
		if (buy and buy > 0 and qty) then
			local label = format(KC_SELLVALUE_TEXT_BUYS_FOR_LONG, qty);
			local label = (showsingle and qty > 1) and label .. KC_SELLVALUE_TEXT_EACH or label;
			local single = (showsingle and qty > 1) and buy;
			hooker:AddPriceLine(tooltip, buy * qty, label, single, KC_SELLVALUE_TEXT_SEP, KC_SELLVALUE_SEPCOLOR);
		end	

	end
end

-- Chat Commands.

function KC_ItemsSellValueClass:short()
	local status = self:TogOpt("short", self.optPath);
	self:Result(KC_SELLVALUE_TEXT_SHORT_DISPLAY_MODE, status, ACEG_MAP_ENABLED);
end

function KC_ItemsSellValueClass:single()
	local status = self:TogOpt("single", self.optPath);
	self:Result(KC_SELLVALUE_TEXT_DISPLAY_OF_SINGLE, status, ACEG_MAP_ENABLED);
end

-- Registering with KCI
KC_Items:Register(KC_ItemsSellValueClass:new())