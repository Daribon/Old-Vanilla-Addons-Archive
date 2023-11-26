--[[

    ShardTracker - A Warlock AddOn for World of Warcraft

    Concept by Kithador
    Originally written by Kithador
    Sorting code by Ryu
    Modified, rewritten and integrated by Cragganmore

    Cosmos and Sea dependancies removed by Gottac : wright_dj@hotmail.com
    1.04 - NCS
	o Minor color tweaks
	o Changed sound on Soulstone ready (made very quickly by me, someone
	  please supply something better)
    
        1.03 - NCS
    o Added Keybindings for Health,Soul,Spell stones
    o Fixed broken keybinding for Sort

    1.02 - NCS
    o Added /st flash x to allow users to define when to start flashing
    o Changed Graphics behind SoulShard Number, thanks to Toran

    This mod helps Warlocks to:
    
    o track how many soul shards you have
    o sort your soul shards into a specified bag
    o keep track of your healthstone status
    o create and use healthstones
    o give healthstones to other players
REMOVED o track your party members' healthstone status 
          and be notified when they need new healthstones
    o keep track of your soulstone status
    o create and use soulstones
    o see the cooldown time until you can re-cast soulstone,
      and be notified when the cooldown time expires
    o keep track of your spellstone status
    o create and equip spellstones
    o see the cooldown time until you can use an equipped spellstone
    o automatically re-equip the item that was in your off hand when you
      equipped the spellstone
        
    For non-warlocks, this AddOn will display a small button
    near the minimap when the player has a healthstone.  Clicking on this
    button will activate the healthstone.
    
]]--

SHARDTRACKER_DEBUG = false;
SHARDTRACKER_VERSION = "1.01";

SHARDTRACKER_FLASH_TIME_ON          = 0.75;     -- number of seconds to flash on
SHARDTRACKER_FLASH_TIME_OFF         = 0.75;     -- number of seconds to flash off
SHARDTRACKER_MIN_ALPHA              = 0.3;      -- minimum transparency to drop to when flashing
SHARDTRACKER_SHARD_ENABLED          = 1;        -- whether or not to show the number of shards button
SHARDTRACKER_HEALTHSTONE_ENABLED    = 1;        -- whether or not to show the healthstone button
SHARDTRACKER_SOULSTONE_ENABLED      = 1;        -- whether or not to show the soulstone button
SHARDTRACKER_SPELLSTONE_ENABLED     = 1;        -- whether or not to show the spellstone button
SHARDTRACKER_FIRST_TIME = { };
SHARDTRACKER_FIRST_TIME.ENABLED = true;
SHARDTRACKER_FIRST_TIME.SOUND = true;

SHARDTRACKER_CONFIG = { };
SHARDTRACKER_CONFIG.ENABLED           = 1;      -- whether or not the plugin should be active
SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 0;      -- whether or not to flash the healthstone button when we don't have a healthstone
SHARDTRACKER_CONFIG.USE_SOUND         = 1;      -- whether or not to play sounds when soulstone cooldowns expire / players need new healthstones
SHARDTRACKER_CONFIG.THE_SORT_BAG      = 4;      -- the default bag to sort shards into
SHARDTRACKER_CONFIG.SHARD_FLASH_NUM   = 2;      -- Flash on 'X' or less than number of shards

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              INITIALIZATION FUNCTIONS                                      --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Handle the loading stuff when the plugin first loads
--
-----------------------------------------------------------------------------------
function ShardTracker_OnLoad()  
    ShardTracker_ShardButton       = getglobal("ShardTrackerMinimapButton");
    ShardTracker_ShardCountLabel   = getglobal("ShardTrackerText");
    ShardTracker_HealthStoneButton = getglobal("ShardTrackerMinimapButtonHealth");
    ShardTracker_SoulStoneButton   = getglobal("ShardTrackerMinimapButtonSoul");
    ShardTracker_SpellStoneButton  = getglobal("ShardTrackerMinimapButtonSpell");
    ShardTracker_SoulStoneText     = getglobal("ShardTrackerSoulText");
    ShardTracker_SpellStoneText    = getglobal("ShardTrackerSpellText");
    
    ShardTracker_SpellStoneText:SetText("");
    ShardTracker_ShardButton:Hide();
    ShardTracker_HealthStoneButton:Hide();
    ShardTracker_SoulStoneButton:Hide();
    
    getglobal("ShardTrackerSortFrame"):Hide();
    
    ShardTracker_FlashTime = 0;                         -- timer for flashing buttons
    ShardTracker_FlashState = 1;                        -- whether we're flashing on or off
    ShardTracker_SoulStoneExpired = 0;                  -- whether the cooldown on using a soulstone has expired
    ShardTracker_TotalShards = 0;                       -- number of shards in our inventory
    ShardTracker_HaveHealthStone = 0;                   -- if we have a healthstone in our inventory
    ShardTracker_HaveSoulStone = 0;                     -- if we have a soulstone in our inventory
    ShardTracker_SpellStoneInBag = 0;                   -- if we've created a spellstone, but haven't yet equipped it
    ShardTracker_HealthStoneLoc = {-1, -1};             -- the bag / slot where our healthstone is
    ShardTracker_SoulstoneLoc = {-1, -1};               -- the bag / slot where our soulstone is
    ShardTracker_SpellStoneLoc = {-1, -1};              -- the bag / slot where our spellstone is
    ShardTracker_SpellStoneReady = 0;                   -- whether a spellstone is ready to be used
    ShardTracker_SpellStoneEquipped = 0;                -- whether a spellstone is equipped
    ShardTracker_SpellStoneIsActive = 0;                -- whether the spellstone was just used to cast its effect on us
    ShardTracker_Timer = { };                           -- structure to time cooldowns
    ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
    ShardTracker_Timer.SpellstoneTimeSeconds = 0
    ShardTracker_intoSeconds = nil;                     -- whether our soulstone cooldown timer is counting down minutes or seconds
    ShardTracker_UnderTwoMinutes = nil;                 -- whether our soulstone cooldown timer is under two minutes
    ShardTracker_LastMinute = 0;                        -- track the last minute that we checked the soulstone's cooldown
    ShardTracker_SpellTableBuilt = nil;                 -- whether we've built the list of create health/soulstone spells available to us
    ShardTracker_OffHandItem = nil;                     -- the item in our offhand, so we can reequip it once we use up a spellstone
    ShardTracker_HealthstoneFlashing = {0, 0, 0, 0};    -- track the flashing state of party member's healthstone buttons
    ShardTracker_SentHealthstoneNotification = 0;       -- whether we've already notified warlocks in the party that we need a new healthstone
    
    this:RegisterEvent("BAG_UPDATE");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("UNIT_NAME_UPDATE");
    this:RegisterEvent("SPELLCAST_START");
    this:RegisterEvent("SPELLS_CHANGED");
    this:RegisterEvent("LEARNED_SPELL_IN_TAB");
    this:RegisterEvent("UNIT_INVENTORY_CHANGED");

    -- shard sorting variables, from ryu's ShardSort code
    ShardTracker_ShardSortFrameCounter = 0;
    ShardTracker_ShardMoverIndex = 0;
    ShardTracker_TotalShardsToMove = 5;
    ShardTracker_ShardMoverRunning = nil;
    ShardTracker_ShardMoverArray = { };
    ShardTracker_ShardMoverFilled = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil};

	SLASH_SHARDTRACKER1 = "/st";
	SLASH_SHARDTRACKER2 = "/shardtracker";
	SlashCmdList["SHARDTRACKER"] = function(msg)
		Shardtracker_ChatCommandHandler(msg);
	end
    
