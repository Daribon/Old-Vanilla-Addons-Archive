--[[
	LootDestroyer

	By sarf

	This mod allows loot to be automatically destroyed.
	Looting (and destroying) by both left- and right-clicking is allowed.
	The loot that should be destroyed must be specified by the user
	(by shift-rightclicking it in the LootFrame).
	
	It destroys the item by picking up the last item it encounters in 
	your inventory that matches the unwanted item name.
	
	OBSERVE! NOTE! OBSERVERA! ACHTUNG!

	Note that it can now try to preserve the number of items that you currently 
	possess when you mark the item as unwanted. You have to enable this as an option.



	Thanks go to Mugendai for his code, which remains an inspiration for me.
	Thanks also goes to Bayta (on the official WoW community boards), who came up with the idea, 
	as well as karconn (Bayta's nick on the CosmosUI.org forums) for providing much valued feedback.
	
	Credits for the ultra-nice unwanted item texture goes to myself. I suck at drawing things, by the way, 
	so if you want your name here, send me your creation and I'll probably use it instead.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=257
	
	Bayta's Thread URL:
+	http://www.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=7202
	
	Changes
	0.54.V
		Autosave feature added (cosmos checkbox added but not working?)
			Added slashcommands for non-cosmos (/ldautosave) and for cosmos functionality.  The slashcommands seem to work fine.
		Fixed destroying item when it was marked then unmarked for destruction.
		Changed from a full inventory check to storing data locally and only updating bag data as it changes.
			This requires storing slightly more information locally, but will be minimal increase in memory usage.
			Also adds an extra single bag check every 10th run to consistantly verify data is maintained.
		Items will no longer be deleted multiple times.  There is a 0.5 second time limit before it can be destroyed again.
		Items can destroy a stack of itself (instead of 1 at a time) depending on the if preservation is on and the total count of an item vs the count of that single stack, etc.

		Todo: Detect if a bag changes(mainly for new slots).  Force a complete reinitialization of bag data if this happens?
   ]]
   

-- Constants
LOOTDESTROYER_MAX_NUMBER_OF_BAGS = 4; -- add one because it starts at zero

LOOTDESTROYER_UNWANTED_ITEM_TEXTURE = "Interface\\AddOns\\LootDestroyer\\Skin\\Icons\\UnwantedItem-Icon";
LOOTDESTROYER_UNWANTED_ITEM_TEXTURE_WOW = "Interface\\Icons\\Spell_Shadow_SacrificalShield";
LOOTDESTROYER_AUTOSAVEITEMLISTNAME = "AutoSavedItemList"

LOOTDESTROYER_BAGDATA_CHECKBAGCOUNTMAX = 10;	-- How often to do a scan of alternate bags to verify data

-- Variables
LootDestroyer_RecentUnwantedItems = {};
LootDestroyer_Saved_LootFrameItem_OnClick = nil;
LootDestroyer_Saved_ContainerFrameItemButton_OnClick = nil;
LootDestroyer_Saved_LootFrame_Update = nil;
LootDestroyer_UnwantedItems = {};
LootDestroyer_PreserveItemCount = {};

LootDestroyer_ShouldPreserveItemCount = 0;
LootDestroyer_CosmosRegistered = 0;
LootDestroyer_DebugPrint_Enabled = false;

-- contains the saved icons (not that it might be needed, but I try to err on the side of caution)
LootDestroyer_SavedIconTexture = {};


-- Variables that the user is supposed to be able to affect
LootDestroyer_Enabled = 0;
LootDestroyer_Preserve_Enabled = 0;
LootDestroyer_Destroy_Messages_Enabled = 0;					-- should "item XYZ has been destroyed" messages be shown?
LootDestroyer_Autosave_Enabled = 1;

-- Create toggles for these
LootDestroyer_OverloadLootUpdate_Enabled = 1;				-- if the LootFrame_Update() should be overloaded at all, needed to change the look of the icons
LootDestroyer_Display_Unwanted_Use_Quantity_Enabled = 0;	-- less easy to see, less CPU used
LootDestroyer_Display_Unwanted_Use_Texture_Enabled = 1;		-- easier to see, might cause some CPU problems, might cause interference problems

LootDestroyer_ItemList = {};
LootDestroyer_VariablesInitialized = false;

-- Variables to store bag data locally
LootDestroyer_BagData_ItemName = {};
LootDestroyer_BagData_ItemCount = {};
LootDestroyer_BagData_Initialized = false;
LootDestroyer_BagData_CheckBag = 0;
LootDestroyer_BagData_CheckBagCounter = 1;

function LootDestroyer_OnLoad()
	LootDestroyer_Register();
end

function LootDestroyer_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( LootDestroyer_CosmosRegistered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_LOOTDESTROYER",
			"SECTION",
			TEXT(LOOTDESTROYER_CONFIG_HEADER),
			TEXT(LOOTDESTROYER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTDESTROYER_HEADER",
			"SEPARATOR",
			TEXT(LOOTDESTROYER_CONFIG_HEADER),
			TEXT(LOOTDESTROYER_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTDESTROYER_ENABLED",
			"CHECKBOX",
			TEXT(LOOTDESTROYER_ENABLED),
			TEXT(LOOTDESTROYER_ENABLED_INFO),
			LootDestroyer_Toggle_Enabled,
			LootDestroyer_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTDESTROYER_PRESERVE_ENABLED",
			"CHECKBOX",
			TEXT(LOOTDESTROYER_PRESERVE_ENABLED),
			TEXT(LOOTDESTROYER_PRESERVE_ENABLED_INFO),
			LootDestroyer_Preserve_Toggle_Enabled,
			LootDestroyer_Preserve_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTDESTROYER_DESTROY_MESSAGES_ENABLED",
			"CHECKBOX",
			TEXT(LOOTDESTROYER_DESTROY_MESSAGES_ENABLED),
			TEXT(LOOTDESTROYER_DESTROY_MESSAGES_ENABLED_INFO),
			LootDestroyer_Destroy_Messages_Toggle_Enabled,
			LootDestroyer_Destroy_Messages_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_LOOTDESTROYER_AUTOSAVE_ENABLED",
			"CHECKBOX",
			TEXT(LOOTDESTROYER_AUTOSAVE_ENABLED),
			TEXT(LOOTDESTROYER_AUTOSAVE_ENABLED_INFO),
			LootDestroyer_Autosave_Toggle_Enabled,
			LootDestroyer_Autosave_Enabled
		);
		LootDestroyer_CosmosRegistered = 1;
	end
end


function LootDestroyer_Register()
	if ( Cosmos_RegisterConfiguration ) then
		LootDestroyer_Register_Cosmos();
	else
		SlashCmdList["LOOTDESTROYERSLASHENABLE"] = LootDestroyer_Enable_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHENABLE1 = "/lootdestroyerenable";
		SLASH_LOOTDESTROYERSLASHENABLE2 = "/ldenable";
		SLASH_LOOTDESTROYERSLASHENABLE3 = "/lootdestroyerdisable";
		SLASH_LOOTDESTROYERSLASHENABLE4 = "/lddisable";
		SlashCmdList["LOOTDESTROYERSLASHCLEAR"] = LootDestroyer_Clear_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHCLEAR1 = "/lootdestroyerclear";
		SLASH_LOOTDESTROYERSLASHCLEAR2 = "/ldclear";
		SlashCmdList["LOOTDESTROYERSLASHSHOW"] = LootDestroyer_List_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHSHOW1 = "/lootdestroyershow";
		SLASH_LOOTDESTROYERSLASHSHOW2 = "/ldshow";
		SLASH_LOOTDESTROYERSLASHSHOW3 = "/lootdestroyerlist";
		SLASH_LOOTDESTROYERSLASHSHOW4 = "/ldlist";
		SlashCmdList["LOOTDESTROYERSLASHTOGGLE"] = LootDestroyer_Toggle_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHTOGGLE1 = "/lootdestroyertoggle";
		SLASH_LOOTDESTROYERSLASHTOGGLE2 = "/ldtoggle";
		SLASH_LOOTDESTROYERSLASHTOGGLE3 = "/lootdestroyeradd";
		SLASH_LOOTDESTROYERSLASHTOGGLE4 = "/ldadd";
		SLASH_LOOTDESTROYERSLASHTOGGLE5 = "/lootdestroyerremove";
		SLASH_LOOTDESTROYERSLASHTOGGLE6 = "/ldremove";
		SlashCmdList["LOOTDESTROYERSLASHPRESERVEDTOGGLE"] = LootDestroyer_Preserve_Toggle_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHPRESERVEDTOGGLE1 = "/lootdestroyerpreservetoggle";
		SLASH_LOOTDESTROYERSLASHPRESERVEDTOGGLE2 = "/ldpreservetoggle";
		SLASH_LOOTDESTROYERSLASHPRESERVEDTOGGLE3 = "/ldptoggle";
		SLASH_LOOTDESTROYERSLASHPRESERVEDTOGGLE4 = "/ldpt";
		SlashCmdList["LOOTDESTROYERSLASHLOADITEMLIST"] = LootDestroyer_Load_ItemList_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST1 = "/lootdestroyerloaditemlist";
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST2 = "/lootdestroyerloaditems";
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST3 = "/ldloaditemlist";
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST4 = "/ldlitemlist";
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST5 = "/ldloaditemlist";
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST6 = "/ldloaditems";
		SLASH_LOOTDESTROYERSLASHLOADITEMLIST7 = "/ldload";
		SlashCmdList["LOOTDESTROYERSLASHSAVEITEMLIST"] = LootDestroyer_Save_ItemList_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST1 = "/lootdestroyersaveitemlist";
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST2 = "/lootdestroyersaveitems";
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST3 = "/ldsaveitemlist";
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST4 = "/ldlitemlist";
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST5 = "/ldsaveitemlist";
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST6 = "/ldsaveitems";
		SLASH_LOOTDESTROYERSLASHSAVEITEMLIST7 = "/ldsave";
		SlashCmdList["LOOTDESTROYERSLASHSHOWITEMLIST"] = LootDestroyer_Show_ItemList_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHSHOWITEMLIST1 = "/lootdestroyershowitemlist";
		SLASH_LOOTDESTROYERSLASHSHOWITEMLIST2 = "/ldshowitemlist";
		SLASH_LOOTDESTROYERSLASHSHOWITEMLIST3 = "/ldshowil";
		SlashCmdList["LOOTDESTROYERSLASHDESTROYMESSAGES"] = LootDestroyer_Destroy_Messages_Toggle_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES1 = "/lootdestroyertoggledestroymessages";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES2 = "/lootdestroyerdestroymessages";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES3 = "/lootdestroyertoggledmessages";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES4 = "/lootdestroyertoggledm";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES5 = "/ldtoggledestroymessages";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES6 = "/lddestroymessages";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES7 = "/ldtoggledmessages";
		SLASH_LOOTDESTROYERSLASHDESTROYMESSAGES8 = "/ldtoggledm";
		SlashCmdList["LOOTDESTROYERSLASHAUTOSAVE"] = LootDestroyer_Autosave_ChatCommandHandler;
		SLASH_LOOTDESTROYERSLASHAUTOSAVE1 = "/lootdestroyerautosave";
		SLASH_LOOTDESTROYERSLASHAUTOSAVE2 = "/ldautosave";
	end
	if ( Cosmos_RegisterChatCommand ) then
		local LootDestroyerEnableCommands = {"/lootdestroyerenable","/ldenable","/lootdestroyerdisable","/lddisable"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_ENABLE_COMMANDS", -- Some Unique Group ID
			LootDestroyerEnableCommands, -- The Commands
			LootDestroyer_Enable_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
		local LootDestroyerClearCommands = {"/lootdestroyerclear","/ldclear"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_CLEAR_COMMANDS", -- Some Unique Group ID
			LootDestroyerClearCommands, -- The Commands
			LootDestroyer_Clear_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_CLEAR_INFO -- Description String
		);
		local LootDestroyerListCommands = {"/lootdestroyershow","/ldshow","/lootdestroyerlist","/ldlist"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_LIST_COMMANDS", -- Some Unique Group ID
			LootDestroyerListCommands, -- The Commands
			LootDestroyer_List_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_LIST_INFO -- Description String
		);
		local LootDestroyerToggleCommands = {"/lootdestroyertoggle","/ldtoggle","/lootdestroyeradd","/ldadd","/lootdestroyerremove","/ldremove"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_TOGGLE_COMMANDS", -- Some Unique Group ID
			LootDestroyerToggleCommands, -- The Commands
			LootDestroyer_Toggle_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_TOGGLE_INFO -- Description String
		);
		local LootDestroyerPreserveToggleCommands = {"/lootdestroyerpreservetoggle","/ldpreservetoggle","/ldptoggle"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_PRESERVE_TOGGLE_COMMANDS", -- Some Unique Group ID
			LootDestroyerPreserveToggleCommands, -- The Commands
			LootDestroyer_Preserve_Toggle_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_PRESERVE_TOGGLE_INFO -- Description String
		);
		local LootDestroyerLoadItemListCommands = {"/lootdestroyerloaditemlist","/lootdestroyerloaditems","/lootdestroyerloadlist","/ldloaditemlist","/ldloaditems","/ldloadlist","/ldll","/ldl"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_LOAD_ITEMLIST_COMMANDS", -- Some Unique Group ID
			LootDestroyerLoadItemListCommands, -- The Commands
			LootDestroyer_Load_ItemList_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_LOAD_ITEMLIST_INFO -- Description String
		);
		local LootDestroyerSaveItemListCommands = {"/lootdestroyersaveitemlist","/lootdestroyersaveitems","/lootdestroyersavelist","/ldsaveitemlist","/ldsaveitems","/ldsavelist","/ldsave","/ldsl","/lds"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_SAVE_ITEMLIST_COMMANDS", -- Some Unique Group ID
			LootDestroyerSaveItemListCommands, -- The Commands
			LootDestroyer_Save_ItemList_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_SAVE_ITEMLIST_INFO -- Description String
		);
		local LootDestroyerShowItemListCommands = {"/lootdestroyershowitemlist","/ldshowitemlist","/ldshowil"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_SHOW_ITEMLIST_COMMANDS", -- Some Unique Group ID
			LootDestroyerShowItemListCommands, -- The Commands
			LootDestroyer_Show_ItemList_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_SHOW_ITEMLIST_INFO -- Description String
		);
		local LootDestroyerDestroyMessagesCommands = {"/lootdestroyertoggledestroymessages","/lootdestroyerdestroymessages","/lootdestroyertoggledmessages","/lootdestroyertoggledm","/ldtoggledestroymessages","/lddestroymessages","/ldtoggledmessages","/ldtoggledm"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_DESTROYMESSAGES_COMMANDS", -- Some Unique Group ID
			LootDestroyerDestroyMessagesCommands, -- The Commands
			LootDestroyer_Destroy_Messages_Toggle_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMAND_DESTROYMESSAGES_INFO -- Description String
		);
		local LootDestroyerAutosaveCommands = {"/lootdestroyerautosave","/ldautosave"};
		Cosmos_RegisterChatCommand (
			"LOOTDESTROYER_AUTOSAVE_COMMANDS",
			LootDestroyerAutosaveCommands,
			LootDestroyer_Autosave_Toggle_ChatCommandHandler,
			LOOTDESTROYER_CHAT_COMMMAND_AUTOSAVE_INFO
		);
	end

	--this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("VARIABLES_LOADED");
	
	--this:RegisterEvent("BAG_UPDATE");
	DynamicData.item.addOnInventoryUpdateHandler(LootDestroyer_OnInventoryUpdate);
end

function LootDestroyer_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		LootDestroyer_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			LootDestroyer_Toggle_Enabled(0);
		else
			LootDestroyer_Toggle_Enabled(-1);
		end
	end
end

function LootDestroyer_LoadItemList(itemList, silent)
	if ( LootDestroyer_VariablesInitialized ) then
		if ( LootDestroyer_ItemList[itemList] ) then
			local tmpItemList = LootDestroyer_ItemList[itemList];
			local tmpItemCount = tmpItemList["PreserveItemCount"];
			for k, v in tmpItemList["UnwantedItemNames"] do
				LootDestroyer_AddToUnwantedItemList(v);
				LootDestroyer_PreserveItemCount[v] = tmpItemCount[v];
			end
			if ( silent ~= 1 ) then
				LootDestroyer_Print(format(LOOTDESTROYER_CHAT_LOAD_ITEMLIST, itemList));
			end
		else
			if ( silent ~= 1 ) then
				LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEMLIST_NOT_FOUND, itemList));
			end
		end
	else
		if ( silent ~= 1 ) then
			LootDestroyer_Print(LOOTDESTROYER_CHAT_ITEMLIST_VARIABLES_NOT_INITIALIZED);
		end
	end
end

function LootDestroyer_SaveItemList(itemList, silent)
	if ( LootDestroyer_VariablesInitialized ) then
		local tmpItemList = {};
		local tmpItemCount = {};
		for k, v in LootDestroyer_UnwantedItems do
			table.insert(tmpItemList, v);
			tmpItemCount[v] = LootDestroyer_PreserveItemCount[v];
		end
		if (getn(tmpItemList) <= 0) then
			LootDestroyer_ItemList[itemList] = null;
			LootDestroyer_Print(format(LOOTDESTROYER_CHAT_DELETE_ITEMLIST, itemList));
		else
			LootDestroyer_ItemList[itemList] = {["UnwantedItemNames"] = tmpItemList, ["PreserveItemCount"] = tmpItemCount };
			if ( silent == 0 ) then
				LootDestroyer_Print(format(LOOTDESTROYER_CHAT_SAVE_ITEMLIST, itemList));
			end
		end
		RegisterForSave("LootDestroyer_ItemList");
	else
		LootDestroyer_Print(LOOTDESTROYER_CHAT_ITEMLIST_VARIABLES_NOT_INITIALIZED);
	end
end

function LootDestroyer_PrintGenericItemList(unwantedItemNamesList, preserveItemCountList, doNotShowPreserve)
	for k, v in unwantedItemNamesList do
		if ( not doNotShowPreserve ) or ( doNotShowPreserve == 0) then
			LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEMENTRY_PRESERVETEXT, v, preserveItemCountList[v]));
		else
			LootDestroyer_Print(v);
		end
	end
