To view this file online, go to http://hub1.netfirms.com/wowui/cta/cta_readme.html




Call To Arms R6 README File
---------------------------

Contents:

1.0 Introduction
2.0 Installation
3.0 Using Call To Arms
4.0 Release Notes
5.0 Other notes
6.0 Credits
		
		
------------------------------------------------------------------------------------------------

1.0	Introduction

	1.1	What is Call To Arms?
	
		Call To Arms (CTA) is an add-on (mod) for World of Warcraft that helps players create a 
		group. CTA has several features that allow players to search for open groups, advertise 
		group needs, and control which players are allowed to join the group and more. 
		Call To	Arms was created by Sacha Beharry in June, 2005.
		
	1.2	How does CTA work?
	
		CTA lets group leaders create a profile of their group. This profile includes a short 
		description, the maximum size wanted, the minimum level of the players in the group 
		and even a password to join. Group leaders can even set the class distribution of the 
		group members.

		Players can also use CTA to search for these groups using various search criteria. 
		When a suitable group is found, players can try to join the group. CTA will 
		automatically check whether the player has the correct level and class needed by the 
		group. Only a player that meets the requirements will be sent an invitation to join 
		the group. If a player is on the group leader's ignore list, that player cannot see 
		the leader's raid nor join it using CTA. Group leaders can also make the group private 
		so other players cannot see the group on CTA.

------------------------------------------------------------------------------------------------

2.0	Installation

	Copy Interface folder and its contents to your World of Warcraft installation folder so 
	that, after extraction of the contents, CallToArms should be in this folder:

	'<World of Warcraft installation path>\Interface\AddOns\CallToArms\'

	eg. if you installed World of Warcraft to this folder:

	'C:\Program Files\World of Warcraft'

	then CallToArms should be here after you have installed it:

	'C:\Program Files\World of warcraft\Interface\AddOns\CallToArms\' 	
	
	Once you do that just (re)start World of Warcraft to use CTA. 
	
	
------------------------------------------------------------------------------------------------

3.0	Using Call To Arms	
	
	3.1	Requirements
	
		You must have one free channel for CTA to use. This channel allows CTA to send and 
		receive search queries to and from other players. Currently this channel is named 
		'CTAChannel' and you can join it manually if CTA does not automatically join this 
		channel for any reason.
		
	3.2	Using Call To Arms for the first time
	
		The first time you use CTA, a window will be presented showing the settings for the 
		CTA minimap icon. You can use the settings panel to adjust the position of the minimap 
		icon and its text. If you accidentally close the settings window and you are unable to 
		click the minimap icon type '/cta toggle' in your chat frame to open the settings 
		window again. 
		
	3.2	Accessing CTA's features:
	
		Most of CTA's features are accessed by clicking on the red CTA button on your minimap.
		This button will appear when you start World of Warcraft after you have installed CTA.
		
		There are also a few slash commands available for CTA. Use '/cta' for a list of available 
		commands and '/cta help' for details on	each command. (See 3.3)
		
		The main frame of CTA has five tabs that provide access to the main features of CTA. The
		five tabs are: 'Find a group', 'Host a group', 'Blacklisted Players', 'Log' and 'Settings'
		(See 3.4).

	3.3	Slash commands

		'/cta' : Show a list of all available CTA commands.
		
		'/cta help' : Show details of each CTA command.
		
		'/cta toggle' : Show/hide the CTA Main Frame.
		
		'/cta announce <channel>' : Sends an automatically generated 'LFM' message to the channel.
		
		'/cta dissolve group': Totally dissolve the group by uninviting every member.
		
	3.4 Features
	
		3.4.1 	Find a group
				
				This feature presents a list of all the groups currently hosted by other players
				using CTA. There are several filters whish may be applied to the list so that only
				groups that satisfy these filters will be shown. Each group shown will have a 
				description of the group including information such as a comment by the leader, 
				the minimum level required to join the group, the current and maximum size of the
				group and more. Players wishing to join the group can select it in the results list
				and press the 'Join Group' button.
		
		3.4.2	Host a group
		
				The leader of a group, or any player that is not in a group, can start to host a 
				group in CTA. This seems strange at first, but think of it this way: If you are not
				in a group, then hosting a group is similar to indicating that you are looking for
				a group with the description that you specified. 
				I like to think that we are all groups with just one member, until we start joining
				each other's groups... Anyways..
				When you start hosting a group you can control which players join your group based 
				on the size of the group, player level and by class (See 3.4.3).
				
		3.4.3	ACID - Advanced Class Integration and Distribution... hehe :)
				
				ACID is used to set which classes you want in your group. There are eight available
				'Acid rules' that can be used. You can configure each rule exactly the way you want,
				nothing is pre-defined. The best way to explain ACID is to use examples:
				
				Problem 1:
					We want 4 more players (LF4M), 2 healers, 1 Warrior, 1 any class
					
				ACID Solution:
					Acid Rule 1: Size=2, Classes=Priest,Paladin(,Druid)
					Acid Rule 2: Size=1, Classes=Warrior
					
				Problem 2:
					We want 1 more player (LF1M), anything but a Paladin
					
				ACID Solution:
					Acid Rule 1: Size=1, Classes=Priest,Mage,Warlock,Warrior,Hunter,Druid,Rogue
					
						
		3.4.4	Blacklisted players
			
				The blacklist is a list of all players you do not want to join your group. 
				Sometimes, CTA will automatically add certain players to the list if they spam 
				the CTA channel. The blacklist entries can be edited and removed, but any 
				players on your ignore list	will be automatically added to the blacklist every 
				time CTA is started. Chat messages from blacklisted players are also ignored.
				
		3.4.5	Log and chat monitoring
				
				The CTA System Log contains entries made by CTA during operation. These entries 
				are used when debugging or keeping track of CTA's activities. 
				
				The log can also be used by CTA's chat monitoring feature to log any chat 
				messages that CTA suspects to be related to group activity.	The chat monitor 
				feature is still being developed. 
				
				You can (left/right/shift) click on the player names directly in the log just as 
				you can in the normal chat window - so if you see a similar group forming its a 
				little easier to send an invite/tell to the player.


