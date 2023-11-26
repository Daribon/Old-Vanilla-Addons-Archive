--	///////////////////////////////////////////////////////////////////////////////////////////

--[[	
REDUX version of WatchTower by nathanmx
Original author and contributer information below
_______
1.7
- instead of using -1 when reporting ?? players, now you will report a predicted minimum level
- updated a function that would not always return the correct localdefense channel
- removed onload chat spam
- added Ultimate UI button registration code
- commented up report function for easy player editing

1.6
- removed outdated unitfacing() functions
- added unitname() to output
- now allows tracking of your own faction as well
- removed pvp enabled / disabled code as it wasn't functioning correctly
- changed display output to a better, more clear format that doesn't take up as much space
- fixed keybindings
- added player coordinates to the output

]]--

--
--	WatchTower:	Developed for use in Realm Defense. WatchTower allows you to automatically announce to the area all
--			pertinant information about the invaders. Simply click on the invader and use your hot key to Report
--			enemy. Information included in your message will be Faction, Race, Level, Current Subzone they are in and 
--			which way they are headed (N, NE, E, SE, S, SW, W, NW). Or, you may use your muliple reporting hotkey,
--			mouseover all enemies you wish to report, and then hit the hotkey again to report multiple enemies at once.
--
--	Official Site: 	www.grimeygames.com/wow
--		
--	Contributions: Rowne's Variable Saves/Loads and GUI Detection.  Sancho's multiple enemy reporting code.
--	
--	License: You are hereby authorized to freely modify and/or distribute all files of this add-on, in whole or in part,
--		providing that this header stays intact, and that you do not claim ownership of this Add-on.
--		
--		Additionally, the original owner wishes to be notified by email if you make any improvements to this add-on.
--		Any positive alterations will be added to a future release, and any contributing authors will be 
--		identified in the section above. Contact at fcarentz@grimeygames.com
--	
--	Features:
--			v1.5 - Additions by Sancho:  Multiple enemy reporting, Raid channel broadcasting
--				1.5 Bug Fixes (Sancho)
--					-Fixed faction auto-detection (hopefully) and removed from saved variable list
--					-Fixed language auto-detection (hopefully) and removed from saved variable list
--			v1.4 - Added detection for GUI to show saved settings. Added Rownes Variable saves and GUI detection.
--				1.4 Bug Fixes
--					- Auto Language detection to determine what language the message should be sent in.
--					- REmoved bug causing error on NPC Targeting. Will now display message that player can only
--					  target players of the selected enemy faction.
--
--			v1.3 - Added GUI interface...and options to send message to Party, Guild and Local Def. 
--						added Simple slash commands.
--			v1.2 - Corrected Autofaction code. Added Message notification of Enemy Faction, also added 
--					 	message telling user if Target is currently PVP enabled or not. 
--			v1.1 - Removed the Player Set variable of WTChannel to allow program to post to Local Defense.
--						Added autodetect for faction on load of Watch Tower. WatchTower will now automatically
--						set your enemy faction to the opposite of that which you are playing.
--
--         v1.0 - Sends message containing targets Faction, Race, Level, Subzone and Heading (Compass Style)
--	
--	///////////////////////////////////////////////////////////////////////////////////////////


	
	
-----------------------------------------------------------------------------------------------------------
--DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING--
-----------------------------------------------------------------------------------------------------------
BINDING_HEADER_WATCHTOWER = "Watch Tower";
BINDING_NAME_WT_REPORT = "Report Enemy";
BINDING_NAME_WT_TOGGLE = "Toggle Watch Tower";
BINDING_NAME_WT_FACTION = "Switch Faction Enemy";
BINDING_NAME_WT_REPORT_MULTIPLE = "Report Multiple Enemies With Mouseover";
BINDING_NAME_WT_REPORT_PVP_TOGGLE = "Toggle PvP only reporting";
WATCHTOWERTITLE = "The Watch Tower";
WT_PARTY = "Send To Party";
WT_RAID = "Send To Raid";
WT_GUILD = "Send To Guild";
WT_DEFENSE = "Local Defense";
FactionSetTo = "";
WT_Language= "";

