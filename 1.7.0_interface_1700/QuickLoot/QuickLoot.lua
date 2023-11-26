--[[

	QuickLoot: easier, faster looting
		copyright 2004 by Telo

	- Automatically positions the most relevant part of the loot window under your cursor

	- Patched to only use one SavedVariable
	- Khaos compatible.
	
]] 

--------------------------------------------------------------------------------------------------
-- Configuration variables
--------------------------------------------------------------------------------------------------

QuickLoot_Options_Default = {
	enable = true;
	autoHide = true;
	onScreen = false;
	moveOnce = false;
};

QuickLoot_Options = {
};

QuickLoot_KhaosToCosmos = {
	enable = "COS_QUICKLOOT_ONOFF";
	autoHide = "COS_QUICKLOOT_HIDE";
	onScreen = "COS_QUICKLOOT_ONSCREEN";
	moveOnce = "COS_QUICKLOOT_MOVE_ONCE";
};

QUICKLOOT_KHAOS_SET_EASY_ID = "QuickLootEasy";


QuickLoot_AutoHide = nil;	-- set to 1 if you want the window to auto-hide when there's no loot
QuickLoot_OnScreen = nil;	-- set to 1 if you want the window to remain completly on screen
QuickLoot_MoveOnce = nil;	-- set to 1 if you want the window to only move once

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local originalLootFrame_Update;

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

-- Basically, what this function does is ensure that the LootFrame window is not placed outside the screen
local function LootFrame_SetLootFramePoint(x, y)
	if (QuickLoot_OnScreen) then
		local screenWidth = GetScreenWidth();
		if (UIParent:GetWidth() > screenWidth) then
			screenWidth = UIParent:GetWidth();
		end
		local screenHeight = GetScreenHeight();
		
		-- LootFrame is set to 256 wide in the xml file, but is actually only 191 wide
		-- This is based on calculation envolving the offset on the close button:
		-- The height is always 256, which is the correct number.
		local windowWidth = 191;
		local windowHeight = 256;
		
		if ( (x + windowWidth) > screenWidth ) then
			x = screenWidth - windowWidth;
		end
		if ( y > screenHeight ) then
			y = screenHeight;
		end
		if ( x < 0 ) then
			x = 0;
		end
		if ( (y - windowHeight) < 0 ) then
			y = windowHeight;
		end
		--Print("wWith: "..windowWidth..", wHeight: "..windowHeight..", X: "..x..", Y: "..y..", sWidth: "..screenWidth..", sHeight: "..screenHeight);
	end
	
	LootFrame:ClearAllPoints();
	LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
end

function LootFrame_ItemUnderCursor()
	if ( ( not QuickLoot_Options.enable ) or (LootFrame_IsRespawning) ) then return; end
	local index;
	local x, y = GetCursorPosition();
	local scale = LootFrame:GetScale();

	x = x / scale;
	y = y / scale;

	for index = 1, LOOTFRAME_NUMBUTTONS, 1 do
		local button = getglobal("LootButton"..index);
		if( button:IsVisible() ) then
			x = x - 42;
			y = y + 56 + (40 * index);
			-- LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
			LootFrame_SetLootFramePoint(x, y);
			return;
		end
	end

	if( LootFrameDownButton:IsVisible() ) then
		-- If down arrow, position on it
		x = x - 158;
		y = y + 223;
	else
		-- Otherwise, position on close box
		x = x - 173;
		y = y + 25;
	end
	
	--LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
	LootFrame_SetLootFramePoint(x, y);
end

function QuickLoot_LootFrame_OnHide()
	if (not LootFrame_IsRespawning) then
		CloseLoot();
	end
end

function QuickLoot_LootFrame_OnShow()
	if (not LootFrame_IsRespawning) then
		this.numLootItems = GetNumLootItems();
		LootFrame_Update();
		LootFramePortraitOverlay:SetTexture("Interface\\TargetingFrame\\TargetDead");
		if( this.numLootItems == 0 ) then
			PlaySound("LOOTWINDOWOPENEMPTY");
		elseif( IsFishingLoot() ) then
			PlaySound("FISHING REEL IN");
			LootFramePortraitOverlay:SetTexture("Interface\\LootFrame\\FishingLoot-Icon");
		end
	end
end

