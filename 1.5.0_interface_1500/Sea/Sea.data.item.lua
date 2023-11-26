--[[
--
--	Sea.data.item
--
--	Various item lists for use by WoW mods
--
--]]

Sea.data.item = {

	-- 
	-- Herbs
	-- 
	-- Thanks to Zatharas, Narands, Xdra, Mirodin and Reima for this list
	herb = {
		"Peacebloom", 
		"Silverleaf", 
		"Earthroot",
		"Snakeroot", 
		"Mageroyal", 
		"Briarthorn", 
		"Swiftthistle",
		"Stranglekelp",
		"Bruiseweed", 
		"Wild Steelbloom",
		"Grave Moss", 
		"Kingsblood",
		"Liferoot",
		"Fadeleaf", 
		"Khadgar's Whiskers",
		"Wintersbite",
		"Firebloom",
		"Purple Lotus",
		"Sungrass",
		"Blindweed",
		"Ghost Mushroom",
		"Gromsblood",
		"Goldthorn"	
	};

	--
	-- A list of the ores in Wow
	--	
	ore = {
		"Copper Ore",
		"Tin Ore",
		"Silver Ore",
		"Iron Ore",
		"Gold Ore",
		"Steel Ore",
		"Mithril Ore",
		"Truesilver Ore",
		"Thorium Ore"
	};


	--
	-- A very incomplete gem list
	--
	gem = {
		"Malachite",
		"Moss Agate",
		"Tigerseye", 
		"Citrine",
		"Jade",
		"Shadowgem",
		"Aquamarine",
		"Blue Pearl",
		"Black Pearl",
		"Gold Pearl",
		"Star Ruby"
	};

	--
	-- A simple list for potion name checks
	--
	potion = {
		"Potion",
		"Elixir",
		"Oil",	
		"Holy Spring Water"
	};

	--
	-- Cloths 
	--
	cloth =  {
		"Cloth",
		"Wool",
		"Silk",
		"Mageweave",
		"Runecloth",
		"Felcloth",
		"Mooncloth"
	};

	--
	-- Leather
	--
	
	leather = {
		"Ruined Leather Scraps",
		"Light Leather",
		"Light Hide",
		"Deviate Scale",
		"Black Whelp Scale",
		"Perfect Deviate Scale",
		"Red Whelp Scale",
		"Medium Leather",
		"Medium Hide",
		"Green Whelp Scale",
		"Heavy Leather",
		"Heavy Hide",
		"Scorpid Scale",
		"Shadowcat Hide", 
		"Thick Yeti Hide",
		"Thick Leather",
		"Thick Hide",
		"Thick Wolfhide",
		"Black Dragonscale",
		"Warbear Leather",
		"Heavy Scorpid Scale",
		"Rugged Leather",
		"Rugged Hide",
		"Turtle Scale",
		"Dragonscale",
		"Worn Dragonscale",
		"Blue Dragonscale",
		"Chimera Leather",
		"FrostSaber Leather",
		"Blue Dragonscale"
	};

	--[[ Tradeskills  ]]--
	--
	-- Leatherworking only items
	--
	leatherworking = {
		"Cured Light Hide",
		"Cured Medium Hide",
		"Cured Heavy Hide",
		"Cured Thick Hide",
		"Cured Rugged Hide"
	};	
	-- leatherworking is joined with Sea.data.item.leather to create a complete list.

	--
	-- Fishing Tools
	--
	fishing =  {
		"Bauble",
		"Nightcrawler",
		"Fishing Pole",
		"Fish Attractor"
	};

	--[[ Class Items ]] --

	--
	-- Warlock Items
	-- 
	warlock = {
		"Soul Shard",
		"Healthstone",
		"Spellstone",
		"Soulstone"
	};

	--
	-- Shaman Items
	-- 
	shaman = {
		"Earth Totem",
		"Fire Totem",
		"Water Totem",
		"Air Totem",
		"Sapta"		
	};


	--
	-- Mage Items
	-- 
	mage = {
		"Mana Agate",
		"Mana Jade",
		"Mana Citrine",
		"Mana Ruby"	
	};


	--[[ Consumable ]]--
	

	--
	-- Food
	--
	food =  {
		"Bread",
		"Cornbread",
		"Haunch",
		"Mutton Chop",
		"Hog Shank",
		"Tough Jerky",
		"Stormwind Brie",
		"Aged Cheddar",
		"Alterac Swiss",
		"Apple",
		"Watermelon",
		"Banana",
		"Ham Steak",
		"Dalaran Sharp",
		"Bleu", 
		"Dwarven Mild", 
		"Charred Wolf Meat", 
		"Spiced Wolf Meat", 
		"Roasted Boar Meat",
		"Mackerel", 
		"Smallfish",
		"Kaldorei Caviar",
		"Scorpid Surprise",
		"Beer Basted",
		"Smoked Bear Meat",
		"Roasted Kodo Meat",
		"Mud Snapper",
		"Rainbow Fin Albacore",
		"Halibut",
		"Strider Stew",
		"Fillet of Frenzy",
		"Boiled Clams",
		"Goretusk Liver Pie",
		"Loch Frenzy Delights",
		"Coyote Steak",
		"Blood Sausage",
		"Westfall Stew",
		"Crab Cake",
		"Crispy Lizard",
		"Pork Ribs",
		"Croclist Steak",
		"Savory Deviate",
		"Scorpid Surprise",
		"Cooked Crab Claw",
		"Dig Rat Stew",
		"Murloc Fin Soup",
		"Clam Chowder",
		"Seasoned Wolf",
		"Spider Cake",
		"Bear Steak",
		"Venison",
		"Pork Ribs",
		"Gumbo",
		"Lion Chops",
		"Goblin Deviled",
		"Omelet",
		"Tasty Lion Steak",
		"Barbecued Buzzard",
		"Giant Clam Scorcho",
		"Soothing Turtle",
		"Rockscale Cod",
		"Cave Mold",
		"eckled Mushroom",
		"Mushroom Cap",
		"Bolete",
		"Morel",
		"Truffle",
		"Strider Stew",
		"Mystery Stew",
		"Roast Raptor",
		"Carrion Surprise",
		"Dragonbreath Chi",
		"Spiced Chi",
		"Monster Om",
		"Spiced Wolf",
		"Goldthorn Tea",
		"Squid",
		"Pumpkin",
		"Ice Cream",
		-- conjured stuff
		"Conjured Bread",
		"Conjured Muffin",
		"Conjured Pumpernickel",
		"Conjured Rye",
		"Conjured Sourdough",
		"Conjured Sweet Roll"
	};
	
	--
	-- Drink
	--
	drink = {
		"Refreshing Spring Water",		
		"Cherry Grog",
		"Moonberry Juice",
		"Cold Milk",
		"Melon Juice",
		"Sweet Nectar",
		"Spring Water",
		"Glory Dew",
		"Bubbling Water",
		-- conjured stuff
		"Conjured Fresh Water",
		"Conjured Mineral Water",
		"Conjured Purified Water",
		"Conjured Sparkling Water",
		"Conjured Spring Water",
		"Conjured Water"
	};

	--[[ Reagents ]]--

	reagent = {
	};
};

		--
		-- Alchemy Reagents
		--
		Sea.data.item.reagent.alchemy = {
			"Arcane Crystal",
			"Arthas' Tears",
			"Black Lotus",
			"Black Vitrol",
			"Blackmouth Oil",
			"Blindweed",
			"Briarthorn",
			"Bruiseweed",
			"Crystal Vial",
			"Delicate Feather",
			"Deviate Fish",
			"Discolored Worg Heart",
			"Dream Dust",
			"Dreamfoil",
			"Earthroot",
			"Elemental Air",
			"Elemental Earth",
			"Elemental Fire",
			"Elemental Water",
			"Empty Vial",
			"Essence of Air",
			"Essence of Earth",
			"Essence of Fire",
			"Essence of Undeath",
			"Essence of Water",
			"Fadeleaf",
			"Fire Oil",
			"Firebloom",
			"Firefin Snapper",
			"Ghost Mushroom",
			"Golden Sansam",
			"Goldthorn",
			"Grave Moss",
			"Gromsblood",
			"Icecap",
			"Iron Bar",
			"Khadgar's Whisker",
			"Kingsblood",
			"Large Fang",
			"Large Venom Sac",
			"Leaded Vial",
			"Liferoot",
			"Living Essence",
			"Mageroyal",
			"Minor Healing Potion",
			"Mithril Bar",
			"Mountain Silversage",
			"Oily Blackmouth",
			"Peacebloom",
			"Plaguebloom",
			"Purple Dye",
			"Purple Lotus",
			"Shadow Oil",
			"Sharp Claw",
			"Silverleaf",
			"Small Flame Sac",
			"Stonescale Eel",
			"Stonescale Oil",
			"Stranglekelp",
			"Sungrass",
			"Swiftthistle",
			"Thorium Bar",
			"Thorium Ore",
			"Volatile Rum",
			"Wild Steelbloom",
			"Wildvine",
			"Wintersbite"
		};

	--
	-- Blacksmithing Reagents
	--
	Sea.data.item.reagent.blacksmithing ={
		"Aquamarine",
		"Arcanite Bar",
		"Azerothian Diamond",
		"Black Pearl",
		"Blood of the Mountain",
		"Blue Power Crystal",
		"Blue Sapphire",
		"Breath of Wind",
		"Bronze Bar",
		"Citrine",
		"Coarse Grinding Stone",
		"Coarse Stone",
		"Copper Bar",
		"Core of Earth",
		"Dark Iron Bar",
		"Demonic Rune",
		"Dense Grinding Stone",
		"Dense Stone",
		"Elemental Air",
		"Elemental Earth",
		"Elemental Fire",
		"Elemental Water",
		"Elixir of Ogre's Strength",
		"Enchanted Leather",
		"Enchanted Thorium Bar",
		"Essence of Earth",
		"Essence of Fire",
		"Essence of Undeath",
		"Essence of Water",
		"Fine Thread",
		"Frost Oil",
		"Gold Bar",
		"Green Dye",
		"Green Leather Armor",
		"Green Power Crystal",
		"Guardian Gloves",
		"Guardian Stone",
		"Heart of Fire",
		"Heavy Grinding Stone",
		"Heavy Leather",
		"Heavy Stone",
		"Huge Emerald",
		"Ichor of Undeath",
		"Iridescent Pearl",
		"Iron Bar",
		"Jade",
		"Jet Black Feather",
		"Large Fang",
		"Large Opal",
		"Lesser Invisibility Potion",
		"Lesser Moonstone",
		"Light Leather",
		"Linen Cloth",
		"Living Essence",
		"Mageweave Cloth",
		"Malachite",
		"Medium Leather",
		"Mithril Bar",
		"Moss Agate",
		"Powerful Mojo",
		"Red Power Crystal",
		"Righteous Orb",
		"Rough Grinding Stone",
		"Rough Stone",
		"Rugged Leather",
		"Runecloth",
		"Shadow Oil",
		"Shadowgem",
		"Sharp Claw",
		"Silk Cloth",
		"Silver Bar",
		"Small Lustrous Pearl",
		"Solid Grinding Stone",
		"Solid Stone",
		"Star Ruby",
		"Steel Bar",
		"Strong Flux",
		"Swiftness Potion",
		"Thick Leather",
		"Thorium Bar",
		"Tigerseye",
		"Truesilver Bar",
		"Weak Flux",
		"Wicked Claw",
		"Wildvine",
		"Wool Cloth",
		"Yellow Power Crystal"
		 };

