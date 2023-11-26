--[[

    Wardrobe

    By Cragganmore
    Based on "Tackle Box" by Mugendai and "BCUI Tracking Menu" by Kugnar

    Wardrobe lets you define up to 20 distinct equipment profiles 
    (called "outfits") and lets you switch among them on the fly.  
    For example, you can define a Normal Outfit that consists of 
    your regular equipment, an Around Town Outfit that consists of 
    what you'd like to wear when inside a city or roleplaying, a 
    Stamina Outfit that consists of all your best +stam gear, etc.  
    You can then switch amongst these outfits using a simple slash chat 
    command (/wardrobe wear Around Town Outfit), or using a small 
    interactive button docked beneath your radar.

   ]]--

ULTIMATEUI_CONFIG_SEP		= "Interface Settings";
ULTIMATEUI_CONFIG_SEP_INFO		= "These settings allow you to adjust the transparency of the chat window and the size of certain UI components.";
   
   
WARDROBE_VERSION                    = "1.21";
WARDROBE_DEBUG                      = false;
WARDROBE_NUM_OUTFITS                = 20;
WARDROBE_NUM_POPUP_FUNCTION_BUTTONS = 1;
WARDROBE_UNMOUNT_OUTFIT_NAME        = "#unmount#";
WARDROBE_UNPLAGUE_OUTFIT_NAME       = "#unplague#";
WARDROBE_DONEEATING_OUTFIT_NAME     = "#doneeating#";
WARDROBE_TEMP_OUTFIT_NAME           = "#temp#";
WARDROBE_MAX_SCROLL_ENTRIES         = 9;
WARDROBE_MOUNT_EQUIP_DELAY          = 0.5;
WARDROBE_PLAGUEZONES                = {WARDROBE_TXT_WPLAGUELANDS, WARDROBE_TXT_EPLAGUELANDS, 
                                       WARDROBE_TXT_STRATHOLME, WARDROBE_TXT_SCHOLOMANCE};


WARDROBE_TEXTCOLORS = { {1.00, 0.00, 0.00},    -- red
                        {1.00, 0.50, 0.50},    -- light red
                        {1.00, 0.50, 0.00},    -- orange
                        {1.00, 0.75, 0.50},    -- light orange
                        {1.00, 0.75, 0.00},    -- gold
                        {1.00, 0.87, 0.50},    -- light gold

                        {1.00, 1.00, 0.00},    -- yellow
                        {1.00, 1.00, 0.50},    -- light yellow
                        {0.50, 1.00, 0.00},    -- yellow-green
                        {0.75, 1.00, 0.50},    -- light yellow-green
                        {0.00, 1.00, 0.00},    -- green
                        {0.50, 1.00, 0.50},    -- light green

                        {0.00, 1.00, 0.50},    -- blue-green
                        {0.50, 1.00, 0.75},    -- light blue-green
                        {0.00, 1.00, 1.00},    -- cyan
                        {0.50, 1.00, 1.00},    -- light cyan
                        {0.00, 0.00, 1.00},    -- blue
                        {0.50, 0.50, 1.00},    -- light blue

                        {0.50, 0.00, 1.00},    -- blue-purple
                        {0.75, 0.50, 1.00},    -- light blue-purple
                        {1.00, 0.00, 1.00},    -- purple
                        {1.00, 0.50, 1.00},    -- light purple
                        {1.00, 0.00, 0.50},    -- pink-red
                        {1.00, 0.50, 0.75}     -- light pink-red
                      };
                      
WARDROBE_DRABCOLORS = { {0.50, 0.00, 0.00},    -- red
                        {0.50, 0.25, 0.25},    -- light red
                        {0.50, 0.25, 0.00},    -- orange
                        {0.50, 0.38, 0.25},    -- light orange
                        {0.50, 0.38, 0.00},    -- gold
                        {0.50, 0.43, 0.25},    -- light gold

                        {0.50, 0.50, 0.00},    -- yellow
                        {0.50, 0.50, 0.25},    -- light yellow
                        {0.25, 0.50, 0.00},    -- yellow-green
                        {0.38, 0.50, 0.25},    -- light yellow-green
                        {0.00, 0.50, 0.00},    -- green
                        {0.25, 0.50, 0.25},    -- light green

                        {0.00, 0.50, 0.25},    -- blue-green
                        {0.25, 0.50, 0.38},    -- light blue-green
                        {0.00, 0.50, 0.50},    -- cyan
                        {0.25, 0.50, 0.50},    -- light cyan
                        {0.00, 0.00, 0.50},    -- blue
                        {0.25, 0.25, 0.50},    -- light blue

                        {0.25, 0.00, 0.50},    -- blue-purple
                        {0.38, 0.25, 0.50},    -- light blue-purple
                        {0.50, 0.00, 0.50},    -- purple
                        {0.50, 0.25, 0.50},    -- light purple
                        {0.50, 0.00, 0.25},    -- pink-red
                        {0.50, 0.25, 0.38},    -- light pink-red
                      };
                      
WARDROBE_DEFAULT_BUTTON_COLOR = 11;  -- corresponds to the entry in WARDROBE_TEXTCOLORS (in this case, #11 is green)
WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY = 0.001;
                  
Wardrobe_InventorySlots = {"HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","ShirtSlot",
                           "TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot","FeetSlot",
                           "Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot","MainHandSlot",
                           "SecondaryHandSlot","RangedSlot"};

-- the variable that stores all the wardrobe info
-- and gets saved when you quit the game
Wardrobe_Config                         = {};
Wardrobe_Config.Enabled                 = false;
Wardrobe_Config.xOffset                 = 10;
Wardrobe_Config.yOffset                 = 39;
Wardrobe_Config.DefaultCheckboxState    = 1;       -- default state for the checkboxes when specifying what equipment slots make up an outfit on the character paperdoll screen
Wardrobe_Config.MustClickUIButton       = false;   -- default state for the checkboxes when specifying what equipment slots make up an outfit on the character paperdoll screen

Wardrobe_Current_Outfit                 = 0;
Wardrobe_AlreadySetCharactersWardrobeID = false;    -- set this to true once we've looked up this character's wardrobe info
Wardrobe_PopupFunction                  = "";       -- tells the popup confirmation box what it's confirming (deleting an outfit, adding one, etc)
WARDROBE_POPUP_TITLE                    = "";       -- the title of the popup confirmation box
Wardrobe_Rename_OldName                 = "";       -- remembers original outfit name in case we cancel a rename
Wardrobe_BeingDragged                   = false;    -- flag for dragging the wardrobe UI button
Wardrobe_DragLock                       = false;    -- true if we're not allowed to drag the wardrobe UI button
Wardrobe_InCombat                       = false;    -- true if we're in combat
Wardrobe_RegenEnabled                   = true;     -- true if we can't regen (usually means we're in combat)
Wardrobe_ShowingCharacterPanel          = false;    -- true if the character paperdoll frame is visible
Wardrobe_PressedAcceptButton            = false;    -- remembers if we pressed the accept button in case the character paperdoll frame closes via other means
Wardrobe_MountState                     = false;    -- tracks whether we're mounted or not
Wardrobe_ChowingState                   = false;    -- tracks whether we're in the process of eating / drinking
Wardrobe_MoneyProtected                 = false;    -- remembers the state of the tooltip money protection status
Wardrobe_WaitingList                    = { };

--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              INITIALIZATION FUNCTIONS                                      --
--                                                                                            --
--============================================================================================--
--============================================================================================--


---------------------------------------------------------------------------------
-- Stuff done when the plugin first loads
---------------------------------------------------------------------------------
function Wardrobe_OnLoad()  

    -- watch our bags and update our wardrobe availability
    this:RegisterEvent("BAG_UPDATE");
    this:RegisterEvent("UNIT_INVENTORY_CHANGED");
    this:RegisterEvent("PLAYER_REGEN_DISABLED");
    this:RegisterEvent("PLAYER_REGEN_ENABLED");
    this:RegisterEvent("PLAYER_ENTER_COMBAT");
    this:RegisterEvent("PLAYER_LEAVE_COMBAT");
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PLAYER_AURAS_CHANGED");
    this:RegisterEvent("ZONE_CHANGED_NEW_AREA");

    Wardrobe_RegisterUltimateUI();
    
end