end

function LootDestroyer_PrintItemList(itemList)
	if ( LootDestroyer_VariablesInitialized ) then
		if ( LootDestroyer_ItemList[itemList] ) then
			local tmpList = LootDestroyer_ItemList[itemList];
			local tmpItemCount = tmpList["PreserveItemCount"];
			LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEMLIST, itemList));
			LootDestroyer_PrintGenericItemList(tmpList["UnwantedItemNames"], tmpList["PreserveItemCount"]);
		else
			LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEMLIST_NOT_FOUND, itemList));
		end
	else
		LootDestroyer_Print(LOOTDESTROYER_CHAT_ITEMLIST_VARIABLES_NOT_INITIALIZED);
	end
end

function LootDestroyer_ShowItemList(itemList)
	if ( LootDestroyer_VariablesInitialized ) then
		if ( LootDestroyer_ItemList[itemList] ) then
			LootDestroyer_PrintItemList(itemList);
		else
			if ( (itemList) and (strlen(itemList) > 0) ) then
				LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEMLIST_NOT_FOUND, itemList));
			end
			LootDestroyer_Print(LOOTDESTROYER_CHAT_ITEMLISTS);
			if ( getn(LootDestroyer_ItemList) > 0 ) then
				for k, v in LootDestroyer_ItemList do
					LootDestroyer_PrintItemList(v);
				end
			else
				LootDestroyer_Print(LOOTDESTROYER_CHAT_ITEMLISTS_NONE);
			end
		end
	else
		LootDestroyer_Print(LOOTDESTROYER_CHAT_ITEMLIST_VARIABLES_NOT_INITIALIZED);
	end
