--[[
 QuickMountEquip
    By Robert Jenkins (Merrem@Perenolde)
  
  Automates equipping of items when mounting/dismounting

	UI based on Totem Stomper by AlexYoshi
  
]]

QuickMount_Version = "2.12";

QuickMount_ConfigMap = nil;
QuickMount_Disabled = false;

-- Current Player information...
QMCP = "NONE";

QuickMount_SavedBagFunc = nil;
QuickMount_SavedInvFunc = nil;

local combat_flag = false
local last_action = nil
local attack_button = 0;

local MOUNT = 1;
local UNMOUNT = 2;
local SET_COUNT = 2;
local SET_SIZE = 5;

local QuickMount_CurrentID = -1;
local QuickMount_CurrentBag = -1;
local QuickMount_CurrentSlot = -1;
local QuickMount_CurrentName = "";
local QuickMount_CurrentTexture = "";

UIPanelWindows["QuickMountFrame"] = { area = "left", pushable = 11 };

function QuickMount_RegisterEvents()
	this:RegisterEvent("VARIABLES_LOADED")		-- configuration loading
	this:RegisterEvent("UNIT_NAME_UPDATE")		-- configuration loading
	this:RegisterEvent("PLAYER_AURAS_CHANGED")	-- mount buff check
	this:RegisterEvent("ACTIONBAR_UPDATE_USABLE")	-- flight path check
	this:RegisterEvent("PLAYER_REGEN_DISABLED")	-- combat check
	this:RegisterEvent("PLAYER_REGEN_ENABLED")	-- combat check
	this:RegisterEvent("DELETE_ITEM_CONFIRM")		-- delete check
end

function QuickMount_UnregisterEvents()
	this:UnregisterEvent("PLAYER_AURAS_CHANGED")    -- mount buff check
	this:UnregisterEvent("ACTIONBAR_UPDATE_USABLE") -- flight path check
	this:UnregisterEvent("PLAYER_REGEN_DISABLED")   -- combat check
	this:UnregisterEvent("PLAYER_REGEN_ENABLED")    -- combat check
end

function QuickMount_ShowUsage()
	QM_Print("/mountequip on | off | quiet | verbose | config | status\n");
end

function QuickMount_Toggle()
	QuickMount_Config("config");
end

-- Show/hide the Main Frame
function QuickMount_Config(msg)
	if QuickMount_CheckPlayer() == false then
		QM_Print("Sorry, QuickMountEquip variables aren't loaded yet.");
		return;
	end
	if msg == nil or msg == "" then
		msg = "status";
	end
	if msg == 'off' then
		QuickMount_Disabled = true;
		QM_Print("QuickMountEquip disabled.");
	elseif msg == 'on' then
		QuickMount_Disabled = false;
		QM_Print("QuickMountEquip enabled.");
	elseif msg == 'quiet' then
		QuickMount_ConfigMap[QMCP]["Quiet"] = true;
		QM_Print("QuickMountEquip verbosity off.");
	elseif msg == 'verbose' then
		QuickMount_ConfigMap[QMCP]["Quiet"] = false;
		QM_Print("QuickMountEquip verbosity on.");
	elseif msg == 'status' then
		QuickMount_ShowUsage();
		local status = "QuickMountEquip is currently";
		if QuickMount_Disabled == true then
			status = status .. " disabled";
		else
			status = status .. " enabled";
		end
		if QuickMount_ConfigMap[QMCP]["Quiet"] == false then
			status = status .. " and is in verbose mode.";
		else
			status = status .. " and is in quiet mode.";
		end
		QM_Print(status);
	elseif msg == 'config' then
            -- Reset attack_button, just in case they rearranged hot keys.
		attack_button = 0
		if ( QuickMountFrame ) then 
			if ( QuickMountFrame:IsVisible() ) then 
				HideUIPanel(QuickMountFrame);
			else	
				ShowUIPanel(QuickMountFrame);
			end
		else
			QM_Print("QuickMountEquip did not load. Please check your logs/FrameXML.log file and report this error");
		end
	else
		QuickMount_ShowUsage();
	end
end

