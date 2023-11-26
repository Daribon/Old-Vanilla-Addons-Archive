-- CastParty - by danboo
-- $Id: CastParty.lua,v 1.11 2005-03-22 17:08:15-05 danboo Exp danboo $

-- ideas
--   separate into HealerHelper and CastParty
--   differentiate buffs/debuffs more
--   limit spell cancellation to health events that increased the health of the spell target
--   add methods to sort the party members when party changes (e.g., max health, level)
--   reconsider size of aura icons (percentages may appear clearer)
--   include emergency heals in the efficient list, and just sort by efficiency (might get a fast one!)
--   add consideration for mana-less/time-less talents
--   use efficient heal if the target has pw:s
--   add a configurable alpha to the backdrop (re-write XML)
--   track how recently a player has been hit, offer an in-battle health target percent for overhealing
--   try to honor tooltip placement
--   add bindings to do the right thing on specific party members
--   add a binding just to target the player with the lowest health
--   add a bar for the target (just above the player but spaced differently)
--   add pet bars and a binding to update

-- todo
--   add rage/energy
--   ChooseSpell should auto cure if all members are above a certain health amount
--   add a method of locking the position
--   add a CastParty_CastBest() function
--   add a /castbest slash-command
--   use raid channel if available
--   option to turn off flags
--   resurrect on clicking dead players
--   take into account level of healing target when casting Renew
--   combine the various unit tracking tables into one table of tables
--   convert id based functions to unit based

-- bugs
--   sometimes the party leader crown appears on 2 people, dunno why yet

local _class
local _priorX
local _priorY
local _is_moving
local _last_player_health
local _last_player_damage
local _force_heal
local _click_button
local _spell_target_unit
local _spell_being_cast
local _casting_now

local _hpc            = CastPartyPlayerConfig
local _cpc            = CastParty_constants
local _event_dispatch = {}
local _units          = { [0] = 'player', 'party1', 'party2', 'party3', 'party4' }
local _ids            = { player = 0, party1 = 1, party2 = 2, party3 = 3, party4 = 4 }
local _auras          = { player = {}, party1 = {}, party2 = {}, party3 = {}, party4 = {} }
local _flags          = { player = {}, party1 = {}, party2 = {}, party3 = {}, party4 = {} }
local _ills           = { player = {}, party1 = {}, party2 = {}, party3 = {}, party4 = {} }
local _spell_ids      = {}
local _best_spell_ids = {}
local _my_curables    = {}
local _max_debuffs    = 4
local _max_buffs      = 8
local _debug          = false

-- tables for interpolating health of targets outside the group
local _class_health = {
   [_cpc.CLASS_DRUID]   = { ["1"] = 30, ["60"] = 3500 },
   [_cpc.CLASS_MAGE]    = { ["1"] = 30, ["60"] = 2500 },
   [_cpc.CLASS_HUNTER]  = { ["1"] = 30, ["60"] = 3500 },
   [_cpc.CLASS_PALADIN] = { ["1"] = 30, ["60"] = 4000 },
   [_cpc.CLASS_PRIEST]  = { ["1"] = 30, ["60"] = 2500 },
   [_cpc.CLASS_ROGUE]   = { ["1"] = 30, ["60"] = 3500 },
   [_cpc.CLASS_SHAMAN]  = { ["1"] = 30, ["60"] = 3800 },
   [_cpc.CLASS_WARLOCK] = { ["1"] = 30, ["60"] = 3500 },
   [_cpc.CLASS_WARRIOR] = { ["1"] = 30, ["60"] = 5000 },
}

-- table of all cure spells
local _all_cures = {
   { spell = _cpc.CURE_DISEASE_1, cures = { _cpc.AILMENT_DISEASE } },
   { spell = _cpc.CURE_DISEASE_2, cures = { _cpc.AILMENT_DISEASE } },
   { spell = _cpc.CURE_PURIFY_1,  cures = { _cpc.AILMENT_DISEASE, _cpc.AILMENT_POISON } },
   { spell = _cpc.CURE_CLEANSE_1, cures = { _cpc.AILMENT_DISEASE, _cpc.AILMENT_POISON, _cpc.AILMENT_MAGIC } },
   { spell = _cpc.CURE_MAGIC_1,   cures = { _cpc.AILMENT_MAGIC   } },
   { spell = _cpc.CURE_POISON_1,  cures = { _cpc.AILMENT_POISON  } },
   { spell = _cpc.CURE_POISON_2,  cures = { _cpc.AILMENT_POISON  } },
   { spell = _cpc.CURE_CURSE_1,   cures = { _cpc.AILMENT_CURSE   } },
   { spell = _cpc.CURE_CURSE_2,   cures = { _cpc.AILMENT_CURSE   } },
}

-- storage for spell data used in determining appropriateness
local _heal_data = {
  [_cpc.CLASS_SHAMAN]  = {},
  [_cpc.CLASS_PRIEST]  = {},
  [_cpc.CLASS_DRUID]   = {},
  [_cpc.CLASS_PALADIN] = {},
}

-- mapping of healing spell lines to casting categories
local _heal_types = {
  [_cpc.CLASS_SHAMAN] = {
     [_cpc.HEAL_HEALING_WAVE]        = 'efficient',
     [_cpc.HEAL_LESSER_HEALING_WAVE] = 'emergency',
     [_cpc.HEAL_CHAIN_HEAL]          = 'group',
  },
  [_cpc.CLASS_PRIEST] = {
     [_cpc.HEAL_LESSER_HEAL]         = 'efficient',
     [_cpc.HEAL_HEAL]                = 'efficient',
     [_cpc.HEAL_GREATER_HEAL]        = 'efficient',
     [_cpc.HEAL_FLASH_HEAL]          = 'emergency',
     [_cpc.HEAL_RENEW]               = 'instant',
     [_cpc.HEAL_PRAYER_OF_HEALING]   = 'group',
  },
  [_cpc.CLASS_DRUID] = {
     [_cpc.HEAL_HEALING_TOUCH]       = 'efficient',
     [_cpc.HEAL_REJUVENATION]        = 'instant',
     [_cpc.HEAL_REGROWTH]            = 'emergency',
     [_cpc.HEAL_TRANQUILITY]         = 'group',
  },
  [_cpc.CLASS_PALADIN] = {
     [_cpc.HEAL_HOLY_LIGHT]          = 'efficient',
     [_cpc.HEAL_FLASH_OF_LIGHT]      = 'emergency',
  },
}

-- functions for parsing healing info from tooltip
-- unfortunately lua requires functions be defined before referring to them
local function parse_integer(text, index)

   local i = 1
   for integer in string.gfind(text, '%d+') do
      if i == index then
         return tonumber(integer)
      end
      i = i + 1
   end

end

-- pull the first integer
local function pi_first(text)
   return parse_integer(text, 1)
