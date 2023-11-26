--[[
	                    ==> Merphle's BankStatement <==
	 
	 View the contents of your bank, anywhere in the world, including quantity of each item.
	 You will not be able to modify the contents of your bank (add, remove, move).
	 This is most useful for those of us with poor memory skills. :)
	 Bank Statement contents are stored distinctly for each character.
	 You will need to visit a bank after installing BankStatement, to set up the stored items.
	 
	 Let me know if you come up with any good extensions to this AddOn.
	 This is my first AddOn, so please be gentle. :)
	 
	 Thanks go out to Telo, from whose awesome LinkLoot AddOn I shamelessly stole the
	  bank item scanning and tooltip population code.
	 Thanks also go out to Jerigord for showing me how to retrieve the Realm name, so that
	  I can properly store bank items for same-name-different-server players.
	 Yet more thank go to Juki at curse-gaming.com, for the French translation.
	 
	 History:
	  v0.5 (2004-12-16): Initial release.
	  v0.5.1 (2004-12-17): Bug fix for "table index is null" on line 115.
	  v0.6 (2004-12-18): Added graphical view for base Bank contents.
	  v0.7 (2005-01-05): Corrected bug in chat "list" command for bags. Thanks for prodding me, Raseri!
	  v1.0 (2005-01-08): Added graphical view for Bank Bag contents!
	                     Added ability to close BankStatement and all Bank Bags via ESC key.
	                     Added functionality to shift BankStatement and Bank Bags around on screen
	                     depending on visibility of other windows.
	  v1.1 (2005-01-10): Added new command "/bs showall" (with bindable key) to open BankStatement and
	                     all Bank Bags simultaneously.
	                     Added ability to shift-click items to copy links into chat.
	  v1.2 (2005-01-11): Added functionality to store bank information for multiple characters with
	                     the same name, on different servers.
	                     Fixed bug whereby items moved onto empty slots result in duplicates displayed.
	  v1.2.1 (2005-01-15): Corrected bug where BankStatement frame would occasionally not show
	                       any items upon first logging in.
	  v1.2.2 (2005-01-19): Corrected bug where BankStatement would lose track of what items are stored.
	                       Added subcommand to clear stored items for current character, or
	                       across all characters.
	  v1.2.3 (2005-01-20): Corrected bug from v1.2.2 where BankStatement would always lose track of
	                       items upon logging in.
	  v1.2.4 (2005-01-22): Finally, finally, corrected problems with losing track of items upon
	                       certain zone changes, and should lessen conflicts with other AddOns.
	  v2.0 (2005-01-24): Added ability to view your other characters' items via drop-down menu.
	  v2.1 (2005-02-16): Updated to Interface version 4211.
	                     Integrated French translation.
	                     Enabled compatibility with SellValue (and the other tooltip-modifying addons?).
	  v2.2 (2005-02-22): Updated to Interface version 4216.
	 TODO: ???
--]]

-- Local variables
local BankStatementCurrentIndex = nil;

-- Local functions

-- OnFoo functions

function BankStatement_OnLoad()
	RegisterForSave("BankStatementItems");

	SlashCmdList["BANKSTATEMENT"] = function(msg)
		BankStatement_SlashCmd(msg);
	end
	
	UIPanelWindows["BankStatementFrame"] = { area = "left", pushable = 6 };
	
	BankStatementFrameTitleText:SetText("BankStatement");
	
	this:RegisterEvent("BANKFRAME_OPENED");
	this:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	this:RegisterEvent("BAG_UPDATE");

-- ======================================================
-- Start of Ultimate UI Spellbook Registration
-- ======================================================
   if ( UltimateUI_RegisterButton ) then
      UltimateUI_RegisterButton (
		"BankStatement",
		"Toggle",
		"Allows you to view the contents of your bank from anywhere in the world.",
		"Interface\\Icons\\Spell_Nature_MagicImmunity",
		BankStatement_Toggle
	);
   end
