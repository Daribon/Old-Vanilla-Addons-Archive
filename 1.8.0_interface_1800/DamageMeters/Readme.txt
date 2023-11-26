************
DamageMeters - A user-interface modification for World of Warcraft.
************

Author - Patrick Cyr (wwdandelion@yahoo.com) (Dandelion on Whisperwind)
Permissions - Do anything you want with it except take credit for it or make 
	money from it.
Credit To - 
	Zoldan and Chakotay1357 for the German translation.
	Kurty and eXess for the French translation.
	Author(s) of DPSPlus and CombatStats for the parsing technique.
	Authors of Sky (for their assert function).
Thanks To - Rancor, Cyntax, Kixxs, Gileran, Dex, Zurai, Kotor,
	Tagamogi, Sensi, and Pharaoh for help with testing.


************
**Contents**
************
I. Summary
II. How It Works
III. Features
	1) Interface
	2) Bar Counts
	3) Quantities
	4) Players
	5) Reporting
	6) Synchronization
	7) Memory Register
IV. Version History

-------------------------------------------------------------------------------

***********
I. Summary:
***********

DamageMeters keeps track of the damage you and nearby players does
and shows the total damage as meters in a window on the screen.  It makes it
easy to compare the relative damage/healing output of members of a party or 
raid.  At any time you can have the mod output the resulting information as 
text "say"s or to a channel of your choice.


*****************
II. How It Works:
*****************

DM works by analyzing (parsing) text messages of the sort you see in your
"Combat Log" chat window.  An example would be "You hit Onyxia for 10."  This
is the only way a mod can know what damage/healing anyone is doing/taking, 
which is unfortunate because parsing strings isn't terribly fast or easy.

There is a VERY important limitation to DM: a player only receives combat 
text messages for those players that are near him.  The distance varies quite
a bit but it doesn't seem to ever be any higher than 45 yards or so.  You
are not guaranteed to get messages even for members of your own party if they
are not near you.  DM's Synchronization system provides something of a 
work-around for this problem.

Also: it is a common misconception that you need to have messages turned on
in your chat window in order for DM to work.  This is not the case: they are
entirely independent of each other.


**************
III. Features:
**************

-------------
1) Interface:
-------------

DM appears as a frame (window) with a vertical stack of horizontal meters 
(bars).  Each bar represents a value for a single player.  Bars can be sorted
in increasing or decreasing order, though almost always in the latter.  The
bar for the player with the highest value of a given quantity will always be
at full length.  Everyone else's bar will be some shorter length in proportion
to the lead player's value.  In addition to the bar itself, various text 
can be specified to be drawn over each bar, including the player name, the
value, etc.  Moving the mouse over a given person's bar brings up a tooltip
which shows detailed information for a given player.

There are two interfaces for setting program options: menus and console 
commands.  There are two menus.  The main menu is reached by right clicking
on the title of the DM window.  There is also a player menu which is reached
by right clicking on a particular player's bar.  Console commands all start
with /dm and are entered like chat commands.  Use /dmhelp to get a full list.

The window can be moved by click-and-dragging on the title button.  Lastly,
clicking on a player's bar will attempt to target them.


--------------
2) Bar Counts:
--------------

When a player is detected doing something we are interested in, DM 
automatically adds it to its internal list.  The internal list can have at
most 50 entries, at which point it is full and NO new players will be added.
The number of players in the list, though, is independant of the number of 
bars visible on the screen.  Generally, there are two ways you can specify the 
number of bars: 1) as a hard number, or 2) as an up-to number.  The latter
is called the "auto-count" number, and it basically means "show as many bars
as I have player information for, up to this number."

Again, though, it is important to note: the internal player list is NOT
limited by the number of visible bars.


--------------
3) Quantities:
--------------

DM monitors the following quantities:

- Damage Done: The amount of damage done by a player.

- Healing Done: The amount of healing done by a player.

- Damage Taken: The amount of damage taken by a player.

- Healing Taken: The amount of healing taken by a player.

- Idle Time: The amount of time that has passed since the player has last 
done something (either done damage or done healing).  This is useful for 
detecting when someone has gone ninja-afk.

- DPS: The Damage Per Second done by a player.  DM's DPS is averaged over
the entire duration of the current fight.  It is very difficult to determine
the duration a fight in software.  DM defines it like so: the first time 
a monitored person does damage is the start of combat.  When you start 
regenerating health again (pretty much equivalent to when your portrait shows
you leaving combat) signifies the end.  It is NOT precise, it will NOT give
good numbers all the time, but it is pretty good for most instances and is
really only intended to give you a rough idea anyway.


--------------
4) Players:
--------------

DM, by default, monitors yourself, your pet, your party/raid members, 
any nearby friendly players, and miscellaneous things like totems.  There is
a menu option, "Only Monitor Group Members", which tells DM to reject nearby
friendlies and miscellaneous things.  There are valid reasons for having both
options available. For example, in a pvp environment data from friendlys 
can quickly bury your own, and so you'd want to turn that option on.  
However, if you are a soloing shaman you could be interested in how much 
healing your totems are doing, for instance, so you'd want the option off.

