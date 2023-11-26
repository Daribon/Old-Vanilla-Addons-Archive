--[[

	Clock: a simple in-game clock window
		copyright 2004 by Telo

	- Displays the time in a small, movable window
	- Displays time-based character information in a tooltip on mouseover

]]

-- Configuration variables
local MilitaryTime = 0;			-- set this to something other than nil to use 24-hour display
local OffsetHour = 0;			-- this is the hour offset applied to server time
local OffsetMinute = 0;			-- this is the minute offset applied to server time
local ShowSeconds = 0;			-- set this to 1 to enable timestamping of seconds
local HideExp = 0;				-- set this to 1 to hide xp


-- Constants
CLOCK_UPDATE_RATE = 0.1;
RUN_SPEED = 7;

local Clock_PopupOnMouseOver = true;

-- Local variables

local TotalTimePlayed = 0;
local LevelTimePlayed = 0;
local SessionTimePlayed = 0;
local ElapsedSinceLastPlayedMessage = 0;
local NeedPlayedMessage = 1;

local localInitialXP;
local localSessionXP = 0;
local localRolloverXP = 0;

local localHealthSecondTimer = 0;
local localInitialHealth;
local localHealthPerSecond;
local localManaSecondTimer = 0;
local localInitialMana;
local localManaPerSecond;

local localInCombat;
local localTravelTime = 0;
local localTravelDist = 0;

local localSpeed = 0;
local localSpeedDist = 0;
local localSpeedTime = 0;

-- added by max for seconds
local SecondCount = 0;
local LastMinute = 0;
local CurrentSecond = 0;
local InitialRun = 1;
local UpdateTime = 0; 

-- added by sarf for money
local Clock_ShowMoney = 0;
local localMoneyOld = nil;
local localMoneyIncreases = 0;


-- Local functions
local function Clock_ResetHealth()
	localHealthSecondTimer = 0;
	localInitialHealth = UnitHealth("player");
end

local function Clock_ResetMana()
	localManaSecondTimer = 0;
	localInitialMana = UnitMana("player");
end

-- Callback functions
function ToggleClock()
	if( ClockFrame:IsVisible() ) then
		HideUIPanel(ClockFrame);
	else
		ShowUIPanel(ClockFrame);
	end
end

function ResetClockPosition(setval, checked)
	ClockFrame:ClearAllPoints();
	ClockFrame:SetPoint("TOP", "UIParent", "TOP", 0, 0);
end

function ClockFormat(checked)
	MilitaryTime = checked;
end
function ClockHideExp(checked)
	HideExp = checked;
end

function ClockOffset(checked,value)
	local offset = value;
	if( OffsetHour > 0 ) then
		OffsetHour = math.floor(offset);
	else
		OffsetHour = math.ceil(offset);
	end
	OffsetMinute = (value - OffsetHour) * 60;
end

function ClockDisplay(toggle)
	if ( toggle == 1 ) then 
		ClockFrame:Show();
	else
		ClockFrame:Hide();
	end
end

-- added 2005-01-13 by arys
function ClockRoundTravelSpeed(checked)
	Clock_RoundTravelSpeed = checked;
end