--
-- Enchanting Reagents
--
Sea.data.item.reagent.enchanting ={
 	"Aquamarine",
	"Arcanite Rod",
	"Black Pearl",
	"Blackmouth Oil",
	"Blood of the Mountain",
	"Breath of Wind",
	"Copper Rod",
	"Core of Earth",
	"Dream Dust",
	"Elemental Earth",
	"Elemental Fire",
	"Elixir of Demonslaying",
	"Essence of Air",
	"Essence of Fire",
	"Essence of Undeath",
	"Essence of Water",
	"Fire Oil",
	"Frost Oil",
	"Globe of Water",
	"Golden Pearl",
	"Golden Rod",
	"Greater Astral Essence",
	"Greater Eternal Essence",
	"Greater Magic Essence",
	"Greater Mystic Essence",
	"Greater Nether Essence",
	"Green Whelp Scale",
	"Heart of Fire",
	"Icecap",
	"Ichor of Undeath",
	"Illusion Dust",
	"Iridescent Pearl",
	"Iron Ore",
	"Kingsblood",
	"Large Brilliant Shard",
	"Large Fang",
	"Large Glimmering Shard",
	"Large Glowing Shard",
	"Large Radiant Shard",
	"Lesser Astral Essence",
	"Lesser Eternal Essence",
	"Lesser Magic Essence",
	"Lesser Mystic Essence",
	"Lesser Nether Essence",
	"Living Essence",
	"Righteous Orb",
	"Rugged Leather",
	"Shadow Protection Potion",
	"Shadowgem",
	"Silver Rod",
	"Simple Wood",
	"Simple Wood",
	"Small Brilliant Shard",
	"Small Glimmering Shard",
	"Small Glowing Shard",
	"Small Radiant Shard",
	"Soul Dust",
	"Star Wood",
	"Strange Dust",
	"Sungrass",
	"Thorium Bar",
	"Truesilver Bar",
	"Truesilver Rod",
	"Vision Dust",
	"Wildvine",
	"Wintersbite"
 };
 --
 -- Engineering Reagents
 --
