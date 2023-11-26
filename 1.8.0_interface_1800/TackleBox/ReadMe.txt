Slash Command(includes usage info): "/tacklebox"
For help, type "/tacklebox help"

--About--
 This mod assists the fisherman by making it easy to cast, and easy to switch to the fishing poles and back.  When a fishing pole is equipped, right clicking will cause the player to cast their line.  Also it can put a lure on your pole if it doesn't already have one, and you have one in your bags.

--GUI Information--
 This addon supports both Khaos and Cosmos, which will give you graphical configuration options, for every option this addon has.  You can obtain Cosmos and Khaos from http://www.cosmosui.org

--Installation Info--
 Simply extract TackleBox.zip to your Interface/Addons folder

--Dependencies--
 Required: Sea
 Optional: MCom, Sky, Khaos, Cosmos, myAddOns

 This mod comes with an embeded version of MCom, so you don't need to load MCom as a seperate addon to use it. But if you do, then the seperate addon MCom will take precidence over the embeded one.

--Author Info--
 By: Mugendai
 Special Thanks:
  Sinaloit: Origional use of textures to determine fishing skill and equipment

  Aalny:    Origional use of ItemLink's to store/recognize equipment.  As well as
 a few tweaks and fixes.  Oh and the Shift click option.  Aalny did a
 fair amount of good work.
  Groll: For asking for the Easy Lure feature
 Contact: mugekun@gmail.com

--Change Log--
v1.46:
-Updated to MCom 1.48
-Updated to support 1.8 blizzard addons
v1.45:
-Updated to MCom 1.46
-Added support for the newer version of myAddOns: 2.2
v1.44:
-Added fishing boots
v1.43:
-Updated to MCom 1.45
-Fixed MCom.io error, I forgot to capitalize IO, sorry
v1.42:
-Updated to MCom 1.44
-Removed Sea dependance
-Fixed Macro creation duplication that occured when not using Cosmos/Khaos.  Macro will now not be created till you open your macro screen.  If there is more than one copy of the Tackle Box macro, the extra copies will be deleted.
v1.41
-Updated to MCom 1.41
-Added Khaos option dependencies
v1.4:
-Updated for 1.7 patch
-Changed to the new variable storage system, so that variables are now saved in the per addon directory
-Moved all option registration out of the main lua file, and into a seperate file
-Fixed the binding for throwing your line
-Added a binding to switch your equipment
v1.33:
-Updated to MCom 1.35
-Updated to MCom 1.34
-Updated to use MCom.safeLoad to prevent nil options for overwriting defaults on variable loading
v1.32:
-Updated to MCom 1.33
-Turns out that Aquadynamic Fish Lens is not 6531, but 6811, aka Aquadynamic Fish Lens will now be properly used as a lure.
v1.31:
-Will no longer make an audible error message when trying a lure that is too high level.
v1.3:
-Updated hooks and functions to use . format
-Added Easy Lures feature, Lures are identified by itemlink id, this likely needs testing, and not all lures are included.  If you know a lure that needs to be included, let me know.
-Updated help docs to be a bit more helpful.
v1.2:
-Updated for 1.6 patch
-Updated to MCom 1.32
-Updated to MCom's new load format
-Will now save the config variable whether there is a UI around or not
-Updated to MCom 1.3
 This improves the display of the help screen, and shows current status of all options in it as well
-Updated to use MCom's new textname, to help a bit with localization ease
-Updated to MCom 1.29
-Updated to MCom 1.28
-Updated to MCom 1.27
-Updated to MCom 1.26
-Updated to MCom 1.25
-Added support for myAddOns
-Updated MCom to 1.24, slight improvements to the display of the help screen.
v1.11:
-Updated to MCom 1.23
v1.1:
-Updated to MCom 1.22
-Added a help dialog
-Fast Cast now means that you can re-cast while already casting. Otherwise, if you are currently fishing, then you can't cast again until you finish. This removes dependancy on the Bobber name, and completly removes need for localization for functionality.
v1.0:
-Complete revamp of the codebase
-Now uses MCom(meaning it can register with Cosmos and Khaos)
-Commented the code to great extremes
-Fishing skill, and equipment are now recognized by texture
-Items are now stored/loaded by ItemLink
-There are now options to make it only cast when you hold, Shift, Alt, or Control
-Supports both fishing hats, and gloves now
-Can now store/load it's variables on a per realm, per character basis.