--TODO
	-- convert to Ace.
	-- options menu
	-- add option to change casting, failed/interupted, channeling, and success bar color.
	-- add an icon to the left for the spell (also fairly advanced feature - i think i can do it)
	-- 	they both need the spell id, figure out a way to catch this at casting start - would help a bunch for icon

-- Global constants
CASTING_BAR_MAJOR_VERSION = "1";
CASTING_BAR_MINOR_VERSION = "2";
CASTING_BAR_ALPHA_STEP = 0.05;
CASTING_BAR_FLASH_STEP = 0.2;
CASTING_BAR_HOLD_TIME = 1;

-- Global variables
eCastingBar_Saved = {};

-- Local Constants
local CASTING_BAR_DEFAULT_TEXTURE = "Interface\\TargetingFrame\\UI-StatusBar";
local CASTING_BAR_PERL_TEXTURE = "Interface\\AddOns\\eCastingBar\\Textures\\StatusBar.tga";

-- local variables
local eCastingBar_Player = nil;
local eCastingBar_Defaults = {

	intLocked = 1,
	intEnabled = 1,
	intTexture = 1
	
}

local eCastingBar__FlashBorders = {
	"TOPLEFT",
	"TOP",
	"TOPRIGHT",
	"LEFT",
	"RIGHT",
	"BOTTOMLEFT",
	"BOTTOM",
	"BOTTOMRIGHT"	
}

local eCastingBar__Events = {
	"SPELLCAST_START",
	"SPELLCAST_STOP",
	"SPELLCAST_INTERRUPTED",
	"SPELLCAST_FAILED",
	"SPELLCAST_DELAYED",
	"SPELLCAST_CHANNEL_START",
	"SPELLCAST_CHANNEL_UPDATE"
}


local eCastingBar__CastTimeEvents = {
	"SPELLCAST_START",
	"SPELLCAST_STOP",
	"SPELLCAST_INTERRUPTED",
	"SPELLCAST_FAILED"
}

--[[ onFoo stuff ]]--
function eCastingBar_OnLoad()

	-- load the new castingbar:
	eCastingBar:RegisterEvent("PLAYER_ENTERING_WORLD");
	eCastingBar:RegisterEvent("VARIABLES_LOADED");
	
end



--[[ sets up the flash to look cool ]]--
--	(thanks goes to kaitlin for the code used while resting). 
function eCastingBar_SetFlashBorderColors( intRed, intGreen, intBlue )

	local frmFrame = "eCastingBarFlash";
	local intIndex = 0;
	local strBorder = "";
	
	-- for each border in eCastingBar__FlashBorders set the color to gold.
	for intIndex, strBorder in eCastingBar__FlashBorders do
	
		getglobal( frmFrame.."_"..strBorder ):SetVertexColor( intRed, intGreen, intBlue );
		
	end
	
end

--[[ Registers "frame" (passed as a string) to spellcast events. ]]--
function eCastingBar_Register( frmFrame, strEvent )

	-- register event.
	getglobal( frmFrame ):RegisterEvent( strEvent );	

end

--[[ Unregisters "frame" (passed as a string) from spellcast events. ]]--
function eCastingBar_Unregister( frmFrame, strEvent )

	-- ungregister event.
	getglobal( frmFrame ):UnregisterEvent( strEvent );	

end

