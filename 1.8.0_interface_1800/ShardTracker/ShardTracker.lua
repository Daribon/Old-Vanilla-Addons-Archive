--[[
ShardTracker - A Warlock AddOn for World of Warcraft
Version 1.33 - 5/14/2005
----------------------------------------------------

REQUIREMENTS
------------
Requires: 
     Nothing
     
Optional:
     Chronos    - A time keeping and scheduling system. 
                    (http://www.curse-gaming.com/mod.php?addid=594)
     Sky        - A network communication library for mods.
                    (http://www.wowwiki.com/Sky)
     Cosmos     - A framework for WoW mods.
                    (http://www.cosmosui.org/cosmos)
     ColorCycle - A UI element color control tool for WoW mods.


DESCRIPTION
-----------
This AddOn helps Warlocks to: 

o Track how many soul shards you have 
o Sort your soul shards into a specified bag 
o Keep track of your healthstone status 
o Create and use healthstones 
o Give healthstones to other players 
o Track your party members' healthstone status 
  and be notified when they need new healthstones 
o Keep track of your soulstone status 
o Create and use soulstones 
o See the cooldown time until you can re-cast soulstone, 
  and be notified when the cooldown time expires 
o Keep track of your spellstone status 
o Create and equip spellstones 
o See the cooldown time until you can use an equipped spellstone 
o Automatically re-equip the item that was in your off hand when you 
  equipped the spellstone 
o Keep track of your firestone status 
o Create and equip firestones 
o Automatically re-equip the item that was in your off hand when you 
  equipped the firestone 
o Nag you about re-casting Soulstone Resurrection
o Nag you about giving Healthstones to party members
o Notify you when Nightfall happens
o Notify you when you successfully gain a Soul Shard

For non-warlocks, this AddOn will display a small button 
near the minimap when the player has a healthstone. Clicking on this 
button will activate the healthstone. 


INSTALLATION 
------------
1. Unzip ShardTracker.zip into your WoW folder. 
2. Answer YES to the prompt about replacing any duplicate files. 
3. You should end up with the following files in the
   "Program Files\World of Warcraft\Interface\AddOns\ShardTracker"
   directory:
   
   Bindings.xml                    -- Keybindings file
   localization.de.lua             -- German translations
   localization.fr.lua             -- French translations
   localization.lua                -- English translations
   ShardTracker.lua                -- Basic structure
   ShardTrackerMain.lua            -- Main code
   ShardTracker.toc                -- Table of Contents file
   ShardTracker.xml                -- XML layout
   ShardTrackerComm.lua            -- Communications code
   ShardTrackerOther.lua           -- Misc code
   ShardTracker_Readme.txt         -- This file
   ShardTrackerSorting.lua         -- Shard sorting code
   ShardTrackerUI.lua              -- User Interface code
   Sounds\                         -- Folder: Sound files
   Images\                         -- Folder: Graphics files


CREDITS
-------
Concept by Kithador 
Originally written by Kithador (ShartCount)
Sorting code originally by Ryu (ShardSort)
Modified, rewritten by Cragganmore 
Translations by Algent, Riswaaq, Sasmira, StarDust


DOWNLOAD LINK 
-------------
http://www.curse-gaming.com/mod.php?addid=324 

]]--

SHARDTRACKER_DEBUG = false;
SHARDTRACKER_TRON  = false;
SHARDTRACKER_VERSION = "1.33";

SHARDTRACKER_FLASH_TIME_ON          = 0.75;     -- number of seconds to flash on
SHARDTRACKER_FLASH_TIME_OFF         = 0.75;     -- number of seconds to flash off
SHARDTRACKER_MIN_ALPHA              = 0.3;      -- minimum transparency to drop to when flashing
SHARDTRACKER_FIRST_TIME = { };                  -- used to track when certain events happen for the first time
SHARDTRACKER_FIRST_TIME.ENABLED         = true;
SHARDTRACKER_FIRST_TIME.SOUND           = true;
SHARDTRACKER_FIRST_TIME.MONITOR         = true;
SHARDTRACKER_FIRST_TIME.SOULPOP         = true;
SHARDTRACKER_FIRST_TIME.SHARDBG         = true;
SHARDTRACKER_FIRST_TIME.LIST_RESTRICT   = true;

-- default locations of the various buttons on the interface
SHARDTRACKER_ORIG_SHARDBUTTONX      = -77;
SHARDTRACKER_ORIG_SHARDBUTTONY      = 25;
SHARDTRACKER_ORIG_HEALTHBUTTONX     = -81;              
SHARDTRACKER_ORIG_HEALTHBUTTONY     = 5;                
SHARDTRACKER_ORIG_SOULBUTTONX       = -80;              
SHARDTRACKER_ORIG_SOULBUTTONY       = -17;              
SHARDTRACKER_ORIG_SPELLBUTTONX      = -74;              
SHARDTRACKER_ORIG_SPELLBUTTONY      = -37;              
SHARDTRACKER_ORIG_FIREBUTTONX       = -62;              
SHARDTRACKER_ORIG_FIREBUTTONY       = -55;              

SHARDTRACKER_CNTR_SHARDBUTTONX      = -495;
SHARDTRACKER_CNTR_SHARDBUTTONY      = -250;
SHARDTRACKER_CNTR_HEALTHBUTTONX     = -438;
SHARDTRACKER_CNTR_HEALTHBUTTONY     = -251;
SHARDTRACKER_CNTR_SOULBUTTONX       = -495;
SHARDTRACKER_CNTR_SOULBUTTONY       = -300;
SHARDTRACKER_CNTR_SPELLBUTTONX      = -438;
SHARDTRACKER_CNTR_SPELLBUTTONY      = -300;
SHARDTRACKER_CNTR_FIREBUTTONX       = -466;
SHARDTRACKER_CNTR_FIREBUTTONY       = -275;

SHARDTRACKER_CONFIG = { };
SHARDTRACKER_CONFIG.ENABLED                     = 1;      -- whether or not the plugin should be active
SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED         = 1;      -- whether or not the shard button should be active
SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED        = 1;      -- whether or not the healthstone button should be active
SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED          = 1;      -- whether or not the soulstone button should be active
SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED         = 1;      -- whether or not the spellstone button should be active
SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED          = 1;      -- whether or not the firestone button should be active
SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE           = 0;      -- whether or not to flash the healthstone button when we don't have a healthstone
SHARDTRACKER_CONFIG.USE_SOUND                   = 1;      -- whether or not to play sounds when soulstone cooldowns expire / players need new healthstones
SHARDTRACKER_CONFIG.THE_SORT_BAG                = 4;      -- the default bag to sort shards into
SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT    = 1;      -- when your total number of shards drops below this number, your shard button will flash
SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES  = 1;      -- whether or not to monitor the status of your party member's healthstones
SHARDTRACKER_CONFIG.BUTTONSCALE                 = SHARDTRACKER_SCALE_1_CMD;
SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP             = 1;
SHARDTRACKER_CONFIG.SHOW_SHARD_BG               = 1;
SHARDTRACKER_CONFIG.LIST_RESTRICT               = true;
SHARDTRACKER_CONFIG.COMM_LIST                   = { };
SHARDTRACKER_CONFIG.HEALTHSOUND                 = "";
SHARDTRACKER_CONFIG.HEALTHSOUNDNAME             = "";
SHARDTRACKER_CONFIG.SOULSOUND                   = "";
SHARDTRACKER_CONFIG.SOULSOUNDNAME               = "";
SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR        = {0.39, 1.0, 0.0};
SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR         = {1.0, 1.0, 1.0};
SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR        = {0.7, 0.95, 0.98};
SHARDTRACKER_CONFIG.FLASHY_GRAPHICS             = true;
SHARDTRACKER_CONFIG.NAGSOUL                     = true;
SHARDTRACKER_CONFIG.NAGHEALTH                   = true;
SHARDTRACKER_CONFIG.NAGCOUNT                    = 5;
SHARDTRACKER_CONFIG.NAGFREQ                     = 15;
SHARDTRACKER_CONFIG.MAXSHARDS                   = 0;
SHARDTRACKER_CONFIG.NIGHTFALLEFFECT             = true;
SHARDTRACKER_CONFIG.SHARDEFFECT                 = true;
SHARDTRACKER_CONFIG.AUTOSORT                    = false;

-- list of default sounds to choose from for use as notifiers (like when soulstone is ready to recast, a player needs a healthstone, etc)
SHARDTRACKER_SOUNDLIST = { "one.mp3", "two.mp3", "three.mp3", "four.mp3", "five.mp3", "six.mp3", 
                           "seven.mp3", "eight.mp3", "nine.mp3", "ten.mp3", "eleven.mp3", "twelve.mp3", 
                           "thirteen.mp3" };

-- locations of the various buttons on the interface
SHARDTRACKER_CONFIG.SHARDBUTTONX                = SHARDTRACKER_ORIG_SHARDBUTTONX;    
SHARDTRACKER_CONFIG.SHARDBUTTONY                = SHARDTRACKER_ORIG_SHARDBUTTONY;
SHARDTRACKER_CONFIG.HEALTHBUTTONX               = SHARDTRACKER_ORIG_HEALTHBUTTONX;
SHARDTRACKER_CONFIG.HEALTHBUTTONY               = SHARDTRACKER_ORIG_HEALTHBUTTONY;
SHARDTRACKER_CONFIG.SOULBUTTONX                 = SHARDTRACKER_ORIG_SOULBUTTONX;
SHARDTRACKER_CONFIG.SOULBUTTONY                 = SHARDTRACKER_ORIG_SOULBUTTONY;
SHARDTRACKER_CONFIG.SPELLBUTTONX                = SHARDTRACKER_ORIG_SPELLBUTTONX;
SHARDTRACKER_CONFIG.SPELLBUTTONY                = SHARDTRACKER_ORIG_SPELLBUTTONY;
SHARDTRACKER_CONFIG.FIREBUTTONX                 = SHARDTRACKER_ORIG_FIREBUTTONX;
SHARDTRACKER_CONFIG.FIREBUTTONY                 = SHARDTRACKER_ORIG_FIREBUTTONY;

-- how often to check our sky mailbox (in seconds)
SKY_MESSAGE_CHECK_FREQ = 0.25;
SHARDTRACKER_NAGFREQUENCY = 30;
SHARDTRACKER_MAXNAGS = 5;

-- chat string constants
SHARDTRACKER_VERSIONPINGSTRING          = "version-ping";
SHARDTRACKER_VERSIONPINGREPLYSTRING     = "version-reply";

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
    ShardTracker_HealthStoneButton = getglobal("ShardTrackerMinimapButtonHealth");
    ShardTracker_SoulStoneButton   = getglobal("ShardTrackerMinimapButtonSoul");
    ShardTracker_SpellStoneButton  = getglobal("ShardTrackerMinimapButtonSpell");
    ShardTracker_FireStoneButton   = getglobal("ShardTrackerMinimapButtonFire");
    ShardTracker_ShardCountLabel   = getglobal("ShardTrackerText");
    ShardTracker_SoulStoneText     = getglobal("ShardTrackerSoulText");
    ShardTracker_SpellStoneText    = getglobal("ShardTrackerSpellText");
    
    ShardTracker_SpellStoneText:SetText("");
    ShardTracker_ShardButton:Hide();
    ShardTracker_HealthStoneButton:Hide();
    ShardTracker_SoulStoneButton:Hide();
    ShardTracker_FireStoneButton:Hide();
    
    getglobal("ShardTrackerSortFrame"):Hide();

    ShardTracker_InUpdateShardTracker = false;
    
    -- setup the data to handle flashing UI elements    
    SHARDTRACKER_FLASHSTATELIST = {"rising", "toppause", "falling", "bottompause"};    
    ShardTracker_FlashController = {
        ["shard"] = {
            time = 0;
            stateIndex = 1;
            minAlpha = 0.3;
            maxAlpha = 1.0;
            defaultAlpha = 1.0;
            state = SHARDTRACKER_FLASHSTATELIST[1];
            totalTime = {
                ["rising"]      = 0.75;
                ["toppause"]    = 1.0;
                ["falling"]     = 0.75;
                ["bottompause"] = 0.0;
            };
            elementList = {"ShardTrackerMinimapButton", "ShardTrackerText"};
        };
        ["healthstone"] = {
            time = 0;
            stateIndex = 1;
            minAlpha = 0.0;
            maxAlpha = 1.0;
            defaultAlpha = 1.0;
            state = SHARDTRACKER_FLASHSTATELIST[1];
            totalTime = {
                ["rising"]      = 0.75;
                ["toppause"]    = 0.75;
                ["falling"]     = 0.75;
                ["bottompause"] = 0.75;
            };
            elementList = {"ShardTrackerMinimapButtonHealth"};
        };
        ["partyhealthstone"] = {
            time = 0;
            stateIndex = 1;
            minAlpha = 0.3;
            maxAlpha = 1.0;
            defaultAlpha = 1.0;
            state = SHARDTRACKER_FLASHSTATELIST[1];
            totalTime = {
                ["rising"]      = 0.5;
                ["toppause"]    = 0.0;
                ["falling"]     = 0.5;
                ["bottompause"] = 0.1;
            };
            elementList = {};
        };
        ["partyhealthstoneglow"] = {
            time = 0;
            stateIndex = 1;
            minAlpha = 0.0;
            maxAlpha = 1.0;
            defaultAlpha = 0.0;
            state = SHARDTRACKER_FLASHSTATELIST[1];
            totalTime = {
                ["rising"]      = 0.5;
                ["toppause"]    = 0.0;
                ["falling"]     = 0.5;
                ["bottompause"] = 3.0;
            };
            elementList = {};
        };
        ["soulstone"] = {
            time = 0;
            stateIndex = 1;
            minAlpha = 0.0;
            maxAlpha = 1.0;
            defaultAlpha = 1.0;
            state = SHARDTRACKER_FLASHSTATELIST[1];
            totalTime = {
                ["rising"]      = 0.5;
                ["toppause"]    = 0.0;
                ["falling"]     = 0.5;
                ["bottompause"] = 0.25;
            };
            elementList = {"ShardTrackerMinimapButtonSoul"};
        };
        ["soulglow"] = {
            time = 0;
            stateIndex = 1;
            minAlpha = 0.0;
            maxAlpha = 1.0;
            defaultAlpha = 0.0;
            state = SHARDTRACKER_FLASHSTATELIST[1];
            totalTime = {
                ["rising"]      = 0.5;      -- 1, 0, 1, 3
                ["toppause"]    = 0.0;
                ["falling"]     = 0.5;
                ["bottompause"] = 1.5;
            };
            elementList = {"ShardTrackerRadarSoulGlowFrame"};          
        };
    };
                        
    ShardTracker_FlashTime = 0;                         -- timer for flashing buttons
    ShardTracker_FlashState = 1;                        -- whether we're flashing on or off
    ShardTracker_SoulStoneExpired = 0;                  -- whether the cooldown on using a soulstone has expired
    ShardTracker_TotalShards = 0;                       -- number of shards in our inventory
    ShardTracker_HaveHealthStone = 0;                   -- if we have a healthstone in our inventory
    ShardTracker_HaveSoulStone = 0;                     -- if we have a soulstone in our inventory
    ShardTracker_SpellStoneInBag = 0;                   -- if we've created a spellstone, but haven't yet equipped it
    ShardTracker_FireStoneInBag = 0;                    -- if we've created a firestone, but haven't yet equipped it
    ShardTracker_HealthStoneLoc = {-1, -1};             -- the bag / slot where our healthstone is
    ShardTracker_SoulstoneLoc = {-1, -1};               -- the bag / slot where our soulstone is
    ShardTracker_SpellStoneLoc = {-1, -1};              -- the bag / slot where our spellstone is
    ShardTracker_SpellStoneReady = 0;                   -- whether a spellstone is ready to be used
    ShardTracker_SpellStoneEquipped = 0;                -- whether a spellstone is equipped
    ShardTracker_SpellStoneIsActive = 0;                -- whether the spellstone was just used to cast its effect on us
    ShardTracker_FireStoneLoc = {-1, -1};               -- the bag / slot where our firestone is
    ShardTracker_FireStoneEquipped = 0;                 -- whether a firestone is equipped
    ShardTracker_Timer = { };                           -- structure to time cooldowns
    ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
    ShardTracker_Timer.SpellstoneTimeSeconds = 0
    ShardTracker_SubVersion = 0;
    ShardTracker_intoSeconds = nil;                     -- whether our soulstone cooldown timer is counting down minutes or seconds
    ShardTracker_UnderTwoMinutes = nil;                 -- whether our soulstone cooldown timer is under two minutes
    ShardTracker_LastMinute = 0;                        -- track the last minute that we checked the soulstone's cooldown
    ShardTracker_SpellTableBuilt = nil;                 -- whether we've built the list of create health/soulstone spells available to us
    ShardTracker_OffHandItem = nil;                     -- the item in our offhand, so we can reequip it once we use up a spellstone
    ShardTracker_HealthstoneFlashing = {0, 0, 0, 0};    -- track the flashing state of party member's healthstone buttons
    ShardTracker_SentHealthstoneNotification = 0;       -- whether we've already notified warlocks in the party that we need a new healthstone
    ShardTracker_CosmosEnabled = false;                 -- whether cosmos is enabled
    ShardTracker_MessageLanguage = "";                  -- the language to send our messages in
    ShardTracker_StopPinging = true;                    -- set when it's safe to stop pinging a party member about his/her healthstone
    ShardTracker_PingCounter = 0;                       -- remember how often we've pinged someone
    ShardTracker_ForceNonCosmosChat = false;            -- used to force chat into noncosmos mode for testing
    ShardTracker_DragLock = true;                       -- when true, we can't drag buttons around the interface
    ShardTracker_BeingDragged = false;                  -- true when we're in the midst of dragging a button
    ShardTracker_DisplayedLoginMessage = false;         -- track whether we've displayed the initial "shard tracker is running" message
    ShardTracker_NagCounter = 0;
    ShardTracker_NightfallAuraActive = false;
    ShardTracker_ShieldStatusBarActive = false;
    ShardTracker_FirstTimeUpdating = true;
    
    ShardTracker_PartyMemberList = { };                 -- this list tracks our party members and various info about them
                                                        -- needed because we get notified of members joining/leaving before GetNumPartyMembers() is
    ShardTracker_CreatePrintCommand();
    
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("BAG_UPDATE");
    this:RegisterEvent("UNIT_NAME_UPDATE");
    this:RegisterEvent("SPELLCAST_START");
    this:RegisterEvent("SPELLS_CHANGED");
    this:RegisterEvent("LEARNED_SPELL_IN_TAB");
    this:RegisterEvent("UNIT_INVENTORY_CHANGED");
    this:RegisterEvent("PARTY_MEMBERS_CHANGED");
    this:RegisterEvent("PLAYER_AURAS_CHANGED");
    
    -- shard sorting variables, some from ryu's ShardSort code
    ShardTracker_ShardSortFrameCounter = 0;
    ShardTracker_ShardMoverIndex = 0;
    ShardTracker_TotalShardsToMove = 5;
    ShardTracker_ShardMoverRunning = nil;
    ShardTracker_ShardMoverDone = false;
    ShardTracker_ShardMoverArray = { };
    ShardTracker_ShardMoverFilled = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil};

end



---------------------------------------------------------------------------------
--
-- Make sure we have the Print() function
-- 
---------------------------------------------------------------------------------
function ShardTracker_CreatePrintCommand()
    if (not Print) then
        function Print(msg, r, g, b, frame) 
            if (not r) then r = 1.0; end
            if (not g) then g = 1.0; end
            if (not b) then b = 0.5; end
            if ( frame ) then 
                frame:AddMessage(msg,r,g,b);
            else
                if (DEFAULT_CHAT_FRAME) then 
                    DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
                end
            end
        end
    end
end


---------------------------------------------------------------------------------
--
-- Hook the chat onEvent handler to intercept incoming chat messages
-- 
---------------------------------------------------------------------------------
function ShardTracker_SetupChatWatcher()
       ShardTracker_Orig_ChatFrame_OnEvent = ChatFrame_OnEvent;
       ChatFrame_OnEvent = ShardTracker_ChatFrame_OnEvent;
end



---------------------------------------------------------------------------------
--
-- Register with Cosmos UI
-- 
---------------------------------------------------------------------------------
function ShardTracker_RegisterCosmosAndSky()

    --
    -- Add an entry to the Cosmos configuration menu
    --
    if (Cosmos_RegisterConfiguration) then
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER",
            "SECTION",
            SHARDTRACKER_CONFIG_HEADER,
            SHARDTRACKER_CONFIG_HEADER_INFO
        );
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_HEADER",
            "SEPARATOR",
            SHARDTRACKER_CONFIG_HEADER,
            SHARDTRACKER_CONFIG_HEADER_INFO
        );
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_ENABLED",
            "CHECKBOX",
            SHARDTRACKER_CONFIG_ENABLED,
            SHARDTRACKER_CONFIG_ENABLED_INFO,
            ShardTracker_Toggle,
            SHARDTRACKER_CONFIG.ENABLED
        );
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_FLASH_HEALTH",
            "CHECKBOX",
            SHARDTRACKER_CONFIG_FLASH_HEALTH,
            SHARDTRACKER_CONFIG_FLASH_HEALTH_INFO,
            ShardTracker_Toggle_Flash_Health,
            SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE
        );
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_SOUND",
            "CHECKBOX",
            SHARDTRACKER_CONFIG_SOUND,
            SHARDTRACKER_CONFIG_SOUND_INFO,
            ShardTracker_Toggle_Sound,
            SHARDTRACKER_CONFIG.USE_SOUND
        );
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_SOULPOP",
            "CHECKBOX",
            SHARDTRACKER_CONFIG_SOULPOP,
            SHARDTRACKER_CONFIG_SOULPOP_INFO,
            ShardTracker_Toggle_SoulPop,
            SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP
        );        
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_RESTRICT",
            "CHECKBOX",
            SHARDTRACKER_CONFIG_RESTRICT,
            SHARDTRACKER_CONFIG_RESTRICT_INFO,
            ShardTracker_Toggle_RestrictedChat,
            SHARDTRACKER_CONFIG.LIST_RESTRICT
        );        
                
        Cosmos_RegisterConfiguration(
            "COS_SHARDTRACKER_RESET",
            "BUTTON",
            SHARDTRACKER_RESET,
            SHARDTRACKER_RESET_INFO,
            ShardTracker_ResetButtonLocations,
            0,
            0,
            0,
            0,
            SHARDTRACKER_RESET_NAME
        );
        ShardTracker_CosmosEnabled = true;
    end;

    -- register the slash commands    
    local ShardtrackerSlashCommands = {"/shardtracker","/st"};
    if (Sky) then
        Sky.registerSlashCommand(
            {
                id = "SHARDTRACKER";
                commands = ShardtrackerSlashCommands;
                onExecute = Shardtracker_ChatCommandHandler;
            }
        );
    elseif (Cosmos_RegisterChatCommand) then
        -- register our chat commands
        Cosmos_RegisterChatCommand (
            "SHARDTRACKER_COMMANDS", -- Some Unique Group ID
            ShardtrackerSlashCommands, -- The Commands
            Shardtracker_ChatCommandHandler,
            "" -- Description String
        );

    -- else enable the slash commands for non-cosmos and non-sky users
    else
        SlashCmdList["SHARDTRACKER_SLASHENABLE"] = Shardtracker_ChatCommandHandler;
        SLASH_SHARDTRACKER_SLASHENABLE1 = ShardtrackerSlashCommands[1];
        SLASH_SHARDTRACKER_SLASHENABLE2 = ShardtrackerSlashCommands[2];
    end
    
