PopupHandler_BindonPickupFrame_SlotList = {};

POPUPHANDLER_BINDONPICKUP_SCHEDULE_DELAY = 0.1;

PopupHandler_BindOnPickup_RightPopups = {
	"LOOT_BIND"
};

function PopupHandler_BindonPickup_OnLoad()
	for k, v in PopupHandler_BindOnPickup_RightPopups do
		PopupHandler_AddPopupHandler(v, PopupHandler_BindOnPickup_PopupHandler);
	end
	
	PopupHandler_AddEventListener("LOOT_BIND_CONFIRM", PopupHandler_BindonPickup_LootBindConfirmEvent)
	
	local option = PopupHandler_Get_Khaos_CheckBox(
		"autoBindOnPickupCheckBox", 
		"autoBindOnPickup", 
		POPUPHANDLER_OPTION_BIND_ON_PICKUP_NAME,
		POPUPHANDLER_OPTION_BIND_ON_PICKUP_INFO,
		false,
		function (state) PopupHandler_UpdateBooleanOption("autoBindOnPickup", state.checked); end
	);
	table.insert(PopupHandler_Khaos_Options_Easy, option);
	PopupHandler_AddSlashCommand(POPUPHANDLER_CHAT_BIND_ON_PICKUP_CMDS, "autoBindOnPickup", POPUPHANDLER_CHAT_BIND_ON_PICKUP_FORMAT, POPUPHANDLER_OPTION_BIND_ON_PICKUP_NAME, POPUPHANDLER_OPTION_BIND_ON_PICKUP_INFO);

	PopupHandler_AddCosmosBooleanOption("autoBindOnPickup", false, 
		POPUPHANDLER_OPTION_BIND_ON_PICKUP_NAME, 
		POPUPHANDLER_OPTION_BIND_ON_PICKUP_INFO
	);
	
end

function PopupHandler_BindOnPickup_PopupHandler(which, text_arg1, text_arg2)
	if ( PopupHandler_Options.autoBindOnPickup ) and ( not PopupHandler_BindonPickup_IsInPartyOrRaid() ) then
		PopupHandler_StaticPopup_Show_ReturnNow = true;
		PopupHandler_StaticPopup_Show_ReturnDialog = nil;
	else
		PopupHandler_StaticPopup_Show_ReturnDialog = PopupHandler_Saved_StaticPopup_Show(which, text_arg1, text_arg2);
	end
end

function PopupHandler_BindonPickup_LootBindConfirmEvent(slot)
	if ( PopupHandler_Options.autoBindOnPickup ) and ( not PopupHandler_BindonPickup_IsInPartyOrRaid() ) then
		PopupHandler_BindonPickup_LootSlot(slot);
	end
end

function PopupHandler_BindonPickup_LootSlot(slot)
	if ( Chronos ) and ( Chronos.schedule ) then
		Chronos.schedule(POPUPHANDLER_BINDONPICKUP_SCHEDULE_DELAY, LootSlot, slot);
	elseif ( Cosmos_Schedule ) then
		Cosmos_Schedule(POPUPHANDLER_BINDONPICKUP_SCHEDULE_DELAY, LootSlot, slot);
	else
		PopupHandler_BindonPickup_AddLootSlot(slot);
	end
end

function PopupHandler_BindonPickup_IsInPartyOrRaid()
	if ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0  ) ) then
		return true;
	else
		return false;
	end
end

function PopupHandler_BindonPickup_AddLootSlot(slot)
	local n = PopupHandler_BindonPickupFrame_SlotList.n;
	if ( not n ) then
		n = 1;
	else
		n = n + 1;
	end
	PopupHandler_BindonPickupFrame_SlotList.n = n;
	PopupHandler_BindonPickupFrame_SlotList[n] = slot;
	if ( not PopupHandler_BindonPickupFrame:IsVisible() ) then
		PopupHandler_BindonPickupFrame:Show();
	end
end

function PopupHandler_BindonPickupFrame_OnUpdate()
	local n = PopupHandler_BindonPickupFrame_SlotList.n;
	if ( n > 0 ) then
		local slot = PopupHandler_BindonPickupFrame_SlotList[n];
		PopupHandler_BindonPickupFrame_SlotList[n] = nil;
		PopupHandler_BindonPickupFrame_SlotList.n = n - 1;
		if ( slot ) then
			LootSlot(slot);
		end
	else
		PopupHandler_BindonPickupFrame:Hide();
	end
end


PopupHandler_Options.autoBindOnPickup = false;
PopupHandler_Keys_To_Cosmos.autoBindOnPickup = "COS_POPUPHANDLER_AUTO_BIND_ON_PICKUP";
table.insert(PopupHandler_HandlersOnLoad, PopupHandler_BindonPickup_OnLoad);


