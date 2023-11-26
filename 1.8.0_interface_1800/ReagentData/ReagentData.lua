-- Reagent Data - Version 2.2.1
--
-- Author: Jerigord (GDI)
-- Recipe Data Compiled by Bima
-- Original German Translated provided by Xadros
--
-- Description:
-- Reagent Data is a comprehensive library of all reagents used in tradeskills in World of Warcraft.
-- It also contains a variety of common item classes to provide a rich reagent library for other mod
-- developers.  In addition, it provides an access API to give developers flexibility when dealing
-- with the data as well as direct access to its data arrays so authors can get exactly what they
-- want from it.
--
-- Users: This mod is a base mod used by several other addons.  There is no need to directly interact
-- with this addon and you should not delete or otherwise alter it unless you're certain it's not
-- currently in use.
--
-- Mod Authors: Reagent Data was designed with you in mind.  It provides you a massive reagent library and
-- API that will automatically translate to other languages, giving your mod additional flexibility at no
-- coding cost.  It is as comprehensive as possible and designed to be flexible and lightweight so you
-- don't have to worry about coding or storing the reagent data yourself.
--
-- For complete usage and API instructions, please see the included readme.txt file.

-------------
-- Changes --
-------------

-------------------
-- Version 2.2.1 --
-------------------
--
-- Updated for the 1.8 (1800) patch

-----------------------
-- API/Table Changes --
-----------------------
--
-- * General
--   - Added Dark Rune: ReagentData['monster']['darkrune']
--   - Added Dreamscale: ReagentData['monster']['dreamscale']
--   - Added Heavy Silithid Carapace: ReagentData['monster']['heavysilithidcarapace']
--   - Added Light Silithid Carapace: ReagentData['monster']['lightsilithidcarapace']
--   - Added Sandworm Meat: ReagentData['monster']['sandwormmeat']
--   - Added Silithid Chitin: ReagentData['monster']['silithidchitin']
--   - Changed ReagentData['monster']['bloodvine'] to ReagentData['herb']['bloodvine']
--
-- * Blacksmithing
--   - Added Darkrune Gauntlets, Darkrune Helm, and Darkrune Breastplate recipes
--
-- * Cooking
--   - Added Sandworm Meat to ReagentData['cooking']
--
-- * Leatherworking
--   - Added Dreamscale to ReagentData['leatherworking']
--   - Added Heavy Silithid Carapace to ReagentData['leatherworking']
--   - Added Light Silithid Carapace to ReagentData['leatherworking']
--   - Added Silithid Chitin to ReagentData['leatherworking']
--   - Added Green Dragonscale Gauntlets, Blue Dragonscale Leggings, Dreamscale Breastplate,
--     Sandstalker Bracers, Sandstalker Breastplate, Sandstalker Gauntlets, Spitfire Gauntlets,
--     Spitfire Breastplate, Spitfire Bracers, and Black Whelp Tunic recipes
--
-- * Tailoring 
--   - Added Dark Rune to ReagentData['tailoring']
--   - Added Runed Stygian Leggings and Runed Stygian Belt recipes

-------------------
-- Version 2.2.0 --
-------------------

--------------------
-- New Tables/API --
--------------------
--
-- Reagent Data now contains a ReagentData['quest'] table for important quest items.  This was done
-- due to the addition of new quests that have a complicated number of tradeable items that are
-- desired by multiple classes.  The table was designed to be zone-centric.  That is to say, the subtables 
-- of ReagentData['quest'] are the names of the zones in which the quests appear.  Currently, only
-- Zul'Gurub quests are supported.  Due to the dynamic nature of the quest system, the individual table
-- design and format will vary from zone table to zone table.  This is by design.

-----------------------
-- API/Table Changes --
-----------------------
--
-- * All profession tables have been tweaked or revamped thanks to Fara and Andreas.
--
-- * General:
--   - Added Massive Mojo: ReagentData['monster']['massiveomojo']
--   - Added Bloodvine: ReagentData['monster']['bloodvine']
--   - Added Primal Bat Leather: ReagentData['leather']['primalbat']
--   - Added Primal Tiger Leather: ReagentData['leather']['primaltiger']
--   - Added Elementium Ore: ReagentData['ore']['elementium']
--   - Added Elemental Flux: ReagentData['flux']['elementium']
--   - Added Souldarite: ReagentData['gem']['souldarite']
--   - Added Huge Venom Sac: ReagentData['monster']['hugevenomsac']
--   - Added ReagentData['bandage']['powerfulantivenom']
--   - Changed ReagentData['monster']['coreleather'] to ReagentData['leather']['core']
--
-- * Alchemy
--   - Corrected Major Rejuvenation Potion (spelling error)
--   - Corrected Restorative Potion (name change)
--   - Added Elemental Air to ReagentData['alchemy']
--   - Added Large Fang to ReagentData['alchemy']
--   - Added Heart of the Wild to ReagentData['alchemy']
--   - Removed Oil of Immolation from ReagentData['alchemy'] since it's not used in any recipes
--   - Removed Goblin Rocket Fuel from ReagentData['alchemy'] since it's not used in any recipes
--   - Added Mageblood Potion, Greater Dreamless Sleep Potion, Living Action Potion, and 
--     Major Troll's Blood Potion recipes
--
-- * Blacksmithing
--   - Too many recipe changes to list individually.  The recipe list should be far, far more accurate now.
--   - Added Elemental Air to ReagentData['blacksmithing']
--   - Added Essence of Undeath to ReagentData['blacksmithing']
--   - Added Core Leather to ReagentData['blacksmithing']
--   - Added Sulfuron Ingot to ReagentData['blacksmithing']
--   - Added Bloodvine to ReagentData['blacksmithing']
--   - Added Souldarite to ReagentData['blacksmithing']
--   - Corrected Elixir of Ogre's Strength in ReagentData['blacksmithing'] (spelling error)
--   - Corrected Lesser Invisibility Potion in ReagentData['blacksmithing'] (spelling error)
--
-- * Enchanting
--   - Corrected skill level on Lesser Magic, Greater Magic, and Lesser Mystic wands
--   - Added in all enchanting effects thanks to data from Fara!
--
-- * Engineering: 
--   - Removed several Unknown Items
--   - Removed Strong Flux and Elemental Flux from ReagentData['flux']
--   - Added Truesilver Transformer to ReagentData['part'] and ReagentData['engineering']
--   - Added The Big One to ReagentData['part'] and ReagentData['engineering']
--   - Added Essence of Water to ReagentData['engineering']
--   - Added Elemental Air to ReagentData['engineering'].  Man this stuff is popualr.
--   - Added Essence of Undeath to ReagentData['engineering']
--   - Added Icecap to ReagentData['engineering']
--   - Added Deeprock Salt to ReagentData['engineering']
--   - Added Bloodvine to ReagentData['engineering']
--   - Added Souldarite to ReagentData['engineering']
--   - Added Powerful Mojo to ReagentData['engineering']
--   - Added Hyper-Radiant Flame Reflector, Dimensional Ripper - Everlook, Green Firework, EZ-Thro Dynamite II,
--     Red Firework, Blue Firework, Powerful Seaforium Charge, Gyrofreeze Ice Deflector, World Enlarger,
--     Alarm-O-Bot, Ultrasafe Transporter - Gadgetzan, Ultra-Flash Shadow Reflector, Dense Dynamite,
--     Snake Burst Firework, Bloodvine Goggles, and Bloodvine Lens recipes.
--
-- * First Aid
--   - Added ReagentData['monster']['hugevenomsac']
--
-- * Leatherworking
--   - Removed Mageweave Bolt from ReagentData['leatherworking']
--   - Added Righteous Orb to ReagentData['leatherworking']
--   - Added Ironweb Spider Silk to ReagentData['leatherworking']
--   - Added Powerful Mojo to ReagentData['leatherworking']
--   - Added Runecloth Bolt to ReagentData['leatherworking']
--   - Added Felcloth to ReagentData['leatherworking']
--   - Added Mooncloth to ReagentData['leatherworking']
--   - Added Jet Black Feather to ReagentData['leatherworking']
--   - Added Bloodvine to ReagentData['leatherworking']
--   - Added Golden Mantle of the Dawn, Heavy Leather Ball, Lava Belt, Barbaric Bracers, Dawn Treaders,
--     Molten Belt, Might of the Timbermaw, Timbermaw Brawlers, Chromatic Gauntlets, Corehound Belt,
--     Primal Batskin Jerkin, Primal Batskin Gloves, Primal Batskin Bracers, Blood Tiger Breastplate,
--     Blood Tiger Shoulders, recipes.
--
-- * Mining
--   - Added Smelt Elementium
--
-- * Tailoring
--   - Removed several Unknown Items
--   - Added Enchanted Leather to ReagentData['tailoring']
--   - Added Living Essence to ReagentData['tailoring']
--   - Added Essence of Earth to ReagentData['tailoring']
--   - Added Arcanite Bar to ReagentData['tailoring']
--   - Added Bloodvine to ReagentData['tailoring']
--   - Added Argent Boots, Flarecore Leggings, Wisdom of the Timbermaw, Mantle of the Timbermaw, Argent Shoulders
--     Flarecore Robe, Bloodvine Vest, Bloodvine Leggings, and Bloodvine Boots recipes.

---------------
-- Bug Fixes --
---------------
--
-- * More German translation corrections.  You crazy kids and your umlautes.

-----------------------------------------------------------
-- For a full change history, please see the readme file --
-----------------------------------------------------------

---------------
-- MOD START --
---------------

