-- The ace:LoadTranslation() method looks for a specific translation function for
-- the addon. If it finds one, that translation is loaded. See AceHelloLocals_xxXX.lua
-- for an example and description of function naming.
if( not ace:LoadTranslation("KC_Items_MasterDB") ) then

KC_ITEMS_MASTERDB_NAME          = "KC_Items_MasterDB"
KC_ITEMS_MASTERDB_DESCRIPTION   = "This module handles conversion of IM and LL data."

KC_ITEMS_MASTERDB_CHAT_COMMANDS = {"/KCI_MasterDB", "/kcidb"};

KC_ITEMS_MASTERDB_CHAT_OPTIONS  = {
	{
		option = "merge",
		desc   = "Merge the MasterDB into your KC_ItemsDB",
		method = "merge",
	},
}
end

