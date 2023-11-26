NAME

   CastParty - by danboo

WEBSITE

   http://wow.boorstein.net/

VERSION

   1.11 - 03/22/2005

INTRODUCTION

   CastParty is a minimalistic party frame that allows binding of spells,
   action and game functions to mouse clicks on party members.

   Examples bindings (configurable):

      - right click to assist
      - left click to heal
      - shift + right click to follow
      - middle button to buff Power Word: Fortitude

   In addition there are custom functions available for these bindings to
   assist Healers. They include:

      - pick a heal rank based on damage on party member
      - pick a heal type based on the situation (e.g., near death, being
        attacked, moving)
      - cure any ailment on the player (assuming you have the spell)

   And last but not least it provides key bindings (under the 'Healomatic'
   heading):

      - apply appropriate heal to player nearest to death
      - force efficient/emergency/instant/group healing on next heal
      - cure any ailing party member

CAVEATS

   Currently, the configuration of this mod requires editing a Lua file.
   This requires very little knowledge of Lua, but may be challenging for
   some. Eventually I will add a configuration interface, but for now, as
   this add-on develops fast and furious, it is easier for me to hold off
   on writing the configuration code.

CONFIGURATION - !!! PLEASE READ THIS !!!

   CastParty is *highly* configurable. In fact, if you do not go through the
   configuration file, it likely won't behave as you expect it to. 

   To do this, open the 'CastPartyPlayerConfig.lua' file in notepad.exe (or
   vim if you go that way) to see what you can configure.

   Each option has a caption explaining it's effect. If you are not familiar
   with Lua, please note that the '--' you see all that file represent
   comments. Everything on the line after them is ignored.

   The default configuration is mine (Shaman), so non-healers will definitely
   want to change it.

USAGE

   The two main features of CastParty are the compact party/player frame,
   and the ability to program how mouse clicks behave when clicking on a party
   member.

   The configuration file goes into detail, and shows examples, but briefly
   you can do the following:

      LeftButton = 'TargetUnit',

   The above simply targets the clicked unit. This works for any WoW built-in
   function that takes a unit as its only argument. Additionally I've coded
   some CastParty built-ins for your usage:

      LeftButton_Alt = 'CastParty_ApplyHeal',

   This performs the heal selection from the old Healomatic codebase, when
   you hold the Alt key in combination with a left click on the party
   member's bar. See the configuration file for a full list of CastParty
   built-ins.

   If you want a specific click/meta-button combination to cast a specific
   spell, you can simply use something like:

      LeftButton_Alt_Shift = 'Healing Wave(Rank 3)',

   If you want a specific click/meta-button combination to cast the highest
   rank of a certain spell family, you can simply use something like:

      MiddleButton = 'Healing Wave',

   And finally, if you're Lua-fluent, you can assign anonymous functions to
   a click/meta-button combination:

      Button4 = function(unit) AssistUnit(unit) CastParty_ApplyHeal(unit) end,

SETUP

   Prior to upgrading or reinstalling, it is a good idea to save your old
   'CastPartyPlayerConfig.lua' file for reference. The format hasn't changed
   but there are some new options.

   After installing (see link near the top), when you next load your UI,
   you will see a small frame, with your name on it, in the middle of your
   screen. You can drag this to whatever position you desire, by clicking
   and dragging on the thin grey borders.

   Within the grey borders are 2 status bars, one for health and one
   for mana. Assuming you are at full health and mana, you will not see
   them. You know you're at full health. Why do you need a large green
   bar to be remind you of that? Wouldn't you rather be reminded of the
   fact that you're almost dead? I thought so. Me too. =)

   Instead as you take damage and spend mana, the bars will grow from
   left to right. The health bar will change in color from green to red
   and the mana bar from blue to red. The health bar is always on top of
   the mana bar and is twice the thickness, so you won't have any problem
   distinguishing the two.

   Additional party members will be added below the player's status bars.
   They behave just as your status bars do.