Sea.data.item.reagent.engineering = {
	"Accurate Scope",
	"Aquamarine",
	"Arcanite Bar",
	"Azerothian Diamond",
	"Big Iron Bomb",
	"Black Mageweave Boots",
	"Blank Parchment",
	"Blue Pearl",
	"Blue Sapphire",
	"Bolt of Mageweave",
	"Bronze Bar",
	"Bronze Framework",
	"Bronze Tube",
	"Catseye Elixir",
	"Citrine",
	"Coarse Blasting Powder",
	"Coarse Stone",
	"Copper Bar",
	"Copper Modulator",
	"Copper Tube",
	"Core of Earth",
	"Dark Iron Bar",
	"Deadly Scope",
	"Dense Blasting Powder",
	"Dense Stone",
	"Dusky Belt",
	"Elemental Earth",
	"Elemental Fire",
	"Enchanted Leather",
	"Enchanted Thorium Bar",
	"Engineer's Ink",
	"Essence of Earth",
	"Essence of Fire",
	"Essence of Undeath",
	"Fire Goggles",
	"Flask of Mojo",
	"Flask of Oil",
	"Flying Tiger Goggles",
	"Frost Oil",
	"Fused Wiring",
	"Goblin Construction Helmet",
	"Goblin Rocket Fuel",
	"Gold Bar",
	"Gold Power Core",
	"Green Tinted Goggles",
	"Gyrochronatom",
	"Handful of Copper Bolts",
	"Heart of Fire",
	"Heart of the Wild",
	"Heavy Blasting Powder",
	"Heavy Leather",
	"Heavy Stock",
	"Heavy Stone",
	"Huge Emerald",
	"Ichor of Undeath",
	"Inlaid Mithril Cylinder",
	"Iron Bar",
	"Iron Strut",
	"Ironweb Spider Silk",
	"Jade",
	"Large Opal",
	"Leather Dusky Belt",
	"Lesser Moonstone",
	"Light Leather",
	"Linen Cloth",
	"Living Essence",
	"Mageweave Cloth",
	"Malachite",
	"Medium Leather",
	"Minor Soulstone",
	"Mithril Bar",
	"Mithril Casing",
	"Mithril Mechanical Dragonling",
	"Mithril Tube",
	"Moss Agate",
	"Nightcrawlers",
	"Razor Arrow",
	"Refreshing Spring Water",
	"Rough Blasting Powder",
	"Rough Stone",
	"Rugged Leather",
	"Runecloth",
	"Shadow Silk",
	"Shadowgem",
	"Silk Cloth",
	"Silver Bar",
	"Silver Bar",
	"Silver Contact",
	"Small Flame Sac",
	"Snowball",
	"Solid Blasting Powder",
	"Solid Dynamite",
	"Solid Stone",
	"Spellpower Goggles Xtreme",
	"Star Ruby",
	"Steel Bar",
	"Thick Leather",
	"Thick Spider's Silk",
	"Thorium Bar",
	"Thorium Tube",
	"Thorium Widget",
	"Tigerseye",
	"Truesilver Bar",
	"Unstable Trigger",
	"Weak Flux",
	"Whirring Bronze Gizmo",
	"Wildvine",
	"Wooden Stock",
	"Wool Cloth",
};