--[[ Handles all the mods' events. ]]--
function eCastingBar_OnEvent( )

	if event == "PLAYER_ENTERING_WORLD" then
	
		-- inform the user we are starting loading .
	--	DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_LOADED );

		eCastingBar:UnregisterEvent( event );
		
		eCastingBar_Player = UnitName( "player" ).. " - " ..GetRealmName( );

		--is the save empty or broken?
		if not eCastingBar_Saved[eCastingBar_Player]  or eCastingBar_Saved[eCastingBar_Player] == 1 then

			--yes, inform the user we are loaing defaults
			DEFAULT_CHAT_FRAME:AddMessage( "	First Load or broken save, Loading defaults." );
			
			--set it to defaults
			eCastingBar_Saved[eCastingBar_Player] = {
				["Locked"] = eCastingBar_Defaults["intLocked"];
				["Enabled"] = eCastingBar_Defaults["intEnabled"];
				["UsePerlTexture"] = eCastingBar_Defaults["intTexture"];
			}
			
		end
		
		eCastingBar_LoadVariables( );

	end

    --if( event == "VARIABLES_LOADED" ) then
	
		-- load the variables

	--end
	
	if( event == "SPELLCAST_START" ) then

		-- arg1 = Spell Name
		-- arg2 = Duration (in milliseconds)
		eCastingBar_SpellcastStart( arg1, arg2 );
		
	elseif( event == "SPELLCAST_STOP" ) then
	
		eCastingBar_SpellcastStop( );
		
	elseif( event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" ) then
	
		eCastingBar_SpellcastFailed( );

	elseif( event == "SPELLCAST_DELAYED" ) then
	
		-- arg1 = Disruption Time(in milliseconds)
		eCastingBar_SpellcastDelayed( arg1 );

	elseif( event == "SPELLCAST_CHANNEL_START" ) then

		-- arg1 = Duration (in milliseconds)
		-- arg2 = Spell Name
		eCastingBar_SpellcastChannelStart( arg1, arg2 );
		
	elseif( event == "SPELLCAST_CHANNEL_UPDATE" ) then
	
		-- arg1 = Remaining Duration (in milliseconds)
		eCastingBar_SpellcastChannelUpdate( arg1 );

	end
end

--[[ Iniitialization ]]--
function eCastingBar_LoadVariables( )	
		-- set the loaded variables
		
		eCastingBar_EnableToggle( eCastingBar_GetEnabled( ) );
		eCastingBar_LockToggle( eCastingBar_GetLocked( ) );
		eCastingBar_TextureToggle( eCastingBar_GetTexture( ) );
		
		-- setup the flash
		eCastingBar_SetFlashBorderColors( 1.0, 0.88, 0.25 );
		
		-- make the casting bar link to the movable button
		eCastingBar:SetPoint("TOPLEFT", "eCastingBarDragButton", "TOPLEFT", 15, 0 );

		-- reset the frame lvl so it doesn't get too high and lag the ui
		eCastingBar:SetFrameLevel( eCastingBar:GetFrameLevel( ) - 1 );
		
		-- reset variables
		eCastingBar.casting = nil;
		eCastingBar.holdTime = 0;
		
			-- code used if no cosmos is present

		-- make the slash commands
		SlashCmdList["ECASTINGBAR"] = eCastingBar_SlashHandler;
		SLASH_ECASTINGBAR1 = "/eCastingBar";
		SLASH_ECASTINGBAR2 = "/eCB";
	
		-- status
		--eCastingBar_DisplayStatus( );

end


--[[ Displays the status. ]]--
function eCastingBar_DisplayStatus( )

	DEFAULT_CHAT_FRAME:AddMessage( "	Enabled: "..eCastingBar_GetEnabled( ) );
	DEFAULT_CHAT_FRAME:AddMessage( "	Locked: "..eCastingBar_GetLocked( ) );
	DEFAULT_CHAT_FRAME:AddMessage( "	PerlTexture: "..eCastingBar_GetTexture( ) );

end

--[[ Handles all the slash commands if cosmos isn't present. ]]--
function eCastingBar_SlashHandler( strMessage )

	-- make it it all lower case to be sure
	strMessage = string.lower( strMessage );
			
	-- did they type: unlock?
	if( string.find( strMessage, CASTINGBAR_CHAT_C1 ) ) then 
	
		-- yes, unlock the frame.
		eCastingBar_Unlock( );
		
		-- imform the user
		DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_HEADER..": Unlocked." );
		
	-- no, did they type: lock?
	elseif( string.find( strMessage, CASTINGBAR_CHAT_C2 ) ) then 

		-- yes, lock the frame.
		eCastingBar_Lock( );
		
		-- imform the user
		DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_HEADER..": Locked." );
		
	-- no, did they type: disabled?
	elseif( string.find( strMessage, CASTINGBAR_CHAT_C3 ) ) then 

		-- yes, disable the mod.
		eCastingBar_Disable( );
		
		-- imform the user
		DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_HEADER..": Disabled." );

	-- no, did they type: enable?
	elseif( string.find( strMessage, CASTINGBAR_CHAT_C4 ) ) then 

		-- yes, enable the mod.
		eCastingBar_Enable( );
		
		-- imform the user
		DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_HEADER..": Enabled." );
		
	-- no, did they type: toggletexture?
	elseif( string.find( strMessage, CASTINGBAR_CHAT_C5 ) ) then 
		
		-- imform the user
		if( eCastingBar_GetTexture( ) == 1 ) then
		
			DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_HEADER..": Using default texture." );
			eCastingBar_SetTexture( 0 );
			
		else
		
			DEFAULT_CHAT_FRAME:AddMessage( CASTINGBAR_HEADER..": Using Perl texture." );
			eCastingBar_SetTexture( 1 );

		end
		
		-- yes,toggle the perl texture.
		eCastingBar_TextureToggle( eCastingBar_GetTexture( ) );
	
	-- no: do default
	else
	
		-- call for help
		eCastingBar_ChatHelp( );
		
	end		
	
