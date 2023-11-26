-- Version : German (by StarDust)
-- Last Update : 03/10/2005

if ( GetLocale() == "deDE" ) then

	-- Keywords
	SKY_GENERAL_ID			= "allgemein";
	SKY_TRADE_ID			= "handel";
	SKY_LFG_ID			= "suchenachgruppe";
	SKY_LOCALDEFENSE_ID		= "lokaleverteidigung";
	SKY_WORLDDEFENSE_ID		= "weltverteidigung";
	
	-- Pretty print for capitalization
	SKY_GENERAL_PRETTYPRINT		= "Allgemein";
	SKY_TRADE_PRETTYPRINT		= "Handel";
	SKY_LFG_PRETTYPRINT		= "SucheNachGruppe";
	SKY_LOCALDEFENSE_PRETTYPRINT	= "LokaleVerteidigung";
	SKY_WORLDDEFENSE_PRETTYPRINT	= "WeltVerteidigung";
	
	-- Colored Sky
	SKY_COLOR			= "|cFF99BBCCSky|r";
	SKY_PARTY_COLOR			= SKY_COLOR.."|cFF009955Gruppe|r";
	SKY_RAID_COLOR			= SKY_COLOR.."|cFF770000Schlachtzug|r";
	SKY_ZONE_COLOR			= SKY_COLOR.."|cFF777777Zone|r";
	SKY_GUILD_COLOR			= SKY_COLOR.."|cFF229922Gilde|r";
	
	-- Sky Channels List	
	SKY_CHANNELS_LIST		= "[Aktive Sky-Channels: %s]";	

	-- Zombie Warning!
	SKY_UNDEAD_CHANNEL_WARNING	= " |cFFFF7777Warnung!|r Du hast momentan %d inaktive Channels. Jene k\195\182nnen von "..SKY_COLOR.." nicht entfernt werden, wodurch eventuell in jenen Spam entsteht! Bitte beende das Spiel und l\195\182sche die Datei |cFFDDDDDDchat-cache.txt|r im Verzeichnis |cFFDDDDDDWorldOfWarcraft\\WTF\\DeinAccountName\\DeinCharakterName|r. Blizzard wird dieses Problem hoffentlich in naher Zukunft beheben. Falls du das Spiel nicht beenden kannst oder willst wird "..SKY_COLOR.." sein bestes tun um diese Channels auszublenden, allerdings treten dann m\195\182glicherweise bei Funktionen die Sky benutzen Fehler auf.\nViel Gl\195\188ck!\nInaktive Channels: %s";
	
	-- Channel is already in list
	SKY_CHANNEL_ALREADY_LISTED	= "Du bist dem Channel %s bereits beigetreten.";

	-- Joining too many channel
	SKY_CHANNEL_TOO_MANY_CHANNELS	= "Es gibt zu viele Channels. Du musst einen verlassen um Channel '%s' beizutreten.";

	-- /command Help
	SKY_JOIN_HELP			= "Gib /join <ChannelName> [Passwort] ein um einen neuen Channel anzulegen oder einem bestehenden beizutreten.";
	SKY_LEAVE_HELP			= "Gib /leave <ChannelName> or /leave [ChannelNummer] ein um einen Channel zu verlassen.";
	SKY_Z_HELP			= "K\195\188rzerer Ersatz f\195\188r das Ausf\195\188hren von /script Code.";
	SKY_PRINT_HELP			= "Ausgef\195\188hrten Code im aktuellen Chatfenster ausgeben. Abk\195\188rzung f\195\188r /script Sea.io.printf(SELECTED_CHAT_FRAME, msg);";

	SKY_CHANNEL_FORMAT		= "%s. %s";

	-- Leave Warnings
	SKY_LEAVE_WARNING_RAID		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_RAID_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_RAID_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyRaid ein. (It will add your leader's name to the end automatically.)";
	SKY_LEAVE_WARNING_GUILD		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_GUILD_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_GUILD_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyGuild ein. (Dein Gildenname wir automatisch an das Ende angereiht.)";
	SKY_LEAVE_WARNING_PARTY		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_PARTY_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_PARTY_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyParty ein. (It will add your leader's name to the end automatically.)";
	SKY_LEAVE_WARNING_ZONE		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_ZONE_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_ZONE_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyZone ein. (It will add your leader's name to the end automatically.)";
	SKY_LEAVE_WARNING_SKY		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join Sky ein.";
	
	-- Join Warnings
	SKY_JOIN_WARNING_RAID		= "Kann dem Channel "..SKY_RAID_COLOR.." nicht beitreten. Du befindest dich in keinem Schlachtzug.";
	SKY_JOIN_WARNING_GUILD		= "Kann dem Channel "..SKY_GUILD_COLOR.." nicht beitreten. Du befindest dich in keiner Gilde.";
	SKY_JOIN_WARNING_PARTY		= "Kann dem Channel "..SKY_PARTY_COLOR.." nicht beitreten. Du befindest dich in keiner Gruppe.";

	-- Slash commands
	SKY_JOIN_COMMANDS		= {"/join", "/beitreten", "/channel", "/chan"};
	SKY_LEAVE_COMMANDS		= {"/leave", "/verlassen", "/chatleave", "/chatexit", "/chatverlassen"};
	SKY_LIST_COMMANDS		= {"/list", "/liste", "/chatlist", "/chatliste", "/clist", "/cliste", "/chatinfo"};
	SKY_HELP_COMMANDS		= {"/help", "/hilfe", "/skyhelp", "/skyhilfe", "/shelp", "/shilfe"};
	SKY_PRINT_COMMANDS		= {"/print", "/drucken"};

	-- Capital Cities
	--CAPITAL_CITIES		= {"Orgrimmar", "Stormwind City", "Ironforge", "Darnassus", "Undercity", "Thunder Bluff"};
	
end