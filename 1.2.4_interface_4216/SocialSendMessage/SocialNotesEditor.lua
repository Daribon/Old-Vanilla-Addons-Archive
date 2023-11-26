-- SocialNotesEditor.lua    -- by <geowar@apple.com>
-- Based heavly on the Notepad editor by Vladimir Vukicevic <vladimir@pobox.com>
--
-- This file is part of the SocialSendMessage AddOn for Blizzard Entertainment Inc.'s World of Warcraft.
--

-- exported globals

SocialNotes = {};

-- local globals

-- Currently selected entry. 0 = no/new entry.
local SocialNotesEditor_SelectedEntry = 0;

-- Are we resizing?
local SocialNotesEditor_IsResizing = 0;

-- The number of visible entry buttons
local SocialNotesEditor_NumVisibleEntryButtons = 0;
local SocialNotesEditor_CurrentOffset = 0;

RegisterForSave("SocialNotes");
RegisterForSave("SocialNotesEditor_SelectedEntry");

-- Constants

-- this is the max number of buttons that we have available, numbered 1 through this value

local NOTEPAD_MAX_BUTTONS = 25;

-- local (non exported) functions


-- Helper function to sort the list of names
local function SNE_compare(section1, section2)
    if (not section1) then
        return false;
    elseif (not section2) then
        return true;
    else
        if (section1.title < section2.title) then
            return true;
        else
            return false;
        end
    end
end

local function SNE_GetTimeText()
    if (Clock_GetTimeText) then
        return Clock_GetTimeText();
    end

    local hour, minute = GetGameTime();

    return format("%02d:%02d", hour, minute);
end

local function SNE_AppendText(text)
    if (text) then
        local body = SocialNotesEditorEntryEditBox:GetText();
        if (body) then
            text = body..text.."\n";
        end
        SocialNotesEditorEntryEditBox:SetText(text);
    end
end

-- exported functions

-- On loading, make sure that our current button state is set up, and do UI hook setup
function SocialNotesEditor_Toggle()
    if (SocialNotesEditorFrame:IsVisible()) then
        SocialNotesEditorFrame:Hide();
    else
        SocialNotesEditorFrame:Show();
    end
end

function SocialNotesEditor_EditPlayerNote(player)
    if (not SocialNotesEditorFrame:IsVisible()) then
      SocialNotesEditorFrame:Show();
    end

    if (SocialNotesEditor_SelectedEntry and SocialNotesEditor_SelectedEntry > 0) then
        SocialNotesEditor_SaveCurrentEntry();
    end
    
    --print1("SocialNotes: "..asText(SocialNotes)..".");
    
    local oldEntry = false;
    for key,value in SocialNotes do
        --print1("key: "..asText(key)..", value: "..asText(value)..".");
        if (value and value.title and value.body) then
            if (value.title == player) then
                oldEntry = key;
            end
        else
            SocialNotes[key] = {title = "Bobo", body = "...is a bad boy!"};
            --table.remove(SocialNotes, key);
        end
    end

    if (oldEntry) then
        SocialNotesEditor_LoadEntry(oldEntry);
        SocialNotesEditor_UpdateEntryList();
    else
        SocialNotesEditor_SelectedEntry = 0;
        SocialNotesEditorEntryTitleText:SetText(player);
        SocialNotesEditorEntryEditBox:SetText("");

        SocialNotesEditor_SaveCurrentEntry();
    end
end

function SocialNotesEditor_OnLoad()
    this:RegisterForDrag("LeftButton");
    this:RegisterEvent("VARIABLES_LOADED");
--[[
    if ( Cosmos_RegisterButton ) then
        Cosmos_RegisterButton (TEXT(NOTEPAD_BUTTON_NAME),
                                      TEXT(NOTEPAD_BUTTON_DESC),
                                      TEXT(NOTEPAD_BUTTON_LONGDESC),
                                      "Interface\\AddOns\\SocialNotesEditor\\SocialNotesEditor_Icon",
                                      SocialNotesEditor_Toggle);
    end
]]
    SocialNotesEditor_UpdateEntryList();
end

-- Take the window's current height and show the appropriate number of buttons
function SocialNotesEditor_UpdateEntryButtonVisibility()
    local buttonHeight, frameHeight, numButtons, numEntries;

    local uiScale = GetCVar("uiscale");

    buttonHeight = 20;
    frameHeight = SocialNotesEditorEntriesScrollFrame:GetHeight() + 5; -- 5 seems to be a magic fudge factor!
    if (uiScale) then
        frameHeight = frameHeight / uiScale;
    end

    numButtons = frameHeight / buttonHeight;
    numEntries = getn(SocialNotes);

    --print1("SocialNotesEditor_UpdateEntryButtonVisibility fh: " .. frameHeight .. " nb: " .. numButtons .. " ne: " .. numEntries);

    for i=1, NOTEPAD_MAX_BUTTONS do
        local theButton = getglobal ("SocialNotesEditorEntry" .. i);
        if ( i <= numButtons and i <= numEntries ) then
            theButton:Show();
        else
            theButton:Hide();
        end
    end

    SocialNotesEditor_NumVisibleEntryButtons = floor(numButtons);