end

--[[ Handles chat help messages. ]]--
function eCastingBar_ChatHelp( )

	local intIndex = 0;
	local strMessage = "";
	
	-- prints each line in CASTINGBAR_HELP = { }
	for intIndex, strMessage in CASTINGBAR_HELP do
	
		DEFAULT_CHAT_FRAME:AddMessage( strMessage );
		
	end
	
end

--[[ Handles the SPELLCAST_START event. ]]--
function eCastingBar_SpellcastStart( strSpellName, intDuration )

	-- set the bar color (to yellow for now, but will have an option later to change this)
	eCastingBarStatusBar:SetStatusBarColor( 1.0, 0.7, 0.0 );
	
	-- show the spark
	eCastingBarSpark:Show( );
	
	-- set the start and max time
	eCastingBar.startTime = GetTime( );
	eCastingBar.maxValue = eCastingBar.startTime + ( intDuration / 1000 );
	
	-- set the bar minium and maxium accordingly (basicly it will grow as time passes)
	eCastingBarStatusBar:SetMinMaxValues( eCastingBar.startTime, eCastingBar.maxValue );
	
	-- set the bar to empty
	eCastingBarStatusBar:SetValue( eCastingBar.startTime );
	
	-- set the text to the spell name
	eCastingBarText:SetText( strSpellName );
	
	-- set the bar to fully opaque
	eCastingBar:SetAlpha( 1.0 );
	
	-- start the casting state, and make sure everything else is reset
	eCastingBar.holdTime = 0;
	eCastingBar.casting = 1;
	eCastingBar.fadeOut = nil;
	eCastingBar:Show( );
	eCastingBar.mode = "casting";

end

--[[ Handles the SPELLCAST_STOP event. ]]--
function eCastingBar_SpellcastStop( )

	-- NOTE: not sure why but certain things in here keep getting called everytime channeling updates
	--	first the green bar colored used for success, forced channeling green also (no matter what i did)
	-- so don't put anything in here that will fuck w/ channeling, unless you use if( eCastingBar.channeling == nil)

		-- test

	
	-- make sure we aren't channeling first
	if( eCastingBar.channeling == nil ) then
	
		-- set the bar color (to green for now, but will have an option later to change this)
		eCastingBarStatusBar:SetStatusBarColor( 0, 1, 0 );
		eCastingBarSpark:Hide( );
		
	end
		
	-- is the bar still visiable?
	if ( not eCastingBar:IsVisible( ) ) then
	
		-- yes, we are done casting, so hide it
		eCastingBar:Hide( );
		
	end
	
	-- is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	if ( eCastingBar:IsShown( ) ) then
	
		-- set the bar to max value (visually helps the user see)
		eCastingBarStatusBar:SetValue( eCastingBar.maxValue );
		
		-- start the flash state
		eCastingBarFlash:SetAlpha( 0.0 );
		eCastingBarFlash:Show( );
		eCastingBar.casting = nil;
		eCastingBar.flash = 1;
		eCastingBar.fadeOut = 1;
		eCastingBar.mode = "flash";
		
	end