---------------------------------------------------------------------------------
-- Register with UltimateUI UI
---------------------------------------------------------------------------------
function Wardrobe_RegisterUltimateUI()

    SlashCmdList["WARDROBESLASH"] = Wardrobe_ChatCommandHandler;
    SLASH_WARDROBESLASH1 = "/wardrobe";
    SLASH_WARDROBESLASH2 = "/wd";
    
--[[]]--
    if (UltimateUI_RegisterConfiguration) then 

		UltimateUI_RegisterConfiguration(
			"UUI_COS",
			"SECTION",
			TEXT(ULTIMATEUI_CONFIG_SEP),
			TEXT(ULTIMATEUI_CONFIG_SEP_INFO)
		);
        UltimateUI_RegisterConfiguration(
            "UUI_WARDROBE_HEADER",
            "SEPARATOR",
            WARDROBE_CONFIG_HEADER,
            WARDROBE_CONFIG_HEADER_INFO
        );
        UltimateUI_RegisterConfiguration(
            "UUI_WARDROBE_ENABLED",
            "CHECKBOX",
            WARDROBE_CONFIG_ENABLED,
            WARDROBE_CONFIG_ENABLED_INFO,
            Wardrobe_Toggle,
            Wardrobe_Config.Enabled
        );

        local WardrobeCommands = {"/wardrobe","/wd"};
        UltimateUI_RegisterChatCommand (
            "WARDROBE_COMMANDS", -- Some Unique Group ID
            WardrobeCommands, -- The Commands
            Wardrobe_ChatCommandHandler,
            WARDROBE_CHAT_COMMAND_INFO -- Description String
        );
        
    -- if ULTIMATEUI isn't installed, create the slash commands
    else

    end
    
    -- makes sure we have a Print() command, just in
    -- case ULTIMATEUI isn't installed
    if(not Print) then
        function Print(msg, r, g, b, frame) 
            if (not r) then r = 1.0; end
            if (not g) then g = 1.0; end
            if (not b) then b = 1.0; end
            if ( frame ) then 
                frame:AddMessage(msg,r,g,b);
            else
                if ( DEFAULT_CHAT_FRAME ) then 
                    DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
                end
            end
        end
    end
end


---------------------------------------------------------------------------------
-- Event handler
---------------------------------------------------------------------------------
function Wardrobe_OnEvent(event)

    if (Wardrobe_Config.Enabled) then       
        if (event == "PLAYER_REGEN_DISABLED") then
            --Print("PLAYER_REGEN_DISABLED");
            Wardrobe_RegenEnabled = false;
        elseif (event == "PLAYER_REGEN_ENABLED") then
            --Print("PLAYER_REGEN_ENABLED");
            Wardrobe_RegenEnabled = true;
            if (not Wardrobe_IsPlayerInCombat()) then Chronos.schedule(1, Wardrobe_CheckWaitingList); end
        elseif (event == "PLAYER_ENTER_COMBAT") then
            --Print("PLAYER_ENTER_COMBAT");
            Wardrobe_InCombat = true;
        elseif (event == "PLAYER_LEAVE_COMBAT") then
            --Print("PLAYER_LEAVE_COMBAT");
            Wardrobe_InCombat = false;
            if (not Wardrobe_IsPlayerInCombat()) then Chronos.schedule(1, Wardrobe_CheckWaitingList); end
        elseif (event == "PLAYER_AURAS_CHANGED") then
            Chronos.schedule(1, Wardrobe_CheckForMounted);
            Chronos.schedule(1, Wardrobe_CheckForEatDrink);
        elseif (event == "ZONE_CHANGED_NEW_AREA") then
            Chronos.schedule(1, Wardrobe_ChangedZone);            
        elseif (event == "VARIABLES_LOADED") then
            Wardrobe_UpdateOldConfigVersions();
            Chronos.schedule(1, Wardrobe_CheckForMounted); -- we might login on a mount, so check here
            Wardrobe_CurrentZone = GetZoneText();
            Chronos.schedule(1, Wardrobe_ChangedZone);
        end
    end
end


---------------------------------------------------------------------------------
-- Return true if we're in combat
---------------------------------------------------------------------------------
function Wardrobe_IsPlayerInCombat() 
    if (Wardrobe_InCombat or (not Wardrobe_RegenEnabled)) then
        return true;
    else
        return false;
    end
end


---------------------------------------------------------------------------------
-- Update outdated config information
---------------------------------------------------------------------------------
function Wardrobe_UpdateOldConfigVersions()
    if (Wardrobe_Config.DefaultCheckboxState == nil) then
        WardrobeDebug("Adding DefaultCheckboxState to Wardrobe_Config.");
        Wardrobe_Config.DefaultCheckboxState = 1;
    else
        WardrobeDebug("Wardrobe_Config.DefaultCheckboxState = "..tostring(Wardrobe_Config.DefaultCheckboxState));        
    end
end


---------------------------------------------------------------------------------
-- Update outdated item data structures
---------------------------------------------------------------------------------
function Wardrobe_FixOldDataStructures()
    if (table.getn(Wardrobe_Config[WD_charID].Outfit) > 0) then
        for outfitNum = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
            if (type(Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[1]) == "string") then
                for i = 1, table.getn(Wardrobe_InventorySlots) do       
                    tmpTable = { };
                    tmpTable.Name = Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i];
                    tmpTable.IsSlotUsed = Wardrobe_Config.DefaultCheckboxState;
                    Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i] = { };
                    table.insert(Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i], tmpTable);
                end      
            end    
            if (not Wardrobe_Config[WD_charID].Outfit[outfitNum].ButtonColor) then
                Wardrobe_Config[WD_charID].Outfit[outfitNum].ButtonColor = WARDROBE_DEFAULT_BUTTON_COLOR;
            end
            if (type(Wardrobe_Config[WD_charID].Outfit[outfitNum].ButtonColor) ~= "number") then
                Wardrobe_Config[WD_charID].Outfit[outfitNum].ButtonColor = WARDROBE_DEFAULT_BUTTON_COLOR;
            end
            if (not Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber) then
                Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber = outfitNum;
            end
            if (not Wardrobe_Config[WD_charID].Outfit[outfitNum].Selected) then
                Wardrobe_Config[WD_charID].Outfit[outfitNum].Selected = false;
            end
            if (not Wardrobe_Config[WD_charID].Outfit[outfitNum].Special) then
                Wardrobe_Config[WD_charID].Outfit[outfitNum].Special = "";
            end
        end
    end
    
    if (Wardrobe_Config.MustClickUIButton == nil) then Wardrobe_Config.MustClickUIButton = false; end
 
end

