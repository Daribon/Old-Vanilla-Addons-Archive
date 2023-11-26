
NotesUNeed v1.02 - Telic of Dragonblight (EU)
---------------------------------------------




Changes in v1.02 from v1.01
---------------------------

- Fixed the error being reported when logging in to a character in different Realms



Changes in v1.01 from v1.0
--------------------------

- Very minor change to display a border around the Microbuttons when the mouse pointer is over the frame. Hopefully should clear up any issues new users have with moving the panel, as it is the border which needs to be clicked to move the buttons, and this border was not previously visible.







General Description
-------------------

Searchable, feature rich Notes database allowing the player to keep notes on Friends, Ignores, Guild Mates, or any player you party with or target, whether they belong to your Faction or the Opposing Faction, or just General notes on any subject. A Very useful Search feature allowing the player to browse all notes, or search for Class, Profession, General notes, or for any Free Text phrase !  So if you can't remember who it was who needed that Pristine Black Diamond, just search for Diamond and you will find the contact :)  Or if you are a Guild Master, now you can list all those members who are Enchanters that have +15 agility chant, or track which characters are alts of which members. Notes can be automatically maintained on Friends and Ignores and shared amongst your alts, allowing you to import your friends list to your brand new alt :)  A note for the character you play is also automatically generated, and keeps track of when and where you level up :)

The Microbuttons panel is currently just above the Player portrait frame by Default.

PLEASE NOTE that you can't drag the Microbuttons if you have actually clicked on one of the buttons - they need to be dragged by the edge. There is a small transparent border surrounding the buttons and you need to click this to drag the frame, not the buttons themselves. So get your mouse pointer as close to the buttons as possible without actually highlighting any, then click and drag.


Key Features
------------

- New 'Edit' buttons on the Friend, Ignore, and Guild panels allowing the creation/editing of a note for that Contact

- A new movable and discrete panel of 4 buttons allowing immediate access via the mouse to the 
        1. NotesUNeed Options
        2. Browse all notes
        3. Create/Edit Contact Note, depending on who you have targetted
        4. Create new General Note
        
- Create or Edit notes via Slash Commands

- Browse All notes, or Search by Class, Profession, General notes only, or search for any free text. Searches can be initiated from the NotesUNeed Options frame.

- When browsing, notes are sorted by your current player's Faction, then the opposing Faction, then General notes. Symbols clearly display whether a note is an Alliance Contact, a Horde Contact, or a General note. Notes are kept at the Realm level and all are accessable by any alt of either faction on that Realm.

- Drop down boxes on the NotesUNeed Contact note frame reduce the amount of typing, when entering Class, Profession, Rank, etc. NotesUNeed will also try to automatically fill in as much information as possible for Contacts that are online, noting Race, Class, Sex, PvP Rank, Guild and Guild Rank ( Distance from target will reduce the amount of inormation that can be gathered )

- Use the "Target Info" and "Who Info" buttons to manually request a refresh of Race, Class, Sex, PvP Rank, Guild and Guild Rank. Again, this functionality is restricted by the underlying WoW functionality, and distance to target will reduce the amount of information.

- Allow NotesUNeed to automatically maintain notes on Friends and Ignores, and then use the NotesUNeed database to import Friends and Ignores to other alts. 

- Allow NotesUNeed to automatically delete notes when Friends/Ignores are removed. ( Contact Notes will only be auto-deleted when that player is no longer a Friend/Ignore of ANY of your alts, AND the note was created automatically by NotesUNeed; So any note you manually Save will never be deleted automatically, as it is assumed that you will have saved that note for a different reason than simply tracking Friends/Ignores )

- Default headings exist in the Contact Note frame for Guild, Guild Rank, Real Name, e-mail, and Web address. However, these are user definable headings, and you can change these to be phone number rather than web address for example, or whatever you feel is more suitable for your needs; The Default headings can be changed for all your Contact notes, or you can change the headings for an individual Note if need be.  Please note that if you change the Guild and Guild Rank headings then the underlying details will NOT be automatically filled in by NotesUNeed.

- NotesUNeed will automatically generate a note for your character and will automatically record when and where you level up

- Add Timestamps and Location to notes (Location is always YOUR location.)




Slash Commands
--------------

/nun   : Toggles the NotesUNeed Options window

/nun -h   : Displays this list of Slash commands

/nun <note title>   : Will attempt the following :
  1. Fetch a saved Contact note with that name
  2. Fetch a saved General note with that title
  3. Create a new Contact note if a player of that name is in your party/raid group or is within target range
  4. Toggles the NotesUNeed Options window

/nun -t	  : Fetches the saved Contact note for the current target, or creates a new one, or shows your own characters note if no valid target

/nun -g	  : Creates a new General Note, untitled.

/nun -g <note title>   : Fetches the existing General note with that title, or Creates a new General note with that title.





Notes & Troubleshooting
-----------------------

1. The "Who Info" button needs to be clicked at least twice to refresh the Race and Class on the Contact note window. This seems to be due to the way the /who command works in WoW and the amount of time needed to refresh the who list. Again, if enough people say it is a big problem, I might look at trying to ensure only 1 click of "Who Info" is required, but this can only fetch Race and Class, and I didn't think clicking the button until the data refreshes was too big a problem. Note that as with the "Target Info" button, the player needs to be on line to gather any useful data. Also, just like the normal /who command, there is a period of time after clicking the "Who Info" button a couple of times for one character, before it will respond again for another character. I can't do anything about the delay between /who commands as this is a characteristic of the WoW API, just try typing /who <character name> multiple times to see what I mean. 

2. When importing players in to your Ignore list from the NotesUNeed database, note that a character needs to be on line to be succesfully ignored. This is a restriction of the WoW API.  Every time you log on, NotesUNeed will make another attempt to ignore any Contacts which it failed to ignore previously, but it will only attempt this once, as periodic background attempts to ignore these players would only generate puzzling "Player not found" messages in the chat window.

3. The default position for the new panel of 4 NotesUNeed microbuttons is just above the player portrait. This panel can be moved by the user and will remember its location between sessions. If you do move this panel and then subsequently increase the UI scale, this panel may disappear off screen. To get it back simply reduce the UI scale again, move the panel toward the center or topleft of the screen, set the UI scale to what you need again, and then position the panel where you need it. Alternatively log on without the mod, then relog with the mod active and it should reset to the default position.  As the risk of this happening will affect so few, and it can be so easily fixed, I have not attempted to code a better movable window, but if enough people say it is a big issue for some reason, then I will consider altering the code :) I haven't found any other problems when testing different scales and resolutions.

4. Developer / Compatibility Note : 4 WoW functions have been re-written in this mod, as I simply could not get standard function hooking to work with them. Even so, I have found NO compatibility issues with other mods, including Cosmos, SocialNotes, NotePad, Friend's Notes.  I wanted to create a stand alone mod, as I myself am not fond of using a large number of mods, or mod packages, and I have therefore not attempted to use Sea, or any other 'standard' library to hook the functions. I would appreciate any help or suggestions people might have for hooking these functions ( contact e-mail below ) : FriendsFrameFriendButton_OnClick(), FriendsFrameIgnoreButton_OnClick(), FriendsFrameGuildPlayerStatusButton_OnClick(), and FriendsFrameGuildStatusButton_OnClick().







Contact for Feedback & Bug Reports
----------------------------------

telic@hotmail.co.uk



