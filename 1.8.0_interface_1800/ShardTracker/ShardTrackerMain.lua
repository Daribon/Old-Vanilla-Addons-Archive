--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              MAIN/UPDATE FUNCTIONS                                         --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- The Main Event
-- Update the number of shards in the player's pack, as well as the
-- healthstone and soulstone status.
-- A big-giant-gordo function.
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateShardTracker()

    ShardTracker_InUpdateShardTracker = true;
    
    local shardCount = 0;
    local foundSoulStone = 0;
    local foundHealthStone = 0;
    local foundSpellStone = 0;
    local foundFireStone = 0;
    local lastShardLocation = {bag = nil; slot = nil};
    
    ShardTracker_SpellStoneInBag = 0;
    ShardTracker_FireStoneInBag = 0;
    
    -- if this is our first update, build the table of known spells
    -- so we can cast create healthstone/soulstone spells
    if (not ShardTracker_SpellTableBuilt) then
        ShardTracker_BuildSpellTable();
        ShardTracker_SpellTableBuilt = true;
    end

    local theResult = { };

    -- now we're going to look through all our bags to see how many
    -- shards we have, whether we have a healthstone, and whether
    -- we have a soulstone
    
    -- for each bag
    for bag = 4, 0, -1 do
        local size = GetContainerNumSlots(bag);
        if (size > 0) then
        
            -- for each slot in the bag
            for slot = 1, size do
            
                -- get info about the item in this slot
                local texture, itemCount = GetContainerItemInfo(bag, slot);
                if (itemCount) then
                    local itemName = ShardTracker_GetItemNameInBagSlot(bag, slot, false);
                                            
                    -- if the item has a name
                    if (itemName ~= "" and itemName ~= nil) then

                        -- if the item is a soul shard, increase the count
                        if (itemName == SHARDTRACKER_SOULSHARD) then
                            shardCount = shardCount + 1;
                            lastShardLocation.bag  = bag;
                            lastShardLocation.slot = slot;
                            
                        -- if the item is a soulstone, remember which slot it's in so
                        -- that we can activate it later, if the player clicks on the healthstone button
                        elseif (string.find(itemName, SHARDTRACKER_SOULSTONE, 1, TRUE) ~= nil) then
                            foundSoulStone = 1;
                            ShardTracker_SoulstoneLoc = {bag, slot};
                            ShardTracker_MoneyToggle();
                            theResult = ShardTracker_ScanToolTip("ShardTrackerTooltip");
                            ShardTracker_MoneyToggle();

                            -- look for the "Cooldown remaining" text in the stone's tooltip
                            timeRemainingText = "";
                            if (theResult) then
                                if (theResult[6]) then
                                    if (theResult[6].left) then              
                                        timeRemainingText = theResult[6].left;
                                    end
                                end
                            end
                            if (string.find(timeRemainingText, SHARDTRACKER_COOLDOWN, 1, TRUE) ~= nil) then
                                ShardTracker_SoulStoneExpired = 0;

                                -- grab the number of seconds or minutes remaining
                                for theTime in string.gfind(timeRemainingText, "%d+") do
                                    timeRemaining = theTime;
                                end

                                -- check if the tooltip has the word "sec" in it, we're counting down seconds
                                -- otherwise, we're counting down minutes
                                ShardTracker_intoSeconds = string.find(timeRemainingText, "sec", 1, TRUE);                                      
                                timeRemaining = tonumber(timeRemaining);

                                ShardTracker_ShowSoulstoneTime(timeRemaining, ShardTracker_intoSeconds);

                            -- else if there's no "cooldown remaining" then the cooldown has expired
                            else
                                if (ShardTracker_SoulStoneExpired ~= 1) then
                                    ShardTracker_NotifySoulstoneReady();
                                end
                                ShardTracker_SoulStoneExpired = 1;
                            end

                        -- if the item is a healthstone, remember which slot it's in so
                        -- that we can activate it later, if the player clicks on the healthstone button
                        elseif (string.find(itemName, SHARDTRACKER_HEALTHSTONE, 1, TRUE) ~= nil) then
                            foundHealthStone = 1;
                            ShardTracker_HealthStoneLoc = {bag, slot};
                            
                        -- if the item is a spellstone
                        elseif (string.find(itemName, SHARDTRACKER_SPELLSTONE, 1, TRUE) ~= nil) then -- and (ShardTracker_SpellStoneEquipped ~= 1)) then
                            ShardTracker_SpellStoneInBag = 1;
                            ShardTracker_SpellStoneEquipped = 0;
                            ShardTracker_SpellStoneLoc = {bag, slot};
                            
                        -- if the item is a firestone
                        elseif (string.find(itemName, SHARDTRACKER_FIRESTONE, 1, TRUE) ~= nil) then -- and (ShardTracker_FireStoneEquipped ~= 1)) then
                            ShardTracker_FireStoneInBag = 1;
                            ShardTracker_SpellStoneEquipped = 0;
                            ShardTracker_FireStoneLoc = {bag, slot};
                        end
                    end
                end
            end
        end
    end
    
    -- check to see if we should delete any extra soul shards
    if (SHARDTRACKER_CONFIG.MAXSHARDS > 0 and shardCount > SHARDTRACKER_CONFIG.MAXSHARDS) then
        if (lastShardLocation.bag and lastShardLocation.slot) then
            ShardTracker_DeleteAShard(lastShardLocation.bag, lastShardLocation.slot);
            shardCount = shardCount - 1;
        end        
    end
    
    -------------------------------------------------------------------------------------
    -- Now we're done looking through our pack, so we need to update our minimap buttons
    -------------------------------------------------------------------------------------
            
    -- if we're a warlock, we'll want to display the shard and soulstone buttons 
    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
    
        --------------------------------
        -- Handle Shards
        --------------------------------
    
        ShardTracker_UpdateShardButton(shardCount);
        
        --------------------------------
        -- Handle Soulstone
        --------------------------------

        -- display the soulstone button, if we have one in inventory
        if (SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED == 1) then
            ShardTracker_SoulStoneButton:Show();
            ShardTracker_SoulStoneText:Show()
            
            -- if no soulstone in inventory, show the greyed out button
            if (foundSoulStone == 1) then
                ShardTrackerMinimapButtonSoul:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoul");
            else
                ShardTracker_SoulstoneLoc = {-1, -1};
                ShardTrackerMinimapButtonSoul:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulGreyed");
                
                -- if we'd cast Soulstone Resurrection and haven't made a new Soulstone, track the time until we can cast it again
                if (ShardTracker_Timer.SoulstoneExpireTimeSeconds ~= 0) then
                    local timeRemaining = ShardTracker_Timer.SoulstoneExpireTimeSeconds - GetTime();
                    if (timeRemaining <= 0) then
                        ShardTracker_SoulStoneExpired = 1;
                        ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
                        ShardTracker_NotifySoulstoneReady();
                    elseif (timeRemaining < 60) then
                        ShardTracker_intoSeconds = true;
                    elseif (timeRemaining < 120) then
                        ShardTracker_UnderTwoMinutes = true;
                    else
                        ShardTracker_SoulStoneExpired = 0;
                        ShardTracker_intoSeconds = nil;
                        ShardTracker_UnderTwoMinutes = nil;
                        timeRemaining = timeRemaining / 60;
                    end
                    ShardTracker_ShowSoulstoneTime(timeRemaining, ShardTracker_intoSeconds);
                end
            end
        else
            ShardTracker_SoulStoneButton:Hide();
            ShardTracker_SoulStoneText:Hide();
        end
        
        --------------------------------
        -- Handle Spellstone
        --------------------------------

        -- display the spellstone button, if we have one equipped
        if (SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED == 1) then
            local spellStoneInOffHand = 0;
            ShardTracker_SpellStoneButton:Show();
            ShardTracker_SpellStoneText:Show()

            -- see what we have in our secondary hand slot
            local id = GetInventorySlotInfo("SecondaryHandSlot");
            ShardTracker_MoneyToggle();
            local hasItem = getglobal("ShardTrackerTooltip"):SetInventoryItem("player", id);
            ShardTracker_MoneyToggle();

            ShardTracker_SpellStoneEquipped = 0;
            ShardTracker_SpellStoneReady = 0;
            
            -- if we're carrying an item in our secondary hand slot
            if (hasItem) then
                ShardTracker_MoneyToggle();
                local itemTip = ShardTracker_ScanToolTip("ShardTrackerTooltip");
                ShardTracker_ClearTooltip("ShardTrackerTooltip");
                ShardTracker_MoneyToggle();

                -- if that item has a tooltip description
                if (itemTip) then

                    -- if the item is a spellstone
                    local itemName = ShardTracker_GetItemName(itemTip);
                    if (string.find(itemName, SHARDTRACKER_SPELLSTONE, 1, true)) then

                        spellStoneInOffHand = 1;
                        ShardTracker_SpellStoneEquipped = 1;
                        ShardTracker_SpellStoneReady = 0;
                        
                        -- look for the "Cooldown remaining" text in the stone's tooltip
                        local timeRemainingText = "";
                        if (itemTip[9].left) then timeRemainingText = itemTip[9].left; end
                        if (string.find(timeRemainingText, SHARDTRACKER_COOLDOWN, 1, TRUE) ~= nil) then

                            -- grab the number of seconds remaining
                            for theTime in string.gfind(timeRemainingText, "%d+") do
                                timeRemaining = theTime;
                            end    
                            timeRemaining = tonumber(timeRemaining);
                            ShardTracker_ShowSpellStoneTime(timeRemaining);

                        -- else if there's no "cooldown remaining" then the cooldown has expired and
                        -- the spellstone is ready for use
                        elseif (ShardTracker_SpellStoneIsActive == 0 and ShardTracker_SpellStoneEquipped == 1) then
                            ShardTracker_SpellStoneReady = 1;
                            ShardTracker_SpellStoneText:SetText("");
                            ShardTracker_SpellStoneText:Hide();
                        end
                    end
                end
            end
            
            -- if the spellstone is equipped, show the icon
            if (ShardTracker_SpellStoneReady == 1) then
                ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreen"); 
            elseif (ShardTracker_SpellStoneEquipped == 1) then
                ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellYellow");             
            elseif (ShardTracker_SpellStoneInBag == 1) then
                ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpell");              
            elseif (ShardTracker_SpellStoneText:GetText() ~= "" and ShardTracker_SpellStoneText:GetText() ~= nil) then
                ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreyedHole");
            else
                ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreyed");
            end
            
        -- else if spellstone is disabled, hide the button
        else
            ShardTracker_SpellStoneButton:Hide();
            ShardTracker_SpellStoneText:Hide();
        end

        --------------------------------
        -- Handle Firestone
        --------------------------------

        -- display the firestone button, if we have one equipped
        if (SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED == 1) then
            local fireStoneInOffHand = 0;
            ShardTracker_FireStoneButton:Show();

            -- see what we have in our secondary hand slot
            local id = GetInventorySlotInfo("SecondaryHandSlot");
            ShardTracker_MoneyToggle();
            local hasItem = getglobal("ShardTrackerTooltip"):SetInventoryItem("player", id);
            ShardTracker_MoneyToggle();

            ShardTracker_FireStoneEquipped = 0;
            
            -- if we're carrying an item in our secondary hand slot
            if (hasItem) then
                ShardTracker_MoneyToggle();
                local itemTip = ShardTracker_ScanToolTip("ShardTrackerTooltip");
                ShardTracker_ClearTooltip("ShardTrackerTooltip");
                ShardTracker_MoneyToggle();

                -- if that item has a tooltip description
                if (itemTip) then

                    -- if the item is a firestone
                    local itemName = ShardTracker_GetItemName(itemTip);
                    if (string.find(itemName, SHARDTRACKER_FIRESTONE, 1, true)) then
                        fireStoneInOffHand = 1;
                        ShardTracker_FireStoneEquipped = 1;
                        ShardTracker_FireStoneInBag = 0;
                    end
                end
            end
            
            -- if the firestone is equipped, show the icon
            if (ShardTracker_FireStoneEquipped == 1) then
                ShardTrackerMinimapButtonFire:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardFireGreen");              
            elseif (ShardTracker_FireStoneInBag == 1) then
                ShardTrackerMinimapButtonFire:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardFire");              
            else
                ShardTrackerMinimapButtonFire:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardFireGreyed");
            end
            
        -- else if firestone is disabled, hide the button
        else
            ShardTracker_FireStoneButton:Hide();
        end

    -- else we're not a warlock, so hide the warlock-specific buttons (shard, soul, and spellstone)
    else
        ShardTracker_SoulStoneButton:Hide();
        ShardTracker_SoulStoneText:Hide();
        ShardTracker_SpellStoneButton:Hide();
        ShardTracker_SpellStoneText:Hide();
        ShardTracker_ShardCountLabel:Hide();
        ShardTracker_ShardButton:Hide();
    end 

    --------------------------------
    -- Handle Healthstone
    --------------------------------

    -- regardless of character class, display the healthstone button, if we have one in inventory
    if ((UnitClass("player") == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED == 1) or 
       (foundHealthStone == 1 and SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED == 1) or 
       (SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 1)) then
        ShardTrackerMinimapButtonHealth:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealth");
        ShardTracker_HealthStoneButton:Show();
    elseif (SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 0) then
        ShardTracker_HealthStoneButton:Hide();    
    end
        
    -- if we don't have a healthstone, reset the variable that tells us where it is in our pack
    if (foundHealthStone == 0) then
        ShardTracker_HealthStoneLoc = {-1, -1};
        ShardTrackerMinimapButtonHealth:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealthGreyed");
        
        -- if we previously had a healthstone, notify any warlocks that we now need a new one
        if (ShardTracker_HaveHealthStone == 1) then
            ShardTracker_SentHealthstoneNotification = 0;
            ShardTracker_NotifyHealthstoneStatus(SHARDTRACKER_NEED_HEALTHSTONE_MSG);
        end
        
    -- else if we just got a new healthstone, notify any Warlocks in our party that we now have a Healthstone
    elseif (foundHealthStone == 1 and ShardTracker_HaveHealthStone == 0) then
        ShardTracker_SentHealthstoneNotification = 0;
        ShardTracker_NotifyHealthstoneStatus(SHARDTRACKER_GOT_HEALTHSTONE_MSG);
    end
    
    -- if we just got a new shard, show the visual effect
    -- also, do an auto-sort if desired
    if ((ShardTracker_TotalShards < shardCount) and (not ShardTracker_FirstTimeUpdating)) then
        ShardTracker_TriggerCreatedSoulShardVisual();
        if (SHARDTRACKER_CONFIG.AUTOSORT) then
            if (Chronos) then
                Chronos.schedule(1, ShardTracker_SortShards, false);
            else
                ShardTracker_SortShards(false);
            end
        end    
    end
    
    -- store the total number of shards for later use
    ShardTracker_TotalShards = shardCount;
    ShardTracker_HaveHealthStone = foundHealthStone;
    ShardTracker_HaveSoulStone = foundSoulStone;
    
    ShardTracker_FirstTimeUpdating = false;
    ShardTracker_InUpdateShardTracker = false;
