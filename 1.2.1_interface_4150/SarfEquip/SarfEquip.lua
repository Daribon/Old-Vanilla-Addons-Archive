
MOVE_ITEM_TIMEOFFSET = 0;
MOVE_ITEM_TIMEOFFSET_LOCKED = nil;

SARF_INVALID_BAG_SLOT = -1;

SARF_EQUIPMENT_BAG_SLOT = -1;
SARF_EQUIPMENT_ITEM_SLOT_NAMES = { ["Shirt"] = 4, ["Chest"] = 5, ["Waist"] = 6, ["Legs"] = 7, ["Feet"] = 8, ["Wrist"] = 9, ["Main Hand"] = 16, ["Off Hand"] = 17, ["Ranged"] = 18, ["RangedAmmo"] = 19, ["Ammo"] = 19 };


function FindFreeBagSlot()
	for bag = 4,0,-1 do
		for slot = GetContainerNumSlots(bag),1,-1 do
			if ( not SlotHasItem(bag, slot ) ) then
				return bag, slot;
			end
		end
	end
	return -1,-1;
end

function GetNumberOfFreeItemSlots()
	local freeSlots = 0;
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			local texture, itemCount = GetContainerItemInfo(bag, slot);
			if (not itemCount) then
				freeSlots = freeSlots + 1;
			end
		end
	end
	return freeSlots;
end

function SarfPickupItem(bag, slot)
	if ( ( ( bag ~= nil ) or ( slot ~= nil ) ) and ( ( bag >= 0 ) or ( slot >= 0 ) ) ) then
		if ( ( not bag ) or ( bag == SARF_EQUIPMENT_BAG_SLOT ) ) then
			PickupInventoryItem(slot);
		else
			if ( ( not slot ) or ( slot == SARF_EQUIPMENT_BAG_SLOT ) ) then
				PickupInventoryItem(bag);
			else
				PickupContainerItem(bag, slot);
			end
		end
	end
end

function SarfPutdownItem(bag, slot)
	if ( SlotHasItem(bag, slot) ) then
		bag, slot = FindFreeBagSlot();
	end
	SarfPickupItem(bag, slot);
end

function MoveItemInCursorTo(bag, slot)
	if ( CursorHasItem() ) then
		SarfPickupItem(bag, slot);
	end
	return true;
end

function SlotHasItem(bag, slot)
	if ( bag == SARF_EQUIPMENT_BAG_SLOT) then
		if (slot == SARF_INVALID_BAG_SLOT) then
			return false;
		end
		local hasItem, hasCooldown = CosmosTooltip:SetInventoryItem("player", slot);
		if ( not hasItem) then
			return false;
		else
			return true;
		end
	end
	local texture, itemCount = GetContainerItemInfo(bag, slot);
	if (not itemCount) then
		return false;
	else
		return true;
	end
end

-- placeholder function until I find a way of extracting the current latency
function GetLatency()
	local bandwidthIn, bandwidthOut, latency = GetNetStats();
	return latency / 100;
end

function GetEquipLatency()
	return GetLatency()*2;
end

function SarfMoveItemResetTimeOffset()
	SarfEquip_PrintDebug("time offset reset");
	MOVE_ITEM_TIMEOFFSET = 0;
end

function MoveItemByNameToLastPosition(itemName)
	local itemBag, itemSlot = SarfFindItemByName(itemName);
	local freeBag, freeSlot = FindFreeBagSlot();
	if ( ( ( itemBag == -1 ) and ( itemSlot == -1 ) ) or ( ( freeBag == -1) and (freeSlot == -1) ) ) then
		return;
	end
	if ( freeBag == -1 ) then
		return;
	end
	MoveItem(itemBag, itemSlot, freeBag, freeSlot);
end

function MoveContainerItemByNameToLastPosition(itemName)
	local itemBag, itemSlot = SarfFindItemByName(itemName);
	if ( ( itemBag == -1 ) and ( itemSlot == -1 ) ) then
		return;
	end
	if ( itemBag == -1 ) then
		Cosmos_Schedule(1, MoveContainerItemByNameToLastPosition, itemName);
	end
	local freeBag, freeSlot = FindFreeBagSlot();
	if ( ( ( itemBag == -1 ) and ( itemSlot == -1 ) ) or ( ( freeBag == -1) and (freeSlot == -1) ) ) then
		return;
	end
	if ( freeBag == -1 ) then
		return;
	end
	MoveItem(itemBag, itemSlot, freeBag, freeSlot);
