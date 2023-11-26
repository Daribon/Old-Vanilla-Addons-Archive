-- Version : French  ( by Sasmira )
-- Last Update : 06/14/2005

if ( GetLocale() == "frFR" ) then

-- Keywords
SKY_GENERAL_ID = "g\195\169n\195\169ral";
SKY_TRADE_ID = "commerce";
SKY_LFG_ID = "recherchegroupe";
SKY_LOCALDEFENSE_ID = "d\195\169fenselocale";
SKY_WORLDDEFENSE_ID = "d\195\169fenseuniverselle";

-- Pretty print for capitalization
SKY_GENERAL_PRETTYPRINT = "G\195\169n\195\169ral";
SKY_TRADE_PRETTYPRINT = "Commerce";
SKY_LFG_PRETTYPRINT = "RechercheGroupe";
SKY_LOCALDEFENSE_PRETTYPRINT = "D\195\169fenseLocale";
SKY_WORLDDEFENSE_PRETTYPRINT = "D\195\169fenseUniverselle";

-- Colored Sky
SKY_COLOR = "|cFF99BBCCSky|r";
SKY_PARTY_COLOR = SKY_COLOR.."|cFF009955Party|r";
SKY_RAID_COLOR = SKY_COLOR.."|cFF770000Raid|r";
SKY_ZONE_COLOR = SKY_COLOR.."|cFF777777Zone|r";
SKY_GUILD_COLOR = SKY_COLOR.."|cFF229922Guild|r";

-- Sky Channels List
SKY_CHANNELS_LIST = "[Activation des canaux Sky : %s]";

-- Zombie Warning!
SKY_UNDEAD_CHANNEL_WARNING = " |cFFFF7777Attention !|r Vous avez actuellement des canaux Zombies  %d  .Ceux-ci ne pouvent \195\170tre supprim\195\169s par "..SKY_COLOR.." et peut entrainer des SPAM !!! S\'il vous plait, quitter le jeu et supprimer le fichier |cFFDDDDDDchat-cache.wtf|r se trouvant dans |cFFDDDDDDWorldOfWarcraft\\WTF\\YourAccountName\\YourCharacterName|r. En esp\195\169rant que Blizzard fixe ce probl\195\168 prochainement. Dans le cans ou vous ne pourriez vous d\195\169connecter, "..SKY_COLOR.." la meilleure solution pour vous sera de cacher le canal, mais les Addons qui ont besoin de Sky peuvent cesser de fonctionner. \n Bonne Chance ! \n Les Canaux sont : %s";

-- Channel is already in list
SKY_CHANNEL_ALREADY_LISTED = "Vous \195\170tes d\195\169j\195\160 dans le canal %s.";

-- Joining too many channel
SKY_CHANNEL_TOO_MANY_CHANNELS = "Il y a trop de canaux. Canal %s n\'est pas accessible.";

-- /command Help
SKY_JOIN_HELP 	= "Taper /join <nom du canal> [/raccourci] [mot de passe] pour cr\195\169er un canal ou joindre un existant. ";
SKY_LEAVE_HELP 	= "Taper /leave <nom du canal> ou /leave [raccourci] pour quitter un canal. ";
SKY_Z_HELP = "Replacer rapidement l\'execution du code /script. ";
SKY_PRINT_HELP = "Afficher le code execut\195\169 dans la fen\195\170tre courante. Exemple /script Sea.io.printf(SELECTED_CHAT_FRAME, msg); ";

SKY_CHANNEL_FORMAT = "%s. %s";

-- Leave Warnings
SKY_LEAVE_WARNING_RAID 	= "|cFFFF3333Attention !|r Quitter le canal "..SKY_RAID_COLOR.." peut entrainer la perte de l\'usage de certains Mods. Si vous souhaitez r\195\169activer le canal "..SKY_RAID_COLOR..", taper /join SkyRaid. ( Il faudra automatiquement ajouter le nom de votre Leader \195\160 la fin.)";
SKY_LEAVE_WARNING_GUILD = "|cFFFF3333Attention !|r Quitter le canal "..SKY_GUILD_COLOR.." peut entrainer la perte de l\'usage de certains Mods. Si vous souhaitez r\195\169activer le canal "..SKY_GUILD_COLOR..", taper /join SkyGuild. ( Il faudra automatiquement ajouter le nom de votre Maitre de Guilde \195\160 la fin.)";
SKY_LEAVE_WARNING_PARTY = "|cFFFF3333Attention !|r Quitter le canal "..SKY_PARTY_COLOR.." peut entrainer la perte de l\'usage de certains Mods. Si vous souhaitez r\195\169activer le canal "..SKY_PARTY_COLOR..", taper /join SkyParty. ( Il faudra automatiquement ajouter le nom de votre Leader \195\160 la fin.)";
SKY_LEAVE_WARNING_ZONE 	= "|cFFFF3333Attention !|r Quitter le canal "..SKY_ZONE_COLOR.." peut entrainer la perte de l\'usage de certains Mods. Si vous souhaitez r\195\169activer le canal "..SKY_ZONE_COLOR..", taper /join SkyZone. ( Il faudra automatiquement ajouter le nom de votre Leader \195\160 la fin.)";
SKY_LEAVE_WARNING_SKY 	= "|cFFFF3333Attention !|r Quitter le canal "..SKY_COLOR.." peut entrainer la perte de l\'usage de certains Mods. Si vous souhaitez r\195\169activer le canal "..SKY_COLOR..", taper /join Sky.";

-- Join Warnings
SKY_JOIN_WARNING_RAID = "Vous ne pouvez pas rejoindre le canal "..SKY_RAID_COLOR..". Vous n\'\195\170tes pas dans Raid.";
SKY_JOIN_WARNING_GUILD = "Vous ne pouvez pas rejoindre le canal"..SKY_GUILD_COLOR.." Vous n\'\195\170tes pas dans Guild.";
SKY_JOIN_WARNING_PARTY = "Vous ne pouvez pas rejoindre le canal"..SKY_PARTY_COLOR.." Vous n\'\195\170tes pas dans Party.";

-- Slash commands
SKY_JOIN_COMMANDS = {"/join", "/channel", "/chan"};
SKY_LEAVE_COMMANDS = {"/leave", "/chatleave", "/chatexit"};
SKY_LIST_COMMANDS = {"/list", "/chatlist", "/clist", "/chatinfo", "/chatwho"};
SKY_HELP_COMMANDS =  {"/help", "/skyhelp", "/shelp"};
SKY_PRINT_COMMANDS =  {"/print"};

-- Capital Cities
CAPITAL_CITIES = {"Orgrimmar", "Cit\195\169 de Stormwind", "Ironforge", "Darnassus", "Undercity", "Thunder Bluff" };

end