end


-----------------------------------------------------------------------------------
--
-- Update the flashing buttons and everything else that needs to update each frame
-- This stuff gets called every frame, so beware
--
-----------------------------------------------------------------------------------
function ShardTracker_OnUpdate(elapsed)
    
    -- we have to do this here because we don't always have our class info at "VARIABLES_LOADED"
    if (UnitClass("player") ~= nil and not ShardTracker_DisplayedLoginMessage) then    
        ShardTracker_PerformInitialLoginStuff();        
    end
    
    -- if we don't have chronos, check for incoming SKY message
    if (not Chronos and Sky) then
        ShardTracker_CheckForIncomingSkyMessage();
    end
    
    -- update the flashtimer
    ShardTracker_UpdateFlashTimers(elapsed);
        
    -- flash the healthstone button
    ShardTracker_UpdateAFlashingElement("healthstone", (SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 1),
                                        (ShardTracker_HaveHealthStone == 0));

    -- this stuff only applies to warlocks        
    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then

        -- flash the soulstone button and soulstone glow around the minimap
        if (ShardTracker_SoulStoneExpired ~= nil and SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED ~= nil and SHARDTRACKER_CONFIG.FLASHY_GRAPHICS ~= nil) then
            ShardTracker_UpdateAFlashingElement("soulstone", (SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED == 1),
                                                (ShardTracker_SoulStoneExpired == 1));
            ShardTracker_UpdateAFlashingElement("soulglow", (SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED == 1 and SHARDTRACKER_CONFIG.FLASHY_GRAPHICS),
                                                (ShardTracker_SoulStoneExpired == 1));
        end
        -- flash the shard button
        if (ShardTracker_TotalShards ~= nil and SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT ~= nil and SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED ~= nil) then
            ShardTracker_UpdateAFlashingElement("shard", (SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED == 1),
                                                (ShardTracker_TotalShards < SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT));
        end
        
        -- update the visibility of the party member healthstone icons
        ShardTracker_UpdatePartyMemberHealthstoneIconVisibility();

        -- flash the party members' healthstone buttons and glow
        ShardTracker_UpdatePartyMemberHealthstoneIconFlashing();
        ShardTracker_UpdatePartyMemberHealthstoneGlowFlashing();
                        
        -- if a minute has passed, or we're counting down seconds on the soulstone, 
        -- or counting down seconds on the spellstone, update the shard tracker
        local hour, minute = GetGameTime();
        if (minute ~= ShardTracker_LastMinute or ShardTracker_intoSeconds or 
            ShardTracker_UnderTwoMinutes or (ShardTracker_SpellStoneEquipped == 1 and 
            ShardTracker_SpellStoneReady == 0)) then
            ShardTracker_LastMinute = minute;
            ShardTracker_UpdateShardTracker();
        end

        -- see if we still need to ping non-responsive party members
        if (not ShardTracker_StopPinging) then
            ShardTracker_PingCounter = math.mod(ShardTracker_PingCounter + 1,60);
            if (ShardTracker_PingCounter == 0) then
                ShardTrackerDebug("Calling ShardTracker_UpdatePartyMemberPingStatus from OnUpdate",0,1,0);
                ShardTracker_UpdatePartyMemberPingStatus();
            end
        end

        -- update the shard sorting code
        ShardTracker_UpdateShardSorter(); 
    end
    
    if (ShardTracker_ShieldStatusBarActive) then
        ShardTracker_StatusBar_OnUpdate();
    end
    
    ShardTracker_UpdateFlashTimers(elapsed);