end

--[[ Handles the SPELLCAST_FAILED and SPELLCAST_INTERRUPTED events. ]]--
function eCastingBar_SpellcastFailed( )

	-- is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	if ( eCastingBar:IsShown( ) ) then
	
		-- set the bar to max (visually helps the user see)
		eCastingBarStatusBar:SetValue( eCastingBar.maxValue );
		
		-- set the bar color (to red for now, but will have an option later to change this)
		eCastingBarStatusBar:SetStatusBarColor( 1.0, 0.0, 0.0 );
		
		-- hide the spark, we dont need it anymore
		eCastingBarSpark:Hide( );
		
		-- was the called event: spell failed?
		if ( event == "SPELLCAST_FAILED" ) then
		
			-- yes, set the text accordingly
			eCastingBarText:SetText( FAILED );
			
		else
		
			-- no, it must have been interupted instead, set the text accordingly
			eCastingBarText:SetText( INTERRUPTED );
			
		end
		
		-- end the casting state, start the fadeout state
		eCastingBar.casting = nil;
		eCastingBar.fadeOut = 1;
		eCastingBar.holdTime = GetTime() + CASTING_BAR_HOLD_TIME;
		
	end

end

--[[ Handles the SPELLCAST_DELAYED event. ]]--
function eCastingBar_SpellcastDelayed( intDisruptionTime )

	-- is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	if( eCastingBar:IsShown( ) ) then
	
		-- set the start and max time according to how much it was disrupted
		eCastingBar.startTime = eCastingBar.startTime + ( intDisruptionTime / 1000 );
		eCastingBar.maxValue = eCastingBar.maxValue + ( intDisruptionTime / 1000 );
		
		-- set the bar accordingly (basicly stricking it according to how much it was disrupted)
		eCastingBarStatusBar:SetMinMaxValues( eCastingBar.startTime, eCastingBar.maxValue );
		
	end

end

--[[ Handles the SPELLCAST_CHANNEL_START event. ]]--
function eCastingBar_SpellcastChannelStart( intDuration, strSpellName )

	--set the bar color (to blue for now, will make an option for this later)
	eCastingBarStatusBar:SetStatusBarColor( 0.3, 0.3, 1.0 );
	
	-- show the spark
	eCastingBarSpark:Show( );
	
	-- set the bar to max
	eCastingBar.maxValue = 1;
	
	-- set the start and end times
	eCastingBar.startTime = GetTime( );
	eCastingBar.endTime = eCastingBar.startTime + ( intDuration / 1000 );
	
	-- set the bar minium and maxium values
	eCastingBarStatusBar:SetMinMaxValues( eCastingBar.startTime, eCastingBar.endTime );
	
	-- set the bar length visually to reflex the new time
	eCastingBarStatusBar:SetValue( eCastingBar.endTime );
	
	-- set the text to the spell name
	eCastingBarText:SetText( strSpellName );
	
	-- set the bar to fully opaque
	eCastingBar:SetAlpha( 1.0 );
	
	-- reset various valuses used to hide the bar, also make sure its channeling not casting
	eCastingBar.holdTime = 0;
	eCastingBar.casting = nil;
	eCastingBar.channeling = 1;
	eCastingBar.fadeOut = nil;
	eCastingBar:Show( );
	eCastingBar.mode = "channeling";

end

