--[[

Timer routines for flight timers.

Code inspired by Kwarz's flightpath.

]]

-- Preset some global variables
local EFM_Timer_StartRecording	= false;
local EFM_Timer_Recording		= false;
local myFlight					= {};
local EFM_Timer_TaxiDestination	= "";
local EFM_Timer_LastTime       	= time();
local EFM_Timer_TimeRemaining	= 0;
local EFM_Timer_TimeKnown		= false;
local EFM_Timer_FlightTime		= 0;

-- Function: Initialize the required structures and hook the required processes.
function EFM_Timer_Init()
	-- Hook the TakeTaxiNode function.
	-- This is done as there is no way (currently) to determine what node we are flying to while in flight.
	if(TakeTaxiNode ~= EFM_Timer_TakeTaxiNode) then
		Original_TakeTaxiNode = TakeTaxiNode;
		TakeTaxiNode = EFM_Timer_TakeTaxiNode;
	end

	-- Hook TaxiNodeOnButtonEnter function.
	-- We do this to be able to display the additional data for the blizzard-defined nodes as well as our nodes.
	if (TaxiNodeOnButtonEnter ~= EFM_FM_TaxiNodeOnButtonEnter) then
		EFM_OriginalTaxiNodeOnButtonEnter = TaxiNodeOnButtonEnter;
		TaxiNodeOnButtonEnter = EFM_FM_TaxiNodeOnButtonEnter;
	end

end

-- Function: Update
function EFM_Timer_EventFrame_OnUpdate()
	local ctime;
	EFM_Timer_CheckInFlightStatus();

	if (EFM_Config.Timer) then
		if (UnitOnTaxi("player")) then
			ctime = time();
			if(ctime ~= EFM_Timer_LastTime) then
				EFM_Timer_ShowInFlightTimer(ctime-EFM_Timer_LastTime);
				EFM_Timer_LastTime = ctime;
			end
		else
			EFM_Timer_HideTimers();
		end
	end
end

-- Function: Check the in flight status
function EFM_Timer_CheckInFlightStatus()

	-- Check the flight recording state.
	if (EFM_Timer_Recording and not UnitOnTaxi("player")) then
		-- End of the road, stop recording
		EFM_Timer_FlightPathEnd();
		EFM_Timer_Recording			= false;
		EFM_Timer_StartRecording	= false;
	end

	if (EFM_Timer_StartRecording) then
		if (UnitOnTaxi("player")) then
			EFM_Timer_StartRecording	= false;
			EFM_Timer_Recording			= true;
		end
	end

end

-- Function: Determine remote location from taxi node
function EFM_Timer_TakeTaxiNode(nodeID)
	EFM_TaxiDestination		= TaxiNodeName(nodeID);
	EFM_Timer_TimeRemaining = 0;
	EFM_Timer_StartTime		= time();
	EFM_Timer_LastTime		= EFM_Timer_StartTime;

	local myFaction		= UnitFactionGroup("player");
	local myContinent	= GetCurrentMapContinent();

	-- If there is a known flight time, calculate the duration estimate
	if (EFM_Timer_FlightDuration(EFM_TaxiOrigin, EFM_TaxiDestination) ~= nil) then
		local _,_,minutes,seconds = string.find(EFM_Timer_FlightDuration(EFM_TaxiOrigin, EFM_TaxiDestination),"(%d+):(%d+)");
		if(minutes and seconds) then
			EFM_Timer_TimeRemaining	= (minutes*60) + seconds;
			EFM_Timer_FlightTime	= EFM_Timer_TimeRemaining;
		end
		EFM_Timer_TimeKnown = true;
	else
		EFM_Timer_TimeKnown		= false;
		EFM_Timer_FlightTime	= 0;
	end

	EFM_Timer_StartRecording = true;

	Original_TakeTaxiNode(nodeID);
end

-- Function: end of flight path
function EFM_Timer_FlightPathEnd()
	EFM_Timer_TimeRemaining = 0;

	local myFaction		= UnitFactionGroup("player");
	local myContinent	= GetCurrentMapContinent();
	
	if (not EnhancedFlightMap_TaxiPathData[myFaction][myContinent][EFM_TaxiOrigin]) then
		EnhancedFlightMap_TaxiPathData[myFaction][myContinent][EFM_TaxiOrigin] = {};
	end
	
	if (not EnhancedFlightMap_TaxiPathData[myFaction][myContinent][EFM_TaxiOrigin][EFM_TaxiDestination]) then
		EnhancedFlightMap_TaxiPathData[myFaction][myContinent][EFM_TaxiOrigin][EFM_TaxiDestination] = {};
	end
	
	EnhancedFlightMap_TaxiPathData[myFaction][myContinent][EFM_TaxiOrigin][EFM_TaxiDestination].Duration = LYS_Elapsed(EFM_Timer_StartTime,time());
end