--
-- Leatherworking Reagents
--
Sea.data.item.reagent.leatherworking = {
	"Black Dragonscale",
	"Black Dye",
	"Black Pearl",
	"Black Whelp Scale",
	"Bleach",
	"Blue Dragonscale",
	"Bolt of Silk Cloth",
	"Bolt of Woolen Cloth",
	"Chimera Leather",
	"Citrine",
	"Coarse Gorilla Hair",
	"Coarse Thread",
	"Core of Earth",
	"Cured Heavy Hide",
	"Cured Light Hide",
	"Cured Medium Hide",
	"Cured Rugged Hide",
	"Cured Thick Hide",
	"Deeprock Salt",
	"Deviate Scale",
	"Devilsaur Leather",
	"Elemental Earth",
	"Elemental Water",
	"Elixir of Agility",
	"Elixir of Defense",
	"Elixir of Greater Defense",
	"Elixir of Lesser Agility",
	"Elixir of Minor Agility",
	"Elixir of Wisdom",
	"Enchanted Leather",
	"Essence of Air",
	"Essence of Earth",
	"Essence of Fire",
	"Essence of Water",
	"Fine Thread",
	"Felcloth",
	"Fine Leather Belt",
	"Fine Leather Gloves",
	"Fine Leather Tunic",
	"Fine Thread",
	"Flask of Big Mojo",
	"Flask of Mojo",
	"Frostsaber Leather",
	"Globe of Water",
	"Gray Dye",
	"Great Rage Potion",
	"Green Dragonscale",
	"Green Dye",
	"Green Whelp Scale",
	"Heart of Fire",
	"Heavy Hide",
	"Heavy Leather",
	"Heavy Scorpid Scale",
	"Heavy Silken Thread",
	"Iridescent Pearl",
	"Iron Buckle",
	"Ironfeather",
	"Jade",
	"Jet Black Feather",
	"Kingsblood",
	"Large Fang",
	"Light Hide",
	"Light Leather",
	"Living Essence",
	"Long Tail Feather",
	"Lucky Charm",
	"Mageweave Cloth",
	"Medium Hide",
	"Medium Leather",
	"Mooncloth",
	"Moss Agate",
	"Perfect Deviate Scale",
	"Raptor Hide",
	"Red Dragonscale",
	"Red Whelp Scale",
	"Refined Deeprock Salt",
	"Rugged Hide",
	"Rugged Leather",
	"Ruined Leather Scraps",
	"Rune Thread",
	"Runecloth",
	"Salt",
	"Scorpid Scale",
	"Shadow Oil",
	"Shadowcat Hide",
	"Silken Thread",
	"Slimy Murloc Scale",
	"Small Lustrous Pearl",
	"Spider's Silk",
	"Swiftness Potion",
	"Thick Hide",
	"Thick Leather",
	"Thick Murloc Scale",
	"Thick Spider's Silk",
	"Thick Wolfhide",
	"Thin Kodo Leather",
	"Turtle Scale",
	"Warbear Leather",
	"Wicked Claw",
	"Wildvine",
	"Worn Dragonscale",
};
 