-- ======================================================
-- Start of Ultimate UI Spellbook Registration
-- ======================================================

end

function BankStatement_OnEvent(event, arg1)
	if ((event == "BANKFRAME_OPENED") or (event == "PLAYERBANKSLOTS_CHANGED" and arg1 == nil) or (event == "BAG_UPDATE" and arg1 >= 5 and arg1 <= 10)) then
		BankStatement_StoreBankItems();
	end
end

function BankStatementItemButton_OnEnter()
	local link;
	local player = BankStatementGetBSIIndex();
	if (not BankStatementItems) then BankStatementItems = {}; end
	if (not BankStatementItems[player]) then BankStatementItems[player] = {}; end
	if (this.isBag) then
		if (BankStatementItems[player]["bag"..this:GetID()]) then
			link = BankStatementItems[player]["bag"..this:GetID()].link;
		end
	else
		if (BankStatementItems[player]["bank"] and BankStatementItems[player]["bank"][this:GetID()]) then
			link = BankStatementItems[player]["bank"][this:GetID()].link;
		end
	end

	ShowUIPanel(GameTooltip);
--	if( not GameTooltip:IsVisible() ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
--	end
	if (link) then
		_, _, link = string.find(link, "|H(item:%d+:%d+:%d+:%d+)|");
		GameTooltip:SetHyperlink(link);
	else
		if (this.isBag) then
			GameTooltip:SetText(TEXT(BANK_BAG));
		end
	end
	
end

function BankStatementItemButton_OnClick(arg1)
	if (arg1 ~= "LeftButton") then return end
	if (IsShiftKeyDown() and ChatFrameEditBox:IsVisible()) then
		ChatFrameEditBox:Insert(BankStatementGetItemLink("bank", this:GetID()));
	end
end

function BankStatementFrameItemButtonBag_OnClick(arg1)
	if (not this.isBag) then return end
	if (arg1 ~= "LeftButton") then return end
	if (IsShiftKeyDown() and ChatFrameEditBox:IsVisible()) then
		ChatFrameEditBox:Insert(BankStatementGetItemLink("bag"..this:GetID(), "bag"));
	else
		BankStatementToggleBag(this:GetID());
	end
end

function BankStatementContainerFrameItemButton_OnClick(arg1)
	if (arg1 ~= "LeftButton") then return end
	if (IsShiftKeyDown() and ChatFrameEditBox:IsVisible()) then
		ChatFrameEditBox:Insert(BankStatementGetItemLink("bag"..this:GetParent():GetID(), this:GetID()));
	end
end

function BankStatementContainerFrameItemButton_OnEnter()
	local link;
	local player = BankStatementGetBSIIndex();
	if (not BankStatementItems) then BankStatementItems = {}; end
	if (not BankStatementItems[player]) then BankStatementItems[player] = {}; end
	if (BankStatementItems[player]["bag"..this:GetParent():GetID()]) then
		local bag = BankStatementItems[player]["bag"..this:GetParent():GetID()];
		if (bag[this:GetID()] and bag[this:GetID()].link) then
			link = BankStatementItems[player]["bag"..this:GetParent():GetID()][this:GetID()].link;
		end
	end

	if (link) then
		ShowUIPanel(GameTooltip);
--		if( not GameTooltip:IsVisible() ) then
			GameTooltip:SetOwner(this, "ANCHOR_LEFT");
--		end
		_, _, link = string.find(link, "|H(item:%d+:%d+:%d+:%d+)|");
		GameTooltip:SetHyperlink(link);
	end
end

function BankStatementContainerFrameCloseButton_OnClick()
	HideUIPanel(this:GetParent());
end

function BankStatementContainerFrame_OnHide()
	ContainerFrame1.bagsShown = ContainerFrame1.bagsShown - 1;
	-- Remove the closed bag from the list and collapse the rest of the entries
	local index = 1;
	while ContainerFrame1.bags[index] do
		if ( ContainerFrame1.bags[index] == this:GetName() ) then
			local tempIndex = index;
			while ContainerFrame1.bags[tempIndex] do
				if ( ContainerFrame1.bags[tempIndex + 1] ) then
					ContainerFrame1.bags[tempIndex] = ContainerFrame1.bags[tempIndex + 1];
				else
					ContainerFrame1.bags[tempIndex] = nil;
				end
				tempIndex = tempIndex + 1;
			end
		end
		index = index + 1;
	end
	updateContainerFrameAnchors();
end

function BankStatementContainerFrame_OnShow()
	ContainerFrame1.bagsShown = ContainerFrame1.bagsShown + 1;
end

function BankStatementDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, BankStatementDropDown_Initialize);
	UIDropDownMenu_SetText(BANKSTATEMENT_SELPLAYER, this);
	UIDropDownMenu_SetWidth(130, BankStatementDropDown);