function Clock_RegisterCosmosOptions()
	if ( Khaos ) then 
		local basicToggleStringMap = {
			["enable"] = {checked=true;};
			["disable"] = {checked=false;};
			["on"] = {checked=true};
			["off"] = {checked=false};
			["true"] = {checked=true};
			["false"] = {checked=false};
			default={checked="!"}; -- negate it
		};
		Khaos.registerOptionSet(
			"other",
			{
				id="Clock";
				text=CLOCK_OPTION_HEADER;
				helptext=CLOCK_OPTION_HEADER_INFO;
				difficulty=1;
				default=true;
				commands={
					{
						id="ClockCommands";
						commands={"/clock";"/clk"};
						parseTree={
							["enable"] = {
								[1] = {
									key="Enable";
									stringMap=basicToggleStringMap;
								}
							};
							["seconds"] = {
								[1] = {
									key="SecondsEnable";
									stringMap=basicToggleStringMap;
								}
							};
							["money"] = {
								[1] = {
									key="MoneyEnable";
									stringMap=basicToggleStringMap;
								}
							};
							["offset"] = {
								[1] = {
									key="TimeOffset";
									valueMap={
										slider="%1d";
									}
								};
							};
							["24"] = {
								[1] = {
									key="MilitaryTime";
									stringMap=basicToggleStringMap;
								}
							};
							["military"] = {
								[1] = {
									key="MilitaryTime";
									stringMap=basicToggleStringMap;
								}
							};
							["exp"] = {
								[1] = {
									key="HideExp";
									stringMap=basicToggleStringMap;
								}
							};
							["popup"] = {
								[1] = {
									key="PopupOnMouseOver";
									stringMap=basicToggleStringMap;
								}
							};
						};
					}
				};
				options={
					{
						id="Header";
						text=CLOCK_OPTION_HEADER;
						helptext=CLOCK_OPTION_HEADER_INFO;
						type=K_HEADER;
						difficulty=2;
					};
					{
						id="Enable";
						text=CLOCK_OPTION_ENABLE;
						helptext=CLOCK_OPTION_ENABLE_INFO;
						difficulty=1;
						type=K_TEXT;
						check=true;
						callback=function(state)
							if ( state.checked ) then 
								ClockDisplay(1);
							else
								ClockDisplay(0);
							end
						end;
						feedback=function(state)
							if ( state.checked ) then 
								return 'The clock is visible.';
							else
								return 'The clock is hidden.';
							end
						end;
						default={
							checked=true;
						};
						disabled={
							checked=false;
						};
					};
					{
						id="SecondsEnable";
						type=K_TEXT;
						check=true;
						text=CLOCK_OPTION_SECONDS;
						helptext=CLOCK_OPTION_SECONDS_INFO;
						difficulty=2;
						feedback=function(state)
							if ( state.checked ) then 
								return "Display the clock time with seconds.";
							else
								return "Display the time without seconds.";
							end
						end;
						callback=function(state)
							if ( state.checked ) then 
								Clock_DisplaySeconds(1);
							else
								Clock_DisplaySeconds(0);
							end
						end;
						default={checked=false};
						disabled={checked=false};
					};
					{
						id="MoneyEnable";
						type=K_TEXT;
						check=true;
						text=CLOCK_OPTION_MONEY;
						helptext=CLOCK_OPTION_MONEY_INFO;
						difficulty=2;
						feedback=function(state)
							if ( state.checked ) then 
								return "Will show money earned in the tooltip.";
							else
								return "Money will not be displayed.";
							end
						end;
						callback=function(state)
							if ( state.checked ) then 
								Clock_DisplayMoney(1);
							else
								Clock_DisplayMoney(0);
							end
						end;
						default={checked=false};
						disabled={checked=false};
					};
					{
						id="TimeOffset";
						type=K_SLIDER;
						text=CLOCK_OPTION_TIME_OFFSET;
						helptext=CLOCK_OPTION_TIME_OFFSET_INFO;
						difficulty=2;
						feedback=function(state)
							return "The time will be offset by "..state.slider.." hours.";
						end;
						callback=function(state)
							ClockOffset(nil, state.slider);
						end;
						default={checked=false;slider=0};
						disabled={checked=false;slider=0};
						setup={
							sliderMin=-12;
							sliderMax=12;
							sliderStep=.5;
							sliderText=CLOCK_OPTION_TIME_OFFSET_SLID_1;
							sliderDisplayFunc=function(val)return val..CLOCK_OPTION_TIME_OFFSET_SLID_2; end;
						};
					};
					{
						id="MilitaryTime";
						type=K_TEXT;
						check=true;
						text=CLOCK_OPTION_TWENTYFOUR_HOURS;
						helptext=CLOCK_OPTION_TWENTYFOUR_HOURS_INFO;
						difficulty=2;
						feedback=function(state)
							if ( state.checked ) then 
								return "Clock will range from 00:00-23:59.";
							else
								return "Clock will range from 12:00 AM -23:59 PM.";
							end
						end;
						callback=function(state)
							if ( state.checked ) then 
								ClockFormat(1);
							else
								ClockFormat(0);
							end
						end;
						default={checked=false};
						disabled={checked=false};
					};
					{
						id="HideExp";
						type=K_TEXT;
						check=true;
						text=CLOCK_OPTION_HIDE_EXP;
						helptext=CLOCK_OPTION_HIDE_EXP_INFO;
						difficulty=2;
						feedback=function(state)
							if ( state.checked ) then 
								return "Clock will display experience in the tooltip.";
							else
								return "Clock will not show experience in the tooltip.";
							end
						end;
						callback=function(state)
							if ( state.checked ) then 
								ClockHideExp(1);
							else
								ClockHideExp(0);
							end
						end;
						default={checked=false};
						disabled={checked=false};
					};
					{
						id="PopupOnMouseOver";
						type=K_TEXT;
						check=true;
						text=CLOCK_OPTION_POPUPONMOUSEOVER;
						helptext=CLOCK_OPTION_POPUPONMOUSEOVER_INFO;
						difficulty=2;
						feedback=function(state)
							if ( state.checked ) then 
								return "Tooltip will appear when the mouse moves over the clock.";
							else
								return "Tooltip will not appear when the mouse is over the clock.";
							end
						end;
						callback=function(state)
							if ( state.checked ) then 
								ClockPopupOnMouseOver(1);
							else
								ClockPopupOnMouseOver(0);
							end
						end;
						default={checked=true};
						disabled={checked=false};
					};
					{
						id="ResetPosition";
						type=K_BUTTON;
						text=CLOCK_OPTION_RESET_POSITION;
						helptext=CLOCK_OPTION_RESET_POSITION_INFO;
						difficulty=1;
						callback=ResetClockPosition;
						setup={
							buttonText=CLOCK_OPTION_RESET_POSITION_NAME;
						};
					};
					{
						id="ResetData";
						type=K_BUTTON;
						text=CLOCK_OPTION_RESET_DATA;
						helptext=CLOCK_OPTION_RESET_DATA_INFO;
						difficulty=2;
						callback=Clock_ResetData;
						setup={buttonText=CLOCK_OPTION_RESET_DATA_NAME};
					};

				};
			}
		);
	elseif( Cosmos_RegisterConfiguration ~= nil ) then
		Cosmos_RegisterConfiguration("COS_CLOCK",
			"SECTION",
			CLOCK_OPTION_HEADER,
			CLOCK_OPTION_HEADER_INFO
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_SECTION",
			"SEPARATOR",
			CLOCK_OPTION_HEADER,
			CLOCK_OPTION_HEADER_INFO
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_ENABLE",
			"CHECKBOX",
			CLOCK_OPTION_ENABLE, 
			CLOCK_OPTION_ENABLE_INFO,
			ClockDisplay,
			0,
			1
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_SECONDS_ENABLE",
			"CHECKBOX",
			CLOCK_OPTION_SECONDS,
			CLOCK_OPTION_SECONDS_INFO,
			Clock_DisplaySeconds,
			0,
			0
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_MONEY",
			"CHECKBOX",
			CLOCK_OPTION_MONEY,
			CLOCK_OPTION_MONEY_INFO,
			Clock_DisplayMoney,
			0,
			0
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_OFFSET",
			"SLIDER",
			CLOCK_OPTION_TIME_OFFSET,
			CLOCK_OPTION_TIME_OFFSET_INFO,
			ClockOffset,
			0,
			0,
			-12,
			12,
			CLOCK_OPTION_TIME_OFFSET_SLID_1,
			0.5,
			1,
			CLOCK_OPTION_TIME_OFFSET_SLID_2,
			1
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_TWENTYFOUR_HOURS",
			"CHECKBOX",
			CLOCK_OPTION_TWENTYFOUR_HOURS,
			CLOCK_OPTION_TWENTYFOUR_HOURS_INFO,
			ClockFormat,
			0,
			1
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_HIDE_EXP",
			"CHECKBOX",
			CLOCK_OPTION_HIDE_EXP,
			CLOCK_OPTION_HIDE_EXP_INFO,
			ClockHideExp,
			0,
			1
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_RESET_POSITION",
			"BUTTON",
			CLOCK_OPTION_RESET_POSITION,
			CLOCK_OPTION_RESET_POSITION_INFO,
			ResetClockPosition,
			0,
			0,
			0,
			0,
			CLOCK_OPTION_RESET_POSITION_NAME
		);
		Cosmos_RegisterConfiguration("COS_CLOCK_RESET_DATA",
			"BUTTON",
			CLOCK_OPTION_RESET_DATA,
			CLOCK_OPTION_RESET_DATA_INFO,
			Clock_ResetData,
			0,
			0,
			0,
			0,
			CLOCK_OPTION_RESET_DATA_NAME
		);
		Cosmos_RegisterConfiguration(
			"COS_CLOCK_POPUPONMOUSEOVER",
			"CHECKBOX",
			CLOCK_OPTION_POPUPONMOUSEOVER, 
			CLOCK_OPTION_POPUPONMOUSEOVER_INFO,
			ClockPopupOnMouseOver,
			1,
			1
		);
	end