function QuickLoot_OnEvent()
	if ( event == "LOOT_SLOT_CLEARED" ) then
		if ( QuickLoot_Options.enable ) and ( not QuickLoot_Options.moveOnce ) then
			LootFrame_ItemUnderCursor();
		end
		return;
	end
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in QuickLoot_Options_Default do
			if ( QuickLoot_Options[k] == nil ) then
				QuickLoot_Options[k] = v;
			end
		end
		return;
	end
	if ( event == "LOOT_OPENED" ) then
		local lootItems = LootFrame.numLootItems;
		if ( lootItems == 0 ) then
			if( QuickLoot_Options.autoHide ) then
				CloseLoot();
				local info = ChatTypeInfo["LOOT"];
				ChatFrame1:AddMessage(ERR_LOOT_NONE, info.r, info.g, info.b, info.id);
			end
		elseif ( QuickLoot_Options.enable ) then
			LootFrame_ItemUnderCursor();
		end

		if ( ( not QuickLoot_Options.autoHide ) or ( lootItems > 0 ) ) then
			--Make sure LootFrame is above all bags.
			local lootLevel = LootFrame:GetFrameLevel();
			local highestLevel = lootLevel;
			--Go through all the bags and it's children, and find the highest level frame
			for curBag = 1, 17 do
				local curLevel = getglobal("ContainerFrame"..curBag):GetFrameLevel();
				if (curLevel > highestLevel) then
					highestLevel = curLevel;
				end
				local curItemLevel = getglobal("ContainerFrame"..curBag.."PortraitButton"):GetFrameLevel();
				if (curItemLevel > highestLevel) then
					highestLevel = curItemLevel;
				end
				for curBut = 1, 20 do
					curItemLevel = getglobal("ContainerFrame"..curBag.."Item"..curBut):GetFrameLevel();
					if (curItemLevel > highestLevel) then
						highestLevel = curItemLevel;
					end
				end
			end
			--If we found a higher level frame, then move the Loot Frame above it
			if (highestLevel > lootLevel) then
				local levelChange = (highestLevel - lootLevel) + 1;
				LootFrame:SetFrameLevel(lootLevel + levelChange);
				--Simply moving the frame itself isn't enough, we have to move it's children too
				local lootList = {
					"LootCloseButton";
					"LootButton1";
					"LootButton2";
					"LootButton3";
					"LootButton4";
					"LootFrameUpButton";
					"LootFrameDownButton";
				};
				for curLoot in lootList do
					local curLootFrame = getglobal(lootList[curLoot]);
					curLootFrame:SetFrameLevel(curLootFrame:GetFrameLevel() + levelChange);
				end
				--And then to get the moved changes to truely work, and not just look like they
				--are on top, we need to hide and show the frame, but need to do so without all
				--the normal hiding and showing events occuring, so we set IsRespawning to true
				--so the other functions know to not do their stuff.
				LootFrame_IsRespawning = true;
				LootFrame:Hide();
				LootFrame:Show();
				LootFrame_IsRespawning = nil;
			end
		end
		return;
	end
end


local function QuickLoot_LootFrame_Update()
	originalLootFrame_Update();
	if ( not QuickLoot_Options.moveOnce ) then
		LootFrame_ItemUnderCursor();
	end
end


