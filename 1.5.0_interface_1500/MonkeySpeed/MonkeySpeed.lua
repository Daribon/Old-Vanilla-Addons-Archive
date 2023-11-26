--[[

	MonkeySpeed:
	A simple speedometer.
	
	Author: Trentin
	
	Resurected by: Quel

--]]

-- define the dialog box for reseting config
StaticPopupDialogs["MONKEYSPEED_RESET"] = {
	text = TEXT(MONKEYSPEED_CONFIRM_RESET),
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		MonkeySpeed_ResetConfig();
	end,
	timeout = 0,
	exclusive = 1
};

-- Script array, not saved
MonkeySpeed = {};
MonkeySpeed.m_iDeltaTime = 0;
--MonkeySpeed.m_fDefaultSpeed = 7.0;

MonkeySpeed.m_fSpeed = 0.0;
MonkeySpeed.m_fSpeedDist = 0.0;
MonkeySpeed.m_bLoaded = false;
MonkeySpeed.m_bVariablesLoaded = false;
MonkeySpeed.m_strPlayer = "";
--MonkeySpeed.m_vLastPos = {};

local ZoneBaseline2 = { {zid=1, rate=0.00210}, -- Alterac Mtns
			{zid=2, rate=0.00292}, -- Arathi Highlands
			{zid=3, rate=0.0042}, -- Bad Lands
			{zid=4, rate=0.00313}, -- Blasted Lands
			{zid=5, rate=0.00359}, -- Burning Steppes
			{zid=6, rate=0.00420}, -- Deadwind pass
			{zid=7, rate=0.00213}, -- Dun Morogh
			{zid=8, rate=0.00389}, -- Duskwood
			{zid=9, rate=0.00271}, -- Eastern Plaguelands
			{zid=10, rate=0.00302}, -- Elwynn Forest
			{zid=11, rate=0.00328},	-- Hillsbrad
			{zid=12, rate=0.01327},	-- Iron Forge
			{zid=13, rate=0.00381},	-- Loch Modan
			{zid=14, rate=0.00484}, -- Redridge Mnts
			{zid=15, rate=0.0001},
			{zid=16, rate=0.0001},	 
			{zid=17, rate=0.00781}, -- Stormwind
			{zid=18, rate=0.00165}, -- Stranglethorn Vale
			{zid=19, rate=0.00458}, -- Swamp of Sorrows
			{zid=20, rate=0.0001},
			{zid=21, rate=0.00232}, -- Tristfall Glades
			{zid=22, rate=0.01094}, -- Undercity
			{zid=23, rate=0.00244}, -- Western Plaguelands
			{zid=24, rate=0.00300}, -- Westfall
			{zid=25, rate=0.00254}	-- Wetlands
			 };
local ZoneBaseline1 = { {zid=1, rate=0.00182}, -- Ashenvale
			{zid=2, rate=0.00207}, -- Azshara
			{zid=3, rate=0.00160}, -- Darkshore
			{zid=4, rate=0.0001},	
			{zid=5, rate=0.00234}, -- Desolace
			{zid=6, rate=0.00199}, -- Durotar
			{zid=7, rate=0.00200}, -- dustwallow marsh
			{zid=8, rate=0.00183}, -- felwood
			{zid=9, rate=0.00151}, -- feralas
			{zid=10, rate=0.00455}, -- Moonglade
			{zid=11, rate=0.00204},	-- Mulgore
			{zid=12, rate=0.00748}, -- Orgrimmar
			{zid=13, rate=0.00151},	-- Silithus
			{zid=14, rate=0.00215}, -- Stonetalon Mtns
			{zid=15, rate=0.00152}, -- Tanaris
			{zid=16, rate=0.0001},
			{zid=17, rate=0.00104}, -- The Barrens
			{zid=18, rate=0.00239}, -- Thousand Needles
			{zid=19, rate=0.01006}, -- Thunderbluff
			{zid=20, rate=0.00284}, -- Un'Goro Crater
			{zid=21, rate=0.00148}, -- Winterspring
			{zid=22, rate=0.0001},
			{zid=23, rate=0.0001},
			{zid=24, rate=0.0001},
			{zid=25, rate=0.0001}	
			 };	

