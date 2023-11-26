-- Average Exp Calculator Plus
-- This is a mod of the Average Exp Calculator originally by jINx of Purgatory LAN Organization
-- I added the XP Progress bar in the background, stretched out hte bar a little and added the current
-- xp/total xp for the lvl.
-- Free to Modify and use, please retain Credibility

-- Currently this is merely an average exp gain. Often times the mobile count is not entirely
-- accurate, as its based on if you gain the average exp. Though if you let it go across your 
-- entire level until it resets it will give you information regarding your average exp gain
-- across that entire level per kill. It stores the average exp per level that you gain.

-- Version 0.420
-- * Standard UI bar now displays Current Target statistics
-- * Can now broadcast current target statistics if you use the standard broadcast commands while targeting
-- * Updated Tooltip again:
--     Now displays Best Average exp creature 
--     Compares Current Target stats to Best Average

-- Version 0.41
-- * Updated Tooltip
-- * Functional implementation of Exp tracking per creature name

-- Version 0.4
-- * Fixed glitch with jx_exp_history being a number not a table
-- * Fixed glitch with exp history table tracking 1 level to low, due to -1 
--   (appears the level isn't updated during the course of the PLAYER_LEVEL_UP event until afterwards?)
-- * Updated the table to save with name race and realmname for redundancy (you'll see I like to do that)
-- * Created is_loaded for the simple sake of not doing anything until VARIABLES_LOADED
-- * Cleaned up a little code here and there
-- * Stopped specifying level in jx_exp_history so that the index is now the level

-- Version 0.36
-- * Added UnitName checking and UNIT_NAME_UPDATE event so it works on login before player enters the world

-- Version 0.35
-- * Created a SavePlayer and LoadPlayer function that add to a globally saved table
--   This table indexes the player by a player pid and searchs for that pid by name
--   This means that player data is now player specific and not just session
-- * Added tooltip that displays last kill and total kills used in average
-- * Modified the times at which the calculation and update events fire, since this now saves data to saved table as well

-- Version 0.33
-- * Removed Rested Exp bonus from the average, kill and regular exp still count
-- * Updated Help command line options (/avgxp [help])
-- * Added level history list and it Displays on level up (/avgxp level)
-- * Added command to reset level history (/avgxp levelreset)
-- * Removed some localized variables that were overwriting saved variables

-- Version 0.32
-- * Updated TOC so the Exp History is actually saved
-- * Made changes prepairing for Kill History to not recreate issues fixed in 0.31

-- Version 0.31
-- * Fixed a few bugs with the Player Level Up that was caused by cleaning up code and moving functions

-- Version 0.3
-- * Cleaned up more code (removed duplicate calculations and stored values instead)
-- * Added Tag (+ / -) to show whether last exp gain was above or below average 
-- * Update to Store Average Exp Gain per Level

-- Version 0.2
-- * Cleaned up A LOT of code
-- * Organized variable declaration
-- * Added Reset on Player Level Up event (To get proper Average Exp across the entire level)
-- * Updated Frame and object names from Jinx to AvgXP to make mod specific
-- * Created a function for comma delimited numbers
-- * Updated TOC

-- In Development:
-- * Track what monsters are killed and how many, and the avg exp for killing them

-- ToDo:
-- * Update display function to break each carriage return to a new AddMessage(), thus eliviating the need to scroll the chat window in certain situations (ie. /avgxp help)
-- * Implement UltimateUI friendliness and fixing UltimateUI specific issues (SendChatMessage)

-- Potential ToDo:
-- * Allow for custom string and .gsub to fill with values, possibly with tracking more this would be useful

-- End of Notes



-----------------------------------------------------------------------------------------
-- Vars 
local jx_avgexp_version = 0.420;
local jx_avgexp_init
local jx_last_xp_gained 
local jx_avg_xp_per_mob 
local jx_num_mobs_left
local jx_avgexp_stats 
local jx_target_stats
local jx_total_xp_gained
local jx_total_mobs_killed
local jx_kill_history = { }
local jx_kill_history_dep = { }
local jx_exp_history = { }

-- (Yes some of this is ridiculous but I was sick of having duplicated code)
local jx_best_average
local jx_best_average_str
local jx_rested_bonus
local jx_avg_xp_per_mob_str
local jx_kills_str
local jx_exp_togo
local jx_exp_pc
local msg
local pid

local is_loaded = false;
local is_saved = false;
local jx_oldversion = false;

-- Colors
local GRN="|cff20ff20";
local YEL="|cffffff40";
local RED="|cffff2020";
local WHT="|cffffffff";

-- Constants
local jx_alliedraces = { "Dwarf", "Gnome", "Human", "Night Elf" };
local jx_commlang

-----------------------------------------------------------------------------------------
-- Common functions

local function display(output)
	local anyoutput = false;

	-- IF the output ends without a carriage return but has some in it, the entire message will not display
	for msg in string.gfind(output,"(.+)\n") do
		if (msg~=nil) then
			anyoutput = true;
		end
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end

	-- This basically means that there were no carriage returns
	if (not anyoutput) then
		DEFAULT_CHAT_FRAME:AddMessage(output);
	end
end

function EXPBarUpdate()

  local CXP = UnitXP("player");
  local NXP = UnitXPMax("player");
  local RXP = GetXPExhaustion();

  EXPBar:SetMinMaxValues(min(0, CXP), NXP);
  EXPBar:SetValue(CXP);
  EXPBarb:SetValue(NXP);

end


function EXP_OnLoad()
  EXPBarUpdate();
	AvgXP:SetBackdropColor(0, 0, 0, 0);
	AvgXP:SetBackdropBorderColor(1, 1, 1, 1); --[[ mark ]]--
end


function EXP_OnUpdate(arg1)
  EXPBarUpdate();

end


function EXP_OnEvent()
  EXPBarUpdate();

end
-----------------------------------------------------------------------------------------
-- Development

local DEBUG = false;
local jx_debug_threshold = 2;
local function debug(level,msg)
	if DEBUG then
		if (level >= jx_debug_threshold) then
			msg = YEL.."AvgXP debug: "..msg;
			display(msg);
		end
	end
end

-----------------------------------------------------------------------------------------
-- History Functions

local function JX_AvgXP_Depricate_History()
	for i,v in pairs(jx_kill_history) do
		jx_kill_history_dep[ i ] = { };
		jx_kill_history_dep[ i ] = v;
	end

	jx_kill_history = { };
end

local function JX_AvgXP_AddKill(mobile_name,xp)
	local exp = 0
	local kills = 0
	local target = mobile_name;
	
	if (not jx_kill_history[ target ] ) then
		debug(2,string.format("Created kill record for %s\n",mobile_name));
		jx_kill_history[ target ] = { };
		jx_kill_history[ target ] = { level = UnitLevel("player"), total_xp = 0, total_kills = 0 };
	end

	if (xp > 0) then
		exp = jx_kill_history[ target ].total_xp;
		kills = jx_kill_history[ target ].total_kills;
		jx_kill_history[ target ].total_xp = exp + xp;
		jx_kill_history[ target ].total_kills = kills + 1;
		jx_kill_history[ target ].level = UnitLevel("player");
		avg = (jx_kill_history[ target ].total_xp / jx_kill_history[ target ].total_kills);		
	
		-- If we have a new best average, update it
		if (avg > jx_best_average) then
			jx_best_average = avg;
			jx_best_average_str = target;
		end

		debug(2,string.format("Adding kill for %s for %d exp, total exp now %d and kills %d :: Current average %.1f\n",mobile_name, xp, jx_kill_history[ target ].total_xp , jx_kill_history[ target ].total_kills, avg));
	else
		debug(2,string.format("No exp awarded for kill for %s\n",mobile_name));
	end
end

local function JX_AvgXP_Kill_Reset()
	jx_kill_history = { };
	output(YEL.."Average Exp Kill History has been reset.\n");
end

local function JX_AvgXP_FindBestAvg()
	jx_best_average = 0
	jx_best_average_str = "Not Available"
	local avg
	
	if (not jx_kill_history) then
		debug(2,"No kill history available for Best Average\n");
		return;
	end
	
	for k,v in pairs(jx_kill_history) do
		avg = (v.total_xp / v.total_kills);
		if( (avg > jx_best_average) and (v.total_kills > 1) ) then
			jx_best_average = avg;
			jx_best_average_str = k;
		end
	end
	debug(1,string.format("Set Best Average to %s at %.1f\n",jx_best_average_str,jx_best_average));
end

-----------------------------------------------------------------------------------------
-- Utility

local function JX_AvgXP_MobXP(plevel, mlevel)
	return (plevel * 5) + 45 + ( ( mlevel - plevel) * 17);
end

function JX_SetCommLang()
	for i, nextRace in ipairs(jx_alliedraces) do
		if (string.find(UnitRace("player"),nextRace)~=nil) then
			jx_commlang = "COMMON";
		end
	end
	if (not jx_commlang) then
		jx_commlang = "ORCISH";
	end
end

function JX_AvgXP_SetTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:ClearLines();

	if (not jx_target_stats) then

		GameTooltip:AddLine("Average Experience");
--		GameTooltip:AddLine(string.format("Total Kills: %d",jx_total_mobs_killed),1,1,1);
		
		if (not jx_rested_bonus) then
			jx_rested_bonus = 0;
		end
		
		if (jx_rested_bonus > 0) then
			msg = string.format("Total Kills: %d   Last Kill: %d exp (%d rested bonus)",jx_total_mobs_killed, (jx_last_xp_gained+jx_rested_bonus),jx_rested_bonus);
		else
			msg = string.format("Total Kills: %d   Last Kill: %d exp",jx_total_mobs_killed, jx_last_xp_gained);
		end
		GameTooltip:AddLine(msg,1,1,1);
	
		if( (jx_last_xp_gained < jx_avg_xp_per_mob) and (jx_last_xp_gained ~= 0) ) then
			msg = "Less than Avg";
		else
			if (jx_last_xp_gained > jx_avg_xp_per_mob) then
				msg = "More than Avg";
			else
				msg = "";
			end
		end
		GameTooltip:AddLine(msg,1,1,1);

		GameTooltip:AddLine("Best Average",1,0.82,0);
		
		msg = string.format("%s at %.1f exp per kill",jx_best_average_str,jx_best_average);
		GameTooltip:AddLine(msg,1,1,1);
	else
		if ( (jx_kill_history_dep[ UnitName("target") ] ~= nil) and (not jx_kill_history[ UnitName("target") ]) ) then
			-- Depricated Target Stats
			GameTooltip:AddLine(UnitName("target"));
			
			local avg = (jx_kill_history_dep[ UnitName("target") ].total_xp / jx_kill_history_dep[ UnitName("target") ].total_kills);
			
			local approx_avg = avg - ( (UnitLevel("player") - jx_kill_history_dep[ UnitName("target") ].level) * 17);
			
			GameTooltip:AddLine(string.format("Level %d Avg was %.1f",jx_kill_history_dep[ UnitName("target") ].level,avg),1,1,1);
			GameTooltip:AddLine(string.format("Approx Avg now is %.1f",approx_avg),1,1,1);
		else 
			-- Target Stats
			GameTooltip:AddLine(UnitName("target"));
			
			local avg = (jx_kill_history[ UnitName("target") ].total_xp / jx_kill_history[ UnitName("target") ].total_kills);
			local kills = math.ceil( jx_exp_togo / avg );
			local kills_str = "kills";
			
			if (kills == 1) then
				kills_str = "kill";
			end
			
			GameTooltip:AddLine(string.format("Would take %d %s to level", kills, kills_str),1,1,1);
			
			if (kills < jx_num_mobs_left) then
				GameTooltip:AddLine("Faster than Average",1,1,1);
			else
				if (kills == jx_num_mobs_left) then
					GameTooltip:AddLine("Same as Average",1,1,1);
				else
					GameTooltip:AddLine("Slower than Average",1,1,1);
				end
			end
	
			if (UnitName("target") == jx_best_average_str) then
				GameTooltip:AddLine("Best Current Average",1,0.82,0);
			else
				msg = string.format("%.1f exp per kill less than %s",(jx_best_average - avg), jx_best_average_str);
				GameTooltip:AddLine(msg,1,1,1);
			end
		end
	end

	GameTooltip:Show();
end

-----------------------------------------------------------------------------------------
-- Utility

-- Horrible way to comma delimit a number (this assumes its < 7 digits)
local function comma(val)
	local temp = tostring(val);
	if(string.len(temp) > 3) then
		return string.sub(temp,1,(string.len(temp) - 3))..","..string.sub(temp,(string.len(temp) - 3 + 1));
	else
		return temp;
	end
end

-- JX_AvgXP_Reset()
-- no parms
-- desc: zeros out variables
local function JX_AvgXP_Reset()
	jx_total_xp_gained = 0;
	jx_last_xp_gained = 0;
	jx_total_mobs_killed = 0;
	jx_avg_xp_per_mob = 0;
	jx_num_mobs_left = 0;
end

-----------------------------------------------------------------------------------------
-- Level Up functions

local function JX_Level_Display(i,val)
	if (val~=nil) then
		msg = string.format("  Level %d :: %1.f exp per kill :: %d kills total\n",i,val.avgxp,val.kills);
		display(WHT..msg);
	end
end

local function JX_AvgXP_Level_Report()
	msg = "none";
	display(YEL.."Average Exp gain per level::\n");
	table.foreachi(jx_exp_history, JX_Level_Display);
	if (msg=="none") then
		display(WHT.."  No records found in history.\n");
	end
end

local function JX_AvgXP_Level_Reset()
	jx_exp_history = { };
	display(YEL.."Average Exp gain per level reset.\n");
end

-- JX_Event_Player_Level_UP()
-- no parms
-- desc: Player Level Up, reset stats so we get Average Exp Gain across the entire level
-- ToDo: Store Average Exp Gain per level
function JX_Event_Player_Level_Up()
	-- Insert pair (level,average exp) into Exp History table
	table.insert(jx_exp_history, UnitLevel("player"), { avgxp = jx_avg_xp_per_mob, kills = jx_total_mobs_killed } )

	JX_AvgXP_Level_Report();

	-- Report statistics
	msg = string.format("%sXP Report: Average Exp per Kill for Level %d :: %1.f exp per kill\n",YEL,UnitLevel("player"),jx_avg_xp_per_mob);
	display(msg);

	JX_AvgXP_Depricate_History();	

	-- Reset average values for new level
	JX_AvgXP_Reset();
	display(YEL.."Average Exp settings have been reset due to level up.\n");
end

-----------------------------------------------------------------------------------------
-- Core functions

function JX_AvgXP_FindPID()
	--Wait till VARIABLES_LOADED has fired
	if( (UnitName("player")==nil) or (UnitName("player") == "Unknown Entity") or (UnitName("player") == "Unknown Being") or (not GetCVar("realmName")) ) then
		return;
	end

	if (jx_avgxp_players == nil) then
		jx_avgxp_players = { };
		pid = -1;
		return;
	end

	--If the table is empty why even recurse, no PID exists
	if( (table.getn(jx_avgxp_players) == 0) or (table.getn(jx_avgxp_players)==nil) ) then
		-- If PID == Nil when it enters JX_AvgXP_Calc it will fail
		-- We set to -1 to state that no pid currently exists, and when it enters Calc it will initialize and then save after first calc
		pid = -1;
		return;
	end

	if( (pid==nil) or (pid==-1) )then
		pid = -1;
		debug(1,string.format("Looking for PID...%d\n",table.getn(jx_avgxp_players)));
		for i,v in ipairs(jx_avgxp_players) do
			if( (v.race == nil) and (v.realm == nil) and (v.name == UnitName("player")) ) then
				-- Using version 0.32 to 0.36
				jx_oldversion = true;
				pid = i;
			end

			-- Check Name, Race, and Realm
			if( (v.name == UnitName("player")) and (v.race == UnitRace("player")) and (v.realm == GetCVar("realmName")) ) then
				pid = i;
			end
		end
	end
	if (pid ~= -1) then
		debug(1,string.format("PID is %d\n",pid));
	else
		debug(1,"No PID found\n");
	end
end

function JX_AvgXP_LoadPlayer()
	-- This calls after the player enters the world, this is necessary to detect UnitRace
	if (not jx_commlang) then
		JX_SetCommLang();
	end	

	JX_AvgXP_FindPID();
	
	if( (pid ~= -1) and (pid ~= nil) ) then
		jx_avgexp_init = jx_avgxp_players[pid].init;
		jx_total_mobs_killed = jx_avgxp_players[pid].totalmobs;
		jx_total_xp_gained = jx_avgxp_players[pid].totalxp;
		if (jx_oldversion) then
			jx_exp_history = { };
			jx_kill_history = { };
			jx_kill_history_dep = { };
			display(GRN.."Exp History per level was reset due to an old version, to avoid corruption.\n");
		else
			jx_exp_history = jx_avgxp_players[pid].exphistory;
			jx_kill_history = jx_avgxp_players[pid].killhistory;
			if (not jx_kill_history) then
				jx_kill_history = { };
			end
			jx_kill_history_dep = jx_avgxp_players[pid].depkillhistory;
			if (not jx_kill_history_dep) then
				jx_kill_history_dep = { };
			end
		end
	else
		jx_avgexp_init = true;
		jx_total_mobs_killed = 0;
		jx_total_xp_gained = 0;
		jx_exp_history = { };
		jx_kill_history = { };
		jx_kill_history_dep = { };
	end

	jx_avg_xp_per_mob = 0;
	jx_num_mobs_left = 0;
	jx_last_xp_gained = 0;

	debug(1,"Load fired.\n");
end

function JX_AvgXP_SavePlayer()
	-- Locate Player ID
	JX_AvgXP_FindPID();

	-- If No Player ID insert first values
	if (pid == -1) then
		local stats = {
			name = UnitName("player"),
			race = UnitRace("player"),
			realm = GetCVar("realmName"),
			init = jx_avgexp_init,
			totalmobs = jx_total_mobs_killed,
			totalxp = jx_total_xp_gained,
			exphistory = jx_exp_history, 
			killhistory = jx_kill_history,
			depkillhistory = jx_kill_history_dep };
		table.insert(jx_avgxp_players,stats);
	else
		-- Player existed overwrite old values
		jx_avgxp_players[pid].totalmobs = jx_total_mobs_killed;
		jx_avgxp_players[pid].totalxp = jx_total_xp_gained;
		jx_avgxp_players[pid].exphistory = jx_exp_history;
		jx_avgxp_players[pid].killhistory = jx_kill_history;
		jx_avgxp_players[pid].depkillhistory = jx_kill_history_dep;
		
		if (jx_oldversion) then
			jx_avgxp_players[pid].race = UnitRace("player");
			jx_avgxp_players[pid].realm = GetCVar("realmName");
		end
	end

	is_saved = true;

	debug(1,"Save fired.\n");
end

-- JX_AvgXP_Initialize()
-- No Parms
-- Desc: Initializes all values, runs OnLoad
function JX_AvgXP_Initialize()
	if(pid~=nil) then
		-- Check Player specific Init, if its false set default values
		if( (jx_avgexp_init==nil) or (jx_avgexp_init==false) ) then
			jx_total_mobs_killed = 0;
			jx_total_xp_gained = 0;
			jx_exp_history = { };
			jx_avgexp_init = true;
			JX_AvgXP_Reset();
			display(YEL.."Average Exp settings have been reset.\n");		
		end
	end

	-- Check Global init other initialize player table
	if( (jx_avgxp_globalinit==nil) or (jx_avgxp_globalinit==false) ) then
		jx_avgxp_players = { };
		jx_avgxp_globalinit = true;
	end

	-- Add /avgxp command line
	SlashCmdList["JXAVGXP"] = JX_AvgXP_Command;
	SLASH_JXAVGXP1 = "/averagexp";
	SLASH_JXAVGXP2 = "/avgxp";

	-- Calculate when Exp Gain. From Combat, XP Update (Quest / Exploration), Level Up
	this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	
	-- Run Calculation and update UI (This will Save the Player at the end)
	JX_AvgXP_Calc("JX_AVGXP_INIT");
end

-- JX_AvgXP_Command(msg)
-- msg : Command line parameter
-- Desc: Parses the /avgxp command
function JX_AvgXP_Command(msg)
	-- Vars: removed all duplicate calculations, since nothing SHOULD change
	local output = "";

	if (not is_loaded) then
		return;
	end
	
-- Nanny
-- ToDo: Verify that "COMMON" in SendChatMessage works for Alliance and Horde

	-- No parameter
	if( (msg==nil) or (msg=="") ) then
		out=GRN.."Average Experience Calculator (Use Letters in [ ] for Shortcut)\n "..YEL.."Reset"..GRN.." - Resets the calculator        :: "..YEL.."LevelReset"..GRN.." - Resets Exp History\n\n ["..YEL.."P"..GRN.."]"..YEL.."arty"..GRN.." - Broadcasts stats to Party :: ["..YEL.."R"..GRN.."]"..YEL.."aid"..GRN.." - Broadcasts stats to Raid\n ["..YEL.."G"..GRN.."]"..YEL.."uild"..GRN.." - Broadcasts stats to Guild :: ["..YEL.."#"..GRN.."] - Broadcasts stats to Channel #\n\n ["..YEL.."L"..GRN.."]"..YEL.."evel"..GRN.." - Displays Avg Exp per Level Report\n";
		display(out);
	end

	if( (UnitName("target")~=nil) and (jx_target_stats~=nil) ) then
		output = jx_target_stats;
	else
		output = jx_avgexp_stats;
	end
	
	msg=string.lower(msg);

	-- If msg converts to a number cleanly, assume its a channel id
	-- ToDo: Something with UltimateUI breaks SendChatMessage() to a channel. Research?
	if( (tonumber(msg)~=nil) ) then
		SendChatMessage(output,"CHANNEL",jx_commlang,tonumber(msg));
	end

	-- Reset parameter, clear stats
	if(msg=="reset") then
		JX_AvgXP_Reset();
		msg=YEL.."Average Experience has been reset.\n";
		display(msg);

		-- Recalc and Update UI
		JX_AvgXP_Calc("JX_AVGXP_INIT");		
	end

	-- Reset Level parameter, clear exp history
	if(msg=="levelreset") then
		JX_AvgXP_Level_Reset();
	end
	
	-- Reset Kill History
	if(msg=="killreset") then
		JX_AvgXP_Kill_Reset();
	end
	
	-- Display Exp per Level Report
	if( (msg=="level") or (msg=="l") ) then
		JX_AvgXP_Level_Report();
	end

	-- Broadcast stats to party
	if( (msg=="party") or (msg=="p") ) then
		-- Verify they are in a party, yes it is redundancy checking
		if ( (GetNumPartyMembers()==nil) or (GetNumPartyMembers() < 1) ) then
			msg="You are not in a party.";
			display(msg);
		else
			SendChatMessage(output,"PARTY",jx_commlang,"");
		end
	end

	-- Broadcast stats to raid
	if( (msg=="raid") or (msg=="r") ) then
		-- Verify they are in a raid, yes it is redundancy checking I said that already!
		if ( (GetNumRaidMembers()==nil) or (GetNumRaidMembers() < 1) ) then
			msg="You are not in a raiding party.";
			display(msg);
		else
			SendChatMessage(output,"RAID",jx_commlang,"");
		end
	end

	-- Broadcast stats to guild
	if( (msg=="guild") or (msg=="g") ) then
		-- Verify they are in a guild, if you're reading this and didn't expect this, you my friend have serious issues with short term memory
		if ( (GetNumGuildMembers()==nil) or (GetNumGuildMembers() < 1) ) then
			msg="You are not a member of a guild.";
			display(msg);
		else
			SendChatMessage(output,"GUILD",jx_commlang,"");
		end
	end

	-- Help parameter dump parameter list
	-- This currently outputs the same as no param, but no param will be changing to GUI, retaining command line backwards compat
	if( (msg=="help") or (msg=="?") ) then
		out=GRN.."Average Experience Calculator (Use Letters in [ ] for Shortcut)\n "..YEL.."Reset"..GRN.." - Resets the calculator        :: "..YEL.."LevelReset"..GRN.." - Resets Exp History\n\n ["..YEL.."P"..GRN.."]"..YEL.."arty"..GRN.." - Broadcasts stats to Party :: ["..YEL.."R"..GRN.."]"..YEL.."aid"..GRN.." - Broadcasts stats to Raid\n ["..YEL.."G"..GRN.."]"..YEL.."uild"..GRN.." - Broadcasts stats to Guild :: ["..YEL.."#"..GRN.."] - Broadcasts stats to Channel #\n\n ["..YEL.."L"..GRN.."]"..YEL.."evel"..GRN.." - Displays Avg Exp per Level Report\n";
		display(out);
	end

-- End of Nanny

end

-- JX_AvgXP_Calc()
-- no parms
-- Desc: Event that updates the calculation
function JX_AvgXP_Calc(event)
	-- vars: string initialization
	local jx_last_xp_str = "";
	local jx_isrested = false;
	local update = false;

-- Sanity Checks : These are the things that drive you nuts because it makes the script appear like its not working properly when it should be

	if(event=="VARIABLES_LOADED") then
		-- Report Information so we can verify that initialize was called and to show version
		-- msg = GRN.."Average Exp Calculator Plus v."..jx_avgexp_version.." modded by Tolin (Original by jINx)\nSyntax: /avgxp [command] (eg. /avgxp help)\n";
		-- display(msg);
		debug(9,string.format("%sDebug is Enabled. Current Threshold is Level %d\n",GRN,jx_debug_threshold));
		debug(1,"Variables loaded, safe to load player and init\n");
		update = true;
		is_loaded = true;
	end

	-- If Variables are not loaded do not process anything
	if (not is_loaded) then
		return;
	end

	-- Wait for the player to enter the world before loading (otherwise UnitName("player") == Nil)	
	if( (event=="UNIT_NAME_UPDATE") and (arg1 == "player") ) then
		JX_AvgXP_LoadPlayer();

		-- Setup Best Average
		JX_AvgXP_FindBestAvg();

		-- Don't need to update because PLAYER_XP_UPDATE will fire next
	end

	-- If something failed with LoadPlayer or its an event call prior to UNIT_NAME_UPDATE do not process anything further
	if(not pid) then
		debug(1,"Breaking because pid is nil\n");
		return;
	end
	
	-- Check: If not initialized, and we somehow got here, Initialize!
	-- Return to break out, as Initialize will recurse and call Calc again
	-- Note: Found this can occur because PLAYER_XP_UPDATE is called OnLoad I believe
	if( (jx_avgexp_init==nil) or (jx_avgexp_init==false) ) then
		JX_AvgXP_Initialize();
		return;
	end

-- End of Sanity Checks

-- Begin Events

	-- Event: Update display for Target info
	if(event=="PLAYER_TARGET_CHANGED") then
		-- Sanity check
		if (UnitName("target")~=nil) then
			-- If its Focus and not Losing Focus
			if (UnitIsEnemy("player","target")) then
				-- Check if kill tracking exists and display 
				if (jx_kill_history[ UnitName("target") ] ~= nil) then
					jx_target_stats = string.format("Target :: %s :: Average Exp per Kill %.1f exp :: Total kills %d", UnitName("target"), (jx_kill_history[ UnitName("target") ].total_xp / jx_kill_history[ UnitName("target") ].total_kills), jx_kill_history[ UnitName("target") ].total_kills);
					AvgXPText:SetText(jx_target_stats);
				else		
					-- Check Depricated history
					if (jx_kill_history_dep[ UnitName("target") ] ~= nil) then
						jx_target_stats = string.format("Level %d :: %s :: Average Exp per Kill %.1f exp :: Total kills %d", jx_kill_history_dep[ UnitName("target") ].level, UnitName("target"), (jx_kill_history_dep[ UnitName("target") ].total_xp / jx_kill_history_dep[ UnitName("target") ].total_kills), jx_kill_history_dep[ UnitName("target") ].total_kills);
						AvgXPText:SetText(jx_target_stats);
					end
				end
			end
		else	
			-- If nil not displaying stats
			jx_target_stats = nil;
			-- Revert UI to standard Stats on losing focus
			AvgXPText:SetText(jx_avgexp_stats);
		end
	end

	-- Event: Self triggered Calc for the purpose of Updating the UI
	if(event=="JX_AVGXP_INIT") then
		update = true;
	end

	-- Event: Gain exp from a quest or exploration, update the UI and Save
	if(event=="PLAYER_XP_UPDATE") then
		update = true;
	end

	-- Event: Experience gain from Combat (Don't count kills that don't result in Experience, would skew Average Exp Gain)
	if(event=="CHAT_MSG_COMBAT_XP_GAIN") then
		jx_rested_bonus = 0;

		-- When you're rested don't count the rested exp into the average, skews it horribly
		-- By removing rested_bonus from jx_last_xp_gained we essentially process the rested_bonus as a standard PLAYER_XP_UPDATE event
		for rested_bonus in string.gfind(arg1,"(%d+) exp Rested bonus") do
			jx_isrested = true;
			jx_rested_bonus = tonumber(rested_bonus);
		end

		for mobile_name, xp in string.gfind(arg1, "(.+) dies, you gain (%d+) experience.") do
			jx_last_xp_gained = tonumber(xp);
			if (jx_isrested) then
				jx_last_xp_gained = jx_last_xp_gained - jx_rested_bonus;
				msg = string.format("Was Rested %d counted toward average (%d rested)",jx_last_xp_gained, jx_rested_bonus);
				debug(2,msg);
			end

			jx_total_xp_gained = jx_total_xp_gained + jx_last_xp_gained;
			jx_total_mobs_killed = jx_total_mobs_killed + 1;

			-- Tally the Kill (does not include rested bonus)
			JX_AvgXP_AddKill(mobile_name,jx_last_xp_gained);
		end

		-- Update the UI and Save	
		update = true;
	end

	-- Event: Player Level Up, reset stats so we get Average Exp Gain across the entire level
	if(event=="PLAYER_LEVEL_UP") then
		-- Run Level Up to store Level and Reset Avgs		
		JX_Event_Player_Level_Up();

		-- Update the UI and Save	
		update = true;
	end		

	-- If set variables have changed and should update the data, otherwise it fires everytime an event occurs
	if( update == true) then
		debug(1,string.format("Update is True - Event that fired is: %s\n",event));

		-- Calculate average (Exp Gained / Kills) - Check for Div by 0 (though LUA doesn't complain)
		if( (jx_total_mobs_killed > 0) and (jx_total_mobs_killed~=nil) ) then
			jx_avg_xp_per_mob = jx_total_xp_gained / jx_total_mobs_killed;
		end
		
		-- Calculate approximate kills to level - Check for Div by 0 again
		if( (jx_avg_xp_per_mob > 0) and (jx_avg_xp_per_mob~=nil) ) then
			jx_num_mobs_left = ( UnitXPMax("player") - UnitXP("player") ) / jx_avg_xp_per_mob;
			jx_num_mobs_left = math.ceil(jx_num_mobs_left); -- Round up
		end
	
		-- Personal pet pieve: Couldn't find a LUA inline conditional, ie C. (jx_num_mobs_left==1?"kill":"kills") this possible? (Dejavu?)
		if (jx_num_mobs_left == 1) then
			jx_kills_str = "kill";
		else
			jx_kills_str = "kills";
		end
	
		-- If last exp gained was different than average, show + for higher, - for lower
		if (jx_last_xp_gained < jx_avg_xp_per_mob) then
			jx_last_xp_str = "- ";
		else
			if (jx_last_xp_gained > jx_avg_xp_per_mob) then
				jx_last_xp_str = "+ ";
			else
				jx_last_xp_str = "  ";
			end
		end
	
		jx_exp_togo = UnitXPMax("player") - UnitXP("player");
		--jx_exp_pc = UnitXP("player") / UnitXPMax("player") * 100;
		jx_exp_pc = jx_exp_togo / UnitXPMax("player") * 100;
	
		-- Check: Cannot divide by 0, display N/A instead of attempting to display numeric, will result in -1.#IND
		if( (jx_total_mobs_killed==0) or (jx_total_mobs_killed==nil) ) then
			jx_avg_xp_per_mob_str = "N/A";
		else
			jx_avg_xp_per_mob_str = string.format("%.1f",jx_avg_xp_per_mob);
		end
	
		-- Setup stats output string
		-- Potential ToDo: Allow for custom string and .gsub to fill with values, possibly with tracking more this would be useful
		local RXP = GetXPExhaustion();
		if(RXP == nil) then
		jx_avgexp_stats = string.format("Exp: %d/%d :: %.1f%% till level %d :: %s exp left :: Avg Exp per Kill %s %s:: %d %s to level", UnitXP("player"), UnitXPMax("player"), jx_exp_pc, (UnitLevel("player")+1), comma(jx_exp_togo), jx_avg_xp_per_mob_str, jx_last_xp_str, jx_num_mobs_left, jx_kills_str);
		else
		jx_avgexp_stats = string.format("Exp: %d/%d(%d) :: %.1f%% till level %d :: %s exp left :: Avg Exp per Kill %s %s:: %d %s to level", UnitXP("player"), UnitXPMax("player"), GetXPExhaustion(), jx_exp_pc, (UnitLevel("player")+1), comma(jx_exp_togo), jx_avg_xp_per_mob_str, jx_last_xp_str, jx_num_mobs_left, jx_kills_str);
		end
		-- Update UI
		AvgXPText:SetText(jx_avgexp_stats);
	
		-- Update the Saved Table	
		JX_AvgXP_SavePlayer();	
	end

-- End Events

end


