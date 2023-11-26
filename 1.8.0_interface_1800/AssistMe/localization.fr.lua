-- Version : German (by Kaworu-kun, AnduinLothar)
-- Last Update : 02/17/2005
if ( GetLocale() == "frFR" ) then

BINDING_HEADER_ASSISTMEHEADER			= "Assistez Moi!";
BINDING_NAME_ATTACKTARGETEMOTE			= "Emote Voix Attaque Cible";
BINDING_DESCRIPTION_ATTACKTARGETEMOTE	= "Annoncer aux autres de vous assister via l' émote voix '/attaquecible'.";
BINDING_NAME_ASSISTLAST					= "Assister le Dernier";
BINDING_DESCRIPTION_ASSISTLAST			= "Assister le dernier membre du groupe/raid qui a utilisé l'émote voix '/attaquecible'.";

ASSIST_ME_HEADER					= "Assistez Moi!";
ASSIST_ME_HEADER_INFO				= "Assiste le Dernier et Auto-Assiste.";
ASSIST_ME_ENABLE_PARTY_TRACK		= "Active '/assistlast' pour le Groupe.";
ASSIST_ME_ENABLE_PARTY_TRACK_INFO   = "Configure '/assistlast' pour qu'il assiste le dernier membre du groupe qui a utilisé l'émote voix '/attaquecible'.";
ASSIST_ME_ENABLE_PARTY				= "Active l'Auto-Assiste pour le Groupe. (Necessite '/assistlast')";
ASSIST_ME_ENABLE_PARTY_INFO			= "Assiste automatiquement n'importe quel membre du groupe qui utilise l'émote voix '/attaquecible'.";
ASSIST_ME_ENABLE_RAID_TRACK			= "Active '/assistlast' pour le Raid.";
ASSIST_ME_ENABLE_RAID_TRACK_INFO	= "Configure '/assistlast' pour qu'il assiste le dernier membre du raid qui a utilisé l'émote voix '/attaquecible'.";
ASSIST_ME_ENABLE_RAID				= "Active l'Auto-Assist pour le Raid. (Necessite '/assistlast')";
ASSIST_ME_ENABLE_RAID_INFO			= "Assiste automatiquement n'importe quel membre du raid qui utilise l'émote voix '/attaquecible'";
ASSIST_ME_ENABLE_NOTICE				= "Active les bannières de notifications pour l'addon Assistez-Moi";
ASSIST_ME_ENABLE_NOTICE_INFO		= "Affiche le message: X vous demande de l'assister! Utilisez /assistlast si vous avez désactivé l'auto-assiste.";

-- Assist banner
ASSIST_ME_BANNER_STRING 			= "%s vous demande de l'assister!";
ASSIST_ME_BANNER_NEWBIE_STRING = 	"(Tappez /assistlast pour assister)";

--following 3 are from the /attack target emote (couldn't find the global variable)
ASSIST_ME_EMOTE_GET					= "dit à tout le monde d'attaquer";
ASSIST_ME_EMOTE_PARTY_GET			= "vous dit d'attaquer";
ASSIST_ME_EMOTE_YOU					= "Vous";

--Chat Msgs
ASSIST_ME_PARTY_TRACK_ENABLED		= "Surveillance de l'assiste du Groupe activé";
ASSIST_ME_PARTY_TRACK_DISABLED		= "Surveillance de l'assiste du Groupe désactivé";
ASSIST_ME_PARTY_ENABLED				= "Auto-Assiste du Groupe activé";
ASSIST_ME_PARTY_DISABLED			= "Auto-Assiste du Groupe désactivé";
ASSIST_ME_RAID_TRACK_ENABLED		= "Surveillance de l'assiste du Raid activé";
ASSIST_ME_RAID_TRACK_DISABLED		= "Surveillance de l'assiste du Raid désactivé";
ASSIST_ME_RAID_ENABLED				= "Auto-Assiste du Raid activé";
ASSIST_ME_RAID_DISABLED				= "Auto-Assiste du Raid désactivé";
ASSIST_ME_NOTICE_ENABLED			= "Messages de notifications activés";
ASSIST_ME_NOTICE_DISABLED			= "Messages de notifications désactivés";


elseif ( GetLocale() == "deDE" ) then
	-- /attacktarget = /zielangreifen
	
	--following '3' are from the /attack target emote (couldn't find the global variable)
	ASSIST_ME_EMOTE_GET					= "sagt allen, dass Ihr";
	ASSIST_ME_EMOTE_GET_PARTTWO			= "angreifen sollt."; --unused
	ASSIST_ME_EMOTE_PARTY_GET			= "sagt Euch, dass Ihr";
	ASSIST_ME_EMOTE_PARTY_GET_PARTTWO   = "angreifen sollt."; --unused
	ASSIST_ME_EMOTE_YOU					= "Ihr";


end
