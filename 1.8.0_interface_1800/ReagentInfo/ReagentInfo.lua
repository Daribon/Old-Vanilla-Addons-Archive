-- Reagent Info - Version 1.5.1
-- Author: Jerigord (GDI)
--
-- Dependencies: ReagentData (2.2.0 or higher)
-- Optional Dependencies: myAddOns
--
-- Description: Reagent Info modifies the World of Warcraft tooltip to display what
-- professions use the mousedover item as well as what skills acquire it or if any
-- classes use it as a spell reagent.  It allows users to disable any of the three
-- pieces of mouseover information as well as limit what professions are listed in
-- the mouseover.
--
-- Usage: To use Reagent Info, just mouseover various items in your pack, on the
-- ground, or at the auction house or click on item links in chat channels.  Reagent
-- Info also supports the following slash commands:
--
-- /ri enable - Enable tooltip information
-- /ri disable - Disable tooltip information
-- /ri clear - Clear the current character's settings, returning them to default
-- /ri clearall - Clear all Reagent Info settings (for all characters)
-- /ri config - Display the Reagent Info configuration screen.
--
-- Note: Reagent Info is dependent on my Reagent Data addon.  Reagent Data is a
-- standalone library that contains reagent information for all tradeskills in the
-- game as well as an API for easily accessing this data.  This information is
-- necessary for Reagent Info to function.  By packaging it as a separate addon with
-- API, other authors can make use of it as well and the more addons you have using
-- it, the better use you're getting out of your memory!

-------------
-- Changes --
-------------

-------------------
-- Version 1.5.1 --
-------------------

------------------
-- New Features --
------------------
--
-- * Updated for the 1.8 (1800) patch

---------------
-- Bug Fixes --
---------------
--
-- * Corrected a new nil error due to calling Blizzard's TradeSkillColor array
-- * Corrected a couple typos.  Thanks to DaemoN.

-------------------
-- Version 1.5.0 --
-------------------

------------------
-- New Features --
------------------
--
-- * Updated for the 1.7 (1700) patch
-- * Reagent Info can now optionally display usage information for certain quest
--   drops in Zul'Gurub.  This was because the looting situation was a pain in the
--   butt at first and I thought something like this might help other people out too.
--   When you mouse over a piece of Zul'Gurub loot (like Sandfury Coins), Reagent Info
--   can tell you what classes use the item and for what pieces of armor.  Like
--   everything else in Reagent Info, it can be disabled and has a color choice as well.

---------------
-- Bug Fixes --
---------------
--
-- * Reagent Info will no longer break shift clicking on item links
-- * Changed event hooks to prevent nil errors on zoning as of 1.7

--------------------------------------------------------------------
-- For a complete list of changes, please see the readme.txt file --
--------------------------------------------------------------------

---------------------
-- Local Variables --
---------------------

local ReagentInfoPlayer = nil;

-----------------------------------
-- Color Variables and Functions --
-----------------------------------

local ReagentInfo_DefaultColors = {
     ["UsedByColor"] = {r = 1.0, g = 0.82, b = 0.0 },
     ["GatheredByColor"] = { r = 0.0, g = 0.75, b = 0.8 },
     ["SpellReagentColor"] = { r = 1.0, g = 0.0, b = 1.0 },
     ["QuestItemsColor"] = { r = 1.0, g = 0.0, b = 0.0 },
};

local ReagentInfo_SetColorFunc = {
     ["UsedByColor"] = function(x) ReagentInfo_SetFontColor("UsedByColor") end,
     ["GatheredByColor"] = function(x) ReagentInfo_SetFontColor("GatheredByColor") end,
     ["SpellReagentColor"] = function(x) ReagentInfo_SetFontColor("SpellReagentColor") end,
     ["QuestItemsColor"] = function(x) ReagentInfo_SetFontColor("QuestItemsColor") end,
};

local ReagentInfo_TradeSkillTypeColor = {
     ["optimal"] = { r = 1.00, g = 0.50, b = 0.25 },
     ["medium"] = { r = 1.00, g = 1.00, b = 0.00 },
     ["easy"] = { r = 0.25, g = 0.75, b = 0.25 },
     ["trivial"] = { r = 0.50, g = 0.50, b = 0.50 },
};

--------------------
-- Function Hooks --
--------------------

local RI_OriginalContainerFrameItemButton_OnEnter;
local RI_OriginalContainerFrame_Update;
local RI_OriginalGameTooltip_SetLootItem;
local RI_OriginalGameTooltip_SetOwner;
local RI_OriginalGameTooltip_OnHide;
local RI_OriginalGameTooltip_ClearMoney;
local RI_OriginalSetItemRef;

-- If non-nil, check for appearance of GameTooltip for adding information
local RI_CheckTooltip;

-- If non-nil, don't add extra information to the tooltip on GameTooltip_ClearMoney
local RI_SuppressInfoAdd;

-- Timer for frequency of tooltip checks
local RI_CheckTimer = 0;

-- The current owner of the GameTooltip
local RI_GameToolTipOwner;

-- Current Tooltip frame
local RI_Tooltip = nil;

-- Boolean to watch if LootLink is running
local RI_LootLink = false;

-- Boolean to watch if ItemsMatrix is running
local RI_ItemsMatrix = false;

-- Hooks for the AllInOneInventory stuff.  Code courtesy of ItemsMatrix
local RI_OriginalAllInOneInventory_ModifyItemTooltip;

-- Hooks for the MyInventory stuff.  Code courtesy of ItemsMatrix
local RI_OriginalMyInventory_ContainerFrameItemButton_OnEnter;
local RI_OriginalMyInventoryFrame_Update;

-- Anti-freeze code taken from Quest-I-On.  Without getting too technical, there are certain
-- conditions where Reagent Info could cause a client to freeze indefinitely.  This would
-- most often happen on a new WoW install or when the player hadn't viewed his/her tradeskills
-- in a while.  What happens is that the TRADE_SKILL_SHOW event would fire, causing Reagent
-- Info to update its recipe list.  It would then loop through the recipes, reading in each one
-- and storing its data.  When it did this, it asked the server for some tradeskill information.
-- This could cause another TRADE_SKILL_SHOW event to fire, adding another event to the queue.
-- If the client had a lot of recipes and a lot of item links to request from the server,
-- it would actually fill the event queue and freeze the client.  This code will prevent this
-- from happening by only allowing Reagent Info to update its tradeskill lists once per second.

local RI_allowUpdates = true;
local RI_eventCooldown = 0;
local RI_eventCooldownTime = 1;
ReagentInfo_Version = "1.5.1";

-- ReagentInfo_Config - The only saved variable.  It contains all the player data.

-- ReagentInfo_FreshVar()
--
-- Creates ReagentInfo_Config and sets it to a default value.  It is then overwritten
-- after Warcraft loads the variables from the SavedVariables.lua file.

function ReagentInfo_FreshVar()
     ReagentInfo_Config = { };
end

ReagentInfo_FreshVar();

---------------
-- Functions --
---------------

---------------------
-- OnFoo Functions --
---------------------

-- ReagentInfo_OnEvent()
--
-- Reagent Info's event handler.  This handles the loading of player variables.

