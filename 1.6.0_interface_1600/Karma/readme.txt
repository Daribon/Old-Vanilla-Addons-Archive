------------------------------------------------------------------------
--
--	KARMA v0.7.1
--	Design/Implementation: Sean Hummel
--  Testing/GUI Slave	 : James Green
--
------------------------------------------------------------------------

* What is Karma?

Karma is a tool for helping an person playing World of Warcraft, put
words, numbers, and feelings to all other characters they meet and 
play with. 

It allows for the tracking of group members, to be remembered, and
tracks the following about each player automatically:

	- Amount of Experience gained with them.
	- Amount of Time played with them.
	- Quests which they have helped you with.
	- Zones you gained experience in with certain players.
	
As well as letting the player also add:

	- Karmatic setting (hence the name), a bar which represents how
		the player feels about other characters.  Green is good,
		blue is neutral,  red is unliked.   
	
	- Notes about the player.
	  
* New/changed in V0.7.1:
	* Bug Fixes, no more PopBar conflicts.
	* no more nil value errors.

* New/changed in V0.7:
	* Bug fixes!  All those nasty NIL comparison errors, should be gone now.
	
* New/changed in V0.6:

	* Player information is now shown when you mouse over names of players
	  in the Karma character list.
	* Zones you earn experience in with other players automatically noted.
	* You can now give karma to anyone you meet, using the player menu.
	* the addmember/ignore command will now do a /who verification of the player.
	  This means that names not found will not be added.  
	* Color scale, when coloring your Karma player list, has been changed for
	  experience and time modes, to be from dark blue to bright green.  Karma
	  colors still remain the same however.
	* Scale of figuring the percentages for time/experience is now based upon
	  the range of all members in your memberlist. Otherwise over time the
	  players you played with, were fading to red (not played with much,)
	  over time.

* Fixed in V0.6:
	*	Lots of dumb little bugs.  
	*	Bugs where changes in your faction temporarily would cause Karma 
		to spew error codes. (Say a priest mind control's you, or a mob
		uses a curse which converts you into another creature and you then
		attack your friends.)
	* 	Fixed an annoying bug causing an error box to popup, whenever you
		were being invited to a guild or group, or being challenged to duel.
		This would stop you from being invited as well.
	* 	GUI bugs
	
* How do I use it?
 
 There are many ways to use Karma.  I use it help me track
 those players I most often play with, as well as keep notes
 about their real life, and what favors they have done for 
 me.    I use the Karma bar to denote when people do good
 things, which make them stand out in my mind, as well as
 also note when people are outright mean and abusive, to me
 or others.  Or just plain do something stupid.

 Karma is also useful as a means of a global friends/ignore list. 
 It remembers people, whom you've met, regardless of which 
 character you choose play (per server).   It will also you allow 
 you to ignore people (on a global basis,) regardless of which
 character you are playing on.  Trades/Invites/Duels will all
 be automatically canceled and or ignored for you, as well as
 the normal chat ignore feature.
 
* How do I give out Karma?

Assuming the default settings for Karma, when you first group with
a character, they are automatically added to your Karma list.
When they are first added, everyone is gives Neutral Karma, (blue,)
as you add and take karma this will change color.    (Karma by
default is used to colorize the name of each player in your
group's party names, and will always be used to colorize the
banner behind their name when they are the currently selected target.)

Don't expect immediate changes in the color (although they are there,)
the color changes subtley as you adjust the Karma setting.   After a 
character has grouped with you, you may add/subtract Karma from them
regardless of whether or not they are still grouped with you.
It can be done current in two ways. First two entries have been
added to each party member's menu, "Karma ++" and "Karma --" which
allow you to just right click and give or take Karma.    Or you may
open the Karma window, and select the character, and use arrows on either
end of the Karma bar to adjust their Karma.

Remember Karma is a subtle thing, which is why it making small adjustments
won't reflect a large color change.  This is to give people their own
person scale on which to rate other people that they play with. There isn't
any imposed scale, or imposed reasons for giving or taking Karma.  That is
entirely up to each person.

However because of the request to add an ignore feature, I made it possible
to immediately add someone to the list, as someone to ignore.  This is 
possible using the "/karma addignore <name>" command.  (Make sure to spell
and case their name correctly.)   So that you can ignore anyone you see
without grouping with them first.
Ignore will also kick in when a character's Karma falls below a certain
threshold (this is settable,) by default it is 10% of the Karma bar. (Deep
deep red.)
 
* What's next?

Probably bug fixes, and more optimizing, currently I've tested Karma with
as many as 2000 people in the list of characters, and it works well. But
your mileage may vary depending upon machine speed, and the number of people
you group with.   If you don't group with your whole server then you'll
probably be fine.  Even on slow machines even having 250 or so people,
is handled very well.

New features will be coming in the next couple revisions, nothing major, 
just some simple things.  To make for a solid package.

* Commands:

	*/karma addmember <name>
		This adds the character of <name> to your list, this person
		then starts out with the normal karma setting. However the name 
		is subject to verification using the who command.  So the character
		must be logged on.
	
	*/karma addignore <name>
		This adds the character with the same caveats as the addmember command
		except that this character is given the lowest karma rating possible,
		and if you have the autoignore turned on, then the user will be ignored
		from then on out.
	
	*/karma removemember <name>
		This removes a character from your karma character list.  
			
	*/karma givekarma <name>
		This checks your list and gives +3 karma to the character.  This
		again is primarily for macros.
		
	*/karma takekarma <name>
		This checks your list and gives -3 karma to the character.  This
		again is primarily for macros.

	*/karma sortby <[name|played|exp|time]>
		This changes your option as to how you sort the list of characters
		in your karma window.
	
	*/karma colorby <[played|exp|time]>
		This changes your option as to how you color the names of the characters
		in your karma window.
	
	*/karma autoignore <[on|off]>
		This turns on or off the autoignore feature of Karma.
	
	*/karma window
		This toggles the karma window. You may also use the key binding 
		available for this as well.  This is primarily for macro writers.
	
	*/karma options 
		This toggles the options window for Karma.  This is intended for
		macro writers.

* Credits:

Me: Sean Hummel (Aveasau on Stormscale)
Testing/GUI Slave: Laegfaron 
Others:  Everyone on Stormscale who as put up with my sitting around AFK while
				 I tested Karma, and to those who actively helped me to test it.
				 


	
	