end

function BankStatementDropDown_OnClick()
	BankStatementCurrentIndex = this.value;
	BankStatement_ToggleAll();
	BankStatement_ToggleAll();
end

-- Helper functions

function BankStatement_SlashCmd(msg)
	if (msg == BANKSTATEMENT_SUBCMD_LIST) then
		BankStatement_List();
	elseif (msg == BANKSTATEMENT_SUBCMD_SHOW) then
		BankStatement_Show();
	elseif (msg == BANKSTATEMENT_SUBCMD_SHOWALL) then
		BankStatement_ToggleAll();
	elseif (msg == BANKSTATEMENT_SUBCMD_CLEAR) then
		local player = BankStatementGetBSIIndex();
		if (not BankStatementItems) then BankStatementItems = {}; end
		BankStatementItems[player] = {};
		DEFAULT_CHAT_FRAME:AddMessage(format(BANKSTATEMENT_PLAYERITEMSCLEARED, player));
	elseif (msg == BANKSTATEMENT_SUBCMD_CLEARALL) then
		BankStatementItems = {};
		DEFAULT_CHAT_FRAME:AddMessage(BANKSTATEMENT_ALLPLAYERITEMSCLEARED);
	elseif (msg == "") then
		BankStatement_Toggle();
	else
		DEFAULT_CHAT_FRAME:AddMessage(BANKSTATEMENT_USAGE);
		local index, subcmdUsage;
		for index, subcmdUsage in BANKSTATEMENT_USAGE_SUBCMD do
			if (subcmdUsage) then
				DEFAULT_CHAT_FRAME:AddMessage(subcmdUsage);
			end
		end
	end
end

function BankStatement_List()
	local player = BankStatementGetBSIIndex();
	if (not BankStatementItems or not BankStatementItems[player]) then
		DEFAULT_CHAT_FRAME:AddMessage(BANKSTATEMENT_MSG_EMPTY);
	else
		local index, item, bagNum, shown;
		if (BankStatementItems[player]["bank"]) then
			for index, item in BankStatementItems[player]["bank"] do
				if (item.link and item.quantity) then
					DEFAULT_CHAT_FRAME:AddMessage(BANKSTATEMENT_BANKITEM..index .. ": " .. item.link .. " x" .. item.quantity);
					shown = 1;
				end
			end
		end
		for bagNum = 5, 10 do
			if (BankStatementItems[player]["bag"..bagNum]) then
				for index, item in BankStatementItems[player]["bag"..bagNum] do
					if (type(item) == "table" and item.link and item.quantity) then
						DEFAULT_CHAT_FRAME:AddMessage(BANKSTATEMENT_BANKBAG..bagNum..BANKSTATEMENT_ITEM..index .. ": " .. item.link .. " x" .. item.quantity);
						shown = 1;
					end
				end
			end
		end
		if (not shown) then
			DEFAULT_CHAT_FRAME:AddMessage(BANKSTATEMENT_MSG_EMPTY);
		end
	end