end


-----------------------------------------------------------------------------------
--
-- Perform stuff we need to only do once after login
-- we have to do this here because we don't always have our class info at "VARIABLES_LOADED"
--
-----------------------------------------------------------------------------------
function ShardTracker_PerformInitialLoginStuff()
    ShardTracker_DisplayedLoginMessage = true;

    -- setup the default for monitoring healthstones.  non-warlocks default to always 
    -- listening for healthstone msgs (dummy proof: we really don't want to have to tell every non-warlock
    -- to remember to turn this on)

    -- show or don't show the shardtracker interface
    if (not ShardTracker_CosmosEnabled) then ShardTracker_Toggle(SHARDTRACKER_CONFIG.ENABLED) end;          

    -- turn on or off monitoring of party healthstone status
    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
        ShardTrackerDebug("MONITOR_PARTY_HEALTHSTONES = "..SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES);
        ShardTracker_Toggle_Monitor_Party_Healthstones(SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES, true);
    else
        ShardTracker_Toggle_Monitor_Party_Healthstones(1, nil);
    end    

    -- when we first login, if we're a warlock, print a message about our monitoring status
    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
        if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == 1 and SHARDTRACKER_CONFIG.ENABLED == 1) then
            ShardTrackerPrint("ShardTracker is monitoring your party's Healthstone status.  To disable monitoring, use the \"/st monitor off\" command.");
        else
            ShardTrackerPrint("ShardTracker isn't monitoring your party's Healthstone status.  To enable monitoring, use the \"/st monitor on\" command.");
        end
    elseif (SHARDTRACKER_CONFIG.ENABLED == 1) then
        ShardTrackerPrint("ShardTracker is active.");
    end

    -- initialize the scale of the buttons
    ShardTracker_InitButtonScales();

    -- if we have chronos and sky, start SKY looking for incoming messages
    if (Chronos and Sky) then
        Chronos.schedule(SKY_MESSAGE_CHECK_FREQ, ShardTracker_CheckForIncomingSkyMessage);
    end
