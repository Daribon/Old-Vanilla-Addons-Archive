----------------------------
=====---- TipBuddy ----=====
=====----- V 1.81 -----=====
====---- by Chester ----====
----------------------------
---chester.dent@gmail.com---


--- SLASH COMMANDS

/tipbuddy
/tbuddy
/tip
- toggles the options window

/tipbuddy rankname
- toggles whether full rank name is displayed before names

/tipbuddy resetanchor
- resets the TipBuddyAnchor position to its default (use this if it goes offscreen)

/tipbuddy blizdefault
- any tooltip that you have set to use the default mode will now be displayed with the Blizzard Default style tooltips (all TB anchoring still works though)

/tipbuddy extras {type}
**UNSUPPORTED** (but still works)
-This is used to set whether you would like to see 'extras' in the compact mode tooltip (extras include anything after the 'level' line not including PvP and stuff like that and anything other mods add to the tooltip)
-Valid arguments for {type}:
on  -- (turns all on)
off -- (turns all off)
pc_friend
pc_enemy
pc_party
pet_friend
pet_enemy
npc_friend
npc_enemy
npc_neutral


--- MENU
- To access the menu: 
- Use the slash command above OR
- Hit ESC to bring up the default WoW options menu
- Click the TipBuddy button attached to the right of the default menu

Thanks to:
Medici of Eredar (German Translations)
Frosty (for fixing a bug, when I was in dial-up Hell)
Skeeve (additional fixes)


--- CHANGELIST
10/2/05 - v1.82
-fixed bug with default tooltip scaling starting off incorrect if you either downloaded for the first time or upgraded from a version pre-1700
-reorganized initialization of variables and some general code 
-fixed an error with a saved variable which could cause an error and reset your saved settings
---if you get an error after updating to this version, you will need to either reset your settings using the options menu or delete your saved variables file.  I apologize for this inconvinience.
-new code for new features are also included in this version, but are not exposed.  I wanted to get this version out to fix up all those folks getting the savedvariables error.  Look for some cool new functionality and all new customization features next version!

9/20/05 - v1.81
-fixed error with corpses if you didn't have a mobhealth addon
-fixed health/mana text showing on corpses

