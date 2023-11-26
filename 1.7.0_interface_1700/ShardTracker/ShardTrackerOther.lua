--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              UTILITY FUNCTIONS                                             --
--                                                                                            --
--============================================================================================--
--============================================================================================--


---------------------------------------------------------------------------------
--
-- Put an item into a free bag slot
-- 
---------------------------------------------------------------------------------
function ShardTracker_BagItem()

    -- for each bag and slot
    for theBag = 0, 4, 1 do
        local numSlot = GetContainerNumSlots(theBag);
        for theSlot = 1, numSlot, 1 do
        
            -- get info about the item here
            local texture, itemCount, locked = GetContainerItemInfo(theBag, theSlot);
            
            -- if we found nothing, put the item in this slot
            if (not texture) then
                PickupContainerItem(theBag,theSlot);
                return true;
            end
        end
    end
    
    AutoEquipCursorItem();
    
    return false;
end


---------------------------------------------------------------------------------
--
-- Return true if the item in the player's main hand is two handed
-- 
---------------------------------------------------------------------------------
function ShardTracker_IsWeaponTwoHanded()

    -- get the id number for the item slot
    local id = GetInventorySlotInfo("MainHandSlot");

    -- point the tooltip at this slot
    ShardTracker_MoneyToggle();
    local hasItem = ShardTrackerTooltip:SetInventoryItem("player", id);
    ShardTracker_MoneyToggle();
    if (hasItem) then
        local itemName1 = "";    
        ShardTracker_MoneyToggle();
        ttext = getglobal("ShardTrackerTooltipTextLeft2");
        if (ttext and ttext:IsVisible() and ttext:GetText() ~= nil) then
            itemName1 = ttext:GetText();
        end
        ShardTracker_MoneyToggle();
        local itemName2 = "";    
        ShardTracker_MoneyToggle();
        ttext = getglobal("ShardTrackerTooltipTextLeft3");
        if (ttext and ttext:IsVisible() and ttext:GetText() ~= nil) then
            itemName2 = ttext:GetText();
        end
        ShardTracker_MoneyToggle();

        if (itemName1 == "Two-Hand" or itemName2 == "Two-Hand") then
            return true;
        end
    end
    
    return false;
end

-----------------------------------------------------------------------------------
--
-- Return the name of the item in the specified bag and slot
--
-----------------------------------------------------------------------------------
function ShardTracker_GetItemNameInBagSlot(theBag, theSlot, clearToolTip)

    local itemName = nil;
    
    -- point our tooltip at this item so we can read its name, etc
    ShardTracker_MoneyToggle();
    getglobal("ShardTrackerTooltip"):SetBagItem(theBag, theSlot);
    local ttext = getglobal("ShardTrackerTooltipTextLeft1");
    ShardTracker_MoneyToggle();

    -- if the tooltip had info, store it
    if (ttext and ttext:IsVisible() and ttext:GetText() ~= nil) then
        itemName = ttext:GetText();
    end
    
    if (clearToolTip) then
        ShardTracker_MoneyToggle();
        ShardTracker_ClearTooltip("ShardTrackerTooltip");
        ShardTracker_MoneyToggle();
    end
    return itemName;
end


-----------------------------------------------------------------------------------
--
-- Clear out the specified tooltip
--
-----------------------------------------------------------------------------------
function ShardTracker_ClearTooltip(theToolTip)
    for i = 1, 15 do
        getglobal(theToolTip.."TextLeft"..i):SetText("");
        getglobal(theToolTip.."TextRight"..i):SetText("");
    end     
end

-----------------------------------------------------------------------------------
--
-- Return the name of the item in the specified tooltip text
--
-----------------------------------------------------------------------------------
function ShardTracker_GetItemName(itemTip)
    if (type(itemTip) ~= "table") then
        return itemTip;
    elseif (type(itemTip[1]) == "table") then
        return itemTip[1]["left"];
    else
        return "NIL";
    end
end


-----------------------------------------------------------------------------------
--
-- Return the bag, slot location of the specified item
--
-----------------------------------------------------------------------------------
function ShardTrackerFindItemBagSlotByName(theItemName)
    
    -- for each bag
    for bag = 4, 0, -1 do
        local size = GetContainerNumSlots(bag);
        if (size > 0) then
        
            -- for each slot in the bag
            for slot=1, size, 1 do
            
                -- get info about the item in this slot
                local texture, itemCount = GetContainerItemInfo(bag, slot);
                if (itemCount) then
                    local itemName = ShardTracker_GetItemNameInBagSlot(bag, slot, false);
                                            
                    -- if the item has a name
                    if (itemName ~= "") then

                        -- if the item is a soul shard, increase the count
                        if (itemName == theItemName) then
                            return bag, slot;
                        end
                    end
                end
            end
        end
    end
    
    return nil, nil;
end


-----------------------------------------------------------------------------------
--
-- Given a player's name, return their party member number
--
-----------------------------------------------------------------------------------
function ShardTracker_GetPartyMemberNumber(theName)
    local numberOfPartyMembers = GetNumPartyMembers();
    for i = 1, numberOfPartyMembers do
        if (UnitName("party"..i) == theName) then
            return i
        end
    end
    return 0
end


