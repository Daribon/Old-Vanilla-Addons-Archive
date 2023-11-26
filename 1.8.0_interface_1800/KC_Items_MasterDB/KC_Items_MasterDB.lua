local TRUE = 1;
local FALSE = nil;

local DEFAULT_OPTIONS =	{};

--[[--------------------------------------------------------------------------------
	Module Description : Optimizer

	This module handles conversion of IM and LL data.

	Version: 0.92
	Last Released: 7/30/2005

-----------------------------------------------------------------------------------]]

--[[--------------------------------------------------------------------------------
  Class Definition
-----------------------------------------------------------------------------------]]

KCI_MasterDBClass = AceAddonClass:new({
    name          = KC_ITEMS_MASTERDB_NAME,
    description   = KC_ITEMS_MASTERDB_DESCRIPTION,
    version       = "1.0",
    releaseDate   = "8/07/05",
    aceCompatible = "100", -- Check ACE_COMP_VERSION in Ace.lua for current.
    author        = "Kaelten",
    email         = "kaelten@gmail.com",
    website       = "http://kaelcycle.wowinterface.com",
	defaults	  = DEFAULT_OPTIONS,
    category      = "inventory",
	cmd           = AceChatCmdClass:new(KC_ITEMS_MASTERDB_CHAT_COMMANDS, KC_ITEMS_MASTERDB_CHAT_OPTIONS)
})

--[[--------------------------------------------------------------------------------
  merging
-----------------------------------------------------------------------------------]]

function KCI_MasterDBClass:merge()
	for id in KCI_Master do
		local data = KCI_Master[id];
		local sv, bv = ace.SplitString(data, ":");
		KC_Items:AddCode(id, tonumber(sv), tonumber(bv));
	end
	message("KCI_Master has finished merging.  You may now safely delete KCI_MasterDB.");
end

--[[--------------------------------------------------------------------------------
  Create and Register Addon Object
-----------------------------------------------------------------------------------]]

KCI_MasterDB = KCI_MasterDBClass:new()
KCI_MasterDB:RegisterForLoad();