end

function MoveItemByName(itemName, bagDestination, slotDestination, resetTimeOffset)
end

function MoveItem(bagSource, slotSource, bagDestination, slotDestination, resetTimeOffset)
--[[
	if ( not SlotHasItem(bagSource, slotSource) ) then
		SarfEquip_PrintDebug(format("Source location (%d,%d) did not have an item.", bagSource, slotSource));
		return false;
	end
	if ( SlotHasItem(bagDestination, slotDestination) ) then
		SarfEquip_PrintDebug(format("Destination (%d,%d) did have an item occupying it.", bagDestination, slotDestination));
		return false;
	end
]]--
	--SarfEquip_PrintDebug("MoveTo Source : "..bagSource..","..slotSource.."    dest : "..bagDestination..","..slotDestination)
	local cursorItemBag = SARF_INVALID_BAG_SLOT;
	local cursorItemSlot = SARF_INVALID_BAG_SLOT;
	local tempItemBag = SARF_INVALID_BAG_SLOT;
	local tempItemSlot = SARF_INVALID_BAG_SLOT;
	
	if ( ( not MOVE_ITEM_TIMEOFFSET_LOCKED ) or ( ( resetTimeOffset ) and ( resetTimeOffset == 1) ) ) then
		SarfMoveItemResetTimeOffset();
	end
	
	if (CursorHasItem()) then
		if ( GetNumberOfFreeItemSlots() > 1) then
			cursorItemBag, cursorItemSlot = FindFreeBagSlot();
			if ( ( cursorItemBag >= 0) and (cursorItemSlot >= 0) ) then
				MoveItemInCursorTo(cursorItemBag, cursorItemSlot);
				MOVE_ITEM_TIMEOFFSET = MOVE_ITEM_TIMEOFFSET + GetEquipLatency();
			else
				Print("SarfEquip: Could not place find a free space to send cursor item to.");
				return false;
			end
		end
	end
	Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET, SarfPickupItem, bagSource, slotSource);
	MOVE_ITEM_TIMEOFFSET = MOVE_ITEM_TIMEOFFSET + GetEquipLatency();
	Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET, SarfPutdownItem, bagDestination, slotDestination);
	MOVE_ITEM_TIMEOFFSET = MOVE_ITEM_TIMEOFFSET + GetEquipLatency();
	
	if ( (cursorItemBag >= 0) and (cursorItemSlot >= 0) ) then
		if ( SlotHasItem(cursorItemBag, cursorItemSlot) ) then
			Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET, PickupContainerItem, cursorItemBag, cursorItemSlot);
			MOVE_ITEM_TIMEOFFSET = MOVE_ITEM_TIMEOFFSET + GetEquipLatency();
		else
			Print(format("SarfEquip: Cursor item which previously was temporarily stored at (%d, %d) could not be found.", cursorItemBag, cursorItemSlot));
			return false;
		end
	end
	return true;
end

function SarfEquipByBagSlot(equipmentID, bag, slot)
	if ( ( bag > -1 ) or (slot > -1) ) then
		return MoveItem(bag, slot, -1, equipmentID);
	end
end

function SarfEquipByNameAndDestination(equipmentID, name)
	local bag, slot = SarfFindItemByName(name);
	return SarfEquipByBagSlot(equipmentID, bag, slot);
end

function SarfUnequipByID(equipmentID)
	local bag, slot = FindFreeBagSlot();
	return MoveItem(-1, equipmentID, bag, slot);
end

function SarfEquipByName(name)
	Print("SarfEquip: SarfEquipByName not implented yet.");
end

function SarfGetItemName(bag, slot)
	local name = "";
	local strings = nil;
	if ( bag > -1 ) then
		strings = GetItemInfoStrings(bag, slot, "CosmosTooltip");
	else
		local hasItem, hasCooldown = CosmosTooltip:SetInventoryItem("player", slot);
		strings = ScanTooltip("CosmosTooltip");
		if ( not hasItem) then
			if ( strings[1] ) then
				strings[1].left = "";
			end
		end
	end
	if ( strings[1] ) then
		name = strings[1].left;
	end
	return name;
end

