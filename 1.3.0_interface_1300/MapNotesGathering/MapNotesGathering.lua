--[[ 
           ********** Map Notes Gathering **********
Automatically marks herbs, ores and chests on the WorldMapFrame

Author: Sir.Bender [Meog on WoW Forums]
Date: 30. Dec 2004 12:31 GMT + 1
Version: 0.5.2

The idea is ripped mercilessly from Norganna, nothing more.
Thanks go to Sembiance from the WoW-Forums for making the chests list.
]]

MapNotesGathering_NotesPerZone = 150;

RegisterForSave("MapNotesGathering_Data");
MapNotesGathering_Data = {};
MapNotesGathering_Data[1] = {};
MapNotesGathering_Data[2] = {};

function MapNotesGathering_OnLoad()
	for i=1, 21, 1 do
		MapNotesGathering_Data[1][i] = {};
	end
	for i=1, 26, 1 do
		MapNotesGathering_Data[2][i] = {};
	end
	MapNotes_RegisterDropDownButton(MAPNOTESGATHERING_SHOWHERBS, "MapNotes_Options.showherbs", "MapNotesGatheringHerbsDropDownSubMenu");
	MapNotes_RegisterDropDownButton(MAPNOTESGATHERING_SHOWVEINS, "MapNotes_Options.showveins", "MapNotesGatheringVeinsDropDownSubMenu");
	MapNotes_RegisterDropDownButton(MAPNOTESGATHERING_SHOWCHESTS, "MapNotes_Options.showchests");
end

function MapNotesGathering_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		if (not MapNotes_Options["Gathering"]) then MapNotes_Options["Gathering"] = {}; end
	else
		local name;
		local typeofobject;
		if (strfind(arg1, MapNotesGathering_SearchHerb2)) then
			name = gsub(arg1, MapNotesGathering_SearchHerb, "%1", 1);
		elseif (strfind(arg1, MapNotesGathering_SearchOre2)) then
			name = gsub(arg1, MapNotesGathering_SearchOre, "%1", 1);
		elseif (strfind(arg1, MapNotesGathering_SearchChest2)) then
			name = gsub(arg1, MapNotesGathering_SearchChest, "%1", 1);
			typeofobject = "chest";
		end
		if (name ~= nil) then
			local continent, zone = MapNotes_GetZone();
			if (zone ~= 0) then
				SetMapZoom(continent, zone);
				local xPos, yPos = GetPlayerMapPosition("player");
				local icon, subname = MapNotesGathering_GetNameNumber(name);
				if ((not MapNotesGathering_CheckNearNotes(continent, zone, xPos, yPos, icon)) and xPos ~= 0 and yPos ~= 0 ) then
					local lastnote = getn(MapNotesGathering_Data[continent][zone]);
					if (icon ~= 0 and subname ~= 0 and lastnote < MapNotesGathering_NotesPerZone) then	
						MapNotesGathering_Data[continent][zone][lastnote+1] = {};
						MapNotesGathering_Data[continent][zone][lastnote+1].xPos = xPos
						MapNotesGathering_Data[continent][zone][lastnote+1].yPos = yPos;
						MapNotesGathering_Data[continent][zone][lastnote+1].icon = icon;
						MapNotesGathering_Data[continent][zone][lastnote+1].subname = subname;
					else
						if (typeofobject ~= "chest") then MapNotes_StatusPrint(MAPNOTESGATHERING_NOTINLIST); end
					end
				end
			end
		end
	end
end

function MapNotesGathering_CheckNearNotes(continent, zone, xPos, yPos, icon)
	for i=1, getn(MapNotesGathering_Data[continent][zone]), 1 do
		if (abs(MapNotesGathering_Data[continent][zone][i].xPos - xPos) <= 0.0009765625 * MapNotes_MinDiff and abs(MapNotesGathering_Data[continent][zone][i].yPos - yPos) <= 0.0013020833 * MapNotes_MinDiff) then
			if (MapNotesGathering_Data[continent][zone][i].icon == icon) then -- only return true (for too near), when the types are the same...
				return true;
			end
		end
	end
	return false;
end