-----------------------------------------------------------------------------------
-- Workaround functions to handle a problem where the money field of a tooltip
-- will get hidden whenever tooltips are invoked.
-- 
-- Code by Telo.  From his post (http://forums.worldofwarcraft.com/thread.aspx?fn=wow-interface-customization&t=16768&tmp=1#post16768):
--   Whenever a tooltip is set, the game sends a CLEAR_TOOLTIP event, which causes GameTooltip_OnEvent to call 
--   GameTooltip_ClearMoney, hiding the money frame for GameTooltip. There doesn't appear to be any identifying 
--   information sent with the CLEAR_TOOLTIP event that would allow GameTooltip_OnEvent to discriminate between 
--   its tooltip and others, so simply hooking this function doesn't appear to help. I've worked around the 
--   issue for my code by using something similar to the following code wherever I use a hidden tooltip.
-----------------------------------------------------------------------------------
Wardrobe_Original_GameTooltip_ClearMoney = nil;
function Wardrobe_MoneyToggle()
    if (Sea.wow.tooltip.protectTooltipMoney) then
        if (Wardrobe_MoneyProtected) then
            Sea.wow.tooltip.unprotectTooltipMoney();
            Wardrobe_MoneyProtected = false;
        else
            Sea.wow.tooltip.protectTooltipMoney();
            Wardrobe_MoneyProtected = true;
        end
    else    
        if (Wardrobe_Original_GameTooltip_ClearMoney) then
            GameTooltip_ClearMoney = lOriginal_GameTooltip_ClearMoney;
            Wardrove_Original_GameTooltip_ClearMoney = nil;
        else
            Wardrobe_Original_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
            GameTooltip_ClearMoney = Wardrobe_GameTooltip_ClearMoney;
        end
    end
end
function Wardrobe_GameTooltip_ClearMoney()
    -- Intentionally empty since we don't want to clear money while we use hidden tooltips
end


---------------------------------------------------------------------------------
-- Main OnUpdate function that gets called always
---------------------------------------------------------------------------------
function Wardrobe_OnUpdateMain()
    -- does nothing right now
end


---------------------------------------------------------------------------------
-- Cleanup function to remove out of date data from previous AddOn version
---------------------------------------------------------------------------------
function Wardrobe_FilterUnusedoutfits()

    if (not Wardrobe_AlreadyFiltered) then
        numOutfitSlots = table.getn(Wardrobe_Config[WD_charID].Outfit);
        WardrobeDebug("Before processing: total outfitSlots = "..numOutfitSlots);
        for i = 1, numOutfitSlots do
            WardrobeDebug("Outfit in slot "..i.." = ["..Wardrobe_Config[WD_charID].Outfit[i].OutfitName.."]");
        end    

        WardrobeDebug("Begin processing.");

        numOutfitSlots = table.getn(Wardrobe_Config[WD_charID].Outfit);
        local currentSlot = 1;
        for i = 1, numOutfitSlots do

            -- if we found an empty outfit
            if (Wardrobe_Config[WD_charID].Outfit[currentSlot].OutfitName == "") then

                WardrobeDebug("Found blank outfit at "..i);

                -- remove the outfit
                table.remove(Wardrobe_Config[WD_charID].Outfit, currentSlot);
            else
                currentSlot = currentSlot + 1
            end
        end

        WardrobeDebug("Done processing.");
        numOutfitSlots = table.getn(Wardrobe_Config[WD_charID].Outfit);
        WardrobeDebug("After processing: total outfitSlots = "..numOutfitSlots);
        for i = 1, numOutfitSlots do
            WardrobeDebug("Outfit in slot "..i.." = ["..Wardrobe_Config[WD_charID].Outfit[i].OutfitName.."]");
        end    
        
        Wardrobe_AlreadyFiltered = true;
    end
end


--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              CHAT COMMAND FUNCTIONS                                        --
--                                                                                            --
--============================================================================================--
--============================================================================================--


---------------------------------------------------------------------------------
-- Break a chat command into its command and variable parts (i.e. "debug on" 
-- will break into command = "debug" and variable = "on", or "add my spiffy wardrobe"
-- breaks into command = "add" and variable = "my spiffy wardrobe"
---------------------------------------------------------------------------------
function Wardrobe_ParseCommand(msg)
    firstSpace = string.find(msg, " ", 1, true);
    if (firstSpace) then
        local command = string.sub(msg, 1, firstSpace - 1);
        local var  = string.sub(msg, firstSpace + 1);
        return command, var
    else
        return msg, nil;
    end
end


---------------------------------------------------------------------------------
-- A simple chat command handler.  takes commands in the form "/wardrobe command var"
---------------------------------------------------------------------------------
function Wardrobe_ChatCommandHandler(msg)
    local command, var = Wardrobe_ParseCommand(msg);
    if ((not command) and msg) then
        command = msg;
    end
    if (command) then
        command = string.lower(command);
        if (command == WARDROBE_CMD_RESET) then
            Wardrobe_EraseAllOutfits();
        elseif (command == WARDROBE_CMD_LIST) then
            Wardrobe_ListOutfits(var);
        elseif (command == WARDROBE_CMD_WEAR or command == WARDROBE_CMD_WEAR2 or command == WARDROBE_CMD_WEAR3) then
            Wardrobe_WearOutfit(var);
        elseif (command == WARDROBE_CMD_ON) then
            Wardrobe_Toggle(1);
        elseif (command == WARDROBE_CMD_OFF) then
            Wardrobe_Toggle(0);
        elseif (command == WARDROBE_CMD_LOCK) then
            Wardrobe_ToggleLockButton(true);
        elseif (command == WARDROBE_CMD_UNLOCK) then
            Wardrobe_ToggleLockButton(false);
        elseif (command == WARDROBE_CMD_VERSION) then
            WardrobePrint(WARDROBE_TXT_WARDROBEVERSION.." "..WARDROBE_VERSION);
        elseif (command == "testcheck") then
            Wardrobe_ShowWardrobeConfigurationScreen();
        elseif (command == "testsort") then
            Wardrobe_ShowMainMenu();
        elseif (command == "debug") then
            Wardrobe_ToggleDebug();
        elseif (command == "report") then
            Wardrobe_DumpDebugReport();
        elseif (command == "itemlist") then
            Wardrobe_BuildItemList();
        elseif (command == "struct") then
            Wardrobe_DumpDebugStruct();
        else
            Wardrobe_ShowHelp();
        end
    end
end



--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              WARDROBE MAIN FUNCTIONS                                       --
--                                                                                            --
--============================================================================================--
--============================================================================================--

---------------------------------------------------------------------------------
-- Each character on an account has an ID assigned to it that specifies its wardrobes
-- This function returns the ID associated with this character
---------------------------------------------------------------------------------
function Wardrobe_GetThisCharactersWardrobeID()

   WardrobeDebug("Looking up this character's wardrobe number...");
   
   -- look for this character in the wardrobe table
   WD_charID = nil;
    for i = 1, table.getn(Wardrobe_Config) do
        if (Wardrobe_Config[i].PlayerName == UnitName("player")) then
            WD_charID = i;
            break;
        end
    end
    
    -- if we didn't find this character, add us to the wardrobe table
    if (not WD_charID) then
        Wardrobe_AddThisCharacterToWardrobeTable();
        WD_charID = table.getn(Wardrobe_Config);
    end
    
    WardrobeDebug("This character's wardrobe number is: "..WD_charID);

    -- remove any blank/unused outfits in case older versions of the AddOn
    -- were still storing unused outfits
    Wardrobe_FilterUnusedoutfits();
    
    -- adjust datastructures for older versions of the addon
    Wardrobe_FixOldDataStructures();
    
    -- flag that we've already found / created this character's wardrobe entry
    Wardrobe_AlreadySetCharactersWardrobeID = true;
end


---------------------------------------------------------------------------------
-- Checks to see if we've already looked up the number associated with this character
-- If not, grab the number
---------------------------------------------------------------------------------
function Wardrobe_CheckForOurWardrobeID()
    if (not Wardrobe_AlreadySetCharactersWardrobeID) then
        Wardrobe_GetThisCharactersWardrobeID();
    end
end


-- NOTES ABOUT DATASTRUCTURES:
--
-- For each character, the wardrobes are stored in a datastructure that looks like this
-- 
-- x = total number of outfits
-- y = total slots on a character (head, feet, hands, etc)
--
-- Outfit[x]          -- the datastructure for a single outfit
--
--     SortNumber       -- specifies the position this outfit will appear in the list of outfits when the list is sorted
--     OutfitName       -- the name of this outfit
--     Available        -- true if all of the items in this outfit are in our bags or equiped
--     Mounted          -- true if this is the outfit to be worn when we mount
--     Virtual          -- true if this outfit is virtual (not a real outfit, but only used as temporary storage)
--     Selected         -- true if this outfit is the currently selected outfit on the menu screen (highlighted white)
--     Item[1]          -- the data structure for all the items in this outfit
--          Name        -- the name of the item
--          IsSlotUsed  -- 1 if this outfit uses this slot, 0 if not (i.e. an outfit might not involve your trinkets, or might only consist of your rings)
--        .
--        .
--        .
--     Item[y]      
--
-- So, let's say you have two outfits in your wardrobe.  Wardrobe[1] represents outfit 1, and Wardrobe[2] 
-- represents outfit 2.  for outfit 1, Wardrobe[1].OutfitName would be the name of this outfit (say, "In town outfit").  
-- the item on your character slot 5 would be Wardrobe[1].Item[5].Name.  Since all these are stored per character, the
-- actual datastructure would look like:
--
-- Wardrobe_Config[3].Wardrobe[1].Item[5].Name --> for character 3, outfit 1, item 5


---------------------------------------------------------------------------------
-- Add an entry for this character to the main table of wardrobes
---------------------------------------------------------------------------------
function Wardrobe_AddThisCharacterToWardrobeTable()
    
    WardrobeDebug("Didn't find a wardrobe ID for this character.  Adding this character to the table...");
    
    -- build the structure for this char's wardrobe
    tempTable = { };
    tempTable.PlayerName = UnitName("player");
    tempTable.Outfit = { };
    
    -- stick this structure into the main table of wardrobes
    table.insert(Wardrobe_Config, tempTable);
end


---------------------------------------------------------------------------------
-- Create and return a blank outfit structure
---------------------------------------------------------------------------------
function Wardrobe_CreateBlankOutfit()
    local tempTable2 = { };
    tempTable2.SortNumber = nil;
    tempTable2.OutfitName = "";
    tempTable2.Available = false;
    tempTable2.Special = "";
    tempTable2.Virtual = false;
    tempTable2.Selected = false;
    tempTable2.ButtonColor = WARDROBE_DEFAULT_BUTTON_COLOR;
    tempTable2.Item = { };
    for i = 1, table.getn(Wardrobe_InventorySlots) do
        tempTable3 = { };
        tempTable3.Name = "";
        tempTable3.IsSlotUsed = Wardrobe_Config.DefaultCheckboxState;
        table.insert(tempTable2.Item, tempTable3);
    end
    
    return tempTable2;
end


---------------------------------------------------------------------------------
-- Add the named outfit to our wardrobe
---------------------------------------------------------------------------------
function Wardrobe_AddNewOutfit(outfitName, buttonColor)   

     if (Wardrobe_Config.Enabled) then
    
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();

        if (not outfitName) then
            return;
        end
        
        -- make sure we don't already have an outfit with the same name
        if (Wardrobe_FoundOutfitName(outfitName)) then
            WardrobePrint(WARDROBE_TXT_OUTFITNAMEEXISTS);   
            return;
        end

        WardrobeDebug("Trying to set this wardrobe as \""..outfitName.."\"");

        -- if we found a free outfit slot
        local outfitNum = Wardrobe_GetNextFreeOutfitSlot();
        if (outfitNum ~= 0) then
        
            -- store our current equipment in this outfit
            Wardrobe_StoreItemsInOutfit(outfitName, outfitNum, "added");
            Wardrobe_Config[WD_charID].Outfit[outfitNum].ButtonColor = buttonColor;
        -- otherwise we've used the maximum number of outfits
        else
            WardrobePrint(WARDROBE_TXT_USEDUPALL.." "..WARDROBE_NUM_OUTFITS.." "..WARDROBE_TXT_OFYOUROUTFITS, 1.0, 0.0, 0.0);
        end
    end
end


---------------------------------------------------------------------------------
-- Create and return the index of the next free outfit slot
---------------------------------------------------------------------------------
function Wardrobe_GetNextFreeOutfitSlot(addingVirtualOutfit)

    -- find next unused outfit slot
    local outfitNum = 0;
    
    local outfitCount = 0;
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        if (not Wardrobe_Config[WD_charID].Outfit[i].Virtual) then outfitCount = outfitCount + 1; end
    end
    
    -- if we aren't already using our max number of outfits
    if (outfitCount < WARDROBE_NUM_OUTFITS or addingVirtualOutfit) then
    
        -- add another outfit to the list and return its index
        table.insert(Wardrobe_Config[WD_charID].Outfit, Wardrobe_CreateBlankOutfit());
        outfitNum = table.getn(Wardrobe_Config[WD_charID].Outfit);
        Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber = outfitNum;
    end
        
    return outfitNum;    
end


---------------------------------------------------------------------------------
-- Store our currently equipped items in the specified outfit name
---------------------------------------------------------------------------------
function Wardrobe_StoreItemsInOutfit(outfitName, outfitNum, printMessage)

    -- store the name of this outfit
     Wardrobe_Config[WD_charID].Outfit[outfitNum].OutfitName = outfitName;
     Wardrobe_Config[WD_charID].Outfit[outfitNum].Special = "";
     Wardrobe_Config[WD_charID].Outfit[outfitNum].Virtual = false;

    -- for each slot on our character's person (hands, feet, etc)
    for i = 1, table.getn(Wardrobe_InventorySlots) do       
        Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].IsSlotUsed = Wardrobe_ItemCheckState[i];
        if (Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].IsSlotUsed == 1) then
            Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].Name = Wardrobe_GetItemNameAtInventorySlotNumber(i);
        else
            Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].Name = "";
        end
        if (Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].IsSlotUsed == 1) then
            WardrobeDebug("    Setting USED slot "..Wardrobe_InventorySlots[i].." = ["..Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].Name.."]");
        else
            WardrobeDebug("    Setting unused slot "..Wardrobe_InventorySlots[i].." = ["..Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].Name.."]");
        end
    end 

    -- all the items in this outfit are currently available in the player's inventory
    Wardrobe_Config[WD_charID].Outfit[outfitNum].Available = true;

    if (printMessage) then
        WardrobePrint(WARDROBE_TXT_OUTFIT.." \""..outfitName.."\" "..printMessage..".");
    end
