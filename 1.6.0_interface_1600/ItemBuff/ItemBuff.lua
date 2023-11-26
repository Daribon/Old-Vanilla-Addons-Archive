--[[

	ItemBuff: A simple mechanism for monitoring item buffs
		copyright 2004-2005 by Telo
	
	- Automatically displays up to six timed item buffs onscreen in a small movable window
	
]]

ITEMBUFF_BUTTONS = 6;


--------------------------------------------------------------------------------------------------
-- Local variables
--------------------------------------------------------------------------------------------------

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
-- Internal functions
--------------------------------------------------------------------------------------------------

function ItemBuff_DoNotShowBuff(itemName)
	for k, v in ItemBuff_HideBuffsFromTheseItems do
		if ( itemName == v ) then
			return true;
		end
	end
	return false;
end

ITEMBUFF_NUMBER_OF_BUTTONS = 6;

function ItemBuff_RescaleIcons(newScale)
	local baseName = "ItemBuffButton";
	local buttonName = nil;
	local button = nil;
	local icon = nil;
	local oldScale;
	local realNewScale;
	for i = 1, ITEMBUFF_NUMBER_OF_BUTTONS do
		buttonName = baseName..i;
		button = getglobal(buttonName);
		if ( button ) then
			icon = getglobal(buttonName.."IconFrame");
			if ( icon ) then
				if ( not icon.originalScale ) then
					icon.originalScale = icon:GetScale();
				end
				oldScale = icon:GetScale();
				realNewScale = icon.originalScale * newScale;
				if ( realNewScale ~= oldScale ) then
					icon:SetScale(realNewScale);
				end
			end
		end
	end
	if ( realNewScale ~= oldScale ) then
		button = getglobal(baseName.."1");
		button:ClearAllPoints();
		if ( button ) then
			if ( realNewScale > oldScale ) then
				button:SetPoint("BOTTOMLEFT", "ItemBuffBar", "TOPLEFT", ITEMBUFF_NORMAL_ICON_START_X, ITEMBUFF_NORMAL_ICON_START_Y);
			elseif ( realNewScale < oldScale ) then
				button:SetPoint("BOTTOMLEFT", "ItemBuffBar", "TOPLEFT", ITEMBUFF_SMALL_ICON_START_X, ITEMBUFF_SMALL_ICON_START_Y);
			end
		end
	end
end

ITEMBUFF_NORMAL_ICON_START_X = 0;
ITEMBUFF_NORMAL_ICON_START_Y = 0;
ITEMBUFF_SMALL_ICON_START_X = -18;
ITEMBUFF_SMALL_ICON_START_Y = 0;

ItemBuff_SmallIcons = 0;
ItemBuff_SmallIconScale = 0.5;
ItemBuff_NormalIconScale = 1.0;
ItemBuff_DisplayBuffName = 1;
ItemBuff_DisplayBuffTimeSeperately = 0;

function ItemBuff_ScaleIcons()
	if ( ItemBuff_SmallIcons == 1 ) then
		ItemBuff_RescaleIcons(ItemBuff_SmallIconScale);
	else
		ItemBuff_RescaleIcons(ItemBuff_NormalIconScale);
	end
end

function ItemBuff_SetSmallIcons(toggle)
	if ( toggle ~= ItemBuff_SmallIcons ) then
		ItemBuff_SmallIcons = toggle;
		ItemBuff_ScaleIcons();
	end
end

function ItemBuff_SetDisplayBuffName(toggle)
	if ( toggle ~= ItemBuff_DisplayBuffName ) then
		ItemBuff_DisplayBuffName = toggle;
	end
end

function ItemBuff_SetDisplayBuffTimeSeperately(toggle)
	if ( toggle ~= ItemBuff_DisplayBuffTimeSeperately ) then
		ItemBuff_DisplayBuffTimeSeperately = toggle;
	end
end

function ItemBuff_HasBuff(id)
	local index;
	local field;
	local text;

	if( id ) then
		local hasItem;
		ItemBuff_ProtectTooltip();
		hasItem = ItemTempTooltip:SetInventoryItem("player", id);
		ItemBuff_UnprotectTooltip();
		if( hasItem ) then
			field = getglobal("ItemTempTooltipTextLeft1");
			if( field and field:IsVisible() ) then
				text = field:GetText();
				if ( text ) and ( ItemBuff_DoNotShowBuff(text) ) then
					return nil;
				end
			end
			for index = 2, 15, 1 do
				field = getglobal("ItemTempTooltipTextLeft"..index);
				if( field and field:IsVisible() ) then
					text = field:GetText();

					if( text and (string.find(text, ITEMBUFF_ENCHANT_TIME_LEFT_MINUTES) or string.find(text, ITEMBUFF_ENCHANT_TIME_LEFT_SECONDS)) ) then
						return 1;
					end
				end
			end
		end
	end
	return nil;
