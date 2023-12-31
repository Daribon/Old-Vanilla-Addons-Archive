KC_ET_Buyables = {

  -- alchemy
  ["3371"] = 1,  -- Empty Vial
  ["3372"] = 1,  -- Leaded Vial
  ["8925"] = 1,  -- Crystal Vial
 
  -- tailoring (and leatherworking)
  ["2320"] = 1,  -- Coarse Thread
  ["2321"] = 1,  -- Fine Thread
  ["4291"] = 1,  -- Silken Thread
  ["8343"] = 1,  -- Heavy Silken Thread
  ["14341"] = 1, -- Rune Thread

  ["2324"] = 1,  -- Bleach
  ["2325"] = 1,  -- Black Dye
  ["6260"] = 1,  -- Blue Dye
  ["2605"] = 1,  -- Green Dye
  ["4342"] = 1,  -- Purple Dye
  ["2604"] = 1,  -- Red Dye
  ["4341"] = 1,  -- Yellow Dye
  ["4340"] = 1,  -- Gray Dye
  ["6261"] = 1,  -- Orange Dye
  ["10290"] = 1, -- Pink Dye

  ["4289"] = 1,  -- Salt

  -- mining
  ["3857"] = 1, -- Coal

  -- enchanting
  ["6217"] = 1,  -- Copper Rod

--  ["10940"] = 1, -- Strange Dust
--  ["10938"] = 1, -- Lesser Magic Essence

  ["4470"] = 1,  -- Simple Wood
  ["11291"] = 1, -- Star Wood

  -- poison
  ["2928"] = 1,  -- Dust of Decay
  ["3777"] = 1,  -- Lethargy Root
  ["2930"] = 1,  -- Essence of Pain
  ["8923"] = 1,  -- Essence of Agony
  ["5173"] = 1,  -- Deathweed
  ["8924"] = 1,  -- Dust of Deterioration

  -- cooking
  ["2692"] = 1,  -- Hot Spices
  ["2678"] = 1,  -- Mild Spices
  ["3713"] = 1,  -- Soothing Spices
  ["2665"] = 1,  -- Stormwind Seasoning Herbs

  ["159"] = 1,    -- Refreshing Spring Water
  ["1179"] = 1,  -- Ice Cold Milk
  ["2596"] = 1,  -- Skin of Dwarven Stout
  ["2894"] = 1,  -- Rhapsody Malt
  ["4536"] = 1,  -- Shiny Red Apple

  -- blacksmithing (and engineering)
  ["3466"] = 1,  -- Strong Flux
  ["2880"] = 1,  -- Weak Flux

  -- engineering (some items included above)
  ["4400"] = 1,  -- Heavy Stock
  ["4399"] = 1,  -- Wooden Stock

  ["10647"] = 1,  -- Engineer's Ink
  ["10648"] = 1, -- Blank Parchment

  ["6530"] = 1,  -- Nightcrawlers
 };

--[[  Essense ID list
10938 -- Lesser Magic Essence
10939 -- Greater Magic Essence
10998 -- Lesser Astral Essence
11082 -- Greater Astral Essence
11134 -- Lesser Mystic Essence
11135 -- Greater Mystic Essence
11174 -- Lesser Nether Essence
11175 -- Greater Nether Essence
16202 -- Lesser Eternal Essence
16203 -- Greater Eternal Essence
--]] 

-- put in the id for a greater and get the Key for a lesser
KC_ET_lEssence = {
  ["3:0:10939"] = "3:0:10938",
  ["3:0:11082"] = "3:0:10998",
  ["3:0:11135"] = "3:0:11134",
  ["3:0:11175"] = "3:0:11174",
  ["3:0:16203"] = "3:0:16202",
};

-- put in the id for a lesser and get the id for a greater
KC_ET_gEssence = {
  ["3:0:10938"] = "3:0:10939",
  ["3:0:10998"] = "3:0:11082",
  ["3:0:11134"] = "3:0:11135",
  ["3:0:11174"] = "3:0:11175",
  ["3:0:16202"] = "3:0:16203",
};