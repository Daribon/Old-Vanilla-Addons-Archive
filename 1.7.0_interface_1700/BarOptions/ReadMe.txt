Slash Command(includes usage info): "/baroptions"
For help, type "/baroptions help"

--About--
 BarOptions is a mod that is meant to expand the capabilaties of the built in bars provided by Blizzard. It lets you do several things with that bars, and here is a list:
 -Gives several options for configuration of the varying bars:
 -Remove art from the bars
 -Add background art to the multi bars
 -Replaces BonusActionBar with one that has an accessable background art, needed for PopNUI, TransNUI, and VisibilityOptions
 -Provide coloring of actions that are not in range of their target.
 -Use a different set of ID ranges for the bars, like secondbar, and sidebar did.
 -Group the bottom left bar and action bar, for turning pages, like secondbar did.
 -Make the bottom left bar use different ID's based on stance.
 -Show/Hide empty bar buttons.
 -Show the hotkeys on the multi bars.
 -Show/Hide all hotkeys.
 -Shorten the names of the modifier keys for bindings.
 -Change the number of buttons on each of the four multi bars.

--Installation Info--
 Simply extract BarOptions.zip to your Interface/Addons folder

--Dependencies--
 Required: Sea
 Optional: MCom, Sky, Cosmos, Khaos, myAddOns

 This mod requires a RECENT version of Sea dated 6/17/2005 or later. You can get it via Cosmos, or on Curse.
 This mod comes with an embeded version of MCom, so you don't need to load MCom as a seperate addon to use it. But if you do, then the seperate addon MCom will take precidence over the embeded one.

--Author Info--
 By: Mugendai
 Contact: mugekun@gmail.com

--Change Log--
v1.23:
-Updated to MCom 1.35
-Updated to MCom 1.34
-Updated to use MCom.safeLoad to prevent nil options for overwriting defaults on variable loading
-Added options to move the Main Bar to the bottom left, right, or center
v1.22:
-Updated to MCom 1.33
-Fixed the BOBAB relative to the AB instead of BAB, aka fixed the bar dissapearing when shapeshifting
v1.21:
-Made BarOptions Bonus Action Bar relative in position to the normal BonusActionBar.  Will fix incompatability with mods that move the BonusActionBar, or main bar.
-Updated hooks to use . format
v1.2:
-Updated for 1.6 patch
-Updated to MCom 1.32
-Updated to MCom's new load format
-Will now save the config variable whether there is a UI around or not
-Updated to MCom 1.3
 This improves the display of the help screen, and shows current status of all options in it as well
-Updated to use MCom's new textname, to help a bit with localization ease
-Updated to MCom 1.28
-Updated to MCom 1.27
-BarOptions.OffsetParty wasn't saving new location properly, however this functionality may or may not be needed.  But it at least works now ;)
-Updated to MCom 1.26
-Updated to MCom 1.25
-Added support for myAddOns
-Updated MCom to 1.24, slight improvements to the display of the help screen.
v1.13:
-Updated to MCom 1.23
v1.12:
-Updated to MCom 1.22
-Added a help dialog
v1.1:
-Fixed a few bugs in the slash command output when no UI was available.
-Can now store/load it's variables on a per realm, per character basis.
-Updated to MCom 1.1