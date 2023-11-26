function MapLibrary_AddPredefines()
   local t = MapLibrary_Predefines();
   for zone, translation in t do
      if ZoneIsCalibrated(zone) == false then
	 MapLibraryData.translation[zone] = translation;
      end
   end
end

function MapLibrary_Predefines()
   return {
      ["The Hinterlands"] = {
	 ["scale_y"] = 11.5673,
	 ["offset_x"] = -8.86929,
	 ["scale_x"] = 11.5651,
	 ["offset_y"] = -3.27278,
      },
      ["Arathi Highlands"] = {
	 ["scale_y"] = 12.3704,
	 ["offset_y"] = -4.16666,
	 ["scale_x"] = 12.3705,
	 ["offset_x"] = -9.29024,
      },
      ["Darkshore"] = {
	 ["scale_y"] = 6.79929,
	 ["offset_y"] = -1.43866,
	 ["scale_x"] = 6.79879,
	 ["offset_x"] = -0.887582,
      },
      ["Eastern Kingdoms"] = {
	 ["scale_y"] = 1.26524,
	 ["offset_x"] = -0.471017,
	 ["scale_x"] = 1.26523,
	 ["offset_y"] = -0.102304,
      },
      ["Desolace"] = {
	 ["scale_y"] = 9.90299,
	 ["offset_y"] = -4.7242,
	 ["scale_x"] = 9.90532,
	 ["offset_x"] = -1.00585,
      },
      ["Kalimdor"] = {
	 ["scale_y"] = 1.21015,
	 ["offset_y"] = -0.0739885,
	 ["scale_x"] = 1.21015,
	 ["offset_x"] = 0.225845,
      },
      ["Azshara"] = {
	 ["scale_y"] = 8.78067,
	 ["offset_x"] = -2.37283,
	 ["scale_x"] = 8.78195,
	 ["offset_y"] = -2.7427,
      },
      ["The Barrens"] = {
	 ["scale_y"] = 4.39429,
	 ["offset_y"] = -1.92453,
	 ["scale_x"] = 4.39486,
	 ["offset_x"] = -0.605226,
      },
      ["Darnassus"] = {
	 ["scale_y"] = 42.0685,
	 ["offset_y"] = -6.20182,
	 ["scale_x"] = 42.0787,
	 ["offset_x"] = -5.49656,
      },
      ["Ashenvale"] = {
	 ["scale_y"] = 7.72394,
	 ["offset_y"] = -2.58659,
	 ["scale_x"] = 7.72253,
	 ["offset_x"] = -1.2235,
      },
      ["Wetlands"] = {
	 ["scale_y"] = 10.7715,
	 ["offset_y"] = -4.35904,
	 ["scale_x"] = 10.768,
	 ["offset_x"] = -7.97134,
      },
      ["Hillsbrad Foothills"] = {
	 ["scale_y"] = 13.9166,
	 ["offset_x"] = -9.84718,
	 ["scale_x"] = 13.9166,
	 ["offset_y"] = -4.43749,
      },
      ["Feralas"] = {
	 ["scale_y"] = 6.40787,
	 ["offset_y"] = -3.66524,
	 ["scale_x"] = 6.40772,
	 ["offset_x"] = -0.476824,
      },
      ["Teldrassil"] = {
	 ["scale_y"] = 8.74811,
	 ["offset_y"] = -0.820292,
	 ["scale_x"] = 8.7463,
	 ["offset_x"] = -0.970401,
      },
      ["Stonetalon Mountains"] = {
	 ["scale_y"] = 9.11757,
	 ["offset_y"] = -3.59264,
	 ["scale_x"] = 9.1195,
	 ["offset_x"] = -1.12828,
      },
   }
end
