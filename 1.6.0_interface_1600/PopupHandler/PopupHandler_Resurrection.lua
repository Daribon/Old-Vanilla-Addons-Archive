function PopupHandler_Resurrection_OnLoad()
	PopupHandler_AddPopupHandler("RESURRECT", PopupHandler_Resurrection_Popup);
	PopupHandler_AddPopupHandler("RESURRECT_NO_SICKNESS", PopupHandler_Resurrection_Popup);
	PopupHandler_AddPopupHandler("RESURRECT_NO_TIMER", PopupHandler_Resurrection_Popup);

	local option1 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptResurrectionCheckBox", 
		"autoAcceptResurrection", 
		POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option1);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_RESURRECTION_CMDS, "autoAcceptResurrection", POPUPHANDLER_CHAT_ACCEPT_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_NAME, POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptResurrection", false, 
		POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptResurrection", toggle); end
	);
	
	local option2 = PopupHandler_Get_Khaos_CheckBox(
		"autoDeclineResurrectionCheckBox", 
		"autoDeclineResurrection", 
		POPUPHANDLER_OPTION_DECLINE_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_DECLINE_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoDeclineResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option2);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_DECLINE_RESURRECTION_CMDS, "autoDeclineResurrection", POPUPHANDLER_CHAT_DECLINE_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_DECLINE_RESURRECTION_NAME, POPUPHANDLER_OPTION_DECLINE_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoDeclineResurrection", false, 
		POPUPHANDLER_OPTION_DECLINE_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_DECLINE_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoDeclineResurrection", toggle); end
	);
	
	local option3 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptFriendResurrectionCheckBox", 
		"autoAcceptFriendResurrection", 
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptFriendResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option3);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_FRIEND_RESURRECTION_CMDS, "autoAcceptFriendResurrection", POPUPHANDLER_CHAT_ACCEPT_FRIEND_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_NAME, POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptFriendResurrection", false, 
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptFriendResurrection", toggle); end
	);
	
	local option4 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptGuildResurrectionCheckBox", 
		"autoAcceptGuildResurrection", 
		POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptGuildResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option4);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_GUILD_RESURRECTION_CMDS, "autoAcceptGuildResurrection", POPUPHANDLER_CHAT_ACCEPT_GUILD_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_NAME, POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptGuildResurrection", false, 
		POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptGuildResurrection", toggle); end
	);
	
	local option5 = PopupHandler_Get_Khaos_CheckBox(
		"autoDeclineIgnoreResurrectionCheckBox", 
		"autoDeclineIgnoreResurrection", 
		POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoDeclineIgnoreResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option5);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_DECLINE_IGNORE_RESURRECTION_CMDS, "autoDeclineIgnoreResurrection", POPUPHANDLER_CHAT_DECLINE_IGNORE_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_NAME, POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoDeclineIgnoreResurrection", false, 
		POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoDeclineIgnoreResurrection", toggle); end
	);
	
	local option6 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptPartyResurrectionCheckBox", 
		"autoAcceptPartyResurrection", 
		POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptPartyResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option6);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_PARTY_RESURRECTION_CMDS, "autoAcceptPartyResurrection", POPUPHANDLER_CHAT_ACCEPT_PARTY_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_NAME, POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptPartyResurrection", false, 
		POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptPartyResurrection", toggle); end
	);
	
	local option7 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptPvPResurrectionCheckBox", 
		"autoAcceptPvPResurrection", 
		POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptPvPResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option7);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_PVP_RESURRECTION_CMDS, "autoAcceptPvPResurrection", POPUPHANDLER_CHAT_ACCEPT_PVP_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_NAME, POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptPvPResurrection", false, 
		POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptPvPResurrection", toggle); end
	);
	
	local option8 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptAreaResurrectionCheckBox", 
		"autoAcceptAreaResurrection", 
		POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_NAME,
		POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptAreaResurrection", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option8);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_AREA_RESURRECTION_CMDS, "autoAcceptAreaResurrection", POPUPHANDLER_CHAT_ACCEPT_AREA_RESURRECTION_FORMAT, POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_NAME, POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptAreaResurrection", false, 
		POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptAreaResurrection", toggle); end
	);
	
end

