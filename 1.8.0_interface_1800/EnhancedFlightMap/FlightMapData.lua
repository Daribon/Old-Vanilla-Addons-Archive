--[[

This file contains all the flightpaths I have discovered in game.  This list is nowhere near complete, but it is a good start for most things.

If any paths are missing, please send me just the relevant snippet from your savedvariables.lua file.

Special Thanks go to:
Bam at Curse-gaming for supplying the Alliance flight data for the continent of Azeroth.
jgleigh at Curse-gaming for supplying the 1.8 patch alliance data for enUS.

Corwing Whitehorn at Curse-Gaming for supplying the initial data load for the french data.
]]

EFMDATA_CLEAR_ON_LOAD = false;

-- Blank Un-localised data.
Default_EFM_Data_Horde = {
	["HordeVersion"] = 0,
	["Horde"] = {
		[1] = {},
		[2] = {},
	},
}

-- Alliance Data - contains user-submitted data.
Default_EFM_Data_Alliance = {
	["AllianceVersion"] = 0,
	["Alliance"] = {
		[1] = {},
		[2] = {},
	},
}

-- These are the only two flight paths, so this should never need to be changed.
Default_EFM_Data_Druid = {
	["DruidVersion"] = 0,
	["Alliance"] = {
		[1] = {},
	},
	["Horde"] = {
		[1] = {},
	},
}

-- Map Translation Data - Horde
Default_EFM_Data_HordeMapTranslation = {
	["HordeMapTranslationVersion"] = 0,
	["Horde"] = {
		[1] = {},
		[2] = {},
	},
}

-- Map Translation Data - Alliance
Default_EFM_Data_AllianceMapTranslation = {
	["AllianceMapTranslationVersion"] = 0,
	["Alliance"] = {
		[1] = {},
		[2] = {},
	},
}

-- Flight Path Data - Horde
Default_EFM_Data_HordeFlightPath = {
	["HordeFlightPathVersion"] = 0,
	["Horde"] = {
		[1] = {},
		[2] = {},
	},
}

-- Flight Path Data - Alliance
Default_EFM_Data_AllianceFlightPath= {
	["AllianceFlightPathVersion"] = 0,
	["Alliance"] = {
		[1] = {},
		[2] = {},
	},
}

------------------------------

if ( GetLocale() == "enUS" ) then
-- Set to true to have the old data cleared when loading the new data in.
EFMDATA_CLEAR_ON_LOAD = true;

-- Horde Data - Now updated to 1.6 flight paths..
Default_EFM_Data_Horde = {
	["HordeVersion"] = 2.1,
	["Horde"] = {
		[1] = {
			["Brackenwall Village, Dustwallow Marsh"] = {
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Gadgetzan, Tanaris",
					[3] = "Orgrimmar, Durotar",
					[4] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.567468,
				["y"] = 0.358365,
				["mapy"] = 31.81,
				["mapx"] = 35.57,
			},
			["Cenarion Hold, Silithus"] = {
				["routes"] = {
					[1] = "Gadgetzan, Tanaris",
				},
				["x"] = 0.4163212776184082,
				["mapx"] = 48.73,
				["mapy"] = 36.6,
				["y"] = 0.2078311294317246,
			},
			["Moonglade"] = {
				["routes"] = {
					[1] = "Bloodvenom Post, Felwood",
					[2] = "Everlook, Winterspring",
				},
				["x"] = 0.537937,
				["y"] = 0.794593,
				["mapx"] = 32.15,
				["mapy"] = 66.33,
			},
			["Zoram'gar Outpost, Ashenvale"] = {
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Splintertree Post, Ashenvale",
				},
				["x"] = 0.409738,
				["mapx"] = 12.18,
				["mapy"] = 33.84,
				["y"] = 0.626323,
			},
			["Freewind Post, Thousand Needles"] = {
				["y"] = 0.265501,
				["x"] = 0.549889,
				["routes"] = {
					[1] = "Camp Taurajo, The Barrens",
					[2] = "Crossroads, The Barrens",
					[3] = "Gadgetzan, Tanaris",
					[4] = "Thunder Bluff, Mulgore",
				},
				["mapy"] = 49.21,
				["mapx"] = 45.12,
			},
			["Crossroads, The Barrens"] = {
				["y"] = 0.469523,
				["x"] = 0.557357,
				["routes"] = {
					[1] = "Bloodvenom Post, Felwood",
					[2] = "Brackenwall Village, Dustwallow Marsh",
					[3] = "Camp Mojache, Feralas",
					[4] = "Camp Taurajo, The Barrens",
					[5] = "Freewind Post, Thousand Needles",
					[6] = "Gadgetzan, Tanaris",
					[7] = "Orgrimmar, Durotar",
					[8] = "Splintertree Post, Ashenvale",
					[9] = "Sun Rock Retreat, Stonetalon Mountains",
					[10] = "Thunder Bluff, Mulgore",
					[11] = "Valormok, Azshara",
					[12] = "Zoram'gar Outpost, Ashenvale",
				},
				["mapy"] = 30.39,
				["mapx"] = 51.52,
			},
			["Camp Taurajo, The Barrens"] = {
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Freewind Post, Thousand Needles",
					[3] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.528047,
				["y"] = 0.389866,
				["mapy"] = 59.1,
				["mapx"] = 44.46,
			},
			["Everlook, Winterspring"] = {
				["routes"] = {
					[1] = "Bloodvenom Post, Felwood",
					[2] = "Moonglade",
					[3] = "Orgrimmar, Durotar",
				},
				["x"] = 0.640145,
				["mapx"] = 60.48,
				["mapy"] = 36.33,
				["y"] = 0.767587,
			},
			["Thunder Bluff, Mulgore"] = {
				["y"] = 0.438488,
				["x"] = 0.449478,
				["routes"] = {
					[1] = "Brackenwall Village, Dustwallow Marsh",
					[2] = "Camp Mojache, Feralas",
					[3] = "Camp Taurajo, The Barrens",
					[4] = "Crossroads, The Barrens",
					[5] = "Freewind Post, Thousand Needles",
					[6] = "Gadgetzan, Tanaris",
					[7] = "Orgrimmar, Durotar",
					[8] = "Shadowprey Village, Desolace",
					[9] = "Sun Rock Retreat, Stonetalon Mountains",
					[10] = "Valormok, Azshara",
				},
				["mapy"] = 50.41,
				["mapx"] = 46.74,
			},
			["Sun Rock Retreat, Stonetalon Mountains"] = {
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Shadowprey Village, Desolace",
					[3] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.407957,
				["mapx"] = 45.19,
				["mapy"] = 59.88,
				["y"] = 0.527386,
			},
			["Valor's Rest, Silithus"] = {
				["routes"] = {
					[1] = "Gadgetzan, Tanaris",
				},
				["x"] = 0.461045,
				["y"] = 0.226628,
				["mapy"] = 11.98,
				["mapx"] = 70.41,
			},
			["Camp Mojache, Feralas"] = {
				["y"] = 0.306086,
				["x"] = 0.44251,
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Gadgetzan, Tanaris",
					[3] = "Shadowprey Village, Desolace",
					[4] = "Thunder Bluff, Mulgore",
				},
				["mapy"] = 44.31,
				["mapx"] = 75.43,
			},
			["Gadgetzan, Tanaris"] = {
				["routes"] = {
					[1] = "Brackenwall Village, Dustwallow Marsh",
					[2] = "Camp Mojache, Feralas",
					[3] = "Crossroads, The Barrens",
					[4] = "Freewind Post, Thousand Needles",
					[5] = "Orgrimmar, Durotar",
					[6] = "Thunder Bluff, Mulgore",
					[7] = "Cenarion Hold, Silithus",
				},
				["x"] = 0.606013,
				["y"] = 0.198074,
				["mapy"] = 25.49,
				["mapx"] = 51.62,
			},
			["Shadowprey Village, Desolace"] = {
				["y"] = 0.415052,
				["x"] = 0.316603,
				["mapx"] = 21.62,
				["mapy"] = 74.01,
				["routes"] = {
					[1] = "Camp Mojache, Feralas",
					[2] = "Sun Rock Retreat, Stonetalon Mountains",
					[3] = "Thunder Bluff, Mulgore",
				},
			},
			["Bloodvenom Post, Felwood"] = {
				["y"] = 0.695908,
				["x"] = 0.464553,
				["mapx"] = 34.43,
				["mapy"] = 53.9,
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Everlook, Winterspring",
					[3] = "Moonglade",
					[4] = "Orgrimmar, Durotar",
					[5] = "Valormok, Azshara",
				},
			},
			["Orgrimmar, Durotar"] = {
				["routes"] = {
					[1] = "Bloodvenom Post, Felwood",
					[2] = "Brackenwall Village, Dustwallow Marsh",
					[3] = "Crossroads, The Barrens",
					[4] = "Everlook, Winterspring",
					[5] = "Gadgetzan, Tanaris",
					[6] = "Splintertree Post, Ashenvale",
					[7] = "Thunder Bluff, Mulgore",
					[8] = "Valormok, Azshara",
				},
				["x"] = 0.628008,
				["y"] = 0.556598,
				["mapy"] = 63.98,
				["mapx"] = 45.25,
			},
			["Splintertree Post, Ashenvale"] = {
				["y"] = 0.582267,
				["x"] = 0.554419,
				["mapx"] = 73.2,
				["mapy"] = 61.57,
				["routes"] = {
					[1] = "Crossroads, The Barrens",
					[2] = "Orgrimmar, Durotar",
					[3] = "Zoram'gar Outpost, Ashenvale",
				},
			},
			["Valormok, Azshara"] = {
				["routes"] = {
					[1] = "Bloodvenom Post, Felwood",
					[2] = "Crossroads, The Barrens",
					[3] = "Orgrimmar, Durotar",
					[4] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.631076,
				["mapx"] = 21.95,
				["mapy"] = 49.69,
				["y"] = 0.638107,
			},
		},
		[2] = {
			["Booty Bay, Stranglethorn"] = {
				["routes"] = {
					[1] = "Grom'gol, Stranglethorn",
					[2] = "Kargath, Badlands",
					[3] = "Stonard, Swamp of Sorrows",
				},
				["x"] = 0.431591,
				["mapx"] = 26.83,
				["mapy"] = 77.06,
				["y"] = 0.0704551,
			},
			["Kargath, Badlands"] = {
				["y"] = 0.428775,
				["x"] = 0.554987,
				["mapx"] = 4.05,
				["mapy"] = 44.88,
				["routes"] = {
					[1] = "Booty Bay, Stranglethorn",
					[2] = "Flame Crest, Burning Steppes",
					[3] = "Grom'gol, Stranglethorn",
					[4] = "Hammerfall, Arathi",
					[5] = "Stonard, Swamp of Sorrows",
					[6] = "Thorium Point, Searing Gorge",
					[7] = "Undercity, Tirisfal",
				},
			},
			["Flame Crest, Burning Steppes"] = {
				["routes"] = {
					[1] = "Kargath, Badlands",
					[2] = "Stonard, Swamp of Sorrows",
					[3] = "Thorium Point, Searing Gorge",
				},
				["x"] = 0.555331,
				["mapx"] = 65.63,
				["mapy"] = 24.28,
				["y"] = 0.388859,
			},
			["Tarren Mill, Hillsbrad"] = {
				["routes"] = {
					[1] = "Hammerfall, Arathi",
					[2] = "Revantusk Village, The Hinterlands",
					[3] = "Undercity, Tirisfal",
				},
				["x"] = 0.494422,
				["mapx"] = 60.14,
				["mapy"] = 18.71,
				["y"] = 0.733126,
			},
			["Stonard, Swamp of Sorrows"] = {
				["routes"] = {
					[1] = "Booty Bay, Stranglethorn",
					[2] = "Flame Crest, Burning Steppes",
					[3] = "Grom'gol, Stranglethorn",
					[4] = "Kargath, Badlands",
				},
				["x"] = 0.605416,
				["mapx"] = 46.08,
				["mapy"] = 54.62,
				["y"] = 0.253385,
			},
			["Undercity, Tirisfal"] = {
				["y"] = 0.805093,
				["x"] = 0.442677,
				["mapx"] = 63.38,
				["mapy"] = 48.35,
				["routes"] = {
					[1] = "Hammerfall, Arathi",
					[2] = "Kargath, Badlands",
					[3] = "Light's Hope Chapel, Eastern Plaguelands",
					[4] = "Revantusk Village, The Hinterlands",
					[5] = "Sepulcher, Silverpine",
					[6] = "Tarren Mill, Hillsbrad",
				},
			},
			["Hammerfall, Arathi"] = {
				["routes"] = {
					[1] = "Kargath, Badlands",
					[2] = "Tarren Mill, Hillsbrad",
					[3] = "Undercity, Tirisfal",
				},
				["x"] = 0.615401,
				["mapx"] = 72.98,
				["mapy"] = 32.72,
				["y"] = 0.691091,
			},
			["Grom'gol, Stranglethorn"] = {
				["routes"] = {
					[1] = "Booty Bay, Stranglethorn",
					[2] = "Kargath, Badlands",
					[3] = "Stonard, Swamp of Sorrows",
				},
				["x"] = 0.448259,
				["mapx"] = 32.5,
				["mapy"] = 29.32,
				["y"] = 0.163592,
			},
			["Light's Hope Chapel, Eastern Plaguelands"] = {
				["y"] = 0.839905,
				["x"] = 0.697522,
				["mapx"] = 80.24,
				["mapy"] = 57.08,
				["routes"] = {
					[1] = "Undercity, Tirisfal",
				},
			},
			["Thorium Point, Searing Gorge"] = {
				["routes"] = {
					[1] = "Flame Crest, Burning Steppes",
					[2] = "Kargath, Badlands",
				},
				["x"] = 0.505439,
				["mapx"] = 34.82,
				["mapy"] = 30.58,
				["y"] = 0.432402,
			},
			["Sepulcher, Silverpine"] = {
				["routes"] = {
					[1] = "Undercity, Tirisfal",
				},
				["x"] = 0.384475,
				["y"] = 0.755098,
				["mapy"] = 42.48,
				["mapx"] = 45.59,
			},
			["Revantusk Village, The Hinterlands"] = {
				["routes"] = {
					[1] = "Tarren Mill, Hillsbrad",
					[2] = "Undercity, Tirisfal",
				},
				["x"] = 0.671537,
				["y"] = 0.703984,
				["mapy"] = 81.88,
				["mapx"] = 81.67,
			},
		},
	},
}