end

function ShardTracker_Button_OnLoad()
   	this:RegisterEvent("UPDATE_BINDINGS");
   	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
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
local function ShardTracker_MoneyToggle()
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


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              EVENT HANDLING FUNCTIONS                                      --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Checks for events that might alter the shard count
--
-----------------------------------------------------------------------------------
function ShardTracker_OnEvent(event)

    -- if an event occurs that would affect the number of shards, soulstone, healthstone, or spellstone, update us
    if (UnitName("player") ~= "Unknown Being" and UnitName("player") ~= "Unknown Entity" and (event == "BAG_UPDATE" or event == "UNIT_NAME_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "UNIT_INVENTORY_CHANGED") ) then
        ShardTracker_UpdateShardTracker();
        
    -- if we're using a soulstone on someone (casting Soulstone Resurrection), reset the soulstone timer
    elseif (event == "SPELLCAST_START") then
        if (arg1 == "Soulstone Resurrection") then
            ShardTracker_StartSoulstoneTimer();
        --elseif (string.find(arg1, "Create Spellstone", 1, true)) then
        --  ShardTracker_StartSpellstoneTimer();
        end
        
    -- if we learned new spells, update the list of spells we can cast
    -- since now we might be able to create a better healthstone or soulstone
    elseif (event == "LEARNED_SPELL_IN_TAB" or event == "SPELLS_CHANGED") then
        ShardTracker_BuildSpellTable();     
    end
end


---------------------------------------------------------------------------------
--
-- Break a chat command into its command and variable parts (i.e. "debug on"
-- breaks into command = "debug" and variable = "on"
-- 
---------------------------------------------------------------------------------
function ShardTracker_ParseCommand(msg)
    firstSpace = string.find(msg, " ", 1, true);
    if (firstSpace) then
        local command = string.sub(msg, 1, firstSpace - 1);
        local var  = string.sub(msg, firstSpace + 1);
        return command, var
    else
        return msg, "";
    end
end


---------------------------------------------------------------------------------
--
-- A simple chat command handler that can take commands in the form: "/slashCommand command var"
-- 
---------------------------------------------------------------------------------
function Shardtracker_ChatCommandHandler(msg)
    local command, var = ShardTracker_ParseCommand(msg);
    if ((not command) and msg) then
        command = msg;
    end
    if (command) then
        command = string.lower(command);
        if (command == "debug") then
            ShardTracker_ToggleDebug();
        elseif (command == "toggle") then
            ShardTracker_Toggle();
        elseif (command == "on") then
            ShardTracker_Toggle(1);
        elseif (command == "off") then
            ShardTracker_Toggle(0);
        elseif (command == "bag") then
            ShardTracker_SetShardBag(var);
        elseif (command == "sort") then
            ShardTracker_SortShards();
        elseif (command == "report") then
            ShardTracker_DebugPrintStatus();
        elseif (command == "version") then
            Print("ShardTracker Version "..SHARDTRACKER_VERSION, 1, 1, 0.5);
        elseif (command == "sound") then
            if (var == "on") then
				PlaySoundFile("Interface\\AddOns\\ShardTracker\\SoulStone.wav");
                ShardTracker_Toggle_Sound(1);
            elseif (var == "off") then
                ShardTracker_Toggle_Sound(0);
            else
                ShardTracker_Toggle_Sound();
            end
        elseif (command == "flash") then
       		SHARDTRACKER_CONFIG.SHARD_FLASH_NUM = tonumber(var);
            ChatFrame1:AddMessage("Shard count will flash on "..SHARDTRACKER_CONFIG.SHARD_FLASH_NUM.." and below", 1.0, 1.0, 0.5);
        elseif (command == "" or command == "help" or command == "?") then
            if (ChatFrame1) then
                ChatFrame1:AddMessage("Shardtracker", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("Usage: /shardtracker or /st", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/shardtracker on|off|toggle.  Turns ShardTracker on or off, or toggles on/off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/shardtracker sort.  Sorts all the shards into the default bag.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/shardtracker bag [0-4]. Sets the default bag for shards.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/shardtracker sound on|off. Turns sound effects on or off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/shardtracker flash [number]. Sets no. of shards to start flashing at.", 1.0, 1.0, 0.5);
            end
        elseif (command == "testyes" or command == "testno") then
            ShardTracker_DebugHealthstonePartyCode(command, var);
        end
    end
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              MAIN/UPDATE FUNCTIONS                                         --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
--
-- Update the number of shards in the player's pack, as well as the
-- healthstone and soulstone status
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateShardTracker()
    local shardCount = 0;
    local foundSoulStone = 0;
    local foundHealthStone = 0;
    local foundSpellStone = 0;
    
    -- if this is our first update, build the table of known spells
    -- so we can cast create healthstone/soulstone spells
    if (not ShardTracker_SpellTableBuilt) then
        ShardTracker_BuildSpellTable();
        ShardTracker_SpellTableBuilt = true;
    end

    local theResult = { };
    ShardTracker_PlayerClass = UnitClass("player");

    -- now we're going to look through all our bags to see how many
    -- shards we have, whether we have a healthstone, and whether
    -- we have a soulstone
    
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
                    if (itemName ~= "" and itemName ~= nil) then

                        -- if the item is a soul shard, increase the count
                        if (itemName == "Soul Shard") then
                            shardCount = shardCount+ 1;

                        -- if the item is a soulstone, remember which slot it's in so
                        -- that we can activate it later, if the player clicks on the healthstone button
                        elseif (string.find(itemName, "Soulstone", 1, TRUE) ~= nil) then
                            foundSoulStone = 1;
                            ShardTracker_SoulstoneLoc = {bag, slot};
                            ShardTracker_MoneyToggle();
                            --theResult = sea.wow.tooltip.scan("ShardTrackerTooltip");
                            theResult = easyscan("ShardTrackerTooltip");
                            ShardTracker_MoneyToggle();

                            -- look for the "Cooldown remaining" text in the stone's tooltip
                            timeRemainingText = theResult[6].left;
                            if (string.find(timeRemainingText, "Cooldown remaining", 1, TRUE) ~= nil) then
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
                                   	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00**SOULSTONE cooldown is over**|r");
                                    if (SHARDTRACKER_CONFIG.USE_SOUND) then
										PlaySoundFile("Interface\\AddOns\\ShardTracker\\SoulStone.wav");
                                    end
                                end
                                ShardTracker_SoulStoneExpired = 1;
                            end

                        -- if the item is a healthstone, remember which slot it's in so
                        -- that we can activate it later, if the player clicks on the healthstone button
                        elseif (string.find(itemName, "Healthstone", 1, TRUE) ~= nil) then
                            foundHealthStone = 1;
                            ShardTracker_HealthStoneLoc = {bag, slot};
                            
                        -- if the item is a spellstone
                        elseif (string.find(itemName, "Spellstone", 1, TRUE) ~= nil and (ShardTracker_SpellStoneEquipped ~= 1)) then
                            ShardTracker_SpellStoneInBag = 1;
                            ShardTracker_SpellStoneLoc = {bag, slot};
                        end
                    end
                end
            end
        end
    end
    
    -------------------------------------------------------------------------------------
    -- Now we're done looking through our pack, so we need to update our minimap buttons
    -------------------------------------------------------------------------------------
            
    -- if we're a warlock, we'll want to display the shard and soulstone buttons 
    if (ShardTracker_PlayerClass == "Warlock") then
    
        --------------------------------
        -- Handle Shards
        --------------------------------
    
        -- display the number of shards
        ShardTracker_ShardCountLabel:SetText(shardCount);
        
       	if (not SHARDTRACKER_CONFIG.SHARD_FLASH_NUM) then
			SHARDTRACKER_CONFIG.SHARD_FLASH_NUM = 2;
		end

		-- if the number of shards is less than X, display the number in yellow
        if (shardCount <= SHARDTRACKER_CONFIG.SHARD_FLASH_NUM) then
            ShardTracker_ShardCountLabel:SetTextColor(1.0,0.8,0.0);
            ShardTracker_ShardButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardBlankRed");
        else
            ShardTracker_ShardCountLabel:SetTextColor(0.4,1.0,0.0);
            ShardTracker_ShardButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardBlank");
        end
        if (SHARDTRACKER_SHARD_ENABLED == 1) then
            ShardTracker_ShardCountLabel:Show();
            ShardTracker_ShardButton:Show();
        else
            ShardTracker_ShardCountLabel:Hide();
            ShardTracker_ShardButton:Hide();
        end
        
        --------------------------------
        -- Handle Soulstone
        --------------------------------

        -- display the soulstone button, if we have one in inventory
        if (SHARDTRACKER_SOULSTONE_ENABLED == 1) then
            ShardTracker_SoulStoneButton:Show();
            ShardTracker_SoulStoneText:Show()
            
            -- if no soulstone in inventory, show the greyed out button
            if (foundSoulStone == 1) then
                ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoul");
            else
                ShardTracker_SoulstoneLoc = {-1, -1};
                ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulGreyed");
                
                -- if we'd cast Soulstone Resurrection and haven't made a new Soulstone, track the time until we can cast it again
                if (ShardTracker_Timer.SoulstoneExpireTimeSeconds ~= 0) then
                    local timeRemaining = ShardTracker_Timer.SoulstoneExpireTimeSeconds - GetTime();
                    if (timeRemaining <= 0) then
                        ShardTracker_SoulStoneExpired = 1;
                        ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
                    elseif (timeRemaining < 60) then
                        ShardTracker_intoSeconds = true;
                    elseif (timeRemaining < 120) then
                        ShardTracker_UnderTwoMinutes = true;
                    else
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
        if (SHARDTRACKER_SPELLSTONE_ENABLED == 1) then
            local spellStoneInOffHand = 0;
            ShardTracker_SpellStoneButton:Show();
            ShardTracker_SpellStoneText:Show()

            -- see what we have in our secondary hand slot
            local id = GetInventorySlotInfo("SecondaryHandSlot");
            ShardTracker_MoneyToggle();
            local hasItem = getglobal("ShardTrackerTooltip"):SetInventoryItem("player", id);
            ShardTracker_MoneyToggle();

            -- if we're carrying an item in our secondary hand slot
            if (hasItem) then
                ShardTracker_MoneyToggle();
                --local itemTip = Sea.wow.tooltip.scan("ShardTrackerTooltip");
                --Sea.wow.tooltip.clear("ShardTrackerTooltip");
                local itemTip = easyscan("ShardTrackerTooltip");
                easyclear("ShardTrackerTooltip");
                ShardTracker_MoneyToggle();

                -- if that item has a tooltip description
                if (itemTip) then

                    -- if the item is a spellstone
                    local itemName = ShardTracker_GetItemName(itemTip);
                    if (string.find(itemName, "Spellstone", 1, true)) then

                        spellStoneInOffHand = 1;

                        -- look for the "Cooldown remaining" text in the stone's tooltip
                        timeRemainingText = itemTip[8].left;
                        if (string.find(timeRemainingText, "Cooldown remaining", 1, TRUE) ~= nil) then
                            ShardTracker_SpellStoneReady = 0;

                            -- grab the number of seconds remaining
                            for theTime in string.gfind(timeRemainingText, "%d+") do
                                timeRemaining = theTime;
                            end

                            -- check if the tooltip has the word "sec" in it, we're counting down seconds
                            -- otherwise, we're counting down minutes
                            timeRemaining = tonumber(timeRemaining);

                            ShardTracker_ShowSpellstoneTime(timeRemaining);

                        -- else if there's no "cooldown remaining" then the cooldown has expired and
                        -- the spellstone is ready for use
                        elseif (ShardTracker_SpellStoneIsActive == 0) then
                            ShardTracker_SpellStoneReady = 1;
                            ShardTracker_SpellStoneText:SetText("");
                            ShardTracker_SpellStoneText:Hide();
                        end
                    end
                end
            end
            
            -- if the spellstone is equipped, show the icon
            if (ShardTracker_SpellStoneReady == 1) then
                ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreen");              
            elseif (ShardTracker_SpellStoneInBag == 1) then
                ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpell");              
            elseif (ShardTracker_SpellStoneText:GetText() ~= "" and ShardTracker_SpellStoneText:GetText() ~= nil) then
                ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreyedHole");
            else
                ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreyed");
            end
            
        -- else if spellstone is disabled, hide the button
        else
            ShardTracker_SpellStoneButton:Hide();
            ShardTracker_SpellStoneText:Hide();
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

	--DEFAULT_CHAT_FRAME:AddMessage("Oh Yeah");

    -- regardless of character class, display the healthstone button, if we have one in inventory
    if ((foundHealthStone == 1 and SHARDTRACKER_HEALTHSTONE_ENABLED == 1) or SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 1) then
        ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealth");
        ShardTracker_HealthStoneButton:Show();
    else
        ShardTracker_HealthStoneButton:Show();
    end
        
    -- if we don't have a healthstone, reset the variable that tells us where it is in our pack
    if (foundHealthStone == 0) then
        ShardTracker_HealthStoneLoc = {-1, -1};
        ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealthGreyed");
    end
    
    -- store the total number of shards for later use
    ShardTracker_TotalShards = shardCount;
    ShardTracker_HaveHealthStone = foundHealthStone;
    ShardTracker_HaveSoulStone = foundSoulStone;
    
end


-----------------------------------------------------------------------------------
--
-- Update the flashing buttons and everything else that needs to update each frame
--
-----------------------------------------------------------------------------------
function ShardTracker_OnUpdate(elapsed)

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

    -- flash the healthstone button
    if (SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 1) then
        if (ShardTracker_HaveHealthStone == 0) then
            if ( ShardTracker_FlashState == 1 ) then
                shardAlphaValue = (SHARDTRACKER_FLASH_TIME_ON - ShardTracker_FlashTime) / SHARDTRACKER_FLASH_TIME_ON;
                shardAlphaValue = shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA) + SHARDTRACKER_MIN_ALPHA;
            else
                shardAlphaValue = ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON;
                shardAlphaValue = (shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA)) + SHARDTRACKER_MIN_ALPHA;
                ShardTracker_HealthStoneButton:SetAlpha(ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON);
            end
            ShardTracker_HealthStoneButton:SetAlpha(shardAlphaValue);
        else
            ShardTracker_HealthStoneButton:SetAlpha(1.0);
        end
    end
        
    if (ShardTracker_PlayerClass == "Warlock") then
    
        -- flash the soulstone button
        if (SHARDTRACKER_SOULSTONE_ENABLED == 1) then
            if (ShardTracker_SoulStoneExpired == 1) then
                if ( ShardTracker_FlashState == 1 ) then
                    shardAlphaValue = (SHARDTRACKER_FLASH_TIME_ON - ShardTracker_FlashTime) / SHARDTRACKER_FLASH_TIME_ON;
                    shardAlphaValue = shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA) + SHARDTRACKER_MIN_ALPHA;
                else
                    shardAlphaValue = ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON;
                    shardAlphaValue = (shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA)) + SHARDTRACKER_MIN_ALPHA;
                    ShardTracker_SoulStoneButton:SetAlpha(ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON);
                end
                ShardTracker_SoulStoneButton:SetAlpha(shardAlphaValue);
            else
                ShardTracker_SoulStoneButton:SetAlpha(1.0);
            end
        end
        
        -- flash the total shards button
        if (SHARDTRACKER_SHARD_ENABLED == 1) then
            if (ShardTracker_TotalShards <= SHARDTRACKER_CONFIG.SHARD_FLASH_NUM) then
                if ( ShardTracker_FlashState == 1 ) then
                    shardAlphaValue = (SHARDTRACKER_FLASH_TIME_ON - ShardTracker_FlashTime) / SHARDTRACKER_FLASH_TIME_ON;
                    shardAlphaValue = shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA) + SHARDTRACKER_MIN_ALPHA;
                else
                    shardAlphaValue = ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON;
                    shardAlphaValue = (shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA)) + SHARDTRACKER_MIN_ALPHA;
                    ShardTracker_ShardButton:SetAlpha(ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON);
                    ShardTracker_ShardCountLabel:SetAlpha(ShardTracker_FlashTime / SHARDTRACKER_FLASH_TIME_ON);
                end
                ShardTracker_ShardButton:SetAlpha(shardAlphaValue);
                ShardTracker_ShardButton:Show();
                ShardTracker_ShardCountLabel:SetAlpha(shardAlphaValue);
                ShardTracker_ShardCountLabel:SetTextColor(1.0,0.8,0.0);
            	ShardTracker_ShardButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardBlankRed");
                ShardTracker_ShardCountLabel:Show();
            else
                ShardTracker_ShardButton:SetAlpha(1.0);
            	ShardTracker_ShardCountLabel:SetTextColor(0.4,1.0,0.0);
            	ShardTracker_ShardButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardBlank");
                ShardTracker_ShardCountLabel:SetAlpha(1.0);
            end
        end
        
        if ( ShardTracker_FlashState == 1 ) then
            shardAlphaValue = (SHARDTRACKER_FLASH_TIME_ON - ShardTracker_FlashTime) / SHARDTRACKER_FLASH_TIME_ON;
            shardAlphaValue = shardAlphaValue * (1 - SHARDTRACKER_MIN_ALPHA) + SHARDTRACKER_MIN_ALPHA;
        end

        -- if a minute has passed, or we're counting down seconds on the soulstone, or counting down seconds on the spellstone, update the shard tracker
        local hour, minute = GetGameTime();
        if (minute ~= ShardTracker_LastMinute or ShardTracker_intoSeconds or ShardTracker_UnderTwoMinutes or (ShardTracker_SpellStoneEquipped == 1 and ShardTracker_SpellStoneReady == 0)) then
            ShardTracker_LastMinute = minute;
            ShardTracker_UpdateShardTracker();
        end

        -- update the shard sorting code
        ShardTracker_UpdateShardSorter();
        
    end