--
-- Mining Reagents
--
--   OK, guys, you better decide - are Bars parts of Mining or not?
--
Sea.data.item.reagent.mining = {
	"Coal",
	"Copper Ore",
	"Dark Iron Ore",
	"Gold Ore",
	"Iron Ore",
	"Mithril Ore",
	"Silver Ore",
	"Thorium Ore",
	"Tin Ore",
	"Truesilver Ore"
};

-- First Aid Reagents
--
Sea.data.item.reagent.firstaid = {
	"Large Venom Sac",
	"Linen Cloth",
	"Mageweave Cloth",
	"Runecloth",
	"Silk Cloth",
	"Small Venom Sac",
	"Wool Cloth"
};
--
-- Cooking Reagents
--
Sea.data.item.reagent.cooking ={
	"Bear Meat",
	"Big Bear Meat",
	"Boar Intestines",
	"Boar Ribs",
	"Buzzard Wing",
	"Chunk of Boar Meat",
	"Clam Meat",
	"Coyote Meat",
	"Crag Boar Rib",
	"Crawler Claw",
	"Crawler Meat",
	"Crisp Spider Meat",
	"Crocolisk Meat",
	"Darkclaw Lobster",
	"Deviate Fish",
	"Dig Rat",
	"Giant Clam Meat",
	"Giant Egg",
	"Goldthorn",
	"Gooey Spider Leg",
	"Goretusk Liver",
	"Goretusk Snout",
	"Heavy Kodo Meat",
	"Holiday Spices",
	"Holiday Spirits",
	"Hot Spices",
	"Ice Cold Milk",
	"Kodo Meat",
	"Large Raw Mightfish",
	"Lean Wolf Flank",
	"Lion Meat",
	"Meaty Bat Wing",
	"Mild Spices",
	"Murloc Eye",
	"Murloc Fin",
	"Mystery Meat",
	"Raptor Egg",
	"Raptor Flesh",
	"Raw Brilliant Smallfish",
	"Raw Bristle Whisker Catfish",
	"Raw Glossy Mightfish",
	"Raw Loch Frenzy",
	"Raw Longjaw Mud Snapper",
	"Raw Mithril Head Trout",
	"Raw Nightfin Snapper",
	"Raw Rainbow Fin Albacore",
	"Raw Redgill",
	"Raw Rockscale Cod",
	"Raw Slitherskin Mackerel",
	"Raw Spotted Yellowtail",
	"Raw Summer Bass",
	"Raw Sunscale Salmon",
	"Raw Whitescale Salmon",
	"Red Wolf Meat",
	"Refreshing Spring Water",
	"Rhapsody Malt",
	"Scorpid Stinger",
	"Shiny Red Apple",
	"Skin of Dwarven Stout",
	"Small Egg",
	"Small Flame Sac",
	"Small Spider Leg",
	"Soft Frenzy Flesh",
	"Soothing Spices",
	"Spider Ichor",
	"Stag Meat",
	"Stormwind Seasoning Herbs",
	"Strider Meat",
	"Stringy Vulture Meat",
	"Stringy Wolf Meat",
	"Swiftthistle",
	"Tangy Clam Meat",
	"Tender Crab Meat",
	"Tender Crocolisk Meat",
	"Thunder Lizard Tail",
	"Tiger Meat",
	"Tough Condor Meat",
	"Turtle Meat",
	"White Spider Meat",
	"Winter Squid",
	"Zesty Clam Meat"
};

 
Sea.data.item.reagent.reagent = {
	  "Flash Powder",
	  "Dust of Deterioration", 
	  "Essence of Agony",
	  "Deathweed",
	  "Dust of Decay",
	  "Essence of Pain",
	  "Lethargy Root",
	  "Blinding Powder"
	  };