Note: there is no easy way to distinguish totems from players, and 
there is no way at all to determine who dropped a particular totem.

Pets present challenges for DM which require some understanding on the users
part for best results.  DM CANNOT distinguish someone else's pet from a random
friendly player.  If "Only Monitor Group Members" is on you will not see
other players's pets.  DM CAN tell if something is YOUR pet.  Your pet is 
always shown.

The "Treat Pet Data As Your Data" option is meant to help people determine what
their total (themselves plus their pets) contributions are.  When this option 
is on, any data that registers for your pet is treated as if it came from
yourself.  If you accumulate data from one or more pets with this option off,
then turn the option on, the pet(s) data will be AUTOMATICALLY merged into your
own.


--------------
5) Reporting.
--------------

DM has a system for reporting its data to other people.  It is accessible 
using the "Report" menu or via the /dmreport command.  The former is quicker,
but the latter is much more flexible.  

The basic syntax for the /dmreport command is:

/dmreport [X[#]] [tell target|channel]

X is the report destination, and can be one of the following:

c - Console: Chat messages that you only can see.  This is the default.
s - Say
p - Party
r - Raid
g - Guild
w - Whisper - For example, /dmreport w dandelion
h - cHannel - Use the channel name, not number: /dmreport h mychannel
f - Frame - Shows results in a frame (window), which you can use to copy the
	text to the clipboard.

# is optional.  If specified, it limits the number of people reported to the
top #.  For example, to output the top 10 to raid, use:

/dmreport r10

As far as doing reports via the menu: it works the same as the console 
command, though of course the Whisper and cHannel report types are unavailable.
Also, note that when using the menu it will only report up to the number of
bars you have visible.  [I only did this to cut down on the amount of spam
it was generating in my raids, heh.]


-------------------
6) Synchronization:
-------------------

The Sync system is an attempt to work around the fundamental problem of 
people not receiving messages from people who are too far away from them.
It was made with raid groups in mind, and so this discussion will focus on
how raid groups can best use it.

Here's how it works: in principle, the only source of errors in DM are from
someone being outside of your range and so you miss their messages.  For 
example, a raid that is attacking a mob normally has a melee guys close to 
the mob and casters standing back.  A caster is very likely to miss messages
from melee guys, and a melee guy is very likely to miss messages from a caster.
However, if you took the melee guys' numbers for the melee players, and the
caster's numbers for the other casters, you'd likely have a very good set of
data.

Thats basically what synchronizing does.  The actual mechanism is very simple:
everyone transmits all their numbers, and then people just take whatever
numbers are HIGHEST.  In theory, each player has perfect data for himself, so
if everyone was involved in the sync'ing you would have a perfect picture.
In practice, thats probably overkill...a handful of people who play different
positions should be fine--maybe a healer, a melee'er, and a hunter.

Here is how a raid would go about setting up for sync:

1) Everyone joins an agreed upon chat channel, for instance "oursync".  This
channel will receive a pretty large amount of messages so you'll probably want
to set your chatwindow to not show them.
2) Everyone tells DM what that channel is: "/dmsyncchan oursync".
3) Just before getting started, it is wise for one person to "/dmsyncclear", 
which clears everyone's data.
4) Play!
5) When you want to synchronize data, call "/dmsync".  This will both send
your information to other players and request that they transmit theirs as
well.  This generates quite a bit of spam on the syncchan, and so it is best 
if done outside of combat.

In addition to the above steps, I'd recommend that everyone doing sync'ing 
use the following settings:

* "Only Monitor Group Members" ON: Totems, pets, and such can make the 
internal tables reach their limit, potentially preventing actual raid members 
from making the tables.

* "Treat Pet Data As Your Data" ON: If you are a pet using class, this is 
the best (only) way to make sure your total contribution is counted.


-------------------
7) Memory Register:
-------------------

DamageMeters has a second table of information, the Memory Register.  It 
functions pretty much exactly like a memory button on a calculator.  Its
purpose is to have a place for you to save a set of information (for example,
the data from your last raid).

There is a menu option, "Accumulate Data", which makes it so whenever data
is added to the main table (ie. when it appears in your bars), it is also
added to the MR.  One possible use of this is in conjunction with the 
"Reset Data When Combat Starts" option.  If both options were on, for example,
you could do an instance run and see what the data is for each fight 
individually, and then at the end look at the memory data to see what the 
totals are.


********************
IV. Version History:
********************

2.3.0 - 6-7-05 : SYNC VERSION CHANGED: This version will not
be able to sync with older versions. Added alphabetical sort option.  
Fixed major bug: all non-melee damage done to friendly characters 
was being ignored.  Hit/crit counts now shown for all main 
quantities, not just damage.  Added "Show Total" menu option.  Fixed bug
where invisible bars could still be clicked and would block mouse messages
intended for ui elements beneath them.  Added "% of Leader" text option.

