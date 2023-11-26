if( not ace:LoadTranslation("KC_Items_Auction") ) then

KC_AUCTION_NAME          = "KC_Auction"
KC_AUCTION_DESCRIPTION   = "A KC_Items Module for handling auciton scanning and data retention."

KC_AUCTION_TEXT_CANT_SCAN = "Must have the auction house window open during a scan.";


KC_AUCTION_TEXT_BASE		= format(ACE_CMD_RESULT, KC_Items.name, KC_ITEMS_MSG_COLOR);
KC_AUCTION_TEXT_SCANNING	= KC_AUCTION_TEXT_BASE .. "Is currently scanning page %s of %s of the \"%s\" category.";
KC_AUCTION_TEXT_SETTINGUP	= KC_AUCTION_TEXT_BASE .. "Is setting up to scan the marked categories.";
KC_AUCTION_TEXT_NO_TARGETS  = KC_AUCTION_TEXT_BASE .. "You must have at least one category selected to perform a scan.";

KC_AUCTION_TEXT_SCAN_DONE		= KC_AUCTION_TEXT_BASE .. "Scanning has been completed.";
KC_AUCTION_TEXT_SCAN_CANCELED	= KC_AUCTION_TEXT_BASE .. "Scanning has been cancled";

KC_AUCTION_TEXT_SHORT_DISPLAY_MODE	= "Short display mode";
KC_AUCTION_TEXT_DISPLAY_OF_SINGLE	= "Display of single prices";
KC_AUCTION_TEXT_DISPLAY_OF_BID		= "Display of bid price";
KC_AUCTION_TEXT_DISPLAY_OF_STATS	= "Display of item's stats";

KC_AUCTION_TEXT_EACH				= "|cffff3333(each)|r";

KC_AUCTION_TEXT_MIN_SHORT	= "|cff00ffffMin (|r%s|cff00ffff)|r";
KC_AUCTION_TEXT_BID_SHORT	= "|cff00ffffBid (|r%s|cff00ffff)|r";
KC_AUCTION_TEXT_BUY_SHORT	= "|cff00ffffBuy (|r%s|cff00ffff)|r";

KC_AUCTION_TEXT_AUCTION_PRICES_FOR	= "|cff00ffffAuction prices for (|r%s|cff00ffff)";

KC_AUCTION_TEXT_STATS	= "|cff00ffffSeen |r%s|cff00ffff times, in Avg Stacks of |r%s."

KC_AUCTION_TEXT_SEP = "-";
KC_AUCTION_SEPCOLOR = "|cff00ffff";

KC_AUCTION_TEXT_SCAN	  = "Scan";
KC_AUCTION_TEXT_STOP_SCAN = "Stop Scan";

KC_AUCTION_TEXT_AUCTION_DATA_CLEARED = "All auction data has been erased for this faction/server.";

KC_AUCTION_TEXT_MIN_LONG	= "|cff00ffffMinBid|r ";
KC_AUCTION_TEXT_BID_LONG	= "|cff00ffffActual Bid|r ";
KC_AUCTION_TEXT_BUY_LONG	= "|cff00ffffBuyout|r ";

KC_AUCTION_CMD_OPTIONS = {
	option	= "auction",
	desc	= "Auction data related commands.",
	args	= {
		{
			option = "scan",
			desc   = "Initiates an Auction House scan.",
			method = "scanstart"
		},
		{
			option = "short",
			desc   = "Toggles use of the short display mode.",
			method = "short"
		},
		{
			option = "single",
			desc   = "Toggles display of the single price.",
			method = "single"
		},
		{
			option = "showbid",
			desc   = "Toggles display of the bid average.",
			method = "showbid"
		},
		{
			option = "showstats",
			desc   = "Toggles display of the item's stats.",
			method = "showstats"
		},
		{
			option = "clear",
			desc   = "Clears saved auction data and resets default options.",
			method = "clear"
		},
	},
        
}

StaticPopupDialogs["KCI_AUCTION_CLEARDATA_CONFIRM"] = {
		text = TEXT("|cffff3333\nTHIS IS NON-REVERSABLE!\n\nTHIS IS NON-REVERSABLE!\n\n|cffffff78Clear all auction data?\n\n|cffff3333THIS IS NON-REVERSABLE!\n\nTHIS IS NON-REVERSABLE!"),
		button1 = TEXT(OKAY),
		button2 = TEXT(CANCEL),
		OnAccept = function()
			KC_Items.auction:clearConfirmed()
		end,
		showAlert = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		interruptCinematic = 1
};

end