--[[ Handles the SPELLCAST_CHANNEL_UPDATE event. ]]--
function eCastingBar_SpellcastChannelUpdate( intRemainingDuration )

	-- is the remaining time zero?
	if( intRemainingDuration == 0 ) then
	
			-- yes, we aren't channeling anymore
			eCastingBar.channeling = nil;
		
	-- no, is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	elseif( eCastingBar:IsShown( ) ) then
			
		-- set the original duration
		local intOriginalDuration = eCastingBar.endTime - eCastingBar.startTime;
		
		-- set the start and end time
		eCastingBar.endTime = GetTime( ) + ( intRemainingDuration / 1000 );
		eCastingBar.startTime = eCastingBar.endTime - intOriginalDuration;
		
		-- set the bar length reflect the new state (basicly decreases the start time as time passes, thus shrinking the bar)
		eCastingBarStatusBar:SetMinMaxValues( eCastingBar.startTime, eCastingBar.endTime ); 
		
		-- test to see visually when it fires... and it doesn't fire much.
		--DEFAULT_CHAT_FRAME:AddMessage( "SPELLCAST_CHANNELING_UPDATE" );
		
	end

end

--[[ Handles all updates. ]]--
function eCastingBar_OnUpdate( )

	-- are we casting?
	if( eCastingBar.casting ) then
		
		-- yes:
		local intCurrentTime = GetTime();
		local intSparkPosition = 0;
		
		-- update the casting time
		--eCastingBar_Time:SetText( string.sub( math.max( eCastingBar.maxValue - intCurrentTime, 0.00 ), 1,4 ) );
		
		-- Thanks to wbb at Cursed for the lovely formating
		eCastingBar_Time:SetText( string.format( "%.1f", math.max( eCastingBar.maxValue - intCurrentTime, 0.0 ) ) );
		
		-- is the status > than the max?
		if( intCurrentTime > eCastingBar.maxValue ) then
		
			-- yes, set it to max (not sure how it would get that way, but again blizzard is safe)
			intCurrentTime = eCastingBar.maxValue;
			
		end
		
		-- update the bar length
		eCastingBarStatusBar:SetValue( intCurrentTime );
		
		--reset the flash to hidden
		 eCastingBarFlash:Hide( );
		
		-- updates the spark
		intSparkPosition = ( ( intCurrentTime - eCastingBar.startTime ) / ( eCastingBar.maxValue - eCastingBar.startTime ) ) * 195;
		if( intSparkPosition < 0 ) then
		
			intSparkPosition = 0;
			
		end
		
		-- set the spark to the end of the current barsize
		eCastingBarSpark:SetPoint( "CENTER", "eCastingBarStatusBar", "LEFT", intSparkPosition, 0 );
		
	-- no, are we channeling?	
	elseif ( eCastingBar.channeling ) then
	
		-- yes:
		local intTimeLeft = GetTime( );
		local intBarValue = 0;
		local intSparkPosition = eCastingBar.endTime;
		
		-- update the channeling time
		--eCastingBar_Time:SetText( string.sub( math.max( eCastingBar.endTime - intTimeLeft, 0.00 ), 1 , 4 ) );
		
		-- Thanks to wbb at Cursed for the lovely formating
		eCastingBar_Time:SetText( string.format( "%.1f", math.max( eCastingBar.endTime - intTimeLeft, 0.0 ) ) );
		
		-- is the time left greater than channeling end time?
		if( intTimeLeft > eCastingBar.endTime ) then
		
			-- yes, set it to the channeling end time (this will happen if you get delayed longer than the time left on channeling)
			intTimeLeft = eCastingBar.endTime;
			
		end
		
		-- are the times equal?
		if( intTimeLeft == eCastingBar.endTime ) then
		
			-- yes, we finished channeling, so start the fadeout process and exit
			eCastingBar.channeling = nil;
			eCastingBar.fadeOut = 1;
			return;
			
		end
		
		-- update the bar length
		intBarValue = eCastingBar.startTime + ( eCastingBar.endTime - intTimeLeft );
		eCastingBarStatusBar:SetValue( intBarValue );
		
		--reset the flash to hidden
		 eCastingBarFlash:Hide( );
		
		-- updates the spark
		intSparkPosition = ( ( intBarValue - eCastingBar.startTime ) / ( eCastingBar.endTime - eCastingBar.startTime ) ) * 195;
		eCastingBarSpark:SetPoint( "CENTER", "eCastingBarStatusBar", "LEFT", intSparkPosition, 0 );
		
	-- no,  is the current time < the hold time?
	elseif( GetTime( ) < eCastingBar.holdTime ) then
	
		-- yes, exit, we aren't doing anything
		return;
	
	-- no, are we in flash mode?
	elseif( eCastingBar.flash ) then
	
		-- yes, sest the flash alpha
		local intAlpha = eCastingBarFlash:GetAlpha( ) + CASTING_BAR_FLASH_STEP;
		
		-- reset the text
		eCastingBar_Time:SetText( "" );
		
		-- is the flash alpha < 1?
		if( intAlpha < 1 ) then
		
			-- yes, step it up
			eCastingBarFlash:SetAlpha( intAlpha );
			
		else
		
			-- no, which means its 1 or greater, and we are at full alpha and done.
			eCastingBar.flash = nil;
			
		end
		
	-- no, are we fading out now?
	elseif ( eCastingBar.fadeOut ) then
	
		--yes, set the CastingBar alpha
		local intAlpha = eCastingBar:GetAlpha( ) - CASTING_BAR_ALPHA_STEP;
		
		-- is the bar alpha > 0?
		if( intAlpha > 0 ) then
		
			-- step it down
			eCastingBar:SetAlpha( intAlpha );
			
		else
		
			-- no, which means its 0 or larger, and we are at fully transparent so we are done and hide the bar.
			eCastingBar.fadeOut = nil;
			eCastingBar:Hide( );
			
		end
		
	end
	
