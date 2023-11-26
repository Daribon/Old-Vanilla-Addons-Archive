-- -*- Mode: lua; indent-tabs-mode: nil; lua-indent-level: 2; -*-
--
--  RaidMinion 2
--
--  Author(s):  Vladimir Vukicevic <vladimir@pobox.com>
--  Copyright (C) 2005  Vladimir Vukicevic  <vladimir@pobox.com>
--

----------------------------------------------------------------------
----
---- UI stuff
----
----------------------------------------------------------------------

RM_MAX_TABS = 5;
RM_MAX_PLAYERS_PER_TAB = 10;
RM_NUM_DEBUFF_ICONS = 4;

-- saved, whether the tabs appear only when
-- in a raid.
RM_TabsOnlyInRaid = true;

-- saved, indexed by tab, then an array of players
RM_TabPlayers = { };

-- saved, indexed by tab
RM_TabNames = {
  "Tab 1",
  "Tab 2",
  "Tab 3",
  "Tab 4",
  "Tab 5"
};

-- saved
RM_TabOptions = nil;

-- not saved, quick way to find per-player what
-- to update
RM_PlayerButtonsByName = { };

--
--  Initialize the RM UI bits
--
RM_Orig_RaidGroupButton_OnMouseDown = nil;
RM_Orig_RaidGroupButton_OnMouseUp = nil;
function RaidMinion_UI_Init()
  -- Initialize RM_TabOptions if never set before
  if (RM_TabOptions == nil) then
    RM_TabOptions = { };
    for n=1, RM_MAX_TABS do
      RM_TabOptions[n] = { updateLabel = "hp" };
    end
  end

  -- Hook RaidFrame.lua functions
  RM_Orig_RaidGroupButton_OnMouseDown = RaidGroupButton_OnMouseDown;
  RM_Orig_RaidGroupButton_OnMouseUp = RaidGroupButton_OnMouseUp;
  RaidGroupButton_OnMouseDown = RaidMinion_RaidGroupButton_OnMouseDown;
  RaidGroupButton_OnMouseUp = RaidMinion_RaidGroupButton_OnMouseUp;

  -- Register our /rm handler
  Sky.registerSlashCommand({ id = "RaidMinionCommand",
                             commands = {"/rm"},
                             onExecute = RaidMinion_OnSlashCommand });

  -- Register for RM backend notifications
  RaidMinion_RegisterForPlayerUpdate(RaidMinion_UI_PlayerUpdate);
  RaidMinion_RegisterForRaidUpdate(RaidMinion_UI_RaidUpdate);
  RaidMinion_RegisterForPlayerDebuffUpdate(RaidMinion_UI_PlayerDebuffUpdate);
end

function RaidMinion_UI_PlayerUpdate(pname, pdata)
  RaidMinion_UI_UpdateDataForPlayer(pname, pdata);
end

function RaidMinion_UI_RaidUpdate(cmd, roster)
  if (cmd == "join") then
    RaidMinion_UI_JoinedRaid();
  elseif (cmd == "leave") then
    RaidMinion_UI_LeftRaid();
  elseif (cmd == "roster") then
    for raider,rinfo in roster do
      RaidMinion_UI_UpdateDataForPlayer(raider);
    end

    -- check if we have any tabs that are class-locked
    for n=1, RM_MAX_TABS do
      RaidMinion_UI_ClassLock_UpdateTab(n, roster);
    end
  end
end

function RaidMinion_UI_PlayerDebuffUpdate(pname, ddata)
  RaidMinion_UI_UpdateDebuffsForPlayer(pname, ddata);
end

--
--  RaidFrame.lua hooked functions
--