function QuickLoot_Register_Khaos()
	if ( not Khaos ) then
		return false;
	end
	local optionSetEasy = {
		id = QUICKLOOT_KHAOS_SET_EASY_ID;
		text = COSMOS_CONFIG_QLOOT_HEADER;
		helptext = COSMOS_CONFIG_QLOOT_HEADER_INFO;
		difficulty = 1;
		options = {};
		default = true;
		commands = {
						{
							id="QuickLootSlashCommand";
							helpText=QUICKLOOT_CHAT_COMMAND_INFO;
							commands = QUICKLOOT_COMMANDS;
							parseTree = {
								[1] = {
									callback = function ( msg ) 
										if ( not msg or msg == "" ) then
											Sea.io.print(QUICKLOOT_CHAT_COMMAND_USAGE);
										end
									end;
								};
								[QUICKLOOT_COMMANDS_ENABLE] = {
									default = {
										key="enable";
										valueMap = {
											checked="!";	
										}
									};
									[QUICKLOOT_COMMANDS_TRUE] = {
										[1] = {
											key="enable";
											valueMap = {
												checked=true;	
											}
										}
									};
									[QUICKLOOT_COMMANDS_FALSE] = {
										[1] = {
											key="enable";
											valueMap = {
												checked=false;	
											}
										}
									};
								};
								[QUICKLOOT_COMMANDS_AUTOHIDE] = {
									default = {
										key="autoHide";
										valueMap = {
											checked="!";	
										}
									};
									[QUICKLOOT_COMMANDS_TRUE] = {
										[1] = {
											key="autoHide";
											valueMap = {
												checked=true;
											}
										}
									};
									[QUICKLOOT_COMMANDS_FALSE] = {
										[1] = {
											key="autoHide";
											valueMap = {
												checked=false;	
											}
										}
									};
								};
								[QUICKLOOT_COMMANDS_ONSCREEN] = {
									default = {
										key="OnScreen";
										valueMap = { checked="!"; }
									};
									[QUICKLOOT_COMMANDS_TRUE] = {
										[1] = {
											key="onScreen";
											valueMap = {
												checked=true;	
											}										
										}
									};
									[QUICKLOOT_COMMANDS_FALSE] = {
										[1] = {
											key="onScreen";
											valueMap = {
												checked=false;	
											}
										}
									};
								};
								[QUICKLOOT_COMMANDS_MOVEONCE] = {
									default = {
										key="MoveOnce";
										valueMap = { checked="!"; }
									};
									[QUICKLOOT_COMMANDS_TRUE] = {
										[1] = {
											key="moveOnce";
											valueMap = {
												checked=true;
											}
										}
									};
									[QUICKLOOT_COMMANDS_FALSE] = {
										[1] = {
											key="moveOnce";
											valueMap = {
												checked=false;	
											}										
										};
									};
								};
							};
						}
		};
	};
	local optionEnabled = {
		id = "quickLootEnable";
		key = "enable";
		text = COSMOS_CONFIG_QLOOT;
		helptext = COSMOS_CONFIG_QLOOT_INFO;
		check = true;
		callback = function(state) QuickLoot_Options.enable = state.checked; QuickLoot_SetVariable(QuickLoot_OptionValue_Cosmos("enable"), "enable"); end;
		type = K_TEXT;
		feedback = function(state) QuickLoot_GetTextState(state.checked, QUICKLOOT_CHAT_COMMAND_ENABLE); end;
		default = {
			checked = true;
		};
		disabled = {
			checked = false;
		};
	};
	table.insert(optionSetEasy.options, optionEnabled);
	local optionAutoHide = {
		id = "quickLootAutoHide";
		key = "autoHide";
		text = COSMOS_CONFIG_QLOOT_HIDE;
		helptext = COSMOS_CONFIG_QLOOT_HIDE_INFO;
		check = true;
		callback = function(state) QuickLoot_Options.autoHide = state.checked; QuickLoot_SetVariable(QuickLoot_OptionValue_Cosmos("autoHide"), "autoHide"); end;
		type = K_TEXT;
		feedback = function(state) QuickLoot_GetTextState(state.checked, QUICKLOOT_CHAT_COMMAND_HIDE); end;
		default = {
			checked = true;
		};
		disabled = {
			checked = false;
		};
	};
	table.insert(optionSetEasy.options, optionAutoHide);
	local optionOnScreen = {
		id = "quickLootOnScreen";
		key = "onScreen";
		text = COSMOS_CONFIG_QLOOT_ONSCREEN;
		helptext = COSMOS_CONFIG_QLOOT_ONSCREEN_INFO;
		check = true;
		callback = function(state) QuickLoot_Options.onScreen = state.checked; QuickLoot_SetVariable(QuickLoot_OptionValue_Cosmos("onScreen"), "onScreen"); end;
		type = K_TEXT;
		feedback = function(state) QuickLoot_GetTextState(state.checked, QUICKLOOT_CHAT_COMMAND_ONSCREEN); end;
		default = {
			checked = false;
		};
		disabled = {
			checked = false;
		};
	};
	table.insert(optionSetEasy.options, optionOnScreen);
	local optionMoveOnce = {
		id = "quickLootMoveOnce";
		key = "moveOnce";
		text = COSMOS_CONFIG_QLOOT_MOVE_ONCE;
		helptext = COSMOS_CONFIG_QLOOT_MOVE_ONCE_INFO;
		check = true;
		callback = function(state) QuickLoot_Options.moveOnce = state.checked; QuickLoot_SetVariable(QuickLoot_OptionValue_Cosmos("moveOnce"), "moveOnce"); end;
		type = K_TEXT;
		feedback = function(state) QuickLoot_GetTextState(state.checked, QUICKLOOT_CHAT_COMMAND_MOVE_ONCE); end;
		default = {
			checked = false;
		};
		disabled = {
			checked = false;
		};
	};
	table.insert(optionSetEasy.options, optionMoveOnce);
	Khaos.registerOptionSet( "inventory", optionSetEasy);
	return true;
