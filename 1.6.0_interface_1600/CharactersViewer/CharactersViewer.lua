--[[

   Version: 0.59 (UltimateUI Revision : $Rev: 2144 $)
   Last Changed by: $LastChangedBy: flisher $
   Date: $Date: 2005-07-17 08:48:29 -0400 (Sun, 17 Jul 2005) $

   Official Distribution site:   http://www.curse-gaming.com/mod.php?addid=490
   Also packaged in UltimateUI: http://www.ultimateuiui.org

To make the lua file lighter, comment and update log are moved to a readme.txt
Change from 0.58 to 0.59
-(0.59) Fixed the .toc file to 1600

Change from 0.57 to 0.58
-(0.58) Added ReceipeBook Support. (by Flisher)
-(0.58) Fixed the money frame click to not do anything (by flisher, inspired from Accountant code)

]]--

-- Initialize the variables

CharactersViewerProfile = {};
CharactersViewerProfile[GetCVar("realmName")] = {} ;
CharactersViewerConfig = {};

CharactersViewer = {
   -- Functions
   
   unregister =
      {
         Event = function ()
            for index, event in CharactersViewer.constant.event do
               this:UnregisterEvent(event);         -- Event that will be called for initialisation of the addon
            end
         end;
      };

   register =
      {  Event = function ()
            for index, event in CharactersViewer.constant.event do
               this:RegisterEvent(event);         -- Event that will be called for initialisation of the addon
            end
            CharactersViewer.status.register.event = true;
         end;

         hook = function ()
            if (Sea) then
               Sea.util.hook("Logout", "CharactersViewer.collect.all");
               Sea.util.hook("Quit", "CharactersViewer.collect.all");
            else
               CharactersViewer_ORIG_Logout = Logout;
               CharactersViewer_ORIG_Quit = Quit;
               function Quit()
                  CharactersViewer.collect.all();
                  return CharactersViewer_ORIG_Quit();
               end
               function Logout()
                  CharactersViewer.collect.all();
                  return CharactersViewer_ORIG_Logout();
               end
            end
            CharactersViewer.status.register.hook = true;
         end;
      
         ultimateui = function ()                                  -- UltimateUI Button Support --
            if ( EarthFeature_AddButton ) then
               EarthFeature_AddButton (
                  {
                     id = "CharactersViewer";
                     name = BINDING_HEADER_CHARACTERSVIEWER;
                     subtext = CHARACTERSVIEWER_SHORT_DESC;
                     tooltip = CHARACTERSVIEWER_DESCRIPTION;
                     icon = CHARACTERSVIEWER_ICON;
                     callback = CharactersViewer.Toggle;
                     test = nil;
                  }
               );
               CharactersViewer.status.register.earth = true;
            elseif(UltimateUI_RegisterButton) then
               UltimateUI_RegisterButton (
                  BINDING_HEADER_CHARACTERSVIEWER,
                  CHARACTERSVIEWER_SHORT_DESC,
                  CHARACTERSVIEWER_DESCRIPTION,
                  CHARACTERSVIEWER_ICON,
                  CharactersViewer.Toggle
               );
               CharactersViewer.status.register.ultimateui = true;
            end
         end;
         
         myaddon = function ()                                 -- Interoperability MyAddOns --
            if(myAddOnsList and myAddOnsFrame) then
               myAddOnsList.CharactersViewer =
                  {
                     name = BINDING_HEADER_CHARACTERSVIEWER,
                     description = CHARACTERSVIEWER_DESCRIPTION,
                     version = CharactersViewer.version.text,
                     category = MYADDONS_CATEGORY_INVENTORY,
                     frame = "CharactersViewer_Frame",
                     optionsframe = ''
                  };
               CharactersViewer.status.register.myaddon = true;
            end
         end;
         
         counselor = function ()                               -- Counselor tip --
            if (Counselor and Counselor.registerTip) then
               Counselor.registerTip (
                  {  id = "CharactersViewer_013";
                     addOn = "CharactersViewer";
                     type = COUNSELOR_STARTUP;
                     title = "CharactersViewer Description";
                     text = "CharactersViewer is an addons created with the purpose of displaying information about your other characters on the same server,\nYou can call the addons by typing /cv.\n\n  If the addons already know information about yout other characters, a dropdown menu will appear in your character paperdoll soo you can compare with your other character.";
                     tooltip = "What CharactersViewer can do for you!";
                  }
               );
               CharactersViewer.status.register.counselor = true;
            end
         end;
         
         ctmod = function()
            if (CT_RegisterMod) then
               CT_RegisterMod(BINDING_HEADER_CHARACTERSVIEWER, CHARACTERSVIEWER_SHORT_DESC, 4, "Interface\\Buttons\\Button-Backpack-Up", CHARACTERSVIEWER_DESCRIPTION, "switch", "", CharactersViewer.Toggle);
               CharactersViewer.status.register.ctmod = true;

            end
         end;

         titanmodmenu = function ()
            if (TitanModMenu_MenuItems) then 
               TitanModMenu_MenuItems["CharactersViewer"] = {
                  frame = "CharactersViewer_Frame",
                  cat = TITAN_MODMENU_CAT_INVENTORY,         
                  text = BINDING_HEADER_CHARACTERSVIEWER,
                  func = "CharactersViewer_Toggle"
                  };
               CharactersViewer.status.register.titanmodmenu = true;
            end
         end;

         slashcmd = function ()
            -- Register the SlashCommand in the system
            --! todo: Regster thing with ultimateui slashcmd 
            SlashCmdList["CHARACTERSVIEWER"] = function(msg)
               CharactersViewer.SlashCmd(msg);
            end
            CharactersViewer.status.register.slashcmd = true;
         end;
         
      };

   onLoad = function ()
      -- Registering Event
      CharactersViewer.register.Event();

      ---- Todo: Register slashcommand with sky
      CharactersViewer.register.slashcmd();

      -- Registering with other addons --
      CharactersViewer.register.ultimateui();
      CharactersViewer.register.myaddon();
      CharactersViewer.register.counselor();
      CharactersViewer.register.ctmod();
      CharactersViewer.register.titanmodmenu();
   end;

   SlashCmd = function(msg)
      -- get the parameter from the ShashCmd
      param = CharactersViewer.library.splitstring(msg);

      if ( param[0] and strlen(param[0]) > 0 ) then
         param[0] = strlower(param[0]);
      end
      if ( msg and strlen(msg) > 0 ) then
         msg = strlower(msg);
      end

      if (msg == CHARACTERSVIEWER_SUBCMD_SHOW) then
         CharactersViewer_Show();

      elseif (param[0] == CHARACTERSVIEWER_SUBCMD_CLEAR) then
         -- if no param[1] (character), then assign the current one.
         if (not param[1] ) then
            param[1] = UnitName("player");  --! todo: use the new blizzard function
         end

         -- Make the first character upper, all the other lowercase.
         param[1] = string.upper(string.sub(param[1], 1,1)) .. string.lower(string.sub(param[1] , 2));

         -- Check if the data exist,
         if (CharactersViewerProfile[GetCVar("realmName")][param[1]] ~= nil) then
            -- The data is confirmed existing, we can wipe it.
            CharactersViewerProfile[GetCVar("realmName")][param[1]] = nil;

            --! Make it Sea compatible
            DEFAULT_CHAT_FRAME:AddMessage(CHARACTERSVIEWER_PROFILECLEARED .. param[1]);

            -- If we cleared ourself, we will collect data
            if ( param[1] == UnitName("player") ) then
               CharactersViewer.collect.all();
            
            elseif ( param[1] == CharactersViewer.index ) then
               CharactersViewer.Switch();
               CharactersViewer_PaperDoll_Dropdown2_Toggle();
            else
               CharactersViewer_PaperDoll_Dropdown2_Toggle();
            end            

         else
            -- The data isn't existing for that character
            --! Make it Sea compatible
            DEFAULT_CHAT_FRAME:AddMessage(CHARACTERSVIEWER_NOT_FOUND .. param[1]);
         end
  
      elseif (msg == CHARACTERSVIEWER_SUBCMD_CLEARALL) then
         CharactersViewerProfile = {};
         --! todo: make it sea compliant
         DEFAULT_CHAT_FRAME:AddMessage(CHARACTERSVIEWER_ALLPROFILECLEARED);
         CharactersViewer.collect.all();
         CharactersViewer.Switch();
         CharactersViewer_PaperDoll_Dropdown2_Toggle(); 
      
      elseif (msg == "") then
         CharactersViewer.Toggle();

      elseif (msg == CHARACTERSVIEWER_SUBCMD_PREVIOUS) then
         CharactersViewer.Switch(-1);

      elseif (msg == CHARACTERSVIEWER_SUBCMD_NEXT) then
         CharactersViewer.Switch(1);

      elseif (param[0] == CHARACTERSVIEWER_SUBCMD_SWITCH) then
         if (not param[1] ) then
            param[1] = UnitName("player");  --! todo: use the new blizzard function
         end
         CharactersViewer.Switch(param[1]);
      else
         DEFAULT_CHAT_FRAME:AddMessage(CHARACTERSVIEWER_USAGE);
         local index, subcmdUsage;
         for index, subcmdUsage in CHARACTERSVIEWER_USAGE_SUBCMD do
            if (subcmdUsage) then
               DEFAULT_CHAT_FRAME:AddMessage(subcmdUsage);
            end
         end
      end
   end;

   Toggle = function ()                      -- Changed by Flisher 2005-06-12
      if (CharactersViewer_Frame:IsVisible()) then
         CharactersViewer.Hide();
      else
         CharactersViewer_Show();
      end
   end;

   Hide = function()
      HideUIPanel(CharactersViewer_Frame);
   end;


   Switch = function (choice)
      if (choice == nil) then
         choice = UnitName("player"); --! todo: improve
      end

      if (choice == -1 or choice == 1) then
         local current = 0;
         local i = 0;
         local temp = {};
         for j, name in CharactersViewerProfile[GetCVar("realmName")] do
            i = i + 1;
            temp[i] = j;
            if (j == CharactersViewer.index ) then
               current = i;
            end
         end
         current = current + choice;
         if (current <= 0) then
            choice = temp[i];
         elseif (current > i) then
            choice = temp[1];
         else
            choice = temp[current];
         end
      end
 
      -- Switch the current characterviwer character
      choice = string.upper(string.sub(choice, 1,1)) .. string.lower(string.sub(choice , 2));  -- Make the first character upper, all the other lowercase.
      if (CharactersViewerProfile[GetCVar("realmName")][choice] ~= nil) then
         CharactersViewer.index = choice;
         CharactersViewerCurrentIndex = CharactersViewer.index;        -- Backward compatibility
      else
         DEFAULT_CHAT_FRAME:AddMessage(CHARACTERSVIEWER_NOT_FOUND .. choice);
         CharactersViewer.Hide();
      end

      if (CharactersViewer_Frame:IsVisible()) then
         CharactersViewer_Show();
      end
   end;

   collect =
      {
         basic = function ()
            -- Set the character name
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Name"] = playerName;

            -- Find the sex
            local sex = "";
            if (UnitSex("player") == 0) then
               sex = MALE;
            else
               sex = FEMALE;
            end

            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Other"] =
               {  Race = UnitRace("player"),
                  Class = UnitClass("player"),
                  Level = UnitLevel("player"),
                  Zone = GetZoneText(),
                  SubZone = GetSubZoneText(),
                  Money = GetMoney(),
                  Server = GetCVar("realmName"),
                  Sex = sex,
               }

            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Guild"] = {} ;
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Guild"]["GuildName"], CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Guild"]["Title"], CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Guild"]["Rank"] = GetGuildInfo("player");

            -- Set the mana pool if it's a mana user
            if ( UnitPowerType("player") == 0 ) then
               CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Other"]["Mana"] = UnitManaMax("player");
            end

            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Other"]["Health"] = UnitHealthMax("player");
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Other"]["Defense"] = UnitDefense("player");

            -- Set the armor value
            local baseArm, effectiveArmor, armor, positiveArm, negativeArm = UnitArmor("player");
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Other"]["Armor"] = baseArm .. ":" .. (baseArm + positiveArm) .. ":" .. positiveArm; -- if they have a debuf on, don't save it
         end;


         stats = function ()                       -- Flisher 2005-06-12
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Stats"] = {};
            -- "stat" is the same as effectiveStat...
            -- problem here is if they have a debuff spell on, the values saved will be wrong

            local stat, effectiveStat, posBuff, negBuff;
            for index = 1, 5 do
               local stat, effectiveStat, posBuff, negBuff = UnitStat("player", index);
               CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Stats"][index] = (stat - posBuff - negBuff) .. ":" .. effectiveStat .. ":" .. posBuff .. ":" .. negBuff;
            end
         end;

         resistance = function ()                  -- Flisher 2005-06-12
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Resists"] = {};
            for index = 2, 6 do
               local base, resistance, positive, negative = UnitResistance("player", index);
               CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Resists"][index] = resistance;
            end
         end;

         combatstats = function ()                 -- Flisher 2005-06-12
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["CombatStats"] = {};
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["CombatStats"]["D"] = GetDodgeChance();
            if ( GetBlockChance() > 0) then
               CharactersViewerProfile[GetCVar("realmname")][UnitName("player")]["CombatStats"]["B"] = GetBlockChance();
            end
            local spellIndex = 1;
            local spellName, subSpellName = GetSpellName(spellIndex,BOOKTYPE_SPELL);
            local tmpStr = nil;
            while spellName do
               if (spellName == ATTACK or spellName == PARRY) then
                  CharactersVTooltip:SetSpell(spellIndex, BOOKTYPE_SPELL);
                  local full_field_text = CharactersVTooltipTextLeft2:GetText();
                  local startString, endString = string.find(full_field_text, '%d+\.%d+')
                  if (startString ~= nil) then
                     tmpStr = string.sub(full_field_text,startString,endString);
                     tmpStr = string.gsub(tmpStr, ",", ".");
                  end
                  if (spellName == ATTACK) then
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["CombatStats"]["C"] = tmpStr;
                  elseif (spellName == PARRY) then
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["CombatStats"]["P"] = GetParryChance();
                  end
               end
               spellIndex = spellIndex + 1;
               spellName,subSpellName = nil;
               spellName,subSpellName = GetSpellName(spellIndex,BOOKTYPE_SPELL);
            end
         end;

         honor = function ()                    -- Flisher 2005-06-12
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Honor"] = {};
            if (UnitPVPRank("player") >= 1) then
               local rankName, rankNumber;
               rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));
               CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Honor"]["rankName"] = rankName;
               CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Honor"]["rankNumber"] = rankNumber;
            end
         end;
         
         Equipment = function()                 -- Changed by Flisher 2005-06-12
            local link, texture;
            -- Initialise the equipments
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Equipment"] = {};
            for index = 1, 19 do
               link = GetInventoryItemLink("player", index);
               texture = GetInventoryItemTexture("player", index);
               if( link ) then
                  for color, item, name in string.gfind(link, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
                     if( color ~= nil and item ~= nil and name ~= nil ) then
                        CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Equipment"][index] = { };
                        CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Equipment"][index]["T"] = texture;
                        CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Equipment"][index]["L"] = link;
                        if ( GetInventoryItemCount("player", index) > 1 ) then
                           CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Equipment"][index]["C"] = GetInventoryItemCount("player", index);
                        end
                     end
                  end
               end
            end
         end;

         Inventory = function ()             -- Changed by Flisher 2005-06-12
            local bag, bagname, link, texture, color, item, strings, str;
            -- Reset/Initialize
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"] = {}

            for bag = 0,4 do
               if (bag == 0) then
                  bagname = "Backpack";
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag] = { };
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["name"] = "Backpack";
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["Item"] = "Backpack";
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["Color"] = "ffffffff";
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["size"] = 16;
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["T"] = "Interface\\Buttons\\Button-Backpack-Up";
                  CharactersViewer.collect.Bag(bag);
               else
                  link = GetInventoryItemLink("player", (bag+19));
                  texture = GetInventoryItemTexture("player", (bag+19));
                  if( link ) then
                     for color, item, bagname in string.gfind(link, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
                        if( color ~= nil and item ~= nil and bagname ~= nil ) then
                           CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag] = { };
                           CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["name"] = bagname;
                           CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["size"] = GetContainerNumSlots(bag);
                           CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["L"] = link;
                           CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["T"] = texture;
                           CharactersViewer.collect.Bag(bag);
                        end
                     end
                  end
               end
            end
         end;

         Bag = function (bag)             -- Changed by Flisher 2005-06-12
            local slot, strings, str, texture, itemCount, locked, quality, link, color, item, name;
            for slot = 1,GetContainerNumSlots(bag) do   -- loop through all slots in this bag and get items
               CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag][slot] = {};
               texture, itemCount, locked, quality = GetContainerItemInfo(bag,slot);
               link = GetContainerItemLink(bag, slot);
               if( link ) then
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag][slot]["T"] = texture;
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag][slot]["L"] = link;
                  if (itemCount > 1) then
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag][slot]["C"] = itemCount;
                  end
               end
            end
         end;
         
         all = function ()                      -- Changed Flisher 2005-06-12
            -- Properly initialize the SavedVariable if it do not exist
            if ( not CharactersViewerProfile ) then
               CharactersViewerProfile = {};
            end
            -- Properly initialize the current realm if it do not exist
            if ( not CharactersViewerProfile[GetCVar("realmName")] ) then
               CharactersViewerProfile[GetCVar("realmName")] = {};
            end
            -- Properly initialise the current character data
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")] = {};

            CharactersViewer.collect.basic();
            CharactersViewer.collect.stats();
            CharactersViewer.collect.resistance();
            CharactersViewer.collect.combatstats();
            CharactersViewer.collect.honor();

            CharactersViewer.collect.Equipment();
            CharactersViewer.collect.Inventory();

            -- Set the status flag if data was collected at least once sicne the addon loaded
            if (not CharactersViewer.status.collected) then
               CharactersViewer.status.collected = true;
               CharactersViewer.Switch();
               CharactersViewer_PaperDoll_Dropdown2_Toggle();
            end
         end;
      };

   db = {
         validate = function ()
            if ( (not CharactersViewerConfig) or (CharactersViewerConfig["version"] and CharactersViewerConfig["version"] ~= CharactersViewer.version.db )) then                              -- Version Checking / Initializing
               return false;
            else
               return true;
            end
         end; 

         init = function ()
           CharactersViewerConfig = {};
           CharactersViewerProfile = {};
           ---- Todo: Make the display Sea Compatible
           -- Display a warning
           DEFAULT_CHAT_FRAME:AddMessage(CHARACTERSVIEWER_ALLPROFILECLEARED);

           -- Update the version of the Database
           CharactersViewerConfig["version"] = CharactersViewer.version.db;

           -- Initialise the Bag Display Status, true by default
           CharactersViewerConfig["Bag_Display"] = true;
         end;
            
      };

   library = 
      {
         splitstring = function (input)
            local list = {};
            local i = 0;
            for w in string.gfind(input, "%a+") do
               list[i] = w;
               i = i + 1;
            end
            return list;
         end;
         nameFromLink = function (link)               -- Norgana code from auctioneer
            local name;
            if( not link ) then
               return nil;
            end
            for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
               return name;
            end
         end;

         qualityFromLink = function (link)            -- Norgana code from auctioneer
            local color;
            if (not link) then return nil; end
            for color in string.gfind(link, "|c(%x+)|Hitem:%d+:%d+:%d+:%d+|h%[.-%]|h|r") do
               if (color == "   ") then return 4;--[[ Epic ]] end
               if (color == "ff0070dd") then return 3;--[[ Rare ]] end
               if (color == "ff1eff00") then return 2;--[[ Uncommon ]] end
               if (color == "ffffffff") then return 1;--[[ Common ]] end
               if (color == "ff9d9d9d") then return 0;--[[ Poor ]] end
            end
            return -1;
         end;

      }; 
         


   -- Variables
   index = nil;         -- is now initialised via the first data collect, wich should happen before any possible call
   loaded = nil;                             -- Successful load of the script
   version =
      {  db = 50;
         text = "0.59";
         number = 59;
      };
   
   constant =
      {
         event =
            {
               "VARIABLES_LOADED",
               "UNIT_NAME_UPDATE";
               "PLAYER_GUILD_UPDATE";
               "UNIT_INVENTORY_CHANGED";
               --"TRAINER_CLOSED";
               "PLAYER_LEVEL_UP";
               "PLAYER_PVP_RANK_CHANGED";
               "CHARACTER_POINTS_CHANGED";
            };

         inventorySlot =
            {
               Name =
                  {  [0] = AMMOSLOT,                    -- 0
                     [1] = HEADSLOT,                    -- 1
                     [2] = NECKSLOT,                    -- 2
                     [3] = SHOULDERSLOT,                -- 3
                     [4] = SHIRTSLOT,                   -- 4
                     [5] = CHESTSLOT,                   -- 5
                     [6] = WAISTSLOT,                   -- 6
                     [7] = LEGSSLOT,                    -- 7
                     [8] = FEETSLOT,                    -- 8
                     [9] = WRISTSLOT,                   -- 9
                     [10] = HANDSSLOT,                  -- 10
                     [11] = FINGER0SLOT,                -- 11
                     [12] = FINGER1SLOT,                -- 12
                     [13] = TRINKET0SLOT,               -- 13
                     [14] = TRINKET1SLOT,               -- 14
                     [15] = BACKSLOT,                   -- 15
                     [16] = MAINHANDSLOT,               -- 16
                     [17] = SECONDARYHANDSLOT,          -- 17
                     [18] = RANGEDSLOT,                 -- 18
                     [19] = TABARDSLOT,                 -- 19
                  };

               Texture =
                  {  [0] = ({GetInventorySlotInfo("AMMOSLOT")})[2],           -- 0
                     [1] = ({GetInventorySlotInfo("HEADSLOT")})[2],           -- 1
                     [2] = ({GetInventorySlotInfo("NECKSLOT")})[2],           -- 2
                     [3] = ({GetInventorySlotInfo("SHOULDERSLOT")})[2],       -- 3
                     [4] = ({GetInventorySlotInfo("SHIRTSLOT")})[2],          -- 4
                     [5] = ({GetInventorySlotInfo("CHESTSLOT")})[2],          -- 5
                     [6] = ({GetInventorySlotInfo("WAISTSLOT")})[2],          -- 6
                     [7] = ({GetInventorySlotInfo("LEGSSLOT")})[2],           -- 7
                     [8] = ({GetInventorySlotInfo("FEETSLOT")})[2],           -- 8
                     [9] = ({GetInventorySlotInfo("WRISTSLOT")})[2],          -- 9
                     [10] = ({GetInventorySlotInfo("HANDSSLOT")})[2],          -- 10
                     [11] = ({GetInventorySlotInfo("FINGER0SLOT")})[2],        -- 11
                     [12] = ({GetInventorySlotInfo("FINGER1SLOT")})[2],        -- 12
                     [13] = ({GetInventorySlotInfo("TRINKET0SLOT")})[2],       -- 13
                     [14] = ({GetInventorySlotInfo("TRINKET1SLOT")})[2],       -- 14
                     [15] = ({GetInventorySlotInfo("BACKSLOT")})[2],           -- 15
                     [16] = ({GetInventorySlotInfo("MAINHANDSLOT")})[2],       -- 16
                     [17] = ({GetInventorySlotInfo("SECONDARYHANDSLOT")})[2],  -- 17
                     [18] = ({GetInventorySlotInfo("RANGEDSLOT")})[2],         -- 18
                     [19] = ({GetInventorySlotInfo("TABARDSLOT")})[2],         -- 19
                  }
               };
      };
      
      config =
         {

      };

      status = {
         register = {};
         -- Known status to be inserted by the code lather
         -- loaded (meaning the initial load/initialisation is done)
         -- collected (true = that the system collected data at least once
      };

      debug = {          -- Added as I can use many debug flag for developpement - Flisher 2006-06-16

      };

};    -- End of CharactersViewer Object

