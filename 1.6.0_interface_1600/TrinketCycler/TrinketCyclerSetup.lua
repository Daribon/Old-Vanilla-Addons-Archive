TRINKET_CYCLER_ALL_TRINKETS = "AllTrinkets";
TRINKET_CYCLER_FIRST_TRINKET = "Trinket0";
TRINKET_CYCLER_SECOND_TRINKET = "Trinket1";

TRINKET_CYCLER_TRINKET_INDICES = {
	TRINKET_CYCLER_ALL_TRINKETS, 
	TRINKET_CYCLER_FIRST_TRINKET, 
	TRINKET_CYCLER_SECOND_TRINKET
};

TRINKETCYCLER_NUMBER_OF_TRINKETS_IN_LIST = 8;

TRINKET_CYCLER_ALL_INDEX = -1;
TRINKET_CYCLER_FIRST_TRINKET_INDEX = 14;
TRINKET_CYCLER_SECOND_TRINKET_INDEX = 15;

TrinketCycler_TrinketsList = {};
TrinketCycler_TrinketIndexList = {
	{ slotName = "Trinket0Slot", globalName = "TRINKET_CYCLER_FIRST_TRINKET_INDEX" },
	{ slotName = "Trinket1Slot", globalName = "TRINKET_CYCLER_SECOND_TRINKET_INDEX" },
};

TrinketCycler_Saved_PickupContainerItem = PickupContainerItem;
TrinketCycler_Saved_PickupInventoryItem = PickupInventoryItem;

UIPanelWindows["TrinketCyclerSetupFrame"] = { area = "left", pushable = 5 }; 

--[[

TrinketList entry spec
	[index] = {
		index = 1, -- current index
		list = {} -- list of entry entries :)
	}
	

TrinketList entry entry spec
	{ 
		itemName = "", -- item name,
		texture = "" -- item texture
	} 

]]--

function TrinketCyclerSetup_DrawList(entries, entryFormat)
	local obj = nil;
	local objTexture = nil;
	local index = 1;
	for k, v in entries do
		obj = getglobal(string.format(entryFormat, index));
		objTexture = getglobal(string.format(entryFormat.."IconTexture", index));
		if ( obj ) and ( objTexture ) then
			if ( strlen(obj.name) > 0 ) then
				obj.name = v.itemName;
				obj.texture = v.texture;
				objTexture:SetTexture(v.texture);
				index = index + 1;
			end
		else
			break;
		end
	end
	for hideIndex = index, TRINKETCYCLER_NUMBER_OF_TRINKETS_IN_LIST do
		obj = getglobal(string.format(entryFormat, hideIndex));
		objTexture = getglobal(string.format(entryFormat.."IconTexture", hideIndex));
		if ( obj ) and ( objTexture ) then
			obj.name = nil;
			obj.texture = nil;
			objTexture:SetTexture(nil);
		end
	end
end

function TrinketCyclerSetup_GenerateList(entryFormat)
	local entries = {};
	local obj = nil;
	local entry = nil;
	for index = 1, TRINKETCYCLER_NUMBER_OF_TRINKETS_IN_LIST do
		obj = getglobal(string.format(entryFormat, index));
		if ( obj ) and ( objTexture ) then
			entry = {};
			entry.itemName = obj.name;
			entry.texture = obj.texture;
			if ( entry.texture ) and ( entry.itemName ) and ( strlen(entry.itemName) > 0 ) then
				table.insert(entries, entry);
			end
		end
	end
	return entries;
end


function TrinketCyclerSetup_InitializeList()
	TrinketCycler_TrinketsList = {
		[TRINKET_CYCLER_ALL_INDEX] = {
			index = 1,
			list = {}
		},
		[TRINKET_CYCLER_FIRST_TRINKET_INDEX] = {
			index = 1,
			list = {}
		},
		[TRINKET_CYCLER_SECOND_TRINKET_INDEX] = {
			index = 1,
			list = {}
		},
	};
end


function TrinketCyclerSetup_OnLoad()
	RegisterForSave("TrinketCycler_TrinketsList");
	this:RegisterEvent("VARIABLES_LOADED");
	
	local slotIndex = 0;
	for k, v in TrinketCycler_TrinketIndexList do
		slotIndex = GetInventorySlotInfo(v.slotName);
		setglobal(v.globalName, slotIndex);
	end
	TrinketCyclerSetup_InitializeList();
end

function TrinketCyclerSetup_OnVariablesLoaded()
	if ( TrinketCyclerSetupFrame:IsVisible() ) then
		TrinketCyclerSetupFrame_OnUpdate();
	end
end

function TrinketCyclerSetup_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		TrinketCyclerSetup_OnVariablesLoaded();
		return;
	end
end

function TrinketCyclerSetup_GetTrinketIndex(trinket)
	if ( not trinket ) then trinket = TRINKET_CYCLER_ALL_TRINKETS; end
	local index = TRINKET_CYCLER_ALL_INDEX;
	if ( trinket == TRINKET_CYCLER_FIRST_TRINKET ) or ( trinket == TRINKET_CYCLER_FIRST_TRINKET_INDEX ) then
		index = TRINKET_CYCLER_FIRST_TRINKET_INDEX;
	end
	if ( trinket == TRINKET_CYCLER_SECOND_TRINKET ) or ( trinket == TRINKET_CYCLER_SECOND_TRINKET_INDEX ) then
		index = TRINKET_CYCLER_SECOND_TRINKET_INDEX;
	end
	return index;
end

function TrinketCyclerSetup_ResetTrinketIndex(trinket)
	local index = TrinketCyclerSetup_GetTrinketIndex(trinket);
	TrinketCycler_TrinketsList[index].index = 1;
end