function QuickMount_CheckPlayer()
	if QMCP == "" then
		local playername = UnitName("player");
		if playername == nil or playername == UKNOWNBEING or playername == UNKNOWNOBJECT then
			return false;
		end
		QMCP = GetCVar("realmName") .. "." .. playername;
		-- Convert old config
		if QuickMount_ButtonMap ~= nil and QuickMount_ButtonMap[1] ~= nil then
			QuickMount_ConfigMap = {};
			QuickMount_ConfigMap[QMCP] = QuickMount_ButtonMap;
			QuickMount_ConfigMap[QMCP]["Quiet"] = false;
		end
		if QuickMount_ConfigMap == nil or QuickMount_ConfigMap[QMCP] == nil then
			QuickMount_Reset();
		end
		QuickMount_UpdateAllSets();
		this:UnregisterEvent("UNIT_NAME_UPDATE");
	end
	if QMCP == "" or QMCP == "NONE" then
		return false;
	else
		return true;
	end
end

-- Reset QuickMount
function QuickMount_Reset()
	if QuickMount_CheckPlayer() == false then
		return;
      end
	if QuickMount_ConfigMap == nil then
		QuickMount_ConfigMap = {};
	end
	QuickMount_ConfigMap[QMCP]={index=nil;};
	for i=1,SET_COUNT,1 do
		QuickMount_ConfigMap[QMCP][i]={index=nil;};
		for j=1,SET_SIZE,1 do
			QuickMount_ConfigMap[QMCP][i][j]= {id=-1;bag=-1;slot=-1;texture="";name="";};
		end
		QuickMount_ConfigMap[QMCP]["Quiet"] = false;
	end
end

function QuickMount_GetBuffName(buffIndex)
	local x, y = GetPlayerBuff(buffIndex, "HELPFUL");
	QuickMountTooltip:SetUnitBuff("player", buffIndex);
      local Bname = QuickMountTooltipTextLeft1:GetText();
	if ( Bname ~= nil ) then
		return Bname;
	end
	return nil;
end

function QuickMount_GetItemName(bag, slot)
	local bagNumber = bag;
	local name = "";
	if ( type(bagNumber) ~= "number" ) then
		bagNumber = tonumber(bag);
	end
	if (bagNumber <= -1) then
		QuickMountTooltip:SetInventoryItem("player", slot);
	else
		QuickMountTooltip:SetBagItem(bag, slot);
	end
	name = QuickMountTooltipTextLeft1:GetText();
	if name == nil then
		name = "";
	end
	return name;
end

function QuickMount_WatchInventoryItems(button, ignoreshift)
	if button == "LeftButton" then
		if CursorHasItem() then
			QuickMount_ResetItem();
		else
			local slot = this:GetID();
			local texture = GetInventoryItemTexture("player", slot);
			if ( texture ) then
	      		local name = QuickMount_GetItemName(-1, slot)
				QuickMount_PickupItem(-1, slot, name, texture)
			end
		end
	else
		QuickMount_ResetItem();
	end
	if ( QuickMount_SavedInvFunc ) then
      	QuickMount_SavedInvFunc(button, ignoreshift);
	end
end

function QuickMount_WatchBagItems(button, ignoreshift)
	if button == "LeftButton" then
		if CursorHasItem() then
			QuickMount_ResetItem();
		else
      		local bag = this:GetParent():GetID();
      		local slot = this:GetID();
			local texture, itemCount, locked = GetContainerItemInfo(bag, slot);
			if ( texture ) then
	      		local name = QuickMount_GetItemName(bag, slot)
				QuickMount_PickupItem(bag, slot, name, texture)
			end
		end
	else
		QuickMount_ResetItem();
	end
	if ( QuickMount_SavedBagFunc ) then
		QuickMount_SavedBagFunc(button, ignoreshift);
	end
end

function QuickMount_OnLoad()
	-- Set the header
	local name = this:GetName();
	local header = getglobal(name.."TitleText");

	if ( header ) then 
		header:SetText("|cFFee9966Mount Equipment|r");
	end

      QuickMount_Reset();
	-- RegisterForSave("QuickMount_ConfigMap");
	QuickMount_RegisterEvents();

	if ( Sea and Sea.util and Sea.util.hook ) then
		Sea.util.hook("ContainerFrameItemButton_OnClick", "QuickMount_WatchBagItems", "before");
		Sea.util.hook("PaperDollItemSlotButton_OnClick", "QuickMount_WatchInventoryItems", "before");
	elseif ( HookFunction ) then
		HookFunction("ContainerFrameItemButton_OnClick", "QuickMount_WatchBagItems", "before");
		HookFunction("PaperDollItemSlotButton_OnClick", "QuickMount_WatchInventoryItems", "before");
	else
      	local temp = ContainerFrameItemButton_OnClick;
		if ( QuickMount_HookFunction("ContainerFrameItemButton_OnClick", "QuickMount_WatchBagItems") ) then
			QuickMount_SavedBagFunc = temp;
		end
	
		local temp = PaperDollItemSlotButton_OnClick;
		if ( QuickMount_HookFunction("PaperDollItemSlotButton_OnClick", "QuickMount_WatchInventoryItems") ) then
			QuickMount_SavedInvFunc = temp;
		end
	end

	-- Slash Commands
	SlashCmdList["MOUNTEQUIP"] = function(msg) QuickMount_Config(msg); end
	setglobal("SLASH_MOUNTEQUIP1", "/mountequip");

	if ( Cosmos_RegisterButton ) then
		Cosmos_RegisterButton (
			"Mount Equipment",
			"Auto-Equip Spurs",
			"This allows you to select \nequipment to be auto-equipped \nas you mount/dismount",
			"Interface\\Icons\\Ability_Mount_RidingHorse",
			QuickMount_Toggle,
			function()
				return true; -- The button is enabled
			end
		);
	end