end


---------------------------------------------------------------------------------
-- Update an outfit
---------------------------------------------------------------------------------
function Wardrobe_UpdateOutfit(outfitName, buttonColor)

    if (Wardrobe_Config.Enabled) then
    
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();
             
        -- check to see if the wardrobe doesn't exist
        if (outfitName == nil or outfitName == "") then
            WardrobePrint(WARDROBE_TXT_PLEASEENTERNAME);
        elseif (not Wardrobe_FoundOutfitName(outfitName)) then
            WardrobePrint(WARDROBE_TXT_OUTFITNOTEXIST);
            UIErrorsFrame:AddMessage(WARDROBE_TXT_NOTEXISTERROR, 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
        else

            -- find the outfit to update
            for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do

                -- if we found the outfit, store our equipment
                if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName == outfitName) then
                    Wardrobe_StoreItemsInOutfit(outfitName, i, WARDROBE_TXT_UPDATED);
                    Wardrobe_Config[WD_charID].Outfit[i].ButtonColor = buttonColor;
                end
            end
        end
    end
end


---------------------------------------------------------------------------------
-- Erase the named outfit
---------------------------------------------------------------------------------
function Wardrobe_EraseOutfit(outfitName, silent)  

    if (Wardrobe_Config.Enabled) then
    
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();
        
        WardrobeDebug("Trying to delete outfit \""..outfitName.."\"");

        -- find the outfit to erase
        for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do

            -- if we found the outfit
            if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName == outfitName) then

                -- remove the outfit
                table.remove(Wardrobe_Config[WD_charID].Outfit, i);
                Wardrobe_RenumberSortNumbers();
                
                --Wardrobe_RemoveAPopupButton(outfitName);

                if (not DoEraseAll and not silent) then
                    WardrobePrint(WARDROBE_TXT_OUTFIT.." \""..outfitName.."\" "..WARDROBE_TXT_DELETED);
                    Wardrobe_ListOutfits();
                    UIErrorsFrame:AddMessage(WARDROBE_TXT_OUTFIT.." \""..outfitName.."\" "..WARDROBE_TXT_DELETED, 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
                end
                return true;
            end
        end

        WardrobePrint(WARDROBE_TXT_UNABLETOFIND.." \""..outfitName.."!\"");
        UIErrorsFrame:AddMessage(WARDROBE_TXT_UNABLEFINDERROR, 1.0, 0.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
        return false;
    end
end


---------------------------------------------------------------------------------
-- Erase all our outfits
---------------------------------------------------------------------------------
function Wardrobe_EraseAllOutfits()

    if (Wardrobe_Config.Enabled) then
    
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();

        -- delete all the outfits
        Wardrobe_Config[WD_charID].Outfit = { };
        
        -- hide the main menu
        Wardrobe_ToggleMainMenuFrameVisibility(false);
        
        WardrobePrint(WARDROBE_TXT_ALLOUTFITSDELETED);
        UIErrorsFrame:AddMessage(WARDROBE_TXT_ALLOUTFITSDELETED, 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
    end
end


---------------------------------------------------------------------------------
-- Print a list of our outfits
---------------------------------------------------------------------------------
function Wardrobe_ListOutfits(var)

    if (Wardrobe_Config.Enabled) then
    
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();

        local foundOutfits = false;
        WardrobePrint(WARDROBE_TXT_YOURCURRENTARE);

        -- for each outfit
        for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do

            -- if it has a name and isn't virtual
            if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName ~= "" and (not Wardrobe_Config[WD_charID].Outfit[i].Virtual)) then
                WardrobePrint("    o "..Wardrobe_Config[WD_charID].Outfit[i].OutfitName);
                foundOutfits = true;

                -- if we asked for a detailed printout, show all the items
                if (var == "items") then
                    for j = 1, table.getn(Wardrobe_InventorySlots) do    
                        if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name ~= "") then
                           WardrobePrint("        ["..Wardrobe_InventorySlots[j].." -> "..Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name.."]");
                        end
                    end           
                end
            end
        end

        if (not foundOutfits) then
            WardrobePrint("  "..WARDROBE_TXT_NOOUTFITSFOUND);
        end
    end
end


---------------------------------------------------------------------------------
-- Wear an outfit
---------------------------------------------------------------------------------
function Wardrobe_WearOutfit(wardrobeName, silent)

    if (Wardrobe_Config.Enabled) then
    
         -- if we haven't already looked up our character's number
         Wardrobe_CheckForOurWardrobeID();

        -- if the user didn't specify a wardrobe to wear
        if (not wardrobeName) then

            WardrobePrint(WARDROBE_TXT_SPECIFYOUTFITTOWEAR);
            return;

        -- else use the specified wardrobe
        else
            OutfitNumber = 0;
            for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
                WardrobeDebug("In WearOutfit, Looking at outfit #"..i.."  name = ["..Wardrobe_Config[WD_charID].Outfit[i].OutfitName.."]");
                if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName == wardrobeName) then
                    OutfitNumber = i;
                    WardrobeDebug("Wardrobe_WearOutfit: Found outfit at #"..OutfitNumber);
                    break;
                end
            end

            if (OutfitNumber == 0) then
                WardrobePrint(WARDROBE_TXT_UNABLEFIND.." \""..wardrobeName.."\" "..WARDROBE_TXT_INYOURLISTOFOUTFITS);
                return;       
            end
        end

        WardrobeDebug(WARDROBE_TXT_SWITCHINGTOOUTFIT.." \""..wardrobeName.."\"");

        -- this variable "freeBagSpacesUsed" lets us track which empty pack spaces we've
        -- already assigned an item to be put into.  we need to do this because when we remove
        -- items from our character and put them into our bags, the server takes time to actually
        -- move the item into the bag.  during this delay, we may be still removing items, and we
        -- may see a slot that LOOKS empty but really the server just hasn't gotten around to moving
        -- a previous item into the slot.  this variable lets us mark each empty slot once we've assigned
        -- an item to it so that we don't try to use the same empty slot for another item.
        local freeBagSpacesUsed = { };

        -- tracks how our switching is going.  if at any point we can't remove an item (bags are full, etc),
        -- this will get set to false
        local switchResult = true;

        -- for each slot on our character (hands, neck, head, feet, etc)
        for i = 1, table.getn(Wardrobe_InventorySlots) do
            theSlotID = GetInventorySlotInfo(Wardrobe_InventorySlots[i]);
            theItemName = Wardrobe_Config[WD_charID].Outfit[OutfitNumber].Item[i].Name;
            WardrobeDebug("Working on slot -> "..Wardrobe_InventorySlots[i]);

            -- if this slot is used in this outfit
            if (Wardrobe_Config[WD_charID].Outfit[OutfitNumber].Item[i].IsSlotUsed == 1) then
            
                -- if we've set an item for this slot
                if (Wardrobe_Config[WD_charID].Outfit[OutfitNumber].Item[i].Name ~= "") then

                    -- if this item is different from what we're already wearing
                    WardrobeDebug("   Comparing ["..theItemName.."] with ["..Wardrobe_GetItemNameAtInventorySlotNumber(i).."]");
                    if (Wardrobe_Config[WD_charID].Outfit[OutfitNumber].Item[i].Name ~=  Wardrobe_GetItemNameAtInventorySlotNumber(i)) then

                        WardrobeDebug("      Didn't match!  Switching out "..Wardrobe_InventorySlots[i].." for ["..theItemName.."]");

                        -- equip the item
                        if (not Wardrobe_Equip(theItemName, theSlotID)) then
                            WardrobePrint(WARDROBE_TXT_WARNINGUNABLETOFIND.." \""..theItemName.."\" "..WARDROBE_TXT_INYOURBAGS);
                        end

                    -- else we're already wearing it so no need to do anything
                    else
                        WardrobeDebug("      Matched!  No need to switch out "..Wardrobe_InventorySlots[i].." ["..theItemName.."]");
                    end

                -- else this wardrobe doesn't use an item for this inventory slot (i.e. no gloves in this wardrobe)
                else

                    -- if the inventory slot has an item equipped
                    if (Wardrobe_GetItemNameAtInventorySlotNumber(i) ~= "") then

                        -- grab the inventory item and bag it
                        PickupInventoryItem(theSlotID);
                        result, freeBagSpacesUsed = BagItem(freeBagSpacesUsed);
                        WardrobeDebug("   Trying to remove "..Wardrobe_InventorySlots[i].." ( slot ID #"..theSlotID..")");

                        -- if we failed to switch, this will let us know
                        switchResult = switchResult and result;
                    end
                end
            end    
        end 

        -- only errorcheck when dealing with non-virtual outfits
        if (not Wardrobe_Config[WD_charID].Outfit[OutfitNumber].Virtual and not silent) then
        
            -- if everything went OK
            if (switchResult) then
                WardrobePrint(WARDROBE_TXT_SWITCHEDTOOUTFIT.." \""..wardrobeName..".\"");
                Wardrobe_Current_Outfit = OutfitNumber;
            else
                WardrobePrint(WARDROBE_TXT_PROBLEMSCHANGING);
            end
        end    
    end