end

-- OnFoo functions
function Clock_OnLoad()
	this:RegisterEvent("PLAYER_MONEY");
	this:RegisterEvent("TIME_PLAYED_MSG");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	
	ClockFrame.TimeSinceLastUpdate = 0;
	
	Clock_RegisterCosmosOptions();
	
	if (Eclipse) then
		--Register clock border
		Eclipse.registerForVisibility( {
			name = "ClockBorder";
			uiname = CLOCK_BORDER_OPTION_HEADER;
			slashcom = {"clockborder"};
		}	);
	end
	
	if ( Chronos ) then
		Chronos.afterInit(Clock_RetrieveCurrentMoneyOnStart);
	end
end

function Clock_OnUpdate(arg1)
	Clock_ShowSeconds_DoUpdate(arg1);
	SessionTimePlayed = SessionTimePlayed + arg1;
	ElapsedSinceLastPlayedMessage = ElapsedSinceLastPlayedMessage + arg1;
	localHealthSecondTimer = localHealthSecondTimer + arg1;
	localManaSecondTimer = localManaSecondTimer + arg1;
	
	if( localHealthSecondTimer >= 1 and localInitialHealth ) then
		if( UnitHealth("player") < UnitHealthMax("player") ) then
			local hps = UnitHealth("player") - localInitialHealth;
			if( hps > 0 ) then
				localHealthPerSecond = hps / localHealthSecondTimer;
			end
		end
		Clock_ResetHealth();
	end
	
	if( localManaSecondTimer >= 1 and localInitialMana ) then
		if( UnitMana("player") < UnitManaMax("player") ) then
			local mps = UnitMana("player") - localInitialMana;
			if( mps > 0 ) then
				localManaPerSecond = mps / localManaSecondTimer;
			end
		end
		Clock_ResetMana();
	end
	
	ClockFrame.TimeSinceLastUpdate = ClockFrame.TimeSinceLastUpdate + arg1;
	if( ClockFrame.TimeSinceLastUpdate > CLOCK_UPDATE_RATE ) then
		ClockText:SetText(Clock_GetTimeText());
		if ( EarthTooltip ) then 
			if( EarthTooltip:IsOwned(this) ) then
				Clock_SetTooltip();
			end
		end
		ClockFrame.TimeSinceLastUpdate = 0;
	end
	
