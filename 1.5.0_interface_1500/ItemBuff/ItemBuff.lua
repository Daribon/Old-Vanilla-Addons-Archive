--[[

	ItemBuff: A simple mechanism for monitoring item buffs
		copyright 2004 by Telo
	
	- Automatically displays up to six timed item buffs onscreen in a small movable window
	
]]

--------------------------------------------------------------------------------------------------
-- Localizable strings
--------------------------------------------------------------------------------------------------

ITEMBUFF_HELP = "help";				-- must be lowercase; displays help
ITEMBUFF_STATUS = "status";			-- must be lowercase; shows status
ITEMBUFF_FREEZE = "freeze";			-- must be lowercase; freezes the window in position
ITEMBUFF_UNFREEZE = "unfreeze";		-- must be lowercase; unfreezes the window so that it can be dragged
ITEMBUFF_RESET = "reset";			-- must be lowercase; resets the window to its default position

ITEMBUFF_STATUS_HEADER = "|cffffff00ItemBuff status:|r";
ITEMBUFF_FROZEN = "ItemBuff: frozen in place";
ITEMBUFF_UNFROZEN = "ItemBuff: unfrozen and can be dragged";
ITEMBUFF_RESET_DONE = "ItemBuff: position reset to default";

ITEMBUFF_HELP_TEXT0 = " ";
ITEMBUFF_HELP_TEXT1 = "|cffffff00ItemBuff command help:|r";
ITEMBUFF_HELP_TEXT2 = "|cff00ff00Use |r|cffffffff/itembuff <command>|r|cff00ff00 or |r|cffffffff/ib <command>|r|cff00ff00 to perform the following commands:|r";
ITEMBUFF_HELP_TEXT3 = "|cffffffff"..ITEMBUFF_HELP.."|r|cff00ff00: displays this message.|r";
ITEMBUFF_HELP_TEXT4 = "|cffffffff"..ITEMBUFF_STATUS.."|r|cff00ff00: displays status information about the current option settings.|r";
ITEMBUFF_HELP_TEXT5 = "|cffffffff"..ITEMBUFF_FREEZE.."|r|cff00ff00: freezes the window so that it can't be dragged.|r";
ITEMBUFF_HELP_TEXT6 = "|cffffffff"..ITEMBUFF_UNFREEZE.."|r|cff00ff00: unfreezes the window so that it can be dragged.|r";
ITEMBUFF_HELP_TEXT7 = "|cffffffff"..ITEMBUFF_RESET.."|r|cff00ff00: resets the window to its default position.|r";
ITEMBUFF_HELP_TEXT8 = " ";
ITEMBUFF_HELP_TEXT9 = "|cff00ff00For example: |r|cffffffff/itembuff freeze|r|cff00ff00 will prevent the window from being dragged with the mouse.|r";

ITEMBUFF_HELP_TEXT = {
	ITEMBUFF_HELP_TEXT0,
	ITEMBUFF_HELP_TEXT1,
	ITEMBUFF_HELP_TEXT2,
	ITEMBUFF_HELP_TEXT3,
	ITEMBUFF_HELP_TEXT4,
	ITEMBUFF_HELP_TEXT5,
	ITEMBUFF_HELP_TEXT6,
	ITEMBUFF_HELP_TEXT7,
	ITEMBUFF_HELP_TEXT8,
	ITEMBUFF_HELP_TEXT9,
};

--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

-- Function hooks
local lOriginal_GameTooltip_ClearMoney;

local lInventorySlots = {
	{ name = "HeadSlot" },
	{ name = "NeckSlot" },
	{ name = "ShoulderSlot" },
	{ name = "BackSlot" },
	{ name = "ChestSlot" },
	{ name = "ShirtSlot" },
	{ name = "TabardSlot" },
	{ name = "WristSlot" },
	{ name = "HandsSlot" },
	{ name = "WaistSlot" },
	{ name = "LegsSlot" },
	{ name = "FeetSlot" },
	{ name = "Finger0Slot" },
	{ name = "Finger1Slot" },
	{ name = "Trinket0Slot" },
	{ name = "Trinket1Slot" },
	{ name = "MainHandSlot" },
	{ name = "SecondaryHandSlot" },
	{ name = "RangedSlot" },
};

local lBeingDragged;
local lMouseEntered;
local lOkayToShow;

--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

ITEMBUFF_BUTTONS = 6;

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

local function ItemBuff_MoneyToggle()
	if( lOriginal_GameTooltip_ClearMoney ) then
		GameTooltip_ClearMoney = lOriginal_GameTooltip_ClearMoney;
		lOriginal_GameTooltip_ClearMoney = nil;
	else
		lOriginal_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = ItemBuff_GameTooltip_ClearMoney;
	end