-----------------------------------------------------------------------------------
--
-- Create a list of spell IDs for spells we might want to cast (such as Create Healthstone)
--
-----------------------------------------------------------------------------------
function ShardTracker_BuildSpellTable()

    ShardTracker_CreateSoulStoneSpellID   = nil;
    ShardTracker_CreateHealthStoneSpellID = nil;
    ShardTracker_CreateSpellStoneSpellID = nil;
    ShardTracker_CreateFireStoneSpellID = nil;
    
    -- as we look through the spellbook, these variables will
    -- allow us to remember the highest level of a spell that
    -- we're found overall, since we only want to cast the
    -- highest level create health/soulstone spell
    local HighestSoulstoneSpellLevelSeen = 0;
    local HighestHealthstoneSpellLevelSeen = 0;
    local HighestSpellstoneSpellLevelSeen = 0;
    local HighestFirestoneSpellLevelSeen = 0;
    local spellLevel = 0;
    
    -- for all 180 possible spell entries
    for id = 1, 180 do 
        local spellName, subSpellName = GetSpellName(id, "spell");
        if (spellName) then
        
            -- find the highest level healthstone we can make
            if (string.find(spellName, SHARDTRACKER_HEALTHSTONE, 1, true)) then
                spellLevel = 0;
                if (spellName == SHARDTRACKER_CREATEHEALTHSTONEMINOR) then
                    spellLevel = 1;
                elseif (spellName == SHARDTRACKER_CREATEHEALTHSTONELESSER) then
                    spellLevel = 2;
                elseif (spellName == SHARDTRACKER_CREATEHEALTHSTONE) then
                    spellLevel = 3;
                elseif (spellName == SHARDTRACKER_CREATEHEALTHSTONEGREATER) then
                    spellLevel = 4;
                elseif (spellName == SHARDTRACKER_CREATEHEALTHSTONEMAJOR) then
                    spellLevel = 5;
                end
                if (spellLevel > HighestHealthstoneSpellLevelSeen) then
                    ShardTracker_CreateHealthStoneSpellID = id;
                    HighestHealthstoneSpellLevelSeen = spellLevel;
                end
                
            -- find the highest level soulstone we can make
            elseif (string.find(spellName, SHARDTRACKER_SOULSTONE, 1, true)) then
                spellLevel = 0;
                if (spellName == SHARDTRACKER_CREATESOULSTONEMINOR) then
                    spellLevel = 1;
                elseif (spellName == SHARDTRACKER_CREATESOULSTONELESSER) then
                    spellLevel = 2;
                elseif (spellName == SHARDTRACKER_CREATESOULSTONE) then
                    spellLevel = 3;
                elseif (spellName == SHARDTRACKER_CREATESOULSTONEGREATER) then
                    spellLevel = 4;
                elseif (spellName == SHARDTRACKER_CREATESOULSTONEMAJOR) then
                    spellLevel = 5;
                end
                if (spellLevel > HighestSoulstoneSpellLevelSeen) then
                    ShardTracker_CreateSoulStoneSpellID = id;
                    HighestSoulstoneSpellLevelSeen = spellLevel;
                end
                
            -- find the highest level spellstone we can make
            elseif (string.find(spellName, SHARDTRACKER_SPELLSTONE, 1, true)) then
                spellLevel = 0;
                if (spellName == SHARDTRACKER_CREATESPELLSTONE) then
                    spellLevel = 3;
                elseif (spellName == SHARDTRACKER_CREATESPELLSTONEGREATER) then
                    spellLevel = 4;
                elseif (spellName == SHARDTRACKER_CREATESPELLSTONEMAJOR) then
                    spellLevel = 5;
                end
                if (spellLevel > HighestSpellstoneSpellLevelSeen) then
                    ShardTracker_CreateSpellStoneSpellID = id;
                    HighestSpellstoneSpellLevelSeen = spellLevel;
                end
                
            -- find the highest level firestone we can make
            elseif (string.find(spellName, SHARDTRACKER_FIRESTONE, 1, true)) then
                spellLevel = 0;
                if (spellName == SHARDTRACKER_CREATEFIRESTONELESSER) then
                    spellLevel = 2;
                elseif (spellName == SHARDTRACKER_CREATEFIRESTONE) then
                    spellLevel = 3;
                elseif (spellName == SHARDTRACKER_CREATEFIRESTONEGREATER) then
                    spellLevel = 4;
                elseif (spellName == SHARDTRACKER_CREATEFIRESTONEMAJOR) then
                    spellLevel = 5;
                end
                if (spellLevel > HighestFirestoneSpellLevelSeen) then
                    ShardTracker_CreateFireStoneSpellID = id;
                    HighestFirestoneSpellLevelSeen = spellLevel;
                end
            end
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Our own print function
--
-----------------------------------------------------------------------------------
function ShardTrackerPrint(theMsg, r, g, b)
    
    -- 0.73, 0.53, 0.87
    if (r == nil) then r = 0.73; end
    if (g == nil) then g = 0.53; end
    if (b == nil) then b = 0.87; end

    Print(theMsg, r, g, b);
end


-----------------------------------------------------------------------------------
--
-- Show the info text
--
-----------------------------------------------------------------------------------
function ShardTracker_ShowInfoMessage()
    DEFAULT_CHAT_FRAME:AddMessage(" ");
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG1);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG2);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG3);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG4);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG5);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_LTGREEN..ST_SHOWINFO_MSG6..SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT..ST_SHOWINFO_MSG6a);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG7..SHARDTRACKER_CONFIG.THE_SORT_BAG..ST_SHOWINFO_MSG7a);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_LTGREEN..ST_SHOWINFO_MSG8);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG9);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_LTGREEN..ST_SHOWINFO_MSG10);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG11);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG12);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG13);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG14);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_LTGREEN..ST_SHOWINFO_MSG15);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG16);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_LTGREEN..ST_SHOWINFO_MSG15a);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG16a);
    ShardTracker_AddHelpMessage("");
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG17);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG18);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG19);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG20);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_GREEN..ST_SHOWINFO_MSG21);
    ShardTracker_AddHelpMessage("");
end