end

QuickLoot_Set = {};

function QuickLoot_SetVariable(toggle, name)
	if ( not name ) then
		return;
	end
	if ( QuickLoot_Set[name] ) then
		return;
	end
	QuickLoot_Set[name] = true;
	if ( toggle == 1 ) then
		QuickLoot_Options[name] = true;
	else
		QuickLoot_Options[name] = false;
	end
	if ( Khaos ) then
		local setId = QUICKLOOT_KHAOS_SET_EASY_ID;
		local key = name;
		local khaosKey = Khaos.getSetKey(setId, key);
		if ( khaosKey ) then
			Khaos.setSetKeyParameter(setId, key, "checked", QuickLoot_Options[name]);
			if ( Khaos.updateOptionSet ) then
				Khaos.updateOptionSet(setId);
			end
			if KhaosFrame:IsVisible() then
				Khaos.refresh(false, false, true);
			end
		end
	end
	if ( Cosmos_UpdateValue ) then
		local cosName = QuickLoot_KhaosToCosmos[name];
		if ( ( name ) and ( strlen(name) > 0 ) ) then
			Cosmos_UpdateValue(name, CSM_CHECKONOFF, toggle);
		end
		if ( CosmosMaster_DrawData ) then
			CosmosMaster_DrawData();
		end
	end
	QuickLoot_Set[name] = false;
end

function QuickLoot_OptionValue_Cosmos(name)
	if ( not name ) then
		return -1;
	end
	if ( QuickLoot_Options[name] ) then
		return 1;
	else
		return 0;
	end
end


function QuickLoot_GetTextState(enabled, text)
	local s = QUICKLOOT_CHAT_STATE_ENABLED; 
	if ( not enabled ) then 
		s = QUICKLOOT_CHAT_STATE_DISABLED; 
	end 
	if ( not text ) then
		text = QUICKLOOT_KHAOS_OPTION_STATE_TEXT;
	end
	return QUICKLOOT_KHAOS_OPTION_STATE_TEXT..s;
end





