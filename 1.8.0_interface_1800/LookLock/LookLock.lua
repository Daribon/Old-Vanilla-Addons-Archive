--[[
	Look Lock
		Allows user to switch to a state where moving the mouse rotates the character.

	By: Mugendai
	Special Thanks:
		Skrag, and iecur showed me how to do this, way back during beta, and
		thus allowed me to make my first addon.
	Contact: mugekun@gmail.com

	This addon makes it possible to bind a key to enter a state where
	moving the mouse rotates the character, without holding down a button.
	While in this mode, the mouse buttons can be set to behave
	differently, or to strafe.

	It used to provide a mode that lets this, look lock, state always be on.
	However this mode is disabled at present, as Blizzard has made it impossible.

	$Id: LookLock.lua 2603 2005-10-12 03:01:28Z mugendai $
	$Rev: 2603 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-11 22:01:28 -0500 (Tue, 11 Oct 2005) $
]]--

--------------------------------------------------
--
-- LookLock Declaration
--
--------------------------------------------------
LookLock = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.37;
	UPDATETIME=0.1;	--How often to check that the mouse is not over a frame in always look mode
	FLUFF=10;				--Amount of extra pixels to tack on to the area of frames when checking mouse in always look mode
	
	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	LastUpdate = 0;	--What time the last update occured
	
	--If any of these frames are found to be open, the mouse will return to normal
	--First entry in each table is the frame name, second and third are frames to go through
	--Ex: {"ContainerFrame",1,17}, will do "ContainerFrame1" through "ContainerFrame17"
	FramesToCheck = {
		{"AuctionFrame"},
		{"BankFrame"},
		{"BattlefieldFrame"},
		{"CharacterFrame"},
		{"ChatMenu"},
		{"EmoteMenu"},
		{"LanguageMenu"},
		{"VoiceMacroMenu"},
		{"ClassTrainerFrame"},
		{"CoinPickupFrame"},
		{"ContainerFrame",1,17},
		{"CraftFrame"},
		{"FriendsFrame"},
		{"GameMenuFrame"},
		{"GossipFrame"},
		{"GuildRegistrarFrame"},
		{"HelpFrame"},
		{"InspectFrame"},
		{"InspectPaperDollFrame"},
		{"ItemTextFrame"},
		{"KeyBindingFrame"},
		{"LootFrame"},
		{"MacroFrame"},
		{"MailFrame"},
		{"MerchantFrame"},
		{"OptionsFrame"},
		{"PaperDollFrame"},
		{"PetPaperDollFrame"},
		{"PetRenamePopup"},
		{"PetStable"},
		{"QuestFrame"},
		{"QuestLogFrame"},
		{"RaidFrame"},
		{"ReputationFrame"},
		{"ScriptErrors"},
		{"SkillFrame"},
		{"SoundOptionsFrame"},
		{"SpellBookFrame"},
		{"StackSplitFrame"},
		{"StaticPopup1"},
		{"StaticPopup2"},
		{"StaticPopup3"},
		{"StaticPopup4"},
		{"StatsFrame"},
		{"SuggestFrame"},
		{"TabardFrame"},
		{"TalentFrame"},
		{"TalentTrainerFrame"},
		{"TaxiFrame"},
		{"TradeFrame"},
		{"TradeSkillFrame"},
		{"TutorialFrame"},
		{"DropDownList",1,3},
		{"UIOptionsFrame"},
		{"UnitPopup"},
		{"WorldMapFrame"},
		{"CosmosMasterFrame"},
		{"CosmosDropDown"},
		{"CosmosDropDownBis"},
		{"ChooseItemsFrame"},
		{"ImprovedErrorFrameFrame"},
		{"IEFMinimapButton"},
		{"InventoryManagerFrame"},
		{"TicTacToeFrame"},
		{"OthelloFrame"},
		{"MinesweeperFrame"},
		{"GamesListFrame"},
		{"ConnectFrame"},
		{"ChessFrame"},
		{"QuestShareFrame"},
		{"TotemStomperFrame"},
		{"WantAds"},
		{"AtlasFrame"},
		{"AtlasOptionsFrame"},
		{"BetterKeyBindingFrame"},
		{"CensusPlus"},
		{"CharactersViewer_Frame"},
		{"EarthFeatureFrame"},
		{"FireFrame"},
		{"GathererUI_Options"},
		{"GathererUI_Popup"},
		{"GathererUI_ZoneRematchDialog"},
		{"KhaosFrame"},
		{"KhaosImportExportFrame"},
		{"KhaosLoginSelectionFrame"},
		{"MonkeyBuddyFrame"},
		{"NotepadFrame"},
		{"PartyQuestsFrame"},
		{"PartyQuestsLogFrame"},
		{"SCTOptions"},
		{"ShardTrackerSortFrame"},
		{"SocialNotesEditorFrame"},
		{"TotemStomperFrame"}
	};
	
	--If any of these frames are found to be open, and the mouse is over them, the mouse will return to normal
	--First entry in each table is the frame name, second and third are frames to go through
	--Ex: {"ContainerFrame",1,17}, will do "ContainerFrame1" through "ContainerFrame17"
	FramesToCheckForMouse = {
		{"BonusActionBarFrame"},
		{"BuffFrame"},
		{"CastingBarFrame"},
		{"ChatFrame",1,7},
		{"ChatFrame%iTab",1,7},
		{"ChatFrame%iBottomButton",1,7},
		{"ChatFrame%iDownButton",1,7},
		{"ChatFrame%iUpButton",1,7},
		{"ChatFrameMenuButton"},
		{"ChatFrameEditBox"},
		{"CoinPickupFrame"},
		{"ColorPickerFrame"},
		{"DialogBoxFrame"},
		{"DurabilityFrame"},
		{"GameTimeFrame"},
		{"GameTooltip"},
		{"MainMenuBar"},
		{"MinimapCluster"},
		{"MultiBarBottomLeft"},
		{"MultiBarBottomRight"},
		{"MultiBarLeft"},
		{"MultiBarRight"},
		{"PartyFrame"},
		{"PetActionBarFrame"},
		{"PetFrame"},
		{"PetitionFrame"},
		{"PlayerFrame"},
		{"QuestTimerFrame"},
		{"TargetFrame"},
		{"UnitFrame"},
		{"ZoneTextFrame"},
		{"SubZoneTextFrame"},
		{"AutoFollowStatus"},
		{"SecondBar"},
		{"PopBarKnob"},
		{"PopBarButton1%02d",1,12},
		{"PopBarButton2%02d",1,12},
		{"PopBarButton3%02d",1,12},
		{"PopBarButton4%02d",1,12},
		{"PopBarButton5%02d",1,12},
		{"PopBarButton6%02d",1,12},
		{"PopBarButton7%02d",1,12},
		{"PopBarButton8%02d",1,12},
		{"PopBarButton9%02d",1,12},
		{"PopBarButton10%02d",1,12},
		{"PopBarButton11%02d",1,12},
		{"PopBarButton12%02d",1,12},
		{"ClockFrame"},
		{"CosmosTooltip"},
		{"CombatStatsDataFrame"},
		{"CombatStatsFrame"},
		{"DPSPLUS_PlayerFrame"},
		{"ItemBuffBar"},
		{"ItemBuffButton",1,6},
		{"KillCountFrame"},
		{"KillCountFrame2"},
		{"InventoryManagerTooltip"},
		{"MonitorStatus"},
		{"MooBuffTooltip"},
		{"MooBuffFrame"},
		{"MooBuffButton",0,23},
		{"QuestTooltip"},
		{"SideBar"},
		{"SideBar2"},
		{"TargetDistanceFrame"},
		{"TargetStatsTooltip"},
		{"AlarmClockFrame"},
		{"MiniCensusPlus"},
		{"ChannelManagerFrame"},
		{"ChatFrame1TabRight1"},
		{"ChatFrame1TabRight2"},
		{"ChatFrame1TabRight3"},
		{"ChatFrame1Tab1"},
		{"ChatFrame1Tab2"},
		{"ChatFrame1Tab3"},
		{"DamageMetersTooltip"},
		{"DMReportFrame"},
		{"DamageMetersFrame"},
		{"DivineBlessingFrame"},
		{"EarthMinimapButton"},
		{"ComparisonTooltip",1,2},
		{"VickelFrame"},
		{"GathererUI_IconFrame"},
		{"MeteorologistTooltip"},
		{"MonkeyQuestFrame"},
		{"MonkeySpeedFrame"},
		{"RaidMinionTab",1,8},
		{"RaidMinionTab51"},
		{"RaidMinionPlayer",1,80},
		{"RaidMinionPlayer50",1,9},
		{"RaidMinionPlayer510"},
		{"RogueHelperFrame"},
		{"ShardTrackerShieldTimerBarFrame"},
		{"ShardTrackerShieldEnergyBarFrame"},
		{"TellTrackFrame"},
		{"TellTrackTooltip"},
		{"WeaponButtonsFrame"}
	};
};