local HasCheckedFaction = false;
local PlayerCollectionEnabled = false;
local ReportPvPOnly = false;
local ClassOrder = {"Warrior", "Paladin", "Priest", "Hunter", "Rogue", "Shaman", "Mage", "Warlock", "Druid"};
local NumOfPlayers = 0;
local PlayerNames = { "" };
local PlayerLevels = { };
local SortedPlayerLevels = { };
local AverageLevel = 0;
local PlayerClasses = { };
local SortedPlayerClasses = { };
local PlayerRaces = { };
local SortedPlayerRaces = { };
local PlayerClassCounts = {0, 0, 0, 0, 0, 0, 0, 0, 0};

function WT_OnEvent()
	-- Register command handler and new commands
	SlashCmdList["WatchTowerCOMMAND"] = WTStatusSlashHandler;
	SLASH_WatchTowerCOMMAND1 = "/watchtower";
	SLASH_WatchTowerCOMMAND2 = "/wt";

	   
    if (event == "VARIABLES_LOADED") then
    	if (WatchTowerEnabled == nil) then
		WatchTowerEnabled = true;
	end
	if (WatchTower_SendParty == nil or WatchTower_SendLocal == nil or WatchTower_SendGuild == nil or WatchTower_SendRaid == nil) then
		if (WatchTower_SendParty == nil) then
			WatchTower_SendParty = false;
		end
		if (WatchTower_SendRaid == nil) then
			WatchTower_SendRaid = false;
		end
		if (WatchTower_SendGuild == nil) then
			WatchTower_SendGuild = false;
		end 
		if (WatchTower_SendLocal == nil) then
			WatchTower_SendLocal = false;
		end
		ShowUIPanel(WT_FrameTemplate);
	end
		--Let the player know that WatchTower has Loaded.
		-- Ultimate UI users won't see this spam
		if( not UltimateUI_IsLoaded ) then
			WatchTowerStatusChatMsg("WatchTower loaded. Type /wt to display options.");
			WatchTowerStatusChatMsg("Remember to set up your Key Bindings.");
		end
		WT_SetCheckBox();
	end
	if(PlayerCollectionEnabled and WatchTowerEnabled and event == "UPDATE_MOUSEOVER_UNIT" and UnitExists("mouseover")) then
		TargetUnit("mouseover");
		if (UnitFactionGroup("target") == FactionSetTo and UnitPlayerControlled("target") and UnitIsPlayer("target") and (UnitIsPVP("target") or not ReportPvPOnly)) then
						local tempname = UnitName("target");
						local isNew = true;
						for i=1, NumOfPlayers + 1 do
							if (PlayerNames[i] == tempname) then
								isNew = false;
							end
						end
						if(isNew) then
							Sancho_AddPlayer();
						else
							--For debugging
							WatchTowerStatusChatMsg("PLAYER ALREADY ADDED");
						end
		end
	end	
end

function WT_OnLoad()
	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	this:RegisterEvent("VARIABLES_LOADED");
	SLASH_WATCHTOWER1 = "/watchtower";
	SLASH_WATCHTOWER2 = "/wt";
	SlashCmdList["WATCHTOWER"] = WatchTower_ShowUI;
	
	-- Register with UltimateUI
	if(UltimateUI_RegisterButton) then
		UltimateUI_RegisterButton( 
			"WatchTower", 
			"Settings", 
			"|cFF00CC00WatchTower|r\nAllows you to report information about friendly\nand enemy targets in various chat channels", 
			"Interface\\Icons\\Ability_Druid_ChallangingRoar", 
			WatchTowerDisplay
		);
	end
	
end

--Executed by the user via a script, slash command, or bindable key

function Sancho_ReportToggle()
	if(PlayerCollectionEnabled == false) then
		PlayerCollectionEnabled = true;
		if(HasCheckedFaction == false) then
			SetFaction(UnitFactionGroup("player"));
			HasCheckedFaction = true;
		end
		WatchTowerStatusChatMsg("WatchTower player collection enabled");
		WatchTowerStatusChatMsg("Reporting " .. FactionSetTo .. " enemies");
		if(ReportPvPOnly) then
			WatchTowerStatusChatMsg("Reporting only PvP players");
		else
			WatchTowerStatusChatMsg("Reporting PvP and non-PvP players");
		end
	else
		PlayerCollectionEnabled = false;
		Sancho_PrintData();
		Sancho_ClearData();
	end
end

--Toggles whether the addon should report PvP enabled enemies only (default is PvP + non-PvP)

function PvPOnlyToggle()
	ReportPvPOnly = not ReportPvPOnly;
	if(ReportPvPOnly) then
		WatchTowerStatusChatMsg("Will report only PvP players");
	else
		WatchTowerStatusChatMsg("Will report PvP and non-PvP players");
	end
