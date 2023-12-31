--[[
--	Atlas Localization Data (FRENCH)

-- Initial translation by Sasmira & V�v�

-- Version : French ( by Sasmira, V�v� )
-- Last Update : 07/09/2005

--]]

if ( GetLocale() == "frFR" ) then

ATLAS_TITLE = "Atlas";
ATLAS_VERSION = "1.0.1";
ATLAS_SUBTITLE = "Cartes d\'Instance";
ATLAS_DESC = "Atlas est un navigateur de cartes d\'instance.";
ATLAS_NAME = ATLAS_TITLE.." v"..ATLAS_VERSION;

ATLAS_OPTIONS_BUTTON = "Options";

BINDING_HEADER_ATLAS_TITLE = "Atlas Bindings";
BINDING_NAME_ATLAS_TOGGLE = "[ON/OFF] Atlas";
BINDING_NAME_ATLAS_OPTIONS = "[ON/OFF] Options";

ATLAS_SLASH = "/atlas";
ATLAS_SLASH_OPTIONS = "options";

ATLAS_STRING_LOCATION = "Lieu";
ATLAS_STRING_LEVELRANGE = "Niveau";
ATLAS_STRING_PLAYERLIMIT = "Limite de Joueurs";

ATLAS_BUTTON_TOOLTIP = "[ON/OFF] Atlas";

ATLAS_OPTIONS_TITLE = "Atlas Options";
ATLAS_OPTIONS_SHOWBUT = "Voir le Bouton";
ATLAS_OPTIONS_BUTPOS = "Position du Bouton";
ATLAS_OPTIONS_TRANS = "Transparence";
ATLAS_OPTIONS_DONE = "Ok";





local BLUE = "|cff6666ff";
local GREY = "|cff999999";
local GREN = "|cff66cc33";
local INDENT = "   ";