-----------------------------------------------------------------------------------
--
-- Show the help text
--
-----------------------------------------------------------------------------------
function ShardTracker_ShowHelp()

    if (ShardTracker_DragLock) then
        lockedText = "Locked";
    else
        lockedText = "Unlocked";
    end
    
    local warlock;
    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
        warlock = true;
    else
        warlock = false;
    end
    
    local soulSound;
    if (SHARDTRACKER_CONFIG.SOULSOUND == "") then
        soulSound = "default sound";
    else
        soulSound = SHARDTRACKER_CONFIG.SOULSOUNDNAME;
    end
    local healthSound;
    if (SHARDTRACKER_CONFIG.HEALTHSOUND == "") then
        healthSound = "default sound";
    else
        healthSound = SHARDTRACKER_CONFIG.HEALTHSOUNDNAME;
    end
    if (SHARDTRACKER_CONFIG.MAXSHARDS == 0) then
        maxShardTxt = "unlimited";
    else
        maxShardTxt = tostring(SHARDTRACKER_CONFIG.MAXSHARDS);
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(" ");
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..ST_HELP_MSG1..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.."Version "..SHARDTRACKER_VERSION, nil, nil, nil);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..ST_HELP_MSG1A, nil, nil, nil);
    ShardTracker_AddHelpMessage(SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..ST_HELP_MSG2, nil, nil, nil);
    DEFAULT_CHAT_FRAME:AddMessage(SHARDTRACKER_COLOR_GREEN..ST_HELP_MSG3..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..ST_HELP_MSG4..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..ST_HELP_MSG5..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..ST_HELP_MSG6..SHARDTRACKER_COLOR_CLOSE);
    ShardTracker_AddHelpMessage("  "..SHARDTRACKER_ON_CMD.."|"..SHARDTRACKER_OFF_CMD, ST_HELP_MSG7, nil, SHARDTRACKER_CONFIG.ENABLED);
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_TOGGLE_CMD.." [shards | healthstone | soulstone | spellstone | firestone]", ST_HELP_MSG8, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_MONITOR_CMD.." on|off", ST_HELP_MSG9, nil, SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_BAG_CMD.." [0-4]", ST_HELP_MSG10, SHARDTRACKER_CONFIG.THE_SORT_BAG, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SORT_CMD, ST_HELP_MSG11, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_LIMIT_CMD.." [0-20]", ST_HELP_MSG12, SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SOUND_CMD.." on|off", ST_HELP_MSG13, nil, SHARDTRACKER_CONFIG.USE_SOUND); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SOUL_POPUP_CMD.." on|off", ST_HELP_MSG14, nil, SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SHARDBG_CMD.." on|off", ST_HELP_MSG15, nil, SHARDTRACKER_CONFIG.SHOW_SHARD_BG); end
    ShardTracker_AddHelpMessage("  "..SHARDTRACKER_FLASH_CMD.." on|off", ST_HELP_MSG16, nil, SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE);
    ShardTracker_AddHelpMessage("  "..SHARDTRACKER_UNLOCK_CMD, ST_HELP_MSG17, lockedText, true);
    ShardTracker_AddHelpMessage("  "..SHARDTRACKER_LOCK_CMD, ST_HELP_MSG18, lockedText, true);
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_RESET_CMD, ST_HELP_MSG19, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_CENTER_CMD, ST_HELP_MSG20, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SCALE_CMD.." "..SHARDTRACKER_SCALE_1_CMD.."|"..SHARDTRACKER_SCALE_2_CMD.."|"..SHARDTRACKER_SCALE_3_CMD.."|"..SHARDTRACKER_SCALE_4_CMD, ST_HELP_MSG21, SHARDTRACKER_CONFIG.BUTTONSCALE, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_RESTRICT_CMD.." on|off", ST_HELP_MSG22, nil, SHARDTRACKER_CONFIG.LIST_RESTRICT); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_ADD_CMD, ST_HELP_MSG23, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_REMOVE_CMD, ST_HELP_MSG24, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_LIST_CMD, ST_HELP_MSG25, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SOULSOUND_CMD.." <0-"..table.getn(SHARDTRACKER_SOUNDLIST).."> | <exactSoundFileName.ext>", ST_HELP_MSG29, soulSound, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_HEALTHSOUND_CMD.." <0-"..table.getn(SHARDTRACKER_SOUNDLIST).."> | <exactSoundFileName.ext>", ST_HELP_MSG30, healthSound, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_LIST_CMD, ST_HELP_MSG25, nil, nil); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_FLASHY_CMD.." on|off", ST_HELP_MSG31, nil, SHARDTRACKER_CONFIG.FLASHY_GRAPHICS); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_NAGSOUL_CMD.." on|off", ST_HELP_MSG32, nil, SHARDTRACKER_CONFIG.NAGSOUL); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_NAGHEALTH_CMD.." on|off", ST_HELP_MSG33, nil, SHARDTRACKER_CONFIG.NAGHEALTH); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_NAGFREQ_CMD.." (1 - 180)", ST_HELP_MSG34, SHARDTRACKER_CONFIG.NAGFREQ, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_NAGCOUNT_CMD.." (0 - 20)", ST_HELP_MSG35, SHARDTRACKER_CONFIG.NAGCOUNT, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_MAXSHARDS_CMD.." (0 - N)", ST_HELP_MSG36, maxShardTxt, true); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_NIGHTFALL_CMD.." on|off", ST_HELP_MSG37, nil, SHARDTRACKER_CONFIG.NIGHTFALLEFFECT); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_SHARDEFFECT_CMD.." on|off", ST_HELP_MSG38, nil, SHARDTRACKER_CONFIG.SHARDEFFECT); end
    if (warlock) then ShardTracker_AddHelpMessage("  "..SHARDTRACKER_AUTOSORT_CMD.." on|off", ST_HELP_MSG39, nil, SHARDTRACKER_CONFIG.AUTOSORT); end

    ShardTracker_AddHelpMessage("  "..SHARDTRACKER_INFO_CMD, ST_HELP_MSG26, nil, nil);
    ShardTracker_AddHelpMessage("  "..SHARDTRACKER_HELP_CMD, ST_HELP_MSG27, nil, nil);
    DEFAULT_CHAT_FRAME:AddMessage(" ");
    ShardTracker_AddHelpMessage(ST_HELP_MSG28, nil, nil, nil);
end

-----------------------------------------------------------------------------------
--
-- Prints a formatted help message
--
-----------------------------------------------------------------------------------
function ShardTracker_AddHelpMessage(command, detail, status, enabled)

    local message = "";
    
    if (detail == nil) then
        message = SHARDTRACKER_COLOR_VIOLET..command..SHARDTRACKER_COLOR_CLOSE;
    else
        message = SHARDTRACKER_COLOR_VIOLET..command..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..": "..detail..SHARDTRACKER_COLOR_CLOSE;
    end
    
    if (enabled == nil) then
        DEFAULT_CHAT_FRAME:AddMessage(message);
        return;
    end
    
    if (status == "" or status == nil) then
        if (enabled and enabled ~= 0) then
            DEFAULT_CHAT_FRAME:AddMessage(message..SHARDTRACKER_COLOR_VIOLET..ST_HELP_ENABLED..SHARDTRACKER_COLOR_CLOSE);
        else
            DEFAULT_CHAT_FRAME:AddMessage(message..SHARDTRACKER_COLOR_GREY..ST_HELP_DISABLED..SHARDTRACKER_COLOR_CLOSE);
        end
    else
        if (enabled and enabled ~= 0) then
            DEFAULT_CHAT_FRAME:AddMessage(message..SHARDTRACKER_COLOR_VIOLET.." (set to "..status..")"..SHARDTRACKER_COLOR_CLOSE);
        else
            DEFAULT_CHAT_FRAME:AddMessage(message..SHARDTRACKER_COLOR_CLOSE.." (set to "..status..")"..SHARDTRACKER_COLOR_CLOSE);
        end     
    end
end




--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              TOGGLING FUNCTIONS                                    --
--                                                                                            --
--============================================================================================--
--============================================================================================--