-- Alliance Data - contains user-submitted data.
Default_EFM_Data_Alliance = {
	["AllianceVersion"] = 2.1,
	["Alliance"] = {
		[1] = {
			["Rut'theran Village, Teldrassil"] = {
				["routes"] = {
					[1] = "Auberdine, Darkshore",
				},
				["x"] = 0.416144,
				["mapx"] = 58.39,
				["mapy"] = 93.92,
				["y"] = 0.842793,
			},
			["Stonetalon Peak, Stonetalon Mountains"] = {
				["routes"] = {
					[1] = "Auberdine, Darkshore",
				},
				["x"] = 0.390646,
				["mapx"] = 36.5,
				["mapy"] = 7.18,
				["y"] = 0.597828,
			},
			["Theramore, Dustwallow Marsh"] = {
				["y"] = 0.330511,
				["x"] = 0.636261,
				["mapx"] = 67.52,
				["mapy"] = 51.28,
				["routes"] = {
					[1] = "Auberdine, Darkshore",
					[2] = "Gadgetzan, Tanaris",
					[3] = "Nijel's Point, Desolace",
					[4] = "Thalanaar, Feralas",
				},
			},
			["Moonglade"] = {
				["routes"] = {
					[1] = "Auberdine, Darkshore",
					[2] = "Everlook, Winterspring",
				},
				["x"] = 0.552823,
				["mapx"] = 47.96,
				["mapy"] = 67.31,
				["y"] = 0.793992,
			},
			["Gadgetzan, Tanaris"] = {
				["y"] = 0.19088,
				["x"] = 0.604133,
				["mapx"] = 51.04,
				["mapy"] = 29.36,
				["routes"] = {
					[1] = "Thalanaar, Feralas",
					[2] = "Theramore, Dustwallow Marsh",
					[4] = "Cenarion Hold, Silithus",
				},
			},
			["Talrendis Point, Azshara"] = {
				["routes"] = {
					[1] = "Auberdine, Darkshore",
					[2] = "Talonbranch Glade, Felwood",
				},
				["x"] = 0.610477,
				["mapx"] = 11.95,
				["mapy"] = 77.68000000000001,
				["y"] = 0.599073,
			},
			["Auberdine, Darkshore"] = {
				["y"] = 0.748208,
				["x"] = 0.427786,
				["mapx"] = 36.37,
				["mapy"] = 45.56,
				["routes"] = {
					[1] = "Astranaar, Ashenvale",
					[2] = "Feathermoon, Feralas",
					[3] = "Moonglade",
					[4] = "Nijel's Point, Desolace",
					[5] = "Rut'theran Village, Teldrassil",
					[6] = "Stonetalon Peak, Stonetalon Mountains",
					[7] = "Talonbranch Glade, Felwood",
					[8] = "Talrendis Point, Azshara",
					[9] = "Theramore, Dustwallow Marsh",
				},
			},
			["Feathermoon, Feralas"] = {
				["y"] = 0.307979,
				["x"] = 0.313531,
				["mapx"] = 30.29,
				["mapy"] = 43.29,
				["routes"] = {
					[1] = "Auberdine, Darkshore",
					[2] = "Nijel's Point, Desolace",
					[3] = "Thalanaar, Feralas",
				},
			},
			["Astranaar, Ashenvale"] = {
				["routes"] = {
					[1] = "Auberdine, Darkshore",
				},
				["x"] = 0.462582,
				["mapx"] = 34.49,
				["mapy"] = 48.01,
				["y"] = 0.603835,
			},
			["Nijel's Point, Desolace"] = {
				["y"] = 0.493395,
				["x"] = 0.396228,
				["mapx"] = 64.67,
				["mapy"] = 10.43,
				["routes"] = {
					[1] = "Auberdine, Darkshore",
					[2] = "Feathermoon, Feralas",
					[3] = "Theramore, Dustwallow Marsh",
				},
			},
			["Everlook, Winterspring"] = {
				["routes"] = {
					[1] = "Talonbranch Glade, Felwood",
					[2] = "Moonglade",
				},
				["x"] = 0.64554,
				["mapx"] = 62.34,
				["mapy"] = 36.69,
				["y"] = 0.767019,
			},
			["Talonbranch Glade, Felwood"] = {
				["routes"] = {
					[1] = "Auberdine, Darkshore",
					[2] = "Everlook, Winterspring",
					[3] = "Talrendis Point, Azshara",
				},
				["x"] = 0.530809,
				["mapx"] = 62.46,
				["mapy"] = 24.16,
				["y"] = 0.742692,
			},
			["Thalanaar, Feralas"] = {
				["y"] = 0.303127,
				["x"] = 0.482576,
				["mapx"] = 89.45999999999999,
				["mapy"] = 45.86,
				["routes"] = {
					[1] = "Feathermoon, Feralas",
					[2] = "Gadgetzan, Tanaris",
					[3] = "Theramore, Dustwallow Marsh",
				},
			},
			["Cenarion Hold, Silithus"] = {
				["routes"] = {
					[1] = "Gadgetzan, Tanaris",
				},
				["x"] = 0.4189798533916473,
				["mapx"] = 50.6,
				["mapy"] = 34.51,
				["y"] = 0.2098672986030579,
			},
		},
		[2] = {
			["Southshore, Hillsbrad"] = {
				["routes"] = {
					[1] = "Menethil Harbor, Wetlands",
					[2] = "Aerie Peak, The Hinterlands",
					[3] = "Chillwind Camp, Western Plaguelands",
					[4] = "Ironforge, Dun Morogh",
					[5] = "Refuge Pointe, Arathi",
				},
				["x"] = 0.47862,
				["mapx"] = 49.44,
				["mapy"] = 52.12,
				["y"] = 0.700487,
			},
			["Sentinel Hill, Westfall"] = {
				["y"] = 0.245498,
				["x"] = 0.40741,
				["mapx"] = 56.57,
				["mapy"] = 52.66,
				["routes"] = {
					[1] = "Booty Bay, Stranglethorn",
					[2] = "Darkshire, Duskwood",
					[3] = "Lakeshire, Redridge",
					[4] = "Stormwind, Elwynn",
				},
			},
			["Thelsamar, Loch Modan"] = {
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Menethil Harbor, Wetlands",
					[3] = "Refuge Pointe, Arathi",
				},
				["x"] = 0.5893929999999999,
				["mapx"] = 33.88,
				["mapy"] = 50.9,
				["y"] = 0.484383,
			},
			["Light's Hope Chapel, Eastern Plaguelands"] = {
				["y"] = 0.837321,
				["x"] = 0.699995,
				["mapx"] = 81.59,
				["mapy"] = 59.25,
				["routes"] = {
					[1] = "Aerie Peak, The Hinterlands",
				},
			},
			["Aerie Peak, The Hinterlands"] = {
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Light's Hope Chapel, Eastern Plaguelands",
					[3] = "Refuge Pointe, Arathi",
					[4] = "Southshore, Hillsbrad",
				},
				["x"] = 0.546853,
				["mapx"] = 11.11,
				["mapy"] = 46.08,
				["y"] = 0.746146,
			},
			["Stormwind, Elwynn"] = {
				["y"] = 0.327542,
				["x"] = 0.432504,
				["mapx"] = 66.3,
				["mapy"] = 62.66,
				["routes"] = {
					[1] = "Booty Bay, Stranglethorn",
					[2] = "Darkshire, Duskwood",
					[3] = "Ironforge, Dun Morogh",
					[4] = "Lakeshire, Redridge",
					[5] = "Nethergarde Keep, Blasted Lands",
					[6] = "Sentinel Hill, Westfall",
					[7] = "Morgan's Vigil, Burning Steppes",
				},
			},
			["Chillwind Camp, Western Plaguelands"] = {
				["routes"] = {
					[1] = "Southshore, Hillsbrad",
				},
				["x"] = 0.520581,
				["mapx"] = 42.91,
				["mapy"] = 84.93000000000001,
				["y"] = 0.775855,
			},
			["Morgan's Vigil, Burning Steppes"] = {
				["routes"] = {
					[1] = "Nethergarde Keep, Blasted Lands",
					[2] = "Thorium Point, Searing Gorge",
					[3] = "Stormwind, Elwynn",
				},
				["x"] = 0.580601,
				["mapx"] = 84.38,
				["mapy"] = 68.3,
				["y"] = 0.349378,
			},
			["Lakeshire, Redridge"] = {
				["y"] = 0.300541,
				["x"] = 0.557343,
				["mapx"] = 30.63,
				["mapy"] = 59.34,
				["routes"] = {
					[1] = "Darkshire, Duskwood",
					[2] = "Sentinel Hill, Westfall",
					[3] = "Stormwind, Elwynn",
				},
			},
			["Nethergarde Keep, Blasted Lands"] = {
				["routes"] = {
					[1] = "Darkshire, Duskwood",
					[2] = "Morgan's Vigil, Burning Steppes",
					[3] = "Stormwind, Elwynn",
				},
				["x"] = 0.612595,
				["mapx"] = 65.48999999999999,
				["mapy"] = 24.42,
				["y"] = 0.223322,
			},
			["Ironforge, Dun Morogh"] = {
				["routes"] = {
					[1] = "Aerie Peak, The Hinterlands",
					[2] = "Menethil Harbor, Wetlands",
					[3] = "Refuge Pointe, Arathi",
					[4] = "Southshore, Hillsbrad",
					[5] = "Stormwind, Elwynn",
					[6] = "Thelsamar, Loch Modan",
					[7] = "Thorium Point, Searing Gorge",
				},
				["x"] = 0.50798,
				["mapx"] = 55.63,
				["mapy"] = 48.07,
				["y"] = 0.511915,
			},
			["Booty Bay, Stranglethorn"] = {
				["y"] = 0.06913569999999999,
				["x"] = 0.433677,
				["mapx"] = 27.52,
				["mapy"] = 77.67,
				["routes"] = {
					[1] = "Darkshire, Duskwood",
					[2] = "Sentinel Hill, Westfall",
					[3] = "Stormwind, Elwynn",
				},
			},
			["Menethil Harbor, Wetlands"] = {
				["y"] = 0.559148,
				["x"] = 0.490907,
				["mapx"] = 9.48,
				["mapy"] = 59.71,
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Refuge Pointe, Arathi",
					[3] = "Southshore, Hillsbrad",
					[4] = "Thelsamar, Loch Modan",
				},
			},
			["Thorium Point, Searing Gorge"] = {
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Morgan's Vigil, Burning Steppes",
				},
				["x"] = 0.508569,
				["mapx"] = 37.91,
				["mapy"] = 30.5,
				["y"] = 0.43251,
			},
			["Darkshire, Duskwood"] = {
				["y"] = 0.250701,
				["x"] = 0.512853,
				["mapx"] = 77.59999999999999,
				["mapy"] = 44.29,
				["routes"] = {
					[1] = "Booty Bay, Stranglethorn",
					[2] = "Lakeshire, Redridge",
					[3] = "Nethergarde Keep, Blasted Lands",
					[4] = "Sentinel Hill, Westfall",
					[5] = "Stormwind, Elwynn",
				},
			},
			["Refuge Pointe, Arathi"] = {
				["routes"] = {
					[1] = "Menethil Harbor, Wetlands",
					[2] = "Aerie Peak, The Hinterlands",
					[3] = "Ironforge, Dun Morogh",
					[4] = "Southshore, Hillsbrad",
					[5] = "Thelsamar, Loch Modan",
				},
				["x"] = 0.5703589999999999,
				["mapx"] = 45.73,
				["mapy"] = 46.11,
				["y"] = 0.676216,
			},
		},
	},
}