end

function Clock_OnEvent()
	if( event == "PLAYER_MONEY" ) then
		Clock_UpdateMoney();
		return;
	end
	if( event == "TIME_PLAYED_MSG" ) then
		TotalTimePlayed = arg1;
		LevelTimePlayed = arg2;
		ElapsedSinceLastPlayedMessage = 0;
		NeedPlayedMessage = 0;
		
	-- Sync up all of the times to the session time; this makes
	-- the tooltip look nicer as everything changes all at once
	local fraction = SessionTimePlayed - floor(SessionTimePlayed);
		TotalTimePlayed = floor(TotalTimePlayed) + fraction;
		LevelTimePlayed = floor(LevelTimePlayed) + fraction;

		if( EarthTooltip:IsOwned(this) ) then
			Clock_SetTooltip();
		end
	elseif( event == "PLAYER_LEVEL_UP" ) then
		LevelTimePlayed = SessionTimePlayed - floor(SessionTimePlayed);
		localRolloverXP = localSessionXP;
		localInitialXP = 0;
		if( EarthTooltip:IsOwned(this) ) then
			Clock_SetTooltip();
		end
	elseif( event == "PLAYER_ENTERING_WORLD" ) then
		if( not localInitialXP ) then
			localInitialXP = UnitXP("player");
		end
		Clock_ResetHealth();
		Clock_ResetMana();
	elseif( event == "PLAYER_XP_UPDATE" ) then
		if( localInitialXP ) then
			localSessionXP = UnitXP("player") - localInitialXP + localRolloverXP;
		end
	elseif( event == "UNIT_HEALTH" ) then
		if( arg1 == "player" ) then
			if( not localInitialHealth or UnitHealth("player") - localInitialHealth < 0 ) then
				Clock_ResetHealth();
			end
		end
	elseif( event == "UNIT_MANA" ) then
		if( arg1 == "player" ) then
			if( not localInitialMana or UnitMana("player") - localInitialMana < 0 ) then
				Clock_ResetMana();
			end
		end
	elseif( event == "PLAYER_ENTER_COMBAT" ) then
		localInCombat = 1;
	elseif( event == "PLAYER_LEAVE_COMBAT" ) then
		localInCombat = nil;
	end