end

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              SOULSTONE FUNCTIONS                                   --
--                                                                                            --
--============================================================================================--
--============================================================================================--

-----------------------------------------------------------------------------------
--
-- Create a new soulstone if we click on our soulstone button
--
-----------------------------------------------------------------------------------
function ShardTracker_OnSoulButtonClick(button)
    local myClass = UnitClass("player");
    if (myClass == "Warlock") then

    	if (button == "RightButton" and ShardTracker_SummounMountSpellID) then
	    	CastSpell(ShardTracker_SummounMountSpellID, "spell");
		else
	        if (ShardTracker_HaveSoulStone == 1) then
	            if (ShardTracker_SoulstoneLoc[1] ~= -1 and ShardTracker_SoulstoneLoc[2] ~= -1) then
	                UseContainerItem(ShardTracker_SoulstoneLoc[1], ShardTracker_SoulstoneLoc[2]);
	            end
	        elseif (ShardTracker_TotalShards > 0 and ShardTracker_CreateSoulStoneSpellID) then
	            CastSpell(ShardTracker_CreateSoulStoneSpellID, "spell");
	        end
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


function easyround(x)
	if(x - math.floor(x) > 0.5) then
		x = x + 0.5;
	end
	return math.floor(x);
end

function easyclear( tooltipBase )
	for i=1, 15, 1 do
		getglobal(tooltipBase.."TextLeft"..i):SetText("");
		getglobal(tooltipBase.."TextRight"..i):SetText("");
	end		