-- These are the only two flight paths, so this should never need to be changed.
Default_EFM_Data_Druid = {
	["DruidVersion"] = 2.0,
	["Alliance"] = {
		[1] = {
			["Nighthaven, Moonglade"] = {
				["y"] = 0.807872,
				["x"] = 0.549444,
				["mapx"] = 44.26,
				["mapy"] = 45.29,
				["routes"] = {
					[1] = "Rut'theran Village, Teldrassil",
				},
			},
		},
	},
	["Horde"] = {
		[1] = {
			["Nighthaven, Moonglade"] = {
				["routes"] = {
					[1] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.54947,
				["mapx"] = 44.3,
				["mapy"] = 45.68,
				["y"] = 0.80763,
			},
		},
	},
}


-- Map Translation Data - Horde
Default_EFM_Data_HordeMapTranslation = {
	["HordeMapTranslationVersion"] = 2.1,
	["Horde"] = {
		[1] = {
			["Brackenwall Village, Dustwallow Marsh"] = 7,
			["Zoram'gar Outpost, Ashenvale"] = 1,
			["Freewind Post, Thousand Needles"] = 18,
			["Crossroads, The Barrens"] = 17,
			["Camp Taurajo, The Barrens"] = 17,
			["Everlook, Winterspring"] = 21,
			["Thunder Bluff, Mulgore"] = 19,
			["Sun Rock Retreat, Stonetalon Mountains"] = 14,
			["Cenarion Hold, Silithus"] = 13,
			["Camp Mojache, Feralas"] = 9,
			["Gadgetzan, Tanaris"] = 15,
			["Shadowprey Village, Desolace"] = 5,
			["Bloodvenom Post, Felwood"] = 8,
			["Orgrimmar, Durotar"] = 12,
			["Splintertree Post, Ashenvale"] = 1,
			["Valormok, Azshara"] = 2,
		},
		[2] = {
			["Booty Bay, Stranglethorn"] = 18,
			["Kargath, Badlands"] = 3,
			["Flame Crest, Burning Steppes"] = 5,
			["Tarren Mill, Hillsbrad"] = 11,
			["Stonard, Swamp of Sorrows"] = 19,
			["Undercity, Tirisfal"] = 22,
			["Hammerfall, Arathi"] = 2,
			["Grom'gol, Stranglethorn"] = 18,
			["Light's Hope Chapel, Eastern Plaguelands"] = 9,
			["Thorium Point, Searing Gorge"] = 15,
			["Sepulcher, Silverpine"] = 16,
			["Revantusk Village, The Hinterlands"] = 20,
		},
	},
}

-- Map Translation Data - Alliance
Default_EFM_Data_AllianceMapTranslation = {
	["AllianceMapTranslationVersion"] = 2.1,
	["Alliance"] = {
		[1] = {
			["Rut'theran Village, Teldrassil"] = 16,
			["Cenarion Hold, Silithus"] = 13,
			["Theramore, Dustwallow Marsh"] = 7,
			["Moonglade"] = 10,
			["Gadgetzan, Tanaris"] = 15,
			["Talrendis Point, Azshara"] = 2,
			["Auberdine, Darkshore"] = 3,
			["Feathermoon, Feralas"] = 9,
			["Astranaar, Ashenvale"] = 1,
			["Nijel's Point, Desolace"] = 5,
			["Talonbranch Glade, Felwood"] = 8,
			["Everlook, Winterspring"] = 21,
			["Thalanaar, Feralas"] = 9,
			["Nighthaven, Moonglade"] = 10,
			["Stonetalon Peak, Stonetalon Mountains"] = 14,
		},
		[2] = {
			["Southshore, Hillsbrad"] = 11,
			["Sentinel Hill, Westfall"] = 24,
			["Thelsamar, Loch Modan"] = 13,
			["Light's Hope Chapel, Eastern Plaguelands"] = 9,
			["Aerie Peak, The Hinterlands"] = 20,
			["Stormwind, Elwynn"] = 17,
			["Booty Bay, Stranglethorn"] = 18,
			["Morgan's Vigil, Burning Steppes"] = 5,
			["Thorium Point, Searing Gorge"] = 15,
			["Nethergarde Keep, Blasted Lands"] = 4,
			["Ironforge, Dun Morogh"] = 12,
			["Darkshire, Duskwood"] = 8,
			["Chillwind Camp, Western Plaguelands"] = 23,
			["Lakeshire, Redridge"] = 14,
			["Menethil Harbor, Wetlands"] = 25,
			["Refuge Pointe, Arathi"] = 2,
		},
	},
}

-- Flight Path Data - Horde
Default_EFM_Data_HordeFlightPath = {
	["HordeFlightPathVersion"] = 2.1,
	["Horde"] = {
		[1] = {
			["Brackenwall Village, Dustwallow Marsh"] = {
				["Orgrimmar, Durotar"] = {
					["Duration"] = "3:48",
					["Cost"] = 567,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "2:44",
					["Cost"] = 567,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "3:41",
					["Cost"] = 657,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "3:45",
					["Cost"] = 567,
				},
			},
			["Cenarion Hold, Silithus"] = {
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "4:07",
					["Cost"] = 730,
				},
			},
			["Moonglade"] = {
				["Everlook, Winterspring"] = {
					["Duration"] = "2:25",
					["Cost"] = 918,
				},
				["Bloodvenom Post, Felwood"] = {
					["Duration"] = "2:40",
					["Cost"] = 837,
				},
			},
			["Zoram'gar Outpost, Ashenvale"] = {
				["Crossroads, The Barrens"] = {
					["Duration"] = "3:49",
					["Cost"] = 99,
				},
				["Splintertree Post, Ashenvale"] = {
					["Duration"] = "2:49",
					["Cost"] = 477,
				},
			},
			["Freewind Post, Thousand Needles"] = {
				["Crossroads, The Barrens"] = {
					["Duration"] = "3:06",
					["Cost"] = 387,
				},
				["Camp Taurajo, The Barrens"] = {
					["Duration"] = "2:16",
					["Cost"] = 387,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "1:33",
					["Cost"] = 657,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "3:39",
					["Cost"] = 387,
				},
			},
			["Crossroads, The Barrens"] = {
				["Brackenwall Village, Dustwallow Marsh"] = {
					["Duration"] = "2:44",
					["Cost"] = 567,
				},
				["Camp Mojache, Feralas"] = {
					["Duration"] = "4:14",
					["Cost"] = 657,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "5:10",
					["Cost"] = 657,
				},
				["Zoram'gar Outpost, Ashenvale"] = {
					["Duration"] = "3:51",
					["Cost"] = 297,
				},
				["Freewind Post, Thousand Needles"] = {
					["Duration"] = "3:09",
					["Cost"] = 387,
				},
				["Orgrimmar, Durotar"] = {
					["Duration"] = "2:14",
					["Cost"] = 99,
				},
				["Splintertree Post, Ashenvale"] = {
					["Duration"] = "2:40",
					["Cost"] = 477,
				},
				["Camp Taurajo, The Barrens"] = {
					["Duration"] = "1:31",
					["Cost"] = 99,
				},
				["Sun Rock Retreat, Stonetalon Mountains"] = {
					["Duration"] = "2:23",
					["Cost"] = 189,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "2:53",
					["Cost"] = 99,
				},
				["Bloodvenom Post, Felwood"] = {
					["Duration"] = "4:02",
					["Cost"] = 837,
				},
				["Valormok, Azshara"] = {
					["Duration"] = "2:52",
					["Cost"] = 747,
				},
			},
			["Camp Taurajo, The Barrens"] = {
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "1:55",
					["Cost"] = 99,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "1:23",
					["Cost"] = 99,
				},
				["Freewind Post, Thousand Needles"] = {
					["Duration"] = "2:06",
					["Cost"] = 387,
				},
			},
			["Everlook, Winterspring"] = {
				["Orgrimmar, Durotar"] = {
					["Duration"] = "4:56",
					["Cost"] = 918,
				},
				["Bloodvenom Post, Felwood"] = {
					["Duration"] = "3:17",
					["Cost"] = 837,
				},
				["Moonglade"] = {
					["Duration"] = "2:26",
					["Cost"] = 747,
				},
			},
			["Thunder Bluff, Mulgore"] = {
				["Brackenwall Village, Dustwallow Marsh"] = {
					["Duration"] = "3:59",
					["Cost"] = 567,
				},
				["Camp Mojache, Feralas"] = {
					["Duration"] = "4:13",
					["Cost"] = 657,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "4:51",
					["Cost"] = 657,
				},
				["Freewind Post, Thousand Needles"] = {
					["Duration"] = "3:25",
					["Cost"] = 387,
				},
				["Orgrimmar, Durotar"] = {
					["Duration"] = "3:28",
					["Cost"] = 45,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "2:38",
					["Cost"] = 99,
				},
				["Camp Taurajo, The Barrens"] = {
					["Duration"] = "1:51",
					["Cost"] = 99,
				},
				["Sun Rock Retreat, Stonetalon Mountains"] = {
					["Duration"] = "3:03",
					["Cost"] = 189,
				},
				["Shadowprey Village, Desolace"] = {
					["Duration"] = "2:41",
					["Cost"] = 477,
				},
				["Valormok, Azshara"] = {
					["Duration"] = "4:30",
					["Cost"] = 747,
				},
			},
			["Sun Rock Retreat, Stonetalon Mountains"] = {
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "2:55",
					["Cost"] = 189,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "2:31",
					["Cost"] = 189,
				},
				["Shadowprey Village, Desolace"] = {
					["Duration"] = "3:17",
					["Cost"] = 477,
				},
			},
			["Camp Mojache, Feralas"] = {
				["Crossroads, The Barrens"] = {
					["Duration"] = "4:27",
					["Cost"] = 657,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "3:22",
					["Cost"] = 567,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "4:22",
					["Cost"] = 657,
				},
				["Shadowprey Village, Desolace"] = {
					["Duration"] = "3:26",
					["Cost"] = 657,
				},
			},
			["Gadgetzan, Tanaris"] = {
				["Brackenwall Village, Dustwallow Marsh"] = {
					["Duration"] = "3:42",
					["Cost"] = 567,
				},
				["Orgrimmar, Durotar"] = {
					["Duration"] = "5:51",
					["Cost"] = 657,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "5:06",
					["Cost"] = 657,
				},
				["Camp Mojache, Feralas"] = {
					["Duration"] = "3:13",
					["Cost"] = 567,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "5:05",
					["Cost"] = 657,
				},
				["Freewind Post, Thousand Needles"] = {
					["Duration"] = "1:27",
					["Cost"] = 387,
				},
				["Cenarion Hold, Silithus"] = {
					["Duration"] = "4:00",
					["Cost"] = 918,
				},
			},
			["Shadowprey Village, Desolace"] = {
				["Sun Rock Retreat, Stonetalon Mountains"] = {
					["Duration"] = "3:21",
					["Cost"] = 189,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "2:52",
					["Cost"] = 477,
				},
				["Camp Mojache, Feralas"] = {
					["Duration"] = "3:24",
					["Cost"] = 657,
				},
			},
			["Bloodvenom Post, Felwood"] = {
				["Orgrimmar, Durotar"] = {
					["Duration"] = "4:06",
					["Cost"] = 837,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "4:28",
					["Cost"] = 837,
				},
				["Moonglade"] = {
					["Duration"] = "2:40",
					["Cost"] = 747,
				},
				["Everlook, Winterspring"] = {
					["Duration"] = "3:13",
					["Cost"] = 918,
				},
				["Valormok, Azshara"] = {
					["Duration"] = "3:57",
					["Cost"] = 747,
				},
			},
			["Orgrimmar, Durotar"] = {
				["Brackenwall Village, Dustwallow Marsh"] = {
					["Duration"] = "3:49",
					["Cost"] = 567,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "6:57",
					["Cost"] = 657,
				},
				["Bloodvenom Post, Felwood"] = {
					["Duration"] = "4:09",
					["Cost"] = 747,
				},
				["Splintertree Post, Ashenvale"] = {
					["Duration"] = "1:30",
					["Cost"] = 477,
				},
				["Everlook, Winterspring"] = {
					["Duration"] = "5:21",
					["Cost"] = 918,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "3:46",
					["Cost"] = 45,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "1:51",
					["Cost"] = 99,
				},
				["Valormok, Azshara"] = {
					["Duration"] = "1:39",
					["Cost"] = 747,
				},
			},
			["Splintertree Post, Ashenvale"] = {
				["Orgrimmar, Durotar"] = {
					["Duration"] = "1:29",
					["Cost"] = 477,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "2:44",
					["Cost"] = 477,
				},
				["Zoram'gar Outpost, Ashenvale"] = {
					["Duration"] = "2:48",
					["Cost"] = 297,
				},
			},
			["Valormok, Azshara"] = {
				["Bloodvenom Post, Felwood"] = {
					["Duration"] = "3:59",
					["Cost"] = 837,
				},
				["Crossroads, The Barrens"] = {
					["Duration"] = "2:52",
					["Cost"] = 747,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "4:18",
					["Cost"] = 747,
				},
				["Orgrimmar, Durotar"] = {
					["Duration"] = "2:02",
					["Cost"] = 747,
				},
			},
			["Nighthaven, Moonglade"] = {
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "9:04",
					["Cost"] = 0,
				},
			},
		},
		[2] = {
			["Booty Bay, Stranglethorn"] = {
				["Grom'gol, Stranglethorn"] = {
					["Duration"] = "1:43",
					["Cost"] = 567,
				},
				["Stonard, Swamp of Sorrows"] = {
					["Duration"] = "4:11",
					["Cost"] = 567,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "6:35",
					["Cost"] = 567,
				},
			},
			["Kargath, Badlands"] = {
				["Booty Bay, Stranglethorn"] = {
					["Duration"] = "7:12",
					["Cost"] = 567,
				},
				["Hammerfall, Arathi"] = {
					["Duration"] = "4:17",
					["Cost"] = 567,
				},
				["Grom'gol, Stranglethorn"] = {
					["Duration"] = "5:15",
					["Cost"] = 477,
				},
				["Flame Crest, Burning Steppes"] = {
					["Duration"] = "1:28",
					["Cost"] = 747,
				},
				["Stonard, Swamp of Sorrows"] = {
					["Duration"] = "4:45",
					["Cost"] = 639,
				},
				["Thorium Point, Searing Gorge"] = {
					["Duration"] = "0:57",
					["Cost"] = 747,
				},
				["Undercity, Tirisfal"] = {
					["Duration"] = "8:19",
					["Cost"] = 567,
				},
			},
			["Flame Crest, Burning Steppes"] = {
				["Stonard, Swamp of Sorrows"] = {
					["Duration"] = "3:18",
					["Cost"] = 747,
				},
				["Thorium Point, Searing Gorge"] = {
					["Duration"] = "1:14",
					["Cost"] = 747,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "1:28",
					["Cost"] = 747,
				},
			},
			["Tarren Mill, Hillsbrad"] = {
				["Hammerfall, Arathi"] = {
					["Duration"] = "1:55",
					["Cost"] = 530,
				},
				["Revantusk Village, The Hinterlands"] = {
					["Duration"] = "3:12",
					["Cost"] = 730,
				},
				["Undercity, Tirisfal"] = {
					["Duration"] = "2:15",
					["Cost"] = 330,
				},
			},
			["Stonard, Swamp of Sorrows"] = {
				["Booty Bay, Stranglethorn"] = {
					["Duration"] = "4:21",
					["Cost"] = 567,
				},
				["Grom'gol, Stranglethorn"] = {
					["Duration"] = "3:10",
					["Cost"] = 567,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "4:46",
					["Cost"] = 567,
				},
				["Flame Crest, Burning Steppes"] = {
					["Duration"] = "3:19",
					["Cost"] = 747,
				},
			},
			["Undercity, Tirisfal"] = {
				["Hammerfall, Arathi"] = {
					["Duration"] = "5:01",
					["Cost"] = 530,
				},
				["Revantusk Village, The Hinterlands"] = {
					["Duration"] = "4:45",
					["Cost"] = 730,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "8:09",
					["Cost"] = 630,
				},
				["Light's Hope Chapel, Eastern Plaguelands"] = {
					["Duration"] = "4:22",
					["Cost"] = 1020,
				},
				["Tarren Mill, Hillsbrad"] = {
					["Duration"] = "2:21",
					["Cost"] = 330,
				},
				["Sepulcher, Silverpine"] = {
					["Duration"] = "1:46",
					["Cost"] = 110,
				},
			},
			["Hammerfall, Arathi"] = {
				["Tarren Mill, Hillsbrad"] = {
					["Duration"] = "1:58",
					["Cost"] = 297,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "4:20",
					["Cost"] = 567,
				},
				["Undercity, Tirisfal"] = {
					["Duration"] = "4:16",
					["Cost"] = 477,
				},
			},
			["Grom'gol, Stranglethorn"] = {
				["Booty Bay, Stranglethorn"] = {
					["Duration"] = "1:22",
					["Cost"] = 567,
				},
				["Stonard, Swamp of Sorrows"] = {
					["Duration"] = "3:08",
					["Cost"] = 567,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "5:15",
					["Cost"] = 567,
				},
			},
			["Light's Hope Chapel, Eastern Plaguelands"] = {
				["Undercity, Tirisfal"] = {
					["Duration"] = "4:19",
					["Cost"] = 1020,
				},
			},
			["Revantusk Village, The Hinterlands"] = {
				["Tarren Mill, Hillsbrad"] = {
					["Duration"] = "2:48",
					["Cost"] = 297,
				},
				["Undercity, Tirisfal"] = {
					["Duration"] = "4:45",
					["Cost"] = 657,
				},
			},
			["Sepulcher, Silverpine"] = {
				["Undercity, Tirisfal"] = {
					["Duration"] = "1:55",
					["Cost"] = 99,
				},
			},
			["Thorium Point, Searing Gorge"] = {
				["Flame Crest, Burning Steppes"] = {
					["Duration"] = "1:18",
					["Cost"] = 747,
				},
				["Kargath, Badlands"] = {
					["Duration"] = "0:57",
					["Cost"] = 567,
				},
			},
		},
	},
}

