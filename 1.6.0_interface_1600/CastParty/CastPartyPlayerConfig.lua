-- CastParty - by danboo
-- $Id: CastPartyPlayerConfig.lua,v 1.11 2005-03-22 17:08:14-05 danboo Exp danboo $

local _cpc = CastParty_constants

CastPartyPlayerConfig = {

   -- set the behaviors for the combinations you like.
   --
   -- if the value is a global function *name*, that function will be
   -- called with the unit id (e.g., 'player1') as the only argument.
   -- This can be a WoW defined function such as 'TargetUnit' or
   -- 'AssistUnit', or one defined by CastParty (see config section
   -- below for examples):
   --
   --    CastParty_ApplyHeal          - picks a heal based on damage, mana and combat
   --    CastParty_ApplyEfficientHeal - picks from *efficient* heals only
   --    CastParty_ApplyEmergencyHeal - picks from *emergency* heals only
   --    CastParty_ApplyInstantHeal   - picks from *instant* heals only
   --    CastParty_CureAny            - picks one of the right cures for whatever ails your target
   --    CastParty_WoWDefaultClick    - default WoW party frame behavior (use for left and right clicks only)
   --
   -- if the value is a spell name and rank (e.g., 'Healing Wave(Rank 1)') then
   -- that spell will be cast on the player that receives the click.
   --
   -- if the value is a spell name with *no* rank (e.g., 'Healing Wave') then
   -- the most powerful version of that spell will be cast on the player that
   -- receives the click. note that for buffs this takes the level of the recipient
   -- into consideration.
   --
   -- power users can even set the value to a function. that function will
   -- be callled with the unit id as the only argument
   --

   key_bindings = {

      -- generic class-wide bindings

      LeftButton                   = 'CastParty_ApplyHeal',
      LeftButton_Alt               = 'CastParty_ApplyEfficientHeal',
      LeftButton_Alt_Control       = nil,
      LeftButton_Alt_Control_Shift = nil,
      LeftButton_Alt_Shift         = nil,
      LeftButton_Control           = 'Heal',
      LeftButton_Control_Shift     = nil,
      LeftButton_Shift             = 'CastParty_WoWDefaultClick',

      RightButton                   = nil,
      RightButton_Alt               = 'CastParty_ApplyInstantHeal',
      RightButton_Alt_Control       = nil,
      RightButton_Alt_Control_Shift = nil,
      RightButton_Alt_Shift         = nil,
      RightButton_Control           = 'CastParty_CureAny',
      RightButton_Control_Shift     = nil,
      RightButton_Shift             = nil,

      MiddleButton                   = 'CastParty_PartyDropDown',
      MiddleButton_Alt               = nil,
      MiddleButton_Alt_Control       = nil,
      MiddleButton_Alt_Control_Shift = nil,
      MiddleButton_Alt_Shift         = nil,
      MiddleButton_Control           = nil,
      MiddleButton_Control_Shift     = nil,
      MiddleButton_Shift             = nil,

      Button4                   = 'CastParty_CureAny',
      Button4_Alt               = nil,
      Button4_Alt_Control       = nil,
      Button4_Alt_Control_Shift = nil,
      Button4_Alt_Shift         = nil,
      Button4_Control           = nil,
      Button4_Control_Shift     = nil,
      Button4_Shift             = nil,

      Button5                   = nil,
      Button5_Alt               = nil,
      Button5_Alt_Control       = nil,
      Button5_Alt_Control_Shift = nil,
      Button5_Alt_Shift         = nil,
      Button5_Control           = nil,
      Button5_Control_Shift     = nil,
      Button5_Shift             = nil,

      -- class specific bindings
      -- these take precedence over the defaults above

      [_cpc.CLASS_DRUID] = {
      },

      [_cpc.CLASS_HUNTER] = {
      },

      [_cpc.CLASS_MAGE] = {
      },

      [_cpc.CLASS_PALADIN] = {
      },

      [_cpc.CLASS_PRIEST] = {
         RightButton                   = 'Power Word: Shield',
         RightButton_Shift             = 'Power Word: Fortitude',
         RightButton_Control_Shift     = 'TargetUnit',
      },

      [_cpc.CLASS_ROGUE] = {
      },

      [_cpc.CLASS_SHAMAN] = {
      },

      [_cpc.CLASS_WARLOCK] = {
      },

      [_cpc.CLASS_WARRIOR] = {
      },

   },


   -- specify whether debuffs should be shown or not
   --   true: debuff icons are visible
   --  false: debuff icons are not visible
   show_debuffs = true,

   -- specify whether buffs should be shown or not
   --   true: buff icons are visible
   --  false: buff icons are not visible
   show_buffs = true,

   -- specify whether buffs should be filtered to only those that you can cast
   filter_buffs = true,

   -- specify whether debuffs should be filtered to only those that you can cure
   filter_debuffs = true,

   -- specify whether tooltips should be shown when mousing over players in your party
   show_party_tooltips = false,

   -- specify whether tooltips should be shown when mousing over buffs and debuffs
   show_aura_tooltips = false,

   -- specify growth/coloring behavior of health/mana bars
   --   true: bars grow as health/mana pools shrink (CastParty style)
   --  false: bars shrink as health/mana pools shrink (default WoW client style)
   grow_with_depletion = true,

   -- specifies the rgb values for the name and health text
   text_rgb = { r = 1, g = 1, b = 1 },

   -- specifies the sole rgb values for the mana bar, if nil, then use the fade from blue to red
   --mana_rgb = { r = 0, g = 0, b = 1 },
   mana_rgb = nil,

   -- specifies the sole rgb values for the health bar, if nil, then use the fade from green to red
   --health_rgb = { r = 0, g = 1, b = 0 },
   health_rgb = nil,

   -- specifies the sole rgb values for the mana bar background
   mana_bg_rgb   = { r = 0, g = 0, b = 0.3, a = 0.5 },

   -- specifies the sole rgb values for the health bar background
   health_bg_rgb = { r = 0, g = 0.3, b = 0, a = 0.5 },

   -- specify the height of your health bar
   health_bar_height = 12,

   -- specify the height of your mana bar
   mana_bar_height = 6,

   -- specify the width of your health and mana bars
   bar_width = 140,

   -- specify whether statusbar frame is visible
   show_statusbar_frames = false,

   -- specify manner in which auras are displayed
   --  right: the buffs and debuffs appear right of the party bars
   --   left: the buffs and debuffs appear left of the party bars
   --  below: the buffs and debuffs appear to below the party bars
   aura_alignment = 'right',

   -- specify the template to say when casting spells (nil indicates no message)
   -- %s - spell name
   -- %t - target name
   -- %d - duration of cast in seconds
   -- %r - spell rank
   message_text = 'Casting %s(%r) on %t in %d seconds',
   --message_text = nil,

   -- specify whether we should message about healing spells
   message_heals = true,

   -- specify the health percentage at which and below we should issue healing messages
   message_health_percent = 0.5,

   -- specify whether we should message about non-healing spells
   message_non_heals = false,

   -- specify whether messages should only be displayed for you
   message_player_only = false,

   -- specify the format of the text on your party member bars
   --   %n - unit name
   --   %m - max health
   --   %h - current health
   --   %d - health deficit
   --   %p - health percent
   --   %l - level
   --   %c - class
   unit_text_template = '%n: %d',

   -- specify whether default party frame should be hidden
   hide_party_frame = false,

   -- THE FOLLOWING ARE HEALOMATIC SPECIFIC

   -- specify the behavior of the Healomatic hot keys (e.g, 'Efficient Only')
   --   parallel: the hot key must be held while the healing is triggered
   --     serial: the hot key is pressed and released, modifying the next heal
   hot_key_style = 'serial',

   -- specifies whether CastParty should hides itself when you play a non-healer
   hide_unless_healer = false,

   -- specifies the health percentage a given spell must satisfy to be
   -- chosen as the most appropriate heal. for example, a value of 0.90
   -- indicates that if a heal gets the player to 90% health no higher
   -- heal will be tested
   spell_choice_threshold = 0.90,

   -- NOTE: THIS FEATURE IS EXPERIMENTAL. TEST IT AT YOUR OWN RISK!!!
   -- if the heal spell being cast is not going to hit for at least this
   -- fraction of it's potential, it will cancel. so, if you set it
   -- to 0.6 (i.e., 60%) then a 100 point heal would cancel if the recipient
   -- only need 59 points of healing.
   --
   -- the test for cancellation is made during UNIT_HEALTH updates. this
   -- means that a cancellation may happen very early after an attempt to
   -- overheal. this might make this method bad for end-game raiders. your
   -- feedback is appreciated, as i'm not involved in that aspect of the game.
   heal_cancel_threshold = 0.7,

   -- specifies the health percentage at which the player will cast emergency
   -- heals in place of longer casting more efficient heals.
   emergency_health_percent = 0.35,

   -- true specifies that emergency spells will be favored when the player is
   -- on a monster's hate list and has recenty taken damage
   emergency_in_combat = true,

   -- number of seconds for which damage will be considered recent in the above.
   -- a value of 2 (and true for 'emergency_in_combat') means that the player must
   -- be in combat and taken damage in the last 2 seconds to automatically use
   -- emergency heals
   emergency_damage_window = 2,

   -- if the amount of healing that your group heal spell can do (assuming you have one)
   -- is this much more health/mana efficient than your best single target efficient heal
   -- the group heal will be favored. this affects the 'Do The Right Thing' key binding.
   auto_group_threshold = 1.2,

}