end

function LootDestroyer_Save_ItemList_ChatCommandHandler(msg)
	LootDestroyer_SaveItemList(msg, 0);
end

function LootDestroyer_Load_ItemList_ChatCommandHandler(msg)
	LootDestroyer_LoadItemList(msg);
end

function LootDestroyer_Show_ItemList_ChatCommandHandler(msg)
	LootDestroyer_ShowItemList(msg);
end

function LootDestroyer_Clear_ChatCommandHandler(msg)
	LootDestroyer_ClearUnwantedItems();
end

function LootDestroyer_List_ChatCommandHandler(msg)
	LootDestroyer_ShowUnwantedItems();
end

function LootDestroyer_Toggle_ChatCommandHandler(msg)
	LootDestroyer_ToggleUnwantedItem(msg, true);
end

function LootDestroyer_Preserve_Toggle_ChatCommandHandler(msg)
	LootDestroyer_Preserve_Toggle_Enabled(msg, true);
end

function LootDestroyer_Destroy_Messages_Toggle_ChatCommandHandler(msg)
	LootDestroyer_Destroy_Messages_Toggle_Enabled(msg, true);
end

function LootDestroyer_ClearUnwantedItems()
	LootDestroyer_UnwantedItems = {};
	LootDestroyer_Print(LOOTDESTROYER_CHAT_LIST_CLEARED);
	if ( LootDestroyer_Autosave_Enabled == 1 ) then
		LootDestroyer_SaveItemList(LOOTDESTROYER_AUTOSAVEITEMLISTNAME, 1);
	end
