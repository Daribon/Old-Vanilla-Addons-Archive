--[[
	Look Lock

	By Mugendai

	This mod allows a button to be mapped to allow
	freelook to become locked on.
	It also allows for the option to remap the left
	and right mouse buttons to act different when
	in Look Lock mode.
	
	Thanks go to Skrag and iecur for info on how to do this.
   ]]
   
-- Set this to 1 if you want the mouse buttons remapped to use the modified versions.
LookLockRemapOn = 0;
-- Set this to 1 if you want the mouse buttons to act as strafe left/right when using looklock.
LookLockStrafeOn = 0;
-- Set this to 1 if you want the mouse to always be in look lock mode
LookLockAlwaysLook = 0;

LookLock_ChatHandlers = {};
LookLock_LastUpdate = 0;

LOOKLOCK_UPDATETIME=0.1;
LOOKLOCK_FLUFF=10;

--If any of these frames are found to be open, the mouse will return to normal
LookLock_FramesToCheck = {};
table.insert(LookLock_FramesToCheck, {"AuctionFrame",0,0});
table.insert(LookLock_FramesToCheck, {"BankFrame",0,0});
table.insert(LookLock_FramesToCheck, {"BattlefieldFrame",0,0});
table.insert(LookLock_FramesToCheck, {"CharacterFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ChatMenu",0,0});
table.insert(LookLock_FramesToCheck, {"EmoteMenu",0,0});
table.insert(LookLock_FramesToCheck, {"LanguageMenu",0,0});
table.insert(LookLock_FramesToCheck, {"VoiceMacroMenu",0,0});
table.insert(LookLock_FramesToCheck, {"ClassTrainerFrame",0,0});
table.insert(LookLock_FramesToCheck, {"CoinPickupFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ContainerFrame",1,17});
table.insert(LookLock_FramesToCheck, {"CraftFrame",0,0});
table.insert(LookLock_FramesToCheck, {"FriendsFrame",0,0});
table.insert(LookLock_FramesToCheck, {"GameMenuFrame",0,0});
table.insert(LookLock_FramesToCheck, {"GossipFrame",0,0});
table.insert(LookLock_FramesToCheck, {"GuildRegistrarFrame",0,0});
table.insert(LookLock_FramesToCheck, {"HelpFrame",0,0});
table.insert(LookLock_FramesToCheck, {"InspectFrame",0,0});
table.insert(LookLock_FramesToCheck, {"InspectPaperDollFrame",0,0});
table.insert(LookLock_FramesToCheck, {"KeyBindingFrame",0,0});
table.insert(LookLock_FramesToCheck, {"LootFrame",0,0});
table.insert(LookLock_FramesToCheck, {"MacroFrame",0,0});
table.insert(LookLock_FramesToCheck, {"MailFrame",0,0});
table.insert(LookLock_FramesToCheck, {"MerchantFrame",0,0});
table.insert(LookLock_FramesToCheck, {"OptionsFrame",0,0});
table.insert(LookLock_FramesToCheck, {"PaperDollFrame",0,0});
table.insert(LookLock_FramesToCheck, {"PetPaperDollFrame",0,0});
table.insert(LookLock_FramesToCheck, {"PetRenamePopup",0,0});
table.insert(LookLock_FramesToCheck, {"PetStable",0,0});
table.insert(LookLock_FramesToCheck, {"QuestFrame",0,0});
table.insert(LookLock_FramesToCheck, {"QuestLogFrame",0,0});
table.insert(LookLock_FramesToCheck, {"RaidFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ReputationFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ScriptErrors",0,0});
table.insert(LookLock_FramesToCheck, {"SkillFrame",0,0});
table.insert(LookLock_FramesToCheck, {"SoundOptionsFrame",0,0});
table.insert(LookLock_FramesToCheck, {"SpellBookFrame",0,0});
table.insert(LookLock_FramesToCheck, {"StackSplitFrame",0,0});
table.insert(LookLock_FramesToCheck, {"StaticPopup1",0,0});
table.insert(LookLock_FramesToCheck, {"StaticPopup2",0,0});
table.insert(LookLock_FramesToCheck, {"StaticPopup3",0,0});
table.insert(LookLock_FramesToCheck, {"StaticPopup4",0,0});
table.insert(LookLock_FramesToCheck, {"StatsFrame",0,0});
table.insert(LookLock_FramesToCheck, {"SuggestFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TabardFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TalentFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TalentTrainerFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TaxiFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TradeFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TradeSkillFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TutorialFrame",0,0});
table.insert(LookLock_FramesToCheck, {"DropDownList",1,3});
table.insert(LookLock_FramesToCheck, {"UIOptionsFrame",0,0});
table.insert(LookLock_FramesToCheck, {"UnitPopup",0,0});
table.insert(LookLock_FramesToCheck, {"WorldMapFrame",0,0});
table.insert(LookLock_FramesToCheck, {"CosmosMasterFrame",0,0});
table.insert(LookLock_FramesToCheck, {"CosmosDropDown",0,0});
table.insert(LookLock_FramesToCheck, {"CosmosDropDownBis",0,0});
table.insert(LookLock_FramesToCheck, {"ChooseItemsFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ImprovedErrorFrame",0,0});
table.insert(LookLock_FramesToCheck, {"InventoryManagerFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TicTacToeFrame",0,0});
table.insert(LookLock_FramesToCheck, {"OthelloFrame",0,0});
table.insert(LookLock_FramesToCheck, {"MinesweeperFrame",0,0});
table.insert(LookLock_FramesToCheck, {"GamesListFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ConnectFrame",0,0});
table.insert(LookLock_FramesToCheck, {"ChessFrame",0,0});
table.insert(LookLock_FramesToCheck, {"QuestShareFrame",0,0});
table.insert(LookLock_FramesToCheck, {"TotemStomperFrame",0,0});
table.insert(LookLock_FramesToCheck, {"WantAds",0,0});