function MonkeySpeed_Init()
		
	-- double check that we didn't already load
	if ((MonkeySpeed.m_bLoaded == false) and (MonkeySpeed.m_bVariablesLoaded == true)) then
		
		-- add the realm to the "player's name" for the config settings
		MonkeySpeed.m_strPlayer = GetCVar("realmName").."|"..MonkeySpeed.m_strPlayer;
		
		if (not MonkeySpeedConfig) then
			MonkeySpeedConfig = { };
		end
		
		-- now we're ready to calculate speed
		MonkeySpeed.m_vLastPos = {};
--		MonkeySpeed.m_vLastPos.x, MonkeySpeed.m_vLastPos.y, MonkeySpeed.m_vLastPos.z = MonkeySpeed_ParsePosition(GetCurrentPosition());
		MonkeySpeed.m_vLastPos.x, MonkeySpeed.m_vLastPos.y = GetPlayerMapPosition("player");

		-- if there's not an entry for this
		if (not MonkeySpeedConfig[MonkeySpeed.m_strPlayer]) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer] = {};
		end
		
		-- set the defaults if the values weren't loaded by the SavedVariables.lua
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay == nil) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay = true;
		end
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent == nil) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent = true;
		end
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar == nil) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar = true;
		end
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_fUpdateRate == nil) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_fUpdateRate = 0.5;
		end
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDebugMode == nil) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDebugMode = false;
		end
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked == nil) then
			MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked = false;
		end
		
		-- show or hide the right options
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay) then
			MonkeySpeedFrame:Show();
		else
			MonkeySpeedFrame:Hide();
		end
		
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent) then
			MonkeySpeedText:Show();
		else
			MonkeySpeedText:Hide();
		end
		
		if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar) then
			MonkeySpeedBar:Show();
		else
			MonkeySpeedBar:Hide();
		end
		
		-- All variables are loaded now
		MonkeySpeed.m_bLoaded = true;
		
		-- print out a nice message letting the user know the addon loaded
		if (DEFAULT_CHAT_FRAME) then
			DEFAULT_CHAT_FRAME:AddMessage(MONKEYSPEED_LOADED);
		end
	end
end

-- OnLoad Function
function MonkeySpeed_OnLoad()
	
	-- register for save (obsolete)
	RegisterForSave("MonkeySpeedConfig");
	
	-- register events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_NAME_UPDATE");			-- this is the event I use to get per character config settings
	this:RegisterEvent("PLAYER_ENTERING_WORLD");	-- this event gives me a good character name in situations where "UNIT_NAME_UPDATE" doesn't even trigger

	-- register chat slash commands
	-- this command toggles the percent display
	SlashCmdList["MONKEYSPEED_PERCENT"] = MonkeySpeed_TogglePercent;
	SLASH_MONKEYSPEED_PERCENT1 = "/monkeyspeedpercent";
	SLASH_MONKEYSPEED_PERCENT2 = "/mspercent";
	
	-- this command toggles the coloured speed bar display
	SlashCmdList["MONKEYSPEED_BAR"] = MonkeySpeed_ToggleBar;
	SLASH_MONKEYSPEED_BAR1 = "/monkeyspeedbar";
	SLASH_MONKEYSPEED_BAR2 = "/msbar";
	
	-- this command toggles the whole speed bar display
	SlashCmdList["MONKEYSPEED_DISPLAY"] = MonkeySpeed_ToggleDisplay;
	SLASH_MONKEYSPEED_DISPLAY1 = "/monkeyspeed";
	SLASH_MONKEYSPEED_DISPLAY2 = "/mspeed";
	
	-- this command toggles the debug mode
	SlashCmdList["MONKEYSPEED_DEBUG"] = MonkeySpeed_ToggleDebug;
	SLASH_MONKEYSPEED_DEBUG1 = "/monkeyspeeddebug";
	SLASH_MONKEYSPEED_DEBUG2 = "/msdebug";
	
	-- this command toggles the lock
	SlashCmdList["MONKEYSPEED_LOCK"] = MonkeySpeed_ToggleLock;
	SLASH_MONKEYSPEED_LOCK1 = "/monkeyspeedlock";
	SLASH_MONKEYSPEED_LOCK2 = "/mslock";
	
	MonkeySpeedFrame:SetBackdropBorderColor(0.75, 0.75, 0.75, 1.0);
