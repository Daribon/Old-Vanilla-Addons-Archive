TackleBox (SA)
by Aalny
version 1.1
(forked from Mugendai's original TackleBox included with Cosmos)

Download Location:
http://wow.dvolve.net/dropbox/wow/TackleBoxSA_1.1.zip
(and in case my server is down)
http://www.curse-gaming.com/mod.php?addid=1215
http://www.wowguru.com/ui/tackleboxsa/

---------------------------------------------------------------------------
Description

This Addon helps people use the Fishing tradeskill more efficiently by
making it easy to cast and easy to switch between fishing gear and normal
gear.  When a fishing pole is equipped, right clicking will cause the
player to cast their line.  Also, clicking on the bobber will automatically
recast the line.  Type "/tacklebox help" in game for instructions on how 
to use the features.

It should be noted that Mugendai's original TackleBox included with Cosmos
was the starting point in making this stand alone version.  Many, many
thanks to Mugendai and all those who helped write that original version.


---------------------------------------------------------------------------
Features

* EasyCast allows right-click casting while a fishing pole is equipped.
* FastCast allows automatic recasting after clicking the bobber.
* Switch command allows swapping between normal and fishing gear sets.
* Reset command clears all saved gear sets.
  

---------------------------------------------------------------------------
Known Issues

* The German and French translations *should* work from a functional
  standpoint.  However, most of the French and some of the German output 
  text is still in english.  I don't have those clients to test with and I 
  don't speak either language so I'll need help translating.
* FastCast is dependent on EasyCast.  So if EasyCast is off, FastCast will
  not work regardless of it's setting.


---------------------------------------------------------------------------
History

1.1
* Updated toc for 1.5.0 patch
* Gear sets and casting options are now saved per character. Sorry about 
  the delay on this one.  The 1.5 patch fixed the Lua environment in such 
  a way that doing this is much easier now than it would've been before.

1.0.3
* Thanks to Sylvaninox for providing more of the French translation.
* Minor internal code changes and some prep for per-character data saving.

1.0.2
* Thanks to Maischter for providing a more complete German translation.
* Fixes some string formatting so the translations would work better.

1.0.1
* Fixed an annoying bug that would reset your gear sets on every login.
  (forgot to remove some old code)
* Fixed a minor bug that would cause the saved gear sets to get confused
  if your saved main hand weapon was 2h and then you switched to 1h+shield
  combo.  Only the shield would end up getting equipped.

1.0
* Initial fork from TackleBox version 4150 on Curse-Gaming:
  http://www.curse-gaming.com/mod.php?addid=97
* Removed all remaining Cosmos related code
* Easycast and Fastcast are now on by default
* Since apparently the Lucky Fishing Hat doesn't exist in game anymore,
  hat saving has been replaced with glove saving because you can get
  gloves enchanted with fishing skill.
* Changed the core method used to find, examine, and equip items.  It now
  uses the item ID from the item link rather than the item tooltip.  This
  was primarily because searching for fishing poles based on tooltip was 
  problematic in different locales.  The change also has the pleasant 
  side effect that MUCH less data needs to be saved in SavedVariables.lua.
* Simplified the slash command processing code a bit.
* No more automatic macro creation because it was buggy and unneccesary.
  You can create your own macro with "/tb switch"
* The command help text was tweaked a bit for clarity and formatting.
* Renamed most of the internal variables so that theoretically nothing
  will conflict if the user has the Cosmos version installed as well.
  However, there will still most likely be issues because the slash
  commands are the same and who knows what'll happen if two addons
  try to do the same thing at the same time.