end

function ItemBuff_UpdateWindow()
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
		lOkayToShow = 1;
	end
	if ( ItemBuffBar ) then
		ItemBuffBar:SetHeight(2 + iVisible * 42);
		ItemBuffBar:SetWidth(36 + maxSize - 1);
	end
	ItemBuff_ScaleIcons();
end

function ItemBuff_UpdateText(button)
	local index;
	local field;
	local text;
	local label;
	
	label = getglobal(button:GetName().."Label");
	
	if( button.id ) then
		--[[
		if( MerchantFrame:IsVisible() ) then
			label:SetTextColor(0.7, 0.7, 0.7);
			label:SetText(ITEMBUFF_CANTUPDATE);
			return;
		end
		]]--
		
		ItemBuff_ProtectTooltip();
		ItemTempTooltip:SetInventoryItem("player", button.id);
		ItemBuff_UnprotectTooltip();
		for index = 1, 15, 1 do
			field = getglobal("ItemTempTooltipTextLeft"..index);
			if( field and field:IsVisible() ) then
				text = field:GetText();
				if( text ) then
					local iStart, iEnd, secs;
				
					iStart, iEnd = string.find(text, ITEMBUFF_ENCHANT_TIME_LEFT_MINUTES)
					if( iStart ) then
						label:SetTextColor(0.0, 1.0, 0.0);
						if ( ItemBuff_DisplayBuffName == 1 ) then
							if ( ItemBuff_DisplayBuffTimeSeperately == 1 ) then
								label:SetText(string.sub(text,1,iStart-1).."\n|cFFFFFFFF"..string.sub(text,iStart+1,iEnd-1).."|r");
							else
								label:SetText(text);
							end
						else
							label:SetText("");
						end

						return;
					end
					
					iStart, iEnd, secs = string.find(text, ITEMBUFF_ENCHANT_TIME_LEFT_SECONDS)
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

function ItemBuff_ProtectTooltip()
	if ( Sea ) and ( Sea.wow ) and ( Sea.wow.tooltip ) and ( Sea.wow.tooltip.protectTooltipMoney ) then
		Sea.wow.tooltip.protectTooltipMoney();
	end
end

function ItemBuff_UnprotectTooltip()
	if ( Sea ) and ( Sea.wow ) and ( Sea.wow.tooltip ) and ( Sea.wow.tooltip.unprotectTooltipMoney ) then
		Sea.wow.tooltip.unprotectTooltipMoney();
	end
end

function ItemBuffButton_SetTooltip(button)
	if( button.id ) then
		UltimateUITooltip:SetOwner(button, "ANCHOR_RIGHT");
		ItemBuff_ProtectTooltip();
		UltimateUITooltip:SetInventoryItem("player", button.id);
		ItemBuff_UnprotectTooltip();
	end
end

function ItemBuffButton_Clear(button)
	if( button.id ) then
		button.texture = nil;
		button.id = nil;
		
		getglobal(button:GetName().."IconFrameCheckButtonIcon"):SetTexture("");
		ItemBuff_UpdateText(button);
		ItemBuff_UpdateWindow();
		if( UltimateUITooltip:IsOwned(button) ) then
			button.tooltip = nil;
			UltimateUITooltip:Hide();
		end
	end
end

function ItemBuffButton_Set(button, id)
	button.texture = GetInventoryItemTexture("player", id);
	button.id = id;
	
	getglobal(button:GetName().."IconFrameCheckButtonIcon"):SetTexture(button.texture);
	if( button.tooltip ) then
		ItemBuffButton_SetTooltip(button);
	end
	ItemBuff_UpdateText(button);
	ItemBuff_UpdateWindow();
end

function ItemBuff_Status()
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

