
-- To use this template, simply replace all occurances of KC_Items with the
-- name of your addon.

--[[--------------------------------------------------------------------------------
  Class Definition
-----------------------------------------------------------------------------------]]

KC_ItemsClass = AceAddonClass:new({
    name          = KC_ITEMS_NAME,
    description   = KC_ITEMS_DESCRIPTION,
    version       = "0.6",
    releaseDate   = "06/16/05",
    aceCompatible = "099", -- Check ACE_COMP_VERSION in Ace.lua for current.
    author        = "Kael",
    email         = "kaelten@gmail.com",
    website       = "Coming Soon!",
    category      = "others",
    --optionsFrame  = "KC_ItemsOptionsFrame",
    db            = AceDbClass:new("KC_ItemsDB"),
    bank	  = AceDbClass:new("KC_BankDB"),
    inv		  = AceDbClass:new("KC_InvDB"),
    dataCache	  = AceDbClass:new(),
    cmd           = AceChatCmdClass:new(KC_ITEMS_COMMANDS),
})

function KC_ItemsClass:Initialize()
	-- Useful Constants
	self.tipLineHeight = 14
	self.widthBuffer   = 6;
	-- Two-Way Reference Charts
	self.colors = KC_Items_Colors;
	self.desc = KC_Items_Descriptors;
	-- Shortcut
	self.strsubt = string.sub;
	-- Database Initialization
	self.bank:Initialize();
	self.inv:Initialize();
end


--[[--------------------------------------------------------------------------------
  Addon Enabling/Disabling
-----------------------------------------------------------------------------------]]

function KC_ItemsClass:Enable()
	self:RegisterEvent("BANKFRAME_OPENED"		, "BankOpen")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED"	, "SaveBank")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED"	, "SaveBank")
	self:RegisterEvent("BAG_UPDATE"			, "BagUpdate")
	self:RegisterEvent("MERCHANT_SHOW"		, "GetMerchantPrices")	
	self:RegisterEvent("MERCHANT_CLOSED"            , "HookContainers"   )

	self:HookContainers()

	if (not self.db:get("count")) then
		self.db:set("count", 0);		
	end
	
	if (not self.db:get("pricecount")) then
		self.db:set("pricecount", 0);		
	end

	
	self:SaveBags();
	
	if (not self.bank:get({ace.char.id}, "BI")) then
		UIErrorsFrame:AddMessage("No Bank Data Stored For " .. ace.char.name, 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME+10);
	end
	
end

function KC_ItemsClass:Disable()
    self:UnregisterAllEvents()
    self:UnhookAllFunctions()
end

--[[--------------------------------------------------------------------------------
- Events
-----------------------------------------------------------------------------------]]

function KC_ItemsClass:BankOpen()
    self:SaveBank();
    self:HookBank();
end

function KC_ItemsClass:BANKFRAME_CLOSED()
    self:UnhookBank();
end

function KC_ItemsClass:BagUpdate()
	if (BankFrame:IsVisible()) then
		self:SaveBank();		
	end
	self:SaveBags();
	self.dataCache:reset();
end


--[[--------------------------------------------------------------------------
- Hook Handlers
-----------------------------------------------------------------------------]]

function KC_ItemsClass:HookContainers()
    self:HookFunction("ContainerFrameItemButton_OnEnter");
    self:HookFunction("ContainerFrame_Update");
    self:HookFunction("GameTooltip_OnHide");
    self:HookFunction("GameTooltip_ClearMoney");
end

function KC_ItemsClass:UnhookContainers()
    self:UnhookFunction("ContainerFrameItemButton_OnEnter");
    self:UnhookFunction("ContainerFrame_Update");
    self:UnhookFunction("GameTooltip_OnHide");
    self:UnhookFunction("GameTooltip_ClearMoney");
end

function KC_ItemsClass:HookBank()
    self:HookFunction("GameTooltip:SetInventoryItem");
end

function KC_ItemsClass:UnhookBank()
    self:UnhookFunction("GameTooltip:SetInventoryItem");
end

function KC_ItemsClass:ContainerFrameItemButton_OnEnter()
    self:CallHook("ContainerFrameItemButton_OnEnter");
    self._itemEntered = {this:GetParent():GetID(), this:GetID()};
    self:DisplayTooltipPrice();
end

function KC_ItemsClass:ContainerFrame_Update(frame)
    self:CallHook("ContainerFrame_Update", frame);
    self:DisplayTooltipPrice();
end

function KC_ItemsClass:GameTooltip_OnHide()
    self:CallHook("GameTooltip_OnHide");
    self._itemEntered = nil;
    self._priceAdded  = FALSE;
end

function KC_ItemsClass:GameTooltip_ClearMoney()
    self:CallHook("GameTooltip_ClearMoney");
    self._priceAdded = FALSE;