-- OnFoo functions

function CharactersViewer_OnEvent(event, arg1)           -- Cleaned by Flisher 2005-05-31
   if (event == "VARIABLES_LOADED" and not CharactersViewer.status.loaded) then
      -- Set the Loaded Status to true, to ensure it's not runned twice, we never know with blizzard...
      CharactersViewer.status.loaded = true;

      -- Configure the panel display and title
      UIPanelWindows["CharactersViewer_Frame"] = { area = "left", pushable = 6 };
      CharactersViewer_FrameTitleText:SetText("CharactersViewer " .. CharactersViewer.version.text .. " by Flisher");

      -- Hooked function
      CharactersViewer.register.hook();

      -- Database version checkup, clean the data if the database version is obsolete
      if (CharactersViewer.db.validate() == false) then
         CharactersViewer.db.init();
      end

   end
   
   -- Escape if we can't properly initialize, gotta be checked after 1.5.0 patch, not trigered on loading, but sometime trigered on mail retrieval
   if ( ( event == "UNIT_INVENTORY_CHANGED" and arg1 ~= "player" ) or not UnitName("player") or UnitName("player") == UNKNOWNOBJECT or UnitName("player") == UKNOWNBEING or not GetCVar("realmName")) then
      return;
   end

   CharactersViewer.collect.all();

   return;