end

function LootDestroyer_Autosave_Toggle_ChatCommandHandler(msg)
	LootDestroyer_AutoSave_Toggle_Enabled(msg, true);
end

function LootDestroyer_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( LootFrameItem_OnClick ~= LootDestroyer_LootFrameItem_OnClick ) and (LootDestroyer_Saved_LootFrameItem_OnClick == nil) ) then
			LootDestroyer_Saved_LootFrameItem_OnClick = LootFrameItem_OnClick;
			LootFrameItem_OnClick = LootDestroyer_LootFrameItem_OnClick;
		end
		if ( ( ContainerFrameItemButton_OnClick ~= LootDestroyer_ContainerFrameItemButton_OnClick ) and (LootDestroyer_Saved_ContainerFrameItemButton_OnClick == nil) ) then
			LootDestroyer_Saved_ContainerFrameItemButton_OnClick = ContainerFrameItemButton_OnClick;
			ContainerFrameItemButton_OnClick = LootDestroyer_ContainerFrameItemButton_OnClick;
		end
		if ( ( LootDestroyer_OverloadLootUpdate_Enabled == 1 ) and ( LootFrame_Update ~= LootDestroyer_LootFrame_Update ) and (LootDestroyer_Saved_LootFrame_Update == nil) ) then
			LootDestroyer_Saved_LootFrame_Update = LootFrame_Update;
			LootFrame_Update = LootDestroyer_LootFrame_Update;
		end
	else
		if ( LootFrameItem_OnClick == LootDestroyer_LootFrameItem_OnClick) then
			LootFrameItem_OnClick = LootDestroyer_Saved_LootFrameItem_OnClick;
			LootDestroyer_Saved_LootFrameItem_OnClick = nil;
		end
		if ( ContainerFrameItemButton_OnClick == LootDestroyer_ContainerFrameItemButton_OnClick) then
			ContainerFrameItemButton_OnClick = LootDestroyer_Saved_ContainerFrameItemButton_OnClick;
			LootDestroyer_Saved_ContainerFrameItemButton_OnClick = nil;
		end
		if ( LootFrame_Update == LootDestroyer_LootFrame_Update) then
			LootFrame_Update = LootDestroyer_Saved_LootFrame_Update;
			LootDestroyer_Saved_LootFrame_Update = nil;
		end
	end
end


function LootDestroyer_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( LootDestroyer_CosmosRegistered == 0 ) then
			local value = getglobal("COS_LOOTDESTROYER_ENABLED_X");
			if ( value == nil ) then
				-- defaults to off
				value = 0;
			end
			LootDestroyer_Toggle_Enabled(value);
		end
		RegisterForSave("LootDestroyer_ItemList");
		LootDestroyer_VariablesInitialized = true;
		if ( LootDestroyer_Autosave_Enabled == 1 ) then
			LootDestroyer_LoadItemList(LOOTDESTROYER_AUTOSAVEITEMLISTNAME, 1);
		end
		--[[
		if ( LootDestroyer_BagData_Initialized == false ) then
			LootDestroyer_BagData_Initialize();
		end
		]]--
		return;
	end

	if ( event == "BAG_UPDATE" ) then
				-- Initialize data ?
		if ( LootDestroyer_BagData_Initialized == false ) then
			LootDestroyer_BagData_Initialize();
		end
				-- Update data for specific bag that changed
		LootDestroyer_BagData_UpdateBagData(arg1);

				-- Every 10 bag changes, check another bag to verify data
		LootDestroyer_BagData_CheckBagCounter = LootDestroyer_BagData_CheckBagCounter + 1;
		if ( LootDestroyer_BagData_CheckBagCounter > LOOTDESTROYER_BAGDATA_CHECKBAGCOUNTMAX ) then
			if ( arg1 ~= LootDestroyer_BagData_CheckBag ) then
				LootDestroyer_BagData_UpdateBagData(LootDestroyer_BagData_CheckBag);
			end
			LootDestroyer_BagData_CheckBag = LootDestroyer_BagData_CheckBag + 1;
			if ( LootDestroyer_BagData_CheckBag > LOOTDESTROYER_MAX_NUMBER_OF_BAGS ) then
				LootDestroyer_BagData_CheckBag = 0;
			end
			LootDestroyer_BagData_CheckBagCounter = 1;
		end

				-- Check for items to destroy
		if ( LootDestroyer_HasItemsToDestroy() == 1 ) then
			LootDestroyer_BagData_DestroyNewUnwantedItems();
		else
			LootDestroyer_BagData_CheckForUnwantedItemsInInventory();
		end
	end
end

function LootDestroyer_OnInventoryUpdate()
	if ( scanType ) then
		if ( ( scanType and DYNAMICDATA_ITEM_SCAN_TYPE_ITEMINFO ) == 0 ) then
			return;
		end
	end
	if ( LootDestroyer_HasItemsToDestroy() == 1 ) then
		LootDestroyer_DynamicData_DestroyNewUnwantedItems();
	else
		LootDestroyer_DynamicData_CheckForUnwantedItemsInInventory();
	end
end

