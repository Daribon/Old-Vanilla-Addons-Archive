-- Version : German (by DocVanGogh, AnduinLothar, StarDust)
-- Last Update : 08/16/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_ASSISTMEHEADER		= "Hilf Mir!";
	BINDING_NAME_ATTACKTARGETEMOTE		= "Ziel angreifen Emote";
	BINDING_DESCRIPTION_ATTACKTARGETEMOTE	= "Bittet andere Spieler mittels dem '/zielangreifen' Emote dir zu helfen.";
	BINDING_NAME_ASSISTLAST			= "Letztem Spieler Helfen";
	BINDING_DESCRIPTION_ASSISTLAST		= "Dem letzten Schlachtzugmitglied der eigenen Gruppe helfen, welches das '/zielangreifen' Emote verwendet hat.";

	-- Cosmos Configuration
	ASSIST_ME_HEADER			= "Hilf Mir!";
	ASSIST_ME_HEADER_INFO			= "Letztem Spieler helfen und automatische Hilfe.";
	ASSIST_ME_ENABLE_PARTY_TRACK		= "'/assistlast' in der Gruppe aktivieren";
	ASSIST_ME_ENABLE_PARTY_TRACK_INFO	= "Stellt '/assistlast' so ein, da\195\159 dem letzten Gruppenmitglied, welches das '/zielangreifen' Emote verwendet hat, geholfen wird.";
	ASSIST_ME_ENABLE_PARTY			= "Auto-Hilfe in der Gruppe verwenden. (Ben\195\182tigt '/assistlast')";
	ASSIST_ME_ENABLE_PARTY_INFO		= "Hilft automatisch dem letzten Gruppenmitglied, welches das '/zielangreifen' Emote verwendet hat.";
	ASSIST_ME_ENABLE_RAID_TRACK		= "'/assistlast' beim Schlachtzug aktivieren";
	ASSIST_ME_ENABLE_RAID_TRACK_INFO	= "Stellt '/assistlast' so ein, da\195\159 dem letzten Schlachtzugmitglied, welches das '/zielangreifen' Emote verwendet hat, geholfen wird.";
	ASSIST_ME_ENABLE_RAID			= "Auto-Hilfe beim Schlachtzug verwenden. (Ben\195\182tigt '/assistlast')";
	ASSIST_ME_ENABLE_RAID_INFO		= "Hilft automatisch dem letzten Schlachtzugmitglied, welches das '/zielangreifen' Emote verwendet hat.";
	ASSIST_ME_ENABLE_NOTICE			= "Bannerachricht f\195\188r 'Hilf Mir!' aktivieren";
	ASSIST_ME_ENABLE_NOTICE_INFO		= "Zeigt folgende Nachricht am Bildschirm an: X hat dich um Hilfe gebeten! Benutze /assistlast falls die Auto-Hilfe nicht aktiv ist.";

	-- Assist banner
	ASSIST_ME_BANNER_STRING 		= "%s hat dich um Hilfe gebeten!";
	ASSIST_ME_BANNER_NEWBIE_STRING		= "(Benutze /assistlast um zu helfen.)";

	-- following 5 are from the /attack target emote (couldn't find the global variable)
	ASSIST_ME_EMOTE_GET			= "sagt allen, dass sie";
	ASSIST_ME_EMOTE_GET_PARTTWO		= "angreifen sollen.";		--unused
	ASSIST_ME_EMOTE_PARTY_GET		= "sagt euch, dass ihr";
	ASSIST_ME_EMOTE_PARTY_GET_PARTTWO	= "angreifen sollt.";		--unused
	ASSIST_ME_EMOTE_YOU			= "Ihr";

	-- Chat Msgs
	ASSIST_ME_PARTY_TRACK_ENABLED		= "\195\156berwachung der Hilfe in Gruppen aktiviert.";
	ASSIST_ME_PARTY_TRACK_DISABLED		= "\195\156berwachung der Hilfe in Gruppen deaktiviert.";
	ASSIST_ME_PARTY_ENABLED			= "\195\156berwachung der Auto-Hilfe in Gruppen aktiviert.";
	ASSIST_ME_PARTY_DISABLED		= "\195\156berwachung der Auto-Hilfe in Gruppen deaktiviert.";
	ASSIST_ME_RAID_TRACK_ENABLED		= "\195\156berwachung der Hilfe beim Schlachtzug aktiviert.";
	ASSIST_ME_RAID_TRACK_DISABLED		= "\195\156berwachung der Hilfe beim Schlachtzug deaktiviert.";
	ASSIST_ME_RAID_ENABLED			= "\195\156berwachung der Auto-Hilfe beim Schlachtzug aktiviert.";
	ASSIST_ME_RAID_DISABLED			= "\195\156berwachung der Auto-Hilfe beim Schlachtzug deaktiviert.";
	ASSIST_ME_NOTICE_ENABLED		= "Bannernachricht aktiviert.";
	ASSIST_ME_NOTICE_DISABLED		= "Bannernachricht deaktiviert.";

end