end

--Function assumes that an enemy unit is selected which is not already in the tables

function Sancho_AddPlayer()
	NumOfPlayers = NumOfPlayers + 1;
	if(NumOfPlayer == 1) then
		--Facing = math.deg(UnitFacing("target")); --Change facing to Degrees
	end
	PlayerNames[NumOfPlayers] = UnitName("target");
	PlayerClasses[NumOfPlayers] = UnitClass("target");
	PlayerLevels[NumOfPlayers] = UnitLevel("target");
	PlayerRaces[NumOfPlayers] = UnitRace("target");
	--Was for debugging, but keeping it until a better way is developed of telling the
	--user which players have already been added (i.e. highlighting the added players somehow)
	WatchTowerStatusChatMsg("Added (" .. NumOfPlayers .. " Players)");
end

--Prints results, will only be done after data collection has been stopped

function Sancho_PrintData()
	if(NumOfPlayers ~= 0) then
		Sancho_ClassBreakdown();
		Sancho_SortLevels();
	end
	local tMessage = "";		

	if(not ReportPvPOnly) then
		tMessage = tMessage .. "WatchTower: " .. NumOfPlayers .. " " .. FactionSetTo ..
					" attacking " .. GetMinimapZoneText() .. "! ";
	else
		tMessage = tMessage .. "WatchTower: " .. NumOfPlayers .. " PvP enabled " .. FactionSetTo ..
					" attacking " .. GetMinimapZoneText() .. "! ";
	end
	if(NumOfPlayers > 50) then
		Sancho_CalculateAverage();
		tMessage = tMessage .. "Lowest level: " .. SortedPlayerLevels[1] ..
						" Highest level: " .. SortedPlayerLevels[NumOfPlayers] ..
						" Average level: " .. string.format("%.1f", AverageLevel);
	elseif(NumOfPlayers > 20) then
		tMessage = tMessage .. "lvls: ";
		for i=1, NumOfPlayers do
			tMessage = tMessage .. SortedPlayerLevels[i] .. " ";
		end
	elseif(NumOfPlayers > 10) then
		local temporarycounter = 0; --<<keeps track of how many players are processed,
		for i=1, 9 do		    ----so that it knows if it should add a comma or not
			if(PlayerClassCounts[i] ~= 0) then
					--For the first loop, i = 1, ClassOrder[1] will be a Warrior
					--If there are 2 warriors, for example, the first loop will add
					--"2 Warrior" and "s" since there are more than one
					--and ", " if there are more than 2 total players
				tMessage = tMessage .. PlayerClassCounts[i] .. " " .. ClassOrder[i];
				if(PlayerClassCounts[i] > 1) then
					tMessage = tMessage .. "s";
				end
				temporarycounter = temporarycounter + PlayerClassCounts[i];
				if(temporarycounter < NumOfPlayers) then
					tMessage = tMessage .. ", ";
				end
			end
		end
		tMessage = tMessage .. " - lvls: ";
		for i=1, NumOfPlayers do
			tMessage = tMessage .. SortedPlayerLevels[i] .. " ";
		end
	elseif(NumOfPlayers > 5) then
		for i=1, NumOfPlayers do
			tMessage = tMessage .. "lvl " .. SortedPlayerLevels[i] .. " " .. SortedPlayerClasses[i];
			if(i < NumOfPlayers) then
				tMessage = tMessage .. ", ";
			end
		end
	elseif(NumOfPlayers > 0) then
		for i=1, NumOfPlayers do
			tMessage = tMessage .. "Level " .. SortedPlayerLevels[i] .. " " .. SortedPlayerRaces[i] .. " " .. SortedPlayerClasses[i];
			if(i < NumOfPlayers) then
				tMessage = tMessage .. ", ";
			end
		end
	else
		--Just in case
	end
	--Actually sends the data to whichever channel is wanted
	if(NumOfPlayers ~= 0) then
		if (UnitFactionGroup("player") == "Horde") then
			WT_Language = "Orcish";
		else
			WT_Language = "Common";
		end
		if (WatchTower_SendLocal == true) then
			tempArray = { GetMapZones(GetCurrentMapContinent()) }; 
			mapZone = tempArray[GetCurrentMapZone()]; 
			localDef = GetChannelName("LocalDefense - " ..mapZone); 
			SendChatMessage(tMessage ,"CHANNEL", WT_Language, localDef);
		end

		if WatchTower_SendGuild == true then
			SendChatMessage(tMessage ,"Guild");
		end

		if WatchTower_SendParty == true then
			SendChatMessage(tMessage ,"Party");
		end
		
		if WatchTower_SendRaid == true then
			SendChatMessage(tMessage ,"Raid");
		end

		--WatchTowerStatusChatMsg(tMessage);
	else
		WatchTowerStatusChatMsg("No enemies to report.  Is your faction set right?  Is PvP only reporting enabled?");
	end