function MapNotesGathering_GetNameNumber(name)
	for icon = 1, getn(MapNotesGathering_Names), 1 do
		for subname = 1, getn(MapNotesGathering_Names[icon]), 1 do
			if (MapNotesGathering_Names[icon][subname] == name) then
				return icon, subname;
			end
		end
	end
	return 0, 0;
end

function MapNotesGathering_OnEnter(id)
	if ((not MapNotesPOIMenuFrame:IsVisible()) and (not MapNotesNewMenuFrame:IsVisible()) and MapNotes_BlockingFrame()) then
		local x, y = this:GetCenter();
		local x2, y2 = WorldMapButton:GetCenter();
		local anchor = "";
		if (x > x2) then anchor = "ANCHOR_LEFT"; else anchor = "ANCHOR_RIGHT"; end
		local zone = GetCurrentMapZone();
		local continent = GetCurrentMapContinent();
		WorldMapTooltip:SetOwner(this, anchor);
		WorldMapTooltip:SetText(MapNotesGathering_Names[MapNotesGathering_Data[continent][zone][id].icon][MapNotesGathering_Data[continent][zone][id].subname], MapNotes_Colors[0].r, MapNotes_Colors[0].g, MapNotes_Colors[0].b);
		local xPos = MapNotesGathering_Data[continent][zone][id].xPos;
		local yPos = MapNotesGathering_Data[continent][zone][id].yPos;
		for i=1, getn(MapNotesGathering_Data[continent][zone]), 1 do
			if (i ~= id and abs(MapNotesGathering_Data[continent][zone][i].xPos - xPos) <= 0.0009765625 * MapNotes_MinDiff and abs(MapNotesGathering_Data[continent][zone][i].yPos - yPos) <= 0.0013020833 * MapNotes_MinDiff) then
				local icon = MapNotesGathering_Data[continent][zone][i].icon;
				if ((MapNotes_Options.showherbs and icon > 8 and icon <= 37 and MapNotes_Options["Gathering"][icon] ~= "off") or (MapNotes_Options.showveins and icon <= 8 and MapNotes_Options["Gathering"][icon] ~= "off") or (MapNotes_Options.showchests and icon == 38)) then
					WorldMapTooltip:AddLine(MapNotesGathering_Names[icon][MapNotesGathering_Data[continent][zone][i].subname], MapNotes_Colors[0].r, MapNotes_Colors[0].g, MapNotes_Colors[0].b);
				end
			end
		end
		WorldMapTooltip:Show();
	else
		WorldMapTooltip:Hide();
	end
end

function MapNotesGathering_OnLeave(id)
	WorldMapTooltip:Hide();
end
	
function MapNotesGathering_OnClick(arg1, id)
	CloseDropDownMenus();
	if (arg1 == "LeftButton") then
		local x, y = this:GetCenter();
		x = x / WorldMapButton:GetScale();
		y = y / WorldMapButton:GetScale();
		local centerX, centerY = WorldMapButton:GetCenter();
		local width = WorldMapButton:GetWidth();
		local height = WorldMapButton:GetHeight();
		local adjustedY = (centerY + (height/2) - y) / height;
		local adjustedX = (x - (centerX - (width/2))) / width;
		if (GetCurrentMapZone() ~= 0) then
			MapNotesButtonNewNote:Disable();
			MapNotes_ShowNewFrame(adjustedX, adjustedY);
			if (MapNotes_BlockingFrame()) then MapNotes_TempData_Id = -1; end
		end
	elseif (arg1 == "RightButton") then
		local x, y = this:GetCenter();
		x = x / WorldMapButton:GetScale();
		y = y / WorldMapButton:GetScale();
		local centerX, centerY = WorldMapButton:GetCenter();
		local width = WorldMapButton:GetWidth();
		local height = WorldMapButton:GetHeight();
		local ay = (centerY + (height/2) - y) / height;
		local ax = (x - (centerX - (width/2))) / width;
		if (ax*1002 >= (1002 - 195)) then xOffset = -176; else xOffset = 0;	end
		if (ay*668 <= (668 - 156)) then yOffset = -75; else yOffset = 61; end
		if (MapNotes_BlockingFrame()) then
			MapNotesGatheringMenuFrame:SetPoint("TOPLEFT", "WorldMapFrame", "TOPLEFT", ax * WorldMapButton:GetWidth() + xOffset, -(ay * WorldMapButton:GetHeight()) + yOffset);
			MapNotesPOIMenuFrame:Hide()
			MapNotesNewMenuFrame:Hide();
			WorldMapTooltip:Hide();
			MapNotesGatheringMenuFrame:Show();
			MapNotes_TempData_Id = this:GetID();
		end
	end