-- Flight Path Data - Alliance
Default_EFM_Data_AllianceFlightPath= {
	["AllianceFlightPathVersion"] = 2.1,
	["Alliance"] = {
		[1] = {
			["Rut'theran Village, Teldrassil"] = {
				["Auberdine, Darkshore"] = {
					["Duration"] = "1:29",
					["Cost"] = 0,
				},
			},
			["Cenarion Hold, Silithus"] = {
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "3:11",
					["Cost"] = 730,
				},
			},
			["Theramore, Dustwallow Marsh"] = {
				["Nijel's Point, Desolace"] = {
					["Duration"] = "5:35",
					["Cost"] = 504,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "2:38",
					["Cost"] = 657,
				},
				["Auberdine, Darkshore"] = {
					["Duration"] = "10:21",
					["Cost"] = 598,
				},
				["Thalanaar, Feralas"] = {
					["Duration"] = "2:41",
					["Cost"] = 387,
				},
			},
			["Moonglade"] = {
				["Everlook, Winterspring"] = {
					["Duration"] = "2:13",
					["Cost"] = 867,
				},
				["Auberdine, Darkshore"] = {
					["Duration"] = "2:26",
					["Cost"] = 706,
				},
			},
			["Gadgetzan, Tanaris"] = {
				["Cenarion Hold, Silithus"] = {
					["Duration"] = "3:18",
					["Cost"] = 816,
				},
				["Thalanaar, Feralas"] = {
					["Duration"] = "2:54",
					["Cost"] = 344,
				},
				["Theramore, Dustwallow Marsh"] = {
					["Duration"] = "2:38",
					["Cost"] = 504,
				},
			},
			["Talrendis Point, Azshara"] = {
				["Talonbranch Glade, Felwood"] = {
					["Duration"] = "4:45",
					["Cost"] = 657,
				},
				["Auberdine, Darkshore"] = {
					["Duration"] = "5:06",
					["Cost"] = 657,
				},
			},
			["Auberdine, Darkshore"] = {
				["Rut'theran Village, Teldrassil"] = {
					["Duration"] = "1:25",
					["Cost"] = 0,
				},
				["Stonetalon Peak, Stonetalon Mountains"] = {
					["Duration"] = "3:05",
					["Cost"] = 280,
				},
				["Theramore, Dustwallow Marsh"] = {
					["Duration"] = "11:31",
					["Cost"] = 536,
				},
				["Moonglade"] = {
					["Duration"] = "2:29",
					["Cost"] = 706,
				},
				["Talrendis Point, Azshara"] = {
					["Duration"] = "5:03",
					["Cost"] = 584,
				},
				["Talonbranch Glade, Felwood"] = {
					["Duration"] = "3:09",
					["Cost"] = 620,
				},
				["Feathermoon, Feralas"] = {
					["Duration"] = "7:55",
					["Cost"] = 620,
				},
				["Astranaar, Ashenvale"] = {
					["Duration"] = "3:00",
					["Cost"] = 280,
				},
				["Nijel's Point, Desolace"] = {
					["Duration"] = "4:46",
					["Cost"] = 450,
				},
			},
			["Feathermoon, Feralas"] = {
				["Auberdine, Darkshore"] = {
					["Duration"] = "7:49",
					["Cost"] = 584,
				},
				["Nijel's Point, Desolace"] = {
					["Duration"] = "3:48",
					["Cost"] = 620,
				},
				["Thalanaar, Feralas"] = {
					["Duration"] = "2:49",
					["Cost"] = 387,
				},
			},
			["Astranaar, Ashenvale"] = {
				["Auberdine, Darkshore"] = {
					["Duration"] = "2:31",
					["Cost"] = 297,
				},
			},
			["Nijel's Point, Desolace"] = {
				["Auberdine, Darkshore"] = {
					["Duration"] = "4:43",
					["Cost"] = 477,
				},
				["Theramore, Dustwallow Marsh"] = {
					["Duration"] = "5:08",
					["Cost"] = 477,
				},
				["Feathermoon, Feralas"] = {
					["Duration"] = "3:49",
					["Cost"] = 657,
				},
			},
			["Talonbranch Glade, Felwood"] = {
				["Everlook, Winterspring"] = {
					["Duration"] = "2:03",
					["Cost"] = 867,
				},
				["Talrendis Point, Azshara"] = {
					["Duration"] = "4:45",
					["Cost"] = 657,
				},
				["Auberdine, Darkshore"] = {
					["Duration"] = "3:07",
					["Cost"] = 620,
				},
			},
			["Everlook, Winterspring"] = {
				["Talonbranch Glade, Felwood"] = {
					["Duration"] = "2:04",
					["Cost"] = 620,
				},
				["Moonglade"] = {
					["Duration"] = "2:12",
					["Cost"] = 706,
				},
			},
			["Nighthaven, Moonglade"] = {
				["Rut'theran Village, Teldrassil"] = {
					["Duration"] = "2:34",
					["Cost"] = 0,
				},
			},
			["Thalanaar, Feralas"] = {
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "2:51",
					["Cost"] = 657,
				},
				["Theramore, Dustwallow Marsh"] = {
					["Duration"] = "2:41",
					["Cost"] = 657,
				},
				["Feathermoon, Feralas"] = {
					["Duration"] = "2:49",
					["Cost"] = 504,
				},
			},
			["Stonetalon Peak, Stonetalon Mountains"] = {
				["Auberdine, Darkshore"] = {
					["Duration"] = "3:01",
					["Cost"] = 297,
				},
			},
		},
		[2] = {
			["Southshore, Hillsbrad"] = {
				["Chillwind Camp, Western Plaguelands"] = {
					["Duration"] = "1:27",
					["Cost"] = 706,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "3:24",
					["Cost"] = 280,
				},
				["Aerie Peak, The Hinterlands"] = {
					["Duration"] = "1:12",
					["Cost"] = 584,
				},
				["Menethil Harbor, Wetlands"] = {
					["Duration"] = "1:45",
					["Cost"] = 280,
				},
				["Refuge Pointe, Arathi"] = {
					["Duration"] = "1:15",
					["Cost"] = 424,
				},
			},
			["Sentinel Hill, Westfall"] = {
				["Darkshire, Duskwood"] = {
					["Duration"] = "1:38",
					["Cost"] = 297,
				},
				["Booty Bay, Stranglethorn"] = {
					["Duration"] = "3:07",
					["Cost"] = 567,
				},
				["Lakeshire, Redridge"] = {
					["Duration"] = "2:11",
					["Cost"] = 189,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "1:22",
					["Cost"] = 99,
				},
			},
			["Thelsamar, Loch Modan"] = {
				["Menethil Harbor, Wetlands"] = {
					["Duration"] = "2:32",
					["Cost"] = 330,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "1:57",
					["Cost"] = 110,
				},
				["Refuge Pointe, Arathi"] = {
					["Duration"] = "2:44",
					["Cost"] = 450,
				},
			},
			["Light's Hope Chapel, Eastern Plaguelands"] = {
				["Aerie Peak, The Hinterlands"] = {
					["Duration"] = "2:55",
					["Cost"] = 584,
				},
			},
			["Aerie Peak, The Hinterlands"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:08",
					["Cost"] = 314,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "4:16",
					["Cost"] = 657,
				},
				["Light's Hope Chapel, Eastern Plaguelands"] = {
					["Duration"] = "2:55",
					["Cost"] = 918,
				},
				["Refuge Pointe, Arathi"] = {
					["Duration"] = "1:15",
					["Cost"] = 477,
				},
			},
			["Stormwind, Elwynn"] = {
				["Booty Bay, Stranglethorn"] = {
					["Duration"] = "4:06",
					["Cost"] = 504,
				},
				["Sentinel Hill, Westfall"] = {
					["Duration"] = "1:17",
					["Cost"] = 88,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "4:20",
					["Cost"] = 40,
				},
				["Darkshire, Duskwood"] = {
					["Duration"] = "1:57",
					["Cost"] = 264,
				},
				["Morgan's Vigil, Burning Steppes"] = {
					["Duration"] = "2:30",
					["Cost"] = 664,
				},
				["Lakeshire, Redridge"] = {
					["Duration"] = "1:52",
					["Cost"] = 168,
				},
				["Nethergarde Keep, Blasted Lands"] = {
					["Duration"] = "2:54",
					["Cost"] = 664,
				},
			},
			["Chillwind Camp, Western Plaguelands"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:27",
					["Cost"] = 280,
				},
			},
			["Morgan's Vigil, Burning Steppes"] = {
				["Nethergarde Keep, Blasted Lands"] = {
					["Duration"] = "4:10",
					["Cost"] = 664,
				},
				["Thorium Point, Searing Gorge"] = {
					["Duration"] = "1:44",
					["Cost"] = 664,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "2:31",
					["Cost"] = 264,
				},
			},
			["Thorium Point, Searing Gorge"] = {
				["Morgan's Vigil, Burning Steppes"] = {
					["Duration"] = "1:43",
					["Cost"] = 664,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "1:31",
					["Cost"] = 664,
				},
			},
			["Menethil Harbor, Wetlands"] = {
				["Thelsamar, Loch Modan"] = {
					["Duration"] = "2:44",
					["Cost"] = 110,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "1:30",
					["Cost"] = 330,
				},
				["Southshore, Hillsbrad"] = {
					["Duration"] = "2:10",
					["Cost"] = 297,
				},
				["Refuge Pointe, Arathi"] = {
					["Duration"] = "1:53",
					["Cost"] = 477,
				},
			},
			["Ironforge, Dun Morogh"] = {
				["Menethil Harbor, Wetlands"] = {
					["Duration"] = "2:10",
					["Cost"] = 264,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "3:35",
					["Cost"] = 40,
				},
				["Southshore, Hillsbrad"] = {
					["Duration"] = "4:26",
					["Cost"] = 264,
				},
				["Thelsamar, Loch Modan"] = {
					["Duration"] = "1:42",
					["Cost"] = 88,
				},
				["Aerie Peak, The Hinterlands"] = {
					["Duration"] = "5:07",
					["Cost"] = 584,
				},
				["Thorium Point, Searing Gorge"] = {
					["Duration"] = "1:29",
					["Cost"] = 664,
				},
				["Refuge Pointe, Arathi"] = {
					["Duration"] = "4:17",
					["Cost"] = 424,
				},
			},
			["Booty Bay, Stranglethorn"] = {
				["Darkshire, Duskwood"] = {
					["Duration"] = "2:56",
					["Cost"] = 297,
				},
				["Sentinel Hill, Westfall"] = {
					["Duration"] = "3:02",
					["Cost"] = 477,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "3:42",
					["Cost"] = 567,
				},
			},
			["Darkshire, Duskwood"] = {
				["Nethergarde Keep, Blasted Lands"] = {
					["Duration"] = "1:38",
					["Cost"] = 664,
				},
				["Sentinel Hill, Westfall"] = {
					["Duration"] = "1:37",
					["Cost"] = 99,
				},
				["Booty Bay, Stranglethorn"] = {
					["Duration"] = "2:53",
					["Cost"] = 567,
				},
				["Lakeshire, Redridge"] = {
					["Duration"] = "1:01",
					["Cost"] = 189,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "1:30",
					["Cost"] = 264,
				},
			},
			["Lakeshire, Redridge"] = {
				["Darkshire, Duskwood"] = {
					["Duration"] = "1:01",
					["Cost"] = 297,
				},
				["Sentinel Hill, Westfall"] = {
					["Duration"] = "2:14",
					["Cost"] = 99,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "1:54",
					["Cost"] = 189,
				},
			},
			["Nethergarde Keep, Blasted Lands"] = {
				["Darkshire, Duskwood"] = {
					["Duration"] = "1:34",
					["Cost"] = 297,
				},
				["Morgan's Vigil, Burning Steppes"] = {
					["Duration"] = "3:56",
					["Cost"] = 747,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "3:02",
					["Cost"] = 747,
				},
			},
			["Refuge Pointe, Arathi"] = {
				["Thelsamar, Loch Modan"] = {
					["Duration"] = "2:51",
					["Cost"] = 99,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "4:29",
					["Cost"] = 424,
				},
				["Aerie Peak, The Hinterlands"] = {
					["Duration"] = "1:13",
					["Cost"] = 584,
				},
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:21",
					["Cost"] = 297,
				},
				["Menethil Harbor, Wetlands"] = {
					["Duration"] = "2:06",
					["Cost"] = 297,
				},
			},
		},
	},
}

