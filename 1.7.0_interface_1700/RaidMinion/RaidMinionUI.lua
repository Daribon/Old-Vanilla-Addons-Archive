-- -*- Mode: lua; indent-tabs-mode: nil; lua-indent-level: 2; -*-
--
--  RaidMinion 2
--
--  Author(s):  Vladimir Vukicevic <vladimir@pobox.com>
--  Copyright (C) 2005  Vladimir Vukicevic  <vladimir@pobox.com>
--
-- $Id: RaidMinionUI.lua 2025 2005-07-02 23:51:34Z Sinaloit $
-- $LastChangedBy: Sinaloit $
-- $Rev: 2025 $
-- $Date: 2005-07-02 18:51:34 -0500 (Sat, 02 Jul 2005) $
--

----------------------------------------------------------------------
----
---- UI stuff
----
----------------------------------------------------------------------

RM_MAX_TABS = 8;
RM_MAX_PLAYERS_PER_TAB = 10;
RM_NUM_DEBUFF_ICONS = 4;
RM_TARGET_TAB = 51;

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
  "Tab 5",
  "Tab 6",
  "Tab 7",
  "Tab 8"
};

-- saved
RM_TabOptions = nil;

-- not saved, quick way to find per-player what
-- to update
RM_PlayerButtonsByName = { };

RM_UI_AllHidden = false;

--
--  Initialize the RM UI bits
--
RM_Orig_RaidGroupButton_OnMouseDown = nil;
RM_Orig_RaidGroupButton_OnMouseUp = nil;
function RaidMinion_UI_Init()
  -- Initialize RM_TabOptions if never set before
  if (RM_TabOptions == nil) then
    RM_TabOptions = { };
  end

  if (RM_TabNames == nil) then
    RM_TabNames = { };
  end

  -- set the target tab name manually
  getglobal("RaidMinionTab" .. RM_TARGET_TAB .. "Title"):SetText("Target");

  for n=1, RM_MAX_TABS do
    if (RM_TabOptions[n] == nil) then
      RM_TabOptions[n] = { updateLabel = "hp" };
    end

    if (RM_TabNames[n] == nil) then
      RM_TabNames[n] = "Tab " .. n;
    end
  end

  -- Hook RaidFrame.lua functions
  RM_Orig_RaidGroupButton_OnMouseDown = RaidGroupButton_OnMouseDown;
  RM_Orig_RaidGroupButton_OnMouseUp = RaidGroupButton_OnMouseUp;
  RaidGroupButton_OnMouseDown = RaidMinion_RaidGroupButton_OnMouseDown;
  RaidGroupButton_OnMouseUp = RaidMinion_RaidGroupButton_OnMouseUp;

  -- Register our /rm handler
  SLASH_RM1 = "/rm";
  SlashCmdList["RM"] = RaidMinion_OnSlashCommand;

  -- Register for RM backend notifications
  RaidMinion_RegisterForPlayerUpdate(RaidMinion_UI_PlayerUpdate);
  --RaidMinion_RegisterForTargetUpdate(RaidMinion_UI_TargetUpdate);
  RaidMinion_RegisterForRaidUpdate(RaidMinion_UI_RaidUpdate);
  RaidMinion_RegisterForPlayerDebuffUpdate(RaidMinion_UI_PlayerDebuffUpdate);

  -- Add Cosmos icons, if cosmos is installed
  if (Cosmos_RegisterButton) then
    Cosmos_RegisterButton ("RaidMinion Raid View",
                           "",
                           "Place all players in the current raid in RaidMinion tabs 1-4.\nOnly useful when in a raid.",
                           "Interface\\Icons\\Spell_Arcane_StarFire",
                           RaidMinion_UI_AutoSetupRaid,
                           function()
                             return RM_IsInRaid;
                           end
                         );

    Cosmos_RegisterButton ("RaidMinion Class View",
                           "",
                           "Assign one class to each RaidMinion tab.\nWill automatically update tabs as players join and leave the raid.\nOnly useful when in a raid.",
                           "Interface\\Icons\\Spell_Arcane_StarFire",
                           RaidMinion_UI_AutoSetupClasses,
                           function()
                             return RM_IsInRaid;
                           end
                         );
  end
end

function RaidMinion_UI_PlayerUpdate(pname, pdata)
  RaidMinion_UI_UpdateDataForPlayer(pname, pdata);