end

--Run after the data is printed .. also sorts classes and races to match up with levels when needed

function Sancho_SortLevels()
	for i=1, NumOfPlayers do
		for j=1, i do
			if(SortedPlayerLevels[j] == nil or SortedPlayerLevels[j] > PlayerLevels[i]) then
				table.insert(SortedPlayerLevels, j, PlayerLevels[i]);
				table.insert(SortedPlayerClasses, j, PlayerClasses[i]);
				table.insert(SortedPlayerRaces, j, PlayerRaces[i]);
				break;
			end
		end
	end
	--For testing
	--for i=1, NumOfPlayers do
	--	WatchTowerStatusChatMsg(SortedPlayerLevels[i]);
	--end
end

function Sancho_CalculateAverage()
	for i=1, NumOfPlayers do
		AverageLevel = AverageLevel + PlayerLevels[i];
	end
	AverageLevel = AverageLevel / NumOfPlayers;
end

--Will make an array with elements based on the number of each class
--For example PlayerClasses[1] would equal the number of Warriors (see ClassOrder)

function Sancho_ClassBreakdown()
	for i=1, NumOfPlayers do
		for j=1, 9 do
			if(PlayerClasses[i] == ClassOrder[j]) then
				PlayerClassCounts[j] = PlayerClassCounts[j] + 1;
			end
		end
	end
end

function Sancho_ClearData()
	NumOfPlayers = 0;
	PlayerNames = { "" };
	PlayerLevels = { };
	SortedPlayerLevels = { };
	PlayerClasses = { };
	SortedPlayerClasses = { };
	PlayerRaces = { };
	SortedPlayerRaces = { };
	PlayerClassCounts = {0, 0, 0, 0, 0, 0, 0, 0, 0}
end

function WTReportEnemy()
	if(HasCheckedFaction == false) then
		SetFaction(UnitFactionGroup("player"));
		HasCheckedFaction = true;
	end
	if (WatchTowerEnabled == true) then
		if (UnitPlayerControlled("target") and UnitIsPlayer("target")) then --make sure that the unit is the correct faction
			-- Gather all the needed information about the target
			local tClass, tLevel, tFaction, tRace, tLoc, tPvP, tName;
			tName = UnitName("target");
			tClass = UnitClass("target");
			tLevel = UnitLevel("target");
			tFaction = UnitFactionGroup("target");
			tRace = UnitRace("target");
			tLoc = GetMinimapZoneText();
			tSubZone = GetSubZoneText() ; -- not really used
			
			-- Change the '-1' return of UnitLevel() to a minimum predicted level
			if (tLevel == -1) then
				if (UnitLevel("player") == 50) then
					tLevel = "60";
				else
					tLevel = "?? (" .. tostring(UnitLevel("player") + 10) .. "+)";
				end
			end
			
			-- Get Player rounded player coords
			local posX, posY = GetPlayerMapPosition("player");
			posX = posX * 100;
			posY = posY * 100;
			posX = math.floor(posX);
			posY = math.floor(posY);
			
			-- Put the faction name in all caps
			tFaction = string.upper(tFaction);
			
			-- Format the message
			tMessage = "" .. tFaction .. " <" .. tName .. ", ".. tLevel .. " " .. tRace .. " " .. tClass .. "> near (" .. posX .."," .. posY .. ") in ".. tLoc .. "";
			
			-- original watchtower message
			--	tMessage = "WatchTower: " .. tPvP .. " " .. tFaction .. " "..tRace.." "..tClass.." (lvl:".. tLevel .. ")".." seen heading through "..tLoc.."";
			
			-- Set which default language to use
			if (UnitFactionGroup("player") == "Horde") then
				WT_Language = "Orcish";
			else
				WT_Language = "Common";
			end
			
			-- Send to local defense, if enabled
			if (WatchTower_SendLocal == true) then
				tempArray = { GetMapZones(GetCurrentMapContinent()) }; 
				mapZone = tempArray[GetCurrentMapZone()]; 
				if (mapZone) then
					localDef = GetChannelName("LocalDefense - " .. mapZone); 
				else
					mapZone = GetMinimapZoneText();
					localDef = GetChannelName("LocalDefense - " .. mapZone); 
				end
				SendChatMessage(tMessage ,"CHANNEL", WT_Language, localDef);
			end
				
			-- Send to guild / party / raid, if enabled
			if (WatchTower_SendGuild == true) then
				SendChatMessage(tMessage,"Guild");
			end
			if (WatchTower_SendParty == true) then
				SendChatMessage(tMessage,"Party");
			end
			if (WatchTower_SendRaid == true) then
				SendChatMessage(tMessage,"Raid");
			end
		else
			WatchTowerStatusChatMsg("You can only track player-controlled units.");
		end 
	end
