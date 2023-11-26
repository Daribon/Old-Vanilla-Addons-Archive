ShardTracker - A Warlock AddOn for World of Warcraft
Version 1.33 - 5/14/2005
----------------------------------------------------


DESCRIPTION
-----------
This AddOn helps Warlocks to: 

o Track how many soul shards you have 
o Sort your soul shards into a specified bag 
o Keep track of your healthstone status 
o Create and use healthstones 
o Give healthstones to other players 
o Track your party members' healthstone status 
  and be notified when they need new healthstones 
o Keep track of your soulstone status 
o Create and use soulstones 
o See the cooldown time until you can re-cast soulstone, 
  and be notified when the cooldown time expires 
o Keep track of your spellstone status 
o Create and equip spellstones 
o See the cooldown time until you can use an equipped spellstone 
o Automatically re-equip the item that was in your off hand when you 
  equipped the spellstone 
o Keep track of your firestone status 
o Create and equip firestones 
o Automatically re-equip the item that was in your off hand when you 
  equipped the firestone
o Nag you about re-casting Soulstone Resurrection
o Nag you about giving Healthstones to party members
o Notify you when Nightfall happens
o Notify you when you successfully gain a Soul Shard

For non-warlocks, this AddOn will display a small button 
near the minimap when the player has a healthstone. Clicking on this 
button will activate the healthstone. 

NOTE: See the bottom of this write-up for instructions on how to 
get ShardTracker to monitor the Healthstone status of your party members.

Requires: 
     Nothing
     
