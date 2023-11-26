local MYINVENTORY_DEFAULT_OPTIONS = { -- {{{
	Columns  = 10,
	Replace  = TRUE,
	Bag      = "none",
	Graphics = "default",
	Count    = "free", 
	HlItems  = TRUE,
	HlBags   = TRUE,
	Freeze   = FALSE,
	Lock     = FALSE,
	Title    = TRUE,
	Cash     = TRUE,
	Buttons  = TRUE,
	AIOI     = FALSE,
	Border   = TRUE,
	Player   = FALSE,
	Scale    = FALSE,
	Anchor   = "bottomright",
	BackColor= {0.7,0,0,0},
} -- }}}

MyInventoryClass = MyBagsCoreClass:new({
	name           = MYINVENTORY_NAME,
	description    = MYINVENTORY_DESCRIPTION,
	db             = AceDbClass:new("MyInventoryDB"),
	defaults       = MYINVENTORY_DEFAULT_OPTIONS,
	frameName      = "MyInventoryFrame",
	cmd            = AceChatCmdClass:new(MYINVENTORY_COMMANDS, MYINVENTORY_CMD_OPTIONS),

	totalBags        = 5,
	firstBag         = 0,
	anchorPoint      = "BOTTOMRIGHT",
	anchorParent     = "UIParent",
	anchorOffsetX    = -5,
	anchorOffsetY    = 100,
})

function MyInventoryClass:HookFunctions() -- {{{
	MyBagsCoreClass.HookFunctions(self)

	self:Hook("ToggleBackpack")
	self:Hook("OpenBackpack")
	self:Hook("CloseBackpack")
end -- }}}

function MyInventoryClass:ToggleBackpack() -- {{{
	if not (self.GetOpt("Replace") and self:IncludeBag(0)) then
		self:CallHook("ToggleBackpack")
	else
		self:Toggle()
	end
end -- }}}
function MyInventoryClass:OpenBackpack() -- {{{
	if not (self.GetOpt("Replace") and self:IncludeBag(0)) then
		self:CallHook("OpenBackpack")
	else
		self:Open()
	end
end -- }}}
function MyInventoryClass:CloseBackpack() -- {{{
	if not (self.GetOpt("Replace") and self:IncludeBag(0)) then
		self:CallHook("CloseBackpack")
	elseif not self.GetOpt("Freeze") then
		self:Close()
	end
end -- }}}

function MyInventoryClass:GetInfoFunc() -- {{{
	if self.isLive then
		return self.GetInfoLive
	end
	if KC_Inventory then
		return self.GetInfoKC
	end
	if MyBagsCache then
		return self.GetInfoMyBagsCache
	end
	return self.GetInfoNone
end -- }}}
function MyInventoryClass:GetInfoKC(bag, slot) -- {{{
	local texture, count, ID = nil, nil, nil
	local locked, quality, readable = nil, nil, nil
	local charID = self.Player
	if slot ~= nil then
		texture, count, ID = KC_Inventory:InvSlotInfo(bag,slot, charID)
	else
		texture, count, ID = KC_Inventory:InvBagInfo(bag, charID)
		if bag == 0 then 
			texture = "Interface\\Buttons\\Button-Backpack-Up"
			count = 16
		end
	end
	if ID then
		quality = KC_Items:GetColor(ID)
		local c 
		_,_,_,_,c = GetItemInfo("item:"..ID)
		if(strlower(c or "")==strlower(ACEG_TEXT_AMMO)) then readable = 1 end
		if(strlower(c or "")==strlower(ACEG_TEXT_QUIVER)) then readable = 2 end
	end
	count = ace.tonum(count)
	return texture, count, ID, locked, quality, readable
end -- }}}

function MyInventoryClass:BagIDToInvSlotID(bag) -- {{{
	if bag == 0 then return nil end
	return ContainerIDToInventoryID(bag)
end -- }}}
function MyInventoryClass:IsBagSlotUsable(slot) -- {{{
	if slot >= 0 and slot <= 4 then return true end
	return false
end -- }}}

MyInventory = MyInventoryClass:new()
MyInventory:RegisterForLoad()
