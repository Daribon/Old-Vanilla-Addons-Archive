-- Version : German (by StarDust)
-- Last Update : 03/07/2005

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
	
	-- Pretty print for other channels
	SKY_CHANNEL_PRETTYPRINT		= "Sky";
	SKY_PARTY_PRETTYPRINT		= "SkyGruppe";
	SKY_RAID_PRETTYPRINT		= "Sky\195\156berfall";
	SKY_ZONE_PRETTYPRINT		= "SkyZone";
	SKY_GUILD_PRETTYPRINT		= "SkyGilde";

	-- Colored Sky
	SKY_COLOR			= "|cFF99BBCCSky|r";
	SKY_PARTY_COLOR			= SKY_COLOR.."|cFF009955Gruppe|r";
	SKY_RAID_COLOR			= SKY_COLOR.."|cFF770000\195\156berfall|r";
	SKY_ZONE_COLOR			= SKY_COLOR.."|cFF777777Zone|r";
	SKY_GUILD_COLOR			= SKY_COLOR.."|cFF229922Gilde|r";
	
	-- Sky Channels List	
	SKY_CHANNELS_LIST		= "[Aktive Sky-Channels: %s]";	

	-- Zombie Warning!
	SKY_UNDEAD_CHANNEL_WARNING	= " |cFFFF7777Warnung!|r Du hast momentan %d inaktive Channels. Jene k\195\182nnen von "..SKY_COLOR.." nicht entfernt werden, wodurch eventuell in jenen Spam entsteht! Bitte beende das Spiel und l\195\182sche die Datei |cFFDDDDDDchat-cache.txt|r im Verzeichnis |cFFDDDDDDWorldOfWarcraft\\WTF\\DeinAccountName\\DeinCharakterName|r. Blizzard wird dieses Problem hoffentlich in naher Zukunft beheben. Falls du das Spiel nicht beenden kannst oder willst wird "..SKY_COLOR.." sein bestes tun um diese Channels auszublenden, allerdings treten dann m\195\182glicherweise bei Funktionen die Sky benutzen Fehler auf. \n Viel Gl\195\188ck!";
	
	-- AutoJoin
	SKY_AUTO_JOIN_CHANNEL_WARNING = " |cFFFF7777Warnung!|r Ein verwendetes AddOn ist dem Channel %s automatisch beigetreten. Sky hat dies erkannt und wird nicht versuchen jenen Channel zu entfernen. Bitte beachte, dass Addons welche Channels automatisch beitreten die Funktionalit\195\164t von Sky beeintr\195\164chtigen k\195\182nnen. Um dies zu verhindern, tippe \"/z SkyNotices.autoJoinOn = false;\" ein.";

	-- AutoJoin
	SKY_FIRST_TIME_WARNING = "Willkommen bei Sky. \nBei der ersten Verwendung von Sky werden alle Channels automatisch zur\195\188ckgesetzt. Sie m\195\188ssen lediglich mittels /join oder /leave den gew\195\188nschten Channels beitreten oder jene verlassen. Sky wurde entwickelt um es AddOns zu erm\195\182glichen im Hintergrund Informationen zu teilen. So zum Beispiel das AddOn \"Gruppen Quest\", welches es erlaubt die Quests von Gruppenmitgliedern zu betrachten und zu teilen oder der \"\195\156berfall Gehilfe\", welcher die Gesundheit aller Mitglieder anzeigt.";

	-- Channel is already in list
	SKY_CHANNEL_ALREADY_LISTED	= "Du bist dem Channel %s bereits beigetreten.";
	
	-- Password is updated
	SKY_CHANNEL_PASSWORD_UPDATED	= "Dein Passwort f\195\188r den Channel %s wurde aktualisiert.";
	
	-- Joined the channel, but it did not work!
	SKY_CHANNEL_JOINED_BUT_INACTIVE = "Du versuchst bereits dem Channel %s beizutreten. M\195\182glicherweise bist du bereits in zu vielen Channels oder der Server reagiert nicht.";
	
	-- Joined the channel	
	SKY_CHANNEL_IS_JOINING		= "Trete Channel %s bei.";

	-- Joined by index
	SKY_CHANNEL_JOIN_BY_INDEX	= "Setze /%s auf %s.";
	
	-- Removed by index
	SKY_CHANNEL_REMOVED_SHORTCUT	= "/%s entfernt.";
	
	-- Joining too many channel
	SKY_CHANNEL_TOO_MANY_CHANNELS	= "Es gibt zu viele Channels. Channel %s wurde verlassen.";
	
	-- Leaving by index (/leave 3)
	SKY_CHANNEL_LEAVE_BY_INDEX	= "Verlasse Channel /%s.";

	-- Leaving by index and name
	SKY_CHANNEL_LEAVE_BY_INDEX_AND_NAME = "Verlasse Channel /%s. (%s)";

	-- Leaving by name (/leave General)
	SKY_CHANNEL_LEAVE_BY_NAME	= "Verlasse Channel %s.";

	-- Join Help
	SKY_JOIN_HELP			= "Gib /join <ChannelName> [/Abk\195\188rzung] [Passwort] ein um einen neuen Channel anzulegen oder einem bestehenden beizutreten.";
	SKY_LEAVE_HELP			= "Gib /leave <ChannelName> or /leave <Abk\195\188rzung> ein um einen Channel zu verlassen.";
	SKY_REMOVE_HELP			= "Gib /remove <Abk\195\188rzung> ein um die Abk\195\188rzung des Channels zu entfernen. (Um z.B. die Abk\195\188rzung /tra zu entfernen, gib : \"/remove /tra\" ein).";

	SKY_UNABLE_TO_JOIN		= "Kann %s nicht beitreten.";
	SKY_CHANNEL_SEND		= "[%s]:\32";
	SKY_CHANNEL_FORMAT		= "%s. %s";
	
	-- Leave Warnings
	SKY_LEAVE_WARNING_RAID		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_RAID_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_RAID_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyRaid ein. (It will add your leader's name to the end automatically.)";
	SKY_LEAVE_WARNING_GUILD		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_GUILD_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_GUILD_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyGuild ein. (Dein Gildenname wir automatisch an das Ende angereiht.)";
	SKY_LEAVE_WARNING_PARTY		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_PARTY_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_PARTY_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyParty ein. (It will add your leader's name to the end automatically.)";
	SKY_LEAVE_WARNING_ZONE		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_ZONE_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_ZONE_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join SkyZone ein. (It will add your leader's name to the end automatically.)";
	SKY_LEAVE_WARNING_SKY		= "|cFFFF3333Warnung!|r Das verlassen des "..SKY_COLOR.." Channels kann dazu f\195\188hren, da\195\159 einige AddOns nicht mehr funktionieren. Falls du dem "..SKY_COLOR.." Channel wieder beitreten m\195\182chtest, gib /join Sky ein.";
	
end