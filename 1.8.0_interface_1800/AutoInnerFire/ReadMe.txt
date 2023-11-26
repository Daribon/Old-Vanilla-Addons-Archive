---------------------------------------------------------------------------------------
# AutoInnerFire 1.33
---------------------------------------------------------------------------------------
| 
| This mod piggyback's the movement keys to automatically
| cast the best rank of Inner Fire if you are a priest, you
| do not have the buff, you are not on a mount, you are not using
| Mind Control or you are in combat, and your mana is above a certain
| percentage threshold.
| 
# Help:
| 	Configurate with /autoinnerfire or /aif
| 	- on (enables AutoInnerFire)
| 	- off (disables AutoInnerFire)
| 	- threshold (mana threshold)
|   - combat (toggles buff in combat)
|   - button (toggles minimap button)
|   - position (changes minimap Button position)
|   - options (options frame)
| 	
| 	Examples:
| 	/autoinnerfire on (aktivate AutoInnerFire)
| 	/autoinnerfire off (deaktivate AutoInnerFire)
| 	/aif threshold 50 (change the mana threshold to 50%)
|   
|   
# Authors:	
| 	- Gello (AutoInnerFire 1.0)
| 	- Hyjal (AutoInnerFire 1.1)
| 	- deto (AutoInnerFire 1.2 & 1.3) - www.mydeto.de
|   
|   
# ToDo 1.4
|   - don't know ^^
|   
# Revision 1.33 (by deto)
|   - added check to make sure you are not having 'inner focus'
|   
# Revision 1.32 (by deto)
|   - added check to make sure you are not having 'spirit tap'
|   - disabled the addon for non-priests
|   
# Revision 1.31 (by deto)
|   - fixed a bug in the save profile routine
|   - support for Cosmos UI & CT_Mod
|   
# Revision 1.3 (by deto)
|   - Localization some texts to FR - thx to Fue of the curse-gaming comments
|   - added minimap button
|   - added configuration menu
|   - added the other movement keys for the buff
|   - added feature - buff in combat on/off
|   - also added autowalk as buffmethod
|   
# Revision 1.22 (by deto)
| 	- bugfix at the slash events
|   - colored the help msgs
|   - updated the .toc file
|   
# Revision 1.21 (by deto)
| 	- some changes at the slash events
| 	- changed the 'mymana' check (ceil(); instead of round();)
|   - updated the .toc file
| 	
# Revision 1.2 (by deto)
| 	- Slash Commands
| 	- Help File
| 	- Localization (EN & DE)
| 	- Profiling
| 	
# Revision 1.1 (by Hyjal)
| 	- Added check to make sure that mana is above a certain percentage threshold.
| 	- Added check to make sure you are not using Mind Control.
| 	
# Revsion 1.0 (by Gello)
| 	- first release
| 	- mother addon
| 	
# Thanks to...
| 	... myBank Team (for some great functions)
|   ... myClock Team (for the configmenu template)
|   ... Atlas Team (for the Minimap-Button templat)
| 	... Gello (for AutoInnerFire 1.0)
| 	... Hyjal (for AutoInnerFire 1.1)
| 	... wowwiki.com (for some help)
| 	... EasyPriest-Team (for the frence 'Inner Fire' name ^^)
|   ... Fue of the curse-gaming comments (for the frence localization)
| 
---------------------------------------------------------------------------------------