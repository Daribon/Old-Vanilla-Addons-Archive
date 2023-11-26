
KC_ItemsTooltipHooker = KC_ItemsModuleClass:new({
	type		 = "tooltip",
	name		 = KC_TOOLTIPHOOKER_NAME,
	desc		 = KC_TOOLTIPHOOKER_DESCRIPTION,
	cmdOptions	 = KC_TOOLTIPHOOKER_CMD_OPTIONS,
	optPath		 = {"tooltip", "options"},
})

function KC_ItemsTooltipHooker:Enable()
	self:Hook("GameTooltip_OnHide");
	self:Hook("GameTooltip_ClearMoney");
	self:HookScript(ItemRefTooltip, "OnHide", "ItemRefTooltip_OnHide");
	self:Hook(GameTooltip, "SetAuctionItem", "GameTooltip_SetAuctionItem");
	self:Hook(GameTooltip, "SetQuestLogItem", "GameTooltip_SetQuestLogItem");
	self:Hook(GameTooltip, "SetQuestItem", "GameTooltip_SetQuestItem");
	self:Hook(GameTooltip, "SetLootItem", "GameTooltip_SetLootItem")
	self:Hook("SetItemRef");
	self:Hook(GameTooltip, "SetInventoryItem", "GameTooltip_SetInventoryItem")
	self:HookSetBag();
	self:Hook(GameTooltip, "SetTradeSkillItem",	"GameTooltip_SetTradeSkillItem")
	self:Hook(GameTooltip, "SetHyperlink", "GameTooltip_SetHyperlink")

	self:RegisterEvent("MERCHANT_SHOW"		, "UnhookSetBag")	
	self:RegisterEvent("MERCHANT_CLOSED"	, "HookSetBag")
end

function KC_ItemsTooltipHooker:UnhookSetBag()
	self:Unhook(GameTooltip, "SetBagItem")
end

function KC_ItemsTooltipHooker:HookSetBag()
	self:Hook(GameTooltip, "SetBagItem", "GameTooltip_SetBagItem")
end

function KC_ItemsTooltipHooker:GameTooltip_OnHide()
    self:CallHook("GameTooltip_OnHide");
    self._itemEntered = FALSE;
    self._priceAdded  = FALSE;
	if (TTHookerTooltip:IsVisible()) then
		TTHookerTooltip:Hide();
	end
end

function KC_ItemsTooltipHooker:ItemRefTooltip_OnHide()
    self._itemEntered = FALSE;
    self._priceAdded  = FALSE;
	if (TTHookerItemRef:IsVisible()) then
		TTHookerItemRef:Hide();
	end
end

function KC_ItemsTooltipHooker:GameTooltip_ClearMoney()
    self:CallHook("GameTooltip_ClearMoney");
    self._priceAdded = FALSE;
end

function KC_ItemsTooltipHooker:GameTooltip_SetQuestItem(type, index)
	self:CallHook(GameTooltip, "SetQuestItem", type, index);
	local link = GetQuestItemLink(type, index);
	local _, _, qty = GetQuestItemInfo(type, index);

	self._itemEntered = TRUE;
	
	self:DisplayTooltipPrice(GameTooltip, link, qty);
end

function KC_ItemsTooltipHooker:GameTooltip_SetAuctionItem(type, index)
	self:CallHook(GameTooltip, "SetAuctionItem", type, index);
	local link, qty;
	link = GetAuctionItemLink(type, index);
	_, _, qty  = GetAuctionItemInfo(type, index);

	self._itemEntered = TRUE;

	self:DisplayTooltipPrice(GameTooltip, link, qty);
end

function KC_ItemsTooltipHooker:GameTooltip_SetQuestLogItem(type, id)
	self:CallHook(GameTooltip, "SetQuestLogItem", type, id);
	local link, qty;
	link = GetQuestLogItemLink(type, id);
	_, _, qty = GetQuestItemInfo(type, id)

	self._itemEntered = TRUE;

	self:DisplayTooltipPrice(GameTooltip, link, qty);
end

function KC_ItemsTooltipHooker:GameTooltip_SetLootItem(slot)
	self:CallHook(GameTooltip, "SetLootItem", slot);
	local link, qty;
	link = GetLootSlotLink(slot);
	_, _, qty = GetLootSlotInfo(slot)

	self._itemEntered = TRUE;

	self:DisplayTooltipPrice(GameTooltip, link, qty);
end

function KC_ItemsTooltipHooker:GameTooltip_SetInventoryItem(type, slot)
	local results = {self:CallHook(GameTooltip, "SetInventoryItem", type, slot)};
	local link, qty;
	
	if (type) then
		link = GetInventoryItemLink(type, slot);	
		qty = GetInventoryItemCount(type, slot);
		if (link and qty == 0) then qty = 1; end
	else
		link = GetContainerItemLink(BANK_CONTAINER, this:GetID());
		_, qty = GetContainerItemInfo(BANK_CONTAINER, this:GetID());
		if (link and qty == 0) then qty = 1; end
	end

	self._itemEntered = TRUE;

	self:DisplayTooltipPrice(GameTooltip, link, qty)
	return unpack(results);
end

function KC_ItemsTooltipHooker:GameTooltip_SetBagItem(bag, slot)
	self:CallHook(GameTooltip, "SetBagItem", bag, slot);
	local link, qty;
	link = GetContainerItemLink(bag, slot);
	_, qty = GetContainerItemInfo(bag, slot);

	self._itemEntered = TRUE;

	self:DisplayTooltipPrice(GameTooltip, link, qty)
end

