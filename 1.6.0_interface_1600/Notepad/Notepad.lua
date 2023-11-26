-- -*- mode: lua; indent-tabs-mode: nil; tab-width: 20; lua-indent-level: 3; -*-

--
-- Notepad.lua
-- Copyright (C) 2004  Vladimir Vukicevic
--
-- Author(s): Vladimir Vukicevic <vladimir@pobox.com>
--
-- This file is part of the Notepad AddOn for Blizzard Entertainment
-- Inc.'s World of Warcraft.
--

--
-- Notepad entries
--

-- All the entries; this is an array of tables,
-- with each table having a "title" and "body" attribute.
Notepad_Entries = {};

-- Currently selected entry. 0 = no/new entry.
Notepad_SelectedEntry = 0;

RegisterForSave("Notepad_Entries");
RegisterForSave("Notepad_SelectedEntry");

--
-- UI goop
--

-- Are we resizing?
local Notepad_IsResizing = 0;

-- The number of visible entry buttons
local Notepad_NumVisibleEntryButtons = 0;
local Notepad_CurrentOffset = 0;

-- this is the max number of buttons that we have available, numbered 1 through this value
NOTEPAD_MAX_BUTTONS = 25;

-- On loading, make sure that our current button state is set up, and do UI
-- hook setup
function Notepad_Toggle()
   if (NotepadFrame:IsVisible()) then
      NotepadFrame:Hide();
   else
      NotepadFrame:Show();
   end
end

function Notepad_OnLoad()
   this:RegisterForDrag("LeftButton");
   this:RegisterEvent("VARIABLES_LOADED");


-- ======================================================
-- Start of Ultimate UI Spellbook Registration
-- ======================================================
	if ( UltimateUI_RegisterButton ) then
		UltimateUI_RegisterButton (TEXT(NOTEPAD_BUTTON_NAME),
			"Show",
			"Gives you an easy to use notepad for WoW",
			"Interface\\AddOns\\Notepad\\Notepad_Icon",
			Notepad_Toggle
		);
	end
-- ======================================================
-- End of Ultimate UI Spellbook Registration
-- ======================================================
   Notepad_UpdateEntryList();
end

-- Take the window's current height and how the appropriate number of buttons
function Notepad_UpdateEntryButtonVisibility()
   local buttonHeight, frameHeight, numButtons, numEntries;

   local uiScale = GetCVar("uiscale");

   buttonHeight = 20;
   frameHeight = NotepadEntriesScrollFrame:GetHeight() + 5; -- 5 seems to be a magic fudge factor!
   if (uiScale) then
      frameHeight = frameHeight / uiScale;
   end

   numButtons = frameHeight / buttonHeight;
   numEntries = getn(Notepad_Entries);

   --print1 ("Notepad_UpdateEntryButtonVisibility fh: " .. frameHeight .. " nb: " .. numButtons .. " ne: " .. numEntries);

   for i=1, NOTEPAD_MAX_BUTTONS do
      local theButton = getglobal ("NotepadEntry" .. i);
      if ( i <= numButtons and i <= numEntries ) then
         theButton:Show();
      else
         theButton:Hide();
      end
   end

   Notepad_NumVisibleEntryButtons = floor(numButtons);
end

-- Figure out where to set the various faux scroll frame bits
function Notepad_UpdateScrollFrame()
   FauxScrollFrame_Update(NotepadEntriesScrollFrame,
                          table.getn(Notepad_Entries),
                          Notepad_NumVisibleEntryButtons,
                          32);
end

--
-- Notepad event handler
--
-- We only care about VARIABLES_LOADED, so that we can load the previously
-- selected entry and initialize the scroll frame
Notepad_VarsLoaded = 0;
function Notepad_OnEvent(event)
   if ( (event == "VARIABLES_LOADED") and (Notepad_VarsLoaded == 0) ) then
      -- we finally (!) have our variables loaded, grrr
      Notepad_UpdateEntryList();
      if ( Notepad_SelectedEntry ~= 0 ) then
         Notepad_LoadEntry(Notepad_SelectedEntry);
      end
      Notepad_VarsLoaded = 1;
   end
end

--
-- Drag handlers, for when the window is dragged
function Notepad_OnDragStart()
   this:StartMoving();
end