--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
--Main Configuration variable
LookLock_Config = {
	Remap = 0;					--Set this to 1 if you want the mouse buttons remapped to use the modified versions.
	Strafe = 0;					--Set this to 1 if you want the mouse buttons to act as strafe left/right when using looklock.
	AlwaysLook = 0;			--Set this to 1 if you want the mouse to always be in look lock mode
	SelectMode = 0;			--Set this to 1 if you want the left mouse button to give a cursor for selection when in AlwaysLook mode
	UseCursor = 0;			--Set this to 1 if you want a targeting cursor to be shown when in always look mode
	EasyLook = 0;				--Set this to 1 if you want the right mouse button to enter look lock mode when released after x seconds of holding it
	EasyLookTime = 2;		--The amount of time the right mouse must be held down for easy look to be activated
	EasyCamera = 0;			--Set this to 1 if you want the left mouse button to enter camera lock mode when released after x seconds of holding it
	EasyCameraTime = 2;	--The amount of time the right camera must be held down for easy camera to be activated
	LookTime = 0;				--The amount of time the mouse must be in the look area before look mode is turned back on
	UseArea = 0;				--Set this to 1 if you want to only re-enter look mode, while in always look, when the mouse is within a set area
	AreaWidth = 0.25;		--This increases/descreases the width of the look area
	AreaHeight = 0.33;	--This increases/descreases the height of the look area
	AreaHOff = 0;				--This increases/descreases the horizontal offset of the look area
	AreaVOff = 0;				--This increases/descreases the vertical offset of the look area
};
--Store this config for safe load
MCom.safeLoad("LookLock_Config");

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Checks all frames to see if look mode needs to be disabled ]]--
LookLock.CheckFrames = function ()
	--Check all the open check frames
	for index = 1, table.getn(LookLock.FramesToCheck) do
		local doCount = false;	--Set true if the frame needs to have multiples checked
		--Get the start frame number
		local curNum = 0;
		if ( LookLock.FramesToCheck[index][2] ) then
			curNum = LookLock.FramesToCheck[index][2];
		end
		--Get the stop frame number
		local maxNum = 0;
		if ( LookLock.FramesToCheck[index][3] ) then
			maxNum = LookLock.FramesToCheck[index][3];
		end
		--If the start and stop numbers are different, then we have a range to go through.
		if (curNum ~= maxNum) then
			doCount = true;
		end
		--Go through all the numbered frames, if any
		repeat
			local curFrameName = LookLock.FramesToCheck[index][1];
			--If we have multiple frames, then check the current one
			if (doCount and (curNum <= maxNum)) then
				--If there is a % in the current frame name, then replace it with the frame number
				if (string.find(curFrameName, "%%")) then
					curFrameName = string.format(curFrameName, curNum);
				else
					curFrameName = curFrameName..curNum;
				end
				curNum = curNum + 1;
			end
			--Get the current frame
			local curFrame = getglobal(curFrameName);
			--If we have the frame, and it is visible, then return true
			if (curFrame and curFrame:IsVisible()) then
				return true;
			end
		until ( (curNum > maxNum) or (doCount == false) )
	end

	--Go through all the mouse check frames
	for index = 1, table.getn(LookLock.FramesToCheckForMouse) do
		local doCount = false;	--Set true if the frame needs to have multiples checked
		--Get the start frame number
		local curNum = 0;
		if ( LookLock.FramesToCheckForMouse[index][2] ) then
			curNum = LookLock.FramesToCheckForMouse[index][2];
		end
		--Get the stop frame number
		local maxNum = 0;
		if ( LookLock.FramesToCheckForMouse[index][3] ) then
			maxNum = LookLock.FramesToCheckForMouse[index][3];
		end
		--If the start and stop numbers are different, then we have a range to go through.
		if (curNum ~= maxNum) then
			doCount = true;
		end
		--Go through all the numbered frames, if any
		repeat
			local curFrameName = LookLock.FramesToCheckForMouse[index][1];
			--If we have multiple frames, then check the current one
			if (doCount and (curNum <= maxNum)) then
				--If there is a % in the current frame name, then replace it with the frame number
				if (string.find(curFrameName, "%%")) then
					curFrameName = string.format(curFrameName, curNum);
				else
					curFrameName = curFrameName..curNum;
				end
				curNum = curNum + 1;
			end
			--Get the current frame
			local curFrame = getglobal(curFrameName);
			--If the current frame has the mouse over it, then return true
			if (curFrame and curFrame:IsVisible()) then
				--Get the mouse position
				local xPos, yPos = GetCursorPosition();
				--Get the sides of the current frame
				local left = curFrame:GetLeft();
				local right = curFrame:GetRight();
				local top = curFrame:GetTop();
				local bottom = curFrame:GetBottom();
				local scale = UIParent:GetScale();
				--Make sure we have all neccisary data for the check
				if (xPos and yPos and left and right and top and bottom and scale) then
					--Scale the sides
					left = left * scale;
					right = right * scale;
					top = top * scale;
					bottom = bottom * scale;
					--If this is a chat frame then give it some extra padding for safety
					if (string.find(curFrameName, "ChatFrame")) then
						top = top + 20;
						left = left - 20;
						right = right + 10;
						bottom = bottom - 10;
					else
						top = top + LookLock.FLUFF;
						left = left - LookLock.FLUFF;
						right = right + LookLock.FLUFF;
						bottom = bottom - LookLock.FLUFF;
					end
					--If the current frame has the mouse over it, then return true
					if ((xPos >= left) and (xPos <= right) and (yPos >= bottom) and (yPos <= top)) then
						return true;
					end
				end
			end
		until ( (curNum > maxNum) or (doCount == false) )
	end
	--Nothing found, return false
	return false;
