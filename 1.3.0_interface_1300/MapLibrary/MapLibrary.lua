-- Usage:
-- Use this to get coordinates of units with minimal
-- interference with other addons. It will only change map zoom when
-- absolutely necessary.

-- Use MapLibrary.Ready to detect if MapLibrary is ready for usage
-- (Happens on VARIABLES_LOADED).

-- Functions:
-- MapLibrary.ZoneIsCalibrated - check if a zone has been calibrated
-- MapLibrary.GetMapZoneName - get the name of the zone that's currently on the map
-- MapLibrary.GetWorldPosition - get the position of a unit in world coordinates
-- MapLibrary.GetZonePosition - get the position of a unit in zone coordinates
-- MapLibrary.GetYardsPosition - get the position of a unit in yards.                     
-- MapLibrary.TranslateWorldToZone - translate coordinates
-- MapLibrary.TranslateZoneToWorld - translate coordinates
-- MapLibrary.TranslateWorldToYards - translate coordinates
-- MapLibrary.YardDistance - distance between two points in yards.
-- MapLibrary.UnitDistance - distance between two units
-- MapLibrary.InInstance - true if player is an instance, otherwise false

MapLibrary = { };

-- returns the name of the currently shown map zone
-- returns nil of the currently shown map zone is not a real zone.
local function MapLibrary_GetMapZoneName()
   local continent = GetCurrentMapContinent();
   local zone = GetCurrentMapZone();

   if continent == -1 then
      return nil;
   end

   local name = MapLibrary.zone_names[continent][zone];
   if MapLibrary.mappedzone[name] then
      return name;
   end

   return nil;
end

-- returns true if the zone is calibrated
-- returns false if the zone is not calibrated
-- returns nil if the zone can not be calibrated
local function MapLibrary_ZoneIsCalibrated(zone)

   if type(zone) ~= "string" then
      return nil;
   end

   if zone == "World" then
      return true;
   end

   local id = MapLibrary.mappedzone[zone];
   if not id then
      return nil;
   end

   if MapLibraryData.translation[zone].offset_x and
      MapLibraryData.translation[zone].offset_y then
      return true;
   else
      return false;
   end
end

-- translates from world coordinates to zone coordinates.
-- returns nil on failure (if the zone is not calibrated)
local function MapLibrary_TranslateWorldToZone(wx, wy, zone)
   if zone == "World" then
      return wx, wy;
   end
   if MapLibrary_ZoneIsCalibrated(zone) then
      local t = MapLibraryData.translation[zone];
      return t.offset_x + t.scale_x * wx, t.offset_y + t.scale_y * wy
   end
   return nil;
end

-- translates from zone coordinates to world coordinates.
-- returns nil on failure (if the zone is not calibrated)
local function MapLibrary_TranslateZoneToWorld(zx, zy, zone)
   if zone == "World" then
      return zx, zy;
   end
   if MapLibrary_ZoneIsCalibrated(zone) then
      local t = MapLibraryData.translation[zone];
      return (zx - t.offset_x) / t.scale_x, (zy - t.offset_y) / t.scale_y;
   end
   return nil;
end