-----------------------------------------------------------------------------------
--
-- Toggle on or off nagging
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleNagging(nagType, toggleCommand, slashCmd)
    local toggle = nil;
    
    if (toggleCommand == nil or toggleCommand == "") then
        if (nagType == SHARDTRACKER_NAGSOUL_CMD) then
            if (SHARDTRACKER_CONFIG.NAGSOUL == true) then
                toggle = false;
            else
                toggle = true;
            end    
        elseif (nagType == SHARDTRACKER_NAGHEALTH_CMD) then
            if (SHARDTRACKER_CONFIG.NAGHEALTH == true) then
                toggle = false;
            else
                toggle = true;
            end    
        end
    elseif (toggleCommand == "on") then
        toggle = true;
    elseif (toggleCommand == "off") then
        toggle = false;
    else
        return;
    end
    
    if (toggle ~= nil) then
        if (nagType == SHARDTRACKER_NAGSOUL_CMD) then
            SHARDTRACKER_CONFIG.NAGSOUL = toggle;
            if (slashCmd) then
                if (toggle) then
                    ShardTrackerPrint(ST_SOULNAGON);
                else
                    ShardTrackerPrint(ST_SOULNAGOFF);
                end
            end    
        elseif (nagType == SHARDTRACKER_NAGHEALTH_CMD) then
            SHARDTRACKER_CONFIG.NAGHEALTH = toggle;
            if (slashCmd) then
                if (toggle) then
                    ShardTrackerPrint(ST_HEALTHNAGON);
                else
                    ShardTrackerPrint(ST_HEALTHNAGOFF);
                end
            end
        end
        
        if (not Chronos) then ShardTrackerPrint(ST_NEEDCHRONOS); end
    end
end


-----------------------------------------------------------------------------------
--
-- Set the number of times to Nag before giving up
--
-----------------------------------------------------------------------------------
function ShardTracker_SetNagCount(theCount)
    theCount = tonumber(theCount);
    if (type(theCount) ~= "number") then return; end
    
    if (theCount < 0) then theCount = 0; end
    if (theCount > 20) then theCount = 20; end
    
    SHARDTRACKER_CONFIG.NAGCOUNT = theCount;
    if (theCount == 0) then
        ShardTrackerPrint(ST_NAGCOUNT1..ST_NAGCOUNT3);
    else
        ShardTrackerPrint(ST_NAGCOUNT1..theCount..ST_NAGCOUNT2);
    end
    
    if (not Chronos) then ShardTrackerPrint(ST_NEEDCHRONOS); end

end


-----------------------------------------------------------------------------------
--
-- Set the number of seconds between nags
--
-----------------------------------------------------------------------------------
function ShardTracker_SetNagFreq(theFreq)
    theFreq = tonumber(theFreq);
    if (type(theFreq) ~= "number") then return; end

    if (theFreq < 1) then theFreq = 1; end
    if (theFreq > 180) then theFreq = 180; end
    
    SHARDTRACKER_CONFIG.NAGFREQ = theFreq;
    ShardTrackerPrint(ST_NAGINTERVAL1..theFreq..ST_NAGINTERVAL2);
    
    if (not Chronos) then ShardTrackerPrint(ST_NEEDCHRONOS); end
end


-----------------------------------------------------------------------------------
--
-- Set the max number of soul shards allowed in inventory
--
-----------------------------------------------------------------------------------
function ShardTracker_SetMaxShards(theNum)
    theNum = tonumber(theNum);
    if (type(theNum) ~= "number") then 
        ShardTrackerPrint(ST_MAXSHARDSERROR);
        return
    end

    if (theNum < 0) then theNum = 0; end
    
    SHARDTRACKER_CONFIG.MAXSHARDS = theNum;
    if (theNum == 0) then
        ShardTrackerPrint(ST_MAXSHARDSSETUNLIMITED);    
    else
        ShardTrackerPrint(ST_MAXSHARDSSET1..theNum..".  "..ST_MAXSHARDSSET2);    
    end    
end


