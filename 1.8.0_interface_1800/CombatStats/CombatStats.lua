--[[

	CombatStats3 - Stat Damage Tracking
	AUTHOR:	DmgInc on most forums / Glacier on official WoW forums
	THANKS TO:	The dude(ette) who made DPSPlus for showing me the light on how to parse the combat log
				The dude(ette) who made Clock for the time conversion routines 

	Rev 3.971 - Removed the "DPS : " from the titan panel	

	Rev 3.97	- 2 fixes,	1) The sCombatStats.... error
							2) The error in the de.lua file	

	Rev 3.96	- German localization translations added

	Rev 3.94	- Fixed the error if you weren't using Titan

	Rev 3.94	- Fixed the not updating on TitanPane while hidden bug

	Rev 3.93	- Quick fix for a bonehead mistake

	Rev 3.92	- Added TitanPanel plug-in support
			- Added a slash command to hide the tooltip

	Rev 3.91	- HUGE bugfix. The infobar stuff was causing the OnEvent to get ran twice
			 causing your damage to be recorded twice, as such the DPS value was doubled	

	Rev 3.9		- Removed mouseover stats pop up when used w/infobar
			- Added a /cs showstats command to show the attack stats	

	Rev 3.8		- Removed any Sea calls, this will get rid of any of the UIDROPDOWNxxxx errors 
			 people may have been having [I hadn't noticed because I don't use Sea]
			- Implemented the right click to drag the window that had been added by the CTMod folks
			- Re-did the slash command handler so it actually works, the slash commands are now
				enable - 'Enables CombatStats'
				disable - 'Disables CombatStats'
				showonlywhentarget - 'Only show DPS meter when you have a target'
				showalways - 'Only show DPS meter always'
				statsonmouseover - 'Show detailed window on mouseover'
				statsonclick - 'Show detailed window on mouseclick'
				endoffight - 'Show end of fight information'
				noendoffight - 'Don't show end of fight information'
				hide - 'Hide the frame '
				show - 'Show the frame '
				reset - 'Rest all stats to 0'

	Rev 3.7		- Parsing strings moved to localization file (Thx to whoever at cosmos moved them)
			- It appears the french localization may be done. (?)

	Rev 3.6		- Fixed a bug where sometimes the DPS meter wouldn't start even though you were fighting
			- Increased DPS Meter window to 30 seconds

	Rev 3.5		- Fixed the sasving of the variables, AGAIN
			- Added some info about what the DPS meter actually represents

	Rev 3.4 	- First crack at adding CombatStats to InfoBar
			- Back to using if ( (event == "PLAYER_REGEN_ENABLED") or (event == "PLAYER_LEAVE_COMBAT" )) 
			  to determine end of fight
			- Also really really really now saves options when used via slash commands

	Rev. 3.3	- ReEnabled the option to only show the stats on a mouseclick
	2.16.05		- DPS caluculated is now 15 seconds w/no option to change
				- Added end of fight stats option to turn on/off
				- Slash commands will save between sessions when not using w/cosmos
				
	Rev. 3.2	- Added end of fight statistics
	2.09.05		- Using PLAYER_REGEN_DISABLED ENABLED to tell when you
				  are in/out of combat for end of fight info

	Rev. 3.1	- Lots of fixes to track pet stats
	2.07.05	

	Rev. 3.0	- Initial version to track Defensive DPS	
	12.xx.04

	Rev 2.03 	- Now really really works w/o cosmos
	11.15.04
	
	Rev 2.02	- Now works w/o cosmos
	11.14.04	- Changed the text display frame
			- Fixed the crit % running out of the frame when it was 100%
			- Put "Default" attack at top of the list
			- Added in a "Total", put it at the bottom of the list
			- UI is now movalbe
			- UI will update itself while you are attacking if it is visible
			- Fixed a bug where the close "X" button couldn't be pressed
			- Now uses OnEvent and OnUpdate 
			- Pet damage is now tracked
			- DOT damage totals are correctly shown
			- Hopefully got rid of bogus entries
				

	Rev 2.01	- First release w/new UI
	11.05.04
	
]]

--
--	Cosmos Cofig variables
--

CombatStats_Config = { };
CombatStats_Menu = { };

function CombatStats_AddButton(info)
	table.insert(CombatStats_Menu, info);
end

--CombatStats_Config.CombatStats_OnOff = 1;
--CombatStats_Config.CombatStats_HideOnNoTarget = 0;
--CombatStats_Config.CombatStats_EndOfFight = 0;
--CombatStats_Config.CombatStats_UseMouseOver = 0;
--CombatStats_Config.CombatStats_Hide = 0;

CombatStats_LastUpdate = 0;
CombatStats_UpdateFreq = 0.1; 
TB_DPS_FREQUENCTY = 0.1;
CombatStats_DPSLen = 30;	-- Calculate DPS over the last 30 seconds
 
defcritCount = 0;
speccritCount= 0;

timestamps = {};
takenTimestamps = {};

players = {};
playersTaken = {};

dmg = {};
dmgTaken = {};

globalTaken = 0.0;
globalDone = 0.0;

dpstotals = {};
dpsTakenTotals = {};

defCrits = {0};
specCrits = {0};

defCritTotals = {};
specCritTotals = {};

bInCombat = 0;
bHasDefault = 0;

totalDamage = 0;

--
-- Procs info
--

totalProcs 		=	0;

--
--	Last fight info
--

lastFightStart		=	0;
lastFightFinish		=	 0;
lastFightPlayerDamage	=	0;
lastFightPetDamage	=	0;

mobDied				=	0;
regenEnabled		=	0;
leaveCombat		=	0;

overallCombatTime	=	0;

overallSwings		=	0;
overallMisses		=	0;
overallDodged		=	0;
overallParried		=	0;
overallEvaded		=	0;
overallBlocked		=	0;
overallResisted		=	0;
overallImmuned		=	0;
overallDeflected	=	0;
overallHits		=	0;
overallNonCrits		=	0;
overallCrits		=	0;
overallmaxCrit		=	0;
overallminCrit		=	0;
overallmaxReg		=	0;
overallminReg		=	0;
overallRegDmg		=	0;
overallCritDmg		=	0;
overallLastcrit		=	0;

attackNames = {};
specialAttacks = {};
specialAttackLog = {};

totalHits = 0;
totalCrits = 0;
specialsCount = 0;

CombatStats_Old_TargetFrame_OnShow = nil;
CombatStats_Old_TargetFrame_OnHide = nil;

CombatStats_ChatCommandHandlers={};

bFirstTime = 1;

CombatStatsVars = { };
CombatStatsSessionVars = { };
DeathCount = 0;
DeathLog = { };
CombatStatsRecentVars = { };
CombatStatsByName = { };
CombatStatsSessionByName = { };
CombatStatsDisplay = { };

function CombatStats_ChatCommandHandler(msg)	
	-- Print("CombatStats_ChatCommandHandler("..asText(msg)..")");
	if( not msg or msg == "" ) then
		Print("All slash command can start with either /cs or /combatstats example: /cs enable or /combatstats enable");		
		Print("enable - 'Enables CombatStats'");
		Print("disable - 'Disables CombatStats'");
		Print("showonlywhentarget - 'Only show DPS meter when you have a target'");
		Print("showalways - 'Show DPS meter always'");
		Print("statsonmouseover - 'Show detailed window on mouseover'");
		Print("statsonclick - 'Show detailed window on mouseclick'");
		Print("endoffight - 'Show end of fight information'");
		Print("noendoffight - 'Don't show end of fight information'");
		Print("hide - 'Hide the frame '");
		Print("show - 'Show the frame '");
		Print("showstats - 'Show the attack stats frame '");
		Print("hidettip - 'Hides the ...over last 30 seconds tooltip'");
		Print("reset - 'Rest all stats to 0'");
	else
		local command = string.lower(msg);
		
		if(command == "enable") then
			CombatStats_Config.CombatStats_OnOff = 1;
		elseif(command == "disable") then
			CombatStats_Config.CombatStats_OnOff = 0;
		elseif(command == "showonlywhentarget") then
			CombatStats_Config.CombatStats_HideOnNoTarget = 1;
		elseif(command == "showalways") then
			CombatStats_Config.CombatStats_HideOnNoTarget = 0;
		elseif(command == "statsonmouseover") then
			CombatStats_Config.CombatStats_UseMouseOver = 1;
		elseif(command == "statsonclick") then
			CombatStats_Config.CombatStats_UseMouseOver = 0;
		elseif(command == "endoffight") then
			CombatStats_Config.CombatStats_EndOfFight = 1;		
		elseif(command == "noendoffight") then
			CombatStats_Config.CombatStats_EndOfFight = 0;		
		elseif(command == "hide") then
			CombatStats_Config.CombatStats_Hide = 1;		
		elseif(command == "show") then
			CombatStats_Config.CombatStats_Hide = 0;
		elseif(command == "hidettip") then
			CombatStats_Config.CombatStats_HideTtip = 1;
		elseif(command == "showstats") then
			CombatStatsText_ShowFrame();
		elseif(command == "reset") then
			CombatStats_Reset();
		end

		CombatStats_UpdateVisibility();	

	end

end

--
--	Cosmos Config Handlers
--

function CombatStats_HideOnNoTarget_OnOff(toggle)
	-- Print("CombatStats_HideOnNoTarget_OnOff("..asText(toggle)..")");
	CombatStats_Config.CombatStats_HideOnNoTarget = toggle;
	CombatStats_UpdateVisibility();
end

function CombatStats_Watch_OnOff(toggle) 
	-- Print("CombatStats_Watch_OnOff("..asText(toggle)..")");
	CombatStats_Config.CombatStats_OnOff = toggle;
	CombatStats_UpdateVisibility();	
end

function CombatStats_UseMouseOver_OnOff(toggle)
	-- Print("CombatStats_UseMouseOver_OnOff("..asText(toggle)..")");
	CombatStats_Config.CombatStats_UseMouseOver = toggle;
	CombatStats_UpdateVisibility();
end

function CombatStats_EndOfFight_OnOff(toggle)
	-- Print("CombatStats_EndOfFight_OnOff("..asText(toggle)..")");
	CombatStats_Config.CombatStats_EndOfFight = toggle;
	CombatStats_UpdateVisibility();
end

function CombatStats_UpdateVisibility(hasTarget)

	if (not hasTarget) then
		if (TargetFrame:IsVisible()) then
			hasTarget = 1;
		else
			hasTarget = 0;
		end
	end

	if (CombatStats_Config.CombatStats_OnOff == 1) then
		if (CombatStats_Config.CombatStats_HideOnNoTarget == 1) then
			if (hasTarget == 1) then
				if (CombatStats_Config.CombatStats_Hide == 0) then
					CombatStatsFrame:Show();
				end
			else
				CombatStatsFrame:Hide();
			end
		else
			if (CombatStats_Config.CombatStats_Hide == 0) then
				CombatStatsFrame:Show();
			else
				CombatStatsFrame:Hide();
			end
		end						
		
	else
		CombatStatsFrame:Hide();
	end
