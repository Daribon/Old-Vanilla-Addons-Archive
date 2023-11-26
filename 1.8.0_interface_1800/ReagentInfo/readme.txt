Reagent Info - Version 1.5.1
Author: Jerigord (GDI)

Dependencies: ReagentData (2.2.0 or higher)
Optional Dependencies: myAddOns

Description: Reagent Info modifies the World of Warcraft tooltip to display what
professions use the mousedover item as well as what skills acquire it or if any
classes use it as a spell reagent.  It allows users to disable any of the three
pieces of mouseover information as well as limit what professions are listed in
the mouseover.

Installation: Unzip the reagentinfo-1.0.zip file into your World
of Warcraft directory.  This will create two folders in your
Interface/AddOns directory: ReagentInfo and ReagentData.  After
that, you're good to go!

Usage: To use Reagent Info, just mouseover various items in your pack, on the
ground, or at the auction house or click on item links in chat channels.  Reagent
Info also supports the following slash commands:

/ri enable - Enable tooltip information
/ri disable - Disable tooltip information
/ri clear - Clear the current character's settings, returning them to default
/ri clearall - Clear all Reagent Info settings (for all characters)
/ri config - Display the Reagent Info configuration screen.

Homepage: http://www.tarys.com/reagents/
Mirror #1: http://ui.worldofwar.net/ui.php?id=586
Mirror #2: http://www.curse-gaming.com/mod.php?addid=850

-------------
-- Changes --
-------------

-------------------
-- Version 1.5.1 --
-------------------

------------------
-- New Features --
------------------
--
-- * Updated for the 1.8 (1800) patch

---------------
-- Bug Fixes --
---------------
--
-- * Corrected a new nil error due to calling Blizzard's TradeSkillColor array
-- * Corrected a couple typos.  Thanks to DaemoN.

-------------------
-- Version 1.5.0 --
-------------------

------------------
-- New Features --
------------------

 * Updated for the 1.7 (1700) patch
 * Reagent Info can now optionally display usage information for certain quest
   drops in Zul'Gurub.  This was because the looting situation was a pain in the
   butt at first and I thought something like this might help other people out too.
   When you mouse over a piece of Zul'Gurub loot (like Sandfury Coins), Reagent Info
   can tell you what classes use the item and for what pieces of armor.  Like
   everything else in Reagent Info, it can be disabled and has a color choice as well.

---------------
-- Bug Fixes --
---------------

 * Reagent Info will no longer break shift clicking on item links
 * Changed event hooks to prevent nil errors on zoning as of 1.7

-------------------
-- Version 1.4.4 --
-------------------

---------------
-- Bug Fixes --
---------------

* Fixed a bug with tradeskill recursion.  Credit to Koalachan and Kaelten.
* Localization fixes for German and French clients (due to Reagent Data)

-------------------
-- Version 1.4.3 --
-------------------

---------------
-- Bug Fixes --
---------------

* Fixed a bug with displaying alt recipes.  Reagent Info wasn't showing the names
  for more than one alt.  Credit to Ratstomper.

-------------------
-- Version 1.4.2 --
-------------------

------------------
-- New Features --
------------------

* Updated TOC for the 1.6 (1600) patch

-------------------
-- Version 1.4.1 --
-------------------

---------------
-- Bug Fixes --
---------------

 * Accomodated for the Reagent Data 2.1.0 changes

-----------------
-- Version 1.4 --
-----------------

------------------
-- New Features --
------------------

 * "Recipe trees" in tooltips will now show sub-recipes that are above the threshold
   even if the parent is below the threshold.  For example, a high level tailor has
   some runecloth.  He can turn this into Bolt of Runecloth, which is a gray recipe.
   However, Bolt of Runecloth is used in Runecloth Gloves, which is an orange recipe.
   Reagent Info will now show Bolt of Runecloth as well as Runecloth Gloves in this case.

 * Reagent Info will now optionally show the recipies of your alts on the same server/faction.

 * If you are running Reagent Info standalone (without LootLink, ItemsMatrix, etc.), it will
   now display its information on merchant screens.

---------------
-- Bug Fixes --
---------------

 * Fixed a bug with slash commands not working
 * Removed a now unnecessary connection between ItemsMatrix and
   Reagent Info after talking with Derkyle.  This will prevent
   doubling (or even tripling) in some tooltips.  ItemsMatrix now
   natively includes basic profession information using Reagent
   Data.  If that's all you need Reagent Info for, you can safely
   go with just ItemsMatrix.  If you want tradeskill information
   as well, you should disable ItemsMatrix's Reagent Data checks
   on the ItemsMatrix option screen and enable sending to Reagent
   Info.

-------------------
-- Version 1.3.2 --
-------------------

---------------
-- Bug Fixes --
---------------
 * Fixed a freeze bug that happened on some clients using some code from Quest-I-On.
   Yes, I typed that correctly.
 * Integrated a SortEnchant fix provided by Gurvante.  It doesn't make sense to me why
   this would be the cause of the bug, but I'm not in the mood to argue with the LUA
   gods right now.
 * Reagent Info will no longer parse your tradeskill information if you disable the
   recipe display on the configuration screen.

-------------------
-- Version 1.3.1 --
-------------------

------------------
-- New Features --
------------------

 * Added German localization strings for the new text in 1.3.  Thanks to jth

---------------
-- Bug Fixes --
---------------

 * Compensated for a bug in SortEnchant's hooking routines that was causing errors for SortEnchant users