function ReagentInfo_OnEvent()
     if (event == "VARIABLES_LOADED") then
	  if(myAddOnsFrame) then
	       myAddOnsList.ReagentInfo = {name = REAGENTINFO, description = REAGENTINFO_DESC, version = tostring(ReagentInfo_Version), category = MYADDONS_CATEGORY_INVENTORY, frame = "ReagentInfo", optionsframe = "ReagentInfo_ConfigFrame"};
	end
     elseif (event == "PLAYER_ENTERING_WORLD") then
	  local playerName = UnitName("player");
	  local realmName = GetCVar("realmName");
	  if (playerName ~= nil and playerName ~= UNKNOWNOBJECT and realmName ~= nil and ReagentInfoPlayer == nil) then
	       ReagentInfoPlayer = ReagentInfo_GetPlayer();
	  end
     elseif (event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_UPDATE") then
	  -- This handles all tradeskill functions except Enchanting.
	  if (ReagentInfoPlayer ~= nil and ReagentInfoPlayer["ShowRecipes"] == 1 and TradeSkillFrame:IsVisible() and RI_allowUpdates) then
	       -- This prevents further update events from being handled if we're already processing one.
	       -- This is done to prevent the game from freezing under certain conditions.
	       RI_allowUpdates = false;
	       
	       for i=1, GetNumTradeSkills() do
		    local itemName, type, _, _ = GetTradeSkillInfo(i);
		    if (type ~= "header") then
			 if (ReagentInfoPlayer ~= nil) then
			      if (ReagentInfoPlayer["Tradeskill"] == nil) then
				   ReagentInfoPlayer["Tradeskill"] = {};
			      end
			      if (ReagentInfoPlayer["Recipe"] == nil) then
				   ReagentInfoPlayer["Recipe"] = {};
			      end
			      
			      for j=1, GetTradeSkillNumReagents(i) do
				   local reagentName, _, _, _ = GetTradeSkillReagentInfo(i, j);
				   
				   if (reagentName ~= nil) then
					if (ReagentInfoPlayer["Tradeskill"][reagentName] == nil) then
					     ReagentInfoPlayer["Tradeskill"][reagentName] = {};
					end
					if (ReagentInfoPlayer["Recipe"][itemName] == nil) then
					     ReagentInfoPlayer["Recipe"][itemName] = {};
					end
					
					ReagentInfoPlayer["Tradeskill"][reagentName][itemName] = 1;
					ReagentInfoPlayer["Recipe"][itemName] = ReagentInfo_ConvertLevelToInt(type);
				   end
			      end
			 end
		    end
	       end
	  end
     elseif (event == "CRAFT_SHOW" or event == "CRAFT_UPDATE") then
	  -- Enchanting still uses the Craft functions, so we have this code to handle that
	  if (ReagentInfoPlayer ~= nil and ReagentInfoPlayer["ShowRecipes"] == 1 and CraftFrame:IsVisible() and RI_allowUpdates) then
	       -- This prevents further update events from being handled if we're already processing one.
	       -- This is done to prevent the game from freezing under certain conditions.
	       RI_allowUpdates = false;
	       for i=1, GetNumCrafts() do
		    local itemName, _, type, _ = GetCraftInfo(i);
		    if (type ~= "header") then
			 if (ReagentInfoPlayer ~= nil) then
			      if (ReagentInfoPlayer["Tradeskill"] == nil) then
				   ReagentInfoPlayer["Tradeskill"] = {};
			      end
			      if (ReagentInfoPlayer["Recipe"] == nil) then
				   ReagentInfoPlayer["Recipe"] = {};
			      end
			      
			      for j=1, GetCraftNumReagents(i) do
				   local reagentName, _, _, _ = GetCraftReagentInfo(i, j);
				   
				   if (reagentName ~= nil) then
					if (ReagentInfoPlayer["Tradeskill"][reagentName] == nil) then
					     ReagentInfoPlayer["Tradeskill"][reagentName] = {};
					end
					if (ReagentInfoPlayer["Recipe"][itemName] == nil) then
					     ReagentInfoPlayer["Recipe"][itemName] = {};
					end
					
					ReagentInfoPlayer["Tradeskill"][reagentName][itemName] = 1;
					ReagentInfoPlayer["Recipe"][itemName] = ReagentInfo_ConvertLevelToInt(type);
				   end
			      end
			 end
		    end
	       end
	  end
     end
end

-- ReagentInfo_OnLoad()
--
-- Called when Reagent Info is loaded.  It registers for the necessary events,
-- sets up the necessary function hooks, and initializes the slash handler.

function ReagentInfo_OnLoad()
     this:RegisterEvent("PLAYER_ENTERING_WORLD");
     this:RegisterEvent("VARIABLES_LOADED");
     this:RegisterEvent("TRADE_SKILL_UPDATE");
     this:RegisterEvent("TRADE_SKILL_SHOW");
     this:RegisterEvent("CRAFT_SHOW");
     this:RegisterEvent("CRAFT_UPDATE");

     -- Hook the GameTooltip's ClearMoney function
     RI_OriginalGameTooltip_ClearMoney = GameTooltip_ClearMoney;
     GameTooltip_ClearMoney = ReagentInfo_GameTooltip_ClearMoney;

     -- Hook the GameTooltip's OnHide function
     RI_OriginalGameTooltip_OnHide = GameTooltip_OnHide;
     GameTooltip_OnHide = ReagentInfo_GameTooltip_OnHide;

     -- Hook the GameTooltip:SetOwner function
     RI_OriginalGameTooltip_SetOwner = GameTooltip.SetOwner;
     GameTooltip.SetOwner = ReagentInfo_GameTooltip_SetOwner;

     -- Hook the SetItemRef function
     RI_OriginalSetItemRef = SetItemRef;
     SetItemRef = ReagentInfo_SetItemRef;

     -- Hook LootLink's functions if they're available
     if (type(LootLink_AddExtraTooltipInfo) == "function") then
	  RI_LootLink = true;
	  ReagentInfo_Old_Tooltip_Hook = LootLink_AddExtraTooltipInfo;
	  LootLink_AddExtraTooltipInfo = ReagentInfo_Tooltip_Hook;
     end

     -- Hook ItemsMatrix's functions if they're available
     if (type(ItemsMatrix_AddExtraTooltipInfo) == "function") then
	  RI_ItemsMatrix = true;
     end

     -- Hook AIOI's stuff if it's available and we're not running LootLink or ItemsMatrix
     if(AllInOneInventory_Enabled and not RI_LootLink and not RI_ItemsMatrix) then
	  RI_OriginalAllInOneInventory_ModifyItemTooltip = AllInOneInventory_ModifyItemTooltip;
	  AllInOneInventory_ModifyItemTooltip = ReagentInfo_AllInOneInventory_ModifyItemTooltip;
     end

     --hook for myinventory
     if (MyInventoryProfile and not RI_LootLink and not RI_ItemsMatrix) then
	  RI_OriginalMyInventory_ContainerFrameItemButton_OnEnter = MyInventory_ContainerFrameItemButton_OnEnter;
	  MyInventory_ContainerFrameItemButton_OnEnter = ReagentInfo_MyInventory_ContainerFrameItemButton_OnEnter;
	  
	  RI_OriginalMyInventoryFrame_Update = MyInventoryFrame_Update;
	  MyInventoryFrame_Update = ReagentInfo_MyInventoryFrame_Update;
     end
     
     -- Hook the ContainerFrameItemButton_OnEnter, ContainerFrame_Update and GameTooltip:SetLootItem functions
     RI_OriginalContainerFrameItemButton_OnEnter = ContainerFrameItemButton_OnEnter;
     ContainerFrameItemButton_OnEnter = ReagentInfo_ContainerFrameItemButton_OnEnter;
     RI_OriginalContainerFrame_Update = ContainerFrame_Update;
     ContainerFrame_Update = ReagentInfo_ContainerFrame_Update;
     RI_OriginalGameTooltip_SetLootItem = GameTooltip.SetLootItem;
     GameTooltip.SetLootItem = ReagentInfo_GameTooltip_SetLootItem;

     SlashCmdList["REAGENTINFOCOMMAND"] = ReagentInfo_SlashHandler;
     SLASH_REAGENTINFOCOMMAND1 = "/reagentinfo";
     SLASH_REAGENTINFOCOMMAND2 = "/ri";     

     UIPanelWindows["ReagentInfo_ConfigFrame"] = {area = "center", pushable = 0};

     -- Have Reagent Data load its quest items now
     ReagentData_LoadQuestItems();

--     ReagentInfo_Chat(REAGENTINFO .. " " .. ReagentInfo_Version .. " " .. REAGENTINFO_LOADED);
   
--     UIErrorsFrame:AddMessage(REAGENTINFO .. " " .. ReagentInfo_Version .. " " .. REAGENTINFO_LOADED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);   
end

-- ReagentInfo_OnUpdate(elapsed)
--
-- Ensures that Reagent Info doesn't try and write to the tooltips too quickly.

function ReagentInfo_OnUpdate(elapsed)
     RI_CheckTimer = RI_CheckTimer + elapsed;

     if( RI_CheckTimer >= 0.1 ) then
	  if( RI_CheckTooltip ) then
	       RI_CheckTooltip = ReagentInfo_CheckTooltipInfo(RI_Tooltip);
	  end
	  RI_CheckTimer = 0;
     end

     -- If it's been more than a second since our last tradeskill update,
     -- we can allow the event to process again.
     if (not RI_allowUpdates) then
	  RI_eventCooldown = RI_eventCooldown + elapsed;
	  if (RI_eventCooldown > RI_eventCooldownTime) then

	       RI_eventCooldown = 0;
	       RI_allowUpdates = true;
	  end
     end
end

-----------------------
-- Primary Functions --
-----------------------

-- ReagentInfo_AddTooltipInfo(frame, name)
--
-- The main action function of the mod.  This routine adds the tooltip information for
-- item "name" to the tooltip "frame".  Like with most of the tooltip functions
-- in this addon, it's based off of code created by Norganna and Telo.

function ReagentInfo_AddTooltipInfo(frame, name)
     -- Failsafe code.  If ReagentInfoPlayer is nil (because player
     -- data isn't loaded), just exit.  Also exit if the user has
     -- the addon disabled.

     if (ReagentInfoPlayer == nil or ReagentInfoPlayer['Enabled'] == 0) then
	  return;
     end

     -- Profession handling code
     if (ReagentInfoPlayer['UsedBy'] == 1) then
	  -- First ask Reagent Data which professions use the specified item.
	  local professions = ReagentData_GetProfessions(name);

	  -- Next load our colors from the player's data
	  local red = ReagentInfoPlayer['UsedByColor'].r;
	  local green = ReagentInfoPlayer['UsedByColor'].g;
	  local blue = ReagentInfoPlayer['UsedByColor'].b;

	  -- If his colors are somehow nil (this shouldn't ever happen),
	  -- load the defaults.
	  if (red == nil) then
	       red = ReagentInfo_DefaultColors['UsedByColor'].r;
	  end
	  if (green == nil) then
	       green = ReagentInfo_DefaultColors['UsedByColor'].g;
	  end
	  if (blue == nil) then
	       blue = ReagentInfo_DefaultColors['UsedByColor'].b;
	  end
	  
	  -- Sort the resultant profession list alphabetically.
	  table.sort(professions);

	  -- text will hold the text to be written to the frame.
	  local text = "";
	  
	  -- count is used to keep track of how many professions have been
	  -- displayed on a line.  My experience has been that showing more than
	  -- three professions on a single line makes the tooltip way too large,
	  -- so I force a linewrap every three.

	  local count = 0;

	  -- Loop through the professions
	  for key, value in professions do
	       -- If the player is tracking the profession, proceed.
	       --
	       -- For reference, ReagentData['reverseprofessions'] takes the translated
	       -- name of a profession (such as "Blacksmithing") and turns it into the index
	       -- variable used by ReagentData ('blacksmithing').  It will do this for other
	       -- languages as well, provided Reagent Data knows about the alternate langauges.
	       --
	       -- This is all necessary because I use the index value for the settings to
	       -- prevent translation issues within Reagent Info.

	       if (ReagentInfoPlayer[ReagentData['reverseprofessions'][value]] == 1) then
		    text = text .. value .. ", ";
		    count = count + 1;
		    if (count == 3) then
			 text = text .. "\n";
			 count = 0;
		    end
	       end
	  end

	  -- Remove the last comma space from the text string.
	  text = gsub(text, "(.+), $", "%1");
	  
	  -- Add in the Professions prefix
	  if (text ~= "" and text ~= nil) then
	       text = REAGENTINFO_PROFESSIONS .. ": " .. text;
	  end
	  
	  -- Finally, update the frame
	  frame:AddLine(text, red, green, blue);
     end

     -- Gather skills handling code
     if (ReagentInfoPlayer['GatheredBy'] == 1) then
	  -- First ask Reagent Data which skills gather the specified item.
	  local gathering = ReagentData_GatheredBy(name);

	  -- Alphabetically sort the results
	  table.sort(gathering);

	  -- text will hold the string we add to the tooltip
	  local text = "";
     
	  -- Load the player's colors
	  local red = ReagentInfoPlayer['GatheredByColor'].r;
	  local green = ReagentInfoPlayer['GatheredByColor'].g;
	  local blue = ReagentInfoPlayer['GatheredByColor'].b;

	  -- If his colors are somehow nil (this shouldn't ever happen),
	  -- load the defaults.
	  if (red == nil) then
	       red = ReagentInfo_DefaultColors['GatheredByColor'].r;
	  end
	  if (green == nil) then
	       green = ReagentInfo_DefaultColors['GatheredByColor'].g;
	  end
	  if (blue == nil) then
	       blue = ReagentInfo_DefaultColors['GatheredByColor'].b;
	  end

	  -- Now loop through the results
	  for key, value in gathering do
	       -- If the player is tracking the skill, proceed.
	       --
	       -- For reference, ReagentData['reversegathering'] takes the translated
	       -- name of a profession (such as "Mining") and turns it into the index
	       -- variable used by ReagentData ('mining').  It will do this for other
	       -- languages as well, provided Reagent Data knows about the alternate langauges.
	       --
	       -- This is all necessary because I use the index value for the settings to
	       -- prevent translation issues within Reagent Info.

	       if (ReagentInfoPlayer[ReagentData['reversegathering'][value]] == 1) then
		    text = text .. value .. ", ";
	       end
	  end

	  -- Remove the last comma space from the text string
	  text = gsub(text, "(.+), $", "%1");
	  
	  -- Add the Gathered By prefix
	  if (text ~= "" and text ~= nil) then
	       text = REAGENTINFO_GATHEREDBY .. ": " .. text;
	  end
	  
	  -- Finally, add the text to the tooltip.
	  frame:AddLine(text, red, green, blue);
     end

     -- Spell Reagent handling code
     if (ReagentInfoPlayer['SpellReagents'] == 1) then
	  -- text will hold the string to add to the tooltip.
	  -- And, in case you're wondering, I have no idea
	  -- why I wrote the code in three different orders in the
	  -- three different sections.  I blame my cat.
	  local text = "";
     
	  -- Load the player's color choices
	  local red = ReagentInfoPlayer['SpellReagentColor'].r;
	  local green = ReagentInfoPlayer['SpellReagentColor'].g;
	  local blue = ReagentInfoPlayer['SpellReagentColor'].b;

	  -- If his colors are somehow nil (this shouldn't ever happen),
	  -- load the defaults.
	  if (red == nil) then
	       red = ReagentInfo_DefaultColors['SpellReagentColor'].r;
	  end
	  if (green == nil) then
	       green = ReagentInfo_DefaultColors['SpellReagentColor'].g;
	  end
	  if (blue == nil) then
	       blue = ReagentInfo_DefaultColors['SpellReagentColor'].b;
	  end

	  -- Ask Reagent Data what classes use the item as a spell reagent
	  local classes = ReagentData_ClassSpellReagent(name);

	  table.sort(classes);

	  for num, class in classes do
	       text = text .. class .. ", ";
	  end

	  -- Remove the last comma space from the text string
	  text = gsub(text, "(.+), $", "%1");

	  -- Add in the Spell Reagent prefix
	  if (text ~= "" and text ~= nil) then
	       text = REAGENTINFO_SPELLREAGENT .. ": " .. text;
	  end
	  
	  -- Finally, add the text to the tooltip
	  frame:AddLine(text, red, green, blue);
     end

     -- Quest Item handling code
     if (ReagentInfoPlayer['QuestItems'] == 1) then
	  local text = "";
     
	  -- Load the player's color choices
	  local red = ReagentInfoPlayer['QuestItemsColor'].r;
	  local green = ReagentInfoPlayer['QuestItemsColor'].g;
	  local blue = ReagentInfoPlayer['QuestItemsColor'].b;

	  -- If his colors are somehow nil (this shouldn't ever happen),
	  -- load the defaults.
	  if (red == nil) then
	       red = ReagentInfo_DefaultColors['QuestItemsColor'].r;
	  end
	  if (green == nil) then
	       green = ReagentInfo_DefaultColors['QuestItemsColor'].g;
	  end
	  if (blue == nil) then
	       blue = ReagentInfo_DefaultColors['QuestItemsColor'].b;
	  end

	  local zone = ReagentData_IsQuestItem(name, "");

	  -- If we got a zone back, continue
	  if (zone) then
	       text = "Quest item in zone: " .. zone;

	       frame:AddLine(text, red, green, blue);

	       local questuse = ReagentData_QuestUsage(name, zone);

	       if (questuse) then
		    for num, array in questuse do
			 for class, armor in array do
			      text = "   " .. class .. " (" .. armor .. ")";
			      
			      frame:AddLine(text, red, green, blue);
			 end
		    end
		    
	       end
	  end
     end

     -- Now show the recipes
     local returnTable = {};
     if (ReagentInfoPlayer["Tradeskill"] ~= nil and ReagentInfoPlayer["Tradeskill"][name] ~= nil and ReagentInfoPlayer["ShowRecipes"] == 1) then
	  local recipes = ReagentInfoPlayer["Tradeskill"][name];
	  returnTable = ReagentInfo_ProcessRecipes(frame, recipes, ReagentInfoPlayer, 1);
     end

     if (getn(returnTable) > 0) then
	  frame:AddLine(REAGENTINFO_USEDIN, 0, 1, 0);

	  for num, recipe in returnTable do
	       -- Grab the difficulty color from Blizzard's own color array
	       local difficulty = ReagentInfo_TradeSkillTypeColor[ReagentInfo_ConvertIntToLevel(recipe.difficulty)];

	       -- Add the line to the frame.
	       frame:AddLine(recipe.name, difficulty.r, difficulty.g, difficulty.b);
	  end
     end

     -- Now show the recipes for alts

     -- Note to self: WTF is "found" used for?
--     local found = false;
     local realm = GetCVar("realmName");
     local faction = UnitFactionGroup("player");
     
     for key, RItemp in ReagentInfo_Config do
	  if (string.find(key, "-" .. realm) and RItemp["Faction"] ~= nil and RItemp["Faction"] == faction and RItemp ~= ReagentInfoPlayer) then
	       local character = string.gsub(key, "(.+)-" .. realm, "%1");

	       local returnTable = {};
	       -- FIX ME
	       if (RItemp["Tradeskill"] ~= nil and RItemp["Tradeskill"][name] ~= nil and ReagentInfoPlayer["ShowOther"] == 1) then
--	       if (RItemp["Tradeskill"] ~= nil and RItemp["Tradeskill"][name] ~= nil) then
		    local recipes = RItemp["Tradeskill"][name];
		    returnTable = ReagentInfo_ProcessRecipes(frame, recipes, RItemp, 1);
	       end
	       
	       if (getn(returnTable) > 0) then
--		    if (not found) then
			 frame:AddLine(REAGENTINFO_USEDBY .. " " .. character, 0, 1, 0);
--			 found = true;
--		    end
		    
		    for num, recipe in returnTable do
			 -- Grab the difficulty color from Blizzard's own color array
			 local difficulty = ReagentInfo_TradeSkillTypeColor[ReagentInfo_ConvertIntToLevel(recipe.difficulty)];
			 
			 -- Add the line to the frame.
			 frame:AddLine(recipe.name, difficulty.r, difficulty.g, difficulty.b);
		    end
	       end
	  end
     end

     -- Done, so show the frame
     frame.riDone = 1;
     frame:Show();
end

-- ReagentInfo_Chat(msg)
-- Prints a chat message to the screen.  The messages are printed in green and
-- prefaced by <RI>.  This is mainly used for debugging, though it does show
-- usage information for when the mod is loaded.

function ReagentInfo_Chat(msg)
   if( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage("<RI> "..msg, 0.0, 1.0, 0.0);
   end
end

-- ReagentInfo_CheckTooltipInfo(frame)
--
-- Checks the tooltip info for an item name.  If one is found and we haven't
-- updated the tip already, process it.

function ReagentInfo_CheckTooltipInfo(frame)
     -- If we've already added our information, no need to do it again
     if ( not frame or frame.riDone or RI_LootLink or RI_ItemsMatrix) then
	  return nil;
     end

     RI_Tooltip = frame;

     if( frame:IsVisible() ) then
	  local field = getglobal(frame:GetName().."TextLeft1");
	  if( field and field:IsVisible() ) then
	       local name = field:GetText();
	       if( name ) then
		    ReagentInfo_AddTooltipInfo(frame, name);
		    return nil;
	       end
	  end
     end
	
     return 1;
end

-- ReagentInfo_ConvertIntoToLevel(int)
--
-- Converts an integer (0-3) into the text representation of 
-- tradeskill difficulty (trivial, easy, medium, optimal).  If it 
-- gets an int outside this range, it returns trivial.

function ReagentInfo_ConvertIntToLevel(int)
     if (int == 3) then
	  return "optimal";
     elseif (int == 2) then
	  return "medium";
     elseif (int == 1) then
	  return "easy";
     else
	  return "trivial";
     end
end

-- ReagentInfo_ConvertLevelToInt(level)
--
-- Converts the text representation of tradeskill difficulty
-- (trivial, easy, medium, optimal) into an integer (0-3).  If it
-- gets something it doesn't understand, it returns 0.

function ReagentInfo_ConvertLevelToInt(level)
     if (level == "optimal") then
	  return 3;
     elseif (level == "medium") then
	  return 2;
     elseif (level == "easy") then
	  return 1;
     else
	  return 0;
     end
end

-- ReagentInfo_ProcessRecipes(frame, recipes, player, level)
--
-- Warning: This is a recursive function.  If you don't understand recursion,
-- please don't try and mess with this.  :-)
--
-- This function builds the item trees from the reagents.  It takes a tooltip frame
-- to update, a recipe array, and a recursion level as arguments.  The level is used
-- to prevent cases of extreme or infinite recursion by limiting the depth to four.
-- The function then goes through the recipe table, sorts it based upon difficulty,
-- pulls out the number of recipes the player requested, and begins printing them to
-- the frame.  If one of the lines it prints is used as a reagent in another recipe,
-- it recurses down another level and continues the process.
--
-- This is especially cool with the engineering profession.  :-)

function ReagentInfo_ProcessRecipes(frame, recipes, player, level)
     -- Failsafe code.  Leave if we get invalid arguments.
     if (not frame or not recipes) then
	  return;
     end

     -- If level isn't defined for some silly reason, set it to one.
     if (not level) then
	  level = 1;
     end

     -- Dropout code.  If we hit a level greater than four, leave.  This prevents
     -- making massive tooltips and also prevents infinite recursion conditions.
     if (level > 4) then
	  return;
     end

     -- tempTable will hold a formatted reagent list
     local tempTable = {};

     -- This is a silly loop that merges data from the ["Tradeskill"] and ["Recipe"] data
     -- arrays in the player's configuration data.  This allows me to have the flexible storage
     -- I wanted for easy data lookup and still allows for sorting based upon difficulty via the
     -- tempTable array.

     for name in recipes do
	  tinsert(tempTable, {name=name, difficulty=player["Recipe"][name]});
     end

     table.sort(tempTable, function(a, b) return a.difficulty > b.difficulty end);

     -- toPrint will hold the reagents to be printed
     local toPrint = {};

     -- Define our counting variables.  Set a default maxCount of 5 just in case the player
     -- somehow hasn't defined a number. 
     local count = 0;
     local maxCount = 5;
     if (ReagentInfoPlayer["NumRecipes"] ~= nil) then
	  maxCount = ReagentInfoPlayer["NumRecipes"];
     end
     
     -- This sets our lead in character (for visual interest only)
     local char = "- ";
     if (math.mod(level, 2) == 0) then
	  char = "+ ";
     end

     -- At last, loop through toPrint and add them to the frame.
     for num, recipe in tempTable do
	  if (count == maxCount) then
	       return toPrint;
	  end

	  local added = false;

	  if (recipe.difficulty >= ReagentInfoPlayer["RecipeThreshold"]) then
	       tinsert(toPrint, {name=string.rep("   ", level) .. char .. recipe.name, difficulty=recipe.difficulty});
	       count = count + 1;
	       added = true;
	  end
	       
	  if (count == maxCount) then
	       return toPrint;
	  end

	  -- And if the reagent we just displayed is used in other recipes, recurse deeper!
	  local returnTable = {};

	  if (player["Tradeskill"][recipe.name] ~= nil and player["Recurse"] == 1) then
	       returnTable = ReagentInfo_ProcessRecipes(frame, player["Tradeskill"][recipe.name], player, level + 1) or {};
	  end

	  if (getn(returnTable) > 0) then
	       if (not added and count < maxCount) then
		    tinsert(toPrint, {name=string.rep("   ", level) .. char .. recipe.name, difficulty=recipe.difficulty});
		    count = count + 1;
		    added = true;
	       end

	       for subN, subRecipe in returnTable do
		    tinsert(toPrint, {name=subRecipe.name, difficulty=subRecipe.difficulty});
	       end
	  end
     end

     return toPrint;
end

-- ReagentInfo_SlashHandler(msg)
-- This function is called when a user types one of your slash commands
-- the text they enter after the command comes in msg

function ReagentInfo_SlashHandler(msg)
     if (msg) then
	  msg = string.lower(msg);
	  
	  if (string.find(msg, "config")) then
--	       ShowUIPanel(ReagentInfo_ConfigFrame);
	       ReagentInfo_ConfigFrame:Show();
	  elseif (string.find(msg, "enable")) then
	       ReagentInfo_Chat(REAGENTINFO_ENABLED);
	       ReagentInfoPlayer['Enabled'] = 1;
	  elseif (string.find(msg, "disable")) then
	       ReagentInfo_Chat(REAGENTINFO_DISABLED);
	       ReagentInfoPlayer['Enabled'] = 0;
	  elseif (string.find(msg, "clearall")) then
	       ReagentInfo_FreshVar();
	       ReagentInfoPlayer = ReagentInfo_GetPlayer();
	  elseif (string.find(msg, "clear")) then
	       ReagentInfo_NewPlayer(UnitName("player"), GetCVar("realmName"));
	       ReagentInfoPlayer = ReagentInfo_GetPlayer();
	  else
	       ReagentInfo_Chat(REAGENTINFO_USAGE);
	  end
     else
	  ReagentInfo_Chat(REAGENTINFO_USAGE);
     end
end

------------------------------
-- Player Options Functions --
------------------------------

-- ReagentInfo_GetPlayer
-- Loads the settings for the current player.  If the player has no
-- settings, it calls ReagentInfo_NewPlayer().

function ReagentInfo_GetPlayer()
   if (UnitName("player") == nil or UnitName("player") == UNKNOWNOBJECT or GetCVar("realmName") == nil) then
	return;
   end

   if (ReagentInfo_Config[UnitName("player") .. "-" .. GetCVar("realmName")] == nil) then
      ReagentInfo_NewPlayer(UnitName("player"), GetCVar("realmName"));
   end
   
   local RItempPlayer = ReagentInfo_Config[UnitName("player") .. "-" .. GetCVar("realmName")];

   -- Failsafe code.  May be able to remove it later
   if (RItempPlayer == nil) then
	return;
   end

   -- Upgrade code
--   if (RItempPlayer["Version"] == nil or tostring(RItempPlayer["Version"]) ~=  ReagentInfo_Version) then
--	ReagentInfo_Chat(REAGENTINFO_UPGRADE);

   if (not RItempPlayer["Tradeskill"]) then
	RItempPlayer["Tradeskill"] = {};
	
	-- Display a warning message
	message(REAGENTINFO_TRADESKILLWARNING);
   end
	
   if (not RItempPlayer["Recipe"]) then
	RItempPlayer["Recipe"] = {};
   end
   
   if (not RItempPlayer["Recurse"]) then
	RItempPlayer["Recurse"] = 1;
   end
   
   if (not RItempPlayer["ShowRecipes"]) then
	RItempPlayer["ShowRecipes"] = 1;
   end
   
   if (not RItempPlayer["NumRecipes"]) then
	RItempPlayer["NumRecipes"] = 5;
   end
   
   if (not RItempPlayer["RecipeThreshold"]) then
	RItempPlayer["RecipeThreshold"] = 3;
   end
   
   if (not RItempPlayer["Faction"]) then
	RItempPlayer["Faction"] = UnitFactionGroup("player");
   end
   
   if (not RItempPlayer["QuestItems"]) then
	RItempPlayer["QuestItems"] = 1;
   end

   if (not RItempPlayer["UsedByColor"]) then
	RItempPlayer["UsedByColor"] = ReagentInfo_DefaultColors["UsedByColor"];
   end

   if (not RItempPlayer["GatheredByColor"]) then
	RItempPlayer["GatheredByColor"] = ReagentInfo_DefaultColors["GatheredByColor"];
   end

   if (not RItempPlayer["SpellReagentColor"]) then
	RItempPlayer["SpellReagentColor"] = ReagentInfo_DefaultColors["SpellReagentColor"];
   end

   if (not RItempPlayer["QuestItemsColor"]) then
	RItempPlayer["QuestItemsColor"] = ReagentInfo_DefaultColors["QuestItemsColor"];
   end
   
   RItempPlayer["Version"] = ReagentInfo_Version;
--end

   return RItempPlayer;
end

-- ReagentInfo_NewPlayer(PlayerName, RealmName)
-- Initializes the configuration for a new player

function ReagentInfo_NewPlayer(PlayerName, RealmName)
     ReagentInfo_Chat(REAGENTINFO_CREATINGPLAYER .. " " .. PlayerName .. " " .. REAGENTINFO_SERVER .. " " .. RealmName);

     ReagentInfo_Config[PlayerName .. "-" .. RealmName] = { 
	  ["Enabled"] = 1,
	  ["UsedBy"] = 1,
	  ["GatheredBy"] = 1,
	  ["NumRecipes"] = 5,
	  ["Recurse"] = 1,
	  ["ShowRecipes"] = 1,
	  ["SpellReagents"] = 1,
	  ["QuestItems"] = 1,
	  ["Tradeskill"] = {},
	  ["Recipe"] = {},
	  ["Version"] = ReagentInfo_Version;
	  ["RecipeThreshold"] = 3;
	  ["TooltipLoc"] = REAGENTINFO_DROPDOWN_BOTTOM;
	  ["Faction"] = UnitFactionGroup("player");
     };

     -- Enable professions by default
     for profession in ReagentData['professions'] do
	  ReagentInfo_Config[PlayerName .. "-" .. RealmName][profession] = 1;
     end

     -- Enable gather skills by default
     for profession in ReagentData['gathering'] do
	  ReagentInfo_Config[PlayerName .. "-" .. RealmName][profession] = 1;
     end

     -- Set the default colors
     for title, colors in ReagentInfo_DefaultColors do
	  ReagentInfo_Config[PlayerName .. "-" .. RealmName][title] = colors;
     end

     -- Display a warning message
     message(REAGENTINFO_TRADESKILLWARNING);
end

------------------------------------
-- Configuration Screen Functions --
------------------------------------

-- ReagentInfo_CheckButton_OnShow()
--
-- Sets the checked status of the config window's check buttons when they're shown

function ReagentInfo_CheckButton_OnShow()
     local name = this:GetName();

     if (name == nil or ReagentInfoPlayer == nil) then
	  return;
     end

     if (string.find(name, "ReagentInfo_CheckButton")) then
	  -- Set the button's label
	  local button = getglobal(name .. "Text");
	  local label = getglobal(name .. "_Label");
	  button:SetText(label);

	  -- Now set if it's checked
	  local buttonName = string.gsub(name, "ReagentInfo_CheckButton_(.+)", "%1");
	  local checked = 0;
	  if (ReagentInfoPlayer[buttonName] == 1) then
	       checked = 1;
	  end

	  this:SetChecked(checked);
     elseif (string.find(name, "ReagentInfo_Profession")) then
	  local buttonName = string.gsub(name, "ReagentInfo_Profession_(.+)", "%1");

	  local label = ReagentData['professions'][buttonName];

	  -- Set the button's label
	  local button = getglobal(name .. "Text");
	  button:SetText(label);

	  -- Now set if it's checked
	  local checked = 0;
	  if (ReagentInfoPlayer[buttonName] == 1) then
	       checked = 1;
	  end

	  this:SetChecked(checked);
     elseif (string.find(name, "ReagentInfo_Gathering")) then
	  local buttonName = string.gsub(name, "ReagentInfo_Gathering_(.+)", "%1");

	  local label = ReagentData['gathering'][buttonName];

	  -- Set the button's label
	  local button = getglobal(name .. "Text");
	  button:SetText(label);

	  -- Now set if it's checked
	  local checked = 0;
	  if (ReagentInfoPlayer[buttonName] == 1) then
	       checked = 1;
	  end

	  this:SetChecked(checked);
     end
end

-- ReagentInfo_ColorSelect_OnLoad
--
-- Sets the appropriate color for the color swatches on the config screen and
-- labels them as well.

function ReagentInfo_ColorSelect_OnLoad()
     local swatch, frame;

     for title, colors in ReagentInfo_DefaultColors do
	  swatch = getglobal("ReagentInfo_ColorSelect_" .. title .. "_ColorSwatchNormalTexture");
	  frame = getglobal("ReagentInfo_ColorSelect_" .. title);
	  local label = getglobal("ReagentInfo_ColorSelect_" .. title .. "_ColorSwatchText");

	  local set_red = colors.r;
	  local set_green = colors.g;
	  local set_blue = colors.b;

	  if (ReagentInfoPlayer[title] ~= nil) then
	       set_red = ReagentInfoPlayer[title].r;
	       set_green = ReagentInfoPlayer[title].g;
	       set_blue = ReagentInfoPlayer[title].b;
	  end

	  frame.r = set_red;
	  frame.g = set_green;
	  frame.b = set_blue;
	  frame.swatchFunc = ReagentInfo_SetColorFunc[title];

	  swatch:SetVertexColor(set_red, set_green, set_blue);

	  label:SetText(REAGENTINFO_COLORNAMES[title] .. " Color");
     end
end

-- ReagentInfo_ConfigFrame_OnClick()
--
-- A function for handling clicking on the config screen's checkboxes.

function ReagentInfo_ConfigFrame_OnClick()
     local name = this:GetName();

     if (name == nil) then
	  return;
     end

     if (string.find(name, "ReagentInfo_CheckButton")) then
	  -- We're dealing with a check button
	  local button = string.gsub(name, "ReagentInfo_CheckButton_(.+)", "%1");

	  ReagentInfo_ToggleButton(button, this:GetChecked());
     elseif (string.find(name, "ReagentInfo_Profession")) then
	  -- We're dealing with a profession check button
	  local button = string.gsub(name, "ReagentInfo_Profession_(.+)", "%1");

	  ReagentInfo_ToggleButton(button, this:GetChecked());
     elseif (string.find(name, "ReagentInfo_Gathering")) then
	  -- We're dealing with a gather skill check button
	  local button = string.gsub(name, "ReagentInfo_Gathering_(.+)", "%1");

	  ReagentInfo_ToggleButton(button, this:GetChecked());
     else
	  -- Failsafe condition that shouldn't happen.
	  ReagentInfo_Chat("Unknown Object Received");
     end
end

-- ReagentInfo_ConfigFrame_OnShow()
--
-- Called when the config frame is shown.  Pretty much only sets up the color swatches.

function ReagentInfo_ConfigFrame_OnShow()
     ReagentInfo_ColorSelect_OnLoad();
end

-- ReagentInfo_NumRecipes_OnShow()
--
-- Sets the value of the NumRecipes edit box when it's displayed

function ReagentInfo_NumRecipes_OnShow()
     if (ReagentInfoPlayer["NumRecipes"] ~= nil) then
	  ReagentInfo_NumRecipes:SetText(ReagentInfoPlayer["NumRecipes"]);
     else
	  ReagentInfo_NumRecipes:SetText(0);
     end
end

-- ReagentInfo_SetEdit(option)
--
-- A semi-generic routine for setting the value of player options based upon the
-- contents of an edit box.

function ReagentInfo_SetEdit(option)
     if (not option or getglobal("ReagentInfo_" .. option) == nil) then
	  return;
     end

     local value = tonumber(getglobal("ReagentInfo_" .. option):GetText());

     if (value == nil or value == 0) then
	  value = 1;
     end

     if (value > 9) then
	  value = 9;
     end

     ReagentInfoPlayer[option] = value;
end

-- ReagentInfo_SetFontColor(font)
--
-- Sets the colors for the swatches and updates the player's settings when the color
-- frame is closed.

function ReagentInfo_SetFontColor(font)
     local set_red, set_green, set_blue = ColorPickerFrame:GetColorRGB();

     ReagentInfoPlayer[font] = {r = set_red, g = set_green, b = set_blue};
     
     swatch = getglobal("ReagentInfo_ColorSelect_" .. font .. "_ColorSwatchNormalTexture");
     frame = getglobal("ReagentInfo_ColorSelect_" .. font);
     
     frame.r = set_red;
     frame.g = set_green;
     frame.b = set_blue;
     frame.swatchFunc = ReagentInfo_SetColorFunc[font];
     
     swatch:SetVertexColor(set_red, set_green, set_blue);
end

-- ReagentInfo_SetHelpText(text)
--
-- Updates the little help frame at the bottom of the config window.
-- I like it and think it's fun.  Deal or I'll send the April Fool's murloc
-- sound after you.

function ReagentInfo_SetHelpText(text)
     if (text == "clear") then
	  ReagentInfo_ConfigFrame_Help_Text:SetText("");
     else
	  local name = this:GetName();
	  local text = getglobal(name .. "_HelpText");
	  ReagentInfo_ConfigFrame_Help_Text:SetText(text);
     end
     
     ReagentInfo_ConfigFrame_Help_Text:SetWidth(300);
end

-- ReagentInfo_ToggleButton(buttonName, checked)
-- Toggles the bit associated with the specified button

function ReagentInfo_ToggleButton(buttonName, checked)
     if (checked == nil) then
	  checked = 0;
     end

     ReagentInfoPlayer[buttonName] = checked;
end

----------------------
-- Helper Functions --
----------------------

-- ReagentInfo_NameFromLink(link)
--
-- Grabs an item's name from its link.  This code is directly from LootLink, so 
-- full props go to Telo.  Well go on, start propping him!

local function ReagentInfo_NameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end

-- Calling this will allow Reagent Info to automatically add information to tooltips when needed
function ReagentInfo_AutoInfoOn()
	lSuppressInfoAdd = nil;
end

-- Calling this will prevent Reagent Info from automatically adding information to tooltips
function ReagentInfo_AutoInfoOff()
	lSuppressInfoAdd = 1;
end

--------------------
-- Hook Functions --
--------------------

-- These are all hooking functions.  They simply replace the built in game functions
-- with ones in Reagent Info.  They're all taken directly from Norganna and Telo's code
-- bases.  Nothing to see here.

function ReagentInfo_ContainerFrameItemButton_OnEnter()
     RI_OriginalContainerFrameItemButton_OnEnter();
     ReagentInfo_AutoInfoOff();

     if (RI_LootLink or RI_ItemsMatrix) then
	  ReagentInfo_AutoInfoOn();
	  return;
     end

--     if( not InRepairMode() and not MerchantFrame:IsVisible() ) then
     if (not InRepairMode()) then
	  local frameID = this:GetParent():GetID();
	  local buttonID = this:GetID();
	  local link = GetContainerItemLink(frameID, buttonID);
	  local name = ReagentInfo_NameFromLink(link);
	  
	  if( name ) then
	       local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID);
--	       ReagentInfo_AddTooltipInfo(GameTooltip, name);
	       ReagentInfo_CheckTooltipInfo(GameTooltip);
	       GameTooltip:Show();
	  end
     end
     ReagentInfo_AutoInfoOn();
end

function ReagentInfo_ContainerFrame_Update(frame)
     RI_OriginalContainerFrame_Update(frame);
     ReagentInfo_AutoInfoOff();

     if (RI_LootLink or RI_ItemsMatrix) then
	  ReagentInfo_AutoInfoOn();
	  return;
     end

--     if( not InRepairMode() and not MerchantFrame:IsVisible() and GameTooltip:IsVisible() ) then
     if( not InRepairMode() and GameTooltip:IsVisible() ) then
	  local frameID = frame:GetID();
	  local frameName = frame:GetName();
	  local iButton;
	  for iButton = 1, frame.size do
	       local button = getglobal(frameName.."Item"..iButton);
	       if( GameTooltip:IsOwned(button) ) then
		    local buttonID = button:GetID();
		    local link = GetContainerItemLink(frameID, buttonID);
		    local name = ReagentInfo_NameFromLink(link);
		    
		    if( name ) then
			 local texture, itemCount, locked, quality, readable = GetContainerItemInfo(frameID, buttonID);
--			 ReagentInfo_AddTooltipInfo(GameTooltip, name);
			 ReagentInfo_CheckTooltipInfo(GameTooltip);
			 GameTooltip:Show();
		    end
	       end
	  end
     end
     ReagentInfo_AutoInfoOn();
end

function ReagentInfo_GameTooltip_ClearMoney()
     RI_OriginalGameTooltip_ClearMoney();
     if (not RI_SupressInfoAdd) then
	  RI_CheckTooltip = ReagentInfo_CheckTooltipInfo(GameTooltip);
     end
end

function ReagentInfo_GameTooltip_OnHide()
     RI_OriginalGameTooltip_OnHide();
     GameTooltip.riDone = nil;
     if ( RI_Tooltip ) then
	  RI_Tooltip.riDone = nil;
	  RI_Tooltip = nil;
     end
end

function ReagentInfo_GameTooltip_SetOwner(this, owner, anchor)
     RI_OriginalGameTooltip_SetOwner(this, owner, anchor);
     RI_GameToolTipOwner = owner;
end

function ReagentInfo_SetItemRef(link, text, button)
     RI_OriginalSetItemRef(link, text, button);
     RI_CheckTooltip = ReagentInfo_CheckTooltipInfo(ItemRefTooltip);
end

function ReagentInfo_Tooltip_Hook(frame, name, count, data)
     if (ReagentInfoPlayer ~= nil and ReagentInfoPlayer['TooltipLoc'] == REAGENTINFO_DROPDOWN_TOP) then
	  ReagentInfo_AddTooltipInfo(frame, name);
	  ReagentInfo_Old_Tooltip_Hook(frame, name, count, data);
     else
	  ReagentInfo_Old_Tooltip_Hook(frame, name, count, data);
	  ReagentInfo_AddTooltipInfo(frame, name);
     end
end

-- AIOI Hooks
function ReagentInfo_AllInOneInventory_ModifyItemTooltip(bag, slot, tooltipName)
     RI_OriginalAllInOneInventory_ModifyItemTooltip(bag, slot, tooltipName);

     -- Verify AIOI is installed and running
     if(not AllInOneInventory_Enabled or RI_LootLink or RI_ItemsMatrix) then
	  return;	
     end
     
     local tooltip = getglobal(tooltipName);
     if ( not tooltip ) then
	  tooltip = getglobal("GameTooltip");
	  tooltipName = "GameTooltip";
     end
     if ( not tooltip ) then
	  return false;
     end

--     if ( not InRepairMode() and not MerchantFrame:IsVisible() ) then
     if ( not InRepairMode() ) then
	  local link = GetContainerItemLink(bag, slot);
	  local name = ReagentInfo_NameFromLink(link);
	  
	  ReagentInfo_AddTooltipInfo(tooltip, name);
--	  ReagentInfo_CheckTooltipInfo(tooltip);
     end
end

-- MyInventory Hooks
function ReagentInfo_MyInventory_ContainerFrameItemButton_OnEnter()
     RI_OriginalMyInventory_ContainerFrameItemButton_OnEnter();
	
     if (GameTooltip:IsVisible() and not InRepairMode()) then
	  local bag, slot = MyInventory_GetIdAsBagSlot(this:GetID());
	  local _, stack = GetContainerItemInfo(bag, slot);
		
	  local link = GetContainerItemLink(bag, slot);
	  local name = ReagentInfo_NameFromLink(link);
		
	  if(link and name) then
	       ReagentInfo_AddTooltipInfo(GameTooltip, name);
	  end
     end
end

function ReagentInfo_MyInventoryFrame_Update(frame)
     RI_OriginalMyInventoryFrame_Update(frame);
	
     local name = frame:GetName();
     for j=1, frame.size, 1 do
	  local itemButton = getglobal(name.."Item"..j);
    
--	  if (GameTooltip:IsVisible() and GameTooltip:IsOwned(itemButton) and not MerchantFrame:IsVisible()) then
	  if (GameTooltip:IsVisible() and GameTooltip:IsOwned(itemButton)) then
	       tooltip = getglobal("GameTooltip");
	       tooltipName = "GameTooltip";

	       if ( not tooltip ) then
		    return false;
	       end
    		
	       local bag, slot = MyInventory_GetIdAsBagSlot(itemButton:GetID());
	       local link = GetContainerItemLink(bag, slot);
	       local name = ReagentInfo_NameFromLink(link);

	       if (name ~= nil) then
		    ReagentInfo_AddTooltipInfo(GameTooltip, name);
	       end
	  end
     end
end

----------------------------
-- Reagent Info DropDowns --
----------------------------

-- The pair of functions that initialize the Tooltip Location dropdown menu.  Should be pretty self explanatory.

function ReagentInfo_DropDown_TooltipLoc_OnShow()
     UIDropDownMenu_Initialize(this, ReagentInfo_DropDown_TooltipLoc_Initialize);
     UIDropDownMenu_SetSelectedValue(this, ReagentInfoPlayer.TooltipLoc);
     UIDropDownMenu_SetWidth(75, ReagentInfo_DropDown_TooltipLoc);
end

function ReagentInfo_DropDown_TooltipLoc_Initialize()
     local selectedValue = UIDropDownMenu_GetSelectedValue(ReagentInfo_DropDown_TooltipLoc);

     -- Note: These values were chosen for readability.  Yes, numerical values
     -- probably would have been more efficient, but this will be a lot easier
     -- to debug should someone else decide to play with the code.

     info = {};
     info.text = REAGENTINFO_DROPDOWN_TOP;
     info.value = REAGENTINFO_DROPDOWN_TOP;
     if (selectedValue == info.value) then
	  info.checked = 1;
     else
	  info.checked = nil;
     end
     info.func = ReagentInfo_TooltipLoc_OnClick;
     UIDropDownMenu_AddButton(info);
     
     info = {};
     info.text = REAGENTINFO_DROPDOWN_BOTTOM;
     info.value = REAGENTINFO_DROPDOWN_BOTTOM;
     if (selectedValue == info.value) then
	  info.checked = 1;
     else
	  info.checked = nil;
     end
     info.func = ReagentInfo_TooltipLoc_OnClick;
     UIDropDownMenu_AddButton(info);
end

-- ReagentInfo_TooltipLoc_OnClick()
-- A simple function that's called when you click on the tooltip location dropdown.

function ReagentInfo_TooltipLoc_OnClick()
     UIDropDownMenu_SetSelectedValue(ReagentInfo_DropDown_TooltipLoc, this.value);

     if (ReagentInfoPlayer ~= nil) then
	  ReagentInfoPlayer["TooltipLoc"] = this.value;
     end
end

-- The pair of functions that initialize the Recipe Threshold dropdown menu.  Should be pretty self explanatory.

function ReagentInfo_DropDown_RecipeThreshold_OnShow()
     UIDropDownMenu_Initialize(this, ReagentInfo_DropDown_RecipeThreshold_Initialize);
     UIDropDownMenu_SetSelectedValue(this, ReagentInfoPlayer.RecipeThreshold);
     UIDropDownMenu_SetWidth(75, ReagentInfo_DropDown_RecipeThreshold);
end

function ReagentInfo_DropDown_RecipeThreshold_Initialize()
     local selectedValue = UIDropDownMenu_GetSelectedValue(ReagentInfo_DropDown_RecipeThreshold);

     -- Note: These values were chosen for readability.  Yes, numerical values
     -- probably would have been more efficient, but this will be a lot easier
     -- to debug should someone else decide to play with the code.

     info = {};
     info.text = REAGENTINFO_DROPDOWN_OPTIMAL;
     info.value = 3;
     if (selectedValue == info.value) then
	  info.checked = 1;
     else
	  info.checked = nil;
     end
     info.func = ReagentInfo_RecipeThreshold_OnClick;
     UIDropDownMenu_AddButton(info);
     
     info = {};
     info.text = REAGENTINFO_DROPDOWN_MEDIUM;
     info.value = 2;
     if (selectedValue == info.value) then
	  info.checked = 1;
     else
	  info.checked = nil;
     end
     info.func = ReagentInfo_RecipeThreshold_OnClick;
     UIDropDownMenu_AddButton(info);

     info = {};
     info.text = REAGENTINFO_DROPDOWN_EASY;
     info.value = 1;
     if (selectedValue == info.value) then
	  info.checked = 1;
     else
	  info.checked = nil;
     end
     info.func = ReagentInfo_RecipeThreshold_OnClick;
     UIDropDownMenu_AddButton(info);

     info = {};
     info.text = REAGENTINFO_DROPDOWN_TRIVIAL;
     info.value = 0;
     if (selectedValue == info.value) then
	  info.checked = 1;
     else
	  info.checked = nil;
     end
     info.func = ReagentInfo_RecipeThreshold_OnClick;
     UIDropDownMenu_AddButton(info);
end

-- ReagentInfo_RecipeThreshold_OnClick()
-- A simple function that's called when you click on the recipe threshold dropdown.

function ReagentInfo_RecipeThreshold_OnClick()
     UIDropDownMenu_SetSelectedValue(ReagentInfo_DropDown_RecipeThreshold, this.value);

     if (ReagentInfoPlayer ~= nil) then
	  ReagentInfoPlayer["RecipeThreshold"] = this.value;
     end
end
