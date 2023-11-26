Slash Command(includes usage info): "/looklock"
For help, type "/looklock help"

--About--
 This addon makes it possible to bind a key to enter a state where
 moving the mouse rotates the character, without holding down a button.
	While in this mode, the mouse buttons can be set to behave
 differently, or to strafe.

--GUI Information--
 This addon supports both Khaos and Cosmos, which will give you graphical configuration options, for every option this addon has.  You can obtain Cosmos and Khaos from http://www.cosmosui.org

--Installation Info--
 Simply extract LookLock.zip to your Interface/Addons folder

--Dependencies--
 Optional: Sea, MCom, Sky, Khaos, Cosmos, myAddOns, VisibilityOptions

 This mod comes with an embeded version of MCom, so you don't need to load MCom as a seperate addon to use it. But if you do, then the seperate addon MCom will take precidence over the embeded one.

--Author Info--
 By: Mugendai
 Special Thanks:
  Skrag, and iecur showed me how to do this, way back during beta, and
 thus allowed me to make my first addon.
 Contact: mugekun@gmail.com

--Change Log--
v1.37:
-Updated to MCom 1.48
-Updated for 1.8 patch
v1.36:
-Updated to MCom 1.47
-The escape canceling will now only occur when the main menu opens, instead of ANY time escape was pressed
v1.35:
-Lock modes will now be canceled if you hit a button to open the main menu.  This helps to guarantee that if some window pops up over your mouse, you can get the mouse back.
-Updated to MCom 1.46
-Added support for the newer version of myAddOns: 2.2
v1.34:
-Added Camera Lock key bindings
-Added options to automatically enter look/camera mode when releasing the mouse button if it was held for several seconds
v1.33:
-Removed a call to a function that was only useful for AlwaysLook mode which is currently not possible
v1.32:
-Updated to MCom 1.44
-Added new slash command root: /llk
-LookLock will no longer use the /ll slash command when LootLink is around, yielding to it's higher popularity.
v1.31:
-Updated to MCom 1.41
-Added Khaos option dependencies
v1.3:
-Updated for 1.7 patch
-Changed to the new variable storage system, so that variables are now saved in the per addon directory
-Moved all option registration out of the main lua file, and into a seperate file
v1.23:
-Updated to MCom 1.35
-Updated to MCom 1.34
-Updated to use MCom.safeLoad to prevent nil options for overwriting defaults on variable loading
v1.22:
-Updated to MCom 1.33
-Re-enabled setting transparency of the targeting cursor
v1.21:
-Removed unused Sea dependencies
v1.2:
-Updated for 1.6 patch
-Updated to MCom 1.32
-Updated to MCom's new load format
-Will now save the config variable whether there is a UI around or not
-*Sob* Blizzard broke Always Look mode, so until further notice it has been disabled
-Always Look will now properly disable when ItemTextFrame is showing
-Updated to MCom 1.29
-Updated to MCom 1.28
-Added an option to only re-enter look mode when in Always Look mode, when the mouse is in a certain area of the screen.
-Added an option to require a delay of the mouse being in always lookable region, before re-entering look mode
-When right/left clicking out of look mode, clicks/actions will now only take place if the mouse isn't over another frame
-Fixes for potential bugs
-Complete revamp to my newer MCom based format
-Supports Khaos and myAddOns
-Added ability to show a targeting cursor when in look mode
-Added ability to change how the left mouse behaves in look mode
-Updated frames list for Always Look mode, should now handle all frames in Cosmos as of 7/5/2005