end

-- pull the second integer
local function pi_second(text)
   return parse_integer(text, 2)
end

-- mapping of healing spell lines to heal amount parsers
local _spell_parsers = {
  [_cpc.CLASS_SHAMAN] = {
     [_cpc.HEAL_HEALING_WAVE]        = pi_second,
     [_cpc.HEAL_LESSER_HEALING_WAVE] = pi_second,
     [_cpc.HEAL_CHAIN_HEAL]          = pi_second,
  },
  [_cpc.CLASS_PRIEST] = {
     [_cpc.HEAL_LESSER_HEAL]         = pi_second,
     [_cpc.HEAL_HEAL]                = pi_second,
     [_cpc.HEAL_GREATER_HEAL]        = pi_second,
     [_cpc.HEAL_FLASH_HEAL]          = pi_second,
     [_cpc.HEAL_RENEW]               = pi_first,
     [_cpc.HEAL_PRAYER_OF_HEALING]   = pi_second,
  },
  [_cpc.CLASS_DRUID] = {
     [_cpc.HEAL_HEALING_TOUCH]       = pi_second,
     [_cpc.HEAL_REJUVENATION]        = pi_first,
     [_cpc.HEAL_REGROWTH]            = pi_second,
     [_cpc.HEAL_TRANQUILITY]         = pi_first,
  },
  [_cpc.CLASS_PALADIN] = {
     [_cpc.HEAL_HOLY_LIGHT]          = pi_second,
     [_cpc.HEAL_FLASH_OF_LIGHT]      = pi_second,
  },
}

-- thanks Thirsterhal! =)
local _class_buffs = {
  [_cpc.CLASS_PRIEST] = {
     [_cpc.BUFF_PWF]          = {1,12,24,36,48,60},
     [_cpc.BUFF_PWS]          = {6,12,18,24,30,36,42,48,54,60},
     [_cpc.BUFF_SP]           = {30,42,56},
     [_cpc.BUFF_DS]           = {40,42,54},
     [_cpc.HEAL_RENEW]        = {8,14,20,26,32,38,44,50,56},
   },
  [_cpc.CLASS_DRUID] = {
     [_cpc.BUFF_MOTW]         = {1,10,20,30,40,50,60},
     [_cpc.BUFF_THORNS]       = {6,14,24,34,44,54},
     [_cpc.HEAL_REJUVENATION] = {4,10,26,22,28,34,40,46,52,58},
   },
  [_cpc.CLASS_MAGE] = {
     [_cpc.BUFF_AI]           = {1,14,28,42,56},
   },
  [_cpc.CLASS_PALADIN] = {
     [_cpc.BUFF_BOM]          = {4,12,22,32,42,52},
     [_cpc.BUFF_BOP]          = {10,24,38},
     [_cpc.BUFF_BOW]          = {14,24,34,44,54},
   }
}


function CastParty_ChooseBuffRank(unit, buff_name)

   if not ( UnitExists(unit) and _class_buffs[_class] and _class_buffs[_class][buff_name] ) then
      return
   end

   local unit_level = UnitLevel(unit)
   local rank

   for i = getn(_class_buffs[_class][buff_name]),1,-1 do

      rank = i

      local full_name  = buff_name .. '(' .. _cpc.RANK .. ' ' .. rank .. ')'
      local buff_level = _class_buffs[_class][buff_name][i]

      if _spell_ids[full_name] and buff_level - unit_level <= 10 then
         do break end
      end

   end

   return rank

end

--
-- Miscellaneous Functions
--

-- display debug info in the chat frame
local function debug(...)
   if not DEFAULT_CHAT_FRAME or not _debug then
      return
   end
   local msg = ''
   for k,v in ipairs(arg) do
      msg = msg .. tostring(v) .. ' : '
   end
   DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local function debug2(...)
   local msg = ''
   for k,v in ipairs(arg) do
      msg = msg .. tostring(v) .. ' : '
   end
   DEFAULT_CHAT_FRAME:AddMessage(msg)
end

function CastParty_DeepCopyTable(src_table, dest_table)

   for i in src_table do

      if type(src_table[i]) == 'table' then

         if not dest_table[i] or not type(dest_table[i]) == 'table' then
            dest_table[i] = {}
         end

         CastParty_DeepCopyTable(src_table[i], dest_table[i])

      end

      dest_table[i] = src_table[i]

   end

end

-- fillin the _heal_data table by iterating over spells in spellbook
-- and parsing tool tips for info
function CastParty_LoadSpellData()

   local i = 1

   while true do

      local spell_name, spell_rank = GetSpellName(i, SpellBookFrame.bookType)

      if not spell_name then
         do break end
      end

      _spell_ids[spell_name .. '(' .. spell_rank .. ')'] = { id = i, name = spell_name, rank = spell_rank }
      _best_spell_ids[spell_name] = { id = i, name = spell_name, rank = spell_rank }

      --debug(_class, i, spell_name, spell_rank)

      -- get healing data

      if _heal_types[_class] then

         local spell_type = _heal_types[_class][spell_name]

         if spell_type then

            debug(i, spell_name, spell_rank)

            CastParty_Tooltip:SetSpell(i, SpellBookFrame.bookType)

            local mana_cost = CastParty_TooltipTextLeft2:GetText()

            if string.find(mana_cost, "Mana") then
               _,_,mana_cost = string.find(mana_cost, "(%d+)")
            else
               mana_cost = nil
            end

            local heal_amount = _spell_parsers[_class][spell_name](CastParty_TooltipTextLeft4:GetText())

            if not _heal_data[_class][spell_type] then
               _heal_data[_class][spell_type] = { }
            end

            local entry = { name = spell_name,
                            rank = spell_rank,
                        max_heal = tonumber(heal_amount),
                            mana = tonumber(mana_cost),
                              id = i }

            table.insert(_heal_data[_class][spell_type], entry)

            _spell_ids[spell_name .. '(' .. spell_rank .. ')'] = entry
            _best_spell_ids[spell_name]                        = entry

            debug('insert', _class, spell_type, entry.name, entry.max_heal, entry.mana)

         end

      end

      i = i + 1

   end

   -- sort the heal spells by mana cost within each spell type

   if _heal_data[_class] then

      for spell_type in _heal_data[_class] do

         debug(spell_type, _heal_data[_class][spell_type])
         table.sort(_heal_data[_class][spell_type], function(a,b) return a.mana < b.mana end)
         for j in _heal_data[_class][spell_type] do
            debug(_heal_data[_class][spell_type][j].name, _heal_data[_class][spell_type][j].mana)
         end

      end

   end

   -- fill in my curables as well

   _my_curables = {}

   for i in _all_cures do

      local cure_name  = _all_cures[i].spell
      local cures      = _all_cures[i].cures

      if _best_spell_ids[cure_name] then

         for i in cures do
            _my_curables[ cures[i]] = cure_name
         end

      end

   end