function RaidMinion_RaidGroupButton_OnMouseDown(button)
  if (button == "RightButton" and IsControlKeyDown()) then
    local raider = this.name;
    local menu = { };
    table.insert (menu, {
                    text = "RaidMinion",
                    isTitle = 1
                  });

    for n=1, RM_MAX_TABS do
      -- if we can't add any more to the given tab, disable the menu item
      local dis = nil;
      if (not RaidMinion_UI_IsTabValidForAdd(n, nil)) then
        dis = 1;
      end

      local tabnum = n;
      table.insert (menu, {
                      text = "Add to " .. RM_TabNames[n] .. " (" .. n .. ")";
                      func = function ()
                               RaidMinion_UI_AddPlayerToTab(raider, tabnum);
                             end,
                      disabled = dis
                    });
    end
    EarthMenu_MenuOpen(menu, this:GetName(), 0, 0, "MENU");
--  elseif (button == "LeftButton"
--          and not IsShiftKeyDown()
--          and not IsControlKeyDown()
--          and not IsAltKeyDown())
--  then
--    -- let people click on raid tab players to target
--    local raider = this.name;
--    TargetByName(raider);
  else
    return RM_Orig_RaidGroupButton_OnMouseDown(button);
  end
end

function RaidMinion_RaidGroupButton_OnMouseUp(button)
  -- we know this function doesn't do anything exciting on RightButton,
  -- so we don't have to hide our own RightButton intercepts from it
  return RM_Orig_RaidGroupButton_OnMouseUp(button);
end

--
-- repopulate everything
--
function RaidMinion_UI_Update()
  -- we'll repopulate this
  RM_PlayerButtonsByName = { };

  for tabn=1, RM_MAX_TABS do
    local tab = getglobal("RaidMinionTab" .. tabn);
    local tabTitle = getglobal("RaidMinionTab" .. tabn .. "Title");

    local tabScale = RaidMinion_UI_GetTabOption(tabn, "tabScale");
    if (tabScale) then
      tab:SetScale(tabScale);
    end

    local classLock = RaidMinion_UI_GetTabOption(tabn, "classLock");

    local titleSuffix = "";
    if (classLock) then
      titleSuffix = titleSuffix .. "*";
    end

    tabTitle:SetText(RM_TabNames[tabn] .. titleSuffix);

    if (RM_TabPlayers[tabn] and table.getn(RM_TabPlayers[tabn]) > 0) then
      tab:Show();

      for playern=1, RM_MAX_PLAYERS_PER_TAB do
        local idx = (tabn-1) * RM_MAX_PLAYERS_PER_TAB + playern;
        local player = RM_TabPlayers[tabn][playern];

        local ps = "RaidMinionPlayer" .. idx;
        local p = getglobal(ps);
        local pName = getglobal(ps .. "Name");
        local pNumLabel = getglobal(ps .. "NumLabel");
        local pHealthBar = getglobal(ps .. "HealthBar");
        local pManaBar = getglobal(ps .. "ManaBar");

        if (player) then
          p:Show();
          local pName = getglobal(ps .. "Name");
          pName:SetText(player);
          pNumLabel:SetText("");
          pHealthBar:SetMinMaxValues(0.0, 1.0);
          pManaBar:SetMinMaxValues(0.0, 1.0);

          if (RM_PlayerButtonsByName[player]) then
            table.insert(RM_PlayerButtonsByName[player], idx);
          else
            RM_PlayerButtonsByName[player] = { idx };
          end

          -- RM_RaidData[player] may be nil
          RaidMinion_UI_UpdateDataForPlayerIndex(idx, player, RM_RaidData[player]);
          RaidMinion_UI_UpdateDebuffsForPlayerIndex(idx, player, RM_RaidDebuffData[player]);
        else
          p:Hide();
        end
      end
    else
      tab:Hide();
      for playern=1, RM_MAX_PLAYERS_PER_TAB do
        local idx = (tabn-1) * RM_MAX_PLAYERS_PER_TAB + playern;
        getglobal("RaidMinionPlayer" .. idx):Hide();
      end
    end
  end
end