------------------------------
end

--
if ( GetLocale() == "frFR" ) then
Default_EFM_Data_Horde = {
	["HordeVersion"] = 1.0,
	["Horde"] = {
		[1] = {
			["Retraite de Roche-Soleil, Serres-Rocheuses"] = {
				["y"] = 0.527386,
				["x"] = 0.407957,
				["zone"] = "Retraite de Roche-Soleil, Serres-Rocheuses",
				["mapx"] = 45.2,
				["mapy"] = 59.86,
				["routes"] = {
					[1] = "La Croisée, Tarides",
					[2] = "Proie-de-l'Ombre, Désolace",
					[3] = "Thunder Bluff, Mulgore",
				},
			},
			["Mur-de-Fougères, marécage d'Âprefange"] = {
				["routes"] = {
					[1] = "Gadgetzan, Tanaris",
					[2] = "La Croisée, Tarides",
					[3] = "Orgrimmar, Durotar",
					[4] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.567468,
				["zone"] = "Mur-de-Fougères, marécage d'Âprefange",
				["mapx"] = 35.55,
				["mapy"] = 31.83,
				["y"] = 0.358365,
			},
			["Gadgetzan, Tanaris"] = {
				["y"] = 0.198074,
				["x"] = 0.606013,
				["zone"] = "Gadgetzan, Tanaris",
				["mapx"] = 51.6,
				["mapy"] = 25.51,
				["routes"] = {
					[1] = "La Croisée, Tarides",
					[2] = "Mur-de-Fougères, marécage d'Âprefange",
					[3] = "Orgrimmar, Durotar",
					[4] = "Poste de Librevent, Mille Pointes",
					[5] = "Thunder Bluff, Mulgore",
				},
			},
			["La Croisée, Tarides"] = {
				["y"] = 0.469523,
				["x"] = 0.557357,
				["zone"] = "La Croisée, Tarides",
				["mapx"] = 51.51,
				["mapy"] = 30.32,
				["routes"] = {
					[1] = "Avant-poste de Zoram'gar, Ashenvale",
					[2] = "Camp Taurajo, les Tarides",
					[3] = "Gadgetzan, Tanaris",
					[4] = "Mur-de-Fougères, marécage d'Âprefange",
					[5] = "Orgrimmar, Durotar",
					[6] = "Poste de Bois-brisé, Ashenvale",
					[7] = "Poste de Librevent, Mille Pointes",
					[8] = "Retraite de Roche-Soleil, Serres-Rocheuses",
					[9] = "Thunder Bluff, Mulgore",
				},
			},
			["Poste de Bois-brisé, Ashenvale"] = {
				["routes"] = {
					[1] = "Avant-poste de Zoram'gar, Ashenvale",
					[2] = "La Croisée, Tarides",
					[3] = "Orgrimmar, Durotar",
				},
				["x"] = 0.554419,
				["zone"] = "Poste de Bois-brisé, Ashenvale",
				["y"] = 0.582267,
			},
			["Avant-poste de Zoram'gar, Ashenvale"] = {
				["routes"] = {
					[1] = "La Croisée, Tarides",
					[2] = "Poste de Bois-brisé, Ashenvale",
				},
				["x"] = 0.409738,
				["zone"] = "Avant-poste de Zoram'gar, Ashenvale",
				["y"] = 0.626323,
			},
			["Poste de Librevent, Mille Pointes"] = {
				["routes"] = {
					[1] = "Camp Taurajo, les Tarides",
					[2] = "Gadgetzan, Tanaris",
					[3] = "La Croisée, Tarides",
					[4] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.549889,
				["zone"] = "Poste de Librevent, Mille Pointes",
				["mapx"] = 45.11,
				["mapy"] = 49.13,
				["y"] = 0.265501,
			},
			["Proie-de-l'Ombre, Désolace"] = {
				["y"] = 0.415052,
				["x"] = 0.316603,
				["zone"] = "Proie-de-l'Ombre, Désolace",
				["mapx"] = 21.56,
				["mapy"] = 74.04000000000001,
				["routes"] = {
					[1] = "Retraite de Roche-Soleil, Serres-Rocheuses",
					[2] = "Thunder Bluff, Mulgore",
				},
			},
			["Thunder Bluff, Mulgore"] = {
				["y"] = 0.438488,
				["x"] = 0.449478,
				["zone"] = "Thunder Bluff, Mulgore",
				["mapx"] = 47,
				["mapy"] = 49.89,
				["routes"] = {
					[1] = "Camp Taurajo, les Tarides",
					[2] = "Gadgetzan, Tanaris",
					[3] = "La Croisée, Tarides",
					[4] = "Mur-de-Fougères, marécage d'Âprefange",
					[5] = "Orgrimmar, Durotar",
					[6] = "Poste de Librevent, Mille Pointes",
					[7] = "Proie-de-l'Ombre, Désolace",
					[8] = "Retraite de Roche-Soleil, Serres-Rocheuses",
				},
			},
			["Orgrimmar, Durotar"] = {
				["routes"] = {
					[1] = "Gadgetzan, Tanaris",
					[2] = "La Croisée, Tarides",
					[3] = "Mur-de-Fougères, marécage d'Âprefange",
					[4] = "Poste de Bois-brisé, Ashenvale",
					[5] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.628008,
				["zone"] = "Orgrimmar, Durotar",
				["y"] = 0.556598,
				["mapy"] = 63.87,
				["mapx"] = 45.35,
			},
			["Camp Taurajo, les Tarides"] = {
				["routes"] = {
					[1] = "La Croisée, Tarides",
					[2] = "Poste de Librevent, Mille Pointes",
					[3] = "Thunder Bluff, Mulgore",
				},
				["x"] = 0.528047,
				["zone"] = "Camp Taurajo, les Tarides",
				["mapx"] = 44.46,
				["mapy"] = 59.1,
				["y"] = 0.389866,
			},
		},
		[2] = {
			["Sépulcre, Pins argentés"] = {
				["routes"] = {
					[1] = "Undercity, Tirisfal",
				},
				["x"] = 0.384475,
				["zone"] = "Sépulcre, Pins argentés",
				["y"] = 0.7550980000000001,
			},
			["Grom'gol, Strangleronce"] = {
				["y"] = 0.163592,
				["x"] = 0.448259,
				["zone"] = "Grom'gol, Strangleronce",
				["mapx"] = 32.51,
				["mapy"] = 29.33,
				["routes"] = {
					[1] = "Baie-du-Butin, Strangleronce",
					[2] = "Stonard, marais des Chagrins",
				},
			},
			["Undercity, Tirisfal"] = {
				["routes"] = {
					[1] = "Moulin-de-Tarren, Hillsbrad",
					[2] = "Sépulcre, Pins argentés",
					[3] = "Trépas-d'Orgrim, Arathi",
				},
				["x"] = 0.442677,
				["zone"] = "Undercity, Tirisfal",
				["mapx"] = 63.44,
				["mapy"] = 48.75,
				["y"] = 0.805093,
			},
			["Baie-du-Butin, Strangleronce"] = {
				["routes"] = {
					[1] = "Grom'gol, Strangleronce",
				},
				["x"] = 0.431591,
				["zone"] = "Baie-du-Butin, Strangleronce",
				["mapx"] = 26.86,
				["mapy"] = 77.06,
				["y"] = 0.07045510000000001,
			},
			["Moulin-de-Tarren, Hillsbrad"] = {
				["routes"] = {
					[1] = "Trépas-d'Orgrim, Arathi",
					[2] = "Undercity, Tirisfal",
				},
				["x"] = 0.494422,
				["zone"] = "Moulin-de-Tarren, Hillsbrad",
				["y"] = 0.7331260000000001,
				["mapy"] = 18.68,
				["mapx"] = 60.09,
			},
			["Stonard, marais des Chagrins"] = {
				["y"] = 0.253385,
				["x"] = 0.605416,
				["zone"] = "Stonard, marais des Chagrins",
				["routes"] = {
				},
			},
			["Trépas-d'Orgrim, Arathi"] = {
				["y"] = 0.691091,
				["x"] = 0.615401,
				["zone"] = "Trépas-d'Orgrim, Arathi",
				["routes"] = {
					[1] = "Moulin-de-Tarren, Hillsbrad",
					[2] = "Undercity, Tirisfal",
				},
				["mapy"] = 32.7,
				["mapx"] = 73.03,
			},
		},
	},
}

-- Alliance Data - contains user-submitted data.
Default_EFM_Data_Alliance = {
	["AllianceVersion"] = 1.0,
	["Alliance"] = {
		[1] = {
			["Clairière de Griffebranche, Gangrebois"] = {
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
					[2] = "Halte de Talrendis, Azshara",
					[3] = "Long-guet, Berceau-de-l'Hiver",
				},
				["x"] = 0.530809,
				["zone"] = "Clairière de Griffebranche, Gangrebois",
				["mapx"] = 62.47,
				["mapy"] = 24.16,
				["y"] = 0.742692,
			},
			["Rut'theran, Teldrassil"] = {
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
				},
				["x"] = 0.416144,
				["zone"] = "Rut'theran, Teldrassil",
				["y"] = 0.842793,
				["mapy"] = 93.92,
				["mapx"] = 58.39,
			},
			["Havrenuit, Reflet-de-Lune"] = {
				["routes"] = {
					[1] = "Rut'theran, Teldrassil",
				},
				["x"] = 0.549444,
				["zone"] = "Havrenuit, Reflet-de-Lune",
				["y"] = 0.807872,
				["mapy"] = 45.2,
				["mapx"] = 44.26,
			},
			["Gadgetzan, Tanaris"] = {
				["routes"] = {
					[1] = "Repos des vaillants, Silithus",
					[2] = "Thalanaar, Feralas",
					[3] = "Theramore, marécage d'Âprefange",
				},
				["x"] = 0.604133,
				["zone"] = "Gadgetzan, Tanaris",
				["y"] = 0.19088,
				["mapy"] = 29.27,
				["mapx"] = 50.99,
			},
			["Pic des Serres-Rocheuses, Serres-Rocheuses"] = {
				["routes"] = {
				},
				["x"] = 0.390646,
				["zone"] = "Pic des Serres-Rocheuses, Serres-Rocheuses",
				["y"] = 0.597828,
			},
			["Combe de Nijel, Désolace"] = {
				["y"] = 0.493395,
				["x"] = 0.396228,
				["zone"] = "Combe de Nijel, Désolace",
				["mapx"] = 64.67,
				["mapy"] = 10.43,
				["routes"] = {
					[1] = "Feathermoon, Feralas",
					[2] = "Auberdine, Sombrivage",
					[3] = "Theramore, marécage d'Âprefange",
				},
			},
			["Feathermoon, Feralas"] = {
				["y"] = 0.307979,
				["x"] = 0.313531,
				["zone"] = "Feathermoon, Feralas",
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
					[2] = "Combe de Nijel, Désolace",
					[3] = "Thalanaar, Feralas",
				},
				["mapy"] = 43.29,
				["mapx"] = 30.24,
			},
			["Thalanaar, Feralas"] = {
				["y"] = 0.303127,
				["x"] = 0.482576,
				["zone"] = "Thalanaar, Feralas",
				["mapx"] = 89.45999999999999,
				["mapy"] = 45.86,
				["routes"] = {
					[1] = "Feathermoon, Feralas",
					[2] = "Gadgetzan, Tanaris",
					[3] = "Theramore, marécage d'Âprefange",
				},
			},
			["Astranaar, Ashenvale"] = {
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
				},
				["x"] = 0.462582,
				["zone"] = "Astranaar, Ashenvale",
				["y"] = 0.603835,
				["mapy"] = 48.01,
				["mapx"] = 34.45,
			},
			["Halte de Talrendis, Azshara"] = {
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
					[2] = "Clairière de Griffebranche, Gangrebois",
				},
				["x"] = 0.6104770000000001,
				["zone"] = "Halte de Talrendis, Azshara",
				["y"] = 0.599073,
				["mapy"] = 77.62000000000001,
				["mapx"] = 11.89,
			},
			["Auberdine, Sombrivage"] = {
				["y"] = 0.748208,
				["x"] = 0.427786,
				["zone"] = "Auberdine, Sombrivage",
				["mapx"] = 36.36,
				["mapy"] = 45.61,
				["routes"] = {
					[1] = "Astranaar, Ashenvale",
					[2] = "Clairière de Griffebranche, Gangrebois",
					[3] = "Combe de Nijel, Désolace",
					[4] = "Feathermoon, Feralas",
					[5] = "Halte de Talrendis, Azshara",
					[6] = "Pic des Serres-Rocheuses, Serres-Rocheuses",
					[7] = "Reflet-de-Lune",
					[8] = "Rut'theran, Teldrassil",
					[9] = "Theramore, marécage d'Âprefange",
				},
			},
			["Reflet-de-Lune"] = {
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
					[2] = "Long-guet, Berceau-de-l'Hiver",
				},
				["x"] = 0.552823,
				["zone"] = "Reflet-de-Lune",
				["y"] = 0.793992,
				["mapy"] = 67.18000000000001,
				["mapx"] = 48.09,
			},
			["Long-guet, Berceau-de-l'Hiver"] = {
				["routes"] = {
					[1] = "Clairière de Griffebranche, Gangrebois",
					[2] = "Reflet-de-Lune",
				},
				["x"] = 0.64554,
				["zone"] = "Long-guet, Berceau-de-l'Hiver",
				["y"] = 0.767019,
				["mapy"] = 36.66,
				["mapx"] = 62.32,
			},
			["Theramore, marécage d'Âprefange"] = {
				["routes"] = {
					[1] = "Auberdine, Sombrivage",
					[2] = "Combe de Nijel, Désolace",
					[3] = "Gadgetzan, Tanaris",
					[4] = "Thalanaar, Feralas",
				},
				["x"] = 0.636261,
				["zone"] = "Theramore, marécage d'Âprefange",
				["y"] = 0.330511,
				["mapy"] = 51.36,
				["mapx"] = 67.53,
			},
			["Repos des vaillants, Silithus"] = {
				["routes"] = {
					[1] = "Gadgetzan, Tanaris",
				},
				["x"] = 0.463876,
				["zone"] = "Repos des vaillants, Silithus",
				["y"] = 0.223823,
			},
		},
		[2] = {
			["Southshore, Hillsbrad"] = {
				["y"] = 0.700487,
				["x"] = 0.47862,
				["zone"] = "Southshore, Hillsbrad",
				["routes"] = {
					[1] = "Camp du Noroît, Maleterres de l'ouest",
					[2] = "Ironforge, Dun Morogh",
					[3] = "Nid-de-l'Aigle, Les Hinterlands",
					[4] = "Port de Menethil, les Paluns",
					[5] = "Refuge de l'Ornière, Arathi",
				},
				["mapy"] = 52.1,
				["mapx"] = 49.44,
			},
			["Rempart-du-Néant, Terres foudroyées"] = {
				["routes"] = {
					[1] = "Darkshire, bois de la Pénombre",
					[2] = "Stormwind, Elwynn",
					[3] = "Veille de Morgan, Steppes ardentes",
				},
				["x"] = 0.612595,
				["zone"] = "Rempart-du-Néant, Terres foudroyées",
				["mapx"] = 65.49,
				["mapy"] = 24.42,
				["y"] = 0.223322,
			},
			["Halte du Thorium, Gorge des Vents brûlants"] = {
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Veille de Morgan, Steppes ardentes",
				},
				["x"] = 0.5085690000000001,
				["zone"] = "Halte du Thorium, Gorge des Vents brûlants",
				["y"] = 0.43251,
				["mapy"] = 30.76,
				["mapx"] = 37.88,
			},
			["Lakeshire, les Carmines"] = {
				["routes"] = {
					[1] = "Colline des sentinelles, marche de l'Ouest",
					[2] = "Darkshire, bois de la Pénombre",
					[3] = "Stormwind, Elwynn",
				},
				["x"] = 0.557343,
				["zone"] = "Lakeshire, les Carmines",
				["mapx"] = 30.6,
				["mapy"] = 59.26,
				["y"] = 0.300541,
			},
			["Chapelle de l'Espoir de Lumière, Maleterres de l'est"] = {
				["y"] = 0.837321,
				["x"] = 0.699995,
				["zone"] = "Chapelle de l'Espoir de Lumière, Maleterres de l'est",
				["mapx"] = 81.54000000000001,
				["mapy"] = 59.22,
				["routes"] = {
					[1] = "Nid-de-l'Aigle, Les Hinterlands",
				},
			},
			["Darkshire, bois de la Pénombre"] = {
				["y"] = 0.250701,
				["x"] = 0.512853,
				["zone"] = "Darkshire, bois de la Pénombre",
				["routes"] = {
					[1] = "Baie-du-Butin, Strangleronce",
					[2] = "Colline des sentinelles, marche de l'Ouest",
					[3] = "Lakeshire, les Carmines",
					[4] = "Rempart-du-Néant, Terres foudroyées",
					[5] = "Stormwind, Elwynn",
				},
				["mapy"] = 44.37,
				["mapx"] = 77.59,
			},
			["Veille de Morgan, Steppes ardentes"] = {
				["routes"] = {
					[1] = "Halte du Thorium, Gorge des Vents brûlants",
					[2] = "Rempart-du-Néant, Terres foudroyées",
				},
				["x"] = 0.580601,
				["mapx"] = 84.38,
				["zone"] = "Veille de Morgan, Steppes ardentes",
				["mapy"] = 68.37000000000001,
				["y"] = 0.349378,
			},
			["Port de Menethil, les Paluns"] = {
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Refuge de l'Ornière, Arathi",
					[3] = "Southshore, Hillsbrad",
					[4] = "Thelsamar, Loch Modan",
				},
				["x"] = 0.490907,
				["mapx"] = 9.52,
				["y"] = 0.559148,
				["mapy"] = 59.65,
				["zone"] = "Port de Menethil, les Paluns",
			},
			["Baie-du-Butin, Strangleronce"] = {
				["y"] = 0.06913569999999999,
				["x"] = 0.433677,
				["zone"] = "Baie-du-Butin, Strangleronce",
				["routes"] = {
					[1] = "Colline des sentinelles, marche de l'Ouest",
					[2] = "Darkshire, bois de la Pénombre",
					[3] = "Stormwind, Elwynn",
				},
				["mapy"] = 77.67,
				["mapx"] = 27.52,
			},
			["Thelsamar, Loch Modan"] = {
				["y"] = 0.484383,
				["x"] = 0.5893929999999999,
				["zone"] = "Thelsamar, Loch Modan",
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Port de Menethil, les Paluns",
					[3] = "Refuge de l'Ornière, Arathi",
				},
				["mapy"] = 50.81,
				["mapx"] = 34.03,
			},
			["Ironforge, Dun Morogh"] = {
				["y"] = 0.511915,
				["x"] = 0.50798,
				["zone"] = "Ironforge, Dun Morogh",
				["mapx"] = 55.77,
				["mapy"] = 48.08,
				["routes"] = {
					[1] = "Halte du Thorium, Gorge des Vents brûlants",
					[2] = "Nid-de-l'Aigle, Les Hinterlands",
					[3] = "Port de Menethil, les Paluns",
					[4] = "Refuge de l'Ornière, Arathi",
					[5] = "Southshore, Hillsbrad",
					[6] = "Stormwind, Elwynn",
					[7] = "Thelsamar, Loch Modan",
				},
			},
			["Colline des sentinelles, marche de l'Ouest"] = {
				["y"] = 0.245498,
				["x"] = 0.40741,
				["zone"] = "Colline des sentinelles, marche de l'Ouest",
				["routes"] = {
					[1] = "Baie-du-Butin, Strangleronce",
					[2] = "Stormwind, Elwynn",
					[3] = "Lakeshire, les Carmines",
					[4] = "Darkshire, bois de la Pénombre",
				},
				["mapy"] = 52.66,
				["mapx"] = 56.57,
			},
			["Nid-de-l'Aigle, Les Hinterlands"] = {
				["y"] = 0.746146,
				["x"] = 0.546853,
				["zone"] = "Nid-de-l'Aigle, Les Hinterlands",
				["routes"] = {
					[1] = "Chapelle de l'Espoir de Lumière, Maleterres de l'est",
					[2] = "Ironforge, Dun Morogh",
					[3] = "Refuge de l'Ornière, Arathi",
					[4] = "Southshore, Hillsbrad",
				},
				["mapy"] = 46.08,
				["mapx"] = 11.11,
			},
			["Stormwind, Elwynn"] = {
				["routes"] = {
					[1] = "Baie-du-Butin, Strangleronce",
					[2] = "Colline des sentinelles, marche de l'Ouest",
					[3] = "Darkshire, bois de la Pénombre",
					[4] = "Ironforge, Dun Morogh",
					[5] = "Lakeshire, les Carmines",
					[6] = "Rempart-du-Néant, Terres foudroyées",
				},
				["x"] = 0.432504,
				["zone"] = "Stormwind, Elwynn",
				["y"] = 0.327542,
				["mapy"] = 62.26,
				["mapx"] = 66.53,
			},
			["Camp du Noroît, Maleterres de l'ouest"] = {
				["routes"] = {
					[1] = "Southshore, Hillsbrad",
				},
				["x"] = 0.520581,
				["zone"] = "Camp du Noroît, Maleterres de l'ouest",
				["y"] = 0.775855,
				["mapy"] = 85.11,
				["mapx"] = 43.01,
			},
			["Refuge de l'Ornière, Arathi"] = {
				["y"] = 0.676216,
				["x"] = 0.570359,
				["zone"] = "Refuge de l'Ornière, Arathi",
				["routes"] = {
					[1] = "Ironforge, Dun Morogh",
					[2] = "Nid-de-l'Aigle, Les Hinterlands",
					[3] = "Port de Menethil, les Paluns",
					[4] = "Southshore, Hillsbrad",
					[5] = "Thelsamar, Loch Modan",
				},
				["mapy"] = 46,
				["mapx"] = 45.75,
			},
		},
	},
}