end

function KC_ItemsClass:GameTooltip_SetInventoryItem(type, slot)
    local x = {self:CallHook("GameTooltip:SetInventoryItem", type, slot)};
    self._itemEntered = {BANK_CONTAINER, this:GetID()};
    self:DisplayTooltipPrice();
    return unpack(x);
end
--[[--------------------------------------------------------------------------------
  Database Manipulation
-----------------------------------------------------------------------------------]]
function KC_ItemsClass:_conditionalAdd(path, var, value)
	if (not self.db:get(path, var)) then
		self.db:set(path, var, value);

		local pricecount = self.db:get("pricecount");
		local count = self.db:get("count")+1;
		local percentage = pricecount / count;
		self.db:set("count", count);
		self.db:set("pricepercentage", percentage);
		return 1;
	end
end

function KC_ItemsClass:GetCharListByRealm(realm)
	if (not realm) then realm = ace.char.realm; end
	local result = {};
	local bank = self.bank:get();

	for index in bank do
		local charName , realmID= ace.SplitString(index, " of ");
		if (realmID == realm) then
			result[index] = {
				charName= charName,
				realm	= realmID,
			};
		end
	end	
	
	local inv = self.inv:get();
	for index in inv do
		local charName , realmID= ace.SplitString(index, " of ");
		if (realmID == realm) then
			result[index] = {
				charName= charName,
				realm	= realmID,
			};
		end
	end
	
	return result;
end


--[[--------------------------------------------------------------------------------
  ItemLink Manipulation
-----------------------------------------------------------------------------------]]
-- Getting Stuff
function KC_ItemsClass:GetKey(link)
	local color, desc, name, id, idLong = self:_dismemberLink(link);
	if (not color or not desc or not name or not id or not idLong or name == "") then return nil;	end
	
	local key = color..":"..desc..":"..id;
	local stored = name .. "," .. idLong
	self:_conditionalAdd({color, desc}, id, stored);
	
	return key;
end

function KC_ItemsClass:GetID(link)
	self:AddLink(link);

	local _, _, _, id = self:_dismemberLink(link);

	return id;
end

function KC_ItemsClass:GetPrice(key)
	if (not key) then return nil; end
	local optPath, id = self:_getPath(key);

	if (not optPath or not name) then return nil; 	end
	local value = self.db:get(optPath, id);

	if (value) then
		local name, idLong, price = ace.SplitString(value, ",");
		if (price) then
			price = tonumber(price);
			return price;
		end
	end
end

-- Adding Stuff
function KC_ItemsClass:AddLink(link)
	return self:GetKey(link);
end

function KC_ItemsClass:AddPrice(key, price)
	if (type(price) == "number" and price ~= 0) then
		local optPath, id = self:_getPath(key);

		if (not optPath or not name) then return nil; 	end

		local value = self.db:get(optPath, id);
		
		if (value) then
			local name, idLong, oldprice = ace.SplitString(value, ",");
			oldprice = tonumber(oldprice);
			if (oldprice == price) then 
				return;
			elseif (id) then
				self.db:set(optPath, id, name .. "," .. idLong .. "," .. price);
				local pricecount = self.db:get("pricecount") +1;
				local count = self.db:get("count");
				local percentage = pricecount / count;
				self.db:set("pricecount", pricecount);
				self.db:set("pricepercentage", percentage);
			else 
				return;
			end
		end
	end
end

-- Helper Functions
function KC_ItemsClass:_getPath(key)
	local color, desc , id = ace.SplitString(key, ":");
	if (not color or not desc or not id) then return nil, nil;	end

	color = tonumber(color);
	desc = tonumber(desc);
	local optPath = {color, desc};

	return optPath, id;	
end

function KC_ItemsClass:_dismemberLink(link)
	local _, color, id, oName= ace.SplitString(link, "|");
	local desc, name, idLong;

	color = self.strsubt(color, 4);
	
	color = self.colors[color];
	if (not color) then color = 0; end

	id =	self.strsubt(id, 7);
	idLong = {ace.SplitString(id, ":")};
	if (idLong) then
		id = idLong[1];
		local idtemp = ""
		for index = 2, 4, 1 do
			idtemp = idtemp .. ":" .. idLong[index];
		end
		
		idLong = idtemp;	
	end
	
	oName =	self.strsubt(oName, 3, -2);

	
	local parts = {ace.SplitString(oName, " ")};
	local partsN = table.getn(parts);

	if (parts[partsN-2] == "of" and parts[partsN-1] == "the") then
		desc = self.desc[parts[partsN]];
		if (desc) then
			name = parts[1];
			for i = 2, partsN-3 do
				name = name .. " " .. parts[i];
			end
		end
	elseif (parts[partsN-2] == "of") then
		desc = parts[partsN-1] .. " " .. parts[partsN];
		desc = self.desc[desc];
		if (desc) then
			name = parts[1];
			for i = 2, partsN-3 do
				name = name .. " " .. parts[i];
			end
		end
	elseif (parts[partsN-1] == "of") then
		desc = self.desc[parts[partsN]];
		if (desc) then
			name = parts[1];
			for i = 2, partsN-2 do
				name = name .. " " .. parts[i];
			end
		end
	else
		desc = self.desc[parts[1]];
		
		if (desc) then
			name = parts[2];
			for i = 3, partsN do
				name = name .. " " .. parts[i];
			end
			if (desc < 35) then 
				desc = 0; 
				name = oName;
			end		
		end
	end	
	
	if (not desc) then desc = 0; end
	
	if (color == 1 and desc < 35) then
		desc = 0;
		name = oName;
	end
	
	if (name == "Scroll" or name == "Elixir") then
		desc = 0;
		name = oName;
	end

	if (not name) then name = oName; end
	
	return color, desc, name, id, idLong;
