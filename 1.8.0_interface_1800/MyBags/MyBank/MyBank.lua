local MYBANK_DEFAULT_OPTIONS = { -- {{{
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
	Anchor   = "bottomleft",
	BackColor= {0.7,0,0,0},
} -- }}}
MyBankClass = MyBagsCoreClass:new({
	name           = MYBANK_NAME,
	description    = MYBANK_DESCRIPTION,
	db             = AceDbClass:new("MyBankDB"),
	defaults       = MYBANK_DEFAULT_OPTIONS,
	frameName      = "MyBankFrame",
	cmd            = AceChatCmdClass:new(MYBANK_COMMANDS, MYBANK_CMD_OPTIONS),

	totalBags        = 6,
	firstBag         = 5,
	isBank			  = TRUE,
	atBank           = FALSE,
	
	saveBankFrame    = BankFrame,

	anchorPoint      = "BOTTOMLEFT",
	anchorParent     = "UIParent",
	anchorOffsetX    = 5,
	anchorOffsetY    = 100,
})

function MyBankClass:Enable() -- {{{
	MyBagsCoreClass.Enable(self)
	MyBankFrameBank.maxIndex = 24
	MyBankFrameBank:SetID(BANK_CONTAINER)
	MyBankFrameBag0:SetID(5)
	MyBankFrameBag1:SetID(6)
	MyBankFrameBag2:SetID(7)
	MyBankFrameBag3:SetID(8)
	MyBankFrameBag4:SetID(9)
	MyBankFrameBag5:SetID(10)
	if self.GetOpt("Replace") then
		BankFrame:UnregisterEvent("BANKFRAME_OPENED")
		BankFrame:UnregisterEvent("BANKFRAME_CLOSED")
		setglobal("BankFrame", self.frame)
	end
	MyBankFramePortrait:SetTexture("Interface\\Addons\\MyBags\\Skin\\MyBankPortait");
	StaticPopupDialogs["PURCHASE_BANKBAG"] = {
		text = TEXT("Are you sure you want to buy a bag?"),
		button1 = TEXT(ACCEPT),
		button2 = TEXT(CANCEL),
		OnAccept = function()
			PurchaseSlot();
			MyBank:LayoutFrame();
		end,
		showAlert = 1,
		timeout = 0,
	}
end -- }}}

function MyBankClass:Disable()
	BankFrame = self.saveBankFrame
	BankFrame:RegisterEvent("BANKFRAME_OPENED")
	BankFrame:RegisterEvent("BANKFRAME_CLOSED")
end
function MyBankClass:RegisterEvents() -- {{{
	MyBagsCoreClass.RegisterEvents(self)
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
end -- }}}

function MyBankClass:BANKFRAME_OPENED() -- {{{
	self.atBank = TRUE
	SetPortraitTexture(MyBankFramePortrait, "npc");
	if self.GetOpt("Replace") then self:Open() end
	self:LayoutFrame()
end -- }}}
function MyBankClass:BANKFRAME_CLOSED() -- {{{
	self.atBank = FALSE
	if self.GetOpt("Replace") and not self.GetOpt("Freeze") then self:Close() end
	self:LayoutFrame()
	MyBankFramePortrait:SetTexture("Interface\\Addons\\MyBags\\Skin\\MyBankPortait");
end -- }}}

function MyBankClass:GetInfoFunc() -- {{{
	if self.isLive then
		return self.GetInfoLive
	end
	if KC_Bank then
		return self.GetInfoKC
	end
	if MyBagsCache then
		return self.GetInfoMyBagsCache
	end
	return self.GetInfoNone
end -- }}}
function MyBankClass:GetInfoKC(bag, slot) -- {{{
	local texture, count, ID = nil, nil, nil
	local locked, quality, readable = nil, nil, nil
	local charID = self:GetCurrentPlayer()
	if slot then
		texture, count, ID = KC_Bank:BankSlotInfo(bag, slot, charID)
	else
		texture, count, ID = KC_Bank:BankBagInfo(bag, charID)
		if bag == -1 then count = 24 end
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

function MyBankClass:SetReplace() -- {{{
	MyBagsCoreClass.SetReplace(self)
	if self.GetOpt("Replace") then
		BankFrame:UnregisterEvent("BANKFRAME_OPENED")
		BankFrame:UnregisterEvent("BANKFRAME_CLOSED")
		setglobal("BankFrame", self.frame)
	else
		setglobal("BankFrame",  self.saveBankFrame)
		BankFrame:RegisterEvent("BANKFRAME_OPENED")
		BankFrame:RegisterEvent("BANKFRAME_CLOSED")
	end
end -- }}}

MyBank = MyBankClass:new()
MyBank:RegisterForLoad()
