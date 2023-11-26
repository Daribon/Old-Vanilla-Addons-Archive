PopupHandler_OverwriteEnchant_RightPopups = {
	"REPLACE_ENCHANT"
};

function PopupHandler_OverwriteEnchant_OnLoad()
	for k, v in PopupHandler_OverwriteEnchant_RightPopups do
		PopupHandler_AddPopupHandler(v, PopupHandler_OverwriteEnchant_PopupHandler);
	end
	
	local option = PopupHandler_Get_Khaos_CheckBox(
		"autoOverwriteEnchantCheckBox", 
		"autoOverwriteEnchant", 
		POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_NAME,
		POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoOverwriteEnchant", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option);
	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_OVERWRITE_ENCHANT_CMDS, "autoOverwriteEnchant", POPUPHANDLER_CHAT_OVERWRITE_ENCHANT_FORMAT, POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_NAME, POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_INFO);

	PopupHandler_AddCosmosBooleanOption("autoOverwriteEnchant", false, 
		POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_NAME, 
		POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_INFO
	);
	
end

function PopupHandler_OverwriteEnchant_PopupHandler(which, text_arg1, text_arg2)
	if ( PopupHandler_Options.autoOverwriteEnchant ) and ( not PopupHandler_OverwriteEnchant_IsInPartyOrRaid() ) then
		ReplaceEnchant();
		PopupHandler_StaticPopup_Show_ReturnNow = true;
		PopupHandler_StaticPopup_Show_ReturnDialog = nil;
	else
		PopupHandler_StaticPopup_Show_ReturnDialog = PopupHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2)
	end
end

function PopupHandler_OverwriteEnchant_IsInPartyOrRaid()
	if ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0  ) ) then
		return true;
	else
		return false;
	end
end

PopupHandler_Options.autoOverwriteEnchant = false;
PopupHandler_Keys_To_Cosmos.autoOverwriteEnchant = "COS_POPUPHANDLER_AUTO_OVERWRITE_ENCHANT";

table.insert(PopupHandler_HandlersOnLoad, PopupHandler_OverwriteEnchant_OnLoad);
