--[[
   Version: 0.71 (Cosmos Revision : $Rev: 2313 $)
   Last Changed by: $LastChangedBy: flisher $
   Date: $Date: 2005-08-17 12:58:13 -0500 (Wed, 17 Aug 2005) $

   Official Distribution site:   http://www.curse-gaming.com/mod.php?addid=490
   Also packaged in Cosmos: http://www.cosmosui.org

To make the lua file lighter, comment and update log are moved to a readme.txt

Change from 0.69 to 0.7x
-0.70: MailTo now switch when you change characters, by Flisher
-0.70: Fixed German/French localization of portrait, by Flisher
-0.70: Fixed problem when the first character of the name is an accent, by Flisher
-0.71: Fixed misc typo, internal push, by Flisher / LordRod
-0.71: Added Dropdown protection, they only contain "self" type now, guildmate (GCV) visible in guild pannel, by Flisher

Planned Milestone 1: "Fix / improvement release"
-Add anti level 60 rested xp
-Add level icon to portrait
-Redesign the placement of information in the frame as it sometime get out of the frame
-Add a total money tooltip over the money frame

Change from 0.67 to 0.69
-(0.68) Added a field containing the non-localized race/class, by Flisher
-(0.68) Added generic portrait per sex/race, by Flisher
-(0.68) Fixed the class/level display, by Flisher
-(0.69) Added support for MailTo, by Flisher and Vincent

Change from 0.65 to 0.67
-(0.66) Fixed the splitstring function, non-standard characters will be accepted now, by Flisher
-(0.66) Added current xp to data saved, by Flisher
-(0.66) Major GUI improved xp display, by Flisher
-(0.66) Added the "Resting" flag next to the CV portrait, by Flisher
-(0.67) Improved data collection for future inspect/remote integration, by Flisher
-(0.67) Added button in GuildPannel to see their data if know, by Flisher
-(0.67) Minor GUI improvement in headers, by Flisher

Change from 0.64 to 0.65
-(0.65) Fixed the caching validation on equiped item, by Flisher
-(0.65) Added MakeLink and DeLink data protection, by Flisher

Change from 0.59 to 0.64
Key Feature: "/cv List", Rested XP and Mailbox status and easier plugin integration.

-(0.60) Added GetItemInfo() to improve code feature, by Flisher
-(0.60) Added GetItemInfo() to prevent kickout of the game, by Flisher
-(0.60) Fixed the DB reinitialisation code, by Flisher
-(0.60) Reduced saved data space by using shorter link, by Flisher
-(0.60) Added a "/cv list" to display various information, by Flisher
-(0.60) Added a mailflag(no gui yet) and timestamp to profile, by Flisher
-(0.60) Added type of profile, for addons integration, by Flisher
-(0.61) Modification to Timestamp/Type by request of LordRod, by Flisher
-(0.61) Fixed the mail info retreival, by Flisher
-(0.61) Fixed Displaying of information to the new blizz format (few pixels...)
-(0.62) Added 2 .library function, MakeLink and Delink, by Flisher/LordRod
-(0.62) Fixed plugin tooltip from 0.60 change.
-(0.62) Added rested xp to "/cv list", by Flisher,
-(0.62) Bulletproofed textual information, by Flisher
-(0.63) Fixed the rested/resting part in "/cv list", by Flisher/LordRod
-(0.63) Fixed internal link function, by Flisher/LordRod
-(0.64) Fixed the calculated rested XP calculation, by Flisher
-(0.64) Addded Rested XP to the GUI, by Flisher
-(0.64) Added mailbox to the GUI, by Flisher

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
               this:UnregisterEvent(event);        -- Event that will be called for initialisation of the addon
            end
         end;
      };

   register =
      {  Event = function ()
            for index, event in CharactersViewer.constant.event do
               this:RegisterEvent(event);          -- Event that will be called for initialisation of the addon
            end
            CharactersViewer.status.register.event = true;
         end;

         hook = function ()
            if (Sea) then
               Sea.util.hook("Logout", "CharactersViewer.collect.all");
               Sea.util.hook("Quit", "CharactersViewer.collect.all");
               Sea.util.hook("GuildPlayerStatus_Update", "CharactersViewer.Note.Guild_OnUpdate");
            else
               CharactersViewer_ORIG_Logout = Logout;
               CharactersViewer_ORIG_Quit = Quit;
               CharactersViewer_ORIG_GuildPlayerStatus_Update = GuildStatus_Update;
               
               function Quit()
                  CharactersViewer.collect.all();
                  return CharactersViewer_ORIG_Quit();
               end
               function Logout()
                  CharactersViewer.collect.all();
                  return CharactersViewer_ORIG_Logout();
               end

               function GuildStatus_Update()
                  CharactersViewer.Note.Guild_OnUpdate();
                  CharactersViewer_ORIG_GuildPlayerStatus_Update();
               end

            end
            CharactersViewer.status.register.hook = true;
         end;
      
         cosmos = function ()                                  -- Cosmos Button Support --
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
            elseif(Cosmos_RegisterButton) then
               Cosmos_RegisterButton (
                  BINDING_HEADER_CHARACTERSVIEWER,
                  CHARACTERSVIEWER_SHORT_DESC,
                  CHARACTERSVIEWER_DESCRIPTION,
                  CHARACTERSVIEWER_ICON,
                  CharactersViewer.Toggle
               );
               CharactersViewer.status.register.cosmos = true;
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
            --! todo: Regster thing with cosmos slashcmd 
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
      CharactersViewer.register.cosmos();
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
      elseif (msg == CHARACTERSVIEWER_SUBCMD_LIST) then
         CharactersViewer.List();
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

   List = function ()
      if (CharactersViewerProfile and CharactersViewerProfile[GetCVar("realmName")]) then
         for index, item in CharactersViewerProfile[GetCVar("realmName")] do
            if (  CharactersViewerProfile[GetCVar("realmName")][index]["Type"] and CharactersViewerProfile[GetCVar("realmName")][index]["Type"] == "Self") then
               if ( CharactersViewerProfile[GetCVar("realmName")][index] and CharactersViewerProfile[GetCVar("realmName")][index]["Data"]) then
                  local output = index;
                  if (CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Id"] and CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Id"]["Class"]) then
                     output = output .. ", " .. CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Id"]["Class"];
                  end
                  if (CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Id"] and CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Id"]["Level"]) then
                     output = output .. ", " .. CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Id"]["Level"];
                  end
                  if (CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Location"] and CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Location"]["Zone"]) then
                     output = output .. ", " .. CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Location"]["Zone"];
                  end
                  if ( CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Mail"] and CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["Mail"]["HasNewMail"]) then
                     output = output .. ", " .. HAVE_MAIL;
                  end
                  if ( CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["xp"] ) then
                     local temp = CharactersViewer.library.CalcRestedXP( CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["xp"] );
                     if ( temp and temp.estimated > 0 ) then
                        output = output .. ", " .. temp.levelratio .. " " .. LEVEL .. " " .. CHARACTERSVIEWER_RESTED;
                     end
                     if ( CharactersViewerProfile[GetCVar("realmName")][index]["Data"]["xp"]["resting"] and temp.levelratio < 1.5 ) then
                        output = output .. ", " .. CHARACTERSVIEWER_RESTING;
                     end
                  end
                  DEFAULT_CHAT_FRAME:AddMessage(output);
               end
            end
         end
      end
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
            if (name["Type"] == "Self") then
               i = i + 1;
               temp[i] = j;
               if (j == CharactersViewer.index ) then
                  current = i;
               end
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
      choice2 = string.upper(string.sub(choice, 1,1)) .. string.lower(string.sub(choice , 2));  -- Make the first character upper, all the other lowercase.
      if (CharactersViewerProfile[GetCVar("realmName")][choice] ~= nil) then
         CharactersViewer.index = choice;
         CharactersViewerCurrentIndex = CharactersViewer.index;        -- Backward compatibility
      elseif (CharactersViewerProfile[GetCVar("realmName")][choice2] ~= nil) then
         CharactersViewer.index = choice2;
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
         basic = function (target)
            local temp = {};
            
            -- Set the mana pool if it's a mana user
            if ( UnitPowerType(target) and UnitPowerType(target) == 0 ) then
               if ( UnitManaMax(target) and UnitManaMax(target) > 0) then
                  temp["Mana"] = UnitManaMax(target);
               else
                  temp["Mana"] = "??";
               end
            end
            
            if (UnitHealthMax(target) and (UnitHealthMax(target) > 100 or target == "player") ) then
               temp["Health"] = UnitHealthMax(target);
            else
               temp["Health"] = "??";
            end
            
            if (target == "player") then
               temp["Defense"] = UnitDefense(target);
               -- Set the armor value
               local baseArm, effectiveArmor, armor, positiveArm, negativeArm = UnitArmor(target);
               temp["Armor"] = baseArm .. ":" .. (baseArm + positiveArm) .. ":" .. positiveArm; -- if they have a debuf on, don't save it
            end
            return temp;
         end;
         
         id = function (target)                    -- Flisher 2005-07-29
            local Race, RaceEn = UnitRace(target);
            local Class, ClassEn = UnitClass(target);
            local temp = {
               Sex = CharactersViewer.collect.sex(target, 0),
               SexId = CharactersViewer.collect.sex(target, 1),
               Race = Race,
               RaceEn = RaceEn,
               Class = Class,
               ClassEn = ClassEn,
               Level = UnitLevel(target),
               Server = GetCVar("realmName"),
               Name = UnitName(target),                               -- Added 2005-07-28 for easyness of access, by Flisher
            };
            return temp;
         end;

         location = function ()                    -- Flisher 2005-07-29
            return {
               Zone = GetZoneText(),
               SubZone = GetSubZoneText(),
            }
         
         end;

         xp = function()                           -- Flisher 2005-07-29
            return {
               max = UnitXPMax("player");
               current = UnitXP("player");
               resting = IsResting() == 1 or false;
               bonus = GetXPExhaustion();
               timestamp = time();
            }
         end;
         
         mail = function ()                        -- Flisher 2005-07-28
            local temp = {};
            temp["HasNewMail"] = HasNewMail() == 1 or false;
            return temp;
         end;
         
         sex = function (target, num)                         -- Flisher 2005-07-28
            local temp = "";
            temp = UnitSex(target);
            if ( (not num) or num == 0) then
               if (UnitSex(target) and UnitSex(target) == 0) then
                  temp = MALE;
               else
                  temp = FEMALE;
               end
            end
            return temp;
         end;
         
         guild = function (target)                       -- Flisher 2005-07-28
            local temp = {};
            temp["GuildName"], temp["Title"], temp["Rank"] = GetGuildInfo(target);
            return temp;
         end;
         
         stats = function ()                       -- Flisher 2005-07-28
            -- "stat" is the same as effectiveStat...
            -- problem here is if they have a debuff spell on, the values saved will be wrong
            local temp = {};
            for index = 1, 5 do
               local stat, effectiveStat, posBuff, negBuff = UnitStat("player", index);
               temp[index] = (stat - posBuff - negBuff) .. ":" .. effectiveStat .. ":" .. posBuff .. ":" .. negBuff;
            end
            return temp;
         end;

         resistance = function ()                  -- Flisher 2005-06-28
            local temp = {};
            for index = 2, 6 do
               local base, resistance, positive, negative = UnitResistance("player", index);
               temp[index] = resistance;
            end
            return temp;
         end;

         combatstats = function ()                 -- Flisher 2005-06-12
            local temp = {};
            temp["D"] = GetDodgeChance();
            if ( GetBlockChance() > 0) then
               temp["B"] = GetBlockChance();
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
                     temp["C"] = tmpStr;
                  elseif (spellName == PARRY) then
                     temp["P"] = GetParryChance();
                  end
               end
               spellIndex = spellIndex + 1;
               spellName,subSpellName = nil;
               spellName,subSpellName = GetSpellName(spellIndex,BOOKTYPE_SPELL);
            end
            return temp;
         end;

         honor = function (target)                    -- Flisher 2005-06-12
            local temp = {};
            if (UnitPVPRank(target) and GetPVPRankInfo(UnitPVPRank(target)) and UnitPVPRank(target) >= 1) then
               temp["rankName"], temp["rankNumber"] = GetPVPRankInfo(UnitPVPRank(target));
            end
            return temp;
         end;
         
         Equipment = function(target)                 -- Changed by Flisher 2005-06-12
            local link, texture ;
            temp = {}
            -- Initialise the equipments
            for index = 1, 19 do
               link = GetInventoryItemLink(target, index);
               texture = GetInventoryItemTexture(target, index);
               if( link ) then
                  for color, item, name in string.gfind(link, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r") do
                     if( color ~= nil and item ~= nil and name ~= nil ) then
                        temp[index] = { };
                        temp[index]["T"] = texture;
                        temp[index]["L"] = CharactersViewer.library.DeLink(link);
                        if ( GetInventoryItemCount(target, index) > 1 ) then
                           temp[index]["C"] = GetInventoryItemCount(target, index);
                        end
                     end
                  end
               end
            end
            return temp;
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
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag] = { };
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["name"] = bagname;
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["size"] = GetContainerNumSlots(bag);
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["L"] = CharactersViewer.library.DeLink(link);
                     CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag]["T"] = texture;
                     CharactersViewer.collect.Bag(bag);
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
                  CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Bag"][bag][slot]["L"] = CharactersViewer.library.DeLink(link);
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

            -- Initialise the type
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Type"] = "Self";
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Timestamp"] = time();

            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Data"] = {
                  Type = CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Type"];
                  Timestamp = CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Timestamp"];
                  Money = GetMoney(),
                  Guild = CharactersViewer.collect.guild("player");
                  Resists = CharactersViewer.collect.resistance();
                  Stats = CharactersViewer.collect.stats();
                  CombatStats = CharactersViewer.collect.combatstats();
                  Mail = CharactersViewer.collect.mail(false);
                  Id = CharactersViewer.collect.id("player");
                  Location = CharactersViewer.collect.location();
                  xp = CharactersViewer.collect.xp();
                  Honor = CharactersViewer.collect.honor("player");
                  Basic = CharactersViewer.collect.basic("player");
               }

            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Equipment"] = CharactersViewer.collect.Equipment("player");
            CharactersViewer.collect.Inventory();

            -- Set the status flag if data was collected at least once sicne the addon loaded
            if (not CharactersViewer.status.collected) then
               CharactersViewer.status.collected = true;
               CharactersViewer.Switch();
               CharactersViewer_PaperDoll_Dropdown2_Toggle();
            end
         end;

         inspect = function ()                      -- Created by Flisher 2005-08-10
            if ( UnitIsPlayer("target") and not UnitIsUnit("player", "target") and UnitName("target") ~= nil and UnitName("target") ~= UNKNOWNOBJECT and UnitName("target") ~= UKNOWNBEING ) then
               -- Properly initialize the SavedVariable if it do not exist
               if ( not CharactersViewerProfile ) then
                  CharactersViewerProfile = {};
               end
               -- Properly initialize the current realm if it do not exist
               if ( not CharactersViewerProfile[GetCVar("realmName")] ) then
                  CharactersViewerProfile[GetCVar("realmName")] = {};
               end
               -- Properly initialise the current character data
               CharactersViewerProfile[GetCVar("realmName")][UnitName("target")] = {};

               -- Initialise the type
               CharactersViewerProfile[GetCVar("realmName")][UnitName("target")]["Type"] = "Inspect";
               CharactersViewerProfile[GetCVar("realmName")][UnitName("target")]["Timestamp"] = time();

               CharactersViewerProfile[GetCVar("realmName")][UnitName("target")]["Data"] = {
                     Type = CharactersViewerProfile[GetCVar("realmName")][UnitName("target")]["Type"];
                     Timestamp = CharactersViewerProfile[GetCVar("realmName")][UnitName("target")]["Timestamp"];
                     Guild = CharactersViewer.collect.guild("target");
                     Id = CharactersViewer.collect.id("target");
                     Honor = CharactersViewer.collect.honor("target");
                     Basic = CharactersViewer.collect.basic("target");

                     --Money = GetMoney(),
                     --Resists = CharactersViewer.collect.resistance();
                     --Stats = CharactersViewer.collect.stats();
                     --CombatStats = CharactersViewer.collect.combatstats();
                     --Mail = CharactersViewer.collect.mail(false);
                     --Location = CharactersViewer.collect.location();
                     --xp = CharactersViewer.collect.xp();
                  }
               CharactersViewerProfile[GetCVar("realmName")][UnitName("target")]["Equipment"] = CharactersViewer.collect.Equipment("target");
               --CharactersViewer.collect.Inventory();

               CharactersViewer_PaperDoll_Dropdown2_Toggle();
            end
         end;
      };

   db = {
         validate = function ()
            if (CharactersViewerConfig and CharactersViewerConfig["version"] and CharactersViewerConfig["version"] == CharactersViewer.version.db ) then
               return true;
            else
               return false;
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
            for w in string.gfind(input, "([^ ]+)") do
               list[i] = w;
               i = i + 1;
            end
            return list;
         end;
         
         returnColor = function (quality)
            color = {
               [0] = "ff9d9d9d",    -- poor, gray
               [1] = "ffffffff",    -- common, white
               [2] = "ff1eff00",    -- uncommon, green
               [3] = "ff0070dd",    -- rare, blue
               [4] = "ffa335ee",    -- epic, purple
               [5] = "ffff8000",    -- legendary, orange
            }
            return color[quality];
         end;
         
         MakeLink = function(link)                -- by Flisher 2005-05-30, will create a fully qualified link from an item id
            local temp = link;
            if ( link and string.sub(link,1,5) == "item:") then
               local name,_,quality = GetItemInfo(link);
               local color = CharactersViewer.library.returnColor(quality);
               if (name) then
                  temp = "|c"..color.."|H"..link.."|h["..name.."]|h|r";
               else
                  temp = false;
               end
            end
            return temp;
         end;
         
         DeLink = function(link)                  -- by Flisher 2005-05-30, will return the item id from a fully qualified link.
            local temp = link;
            if ( link and string.sub(link,1,2) == "|c") then
               _,_,temp = strfind(link,"|H(item:%d+:%d+:%d+:%d+)|");
            end
            return temp;
         end;
         
         CalcRestedXP = function (data)
            local temp = {
               estimated = 0;
               levelratio = 0;
               percentrested = 0;
            }
            if (data and data["bonus"] and data["resting"] ~= nil and data["max"] and data["timestamp"]) then
               local speed = data.resting and 4 or 1;
               local estimated = data.bonus;
               if(data.timestamp < time()) then
                  estimated = data.bonus + floor((time()-data.timestamp) * data.max * 1.5 / 864000 / 4 * speed);
                  if(estimated  > (data.max * 1.5) ) then
                     estimated = (data.max * 1.5);
                  end
               end
               temp = {
                  estimated = estimated;
                  levelratio = floor(estimated/data.max *10)/10;
                  percentrested = floor(estimated / (data.max  *1.5) *100)/100;
               }
            end
            return temp;
         end;
      };

      Mail = {
         OnEnter = function()
            local count = "";
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
            if (MailTo_InFrame and MailTo_Mail and MailTo_Mail[GetCVar("realmName")][CharactersViewer.index]) then
               count = 0;
               for anything in MailTo_Mail[GetCVar("realmName")][CharactersViewer.index] do
                  count = count + 1;
               end
               count = " (" .. count ..")";
            end
            GameTooltip:SetText(HAVE_MAIL .. count .. "\n\n" .. CHARACTERSVIEWER_TOOLTIP_MAIL);
         end;
         
         OnClick = function(button)
            if (MailTo_InFrame) then
               if (arg1 == "LeftButton") then
                  if (MailTo_InFrame:IsVisible() ) then
                     MailTo_InFrame:Hide();
                  else
                     MailTo_inbox(CharactersViewer.index);
                  end
               elseif (arg1 == "RightButton") then
                  if (CharactersViewerConfig["MailTo_Location"] and CharactersViewerConfig["MailTo_Location"] == 1) then
                     MailTo_InFrame:SetPoint("TOPLEFT", "CharactersViewer_ContainerFrame3", "TOPRIGHT", 0,0 );
                     CharactersViewerConfig["MailTo_Location"] = 0;
                  else
                     MailTo_InFrame:SetPoint("TOPLEFT", "CharactersViewer_Frame", "TOPRIGHT", 0,0 );
                     CharactersViewerConfig["MailTo_Location"] = 1;
                  end
               end
            end
         end
      };
      
      Note = {
         Guild_OnUpdate = function ()
            local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame);
            if (GuildFrameButton1:IsVisible()) then
               for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
                  local button = getglobal("CharactersViewerGuildFrameNoteButton"..i);
                  local name = GetGuildRosterInfo(i + guildOffset);
                  if ( CharactersViewerProfile and CharactersViewerProfile[GetCVar("realmName")] and CharactersViewerProfile[GetCVar("realmName")][name]) then
                     button:Show();
                  else
                     button:Hide();
                  end
               end
            end
         end;
   
         Guild_OnClick = function (arg1)
            local name = GetGuildRosterInfo(this:GetID() + FauxScrollFrame_GetOffset(GuildListScrollFrame));
            if ( CharactersViewer.index ~= name ) then
               CharactersViewer.Switch(name);
               CharactersViewer_Show();
            else
               CharactersViewer_Toggle();
            end
         end;
         
         Guild_OnEnter = function ()
            ShowUIPanel(GameTooltip);
         GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
         GameTooltip:SetText(BINDING_NAME_CHARACTERSVIEWER_TOGGLE);
         end;
      };

   -- Variables
   index = nil;         -- is now initialised via the first data collect, wich should happen before any possible call
   loaded = nil;                             -- Successful load of the script
   version =
      {  db = 62;
         text = "0.71";
         number = 71;
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
               "MAIL_SHOW";
               "MAIL_CLOSE";
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
   --[[
   if (event == "MAIL_SHOW" or event == "MAIL_CLOSE") then
      if (CharactersViewerProfile and CharactersViewerProfile[GetCVar("realmName")]and CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]and
         CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Data"] ) then
            CharactersViewerProfile[GetCVar("realmName")][UnitName("player")]["Data"]["Mail"] = CharactersViewer.collect.mail(true);
      end
   end
   ]]--
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
      if ( GetItemInfo(link) ) then
         GameTooltip:SetHyperlink(link);
      else
         GameTooltip:SetText(CHARACTERSVIEWER_NOT_CACHED);
      end
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
      local name,_,quality = GetItemInfo(link);
      if (name) then
         if (not itemCount) then
            itemCount = 1;
         end
         TT_Clear();
         TT_TooltipCall(GameTooltip, name, CharactersViewer.library.MakeLink(link), quality, itemCount);
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
         else
            text = CharactersViewer.constant.inventorySlot.Name[slotid];
         end
      else
         -- Inventory item link
         local slot = math.mod(slotid, 100);
         local bag  = (slotid - slot - 100) / 100;
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L) then
            link = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"][bag][slot].L;
         else
            text = EMPTY;
         end
      end

      if (link) then
         if ( GetItemInfo(link) ) then
            tooltip:SetHyperlink(link);
            if (UnitName("player") ~= CharactersViewer.index) then
               tooltip:AddLine(CharactersViewer.index .. " " .. INVENTORY_TOOLTIP);
               tooltip:Show();
            else
               tooltip:Show();
            end
         else
            tooltip:SetText(CHARACTERSVIEWER_NOT_CACHED);
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
   link = CharactersViewer.library.MakeLink(link);
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
   local temp;
   if (CharactersViewer.index == UnitName("player")) then
      CharactersViewer.collect.all();
   end

   --[[
   color = ITEM_QUALITY_COLORS[1];
   if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Type"] ) then
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Type"] == "Inspect" ) then
         color = ITEM_QUALITY_COLORS[5 ];
      elseif (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Type"] == "Remote" ) then
         color = ITEM_QUALITY_COLORS[2];
      end
   end
   CharactersViewer_CharactersBgTextureTL:SetVertexColor(color.r, color.g, color.b);
   CharactersViewer_CharactersBgTextureTR:SetVertexColor(color.r, color.g, color.b);
   CharactersViewer_CharactersBgTextureBL:SetVertexColor(color.r, color.g, color.b);
   CharactersViewer_CharactersBgTextureBR:SetVertexColor(color.r, color.g, color.b);
   ]]--
   -- Character Name and location
   if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]) then

      -- "Name (Zone / SubZone)"
      temp = CharactersViewer.index;
      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Location"] ~= nil
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Location"]["Zone"] ~= nil
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Location"]["SubZone"] ~= nil ) then
         temp = temp .. " (" .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Location"]["Zone"] .. " - " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Location"]["SubZone"] .. ")";
      end
      CharactersViewer_FrameTopText1:SetText(temp);


      -- Character Honor Rank, Level, Race and Class
      temp = "";
      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"] ~= nil
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["Level"] ~= nil
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["Class"] ~= nil ) then
         temp = temp .. "Level " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["Level"] ..  " " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["Class"];
      end
      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Honor"] ~= nil
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Honor"]["rankNumber"] ~= nil
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Honor"]["rankName"] ~= nil) then
         temp  = temp .. " (Rank " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Honor"]["rankNumber"] .. ", " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Honor"]["rankName"] .. ")";
      end
      CharactersViewer_FrameTopText2:SetText(temp);


      -- Guild Rank and Name display initialisation
      temp = ""
      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Guild"]
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Guild"]["GuildName"]
       and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Guild"]["Title"] ) then
         temp = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Guild"]["Title"] .. " of " .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Guild"]["GuildName"];
      end
      CharactersViewer_FrameTopText3:SetText(temp);


      -- Characters stats (str agi spirit intel stam...)
      temp = { "", "", "", "", ""};
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Stats"]) then
         for index = 1, 5 do
            if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Stats"][index]) then
               local j = 0, stat, effectiveStat, posBuff, negBuff;
               for w in string.gfind(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Stats"][index], "%d+") do
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
            end
            temp[index] = effectiveStat;
         end
      end
      for index = 1, 5 do
         getglobal("CharactersViewer_FrameStatsTitle"..index):SetText(TEXT(getglobal("SPELL_STAT"..(index-1).."_NAME"))..":");
         getglobal("CharactersViewer_FrameStatsText"..index):SetText(temp[index]);
      end


      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]) then
         -- Initialise the armor display
         temp = "";
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]["Armor"]) then
            local j =0, stat, effectiveStat, posBuff, negBuff;
            for w in string.gfind(CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]["Armor"], "%d+") do
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
               temp = effectiveStat;
            end
         end
         CharactersViewer_FrameStatsTitle6:SetText(ARMOR_COLON);
         CharactersViewer_FrameStatsText6:SetText(temp);
         
         -- Initialise the Health display
         temp = "";
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]["Health"]) then
            temp = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]["Health"];
         end
         CharactersViewer_FrameDetailTitle1:SetText(HEALTH_COLON);
         CharactersViewer_FrameDetailText1:SetText(temp);

         -- Initialise the mana display
         temp = "";
         if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]["Mana"]) then
            temp = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Basic"]["Mana"];
         end
         CharactersViewer_FrameDetailTitle2:SetText(MANA_COLON);
         CharactersViewer_FrameDetailText2:SetText(temp);
      end


      -- Initialize the combats stats (crit, parry, dodge, block...)
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]) then
         temp = ""
         if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["C"] ) then
            temp = string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["C"] );
         end
         CharactersViewer_FrameDetailTitle3:SetText(CHARACTERSVIEWER_CRIT ..":");
         CharactersViewer_FrameDetailText3:SetText(temp);

         temp = "";
         if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["D"] ) then
            temp = string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["D"] );
         end
         CharactersViewer_FrameDetailTitle4:SetText(DODGE ..":");
         CharactersViewer_FrameDetailText4:SetText(temp);

         if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["B"] ) then
            CharactersViewer_FrameDetailTitle5:SetText(BLOCK ..":");
            CharactersViewer_FrameDetailText5:SetText( string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["B"] ));
         end
         CharactersViewer_FrameDetailTitle5:SetText("");
         CharactersViewer_FrameDetailText5:SetText("");

         if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["P"] ) then
            CharactersViewer_FrameDetailTitle6:SetText(PARRY ..":");
            CharactersViewer_FrameDetailText6:SetText( string.format("%01.2f%%", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["CombatStats"]["P"] ));
         else
            CharactersViewer_FrameDetailTitle6:SetText("");
            CharactersViewer_FrameDetailText6:SetText("");
         end
         if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"] ) then
            temp = CharactersViewer.library.CalcRestedXP( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"] );
            if ( temp and temp.levelratio ~= nil) then
               temp = temp.levelratio .. " " .. LEVEL .. " " .. CHARACTERSVIEWER_RESTED;
            else
               temp = "";
            end
            CharactersViewer_FrameDetailTitle7:SetText(XP .. ":");
            CharactersViewer_FrameDetailText7:SetText(temp);

            temp = "";
            if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"]["current"] ) then
               temp = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"]["current"];
            else
               temp = "??";
            end
            if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"]["max"] ) then
               temp = temp .. "/" .. CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"]["max"];
            else
               temp = temp .. "/??";
            end
            CharactersViewer_FrameDetailTitle8:SetText("");
            CharactersViewer_FrameDetailText8:SetText(temp);

            if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["xp"]["resting"] ) then
               CharactersViewer_RestedFrame:Show();
            else
               CharactersViewer_RestedFrame:Hide();
            end

            
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
         CharactersViewer_FrameDetailTitle7:SetText("");
         CharactersViewer_FrameDetailText7:SetText("");
         CharactersViewer_FrameDetailTitle8:SetText("");
         CharactersViewer_FrameDetailText8:SetText("");
         CharactersViewer_RestedFrame:Hide();
         CharactersViewer_MailFrame:Hide();
         CharactersViewer_MoneyFrame:Hide();
      end

      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Resists"]) then
         -- Initialise the various resistance display
         for index = 2, 6 do
            temp = "";
            if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Resists"][index] ) then
               temp = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Resists"][index];
            end
            getglobal("CharactersViewerMagicResText"..index):SetText(temp);
         end
      else
         for index = 2, 6 do
            getglobal("CharactersViewerMagicResText"..index):SetText("x");
         end
      end

      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Money"]) then
         MoneyFrame_Update("CharactersViewer_MoneyFrame", CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Money"]);
      else
         MoneyFrame_Update("CharactersViewer_MoneyFrame", 0 );
         CharactersViewer_MoneyFrame:Hide();
      end

      if (MailTo_InFrame and MailTo_Mail and MailTo_Mail[GetCVar("realmName")][CharactersViewer.index] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Type"] == "Self") then
         --if Inbox is already open, switch inbox to the current character
         if (MailTo_InFrame:IsVisible() ) then
            MailTo_inbox(CharactersViewer.index);
         end

         -- Count current know mail in the inbox
         local count = 0;
         for anything in MailTo_Mail[GetCVar("realmName")][CharactersViewer.index] do
            count = count + 1;
         end
         
         -- If there is 1 or more mail in inbox, or if mailflag is true, then display the icon with knwon mail.
         if ( count > 1 or (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Mail"] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Mail"]["HasNewMail"])) then
            SetItemButtonCount(getglobal("CharactersViewer_MailFrame"), count);
            CharactersViewer_MailFrame:Show();
         else
            CharactersViewer_MailFrame:Hide();
         end
      elseif ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Mail"] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Mail"]["HasNewMail"]) then
            SetItemButtonCount(getglobal("CharactersViewer_MailFrame"), 0);
         CharactersViewer_MailFrame:Show();
      else
         CharactersViewer_MailFrame:Hide();
      end
   end
   
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
   
   if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["SexId"] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["RaceEn"]) then
      local temprace, tempsex;
      if (CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["RaceEn"] == "Night Elf") then
         temprace = "NightElf";
      else
         temprace = CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["RaceEn"];
      end
      if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Data"]["Id"]["SexId"] == 0) then
         tempsex = "Male";
      else
         tempsex = "Female";
      end
      temp = "Interface\\CharacterFrame\\TemporaryPortrait-" .. tempsex .. "-" .. temprace;
   else
      temp = "Interface\\CharacterFrame\\TempPortrait";
   end
   CharactersViewer_PortraitTexure:SetTexture(temp);

   if ( CharactersViewerProfile and CharactersViewerProfile[GetCVar("realmName")] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Bag"] ) then
      CharactersViewer_Bag_Toggle_Button:Show();
   else
      CharactersViewer_Bag_Toggle_Button:Hide();
   end
   

   ShowUIPanel(CharactersViewer_Frame);
   
   -- bag
   if ( CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Type"] and CharactersViewerProfile[GetCVar("realmName")][CharactersViewer.index]["Type"] == "Self" ) then
      if (CharactersViewerConfig["Bag_Display"] == true) then
         CharactersViewer_Bag_Display();
      else
         CharactersViewer_Bag_Hide();
      end
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
      if (CharactersViewerProfile[GetCVar("realmName")][index]["Type"] == "Self") then
         local realm, player;
         info.text = index;
         info.value = index;
         info.func = CharactersViewerDropDown_OnClick;
         info.notCheckable = nil;
         info.keepShownOnClick = nil;
         UIDropDownMenu_AddButton(info);
      end
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