end

function QuickMount_HookFunction(func, newfunc)
	local oldValue = getglobal(func);
	if ( oldValue ~= getglobal(newfunc) ) then
		setglobal(func, getglobal(newfunc));
		return true;
	end
	return false;
end

function QuickMount_ShowHelp()
	local helptext = getglobal("QuickMountFrameHelpText");
	if helptext then
		helptext:SetText("Drag Equipment you want auto-equipped into the squares. (Spurs, etc.) Shift click to clear item. Items that go in the same inventory slot should 'line up'. (Boots in slot 1, Trinkets in slot 2, etc.)");
	end
end

function QuickMount_OnShow()
	QuickMount_ShowHelp()
end

function QuickMount_OnEvent(event)
  local mounted = false
  local sheeped = false
  local clogged = false

  if event == "VARIABLES_LOADED" then
    QMCP = "";
    clogged = true;
  end

  if event == "UNIT_NAME_UPDATE" and arg1 == "player" then
    QMCP = "";
    clogged = true;
  end

  if QuickMount_CheckPlayer() == false then
    return;
  end

  if clogged == true or QuickMount_Disabled == true then
    return;
  end

  if event == "DELETE_ITEM_CONFIRM" then
    -- If the GUI frame is open, don't let them delete anything.
    if ( QuickMountFrame and QuickMountFrame:IsVisible() ) then 
      QuickMount_DropItem();
    end
    return;
  end

  if event == "PLAYER_REGEN_DISABLED" then
    combat_flag = true
  end
  if event == "PLAYER_REGEN_ENABLED" then
    combat_flag = false
  end

  -- Can't switch inventory while in combat, so ignore if in combat
  if combat_flag == false then
    local Pclass = UnitClass("player");
    for i = 1,16 do
      local buff_texture = UnitBuff("player", i)
      local debuff_texture = UnitDebuff("player", i)
      if debuff_texture and string.find(debuff_texture, "Polymorph") then
        sheeped = true
        return;
      end
	if Pclass == "Paladin" or Pclass == "Warlock" then
        -- Paladin/Warlock Mount... Hopefully no other buff uses the same texture...
	  if buff_texture and string.find(buff_texture, "Spell_Nature_Swiftness") then
	    mounted = true
          break;
        end
      end
      if buff_texture and ( string.find(buff_texture, "Mount") or string.find(buff_texture, "Foot_Kodo") ) then
        -- Make sure it isn't "Aspect of the xxx" or "Tiger's Fury"
        local BuffName = QuickMount_GetBuffName(i);
        local Skip = false;
        if BuffName and ( string.find(BuffName, "Aspect") or string.find(BuffName, "Tiger's Fury") ) then
          Skip = true
        end
        if Skip == false then
          mounted = true
          break;
        end
      end
    end

    -- Test for flight path. Search for an attack button and see if it's disabled. This assumes the
    --   only time attack is disabled outside of combat is because of flight paths.
    --     Whoops... Polymorph takes them out of combat, *and* disables attack. Bleh.
    if mounted == false and sheeped == false and attack_button ~= -1 then
	if attack_button == 0 then
        attack_button = -1
        -- Search for an attack button, and remember it.
        for i = 1,72 do
          if IsAttackAction(i) then
            attack_button = i
            break;
          end
        end
      end
	if attack_button ~= -1 then
        local isusable, mana = IsUsableAction(attack_button)
        if isusable == nil or isusable == false then
          mounted = true
        end
      end
    end

    -- Only attempt to equip if it's different from last time.
    if last_action == nil or last_action ~= mounted then
      last_action = mounted
      local row1, row2;
      if mounted then
        row1 = MOUNT;
	  row2 = UNMOUNT;
      else
        row1 = UNMOUNT;
	  row2 = MOUNT;
      end        
      items = "";
      for i in QuickMount_ConfigMap[QMCP][row1] do
	  local x, y;
        x = -1; y = -1;
	  if QuickMount_ConfigMap[QMCP][row1][i].id > 0 and QuickMount_ConfigMap[QMCP][row2][i].id > 0 then
          -- Swap Items
	    x, y = QuickMount_FindInvItem(QuickMount_ConfigMap[QMCP][row2][i].name, true);
	    if CursorHasItem() then
            x, y = QuickMount_FindBagItem(QuickMount_ConfigMap[QMCP][row1][i].name, true);
            if CursorHasItem() then
              y = -1;
              AutoEquipCursorItem();
            end
          else 
            x, y = QuickMount_FindBagItem(QuickMount_ConfigMap[QMCP][row1][i].name, true, true);
          end
        elseif QuickMount_ConfigMap[QMCP][row1][i].id > 0 then
          x, y = QuickMount_FindBagItem(QuickMount_ConfigMap[QMCP][row1][i].name, true, true);
        end
        if y >= 0 then
          items = items .. ' "' .. QuickMount_ConfigMap[QMCP][row1][i].name .. '"';
        end
      end
      if items ~= "" and QuickMount_ConfigMap[QMCP]["Quiet"] == false then
	      QM_Print("Equipped" .. items);
      end
    end -- last_action
  end -- combat_flag
