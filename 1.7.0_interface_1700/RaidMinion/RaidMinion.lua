-- -*- Mode: lua; indent-tabs-mode: nil; lua-indent-level: 2; -*-
--
--  RaidMinion 2
--
--  Author(s):  Vladimir Vukicevic <vladimir@pobox.com>
--  Copyright (C) 2005  Vladimir Vukicevic  <vladimir@pobox.com>
--
--  http://www.wowwiki.com/RaidMinion
--
--  There are hooks provided for other addons to obtain information
--  about the current raider state, or to be notified when raider
--  state or debuffs change.  Search for "Public API".
--

RaidMinion_Version = "0.3.0";

RM_DEBUG_MESSAGES = false;
RM_DEBUG = "RM_DEBUG_MESSAGES";
RM_DEBUG_RAID_MESSAGES = false;
RM_DEBUG_RAID = "RM_DEBUG_RAID_MESSAGES";
RM_DEBUG_SEND_MESSAGES = false;
RM_DEBUG_SEND = "RM_DEBUG_SEND_MESSAGES";
RM_DEBUG_DEBUFF_MESSAGES = false;
RM_DEBUG_DEBUFF = "RM_DEBUG_DEBUFF_MESSAGES";
RM_DEBUG_TARGET_MESSAGES = false;
RM_DEBUG_TARGET = "RM_DEBUG_TARGET_MESSAGES";

-- whether the player is in combat
RM_PlayerInCombat = nil;
-- the current raid data
RM_RaidData = {};
-- the last raid roster
RM_RaidRoster = nil;

-- classes
RM_UnitClasses = {
  DRUID = 1,
  HUNTER = 2,
  MAGE = 3,
  PALADIN = 4,
  PRIEST = 5,
  ROGUE = 6,
  SHAMAN = 7,
  WARLOCK = 8,
  WARRIOR = 9
};

-- tracking whether we're in a raid or not
RM_IsInRaid = false;
RM_LastNumRaidMembers = -1;

-- callback lists for public API
RM_PlayerUpdateFunctions = { };
RM_PlayerDebuffUpdateFunctions = { };
RM_RaidUpdateFunctions = { };

--
-- Public API
--

-- Register a function to be called when new player
-- data is received.  The function will be called
-- with the player name, the data table for a player (may be null),
-- as well as userarg.
function RaidMinion_RegisterForPlayerUpdate(pfunc, userarg)
  table.insert(RM_PlayerUpdateFunctions, { func = pfunc, arg = userarg });
end

-- Register a function to be called when new player debuff
-- data is received.  The function will be called
-- with the player name, the unit that may be used
-- to obtain debuff information, as well as userarg if any.
function RaidMinion_RegisterForPlayerDebuffUpdate(pfunc, userarg)
  table.insert(RM_PlayerDebuffUpdateFunctions, { func = pfunc, arg = userarg });
end

-- Register a function to be called when the player
-- joins or leaves a raid.  The first argument to
-- the function will be "join" if the player is joining
-- a raid; "leave" if the player is leaving; or "roster" if the
-- next arg contains a raid roster.
-- userarg will also be passed to the function as the last arg.
function RaidMinion_RegisterForRaidUpdate(pfunc, userarg)
  table.insert(RM_RaidUpdateFunctions, { func = pfunc, arg = userarg });
end

-- Register a function to be called when a player broadcasts
-- a target HP update.  The first argument is the name
-- of the player who sent the update (the player whose target it is),
-- and the second is a table containing the target data (same
-- format as the player chunk), or nil if no target.
-- userarg will also be passed to the function as the last arg.
function RaidMinion_RegisterForTargetUpdate(pfunc, userarg)
  --table.insert(RM_PlayerTargetUpdateFunctions, { func = pfunc, arg = userarg });
end

-- Return the current raid roster, if known.
-- nil otherwise.
function RaidMinion_GetRoster()
  return RM_RaidRoster;
end

--
-- RaidMinion private
--