function ItemBuff_Reset()
	ItemBuffBar:ClearAllPoints();
	ItemBuffBar:SetPoint("TOPLEFT", "ChatFrame1", "TOPLEFT", 0, 20);
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
			if ( ItemBuffBackdrop ) then
				ItemBuffBackdrop:Hide();
			end
			ItemBuff_OnDragStop();
			DEFAULT_CHAT_FRAME:AddMessage(ITEMBUFF_FROZEN);
		elseif( command == ITEMBUFF_UNFREEZE ) then
			ItemBuffState.Freeze = nil;
			if( lOkayToShow and lMouseEntered ) then
				if ( ItemBuffBackdrop ) then
					--ItemBuffBackdrop:Show();
				end
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
	if(UltimateUI_RegisterConfiguration) then
		UltimateUI_RegisterConfiguration(
			"UUI_ITEMBUFF",
			"SECTION",
			ITEMBUFF_SEP
			);
		UltimateUI_RegisterConfiguration(
			"UUI_ITEMBUFF_SEPARATOR",
			"SEPARATOR",
			ITEMBUFF_SEP
			);
		UltimateUI_RegisterConfiguration(
		 	"UUI_ITEMBUFF_ON", 
		 	"CHECKBOX", 
		 	ITEMBUFF_CHECK,
		 	ITEMBUFF_CHECK_INFO, 
		 	function (toggle) 
				if ( toggle == 1 ) then 
					ItemBuffBar:Show();
				else
					ItemBuffBar:Hide();
				end
			end,
			1
			);
		UltimateUI_RegisterConfiguration(
		 	"UUI_ITEMBUFF_SMALL_ICONS", 
		 	"CHECKBOX", 
		 	ITEMBUFF_SMALL_ICONS,
		 	ITEMBUFF_SMALL_ICONS_INFO, 
		 	ItemBuff_SetSmallIcons
			);
		UltimateUI_RegisterConfiguration(
		 	"UUI_ITEMBUFF_SHOW_BUFFNAME", 
		 	"CHECKBOX", 
		 	ITEMBUFF_DISPLAY_BUFFNAME,
		 	ITEMBUFF_DISPLAY_BUFFNAME_INFO, 
		 	ItemBuff_SetDisplayBuffName
			);
		UltimateUI_RegisterConfiguration(
		 	"UUI_ITEMBUFF_SHOW_BUFFTIMESEPERATELY", 
		 	"CHECKBOX", 
		 	ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY,
		 	ITEMBUFF_DISPLAY_BUFFTIMESEPERATELY_INFO, 
		 	ItemBuff_SetDisplayBuffTimeSeperately
			);
	end

	this:RegisterForClicks("LeftButton");
	this:RegisterForDrag("LeftButton");
	
	RegisterForSave("ItemBuffState");
	
	this:RegisterEvent("VARIABLES_LOADED");

	if ( UltimateUI_RegisterChatCommand ) then
		local ItemBuffMainCommands = {"/itembuff","/ib"};
		UltimateUI_RegisterChatCommand (
			"ITEMBUFF_MAIN_COMMANDS", -- Some Unique Group ID
			ItemBuffMainCommands, -- The Commands
			ItemBuff_SlashCommandHandler,
			ITEMBUFF_CHAT_COMMAND_INFO -- Description String
		);
	else
		-- Register our slash command
		SLASH_ITEMBUFF1 = "/itembuff";
		SLASH_ITEMBUFF2 = "/ib";
		SlashCmdList["ITEMBUFF"] = function(msg)
			ItemBuff_SlashCommandHandler(msg);
		end
	end

	
	if( DEFAULT_CHAT_FRAME ) then
		--DEFAULT_CHAT_FRAME:AddMessage("Telo's ItemBuff AddOn loaded");
	end
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
					if( n > 6 ) then
						return;
					end
				end
			end
			
			while( n <= 6 ) do
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
		if ( ItemBuffBackdrop ) then
			--ItemBuffBackdrop:Show();
		end
	end
end

function ItemBuff_OnLeave()
	lMouseEntered = nil;
	if( not lBeingDragged ) then
		if ( ItemBuffBackdrop ) then
			ItemBuffBackdrop:Hide();
		end
	end
end

function ItemBuff_OnDragStart()
	if( not ItemBuffState or not ItemBuffState.Freeze ) then
		ItemBuffBar:StartMoving()
		lBeingDragged = 1;
	end
end

function ItemBuff_OnDragStop()
	if( not lMouseEntered ) then
		if ( ItemBuffBackdrop ) then
			ItemBuffBackdrop:Hide();
		end
	end
	ItemBuffBar:StopMovingOrSizing()
	lBeingDragged = nil;
end

function ItemBuffButton_OnEnter()
	this.tooltip = 1;
	ItemBuffButton_SetTooltip(this:GetParent():GetParent());
end

function ItemBuffButton_OnLeave()
	if( this.tooltip ) then
		this.tooltip = nil;
		UltimateUITooltip:Hide();
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


function ItemBuffButtonCheckButton_OnLoad()
	this:RegisterForClicks("LeftButton");
	this:RegisterForDrag("LeftButton");
end
