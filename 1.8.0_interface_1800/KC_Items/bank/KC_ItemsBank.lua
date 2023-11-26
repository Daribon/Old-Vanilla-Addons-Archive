
KC_ItemsBankClass = KC_ItemsModuleClass:new({
	type		 = "bank",
	name		 = KC_BANK_NAME,
	desc		 = KC_BANK_DESCRIPTION,
	cmdOptions	 = KC_BANK_CMD_OPTIONS,
	--dependencies = {"test"},
	db			 = AceDbClass:new("KC_BankDB")
})

function KC_ItemsBankClass:Enable()
	self:RegisterEvent("BANKFRAME_OPENED"			, "BankOpen")
	self:RegisterEvent("BANKFRAME_CLOSED"			, "BankClose")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED"	, "BankUpdate")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED"	, "BankUpdate")
	self:RegisterEvent("BAG_UPDATE"					, "BagUpdate")

	if (not self.db:get({ace.char.id}, "BI")) then
		self.app.PrintOverheadText({1.0,0.0,0.0,12}, format(KC_BANK_TEXT_NOBANKDATA, ace.char.name));
	end
end

function KC_ItemsBankClass:BagUpdate()
	if (BankFrame:IsVisible()) then
		self:SaveBank();
	end
end

function KC_ItemsBankClass:BankOpen()
	self.ShouldScan = TRUE;
	self:SaveBank();
end

function KC_ItemsBankClass:BankClose()
	self.ShouldScan = FALSE;
end

function KC_ItemsBankClass:BankUpdate()
	self:SaveBank();
end

function KC_ItemsBankClass:SaveBank(force)
	if (not self.ShouldScan and not force) then return; end
	
	self.db:set({ace.char.id}, "faction", ace.char.faction);

	local itemLink,icon,quantity,bagNum_Slots;
	
	for num = 1, 24 do
		local optPath	= {ace.char.id, "BI"};
		itemLink		= GetContainerItemLink(BANK_CONTAINER, num);
		icon, quantity	= GetContainerItemInfo(BANK_CONTAINER, num);
		if (itemLink) then
			local id = self:GetCode(itemLink);
			icon = strsub(icon, 17);
			local storage = id .. "," .. icon .. "," .. quantity;
			self.db:set(optPath, num, storage);
		else
			self.db:set({ace.char.id, "BI"}, num, nil);
		end
	end
	
	for bagNum = 5, 10 do
		local optPath = {ace.char.id, "BB", bagNum};
		bagNum_Slots = GetContainerNumSlots(bagNum);
		bagNum_ID = BankButtonIDToInvSlotID(bagNum, 1);
		itemLink = GetInventoryItemLink("player", bagNum_ID);
		icon = GetInventoryItemTexture("player", bagNum_ID);

		if ( icon ) then
			local id= self:GetCode(itemLink);
			icon = strsub(icon, 17);
			local storage = id .. "," .. icon .. "," .. bagNum_Slots;
			self.db:set(optPath, "data", storage);
		else
			self.db:set({ace.char.id, "BB"}, bagNum, nil);
			break;
		end

		itemLink = nil;

		for bagItem = 1, bagNum_Slots do
			local optPath = {ace.char.id, "BB", bagNum};
			itemLink = GetContainerItemLink(bagNum, bagItem);
			icon, quantity = GetContainerItemInfo(bagNum, bagItem);
			if ( itemLink ) then
				local id = self:GetCode(itemLink);
				icon = strsub(icon, 17);
				local storage = id .. "," .. icon .. "," .. quantity;
				self.db:set(optPath, bagItem, storage);
			else
				self.db:set({ace.char.id, "BB", bagNum}, bagItem, nil);
			end
		end
	end
end




-- returns the qty of items stored in the bank by key.
-- charID is a optional arg, defaulting to the current character.
function KC_ItemsBankClass:BankCount(id, charID)
	if (not charID) then charID = ace.char.id; end

	local count = 0;
	for index = 1, 24 do
		local optPath = {charID, "BI"};
		local item = self.db:get(optPath, index);
		if (item) then
			local lid, _, lcount = ace.SplitString(item, ",");
			lid = self:_id(lid);
			if (lid == id and lcount) then count = count + lcount; end		
		end
	end

	for bagIndex = 5, 10 do
		local optPath = {charID, "BB", bagIndex};
		local bag = self.db:get(optPath, "data");
		if (bag) then
			local _,_, size = ace.SplitString(bag, ",");
			for itemNum = 1, size do
				item = self.db:get(optPath, itemNum);
				if (item) then
					local lid, _, lcount = ace.SplitString(item, ",");
					lid = self:_id(lid);
					if (lid == id and lcount) then count = count + lcount; end		
				end			
			end
		end
		
	end
	
	return count;
end

-- returns the icon texture, qty, and KCI key of items stored in the bank by bag and slot.
-- charID is a optional arg, defaulting to the current character.
function KC_ItemsBankClass:BankSlotInfo(bag, slot, charID)
	if (not charID) then charID = ace.char.id; end

	local path,	id, icon, qty;
	if (bag == BANK_CONTAINER) then
		path = {charID, "BI"};
	else
		path = {charID, "BB", bag};
	end
	
	data = self.db:get(path, slot);

	if (data) then
		id, icon, qty = ace.SplitString(data, ",");
		if (strfind(icon, "INV_") or strfind(icon, "SPELL_") or strfind(icon, "Spell_")) then
			icon = "Interface\\Icons\\" .. icon;			
		else
			icon = "Interface\\Icons\\INV_" .. icon;
		end
	end
	
	return icon, qty, id;
end

-- returns the icon texture, size, and KCI key of bank bags by bag #.
-- charID is a optional arg, defaulting to the current character.
function KC_ItemsBankClass:BankBagInfo(bag, charID)
	if (not charID) then charID = ace.char.id; end

	local id, icon, size;
	local path = {charID, "BB", bag};
	
	data = self.db:get(path, "data");

	if (data) then
		id, icon, size = ace.SplitString(data, ",");
		if (strfind(icon, "INV_")) then
			icon = "Interface\\Icons\\" .. icon;			
		else
			icon = "Interface\\Icons\\INV_" .. icon;
		end
	end
	
	return icon, size, id;
end


-- Chat Command handlers

function KC_ItemsBankClass:save()
	if (BankFrame:IsVisible()) then
		self:SaveBank(TRUE);
		self:Msg(KC_BANK_TEXT_SAVED);	
	else
		self:Msg(KC_BANK_TEXT_NOTBANK);
	end
end

function KC_ItemsBankClass:clear()
	PlaySound("QUESTADDED");
	StaticPopup_Show("KCI_BANKCLEARDATA_CONFIRM");	
end

function KC_ItemsBankClass:clearconfirmed()
	self.db:reset();
	self:Msg(KC_BANK_TEXT_ERASE);
end

KC_Items:Register(KC_ItemsBankClass:new())