-- Function: In flight timer
function EFM_Timer_ShowInFlightTimer(secondsElapsed)

	local EFM_Timer_BarSize			= "small";  -- set to "large" for large bar display.

	if (EFM_TaxiDestination) then
		EFM_TimerFrame_Dest:SetText(EFM_FT_DESTINATION..EFM_TaxiDestination);
	else
		EFM_TimerFrame_Dest:SetText(EFM_FT_DESTINATION..UNKNOWN);
	end

	EFM_Timer_HideTimers();
	EFM_TimerFrame_Dest:Show();

	if(EFM_Timer_TimeRemaining > 0) then
		EFM_Timer_TimeRemaining = EFM_Timer_TimeRemaining - secondsElapsed;  -- Decrease in flight time remaining

		-- Display in flight time display thingy...
		if (not EFM_Config.ShowTimerBar) then
			-- Show text status
			EFM_TimerFrame_CountDown:SetText(EFM_FT_ARRIVAL_TIME..LYS_FormatTime(EFM_Timer_TimeRemaining));
			EFM_TimerFrame_CountDown:Show();
		else
			if (EFM_Config.ShowLargeBar) then
				-- Display status bar
				EFM_TimerFrame_StatusBar:SetMinMaxValues(0, EFM_Timer_FlightTime);
				EFM_TimerFrame_StatusBar:SetValue(EFM_Timer_TimeRemaining);
				EFM_TimerFrame_StatusBar:SetStatusBarColor(1.0, 0.7, 0.0);

				EFM_TimerFrame_StatusBar_Text:SetText(EFM_FT_ARRIVAL_TIME..LYS_FormatTime(EFM_Timer_TimeRemaining));

				-- Show the timer status bar
				EFM_TimerFrame_StatusBar:Show();
			
				-- Display the "spark" for the status bar
				local sparkPosition = (EFM_Timer_TimeRemaining / EFM_Timer_FlightTime) * 300;
				if ( sparkPosition < 0 ) then
					sparkPosition = 0;
				end
				EFM_TimerFrame_StatusBar_Spark:SetPoint("CENTER", "EFM_TimerFrame_StatusBar", "LEFT", sparkPosition, 0);
				EFM_TimerFrame_StatusBar_Spark:Show();
			else
				-- Display status bar
				EFM_TimerFrame_SmallStatusBar:SetMinMaxValues(0, EFM_Timer_FlightTime);
				EFM_TimerFrame_SmallStatusBar:SetValue(EFM_Timer_TimeRemaining);
				EFM_TimerFrame_SmallStatusBar:SetStatusBarColor(1.0, 0.7, 0.0);

				EFM_TimerFrame_SmallStatusBar_Text:SetText(EFM_FT_ARRIVAL_TIME..LYS_FormatTime(EFM_Timer_TimeRemaining));

				-- Show the timer status bar
				EFM_TimerFrame_SmallStatusBar:Show();
			
				-- Display the "spark" for the status bar
				local sparkPosition = (EFM_Timer_TimeRemaining / EFM_Timer_FlightTime) * 206;
				if ( sparkPosition < 0 ) then
					sparkPosition = 0;
				end
				EFM_TimerFrame_SmallStatusBar_Spark:SetPoint("CENTER", "EFM_TimerFrame_SmallStatusBar", "LEFT", sparkPosition, 0);
				EFM_TimerFrame_SmallStatusBar_Spark:Show();
			end
		end
	else
		if (not EFM_Timer_TimeKnown) then
			-- Display the flight timer screen if the time to destination is unknown as that way people will see it is online.
			EFM_TimerFrame_CountDown:SetText(EFM_FT_ARRIVAL_TIME..UNKNOWN);
			EFM_TimerFrame_CountDown:Show();
		else
			-- Display the flight timer as incorrect
			EFM_TimerFrame_CountDown:SetText(EFM_FT_INCORRECT);
			EFM_TimerFrame_CountDown:Show();
		end
	end
end

-- Function: Return the flight duration
function EFM_Timer_FlightDuration(orig, dest)
	local myFaction		= UnitFactionGroup("player");
	local myContinent	= GetCurrentMapContinent();

	if (EnhancedFlightMap_TaxiPathData[myFaction]) then
		if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent]) then
			if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig]) then
				if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest]) then
					return EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest].Duration;
				end
			end
		end
	end

	return nil;
end

-- Function: Update flight path cost
function EFM_Timer_FlightCostUpdate(orig, dest, cost)
	local myFaction		= UnitFactionGroup("player");
	local myContinent	= GetCurrentMapContinent();

	if (not EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig]) then
		EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig] = {};
	end

	if (not EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest]) then
		EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest] = {};
	end
	
	EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest].Cost = cost;
end

-- Function: Return the flight cost
function EFM_Timer_FlightCost(orig, dest)
	local myFaction		= UnitFactionGroup("player");
	local myContinent	= GetCurrentMapContinent();

	if (EnhancedFlightMap_TaxiPathData[myFaction]) then
		if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent]) then
			if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig]) then
				if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest]) then
					if (EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest].Cost) then
						return EnhancedFlightMap_TaxiPathData[myFaction][myContinent][orig][dest].Cost;
					end
				end
			end
		end
	end

	return 0;
end

-- Function: Return the flight time as a numerical value
function EFM_Timer_FlightLength(startNode, endNode)
	if (EFM_Timer_FlightDuration(startNode, endNode) ~= nil) then
		local _,_,minutes,seconds = string.find(EFM_Timer_FlightDuration(startNode, endNode),"(%d+):(%d+)");
		if(minutes and seconds) then
			totalTime = (minutes*60) + seconds;
		end
	
		return totalTime;
	else
		return 0;
	end
end

-- Function: Hide the flight timer(s)
function EFM_Timer_HideTimers()
	EFM_TimerFrame_Dest:Hide();
	EFM_TimerFrame_CountDown:Hide();
	EFM_TimerFrame_StatusBar:Hide();
	EFM_TimerFrame_StatusBar_Spark:Hide();
	EFM_TimerFrame_SmallStatusBar:Hide();
	EFM_TimerFrame_SmallStatusBar_Spark:Hide();
end