end

-- OnEvent Function
function MonkeySpeed_OnEvent(event)
	
	if (event == "VARIABLES_LOADED") then
		-- this event gets called when the player enters the world
		--  Note: on initial login this event will not give a good player name
		
		MonkeySpeed.m_bVariablesLoaded = true;
		
		-- double check that the mod isn't already loaded
		if (not MonkeySpeed.m_bLoaded) then
			
			MonkeySpeed.m_strPlayer = UnitName("player");
			
			-- if MonkeySpeed.m_strPlayer is "Unknown Entity" get out, need a real name
			if (MonkeySpeed.m_strPlayer ~= nil and MonkeySpeed.m_strPlayer ~= UNKNOWNOBJECT) then
				-- should have a valid player name here
				MonkeySpeed_Init();
			end
		end
		
		-- exit this event
		return;
		
	end -- PLAYER_ENTERING_WORLD
	
	if (event == "UNIT_NAME_UPDATE") then
		-- this event gets called whenever a unit's name changes (supposedly)
		--  Note: Sometimes it gets called when unit's name gets set to
		--  "Unknown Entity"
				
		-- double check that we are getting the player's name update
		if (arg1 == "player" and not MonkeySpeed.m_bLoaded) then
			-- this is the first place I know that reliably gets the player name
			MonkeySpeed.m_strPlayer = UnitName("player");
			
			-- if MonkeySpeed.m_strPlayer is "Unknown Entity" get out, need a real name
			if (MonkeySpeed.m_strPlayer ~= nil and MonkeySpeed.m_strPlayer ~= UNKNOWNOBJECT) then
				-- should have a valid player name here
				MonkeySpeed_Init();
			end
		end
		
		-- exit this event
		return;
		
	end -- UNIT_NAME_UPDATE
	if (event == "PLAYER_ENTERING_WORLD") then
		-- this event gets called when the player enters the world
		--  Note: on initial login this event will not give a good player name
		
		-- double check that the mod isn't already loaded
		if (not MonkeySpeed.m_bLoaded) then
			
			MonkeySpeed.m_strPlayer = UnitName("player");
			
			-- if MonkeySpeed.m_strPlayer is "Unknown Entity" get out, need a real name
			if (MonkeySpeed.m_strPlayer ~= nil and MonkeySpeed.m_strPlayer ~= UNKNOWNOBJECT) then
				-- should have a valid player name here
				MonkeySpeed_Init();
			end
		end
		
		-- exit this event
		return;
		
	end -- PLAYER_ENTERING_WORLD
end

