if ( GetLocale() == "deDE" ) then



-- Deutsch (German)
-- Lokalisierung von Azeroths Plage (www.playwow.de)
-- Für Tipps zu falschen oder fehlenden Namen
-- bitte im Forum bescheid geben! DANKE!
-- Lokalisation: Dermott



ATLAS_TITLE = "Atlas";
ATLAS_SUBTITLE = "Instanzkarten";
ATLAS_DESC = "Atlas ist ein Instanzkarten-Browser";
ATLAS_NAME = ATLAS_TITLE.." v"..ATLAS_VERSION;

ATLAS_OPTIONS_BUTTON = "Optionen";

BINDING_HEADER_ATLAS_TITLE = "Atlas Tastaturbelegungen";
BINDING_NAME_ATLAS_TOGGLE = "Atlas an/aus";
BINDING_NAME_ATLAS_OPTIONS = "Optionen an/aus";

ATLAS_SLASH = "/atlas";
ATLAS_SLASH_OPTIONS = "options";

ATLAS_STRING_LOCATION = "Platz";
ATLAS_STRING_LEVELRANGE = "Level Reichweite";
ATLAS_STRING_PLAYERLIMIT = "Spieler Limit";

ATLAS_BUTTON_TOOLTIP = "Atlas an/aus";

ATLAS_OPTIONS_TITLE = "Atlas Optionen";
ATLAS_OPTIONS_SHOWBUT = "Zeige Schalter";
ATLAS_OPTIONS_AUTOSEL = "Automatische Auswahl";
ATLAS_OPTIONS_BUTPOS = "Schalterposition";
ATLAS_OPTIONS_TRANS = "Transparenz";
ATLAS_OPTIONS_DONE = "Fertig";



local BLUE = "|cff6666ff";
local GREY = "|cff999999";
local GREN = "|cff66cc33";
local INDENT = "   ";