function QuickLoot_RegisterCosmos()
	if ( Cosmos_RegisterConfiguration ) then
		if ( ( not QuickLoot_RegisteredWithCosmos ) or ( QuickLoot_RegisteredWithCosmos ~= 1 ) ) then
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT",
				"SECTION",
				COSMOS_CONFIG_QLOOT_HEADER,
				COSMOS_CONFIG_QLOOT_HEADER_INFO
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_HEADER",
				"SEPARATOR",
				COSMOS_CONFIG_QLOOT_HEADER,
				COSMOS_CONFIG_QLOOT_HEADER_INFO
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_ONOFF",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT),
				TEXT(COSMOS_CONFIG_QLOOT_INFO),
				QuickLoot_Enable,
				QuickLoot_OptionValue_Cosmos("enable")
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_HIDE",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT_HIDE),
				TEXT(COSMOS_CONFIG_QLOOT_HIDE_INFO),
				QuickLoot_Hide_Enable,
				QuickLoot_OptionValue_Cosmos("autoHide")
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_ONSCREEN",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT_ONSCREEN),
				TEXT(COSMOS_CONFIG_QLOOT_ONSCREEN_INFO),
				QuickLoot_OnScreen_Enable,
				QuickLoot_OptionValue_Cosmos("onScreen")
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_MOVE_ONCE",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT_MOVE_ONCE),
				TEXT(COSMOS_CONFIG_QLOOT_MOVE_ONCE_INFO),
				QuickLoot_MoveOnce_Enable,
				QuickLoot_OptionValue_Cosmos("moveOnce")
			);
			if ( Cosmos_RegisterChatCommand ) then
				local QuickLootCommands = {"/quickloot","/ql"};
				Cosmos_RegisterChatCommand (
					"QUICKLOOT_COMMANDS", -- Some Unique Group ID
					QuickLootCommands, -- The Commands
					QuickLoot_ChatCommandHandler,
					QUICKLOOT_CHAT_COMMAND_INFO -- Description String
				);
			end
			QuickLoot_RegisteredWithCosmos = 1;
		end
		return true;
	else 
		return false;
	end
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------
function QuickLoot_OnLoad()
	this:RegisterEvent("LOOT_SLOT_CLEARED");
	this:RegisterEvent("LOOT_OPENED");
	this:RegisterEvent("VARIABLES_LOADED");

	-- Hook the LootFrame_Update function
	originalLootFrame_Update = LootFrame_Update;
	LootFrame_Update = QuickLoot_LootFrame_Update;
	
	-- Hook the LootFrame_Show and Hide functions
	originalLootFrame_OnShow = LootFrame_OnShow;
	LootFrame_OnShow = QuickLoot_LootFrame_OnShow;
	originalLootFrame_OnHide = LootFrame_OnHide;
	LootFrame_OnHide = QuickLoot_LootFrame_OnHide;

	if ( QuickLoot_Register_Khaos() ) then 
	
	elseif ( not QuickLoot_RegisterCosmos() ) then
		SlashCmdList["QUICKLOOTSLASH"] = QuickLoot_ChatCommandHandler;
		SLASH_QUICKLOOTSLASH1 = "/quickloot";
		SLASH_QUICKLOOTSLASH1 = "/ql";
		
		QuickLoot_Print(QLOOT_LOADED);
		UIErrorsFrame:AddMessage(QLOOT_LOADED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);		
	end
end

function QuickLoot_Enable(toggle) 
	QuickLoot_SetVariable(toggle, "enable");
end

function QuickLoot_Hide_Enable(toggle) 
	QuickLoot_SetVariable(toggle, "autoHide");
end

function QuickLoot_OnScreen_Enable(toggle) 
	QuickLoot_SetVariable(toggle, "onScreen");
end

function QuickLoot_MoveOnce_Enable(toggle)
	QuickLoot_SetVariable(toggle, "moveOnce");
end

function QuickLoot_ChatCommandHandler(msg)
	if ( ( not msg ) or ( strlen(msg) <= 0) ) then
		QuickLoot_Print(QUICKLOOT_CHAT_COMMAND_USAGE);
		return
	end
	local command = string.lower(msg);
	local varName = nil;
	local varText = nil;
	if ( command == "enable" ) then
		varName = "enable";
		varText = QUICKLOOT_CHAT_COMMAND_ENABLE;
	elseif ( command == "autohide" ) then
		varName = "autoHide";
		varText = QUICKLOOT_CHAT_COMMAND_HIDE;
	elseif ( command == "onscreen" ) then
		varName = "QuickLoot_OnScreen";
		varText = QUICKLOOT_CHAT_COMMAND_ONSCREEN;
	elseif ( strfind(command, "once") ) then
		varName = "moveOnce";
		varText = QUICKLOOT_CHAT_COMMAND_MOVE_ONCE;
	end
	if ( varName ) then
		local oldValue = getglobal(varName);
		local newValue = nil;
		if ( ( not curValue ) or ( curValue == 0 ) ) then
			newValue = 1;
		else
			newValue = 0;
		end
		if ( newValue == 1 ) then
			QuickLoot_SetVariable(1, varName);
			if ( varText ) then
				QuickLoot_Print(varText..QUICKLOOT_CHAT_STATE_ENABLED);
			end
		else
			QuickLoot_SetVariable(0, varName);
			if ( varText ) then
				QuickLoot_Print(varText..QUICKLOOT_CHAT_STATE_DISABLED);
			end
		end
	else
		QuickLoot_Print(QUICKLOOT_CHAT_COMMAND_USAGE);
		return
	end
end

function QuickLoot_Print(msg) 
	if ( ( msg ) and ( strlen(msg) > 0 ) ) then
		if( Print ) then
			Print(msg);
			return;
		end
		if ( DEFAULT_CHAT_FRAME ) then
			DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
		end
	end
end

