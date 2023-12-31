-- English





ATLAS_TITLE = "Atlas";
ATLAS_VERSION = "1.0.1";
ATLAS_SUBTITLE = "Instance Maps";
ATLAS_DESC = "Atlas is an instance map browser.";
ATLAS_NAME = ATLAS_TITLE.." v"..ATLAS_VERSION;

ATLAS_OPTIONS_BUTTON = "Options";

BINDING_HEADER_ATLAS_TITLE = "Atlas Bindings";
BINDING_NAME_ATLAS_TOGGLE = "Toggle Atlas";
BINDING_NAME_ATLAS_OPTIONS = "Toggle Options";

ATLAS_SLASH = "/atlas";
ATLAS_SLASH_OPTIONS = "options";

ATLAS_STRING_LOCATION = "Location";
ATLAS_STRING_LEVELRANGE = "Level Range";
ATLAS_STRING_PLAYERLIMIT = "Player Limit";

ATLAS_BUTTON_TOOLTIP = "Toggle Atlas";

ATLAS_OPTIONS_TITLE = "Atlas Options";
ATLAS_OPTIONS_SHOWBUT = "Show Button";
ATLAS_OPTIONS_BUTPOS = "Button Position";
ATLAS_OPTIONS_TRANS = "Transparency";
ATLAS_OPTIONS_DONE = "Done";





local BLUE = "|cff6666ff";
local GREY = "|cff999999";
local GREN = "|cff66cc33";
local INDENT = "   ";