function Notepad_OnDragStop()
   this:StopMovingOrSizing();
end

-- Called from FauxScrollFrame
function Notepad_UpdateEntriesScrollFrame()
   Notepad_CurrentOffset = FauxScrollFrame_GetOffset(NotepadEntriesScrollFrame);
   for i=1, min(Notepad_NumVisibleEntryButtons, table.getn(Notepad_Entries)) do
      local button = getglobal("NotepadEntry" .. i);
      button:SetText(Notepad_Entries[Notepad_CurrentOffset + i].title);
   end
end

function Notepad_SaveCurrentEntry()
   --print1("Notepad_SaveCurrentEntry " .. Notepad_SelectedEntry);
   local title = NotepadEntryTitleEditBox:GetText();
   local body = NotepadEntryEditBox:GetText();

   -- If the body and title are empty, we don't save
   if (title == "" and body == "") then
      return;
   end

   -- Otherwise
   local entryIndex = Notepad_SelectedEntry;
   if ( entryIndex == 0 ) then
      entryIndex = table.getn(Notepad_Entries) + 1;
      table.setn(Notepad_Entries, entryIndex);
   end

   local entry = {};
   entry.title = title;
   entry.body = body;
   Notepad_Entries[entryIndex] = entry;
   Notepad_SelectedEntry = entryIndex;

   Notepad_UpdateEntryList();
end

function Notepad_UpdateEntryList()
   --print1("Notepad_UpdateEntryList");
   Notepad_UpdateEntryButtonVisibility();
   Notepad_UpdateScrollFrame();
   Notepad_UpdateEntriesScrollFrame();
end

-- Load the entry with the given index.
function Notepad_LoadEntry(aEntryId)
   Notepad_SelectedEntry = aEntryId;
   NotepadEntryTitleEditBox:SetText(Notepad_Entries[aEntryId].title);
   NotepadEntryEditBox:SetText(Notepad_Entries[aEntryId].body);

   if (false) then
      -- is the tab visible?
      if (aEntryId < Notepad_CurrentOffset or
          (Notepad_CurrentOffset + Notepad_NumVisibleEntryButtons) >= aEntryId)
      then
         local newOffset;
         -- no; place it at the start or the end
         if ( aEntryId < Notepad_CurrentOffset ) then
            newOffset = aEntryId;
         else
            newOffset = aEntryId - Notepad_NumVisibleEntryButtons;
         end
         Notepad_CurrentOffset = newOffset;
         FauxScrollFrame_SetOffset(NotepadEntriesScrollFrame, newOffset);
      end
   end
end

function Notepad_ClearEntry()
   --print1("Notepad_ClearEntry");
   Notepad_SelectedEntry = 0;
   NotepadEntryTitleEditBox:SetText("");
   NotepadEntryEditBox:SetText("");
   NotepadEntryTitleEditBox:SetFocus();
end

function Notepad_OnNewButtonClick()
   Notepad_SaveCurrentEntry();
   Notepad_ClearEntry();
end

function Notepad_OnDeleteButtonClick()
   --print1("Notepad_OnDeleteButtonClick " .. Notepad_SelectedEntry);
   if ( Notepad_SelectedEntry ~= 0 ) then
      table.remove(Notepad_Entries, Notepad_SelectedEntry);
   end

   Notepad_ClearEntry();
   Notepad_UpdateEntryList();
end

function Notepad_OnEntryClick(aButtonID)
   Notepad_SaveCurrentEntry();

   local entryId = Notepad_CurrentOffset + aButtonID;
   Notepad_LoadEntry(entryId);
end

function Notepad_OnCloseButtonClick(aArg)
   NotepadFrame:Hide();
end

function Notepad_OnResizeButtonMouseDown(aWhichCorner)
   Notepad_IsResizing = 1;

   this:GetParent():StartSizing(aWhichCorner);
end

function Notepad_OnResizeButtonMouseUp()
   Notepad_IsResizing = 0;

   this:GetParent():StopMovingOrSizing();
end

function Notepad_OnEntryBodyTextChanged()
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

function Notepad_OnEntryTitleEditFocusLost()
   Notepad_SaveCurrentEntry();
end

function Notepad_OnEntryBodyEditFocusLost()
   Notepad_SaveCurrentEntry();
end