end

function CharactersViewerItemButton_OnEnter()                        -- Cleaned by Flisher 2005-05-31
   local link, text, itemCount;

   -- Detecting if it's from the inventory or equipment
   if (this:GetID() < 100) then
      -- Equiped item link
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][this:GetID()]) then
         link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][this:GetID()].L ;
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][this:GetID()].C) then
            itemCount = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][this:GetID()].C;
         end
      else
         text = CharactersViewer.constant.inventorySlot.Name[this:GetID()];
      end
   else
      -- Inventory item link
      local slot = math.mod(this:GetID(), 100);
      local bag  = (this:GetID() - slot - 100) / 100;
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L) then
         link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L;
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].C) then
            itemCount = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].C;
         end
      else
         text = EMPTY;
      end
   end

   ShowUIPanel(GameTooltip);
   GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
   if (link) then
      _,_,link2 = strfind(link,"|H(item:%d+:%d+:%d+:%d+)|");
      GameTooltip:SetHyperlink(link2);
   else
      GameTooltip:SetText(text);
   end
   
   -- Book of Crafts inter-operability (http://www.curse-gaming.com/mod.php?addid=1397)
   if (BookOfCrafts_UpdateGameToolTips and link) then
      BookOfCrafts_UpdateGameToolTips();
   end
   
   -- Receipe Book inter-operability (http://www.curse-gaming.com/mod.php?addid=914)
   if ( RecipeBook_DoHookedFunction and link) then
      RecipeBook_DoHookedFunction();
   end
   

   
   --Auctioneer inter-operability (http://www.curse-gaming.com/mod.php?addid=146)
   if (TT_TooltipCall and link) then
      local name = CharactersViewer.library.nameFromLink(link);
      if (name) then
         if (not itemCount) then
            itemCount = 1;
         end
         quality = CharactersViewer.library.qualityFromLink(link);
         TT_Clear();
         TT_TooltipCall(GameTooltip, name, link, quality, itemCount);
         TT_Show(GameTooltip);
      end
   end
   
end

function CharactersViewer_Tooltip_SetInventoryItem(tooltip, slotid)     -- Cleaned by Flisher 2005-05-31
   local link, text;
--!   if (not CharactersViewer.index) then
--!      CharactersViewer.Switch();
--!   end

   if ( CharactersViewer.index ~= UnitName("player") ) then
      -- Detecting if it's from the inventory or equipment
      if ( slotid < 100) then
         -- Equiped item link
         if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][slotid] ) then
            link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][slotid].L ;
            _,_,link = strfind(link,"|H(item:%d+:%d+:%d+:%d+)|");
         else
            text = CharactersViewer.constant.inventorySlot.Name[slotid];
         end
      else
         -- Inventory item link
         local slot = math.mod(slotid, 100);
         local bag  = (slotid - slot - 100) / 100;
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L) then
            link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L;
            _,_,link = strfind(link,"|H(item:%d+:%d+:%d+:%d+)|");
         else
            text = EMPTY;
         end
      end

      if (link) then
         tooltip:SetHyperlink(link);
         if (UnitName("player") ~= CharactersViewer.index) then
            tooltip:AddLine(CharactersViewer.index .. " " .. INVENTORY_TOOLTIP);
            tooltip:Show();
         else
            tooltip:Show();
         end
      end
   else       
      -- if the player requested is the logged one, use the original game tooltip
      tooltip:SetInventoryItem("player", slotid);
      tooltip:Show();
   end
   