--
-- Update just this player's info
--
function RaidMinion_UI_UpdateDataForPlayer(name, data)
  -- Not shown, nothing to do
  if (not RM_PlayerButtonsByName[name]) then
    return;
  end

  if (not data and RM_RaidData) then
    data = RM_RaidData[name];
  end

--  if (data) then
--    Sea.IO.dprint(RM_DEBUG, "RM: UpdateDataForPlayer " .. name .. " hp: " .. data.hp .. "/" .. data.hpmax .. " mana: " .. data.mana .. "/" .. data.manamax);
--  else
--    Sea.IO.dprint(RM_DEBUG, "RM: UpdateDataForPlayer " .. name .. " ??");
--  end

  for n=1, table.getn(RM_PlayerButtonsByName[name]) do
    local idx = RM_PlayerButtonsByName[name][n];

    RaidMinion_UI_UpdateDataForPlayerIndex(idx, name, data);
  end
end

--
-- Update the display portion of the given player frame index
-- for the given player data
--
function RaidMinion_UI_UpdateDataForPlayerIndex(idx, name, data)
  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  local ps = "RaidMinionPlayer" .. idx;
  local p = getglobal(ps);
  local pName = getglobal(ps .. "Name");
  local pNumLabel = getglobal(ps .. "NumLabel");
  local pHealthBar = getglobal(ps .. "HealthBar");
  local pManaBar = getglobal(ps .. "ManaBar");

  if (not data) then
    pNumLabel:SetText("?");
    pHealthBar:SetValue(0);
    pManaBar:SetValue(0);
    return;
  end

  local updateNumLabel = RaidMinion_UI_GetTabOption(tabn, "updateLabel");

  if (not updateNumLabel) then
    pNumLabel:SetText("");
  end

  -- the name is set in _Update(), which happens whenever
  -- we add/remove a player.  It would be nice to be able to set
  -- the mana bar color there as well, but i'm hoping that
  -- the SetStatusBarColor call just changes a vertex color
  -- somewhere (which is cheap).
  if (not data.hpmax or data.hpmax == 0) then
    if (updateNumLabel == "hp") then
      pNumLabel:SetText(0);
      pNumLabel:SetTextColor(0.0, 0.9, 0.0);
    end
    pHealthBar:SetValue(0);
  else
    if (updateNumLabel == "hp") then
      pNumLabel:SetText(data.hp);
      pNumLabel:SetTextColor(0.0, 0.9, 0.0);
    end
    local val = data.hp / data.hpmax;

    -- lerp between green (0.90), yellow (0.60), red (0.20)
    -- for health
    if (val > 0.90) then
      pHealthBar:SetStatusBarColor(0.0, 1.0, 0.0);
    elseif (val > 0.60) then
      local vp = (val - 0.60) / (0.90 - 0.60);
      pHealthBar:SetStatusBarColor((1.0 - vp) * 1.0, 1.0, 0.0);
    elseif (val > 0.20) then
      local vp = (val - 0.20) / (0.60 - 0.20);
      pHealthBar:SetStatusBarColor(1.0, vp * 1.0, 0.0);
    else
      pHealthBar:SetStatusBarColor(1.0, 0.0, 0.0);
    end

    pHealthBar:SetValue(val);
  end

  -- mana/rage/etc. always have numbers that are bluish in color
  if (not data.manamax or data.manamax == 0) then
    if (updateNumLabel == "mana") then
      pNumLabel:SetText(0);
      pNumLabel:SetTextColor(0.6, 0.6, 1.0);
    end
    pManaBar:SetValue(0);
  else
    if (updateNumLabel == "mana") then
      pNumLabel:SetText(data.mana);
      pNumLabel:SetTextColor(0.6, 0.6, 1.0);
    end
    pManaBar:SetStatusBarColor(ManaBarColor[data.manatype].r,
                               ManaBarColor[data.manatype].g,
                               ManaBarColor[data.manatype].b);
    pManaBar:SetValue(data.mana / data.manamax);
  end