function PopupHandler_Resurrection_Popup(which, text_arg1, text_arg2)
	if ( PopupHandler_Resurrection_IgnoreNextOffer ) then
		PopupHandler_Resurrection_IgnoreNextOffer = false;
		return;
	end
	local popup = StaticPopupDialogs[which];
	if ( not text_arg1 ) then
		return;
	end
	local state = 0;
	if ( text_arg1 ) then
		state = PopupHandler_Resurrection_GetState(text_arg1);
	end
	if ( state == 1 ) then
		-- accept 
		popup.OnAccept();
	elseif ( state == 2 ) then
		-- silent decline
		popup.OnCancel();
	elseif ( state == 3 ) then
		-- verbose decline
		popup.OnCancel();
		PopupHandler_Print(string.format(POPUPHANDLER_CHAT_DENIED_RESURRECTION_USER, text_arg1));
	else
		PopupHandler_StaticPopup_Show_ReturnDialog = PopupHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2);
		return;
	end
	PopupHandler_StaticPopup_Show_ReturnNow = true;
	PopupHandler_StaticPopup_Show_ReturnDialog = nil;
end

function PopupHandler_Resurrection_GetState(name)
	if ( PopupHandler_Options.autoAcceptFriendResurrection ) then
		for k, v in PopupHandler_FriendList do
			if ( v == name ) then
				return 1;
			end
		end
	end
	if ( PopupHandler_Options.autoAcceptGuildResurrection ) then
		for k, v in PopupHandler_GuildList do
			if ( v == name ) then
				return 1;
			end
		end
	end
	if ( PopupHandler_Options.autoAcceptPartyResurrection ) then
		for k, v in PopupHandler_UnitsInParty do
			if ( UnitName(v) == name ) then
				return 1;
			end
		end
	end
	if ( PopupHandler_Options.autoDeclineIgnoreResurrection ) then
		for k, v in PopupHandler_IgnoreList do
			if ( v == name ) then
				return 2;
			end
		end
	end
	if ( PopupHandler_Options.autoAcceptPvPResurrection ) then
		if ( UnitIsPVPFreeForAll("player") ) then
			return 1;
		end
		if ( UnitIsPVP("player") ) then
			return 1;
		end
	end
	if ( PopupHandler_Options.autoAcceptAreaResurrection ) then
		local zone = GetRealZoneText();
		for k, v in POPUPHANDLER_AUTO_ACCEPT_RESURRECTION_AREAS do
			if ( v == zone ) then
				return 1;
			end
		end
	end
	if ( PopupHandler_Options.autoAcceptResurrection ) then
		return 1;
	end
	if ( PopupHandler_Options.autoDeclineResurrection ) then
		if ( PopupHandler_Options.verbosePartyDeclines ) then
			return 3;
		else
			return 2;
		end
	end
	return 0;
end


PopupHandler_Options.autoAcceptResurrection = false;
PopupHandler_Options.autoDeclineResurrection = false;
PopupHandler_Options.autoAcceptFriendResurrection = false;
PopupHandler_Options.autoAcceptGuildResurrection = false;
PopupHandler_Options.autoDeclineIgnoreResurrection = false;
PopupHandler_Options.autoAcceptPartyResurrection = false;
PopupHandler_Options.autoAcceptPvPResurrection = false;
PopupHandler_Options.autoAcceptAreaResurrection = false;
PopupHandler_Options.verbosePartyDeclines = false;

PopupHandler_Keys_To_Cosmos.autoAcceptResurrection = "COS_POPUPHANDLER_AUTO_ACCEPT_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoDeclineResurrection = "COS_POPUPHANDLER_AUTO_DECLINE_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoAcceptFriendResurrection = "COS_POPUPHANDLER_AUTO_ACCEPT_FRIEND_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoAcceptGuildResurrection = "COS_POPUPHANDLER_AUTO_ACCEPT_GUILD_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoDeclineIgnoreResurrection = "COS_POPUPHANDLER_AUTO_DECLINE_IGNORE_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoAcceptPartyResurrection = "COS_POPUPHANDLER_AUTO_ACCEPT_PARTY_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoAcceptPvPResurrection = "COS_POPUPHANDLER_AUTO_ACCEPT_PVP_RESURRECTION";
PopupHandler_Keys_To_Cosmos.autoAcceptAreaResurrection = "COS_POPUPHANDLER_AUTO_ACCEPT_AREA_RESURRECTION";

table.insert(PopupHandler_HandlersOnLoad, PopupHandler_Resurrection_OnLoad);