--If any of these frames are found to be open, and the mouse is over them, the mouse will return to normal
LookLock_FramesToCheckForMouse = {};
table.insert(LookLock_FramesToCheckForMouse, {"BonusActionBarFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"BuffFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"CastingBarFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrame",1,7});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrame%iTab",1,7});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrame%iBottomButton",1,7});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrame%iDownButton",1,7});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrame%iUpButton",1,7});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrameMenuButton",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ChatFrameEditBox",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"CoinPickupFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ColorPickerFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"DialogBoxFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"DurabilityFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"GameTimeFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"GameTooltip",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ItemTextFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"MainMenuBar",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"MinimapCluster",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PartyFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PetActionBarFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PetFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PetitionFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PlayerFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"QuestTimerFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"TargetFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"UnitFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ZoneTextFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"SubZoneTextFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"AutoFollowStatus",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"SecondBar",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarKnob",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton1%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton2%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton3%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton4%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton5%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton6%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton7%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton8%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton9%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton10%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton11%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"PopBarButton12%02d",1,12});
table.insert(LookLock_FramesToCheckForMouse, {"ClockFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"CosmosTooltip",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"CombatStatsDataFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"CombatStatsFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"DPSPLUS_PlayerFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ItemBuffBar",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"ItemBuffButton",1,6});
table.insert(LookLock_FramesToCheckForMouse, {"KillCountFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"KillCountFrame2",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"InventoryManagerTooltip",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"MonitorStatus",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"MooBuffTooltip",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"MooBuffFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"MooBuffButton",0,23});
table.insert(LookLock_FramesToCheckForMouse, {"QuestTooltip",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"SideBar",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"SideBar2",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"TargetDistanceFrame",0,0});
table.insert(LookLock_FramesToCheckForMouse, {"TargetStatsTooltip",0,0});

function LookLock_TurnOrActionStart(arg1)
	LookLock_RightMouseDown = true;
	local doNorm = true;
	if (LookLockRemapOn == 1) then
		if ((LookLockAlwaysLook ~= 1)) then
			doNorm = false;
			if ( LookLockOn == 1 ) then
				if ( LookLockStrafeOn==1 ) then
					StrafeRightStart(arg1);
				else
					Sea.util.Hooks["TurnOrActionStop"].orig(arg1);
					LookLock_InTurn = nil;
				end
			else
				doNorm = true;
			end
		elseif ( LookLockOn == 1 ) then
			doNorm = true;
		end
	end
	
	if (doNorm) then
		LookLock_InTurn = true;
	end
	return doNorm;
end

function LookLock_TurnOrActionStop(arg1)
	LookLock_RightMouseDown = false;
	local doNorm = true;
	if (LookLockRemapOn == 1) then
		if (LookLockAlwaysLook ~= 1) then
			doNorm = false;
			if ( LookLockOn == 1 ) then
				if ( LookLockStrafeOn==1 ) then
					StrafeRightStop(arg1);
				else
					Sea.util.Hooks["TurnOrActionStart"].orig(arg1);
					doNorm = true;
					LookLock_InTurn = nil;
					LookLockOn = nil;
				end
			else
				doNorm = true;
			end
		elseif ( LookLockOn == 1 ) then
			doNorm = true;
		else
			if ((not LookLock_InTurn) and GameTooltip:IsVisible()) then
				Sea.util.Hooks["TurnOrActionStart"].orig(arg1);
				doNorm = true;
				LookLock_InTurn = nil;
			end
		end
	elseif (LookLockAlwaysLook ~= 1) then
		LookLockOn = 0;
	end
		
	if (doNorm) then
		LookLock_InTurn = nil;
	end
	return doNorm;
end

function LookLock_CameraOrSelectOrMoveStart(arg1)
	LookLock_LeftMouseDown = true;
	local doNorm = true;
	if (LookLockRemapOn == 1) then
		if (LookLockAlwaysLook ~= 1) then
			doNorm = false;
			if ( LookLockOn == 1 ) then
				if ( LookLockStrafeOn==1 ) then
					StrafeLeftStart(arg1);
				else
					Sea.util.Hooks["TurnOrActionStop"].orig(arg1);
					doNorm = true;
				end
			else
				doNorm = true;
			end
		elseif ( LookLockOn == 1 ) then
			doNorm = true;
		elseif ((LookLockAlwaysLook == 1) and (LookLock_InTurn)) then
			Sea.util.Hooks["TurnOrActionStop"].orig(arg1);
		end
	end

	return doNorm;
end

function LookLock_CameraOrSelectOrMoveStop(arg1)
	LookLock_LeftMouseDown = false;
	local doNorm = true;
	if (LookLockRemapOn == 1) then
		if (LookLockAlwaysLook ~= 1) then
			doNorm = false;
			if ( LookLockOn == 1 ) then
				if ( LookLockStrafeOn==1 ) then
					StrafeLeftStop(arg1);
				else
					Sea.util.Hooks["CameraOrSelectOrMoveStop"].orig(arg1);
					Sea.util.Hooks["TurnOrActionStart"].orig(arg1);
				end
			else
				doNorm = true;
			end
		elseif ( LookLockOn == 1 ) then
			doNorm = true;
		elseif ((LookLockAlwaysLook == 1) and (LookLock_InTurn)) then
			doNorm = false;
			Sea.util.Hooks["CameraOrSelectOrMoveStop"].orig(arg1);
			Sea.util.Hooks["TurnOrActionStart"].orig(arg1);
		end
	end
	
	return doNorm;
end

function LookLock_CheckFrames()
	local ret = false;
	for index in LookLock_FramesToCheck do
		local doCount = false;
		local curNum = LookLock_FramesToCheck[index][2];
		local maxNum = LookLock_FramesToCheck[index][3];
		if (curNum ~= maxNum) then
			doCount = true;
		end

		repeat
			local curFrameName = LookLock_FramesToCheck[index][1];
			if (doCount and (curNum <= maxNum)) then
				if (string.find(curFrameName, "%%")) then
					curFrameName = string.format(curFrameName, curNum);
				else
					curFrameName = curFrameName..curNum;
				end
				curNum = curNum + 1;
			end
			local curFrame = getglobal(curFrameName);
			if (curFrame and curFrame:IsVisible()) then
				ret = true;
			end
		until ((ret == true) or (curNum > maxNum) or (doCount == false))
		if (ret == true) then
			break;
		end
	end
	
	if (not ret) then
		for index in LookLock_FramesToCheckForMouse do
			local doCount = false;
			local curNum = LookLock_FramesToCheckForMouse[index][2];
			local maxNum = LookLock_FramesToCheckForMouse[index][3];
			if (curNum ~= maxNum) then
				doCount = true;
			end
	
			repeat
				local curFrameName = LookLock_FramesToCheckForMouse[index][1];
				if (doCount and (curNum <= maxNum)) then
					if (string.find(curFrameName, "%%")) then
						curFrameName = string.format(curFrameName, curNum);
					else
						curFrameName = curFrameName..curNum;
					end
					curNum = curNum + 1;
				end
				local curFrame = getglobal(curFrameName);
				if (curFrame and curFrame:IsVisible()) then
					local xPos, yPos = GetCursorPosition();
					local left = curFrame:GetLeft() * UIParent:GetScale();
					local right = curFrame:GetRight() * UIParent:GetScale();
					local top = curFrame:GetTop() * UIParent:GetScale();
					local bottom = curFrame:GetBottom() * UIParent:GetScale();
					if (xPos and yPos and left and right and top and bottom) then
						if (string.find(curFrameName, "ChatFrame")) then
							top = top + 20;
							left = left - 20;
							right = right + 10;
							bottom = bottom - 10;
						else
							top = top + LOOKLOCK_FLUFF;
							left = left - LOOKLOCK_FLUFF;
							right = right + LOOKLOCK_FLUFF;
							bottom = bottom - LOOKLOCK_FLUFF;
						end
						if ((xPos >= left) and (xPos <= right) and (yPos >= bottom) and (yPos <= top)) then
							ret = true;
						end
					end
				end
			until ((ret == true) or (curNum > maxNum) or (doCount == false))
			if (ret == true) then
				break;
			end
		end
	end
	
	return ret;
end

function LookLock_OnUpdate(elapsed)
	if ((LookLockAlwaysLook == 1) and LookLock_VarsLoaded) then
		LookLock_LastUpdate = LookLock_LastUpdate + elapsed;
		if (LookLock_LastUpdate >= LOOKLOCK_UPDATETIME) then 
			LookLock_LastUpdate = 0;
			
			if (not LookLockOn) then
				local frameStatus = LookLock_CheckFrames();
				if ((not LookLock_RightMouseDown) and (not LookLock_LeftMouseDown) and (not CursorHasItem()) and (not frameStatus)) then
					if (not LookLock_InTurn) then
						Sea.util.Hooks["TurnOrActionStart"].orig();
						LookLock_InTurn = true;
					end
				else
					if (LookLock_InTurn) then
						Sea.util.Hooks["TurnOrActionStop"].orig();
						LookLock_InTurn = nil;
					end
				end
			end
		end
	end
end

-- General Cosmos Registration Functions
function LookLock_RegisterCosmos()

	--
	-- Check for the functions before calling them. 
	--
	-- This will make it possible to keep the add-on
	-- independent of Cosmos Core
	-- 
	if ( Cosmos_RegisterConfiguration ) then 

		Cosmos_RegisterConfiguration(
			"COS_LOOKLOCK",
			"SECTION",
			LOOKLOCK_CONFIG_HEADER,
			LOOKLOCK_CONFIG_HEADER_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_LOOKLOCK_TOGGLE", -- CVAr
			"CHECKBOX",
			LOOKLOCK_CONFIG_REMAP_ONOFF,
			LOOKLOCK_CONFIG_REMAP_ONOFF_INFO,
			LookLock_Remap_Toggle,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_LOOKLOCK_STRAFE", -- CVAr
			"CHECKBOX",
			LOOKLOCK_CONFIG_STRAFE_ONOFF,
			LOOKLOCK_CONFIG_STRAFE_ONOFF_INFO,
			LookLock_Strafe_Toggle,
			0
			);
		Cosmos_RegisterConfiguration(
			"COS_LOOKLOCK_ALWAYS", -- CVAr
			"CHECKBOX",
			LOOKLOCK_CONFIG_ALWAYS_ONOFF,
			LOOKLOCK_CONFIG_ALWAYS_ONOFF_INFO,
			LookLock_Always_Toggle,
			0
			);
			
		local LookLockCommands = {"/looklock","/ll"};
		Cosmos_RegisterChatCommand (
			"LOOKLOCK_COMMANDS", -- Some Unique Group ID
			LookLockCommands, -- The Commands
			LookLock_ChatCommandHandler,
			LOOKLOCK_CHAT_COMMAND_INFO -- Description String
		);
	else
		SlashCmdList["LOOKLOCKSLASH"] = LookLock_ChatCommandHandler;
		SLASH_LOOKLOCKSLASH1 = "/looklock";
		SLASH_LOOKLOCKSLASH2 = "/ll";
	end
end

-- LookLock command handler
function LookLock_ChatCommandHandler(msg)
	if (msg) then
		msg = string.lower(msg);
		local command, setStr = unpack(Sea.string.split(msg, " "));
		if ((not command) and msg) then
			command = msg;
		end
		if (command) then
			for curCommand in LookLock_ChatHandlers do
				if (command == curCommand) then
					LookLock_ChatHandlers[curCommand](setStr);
					return;
				end
			end
		end
	end
	for i = 1, getn(LOOKLOCK_CHAT_COMMAND_HELP) do
		Sea.io.printc(ChatTypeInfo["SYSTEM"], LOOKLOCK_CHAT_COMMAND_HELP[i]);
	end
end

-- LookLock command handler
function LookLock_Remap_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if (string.find(msg, 'on')) then
		LookLock_Remap_Toggle(1);
	else
		if (string.find(msg, 'off')) then
			LookLock_Remap_Toggle(0);
		else
			LookLock_Remap_Toggle(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_LOOKLOCK_TOGGLE", CSM_CHECKONOFF, LookLockRemapOn);
	end
end
LookLock_ChatHandlers["remap"] = LookLock_Remap_ChatCommandHandler;

-- LookLock command handler
function LookLock_Strafe_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if (string.find(msg, 'on')) then
		LookLock_Strafe_Toggle(1);
	else
		if (string.find(msg, 'off')) then
			LookLock_Strafe_Toggle(0);
		else
			LookLock_Strafe_Toggle(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_LOOKLOCK_STRAFE", CSM_CHECKONOFF, LookLockStrafeOn);
	end
end
LookLock_ChatHandlers["strafe"] = LookLock_Strafe_ChatCommandHandler;

-- LookLock command handler
function LookLock_Always_ChatCommandHandler(msg)
	if (not msg) then
		msg = "-1";
	end
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if (string.find(msg, 'on')) then
		LookLock_Always_Toggle(1);
	else
		if (string.find(msg, 'off')) then
			LookLock_Always_Toggle(0);
		else
			LookLock_Always_Toggle(-1);
		end
	end
	if(Cosmos_RegisterConfiguration) then
		Cosmos_UpdateValue("COS_LOOKLOCK_ALWAYS", CSM_CHECKONOFF, LookLockAlwaysLook);
	end
end
LookLock_ChatHandlers["always"] = LookLock_Always_ChatCommandHandler;

-- LookLock command handler
function LookLock_Fix_ChatCommandHandler(msg)
	LookLock_FixMouse();
end
LookLock_ChatHandlers["fix"] = LookLock_Fix_ChatCommandHandler;

-- Remaps the mouse buttons to their normal states and save the bindings
function LookLock_CheckMouse()
	local leftButton = GetBindingAction("BUTTON1");
	local rightButton = GetBindingAction("BUTTON2");
	
	local changed = false;
	if (rightButton == "LOOKLOCKACTION") then
		SetBinding("BUTTON2","TURNORACTION");
		changed = true;
	end
	if (leftButton == "LOOKLOCKCAMERA") then
		SetBinding("BUTTON1","CAMERAORSELECTORMOVE");
		changed = true;
	end
	
	if (changed) then
		SaveBindings();
		Sea.io.printc(ChatTypeInfo["SYSTEM"], LOOKLOCK_CHAT_FIX_DONE);
	end
end

-- Remaps the mouse buttons to their normal states and save the bindings
function LookLock_FixMouse()	
	SetBinding("BUTTON2","TURNORACTION");
	SetBinding("BUTTON1","CAMERAORSELECTORMOVE");
	SaveBindings();
	
	Sea.io.printc(ChatTypeInfo["SYSTEM"], LOOKLOCK_CHAT_FIX_DONE);
end

-- Enable/Disable Remapping the mouse buttons
function LookLock_Remap_Toggle(toggle) 
	local dotoggle = 0;
	if ( toggle == -1 ) then 
		if (LookLockRemapOn == 1) then
			dotoggle = 0;
		else
			dotoggle = 1;
		end
	else
		dotoggle = toggle;
	end
	LookLockRemapOn = dotoggle;
	local msg = LOOKLOCK_CHAT_REMAP_ON;
	if ( dotoggle == 0 ) then 
		msg = LOOKLOCK_CHAT_REMAP_OFF;
	end
	
	if ( Cosmos_RegisterConfiguration == nil ) then 
		RegisterForSave("LookLockRemapOn");	
    	Sea.io.printc(ChatTypeInfo["SYSTEM"], msg);
	end
end

-- Enable/Disable strafe with mouse buttons
function LookLock_Strafe_Toggle(toggle) 
	local dotoggle = 0;
	if ( toggle == -1 ) then 
		if (LookLockStrafeOn == 1) then
			dotoggle = 0;
		else
			dotoggle = 1;
		end
	else
		dotoggle = toggle;
	end
	LookLockStrafeOn = dotoggle;
	local msg = LOOKLOCK_CHAT_STRAFE_ON;
	if ( dotoggle == 0 ) then 
		msg = LOOKLOCK_CHAT_STRAFE_OFF;
	end
	
	if ( Cosmos_RegisterConfiguration == nil ) then 
		RegisterForSave("LookLockStrafeOn");	
    	Sea.io.printc(ChatTypeInfo["SYSTEM"], msg);
	end
end

-- Enable/Disable Always Look
function LookLock_Always_Toggle(toggle) 
	local dotoggle = 0;
	if ( toggle == -1 ) then 
		if (LookLockAlwaysLook == 1) then
			dotoggle = 0;
			LookLock_InTurn = nil;
			LookLock_RightMouseDown = false;
			LookLock_LeftMouseDown = false;
			LookLockOn = nil;
			Sea.util.Hooks["TurnOrActionStop"].orig(arg1);
		else
			dotoggle = 1;
		end
	else
		dotoggle = toggle;
	end
	LookLockAlwaysLook = dotoggle;
	local msg = LOOKLOCK_CHAT_ALWAYS_ON;
	if ( dotoggle == 0 ) then 
		msg = LOOKLOCK_CHAT_ALWAYS_OFF;
	end
	
	if ( Cosmos_RegisterConfiguration == nil ) then 
		RegisterForSave("LookLockAlwaysLook");
    	Sea.io.printc(ChatTypeInfo["SYSTEM"], msg);
	end
end

-- OnFoo Functions
function LookLock_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UPDATE_BINDINGS");
	
	Sea.util.hook("TurnOrActionStart", "LookLock_TurnOrActionStart", "replace");
	Sea.util.hook("TurnOrActionStop", "LookLock_TurnOrActionStop", "replace");
	Sea.util.hook("CameraOrSelectOrMoveStart", "LookLock_CameraOrSelectOrMoveStart", "replace");
	Sea.util.hook("CameraOrSelectOrMoveStop", "LookLock_CameraOrSelectOrMoveStop", "replace");
	
	LookLock_RegisterCosmos();
end

-- Catches the OnEvent message to handle remaping the mouse buttons after the keys are bound normally.
function LookLock_OnEvent()
	if (event == "UPDATE_BINDINGS") then
		LookLock_CheckMouse();
	end
	if (event == "VARIABLES_LOADED") then
		LookLock_VarsLoaded = true;
	end
end