end

--
-- Hide various things
--
function RaidMinion_UI_HideTabs()
  for n=1, RM_MAX_TABS do
    local tab = getglobal("RaidMinionTab" .. n);
    tab:Hide();
  end
end

function RaidMinion_UI_ShowTabs()
  for n=1, RM_MAX_TABS do
    if (RM_TabPlayers[n]) then
      local tab = getglobal("RaidMinionTab" .. n);
      tab:Show();
    end
  end
end

-- clear everyone's hp/mana to 0
function RaidMinion_UI_ClearData()
  for idx=1, RM_MAX_TABS*RM_MAX_PLAYERS_PER_TAB do
    local ps = "RaidMinionPlayer" .. idx;
    local pHealthBar = getglobal(ps .. "HealthBar");
    local pManaBar = getglobal(ps .. "ManaBar");

    pHealthBar:SetValue(0);
    pManaBar:SetValue(0);
  end
end

--
-- Called when we join/leave the raid,
-- so we can update our UI (show/hide tabs,
-- and reset hp)
--
function RaidMinion_UI_JoinedRaid()
  RaidMinion_UI_ClearData();
  RaidMinion_UI_Update();
end

function RaidMinion_UI_LeftRaid()
  RaidMinion_UI_ClearData();
  if (RM_TabsOnlyInRaid) then
    RaidMinion_UI_HideTabs();
  end
end

--
-- Add the given player to tab N
--
function RaidMinion_UI_AddPlayerToTab(player, tabn, ignoreCheck)
  if (not ignoreCheck and not RaidMinion_UI_IsTabValidForAdd(tabn, true)) then
    return;
  end

  if (not RM_TabPlayers[tabn]) then
    RM_TabPlayers[tabn] = {};
  end

  table.insert(RM_TabPlayers[tabn], player);

  RaidMinion_UI_Update();
end

--
-- Remove the player from tabn
--
function RaidMinion_UI_RemovePlayerFromTab(player, tabn)
  if (not RM_TabPlayers[tabn]) then
    Sea.io.error ("RaidMinion: Tab " .. tabn .. " has no players!");
    return;
  end

  -- loop through this tab, removing all instances of this player
  local found;
  repeat
    found = nil;
    for n=1, RM_MAX_PLAYERS_PER_TAB do
      if (RM_TabPlayers[tabn][n] == player) then
        table.remove(RM_TabPlayers[tabn], n);
        found = true;
      end
    end
  until (not found);

  RaidMinion_UI_Update();
end

--
-- Remove the player in a given index
--
function RaidMinion_UI_RemovePlayerAtIndex(idx)
  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  if (not RM_TabPlayers[tabn] or table.getn(RM_TabPlayers[tabn]) < pnum) then
    Sea.io.error("RaidMinion: Index " .. idx .. " in RemovePlayerAtIndex is invalid.");
    return;
  end

  table.remove(RM_TabPlayers[tabn], pnum);

  RaidMinion_UI_Update();
end

--
-- Tab options
--
function RaidMinion_UI_SetTabOption(tabn, option, value)
  if (not RM_TabOptions[tabn]) then
    RM_TabOptions[tabn] = { };
  end

  RM_TabOptions[tabn][option] = value;

  -- force an update
  RaidMinion_UI_Update();
end

function RaidMinion_UI_GetTabOption(tabn, option)
  if (RM_TabOptions[tabn]) then
    return RM_TabOptions[tabn][option];
  end
  return nil;
end

function RaidMinion_UI_AddTabOptionListItem(tabn, option, value)
  if (RaidMinion_UI_HasTabOptionListItem(tabn, option, value)) then
    return;
  end

  if (not RM_TabOptions[tabn]) then
    RM_TabOptions[tabn] = { };
  end

  if (not RM_TabOptions[tabn][option]) then
    RM_TabOptions[tabn][option] = { };
  end

  table.insert (RM_TabOptions[tabn][option], value);
