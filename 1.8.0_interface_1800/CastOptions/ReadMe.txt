Slash Command(includes usage info): "/castoptions"
For help, type "/castoptions help"

--About--
 CastOptions allows you to take a great deal of control over the functioning of casting.
 Here is a list of what it has:
 -Key bindings to cast the spell at your self, or other party members.
 -Automatically lower the rank of spells that are too high for the target.
 -Cast spells at the unit whose frame the mouse is over.
 -Cancel casting of the wand when casting another spell.
 -Cancel auto shot when bandaging.
 -Prevent casting of mana boosting spells on units that have no use for mana.
 -Prevent casting at units that are bound if casting will free them.
 -Use Alt/Ctrl/Shift for self casting.
 -Cast spells at self when no good target is selected.
 -Cast spells at friendly units hostile target.
 -Automatic selection of target amongst group members based on health, mana, buff status, and debuff status.

 NOTE: CastOptions is a rewrite of AltSelfCast(the one previously found in Cosmos, not Telos current one), and is meant to replace it. ASC will be phased out.
 DO NOT USE CastOptions and AltSelfCast at the same time!

--GUI Information--
 This addon supports both Khaos and Cosmos, which will give you graphical configuration options, for every option this addon has.  You can obtain Cosmos and Khaos from http://www.cosmosui.org

--Installation Info--
 Simply extract CastOptions.zip to your Interface/Addons folder

--Dependencies--
 Required: Sea
 Optional: MCom, Sky, Cosmos, Khaos, myAddOns

 This mod comes with an embeded version of MCom, so you don't need to load MCom as a seperate addon to use it. But if you do, then the seperate addon MCom will take precidence over the embeded one.

--Author Info--
 By: Mugendai
 Contact: mugekun@gmail.com
 Special Thanks:
  Telo - Orgigional concept for Self Cast
  Sarf - For making the origional Addon
  Exi and Miravlix - For doing some rewriting and initial implimentation of Smart Ranks, resulting in prompting me to go ahead and do the rewrite.

  Some Other People - For the concept of smart ranks, and their implementations.  The info on the spell ranks, and some of the code related to them
 is based on someone elses work.  I do not know who, but whoever
 they are, they deserve credit for it.  If you wanna claim credit
 for this, then let me, Mugendai know.

  Wh1sper - For the concept of Smart Assist Casting, and for going through the trouble to workout the textures for allmsot all the hostile, and self cast spells.