end

--[[ Starts moving the frame. ]]--
function eCastingBar_MouseUp( strButton, frmFrame )

	if( eCastingBar_GetLocked( ) == 0 ) then
		getglobal( frmFrame ):StopMovingOrSizing( );
	end
end

--[[ Stops moving the frame. ]]--
function eCastingBar_MouseDown( strButton, frmFrame )
	if( strButton == "LeftButton" and eCastingBar_GetLocked( ) == 0 ) then
		getglobal( frmFrame ):StartMoving( );
	end
end

--[[-------------------------------------------
	Functions for Locked State
-------------------------------------------]]--

--[[ Unlocks the frame. ]]--
function eCastingBar_Unlock( )
	-- first make sure we are enabled
	if( eCastingBar_GetEnabled( ) == 1 ) then

		--show the frame so you can move it
		eCastingBarDragButton:Show( );
		
		-- set the cVar
		eCastingBar_SetLocked( 0 );
		
	end
end

--[[ Locks the frame. ]]--
function eCastingBar_Lock( )

	-- first make sure we are enabled
	if( eCastingBar_GetEnabled( ) == 1 ) then
		--hide the frame, now that we are done
		eCastingBarDragButton:Hide( );

		-- set the cVar
		eCastingBar_SetLocked( 1 );		
		
	end
end

--[[ Toggles Lock/unlock of the frame. ]]--
function eCastingBar_LockToggle( intState )

	-- are we locked?
	if( intState == 1 ) then
	
		-- yes, make it so
		eCastingBar_Lock( );
		
	-- no, are we unlocked?
	elseif( intState == 0 ) then
	
		-- yes, make it so
		eCastingBar_Unlock( );
	
	else
	
		-- error goes here
		
	end
end

--[[  Sets Locked or Unlocked variable ]]--
function eCastingBar_SetLocked( intState )
	-- set it
	eCastingBar_Saved[eCastingBar_Player]["Locked"] = intState;
end

--[[  Gets Locked state ]]--
function eCastingBar_GetLocked( )
	-- get it
	return eCastingBar_Saved[eCastingBar_Player]["Locked"];
end

--[[-------------------------------------------
	Functions for Enabled State
-------------------------------------------]]--