end

function RaidMinion_UI_RemoveTabOptionListItem(tabn, option, value)
  if (not RM_TabOptions[tabn] or not RM_TabOptions[tabn][option]) then
    return;
  end

  for n=1,table.getn(RM_TabOptions[tabn][option]) do
    if  (RM_TabOptions[tabn][option][n] == value) then
      table.remove(RM_TabOptions[tabn][option], n);
      return;
    end
  end
end

function RaidMinion_UI_HasTabOptionListItem(tabn, option, value)
  if (not RM_TabOptions[tabn] or not RM_TabOptions[tabn][option]) then
    return false;
  end

  for n=1,table.getn(RM_TabOptions[tabn][option]) do
    if (RM_TabOptions[tabn][option][n] == value) then
      return true;
    end
  end

  return;
end

--
-- Tab mouse handling, incl. dragging
--
function RaidMinion_UI_TabMouseDown(button)
  local tabn = this:GetID();

  if (button == "LeftButton") then
    this:StartMoving();
  elseif (button == "RightButton") then
    local c;

    local menu = { };

    --
    --  Label section
    --
    local updateLabel = RaidMinion_UI_GetTabOption(tabn, "updateLabel");
    table.insert (menu, {
                    text = "Label",
                    isTitle = 1
                  });
    if (updateLabel == nil) then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "None",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "updateLabel", nil);
                           end,
                    checked = c
                  });
    if (updateLabel == "hp") then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "Health",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "updateLabel", "hp");
                           end,
                    checked = c
                  });
    if (updateLabel == "mana") then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "Mana",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "updateLabel", "mana");
                           end,
                    checked = c
                  });
    if (updateLabel == "debuffs") then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "Debuffs",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "updateLabel", "debuffs");
                           end,
                    checked = c
                  });

    --
    --  Debuffs section
    --
    local showDebuffs = RaidMinion_UI_GetTabOption(tabn, "showDebuffs");
    table.insert (menu, {
                    text = "Debuff Icons",
                    isTitle = 1
                  });
    if (not showDebuffs) then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "Hide Debuffs",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "showDebuffs", nil);
                             RaidMinion_UI_HideDebuffsForTab(tabn);
                           end,
                    checked = c});
    if (showDebuffs) then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "Show Debuffs",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "showDebuffs", true);
                           end,
                    checked = c});

    --
    --  Create the Class Lock section
    --
    table.insert (menu, {
                    text = "Class Lock",
                    isTitle = 1
                  });

    local classLock = RaidMinion_UI_GetTabOption(tabn, "classLock");

    local classes;
    local _, fname = UnitFactionGroup("player");
    if (fname == "Horde") then
      classes = {
        { "DRUID", "Druid" },
        { "HUNTER", "Hunter" },
        { "MAGE", "Mage" },
        { "PRIEST", "Priest" },
        { "ROGUE", "Rogue" },
        { "SHAMAN", "Shaman" },
        { "WARLOCK", "Warlock" },
        { "WARRIOR", "Warrior" }
      };
    else
      classes = {
        { "DRUID", "Druid" },
        { "HUNTER", "Hunter" },
        { "MAGE", "Mage" },
        { "PALADIN", "Paladin" },
        { "PRIEST", "Priest" },
        { "ROGUE", "Rogue" },
        { "WARLOCK", "Warlock" },
        { "WARRIOR", "Warrior" }
      };
    end

    if (classLock == nil) then c = 1; else c = nil; end
    table.insert (menu, {
                    text = "None",
                    func = function()
                             RM_TabPlayers[tabn] = nil;
                             RaidMinion_UI_SetTabOption(tabn, "classLock", nil);
                           end,
                    checked = c
                  });

    for k,v in classes do
      if (RaidMinion_UI_HasTabOptionListItem(tabn, "classLock", v[1])) then
        c = 1;
      else
        c = nil;
      end

      local vname = v[1];
      if (c) then
        table.insert (menu, {
                      text = v[2],
                      func = function()
                               RaidMinion_UI_RemoveTabOptionListItem(tabn, "classLock", vname);
                               RaidMinion_UI_ClassLock_UpdateTab(tabn);
                             end,
                      checked = c
                    });
      else
        table.insert (menu, {
                      text = v[2],
                      func = function()
                               RaidMinion_UI_AddTabOptionListItem(tabn, "classLock", vname);
                               RaidMinion_UI_ClassLock_UpdateTab(tabn);
                             end,
                      checked = c
                    });
      end
    end

    --
    --  Open the menu
    --
    EarthMenu_MenuOpen(menu, this:GetName(), 0, 0, "MENU");
  end