function KC_ItemsTooltipHooker:GameTooltip_SetTradeSkillItem(skill, id)
	self:CallHook(GameTooltip, "SetTradeSkillItem", skill, id);
	
	local link, qty;

	if (id) then
		link = GetTradeSkillReagentItemLink(skill, id);		
		_, _, _, qty = GetTradeSkillReagentInfo(skill, id);
	else
		link = GetTradeSkillItemLink(skill);
		qty = self:GetMaxStackSize(self:GetCode(link));
	end

	self._itemEntered = TRUE;
	if (qty and qty > 0) then
		self:DisplayTooltipPrice(GameTooltip, link, qty)		
	end
end


function KC_ItemsTooltipHooker:SetItemRef(link, text, button)
	self:CallHook("SetItemRef", link, text, button);
	local qty = 1;
	self._itemEntered = TRUE;
	
	self:DisplayTooltipPrice(ItemRefTooltip, link, qty, TRUE);
end


function KC_ItemsTooltipHooker:GameTooltip_SetHyperlink(link)
	self:CallHook(GameTooltip, "SetHyperlink", link)
	local qty = 1;
	
	self._itemEntered = TRUE;

	self:DisplayTooltipPrice(GameTooltip, link, qty);
end

function KC_ItemsTooltipHooker:DisplayTooltipPrice(tooltip, link, qty, itemref)
	if( (not self._itemEntered) or self._priceAdded or not tooltip or not link or not self._funcs) then return; end
	
	local ctooltip = GameTooltip;
	local id = self:GetCode(link);
	if (not id) then return; end

	if (tooltip ~= GameTooltip and self:GetOpt("seperated", self.optPath)) then
		ctooltip = (tooltip == ItemRefTooltip) and TTHookerItemRef or TTHookerTooltip;
	elseif (self:GetOpt("seperated", self.optPath) and tooltip == GameTooltip) then
		ctooltip = TTHookerTooltip;
	else
		ctooltip = tooltip;
	end

	
	qty = qty or 1;

	if (self:GetOpt("seperated", self.optPath)) then
		ctooltip:SetOwner(tooltip, "ANCHOR_LEFT");
		ctooltip:ClearAllPoints();
		ctooltip:SetPoint("TOPLEFT", tooltip:GetName(), "BOTTOMLEFT", 0, 0);
		ctooltip:AddLine((self:GetName(id) or " ") .. " x " .. qty);
	end

	for index, func in self._funcs do
		if (self:GetOpt("seperator", self.optPath) and ctooltip == GameTooltip and self.sepneeded) then
			ctooltip:AddLine(" ", 0, 0, 0);
		end
		self.sepneeded = FALSE;
		func(ctooltip, id, qty, self);
		if (self:GetOpt("seperator", self.optPath) and ctooltip ~= GameTooltip and self.sepneeded) then
			ctooltip:AddLine(" ", 0, 0, 0);
		end
	end
	
	if (self:GetOpt("seperated", self.optPath)) then
		local width  = ctooltip:GetWidth();
		local width2 = tooltip:GetWidth();
		if (width > width2) then
			tooltip:SetWidth(width);
		else
			ctooltip:SetWidth(width2);
		end
	end

	self._priceAdded = TRUE;
end

function KC_ItemsTooltipHooker:RegisterFunc(addon, func)
	if (not self._funcs) then self._funcs = {}; end
	tinsert(self._funcs, ace:call(addon,func));
end

function KC_ItemsTooltipHooker:AddPriceLine(tooltip, amt, label, single, sep, sepcolor)
	local pricetext = self.app.CashTextLetters(amt);
	if (single) then
		pricetext = pricetext .. " |cffff3333(" .. self.app.CashTextLetters(single) .. "|cffff3333)|r";
	end

	if (self:GetOpt("splitline", self.optPath)) then
		tooltip:AddDoubleLine(label, pricetext, 1, 1, 1, 1, 1, 1)
	else
		sep = sep or ""; sep = ace.trim(sep); sep = " " .. (sepcolor or "") .. sep .. " |r";
		tooltip:AddLine(label .. sep .. pricetext, 1, 1, 1);
	end
	tooltip:Show();
	self.sepneeded = TRUE;
end

function KC_ItemsTooltipHooker:AddTextLine(tooltip, left, right, sep, sepcolor)
	if (not left or not tooltip) then return; end

	if (self:GetOpt("splitline", self.optPath)) then
		tooltip:AddDoubleLine(left, right, 1, 1, 1, 1, 1, 1)
	else
		sep = sep or ""; sep = ace.trim(sep); sep = " " .. (sepcolor or "") .. sep .. " |r";
		tooltip:AddLine(left .. sep .. (right or ""), 1, 1, 1);
	end
	tooltip:Show();
	self.sepneeded = TRUE;
end

-- Chat commands.

function KC_ItemsTooltipHooker:modeswitch()
	local status = self:TogOpt("seperated", self.optPath);
	self:Result(KC_TOOLTIPHOOKER_TEXT_SEPERATED_TOOLTIP, status, ACEG_MAP_ENABLED);
end

function KC_ItemsTooltipHooker:seperatortog()
	local status = self:TogOpt("seperator", self.optPath);
	self:Result(KC_TOOLTIPHOOKER_TEXT_SEPERATOR_LINES, status, ACEG_MAP_ENABLED);
end

function KC_ItemsTooltipHooker:splitline()
	local status = self:TogOpt("splitline", self.optPath);
	self:Result(KC_TOOLTIPHOOKER_TEXT_SPLITING_OF_LINES, status, ACEG_MAP_ENABLED);
end

-- Registering with	KCI
KC_Items:Register(KC_ItemsTooltipHooker:new())