end

function CombatStats_Reset()

	defcritCount = 0;
	speccritCount= 0;
	timestamps = {};
	players = {};
	dmg = {};
	dpstotals = {};
	defCrits = {0};
	specCrits = {0};
	defCritTotals = {};
	specCritTotals = {};

	totalDamage = 0;

	attackNames = {};
	specialAttacks = {};
	specialAttackLog = {};

	totalHits = 0;
	totalCrits = 0;
	specialsCount = 0;
	bHasDefault = 0;
	
	overallSwings		=	0;
	overallMisses		=	0;
	overallDodged		=	0;
	overallParried		=	0;
	overallEvaded		=	0;
	overallBlocked		=	0;
	overallResisted		=	0;
	overallImmuned		=	0;
	overallDeflected	=	0;
	overallHits			=	0;
	overallNonCrits		=	0;
	overallCrits		=	0;
	overallmaxCrit		=	0;
	overallminCrit		=	0;
	overallmaxReg		=	0;
	overallminReg		=	0;
	overallRegDmg		=	0;
	overallCritDmg		=	0;
	overallLastcrit		=	0;
	
	CombatStatsText:SetText("Overall DPS :: ");
	
	CombatStatsGeneralNameTextLabel:SetText("N/A");
		
		CombatStatsNonCritHitsStatText:SetText("0");	
		CombatStatsNonCritDamageStatText:SetText("0");		
		CombatStatsNonCritMinMaxStatText:SetText("0 / 0");	
		CombatStatsNonCritAvgStatText:SetText("0.0");	
		CombatStatsNonCritPercentDamageStatText:SetText("0.0 %");	
	
		CombatStatsCritHitsStatText:SetText("0");
		CombatStatsCritDamageStatText:SetText("0");
		CombatStatsCritMinMaxStatText:SetText("0 / 0");
		CombatStatsCritAvgStatText:SetText("0.0");
		CombatStatsCritPercentDamageStatText:SetText("0.0 %");
	
		CombatStatsGeneralTotalHitsHits:SetText("0");	
		CombatStatsGeneralSwingsLabel:SetText("0");
			
		CombatStatsGeneralMissesTextLabel:SetText("0");	
		CombatStatsGeneralMissesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralDodgesTextLabel:SetText("0");	
		CombatStatsGeneralDodgesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralParriedTextLabel:SetText("0");	
		CombatStatsGeneralParriedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralBlockedTextLabel:SetText("0");	
		CombatStatsGeneralBlockedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralResistedTextLabel:SetText("0");	
		CombatStatsGeneralResistedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralImmunedTextLabel:SetText("0");	
		CombatStatsGeneralImmunedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralEvadedTextLabel:SetText("0");	
		CombatStatsGeneralEvadedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralPercentDmgPctLabel:SetText("0.0%");
		
		CombatStatsGeneralTimeLastCritTimeLabel:SetText(GREEN_FONT_COLOR_CODE.."N/A");
	
		CombatStatsOverallCritPctLabel:SetText(RED_FONT_COLOR_CODE.."0.0 %");		
		
		CombatStatsAttackNonCritPctLabel:SetText(GREEN_FONT_COLOR_CODE.."0.0 %");		
		CombatStatsAttackCritPctLabel:SetText(RED_FONT_COLOR_CODE.."0.0 %");
		
		UIDropDownMenu_SetText(CS_DROPDOWN_SELECT_TEXT,CombatStatsAttackDropDown);
				
	
end

function CombatStatDPSLen(checked,value)
	CombatStats_DPSLen = value;	
end

-- Register w/ Khaos Config and setup
function CombatStats_RegisterKhaos()
	-- Print("CombatStats_RegisterKhaos",0.0, 1.0, 0.0);

	local localKhaosParseTree = {
		-- String keywords branch into other trees
		["keyword"] = {localKhaosParseTree}; -- IMPORTANT NOTE: KEYWORDS MUST BE LOWERCASE
		
		-- the default keyword is a special case
		default = {localKhaosParseTree}; -- Will get executed only if nothing else matches
		
		enable = {callback = CombatStats_ChatCommandHandler;};
		disable = {callback = CombatStats_ChatCommandHandler;};
		showonlywhentarget = {callback = CombatStats_ChatCommandHandler;};
		showalways = {callback = CombatStats_ChatCommandHandler;};
		statsonmouseover = {callback = CombatStats_ChatCommandHandler;};
		statsonclick = {callback = CombatStats_ChatCommandHandler;};
		endoffight = {callback = CombatStats_ChatCommandHandler;};
		noendoffight = {callback = CombatStats_ChatCommandHandler;};
		hide = {callback = CombatStats_ChatCommandHandler;};
		show = {callback = CombatStats_ChatCommandHandler;};
		hidettip = {callback = CombatStats_ChatCommandHandler;};
		showstats = {callback = CombatStats_ChatCommandHandler;};
		reset = {callback = CombatStats_ChatCommandHandler;};
	};

	local localKhaosSlashCommand = {
		id = "CombatStatsCommands";
		commands = {"/combatstats", "/cbs", "/cs"};
		parseTree = { localKhaosParseTree };
		helpText = "Just a demo function.";
	};

	Khaos.registerOptionSet(
		"combat",
		{
			id = "CombatStats";
			text = COMBATSTATS_CONFIG_HEADER;
			helptext = COMBATSTATS_CONFIG_HEADER_INFO;
			difficulty = 1;
			default = true;
			-- commands = localKhaosSlashCommand;
			options = {
				{
					id = "Header";
					type = K_HEADER;
					text = COMBATSTATS_CONFIG_HEADER;
					helptext = COMBATSTATS_CONFIG_HEADER_INFO;
					difficulty = 1;
					default = false;
				};
				{
					id = "Enable";
					type = K_TEXT;
					text = COMBATSTATS_CONFIG_ONOFF;
					helptext = COMBATSTATS_CONFIG_ONOFF_INFO;
					difficulty = 1;
					check = true;
					callback = function(state) 
						if (state.checked) then
							CombatStats_Watch_OnOff(1);
						else
							CombatStats_Watch_OnOff(0);
						end
					end;
					feedback = function(state)
						if ( state.checked ) then 
							return 'CombatStats is enabled.';
						else
							return 'CombatStats is disabled.';
						end
					end;
					default = {checked = true};
					disabled = {checked = false};
				};
				{
					id = "COMBATSTATS_CONFIG_USEMOUSEOVER";
					type = K_TEXT;
					check = true;
					text = COMBATSTATS_CONFIG_USEMOUSEOVER;
					helptext = COMBATSTATS_CONFIG_USEMOUSEOVER_INFO;
					difficulty = 2;
					feedback = function(state)
						if ( state.checked ) then 
							return "Display on mouseover.";
						else
							return "Don't display on mouseover.";
						end
					end;
					callback = function(state) 
						if (state.checked) then
							CombatStats_UseMouseOver_OnOff(1);
						else
							CombatStats_UseMouseOver_OnOff(0);
						end
					end;
					default = {checked = false};
					disabled = {checked = false};
				};
				{
					id = "COMBATSTATS_HIDEONNOTARGET_ONOFF";
					type = K_TEXT;
					check = true;
					text = COMBATSTATS_CONFIG_HIDEONNOTARGET;
					helptext = COMBATSTATS_CONFIG_HIDEONNOTARGET_INFO;
					difficulty = 2;
					feedback = function(state)
						if ( state.checked ) then 
							return "Will hide on no target.";
						else
							return "Will not hide on no target.";
						end
					end;
					callback = function(state) 
						if (state.checked) then
							CombatStats_HideOnNoTarget_OnOff(1);
						else
							CombatStats_HideOnNoTarget_OnOff(0);
						end
					end;
					default = {checked = false};
					disabled = {checked = false};
				};
				{
					id = "COMBATSTATS_CONFIG_ENDOFFIGHT";
					type = K_TEXT;
					check = true;
					text = COMBATSTATS_CONFIG_ENDOFFIGHT;
					helptext = COMBATSTATS_CONFIG_ENDOFFIGHT_INFO;
					difficulty = 2;
					feedback = function(state)
						if ( state.checked ) then 
							return "Will display stats at end of fight.";
						else
							return "Will not display stats at end of fight.";
						end
					end;
					callback = function(state) 
						CombatStats_EndOfFight_OnOff(state.checked);
					end;
					default = {checked = false;slider = 0};
					disabled = {checked = false;slider = 0};
				};
			};
		}
	);
end

-- Register w/ Cosmos Config and set up a chat watch
function CombatStats_RegisterCosmos()
	if( (Cosmos_RegisterConfiguration ~= nil)) then
		Cosmos_RegisterConfiguration(
			"COMBATSTATS",
			"SECTION",
			COMBATSTATS_CONFIG_HEADER,
			COMBATSTATS_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COMBATSTATS_HEADER",
			"SEPARATOR",
			COMBATSTATS_CONFIG_HEADER,
			COMBATSTATS_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COMBATSTATS_ONOFF", 
			"CHECKBOX",
			COMBATSTATS_CONFIG_ONOFF,
			COMBATSTATS_CONFIG_ONOFF_INFO,
			CombatStats_Watch_OnOff,
			CombatStats_Config.CombatStats_OnOff
			);		
		Cosmos_RegisterConfiguration(
			"COMBATSTATS_USEMOUSEOVER_ONOFF", 
			"CHECKBOX",
			COMBATSTATS_CONFIG_USEMOUSEOVER,
			COMBATSTATS_CONFIG_USEMOUSEOVER_INFO,
			CombatStats_UseMouseOver_OnOff,
			CombatStats_Config.CombatStats_UseMouseOver,
			0
			);
		Cosmos_RegisterConfiguration(
			"COMBATSTATS_HIDEONNOTARGET_ONOFF", 
			"CHECKBOX",
			COMBATSTATS_CONFIG_HIDEONNOTARGET,
			COMBATSTATS_CONFIG_HIDEONNOTARGET_INFO,
			CombatStats_HideOnNoTarget_OnOff,
			CombatStats_Config.CombatStats_HideOnNoTarget
			);	
		Cosmos_RegisterConfiguration(
			"COMBATSTATS_ENDOFFIGHT_ONOFF", 
			"CHECKBOX",
			COMBATSTATS_CONFIG_ENDOFFIGHT,
			COMBATSTATS_CONFIG_ENDOFFIGHT_INFO,
			CombatStats_EndOfFight_OnOff,
			CombatStats_Config.CombatStats_EndOfFight
			);	

						
		Cosmos_RegisterChatCommand (
			"COMBATSTATS_COMMANDS",
			{"/cs", "/combatsats"},
			CombatStats_ChatCommandHandler,
			CS_CHAT_COMMAND_INFO
			);					
	end