end

function RaidMinion_UI_TabMouseUp(button)
  local tabn = this:GetID();

  if (button == "LeftButton") then
    this:StopMovingOrSizing();
  end
end

function RaidMinion_UI_PlayerMouseDown(idx, button)
  if (button == "LeftButton") then
    local player = RaidMinion_UI_PlayerNameAtIndex(idx);
    local spelltargetting = SpellIsTargeting();
    TargetByName(player);
    if (not spelltargetting and UnitName("target") ~= player) then
      Sea.io.error("Out of range to target " .. player .. "!");
    end
  elseif (button == "RightButton") then
    local menu = { };

    table.insert (menu, {
                    text = "Remove from tab",
                    func = function()
                             RaidMinion_UI_RemovePlayerAtIndex(idx);
                           end
                  });
    EarthMenu_MenuOpen(menu, this:GetName(), 0, 0, "MENU");
  end
end

--
--  Slash command
--
function RaidMinion_UI_ShowUsage()
  local RM_Usage = {
    "/rm show [tab#] -- show all tabs or tab tab#",
    "/rm hide [tab#] -- hide all tabs or tab tab#",
    "/rm add tab# player1 [player2 ...] -- add player1 player2 etc. to tab number tab#",
    "/rm clear [tab#] -- clear players from all tabs or tab#",
    "/rm rename tab# newname -- rename tab# to newname",
--    "/rm scale [tab#] scale -- set scale of tab# or all tabs to scale (number)", -- hidden
    "/rm refresh -- refresh all tabs",
    "/rm resetpos -- reset all tab positions and scales",
    "/rm reset -- reset tab options and names"
  };
  for n=1, table.getn(RM_Usage) do
    Sea.io.print(RM_Usage[n]);
  end
end