end


---------------------------------------------------------------------------------
-- Rename an outfit
---------------------------------------------------------------------------------
function Wardrobe_RenameOutfit(oldName, newName)

    if (Wardrobe_Config.Enabled) then    

        -- check to see if the new name is already being used
        if (not Wardrobe_FoundOutfitName(newName) and newName ~= "") then
            for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
                if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName == oldName) then
                    Wardrobe_Config[WD_charID].Outfit[i].OutfitName = newName;
                    break;
                end
            end   
            UIErrorsFrame:AddMessage(WARDROBE_TXT_OUTFITRENAMEDERROR, 0.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
            WardrobePrint(WARDROBE_TXT_OUTFITRENAMEDTO.." \""..oldName.."\" "..WARDROBE_TXT_TOWORDONLY.." \""..newName.."\"");
        end
    end
end



---------------------------------------------------------------------------------
-- Comparison function for sorting outfits
---------------------------------------------------------------------------------
function Wardrobe_SortOutfitCompare(outfit1, outfit2)
    if (outfit1.SortNumber < outfit2.SortNumber) then
        return true;
    else
        return false;
    end
end


---------------------------------------------------------------------------------
-- Sort the outfits based on the .SortNumber property
---------------------------------------------------------------------------------
function Wardrobe_SortOutfits()
    table.sort(Wardrobe_Config[WD_charID].Outfit, Wardrobe_SortOutfitCompare);
    
    Wardrobe_RenumberSortNumbers();
end


---------------------------------------------------------------------------------
-- Re-number the .SortNumbers so they start at 1 and go up by 1
---------------------------------------------------------------------------------
function Wardrobe_RenumberSortNumbers()
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        Wardrobe_Config[WD_charID].Outfit[i].SortNumber = i;
    end
end


---------------------------------------------------------------------------------
-- Re-order an outfit in the list of outfits
---------------------------------------------------------------------------------
function Wardrobe_OrderOutfit(outfitNum, direction)
    if (outfitNum == 1 and direction < 0) then return; end
    if (outfitNum == table.getn(Wardrobe_Config[WD_charID].Outfit) and direction > 0) then return; end
    
    if (direction > 0) then
        
        swapNum = 0;
        for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
            if (Wardrobe_Config[WD_charID].Outfit[i].SortNumber == Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber + 1) then
                swapNum = i;
                break;
            end
        end
        Wardrobe_Config[WD_charID].Outfit[swapNum].SortNumber = Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber
        Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber = Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber + 1;
    else
        swapNum = 0;
        for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
            if (Wardrobe_Config[WD_charID].Outfit[i].SortNumber == Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber - 1) then
                swapNum = i;
                break;
            end
        end
        Wardrobe_Config[WD_charID].Outfit[swapNum].SortNumber = Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber
        Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber = Wardrobe_Config[WD_charID].Outfit[outfitNum].SortNumber - 1;
    end
    
    return swapNum;    
end


---------------------------------------------------------------------------------
-- return the index of the selected outfit, or nil if none
---------------------------------------------------------------------------------
function Wardrobe_FindSelectedOutfit()
    local outfitNum = nil;
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        if (Wardrobe_Config[WD_charID].Outfit[i].Selected) then
            outfitNum = i;
            break;
        end
    end

    return outfitNum;    
end


---------------------------------------------------------------------------------
-- Tag this outfit to be worn when mounted
---------------------------------------------------------------------------------
function Wardrobe_SetMountedOutfit(outfitName)
    OutfitNumber = nil;
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        Wardrobe_Config[WD_charID].Outfit[i].Special = "";
        if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName == outfitName) then
            OutfitNumber = i;
        end
    end
    if (OutfitNumber == nil) then
        WardrobePrint(WARDROBE_TXT_UNABLETOFINDOUTFIT.." \""..outfitName..".\"");
    else
        Wardrobe_Config[WD_charID].Outfit[OutfitNumber].Special = "mounted";
        WardrobePrint(WARDROBE_TXT_OUTFIT.." \""..outfitName.."\" "..WARDROBE_TXT_WILLBEWORNWHENMOUNTED);
    end