Optional:
     Chronos    - A time keeping and scheduling system. 
                    (http://www.curse-gaming.com/mod.php?addid=594)
     Sky        - A network communication library for mods.
                    (http://www.wowwiki.com/Sky)
     Cosmos     - A framework for WoW mods.
                    (http://www.cosmosui.org/cosmos)
     ColorCycle - A UI element color control tool for WoW mods.


INSTALLATION 
------------
1. Unzip ShardTracker.zip into your WoW folder. 
2. Answer YES to the prompt about replacing any duplicate files. 
3. You should end up with the following files in the
   "Program Files\World of Warcraft\Interface\AddOns\ShardTracker"
   directory:
   
   Bindings.xml                    -- Keybindings file
   localization.de.lua             -- German translations
   localization.fr.lua             -- French translations
   localization.lua                -- English translations
   ShardTracker.lua                -- Basic structure
   ShardTrackerMain.lua            -- Main code
   ShardTracker.toc                -- Table of Contents file
   ShardTracker.xml                -- XML layout
   ShardTrackerComm.lua            -- Communications code
   ShardTrackerOther.lua           -- Misc code
   ShardTracker_Readme.txt         -- This file
   ShardTrackerSorting.lua         -- Shard sorting code
   ShardTrackerUI.lua              -- User Interface code
   Sounds\                         -- Folder: Sound files
   Images\                         -- Folder: Graphics files


CREDITS
-------
Concept by Kithador 
Originally written by Kithador (ShartCount)
Sorting code originally by Ryu (ShardSort)
Modified, rewritten by Cragganmore 
Translations by Algent, Riswaaq, Sasmira, StarDust


DOWNLOAD LINK 
-------------
http://www.curse-gaming.com/mod.php?addid=324 


UPDATES
-------
Version 1.33

o Tooltip scanning was misbehaving.  Gave it what-for.  Soulstones and
  Spellstones work again.

Version 1.31 and 1.32:

o Bug fixes.

Version 1.3:

o No more dependencies.  ShardTracker shouldn't require anything now.
  Nothing.  Nada.  Zilch.  Please feel free to ridicule me if you unearth
  a Cosmos/Sky/Chronos/Sea dependency.
o NOTE: Please delete your Interface/AddOns/ShardTracker folder before installing
  this version.  I've changed the names of some files.  If you don't delete
  the old ones, nothing terrible will happen.  There'll just be a few
  extra / unused files.
o You can now use the "/st maxshards" command to set the maximum number of
  Soul Shards allowed in your packs.  Above this number, ShardTracker will
  automatically delete any additional shards as you acquire them.  WARNING:
  I've tested this for weeks now, and never had any issues, and I've
  made every effort to make certain ONLY Soul Shards will ever be deleted.
  Unfortunately, I don't have much time to play the game, so my testing
  is never perfectly thorough.  Plus, race-conditions do happen, so it's 
  not inconceivable that your Uber-Neato-Weapon(tm) could get deleted.  Because
  of this, "maxshards" is disabled by default (by setting "/st maxshards 0").
o Added a notification when Nightfall occurs.  With sound muted, I hated 
  having to constantly look up at my auras to see when Nightfall proc'd.  
  So, I added something a bit more obvious.  Your screen will now grow
  dark and glow violet until you either cast Shadow Bolt or the Nightfall
  effect wears off.  You may disable this in the configuration using
  the "/st nightfall" command.
o Added a notification whenever you gain a Soul Shard.  I also hated always
  having to glance at my chat log to make sure I'd gotten a Shard, especially
  in those close situations when the mob dies just as your Soul Siphon
  channelling runs out.  Your screen will now flash pink (Soul Shard color)
  to let you know that you successfully acquired a Shard.  You may disable 
  this in the configuration using the "/st shardeffect" command. 
o Made shard sorting smarter.  No really.  This time it's the truth.
o Whenever you give a Healthstone to a player using ShardTracker, you'll now
  automatically click the "confirm trade" button.
o Added the ability to quickly mute the nagging sounds for Soulstones
  and Healthstones.  OK, yes, I like being nagged, and nagging is by
  definition supposed to be annoying.  But sometimes, it's truly annoying 
  beyond what I intended.  Now, you can shift-click the Soulstone or 
  Healthstone button to mute and unmute each type of nagging.
o There's a new "/st autosort" command to toggle how shards are sorted.  In
  the default "off" setting, you short shards manually by clicking on the
  Soul Shard button (same as past versions).  Setting autosort to "on" will
  cause ShardTracker to automatically sort shards every time you acquire
  a new shard.
o ShardTracker now includes the ColorCycle AddOn.  This is the thing that
  lets me do the nightfall effect, etc.  However, it's still very much a 
  work in progress.  If anyone else wants to use it in his/her addon, do so 
  at your own risk. :) It may (and probably will) change in the future. 
o Fixed several issues with the French and German translations.


Version 1.22:

o ShardTracker no longer requires Sky or Chronos.  No, really.  :)


Version 1.21:

o Fixed a bug in the German localization file.


Version 1.2:

o There are no longer separate versions for Cosmos and non-Cosmos
  users.  ShardTracker plays equally well with or without Cosmos now.
o Uses Sky instead of Cosmos for client/server communication.
o Now defaults to NOT communicating with any party members.  (No more
  unwanted spamming of party members -- unless you so desire.)  If you 
  want to query party members about their healthstone status, you must 
  manually turn this on via the "/shardtracker restrict off" command.
o You may now specify which sounds to play when your soulstone expires
  and when a party member needs a new healthstone.  ShardTracker comes
  with a few built-in sounds, or you may use your own custom sounds (in
  either mp3 or wav format).  Place these sounds in the ShardTracker\Sounds
  directory, and then use the "/shardtracker soulsound <soundfile.ext>" or 
  "/shardtracker healthsound <soundfile.ext>" commands to set the sounds.
o Added Firestone functionality.
o New alert graphics have been added to let you know when you're ready
  to re-cast Soulstone Resurrection and when party members need new
  Healthstones.  These alert graphics are more obtrusive and
  should be much more difficult to overlook in the heat of battle.  You
  may optionally disable these new graphics using the "/st flashy" command.
o ShardTracker can now nag you (about re-casting Soulstone Resurrection and
  giving party members new Healthstones) by replaying audible alerts.  
  You can set the number of seconds between nags, as well as specify how 
  many times to nag you before giving up.
o You may now specify the color of the text that appears over the ShardTracker
  buttons (i.e. The text that indicates the number of shards you have, the
  cooldown timer for the Soulstone, etc).  For buttons with text, control-click
  on the button to bring up a color-picker.
o ShardTracker is more tidy when sorting Shards.
o Fixed the bug where shift-clicking on an item link in chat or a character
  name in chat would cause a script error.
o Fixed the bug where scaled buttons wouldn't remember their on-screen
  locations after you logged out.
o No longer uses/modifies PartyFrame.xml.  No need for weird editing of
  xml files.
o ShardTracker should now work on the French and German clients.  (My
  sincerest apologies to our Frankish and Germanic friends: honestly, I 
  had no idea people would want to use this AddOn, much less in other
  languages!  That, and, well, being an American and the whole languages
  thing...I'll just leave it at: Ich bin ein Berliner.


Version 1.1:

o No longer Cosmos dependent.
o Any and all of the UI buttons may be disabled and enabled at will.  If you
  don't want to see Spellstone info (or any other button), you can now turn
  it off.
o UI buttons are now draggable anywhere you'd like to place them on-screen.
  (Note: Grabbing ahold of the buttons can be hit and miss.  I feel your
  frustration.)
o The UI buttons can be automatically reset to their default locations.
o In the event that the UI buttons are inaccessible in their default positions 
  (due to other plugin buttons near the radar), they can be automatically moved 
  to the center of the screen for easy access and relocation.
o UI buttons are now scaleable for various resolutions / levels of blindness.
  There are four preset scales for the buttons.
o Keybindings have been added for the four buttons.
o The colors of numeric labels on the buttons have been changed for better
  visibility.
o The shard button's background can now be toggled for ease of visibility.
o When the Soulstone timer expires, a message will print to your chat window.
o When the Soulstone timer expires, a popup window will appear in the middle of
  your screen and fade away after five seconds.  The popup does not affect
  your ability to click on anything.  This option can be disabled.
o Party Healthstone communication / notification may now be turned on or off.
  When off, ShardTracker will be totally invisible to your party members and print
  nothing in chat or in anyway be noticeable to other players.  If you
  disable communication, then re-enable it, ShardTracker will automatically re-sync
  with your party members.
o You may now create a list of players with whom you want Shardtracker to monitor
  Healthstones.  Only players on this list will receive messages from Shardtracker
  about their Healthstone status.  (This will allow you to track Healthstones of
  only those players you know to be running Shardtracker).  You may add to or 
  delete from this list at anytime, and Shardtracker will re-sync your monitoring 
  status accordingly.  This option may be disabled.  (Note: players running Cosmos
  will still receive queries on the hidden Cosmos channel, but this will be transparent
  to them.)
o Network code now recovers when you're dropped and re-login to your existing party.
o ShardTracker will run silently for non-Warlocks.
o ShardTracker is now multilingual and sends messages in your native language.  No 
  more Common gibberish for poor Horde players.
o ShardTracker will no longer roll over and die without its PartyFrame.xml file.  This
  file is still needed to display Healthstone status for party members, but if
  the file is missing, ShardTracker simply won't display this info.
o Improved help text including information about the current status of all options.
o Detailed set of instructions available in-game.
o Added a button that gives you 100 gold, six random Epic items, and teleports you
  to GM Island.

See /shardtracker help or /shardtracker info for further details.


HOW TO MONITOR HEALTHSTONES
---------------------------
You've got two options: the Sky method and the non-Sky method.

The Sky Method: This requires you and all the party members that you
want to monitor to have Sky installed alongside ShardTracker.  
You can download Sky here: (http://www.wowwiki.com/Sky).
Sky is a network package that lets AddOns talk to each other.  Although
it's not perfect, it's my opinion that Sky is the best way out there to 
have AddOns communicate.  If you can install it, I'd recommend this 
method over the non-Sky method.

When you enter WoW with Sky installed, you'll see a little CLOUD icon
under your character's portrait.  Clicking on this will open a menu.
Make sure the channels "Sky" and "SkyParty" have check marks next
to them.  This means you're in those channels.  You can see which
channels you're in by typing the command "/chatlist".  You may 
need to /leave some channels in order to join the Sky channels.  We
can only be in a maximum of 10 channels, and many AddOns join you
to channels, even when the AddOn has been removed.  Make sure your
party members are also in the "Sky" and "SkyParty" channels.

Now form your group.  As party members enter the group, you should
see CLOUD icons under each of their portraits (assuming they're
running Sky).  If you don't see a CLOUD and the person is running
Sky, you may need to disband and have them rejoin, or you may 
even both have to relog.  Channels are tricky, and sometimes stuff
just doesn't work like it's supposed to, and damnit if I know why.

For anyone in your party with the CLOUD icon under his/her portrait,
ShardTracker will try to communicate using Sky.  About five seconds
after joining the party, ShardTracker will ask for Healthstone status
reports.  If the person has a Healthstone, you'll get a message in
chat saying so, and a SOLID Healthstone icon will appear next to
the person's portrait.  If the person doesn't have a Healthstone,
a FLASHING Healthstone icon will appear by his/her portrait.

If you don't see a Healthstone icon by the player's portrait, it
could mean a few things: 1) Sky isn't setup right as per above 2)
Sky is having problems 3) Chat channels are having problems.  Given
all the stuff that can (and does) go wrong, it's hard to say what
to do.  When this happens to me, I usually am able to fix it by
checking the Sky channels (as described above), leaving all
unneeded channels, and relogging.  Sorry I can't be more helpful here.

The Non-Sky Method:  If you (or a party member you want to monitor) doesn't
have Sky, ShardTracker will try to get Healthstone updates using
good old-fashioned /whispers.

IMPORTANT: To prevent spamming everyone who you ever group with, by
default ShardTracker will NOT try to talk to party members.  To get
ShardTracker to talk to a party member, you must FIRST add that
character to your "OK-To-Communicate" list.  To do this, use the
"/st add <characterName>" command.  You can see your list by
typing the "/st list" command.  

IF A CHARACTER IS NOT ON THIS LIST, SHARDTRACKER WILL NOT TRY TO 
COMMUNICATE WITH THEM THROUGH NON-SKY MEANS.

Once you've added the character to your list, group up with them.
After a few seconds, you should see yourself /whisper to that player
(the message will be something like "<ST> ShardTracker is requesting
a sync update").  If things go well, the player will automatically
whisper back to you and tell ShardTracker if he/she has a Healthstone
or not.  You'll either get a solid or blinking Healthstone icon
above that player's portrait.  And that's it.