function LootDestroyer_ShowUnwantedItems()
	LootDestroyer_Print(LOOTDESTROYER_CHAT_UNWANTED_ITEMS_LIST);
	local doNotShowPreserve = LootDestroyer_Preserve_Enabled;
	if ( doNotShowPreserve == 1 ) then
		doNotShowPreserve = 0;
	else
		doNotShowPreserve = 1;
	end
	LootDestroyer_PrintGenericItemList(LootDestroyer_UnwantedItems, LootDestroyer_PreserveItemCount, doNotShowPreserve);
end

function LootDestroyer_RemoveFromUnwantedItemList(itemName)
	if ( LootDestroyer_IsUnwantedItem(itemName) == 1 ) then
		for k,v in LootDestroyer_UnwantedItems do
			if ( v == itemName) then
				table.remove(LootDestroyer_UnwantedItems, k);
				LootDestroyer_PreserveItemCount[v] = null;
				LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEM_REMOVED, v));

				for k1,v1 in LootDestroyer_RecentUnwantedItems do
					if ( k1 == itemName ) then
						LootDestroyer_RecentUnwantedItems[k1] = null;
					end
				end
				return 1;
			end
		end
	end
	return 0;
end

function LootDestroyer_AddToUnwantedItemList(itemName)
	if ( LootDestroyer_IsUnwantedItem(itemName) == 0) then
		table.insert(LootDestroyer_UnwantedItems, itemName);
		if (LootDestroyer_Preserve_Enabled == 1) then
			LootDestroyer_PreserveItemCount[itemName] = LootDestroyer_DynamicData_GetNumberOfItemsInInventory(itemName);
			if ( LootDestroyer_DebugPrint_Enabled == true) then
				LootDestroyer_Print(format("LootDestroyer_PreserveItemCount[%s] = %d", itemName, LootDestroyer_PreserveItemCount[itemName]));
			end
		else
			LootDestroyer_PreserveItemCount[itemName] = 0;
		end
		return 1;
	end
	return 0;
end

function LootDestroyer_ToggleUnwantedItem(itemName)
	if (itemName == nil) then
		LootDestroyer_Print(LOOTDESTROYER_CHAT_ERROR_TOGGLE_NIL);
		return;
	end
	if ( LootDestroyer_RemoveFromUnwantedItemList(itemName) == 0 ) then
		LootDestroyer_AddToUnwantedItemList(itemName);
		LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEM_ADDED, itemName));
	end
	if ( LootDestroyer_Autosave_Enabled == 1 ) then
		LootDestroyer_SaveItemList(LOOTDESTROYER_AUTOSAVEITEMLISTNAME, 1);
	end
	-- basically, if we are messing with the LootFrame_Update, we should force an update 
	-- when we have toggled the item unwanted list, as that may have changed what the user should see.
	if ( ( LootFrame_Update == LootDestroyer_LootFrame_Update ) and (LootFrame) and (LootFrame:IsVisible() ) ) then
		-- DEBUG: the following print is for debug use only
		if ( LootDestroyer_DebugPrint_Enabled == true) then
			LootDestroyer_PrintOnce("LD: DBG forcing LootFrame update.", "LootDestroyer_HasNotifiedOfForcedLootFrameUpdate");
		end
		LootFrame_Update();
	end
end

function LootDestroyer_AutoSave_Toggle_Enabled(toggle, showInChat)
	local oldvalue = LootDestroyer_Autosave_Enabled;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	LootDestroyer_Autosave_Enabled = newvalue;
	setglobal("COS_LOOTDESTROYER_AUTOSAVE_ENABLED_X", newvalue);
	if ( ( LootDestroyer_CosmosRegistered == 0 ) or ( showInChat ) ) then 
		if ( newvalue ~= oldvalue ) then
			if ( newvalue == 1 ) then
				LootDestroyer_Print(LOOTDESTROYER_CHAT_AUTOSAVE_ENABLED);
			else
				LootDestroyer_Print(LOOTDESTROYER_CHAT_AUTOSAVE_DISABLED);
			end
		end
	end
	if ( ( newvalue ~= oldvalue ) and ( newvalue == 1 ) ) then
		LootDestroyer_SaveItemList(LOOTDESTROYER_AUTOSAVEITEMLISTNAME, 1);
	end
	LootDestroyer_Register_Cosmos();
	if ( LootDestroyer_CosmosRegistered == 0 ) then 
		RegisterForSave("COS_LOOTDESTROYER_AUTOSAVE_ENABLED_X");	
	end
end

function LootDestroyer_Preserve_Toggle_Enabled(toggle, showInChat)
	local oldvalue = LootDestroyer_Preserve_Enabled;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	LootDestroyer_Preserve_Enabled = newvalue;
	setglobal("COS_LOOTDESTROYER_PRESERVE_ENABLED_X", newvalue);
	if ( ( LootDestroyer_CosmosRegistered == 0 ) or ( showInChat ) ) then 
		if ( newvalue ~= oldvalue ) then
			if ( newvalue == 1 ) then
				LootDestroyer_Print(LOOTDESTROYER_CHAT_PRESERVE_ENABLED);
			else
				LootDestroyer_Print(LOOTDESTROYER_CHAT_PRESERVE_DISABLED);
			end
		end
	end
	LootDestroyer_Register_Cosmos();
	if ( LootDestroyer_CosmosRegistered == 0 ) then 
		RegisterForSave("COS_LOOTDESTROYER_PRESERVE_ENABLED_X");	
	end
end

function LootDestroyer_Destroy_Messages_Toggle_Enabled(toggle, showInChat)
	local oldvalue = LootDestroyer_Destroy_Messages_Enabled;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	LootDestroyer_Destroy_Messages_Enabled = newvalue;
	setglobal("COS_LOOTDESTROYER_DESTROY_MESSAGES_ENABLED_X", newvalue);
	if ( ( LootDestroyer_CosmosRegistered == 0 ) or ( showInChat ) ) then 
		if ( newvalue ~= oldvalue ) then
			if ( newvalue == 1 ) then
				LootDestroyer_Print(LOOTDESTROYER_CHAT_DESTROY_MESSAGES_ENABLED);
			else
				LootDestroyer_Print(LOOTDESTROYER_CHAT_DESTROY_MESSAGES_DISABLED);
			end
		end
	end
	LootDestroyer_Register_Cosmos();
	if ( LootDestroyer_CosmosRegistered == 0 ) then 
		RegisterForSave("COS_LOOTDESTROYER_DESTROY_MESSAGES_ENABLED_X");	
	end
end

