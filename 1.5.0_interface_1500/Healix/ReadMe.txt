--[[--------------------------------------------------------------------------------------------------
Spell Text:
	NOTE: Default emotes dont work with custem text you must specify the channel as EMOTE using the "/hx menu" then clicking on channel and setting it to "EMOTE" and make sure the channel checkbox is checked.
	@t = target's name
	@on_t = "on "+target's name
	@s = Spell's name
	@m = Cast time (check mark will auto put this in...this is for if you want to state exactly where to put the time instead of the end)
	@r = spell's rank
	@pre = spell prefix (your global prefix; will not work with default emotes)
	@post = spell postfix (same as prefix)
	@mana = the casters mana percent
BackSlash Commands:
	/hx menu = healix's menu
	/hx spell = spell menu
	/hx debug = debug mode
	/hx = healix's help
	/hx macro <Spell Name>,<Is it instant cast?>
		<Spell name> = the spells name with capitalized first letters
		<Is it instant cast?> = a 1 if it is an instant cast spell or 0 if it isn't (can also be left blank for noninstants);
		so an example would be:		/hx macro Healing Wave
		this could also be writen as:   /hx macro Healing Wave, 0
		anouther would be:		/hx macro Rejuvenation, 1
--------------------------------------------------------------------------------------------------------------------

People:
	<<Author>>
		Lelek the Orkish Shaman and "Da Boss" of Ordo Astrum from ArgentDawn
	<<Priest Tester>>
		Skarphedinn the Undead Priest of the Drunken Fishermen from ArgentDawn
		Giler the Undead Priest from ArgentDawn
	<<Druid Tester>>
		Velora the NightElf Druid from SilverHand
	<<Shaman Helper>>
		Zesh = Thanks Love.
	<<Awsome Person Who Helped>>
		SkaDemon: knows stuff
	<<Additional people>>
		Aziel was there for me in the early days.
		Elfarran - Priest - Zul'jin.
		Rulan ... You point out all the mistakes in me. <3
	<<Fetch>>
		Rowne Nab those pesky Unknown bugs!
	<<SpellTell>>
		Oloch! Thanks man.

	THANKS!!
---------------------------------------------------------------------------------------------------
History:
	Version 4.4
		Fixed healix from displaying multible times if the person spammed a no target spell.
		add @mana for the players mana %
		added spells : Fade, Psychic Scream, Shackle Undead, Mana Tide Totem, Astral Recall, Hellfire, Enslave Demon, Rain of Fire, Howl of Terror
		Fix for interrupts text not changing if you changed it.
	Version 4.3 on 4-14-05
		New @on_t looks like "on TargetsName". 
		Widened the Edit box.
		Healix should work in macros (See readme for more details) type: /hx macro <Spell Name>,<Is it instant cast?> 
		Healix's spellmenu can now set all spells back to default
		c = fix for chat frame
		d = added reset all saves option type /hx reset
		e = Fixed emote bug
	Version 4.2 on 4-06-05
		Fixed Rez bug
		Fixed " on " bug
		b = Fixed " on " bug for emote
		c = fixed time bug. Time should show up right with checkmark.
	Version 4.1 on 3-23-05
		Now you can configure each spells output do it on the spell menu(/hx spell)
		you can now set channels to say,guild,officer,yell,and party.
		Should fix the bug people have been getting.
		b = petframe fix, Classes individual Healix saying fixed
	Version 4.0 on 3-18-05
		Unified SpellTell and Healix. Thanks Oloch!
		b = fixed things Oloch proposed
		c = fixed error if one didnt have PartyComm
	Version 3.5 on 3-14-05
		Externalized alot of localization stuff.
		Fixed insta casts and nontargeting spells (I hope).
		Renamed alot of variables.
		b  =  Fixed Sea error.
		c  =  Fixed spells checks not saving.
		d  =  Fixed emote self not working. Changed Resurrection spelling.
	Version 3.4.2 on 3-11-05
		The channel now works (Name not number and Watch caps)
		3.4.2b on 3-12-05 = fixed problem with sea and hooking right. 
		Changed the channel, prefix and postfix to save. 
		Prefix and postfix were fixed.
	Version 3.4.1 on 3-9-05
		Added spell interrupt to displayable
		fixed a bug with mouseover and self cast
		Made Healix much more localisable
		3.4.1b = Added in all rezz's to healix
		3.4.1c = Figured out that only one other party memeber would cause healix not to show
		3.4.1d = Definable interrupt and a new button
		3.4.1e = a fix for prefix / postfix
	version 3.4 on 3-9-05
		Added prefix and postfix change boxes.
		Channel box should work now... needs more testing.
		supports up to 20 spells.
	Version 3.3 on 3-6-05
		Ok fixed the problem of cosmos dependancy (I believe).
		Fixed the renew problem (I think).
		Now has no ties to cosmos (But can place a button in cosmos).
		3.3b = myAddOns support
	Version 3.2 on 3-6-05
		Adds assured working add and remove spells
		**MUCH MORE STABLE**
		Fixed alot of memory problems
		Fixed spell output for spells that have no target.
	Version 3.1 on 3-5-05
		Adds raid support (And a button for it)
		Adds a button to turn off target info
	Version 3.0 3-4-05
		You can now add spells to healix. Open up the menu (/hx menu) and click the add spell button.
		**WARNING** Make Damn sure you know the name of the spell/skill.
		If you want to get the name of a skill for sure type /debug and use it. Look though what outputs for Spell =.
		Version 3.0b on 3-5-05  = Fixed toggles not working.
	Version 2.2.1 3-4-05
		I got a new UI! Now opens / closes like blizzards
		2.2.1b Found the second spell wasnt being displayed
	Version 2.2 3-2-05
		Virtualized Spell definition completely now. MUHAHAHHAHAHAHH! Expect a add spell function soon.
		Turned Healix into a button in cosmos and added an icon (made by Lelek ^_^)>
		2.2b = fixed a bug in code when casting something other that somespell tog
		2.2c = fixed the problem that smart party was on default
	Version 2.1.1 3-2-05
		I think I got most of the targeting issues covered
		Fixed the help spam
	Version 2.1 2-28-05
		split /hx menu and /hx spell
		Now every class has something
		Added these spells:
			Druid: Hibernate, Entangle roots, Tranquility
			Mage: Arcane Explosion
			Hunter: Feign Death, Hunter's Mark, Scare Beast
			Priest: Prayer of Healing
			Rogue: Sap,Gouge
			Warlock: fear
			Warrior: charge
	Version 2.0.3 2-28-05
		SkaDemon found a bug with spell time
	Version 2.0.2 2-28-05
		Thanks SkaDemon you rock
		Added tootip / tookout event
		Now should work for renew and PW shield.
	Version 2.0 02-26-05
		New GUI independant of cosmos
		access it via /hx menu
	Version 1.6.2 02-24-05
		Fixed alot of bugs concerning init and onload.
		Took out division of heal and non heals
	Version 1.6 02-23-05
		They changed the interface number on me overnight
		Ok Seems I lost 6 hours of codeing when WoW patched
		It has been reinstated and the changes are many (though small to list)
		Added an option to turn off the "Casting" part of display
	Version 1.5.1
		compressed the spell toggel functions
		Split off Healixes function library
		Split off this read me
	Version 1.5 on 02-18-05
		Now no longer needs AltSelfCast to work.
		Will function as AltSelfCast.
		Now hooks to get mana cost and insta cast spells.
		Fixed up my if statements so that they should work instead of being a quick fix.
	Version 1.4.4 on 02-17-05
		Fixed the rest of the targeting bugs until I realized that if out of range it would always be wrong.
	Version 1.4.3 on 02-17-05
		Changed the interface number with the new patch.
		Fixed more targeting bugs.
	Version 1.4.2 on 02-16-05
		Fixed some targeting bugs
	Version 1.4.1 on 02-16-05
		Added check boxes for offensive spells for shaman
		Cliped some code.
		Changed how toggels work in the program
		Fixed a bug that could occure with self emote
	Version 1.4 on 02-14-05
		Doubled program length adding all the class toggels
		Added specific spell name toggels.
		Added smartparty checkbox which will disply only if more than one healer in party
		Changed the way the table of heal spells is iterated though
	Version 1.3 on 02-09-05
		Added the ability to toggle display of when you will cast the spell
		Made table of the heal spells and iterate though it
		Cut target finder functions length in half
		Added emote self checkbox
		Renamed and reformated plus added more commenting
	Version 1.2 on 02-03-05
		Added sheep spell support
		Added all timed heal spells I could find
	Version 1.1 on 02-02-05
		Added much more configuration in cosmos.
		Has himself, herself, me when selfcasting.
		Fused chat functions.
		Changed Commenting.
	Version 1.0 on 01-29-05
		Worked Perfectly
	Version 0.1 on 01-25-05
		Had limited functionality 
-----------------------------------------------------------------------------------
Purpose:
	This will anounce ablilites
------------------------------------------------------------------------------------------------------------------
Note:
	Loot or "borrow" the code all you want just give credit where due please.
------------------------------------------------------------------------------------------------------------------

--]]----------------------------------------------------------------------------------------------------------------