end

function easyscan ( tooltipBase )
		if ( tooltipBase == nil ) then 
			tooltipBase = "GameTooltip";
		end
	
		local strings = {};
		for idx = 1, 10 do
			local textLeft = nil;
			local textRight = nil;
			ttext = getglobal(tooltipBase.."TextLeft"..idx);
			if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
			then
				textLeft = ttext:GetText();
			end
			ttext = getglobal(tooltipBase.."TextRight"..idx);
			if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil)
			then
				textRight = ttext:GetText();
			end
			if (textLeft or textRight)
			then
				strings[idx] = {};
				strings[idx].left = textLeft;
				strings[idx].right = textRight;
			end	
		end
	
		return strings;
end
-----------------------------------------------------------------------------------
--
-- Show the time remaining until we can cast another soulstone
--
-----------------------------------------------------------------------------------
function ShardTracker_ShowSoulstoneTime(timeRemaining, intoSeconds)
                                    
    -- display the number of minutes or seconds remaining until
    -- the player can use another soulstone
    timeRemaining = easyround(timeRemaining);
    
    if (timeRemaining > 0) then
        ShardTracker_SoulStoneText:SetText(timeRemaining);
        ShardTracker_SoulStoneText:Show();
    else
        ShardTracker_SoulStoneText:SetText("");
        ShardTracker_SoulStoneText:Hide();
    end
    
    -- if we're displaying seconds (as opposed to minutes), show
    -- the seconds in yellow text
    if (intoSeconds ~= nil) then
        ShardTracker_SoulStoneText:SetTextColor(1.0,1.0,0.3);
    else
        ShardTracker_SoulStoneText:SetTextColor(1.0,1.0,1.0);
    end
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              HEALTHSTONE FUNCTIONS                                     --
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
        if (UnitClass("player") == "Warlock" and UnitExists("target") and UnitIsPlayer("target") and UnitCanCooperate("player", "target")) then
        
            -- pickup the healthstone and drop it on the target
            PickupContainerItem(ShardTracker_HealthStoneLoc[1], ShardTracker_HealthStoneLoc[2]);
            if ( CursorHasItem() ) then
                DropItemOnUnit("target");
            end
            
        -- otherwise without a friendly target selected, use the healthstone
        else
            UseContainerItem(ShardTracker_HealthStoneLoc[1], ShardTracker_HealthStoneLoc[2]);
        end
        
    -- else we don't have a healthstone, so if we're a warlock, try to create one
    else
        if (UnitClass("player") == "Warlock") then
            if (ShardTracker_TotalShards > 0 and ShardTracker_CreateHealthStoneSpellID) then
                CastSpell(ShardTracker_CreateHealthStoneSpellID, "spell");
            end
        end
    end