-- There are the only two flight paths, so this should never need to be changed.
Default_EFM_Data_Druid = {
	["DruidVersion"] = 0,
	["Alliance"] = {
		[1] = {},
	},
	["Horde"] = {
		[1] = {},
	},
}

-- Map Translation Data - Horde
Default_EFM_Data_HordeMapTranslation = {
	["HordeMapTranslationVersion"] = 1.0,
	["Horde"] = {
		[1] = {
			["Retraite de Roche-Soleil, Serres-Rocheuses"] = 10,
			["Mur-de-Fougères, marécage d'Âprefange"] = 12,
			["Gadgetzan, Tanaris"] = 19,
			["La Croisée, Tarides"] = 11,
			["Orgrimmar, Durotar"] = 15,
			["Proie-de-l'Ombre, Désolace"] = 7,
			["Thunder Bluff, Mulgore"] = 21,
			["Camp Taurajo, les Tarides"] = 11,
			["Poste de Librevent, Mille Pointes"] = 13,
		},
		[2] = {
			["Baie-du-Butin, Strangleronce"] = 25,
			["Grom'gol, Strangleronce"] = 25,
			["Moulin-de-Tarren, Hillsbrad"] = 4,
			["Undercity, Tirisfal"] = 24,
			["Trépas-d'Orgrim, Arathi"] = 10,
		},
	},
}