function LootDestroyer_Toggle_Enabled(toggle, showInChat)
	local oldvalue = LootDestroyer_Enabled;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	LootDestroyer_Enabled = newvalue;
	setglobal("COS_LOOTDESTROYER_ENABLED_X", newvalue);
	LootDestroyer_Setup_Hooks(newvalue);
	if ( ( LootDestroyer_CosmosRegistered == 0 ) or ( showInChat ) ) then 
		if ( newvalue ~= oldvalue ) then
			if ( newvalue == 1 ) then
				LootDestroyer_Print(LOOTDESTROYER_CHAT_ENABLED);
			else
				LootDestroyer_Print(LOOTDESTROYER_CHAT_DISABLED);
			end
		end
	end
	if ( newvalue == 0) then
		LootDestroyer_RecentUnwantedItems = {};
	end
	LootDestroyer_Register_Cosmos();
	if ( LootDestroyer_CosmosRegistered == 0 ) then 
		RegisterForSave("COS_LOOTDESTROYER_ENABLED_X");	
	end
end

function LootDestroyer_IsUnwantedItem(itemName)
	for k,v in LootDestroyer_UnwantedItems do
		if ( v == itemName ) then
			return 1;
		end
	end
	return 0;
end

function LootDestroyer_AddNewUnwantedItem(itemName, quantity)
	LootDestroyer_RecentUnwantedItems[itemName] = 0;
	if (LootDestroyer_DebugPrint_Enabled == true) then
		LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEM_WILL_BE_REMOVED, itemName, quantity));
	end
end

-- Bag Data functionality begin

function LootDestroyer_BagData_Initialize()
	for bag = 0,4 do
		LootDestroyer_BagData_UpdateBagData(bag);
	end
	LootDestroyer_BagData_Initialized = true;
end

function LootDestroyer_BagData_UpdateBagData(bagnum)
	local ttext = null;
	local id;
	
		-- Clean up RecentUnwantedItems
	for k, v in LootDestroyer_RecentUnwantedItems do
	  if ( ( GetTime() - v ) > 0.5 ) then
	    LootDestroyer_RecentUnwantedItems[k] = null;
	  end
	end
	if ( bagnum == nil ) then
	  for b = 0,4 do
	    LootDestroyer_BagData_UpdateBagData(b);
	  end
	  return;
	end
	for slot = 1,GetContainerNumSlots(bagnum) do
		ttext = LootDestroyer_GetContainerItemName(bagnum, slot);
		id = format("%02d%02d", bagnum, slot);
		if ( ( ttext ) and ( strlen(ttext) > 0 ) and ( ttext ~= nil ) ) then
			local texture, itemcount = GetContainerItemInfo(bagnum, slot);
			LootDestroyer_BagData_ItemName[id] = ttext;
			LootDestroyer_BagData_ItemCount[id] = itemcount;
		else
			LootDestroyer_BagData_ItemName[id] = null;
			LootDestroyer_BagData_ItemCount[id] = null;
		end
	end
end

function LootDestroyer_BagData_GetNumberOfItemsInInventory(itemName)
	local ttext = null;
	local count = 0;
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			local itemCount = LootDestroyer_BagData_ItemCount[format("%02d%02d", bag, slot)];
			if ( (itemCount) and (itemCount > 0) ) then
				ttext = LootDestroyer_BagData_ItemName[format("%02d%02d", bag, slot)];
				if ( ( ttext ) and ( strlen(ttext) > 0 ) and ( ttext == itemName ) )then
					count = count + itemCount;
				end
			end
		end
	end
	return count;
end

function LootDestroyer_BagData_CheckForUnwantedItemsInInventory()
	if ( table.getn(LootDestroyer_UnwantedItems) > 0 ) then
		local currentNumberOfItems = 0;
		local preservedNumberOfItems = 0;
		LootDestroyer_RecentUnwantedItems = {};
		for k, v in LootDestroyer_UnwantedItems do
			currentNumberOfItems = LootDestroyer_BagData_GetNumberOfItemsInInventory(v);
			if ( currentNumberOfItems > 0 ) then
				if ( LootDestroyer_Preserve_Enabled == 1 ) then 
					preservedNumberOfItems = LootDestroyer_PreserveItemCount[v];
					if ( not preservedNumberOfItems ) then
						preservedNumberOfItems = 0;
					end
					if ( currentNumberOfItems > preservedNumberOfItems ) then
						LootDestroyer_AddNewUnwantedItem(v, currentNumberOfItems-preservedNumberOfItems);
					end
				else
					LootDestroyer_AddNewUnwantedItem(v, currentNumberOfItems);
				end
			end
		end
		LootDestroyer_BagData_DestroyNewUnwantedItems();
	end
end

function LootDestroyer_BagData_DestroyNewUnwantedItems()
	for k, v in LootDestroyer_RecentUnwantedItems do
	  if ( ( v == 0 ) or ( ( v - GetTime() ) > 0.5 ) ) then
	    LootDestroyer_RecentUnwantedItems[k] = GetTime();
	    LootDestroyer_BagData_DestroyItem(k);
	  end
	end
end


function LootDestroyer_BagData_DestroyItem(itemName)
	if ( CursorHasItem() ) then
		LootDestroyer_Print(LOOTDESTROYER_CHAT_CURSORHASITEM);
		return false;
	end
	local bag = -1;
	local slot = -1;
	local id = "";
	for k, v in LootDestroyer_BagData_ItemName do
	  if ( v == itemName ) then
	    bag = tonumber(string.sub(k, 1, 2));
	    slot = tonumber(string.sub(k, 3, 4));
	    id = k;
	  end
	end
	if ( ( bag > -1 ) and ( slot > -1) ) then
 		local itemCount = LootDestroyer_BagData_ItemCount[id];
 		local totalitemCount = LootDestroyer_BagData_GetNumberOfItemsInInventory(itemName);
 		local preserveCount = LootDestroyer_PreserveItemCount[itemName];
		if ( ( ( LootDestroyer_Preserve_Enabled == 1 ) and ( totalitemCount - itemCount >= preserveCount ) ) or ( LootDestroyer_Preserve_Enabled == 0 ) ) then
			PickupContainerItem(bag, slot);
		elseif ( ( LootDestroyer_Preserve_Enabled == 1) and ( totalitemCount - itemCount < preserveCount ) ) then
			SplitContainerItem(bag, slot, (totalitemCount - preserveCount) );
		else
			SplitContainerItem(bag, slot, 1);
		end
		DeleteCursorItem();
		if ( (LootDestroyer_DebugPrint_Enabled == true) or (LootDestroyer_Destroy_Messages_Enabled == 1) ) then
			LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEM_HAS_BEEN_REMOVED, itemName));
		end
	end
end

-- Bag Data functionality end


