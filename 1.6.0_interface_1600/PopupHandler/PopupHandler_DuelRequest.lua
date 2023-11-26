function PopupHandler_DuelRequest_OnLoad()
	PopupHandler_AddPopupHandler("DUEL_REQUESTED", PopupHandler_DuelRequest_Popup);

	local option1 = PopupHandler_Get_Khaos_CheckBox(
		"autoDeclineDuelRequestCheckBox", 
		"autoDeclineDuelRequest", 
		POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_NAME,
		POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoDeclineDuelRequest", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option1);

	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_DECLINE_DUEL_REQUEST_CMDS, "autoDeclineDuelRequest", POPUPHANDLER_CHAT_DECLINE_DUEL_REQUEST_FORMAT, POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_NAME, POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_INFO);

	PopupHandler_AddCosmosBooleanOption("autoDeclineDuelRequest", false, 
		POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_NAME, 
		POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_INFO
	);
	
end

function PopupHandler_DuelRequest_Popup(which, text_arg1, text_arg2)
	if ( PopupHandler_DuelRequest_IgnoreNextOffer ) then
		PopupHandler_DuelRequest_IgnoreNextOffer = false;
		return;
	end
	local popup = StaticPopupDialogs[which];
	if ( PopupHandler_Options.autoDeclineDuelRequest ) then
		popup.OnCancel();
		PopupHandler_StaticPopup_Show_ReturnNow = true;
		PopupHandler_StaticPopup_Show_ReturnDialog = nil;
	else
		PopupHandler_StaticPopup_Show_ReturnDialog = PopupHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2)
	end
end

PopupHandler_Options.autoDeclineDuelRequest = false;
PopupHandler_Keys_To_Cosmos.autoDeclineDuelRequest = "COS_POPUPHANDLER_AUTO_DECLINE_DUEL_REQUEST";
table.insert(PopupHandler_HandlersOnLoad, PopupHandler_DuelRequest_OnLoad);
