Druid Bar, v2.3

Slash commands: /DruidBar or /dbar
Commands: Toggle, ShowText, Update, Lock, Hide, Replace, Percent, EZShift, kmg, barcolor, Changex (1-??), Changey (1-??), PlayerFrame, TextType, TextColor (lots of options)


Toggle: Toggles the bar on/off
ShowText: Shows Mana info constantly, instead of mousing over it to display
Update: Use in caster form if it's not displaying the right information.
Lock: Locks the mana bar in place.
Hide: Hides the mana bar unless you're shapeshifted.
Replace: Replaces the mana bar in the Player Frame with 2 smaller bars for mana and rage/energy
Percent: Changes the text used in Replace to show either Raw numbers or Percent.
EZShift: Expands the shapeshift bar's "quick shifting" to action bars. Turn off if you're having probs w/alt-casting.
barcolor: Toggles the mana bar from changing colors as you lose mana
ChangeX: Changes the width of the movable mana bar
ChangeY: Changes the height of the movable mana bar.
PlayerFrame: Toggles the bar from sitting under the Player Frame, or to the normal movable style.
TextType: Changes the look of the text from the normal to an outlined style and back.
TextColor: Changes the text color. Use by color name or number(0.00-1.00 please!)
kmg: EXPERIMENTAL - adds replace support to Kaitlin's MiniGroup Suite vK0.5-(datestamp ~2/27/05). BTW, if you use this, please drop the MiniGroup.xml into your MiniGroup folder. ^^;

Druid Bar is a movable mana bar that keeps track of your current mana, even in a shapeshifted form like bear or cat. Please note that you must cast a couple of spells your first time starting up, for it to accurately gauge your regeneration rate. Might I suggest casting Healing touch a couple times on yourself and letting yourself regenerate? If the bar doesn't seem to be displaying the proper information because you logged on already in a shapeshifted form or whatever, simply shift out and type /dbar update.

