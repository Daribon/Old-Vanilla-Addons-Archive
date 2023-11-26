--[[

	QuickLoot: easier, faster looting
		copyright 2004 by Telo

	- Automatically positions the most relevant part of the loot window under your cursor
	
]]

--------------------------------------------------------------------------------------------------
-- Configuration variables
--------------------------------------------------------------------------------------------------

QuickLoot_AutoHide = nil;	-- set to 1 if you want the window to auto-hide when there's no loot
QuickLoot_OnScreen = nil;	-- set to 1 if you want the window to remain completly on screen
QuickLoot_MoveOnce = nil;	-- set to 1 if you want the window to only move once

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local originalLootFrame_OnEvent;
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
	if ( QuickLoot_Enabled ~= 1 ) then return; end
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

local function QuickLoot_LootFrame_OnEvent(event)
	originalLootFrame_OnEvent(event);
	if ( event == "LOOT_SLOT_CLEARED" ) then
		if ( QuickLoot_MoveOnce ~= 1 ) then
			LootFrame_ItemUnderCursor();
		end
	end
	if ( event == "LOOT_OPENED" ) then
		local lootItems = GetNumLootItems();
		if ( lootItems == 0 ) then
			if( QuickLoot_AutoHide ) then
				CloseLoot();
				local info = ChatTypeInfo["LOOT"];
	    		ChatFrame1:AddMessage(ERR_LOOT_NONE, info.r, info.g, info.b, info.id);
			end
		elseif ( QuickLoot_MoveOnce == 1 ) then
			LootFrame_ItemUnderCursor();
		end
	end
end

local function QuickLoot_LootFrame_Update()
	originalLootFrame_Update();
	if ( QuickLoot_MoveOnce ~= 1 ) then
		LootFrame_ItemUnderCursor();
	end
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
				1
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_HIDE",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT_HIDE),
				TEXT(COSMOS_CONFIG_QLOOT_HIDE_INFO),
				QuickLoot_Hide_Enable,
				1
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_ONSCREEN",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT_ONSCREEN),
				TEXT(COSMOS_CONFIG_QLOOT_ONSCREEN_INFO),
				QuickLoot_OnScreen_Enable,
				1
			);
			Cosmos_RegisterConfiguration(
				"COS_QUICKLOOT_MOVE_ONCE",
				"CHECKBOX", 
				TEXT(COSMOS_CONFIG_QLOOT_MOVE_ONCE),
				TEXT(COSMOS_CONFIG_QLOOT_MOVE_ONCE_INFO),
				QuickLoot_MoveOnce_Enable,
				0
			);
			if ( Cosmos_RegisterChatCommand ) then
				local QuickLootCommands = {"/quickloot"};
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

	-- Hook the LootFrame_OnEvent function
	originalLootFrame_OnEvent = LootFrame_OnEvent;
	LootFrame_OnEvent = QuickLoot_LootFrame_OnEvent;
	
	-- Hook the LootFrame_Update function
	originalLootFrame_Update = LootFrame_Update;
	LootFrame_Update = QuickLoot_LootFrame_Update;

	if ( not QuickLoot_RegisterCosmos() ) then
		SlashCmdList["QUICKLOOTSLASH"] = QuickLoot_ChatCommandHandler;
		SLASH_QUICKLOOTSLASH1 = "/quickloot";
		
		RegisterForSave("QuickLoot_Enabled");
		RegisterForSave("QuickLoot_AutoHide");
		RegisterForSave("QuickLoot_OnScreen");
		RegisterForSave("QuickLoot_MoveOnce");
		
		QuickLoot_Print(QLOOT_LOADED);
		UIErrorsFrame:AddMessage(QLOOT_LOADED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);		
	end
end

function QuickLoot_Enable(toggle) 
	if ( toggle == 1 ) then 
		QuickLoot_Enabled = 1;
	else 
		QuickLoot_Enabled = 0;
	end
end

function QuickLoot_Hide_Enable(toggle) 
	if ( toggle == 1 ) then 
		QuickLoot_AutoHide = 1;
	else 
		QuickLoot_AutoHide = nil;
	end
end

function QuickLoot_OnScreen_Enable(toggle) 
	if ( toggle == 1 ) then 
		QuickLoot_OnScreen = 1;
	else 
		QuickLoot_OnScreen = nil;
	end
end

function QuickLoot_MoveOnce_Enable(toggle)
	if ( toggle == 1 ) then 
		QuickLoot_MoveOnce = 1;
	else 
		QuickLoot_MoveOnce = nil;
	end
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
		varName = "QuickLoot_Enabled";
		varText = QUICKLOOT_CHAT_COMMAND_ENABLE;
	elseif ( command == "autohide" ) then
		varName = "QuickLoot_AutoHide";
		varText = QUICKLOOT_CHAT_COMMAND_HIDE;
	elseif ( command == "onscreen" ) then
		varName = "QuickLoot_OnScreen";
		varText = QUICKLOOT_CHAT_COMMAND_ONSCREEN;
	elseif ( strfind(command, "once") ) then
		varName = "QuickLoot_MoveOnce";
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
			setglobal(varName, 1);
			if ( varText ) then
				QuickLoot_Print(varText..QUICKLOOT_CHAT_STATE_ENABLED);
			end
		else
			setglobal(varName, nil);
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