------------------------------------------------------------------------------------------------

4.0	Release Notes

	4.1	CallToArms is compliant with the 1.6 patch
		
		CTA was tested with the new 1600 UI and appears to work fine. The TOC file has been 
		updated to indicate this.
	
	4.2	The communication channel (CTAChannel)
	
		CTA communicates using a channel named 'CTAChannel'. CTA will try to join this channel 
		automatically when started. CTA will wait until a channel message is received before 
		doing this, to avoid replacing channel 1 with 'CTAChannel' as was the problem some
		players had in R5.
		
		If CTA cannot join for any reason, please ensure that you have at least one free 
		channel, as you can only join a maximum of 10 channels at any time in World of Warcraft. 		
		
		
------------------------------------------------------------------------------------------------

5.0	Other notes
	
	5.1	Invitations:

		If you are hosting a raid, players who do not have CTA can still join your 
		raids automatically by sending a whisper to you with the message 'inviteme' or 
		'inviteme raidpassword' if you raid is password protected, replacing 'raidpassword' 
		with your password.

	5.2	Bug reporting and feedback
	
		Please feel free to submit any bugs or or any other feedback regarding CTA.
		Before you report a bug disable all other add-ons and restart CTA. If the problem
		stops then indicate the addons that were enabled when the problem started. Please
		include your language (English/German/French) and the version of CTA you are using
		(R1/R2/R3 etc) when reporting a bug.
			
		You may report bugs at the website from which you downloaded CTA or you can post them
		at http://cta.wowguru.com
	
	
------------------------------------------------------------------------------------------------

6.0	Credits

	6.1 Development
	
		UI design and testing	.. 	Adrianshiva
		
		German Localization		..	Markus Lanz, 
									Thrillseeker
									
		French Localization		..	Sasmira
	
	6.2 Thanks to:
	
		Every mod site that hosts CTA. 
		Every player who helped promote CTA.
		Everyone who left suggestions, reported bugs and other feedback on the forums.
		Every player who downloaded and used CTA and supported CTA in any other way.
	
	6.3 Special thanks to:
			
		You, for using CTA - your support will help this mod mature and become more useful to
		all players.
		