end

--[[ Returns true if the mouse is in the area, or if area checking is disabled ]]--
LookLock.InArea = function ()
	if (LookLock_Config.UseArea == 1) then
		if (LookLockArea) then
			--Get the mouse position
			local xPos, yPos = GetCursorPosition();
			--Get the sides of the current frame
			local left = LookLockArea:GetLeft();
			local right = LookLockArea:GetRight();
			local top = LookLockArea:GetTop();
			local bottom = LookLockArea:GetBottom();
			local scale = UIParent:GetScale();
			--Make sure we have all neccisary data for the check
			if (xPos and yPos and left and right and top and bottom and scale) then
				--Scale the sides
				left = left * scale;
				right = right * scale;
				top = top * scale;
				bottom = bottom * scale;
				--If the area frame has the mouse over it, then return true
				if ((xPos >= left) and (xPos <= right) and (yPos >= bottom) and (yPos <= top)) then
					return true;
				end
			end
		end
	else
		return true;
	end
end

--[[ Updates the size and position of the Look Area ]]--
LookLock.UpdateArea = function ()
	--Get the screen size and scale
	local sWidth = GetScreenWidth();
	local sHeight = GetScreenHeight();
	local scale = UIParent:GetScale();
	if (sWidth and sHeight and scale) then
		--Calculate the new position and size
		local aWidth = sWidth * LookLock_Config.AreaWidth;
		local aHeight = sHeight * LookLock_Config.AreaHeight;
		local aHOff = ( ( (sWidth / 2) - ( aWidth /2 ) ) * LookLock_Config.AreaHOff );-- * scale;
		local aVOff = ( ( (sHeight / 2) - ( aHeight / 2 ) ) * LookLock_Config.AreaVOff );-- * scale;
		--Move to the new position
		if (aHOff and aVOff) then
			LookLockArea:ClearAllPoints();
			LookLockArea:SetPoint("CENTER", "UIParent", "CENTER", aHOff, aVOff);
		end
		--Resize to the new size
		if (aWidth) then
			LookLockArea:SetWidth(aWidth);
		end
		if (aHeight) then
			LookLockArea:SetHeight(aHeight);
		end
	end
