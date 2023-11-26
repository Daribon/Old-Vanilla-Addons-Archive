if( not ace:LoadTranslation("KC_Items_Bank") ) then

KC_BANK_NAME			= "KC_Bank"
KC_BANK_DESCRIPTION		= "A KC_Items Module for handling bank info."

KC_BANK_TEXT_SAVED		= "Bank data has been saved."
KC_BANK_TEXT_COLLECT	= "Collection of bank data"

KC_BANK_TEXT_NOBANKDATA = "No Bank Data Stored For %s";
KC_BANK_TEXT_NOTBANK	= "Can't save bank data. Must be at bank.";
KC_BANK_TEXT_ERASE		= "All bank data has been erased.";

KC_BANK_CMD_OPTIONS = {
	option	= "bank",
	desc	= "Bank related commands.",
	args	= {
		{
			option = "save",
			desc   = "Saves bank info, bank window must be open.",
			method = "save"
		},
		{
			option = "clear",
			desc   = "Erase bank data for all characters.  NOTE: You can not undo this.",
			method = "clear"
		}
	},
}

end



StaticPopupDialogs["KCI_BANKCLEARDATA_CONFIRM"] = {
		text = TEXT("|cffff3333\nTHIS IS NON-REVERSABLE!\n\nTHIS IS NON-REVERSABLE!\n\n|cffffff78Clear all bank item data?\n\n|cffff3333THIS IS NON-REVERSABLE!\n\nTHIS IS NON-REVERSABLE!"),
		button1 = TEXT(OKAY),
		button2 = TEXT(CANCEL),
		OnAccept = function()
			KC_Items.modules.bank:clearconfirmed()
		end,
		showAlert = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
};