end

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              SPELLSTONE FUNCTIONS                                      --
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
    ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreyed");
end


-----------------------------------------------------------------------------------
--
-- Create a new spellstone if we click on our spellstone button, or use our spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_OnSpellButtonClick()
    local myClass = UnitClass("player");
    if (myClass == "Warlock") then
    
        -- if a spellstone is sitting in our bag ready to be equipped
        if (ShardTracker_SpellStoneInBag == 1 and ShardTracker_SpellStoneEquipped ~= 1) then
            ShardTracker_EquipSpellStone();
            
        -- if we have a spellstone equipped and it's ready for use
        elseif (ShardTracker_SpellStoneEquipped == 1 and ShardTracker_SpellStoneReady == 1) then
            ShardTrackerDebug("ShardTracker_OnSpellButtonClick: trying to use spellstone!");
            ShardTracker_ActivateSpellStone();

        -- else if we have shards and know how to create a spellstone, try to create a spellstone
        elseif (ShardTracker_TotalShards > 0 and ShardTracker_CreateSpellStoneSpellID and (ShardTracker_SpellStoneEquipped ~= 1)) then
            ShardTrackerDebug("Trying to cast create spellstone, spell #"..ShardTracker_CreateSpellStoneSpellID);
            CastSpell(ShardTracker_CreateSpellStoneSpellID, "spell");
            ShardTracker_SpellStoneIsActive = 0;
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Equip a spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_EquipSpellStone()

    -- remember what item (if any) we have equipped in our offhand
    -- so that we can re-equip when we use the spellstone
    ShardTracker_RememberOffHandItem();

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
    
    
end