-- Reagent Data Start
--
-- The ReagentData table holds the complete reagent information for this addon.  It was created with two 
-- principles in mind.  
--
-- First, each reagent will only appear by name once.  That means that there will only be one place
-- that says "Light Leather".  Any other references to the item will call the table reference to that base name.
-- This cuts down on potential typos, makes translations easier, and cuts down on memory usage by using LUA's
-- table reference mechanisms instead of flinging multiple copies of the strings into memory.
--
-- Second, reagents will be broken down into logical base groups based on a common attribute.  For example,
-- all leathers appear in a ReagentData['leather'] category because they're all leathers.  After the base groups,
-- other logical groups such as professions and vendor items are built by referencing the base groups as 
-- mentioned earlier.
--
-- One benefit of this mechanism is that only the base groups need to be altered for a translation.  By creating
-- a new GetLocale() if block that contains translations for the base groups, all references to those items are
-- automatically translated into the new language based on the client's settings.  For example, if your code
-- references ReagentData['leather']['light'], it will resolve to "Light Leather" on English clients.  However,
-- if a German client runs your mod, it will automatically resolve to "Leichtes Leder" without any special
-- effort on your part.
--
-- For those who may be wondering, base group names are based on the English version of the items.  This was a
-- conscious decision on my part.  The way I saw it, I had two options.  I could either use the English names
-- in some way or go with an arbitrary addressing system to make the system language independent.  The English
-- version was quick to develop and can be easily checked for accuracy; it's a lot easier to spot a typo in the
-- translation of ReagentData['leather']['light'] than it is ReagentData[1][15].  In addition, I made the
-- assumption that mod authors know at least a little English considering that LUA and the Warcraft API both
-- stem from English.  Lastly, the arbitrary address system would require another level of accessors to grab data.
-- This would be fine and preferable in an object oriented setup, but I wanted mods to touch the data directly so
-- that the library could tailor itself to the mod author's needs.  I cannot possibly predict every way someone 
-- would want to view the reagent data, so making an API that's flexible enough would be challenging or impossible.
-- So I hope no one's offended at my indexing scheme.  :-)

---------------------
-- Helper Function --
---------------------

-- ReagentData_Flatten(table)
--
-- This function takes a two-dimensional table and flattens it.  This is
-- necessary due to the way profession tables are built (to assist in
-- maintainability).  If necessary, this function can be extended to an 
-- n-dimensional table by way of recursion, though this requires a minor
-- logic change and will not be done unless necessary.

function ReagentData_Flatten(table)
     if (type(table) ~= "table") then
	  return;
     end

     local returnTable = {};

     for key,value in table do
	  if (type(value) == "table") then
	       for subKey, subValue in value do
		    tinsert(returnTable, subValue);
	       end
	  else
	       tinsert(returnTable, value);
	  end
     end

     return returnTable;
end

ReagentData = {};
ReagentData['crafted'] = {};

-- Reagent Data: Version
ReagentData['version'] = "2.2.1";

-------------------------------
-- Reagent Data: Data Tables --
-------------------------------

-----------------
-- Basic Items --
-----------------

-- Reagent Data: Alchemy Fish
ReagentData["alchemyfish"] = {
     ["oilyblackmouth"] = "Oily Blackmouth",
     ["firefinsnapper"] = "Firefin Snapper",
     ["stonescaleeel"] = "Stonescale Eel",
};

-- Reagent Data: Bandages
ReagentData["bandage"] = {
     ["linen"] = "Linen Bandage",
     ["heavylinen"] = "Heavy Linen Bandage",
     ["wool"] = "Wool Bandage",
     ["heavywool"] = "Heavy Wool Bandage",
     ["silk"] = "Silk Bandage",
     ["heavysilk"] = "Heavy Silk Bandage",
     ["mageweave"] = "Mageweave Bandage",
     ["heavymageweave"] = "Heavy Mageweave Bandage",
     ["runecloth"] = "Runecloth Bandage",
     ["heavyrunecloth"] = "Heavy Runecloth Bandage",
     ["antivenom"] = "Anti-Venom",
     ["strongantivenom"] = "Strong Anti-Venom",
     ["powerfulantivenom"] = "Powerful Anti-Venom",
};

-- Reagent Data: Bar
ReagentData["bar"] = {
     ["copper"] = "Copper Bar",
     ["tin"] = "Tin Bar",
     ["bronze"] = "Bronze Bar",
     ["silver"] = "Silver Bar",
     ["iron"] = "Iron Bar",
     ["steel"] = "Steel Bar",
     ["gold"] = "Gold Bar",
     ["mithril"] = "Mithril Bar",
     ["truesilver"] = "Truesilver Bar",
     ["thorium"] = "Thorium Bar",
     ["arcanite"] = "Arcanite Bar",
     ["darkiron"] = "Dark Iron Bar",
     ["enchantedthorium"] = "Enchanted Thorium Bar",
};

-- Reagent Data: Cloth
ReagentData["cloth"] = {
     ["linen"] = "Linen Cloth",
     ["wool"] = "Wool Cloth",
     ["silk"] = "Silk Cloth",
     ["mageweave"] = "Mageweave Cloth",
     ["rune"] = "Runecloth",
     ["fel"] = "Felcloth",
     ["moon"] = "Mooncloth",
};

-- Reagent Data: Cooking Fish
ReagentData["cookingfish"] = {
     ["rawslitherskinmackerel"] = "Raw Slitherskin Mackerel",
     ["rawbrilliantsmall"] = "Raw Brilliant Smallfish",
     ["rawlochfrenzy"] = "Raw Loch Frenzy",
     ["rawlongjawmudsnapper"] = "Raw Longjaw Mud Snapper",
     ["rawrainbowfinalbacore"] = "Raw Rainbow Fin Albacore",
     ["deviate"] = "Deviate Fish",
     ["rawbristlewhiskercat"] = "Raw Bristle Whisker Catfish",
     ["rawrockscalecod"] = "Raw Rockscale Cod",
     ["rawmithrilheadtrout"] = "Raw Mithril Head Trout",
     ["rawredgill"] = "Raw Redgill",
     ["rawspottedyellowtail"] = "Raw Spotted Yellowtail",
     ["largerawmightfish"] = "Large Raw Mightfish",
     ["rawsummerbass"] = "Raw Summer Bass",
     ["wintersquid"] = "Winter Squid",
     ["rawsunscalesalmon"] = "Raw Sunscale Salmon",
     ["rawnightfinsnapper"] = "Raw Nightfin Snapper",
     ["rawwhitescalesalmon"] = "Raw Whitescale Salmon",
     ["darkclawlobster"] = "Darkclaw Lobster",
     ["rawglossymightfish"] = "Raw Glossy Mightfish",
};

-- Reagent Data: Elements
ReagentData["element"] = {
     ["earth"] = "Elemental Earth",
     ["fire"] = "Elemental Fire",
     ["water"] = "Elemental Water",
     ["air"] = "Elemental Air",
     ["ichorofundeath"] = "Ichor of Undeath",
     ["heartofthewild"] = "Heart of the Wild",
     ["coreofearth"] = "Core of Earth",
     ["heartoffire"] = "Heart of Fire",
     ["globeofwater"] = "Globe of Water",
     ["breathofwind"] = "Breath of Wind",
     ["essenceofearth"] = "Essence of Earth",
     ["essenceofwater"] = "Essence of Water",
     ["essenceofair"] = "Essence of Air",
     ["essenceoffire"] = "Essence of Fire",
     ["essenceofundeath"] = "Essence of Undeath",
     ["livingessence"] = "Living Essence",
};

-- Reagent Data: Gems
ReagentData["gem"] = {
     ["malachite"] = "Malachite",
     ["tigerseye"] = "Tigerseye",
     ["shadow"] = "Shadowgem",
     ["lessermoonstone"] = "Lesser Moonstone",
     ["mossagate"] = "Moss Agate",
     ["jade"] = "Jade",
     ["citrine"] = "Citrine",
     ["aquamarine"] = "Aquamarine",
     ["starruby"] = "Star Ruby",
     ["blackvitriol"] = "Black Vitriol",
     ["largeopal"] = "Large Opal",
     ["hugeemerald"] = "Huge Emerald",
     ["bluesapphire"] = "Blue Sapphire",
     ["azerothiandiamond"] = "Azerothian Diamond",
     ["arcanecrystal"] = "Arcane Crystal",
     ["bloodofthemountain"] = "Blood of the Mountain",
     ["blackdiamond"] = "Black Diamond",
     ["souldarite"] = "Souldarite",
};

-- Reagent Data: Herbs
ReagentData["herb"] = {
     ["peacebloom"] = "Peacebloom",
     ["silverleaf"] = "Silverleaf",
     ["earthroot"] = "Earthroot",
     ["mageroyal"] = "Mageroyal",
     ["briarthorn"] = "Briarthorn",
     ["swifthistle"] = "Swiftthistle",
     ["stranglekelp"] = "Stranglekelp",
     ["bruiseweed"] = "Bruiseweed",
     ["wildsteelbloom"] = "Wild Steelbloom",
     ["gravemoss"] = "Grave Moss",
     ["kingsblood"] = "Kingsblood",
     ["liferoot"] = "Liferoot",
     ["fadeleaf"] = "Fadeleaf",
     ["goldthorn"] = "Goldthorn",
     ["khadgarswhisker"] = "Khadgar's Whisker",
     ["wintersbite"] = "Wintersbite",
     ["firebloom"] = "Firebloom",
     ["purplelotus"] = "Purple Lotus",
     ["sungrass"] = "Sungrass",
     ["blindweed"] = "Blindweed",
     ["ghostmushroom"] = "Ghost Mushroom",
     ["gromsblood"] = "Gromsblood",
     ["wildvine"] = "Wildvine",
     ["icecap"] = "Icecap",
     ["arthastears"] = "Arthas' Tears",
     ["dreamfoil"] = "Dreamfoil",
     ["goldensansam"] = "Golden Sansam",
     ["mountainsilversage"] = "Mountain Silversage",
     ["plaguebloom"] = "Plaguebloom",
     ["blacklotus"] = "Black Lotus",
     ["bloodvine"] = "Bloodvine",
};