-- returns x, y relative to the world map on success.
-- returns nil on failure
-- if unit is nil then "player" is assumed
-- if corpse is nil then GetPlayerMapPosition is assumed,
-- otherwise GetPlayerCorpsePosition is used.
-- if nice is nil, then GetWorldPosition will actively try to
-- change map zoom to find the position!
local function MapLibrary_GetWorldPosition(unit, corpse, nice)
   local func = GetPlayerMapPosition;
   if corpse then
      func = GetCorpseMapPosition;
   end

   local zone = MapLibrary_GetMapZoneName();
   if zone == nil then
      return nil;
   end

   if unit == nil then
      unit = "player";
   end

   -- First try to use the current zone.
   if MapLibrary_ZoneIsCalibrated(zone) then
      local x, y = func(unit);
      if x ~= 0 or y ~= 0 then
	 return MapLibrary_TranslateZoneToWorld(x, y, zone);
      end
   end

   if nice ~= nil then
      return nil;
   end

   -- That failed. Zoom to current zone instead
   zone = GetRealZoneText();
   if MapLibrary_ZoneIsCalibrated(zone) then
      local id = MapLibrary.mappedzone[zone];
      SetMapZoom(id.continent, id.zone);
      local x, y = func(unit);
      if x ~= 0 then
	 return MapLibrary_TranslateZoneToWorld(x, y, zone);
      end
   end

   -- Sometimes your position won't be on the map of the zone you're in!
   -- (Between badlands and searing gorge)
   SetMapZoom(0, 0);
   local x, y = func(unit);
   if x ~= 0 then
      return x, y;
   end
   
   return nil;
end

-- returns x, y relative to the zone map on success.
-- see GetWorldPosition for details
local function MapLibrary_GetZonePosition(zone, unit, corpse, nice)
   if MapLibrary_ZoneIsCalibrated(zone) then
      local x, y = MapLibrary_GetWorldPosition(unit, corpse, nice);
      return MapLibrary_TranslateWorldToZone(x, y, zone);
   end
   return nil;
end

-- returns x, y that are scaled properly but is not relative to anything.
-- see GetWorldPosition for details
local function MapLibrary_GetYardsPosition(zone, unit, corpse, nice)
   if MapLibrary_ZoneIsCalibrated(zone) then
      local x, y = MapLibrary_GetWorldPosition(unit, corpse, nice);
      return MapLibrary_TranslateWorldToYards(x, y);
   end
   return nil;
end

-- translates from world coordinates to yards.
local function MapLibrary_TranslateWorldToYards(wx, wy)
   return wx * MapLibrary.yard_factor_x, wy * MapLibrary.yard_factor_y; 
end

-- The parameters should be in world coordinates!
local function MapLibrary_YardDistance(x1, y1, x2, y2)
   local dx = (x1 - x2) * MapLibrary.yard_factor_x;
   local dy = (y1 - y2) * MapLibrary.yard_factor_y;
   return math.sqrt(dx * dx + dy * dy);
end

-- units can be "player", "party1", et.c.
-- set nice to 1 to avoid doing SetMapZoom
-- returns nil on failure
-- returns the distance in yards on success.
local function MapLibrary_UnitDistance(unit1, unit2, nice)
   local x1, y1 = MapLibrary_GetWorldPosition(unit1, nil, nice);
   local x2, y2 = MapLibrary_GetWorldPosition(unit2, nil, nice);
   if x1 == nil or x2 == nil then
      return nil;
   end
   return MapLibrary_YardDistance(x1, y1, x2, y2);
end