end

function ShowLastFightDPS()

	--
	--	Show the last fight DPS
	--
	
	local totalFightTime
	local playerDPS
	local petDPS
	local petPct
	local playerText = "%.1f sec.\nTotal Damage : %d\nOverall Fight DPS : %.1f\n";
	local petText = "Your pet did %d or %.1f%% of your overall damage.\nPet DPS : %.1f";
	local text = "Fight Statistics\nDuration : ";
	
	
	if( (bInCombat == 0) and (lastFightFinish > lastFightStart)) then
			
		totalFightTime = lastFightFinish - lastFightStart;
		petDPS = lastFightPetDamage / totalFightTime;
		playerDPS = lastFightPlayerDamage / totalFightTime;
		
		if(lastFightPetDamge ~= 0) then
			petPct = (lastFightPetDamage / lastFightPlayerDamage) * 100;
		end
		
		text = text ..format(playerText, totalFightTime,lastFightPlayerDamage,playerDPS);
		
		if(lastFightPetDamage ~= 0) then		
			text = text ..format(petText,lastFightPetDamage,petPct,petDPS);		
		end
				
		if(DEFAULT_CHAT_FRAME) then
			
			DEFAULT_CHAT_FRAME:AddMessage(text);
		
		end
			
	end
	
	
end

function CombatStats_OnEvent()

	--
	--	Don't do all this unless
	--	combat stats is turned on
	--

	-- Print(event,1,1,1,ChatFrame2);	

	if(event == "VARIABLES_LOADED") then
		-- Print("Variables Loaded");
		if(CombatStats_Config.CombatStats_OnOff == nil) then
			CombatStats_Config.CombatStats_OnOff = 1;
		end
		if(CombatStats_Config.CombatStats_HideOnNoTarget == nil) then
			CombatStats_Config.CombatStats_HideOnNoTarget = 0;
		end
		if(CombatStats_Config.CombatStats_EndOfFight == nil) then
			CombatStats_Config.CombatStats_EndOfFight = 0;
		end
		if(CombatStats_Config.CombatStats_UseMouseOver == nil) then
			CombatStats_Config.CombatStats_UseMouseOver = 0;
		end
		if(CombatStats_Config.CombatStats_Hide == nil) then
			CombatStats_Config.CombatStats_Hide = 0;
		end
		if(CombatStats_Config.CombatStats_HideTtip == nil) then
			CombatStats_Config.CombatStats_HideTtip = 0;
		end
		
		
		CombatStats_UpdateVisibility();
	
	end
		
		

	if ( not CombatStats_Config.CombatStats_OnOff ) then
		return;
	end
	
			
	if ( (event == "PLAYER_REGEN_ENABLED") or (event == "PLAYER_LEAVE_COMBAT" )) then
		regenEnabled = GetTime();
		if( (lastFightPlayerDamage > 0) and (bInCombat == 1) ) then
			lastFightFinish = GetTime();
			bInCombat = 0;					
			if(CombatStats_Config.CombatStats_EndOfFight == 1) then
				ShowLastFightDPS();
			end
		end
		
	end