end

function CharactersViewerItemButton_OnClick(arg1)                       -- Cleaned by Flisher 2005-05-31
   local link, item;
   -- Detecting if it's from the inventory or equipment
   if (this:GetID() < 100 ) then
      -- Equiped item link
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][this:GetID()]) then
         link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"][this:GetID()].L;
      end
   else
      -- Inventory item link
      local slot = math.mod(this:GetID(), 100);
      local bag  = (this:GetID() - slot - 100) / 100;
      link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L;
   end
   if (IsShiftKeyDown() and ChatFrameEditBox:IsVisible() and link and arg1 == "LeftButton") then
      ChatFrameEditBox:Insert(link);
   end

   -- Component interaction, http://www.curse-gaming.com/mod.php?addid=1256, added by Flisher 2005-06-16
   --! CharactersViewerItemButton_OnClick must be kept in backtracking ability CharactersViewer.button.onclick();
   if (Comp_TestOnClick and Comp_TestOnClick() and link) then
      return Comp_OnClick(arg1, link);
   end

end

function CharactersViewerMagicResistanceFrame_OnEnter()                 -- Checked by Flisher 2005-05-31
   ShowUIPanel(GameTooltip);
   GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
   GameTooltip:SetText(TEXT(getglobal("RESISTANCE"..this:GetID().."_NAME")));