-----------------------------------------------------------------------------------
--
-- Toggle on or off advanced graphics
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleFlashyGraphics(toggle, slashCmd)
 
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.FLASHY_GRAPHICS == true) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if ((toggle == 1 or toggle == true) and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.FLASHY_GRAPHICS = true;
        if (slashCmd == true) then ShardTrackerPrint(ST_FLASHYGRAPHICSON); end
        ShardTracker_ToggleAllFlashyGraphicsVisibility(true);
    else
        SHARDTRACKER_CONFIG.FLASHY_GRAPHICS = false;
        if (slashCmd == true) then ShardTrackerPrint(ST_FLASHYGRAPHICSOFF); end
        ShardTracker_ToggleAllFlashyGraphicsVisibility(false);
    end
end


-----------------------------------------------------------------------------------
--
-- Toggle auto sorting
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleAutoSorting(toggle, slashCmd)
 
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.AUTOSORT == true) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if ((toggle == 1 or toggle == true or toggle == "on") and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.AUTOSORT = true;
        if (slashCmd == true) then ShardTrackerPrint(ST_AUTOSORTON); end
    else
        SHARDTRACKER_CONFIG.AUTOSORT = false;
        if (slashCmd == true) then ShardTrackerPrint(ST_AUTOSORTOFF); end
    end
end



-----------------------------------------------------------------------------------
--
-- Toggle on or off the Nightfall visuals (making the screen glow purple)
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleNighfallEffect(toggle, slashCmd)
 
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.NIGHTFALLEFFECT == true) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if ((toggle == 1 or toggle == true or toggle == "on") and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.NIGHTFALLEFFECT = true;
        if (slashCmd == true) then ShardTrackerPrint(ST_NIGHTFALLEFFECTON); end
    else
        SHARDTRACKER_CONFIG.NIGHTFALLEFFECT = false;
        if (slashCmd == true) then ShardTrackerPrint(ST_NIGHTFALLEFFECTOFF); end
    end
end


-----------------------------------------------------------------------------------
--
-- Toggle on or off the shard creation visuals (making the screen flash pink)
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleShardCreationVisual(toggle, slashCmd)
 
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.SHARDEFFECT == true) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if ((toggle == 1 or toggle == true or toggle == "on") and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.SHARDEFFECT = true;
        if (slashCmd == true) then ShardTrackerPrint(ST_SHARDEFFECTON); end
    else
        SHARDTRACKER_CONFIG.SHARDEFFECT = false;
        if (slashCmd == true) then ShardTrackerPrint(ST_SHARDEFFECTOFF); end
    end
end


-----------------------------------------------------------------------------------
--
-- Toggle the visibility of the advanced graphics elements
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleAllFlashyGraphicsVisibility(toggle)
    
    -- toggle the glowies behind party member portraits
    for p = 1, 4 do
        local gname2 = "PartyMemberFrame"..tostring(p).."ShardTrackerGlowFrame";
        if (toggle) then
            getglobal(gname2):Show();
        else
            getglobal(gname2):Hide();
        end
    end
    
    -- toggle the soulstone alert glowy behind the minimap
    if (toggle) then
        ShardTrackerRadarSoulGlowFrame:Show();
    else
        ShardTrackerRadarSoulGlowFrame:Hide();
    end
end


-----------------------------------------------------------------------------------
--
-- Toggle on or off flashing healthstones
--
-----------------------------------------------------------------------------------
function ShardTracker_Toggle_Flash_Health(toggle, slashCmd)
    if (not toggle or toggle == "") then
        if (SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1 and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 1;
        if (slashCmd == true) then ShardTrackerPrint(ST_HEALTHSTONEFLASH); end
        if (UnitClass("player") ~= SHARDTRACKER_WARLOCK) then
            ShardTracker_HealthStoneButton:Show();
        end
    else
        SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 0;
        if (slashCmd == true) then ShardTrackerPrint(ST_HEALTHSTONEFLASHOFF); end
        ShardTracker_HealthStoneButton:SetAlpha(1.0);
        if (UnitClass("player") ~= SHARDTRACKER_WARLOCK) then
            ShardTracker_HealthStoneButton:Hide();
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Handle the toggling on and off of various aspects of the plugin
--
-----------------------------------------------------------------------------------
function ShardTracker_Toggle_Shards(toggle)
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1 and UnitClass("player") == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED = 1;
        ShardTracker_ShardButton:Show();
        ShardTracker_ShardCountLabel:Show();
    else
        SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED = 0;
        ShardTracker_ShardButton:Hide();
        ShardTracker_ShardCountLabel:Hide();
        ShardTracker_ShardButton:SetAlpha(1.0);
        ShardTracker_ShardCountLabel:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle_Health(toggle)
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1 and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED = 1;
        ShardTracker_HealthStoneButton:Show();
    else
        SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED = 0;
        ShardTracker_HealthStoneButton:Hide();
    end
end
function ShardTracker_Toggle_Soul(toggle)
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1 and UnitClass("player") == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED = 1;
        --if (ShardTracker_HaveSoulStone == 1) then
            ShardTracker_SoulStoneButton:Show();
            ShardTracker_SoulStoneText:Show();
        --end
    else
        SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED = 0;
        ShardTracker_SoulStoneButton:Hide();
        ShardTracker_SoulStoneButton:SetAlpha(1.0);
        ShardTracker_SoulStoneText:Hide();
        ShardTracker_SoulStoneText:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle_Spell(toggle)
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1 and UnitClass("player") == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED = 1;
        ShardTracker_SpellStoneButton:Show();
        ShardTracker_SpellStoneText:Show();
    else
        SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED = 0;
        ShardTracker_SpellStoneButton:Hide();
        ShardTracker_SpellStoneButton:SetAlpha(1.0);
        ShardTracker_SpellStoneText:Hide();
        ShardTracker_SpellStoneText:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle_Fire(toggle)
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1 and UnitClass("player") == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED = 1;
        ShardTracker_FireStoneButton:Show();
    else
        SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED = 0;
        ShardTracker_FireStoneButton:Hide();
        ShardTracker_FireStoneButton:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle(toggle)
    if (toggle == nil or toggle == "") then
        if (SHARDTRACKER_CONFIG.ENABLED == 1 and not SHARDTRACKER_FIRST_TIME.ENABLED) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1) then
        if (not SHARDTRACKER_FIRST_TIME.ENABLED and (SHARDTRACKER_CONFIG.ENABLED ~= toggle)) then
            ShardTrackerPrint("ShardTracker: Enabled");
        else
            SHARDTRACKER_FIRST_TIME.ENABLED = false;
        end
    else
        if (SHARDTRACKER_CONFIG.ENABLED ~= toggle) then
            ShardTrackerPrint("ShardTracker: Disabled");
        end
    end
    
    SHARDTRACKER_CONFIG.ENABLED = toggle;
    
    ShardTracker_Toggle_Shards(toggle);
    ShardTracker_Toggle_Health(toggle);
    ShardTracker_Toggle_Soul(toggle);   
    ShardTracker_Toggle_Spell(toggle);
    ShardTracker_Toggle_Fire(toggle);
    
    ShardTrackerDebug("Toggle: SHARDTRACKER_CONFIG.ENABLED = "..SHARDTRACKER_CONFIG.ENABLED);
    ShardTrackerDebug("Toggle: SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED = "..SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED);
    ShardTrackerDebug("Toggle: SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED = "..SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED);
    ShardTrackerDebug("Toggle: SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED = "..SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED);
    ShardTrackerDebug("Toggle: SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED = "..SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED);
    ShardTrackerDebug("Toggle: SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED = "..SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED);

end

-----------------------------------------------------------------------------------
--
-- Process the toggle slash command
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleSlashCommand(var)
    if (var == "shards") then
        ShardTracker_Toggle_Shards();
    elseif (var == "healthstone") then
        ShardTracker_Toggle_Health();
    elseif (var == "soulstone") then
        ShardTracker_Toggle_Soul();   
    elseif (var == "spellstone") then
        ShardTracker_Toggle_Spell();
    elseif (var == "firestone") then
        ShardTracker_Toggle_Fire();
    elseif (var == "") then
        ShardTracker_Toggle();
    else
        ShardTrackerPrint(ST_TOGGLEUSAGE);
    end
end

-----------------------------------------------------------------------------------
--
-- Toggle Debug Messages
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleDebug()
    SHARDTRACKER_DEBUG = (not SHARDTRACKER_DEBUG);
    if (SHARDTRACKER_DEBUG) then
        ShardTrackerPrint("ShardTracker: Debug On");
    else
        ShardTrackerPrint("ShardTracker: Debug Off");
    end
end


function ShardTracker_PrintRiddle()
    if (message) then
        message("What's tall as a house,\nRound as a cup,\nAnd all the king's horses\nCan't draw it up?");
    else
        Print("What's tall as a house,\nRound as a cup,\nAnd all the king's horses\nCan't draw it up?", 1.0, 1.0, 0.5);
    end
end


---------------------------------------------------------------------------------
--
-- Toggle whether to play sounds when soulstone cooldowns expire / players need new healthstones
-- 
---------------------------------------------------------------------------------
function ShardTracker_Toggle_Sound(toggle)
    if (not toggle) then
        if (SHARDTRACKER_CONFIG.USE_SOUND == true) then
            toggle = false;
        else
            toggle = true;
        end
    end
    if (toggle == 0) then toggle = false end;
    if (toggle == 1) then toggle = true end;
    if (toggle) then
        if (not SHARDTRACKER_FIRST_TIME.SOUND and (SHARDTRACKER_CONFIG.USE_SOUND ~= toggle)) then
            ShardTrackerPrint(ST_SOUNDON);
        else
            SHARDTRACKER_FIRST_TIME.SOUND = false;
        end
        SHARDTRACKER_CONFIG.USE_SOUND = true;
    else
        if (SHARDTRACKER_CONFIG.USE_SOUND ~= toggle) then
            ShardTrackerPrint(ST_SOUNDOFF);
        end
        SHARDTRACKER_CONFIG.USE_SOUND = false;
    end
end



---------------------------------------------------------------------------------
--
-- Toggle whether to play sounds when soulstone cooldowns expire / players need new healthstones
-- 
---------------------------------------------------------------------------------
function ShardTracker_Toggle_SoulPop(toggle)
    if (not toggle) then
        if (SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP == true) then
            toggle = false;
        else
            toggle = true;
        end
    end
    if (toggle == 0) then toggle = false end;
    if (toggle == 1) then toggle = true end;
    if (toggle) then
        if (not SHARDTRACKER_FIRST_TIME.SOULPOP and (SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP ~= toggle)) then
            ShardTrackerPrint(ST_POPUPENABLED);
        else
            SHARDTRACKER_FIRST_TIME.SOULPOP = false;
        end
        SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP = true;
    else
        if (SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP ~= toggle) then
            ShardTrackerPrint(ST_POPUPDISABLED);
        end
        SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP = false;
    end
end

---------------------------------------------------------------------------------
--
-- Toggle whether to only send healthstone monitoring messages to people on our
-- "OK to send" list
-- 
---------------------------------------------------------------------------------
function ShardTracker_Toggle_RestrictedChat(toggle, slashCmd)
    if (toggle == nil) then
        if (SHARDTRACKER_CONFIG.LIST_RESTRICT == true) then
            toggle = false;
        else
            toggle = true;
        end
    end
    if (toggle == 0) then toggle = false end;
    if (toggle == 1) then toggle = true end;
    if (toggle) then
        if ((slashCmd) or (not SHARDTRACKER_FIRST_TIME.LIST_RESTRICT and (SHARDTRACKER_CONFIG.LIST_RESTRICT ~= toggle))) then
            if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
                ShardTrackerPrint(ST_MONITORINGON);
            end
        else
            SHARDTRACKER_FIRST_TIME.LIST_RESTRICT = false;
        end
        ShardTracker_InitializePartyHealthstoneIcons();
        ShardTracker_ReQueryAllPartyMembers();
        SHARDTRACKER_CONFIG.LIST_RESTRICT = true;
    else
        if (SHARDTRACKER_CONFIG.LIST_RESTRICT ~= toggle and (not SHARDTRACKER_FIRST_TIME.LIST_RESTRICT)) then
            if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
                ShardTrackerPrint(ST_MONITORINGOFF);
            end
            SHARDTRACKER_CONFIG.LIST_RESTRICT = false;
        end
        ShardTracker_InitializePartyHealthstoneIcons();
        ShardTracker_ReQueryAllPartyMembers();
    end
    
    SHARDTRACKER_FIRST_TIME.LIST_RESTRICT = false;
end


---------------------------------------------------------------------------------
--
-- Toggle the shard background image
-- 
---------------------------------------------------------------------------------
function ShardTracker_Toggle_ShardBG(toggle)
    if (not toggle) then
        if (SHARDTRACKER_CONFIG.SHOW_SHARD_BG == true) then
            toggle = false;
        else
            toggle = true;
        end
    end
    if (toggle == 0) then toggle = false end;
    if (toggle == 1) then toggle = true end;
    if (toggle) then
        if (not SHARDTRACKER_FIRST_TIME.SHARDBG and (SHARDTRACKER_CONFIG.SHOW_SHARD_BG ~= toggle)) then
            ShardTrackerPrint(ST_BGENABLED);
        else
            SHARDTRACKER_FIRST_TIME.SHARDBG = false;
        end
        SHARDTRACKER_CONFIG.SHOW_SHARD_BG = true;
    else
        if (SHARDTRACKER_CONFIG.SHOW_SHARD_BG ~= toggle) then
            ShardTrackerPrint(ST_BGDISABLED);
        end
        SHARDTRACKER_CONFIG.SHOW_SHARD_BG = false;
    end

    ShardTracker_UpdateShardButton(ShardTracker_TotalShards);    
end




---------------------------------------------------------------------------------
--
-- Toggle whether to monitor when your party members use / need healthstones
-- 
---------------------------------------------------------------------------------
function ShardTracker_Toggle_Monitor_Party_Healthstones(toggle, slashCommand)

    if (not toggle) then
        if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end

    -- always look for chat msgs if not a warlock.  dummyproof.
    if (UnitClass("player") ~= SHARDTRACKER_WARLOCK) then 
        toggle = 1;  
        if (slashCommand) then
            ShardTrackerPrint(ST_ONLYFORWARLOCKS);
        end
    end

    if (toggle == 1) then
        if ((not SHARDTRACKER_FIRST_TIME.MONITOR or slashCommand) and (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES ~= toggle)) then
            SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES = 1;
            if (slashCommand) then ShardTracker_ShowHealthstoneMonitorStatus(); end
            ShardTracker_InitializePartyHealthstoneIcons();
            ShardTracker_ReQueryAllPartyMembers();
            
            SHARDTRACKER_FIRST_TIME.MONITOR = false;
        else
            SHARDTRACKER_FIRST_TIME.MONITOR = false;
            SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES = 1;
        end
    else
        if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES ~= toggle) then
            SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES = 0;
            if (slashCommand) then ShardTracker_ShowHealthstoneMonitorStatus(); end
            ShardTracker_InitializePartyHealthstoneIcons();
            SHARDTRACKER_FIRST_TIME.MONITOR = false;
        end
        SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES = 0;
        SHARDTRACKER_FIRST_TIME.MONITOR = false;
    end