-----------------------------------------------------------------------------------
--
-- Store what we have equipped in our offhand so we can reequip it after
-- using a spellstone
--
-----------------------------------------------------------------------------------
function ShardTracker_RememberOffHandItem()
    ShardTracker_OffHandItem = nil;
    
    local id = GetInventorySlotInfo("SecondaryHandSlot");
    ShardTracker_MoneyToggle();
    local hasItem = getglobal("ShardTrackerTooltip"):SetInventoryItem("player", id);
    ShardTracker_MoneyToggle();
    if (hasItem) then
        ShardTracker_MoneyToggle();
        --local itemTip = Sea.wow.tooltip.scan("ShardTrackerTooltip");
        --sea.wow.tooltip.clear("ShardTrackerTooltip");
        local itemTip = easyscan("ShardTrackerTooltip");
        easyclear("ShardTrackerTooltip");
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
function ShardTracker_ShowSpellstoneTime(timeRemaining)
                                    
    -- display the number of seconds remaining until
    -- the player can use the spellstone
    --timeRemaining = Sea.math.round(timeRemaining);
    timeRemaining = easyround(timeRemaining);
    if (timeRemaining > 0) then
        ShardTracker_SpellStoneText:SetText(timeRemaining);
        ShardTracker_SpellStoneText:Show();
    else
        ShardTracker_SpellStoneText:SetText("");
        ShardTracker_SpellStoneText:Hide();
    end
    
    ShardTracker_SpellStoneText:SetTextColor(0.7, 0.95, 0.98);