-- OnUpdate Function (heavily based off code in Telo's Clock)
function MonkeySpeed_OnUpdate(arg1)

	-- if the speedometer's not loaded yet, just exit
	if (not MonkeySpeed.m_bLoaded) then
		return;
	end
	
	-- how long since the last update?
	MonkeySpeed.m_iDeltaTime = MonkeySpeed.m_iDeltaTime + arg1;
	
	-- update the speed calculation
	MonkeySpeed.m_vCurrPos = {};
	MonkeySpeed.m_vCurrPos.x, MonkeySpeed.m_vCurrPos.y = GetPlayerMapPosition("player");
	MonkeySpeed.m_vCurrPos.x = MonkeySpeed.m_vCurrPos.x + 0.0;
	MonkeySpeed.m_vCurrPos.y = MonkeySpeed.m_vCurrPos.y + 0.0;

	if (MonkeySpeed.m_vCurrPos.x) then
		local dist;
		
		-- travel speed ignores Z-distance (i.e. you run faster up or down hills)	
		-- x and y coords are not square, had to weight the x by 2.25 to make the readings match the y axis.
		dist = math.sqrt(
				((MonkeySpeed.m_vLastPos.x - MonkeySpeed.m_vCurrPos.x) * (MonkeySpeed.m_vLastPos.x - MonkeySpeed.m_vCurrPos.x) * 2.25 ) +
				((MonkeySpeed.m_vLastPos.y - MonkeySpeed.m_vCurrPos.y) * (MonkeySpeed.m_vLastPos.y - MonkeySpeed.m_vCurrPos.y)));
		
		MonkeySpeed.m_fSpeedDist = MonkeySpeed.m_fSpeedDist + dist;
		if (MonkeySpeed.m_iDeltaTime >= .5) then

--			The map coords seem to be a different scale in different zones. Figure out which zone we're in
			local zonenum;
			local contnum;
			local baserate;

			zonenum = GetCurrentMapZone();
			if (zonenum ~= 0) then
				contnum = GetCurrentMapContinent();
				f,h,w = GetMapInfo();
				if (contnum == 2) then
					baserate = ZoneBaseline2[zonenum].rate;
				else
					baserate = ZoneBaseline1[zonenum].rate;
				end

				if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDebugMode == true) then
					-- Debug code for figuring out new zone rates

					if (DEFAULT_CHAT_FRAME) then
						if (dist ~= 0 and baserate == 0.0001) then
							DEFAULT_CHAT_FRAME:AddMessage(format("ZoneBaseline"..contnum.."  zid="..zonenum.."  rate=%.5f", 
								(MonkeySpeed.m_fSpeedDist / MonkeySpeed.m_iDeltaTime)));
						end
					end
				end
				
				MonkeySpeed.m_fSpeed = MonkeySpeed_Round(((MonkeySpeed.m_fSpeedDist / MonkeySpeed.m_iDeltaTime) / baserate) * 100);
			
				MonkeySpeed.m_fSpeedDist = 0.0;
				MonkeySpeed.m_iDeltaTime = 0.0;
			
				if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent) then
					-- Set the text for the speedometer
					MonkeySpeedText:SetText(format("%d%%", MonkeySpeed.m_fSpeed));
				end
			
				if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar) then
					-- Set the colour of the bar
					if (MonkeySpeed.m_fSpeed == 0.0) then
						MonkeySpeedBar:SetVertexColor(1, 0, 0);
					elseif (MonkeySpeed.m_fSpeed < 100.0) then
						MonkeySpeedBar:SetVertexColor(1, 0.25, 0);
					elseif (MonkeySpeed.m_fSpeed == 100.0) then
						MonkeySpeedBar:SetVertexColor(1, 0.5, 0);
					elseif ((MonkeySpeed.m_fSpeed > 100.0) and (MonkeySpeed.m_fSpeed < 140.0)) then
						MonkeySpeedBar:SetVertexColor(0, 1, 0);
					elseif ((MonkeySpeed.m_fSpeed >= 140.0) and (MonkeySpeed.m_fSpeed < 200.0)) then
						MonkeySpeedBar:SetVertexColor(1, 0, 1);
					elseif ((MonkeySpeed.m_fSpeed >= 200.0) and (MonkeySpeed.m_fSpeed < 550.0)) then
						MonkeySpeedBar:SetVertexColor(0.5, 0, 1);
					elseif (MonkeySpeed.m_fSpeed >= 550.0) then
						MonkeySpeedBar:SetVertexColor(0, 0, 1);
					end
				end
			end
		end

		MonkeySpeed.m_vLastPos.x = MonkeySpeed.m_vCurrPos.x;
		MonkeySpeed.m_vLastPos.y = MonkeySpeed.m_vCurrPos.y;
		MonkeySpeed.m_vLastPos.z = MonkeySpeed.m_vCurrPos.z;
	end
end

