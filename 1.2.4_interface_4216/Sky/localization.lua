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

-- Pretty print for other channels
SKY_CHANNEL_PRETTYPRINT = "Sky";
SKY_PARTY_PRETTYPRINT = "SkyParty";
SKY_RAID_PRETTYPRINT = "SkyRaid";
SKY_ZONE_PRETTYPRINT = "SkyZone";
SKY_GUILD_PRETTYPRINT = "SkyGuild";

-- Colored Sky
SKY_COLOR = "|cFF99BBCCSky|r";
SKY_PARTY_COLOR = SKY_COLOR.."|cFF009955Party|r";
SKY_RAID_COLOR = SKY_COLOR.."|cFF770000Raid|r";
SKY_ZONE_COLOR = SKY_COLOR.."|cFF777777Zone|r";
SKY_GUILD_COLOR = SKY_COLOR.."|cFF229922Guild|r";

-- Sky Channels List
SKY_CHANNELS_LIST = "[Active Sky Channels: %s]";

-- Zombie Warning!
SKY_UNDEAD_CHANNEL_WARNING = " |cFFFF7777Warning!|r You currently have %d Undead Channels. These cannot be removed by "..SKY_COLOR.." and may cause you to get spammed! Please logout and delete the |cFFDDDDDDchat-cache.wtf|r files from |cFFDDDDDDWorldOfWarcraft\\WTF\\YourAccountName\\YourCharacterName|r. Hopefully, Blizzard will fix this issue in the future. In case you can't logout, "..SKY_COLOR.." will do its very best to hide the channels from you, but features which need Sky may stop working. \n Good luck!";

-- AutoJoin
SKY_AUTO_JOIN_CHANNEL_WARNING = " |cFFFF7777Warning!|r An AddOn you are using has auto-joined %s. Sky has detected this and will not attempt to remove it. Please be aware that AddOns which auto-join channels can interfere with Sky's operation. If you would like to prevent-autojoin type \"/z SkyNotices.autoJoinOn = false;\". ";

-- AutoJoin
SKY_FIRST_TIME_WARNING = " Welcome to Sky. \n The first time you use Sky, all of your channels will be reset. Just /leave or /join the channels you want to be in.  Sky is a communications tool designed to make it possible for addons to share information between users silently. For example, PartyQuests allows you to share your quest lists with other players, and RaidMinion shows you full-raid HP. If you have RaidMinion enabled type /rm or control-right click the raid panel for details. (Only works in active raids)";

-- Channel is already in list
SKY_CHANNEL_ALREADY_LISTED = "You are already in channel %s.";

-- Password is updated
SKY_CHANNEL_PASSWORD_UPDATED = "Your password has been updated for channel %s. ";

-- Joined the channel, but it did not work!
SKY_CHANNEL_JOINED_BUT_INACTIVE = "You are already trying to join %s. You may have too many channels or the server is not responding.";

-- Joined the channel
SKY_CHANNEL_IS_JOINING = "Attempting to join channel %s.";

-- Joined by index
SKY_CHANNEL_JOIN_BY_INDEX = "Setting /%s to %s.";

-- Removed by index
SKY_CHANNEL_REMOVED_SHORTCUT = "Removed /%s.";

-- Joining too many channel
SKY_CHANNEL_TOO_MANY_CHANNELS = "There are too many channels. Channel %s is no longer joined.";

-- Leaving by index (/leave 3)
SKY_CHANNEL_LEAVE_BY_INDEX = "Leaving /%s.";

-- Leaving by index and name
SKY_CHANNEL_LEAVE_BY_INDEX_AND_NAME = "Leaving /%s. (%s)";

-- Leaving by name (/leave General)
SKY_CHANNEL_LEAVE_BY_NAME = "Leaving channel %s.";

-- Join Help
SKY_JOIN_HELP = "Type /join <channelname> [/shortcut] [password] to create a channel or join an existing one. ";
SKY_LEAVE_HELP = "Type /leave <channelname> or /leave shortcut to leave a channel. ";
SKY_REMOVE_HELP = "Type /remove <shortcut> to remove the chat channel shortcut. (e.g. To remove the /tra shortcut type: \"/remove /tra\" ).";

SKY_UNABLE_TO_JOIN = "Unable to join %s.";
SKY_CHANNEL_SEND = "[%s]:\32";
SKY_CHANNEL_FORMAT = "%s. %s";

-- Leave Warnings
SKY_LEAVE_WARNING_RAID = "|cFFFF3333Warning!|r Leaving the "..SKY_RAID_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_RAID_COLOR.." channel, type /join SkyRaid. (It will add your leader's name to the end automatically.)";
SKY_LEAVE_WARNING_GUILD = "|cFFFF3333Warning!|r Leaving the "..SKY_GUILD_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_GUILD_COLOR.." channel, type /join SkyGuild. (It will add your guild's name to the end automatically.)";
SKY_LEAVE_WARNING_PARTY = "|cFFFF3333Warning!|r Leaving the "..SKY_PARTY_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_PARTY_COLOR.." channel, type /join SkyParty. (It will add your leader's name to the end automatically.)";
SKY_LEAVE_WARNING_ZONE = "|cFFFF3333Warning!|r Leaving the "..SKY_ZONE_COLOR.." channel may cause you to lose the ability to use certain mods. If you wish to reactive the "..SKY_ZONE_COLOR.." channel, type /join SkyZone. (It will add your leader's name to the end automatically.)";
SKY_LEAVE_WARNING_SKY = "|cFFFF3333Warning!|r Leaving the "..SKY_COLOR.." channel may cause you to lose the ability to use many mods. If you wish to reactive the "..SKY_COLOR.." channel, type /join Sky.";

-- Slash commands
SKY_JOIN_COMMANDS = {"/join", "/channel", "/chan"};
SKY_LEAVE_COMMANDS = {"/leave", "/chatleave", "/chatexit"};
SKY_LIST_COMMANDS = {"/list", "/chatlist", "/clist", "/chatinfo"};
SKY_REMOVE_COMMANDS =  {"/remove", "/rem"};
SKY_HELP_COMMANDS =  {"/help", "/skyhelp", "/shelp"};