end

function CastParty_SpeakSpell(unit, spell, duration)

   if not duration then duration = 0 end

   duration = string.format('%.1f', duration / 1000)

   local message_text = _hpc.message_text

   message_text = string.gsub(message_text, '%%s', spell.name)
   message_text = string.gsub(message_text, '%%d', duration)
   message_text = string.gsub(message_text, '%%r', spell.rank)

   if unit == 'party' then
      message_text = string.gsub(message_text, '%%t', 'party')
   else
      message_text = string.gsub(message_text, '%%t', UnitName(unit))
   end

   if _hpc.message_player_only and DEFAULT_CHAT_FRAME then
      DEFAULT_CHAT_FRAME:AddMessage(message_text)
   elseif ( UnitInParty(unit) and UnitInParty('party1') ) or unit == 'party' then
      SendChatMessage(message_text, 'PARTY')
   elseif UnitIsPlayer(unit) and not unit == 'player' then
      SendChatMessage(message_text, "WHISPER", nil, UnitName(unit))
   end
end

--
-- Healing Functions
--

function CastParty_ApplyEfficientHeal(unit)

   _force_heal = 'efficient'

   if not _heal_data[_class][_force_heal] then
      return
   end

   CastParty_ApplyHeal(unit)

   _force_heal = false

end

function CastParty_ApplyEmergencyHeal(unit)

   _force_heal = 'emergency'

   if not _heal_data[_class][_force_heal] then
      return
   end

   CastParty_ApplyHeal(unit)

   _force_heal = false

end

function CastParty_ApplyInstantHeal(unit)

   _force_heal = 'instant'

   if not _heal_data[_class][_force_heal] then
      return
   end

   CastParty_ApplyHeal(unit)

   _force_heal = false

end

function CastParty_ApplyHeal(unit)

   if not _heal_data[_class] then
      return
   end

   local health     = UnitHealth(unit)
   local health_max = UnitHealthMax(unit)

   local spell = CastParty_ChooseSpell(health, health_max)

   if not spell then return end

   debug('Spell chosen', spell.name)

   -- if we have another friendly unit targeted that is not the clicked player, we need
   -- to target the clicked player first
   if UnitIsFriend('player', 'target') and not UnitIsUnit('target', unit) then
     TargetUnit(unit)
   end

   _spell_target_unit = unit
   _spell_being_cast  = spell
   CastSpell(spell.id, SpellBookFrame.bookType)
   SpellTargetUnit(unit)

   -- stop targeting just in case we did not apply the spell successfully
   if SpellIsTargeting() then SpellStopTargeting() end

end

-- sort helper for sorting units based on health
local function CastParty_CompareHealth(unit_a, unit_b)
   return unit_a.health < unit_b.health
end

local function CastParty_UnitNeedsHeal(unit)

   if UnitHealth(unit) <= 0 or UnitHealth(unit) >= UnitHealthMax(unit) then
      debug(unit, 'does not benefit from healing')
      return false
   end

   debug(unit, 'needs heal')

   return true

end

-- returns true if the unit is healable, false otherwise
local function CastParty_UnitIsHealable(unit)

   if not UnitExists(unit) then
      debug(unit, 'does not exist')
      return false
   end

   if not UnitIsFriend('player', unit) then
      debug(unit, 'is not a friend')
      return false
   end

   if UnitIsEnemy(unit, 'player') then
      debug(unit, 'is an enemy')
      return false
   end

   if UnitCanAttack(unit, 'player') then
      debug(unit, 'can attack player')
      return false
   end

   if UnitCanAttack('player', unit) then
      debug(unit, 'can be attacked by player')
      return false
   end

   if not unit == 'player' and not UnitCanCooperate('player', unit) then
      debug(unit, 'cannot cooperate with player')
      return false
   end

   if not UnitIsConnected(unit) then
      debug(unit, 'is not connected')
      return false
   end

   if UnitIsDead(unit) then
      debug(unit, 'is dead')
      return false
   end

   if UnitIsGhost(unit) then
      debug(unit, 'is ghost')
      return false
   end

   debug(unit, 'is healable')

   return true

end

-- interpolates the health of the given unit (used for those outside the party)
function CastParty_UnitInterpolateHealth(unit, health_percent)
   local class      = UnitClass(unit)
   local level      = UnitLevel(unit)
   debug('interpolate', class, level)
   local slope      = ( _class_health[class]["60"] - _class_health[class]["1"] ) / 59
   local health_max = level * slope + _class_health[class]["1"]
   local health     = health_max * health_percent / 100
   return health, health_max
end

function CastParty_CureAny(unit)
   local next_cure = _ills[unit][1]
   if next_cure then
      if next_cure == _cpc.CURE_MAGIC_1 and not UnitIsUnit('target', unit) then
         local retarget_enemy = UnitIsEnemy('target', 'player')
         TargetUnit(unit)
         CastSpell(_best_spell_ids[next_cure]['id'], SpellBookFrame.bookType)
         if retarget_enemy then
            TargetLastEnemy()
         end
      else
         if UnitIsFriend('player', 'target') and not UnitIsUnit('target', unit) then
            TargetUnit(unit)
         end
         CastSpell(_best_spell_ids[next_cure]['id'], SpellBookFrame.bookType)
         SpellTargetUnit(unit)
      end
      return true
   end
   return false
end

function CastParty_CurePartyMember()

   for unit in _ids do
      if UnitExists(unit) and CastParty_CureAny(unit) then
         return true
      end
   end

   return false

end

-- key-bindable function that heals a party member based on percent health
function CastParty_DoTheRightThing()

   if not _heal_data[_class] then
      return
   end

   -- always heal the target if possible.
   if CastParty_UnitIsHealable('target') then

      if CastParty_UnitNeedsHeal('target') then

         local health     = UnitHealth('target')
         local health_max = UnitHealthMax('target')

         if not UnitInParty('target') then
            health, health_max = CastParty_UnitInterpolateHealth('target', health)
         end

         local spell = CastParty_ChooseSpell(health, health_max)

         if spell then
            debug('Spell chosen', spell.name)
            _spell_target_unit  = 'target'
            _spell_being_cast   = spell
            CastSpell(spell.id, SpellBookFrame.bookType)
         end

      end

      return

   end

   -- next test group healing

   local group_heal_spell = CastParty_TestGroupHeal()

   if group_heal_spell then
      _spell_target_unit  = 'party'
      _spell_being_cast   = group_heal_spell
      CastSpell(group_heal_spell.id, SpellBookFrame.bookType)
      return
   end

   -- Otherwise heal the party member with the lowest % health

   local group_status = {}

   for i in _ids do

      if CastParty_UnitIsHealable(i) and CastParty_UnitNeedsHeal(i) then

         local health     = UnitHealth(i)
         local health_max = UnitHealthMax(i)

         table.insert(group_status, { name = i,
                                    health = health / health_max,
                                   current = health,
                                   maximum = health_max })

      end

   end

   table.sort(group_status, CastParty_CompareHealth)

   for i,j in pairs(group_status) do

      debug('healing: ' .. j.name)

      local spell = CastParty_ChooseSpell(j.current, j.maximum)

      if spell then
         debug('Spell chosen', spell.name)
         _spell_target_unit  = j.name
         _spell_being_cast   = spell
         CastSpell(spell.id, SpellBookFrame.bookType)
         SpellTargetUnit(j.name)
         do break end
      end

   end