end


---------------------------------------------------------------------------------
--
-- Display a message letting the player know whether healthstone monitoring is on or off
-- 
---------------------------------------------------------------------------------
function ShardTracker_ShowHealthstoneMonitorStatus()
    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
        if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1) then
            ShardTrackerPrint(ST_PARTYMONITORINGON);
        else
            ShardTrackerPrint(ST_PARTYMONITORINGOFF);
        end
    end
end


---------------------------------------------------------------------------------
--
-- Play a sound
-- 
---------------------------------------------------------------------------------
function ShardTracker_PlaySound(theSoundName)
    if (SHARDTRACKER_CONFIG.USE_SOUND == true) then
        PlaySound(theSoundName);
    end
end


---------------------------------------------------------------------------------
--
-- Start the playing of a notification sound
-- 
---------------------------------------------------------------------------------
function ShardTracker_StartNotificationSound(theType, playerNum)
    ShardTracker_PlayNotificationSound(theType);

    if (Chronos) then
        if ((theType == SHARDTRACKER_SOULSTONE and SHARDTRACKER_CONFIG.NAGSOUL) or 
           (theType == SHARDTRACKER_HEALTHSTONE and SHARDTRACKER_CONFIG.NAGHEALTH)) then
            Chronos.schedule(SHARDTRACKER_NAGFREQUENCY, ShardTracker_Nag, theType, playerNum);
            ShardTracker_NagCounter = 0;
        end
    end
