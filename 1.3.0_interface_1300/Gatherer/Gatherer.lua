-- Gatherer
-- Written by Chandora
GATHERER_VERSION="2.0-p5";
-- Revision: $Id: Gatherer.lua,v 1.7 2005/05/04 17:36:07 islorgris Exp $
--
-- Look, seriously a full half of this code is from MapNotes.
-- The only reason I pinched it and put it in here is I couldn't
-- work out how to extend MapNotes to do what I wanted it to do
-- without actually editing the NapNotes files.
-- 
-- Full credit to the MapNotes guys!
-- 
-- Added by Jet:
--    * localization for french version (Gatherer_FindOreType, Gatherer_FindTreasureType and Gatherer_ReadBuff modified).
--      localized text Variables are in the localization.lua file (added for load in Gatherer.xml), french and english (default).
--      Gather_IconSet modified to use variables, added Wildvine herb type (iconic style icon is from MapNotesGathering Addon 
--        and treasure types (including giant clam) in GatherIcons.lua
--    * GatherConfig current values displayed on load (Gatherer_OnEvent) and
--      on /gather (Gatherer_Command) (added useMinimapTexT to GatherConfig to translate useMinimap).
--    * crude filtering of displayed notes (added filter to GatherConfig), 
--      /gather filter command added in Gatherer_Command and filter check in Gatherer_OnUpdate.
--    * added Clam and Cask type to check in Gatherer_FindTreasureType
--    * zone names at the end of GatherRegionData
--
-- Added by Lokibar:
--    * localization for german version (Gatherer_FindOreType, Gatherer_FindTreasureType and Gatherer_ReadBuff modified).
--      localized text Variables are in the localization.lua file (added for load in Gatherer.xml).

GATHERNOTE_UPDATE_INTERVAL = 0.25;
GATHERNOTE_CHECK_INTERVAL = 5.0;
GATHERER_MAXNUMNOTES = 25;
GATHERER_LOADED = false;

GatherItems = { };
GatherConfig = { useMinimap = true, maxDist = 0, number = 10, useMinimapText = "on", iconSet = "shaded", miniIconDist = 40, filter="all" };
GatherZoneData = { };

function Gatherer_OnLoad()
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("WORLD_MAP_UPDATE");
	this:RegisterEvent("CLOSE_WORLD_MAP");

	-- event added for impossible to gather item
	this:RegisterEvent("UI_ERROR_MESSAGE");

	Gatherer_LoadContinents(GetMapContinents());

	SLASH_GATHER1 = "/gather";
	SLASH_GATHER2 = "/gatherer";
	SlashCmdList["GATHER"] = function(msg)
		Gatherer_Command(msg);
	end

end

function Gatherer_Command(command)
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$");
	if (not cmd) then cmd = command; end
	if (not cmd) then cmd = ""; end
	if (not param) then param = ""; end

	if ((cmd == "") or (cmd == "help")) then
		local useMinimap = "Off";
		if (GatherConfig.useMinimap) then useMinimap = "On"; end
		local useMainmap = "Off";
		if (GatherConfig.useMainmap) then useMainmap = "On"; end
		local mapMinder = "Off";
		if (GatherConfig.mapMinder) then mapMinder = "On"; end
		local minderTime = "5s";
		if (GatherConfig.minderTime) then minderTime = GatherConfig.minderTime.."s"; end
		
		Gatherer_ChatPrint("Usage:");
		Gatherer_ChatPrint("  |cffffffff/gather (on|off|toggle)|r |cff2040ff["..useMinimap.."]|r - turns the gather minimap display on and off");
		Gatherer_ChatPrint("  |cffffffff/gather mainmap (on|off|toggle)|r |cff2040ff["..useMainmap.."]|r - turns the gather mainmap display on and off");
		Gatherer_ChatPrint("  |cffffffff/gather minder (on|off|toggle|<n>)|r |cff2040ff["..mapMinder.."]|r - turns the gather map minder on and off (remembers and reopens your last open main map; within "..minderTime..")");
		Gatherer_ChatPrint("  |cffffffff/gather dist <n>|r |cff2040ff["..GatherConfig.maxDist.."]|r - sets the maximum search distance for display (0=infinite(default), typical=10)");
		Gatherer_ChatPrint("  |cffffffff/gather num <n>|r |cff2040ff["..GatherConfig.number.."]|r - sets the maximum number of items to display (default=10, up to 25)");
		Gatherer_ChatPrint("  |cffffffff/gather fdist <n>|r |cff2040ff["..GatherConfig.fadeDist.."]|r - sets a fade distance (in units) for the icons to fade out by (default = 20)");
		Gatherer_ChatPrint("  |cffffffff/gather fperc <n>|r |cff2040ff["..GatherConfig.fadePerc.."]|r - sets the percentage for fade at max fade distance (default = 80 [=80% faded])");
		Gatherer_ChatPrint("  |cffffffff/gather theme <name>|r |cff2040ff["..GatherConfig.iconSet.."]|r - sets the icon theme: original, shaded (default), or iconic");
		Gatherer_ChatPrint("  |cffffffff/gather idist <n>|r |cff2040ff["..GatherConfig.miniIconDist.."]|r - sets the minimap distance at which the gather icon will become iconic (0 = off, 1-60 = pixel radius on minimap, default = 40)");
		Gatherer_ChatPrint("  |cffffffff/gather herbs (on|off|toggle|auto)|r |cff2040ff["..Gatherer_GetFilterVal("herbs").."]|r - select whether to show herb data on the minimap");
		Gatherer_ChatPrint("  |cffffffff/gather mining (on|off|toggle|auto)|r |cff2040ff["..Gatherer_GetFilterVal("mining").."]|r - select whether to show mining data on the minimap");
		Gatherer_ChatPrint("  |cffffffff/gather treasure (on|off|toggle|auto)|r |cff2040ff["..Gatherer_GetFilterVal("treasure").."]|r - select whether to show treasure data on the minimap");
		Gatherer_ChatPrint("  |cffffffff/gather options|r - show/hide UI Options dialog");
	elseif (cmd == "options" ) then
		if ( GathererUI_Options:IsVisible() ) then
			GathererUI_Options:Hide();
		else
			GathererUI_Options:Show();
		end
	elseif (cmd == "on") then
		GatherConfig.useMinimap = true;
		Gatherer_OnUpdate(0, true);
		GatherConfig.useMinimapText = "on";
		Gatherer_ChatPrint("Turned gather minimap display on");
	elseif (cmd == "off") then
		GatherConfig.useMinimap = false;
		GatherConfig.useMinimapText = "off";
		Gatherer_OnUpdate(0, true);
		Gatherer_ChatPrint("Turned gather minimap display off (still collecting)");
	elseif (cmd == "toggle") then
		GatherConfig.useMinimap = not GatherConfig.useMinimap;
		Gatherer_OnUpdate(0, true);
		if (GatherConfig.useMinimap) then
			Gatherer_ChatPrint("Turned gather minimap display on");
		        GatherConfig.useMinimapText = "on";
		else
			Gatherer_ChatPrint("Turned gather minimap display off (still collecting)");
		        GatherConfig.useMinimapText = "off";
		end
	elseif (cmd == "dist") then
		local i,j, value = string.find(param, "(%d+)");
		if (not value) then value = 0; else value = value + 0.0; end
		if (value <= 0) then
			GatherConfig.maxDist = 0;
		else
			GatherConfig.maxDist = value + 0.0;
		end
		Gatherer_ChatPrint("Setting maximum note distance to "..GatherConfig.maxDist);
		Gatherer_OnUpdate(0, true);
	elseif (cmd == "fdist") then
		local i,j, value = string.find(param, "(%d+)");
		if (not value) then value = 0; else value = value + 0.0; end
		if (value <= 0) then
			GatherConfig.fadeDist = 0;
		else
			GatherConfig.fadeDist = value + 0.0;
		end
		Gatherer_ChatPrint("Setting fade distance to "..GatherConfig.fadeDist);
		Gatherer_OnUpdate(0, true);
	elseif (cmd == "fperc") then
		local i,j, value = string.find(param, "(%d+)");
		if (not value) then value = 0; else value = value + 0.0; end
		if (value <= 0) then
			GatherConfig.fadePerc = 0;
		else
			GatherConfig.fadePerc = value + 0.0;
		end
		Gatherer_ChatPrint("Setting fade percent at fade distance to "..GatherConfig.fadePerc);
		Gatherer_OnUpdate(0, true);
	elseif ((cmd == "idist") or (cmd == "icondist")) then
		local i,j, value = string.find(param, "(%d+)");
		if (not value) then value = 0; else value = value + 0; end
		if (value <= 0) then
			GatherConfig.miniIconDist = 0;
		else
			GatherConfig.miniIconDist = value + 0;
		end
		Gatherer_ChatPrint("Setting iconic distance to "..GatherConfig.miniIconDist);
		Gatherer_OnUpdate(0, true);
	elseif (cmd == "theme") then
		if (Gather_IconSet[param]) then
			GatherConfig.iconSet = param;
			Gatherer_ChatPrint("Gatherer theme set to "..GatherConfig.iconSet);
		else
			Gatherer_ChatPrint("Unknown theme: "..param);
		end
		Gatherer_OnUpdate(0, true);
	elseif ((cmd == "num") or (cmd == "number")) then
		local i,j, value = string.find(param, "(%d+)");
		if (not value) then value = 0; else value = value + 0; end
		if (value < 0) then
			GatherConfig.number = 10;
		elseif (value <= GATHERER_MAXNUMNOTES) then
			GatherConfig.number = math.floor(value + 0);
		else
			GatherConfig.number = GATHERER_MAXNUMNOTES;
		end
		if (GatherConfig.number == 0) then
			GatherConfig.useMinimap = false;
		        GatherConfig.useMinimapText = "off";
			Gatherer_OnUpdate(0, true);
			Gatherer_ChatPrint("Turned gather minimap display off (still collecting)");
		else
			if ((GatherConfig.number > 0) and (GatherConfig.useMinimap == false)) then
				GatherConfig.useMinimap = true;
		        	GatherConfig.useMinimapText = "on";
				Gatherer_ChatPrint("Turned gather minimap display on");
			end
			Gatherer_ChatPrint("Displaying "..GatherConfig.number.." notes at once");
			Gatherer_OnUpdate(0, true);
		end
	elseif (cmd == "mainmap") then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			GatherConfig.useMainmap = false;
		elseif (param == "toggle") then
			GatherConfig.useMainmap = not GatherConfig.useMainmap;
		else
			GatherConfig.useMainmap = true;
		end
		if (GatherConfig.useMainmap) then
			Gatherer_ChatPrint("Displaying notes in main map");
		else
			Gatherer_ChatPrint("Not displaying notes in main map");
		end
	elseif (cmd == "minder") then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			GatherConfig.mapMinder = false;
		elseif (param == "toggle") then
			GatherConfig.mapMinder = not GatherConfig.mapMinder;
		elseif (param == "on") then
			GatherConfig.mapMinder = true;
		else
			local i,j, value = string.find(param, "(%d+)");
			if (not value) then value = 0; else value = value + 0; end
			if (value <= 0) then
				GatherConfig.mapMinder = false;
				GatherConfig.minderTime = 0;
			else
				GatherConfig.mapMinder = true;
				GatherConfig.minderTime = value + 0;
			end
			Gatherer_ChatPrint("Setting map minder timeout to "..GatherConfig.minderTime);
		end
		if (GatherConfig.mapMinder) then
			Gatherer_ChatPrint("Map minder activated at "..GatherConfig.minderTime);
		else
			Gatherer_ChatPrint("Not minding your map");
		end
	elseif ((cmd == "herbs") or (cmd == "mining") or (cmd == "treasure")) then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			Gatherer_SetFilter(cmd, "off");
			Gatherer_ChatPrint("Not displaying "..cmd.." notes in minimap");
		elseif (param == "on" or param == "On" ) then
				Gatherer_SetFilter(cmd, "on");
				Gatherer_ChatPrint("Displaying "..cmd.." notes in minimap");
		elseif (param == "toggle" or param == "") then
			local cur = Gatherer_GetFilterVal(cmd);
			if ((cur == "on") or (cur == "auto")) then
				cur = "off";
				Gatherer_SetFilter(cmd, "off");
				Gatherer_ChatPrint("Not displaying "..cmd.." notes in minimap");
			else
				cur = "on";
				Gatherer_SetFilter(cmd, "on");
				Gatherer_ChatPrint("Displaying "..cmd.." notes in minimap");
			end
		else
			Gatherer_SetFilter(cmd, "auto");
			Gatherer_ChatPrint("Displaying "..cmd.." notes in minimap based on ability");
		end
		Gatherer_OnUpdate(0, true);
		GatherMain_Draw();
	end
end

function Gatherer_SetFilter(type, value)
	if (not Gather_Player) then return; end
	if (not GatherConfig.users) then GatherConfig.users = {}; end
	if (not GatherConfig.users[Gather_Player]) then GatherConfig.users[Gather_Player] = {}; end
	if (not GatherConfig.users[Gather_Player].filters) then GatherConfig.users[Gather_Player].filters = {}; end

	GatherConfig.users[Gather_Player].filters[type] = value;
end

function Gatherer_GetFilterVal(type)
	if (not Gather_Player) then return "off"; end
	if (not GatherConfig.users) then GatherConfig.users = {}; end
	if (not GatherConfig.users[Gather_Player]) then GatherConfig.users[Gather_Player] = {}; end
	if (not GatherConfig.users[Gather_Player].filters) then GatherConfig.users[Gather_Player].filters = {}; end
	value = GatherConfig.users[Gather_Player].filters[type];
	if (not value) then return "auto"; end
	return value;
end

function Gatherer_GetFilter(filter)
	local value = Gatherer_GetFilterVal(filter);
	local filterVal = false;

	if (value == "on") then 
		filterVal = true;
	elseif (value == "off") then
		filterVal = false; 
	elseif (value == "auto") then
		if (filter == "treasure") then 
			filterVal = true; 
		end
		if (not GatherSkills) then 
			filterVal = true; 
		end
		if ((GatherSkills[filter]) and (GatherSkills[filter] > 0)) then 
			filterVal = true; 
		end
	end

	return filterVal;
end
	
function Gatherer_GetSkills()
   	GatherSkills = {};
	ExpandSkillHeader(0);
	for i=1, GetNumSkillLines(), 1 do
		local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType = GetSkillLineInfo(i);
		if (skillName) then
			if (skillName == TRADE_HERBALISM) then
				GatherSkills.herbs = skillRank;
			elseif (skillName == TRADE_MINING) then
				GatherSkills.mining = skillRank;
			end
		end
	end   
end

GatherMap_InCity = false;
Gatherer_LoadCount = 0;
Gatherer_MapOpen = false;
function Gatherer_OnEvent(event)
	if (strfind(event, "CHAT_MSG")) then
		Gatherer_ReadBuff(event);
	-- process event to record, normally not possible gather (low/inexistant skill)
	elseif (strfind(event, "UI_ERROR_MESSAGE")) then
		-- process gather error message
		-- need to be in standard gather range to get the correct message to process.
		local trade_herb_check
		if ( GetLocale() == "frFR" ) then 
			trade_herb_check = OLD_TRADE_HERBALISM 
		else
			trade_herb_check = TRADE_HERBALISM
		end
               
		if (arg1 and
		    (strfind(arg1, GATHERER_REQUIRE.." "..trade_herb_check) or strfind(arg1, GATHERER_NOSKILL.." "..trade_herb_check) or
		     strfind(arg1, GATHERER_REQUIRE.." "..TRADE_MINING) or strfind(arg1, GATHERER_NOSKILL.." "..TRADE_MINING))) then
			Gatherer_ReadBuff(event);
		end
	elseif (event == "MINIMAP_UPDATE_ZOOM") then
		GatherMap_InCity = isMinimapInCity();
	elseif (event == "WORLD_MAP_UPDATE") then
--		Gatherer_ChatPrint("Map update");
		if (WorldMapFrame:IsVisible()) then
--			Gatherer_ChatPrint("Map is visible");
			local serverTime = GetTime();
			if ((GatherConfig.mapMinder == true) and (Gatherer_MapOpen == false)) then 
--				Gatherer_ChatPrint("Opening map");
				-- Enhancement to open to last opened map if we were there less than a minute ago
				-- Otherwise, go to the player's current position
				local startContinent, startZone;
				if ((Gatherer_CloseMap ~= nil) and (serverTime - Gatherer_CloseMap.time < GatherConfig.minderTime)) then
					startContinent = Gatherer_CloseMap.continent;
					startZone = Gatherer_CloseMap.zone;
--					Gatherer_ChatPrint("Time delta was "..(serverTime - Gatherer_CloseMap.time).." on "..startContinent..":"..startZone);
				else
					if (Gatherer_CloseMap ~= nil) then
--						Gatherer_ChatPrint("Time delta expired: "..(serverTime - Gatherer_CloseMap.time));
					else
--						Gatherer_ChatPrint("Time delta unknown");
					end
					startContinent, startZone = Gatherer_GetCurrentZone();
				end

--				Gatherer_ChatPrint("Changing map to "..startContinent..":"..startZone);
				Gatherer_MapOpen = true;
				SetMapZoom(startContinent, startZone);
			end
			Gatherer_MapOpen = true;
			local mapContinent = GetCurrentMapContinent();
			local mapZone = GetCurrentMapZone();
--			Gatherer_ChatPrint("Setting last map to "..mapContinent..":"..mapZone);
			Gatherer_CloseMap = { continent = mapContinent, zone = mapZone, time = GetTime() };
			GatherMain_Draw();
		elseif (Gatherer_MapOpen) then
--			Gatherer_ChatPrint("Map is not visible but I thought it was open");
			Gatherer_MapOpen = false;
			GatherMain_Draw();
			Gatherer_ChangeMap();
		else
--			Gatherer_ChatPrint("Map is not visible and I think it is closed");
		end
	elseif ( event == "CLOSE_WORLD_MAP" ) then
		Gatherer_MapOpen = false;
		GatherMain_Draw();
		Gatherer_ChangeMap()
	elseif( event == "VARIABLES_LOADED" ) then
		Gatherer_LoadCount = Gatherer_LoadCount + 1;
		if (Gatherer_LoadCount == 10) then
			GATHERER_LOADED = true;
			Gatherer_OnUpdate(0, true);
			GatherMain_Draw();
			Gatherer_Print("Gatherer v"..GATHERER_VERSION.." -- Loaded!");
			if (GatherConfig.useMinimap == nil) then
				GatherConfig.useMinimap = true;
			end
			if (GatherConfig.useMainmap == nil) then
				GatherConfig.useMainmap = true;
			end
			if (not GatherConfig.iconSet) then
				GatherConfig.iconSet = "shaded";
			end
			if (not GatherConfig.number) then
				GatherConfig.number = 10;
			end
			if (not GatherConfig.maxDist) then
				GatherConfig.maxDist = 0;
			end
			if (not GatherConfig.fadeDist) then
				GatherConfig.fadeDist = 40;
			end
			if (not GatherConfig.fadePerc) then
				GatherConfig.fadePerc = 80;
			end
			if (not GatherConfig.miniIconDist) then
				GatherConfig.miniIconDist = 40;
			end
			if (GatherConfig.mapMinder == nil) then
				GatherConfig.mapMinder = true;
			end
			if (not GatherConfig.minderTime) then
				GatherConfig.minderTime = 5;
			end
			if (not GatherConfig.rareOre) then
				GatherConfig.rareOre = 0;
			end
			if (not GatherConfig.fixscale) then
				if ( GetLocale() == "frFR" ) then
					GatherConfig.fixscale = true;
					RecalcNotes();
				end
			end

			-- New backup format allows the user to permenantly save their data
			-- in an automatically restoring file "GatherBase.lua"
			-- All data in this file will be loaded "under" the saved data every
			-- time the addon loads so that in the event of a savedVariables wipe
			-- the next time they run WoW, their data will be back to the last
			-- backed up point. (This utility will appear in a later version of
			-- Gatherer as a Java applet)
			if (GatherItemBase ~= nil) then
				for c,cd in GatherItems do
					for z,zd in cd do
						for n,nd in zd do
							for i,id in nd do
								local matched = 0;
								local max = 0;
								for j,jd in GatherItemBase[c][z][n] do
									if (math.abs(id.x-jd.y) < 0.05) then
										matched = j;
									end
									max = j;
								end
								if (matched > 0) then
									GatherItemBase[c][z][n][matched] = id;
								else
									GatherItemBase[c][z][n][max+1] = id;
								end
							end
						end
					end
				end
				GatherItems = GatherItemBase;
			end
		end
	elseif (event == "UNIT_NAME_UPDATE") then
		if ((arg1) and (arg1 == "player")) then
			local playerName = UnitName("player");
			if ((playerName) and (playerName ~= UNKNOWNOBJECT)) then
				Gather_Player = playerName;
				Gatherer_GetSkills();

				local useMinimap = "Off";
				if (GatherConfig.useMinimap) then useMinimap = "On"; end
				local useMainmap = "Off";
				if (GatherConfig.useMainmap) then useMainmap = "On"; end
				local mapMinder = "Off";
				if (GatherConfig.mapMinder) then mapMinder = "On"; end

				local minderTime = "5s";
				if (GatherConfig.minderTime) then minderTime = GatherConfig.minderTime.."s"; end

				Gatherer_Print("[Player: "..Gather_Player..", Theme: "..GatherConfig.iconSet..", Mainmap: "..useMainmap..", Minimap: "..useMinimap..", MaxDist: "..GatherConfig.maxDist.." units, NoteCount: "..GatherConfig.number..", Fade: "..GatherConfig.fadePerc.."% at "..GatherConfig.fadeDist.." units, IconDist: "..GatherConfig.miniIconDist.."px on minimap, MapMinder: "..mapMinder.." ("..minderTime.."), Filters: herbs="..Gatherer_GetFilterVal("herbs")..", mining="..Gatherer_GetFilterVal("mining")..", treasure="..Gatherer_GetFilterVal("treasure").."]");
			end
		end
	end
end

function isMinimapInCity()
	local tempzoom = 0;
	local inCity = false;
	if (GetCVar("minimapZoom") == GetCVar("minimapInsideZoom")) then
		if (GetCVar("minimapInsideZoom")+0 >= 3) then 
			Minimap:SetZoom(Minimap:GetZoom() - 1);
			tempzoom = 1;
		else
			Minimap:SetZoom(Minimap:GetZoom() + 1);
			tempzoom = -1;
		end
	end
	if (GetCVar("minimapInsideZoom")+0 == Minimap:GetZoom()) then inCity = true; end
	Minimap:SetZoom(Minimap:GetZoom() + tempzoom);
	return inCity;
end

function Gatherer_TimeCheck(timeDelta)
	if (not GatherNotes) then
		GatherNotes = { timeDiff=0, checkDiff=0 };
	else
		GatherNotes.checkDiff = GatherNotes.checkDiff + timeDelta;
		if (GatherNotes.checkDiff > GATHERNOTE_CHECK_INTERVAL) then
			GatherNotes.checkDiff = 0;
			Gatherer_GetSkills();
			Gatherer_OnUpdate(0,true);
		end
	end
--	Gatherer_Print("Check test at "..GatherNotes.checkDiff);
end

function Gatherer_HideAll()
--	Gatherer_Print("Hiding all");
	local mmPos = 0;
	while (mmPos < GATHERER_MAXNUMNOTES) do
		mmPos = mmPos+1;
		local gatherNote = getglobal("GatherNote"..mmPos);
		gatherNote:Hide();
	end
end


function Gatherer_OnUpdate(timeDelta, force)
	if (not GATHERER_LOADED) then
		Gatherer_Print("Gatherer not loaded");
		return; 
	end
	
	if (not GatherConfig.useMinimap) then
		Gatherer_HideAll();
		return;
	end
	
	local recalculate = false;
	local needsUpdate = false;
	if (not GatherNotes) then
		GatherNotes = { timeDiff=0, checkDiff=0 };
		needsUpdate = true;
	else
		GatherNotes.timeDiff = GatherNotes.timeDiff + timeDelta;
		if (GatherNotes.timeDiff > GATHERNOTE_UPDATE_INTERVAL) then
			needsUpdate = true;
		end
	end
	if (force) then
		needsUpdate = true;
		recalculate = true;
	end

	if (needsUpdate) then
		if ((not WorldMapFrame:IsVisible()) and (Gatherer_MapOpen)) then
			Gatherer_OnEvent("WORLD_MAP_UPDATE");
		end

		GatherNotes.timeDiff = 0;
		-- Find the 10 closest gathers
		local continent, zone = Gatherer_GetCurrentZone();
		if ((continent == 0) or (zone == 0)) then
			Gatherer_HideAll();
			return;
		end

		local inCity = GatherMap_InCity;
		local zoomLevel = Minimap:GetZoom();
		local px, py = Gatherer_PlayerPos();
		if ((px == 0) and (py == 0)) then 
--			Gatherer_Print("Player is not on a visible map");
			return; 
		end
		local xMovement = 0; if (ClosestGathers) then xMovement = math.abs(ClosestGathers.px - px); end
		local yMovement = 0; if (ClosestGathers) then yMovement = math.abs(ClosestGathers.py - py); end
		if (not ClosestGathers) then recalculate = true;
		elseif (ClosestGathers.playerC ~= continent) then recalculate = true;
		elseif (ClosestGathers.playerZ ~= zone) then recalculate = true;
		elseif (xMovement+yMovement > 0.01) then recalculate = true;
		end

		local displayNumber = 10;
		if ((GatherConfig.number) and (GatherConfig.number > 0)) then
			displayNumber = GatherConfig.number;
		end

		local playerDeltaX = 0;
		local playerDeltaY = 0;
		if (recalculate == true) then
--			Gatherer_Print("Recalculating...");
			ClosestGathers = Gatherer_FindClosest(displayNumber, GatherConfig.interested);
			if (ClosestGathers.count > 0) then
				ClosestGathers.inCity = inCity;
				ClosestGathers.zoomLevel = zoomLevel;
				ClosestGathers.scaleX, ClosestGathers.scaleY = Gatherer_GetMapScale(continent, zone, inCity, zoomLevel);
			end
		else
			if ((inCity ~= ClosestGathers.inCity) or (zoomLevel ~= ClosestGathers.zoomLevel)) then
				ClosestGathers.inCity = inCity;
				ClosestGathers.zoomLevel = zoomLevel;
				ClosestGathers.scaleX, ClosestGathers.scaleY = Gatherer_GetMapScale(continent, zone, inCity, zoomLevel);
			end
			local absX, absY = Gatherer_AbsCoord(continent, zone, px, py);
			playerDeltaX = ClosestGathers.playerX - absX;
			playerDeltaY = ClosestGathers.playerY - absY;
--			Gatherer_Print("PlayerDelta "..playerDeltaX..","..playerDeltaY);
		end

		local maxPos = 0;
		if ((ClosestGathers) and (ClosestGathers.count > 0)) then
			local py;
			for closestPos, closestGather in ClosestGathers.items do
				-- need to position and label the corresponding button
				local gatherNote = getglobal("GatherNote"..closestPos);
				local gatherNoteTexture = getglobal("GatherNote"..closestPos.."Texture");

				local itemDeltaX = closestGather.deltax+playerDeltaX;
				local itemDeltaY = closestGather.deltay+playerDeltaY;
				local offsX, offsY, gDist = Gatherer_MiniMapPos(itemDeltaX, itemDeltaY, ClosestGathers.scaleX, ClosestGathers.scaleY);
--				Gatherer_Print("Got "..offsX..", "..offsY);
				gatherNote:SetPoint("CENTER", "MinimapCluster", "TOPLEFT", 107 + offsX, -92 - offsY);
				
				local iconSet = GatherConfig.iconSet;
				local iDist = GatherConfig.miniIconDist;
				if (not iconSet) then iconSet = "shaded"; end
				if (not iDist) then iDist = 40; end
				if ((iDist > 0) and (gDist > iDist)) then
					iconSet = "iconic";
				end
				local fadeDist = GatherConfig.fadeDist / 1000;
				local fadePerc = GatherConfig.fadePerc / 100;
				local alpha = 1.0;
				if ((fadeDist > 0) and (fadePerc > 0)) then
					local objDist = Gatherer_Pythag(itemDeltaX, itemDeltaY);
					local distRatio = objDist / fadeDist;
					alpha = 1.0 - (math.min(1.0, math.max(0.0, distRatio)) * fadePerc);
				end

				local textureType = closestGather.item.gtype;
				local textureIcon = closestGather.item.icon;

				if (not textureIcon) then textureIcon = "default"; end;
				if (not Gather_IconSet[iconSet]) then iconSet = "shaded"; end
				if (not Gather_IconSet[iconSet][textureType]) then textureType = "Default"; end
				local selectedTexture = Gather_IconSet[iconSet][textureType][textureIcon];
				if (not selectedTexture) then
					selectedTexture = Gather_IconSet[iconSet][textureType]["default"];
				end
				gatherNoteTexture:SetTexture(selectedTexture);
				gatherNote:SetFrameLevel(MiniMapTrackingFrame:GetFrameLevel()+1);
				gatherNote:SetAlpha(alpha);
				gatherNote:Show();
				-- Added to allow hiding if under min distance
				if ( GatherConfig.NoIconOnMinDist ~= nil and GatherConfig.NoIconOnMinDist == 1 ) then
					if ( iconSet == "shaded" and gDist < iDist ) then
						gatherNote:Hide();
					end
				end

				if (closestPos > maxPos) then maxPos = closestPos; end
			end
		end
		while (maxPos < GATHERER_MAXNUMNOTES) do
			maxPos = maxPos+1;
--			Gatherer_Print("Hiding gather item "..maxPos);
			local gatherNote = getglobal("GatherNote"..maxPos);
			gatherNote:Hide();
		end
	else
--		Gatherer_Print("Update not needed");
	end
end

function GatherMain_Draw()
	local lastUnused = 1000;
	local maxNotes = 1500;
	
	if ((Gatherer_MapOpen) and (GatherConfig.useMainmap)) then
		local mapContinent = GetCurrentMapContinent();
		local mapZone = GetCurrentMapZone();
		if ((mapContinent ~= 0) and (mapZone ~= 0) and (GatherItems[mapContinent]) and (GatherItems[mapContinent][mapZone])) then
			for gatherName, gatherData in GatherItems[mapContinent][mapZone] do
				local gatherType = "Default";
				local specificType = "";
				local allowed = true; 
				local minSetSkillLevel = 0;
				local idx_count=0;

				local userConfig = GatherConfig.users[Gather_Player];

				specificType = Gatherer_FindOreType(gatherName);
				if (specificType) then
					gatherType = "Ore";
					allowed = Gatherer_GetFilter("mining");
				else
					specificType = Gatherer_FindTreasureType(gatherName);
					if (specificType) then
						gatherType = "Treasure";
						allowed = Gatherer_GetFilter("treasure");
					else
						specificType = gatherName;
						gatherType = "Herb"; 
						allowed = Gatherer_GetFilter("herbs");
					end

				end
				if (not specificType) then
					specificType = "default";
				end

				-- extra filtering options
				if (userConfig) then
					if ( userConfig.interested and userConfig.interested[gatherType] ) then
						for interest_index in userConfig.interested[gatherType] do
							idx_count= idx_count +1;
						end
					end

					if( gatherType == "Ore" ) then
						minSetSkillLevel = userConfig.minSetOreSkill;
						if ( not minSetSkillLevel ) then minSetSkillLevel = -1; end
					elseif ( gatherType == "Herb" ) then
						minSetSkillLevel = userConfig.minSetHerbSkill;
						if ( not minSetSkillLevel ) then minSetSkillLevel = -1; end
					end

					if ( allowed == true and Gather_SkillLevel[specificType] and
						minSetSkillLevel > 0 and 
						(minSetSkillLevel > Gather_SkillLevel[specificType] or
						 (GatherConfig.rareOre == 1 and Gather_SkillLevel[Gather_RareMatch[specificType]] and
						  Gather_SkillLevel[specificType] < Gather_SkillLevel[Gather_RareMatch[specificType]] and
						  minSetSkillLevel > Gather_SkillLevel[Gather_RareMatch[specificType]] ))
					) then
						allowed = false;
					end
				end

				if ((allowed == true) and
					((userConfig == nil) or
					 (userConfig.interested == nil) or (idx_count == 0) or userConfig.interested[gatherType] == nil or
					 (userConfig.interested[gatherType][specificType] == true or 
					  (GatherConfig.rareOre == 1 and userConfig.interested[gatherType][Gather_RareMatch[specificType]])
					 )
					)
				) then
					for hPos, gatherInfo in gatherData do
						if ((gatherInfo.x) and (gatherInfo.y) and (gatherInfo.x>0) and (gatherInfo.y>0) and (lastUnused <= maxNotes)) then
							local mainNote = getglobal("GatherMain"..lastUnused);

							local mnX,mnY;
							mnX = gatherInfo.x / 100 * WorldMapDetailFrame:GetWidth();
							mnY = -gatherInfo.y / 100 * WorldMapDetailFrame:GetHeight();
							mainNote:SetAlpha(0.8);
							mainNote:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", mnX, mnY);
							mainNote:SetFrameLevel(WorldMapPlayer:GetFrameLevel() - 1);
							if ( Gatherer_TitleCase(specificType) == ORE_THORIUM ) then
								mainNote.toolTip = Gatherer_TitleCase(gatherName);
							else
								mainNote.toolTip = Gatherer_TitleCase(specificType);
							end

							if (not Gather_IconSet["iconic"][gatherType]) then 
								gatherType = "Default"; 
							end
							local texture = Gather_IconSet["iconic"][gatherType][specificType];
							if (not texture) then
								texture = Gather_IconSet["iconic"][gatherType]["default"];
							end

							local mainNoteTexture = getglobal("GatherMain"..lastUnused.."Texture");
							mainNoteTexture:SetTexture(texture);
							mainNote:Show();
							lastUnused = lastUnused + 1;
						end
					end
				end
			end
		end
	end
	for i=lastUnused, maxNotes, 1 do
		local mainNote = getglobal("GatherMain"..i);
		mainNote:Hide();
	end
end

function Gatherer_OnClick() -- function changed to be able to ping through the MiniNote (mostly direct copy) (only change: this -> Minimap)
	local x, y = GetCursorPosition();
	x = x / Minimap:GetScale();
	y = y / Minimap:GetScale();

	local cx, cy = Minimap:GetCenter();
	x = x + CURSOR_OFFSET_X - cx;
	y = y + CURSOR_OFFSET_Y - cy;
	if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
		Minimap:PingLocation(x, y);
	end
end

function Gatherer_MakeName(frameID)
	if (not GATHERER_LOADED) then return "Unknown", 0, 0; end
	local gatherInfo = ClosestGathers.items[frameID];
	local approxDist = math.floor(gatherInfo.dist*10000)/10;
	return Gatherer_TitleCase(gatherInfo.name), gatherInfo.item.count, approxDist;
end


function Gatherer_FindClosest(num, interested)
	local gatherLocal = {playerC=0,playerZ=0,playerX=0,playerY=0,px=0,py=0,items={},count=0};

	if (not GATHERER_LOADED) then return gatherLocal; end

	local continent, zone = Gatherer_GetCurrentZone();
	if ((continent == 0) or (zone == 0)) then return gatherLocal; end
	local px,py = Gatherer_PlayerPos();
	if ((px == 0) and (py == 0)) then return gatherLocal; end

	local absPx, absPy = Gatherer_AbsCoord(continent, zone, px, py);
	gatherLocal = { playerC=continent, playerZ=zone, playerX=absPx, playerY=absPy, px=px, py=py, items={}, count=0 };

	local gatherCount = 0;
	local maxAllowable = 0;
	if ((GatherConfig.maxDist) and (GatherConfig.maxDist > 0)) then
		maxAllowable = GatherConfig.maxDist / 1000;
	end
	
	if (not GatherItems[continent]) then return gatherLocal; end

	for gatherZone, gathersInZone in GatherItems[continent] do
		for gatherName, gatherData in gathersInZone do
			local gatherType = "Default";
			local specificType = "";
			local allowed = true;

			specificType = Gatherer_FindOreType(gatherName);
			if (specificType) then
				gatherType = "Ore";
				allowed = Gatherer_GetFilter("mining");
			else
				specificType = Gatherer_FindTreasureType(gatherName);
				if (specificType) then
					gatherType = "Treasure";
					allowed = Gatherer_GetFilter("treasure");
				else
					specificType = gatherName;
					gatherType = "Herb"; 
					allowed = Gatherer_GetFilter("herbs");
				end
			end
			if (not specificType) then
				specificType = "default";
			end

			local userConfig = GatherConfig.users[Gather_Player];
			local idx_count=0;
			if (userConfig) then
				if ( userConfig.interested and userConfig.interested[gatherType] ) then
					for interest_index in userConfig.interested[gatherType] do
						idx_count= idx_count +1;
					end
				end

				if( gatherType == "Ore" ) then
					minSetSkillLevel = userConfig.minSetOreSkill;
					if ( not minSetSkillLevel ) then minSetSkillLevel = -1; end
				elseif ( gatherType == "Herb" ) then
					minSetSkillLevel = userConfig.minSetHerbSkill;
					if ( not minSetSkillLevel ) then minSetSkillLevel = -1; end
				end

				if ( allowed == true and Gather_SkillLevel[specificType] and
					minSetSkillLevel > 0 and 
					(minSetSkillLevel > Gather_SkillLevel[specificType] or
					 (GatherConfig.rareOre == 1 and Gather_SkillLevel[Gather_RareMatch[specificType]] and
					  minSetSkillLevel > Gather_SkillLevel[Gather_RareMatch[specificType]] ))
				) then
					allowed = false;
				end

			end

			if ((allowed == true) and
				((userConfig == nil) or
				 (userConfig.interested == nil) or (idx_count == 0) or userConfig.interested[gatherType] == nil or
				 (userConfig.interested[gatherType][specificType] == true or 
				  (GatherConfig.rareOre == 1 and userConfig.interested[gatherType][Gather_RareMatch[specificType]])
				 )
				)
			) then
				for hPos, gatherInfo in gatherData do

					local absHx;
					local absHy;

					if ((not gatherInfo.gtype) or (gatherInfo.gtype == "")) then
						gatherInfo.gtype = gatherType;
					end

					if ((not gatherInfo.icon) or (gatherInfo.icon == "")) then
						gatherInfo.icon = specificType;
					end

					if ((gatherInfo.absx) and (gatherInfo.absy)) then
						absHx = gatherInfo.absx;
						absHy = gatherInfo.absy;
					else
						absHx, absHy = Gatherer_AbsCoord(continent, gatherZone, gatherInfo.x/100, gatherInfo.y/100);
						absHx = math.floor(absHx * 100000)/100000;
						absHy = math.floor(absHy * 100000)/100000;
						GatherItems[continent][gatherZone][gatherName][hPos].absx = absHx;
						GatherItems[continent][gatherZone][gatherName][hPos].absx = absHy;
					end
					if ((absHx ~= 0) and (absHy ~= 0)) then
						local maxLocalPos = 0;
						local replCandidate = 0;
						local replPos = 0;
						local dist, deltaX, deltaY = Gatherer_Distance(absPx, absPy, absHx, absHy);
						if ((maxAllowable == 0) or (dist < maxAllowable)) then
							for localPos, localInfo in gatherLocal.items do
								if (localPos > maxLocalPos) then maxLocalPos = localPos; end
								if (localInfo.dist > dist) then
									if ((replCandidate == 0) or (localInfo.dist > gatherLocal.items[replCandidate].dist)) then
	--									Gatherer_Print("Choosing item "..hPos.." over "..replPos..": "..dist.." vs "..localInfo.dist);

										replCandidate = localPos;
										replPos = hPos;
									end
								end
							end
							if (maxLocalPos < num) then
								replCandidate = maxLocalPos+1;
								replPos = 0;
							end
						end

						if (replCandidate > 0) then
--							Gatherer_Print("Setting item "..replCandidate..": pos "..replPos..", "..dist.."d, "..gatherName);
							local setItem = {};
							setItem.name = gatherName;
							setItem.item = gatherInfo;
							setItem.dist = dist;
							setItem.deltax = deltaX;
							setItem.deltay = deltaY;

							gatherLocal["items"][replCandidate] = setItem;
							gatherCount = gatherCount+1;
						else
	--						Gatherer_Print("Ignoring item "..replCandidate..": "..dist..", "..gatherName);
						end
					end
				end
			end
		end
	end
	gatherLocal.count = gatherCount;
	return gatherLocal;
end

function Gatherer_AbsCoord(continent, zone, x, y)
	if ((continent == 0) or (zone == 0)) then return x, y; end
	local r = GatherRegionData[continent][zone];
	local absX = x * r.scale + r.xoffset;
	local absY = y * r.scale + r.yoffset;
	return absX, absY;
end

function Gatherer_Distance(originX, originY, targetX, targetY)
	local dx = (targetX - originX);
	local dy = (targetY - originY);
	local d = Gatherer_Pythag(dx, dy);
	return d, dx, dy;
end
function Gatherer_Pythag(dx, dy)
	local d = math.sqrt(dx*dx + dy*dy); -- (a*a) is usually computationally faster than math.pow(a,2)
	if (d == 0) then d = 0.0000000001; end -- to avoid divide by zero errors.
	return d;
end

function Gatherer_GetMapScale(continent, zone, inCity, zoomLevel)
	if ((continent == nil) or (zoomLevel == nil)) then return 0,0; end
	if ((not GatherRegionData) or 
	(not GatherRegionData[continent]) or 
	(not GatherRegionData[continent].scales) or 
	(not GatherRegionData[continent].scales[zoomLevel]) or 
	(not GatherRegionData[continent].scales[zoomLevel].xscale) or
	(not GatherRegionData[continent].scales[zoomLevel].yscale)) then
--		Gatherer_Print("Returning 0,0 scale");
		return 0,0;
	end

	local scaleX = GatherRegionData[continent].scales[zoomLevel].xscale;
	local scaleY = GatherRegionData[continent].scales[zoomLevel].yscale;
	if (inCity == true) then
		local cityScale = GatherRegionData.cityZoom[zoomLevel];
--		Gatherer_Print("Using city scale "..cityScale);
		scaleX = scaleX * cityScale;
		scaleY = scaleY * cityScale;
	else
--		Gatherer_Print("Using country scale");
	end
	
--	Gatherer_Print("Returning scale "..scaleX..","..scaleY);
	return scaleX, scaleY;
end

function Gatherer_MiniMapPos(deltaX, deltaY, scaleX, scaleY) -- works out the distance on the minimap
	local mapX = deltaX * scaleX;
	local mapY = deltaY * scaleY;
	local mapDist = 0;
	--print2 ("Calculating map pos from "..deltaX..","..deltaY.." @"..scaleX..","..scaleY);
	mapDist = Gatherer_Pythag(mapX, mapY);
	if (mapDist >= 57) then
		-- Remap it to just inside the minimap, by:
		--   converting dx,dy to angle,distance
		--   then truncate distance to 58 
		--   and convert angle,58 to dx,dy
		local flipAxis = 1;
		if (mapX == 0) then mapX = 0.0000000001;
		elseif (mapX < 0) then flipAxis = -1;
		end
		local angle = math.atan(mapY / mapX);
		mapX = math.cos(angle) * 58 * flipAxis;
		mapY = math.sin(angle) * 58 * flipAxis;
	end
	return mapX, mapY, mapDist;
end

function Gatherer_Spam(c, z, num)
	local gatherC, gatherZ = Gatherer_GetCurrentZone();
	if ((c~=nil) and (c~=0)) then gatherC = c; end
	if ((z~=nil) and (z~=0)) then gatherZ = z; end
	if ((num==nil) or (num==0)) then num = 100; end
	if (not GatherItems[gatherC]) then GatherItems[gatherC] = { }; end
	if (not GatherItems[gatherC][gatherZ]) then GatherItems[gatherC][gatherZ] = { }; end
	if (not GatherItems[gatherC][gatherZ]["test"]) then GatherItems[gatherC][gatherZ]["test"] = { }; end

	local px,py = Gatherer_PlayerPos();
	local gatherX;
	local gatherY;
	math.randomseed((px+py)*10000);
	local totalCount = 0;
	for i=1, num, 1 do
		gatherX = math.random(1,999)/10;
		gatherY = math.random(1,999)/10;
		Gatherer_Print("Adding point at "..gatherC..":"..gatherZ..";"..gatherX..","..gatherY);
		Gatherer_AddGather("test", "Test", gatherC, gatherZ, gatherX, gatherY, "test");
		totalCount = totalCount + 1;
	end
	Gatherer_Print("Spammed "..totalCount.." test items around you in c"..gatherC.."z"..gatherZ..". Last one was "..gatherX..","..gatherY.." and you are at "..px..","..py);
	Gatherer_OnUpdate(0,true);
end

function Gatherer_Unspam()
	if (GatherItems) then
		for gatherC, cData in GatherItems do
			for gatherZ, zData in cData do
				if ((zData) and (zData["test"])) then
					GatherItems[gatherC][gatherZ]["test"] = nil;
				end
			end
		end
	end
	Gatherer_Print("Unspammed all items");
	Gatherer_OnUpdate(0,true);
end

-- Test: /script arg1="You perform Herb Gathering on Mageroyal."; Gatherer_ReadBuff("event");
function Gatherer_ReadBuff(event)
	local record = false;
	local gather;
	local gatherType, gatherIcon;
	if (not arg1) then return; end

	if( strfind(event, "CHAT_MSG") or strfind(event, "CHAT_MSG_SPELL_SELF_BUFF")) then
		if (string.find(arg1, HERB_GATHER_STRING)) then
			record = true;
			gather = string.lower(strsub(arg1, HERB_GATHER_LENGTH, HERB_GATHER_END))

			gatherType = "Herb";
			gatherIcon = gather;
		elseif (string.find(arg1, ORE_GATHER_STRING)) then
			record = true;
			gather = string.lower(strsub(arg1, ORE_GATHER_LENGTH, ORE_GATHER_END))
			gatherType = "Ore";
			gatherIcon = Gatherer_FindOreType(gather);
			if (not gatherIcon) then return; end;
		elseif (string.find(arg1, TREASURE_GATHER_STRING)) then
			record = true;
			gather = string.lower(strsub(arg1, TREASURE_GATHER_LENGTH, TREASURE_GATHER_END));
			gatherType = "Treasure";
			gatherIcon = Gatherer_FindTreasureType(gather);
			if (not gatherIcon) then return; end;
		end
	-- process event to record, normally not possible gather (low/inexistant skill)
	elseif (strfind(event, "UI_ERROR_MESSAGE")) then
		gather = Gatherer_ExtractItemFromTooltip();

		-- process non gatherable item because of low/lack of skill
		local trade_herb_check
		if ( GetLocale() == "frFR" ) 
                then
			-- need to add this since herbalism trade name was translated differently
			-- but the part used in the error messages was not changed to match new name.
			trade_herb_check = OLD_TRADE_HERBALISM
		else
			trade_herb_check = TRADE_HERBALISM
		end

		if(gather and strfind(arg1, trade_herb_check)) then
			record = true;
			gatherType = "Herb";
			gatherIcon = gather;
		elseif (gather and strfind(arg1, TRADE_MINING)) then
			record = true;
			gatherType = "Ore";
			gatherIcon = Gatherer_FindOreType(gather);
		end
	else
		return;
	end

	if (record == true) then
		local gatherC, gatherZ = Gatherer_GetCurrentZone();
		local px, py = Gatherer_PlayerPos();
		if ((px == 0) and (py == 0)) then
			Gatherer_Print("Gatherer: Cannot record item position as client is reporting position 0,0");
			return; 
		end
		local gatherX = px * 100;
		local gatherY = py * 100;
		if (not GatherItems) then
			Gatherer_Print("Initializing empty gatherable database");
			GatherItems = { };
		end

		Gatherer_AddGather(gather, gatherType, gatherC, gatherZ, gatherX, gatherY, gatherIcon);
--		Gatherer_Print("Found "..gather.." at "..gatherX..","..gatherY.." continent "..gatherC.." zone "..gatherZ);
		Gatherer_OnUpdate(0,true);
		GatherMain_Draw();
	end
end

function Gatherer_AddGather(gather, gatherType, gatherC, gatherZ, gatherX, gatherY, gatherIcon)
	if (not GatherItems[gatherC]) then GatherItems[gatherC] = { }; end
	if (not GatherItems[gatherC][gatherZ]) then GatherItems[gatherC][gatherZ] = { }; end
	if (not GatherItems[gatherC][gatherZ][gather]) then GatherItems[gatherC][gatherZ][gather] = { }; end
	
	local found = 0;
	local lastGather = 0;
	local closest = 0;
	for hPos, gatherData in GatherItems[gatherC][gatherZ][gather] do
--		Gatherer_Print("Checking gather: "..hPos);
		local dist, deltaX, deltaY = Gatherer_Distance(gatherX,gatherY, gatherData.x,gatherData.y);
--		Gatherer_Print("Distance = "..dist);
		if ((dist < 0.5) and ((closest == 0) or (closest > dist))) then -- same gather
--			Gatherer_Print("Same gather as "..hPos);
			gatherX = (gatherX + gatherData.x) / 2;
			gatherY = (gatherY + gatherData.y) / 2;
			closest = dist;
			found = hPos;
		end
		if (hPos > lastGather) then
			lastGather = hPos;
		end
	end
	if (found == 0) then -- need to create a new one (at hPos+1)
		found = lastGather+1;
--		Gatherer_Print("Creating new gatherable at "..found);
	end
	
	local gatherCount = 1;
	if (GatherItems[gatherC][gatherZ][gather][found] == nil) then
--		Gatherer_Print("Initializing GatherItems["..gatherC.."]["..gatherZ.."]["..gather.."]["..found.."]");
		GatherItems[gatherC][gatherZ][gather][found] = { };
	else
		gatherCount = GatherItems[gatherC][gatherZ][gather][found].count + 1;
	end

	-- Round off those coordinates
	local absX, absY = Gatherer_AbsCoord(gatherC, gatherZ, gatherX/100, gatherY/100);
	gatherX = math.floor(gatherX * 100)/100;
	gatherY = math.floor(gatherY * 100)/100;
	absX = math.floor(absX * 10000)/10000;
	absY = math.floor(absY * 10000)/10000;
	
--	Gatherer_Print("Setting GatherItems["..gatherC.."]["..gatherZ.."]["..gather.."]["..found.."].{x="..gatherX..",y="..gatherY..",ax="..absX..",ay="..absY..",count = "..gatherCount.."}");
	GatherItems[gatherC][gatherZ][gather][found].x = gatherX;
	GatherItems[gatherC][gatherZ][gather][found].y = gatherY;
	GatherItems[gatherC][gatherZ][gather][found].absx = absX;
	GatherItems[gatherC][gatherZ][gather][found].absy = absY;
	GatherItems[gatherC][gatherZ][gather][found].gtype = gatherType;
	GatherItems[gatherC][gatherZ][gather][found].count = gatherCount;
	GatherItems[gatherC][gatherZ][gather][found].icon = gatherIcon;
end

function Gatherer_Clear()
	Gatherer_Print("Clearing your gather data");
	GatherItems = { };
	ClosestList = { };
	ClosestSearchGather = "";
	Gatherer_OnUpdate(0,true);
	GatherMain_Draw();
end
 
function Gatherer_Show()
	for gatherCont, contData in GatherItems do
		for gatherZone, zoneData in contData do
			for gatherName, nameData in zoneData do
				for gatherPos, gatherItem in nameData do
					Gatherer_Print(gatherItem.gtype.." "..gatherName.." was found in zone "..gatherCont..":"..gatherZone.." at "..gatherItem.x..","..gatherItem.y.."  ("..gatherItem.count.." times)");
				end
			end
		end
	end
end

function Gatherer_ChatPrint(str)
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(str, 1.0, 0.5, 0.25);
	end
end

function Gatherer_Print(str, add)
	if ((Gather_LastPrinted) and (str == Gather_LastPrinted)) then
		return;
	end
	Gather_LastPrinted = str;
	if (add) then
		str = str..": "..add;
	end
	if(ChatFrame2) then
		ChatFrame2:AddMessage(str, 1.0, 1.0, 0.0);
	end
end

function Gatherer_TitleCase(str)
	if (GetLocale() == "frFR") then return str; end

	local function ucaseWord(first, rest)
		return string.upper(first)..string.lower(rest)
	end
	return string.gsub(str, "([a-zA-Z])([a-zA-Z']*)", ucaseWord);
end

function Gatherer_LoadContinents(...)
	GatherZoneData = { };
	for c=1, arg.n, 1 do
		local cname = arg[c];
		Gatherer_LoadZones(c, cname, GetMapZones(c));
	end
end
function Gatherer_LoadZones(c,cname, ...)
	for z=1, arg.n, 1 do
		local zname = arg[z];
		GatherZoneData[zname] = { continent=c, zone=z, continentName=cname };
	end
end

function Gatherer_GetCurrentZone()
	local currentZoneName = GetRealZoneText();
--	local currentZoneName = GetMapInfo();
	for zoneName, zoneData in GatherZoneData do
		if (currentZoneName == zoneName) then
			return zoneData.continent, zoneData.zone;
		end
	end
	--print2("Couldn't get current zone for "..currentZoneName);
	return 0,0;
end
	
Gatherer_LastZone = {};
function Gatherer_ChangeMap()
	local mapContinent = GetCurrentMapContinent();
	local mapZone = GetCurrentMapZone();
	local minderCurZone = false;
	if ((Gatherer_CloseMap ~= nil) and (Gatherer_CloseMap.continent == Gatherer_LastZone.continent) and (Gatherer_CloseMap.zone == Gatherer_LastZone.zone)) then
--		Gatherer_ChatPrint("Player's last zone is minder zone");
		minderCurZone = true;
	end
	local playerContinent, playerZone = Gatherer_GetCurrentZone();
	Gatherer_LastZone = { continent = playerContinent, zone = playerZone };
	if ((playerContinent == 0) or (playerZone == 0)) then return false; end
	if ((playerContinent == mapContinent) and (playerZone == mapZone)) then return true; end
--	Gatherer_ChatPrint("Had to get player zone "..playerContinent..":"..playerZone.." cause map pos was "..mapContinent..":"..mapZone);

	SetMapZoom(playerContinent, playerZone);
	local lastTime = 0;
	if ((Gatherer_CloseMap ~= nil) and (Gatherer_CloseMap.time ~= nil)) then
		lastTime = Gatherer_CloseMap.time;
	end
	
	if (minderCurZone) then
--		Gatherer_ChatPrint("Resetting minder zone to "..playerContinent..":"..playerZone);
		Gatherer_MapOpen = false;
		Gatherer_CloseMap = { continent = playerContinent, zone = playerZone, time = lastTime };
		Gatherer_OnEvent("WORLD_MAP_UPDATE");
	end
	
	return true;
end

function Gatherer_PlayerPos(forced)
	local currentZoneName = GetRealZoneText();
--	local currentZoneName = GetMapInfo();
	if (currentZoneName ~= Gather_LastZone) then
		forced = true;
	end
	Gather_LastZone = currentZoneName;
	if (forced) then Gatherer_ChangeMap(); end

	local px, py = GetPlayerMapPosition("player");
	if ((px == 0) and (py == 0)) then
		if (not forced) then 
			if (Gatherer_ChangeMap()) then
				px, py = GetPlayerMapPosition("player");
			else
				return 0,0;
			end
		end
	end
	return px, py;
end


function RecalcNotes()
	local note_count=0;
	Gatherer_ChatPrint("Starting recompute of mininotes coordinates...")
	for idx_c, rec_continent in GatherItems do
		for idx_z, rec_zone in rec_continent do
			if ( idx_c ~= 0 and idx_z ~= 0) then
				--Gatherer_ChatPrint("continent: "..idx_c.." zone: "..idx_z.. " : "..GatherRegionData[idx_c][idx_z].name);
				for myItems, rec_gatheritem in rec_zone do
					--Gatherer_ChatPrint(" ==>"..myItems);
					for idx_item, myGather in rec_gatheritem do
						--Gatherer_ChatPrint("Id: "..idx_item.." type: "..myGather.gtype.." icon: "..myGather.icon);
						rec_absHx, rec_absHy = Gatherer_AbsCoord(idx_c, idx_z, myGather.x/100, myGather.y/100);
						rec_absHx = math.floor(rec_absHx * 100000)/100000;
						rec_absHy = math.floor(rec_absHy * 100000)/100000;
						GatherItems[idx_c][idx_z][myItems][idx_item].absx = rec_absHx;
						GatherItems[idx_c][idx_z][myItems][idx_item].absy = rec_absHy;
						note_count = note_count + 1;
					end
				end
			end
		end
	end
	Gatherer_ChatPrint("Recompute of mininotes coordinates completed ("..note_count.." items fixed).")
end




