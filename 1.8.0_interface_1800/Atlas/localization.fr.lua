if ( GetLocale() == "frFR" ) then



-- French (Français)
-- Localisation: Sparrows 
-- Merci a Razark pour se superbe mod.
-- http://www.curse-gaming.com/mod.php?addid=539



ATLAS_TITLE = "Atlas [FR]";
ATLAS_SUBTITLE = "Cartes d\'Instance";
ATLAS_DESC = "Atlas est un navigateur de cartes d\'instance.";
ATLAS_NAME = ATLAS_TITLE.." v"..ATLAS_VERSION;

ATLAS_OPTIONS_BUTTON = "Options";

BINDING_HEADER_ATLAS_TITLE = "Atlas Bindings";
BINDING_NAME_ATLAS_TOGGLE = "Atlas [ON/OFF]";
BINDING_NAME_ATLAS_OPTIONS = "Options [ON/OFF]";

ATLAS_SLASH = "/atlas";
ATLAS_SLASH_OPTIONS = "options";

ATLAS_STRING_LOCATION = "Lieu";
ATLAS_STRING_LEVELRANGE = "Niveau";
ATLAS_STRING_PLAYERLIMIT = "Limitation de joueurs";

ATLAS_BUTTON_TOOLTIP = "Atlas [ON/OFF]";