end

-- Figure out where to set the various faux scroll frame bits
function SocialNotesEditor_UpdateScrollFrame()
    FauxScrollFrame_Update(SocialNotesEditorEntriesScrollFrame,
                                  table.getn(SocialNotes),
                                  SocialNotesEditor_NumVisibleEntryButtons,
                                  32);
end

--
-- SocialNotesEditor event handler
--
-- We only care about VARIABLES_LOADED, so that we can load the previously
-- selected entry and initialize the scroll frame
local SocialNotesEditor_VarsLoaded = 0;
function SocialNotesEditor_OnEvent(event)
    if ( (event == "VARIABLES_LOADED") and (SocialNotesEditor_VarsLoaded == 0) ) then

        -- we finally (!) have our variables loaded, grrr
        SocialNotesEditor_UpdateEntryList();
        if ( SocialNotesEditor_SelectedEntry ~= 0 ) then
            SocialNotesEditor_LoadEntry(SocialNotesEditor_SelectedEntry);
        end
        SocialNotesEditor_VarsLoaded = 1;
    end
end

--
-- Drag handlers, for when the window is dragged
function SocialNotesEditor_OnDragStart()
    this:StartMoving();
end

function SocialNotesEditor_OnDragStop()
    this:StopMovingOrSizing();
end

-- Called from FauxScrollFrame
function SocialNotesEditor_UpdateEntriesScrollFrame()
    SocialNotesEditor_CurrentOffset = FauxScrollFrame_GetOffset(SocialNotesEditorEntriesScrollFrame);
    for i=1, min(SocialNotesEditor_NumVisibleEntryButtons, table.getn(SocialNotes)) do
        local button = getglobal("SocialNotesEditorEntry" .. i);
        local title = SocialNotes[SocialNotesEditor_CurrentOffset + i].title;
        button:SetText(title);
        if (title and Cosmos_IsCosmosUser and Cosmos_IsCosmosUser(title)) then
            button:SetTextColor(0.25, 0.50, 1.0);
        else
            button:SetTextColor(1.0, 0.82, 0.0);
        end
    end
end

function SocialNotesEditor_SaveCurrentEntry()
    --print1("SocialNotesEditor_SaveCurrentEntry " .. SocialNotesEditor_SelectedEntry);
    local title = SocialNotesEditorEntryTitleText:GetText();
    local body = SocialNotesEditorEntryEditBox:GetText();

    -- If the title is empty, we don't save
    if (title ~= "") then
        local entryIndex = SocialNotesEditor_SelectedEntry;
        if ( entryIndex == 0 ) then
            entryIndex = table.getn(SocialNotes) + 1;
            table.setn(SocialNotes, entryIndex);
        end
    
        local entry = {};
        entry.title = title;
        entry.body = body;
        SocialNotes[entryIndex] = entry;

        table.sort(SocialNotes, SNE_compare);
    
        entryIndex = 0;
        for key, value in SocialNotes do
            if (value and value.title and value.title == title) then
                entryIndex = key;
            end
        end
        SocialNotesEditor_SelectedEntry = entryIndex;

        SocialNotesEditor_UpdateEntryList();

        RegisterForSave("SocialNotes");
        RegisterForSave("SocialNotesEditor_SelectedEntry");
    end
end

function SocialNotesEditor_UpdateEntryList()
    --print1("SocialNotesEditor_UpdateEntryList");
    SocialNotesEditor_UpdateEntryButtonVisibility();
    SocialNotesEditor_UpdateScrollFrame();
    SocialNotesEditor_UpdateEntriesScrollFrame();
end

-- Load the entry with the given index.
function SocialNotesEditor_LoadEntry(aEntryId)

    --print1("SocialNotesEditor_LoadEntry: "..asText(aEntryId)..".");

    SocialNotesEditor_SelectedEntry = aEntryId;
    if (aEntryId and aEntryId > 0) then
        if (SocialNotes[aEntryId]) then
            local title = SocialNotes[aEntryId].title;
            SocialNotesEditorEntryTitleText:SetText(title);
            if (title and Cosmos_IsCosmosUser and Cosmos_IsCosmosUser(title)) then
                SocialNotesEditorEntryTitleText:SetTextColor(0.25, 0.50, 1.0);
            else
                SocialNotesEditorEntryTitleText:SetTextColor(1.0, 0.82, 0.0);
            end
            SocialNotesEditorEntryEditBox:SetText(SocialNotes[aEntryId].body);
        end
    end