function SarfGetWeaponHandRequirement(bag, slot)
	local name = "";
	local strings = nil;
	if ( bag > -1 ) then
		strings = GetItemInfoStrings(bag, slot, "CosmosTooltip");
	else
		local hasItem, hasCooldown = CosmosTooltip:SetInventoryItem("player", slot);
		strings = ScanTooltip("CosmosTooltip");
		if ( not hasItem) then
			if ( strings[1] ) then
				strings[1].left = "";
			end
		end
	end
	if ( strings[2] ) then
		local str = strings[2].left;
		if ( str == "Soulbound" ) then
			str = strings[3].left;
		end
		if ( str == "Main Hand" ) then 
			return 1;
		end
		if ( str == "Off Hand" ) then 
			return 2;
		end
		if ( str == "Two-Hand" ) then 
			return 3;
		end
		if ( str == "Two Hand" ) then 
			return 3;
		end
	end
	return -1;
end

function SarfGetEquipmentNumSlots()
	return 20;
end

function SarfFindItemByNameInBags(name, allowedMatches)
	if ( (not name) or (strlen(name) <= 0) ) then
		return -1, -1;
	end
	if (not allowedMatches) then
		allowedMatches = 1;
	end
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			if ( name == SarfGetItemName(bag, slot) ) then
				if ( allowedMatches <= 1 ) then
					return bag, slot;
				else
					allowedMatches = allowedMatches - 1;
				end
			end
		end
	end
	return -1, -1;
end

function SarfFindItemByNameInEquipment(name, allowedMatches)
	if ( (not name) or (strlen(name) <= 0) ) then
		return -1, -1;
	end
	if (not allowedMatches) then
		allowedMatches = 1;
	end
	for slot = 1, SarfGetEquipmentNumSlots() do
		if ( name == SarfGetItemName(-1, slot) ) then
			if ( allowedMatches <= 1 ) then
				return -1, slot;
			else
				allowedMatches = allowedMatches - 1;
			end
		end
	end
	return -1, -1;
end

function SarfFindItemByName(name, prioritizeEquippedItems, allowedMatches)
	if ( (not name) or (strlen(name) <= 0) ) then
		return -1, -1;
	end
	local bag, slot;
	if ( not prioritizeEquippedItems ) then
		bag, slot = SarfFindItemByNameInBags(name, allowedMatches);
	else
		bag, slot = SarfFindItemByNameInEquipment(name, allowedMatches);
	end

	if ( ( bag == -1 ) and ( slot == -1 ) ) then
		if ( not prioritizeEquippedItems ) then
			bag, slot = SarfFindItemByNameInEquipment(name, allowedMatches);
		else
			bag, slot = SarfFindItemByNameInBags(name, allowedMatches);
		end
	end

	return bag, slot;
end

function SarfWieldoffHandWeapon(bagOff, slotOff)
	if ( ( bagOff > -1 ) or ( ( slotOff ~= 17 ) and ( slotOff > -1 ) ) ) then
		MoveItem(bagOff, slotOff, -1, 17);
	end
end