end

    
    
-----------------------------------------------------------------------------------
--
-- Update the timer for flashing stuff
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateFlashTimer(elapsed)
    ShardTracker_FlashTime = ShardTracker_FlashTime - elapsed;
    if ( ShardTracker_FlashTime < 0 ) then
        local overtime = -ShardTracker_FlashTime;
        if ( ShardTracker_FlashState == 0 ) then
            ShardTracker_FlashState = 1;
            ShardTracker_FlashTime = SHARDTRACKER_FLASH_TIME_ON;
        else
            ShardTracker_FlashState = 0;
            ShardTracker_FlashTime = SHARDTRACKER_FLASH_TIME_OFF;
        end
        if ( overtime < ShardTracker_FlashTime ) then
            ShardTracker_FlashTime = ShardTracker_FlashTime - overtime;
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Update the timers for flashing stuff
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateFlashTimers(elapsed)
    ShardTracker_ElapsedTime = elapsed;
    table.foreach(ShardTracker_FlashController, ShardTracker_UpdateAFlashTimer);
end


-----------------------------------------------------------------------------------
--
-- Update a timer for flashing stuff
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateAFlashTimer(k, v, elapsed)

    -- update the timer
    v.time = v.time - ShardTracker_ElapsedTime;
    
    -- if the timer is done
    if (v.time < 0) then
    
        -- store any overtime just incase we need to adjust the timer
        local overtime = -v.time;
        
        -- move to the next state
        v.stateIndex = v.stateIndex + 1;
        if (v.stateIndex > table.getn(SHARDTRACKER_FLASHSTATELIST)) then v.stateIndex = 1; end
        v.state = SHARDTRACKER_FLASHSTATELIST[v.stateIndex];
        
        -- set the time for this state
        v.time = v.totalTime[v.state];        
        
        -- adjust for any overtime
        if (overtime < v.time) then
            v.time = v.time - overtime;
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Update the flashing of a UI element
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateAFlashingElement(elementName, toggled, flashCondition, gname, visibleState)

    if (visibleState == nil) then visibleState = true; end
        
    -- get the current alpha value for the element we're flashing
    local alphaValue = 0;
    if (gname) then
        alphaValue = getglobal(gname):GetAlpha();
    else
        alphaValue = getglobal(ShardTracker_FlashController[elementName].elementList[1]):GetAlpha();
    end
    
    if (toggled) then
    
        -- calculate the alphaValue
        if (flashCondition) then
            local theState = ShardTracker_FlashController[elementName].state;
            local totalTime = ShardTracker_FlashController[elementName].totalTime[theState];
            local theTime = ShardTracker_FlashController[elementName].time;
            local minAlpha = ShardTracker_FlashController[elementName].minAlpha;
            if (theState == "rising") then
                alphaValue = ((totalTime - theTime) / totalTime) * (1 - minAlpha) + minAlpha;
            elseif (theState == "toppause") then
                -- do nothing;
            elseif (theState == "falling") then
                alphaValue = (theTime / totalTime) * (1 - minAlpha) + minAlpha;
            elseif (theState == "bottompause") then
                -- donothing;
            end   
        else
            alphaValue = ShardTracker_FlashController[elementName].defaultAlpha;
        end
        
        -- if we specified a UI element to flash, use this instead of the default list of elements
        if (gname) then
            getglobal(gname):SetAlpha(alphaValue);
            if (visibleState) then
                getglobal(gname):Show();
            else
                getglobal(gname):Hide();
            end
            
        -- else for each element in the element list, adjust its alpha value
        else
            for i = 1, table.getn(ShardTracker_FlashController[elementName].elementList) do
                getglobal(ShardTracker_FlashController[elementName].elementList[i]):SetAlpha(alphaValue);
                if (visibleState) then                
                    getglobal(ShardTracker_FlashController[elementName].elementList[i]):Show();
                else
                    getglobal(ShardTracker_FlashController[elementName].elementList[i]):Hide();
                end
            end
        end    
    end
