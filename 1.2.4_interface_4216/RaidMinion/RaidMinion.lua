-- -*- Mode: lua; indent-tabs-mode: nil; lua-indent-level: 2; -*-
--
--  RaidMinion 2
--
--  Author(s):  Vladimir Vukicevic <vladimir@pobox.com>
--  Copyright (C) 2005  Vladimir Vukicevic  <vladimir@pobox.com>
--

RM_DEBUG_MESSAGES = false;
RM_DEBUG = "RM_DEBUG_MESSAGES";
RM_DEBUG_RAID_MESSAGES = false;
RM_DEBUG_RAID = "RM_DEBUG_RAID_MESSAGES";

-- the current message format version,
-- and whether we've told the user about a new version
RM_MessageVersion = 1;
RM_NotifiedOfNewVersion = false;

-- below low health threshold we update using the Fast interval.
-- if anyone's hp is below the full threshold, we use the Normal interval.
-- if everyone is at 100% hp or dead, we use the Slow interval.
RM_FullHealthThreshold = 0.95;
RM_LowHealthThreshold = 0.50;

-- in seconds
RM_FastInterval = 0.60;
RM_NormalInterval = 1.55;
RM_SlowInterval = 10.0;

RM_UpdateInterval = nil;

-- interval in which to send debuff updates
RM_DebuffInterval = 0.50;

-- how often we check for stale data
RM_StaleDataCheckInterval = 30.0;
-- if we haven't heard updates in 60 seconds, we purge
RM_StaleDataTime = 60.0;

-- the current group data that we use to build our chunk
RM_GroupData = {};
RM_GroupDebuffData = {};
-- the current raid data that we've received
RM_RaidData = {};
-- the current raid debuff data that we've received
RM_RaidDebuffData = {};
-- whether we are the active sender for our group or not
RM_ActiveSender = true;
-- the last raid roster
RM_RaidRoster = nil;

-- fast lookups for whether we care about the given unit
RM_UnitTypes = {
  "player",
  "party1",
  "party2",
  "party3",
  "party4"
};

RM_IsUnitImportant = {
  player = true,
  party1 = true,
  party2 = true,
  party3 = true,
  party4 = true,
};

-- member name -> true map
RM_PartyPlayers = {};

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

-- map localized debuff types to something sane
RM_DebuffTypes = {
  Poison = "POISON",
  Curse = "CURSE",
  Disease = "DISEASE",
  Magic = "MAGIC"
};

RM_DebuffTypeToInt = {
  POISON = 1,
  CURSE = 2,
  DISEASE = 3,
  MAGIC = 4,
  OTHER = 5
};

