--[[
--
--	Sky Localization Data
--
--]]

-- Keywords
SKY_GENERAL_ID = "general";
SKY_TRADE_ID = "trade";
SKY_LFG_ID = "lookingforgroup";
SKY_LOCALDEFENSE_ID = "localdefense";
SKY_WORLDDEFENSE_ID = "worlddefense";

-- Pretty print for capitalization
SKY_GENERAL_PRETTYPRINT = "General";
SKY_TRADE_PRETTYPRINT = "Trade";
SKY_LFG_PRETTYPRINT = "LookingForGroup";
SKY_LOCALDEFENSE_PRETTYPRINT = "LocalDefense";
SKY_WORLDDEFENSE_PRETTYPRINT = "WorldDefense";

-- Colored Sky
SKY_COLOR = "|cFF99BBCCSky|r";
SKY_PARTY_COLOR = SKY_COLOR.."|cFF009955Party|r";
SKY_RAID_COLOR = SKY_COLOR.."|cFF770000Raid|r";
SKY_ZONE_COLOR = SKY_COLOR.."|cFF777777Zone|r";
SKY_GUILD_COLOR = SKY_COLOR.."|cFF229922Guild|r";

-- Sky Channels List
SKY_CHANNELS_LIST = "[Active Sky Channels: %s]";

-- Zombie Warning!
SKY_UNDEAD_CHANNEL_WARNING = " |cFFFF7777Warning!|r You currently have %d Undead Channels. These cannot be removed by "..SKY_COLOR.." and may cause you to get spammed! Please logout and delete the |cFFDDDDDDchat-cache.wtf|r files from |cFFDDDDDDWorldOfWarcraft\\WTF\\YourAccountName\\YourCharacterName|r. Hopefully, Blizzard will fix this issue in the future. In case you can't logout, "..SKY_COLOR.." will do its very best to hide the channels from you, but features which need Sky may stop working. \n Good luck! \n The channels are: %s";

-- Channel is already in list
SKY_CHANNEL_ALREADY_LISTED = "You are already in channel %s.";

-- Joining too many channel
SKY_CHANNEL_TOO_MANY_CHANNELS = "There are too many channels. You must leave one before you can join '%s'.";

-- /command Help
SKY_JOIN_HELP = "Type /join <channelname> [password] to create a channel or join an existing one. ";
SKY_LEAVE_HELP = "Type /leave <channelname> or /leave # to leave a channel. ";
SKY_Z_HELP = "Shorter replacement for /script code execution. ";
SKY_PRINT_HELP = "Print executed code to the current frame. Short for /script Sea.io.printf(SELECTED_CHAT_FRAME, msg); ";

SKY_CHANNEL_FORMAT = "%s. %s";

-- Leave Warnings
SKY_LEAVE_WARNING_RAID = "|cFFFF3333Warning!|r Leaving the "..SKY_RAID_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_RAID_COLOR.." channel, type /join SkyRaid. (It will add your leader's name to the end automatically.)";
SKY_LEAVE_WARNING_GUILD = "|cFFFF3333Warning!|r Leaving the "..SKY_GUILD_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_GUILD_COLOR.." channel, type /join SkyGuild. (It will add your guild's name to the end automatically.)";
SKY_LEAVE_WARNING_PARTY = "|cFFFF3333Warning!|r Leaving the "..SKY_PARTY_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_PARTY_COLOR.." channel, type /join SkyParty. (It will add your leader's name to the end automatically.)";
SKY_LEAVE_WARNING_ZONE = "|cFFFF3333Warning!|r Leaving the "..SKY_ZONE_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_ZONE_COLOR.." channel, type /join SkyZone. (It will add your leader's name to the end automatically.)";
SKY_LEAVE_WARNING_SKY = "|cFFFF3333Warning!|r Leaving the "..SKY_COLOR.." channel may cause you to lose the ability to use many mods. If you wish to reactive the "..SKY_COLOR.." channel, type /join Sky.";

-- Join Warnings
SKY_JOIN_WARNING_RAID = "You cannot join the "..SKY_RAID_COLOR.." channel. You are not in a Raid.";
SKY_JOIN_WARNING_GUILD = "You cannot join the "..SKY_GUILD_COLOR.." channel. You are not in a Guild.";
SKY_JOIN_WARNING_PARTY = "You cannot join the "..SKY_PARTY_COLOR.." channel. You are not in a Party.";

-- Slash commands
SKY_JOIN_COMMANDS = {"/join", "/channel", "/chan"};
SKY_LEAVE_COMMANDS = {"/leave", "/chatleave", "/chatexit"};
SKY_LIST_COMMANDS = {"/list", "/chatlist", "/clist", "/chatinfo", "/chatwho"};
SKY_HELP_COMMANDS =  {"/help", "/skyhelp", "/shelp"};
SKY_PRINT_COMMANDS =  {"/print"};

-- Capital Cities
CAPITAL_CITIES = {"Orgrimmar", "Stormwind City", "Ironforge", "Darnassus", "Undercity", "Thunder Bluff"};
