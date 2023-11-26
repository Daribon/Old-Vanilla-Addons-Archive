***********************************
Scrolling Combat Text Versions 3.01
***********************************

Website - http://rjhaney.pair.com/sct/ 

Offical Thread - http://forums.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=27803&p=1&tmp=1#post27803

What is it? - A fairly simple but very configurable mod that adds damage, heals, and events (dodge, parry, windfury, etc...) as scrolling text above you character model, much like what already happens above your target. This makes it so you do not have to watch (or use) your regular combat chat window and gives it a "Final Fantasy" feel. 

Where did it come from? - The idea and base code came from the healthbar mod: http://forums.worldofwarcraft.com/thread.aspx?FN=wow-interface-customization&T=3913&P=1 
I liked that mod a lot, but it really didn't do all that I wanted. So I decided to use it as a base to create my own mod purely as a learning experience. I've continued to work on it and think its now at a point to be released on its own merits. 

What's it look like? - See the image on the website: http://rjhaney.pair.com/sct/ 

What can it do? 

- Damage messages
- Heals
- Spell Damage/Resists
- Dodges, Blocks, Parries, Absorbs, and Misses 
- Custom Colors for all text events
- Config file to setup custom events (self and target)
- Debuff Messages
- Low Health and Mana Warnings
- Rage/Mana/Energy Gains
- Troll Berserk alert
- Enter and Leave Combat Messages
- Rogue Combo Points, 5 CP Alert Message
- Honor Gain (Only works for English client in 3.0)
- Ability to flag all text with * to more easily seperate it from target damage 
- Ability to show events as text messages at the top of the screen
- Ability to set the scroll direction to up or down
- Sliders for text size, opacity, and text scroll speed
- MyAddons support
- Settings saved per character
- Load settings from another character

Where can I download it? - Right here, assuming my bandwidth hasn't all been used =) 

http://rjhaney.pair.com/sct/ 

How do I use it? - First unzip it into your interface\addons directory. It should be in its own folder called SCT. Now just run WoW and once logged in, type /sct to get the options screen. 

sct_event_config.lua is used to setup custom message events. Please open up the file and read the opening section to understand how to use it all.

/sctdisplay is used to create your own custom messages. 
Useage:
/sctdisplay 'message' (for white text)
/sctdisplay 'message' red(0-10) green(0-10) blue(0-10)
Example: /sctdisplay 'Heal Me' 10 0 0 - This will display 'Heal Me' in bright red
Some Colors: red = 10 0 0, green = 0 10 0, blue = 0 0 10, yellow = 10 10 0, magenta = 10 0 10, cyan = 0 10 10

FAQ
My custom event doesn't work. What's wrong? - Make sure you have the text exactly right, punctuation and capitalization matters. 

How do I change the text for parry, block, etc...? - open up the localiztions.lua file and look for the event you want to change. Then change the text to whatever you like.

How do I get get text to scroll? I only see numbers! - Make sure the "Show Events as Message" option is unchecked. This is only if you want events to appear in the games default message area ("Not enough Mana", "You are too far away", etc...)

Version History
3.01 - Added New localization files (from cosmos), added cosmos button, fixed multiple sticky crits, turned off some custom events by default.
3.0 - Added custom events for target, Honor gain as event, 5 CP message, flag events as crit, new option screen, load other character settings, Fixed bug when getting hit during load, Fixed bug with multiple crits on the screen at once.
2.82 - Added Rogue Combo Points, Updated Troll Berserk event, hopefully fixed disappearing sound/graphics issue
2.81 - hopefully fixed issue with lingering text and flashing opacity
2.8 - added opacity slider, Troll Berserk alert, Combat alerts, MyAddon Support, random bug fixes, general code optimizations.
2.71 - fixed parry bug.
2.7 - added new version friendly parsing system by Ayny, fixed major animation bug (much smoother now), fixed custom event bug with weapon procs, added french localization.
2.61 - fixed bug with new frame code and the color selector.
2.6 - added Sticky Crits, Critical Heals, Rage/Mana/Energy Gains. Partial Absorbs and Blocks changed. Debuffs and Drowning damage fixed. New Animation System.
2.5	-	added Debuffs, Absorb, Custom Events, Misc Damage (fire, falling, etc...), localization file. 
2.12 - fixed toc version
2.11 - fixed toc version, fixed druid low mana bug, fixed defaulting new settings
2.1 - fixed bug with blocks and PvP/Duel damage, added Low Health and Mana warning events
2.02 - fixed bugs with ReloadUI (hopefully), init of the system, and made resists off by default
2.01 - fixed a minor bug with scroll down and resist messages
2.0 - Major code re-write. Added Custom Colors, Direction Toggle, Per Character Settings, /sctdisplay ability
1.2 - Added PvP/Duel Damage and actual damage to blocks
1.1 - Added Clearcasting to list of events
1.01 - Fixed a minor option reference
1.0 - Initial Release 