end

--[[ Returns false unless the mouse has been in a valid look area for long enough ]]--
LookLock.CheckAutoLook = function ()
	--See if any frames require us to stop looking, and if we are in the right area
	LookLock.FrameStatus = LookLock.CheckFrames();
	local autoLook = ( LookLock.FrameStatus or ( not LookLock.InArea() ) );
	
	--If the time of the previous check is not set, then set it
	if (not LookLock.ALCheck) then
		LookLock.ALCheck = GetTime();
	end
	--If we are in a good state for entering look mode, then check the time
	if (not autoLook) then
		--If we have met the look time, then return true
	 	if ( ( GetTime() - LookLock.ALCheck ) >= LookLock_Config.LookTime ) then
			return true;
		end
	else
		--This is not a valid state, so set the last check time to nil
		LookLock.ALCheck = nil;
	end
end

--[[ Toggle's Look Lock mode ]]--
LookLock.Toggle = function (arg1)
	--If we are not in always look mode then toggle look lock mode
	if (LookLock_Config.AlwaysLook ~= 2) then
		--If we are not in look mode, then turn it on, else turn it off
		if ( LookLock.Lock ~= 1 ) then
			MCom.callHook("TurnOrActionStart", arg1);
			LookLock.InTurn = true;
			LookLock.Lock = 1;
		else
			MCom.callHook("TurnOrActionStop", arg1);
			LookLock.InTurn = nil;
			LookLock.Lock = nil;
		end
	else
		--If we are in always look mode then
		--if we are not locked, then do normal always look behavior,
		--otherwise, act normalish
		if ( LookLock.Lock ~= 1 ) then
			LookLock.Lock = 1;
			LookLock.InTurn = nil;
			MCom.callHook("TurnOrActionStop", arg1);
		else
			LookLock.Lock = nil;
		end
	end
end

--[[ Toggle's Camera Lock mode ]]--
LookLock.ToggleCamera = function (arg1)
	--If we are not in camera mode, then turn it on, else turn it off
	if ( LookLock.Camera ~= 1 ) then
		MCom.callHook("CameraOrSelectOrMoveStart", arg1);
		LookLock.Camera = 1;
	else
		MCom.callHook("CameraOrSelectOrMoveStop", arg1);
		LookLock.Camera = nil;
	end
end

--[[ Stops all turning and camera locks ]]--
LookLock.StopAll = function ()
	MCom.callHook("TurnOrActionStop");
	LookLock.InTurn = nil;
	LookLock.Lock = nil;
	MCom.callHook("CameraOrSelectOrMoveStop");
	LookLock.Camera = nil;
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------
--[[ Hooked to handle right mouse button down ]]--
LookLock.TurnOrActionStart = function (arg1)
	--The right mouse button has been pressed down so lets remember that
	LookLock.RightMouseDown = GetTime();
	--Record the frame status on down, so the same can be used on up
	LookLock.LastAutoLook = LookLock.AutoLook;
	local doNorm = true;	--If set false, we will not call the normal function
	--If remaping is enabled, then do so now
	if (LookLock_Config.Remap == 1) then
		--If this is not Always Look mode, then do it using normal Look Lock mode
		if ( (LookLock_Config.AlwaysLook ~= 2) ) then
			doNorm = false;	--Don't call the origional function
			--If we are in look lock mode, then do look lock behavior
			if ( ( LookLock.Lock == 1 ) or ( LookLock.Camera == 1 ) ) then
				--If strafe mode is on, then start strafing
				if ( ( LookLock.Lock == 1 ) and ( LookLock_Config.Strafe == 1 ) ) then
					StrafeRightStart(arg1);
				else
					if ( LookLock.Lock == 1 ) then
						--Call the origional stop looking function
						MCom.callHook("TurnOrActionStop", arg1);
						--We are now not in a turn
						LookLock.InTurn = nil;
					end
					--If we are in camera mode then stop the camera rotation
					if ( LookLock.Camera == 1 ) then
						MCom.callHook("CameraOrSelectOrMoveStop", arg1);
					end
				end
			else
				--If we are not in look lock mode, then call the normal function
				doNorm = true;
			end
		end
	end

	--If we should call the normal function, then we are in a turn
	if (doNorm) then
		LookLock.InTurn = true;
	end
	return doNorm;
end

--[[ Hooked to handle right mouse button up ]]--
LookLock.TurnOrActionStop = function (arg1)
	--Figure out how long the mouse button was held down
	local holdTime = GetTime();
	if (LookLock.RightMouseDown) then
		holdTime = holdTime - LookLock.RightMouseDown;
	else
		holdTime = 0;
	end
	--The right mouse button has been released so lets remember that
	LookLock.RightMouseDown = nil;
	local doNorm = true;	--If set false, we will not call the normal function
	--If remaping is enabled, then do so now
	if (LookLock_Config.Remap == 1) then
		--If this is not Always Look mode, then do it using normal Look Lock mode
		if (LookLock_Config.AlwaysLook ~= 2) then
			doNorm = false;	--Don't call the origional function
			--If we are in look lock mode, then do look lock behavior
			if ( ( LookLock.Lock == 1 ) or ( LookLock.Camera == 1 ) ) then
				--If strafe mode is on, then stop strafing
				if ( ( LookLock.Lock == 1 ) and ( LookLock_Config.Strafe == 1 ) ) then
					StrafeRightStop(arg1);
				else
					--Call the origional action start function so we can have a click on release
					if ( not LookLock.FrameStatus) then
						MCom.callHook("TurnOrActionStart", arg1);
					end
					if ( LookLock.Lock == 1 ) then
						LookLock.InTurn = nil;	--We are no longer in a turn
						LookLock.Lock = nil;				--Look lock is now off
					end
					if ( LookLock.Camera == 1 ) then
						LookLock.Camera = nil;
					end
					doNorm = true;	--Do the normal function when we finish
				end
			else
				--Do the normal function
				doNorm = true;
			end
		elseif ( LookLock.Lock ~= 1 ) then
			--Do always look behavior
			if ( (not LookLock.InTurn) and GameTooltip:IsVisible() and (not LookLock.LastAutoLook) and ( not LookLock.FrameStatus) ) then
				--If we are in a turn, and the mouse has been released, then we need to start looking again
				MCom.callHook("TurnOrActionStart", arg1);
			end
		end
	elseif (LookLockAlwaysLook ~= 2) then
		--We should end our lock if we release
		LookLock.Lock = nil;
	end
		
	--If we should call the normal function, then we are no longer in a turn
	if (doNorm) then
		LookLock.InTurn = nil;
	end

	if ( ( LookLock_Config.EasyLook == 1 ) and ( LookLock_Config.EasyLookTime <= holdTime ) ) then
		if (doNorm) then
			MCom.callHook("TurnOrActionStop", arg1);
		end
		doNorm = false;
		MCom.callHook("TurnOrActionStart", arg1);
		LookLock.Lock = 1;
	end

	return doNorm;
end

--[[ Hooked to handle left mouse button down ]]--
LookLock.CameraOrSelectOrMoveStart = function (arg1)
	--The left mouse button has been pressed so lets remember that
	LookLock.LeftMouseDown = GetTime();
	--Record the frame status on down, so the same can be used on up
	LookLock.LastAutoLook = LookLock.AutoLook;
	local doNorm = true;	--If set false, we will not call the normal function
	--If remaping is enabled, then do so now
	if (LookLock_Config.Remap == 1) then
		--If this is not Always Look mode, then do it using normal Look Lock mode
		if (LookLock_Config.AlwaysLook ~= 2) then
			doNorm = false;	--Don't call the origional function
			--If we are in look lock mode, then do look lock behavior
			if ( ( LookLock.Lock == 1 ) or ( LookLock.Camera == 1 ) ) then
				--If strafe mode is on, then start strafing
				if ( ( LookLock.Lock == 1 ) and ( LookLock_Config.Strafe == 1 ) ) then
					StrafeLeftStart(arg1);
				else
					if ( LookLock.Lock == 1 ) then
						--Stop turning
						MCom.callHook("TurnOrActionStop", arg1);
					end
					--If we are in camera mode then stop the camera rotation
					if ( LookLock.Camera == 1 ) then
						MCom.callHook("CameraOrSelectOrMoveStop", arg1);
					end
					doNorm = true;	--Call the normal function
					--If select mode is enabled, then don't call the origional function
					if (LookLock_Config.SelectMode == 1) then
						doNorm = false;
					end
				end
			else
				--Call the normal function
				doNorm = true;
			end
		elseif ( LookLock.Lock == 1 ) then
			--Call the normal function if this is always look mode and look lock is on
			doNorm = true;
		elseif (LookLock_Config.AlwaysLook == 2) then
			if (not LookLock.AutoLook) then
				if (LookLock.InTurn) then
					--If we are doing an always look, and look lock is off, and we were in a turn, then
					--stop turning
					MCom.callHook("TurnOrActionStop", arg1);
				end
				--If select mode is enabled, then don't call the origional function
				if (LookLock_Config.SelectMode == 1) then
					doNorm = false;
				end
			end
		end
	end

	return doNorm;
end

--[[ Hooked to handle left mouse button up ]]--
LookLock.CameraOrSelectOrMoveStop = function (arg1)
	--Figure out how long the mouse button was held down
	local holdTime = GetTime();
	if (LookLock.LeftMouseDown) then
		holdTime = holdTime - LookLock.LeftMouseDown;
	else
		holdTime = 0;
	end
	--The left mouse button has been released so lets remember that
	LookLock.LeftMouseDown = nil;
	local doNorm = true;	--If set false, we will not call the normal function
	--If remaping is enabled, then do so now
	if (LookLock_Config.Remap == 1) then
		--If this is not Always Look mode, then do it using normal Look Lock mode
		if (LookLock_Config.AlwaysLook ~= 2) then
			doNorm = false;	--Don't call the origional function
			--If we are in look lock mode, then do look lock behavior
			if ( ( LookLock.Lock == 1 ) or ( LookLock.Camera == 1 ) ) then
				--If strafe mode is on, then stop strafing
				if ( ( LookLock.Lock == 1 ) and ( LookLock_Config.Strafe == 1 ) ) then
					StrafeLeftStop(arg1);
				else
					if ( LookLock.Camera == 1 ) then
						LookLock.Camera = nil;
					end
					--If select mode is enabled, then click the target
					if ( LookLock_Config.SelectMode == 1 ) then
						if ( not LookLock.FrameStatus) then
							MCom.callHook("CameraOrSelectOrMoveStart", arg1);
						end
						LookLock.Lock = nil;		--We are leaving lock mode
						LookLock.InTurn = nil;	--We are no longer in a turn
					end
					--If in look lock mode, then stop rotating the camera, and start rotating the character
					MCom.callHook("CameraOrSelectOrMoveStop", arg1);
					if (LookLock_Config.SelectMode ~= 1) then
						MCom.callHook("TurnOrActionStart", arg1);
					end
				end
			else
				--Call the normal function
				doNorm = true;
			end
		elseif ( LookLock.Lock == 1 ) then
			--Call the normal function if this is always look mode and look lock is on
			doNorm = true;
		elseif ( LookLock_Config.AlwaysLook == 2 ) then
			if (not LookLock.LastAutoLook) then
				--If select mode is enabled, then click the target
				if ( (LookLock_Config.SelectMode == 1)  and ( not LookLock.FrameStatus) ) then
					MCom.callHook("CameraOrSelectOrMoveStart", arg1);
				end
				if (LookLock.InTurn) then
					--If we are doing an always look, and look lock is off, and we were in a turn, then
					--stop the camera rotating, and start the character rotating
					doNorm = false;
					MCom.callHook("CameraOrSelectOrMoveStop", arg1);
					MCom.callHook("TurnOrActionStart", arg1);
				end
			end
		end
	end

	if ( ( LookLock_Config.EasyCamera == 1 ) and ( LookLock_Config.EasyCameraTime <= holdTime ) ) then
		if (doNorm) then
			MCom.callHook("CameraOrSelectOrMoveStop", arg1);
		end
		doNorm = false;
		MCom.callHook("CameraOrSelectOrMoveStart", arg1);
		LookLock.Camera = 1;
	end

	return doNorm;
end

--------------------------------------------------
--
-- Data Storage
--
--------------------------------------------------

--[[ Saves the current configuration on a per realm/per character basis ]]--
LookLock.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "LookLock_Config";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
LookLock.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "LookLock_Config";
		nonUIList = {};
	});
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
LookLock.OnVarsLoaded = function ()
	LookLock.VarsLoaded = true;
	if (not LookLock.ConfigLoaded) then
		LookLock.ConfigLoaded = true;
		--Load the configuration
		LookLock.LoadConfig();

		--For extra safety we make sure that Always Look mode is disabled
		LookLock_Config.AlwaysLook = 0;

		--Store the configuration for this character
		LookLock.SaveConfig();

		--Update the size of the look area
		LookLock.UpdateArea();
	end;
end

LookLock.OnUpdate = function (elapsed)
	if (LookLock.VarsLoaded) then
		--Only update every 10th of a second
		LookLock.LastUpdate = LookLock.LastUpdate + elapsed;
		if (LookLock.LastUpdate >= LookLock.UPDATETIME) then 
			LookLock.LastUpdate = 0;

			--Move the targeting cursor to the same spot as the normal cursor
			local xPos, yPos = GetCursorPosition();
			local scale = LookLockCursor:GetScale();
			if (xPos and yPos and scale) then
				xPos = xPos / scale;
				yPos = yPos / scale;
				LookLockCursor:ClearAllPoints();
				LookLockCursor:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", xPos, yPos);
			end

			--See if we are in a good state to enter look mode
			--LookLock.AutoLook = ( not LookLock.CheckAutoLook() );
				
			--If always look mode is on, and the variables have been loaded, then make sure
			--that we are safe to be in look mode
			if (LookLock_Config.AlwaysLook == 2) then
				--If the targeting cursor should be showing, then show it, othewise hide it
				if (	(not LookLock.RightMouseDown) and (not LookLock.Lock) and (not LookLock.AutoLook) and (LookLock_Config.UseCursor == 1) and
							( (LookLock_Config.SelectMode ~= 1) or ( (LookLock_Config.SelectMode == 1) and (not LookLock.LeftMouseDown) ) ) ) then
					if ( not LookLockCursor:IsVisible() ) then
						LookLockCursor:Show();
					end
					if ( LookLockArea:IsVisible() ) then
						LookLockArea:Hide();
					end
				else
					if ( LookLockCursor:IsVisible() ) then
						--Since the normal cursor is visible, hide the targeting cursor
						LookLockCursor:Hide();
					end
					if ( ( LookLock_Config.UseArea == 1 ) and ( not LookLockArea:IsVisible() ) ) then
						LookLockArea:Show();
					elseif ( ( LookLock_Config.UseArea ~= 1 ) and LookLockArea:IsVisible() ) then
						LookLockArea:Hide();
					end
				end

				--If we are not in lock mode, then deal with always look mode
				if (not LookLock.Lock) then
					--If the mouse isn't down, and there is nothing in the cursor, and we are all clear on frames, and aren't in a turn then
					--put us in look mode
					if ( (not LookLock.RightMouseDown) and (not LookLock.LeftMouseDown) and (not CursorHasItem()) and (not LookLock.AutoLook) ) then
						if (not LookLock.InTurn) then
							MCom.callHook("TurnOrActionStart");
							LookLock.InTurn = true;	--Remember that we are now in turn mode
						end
					elseif ( LookLock.InTurn and ( ( (not LookLock.AutoLook) and LookLock.RightMouseDown ) or (LookLock.AutoLook and (not LookLock.RightMouseDown) ) ) ) then
						--If we are in turn mode, and something needs us to stop turning, then stop now
						MCom.callHook("TurnOrActionStop");
						LookLock.InTurn = nil;	--Remember that we are no longer in turn mode
					end
				end
			else
				--If the targeting cursor should be showing, then show it, othewise hide it
				if (	(not LookLock.RightMouseDown) and ( LookLock.Lock or LookLock.Camera ) and (LookLock_Config.UseCursor == 1) and ( ( not LookLock.Lock ) or ( LookLock_Config.Strafe ~= 1 ) ) and
							( (LookLock_Config.SelectMode ~= 1) or ( (LookLock_Config.SelectMode == 1) and (not LookLock.LeftMouseDown) ) ) ) then
					if (not LookLockCursor:IsVisible()) then
						LookLockCursor:Show();
					end
				elseif (LookLockCursor:IsVisible()) then
					--Since the normal cursor is visible, hide the targeting cursor
					LookLockCursor:Hide();
				end
				if ( LookLockArea:IsVisible() ) then
					LookLockArea:Hide();
				end
			end
		end
	end
end

LookLock.OnLoad = function ()
	if ( LookLock.Initialized ~= 1) then
		--Hook functions
		MCom.util.hook("TurnOrActionStart", "LookLock.TurnOrActionStart", "replace");
		MCom.util.hook("TurnOrActionStop", "LookLock.TurnOrActionStop", "replace");
		MCom.util.hook("CameraOrSelectOrMoveStart", "LookLock.CameraOrSelectOrMoveStart", "replace");
		MCom.util.hook("CameraOrSelectOrMoveStop", "LookLock.CameraOrSelectOrMoveStop", "replace");
		MCom.util.hook("GameMenuFrame", "LookLock.StopAll", "before", "OnShow");

		--Set the initial transparency of the targeting cursor and area
		LookLockCursor:SetAlpha(0.5);
		LookLockArea:SetAlpha(0.5);

		--Register the configuration options
		LookLock.Register();

		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(LookLock.OnVarsLoaded);

		LookLock.Initialized = 1;
	end
end