end

function ClockPopupOnMouseOver(toggle)
	if ( toggle == 1 ) then
		Clock_PopupOnMouseOver = true;
	else
		Clock_PopupOnMouseOver = false;
	end
	RegisterForSave("Clock_PopupOnMouseOver");
end

function ClockText_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function ClockText_OpenUpTooltip()
	if( NeedPlayedMessage == 1 ) then
		RequestTimePlayed();
	end
	EarthTooltip:SetOwner(ClockFrame, "ANCHOR_BOTTOMLEFT");
	Clock_SetTooltip();

	Clock_SetClockTooltipPoint();	
end

function ClockText_OnEnter()
	if ( Clock_PopupOnMouseOver ) then
		ClockText_OpenUpTooltip();
	end
end

function ClockText_OnLeave()
	if ( EarthTooltip:IsOwned(ClockFrame) ) then
		EarthTooltip:Hide();
	end
end

function ClockText_OnClick(button)
	if ( not Clock_PopupOnMouseOver ) then
		ClockText_OpenUpTooltip();
	end
end


function Clock_SetClockTooltipPoint()
 	-- Figured out the scale system.. it shows the scale between the object and the UIParent
	local x,y = ClockFrame:GetCenter();
	local screenWidth = UIParent:GetWidth();
	local screenHeight = UIParent:GetHeight();
	local scale = ClockFrame:GetScale();
	local setX = 0;
	if (x~=nil and y~=nil and screenWidth>0 and screenHeight>0) then
		x = x * scale;
		y = y * scale;
		local anchorPoint = "";
		local relativePoint = "";
		if (y <= (screenHeight * (1/2))) then
			anchorPoint = "BOTTOM";
			relativePoint = "TOP";
		else
			anchorPoint = "TOP";
			relativePoint = "BOTTOM";
		end
		if (x <= (screenWidth * (1/2))) then
			anchorPoint = anchorPoint.."LEFT";
			relativePoint = relativePoint.."LEFT";
			if ((ClockFrame:GetLeft() * scale) < 0) then
				setX = -(ClockFrame:GetLeft() * scale);
			end
		else
			anchorPoint = anchorPoint.."RIGHT";
			relativePoint = relativePoint.."RIGHT";
			if ((ClockFrame:GetRight() * scale) > screenWidth) then
				setX = screenWidth - (ClockFrame:GetRight() * scale);
			end
		end
		
		if (anchorPoint == "") then
			anchorPoint = "TOPLEFT";
		end
		
		if (relativePoint == "") then
			anchorPoint = "BOTTOMLEFT";
		end
		
		EarthTooltip:ClearAllPoints();
		EarthTooltip:SetPoint(anchorPoint, ClockFrame:GetName(), relativePoint, setX / EarthTooltip:GetScale(), 0);
		
		-- added 2005-01-13 by arys
		-- makes clock tooltip scale correctly
		EarthTooltip:SetScale(this:GetScale());
	end