end

-- determine what spell is most appropriate given the health and max health
-- takes into accoutn the current state of affairs as well
function CastParty_ChooseSpell(health, health_max)

   local force_heal = _force_heal

   if _hpc.hot_key_style == 'serial' then
      _force_heal = false
   end

   local mana = UnitMana('player')

   local health_target   = health_max * _hpc.spell_choice_threshold
   local health_fraction = health / health_max

   local spell

   -- always choose the highest heal when forced
   if force_heal and _heal_data[_class][force_heal] then
      debug('heal forced', force_heal)

      -- always choose the best instant and group heals based on mana
      if force_heal == 'instant' or force_heal == 'group' then
         for i in _heal_data[_class][force_heal] do
            if _heal_data[_class][force_heal][i]['mana'] <= mana then
               spell = _heal_data[_class][force_heal][i]
            end
         end
         return spell
      end

      -- otherwise choose the best efficient/emergency based on mana and health
      for i in _heal_data[_class][force_heal] do
         if _heal_data[_class][force_heal][i]['mana'] <= mana then
            spell = _heal_data[_class][force_heal][i]
            -- break the search early if we find a smaller sufficient heal
            if _heal_data[_class][force_heal][i]['max_heal'] + health >= health_target then
               do break end
            end
         end
      end

      return spell

   end

   -- if the player is moving at least try an instant heal
   if _is_moving and _heal_data[_class]['instant'] then
      for i in _heal_data[_class]['instant'] do
         if _heal_data[_class]['instant'][i]['mana'] <= mana then
            spell = _heal_data[_class]['instant'][i]
         end
      end
      return spell
   end

   -- if the player is involved i combat or the target is very low use an emergency heal

   local try_emergency = false

   if (_hpc.emergency_in_combat
         and PlayerFrame.onHateList
         and _last_player_damage
         and GetTime() - _last_player_damage < _hpc.emergency_damage_window) then
      try_emergency = true
   end

   if health_fraction < _hpc.emergency_health_percent then
      try_emergency = true
   end

   if try_emergency and _heal_data[_class]['emergency'] then
      for i in _heal_data[_class]['emergency'] do
         if _heal_data[_class]['emergency'][i]['mana'] <= mana then
            spell = _heal_data[_class]['emergency'][i]
            -- break the search early if we find a smaller sufficient heal
            if _heal_data[_class]['emergency'][i]['max_heal'] + health >= health_target then
               do break end
            end
         end
      end
   end

   if spell then return spell end

   -- otherwise try an efficient heal
   for i in _heal_data[_class]['efficient'] do
      debug('testing', _heal_data[_class]['efficient'][i]['name'])
      debug('cost', _heal_data[_class]['efficient'][i]['mana'], 'pool', mana)
      if _heal_data[_class]['efficient'][i]['mana'] <= mana then
         spell = _heal_data[_class]['efficient'][i]
         -- break the search early if we find a smaller sufficient heal
         if _heal_data[_class]['efficient'][i]['max_heal'] + health >= health_target then
            do break end
         end
      end
   end

   return spell

end

function CastParty_TestGroupHeal()

   -- be sure the player has an up to date config
   if not _hpc.auto_group_threshold then
      return false
   end

   -- be sure the player has group heals
   if not ( _heal_data[_class] and _heal_data[_class]['group'] ) then
      return false
   end

   local group_heal_name = _heal_data[_class]['group'][1].name
   local best_group_heal = _best_spell_ids[group_heal_name]

   if best_group_heal then

      -- see how much we could possible heal the group

      local total_heal = 0
      for unit in _ids do
         if CastParty_UnitIsHealable(unit) and UnitInParty(unit) then
            total_heal = total_heal + math.min( UnitHealthMax(unit) - UnitHealth(unit), best_group_heal.max_heal )
         end
      end

      local efficient_heal_name = _heal_data[_class]['efficient'][ getn(_heal_data[_class]['efficient']) ].name
      local best_efficient_heal = _best_spell_ids[efficient_heal_name]

      if best_efficient_heal then

         local group_heal_ratio     = total_heal / best_group_heal.mana
         local efficient_heal_ratio = best_efficient_heal.max_heal / best_efficient_heal.mana

         debug('Group heal total', total_heal, 'Group heal mana', best_group_heal.mana, 'Group heal ratio', group_heal_ratio)
         debug('Single heal total', best_efficient_heal.max_heal, 'Single heal mana', best_efficient_heal.mana, 'Single heal ratio', efficient_heal_ratio)

         if group_heal_ratio >= efficient_heal_ratio * _hpc.auto_group_threshold then

            return best_group_heal

         end

      end

   end

   return false

end

--
-- UI Functions
--

function CastParty_ForceHeal(keystate, heal_type)

   if not _heal_data[_class][heal_type] then
      return
   end

   if keystate == 'down' then
      _force_heal = heal_type
   else

      if _hpc.hot_key_style ~= 'serial' then
            _force_heal = false
      end

   end

   debug(heal_type, _force_heal)

end

local function CastParty_HealthRGB(percent_full)
   local r,g
   r = max(min(2 - (percent_full * 2), 1), 0)
   g = max(min(0 + (percent_full * 2), 1), 0)
   return { r = r, g = g, b = 0 }
end

local function CastParty_ManaRGB(percent_full)
   local r,b
   r = max(min(2 - (percent_full * 2), 1), 0)
   b = max(min(0 + (percent_full * 2), 1), 0)
   return { r = r, g = 0, b = b }
end