end


-----------------------------------------------------------------------------------
--
-- Update the visibility of the party members' healthstone icons
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyMemberHealthstoneIconVisibility()

    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        partyNumber = ShardTracker_GetPartyMemberNumber(ShardTracker_PartyMemberList[i].name);
        --Print("For member "..i.." partyNumber = "..tostring(partyNumber));
        local healthStoneIcon = getglobal("PartyMemberFrame"..partyNumber.."ShardTrackerIcon");
        if (healthStoneIcon) then
            --Print("   healthStoneIcon exists");
            --Print("   hasHealthstone = "..tostring(ShardTracker_PartyMemberList[i].hasHealthstone).." flashing = "..tostring(ShardTracker_PartyMemberList[i].flashing));
            if (ShardTracker_PartyMemberList[i].hasHealthstone or ShardTracker_PartyMemberList[i].flashing) then
                healthStoneIcon:Show();
            else
                healthStoneIcon:Hide();
            end
        else
            --Print("   healthStoneIcon does NOT exist");            
        end
    end
end


-----------------------------------------------------------------------------------
--
-- flash the party members' healthstone buttons
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyMemberHealthstoneIconFlashing()        

    -- reset the flashing array
    for i = 1, 4 do
        ShardTracker_HealthstoneFlashing[i] = 0;
    end

    -- set the flashing array based on each party member's .flashing property in the party list
    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        partyNumber = ShardTracker_GetPartyMemberNumber(ShardTracker_PartyMemberList[i].name);
        if (ShardTracker_PartyMemberList[i].flashing) then
            ShardTracker_HealthstoneFlashing[partyNumber] = 1;
        end
    end

    -- for each party member's healthstone icon, set the alpha value
    for p = 1, table.getn(ShardTracker_PartyMemberList) do
        local gname = "PartyMemberFrame"..tostring(p).."ShardTrackerIcon";
        if (getglobal(gname)) then
            local visibleState = (ShardTracker_PartyMemberList[p].hasHealthstone or ShardTracker_PartyMemberList[p].flashing);
            ShardTracker_UpdateAFlashingElement("partyhealthstone", true, (ShardTracker_HealthstoneFlashing[p] == 1), gname, visibleState);
        end
    end
end


-----------------------------------------------------------------------------------
--
-- flash the party members' healthstone glow
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyMemberHealthstoneGlowFlashing()        

    -- for each party member's healthstone icon, set the alpha value
    for p = 1, 4 do
        local gname = "PartyMemberFrame"..tostring(p).."ShardTrackerGlowFrame";
        if (getglobal(gname)) then
            ShardTracker_UpdateAFlashingElement("partyhealthstoneglow", (SHARDTRACKER_CONFIG.FLASHY_GRAPHICS), (ShardTracker_HealthstoneFlashing[p] == 1), gname);
        end
    end
end



-----------------------------------------------------------------------------------
--
-- Update status of the shard button
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateShardButton(shardCount)

    local limitNum;
    
    -- display the number of shards
    ShardTracker_ShardCountLabel:SetText(shardCount);

    -- some players report these not getting set correctly
    if (shardCount == nil) then shardCount = 0; end
    if (SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT == nil) then SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT = 1; end
    
    -- if the number of shards is less than the limit, display the number in yellow    
    if (shardCount < SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT) then
        if (ColorCycle_Exists) then
            ColorCycle_AlternateColors(
                {
                    ID = "ShardTrackerText";
                    globalName = "ShardTrackerText";
                    globalType = "FontText";
                    color1 = {1.00, 1.00, 1.00};
                    color2 = {1.00, 0.00, 0.00};
                    speed = 0.07;
                    unique = true;
                }
            );            
        else
            ShardTracker_ShardCountLabel:SetTextColor(0.89, 0.98, 0.46);
        end
        if (SHARDTRACKER_CONFIG.SHOW_SHARD_BG) then
            ShardTrackerMinimapButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardRed");
        else
            ShardTrackerMinimapButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardBlankRed");
        end
    else
        ShardTracker_ShardCountLabel:SetTextColor(SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[1],
                                                  SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[2],
                                                  SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR[3]);
        if (ColorCycle_Exists) then
            ColorCycle_Remove("ShardTrackerText");            
        end
        if (SHARDTRACKER_CONFIG.SHOW_SHARD_BG) then
            ShardTrackerMinimapButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\Shard");
        else
            ShardTrackerMinimapButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardBlank");        
        end
    end
    if (SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED == 1) then
        ShardTracker_ShardCountLabel:Show();
        ShardTracker_ShardButton:Show();
    else
        ShardTracker_ShardCountLabel:Hide();
        ShardTracker_ShardButton:Hide();
    end