end

function CharactersViewer_Bag_Toggle_Button_OnEnter()                   -- Checked by Flisher 2005-05-31
   ShowUIPanel(GameTooltip);
   GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
   GameTooltip:SetText(CHARACTERSVIEWER_TOOLTIP_BAGRESET);
end

function CharactersViewerDropDown2_OnEnter()                            -- Checked by Flisher 2005-05-31
   ShowUIPanel(GameTooltip);
   GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
   GameTooltip:SetText(CHARACTERSVIEWER_TOOLTIP_DROPDOWN2);
end

function CharactersViewer_Show()
   CharactersViewer.Hide();

   if (CharactersViewer.index == UnitName("player")) then
      CharactersViewer.collect.all();
   end

   -- Character Name and location
   CharactersViewer_FrameTopText1:SetText(CharactersViewer.index .. " (" .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Zone"] .. " - " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["SubZone"] .. ")");

   -- Character Honor Rank, Level, Race and Class
   local tempFrameTopText2 = "Level " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Level"] ..  " " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Race"] .. " " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Class"];
   if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Honor"] ~= nil and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Honor"]["rankNumber"] ~= nil and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Honor"]["rankName"] ~= nil) then
      tempFrameTopText2 = tempFrameTopText2 .. " (Rank " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Honor"]["rankNumber"] .. ", " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Honor"]["rankName"] .. ")";
   end
   CharactersViewer_FrameTopText2:SetText(tempFrameTopText2);

   -- Guild Rank and Name display initialisation
   if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Guild"]["GuildName"] ) then
      CharactersViewer_FrameTopText3:SetText(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Guild"]["Title"] .. " of " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Guild"]["GuildName"] );
   else
      CharactersViewer_FrameTopText3:SetText("");
   end

   -- Characters stats (str agi spirit intel stam...)
   for index = 1, 5 do
     local j = 0, stat, effectiveStat, posBuff, negBuff;
     for w in string.gfind(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Stats"][index], "%d+") do
         j = j + 1;
         if (j == 1) then
            stat = w;
         end
         if (j == 2) then
            effectiveStat = w;
         end
         if (j == 3) then
            posBuff = w;
         end
         if (j == 4) then
            negBuff = w;
         end
     end

     -- Set the stats title
     local text = getglobal("CharactersViewer_FrameStatsTitle"..index);
     text:SetText(TEXT(getglobal("SPELL_STAT"..(index-1).."_NAME")));
     local text = getglobal("CharactersViewer_FrameStatsText"..index);
     text:SetText(effectiveStat);
   end

   -- Initialise the armor display
   local j =0, stat, effectiveStat, posBuff, negBuff;
   for w in string.gfind(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Armor"], "%d+") do
         j = j + 1;
         if (j == 1) then
            stat = w;
         end
         if (j == 2) then
            effectiveStat = w;
         end
         if (j == 3) then
            posBuff = w;
         end
         if (j == 4) then
            negBuff = w;
         end
   end
   CharactersViewer_FrameStatsTitle6:SetText(ARMOR_COLON);
   CharactersViewer_FrameStatsText6:SetText(effectiveStat);


   -- Initialise the Health display
   CharactersViewer_FrameDetailTitle1:SetText(HEALTH_COLON);
   CharactersViewer_FrameDetailText1:SetText(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Health"]);

   -- Initialise the mana display
   if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Mana"] ) then
      -- Mana user (mana saved)
      CharactersViewer_FrameDetailTitle2:SetText(MANA_COLON);
      CharactersViewer_FrameDetailText2:SetText(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Mana"]);
   else
      -- Not a mana user (no mana saved)
      CharactersViewer_FrameDetailTitle2:SetText("");
      CharactersViewer_FrameDetailText2:SetText("");
   end

   -- Initialize the combats stats (crit, parry, dodge, block...)
   if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]) then
      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["C"] ) then
         CharactersViewer_FrameDetailTitle3:SetText(CHARACTERSVIEWER_CRIT);
         CharactersViewer_FrameDetailText3:SetText( string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["C"] ));
      else
         CharactersViewer_FrameDetailTitle3:SetText("");
         CharactersViewer_FrameDetailText3:SetText("");
      end

      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["D"] ) then
         CharactersViewer_FrameDetailTitle4:SetText(DODGE);
         CharactersViewer_FrameDetailText4:SetText( string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["D"] ));
      else
         CharactersViewer_FrameDetailTitle4:SetText("");
         CharactersViewer_FrameDetailText4:SetText("");
      end

      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["B"] ) then
         CharactersViewer_FrameDetailTitle5:SetText(BLOCK);
         CharactersViewer_FrameDetailText5:SetText( string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["B"] ));
      else
         CharactersViewer_FrameDetailTitle5:SetText("");
         CharactersViewer_FrameDetailText5:SetText("");
      end

      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["P"] ) then
         CharactersViewer_FrameDetailTitle6:SetText(PARRY);
         CharactersViewer_FrameDetailText6:SetText( string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["CombatStats"]["P"] ));
      else
         CharactersViewer_FrameDetailTitle6:SetText("");
         CharactersViewer_FrameDetailText6:SetText("");
      end
   else
      CharactersViewer_FrameDetailTitle3:SetText("");
      CharactersViewer_FrameDetailText3:SetText("");
      CharactersViewer_FrameDetailTitle4:SetText("");
      CharactersViewer_FrameDetailText4:SetText("");
      CharactersViewer_FrameDetailTitle5:SetText("");
      CharactersViewer_FrameDetailText5:SetText("");
      CharactersViewer_FrameDetailTitle6:SetText("");
      CharactersViewer_FrameDetailText6:SetText("");
   end

   -- Initialise the various resistance display
   for index = 2, 6 do
     local text = getglobal("CharactersViewerMagicResText"..index);
     text:SetText(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Resists"][index]);
   end

   ---- Tofix: the blizzard moneyframe is crap... Flisher 2005-05-31
   MoneyFrame_Update("CharactersViewer_MoneyFrame", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Other"]["Money"]);

   local index, item, button, texture;
   for index = 1, 19 do
      button = getglobal("CharactersViewer_FrameItem"..index);
      texture = getglobal("CharactersViewer_FrameItem"..index.."IconTexture");
      texture2 = CharactersViewer.constant.inventorySlot.Texture[index];
      texture:SetTexture(texture2);
      SetItemButtonCount(button, 0);
   end
   for index, item in CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Equipment"] do
       button = getglobal("CharactersViewer_FrameItem"..index);
       texture = getglobal("CharactersViewer_FrameItem"..index.."IconTexture");
       texture:SetTexture(item.T);
       SetItemButtonCount(button, item.C);
   end
   
   SetPortraitTexture(CharactersViewer_PortraitTexure, "player");
   ShowUIPanel(CharactersViewer_Frame);
   
   -- bag
   if (CharactersViewerConfig["Bag_Display"] == true) then
      CharactersViewer_Bag_Display();    
   else
      CharactersViewer_Bag_Hide();
   end
end

function CharactersViewer_Bag_Display()                           -- Checked by Flisher 2005-05-31
   local index2 = 0;
   for index = 0,4 do
      getglobal("CharactersViewer_ContainerFrame" ..index ):Hide();
      --- Removed Flisher 2005-05-29 bagFrame:Hide();
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][index]) then
         CharactersViewer_Bag_Open(index, index2);
         index2 = index2 + 1;
      end
   end
