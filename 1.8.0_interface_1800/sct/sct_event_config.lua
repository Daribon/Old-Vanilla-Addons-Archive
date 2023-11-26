--[[
  ****************************************************************
	Scrolling Combat Text v3.5
	Event Config File
	****************************************************************
	Description:
		This file is used to setup custom events for use in SCT. Most 
		of the old limitations have been removed, so you can now check
		for custom events on most chat log messages. You can now also
		perform captures on the text and display the data in a 
		customized format. for each event you must setup three required 
		settings. for captured events you must setup one required
		setting. All events can also have one optional setting:
			
			  name:		This is basically the text you want SCT to display 
						 		whenever the event occurs. for captured data you
						 		use *n where n is the index of the captured data in 
						 		the order of the search. (see examples) 
						 		
			search:		This is the EXACT text SCT will search for to know
								when to display the event. You will most likley
								need to watch your combat chat log in game and see
								what text is displayed when the buff/talent/proc
								goes off. You can now use normal LUA expressions 
								to capture data. The order of these expressions is 
								what should be used in determining how to display 
								them in the name field. (see examples)
								
		argcount: 	this is required when you are wanting to use 
								captured data. This tells SCT how many captured 
								fields you want to replace in the name field. Keeping 
								this accurate helps improve SCT performance. If its 
								lower then you need some captured fields will not be 
								displayed, if its higher it just wastes loops 
								looking for data that is not there. 

							
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
		a valid event. 	
	****************************************************************]]

SCT_Event_Config = {

-- To remove an event, simply add -- in front of the line.
-- Example : to remove "Windfury!" do :
-- [1] = {name="Windfury!", search="You gain Windfury", r=256/256, g=256/256, b=0/256},

-- other examples
-- [2] = {name="Rend!", search="is afflicted by Rend", r=0/256, g=0/256, b=256/256},
-- [3] = {name="Overpower!", search="dodges", r=256/256, g=256/256, b=0/256, iscrit=1},

[1] = {name="Windfury!", search="You (.+) Windfury", r=256/256, g=256/256, b=0/256, iscrit=1},
[2] = {name="Clearcast!", search="You gain Clearcast", r=256/256, g=256/256, b=0/256},
[3] = {name="Flurry!", search="You (.+) Flurry", r=128/256, g=0/256, b=0/256},
[4] = {name="Lightning Shield!", search="You gain Lightning Shield", r=0/256, g=0/256, b=256/256},
[5] = {name="Thrash!", search="You (.+) Thrash", r=0/256, g=128/256, b=128/256},
[6] = {name="Nightfall!", search="You gain Shadow Trance", r=0/256, g=128/256, b=128/256},
[7] = {name="Lightning Shield Faded!", search="Lightning Shield fades", r=0/256, g=0/256, b=256/256, iscrit=1},

--Captured data examples. Remove, change, or comment out the ones you don't want.

--critical hits
--[8] = {name="Critical! (*1: *3)", argcount=3, search="Your (.+) crits (.+) for (%d+)", r=256/256, g=256/256, b=0/256}, 
--[9] = {name="Critical! (*2)", argcount=2, search="You crit (.+) for (%d+)", r=256/256, g=256/256, b=0/256},

--your heals
--[10] = {name="*2: +*3", argcount=3, search="Your (.+) critically heals (.+) for (%d+)", r=0/256, g=256/256, b=0/256, iscrit=1},
--[11] = {name="*2: +*3", argcount=3, search="Your (.+) heals (.+) for (%d+)", r=0/256, g=256/256, b=0/256},

--heals to you
--[12] = {name="+*3 (*1)", argcount=3, search="(.+)'s (.+) critically heals you for (%d+)", r=0/256, g=256/256, b=0/256, iscrit=1},
--[13] = {name="+*3 (*1)", argcount=3, search="(.+)'s (.+) heals you for (%d+)", r=0/256, g=256/256, b=0/256},
--[14] = {name="+*1 (*2)", argcount=2, search="You gain (%d+) health from (.+)'s (.+)", r=0/256, g=256/256, b=0/256},
--[15] = {name="+*1 (*2)", argcount=2, search="You gain (%d+) health from (.+).", r=0/256, g=256/256, b=0/256},

--all your hits
--[16] = {name="*2: *3 (*1)", argcount=3, search="Your (.+) hits (.+) for (%d+)", r=256/256, g=256/256, b=0/256}, 
--[17] = {name="*1: *2", argcount=2, search="You hit (.+) for (%d+)", r=256/256, g=256/256, b=0/256},

-- French
--[1000] = {name="Loup Fantôme !", search="Vous gagnez Loup fantôme", r=128/256, g=128/256, b=128/256},
--[1001] = {name="Bouclier de Foudre !", search="Vous gagnez Bouclier de foudre", r=0/256, g=0/256, b=256/256},
--[1002] = {name="Attaque des Vents !", search="Vous gagnez Attaque des vents", r=256/256, g=256/256, b=0/256},
--[1003] = {name="Idées Claires !", search="Vous gagnez Idées claires", r=256/256, g=256/256, b=0/256},
--[1004] = {name="Rafale !", search="Vous gagnez Rafale", r=128/256, g=0/256, b=0/256},

};