local function CastParty_UpdateIdHealth(id)

   local name_text  = getglobal('CastPartyMember' .. id .. 'Name')
   local health_bar = getglobal('CastPartyMember' .. id .. 'HealthBar')
   local health     = UnitHealth(_units[id])
   local health_max = UnitHealthMax(_units[id])
   local unit_name  = UnitName(_units[id])
   local health_percent = '0%'
   local unit_class = UnitClass(_units[id])

   if health_max ~= 0 then
      health_percent = string.format('%d', 100 * health / health_max)
   end

   if not (health and health_max and unit_name) then
      return
   end

   name_text:SetTextColor(_hpc.text_rgb.r, _hpc.text_rgb.g, _hpc.text_rgb.b)

   local unit_bar_text = _hpc.unit_text_template

   unit_bar_text = string.gsub(unit_bar_text, '%%n', unit_name)
   unit_bar_text = string.gsub(unit_bar_text, '%%m', health_max)
   unit_bar_text = string.gsub(unit_bar_text, '%%h', health)
   unit_bar_text = string.gsub(unit_bar_text, '%%d', -1 * ( health_max - health ) )
   unit_bar_text = string.gsub(unit_bar_text, '%%p', health_percent )
   unit_bar_text = string.gsub(unit_bar_text, '%%c', unit_class )
   unit_bar_text = string.gsub(unit_bar_text, '%%l', UnitLevel(_units[id]) )

   name_text:SetText(unit_bar_text)

   health_bar:SetMinMaxValues(0, health_max)

   if _hpc.grow_with_depletion then
      health_bar:SetValue(health_max - health)
   else
      health_bar:SetValue(health)
   end

   if health_max > 0 then
      local health_percent = health / health_max
      local health_rgb = _hpc.health_rgb or CastParty_HealthRGB(health_percent)
      health_bar:SetStatusBarColor( health_rgb.r, health_rgb.g, health_rgb.b)
   end

end

local function CastParty_UpdateIdMana(id)
   local mana_bar   = getglobal('CastPartyMember' .. id .. 'ManaBar')
   if UnitPowerType(_units[id]) == 0 then
      local mana = UnitMana(_units[id])
      local mana_max = UnitManaMax(_units[id])
      mana_bar:SetMinMaxValues(0, mana_max)

      if _hpc.grow_with_depletion then
         mana_bar:SetValue(mana_max - mana)
      else
         mana_bar:SetValue(mana)
      end

      if mana_max > 0 then
         local mana_percent = mana / mana_max
         local mana_rgb = _hpc.mana_rgb or CastParty_ManaRGB(mana_percent)
         mana_bar:SetStatusBarColor( mana_rgb.r, mana_rgb.g, mana_rgb.b)
      end

   else
      mana_bar:SetMinMaxValues(0, 100)
      mana_bar:SetValue(0)
   end
end

local function CastParty_UpdateId(id)

   local button = getglobal('CastPartyMember' .. id)

   if UnitExists(_units[id]) and button then

      local name_text = getglobal('CastPartyMember' .. id .. 'Name')

      CastParty_UpdateIdHealth(id)
      CastParty_UpdateIdMana(id)

      button:Show()

      return 1

   end

   if button then
      button:Hide()
   end

   return 0

end

local function CastParty_UpdateParty()

   local party_count = 0

   for i = 0,4 do
      party_count = party_count + CastParty_UpdateId(i)
   end

end


function CastParty_LayoutUI()

   CastPartyMainFrame:SetWidth(_hpc.bar_width + 8)
   CastPartyMainFrame:SetHeight(_hpc.health_bar_height + _hpc.mana_bar_height + 8)

   debug('adjusting UI')

   for id = 0,4 do
      local member_button = getglobal('CastPartyMember' .. id)

      member_button:SetWidth(_hpc.bar_width)
      member_button:SetHeight(_hpc.health_bar_height + _hpc.mana_bar_height)


      if _hpc.show_statusbar_frames then

         local member_texture = getglobal('CastPartyMember' .. id .. 'Texture')

         member_texture:SetWidth(_hpc.bar_width + 8)
         member_texture:SetHeight(_hpc.health_bar_height + _hpc.mana_bar_height + 8)

         member_texture:Show()

      else

         local member_texture = getglobal('CastPartyMember' .. id .. 'Texture')

         member_texture:Hide()

      end

      local member_health_bar = getglobal('CastPartyMember' .. id .. 'HealthBar')

      member_health_bar:SetWidth(_hpc.bar_width)
      member_health_bar:SetHeight(_hpc.health_bar_height)
      member_health_bar:SetFrameLevel(3)

      local member_health_bar_bg = getglobal('CastPartyMember' .. id .. 'HealthBarBG')

      member_health_bar_bg:SetWidth(_hpc.bar_width)
      member_health_bar_bg:SetHeight(_hpc.health_bar_height)
      member_health_bar_bg:SetStatusBarColor( _hpc.health_bg_rgb.r, _hpc.health_bg_rgb.g, _hpc.health_bg_rgb.b, _hpc.health_bg_rgb.a)
      member_health_bar_bg:SetFrameLevel(2)

      local member_mana_bar = getglobal('CastPartyMember' .. id .. 'ManaBar')

      member_mana_bar:SetWidth(_hpc.bar_width)
      member_mana_bar:SetHeight(_hpc.mana_bar_height)
      member_mana_bar:SetFrameLevel(3)

      local member_mana_bar_bg = getglobal('CastPartyMember' .. id .. 'ManaBarBG')

      member_mana_bar_bg:SetWidth(_hpc.bar_width)
      member_mana_bar_bg:SetHeight(_hpc.mana_bar_height)
      member_mana_bar_bg:SetStatusBarColor( _hpc.mana_bg_rgb.r, _hpc.mana_bg_rgb.g, _hpc.mana_bg_rgb.b, _hpc.mana_bg_rgb.a)
      member_mana_bar_bg:SetFrameLevel(2)

      if _hpc.aura_alignment == 'below' then

         local aura_frame = getglobal('CastPartyMember' .. id .. 'Aura1')

         aura_frame:ClearAllPoints()
         aura_frame:SetPoint("TOPLEFT", 'CastPartyMember' .. id, "BOTTOMLEFT", 0, -3)

         if id > 0 then
            member_button:ClearAllPoints()
            member_button:SetPoint("TOPLEFT", 'CastPartyMember' .. id - 1, "BOTTOMLEFT", 0, -27)
         end

      end

   end

   if _hpc.aura_alignment == 'left' then

      for id = 0,4 do

         -- move auras

         local aura_frame = getglobal('CastPartyMember' .. id .. 'Aura1')

         aura_frame:ClearAllPoints()
         aura_frame:SetPoint("RIGHT", 'CastPartyMember' .. id, "LEFT", -2, 0)

         for aura = 2,12 do

            local aura_frame   = getglobal('CastPartyMember' .. id .. 'Aura' .. aura)

            aura_frame:ClearAllPoints()
            aura_frame:SetPoint("RIGHT", 'CastPartyMember' .. id .. 'Aura' .. aura - 1, "LEFT", -2, 0)

         end

         -- move flags

         local flag_frame = getglobal('CastPartyMember' .. id .. 'Flag1')

         flag_frame:ClearAllPoints()
         flag_frame:SetPoint("LEFT", 'CastPartyMember' .. id, "RIGHT", 4, 0)

         for flag = 2,3 do

            local flag_frame   = getglobal('CastPartyMember' .. id .. 'Flag' .. flag)

            flag_frame:ClearAllPoints()
            flag_frame:SetPoint("LEFT", 'CastPartyMember' .. id .. 'Flag' .. flag - 1, "RIGHT", 4, 0)

         end

      end

   end


