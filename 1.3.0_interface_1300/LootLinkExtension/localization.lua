LOOTLINKEXTENSION_CHAT_COMMANDS_INFO					= "Controls LootLink Extension"
LOOTLINKEXTENSION_SLASH_COMMANDS_INSPECT_ON_MOUSE_OVER	= {"inspectonmouseover", "mouseover", "iomo", "imo" };
LOOTLINKEXTENSION_SLASH_COMMANDS_REFRESH_ON_SHOW		= {"refreshonshow", "refreshshow", "ros", "rs" };
LOOTLINKEXTENSION_SLASH_COMMANDS_SCAN_MERCHANT_ITEMS	= {"scanmerchantitems", "scanmerchant", "smi", "sm", "scanvendoritems", "scanvendor", "svi", "sv" };

LOOTLINKEXTENSION_INFO_INSPECT_ON_MOUSE_OVER			= " inspectonmouseover (or imo)\ndetermines whether players will be inspected on mouse over";
LOOTLINKEXTENSION_INFO_REFRESH_ON_SHOW					= " refreshonshow (or ros)\ndetermines whether the LootLink window will be refreshed when it is shown";
LOOTLINKEXTENSION_INFO_SCAN_MERCHANT_ITEMS				= " scanmerchantitems (or smi)\ndetermines whether merchants (vendors) should have their inventory scanned when it is displayed";

LOOTLINKEXTENSION_USAGE									= {};

table.insert(LOOTLINKEXTENSION_USAGE,
	" Usage: /lootlinkextension (or /lle) <command> [parameter]");
table.insert(LOOTLINKEXTENSION_USAGE,
	"Commands:");
table.insert(LOOTLINKEXTENSION_USAGE,
	LOOTLINKEXTENSION_INFO_INSPECT_ON_MOUSE_OVER);
table.insert(LOOTLINKEXTENSION_USAGE,
	LOOTLINKEXTENSION_INFO_REFRESH_ON_SHOW);
table.insert(LOOTLINKEXTENSION_USAGE,
	LOOTLINKEXTENSION_INFO_SCAN_MERCHANT_ITEMS);
