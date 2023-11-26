This is Gatherer v<%version%>
http://gatherer.sf.net/

ABOUT:
--------------
Gatherer is an addon for herbalists, miners and treasure hunters in World of Warcraft. It's main purpose is to track the closest plants, deposits and treasure locations on you minimap.

The addon does not track like a tracking ability does, rather it "remembers" where you have found various items in the past. It does this whenever you gather (perform herbalism, mining or opening) on an item, and records the specific map location in it's history. From then on, whenever the item comes into range of being one of the closest 1-25 (configurable) items to your present location, it will pop up on you minimap.

When you view your main map, you will also see the item locations marked on the particular map you are viewing there.

INSTALLATION:
--------------
Extract the data to your "World of Warcraft/Interface/AddOns" directory so that the "Gatherer" directory is a subdirectory of the "AddOns" directory.

USAGE:
--------------
Just use the game as normal.
When you gather things, they will appear on your minimap and your main map.
If you want to configure the addon, click the Gatherer configuration icon floating around your minimap frame.


CHANGELOG:
----------
2.0.3:
===========
* Bug Fixes:
- Localization:
  # german: error in localization.lua
- Map should show correctly in battlegrounds now.
 

2.0.2:
===========
* Bug Fixes:
- Localization:
  # english: barrel gathering should now read barrels that have the keyword at the beginning of the gather text
  # german: firebloom, mountain silversage, clam, rich thorium and small thorium should be fixed, "ooze covered" display problem should be fixed too.
  # french: zone transition matrix for wow patch 1.5.0 added
  # french: new french GatherRegionData ordered table
- slowdown on using no icon under min distance option should be lessened in gather item heavy environment
- delay opening world map with a huge number of items should be reasonable now.

* Features:
- Icon size on worldmap can now be changed (between 8 and 16, included, hit enter in the edit box to validate the new value)
- option to hide the minimap menu icon
- tooltips added for all UI elements
- added tooltip to menu title to make it more obvious you can click on it to access configuration dialog
- option to hide mininotes while still displaying gather items on minimap
- option to display full item name on worldmap item tooltip instead of the short one (thorium will always show the long name whatever the option value is)
- myAddOns support
- ingame item deletion facility added (alt right click on item on the worldmap), alt mousing over an item in the worldmap display full name and item indexes in the GatherItems structure.
- misc: added a hundred more buttons to display items on world map as part of the large item DB fix.

2.0.1:
======
* UI: New movable UI button on minimap border, gives access to a quick toggle menu for main filters (options for show/hide the quickmenu and move the minimap icon in the options dialog).
* UI: by clicking on the quick menu title, you access a configuration windows for Gatherer options (can also be accessed by using /gather options).
* UI: key binding available for the quickmenu.

* Filter (UI only): possibility to filter ore/herbs display by giving minimum skill level (text field next to the gather type filter boxes).
* Filter (UI only): possibility to select specific objects to display.
* Filter (UI only): couple rare ore/herbs so that they can be displayed together (ex: tin and silver shown together by selecting only one, or for herbs selection swiftthistle will show briarthorn and mageroyal)
* Filter (UI only): prevent gatherer icon from displaying when a node is closer than the min icon distance (used to switch between theme icon and item icon).

* Localization: french and german localization fixes
* Localization: facility for swapping data around zones and fixing item names for localized clients

* Various: GatherRegionTable moved to it's own file outside of Gatherer.lua

* Bug Fix: remaining RegisterForSave removed from code, in some case they could cause a fatal client error with #132 error (note: this is not specific to gatherer, it's true for all WoW addons)
* Bug Fix: missing icon for treasure in original theme fixed
* Bug Fix: Real zone text is now used that should alleviate difficulty to display the map in some zone on first try (ie. Ironforge).


1.9.12:
=======
- Updated patch number.

1.9.11:
=======
- Fixed some other small stuff

1.9.10:
- Fixed nasty bug where icons would not appear on minimap.

1.9.9:
======
- Fixed minimap tooltip layering issue

1.9.8:
======
- Patched to version 1.2.4
- Added extra german and french localizations
- Fixed wandering icons on french localized versions
- Reduced sizes of minimap icons to 12x12
- Increased size of mainmap icons to 12x12
- Improved visibility by moving minimap icons below player and skill icons
- Added the ability to add herbs/ore when you do not have the ability simply by attempting to gather it (triggered by the error message that you can't gather it)
- Tweaked map-minder to be less annoying
- Fixed map-minder disable bug

1.9.7:
======
- Fixed stupid unset variable bug with mapMinder

1.9.6:
======
=> Patch day! Now up to date with patch level 4211 (1.2.3)
- Reduced size of icons on main-map, made partially transparent and popped 'em under the player icons.
- Added "Map Minder". This little beast will remember your last open main map for 60 seconds and then take you back to it. If it's more than 60 seconds, you get taken to your current location. You can turn it off with the new "/gather minder off" command, but then you will just be taken to your current map every time you close and reopen your main map.
- Changed the icons, so they no longer have a border... nobody liked em 'cept me... Poot.
- Added icon fading in your minimap so that as the icons get farther away, they will progressivly fade out.
- Added partial German translations care of Lokibar - Dankeshoen! (Any further translations very welcome!)

1.9.4:
======
- Fixed a bug when no arg1 was passed to the buffer reader.

1.9.3:
======
- No major changes, just packaging changes.

1.9.2:
======
- Fixed positioning, add multiline notes, correctly justified.

1.9.1:
Fixed ore and treasure not appearing on main map as icon, but as a circle.
Deleted a rogue print2 statement.

1.9.0:
======
- Fixed wandering icon bug
- Added main-map item locations
- Added locale fixes for French localized version

1.8.8:
======
- Fixed some herb icon displaying stuff for mountain silversage and wildvine.

1.8.7:
======
- Fix ore gathering bug that was causing ore to not be recognized.

1.8.6:
======
- Cosmetic change - names in tooltips now in Title Case

1.8.5:
======
- Fixed bug where data was not initialized causing error

1.8.4: (many thanks to Jet who contributed much for this version)
======
- Fixed bug with icon display causing script errors
- Added per character filtering options.
- Added localizations in french.
- Added giant clam treasure

--------------
Revision: $Id: Readme.txt,v 1.3 2005/06/16 16:54:53 islorgris Exp $