--	if (event == "PLAYER_LEAVE_COMBAT") then
--		leaveCombat = GetTime();
--		if( (lastFightPlayerDamage > 0) and (bInCombat == 1) ) then
--			lastFightFinish = GetTime();
--			bInCombat = 0;					
--			if(CombatStats_Config.CombatStats_EndOfFight == 1) then
--				ShowLastFightDPS();
--			end
--		end
--	end
	
	if ( (event == "PLAYER_REGEN_DISABLED" ) or (event == "PLAYER_ENTER_COMBAT")) then	
		if (bInCombat == 0) then
			lastFightStart = GetTime();
 		 	bInCombat = 1;			
			lastFightPlayerDamage = 0;
			lastFightPetDamage = 0;			
		end								
	end	

	if ( event == "CHAT_MSG_SPELL_SELF_BUFF") then
		for damage in string.gfind(arg1, "Your Holy Strength heals you for (%d).") do
			totalProcs = totalProcs +1;
			Print("Total Procs / Swings : ".. totalProcs .." / " .. overallSwings,1,1,1,ChatFrame2);
			return;
		end
	end
	
	local p, d;
	local curtime = GetTime();
	
	if(	event == "CHAT_MSG_COMBAT_SELF_HITS" 
		or event == "CHAT_MSG_COMBAT_SELF_MISSES"
		or event == "CHAT_MSG_SPELL_SELF_DAMAGE"
		or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE"
		or event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"
		) then			

		for creatureName, damage,damageType, spell in string.gfind(arg1, CS_1) do
			CombatStats_AddSpecialData(spell,"dot",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end
		
		for spell, creatureName, damage in string.gfind(arg1, CS_2) do
			CombatStats_AddSpecialData(spell,"hit",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end

		for creatureName, damage in string.gfind(arg1, CS_3) do
			CombatStats_AddSpecialData("Default","hit",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, CS_4) do
			CombatStats_AddSpecialData(spell,"crit",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end
		for creatureName, damage in string.gfind(arg1, CS_5) do
			CombatStats_AddSpecialData("Default","crit",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end
		for creatureName in string.gfind(arg1, CS_6) do
			CombatStats_AddSpecialData("Default","miss",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_7) do
			CombatStats_AddSpecialData("Default","parry",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_8) do
			CombatStats_AddSpecialData("Default","evade",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_9) do
			CombatStats_AddSpecialData("Default","dodge",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_10) do
			CombatStats_AddSpecialData("Default","deflect",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_11) do
			CombatStats_AddSpecialData("Default","block",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_12) do
			CombatStats_AddSpecialData(spell,"block",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_13) do
			CombatStats_AddSpecialData(spell,"deflect",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_14) do
		 if (GetLocale() == "deDE")then local temp = spell;spell = creatureName;creatureName = spell; end
			CombatStats_AddSpecialData(spell,"dodge",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_15) do
			CombatStats_AddSpecialData(spell,"evade",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_16) do
			CombatStats_AddSpecialData(spell,"parry",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_17) do
			CombatStats_AddSpecialData(spell,"resist",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_18) do
			CombatStats_AddSpecialData(spell,"immune",0,curtime);
			return;
		end
		for spell, creatureName in string.gfind(arg1, CS_19) do
			CombatStats_AddSpecialData(spell,"miss",0,curtime);
			return;
		end
		
	end
	
	if(	event == "CHAT_MSG_COMBAT_PET_HITS" ) then
		
		bInCombat = 1;
		
		for petName, creatureName, damage in string.gfind(arg1, CS_20) do
			CombatStats_AddSpecialData("[Pet] Default","crit",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end
		
		for petName, creatureName, damage in string.gfind(arg1, CS_21) do
			CombatStats_AddSpecialData("[Pet] Default","hit",damage,curtime);
			CombatStats_AddDPSEntry("Your", damage);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_PET_DAMAGE") then

		for petName, spell, creatureName, damage in string.gfind(arg1, CS_22) do
			if (GetLocale() == "frFR")then local temp = petName;petName = spell;spell = temp; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"hit",damage,curtime);
				CombatStats_AddDPSEntry("Your", damage);
			end
			return;
		end
		
		for petName, spell, creatureName, damage in string.gfind(arg1, CS_23) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"crit",damage,curtime);
				CombatStats_AddDPSEntry("Your", damage);
			end
			return;
		end
		
		for petName, spell, creatureName in string.gfind(arg1, CS_24) do
			if (GetLocale() == "frFR")then local petName = creatureName; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"block",0,curtime);
			end
			return;
		end
		
		for petName, spell, creatureName in string.gfind(arg1, CS_25) do
			if (GetLocale() == "frFR")then local petName = creatureName; end
			if (GetLocale() == "deDE")then local petName = creatureName; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"dodge",0,curtime);
			end			
			return;
		end
	
		for petName, spell, creatureName in string.gfind(arg1, CS_26) do
			if (GetLocale() == "frFR")then local petName = creatureName; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"evade",0,curtime);
			end			
			return;
		end

		for petName, spell, creatureName in string.gfind(arg1, CS_27) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"immune",0,curtime);
			end						
			return;
		end
	
		for petName, spell, creatureName in string.gfind(arg1, CS_28) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"resist",0,curtime);
			end						
			return;
		end

		for petName, spell, creatureName in string.gfind(arg1, CS_29) do
			if (GetLocale() == "frFR")then local temp = petName;petName = spell;spell = temp; end
			if (GetLocale() == "deDE")then local temp = petName;petName = spell;spell = temp; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"miss",0,curtime);
			end						
			return;
			
		end
		
		for petName, spell, creatureName in string.gfind(arg1, CS_30) do
			if (GetLocale() == "frFR")then local temp = petName;petName = spell;spell = temp; end
			if (GetLocale() == "deDE")then local temp = petName;petName = spell;spell = temp; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"miss",0,curtime);
			end						
			return;
		end
		
		for petName, spell, creatureName in string.gfind(arg1, CS_31) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"immune",0,curtime);
			end
			return;
		end
		for petName, spell, creatureName in string.gfind(arg1, CS_32) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"miss",0,curtime);
			end
			return;
		end
		for petName, spell, creatureName in string.gfind(arg1, CS_33) do
			if (GetLocale() == "frFR")then local petName = creatureName; end
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] "..spell,"deflect",0,curtime);
			end
			return;
		end
		
	end
	
	if (event == "CHAT_MSG_COMBAT_PET_MISSES") then

		bInCombat = 1;	
	
		for petName, creatureName in string.gfind(arg1, CS_34) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] Default","miss",0,curtime);
			end	
			return;
		end
		
		for petName, creatureName in string.gfind(arg1, CS_35) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] Default","parry",0,curtime);
			end
			return;
		end
		for petName, creatureName in string.gfind(arg1, CS_36) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] Default","evade",0,curtime);
			end
			return;
		end
		for petName, creatureName in string.gfind(arg1, CS_37) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] Default","dodge",0,curtime);
			end
			return;
		end
		for petName, creatureName in string.gfind(arg1, CS_38) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] Default","deflect",0,curtime);
			end
			return;
		end
		for petName, creatureName in string.gfind(arg1, CS_39) do
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatStats_AddSpecialData("[Pet] Default","block",0,curtime);
			end
			return;
		end
		
		
	end
	
	if(event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") then

		bInCombat = 1;
	
		for creatureName, damage,tmpStr in string.gfind(arg1, CS_40) do
			CombatStats_AddDefDPSEntry("Your",damage);
			CombatStats_AddSpecialData("Defensive","hit",damage,curtime);
			CombatStats_AddSpecialData("Defensive","block",0,curtime);			
			return;
		end
		for creatureName, damage in string.gfind(arg1, CS_41) do
			CombatStats_AddDefDPSEntry("Your",damage);
			CombatStats_AddSpecialData("Defensive","hit",damage,curtime);			
			return;
		end
		for creatureName, damage in string.gfind(arg1, CS_42) do
			CombatStats_AddDefDPSEntry("Your",damage);
			CombatStats_AddSpecialData("Defensive","crit",damage,curtime);
			return;
		end
	
	end
	
	if( event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE") then

		for creatureName, spell, damage in string.gfind(arg1, CS_43) do
			if (GetLocale() == "frFR")then local temp = creatureName;creatureName = spell;spell = temp; end
			CombatStats_AddDefDPSEntry("Your",damage);
			CombatStats_AddSpecialData("Defensive","hit",damage,curtime);
			return;
		end
		
		for creatureName, spell, damage in string.gfind(arg1, CS_44) do
			CombatStats_AddDefDPSEntry("Your",damage);
			CombatStats_AddSpecialData("Defensive","crit",damage,curtime);
			return;
		end
		
		for creatureName, spell in string.gfind(arg1, CS_45) do
			CombatStats_AddSpecialData("Defensive","block",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_46) do
			CombatStats_AddSpecialData("Defensive","deflect",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_47) do
			CombatStats_AddSpecialData("Defensive","dodge",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_48) do
			CombatStats_AddSpecialData("Defensive","evade",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_49) do
			CombatStats_AddSpecialData("Defensive","immune",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_50) do
			CombatStats_AddSpecialData("Defensive","miss",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_51) do
			CombatStats_AddSpecialData("Defensive","parry",0,curtime);
			return;
		end
		for creatureName, spell in string.gfind(arg1, CS_52) do
			CombatStats_AddSpecialData("Defensive","resist",0,curtime);
			return;
		end
	end
	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES") then

		
		for creatureName in string.gfind(arg1, CS_53) do
			CombatStats_AddSpecialData("Defensive","miss",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_54) do
			CombatStats_AddSpecialData("Defensive","parry",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_55) do
			CombatStats_AddSpecialData("Defensive","evade",0,curtime);			
			return;
		end
		for creatureName in string.gfind(arg1, CS_56) do
			CombatStats_AddSpecialData("Defensive","dodge",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_57) do
			CombatStats_AddSpecialData("Defensive","deflect",0,curtime);
			return;
		end
		for creatureName in string.gfind(arg1, CS_58) do
			CombatStats_AddSpecialData("Defensive","block",0,curtime);
			return;
		end
	end
end

--
--	Add/Check for attack(s)
--

function CombatStats_AddSpecialData(specialName,type,dmg,time)
	
	--
	--	If we haven't logged this attack
	--	Create a record in the table for it
	--		

	-- Print("Adding : "..specialName .." with damage : "..dmg.."at : "..time);	
			
	if(specialName ~= "Defensive") then
		lastFightPlayerDamage = lastFightPlayerDamage + dmg;
		totalDamage = totalDamage + dmg;
	end
	
	for creatureName,tempJunk in string.gfind(specialName, "(.+)Pet(.+)") do
	--	Print("creatureName : "..creatureName);
	--	Print("tempJunk : "..tempJunk);
	--	Print("Adding pet special : "..specialName.. " with damage of : "..dmg);
		lastFightPetDamage = lastFightPetDamage + dmg;
	end
	
	if (type == "dot") then
		specialName = specialName .." [DOT]";
	end
	
	if(specialName == "Default") then
		bHasDefault = 1;
	end
	
	if ( not specialAttacks[specialName] ) then
		specialsCount = specialsCount + 1;
		table.insert(attackNames,specialName);
		
		specialAttackLog[specialsCount] = {
			index				 = 	specialsCount,
			name				 = 	specialName,
			isDOT				 = 	0,
			dotDmg				 = 	0,
			dotTicks			 = 	0,
			totalSwings			 = 	0,
			totalMisses			 = 	0,
			totalDodged			 = 	0,
			totalParried		 = 	0,
			totalEvaded			 = 	0,
			totalBlocked		 = 	0,
			totalResisted		 = 	0,
			totalImmuned		 = 	0,
			totalDeflected		 = 	0,
			totalHits			 = 	0,
			totalNonCrits		 = 	0,
			totalCrits			 = 	0,
			maxCrit				 = 	0,
			minCrit				 = 	0,
			maxReg				 = 	0,
			minReg				 = 	0,
			totalRegDmg			 = 	0,
			totalCritDmg		 = 	0,
			lastCrit			 = 	0,
		}
		
		specialAttacks[specialName]	 = specialAttackLog[specialsCount];
		
		local info;
		
		info = {};
		info.text = specialName;
		info.func = CombatStatsAttack_OnClick;
		CombatStats_AddButton(info);
				
	end
	
	--
	--	Now add the data
	--
	
	if(specialName ~= "Defensive") then	
	
		specialAttacks[specialName].totalSwings = specialAttacks[specialName].totalSwings + 1;
		overallSwings = overallSwings + 1;
	
		if(type == "crit") then
		
			totalHits = totalHits + 1;
			totalCrits = totalCrits + 1;
			specialAttacks[specialName].totalCrits = specialAttacks[specialName].totalCrits +1;
			specialAttacks[specialName].totalCritDmg = specialAttacks[specialName].totalCritDmg + dmg;
			specialAttacks[specialName].lastCrit = time;	
			specialAttacks[specialName].totalHits = specialAttacks[specialName].totalHits + 1;
		
			overallCrits = overallCrits + 1;
			overallCritDmg = overallCritDmg + dmg;
			overallLastcrit = time;
				
			--
			--	Set the initial min/max		
			--
		
			if(specialAttacks[specialName].maxCrit == 0) then
				specialAttacks[specialName].maxCrit = dmg;
			end
		
			if(specialAttacks[specialName].minCrit == 0) then
				specialAttacks[specialName].minCrit = dmg;
			end
		
			if(overallmaxCrit == 0) then
				overallmaxCrit = dmg;
			end
		
			if(overallminCrit == 0) then
				overallminCrit = dmg;
			end
		
			--
			--	Check to see if this dmg
			--	is a new min or max
			--
				
			if(tonumber(dmg) < tonumber(specialAttacks[specialName].minCrit)) then
				specialAttacks[specialName].minCrit = dmg;
			end
		
			if(tonumber(dmg) > tonumber(specialAttacks[specialName].maxCrit)) then
				specialAttacks[specialName].maxCrit = dmg;
			end	
		
			if(tonumber(dmg) < tonumber(overallminCrit)) then
				overallminCrit = dmg;
			end
		
			if(tonumber(dmg) > tonumber(overallmaxCrit)) then
				overallmaxCrit = dmg;
			end	
		
		end
	
		if(type == "hit") then
		
			totalHits = totalHits + 1;
			specialAttacks[specialName].isDOT = 0;
			specialAttacks[specialName].totalNonCrits = specialAttacks[specialName].totalNonCrits +1;
			specialAttacks[specialName].totalRegDmg = specialAttacks[specialName].totalRegDmg + dmg;
			specialAttacks[specialName].totalHits = specialAttacks[specialName].totalHits + 1;
		
			overallNonCrits = overallNonCrits + 1;
			overallRegDmg = overallRegDmg + dmg;
		
			--
			--	Set the initial min/max		
			--
		
			if(specialAttacks[specialName].maxReg == 0) then
				specialAttacks[specialName].maxReg = dmg;
			end
		
			if(specialAttacks[specialName].minReg == 0) then
				specialAttacks[specialName].minReg = dmg;
			end
		
			if(overallmaxReg == 0) then
				overallmaxReg = dmg;
			end
		
			if(overallminReg == 0) then
				overallminReg = dmg;
			end
		
			--
			--	Check to see if this dmg
			--	is a new min or max
			--
		
			if(tonumber(dmg) < tonumber(specialAttacks[specialName].minReg)) then
				specialAttacks[specialName].minReg = dmg;
			end
		
			if(tonumber(dmg) > tonumber(specialAttacks[specialName].maxReg)) then
				specialAttacks[specialName].maxReg = dmg;
			end
		
			if(tonumber(dmg) < tonumber(overallminReg)) then
				overallminReg = dmg;
			end
		
			if(tonumber(dmg) > tonumber (overallmaxReg)) then
				overallmaxReg = dmg;
			end	
		
		end
	
		if(type == "dot") then
		
			totalHits = totalHits + 1;
			specialAttacks[specialName].isDOT = 1;
			specialAttacks[specialName].dotTicks = specialAttacks[specialName].dotTicks +1;
			specialAttacks[specialName].dotDmg = specialAttacks[specialName].dotDmg + dmg;
			specialAttacks[specialName].totalHits = specialAttacks[specialName].totalHits + 1;		
		
			overallNonCrits = overallNonCrits + 1;
			overallRegDmg = overallRegDmg + dmg;
		
			--
			--	Set the initial min/max		
			--
		
			if(specialAttacks[specialName].maxReg == 0) then
				specialAttacks[specialName].maxReg = dmg;
			end
			
			if(specialAttacks[specialName].minReg == 0) then
				specialAttacks[specialName].minReg = dmg;
			end
		
			if(overallmaxReg == 0) then
				overallmaxReg = dmg;
			end
		
			if(overallminReg == 0) then
				overallminReg = dmg;
			end
		
			--
			--	Check to see if this dmg
			--	is a new min or max
			--
		
			if(tonumber(dmg) < tonumber(specialAttacks[specialName].minReg)) then
				specialAttacks[specialName].minReg = dmg;
			end
		
			if(tonumber(dmg) > tonumber(specialAttacks[specialName].maxReg)) then
				specialAttacks[specialName].maxReg = dmg;
			end
		
			if(tonumber(dmg) < tonumber(overallminReg)) then
				overallminReg = dmg;
			end
		
			if(tonumber(dmg) > tonumber (overallmaxReg)) then
				overallmaxReg = dmg;
			end	
		
		end
	 
		if(type == "miss") then
		
			specialAttacks[specialName].totalMisses = 	specialAttacks[specialName].totalMisses + 1;
			overallMisses = overallMisses +1;
			
		end
	
		if(type == "dodge") then
			
			specialAttacks[specialName].totalDodged = 	specialAttacks[specialName].totalDodged + 1;
			overallDodged = overallDodged + 1;
		
		end
	
		if(type == "parry") then
			
			specialAttacks[specialName].totalParried = 	specialAttacks[specialName].totalParried + 1;
			overallParried = overallParried + 1;
		
		end
	
		if(type == "block") then
		
			specialAttacks[specialName].totalBlocked = 	specialAttacks[specialName].totalBlocked + 1;
			overallBlocked = overallBlocked + 1;
	
		end
	
		if(type == "evade") then
		
			specialAttacks[specialName].totalEvaded = 	specialAttacks[specialName].totalEvaded + 1;
			overallEvaded = overallEvaded + 1;
		
		end
	
		if(type == "resist") then
			
			specialAttacks[specialName].totalResisted = 	specialAttacks[specialName].totalResisted + 1;
			overallResisted = overallResisted + 1;
			
		end
	
		if(type == "immune") then
		
			specialAttacks[specialName].totalImmuned = 	specialAttacks[specialName].totalImmuned + 1;
			overallImmuned = overallImmuned + 1;
		
		end
	
		if(type == "deflect") then
			
			specialAttacks[specialName].totalDeflected = 	specialAttacks[specialName].totalDeflected + 1;
			overallDeflected = overallDeflected + 1;
		
		end
	
	else
	
		--
		--	Defesnsive info
		--	Don't add to overall stats and overa
		--
		
		specialAttacks[specialName].totalSwings = specialAttacks[specialName].totalSwings + 1;
		
		if(type == "crit") then
		
			specialAttacks[specialName].totalCrits = specialAttacks[specialName].totalCrits +1;
			specialAttacks[specialName].totalCritDmg = specialAttacks[specialName].totalCritDmg + dmg;
			specialAttacks[specialName].lastCrit = time;	
			specialAttacks[specialName].totalHits = specialAttacks[specialName].totalHits + 1;
						
			--
			--	Set the initial min/max		
			--
		
			if(specialAttacks[specialName].maxCrit == 0) then
				specialAttacks[specialName].maxCrit = dmg;
			end
		
			if(specialAttacks[specialName].minCrit == 0) then
				specialAttacks[specialName].minCrit = dmg;
			end
				
			--
			--	Check to see if this dmg
			--	is a new min or max
			--
				
			if(tonumber(dmg) < tonumber(specialAttacks[specialName].minCrit)) then
				specialAttacks[specialName].minCrit = dmg;
			end
		
			if(tonumber(dmg) > tonumber(specialAttacks[specialName].maxCrit)) then
				specialAttacks[specialName].maxCrit = dmg;
			end			
		
		end
	
		if(type == "hit") then
		
			specialAttacks[specialName].isDOT = 0;
			specialAttacks[specialName].totalNonCrits = specialAttacks[specialName].totalNonCrits +1;
			specialAttacks[specialName].totalRegDmg = specialAttacks[specialName].totalRegDmg + dmg;
			specialAttacks[specialName].totalHits = specialAttacks[specialName].totalHits + 1;
				
			--
			--	Set the initial min/max		
			--
		
			if(specialAttacks[specialName].maxReg == 0) then
				specialAttacks[specialName].maxReg = dmg;
			end
		
			if(specialAttacks[specialName].minReg == 0) then
				specialAttacks[specialName].minReg = dmg;
			end
			
			--
			--	Check to see if this dmg
			--	is a new min or max
			--
		
			if(tonumber(dmg) < tonumber(specialAttacks[specialName].minReg)) then
				specialAttacks[specialName].minReg = dmg;
			end
		
			if(tonumber(dmg) > tonumber(specialAttacks[specialName].maxReg)) then
				specialAttacks[specialName].maxReg = dmg;
			end			
		
		end
		
		if(type == "miss") then		
			specialAttacks[specialName].totalMisses = 	specialAttacks[specialName].totalMisses + 1;
		end
	
		if(type == "dodge") then
			specialAttacks[specialName].totalDodged = 	specialAttacks[specialName].totalDodged + 1;
		end
	
		if(type == "parry") then
			specialAttacks[specialName].totalParried = 	specialAttacks[specialName].totalParried + 1;
		end
	
		if(type == "block") then
			specialAttacks[specialName].totalBlocked = 	specialAttacks[specialName].totalBlocked + 1;
		end
	
		if(type == "evade") then
			specialAttacks[specialName].totalEvaded = 	specialAttacks[specialName].totalEvaded + 1;
		end
	
		if(type == "resist") then
			specialAttacks[specialName].totalResisted = 	specialAttacks[specialName].totalResisted + 1;
		end
	
		if(type == "immune") then
			specialAttacks[specialName].totalImmuned = 	specialAttacks[specialName].totalImmuned + 1;
		end
	
		if(type == "deflect") then
			specialAttacks[specialName].totalDeflected = 	specialAttacks[specialName].totalDeflected + 1;
		end
		
	end
						
end

-- CombatStats Event Watcher
--
-- Update Handler
--

function CombatStats_OnUpdate()
	local curtime = GetTime();
	local oldesttime = 0;
	local oldesttimeTaken = 0;
	local deleteindex = 0;
	local deleteindexTaken = 0;
	local playerFrame;
	
	-- Print("In Combat == " ..bInCombat);

	if (bInCombat == 1) then

		-- Check to see if its time to update the on screen DPS and only update if there are dps entries to save CPU
		if ( ((curtime - CombatStats_LastUpdate) > CombatStats_UpdateFreq) and (table.getn(timestamps) > 0) ) then
	
			-- TODO: Change this to a high to low loop so we can do our subtracts and deletes in the same run
			
			--
			--	Offensive
			--
		
			for k,v in pairs(timestamps) do
				
				-- Get rid of old dps entries and adjust the totals				
				if ( (curtime - CombatStats_DPSLen) > v ) then

					-- Subtract this entry from the totals
					dpstotals[players[k]] = dpstotals[players[k]] - dmg[k];					
				
					-- Mark for later removal *We can't do the remove here cause table.remove reindexes the list and bones our loop
					deleteindex = k;
				else
					-- were into the good stuff now, stop
					oldesttime = v;
					break;
				end
			end
					
			
			-- Remove entries from deleteindex down so we don't miss em
			while (deleteindex > 0) do
				table.remove(timestamps, deleteindex);
				table.remove(players, deleteindex);
				table.remove(dmg, deleteindex);
				deleteindex = deleteindex -1;
			end
			
		end
			
		if ( ((curtime - CombatStats_LastUpdate) > CombatStats_UpdateFreq) and (table.getn(takenTimestamps) > 0) ) then
		
			--
			--	Defensive
			--
			
			for w,y in pairs(takenTimestamps) do
			
				-- Get rid of old dps entries and adjust the totals				
				if ( (curtime - CombatStats_DPSLen) > y ) then

					-- Subtract this entry from the totals
					dpsTakenTotals[playersTaken[w]] = dpsTakenTotals[playersTaken[w]] - dmgTaken[w];
			
					-- Mark for later removal *We can't do the remove here cause table.remove reindexes the list and bones our loop
					deleteindexTaken = w;
				else
					-- were into the good stuff now, stop
					oldesttimeTaken = y;
					break;
				end
			end
			
			-- Remove entries from deleteindex down so we don't miss em
			while (deleteindexTaken > 0) do
				table.remove(takenTimestamps, deleteindexTaken);
				table.remove(playersTaken, deleteindexTaken);
				table.remove(dmgTaken, deleteindexTaken);
				deleteindexTaken = deleteindexTaken -1;
			end
			
		end
	
				
			-- NOTE: Everyone calcs off the same oldest time, not their own oldest time.
			-- This should give more accurate dps on a per group fight basis.

	
		if ( ((curtime - CombatStats_LastUpdate) > CombatStats_UpdateFreq) and (table.getn(timestamps) > 0) ) then
			
			--local text = "CurTime - Oldesettime : %.1f";
			--text = format(text,(curtime - oldesttime));
			-- Print(text);
			
			-- Update player DPS
			if ( dpstotals["Your"] ~= nil ) then
					if(dpsTakenTotals["Your"] ~= nil) then	
						globalTaken = (dpsTakenTotals["Your"] / (curtime - oldesttimeTaken) );
						globalDone = (dpstotals["Your"] / (curtime - oldesttime) );
						if(CombatStatsFrame:IsVisible()) then							
							CombatStatsText:SetText( RED_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), (dpsTakenTotals["Your"] / (curtime - oldesttimeTaken) )) ..NORMAL_FONT_COLOR_CODE.. " / " ..GREEN_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), (dpstotals["Your"] / (curtime - oldesttime) )) );
						end
						if(InfoBarFrame ~= nil) then
							if(IB_CombatStats:IsVisible()) then
								IB_CombatStatsCenteredText:SetText( RED_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), (dpsTakenTotals["Your"] / (curtime - oldesttimeTaken) )) ..NORMAL_FONT_COLOR_CODE.. " / " ..GREEN_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), (dpstotals["Your"] / (curtime - oldesttime) )) );
							end
						end
					else	
						globalTaken = 0.0;
						globalDone = (dpstotals["Your"] / (curtime - oldesttime) );
						if(CombatStatsFrame:IsVisible()) then
							CombatStatsText:SetText( RED_FONT_COLOR_CODE.. "0.0" ..NORMAL_FONT_COLOR_CODE.. " / " ..GREEN_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), (dpstotals["Your"] / (curtime - oldesttime) )) );
						end
						if(InfoBarFrame ~= nil) then					
							if(IB_CombatStats:IsVisible()) then
								IB_CombatStatsCenteredText:SetText( RED_FONT_COLOR_CODE.. "0.0" ..NORMAL_FONT_COLOR_CODE.. " / " ..GREEN_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), (dpstotals["Your"] / (curtime - oldesttime) )) );
							end							
						end
					end
					
				
			end

			CombatStats_LastUpdate = curtime;
		end
		
		--
		--	If the data frame is visible
		--	update the selected attack "Real time"
		--
		
		if (CombatStatsDataFrame:IsVisible()) then
			
			if( UIDropDownMenu_GetText(CombatStatsAttackDropDown) ~= CS_DROPDOWN_SELECT_TEXT) then
				CombatStats_UpdateDetails( UIDropDownMenu_GetText(CombatStatsAttackDropDown));
			end
		end
		
	end