end

function RaidMinion_UI_TargetUpdate(pname, pdata)
  RaidMinion_UI_UpdateDataForTarget(pname, pdata);
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

function RaidMinion_UI_PlayerDebuffUpdate(pname, unit)
  RaidMinion_UI_UpdateDebuffsForPlayer(pname, unit);
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
function RaidMinion_UI_UpdateTab(tabn, istarget)
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

  if (istarget) then
    tabTitle:SetText("Targets");
  else
    tabTitle:SetText(RM_TabNames[tabn] .. titleSuffix);
  end

  local hidden = RaidMinion_UI_GetTabOption(tabn, "hidden");
  if (hidden == nil) then
    if (RM_TabPlayers[tabn] and table.getn(RM_TabPlayers[tabn]) > 0) then
      hidden = false;
    else
      hidden = true;
    end
  end

  if (RM_UI_AllHidden) then
    hidden = true;
  end

  if (hidden == false) then
    tab:Show();

    if (RM_TabPlayers[tabn] == nil) then
      RM_TabPlayers[tabn] = {};
    end

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
        if (not istarget) then
          if (RM_RaidData[player]) then
            RaidMinion_UI_UpdateDataForIndex(idx, player, RM_RaidData[player]);
            RaidMinion_UI_UpdateDebuffsForIndex(idx, player, RM_RaidData[player].unit);
          else
            RaidMinion_UI_UpdateDataForIndex(idx, player, nil);
          end
        else
          RaidMinion_UI_UpdateDataForIndex(idx, player, RM_RaidTargetData[player], true);
        end
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

function RaidMinion_UI_Update()
  -- we'll repopulate this
  RM_PlayerButtonsByName = { };

  for tabn=1, RM_MAX_TABS do
    RaidMinion_UI_UpdateTab(tabn);
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
    local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

    if (tabn ~= RM_TARGET_TAB) then
      RaidMinion_UI_UpdateDataForIndex(idx, name, data);
    end
  end
end

function RaidMinion_UI_UpdateDataForTarget(owner, tdata)
  if (not RM_PlayerButtonsByName[owner]) then
    return;
  end

  if (not data and RM_RaidTargetData) then
    data = RM_RaidTargetData[owner];
  end

  for n=1, table.getn(RM_PlayerButtonsByName[owner]) do
    local idx = RM_PlayerButtonsByName[owner][n];
    local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);
    if (tabn == RM_TARGET_TAB) then
      RaidMinion_UI_UpdateDataForIndex(idx, owner, tdata, true);
      return;
    end
  end
end

--
-- Update the display portion of the given player frame index
-- for the given player data.  If istarget==true, update
-- the data as target data.
--
function RaidMinion_UI_UpdateDataForIndex(idx, name, data, istarget)
  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  local ps = "RaidMinionPlayer" .. idx;
  local p = getglobal(ps);
  local pName = getglobal(ps .. "Name");
  local pNumLabel = getglobal(ps .. "NumLabel");
  local pHealthBar = getglobal(ps .. "HealthBar");
  local pManaBar = getglobal(ps .. "ManaBar");

  -- if it's a target, do some prettifying of the name
  if (istarget) then
    if (data) then
      pName:SetText(data.name);
      if (data.hostile ~= 0) then
        pName:SetVertexColor(1.0, 0.0, 0.0);
      else
        pName:SetVertexColor(0.0, 1.0, 0.0);
      end
      pName:SetAlphaGradient(8,4);
    elseif (name) then
      pName:SetText("T? (" .. name .. ")");
    else
      pName:SetText("T? (?)");
    end
  end

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
      pNumLabel:SetText("0");
      pNumLabel:SetTextColor(0.0, 0.9, 0.0);
    end
    pHealthBar:SetValue(0);
  else
    local val = data.hp / data.hpmax;

    if (updateNumLabel == "hp") then
      if (istarget) then
        pNumLabel:SetText(math.floor(val * 100) .. "%");
      else
        pNumLabel:SetText(data.hp);
      end
      pNumLabel:SetTextColor(0.0, 0.9, 0.0);
    end

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

  if (not istarget) then
    -- mana/rage/etc. always have numbers that are bluish in color
    if (not data.manamax or data.manamax == 0) then
      if (updateNumLabel == "mana") then
        pNumLabel:SetText("0");
        pNumLabel:SetTextColor(0.6, 0.6, 1.0);
      end
      pManaBar:SetValue(0);
    else
      if (updateNumLabel == "mana") then
        pNumLabel:SetText(data.mana);
        pNumLabel:SetTextColor(0.6, 0.6, 1.0);
      end
      if (ManaBarColor[data.manatype]) then
        pManaBar:SetStatusBarColor(ManaBarColor[data.manatype].r,
                                   ManaBarColor[data.manatype].g,
                                   ManaBarColor[data.manatype].b);
      else
        pManaBar:SetStatusBarColor(0.3, 0.3, 0.3);
      end
      pManaBar:SetValue(data.mana / data.manamax);
    end
  else
    -- ignore mana for targets
    pManaBar:SetValue(0);
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

  local ttab = getglobal("RaidMinionTab" .. RM_TARGET_TAB);
  ttab:Hide();

  RM_UI_AllHidden = true;