end


---------------------------------------------------------------------------------
-- Wear the outfit tagged as our mounted outfit
---------------------------------------------------------------------------------
function Wardrobe_WearMountedOutfit(wearIt)

    Wardrobe_CheckForOurWardrobeID();
        
    local MountedOutfitNumber = nil;
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        if (Wardrobe_Config[WD_charID].Outfit[i].Special == "mounted") then
            MountedOutfitNumber = i;
            break;
        end
    end

    if (MountedOutfitNumber or (not wearIt)) then
    
        if (wearIt) then
        
            Wardrobe_StoreVirtualOutfit(WARDROBE_UNMOUNT_OUTFIT_NAME, Wardrobe_Config[WD_charID].Outfit[MountedOutfitNumber].OutfitName);
            
            -- wear our mounted outfit
            Wardrobe_WearOutfit(Wardrobe_Config[WD_charID].Outfit[MountedOutfitNumber].OutfitName, true);
        else
        
            -- put the stuff back on that we were wearing before we changed into our mounted outfit
            Wardrobe_CheckForEquipVirtualOutfit(WARDROBE_UNMOUNT_OUTFIT_NAME);            
        end
    end
end


---------------------------------------------------------------------------------
-- Wear the outfit tagged as our "when eating" outfit
---------------------------------------------------------------------------------
function Wardrobe_WearChowingOutfit(wearIt)

    Wardrobe_CheckForOurWardrobeID();
        
    local ChowingOutfitNumber = nil;
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        if (Wardrobe_Config[WD_charID].Outfit[i].Special == "chowing") then
            ChowingOutfitNumber = i;
            break;
        end
    end

    if (ChowingOutfitNumber) then
    
        if (wearIt) then
        
            -- remember what we were wearing and then wear our mounted outfit
            Wardrobe_StoreVirtualOutfit(WARDROBE_DONEEATING_OUTFIT_NAME, Wardrobe_Config[WD_charID].Outfit[ChowingOutfitNumber].OutfitName);
            Wardrobe_WearOutfit(Wardrobe_Config[WD_charID].Outfit[ChowingOutfitNumber].OutfitName, true);
        else
        
            -- put the stuff back on that we were wearing before we changed into our mounted outfit
            Wardrobe_CheckForEquipVirtualOutfit(WARDROBE_DONEEATING_OUTFIT_NAME);
        end
    end
end



---------------------------------------------------------------------------------
-- Wear the outfit tagged as our plaguelands outfit
---------------------------------------------------------------------------------
function Wardrobe_WearPlagueOutfit(wearIt)

    Wardrobe_CheckForOurWardrobeID();
        
    PlagueOutfitNumber = nil;
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        if (Wardrobe_Config[WD_charID].Outfit[i].Special == "plague") then
            PlagueOutfitNumber = i;
            break;
        end
    end

    if (PlagueOutfitNumber) then
    
        if (wearIt) then
        
            -- remember what we're wearing before we put on the plaguelands outfit
            Wardrobe_StoreVirtualOutfit(WARDROBE_UNPLAGUE_OUTFIT_NAME, Wardrobe_Config[WD_charID].Outfit[PlagueOutfitNumber].OutfitName);
            
            -- wear our plaguelands outfit
            Wardrobe_WearOutfit(Wardrobe_Config[WD_charID].Outfit[PlagueOutfitNumber].OutfitName, true);
        else
            
            Wardrobe_CheckForEquipVirtualOutfit(WARDROBE_UNPLAGUE_OUTFIT_NAME);
        end
    end
end



---------------------------------------------------------------------------------
-- See if we're mounted
---------------------------------------------------------------------------------
function Wardrobe_CheckForMounted()

    -- check our buffs for a mount buff
    local mounted = false;
    for i = 1, 16 do
        local texture = UnitBuff("player", i);
        if (texture) then
            if (string.find(texture,"Ability_Mount") or 
                string.find(texture,"Spell_Nature_Swiftness") or 
                string.find(texture,"INV_Misc_Foot_Kodo")) then
                
                -- make sure the buff isn't "aspect of the pack" or "cheetah"
                if ((UnitClass("player") == "Hunter" and 
                    (not string.find(texture,"Ability_Mount_JungleTiger")) and 
                    (not string.find(texture,"Ability_Mount_WhiteTiger")))
                    or (UnitClass("player") ~= "Hunter")) then
                    mounted = true;
                    break;
                end    
            end
        end
    end
    --Print("Wardrobe_CheckForMounted: mounted = "..tostring(mounted));
    --Print("              Wardrobe_MountState = "..tostring(Wardrobe_MountState));
    
    -- toggle the mount state and schedule wearing our mounted outfit
    if (mounted and (not Wardrobe_MountState)) then
        Wardrobe_MountState = true;
        if (Wardrobe_IsPlayerInCombat()) then
            Wardrobe_AddToWaitingList("mount");
        else
            Chronos.schedule(WARDROBE_MOUNT_EQUIP_DELAY, Wardrobe_WearMountedOutfit, true);
        end    
    elseif ((not mounted) and Wardrobe_MountState) then
        Wardrobe_MountState = false;
        if (Wardrobe_IsPlayerInCombat()) then
            Wardrobe_AddToWaitingList("unmount");
        else
            Chronos.schedule(WARDROBE_MOUNT_EQUIP_DELAY, Wardrobe_WearMountedOutfit, false);
        end
    end
    
end


function Wardrobe_AddToWaitingList(theTask)
    --Print("Adding "..theTask.." to waiting list!");
    table.insert(Wardrobe_WaitingList, theTask);
end


function Wardrobe_CheckWaitingList()
    --Print("Checking Wardrobe_WaitingList: "..asText(Wardrobe_WaitingList));
    local theDelay = WARDROBE_MOUNT_EQUIP_DELAY;
    for i = 1, table.getn(Wardrobe_WaitingList) do
        local theTask = table.remove(Wardrobe_WaitingList, 1);
        --Print("Popped "..theTask.." from waiting list!");
        theDelay = theDelay + 2;
        if (theTask == "mount") then
            Chronos.schedule(theDelay, Wardrobe_WearMountedOutfit, true);
        elseif (theTask == "unmount") then
            Chronos.schedule(theDelay, Wardrobe_WearMountedOutfit, false);
        elseif (theTask == "plague") then
            Chronos.schedule(theDelay, Wardrobe_WearPlagueOutfit, true);
        elseif (theTask == "unplague") then
            Chronos.schedule(theDelay, Wardrobe_WearPlagueOutfit, false);
        elseif (theTask == "eating") then
            Chronos.schedule(theDelay, Wardrobe_WearChowingOutfit, true);
        elseif (theTask == "uneating") then
            Chronos.schedule(theDelay, Wardrobe_WearChowingOutfit, false);
        end
    end
end