end

function CastParty_EnterAura()

   if not _hpc.show_aura_tooltips then
      return
   end

   debug('enter aura', this:GetID(), this:GetParent():GetID())
   GameTooltip:SetOwner(this, "ANCHOR_RIGHT")

   local unit = _units[ this:GetParent():GetID() ]

   if _auras[unit][ this:GetID() ].debuff_index then
      GameTooltip:SetUnitDebuff(unit, _auras[unit][ this:GetID() ].debuff_index)
   else
      GameTooltip:SetUnitBuff(unit, _auras[unit][ this:GetID() ].buff_index)
   end

end

function CastParty_EnterUnit()

   if not _hpc.show_party_tooltips then
      return
   end

   debug('enter unit', this:GetID())
   GameTooltip:SetOwner(this, "ANCHOR_RIGHT")

   local unit = _units[ this:GetID() ]

   GameTooltip:SetUnit(unit)
end

function CastParty_UpdatePartyFlagIcons()
   debug('party flag icons')
   for unit in _flags do
      CastParty_UpdateUnitFlagIcons(unit)
   end
end

function CastParty_UpdatePartyAuras()

   for unit in _ids do
      CastParty_UpdateUnitAuras(unit)
   end

end

function CastParty_UpdateUnitAuras(unit)

   _auras[unit] = {}
   _ills[unit]  = {}

   if _hpc.show_debuffs then

      for i = 1,8 do

         local debuff_texture = UnitDebuff(unit, i)

         if debuff_texture then

            CastParty_TooltipTextRight1:SetText(nil);
            CastParty_Tooltip:SetUnitDebuff(unit, i)
            local debuff_name = CastParty_TooltipTextLeft1:GetText()
            local debuff_type = CastParty_TooltipTextRight1:GetText()

            -- record ailments for curing purposes
            if debuff_type and _my_curables and _my_curables[debuff_type] then
               table.insert(_ills[unit], _my_curables[debuff_type])
            end

            -- filter visible debuffs
            local add_debuff = true

            if _hpc.filter_debuffs then

               -- don't show debuffs that have a nil type, or we can't cure
               if (not debuff_type) or (debuff_type and not _my_curables[debuff_type]) then
                  add_debuff = false
               end

               -- but always show Weakened Soul for a Priest
               if _class == _cpc.CLASS_PRIEST and debuff_name == _cpc.DEBUFF_WS then
                  add_debuff = true
               end

            end

            if add_debuff then
               table.insert(_auras[unit], {icon = debuff_texture, overlay = 'Interface\\Buttons\\UI-Debuff-Border', debuff_index = i})
            end

         end

      end

   end

   if _hpc.show_buffs then

      for i = 1,16 do

         local buff_texture = UnitBuff(unit, i)

         if buff_texture then

            local add_buff = true

            if _hpc.filter_buffs then

               CastParty_Tooltip:SetUnitBuff(unit, i)
               local buff_name = CastParty_TooltipTextLeft1:GetText()

               if not _best_spell_ids[buff_name] then
                  add_buff = false
               end

               if _class == _cpc.CLASS_SHAMAN and ( _best_spell_ids[buff_name .. ' Totem'] or
                                           buff_name == 'Grounding Totem Effect' ) then
                  add_buff = true
               end

            end

            if add_buff then
               table.insert(_auras[unit], {icon = buff_texture, overlay = 'Interface\\AddOns\\CastParty\\CastParty_Buff-Border', buff_index = i})
            end

         end

      end

   end

   for i = 1, _max_debuffs + _max_buffs do
      if _auras[unit][i] then
         debug('aura', unit, i, _auras[unit][i].icon, _auras[unit][i].overlay)
         getglobal('CastPartyMember' .. _ids[unit] .. 'Aura' .. i .. 'Icon'):SetTexture(_auras[unit][i].icon)
         getglobal('CastPartyMember' .. _ids[unit] .. 'Aura' .. i .. 'Overlay'):SetTexture(_auras[unit][i].overlay);
         getglobal('CastPartyMember' .. _ids[unit] .. 'Aura' .. i):Show()
      else
         getglobal('CastPartyMember' .. _ids[unit] .. 'Aura' .. i):Hide()
      end
   end

end

function CastParty_UpdateUnitFlagIcons(unit)

   debug('unit flag icons', unit)

   local icon_index = 1

   for i in _flags[unit] do
      debug('flag icon', unit, i, _flags[unit][i])
      local icon_frame = getglobal('CastPartyMember' .. _ids[unit] .. 'Flag' .. icon_index)
      if _flags[unit][i] then
         local icon_texture = getglobal('CastPartyMember' .. _ids[unit] .. 'Flag' .. icon_index .. 'Icon')
         icon_texture:SetTexture(_flags[unit][i])
         icon_frame:Show()
         icon_index = icon_index + 1
      end
   end

   for i = icon_index,3 do
      local icon_frame = getglobal('CastPartyMember' .. _ids[unit] .. 'Flag' .. i)
      icon_frame:Hide()
   end

end

function CastParty_UpdatePartyFlags()
   debug('party flags')
   for i in _flags do
      CastParty_UpdateUnitPVP(i)
   end
   CastParty_UpdatePartyLeader()
   CastParty_UpdateLootMaster()
end

function CastParty_UpdateUnitPVP(unit)

   debug('unit pvp', unit)

   local factionGroup = UnitFactionGroup(unit);

   if UnitIsPVPFreeForAll(unit) then
      _flags[unit].pvp = 'Interface\\TargetingFrame\\UI-PVP-FFA'
   elseif factionGroup and UnitIsPVP(unit) then
      _flags[unit].pvp = 'Interface\\GroupFrame\\UI-Group-PVP-' .. factionGroup
   else
      _flags[unit].pvp = false
   end

   debug('pvp update', unit, _flags[unit].pvp)

end

function CastParty_UpdatePartyLeader()

   debug('update party leader')

   for unit in _flags do
      if UnitIsPartyLeader(unit) then
         _flags[unit].leader = 'Interface\\GroupFrame\\UI-Group-LeaderIcon'
         debug('party leader: ' .. unit)
      else
         _flags[unit].leader = false
      end
   end

end

function CastParty_UpdateLootMaster()

   debug('loot master')

   local loot_method, loot_master_id = GetLootMethod()

   for i = 0,4 do
      local unit = _units[i]
      if loot_master_id and loot_master_id == i then
         _flags[unit].master = 'Interface\\GroupFrame\\UI-Group-MasterLooter'
      else
         _flags[unit].master = false
      end
   end