end


-----------------------------------------------------------------------------------
--
-- Run initialization stuff that needs to be done after we've loaded all the game variables
--
-----------------------------------------------------------------------------------
function ShardTracker_InitAfterVariablesLoaded()

    PartyMemberFrame1ShardTrackerGlowFrame:Hide();
    PartyMemberFrame2ShardTrackerGlowFrame:Hide();
    PartyMemberFrame3ShardTrackerGlowFrame:Hide();
    PartyMemberFrame4ShardTrackerGlowFrame:Hide();    
    ShardTrackerRadarSoulGlowFrame:Hide();
    
    -- register with Cosmos
    ShardTracker_RegisterCosmosAndSky();
    
    -- register with SKY
    ShardTracker_RegisterSky();
    
    -- setup chat watcher
    ShardTracker_SetupChatWatcher();
    
    -- make sure older versions have their SavedVariables.lua updated to reflect any new data structures
    ShardTracker_UpdateOldConfigVersions();
    
    ShardTrackerDebug("Init after var loaded setting monitor healthstones");
    ShardTrackerDebug("Config info loaded: "..asText(SHARDTRACKER_CONFIG));
        
    -- position the buttons in the correct locations
    ShardTracker_ButtonSetLocation();

    -- query the healthstone status of any party members
    ShardTracker_InitializePartyHealthstoneIcons();
    
    -- if using chronos, schedule sending out a message to the party asking about their healthstones
    if (Chronos) then
        Chronos.schedule(5,ShardTracker_SendHealthStoneQuery,"PARTY");
        for i = 1, GetNumPartyMembers() do

            -- if we both have sky, schedule the query
            memberName = tostring(UnitName("party"..i));
            if (Sky) then
                if (Sky.isSkyUser(memberName)) then
                    ShardTrackerDebug("Both "..tostring(UnitName("party"..i)).." and we have sky, so start pinging membername = "..tostring(UnitName("party"..i)));
                    ShardTracker_StartPingQuery(5, UnitName("party"..i), "WHISPER");

                -- if the party member doesn't have sky, send as normal msg
                else
                    ShardTracker_SendHealthStoneQuery("WHISPER", UnitName("party"..i));
                end     
            else
                ShardTracker_SendHealthStoneQuery("WHISPER", UnitName("party"..i));
            end
        end

    -- otherwise we just send it right out
    else
        ShardTracker_SendHealthStoneQuery("PARTY");
    end
    
    ShardTracker_ShardButton:SetFrameLevel(16);
    ShardTracker_HealthStoneButton:SetFrameLevel(16);
    ShardTracker_SoulStoneButton:SetFrameLevel(16);
    ShardTracker_SpellStoneButton:SetFrameLevel(16);
    ShardTracker_FireStoneButton:SetFrameLevel(16);
    