end

function CharactersViewer_Bag_Hide()                              -- Checked by Flisher 2005-05-31
   local index2 = 0;
   for index = 0,4 do
      bagFrame = getglobal("CharactersViewer_ContainerFrame" ..index ):Hide();
   end
end

function CharactersViewer_GetLink(id, name, color)                -- Checked by Flisher 2005-05-31
   local link;
   link = "|c"..color.."|Hitem:"..id.."|h["..name.."]|h|r";
   return link;
end

function CharactersViewerDropDown_OnLoad()                        -- Checked by Flisher 2005-05-31
   --! enable/disable checkup on this
   UIDropDownMenu_Initialize(this, CharactersViewerDropDown_Initialize);
   UIDropDownMenu_SetText(CHARACTERSVIEWER_SELPLAYER, this);
   UIDropDownMenu_SetWidth(80, CharactersViewerDropDown);
end

function CharactersViewerDropDown2_OnLoad()
   --! enable/disable checkup on this
   UIDropDownMenu_Initialize(this, CharactersViewerDropDown_Initialize);
   UIDropDownMenu_SetText(CHARACTERSVIEWER_DROPDOWN2, this);
   UIDropDownMenu_SetWidth(80, CharactersViewerDropDown2);
   --[[   Other know somewhat good positions, kept here if there is an option someday
            dropdown2 = getglobal("CharactersViewerDropDown2");
            dropdown2:SetPoint("BOTTOMRIGHT","MeleeAttackBackgroundTop", "TOPRIGHT",  16, -6 );
            UIDropDownMenu_SetWidth(215, CharactersViewerDropDown2);

            dropdown2 = getglobal("CharactersViewerDropDown2");
            dropdown2:SetPoint("BOTTOMRIGHT","CharacterFrameCloseButton", "TOPLEFT",  21, -12 );
            UIDropDownMenu_SetWidth(242, CharactersViewerDropDown2);
   ]]--