function LootDestroyer_LootFrame_Update()
	if ( LootDestroyer_Saved_LootFrame_Update ) then
		LootDestroyer_Saved_LootFrame_Update();
	end
	for index = 1, LOOTFRAME_NUMBUTTONS, 1 do
		local button = getglobal("LootButton"..index);
		if ( button:IsVisible() ) then
			local slot = LootDestroyer_LootFrameItem_Slot(index);
			local texture;
			local item;
			local quantity;
			texture, item, quantity = GetLootSlotInfo(slot);
			--local itemName = getglobal("LootButton"..index.."Text"):GetText();
			local itemName = item;
			local countString = getglobal("LootButton"..index.."Count");
			local iconTexture = getglobal("LootButton"..index.."IconTexture");
			if ( LootDestroyer_IsUnwantedItem(itemName) == 1 ) then
				if ( LootDestroyer_Display_Unwanted_Use_Quantity_Enabled == 1 ) then
					countString:SetText("X");
					countString:Show();
				end
				if ( LootDestroyer_Display_Unwanted_Use_Texture_Enabled == 1 ) then
					iconTexture:SetTexture(LOOTDESTROYER_UNWANTED_ITEM_TEXTURE);
					-- save the old texture
					countString:Hide();
				end
				LootDestroyer_SavedIconTexture[index] = texture;
			else
				local count = countString:GetText();
				if ( count == "X" ) then
					countString:SetText(quantity);
					if ( quantity <= 1 ) then
						countString:Hide();
					else
						countString:Show();
					end
				end
				-- make sure it uses the item texture (probably unnecessary)
				iconTexture:SetTexture(texture);
			end
		end
	end
end

function LootDestroyer_PrintOnce(msg, key)
	if ( not key ) then
		key = "LootDestroyer_PrintOnce";
	end
	local value = getglobal(key);
	if ( ( value == nil ) or ( value == 0) ) then
		LootDestroyer_Print(msg);
		setglobal(key, 1);
	end
end

function LootDestroyer_HasItemsToDestroy()
	for k, v in LootDestroyer_RecentUnwantedItems do
	  return 1;
	end
	return 0;
end

function LootDestroyer_ContainerFrameItemButton_OnClick(button, ignoreShift)
	if ( LootDestroyer_Enabled == 1) then
		if ( ( button == "RightButton" ) and ( IsControlKeyDown() ) ) then
			local itemName = LootDestroyer_GetContainerItemName(this:GetParent():GetID(), this:GetID());
			if ( itemName ~= nil) then
				if ( ( LootDestroyer_IsUnwantedItem(itemName) == 1 ) and ( IsShiftKeyDown() ) ) then
					local oldCount = LootDestroyer_PreserveItemCount[itemName];
					if (not oldCount) then
						oldCount = 0;
					end
					LootDestroyer_PreserveItemCount[itemName] = 0;
					LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEM_PRESERVE_COUNT_ZERO, itemName, oldCount));
				else
					LootDestroyer_ToggleUnwantedItem(itemName);
				end
			end
			return;
		end
	end
	if ( LootDestroyer_Saved_ContainerFrameItemButton_OnClick ) then
		LootDestroyer_Saved_ContainerFrameItemButton_OnClick(button, ignoreShift);
	end
end


function LootDestroyer_GetContainerItemName(bag, slot)
	if ( LootDestroyer_TooltipsCanBeUsed() ) then
		local strings = LootDestroyerTooltip_GetItemInfoStrings(bag, slot);
		if ( table.getn(strings) > 0 ) then
			if ( strings[1].right ~= nil ) then
				return strings[1].right;
			elseif ( strings[1].left ~= nil ) then
				return strings[1].left;
			end
		end
	else
		LootDestroyer_Print(LOOTDESTROYER_CHAT_TOOLTIP_IN_USE);
	end
	return nil;
end

function LootDestroyer_LootFrameItem_Slot(index)
	local numLootItems = LootFrame.numLootItems;
	--Logic to determine how many items to show per page
	local numLootToShow = LOOTFRAME_NUMBUTTONS;
	if ( numLootItems > LOOTFRAME_NUMBUTTONS ) then
		numLootToShow = numLootToShow - 1;
	end
	local slot = (numLootToShow * (LootFrame.page - 1)) + index;
	return slot;
end

function LootDestroyer_LootFrameItem_DoStuff(index, rightButton)
	local slot = LootDestroyer_LootFrameItem_Slot(index);
	local texture;
	local item;
	local quantity;
	texture, item, quantity = GetLootSlotInfo(slot);
	--local itemName = getglobal("LootButton"..index.."Text"):GetText();
	local itemName = item;
	if ( rightButton == 1) then
		if ( ( IsShiftKeyDown() ) or ( IsControlKeyDown() ) ) then
			LootDestroyer_ToggleUnwantedItem(itemName);
		end
	end
	if ( LootDestroyer_IsUnwantedItem(itemName) == 1 ) then
		LootDestroyer_AddNewUnwantedItem(itemName, quantity);
	end
end

function LootDestroyer_LootFrameItem_OnClick(button)
	if ( LootDestroyer_Enabled == 1) then
		local index = this:GetID();
		if ( button == "LeftButton" ) then
			if ( not IsShiftKeyDown() ) then
				LootDestroyer_LootFrameItem_DoStuff(index, 0);
			end
		end
		if ( button == "RightButton" ) then
			LootDestroyer_LootFrameItem_DoStuff(index, 1);
		end
	end
	if ( LootDestroyer_Saved_LootFrameItem_OnClick ) then
		LootDestroyer_Saved_LootFrameItem_OnClick(button);
	end