--- 
--- Poison Reagents
---
Sea.data.item.reagent.poison = {
	"Crystal Vial",
	"Deathweed",
	"Dust of Decay",
	"Dust of Deterioration",
	"Empty Vial",
	"Fadeleaf",
	"Empty Vial",
	"Essence of Agony",
	"Essence of Pain",
	"Leaded Vial"
	};

--- 
--- Poisons
---
Sea.data.item.poison = {
	  "Instant Poison",
	  "Crippling Poison",
	  "Mind-numbing Poison",
	  "Wound Poison",
	  "Deadly Poison",
	  };


--
-- Tailoring Reagents
--
Sea.data.item.reagent.tailoring ={
	"Azerothian Diamond",
	"Black Dye",
	"Black Pearl",
	"Bleach",
	"Blue Dye",
	"Bolt of Linen Cloth",
	"Bolt of Mageweave",
	"Bolt of Runecloth",
	"Bolt of Silk Cloth",
	"Bolt of Woolen Cloth",
	"Citrine",
	"Coarse Thread",
	"Demonic Rune",
	"Dream Dust",
	"Elemental Air",
	"Elemental Earth",
	"Elemental Fire",
	"Elemental Water",
	"Elixir of Wisdom",
	"Enchanted Leather",
	"Enchanted Thread",
	"Essence of Air",
	"Essence of Earth",
	"Essence of Fire",
	"Essence of Undeath",
	"Essence of Water",
	"Felcloth",
	"Fine Thread",
	"Fire Oil",
	"Frost Oil",
	"Ghost Dye",
	"Globe of Water",
	"Gold Bar",
	"Golden Pearl",
	"Gray Dye",
	"Green Dye",
	"Healing Potion",
	"Heart of Fire",
	"Heart of the Wild",
	"Heavy Leather",
	"Heavy Silken Thread",
	"Huge Emerald",
	"Iridescent Pearl",
	"Iron Buckle",
	"Ironweb Spider Silk",
	"Jade",
	"Large Brilliant Shard",
	"Lesser Moonstone",
	"Light Leather",
	"Linen Cloth",
	"Long Elegant Feather",
	"Mageweave Cloth",
	"Mana Potion",
	"Medium Leather",
	"Mooncloth",
	"Naga Scale",
	"Orange Dye",
	"Pink Dye",
	"Purple Dye",
	"Red Dye",
	"Righteous Orb",
	"Rugged Leather",
	"Rune Thread",
	"Runecloth",
	"Shadow Oil",
	"Shadow Protection Potion",
	"Shadow Silk",
	"Silk Cloth",
	"Silken Thread",
	"Small Lustrous Pearl",
	"Spider's Silk",
	"Star Ruby",
	"Thick Leather",
	"Thick Spider's Silk",
	"Truesilver Bar",
	"Wildvine",
	"Wool Cloth",
	"Yellow Dye",
};
	  
--[[ Class Reagents ]]--
Sea.data.item.reagent.paladin = {
	  "Symbol of Divinity",
	  };

Sea.data.item.reagent.mage = {
	"Light Feather",
	"Rune of Portals",
	"Rune of Teleportation"
	};
	  
Sea.data.item.reagent.priest = {
	"Light Feather",
	};

Sea.data.item.reagent.shaman = {
	"Shiny Fish Scales",
	"Fish Oil", 
	"Ankh",
	};

Sea.data.item.reagent.warlock = {
	"Inferal Stone",
	"Demonic Idol",
	"Soulshard"
	};

Sea.data.item.reagent.druid = {
	"Maple Seeds",
	"Stranglethorn Seed", 
	"Ashwood Seed",
	"Hornbeam Seed",
	"Ironwood Seed",
	"Wild Berries"
	};
	  
