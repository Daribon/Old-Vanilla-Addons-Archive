if( not ace:LoadTranslation("KC_Items_Inventory") ) then

KC_INVENTORY_NAME          = "KC_Inventory"
KC_INVENTORY_DESCRIPTION   = "A KC_Items Module for handling inventory info."

KC_INVENTORY_TEXT_SAVED		= "Inventory data has been saved."
KC_INVENTORY_TEXT_ERASED	= "All inventory data has been erased.";

KC_INVENTORY_CMD_OPTIONS = {
	option	= "inventory",
	desc	= "Inventory related commands.",
	args	= {
			{
				option = "save",
				desc   = "Force saves inventory data.",
				method = "save"
			},
            {
				option = "clear",
				desc   = "Erase inventory data for all characters.",
				method = "clear"
			},
        },
        
}

StaticPopupDialogs["KCI_INVENTORYCLEARDATA_CONFIRM"] = {
		text = TEXT("|cffff3333\nTHIS IS NON-REVERSABLE!\n\nTHIS IS NON-REVERSABLE!\n\n|cffffff78Clear all inventory item data?\n\n|cffff3333THIS IS NON-REVERSABLE!\n\nTHIS IS NON-REVERSABLE!"),
		button1 = TEXT(OKAY),
		button2 = TEXT(CANCEL),
		OnAccept = function()
			KC_Items.inventory:clearConfirmed()
		end,
		showAlert = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
};

end