---------------------------------------------------------------------------------
-- See if we're eating/drinking
---------------------------------------------------------------------------------
function Wardrobe_CheckForEatDrink()

    -- check our buffs for an eat or drink buff
    local chowing = nil;
    for i = 1, 16 do
        local texture = UnitBuff("player", i);
        if (texture) then
            if (string.find(texture,"INV_Misc_Fork") or string.find(texture,"INV_Drink")) then
                chowing = true;
                break;
            end
        end
    end

    -- toggle the chowing state and schedule wearing our chowing outfit
    if (chowing and (not Wardrobe_ChowingState)) then
        Wardrobe_ChowingState = true;
        if (Wardrobe_IsPlayerInCombat()) then
            Wardrobe_AddToWaitingList("eating");
        else
            Chronos.schedule(WARDROBE_MOUNT_EQUIP_DELAY, Wardrobe_WearChowingOutfit, true);
        end    
    elseif (not chowing and Wardrobe_ChowingState) then
        Wardrobe_ChowingState = false;
        if (Wardrobe_IsPlayerInCombat()) then
            Wardrobe_AddToWaitingList("uneating");
        else    
            Chronos.schedule(WARDROBE_MOUNT_EQUIP_DELAY, Wardrobe_WearChowingOutfit, false);
        end    
    end
   
end


---------------------------------------------------------------------------------
-- Check to see if we switched into or out of the plaguelands
---------------------------------------------------------------------------------
function Wardrobe_ChangedZone()

    if (Wardrobe_CurrentZone ~= GetZoneText()) then
        Wardrobe_CurrentZone = GetZoneText();
        local inPlagueZone = false;
        for i = 1, table.getn(WARDROBE_PLAGUEZONES) do
            if (Wardrobe_CurrentZone == WARDROBE_PLAGUEZONES[i]) then
                inPlagueZone = true;
                break;
            end
        end
        if (inPlagueZone) then
            if (Wardrobe_IsPlayerInCombat()) then
                Wardrobe_AddToWaitingList("plague");
            else    
                Chronos.schedule(WARDROBE_MOUNT_EQUIP_DELAY, Wardrobe_WearPlagueOutfit, true);
            end    
        else
            if (Wardrobe_IsPlayerInCombat()) then
                Wardrobe_AddToWaitingList("unplague");
            else    
                Chronos.schedule(WARDROBE_MOUNT_EQUIP_DELAY, Wardrobe_WearPlagueOutfit, false);
            end    
        end
    end    
end


---------------------------------------------------------------------------------
-- Store what we're currently wearing in a virtual outfit
---------------------------------------------------------------------------------
function Wardrobe_StoreVirtualOutfit(virtualOutfitName, currentOutfitName)

    local currentOutfitNum;
    if (type(currentOutfitName) == "number") then
        currentOutfitNum = currentOutfitName;
    else
        currentOutfitNum = Wardrobe_GetOutfitNum(currentOutfitName);
    end
    
    Wardrobe_ItemCheckState = { };
    for i = 1, table.getn(Wardrobe_InventorySlots) do
        local val = Wardrobe_Config[WD_charID].Outfit[currentOutfitNum].Item[i].IsSlotUsed;
        if (val ~= 1) then val = 0; end
        table.insert(Wardrobe_ItemCheckState, val);
    end    

    -- get a new outfit struct
    local newOutfitNum = Wardrobe_GetNextFreeOutfitSlot(true);

    -- this new outfit will remember what we're about to remove in order to wear our mounted outfit
    Wardrobe_StoreItemsInOutfit(virtualOutfitName, newOutfitNum);

    -- set this outfit to virtual so it'll be hidden and not show up as a normal outfit
    Wardrobe_Config[WD_charID].Outfit[newOutfitNum].Virtual = true;
end


---------------------------------------------------------------------------------
-- If we have a virtual outfit, wear it and delete it
---------------------------------------------------------------------------------
function Wardrobe_CheckForEquipVirtualOutfit(virtualOutfitName)

    if (not virtualOutfitName) then virtualOutfitName = WARDROBE_TEMP_OUTFIT_NAME; end
    
    if (Wardrobe_FoundOutfitName(virtualOutfitName)) then
        Wardrobe_WearOutfit(virtualOutfitName, true);
        Wardrobe_EraseOutfit(virtualOutfitName, true);
    end
end


---------------------------------------------------------------------------------
-- Start the process of figuring out what outfits are available to us in inventory
---------------------------------------------------------------------------------
function Wardrobe_UpdateOutfitAvailability_Start()
    if (Wardrobe_Config.Enabled and not Wardrobe_InCombat) then
        
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();

        Wardrobe_MasterItemList = Wardrobe_BuildItemList();
        Wardrobe_GlobalOutfitCounter = 1;        
        Chronos.schedule(WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY, Wardrobe_UpdateOutfitAvailability_Step);
    end    
end


---------------------------------------------------------------------------------
-- Perform one step in the process of figuring out what outfits are available to us in inventory
---------------------------------------------------------------------------------
function Wardrobe_UpdateOutfitAvailability_Step()

    -- if we're done looking at all the outfits
    if (Wardrobe_GlobalOutfitCounter > table.getn(Wardrobe_Config[WD_charID].Outfit)) then
        Chronos.schedule(WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY, Wardrobe_DetermineActiveOutfit_Start);        
    else
        local i = Wardrobe_GlobalOutfitCounter;
        
        -- if it has a name
        if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName ~= "") then

            local foundAllItems = true;

            -- for each item in the outfit
            for j = 1, table.getn(Wardrobe_Config[WD_charID].Outfit[i].Item) do

                -- if this slot is used in this outfit
                if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].IsSlotUsed == 1) then

                    local theItemName = Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name;
                    if (theItemName ~= "") then

                        local foundTheItem = false;
                        for k = 1, table.getn(Wardrobe_MasterItemList) do
                            if (theItemName == Wardrobe_MasterItemList[k]) then
                                foundTheItem = true;
                                break;
                            end
                        end
                        if (not foundTheItem) then 
                            foundAllItems = false;
                            break;
                        end
                    end
                end    
            end

            -- if we found all items in our inventory
            Wardrobe_Config[WD_charID].Outfit[i].Available = foundAllItems;
            WardrobeDebug("   Outfit \""..Wardrobe_Config[WD_charID].Outfit[i].OutfitName.."\" -- found all items = "..tostring(foundAllItems));
        end

        Wardrobe_GlobalOutfitCounter = Wardrobe_GlobalOutfitCounter + 1;
        Chronos.schedule(WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY, Wardrobe_UpdateOutfitAvailability_Step);
    end
end


---------------------------------------------------------------------------------
-- Update whether we have all the items for our outfits in our bags
---------------------------------------------------------------------------------
function Wardrobe_UpdateOutfitAvailability_NonChronos()

    if (Wardrobe_Config.Enabled and not Wardrobe_InCombat) then
    
        -- if we haven't already looked up our character's number
        Wardrobe_CheckForOurWardrobeID();

        WardrobeDebug("Wardrobe Availability:");
        
        local masterItemList = Wardrobe_BuildItemList();
    
        -- for each outfit
        for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do

            -- if it has a name
            if (Wardrobe_Config[WD_charID].Outfit[i].OutfitName ~= "") then

                local foundAllItems = true;

                -- for each item in the outfit
                for j = 1, table.getn(Wardrobe_Config[WD_charID].Outfit[i].Item) do

                    -- if this slot is used in this outfit
                    if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].IsSlotUsed == 1) then

                        local theItemName = Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name;
                        if (theItemName ~= "") then

                            local foundTheItem = false;
                            for k = 1, table.getn(masterItemList) do
                                if (theItemName == masterItemList[k]) then
                                    foundTheItem = true;
                                    break;
                                end
                            end
                            if (not foundTheItem) then 
                                foundAllItems = false;
                                break;
                            end
                        end
                    end    
                end

                -- if we found all items in our inventory
                Wardrobe_Config[WD_charID].Outfit[i].Available = foundAllItems;
                WardrobeDebug("   Outfit \""..Wardrobe_Config[WD_charID].Outfit[i].OutfitName.."\" -- found all items = "..tostring(foundAllItems));
            end
        end
    end
end



---------------------------------------------------------------------------------
-- Start the process of figuring out which outfits are currently being worn
---------------------------------------------------------------------------------
function Wardrobe_DetermineActiveOutfit_Start()
    WardrobeDebug("Wardrobe_DetermineActiveOutfit: Updating Active Outfit");
    Wardrobe_ActiveOutfitList = { };
    Wardrobe_GlobalOutfitCounter = 1;        
    
    -- build a reference table of the currently equipped items
    Wardrobe_CurrentlyEquippedItemList = { };
    for j = 1, table.getn(Wardrobe_InventorySlots) do
        table.insert(Wardrobe_CurrentlyEquippedItemList, Wardrobe_GetItemNameAtInventorySlotNumber(j));
    end    

    Chronos.schedule(WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY, Wardrobe_DetermineActiveOutfit_Step);