end

-- Helper functions
function Clock_GetTimeText()
	local hour, minute = GetGameTime();
	local pm;

	hour = hour + OffsetHour;
	minute = minute + OffsetMinute;
	if( minute > 59 ) then
		minute = minute - 60;
		hour = hour + 1;
	elseif( minute < 0 ) then
		minute = 60 + minute;
		hour = hour - 1;
	end
	if( hour > 23 ) then
		hour = hour - 24;
	elseif( hour < 0 ) then
		hour = 24 + hour;
	end

	if( MilitaryTime == 1 ) then
		if( ( ShowSeconds == 1 ) ) then
			return date("%H:%M:%S", time() + (OffsetHour*60+OffsetMinute)*60 );
		else
			return format(TEXT(CLOCK_TIME_TWENTYFOURHOURS), hour, minute);
		end
	else
		if( hour >= 12 ) then
			pm = 1;
			hour = hour - 12;
		else
			pm = 0;
		end
		if( hour == 0 ) then
			hour = 12;
		end
		if( pm == 1 ) then
			if( ( ShowSeconds == 1 ) )  then
				return date("%I:%M:%S %p", time() + (OffsetHour*60+OffsetMinute)*60 );
			else
				return format(TEXT(TIME_TWELVEHOURPM), hour, minute);
			end
		else
			if( ( ShowSeconds == 1 ) ) then
				return date("%I:%M:%S %p", time() + (OffsetHour*60+OffsetMinute)*60 );
			else
				return format(TEXT(TIME_TWELVEHOURAM), hour, minute);
			end
		end
	end
end

local function Clock_FormatPart(fmt, val)
	local part;

	part = format(TEXT(fmt), val);
	if( val ~= 1 ) then
		part = part..TEXT(CLOCK_PART_PLURAL);
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