local function MapLibrary_Msg(s)
   if(DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage("MapLibrary: " .. s);
   end
end

local function MapLibrary_CalculateCurrentTranslation(zone)
   local b = MapLibrary_ZoneIsCalibrated(zone);
   if b == nil or b == true then
      return;
   end

   local id = MapLibrary.mappedzone[zone];

   local old_continent, old_zone = GetCurrentMapContinent(), GetCurrentMapZone();

   -- Get map coordinates
   SetMapZoom(0, 0);
   local wx, wy = GetPlayerMapPosition("player");
   if wx == 0 and wy == 0 then
      SetMapZoom(old_continent, old_zone);
      return;
   end

   SetMapZoom(id.continent, id.zone);

   local zx, zy = GetPlayerMapPosition("player");
   if zx == 0 and zy == 0 then
      SetMapZoom(old_continent, old_zone);
      return;
   end

   -- Calibrate x and y separately, for more efficiency.

   -- If this is the first calibration run of this zone:
   if MapLibraryData.translation[zone].min_wx == nil then
      MapLibraryData.translation[zone].min_wx = wx;
      MapLibraryData.translation[zone].min_zx = zx;

      MapLibraryData.translation[zone].max_wx = wx;
      MapLibraryData.translation[zone].max_zx = zx;
   end

   if MapLibraryData.translation[zone].min_wy == nil then
      MapLibraryData.translation[zone].min_wy = wy;
      MapLibraryData.translation[zone].min_zy = zy;

      MapLibraryData.translation[zone].max_wy = wy;
      MapLibraryData.translation[zone].max_zy = zy;
   end

   -- Update min and max values
   if wx < MapLibraryData.translation[zone].min_wx then
      MapLibraryData.translation[zone].min_wx = wx;
      MapLibraryData.translation[zone].min_zx = zx;
   end
   if wx > MapLibraryData.translation[zone].max_wx then
      MapLibraryData.translation[zone].max_wx = wx;
      MapLibraryData.translation[zone].max_zx = zx;
   end
   if wy < MapLibraryData.translation[zone].min_wy then
      MapLibraryData.translation[zone].min_wy = wy;
      MapLibraryData.translation[zone].min_zy = zy;
   end
   if wy > MapLibraryData.translation[zone].max_wy then
      MapLibraryData.translation[zone].max_wy = wy;
      MapLibraryData.translation[zone].max_zy = zy;
   end

   -- Check if the distance is enough for calibration:
   local dx = MapLibraryData.translation[zone].max_wx - MapLibraryData.translation[zone].min_wx;
   local dy = MapLibraryData.translation[zone].max_wy - MapLibraryData.translation[zone].min_wy;

   if dx * MapLibrary.yard_factor_x > 5 then
      local min_wx = MapLibraryData.translation[zone].min_wx;
      local max_wx = MapLibraryData.translation[zone].max_wx;

      local min_zx = MapLibraryData.translation[zone].min_zx;
      local max_zx = MapLibraryData.translation[zone].max_zx;

      local scale_x = (max_zx - min_zx) / (max_wx - min_wx);
      MapLibraryData.translation[zone].scale_x = scale_x;
      MapLibraryData.translation[zone].offset_x = max_zx - scale_x * max_wx;
   end

   if dy * MapLibrary.yard_factor_y > 5 then
      local min_wy = MapLibraryData.translation[zone].min_wy;
      local max_wy = MapLibraryData.translation[zone].max_wy;

      local min_zy = MapLibraryData.translation[zone].min_zy;
      local max_zy = MapLibraryData.translation[zone].max_zy;

      local scale_y = (max_zy - min_zy) / (max_wy - min_wy);
      MapLibraryData.translation[zone].scale_y = scale_y;
      MapLibraryData.translation[zone].offset_y = max_zy - scale_y * max_wy;
   end

   if dx * MapLibrary.yard_factor_x > 5 and
      dy * MapLibrary.yard_factor_y > 5 then

      -- Don't need to calibrate anymore, so remove temporary data
      MapLibraryData.translation[zone].min_wx = nil;
      MapLibraryData.translation[zone].min_wy = nil;
      MapLibraryData.translation[zone].max_wx = nil;
      MapLibraryData.translation[zone].max_wy = nil;

      MapLibraryData.translation[zone].min_zx = nil;
      MapLibraryData.translation[zone].min_zy = nil;
      MapLibraryData.translation[zone].max_zx = nil;
      MapLibraryData.translation[zone].max_zy = nil;

      MapLibrary_Msg("Calibrated " .. zone);
   end
   SetMapZoom(old_continent, old_zone);
end

local function MapLibrary_InInstance()
   local zone = GetRealZoneText();
   if MapLibrary_ZoneIsCalibrated(zone) == nil then
      return true;
   end
   return false;
end

MapLibrary = { };

function MapLibrary_OnLoad()
   -- This is for setting up persistent variable
   this:RegisterEvent("VARIABLES_LOADED");

   -- This is for calibrating zones
   this:RegisterEvent("PLAYER_ENTERING_WORLD");
   this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end

local MapLibrary_Predefines;

function MapLibrary_OnEvent()
   if event == "VARIABLES_LOADED" then


      MapLibrary.continent_names = { GetMapContinents(); }
      MapLibrary.zone_names = { };

      MapLibrary.mappedzone = { };
      MapLibrary.mappedzone["World"] = {["continent"] = 0, ["zone"] = 0};

      MapLibrary.zone_names[0] = {[0] = "World";}

      for i, cont_name in MapLibrary.continent_names do
	 MapLibrary.zone_names[i] = { GetMapZones(i) };
	 MapLibrary.zone_names[i][0] = cont_name;
	 
	 MapLibrary.mappedzone[cont_name] = {["continent"] = i, ["zone"] = 0};
	 for index, name in MapLibrary.zone_names[i] do
	    MapLibrary.mappedzone[name] = {["continent"] = i, ["zone"] = index};
	 end
      end

      -- These values are not perfect (but close enough)
      MapLibrary.yard_factor_x = 4.1394e+04;
      MapLibrary.yard_factor_y = 2.7563e+04;

      MapLibrary.ZoneIsCalibrated = MapLibrary_ZoneIsCalibrated;
      MapLibrary.TranslateWorldToZone = MapLibrary_TranslateWorldToZone;
      MapLibrary.TranslateZoneToWorld = MapLibrary_TranslateZoneToWorld;
      MapLibrary.GetWorldPosition = MapLibrary_GetWorldPosition;
      MapLibrary.GetZonePosition = MapLibrary_GetZonePosition;
      MapLibrary.GetMapZoneName = MapLibrary_GetMapZoneName;
      MapLibrary.GetYardsPosition = MapLibrary_GetYardsPosition;
      MapLibrary.TranslateWorldToYards = MapLibrary_TranslateWorldToYards;
      MapLibrary.YardDistance = MapLibrary_YardDistance;
      MapLibrary.UnitDistance = MapLibrary_UnitDistance;

      MapLibrary.InInstance = MapLibrary_InInstance;
      if not MapLibraryData then
	 MapLibraryData = { };
      end

      if not MapLibraryData.translation then
	 MapLibraryData.translation = { };
      end

      for zone, tmp in MapLibrary.mappedzone do
	 if not MapLibraryData.translation[zone] then
	    MapLibraryData.translation[zone] = { };
	 end
      end

      for zone, translation in MapLibrary_Predefines do
	 if MapLibrary_ZoneIsCalibrated(zone) == false then
	    MapLibraryData.translation[zone] = translation;
	 end
      end

      MapLibrary.Ready = 1;

   elseif event == "PLAYER_ENTERING_WORLD" or
      event == "ZONE_CHANGED_NEW_AREA" then
      
      if MapLibrary_ZoneIsCalibrated(GetRealZoneText()) == false then
	 MapLibrary_Updater:Show();
      end
   end
end

local MapLibrary_LastUpdate = 0;

function MapLibrary_OnUpdate()
   -- don't do it too often!
   local time = GetTime();
   if time - MapLibrary_LastUpdate > 3 then
      MapLibrary_LastUpdate = time;
   else
      return;
   end

   local zone = GetRealZoneText();
   local continent = nil;

   local b = MapLibrary_ZoneIsCalibrated(zone);
   if b == nil then
      MapLibrary_Updater:Hide();
   else
      continent = MapLibrary.continent_names[MapLibrary.mappedzone[zone].continent];
      local c = MapLibrary_ZoneIsCalibrated(continent);

      if (b == true) and (c == true) then
	 MapLibrary_Updater:Hide();
      else
	 if b == false then
	    MapLibrary_CalculateCurrentTranslation(zone);
	 end
	 if c == false then
	    MapLibrary_CalculateCurrentTranslation(continent);
	 end
      end
   end
end

MapLibrary_Predefines = {
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
};