end

function QM_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function QuickMount_ButtonLoad()
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");	
end

function QuickMount_FindBagItem(name, pickup, equip)
	if name == nil then
		return -1, -1;
	end
	-- Look in bags.
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (strupper(QuickMount_GetItemName(i, y)) == strupper(name)) then
				if pickup or equip then
					PickupContainerItem(i,y);
					if equip then
						AutoEquipCursorItem();
					end
				end
				return i,y;
			end
		end
	end

	return -1, -1;
end

function QuickMount_FindInvItem(name, pickup)
	if name == nil then
		return -1, -1;
	end

	-- Look in inventory.
	for i = 1, 19, 1 do
		if (strupper(QuickMount_GetItemName(-1, i)) == strupper(name)) then
			if pickup then
				PickupInventoryItem(i);
			end
			return -1, i;
		end
	end 

	return -1, -1;
end

function QuickMount_FindItem(bag, slot, name, pickup, equip)
	if name == nil then
		return -1, -1;
	end
	-- First look where it's suggested we look.
--[[  NOT WORKING... Cacheing problem?
	if (strupper(QuickMount_GetItemName(bag,slot)) == strupper(name)) then
		if pickup then
			if bag >= 0 then
				PickupContainerItem(bag,slot);
			else
				PickupInventoryItem(slot);
			end
		end
		return bag, slot;
	end
]]

      local x, y = QuickMount_FindBagItem(name, pickup, equip);
	
	if equip then
		return x, y;
	end

      if x < 0 then
		x, y = QuickMount_FindInvItem(name, pickup);
	end
	
	return x, y;
end

-- Erases the old button with the hand
function QuickMount_SetButton(row, col) 
	if QuickMount_CheckPlayer() == false then
		return;
	end
	-- Set the new button
	QuickMount_ConfigMap[QMCP][row][col] = {id=QuickMount_CurrentID,bag=QuickMount_CurrentBag,slot=QuickMount_CurrentSlot,name=QuickMount_CurrentName,texture=QuickMount_CurrentTexture};
	QuickMount_DropItem();

	QuickMount_ButtonUpdate(this);	
end

-- Swaps the specified button into hand
function QuickMount_SwapButton(row,col)
	if QuickMount_CheckPlayer() == false then
		return;
	end
	-- Store the old value if one exists
	local temp = nil;
	if ( QuickMount_ConfigMap[QMCP][row][col].id > 0 ) then 
		temp = QuickMount_ConfigMap[QMCP][row][col];
	end

	-- Drop the current button
	QuickMount_SetButton(row, col);
	
	-- Load the old one into the cursor
	if ( temp ) then 
		if ( temp.id > 0 ) then
			local bag, slot = QuickMount_FindItem(temp.bag, temp.slot, temp.name, true);
			QuickMount_PickupItem(bag, slot, temp.name, temp.texture);
		end
	end
end


-- Button Event Handler
function QuickMount_ButtonEvent(event)
end