AtlasText = {
	BlackfathomDeeps = {
		ZoneName = "Blackfathom Deeps";
		Location = "Ashenvale";
		LevelRange = "20-27";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Ghamoo-ra";
		GREY.."2) Lorgalis Manuscript";
		GREY.."3) Lady Sarevess";
		GREY.."4) Argent Guard Thaelrid";
		GREY.."5) Gelihast";
		GREY.."6) Lorgus Jett (Varies)";
		GREY.."7) Fathom Core, Baron Aquanis";
		GREY.."8) Twilight Lord Kelris";
		GREY.."9) Old Serra'kis";
		GREY.."10) Aku'mai";
	};
	BlackrockDepths = {
		ZoneName = "Blackrock Depths";
		Location = "Blackrock Mountain";
		LevelRange = "48-56";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Lord Roccor";
		GREY.."2) Kharan Mighthammer";
		GREY.."3) Marshal Windsor";
		GREY.."4) Ring of Law";
		GREY.."5) Mon. of Franclorn Forgewright,";
		GREY..INDENT.."Pyromancer Loregrain (Rare)";
		GREY.."6) The Vault";
		GREY.."7) Fineous Darkvire";
		GREY.."8) The Black Anvil, Lord Incendius";
		GREY.."9) Bael'Gar";
		GREY.."10) Shadowforge Lock";
		GREY.."11) General Angerforge";
		GREY.."12) Golem Lord Argelmach";
		GREY.."13) The Grim Guzzler";
		GREY.."14) Ambassador Flamelash";
		GREY.."15) Panzor the Invincible (Rare)";
		GREY.."16) Summoner's Tomb";
		GREY.."17) The Lyceum";
		GREY.."18) Magmus";
		GREY.."19) Emperor Dagran Thaurissan,";
		GREY..INDENT.."Princess Moira Bronzebeard";
		GREY.."20) The Black Forge";
		GREY.."21) Molten Core";
	};
	BlackrockSpireLower = {
		ZoneName = "Blackrock Spire (Lower)";
		Location = "Blackrock Mountain";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) Entrance";
		GREY.."1) Warosh";
		GREY.."2) Roughshod Pike";
		GREY.."3) Highlord Omokk";
		GREY.."4) Shadow Hunter Vosh'gajin";
		GREY.."5) War Master Voone";
		GREY.."6) Mother Smolderweb";
		GREY.."7) Crystal Fang (Rare)";
		GREY.."8) Urok Doomhowl";
		GREY.."9) Quartermaster Zigris";
		GREY.."10) Halycon, Gizrul the Slavener";
		GREY.."11) Overlord Wyrmthalak";
	};
	BlackrockSpireUpper = {
		ZoneName = "Blackrock Spire (Upper)";
		Location = "Blackrock Mountain";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) Entrance";
		BLUE.."B) Stairway";
		BLUE.."C) Stairway";
		GREY.."1) Jed Runewatcher (Rare)";
		GREY.."2) Pyroguard Emberseer";
		GREY.."3) Doomrigger's Clasp,";
		GREY..INDENT.." Father Flame";
		GREY.."4) Goraluk Anvilcrack";
		GREY.."5) Warchief Rend Blackhand, Gyth";
		GREY.."6) Awbee";
		GREY.."7) The Beast";
		GREY.."8) General Drakkisath";
		GREY.."9) Blackwing Lair";
	};
	DireMaulEast = {
		ZoneName = "Dire Maul (East)";
		Location = "Ferelas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Entrance";
		BLUE.."B) Entrance";
		BLUE.."C) Entrance";
		BLUE.."D) Exit";
		GREY.."1) Pusillin Chase Begins";
		GREY.."2) Pusillin Chase Ends";
		GREY.."3) Lethtendris, Hydrospawn,";
		GREY..INDENT.."Zevrim Thornhoof";
		GREY.."4) Old Ironbark";
		GREY.."5) Alzzin the Wildshaper";
	};
	DireMaulNorth = {
		ZoneName = "Dire Maul (North)";
		Location = "Ferelas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Entrance";
		GREY.."1) Guard Mol'dar";
		GREY.."2) Stomper Kreeg";
		GREY.."3) Guard Fengus";
		GREY.."4) Guard Slip'kik,";
		GREY..INDENT.."Knot Thimblejack";
		GREY.."5) Captain Kromcrush";
		GREY.."6) King Gordok";
		GREY.."7) Dire Maul (West)";
	};
	DireMaulWest = {
		ZoneName = "Dire Maul (West)";
		Location = "Ferelas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Entrance";
		BLUE.."B) Pylons";
		GREY.."1) Shen'dralar Ancient";
		GREY.."2) Tendris Warpwood";
		GREY.."3) Illyanna Ravenoak,";
		GREY..INDENT.."Magister Kalendris";
		GREY.."4) Immol'thar";
		GREY.."5) Prince Tortheldrin";
		GREY.."6) Dire Maul (North)";
	};
	Gnomeregan = {
		ZoneName = "Gnomeregan";
		Location = "Dun Morogh";
		LevelRange = "24-33";
		PlayerLimit = "10";
		BLUE.."A) Entrance (Front)";
		BLUE.."B) Entrance (Back)";
		GREY.."1) Viscous Fallout (Lower)";
		GREY.."2) Grubbis";
		GREY.."3) Matrix Punchograph 3005-B";
		GREY.."4) Clean Zone";
		GREY.."5) Electrocutioner 6000,";
		GREY..INDENT.."Matrix Punchograph 3005-C";
		GREY.."6) Mekgineer Thermaplugg";
		GREY.."7) Dark Iron Ambassador (Rare)";
		GREY.."8) Crowd Pummeler 9-60,";
		GREY..INDENT.."Matrix Punchograph 3005-D";
	};
	Maraudon = {
		ZoneName = "Maraudon";
		Location = "Desolace";
		LevelRange = "40-49";
		PlayerLimit = "10";
		BLUE.."A) Entrance (Orange)";
		BLUE.."B) Entrance (Purple)";
		BLUE.."C) Entrance (Portal)";
		GREY.."1) Veng (The Fifth Khan)";
		GREY.."2) Noxxion";
		GREY.."3) Razorlash";
		GREY.."4) Maraudos (The Fourth Khan)";
		GREY.."5) Lord Vyletongue";
		GREY.."6) Meshlok the Harvester (Rare)";
		GREY.."7) Celebras the Cursed";
		GREY.."8) Landslide";
		GREY.."9) Tinkerer Gizlock";
		GREY.."10) Rotgrip";
		GREY.."11) Princess Theradras";
	};
	MoltenCore = {
		ZoneName = "Molten Core";
		Location = "Blackrock Depths";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Entrance";
		GREY.."1) Lucifron";
		GREY.."2) Magmadar";
		GREY.."3) Gehennas";
		GREY.."4) Garr";
		GREY.."5) Shazzrah";
		GREY.."6) Baron Geddon";
		GREY.."7) Golemagg the Incinerator";
		GREY.."8) Sulfuron Harbinger";
		GREY.."9) Majordomo Executus";
		GREY.."10) Ragnaros";
	};
	OnyxiasLair = {
		ZoneName = "Onyxia's Lair";
		Location = "Dustwallow Marsh";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Entrance";
		GREY.."1) Onyxian Warders";
		GREY.."2) Whelp Eggs";
		GREY.."3) Onyxia";
	};
	RagefireChasm = {
		ZoneName = "Ragefire Chasm";
		Location = "Orgrimmar";
		LevelRange = "13-15";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Maur Grimtotem";
		GREY.."2) Taragaman the Hungerer";
		GREY.."3) Jergosh the Invoker";
		GREY.."4) Bazzalan";
	};
	RazorfenDowns = {
		ZoneName = "Razorfen Downs";
		Location = "The Barrens";
		LevelRange = "35-40";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Tuten'kash";
		GREY.."2) Henry Stern, Belnistrasz";
		GREY.."3) Mordresh Fire Eye";
		GREY.."4) Glutton";
		GREY.."5) Ragglesnout (Rare)";
		GREY.."6) Amnennar the Coldbringer";
	};
	RazorfenKraul = {
		ZoneName = "Razorfen Kraul";
		Location = "The Barrens";
		LevelRange = "25-35";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Roogug";
		GREY.."2) Aggem Thorncurse";
		GREY.."3) Death Speaker Jargba";
		GREY.."4) Overlord Ramtusk";
		GREY.."5) Agathelos the Raging";
		GREY.."6) Blind Hunter (Rare)";
		GREY.."7) Charlga Razorflank";
		GREY.."8) Willix the Importer,";
		GREY..INDENT.."Heralath Fallowbrook";
	};
	ScarletMonastery = {
		ZoneName = "Scarlet Monastery";
		Location = "Tirisfal Glades";
		LevelRange = "30-40";
		PlayerLimit = "10";
		BLUE.."A) Entrance (Library)";
		BLUE.."B) Entrance (Armory)";
		BLUE.."C) Entrance (Cathedral)";
		BLUE.."D) Entrance (Graveyard)";
		GREY.."1) Houndmaster Loksey";
		GREY.."2) Arcanist Doan";
		GREY.."3) Herod";
		GREY.."4) High Inquisitor Fairbanks";
		GREY.."5) Scarlet Commander Mograine,";
		GREY..INDENT.."High Inquisitor Whitemane";
		GREY.."6) Azshir the Sleepless (Rare),";
		GREY..INDENT.."Fallen Champion (Rare),";
		GREY..INDENT.."Ironspine (Rare)";
		GREY.."7) Bloodmage Thalnos";
	};
	Scholomance = {
		ZoneName = "Scholomance";
		Location = "Western Plaguelands";
		LevelRange = "56-60";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		BLUE.."B) Stairway";
		BLUE.."C) Stairway";
		GREY.."1) Deed to Southshore";
		GREY.."2) Kirtonos the Herald";
		GREY.."3) Jandice Barov";
		GREY.."4) Deed to Tarren Mill";
		GREY.."5) Rattlegore (Lower)";
		GREY.."6) Marduk Blackpool, Vectus";
		GREY.."7) Ras Frostwhisper,";
		GREY..INDENT.."Deed to Brill";
		GREY.."8) Instructor Malicia";
		GREY.."9) Doctor Theolen Krastinov";
		GREY.."10) Lorekeeper Polkelt";
		GREY.."11) The Ravenian";
		GREY.."12) Lord Alexei Barov,";
		GREY..INDENT.."Deed to Caer Darrow";
		GREY.."13) Lady Illucia Barov";
		GREY.."14) Darkmaster Gandling";
		GREN.."1') Torch Lever";
		GREN.."2') Secret Chest";
	};
	ShadowfangKeep = {
		ZoneName = "Shadowfang Keep";
		Location = "Silverpine Forest";
		LevelRange = "18-25";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		BLUE.."B) Walkway";
		BLUE.."C) Walkway";
		GREY.."1) Deathstalker Adamant,";
		GREY..INDENT.."Sorcerer Ashcrombe,";
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
		Location = "Eastern Plaguelands";
		LevelRange = "55-60";
		PlayerLimit = "10";
		BLUE.."A) Entrance (Front)";
		BLUE.."B) Entrance (Side)";
		BLUE.."C) Post Boxes, Postmaster Malown";
		GREY.."1) Fras Siabi, Stratholme Courier,";
		GREY..INDENT.."Skul (Rare, Wanders)";
		GREY.."2) Hearthsinger Forresten";
		GREY..INDENT.."(Rare, Varies)";
		GREY.."3) Timmy the Cruel";
		GREY.."4) Cannon Master Willey";
		GREY.."5) Archivist Galford";
		GREY.."6) Balnazzar";
		GREY.."7) Aurius";
		GREY.."8) Stonespine (Rare)";
		GREY.."9) Baroness Anastari";
		GREY.."10) Nerub'enkan";
		GREY.."11) Maleki the Pallid";
		GREY.."12) Magistrate Barthilas (Varies)";
		GREY.."13) Ramstein the Gorger";
		GREY.."14) Baron Rivendare";
	};
	TheDeadmines = {
		ZoneName = "The Deadmines";
		Location = "Westfall";
		LevelRange = "15-20";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
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
		ZoneName = "The Stockades";
		Location = "Stormwind";
		LevelRange = "23-26";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Targorr the Dread (Varies)";
		GREY.."2) Kam Deepfury";
		GREY.."3) Hamhock";
		GREY.."4) Bazil Thredd";
		GREY.."5) Dextren Ward";
		GREY.."6) Bruegal Ironknuckle (Rare)";
	};
	TheSunkenTemple = {
		ZoneName = "The Sunken Temple";
		Location = "Swamp of Sorrows";
		LevelRange = "44-50";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		BLUE.."B) Stairway";
		BLUE.."C) Troll Minibosses (Upper)";
		GREY.."1) Altar of Hakkar, Atal'alarion";
		GREY.."2) Weaver, Dreamscythe";
		GREY.."3) Avatar of Hakkar";
		GREY.."4) Jammal'an the Prophet,";
		GREY..INDENT.."Ogom the Wretched";
		GREY.."5) Morphaz, Hazzas";
		GREY.."6) Shade of Eranikus, Essence Font";
		GREN.."1'-6') Statue Activation Order";
	};
	Uldaman = {
		ZoneName = "Uldaman";
		Location = "The Badlands";
		LevelRange = "35-45";
		PlayerLimit = "10";
		BLUE.."A) Entrance (Front)";
		BLUE.."B) Entrance (Back)";
		GREY.."1) Baelog";
		GREY.."2) Remains of a Paladin";
		GREY.."3) Revelosh";
		GREY.."4) Ironaya";
		GREY.."5) Obsidian Sentinel";
		GREY.."6) Annora (Master Enchanter)";
		GREY.."7) Ancient Stone Keeper";
		GREY.."8) Galgann Firehammer";
		GREY.."9) Grimlok";
		GREY.."10) Archaedas (Lower)";
		GREY.."11) The Discs of Norgannon,";
		GREY..INDENT.."Ancient Treasure (Lower)";
	};
	WailingCaverns = {
		ZoneName = "Wailing Caverns";
		Location = "The Barrens";
		LevelRange = "15-21";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Disciple of Naralex";
		GREY.."2) Lord Cobrahn";
		GREY.."3) Lady Anacondra";
		GREY.."4) Kresh";
		GREY.."5) Lord Pythas";
		GREY.."6) Skum";
		GREY.."7) Lord Serpentis (Upper)";
		GREY.."8) Verdan the Everliving (Upper)";
		GREY.."9) Mutanus the Devourer, Naralex";
	};
	ZulFarrak = {
		ZoneName = "Zul'Farrak";
		Location = "Tanaris Desert";
		LevelRange = "43-47";
		PlayerLimit = "10";
		BLUE.."A) Entrance";
		GREY.."1) Antu'sul";
		GREY.."2) Theka the Martyr";
		GREY.."3) Witch Doctor Zum'rah,";
		GREY..INDENT.."Zul'Farrak Dead Hero";
		GREY.."4) Nekrum Gutchewer";
		GREY.."5) Sergeant Bly";
		GREY.."6) Hydromancer Velratha,";
		GREY..INDENT.."Gahz'rilla";
		GREY.."7) Chief Ukorz Sandscalp, Ruuzlu";
		GREY.."8) Zerillis (Rare, Wanders)";
	};
};