end

function MapNotesGathering_OnUpdate()
	local zone = GetCurrentMapZone();
	local continent = GetCurrentMapContinent();
	if (zone ~= 0) then
		for i=1, getn(MapNotesGathering_Data[continent][zone]), 1 do
			local temp = getglobal("MapNotesGatheringPOI"..i);
			local icon = MapNotesGathering_Data[continent][zone][i].icon;
			if (icon ~= nil and icon ~= 0) then --workaround for the bug in the first version...
				if ((MapNotes_Options.showherbs and icon > 8 and icon <= 37 and MapNotes_Options["Gathering"][icon] ~= "off") or (MapNotes_Options.showveins and icon <= 8 and MapNotes_Options["Gathering"][icon] ~= "off") or (MapNotes_Options.showchests and icon == 38)) then
					temp:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", (MapNotesGathering_Data[continent][zone][i].xPos)*WorldMapButton:GetWidth(), -(MapNotesGathering_Data[continent][zone][i].yPos)*WorldMapButton:GetHeight());
					getglobal("MapNotesGatheringPOI"..i.."Texture"):SetTexture("Interface\\AddOns\\MapNotesGathering\\POIIcons\\Icon"..icon);
					temp:Show();
				else
					temp:Hide();
				end
			else -- should delete it here, because it was inserted and was no herb / ore
				temp:Hide();
			end
		end
		for i=(getn(MapNotesGathering_Data[continent][zone])+1), MapNotesGathering_NotesPerZone, 1 do
			getglobal("MapNotesGatheringPOI"..i):Hide();
		end
	else
		for i=1, MapNotesGathering_NotesPerZone, 1 do
			getglobal("MapNotesGatheringPOI"..i):Hide();
		end
	end
end

function MapNotesGathering_SetAsMiniNote(id)
	id = tonumber(id);
	local zone = GetCurrentMapZone();
	local continent = GetCurrentMapContinent();
--	print1(id.." "..zone.." "..continent);
	MapNotes_MiniNote_Data.xPos = MapNotesGathering_Data[continent][zone][id].xPos;
	MapNotes_MiniNote_Data.yPos = MapNotesGathering_Data[continent][zone][id].yPos;
	MapNotes_MiniNote_Data.continent = continent;
	MapNotes_MiniNote_Data.zone = zone;
	MapNotes_MiniNote_Data.id = -2;
	MapNotes_MiniNote_Data.name = MapNotesGathering_Names[MapNotesGathering_Data[continent][zone][id].icon][MapNotesGathering_Data[continent][zone][id].subname];
	MapNotes_MiniNote_Data.color = 0;
	MapNotes_MiniNote_Data.icon = MapNotesGathering_Data[continent][zone][id].icon;
	MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotesGathering\\POIIcons\\Icon"..MapNotesGathering_Data[continent][zone][id].icon);
	MiniNotePOI:Show();
	MapNotes_HideFrames();
end

function MapNotesGathering_HideFrames()
	MapNotesGatheringMenuFrame:Hide();
end

if (Sea) then
	Sea.util.hook("WorldMapButton_OnUpdate", "MapNotesGathering_OnUpdate", "after");
	Sea.util.hook("MapNotes_HideFrames", "MapNotesGathering_HideFrames", "after");
else
	old_WorldMapButton_OnUpdate = WorldMapButton_OnUpdate;
	WorldMapButton_OnUpdate = function() old_WorldMapButton_OnUpdate(); MapNotesGathering_OnUpdate(); end
	old_MapNotes_HideFrames = MapNotes_HideFrames;
	MapNotes_HideFrames = function() old_MapNotes_HideFrames(); MapNotesGathering_HideFrames(); end
end