end

--[[--------------------------------------------------------------------------------
  Item Vendor Price Collection
-----------------------------------------------------------------------------------]]
function KC_ItemsClass:GetMerchantPrices()
	self:UnhookContainers()
	self:HookFunction("SetTooltipMoney")
	self._itemPrice = nil

	local _, itemPrice, bag, slot, qty

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			textlink = GetContainerItemLink(bag, slot);
			if(textlink) then
				key = self:GetKey(textlink);
				GameTooltip:SetBagItem(bag, slot)
				if(self._itemPrice) then
					_, qty = GetContainerItemInfo(bag, slot)
					self:AddPrice(key, self._itemPrice / qty)
					self._itemPrice = nil
				end
			end
	        end
	end

	self:UnhookFunction("SetTooltipMoney")
end

function KC_ItemsClass:SetTooltipMoney(obj, money)
	self._itemPrice = money
	self:CallHook("SetTooltipMoney", obj, money)
end

--[[--------------------------------------------------------------------------------
- Display Vendor Price
-----------------------------------------------------------------------------------]]

function KC_ItemsClass:DisplayTooltipPrice()
	if( (not self._itemEntered) or self._priceAdded ) then return; end

	local textlink = GetContainerItemLink(self._itemEntered[1], self._itemEntered[2]);
	if( not textlink ) then return; end

	local _, qty = GetContainerItemInfo(self._itemEntered[1], self._itemEntered[2]);
	local label  = format(KC_ITEMS_SELLS_FOR, ace.ternary(qty > 1, "("..qty..")", ""));
	key = self:GetKey(textlink);
	local price  = self:GetPrice(key);

	if( price ) then
--		self:AddTooltipPriceLines(GameTooltip, price * qty, label);
	end
end

function KC_ItemsClass:AddTooltipPriceLines(frame, amt, label)

    local width = self:AddPriceAsCoins(frame, amt, label);    

    self._priceAdded = TRUE
    if( width > frame:GetWidth() ) then
        frame:SetWidth(width + self.widthBuffer)
    end
    frame:SetHeight(frame:GetHeight() + self.tipLineHeight)
end

function KC_ItemsClass:AddPriceAsCoins(frame, amt, label)
    frame:AddLine(label, 1.0, 1.0, 1.0)

    local numLines   = frame:NumLines()
    local moneyFrame = getglobal(frame:GetName().."MoneyFrame")
    local width      = getglobal(frame:GetName().."TextLeft"..numLines):GetWidth()+5

    moneyFrame:SetPoint("LEFT", frame:GetName().."TextLeft"..numLines, "LEFT", width, 0)
    moneyFrame:Show()
    MoneyFrame_Update(moneyFrame:GetName(), amt)
    frame:SetMoneyWidth(moneyFrame:GetWidth())

    return width + moneyFrame:GetWidth()
end

--[[--------------------------------------------------------------------------------
  Bank Data Managemant
-----------------------------------------------------------------------------------]]

function KC_ItemsClass:BankCount(key, charID)
	if (not charID) then charID = ace.char.id; end

	result = self.dataCache:get({"bank", charID}, key);
	
	if (result) then
		return result;
	end

	local count = 0;
	for index = 1, 24 do
		local optPath = {charID, "BI"};
		local item = self.bank:get(optPath, index);
		if (item) then
			local lkey, _, lcount = ace.SplitString(item, ",");
			if (lkey == key and lcount) then count = count + lcount; end		
		end
	end

	for bagIndex = 5, 10 do
		local optPath = {charID, "BB", bagIndex};
		local bag = self.bank:get(optPath, "data");
		if (bag) then
			local _,_, size = ace.SplitString(bag, ",");
			for itemNum = 1, size do
				item = self.bank:get(optPath, itemNum);
				if (item) then
					local lkey, _, lcount = ace.SplitString(item, ",");
					if (lkey == key and lcount) then count = count + lcount; end		
				end			
			end
		end
		
	end
	
	self.dataCache:set({"bank", charID}, key, count);

	return count;