end
	
	
function LootDestroyer_Print(msg,r,g,b,frame,id,unknown4th)
	if (unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

-- Item helper methods
function LootDestroyer_GetNumberOfBags()
	return LOOTDESTROYER_MAX_NUMBER_OF_BAGS;
end

function LootDestroyer_GetNumberOfBagSlots(bag)
	return GetContainerNumSlots(bag);
end


-- This function finds the specified item, return its bag, slot position
function LootDestroyer_FindItemByName(itemName)
	return LootDestroyer_FindItemByName_LastFirst(itemName);
end

-- This function starts at the end of the bags and goes backwards until it finds the item in question
function LootDestroyer_FindItemByName_LastFirst(itemName)
	local bag = 0;
	local slot = 0;
	for bag = LootDestroyer_GetNumberOfBags(), 0, -1 do
		for slot = LootDestroyer_GetNumberOfBagSlots(bag), 1, -1 do
			if ( LootDestroyer_ContainerItemHasName(itemName, bag, slot) == 1) then
				return bag, slot;
			end
		end
	end
	return -1, -1;
end


function LootDestroyer_ContainerItemHasName(itemName, bag, slot)
	local strings = LootDestroyerTooltip_GetItemInfoStrings(bag, slot);
	if ( ( strings == nil ) or ( table.getn(strings) <= 0 ) ) then
		return 0;
	end
	if ( ( strings[1] == itemName ) or ( strings[1].left == itemName ) or ( strings[1].right == itemName ) ) then
		return 1;
	else
		return 0;
	end
end

-- tooltip helper function
LOOTDESTROYER_TOOLTIPS_UNSAFE_FRAMES = { 
   "TaxiFrame", "MerchantFrame", "TradeSkillFrame", "SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
   }; 

-- use this to add unsafe frames 
function LootDestroyer_TooltipsCanNotBeUsedWithFrame(frame) 
   table.insert(LOOTDESTROYER_TOOLTIPS_UNSAFE_FRAMES, frame); 
end 


-- will return 1 if it is "safe" to use tooltips, otherwise 0 
function LootDestroyer_TooltipsCanBeUsed() 
   local frame = nil; 
   for k, v in LOOTDESTROYER_TOOLTIPS_UNSAFE_FRAMES do 
      frame = getglobal(v); 
      if ( ( frame ) and ( frame:IsVisible() ) ) then 
         return 0; 
      end 
   end 
   return 1; 
end


-- Helper methods from Cosmos
-- All credit should go to the Cosmos team for this one!

-- Gets all lines out of a tooltip.
function LootDestroyerTooltip_ScanTooltip(TooltipNameBase)
	if ( TooltipNameBase == nil ) then 
		TooltipNameBase = "LootDestroyerTooltip";
	end
	
	local strings = {};
	for idx = 1, 10 do
		local textLeft = nil;
		local textRight = nil;
		ttext = getglobal(TooltipNameBase.."TextLeft"..idx);
		if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
		then
			textLeft = ttext:GetText();
		end
		ttext = getglobal(TooltipNameBase.."TextRight"..idx);
		if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
		then
			textRight = ttext:GetText();
		end
		if (textLeft or textRight)
		then
			strings[idx] = {};
			strings[idx].left = textLeft;
			strings[idx].right = textRight;
		end
	end
	
	return strings;
end

-- Obtains all information about a bag/slot and returns it as an array 
function LootDestroyerTooltip_GetItemInfoStrings(bag,slot, TooltipNameBase)
	if ( TooltipNameBase == nil ) then 
		TooltipNameBase = "LootDestroyerTooltip";
	end

	--ClearTooltip(TooltipNameBase);
	local tooltip = getglobal(TooltipNameBase);
	
	for i=1, tooltip:NumLines(), 1 do
		getglobal(TooltipNameBase.."TextLeft"..i):SetText("");
		getglobal(TooltipNameBase.."TextRight"..i):SetText("");
	end

	-- Open tooltip & read contents

	if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
		DynamicData.util.protectTooltipMoney();
	end 
	tooltip:SetText("");
	tooltip:SetBagItem( bag, slot );
	if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.unprotectTooltipMoney ) then
		DynamicData.util.unprotectTooltipMoney();
	end 
	local strings = LootDestroyerTooltip_ScanTooltip(TooltipNameBase);

	-- Done our duty, send report
	return strings;
end



function LootDestroyer_DynamicData_GetNumberOfItemsInInventory(name)
	local allItemInfo = DynamicData.item.getItemInfoByName(name);
	if ( not allItemInfo ) then
		return 0;
	end
	return allItemInfo.count;
end

function LootDestroyer_DynamicData_CheckForUnwantedItemsInInventory()
	if ( table.getn(LootDestroyer_UnwantedItems) > 0 ) then
		local currentNumberOfItems = 0;
		local preservedNumberOfItems = 0;
		LootDestroyer_RecentUnwantedItems = {};
		for k, v in LootDestroyer_UnwantedItems do
			currentNumberOfItems = LootDestroyer_DynamicData_GetNumberOfItemsInInventory(v);
			if ( currentNumberOfItems > 0 ) then
				if ( LootDestroyer_Preserve_Enabled == 1 ) then 
					preservedNumberOfItems = LootDestroyer_PreserveItemCount[v];
					if ( not preservedNumberOfItems ) then
						preservedNumberOfItems = 0;
					end
					if ( currentNumberOfItems > preservedNumberOfItems ) then
						LootDestroyer_AddNewUnwantedItem(v, currentNumberOfItems-preservedNumberOfItems);
					end
				else
					LootDestroyer_AddNewUnwantedItem(v, currentNumberOfItems);
				end
			end
		end
		LootDestroyer_DynamicData_DestroyNewUnwantedItems();
	end
end

function LootDestroyer_DynamicData_DestroyNewUnwantedItems()
	for k, v in LootDestroyer_RecentUnwantedItems do
	  if ( ( v == 0 ) or ( ( v - GetTime() ) > 0.5 ) ) then
	    LootDestroyer_RecentUnwantedItems[k] = GetTime();
	    LootDestroyer_BagData_DestroyItem(k);
	  end
	end
end

function LootDestroyer_DynamicData_DestroyItem(itemName)
	if ( CursorHasItem() ) then
		LootDestroyer_Print(LOOTDESTROYER_CHAT_CURSORHASITEM);
		return false;
	end
	local bag = -1;
	local slot = -1;
	local allItemInfo = DynamicData.item.getItemInfoByName(itemName);
	if ( ( not allItemInfo ) or ( allItemInfo.count <= 0 ) or ( not allItemInfo.position ) or ( table.getn(allItemInfo.position) <= 0 ) ) then
		return false;
	end
	bag = allItemInfo.position[1].bag;
	slot = allItemInfo.position[1].slot;
	local itemInfo = DynamicData.item.getInventoryInfo(bag, slot);
	if ( ( not itemInfo ) or ( not itemInfo.name ) ) then
		return false;
	end
	local itemCount = itemInfo.count;
	local allItemInfo = DynamicData.item.getItemInfoByName(itemInfo.name);
	local totalitemCount = LootDestroyer_DynamicData_GetNumberOfItemsInInventory(itemInfo.name);
	local preserveCount = LootDestroyer_PreserveItemCount[itemName];
	if ( ( ( LootDestroyer_Preserve_Enabled == 1 ) and ( totalitemCount - itemCount >= preserveCount ) ) or ( LootDestroyer_Preserve_Enabled == 0 ) ) then
		PickupContainerItem(bag, slot);
	elseif ( ( LootDestroyer_Preserve_Enabled == 1) and ( totalitemCount - itemCount < preserveCount ) ) then
		SplitContainerItem(bag, slot, (totalitemCount - preserveCount) );
	else
		SplitContainerItem(bag, slot, 1);
	end
	DeleteCursorItem();
	if ( (LootDestroyer_DebugPrint_Enabled == true) or (LootDestroyer_Destroy_Messages_Enabled == 1) ) then
		LootDestroyer_Print(format(LOOTDESTROYER_CHAT_ITEM_HAS_BEEN_REMOVED, itemName));
	end
	return true;
end