end



--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              UTILITY FUNCTIONS                                             --
--                                                                                            --
--============================================================================================--
--============================================================================================--


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
        --Sea.wow.tooltip.clear("ShardTrackerTooltip");
        easyclear("ShardTrackerTooltip");
        ShardTracker_MoneyToggle();
    end
    return itemName;
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
    ShardTracker_SummounMountSpellID = nil;
    
    -- as we look through the spellbook, these variables will
    -- allow us to remember the highest level of a spell that
    -- we're found overall, since we only want to case the
    -- highest level create health/soulstone spell
    local HighestSoulstoneSpellLevelSeen = 0;
    local HighestHealthstoneSpellLevelSeen = 0;
    local HighestSpellstoneSpellLevelSeen = 0;
    local spellLevel = 0;
    
    -- for all 180 possible spell entries
    for id = 1, 180 do 
        local spellName, subSpellName = GetSpellName(id, "spell");
        if (spellName) then
        
            -- find the highest level healthstone we can make
            if (string.find(spellName, "Healthstone", 1, true)) then
                spellLevel = 0;
                if (spellName == "Create Healthstone (Minor)") then
                    spellLevel = 1;
                elseif (spellName == "Create Healthstone (Lesser)") then
                    spellLevel = 2;
                elseif (spellName == "Create Healthstone") then
                    spellLevel = 3;
                elseif (spellName == "Create Healthstone (Greater)") then
                    spellLevel = 4;
                elseif (spellName == "Create Healthstone (Major)") then
                    spellLevel = 5;
                end
                if (spellLevel > HighestHealthstoneSpellLevelSeen) then
                    ShardTracker_CreateHealthStoneSpellID = id;
                    HighestHealthstoneSpellLevelSeen = spellLevel;
                end
                
            -- find the highest level soulstone we can make
            elseif (string.find(spellName, "Soulstone", 1, true)) then
                spellLevel = 0;
                if (spellName == "Create Soulstone (Minor)") then
                    spellLevel = 1;
                elseif (spellName == "Create Soulstone (Lesser)") then
                    spellLevel = 2;
                elseif (spellName == "Create Soulstone") then
                    spellLevel = 3;
                elseif (spellName == "Create Soulstone (Greater)") then
                    spellLevel = 4;
                elseif (spellName == "Create Soulstone (Major)") then
                    spellLevel = 5;
                end
                if (spellLevel > HighestSoulstoneSpellLevelSeen) then
                    ShardTracker_CreateSoulStoneSpellID = id;
                    HighestSoulstoneSpellLevelSeen = spellLevel;
                end
                
            -- find the highest level spellstone we can make
            elseif (string.find(spellName, "Spellstone", 1, true)) then
                spellLevel = 0;
                if (spellName == "Create Spellstone") then
                    spellLevel = 3;
                elseif (spellName == "Create Spellstone (Greater)") then
                    spellLevel = 4;
                elseif (spellName == "Create Spellstone (Major)") then
                    spellLevel = 5;
                end
                if (spellLevel > HighestSpellstoneSpellLevelSeen) then
                    ShardTracker_CreateSpellStoneSpellID = id;
                    HighestSpellstoneSpellLevelSeen = spellLevel;
                end
                
            -- find the Mount Spell
            elseif (string.find(spellName, "Felsteed", 1, true)) then
                if (spellName == "Summon Felsteed") then
					ShardTracker_SummounMountSpellID = id;
				end
            end
        end
    end
end


---------------------------------------------------------------------------------
--
-- Show the tooltip text
-- 
---------------------------------------------------------------------------------
function ShardTracker_ShowShardButtonTooltip(theText1, theText2, theText3, theText4, theText5)

    -- Set the anchor and text for the tooltip.
    ShardTracker_MoneyToggle();
    --Sea.wow.tooltip.clear("GameTooltip");
    easyclear("GameTooltip");
    ShardTracker_MoneyToggle();

    ShardTracker_MoneyToggle();
    GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
    ShardTracker_MoneyToggle();

    ShardTracker_MoneyToggle();
    GameTooltip:SetText(theText1, 0.39, 0.77, 0.16);
    ShardTracker_MoneyToggle();
    
    -- if we're not a warlock and this is a healthstone, show a different tooltip
    if (UnitClass("player") ~= "Warlock" and theText1 == SHARDTRACKER_HEALTHBUTTON_TIP1) then
        ShardTracker_MoneyToggle();
        GameTooltip:AddLine(SHARDTRACKER_HEALTHBUTTON_TIP5, 0.82, 0.24, 0.79);
        ShardTracker_MoneyToggle();
    else

