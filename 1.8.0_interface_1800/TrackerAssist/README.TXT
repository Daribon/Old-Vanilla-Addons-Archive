TrackerAssist, v1.7
================================================================================
by coder_1024@hotmail.com (Aegath)

Download
================================================================================
http://www.cadrequietus.com/%7Ecq/wowaddons/

Blizzard Forums Discussion Thread
================================================================================
http://forums.worldofwarcraft.com/thread.aspx?FN=wow-interface-customization&T=25526

DESCRIPTION
================================================================================
With TrackerAssist enabled, clicking on a blip on the minimap will cause the
corresponding unit to be targeted and information about the unit will be
printed in the chat window and appear under the minimap.  The information
is color-coded (red=hostile,yellow=neutral,green=friendly) and indicates
level of aggression for NPCs and faction for players (same faction is friendly
while opposing faction is hostile).  If multiple units show up under the mouse,
then clicking multiple times will cycle through them.

For NPCs the information includes the name and level.  For player characters
it includes name, level, race, class, and guild name (if the player is in a
guild).  Note that this AddOn relies on targeting by name.  Since NPCs don't
have unique names, the targeting isn't as reliable for them as it is
for players.

You can also turn chat announce on/off and control whether announcements are
made to the party, guild, or raid channels.  When enabled, track information
will also be sent to the specified channel when you click on the map.

You can also enable the mouseover option which will cause the label under
the minimap to display info just by mousing over the blips.  The info
is not printed to the chat window or sent to your party and the blips
are not targeted until you click the mouse.  Note that, for mouseover,
if there are multiple blips under the mouse, the mouseover will only ever get
the first one.  Also note that when using mouseover, although your current
target (if any) is preserved, the mouseover feature can interrupt your
auto-attacking of an NPC or player.  For example, if you're attacking an
NPC and you have mouseover enabled and you mouse over some other blips, when
you're done you'll still have the original target, but you will have
stopped attacking.

Type /trackerassist (or /ta) to see current settings and available commands
which can be used to modify the behavior of TrackerAssist.  You can enable/
disable the AddOn as a whole, control whether mouseover is enabled, party
announce, etc.

SLASH "/" COMMANDS (trackerassist can be replaced with ta)
================================================================================
NOTE: you may want to create macros which run the below commands to allow you to
toggle things on and off by just clicking a macro button
/trackerassist - shows current option states and list of available commands
/trackerassist enabled - toggles whether the AddOn is enabled
/trackerassist decay- toggles decay of the label under the minimap. when
enabled, it only shows for a brief time then gets cleared.
/trackerassist announce - toggles announcement of track info on the specified
chat channel
/trackerassist channel <chan> - sets the chat channel used to announce track
info (must be party, guild, or raid)
/trackerassist mouseover- toggles whether mouseovers on the minimap result in
the label below the minimap being updates to show info (without having to click
the blips)
/trackerassist npccolor - toggles whether or not NPC text is color-coded based
on the unit reaction to the player

INSTALLATION
================================================================================
Unzip into the Interface\AddOns directory inside the WoW install directory.
When done, you should have the following directory:
<WoW Install Directory>\Interface\AddOns\TrackerAssist

REVISION HISTORY
================================================================================
v1.7, 02-05-2005
--------------------------------------------------------------------------------
- prevented processing when mouse was over the side buttons on the minimap
(clock, mail, tracking, zoom, zone text) which avoids a lot of the unwanted,
"I don't have a target" audible error messages thanks to help from Vlaq
- added an option to toggle NPC color-coding on/off (default is on)
- changed the chat channel announce commands.  you can now toggle chat announce
on/off and then specify which channel to use (party, guild, or raid).

v1.6, 01-29-2005
--------------------------------------------------------------------------------
- checks zoommap visibility to avoid getting events when the frame is hidden,
but other group members are pinging their map thanks to help from Quendari
- cleared up the random text error messages which can occur while using
TrackerAssist due to it attempting to target blips thanks to help from Jebji
- prevented targeting sound while doing mouseover thanks to Jebji and Magenta
- now checks for tooltip visibility before processing click or mouseover
to avoid showing info when there isn't actually a tooltip being shown (but
the tooltip still contains whatever was last seen) thanks to help from Rollback

v1.5, 01-27-2005
--------------------------------------------------------------------------------
- NPC text is now also color-coded to indicate aggressive, neutral, or friendly
- Added / command which can be used to enable/disable TrackerAssist
- fixed the problem when using the zoom map addon thanks to a tip from Quendari
- fixed problem where label under the minimap would prevent mouse look when
mouse was over the area to the left of the text label thanks to a tip from Skrag
- added mouseover which, when enabled, lets you mouse over blips and see their
info without having to click them.  also added a / command to
enable/disable this.  Thanks to Jebji for the tip to avoid the targeting sound
being played as the mouseover stuff is being processed

v1.4, 01-20-2005
--------------------------------------------------------------------------------
- for player targets, guild name (if the player is in a guild) is also displayed
- when / cmds are used to toggle options, the result of the cmds are printed
to the chat window.  this makes it easier to know what the current state is
when you're toggling settings on and off
- the positioning for the label which shows up under the minimap has been
changed to now use a relative position to the MinimapCluster frame as opposed
to just absolute positioning which didn't always seem to work correct or end
up where desired (below the minimap)

v1.3, 01-16-2005
--------------------------------------------------------------------------------
- added slash command to toggle whether or not minimap label decays (defaults
to enabled)
- added slash command to toggle whether or not track info is sent to the party
chat channel if grouped (defaults to enabled)

v1.2, 01-15-2005
--------------------------------------------------------------------------------
- MINIMAP_PING events are now only processed when the mouse is over the minimap
which avoids processing these events as a result of other group members
generating them.  Thanks for Zuban for pointing this out.
- The text which prints to the chat window is now also color-coded like the
text below the minimap.
- If there was already a target when the mouse was clicked and the addon was
unable to select a new target based on the click, the original target is
preserved.  so, the click will only affect the target if it results in a new,
valid target.
- misc code cleanup and commenting
- label under minimap is now wider and right justified so if the text is longer
it'll just take up more space to the left as opposed to going off screen.
- label under minimap now also displays player names in addition to level,
race, and class.
- replaced 3 colored font strings with a single font string which has its color
changed as necessary.  wasn't aware of the SetTextColor() method before which
is why is was the that way.

v1.1, 01-08-2005
--------------------------------------------------------------------------------
- added color-coded text display beneath the minimap making it easier to quickly
click around without having to look down to the chat window each time.

v1.0, 01-06-2005
--------------------------------------------------------------------------------
- initial release

FUTURE ENHANCEMENTS
================================================================================
These are possibilities for future versions
--------------------------------------------------------------------------------
- allow dragging minimap label to a different location and have this remembered
- window to accumulate track info and then send them in bulk (perhaps
selectively) to chat
the label area and/or dynamically size the label to the text
- associate names with sounds/alert text which would get triggered when
those names are processed