end

function RaidMinion_UI_ShowTabs()
  RM_UI_AllHidden = false;
  RaidMinion_UI_Update();
end

-- clear everyone's hp/mana to 0
function RaidMinion_UI_ClearData()
  for tabn=1, RM_MAX_TABS do
    for tabi=1, RM_MAX_PLAYERS_PER_TAB do
      local idx = (tabn-1)*RM_MAX_PLAYERS_PER_TAB + tabi;
      local name = nil;
      if (RM_TabPlayers[tabn]) then
        name = RM_TabPlayers[tabn][tabi];
      end

      RaidMinion_UI_UpdateDataForIndex(idx, name, nil);

      -- update the target tab first time through as well
      if (tabn == 1) then
        local idx = (RM_TARGET_TAB-1)*RM_MAX_PLAYERS_PER_TAB + tabi;
        if (RM_TabPlayers[RM_TARGET_TAB]) then
          name = RM_TabPlayers[RM_TARGET_TAB][tabi];
        else
          name = nil;
        end

        RaidMinion_UI_UpdateDataForIndex(idx, name, nil, true);
      end
    end
  end
end

--
-- Called when we join/leave the raid,
-- so we can update our UI (show/hide tabs,
-- and reset hp)
--
function RaidMinion_UI_JoinedRaid()
  RaidMinion_UI_ClearData();
  RaidMinion_UI_ShowTabs();
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

  RaidMinion_UI_SetTabOption(tabn, "hidden", false);

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
    -- Hide
    --
    table.insert (menu, {
                    text = "Hide Tab",
                    func = function()
                             RaidMinion_UI_SetTabOption(tabn, "hidden", true);
                           end
                  });

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

    if (tabn ~= RM_TARGET_TAB) then
      --
      --  Buff/Debuffs section
      --
      local showDebuffs = RaidMinion_UI_GetTabOption(tabn, "showDebuffs");
      local showBuffs = RaidMinion_UI_GetTabOption(tabn, "showBuffs");
      table.insert (menu, {
                      text = "Buff/Debuff Icons",
                      isTitle = 1
                    });
      if ((not showBuffs) and (not showDebuffs)) then c = 1; else c = nil; end
      table.insert (menu, {
                      text = "Hide Both",
                      func = function()
                               RaidMinion_UI_SetTabOption(tabn, "showBuffs", nil);
                               RaidMinion_UI_SetTabOption(tabn, "showDebuffs", nil);
                               RaidMinion_UI_HideDebuffsForTab(tabn);
                             end,
                      checked = c});
      if (showBuffs) then c = 1; else c = nil; end
      table.insert (menu, {
                      text = "Show Buffs",
                      func = function()
                               RaidMinion_UI_SetTabOption(tabn, "showBuffs", true);
                               RaidMinion_UI_SetTabOption(tabn, "showDebuffs", nil);
                             end,
                      checked = c});
      if (showDebuffs) then c = 1; else c = nil; end
      table.insert (menu, {
                      text = "Show Debuffs",
                      func = function()
                               RaidMinion_UI_SetTabOption(tabn, "showBuffs", nil);
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
      local classes = RaidMinion_UI_FactionClasses();

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
    end -- if not RM_TARGET_TAB

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
  Sea.io.print ("RaidMinion " .. RaidMinion_Version .. " -- see http://www.wowwiki.com/RaidMinion for news and updates.");
  local RM_Usage = {
    "/rm show [tab#] -- show all tabs or tab tab#",
    "/rm hide [tab#] -- hide all tabs or tab tab#",
    "/rm add tab# player1 [player2 ...] -- add player1 player2 etc. to tab number tab#",
    "/rm clear [tab#] -- clear players from all tabs or tab#",
    "/rm rename tab# newname -- rename tab# to newname",
--    "/rm scale [tab#] scale -- set scale of tab# or all tabs to scale (number)", -- hidden
    "/rm refresh -- refresh all tabs",
    "/rm resetpos -- reset all tab positions and scales",
    "/rm reset -- reset tab options and names",
    "/rm auto class/raid -- auto-populate tabs by class, or with entire raid in first 4 tabs"
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
    if (args[2] == "target") then
      RaidMinion_UI_SetTabOption(RM_TARGET_TAB, "hidden", false);
    elseif (args[2]) then
      local tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
      RaidMinion_UI_SetTabOption(tabn, "hidden", false);
    else
      RaidMinion_UI_ShowTabs();
    end
  elseif (args[1] == "hide") then
    if (args[2] == "target") then
      RaidMinion_UI_SetTabOption(RM_TARGET_TAB, "hidden", true);
    elseif (args[2]) then
      local tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
      RaidMinion_UI_SetTabOption(tabn, "hidden", true);
    else
      RaidMinion_UI_HideTabs();
    end
  elseif (args[1] == "add") then
    if (table.getn(args) < 3) then RaidMinion_UI_ShowUsage(); return; end
    local tabn;
    if (args[2] == "target") then
      tabn = RM_TARGET_TAB;
    else
      tabn = tonumber(args[2]);
      if (not tabn or tabn < 1 or tabn > RM_MAX_TABS) then RaidMinion_UI_ShowUsage(); return; end
    end

    for n=3, table.getn(args) do
      local pname = args[n];
      -- capitalize first letter
      pname = string.upper(string.sub(pname, 1, 1)) .. string.lower(string.sub(pname, 2));
      RaidMinion_UI_AddPlayerToTab(pname, tabn);
    end
  elseif (args[1] == "clear") then
    if (args[2] == "target") then
      RM_TabPlayers[RM_TARGET_TAB] = nil;
    elseif (args[2]) then
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

    local ttab = getglobal("RaidMinionTab" .. RM_TARGET_TAB);
    ttab:SetScale(GetCVar("uiscale"));
    ttab:ClearAllPoints();
    ttab:SetPoint("CENTER", "UIParent", "CENTER");
  elseif (args[1] == "reset") then
    RM_TabOptions = {};
    RM_TabPlayers = {};
    for n=1,RM_MAX_TABS do
      RM_TabOptions[n] = { updateLabel = "hp" };
    end
    RM_TabOptions[RM_TARGET_TAB] = { updateLabel = "hp" };
    RaidMinion_UI_Update();
  elseif (args[1] == "setopt") then
    local tabn;
    if (args[2] == "target") then tabn = RM_TARGET_TAB;
    else tabn = tonumber(args[2]); end
    local opt = arg[3];
    local val = arg[4];
    if (val == "nil") then val = nil; end
    RaidMinion_UI_SetTabOption(tabn, opt, val);
  elseif (args[1] == "auto") then
    local autotype = args[2];
    if (autotype == "class") then
      RaidMinion_UI_AutoSetupClasses();
    elseif (autotype == "raid") then
      RaidMinion_UI_AutoSetupRaid();
    else
      RaidMinion_UI_ShowUsage();
    end
  --elseif (args[1] == "target") then
  --  if (args[2] == "on") then
  --    RaidMinion_SetSendMyTargetUpdates(true);
  --    Sea.io.print ("RaidMinion: Target updates enabled.");
  --  else
  --    RaidMinion_SetSendMyTargetUpdates(nil);
  --    Sea.io.print ("RaidMinion: Target updates disabled.");
  --  end
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
  if ((tabn <= 0 or tabn > RM_MAX_TABS) and tabn ~= RM_TARGET_TAB) then
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

function RaidMinion_UI_UpdateDebuffsForPlayer(pname, unit)
  if (not RM_PlayerButtonsByName[pname]) then
    return;
  end

  for n=1, table.getn(RM_PlayerButtonsByName[pname]) do
    local idx = RM_PlayerButtonsByName[pname][n];
    RaidMinion_UI_UpdateDebuffsForIndex(idx, pname, unit);
  end
end

function RaidMinion_UI_UpdateDebuffsForIndex(idx, pname, unit)
  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  local showBuffs = RaidMinion_UI_GetTabOption(tabn, "showBuffs");
  local showDebuffs = RaidMinion_UI_GetTabOption(tabn, "showDebuffs");

  if (showBuffs) then
    for didx=1,RM_NUM_DEBUFF_ICONS do
      local buff = UnitBuff(unit, didx);
      local button = getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx .. "Icon");
      local frame = getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx);

      if (buff) then
        button:SetTexture(buff);
        button.id = didx;
        frame:Show();
      else
        frame:Hide();
      end
    end
  elseif (showDebuffs) then
    for didx=1,RM_NUM_DEBUFF_ICONS do
      local debuff = UnitDebuff(unit, didx);
      local button = getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx .. "Icon");
      local frame = getglobal("RaidMinionPlayer" .. idx .. "Debuff" .. didx);

      if (debuff) then
        button:SetTexture(debuff);
        button.id = didx;
        frame:Show();
      else
        frame:Hide();
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
  local tabn, pnum = RaidMinion_UI_TabAndPlayerFromIndex(idx);

  if (not RM_RaidData[name]) then
    return;
  end

  local unit = RM_RaidData[name].unit;
  if (not unit) then
    return;
  end

  local showBuffs = RaidMinion_UI_GetTabOption(tabn, "showBuffs");
  local showDebuffs = RaidMinion_UI_GetTabOption(tabn, "showDebuffs");

  if (not showBuffs and not showDebuffs) then
    return;
  end

  GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 15, -25);
  if (showBuffs) then
    GameTooltip:SetUnitBuff(unit, this:GetID());
  elseif (showDebuffs) then
    GameTooltip:SetUnitDebuff(unit, this:GetID());
  end