--[[
        -- add description lines to the tooltip
        if (theText2) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText2, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
        if (theText3) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText3, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
        if (theText4) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText4, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
        if (theText5) then
            ShardTracker_MoneyToggle();
            GameTooltip:AddLine(theText5, 0.82, 0.24, 0.79);
            ShardTracker_MoneyToggle();
        end
]]--
    end
    
    -- Adjust width and height to account for new lines and show the tooltip
    -- (the Show() command automatically adjusts the width/height)
    GameTooltip:Show();

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
-- Handle the toggling on and off of various aspects of the plugin
--
-----------------------------------------------------------------------------------
function ShardTracker_Toggle_Flash_Health(toggle)
    if (toggle == 1 and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 1;
        if (ShardTracker_PlayerClass ~= "Warlock") then
            ShardTracker_HealthStoneButton:Show();
        end
    else
        SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 0;
        if (ShardTracker_PlayerClass ~= "Warlock") then
            ShardTracker_HealthStoneButton:Hide();
        end
    end
end
function ShardTracker_Toggle_Shards(toggle)
    if (toggle == 1 and ShardTracker_PlayerClass == "Warlock" and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_SHARD_ENABLED = 1;
        ShardTracker_ShardButton:Show();
        ShardTracker_ShardCountLabel:Show();
    else
        SHARDTRACKER_SHARD_ENABLED = 0;
        ShardTracker_ShardButton:Hide();
        ShardTracker_ShardCountLabel:Hide();
        ShardTracker_ShardButton:SetAlpha(1.0);
        ShardTracker_ShardCountLabel:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle_Health(toggle)
    if (toggle == 1 and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_HEALTHSTONE_ENABLED = 1;
        ShardTracker_HealthStoneButton:Show();
    else
        SHARDTRACKER_HEALTHSTONE_ENABLED = 0;
        ShardTracker_HealthStoneButton:Hide();
    end
end
function ShardTracker_Toggle_Soul(toggle)
    if (toggle == 1 and ShardTracker_PlayerClass == "Warlock" and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_SOULSTONE_ENABLED = 1;
        --if (ShardTracker_HaveSoulStone == 1) then
            ShardTracker_SoulStoneButton:Show();
            ShardTracker_SoulStoneText:Show();
        --end
    else
        SHARDTRACKER_SOULSTONE_ENABLED = 0;
        ShardTracker_SoulStoneButton:Hide();
        ShardTracker_SoulStoneButton:SetAlpha(1.0);
        ShardTracker_SoulStoneText:Hide();
        ShardTracker_SoulStoneText:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle_Spell(toggle)
    if (toggle == 1 and ShardTracker_PlayerClass == "Warlock" and SHARDTRACKER_CONFIG.ENABLED == 1) then
        SHARDTRACKER_SPELLSTONE_ENABLED = 1;
        ShardTracker_SpellStoneButton:Show();
        ShardTracker_SpellStoneText:Show();
    else
        SHARDTRACKER_SPELLSTONE_ENABLED = 0;
        ShardTracker_SpellStoneButton:Hide();
        ShardTracker_SpellStoneButton:SetAlpha(1.0);
        ShardTracker_SpellStoneText:Hide();
        ShardTracker_SpellStoneText:SetAlpha(1.0);
    end
end
function ShardTracker_Toggle(toggle)
    if (not toggle) then
        if (SHARDTRACKER_CONFIG.ENABLED == 1) then
            toggle = 0;
        else
            toggle = 1;
        end
    end
    if (toggle == 1) then
        if (not SHARDTRACKER_FIRST_TIME.ENABLED and (SHARDTRACKER_CONFIG.ENABLED ~= toggle)) then
            ChatFrame1:AddMessage("ShardTracker: Enabled", 1.0, 1.0, 0.5);
        else
            SHARDTRACKER_FIRST_TIME.ENABLED = false;
        end
    else
        if (SHARDTRACKER_CONFIG.ENABLED ~= toggle) then
            ChatFrame1:AddMessage("ShardTracker: Disabled", 1.0, 1.0, 0.5);
        end
    end
    SHARDTRACKER_CONFIG.ENABLED = toggle;
    
    ShardTracker_Toggle_Shards(toggle);
    ShardTracker_Toggle_Health(toggle);
    ShardTracker_Toggle_Soul(toggle);   
    ShardTracker_Toggle_Spell(toggle);
end



-----------------------------------------------------------------------------------
--
-- Toggle Debug Messages
--
-----------------------------------------------------------------------------------
function ShardTracker_ToggleDebug()
    SHARDTRACKER_DEBUG = (not SHARDTRACKER_DEBUG);
    if (SHARDTRACKER_DEBUG) then
        ChatFrame1:AddMessage("ShardTracker: Debug On", 1.0, 1.0, 0.5);
    else
        ChatFrame1:AddMessage("ShardTracker: Debug Off", 1.0, 1.0, 0.5);
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
            ChatFrame1:AddMessage("ShardTracker: Sound On", 1.0, 1.0, 0.5);
        else
            SHARDTRACKER_FIRST_TIME.SOUND = false;
        end
        SHARDTRACKER_CONFIG.USE_SOUND = true;
    else
        if (SHARDTRACKER_CONFIG.USE_SOUND ~= toggle) then
            ChatFrame1:AddMessage("ShardTracker: Sound Off", 1.0, 1.0, 0.5);
        end
        SHARDTRACKER_CONFIG.USE_SOUND = false;
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
        ChatFrame1:AddMessage(theMsg, 1.0, 0.2, 0.2);
    end
end


-----------------------------------------------------------------------------------
--
-- Print a debug report of the current status of the plugin
--
-----------------------------------------------------------------------------------
function ShardTracker_DebugPrintStatus()

    if (SHARDTRACKER_DEBUG) then
    
        -- show the party members' healthstone status
        ShardTrackerDebug("Summary of party member Healthstones:");
        for i = 1, table.getn(ShardTracker_PartyMemberList) do
            ShardTrackerDebug("   Member #"..i.." is "..ShardTracker_PartyMemberList[i].name.." Healthstone = "..tostring(ShardTracker_PartyMemberList[i].hasHealthstone).." Flashing = "..tostring(ShardTracker_PartyMemberList[i].flashing));
        end
    end
end