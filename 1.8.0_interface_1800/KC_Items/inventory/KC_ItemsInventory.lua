
KC_ItemsInventoryClass = KC_ItemsModuleClass:new({
	type		 = "inventory",
	name		 = KC_INVENTORY_NAME,
	desc		 = KC_INVENTORY_DESCRIPTION,
	cmdOptions	 = KC_INVENTORY_CMD_OPTIONS,
	--dependencies = {"test"},
	db			 = AceDbClass:new("KC_InvDB")
})

function KC_ItemsInventoryClass:Enable()
	self:RegisterEvent("BAG_UPDATE", "BagUpdate")

	self:SaveBags();
end

function KC_ItemsInventoryClass:BagUpdate()
	self:SaveBags();
end

-- Saves a character's inventory data.  This data should always be avaialble. Data is 
-- completely overwriten when saved.  I have figured this to be more efficiate than 
-- doing several more calls and checks to see if its needed.
function KC_ItemsInventoryClass:SaveBags()
	self.db:set({ace.char.id}, "faction", ace.char.faction);
	for bagNum = 0, 4 do
		if (bagNum ~= 0) then	
			local optPath = {ace.char.id, bagNum};
			bagNum_Slots = GetContainerNumSlots(bagNum);
			bagNum_ID = ContainerIDToInventoryID(bagNum, 1);
			itemLink = GetInventoryItemLink("player", bagNum_ID);
			icon = GetInventoryItemTexture("player", bagNum_ID);

			if ( icon ) then
				local id = self:GetCode(itemLink);
				icon = strsub(icon, 17);
				local storage = id .. "," .. icon .. "," .. bagNum_Slots;
				self.db:set(optPath, "data", storage);
			else
				self.db:set({ace.char.id}, bagNum, nil);
			end	
	
			itemLink = nil
		end	

		for bagItem = 1, GetContainerNumSlots(bagNum) do
			local optPath = {ace.char.id, bagNum};
			itemLink = GetContainerItemLink(bagNum, bagItem);

			icon, quantity = GetContainerItemInfo(bagNum, bagItem);
			if ( itemLink ) then
				local id = self:GetCode(itemLink);
				if (id) then
					icon = strsub(icon, 17);
					local storage = id .. "," .. icon .. "," .. quantity;
					self.db:set(optPath, bagItem, storage);	
				end			
			else
				self.db:set(optPath, bagItem, nil);
			end
		end
	end	
end

-- returns the qty of items stored in a char's inventory by id.
-- charID is a optional arg, defaulting to the current character.
function KC_ItemsInventoryClass:InvCount(id, charID)
	if (not charID) then charID = ace.char.id; end
	local count = 0;
	
	for bagNum = 0, 4 do
		for bagItem = 1, GetContainerNumSlots(bagNum) do
			local optPath = {charID, bagNum};
			local item = self.db:get(optPath, bagItem);
			if ( item ) then
				local lid, _, lcount = KC_Items.SplitString(item, ",");
				lid = self:_id(lid);
				if (lid == id and lcount) then count = count + lcount; end
			end
		end
	end	

	return count;
end

-- returns the icon texture, qty, and id of items stored in the bank by bag and slot.
-- charID is a optional arg, defaulting to the current character.
function KC_ItemsInventoryClass:InvSlotInfo(bag, slot, charID)
	if (not charID) then charID = ace.char.id; end

	local path,	id, icon, qty;
	path = {charID, bag};
	
	data = self.db:get(path, slot);

	if (data) then
		id, icon, qty = KC_Items.SplitString(data, ",");
		if (strfind(icon, "INV_") or strfind(icon, "SPELL_") or strfind(icon, "Spell_")) then
			icon = "Interface\\Icons\\" .. icon;			
		else
			icon = "Interface\\Icons\\INV_" .. icon;
		end
	end
	
	return icon, qty, id;
end

-- returns the icon texture, size, and id of a bag by bag #.
-- possible values should be 1-4
-- charID is a optional arg, defaulting to the current character.
function KC_ItemsInventoryClass:InvBagInfo(bag, charID)
	if (not charID) then charID = ace.char.id; end

	local id, icon, size;
	local path = {charID, bag};
	
	data = self.db:get(path, "data");

	if (data) then
		id, icon, size = KC_Items.SplitString(data, ",");
		if (strfind(icon, "INV_") or strfind(icon, "SPELL_") or strfind(icon, "Spell_")) then
			icon = "Interface\\Icons\\" .. icon;			
		else
			icon = "Interface\\Icons\\INV_" .. icon;
		end
	end
	
	return icon, size, id;
end


-- Chat Handlers

function KC_ItemsInventoryClass:clear()
	PlaySound("QUESTADDED");
	StaticPopup_Show("KCI_INVENTORYCLEARDATA_CONFIRM");
end

function KC_ItemsInventoryClass:clearConfirmed()
	self.db:reset();
	self:Msg(KC_INVENTORY_TEXT_ERASED);
end

function KC_ItemsInventoryClass:save()
	self:Msg(KC_INVENTORY_TEXT_SAVED);
	self:SaveBags();
end

-- Registering with KCI
KC_Items:Register(KC_ItemsInventoryClass:new())