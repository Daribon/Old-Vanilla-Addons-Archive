--=============================================================================
-- File:		SunderThis.lua
-- Author:		© 2004, 2005 Miron
-- Description:	AddOn to show Sunder Armor effects on your target
--=============================================================================

--=============================================================================
-- Variables
local UNIT_TARGET = "target";

local EVENT_VARIABLES_LOADED = "VARIABLES_LOADED";
local EVENT_CHARACTER_POINTS_CHANGED = "CHARACTER_POINTS_CHANGED";

local sundAmnt = 0;
local sundTime = 0;
local sundDelta = 9999;
local impSundRank = -1;

local SUNDER_ARMOR = "Sunder Armor";
local SUNDER_ARMOR_DESC = "Armor decreased by (%d+)\.$";
local SUNDER_ARMOR_DURATION = 30;
local IMPROVED_SUNDER = .1;
local IMPROVED_SUNDER_TREE = 3;
local IMPROVED_SUNDER_INDEX = 10;

local SUNDER_THIS_DEF_FORMAT = "~n";
local SUNDER_THIS_S = "~s";
local SUNDER_THIS_N = "~n";
local SUNDER_THIS_T = "~t";

local SUNDER_THIS_RESET_MSG = "SunderThis reset.";
local SUNDER_THIS_USAGE_MSG = "Usage: /sunderthis [reset||lock||format <format string>||help]";
local SUNDER_THIS_LOCKED_MSG = "SunderThis locked.";
local SUNDER_THIS_UNLOCKED_MSG = "SunderThis unlocked.";
local SUNDER_THIS_FORMAT_MSG = "SunderThis format set: ";

local SUNDER_THIS_HELP_MSG_TEXT0 = "SunderThis Help:";
local SUNDER_THIS_HELP_MSG_TEXT1 = SUNDER_THIS_USAGE_MSG;
local SUNDER_THIS_HELP_MSG_TEXT2 = "reset: Reset SunderThis' position to the top left of the target frame.";
local SUNDER_THIS_HELP_MSG_TEXT3 = "lock: Toggle the ability to drag SunderThis.";
local SUNDER_THIS_HELP_MSG_TEXT4 = "format <format string>: Set SunderThis' display format. Multiple options and other text can be used at once in the format. The default format is \"" .. SUNDER_THIS_DEF_FORMAT .. "\"";
local SUNDER_THIS_HELP_MSG_TEXT5 = "  ~s: Display the amount of armor sundered.";
local SUNDER_THIS_HELP_MSG_TEXT6 = "  ~n: Display the number of Sunder Armors applied.";
local SUNDER_THIS_HELP_MSG_TEXT7 = "  ~t: Display the |cff00ff00approximate|r time remaining.";
local SUNDER_THIS_HELP_MSG_TEXT8 = "help: Display this message";
local SUNDER_THIS_HELP_MSG = {
	SUNDER_THIS_HELP_MSG_TEXT0,
	SUNDER_THIS_HELP_MSG_TEXT1,
	SUNDER_THIS_HELP_MSG_TEXT2,
	SUNDER_THIS_HELP_MSG_TEXT3,
	SUNDER_THIS_HELP_MSG_TEXT4,
	SUNDER_THIS_HELP_MSG_TEXT5,
	SUNDER_THIS_HELP_MSG_TEXT6,
	SUNDER_THIS_HELP_MSG_TEXT7,
	SUNDER_THIS_HELP_MSG_TEXT8,
};

local SUNDER_THIS_RESET = "reset";
local SUNDER_THIS_LOCK = "lock";
local SUNDER_THIS_FORMAT = "format";
local SUNDER_THIS_HELP = "help";
--=============================================================================

--=============================================================================
local function UpdateImprovedSunderArmor()
	local _, texture, _, _, rank, _, _, _ = GetTalentInfo( IMPROVED_SUNDER_TREE, IMPROVED_SUNDER_INDEX );

	if texture then
		impSundRank = rank;
	end
end
--=============================================================================