--Change Log--
v1.9
-Fixed a bug with Khaos options where the CastOptions enabled option was dependent on itself.  How the hell did I make that mistake?  And why didn't I ever notice it before?
v1.89:
-For several versions now, smart group casting was supposed to be considering the targeted member before others.  It wans't, but it is now.
v1.88:
-Updated to MCom 1.49
-Improved Aimed casting, will no longer aimed cast completly improper targets(even if you wanted it to try)
-Smart Assist will now work for Attack, and Pet Attack
-Added Insect Swarm to hostile cast list
-Added Heavy Weightstone, Heave Sharpening Stone, and Solid Weightstone to the smart equipment casting list
-Added ability to self cast spells by right clicking them in the action bar
v1.87:
-Updated to MCom 1.48
-Updated for 1.8 patch
v1.86:
-Will now Smart Assist with wands
v1.85:
-Fixed smart rank healing Heal Rank 4
-Updated to MCom 1.46
-Added support for the newer version of myAddOns: 2.2
v1.84:
-Fixed an error when a mage tried to cast some spells with Rank Healing enabled
-Fixed up mana control, should no longer cast on targets that don't use mana when doing group casting, and should use group/self casting if the target is a non mana using target
-Fixed an error that can occur if for some reason a talent that should be there, isn't
-Buffing heals will now properly act as buffs for group casting when all party members have full life/mana
v1.83:
-Fixed Smart Rank Healing of Shamans Healing Wave
-Fixed error in unit health boost calculation for smart rank healing
-Fixed Smart Rank Healing for Smart Self Casting
v1.82:
-Updated to MCom 1.44
-Changed default for Alt Self Cast to disabled
v1.81:
-Updated to MCom 1.41
-Added Khaos option dependencies
v1.8:
-Updated for 1.7 patch
-Changed to the new variable storage system, so that variables are now saved in the per addon directory
-Moved all option registration out of the main lua file, and into a seperate file
-Fixed a bug with group mana casting
-Made sure that casting spells by name from macros will work even with trailing semicolons
-Added ability to automatically select your equipped equipment when using equipment buffs
-Fixed a bug that caused spell matching range specifier checks to fail
-Fixed problem where disenchant was mistaken for druid remove curse
-Moved all spell data to a seperate file
-Added ability to print the itemlink of a weapon buff by right clicking it in your inventory, you can use this to let me know of more itemlinks to be used with the new smart equipment buffing, this is only accessable as a slash command
-Added Smart Rank Healing, this will make it so that when you cast a healing spell it will cast the lowest rank healing spell needed to heal your target for the amount of life it needs
-Added Group Blessing Casting, blessing will only be cast in groups if this is enabled, and they will only be cast at targets in your group/raid that you have previously cast that blessing on.  This does not count for Blessing of Freedom, which is cast like normal
-Group casting was not working on most raid members, this has been fixed, this fixes the infamous "Can't Shield raid members bug"
-Moved all tooltip getting code to more effecient code
v1.77:
-Updated to MCom 1.35
-When choosing a target to party cast at, should now have less of a chance of picking an ineligible target
-Will no longer process Macros like spells/items
v1.76:
-Updated to MCom 1.34
-Updated to use MCom.safeLoad to prevent nil options for overwriting defaults on variable loading
v1.75:
-Fixed CastSpellByName causing a stack overflow(forgot to rename the internal CO version)
v1.74:
-Updated to MCom 1.33
-Changed Khaos option difficulties
v1.73:
-Updated hooks to use . format
v1.72:
-Fixed a bug that caused smart casting of group only spells to not self cast when a friendly, non-group, character was selected.
-Fixed an error with wand canceling
v1.71:
-Added ability to cast spells at the unit on the screen(friendly or hostile) the mouse is over.
-Added ability to aimed cast when ctrl/alt/shift is pressed
-Fixed a couple places where a rank cast could occur regardless of the option setting
v1.7:
-Updated for 1.6 patch
-Changed show wand canceled to show shot canceled, now handles both wand and auto shot canceled
-New self cast specifier, "f" means it is a first aid skill that channels
-Added option to stop auto shot when using a bandage, as I have been told that the autoshot will interrup the bandaging.  Unfortunately due to a bug in the client as of 1.6, this will only work if Auto Shot is in an action bar.  If Blizzard fixes this bug, it will be fixed in code without any changes.
-The No Return options, are now Target Chosen unit options, same notion, but more understandable
-Better event watching code
-Self/hostile cast data for container and race are now properly returned from the Get functions
-Group casting will no longer occur if a friendly unit that you can attack is targeted(AkA a duel target)
-Fixed time based re-buff targeting
-Changed methodology of group casting.  The old method was to pick a potential target, target it, then if the spell was in the action bar, check range to the target, and if it wasn't in range, repeat till one was found in range, and then cast the spell at the target, and then return to the normal target.
  The new method will cast the spell ahead of time, and only change the target if a friendly was selected(to no target, so we can have the targeting cursor), then to pick a target, taking range into consideration, and then cast at the chosen target, and then return to the old target only if neccisary, and only switch to the chosen unit, if the option is enabled.
  The upshot of all this is, you can heal your friends or self while attacking a hostile without the attack stopping, or the target changing.