-- Reagent Data: Hide
ReagentData["hide"] = {
     ["light"] = "Light Hide",
     ["medium"] = "Medium Hide",
     ["heavy"] = "Heavy Hide",
     ["thick"] = "Thick Hide",
     ["rugged"] = "Rugged Hide",
     ["raptor"] = "Raptor Hide",
     ["thickwolf"] = "Thick Wolfhide",
     ["shadowcat"] = "Shadowcat Hide",
     ["curedlight"] = "Cured Light Hide",
     ["curedmedium"] = "Cured Medium Hide",
     ["curedheavy"] = "Cured Heavy Hide",
     ["curedthick"] = "Cured Thick Hide",
     ["curedrugged"] = "Cured Rugged Hide",
};

-- Reagent Data: Leather
ReagentData["leather"] = {
     ["ruinedscraps"] = "Ruined Leather Scraps",
     ["light"] = "Light Leather",
     ["medium"] = "Medium Leather",
     ["heavy"] = "Heavy Leather",
     ["thick"] = "Thick Leather",
     ["rugged"] = "Rugged Leather",
     ["enchanted"] = "Enchanted Leather",
     ["devilsaur"] = "Devilsaur Leather",
     ["thinkodo"] = "Thin Kodo Leather",
     ["chimera"] = "Chimera Leather",
     ["frostsaber"] = "Frostsaber Leather",
     ["warbear"] = "Warbear Leather",
     ["core"] = "Core Leather",     
     ["primalbat"] = "Primal Bat Leather",
     ["primaltiger"] = "Primal Tiger Leather",
};

-- Reagent Data: Ore
ReagentData["ore"] = {
     ["copper"] = "Copper Ore",
     ["tin"] = "Tin Ore",
     ["silver"] = "Silver Ore",
     ["iron"] = "Iron Ore",
     ["gold"] = "Gold Ore",
     ["mithril"] = "Mithril Ore",
     ["truesilver"] = "Truesilver Ore",
     ["thorium"] = "Thorium Ore",
     ["darkiron"] = "Dark Iron Ore",
     ["elementium"] = "Elementium Ore",
};

-- Reagent Data: Pearl
ReagentData["pearl"] = {
     ["smalllustrous"] = "Small Lustrous Pearl",
     ["iridescent"] = "Iridescent Pearl",
     ["blue"] = "Blue Pearl",
     ["black"] = "Black Pearl",
     ["golden"] = "Golden Pearl",
};

-- Reagent Data: Poisons
ReagentData["poison"] = {
     ["instant"] = "Instant Poison",
     ["crippling"] = "Crippling Poison",
     ["mindnumbing"] = "Mind-numbing Poison",
     ["instantii"] = "Instant Poison II",
     ["deadly"] = "Deadly Poison",
     ["instantv"] = "Instant Poison V",
     ["woundiv"] = "Wound Poison IV",
     ["deadlyiii"] = "Deadly Poison III",
     ["wound"] = "Wound Poison",
     ["deadlyiv"] = "Deadly Poison IV",
     ["woundii"] = "Wound Poison II",
     ["instantiii"] = "Instant Poison III",
     ["cripplingii"] = "Crippling Poison II",
     ["instantiv"] = "Instant Poison IV",
     ["woundiii"] = "Wound Poison III",
     ["deadlyii"] = "Deadly Poison II",
     ["instantvi"] = "Instant Poison VI",
     ["mindnumbingii"] = "Mind-numbing Poison II",
     ["mindnumbingiii"] = "Mind-numbing Poison III",
};

-- Reagent Data: Potions
ReagentData["potion"] = {
     ["minorhealing"] = "Minor Healing Potion",
     ["elixirofdetectdemon"] = "Elixir of Detect Demon",
     ["swiftness"] = "Swiftness Potion",
     ["elixirofbruteforce"] = "Elixir of Brute Force",
     ["freeaction"] = "Free Action Potion",
     ["majormana"] = "Major Mana Potion",
     ["elixirofgiantgrowth"] = "Elixir of Giant Growth",
     ["dreamlesssleep"] = "Dreamless Sleep Potion",
     ["greaterarcaneelixir"] = "Greater Arcane Elixir",
     ["flaskofdistilledwisdom"] = "Flask of Distilled Wisdom",
     ["mightytrollsblood"] = "Mighty Troll's Blood Potion",
     ["elixirofgreaterintellect"] = "Elixir of Greater Intellect",
     ["elixirofdefense"] = "Elixir of Defense",
     ["flaskofsupremepower"] = "Flask of Supreme Power",
     ["arcaneelixir"] = "Arcane Elixir",
     ["flaskofpetrification"] = "Flask of Petrification",
     ["flaskofchromaticresistance"] = "Flask of Chromatic Resistance",
     ["shadowprotection"] = "Shadow Protection Potion",
     ["greatershadowprotection"] = "Greater Shadow Protection Potion",
     ["swimspeed"] = "Swim Speed Potion",
     ["flaskofthetitans"] = "Flask of the Titans",
     ["elixirofagility"] = "Elixir of Agility",
     ["elixirofminordefense"] = "Elixir of Minor Defense",
     ["natureprotection"] = "Nature Protection Potion",
     ["elixirofgreateragility"] = "Elixir of Greater Agility",
     ["elixirofdreamvision"] = "Elixir of Dream Vision",
     ["elixirofminoragility"] = "Elixir of Minor Agility",
     ["catseyeelixir"] = "Catseye Elixir",
     ["weaktrollsblood"] = "Weak Troll's Blood Potion",
     ["elixirofgreaterdefense"] = "Elixir of Greater Defense",
     ["greaterstoneshield"] = "Greater Stoneshield Potion",
     ["minormana"] = "Minor Mana Potion",
     ["giftofarthas"] = "Gift of Arthas",
     ["elixirofshadowpower"] = "Elixir of Shadow Power",
     ["mightyrage"] = "Mighty Rage Potion",
     ["minorrejuvenation"] = "Minor Rejuvenation Potion",
     ["elixiroflionsstrength"] = "Elixir of Lion's Strength",
     ["healing"] = "Healing Potion",
     ["greatermana"] = "Greater Mana Potion",
     ["lesserinvisibility"] = "Lesser Invisibility Potion",
     ["elixirofdetectlesserinvisibility"] = "Elixir of Detect Lesser Invisibility",
     ["fireprotection"] = "Fire Protection Potion",
     ["discoloredhealing"] = "Discolored Healing Potion",
     ["majorhealing"] = "Major Healing Potion",
     ["lesserstoneshield"] = "Lesser Stoneshield Potion",
     ["elixirofdetectundead"] = "Elixir of Detect Undead",
     ["elixirofthemongoose"] = "Elixir of the Mongoose",
     ["holyprotection"] = "Holy Protection Potion",
     ["lessermana"] = "Lesser Mana Potion",
     ["elixiroffortitude"] = "Elixir of Fortitude",
     ["elixirofminorfortitude"] = "Elixir of Minor Fortitude",
     ["elixirofdemonslaying"] = "Elixir of Demonslaying",
     ["mana"] = "Mana Potion",
     ["frostprotection"] = "Frost Protection Potion",
     ["elixirofgiants"] = "Elixir of Giants",
     ["elixiroffrostpower"] = "Elixir of Frost Power",
     ["elixirofpoisonresistance"] = "Elixir of Poison Resistance",
     ["strongtrollsblood"] = "Strong Troll's Blood Potion",
     ["lesserhealing"] = "Lesser Healing Potion",
     ["greaterhealing"] = "Greater Healing Potion",
     ["magicresistance"] = "Magic Resistance Potion",
     ["restorativeelixir"] = "Restorative Potion",
     ["elixirofwisdom"] = "Elixir of Wisdom",
     ["rage"] = "Rage Potion",
     ["greatrage"] = "Great Rage Potion",
     ["elixirofogresstrength"] = "Elixir of Ogre's Strength",
     ["superiorhealing"] = "Superior Healing Potion",
     ["minormagicresistance"] = "Minor Magic Resistance Potion",
     ["elixirofthesages"] = "Elixir of the Sages",
     ["elixiroffirepower"] = "Elixir of Firepower",
     ["greaterfireprotection"] = "Greater Fire Protection Potion",
     ["elixiroflesseragility"] = "Elixir of Lesser Agility",
     ["purificationpotion"] = "Purification Potion",
     ["superiormana"] = "Superior Mana Potion",
     ["wildvine"] = "Wildvine Potion",
     ["elixirofwaterbreathing"] = "Elixir of Water Breathing",
     ["limitedinvulnerability"] = "Limited Invulnerability Potion",
     ["elixirofsuperiordefense"] = "Elixir of Superior Defense",
     ["invisibility"] = "Invisibility Potion",
};

-- Reagent Data: Spell Reagents
ReagentData["reagent"] = {
     ["ironwoodseed"] = "Ironwood Seed",
     ["soulshard"] = "Soul Shard",
     ["ankh"] = "Ankh",
     ["hornbeamseed"] = "Hornbeam Seed",
     ["demonicfigurine"] = "Demonic Figurine",
     ["mapleseed"] = "Maple Seed",
     ["infernalstone"] = "Infernal Stone",
     ["runeofteleportation"] = "Rune of Teleportation",
     ["wildthornroot"] = "Wild Thornroot",
     ["runeofportals"] = "Rune of Portals",
     ["ashwoodseed"] = "Ashwood Seed",
     ["wildberries"] = "Wild Berries",
     ["lightfeather"] = "Light Feather",
     ["fishoil"] = "Fish Oil",
     ["flashpowder"] = "Flash Powder",
     ["holycandle"] = "Holy Candle",
     ["sacredcandle"] = "Sacred Candle",
     ["stranglethornseed"] = "Stranglethorn Seed",
     ["symbolofdivinity"] = "Symbol of Divinity",
     ["blindingpowder"] = "Blinding Powder",
     ["shinyfishscales"] = "Shiny Fish Scales",
};