end

local function ItemBuff_HasBuff(id)
	local index;
	local field;
	local text;

	if( id ) then
		local hasItem;

		-- protect money frame while we set hidden tooltip
		ItemBuff_MoneyToggle();
		hasItem = ItemTempTooltip:SetInventoryItem("player", id);
		ItemBuff_MoneyToggle();

		if( hasItem ) then
			for index = 1, 15, 1 do
				field = getglobal("ItemTempTooltipTextLeft"..index);
				if( field and field:IsVisible() ) then
					text = field:GetText();
					
					if( text and (string.find(text, "%(%d+ min%)") or string.find(text, "%((%d+) sec%)")) ) then
						return 1;
					end
				end
			end
		end
	end
	return nil;
end

local function ItemBuff_UpdateWindow()
	local n;
	local button;
	local iVisible = 0;
	local maxSize = 0;
	
	for n = 1, ITEMBUFF_BUTTONS do
		button = getglobal("ItemBuffButton"..n);
		if( button:IsVisible() ) then
			iVisible = iVisible + 1;
			local label = getglobal(button:GetName().."Label");
			if( label:IsVisible() ) then
				local size = label:GetWidth();
				if( size > maxSize ) then
					maxSize = size;
				end
			end
		end
	end
	
	if( iVisible == 0 ) then
		lOkayToShow = nil;
	else
		ItemBuffFrame:SetHeight(22 + iVisible * 42);
		ItemBuffFrame:SetWidth(66 + maxSize - 1);
		lOkayToShow = 1;
	end
end

local function ItemBuff_UpdateText(button)
	local index;
	local field;
	local text;
	local label;
	
	label = getglobal(button:GetName().."Label");
	
	if( button.id ) then
		-- protect money frame while we set hidden tooltip
		ItemBuff_MoneyToggle();
		ItemTempTooltip:SetInventoryItem("player", button.id);
		ItemBuff_MoneyToggle();
		
		for index = 1, 15, 1 do
			field = getglobal("ItemTempTooltipTextLeft"..index);
			if( field and field:IsVisible() ) then
				text = field:GetText();
				if( text ) then
					local iStart, iEnd, secs;
				
					if( string.find(text, "%(%d+ min%)") ) then
						label:SetTextColor(0.0, 1.0, 0.0);
						label:SetText(text);
						return;
					end
					
					iStart, iEnd, secs = string.find(text, "%((%d+) sec%)")
					if( secs ) then
						secs = secs + 0;
						if( button.flash and secs <= 15 ) then
							label:SetTextColor(1.0, 0.0, 0.0);
						else
							label:SetTextColor(0.0, 1.0, 0.0);
						end
						label:SetText(text);
						return;
					end
				end
			end
		end
	end
	
	label:SetText("");
end

local function ItemBuffButton_SetTooltip(button)
	if( button.id ) then
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
		GameTooltip:SetInventoryItem("player", button.id);
	end
end

local function ItemBuffButton_Clear(button)
	if( button.id ) then
		button.texture = nil;
		button.id = nil;
		
		getglobal(button:GetName().."Icon"):SetTexture("");
		ItemBuff_UpdateText(button);
		ItemBuff_UpdateWindow();
		if( GameTooltip:IsOwned(button) ) then
			button.tooltip = nil;
			GameTooltip:Hide();
		end
	end
end

local function ItemBuffButton_Set(button, id)
	button.texture = GetInventoryItemTexture("player", id);
	button.id = id;
	
	getglobal(button:GetName().."Icon"):SetTexture(button.texture);
	if( button.tooltip ) then
		ItemBuffButton_SetTooltip(button);
	end
	ItemBuff_UpdateText(button);
	ItemBuff_UpdateWindow();
end

local function ItemBuff_Status()
	DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_STATUS_HEADER);
	if( ItemBuffState ) then
		if( ItemBuffState.Freeze ) then
			DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_FROZEN);
		else
			DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_UNFROZEN);
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_UNFROZEN);
	end
end

local function ItemBuff_Reset()
	ItemBuffFrame:ClearAllPoints();
	ItemBuffFrame:SetPoint("BOTTOMLEFT", "ChatFrameMenuButton", "TOPLEFT", 0, 30);
end

