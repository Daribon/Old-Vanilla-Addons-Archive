Slash Command(includes usage info): "/hide" "/autohide" "/trans"
For help, type "/hide help", "/autohide help", and "/trans help"

--About--
 Visibility Options, also known as Eclipse, allows users the ability to hide frames, autohide frames that don't have the mouse over them, and to change the transparency of frames.

 It provides a set of interfaces for developers to easily register frames to be hidden, autohidden, or made transparent as well.  See Eclipse.lua's comments for further details.

 VisOpts is meant to replace both PopNUI and TransNUI, and it adds the ability to completly hide frames as well. PUI and TUI will be phased out, if you have any mods that use them, please update those mods to use VisOpts instead. You will find that the VisOpts registration is just as easy, if not easier(you can register a frame for hiding, autohiding and transparency all in one register) as PUI and TUI were.

 NOTE: VisOpts is mostly backwards compatible with PUI and TUI. This means that any old mods that used PUI and TUI should work fine with VisOpts. VisOpts will complain that they are using old code though. However the mods will likely need to have an optional dependancy for VisibilityOptions, added.

 NOTE: DO NOT USE VisibilityOptions and PopNUI or TransNUI at the same time!

--Installation Info--
 Simply extract VisibilityOptions.zip to your Interface/Addons folder

--Dependencies--
 Required: Sea
 Optional: MCom, Sky, Chronos, Cosmos, Khaos, myAddOns, BarOptions, CT_RaidAssist, PopNUI, TransNUI

 If you wish to hide the parts of the mainbar, and not the entire bar, then you must also use the BarOptions AddOn(but you do not have to enable any of its options)

 This mod comes with an embeded version of MCom, so you don't need to load MCom as a seperate addon to use it. But if you do, then the seperate addon MCom will take precidence over the embeded one.

--Author Info--
 By: Mugendai
 Contact: mugekun@gmail.com

--Change Log--
v1.45:
-Big change in methodology. 
 VO now tracks the proper normal state of frames, and only shows frames if they shouldnt be hidden.
 Allows other things to change transparency of transparent controls, and does so in a multiplicative way.
 Need for requirements and hooks for many frames is now removed due to this system.
 This also allows fully proper behavior with CT_RaidAssist and possibly other addons.
 Old methods will still function fine, and you can override this behaviro using manual, and manualtrans options.
 Addon authors should check their regs out, you can likely remove your reqs, or may want to use manual/manualtrans and may need to set the initial state of the frame.
-Fixed check to make sure that UIFrame can not be set to less than 10% opacity
v1.44:
-Updated to MCom 1.35
-Fixed a potential error that could occur if an addon that registered with VO was removed
v1.43:
-Updated to MCom 1.34
-Updated to use MCom.safeLoad to prevent nil options for overwriting defaults on variable loading
v1.42:
-Updated to MCom 1.33
-Updated hooks to use . format
-Added ability to pass an onupdate function to allow frames that need to onupdate while hidden, to do so.
v1.41:
-Added options for Chat Menu and Scroll buttons
v1.4:
-Updated for 1.6 patch
-Updated to MCom 1.32
-Updated to MCom's new load format
-Will now save the config variable whether there is a UI around or not
-Improved iterated frame sets so that the iterated number can be specified via format code: I.E. "Frame%dName"
v1.35:
-Updated to MCom 1.3
This improves the display of the help screen, and shows current status of all options in it as well
-Updated to use MCom's new textname, to help a bit with localization ease
-Fixed bug that the status update text would not display at all
-Added slashname to allow setting what name to show in slash commands, defaults to uiname
v1.34:
-Updated to MCom 1.29
This fixes the bug that the slash command did not update the Cosmos variables.
v1.33:
-Updated to MCom 1.28
-All registrations now support setting, section, separator, and option difficulty for Khaos
v1.32:
-Updated to MCom 1.27
-Fixed the new slash commands, voh, voah, and vot to actually work
v1.31:
-Added aliases for all three slash commands: /hide - /voh, /autohide - /voah, /trans - /vot
-Fixed display of the Exhaustion Tick(the tick mark on your XP bar that shows your rest state)
-VisibilityOptions will now REFUSE to load if PopNUI or TransNUI are enabled
v1.3:
-Updated to MCom 1.26
-Added aliases for action bar.. action, mainactionbar, mab
-Added ability to control the main bar menu buttons, and bag buttons seperate of the main bar
-Will no longer control party frame if CT_RaidAssist is loaded
-Makes use of new MCom getStringVar version
v1.22:
-Updated to MCom 1.25
-Added myAddOns support
v1.21:
-Updated to MCom 1.24
v1.2:
-Updated to MCom 1.23
-VO was creating some 30k garbage collections per second. I've found and eliminated the sources of these GCs, and now it generates 0kgcps.
v1.12:
-Updated to MCom 1.22
-Added a help dialog
v1.1:
-Can now store/load it's variables on a per realm, per character basis.
-Updated to MCom 1.1