end        



-----------------------------------------------------------------------------------
--
-- Play the nag sounds
--
-----------------------------------------------------------------------------------
function ShardTracker_Nag(theNagType, playerNum)
    
    local performNag = false;
    
    -- if we're nagging about soulstones
    if ((theNagType == SHARDTRACKER_SOULSTONE) and (ShardTracker_SoulStoneExpired == 1) and
        (SHARDTRACKER_CONFIG.NAGSOUL == true)) then
        performNag = true;

    -- if we're nagging about healthstones
    elseif ((theNagType == SHARDTRACKER_HEALTHSTONE) and (SHARDTRACKER_CONFIG.NAGHEALTH == true)) then
    
        -- if we specified a specific player to nag about
        if (playerNum) then
            if (ShardTracker_HealthstoneFlashing[playerNum] == 1) then
                performNag = true;
            end    
            
        -- else see if any players need healthstones
        else
            for p = 1, 4 do
                if (ShardTracker_HealthstoneFlashing[p] == 1) then
                    performNag = true;
                    break;
                end
            end
        end    
    end
    
    -- if we need to nag, and we haven't reached our max number of nags yet
    if (performNag and (ShardTracker_NagCounter <= SHARDTRACKER_CONFIG.NAGCOUNT or SHARDTRACKER_CONFIG.NAGCOUNT == 0)) then
        ShardTracker_PlayNotificationSound(theNagType);
        if (Chronos) then
            Chronos.schedule(SHARDTRACKER_CONFIG.NAGFREQ, ShardTracker_Nag, theNagType);
        end    
        ShardTracker_NagCounter = ShardTracker_NagCounter + 1;
    end
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              SOUL SHARD FUNCTIONS                                          --
--                                                                                            --
--============================================================================================--
--============================================================================================--

-----------------------------------------------------------------------------------
--
-- Delete a shard
--
-----------------------------------------------------------------------------------
function ShardTracker_DeleteAShard(theBag, theSlot)

    -- make doubly sure the item is a soul shard!
    local itemName = ShardTracker_GetItemNameInBagSlot(theBag, theSlot, false);
    if (itemName == SHARDTRACKER_SOULSHARD) then
        PickupContainerItem(theBag, theSlot);
        DeleteCursorItem();
        --ShardTrackerPrint(ST_DELETEDASHARD);
    end    
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              SOULSTONE FUNCTIONS                                           --
--                                                                                            --
--============================================================================================--
--============================================================================================--

-----------------------------------------------------------------------------------
--
-- Create a new soulstone if we click on our soulstone button
--
-----------------------------------------------------------------------------------
function ShardTracker_OnSoulButtonClick()
    local myClass = UnitClass("player");
    if (myClass == SHARDTRACKER_WARLOCK) then
        if (ShardTracker_HaveSoulStone == 1) then
            if (ShardTracker_SoulstoneLoc[1] ~= -1 and ShardTracker_SoulstoneLoc[2] ~= -1) then
                UseContainerItem(ShardTracker_SoulstoneLoc[1], ShardTracker_SoulstoneLoc[2]);
            end
        elseif (ShardTracker_TotalShards > 0 and ShardTracker_CreateSoulStoneSpellID) then
            CastSpell(ShardTracker_CreateSoulStoneSpellID, "spell");
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Remember when the soulstone will expire so that we can countdown the minutes/seconds
-- until we need to cast another one.
--
-----------------------------------------------------------------------------------
function ShardTracker_StartSoulstoneTimer()
    ShardTracker_Timer.SoulstoneExpireTimeSeconds = GetTime() + (60 * 30);
    ShardTracker_intoSeconds = nil;
    ShardTracker_UnderTwoMinutes = nil;
end