function ItemBuff_SlashCommandHandler(msg)
	if( msg ) then
		local command = string.lower(msg);
		if( command == "" or command == ITEMBUFF_HELP ) then
			local index;
			local value;
			for index, value in ITEMBUFF_HELP_TEXT do
				DEFAULT_CHAT_FRAME:AddMessage(value);
			end
		elseif( command == ITEMBUFF_STATUS ) then
			ItemBuff_Status();
		elseif( command == ITEMBUFF_FREEZE ) then
			ItemBuffState.Freeze = 1;
			ItemBuffBackdrop:Hide();
			ItemBuff_OnDragStop();
			DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_FROZEN);
		elseif( command == ITEMBUFF_UNFREEZE ) then
			ItemBuffState.Freeze = nil;
			if( lOkayToShow and lMouseEntered ) then
				ItemBuffBackdrop:Show();
			end
			DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_UNFROZEN);
		elseif( command == ITEMBUFF_RESET ) then
			ItemBuff_Reset();
			ItemBuff_OnDragStop();
			DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_RESET_DONE);
		end
	end
end

--------------------------------------------------------------------------------------------------
-- OnFoo functions
--------------------------------------------------------------------------------------------------

function ItemBuff_OnLoad()
	this:RegisterForDrag("LeftButton");
	
	RegisterForSave("ItemBuffState");
	
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register our slash command
	SLASH_ITEMBUFF1 = "/itembuff";
	SLASH_ITEMBUFF2 = "/ib";
	SlashCmdList["ITEMBUFF"] = function(msg)
		ItemBuff_SlashCommandHandler(msg);
	end
	
	--if( DEFAULT_CHAT_FRAME ) then
	--	DEFAULT_CHAT_FRAME:AddMessage("Telo's ItemBuff AddOn loaded");
	--end
	--UIErrorsFrame:AddMessage("Telo's ItemBuff AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);	
end

function ItemBuff_OnShow()
	local index;
	
	for index = 1, getn(lInventorySlots), 1 do
		lInventorySlots[index].id = GetInventorySlotInfo(lInventorySlots[index].name);
	end

	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
end

function ItemBuff_OnEvent(event)
	if( event == "UNIT_INVENTORY_CHANGED" ) then
		if( arg1 == "player" ) then
			local index;
			local n;
			local button;

			n = 1;
			for index = 1, getn(lInventorySlots), 1 do
				if( ItemBuff_HasBuff(lInventorySlots[index].id) ) then
					button = getglobal("ItemBuffButton"..n);
					button:Show();
					ItemBuffButton_Set(button, lInventorySlots[index].id);
					n = n + 1;
					if( n > ITEMBUFF_BUTTONS ) then
						break;
					end
				end
			end
			
			while( n <= ITEMBUFF_BUTTONS ) do
				button = getglobal("ItemBuffButton"..n);
				button:Hide();
				ItemBuffButton_Clear(button);
				n = n + 1;
			end
		end
		return;
	elseif( event == "VARIABLES_LOADED" ) then
		if( not ItemBuffState ) then
			ItemBuffState = { };
		end
	end
end

function ItemBuff_OnEnter()
	lMouseEntered = 1;
	if( lOkayToShow and (not ItemBuffState or not ItemBuffState.Freeze) ) then
		ItemBuffBackdrop:Show();
	end
end

function ItemBuff_OnLeave()
	lMouseEntered = nil;
	if( not lBeingDragged ) then
		ItemBuffBackdrop:Hide();
	end
end

function ItemBuff_OnDragStart()
	if( not ItemBuffState or not ItemBuffState.Freeze ) then
		ItemBuffFrame:StartMoving()
		lBeingDragged = 1;
	end
end

function ItemBuff_OnDragStop()
	if( not lMouseEntered ) then
		ItemBuffBackdrop:Hide();
	end
	ItemBuffFrame:StopMovingOrSizing()
	lBeingDragged = nil;
end

function ItemBuffButton_OnEnter()
	this.tooltip = 1;
	ItemBuffButton_SetTooltip(this);
end

function ItemBuffButton_OnLeave()
	if( this.tooltip ) then
		this.tooltip = nil;
		GameTooltip:Hide();
	end
end

function ItemBuffButton_OnLoad()
	this.timer = 0;
	this.flashTimer = 0;
end

function ItemBuffButton_OnUpdate(elapsed)
	if( elapsed ) then
		this.timer = this.timer + elapsed;
		this.flashTimer = this.flashTimer + elapsed;
		if( this.flashTimer >= 0.50 ) then
			this.flashTimer = 0;
			if( this.flash ) then
				this.flash = nil;
			else
				this.flash = 1;
			end
		end
		if( this.timer >= 0.25 ) then
			this.timer = 0;
			ItemBuff_UpdateText(this);
			ItemBuff_UpdateWindow();
		end
	end
end

--------------------------------------------------------------------------------------------------
-- Hooked functions
--------------------------------------------------------------------------------------------------

function ItemBuff_GameTooltip_ClearMoney()
	-- Intentionally empty; don't clear money while we use hidden tooltips
end