-Some code tidy
-Added keybinding for casting at party members
-When using a keybinding to cast at a target such as self/party, the spell will be cast at that target, regardless of whether or not the spell can target that unit.
-Added option to cast the spell at the unit whose frame the mouse is over, like Player Frame, Pet Frame, Party1 Frame, etc..
v1.62:
-Updated to MCom 1.3
This improves the display of the help screen, and shows current status of all options in it as well
-Updated to use MCom's new textname, to help a bit with localization ease
v1.61:
-Will now smart self cast spells that are group only, if a non-group friendly is cast
-improved some group buffing logic
-Fixed group curing of poisons(turns out I don't know how to spell poison, well I guess I do now)
v1.6:
-Mana Control, prevention of casting mana boosting spells, on those who dun got no mana bar
-Group Mana Casting, cast mana boosting spells at members with low mana
-Group casting now considers the selected target first
-Fixed a bug that broke group self casting
v1.57:
-Fixed a bug that caused the "No good target" message to occur on every groupable cast.
-Fixed some logics
-Group buff casting now keeps up with then you last cast what on whom, so buffs will now be recast on those who have buffs, if everyone has the buff, but will be cast on the person you buffed the longest ago(and therefore oldest buff)
v1.56:
-Updated to MCom 1.28
-Removed use of locale to identify Gouge
-Added ability to identify bound spells by whether or not they have a digit in their tooltip
-Gouge is now identified seperate of Rend, by the fact that it had no digit in its tooltip
v1.54:
-Set Gouge identifier to "Stun", hope this is right
-Made sure that rank casting only occurs when the player is not the target, and when the target is friendly
-Made sure that bound casting prevention only occurs with hostile spells
v1.53:
-Updated to MCom 1.27
-Self cast table has a new specifier, r, if it is true then the spell must have a range indicator to match
-Added a debug option to print the texture of the spell that was just cast, "texture" or "tex"
-Will now self cast dispel if the player has no target
-SpellCanTarget changed to SpellHasRange
-No longer check that all spells have a range indicator for self/group casting, will now only do so when neccisary(fixes "Lay on Hands")
v1.52:
-Fixed basic smart cast logic issue, should now properly cast at friendly targets
v1.51:
-Added missing self cast spells, Fear Ward, and Prayer of Fortitude
-Fixed Lesser Heal, and Heal, which didn't self cast at all ranks(multiple textures withing the same skill oi)
v1.5:
-Added Heavy Mageweave, Runecloth, and Heavy Runecloth bandages. Thanx to Ironheart
-Added ability to have CO automatically stop canceling a spell, if a group cast was attempted, and no good target was found. Also an error message will display to let you know.
-So long as you do not have dispel disabled, CO will now only smart cast it, if you have a Magic debuff on you, otherwise, it will throw it at your target.
-Fixed logic for preventing CO from messing with other mods. Should now work proper for all mods.(Including DivineBlessing)
-If group casting, and the player is picked as the target, CO will no longer check range
-CastOptions will now REFUSE to load if AltSelfCast is enabled
-Renamed the slash command noreturn to "noassistreturn", and added an alies of "nar".
v1.4:
-Updated to MCom 1.26
-Added Innervate to the self cast table
-Added ability to specify binding debuffs by name, for when the texture is ambiguous
-Should no longer think a player is gouged, when they are actually rended
-Fixed detection of usage of group mode, this was fairly borked
-Simplified some function calls
-Fixed group self option
-Will no longer usurp spellbook or byname casting unless called from a macro or the spellbook, meaning it should no longer break mods like CastParty, and CT_RaidAssist
-For a spell to be self cast, it must now have a range indicator in the tooltip. Should fix issues where some spells/items that are not self-castable share the same texture as a self cast spell. This fixes First Aid on Paladins
v1.3:
-Update to MCom 1.25
-Added support for myAddOns
-Added option to cancel casting of the wand when you try to cast another spell(thanx to AlexanderYoshi for this suggestion)
-Added option to not cast at units that are bound by effects like sleep, polymorph, and fear, if the spell would free the target from the effect(thanx to Gryphon for this suggestion)
v1.23:
-Update to MCom 1.24
-Fixed a bug where casting bad spell names by name, would cause an error.
v1.22:
-Forgot to update Dispel Magic self cast stuff. Caused an error, fixed now.
v1.21:
-Updated to MCom 1.23
v1.2:
-Changed spell recognition to use textures instead of name. This means for the most part Cast Options doesn't need any localization to function properly. The only thing it needs is for the Group Curing to work right, the words Poisen, Curse, Disease, and Magic
-Added Smart Assist Casting, thanx to Wh1sper for this idea. It lets you cast spells at your friendly targets hostile target.
-Added Smart Group Casting, lets CO pick a group member to cast healing, cure, and buff spells on, based on their status.
-CO will now take over casting from scripts, containers, and the spellbook
-First Aid items are now considered selfcastable, other items can be added
v1.1:
-Can now store/load it's variables on a per realm, per character basis.
-Updated to MCom 1.1 