-- Reagent Data: Scales
ReagentData["scale"] = {
     ["bluedragon"] = "Blue Dragonscale",
     ["redwhelp"] = "Red Whelp Scale",
     ["perfectdeviate"] = "Perfect Deviate Scale",
     ["reddragon"] = "Red Dragonscale",
     ["greenwhelp"] = "Green Whelp Scale",
     ["turtle"] = "Turtle Scale",
     ["greendragon"] = "Green Dragonscale",
     ["blackdragon"] = "Black Dragonscale",
     ["blackwhelp"] = "Black Whelp Scale",
     ["worndragon"] = "Worn Dragonscale",
     ["deviate"] = "Deviate Scale",
     ["scorpid"] = "Scorpid Scale",
     ["heavyscorpid"] = "Heavy Scorpid Scale",
};

-- Reagent Data: Stone
ReagentData["stone"] = {
     ["solid"] = "Solid Stone",
     ["dense"] = "Dense Stone",
     ["rough"] = "Rough Stone",
     ["coarse"] = "Coarse Stone",
     ["heavy"] = "Heavy Stone",
};

-------------------------------
-- Tradeskill Produced Items --
-------------------------------

-- Reagent Data: Armors (Only those used in other tradeskills)
ReagentData["armor"] = {
     ["goblinconstructionhelmet"] = "Goblin Construction Helmet",
     ["fineleathertunic"] = "Fine Leather Tunic",
     ["greenleather"] = "Green Leather Armor",
     ["greentintedgoggles"] = "Green Tinted Goggles",
     ["flyingtigergoggles"] = "Flying Tiger Goggles",
     ["firegoggles"] = "Fire Goggles",
     ["spellpowergogglesxtreme"] = "Spellpower Goggles Xtreme",
     ["blackmageweaveboots"] = "Black Mageweave Boots",
     ["guardiangloves"] = "Guardian Gloves",
     ["cinderclothcloak"] = "Cindercloth Cloak",
     ["fineleatherbelt"] = "Fine Leather Belt",
     ["fineleathergloves"] = "Fine Leather Gloves",
     ["duskybelt"] = "Dusky Belt",
     ["ironbuckle"] = "Iron Buckle",
};

-- Reagent Data: Cloth Bolts
ReagentData["bolt"] = {
     ["wool"] = "Bolt of Woolen Cloth",
     ["rune"] = "Bolt of Runecloth",
     ["mageweave"] = "Bolt of Mageweave",
     ["silk"] = "Bolt of Silk Cloth",
     ["linen"] = "Bolt of Linen Cloth",
};

-- Reagent Data: Grinding Stones
ReagentData["grinding"] = {
     ["solid"] = "Solid Grinding Stone",
     ["dense"] = "Dense Grinding Stone",
     ["rough"] = "Rough Grinding Stone",
     ["coarse"] = "Coarse Grinding Stone",
     ["heavy"] = "Heavy Grinding Stone",
};

-- Reagent Data: Oils
ReagentData["oil"] = {
     ["goblinrocketfuel"] = "Goblin Rocket Fuel",
     ["blackmouth"] = "Blackmouth Oil",
     ["shadow"] = "Shadow Oil",
     ["fire"] = "Fire Oil",
     ["immolation"] = "Oil of Immolation",
     ["stonescale"] = "Stonescale Oil",
     ["frost"] = "Frost Oil",
};