end

function CastParty_PartyDropDown(unit)

   if unit == 'player' then
      debug('CastParty_PlayerFrameDropDown', unit)
      ToggleDropDownMenu(1, nil, PlayerFrameDropDown, 'CastPartyMember0', _hpc.bar_width, _hpc.health_bar_height + _hpc.mana_bar_height)
   else
      debug('CastParty_PlayerFrameDropDown', unit)
      ToggleDropDownMenu(1, nil, getglobal("PartyMemberFrame".._ids[unit].."DropDown"), 'CastPartyMember' .. _ids[unit], _hpc.bar_width, _hpc.health_bar_height + _hpc.mana_bar_height)
   end

end

function CastParty_WoWDefaultClick(unit)
   if _click_button == "LeftButton" then
      TargetUnit(unit)
   else
      CastParty_PartyDropDown(unit)
   end
end

function CastParty_ListBindings()
   local tmp_array = {}
   for i in _hpc.key_bindings do
      table.insert(tmp_array, { name = i, value = _hpc.key_bindings[i] } )
   end
   table.sort(tmp_array, function(a,b) return a.name < b.name end)
   for i in tmp_array do
      DEFAULT_CHAT_FRAME:AddMessage(tmp_array[i].name .. ':   ' .. tmp_array[i].value)
   end
end

--
-- Event Handlers
--

_event_dispatch['PLAYER_ENTERING_WORLD'] = function ()

   _class = UnitClass('player')

   if _class and not _heal_data[_class] and _hpc.hide_unless_healer then
      CastPartyMainFrame:Hide()
      CastPartyMainFrame:ClearAllPoints()
      CastPartyMainFrame:UnregisterEvent("UNIT_HEALTH")
      CastPartyMainFrame:UnregisterEvent("UNIT_HEALTHMAX")
      CastPartyMainFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED")
      CastPartyMainFrame:UnregisterEvent("UNIT_NAME_UPDATE");
      CastPartyMainFrame:UnregisterEvent("UNIT_MANA")
      CastPartyMainFrame:UnregisterEvent("UNIT_MANAMAX")
      CastPartyMainFrame:UnregisterEvent("SPELLS_CHANGED")
      CastPartyMainFrame:UnregisterEvent("UNIT_AURA")
      CastPartyMainFrame:UnregisterEvent("PARTY_LEADER_CHANGED");
      CastPartyMainFrame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED");
      CastPartyMainFrame:UnregisterEvent("UNIT_PVP_UPDATE");
      CastPartyMainFrame:UnregisterEvent("SPELLCAST_START");
      CastPartyMainFrame:UnregisterEvent("SPELLCAST_STOP");
      CastPartyMainFrame:UnregisterEvent("SPELLCAST_FAILED");
      CastPartyMainFrame:UnregisterEvent("SPELLCAST_INTERRUPTED");
      return
   end

   CastParty_LayoutUI()

   CastParty_UpdateParty()

   CastParty_LoadSpellData()

   CastParty_UpdatePartyFlags()

   CastParty_UpdatePartyFlagIcons()

   if _hpc.hide_party_frame then
      HidePartyFrame()
   end

end

_event_dispatch['UNIT_NAME_UPDATE'] = function (unit)

   if _ids[unit] then
      CastParty_UpdateId(_ids[unit])
   end

end

_event_dispatch['UNIT_PVP_UPDATE'] = function (unit)

   if _ids[unit] then
      debug('pvp change', unit)
      CastParty_UpdateUnitPVP(unit)
      CastParty_UpdateUnitFlagIcons(unit)
   end

end

_event_dispatch['PARTY_LEADER_CHANGED'] = function ()

   CastParty_UpdatePartyFlags()

   CastParty_UpdatePartyFlagIcons()

end

_event_dispatch['PARTY_LOOT_METHOD_CHANGED'] = function ()

   CastParty_UpdatePartyFlags()

   CastParty_UpdatePartyFlagIcons()

end

_event_dispatch['PARTY_MEMBERS_CHANGED'] = function ()

   CastParty_UpdateParty()

   CastParty_UpdatePartyFlags()

   CastParty_UpdatePartyFlagIcons()

   CastParty_UpdatePartyAuras()

end

_event_dispatch['UNIT_HEALTH'] = function (unit)

   if _ids[unit] then
      CastParty_UpdateIdHealth(_ids[unit])
   end

   -- cancel healing spells if they become inefficient
   if _casting_now and
      _spell_target_unit and
      _spell_being_cast and
      _spell_being_cast.max_heal and
      _hpc.heal_cancel_threshold and
      UnitIsUnit(unit, _spell_target_unit) then

      local health_curr = UnitHealth(_spell_target_unit)
      local health_max  = UnitHealthMax(_spell_target_unit)

      if health_curr > 0 and health_max > 0 then

         if not UnitInParty(_spell_target_unit) then
            health_curr, health_max = CastParty_UnitInterpolateHealth(_spell_target_unit, health_curr / health_max)
         end

         local heal_amount = health_max - health_curr

         if heal_amount / _spell_being_cast.max_heal < _hpc.heal_cancel_threshold then
            debug('spell stopped', 'heal amount', heal_amount, 'max heal', _spell_being_cast.max_heal)
            SpellStopCasting()
         end

      end

   end

   -- make note of the last time the player took damage
   -- this is an overly simple way to see what the health trend is
   if unit == 'player' then
      local current_health = UnitHealth('player')
      if _last_player_health then
         if current_health < _last_player_health then
            _last_player_damage = GetTime()
         end
      end
      _last_player_health = current_health
   end

end

_event_dispatch['UNIT_HEALTH_MAX'] = function (unit)

   if _ids[unit] then
      CastParty_UpdateIdHealth(_ids[unit])
   end

end

_event_dispatch['UNIT_MANA'] = function (unit)

   if _ids[unit] then
      CastParty_UpdateIdMana(_ids[unit])
   end

end

_event_dispatch['UNIT_AURA'] = function (unit)

   if _ids[unit] then
      CastParty_UpdateUnitAuras(unit)
   end

end

_event_dispatch['UNIT_MANA_MAX'] = function (unit)

   if _ids[unit] then
      CastParty_UpdateIdMana(_ids[unit])
   end

end

_event_dispatch['SPELLCAST_START'] = function (spell_name, duration)

   _casting_now = true

   if not ( _hpc.message_text and _spell_target_unit and _spell_being_cast ) then
      return
   end

   if _hpc.message_non_heals and not _heal_types[_class] or not _heal_types[_class][_spell_being_cast.name] then
      CastParty_SpeakSpell(_spell_target_unit, _spell_being_cast, duration)
   end

   local health_curr = UnitHealth(_spell_target_unit)
   local health_max  = UnitHealthMax(_spell_target_unit)

   if ( health_max > 0 and ( health_curr / health_max ) <= _hpc.message_health_percent ) or _spell_target_unit == 'party' then

      if (_hpc.message_heals and _heal_types[_class] and _heal_types[_class][_spell_being_cast.name]) then
         CastParty_SpeakSpell(_spell_target_unit, _spell_being_cast, duration)
      end

   end