--=============================================================================
-- Called when Sunder This is loaded
function SunderThis_OnLoad()
	-- Register for events
	this:RegisterEvent( EVENT_VARIABLES_LOADED );
	this:RegisterEvent( EVENT_CHARACTER_POINTS_CHANGED );
	this:RegisterForDrag( "LeftButton" );

	-- Setup /sunderthis
	SLASH_SUNDERTHIS1 = "/sunderthis";
	SlashCmdList["SUNDERTHIS"] = function( msg )
		SunderThis_SlashCommandHandler( msg );
	end
end

-- Take an event and check target to see if they are sundered.
--
-- event	event name
function SunderThis_OnEvent( event )
	if event == EVENT_VARIABLES_LOADED then
		if not SunderThisState then
			SunderThisState = {};
			SunderThisState.locked = 0;
			SunderThisState.format = SUNDER_THIS_DEF_FORMAT;
		end

		if not SunderThisState.locked then
			SunderThisState.locked = 0;
		end

		if not SunderThisState.format then
			SunderThisState.format = SUNDER_THIS_DEF_FORMAT;
		end
	elseif impSundRank == -1 then
		UpdateImprovedSunderArmor();
	end
end

-- Update function, called continuously
function SunderThis_OnUpdate()
	local r, _, _, sund = UnitDebuffInformation( UNIT_TARGET, SUNDER_ARMOR, SUNDER_ARMOR_DESC );
	local form = "";
	
	if r and sund then
		sund = sund * ( 1 + IMPROVED_SUNDER * impSundRank );

		if sund ~= sundAmnt then
			sundAmnt = sund;
			sundTime = GetTime();

			if sund < sundDelta then
				sundDelta = sund;
			end
		end

		form = string.gsub( SunderThisState.format, SUNDER_THIS_S, sund );
		form = string.gsub( form, SUNDER_THIS_N, sund / sundDelta );
		form = string.gsub( form, SUNDER_THIS_T, math.floor( SUNDER_ARMOR_DURATION - ( GetTime() - sundTime ) ) );

		SunderThisText:SetText( form );
	elseif sundAmnt ~= 0 then
		SunderThisText:SetText( "" );
		sundAmnt = 0;
		sundTime = 0;
	elseif impSundRank == -1 then
		UpdateImprovedSunderArmor();
	end
end

-- Slash command execution
--
-- msg		parameters passed to the command
function SunderThis_SlashCommandHandler( msg )
	local arg;

	if msg then
		_, _, msg, _, arg = string.find( string.lower( msg ), "(%w+)(%s*)(.*)" );

		if msg == SUNDER_THIS_RESET then
			SunderThis:ClearAllPoints();
			SunderThis:SetPoint("TOPLEFT", "TargetFrame" ); --, "BOTTOMLEFT", 0, 0);
			DEFAULT_CHAT_FRAME:AddMessage( SUNDER_THIS_RESET_MSG );
		elseif msg == SUNDER_THIS_LOCK then
			if SunderThisState.locked == 1 then
				SunderThisState.locked = 0;
				DEFAULT_CHAT_FRAME:AddMessage( SUNDER_THIS_UNLOCKED_MSG );
			else
				SunderThisState.locked = 1;
				SunderThis:StopMovingOrSizing();
				DEFAULT_CHAT_FRAME:AddMessage( SUNDER_THIS_LOCKED_MSG );
			end
		elseif msg == SUNDER_THIS_FORMAT then
			SunderThisState.format = arg;
			DEFAULT_CHAT_FRAME:AddMessage( SUNDER_THIS_FORMAT_MSG .. arg );
		elseif msg == SUNDER_THIS_HELP then
			for i,v in SUNDER_THIS_HELP_MSG do
				DEFAULT_CHAT_FRAME:AddMessage( v );
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage( SUNDER_THIS_USAGE_MSG );
		end
	end
end

-- On Drag Start event
function SunderThis_OnDragStart()
	if SunderThisState and not SunderThisState.locked then
		SunderThis:StartMoving();
	end
end

-- On Drag Stop event
function SunderThis_OnDragStop()
	if SunderThisState and not SunderThisState.locked then
		SunderThis:StopMovingOrSizing();
	end
end
--=============================================================================