end


---------------------------------------------------------------------------------
--
-- Play a notification sound (either the default sound, or the user-specified sound)
-- 
---------------------------------------------------------------------------------
function ShardTracker_PlayNotificationSound(theSoundType)
    if (theSoundType == SHARDTRACKER_SOULSTONE) then
        if (SHARDTRACKER_CONFIG.SOULSOUND == "") then
            ShardTracker_PlaySound("AuctionWindowClose");
        else
            PlaySoundFile(SHARDTRACKER_CONFIG.SOULSOUND);
        end
    elseif (theSoundType == SHARDTRACKER_HEALTHSTONE) then
        if (SHARDTRACKER_CONFIG.HEALTHSOUND == "") then
            ShardTracker_PlaySound("AuctionWindowOpen");
        else
            PlaySoundFile(SHARDTRACKER_CONFIG.HEALTHSOUND);
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Set a sound to be played when soulstone is ready to re-cast, or a player needs a new healthstone
--
-----------------------------------------------------------------------------------
function ShardTracker_SetSound(soundType, soundName)
    if (tonumber(soundName) ~= nil) then
        soundNum = tonumber(soundName);
        if (soundNum == 0) then
            soundName = "default sound";
        elseif (soundNum > 0 and soundNum <= table.getn(SHARDTRACKER_SOUNDLIST)) then
            soundName = SHARDTRACKER_SOUNDLIST[soundNum];
        else
            ShardTrackerPrint("Usage: /st "..soundType.." <0-"..table.getn(SHARDTRACKER_SOUNDLIST).."> | <exactSoundFileName.ext>.  Select either a pre-set sound number (use 0 for the default sound), or specify the EXACT filename for a wav or mp3 file that you've placed in ShardTracker's Sounds folder.");
            return;
        end
    elseif (soundName == "") then
        ShardTrackerPrint("Usage: /st "..soundType.." <0-"..table.getn(SHARDTRACKER_SOUNDLIST).."> | <exactSoundFileName.ext>.  Select either a pre-set sound number (use 0 for the default sound), or specify the EXACT filename for a wav or mp3 file that you've placed in ShardTracker's Sounds folder.");
        return;    
    end
    
    if (soundType == SHARDTRACKER_SOULSOUND_CMD) then
        if (soundName == "default sound") then
            SHARDTRACKER_CONFIG.SOULSOUND = "";
            SHARDTRACKER_CONFIG.SOULSOUNDNAME = soundName;
        else
            SHARDTRACKER_CONFIG.SOULSOUND = "Interface\\AddOns\\ShardTracker\\Sounds\\"..soundName;
            SHARDTRACKER_CONFIG.SOULSOUNDNAME = soundName;
        end
        ShardTrackerPrint("Soulstone notification sound set to "..SHARDTRACKER_CONFIG.SOULSOUNDNAME..".");
        ShardTracker_PlayNotificationSound(SHARDTRACKER_SOULSTONE);
    elseif (soundType == SHARDTRACKER_HEALTHSOUND_CMD) then
        if (soundName == "default sound") then
            SHARDTRACKER_CONFIG.HEALTHSOUND = "";
            SHARDTRACKER_CONFIG.HEALTHSOUNDNAME = soundName;
        else
            SHARDTRACKER_CONFIG.HEALTHSOUND = "Interface\\AddOns\\ShardTracker\\Sounds\\"..soundName;
            SHARDTRACKER_CONFIG.HEALTHSOUNDNAME = soundName;
        end
        ShardTrackerPrint("Healthstone notification sound set to "..SHARDTRACKER_CONFIG.HEALTHSOUNDNAME..".");
        ShardTracker_PlayNotificationSound(SHARDTRACKER_HEALTHSTONE);
    end
end



--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              DEBUGGING FUNCTIONS                                   --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Print a debug message
--
-----------------------------------------------------------------------------------
function ShardTrackerDebug(theMsg)
    if (SHARDTRACKER_DEBUG) then
        DEFAULT_CHAT_FRAME:AddMessage(theMsg, 1.0, 1.0, 0.2);
    end
end


-----------------------------------------------------------------------------------
--
-- Print a trace message
--
-----------------------------------------------------------------------------------
function ShardTrackerTron(theMsg)
    if (SHARDTRACKER_DEBUG or SHARDTRACKER_TRON) then
        DEFAULT_CHAT_FRAME:AddMessage(theMsg, 0.3, 0.6, 0.3);
    end
end




-----------------------------------------------------------------------------------
--
-- Dump a debug snapshot of the current party list
--
-----------------------------------------------------------------------------------
function ShardTracker_DebugDumpPartyList()

    ShardTrackerDebug("Dumping Party list with "..table.getn(ShardTracker_PartyMemberList).." members in the list:");
    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        Print("     "..i.." = "..ShardTracker_PartyMemberList[i].name.." , hasHealthstone = "..tostring(ShardTracker_PartyMemberList[i].hasHealthstone).." , answeredPing = "..tostring(ShardTracker_PartyMemberList[i].answeredPing));
    end
end


-----------------------------------------------------------------------------------
--
-- Print a debug report of the current status of the plugin
--
-----------------------------------------------------------------------------------
function ShardTracker_DebugPrintStatus()

    -- show the party members' healthstone status
    ShardTrackerPrint("Summary of party member Healthstones based on ShardTracker_PartyMemberList ("..table.getn(ShardTracker_PartyMemberList).." members in list):");
    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        ShardTrackerPrint("   Member #"..i.." is "..ShardTracker_PartyMemberList[i].name.." Healthstone = "..tostring(ShardTracker_PartyMemberList[i].hasHealthstone).." Flashing = "..tostring(ShardTracker_PartyMemberList[i].flashing));
    end
