if( not ace:LoadTranslation("KC_Items_Auction") ) then

KC_AuctionBrokerLocals = {
	name = "KC_AuctionBroker",
	desc = "A KC_Items Module for handling Auction House enhancements.",
}

KC_AucitonBrokerStringTable = {
	amountError		= "The amount given is not valid.  Amount must be numeric and greater than 0.",
	autofillstate	= "Autofill of auction values is",
	cutset			= "Autofill percentage of market values",
}

KC_AuctionBrokerLocals.cmds = {
	option	= "broker",
	desc	= "Auction broker related commands.",
	args	= {
		{
			option = "autofill",
			desc   = "Toggles use of autofill.",
			method = "togAutofill"
		},
		{
			option = "setcut",
			desc   = "Sets % to under/over cut when autofilling.  Format: /kci broker setcut <amount>.   <Amount> must be numeric and be greater than 0.  \n<Amount> is also a percentage so .95 would be 95% of market value.  1.2 would be 120% of market value.",
			method = "setcut"
		},
	},
      
}


end