function SarfWieldWeapons(mainweapon, offweapon)
	if ( mainweapon == nil ) then
		mainweapon = "";
	end
	if ( offweapon == nil ) then
		offweapon = "";
	end
	local mainHandWeapon = SarfGetItemName(-1, 16);
	local offHandWeapon = SarfGetItemName(-1, 17);
	local bagMain, slotMain = SarfFindItemByName(mainweapon, nil);
	local bagOff, slotOff = SarfFindItemByName(offweapon, nil);
	if ( ( bagMain == bagOff ) and ( slotMain == slotOff ) ) then
		bagOff, slotOff = SarfFindItemByName(offweapon, nil, 2);
	end

	SarfEquip_PrintDebug(format("main item found at : %d, %d", bagMain, slotMain));
	SarfEquip_PrintDebug(format("off item found at : %d, %d", bagOff, slotOff));
	
	if ( ( mainHandWeapon == mainweapon) and ( offHandWeapon == offweapon ) ) then
		return true;
	end
	if (mainHandWeapon == offweapon) and ( offHandWeapon == mainweapon) then
		SarfEquip_PrintDebug("exchanging weapons");
		MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
		if ( ( strlen(mainHandWeapon) > 0 ) and ( strlen(offHandWeapon) > 0 ) ) then
			return MoveItem(-1, 16, -1, 17);
		else
			if ( strlen(mainHandWeapon) > 0 ) then
				return MoveItem(-1, 16, -1, 17);
			else
				return MoveItem(-1, 17, -1, 16);
			end
		end
	end
	
	local moveOrder = 0;
	
	if ( offHandWeapon ~= offweapon ) then
		-- if we replace main weapon with a two-handed weapon
		if ( SarfGetWeaponHandRequirement(bagMain, slotMain) == 3 ) then
			if ( ( offHandWeapon ) and ( strlen(offHandWeapon) > 0 ) ) then
				--Print("Scheduled for packification.");
				Cosmos_ScheduleByName("SarfWieldWeapons_MoveAwayStuff", GetEquipLatency()*8, MoveContainerItemByNameToLastPosition, offHandWeapon);
			end
		end
	end
	
	MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
	if ( ( mainHandWeapon ~= mainweapon ) ) then
		if ( ( mainHandWeapon ) and ( strlen(mainHandWeapon) > 0 ) ) then
			-- we can't use the off-hand switching because some main hand weapons can't be placed in the off hand
			SarfEquip_PrintDebug("unequipping main hand weapon");
			if ( not SarfUnequipByID(16) ) then
				SarfEquip_PrintDebug("could not unequip main hand weapon");
				MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
				return false;
			end
			MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
			Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET+GetEquipLatency(), SarfWieldWeapons, mainweapon, offweapon);
			return true;
		end
		if ( ( mainweapon ) and ( strlen(mainweapon) > 0 ) ) then
			if ( ( bagMain == SARF_EQUIPMENT_BAG_SLOT ) and ( slotMain == 16) ) then
				SarfEquip_PrintDebug("main hand weapon was already equipped");
			else
				SarfEquip_PrintDebug("equipping main hand weapon");
				MoveItem(bagMain, slotMain, SARF_EQUIPMENT_BAG_SLOT, 16);
				MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
				Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET+GetEquipLatency(), SarfWieldWeapons, mainweapon, offweapon);
				return true;
			end
		end
	end

	if ( ( offHandWeapon ~= offweapon ) ) then
		if ( ( offHandWeapon ) and ( strlen(offHandWeapon) > 0 ) ) then
			if ( mainweapon == offHandWeapon ) then
				SarfEquip_PrintDebug("switching off hand weapon to main hand position");
				if ( not MoveItem(SARF_EQUIPMENT_BAG_SLOT, 17, SARF_EQUIPMENT_BAG_SLOT, 16) ) then
					SarfEquip_PrintDebug("could not switch off hand weapon to main hand position");
					return false;
				end
			else
				SarfEquip_PrintDebug("unequipping off hand weapon");
				if ( not SarfUnequipByID(17) ) then
					SarfEquip_PrintDebug("could not unequip off hand weapon");
					MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
					return false;
				end
			end
			MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
			Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET+GetEquipLatency(), SarfWieldWeapons, mainweapon, offweapon);
			return true;
		end
		if ( ( offweapon ) and ( strlen(offweapon) > 0 ) ) then
			if ( ( bagoff == -1 ) and ( slotoff == 17) ) then
				SarfEquip_PrintDebug("off hand weapon was already equipped");
			else
				SarfEquip_PrintDebug("equipping off hand weapon");
				if (not MoveItem(bagOff, slotOff, -1, 17) ) then
					SarfEquip_PrintDebug(format("could not equip off hand weapon [%s]", offweapon));
					MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
					return false;
				else
					MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
					Cosmos_Schedule(MOVE_ITEM_TIMEOFFSET+GetEquipLatency(), SarfWieldWeapons, mainweapon, offweapon);
					return true;
				end
			end
		end
	end

	MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
	SarfMoveItemResetTimeOffset();
	return true;
end

function SarfEquip_PrintDebug(msg)
	--Print("SarfEquip: "..msg);
end


function oldstuff(mainweapon, offweapon)
	if ( mainHandWeapon ~= mainweapon ) then
		if ( strlen(mainHandWeapon) > 0) then
			SarfUnequipByID(16);
			MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
		end
		MoveItem(bagMain, slotMain, -1, 16);
		MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
	end
	if (offHandWeapon ~= offweapon ) then
		if ( strlen(offHandWeapon) > 0) then
			SarfUnequipByID(17);
			MOVE_ITEM_TIMEOFFSET_LOCKED = 1;
		end
		if ( strlen(offweapon) > 0 ) then
			if ( ( mainweapon == offweapon ) and ( mainHandWeapon == mainweapon ) ) then
				MoveItem(bagMain, slotMain, -1, 17);
			else
				MoveItem(bagOff, slotOff, -1, 17);
			end
			MOVE_ITEM_TIMEOFFSET_LOCKED = nil;
		end
		return true;
	end
	return true;
	
end

function SarfEquip_OnLoad()

end