9/20/05 - v1.8
NEW FEATURES
+ added scaling functionality for your default tooltips.  You can now scale it up or down regardless of your UI Scale.  This affects all of your default tooltips so it's great for users with sight problems.
+ added display of your selected unit's target.  Your target's target will be displayed next to their name and will be color coded based on the type of unit they have selected:
red    = enemy
blue   = non-hostile npc
green  = friendly player
purple = party member
white  = YOU!
(these can all be enabled or disabled per unit type via the options menu)
+ added the ability to display the difficulty color as your tooltip background.  You now have a choice whether you want the tooltip background colors to be custom per unit type or to always display as the difficulty color 
(red=impossible, green=easy, grey=trivial, etc)
+ added support for the mobhealth database
+ added the option to turn on the health and mana txt which gets overlayed on top of the health and mana bars
(by default it will display the percentage [90%] unless you have one of the mobhealth mods installed and have data on that unit.  It will then display in mobhealth fashion as: 1393/1548
(both of these can all be enabled or disabled individually per unit type via the options menu)
+ added the ability to toggle showing text instead of the faction symbol.  This will display "PvP" or "FFA" in big bold letters instead of displaying the faction symbol.
(this can be enabled or disabled per unit type via the options menu)
+ increased the range in which you can offset your tooltips from your cursor

FIXES/CHANGES
- lots of small fixes, code reorganization and some minor cleanup.
- reorganized options menu slightly and put the "Compact Only" options in its own section.  If you are looking for it, click on the COMPACT ONLY header.
- a bunch of the new options mentioned above are now selectable from a new 'pop-up' window that pops up when you mouse over the little note to the left of the related checkbox.
- TipBuddy will now properly display text in both the left and right tooltip lines.


9/15/05 - v1.791
-additional fixes by Skeeve (not chester...Thanks Skeeve!)

9/15/05 - v1.79
-fixed 2112 error in new patch (by Frosty)
-updated toc

7/16/05 - v1.78
-fixed line 1456 error finding nil 'gtt_name'

7/13/05 - v1.77
-updated version number

7/7/05 - v1.76
-fixed lines being added every frame on unit frames with default unitframe setup
-fixed tooltips for buttons not showing right away if you quickly moused over a unit then a button
-fixed known nil 'find' errors
-fixed getting extra default info if you moused over a unit and then another with the exact same name

7/6/05 - v1.75
-fixed nil error people would see occasionally when leaving a unit
-fixed hunter's Beast Lore info not all showing properly in the tooltip
-^^ this also fixes a few issues with all info not showing in tips sometimes
-cleaned out a bunch of cruddy old code

6/22/05 - v1.74
-think I fixed a nil error people were getting with last version (please keep your eyes out)
-added cursor tooltip offsets
IMPORTANT:  If you had your tooltip attached to the cursor and did not have it attached to the top, you will have to go into the options and set an offset that works for you (it default to 0,0 on startup of this version)
-added two new sliders to the options menu which control X and Y offsets for the cursor attachment
-reorganized the options menu a bit
-re-enabled compact mode tips to show 'extra' information in them
IMPORTANT: I am not currentlty supporting this 100% which is why I made the options for this command line only (you won't find options in the options menu for it).  I just wanted to get it back in so people could use it and play with it before I could devote large amounts of time to make it work well.

The command is:
"/tipbuddy extras {type}"
-Valid arguments for {type}:
on  -- (turns all on)
off -- (turns all off)
pc_friend
pc_enemy
pc_party
pet_friend
pet_enemy
npc_friend
npc_enemy
npc_neutral

Please type in the 'type' argument exactly how you see it above.

6/21/05 - v1.73
-fixed line doubling if you had any other mod installed which modified the tooltip's name
-fixed fade not working if you had another mod installed that did the same

6/18/05 - v1.72
-fixed error that showed up sometimes relating to tipbuddy compact mode fading out
-fixed chat debugging causing all chat channels to move up a number

6/16/05 - v1.71
-non-unit worlds tips (mailboxes, anvils, etc) will now follow the same anchoring rules that you set for unit tips
-non-unit world tips also will now fade or hide depending on how you have it set for the 'default' tips
-fixed a concatenate error some people were seeing

6/14/05 - v1.7
-compact mode text if no longer set to different alphas, all alphas are now at the highest (makes for crisper text)
-fixed some incorrect translations for germans (pets should now display properly)
-Unit tooltip position is now seperated from non-unit position
--this means you can set your tip to be anchored with units, but still have it follow the cursor on buttons if you like
-fixed an error that would clear out tooltip lines causing some info to not show
--this should also fix another case of double lines
-added new console command 'blizdefault'
--by typing "/tip blizdefault" any tooltip that you have set to use the default mode will now be displayed with the Blizzard Default style tooltips (all TB anchoring still works though)

6/10/05 - v1.691
-fixed error you would get on startup when users were using the anchored mode
-also fixes 'color' errors you would get related to the same problem

6/10/05 - v1.69
-fixed default tooltip not showing for the first time if your first mouseover was a unit
-fixed tooltip floating for buttons if they were attached to cursor and you hadnt moused over a unit yet
-fixed error on new partypet frames
-fixed location showing twice sometimes for party member frames
-fixed errors relating to not finding gtt_guild and gtt_class

6/09/05 - v1.682
-French localisation is now complete thanks to Feu and Gaysha
--should fix text doubling up errors for french users
-new toc version number
--(reverted from v1.69 due to overflow error)

6/07/05 - v1.68
-removed some accidental debug info

6/07/05 - v1.67
-fixed super long tooltips when mousing over target and player frames
-tooltip clipping is now pixel perfect and should work on all machines (some user were seeing weird offsets, tooltip floating relative to your cursor and the clipping on the right side of the screen not working, this should all be fixed now)
-added new option (as well as new dropdown menu) that lets you anchor your nonunit tooltips in a 'smart' way (tooltips will try to anchor to the object you have your mouse over in a smart position relative to that object)

6/05/05 - v1.66
-fixed Skinnable and Resurectable text not showing for corpses
-fixed an error that would sometimes show during combat (Line: 1180)

6/04/05 - v1.65
-fixed another case of class text showing twice as well as increasing in lines

6/04/05 - v1.64
-fixed class text doubling up for friendly players

6/04/05 - v1.63
-fixed titles not showing up for NPC's

6/03/05 - v1.62
-fixed TipBuddy clearing other mod's info that was put in the tooltip
--this makes MobInfo, MonkeyQuest and other mods qhich unitlize the tooltip compatible with TipBuddy again
-added two new anchor positions to the TipBuddyAnchor (Top Center and Bottom Center)
-added the option to have non-unit tooltips (UberTips) anchored to the TipBuddyAnchor instead of the cursor always (click the "Anchor Non-Unit Tips" box in the options)
-think I also fixed an error with class info (attempt to concatonate field gtt_class(a nil value))

6/02/05 - v1.61
-fixed default tooltip's size getting huge when opening your bags if you had bags that did not take up a second column (this also fixes the crashes some would see in the same case)
-fixed party members location not showing in some cases when you moused over their unit frame
-fixed guildmate text color not working
-fixed 'tapped by player' and 'tapped by other' text color not working properly

5/31/05 - v1.6
-the case of the disappearing tooltip has been solved
-fixed compact tooltip disappearing at inopportune times
-added ability to toggle rank icons for players in options menu
-added ability to toggle ranks names in the options menu
-by popular demand, added a new neutral tab for npc's which are neutral to you
--this enables you to set background colors as well as pick what text you want displayed for neutral NPCs
-fixed TipBuddy's background color of tooltip carrying over to an item tooltip in certain cases
-fixed icons sometimes going away if you recieved an event (such as mana) when yout mouse was over that unit (this is fixed for the player as well)
-fixed party frame tooltips showing the wrong unit type
-fixed party member frame tooltip's location not showing if guild was turned on
-fixed the first line of additional tooltip text sometimes getting removed
-fixed level text overlapping title text for some pets in certain cases
-fixed selected guildmate text color not working properly
-fixed a case where guild text would get inserted (and doubled up) when there was none
-Thanks so much to everyone who offered to test this version!

5/27/05 - v1.59b
-fixed compact mode disappearing at random times
-fixed error when mousing over party frame when they were at a distance and you had ranknames on
-fixed buffs, ranks, and faction icon not showing at times
-fixed the above not going away sometimes
-buffs, rankicon, and faction icon now fade properly with the frame they are attached to
-fixed gametooltip frames sometimes showing then disappearing if you moused over then when the previous visible frame was the compact version
-fixed "Skinnable" text not properly showing its difficulty color
-cleaned up quite a bit of code
-added an "Apply" button to the options menu as well as improved button placement
-Options menu now has a "Reset" button that when pressed, prompts you if you really want to reset
-dead player corpses should now should guild if they have one

5/23/05 - v1.58b
-fixed 'elapsed' error you would get when entering inns, etc.

5/23/05 - v1.57b
-fixed background color buttons not being clickable
-fixed same faction level color not working
-fixed level 'con' color for standard and trivial showing the wrong colors
-fixed color picker frame not keeping focus if you clicked off it
-fixed being able to click the frames under the color picker frame
-fixed an error when mousing over party member frames in certain situations
-fixed TipBuddyAnchor starting off the screen under certain circumstances
--"/tipbuddy resetanchor" still works if you get the anchor in a bad spot
-hunter's pet info should now work properly with TipBuddy
-fixed tooltip going crazy/crashing when it was up and you would talk to a vendor or open a bag
-fixed german 'civilian' translation showing incorrectly

5/17/05 - v1.56b
-fixed variables saving poorly which cause a billion errors on startup
(fixes all known errors on mouseover)
-fixed TipBuddyAnchor showing in a bad position when it was first shown
-fixed case where TipBuddyAnchor was never shown at all
(fixed tooltips not drawing or positoned strangely when anchored to the anchor.  If you cannot get your anchor to show, type this: /tipbuddy resetanchor)
-added /'resetanchor' command to reset your anchor position if you get it in a bad spot
-fixed icons getting stuck to frame when it dissapeared
(they don't fade out yet with the frame yet.  I have a solution for this, will be next version)
-fixed tooltip background color from units persisting to your next item tooltip
-fixed German translation of Civilian (I think. Medici, can you test this for me?) 


5/17/05 - v1.55b
-update city tonight!
-fixed color boxes not being selectable
-menu window now closes when TipBuddy options window closes (sorry myAddons author)
-corpses should now display with the default tooltip no matter what now
-TipBuddy menu icon now never goes away

5/17/05 - v1.54b
-quick fix to show mana properly again (fixes ManaTextColor error)
-added the option to set the Default mode tooltip to use the Bliz fade (off by default)
-Bonus Feature: TipBuddy now supports myAddons!  Huzzah!

5/16/05 - v1.53b
--CHANGES/ADDITIONS
-TipBuddy's new default mode now uses the tried and true GameTooltip (with most of the TipBuddy features!)
-all mods that add info to the tooltip are now consistently compatible with the default mode (MobInfo, etc)
-mousing over unit frames (targetframe, party frames) will now show TipBuddy
-you can now choose the text colors for all text TipBuddy shows
-added new menu window for choosing text colors
-TipBuddy is now localized for German users (thanks to Medici! now if anyone knows any French users...)
-Default mode for the tooltip now goes away when you are not on a unit (I will add an option to show the default 'fading' in the next version)
-tooltip border is now the default light grey
--FIXES
-color picker frame now overlays other menu frames
-closing color picker frame takes you back to previous menu now
-optimized TipBuddy pretty severely so it now uses MUCH less memory when running
-fixed civilian text not showing up
-fixed tooltip being blank on start if you used the anchor
-fixed pets showing up as friendly pcs (fixes pets showing their class type as 'Warrior')
-removed slash command /tb as to not conflict with TackleBox (replaced with /tbuddy)
-a few other small things not worth mentioning

5/09/05 - v1.51
-added option for color coded class text
-fixed city faction text showing in the wrong place sometimes
-fixed city faction text thinking there was some when there wasn't with AF_Tooltip installed
-fixed error 'Civilian' checking when AF_Tooltip was installed
-removed Rank Titles in player names by default
-->if you like them displayed you can reenable them by typing "/tb rankname"
-the con coloring system (for level and class text) will now display for friendly players who are flagged for PvP.  Unless you are using the class color coding, then it will only display for the level text
-did a bit of an slight overhaul on text colors and display to make them easier to read
-changed default settings to be more appealing
-optimized code a bit

-->On the Horizon:
-looking into making a "Light" version that uses the default GameTooltip

5/04/05 - v1.50
-TipBuddy no longer shows a skull when your target's level is out of range
(now shows ?? as it was much easier to display elites, rares and bosses this way.  Plus a lot of people seemed to prefer the ?? to the skull graphic)
-Elites are now indicated for friendlies as well as enemies (with a '+')
-Rares, RareElites and Bosses for both friendly and enemy mobs are now indicated (with bright white letters)
-fixed City Faction not showing up for NPCs
-adjusted horizontal sizing math to consider boss and rare text
-TipBuddyAnchor will now not show everytime you load the game when you are using it
-TipBuddyAnchor will now only show the first time you click the option to use it (keeps from having to close it every time you change your options)
-added a button so you can display TipBuddyAnchor at any time from the options menu
-changed tooltips to reflect above changes

5/02/05 - v1.49
-fixed line 655 error on units/pets
-fixed tipbuddy hogging the OnHide and OnEvent for GameTooltip
(auctioneer, lootlink, reagent info, etc should now all show properly)

4/29/05 - v1.48
-names now display rank titles (if available)
-rank icon now diplays to the left of the name
-"Civilian" now properly shows up
-fixed issue with play controlled pets producing an error
-fixed a few other nil errors

4/20/05 - v1.47
-added additional infro to "Race" tooltip checkbox
-internally setup a debugging message system
-fixed another error on pets/totems
-increased total buff/debuff icons displayed to 8
-disabled "Extras" option until a better solution is found
-fixed an error where some units dont properly return their faction
-fixed tooltips not properly clipping to the bottom of the screen
-adjusted disnaces a bit to where the tooltips clip to screen edges

4/20/05 - v1.46
-fixed another error on pets and totems
-added another check to playercontrolled units for title names (fixes MiniDiablo title not showing) ^_^

4/19/05 - v1.45
-added the option to show race for players
-options menu now reflects this with a new checkbox
-fixed manabar not updating when mousing over new units
-warriors with no rage now won't show an empty manabar


4/16/05 - v1.44
-fixed all settings resetting with each new version
-fixed background colors not saving
-default tooltip background color follows TipBuddy settings now if TipBuddy is turned off
-renamed 'Disable All' checkbox to 'Disable TipBuddy' to avoid some confusion that was happening
-moved color picker boxes

4/16/05 - v1.43
-fixed error on enemy NPCs when cityfac was on when there was none

4/15/05 - v1.42
-new check to fix errors on pets and some npcs
-friendly units classes now don't use con coloring system
-increased minimum frame size so the frame doesn't get too small on small named units
-fixed health and mana bars sometimes not sizing properly + improved positioning
-TipBuddyAnchor tooltip now attaches to itself using the current rules set
-TipBuddyAnchor tooltip now goes away when you bring up the dropdown

4/8/05 - v1.41
-GameTooltip now defaults to following the same anchor setup as TipBuddy
--(anchored to cursor or to TipBuddyAnchor)
-new initialization setup which puts you in synch with the latest variables
-all tooltip types can now be attached to cursor or tipbuddy with their position configured
-added dropdown to options to allow tooltip position in raltion to cursor
-TipBuddyAnchor now has drop down which lets you set tooltip position in relation ot it
-a few options went away
-TipBuddyAnchor now sparkles when it shows to keep track of it
-TipBuddyAnchor now fades out when your mouse isnt over it
-disabling TipBuddy for a certain target type will now show the default tooltip in its place

4/3/05 - v1.36
-fixed not creating table entry for new bgcolors and saved variables
(fixed bgcolor error if you had an older version and recently updated)

4/3/05 - v1.35
-added ability to set background color for all unit types
-added options to pick background colors that uses color picker
-rearranged options menu checkboxes to optimize space a bit
-added ability to select a unique background color for units which are in the same guild as 
you

4/2/05 - v1.34
-added option to turn off WoW's default tooltips for units (when TipBuddy is visible)
-tweaked color scheme for names

4/2/05 - v1.33
-fixed Corpse text showing up
-fixed tip updating on unit (if you moused over during a delay) even if you had that type disabled
-if a creature has no class or family and is defined as "Not specified" for CreatureType, I now report it as "Creature"
-fixed typo in readme.txt

4/1/05 - v1.32
-Added TipBuddyAnchor
-added options to use TipBuddyAnchor
--enables you to anchor TipBuddy to the anchor and position it anywhere on screen
-TipBuddy now has a delay for going away
-added option to set the delay time (0-4 seconds) 
-TipBuddy now fades out after the delay
-added option to set the fade time (0-4 seconds)
-enabled you to bring up chat when options window is open
-enabled you to take a screenshot with options window open
-added a readme.txt
-added slash commands to bring up the options menu: 
--/tipbuddy or /tip

4/1/05 - v1.31
-Fixed font size scaling badly
-Increased font size scale range (can now get smaller and much bigger)
--Default scale increased a tad