-- Move the Equipment around
function QuickMount_ButtonDragStart()
	local col, row = QuickMount_GetCurrentLocation(this);		

	-- Pick up the current item
	QuickMount_SwapButton(row,col);
end

--
-- Swap or pick up if clicked with or without a full hand
-- 
function QuickMount_ButtonClick(button)
	if QuickMount_CheckPlayer() == false then
		return;
	end
	local col, row = QuickMount_GetCurrentLocation(this);		

      if IsShiftKeyDown() then
		QuickMount_ConfigMap[QMCP][row][col] = {id=-1;bag=-1;slot=-1;texture="";name="";};
		QuickMount_ButtonUpdate(this);
	elseif IsAltKeyDown() then
		-- PrintTable(QuickMount_ConfigMap[QMCP][row][col]);
	else
		-- Pick up the current item
		QuickMount_SwapButton(row,col);
	end
end

function QuickMount_ButtonDragEnd()
	if QuickMount_CheckPlayer() == false then
		return;
	end
	if( QuickMount_CurrentID > 0 ) then
		local col, row = QuickMount_GetCurrentLocation(this);		
		QuickMount_SwapButton(row,col);
	end
end

-- Displays the tooltip of the item in the box.
function QuickMount_ButtonEnter()
	if QuickMount_CheckPlayer() == false then
		return;
	end
	local col, row = QuickMount_GetCurrentLocation(this);		

	local id = QuickMount_ConfigMap[QMCP][row][col].id;
	local tooltip = QuickMount_ConfigMap[QMCP][row][col].name;

	if ( id > 0 ) then 
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		if ( GameTooltip:SetText(tooltip) ) then
			this.updateTooltip = TOOLTIP_UPDATE_TIME;
		else
			this.updateTooltip = nil;
		end	
	end
end

function QuickMount_ButtonLeave()
	GameTooltip:Hide();
end

function QuickMount_ButtonLoad()
end

-- Self Texture Button
function QuickMount_SetSelfTexture(button, row, col)
	if QuickMount_CheckPlayer() == false then
		return;
	end 
	local name = button:GetName();	
	local icon = getglobal(name.."Icon");

	if (  QuickMount_ConfigMap[QMCP][row] == nil ) then return end
	local id = QuickMount_ConfigMap[QMCP][row][col].id;

	if ( id > 0 ) then 
		-- Set the pretty texture
		local texture = QuickMount_ConfigMap[QMCP][row][col].texture;
		if ( texture ) then
			icon:SetTexture(texture);
			icon:Show();
		else
			icon:Hide();
		end
	else
		icon:Hide();
	end
end	

-- Button Update
function QuickMount_ButtonUpdate(button)
	-- Check the button
	if ( button == nil ) then return; end
	
	-- Uncheck it
	button:SetChecked("false");
	local col, row = QuickMount_GetCurrentLocation(button);

	-- Check for errors
	if ( col == nil or row == nil ) then return; end
	
	-- Enable the button
	button:Enable();
	QuickMount_SetSelfTexture(button, row, col);
end

function QuickMount_UpdateSet(setbasename,set,size)
	if set == nul then return; end

	for i=1,size,1 do
		QuickMount_ButtonUpdate(getglobal(setbasename..set..i));
	end
end

function QuickMount_UpdateAllSets()
	for set=1,SET_COUNT,1 do
		QuickMount_UpdateSet("QuickMountButtonSet",set,SET_SIZE);
	end
end

-- Tracks the last spell picked up
function QuickMount_PickupItem(bag, slot, name, texture) 
	QuickMount_CurrentID = 1;
	QuickMount_CurrentBag = bag;
	QuickMount_CurrentSlot = slot;
	QuickMount_CurrentName = name;
	QuickMount_CurrentTexture = texture;
end

function QuickMount_ResetItem()
	QuickMount_CurrentID = -1;
	QuickMount_CurrentBag = -1;
	QuickMount_CurrentSlot = -1;
	QuickMount_CurrentName = "";
	QuickMount_CurrentTexture = "";
end

function QuickMount_DropItem()
	if CursorHasItem() then
		if QuickMount_CurrentBag >= 0 then
			PickupContainerItem(QuickMount_CurrentBag,QuickMount_CurrentSlot);
      	elseif QuickMount_CurrentSlot >= 0 then
			PickupInventoryItem(QuickMount_CurrentSlot);
		end
	end
	QuickMount_ResetItem();
end

-- Returns the current button location
function QuickMount_GetCurrentLocation(object)
	return object:GetID(), object:GetParent():GetID();
end