RM_DebuffIntToType = {
  "POISON",
  "CURSE",
  "DISEASE",
  "MAGIC",
  "OTHER"
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
-- with the player name, the data table for the player debuffs (may be null),
-- as well as userarg.
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
  this:RegisterEvent("PARTY_MEMBERS_CHANGED");
  this:RegisterEvent("RAID_ROSTER_UPDATE");
  this:RegisterEvent("UNIT_AURA");
  this:RegisterEvent("UNIT_HEALTH");
  this:RegisterEvent("UNIT_MANA");
  this:RegisterEvent("UNIT_RAGE");
  this:RegisterEvent("UNIT_ENERGY");
  this:RegisterEvent("UNIT_NAME_UPDATE");

  -- Sky alert listen
  Sky.registerAlert({ id = "RM",
                      description = "Raid Minion Listener",
                      func = RaidMinion_HandlePackage });
  Sky.registerAlert({ id = "RD",
                      description = "Raid Minion Debuff Listener",
                      func = RaidMinion_HandleDebuffPackage });

  -- after init
  Chronos.afterInit(RaidMinion_AfterInit);

  -- UI init
  RaidMinion_UI_Init();
end

function RaidMinion_AfterInit()
  RaidMinion_CheckForRaid();
end

-- Reset RM_GroupData, populating it with
-- the current group from scratch.  Called
-- when party members change, etc.
function RaidMinion_ResetGroup()
  Sea.IO.dprint(RM_DEBUG, "RM: ResetGroup");

  RM_LastNumRaidMembers = -1;
  RM_GroupData = {};
  RM_GroupDebuffData = {};
  RM_PartyPlayers = {};

  for n=1, 5 do
    local unit = RM_UnitTypes[n];
    if (UnitExists(unit) and UnitName(unit)) then
      RM_GroupData[unit] = RaidMinion_DataForUnit(unit);

      -- update our player-in-party lookup map
      if (unit ~= "player") then
        if (UnitIsGhost(unit) or not UnitIsConnected(unit)) then
          RM_PartyPlayers[UnitName(unit)] = 0;
        else
          RM_PartyPlayers[UnitName(unit)] = true;
        end
      end
    end
  end

  -- reset the raid data if we just left a raid
  if (GetNumRaidMembers() == 0) then
    Sea.IO.dprint(RM_DEBUG, "RM: Left raid; clearing data.");

    RM_RaidData = {};
    RM_RaidDebuffData = {};

    for n=1,table.getn(RM_RaidUpdateFunctions) do
      RM_RaidUpdateFunctions[n].func ("leave", RM_RaidUpdateFunctions[n].arg);
    end
  end
end

-- Return a table containing relevant data for
-- the given unit.
function RaidMinion_DataForUnit(unit)
  local a,cls = UnitClass(unit);

  local chunk = {
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
    manatype = UnitPowerType(unit)
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

-- did the group change since the last time this was called?
RM_LastPartyPeople = { };
function RaidMinion_DidGroupChange()
  local didchange = false;
  for n=1, 5 do
    local pname = UnitName(RM_UnitTypes[n]);
    -- if the person isn't connected, or is a ghost, pretend they're not there
    if (UnitIsGhost(RM_UnitTypes[n]) or not UnitIsConnected(RM_UnitTypes[n])) then
      pname = null;
    end

    if (RM_LastPartyPeople[n] ~= pname) then 
      didchange = true;
      RM_LastPartyPeople[n] = pname;
    end
  end
  return didchange;
end

function RaidMinion_CheckForRaid()
  if (not RM_IsInRaid and GetNumRaidMembers() > 0) then
    RaidMinion_ResetGroup();
    RM_IsInRaid = true;

    if (not Sky.isChannelActive(SKY_RAID)) then
      SkyChannelManager.joinChannel("skyraid");
    end

    for n=1,table.getn(RM_RaidUpdateFunctions) do
      RM_RaidUpdateFunctions[n].func("join", RM_RaidUpdateFunctions[n].arg);
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
        rms[name] = { rank = rank, subgroup = subgroup, level = level, class = class, zone = zone, online = online, isDead = isDead };
      end
    end

    RM_RaidRoster = rms;

    for n=1,table.getn(RM_RaidUpdateFunctions) do
      RM_RaidUpdateFunctions[n].func ("roster", RM_RaidRoster, RM_RaidUpdateFunctions[n].arg);
    end
  end

  if (RM_IsInRaid) then
    RaidMinion_CheckInterval();
    if (not Chronos.isScheduledByName("RaidMinionExpirationCheck")) then
      Chronos.scheduleByName ("RaidMinionExpirationCheck", RM_StaleDataCheckInterval, RaidMinion_CheckForStaleData);
    end
  end

  return RM_IsInRaid;
end

--
-- Event handling function; we decide when to update
--
function RaidMinion_OnEvent()
  --Sea.IO.dprint(RM_DEBUG, "RM Event: " .. event);

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

  if (event == "UNIT_NAME_UPDATE" or
      event == "PARTY_MEMBERS_CHANGED")
  then
    -- we see if something in the group really changed before
    -- doing a resetgroup
    if (RaidMinion_DidGroupChange()) then
      RM_ActiveSender = true;
      RaidMinion_ResetGroup();
    end

    RaidMinion_CheckInterval();
    return;
  end

  -- Anything below here expects a unit type in arg1,
  -- that we check and discard if we don't care
  if (not RM_IsUnitImportant[arg1]) then
    return;
  end

  if (event == "UNIT_HEALTH" or
      event == "UNIT_MANA" or
      event == "UNIT_RAGE" or
      event == "UNIT_ENERGY")
  then
    local chunk = RaidMinion_DataForUnit(arg1);
    RM_GroupData[arg1] = chunk;
    RaidMinion_CheckInterval();
    return;
  end

  if (event == "UNIT_AURA") then
    RaidMinion_HandleAuraUpdate(arg1);
    return;
  end
end

--
-- Check if we need to change the update inteval (and do so)
--
function RaidMinion_CheckInterval()
  if (not RM_ActiveSender) then
    return;
  end

  -- if we're not in a raid, then don't send out anything;
  -- otherwise, make sure our listener is hooked up
  if (GetNumRaidMembers() == 0) then
    if (RM_IsInRaid == true) then
      RM_IsInRaid = false;
      RM_RaidRoster = nil;

      RM_UpdateInterval = nil;
      Chronos.unscheduleByName ("RaidMinionSender");
      Chronos.unscheduleByName ("RaidMinionExpirationCheck");

      for n=1,table.getn(RM_RaidUpdateFunctions) do
        RM_RaidUpdateFunctions[n].func ("leave", RM_RaidUpdateFunctions[n].arg);
      end
    end
    return;
  end

  local neededInterval = RM_NormalInterval;
  local allFull = true;
  local allDead = true;

  for n=1, 5 do
    local unit = RM_UnitTypes[n];
    if (RM_GroupData[unit]) then
      chunk = RM_GroupData[unit];

      -- if the unit is not dead or a ghost, but is connected
      if (not UnitIsDeadOrGhost(RM_UnitTypes[n]) and
          UnitIsConnected(RM_UnitTypes[n]))
      then
        allDead = false;

        local percent = chunk.hp / chunk.hpmax;

        if (percent <= RM_FullHealthThreshold) then
          allFull = false;
        end

        if (percent < RM_LowHealthThreshold) then
          neededInterval = RM_FastInterval;
        end
      end
    end
  end

  if (allFull or allDead) then
    neededInterval = RM_SlowInterval;
  end

  if (RM_UpdateInterval ~= neededInterval) then
    RM_UpdateInterval = neededInterval;
    Sea.io.dprint(RM_DEBUG, "RM: switching interval to " .. RM_UpdateInterval);

    -- force an update send; it'll take care of resetting the interval
    RaidMinion_SendUpdate();
  end
end

--
-- actually send an update; called via Chronos
--
function RaidMinion_SendUpdate()
  if (not RM_ActiveSender) then
    return;
  end

  local package = "<RM>" .. RM_MessageVersion

  for n=1,5 do
    local unit = RM_UnitTypes[n];
    if (RM_GroupData[unit]) then
      package = package .. ";" .. RaidMinion_DataToString(RM_GroupData[unit]);
    end
  end

  Sky.sendAlert (package, SKY_RAID, "RM");

  if (RM_UpdateInterval ~= nil) then
    Chronos.scheduleByName ("RaidMinionSender", RM_UpdateInterval, RaidMinion_SendUpdate);
  end
end

-- The data format is:
-- <RM>version;chunk;chunk;...
-- where chunk is:
-- name:classid:curhp:maxhp:curmana:maxmana:manatype
-- (note the semicolons in the top-level message and the colons in the other)
-- This function builds a chunk portion from the given data table)
function RaidMinion_DataToString (data)
  return data.name
    .. ":" .. data.classid
    .. ":" .. data.hp
    .. ":" .. data.hpmax
    .. ":" .. data.mana
    .. ":" .. data.manamax
    .. ":" .. data.manatype;
end

-- Unpack a <RM>.... string of the above form into a table with N entries,
-- one for each chunk
function RaidMinion_UnpackData (datastr)
  local result = {};
  local chunks = Sea.string.split(strsub(datastr, 5), ";");

  -- check message version, and notify if there's a newer one
  local version = tonumber(chunks[1]);
  if (version > RM_MessageVersion and
      not RM_NotifiedOfNewVersion)
  then
    Sea.IO.error("RaidMinion: A newer version seems to exist, please update!");
    RM_NotifiedOfNewVersion = true;
  end

  if (version ~= RM_MessageVersion) then
    return nil;
  end

  -- now for each actual data chunk, convert it into a table
  for n=2, table.getn(chunks) do
    local chunkstr = chunks[n];
    local chunk = Sea.string.split(chunkstr, ":");

    table.insert(result,
                 { name = chunk[1],
                   classid = tonumber(chunk[2]),
                   hp = tonumber(chunk[3]),
                   hpmax = tonumber(chunk[4]),
                   mana = tonumber(chunk[5]),
                   manamax = tonumber(chunk[6]),
                   manatype = tonumber(chunk[7])
                 });
  end

  return result;
end

--
-- check our Sky mailbox for incoming updates
--
function RaidMinion_HandlePackage(datastr, sender, channel, time)
  if (not datastr or datastr == "") then
    return;
  end

  Sea.io.dprint(RM_DEBUG_RAID, "RM: " .. sender .. ": " .. datastr);

  local data = RaidMinion_UnpackData(datastr);

  -- is the player not us, but in our group,
  -- and not a ghost or disconnected?
  if (RM_ActiveSender and
      sender ~= UnitName("player") and
      RM_PartyPlayers[sender] == true)
  then
    -- yes; see if we should cancel our own sends,
    -- if their name is alphabetically less then ours
    if (sender < UnitName("player")) then
      Sea.io.dprint(RM_DEBUG, "RM: player " .. sender .. " is also sending; stopping our own");

      RM_ActiveSender = false;
    end
  end

  -- update our RaidData based on the data we
  -- just got from the network
  for j=1, table.getn(data) do
    RM_RaidData[data[j].name] = data[j];
    RM_RaidData[data[j].name].lastUpdate = GetTime();
          
    for n=1,table.getn(RM_PlayerUpdateFunctions) do
      RM_PlayerUpdateFunctions[n].func (data[j].name, data[j], RM_PlayerUpdateFunctions[n].arg);
    end
  end
end

--
-- stale data check
--
function RaidMinion_CheckForStaleData()
  local now = GetTime();

  for raider, rdata in RM_RaidData do
    if (not rdata.lastUpdate or (now - rdata.lastUpdate > RM_StaleDataTime)) then
      -- nuke this
      RM_RaidData[raider] = nil;
      RM_RaidDebuffData[raider] = nil;

      for n=1,table.getn(RM_PlayerUpdateFunctions) do
        RM_PlayerUpdateFunctions[n].func (raider, nil, RM_PlayerUpdateFunctions[n].arg);
      end

      for n=1,table.getn(RM_PlayerDebuffUpdateFunctions) do
        RM_PlayerDebuffUpdateFunctions[n].func (raider, nil, RM_PlayerDebuffUpdateFunctions[n].arg);
      end
    end
  end
end

--
-- Debuff handling
--
function RaidMinion_HandleAuraUpdate(unit)
  -- don't bother if we're not the active sender
  if (not RM_ActiveSender) then
    return;
  end

  -- first build a list of debuffs for this unit
  local debuffs = {};
  debuffs.n = 0;
  for n=1, 8 do
    local texture = UnitDebuff(unit, n);
    if (texture) then
      RaidMinionTooltipTextLeft1:SetText(nil);
      RaidMinionTooltipTextRight1:SetText(nil);

      RaidMinionTooltip:SetUnitDebuff(unit, n);

      local name = RaidMinionTooltipTextLeft1:GetText();
      local typetext = RaidMinionTooltipTextRight1:GetText();

      -- strip ":"'s from the name, to avoid screwing us over
      name = string.gsub(name, ":", "");

      local type = "OTHER";
      if (typetext) then
        type = RM_DebuffTypes[typetext];
      end

      -- strip path from texture
      texture = string.gsub(texture, ".*\\(.*)", "%1");

      -- some debuffs don't have a type, but they're useful to pass along
      if (name) then
        debuffs[name] = { type = type, texture = texture };
        debuffs.n = debuffs.n + 1;
      end
    end
  end

  -- check if the debuffs actually changed
  if (RM_GroupDebuffData[unit]
      and table.getn(RM_GroupDebuffData[unit]) == table.getn(debuffs))
  then
    local same = true;
    for name,val in debuffs do
      if (name ~= "n") then
        if (not RM_GroupDebuffData[unit][name]) then
          same = false;
        end
      end
    end

    if (same) then
      return;
    end
  end

  RM_GroupDebuffData[unit] = debuffs;

  -- something did actually change; send out an update
  RaidMinion_QueueDebuffUpdate();
end

function RaidMinion_QueueDebuffUpdate()
  if (Chronos.isScheduledByName("RaidMinionDebuffSender")) then
    return;
  end

  Chronos.scheduleByName("RaidMinionDebuffSender", RM_DebuffInterval, RaidMinion_SendDebuffUpdate);
end

--
-- The debuff chunk format is thus:
-- <RD>version;chunk;chunk;chunk
-- where chunk is:
-- name:debuffname:debufftype:texturename:debuffname:debufftype:texturename:...
function RaidMinion_SendDebuffUpdate()
  if (not RM_ActiveSender) then
    return;
  end

  local package = "<RD>" .. RM_MessageVersion;

  for unit,debuffs in RM_GroupDebuffData do
    local unitstr = UnitName(unit);

    if (table.getn(debuffs) > 0) then
      -- we have debuffs to send out
      for dname,dinfo in RM_GroupDebuffData[unit] do
        -- Lua sucks, yes it does
        if (dname ~= "n") then
          local s = ":" .. dname .. ":" .. RM_DebuffTypeToInt[dinfo.type] .. ":" .. dinfo.texture;
          unitstr = unitstr .. s;
        end
      end
    else
      -- we're sending out a "no debuffs" notice
      unitstr = unitstr .. ":NONE";
    end

    local unitlen = string.len(unitstr);
    local pkglen = string.len(package);

    -- can we even ever send this?
    if (unitlen + 6 >= SKY_MAX_DATAGRAM_LENGTH) then
      Sea.io.error("RaidMinion: Warning: Debuff update for player " .. UnitName(unit) .. " cannot be sent (too long)");
      unitstr = nil;
    elseif (unitlen + pkglen + 1 >= SKY_MAX_DATAGRAM_LENGTH) then
    -- fragment ourselves if we're getting too long
      Sky.sendAlert (package, SKY_RAID, "RD");
      package = "<RD>" .. RM_MessageVersion;
    end

    if (unitstr) then
      package = package .. ";" .. unitstr;
    end
  end

  Sky.sendAlert (package, SKY_RAID, "RD");
end

function RaidMinion_UnpackDebuffData(datastr)
  local result = {};
  local chunks = Sea.string.split(strsub(datastr, 5), ";");

  -- check message version, and notify if there's a newer one
  local version = tonumber(chunks[1]);
  if (version > RM_MessageVersion and
      not RM_NotifiedOfNewVersion)
  then
    Sea.IO.error("RaidMinion: A newer version seems to exist, please update!");
    RM_NotifiedOfNewVersion = true;
  end

  if (version ~= RM_MessageVersion) then
    return nil;
  end

  -- now for each actual data chunk, convert it into a table
  for n=2, table.getn(chunks) do
    local chunkstr = chunks[n];
    local chunk = Sea.string.split(chunkstr, ":");

    local debuffs = { };

    local pname = chunk[1];
    if (chunk[2] ~= "NONE") then
      for j=2,table.getn(chunk),3 do
        local dname = chunk[j];
        local dtype = RM_DebuffIntToType[tonumber(chunk[j+1])];
        local dtex = chunk[j+2];

        table.insert(debuffs, { name = dname, type = dtype, texture = dtex });
      end
    end
    result[pname] = debuffs;
  end

  return result;
end

function RaidMinion_HandleDebuffPackage(datastr, sender, channel, time)
  Sea.io.dprint(RM_DEBUG_RAID, "RD: " .. sender .. ": " .. datastr);

  local data = RaidMinion_UnpackDebuffData(datastr);
  if (not data) then
    return;
  end

  for raider,rdebuffs in data do
    -- store the debuffs
    RM_RaidDebuffData[raider] = rdebuffs;

    for n=1,table.getn(RM_PlayerDebuffUpdateFunctions) do
      RM_PlayerDebuffUpdateFunctions[n].func (raider, rdebuffs, RM_PlayerDebuffUpdateFunctions[n].arg);
    end
  end
end