-----------------------------------------------------------------------------------
--
-- Show the time remaining until we can cast another soulstone
--
-----------------------------------------------------------------------------------
function ShardTracker_ShowSoulstoneTime(timeRemaining, intoSeconds)
                                    
    -- display the number of minutes or seconds remaining until
    -- the player can use another soulstone
    timeRemaining = ShardTracker_Round(timeRemaining);
    if (timeRemaining > 0) then
        ShardTracker_SoulStoneText:SetText(timeRemaining);
        ShardTracker_SoulStoneText:Show();
    else
        ShardTracker_SoulStoneText:SetText("");
        ShardTracker_SoulStoneText:Hide();
    end
    
    -- set the color of the time text
    if (intoSeconds ~= nil) then
        ShardTracker_SoulStoneText:SetTextColor(SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[1],
                                                SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[2],
                                                SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR[3]);
    -- else we're displaying seconds (as opposed to minutes), so show
    -- the seconds in yellow text
    else
        ShardTracker_SoulStoneText:SetTextColor(0.89, 0.98, 0.46);
    end
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              HEALTHSTONE FUNCTIONS                                         --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- If the user clicks on the healthstone button, activate the healthstone.
-- If there's no healthstone to use, try to create one.
--
-----------------------------------------------------------------------------------
function ShardTracker_OnHealthButtonClick()
    
    -- if we found a healthstone in a bag and slot
    if (ShardTracker_HealthStoneLoc[1] ~= -1 and ShardTracker_HealthStoneLoc[2] ~= -1) then
    
        -- if we're a warlock and have a friendly target selected, try to give the healthstone to that target
        if (UnitClass("player") == SHARDTRACKER_WARLOCK and UnitExists("target") and UnitIsPlayer("target") and UnitCanCooperate("player", "target")) then
        
            -- pickup the healthstone and drop it on the target
            PickupContainerItem(ShardTracker_HealthStoneLoc[1], ShardTracker_HealthStoneLoc[2]);
            if ( CursorHasItem() ) then
                DropItemOnUnit("target");
                AcceptTrade();
                if (Chronos) then
                    Chronos.schedule(2, AcceptTrade);
                end
            end
            
        -- otherwise without a friendly target selected, use the healthstone
        else
            UseContainerItem(ShardTracker_HealthStoneLoc[1], ShardTracker_HealthStoneLoc[2]);
        
            -- notify any Warlocks in our party that we need another Healthstone
            ShardTracker_NotifyHealthstoneStatus(SHARDTRACKER_NEED_HEALTHSTONE_MSG);
        end
        
    -- else we don't have a healthstone, so if we're a warlock, try to create one
    else
        if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
            if (ShardTracker_TotalShards > 0 and ShardTracker_CreateHealthStoneSpellID) then
                CastSpell(ShardTracker_CreateHealthStoneSpellID, "spell");
            end
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Create a new healthstone if we click on a party member's healthstone button
--
-----------------------------------------------------------------------------------
function ShardTracker_PartyHealthstoneButtonClick()
    local myClass = UnitClass("player");
    if (myClass == SHARDTRACKER_WARLOCK) then
        if (ShardTracker_TotalShards > 0 and ShardTracker_CreateHealthStoneSpellID) then
            CastSpell(ShardTracker_CreateHealthStoneSpellID, "spell");
        end
    end
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                      SPELLSTONE AND FIRESTONE FUNCTIONS                                    --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Activate a spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_ActivateSpellStone()

    -- use the spellstone
    UseInventoryItem(GetInventorySlotInfo("SecondaryHandSlot"));    

    -- re-equip the old offhanditem, if any
    if (ShardTracker_OffHandItem) then
        ShardTrackerDebug("ShardTracker_ActivateSpellStone: looking for previous offhand item = "..ShardTracker_OffHandItem);
        theBag, theSlot = ShardTrackerFindItemBagSlotByName(ShardTracker_OffHandItem);
        if (theBag) then    
            ShardTrackerDebug("ShardTracker_ActivateSpellStone: found offhand item at bag =  "..theBag.." slot = "..theSlot);
            UseContainerItem(theBag, theSlot);
        else
            ShardTrackerDebug("ShardTracker_ActivateSpellStone: couldn't find offhand item!");
        end
    end
    
    -- reset the ShardTracker_SpellStoneEquipped and ShardTracker_SpellStoneReady and ShardTracker_SpellStoneInBag flags
    ShardTracker_SpellStoneEquipped = 0;
    ShardTracker_SpellStoneReady = 0;
    ShardTracker_SpellStoneIsActive = 1;
    ShardTracker_SpellStoneInBag = 0;
    ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreyed");
end


-----------------------------------------------------------------------------------
--
-- Create a new spellstone or firestone if we click on our spellstone or firestone 
-- button, or use our firestone or spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_OnSpellOrFireButtonClick(theType)
    local myClass = UnitClass("player");
    
    -- only allow spellstone/firestone usage if we're a warlock
    if (myClass == SHARDTRACKER_WARLOCK) then
    
        -- if we're clicking on a spellstone
        if (theType == "spell") then
        
            -- if a spellstone is sitting in our bag ready to be equipped
            if (ShardTracker_SpellStoneInBag == 1 and ShardTracker_SpellStoneEquipped ~= 1) then
                ShardTracker_EquipSpellOrFireStone(theType);

            -- if we have a spellstone equipped and it's ready for use
            elseif (ShardTracker_SpellStoneEquipped == 1 and ShardTracker_SpellStoneReady == 1) then
                ShardTrackerDebug("ShardTracker_OnSpellOrFireButtonClick: trying to use spellstone!");
                ShardTracker_ActivateSpellStone();

            -- else if we have shards and know how to create a spellstone, try to create a spellstone
            elseif (ShardTracker_TotalShards > 0 and ShardTracker_CreateSpellStoneSpellID and (ShardTracker_SpellStoneEquipped ~= 1)) then
                ShardTrackerDebug("Trying to cast create spellstone, spell #"..ShardTracker_CreateSpellStoneSpellID);
                CastSpell(ShardTracker_CreateSpellStoneSpellID, "spell");
                ShardTracker_SpellStoneIsActive = 0;
            end
            
        -- if we're clicking on a firestone
        elseif (theType == "fire") then
        
            -- if a firestone is sitting in our bag ready to be equipped
            if (ShardTracker_FireStoneInBag == 1 and ShardTracker_FireStoneEquipped ~= 1) then
                ShardTracker_EquipSpellOrFireStone(theType);

            -- if we have a firestone equipped, unequip it
            elseif (ShardTracker_FireStoneEquipped == 1) then
                ShardTracker_UnEquipFireStone();

            -- else if we have shards and know how to create a firestone, try to create a firestone
            elseif (ShardTracker_TotalShards > 0 and ShardTracker_CreateFireStoneSpellID and (ShardTracker_FireStoneEquipped ~= 1)) then
                ShardTrackerDebug("Trying to cast create firestone, fire #"..ShardTracker_CreateFireStoneSpellID);
                CastSpell(ShardTracker_CreateFireStoneSpellID, "spell");
                ShardTracker_FireStoneIsActive = 0;
            end
        end
        
    end
end


-----------------------------------------------------------------------------------
--
-- Unequip a spellstone or firestone
--
-----------------------------------------------------------------------------------
function ShardTracker_UnEquipFireStone()

    PickupInventoryItem(GetInventorySlotInfo("SecondaryHandSlot"));
    local bagResult = ShardTracker_BagItem();

    -- re-equip the old offhanditem, if any
    if (ShardTracker_OffHandItem) then
        ShardTrackerDebug("ShardTracker_UnEquipFireStone: looking for previous offhand item = "..ShardTracker_OffHandItem);
        theBag, theSlot = ShardTrackerFindItemBagSlotByName(ShardTracker_OffHandItem);
        if (theBag) then    
            ShardTrackerDebug("ShardTracker_UnEquipFireStone: found offhand item at bag =  "..theBag.." slot = "..theSlot);
            UseContainerItem(theBag, theSlot);
        else
            ShardTrackerDebug("ShardTracker_UnEquipFireStone: couldn't find offhand item!");
        end        
    end
    
    -- reset the ShardTracker_FireStoneEquipped and ShardTracker_FireStoneInBag flags
    ShardTracker_FireStoneEquipped = 0;
    ShardTracker_FireStoneInBag = 1;
    ShardTrackerMinimapButtonFire:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardFire");
