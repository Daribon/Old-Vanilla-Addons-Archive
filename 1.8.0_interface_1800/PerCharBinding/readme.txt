PerCharBinding
by Aalny
version 1.1.3

Download Location:
http://wow.dvolve.net/dropbox/wow/PerCharBinding_1.1.3.zip
Mirrors:
http://www.wowinterface.com/list.php?skinnerid=14585
http://www.wowguru.com/ui/author/aalnydara/
http://www.curse-gaming.com/mod.php?authorid=1215

---------------------------------------------------------------------------
Description

This is a simple addon whose only job is to make it so that key and mouse
bindings are a per character setting instead of the Blizzard default of
per account.  The intended audience is anyone who plays multiple characters
from the same account and wants to use different key bindings depending on
which character they play. No configuration is required. Saving and loading 
the binding profiles happens automatically when you switch characters.

The base functionality provided is very similar to Tale/Bima's ClassBinding
addon which I personally used for a long time before it became unstable 
with the 1.5 WoW patch.  It appears Bima has either been too busy to fix it
or was never able to reproduce the problem.  So I decided to re-write the 
functionality I used from scratch.

NOTE TO CLASSBINDING USERS:
I have included a command to import your old per-character ClassBinding sets.
If you want to import those settings, DON'T DELETE the ClassBinding addon 
until you're done with these instructions.
- Make sure both PerCharBinding and ClassBinding are installed and enabled.
- Login with any character and type the command "/pcb import"
- You should see a list of profiles that were imported from ClassBinding.
- If all the profiles were imported successfully, you can logout and delete
  the ClassBinding addon.


---------------------------------------------------------------------------
Known Issues

* The import command currently only imports character-specific binding sets
  from ClassBinding.  If there is enough demand, I will add support for
  importing class sets as well.  If you plan on waiting for this support,
  don't delete the ClassBinding addon because it will delete your old 
  settings as well.  Instead, just leave it disabled.


---------------------------------------------------------------------------
History

1.1.3
* Updated toc for 1.7.0 patch

1.1.2
* Fixed nil error trying to import from ClassBinding
* Added 'verbose' command that toggles whether binding update confirmations
  are displayed. The default is off.  /nod NiGHTsC
  
1.1.1
* Removed confirmation spam when updating key bindings.  You're welcome, Mord.

1.1
* Fixed a bug in loading profiles that was preventing the bindings from
  being saved properly.
* Added list command which will display an alphabetical list of all saved 
  binding profiles.
* Added save command which will save the current bindings to a profile name
  you specify.
* Added load command which will load and apply the bindings from the profile
  name you specify.
* Added delete command which will delete the saved profile you specify.

1.0
* Initial version.
* Includes import command for importing per-character settings from 
  ClassBinding