-- Map Translation Data - Alliance
Default_EFM_Data_AllianceMapTranslation = {
	["AllianceMapTranslationVersion"] = 1.0,
	["Alliance"] = {
		[1] = {
			["Clairière de Griffebranche, Gangrebois"] = 9,
			["Rut'theran, Teldrassil"] = 20,
			["Havrenuit, Reflet-de-Lune"] = 16,
			["Gadgetzan, Tanaris"] = 19,
			["Auberdine, Sombrivage"] = 18,
			["Feathermoon, Feralas"] = 8,
			["Astranaar, Ashenvale"] = 1,
			["Halte de Talrendis, Azshara"] = 2,
			["Theramore, marécage d'Âprefange"] = 12,
			["Reflet-de-Lune"] = 16,
			["Long-guet, Berceau-de-l'Hiver"] = 3,
			["Thalanaar, Feralas"] = 8,
			["Combe de Nijel, Désolace"] = 7,
		},
		[2] = {
			["Southshore, Hillsbrad"] = 4,
			["Rempart-du-Néant, Terres foudroyées"] = 22,
			["Halte du Thorium, Gorge des Vents brûlants"] = 9,
			["Thelsamar, Loch Modan"] = 15,
			["Chapelle de l'Espoir de Lumière, Maleterres de l'est"] = 16,
			["Stormwind, Elwynn"] = 2,
			["Veille de Morgan, Steppes ardentes"] = 21,
			["Port de Menethil, les Paluns"] = 14,
			["Baie-du-Butin, Strangleronce"] = 25,
			["Refuge de l'Ornière, Arathi"] = 10,
			["Ironforge, Dun Morogh"] = 11,
			["Lakeshire, les Carmines"] = 12,
			["Nid-de-l'Aigle, Les Hinterlands"] = 13,
			["Colline des sentinelles, marche de l'Ouest"] = 19,
			["Camp du Noroît, Maleterres de l'ouest"] = 17,
			["Darkshire, bois de la Pénombre"] = 1,
		},
	},
}

-- Flight Path Data - Horde
Default_EFM_Data_HordeFlightPath = {
	["HordeFlightPathVersion"] = 1.0,
	["Horde"] = {
		[1] = {
			["Orgrimmar, Durotar"] = {
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "3:47",
					["Cost"] = 45,
				},
				["Mur-de-Fougères, marécage d'Âprefange"] = {
					["Duration"] = "3:50",
					["Cost"] = 567,
				},
			},
			["Camp Taurajo, les Tarides"] = {
				["La Croisée, Tarides"] = {
					["Duration"] = "1:25",
					["Cost"] = 99,
				},
			},
			["Mur-de-Fougères, marécage d'Âprefange"] = {
				["Orgrimmar, Durotar"] = {
					["Duration"] = "3:48",
					["Cost"] = 567,
				},
				["Gadgetzan, Tanaris"] = {
					["Cost"] = 657,
				},
				["Thunder Bluff, Mulgore"] = {
					["Cost"] = 567,
				},
				["La Croisée, Tarides"] = {
					["Duration"] = "2:44",
					["Cost"] = 567,
				},
			},
			["Gadgetzan, Tanaris"] = {
				["Mur-de-Fougères, marécage d'Âprefange"] = {
					["Duration"] = "3:42",
					["Cost"] = 567,
				},
			},
			["La Croisée, Tarides"] = {
				["Retraite de Roche-Soleil, Serres-Rocheuses"] = {
					["Cost"] = 189,
				},
				["Mur-de-Fougères, marécage d'Âprefange"] = {
					["Duration"] = "2:44",
					["Cost"] = 567,
				},
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "5:10",
					["Cost"] = 657,
				},
				["Orgrimmar, Durotar"] = {
					["Duration"] = "2:15",
					["Cost"] = 99,
				},
				["Avant-poste de Zoram'gar, Ashenvale"] = {
					["Cost"] = 297,
				},
				["Thunder Bluff, Mulgore"] = {
					["Duration"] = "2:54",
					["Cost"] = 99,
				},
				["Poste de Librevent, Mille Pointes"] = {
					["Cost"] = 387,
				},
				["Camp Taurajo, les Tarides"] = {
					["Cost"] = 99,
				},
			},
			["Thunder Bluff, Mulgore"] = {
				["Retraite de Roche-Soleil, Serres-Rocheuses"] = {
					["Cost"] = 189,
				},
				["Mur-de-Fougères, marécage d'Âprefange"] = {
					["Duration"] = "4:00",
					["Cost"] = 567,
				},
				["Gadgetzan, Tanaris"] = {
					["Cost"] = 657,
				},
				["La Croisée, Tarides"] = {
					["Duration"] = "2:37",
					["Cost"] = 99,
				},
				["Orgrimmar, Durotar"] = {
					["Duration"] = "3:28",
					["Cost"] = 45,
				},
				["Proie-de-l'Ombre, Désolace"] = {
					["Duration"] = "2:40",
					["Cost"] = 477,
				},
				["Poste de Librevent, Mille Pointes"] = {
					["Duration"] = "3:25",
					["Cost"] = 387,
				},
				["Camp Taurajo, les Tarides"] = {
					["Cost"] = 99,
				},
			},
			["Poste de Librevent, Mille Pointes"] = {
				["Gadgetzan, Tanaris"] = {
					["Cost"] = 657,
				},
				["Thunder Bluff, Mulgore"] = {
					["Cost"] = 387,
				},
				["La Croisée, Tarides"] = {
					["Cost"] = 387,
				},
				["Camp Taurajo, les Tarides"] = {
					["Duration"] = "2:15",
					["Cost"] = 387,
				},
			},
		},
		[2] = {
			["Baie-du-Butin, Strangleronce"] = {
				["Grom'gol, Strangleronce"] = {
					["Duration"] = "1:42",
					["Cost"] = 567,
				},
			},
			["Grom'gol, Strangleronce"] = {
				["Baie-du-Butin, Strangleronce"] = {
					["Duration"] = "1:23",
					["Cost"] = 567,
				},
				["Stonard, marais des Chagrins"] = {
					["Duration"] = "3:08",
					["Cost"] = 567,
				},
			},
			["Moulin-de-Tarren, Hillsbrad"] = {
				["Trépas-d'Orgrim, Arathi"] = {
					["Duration"] = "1:55",
					["Cost"] = 477,
				},
				["Undercity, Tirisfal"] = {
					["Duration"] = "2:15",
					["Cost"] = 297,
				},
			},
			["Trépas-d'Orgrim, Arathi"] = {
				["Moulin-de-Tarren, Hillsbrad"] = {
					["Duration"] = "1:57",
					["Cost"] = 297,
				},
				["Undercity, Tirisfal"] = {
					["Duration"] = "4:16",
					["Cost"] = 477,
				},
			},
			["Undercity, Tirisfal"] = {
				["Sépulcre, Pins argentés"] = {
					["Cost"] = 99,
				},
				["Moulin-de-Tarren, Hillsbrad"] = {
					["Duration"] = "2:21",
					["Cost"] = 297,
				},
				["Trépas-d'Orgrim, Arathi"] = {
					["Duration"] = "5:02",
					["Cost"] = 477,
				},
			},
		},
	},
}

