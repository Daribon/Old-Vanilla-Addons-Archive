--[[
	Define all Global Variables here
]]

-- Global Variables that are not supposed to be on-the-fly user configurable.
perl_target_locked = 0;
perl_loaded		= 0;
perl_locked		= 1;
perl_init		= 1;  -- This variable is used to tell all the initial function that they can now run.
perl_targettargetspeed		= 0.25;
perl_targetdistancespeed	= 0.25;
perl_partydistancespeed		= 2;
perl_raidtargetspeed		= 1;

function Perl_Globals_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");

	-- Added to deal with storing variables between sessions.
	RegisterForSave("Perl_Config");
end

function Perl_Globals_OnEvent(event)
	-- Between sessions variable saving.

	if ((not Perl_Config) or (not Perl_Config.BarTextures)) then
		-- Create the global variable
		Perl_Config = {};
		
		-- Set the "Config" Version (If you use the program version it makes things easier as you only need to modify it in the localization file)
		Perl_Config.ConfigVersion	= Perl_VersionNumber;

		-- Define the defaults for the global variable
		Perl_Config.BarTextures			= 1;	--change to 0 to not show the bar textures
		Perl_Config.Transparency		= 1;	--change to the desired overall transparency, between 0 and 1
		Perl_Config.TextTransparency	= 0.8;	--change to the desired text transparency, between 0 and 1
		Perl_Config.ArcaneBar			= 1;	--change this to 0 to hide the ArcaneBar
		Perl_Config.OldCastBar			= 1;	--change this to 0 to hide the old cast bar
		Perl_Config.CastTime			= 1;

		-- CastParty Support
		Perl_Config.CastParty			=1;		--change to 0 to turn off CastParty support
		Perl_Config.CastPartyShow		=0;		--change to 1 to show CastParty frames

		-- Options that modify the player's display
		Perl_Config.ShowPlayerPortrait	= 1;	--change this to 0 to automatically hide the player's portrait
		Perl_Config.ShowPlayerLevel		= 1;	--change this to 0 to hide the player's level
		Perl_Config.ShowPlayerClassIcon	= 1;	--change this to 0 to hide the player's class icon
		Perl_Config.ShowPlayerXPBar		= 0;	--change to 1 to show player XP bar
		Perl_Config.ShowPlayerPVPRank	= 1;	--change to 0 to hide the target's PVP rank
		Perl_Config.ShowOldPlayerFrame	= 0;	--change this to 1 to show old blizzard player frame
		Perl_Config.Scale_PlayerFrame	= 0.8;	--sets the scale of the player frame

		-- Options that modify the target display
		Perl_Config.ShowTargetPortrait	= 1;	--change this to 0 to hide the target's portrait
		Perl_Config.ShowTargetClassIcon	= 1;	--change this to 0 to hide the target's class icon
		Perl_Config.ShowTargetMobType	= 1;	--change this to 0 to hide the target's mob type
		Perl_Config.ShowTargetLevel		= 1;	--change this to 0 to hide the target's level
		Perl_Config.ShowTargetElite		= 1;	--change this to 0 to hide display of 'elite' or 'boss'
		Perl_Config.ShowTargetDistance	= 1;
		Perl_Config.ShowTargetMana		= 1;	--change this to 0 to hide target mana and energy
		Perl_Config.UseCPMeter			= 1;	--change this to 0 to use combo point text display
		Perl_Config.ShowTargetPVPRank	= 1;	--change to 0 to hide the player's PVP rank
		Perl_Config.Scale_TargetFrame	= 0.8;	--sets the scale of the target frame
		
		-- Target of Target options
		Perl_Config.ShowTargetTarget		= 1;
		Perl_Config.Scale_TargetTargetFrame	= 0.7;
		
		-- Options that modify the Party display
		Perl_Config.ShowPartyLevel		= 1;	--change this to 0 to hide party levels
		Perl_Config.ShowPartyNames		= 1;	--change this to 0 to hide party names
		Perl_Config.ShowPartyDistance	= 1;	--change this to 0 to hide distance to party members
		Perl_Config.ShowPartyPercent	= 1;	--change this to 0 to hide party percentages
		Perl_Config.ShowPartyClassIcon	= 1;	--change this to 0 to hide party class icons
		Perl_Config.ShowPartyRaid		= 1;	--change to 0 to hide party frames while in a raid group
		Perl_Config.Scale_PartyFrame	= 0.8;	--sets the scale of the party frame
		Perl_Config.PartyDebuffsBelow	= 0;

		-- Options that modify the pet display
		Perl_Config.PetHappiness	= 1;		--change this to 0 to hide pet happiness icon
		Perl_Config.ShowPetLevel	= 1;		--change this to 0 to hide pet level
		Perl_Config.ShowPetXP		= 1;
		Perl_Config.Scale_PetFrame	= 0.8;		--sets the scale of the pet frame
		Perl_Config.ShowPartyPets	= 1;
		
		
		Perl_Config.SortRaidByClass	= 1;
		Perl_Config.ShowRaid		= 1;
		Perl_Config.ShowGroup1		= 1;
		Perl_Config.ShowGroup2		= 1;
		Perl_Config.ShowGroup3		= 1;
		Perl_Config.ShowGroup4		= 1;
		Perl_Config.ShowGroup5		= 1;
		Perl_Config.ShowGroup6		= 1;
		Perl_Config.ShowGroup7		= 1;
		Perl_Config.ShowGroup8		= 1;
		Perl_Config.ShowGroup9		= 1;
		Perl_Config.ShowRaidPercents= 1;
		Perl_Config.Scale_Raid		=0.8;
		
		
		
		
		
	else
		-- Add new variables here and above (to set defaults).
		-- The reason for this is when you upgrade the variables you need to define the new settings somewhere.
		-- This is important for between version upgrades when the variables change.
		-- There really is no in-game performance loss for running this each version upgrade as it only happens
		-- the first time someone runs the new version, and only once as the first thing it does is update the
		-- version string.

		if ((not Perl_Config.ConfigVersion) or (Perl_Config.ConfigVersion ~= Perl_VersionNumber)) then
			Perl_Config.ConfigVersion = Perl_VersionNumber;	-- Set ConfigVersion to current

			-- This adds the Scale_TargetTargetFrame option if it isn't in the config at the moment,
			-- best to just do this check for each new variable in case somehow the user gets dumped
			-- into this routine.
			if (not Perl_Config.Scale_TargetTargetFrame) then
				Perl_Config.Scale_TargetTargetFrame=0.7;
			end
			if (not Perl_Config.ShowPetXP) then
				Perl_Config.ShowPetXP=1;
			end
			if (not Perl_Config.SortRaidByClass) then
				Perl_Config.SortRaidByClass=1;
			end
			if (not Perl_Config.ShowRaid) then
				Perl_Config.ShowRaid= 1;
			end
			if (not Perl_Config.ShowGroup1) then
				Perl_Config.ShowGroup1= 1;
			end
			if (not Perl_Config.ShowGroup2) then
				Perl_Config.ShowGroup2= 1;
			end
			if (not Perl_Config.ShowGroup3) then
				Perl_Config.ShowGroup3= 1;
			end
			if (not Perl_Config.ShowGroup4) then
				Perl_Config.ShowGroup4= 1;
			end
			if (not Perl_Config.ShowGroup5) then
				Perl_Config.ShowGroup5= 1;
			end
			if (not Perl_Config.ShowGroup6) then
				Perl_Config.ShowGroup6= 1;
			end
			if (not Perl_Config.ShowGroup7) then
				Perl_Config.ShowGroup7= 1;
			end
			if (not Perl_Config.ShowGroup8) then
				Perl_Config.ShowGroup8= 1;
			end
			if (not Perl_Config.ShowGroup9) then
				Perl_Config.ShowGroup9= 1;
			end
			if (not Perl_Config.ShowRaidPercents) then
				Perl_Config.ShowRaidPercents= 1;
			end
			if (not Perl_Config.Scale_Raid) then
				Perl_Config.Scale_Raid=0.8;
			end
			if (not Perl_Config.CastTime) then
				Perl_Config.CastTime=1;
			end
			if (Perl_Config.PartyDebuffsBelow) then
				Perl_Config.PartyDebuffsBelow=0;
			end
			if (not Perl_Config.ShowPartyPets) then
				Perl_Config.ShowPartyPets=1;
			end
		end
	end

	if(myAddOnsFrame) then
		myAddOnsList.Perl_Description = {
			name			= Perl_Description,
			description		= "Modifies the default party and target frames.",
			version			= Perl_VersionNumber,
			category		= MYADDONS_CATEGORY_OTHERS,
			frame			= "Perl_Frame",
			optionsframe	= "Perl_OptionsMenu_Frame"
			};
	end

	Perl_Init();
end
