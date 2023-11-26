local lOriginal_PurchaseSlot;
PURCHASE_BAG_SLOT="Are you sure you wish to purchase a bag slot?";


StaticPopupDialogs["PURCHASE_BANKBAG"] = {
	text = TEXT(PURCHASE_BAG_SLOT),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		lOriginal_PurchaseSlot();
	end,
	showAlert = 1,
	timeout = 0,
};

function BankBuy_OnLoad()
	lOriginal_PurchaseSlot = PurchaseSlot;
	PurchaseSlot=BankBuy_PurchaseSlot;
end

function BankBuy_PurchaseSlot()
	StaticPopup_Show("PURCHASE_BANKBAG");
end