end

function SocialNotesEditor_OnClearButtonClick()
    --print1("SocialNotesEditor_OnClearButtonClick");
    SocialNotesEditorEntryEditBox:SetText("");
end

function SocialNotesEditor_OnDeleteButtonClick()
    --print1("SocialNotesEditor_OnDeleteButtonClick " .. SocialNotesEditor_SelectedEntry);
    if ( SocialNotesEditor_SelectedEntry ~= 0 ) then
        table.remove(SocialNotes, SocialNotesEditor_SelectedEntry);
    end
    SocialNotesEditor_OnClearButtonClick();
    SocialNotesEditor_UpdateEntryList();
    SocialNotesEditor_LoadEntry(SocialNotesEditor_SelectedEntry);
end

function SocialNotesEditor_OnEntryClick(aButtonID)
    SocialNotesEditor_SaveCurrentEntry();

    local entryId = SocialNotesEditor_CurrentOffset + aButtonID;
    SocialNotesEditor_LoadEntry(entryId);
end

function SocialNotesEditor_OnCloseButtonClick(aArg)
    SocialNotesEditorFrame:Hide();
end

function SocialNotesEditor_OnResizeButtonMouseDown(aWhichCorner)
    SocialNotesEditor_IsResizing = 1;

    this:GetParent():StartSizing(aWhichCorner);
end

function SocialNotesEditor_OnResizeButtonMouseUp()
    SocialNotesEditor_IsResizing = 0;

    this:GetParent():StopMovingOrSizing();
end

function SocialNotesEditor_OnEntryBodyTextChanged()
    -- borrowed from MailFrame.xml; update the scrollbar
    local scrollBar = getglobal(this:GetParent():GetParent():GetName().."ScrollBar");
    this:GetParent():GetParent():UpdateScrollChildRect();
    local min, max
    min, max = scrollBar:GetMinMaxValues();
    if ( max > 0 and (this.max ~= max) ) then
        this.max = max
        scrollBar:SetValue(max);
    end
end

function SocialNotesEditor_OnEntryBodyEditFocusLost()
    SocialNotesEditor_SaveCurrentEntry();
end

function SocialNotesEditor_OnAddTimeStampButtonClick()
    SNE_AppendText("\nTime: "..SNE_GetTimeText());
end

function SocialNotesEditor_OnAddPartyButtonClick()
    local text = "\nParty:\n";
    local inParty = false;
    for i=1, MAX_PARTY_MEMBERS, 1 do
        local name = UnitName("party"..i);
        if (name) then
            if (UnitName("player") ~= name) then
                inParty = true;
                text = text.."    "..name.." - ";

                local race = UnitRace("party"..i);
                if (race) then
                    text = text..race.." ";
                end

				local class = UnitClass("party"..i);
                if (class) then
                    text = text..class.." ";
                end

                level = UnitLevel("party"..i);
                if (level) then
                    text = text.." lvl "..level;
                end
                text = text.."\n";
            end
        end
    end
    if (inParty) then
        SNE_AppendText(text);
    end
end

local function fixnilempty(...)
  for i=1, arg.n, 1 do
    if(not arg[i]) then
      arg[i] = "";
    end
  end
  return arg;
end

function SocialNotesEditor_OnAddLocationButtonClick()
    local text = "\nLocation of "..UnitName("player");

    local continent = GetCurrentMapContinent();
    if (continent) then
        local continentName = continent;

        local continents = fixnilempty(GetMapContinents());
        print1("continents: "..asText(continents));
        if (continents and continents[continent]) then
            continentName = continents[continent];
        end

        text = text.."\n    Continent: "..continentName;

        local zoneName = GetMinimapZoneText();
        if (not zoneName) then
            zone = GetCurrentMapZone();
            if (zone) then
                local zones = fixnilempty(GetMapZones(continent));
                print1("zones: "..asText(zones));
                if (zones and zones[zone]) then
                    zoneName = zones[zone];
                end
            end
        end
        if (zoneName) then
            if (text) then
                text = text.."\n    zone: "..zoneName;
            else
                text = "\n    zone: "..zoneName;
            end
        end
    end

    local px, py = GetPlayerMapPosition("player");
    if (px and py) then
        local coords = format("(%d, %d)", px * 100.0, py * 100.0);
        if (text) then
            text = text.."\n    tloc: "..coords;
        else
            text = "\n    tloc: "..coords;
        end
    end
    if (text) then
        SNE_AppendText(text);
    end
end