end

function BankStatement_Show()
	local player = BankStatementGetBSIIndex();
	if (not BankStatementItems) then BankStatementItems = {}; end
	if (not BankStatementItems[player]) then BankStatementItems[player] = {}; end
	local index, item, bagNum, button, texture;
	for index = 1, 24 do
		button = getglobal("BankStatementFrameItem"..index);
		texture = getglobal("BankStatementFrameItem"..index.."IconTexture");
		texture:SetTexture(nil);
		SetItemButtonCount(button, 0);
	end
	if (BankStatementItems[player]["bank"]) then
		for index, item in BankStatementItems[player]["bank"] do
			button = getglobal("BankStatementFrameItem"..index);
			texture = getglobal("BankStatementFrameItem"..index.."IconTexture");
			texture:SetTexture(item.icon);
			SetItemButtonCount(button, item.quantity);
		end
	end
	for bagNum = 5, 10 do
		texture = getglobal("BankStatementFrameBag"..(bagNum-4).."IconTexture");
		if (BankStatementItems[player]["bag"..bagNum] and BankStatementItems[player]["bag"..bagNum].icon) then
			texture:SetTexture(BankStatementItems[player]["bag"..bagNum].icon);
		else
			local _, defaultBagIcon = GetInventorySlotInfo("Bag"..(bagNum-4));
			texture:SetTexture(defaultBagIcon);
		end
	end
	SetPortraitTexture(BankStatementPortraitTexture, "player");
	ShowUIPanel(BankStatementFrame);
end

function BankStatement_Hide()
	HideUIPanel(BankStatementFrame);
end

function BankStatement_Toggle()
	if (BankStatementFrame:IsVisible()) then
		BankStatement_Hide()
	else
		BankStatement_Show()
	end
end

function BankStatement_ToggleAll()
	if (BankStatementFrame:IsVisible()) then
		BankStatement_Hide()
	else
		BankStatement_Show()
		for bagNum = 5, 10 do
			BankStatementToggleBag(bagNum);
		end
	end
end

function BankStatement_StoreBankItems()
	local maxContainerItems;
	local containerItemNum;
	local bagNum;
	local link;
	local quantity;
	local icon;
	local player = BankStatementGetBSIIndex(1);
	if (not BankFrame:IsVisible()) then return end
	if (not BankStatementItems) then BankStatementItems = {}; end

	BankStatementItems[player] = {};

	maxContainerItems = GetContainerNumSlots(BANK_CONTAINER);
	if ( maxContainerItems ) then
		BankStatementItems[player]["bank"] = {};
		for containerItemNum = 1, maxContainerItems do
			BankStatementItems[player]["bank"][containerItemNum] = {};
			link = GetContainerItemLink(BANK_CONTAINER, containerItemNum);
			icon, quantity = GetContainerItemInfo(BANK_CONTAINER, containerItemNum);
			if( link ) then
				BankStatementItems[player]["bank"][containerItemNum].link = link;
				BankStatementItems[player]["bank"][containerItemNum].quantity = quantity;
				BankStatementItems[player]["bank"][containerItemNum].icon = icon;
			end
		end
	end

	for bagNum = 5, 10 do
		maxContainerItems = GetContainerNumSlots(bagNum);
		
		if( maxContainerItems ) then
			BankStatementItems[player]["bag"..bagNum] = {};
			local id = BankButtonIDToInvSlotID(bagNum, 1);
			link = GetInventoryItemLink("player", id);
			icon = GetInventoryItemTexture("player", id);
			BankStatementItems[player]["bag"..bagNum].link = link;
			BankStatementItems[player]["bag"..bagNum].icon = icon;
			BankStatementItems[player]["bag"..bagNum].bagsize = maxContainerItems;
			for containerItemNum = 1, maxContainerItems do
				BankStatementItems[player]["bag"..bagNum][containerItemNum] = {};
				link = GetContainerItemLink(bagNum, containerItemNum);
				icon, quantity = GetContainerItemInfo(bagNum, containerItemNum);
				if( link ) then
					BankStatementItems[player]["bag"..bagNum][containerItemNum].link = link;
					BankStatementItems[player]["bag"..bagNum][containerItemNum].quantity = quantity;
					BankStatementItems[player]["bag"..bagNum][containerItemNum].icon = icon;
				end
			end
		end
	end
