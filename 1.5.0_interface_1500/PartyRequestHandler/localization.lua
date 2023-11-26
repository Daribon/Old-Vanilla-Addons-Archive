-- Version : English - sarf
-- Translation by : None

BINDING_HEADER_PARTYREQUESTHANDLERHEADER				= "Party Request Handler";
BINDING_NAME_PARTYREQUESTHANDLER						= "Party Request Handler Toggle";

PARTYREQUESTHANDLER_CONFIG_HEADER					= "Party Request Handler";
PARTYREQUESTHANDLER_CONFIG_HEADER_INFO				= "Contains settings for the Party Request Handler,\nan AddOn which allows you to auto accept and deny party requests (invites). Use /prh to control it.";

PARTYREQUESTHANDLER_ENABLED							= "Enable PartyRequestHandler";
PARTYREQUESTHANDLER_ENABLED_INFO					= "Enables PartyRequestHandler, which will allow for automatic handling of group invites in some cases. Use /prh to control it.";

PARTYREQUESTHANDLER_SHOW_DENY						= "Show when PRH denies an invite";
PARTYREQUESTHANDLER_SHOW_DENY_INFO					= "Will give a visual cue when PRH auto-denies a party invite.";

PARTYREQUESTHANDLER_ALLOW_BY_DEFAULT				= "Allow by default";
PARTYREQUESTHANDLER_ALLOW_BY_DEFAULT_INFO			= "Will make PRH allow all invites that do not come from denied persons.";

PARTYREQUESTHANDLER_DENY_BY_DEFAULT					= "Deny by default";
PARTYREQUESTHANDLER_DENY_BY_DEFAULT_INFO			= "Will make PRH deny all invites that do not come from approved persons.";

PARTYREQUESTHANDLER_ALLOW_FRIEND					= "Auto-accept friends invites";
PARTYREQUESTHANDLER_ALLOW_FRIEND_INFO				= "Will auto-accept invites to parties that originate from people on your friends list.";

PARTYREQUESTHANDLER_ALLOW_GUILD						= "Auto-accept guildies invites";
PARTYREQUESTHANDLER_ALLOW_GUILD_INFO				= "Will auto-accept invites to parties that originate from people in your guild list.";

PARTYREQUESTHANDLER_DENY_IGNORE						= "Auto-deny ignore-list entries' invites";
PARTYREQUESTHANDLER_DENY_IGNORE_INFO				= "Will auto-deny ignore-list entries' to parties that originate from people in your guild list.";

PARTYREQUESTHANDLER_COMMANDS						= {"/partyrequesthandler", "/prh"};

PARTYREQUESTHANDLER_CHAT_ENABLED					= "Party Request Handler enabled.";
PARTYREQUESTHANDLER_CHAT_DISABLED					= "Party Request Handler disabled.";

PARTYREQUESTHANDLER_CHAT_ALLOW_FRIEND_ENABLED		= "Party Request Handler auto-allow friends invites enabled.";
PARTYREQUESTHANDLER_CHAT_ALLOW_FRIEND_DISABLED		= "Party Request Handler auto-allow friends invites disabled.";

PARTYREQUESTHANDLER_CHAT_ALLOW_GUILD_ENABLED		= "Party Request Handler auto-allow guildies invites enabled.";
PARTYREQUESTHANDLER_CHAT_ALLOW_GUILD_DISABLED		= "Party Request Handler auto-allow guildies invites disabled.";

PARTYREQUESTHANDLER_CHAT_DENY_IGNORE_ENABLED		= "Party Request Handler auto-deny ignore-list entries' invites enabled.";
PARTYREQUESTHANDLER_CHAT_DENY_IGNORE_DISABLED		= "Party Request Handler auto-deny ignore-list entries' invites disabled.";

PARTYREQUESTHANDLER_CHAT_SHOW_DENY_ENABLED			= "Party Request Handler show denies enabled.";
PARTYREQUESTHANDLER_CHAT_SHOW_DENY_DISABLED			= "Party Request Handler auto-allow guildies invites disabled.";

PARTYREQUESTHANDLER_CHAT_ALLOW_BY_DEFAULT_ENABLED	= "Party Request Handler auto-allow everyone not denied enabled.";
PARTYREQUESTHANDLER_CHAT_ALLOW_BY_DEFAULT_DISABLED	= "Party Request Handler auto-allow everyone not denied disabled.";

PARTYREQUESTHANDLER_CHAT_DENY_BY_DEFAULT_ENABLED	= "Party Request Handler auto-deny everyone not allowed enabled.";
PARTYREQUESTHANDLER_CHAT_DENY_BY_DEFAULT_DISABLED	= "Party Request Handler auto-deny everyone not allowed disabled.";

PARTYREQUESTHANDLER_CHAT_COMMAND_INFO				= "Controls Party Request Handler by the command line - /partyrequesthandler for usage.";

PARTYREQUESTHANDLER_CHAT_IGNORE_NEXT				= "Party Request Handler will ignore the next invite request.";

PARTYREQUESTHANDLER_CHAT_TOGGLE_ADDED				= "added";
PARTYREQUESTHANDLER_CHAT_TOGGLE_REMOVED				= "removed";

PARTYREQUESTHANDLER_CHAT_TOGGLE_ALLOWED				= "Party Request Handler has %s %s from the allowed list.";
PARTYREQUESTHANDLER_CHAT_TOGGLE_DENIED				= "Party Request Handler has %s %s from the denied list.";

PARTYREQUESTHANDLER_CHAT_DENIED_MESSAGE				= "Party Request Handler has denied %s's party invitation.";


PARTYREQUESTHANDLER_COMMAND_STATE					= {"state"};
PARTYREQUESTHANDLER_COMMAND_ALLOW_FRIEND			= {"friend"};
PARTYREQUESTHANDLER_COMMAND_ALLOW_GUILD				= {"guild"};
PARTYREQUESTHANDLER_COMMAND_DENY_IGNORE				= {"denyignore", "ignore"};
PARTYREQUESTHANDLER_COMMAND_SHOW_DENY				= {"showdeny"};
PARTYREQUESTHANDLER_COMMAND_DENY_BY_DEFAULT			= {"denybydefault","denydefault"};
PARTYREQUESTHANDLER_COMMAND_ALLOW_BY_DEFAULT		= {"allowbydefault","allowdefault"};
PARTYREQUESTHANDLER_COMMAND_IGNORE_NEXT				= {"ignorenext","ignore","exempt"};
PARTYREQUESTHANDLER_COMMAND_TOGGLE_ALLOWED			= {"allow","grant"};
PARTYREQUESTHANDLER_COMMAND_TOGGLE_DENIED			= {"deny","refuse"};

PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE				= {};
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "Usage:");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "/partyrequesthandler <ignorenext/allow/deny> [name]");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "-and-");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "/partyrequesthandler <state/friend/guild/denyignore/showdeny/denybydefault> [on/off/toggle]");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "Commands:");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "state - determines whether the PartyRequestHandler should be enabled or not");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "friend - auto-allow people on friends list");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "guild - auto-allow people in guild");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "denyignore - auto-deny people in ignore list");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "showdeny - visual display when denying an invite");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "allowbydefault - will allow every request that is not explicitly denied");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "denybydefault - will deny every request that is not explicitly allowed");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "ignorenext - will exempt the next party invite from PRH management");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "allow - will add/remove the person specified into the allowed list");
table.insert(PARTYREQUESTHANDLER_CHAT_COMMAND_USAGE, "deny - will add/remove the person specified into the deny list");