CHANGES

   CastParty 1.10 - 1.11:
      
      - updated toc version to 1300
      - replaced GetCurrentPosition() with GetPlayerMapPosition('player')
      - added CastParty_CastSpell() function
      - use a more robust means of getting mana from tooltips (works in any localization)
      - added templating system for unit bar text:

            %n - unit name
            %m - max health
            %h - current health
            %d - health deficit
            %p - health percent
            %l - level
            %c - class

   CastParty 1.9 - 1.10:

      - added always-full background status bars
      - added configuration settings for color and transparency of background status bars
      - added configuration option to turn off framed borders around each player
      - added french translation
      - added functionality to 'Do The Right Thing' binding to choose group heals when advantageous
      - added configuration option to set efficiency setting for auto group healing
      - added 'Rank' to the localization file
      - added 'Weakened Soul' to the localization file
      - auto-target cure targets if another friendly unit is targeted

      Briefly, the auto-group healing decision is made by comparing your most efficient single
      target heal spell with current potential efficiency of your group heal spell. If your group
      heal is more efficient by a certain multiple (1.2x  by default), then the group heal is
      chosen. This feature is most useful for Priests.

   CastParty 1.8 - 1.9:

      - TOC updated to 4216
      - added key binding to cure any party member of any debuff you can cure
      - localized class and buff names
      - added German localization (thanks Miep!)
      - re-added Abolish Poison after removing it during copy and pasting localizations in 1.8
      - fixed a bug in loading spell data that led to improper aura iltering in non-healers

   CastParty 1.7 - 1.8:

      - updated README.txt to stress the importance of configuring CastParty
      - updated README.txt with CHANGES history
      - updated the TOC to be a little more informative
      - added the start of a localization file (translations would be appreciated)
      - added beginnings of buff selection based on recipient level (thanks Thirsterhal)
      - consolidated spellbook tooltip parsing
      - fixed bug causing nil errors when updating party health text
      - added 'deficit' format to health text display option
      - copy event based globals ASAP to avoid the invocation values being lost
      - added experimental/rudimentary heal spell auto-cancellation when they become inefficient (feedback please)
      - fixed bug with triggering chat on non-CastParty spells

   CastParty 1.6 - 1.7:

      - correctly call UnitIsEnemy() when determining behavior during Dispel Magic casting
      - update party auras when party members change
      - (tried to) fix bug regarding nil warnings when players without any cures are affected by debuffs
      - correctly display Shaman Totems as buffs
      - updated toc to 4211

   CastParty 1.5 - 1.6:

      - removed the duplicate 'Rank' from the message template
      - fix bug that lead to messages about non-CastParty related spell casting
      - added 'Abolish Poison' to cure list
      - reworked cure detection yet again to ensure it always uses your best available cure for a given ailment type

   CastParty 1.4 - 1.5:

      - fixed frameStrata issues causing CastParty frame to always be on top
      - added configuration variable to set health/mana bars to a constant RGB value
      - added %r variable (for spell rank) to message template
      - added configuration boolean to display messages only for the player
      - simplified curable determination
      - added missing cures: Abolish Disease, Remove Curse, Remove Lesser Curse
      - fixed a bug that caused a target with full health to be healed as though they had the health of the lowest party member
      - fixed a bug that caused attempted heals of dead party members (I think, I never got the details, so I guessed)
      - when curing with Dispel magic, handle the case where your target is not the intended recipient
      - fixed bug in forcing instant and group heals, they now always cast the best available by mana
      - handle implicitly-magic debuffs in setting filters and cures

   CastParty 1.1 - 1.4:

      - added private tooltip for parsing hacks
      - added class-specific mouse bindings
      - added CastParty_CureAny(unit) function for clickable smart-curing
      - configurable buff display filtering based on those that you can cast
      - configurable debuff display filtering based on those that you can cure
      - configurable display of buff/debuff/player tooltips
      - configurable alignment of auras (right, left or below)
      - spell notification only happens for non-instant spells now
      - spell notification message contains duration until spell lands
      - configurable spell notification on healing spells
      - configurable spell notification on non-healing spells
      - configurable spell notification on healing spells based on target percent health
      - fixed bug with notification when not in a party
      - only send spell notification on actually starting a cast
      - configurable hiding of default party frame
      - updated max hit points for extra-party member targets
      - druid Regrowth no longer considers the regen portion when deciding which spell to cast
      - color of health/mana status bars is now bright over the full range
      - removed unregistering of PLAYER_ENTERING_WORLD event due to bug in WoW code

   Healomatic 1.17 - CastParty 1.1:

      - mouse clicks in combination with meta keys are fully programmable (read much more useful than just healing)
      - figure out the cast message channel based on whether target is in the party or not
      - always cast the best possible HoT
      - removed restriction on Paladin emergency heals
      - specify the health text format as a percentage or current / max
      - status bars can be configured to shrink as health and mana are depleted
      - buffs and debuffs are visible to the right of each player bar
      - default bar height is 50% larger
      - player tooltips when hovering over party members status bars
      - display pvp/leader/loot icons to the left of each player bar
      - assign player/party popup menus to mouse clicks
      - specify color of text for player names/health

THANKS

   To all those mod writers that have shared their knowledge. And to
   Blizzard for making an utterly competent UI (come on guys, just teasing)
   with great extensibility. And to JB and Sam for taking lots of damage.


$Id: README.txt,v 1.10 2005-03-22 17:08:14-05 danboo Exp danboo $