AtlasText = {
	BlackfathomDeeps = {
		ZoneName = "Profondeurs de Brassenoire";
		Location = "Ashenvale";
		LevelRange = "20-27";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Ghamoo-ra";
		GREY.."2) Manuscrit de Lorgalis";
		GREY.."3) Dame Sarevess";
		GREY.."4) Garde d\'Argent de Thaelrid";
		GREY.."5) Autel de Gelihast";
		GREY.."6) Lorgus Jett";
		GREY.."7) Noyau de Fathom, Baron Aquanis";
		GREY.."8) Seigneur Kelris Cr\195\169pusculaire";
		GREY.."9) Vieux Serra'kis";
		GREY.."10) Aku'mai";
	};
	BlackrockDepths = {
		ZoneName = "Profondeurs de Blackrock";
		Location = "Montagne de Blackrock";
		LevelRange = "48-56";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Seigneur Roccor";
		GREY.."2) Kharan Mighthammer";
		GREY.."3) Marshal Windsor";
		GREY.."4) L\'Ar\195\168ne";
		GREY.."5) Statue de Franclorn Forgewright,";
		GREY..INDENT.."Pyromancier Loregrain (Rare)";
		GREY.."6) La chambre forte";
		GREY.."7) Fineous Darkvire";
		GREY.."8) Enclume Noire, Seigneur Incendius";
		GREY.."9) Bael'Gar";
		GREY.."10) Cl\195\169 Shadowforge";
		GREY.."11) G\195\169n\195\169ral Angerforge";
		GREY.."12) Seigneur Golem Argelmach";
		GREY.."13) Grim Guzzler";
		GREY.."14) Ambassadeur Flamelash";
		GREY.."15) Panzor l\'Invincible (Rare)";
		GREY.."16) Le Tombeau des Sept";
		GREY.."17) Le Lyc\195\169e";
		GREY.."18) Magmus";
		GREY.."19) Empereur Dagran Thaurissan,";
		GREY..INDENT.."Princesse Moira Bronzebeard";
		GREY.."20) La Forge Noire";
		GREY.."21) Coeur du Magma (Raid)";
	};
	BlackrockSpireLower = {
		ZoneName = "Pic de Blackrock (LBRS)";
		Location = "Montagne de Blackrock";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Warosh";
		GREY.."2) Pique de Roughshod";
		GREY.."3) Omokk";
		GREY.."4) Chasseur d\'ombres Vosh'gajin";
		GREY.."5) Maitre de Guerre Voone";
		GREY.."6) Matriarche Couveuse";
		GREY.."7) Croc Cristalin (Rare)";
		GREY.."8) Urok Doomhowl";
		GREY.."9) Intendant Zigris";
		GREY.."10) Halycon, Gizrul l'Esclavagiste";
		GREY.."11) Seigneur Wyrmthalak";
	};
	BlackrockSpireUpper = {
		ZoneName = "Pic de Blackrock (UBRS)";
		Location = "Montagne de Blackrock";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Escalier";
		BLUE.."C) Escalier";
		GREY.."1) Jed Runewatcher (Rare)";
		GREY.."2) Pyrogarde Proph\195\168te Ardent";
		GREY.."3) Fermoir de Doomrigger";
		GREY..INDENT.." Father Flam";
		GREY.."4) Goraluk Anvilcrack";
		GREY.."5) Rend Blackhand et Gyth";
		GREY.."6) Awbee";
		GREY.."7) La B\195\170te";
		GREY.."8) G\195\169n\195\169ral Drakkisath";
		GREY.."9) Rep\195\168re de l\'Aile-Noire";
	};
	DireMaulEast = {
		ZoneName = "Hache-Tripes (Est)";
		Location = "Ferelas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Entr\195\169e";
		BLUE.."C) Entr\195\169e";
		BLUE.."D) Sortie";
		GREY.."1) D\195\169but de la chasse \195\160 Pusillin";
		GREY.."2) Fin de la chasse \195\160 Pusillin";
		GREY.."3) Lethtendris, Hydrospawn,";
		GREY..INDENT.."Zevrim Thornhoof";
		GREY.."4) Viel Ironbark";
		GREY.."5) Alzzin le modeleur";
	};
	DireMaulNorth = {
		ZoneName = "Hache-Tripes (Nord)";
		Location = "Ferelas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Garde Mol'dar";
		GREY.."2) Kreeg le marteleur";
		GREY.."3) Garde Fengus";
		GREY.."4) Garde Slip'kik,";
		GREY..INDENT.."Knot Thimblejack";
		GREY.."5) Captaine Kromcrush";
		GREY.."6) Roi Gordok";
		GREY.."7) Hache-Tripes (Ouest)";
	};
	DireMaulWest = {
		ZoneName = "Hache-Tripes (Ouest)";
		Location = "Ferelas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Les Pyl\195\180nes";
		GREY.."1) L\'Ancien Shen'dralar";
		GREY.."2) Tendris Crochebois";
		GREY.."3) Illyanna Ravenoak,";
		GREY..INDENT.."Magistrat Kalendris";
		GREY.."4) Immol'thar";
		GREY.."5) Prince Tortheldrin";
		GREY.."6) Hache-Tripes (Nord)";
	};
	Gnomeregan = {
		ZoneName = "Gnomeregan";
		Location = "Dun Morogh";
		LevelRange = "24-33";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e (Avant)";
		BLUE.."B) Entr\195\169e (Arri\195\168re)";
		GREY.."1) Retomb\195\169es Visqueuses (Inf\195\169rieur)";
		GREY.."2) Grubbis";
		GREY.."3) Matrice d\'Encodage 3005-B";
		GREY.."4) Zone Propre";
		GREY.."5) Electrocuteur 6000,";
		GREY..INDENT.."Matrice d\'Encodage 3005-C";
		GREY.."6) Mekgineer Thermaplugg";
		GREY.."7) Ambassadeur Dark Iron (Rare)";
		GREY.."8) Faucheur de foule 9-60,";
		GREY..INDENT.."Matrice d\'Encodage 3005-D";
	};
	Maraudon = {
		ZoneName = "Maraudon";
		Location = "Desolace";
		LevelRange = "40-49";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e (Orange)";
		BLUE.."B) Entr\195\169e (Pourpre)";
		BLUE.."C) Entr\195\169e (Portail)";
		GREY.."1) Veng (5eme Khan)";
		GREY.."2) Noxxion";
		GREY.."3) Razorlash";
		GREY.."4) Maraudos (4eme Khan)";
		GREY.."5) Seigneur Vyletongue";
		GREY.."6) Meshlok le collecteur (Rare)";
		GREY.."7) Celebras le maudit";
		GREY.."8) Glissement de tarrain";
		GREY.."9) Artisant Gizlock";
		GREY.."10) Rotgrip";
		GREY.."11) Princesse Theradras";
	};
	MoltenCore = {
		ZoneName = "Coeur du Magma";
		Location = "Profondeurs de Blackrock";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Lucifron";
		GREY.."2) Magmadar";
		GREY.."3) Gehennas";
		GREY.."4) Garr";
		GREY.."5) Shazzrah";
		GREY.."6) Baron Geddon";
		GREY.."7) Golemagg l\'Incin\195\169rateur";
		GREY.."8) Sulfuron Harbinger";
		GREY.."9) Majordomo Executus";
		GREY.."10) Ragnaros";
	};
	OnyxiasLair = {
		ZoneName = "Tani\195\168re d\'Onyxia";
		Location = "Mar\195\169cage d\'Aprefange";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Gardiens Onyxian";
		GREY.."2) Oeufs";
		GREY.."3) Onyxia";
	};
	RagefireChasm = {
		ZoneName = "Gouffre de Ragefeu";
		Location = "Orgrimmar";
		LevelRange = "13-15";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Maur Grimtotem";
		GREY.."2) Taragaman l\'Affam\195\169";
		GREY.."3) Jergosh l\'Invocateur";
		GREY.."4) Bazzalan";
	};
	RazorfenDowns = {
		ZoneName = "Souilles de Tranchebauge";
		Location = "Les Tarides";
		LevelRange = "35-40";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Tuten'kash";
		GREY.."2) Henry Stern, Belnistrasz";
		GREY.."3) Mordresh Oeil de Feu";
		GREY.."4) Glouton";
		GREY.."5) Ragglesnout";
		GREY.."6) Amnennar le Porte-Froid";
	};
	RazorfenKraul = {
		ZoneName = "Krall de Tranchebauge";
		Location = "Les Tarides";
		LevelRange = "25-35";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Roogug";
		GREY.."2) Aggem Thorncurse";
		GREY.."3) M\195\169dium Jargba";
		GREY.."4) Seigneur Ramtusk";
		GREY.."5) Agathelos l\'Enrag\195\169";
		GREY.."6) Chasseur Aveugle (Rare)";
		GREY.."7) Charlga Razorflank";
		GREY.."8) Willix l\'Importateur,";
		GREY..INDENT.."Heralath Fallowbrook";
	};
	ScarletMonastery = {
		ZoneName = "Monast\195\168re Ecarlate";
		Location = "Clairi\195\168re de Tirisfal";
		LevelRange = "30-40";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e (Biblioth\195\168que)";
		BLUE.."B) Entr\195\169e (Armurie)";
		BLUE.."C) Entr\195\169e (Cath\195\169drale)";
		BLUE.."D) Entr\195\169e (Cimeti\195\168re)";
		GREY.."1) Maitre-Chien Loksey";
		GREY.."2) Arcaniste Doan";
		GREY.."3) Herod";
		GREY.."4) Grand Inquisiteur Fairbanks";
		GREY.."5) Commandant Mograine,";
		GREY..INDENT.."Grand Inquisiteur Whitemane";
		GREY.."6) Azshir l\'Insomniaque (Rare),";
		GREY..INDENT.."Champion Mort (Rare),";
		GREY..INDENT.."Ironspine (Rare)";
		GREY.."7) Mage de Sang Thalnos";
	};
	Scholomance = {
		ZoneName = "Scholomance";
		Location = "Maleterres de l\'Ouest";
		LevelRange = "56-60";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Escalier";
		BLUE.."C) Escalier";
		GREY.."1) Titre de propri\195\169t\195\169 de Southshore";
		GREY.."2) Kirtonos le H\195\169rault";
		GREY.."3) Jandice Barov";
		GREY.."4) Titre de propri\195\169t\195\169 de Tarren Mill";
		GREY.."5) Rattlegore (Inf\195\169rieur)";
		GREY.."6) Marduk Blackpool, Vectus";
		GREY.."7) Ras Frostwhisper,";
		GREY..INDENT.."Titre de propri\195\169t\195\169 de Brill";
		GREY.."8) Instructeur Malicia";
		GREY.."9) Docteur Theolen Krastinov";
		GREY.."10) Gardien du Savoir Polkelt";
		GREY.."11) Le Ravenian";
		GREY.."12) Seigneur Alexei Barov,";
		GREY..INDENT.."Titre de propri\195\169t\195\169 de Caer Darrow";
		GREY.."13) Dame Illucia Barov";
		GREY.."14) Sombre Maitre Gandling";
		GREN.."1') Torche Levier";
		GREN.."2') Coffre Secret";
	};
	ShadowfangKeep = {
		ZoneName = "Donjon d\'Ombrecroc";
		Location = "For\195\170t des Pins Argent\195\169s";
		LevelRange = "18-25";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) All\195\169e";
		BLUE.."C) All\195\169e";
		GREY.."1) Deathstalker Adamant,";
		GREY..INDENT.."Sorcier Ashcrombe,";
		GREY..INDENT.."Rethilgore";
		GREY.."2) Razorclaw the Butcher";
		GREY.."3) Baron Silverlaine";
		GREY.."4) Commander Springvale";
		GREY.."5) Odo the Blindwatcher";
		GREY.."6) Fenrus the Devourer";
		GREY.."7) Wolf Master Nandos";
		GREY.."8) Archmage Arugal";
	};
	Stratholme = {
		ZoneName = "Stratholme";
		Location = "Maleterres de l\'Est";
		LevelRange = "55-60";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e (Avant)";
		BLUE.."B) Entr\195\169e (cot\195\169)";
		BLUE.."C) Boite \195\160 lettres, Malown le Facteur";
		GREY.."1) Fras Siabi, Stratholme Courier,";
		GREY..INDENT.."Skul (Rare, Vari\195\169)";
		GREY.."2) Hearthsinger Forresten";
		GREY..INDENT.."(Rare, Errant)";
		GREY.."3) Timmy le Cruel";
		GREY.."4) Maitre Cannonier Willey";
		GREY.."5) Archiviste Galford";
		GREY.."6) Balnazzar";
		GREY.."7) Aurius";
		GREY.."8) Stonespine (Rare)";
		GREY.."9) Barone Anastari";
		GREY.."10) Nerub'enkan";
		GREY.."11) Maleki the Pallid";
		GREY.."12) Magistrate Barthilas (Vari\195\169)";
		GREY.."13) Ramstein the Gorger";
		GREY.."14) Baron Rivendare";
	};
	TheDeadmines = {
		ZoneName = "Les Mortes Mines";
		Location = "Marche de l\'Ouest";
		LevelRange = "15-20";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Exit";
		GREY.."1) Rhahk'Zor";
		GREY.."2) Miner Johnson (Rare)";
		GREY.."3) Sneed";
		GREY.."4) Gilnid";
		GREY.."5) Defias Gunpowder";
		GREY.."6) Captain Greenskin, Cookie,";
		GREY..INDENT.."Edwin VanCleef, Mr. Smite";
	};
	TheStockades = {
		ZoneName = "La Prison";
		Location = "Stormwind";
		LevelRange = "23-26";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Targorr the Dread (Vari\195\169)";
		GREY.."2) Kam Deepfury";
		GREY.."3) Hamhock";
		GREY.."4) Bazil Thredd";
		GREY.."5) Dextren Ward";
		GREY.."6) Bruegal Ironknuckle (Rare)";
	};
	TheSunkenTemple = {
		ZoneName = "Temple d\'Atal\'Hakkar";
		Location = "Marais des chagrins";
		LevelRange = "44-50";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Escalier";
		BLUE.."C) Troll Minibosses (sup\195\169rieur)";
		GREY.."1) Altar d\'Hakkar, Atal'alarion";
		GREY.."2) Weaver, Dreamscythe";
		GREY.."3) Avatar d\'Hakkar";
		GREY.."4) Jammal'an le Proph\195\168te,";
		GREY..INDENT.."Ogom the Wretched";
		GREY.."5) Morphaz, Hazzas";
		GREY.."6) Shade of Eranikus, Essence Font";
		GREN.."1'-6') Ordre d\'Activation de Statue";
	};
	Uldaman = {
		ZoneName = "Uldaman";
		Location = "Terres ingrates";
		LevelRange = "35-45";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e (Avant)";
		BLUE.."B) Entr\195\169e (Arri\195\168re)";
		GREY.."1) Baelog";
		GREY.."2) Restes de Paladin";
		GREY.."3) Revelosh";
		GREY.."4) Ironaya";
		GREY.."5) Sentinelle d\'Obsidien";
		GREY.."6) Annora (Maitre Enchanteur)";
		GREY.."7) Garde en pierre Antique";
		GREY.."8) Galgann Firehammer";
		GREY.."9) Grimlok";
		GREY.."10) Archaedas (Inf\195\169rieur)";
		GREY.."11) les disques de Norgannon,";
		GREY..INDENT.."Tr\195\169sor Antique (Inf\195\169rieur)";
	};
	WailingCaverns = {
		ZoneName = "Cavernes des lamentations";
		Location = "Les Tarides";
		LevelRange = "15-21";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Disciple de Naralex";
		GREY.."2) Seigneur Cobrahn";
		GREY.."3) Dame Anacondra";
		GREY.."4) Kresh";
		GREY.."5) Seigneur Pythas";
		GREY.."6) Skum";
		GREY.."7) Seigneur Serpentis (sup\195\169rieur)";
		GREY.."8) Verdan the Everliving (sup\195\169rieur)";
		GREY.."9) Mutanus the Devourer, Naralex";
	};
	ZulFarrak = {
		ZoneName = "Zul'Farrak";
		Location = "D\195\169sert de Tanaris";
		LevelRange = "43-47";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		GREY.."1) Antu'sul";
		GREY.."2) Theka le Martyre";
		GREY.."3) Sorcier Docteur Zum'rah,";
		GREY..INDENT.."H\195\169ros Mort Zul'Farrak";
		GREY.."4) Nekrum Gutchewer";
		GREY.."5) Sergent Bly";
		GREY.."6) Hydromancienne Velratha,";
		GREY..INDENT.."Gahz'rilla";
		GREY.."7) Ukorz Sandscalp, Ruuzlu";
		GREY.."8) Zerillis (Rare, Errant)";
	};
};

end