Version History
	v2.2   -
		Fixed a bug with Aquatique and Voyage in french local.
		Sorta fixed the /dbar PlayerFrame option.
	v2.1   -
		Ok, this one's an official update.
		First of all, Alt-Casting =SHOULD= be fixed. or at least I can't find any more problems.
		I also added EZShift, which toggles on this function for the action bars. Toggle it off if you're having
		problems with alt-casting on yourself. Otherwise, enjoy.
		Changed how Percent works with the main draggable bar. Percent on: Shows the full raw # and %. Percent off: Only the raw #.
		Added BarColor: For people that don't like their mana bar to change colors as it goes down.
		Finally added kmg to the command list. It's still experimental so use at your own risk please.
	v2.01  -
		BOF! zut alors quel'que chance d'escorpion vert l'affiche desu ka? nigemasu onegaishimasu.
		Fixed my button-breaking ways.
		Added an experimental toggle for anyone using kaitlin's minigroup suite(vK0.5 preferrably) 
		Look at the lua if you use kmg. use at your own risk, not sure how it works with previous versions(or even this one).
	v2.0   -
		Wow. Redid a lot of the code dealing with displaying things.
		Cleaned up a lot of the wasteful code.
		Added a lot of wasteful code.
		"Fixed" the problem with action bars. Sorry Jeff. =P
		Added new functionality(that actually works this time): Casting any shapeshift spell from the action bar
		will shift you out of whatever form you're in, same as it would hitting the shapeshift bar.
		This also works with any macros that have the same picture as shapeshift spells. Use it for macros where
		you would shift out of whatever form you were in ;)
		Added ChangeX and ChangeY: That way you can make the bar smaller or larger than it is.
		For those that like to nitpick sizes ^^
		Added PlayerFrame: This toggle will basically move it under the player frame, similar to those EXP bars
		that show up under the player frame. I don't know why I added this, someone asked. Use if you feel like it.
		Added TextType: For people that felt the unoutlined text was annoying, or wanted to make the text match
		the Player Frame's outlined text...well, there you go.
		Added TextColor: This is more for fun than anything else. Customize your look. Go ahead, make it pink.
		And don't bother TRYING to call it light red. It's pink. PINK!!
		Can use Textcolor r # to set a single color, or TextColor Set # # # to set all 3 colors at once.
		Should be working for DE and FR, thanks for the help everyone!
	v1.925 -
		I'm not going to say I need to contact Jeff, but Jeff? Where are you?
		I need to contact you. WITH THE SHARP END OF MY SWORD.
		The error 500 people have been getting -should- be fixed.
		Let me know how it works for you.
	v1.9   -
		Expanded the functionality of the Shapeshift bar to any action bar. No more need for Shapeshift macros! Just 		drag and drop the Shapeshift spell from your spellbook to your action bar, and go. You will get messages 		about "Cannot use in shapeshift form" but it's a small price to pay. (There's currently no way I know of to 		prevent them from showing up)
		Fixed a couple of typos about how to use the slash command.
		Should be perfectly useable in EN, FR, DE now. If anyone wants to localize the rest, you're welcome to send it to me ^^;

	v1.875 -
		Okay, maybe it wasn't as fixed as I thought, but I offer you this new solution as penance!
		Fixed Innervate. I almost near possibly guarantee it TM.
		Hopefully fixed the Shapeshift mana cost problems for Fr and De.
	v1.85  -
		I overlooked my function DruidBar_GetShapeshiftCost() for Fr/De versions.
		Fixed! Thank you very much Iguane for a solution!
	v1.8   -
		Added Percent - So you can swap between % and #.
		Changed the way ShowText works. It's compatible with the built-in interface toggle now, so you can use that to show hp all the time, 
		and showtext to show the mana on replace.
		(Goodness knows how it works with cosmos --; let me know)
		Fixed a bug with Innervate never turning off. Yay for accidentally making the mod useless!
		moved around bits of code to hopefully make it work better.
		Most of you won't notice, but i changed the regen calculation to something i feel is more accurate.
		(I read either SPI / 3, or  SPI / 4 + 13, but SPI / 5 + 15 seems like it's the best.) +/-1%
	v1.7   -
		Fixed the money bug. yuck.
		Added Health support to ShowText
	v1.6   -
		Added preliminary Innervate support. let me know how it works.
		Fixed the SetFrameLevel bug.
	v1.5.1 -
		Another bug fix version, though this time nothing too serious.
		2 minor updates, both with /replace.
		First is fixing the Rage/Energy bar updating properly.
		Second is fixing the % updating properly. Should be AOK now. hopefully. ^^;
	v1.5   -
		Fixed a small calculation bug with hiding the large mana bar.
		Added Replace...Well, look at the screenshot on www.curse-gaming.com to see what it does.
	v1.4.2 -
		Seems my fix for 1.4.1 brought back problems from 1.3
		This one should have fixed the problems in 1.4 and 1.4.1
	v1.4.1 -
		Smithboy been helping me debug this thing immensely
		This one is fixing the bar jumping back down after hitting 100%
		(Unfortunate byproduct of using a fixed regen rate)
	v1.4 -
		Fixed a lot of bugs. I couldn't tell you specifically what,
		Though the main fix was the crash when shapeshifted and your mana hit 100%,
		As well as running your regen rate off of your Spirit.
		Everything else should just generally run better.
		+/-1% accuracy.
	v1.3 - 
		Fixed lock not properly locking.
		fixed a bug with lock and not showing the mana text on mouseover.
		Modified how the program checks if you've shifted and subtracting the mana accordingly.
		Fixed Regen rate getting reset when you log off and on.
		If you have Hide enabled, the mana bar should hide in shapeshift form when it gets to 100%
		The mana bar will now change colors depending on how full the mana bar is.
	v1.2 -
		Even more accuracy. Saves Regen rate over sessions, and ignores really high or low regen rates.
		Ignores when you're drinking to restore mana.
		(Give it about +/-50 now)
		Added Lock: Will lock the mana bar in place. So you can't move it.
		Added Hide: Will hide the mana bar unless you're in a shapeshifted form.
		Added a bit better reflection support.
		Tried to make my code a lil bit easier to read.
	v1.1 -
		Made the bar more accurate. Still give it the +/-100 range, but lately it's been within 20mp for me.
		Added an extra feature: If you're in one form, and you try to shift to another, you'll instead shift back to caster.
		This way you can just press the shapeshift button you want twice, rather than push one, then the other.
		Added a percent display to the mana bar, in case you like to read % rather than #.

Contact info:

In-game: Velora(Silver Hand)
Aim: Ska Demon X
Email: skademon@catsonmars.com
Or catch me on www.curse-gaming.com or www.worldofwarcraft.com UI forums. (SkaDemon on former, Velora on latter)