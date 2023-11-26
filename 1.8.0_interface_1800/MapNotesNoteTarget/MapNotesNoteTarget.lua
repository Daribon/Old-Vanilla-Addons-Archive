--[[

MapNotesNoteTarget 

Author:         chrispix (mainly copied from Sir.Bender's MapNotes code), 
                with help from Aaron Sullivan on merging notes and adding profession info
Version:        1300.2 
ToDo:           Send requests for functionality to mapnotes@cricklepickle.com.

Last Modified   
1/31/2005 	Release 0.5.3
            Initial release.

2/15/2005   Release 0.5.4
            Updated for 4211 patch version

3/1/2005    Release 4222.1
            Fixed problem with creating notes in Ironforge, updated for patch 4222, 
            and moved to patch number versioning. Now requires MapNotes 0.5.4, available at 
            http://www.curse-gaming.com/mod.php?addid=65.

3/23/2005   Release 1300.1
            Updated for 3/22 patch, fixed error message when nothing is targeted.
            
4/25/2005   Release 1300.2
            Thanks to Aaron Sullivan for his help on these features:
            Added profession info (<Innkeeper>, <Warlock Trainer>, etc) to friendly notes
            Added ability to merge new notes with existing nearby notes

6/21/2005   Release 1500.1
            Updated for interface 1500

9/19/2005   Release 1700.1
            Updated for interface 1700

            
An extension to the excellent MapNotes AddOn which allows you to quickly note your current
position, as well as some information on your current target. Useful for remembering the 
location of questgivers, trainers, flight masters, named mobs, types of critters, etc.

If the target is friendly, the icon will be green and contain the target's name and profession.
If the target is neutral (usually critters), the icon will be yellow and contain the target's name.
If the target is hostile, the icon will be red and contain the target's name, level, elite/boss status,
type (beast, humanoid, elemental, etc), and class (warrior, rogue, warlock, etc).

If you type any text after the command, it will be added to the first optional text line in the note. 
For example, /nt quest objective, /nt wandering, /nt has bodyguards, etc.

Some screenshots:
http://cricklepickle.com/wow/mob.jpg
http://cricklepickle.com/wow/elite.jpg
http://cricklepickle.com/wow/critter.jpg
http://cricklepickle.com/wow/questgiver.jpg
http://cricklepickle.com/wow/vendor.jpg
http://cricklepickle.com/wow/batmaster.jpg
http://cricklepickle.com/wow/profession.jpg
http://cricklepickle.com/wow/merge.jpg

Download the latest version from http://cricklepickle.com/wow/MapNotesNoteTarget.zip and unzip it into
your WoW installation folder.

By default, the note will be created on the world map. However, if you'd like to create a minimap note,
it works in the same way as MapNotes. Just type /nmn to specify your next note as a minimap note, then
create the note using /nt.

Usage: Target something and type /nt [optional text] or /notetarget [optional text]

Requires MapNotes version 0.5.4 or MapNotes (Cont.). See http://www.curse-gaming.com/mod.php?addid=1285. 
I use the latter to test against, since it's in active development, where the original MapNotes has 
been abandoned. If you have any problems, post a comment here or email me at mapnotes@cricklepickle.com 
and I'll look into it.

If you try to create a note that's too close to an existing note (i.e., so close you wouldn't be able to 
differentiate them on the map), an error will be displayed. This is a feature of MapNotes. You can use
/ntm [optional text] or /notetargetmerge [optional text] to automatically append the current target 
info to the existing note. Thanks to Aaron Sullivan for his work on this feature.
]]

local version = "1700.1";

function MapNotesNoteTarget_OnLoad()
    SLASH_NT1 = "/nt";
    SLASH_NT2 = "/notetarget";
    SlashCmdList["NT"] = MapNotesNoteTarget_CreateNote;
    SLASH_NTM1 = "/ntm";
    SLASH_NTM2 = "/notetargetmerge";
    SlashCmdList["NTM"] = MapNotesNoteTarget_CreateNoteMerge;
    -- MapNotes_StatusPrint("Map Notes Note Target version "..version.." loaded");
end

function MapNotesNoteTarget_CreateNote(msg)
    if (not UnitExists("target")) then
		MapNotes_StatusPrint("You must have something targeted to make a note. Press F1 to target yourself");
        return;
    end

	SetMapToCurrentZone();
	local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
	local continent = GetCurrentMapContinent();
	--local continent, zone = MapNotes_GetZone();
	local x, y = GetPlayerMapPosition("player");
	if ((x == 0 and y == 0) or zone == 0) then
		MapNotes_StatusPrint(MAPNOTES_QUICKNOTE_NOPOSITION);
        return;
	end
    
	local checknote = MapNotes_CheckNearNotes(continent, zone, x, y);

    if (checknote) then
		MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETONEAR, MapNotes_Data[continent][zone][checknote].name)..". Use /ntm to merge with existing note");
	else
        MapNotesNoteTarget_WriteNote(continent, zone, "", msg, x, y);
    end	