end


-----------------------------------------------------------------------------------
--
-- Code for debugging the party healthstone code
--
-----------------------------------------------------------------------------------
function ShardTracker_DebugHealthstonePartyCode(command, thePartyMember)

    if (var == "") then
        ShardTrackerPrint("ShardTracker_DebugHealthstonePartyCode: Usage - /st testyes/testno [charname]");
        return;
    end
    
    -- find this party member's number in the party
    senderNumber = ShardTracker_GetPartyMemberNumber(thePartyMember);

    if (senderNumber ~= 0) then
        if (command == "testyes") then
            ShardTrackerPrint("ShardTracker_DebugHealthstonePartyCode: Setting "..thePartyMember.." to have a healthstone!");
            ShardTracker_UpdatePartyHealthstoneList(thePartyMember, true, false);
        elseif (command == "testno") then
            ShardTrackerPrint("ShardTracker_DebugHealthstonePartyCode: Setting "..thePartyMember.." to need a healthstone!");
            ShardTracker_UpdatePartyHealthstoneList(thePartyMember, false, true);
        end
    else
        ShardTrackerPrint("ShardTracker_DebugHealthstonePartyCode: Couldn't find "..thePartyMember.." in the party!");
    end
end


-----------------------------------------------------------------------------------
--
-- Code for debugging the spellstone / firestone code
--
-----------------------------------------------------------------------------------
function ShardTracker_DebugSpellFireStoneStatus()

    ShardTrackerPrint("Spellstone State:");
    ShardTrackerPrint("    ShardTracker_SpellStoneEquipped = "..ShardTracker_SpellStoneEquipped);
    ShardTrackerPrint("    ShardTracker_SpellStoneReady = "..ShardTracker_SpellStoneReady);
    ShardTrackerPrint("    ShardTracker_SpellStoneInBag = "..ShardTracker_SpellStoneInBag);
    ShardTrackerPrint("    ShardTracker_SpellStoneLoc = "..asText(ShardTracker_SpellStoneLoc));
    ShardTrackerPrint("Firestone State:");
    ShardTrackerPrint("    ShardTracker_FireStoneEquipped = "..ShardTracker_FireStoneEquipped);
    ShardTrackerPrint("    ShardTracker_FireStoneInBag = "..ShardTracker_FireStoneInBag);
    ShardTrackerPrint("    ShardTracker_FireStoneLoc = "..asText(ShardTracker_FireStoneLoc));

end


-----------------------------------------------------------------------------------
--
-- Round a number
-- Code by Alex Brazie.  All credit to Mr. Yoshi.
--
-----------------------------------------------------------------------------------
function ShardTracker_Round(theNum)
    if (theNum - math.floor(theNum) > 0.5) then
        theNum = theNum + 0.5;
    end
    
    return math.floor(theNum);
end


-----------------------------------------------------------------------------------
--
-- Nifty little function to view any lua object as text
--
-----------------------------------------------------------------------------------
function asText(obj)

    visitRef = {}
    visitRef.n = 0

    asTxRecur = function(obj, asIndex)
        if type(obj) == "table" then
            if visitRef[obj] then
                return "@"..visitRef[obj]
            end
            visitRef.n = visitRef.n +1
            visitRef[obj] = visitRef.n

            local begBrac, endBrac
            if asIndex then
                begBrac, endBrac = "[{", "}]"
            else
                begBrac, endBrac = "{", "}"
            end
            local t = begBrac
            local k, v = nil, nil
            repeat
                k, v = next(obj, k)
                if k ~= nil then
                    if t > begBrac then
                        t = t..", "
                    end
                    t = t..asTxRecur(k, 1).."="..asTxRecur(v)
                end
            until k == nil
            return t..endBrac
        else
            if asIndex then
                -- we're on the left side of an "="
                if type(obj) == "string" then
                    return obj
                else
                    return "["..obj.."]"
                end
            else
                -- we're on the right side of an "="
                if type(obj) == "string" then
                    return '"'..obj..'"'
                else
                    return tostring(obj)
                end
            end
        end
    end -- asTxRecur

    return asTxRecur(obj)
end -- asText


-----------------------------------------------------------------------------------
--
-- Scan a specified tooltip
-- Code by Alex Brazie.  All credit to Mr. Yoshi.
--
-----------------------------------------------------------------------------------
function ShardTracker_ScanToolTip(theTooltip)
    if (theTooltip == nil) then 
        theTooltip = "GameTooltip";
    end

    local theResult = {};
    for i = 1, 10 do
        local textLeft = nil;
        local textRight = nil;
        tooltipText = getglobal(theTooltip.."TextRight"..i);
        if (tooltipText and tooltipText:IsVisible() and tooltipText:GetText() ~= nil) then
            textRight = tooltipText:GetText();
        end
        tooltipText = getglobal(theTooltip.."TextLeft"..i);
        if (tooltipText and tooltipText:IsVisible() and tooltipText:GetText() ~= nil) then
            textLeft = tooltipText:GetText();
        end
        if (textRight or textLeft) then
            theResult[i] = {};
            theResult[i].right = textRight;
            theResult[i].left = textLeft;
        end 
    end

    return theResult;
end


-----------------------------------------------------------------------------------
--
-- Workaround functions to handle a problem where the money field of a tooltip
-- will get hidden whenever tooltips are invoked.
-- 
-- Code by Telo.  From his post:
--   "Whenever a tooltip is set, the game sends a CLEAR_TOOLTIP event, which causes GameTooltip_OnEvent to call 
--   GameTooltip_ClearMoney, hiding the money frame for GameTooltip. There doesn't appear to be any identifying 
--   information sent with the CLEAR_TOOLTIP event that would allow GameTooltip_OnEvent to discriminate between 
--   its tooltip and others, so simply hooking this function doesn't appear to help. I've worked around the 
--   issue for my code by using something similar to the following code wherever I use a hidden tooltip."
--   (http://forums.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=16768&tmp=1#post16768)
--
-----------------------------------------------------------------------------------
local lOriginal_GameTooltip_ClearMoney;
function ShardTracker_MoneyToggle()
    if( lOriginal_GameTooltip_ClearMoney ) then
        GameTooltip_ClearMoney = lOriginal_GameTooltip_ClearMoney;
        lOriginal_GameTooltip_ClearMoney = nil;
    else
        lOriginal_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
        GameTooltip_ClearMoney = ShardTracker_GameTooltip_ClearMoney;
    end    
end
function ShardTracker_GameTooltip_ClearMoney()
    -- Intentionally empty; don't clear money while we use hidden tooltips
end