function RaidMinion_OnSlashCommand(arg)
  if (arg == "" or arg == nil) then
    RaidMinion_UI_ShowUsage();
    return;
  end

  local args = Sea.util.split(arg, " ");
  if (args[1] == "show") then
    if (args[2]) then
      local tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
      getglobal("RaidMinionTab" .. tabn):Show();
    else
      RaidMinion_UI_ShowTabs();
      RaidMinion_UI_Update();
    end
  elseif (args[1] == "hide") then
    if (args[2]) then
      local tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
      getglobal("RaidMinionTab" .. tabn):Hide();
    else
      RaidMinion_UI_HideTabs();
    end
  elseif (args[1] == "add") then
    if (table.getn(args) < 3) then RaidMinion_UI_ShowUsage(); return; end
    local tabn = tonumber(args[2]);
    if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
    for n=3, table.getn(args) do
      local pname = args[n];
      -- capitalize first letter
      pname = string.upper(string.sub(pname, 1, 1)) .. string.lower(string.sub(pname, 2));
      RaidMinion_UI_AddPlayerToTab(pname, tabn);
    end
  elseif (args[1] == "clear") then
    if (args[2]) then
      local tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
      RM_TabPlayers[tabn] = nil;
    else
      RM_TabPlayers = { };
    end
    RaidMinion_UI_Update();
  elseif (args[1] == "rename") then
    if (table.getn(args) ~= 3) then RaidMinion_UI_ShowUsage(); return; end
    local tabn = tonumber(args[2]);
    if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
    RM_TabNames[tabn] = args[3];
    RaidMinion_UI_Update();
  elseif (args[1] == "scale") then
    if (table.getn(args) ~= 2 and table.getn(args) ~= 3) then RaidMinion_UI_ShowUsage(); return; end
    if (table.getn(args) == 2) then
      local scale = tonumber(args[2]);
      for n=1,RM_MAX_TABS do
        RaidMinion_UI_SetTabOption(n, "tabScale", scale);
      end
    else
      local tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end

      local scale = tonumber(args[3]);
      RaidMinion_UI_SetTabOption(tabn, "tabScale", scale);
    end
  elseif (args[1] == "resetpos") then
    for n=1,RM_MAX_TABS do
      RaidMinion_UI_SetTabOption(n, "tabScale", nil);
      local tab = getglobal("RaidMinionTab" .. n);
      tab:SetScale(GetCVar("uiscale"));
      tab:ClearAllPoints();
      tab:SetPoint("CENTER", "UIParent", "CENTER");
    end
  elseif (args[1] == "reset") then
    RM_TabOptions = {};
    RM_TabPlayers = {};
    for n=1,RM_MAX_TABS do
      RM_TabOptions[n] = { updateLabel = "hp" };
    end
    RaidMinion_UI_Update();
  elseif (args[1] == "setopt") then
    local tabn = tonumber(args[2]);
    local opt = arg[3];
    local val = arg[4];
    if (val == "nil") then val = nil; end
    RaidMinion_UI_SetTabOption(tabn, opt, val);
  elseif (args[1] == "refresh") then
    RaidMinion_UI_Update();
  else
    RaidMinion_UI_ShowUsage();
  end
end

--
--  Utils
--
function RaidMinion_UI_IsTabValidForAdd(tabn, doerror)
  if (tabn <= 0 or tabn > RM_MAX_TABS) then
    if (doerror) then
      Sea.io.error ("RaidMinion: Can't add player to non-existant tab " .. tabn);
    end
    return false;
  end

  if (RM_TabPlayers[tabn] and table.getn(RM_TabPlayers[tabn]) >= RM_MAX_PLAYERS_PER_TAB) then
    if (doerror) then
      Sea.io.error ("RaidMinion: Too many players in tab " .. tabn .. ", please remove some.");
    end
    return false;
  end

  if (RaidMinion_UI_GetTabOption(tabn, "classLock")) then
    if (doerror) then
      Sea.io.error ("RaidMinion: Tab " .. tabn .. " has a class set; you cannot manually add players to it.");
      Sea.io.error ("Remove the class setting and try again.");
    end
    return false;
  end
  return true;
end

function RaidMinion_UI_PlayerNameAtIndex(idx)
  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  if (not RM_TabPlayers[tabn]) then
    return nil;
  end

  return RM_TabPlayers[tabn][pnum];
end

--
--  ClassLock handling
--

function RaidMinion_UI_ClassLock_UpdateTab(tabn, roster)
  if (not roster) then
    roster = RaidMinion_GetRoster();
  end

  if (not roster) then
    return;
  end

  local classLock = RaidMinion_UI_GetTabOption(tabn, "classLock");
  if (not classLock) then
    return;
  end

  -- first remove; it's too bad it's easier to munge
  -- this by hand
  local curnames = { };
  local numnames = 0;
  local tabplayers = RM_TabPlayers[tabn];
  if (tabplayers) then
    for n=RM_MAX_PLAYERS_PER_TAB,1,-1 do
      local name = tabplayers[n];
      if (name) then
        -- duplicate or wrong class
        if (curnames[name] or (not roster[name] or not RaidMinion_UI_HasTabOptionListItem(tabn, "classLock", roster[name].class))) then
          table.remove(RM_TabPlayers[tabn], n);
        else
          curnames[name] = true;
          numnames = numnames + 1;
        end
      end
    end
  end

  -- then add any that are missing
  for raider,rinfo in roster do
    if (RaidMinion_UI_HasTabOptionListItem(tabn, "classLock", rinfo.class)) then
      if (not curnames[raider] and numnames <= RM_MAX_PLAYERS_PER_TAB) then
        RaidMinion_UI_AddPlayerToTab(raider, tabn, true);
        curnames[raider] = true;
        numnames = numnames + 1;
      end
    end
  end

  RaidMinion_UI_Update();