end

function ToggleWatchTower()
   if (WatchTowerEnabled == true) then
		WatchTowerEnabled = false;
		WatchTowerStatusChatMsg("WatchTower Disabled.");
   else
		WatchTowerEnabled = true;
		WatchTowerStatusChatMsg("WatchTower Enabled.");
   end
end

function WTStatusSlashHandler(msg)
	if (msg == nil) then 
		msg = "";
	end
	msg = string.lower(msg);

	local num, offset, command, args = string.find (msg, "(%w+) (%w+)");    
	if (command == nil) then 
		WatchTowerDisplay();
	elseif string.lower(command) == "toggle" then
        ToggleWatchTower();
    elseif string.lower(command) == "faction" then
	    SetFaction(arg);
    else
		WatchTowerDisplay();
	end
end

function WatchTowerStatusChatMsg(msg)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

function SetFaction(faction)
	-- Determine the Players Faction upon login and automatically set 
	-- them to the correct enemy type.
	if (faction==nil) then
		faction= UnitFactionGroup("player");
	end

	if (faction == "Horde") then
		FactionSetTo = "Alliance";
		--WatchTowerStatusChatMsg("Enemy set to Alliance");
	else
		FactionSetTo = "Horde";
		--WatchTowerStatusChatMsg("Enemy set to Horde");
	end
end

function WatchTowerDisplay()
    local text = "";
	text = text .. "/wt To open options dialog box\n";
	text = text .. "Remember to set up your Keybindings.\n";
	ShowUIPanel(WT_FrameTemplate);
	WatchTowerStatusChatMsg(text);
end

function SendGuildMess()
	--Set the Variables to reflect the options of the user
	--according to the GUI selections
	if WatchTower_SendGuild == true then
		WatchTower_SendGuild = false;
	else
		WatchTower_SendGuild = true;
	end
	
end
function SendPartyMess()
	if WatchTower_SendParty == true then
		WatchTower_SendParty = false;
	else
		WatchTower_SendParty = true;
	end
end
function SendLocalMess()
	if WatchTower_SendLocal == true then
		WatchTower_SendLocal = false;
	else
		WatchTower_SendLocal = true;
		
	end
end
function SendRaidMess()
	if WatchTower_SendLocal == true then
		WatchTower_SendRaid = false;
	else
		WatchTower_SendRaid = true;
		
	end
end

function WT_SetCheckBox()
	--Make the GUI show if Options are selected or not 
	--dependant upon the variables.
	if WatchTower_SendLocal == true then
		WT_Checkbox3:SetChecked(1);
		--WatchTowerStatusChatMsg("Local True");
	else
		WT_Checkbox3:SetChecked(0);
		--WatchTowerStatusChatMsg("Local False");
	end
	
	if WatchTower_SendGuild == true then
		WT_Checkbox2:SetChecked(1);
		--WatchTowerStatusChatMsg("Guild True");
	else
		WT_Checkbox2:SetChecked(0);
		--WatchTowerStatusChatMsg("Guild False");
	end
	if WatchTower_SendRaid == true then
		WT_Checkbox1:SetChecked(1);
		--WatchTowerStatusChatMsg("Raid True");
	else
		WT_Checkbox1:SetChecked(0);
		--WatchTowerStatusChatMsg("Raid False");
	end
	if WatchTower_SendParty == true then
		WT_Checkbox0:SetChecked(1);
		--WatchTowerStatusChatMsg("Party True");
	else
		WT_Checkbox0:SetChecked(0);
		--WatchTowerStatusChatMsg("Party False");
	end
			
end
