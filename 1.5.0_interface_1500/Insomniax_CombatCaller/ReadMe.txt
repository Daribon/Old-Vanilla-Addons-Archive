Insomniax CombatCaller v2.2 ReadMe File:

*************************************************************************************

Original Author: Alex Brazie
Modified by: LedMirage to Insomniax Combat Caller v1.0 March 29, 2005
Modified by: Reuben "Ascendant" Johnson to Insomniax Combat Caller v2.0 June 7, 2005
Sound Conversion by: LedMirage, changed version to 2.1 June 11, 2005
Removed "/cc" slash command by: Ascendant June 13, 2005
Added extra slash command functionality to CombatCaller main and added more 
	error checking by: Ascendant, changed version to 2.2 June 14, 2005

*************************************************************************************
Changes made from v2.1 to v2.2: (*updated 6/16/2005)

	*Added check to code that updates variables if new variables are added to code
		(this allows the new variable(s) to be added without the user having to modify
		the SavedVariables.lua file to get the new variable)
	* Added 2 functions (IX_Initialize_Variables and IX_Add_Verify_Variables) to handle
		user variable initialization and update, as described in the above note
		
	Added /disable, /enable slash commands to /combatcaller parameter list
	Added error checking to prevent user from modifying settings while mod is disabled
	Fixed some chat confirmation errors when modifying settings
	
*************************************************************************************

Changes made from v2.0 to v2.1:

	All WAV sound files converted to MP3 files reducing overall mod file size from 
		4.8mb to around 900kb, also changes to Insomniax_Sound_Files.lua were made 
		to reflect the new sound format.
	Removed /cc as a slash command option (conflicted with CooldownCount) -- Ascendant
	
*************************************************************************************
Changes made from v1.0 to v2.0:

	Added slash commands to manipulate mod functionality
	Added saved variables (per char, per realm) - saved between sessions
	Included ingame help file
	Allow user to customize how the CombatCaller makes its calls
		(i.e. the ability to turn off the "OOM" and "HEALME" emotes and replace them 
			with just the sound, a simple text emote, or both)	

*************************************************************************************

Commands:
	
	CombatCaller ->	AddOn used to announce when you are low on mana or health at user-defined intervals
					when mana or health drop below user-defined percentages
		
		Slash Command ->	/combatcaller
		
		Parameters ->		"help"		- displays help file
							"disable"	- disables mod
							"enable"	- enables mod
							Any of the following list of commands
		
		Example ->			/combatcaller help
							/combatcaller enable
							/combatcaller disable
	
	HealthRatio -> 	A decimal value between 0 and 1 representing the percentage of health remaining 
					when CombatCaller will announce that you are low on health

		Slash commands ->	/hr or /healthratio		

		Parameters  ->		"help"		- displays help file
							any decimal value to the tenths place that is greater than zero and less than or equal to one
								(note any decimal value to the hundredths place or greater will be truncated)

		Examples ->			/combatcaller hr help
							/combatcaller healthratio 0.7
					
	ManaRatio ->	A decimal value between 0 and 1 representing the percentage of mana remaining 
					when CombatCaller will announce that you are low on mana

		Slash commands ->	/mr or /manaratio		

		Parameters  ->		"help"		- displays help file
							any decimal value to the tenths place that is greater than zero and less than or equal to one
								(note any decimal value to the hundredths place or greater will be truncated)

		Examples ->			/combatcaller mr help
							/combatcaller manaratio 0.2
					
	CoolDown -> 	A whole number value between 5 and 30 that represents the number of seconds to elapse
					between calls for health or mana
		
		Slash commands ->	/cd or /cooldown or /cooldowntime
		
		Parameters ->		"help"		- displays help file
							##			- any whole number value between 5 and 30 representing the
											number of seconds to elapse between calls for 'low health' or 'low mana'
							
		Example ->			/combatcaller cooldown help
							/combatcaller cd 25
	
	HealthWatch ->	Toggle used to determine if your health will be monitored by CombatCaller
	
		Slash commands ->	/healthwatch
		
		Parameters ->		"help"		- displays help file
							"on"		- turns health monitoring on
							"enable"	- enables health monitoring
							"off"		- turns health monitoring off
							"disable"	- disables health monitoring
							
		Examples ->			/combatcaller healthwatch off
							/combatcaller healthwatch enable
							/combatcaller healthwatch help
	
	ManaWatch ->	Toggle used to determine if your mana will be monitored by CombatCaller
	
		Slash commands ->	/manawatch
		
		Parameters ->		"help"		- displays help file
							"on"		- turns mana monitoring on
							"enable"	- enables mana monitoring
							"off"		- turns mana monitoring off
							"disable"	- disables mana monitoring
							
		Examples ->			/combatcaller manawatch off
							/combatcaller manawatch enable
							/combatcaller manawatch help
	
	HealthCall ->	Toggle used to determine if the default "HEALME" emote will play or a custom text emote
	
		Slash commands ->	/healthcall
		
		Parameters ->		"help"		- displays help file
							"reset"		- resets the Combat Caller emote to default
							
							"customcall" - takes the following parameters:
								
								"reset" 			- resets custom emote setting, effectively re-enabling the default "HEALME" emote
								"soundonly"			- sets the custom setting to play just the "HEALME" emote sound without the text emote
								"soundtext" <text> 	- sets the custom setting to play the "HEALME" emote sound and a custom emote text string
								<text>				- sets the custom setting to display a custom emote text string and disable sounds
								
		Examples ->			/combatcaller customcall reset
							/combatcaller customcall soundonly
							/combatcaller customcall soundtext is in need of a heal
								(will display in chat as "<your name here> is in need of a heal")
							/combatcaller customcall is in need of a heal
								(will display in chat as "<your name here> is in need of a heal")


	ManaCall ->	Toggle used to determine if the default "OOM" emote will play or a custom text emote
	
		Slash commands ->	/manacall
		
		Parameters ->		"help"		- displays help file
							"reset"		- resets the Combat Caller emote to default
							
							"customcall" - takes the following parameters:
								
								"reset" 			- resets custom emote setting, effectively re-enabling the default "OOM" emote
								"soundonly"			- sets the custom setting to play just the "OOM" emote sound without the text emote
								"soundtext" <text> 	- sets the custom setting to play the "OOM" emote sound and a custom emote text string
								<text>				- sets the custom setting to display a custom emote text string and disable sounds
								
		Examples ->			/combatcaller customcall reset
							/combatcaller customcall soundonly
							/combatcaller customcall soundtext is in need of a mana
								(will display in chat as "<your name here> is in need of a mana")
							/combatcaller customcall is in need of a mana
								(will display in chat as "<your name here> is in need of a mana")
	
	Reset ->	Resets default values for all Combat Caller settings
	
		Slash command ->	/reset
		
		Parameters ->		none
		
		Example ->			/combatcaller reset
	
	Default ->	Displays default values for all Combat Caller settings
	
		Slash command ->	/default
		
		Parameters ->		none
		
		Example ->			/combatcaller default
	
	Display ->	Displays current Combat Caller settings for current character
	
		Slash command ->	/display
		
		Parameters ->		none
		
		Example ->			/combatcaller display		