function TrinketCyclerSetup_GetNextTrinket(trinket)
	local index = TrinketCyclerSetup_GetTrinketIndex(trinket);
	local curIndex = TrinketCycler_TrinketsList[index].index;
	if ( curIndex < table.getn(TrinketCycler_TrinketsList[index].list) ) then
		curIndex = curIndex + 1;
	else
		curIndex = 1;
	end
	local str = TrinketCycler_TrinketsList[curIndex].list[curIndex].itemName;
	if ( str ) then
		TrinketCycler_TrinketsList[index].index = curIndex;
	else
		str = "";
	end
	return str;
end

function TrinketCyclerSetup_OnUpdate()
	for k, v in TRINKET_CYCLER_TRINKET_INDICES do
		TrinketCyclerSetup_RegenerateList(v)
	end
end

function TrinketCyclerSetup_OnShow()
	PlaySound("PickupLargeChain");
end

function TrinketCyclerSetup_OnHide()
	PlaySound("PutDownLargeChain");
end

function TrinketCyclerSlot_SetData(name, texture)
	local objTexture = getglobal(this:GetName().."IconTexture");
	if ( objTexture ) then
		this.name = name;
		this.texture = texture;
		objTexture:SetTexture(texture);
	else
		this.name = nil;
		this.texture = nil;
	end
	TrinketCyclerSlot_RegenerateList();
end

function TrinketCycler_TakeItemOffCursor(bag, slot)
	if ( not bag ) then	return; end
	if ( bag <= -1 ) then
		TrinketCycler_Saved_PickupInventoryItem(slot);
	else
		TrinketCycler_Saved_PickupContainerItem(bag, slot);
	end
end

function TrinketCyclerSlot_OnClick(button)
	if ( button ) and ( button == "RightButton" ) then
		TrinketCyclerSlot_ClearSlot();
	else
		if ( CursorHasItem() ) and ( TrinketCycler_PickedupItem ) then
			if CursorCanGoInSlot(TRINKET_CYCLER_FIRST_TRINKET_INDEX) then
				local itemInfo = DynamicData.item.getInventoryInfo(TrinketCycler_PickedupItem.bag, 
					TrinketCycler_PickedupItem.slot);
				if ( itemInfo.name ) and ( strlen(itemInfo.name) > 0 ) then
					TrinketCyclerSlot_SetData(itemInfo.name, itemInfo.texture);
				end
			end
			ResetCursor();
			TrinketCycler_TakeItemOffCursor(TrinketCycler_PickedupItem.bag, TrinketCycler_PickedupItem.slot);
			TrinketCycler_PickedupItem = nil;
		end
	end
end

function TrinketCyclerSlot_OnDragStart()
	TrinketCyclerSlot_ClearSlot();
end

function TrinketCyclerSlot_GetTooltip()
	return getglobal("GameTooltip");
end

function TrinketCyclerSlot_GetEntryListIndex()
	local name = this:GetName();
	if ( strfind(name, TRINKET_CYCLER_FIRST_TRINKET) ) then
		return TRINKET_CYCLER_FIRST_TRINKET_INDEX;
	elseif ( strfind(name, TRINKET_CYCLER_SECOND_TRINKET) ) then
		return TRINKET_CYCLER_FIRST_SECOND_INDEX;
	else
		return TRINKET_CYCLER_ALL_INDEX;
	end
end

function TrinketCyclerSlot_RegenerateList()
	local index = TrinketCyclerSlot_GetEntryListIndex();
	TrinketCyclerSetup_RegenerateList(index);
end

function TrinketCyclerSetup_RegenerateList(index)
	local formatStr = "TrinketCyclerSetupFrame"..index.."ListEntry%d";
	local entryList = TrinketCyclerSetup_GenerateList(formatStr);
	TrinketCyclerSetup_DrawList(entryList, formatStr);
	local index = TrinketCyclerSlot_GetEntryListIndex();
	TrinketCycler_TrinketsList[index].list = entryList;
	local size = table.getn(entryList);
	if ( TrinketCycler_TrinketsList[index].index > size ) then
		TrinketCycler_TrinketsList[index].index = size;
	end
end

function TrinketCyclerSlot_ClearSlot()
	this.name = nil;
	this.texture = nil;
	TrinketCyclerSlot_RegenerateList();
end

function TrinketCyclerSlot_OnEnter()
	local obj = getglobal(this:GetName().."Name");
	if ( obj ) then
		local str = obj:GetText();
		local itemInfo = DynamicData.item.getItemInfoByName(str);
		if ( itemInfo ) and ( itemInfo.name ) and ( strlen(itemInfo.name) > 0 ) then
			if ( itemInfo.position ) and ( table.getn(itemInfo.position) > 0 ) then
				local tooltip = TrinketCyclerSlot_GetTooltip();
				tooltip:SetOwner(this, "ANCHOR_RIGHT");
				tooltip:SetContainerItem(itemInfo.position[1].bag, itemInfo.position[1].slot);
			end
		end
	end
end

function TrinketCyclerSlot_OnLeave()
	local tooltip = TrinketCyclerSlot_GetTooltip();
	if ( tooltip:IsOwned(this) ) then
		tooltip:Hide();
	end
end

PickupContainerItem = function (bag,slot)
	TrinketCycler_PickedupItem = { };
	TrinketCycler_PickedupItem.bag = bag;
	TrinketCycler_PickedupItem.slot = slot;
	return TrinketCycler_Saved_PickupContainerItem(bag,slot);
end

PickupInventoryItem = function (slot)
	TrinketCycler_PickedupItem = { };
	TrinketCycler_PickedupItem.bag = -1;
	TrinketCycler_PickedupItem.slot = slot;
	return TrinketCycler_Saved_PickupInventoryItem(slot);
end