end

-- Called from XML
function CombatStats_OnLoad()
	
	if (Sea == nil) then
		CombatStats_Old_TargetFrame_OnShow = TargetFrame_OnShow;
		CombatStats_Old_TargetFrame_OnHide = TargetFrame_OnHide;
		TargetFrame_OnShow = CombatStats_TargetFrame_OnShow;
		TargetFrame_OnHide = CombatStats_TargetFrame_OnHide;			
	else
		Sea.util.hook("TargetFrame_OnShow", "CombatStats_TargetFrame_OnShow", "after");
		Sea.util.hook("TargetFrame_OnHide", "CombatStats_TargetFrame_OnHide", "after");
	end
		
	if (not Print) then
		setglobal("Print", function(msg, r, g, b, frame, id)
			if (not r) then r = 1.0; end
			if (not g) then g = 1.0; end
			if (not b) then b = 1.0; end
			if (not frame) then frame = DEFAULT_CHAT_FRAME; end
			if (frame) then
				if (not id) then
					frame:AddMessage(msg,r,g,b);
				else
					frame:AddMessage(msg,r,g,b,id);
				end
			end
		end);
	end

	if (not print1) then
		setglobal("print1", function(msg, r, g, b, frame, id)
			Print(join(arg,""), 1.0, 1.0, 0.0, ChatFrame1);
		end);
	end

	if (not print2) then
		setglobal("print2", function(msg, r, g, b, frame, id)
			Print(join(arg,""), 1.0, 1.0, 0.0, ChatFrame2);
		end);
	end
	
	if ( Khaos ) then 
		CombatStats_RegisterKhaos();
	elseif ( Cosmos_RegisterConfiguration ~= nil) then 
		CombatStats_RegisterCosmos();
	else
	-- Standalone (chatwatch)
		SLASH_CSSLASH1 = "/combatstats";
		SLASH_CSSLASH2 = "/cs";	
		SlashCmdList["CSSLASH"] = CombatStats_ChatCommandHandler;
					
	end

	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");

	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");	
	this:RegisterEvent("CHAT_MSG_COMBAT_LOG_ENEMY");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");

	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_ITEM_ENCHANTMENTS");

	this:RegisterEvent("VARIABLES_LOADED");
		
	CombatStatsText:SetText("DPS :: --");
	
	-- Print("Combat Stats Loaded\n"..RED_FONT_COLOR_CODE.."NOTE : The DPS meter is not an indication of your overall DPS for session/fight/mob. It is there as a quick snapshot indication of your DPS over a sliding 30 second window while you are in combat."..NORMAL_FONT_COLOR_CODE);
	-- Print("Hide : "..CombatStats_Config.CombatStats_Hide);
	-- Print("\nOnOff : "..CombatStats_Config.CombatStats_OnOff);
	--CombatStats_Config.CombatStats_HideOnNoTarget = 0;
	--CombatStats_Config.CombatStats_EndOfFight = 0;
	--CombatStats_Config.CombatStats_UseMouseOver = 0;
	--CombatStats_Config.CombatStats_Hide = 0;
