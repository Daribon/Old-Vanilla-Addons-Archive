## Author: Sphinx
## Title: UUI - MoneyDisplay
## Notes: MoneyDisplay - Small movable window displaying current Player Money.
## Version : 1.7.1
## OptionalDeps: None
## Dependencies: None

FILES IN ZIP
MoneyDisplay.xml
MoneyDisplay.lua
MoneyDisplay.toc
readme.txt

INSTALLATION
Extract the MoneyDisplay directory into c:\World of Warcraft\Interface\AddOns\MoneyDisplay
where c:\World of Warcraft is the install directory on your machine.
If this is the first UI mod you have installed you will need to create the \Interface\AddOns directory otherwise it should already exist with your other mods contained within.

MOD DESCRIPTION
Display's a new panel showing Gold, Silver and Copper with appropriate icons defaulting to top-middle of screen.  This updates automatically as you gain or lose money.  The panel can be relocated to any point on the screen by clicking and dragging (click near upper border).

Use of /money command.

/money		   -    Shows all commands
/money show	   -	Shows the mod
/money hide	   -	Hides the mod
/money reset	   -    Reset to default
/money hideborder  -    Hides window border
/money showborder  -    Shows window border
/money alpha 0-255 -	Set the background transparency (0 = transparent, 255 = solid)

REVISIONS
   v1.7.1 
   -- Added reset option and changed ui location code.
   v1.7
   --Removed Unlock/Lock feature for UI mod stability.
   v1.6
   --Two major bug fixes corrected that disabled money command and variable saving.   Help menu added to default /money command.
   v1.5 
   --Changed TOC file to work with WoW patch 4216
   --Width and Height modified from user suggestions
   --Implemented Alpha and border functionality submitted by Rabbit
   --Implemented change of Command Line Call from /moneydisplay to /money as suggested by Rabbit
   --Implemented save window position based on code supplied by MentllyGuitarded
   v1.4 
   --Now adds functionality for locking, unlocking, show and hide and saving location.
   v1.3
   --Allows gold upto 999 to show correctly and adjusted number alignmnent.
   v1.2
   --Graphical money icons added to display.
   v1.1
   --Money expressed as text 10g 10s 10c
   v1.0
   --Money expressed as a numeric value GGSSCC.

TROUBLESHOOTING
If the mod fails to load the most likely problem is a patch revision on the World of Warcraft client PC.   When the WoW login screen appears check the Revision number at the bottom left of screen (e.g 4216).   This number needs to be correct in the MoneyDisplay.toc    Open MoneyDisplay.toc and change the ## Interface: 1300 line to match your current revision.
The interface number 4216 is correct as at 25-Feb-2004.

FUTURE DEVELOPMENT
Hover over tooltip giving various session stats on money incoming / outgoing.

END
Thanks for using my very simple UI Mod !