function Clock_SetTooltip()
	local total, level, session;
	local xpPerHourLevel, xpPerHourSession;
	local xpTotal, xpCurrent, xpToLevel;
	local text;

	total = format(TEXT(TIME_PLAYED_TOTAL), Clock_FormatTime(TotalTimePlayed + ElapsedSinceLastPlayedMessage));
	level = format(TEXT(TIME_PLAYED_LEVEL), Clock_FormatTime(LevelTimePlayed + ElapsedSinceLastPlayedMessage));
	session = format(TEXT(TIME_PLAYED_SESSION), Clock_FormatTime(SessionTimePlayed));

	if( NeedPlayedMessage == 1 ) then
		text = session;
	else
		text = total.."\n"..level.."\n"..session;
	end

	if(HideExp ~= 1) then
		if( (LevelTimePlayed + ElapsedSinceLastPlayedMessage > 0) or SessionTimePlayed > 0 ) then
			text = text.."\n";
		end
		if( LevelTimePlayed + ElapsedSinceLastPlayedMessage > 0 ) then
			xpPerHourLevel = UnitXP("player") / ((LevelTimePlayed + ElapsedSinceLastPlayedMessage) / 3600);
			text = text.."\n"..format(TEXT(EXP_PER_HOUR_LEVEL), xpPerHourLevel);
		else
			xpPerHourLevel = 0;
		end
		if( SessionTimePlayed > 0 ) then
			xpPerHourSession = localSessionXP / (SessionTimePlayed / 3600);
			text = text.."\n"..format(TEXT(EXP_PER_HOUR_SESSION), xpPerHourSession);
		else
			xpPerHourSession = 0;
		end

		xpTotal = UnitXPMax("player");
		xpCurrent = UnitXP("player");
		if( xpCurrent < xpTotal ) then
			xpToLevel = xpTotal - xpCurrent;
			text = text.."\n"..format(TEXT(EXP_TO_LEVEL), xpToLevel, (xpToLevel / xpTotal) * 100);
			if( xpPerHourLevel > 0 ) then
				text = text.."\n"..format(TEXT(TIME_TO_LEVEL_LEVEL), Clock_FormatTime((xpToLevel / xpPerHourLevel) * 3600));
			else
				text = text.."\n"..format(TEXT(TIME_TO_LEVEL_LEVEL), TEXT(TIME_INFINITE));
			end
			if( xpPerHourSession > 0 ) then
				text = text.."\n"..format(TEXT(TIME_TO_LEVEL_SESSION), Clock_FormatTime((xpToLevel / xpPerHourSession) * 3600));
			else
				text = text.."\n"..format(TEXT(TIME_TO_LEVEL_SESSION), TEXT(TIME_INFINITE));
			end
		end
	end

	if( localHealthPerSecond or localManaPerSecond ) then
		text = text.."\n";
	end
	if( localHealthPerSecond ) then
		text = text.."\n"..format(TEXT(HEALTH_PER_SECOND), localHealthPerSecond);
	end
	if( localManaPerSecond ) then
		text = text.."\n"..format(TEXT(MANA_PER_SECOND), localManaPerSecond);
	end
	
	if ( Clock_ShowMoney ) and ( Clock_ShowMoney == 1 ) then
		text = text.."\n\n"..Clock_GetMoneyGainAsString();
	end
	
	EarthTooltip:SetText(text);
end

-- added by popular demand by sarf
function Clock_ResetData()
	TotalTimePlayed = 0;
	LevelTimePlayed = 0;
	SessionTimePlayed = 0;
	ElapsedSinceLastPlayedMessage = 0;
	NeedPlayedMessage = 1;

	localInitialXP = UnitXP("player");
	localSessionXP = 0;
	localRolloverXP = 0;

	localHealthSecondTimer = 0;
	localInitialHealth = UnitHealth("player");
	localHealthPerSecond = nil;
	localManaSecondTimer = 0;
	localInitialMana = UnitMana("player");
	localManaPerSecond = nil;
	localMoneyIncreases = 0;

	localInCombat = nil;
	localSpeed = 0;
	localSpeedDist = 0;
	localSpeedTime = 0;
end


-- added as per Bhaeraus request by sarf

function Clock_DisplayMoney(toggle)
	if ( toggle == 1 ) then
		Clock_ShowMoney = 1;
	else
		Clock_ShowMoney = 0;
	end
end


function Clock_GetMoneyGainAsString()
	local formatStr = TEXT(CLOCK_MONEY);
	local valueStr = TEXT(CLOCK_MONEY_UNAVAILABLE);
	if ( localMoneyIncreases > 0 ) and ( SessionTimePlayed > 0 ) then
		local moneyFormat = TEXT(CLOCK_MONEY_PER_HOUR);
		local moneyGain = math.floor((localMoneyIncreases/SessionTimePlayed)*3600);
		if ( true ) then
			moneyFormat = TEXT(CLOCK_MONEY_PER_HOUR);
			moneyGain = math.floor((localMoneyIncreases/SessionTimePlayed)*3600);
		else
			moneyFormat = TEXT(CLOCK_MONEY_PER_MINUTE);
			moneyGain = math.floor((localMoneyIncreases/SessionTimePlayed)*60);
		end
		valueStr = format(moneyFormat, Clock_GetMoneyAsString(moneyGain));
	end
	return format(formatStr, valueStr);