end

function IB_CombatStatsOnLoad()

	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");	
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");

	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");	
	this:RegisterEvent("CHAT_MSG_COMBAT_LOG_ENEMY");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");

	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_ITEM_ENCHANTMENTS");

	
	this:RegisterEvent("VARIABLES_LOADED");
	if(InfoBarFrame ~= nil) then
		IB_CombatStatsCenteredText:SetText("DPS :: --");	
	end
end

function TB_CombatStatsOnLoad()

	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");	
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");

	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");	
	this:RegisterEvent("CHAT_MSG_COMBAT_LOG_ENEMY");
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");

	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_ITEM_ENCHANTMENTS");

	this.registry = {
		id = "CombatStats",
		menuText = CS_TB_MENU_TEXT,
		buttonTextFunction = "TB_GetText",
		frequency = TB_DPS_FREQUENCTY,	
		updateType = TITAN_PANEL_UPDATE_BUTTON,	
	}
	
	this:RegisterEvent("VARIABLES_LOADED");
	
end

function TB_GetText(id)
	local button,id = TitanUtils_GetButton(id,true);
	return (RED_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), globalTaken) ..NORMAL_FONT_COLOR_CODE.. " / " ..GREEN_FONT_COLOR_CODE.. format(TEXT(DPS_DISPLAY), globalDone ));
end

function TitanPanelCombatStatsButton_ToggleDisplay()
	TitanPanelButton_UpdateButton("CombatStats");
end

function IB_CombatStats_OnClick()

	local attackID = this:GetID();
			
	UIDropDownMenu_SetSelectedID(CombatStatsAttackDropDown, attackID);	
	local attackName = UIDropDownMenu_GetText(CombatStatsAttackDropDown);
	UIDropDownMenu_SetSelectedValue(CombatStatsAttackDropDown, attackName);
	UIDropDownMenu_SetText(attackName,CombatStatsAttackDropDown);
	
	CombatStats_UpdateDetails(attackName);
end

function CombatStatsAttack_OnClick()
		
	local attackID = this:GetID();
			
	UIDropDownMenu_SetSelectedID(CombatStatsAttackDropDown, attackID);	
	local attackName = UIDropDownMenu_GetText(CombatStatsAttackDropDown);
	UIDropDownMenu_SetSelectedValue(CombatStatsAttackDropDown, attackName);
	UIDropDownMenu_SetText(attackName,CombatStatsAttackDropDown);
	
	CombatStats_UpdateDetails(attackName);
	
end

function CombatStatsAttackDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CombatStatsAttackDropDown_Initialize);
end

function CombatStatsAttackDropDown_Initialize()
	CombatStats_Menu = {};
	CombatStats_LoadAttackNames();

	for i = 1, 30 do
		if ( CombatStats_Menu[i] ) then
			UIDropDownMenu_AddButton(CombatStats_Menu[i]);
		end
	end
end

function CombatStats_LoadAttackNames()

	local info;
	
	if(table.getn(attackNames) ~= 0) then	
		if(bHasDefault == 1) then
			info = {};
			info.text = "Default";
			info.func = CombatStatsAttack_OnClick;
			CombatStats_AddButton(info);
		end
	end
	
	for i = 1, table.getn(attackNames), 1 do
		
		if(attackNames[i] ~= "Default") then	
			info = {};
			info.text = attackNames[i];
			info.func = CombatStatsAttack_OnClick;
			CombatStats_AddButton(info);
		end
		
	end
	
	if(table.getn(attackNames) ~= 0) then		
		info = {};
		info.text = "Total";
		info.func = CombatStatsAttack_OnClick;
		CombatStats_AddButton(info);
	end
			
end

--
--	Add the damage to the DPS table
--

function CombatStats_AddDPSEntry(p, d)
	
	
	table.insert(timestamps, GetTime());
	table.insert(players, p);
	table.insert(dmg, d);

--	Print("Adding Entry[" .. p .. "] = " .. d);	-- debug

	-- Keep running totals on group members to shorten calculation times
	-- We'll subtract off the expired entries during OnUpdate				
	if (dpstotals[p] == nil) then
	--	Print("dpstotals[p] == nil");
		dpstotals[p] = d;
	else
	--	Print("dpstotals[p] == " ..dpstotals[p] );
		dpstotals[p] = dpstotals[p] + d;
	--	Print("AFTER : dpstotals[p] == " ..dpstotals[p] );
	end
	
	-- Print("Total : " ..dpstotals[p]);
end

--
--	Add damage taken to the DPS table
--

function CombatStats_AddDefDPSEntry(p, d)

	-- Print("Adding Entry[" .. p .. "] = " .. d);	-- debug
	table.insert(takenTimestamps, GetTime());
	table.insert(playersTaken, p);
	table.insert(dmgTaken, d);

	-- Keep running totals on group members to shorten calculation times
	-- We'll subtract off the expired entries during OnUpdate				
	if (dpsTakenTotals[p] == nil) then
	--	Print("dpstotals[p] == nil");
		dpsTakenTotals[p] = d;
	else
	--	Print("dpstotals[p] == " ..dpstotals[p] );
		dpsTakenTotals[p] = dpsTakenTotals[p] + d;
	--	Print("AFTER : dpstotals[p] == " ..dpstotals[p] );
	end
	
	-- Print("Total : " ..dpstotals[p]);
end

--	Show the stats collected

function IB_CombatStats_OnClick()

 if (CombatStatsDataFrame:IsVisible()) then 
 	CombatStatsDataFrame:Hide();
 else
		if (CombatStats_Config.CombatStats_UseMouseOver == 0) then
			CombatStatsText_ShowFrame();
		end
	end
end

function CombatStatsText_OnClick()

 if (CombatStatsDataFrame:IsVisible()) then 
 	CombatStatsDataFrame:Hide();
 else
		if (CombatStats_Config.CombatStats_UseMouseOver == 0) then
			CombatStatsText_ShowFrame();
		end
	end
end

function IB_CombatStatsText_OnEnter()
	CombatStatsText_ShowFrame();
end

function CombatStatsText_OnEnter()
	if (CombatStats_Config.CombatStats_UseMouseOver == 1) then
		CombatStatsText_ShowFrame();
	end
end