--
-- Initial frame setup
--
function RaidMinion_OnLoad()
  -- Register events needed for sender
  this:RegisterEvent("RAID_ROSTER_UPDATE");
  this:RegisterEvent("UNIT_AURA");
  this:RegisterEvent("UNIT_HEALTH");
  this:RegisterEvent("UNIT_MANA");
  this:RegisterEvent("UNIT_RAGE");
  this:RegisterEvent("UNIT_ENERGY");
  this:RegisterEvent("PLAYER_ENTER_COMBAT");
  this:RegisterEvent("PLAYER_LEAVE_COMBAT");

  -- after init
  Chronos.afterInit(RaidMinion_AfterInit);
end

function RaidMinion_AfterInit()
  -- UI init
  RaidMinion_UI_Init();

  RaidMinion_CheckForRaid();
end

-- Reset current data, called
-- when party members change, etc.
function RaidMinion_ResetGroup()
  Sea.IO.dprint(RM_DEBUG, "RM: ResetGroup");

  RM_LastNumRaidMembers = -1;

  -- reset the raid data if we just left a raid
  if (GetNumRaidMembers() == 0) then
    Sea.IO.dprint(RM_DEBUG, "RM: Left raid; clearing data.");

    RM_RaidData = {};
    RM_RaidDebuffData = {};
    RM_RaidTargetData = {};

    for n=1,table.getn(RM_RaidUpdateFunctions) do
      local s,e = pcall (RM_RaidUpdateFunctions[n].func, "leave", RM_RaidUpdateFunctions[n].arg);
      if (not s) then
        Sea.io.print("RaidUpdate leave: " .. e);
      end
    end
  end
end

-- Return a table containing relevant data for
-- the given unit.
function RaidMinion_DataForUnit(unit)
  if (not UnitExists(unit)) then
    return nil;
  end

  local a,cls = UnitClass(unit);

  local bad = 0;

  if (unit == "target") then
    if (UnitCanAttack("target", "player") or
        UnitCanAttack("player", "target"))
    then
      bad = 1;
    end
  end

  local chunk = {
    -- unit
    unit = unit,
    -- name
    name = UnitName(unit),
    -- classid
    classid = RM_UnitClasses[cls],
    -- cur health
    hp = UnitHealth(unit),
    -- max health
    hpmax = UnitHealthMax(unit),
    -- cur mana
    mana = UnitMana(unit),
    -- max mana
    manamax = UnitManaMax(unit),
    -- mana type
    manatype = UnitPowerType(unit),
    -- hostile/attackable
    hostile = bad
  };
  
  return chunk;
end

-- Return true if d1 and d2 are equal
function RaidMinion_DataEquals(d1, d2)
  local fields = { "name", "hp", "hpmax", "mana", "manamax", "manatype" };
  for n=1, table.getn(fields) do
    if (d1[fields[n]] ~= d2[fields[n]]) then
      return false;
    end
  end

  return true;
end

-- Are we in a raid?  If so, and we just joined,
-- do some bookkeeping.  Also check for roster
-- updates.
function RaidMinion_CheckForRaid()
  if (not RM_IsInRaid and GetNumRaidMembers() > 0) then
    RaidMinion_ResetGroup();
    RM_IsInRaid = true;

    for n=1,table.getn(RM_RaidUpdateFunctions) do
      local s,e = pcall (RM_RaidUpdateFunctions[n].func, "join", RM_RaidUpdateFunctions[n].arg);
      if (not s) then
        Sea.io.print("RaidUpdate join: " .. e);
      end
    end
  end

  -- we get RAID_ROSTER_UPDATE often.  To avoid doing this that often,
  -- we only do it when the number of members actually changes.
  if (RM_IsInRaid and GetNumRaidMembers() ~= RM_LastNumRaidMembers) then
    RM_LastNumRaidMembers = GetNumRaidMembers();
    local rms = {};
    for i=1, RM_LastNumRaidMembers do
      local name, rank, subgroup, level, _, class, zone, online, isDead = GetRaidRosterInfo(i);
      -- for some reason, this sometimes ends up null
      if (name) then
        rms[name] = { rank = rank, subgroup = subgroup, level = level, class = class, zone = zone, online = online, isDead = isDead, unit = ("raid" .. i) };
      end
    end

    RM_RaidRoster = rms;

    for n=1,table.getn(RM_RaidUpdateFunctions) do
      local s,e = pcall (RM_RaidUpdateFunctions[n].func, "roster", RM_RaidRoster, RM_RaidUpdateFunctions[n].arg);
      if (not s) then
        Sea.io.print("RaidUpdate roster: " .. e);
      end
    end

    Chronos.scheduleByName("RM_InitialPopulate", 10, RaidMinion_InitialPopulate);
  end

  return RM_IsInRaid;
