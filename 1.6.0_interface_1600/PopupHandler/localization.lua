
POPUPHANDLER_SLASHCOMMANDS								= {"/popuphandler", "/ph"};

POPUPHANDLER_STATE_TEXT									= "Option";
POPUPHANDLER_STATE_ENABLED								= "enabled";
POPUPHANDLER_STATE_DISABLED								= "disabled";


POPUPHANDLER_CONFIG_NAME								= "PopupHandler";
POPUPHANDLER_CONFIG_INFO								= "Allows for automatated handling of popups, such as bind on pickup items, overwriting personal item enchantments and so on.";


POPUPHANDLER_OPTION_ENABLED_NAME						= "Toggle";
POPUPHANDLER_OPTION_ENABLED_INFO						= "Determines whether PopupHandler is active or not. If not active, no popups will be automatically handled by it.";
POPUPHANDLER_CHAT_ENABLED_CMDS							= {"toggle"};
POPUPHANDLER_CHAT_ENABLED_FORMAT						= " is %s";

-- Bind on Pickup

POPUPHANDLER_OPTION_BIND_ON_PICKUP_NAME					= "Auto Bind on Pickup";
POPUPHANDLER_OPTION_BIND_ON_PICKUP_INFO					= "If enabled, it will automatically accept any Bind on Pickup items you loot, but *only* when you are not grouped.";
POPUPHANDLER_CHAT_BIND_ON_PICKUP_CMDS					= {"bindonpickup", "bop"};
POPUPHANDLER_CHAT_BIND_ON_PICKUP_FORMAT 				= POPUPHANDLER_OPTION_BIND_ON_PICKUP_NAME.." is %s";

-- Replace Enchant

POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_NAME				= "Always Replace Enchantment";
POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_INFO				= "If enabled, it will automatically overwrite any pre-existing enchantment (this includes armor kits). Be careful.";
POPUPHANDLER_CHAT_OVERWRITE_ENCHANT_CMDS				= {"overwriteenchant", "replaceenchant"};
POPUPHANDLER_CHAT_OVERWRITE_ENCHANT_FORMAT				= POPUPHANDLER_OPTION_OVERWRITE_ENCHANT_NAME.." is %s";

-- Party Invites

POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_NAME			= "Auto-accept party invites";
POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_INFO			= "If enabled, it will automatically accept all party invites which are not declined automatically.";
POPUPHANDLER_CHAT_ACCEPT_PARTY_INVITES_CMDS				= {"autoacceptinvite"};
POPUPHANDLER_CHAT_ACCEPT_PARTY_INVITES_FORMAT			= POPUPHANDLER_OPTION_ACCEPT_PARTY_INVITES_NAME.." is %s";

POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_NAME			= "Auto-decline party invites";
POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_INFO			= "If enabled, it will automatically decline all party invites which are not accepted automatically.";
POPUPHANDLER_CHAT_DECLINE_PARTY_INVITES_CMDS			= {"autodeclineinvite"};
POPUPHANDLER_CHAT_DECLINE_PARTY_INVITES_FORMAT			= POPUPHANDLER_OPTION_DECLINE_PARTY_INVITES_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_NAME	= "Auto-accept party invites from friends";
POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_INFO	= "If enabled, it will automatically accept all party invites that come from someone on your friendlist.";
POPUPHANDLER_CHAT_ACCEPT_FRIEND_PARTY_INVITES_CMDS		= {"acceptfriend"};
POPUPHANDLER_CHAT_ACCEPT_FRIEND_PARTY_INVITES_FORMAT	= POPUPHANDLER_OPTION_ACCEPT_FRIEND_PARTY_INVITES_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_NAME		= "Auto-accept party invites from guildies";
POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_INFO		= "If enabled, it will automatically accept all party invites that come from someone in your guild.";
POPUPHANDLER_CHAT_ACCEPT_GUILD_PARTY_INVITES_CMDS		= {"acceptguild"};
POPUPHANDLER_CHAT_ACCEPT_GUILD_PARTY_INVITES_FORMAT		= POPUPHANDLER_OPTION_ACCEPT_GUILD_PARTY_INVITES_NAME.." is %s";

POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_NAME	= "Auto-decline party invites from ignored";
POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_INFO	= "If enabled, it will automatically decline all party invites that come from someone in your ignore list.";
POPUPHANDLER_CHAT_DECLINE_IGNORE_PARTY_INVITES_CMDS		= {"declineignore"};
POPUPHANDLER_CHAT_DECLINE_IGNORE_PARTY_INVITES_FORMAT	= POPUPHANDLER_OPTION_DECLINE_IGNORE_PARTY_INVITES_NAME.." is %s";

POPUPHANDLER_CHAT_DENIED_INVITE_USER					= "PopupHandler denied %s's party invite.";

-- Resurrection

POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_NAME			= "Auto-accept resurrection";
POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_INFO			= "If enabled, it will automatically accept all resurrection offers which are not declined automatically.";
POPUPHANDLER_CHAT_ACCEPT_RESURRECTION_CMDS				= {"autoacceptresurrection"};
POPUPHANDLER_CHAT_ACCEPT_RESURRECTION_FORMAT			= POPUPHANDLER_OPTION_ACCEPT_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_DECLINE_RESURRECTION_NAME			= "Auto-decline resurrection";
POPUPHANDLER_OPTION_DECLINE_RESURRECTION_INFO			= "If enabled, it will automatically decline all resurrection offers which are not accepted automatically.";
POPUPHANDLER_CHAT_DECLINE_RESURRECTION_CMDS				= {"autodeclineresurrection"};
POPUPHANDLER_CHAT_DECLINE_RESURRECTION_FORMAT			= POPUPHANDLER_OPTION_DECLINE_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_NAME		= "Auto-accept resurrection from friends";
POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_INFO		= "If enabled, it will automatically accept all resurrection offers that come from someone on your friendlist.";
POPUPHANDLER_CHAT_ACCEPT_FRIEND_RESURRECTION_CMDS		= {"acceptfriendresurrection"};
POPUPHANDLER_CHAT_ACCEPT_FRIEND_RESURRECTION_FORMAT		= POPUPHANDLER_OPTION_ACCEPT_FRIEND_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_NAME		= "Auto-accept resurrection from guildies";
POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_INFO		= "If enabled, it will automatically accept all resurrection offers that come from someone in your guild.";
POPUPHANDLER_CHAT_ACCEPT_GUILD_RESURRECTION_CMDS		= {"acceptguildresurrection"};
POPUPHANDLER_CHAT_ACCEPT_GUILD_RESURRECTION_FORMAT		= POPUPHANDLER_OPTION_ACCEPT_GUILD_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_NAME	= "Auto-decline resurrection from ignored";
POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_INFO	= "If enabled, it will automatically decline all resurrection offers that come from someone in your ignore list.";
POPUPHANDLER_CHAT_DECLINE_IGNORE_RESURRECTION_CMDS		= {"declineignoreresurrection"};
POPUPHANDLER_CHAT_DECLINE_IGNORE_RESURRECTION_FORMAT	= POPUPHANDLER_OPTION_DECLINE_IGNORE_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_NAME		= "Auto-accept resurrection from party";
POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_INFO		= "If enabled, it will automatically accept all resurrection offers that come from someone in your party/raid.";
POPUPHANDLER_CHAT_ACCEPT_PARTY_RESURRECTION_CMDS		= {"autoacceptpartyresurrection"};
POPUPHANDLER_CHAT_ACCEPT_PARTY_RESURRECTION_FORMAT		= POPUPHANDLER_OPTION_ACCEPT_PARTY_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_NAME		= "Auto-accept any resurrection while in PvP";
POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_INFO		= "If enabled, it will automatically accept all resurrection offers which are made while you are PvP flagged.";
POPUPHANDLER_CHAT_ACCEPT_PVP_RESURRECTION_CMDS			= {"autoacceptpvp"};
POPUPHANDLER_CHAT_ACCEPT_PVP_RESURRECTION_FORMAT		= POPUPHANDLER_OPTION_ACCEPT_PVP_RESURRECTION_NAME.." is %s";

POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_NAME		= "Auto-accept any resurrection while in certain areas";
POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_INFO		= "If enabled, it will automatically accept all resurrection offers which are made while you are in certain areas, such as Battlegrounds, Hillsbrad/Alterac and The Barrens.";
POPUPHANDLER_CHAT_ACCEPT_AREA_RESURRECTION_CMDS			= {"autoacceptarea"};
POPUPHANDLER_CHAT_ACCEPT_AREA_RESURRECTION_FORMAT		= POPUPHANDLER_OPTION_ACCEPT_AREA_RESURRECTION_NAME.." is %s";

POPUPHANDLER_CHAT_DENIED_RESURRECTION_USER				= "PopupHandler denied %s's resurrection offer.";


-- Duel Request

POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_NAME			= "Auto-decline duel request";
POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_INFO			= "If enabled, it will automatically decline all duel requests.";
POPUPHANDLER_CHAT_DECLINE_DUEL_REQUEST_CMDS				= {"autodeclineduel"};
POPUPHANDLER_CHAT_DECLINE_DUEL_REQUEST_FORMAT			= POPUPHANDLER_OPTION_DECLINE_DUEL_REQUEST_NAME.." is %s";

-- Misc


POPUPHANDLER_CHAT_HELP_CMDS								= {"help"};

POPUPHANDLER_CHAT_USAGE									= "Usage: /popuphandler <toggle>";

-- Auto-accept areas

POPUPHANDLER_AUTO_ACCEPT_RESURRECTION_AREAS				= {
	"Alterac Valley",
	"Alterac Mountains",
	"Hillsbrad Foothills",
	"The Barrens",
	"Warsong Gulch",
};

-- Khaos

POPUPHANDLER_KHAOS_SET_EASY_ID							= "PopupHandlerEasyID";