end

function MapNotesNoteTarget_CreateNoteMerge(msg)
    if (not UnitExists("target")) then
		MapNotes_StatusPrint("You must have something targeted to make a note. Press F1 to target yourself");
        return;
    end

    SetMapToCurrentZone();
	local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
	local continent = GetCurrentMapContinent();
	--local continent, zone = MapNotes_GetZone();
	local x, y = GetPlayerMapPosition("player");
	if ((x == 0 and y == 0) or zone == 0) then
		MapNotes_StatusPrint(MAPNOTES_QUICKNOTE_NOPOSITION);
		return;
	end
		
	local checknote = MapNotes_CheckNearNotes(continent, zone, x, y);
    local existingNote = "";
	if (checknote) then
        -- get the content of the existing note
        existingNote = MapNotes_Data[continent][zone][checknote].name;
		if (string.find(existingNote, UnitName("target"))) then
			-- we want to try to avoid adding duplicate information to the note
			MapNotes_StatusPrint("There is already a note for "..UnitName("target"));
			return;
		else
			-- prepend any existing extra info
			existingNote = existingNote.." | ";
			--if (MapNotes_Data[continent][zone][checknote].inf1 ~= "") then
			    msg = MapNotes_Data[continent][zone][checknote].inf1.." | "..msg;
			--end
			MapNotes_DeleteNote(checknote);
			MapNotes_StatusPrint("Merging Notes...");
		end
	end
    MapNotesNoteTarget_WriteNote(continent, zone, existingNote, msg, x, y);
end

function MapNotesNoteTarget_WriteNote(continent, zone, prefix, msg, x, y)
    local id = 0;
    local icon = 3; --green by default
    
    local text = prefix..UnitName("target");
    if (UnitReaction("player", "target") < 4) then 
        -- hostile, get level, classification, type, and class
        text = text.." level "..UnitLevel("target");
        icon = 1; --red
        if (UnitClassification("target") ~= "normal") then
            text = text.." "..UnitClassification("target");
        end
        text = text.." "..UnitCreatureType("target").." "..UnitClass("target");
    elseif (UnitReaction("player", "target") == 4) then 
        -- neutral, assume critter, use yellow icon
        icon = 0; --yellow
    else
        -- add profession
        GameTooltip:SetUnit("target")
        local profession = GameTooltipTextLeft2:GetText();
        -- set profession to nil if it's the target's level or empty
        if (string.find(profession,"Level") or profession == "") then
            profession = nil;
        end    
        if (profession) then
            --MapNotes_StatusPrint("Setting profession to <"..profession..">");
            text = text.." <"..profession..">";
        end
    end

    --MapNotes_StatusPrint(text);
    if (MapNotes_SetNextAsMiniNote ~= 2) then
        local i = 0;
        for j, value in MapNotes_Data[continent][zone] do
            i = i + 1;
        end
        if (i < MapNotes_NotesPerZone) then
            MapNotes_TempData_Id = i + 1;
            MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = text;
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = 0; -- name color
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = msg; -- info 1 text
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = 0; -- info 1 color
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = "";
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = 0;
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = UnitName("player");
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = icon; -- icon color
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = x;
            MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = y;
            id = MapNotes_TempData_Id;
            MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_OK, MapNotes_ZoneNames[continent][zone]).." for "..text);
        else
            MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_TOOMANY, MapNotes_ZoneNames[continent][zone]));
        end
    end
    if (MapNotes_SetNextAsMiniNote ~= 0) then
        MapNotes_MiniNote_Data.xPos = x;
        MapNotes_MiniNote_Data.yPos = y;
        MapNotes_MiniNote_Data.continent = continent;
        MapNotes_MiniNote_Data.zone = zone;
        MapNotes_MiniNote_Data.id = id; -- only shown if the note was written...
        MapNotes_MiniNote_Data.name = text;
        MapNotes_MiniNote_Data.color = 0;
        MapNotes_MiniNote_Data.icon = icon;
        MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..icon);
        MiniNotePOI:Show();
        MapNotes_SetNextAsMiniNote = 0;
        MapNotes_StatusPrint(MAPNOTES_SETMININOTE.." for "..UnitName("target"));
    end
end