end

function RaidMinion_UI_TabAndPlayerFromIndex(idx)
  local tabn = math.floor((idx-1)/10) + 1;
  local pnum = idx - (tabn-1) * RM_MAX_PLAYERS_PER_TAB;

  return tabn, pnum;
end

function RaidMinion_UI_FactionClasses()
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

  return classes;
end

--
--  auto-setup
--

-- set up a tab for each class
function RaidMinion_UI_AutoSetupClasses()
  local classes = RaidMinion_UI_FactionClasses();
  local tabn = 1;

  --Re-Initialize all tabs 1st
  RM_TabOptions = {};
  RM_TabPlayers = {};
  for n=1,RM_MAX_TABS do
    RM_TabOptions[n] = { updateLabel = "hp", hidden = true };
    RM_TabNames[n] = "Tab " .. n;
  end

  for k,v in classes do
    if (tabn > RM_MAX_TABS) then
      Sea.io.error("RaidMinion is out of tabs! (This shouldn't happen!");
      return;
    end

    RM_TabPlayers[tabn] = { };
    RaidMinion_UI_SetTabOption(tabn, "classLock", nil);
    RaidMinion_UI_AddTabOptionListItem(tabn, "classLock", v[1]);
    RM_TabNames[tabn] = v[2];
    RaidMinion_UI_SetTabOption(tabn, "hidden", false);
    tabn = tabn + 1;
  end

  for n=1,tabn do
    RaidMinion_UI_ClassLock_UpdateTab(n, roster);
  end

  RaidMinion_UI_Update();
end

-- set up all 40 people in the first N tabs
function RaidMinion_UI_AutoSetupRaid()
  local roster = RaidMinion_GetRoster();

  local tabn = 1;
  local pnum = 0;

  --Re-Initialize all tabs 1st
  RM_TabOptions = {};
  RM_TabPlayers = {};
  for n=1,RM_MAX_TABS do
    RM_TabOptions[n] = { updateLabel = "hp", hidden = true };
    RM_TabNames[n] = "Tab " .. n;
  end

  for raider,rinfo in roster do
    if (pnum == RM_MAX_PLAYERS_PER_TAB) then
      tabn = tabn + 1;
      pnum = 0;
    end

    -- if it's the start of a tab...
    if (pnum == 0) then
      RaidMinion_UI_SetTabOption(tabn, "hidden", false);
    end

    RaidMinion_UI_AddPlayerToTab(raider, tabn);

    pnum = pnum + 1;
  end

  RaidMinion_UI_Update();
end
