-- Version : German (by StarDust)
-- Last Update : 02/21/2005

if ( GetLocale() == "deDE" ) then
	-- Binding Configuration
	BINDING_HEADER_ASSISTMEHEADER		= "Hilf Mir!";
	BINDING_NAME_ATTACKTARGETEMOTE		= "Emote : Ziel angreifen";
	BINDING_DESCRIPTION_ATTACKTARGETEMOTE	= "Bittet andere Spieler dir zu helfen, wobei das '/attacktarget' Emote verwendet wird.";
	BINDING_NAME_ASSISTLAST			= "Letztem Spieler Helfen";
	BINDING_DESCRIPTION_ASSISTLAST		= "Dem letzten Gruppen- oder Raid-Mitglied helfen, welches das '/attacktarget' Emote verwendet hat.";

	-- Cosmos Configuration
	ASSIST_ME_HEADER			= "Hilf Mir!";
	ASSIST_ME_HEADER_INFO			= "Letztem Spieler helfen und automatische Hilfe.";
	ASSIST_ME_ENABLE_PARTY_TRACK		= "'/assistlast' in der Gruppe aktivieren";
	ASSIST_ME_ENABLE_PARTY_TRACK_INFO	= "Legt '/assistlast' fest um dem letzten Gruppenmitglied zu helfen, welches das '/attacktarget' Emote verwendet hat.";
	ASSIST_ME_ENABLE_PARTY			= "Auto-Hilfe in der Gruppe verwenden. (Ben\195\182tigt '/assistlast')";
	ASSIST_ME_ENABLE_PARTY_INFO		= "Hilft automatisch dem letzten Gruppenmitglied, welches das '/attacktarget' Emote verwendet hat.";
	ASSIST_ME_ENABLE_RAID_TRACK		= "'/assistlast' beim Raid (\195\156berfall) verwenden.";
	ASSIST_ME_ENABLE_RAID_TRACK_INFO	= "Legt '/assistlast' fest um dem letzten Raidmitglied zu helfen, welches das '/attacktarget' Emote verwendet hat.";
	ASSIST_ME_ENABLE_RAID			= "Auto-Hilfe beim Raid (\195\156berfall) verwenden. (Ben\195\182tigt '/assistlast')";
	ASSIST_ME_ENABLE_RAID_INFO		= "Hilft automatisch dem letzten Raidmitglied, welches das '/attacktarget' Emote verwendet hat.";
	ASSIST_ME_ENABLE_NOTICE			= "Bannerachricht f\195\188r 'Hilf Mir!' verwenden";
	ASSIST_ME_ENABLE_NOTICE_INFO		= "Zeigt folgende Nachricht am Bildschirm an: X hat dich um Hilfe gebeten! Benutze /assistlast falls die Auto-Hilfe nicht aktiv ist.";

	-- Assist banner
	ASSIST_ME_BANNER_STRING 		= "%s hat dich um Hilfe gebeten!";
	ASSIST_ME_BANNER_NEWBIE_STRING		= "(Benutze /assistlast um zu helfen.)";

	-- following 3 are from the /attack target emote (couldn't find the global variable)
	ASSIST_ME_EMOTE_GET			= "tells everyone to attack";
	ASSIST_ME_EMOTE_PARTY_GET		= "tells you to attack";
	ASSIST_ME_EMOTE_YOU			= "You";

	-- Chat Msgs
	ASSIST_ME_PARTY_TRACK_ENABLED		= "\195\156berwachung der Hilfe in Gruppen aktiviert.";
	ASSIST_ME_PARTY_TRACK_DISABLED		= "\195\156berwachung der Hilfe in Gruppen deaktiviert.";
	ASSIST_ME_PARTY_ENABLED			= "\195\156berwachung der Auto-Hilfe in Gruppen aktiviert.";
	ASSIST_ME_PARTY_DISABLED		= "\195\156berwachung der Auto-Hilfe in Gruppen deaktiviert.";
	ASSIST_ME_RAID_TRACK_ENABLED		= "\195\156berwachung der Hilfe im Raid aktiviert.";
	ASSIST_ME_RAID_TRACK_DISABLED		= "\195\156berwachung der Hilfe im Raid deaktiviert.";
	ASSIST_ME_RAID_ENABLED			= "\195\156berwachung der Auto-Hilfe im Raidr aktiviert.";
	ASSIST_ME_RAID_DISABLED			= "\195\156berwachung der Auto-Hilfe im Raid deaktiviert.";
	ASSIST_ME_NOTICE_ENABLED		= "Bannernachricht aktiviert.";
	ASSIST_ME_NOTICE_DISABLED		= "Bannernachricht deaktiviert.";

end