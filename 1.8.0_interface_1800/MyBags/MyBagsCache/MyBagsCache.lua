MyBagsCacheClass = AceAddonClass:new({
	name = "MyBagsCache",
	description = "Caches Inventory and Bank items",
	version = "1.0", 
	releaseDate = "8/20/05",
	category = "inventory",
	author = "Ramble",
	aceCompatible = "100",

	db = AceDbClass:new("MyBagsCacheDB"),
})
ace:RegisterFunctions(OneBagCacheClass, { -- {{{
	GetItemInfoFromLink = function(l)
		if(not l) then return end
		local _,_,c,id,il,n=strfind(l,"|cff(%x+)|Hitem:(%d+)(:%d+:%d+:%d+)|h%[(.-)%]|h|r")
		return n,c,id..il,id
	end,
	SplitString = function(s,p,n)
		if (type(s) ~= "string") then
			error("SplitString must be passed a string as the first argument", 2)
		end
		
		local l,sp,ep = {},0
		while(sp) do
			sp,ep=strfind(s,p)
			if(sp) then
				tinsert(l,strsub(s,1,sp-1))
				s=strsub(s,ep+1)
			else
				tinsert(l,s)
				break
			end
			if(n) then n=n-1 end
			if(n and (n==0)) then tinsert(l,s) break end
		end
		return unpack(l)
	end,
}) -- }}}
function MyBagsCacheClass:Initialize()
end

function MyBagsCacheClass:Enable()
	self:RegisterEvents()
end
function MyBagsCacheClass:RegisterEvents()
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED"	, "SaveItems")
	self:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED"	, "SaveItems")
	self:RegisterEvent("BAG_UPDATE", "SaveItems")
   self:RegisterEvent("UPDATE_INVENTORY_ALERTS", "SaveItems")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
end
function MyBagsCacheClass:BANKFRAME_OPENED()
	self.atBank = TRUE
	self:SaveItems()
end
function MyBagsCacheClass:BANKFRAME_CLOSED()
	self.atBank = FALSE
end

function MyBagsCacheClass:GetInfo(bagIndex, slotIndex, charID) -- {{{
	local data
	slotIndex = ace.tonum(slotIndex)
	data = self.db:get({charID, bagIndex}, slotIndex)
	if data then
		return data.Texture, data.Count, data.Link
	end
	return nil, 0, nil
end -- }}}
function MyBagsCacheClass:GetCharList() -- {{{
	local result = {}
	local cache = self.db:get()
	for index in cache do
		local charName, realmID = ace.SplitString(index, " "..ACE_TEXT_OF.." ")
		if index ~= "profiles" then
			result[index] = {
				name = charName,
				realm = realmID,
			}
		end
	end
	return result
end -- }}}

function MyBagsCacheClass:GetTooltipData(invID, itemIndex) -- {{{
	if itemIndex ~= nil then
		MyBagsHiddenTooltip:SetBagItem(invID, itemIndex) -- invID = BagIndex
	else
		MyBagsHiddenTooltip:SetInventoryItem("player", invID)
	end
	local soulbound, madeby = nil, nil
	local field, index
	local left, right
	for index =1, 15, 1 do
		field = getglobal("MyBagsHiddenTooltipTextLeft"..index)
		if( field and field:IsVisible()) then 	left = field:GetText()
		else												left = ""  end
		field = getglobal("MyBagsHiddenTooltipTextRight"..index)
		if( field and field:IsVisible()) then  right= field:GetText()
		else                                   right= ""  end
		if ( string.find(left, ITEM_SOULBOUND) ) then soulbound = 1 end
		local regexp = string.gsub(ITEM_CREATED_BY, "\%s", "\(\.\+\)")
		local iStart, iEnd, val1 = string.find(left, "<Made by (.+)>") -- Need a local
		if (val1) then madeBy = val1 end
	end
	MyBagsHiddenTooltip:Hide()
	return soulbound, madeBy
end -- }}}
function MyBagsCacheClass:SaveItems() -- {{{
	self:SaveInventory()
	self:SaveBank()
end -- }}}
function MyBagsCacheClass:SaveInventory() -- {{{
	for bagIndex = 0, 4 do
		local slots = self:SaveBagInfo(bagIndex)
		for itemIndex = 1, slots do
			self:SaveItemInfo(bagIndex, itemIndex)
		end
	end
end -- }}}
function MyBagsCacheClass:SaveBank() -- {{{
	if not self.atBank then return end
	self.db:set({ace.char.id, BANK_CONTAINER, 0}, "Count",  24)
	for itemIndex = 1, 24 do
		self:SaveItemInfo(BANK_CONTAINER, itemIndex)	
	end
	for bagIndex = 5, 10 do
		local slots = self:SaveBagInfo(bagIndex)
		for itemIndex = 1, slots do
			self:SaveItemInfo(bagIndex, itemIndex)
		end
	end
end -- }}}
function MyBagsCacheClass:SaveBagInfo(bagIndex) -- {{{
	local invID -- get Invnetory ID
	if bagIndex >= 0 and bagIndex <=4 then 
		invID = ContainerIDToInventoryID(bagIndex)
	else
		invID = BankButtonIDToInvSlotID(bagIndex,1)
	end
	if bagIndex == 0 then  -- Set Count to 16
		return 16
	end
	local bagSize = GetContainerNumSlots(bagIndex)
	local itemLink = GetInventoryItemLink("player", invID)
	if itemLink then
		local myColor, myLink, name;
		name, myColor, myLink = ace.GetItemInfoFromLink(itemLink)
		local soulbound, madeBy = self:GetTooltipData(invID)
		local texture = GetInventoryItemTexture("player", invID)
		self.db:set({ace.char.id, bagIndex}, 0, {
			["Name"] = name,
			["Color"] = myColor,
			["Link"] = myLink,
			["Count"] = bagSize,
			["Texture"] = texture,
			["Soulbound"] = soulbound,
			["MadeBy"] = madeBy
		})
	end
	if bagSize > 0 then
		return bagSize
	else
		self.db:set({ace.char.id}, bagIndex)
		return 0
	end
end -- }}}
function MyBagsCacheClass:SaveItemInfo(bagIndex, itemIndex) -- {{{
	local itemLink = GetContainerItemLink(bagIndex, itemIndex)
	if itemLink then
		local myColor, myLink, myName
		myName, myColor, myLink = ace.GetItemInfoFromLink(itemLink)
		local soulbound, madeBy = self:GetTooltipData(bagIndex, itemIndex)
		local texture, itemCount = GetContainerItemInfo(bagIndex, itemIndex)
		self.db:set({ace.char.id, bagIndex}, itemIndex, {
			["Name"] = myName,
			["Color"] = myColor,
			["Link"] = myLink,
			["Count"] = itemCount,
			["Texture"] = texture,
			["Soulbound"] = soulbound,
			["MadeBy"] = madeBy,
		})
	else
		self.db:set({ace.char.id, bagIndex}, itemIndex)
	end
end -- }}}

MyBagsCache = MyBagsCacheClass:new()
MyBagsCache:RegisterForLoad()
