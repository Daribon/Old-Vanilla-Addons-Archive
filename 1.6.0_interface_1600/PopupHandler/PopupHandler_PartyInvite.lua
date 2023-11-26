function PopupHandler_PartyInvite_OnLoad()
	PopupHandler_AddPopupHandler("PARTY_INVITE", PopupHandler_PartyInvite_Popup);

	local option1 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptPartyInvitesCheckBox", 
		"autoAcceptPartyInvites", 
		POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_NAME,
		POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptPartyInvites", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option1);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_PARTY_INVITES_CMDS, "autoAcceptPartyInvites", POPUPHANDLER_CHAT_ACCEPT_PARTY_INVITES_FORMAT, POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_NAME, POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptPartyInvites", false, 
		POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptPartyInvites", toggle); end
	);

	local option2 = PopupHandler_Get_Khaos_CheckBox(
		"autoDeclinePartyInvitesCheckBox", 
		"autoDeclinePartyInvites", 
		POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_NAME,
		POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoDeclinePartyInvites", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option2);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_DECLINE_PARTY_INVITES_CMDS, "autoDeclinePartyInvites", POPUPHANDLER_CHAT_DECLINE_PARTY_INVITES_FORMAT, POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_NAME, POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_INFO);

	PopupHandler_AddCosmosBooleanOption("autoDeclinePartyInvites", false, 
		POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_NAME, 
		POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoDeclinePartyInvites", toggle); end
	);

	local option3 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptFriendPartyInvitesCheckBox", 
		"autoAcceptFriendPartyInvites", 
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_NAME,
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptFriendPartyInvites", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option3);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_FRIEND_PARTY_INVITES_CMDS, "autoAcceptFriendPartyInvites", POPUPHANDLER_CHAT_ACCEPT_FRIEND_PARTY_INVITES_FORMAT, POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_NAME, POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptFriendPartyInvites", false, 
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptFriendPartyInvites", toggle); end
	);

	local option4 = PopupHandler_Get_Khaos_CheckBox(
		"autoAcceptGuildPartyInvitesCheckBox", 
		"autoAcceptGuildPartyInvites", 
		POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_NAME,
		POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoAcceptGuildPartyInvites", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option4);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_ACCEPT_GUILD_PARTY_INVITES_CMDS, "autoAcceptGuildPartyInvites", POPUPHANDLER_CHAT_ACCEPT_GUILD_PARTY_INVITES_FORMAT, POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_NAME, POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_INFO);

	PopupHandler_AddCosmosBooleanOption("autoAcceptGuildPartyInvites", false, 
		POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_NAME, 
		POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoAcceptGuildPartyInvites", toggle); end
	);

	local option5 = PopupHandler_Get_Khaos_CheckBox(
		"autoDeclineIgnorePartyInvitesCheckBox", 
		"autoDeclineIgnorePartyInvites", 
		POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_NAME,
		POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoDeclineIgnorePartyInvites", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option5);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_DECLINE_IGNORE_PARTY_INVITES_CMDS, "autoDeclineIgnorePartyInvites", POPUPHANDLER_CHAT_DECLINE_IGNORE_PARTY_INVITES_FORMAT, POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_NAME, POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_INFO);

	PopupHandler_AddCosmosBooleanOption("autoDeclineIgnorePartyInvites", false, 
		POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_NAME, 
		POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_INFO,
		function(toggle) PopupHandler_CosmosBooleanOptionUpdate("autoDeclineIgnorePartyInvites", toggle); end
	);

end

function PopupHandler_PartyInvite_Popup(which, text_arg1, text_arg2)
	if ( PopupHandler_PartyInvite_IgnoreNextInvite ) then
		PopupHandler_PartyInvite_IgnoreNextInvite = false;
		return;
	end
	if ( not text_arg1 ) then
		return;
	end
	local state = 0;
	if ( text_arg1 ) then
		state = PopupHandler_PartyInvite_GetState(text_arg1);
	end
	local popup = StaticPopupDialogs[which];
	if ( state == 1 ) then
		-- accept 
		popup.OnAccept();
	elseif ( state == 2 ) then
		-- silent decline
		popup.OnCancel();
	elseif ( state == 3 ) then
		-- verbose decline
		popup.OnCancel();
		PopupHandler_Print(string.format(POPUPHANDLER_CHAT_DENIED_INVITE_USER, text_arg1));
	else
		PopupHandler_StaticPopup_Show_ReturnDialog = PopupHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2);
		return;
	end
	PopupHandler_StaticPopup_Show_ReturnNow = true;
	PopupHandler_StaticPopup_Show_ReturnDialog = nil;
end

function PopupHandler_PartyInvite_GetState(name)
	if ( PopupHandler_Options.autoAcceptFriendPartyInvites ) then
		for k, v in PopupHandler_FriendList do
			if ( v == name ) then
				return 1;
			end
		end
	end
	if ( PopupHandler_Options.autoAcceptGuildPartyInvites ) then
		for k, v in PopupHandler_GuildList do
			if ( v == name ) then
				return 1;
			end
		end
	end
	if ( PopupHandler_Options.autoDeclineIgnorePartyInvites ) then
		for k, v in PopupHandler_IgnoreList do
			if ( v == name ) then
				return 2;
			end
		end
	end
	if ( PopupHandler_Options.autoAcceptPartyInvites ) then
		return 1;
	end
	if ( PopupHandler_Options.autoDeclinePartyInvites ) then
		if ( PopupHandler_Options.verbosePartyDeclines ) then
			return 3;
		else
			return 2;
		end
	end
	return 0;
end


PopupHandler_Options.autoAcceptPartyInvites = false;
PopupHandler_Options.autoDeclinePartyInvites = false;
PopupHandler_Options.autoAcceptFriendPartyInvites = false;
PopupHandler_Options.autoAcceptGuildPartyInvites = false;
PopupHandler_Options.autoDeclineIgnorePartyInvites = false;
PopupHandler_Options.verbosePartyDeclines = false;

PopupHandler_Keys_To_Cosmos.autoAcceptPartyInvites = "COS_POPUPHANDLER_AUTO_ACCEPT_PARTY_INVITES";
PopupHandler_Keys_To_Cosmos.autoDeclinePartyInvites = "COS_POPUPHANDLER_AUTO_DECLINE_PARTY_INVITES";
PopupHandler_Keys_To_Cosmos.autoAcceptFriendPartyInvites = "COS_POPUPHANDLER_AUTO_ACCEPT_FRIEND_PARTY_INVITES";
PopupHandler_Keys_To_Cosmos.autoAcceptGuildPartyInvites = "COS_POPUPHANDLER_AUTO_ACCEPT_GUILD_PARTY_INVITES";
PopupHandler_Keys_To_Cosmos.autoDeclineIgnorePartyInvites = "COS_POPUPHANDLER_AUTO_DECLINE_IGNORE_PARTY_INVITES";
--PopupHandler_Keys_To_Cosmos.verbosePartyDeclines = "COS_POPUPHANDLER_VERBOSE_PARTY_DECLINES";

table.insert(PopupHandler_HandlersOnLoad, PopupHandler_PartyInvite_OnLoad);