end


---------------------------------------------------------------------------------
-- Perform one step in the process of figuring out which outfits are currently being worn
---------------------------------------------------------------------------------
function Wardrobe_DetermineActiveOutfit_Step()

    -- if we're done looking at all the outfits
    if (Wardrobe_GlobalOutfitCounter > table.getn(Wardrobe_Config[WD_charID].Outfit)) then
        Chronos.schedule(WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY, Wardrobe_CompleteShowingUIMenu);        
    else
        WardrobeDebug("  Working on outfit "..i..": "..Wardrobe_Config[WD_charID].Outfit[i].OutfitName);
        
        i = Wardrobe_GlobalOutfitCounter;
        foundOutfit = true;
        
        -- for each slot on our character (hands, neck, head, feet, etc)
        for j = 1, table.getn(Wardrobe_InventorySlots) do
        
            -- if this slot is used in this outfit
            if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].IsSlotUsed == 1) then

                -- if this item is different from what we're already wearing
                WardrobeDebug("    Working on slot -> "..Wardrobe_InventorySlots[j]);
                WardrobeDebug("       Comparing ["..Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name.."] with ["..Wardrobe_GetItemNameAtInventorySlotNumber(j).."]");
                if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name ~=  Wardrobe_CurrentlyEquippedItemList[j]) then
                    foundOutfit = false;
                    break;
                end
            end
        end
        
        if (foundOutfit) then
            table.insert(Wardrobe_ActiveOutfitList, i);
        end
        
        Wardrobe_GlobalOutfitCounter = Wardrobe_GlobalOutfitCounter + 1;
        Chronos.schedule(WARDROBE_UPDATE_OUTFIT_CHRONOS_DELAY, Wardrobe_DetermineActiveOutfit_Step);
    end    
end


---------------------------------------------------------------------------------
-- Determine which outfit we're currently wearing
---------------------------------------------------------------------------------
function Wardrobe_DetermineActiveOutfit_NonChronos()

    WardrobeDebug("Wardrobe_DetermineActiveOutfit: Updating Active Outfit");
    local Wardrobe_ActiveOutfitList = { };
    local foundOutfit = false;
    
    -- build a reference table of the currently equipped items
    Wardrobe_CurrentlyEquippedItemList = { };
    for j = 1, table.getn(Wardrobe_InventorySlots) do
        table.insert(Wardrobe_CurrentlyEquippedItemList, Wardrobe_GetItemNameAtInventorySlotNumber(j));
    end    

    -- for each outfit
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
    
        WardrobeDebug("  Working on outfit "..i..": "..Wardrobe_Config[WD_charID].Outfit[i].OutfitName);
        
        foundOutfit = true;
        
        -- for each slot on our character (hands, neck, head, feet, etc)
        for j = 1, table.getn(Wardrobe_InventorySlots) do
        
            -- if this slot is used in this outfit
            if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].IsSlotUsed == 1) then

                -- if this item is different from what we're already wearing
                WardrobeDebug("    Working on slot -> "..Wardrobe_InventorySlots[j]);
                WardrobeDebug("       Comparing ["..Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name.."] with ["..Wardrobe_CurrentlyEquippedItemList[j].."]");
                if (Wardrobe_Config[WD_charID].Outfit[i].Item[j].Name ~= Wardrobe_CurrentlyEquippedItemList[j]) then
                    foundOutfit = false;
                    break;
                end
            end
        end
        
        if (foundOutfit) then
            table.insert(Wardrobe_ActiveOutfitList, i);
        end
     end
     
     return Wardrobe_ActiveOutfitList;     
end



--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              UTILITY FUNCTIONS                                             --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
-- Our own print function
-----------------------------------------------------------------------------------
function WardrobePrint(theMsg, r, g, b)
    
    -- 0.50, 0.50, 1.00
    if (r == nil) then r = 0.50; end
    if (g == nil) then g = 0.50; end
    if (b == nil) then b = 1.00; end

    if (type(theMsg) == "table") then
        Print(asText(theMsg), r, g, b);
    else
        Print(theMsg, r, g, b);
    end
end

---------------------------------------------------------------------------------
-- Save our settings
---------------------------------------------------------------------------------
function Wardrobe_SaveSettings()
    RegisterForSave("Wardrobe_Config");
end


-----------------------------------------------------------------------------------
-- Toggle the plugin on and off
-----------------------------------------------------------------------------------
function Wardrobe_Toggle(toggle)
    if (toggle == 1) then
        --WardrobePrint("Wardrobe Enabled.");
        Wardrobe_Config.Enabled = true;
        Wardrobe_IconFrame:Show();
    else
        --WardrobePrint("Wardrobe Disabled.");
        Wardrobe_Config.Enabled = false;
        Wardrobe_IconFrame:Hide();
    end
end


-----------------------------------------------------------------------------------
-- Nifty little function to view any lua object as text
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


---------------------------------------------------------------------------------
-- Display the help text
---------------------------------------------------------------------------------
function Wardrobe_ShowHelp()
    WardrobePrint("Wardrobe, an AddOn by Cragganmore, Version "..WARDROBE_VERSION);
    WardrobePrint("(Thanks to Saien for ideas from his wonderful EquipManager AddOn.)");
    WardrobePrint("Wardrobe allows you to define and switch among up to 20 different outfits.");
    WardrobePrint("The main interface can be accessed from the Wardrobe icon, which defaults");
    WardrobePrint("to just under your minimap/radar.  You may also use the following commands:");
    WardrobePrint("Usage: /wardrobe <wear/list/reset/lock/unlock>");
    WardrobePrint("   wear [outfit name] - Wear the specified outfit.");
    WardrobePrint("   list - List your outfits.");
    WardrobePrint("   reset - Delete all outfits in your wardrobe.");
    WardrobePrint("   lock/unlock - Lock or unlock moving the wardrobe icon interface.");
    WardrobePrint("In the UI, outfit names are colored as follows:");
    WardrobePrint("   Bright Colored: Your currently equipped outfit.");
    WardrobePrint("   Drab Colored: An outfit where one or more items aren't currently equipped.");
    WardrobePrint("   Grey: An outfit where one or more items aren't in your inventory.");
    WardrobePrint("   Greyed outfits may still be equipped.  The missing items just won't be worn.");
end



--============================================================================================--
--============================================================================================--
--                                                                                            --
--                              DEBUG FUNCTIONS                                               --
--                                                                                            --
--============================================================================================--
--============================================================================================--


-----------------------------------------------------------------------------------
-- Print out a debug statement if the WARDROBE_DEBUG flag is set
-----------------------------------------------------------------------------------
function WardrobeDebug(theMsg)
    if (WARDROBE_DEBUG) then
        ChatFrame1:AddMessage(theMsg, 1.0, 1.0, 0.7);
    end
end


---------------------------------------------------------------------------------
-- Toggle debug output
---------------------------------------------------------------------------------
function Wardrobe_ToggleDebug()
    WARDROBE_DEBUG = not WARDROBE_DEBUG;
    if (WARDROBE_DEBUG) then
        Print("Wardrobe: Debug ON",1.0,1.0,0.5);
    else
        Print("Wardrobe: Debug OFF",1.0,1.0,0.5);
    end    
end


---------------------------------------------------------------------------------
-- Debug routine to print the current state of the plugin
---------------------------------------------------------------------------------
function Wardrobe_DumpDebugReport()
    
    Wardrobe_CheckForOurWardrobeID();
    
    WardrobeDebug("Wardrobe_DumpDebugReport: Character's wardrobe database");
    for outfitNum = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        WardrobeDebug("Outfit: "..tostring(Wardrobe_Config[WD_charID].Outfit[outfitNum].OutfitName));
        for i = 1, table.getn(Wardrobe_InventorySlots) do
            theWardrobeItem = Wardrobe_Config[WD_charID].Outfit[outfitNum].Item[i].Name;
            WardrobeDebug(Wardrobe_InventorySlots[i].." = "..tostring(theWardrobeItem));
        end
    end
end



---------------------------------------------------------------------------------
-- Print a debug report
---------------------------------------------------------------------------------
function Wardrobe_DumpDebugStruct()
    for i = 1, table.getn(Wardrobe_Config[WD_charID].Outfit) do
        Print("Outfit #"..i..":");
        Print(asText(Wardrobe_Config[WD_charID].Outfit[i]));
        Print("--------------------");
    end
end