--[[ Disables the frame. ]]--
function eCastingBar_Disable( )

	local intIndex = 0;
	local strEvent = "";
	
	-- for each border in eCastingBar__Events register event.
	for intIndex, strEvent in eCastingBar__Events do
	
		-- make sure old casting bar is registered
		eCastingBar_Register( "CastingBarFrame", strEvent );
			
		-- now unregister our casting bar
		eCastingBar_Unregister( "eCastingBar", strEvent );
		
	end
	
	-- CastTime mod exist 
	if( CastTimeFrame ) then
	
		-- for each event in eCastingBar__CastTimeEvents register event.
		for intIndex, strEvent in eCastingBar__CastTimeEvents do
		
			-- make sure CastTime mod is enabled also bar is registered
			eCastingBar_Register( "CastTimeFrame", strEvent );
			
		end

	end
	
	-- update the cVar
	eCastingBar_SetEnabled( 0 );
	
	-- is the frame unlocked?
	if( eCastingBar_GetLocked( ) == 0 ) then
	
		-- yes, lets hide the outline
		eCastingBarDragButton:Hide( );
		
	end
end

--[[ Enables the frame. ]]--
function eCastingBar_Enable( )

	local intIndex = 0;
	local strEvent = "";
	
	-- for each border in eCastingBar__Events register event.
	for intIndex, strEvent in eCastingBar__Events do
	
		-- make sure our bar is registered
		eCastingBar_Register( "eCastingBar", strEvent );
		
		-- now unregister blizzard bar
		eCastingBar_Unregister( "CastingBarFrame", strEvent );
		
	end
	
	-- CastTime mod exist 
	if( CastTimeFrame ) then
	
		-- for each event in eCastingBar__CastTimeEvents register event.
		for intIndex, strEvent in eCastingBar__CastTimeEvents do
		
			-- make sure CastTime mod is enabled also bar is registered
			eCastingBar_Unregister( "CastTimeFrame", strEvent );
			
		end

	end

	-- update the cVar
	eCastingBar_SetEnabled( 1 );
	
	-- is the frame unlocked?
	if( eCastingBar_GetLocked( ) == 0 ) then
	
		-- yes, lets show the outline
		eCastingBarDragButton:Show( );
		
	end		
end

--[[ Toggle enabled state. ]]--
function eCastingBar_EnableToggle( intState )

	-- are we enabled?
	if( intState == 1 ) then
	
		eCastingBar_Enable( );
	
	-- no, are we disabled?
	elseif ( intState == 0 ) then
	
		eCastingBar_Disable( );
				
	else
	
		-- error  goes here
		
	end
	
end

--[[ Sets Enabled or Disabled variable ]]--
function eCastingBar_SetEnabled( intState )
	-- set it
	eCastingBar_Saved[eCastingBar_Player]["Enabled"] = intState;
end

--[[  Gets Enabled state ]]--
function eCastingBar_GetEnabled( )
	-- get it
	return eCastingBar_Saved[eCastingBar_Player]["Enabled"];
end


--[[-------------------------------------------
	Functions for using the Texture 
-------------------------------------------]]--

--[[ uses blizzard default texture. ]]--
function eCastingBar_TextureDisable( )

	eCastingBarTexture:SetTexture( CASTING_BAR_DEFAULT_TEXTURE );
end

--[[ uses the texture that comes w/ perl_common. ]]--
function eCastingBar_TextureEnable( )

	eCastingBarTexture:SetTexture( CASTING_BAR_PERL_TEXTURE );
end

--[[ Toggle enabled state. ]]--
function eCastingBar_TextureToggle( intState )

	-- are we enabled?
	if( intState == 1 ) then
	
		eCastingBar_TextureEnable( );
	
	-- no, are we disabled?
	elseif ( intState == 0 ) then
	
		eCastingBar_TextureDisable( );
				
	else
	
		-- error  goes here
		
	end
	
end

--[[ Sets Prel Texture Enabled or Disabled variable ]]--
function eCastingBar_SetTexture( intState )
	-- set it
	eCastingBar_Saved[eCastingBar_Player]["UsePerlTexture"] = intState;
end

--[[  Gets Texture( state ]]--
function eCastingBar_GetTexture( )
	-- get it
	return eCastingBar_Saved[eCastingBar_Player]["UsePerlTexture"];
end