end

function Clock_GetCurrencyString(currencyType)
	local name = "CLOCK_MONEY_";
	if ( currencyType == "gold" ) then
		name = name.."GOLD";
	end
	if ( currencyType == "silver" ) then
		name = name.."SILVER";
	end
	if ( currencyType == "copper" ) then
		name = name.."COPPER";
	end
	if ( not Clock_UseBigCurrencyDescriptions) or ( Clock_UseBigCurrencyDescriptions ~= 1 ) then
		name = name.."_SHORT";
	end
	return getglobal(name);
end

function Clock_GetMoneyAsString(amount)
	local gold = math.floor(amount / COPPER_PER_GOLD);
	amount = amount - gold * COPPER_PER_GOLD;
	local silver = math.floor(amount / COPPER_PER_SILVER);
	amount = amount - silver * COPPER_PER_SILVER;
	local copper = amount;
	local str = "";
	if ( gold > 0 ) then
		str = str..format(Clock_GetCurrencyString("gold"), gold);
		if ( silver > 0 ) or ( copper > 0 ) then
			str = str..TEXT(CLOCK_MONEY_SEPERATOR);
		end
	end
	if ( silver > 0 ) then
		str = str..format(Clock_GetCurrencyString("silver"), silver);
		if ( copper > 0 ) then
			str = str..TEXT(CLOCK_MONEY_SEPERATOR);
		end
	end
	if ( copper > 0 ) then
		str = str..format(Clock_GetCurrencyString("copper"), copper);
	end
	return str;
end

function Clock_RetrieveCurrentMoneyOnStart()
	if ( not Clock_UpdateMoney() ) then
		if ( Chronos ) then
			Chronos.scheduleByName("CLOCK_RETRIEVE_MONEY", 5, Clock_RetrieveCurrentMoneyOnStart);
		end
	end
end

function Clock_UpdateMoney()
	local currentMoney = GetMoney();
	if ( not currentMoney ) then
		return false;
	end
	if ( localMoneyOld ) then
		local diff = currentMoney-localMoneyOld;
		if ( diff > 0 ) then
			localMoneyIncreases = localMoneyIncreases + diff;
		end
	end
	localMoneyOld = currentMoney;
	if ( not localMoneyOld ) then
		return false;
	else
		return true;
	end
end


--- added 2005-01-13 by arys
function Clock_DisplaySeconds(toggle)
	if ( toggle == 1 ) then
		ShowSeconds = 1;
		InitialRun = 1;
	else
		ShowSeconds = 0;
	end
end
  

function Clock_ShowSeconds_DoUpdate(elapsed)
    local DoUpdate = 0;
    if ( ShowSeconds ) and ( ShowSeconds >= 1 ) then

		CurrentSecond = CurrentSecond + elapsed;
		if( InitialRun == 1 ) then
			local CurrentHour, CurrentMinute = GetGameTime();
			LastMinute = CurrentMinute;
			InitialRun = 2;
		end
	
		if( CurrentSecond >= 1 ) then
			CurrentSecond = CurrentSecond - 1;
			SecondCount = SecondCount + 1;
			
			if( SecondCount >= 60 ) then
				SecondCount = 0;
				DoUpdate = 1;
			end
			
			if ( DoUpdate == 1 ) then
				if ( not updateTime ) then 
					updateTime = 0;
				end
				-- fractions of seconds are lost every time the game lags,
				-- this should keep track of that.
				local CurrentTime = GetTime();
				local SecondOffset = ((CurrentTime - 60) - updateTime)/2;
				CurrentSecond = SecondOffset;
				updateTime = CurrentTime;
				DoUpdate = 0;
			end
			
			if( InitialRun == 2 ) then
				local CurrentHour, CurrentMinute = GetGameTime();
				if( CurrentMinute ~= LastMinute ) then
					updateTime = GetTime();
					SecondCount = 1;
					InitialRun = 0;
					LastMinute = CurrentMinute;
				end
			end
		end
	end
end