-----------------
-- Version 1.3 --
-----------------

------------------
-- New Features --
------------------

 * Added recipe usage to the tooltip.  See info below.

-------------------------
-- New Tradeskill info --
-------------------------

Reagent Info will now scan your recipe list when you open a tradeskill and make a catalog of recipes your 
character knows.  You may then optionally display the recipes an item is used in on your tooltips.  In 
addition, Reagent Info can determine what *subitem* is used in other recipes.  For example, mousing over 
linen cloth as a tailor will show it's used in Bolt of Linen Cloth.  However, Bolts of Linen Cloth are used 
in other items as well, so Reagent Info will continue to delve into your recipe list and show what 
tradeskills Bolts of Linen Cloth are used in.  This will continue up to four levels deep and may be 
disabled on the configuration screen.

You may also configure the number of recipes to show per level in the tooltip as well as the minimum threshold
of recipe to show (such as no gray recipes).

-------------------
-- Version 1.2.1 --
-------------------

------------------
-- New Features --
------------------

 * Added in the last of the German localization strings provided by jth.  Everything should
   now appear in German on German clients.
 * Added hooking code for MyInventory.  It works alone, with SellValue, and with ItemsMatrix.  The
   hooks appear to be in place for LootLink, but I couldn't get it working.  For now, I'm going to
   attribute this to these two mods not playing nicely together and leave it at that.  I'll look at
   a better fix in the future.

---------------
-- Bug Fixes --
---------------

 * Fixed a bug with my AIOI hooks.  I blame the Spanish Inquisition.

-----------------
-- Version 1.2 --
-----------------

------------------
-- New Features --
------------------

 * Added German localization strings.  Translation graciously provided by jth.
 * Added new configuration option to select whether Reagent Info's tooltip information
   appears above or below the rest of the tooltip info when using LootLink/ItemsMatrix

---------------
-- Bug Fixes --
---------------

 * Fixed a horrid bug that was causing bag frames to not update properly when selling, moving
   items, etc.  I sincerely apologize for this one.  Fortunately it was only graphical and didn't
   cause any damage.
 * Fixed a tooltip double display bug that could happen with LootLink/ItemsMatrix
 * Improved interaction with SellValue and other tooltip modification addons
 * I believe I've fixed a bug with the Group Loot window.  The game tooltip seems to work now when
   mousing over the Group Loot item, though Reagent Info does display profession information in the tooltip.
   Let me know if there still seems to be a problem.

-----------------
-- Version 1.1 --
-----------------

---------------
-- Bug Fixes --
---------------

 * Added additional tooltip hooks to fix compatibility with SellValue
 * Reagent Info now detects the presence of LootLink and hooks into it when appropriate
 * Reagent Info now detects the presence of ItemsMatrix and hooks into it when appropriate
 * Reagent Info now detects the presence of AllInOneInventory and hooks into it when appropriate
 * Fixed a bug with the color pickers on the UI screen.  There will still be a problem when using
   myAddOns to access Reagent Info's config screen.  Until I can find a more permanent fix, please
   use "/ri config" to make color changes.

-------------
-- Changes --
-------------

 * Shortened tooltip update delay to 0.1 seconds (was 0.2)

-----------
-- Notes --
-----------

I have tested as many addon permutations as possible with the mods mentioned above, though I did
not test every single one.  To the best of my knowledge, they all work except when ItemsMatrix is
paired with Auctioneer and Enchantrix.  In this condition, ItemsMatrix is not firing it's 
AddExtraTooltipInfo function properly and Reagent Info doesn't get a chance to update the tooltip.
I've done some testing and I think it's in his realm to fix, but I'd be happy to work with him to
fix the problem.

For the AIOI fix, I use ItemsMatrix's code to hook into AIOI's functions.  This is not the best
solution, but it's the best I have for now.  Sarf modified AIOI to be aware of LootLink, Reagent
Helper, etc. and handle their tooltips when necessary.  It'd be best if he could do the same here,
but I don't have contact info to discuss it with him.

As always, please let me know if you encounter any problems!

----------------
-- Additional --
----------------

Note: Reagent Info is dependent on my Reagent Data addon.  Reagent Data is a
standalone library that contains reagent information for all tradeskills in the
game as well as an API for easily accessing this data.  This information is
necessary for Reagent Info to function.  By packaging it as a separate addon with
API, other authors can make use of it as well and the more addons you have using
it, the better use you're getting out of your memory!

Fun Fact: This entire mod was developed from start to finish in
one afternoon.  This was due in part to the flexibility and ease
of use of the Reagent Data library.  Granted, Reagent Info isn't
very complicated, but imagine how long compiling the reagent
information alone would have taken.  :-D

Thanks To: As usual, I couldn't have done this without some
help.  Here's a few folks who deserve some props (whatever the
hell those are.)
   * My wife -   It's a rule.  She must be included.  It was in the
   marriage agreement.
   * Celdor - Item sounding board, pseudocode debugging, and
   stuff.
   * Norganna - Most of my tooltip code was based off of the code
   contained within Auctioneer and Enchantrix.  It's nice, clean
   code that is pretty much bug free and plays nice with others.
   * Telo - Some additional tooltip code and ideas came from Loot
   Link.  Plus Telo's got some nice, basic addons that everyone
   should use.
   * Tuatara - For the original Reagent Helper
   * People on the WoW UI Forums - The near daily requests for a
   standalone version of Reagent Helper drastically accelerated
   the completion of Reagent Data and Reagent Info.  :-D