end

function RaidMinion_InitialPopulate()
  local n = GetNumRaidMembers();
  if (n <= 1) then
    return;
  end

  for i=1,n do
    local name, rank, subgroup, level, _, class, zone, online, isDead = GetRaidRosterInfo(i);
    if (name) then
      RM_RaidData[name] = RaidMinion_DataForUnit("raid" .. i);

      for n=1,table.getn(RM_PlayerUpdateFunctions) do
        local s,e = pcall (RM_PlayerUpdateFunctions[n].func, name, RM_RaidData[name], RM_PlayerUpdateFunctions[n].arg);
        if (not s) then
          Sea.io.print("InitialPopulate PlayerUpdate: " .. e);
        end
      end
    end
  end
end

--
-- Event handling function; we decide when to update
--
function RaidMinion_OnEvent()
  Sea.IO.dprint(RM_DEBUG, "RM Event: " .. event);

  if (event == "PLAYER_ENTER_COMBAT") then
    RM_PlayerInCombat = true;
    return;
  end

  if (event == "PLAYER_LEAVE_COMBAT") then
    RM_PlayerInCombat = nil;
    return;
  end

  -- Note that we get RAID_ROSTER_UPDATEs even when
  -- we're not in a raid, so we have to check whether
  -- we're really in a raid.
  if (event == "RAID_ROSTER_UPDATE") then
    RaidMinion_CheckForRaid();
    return;
  end

  -- if we get here, we should be in a raid; otherwise,
  -- we just return
  if (not RM_IsInRaid) then
    return;
  end

  -- Anything below here expects a unit type in arg1,
  -- that we check and discard if we don't care
  if (not ((string.sub(arg1, 1, 4) == "raid") or
           (string.sub(arg1, 1, 5) == "party") or
           (arg1 == "player")))
  then
    -- we don't care
    return;
  end

  if (event == "UNIT_HEALTH" or
      event == "UNIT_MANA" or
      event == "UNIT_RAGE" or
      event == "UNIT_ENERGY")
  then
    local pname = UnitName(arg1);
    if (not pname) then
      return;
    end

    local data = RaidMinion_DataForUnit(arg1);
    RM_RaidData[pname] = data;

    for n=1,table.getn(RM_PlayerUpdateFunctions) do
      local s,e = pcall (RM_PlayerUpdateFunctions[n].func, data.name, data, RM_PlayerUpdateFunctions[n].arg);
      if (not s) then
        Sea.io.print("PlayerUpdate: " .. e);
      end
    end
  end

  if (event == "UNIT_AURA") then
    for n=1,table.getn(RM_PlayerDebuffUpdateFunctions) do
      local s,e = pcall (RM_PlayerDebuffUpdateFunctions[n].func, UnitName(arg1), arg1, RM_PlayerDebuffUpdateFunctions[n].arg);
      if (not s) then
        Sea.io.print("PlayerDebuffUpdate: " .. e);
      end
    end
  end
end

--
-- Debugging utils
--
function rmdebug(enable)
  if (enable) then
    Sea.IO.DEFAULT_PRINT_FRAME = ChatFrame3;
    RM_DEBUG_RAID_MESSAGES = true;
    RM_DEBUG_MESSAGES = true;
    RM_DEBUG_SEND_MESSAGES = true;
    RM_DEBUG_DEBUFF_MESSAGES = true;
    RM_DEBUG_TARGET_MESSAGES = true;
  else
    RM_DEBUG_RAID_MESSAGES = false;
    RM_DEBUG_MESSAGES = false;
    RM_DEBUG_SEND_MESSAGES = false;
    RM_DEBUG_DEBUFF_MESSAGES = false;
    RM_DEBUG_TARGET_MESSAGES = false;
    Sea.IO.DEFAULT_PRINT_FRAME = ChatFrame1;
  end
end