end



-----------------------------------------------------------------------------------
--
-- Equip a spellstone or firestone
--
-----------------------------------------------------------------------------------
function ShardTracker_EquipSpellOrFireStone(theType)

    local theResult = true;
    
    -- if we're wielding a 2H weapon, we need to unequip it first
    local twoHandedWeapon = ShardTracker_IsWeaponTwoHanded();
    if (twoHandedWeapon) then
        PickupInventoryItem(GetInventorySlotInfo("MainHandSlot"));
        theResult = ShardTracker_BagItem();
    end

    -- if we don't have 2H weapon issues
    if (theResult) then    
    
        -- remember what item (if any) we have equipped in our offhand
        -- so that we can re-equip when we use the spellstone
        ShardTracker_RememberOffHandItem(twoHandedWeapon);

        -- if we're equipping a spellstone
        if (theType == "spell") then
        
            -- equip the spellStone
            PickupContainerItem(ShardTracker_SpellStoneLoc[1], ShardTracker_SpellStoneLoc[2]);
            ShardTrackerDebug("Picking up spellstone at bag = "..ShardTracker_SpellStoneLoc[1].." slot = "..ShardTracker_SpellStoneLoc[2]);
            if ( CursorHasItem() ) then
                ShardTrackerDebug("Cursor has item.  Trying to equip spellstone...");
                PickupInventoryItem(18);
            else
                ShardTrackerDebug("Cursor doesn't have item!");
            end

            -- we've equipped it, but it's not ready to be used yet (have to wait out the cooldown)
            ShardTracker_SpellStoneEquipped = 1;
            ShardTracker_SpellStoneReady = 0;
            ShardTracker_SpellStoneInBag = 0;
            ShardTracker_SpellStoneLoc = {-1, -1};
            ShardTrackerPrint("ShardTracker: Equipping Spellstone.");
            
            -- in case a firestone was equipped
            if (ShardTracker_FireStoneEquipped == 1) then
                ShardTracker_FireStoneEquipped = 0;
                ShardTrackerMinimapButtonFire:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardFire");
            end
            
        -- if we're equipping a firestone
        elseif (theType == "fire") then
        
            -- equip the firestone
            PickupContainerItem(ShardTracker_FireStoneLoc[1], ShardTracker_FireStoneLoc[2]);
            ShardTrackerDebug("Picking up firestone at bag = "..ShardTracker_FireStoneLoc[1].." slot = "..ShardTracker_FireStoneLoc[2]);
            if ( CursorHasItem() ) then
                ShardTrackerDebug("Cursor has item.  Trying to equip spellstone...");
                PickupInventoryItem(18);
            else
                ShardTrackerDebug("Cursor doesn't have item!");
            end

            -- we've equipped it
            ShardTracker_FireStoneEquipped = 1;
            ShardTracker_FireStoneInBag = 0;
            ShardTracker_FireStoneLoc = {-1, -1};
            ShardTrackerMinimapButtonFire:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardFireGreen");
            ShardTrackerPrint("ShardTracker: Equipping Firestone.");

            -- in case a spellstone was equipped
            if (ShardTracker_SpellStoneEquipped == 1) then
                ShardTracker_SpellStoneEquipped = 0;
                ShardTracker_SpellStoneReady = 0;
                ShardTrackerMinimapButtonSpell:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpell");
            end    

        end
    else
        ShardTrackerPrint(ST_SPELLSTONEERROR);
    end
    
end


-----------------------------------------------------------------------------------
--
-- Store what we have equipped in our offhand so we can reequip it after
-- using a spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_RememberOffHandItem(isTwoHanded)
    ShardTracker_OffHandItem = nil;
    
    local id = 0;
    if (isTwoHanded) then
        id = GetInventorySlotInfo("MainHandSlot");
    else
        id = GetInventorySlotInfo("SecondaryHandSlot");
    end
    
    ShardTracker_MoneyToggle();
    local hasItem = getglobal("ShardTrackerTooltip"):SetInventoryItem("player", id);
    ShardTracker_MoneyToggle();
    if (hasItem) then
        ShardTracker_MoneyToggle();
        local itemTip = ShardTracker_ScanToolTip("ShardTrackerTooltip");
        ShardTracker_ClearTooltip("ShardTrackerTooltip");
        ShardTracker_MoneyToggle();
        if (itemTip) then
            ShardTracker_OffHandItem = ShardTracker_GetItemName(itemTip);
            ShardTrackerDebug("ShardTracker_RememberOffHandItem: ShardTracker_OffHandItem = "..ShardTracker_OffHandItem);
            if (ShardTracker_OffHandItem == "NIL") then ShardTracker_OffHandItem = nil end;
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Show the time remaining until we can use a spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_ShowSpellStoneTime(timeRemaining)
                                    
    -- display the number of seconds remaining until
    -- the player can use the spellstone
    timeRemaining = ShardTracker_Round(timeRemaining);
    if (timeRemaining > 0) then
        ShardTracker_SpellStoneText:SetText(timeRemaining);
        ShardTracker_SpellStoneText:Show();
    else
        ShardTracker_SpellStoneText:SetText("");
        ShardTracker_SpellStoneText:Hide();
    end
    
    ShardTracker_SpellStoneText:SetTextColor(SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[1],
                                             SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[2],
                                             SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR[3]);
end