end


-----------------------------------------------------------------------------------
--
-- Update any outdated config files
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdateOldConfigVersions()
    
    if (SHARDTRACKER_CONFIG.ENABLED == nil) then
        SHARDTRACKER_CONFIG.ENABLED = 1;
        SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED = 1;
        SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED = 1;      
        SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED = 1;      
        SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED = 1;      
        SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED = 1;
        SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 0;
        SHARDTRACKER_CONFIG.USE_SOUND = 1;
        SHARDTRACKER_CONFIG.THE_SORT_BAG = 4;
    end
    if (SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT == nil) then
        SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT = 1;
    end
    if (SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES == nil) then
        ShardTrackerDebug("Didn't find MONITOR_PARTY_HEALTHSTONES in config - added.");
        SHARDTRACKER_CONFIG.MONITOR_PARTY_HEALTHSTONES = 1;
    end
    if (SHARDTRACKER_CONFIG.SHARDBUTTONX == nil) then
        ShardTrackerDebug("Didn't find button loc info in config - added.");
        SHARDTRACKER_CONFIG.SHARDBUTTONX                = SHARDTRACKER_ORIG_SHARDBUTTONX;
        SHARDTRACKER_CONFIG.SHARDBUTTONY                = SHARDTRACKER_ORIG_SHARDBUTTONY;
        SHARDTRACKER_CONFIG.HEALTHBUTTONX               = SHARDTRACKER_ORIG_HEALTHBUTTONX;
        SHARDTRACKER_CONFIG.HEALTHBUTTONY               = SHARDTRACKER_ORIG_HEALTHBUTTONY;
        SHARDTRACKER_CONFIG.SOULBUTTONX                 = SHARDTRACKER_ORIG_SOULBUTTONX;
        SHARDTRACKER_CONFIG.SOULBUTTONY                 = SHARDTRACKER_ORIG_SOULBUTTONY;
        SHARDTRACKER_CONFIG.SPELLBUTTONX                = SHARDTRACKER_ORIG_SPELLBUTTONX;
        SHARDTRACKER_CONFIG.SPELLBUTTONY                = SHARDTRACKER_ORIG_SPELLBUTTONY;
        SHARDTRACKER_CONFIG.FIREBUTTONX                 = SHARDTRACKER_ORIG_FIREBUTTONX;
        SHARDTRACKER_CONFIG.FIREBUTTONY                 = SHARDTRACKER_ORIG_FIREBUTTONY;
    end
    if (SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED == nil) then
        SHARDTRACKER_CONFIG.SHARDBUTTON_ENABLED         = 1;
        SHARDTRACKER_CONFIG.HEALTHBUTTON_ENABLED        = 1;
        SHARDTRACKER_CONFIG.SOULBUTTON_ENABLED          = 1;
        SHARDTRACKER_CONFIG.SPELLBUTTON_ENABLED         = 1;
    end
    if (SHARDTRACKER_CONFIG.BUTTONSCALE == nil) then
        SHARDTRACKER_CONFIG.BUTTONSCALE                 = SHARDTRACKER_SCALE_1_CMD;
    end
    if (SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP == nil) then
        SHARDTRACKER_CONFIG.SHOW_SOUL_POPUP             = 1;
    end
    if (SHARDTRACKER_CONFIG.SHOW_SHARD_BG == nil) then
        SHARDTRACKER_CONFIG.SHOW_SHARD_BG               = 1;
    end
    if (SHARDTRACKER_CONFIG.COMM_LIST == nil) then
        SHARDTRACKER_CONFIG.COMM_LIST                   = { };
    end    
    if (SHARDTRACKER_CONFIG.LIST_RESTRICT == nil) then
        SHARDTRACKER_CONFIG.LIST_RESTRICT               = true;
    end
    if (SHARDTRACKER_CONFIG.HEALTHSOUND == nil or SHARDTRACKER_CONFIG.SOULSOUND == nil) then
        SHARDTRACKER_CONFIG.HEALTHSOUND     = "";
        SHARDTRACKER_CONFIG.HEALTHSOUNDNAME = "";
        SHARDTRACKER_CONFIG.SOULSOUND       = "";
        SHARDTRACKER_CONFIG.SOULSOUNDNAME   = "";
    end
    if (SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED == nil) then
        SHARDTRACKER_CONFIG.FIREBUTTON_ENABLED = 1;
    end
    if (SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR == nil) then
        SHARDTRACKER_CONFIG.SHARDBUTTONTEXTCOLOR        = {0.39, 1.0, 0.0};
        SHARDTRACKER_CONFIG.SOULBUTTONTEXTCOLOR         = {1.0, 1.0, 1.0};
        SHARDTRACKER_CONFIG.SPELLBUTTONTEXTCOLOR        = {0.7, 0.95, 0.98};
    end    
    if (SHARDTRACKER_CONFIG.FLASHY_GRAPHICS == nil) then
        SHARDTRACKER_CONFIG.FLASHY_GRAPHICS = true;
    end
    if (SHARDTRACKER_CONFIG.NAGSOUL == nil) then
        SHARDTRACKER_CONFIG.NAGSOUL = true;
        SHARDTRACKER_CONFIG.NAGHEALTH = true;
    end
    if (SHARDTRACKER_CONFIG.NAGCOUNT == nil) then
        SHARDTRACKER_CONFIG.NAGCOUNT = 5;
        SHARDTRACKER_CONFIG.NAGFREQ = 15;
    end
    if (SHARDTRACKER_CONFIG.MAXSHARDS == nil) then
        SHARDTRACKER_CONFIG.MAXSHARDS = 0;
    end
    if (SHARDTRACKER_CONFIG.NIGHTFALLEFFECT == nil) then
        SHARDTRACKER_CONFIG.NIGHTFALLEFFECT = true;
    end
    if (SHARDTRACKER_CONFIG.SHARDEFFECT == nil) then
        SHARDTRACKER_CONFIG.SHARDEFFECT = true;
    end
    if (SHARDTRACKER_CONFIG.AUTOSORT == nil) then
        SHARDTRACKER_CONFIG.AUTOSORT = false;
    end
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

    -- once we've loaded into the game
    if (event == "VARIABLES_LOADED") then
        ShardTracker_InitAfterVariablesLoaded();
    
    -- if an event occurs that would affect the number of shards, soulstone, healthstone, or spellstone, update us
    elseif (UnitName("player") ~= "Unknown Being" and UnitName("player") ~= "Unknown Entity" and (event == "BAG_UPDATE" or event == "UNIT_NAME_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "UNIT_INVENTORY_CHANGED") ) then
        if (not ShardTracker_InUpdateShardTracker) then
            if (Chronos) then
                Chronos.scheduleByName("ShardTracker_UpdateShardTracker", 0.5, ShardTracker_UpdateShardTracker);
            else
                ShardTracker_UpdateShardTracker();
            end    
        end    
        
    -- if we're using a soulstone on someone (casting Soulstone Resurrection), reset the soulstone timer
    elseif (event == "SPELLCAST_START") then
        if (arg1 == SHARDTRACKER_SOULSTONERES) then
            ShardTracker_StartSoulstoneTimer();
        end
        
    elseif (event == "PLAYER_AURAS_CHANGED") then
        ShardTracker_CheckAuraChange();
        
    -- if we learned new spells, update the list of spells we can cast
    -- since now we might be able to create a better healthstone or soulstone
    elseif (event == "LEARNED_SPELL_IN_TAB" or event == "SPELLS_CHANGED") then
        ShardTracker_BuildSpellTable();       
    end
end


---------------------------------------------------------------------------------
--
-- Break a slash command into its command and variable parts (i.e. "debug on"
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
-- A simple slash command handler that can take commands in the form: "/slashCommand command var"
-- 
---------------------------------------------------------------------------------
function Shardtracker_ChatCommandHandler(msg)
    local command, var = ShardTracker_ParseCommand(msg);
    if ((not command) and msg) then
        command = msg;
    end
    if (command) then
        command = string.lower(command);
        if (command == SHARDTRACKER_DEBUG_CMD) then
            ShardTracker_ToggleDebug();
        elseif (command == SHARDTRACKER_ON_CMD) then
            ShardTracker_Toggle(1);
        elseif (command == SHARDTRACKER_OFF_CMD) then
            ShardTracker_Toggle(0);
        elseif (command == SHARDTRACKER_BAG_CMD) then
            ShardTracker_SetShardBag(var);
        elseif (command == SHARDTRACKER_SORT_CMD) then
            ShardTracker_SortShards();
        elseif (command == SHARDTRACKER_LIMIT_CMD) then
            ShardTracker_SetShardFlashLimit(var);
        elseif (command == SHARDTRACKER_MONITOR_CMD) then
            if (var) then
                if (var == "on") then
                    ShardTracker_Toggle_Monitor_Party_Healthstones(1, true);
                else
                    ShardTracker_Toggle_Monitor_Party_Healthstones(0, true);
                end
            else
                ShardTracker_Toggle_Monitor_Party_Healthstones(nil, true);
            end
        elseif (command == SHARDTRACKER_SOUND_CMD) then
            if (var == "on") then
                ShardTracker_Toggle_Sound(1);
            elseif (var == "off") then
                ShardTracker_Toggle_Sound(0);
            else
                ShardTracker_Toggle_Sound();
            end
        elseif (command == SHARDTRACKER_SHARDBG_CMD) then
            if (var == "on") then
                ShardTracker_Toggle_ShardBG(1);
            elseif (var == "off") then
                ShardTracker_Toggle_ShardBG(0);
            else
                ShardTracker_Toggle_ShardBG();
            end
        elseif (command == SHARDTRACKER_SOUL_POPUP_CMD) then
            if (var == "on") then
                ShardTracker_Toggle_SoulPop(1);
            elseif (var == "off") then
                ShardTracker_Toggle_SoulPop(0);
            else
                ShardTracker_Toggle_SoulPop();
            end
        elseif (command == SHARDTRACKER_RESTRICT_CMD) then
            if (var == "on") then
                ShardTracker_Toggle_RestrictedChat(1, true);
            elseif (var == "off") then
                ShardTracker_Toggle_RestrictedChat(0, true);
            else
                ShardTracker_Toggle_RestrictedChat(nil, true);
            end
        elseif (command == SHARDTRACKER_FLASHY_CMD) then
            if (var == "on") then
                ShardTracker_ToggleFlashyGraphics(1, true);
            elseif (var == "off") then
                ShardTracker_ToggleFlashyGraphics(0, true);
            else
                ShardTracker_ToggleFlashyGraphics(nil, true);
            end
        elseif (command == SHARDTRACKER_ADD_CMD) then
            ShardTracker_AddToCommList(var);
        elseif (command == SHARDTRACKER_REMOVE_CMD) then
            ShardTracker_RemoveFromCommList(var);
        elseif (command == SHARDTRACKER_LIST_CMD) then
            ShardTracker_ListCommList(var);
        elseif (command == SHARDTRACKER_FLASH_CMD) then
            if (var) then
                if (var == "on") then
                    ShardTracker_Toggle_Flash_Health(1, true);
                else
                    ShardTracker_Toggle_Flash_Health(0, true);
                end
            else
                ShardTracker_Toggle_Flash_Health(nil, true);
            end    
        elseif (command == SHARDTRACKER_LOCK_CMD or command == SHARDTRACKER_UNLOCK_CMD) then
            ShardTracker_ToggleLockedForDragging(command);
        elseif (command == "" or command == SHARDTRACKER_HELP_CMD or command == "?") then
            if (ChatFrame1) then ShardTracker_ShowHelp(); end
        elseif (command == SHARDTRACKER_INFO_CMD) then
            if (ChatFrame1) then ShardTracker_ShowInfoMessage(); end
        elseif (command == SHARDTRACKER_RESET_CMD) then
            ShardTracker_ResetButtonLocations();    
        elseif (command == SHARDTRACKER_CENTER_CMD) then
            ShardTracker_CenterButtonLocations();    
        elseif (command == SHARDTRACKER_TOGGLE_CMD) then        
            ShardTracker_ToggleSlashCommand(var);
        elseif (command == SHARDTRACKER_NAGSOUL_CMD or command == SHARDTRACKER_NAGHEALTH_CMD) then        
            ShardTracker_ToggleNagging(command, var, true);
        elseif (command == SHARDTRACKER_NAGCOUNT_CMD) then        
            ShardTracker_SetNagCount(var);
        elseif (command == SHARDTRACKER_NAGFREQ_CMD) then        
            ShardTracker_SetNagFreq(var);
        elseif (command == SHARDTRACKER_MAXSHARDS_CMD) then
            ShardTracker_SetMaxShards(var);
        elseif (command == SHARDTRACKER_NIGHTFALL_CMD) then
            ShardTracker_ToggleNighfallEffect(var, true);
        elseif (command == SHARDTRACKER_SHARDEFFECT_CMD) then
            ShardTracker_ToggleShardCreationVisual(var, true);
        elseif (command == SHARDTRACKER_AUTOSORT_CMD) then
            ShardTracker_ToggleAutoSorting(var, true);
        elseif (command == "testfallon") then
            ShardTracker_ToggleNightfallVisuals(true);
        elseif (command == "testfalloff") then
            ShardTracker_ToggleNightfallVisuals(false);
        elseif (command == "testshard") then
            ShardTracker_TriggerCreatedSoulShardVisual();
        elseif (command == "buttons") then
            ShardTracker_PrintButtonLocs();
        elseif (command == "version") then
            ShardTrackerPrint("ShardTracker Version "..SHARDTRACKER_VERSION);
        elseif (command == "report") then
            ShardTracker_DebugPrintStatus();
        elseif (command == "dump") then
            ShardTracker_DebugDumpPartyList();
        elseif (command == "ping") then
            ShardTracker_SendVersionPing(var);
        elseif (command == "testyes" or command == "testno") then
            ShardTracker_DebugHealthstonePartyCode(command, var);
        elseif (command == "tron") then
            SHARDTRACKER_TRON = true;
            ShardTrackerPrint("ShardTracker TRON ON");
        elseif (command == "troff") then
            SHARDTRACKER_TRON = false;
            ShardTrackerPrint("ShardTracker TRON OFF");
        elseif (command == "notify" and var == "yes") then
            ShardTracker_SentHealthstoneNotification = 0;
            ShardTracker_NotifyHealthstoneStatus(SHARDTRACKER_GOT_HEALTHSTONE_MSG);
        elseif (command == "scale") then
            ShardTracker_SetButtonScale(var, true);
        elseif (command == SHARDTRACKER_SOULSOUND_CMD or command == SHARDTRACKER_HEALTHSOUND_CMD) then
            ShardTracker_SetSound(command, var);
        elseif (command == "pop") then
            ShardTracker_NotifySoulstoneReady();
        elseif (command == "notify" and var == "no") then
            ShardTracker_SentHealthstoneNotification = 0;
            ShardTracker_NotifyHealthstoneStatus(SHARDTRACKER_NEED_HEALTHSTONE_MSG);
        elseif (command == "togglecosmos") then
            ShardTracker_ForceNonCosmosChat = not ShardTracker_ForceNonCosmosChat;
            ShardTrackerPrint("ShardTracker_ForceNonCosmosChat set to "..tostring(ShardTracker_ForceNonCosmosChat));
        elseif (command == "stonestatus") then
            ShardTracker_DebugSpellFireStoneStatus();
        elseif (command == "superhelp") then
            ShardTrackerPrint("report (print db report), tron/troff, testyes|testno <player> (set that player to having a HS), notify yes/no (notify warlocks that we need/have HS), togglecosmos (toggle cosmos msg sending)");
        elseif (command == "buttonloc") then
            ShardTracker_TestSetButtonLoc(var);
        elseif (command == "buttonrefresh") then
            ShardTracker_ButtonSetLocation();
        elseif (command == "hello" and var == "sailor") then
            ShardTrackerPrint("Cretin!");
        elseif (command == "let's" and var == "fighting love") then
            ShardTrackerPrint("Subarashii chinchin mono\nKintama no kami aru\nSore no oto ha sarubobo\nIie! Ninja ga imasu\nHey hey let's go kenka suru\nTaisetsu no mono protect my balls!\nBoku ga warui so let's fighting...\nLet's fighting love!");
        elseif (command == "xyzzy" or command == "plugh") then
            ShardTrackerPrint("A hollow voice says 'Fool.'");
        elseif (command == "count" and var == "leaves") then
            ShardTrackerPrint("There are 69,105 leaves here.");
        end
    end
end


-----------------------------------------------------------------------------------
--
-- Set the number that, when your total shards drops below it, your shard button will flash
--
-----------------------------------------------------------------------------------
function ShardTracker_SetShardFlashLimit(var)

    if (UnitClass("player") == SHARDTRACKER_WARLOCK) then    
        local badVar = false;
        if (not var) then
            badVar = true;
        else
            var = tonumber(var);
            if (not var) then
                badVar = true;
            elseif (var < 0 or var > 20) then
                badVar = true;
            end
        end

        if (not badVar) then
            SHARDTRACKER_CONFIG.MIN_FLASHING_SHARD_LIMIT = var;
            ShardTrackerPrint(ST_LIMITANSWER..var..".");
            if (ShardTracker_TotalShards == nil) then ShardTracker_TotalShards = 0; end
            ShardTracker_UpdateShardButton(ShardTracker_TotalShards);
        else
            ShardTrackerPrint(ST_LIMITUSAGE);
        end
    else
        ShardTrackerPrint(ST_ONLYFORWARLOCKS);
    end
end