end

function KC_ItemsClass:SaveBank()
	local itemLink,icon,quantity,bagNum_Slots;
--	if ( BankFrame:IsVisible() ) then
		for num = 1, 24 do
			local optPath = {ace.char.id, "BI"};
			itemLink	= GetContainerItemLink(BANK_CONTAINER, num);
			icon, quantity	= GetContainerItemInfo(BANK_CONTAINER, num);
			if (itemLink) then
				local key = self:GetKey(itemLink);
				icon = self.strsubt(icon, 21);
				local storage = key .. "," .. icon .. "," .. quantity;
				self.bank:set(optPath, num, storage);
			else
				self.bank:set({ace.char.id, "BI"}, num, nil);
			end
		end
		for bagNum = 5, 10 do
			local optPath = {ace.char.id, "BB", bagNum};
			bagNum_Slots = GetContainerNumSlots(bagNum);
			bagNum_ID = BankButtonIDToInvSlotID(bagNum, 1);
			itemLink = GetInventoryItemLink("player", bagNum_ID);
			icon = GetInventoryItemTexture("player", bagNum_ID);

			if ( icon ) then
				local key = self:GetKey(itemLink);
				icon = self.strsubt(icon, 21);
				local storage = key .. "," .. icon .. "," .. bagNum_Slots;
				self.bank:set(optPath, "data", storage);
			else
				self.bank:set({ace.char.id, "BB"}, bagNum, nil);
				break;
			end

			itemLink = nil;

			for bagItem = 1, bagNum_Slots do
				local optPath = {ace.char.id, "BB", bagNum};
				itemLink = GetContainerItemLink(bagNum, bagItem);
				icon, quantity = GetContainerItemInfo(bagNum, bagItem);
				if ( itemLink ) then
					local key = self:GetKey(itemLink);
					icon = self.strsubt(icon, 21);
					local storage = key .. "," .. icon .. "," .. quantity;
					self.bank:set(optPath, bagItem, storage);
				else
					self.bank:set({ace.char.id, "BB", bagNum}, bagItem, nil);
				end
			end
		end
--	end
end
--[[--------------------------------------------------------------------------------
  Inventory Data Managemant
-----------------------------------------------------------------------------------]]

function KC_ItemsClass:SaveBags()
	for bagNum = 0, 4 do
		if (bagNum ~= 0) then	
			local optPath = {ace.char.id, bagNum};
			bagNum_Slots = GetContainerNumSlots(bagNum);
			bagNum_ID = ContainerIDToInventoryID(bagNum, 1);
			itemLink = GetInventoryItemLink("player", bagNum_ID);
			icon = GetInventoryItemTexture("player", bagNum_ID);
	
			if ( icon ) then
				local key = self:GetKey(itemLink);
				icon = self.strsubt(icon, 21);
				local storage = key .. "," .. icon .. "," .. bagNum_Slots;
				self.inv:set(optPath, "data", storage);
			else
				self.inv:set({ace.char.id}, bagNum, nil);
			end	
	
			itemLink = nil
		end	

		for bagItem = 1, GetContainerNumSlots(bagNum) do
			local optPath = {ace.char.id, bagNum};
			itemLink = GetContainerItemLink(bagNum, bagItem);
			icon, quantity = GetContainerItemInfo(bagNum, bagItem);
			if ( itemLink ) then
				local key = self:GetKey(itemLink);
				if (key) then
					icon = self.strsubt(icon, 21);
					local storage = key .. "," .. icon .. "," .. quantity;
					self.inv:set(optPath, bagItem, storage);	
				end			
			else
				self.inv:set(optPath, bagItem, nil);
			end
		end
	end	
end

function KC_ItemsClass:InvCount(key, charID)
	if (not charID) then charID = ace.char.id; end
	local count = 0;
	
	result = self.dataCache:get({"inv", charID}, key);
	
	if (result) then
		return result;
	end

	for bagNum = 0, 4 do
		for bagItem = 1, GetContainerNumSlots(bagNum) do
			local optPath = {charID, bagNum};
			local item = self.inv:get(optPath, bagItem);
			if ( item ) then
				local lkey, _, lcount = ace.SplitString(item, ",");
				if (lkey == key and lcount) then count = count + lcount; end
			end
		end
	end	

	self.dataCache:set({"inv", charID}, key, count);

	return count;
end

--[[--------------------------------------------------------------------------------
  Create and Register Addon Object
-----------------------------------------------------------------------------------]]

KC_Items = KC_ItemsClass:new()
KC_Items:RegisterForLoad()
