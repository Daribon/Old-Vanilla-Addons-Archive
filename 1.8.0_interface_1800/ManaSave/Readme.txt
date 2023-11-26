==========================================================
axel0r's ManaSave - www.for-the-horde.de // www.ocrana.com 
==========================================================

- CREDITS
- Requirements
- Whats is ManaSave
- Why use ManaSave
- Configuration
- Changelog

CREDITS:
-------

- big thx to FtH|Ghash for introducing me into WoW API and Lua and helping me a lot with this
- thx to my guild mates from www.for-the-horde.de for helping me testing


Requirements:
-------------

. at least Ace v1.0c
. at least Timex r.21
. Please DELETE CQMC before using ManaSave ;)

What is ManaSave?
-----------------
ManaSave is an Addon which checks the target of your healing spells. If the target has not lost more hp than your heal would heal it,
ManaSave aborts your heal. So this is the same what CQMC or CTRAMS does.


Why use ManaSave instead of CQMC or CTRAMC?
-------------------------------------------

. ManaSave is able to use absolute values for health checking, so it lowers your overheal, 
  especially for classes with low hp. Nevertheless, if you want to, you can also use percent values.
. ManaSave has a Multiplicator for your basic absolute heal check value. You simply can adjust this multiplicator if you use different gear.
  e.g. your basic abort value for flash heal is 1000hp. If you equip your + healing gear with additional +300 healing you simply set
  your multiplicator to 1.1 and the new check value will be 1100. so you ll have less overheal while wearing your +healing gear.
. ManaSave can be disabled when casting spells on yourself. So it wont abort heals on you, but still on other targets. Believe me, thats great in PvP ;)
. ManaSave saves the target on which you start to cast your heal. Thats makes you able to switch your target while casting your healspell.
  ManaSave will still check the player on which you casted your spell and not your new target.
. you can switch your ManaSave settings easily with console commands
. you can, like in cqmc, set the time before your heal ends at which ManaSave will check the target
. ManaSave already provides you with a template of values for each heal spell
. ManaSave works on Targets in your party, raidgroup or even non grouped players (but only using percent values on non grouped) 


Configuration:
--------------

You CAN configure ManaSave for your preferences, but you DONT HAVE TO, it works well with the default settings.
But be sure to use /ms report once you use ManaSave the first time to check if the default settings fit to your personal preferences.
If you haven't reached lvl 60, i strongly recommend to config ManaSave to use percent values or adjust your absolute values for the lvl of your spells.
Please change NOTHING in the lua files. you must change your settings with the console commands!

Commands:

/ms - shows you all commands
/ms checktime x - sets the time before healcast on which health status gets checked, depends on your latency. must be between 0.4 and 1, e.g. /ms checktime 0.5
/ms usepercent - makes ManaSave use percent values for the heal abort check
/ms useabsolute - makes ManaSave use absolute values for the heal abort check, recommended
/ms report - reports the settings of your ManaSave Installation
/ms setpercent - set the percent value where the healspell doesn't abort anymore, e.g. /ms setpercent Flash Heal=85
/ms setabsolute - set the basic maximum absolute value of health deficite to abort for a heal, e.g. /ms setabsolute Flash Heal=950
/ms selfcheck - disables or enables ManaSave to check health status when a player casts a heal on himself
/ms multiplicator x - sets the multiplicator for absolute values, default=1 must be between 1 and 2
/ms debug - toggles debug messages on/off, i hope you ll never have to use it ;)


Changelog:
----------

v0.06
- major bugfix for classes which don't need ManaSave. You should now get no more error messages by using any spells

v0.051:
- little bugfix

v0.05:
- Added support for Druid spell "Regrowth"
- Added spell abort check for Player Pets (percent only)
- fixed german localisation for paladins flash of light
- reimplemented /ms reset (now using Ace ;-))


v0.04:
- implemented /ms reset to reload default ManaSave Settings
- some minor adjustments at the basic check values
- multiplicator can now be set between 0.5<m<2, for those who WANT to overheal, e.g. if your mage uses aoe spells.
- changed /ms multiplicator to /ms setmulti - should be more handy
- slight text changes

v0.03:
- serveral bug fixes
- slight text changes






so, i whish you all HAPPY HEALING ;)

axel0r aka FtH|Lucrella


plz vist 
www.for-the-horde.de
www.ocrana.com

kthxbye