ATLAS_OPTIONS_TITLE = "Atlas Options";
ATLAS_OPTIONS_SHOWBUT = "Voir le Buton";
ATLAS_OPTIONS_AUTOSEL = "Choix automatique";
ATLAS_OPTIONS_BUTPOS = "Position du Bouton";
ATLAS_OPTIONS_TRANS = "Transparence";
ATLAS_OPTIONS_DONE = "Valider";





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
		GREY.."6) Lorgus Jett (Variable)";
		GREY.."7) Noyau de Fathom, Baron Aquanis";
		GREY..INDENT.." Fathom Core (Noyau de Brasse)";
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
		GREY.."3) Commandant Gor'shak";
		GREY.."4) Marshal Windsor";
		GREY.."5) Grand Interrogateur Gerstahn ";
		GREY.."6) L\'Ar\195\168ne";
		GREY.."7) Statue de Franclorn Forgewright";
		GREY..INDENT.." Pyromancier Loregrain (Rare)";
		GREY.."8) La chambre forte";
		GREY.."9) Fineous Darkvire";
		GREY.."10) L'Enclume Noire";
		GREY..INDENT.." Seigneur Incendius";
		GREY.."11) Bael'Gar";
		GREY.."12) Serrure De Shadowforge";
		GREY.."13) G\195\169n\195\169ral Angerforge";
		GREY.."14) Seigneur Golem Argelmach";
		GREY.."15) Grim Guzzler";
		GREY.."16) Ambassadeur Flamelash";
		GREY.."17) Panzor l\'Invincible (Rare)";
		GREY.."18) Le Tombeau des Sept";
		GREY.."19) Le Lyc\195\169e";
		GREY.."20) Magmus";
		GREY.."21) Empereur Dagran Thaurissan";
		GREY..INDENT.." Princesse Moira Bronzebeard";
		GREY.."22) La Forge Noire";
		GREY.."23) Coeur du Magma (Molten Core)";
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
		GREY..INDENT.." Cinqui\195\169me tablette Mosh'aru";
		GREY.."5) Maitre de Guerre Voone";
		GREY..INDENT.." Sixi\195\169me tablette Mosh'aru";
		GREY.."6) Matriarche Couveuse";
		GREY.."7) Croc Cristalin (Rare)";
		GREY.."8) Urok Doomhowl";
		GREY.."9) Intendant Zigris";
		GREY.."10) Gizrul l'Esclavagiste";
		GREY..INDENT.."Halycon";
		GREY.."11) Seigneur Wyrmthalak";
		GREY.."12) Bannok Grimaxe (Rare)";
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
		GREY.."5) Chef de Guerre Rend Blackhand";
		GREY..INDENT.." Gyth";
		GREY.."6) Awbee";
		GREY.."7) La B\195\170te";
		GREY.."8) G\195\169n\195\169ral Drakkisath";

		GREY.."9) Rep\195\168re de l\'Aile-Noire";

	};
	BlackwingLair = {
		ZoneName = "Rep\195\168re de l\'Aile-Noire";
		Location = "Pic de Blackrock ";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Chemin";
		BLUE.."C) Chemin";
		BLUE.."D) Chemin";
		GREY.."1) Razorgorel'indompt\195\169";
		GREY.."2) Vaelastrasz le corrompu";
		GREY.."3) Seigneur des couv\195\169es Lashlayer";
		GREY.."4) Gueule de Feu ";
		GREY.."5) Ebonroc";
		GREY.."6) Flamegor";
		GREY.."7) Chromaggus";
		GREY.."8) Nefarian";
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
		GREY.."3) Zevrim Thornhoof";
		GREY..INDENT.." Hydrospawn";
		GREY..INDENT.." Lethtendris";
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

		GREY.."4) Knot Thimblejack";
		GREY..INDENT.." Garde Slip'kik";
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

		GREY..INDENT.." Magistrat Kalendris";
		GREY.."4) Tsu'Zee (Rare)";
		GREY.."5) Immol'thar";
		GREY.."6) Prince Tortheldrin";
		GREY.."7) Hache-Tripes (Nord)";
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

		GREY..INDENT.." Matrice d\'Encodage 3005-C";

		GREY.."6) Mekgineer Thermaplugg";

		GREY.."7) Ambassadeur Dark Iron (Rare)";

		GREY.."8) Faucheur de foule 9-60,";

		GREY..INDENT.." Matrice d\'Encodage 3005-D";

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
		ZoneName = "Coeur du Magma (MC)";

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
		GREY.."2) Henry Stern";
		GREY..INDENT.." Belnistrasz";
		GREY.."3) Mordresh Oeil de Feu";
		GREY.."4) Glouton";
		GREY.."5) Ragglesnout (Rare)";
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

		GREY..INDENT.." Heralath Fallowbrook";

		GREY.."9) Implorateur de la terre Halmgar";
		GREY..INDENT.." (Rare)";
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

		GREY..INDENT.." Grand Inquisiteur Whitemane";

		GREY.."6) Ironspine (Rare)";
		GREY.."7) Azshir l\'Insomniaque (Rare)";
		GREY.."8) Champion Mort (Rare)";
		GREY.."9) Mage de Sang Thalnos";
	};
	Scholomance = {
		ZoneName = "Scholomance";

		Location = "Maleterres de l\'Ouest";

		LevelRange = "56-60";

		PlayerLimit = "10";

		BLUE.."A) Entr\195\169e";

		BLUE.."B) Escalier";

		BLUE.."C) Escalier";

		GREY.."1) Autel pour Kirtonos";
		GREY..INDENT.." Titre de propri\195\169t\195\169 de Southshore";
		GREY.."2) Kirtonos le H\195\169rault";
		GREY.."3) Jandice Barov";
		GREY.."4) Titre de propri\195\169t\195\169 de Tarren Mill";
		GREY.."5) Rattlegore (Inf\195\169rieur)";
		GREY.."6) Marduk Blackpool";
		GREY..INDENT.." Vectus";
		GREY.."7) Ras Frostwhisper";
		GREY..INDENT.." Titre de propri\195\169t\195\169 de Brill";
		GREY.."8) Instructeur Malicia";
		GREY.."9) Docteur Theolen Krastinov";
		GREY.."10) Gardien du Savoir Polkelt";
		GREY.."11) Le Ravenian";
		GREY.."12) Seigneur Alexei Barov";
		GREY..INDENT.." Titre de propri\195\169t\195\169 de Caer Darrow";
		GREY.."13) Dame Illucia Barov";
		GREY.."14) Sombre Maitre Gandling";
		GREN.."1') Torche Levier";
		GREN.."2') Coffre Secret";
		GREN.."3') Laboratoire D\'Alchimie";
	};
	ShadowfangKeep = {
		ZoneName = "Donjon d\'Ombrecroc";

		Location = "For\195\170t des Pins Argent\195\169s";

		LevelRange = "18-25";

		PlayerLimit = "10";

		BLUE.."A) Entr\195\169e";

		BLUE.."B) All\195\169e";

		BLUE.."C) All\195\169e";

		BLUE..INDENT.." Capitaine Deathsworn (Rare)";
		GREY.."1) Deathstalker Adamant";
		GREY..INDENT.." Sorcier Ashcrombe";
		GREY..INDENT.." Rethilgore";
		GREY.."2) Razorclaw le Boucher";
		GREY.."3) Baron Silverlaine";
		GREY.."4) Commandant Springvale";
		GREY.."5) Odo l\'Aveugle ";
		GREY.."6) Fenrus le D\195\169voreur ";
		GREY.."7) Maitre-loup Nandos ";
		GREY.."8) Archimage Arugal ";
	};
	Stratholme = {
		ZoneName = "Stratholme";

		Location = "Maleterres de l\'Est";

		LevelRange = "55-60";

		PlayerLimit = "10";

		BLUE.."A) Entr\195\169e (Avant)";

		BLUE.."B) Entr\195\169e (cot\195\169)";

		GREY.."1) Skul (Rare, Vari\195\169)";
		GREY..INDENT.." Messager de Stratholme";
		GREY..INDENT.." Fras Siabi";
		GREY.."2) Hearthsinger Forresten";
		GREY..INDENT.."(Rare, Errant)";
		GREY.."3) Le Condamné";
		GREY.."4) Timmy le Cruel";
		GREY.."5) Maitre Cannonier Willey";
		GREY.."6) Archiviste Galford";
		GREY.."7) Balnazzar";
		GREY.."8) Aurius";
		GREY.."9) Stonespine (Rare)";
		GREY.."10) Barone Anastari";
		GREY.."11) Nerub'enkan";
		GREY.."12) Maleki the Pallid";
		GREY.."13) Magistrate Barthilas (Vari\195\169)";
		GREY.."14) Ramstein Grandgosier";
		GREY.."15) Baron Rivendare";
		GREN.."--- Boite aux lettres :";
		GREN.."1') Boite e la Place des Crois\195\169s";
		GREN.."2') Boite de l'All\195\169e du march\195\169";
		GREN.."3') Boite de l'All\195\169e du festival";
		GREN.."4') Boite de la Place des Anciens";
		GREN.."5') Boite de la Place du Roi";
		GREN.."6') Boite aux lettres de Fras Siabi";
	};
	TheDeadmines = {
		ZoneName = "Les Mortes Mines";
		Location = "Marche de l\'Ouest";
		LevelRange = "15-20";
		PlayerLimit = "10";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Sortie";
		GREY.."1) Rhahk'Zor";
		GREY.."2) Mineur Johnson (Rare)";
		GREY.."3) Sneed";
		GREY.."4) Gilnid";
		GREY.."5) Defias Gunpowder";
		GREY.."6) Capitaine Greenskin";
		GREY..INDENT.."Edwin VanCleef";
		GREY..INDENT.."Mr. Smite";
		GREY..INDENT.."Cookie";
	};
	TheStockades = {
		ZoneName = "La Prison";

		Location = "Stormwind";

		LevelRange = "23-26";

		PlayerLimit = "10";

		BLUE.."A) Entr\195\169e";
		GREY.."1) Targorr le Terrifiant (Vari\195\169)";
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

		GREY.."1) Altar d\'Hakkar";
		GREY..INDENT.."Atal'alarion";
		GREY.."2) Dreamscythe";
		GREY..INDENT.."Weaver";
		GREY.."3) Avatar d\'Hakkar";
		GREY.."4) Jammal'an le Proph\195\168te";
		GREY..INDENT.."Ogom le Corrompu";
		GREY.."5) Morphaz";
		GREY..INDENT.."Hazzas";
		GREY.."6) Ombre d\'Eranikus ";
		GREY..INDENT.."Essence Font";
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

		GREY.."8) Verdan l\'Immortel  (sup\195\169rieur)";
		GREY.."9) Mutanus le D\195\169voreur";
		GREY..INDENT.."Naralex";
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

		GREY.."7) Chef Ukorz Sandscalp";
		GREY..INDENT.."Ruuzlu";
		GREY.."8) Zerillis (Rare, Errant)";
	};
	ZulGurub = {
		ZoneName = "Zul'Gurub";
		Location = "la Vall\195\169e de Strangleronce";
		LevelRange = "60+";
		PlayerLimit = "20";
		BLUE.."A) Entr\195\169e";
		BLUE.."B) Eaux Boueuses";
		GREY.."1) Grande Pretresse Jekli";
		GREY.."2) Grand Pretre Venoxis";
		GREY.."3) Grande Pretresse Mar'li";
		GREY.."4) Seigneur de Sang Mandokir";
		GREY.."5) Edge of Madness";
		GREY..INDENT.."Gri'lek, of the Iron Blood";
		GREY..INDENT.."Hazza'rah, the Dreamweaver";
		GREY..INDENT.."Renataki, of the Thousand Blades";
		GREY..INDENT.."Wushoolay, the Storm Witch";
		GREY.."6) Gahz'ranka";
		GREY.."7) Grand Pretre Thekal";
		GREY.."8) Grande Pretresse Arlokk";
		GREY.."9) Jin'do le Hexxer";
		GREY.."10) Hakkar";
	}
};


end