end

function CharactersViewerDropDown_OnClick()
   CharactersViewer.Switch(this.value);
   CharactersViewer_Show();
   
end

function CharactersViewerDropDown_Initialize()
   local info = {};
   for index, item in CharactersViewerProfile[GetCVar("realmName")] do
      local realm, player;
      info.text = index;
      info.value = index;
      info.func = CharactersViewerDropDown_OnClick;
      info.notCheckable = nil;
      info.keepShownOnClick = nil;
      UIDropDownMenu_AddButton(info);
   end;
end

function CharactersViewer_Bag_Open(bagID, FrameID)
   local theBag = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bagID];
   local bagFrame = getglobal("CharactersViewer_ContainerFrame"..(FrameID));
   local bagName = bagFrame:GetName();

   bagFrame:Hide();

   getglobal(bagName.."Name"):SetText(theBag.name );
   getglobal(bagName.."Portrait"):SetTexture(theBag.T);

   -- Generate the frame
   local frameSettings = CONTAINER_FRAME_TABLE[theBag.size];
   local frameBG = getglobal(bagName.."BackgroundTexture");
   local columns = NUM_CONTAINER_COLUMNS;
   local rows = ceil(theBag.size / columns);
   local button,item,idx;

   bagFrame:SetWidth(CONTAINER_WIDTH);
   bagFrame:SetHeight(frameSettings[4]);
   frameBG:SetTexture(frameSettings[1]);
   frameBG:SetWidth(frameSettings[2]);
   frameBG:SetHeight(frameSettings[3]);

   for bagItem = 1, theBag.size do
      idx = theBag.size - (bagItem - 1);
      item = theBag[idx];
      button = getglobal(bagName.."Item"..bagItem);

      if ( bagItem == 1 ) then
         button:SetPoint("BOTTOMRIGHT", bagName, "BOTTOMRIGHT", -11, 9);
      else
         if ( mod((bagItem-1), columns) == 0 ) then
            button:SetPoint("BOTTOMRIGHT", bagName.."Item"..(bagItem - columns), "TOPRIGHT", 0, 4);
         else
            button:SetPoint("BOTTOMRIGHT", bagName.."Item"..(bagItem - 1), "BOTTOMLEFT", -5, 0);
         end
      end
      button:Show();
   end
   for bagItem = theBag.size + 1, 20 do
      getglobal(bagName.."Item"..bagItem):Hide();
   end

   for bagItem = 1, theBag.size do
      idx = theBag.size - (bagItem - 1);
      getglobal(bagName.."Item"..bagItem):SetID(100 * bagID + idx + 100 );
      item = theBag[idx];
      button = getglobal(bagName.."Item"..bagItem);
      if ( item ) then
         SetItemButtonTexture(button, item.T);
         SetItemButtonCount(button, item.C);
      else
         SetItemButtonTexture(button,"");
         SetItemButtonCount(button, nil);
      end
   end

   bagFrame:Show();
   --PlaySound("igBackPackOpen");