AtlasText = {
	BlackfathomDeeps = {
		ZoneName = "Blackfathom-Tiefen";
		Location = "Ashenvale";
		LevelRange = "20-27";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Ghamoo-ra";
		GREY.."2) Lorgalis Manuskript";
		GREY.."3) Lady Sarevess";
		GREY.."4) Argentumwache Thaelrid";
		GREY.."5) Gelihast";
		GREY.."6) Lorgus Jett (variiert)";
		GREY.."7) Baron Aquanis";
		GREY..INDENT.."Fathomkern";
		GREY.."8) Twilight Lord Kelris";
		GREY.."9) Old Serra'kis";
		GREY.."10) Aku'mai";
	};
	BlackrockDepths = {
		ZoneName = "Blackrocktiefen";
		Location = "Blackrock";
		LevelRange = "48-56";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Lord Roccor";
		GREY.."2) Kharan Mighthammer";
		GREY.."3) Kommandant Gor'shak";
		GREY.."4) Marshal Windsor";
		GREY.."5) Hochbefrager Gerstahn";
		GREY.."6) Ring des Gesetzes";
		GREY.."7) Monument von";
		GREY..INDENT.."Franclorn Forgewright,";		
		GREY..INDENT.."Pyromant Loregrain (Rar)";
		GREY.."8) Das schwarze Gewölbe";
		GREY..INDENT.."W\195\164rter Stilgiss, Verek";		
		GREY.."9) Fineous Darkvire";
		GREY.."10) Der schwarze Amboss, ";
		GREY..INDENT.."Lord Incendius";
		GREY.."11) Bael'Gar";
		GREY.."12) Shadowforge Schloss";
		GREY.."13) General Angerforge";
		GREY.."14) Golem Lord Argelmach";
		GREY.."15) The Grim Guzzler";
		GREY.."16) Botschafter Flamelash";
		GREY.."17) Panzor der Unbesiegbare (Rar)";
		GREY.."18) Grabmal der Boten";
		GREY.."19) Das Lyzeum";
		GREY.."20) Magmus";
		GREY.."21) Imperator Dagran Thaurissan,";
		GREY..INDENT.."Prinzessin Moira Bronzebeard";
		GREY.."22) Die schwarze Schmiede";
		GREY.."23) Der geschmolzene Kern";
	};
	BlackrockSpireLower = {
		ZoneName = "Blackrockspitze(Unten)";
		Location = "Blackrock";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) Eingang";
		GREY.."1) Warosh";
		GREY.."2) Roughshod Pike";
		GREY.."3) Hochlord Omokk";
		GREY.."4) Schattenj\195\164gerin Vosh'gajin";
		GREY..INDENT.."F\195\188nfte Mosh'aru-Schrifttafel";
		GREY.."5) Kriegsmeister Voone";
		GREY..INDENT.."Sechste Mosh'aru-Schrifttafel";
		GREY.."6) Mutter Smolderweb";
		GREY.."7) Crystal Fang (Rar)";
		GREY.."8) Urok Doomhowl";
		GREY.."9) Quartiermeister Zigris";
		GREY.."10) Halycon";
		GREY..INDENT.."Gizrul der Sklavenhalter";
		GREY.."11) Hochlord Wyrmthalak";
		GREY.."12) Bannok Grimaxe (Rar)";
	};
	BlackrockSpireUpper = {
		ZoneName = "Blackrockspitze(Oben)";
		Location = "Blackrock";
		LevelRange = "53-60";
		PlayerLimit = "15";
		BLUE.."A) Eingang";
		BLUE.."B) Treppen";
		BLUE.."C) Treppen";
		GREY.."1) Jed Runewatcher (Rar)";
		GREY.."2) Feuerwache Glutseher";
		GREY.."3) Solakar Flamewreath";
		GREY..INDENT.."Vater Flamme";
		GREY.."4) Goraluk Anvilcrack";
		GREY.."5) Kriegsh\195\164uptling Rend Blackhand";
		GREY..INDENT.."Gyth";
		GREY.."6) Awbee";
		GREY.."7) Die Bestie";
		GREY.."8) General Drakkisath";
		GREY.."9) Pechschwingenhort";
	};
	BlackwingLair = {
		ZoneName = "Pechschwingenhort";
		Location = "Blackrockspitze";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Eingang";
		BLUE.."B) Pfad";
		BLUE.."C) Pfad";
		BLUE.."D) Pfad";
		GREY.."1) Razorgore der Ungez\195\164hmte";
		GREY.."2) Vaelastrasz der Verdorbene";
		GREY.."3) Brutlord Lashlayer";
		GREY.."4) Firemaw";
		GREY.."5) Ebonroc";
		GREY.."6) Flamegor";
		GREY.."7) Chromaggus";
		GREY.."8) Nefarian";
	};
	DireMaulEast = {
		ZoneName = "D\195\188sterbruch (Ost)";
		Location = "Feralas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Eingang";
		BLUE.."B) Eingang";
		BLUE.."C) Eingang";
		BLUE.."D) Ausgang";
		GREY.."1) Pusillins Jagd beginnt";
		GREY.."2) Pusillins Jagd endet";
		GREY.."3) Zevrim Thornhoof";
		GREY..INDENT.."Lethtendris";
		GREY..INDENT.."Hydrobrut";
		GREY.."4) Ironbark der Grosse";
		GREY.."5) Alzzin der Wildformer";
	};
	DireMaulNorth = {
		ZoneName = "D\195\188sterbruch (Nord)";
		Location = "Feralas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Eingang";
		GREY.."1) Wache Mol'dar";
		GREY.."2) Stampfer Kreeg";
		GREY.."3) Wache Fengus";
		GREY.."4) Knot Thimblejack";
		GREY..INDENT.."Wache Slip'kik";
		GREY.."5) Captain Kromcrush";
		GREY.."6) K\195\182nig Gordok";
		GREY.."7) D\195\188sterbruch (West)";
	};
	DireMaulWest = {
		ZoneName = "D\195\188sterbruch (West)";
		Location = "Feralas";
		LevelRange = "56-60";
		PlayerLimit = "5";
		BLUE.."A) Eingang";
		BLUE.."B) Pylonen";
		GREY.."1) Shen'dralar Uralter";
		GREY.."2) Tendris Warpwood";
		GREY.."3) Illyanna Ravenoak,";
		GREY..INDENT.."Magister Kalendris";
		GREY.."4) Tsu'zee (Rar)";
		GREY.."5) Immol'thar";
		GREY.."6) Prinz Tortheldrin";
		GREY.."7) D\195\188sterbruch (Nord)";
	};
	Gnomeregan = {
		ZoneName = "Gnomeregan";
		Location = "Dun Morogh";
		LevelRange = "24-33";
		PlayerLimit = "10";
		BLUE.."A) Eingang (Vorne)";
		BLUE.."B) Eingang (Hinten)";
		GREY.."1) Z\195\164hfl\195\188ssiger Niederschlag";
		GREY.."2) Grubbis";
		GREY.."3) Lochkarten-Automat 3005-B";
		GREY.."4) Sichere Zone";
		GREY.."5) Electrocutioner 6000,";
		GREY..INDENT.."Lochkarten-Automat 3005-C";
		GREY.."6) Robogenieur Thermaplugg";
		GREY.."7) Dark Iron Botschafter (Rar)";
		GREY.."8) Meute Verpr\195\188geler 9-60,";
		GREY..INDENT.."Lochkarten-Automat 3005-D";
	};
	Maraudon = {
		ZoneName = "Maraudon";
		Location = "Desolace";
		LevelRange = "40-49";
		PlayerLimit = "10";
		BLUE.."A) Eingang (Orange)";
		BLUE.."B) Eingang (Lila)";
		BLUE.."C) Eingang (Portal)";
		GREY.."1) Veng (Der f\195\188nfte Khan)";
		GREY.."2) Noxxion";
		GREY.."3) Razorlash";
		GREY.."4) Maraudos (Der vierte Khan)";
		GREY.."5) Lord Vyletongue";
		GREY.."6) Meshlok der Ernter (Rar)";
		GREY.."7) Celebras der Verbannte";
		GREY.."8) Erdrutsch";
		GREY.."9) T\195\188ftler Gizlock";
		GREY.."10) Rotgrip";
		GREY.."11) Prinzessin Theradras";
	};
	MoltenCore = {
		ZoneName = "Der geschmolzene Kern";
		Location = "Blackrocktiefen";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Eingang";
		GREY.."1) Lucifron";
		GREY.."2) Magmadar";
		GREY.."3) Gehennas";
		GREY.."4) Garr";
		GREY.."5) Shazzrah";
		GREY.."6) Baron Geddon";
		GREY.."7) Golemagg der Verbrenner";
		GREY.."8) Sulfuron Herold";
		GREY.."9) Majordomus Executus";
		GREY.."10) Ragnaros";
	};
	OnyxiasLair = {
		ZoneName = "Onyxias Hort";
		Location = "Marschen von Dustwallow";
		LevelRange = "60+";
		PlayerLimit = "40";
		BLUE.."A) Eingang";
		GREY.."1) Onyxias Wachen";
		GREY.."2) Welpeneier";
		GREY.."3) Onyxia";
	};
	RagefireChasm = {
		ZoneName = "Ragefireabgrund";
		Location = "Orgrimmar";
		LevelRange = "13-15";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Maur Grimtotem";
		GREY.."2) Taragaman der Hungerleider";
		GREY.."3) Jergosh der Herbeirufer";
		GREY.."4) Bazzalan";
	};
	RazorfenDowns = {
		ZoneName = "H\195\188gel von Razorfen";
		Location = "Brachland";
		LevelRange = "35-40";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Tuten'kash";
		GREY.."2) Henry Stern";
		GREY..INDENT.."Belnistrasz";
		GREY.."3) Mordresh Feuerauge";
		GREY.."4) Glutton";
		GREY.."5) Ragglesnout (Rar)";
		GREY.."6) Amnennar der K\195\164ltebringer";
	};
	RazorfenKraul = {
		ZoneName = "Kral von Razorfen";
		Location = "Brachland";
		LevelRange = "25-35";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Roogug";
		GREY.."2) Aggem Thorncurse";
		GREY.."3) Todessprecher Jargba";
		GREY.."4) Oberanf\195\188hrer Ramtusk";
		GREY.."5) Agathelos der Tobende";
		GREY.."6) Blinder J\195\164ger (Rar)";
		GREY.."7) Charlga Razorflank";
		GREY.."8) Willix der Importeur";
		GREY..INDENT.."Heralath Fallowbrook";
		GREY.."9) Erdenrufer Halmgar (Rar)";
	};
	ScarletMonastery = {
		ZoneName = "Das scharlachrote Kloster";
		Location = "Tirisfal";
		LevelRange = "30-40";
		PlayerLimit = "10";
		BLUE.."A) Eingang (Bibliothek)";
		BLUE.."B) Eingang (Waffenkammer)";
		BLUE.."C) Eingang (Kathedrale)";
		BLUE.."D) Eingang (Friedhof)";
		GREY.."1) Hundemeister Loksey";
		GREY.."2) Arkanist Doan";
		GREY.."3) Herod";
		GREY.."4) Hochinquisitor Fairbanks";
		GREY.."5) Scharlachroter Kommandant";
		GREY..INDENT.."Mograine";
		GREY..INDENT.."Hochinquisitor Whitemane";
		GREY.."6) Eisenstachel (Rar)";
		GREY.."7) Azshir der Schlaflose (Rar)";
		GREY.."8) Gefallener Held (Rar)";
		GREY.."9) Blutmagier Thalnos";
	};
	Scholomance = {
		ZoneName = "Scholomance";
		Location = "Westliche Pestl\195\164nder";
		LevelRange = "56-60";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		BLUE.."B) Treppen";
		BLUE.."C) Treppen";
		GREY.."1) Blutschale von Kirtonos";
		GREY..INDENT.."Besitzurkunde f\195\188r";
		GREY..INDENT.."Southshore";
		GREY.."2) Kirtonos der Herold";
		GREY.."3) Jandice Barov";
		GREY.."4) Besitzurkunde f\195\188r";
		GREY..INDENT.."Tarrens M\195\188hle";
		GREY.."5) Rattlegore (Unten)";
		GREY.."6) Marduk Blackpool";
		GREY..INDENT.."Vectus";
		GREY.."7) Ras Frostwhisper,";
		GREY..INDENT.."Besitzurkunde f\195\188r Brill";
		GREY.."8) Instrukteurin Malicia";
		GREY.."9) Doktor Theolen Krastinov";
		GREY.."10) H\195\188ter des Wissens Polkelt";
		GREY.."11) Der Ravenier";
		GREY.."12) Lord Alexei Barov,";
		GREY..INDENT.."Besitzurkunde f\195\188r";
		GREY..INDENT.."Caer Darrow";
		GREY.."13) Lady Illucia Barov";
		GREY.."14) Dunkelmeister Gandling";
		GREN.."1') Kerzenhebel";
		GREN.."2') Geheime Truhe";
		GREN.."3') Alchimielabor";
	};
	ShadowfangKeep = {
		ZoneName = "Burg Shadowfang";
		Location = "Silberwald";
		LevelRange = "18-25";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		BLUE.."B) Gang";
		BLUE.."C) Gang";
		BLUE..INDENT.."Todesh\195\182riger Captain (Rar)";
		GREY.."1) Todespirscher Adamant,";
		GREY..INDENT.."Zauberhexer Ashcrombe";
		GREY..INDENT.."Rethilgore";
		GREY.."2) Klingenklaue der Metzger";
		GREY.."3) Baron Silverlaine";
		GREY.."4) Kommandant Springvale";
		GREY.."5) Odo der Blindseher";
		GREY.."6) Fenrus der Verschlinger";
		GREY.."7) Wolfmeister Nandos";
		GREY.."8) Erzmagier Arugal";
	};
	Stratholme = {
		ZoneName = "Stratholme";
		Location = "\195\182stliche Pestl\195\164nder";
		LevelRange = "55-60";
		PlayerLimit = "10";
		BLUE.."A) Eingang (Front)";
		BLUE.."B) Eingang (Seite)";
		GREY.."1) Skul (Rar, Wandert)";
		GREY..INDENT.."Fras Siabi";
		GREY..INDENT.."Stratholme-Kurier";
		GREY.."2) Herdsinger Forresten";
		GREY..INDENT.."(Rar, Variiert)";
		GREY.."3) Der Unverziehene";
		GREY.."4) Timmy der Grausame";
		GREY.."5) Kanonenmeister Willey";
		GREY.."6) Archivar Galford";
		GREY.."7) Balnazzar";
		GREY.."8) Aurius";
		GREY.."9) Stonespine (Rar)";
		GREY.."10) Baroness Anastari";
		GREY.."11) Nerub'enkan";
		GREY.."12) Maleki der Leichenblasse";
		GREY.."13) Magistrat Barthilas (Variiert)";
		GREY.."14) Ramstein der Verschlinger";
		GREY.."15) Baron Rivendare";
		GREN.."1') Kreuzfahrerplatz Briefkasten";
		GREN.."2') Marktplatz Briefkasten";
		GREN.."3') Festspiel-Gasse Briefkasten";
		GREN.."4') Älterenplatz Briefkasten";
		GREN.."5') K\195\182nigsplatz Briefkasten";
		GREN.."6') Fras Siabi's Briefkasten";
	};
	TheDeadmines = {
		ZoneName = "Die Todesminen";
		Location = "Westfall";
		LevelRange = "15-20";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		BLUE.."B) Ausgang";
		GREY.."1) Rhahk'Zor";
		GREY.."2) Minenarbeiter Johnson (Rar)";
		GREY.."3) Sneed";
		GREY.."4) Gilnid";
		GREY.."5) Defias Gunpowder";
		GREY.."6) Captain Greenskin";
		GREY..INDENT.."Edwin van Cleef";
		GREY..INDENT.."Mr. Smite";
		GREY..INDENT.."Cookie";
	};
	TheStockades = {
		ZoneName = "Die Palisaden";
		Location = "Stormwind";
		LevelRange = "23-26";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Targorr der Schreckliche";
		GREY..INDENT.."(Variiert)";
		GREY.."2) Kam Deepfury";
		GREY.."3) Hamhock";
		GREY.."4) Bazil Thredd";
		GREY.."5) Dextren Ward";
		GREY.."6) Bruegal Ironknuckle (Rar)";
	};
	TheSunkenTemple = {
		ZoneName = "Der versunkene Tempel";
		Location = "S\195\188mpfe des Elends";
		LevelRange = "44-50";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		BLUE.."B) Treppen";
		BLUE.."C) Troll Minibosse (Oben)";
		GREY.."1) Altar von Hakkar";
		GREY..INDENT.."Atal'alarion";
		GREY.."2) Wirker";
		GREY..INDENT.."Traumsense";
		GREY.."3) Avatar von Hakkar";
		GREY.."4) Jammal'an der Prophet";
		GREY..INDENT.."Ogom der Elende";
		GREY.."5) Morphaz";
		GREY..INDENT.."Hazzas";
		GREY.."6) Eranikus' Schemen";
		GREY..INDENT.."Essenzen Schriftsatz";		
		GREN.."1'-6') Statuen Aktivierungs-";
		GREN..INDENT.."reihenfolge";
	};
	Uldaman = {
		ZoneName = "Uldaman";
		Location = "Das \195\182dland";
		LevelRange = "35-45";
		PlayerLimit = "10";
		BLUE.."A) Eingang (Vorne)";
		BLUE.."B) Eingang (Hinten)";
		GREY.."1) Baelog";
		GREY.."2) \195\156berreste eines Paladins";
		GREY.."3) Revelosh";
		GREY.."4) Ironaya";
		GREY.."5) Obsidian-Schildwache";
		GREY.."6) Annora (Verzauberungsmeister)";
		GREY.."7) Urtum-Steinbewahrer";
		GREY.."8) Galgann Firehammer";
		GREY.."9) Grimlok";
		GREY.."10) Archaedas (Unten)";
		GREY.."11) Die Scheiben von Norgannon";
		GREY..INDENT.."Antiker Schatz (Unten)";
	};
	WailingCaverns = {
		ZoneName = "Die H\195\182hlen des Wehklagens";
		Location = "Brachland";
		LevelRange = "15-21";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) J\195\188nger von Naralex";
		GREY.."2) Lord Cobrahn";
		GREY.."3) Lady Anacondra";
		GREY.."4) Kresh";
		GREY.."5) Lord Pythas";
		GREY.."6) Skum";
		GREY.."7) Lord Serpentis (Oben)";
		GREY.."8) Verdan der Ewiglebende (Oben)";
		GREY.."9) Mutanus der Verschlinger";
		GREY..INDENT.."Naralex";
	};
	ZulFarrak = {
		ZoneName = "Zul'Farrak";
		Location = "Tanaris";
		LevelRange = "43-47";
		PlayerLimit = "10";
		BLUE.."A) Eingang";
		GREY.."1) Antu'sul";
		GREY.."2) Theka der M\195\164rtyrer";
		GREY.."3) Hexendoktor Zum'rah";
		GREY..INDENT.."Zul'Farrak Toter Held";
		GREY.."4) Nekrum Gutchewer";
		GREY.."5) Sergeant Bly";
		GREY.."6) Wasserbeschw\195\182rerin Velratha,";
		GREY..INDENT.."Gahz'rilla";
		GREY.."7) H\195\164uptling Ukorz Sandscalp";
		GREY..INDENT.."Ruuzlu";
		GREY.."8) Zerillis (Rar, Wandert)";
	};
	ZulGurub = {
		ZoneName = "Zul'Gurub";
		Location = "Stranglethorn";
		LevelRange = "60+";
		PlayerLimit = "20";
		BLUE.."A) Eingang";
		BLUE.."B) Muddy Churning Waters";
		GREY.."1) Hohepriesterin Jeklik";
		GREY.."2) Hohepriester Venoxis";
		GREY.."3) Hohepriesterin Mar'li";
		GREY.."4) Blutlord Mandokir";
		GREY.."5) Edge of Madness";
		GREY..INDENT.."Gri'lek vom Eisenblut";
		GREY..INDENT.."Hazza'rah der Traumwirker";
		GREY..INDENT.."Renataki der tausend Klingen";
		GREY..INDENT.."Wushoolay die Sturmhexe";
		GREY.."6) Gahz'ranka";
		GREY.."7) Hohepriester Thekal";
		GREY.."8) Hohepriesterin Arlokk";
		GREY.."9) Jin'do der Hexer";
		GREY.."10) Hakkar";
	}
};



end

