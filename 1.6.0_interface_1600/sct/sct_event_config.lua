--[[
  ****************************************************************
	Scrolling Combat Text v3.1
	Event Config File
	****************************************************************
	Description:
		This file is used to setup custom buffs, talents, and weapon 
		procs for use in SCT. Right now this will only work for things
		that are cast on to you, not something that is cast on to your
		target. for each custom event you must setup three different 
		settings:
			
			name: 		This is basically the text you want SCT to display 
						 		whenever the event occurs.
						 		
			search:		This is the EXACT text SCT will search for to know
								when to display the event. You will most likley
								need to watch your combat chat log in game and see
								what text is displayed when the buff/talent/proc
								goes off. In general, try to use the smallest
								phrase as possible.
							
			r, g, b:	These are the color settings used to select the
								color you want the event to display in. r = red,
								g = green, b = blue. Some common colors:
								
								Red:  			r=256/256, 	g=0/256, 		b=0/256
								Green:			r=0/256, 		g=256/256, 	b=0/256
								Blue:				r=0/256, 		g=0/256, 		b=256/256
								Yellow:			r=256/256, 	g=256/256, 	b=0/256
								Magenta:		r=256/256, 	g=0/256, 		b=256/256
								Cyan:				r=0/256, 		g=256/256, 	b=256/256
								
			iscrit:  	this will make the event appear as a crit event, 
								so it will be sticky or large font. You only need
								to set this if you want it used. iscrit=1
								
	Note:
		Make sure you increase the key count ([1], [2], etc...) for 
		each new event you add. Feel free to delete any of the already
		provided events if you know you will never need them or you
		dont want them to display. You may also place -- in front
		of any of them to comment them out.
		
	Problems:
		if the event you are wanting to add is not being displayed by
		SCT make sure you double check the search text. Any space,
		comma, or period out of place will cause it to fail. There is
		also the chance that the event you are wanting to add is not
		a valid event. It must be an event that triggers on to you in 
		some way and it MUST show up in the combat chat log.	
	****************************************************************]]

SCT_Event_Config = {

-- To remove an event, simply add -- in front of the line.
-- Example : to remove "Windfury!" do :
-- [1] = {name="Windfury!", search="You gain Windfury", r=256/256, g=256/256, b=0/256},

-- other examples
-- [2] = {name="Rend!", search="is afflicted by Rend", r=0/256, g=0/256, b=256/256},
-- [3] = {name="Overpower!", search="dodges", r=256/256, g=256/256, b=0/256, iscrit=1},

[1] = {name="Windfury!", search="through Windfury", r=256/256, g=256/256, b=0/256, iscrit=1},
[2] = {name="Clearcast!", search="You gain Clearcast", r=256/256, g=256/256, b=0/256},
[3] = {name="Flurry!", search="You gain Flurry", r=128/256, g=0/256, b=0/256},
[4] = {name="Lightning Shield!", search="You gain Lightning Shield", r=0/256, g=0/256, b=256/256},
[5] = {name="Flurry Axe!", search="through Flurry Axe", r=0/256, g=128/256, b=128/256},
[6] = {name="Nightfall!", search="You gain Shadow Trance", r=0/256, g=128/256, b=128/256},
[7] = {name="Spell Critical!", search="Your .+ crits .+ for", r=256/256, g=256/256, b=0/256}, 
[8] = {name="Critical!", search="You crit", r=256/256, g=256/256, b=0/256},
[9] = {name="Lightning Shield Faded!", search="Lightning Shield fades", r=0/256, g=0/256, b=256/256, iscrit=1},

-- French
-- To remove an event, simply add -- in front of the line.
-- Example : to remove "Loup Fantôme !" do :
-- [1000] = {name="Loup Fantôme !", search="Vous gagnez Loup fantôme", r=128/256, g=128/256, b=128/256},

--[1000] = {name="Loup Fantôme !", search="Vous gagnez Loup fantôme", r=128/256, g=128/256, b=128/256},
--[1001] = {name="Bouclier de Foudre !", search="Vous gagnez Bouclier de foudre", r=0/256, g=0/256, b=256/256},
--[1002] = {name="Attaque des Vents !", search="Vous gagnez Attaque des vents", r=256/256, g=256/256, b=0/256},
--[1003] = {name="Idées Claires !", search="Vous gagnez Idées claires", r=256/256, g=256/256, b=0/256},
--[1004] = {name="Rafale !", search="Vous gagnez Rafale", r=128/256, g=0/256, b=0/256},

};