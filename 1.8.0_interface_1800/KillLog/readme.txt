----
Name
----

KillLog


-----------
Description
-----------

Record number of creeps you kill and the amount of experience you receive.
Also records deaths.


The method of determining if you killed a creep or not is a bit fuzzy.  This
is the general style I used.  When a creep dies, 
  if you get experience, it is a kill
  if you should not get experience (low level / critter / pvp) and you have
    just done damage to the creep, it is a kill
  otherwise, it is not a kill

This means that if you kill a creep that you should get experience for but
it is tagged by someone else, it will not be counted as a kill.

UPDATE:  I have revised the above logic a bit to count a few more cases that
I had missed before.  It is basically the same as above.  The only exception
is that I check the level of the creep when you TARGET them.  If you will
not get experience for killing that creep, I will store their name and give
you credit when a creature with that name dies.  Before, I checked the 
maximum level of the creep that just died and would not count the kill if
the maximum level should give you experience.

This is still not perfect, since Blizzard does not provide any method to
track kills that you do not receive experience for.  But it is a little
better.


-----------------
Accessing the GUI
-----------------

There are now two methods to access the GUI.  You can either create a
keybinding for it, or use the slash command.
  /killlog
  /kl


----
Note
----
It is NOT possible to store the portraits of the creeps you have killed
between sessions.  My assumption for this is that the portraits are actually
created by merging various textures and for this reason you cannot find a
string to use to load the same texture later.  (human face #2 with hat #5
and shirt #23 or something)  I store up to 100 for the current session only.

I tried everything I could think of to avoid this at least and was not able
to find a way around it.

----
Todo
----
The next things I have planned:
[OPTION TAB]
  - track current session data
  - storing overall data
  - number of levels of level data to store (down to 0)
  - number of portraits to store (possible performance drag on some systems)
  - update tooltip with Kill count
  - filter trivial creeps from display list


-------
History
-------

+ Version 2.15:
  * removed a few debugging messages
  * changed formatting of Death tab a bit
  * added additional family specifications
  * corrected error in French translation regarding "Repose" vs. "En forme"

+ Version 2.14:
  * actually got in a large group and found the error tracking group experience!
    This is now fixed.
  * enabled storing death information.
  * suppressed KillLog loaded message
  * made another attempt to debug German client gathering crit information.

+ Version 2.13:
  * attempted to correct error tracking group experience properly
  * added options tab!

+ Version 2.12:
  * corrected data loading errors for non English localizations
  * sort by name now displays class (elite) instead of kill count and header
    displays number of unique creeps fought
  * I might have rested xp there now for different localizations.
  * Added some debugging information about matching crits...  I hope this
    will allow me to get that functioning correctly.
  * cleaned up code for counting trivial kills and what creep killed you
  * added more words to localization file

+ Version 2.11:
  * added French localization
  * updated interface version number
  * updated Death tab background to stone

+ Version 2.10:
  * Updated method of gathering CreepType and CreepFamily
  * Changed font color on General and Death tab so it is easier to read
  * Refined when I store portraits and creep info
  * Added some more checks to counting trivial kills, now watch enter/leave
    combat

+ Version 2.09:
  * Added general tab
  * Added death tab
  * Changed a few German strings
  * Added button to open window in Cosmos Menu for Cosmos users
  * Updated list page to show the Kill Count on several listing, and total
    Kill Count in the headers
  * added ability to delete creeps from the Kill Log

+ Version 2.08:
  * corrected data gathering for German client
  * added data gathering for recording Max hits
  * completed updating data gathering from using static strings to dynamically
    access the information from GlobalStrings.

+ Version 2.07:
  * corrected error causing loaded message to be displayed multiple times.

+ Version 2.06:
  * German localization
  * some support for new data gathering method
    I now use the GlobalStrings to create patterns to use to extract data
    from the combat messages.  So far, I have only updated a new things
    though, I still need to do most of the combat messages which are used to
    fill trivial creeps.
  * new initialization code; because of a Blizzard error with unregister
    event, I have retooled my initialization.  I hope that I will now load
    correctly regardless of what other AddOns do and that I will not prevent
    other AddOns from loading fully.

+ Version 2.05:
  * ability to reclassify creeps (humanoid => murloc, kobold, etc.)
  * added tracking of creep models and sorting by this
    this will allow me to show exactly how many murlocs you killed on the general tab
  * changed information on tooltip; I now show average xp instead of total xp
  * corrected some minor display things:
    - creep highlighting upon first load
    - switching between lists does not mess up highlight color
    - frame on scroll bar now
  * suppress listing creeps without sort values
    when sorting by xp, I do not list creeps that have 0 xp
  * added skull icon to portrait frame
    looks better than blank hole and there is not enough room to fit the level

+ Version 2.04:
  * small bug fixes only; no new features

+ Version 2.03:
  * Added slash command (/killlog or /kl) to open GUI
  * Added sorting options to listing
  * Added level select to view past data
  * I now hide the detail when no creep is selected
  * switching tabs and levels no maintains which headers are collapsed and
    expanded
  * new theory on counting trivial kills implemented

+ Version 2.02:
  * Added GUI for viewing your kill history
  * Incorporated kill/death/experience tracking based upon:
    - current session
    - overall
    - per level (storing five levels worth of data)

+ Version 2.01:
  * Removed warning if my Debug AddOn wasn't loaded.

+ Version 2.0:
  * Records kills and experience from fighting creeps
  * Records information about the creeps you encounter:
    - min level
    - max level
    - type (humanoid, beast, critter, etc.)
    - is pvp
    - is elite
  * updates tooltip with information regarding number of kills and
    experience gained
  * very cool combat log string matching code

+ Version 1.0:
  * long long ago... before stored variables and many combat log message
    events.


---------
Thanks to
---------
Finkle and Xila for helping to beta test new version and for providing
valuable feadback about how to create a friendly user interface.

Dead_Masters and Myth for help with the German translation.  Myth got me
started with a few words, but Dead_Masters did the rest.  All of the help is
greatly appreciated though!  Now Lunox has provided a few more localization
updates!  The most recent translations were actually provided by Lunox.
All of the assistance is greatly appreciated.

Juki for providing the French translation!



----------------
More information
----------------

To check for updates, please visit:
  http://wow.risse.com/

Please let me know if you encounter any errors while using this AddOn!


------
Author
------

Daniel Risse <dan@risse.com>