-- Reagent Data: Other (Items that don't fit in other categories)
ReagentData["other"] = {
     ["yellowpowercrystal"] = "Yellow Power Crystal",
     ["philosophersstone"] = "Philosophers' Stone",
     ["redpowercrystal"] = "Red Power Crystal",
     ["snowball"] = "Snowball",
     ["runntumtuber"] = "Runn Tum Tuber",
     ["greenpowercrystal"] = "Green Power Crystal",
     ["bluepowercrystal"] = "Blue Power Crystal",
};

-- Reagent Data: Blasting Powder
ReagentData["powder"] = {
     ["solid"] = "Solid Blasting Powder",
     ["dense"] = "Dense Blasting Powder",
     ["rough"] = "Rough Blasting Powder",
     ["coarse"] = "Coarse Blasting Powder",
     ["heavy"] = "Heavy Blasting Powder",
};

-- Reagent Data: Engineering Parts
ReagentData["part"] = {
     ["coppertube"] = "Copper Tube",
     ["woodenstock"] = "Wooden Stock",
     ["mithrilmechanicaldragonling"] = "Mithril Mechanical Dragonling",
     ["delicatearcaniteconverter"] = "Delicate Arcanite Converter",
     ["bronzetube"] = "Bronze Tube",
     ["fusedwiring"] = "Fused Wiring",
     ["thoriumwidget"] = "Thorium Widget",
     ["deadlyscope"] = "Deadly Scope",
     ["coppermodulator"] = "Copper Modulator",
     ["bigironbomb"] = "Big Iron Bomb",
     ["heavystock"] = "Heavy Stock",
     ["unstabletrigger"] = "Unstable Trigger",
     ["silvercontact"] = "Silver Contact",
     ["accuratescope"] = "Accurate Scope",
     ["handfulofcopperbolts"] = "Handful of Copper Bolts",
     ["ironstrut"] = "Iron Strut",
     ["soliddynamite"] = "Solid Dynamite",
     ["mithriltube"] = "Mithril Tube",
     ["gyrochronatom"] = "Gyrochronatom",
     ["inlaidmithrilcylinder"] = "Inlaid Mithril Cylinder",
     ["goldpowercore"] = "Gold Power Core",
     ["mithrilcasing"] = "Mithril Casing",
     ["bronzeframework"] = "Bronze Framework",
     ["blankparchment"] = "Blank Parchment",
     ["engineersink"] = "Engineer's Ink",
     ["whirringbronzegizmo"] = "Whirring Bronze Gizmo",
     ["thoriumtube"] = "Thorium Tube",
     ["truesilvertransformer"] = "Truesilver Transformer",
     ["thebigone"] = "The Big One",
};

-- Reagent Data: Rods
ReagentData["rod"] = {
     ["golden"] = "Golden Rod",
     ["arcanite"] = "Arcanite Rod",
     ["truesilver"] = "Truesilver Rod",
     ["silver"] = "Silver Rod",
     ["copper"] = "Copper Rod",
};

-------------------------
-- Enchanting Reagents --
-------------------------

-- Reagent Data: Dusts
ReagentData["dust"] = {
     ["vision"] = "Vision Dust",
     ["soul"] = "Soul Dust",
     ["strange"] = "Strange Dust",
     ["dream"] = "Dream Dust",
     ["illusion"] = "Illusion Dust",
};

-- Reagent Data: Essences
ReagentData["essence"] = {
     ["lessereternal"] = "Lesser Eternal Essence",
     ["lessermystic"] = "Lesser Mystic Essence",
     ["greaterastral"] = "Greater Astral Essence",
     ["greatermystic"] = "Greater Mystic Essence",
     ["greaternether"] = "Greater Nether Essence",
     ["lesserastral"] = "Lesser Astral Essence",
     ["lessernether"] = "Lesser Nether Essence",
     ["greatermagic"] = "Greater Magic Essence",
     ["lessermagic"] = "Lesser Magic Essence",
     ["greatereternal"] = "Greater Eternal Essence",
};

-- Reagent Data: Shards
ReagentData["shard"] = {
     ["largeglimmering"] = "Large Glimmering Shard",
     ["largebrilliant"] = "Large Brilliant Shard",
     ["smallglowing"] = "Small Glowing Shard",
     ["smallglimmering"] = "Small Glimmering Shard",
     ["smallbrilliant"] = "Small Brilliant Shard",
     ["smallradiant"] = "Small Radiant Shard",
     ["largeradiant"] = "Large Radiant Shard",
     ["largeglowing"] = "Large Glowing Shard",
};

------------------
-- Vendor Items --
------------------

-- Reagent Data: Drinks (Only those used in tradeskills)
ReagentData["drink"] = {
     ["rhapsodymalt"] = "Rhapsody Malt",
     ["icecoldmilk"] = "Ice Cold Milk",
     ["holidyspirits"] = "Holiday Spirits",
     ["skinofdwarvenstout"] = "Skin of Dwarven Stout",
     ["refreshingspringwater"] = "Refreshing Spring Water",
};

-- Reagent Data: Dye
ReagentData["dye"] = {
     ["blue"] = "Blue Dye",
     ["ghost"] = "Ghost Dye",
     ["purple"] = "Purple Dye",
     ["red"] = "Red Dye",
     ["bleach"] = "Bleach",
     ["black"] = "Black Dye",
     ["green"] = "Green Dye",
     ["pink"] = "Pink Dye",
     ["yellow"] = "Yellow Dye",
     ["orange"] = "Orange Dye",
     ["gray"] = "Gray Dye",
};

-- Reagent Data: Flux
ReagentData["flux"] = {
     ["weak"] = "Weak Flux",
     ["strong"] = "Strong Flux",
     ["elemental"] = "Elemental Flux",
};

-- Reagent Data: Food (used in tradeskills)
ReagentData["food"] = {
     ["shinyredapple"] = "Shiny Red Apple",
};

-- Reagent Data: Poison Ingredients
ReagentData["poisoningredient"] = {
     ["dustofdecay"] = "Dust of Decay",
     ["essenceofpain"] = "Essence of Pain",
     ["essenceofagony"] = "Essence of Agony",
     ["dustofdeterioration"] = "Dust of Deterioration",
     ["deathweed"] = "Deathweed",
};

-- Reagent Data: Salt
ReagentData["salt"] = {
     ["refineddeeprock"] = "Refined Deeprock Salt",
     ["salt"] = "Salt",
     ["deeprock"] = "Deeprock Salt",
};

-- Reagent Data: Spices
ReagentData["spice"] = {
     ["soothing"] = "Soothing Spices",
     ["stormwindseasoningherbs"] = "Stormwind Seasoning Herbs",
     ["mild"] = "Mild Spices",
     ["holiday"] = "Holiday Spices",
     ["hot"] = "Hot Spices",
};

-- Reagent Data: Thread
ReagentData["thread"] = {
     ["heavysilken"] = "Heavy Silken Thread",
     ["rune"] = "Rune Thread",
     ["silken"] = "Silken Thread",
     ["coarse"] = "Coarse Thread",
     ["fine"] = "Fine Thread",
};

-- Reagent Data: Vendor Other
ReagentData["vendorother"] = {
     ["coal"] = "Coal",
     ["nightcrawlers"] = "Nightcrawlers",
};

-- Reagent Data: Vials
ReagentData["vial"] = {
     ["crystal"] = "Crystal Vial",
     ["imbued"] = "Imbued Vial",
     ["leaded"] = "Leaded Vial",
     ["empty"] = "Empty Vial",
};

-- Reagent Data: Wood
ReagentData["wood"] = {
     ["simple"] = "Simple Wood",
     ["star"] = "Star Wood",
};

-----------
-- Other --
-----------

-- Reagent Data: Monster Parts
ReagentData["monster"] = {
     ["tendercrocoliskmeat"] = "Tender Crocolisk Meat",
     ["stagmeat"] = "Stag Meat",
     ["powerfulmojo"] = "Powerful Mojo",
     ["lavacore"] = "Lava Core",
     ["crispspidermeat"] = "Crisp Spider Meat",
     ["largefang"] = "Large Fang",
     ["softfrenzyflesh"] = "Soft Frenzy Flesh",
     ["boarintestines"] = "Boar Intestines",
     ["leanwolfflank"] = "Lean Wolf Flank",
     ["stringyvulturemeat"] = "Stringy Vulture Meat",
     ["stringywolfmeat"] = "Stringy Wolf Meat",
     ["nagascale"] = "Naga Scale",
     ["murlocfin"] = "Murloc Fin",
     ["turtlemeat"] = "Turtle Meat",
     ["larvalacid"] = "Larval Acid",
     ["mysterymeat"] = "Mystery Meat",
     ["meatybatwing"] = "Meaty Bat Wing",
     ["sulfuroningot"] = "Sulfuron Ingot",
     ["smallvenomsac"] = "Small Venom Sac",
     ["crocoliskmeat"] = "Crocolisk Meat",
     ["whitespidermeat"] = "White Spider Meat",
     ["wickedclaw"] = "Wicked Claw",
     ["goretuskliver"] = "Goretusk Liver",
     ["righteousorb"] = "Righteous Orb",
     ["kodomeat"] = "Kodo Meat",
     ["skinofshadow"] = "Skin of Shadow",
     ["ogretannin"] = "Ogre Tannin",
     ["smallflamesac"] = "Small Flame Sac",
     ["spiderichor"] = "Spider Ichor",
     ["giantegg"] = "Giant Egg",
     ["smallspiderleg"] = "Small Spider Leg",
     ["demonicrune"] = "Demonic Rune",
     ["crawlerclaw"] = "Crawler Claw",
     ["clawmeat"] = "Clam Meat",
     ["chunkofboarmeat"] = "Chunk of Boar Meat",
     ["goretusksnout"] = "Goretusk Snout",
     ["zestyclammeat"] = "Zesty Clam Meat",
     ["flaskofbigmojo"] = "Flask of Big Mojo",
     ["tendercrabmeat"] = "Tender Crab Meat",
     ["gooeyspiderleg"] = "Gooey Spider Leg",
     ["flaskofoil"] = "Flask of Oil",
     ["giantclammeat"] = "Giant Clam Meat",
     ["scorpidstinger"] = "Scorpid Stinger",
     ["smallegg"] = "Small Egg",
     ["luckycharm"] = "Lucky Charm",
     ["toughcondormeat"] = "Tough Condor Meat",
     ["boarribs"] = "Boar Ribs",
     ["murloceye"] = "Murloc Eye",
     ["guardianstone"] = "Guardian Stone",
     ["largevenomsac"] = "Large Venom Sac",
     ["volatilerum"] = "Volatile Rum",
     ["brilliantchromaticscale"] = "Brilliant Chromatic Scale",
     ["coyotemeat"] = "Coyote Meat",
     ["crawlermeat"] = "Crawler Meat",
     ["bigbearmeat"] = "Big Bear Meat",
     ["stridermeat"] = "Strider Meat",
     ["tenderwolfmeat"] = "Tender Wolf Meat",
     ["flaskofmojo"] = "Flask of Mojo",
     ["coarsegorillahair"] = "Coarse Gorilla Hair",
     ["discoloredworgheart"] = "Discolored Worg Heart",
     ["scaleofonyxia"] = "Scale of Onyxia",
     ["bearmeat"] = "Bear Meat",
     ["buzzardwing"] = "Buzzard Wing",
     ["cragboarrib"] = "Crag Boar Rib",
     ["tangyclammeat"] = "Tangy Clam Meat",
     ["sharpclaw"] = "Sharp Claw",
     ["monster"] = "Soft Frenzy Flesh",
     ["thunderlizardtail"] = "Thunder Lizard Tail",
     ["lionmeat"] = "Lion Meat",
     ["raptoregg"] = "Raptor Egg",
     ["clammeat"] = "Clam Meat",
     ["tigermeat"] = "Tiger Meat",
     ["digrat"] = "Dig Rat",
     ["redwolfmeat"] = "Red Wolf Meat",
     ["slimymurlocscale"] = "Slimy Murloc Scale",
     ["heavykodomeat"] = "Heavy Kodo Meat",
     ["raptorflesh"] = "Raptor Flesh",
     ["fierycore"] = "Fiery Core",
     ["thickmurlocscale"] = "Thick Murloc Scale",
     ["massivemojo"] = "Massive Mojo",
     ["hugevenomsac"] = "Huge Venom Sac",
     ["sandwormmeat"] = "Sandworm Meat",
     ["darkrune"] = "Dark Rune",
     ["dreamscale"] = "Dreamscale",
     ["heavysilithidcarapace"] = "Heavy Silithid Carapace",
     ["lightsilithidcarapace"] = "Light Silithid Carapace",
     ["silithidchitin"] = "Silithid Chitin",
};

-- Reagent Data: Feathers
ReagentData["feather"] = {
     ["longtail"] = "Long Tail Feather",
     ["iron"] = "Ironfeather",
     ["jetblack"] = "Jet Black Feather",
     ["longelegant"] = "Long Elegant Feather",
};

-- Reagent Data: Spider Silk
ReagentData["spidersilk"] = {
     ["ironweb"] = "Ironweb Spider Silk",
     ["shadow"] = "Shadow Silk",
     ["thick"] = "Thick Spider's Silk",
     ["silk"] = "Spider's Silk",
};


---------------------------
-- Begin English Strings --
---------------------------

-- Reagent Data: Professions (Skills that produce a finished product)
ReagentData['professions'] = {};
ReagentData['professions']['alchemy'] = "Alchemy";
ReagentData['professions']['blacksmithing'] = "Blacksmithing";
ReagentData['professions']['cooking'] = "Cooking";
ReagentData['professions']['enchanting'] = "Enchanting";
ReagentData['professions']['engineering'] = "Engineering";
ReagentData['professions']['firstaid'] = "First Aid";
ReagentData['professions']['leatherworking'] = "Leatherworking";
ReagentData['professions']['tailoring'] = "Tailoring";

-- Reagent Data: Gather Skills (Skills to gather/find reagents)
ReagentData['gathering'] = {};
ReagentData['gathering']['fishing'] = "Fishing";
ReagentData['gathering']['herbalism'] = "Herbalism";
ReagentData['gathering']['mining'] = "Mining";
ReagentData['gathering']['skinning'] = "Skinning";

-- Reagent Data: Spell Reagents
ReagentData['spellreagents'] = {
     ["Druid"] = {
	  ReagentData['reagent']['mapleseed'],
	  ReagentData['reagent']['stranglethornseed'],
	  ReagentData['reagent']['ashwoodseed'],
	  ReagentData['reagent']['hornbeamseed'],
	  ReagentData['reagent']['ironwoodseed'],
	  ReagentData['reagent']['wildberries'],
	  ReagentData['reagent']['wildthornroot'],
     };
     ["Mage"] = {
	  ReagentData['reagent']['lightfeather'],
	  ReagentData['reagent']['runeofteleportation'],
	  ReagentData['reagent']['runeofportals'],
     };
     ["Paladin"] = {
	  ReagentData['reagent']['symbolofdivinity'],
     };
     ["Priest"] = {
	  ReagentData['reagent']['lightfeather'],
	  ReagentData['reagent']['holycandle'],
     };
     ["Rogue"] = {
	  ReagentData['reagent']['flashpowder'],
	  ReagentData['reagent']['blindingpowder'],
     };
     ["Shaman"] = {
	  ReagentData['reagent']['shinyfishscales'],
	  ReagentData['reagent']['fishoil'],
	  ReagentData['reagent']['ankh'],
     };
     ["Warlock"] = {
	  ReagentData['reagent']['infernalstone'],
	  ReagentData['reagent']['demonicfigurine'],
	  ReagentData['reagent']['soulshard'],
     };
};

-------------------------
-- End English Strings --
-------------------------

-- Now perform localizations if needed

if (GetLocale() == "deDE") then
     ReagentData_LoadGerman();
elseif (GetLocale() == "frFR") then
     ReagentData_LoadFrench();
end

------------------------------
-- Reagent Data Data Tables --
------------------------------

-----------------
-- Professions --
-----------------

-- Reagent Data: Alchemy
ReagentData['alchemy'] = ReagentData_Flatten({
     ReagentData['vial'],
     ReagentData['herb'],
     ReagentData['oil']['blackmouth'],
     ReagentData['oil']['fire'],
     ReagentData['oil']['shadow'],
     ReagentData['oil']['stonescale'],
     ReagentData['alchemyfish'],
     ReagentData['cookingfish']['deviate'],
     ReagentData['potion']['minorhealing'],
     ReagentData['monster']['discoloredworgheart'],
     ReagentData['monster']['sharpclaw'],
     ReagentData['monster']['largefang'],
     ReagentData['monster']['largevenomsac'],
     ReagentData['monster']['smallflamesac'],
     ReagentData['monster']['volatilerum'],
     ReagentData['monster']['scaleofonyxia'],
     ReagentData['monster']['heartofthewild'],
     ReagentData['ore']['mithril'],
     ReagentData['ore']['thorium'],
     ReagentData['bar']['iron'],
     ReagentData['bar']['mithril'],
     ReagentData['bar']['thorium'],
     ReagentData['gem']['blackvitriol'],
     ReagentData['gem']['arcanecrystal'],
     ReagentData['dye']['purple'],
     ReagentData['dust']['dream'],
     ReagentData['element']['air'],
     ReagentData['element']['earth'],
     ReagentData['element']['fire'],
     ReagentData['element']['water'],
     ReagentData['element']['ichorofundeath'],
     ReagentData['element']['essenceofair'],
     ReagentData['element']['essenceofearth'],
     ReagentData['element']['essenceoffire'],
     ReagentData['element']['essenceofwater'],
     ReagentData['element']['essenceofundeath'],
     ReagentData['element']['livingessence'],
     ReagentData['element']['heartofthewild'],
     ReagentData['other']['philosophersstone'],
});

-- Reagent Data: Blacksmithing
ReagentData['blacksmithing'] = ReagentData_Flatten({
     ReagentData['bar'],
     ReagentData['stone'],
     ReagentData['grinding'],
     ReagentData['flux']['weak'],
     ReagentData['flux']['strong'],
     ReagentData['cloth']['linen'],
     ReagentData['cloth']['wool'],
     ReagentData['cloth']['silk'],
     ReagentData['cloth']['mageweave'],
     ReagentData['cloth']['rune'],
     ReagentData['leather']['light'],
     ReagentData['leather']['medium'],
     ReagentData['leather']['heavy'],
     ReagentData['leather']['thick'],
     ReagentData['leather']['rugged'],
     ReagentData['leather']['enchanted'],
     ReagentData['leather']['core'],
     ReagentData['gem']['malachite'],
     ReagentData['gem']['tigerseye'],
     ReagentData['gem']['shadow'],
     ReagentData['gem']['mossagate'],
     ReagentData['gem']['lessermoonstone'],
     ReagentData['gem']['citrine'],
     ReagentData['gem']['jade'],
     ReagentData['gem']['aquamarine'],
     ReagentData['gem']['starruby'],
     ReagentData['gem']['bluesapphire'],
     ReagentData['gem']['hugeemerald'],
     ReagentData['gem']['largeopal'],
     ReagentData['gem']['azerothiandiamond'],
     ReagentData['gem']['souldarite'],
     ReagentData['pearl']['smalllustrous'],
     ReagentData['pearl']['iridescent'],
     ReagentData['pearl']['black'],
     ReagentData['other']['bluepowercrystal'],
     ReagentData['other']['greenpowercrystal'],
     ReagentData['other']['redpowercrystal'],
     ReagentData['other']['yellowpowercrystal'],
     ReagentData['gem']['bloodofthemountain'],
     ReagentData['thread']['fine'],
     ReagentData['dye']['green'],
     ReagentData['potion']['swiftness'],
     ReagentData['potion']['elixirofogresstrength'],
     ReagentData['potion']['lesserinvisibility'],
     ReagentData['element']['air'],
     ReagentData['element']['earth'],
     ReagentData['element']['fire'],
     ReagentData['element']['water'],
     ReagentData['element']['coreofearth'],
     ReagentData['element']['heartoffire'],
     ReagentData['element']['breathofwind'],
     ReagentData['element']['livingessence'],
     ReagentData['element']['ichorofundeath'],
     ReagentData['element']['essenceofearth'],
     ReagentData['element']['essenceoffire'],
     ReagentData['element']['essenceofwater'],
     ReagentData['element']['essenceofundeath'],
     ReagentData['oil']['shadow'],
     ReagentData['oil']['frost'],
     ReagentData['herb']['wildvine'],
     ReagentData['herb']['bloodvine'],
     ReagentData['monster']['demonicrune'],
     ReagentData['monster']['powerfulmojo'],
     ReagentData['monster']['largefang'],
     ReagentData['monster']['sharpclaw'],
     ReagentData['monster']['wickedclaw'],
     ReagentData['monster']['righteousorb'],
     ReagentData['monster']['fierycore'],
     ReagentData['monster']['lavacore'],
     ReagentData['monster']['guardianstone'],
     ReagentData['monster']['sulfuroningot'],
     ReagentData['monster']['darkrune'],
     ReagentData['feather']['jetblack'],
     ReagentData['armor']['greenleather'],
     ReagentData['armor']['guardiangloves'],
});

-- Reagent Data: Cooking
ReagentData['cooking'] = ReagentData_Flatten({
     ReagentData['monster']['chunkofboarmeat'],
     ReagentData['monster']['stringywolfmeat'],
     ReagentData['monster']['meatybatwing'],
     ReagentData['monster']['smallegg'],
     ReagentData['monster']['smallspiderleg'],
     ReagentData['monster']['scorpidstinger'],
     ReagentData['monster']['cragboarrib'],
     ReagentData['monster']['kodomeat'],
     ReagentData['monster']['bearmeat'],
     ReagentData['monster']['clammeat'],
     ReagentData['monster']['coyotemeat'],
     ReagentData['monster']['goretuskliver'],
     ReagentData['monster']['softfrenzyflesh'],
     ReagentData['monster']['giantclammeat'],
     ReagentData['monster']['stridermeat'],
     ReagentData['monster']['boarintestines'],
     ReagentData['monster']['spiderichor'],
     ReagentData['monster']['stringyvulturemeat'],
     ReagentData['monster']['murloceye'],
     ReagentData['monster']['goretusksnout'],
     ReagentData['monster']['crawlermeat'],
     ReagentData['monster']['crocoliskmeat'],
     ReagentData['monster']['boarribs'],
     ReagentData['monster']['crawlerclaw'],
     ReagentData['monster']['clawmeat'],
     ReagentData['monster']['digrat'],
     ReagentData['monster']['murlocfin'],
     ReagentData['monster']['crispspidermeat'],
     ReagentData['monster']['whitespidermeat'],
     ReagentData['monster']['toughcondormeat'],
     ReagentData['monster']['thunderlizardtail'],
     ReagentData['monster']['leanwolfflank'],
     ReagentData['monster']['gooeyspiderleg'],
     ReagentData['monster']['bigbearmeat'],
     ReagentData['monster']['stagmeat'],
     ReagentData['monster']['tendercrocoliskmeat'],
     ReagentData['monster']['tenderwolfmeat'],
     ReagentData['monster']['tangyclammeat'],
     ReagentData['monster']['raptoregg'],
     ReagentData['monster']['lionmeat'],
     ReagentData['monster']['buzzardwing'],
     ReagentData['monster']['raptorflesh'],
     ReagentData['monster']['mysterymeat'],
     ReagentData['monster']['tigermeat'],
     ReagentData['monster']['redwolfmeat'],
     ReagentData['monster']['heavykodomeat'],
     ReagentData['monster']['smallflamesac'],
     ReagentData['monster']['zestyclammeat'],
     ReagentData['monster']['giantegg'],
     ReagentData['monster']['tendercrabmeat'],
     ReagentData['monster']['sandwormmeat'],
     ReagentData['cookingfish'],
     ReagentData['spice'],
     ReagentData['drink'],
     ReagentData['food']['shinyredapple'],
     ReagentData['herb']['swifthistle'],
     ReagentData['herb']['goldthorn'],
});

-- Reagent Data: Enchanting
ReagentData['enchanting'] = ReagentData_Flatten({
     ReagentData['rod'],
     ReagentData['dust'],
     ReagentData['essence'],
     ReagentData['shard'],
     ReagentData['wood'],
     ReagentData['monster']['largefang'],
     ReagentData['monster']['righteousorb'],
     ReagentData['scale']['greenwhelp'],
     ReagentData['gem']['shadow'],
     ReagentData['pearl']['black'],
     ReagentData['pearl']['iridescent'],
     ReagentData['pearl']['golden'],
     ReagentData['gem']['aquamarine'],
     ReagentData['gem']['bloodofthemountain'],
     ReagentData['oil']['blackmouth'],
     ReagentData['oil']['fire'],
     ReagentData['oil']['frost'],
     ReagentData['potion']['elixirofdemonslaying'],
     ReagentData['ore']['iron'],
     ReagentData['bar']['truesilver'],
     ReagentData['bar']['thorium'],
     ReagentData['herb']['kingsblood'],
     ReagentData['herb']['wildvine'],
     ReagentData['herb']['sungrass'],
     ReagentData['herb']['icecap'],
     ReagentData['leather']['rugged'],
     ReagentData['element']['earth'],
     ReagentData['element']['fire'],
     ReagentData['element']['heartoffire'],
     ReagentData['element']['coreofearth'],
     ReagentData['element']['globeofwater'],
     ReagentData['element']['breathofwind'],
     ReagentData['element']['ichorofundeath'],
     ReagentData['element']['essenceofundeath'],
     ReagentData['element']['livingessence'],
});

-- Reagent Data: Engineering
ReagentData['engineering'] = ReagentData_Flatten({
     ReagentData['bar'],
     ReagentData['stone'],
     ReagentData['powder'],
     ReagentData['part'],
     ReagentData['flux']['weak'],
     ReagentData['cloth']['linen'],
     ReagentData['cloth']['wool'],
     ReagentData['cloth']['silk'],
     ReagentData['cloth']['mageweave'],
     ReagentData['cloth']['rune'],
     ReagentData['bolt']['mageweave'],
     ReagentData['gem']['malachite'],
     ReagentData['gem']['tigerseye'],
     ReagentData['gem']['mossagate'],
     ReagentData['gem']['shadow'],
     ReagentData['gem']['lessermoonstone'],
     ReagentData['gem']['jade'],
     ReagentData['gem']['citrine'],
     ReagentData['gem']['aquamarine'],
     ReagentData['gem']['starruby'],
     ReagentData['gem']['bluesapphire'],
     ReagentData['gem']['largeopal'],
     ReagentData['gem']['hugeemerald'],
     ReagentData['gem']['azerothiandiamond'],
     ReagentData['gem']['souldarite'],
     ReagentData['pearl']['blue'],
     ReagentData['monster']['smallflamesac'],
     ReagentData['vendorother']['nightcrawlers'],
     ReagentData['monster']['flaskofoil'],
     ReagentData['monster']['flaskofmojo'],
     ReagentData['monster']['powerfulmojo'],
     ReagentData['monster']['fierycore'],
     ReagentData['monster']['lavacore'],
     ReagentData['spidersilk']['thick'],
     ReagentData['spidersilk']['shadow'],
     ReagentData['spidersilk']['ironweb'],
     ReagentData['herb']['icecap'],
     ReagentData['herb']['wildvine'],
     ReagentData['herb']['bloodvine'],
     ReagentData['leather']['light'],
     ReagentData['leather']['medium'],
     ReagentData['leather']['heavy'],
     ReagentData['leather']['thick'],
     ReagentData['leather']['rugged'],
     ReagentData['leather']['enchanted'],
     ReagentData['element']['air'],
     ReagentData['element']['earth'],
     ReagentData['element']['fire'],
     ReagentData['element']['heartoffire'],
     ReagentData['element']['coreofearth'],
     ReagentData['element']['heartofthewild'],
     ReagentData['element']['livingessence'],
     ReagentData['element']['essenceofearth'],
     ReagentData['element']['essenceoffire'],
     ReagentData['element']['essenceofair'],
     ReagentData['element']['essenceofundeath'],
     ReagentData['element']['essenceofwater'],
     ReagentData['element']['ichorofundeath'],
     ReagentData['drink']['refreshingspringwater'],
     ReagentData['oil']['frost'],
     ReagentData['oil']['goblinrocketfuel'],
     ReagentData['salt']['deeprock'],
     ReagentData['potion']['catseyeelixir'],
     ReagentData['other']['snowball'],
     ReagentData['armor']['greentintedgoggles'],
     ReagentData['armor']['flyingtigergoggles'],
     ReagentData['armor']['firegoggles'],
     ReagentData['armor']['duskybelt'],
     ReagentData['armor']['blackmageweaveboots'],
     ReagentData['armor']['goblinconstructionhelmet'],
     ReagentData['armor']['spellpowergogglesxtreme'],
});

-- Reagent Data: First Aid
ReagentData['firstaid'] = ReagentData_Flatten({
     ReagentData['cloth']['linen'],
     ReagentData['cloth']['wool'],
     ReagentData['cloth']['silk'],
     ReagentData['cloth']['mageweave'],
     ReagentData['cloth']['rune'],
     ReagentData['monster']['smallvenomsac'],
     ReagentData['monster']['largevenomsac'],
     ReagentData['monster']['hugevenomsac'],
});

-- Reagent Data: Leatherworking
ReagentData['leatherworking'] = ReagentData_Flatten({
     ReagentData['leather'],
     ReagentData['hide'],
     ReagentData['scale'],
     ReagentData['salt'],
     ReagentData['thread'],
     ReagentData['dye']['bleach'],
     ReagentData['dye']['gray'],
     ReagentData['dye']['green'],
     ReagentData['dye']['black'],
     ReagentData['potion']['elixirofminoragility'],
     ReagentData['potion']['elixirofdefense'],
     ReagentData['potion']['elixirofwisdom'],
     ReagentData['potion']['elixiroflesseragility'],
     ReagentData['potion']['swiftness'],
     ReagentData['potion']['greatrage'],
     ReagentData['potion']['elixirofgreaterdefense'],
     ReagentData['potion']['elixirofagility'],
     ReagentData['oil']['shadow'],
     ReagentData['cloth']['fel'],
     ReagentData['cloth']['mageweave'],
     ReagentData['cloth']['moon'],
     ReagentData['cloth']['rune'],
     ReagentData['bolt']['wool'],
     ReagentData['bolt']['silk'],
     ReagentData['bolt']['rune'],
     ReagentData['monster']['slimymurlocscale'],
     ReagentData['monster']['thickmurlocscale'],
     ReagentData['monster']['flaskofmojo'],
     ReagentData['monster']['flaskofbigmojo'],
     ReagentData['monster']['powerfulmojo'],
     ReagentData['monster']['largefang'],
     ReagentData['monster']['coarsegorillahair'],
     ReagentData['monster']['wickedclaw'],
     ReagentData['monster']['luckycharm'],
     ReagentData['monster']['brilliantchromaticscale'],
     ReagentData['monster']['fierycore'],
     ReagentData['monster']['lavacore'],
     ReagentData['monster']['guardianstone'],
     ReagentData['monster']['larvalacid'],
     ReagentData['monster']['skinofshadow'],
     ReagentData['monster']['ogretannin'],
     ReagentData['monster']['scaleofonyxia'],
     ReagentData['monster']['righteousorb'],
     ReagentData['monster']['dreamscale'],
     ReagentData['monster']['silithidchitin'],
     ReagentData['monster']['heavysilithidcarapace'],
     ReagentData['monster']['lightsilithidcarapace'],
     ReagentData['feather']['longtail'],
     ReagentData['feather']['iron'],
     ReagentData['feather']['jetblack'],
     ReagentData['spidersilk']['silk'],
     ReagentData['spidersilk']['thick'],
     ReagentData['spidersilk']['ironweb'],
     ReagentData['pearl']['smalllustrous'],
     ReagentData['pearl']['iridescent'],
     ReagentData['pearl']['black'],
     ReagentData['gem']['shadow'],
     ReagentData['gem']['jade'],
     ReagentData['gem']['citrine'],
     ReagentData['gem']['mossagate'],
     ReagentData['gem']['blackdiamond'],
     ReagentData['herb']['kingsblood'],
     ReagentData['herb']['wildvine'],
     ReagentData['herb']['bloodvine'],
     ReagentData['element']['earth'],
     ReagentData['element']['water'],
     ReagentData['element']['globeofwater'],
     ReagentData['element']['coreofearth'],
     ReagentData['element']['heartoffire'],
     ReagentData['element']['livingessence'],
     ReagentData['element']['essenceoffire'],
     ReagentData['element']['essenceofwater'],
     ReagentData['element']['essenceofair'],
     ReagentData['element']['essenceofearth'],
     ReagentData['armor']['ironbuckle'],
     ReagentData['armor']['fineleathertunic'],
     ReagentData['armor']['fineleatherbelt'],
     ReagentData['armor']['fineleathergloves'],
     ReagentData['armor']['cinderclothcloak'],
});

-- Reagent Data: Tailoring
ReagentData['tailoring'] = ReagentData_Flatten({
     ReagentData['cloth'],
     ReagentData['bolt'],
     ReagentData['thread'],
     ReagentData['dye'],
     ReagentData['spidersilk'],
     ReagentData['leather']['light'],
     ReagentData['leather']['medium'],
     ReagentData['leather']['heavy'],
     ReagentData['leather']['thick'],
     ReagentData['leather']['rugged'],
     ReagentData['leather']['enchanted'],
     ReagentData['leather']['core'],
     ReagentData['pearl']['smalllustrous'],
     ReagentData['pearl']['iridescent'],
     ReagentData['pearl']['black'],
     ReagentData['pearl']['golden'],
     ReagentData['gem']['citrine'],
     ReagentData['gem']['jade'],
     ReagentData['gem']['starruby'],
     ReagentData['gem']['hugeemerald'],
     ReagentData['gem']['azerothiandiamond'],
     ReagentData['herb']['wildvine'],
     ReagentData['herb']['bloodvine'],
     ReagentData['potion']['elixirofwisdom'],
     ReagentData['potion']['shadowprotection'],
     ReagentData['potion']['healing'],
     ReagentData['potion']['mana'],
     ReagentData['oil']['shadow'],
     ReagentData['oil']['fire'],
     ReagentData['oil']['frost'],
     ReagentData['bar']['arcanite'],
     ReagentData['bar']['gold'],
     ReagentData['bar']['truesilver'],
     ReagentData['monster']['nagascale'],
     ReagentData['monster']['demonicrune'],
     ReagentData['monster']['fierycore'],
     ReagentData['monster']['lavacore'],
     ReagentData['monster']['guardianstone'],
     ReagentData['monster']['ogretannin'],
     ReagentData['monster']['righteousorb'],
     ReagentData['monster']['darkrune'],
     ReagentData['feather']['longelegant'],
     ReagentData['dust']['dream'],
     ReagentData['element']['earth'],
     ReagentData['element']['water'],
     ReagentData['element']['fire'],
     ReagentData['element']['air'],
     ReagentData['element']['globeofwater'],
     ReagentData['element']['heartoffire'],
     ReagentData['element']['heartofthewild'],
     ReagentData['element']['essenceofearth'],
     ReagentData['element']['essenceofwater'],
     ReagentData['element']['essenceoffire'],
     ReagentData['element']['essenceofair'],
     ReagentData['element']['essenceofundeath'],
     ReagentData['element']['livingessence'],
     ReagentData['shard']['largebrilliant'],
     ReagentData['armor']['ironbuckle'],
});

-------------------
-- Gather Skills --
-------------------

-- Reagent Data: Fishing
ReagentData['fishing'] = ReagentData_Flatten({
     ReagentData['alchemyfish'],
     ReagentData['cookingfish'],
});

-- Reagent Data: Herbalism
ReagentData['herbalism'] = ReagentData['herb'];

-- Reagent Data: Mining
ReagentData['mining'] = ReagentData_Flatten({
     ReagentData['ore'],
     ReagentData['stone'],
     ReagentData['gem'],
});

-- Reagent Data: Skinning
ReagentData['skinning'] = ReagentData_Flatten({
     ReagentData['leather'],
     ReagentData['scale'],
     ReagentData['hide']['light'],
     ReagentData['hide']['medium'],
     ReagentData['hide']['heavy'],
     ReagentData['hide']['thick'],
     ReagentData['hide']['rugged'],
     ReagentData['hide']['raptor'],
     ReagentData['hide']['shadowcat'],
     ReagentData['hide']['thickwolf'],
});

-----------------------
-- Other Item Groups --
-----------------------

-- Reagent Data: Rogue Poison Reagents
ReagentData['poisonreagent'] = ReagentData_Flatten({
     ReagentData['vial'],
     ReagentData['poisoningredient'],
     ReagentData['herb']['fadeleaf'],
});

-- Reagent Data: Vendor Item Groups
ReagentData['vendor'] = ReagentData_Flatten({
     ReagentData['drink'],
     ReagentData['dye'],
     ReagentData['flux'],
     ReagentData['food'],
     ReagentData['poisoningredient'],
     ReagentData['salt'],
     ReagentData['spice'],
     ReagentData['thread'],
     ReagentData['vendorother'],
     ReagentData['vial'],
     ReagentData['wood'],
     ReagentData['part']['heavystock'],
     ReagentData['part']['blankparchment'],
     ReagentData['part']['engineersink'],
});

-- Reagent Data: Monster Drops
ReagentData['monsterdrops'] = ReagentData_Flatten({
     ReagentData['monster'],
     ReagentData['feather'],
     ReagentData['spidersilk'],
     ReagentData['pearl'],
     ReagentData['scale']['deviate'],
});

-------------------
-- Helper Tables --
-------------------

---------------
-- Functions --
---------------

------------------------
-- EXTERNAL FUNCTIONS --
------------------------

-- ReagentData_ClassSpellReagent(item)
--
-- This function takes an item name (such as "Fish Oil") and returns
-- an array of classes that use the reagent {"Shaman"}.  It returns the
-- translated text version of the name.

function ReagentData_ClassSpellReagent(item)
     if (item == nil or ReagentData['spellreagents'] == nil) then
	  return;
     end
     
     local returnArray = {};

     for class, subtable in ReagentData['spellreagents'] do
	  for key, value in subtable do
	       if (value == item) then
		    tinsert(returnArray, class);
	       end
	  end
     end

     return returnArray;
end

-- ReagentData_GatheredBy(item)
--
-- This function takes an item name (such as "Light Leather") and returns
-- an array of gather skills that are used to gather the item.  For example, 
-- calling ReagentData_GatheredBy("Light Leather") on an English client
-- will return {"Skinning"}.  Results are not sorted, so be sure to run them 
-- through table.sort if you want them in alphabetical order.
--
-- I can't think of any items that are gathered by more than one skill, but 
-- this way the function behaves the same as other API calls and is flexible 
-- in case we  can one day skin herbs or something.

function ReagentData_GatheredBy(item)
     if (item == nil) then
	  return;
     end

     local returnArray = {};

     for profession in ReagentData['gathering'] do
	  if (ReagentData[profession] ~= nil) then
	       for key, value in ReagentData[profession] do
		    if (value == item) then 
			 tinsert(returnArray, ReagentData['gathering'][profession]);
			 break;
		    end
	       end
	  end
     end

     return returnArray;	  
end

-- ReagentData_GetItemClass(class)
--
-- Returns the data array for the requested item class.  This is the 
-- Reagent Data name for the item, NOT the translated name.  This means
-- you'll need to run it through ReagentData['reverseprofessions'] or
-- ReagentData['reversegatherskills'] first.  This function does NOT
-- flatten the returned function either, so keep that in mind when loading
-- professions; it doesn't apply to base classes such as ReagentData['bar'].
--
-- Most authors will simply want to access the ReagentData tables directly
-- instead of using this function, but it's provided anyway.

function ReagentData_GetItemClass(class)
     if (class == nil or ReagentData[class] == nil) then
	  return;
     end

     return ReagentData[class];
end

-- ReagentData_GetProfessions(item)
--
-- Returns a table that contains a translated list of all professions
-- that use the specified item.  For example, calling
-- ReagentData_GetProfessions("Light Leather") on an English client
-- will return {"Blacksmithing", "Engineering", "Leatherworking", "Tailoring"}.
-- Results are not sorted, so be sure to run them through table.sort if you
-- want them in alphabetical order.

function ReagentData_GetProfessions(item)
     if (item == nil) then
	  return;
     end

     local returnArray = {};

     for profession in ReagentData['professions'] do
	  if (ReagentData[profession] ~= nil) then
	       for key, value in ReagentData[profession] do
		    if (value == item) then 
			 tinsert(returnArray, ReagentData['professions'][profession]);
			 break;
		    end
	       end
	  end
     end

     return returnArray;
end

-- ReagentData_GetSpellReagents(class)
--
-- Returns a table that contains all spell reagents used by the specified
-- class.  For example, calling ReagentData_GetSpellReagents("shaman"}
-- will return {"Ankh", "Fish Oil", "Shiny Fish Scales"}.  If class
-- is omitted or specified as "all", all classes and spell reagents will
-- be returned in a multi-dimensional array.

function ReagentData_GetSpellReagents(class)
     if (class == nil) then
	  class = "all";
     end

     if (class == "all") then
	  return ReagentData['spellreagents'];
     end

     for key, value in ReagentData['spellreagents'] do
	  if (key == class) then
	       return value;
	  end
     end

     return nil;
end

-- ReagentData_IsMonsterDrop(item)
--
-- A Boolean function that indicates if the specified item is primarily 
-- obtained from monster drops.  Item is expected to be a localized string 
-- such as "Tiger Meat".

function ReagentData_IsMonsterDrop(item)
     if (item == nil or ReagentData['monsterdrops'] == nil) then
	  return false;
     end

     for key, value in ReagentData['monsterdrops'] do
	  if (value == item) then
	       return true;
	  end
     end

     return false;     
end

-- ReagentData_IsUsedByProfession(item, profession)
--
-- A Boolean function that indicates if the specified profession
-- uses the specified item.  Both profession and item are expected
-- to be the localized text version of the name (such as
-- "Copper Bar" and "Blacksmithing").

function ReagentData_IsUsedByProfession(item, profession)
     -- If we have nil arguments, just return false.
     if (item == nil or profession == nil) then
	  return false;
     end

     -- Now make sure we were passed a valid profession
     if (ReagentData['reverseprofessions'] == nil or ReagentData['reverseprofessions'][profession] == nil) then
	  return false;
     end

     -- Check to see if the requested item is in the array.  If so, return true.
     for key, value in ReagentData[ReagentData['reverseprofessions'][profession]] do
	  if (value == item) then
	       return true;
	  end
     end

     -- If we've gotten here, it's not in the requested profession, so return false.
     return false;
end

-- ReagentData_IsVendorItem(item)
--
-- A Boolean function that indicates if the specified item is primarily
-- obtained from vendors.  Item is expected to be a localized string such as "Heavy Stock".

function ReagentData_IsVendorItem(item)
     if (item == nil or ReagentData['vendor'] == nil) then
	  return false;
     end

     for key, value in ReagentData['vendor'] do
	  if (value == item) then
	       return true;
	  end
     end

     return false;
end

------------------------
-- INTERNAL FUNCTIONS --
------------------------

-- Not only do you not need to touch these function, but they're localized
-- to Reagent Data to prevent any confusion.  :-)