end

function BankStatementContainerFrame_GetOpenFrame()
	for i=1, 6, 1 do
		local frame = getglobal("BankStatementContainerFrame"..i);
		if ( not frame:IsVisible() ) then
			return frame;
		end
		-- If all frames open return the last frame
		if ( i == 6 ) then
			frame:Hide();
			return frame;
		end
	end
end

function BankStatementCloseBags()
	for i=1, 6, 1 do
		local frame = getglobal("BankStatementContainerFrame"..i);
		HideUIPanel(frame);
	end
end

function BankStatementToggleBag(bagId)
	local player = BankStatementGetBSIIndex();
	if (BankStatementItems and BankStatementItems[player]) then
		if (BankStatementItems[player]["bag"..bagId]) then
			local bag = BankStatementItems[player]["bag"..bagId];
			if (bag.bagsize <= 0) then return end
			local bagFrameWasOpen;
			for i=1, 6, 1 do
				local frame = getglobal("BankStatementContainerFrame"..i);
				if ( frame:IsVisible() and frame:GetID() == bagId ) then
					HideUIPanel(frame);
					bagFrameWasOpen = 1;
				end
			end
			if ( not bagFrameWasOpen ) then
				local bagFrameToOpen = BankStatementContainerFrame_GetOpenFrame();
				ContainerFrame_GenerateFrame(bagFrameToOpen, bag.bagsize, bagId);
				getglobal(bagFrameToOpen:GetName().."Name"):SetText(bag.link);
				getglobal(bagFrameToOpen:GetName().."Portrait"):SetTexture(bag.icon);
				for bagItemNum = 1, bag.bagsize do
					local button = getglobal(bagFrameToOpen:GetName().."Item"..(bag.bagsize-bagItemNum+1));
					local item = bag[bagItemNum];
					if (item and item.quantity and item.icon) then
						SetItemButtonCount(button, item.quantity);
						SetItemButtonTexture(button, item.icon);
					else
						SetItemButtonCount(button, 0);
						SetItemButtonTexture(button, "");
					end
				end
			end
		end
	end
end

function BankStatementGetItemLink(container, itemNum)
	local item;
	local player = BankStatementGetBSIIndex();
	if (BankStatementItems and BankStatementItems[player]) then
		if (itemNum == "bag") then
			item = BankStatementItems[player][container];
		else
			if (BankStatementItems[player][container]) then
				item = BankStatementItems[player][container][itemNum];
			end
		end
	end
	if (item and item.link) then
		return item.link;
	else
		return "";
	end
end

function BankStatementGetBSIIndex(forceRecreate)
	if (forceRecreate or not BankStatementCurrentIndex) then
		local realmName = GetCVar("realmName");
		local playerName = UnitName("player");
		BankStatementCurrentIndex = realmName.."|"..playerName;
	end;
	return BankStatementCurrentIndex;
end

function BankStatementDropDown_Initialize()
	local info = {};

	if (not BankStatementItems) then BankStatementItems = {}; end;
	
	for index, item in BankStatementItems do
		local realm, player;
		_, _, realm, player = string.find(index, "^(.+)|(.+)$");
		info.text = player..BANKSTATEMENT_ON..realm;
		info.value = index;
		info.func = BankStatementDropDown_OnClick;
		info.notCheckable = nil;
		info.keepShownOnClick = nil;
		UIDropDownMenu_AddButton(info);
	end;
end