function CombatStatsText_ShowFrame()
	
	if(bFirstTime == 1) then
		
		--
		--	Set all the default values
		--
		
		CombatStatsGeneralNameLabel:SetText(TEXT(CS_FRAME_GEN_ATTACK_NAME));	
		CombatStatsGeneralHitsTextLabel:SetText(CS_FRAME_HITS_TEXT);
		CombatStatsGeneralSwingsTextLabel:SetText(CS_FRAME_SWINGS_TEXT);
		CombatStatsGeneralMissesLabel:SetText(CS_FRAME_MISSES_TEXT);
		CombatStatsGeneralDodgesLabel:SetText(CS_FRAME_DODGES_TEXT);
		CombatStatsGeneralParriedLabel:SetText(CS_FRAME_PARRIES_TEXT);
		CombatStatsGeneralBlockedLabel:SetText(CS_FRAME_BLOCKS_TEXT);
		CombatStatsGeneralResistedLabel:SetText(CS_FRAME_RESISTS_TEXT);
		CombatStatsGeneralImmunedLabel:SetText(CS_FRAME_IMMUNE_TEXT);
		CombatStatsGeneralEvadedLabel:SetText(CS_FRAME_EVADES_TEXT );
		CombatStatsGeneralDeflectedLabel:SetText(CS_FRAME_DEFLECTS_TEXT);
		CombatStatsGeneralPercentDmgLabel:SetText(CS_FRAME_PERCENT_OVERALL_TEXT);
		CombatStatsGeneralTimeLastCritLabel:SetText(CS_FRAME_TIME_LASTCRIT_TEXT);
		
		CombatStatsNonCritHitsLabel:SetText(CS_FRAME_TOTAL_TEXT);
		CombatStatsNonCritDamageLabel:SetText(CS_FRAME_DAMAGE_TEXT);
		CombatStatsNonCritMinMaxLabel:SetText(CS_FRAME_MINMAX_TEXT);
		CombatStatsNonCritAvgLabel:SetText(CS_FRAME_AVGDMG_TEXT);
		CombatStatsNonCritPercentDamageLabel:SetText(CS_FRAME_PERCENTDMG_TEXT);
		
		CombatStatsCritHitsLabel:SetText(CS_FRAME_TOTAL_TEXT);
		CombatStatsCritDamageLabel:SetText(CS_FRAME_DAMAGE_TEXT);
		CombatStatsCritMinMaxLabel:SetText(CS_FRAME_MINMAX_TEXT);
		CombatStatsCritAvgLabel:SetText(CS_FRAME_AVGDMG_TEXT);
		CombatStatsCritPercentDamageLabel:SetText(CS_FRAME_PERCENTDMG_TEXT);
		
		CombatStatsGeneralNameTextLabel:SetText("N/A");
		
		CombatStatsNonCritHitsStatText:SetText("0");	
		CombatStatsNonCritDamageStatText:SetText("0");		
		CombatStatsNonCritMinMaxStatText:SetText("0 / 0");	
		CombatStatsNonCritAvgStatText:SetText("0.0");	
		CombatStatsNonCritPercentDamageStatText:SetText("0.0 %");	
	
		CombatStatsCritHitsStatText:SetText("0");
		CombatStatsCritDamageStatText:SetText("0");
		CombatStatsCritMinMaxStatText:SetText("0 / 0");
		CombatStatsCritAvgStatText:SetText("0.0");
		CombatStatsCritPercentDamageStatText:SetText("0.0 %");
	
		CombatStatsGeneralTotalHitsHits:SetText("0");	
		CombatStatsGeneralSwingsLabel:SetText("0");
			
		CombatStatsGeneralMissesTextLabel:SetText("0");	
		CombatStatsGeneralMissesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralDodgesTextLabel:SetText("0");	
		CombatStatsGeneralDodgesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralParriedTextLabel:SetText("0");	
		CombatStatsGeneralParriedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralBlockedTextLabel:SetText("0");	
		CombatStatsGeneralBlockedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralResistedTextLabel:SetText("0");	
		CombatStatsGeneralResistedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralImmunedTextLabel:SetText("0");	
		CombatStatsGeneralImmunedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralEvadedTextLabel:SetText("0");	
		CombatStatsGeneralEvadedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralDeflectedTextLabel:SetText("0");
		CombatStatsGeneralDeflectedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		
		CombatStatsGeneralPercentDmgPctLabel:SetText("0.0%");
		
		CombatStatsGeneralTimeLastCritTimeLabel:SetText(GREEN_FONT_COLOR_CODE.."N/A");
	
		CombatStatsOverallCritPctLabel:SetText(RED_FONT_COLOR_CODE.."0.0 %");		
		
		CombatStatsAttackNonCritPctLabel:SetText(GREEN_FONT_COLOR_CODE.."0.0 %");		
		CombatStatsAttackCritPctLabel:SetText(RED_FONT_COLOR_CODE.."0.0 %");
		
		UIDropDownMenu_SetText(CS_DROPDOWN_SELECT_TEXT,CombatStatsAttackDropDown);
		
		bFirstTime = 0;
		
	end
	
	if( UIDropDownMenu_GetText(CombatStatsAttackDropDown) ~= CS_DROPDOWN_SELECT_TEXT) then
		
		CombatStats_UpdateDetails( UIDropDownMenu_GetText(CombatStatsAttackDropDown));
		
	end
	
	
	CombatStatsDataFrame:Show();
	
end

function CombatStats_UpdateDetails(attackName)
	
	local x,y,info;
	
	--
	--	Draw the text for the hits/swings 
	--
	
	CombatStatsGeneralHitsTextLabel:SetText(CS_FRAME_HITS_TEXT);
	CombatStatsGeneralSwingsTextLabel:SetText(CS_FRAME_SWINGS_TEXT);
	
	if(attackName ~= "Total") then
			
	--
	-- Calculate % of hits that are crits
	-- 		
	
	if( (totalCrits) ~= 0) then		
		CombatStatsOverallCritPctLabel:SetText( format(RED_FONT_COLOR_CODE.."%.2f %%", ( totalCrits / totalHits) * 100.0));			
	end
	
	CombatStatsGeneralNameTextLabel:SetText(attackName);
	CombatStatsGeneralTotalHitsHits:SetText(specialAttacks[attackName].totalHits);
	CombatStatsGeneralSwingsLabel:SetText(specialAttacks[attackName].totalSwings);
	
	CombatStatsGeneralMissesTextLabel:SetText(specialAttacks[attackName].totalMisses);
	
	if(specialAttacks[attackName].totalMisses ~= 0) then
		CombatStatsGeneralMissesPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalMisses / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralMissesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralDodgesTextLabel:SetText(specialAttacks[attackName].totalDodged);
	
	if(specialAttacks[attackName].totalDodged ~= 0) then
		CombatStatsGeneralDodgesPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalDodged / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralDodgesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralBlockedTextLabel:SetText(specialAttacks[attackName].totalBlocked);
	
	if(attackName == "Defensive") then
	
		if(specialAttacks[attackName].totalBlocked ~= 0) then
			CombatStatsGeneralBlockedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalBlocked / (specialAttacks[attackName].totalHits) * 100)));
		else
			CombatStatsGeneralBlockedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		end
		
	else
	
		if(specialAttacks[attackName].totalBlocked ~= 0) then
			CombatStatsGeneralBlockedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalBlocked / (specialAttacks[attackName].totalSwings) * 100)));
		else
			CombatStatsGeneralBlockedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
		end
	
	end
	
	CombatStatsGeneralParriedTextLabel:SetText(specialAttacks[attackName].totalParried);
	
	if(specialAttacks[attackName].totalParried ~= 0) then
		CombatStatsGeneralParriedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalParried / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralParriedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralResistedTextLabel:SetText(specialAttacks[attackName].totalResisted);
	
	if(specialAttacks[attackName].totalResisted ~= 0) then
		CombatStatsGeneralResistedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalResisted / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralResistedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralImmunedTextLabel:SetText(specialAttacks[attackName].totalImmuned);
	
	if(specialAttacks[attackName].totalImmuned ~= 0) then
		CombatStatsGeneralImmunedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalImmuned / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralImmunedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralEvadedTextLabel:SetText(specialAttacks[attackName].totalEvaded);
	
	if(specialAttacks[attackName].totalEvaded ~= 0) then
		CombatStatsGeneralEvadedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalEvaded / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralEvadedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralDeflectedTextLabel:SetText(specialAttacks[attackName].totalDeflected);
	
	if(specialAttacks[attackName].totalDeflected ~= 0) then
		CombatStatsGeneralDeflectedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (specialAttacks[attackName].totalDeflected / (specialAttacks[attackName].totalSwings) * 100)));
	else
		CombatStatsGeneralDeflectedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	--
	--	Percent of total damage
	--
	
	if(attackName ~= "Defensive") then	
		if(specialAttacks[attackName].totalHits ~= 0) then
			CombatStatsGeneralPercentDmgPctLabel:SetText( format("%.2f %%", ((specialAttacks[attackName].totalRegDmg + specialAttacks[attackName].totalCritDmg + specialAttacks[attackName].dotDmg) / totalDamage) * 100) );
		else
			CombatStatsGeneralPercentDmgPctLabel:SetText("0.0%");
		end
	end
	
	--
	--	Time since last crit
	--
	
	local timeNow;
	timeNow = GetTime();
	
	if(specialAttacks[attackName].lastCrit ~= 0) then
		CombatStatsGeneralTimeLastCritTimeLabel:SetText(GREEN_FONT_COLOR_CODE ..Clock_FormatTime( (timeNow - specialAttacks[attackName].lastCrit)));
	else
		CombatStatsGeneralTimeLastCritTimeLabel:SetText(GREEN_FONT_COLOR_CODE.."N/A");	
	end
	
	--
	--	Attack Crit %
	--
	
	if (specialAttacks[attackName].totalHits ~= 0) and (specialAttacks[attackName].totalCrits ~= 0) then
		CombatStatsAttackCritPctLabel:SetText(format(RED_FONT_COLOR_CODE.."%.1f%%", ( (specialAttacks[attackName].totalCrits) / (specialAttacks[attackName].totalHits)) * 100.0 ));			
	else
		CombatStatsAttackCritPctLabel:SetText(RED_FONT_COLOR_CODE.."0.0 %");
	end
	
	--
	--	Attack Non Crit %
	--
	
	if (specialAttacks[attackName].totalHits ~= 0) and (specialAttacks[attackName].totalNonCrits ~= 0) then
		CombatStatsAttackNonCritPctLabel:SetText( format(GREEN_FONT_COLOR_CODE.."%.1f%%", ( (specialAttacks[attackName].totalNonCrits) / (specialAttacks[attackName].totalHits)) * 100.0 ));			
	else
		CombatStatsAttackNonCritPctLabel:SetText(GREEN_FONT_COLOR_CODE.."0.0 %");
	end
	
	--
	--	Non Crit stats
	--
	
	CombatStatsNonCritHitsStatText:SetText(specialAttacks[attackName].totalNonCrits);	
	CombatStatsNonCritDamageStatText:SetText(specialAttacks[attackName].totalRegDmg);	
	CombatStatsNonCritMinMaxStatText:SetText(specialAttacks[attackName].minReg .." / "..specialAttacks[attackName].maxReg);
	
	if( specialAttacks[attackName].totalRegDmg ~= 0) then
												
		if( (specialAttacks[attackName].totalHits - specialAttacks[attackName].totalCrits) < 0) then
			CombatStatsNonCritAvgStatText:SetText(format("%.1f", specialAttacks[attackName].totalRegDmg / (specialAttacks[attackName].totalCrits - specialAttacks[attackName].totalHits ) ));
		end
						
		if(	(specialAttacks[attackName].totalHits - specialAttacks[attackName].totalCrits) == 0 ) then
			CombatStatsNonCritAvgStatText:SetText(format("%1.f", specialAttacks[attackName].totalRegDmg / (specialAttacks[attackName].totalCrits) ));
		end
						
		if(	(specialAttacks[attackName].totalHits - specialAttacks[attackName].totalCrits) > 0 ) then
			CombatStatsNonCritAvgStatText:SetText(format("%1.f",specialAttacks[attackName].totalRegDmg / (specialAttacks[attackName].totalHits - specialAttacks[attackName].totalCrits) ));
		end
						
	else		
		CombatStatsNonCritAvgStatText:SetText("0.0");
	end
	
	if(specialAttacks[attackName].totalNonCrits ~= 0) then
		CombatStatsNonCritPercentDamageStatText:SetText( format("%.2f %%", ( specialAttacks[attackName].totalRegDmg / (specialAttacks[attackName].totalRegDmg + specialAttacks[attackName].totalCritDmg )) * 100.0));
	else
		CombatStatsNonCritPercentDamageStatText:SetText("0.0 %");
	end
	
	--
	--	Crit stats
	--
	
	CombatStatsCritHitsStatText:SetText(specialAttacks[attackName].totalCrits);	
	CombatStatsCritDamageStatText:SetText(specialAttacks[attackName].totalCritDmg);	
	CombatStatsCritMinMaxStatText:SetText(specialAttacks[attackName].minCrit .." / "..specialAttacks[attackName].maxCrit);
	
	if( specialAttacks[attackName].totalCritDmg ~= 0) then
		CombatStatsCritAvgStatText:SetText(format("%1.f", (specialAttacks[attackName].totalCritDmg / specialAttacks[attackName].totalCrits) ));
	else
		CombatStatsCritAvgStatText:SetText("0.0");
	end
	
	if(specialAttacks[attackName].totalCrits ~= 0) then
		CombatStatsCritPercentDamageStatText:SetText(format("%.2f %%", (specialAttacks[attackName].totalCritDmg / ( specialAttacks[attackName].totalRegDmg + specialAttacks[attackName].totalCritDmg )) * 100.10 ));
	else
		CombatStatsCritPercentDamageStatText:SetText("0.0 %");
	end	
				
	--
	--	Show DOT Stats
	--
	
	
			
	if (specialAttacks[attackName].isDOT == 1) then
		
		CombatStatsGeneralHitsTextLabel:SetText(CS_FRAME_TICKS_TEXT);
		CombatStatsGeneralSwingsTextLabel:SetText("");
		CombatStatsGeneralSwingsLabel:SetText("");
		
		CombatStatsGeneralTotalHitsHits:SetText(specialAttacks[attackName].dotTicks);
		CombatStatsNonCritHitsStatText:SetText(specialAttacks[attackName].dotTicks);
		CombatStatsNonCritDamageStatText:SetText(specialAttacks[attackName].dotDmg);
		
		CombatStatsNonCritMinMaxStatText:SetText(specialAttacks[attackName].minReg .." / "..specialAttacks[attackName].maxReg);
		CombatStatsNonCritAvgStatText:SetText(format("%.1f", specialAttacks[attackName].dotDmg / specialAttacks[attackName].dotTicks ));
		CombatStatsNonCritPercentDamageStatText:SetText("100.0 %");
		CombatStatsAttackNonCritPctLabel:SetText(GREEN_FONT_COLOR_CODE.."100.0%");
		
		--
		--	Should never be a 0 tick entry but just in case
		--