-- Flight Path Data - Alliance
Default_EFM_Data_AllianceFlightPath= {
	["AllianceFlightPathVersion"] = 1.0,
	["Alliance"] = {
		[1] = {
			["Clairière de Griffebranche, Gangrebois"] = {
				["Long-guet, Berceau-de-l'Hiver"] = {
					["Cost"] = 918,
				},
				["Halte de Talrendis, Azshara"] = {
					["Duration"] = "4:45",
					["Cost"] = 657,
				},
				["Auberdine, Sombrivage"] = {
					["Cost"] = 657,
				},
			},
			["Rut'theran, Teldrassil"] = {
				["Auberdine, Sombrivage"] = {
					["Duration"] = "1:29",
					["Cost"] = 0,
				},
			},
			["Havrenuit, Reflet-de-Lune"] = {
				["Rut'theran, Teldrassil"] = {
					["Duration"] = "2:33",
					["Cost"] = 0,
				},
			},
			["Gadgetzan, Tanaris"] = {
				["Theramore, marécage d'Âprefange"] = {
					["Duration"] = "2:37",
					["Cost"] = 567,
				},
				["Repos des vaillants, Silithus"] = {
					["Duration"] = "2:35",
					["Cost"] = 918,
				},
			},
			["Auberdine, Sombrivage"] = {
				["Clairière de Griffebranche, Gangrebois"] = {
					["Duration"] = "3:08",
					["Cost"] = 620,
				},
				["Rut'theran, Teldrassil"] = {
					["Duration"] = "1:25",
					["Cost"] = 0,
				},
				["Combe de Nijel, Désolace"] = {
					["Duration"] = "4:45",
					["Cost"] = 477,
				},
				["Pic des Serres-Rocheuses, Serres-Rocheuses"] = {
					["Cost"] = 297,
				},
				["Astranaar, Ashenvale"] = {
					["Duration"] = "3:00",
					["Cost"] = 297,
				},
				["Halte de Talrendis, Azshara"] = {
					["Duration"] = "5:04",
					["Cost"] = 657,
				},
				["Reflet-de-Lune"] = {
					["Duration"] = "2:28",
					["Cost"] = 747,
				},
				["Theramore, marécage d'Âprefange"] = {
					["Cost"] = 567,
				},
				["Feathermoon, Feralas"] = {
					["Duration"] = "7:55",
					["Cost"] = 657,
				},
			},
			["Feathermoon, Feralas"] = {
				["Thalanaar, Feralas"] = {
					["Cost"] = 387,
				},
				["Combe de Nijel, Désolace"] = {
					["Cost"] = 657,
				},
				["Auberdine, Sombrivage"] = {
					["Cost"] = 657,
				},
			},
			["Reflet-de-Lune"] = {
				["Long-guet, Berceau-de-l'Hiver"] = {
					["Duration"] = "2:13",
					["Cost"] = 918,
				},
				["Auberdine, Sombrivage"] = {
					["Duration"] = "2:26",
					["Cost"] = 706,
				},
			},
			["Astranaar, Ashenvale"] = {
				["Auberdine, Sombrivage"] = {
					["Cost"] = 297,
				},
			},
			["Halte de Talrendis, Azshara"] = {
				["Clairière de Griffebranche, Gangrebois"] = {
					["Cost"] = 657,
				},
				["Auberdine, Sombrivage"] = {
					["Duration"] = "5:05",
					["Cost"] = 657,
				},
			},
			["Theramore, marécage d'Âprefange"] = {
				["Gadgetzan, Tanaris"] = {
					["Duration"] = "2:37",
					["Cost"] = 694,
				},
				["Auberdine, Sombrivage"] = {
					["Cost"] = 630,
				},
				["Thalanaar, Feralas"] = {
					["Duration"] = "2:42",
					["Cost"] = 408,
				},
				["Combe de Nijel, Désolace"] = {
					["Duration"] = "5:35",
					["Cost"] = 504,
				},
			},
			["Nid-de-l'Aigle, Les Hinterlands"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:08",
				},
			},
			["Long-guet, Berceau-de-l'Hiver"] = {
				["Reflet-de-Lune"] = {
					["Duration"] = "2:13",
					["Cost"] = 747,
				},
				["Clairière de Griffebranche, Gangrebois"] = {
					["Duration"] = "2:03",
					["Cost"] = 657,
				},
			},
			["Thalanaar, Feralas"] = {
				["Theramore, marécage d'Âprefange"] = {
					["Duration"] = "2:42",
					["Cost"] = 657,
				},
				["Feathermoon, Feralas"] = {
					["Cost"] = 567,
				},
			},
			["Combe de Nijel, Désolace"] = {
				["Auberdine, Sombrivage"] = {
					["Cost"] = 477,
				},
				["Theramore, marécage d'Âprefange"] = {
					["Cost"] = 477,
				},
				["Feathermoon, Feralas"] = {
					["Cost"] = 657,
				},
			},
		},
		[2] = {
			["Southshore, Hillsbrad"] = {
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "3:23",
					["Cost"] = 297,
				},
				["Nid-de-l'Aigle, Les Hinterlands"] = {
					["Duration"] = "1:12",
					["Cost"] = 620,
				},
				["Port de Menethil, les Paluns"] = {
					["Duration"] = "1:46",
					["Cost"] = 297,
				},
				["Camp du Noroît, Maleterres de l'ouest"] = {
					["Duration"] = "1:27",
					["Cost"] = 747,
				},
				["Refuge de l'Ornière, Arathi"] = {
					["Duration"] = "1:15",
					["Cost"] = 450,
				},
			},
			["Rempart-du-Néant, Terres foudroyées"] = {
				["Veille de Morgan, Steppes ardentes"] = {
					["Duration"] = "3:57",
					["Cost"] = 747,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "3:02",
					["Cost"] = 747,
				},
				["Darkshire, bois de la Pénombre"] = {
					["Duration"] = "1:33",
					["Cost"] = 297,
				},
			},
			["Halte du Thorium, Gorge des Vents brûlants"] = {
				["Veille de Morgan, Steppes ardentes"] = {
					["Duration"] = "1:43",
					["Cost"] = 747,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "1:31",
					["Cost"] = 747,
				},
			},
			["Thelsamar, Loch Modan"] = {
				["Port de Menethil, les Paluns"] = {
					["Duration"] = "2:32",
					["Cost"] = 297,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "1:57",
					["Cost"] = 99,
				},
				["Refuge de l'Ornière, Arathi"] = {
					["Duration"] = "2:44",
					["Cost"] = 477,
				},
			},
			["Chapelle de l'Espoir de Lumière, Maleterres de l'est"] = {
				["Nid-de-l'Aigle, Les Hinterlands"] = {
					["Duration"] = "2:54",
					["Cost"] = 657,
				},
			},
			["Stormwind, Elwynn"] = {
				["Baie-du-Butin, Strangleronce"] = {
					["Duration"] = "4:04",
					["Cost"] = 567,
				},
				["Rempart-du-Néant, Terres foudroyées"] = {
					["Duration"] = "2:54",
					["Cost"] = 747,
				},
				["Colline des sentinelles, marche de l'Ouest"] = {
					["Duration"] = "1:17",
					["Cost"] = 99,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "4:21",
					["Cost"] = 45,
				},
				["Lakeshire, les Carmines"] = {
					["Duration"] = "1:52",
					["Cost"] = 189,
				},
				["Darkshire, bois de la Pénombre"] = {
					["Duration"] = "1:57",
					["Cost"] = 297,
				},
			},
			["Veille de Morgan, Steppes ardentes"] = {
				["Rempart-du-Néant, Terres foudroyées"] = {
					["Duration"] = "4:10",
					["Cost"] = 747,
				},
				["Halte du Thorium, Gorge des Vents brûlants"] = {
					["Duration"] = "1:44",
					["Cost"] = 747,
				},
			},
			["Port de Menethil, les Paluns"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "2:10",
					["Cost"] = 280,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "1:30",
					["Cost"] = 297,
				},
				["Thelsamar, Loch Modan"] = {
					["Duration"] = "2:43",
					["Cost"] = 99,
				},
				["Refuge de l'Ornière, Arathi"] = {
					["Duration"] = "1:54",
					["Cost"] = 477,
				},
			},
			["Baie-du-Butin, Strangleronce"] = {
				["Stormwind, Elwynn"] = {
					["Duration"] = "3:42",
					["Cost"] = 567,
				},
				["Colline des sentinelles, marche de l'Ouest"] = {
					["Duration"] = "3:02",
					["Cost"] = 477,
				},
				["Darkshire, bois de la Pénombre"] = {
					["Duration"] = "2:55",
					["Cost"] = 297,
				},
			},
			["Refuge de l'Ornière, Arathi"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:21",
					["Cost"] = 280,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "4:39",
					["Cost"] = 450,
				},
				["Nid-de-l'Aigle, Les Hinterlands"] = {
					["Duration"] = "1:12",
					["Cost"] = 620,
				},
				["Thelsamar, Loch Modan"] = {
					["Duration"] = "2:52",
					["Cost"] = 94,
				},
				["Port de Menethil, les Paluns"] = {
					["Duration"] = "2:07",
					["Cost"] = 280,
				},
			},
			["Ironforge, Dun Morogh"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "4:25",
					["Cost"] = 280,
				},
				["Refuge de l'Ornière, Arathi"] = {
					["Duration"] = "4:17",
					["Cost"] = 450,
				},
				["Thelsamar, Loch Modan"] = {
					["Duration"] = "1:43",
					["Cost"] = 99,
				},
				["Port de Menethil, les Paluns"] = {
					["Duration"] = "2:09",
					["Cost"] = 280,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "3:35",
					["Cost"] = 42,
				},
				["Nid-de-l'Aigle, Les Hinterlands"] = {
					["Duration"] = "5:07",
					["Cost"] = 620,
				},
				["Halte du Thorium, Gorge des Vents brûlants"] = {
					["Duration"] = "1:29",
					["Cost"] = 706,
				},
			},
			["Lakeshire, les Carmines"] = {
				["Stormwind, Elwynn"] = {
					["Duration"] = "1:55",
					["Cost"] = 189,
				},
				["Colline des sentinelles, marche de l'Ouest"] = {
					["Duration"] = "2:15",
					["Cost"] = 99,
				},
				["Darkshire, bois de la Pénombre"] = {
					["Duration"] = "1:02",
					["Cost"] = 297,
				},
			},
			["Nid-de-l'Aigle, Les Hinterlands"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:07",
					["Cost"] = 314,
				},
				["Ironforge, Dun Morogh"] = {
					["Duration"] = "4:20",
					["Cost"] = 694,
				},
				["Chapelle de l'Espoir de Lumière, Maleterres de l'est"] = {
					["Duration"] = "2:53",
					["Cost"] = 1020,
				},
				["Refuge de l'Ornière, Arathi"] = {
					["Duration"] = "1:14",
					["Cost"] = 504,
				},
			},
			["Colline des sentinelles, marche de l'Ouest"] = {
				["Baie-du-Butin, Strangleronce"] = {
					["Duration"] = "3:06",
					["Cost"] = 567,
				},
				["Lakeshire, les Carmines"] = {
					["Duration"] = "2:11",
					["Cost"] = 189,
				},
				["Darkshire, bois de la Pénombre"] = {
					["Duration"] = "1:38",
					["Cost"] = 297,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "1:22",
					["Cost"] = 99,
				},
			},
			["Camp du Noroît, Maleterres de l'ouest"] = {
				["Southshore, Hillsbrad"] = {
					["Duration"] = "1:27",
					["Cost"] = 297,
				},
			},
			["Darkshire, bois de la Pénombre"] = {
				["Baie-du-Butin, Strangleronce"] = {
					["Duration"] = "2:53",
					["Cost"] = 567,
				},
				["Rempart-du-Néant, Terres foudroyées"] = {
					["Duration"] = "1:38",
					["Cost"] = 747,
				},
				["Colline des sentinelles, marche de l'Ouest"] = {
					["Duration"] = "1:37",
					["Cost"] = 99,
				},
				["Lakeshire, les Carmines"] = {
					["Duration"] = "1:01",
					["Cost"] = 189,
				},
				["Stormwind, Elwynn"] = {
					["Duration"] = "1:30",
					["Cost"] = 297,
				},
			},
		},
	},
}
end
--
--if ( GetLocale() == "deDE" ) then
--end
--