end

_event_dispatch['SPELLS_CHANGED'] = function ()

   -- we only want spell changes after entering the world
   if not _class then
      return
   end

   _heal_data = {
     [_cpc.CLASS_SHAMAN]  = {},
     [_cpc.CLASS_PRIEST]  = {},
     [_cpc.CLASS_DRUID]   = {},
     [_cpc.CLASS_PALADIN] = {},
   }

   CastParty_LoadSpellData()

end

_event_dispatch['SPELLCAST_STOP'] = function ()
   _spell_target_unit = nil
   _spell_being_cast  = nil
   _casting_now       = false
end

_event_dispatch['SPELLCAST_FAILED'] = function ()
   _spell_target_unit = nil
   _spell_being_cast  = nil
   _casting_now       = false
end

_event_dispatch['SPELLCAST_INTERRUPTED'] = function ()
   _spell_target_unit = nil
   _spell_being_cast  = nil
   _casting_now       = false
end

--
-- Game Client Handlers
--

function CastParty_OnLoad()
   debug('OnLoad', UnitClass('player'))

   BINDING_HEADER_HEALOMATIC               = 'Healomatic'
   BINDING_NAME_HEALOMATIC_DOTHERIGHTTHING = 'Do the Right Thing'
   BINDING_NAME_HEALOMATIC_CUREPARTYMEMBER = 'Cure Party Member'
   BINDING_NAME_HEALOMATIC_EFFICIENT       = 'Efficient Only'
   BINDING_NAME_HEALOMATIC_EMERGENCY       = 'Emergency Only'
   BINDING_NAME_HEALOMATIC_GROUP           = 'Group Only'
   BINDING_NAME_HEALOMATIC_INSTANT         = 'Instant Only'

end

function CastParty_BuildActionKey(button)

   local action_key = button

   if IsAltKeyDown() then
      action_key = action_key .. '_Alt'
   end

   if IsControlKeyDown() then
      action_key = action_key .. '_Control'
   end

   if IsShiftKeyDown() then
      action_key = action_key .. '_Shift'
   end

   return action_key

end

function CastParty_OnClick(button)

   _click_button = button

   local id = this:GetID()

   debug('OnClick', id, button)

   local unit = _units[id]

   if not UnitExists(unit) then
      return
   end

   -- if a spell is already targeting, cast it on the clicked player and return
   if SpellIsTargeting() then
      if button == 'LeftButton' then
         SpellTargetUnit(unit)
         return
      elseif button == 'RightButton' then
         SpellStopTargeting()
         return
      end
   end

   -- always take care of items on cursor with left clicks
   if button == "LeftButton" and CursorHasItem() then
      if unit == 'player' then
         AutoEquipCursorItem()
      else
         DropItemOnUnit(unit)
      end
      return
   end

   local action_key = CastParty_BuildActionKey(button)

   debug('action key', action_key)

   local action

   if _hpc.key_bindings[_class] and _hpc.key_bindings[_class][action_key] then
      action = _hpc.key_bindings[_class][action_key]
   else
      action = _hpc.key_bindings[action_key]
   end

   debug('action', action)

   -- execute a function action
   if type(action) == 'function' then
      action(unit)
      return
   end

   -- lookup a global function action
   local action_global = getglobal(action)
   if type(action_global) == 'function' then
      action_global(unit)
      return
   end

   -- cast a particular spell
   if _spell_ids[action] then

      -- if we have another friendly unit targeted that is not the clicked player, we need
      -- to target the clicked player first
      if UnitIsFriend('player', 'target') and not UnitIsUnit('target', unit) then
        TargetUnit(unit)
      end

      _spell_target_unit = unit
      _spell_being_cast  = _spell_ids[action]
      CastSpell(_spell_ids[action]['id'], SpellBookFrame.bookType)
      SpellTargetUnit(unit)
      return
   end

   -- cast the best of a particular spell series
   if _best_spell_ids[action] then

      -- if we have another friendly unit targeted that is not the clicked player, we need
      -- to target the clicked player first
      if UnitIsFriend('player', 'target') and not UnitIsUnit('target', unit) then
        TargetUnit(unit)
      end

      _spell_target_unit = unit

      -- if a buff is chosen, cap the rank based on the spell target level
      if _class_buffs[_class] and _class_buffs[_class][action] then
         local rank         = CastParty_ChooseBuffRank(unit, action)
         local full_name    = action .. '(' .. _cpc.RANK .. ' ' .. rank .. ')'
         _spell_being_cast  = _spell_ids[full_name]
      else
         _spell_being_cast  = _best_spell_ids[action]
      end

      CastSpell(_spell_being_cast.id, SpellBookFrame.bookType)
      SpellTargetUnit(unit)
      return
   end

end

function CastParty_CastSpell(spell_name)

   -- cast a particular spell
   if _spell_ids[spell_name] then
      CastSpell(_spell_ids[spell_name]['id'], SpellBookFrame.bookType)
      return
   end

   -- cast the best of a particular spell series
   if _best_spell_ids[spell_name] then
      CastSpell(_best_spell_ids[spell_name]['id'], SpellBookFrame.bookType)
      return
   end

end


function CastParty_OnUpdate(delay)
   local playerX, playerY = GetPlayerMapPosition("player");
   if playerX ~= _priorX or playerY ~= _priorY then
      _is_moving = true
   else
      _is_moving = false
   end
   _priorX = playerX
   _priorY = playerY
end

local _profile = {}

function CastParty_Profile()
   for i in _profile do
      DEFAULT_CHAT_FRAME:AddMessage(i .. ': ' .. _profile[i].count .. ' times, ' ..
                                    string.format('%.3f', _profile[i].time) .. ' seconds')
   end
end

function CastParty_OnEvent()

   -- copy the globals ASAP
   -- do not use them anywhere else
   -- they are not to be trusted
   local _event, _arg1, _arg2 = event, arg1, arg2

--   if not _profile[_event] then
--      _profile[_event] = { count = 0, time = 0 }
--   end

   if _event_dispatch[_event] then
      --debug('OnEvent - yes dispatch', _event)
--      local start  = GetTime()
      _event_dispatch[_event](_arg1, _arg2)
--      local finish = GetTime()
--      _profile[_event].count = _profile[_event].count + 1
--      _profile[_event].time  = _profile[_event].time + (finish - start)
   else
      debug('OnEvent - no dispatch', _event, _arg1, _arg2)
   end

end