-- when the mouse goes over the main frame, this gets called
function MonkeySpeed_OnEnter()
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	-- set the tool tip text
	GameTooltip:SetText(MONKEYSPEED_TITLE, 255/255, 209/255, 0/255);
	GameTooltip:AddLine("Left-click to move", 1.00, 1.00, 1.00);
	GameTooltip:AddLine("Right-click to configure", 1.00, 1.00, 1.00);	
	GameTooltip:AddLine(MONKEYSPEED_DESCRIPTION, 80/255, 143/255, 148/255);
	GameTooltip:Show();
end

function MonkeySpeed_OnMouseDown(arg1)
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (arg1 == "LeftButton" and MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked == false) then
		MonkeySpeedFrame:StartMoving();
	end
	
	-- right button on the title or frame opens up the MonkeyBuddy, if it's there
	if (arg1 == "RightButton") then
		if (MonkeyBuddyFrame ~= nil) then
			ShowUIPanel(MonkeyBuddyFrame);
			
			-- make MonkeyBuddy show the MonkeySpeed config
			MonkeyBuddySpeedTab_OnClick();
		end
	end
end

function MonkeySpeed_OnMouseUp(arg1)
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (arg1 == "LeftButton") then
		MonkeySpeedFrame:StopMovingOrSizing();
	end
end

function MonkeySpeed_ParsePosition(position)
	local x, y, z;
	local iStart, iEnd;

	iStart, iEnd, x, y = string.find(position, "^(.-), (.-)$");

	if( x ) then
		return x + 0.0, y + 0.0;
	end
	return nil, nil;
end

function MonkeySpeed_Round(x)
	if(x - floor(x) > 0.5) then
		x = x + 0.5;
	end
	return floor(x);
end

function MonkeySpeed_TogglePercent()
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent) then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent = false;
		MonkeySpeedText:Hide();
	else
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent = true;
		MonkeySpeedText:Show();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeed_ToggleBar()
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar) then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar = false;
		MonkeySpeedBar:Hide();
	else
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar = true;
		MonkeySpeedBar:Show();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeed_ToggleDisplay()
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay) then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay = false;
		MonkeySpeedFrame:Hide();
	else
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay = true;
		MonkeySpeedFrame:Show();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeed_ToggleDebug()
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDebugMode = not MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDebugMode;
end

function MonkeySpeed_ToggleLock()
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked = not MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked;
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeedSlash_CmdShowPercent(bShow)
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (bShow == true) then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent = true;
		MonkeySpeedText:Show();
	else
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent = false;
		MonkeySpeedText:Hide();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeedSlash_CmdShowBar(bShow)
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (bShow == true) then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar = true;
		MonkeySpeedBar:Show();
	else
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar = false;
		MonkeySpeedBar:Hide();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeedSlash_CmdOpen(bOpen)
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	if (bOpen == true) then
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay = true;
		MonkeySpeedFrame:Show();
	else
		MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay = false;
		MonkeySpeedFrame:Hide();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeedSlash_CmdLock(bLock)
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked = bLock;
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end

function MonkeySpeedSlash_CmdReset()
	-- if not loaded yet then get out
	if (MonkeySpeed.m_bLoaded == false) then
		return;
	end
	
	StaticPopup_Show("MONKEYSPEED_RESET");
end

function MonkeySpeed_ResetConfig()
	-- set the defaults if the values weren't loaded by the SavedVariables.lua
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay = true;
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent = true;
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar = true;
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_fUpdateRate = 0.5;
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDebugMode = false;
	MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bLocked = false;
	
	-- show or hide the right options
	if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplay) then
		MonkeySpeedFrame:Show();
	else
		MonkeySpeedFrame:Hide();
	end
	
	if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayPercent) then
		MonkeySpeedText:Show();
	else
		MonkeySpeedText:Hide();
	end
	
	if (MonkeySpeedConfig[MonkeySpeed.m_strPlayer].m_bDisplayBar) then
		MonkeySpeedBar:Show();
	else
		MonkeySpeedBar:Hide();
	end
	
	-- check for MonkeyBuddy
	if (MonkeyBuddySpeedFrame_Refresh ~= nil) then
		MonkeyBuddySpeedFrame_Refresh();
	end
end