-- ReagentData_CreateReverseProfessions()
--
-- Creates the ReagentData['reverseprofessions'] array.

local function ReagentData_CreateReverseProfessions()
     if (ReagentData['professions'] == nil) then
	  return;
     end

     local returnArray = {};

     for key, profession in ReagentData['professions'] do
	  returnArray[profession] = key;
     end

     return returnArray;
end

-- ReagentData_CreateReverseGatherSkills()
--
-- Creates the ReagentData['reversegathering'] array.

local function ReagentData_CreateReverseGatherSkills()
     if (ReagentData['gathering'] == nil) then
	  return;
     end

     local returnArray = {};

     for key, profession in ReagentData['gathering'] do
	  returnArray[profession] = key;
     end

     return returnArray;
end

---------------------
-- Execution Block --
---------------------

-- ReagentData['reverseprofessions'] 
--
-- This array allows you to translated the localized text version of a profession
-- into the index used by Reagent Data.  This is useful if your addon has the localized
-- version ("Blacksmithing") and would like to access the associated data array.  You 
-- could do this via ReagentData[ReagentData['reverseprofessions']["Blacksmithing"]].

ReagentData['reverseprofessions'] = ReagentData_CreateReverseProfessions();

-- ReagentData['reversegathering'] 
--
-- This array allows you to translated the localized text version of a gather skill
-- into the index used by Reagent Data.  This is useful if your addon has the localized
-- version ("Mining") and would like to access the associated data array.  You 
-- could do this via ReagentData[ReagentData['reversegathering']["Mining"]].

ReagentData['reversegathering'] = ReagentData_CreateReverseGatherSkills();