end

function CharactersViewer_ResetBag()
   local bagFrame
   bagFrame = getglobal("CharactersViewer_ContainerFrame0");
   bagFrame:SetPoint("TOPLEFT", "CharactersViewer_Frame", "TOPRIGHT", 0,0 );
   bagFrame = getglobal("CharactersViewer_ContainerFrame1");
   bagFrame:SetPoint("TOPLEFT", "CharactersViewer_ContainerFrame0", "BOTTOMLEFT" );
   bagFrame = getglobal("CharactersViewer_ContainerFrame2");
   bagFrame:SetPoint("TOPLEFT", "CharactersViewer_ContainerFrame1", "BOTTOMLEFT" );
   bagFrame = getglobal("CharactersViewer_ContainerFrame3");
   bagFrame:SetPoint("TOPLEFT", "CharactersViewer_ContainerFrame0", "TOPRIGHT");
   bagFrame = getglobal("CharactersViewer_ContainerFrame4");
   bagFrame:SetPoint("TOPLEFT", "CharactersViewer_ContainerFrame3", "BOTTOMLEFT" );
end

-- Bag LUA --

function CharactersViewer_Bag_Toggle()
   if (CharactersViewerConfig["Bag_Display"] == true) then
      CharactersViewerConfig["Bag_Display"] = false;
      CharactersViewer_Bag_Hide();
   else
      CharactersViewerConfig["Bag_Display"] = true;
      CharactersViewer_Bag_Display();
   end
end

function CharactersViewer_Bag_ToggleButton_OnClick(arg1)
   if (arg1 == "LeftButton") then
      CharactersViewer_Bag_Toggle();
   elseif (arg1 == "RightButton") then
      CharactersViewer_ResetBag();
   end
end

function CharactersViewer_PaperDoll_Dropdown2_Toggle()
      --! enable button on/off
      local count = 0;
         for anything in CharactersViewerProfile[GetCVar("realmName")] do
      count = count + 1;
      end
      if ( count > 1 ) then
         getglobal("CharactersViewerDropDown2"):Show();
      else
         getglobal("CharactersViewerDropDown2"):Hide();
      end
end

-- Backward / inter-addons compatibility

-- Called By EquipCompare, soon to be removed, modified to fit with my new code - Flisher 2005-05-16

function CharactersViewerGetBSIIndex(forceRecreate)
   if (forceRecreate or not CharactersViewerCurrentIndex) then
      CharactersViewer.Switch();
   end;
   return CharactersViewer.index;       -- same as returning CharactersViewerCurrentIndex 
end


-- this one is also for Equipcompare interoperability:
CHARACTERSVIEWER_VERSION = CharactersViewer.version.number;
CharactersViewerCurrentIndex = nil; -- Not local so someone can hook to it

function CharactersViewer_Toggle()                 -- Changed by Flisher 2005-06-12
   CharactersViewer.Toggle();
end




