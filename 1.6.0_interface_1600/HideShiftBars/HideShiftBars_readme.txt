Name: HideShiftBars
Author: Jake Bolton (ninmonkey) ninmonkeys@gmail.com

About:
	Ever wanted to remove that annoying stealth bar(Or warrior/druid/paladin bars)? Since you know the button will stealth you, and there are no other buttons, this mod allows you to hide it. You can never have too much open space :P

	This mod allows you to toggle the visibility of the rogue stealth bar, warrior stance bar, paladin aura bar, and druid shape shifting bar. (Hide/Show the stealth/Stance/Aura/Shape bar)

Installation:
	Copy the HideShiftBars directory into your "World of Warcraft\Interface\AddOns\" directory. (mod path should be: "World of Warcraft\Interface\AddOns\HideShiftBars")
	
	Note: If the folder "addons" does not exist, then you must create it. In explorer(My Computer), you can right click and choose new->folder.)

Commands:
	/shiftbar help
	/shiftbar
		Shows help

	/shiftbar toggle
		Toggles the shiftbars on or off (stealth/stance/aura/shape)
		
Examples:
	If you are a rogue, and you have the stealth bar visible, just type:
/shiftbar toggle
	and it dissapears. To make it return, type:
/shiftbar toggle.

	This works for warrior/rogue/druid/paladins

Features: 

	-Allows you to toggle the visibility of the rogue stealth
	bar, warrior stance bar, paladin aura bar, and druid shape
	shifting bar. (Hide/Show the Stealth/Stance/Aura/Shape bar)


Changelog:
	Version 0.1.2:
		-updated for new blizz patch (interface 4216)
		-rewrote Initialization code
		-fixed the known issue that some classes defaulted to showing empty bars
			(ie: if a class like a mage has nothing binded too the shift-ing buttons
			then the buttons would show up as blank. With mods, they may have actions
			ie: AuraAspects + HideShiftBars to Show() the bar will show the aspects on
			a bar.)

	Version 0.1.1:
		-updated interface number for blizzard's patch (4211)
		-colored help
		-defaults bShowBar to false, so non-bar classes don't get a weird bar popup,
				but they can still enable it if they want (ie: hunters can see thier
				different aspects if they enable the bar)
		-any class can remove the bar using /shiftbar toggle
		
	Version 0.1:
		-basic working release
		-saves setting based on character class