2.2.0 - 6-3-05 : Added /dmtotal, which displays the current quantity's 
total in a small button beneath the frames.  Reports now list a total
at the bottom.  Added keybinding for /dmswap.  Added /dmsyncmsg for sending
msgs to other people in the same syncchan (assuming that everyone will have
that channel's messages hidden).  Reordered Report menu a little.  Added
/dmmemclear and menu option.  Fixed bug with all spells and effects with 
"'s" in the name (Ramstein's Lighting Bolts, etc).  Created a new Position
menu which contains a few old position options and two new ones; "Resize Up"
and "Resize Left".  These determine the way the window moves when it changes
size.  Added /dmshowmax and keybinding for it.  

2.1.0 - 5-30-05 : Synchronization data now has a version number (2), meaning
it will no longer be possible to synchronize with people with older versions.
Improved "total" reports: now shows rank of each person for each quantity.
Total reports also show who contributed to the report (if sync'ing was involved).
Fixed parsing for party/friendly players using Julie's Dagger.  Group-only option
now defaults on.  Added text cycling and quantity cycling menu options.  Added
/dmversion.  /dmsyncchan will now attempt to automatically join the channel you
specify.  Added a "Help" option to the Report menu. Added "Accumulate Data" 
toggle to the memory menu.

2.0.0 - 5-21-05 : Text options now settable via the menu.  Fixed bug 
when reporting idle time.  The colors associated with various quantities 
are now settable via the "Visible Quantities" menu.  Reordered the quantities
a little, thus requiring a version change (so once you install this
any saved data will be wiped).  Added key binding to cycle quantity 
backwards.  Added DPS quantity. /dmsyncclear now clears your own meters 
as well.  LOCALIZED FOR FRENCH AND GERMAN VERSIONS.  Renamed /dmsyncreport
to /dmsyncsend (the way it was listed in the help).  Syncing now 
works while paused.  Reports now automatically omit characters with 0
of the given quantity.  Fixed huge bug in sync'ing--pretty much everything
but damage done was being computed wrong.  Idle time is now only reset 
by "active" values (damage done, healing done).  Updated the help file to
be more...er, helpful.  Added "Frame" report option.  Fixed bug with 
pet damage being added to player multiple times during syncs.  Added
key binding to open report frame.  

1.1.0 - 5-6-05 : While help was in for /dmpause before, it is actually 
implemented now.  Added /dmlockpos and menu option for locking the 
position of the meters.  Paused and hidden states now save. Added 
/dmgrouponly and menu option for making it so anyone who isn't yourself,
your pet, or a party or raid member is ignored. Added /dmsyncclear.
Damage done to pets now tracked. Spell damage done to self and party 
now tracked. Added /dmaddpettoplayer command.  Fixed display bug when 
there are an odd number of bars over 20.

1.0.1 - 4-22-05 : Bug fixes:  Saved tables weren't having their time 
reset, could pulse continuously after load.  Character classes weren't being
found for raid/party members.

1.0.0 - 4-17-05 : All known bugs fixed.  Version added: if saved data is of 
a different version the data will be cleared.

0.9.9 - 4-15-05 : Added tracking of healing and damaged received.  Improved calculation
of crit percentage.  Removed dmsynclear, dmsyncleader, dmysncinfo.  Added
dmsyncsend.  dmsync now does both a send and a receive.

0.9.8 - 4-13-05 :  dmpop command no longer clears the list.  Added dmlock.  
Added dmpause.  Added dmsyncclear, dmsyncleader, dmsyncinfo.  Both the regular
and memory data lists are now persistant.  Title button no longer visible 
when interface is hidden with alt-z.

0.9.7 - 4-11-05 : Added dmsync, dmsyncchan, dmsyncrequest commands. Added 
dmpop command.  Completed fixing up the code in preparation to be 
localized, though no localization has been done yet.  Hiding the window no
longer leaves the title button visible.  Added a few key bindings.  Added
rank text option.

0.9.6 : Forgot...oops.

0.9.5 - 4-08-05 : Removed dmfilter from the help list.  Fixed bug which was incorrectly
making friendly characters appear as though they were in your party.  Added
/dmvisinparty, /dmautocount, /dmlistbanned, and /dmclearbanned commands.
Added drop down menus.  Added title button for easy moving and clicking on.
Added ability to ban damage sources.

0.9.4 - 4-02-05 : Removed /dmfilter, as it seems to be unlikely to ever work as 
intended.  Window background now colored to reflect quantity being shown.  Added
g dmreport option for reporting to guild chat.  Improved time text display.
Believe I am catching all healing messages now, though in order to do so I am
getting some enemy heals too.

0.9.3 - 4-01-05 : Added h dmreport option for reporting to a chat channel.
Reporting now reports on the current quantity (damage, healing, etc).

0.9.2 - 3-31-05 : Separated functionality of dmsort into dmsort and dmquant. 
Healing done is now tracked, just like damage dealt. Fixed bug where melee
damage done by non-party members was being lost.  Added detection of damage
shields (thorns, etc).

0.9.1 - 3-30-05 : Removed Cosmos dependency.  (Was using their Print function.)

0.9.0 - 3-30-05 : Released to guild for testing.

