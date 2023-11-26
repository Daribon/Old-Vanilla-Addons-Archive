--------------------------------------------------------------------------
-- MyBagsCore
-- Author: Ramble
--
-- Credits
--   Svarten for MyInventory
--   Turan for OneBag
--   Sarf for AIOI and initail concept
--------------------------------------------------------------------------

local MYBAGS_BOTTOMOFFSET = 20
local MYBAGS_COLWIDTH     = 40
local MYBAGS_ROWHEIGHT    = 40

local MYBAGS_MAXBAGSLOTS  = 20

local MIN_SCALE_VAL 	= "0.2"
local MAX_SCALE_VAL 	= "2.0"

local MYBAGS_SLOTCOLOR = { 0.5, 0.5, 0.5 }
local MYBAGS_AMMOCOLOR = { 0.0, 0.0, 0.0 }

MyBagsCoreClass = AceAddonClass:new({
	version		  = "0.3.4 (1700)",
	releaseDate   = "8/21/05",
	category	  = "inventory",
	author		  = "Ramble",
--	email		  = "",
--	website		  = "",
	aceCompatible = "100",

	MAXBAGSLOTS = 20,
	minColumns = 2,
	maxColumns = 20,

	_TOPOFFSET    = 28,
	_BOTTOMOFFSET = 20,
	_LEFTOFFSET   =  8,
	_RIGHTOFFSET  =  3,

})
ace:RegisterFunctions(OneBagCoreClass, { -- {{{
	ColorConvertHexToDigit = function(h)
		if(strlen(h)~=6) then return 0,0,0 end
		local r={a=10,b=11,c=12,d=13,e=14,f=15}
		return ((tonumber(strsub(h,1,1)) or r[strsub(h,1,1)] or 0) * 16 +
				(tonumber(strsub(h,2,2)) or r[strsub(h,2,2)] or 0))/255,
			   ((tonumber(strsub(h,3,3)) or r[strsub(h,3,3)] or 0) * 16 +
				(tonumber(strsub(h,4,4)) or r[strsub(h,4,4)] or 0))/255,
			   ((tonumber(strsub(h,5,5)) or r[strsub(h,5,5)] or 0) * 16 +
				(tonumber(strsub(h,6,6)) or r[strsub(h,6,6)] or 0))/255
	end,

	GetItemInfoFromLink = function(l)
		if(not l) then return end
		local _,_,c,id,il,n=strfind(l,"|cff(%x+)|Hitem:(%d+)(:%d+:%d+:%d+)|h%[(.-)%]|h|r")
		return n,c,id..il,id
	end,

	IsBagAmmoOnly = function(b)
		local _, i
		_,_,_,i=ace.GetItemInfoFromLink(b)
		if(not i) then return end
		_,_,_,_,c=GetItemInfo(i)
		if(strlower(c or "")==strlower(ACEG_TEXT_AMMO)) then return 1 end
		if(strlower(c or "")==strlower(ACEG_TEXT_QUIVER)) then return 2 end
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

function MyBagsCoreClass:Initialize() -- {{{
	self.GetOpt = function(var) return self.db:get(self.profilePath,var)	end
	self.SetOpt = function(var,val) self.db:set(self.profilePath,var,val)	end
	self.TogOpt = function(var) return self.db:toggle(self.profilePath,var) end
	self.Result = function(text, val, map)
		if( map ) then val = map[val or 0] or val end
		self.cmd:result(text, " ", ACEG_TEXT_NOW_SET_TO, " ",
						format(ACEG_DISPLAY_OPTION, val or ACE_CMD_REPORT_NO_VAL)
					   )
	end
	self.Error  = function(...) self.cmd:result(format(unpack(arg))) end
	self.TogMsg = function(var,text) self.Result(text,self.TogOpt(var),ACEG_MAP_ONOFF) end
	self.frame = getglobal(self.frameName)
	self.frame.self = self
	self:IsLive()
end -- }}}
function MyBagsCoreClass:Enable() -- {{{
	self:RegisterEvents()
	self:HookFunctions()
	if self.GetOpt("Scale") then
		self.frame:SetScale(self.GetOpt("Scale"))
	end
	self:SetFrozen()
	self:SetLockTexture()
	if self:CanSaveItems() then
		self:LoadDropDown()
	else
		self.SetOpt("Player")
	end
	local point = self.GetOpt("Anchor") 
	if point then
		self.frame:ClearAllPoints()
		self.frame:SetPoint(string.upper(point), self.frame:GetParent():GetName(), string.upper(point), 0, 0)
	end
end -- }}}
function MyBagsCoreClass:RegisterEvents() -- {{{
	self:RegisterEvent("BAG_UPDATE",              "LayoutFrame")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN",     "LayoutFrame")
	self:RegisterEvent("ITEM_LOCK_CHANGED",       "LayoutFrame")
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS", "LayoutFrame")
end -- }}}
function MyBagsCoreClass:HookFunctions() -- {{{
	self:Hook("ToggleBag")
	self:Hook("OpenBag")
	self:Hook("CloseBag")
	self:Hook(GameTooltip, "SetOwner", "TooltipSetOwner")
end -- }}}

function MyBagsCoreClass:ToggleBag(bag) -- {{{
	if self.GetOpt("Replace") and self:IncludeBag(bag) then
		self:Toggle()
	else
		self:CallHook("ToggleBag", bag)
	end
end -- }}}
function MyBagsCoreClass:OpenBag(bag) -- {{{
	if (self.GetOpt("Replace") and self:IncludeBag(bag)) then
		self:Open()
	elseif not self.isBank then
		self:CallHook("OpenBag", bag)
	end
end -- }}}
function MyBagsCoreClass:CloseBag(bag) -- {{{
	if  not self.GetOpt("Freeze") and (self.GetOpt("Replace") and self:IncludeBag(bag)) then
		if not self.isBank then self.Error("Closing") end
		self:Close()
	elseif not self.isBank then
		self:CallHook("CloseBag", bag)
	end
end -- }}}

function MyBagsCoreClass:TooltipSetOwner(owner, anchor) -- {{{
	local parent = owner:GetParent()
	if parent and (parent == self.frame or parent:GetParent() == self.frame ) then
		local point = self.GetOpt("Anchor") or "bottomright"
		if point == "topleft" or point == "bottomleft" then
			anchor = "ANCHOR_RIGHT"
		else
			anchor = "ANCHOR_LEFT"
		end
	end
	self:CallHook(GameTooltip, "SetOwner", owner, anchor)
end -- }}}
-- Frame Toggle {{{
function MyBagsCoreClass:Open()
	if(self.frame:IsVisible() ) then return end
	self.frame:Show()
	self:LayoutFrame()
end
function MyBagsCoreClass:Close()
	if self.frame:IsVisible() then self.frame:Hide() end
	if self.isBank and self.atBank then CloseBankFrame() end
end
function MyBagsCoreClass:Toggle()
	if(self.frame:IsVisible() ) then
		self:Close()
	else
		self:Open()
	end
end
function MyBagsCoreClass:OnHide() --{{{
end -- }}}
-- }}}

function MyBagsCoreClass:GetHyperlink(ID) -- {{{
	if KC_Items then return KC_Items:GetHyperlink(ID) end
	local _,	link = GetItemInfo("item:" .. ID)
	return link
end -- }}}

function MyBagsCoreClass:GetTextLink(ID) -- {{{
	if ID and KC_Items then return KC_Items:GetTextLink(ID) end
	local myColors = {
		[0] = "9d9d9d", 
		[1] = "ffffff",
		[2] = "1eff00", 
		[3] = "0070dd",
		[4] = "a335ee",
		[5] = "FF8000",
	}
	local myName, myLink, myQuality= GetItemInfo("item:" .. ID)
	local textLink = "|cff" .. myColors[myQuality] ..  "|H" .. myLink .. "|h[" .. myName .. "]|h|r"
	return textLink
end -- }}}

--ITEMBUTTONS-- -- {{{
function MyBagsCoreClass:ItemButton_OnLoad() -- {{{
	getglobal(this:GetName().."NormalTexture"):SetTexture("Interface\\AddOns\\MyBags\\Skin\\Button");
	ContainerFrameItemButton_OnLoad()
end -- }}}
function MyBagsCoreClass:ItemButton_OnLeave() -- {{{
	GameTooltip:Hide()
	local bagButton = getglobal(this:GetParent():GetName() .. "Bag")
	if bagButton then bagButton:UnlockHighlight() end
end -- }}}
function MyBagsCoreClass:ItemButton_OnClick(button, ignoreShift) -- {{{
	if self.isLive then
		if self.isBank and this:GetParent():GetID() == BANK_CONTAINER then
			BankFrameItemButtonGeneric_OnClick(button)
		else
			ContainerFrameItemButton_OnClick(button, ignoreShift)
		end
	else
		if button == "LeftButton" and IsControlKeyDown() and not ignoreShift then
			local ID
			_, _, ID = self:GetInfo(this:GetParent():GetID(), this:GetID() )
			if DressUpItemLink and ID then
				DressUpItemLink("item:"..ID)
			end
		elseif (button == "LeftButton" ) and ( IsShiftKeyDown() and not ignoreShift) then
			if (ChatFrameEditBox:IsVisible()) then
				local ID
				_, _, ID = self:GetInfo(this:GetParent():GetID(), this:GetID() )
				local textLink
				if ID then textLink = self:GetTextLink(ID) end
				if textLink then ChatFrameEditBox:Insert(textLink)  end
			end
		end
	end
end -- }}}
function MyBagsCoreClass:ItemButton_OnEnter() -- {{{
	if self.GetOpt("HlBags") == 1 then
		local bagButton = getglobal(this:GetParent():GetName() .. "Bag")
		if bagButton then bagButton:LockHighlight() end
	end
	GameTooltip:SetOwner(this)
	if self.isLive then
		if this:GetParent() == MyBankFrameBank then -- OnEnter for BankItems is in XML, need 1.7 to use actual code
			GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(this:GetID()))
		else
			ContainerFrameItemButton_OnEnter()
		end
	else
		local ID
		_, _, ID = self:GetInfo(this:GetParent():GetID(), this:GetID())
		if ID then
			local hyperlink = self:GetHyperlink(ID)
			if hyperlink then GameTooltip:SetHyperlink(hyperlink) end
		end
	end
end -- }}}
function MyBagsCoreClass:ItemButton_OnDragStart() -- {{{
	if self.isLive then
		self:ItemButton_OnClick("LeftButton", 1)
	end
end -- }}}
function MyBagsCoreClass:ItemButton_OnReceiveDrag() -- {{{
	if self.isLive then
		self:ItemButton_OnClick("LeftButton", 1)
	end
end -- }}}
function MyBagsCoreClass:ItemButton_OnUpdate(arg1) -- {{{
end -- }}}
-- }}}
--BAGBUTTONS-- -- {{{
function MyBagsCoreClass:BagButton_OnEnter() -- {{{
	local bagFrame = this:GetParent()
	local setTooltip = true
	GameTooltip:SetOwner(this)
	if self.isLive then
		local invSlot = self:BagIDToInvSlotID(bagFrame:GetID())
		if not invSlot or (not GameTooltip:SetInventoryItem("player", invSlot)) then
			setTooltip = false
		end
	else
		_, _, ID = self:GetInfo(this:GetParent():GetID())
		if bagFrame:GetID() == 0 then
			GameTooltip:SetText(BACKPACK_TOOLTIP)
		elseif ID then
			hyperlink = self:GetHyperlink(ID)
			if hyperlink then
				GameTooltip:SetHyperlink(hyperlink)
			end
		else
			setTooltip = false
		end
	end
	if not setTooltip then
		local keyBinding
		if self.isBank then
			if self:IsBagSlotUsable(bagFrame:GetID()) then
				GameTooltip:SetText(BANK_BAG)
			else
				GameTooltip:SetText(BANK_BAG_PURCHASE)
				if self.atBank then
					local cost = GetBankSlotCost()
					GameTooltip:AddLine("Purchase:", "", 1, 1, 1)
					SetTooltipMoney(GameTooltip, cost)
					if GetMoney() > cost then
						SetMoneyFrameColor("GameTooltipMoneyFrame", 1.0, 1.0, 1.0);
					else
						SetMoneyFrameColor("GameTooltipMoneyFrame", 1.0, 0.1, 0.1)
					end
					GameTooltip:Show()
				end
				keyBinding = GetBindingKey("TOGGLEBAG"..(4-this:GetID()))
			end
		else
			if bagFrame:GetID() == 0 then -- SetScript("OnEnter", MainMenuBarBackpackButton:GetScript("OnEnter"))
				GameTooltip:SetText(BACKPACK_TOOLTIP, 1.0,1.0,1.0)
				keyBinding = GetBindingKey("TOGGLEBACKPACK")
			else
				GameTooltip:SetText(EQUIP_CONTAINER)
			end
		end
	end
	if self.GetOpt("HlItems") == 1 then -- Highlight -- {{{
		local i
		for i = 1, self.MAXBAGSLOTS do
			local button = getglobal(bagFrame:GetName() .. "Item" .. i)
			if button then
				button:LockHighlight() 
			end
		end
	end -- }}}
end -- }}}
function MyBagsCoreClass:BagButton_OnLeave() -- {{{
	SetMoneyFrameColor("GameTooltipMoneyFrame", 1.0, 1.0, 1.0);
	GameTooltip:Hide()
	for i = 1, self.MAXBAGSLOTS do
		button = getglobal(this:GetParent():GetName() .. "Item" .. i)
		if button then	button:UnlockHighlight() end
	end
end -- }}}
function MyBagsCoreClass:BagButton_OnClick(button, ignoreShift) -- {{{
	if self.isBank then 
		this:SetChecked(nil)
	else
		this:SetChecked(self:IncludeBag(this:GetID()))
	end
	if self.isLive then
		if button == "LeftButton" then
			if not self:IsBagSlotUsable(this:GetParent():GetID()) then
				local cost = GetBankSlotCost()
				if GetMoney() > cost then
					if not StaticPopupDialogs["PURCHASE_BANKBAG"] then	return end
					StaticPopup_Show("PURCHASE_BANKBAG")
				end
				return
			end
			if (not IsShiftKeyDown()) then
				self:BagButton_OnReceiveDrag()
			else
			end
		else
			if (IsShiftKeyDown()) then 
				self.db:toggle({self.profilePath, "BagSlot" .. this:GetParent():GetID() }, "Exclude")
				self:LayoutFrame()
			end
		end
	end
end -- }}}
function MyBagsCoreClass:BagButton_OnDragStart() -- {{{
	if self.isLive then
		local bagFrame = this:GetParent()
		local invID = self:BagIDToInvSlotID(bagFrame:GetID())
		if invID then
			PickupBagFromSlot(invID)
			PlaySound("BAGMENUBUTTONPRESS")
		end
	end
end -- }}}
function MyBagsCoreClass:BagButton_OnReceiveDrag() -- {{{
	if self.isLive then
		local bagFrame = this:GetParent()
		local invID = self:BagIDToInvSlotID(bagFrame:GetID())
		local hadItem
		if not invID then
			hadItem = PutItemInBackpack()
		else
			hadItem = PutItemInBag(invID)
		end
		if not hadItem then
			if not self:IncludeBag(bagFrame:GetID()) then
				ToggleBag(bagFrame:GetID())
			end
		end
	end
end -- }}}
--}}}

function MyBagsCoreClass:LoadDropDown() -- {{{
	local dropDown = getglobal(self.frameName .. "CharSelectDropDown")
	local dropDownButton = getglobal(self.frameName .. "CharSelectDropDownButton")
	if not dropDown then return end
	local last_this = getglobal("this")
	setglobal("this", dropDownButton)
	UIDropDownMenu_Initialize(dropDown, self.UserDropDown_Initialize)
	UIDropDownMenu_SetSelectedValue(dropDown, self:GetCurrentPlayer())
	UIDropDownMenu_SetWidth(140, dropDown)
	OptionsFrame_EnableDropDown(dropDown)
	setglobal("this", last_this)
end -- }}}
function MyBagsCoreClass:UserDropDown_Initialize() -- {{{
	--if not KC_Items then return end
	local chars 
	if KC_Items then 
		chars = KC_Items:GetCharList()
	elseif MyBagsCache then
		chars = MyBagsCache:GetCharList()
	else
		return
	end
	local frame = this:GetParent():GetParent():GetParent()
	local selectedValue = UIDropDownMenu_GetSelectedValue(this)

	for key, value in chars do
		info = {
			["text"] = key,
			["value"] = key,
			["func"] = frame.self.UserDropDown_OnClick,
			["owner"] = frame.self,
			["checked"] = nil,
		}
		if selectedValue == info.value then info.checked = 1 end
		UIDropDownMenu_AddButton(info)
	end
end -- }}}
function MyBagsCoreClass:UserDropDown_OnClick() -- {{{
	self = this.owner
	local dropDown = getglobal(self.frameName .. "CharSelectDropDown")
	self.Player = this.value
	UIDropDownMenu_SetSelectedValue(dropDown, this.value)
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:GetCurrentPlayer() -- {{{
	if self.Player then return self.Player end
	return ace.char.id 
end -- }}}

function MyBagsCoreClass:CanSaveItems() -- {{{
	local live = self.isLive
	self.isLive = FALSE
	if self:GetInfoFunc() ~= self.GetInfoNone then
		self.isLive= live
		return TRUE
	end
	self.isLive= live
	return FALSE
end -- }}}
function MyBagsCoreClass:IsLive() -- {{{
	local isLive = true
	local charID = self:GetCurrentPlayer()
	if charID ~= ace.char.id then isLive = false end
	if self.isBank and not self.atBank then isLive = false end
	self.isLive = isLive
	return isLive
end -- }}}
function MyBagsCoreClass:BagIDToInvSlotID(bag, isBank) -- OVERLOAD {{{
	if bag == -1 or bag >= 5 and bag <= 10 then isBank = 1 end
	if isBank then return BankButtonIDToInvSlotID(bag, 1)	end
	return ContainerIDToInventoryID(bag)
end -- }}}

function MyBagsCoreClass:IncludeBag(bag) -- {{{
	if self.isBank and bag == BANK_CONTAINER then return TRUE end
	if bag < self.firstBag or bag > (self.firstBag + self.totalBags-1) then
		return FALSE
	else
		if self.db:get({self.profilePath, "BagSlot"..bag} , "Exclude") then
			return FALSE
		end
		return TRUE
	end
end -- }}}
function MyBagsCoreClass:IsBagSlotUsable(bag) -- {{{
	if not self.isBank then return TRUE end
	local slots, full = GetNumBankSlots()
	if (bag+1 - self.firstBag) <= slots  then return TRUE end
	return FALSE
end -- }}}

function MyBagsCoreClass:GetInfo(bag, slot) -- {{{
	local infofunc = self:GetInfoFunc()
	if infofunc then
		return infofunc(self, bag, slot)
	end
	return nil, 0 , nil
end -- }}}
function MyBagsCoreClass:GetInfoLive(bag, slot) -- {{{
	local texture, count, ID
	local locked, quality, readable
	local itemLink
	
	if slot ~= nil then
		-- it's an item
		texture, count, locked, _ , readable = GetContainerItemInfo(bag, slot)
		itemLink = GetContainerItemLink(bag, slot)
		if itemLink then
			_, quality, _, ID = ace.GetItemInfoFromLink(itemLink)
		end
	else
		-- it's a bag
			count = GetContainerNumSlots(bag)
			local inventoryID = self:BagIDToInvSlotID(bag)
			if inventoryID then
				texture = GetInventoryItemTexture("player", inventoryID)
				itemLink = GetInventoryItemLink("player", inventoryID)
				if itemLink then
					_, quality, _, ID = ace.GetItemInfoFromLink(itemLink)
				end
				locked = IsInventoryItemLocked(inventoryID)	
				readable = ace.IsBagAmmoOnly(itemLink)
			else
				texture = "Interface\\Buttons\\Button-Backpack-Up"
				count = 16
			end
	end
	count = tonumber(count)
	if count == nil then count = 0 end
	return texture, count, ID, locked, quality, readable
end -- }}}
function MyBagsCoreClass:GetInfoMyBagsCache(bag,slot) -- {{{
	local charID = self:GetCurrentPlayer()
	return MyBagsCache:GetInfo(bag, slot, charID)
end -- }}}
function MyBagsCoreClass:GetInfoNone(bag, slot) -- {{{
	return nil, 0, nil
end -- }}}

function MyBagsCoreClass:GetSlotCount() -- {{{
	local slots, used = 0, 0
	if self.isBank then
		if self:CanSaveItems() or self.isLive then slots = 24 end
		for i = 1, slots do
			if (self:GetInfo(BANK_CONTAINER, i)) then used = used + 1 end
		end
	end	
	for bagIndex = 0, self.totalBags -1 do
		local bagFrame = getglobal(self.frameName .. "Bag" .. bagIndex)
		if bagFrame and self:IncludeBag(bagFrame:GetID()) then
			local bagID = bagFrame:GetID()
			local bagSlots
			_, bagSlots = self:GetInfo(bagID)
			slots = slots + bagSlots
			for i = 1, bagSlots do
				if self:GetInfo(bagID, i) then used = used + 1 end
			end
		end
	end
	return slots, used
end -- }}}

function MyBagsCoreClass:LayoutOptions() -- {{{
	local playerSelectFrame = getglobal(self.frameName .. "CharSelect")
	local title = getglobal(self.frameName .. "Name")
	local cash = getglobal(self.frameName .. "MoneyFrame")
	local slots = getglobal(self.frameName .. "Slots")
	local buttons = getglobal(self.frameName .. "Buttons")
	self:UpdateTitle()
	if self.GetOpt("Title") == TRUE then   title:Show()
	else                                   title:Hide() end
	if self.GetOpt("Cash") == TRUE then    cash:Show()
	else                                   cash:Hide()	end
	if self.GetOpt("Buttons") == TRUE then buttons:Show()
	else                                   buttons:Hide()	end
	self:SetFrameMode(self.GetOpt("Graphics"))
	if self.GetOpt("Player") == TRUE then
		playerSelectFrame:Show()
	else
		playerSelectFrame:Hide()
	end
	playerSelectFrame:ClearAllPoints()
	if self.GetOpt("Title") or self.GetOpt("Buttons") or (self.GetOpt("Graphics")) == "art" then
			playerSelectFrame:SetPoint("TOP", self.frameName, "TOP", 0, -38)
			self._TOPOFFSET = 28
	else
			playerSelectFrame:SetPoint("TOP", self.frameName, "TOP", 0, -18)
			self._TOPOFFSET =  8
	end
	if self.GetOpt("Cash") or (self.GetOpt("Count") ~= "none") then
		self._BOTTOMOFFSET = 28
	else
		self._BOTTOMOFFSET = 3
	end
	if (self.frame.isBank) then 
		MYBAGS_BOTTOMOFFSET = MYBAGS_BOTTOMOFFSET+20
		cash:ClearAllPoints()
		cash:SetPoint("BOTTOMRIGHT", self.frameName, "BOTTOMRIGHT", 0, 25)
	end

	if self.GetOpt("Player") == TRUE or self.GetOpt("Graphics") == "art" then
		self.curRow = self.curRow + 1
	end
	if self.GetOpt("Bag") == "bar" then
		self.curRow = self.curRow + 1
	end
	local count, used = self:GetSlotCount()
	count = ace.tonum(count)
	if self.GetOpt("Count") == "free" then
		slots:Show()
		slots:SetText(format(MYBAGS_SLOTS_DD, (count - used), count ))
	elseif self.GetOpt("Count") == "used" then
		slots:Show()
		slots:SetText(format(MYBAGS_SLOTS_DD, (used), count ))
	else
		slots:Hide()
	end
	if self.GetOpt("AIOI") then
		local columns = self.GetOpt("Columns")
		if self.GetOpt("Bag") == "before" then count = count + self.totalBags end
		columns = ace.tonum(columns)
		self.curCol = columns - (mod(count, columns) )
		if self.curCol == columns then self.curCol = 0 end
	end
end -- }}}
function MyBagsCoreClass:UpdateTitle() -- {{{
	local title1 = 4
	local title2 = 7
	if self.GetOpt("Graphics") == "art" then
		title1 = 5
		title2 = 9
	end
	local columns = self.GetOpt("Columns") 
	local titleString
	if columns > title2 then
		titleString = MYBAGS_TITLE2
	elseif columns > title1 then
		titleString = MYBAGS_TITLE1
	else
		titleString = MYBAGS_TITLE0
	end
	titleString = titleString .. getglobal(string.upper(self.frameName) .. "_TITLE")
	local title = getglobal(self.frameName .. "Name")
	local player, realm = ace.SplitString(self:GetCurrentPlayer(), " "..ACE_TEXT_OF.." ")
	title:SetText(format(titleString, player, realm))
end -- }}}
function MyBagsCoreClass:SetFrameMode(mode) -- {{{
	local frame = self.frame
	local frameName = self.frameName
	local textureTopLeft, textureTop, textureTopRight
	local textureLeft, textureCenter, textureRight
	local textureBottomLeft, textureBottom, textureBottomRight
	local texturePortrait
	local frameTitle
	local frameButtonBar = getglobal(frameName .. "Buttons")
	textureTopLeft     = getglobal(frameName .. "TextureTopLeft")
	textureTopCenter   = getglobal(frameName .. "TextureTopCenter")
	textureTopRight    = getglobal(frameName .. "TextureTopRight")
	
	textureLeft        = getglobal(frameName .. "TextureLeft")
	textureCenter      = getglobal(frameName .. "TextureCenter")
	textureRight       = getglobal(frameName .. "TextureRight")

	textureBottomLeft  = getglobal(frameName .. "TextureBottomLeft")
	textureBottomCenter= getglobal(frameName .. "TextureBottomCenter")
	textureBottomRight = getglobal(frameName .. "TextureBottomRight")
	texturePortrait    = getglobal(frameName .. "Portrait")
	frameTitle = getglobal(frameName .. "Name")
	frameTitle:ClearAllPoints()
	frameButtonBar:ClearAllPoints()
	if mode == "art" then
		frameTitle:SetPoint("TOPLEFT", frameName, "TOPLEFT", 70, -10)
		frameTitle:Show()
		frameButtonBar:Show()
		frameButtonBar:SetPoint("TOPRIGHT", frameName, "TOPRIGHT", 10, 0)
		frame:SetBackdropColor(0,0,0,0)
		frame:SetBackdropBorderColor(0,0,0,0)
		textureTopLeft:Show()
		textureTopCenter:Show()
		textureTopRight:Show()
		textureLeft:Show()
		textureCenter:Show()
		textureRight:Show()
		textureBottomLeft:Show()
		textureBottomCenter:Show()
		textureBottomRight:Show()
		texturePortrait:Show()
	else
		frameTitle:SetPoint("TOPLEFT", frameName, "TOPLEFT", 5, -6)
		frameButtonBar:SetPoint("TOPRIGHT", frameName, "TOPRIGHT", 0, 0)
		textureTopLeft:Hide()
		textureTopCenter:Hide()
		textureTopRight:Hide()
		textureLeft:Hide()
		textureCenter:Hide()
		textureRight:Hide()
		textureBottomLeft:Hide()
		textureBottomCenter:Hide()
		textureBottomRight:Hide()
		texturePortrait:Hide()
		if mode == "default" then
			local BackColor = self.GetOpt("BackColor") or {0.7,0,0,0}
			local a, r, g, b = unpack(BackColor)
			frame:SetBackdropColor(r,g,b,a)
			frame:SetBackdropBorderColor(1,1,1,a)
		else
			frame:SetBackdropColor(0,0,0,0)
			frame:SetBackdropBorderColor(0,0,0,0)
		end
	end
end -- }}}
function MyBagsCoreClass:GetXY(row, col) -- {{{
	return (self._LEFTOFFSET + (col * MYBAGS_COLWIDTH)),  (0 - self._TOPOFFSET - (row * MYBAGS_ROWHEIGHT))
end -- }}}
function MyBagsCoreClass:LayoutBagFrame(bagFrame) --{{{
	local bagFrameName = bagFrame:GetName()
	local slot
	local itemBase = bagFrameName .. "Item"
	local bagButton = getglobal(bagFrameName .. "Bag")
	local texture, count, _, locked, quality, ammo
	texture, count, _, locked, quality, ammo = self:GetInfo(bagFrame:GetID())
	bagFrame.size = count
	if bagButton and bagFrame:GetID() ~= BANK_CONTAINER then
		if not texture then _, texture = GetInventorySlotInfo("Bag0Slot")	end
		if self:IsBagSlotUsable(bagFrame:GetID()) then
			SetItemButtonTextureVertexColor(bagButton, 1.0, 1.0, 1.0)
			SetItemButtonDesaturated(bagButton, locked, 0.5, 0.5, 0.5)
		else
			SetItemButtonTextureVertexColor(bagButton, 1.0, 0.1, 0.1)
		end
		SetItemButtonTexture(bagButton, texture)
		-- Set Bag Button position -- {{{
		if self.GetOpt("Bag") == "bar" then
			local col, row = 0, 0
			if self.GetOpt("Player") or self.GetOpt("Graphics") == "art" then row = 1 end
			col = (self.GetOpt("Columns") - self.totalBags)/2
			col = col + bagFrame:GetID() - self.firstBag
			bagButton:Show()
			bagButton:ClearAllPoints()
			bagButton:SetPoint("TOPLEFT", self.frameName, "TOPLEFT", self:GetXY(row, col))
		elseif self.GetOpt("Bag") == "before" then	
			if self.curCol >= self.GetOpt("Columns") then
				self.curCol  = 0
				self.curRow = self.curRow + 1
			end
			bagButton:Show()
			bagButton:ClearAllPoints()
			bagButton:SetPoint("TOPLEFT", self.frameName, "TOPLEFT", self:GetXY(self.curRow,self.curCol))
			self.curCol = self.curCol + 1
		else
			bagButton:Hide()
		end -- }}}
		if not self:IncludeBag(bagFrame:GetID()) or self.isBank then 
			bagButton:SetChecked(nil)
		else
			bagButton:SetChecked(1)
		end
	end
	local maxIndex = 20
	if bagFrame.maxIndex then maxIndex = bagFrame.maxIndex end
	for slot = 1, maxIndex do
		local itemButton = getglobal(itemBase .. slot)
		if bagFrame.size < slot or not self:IncludeBag(bagFrame:GetID()) then
			itemButton:Hide() 
		else	
			if self.curCol >= self.GetOpt("Columns") then
				self.curCol = 0
				self.curRow = self.curRow + 1
			end
			itemButton:Show()
			itemButton:ClearAllPoints()
			itemButton:SetPoint("TOPLEFT", self.frame:GetName(), "TOPLEFT", self:GetXY(self.curRow, self.curCol))
			self.curCol = self.curCol + 1
			texture, count, _, locked, quality = self:GetInfo(bagFrame:GetID(), slot)
			if self.isLive then
				local start,duration, enable = GetContainerItemCooldown(bagFrame:GetID(), slot)
				local cooldown = getglobal(itemButton:GetName() .. "Cooldown")
				CooldownFrame_SetTimer(cooldown,start,duration,enable)
				if duration>0 and enable==0 then
					SetItemButtonTextureVertexColor(itemButton, 0.4,0.4,0.4)
				end
			end
			
			SetItemButtonTexture(itemButton, (texture or ""))
			SetItemButtonCount(itemButton, count)
			SetItemButtonDesaturated(itemButton, locked, 0.5, 0.5, 0.5)
			if quality and self.GetOpt("Border") then
				SetItemButtonNormalTextureVertexColor(itemButton, ace.ColorConvertHexToDigit(quality))
			else
				SetItemButtonNormalTextureVertexColor(itemButton, unpack(MYBAGS_SLOTCOLOR))
			end
			if ammo then
				SetItemButtonNormalTextureVertexColor(itemButton, unpack(MYBAGS_AMMOCOLOR))
			end
		end
	end
end --}}}
function MyBagsCoreClass:LayoutFrame() -- {{{
	if not self.frame:IsVisible() then return end
	self.isLive = self:IsLive()
	local bagBase = self.frameName .. "Bag"
	local bagIndex, bagFrame
	self.curRow, self.curCol = 0,0
	self:LayoutOptions()
	if self.isBank then
		bagFrame = getglobal(self.frameName .. "Bank")
		self:LayoutBagFrame(bagFrame)
	end
	for bag = 0, self.totalBags-1 do
		bagFrame = getglobal(bagBase .. bag)
		if (bagFrame) then
			self:LayoutBagFrame(bagFrame)
		end
	end
	if self.curCol == 0 then self.curRow = self.curRow - 1 end
	self.frame:SetWidth(self._LEFTOFFSET + self._RIGHTOFFSET + self.GetOpt("Columns") * MYBAGS_COLWIDTH)
	self.frame:SetHeight(self._TOPOFFSET + self._BOTTOMOFFSET + (self.curRow + 1) * MYBAGS_ROWHEIGHT)
end -- }}}

function MyBagsCoreClass:LockButton_OnClick() -- {{{
	self.TogOpt("Lock")
	self:SetLockTexture()
end -- }}}

function MyBagsCoreClass:SetLockTexture() -- {{{
	local button = getglobal(self.frameName .. "ButtonsLockButtonNormalTexture")
	local texture = "Interface\\AddOns\\MyBags\\Skin\\LockButton-"
	if not self.GetOpt("Lock") then texture = texture .. "Un" end
	texture = texture .. "Locked-Up"
	button:SetTexture(texture)
	if self.GetOpt("Lock") then
		self:debug("Frame is Locked")
		self.frame:EnableMouse(nil)
	else
		self:debug("Frame is not Locked")
		self.frame:EnableMouse(1)
	end
end -- }}}
function MyBagsCoreClass:SetFrozen() -- {{{
	if not self.GetOpt("Freeze") then
		table.insert(UISpecialFrames, self.frameName)
	else
		local k,v
		for k,v in UISpecialFrames do
			if v == (self.frameName) then
				table.remove(UISpecialFrames, k)
			end
		end
	end
end -- }}}

--CHAT CMD OPTIONS {{{
function MyBagsCoreClass:SetColumns(cols)-- {{{
	cols = ace.tonum(cols)
	
	if( (cols >= self.minColumns) and (cols <= self.maxColumns) ) then
		self.SetOpt("Columns", cols)
		self:LayoutFrame()
		--self.Result(ONEBAG_TEXT_COLS, cols)
	else
		--self.Result(ONEBAG_COLUMN_LIMIT_MSG, self.minColumns, self.maxColumns)
	end
end -- }}}
function MyBagsCoreClass:SetReplace()-- {{{
	self.TogMsg("Replace", "Replace default bags")
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetBagDisplay(opt)-- {{{
	self.SetOpt("Bag", opt)
	self.Result("Bag Buttons", opt)
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetGraphicsDisplay(opt)-- {{{
	local a, r, g, b
	opt, a, r, g, b = unpack(ace.ParseWords(opt))
	self:debug("opt: |" .. opt .."| ")
	if opt ~= "default" and opt~="art" and opt~="none" then
		return
	end
	self.SetOpt("Graphics", opt)
	if a then
		self.SetOpt("BackColor", {ace.tonum(a), ace.tonum(r), ace.tonum(g), ace.tonum(b)})
	else
		self.SetOpt("BackColor")
	end
	self.Result("Background", opt)
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetHighlight(mode)-- {{{
	if mode == "items" then
		self.TogMsg("HlItems", "Highlight")
	else
		self.TogMsg("HlBags", "Highlight")
	end
end -- }}}
function MyBagsCoreClass:SetFreeze()-- {{{
	self.TogMsg("Freeze", "Freeze")
	self:SetFrozen()
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetLock()-- {{{
	self.TogMsg("Lock", "Lock")
	self:SetLockTexture()
end -- }}}
function MyBagsCoreClass:SetTitle()-- {{{
	self.TogMsg("Title", "Frame Title")
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetCash()-- {{{
	self.TogMsg("Cash", "Money Display")
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetButtons()-- {{{
	self.TogMsg("Buttons", "Frame Buttons")
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetAIOI()-- {{{
	self.TogMsg("AIOI", "AIOI Style ordering")
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetBorder()-- {{{
	self.TogMsg("Border", "Quality Borders")
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetPlayerSel()-- {{{
	if self:CanSaveItems() then
		self.TogMsg("Player", "Player selection")
	else
		self.SetOpt("Player")
	end
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetCount(mode)-- {{{
	self.SetOpt("Count", mode)
	self.Result("Count", mode)
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:SetScale(scale) -- {{{
	scale = ace.tonum(scale)

	if scale == 0 then
		self.SetOpt("Scale")
		self.frame:SetScale(self.frame:GetParent():GetScale())
		self.Result("Scale", ACEG_TEXT_DEFAULT)
	elseif (( scale < ace.tonum(MIN_SCALE_VAL)) or (scale > ace.tonum(MAX_SCALE_VAL))) then
		self.Error("Invalid Scale")
	else
		self.SetOpt("Scale", scale)
		self.frame:SetScale(scale)
		self.Result("Scale", scale)
	end
end -- }}}
function MyBagsCoreClass:Report() -- {{{
	self.cmd:report({
		{text="Columns", val=self.GetOpt("Columns")},
		{text="Replace", val=self.GetOpt("Replace"),map=ACEG_MAP_ONOFF},
		{text="Bag", val=self.GetOpt("Bag")},
		{text="Graphics", val=self.GetOpt("Graphics")},
		{text="HlItems", val=self.GetOpt("HlItems"),map=ACEG_MAP_ONOFF},
		{text="HlBags", val=self.GetOpt("HlBags"),map=ACEG_MAP_ONOFF},
		{text="Freeze", val=self.GetOpt("Freeze"),map=ACEG_MAP_ONOFF},
		{text="Lock", val=self.GetOpt("Lock"),map=ACEG_MAP_ONOFF},
		{text="Title", val=self.GetOpt("Title"),map=ACEG_MAP_ONOFF},
		{text="Cash", val=self.GetOpt("Cash"),map=ACEG_MAP_ONOFF},
		{text="Buttons", val=self.GetOpt("Buttons"),map=ACEG_MAP_ONOFF},
		{text="AIOI", val=self.GetOpt("AIOI"),map=ACEG_MAP_ONOFF},
		{text="Border", val=self.GetOpt("Border"),map=ACEG_MAP_ONOFF},
		{text="Player", val=self.GetOpt("Player"),map=ACEG_MAP_ONOFF},
		{text="Count", val=self.GetOpt("Count")},
		{text="Scale", val=self.GetOpt("Scale")},
		{text="Anchor", val=self.GetOpt("Anchor")},
	})
end -- }}}
function MyBagsCoreClass:ResetSettings() -- {{{
	self.db:reset(self.profilePath, self.defaults)
	self.Error("Settings reset to default")
	self:ResetAnchor()
	self:SetLockTexture()
	self:SetFrozen()
	self:LayoutFrame()
end -- }}}
function MyBagsCoreClass:ResetAnchor() -- {{{
	if not self:SetAnchor(self.defaults.Anchor) then return end
	anchorframe = self.frame:GetParent() 
	anchorframe:ClearAllPoints()
	anchorframe:SetPoint(self.anchorPoint, self.anchorParent, self.anchorPoint, self.anchorOffsetX, self.anchorOffsetY)
	self.frame:ClearAllPoints()
	self.frame:SetPoint(self.anchorPoint, anchorframe, self.anchorPoint, 0, 0)
	self.Error("Anchor Reset")
end -- }}}
function MyBagsCoreClass:SetAnchor(point) -- {{{
	if     point == "topleft" then
	elseif point == "topright" then
	elseif point == "bottomleft" then
	elseif point == "bottomright" then
	else self.Error("Invalid Entry for Anchor") return end
	local anchorframe = self.frame:GetParent()
	local top = self.frame:GetTop()
	local left = self.frame:GetLeft()
	local top1 = anchorframe:GetTop()
	local left1 = anchorframe:GetLeft()
	if not top or not left or not left1 or not top1 then
		self.Error("Frame must be open to set anchor") return
	end
	self.frame:ClearAllPoints()
	anchorframe:ClearAllPoints()
	anchorframe:SetPoint(string.upper(point), self.frameName, string.upper(point), 0, 0)
	top = anchorframe:GetTop()
	left = anchorframe:GetLeft()
	if not top or not left then
		anchorframe:ClearAllPoints()
		anchorframe:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", left1, top1-10)
		point = string.upper(self.GetOpt("Anchor") or "bottomright")
		self.frame:SetPoint(point, anchorframe:GetName(), point, 0,0)
		self.Error("Frame must be open to set anchor") return
	end
	anchorframe:ClearAllPoints()
	anchorframe:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", left, top-10)
	self.frame:SetPoint(string.upper(point), anchorframe:GetName(), string.upper(point), 0, 0)
	self.SetOpt("Anchor", point)
	self.Result("Anchor", point)
	self.anchorPoint = string.upper(point)
	return TRUE
end -- }}}
-- }}}