--		if(specialAttacks[attackNames[y]].dotTicks ~= 0) then	
--			text = text.."\n"..format(TEXT(DOT_AVERAGE),(specialAttacks[attackNames[y]].dotDmg / specialAttacks[attackNames[y]].dotTicks));
--		end
	end
	
	else
		
	--
	-- Calculate % of hits that are crits
	-- 		
	
	if( (totalCrits) ~= 0) then		
		CombatStatsOverallCritPctLabel:SetText( format(RED_FONT_COLOR_CODE.."%.2f %%", ( totalCrits / totalHits) * 100.0));			
	end
	
	CombatStatsGeneralNameTextLabel:SetText("Total");
	CombatStatsGeneralTotalHitsHits:SetText(totalHits);
	CombatStatsGeneralSwingsLabel:SetText(overallSwings);
	
	CombatStatsGeneralMissesTextLabel:SetText(overallMisses);
	
	if(overallMisses ~= 0) then
		CombatStatsGeneralMissesPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallMisses / (overallSwings) * 100)));
	else
		CombatStatsGeneralMissesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralDodgesTextLabel:SetText(overallDodged);
	
	if(overallDodged ~= 0) then
		CombatStatsGeneralDodgesPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallDodged / (overallSwings) * 100)));
	else
		CombatStatsGeneralDodgesPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralParriedTextLabel:SetText(overallParried);
	
	if(overallParried ~= 0) then
		CombatStatsGeneralParriedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallParried / (overallSwings) * 100)));
	else
		CombatStatsGeneralParriedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralResistedTextLabel:SetText(overallResisted);
	
	if(overallResisted ~= 0) then
		CombatStatsGeneralResistedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallResisted / (overallSwings) * 100)));
	else
		CombatStatsGeneralResistedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralImmunedTextLabel:SetText(overallImmuned);
	
	if(overallImmuned ~= 0) then
		CombatStatsGeneralImmunedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallImmuned / (overallSwings) * 100)));
	else
		CombatStatsGeneralImmunedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralEvadedTextLabel:SetText(overallEvaded);
	
	if(overallEvaded ~= 0) then
		CombatStatsGeneralEvadedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallEvaded / (overallSwings) * 100)));
	else
		CombatStatsGeneralEvadedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	CombatStatsGeneralDeflectedTextLabel:SetText(overallDeflected);
	
	if(overallDeflected ~= 0) then
		CombatStatsGeneralDeflectedPercentLabel:SetText( format(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.. "%.1f%%" .. NORMAL_FONT_COLOR_CODE.." ]", (overallDeflected / (overallSwings) * 100)));
	else
		CombatStatsGeneralDeflectedPercentLabel:SetText(NORMAL_FONT_COLOR_CODE.."[ "..WHITE_FONT_COLOR_CODE.."0.0%"..NORMAL_FONT_COLOR_CODE.." ]");
	end
	
	--
	--	Percent of total damage
	--
	
	if(totalHits ~= 0) then
		CombatStatsGeneralPercentDmgPctLabel:SetText( format("%.2f %%", ((overallRegDmg + overallCritDmg ) / totalDamage) * 100) );
	else
		CombatStatsGeneralPercentDmgPctLabel:SetText("0.0%");
	end
	
	--
	--	Time since last crit
	--
	
	local timeNow;
	timeNow = GetTime();
	
	if(overallLastcrit ~= 0) then
		CombatStatsGeneralTimeLastCritTimeLabel:SetText(GREEN_FONT_COLOR_CODE ..Clock_FormatTime( (timeNow - overallLastcrit)));
	else
		CombatStatsGeneralTimeLastCritTimeLabel:SetText(GREEN_FONT_COLOR_CODE.."N/A");	
	end
	
	--
	--	Attack Crit %
	--
	
	if (totalHits ~= 0) and (overallCrits ~= 0) then
		CombatStatsAttackCritPctLabel:SetText(format(RED_FONT_COLOR_CODE.."%.1f%%", ( (overallCrits) / (totalHits)) * 100.0 ));			
	else
		CombatStatsAttackCritPctLabel:SetText(RED_FONT_COLOR_CODE.."0.0 %");
	end
	
	--
	--	Attack Non Crit %
	--
	
	if (totalHits ~= 0) and (overallNonCrits ~= 0) then
		CombatStatsAttackNonCritPctLabel:SetText( format(GREEN_FONT_COLOR_CODE.."%.1f%%", ( (overallNonCrits) / (totalHits)) * 100.0 ));			
	else
		CombatStatsAttackNonCritPctLabel:SetText(GREEN_FONT_COLOR_CODE.."0.0 %");
	end
	
	--
	--	Non Crit stats
	--
	
	CombatStatsNonCritHitsStatText:SetText(overallNonCrits);	
	CombatStatsNonCritDamageStatText:SetText(overallRegDmg);	
	CombatStatsNonCritMinMaxStatText:SetText(overallminReg .." / "..overallmaxReg);
	
	if( overallRegDmg ~= 0) then
												
		if( (totalHits - overallCrits) < 0) then
			CombatStatsNonCritAvgStatText:SetText(format("%.1f", overallRegDmg / (overallCrits - totalHits ) ));
		end
						
		if(	(totalHits - overallCrits) == 0 ) then
			CombatStatsNonCritAvgStatText:SetText(format("%1.f", overallRegDmg / (overallCrits) ));
		end
						
		if(	(totalHits - overallCrits) > 0 ) then
			CombatStatsNonCritAvgStatText:SetText(format("%1.f", overallRegDmg / (totalHits - overallCrits) ));
		end
						
	else		
		CombatStatsNonCritAvgStatText:SetText("0.0");
	end
	
	if(overallNonCrits ~= 0) then
		CombatStatsNonCritPercentDamageStatText:SetText( format("%.2f %%", ( overallRegDmg / (overallRegDmg + overallCritDmg )) * 100.0));
	else
		CombatStatsNonCritPercentDamageStatText:SetText("0.0 %");
	end
	
	--
	--	Crit stats
	--
	
	CombatStatsCritHitsStatText:SetText(overallCrits);	
	CombatStatsCritDamageStatText:SetText(overallCritDmg);	
	CombatStatsCritMinMaxStatText:SetText(overallminCrit .." / "..overallmaxCrit);
	
	if( overallCritDmg ~= 0) then
		CombatStatsCritAvgStatText:SetText(format("%1.f", (overallCritDmg / overallCrits) ));
	else
		CombatStatsCritAvgStatText:SetText("0.0");
	end
	
	if(overallCrits ~= 0) then
		CombatStatsCritPercentDamageStatText:SetText(format("%.2f %%", (overallCritDmg / ( overallRegDmg + overallCritDmg )) * 100.10 ));
	else
		CombatStatsCritPercentDamageStatText:SetText("0.0 %");
	end	
	
	end
	
end					

--
-- Time functions
-- from Clock.lua
--

local function Clock_FormatPart(fmt, val)
	local part;

	part = format(TEXT(fmt), val);
	if( val ~= 1 ) then
		part = part.."s";
	end

	return part;
end

function Clock_FormatTime(time)
	local d, h, m, s;
	local text = "";
	local skip = 1;

	d, h, m, s = ChatFrame_TimeBreakDown(time);
	if( d > 0 ) then
		text = text..Clock_FormatPart(CLOCK_TIME_DAY, d)..", ";
		skip = 0;
	end
	if( (skip == 0) or (h > 0) ) then
		text = text..Clock_FormatPart(CLOCK_TIME_HOUR, h)..", ";
		skip = 0;
	end
	if( (skip == 0) or (m > 0) ) then
		text = text..Clock_FormatPart(CLOCK_TIME_MINUTE, m)..", ";
		skip = 0;
	end
	if( (skip == 0) or (s > 0) ) then
		text = text..Clock_FormatPart(CLOCK_TIME_SECOND, s);
	end

	return text;
end

function CombatStats_TargetFrame_OnShow()
	if (CombatStats_Old_TargetFrame_OnShow) then
		CombatStats_Old_TargetFrame_OnShow();
	end
	CombatStats_UpdateVisibility(1);
end

function CombatStats_TargetFrame_OnHide()
	if (CombatStats_Old_TargetFrame_OnHide) then
		CombatStats_Old_TargetFrame_OnHide();
	end
	CombatStats_UpdateVisibility(0);
end