end

--
--  Debuff display
--

function RaidMinion_UI_UpdateDebuffsForPlayer(pname, ddata)
  if (not RM_PlayerButtonsByName[pname]) then
    return;
  end

  if (not ddata) then
    ddata = RM_RaidDebuffData[pname];
  end

  for n=1, table.getn(RM_PlayerButtonsByName[pname]) do
    local idx = RM_PlayerButtonsByName[pname][n];
    RaidMinion_UI_UpdateDebuffsForPlayerIndex(idx, pname, ddata);
  end
end

function RaidMinion_UI_UpdateDebuffsForPlayerIndex(idx, pname, ddata)
  if (not ddata) then
    ddata = {};
  end

  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  local showIcons = RaidMinion_UI_GetTabOption(tabn, "showDebuffs");
  local showText = (RaidMinion_UI_GetTabOption(tabn, "updateLabel") == "debuffs");

  if (showText) then
    local types = {};
    local isPoisoned, isDiseased, isCursed, isMagicd;
    for n=1,table.getn(ddata) do
      types[ddata[n].type] = true;
    end

    local str = "";
    if (types["OTHER"]) then str = str .. "O"; end
    if (types["POISON"]) then str = str .. "P"; end
    if (types["DISEASE"]) then str = str .. "D"; end
    if (types["CURSE"]) then str = str .. "C"; end
    if (types["MAGIC"]) then str = str .. "M"; end
    
    getglobal("RaidMinionPlayer" .. idx .. "NumLabel"):SetText(str);
    getglobal("RaidMinionPlayer" .. idx .. "NumLabel"):SetTextColor(0.9, 0.0, 0.0);
  end

  if (showIcons) then
    for didx=1,RM_NUM_DEBUFF_ICONS do
      if (ddata[didx]) then
        getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx .. "Icon"):SetTexture("Interface\\Icons\\" .. ddata[didx].texture);
        getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx):Show();
      else
        getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx):Hide();
      end
    end
  end
end

function RaidMinion_UI_HideDebuffsForTab(tabn)
  for n=1,RM_MAX_PLAYERS_PER_TAB do
    local idx = (tabn-1) * 10 + n;
    for j=1,RM_NUM_DEBUFF_ICONS do
      getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. j):Hide();
    end
  end
end

RM_UI_DebuffNames = {
  POISON = "Poison",
  CURSE = "Curse",
  DISEASE = "Disease",
  MAGIC = "Magic"
};

function RaidMinion_UI_DebuffButton_OnEnter()
  local idx = this:GetParent():GetID();
  local name = RaidMinion_UI_PlayerNameAtIndex(idx);

  local buffidx = this:GetID();

  if (not RM_RaidDebuffData[name] or not RM_RaidDebuffData[name][buffidx]) then
    return;
  end

  local ddata = RM_RaidDebuffData[name][buffidx];

  GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
  if (RM_UI_DebuffNames[ddata.type]) then
    GameTooltip:SetText(ddata.name .. "     " .. RM_UI_DebuffNames[ddata.type]);
  else
    GameTooltip:SetText(ddata.name);
  end
end

function RaidMinion_UI_TabAndPlayerFromIndex(idx)
  local tabn = math.floor((idx-1)/10) + 1;
  local pnum = idx - (tabn-1) * RM_MAX_PLAYERS_PER_TAB;

  return tabn, pnum;
end
