--=============================================================================
-- File:		SunderThis.lua
-- Author:		© 2004, 2005 Miron
-- Description:	AddOn to show Sunder Armor effects on your target
--=============================================================================

--=============================================================================
-- Variables
local UNIT_TARGET = "target";

local EVENT_VARIABLES_LOADED = "VARIABLES_LOADED";
local EVENT_PLAYER_TARGET_CHANGED = "PLAYER_TARGET_CHANGED";
local EVENT_PLAYER_REGEN_DISABLED = "PLAYER_REGEN_DISABLED";
local EVENT_PLAYER_REGEN_ENABLED = "PLAYER_REGEN_ENABLED";

local sundAmnt = 0;
local sundTime = 0;
local sundDelta = 9999;

local SUNDER_THIS_SLASH_CMD = "/sunderthis";
local SUNDER_THIS_SLASH_CMD_INDEX = "SUNDERTHIS";

local SUNDER_ARMOR_DURATION = 30;
--=============================================================================

--=============================================================================
-- Called when Sunder This is loaded
function SunderThis_OnLoad()
	-- Register for events
	this:RegisterEvent( EVENT_VARIABLES_LOADED );
	this:RegisterEvent( EVENT_PLAYER_TARGET_CHANGED );
	this:RegisterEvent( EVENT_PLAYER_REGEN_DISABLED );
	this:RegisterEvent( EVENT_PLAYER_REGEN_ENABLED );
	this:RegisterForDrag( "LeftButton" );

	-- Setup /sunderthis
	SLASH_SUNDERTHIS1 = SUNDER_THIS_SLASH_CMD;
	SlashCmdList[SUNDER_THIS_SLASH_CMD_INDEX] = function( msg )
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
	elseif event == EVENT_PLAYER_REGEN_ENABLED or ( event == EVENT_PLAYER_TARGET_CHANGED and UnitName( UNIT_TARGET ) == nil ) then
		SunderThis:Hide();
	elseif event == EVENT_PLAYER_REGEN_DISABLED or ( event == EVENT_PLAYER_TARGET_CHANGED and UnitName( UNIT_TARGET ) ~= nil ) then
		SunderThis:Show();
	end
end

-- Update function, called continuously
function SunderThis_OnUpdate()
	local r, _, _, sund = UnitDebuffInformation( UNIT_TARGET, SUNDER_ARMOR, SUNDER_ARMOR_DESC, "Interface\\Icons\\Ability_Warrior_Sunder" );
	local form = "";

	if r and sund then
		sund = sund + 0;

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
	if SunderThisState and SunderThisState.locked == 0 then
		SunderThis:StartMoving();
	end
end

-- On Drag Stop event
function SunderThis_OnDragStop()
	if SunderThisState and SunderThisState.locked == 0 then
		SunderThis:StopMovingOrSizing();
	end
end
--=============================================================================