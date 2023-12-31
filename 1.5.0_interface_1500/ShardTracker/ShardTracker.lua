--[[
    ShardTracker - Credits to: Kithador, Ryu, Cragganmore, GragUK
    XML Summoner Code rejigged from: www.shadydesign.com
    NCS Version by Gottac : wright_dj@hotmail.com

    TO DO:
      Allow a choice of font sizes for the countdowns in the timer buttons
      Seduce and Soul-link added to the timer list
      Check soul shard used when Ritual of Summoning ic cast
      Stop Buttons moving when alt-tabing between resolutions - TESTING DONE, need to fiddle with XML

	2.34 - NCS
	o nil error at line 987 fixed (thanks to Krinkle and others)
	o Vendor lag issue improved
	o Healthstone status in small groups perform correctly now when a healthstone is used
	o Added Siphon Life to timer list
	o Minigroup and Perl_Group support added
	o Added check for DE client on timer countdown
	o Added /st timertargetonly on|off. to turn on and off the timer only showing spells on current target
	o Added soulstone text and /st soul to target the last person you soulstoned
      
    2.33 - NCS
	o Low health warning fixed to not show the text when you do not have a healthstone
	o Soulstone check for stone being used now waits 3 seconds rather than 1 to better cope with lag
	o Added option to turn on and off the shadow trance warning
	  /st trancewarning on|off
	o Curses now replace other curses on the timer *if* the target has not changed
	o Icons no longer flash, when unavailble a no entry sign will show over the icon and the timer
	  on the icons shows how long until the button is available.
	o Added Healtstone timer and no entry sign, icon will not grow if unavailable
            
    2.32 - NCS
	o Sound warning when on low health and you have a healthstone (From Monty Pyton film
	  Holy Grail, quote says: "Just a flesh wound")
	  Is not triggered by Hunters Feign Death
	  /st healthwarning on|off (on by default)
	o Converted all sounds to mp3 to save on space
	o Thanks to Graguk, gave me the macro to help track down the correct image for Fel Domination
	o Added sound and text warning when you are affected by the Shadow Trance buff, no button for 
	  shadow bolt, this will be added into the context sensitive toolbar which is in development
        
    2.31 - NCS
	o German translation, with thanks to Phiolin. French Translation completed, thans to Tinou.
    o Healtstone status now ignores anything in the ST chsnnel whish is not expected.
    o Scale Timer text and icon to UI scale setting of ShardTracker, Icon now only displays
      when icons are unlocked, once in position and locked again icon disappears, text displays
      where the example text is shown.
    o Abbreviated timer text now available with (Not availble in french and german translations yet:
      /st shorttimertext on|off
    o Reordered Shardtracker icons, default is now Shards, Soulstone, Firestone, Healthstone to
      avoid healstone overlapping buttons you might need in a hard situation
    o Delayed soulstone check on soulstone being used from inventory
    o All Button flashing slowed down to help with trades and lag issues
        
    2.30 - NCS
	o Fixed soulstone message not showing target name

    2.29 - NCS
	o Fixed bug at line 2917 (typo)
    
    2.28 - NCS
    o Spell timers added. Currently including (Fear,Howl of Terror,Corruption, Immolate, 
      Curse of Exhaustion/Agony/Elements/Recklessness/Shadow/Tongues/Weakness/Doom, 
      Banish,Enslave Demon,Inferno,Sacrificial Shield)
      /st timer on|off to turn on or off the timer, the timer details displays to the right 
                       of the timer icon in Time - Spell Name -> Target
	  /st timersize small|normal|large to set the font size of the timer text
	o Resolved FrameXML errors in keybindings.XML, thanks to Unique
	o Added checks on all sounds to check the sound toggle in the config, so if sounds
	  are off no sounds will play.
	o When trading a healthstone accept is now automatically clicked (Thanks to 
	  Craggmore, great idea)
	o Tweaked healthstone code to work better with the original ST and hopefully stay in
	  sync during raids and frequent group changes.
	o Healthstone sizing now on by default (requested by people)
	o Soulstone sound when no soulstone in bag now has a second check and *should* always
	  play barring in game sound overriding the sound
	o when dead healtstone sizing is disables and reset to default size
	o Fixed a spelling error in /st update which caused it to not update
	o Added additional messages for healtstone and soulstone status to make them more visible
        
    2.27 - NCS
    o Improved the sort logic to be much more efficient, and as a side effect less noisy
    
    2.25 - NCS
    o Added in custom message to soulstone and summoning
      /st customsummon <message> = Sets the custom summon message
      /st customsoul <message>   - Character name is ALWAYS added to the start of this
                                   message due to the check to ensure the spell was cast.
      Leave these blank to reset to use the default messages
    o Soulstone sound should only play once when timer is up
    o Fixed the sound problem when enslave broke (thanks to devla)
    o Keybinding for summoner menu added
                                       
    2.24 - NCS
    o Fixed elapsed (nil) bug
    o Changed Fel Domination icon to closer match on the summoner menu
    o Soulstone message occurs when no soulstone is summoned and the last soulstone
      buff wears off, sound should also play only if the sound is enabled
    o Updated the ingame help available from /st ? to show all the new options and a
      brief explanation of them
    o Party/Raid messages for soulstones and summons can be turned on and off with
      /st summonmessage on|off
      /st soulmessage on|off
    o Healthstone icon can be configure to grow in size as your health goes down.
      /st healthsizing on|off (off by default)
    
	2.23 - NCS
	o Fixed Scale loeading problem for the first use
    
    2.22 - NCS
	o Added scaling option /st scale (percent)
	o Soulstone sound should now play when soulstone buff expires and you don not already
	  have another soulstone summoned

	2.21 - NCS
	o Soulstone flashes as it should do again
	o Integrated CountDoom into ShardTracker
	o Found the correct Ritual of Summoning icon on Summoner menu
	o Changed tooltip color
	o Summoner menu size reduced slightly
	o Added another check on soulstone being cast
    
    2.20 - NCS
    o Added Eye of Kilrogg and Ritual of Summoning to second line of Summoner menu
    o Healhstone tooltip hide when summoner menu shows for clearer display
    o Added /st update to query ST users in the group and refresh there healtstone status
    o Healthstone status slightly less obtrusive. Sound will only play once when healthstone
      first used, message will be repeated though
    o Fixed spelling error in demon buff message
    o Reworked Soulstone message code to check correctly
    o Reworked healthstone code to be more efficent
    o Altered Sorting code to now sort only shards into the bag, not healthstones and soulstones
    o Sorting should now work for French translation, spell table still needs converting
    
	2.15 - NCS
	o Fixed Button loading error if no positions have already been set
    
    2.14 - NCS
    o Added Summoner option from healthstone right click (I liked that idea in necrosis,
      but now only a summon icon shows if you know that summon)
    o Buttons are now moveable, /st lock|unlock and /st reset to reset positions
    o Added keybind for warlock self buff
    o Healtstone status should now work in raids
	o Minor reorganisation of code
	o Start of conversion for French translation, some spell names missing
	o Party or Raid are informed when you soulstone on someone, if the soulstone 
	  is NOT used for any reason no message is sent
	o Party or Raid are informed when you attempt to summon someone
	o Added /st channel on|off to enable/disable joining the Group Healtstone tracking
	  channel, it is on by default.
	o Autosort, enabled and disabled by right clicking on the shard count, disabled by default
    
    2.12 - NCS
    o Trying to keep ST Joining high channel numbers and not overwriting default ones
    o Reduced amount of updates when nothing in the inventory has changed
    
    2.11 - NCS
    o Tweak Channel leaving/joining to make it stop leaving all channels

    2.10 - NCS
    o Tracked down final few qwirks with healthstones and resolved them.
    o Dreadsteed should work if you have the spell
    o Sounds working again (the wav file had deleted itself somehow and I'd not noticed)

    2.06 - NCS
    o Fixed GTimer code

    2.05 - NCS
	o Move of the zone/continent issues tracked down and resolved, no more
	  errors should occur for the user. Outstanding issues where healtstone status
	  stops working in raids to be fixed on Tuesday
	
	2.04 - NCS
    o Hopefully fixed all the zone/continent issues with healtstones
    
    2.01 - NCS
    o Minor tweaks after more testing healthstones.
    
    2.00 and below- NCS
    o Healthstone showing on party members now works
	o Minor color tweaks
	o Changed sound on Soulstone ready (made very quickly by me, someone
	  please supply something better)
    o Added Keybindings for Health,Soul,Spell stones
    o Fixed broken keybinding for Sort
    o Added /st flash x to allow users to define when to start flashing

    This mod helps Warlocks to:
    o track how many soul shards you have
    o sort your soul shards into a specified bag
    o keep track of your healthstone status
    o create and use healthstones
    o give healthstones to other players
    o track your party members' healthstone status 
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
        
]]--

SHARDTRACKER_DEBUG = false;
SHARDTRACKER_VERSION = "2.34beta";
SHARDTRACKER_LOADED = false;

SHARDTRACKER_FLASH_TIME_ON          = 10.00;     -- number of seconds to flash on
SHARDTRACKER_FLASH_TIME_OFF         = 10.00;     -- number of seconds to flash off
SHARDTRACKER_MIN_ALPHA              = 0.3;      -- minimum transparency to drop to when flashing
SHARDTRACKER_SHARD_ENABLED          = 1;        -- whether or not to show the number of shards button
SHARDTRACKER_HEALTHSTONE_ENABLED    = 1;        -- whether or not to show the healthstone button
SHARDTRACKER_SOULSTONE_ENABLED      = 1;        -- whether or not to show the soulstone button
SHARDTRACKER_SPELLSTONE_ENABLED     = 1;        -- whether or not to show the spellstone button
SHARDTRACKER_DUEL_IN_PROGRESS 		= 0;		-- Is a duel in progreess ?
SHARDTRACKER_FIRST_TIME = { };
SHARDTRACKER_FIRST_TIME.ENABLED = true;
SHARDTRACKER_FIRST_TIME.SOUND = true;

SHARDTRACKER_CONFIG = { };
SHARDTRACKER_CONFIG.ENABLED           	= 1;      	-- whether or not the plugin should be active
SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE 	= 0;      	-- whether or not to flash the healthstone button when we don't have a healthstone
SHARDTRACKER_CONFIG.USE_SOUND         	= 1;      	-- whether or not to play sounds when soulstone cooldowns expire / players need new healthstones
SHARDTRACKER_CONFIG.THE_SORT_BAG      	= 4;      	-- the default bag to sort shards into
SHARDTRACKER_CONFIG.SHARD_FLASH_NUM   	= 2;      	-- Flash on 'X' or less than number of shards
SHARDTRACKER_CONFIG.CHANNEL_JOIN      	= true;	  	-- Join the ST Channel or not ?
SHARDTRACKER_CONFIG.AUTO_SORT			= false;    -- Autosorting
SHARDTRACKER_CONFIG.UI_SCALE			= 1;        -- UI Scaling
SHARDTRACKER_CONFIG.SHOW_SUMMON			= true;		-- Display the Summoning message ?
SHARDTRACKER_CONFIG.SHOW_SOUL			= true;		-- Display the soulstone message ?
SHARDTRACKER_CONFIG.SIZE_HEALTH			= true;		-- Auto size the healthstone icon accoreding to health
SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE	= "";		-- Custom soulstone message
SHARDTRACKER_CONFIG.USE_SOULMESSAGE		= false;	-- Use the custom message ?
SHARDTRACKER_CONFIG.CUSTOM_SUMMONMESSAGE= "";		-- Customer Summoning message
SHARDTRACKER_CONFIG.USE_SUMMONMESSAGE	= false;	-- Use the custom message ?
SHARDTRACKER_CONFIG.SHOW_TIMER			= false;	-- Display the timer ?
SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE		= "Normal"	-- Timer font size
SHARDTRACKER_CONFIG.SHORT_TIMER_TEXT	= false;	-- Abbreviate the timer text
SHARDTRACKER_CONFIG.HEALTH_WARNING		= true;		-- Should the health warning occur
SHARDTRACKER_CONFIG.TRANCE_WARNING		= true;
SHARDTRACKER_CONFIG.TIMER_ONLY_TARGET	= false;


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              INITIALIZATION FUNCTIONS                                      --
--                                                                                            --
--============================================================================================--
--============================================================================================--

local Pre_ST_OnRTChatMessage;

STCOMM_CHANNELPREFIX	= "ST";
ST_GroupLeader 			= "";
LastSendTime			= 0;
LastRecieveTime			= 0;
LastMessageFrom			= "";
LastMessageArg			= "";
NoOnce					= false;
YesOnce					= false;

STTimer 				= {};

SummonerVisible					= false;
SoulstoneTarget					= "";
ShardTracker_Casting			= nil;
ShardTracker_SpellTargetName	= "";
ShardTracker_DragLock 			= true;
ShardTracker_BeingDragged 		= false;

--[[ Original values backup
SHARDTRACKER_ORIG_SHARDBUTTONX      = -70;
SHARDTRACKER_ORIG_SHARDBUTTONY      = 25;
SHARDTRACKER_ORIG_SOULBUTTONX       = -75;              
SHARDTRACKER_ORIG_SOULBUTTONY       = 3;              
SHARDTRACKER_ORIG_SPELLBUTTONX      = -72;              
SHARDTRACKER_ORIG_SPELLBUTTONY      = -21;
SHARDTRACKER_ORIG_HEALTHBUTTONX     = -60;              
SHARDTRACKER_ORIG_HEALTHBUTTONY     = -43;   
SHARDTRACKER_ORIG_TIMERBUTTONX      = -150;
SHARDTRACKER_ORIG_TIMERBUTTONY      = 0; 
]]--

-- LedMirage 6/19/2005 [1/1] Position change start
SHARDTRACKER_ORIG_TIMERBUTTONX      = 14;
SHARDTRACKER_ORIG_TIMERBUTTONY      = -100;
SHARDTRACKER_ORIG_SHARDBUTTONX      = 42;
SHARDTRACKER_ORIG_SHARDBUTTONY      = -100;
SHARDTRACKER_ORIG_HEALTHBUTTONX     = 70;              
SHARDTRACKER_ORIG_HEALTHBUTTONY     = -100;                
SHARDTRACKER_ORIG_SOULBUTTONX       = 42;              
SHARDTRACKER_ORIG_SOULBUTTONY       = -128;              
SHARDTRACKER_ORIG_SPELLBUTTONX      = 70;              
SHARDTRACKER_ORIG_SPELLBUTTONY      = -128;
-- LedMirage 6/19/2005 [1/1] Position change end 

ButtonSize = 0;

local SpellTimer 					= {Name = {},SName = {},Target = {},Time = {},TimeMax = {}};
local SpellCastTime 				= 0;

local ShardTracker_SoulstoneTargetName 	= ""
local ShardTracker_ChangedTarget 		= false;
local ShardTracker_CurrentTarget		= "";
local ShardTracker_HealthStoneAvailable	= true;

local PlayedHealthWarning 			= false;
local ShadowTranceOn 				= false;

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
    ShardTracker_HealthStoneText   = getglobal("ShardTrackerHealthText");
    
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
    ShardTracker_FireStoneCreated = 0;                  -- if we've created a firestone, but haven't yet equipped it
    ShardTracker_HealthStoneLoc = {-1, -1};             -- the bag / slot where our healthstone is
    ShardTracker_SoulstoneLoc = {-1, -1};               -- the bag / slot where our soulstone is
    ShardTracker_SpellStoneLoc = {-1, -1};              -- the bag / slot where our spellstone is
    ShardTracker_FireStoneLoc = {-1, -1};               -- the bag / slot where our firestone is
    ShardTracker_SpellStoneReady = 0;                   -- whether a spellstone is ready to be used
    ShardTracker_SpellStoneEquipped = 0;                -- whether a spellstone is equipped
    ShardTracker_SpellFireEquipped = 0;                 -- whether a firestone is equipped
    ShardTracker_SpellStoneIsActive = 0;                -- whether the spellstone was just used to cast its effect on us
    ShardTracker_Timer = { };                           -- structure to time cooldowns
    ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
    ShardTracker_Timer.SpellstoneTimeSeconds = 0
    ShardTracker_intoSeconds = nil;                     -- whether our soulstone cooldown timer is counting down minutes or seconds
    ShardTrackerHealth_intoSeconds = nil;
    ShardTracker_UnderTwoMinutes = nil;                 -- whether our soulstone cooldown timer is under two minutes
    ShardTracker_LastMinute = 0;                        -- track the last minute that we checked the soulstone's cooldown
    ShardTracker_SpellTableBuilt = nil;                 -- whether we've built the list of create health/soulstone spells available to us
    ShardTracker_OffHandItem = nil;                     -- the item in our offhand, so we can reequip it once we use up a spellstone
    ShardTracker_HealthstoneFlashing = {0, 0, 0, 0};    -- track the flashing state of party member's healthstone buttons
    ShardTracker_SentHealthstoneNotification = 0;       -- whether we've already notified warlocks in the party that we need a new healthstone
    
    ShardTracker_PartyMemberList = { };                 -- this list tracks our party members and various info about them
                                                        -- needed because we get notified of members joining/leaving before GetNumPartyMembers() is

	Pre_ST_OnRTChatMessage = ChatFrame_OnEvent;
	ChatFrame_OnEvent = ST_OnRTChatMessage;
                                                        
	LastSendTime = GetTime();
	
	ST_Hook("CastSpell", "ST_CastSpell", "before");
	ST_Hook("UseAction", "ST_UseAction", "before");

    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("UNIT_NAME_UPDATE");
    this:RegisterEvent("SPELLCAST_START");
    this:RegisterEvent("SPELLCAST_STOP");
    this:RegisterEvent("SPELLCAST_INTERRUPTED");
    this:RegisterEvent("SPELLCAST_FAILED");
    this:RegisterEvent("SPELLS_CHANGED");
    this:RegisterEvent("LEARNED_SPELL_IN_TAB");
    this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("DUEL_REQUESTED")
	this:RegisterEvent("DUEL_INBOUNDS");
	this:RegisterEvent("DUEL_OUTOFBOUNDS");
	this:RegisterEvent("DUEL_FINISHED");
    this:RegisterEvent("PARTY_LEADER_CHANGED");
    this:RegisterEvent("PLAYER_PET_CHANGED");
    this:RegisterEvent("PLAYER_REGEN_ENABLED");
    this:RegisterEvent("UNIT_HEALTH");
    this:RegisterEvent("UNIT_FOCUS");
    
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
   	this:RegisterForDrag("LeftButton");
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
    if ((UnitName("player") ~= "Unknown Being" and UnitName("player") ~= "Unknown Entity") and (event == "BAG_UPDATE" or event == "UNIT_NAME_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "UNIT_INVENTORY_CHANGED") ) then
    	-- To Avoid loading lag (I hope)
       	if event == "UNIT_NAME_UPDATE" and SHARDTRACKER_LOADED == false then
   	    	ShardTracker_UpdateShardTracker();
   	    	ST_GroupLeader = ST_GetPartyLeader();
   	    	RejoinSTChannel();
   	    	if SHARDTRACKER_CONFIG.UI_SCALE == nil then
   	    		SHARDTRACKER_CONFIG.UI_SCALE = 1;
   	    	end
        	ShardTrackerMinimapButton:SetScale(SHARDTRACKER_CONFIG.UI_SCALE);
        	ShardTrackerMinimapButtonHealth:SetScale(SHARDTRACKER_CONFIG.UI_SCALE);
        	ShardTrackerMinimapButtonSoul:SetScale(SHARDTRACKER_CONFIG.UI_SCALE);
        	ShardTrackerMinimapButtonSpell:SetScale(SHARDTRACKER_CONFIG.UI_SCALE);
        	SummonerMenu:SetScale(SHARDTRACKER_CONFIG.UI_SCALE);
        	STTimerButton:SetScale(SHARDTRACKER_CONFIG.UI_SCALE);
   	    	SHARDTRACKER_LOADED = true;
    	end
    	if event == "BAG_UPDATE" then
	    	ShardTracker_UpdateShardTracker();
	    	if SHARDTRACKER_CONFIG.AUTO_SORT == true then
	    		ShardTracker_SortShards("LeftButton");
	    	end
	    end
    elseif (event == "VARIABLES_LOADED") then
    	ShardTracker_InitializePartyHealthstoneIcons();
    	
    	-- position the buttons in the correct locations
    	ButtonSize = ShardTrackerMinimapButtonHealth:GetHeight();
    	ShardTracker_ButtonSetLocation();
    elseif (event == "SPELLCAST_START") then
    	ShardTracker_Casting = arg1;
		ShardTracker_SpellTargetName = UnitName("target");
		if ShardTracker_SpellTargetName then
			ShardTrackerDebug("Spell: "..arg1.." ("..ShardTracker_SpellTargetName..")");
		else
			ShardTracker_SpellTargetName = "";
		end
	elseif (event == "SPELLCAST_STOP") then
		if (ShardTracker_Casting == SHARDTRACKER_RITUALOFSUMMONING) then
			if SHARDTRACKER_CONFIG.SHOW_SUMMON ~= false then
				if GetNumRaidMembers() > 0 then
					if SHARDTRACKER_CONFIG.USE_SUMMONMESSAGE == true then
						SendChatMessage(SHARDTRACKER_CONFIG.CUSTOM_SUMMONMESSAGE, "RAID");
					else
						SendChatMessage(SHARDTRACKER_TARGETSUMMONED, "RAID");
					end
				elseif GetNumPartyMembers() > 0 then
					if SHARDTRACKER_CONFIG.USE_SUMMONMESSAGE  == true then
						SendChatMessage(SHARDTRACKER_CONFIG.CUSTOM_SUMMONMESSAGE, "PARTY");
					else
						SendChatMessage(SHARDTRACKER_TARGETSUMMONED, "PARTY");
					end
				end
			end
			ShardTracker_SpellTargetName = "";
			ShardTracker_Casting = nil;
		elseif (ShardTracker_Casting == SHARDTRACKER_SOULSTONEREZ) then
		    -- if we're using a soulstone on someone (casting Soulstone Resurrection), reset the soulstone timer
    		ShardTracker_SpellTargetName = UnitName("target");
			if ShardTracker_SpellTargetName then
			else
				ShardTracker_SpellTargetName = "";
			end
			ShardTracker_SoulstoneTargetName = ShardTracker_SpellTargetName;
		    STTimer_AddEvent(3.00,SoulstoneMessage);
		end
		if ShardTracker_Casting ~= nil and SHARDTRACKER_CONFIG.SHOW_TIMER == true then
			ShardTrackerDebug("Spellcasting STOP Add Spell: "..ShardTracker_Casting);
			AddTimer();
		else
			ShardTrackerDebug("Spellcasting STOP: Unknown Spell");
		end
		
		ShardTracker_ChangedTarget = false;

		-- DO NOT CLEAR THESE VARS
		--ShardTracker_SpellTargetName = "";
		--ShardTracker_Casting = nil;
		
    elseif (event == "SPELLCAST_INTERRUPTED") then
    	ShardTrackerDebug("Spellcasting INTERRUPTED");
    	if ShardTracker_Casting ~= nil and SHARDTRACKER_CONFIG.SHOW_TIMER == true then
    		-- Remove from Timer
    		RemoveTimer();
    		ShardTracker_Casting = nil;
    		ShardTracker_SpellTargetName = "";
    	end
    	
	elseif (event == "SPELLCAST_FAILED") then  
		ShardTrackerDebug("Spellcasting FAIL");  
		if ShardTracker_Casting ~= nil and SHARDTRACKER_CONFIG.SHOW_TIMER == true then
			--Remove from timer
			RemoveTimer();
			ShardTracker_Casting = nil;
			ShardTracker_SpellTargetName = "";
		end
		
	elseif (event == "PLAYER_REGEN_ENABLED") then
		--Remove all timers
		if SHARDTRACKER_CONFIG.SHOW_TIMER == true then
			ClearTimer();
		end
	
    -- if we learned new spells, update the list of spells we can cast
    -- since now we might be able to create a better healthstone or soulstone
    elseif (event == "LEARNED_SPELL_IN_TAB" or event == "SPELLS_CHANGED") then
        ShardTracker_BuildSpellTable();     

	-- Dueling checks for healhstones        
	elseif ( event == "DUEL_FINISHED" ) then
    	SHARDTRACKER_DUEL_IN_PROGRESS = 0;
    elseif ( event == "DUEL_OUTOFBOUNDS" ) then
    	SHARDTRACKER_DUEL_IN_PROGRESS = 0;
    elseif ( event == "DUEL_INBOUNDS" ) then
		SHARDTRACKER_DUEL_IN_PROGRESS = 1;
	elseif ( event == "DUEL_REQUESTED" ) then
		SHARDTRACKER_DUEL_IN_PROGRESS = 1;
		
	-- Healthstone bits
	elseif ( event == "PARTY_LEADER_CHANGED" ) then
		YesOnce = false;
		NoOnce = false;

		local leaderName = ST_GetPartyLeader();
		if ST_GroupLeader == leaderName then
			-- Leader is the same, no need to change anything	
			ShardTrackerDebug("ST Leader is the same: "..leaderName.." - "..ST_GroupLeader);
        	ShardTracker_PartyMemberList = { };
        	ShardTracker_InitializePartyHealthstoneIcons();
		else
			-- Not sure when/why sometimes Group Leader gets reset to "", this fixes it
			if (ST_GroupLeader and leaderName and leaderName ~= "Unknown Entity")  then
				ShardTrackerDebug("ST Leader changed from: "..ST_GroupLeader.." to "..leaderName);
				RejoinSTChannel();
				ST_GroupLeader = leaderName;
			else
				ShardTrackerDebug("ST Leader Blank, resetting");
			end
		end
		
	elseif (event == "PLAYER_PET_CHANGED" and UnitClass("player") == SHARDTRACKER_WARLOCK) then
		if (UnitIsFriend("player", "pet")) then
		else
			--Pet has either died or enslave broke, try and remove the timer, if it was charmed
			--it will clear it up
			RemoveTimerAny(SHARDTRACKER_ENSLAVEDEMON);
		end
	elseif (event == "UNIT_HEALTH" and arg1 == "player") then
		if ( SHARDTRACKER_CONFIG.SIZE_HEALTH ~= false and ShardTracker_HealthStoneAvailable == true ) then
			local HealthPercent = (100 * UnitHealth("player") / UnitHealthMax("player"));
			
			if (HealthPercent < 10) then
				Factor = 3.5;
			elseif (HealthPercent < 25) then
				Factor = 3;
				if ( SHARDTRACKER_CONFIG.HEALTH_WARNING ~= false ) then
					if PlayedHealthWarning == false then
						-- Check if the player is actually low on health or just Feign Deathed
						if ( CheckBuff(SHARDTRACKER_FEIGNDEATH) == false ) then
							if (ShardTracker_HaveHealthStone == 1) then
								if ( SHARDTRACKER_CONFIG.USE_SOUND ~= false ) then
									PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\LowHealthWarning.mp3");
								end
								UIErrorsFrame:AddMessage(SHARDTRACKER_USEHEALTHSTONE, 0.92, 0.75, 0.05, 1.0, 12);
								PlayedHealthWarning = true;
							end
						end
					end
				end
			elseif (HealthPercent < 50) then
				Factor = 2;
			elseif (HealthPercent < 75) then
				Factor = 1.5;
			elseif (HealthPercent >= 75) then
				Factor = 1;
				if PlayedHealthWarning == true then
					PlayedHealthWarning = false;
				end
			end
			
			if UnitHealth("player") <= 1 then
				-- Your dead, make the button normal size
				Factor = 1;
				PlayedHealthWarning = false;
			end
			ShardTrackerMinimapButtonHealth:SetHeight(ButtonSize*Factor);
			ShardTrackerMinimapButtonHealth:SetWidth(ButtonSize*Factor);
		end
	--gottaa
	--elseif (event == "CHAT_MSG_COMBAT_SELF_HITS" or event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") then
	elseif (event == "UNIT_FOCUS") then
		ShardTracker_ChangedTarget = true;
		ShardTracker_CurrentTarget = UnitName("target")
		if ShardTracker_CurrentTarget then
			ShardTrackerDebug("Targeting: "..ShardTracker_CurrentTarget);
		else
			ShardTrackerDebug("Targeting: NONE");
		end
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
            ShardTracker_SortShards("LeftButton");
        elseif (command == "report") then
            ShardTracker_DebugPrintStatus();
        elseif (command == "version") then
            Print("ShardTracker Version "..SHARDTRACKER_VERSION, 1, 1, 0.5);
        elseif (command == "sound") then
            if (var == "on") then
				PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\SoulStone.mp3");
                ShardTracker_Toggle_Sound(1);
            elseif (var == "off") then
                ShardTracker_Toggle_Sound(0);
            else
                ShardTracker_Toggle_Sound();
            end
        elseif (command == "channel") then
        	if var == "on" then
        		ShardTracker_Toggle_Channel(1);
        	elseif (var == "off") then
        		ShardTracker_Toggle_Channel(0);
        	else
	       		ShardTracker_Toggle_Channel();
        	end
        elseif (command == "flash") then
       		SHARDTRACKER_CONFIG.SHARD_FLASH_NUM = tonumber(var);
            ChatFrame1:AddMessage("Shard count will flash on "..SHARDTRACKER_CONFIG.SHARD_FLASH_NUM.." and below", 1.0, 1.0, 0.5);
        elseif (command == "refresh") then
        	ChatFrame1:AddMessage("Rejoining Healtstone channel", 1.0, 1.0, 0.5);
        	ShardTracker_PartyMemberList = { };
			LastMessageFrom	= "";
			LastMessageArg = "";
        	RejoinSTChannel();
        elseif (command == "lock" or command == "unlock") then
            ShardTracker_ToggleLockedForDragging(command);
        elseif (command == "reset") then
            ShardTracker_ResetButtonLocations();    
        elseif (command == "update") then
        	ChatFrame1:AddMessage("Requested Healthstone update", 1.0, 1.0, 0.5);
        	ShardTracker_PartyMemberList = { };
			LastMessageFrom	= "";
			LastMessageArg = "";
        	ShardTracker_InitializePartyHealthstoneIcons();
        elseif (command == "scale") then
        	UIScale = tonumber(var)/100;
        	ChatFrame1:AddMessage("ShardTracker scale set to "..UIScale.."%", 1.0, 1.0, 0.5);
        	SHARDTRACKER_CONFIG.UI_SCALE = UIScale;
        	ShardTrackerMinimapButton:SetScale(UIScale);
        	ShardTrackerMinimapButtonHealth:SetScale(UIScale);
        	ShardTrackerMinimapButtonSoul:SetScale(UIScale);
        	ShardTrackerMinimapButtonSpell:SetScale(UIScale);
        	SummonerMenu:SetScale(UIScale);
        	STTimerButton:SetScale(UIScale);
        	ShardTracker_ResetButtonLocations();
        elseif (command == "summonmessage") then
            if var == "on" then
            	ChatFrame1:AddMessage("Summoning message enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHOW_SUMMON = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Summoning message disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHOW_SUMMON = false;
			end
        elseif (command == "soulmessage") then
            if var == "on" then
            	ChatFrame1:AddMessage("Soulstone message enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHOW_SOUL = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Soulstone message disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHOW_SOUL = false;
			end
        elseif (command == "healthsizing") then
            if var == "on" then
            	ChatFrame1:AddMessage("Healthstone sizing enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SIZE_HEALTH = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Healthstone sizing disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SIZE_HEALTH = false;
			end
		elseif (command == "customsoul") then
			if var == "" then
				SHARDTRACKER_CONFIG.USE_SOULMESSAGE = false;
				SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE = var;
				ChatFrame1:AddMessage("Soulstone message reset to default.", 1.0, 1.0, 0.5);
			else
				SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE = var;
				SHARDTRACKER_CONFIG.USE_SOULMESSAGE = true;
				ChatFrame1:AddMessage("Soulstone message set to: "..SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE, 1.0, 1.0, 0.5);
			end
		elseif (command == "customsummon") then
			if var == "" then
				SHARDTRACKER_CONFIG.USE_SUMMONMESSAGE = false;
				SHARDTRACKER_CONFIG.CUSTOM_SUMMONMESSAGE = var;
				ChatFrame1:AddMessage("Summoning message reset to default.", 1.0, 1.0, 0.5);
			else
				SHARDTRACKER_CONFIG.CUSTOM_SUMMONMESSAGE = var;
				SHARDTRACKER_CONFIG.USE_SUMMONMESSAGE = true;
				ChatFrame1:AddMessage("Summoning message set to: "..SHARDTRACKER_CONFIG.CUSTOM_SUMMONMESSAGE, 1.0, 1.0, 0.5);
			end
        elseif (command == "timer") then
            if var == "on" then
            	ChatFrame1:AddMessage("Timer enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHOW_TIMER = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Timer disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHOW_TIMER = false;
        		ClearTimer();
			end
		elseif (command == "timersize") then
			if var == "small" or var == "Small" then
				SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE = "Small"
				ChatFrame1:AddMessage("Timer size set to small font", 1.0, 1.0, 0.5);
			elseif var == "large" or var == "Large" then
				SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE = "Large"
				ChatFrame1:AddMessage("Timer size set to large font", 1.0, 1.0, 0.5);
			else
				SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE = "Normal"
				ChatFrame1:AddMessage("Timer size set to default font", 1.0, 1.0, 0.5);
			end
		elseif (command == "shorttimertext") then
            if var == "on" then
            	ChatFrame1:AddMessage("Short Timer text enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHORT_TIMER_TEXT = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Short Timer text disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.SHORT_TIMER_TEXT = false;
			end
		elseif (command == "healthwarning") then
            if var == "on" then
            	ChatFrame1:AddMessage("Health Warning enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.HEALTH_WARNING = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Health Warning disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.HEALTH_WARNING = false;
			end
		elseif (command == "trancewarning") then
            if var == "on" then
            	ChatFrame1:AddMessage("Trance Warning enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.TRANCE_WARNING = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Trance Warning disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.TRANCE_WARNING = false;
			end
		elseif (command == "timertargetonly") then
            if var == "on" then
            	ChatFrame1:AddMessage("Timer only displaying target spells enabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.TIMER_ONLY_TARGET = true;
        	elseif (var == "off") then
        		ChatFrame1:AddMessage("Timer only displaying target spells disabled", 1.0, 1.0, 0.5);
        		SHARDTRACKER_CONFIG.TIMER_ONLY_TARGET = false;
			end
		elseif (command == "soul") then
			TargetByName(ShardTracker_SoulstoneTargetName);
		elseif (command == "test") then
			--gottaa
			ShardTracker_Timer.SoulstoneExpireTimeSeconds = GetTime() + 180;
			
        elseif (command == "" or command == "help" or command == "?") then
            if (ChatFrame1) then
                ChatFrame1:AddMessage("Shardtracke NCSr", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("Usage: /shardtracker or /st", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st version. Shows you what verson of ShardTracker you are using.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st on|off|toggle.  Turns ShardTracker on or off, or toggles on/off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st sort.  Sorts all the shards into the default bag.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st bag [0-4]. Sets the default bag for shards.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st sound on|off. Turns sound effects on or off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st channel on|off. Turns channel joining on or off. (Group healthstone data)", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st refresh. Force a channel update and refresh to ensure you are in the correct channel,.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st update. Request Healthstone status update.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st flash [number]. Sets no. of shards to start flashing at.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st lock|unlock. Locks or unlocks the minimap icons so they can be moved.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st scale [number]. Sets The scaling size for buttons and summoner menu", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st reset. Resets the icons back to there default positions.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st soulmessage on|off. Turns the soulstone message to party/raid on or off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st summonmessage on|off. Turns the summon message to party/raid on or off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st healthsizing on|off. Sizes the healthstone icon according to health.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st customsoul <message>. Set the Soulstone message (target name is always added to the start of this message.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st customsummon <message>. Set the summoning message.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st timer on|off. Turns the timer display on or off.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st timersize small|default|large. Sets the font size of the timer.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st shorttimertext on|off. Turns on and off the abbreviated timer text.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st healthwarning on|off. Turns on and off the health warning.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st trancewarning on|off. Turns on and off the Shadow Trance warning.", 1.0, 1.0, 0.5);
                ChatFrame1:AddMessage("/st timertargetonly on|off. Turns on and off the timer only shows spells on current target.", 1.0, 1.0, 0.5);
            end
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
    local foundFireStone = 0;
    
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
                        if (itemName == SHARDTRACKER_SOULSHARD) then
                            shardCount = shardCount+ 1;

                        -- if the item is a soulstone, remember which slot it's in so
                        -- that we can activate it later, if the player clicks on the healthstone button
                        elseif (string.find(itemName, SHARDTRACKER_SOULSTONE, 1, TRUE) ~= nil) then
                            foundSoulStone = 1;
                            ShardTracker_SoulstoneLoc = {bag, slot};
                            ShardTracker_MoneyToggle();
                            theResult = easyscan("ShardTrackerTooltip");
                            ShardTracker_MoneyToggle();

                            -- look for the "Cooldown remaining" text in the stone's tooltip
                            timeRemainingText = theResult[6].left;
                            if (string.find(timeRemainingText, SHARDTRACKER_COOLDOWNREMAINING, 1, TRUE) ~= nil) then
                                ShardTracker_SoulStoneExpired = 0;

                                -- grab the number of seconds or minutes remaining
                                for theTime in string.gfind(timeRemainingText, "%d+") do
                                    timeRemaining = theTime;
                                end

                                -- check if the tooltip has the word "sec" in it, we're counting down seconds
                                -- otherwise, we're counting down minutes
                                ShardTracker_intoSeconds = string.find(timeRemainingText, "sec", 1, TRUE);                                      
                                timeRemaining = tonumber(timeRemaining);
                                
						    	ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulNotReady");
                                ShardTracker_ShowSoulstoneTime(timeRemaining, ShardTracker_intoSeconds);

                            -- else if there's no "cooldown remaining" then the cooldown has expired
                            else
                            	ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoul");
                            	ShardTracker_SoulStoneText:SetText("");
                            	ShardTracker_intoSeconds = nil;
                        		ShardTracker_UnderTwoMinutes = nil;
								if (ShardTracker_SoulStoneExpired ~= 1) then
                                   	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00**"..SHARDTRACKER_COOLDOWNFINISHED.."**|r");
                                   	if ShardTracker_SoulstoneTargetName ~= "" then
                                   		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..ShardTracker_SoulstoneTargetName.." "..SHARDTRACKER_LASTSOULSTONE.."|r");
                                   	end
                                   	UIErrorsFrame:AddMessage(SHARDTRACKER_COOLDOWNFINISHED, 0.92, 0.75, 0.05, 1.0, 12);
                                    if (SHARDTRACKER_CONFIG.USE_SOUND ~= false) then
										PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\SoulStone.mp3");
                                    end
                                    ShardTracker_SoulStoneExpired = 1;
                                end
                            end

                        -- if the item is a healthstone, remember which slot it's in so
                        -- that we can activate it later, if the player clicks on the healthstone button
                        elseif (string.find(itemName, SHARDTRACKER_HEALTHSTONE, 1, TRUE) ~= nil) then
                            foundHealthStone = 1;
                            ShardTracker_HealthStoneLoc = {bag, slot};
                            
                            ShardTracker_MoneyToggle();
							theResult = easyscan("ShardTrackerTooltip");
                            ShardTracker_MoneyToggle();

                            -- look for the "Cooldown remaining" text in the stone's tooltip
                            --gottaa
                            if theResult then
								if theResult[6] and (string.find(theResult[6].left, SHARDTRACKER_COOLDOWNREMAINING, 1, TRUE) ~= nil) then
									timeRemainingText = theResult[6].left;
								elseif theResult[5] and (string.find(theResult[5].left, SHARDTRACKER_COOLDOWNREMAINING, 1, TRUE) ~= nil) then
									timeRemainingText = theResult[5].left;
								else
									timeRemainingText = ""
								end
							end
                            if (string.find(timeRemainingText, SHARDTRACKER_COOLDOWNREMAINING, 1, TRUE) ~= nil) then
                                ShardTracker_HealthStoneAvailable = false;

                                -- grab the number of seconds or minutes remaining
                                for theTime in string.gfind(timeRemainingText, "%d+") do
                                    HealthTimeRemaining = tonumber(theTime);
                                end

                                -- check if the tooltip has the word "sec" in it, we're counting down seconds
                                -- otherwise, we're counting down minutes
                                ShardTrackerHealth_intoSeconds = string.find(timeRemainingText, "sec", 1, TRUE);                                      
                                HealthTimeRemaining = tonumber(HealthTimeRemaining);

                                ShardTracker_ShowHealthstoneTime(HealthTimeRemaining, ShardTrackerHealth_intoSeconds);
                                --gottaa
                                --ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealthNotReady");
							else
								-- Ready to use it							
								ShardTracker_HealthStoneAvailable = true;
								ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealth");
								ShardTracker_HealthStoneText:SetText("");
								ShardTrackerHealth_intoSeconds = nil;
							end
                        -- if the item is a spellstone
                        elseif (string.find(itemName, SHARDTRACKER_SPELLSTONE, 1, TRUE) ~= nil and (ShardTracker_SpellStoneEquipped ~= 1)) then
                            ShardTracker_SpellStoneInBag = 1;
                            ShardTracker_SpellStoneLoc = {bag, slot};
						-- if the item is a spellstone
                        elseif (string.find(itemName, SHARDTRACKER_FIRESTONE, 1, TRUE) ~= nil and (ShardTracker_FireStoneEquipped ~= 1)) then
							ShardTracker_FireStoneLoc = {bag, slot};
			    		    ShardTracker_FireStoneCreated = 1;
			    		    ShardTracker_FireStoneEquipped = 0;
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
    if (ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK) then
    
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
                --ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoul");
            else
                ShardTracker_SoulstoneLoc = {-1, -1};
                
                -- if we'd cast Soulstone Resurrection and haven't made a new Soulstone, track the time until we can cast it again
                if (ShardTracker_Timer.SoulstoneExpireTimeSeconds ~= 0) then
                    local timeRemaining = ShardTracker_Timer.SoulstoneExpireTimeSeconds - GetTime();
                    if (timeRemaining <= 0) then
                    	if ShardTracker_SoulStoneExpired ~= 1 then
                    		ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
							DEFAULT_CHAT_FRAME:AddMessage("|cffffff00**"..SHARDTRACKER_COOLDOWNFINISHED.."**|r");
							if ShardTracker_SoulstoneTargetName ~= "" then
								DEFAULT_CHAT_FRAME:AddMessage("|cffffff00"..ShardTracker_SoulstoneTargetName.." "..SHARDTRACKER_LASTSOULSTONE.."|r");
							end
							UIErrorsFrame:AddMessage(SHARDTRACKER_COOLDOWNFINISHED, 0.92, 0.75, 0.05, 1.0, 12);
	                        if (SHARDTRACKER_CONFIG.USE_SOUND ~= false) then
								PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\SoulStone.mp3");
	                        end
                        	ShardTracker_SoulStoneExpired = 1;
                        else
                        	ShardTracker_Timer.SoulstoneExpireTimeSeconds = 0;
                        end
						ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulGreyed");
						ShardTracker_SoulStoneText:SetText("");
						ShardTracker_intoSeconds = nil;
                        ShardTracker_UnderTwoMinutes = nil;
                    elseif (timeRemaining < 60) then
                    	ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulNotReady");
                    	ShardTracker_SoulStoneExpired = 0;
                        ShardTracker_intoSeconds = true;
                        ShardTracker_UnderTwoMinutes = nil;
                    elseif (timeRemaining < 120) then
                    	ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulNotReady");
                        ShardTracker_intoSeconds = nil;
                        ShardTracker_UnderTwoMinutes = true;
                    else
                    	ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulNotReady");
                        ShardTracker_intoSeconds = nil;
                        ShardTracker_UnderTwoMinutes = nil;
                        timeRemaining = timeRemaining / 60;
                    end
                    ShardTracker_ShowSoulstoneTime(timeRemaining, ShardTracker_intoSeconds);
                else
	                ShardTracker_SoulStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSoulGreyed");
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
                    if (string.find(itemName, SHARDTRACKER_SPELLSTONE, 1, true)) then

                        spellStoneInOffHand = 1;

                        -- look for the "Cooldown remaining" text in the stone's tooltip
                        timeRemainingText = itemTip[8].left;
                        if (string.find(timeRemainingText, SHARDTRACKER_COOLDOWNREMAINING, 1, TRUE) ~= nil) then
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
            elseif ShardTracker_FireStoneEquipped == 1 then
               	ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardRed");
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

    -- regardless of character class, display the healthstone button, if we have one in inventory
    if ((foundHealthStone == 1 and SHARDTRACKER_HEALTHSTONE_ENABLED == 1) or SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE == 1) then
    	if ShardTracker_HealthStoneAvailable == true then
        	ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealth");
        end
        if ShardTracker_HaveHealthStone == 0 and foundHealthStone == 1 then
        	if (ShardTracker_PlayerClass ~= SHARDTRACKER_WARLOCK) then 
        		YesOnce = false;
        		SendSTChat_Yes();
        	end
        end
        ShardTracker_HealthStoneButton:Show();
    else
        ShardTracker_HealthStoneButton:Show();
        ShardTracker_HealthStoneAvailable = false;
    end
    
    if ( SHARDTRACKER_HEALTHSTONE_ENABLED == 0 ) then
    	ShardTracker_HealthStoneButton:Hide();
    end
        
    -- if we don't have a healthstone, reset the variable that tells us where it is in our pack
    if (foundHealthStone == 0) then
        ShardTracker_HealthStoneLoc = {-1, -1};
        ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealthGreyed");
        if (ShardTracker_PlayerClass ~= SHARDTRACKER_WARLOCK) then ShardTracker_HealthStoneButton:Hide(); end
        if ShardTracker_HaveHealthStone == 1 then
        	if (ShardTracker_PlayerClass ~= SHARDTRACKER_WARLOCK) then 
        		NoOnce = false;
        		SendSTChat_No();
        	end
        end
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

    if elapsed == nil then
    	elapsed = 0;
    end
    
    --[[
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

    if (ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK) then
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
    ]]--
    
	--gottaa
	if (ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK) then
  
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
        if (minute ~= ShardTracker_LastMinute or ShardTracker_intoSeconds ~= nil or ShardTrackerHealth_intoSeconds ~= nil or ShardTracker_UnderTwoMinutes ~= nil or (ShardTracker_SpellStoneEquipped == 1 and ShardTracker_SpellStoneReady == 0)) then
            ShardTracker_LastMinute = minute;
            ShardTracker_UpdateShardTracker();
        end

        -- update the shard sorting code
        ShardTracker_UpdateShardSorter();
        
        local TimeText = "";
        curTime = GetTime();
        if SHARDTRACKER_CONFIG.SHOW_TIMER == true then
        	local update = false;
        	if ((curTime-SpellCastTime) >= 1) then
				SpellCastTime = curTime;
				update = true;
			end
			for index=1, table.getn(SpellTimer.Name), 1 do
				--gottaa
				if (SpellTimer.Time[index] > 0) then
					Seconds = SpellTimer.Time[index];
					local Minutes = floor(Seconds/60);
					Seconds = mod(Seconds, 60);
					local percent = floor((SpellTimer.Time[index]/SpellTimer.TimeMax[index])*100);
					local colour = "|CFF00FF00";
					if (percent < 10) then colour = "|CFFFF0000";
					elseif (percent < 20) then colour = "|CFFFF3300";
					elseif (percent < 30) then colour = "|CFFFF6600";
					elseif (percent < 40) then colour = "|CFFFF9933";
					elseif (percent < 50) then colour = "|CFFFFCC00";
					elseif (percent < 60) then colour = "|CFFFFFF66";
					elseif (percent < 70) then colour = "|CFFCCFF66";
					elseif (percent < 80) then colour = "|CFF99FF66";
					elseif (percent < 90) then colour = "|CFF66FF66";
					end
					
					if SHARDTRACKER_CONFIG.TIMER_ONLY_TARGET == true then
						if ShardTracker_CurrentTarget == SpellTimer.Target[index] then
							if (Seconds >= 10) then
								TimeText = TimeText.."" .. Minutes .. ":" .. Seconds;
							else
								TimeText = TimeText.."" .. Minutes .. ":0" .. Seconds;
							end
							if SHARDTRACKER_CONFIG.SHORT_TIMER_TEXT == true then
								TimeText = TimeText.." - "..colour..SpellTimer.SName[index].."|r";
							else
								TimeText = TimeText.." - "..colour..SpellTimer.Name[index].."|r";
							end
							TimeText = TimeText.."\n";
						end
					else
						if (Seconds >= 10) then
							TimeText = TimeText.."" .. Minutes .. ":" .. Seconds;
						else
							TimeText = TimeText.."" .. Minutes .. ":0" .. Seconds;
						end
						if SHARDTRACKER_CONFIG.SHORT_TIMER_TEXT == true then
							TimeText = TimeText.." - "..colour..SpellTimer.SName[index].."|r -> ";
						else
							TimeText = TimeText.." - "..colour..SpellTimer.Name[index].."|r -> ";
						end
						TimeText = TimeText..SpellTimer.Target[index];
						TimeText = TimeText.."\n";
					end
					if update then
						SpellTimer.Time[index] = SpellTimer.Time[index]-1;
						if (SpellTimer.Time[index] == 0) then
							if SpellTimer.Name[index] == SHARDTRACKER_ENSLAVEDEMON then
								if (SHARDTRACKER_CONFIG.USE_SOUND ~= false) then
									PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\EnslaveBroke.mp3");
								end
							end
							table.remove(SpellTimer.Name, index);
							table.remove(SpellTimer.SName, index);
							table.remove(SpellTimer.Target, index);
							table.remove(SpellTimer.Time, index);
							table.remove(SpellTimer.TimeMax, index);
							break;
						end
					end
				end
			end
		    if SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE == "Large" then
		    	ST_Time_TextLarge:SetText(TimeText);
		    	ST_Time_TextSmall:SetText("");
		    	ST_Time_Text:SetText("");
		    elseif SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE == "Small" then
		    	ST_Time_TextSmall:SetText(TimeText);
		    	ST_Time_TextLarge:SetText("");
		    	ST_Time_Text:SetText("");
		    else
		    	ST_Time_Text:SetText(TimeText);
		    	ST_Time_TextLarge:SetText("");
		    	ST_Time_TextSmall:SetText("");
		    end
		end    

		-- Scan in current buffs to check for Shadow Trance
	    if SHARDTRACKER_CONFIG.TRANCE_WARNING ~= false then
		    if ( CheckBuff(SHARDTRACKER_SHADOWTRANCE) == true ) then
				if ShadowTranceOn == false then
					ShadowTranceOn = true;
					if (SHARDTRACKER_CONFIG.USE_SOUND ~= false) then
						PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\ShadowTrance.mp3");
					end
					UIErrorsFrame:AddMessage(SHARDTRACKER_ENTEREDSHADOWTRANCE, 0.92, 0.75, 0.05, 1.0, 12);
				end
		    else
				ShadowTranceOn = false;
		    end
		end
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
    if (myClass == SHARDTRACKER_WARLOCK) then

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
        -- Idea to make the last 2 minutes more accurate
        if timeRemaining == 2 then
        	ShardTracker_intoSeconds = true;
        end
    end
end

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              HEALTHSTONE FUNCTIONS                                     --
--                                                                                            --
--============================================================================================--
--============================================================================================--

function ShardTracker_ShowHealthstoneTime(timeRemaining, intoSeconds)
                                    
    -- display the number of minutes or seconds remaining until
    -- the player can use another soulstone
    timeRemaining = easyround(timeRemaining);
    
    if (timeRemaining > 0) then
    	ShardTracker_HealthStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealthNotReady");
        ShardTracker_HealthStoneText:SetText(timeRemaining);
        ShardTracker_HealthStoneText:Show();
    else
        ShardTracker_HealthStoneText:SetText("");
        ShardTracker_HealthStoneText:Hide();
    end
    
    -- if we're displaying seconds (as opposed to minutes), show
    -- the seconds in yellow text
    if (intoSeconds ~= nil) then
        ShardTracker_HealthStoneText:SetTextColor(1.0,1.0,0.3);
    else
        ShardTracker_HealthStoneText:SetTextColor(1.0,1.0,1.0);
        ShardTracker_HealthStoneText:SetText(timeRemaining.."m");
        if timeRemaining == 2 then
        	ShardTrackerHealth_intoSeconds = true;
        end

    end
end

-----------------------------------------------------------------------------------
--
-- If the user clicks on the healthstone button, activate the healthstone.
-- If there's no healthstone to use, try to create one.
--
-----------------------------------------------------------------------------------
function ShardTracker_OnHealthButtonClick(button)

    -- if we found a healthstone in a bag and slot
    
    if (button == "RightButton") then
    	if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
    		if SummonerVisible == false then
				SummonerMenu:Show();
				SummonerVisible = true;
				GameTooltip:Hide();
			else
				SummonerMenu:Hide();
				SummonerVisible = false;
			end
		end
   	elseif (button == "LeftButton") then
    	if (ShardTracker_HealthStoneLoc[1] ~= -1 and ShardTracker_HealthStoneLoc[2] ~= -1) then

	        -- if we're a warlock and have a friendly target selected, try to give the healthstone to that target
	        if (UnitClass("player") == SHARDTRACKER_WARLOCK and UnitExists("target") and UnitIsPlayer("target") and UnitCanCooperate("player", "target") and (SHARDTRACKER_DUEL_IN_PROGRESS == 0)) then
	        	-- pickup the healthstone and drop it on the target
	        	PickupContainerItem(ShardTracker_HealthStoneLoc[1], ShardTracker_HealthStoneLoc[2]);
	        	if ( CursorHasItem() ) then
	            	DropItemOnUnit("target");
	            	STTimer_AddEvent(3.00, AcceptTrade);
	        	end
	            
	        -- otherwise without a friendly target selected, use the healthstone
	        else
      	   		if ShardTracker_HealthStoneAvailable == true then
		            UseContainerItem(ShardTracker_HealthStoneLoc[1], ShardTracker_HealthStoneLoc[2]);
		        else
		        	ShardTrackerDebug("ST: Didn't use healthstone, timer still counting down");
				end
	        end
	        
	    -- else we don't have a healthstone, so if we're a warlock, try to create one
	    else
	        if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
	            if (ShardTracker_TotalShards > 0 and ShardTracker_CreateHealthStoneSpellID) then
	                CastSpell(ShardTracker_CreateHealthStoneSpellID, "spell");
	                ShardTrackerHealth_intoSeconds = nil;
	            end
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
function ShardTracker_OnSpellButtonClick(button)
    local myClass = UnitClass("player");
    if (myClass == SHARDTRACKER_WARLOCK) then
    
		if (button == "RightButton") then
			if (ShardTracker_FireStoneCreated == 1) then
				ShardTracker_EquipFireStone();
			elseif (ShardTracker_TotalShards > 0 and ShardTracker_CreateFireStoneSpellID and ShardTracker_FireStoneCreated ~= 1) then
	    		CastSpell(ShardTracker_CreateFireStoneSpellID, "spell");
			end
	    elseif (button == "LeftButton") then
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
-- Equip a firestone
--
-----------------------------------------------------------------------------------
function ShardTracker_EquipFireStone()

    if ShardTracker_FireStoneEquipped == 0 then
        -- remember what item (if any) we have equipped in our offhand
    	-- so that we can re-equip when we use the spellstone
	    ShardTracker_RememberOffHandItem();

	    -- equip the firestone
	    PickupContainerItem(ShardTracker_FireStoneLoc[1], ShardTracker_FireStoneLoc[2]);
	    ShardTrackerDebug("Picking up spellstone at bag = "..ShardTracker_SpellStoneLoc[1].." slot = "..ShardTracker_SpellStoneLoc[2]);
	    if ( CursorHasItem() ) then
	        ShardTrackerDebug("Cursor has item.  Trying to equip spellstone...");
	        PickupInventoryItem(18);
	    else
	        ShardTrackerDebug("Cursor doesn't have item!");
	    end
		
    	ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardRed");
	    
	    -- we've equipped it
	    ShardTracker_FireStoneEquipped = 1;
	    ShardTracker_FireStoneLoc = {-1, -1};
    else
    	if (ShardTracker_OffHandItem) then
	        theBag, theSlot = ShardTrackerFindItemBagSlotByName(ShardTracker_OffHandItem);
	        if (theBag) then    
	            UseContainerItem(theBag, theSlot);
		    	ShardTracker_FireStoneEquipped = 0;
		    	ShardTracker_SpellStoneButton:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardSpellGreen");
	        end
        end
    end
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
                    local itemName = ShardTracker_GetItemNameInBagSlot(bag, slot, true);
                                            
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
    ShardTracker_SummounMountSpellID = nil;
    ShardTracker_DemonBuffSpellID = nil;
    
    -- Tidy up Summoner options
	SummonerButtonDemon1:Hide();
	SummonerButtonDemon2:Hide();
	SummonerButtonDemon3:Hide();
	SummonerButtonDemon4:Hide();
	SummonerButtonDemon5:Hide();
	SummonerButtonDemon6:Hide();
	SummonerButtonDemon7:Hide();
	SummonerButtonDemon8:Hide();
	SummonerButtonDemon9:Hide();
	SummonerButtonDemon10:Hide();
	
    ShardTracker_SummounImpSpellID = nil;
    ShardTracker_SummounVoidwalkerSpellID = nil;
    ShardTracker_SummounSuccubusSpellID = nil;
    ShardTracker_SummounFelhunterSpellID = nil;
    ShardTracker_SummounInfernalSpellID = nil;
    ShardTracker_RitualOfDoomSpellID = nil;
    ShardTracker_CurseOfDoomSpellID = nil;
    ShardTracker_EnslaveDemonSpellID = nil;
    ShardTracker_CurseOfShadowSpellID = nil;
    ShardTracker_FelDominationSpellID = nil;
    ShardTracker_EyeofKilrogSpellID = nil;
    ShardTracker_RitualofSummoningSpellID = nil;
    
    -- as we look through the spellbook, these variables will
    -- allow us to remember the highest level of a spell that
    -- we're found overall, since we only want to case the
    -- highest level create health/soulstone spell
    local HighestSoulstoneSpellLevelSeen = 0;
    local HighestFirestoneSpellLevelSeen = 0;
    local HighestHealthstoneSpellLevelSeen = 0;
    local HighestSpellstoneSpellLevelSeen = 0;
    local HighestSteedSpellLevelSeen = 0;
    local HighestDemonBuffSpellLevelSeen = 0;
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
            -- find the Firestone Spell
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
                
            -- find the Mount Spell
            elseif (string.find(spellName, SHARDTRACKER_STEED, 1, true)) then
                spellLevel = 0;
                if (spellName == SHARDTRACKER_SUMMONFELSTEED) then
					spellLevel = 1;
				elseif (spellName == SHARDTRACKER_SUMMONDREADSTEED) then
					spellLevel = 2;
				end
                if (spellLevel > HighestSteedSpellLevelSeen) then
                	ShardTracker_SummounMountSpellID = id;
                	HighestSteedSpellLevelSeen = spellLevel;
                end
                
            elseif (string.find(spellName,SHARDTRACKER_SUMMONIMP,1,true)) then
            	ShardTracker_SummounImpSpellID = id;
            	SummonerButtonDemon2:Show();
            elseif (string.find(spellName,SHARDTRACKER_SUMMONVOIDWALKER,1,true)) then
            	ShardTracker_SummounVoidwalkerSpellID = id;
            	SummonerButtonDemon3:Show();
            elseif (string.find(spellName,SHARDTRACKER_SUMMONSUCCUBUS,1,true)) then
            	ShardTracker_SummounSuccubusSpellID = id;
            	SummonerButtonDemon4:Show();
            elseif (string.find(spellName,SHARDTRACKER_SUMMONFELHUNTER,1,true)) then
           		ShardTracker_SummounFelhunterSpellID = id;
           		SummonerButtonDemon5:Show();
			elseif (string.find(spellName,SHARDTRACKER_INFERNO,1,true)) then            	 	
			    ShardTracker_SummounInfernalSpellID = id;
			    SummonerButtonDemon6:Show();
			elseif (string.find(spellName,SHARDTRACKER_CURSEOFDOOM,1,true)) then            	 	
				ShardTracker_CurseOfDoomSpellID = id;
				SummonerButtonDemon7:Show();
			elseif (string.find(spellName,SHARDTRACKER_RITUALOFDOOM,1,true)) then
				ShardTracker_RitualOfDoomSpellID = id;
				SummonerButtonDemon8:Show();
			elseif (string.find(spellName,SHARDTRACKER_ENSLAVEDEMON,1,true)) then
				ShardTracker_EnslaveDemonSpellID = id;
			elseif (string.find(spellName,SHARDTRACKER_CURSEOFSHADOW,1,true)) then
				ShardTracker_CurseOfShadowSpellID = id;
			elseif (string.find(spellName,SHARDTRACKER_FELDOMINATION,1,true)) then
				ShardTracker_FelDominationSpellID = id;
				SummonerButtonDemon1:Show();
			elseif (string.find(spellName,SHARDTRACKER_EYEOFKILROG,1,true)) then
				ShardTracker_EyeofKilrogSpellID = id;
				SummonerButtonDemon9:Show();
			elseif (string.find(spellName,SHARDTRACKER_RITUALOFSUMMONING,1,true)) then
				ShardTracker_RitualofSummoningSpellID = id;
				SummonerButtonDemon10:Show();
				
			elseif (string.find(spellName, SHARDTRACKER_DEMONBUFF, 1, true)) then
                spellLevel = 0;
                if (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF1) then
                    spellLevel = 1;
                elseif (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF2) then
                    spellLevel = 2;
                elseif (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF3) then
                    spellLevel = 3;
                elseif (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF4) then
                	spellLevel = 4;
                elseif (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF5) then
                	spellLevel = 5;
                elseif (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF6) then
                	spellLevel = 6;
                elseif (spellName.." "..subSpellName == SHARDTRACKER_DEMONBUFF7) then
                	spellLevel = 7;
                end
                if (spellLevel > HighestDemonBuffSpellLevelSeen) then
                    ShardTracker_DemonBuffSpellID = id;
                    HighestDemonBuffSpellLevelSeen = spellLevel;
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
    easyclear("GameTooltip");
    ShardTracker_MoneyToggle();

    ShardTracker_MoneyToggle();
    GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
    ShardTracker_MoneyToggle();

    ShardTracker_MoneyToggle();
    GameTooltip:SetText(theText1, 1.00, 1.00, 1.00);
    ShardTracker_MoneyToggle();
    
    -- if we're not a warlock and this is a healthstone, show a different tooltip
    if (UnitClass("player") ~= SHARDTRACKER_WARLOCK and theText1 == SHARDTRACKER_HEALTHBUTTON_TIP1) then
        ShardTracker_MoneyToggle();
        GameTooltip:AddLine(SHARDTRACKER_HEALTHBUTTON_TIP5, 0.82, 0.24, 0.79);
        ShardTracker_MoneyToggle();
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
        if (ShardTracker_PlayerClass ~= SHARDTRACKER_WARLOCK) then
            ShardTracker_HealthStoneButton:Show();
        end
    else
        SHARDTRACKER_CONFIG.FLASH_HEALTHSTONE = 0;
        if (ShardTracker_PlayerClass ~= SHARDTRACKER_WARLOCK) then
            ShardTracker_HealthStoneButton:Hide();
        end
    end
end

function ShardTracker_Toggle_Shards(toggle)
    if (toggle == 1 and ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
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
    if (toggle == 1 and ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
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
    if (toggle == 1 and ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK and SHARDTRACKER_CONFIG.ENABLED == 1) then
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

function ShardTracker_Toggle_Channel(toggle)
    if (not toggle) then
        if (SHARDTRACKER_CONFIG.CHANNEL_JOIN == true) then
            toggle = false;
        else
            toggle = true;
        end
    end
    if (toggle == 0) then toggle = false end;
    if (toggle == 1) then toggle = true end;
    if (toggle) then
        if ((SHARDTRACKER_CONFIG.CHANNEL_JOIN ~= toggle)) then
            ChatFrame1:AddMessage("ShardTracker: Channel On", 1.0, 1.0, 0.5);
        end
        SHARDTRACKER_CONFIG.CHANNEL_JOIN = true;
        RejoinSTChannel();
    else
        if (SHARDTRACKER_CONFIG.CHANNEL_JOIN ~= toggle) then
            ChatFrame1:AddMessage("ShardTracker: Channel Off", 1.0, 1.0, 0.5);
        end
        SHARDTRACKER_CONFIG.CHANNEL_JOIN = false;
        LeaveAllSTChannels();
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


----------------------------------------------
--
-- Generic Timer - Based on Cosmos_Schedule
--
----------------------------------------------
function STTimer_AddEvent(delay, handler, ...)
	local newEvent = {};
	newEvent.time = (GetTime() + delay);
	newEvent.handler = handler
	newEvent.args = arg;
	
	local i = 1;
	while(STTimer.PendingEvents[i] and STTimer.PendingEvents[i].time < newEvent.time) do
		i = i + 1;
	end
	table.insert(STTimer.PendingEvents, i, newEvent);
end

function STTimer_AddEventByName(name, delay, handler, ...)
	local i;
	for i=1, STTimer.PendingEvents.n, 1 do
		if (STTimer.PendingEvents[i].name and STTimer.PendingEvents[i].name == name) then
			table.remove(STTimer.PendingEvents, i);
			break;
		end
	end
	local newEvent = {};
	newEvent.time = (GetTime() + delay);
	newEvent.handler = handler
	newEvent.name = name;
	newEvent.args = arg;

	local i = 1;
	while(STTimer.PendingEvents[i] and STTimer.PendingEvents[i].time < newEvent.time) do
		i = i + 1;
	end
	table.insert(STTimer.PendingEvents, i, newEvent);
end

function STTimer_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");

	STTimer = {};
	STTimer.Initialized = false;
	STTimer.PendingEvents = {};
	STTimer.PendingEvents.n = 0;
end

function STTimer_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		STTimer_Initialize();
	end
end

function STTimer_Initialize()
	STTimer.Initializing = true;
	if (UnitName("player") and UnitName("player") ~= "Unknown Being") then
		STTimer.Initialized = true;
	else
		STTimer_AddEvent(0.2, STTimer_Initialize);
	end
end

function STTimer_OnUpdate()
	while (STTimer.PendingEvents[1] and STTimer.PendingEvents[1].time <= GetTime()) do
		if (not STTimer.Initialized) then
			STTimer_Initialize();
			return;
		end
		
		local curEvent = table.remove(STTimer.PendingEvents, 1);
		if (curEvent.args) then
			curEvent.handler(unpack(curEvent.args));
		else
			curEvent.handler();
		end
	end
end

-----------------------------------------------------------------------------------
--
-- Update the visibility of the party member's healthstone icons
--
-----------------------------------------------------------------------------------
function ShardTracker_UpdatePartyMemberHealthstoneIconVisibility()
	local healthStoneIcon = "";

    for i = 1, table.getn(ShardTracker_PartyMemberList) do
        partyNumber = ShardTracker_GetPartyMemberNumber(ShardTracker_PartyMemberList[i].name);
        if (MGParty_Frame) then
        	healthStoneIcon = getglobal("MGParty_Member"..partyNumber.."ShardTrackerIconMG");
        elseif (Perl_party1) then
        	ShardTrackerDebug("Perl");

        	--healthStoneIcon = getglobal("Perl_Party_MemberFrame"..partyNumber.."ShardTrackerIcon");
        	healthStoneIcon = getglobal("Perl_party"..partyNumber.."_NameFrameShardTrackerIcon");
        else
        	healthStoneIcon = getglobal("PartyMemberFrame"..partyNumber.."ShardTrackerIcon");
        end
        if (healthStoneIcon) then
            if (ShardTracker_PartyMemberList[i].hasHealthstone or ShardTracker_PartyMemberList[i].flashing) then
                healthStoneIcon:Show();
            else
                healthStoneIcon:Hide();
            end
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
        if (MGParty_Frame) then
        	healthStoneIcon = getglobal("MGParty_Member"..partyNumber.."ShardTrackerIconMG");
        elseif (Perl_party1) then
        	--healthStoneIcon = getglobal("Perl_Party_MemberFrame"..partyNumber.."ShardTrackerIcon");
        	healthStoneIcon = getglobal("Perl_party"..partyNumber.."_NameFrameShardTrackerIcon");
        	ShardTrackerDebug("Perl: ".."Perl_party"..partyNumber.."_NameFrameShardTrackerIcon");
        else
        	healthStoneIcon = getglobal("PartyMemberFrame"..partyNumber.."ShardTrackerIcon");
        end
        if (ShardTracker_PartyMemberList[i].flashing) then
            healthStoneIcon:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealthNotReady");
        else
            healthStoneIcon:SetNormalTexture("Interface\\AddOns\\ShardTracker\\Images\\ShardHealth");
        end
    end

end

-----------------------------------------------------------------------------------
--
-- Initialize the list of people in our party, mostly for when we crash and reload
-- directly back into our already existing party
--
-----------------------------------------------------------------------------------
function ShardTracker_InitializePartyHealthstoneIcons()

    local numberOfPartyMembers = GetNumPartyMembers();   
    local MatchGroup = 0;
    
	for i = 1,numberOfPartyMembers do
		if ShardTracker_PartyMemberList[i] then
			if ShardTracker_PartyMemberList[i].name == UnitName("party"..i) then
				MatchGroup = MatchGroup + 1;
			end
		end
	end
	if MatchGroup ~= numberOfPartyMembers then
		-- clear all the healthstone icons
	    ShardTracker_ClearPartyHealthstoneIcons();
	
	    -- for each party member, put them into the table
	    ShardTracker_PartyMemberList = { };
	    ShardTrackerDebug("Saw "..numberOfPartyMembers.." members in the party");
	    for i = 1, numberOfPartyMembers do
	        tempTable = { };
	        tempTable.name = UnitName("party"..i);
	        tempTable.hasHealthstone = false;
	        
	        -- we don't ever want to be pinging warlocks asking if they need a healthstone...
	        if (UnitClass("party"..i) == SHARDTRACKER_WARLOCK) then
	            tempTable.answeredPing = true;
	        else
	            tempTable.answeredPing = false;
	        end
	        tempTable.pingCount = 0;
	        tempTable.flashing = false;
	        table.insert(ShardTracker_PartyMemberList, tempTable);
	    end
	    SendSTChatMessage("UPDATE");
	else
		ShardTrackerDebug("Group didn't change, do nothing.");
	end
    
    
end

-----------------------------------------------------------------------------------
--
-- Hide all the healthstone icons for party members
--
-----------------------------------------------------------------------------------
function ShardTracker_ClearPartyHealthstoneIcons()

    for i = 1, 4 do
        local healthStoneIcon = getglobal("PartyMemberFrame"..i.."ShardTrackerIcon");
        if (healthStoneIcon) then
            healthStoneIcon:Hide();
        end
    end
end

-----------------------------------------------------------------------------------
--
-- Reset the party list
--
-----------------------------------------------------------------------------------
function ShardTracker_ResetPartyList()

    ShardTrackerTron("ResetPartyList");

    -- clear all the healthstone icons
    ShardTracker_ClearPartyHealthstoneIcons();

    -- clear the party list
    ShardTracker_PartyMemberList = { };
    
    ShardTrackerDebug("After reset, have "..table.getn(ShardTracker_PartyMemberList).." members in the partylist.");
end

function JoinSTChannel()
	-- Do not display RT messages
	ST_GroupLeader = ST_GetPartyLeader();
	if ST_GroupLeader then
		if SHARDTRACKER_CONFIG.CHANNEL_JOIN ~= false then
			JoinChannelByName((STCOMM_CHANNELPREFIX..ST_GroupLeader), nil, nil);
			ShardTrackerDebug("Join ST Channel: ST"..ST_GroupLeader);
		end
	else
		ChatFrame1:AddMessage("There is no group leader, no group healthstone status available.", 1.0, 1.0, 0.5);
	end
end

function RejoinSTChannel()
	LeaveAllSTChannels();
	STTimer_AddEvent(16.00, JoinSTChannel);
end

function LeaveSTChannel(GroupLeader)

	if GroupLeader then
		for i=1, 10 do
			local channelNumber, channelName = GetChannelName(i);
			if channelName then
				if channelName == STCOMM_CHANNELPREFIX..GroupLeader then
					ShardTrackerDebug("Leave ST Channel: "..GroupLeader);
					LeaveChannelByName(channelName);
				end
			end
		end
	else
		-- No Group leader
	end
end

function LeaveAllSTChannels()
	ShardTrackerDebug("Leave at ST Channels");
	LeaveSTChannel(ST_GroupLeader);
	for i=1, 10 do
		local channelNumber, channelName = GetChannelName(i);
		if channelName then
			if strsub(channelName, 1, strlen(STCOMM_CHANNELPREFIX)) == STCOMM_CHANNELPREFIX then
				LeaveChannelByName(channelName);
			end
		end
	end
end

function UpdateHealthstoneStatus()
	if (ShardTracker_PlayerClass == SHARDTRACKER_WARLOCK) then 
		ShardTracker_InitializePartyHealthstoneIcons();
	else
		if ShardTracker_HaveHealthStone == 1 then
			STTimer_AddEvent(10.0,SendSTChat_Yes);
		else
			STTimer_AddEvent(10.0,SendSTChat_No);
		end
	end
end

function ST_OnRTChatMessage()
	
	if (strsub(event, 1, 16) == "CHAT_MSG_CHANNEL" and (strsub(arg9, 1, strlen(STCOMM_CHANNELPREFIX)) == STCOMM_CHANNELPREFIX)) then
		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		
		ShardTrackerDebug("ST CHANNEL MESSAGE: "..type.." : "..arg2.." ("..arg1..")");
		
		--Update Healthstone
		if (type == "CHANNEL_NOTICE" and arg1 == "YOU_JOINED") then
			YesOnce = false;
			NoOnce = false;

			UpdateHealthstoneStatus();
						
		-- Self left handler
		elseif (type == "CHANNEL_NOTICE" and arg1 == "YOU_LEFT") then
			
		-- Other joined handler
		elseif (type == "CHANNEL_JOIN") then
			YesOnce = false;
			NoOnce = false;

			UpdateHealthstoneStatus();
			
		-- Other left handler
		elseif (type == "CHANNEL_LEAVE") then
			YesOnce = false;
			NoOnce = false;

			UpdateHealthstoneStatus();
			
		-- Chat message handler
		elseif (type == "CHANNEL") then
			if (UnitClass("player") == SHARDTRACKER_WARLOCK) then
				local PartNum = ShardTracker_GetPartyMemberNumber(arg2);
				if PartNum ~= 0 then
					ShardTrackerDebug("MESSAGE IN: "..arg1.." : "..arg2.." ("..PartNum..")");
					if arg1 == "YES" then
						LastMessageFrom = arg2;
						LastMessageArg = arg1;
						
						ShardTracker_PartyMemberList[PartNum].hasHealthstone = true;
						ShardTracker_PartyMemberList[PartNum].flashing = false;
						ShardTracker_UpdatePartyMemberHealthstoneIconVisibility();
					    ShardTracker_UpdatePartyMemberHealthstoneIconFlashing();
					elseif arg1 == "NO" then
						if ( LastMessageFrom == arg2 and LastMessageArg == arg1 ) then
							--Seen this message already, ignore it
						else
							if arg2 ~= nil then
								ChatFrame1:AddMessage(arg2..SHARDTRACKER_NEEDHEALTHSTONE, 1.0, 1.0, 1.0);
								UIErrorsFrame:AddMessage(arg2..SHARDTRACKER_NEEDHEALTHSTONE, 0.92, 0.75, 0.05, 1.0, 12);
								if (ShardTracker_PartyMemberList[PartNum].hasHealthstone == true) then
									-- Only play the sound once when the healthstone is used
									-- Re[eating the text is fine, no need to beep lots though
									if (SHARDTRACKER_CONFIG.USE_SOUND ~= false) then
										PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\Healthstone.mp3");
									end
								end
								LastMessageFrom = arg2;
								LastMessageArg = arg1;
								
								ShardTracker_PartyMemberList[PartNum].hasHealthstone = false;
								ShardTracker_PartyMemberList[PartNum].flashing = true;
							    ShardTracker_UpdatePartyMemberHealthstoneIconVisibility();
							    ShardTracker_UpdatePartyMemberHealthstoneIconFlashing();
							end
						end
					else
						-- Someone can see the channel and is typing in it
					end
				end
			else
				if arg1 == "UPDATE" then
					YesOnce = false;
					NoOnce = false;
		
					UpdateHealthstoneStatus();
				end
			end
		end
	elseif event == "CHAT_MSG_WHISPER" then
		local PartNum = ShardTracker_GetPartyMemberNumber(arg2);
		if PartNum ~= 0 then
			if arg1 == SHARDTRACKER_CHAT_PREFIX..arg2.." "..SHARDTRACKER_GOT_HEALTHSTONE_MSG then
				-- Have a shard
				-- Have to do this straight away and not wait for 
				ShardTracker_InitializePartyHealthstoneIcons();
				ShardTracker_PartyMemberList[PartNum].hasHealthstone = true;
				ShardTracker_PartyMemberList[PartNum].flashing = false;

				ShardTracker_UpdatePartyMemberHealthstoneIconVisibility();
		    	ShardTracker_UpdatePartyMemberHealthstoneIconFlashing();
			elseif arg1 == SHARDTRACKER_CHAT_PREFIX..arg2.." "..SHARDTRACKER_NEED_HEALTHSTONE_MSG then
				-- No shard
				ChatFrame1:AddMessage(arg2..SHARDTRACKER_NEEDHEALTHSTONE, 1.0, 1.0, 1.0);
				ShardTracker_PartyMemberList[PartNum].hasHealthstone = false;
				ShardTracker_PartyMemberList[PartNum].flashing = true;
					    
				ShardTracker_UpdatePartyMemberHealthstoneIconVisibility();
		    	ShardTracker_UpdatePartyMemberHealthstoneIconFlashing();
			end
        end
	end
	Pre_ST_OnRTChatMessage(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
end

function GetSTChannelIndex()
	return (ParseSTChannels(true, GetChannelList()));
end

function ParseSTChannels(useIndex, ...)
	for i=1, arg.n do
		if (strsub(arg[i], 1, strlen(STCOMM_CHANNELPREFIX)) == STCOMM_CHANNELPREFIX) then
			if (useIndex) then
				return (arg[i-1]);
			else
				return (arg[i]);
			end
		end
	end
	return nil;
end

function ST_GetPartyLeader()
	
	if GetNumRaidMembers() > 0 then
    	local numRTMembers = GetNumRaidMembers();
    	local name, rank, subgroup, level, class, fileName, zone, online ;

    	for i=1, numRTMembers do
    		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if ( rank == 2 ) then
				return name;
			end
   		end
    else
		local leaderIndex = GetPartyLeaderIndex();
		if (leaderIndex == 0 or not GetPartyMember(leaderIndex)) then
			return UnitName("player");
		else
			return UnitName("party"..leaderIndex);
		end
	end
end

function SendSTChat_Yes()
	if YesOnce == false then 
		SendSTChatMessage("YES");
		YesOnce = true;
		NoOnce = false;
	end
end

function SendSTChat_No()
	if NoOnce == false then 
		SendSTChatMessage("NO");
		NoOnce = true;
		YesOnce = false;
	end
end

function SendSTChatMessage(message)
	index = GetSTChannelIndex();
	if (index and index > 0) then
		if (LastSendTime + 1.00 > GetTime()) then
		else
			if SHARDTRACKER_CONFIG.CHANNEL_JOIN ~= false then
				SendChatMessage(message, "CHANNEL", nil, index);
				LastSendTime = GetTime();
				ShardTrackerDebug("SENDING Healthsone Status: "..message.." to channel; "..index);
			end
		end
	end
end

function ST_Cast(spellName)
	local spellID = nil;

    if spellName == "Summon Imp" then
    	spellID = ShardTracker_SummounImpSpellID;
    elseif spellName == "Summon Voidwalker" then
    	spellID = ShardTracker_SummounVoidwalkerSpellID;
    elseif spellName == "Summon Succubus" then
    	spellID = ShardTracker_SummounSuccubusSpellID;
    elseif spellName == "Summon Felhunter" then
   		spellID = ShardTracker_SummounFelhunterSpellID;
	elseif spellName == "Inferno" then
	    spellID = ShardTracker_SummounInfernalSpellID;
	elseif spellName == "Curse of Doom" then
		spellID = ShardTracker_CurseOfDoomSpellID;
	elseif spellName == "Ritual of Doom" then
		spellID = ShardTracker_RitualOfDoomSpellID;
	elseif spellName == "Enslave Demon" then
		spellID = ShardTracker_EnslaveDemonSpellID;
	elseif spellName == "Curse of Shadow" then
		spellID = ShardTracker_CurseOfShadowSpellID;
	elseif spellName == "Fel Domination" then
		spellID = ShardTracker_FelDominationSpellID;
	elseif spellName == "Eye of Kilrog" then
		spellID = ShardTracker_EyeofKilrogSpellID;
	elseif spellName == "Ritual of Summoning" then
		spellID = ShardTracker_RitualofSummoningSpellID;
    end
    
    if spellID ~= nil then
		CastSpell(spellID, "spell");
	end
	SummonerVisible = false;
end

function CastBuff()
	CastSpell(ShardTracker_DemonBuffSpellID, "spell");
end

function SoulstoneMessage()
	local CheckSoulstoneSlot = ShardTracker_GetItemNameInBagSlot(ShardTracker_SoulstoneLoc[1], ShardTracker_SoulstoneLoc[2], true);
	-- if the item has a name
	if (CheckSoulstoneSlot == "" or CheckSoulstoneSlot == nil) then
		SoulstoneText();
		ShardTracker_StartSoulstoneTimer();
	else
		if (string.find(CheckSoulstoneSlot, SHARDTRACKER_SOULSTONE, 1, TRUE) ~= nil) then
			local bag,slot = ShardTrackerFindItemBagSlotByName(CheckSoulstoneSlot);
			if bag ~= nil and slot ~= nil then
				ChatFrame1:AddMessage("Failed to use soulstone", 1.0, 1.0, 0.5);
				ShardTrackerDebug("Soulstone fail: "..CheckSoulstoneSlot.." "..bag..","..slot);
			else
				SoulstoneText();
				ShardTracker_StartSoulstoneTimer();
				ShardTrackerDebug("Soulstone found, but couldn't be located in a bag, so it was used.");
			end
		else
			SoulstoneText();
			ShardTracker_StartSoulstoneTimer();
		end
	end
	ShardTracker_SpellTargetName = "";
	ShardTracker_Casting = nil;
end

function SoulstoneText()
	if ShardTracker_SoulstoneTargetName ~= "" then
		if SHARDTRACKER_CONFIG.SHOW_SOUL ~= false then
	    	if GetNumRaidMembers() > 0 then
    			if SHARDTRACKER_CONFIG.USE_SOULMESSAGE == true then
					SendChatMessage(ShardTracker_SoulstoneTargetName.." "..SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE, "RAID");
				else
					SendChatMessage(ShardTracker_SoulstoneTargetName.." "..SHARDTRACKER_TARGETSOULSTONED, "RAID");
				end
	    	elseif GetNumPartyMembers() > 0 then
	    	    if SHARDTRACKER_CONFIG.USE_SOULMESSAGE == true then
					SendChatMessage(ShardTracker_SoulstoneTargetName.." "..SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE, "PARTY");
				else
					SendChatMessage(ShardTracker_SoulstoneTargetName.." "..SHARDTRACKER_TARGETSOULSTONED, "PARTY");
				end
			end
		end
	elseif UnitName("target") then
		if SHARDTRACKER_CONFIG.SHOW_SOUL ~= false then
	    	if GetNumRaidMembers() > 0 then
    			if SHARDTRACKER_CONFIG.USE_SOULMESSAGE == true then
					SendChatMessage(ShardTracker_SpellTargetName.." "..SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE, "RAID");
				else
					SendChatMessage(ShardTracker_SpellTargetName.." "..SHARDTRACKER_TARGETSOULSTONED, "RAID");
				end
	    	elseif GetNumPartyMembers() > 0 then
	    	    if SHARDTRACKER_CONFIG.USE_SOULMESSAGE == true then
					SendChatMessage(ShardTracker_SpellTargetName.." "..SHARDTRACKER_CONFIG.CUSTOM_SOULMESSAGE, "PARTY");
				else
					SendChatMessage(ShardTracker_SpellTargetName.." "..SHARDTRACKER_TARGETSOULSTONED, "PARTY");
				end
			end
		end
	else
		ChatFrame1:AddMessage("Soulstone cast, ST lost track of who it was cast on", 1.0, 1.0, 0.5);
	end
end

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              INTERFACE FUNCTIONS                                           --
--                                                                                            --
--============================================================================================--
--============================================================================================--

---------------------------------------------------------------------------------
--
-- Start dragging the shard button
-- 
---------------------------------------------------------------------------------
function ShardTracker_OnDragStart()
    if (not ShardTracker_DragLock and not ShardTracker_BeingDragged) then
        this:StartMoving();
        ShardTracker_BeingDragged = true;
    else
        ChatFrame1:AddMessage(SHARDTRACKER_DRAGERROR, 1.0, 1.0, 0.5);
    end
end

---------------------------------------------------------------------------------
--
-- Stop dragging the shard button
-- 
---------------------------------------------------------------------------------
function ShardTracker_OnDragStop()
    if (ShardTracker_BeingDragged) then
        this:StopMovingOrSizing()
        ShardTracker_BeingDragged = false;
        local x,y = this:GetCenter();
        local px, py = this:GetParent():GetCenter();
        local ox, oy = ShardTracker_CalcOffsetGivenScaledCoords(this:GetName(), x, y);
        ShardTrackerDebug(" Name = "..this:GetName().."  ParentName = "..this:GetParent():GetName());
        ShardTrackerDebug("   ShardTrackerMinimapButton:GetParent():GetName() = "..this:GetParent():GetName());
        ShardTrackerDebug("   Center        : x = "..x.." y = "..y);
        ShardTrackerDebug("   Parent Center : px = "..px.." py = "..py);
        ShardTrackerDebug("   Offset        : ox = "..ox.." oy = "..oy);
        ShardTracker_StoreButtonLocation(this:GetName(), ox, oy);
    end
end

---------------------------------------------------------------------------------
--
-- Toggle the lock / unlock status of the interface
-- 
---------------------------------------------------------------------------------
function ShardTracker_ToggleLockedForDragging(theCommand)
    if (theCommand == "lock") then
        ShardTracker_DragLock = true;
        STTimerButton:Hide();
        if TimerOnBeforeUnlock == true then
        	SHARDTRACKER_CONFIG.SHOW_TIMER = true;
        end
        ST_Time_TextLarge:SetText("");
        ST_Time_TextSmall:SetText("");
        ST_Time_Text:SetText("");
		ChatFrame1:AddMessage("Shardtracker buttons locked", 1.0, 1.0, 0.5);
    elseif (theCommand == "unlock") then
        ShardTracker_DragLock = false;
        STTimerButton:Show();
        TimerOnBeforeUnlock = false;
        if SHARDTRACKER_CONFIG.SHOW_TIMER == true then
        	SHARDTRACKER_CONFIG.SHOW_TIMER = false;
        	TimerOnBeforeUnlock = true;
        end
       	if SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE == "Large" then
	    	ST_Time_TextLarge:SetText("xx:xx - Spell Name -> Target Name\nxx:xx - Spell Name -> Target Name");
	    elseif SHARDTRACKER_CONFIG.SHOW_TIMER_SIZE == "Small" then
	    	ST_Time_TextSmall:SetText("xx:xx - Spell Name -> Target Name\nxx:xx - Spell Name -> Target Name");
	    else
	    	ST_Time_Text:SetText("xx:xx - Spell Name -> Target Name\nxx:xx - Spell Name -> Target Name");
	    end
        ChatFrame1:AddMessage("Shardtracker buttons unlocked", 1.0, 1.0, 0.5);
    end
end

---------------------------------------------------------------------------------
--
-- Store the location of the specified button, relative to its parent in the XML
-- 
---------------------------------------------------------------------------------
function ShardTracker_StoreButtonLocation(buttonName, ox, oy)

    local scaleFactor = SHARDTRACKER_CONFIG.UI_SCALE;

    if scaleFactor then
    	scaleFactor = 1;
    end
    
    ox = ox / (scaleFactor);
    oy = oy / (scaleFactor);
    
    if (buttonName == "ShardTrackerMinimapButton") then
        SHARDTRACKER_CONFIG.SHARDBUTTONX = ox;
        SHARDTRACKER_CONFIG.SHARDBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonHealth") then
        SHARDTRACKER_CONFIG.HEALTHBUTTONX = ox;
        SHARDTRACKER_CONFIG.HEALTHBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonSoul") then
        SHARDTRACKER_CONFIG.SOULBUTTONX = ox;
        SHARDTRACKER_CONFIG.SOULBUTTONY = oy;
    elseif (buttonName == "ShardTrackerMinimapButtonSpell") then
        SHARDTRACKER_CONFIG.SPELLBUTTONX = ox;
        SHARDTRACKER_CONFIG.SPELLBUTTONY = oy;
    elseif (buttonName == "STTimerButton") then
        SHARDTRACKER_CONFIG.TIMERBUTTONX = ox;
        SHARDTRACKER_CONFIG.TIMERBUTTONY = oy;
    end    
end

---------------------------------------------------------------------------------
--
-- Calculate the offset of the button based on its scale
-- 
---------------------------------------------------------------------------------
function ShardTracker_CalcOffsetGivenScaledCoords(theElement, x, y)
    scaleFactor = SHARDTRACKER_CONFIG.UI_SCALE;
    
    if scaleFactor then
    	scaleFactor = 1;
    end

    x = x * scaleFactor / 1;
    y = y * scaleFactor / 1;
    px, py = getglobal(theElement):GetParent():GetCenter();
    xoffset = x - px;
    yoffset = y - py;
    return xoffset, yoffset;    
end

---------------------------------------------------------------------------------
--
-- Move the interface buttons to the stored locations
-- 
---------------------------------------------------------------------------------
function ShardTracker_ButtonSetLocation()

    ShardTrackerMinimapButton:ClearAllPoints();
    ShardTrackerMinimapButtonHealth:ClearAllPoints();
    ShardTrackerMinimapButtonSoul:ClearAllPoints();
    ShardTrackerMinimapButtonSpell:ClearAllPoints();
    STTimerButton:ClearAllPoints();

    if(SHARDTRACKER_CONFIG.SHARDBUTTONX == nil) then
    	ShardTracker_ResetButtonLocations();
    end
    ShardTrackerDebug("Setting Shard Button Location:  x = "..SHARDTRACKER_CONFIG.SHARDBUTTONX.."  y = "..SHARDTRACKER_CONFIG.SHARDBUTTONY);
    local px, py = ShardTrackerMinimapButton:GetParent():GetCenter();
    ShardTrackerMinimapButton:SetPoint("CENTER", ShardTrackerMinimapButton:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.SHARDBUTTONX, SHARDTRACKER_CONFIG.SHARDBUTTONY);
    ShardTrackerMinimapButtonHealth:SetPoint("CENTER", ShardTrackerMinimapButtonHealth:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.HEALTHBUTTONX, SHARDTRACKER_CONFIG.HEALTHBUTTONY);
    ShardTrackerMinimapButtonSoul:SetPoint("CENTER", ShardTrackerMinimapButtonSoul:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.SOULBUTTONX, SHARDTRACKER_CONFIG.SOULBUTTONY);
    ShardTrackerMinimapButtonSpell:SetPoint("CENTER", ShardTrackerMinimapButtonSpell:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.SPELLBUTTONX, SHARDTRACKER_CONFIG.SPELLBUTTONY);
    STTimerButton:SetPoint("CENTER", STTimerButton:GetParent():GetName(), "CENTER", SHARDTRACKER_CONFIG.TIMERBUTTONX, SHARDTRACKER_CONFIG.TIMERBUTTONY);
end

---------------------------------------------------------------------------------
--
-- Move the interface buttons back to their default locations
-- 
---------------------------------------------------------------------------------
function ShardTracker_ResetButtonLocations(centerButtons)

    local scaleFactor = SHARDTRACKER_CONFIG.UI_SCALE;
    
    if scaleFactor then
    	scaleFactor = 1;
    end

    ChatFrame1:AddMessage("Shardtracker button locations reset", 1.0, 1.0, 0.5);
    SHARDTRACKER_CONFIG.SHARDBUTTONX                = SHARDTRACKER_ORIG_SHARDBUTTONX / scaleFactor;    
    SHARDTRACKER_CONFIG.SHARDBUTTONY                = SHARDTRACKER_ORIG_SHARDBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.HEALTHBUTTONX               = SHARDTRACKER_ORIG_HEALTHBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.HEALTHBUTTONY               = SHARDTRACKER_ORIG_HEALTHBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.SOULBUTTONX                 = SHARDTRACKER_ORIG_SOULBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.SOULBUTTONY                 = SHARDTRACKER_ORIG_SOULBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.SPELLBUTTONX                = SHARDTRACKER_ORIG_SPELLBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.SPELLBUTTONY                = SHARDTRACKER_ORIG_SPELLBUTTONY / scaleFactor;
    SHARDTRACKER_CONFIG.TIMERBUTTONX                = SHARDTRACKER_ORIG_TIMERBUTTONX / scaleFactor;
    SHARDTRACKER_CONFIG.TIMERBUTTONY                = SHARDTRACKER_ORIG_TIMERBUTTONY / scaleFactor;
    ShardTracker_ButtonSetLocation();
end

function ClearTimer()
	for index=1, table.getn(SpellTimer.Name), 1 do
		-- Don't clear timers for banish, infernal or enslave demon, due to tnese spells being 
		-- active even when not in combat
		if (SpellTimer.Name[index] ~= SHARDTRACKER_BANISH and SpellTimer.Name[index] ~= SHARDTRACKER_ENSLAVEDEMON and SpellTimer.Name[index] ~= SHARDTRACKER_INFERNO)then
			table.remove(SpellTimer.Name, index);
			table.remove(SpellTimer.SName, index);
			table.remove(SpellTimer.Target, index);
			table.remove(SpellTimer.Time, index);
			table.remove(SpellTimer.TimeMax, index);
		end
	end

end

function AddTimer()
	local Exists = false;
	local SpellListName = "";
	
	if (SpellList[ShardTracker_Casting] ~= nil) then
		for index=1, table.getn(SpellTimer.Name), 1 do
			if (SpellTimer.Name[index] == ShardTracker_Casting and SpellTimer.Target[index] == ShardTracker_SpellTargetName) then
				SpellTimer.Time[index] = SpellList[ShardTracker_Casting].Time;
				Exists = true;
				break;
			end
		end
		
		if ShardTracker_ChangedTarget == false and Exists == false then
			for index=1, table.getn(SpellTimer.Name), 1 do
				if SpellTimer.Name[index] then 
					if string.find(ShardTracker_Casting, SHARDTRACKER_CURSE, 1, TRUE) ~= nil then
						if ( string.find(SpellTimer.Name[index], SHARDTRACKER_CURSE, 1, TRUE) ~= nil and SpellTimer.Target[index] == ShardTracker_SpellTargetName ) then
							table.remove(SpellTimer.Name, index);
							table.remove(SpellTimer.SName, index);
							table.remove(SpellTimer.Target, index);
							table.remove(SpellTimer.Time, index);
							table.remove(SpellTimer.TimeMax, index);
						end
					end
				end
			end
		end
		
		if Exists == false then
			ShardTrackerDebug("ST: Add Timer: "..ShardTracker_Casting..":"..ShardTracker_SpellTargetName);
			table.insert(SpellTimer.Name, ShardTracker_Casting);
			table.insert(SpellTimer.SName, SpellList[ShardTracker_Casting].SName);
			table.insert(SpellTimer.Target, ShardTracker_SpellTargetName);
			table.insert(SpellTimer.Time, SpellList[ShardTracker_Casting].Time);
			table.insert(SpellTimer.TimeMax, SpellList[ShardTracker_Casting].Time);
		end
	end
end

function RemoveTimer()
	ShardTrackerDebug("ST: Remove Timer: "..ShardTracker_Casting..":"..ShardTracker_SpellTargetName);
	for index=1, table.getn(SpellTimer.Name), 1 do
		if (SpellTimer.Name[index] == ShardTracker_Casting and SpellTimer.Target[index] == ShardTracker_SpellTargetName) then
			table.remove(SpellTimer.Name, index);
			table.remove(SpellTimer.SName, index);
			table.remove(SpellTimer.Target, index);
			table.remove(SpellTimer.Time, index);
			table.remove(SpellTimer.TimeMax, index);
		end
	end
end

function RemoveTimerAny(SpellName) 
	for index=1, table.getn(SpellTimer.Name), 1 do
		if (SpellTimer.Name[index] == SpellName) then
			table.remove(SpellTimer.Name, index);
			table.remove(SpellTimer.SName, index);
			table.remove(SpellTimer.Target, index);
			table.remove(SpellTimer.Time, index);
			table.remove(SpellTimer.TimeMax, index);
			if (SpellName == SHARDTRACKER_ENSLAVEDEMON) then
				if (SHARDTRACKER_CONFIG.USE_SOUND ~= false) then
					PlaySoundFile("Interface\\AddOns\\ShardTracker\\Sounds\\EnslaveBroke.mp3");
				end
			end
		end
	end
end

------------------------------------
-- Hook Function : Taken from Sea --
------------------------------------
ST_Hook = function (orig,new,type)
	if(not type) then type = "before"; end
	if(not Hx_Hooks) then Hx_Hooks = {}; end
	if(not Hx_Hooks[orig]) then
		Hx_Hooks[orig] = {}; Hx_Hooks[orig].before = {}; Hx_Hooks[orig].before.n = 0; Hx_Hooks[orig].after = {}; Hx_Hooks[orig].after.n = 0; Hx_Hooks[orig].hide = {}; Hx_Hooks[orig].hide.n = 0; Hx_Hooks[orig].replace = {}; Hx_Hooks[orig].replace.n = 0; Hx_Hooks[orig].orig = getglobal(orig);
	else
		for key,value in Hx_Hooks[orig][type] do if(value == getglobal(new)) then return; end end
	end
	ST_Push(Hx_Hooks[orig][type],getglobal(new)); setglobal(orig,function(...) ST_hookHandler(orig,arg); end);
end

ST_hookHandler = function (name,arg)
	local called = false; local continue = true; local retval;
	for key,value in Hx_Hooks[name].hide do
		if(type(value) == "function") then if(not value(unpack(arg))) then continue = false; end called = true; end
	end
	if(not continue) then return; end
	for key,value in Hx_Hooks[name].before do
		if(type(value) == "function") then value(unpack(arg)); called = true; end
	end
	continue = false;
	local replacedFunction = false;
	for key,value in Hx_Hooks[name].replace do
		if(type(value) == "function") then
			replacedFunction = true; if(value(unpack(arg))) then continue = true; end called = true;
		end
	end
	if(continue or (not replacedFunction)) then retval = Hx_Hooks[name].orig(unpack(arg)); end
	for key,value in Hx_Hooks[name].after do
		if(type(value) == "function") then value(unpack(arg)); called = true;end
	end
	if(not called) then setglobal(name,Hx_Hooks[name].orig); Hx_Hooks[name] = nil; end
	return retval;
end

function ST_Push (table,val)
	if(not table or not table.n) then return nil; end	--if table or table's number of elements = nil return nil;
	table.n = table.n+1;					--Add one to the tables elements
	table[table.n] = val;					--Add the new val to the table
end

function ST_CastSpell(id, book) 
	local spell, rank = GetSpellName(id,book); 
	ShardTrackerDebug("ST: Hook CastSpell : "..spell.."("..rank..")");
	ShardTracker_Casting = spell;
	ShardTracker_SpellTargetName = UnitName("target");
	if ShardTracker_SpellTargetName then
	else
		ShardTracker_SpellTargetName = "";
	end
end

function ST_UseAction(id, number, onSelf)
	ShardTrackerTooltip:SetAction(id);				--set our tooltip equal to the spell being cast
	local tip = easyscan("ShardTrackerTooltip");	--sets tip equal to the parts of the tooltip
	if (tip and tip[1] and tip[1]["left"]) then		--Check for nil values in the spell name
		ShardTracker_Casting = tip[1]["left"];		--Set SName(Global) from the tooltip 
		ShardTracker_SpellTargetName = UnitName("target");
		if ShardTracker_SpellTargetName then
		else
			ShardTracker_SpellTargetName = "";
		end
		ShardTrackerDebug("ST: Hook UseAction: "..ShardTracker_Casting..">"..ShardTracker_SpellTargetName);
	end
end

function CheckBuff(BuffNameToCheck) 
    local BuffCount = 1;
	while UnitBuff("player", BuffCount) do
	   	ShardTracker_MoneyToggle();
	   	ShardTrackerTooltip:SetUnitBuff("player", BuffCount);
		local buffName = easyscan("ShardTrackerTooltip");
		buffName = buffName[1]["left"]
        ShardTracker_MoneyToggle();
        
		if (buffName == BuffNameToCheck) then
			return true;
		end
		BuffCount = BuffCount + 1;
	end
	return false;
end