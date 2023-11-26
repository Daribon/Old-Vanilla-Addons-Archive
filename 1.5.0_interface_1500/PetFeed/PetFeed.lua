--[[
filename: PetFeed.lua
original by : Rauen
update by: Thomas Friedrich <vincent@wow.g-d-g.de>
created: Mo, 14 Mar 2005 23:0:00 +0100
version: 1.1 (05/01/2005)

This is an enhanced and localized version of Rauen's Petfeed, easily expandable for any language.
Please see readme.txt for details.
]]

-- Configuration
PetFeed_Config = { };
PetFeed_Config.Enabled = true;
PetFeed_Config.Alert = true;
PetFeed_Config.Level = "content";

-- Foods Lists
PetFeed_Foods_Meat = { };
PetFeed_Foods_Fish = { };
PetFeed_Foods_Bread = { };
PetFeed_Foods_Cheese = { };
PetFeed_Foods_Fruits = { };
PetFeed_Foods_Fungus = { };

-- Variables
PetFeed_Var = { };
PetFeed_Var.InCombat = false;
PetFeed_Var.Searching = false;
PetFeed_Var.IsAFK = false;

function PetFeed_OnLoad()
	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PET_ATTACK_START");
	this:RegisterEvent("PET_ATTACK_STOP");
	this:RegisterEvent("UNIT_HAPPINESS");
	this:RegisterEvent("CHAT_MSG_SYSTEM");

	-- Register Slash Commands
	SLASH_PetFeed1 = "/PetFeed";
	SLASH_PetFeed2 = "/pf";
	SlashCmdList["PetFeed"] = function(msg)
		PetFeed_ChatCommandHandler(msg);
	end
end

function PetFeed_OnEvent(event, arg1)
	-- Save Variables
	if ( event == "VARIABLES_LOADED" ) 
	then
		RegisterForSave("PetFeed_Config");
		RegisterForSave("PetFeed_Foods_Meat");
		RegisterForSave("PetFeed_Foods_Fish");
		RegisterForSave("PetFeed_Foods_Bread");
		RegisterForSave("PetFeed_Foods_Cheese");
		RegisterForSave("PetFeed_Foods_Fruits");
		RegisterForSave("PetFeed_Foods_Fungus");
	elseif ( event == "CHAT_MSG_SYSTEM" ) 
	then
		if ( isAFKEvent() ) 
		then
			PetFeed_Var.IsAFK = true;
			ChatMessage(PF_AFKMODE);
		end
		if ( isnotAFKEvent() ) 
		then
			PetFeed_Var.IsAFK = false;
			ChatMessage(PF_NOAFKMODE);
		end
	elseif ( event == "PET_ATTACK_START" ) 
	then
		-- Set Flag
		PetFeed_Var.InCombat = true;
	elseif ( event == "PET_ATTACK_STOP" ) 
	then
		-- Remove Flag
		PetFeed_Var.InCombat = false;
	elseif ( event == "UNIT_HAPPINESS" ) and ( arg1 == "pet" ) 
	then
		-- Check for Pet
		if not ( UnitExists("pet") ) 
		then
			return;
		end
		
		if ( PetFeed_Var.IsAFK ) 
		then
			return;
		end
		
		if ( PetFeed_Var.InCombat ) or ( PlayerFrame.inCombat ) 
		then
			return;
		end
		
		if ( PetFeed_HasFeedEffect() ) 
		then
			return;
		end
	
		if ( PetFeed_Config.Enabled ) 
		then
			PetFeed_CheckHappiness();
		end
	end
end

function PetFeed_ChatCommandHandler(msg)
	-- Print Help
	if ( msg == PF_HELP ) or ( msg == "" ) 
	then
		ShowHelp();
		return;
	end
	
	-- Assign Variables
	local pet = UnitName("pet");
	-- Check for Pet
	if not ( UnitExists("pet") ) 
	then
		ChatMessage(PF_NOPET);
		return;
	end
	
	-- Check Status
	if ( msg == PF_STATUS ) 
	then
		if not ( PetFeed_Config.Enabled ) 
		then
			ChatMessage(PF_DEACT);
			return;
		end

		ChatMessage(string.format(PF_LETFEED,pet));
		ChatMessage(string.format(PF_WHENFEED,pet,LocalLevel()));
		if ( PetFeed_Config.Alert ) 
		then
			ChatMessage(string.format(PF_TELLFEED,pet));
		end
		return;
	end

	-- Turn PetFeed On
	if ( msg == PF_ON ) 
	then
		PetFeed_Config.Enabled = true;
		ChatMessage(PF_ACTIVATED);
		return;
	end
	
	-- Turn PetFeed Off
	if ( msg == PF_OFF ) 
	then
		PetFeed_Config.Enabled = false;
		ChatMessage(PF_DEACTIVATED);
		return;
	end
	
	-- Reset Variables
	if ( msg == PF_RESET ) 
	then
		PetFeed_Config.Enabled = true;
		PetFeed_Config.Alert	= true;
		PetFeed_Config.Level	= "content";
		ChatMessage(PF_MSG_RESET);
		ChatMessage(string.format(PF_TELLFEED,pet));
		ChatMessage(string.format(PF_WHENFEED,pet,LocalLevel()));
		return;
	end
	
	-- Toggle Alert
	if ( msg == PF_ALERT ) 
	then
		if ( PetFeed_Config.Alert ) 
		then
			PetFeed_Config.Alert = false;
			ChatMessage(string.format(PF_NOTELLFEED,pet));
		else
			PetFeed_Config.Alert = true;
			ChatMessage(string.format(PF_TELLFEED,pet));
		end
	end
	
	-- Set Happiness Level
	if ( string.find(msg,PF_LEVEL.." ") )
	then
		if ( string.find(msg,PF_CONTENT) ) 
		then
			PetFeed_Config.Level = "content" ;
		elseif ( string.find(msg,PF_HAPPY) ) 
		then
			PetFeed_Config.Level = "happy" ;
		else
			return;
		end
		ChatMessage(string.format(PF_WHENFEED,pet,LocalLevel()));
		return;
	end
	
	-- Feed Pet
	if ( msg == PF_FEED ) 
	then
		PetFeed_Feed();
	end
	
	-- Add Food to List
	if ( string.find(msg,PF_ADD) ) 
	then
		local food;
		-- MEAT --
		if ( string.find(msg,PF_MEAT.." ") ) 
		then
			food = PetFeed_ParseFood(msg,PF_ADD,PF_MEAT);
			if ( PetFeed_IsInPack(food) and not (food == nil) ) 
			then
				if ( PetFeed_GetIndex(PF_MEAT, food) == 0 ) 
				then
					table.insert( PetFeed_Foods_Meat, food );
					table.sort( PetFeed_Foods_Meat );
					ChatMessage(string.format(PF_ADDEDTOLIST,food,PF_MEAT));
					PetFeed_CheckHappiness();
				else
					ChatMessage(string.format(PF_ALREADYADDED,food,PF_MEAT));
				end
			else
				ChatMessage(string.format(PF_FOODNOTFOUND,food));
			end

		-- FISH --
		elseif ( string.find(msg,PF_FISH.." ") ) 
		then
			food = PetFeed_ParseFood(msg,PF_ADD,PF_FISH);
			if ( PetFeed_IsInPack(food) and not (food == nil) ) 
			then
				if ( PetFeed_GetIndex(PF_FISH, food) == 0 ) 
				then
					table.insert( PetFeed_Foods_Fish, food );
					table.sort( PetFeed_Foods_Fish );
					ChatMessage(string.format(PF_ADDEDTOLIST,food,PF_FISH));
					PetFeed_CheckHappiness();
				else
					ChatMessage(string.format(PF_ALREADYADDED,food,PF_FISH));
				end
			else
				ChatMessage(string.format(PF_FOODNOTFOUND,food));
			end

		-- BREAD --
		elseif ( string.find(msg,PF_BREAD.." ") ) 
		then
			food = PetFeed_ParseFood(msg,PF_ADD,PF_BREAD);
			if ( PetFeed_IsInPack(food) and not (food == nil) ) 
			then
				if ( PetFeed_GetIndex(PF_BREAD, food) == 0 ) 
				then
					table.insert( PetFeed_Foods_Bread, food );
					table.sort( PetFeed_Foods_Bread );
					ChatMessage(string.format(PF_ADDEDTOLIST,food,PF_BREAD));
					PetFeed_CheckHappiness();
				else
					ChatMessage(string.format(PF_ALREADYADDED,food,PF_BREAD));
				end
			else
				ChatMessage(string.format(PF_FOODNOTFOUND,food));
			end

		-- CHEESE --
		elseif ( string.find(msg,PF_CHEESE.." ") ) 
		then
			food = PetFeed_ParseFood(msg,PF_ADD,PF_CHEESE);
			if ( PetFeed_IsInPack(food) and not (food == nil) ) 
			then
				if ( PetFeed_GetIndex(PF_CHEESE, food) == 0 ) 
				then
					table.insert( PetFeed_Foods_Cheese, food );
					table.sort( PetFeed_Foods_Cheese );
					ChatMessage(string.format(PF_ADDEDTOLIST,food,PF_CHEESE));
					PetFeed_CheckHappiness();
				else
					ChatMessage(string.format(PF_ALREADYADDED,food,PF_CHEESE));
				end
			else
				ChatMessage(string.format(PF_FOODNOTFOUND,food));
			end

		-- FRUITS --
		elseif ( string.find(msg,PF_FRUITS.." ") ) 
		then
			food = PetFeed_ParseFood(msg,PF_ADD,PF_FRUITS);
			if ( PetFeed_IsInPack(food) and not (food == nil) ) 
			then
				if ( PetFeed_GetIndex(PF_FRUITS, food) == 0 ) 
				then
					table.insert( PetFeed_Foods_Fruits, food );
					table.sort( PetFeed_Foods_Fruits );
					ChatMessage(string.format(PF_ADDEDTOLIST,food,PF_FRUITS));
					PetFeed_CheckHappiness();
				else
					ChatMessage(string.format(PF_ALREADYADDED,food,PF_FRUITS));
				end
			else
				ChatMessage(string.format(PF_FOODNOTFOUND,food));
			end

		-- FUNGUS --
		elseif ( string.find(msg,PF_FUNGUS.." ") ) 
		then
			food = PetFeed_ParseFood(msg,PF_ADD,PF_FUNGUS);
			if ( PetFeed_IsInPack(food) and not (food == nil) ) 
			then
				if ( PetFeed_GetIndex(PF_FUNGUS, food) == 0 ) 
				then
					table.insert( PetFeed_Foods_Fungus, food );
					table.sort( PetFeed_Foods_Fungus );
					ChatMessage(string.format(PF_ADDEDTOLIST,food,PF_FUNGUS));
					PetFeed_CheckHappiness();
				else
					ChatMessage(string.format(PF_ALREADYADDED,food,PF_FUNGUS));
				end
			else
				ChatMessage(string.format(PF_FOODNOTFOUND,food));
			end
		else
			ChatMessage(PF_USAGE_ADD);
		end
		return;
	end

	-- Remove Food from List(s)
	if ( string.find(msg,PF_REMOVE) ) 
	then
		food = PetFeed_ParseFood2(msg,PF_REMOVE);
		-- MEAT --
		ind = PetFeed_GetIndex(PF_MEAT, food);
		if not ( ind == 0 ) 
		then
			table.remove( PetFeed_Foods_Meat, PetFeed_GetIndex(PF_MEAT, food) );
			table.sort( PetFeed_Foods_Meat );
			ChatMessage(string.format(PF_REMOVEDFROMLIST,food,PF_MEAT));
		end

		-- FISH --
		ind = PetFeed_GetIndex(PF_FISH, food);
		if not ( ind == 0 ) 
		then
			table.remove( PetFeed_Foods_Fish, PetFeed_GetIndex(PF_FISH, food) );
			table.sort( PetFeed_Foods_Fish );
			ChatMessage(string.format(PF_REMOVEDFROMLIST,food,PF_FISH));
		end

		-- BREAD --
		ind = PetFeed_GetIndex(PF_BREAD, food);
		if not ( ind == 0 ) 
		then
			table.remove( PetFeed_Foods_Bread, PetFeed_GetIndex(PF_BREAD, food) );
			table.sort( PetFeed_Foods_Bread );
			ChatMessage(string.format(PF_REMOVEDFROMLIST,food,PF_BREAD));
		end

		-- CHEESE --
		ind = PetFeed_GetIndex(PF_CHEESE, food);
		if not ( ind == 0 ) 
		then
			table.remove( PetFeed_Foods_Cheese, PetFeed_GetIndex(PF_CHEESE, food) );
			table.sort( PetFeed_Foods_Cheese );
			ChatMessage(string.format(PF_REMOVEDFROMLIST,food,PF_CHEESE));
		end

		-- FRUITS --
		ind = PetFeed_GetIndex(PF_FRUITS, food);
		if not ( ind == 0 ) 
		then
			table.remove( PetFeed_Foods_Fruits, PetFeed_GetIndex(PF_FRUITS, food) );
			table.sort( PetFeed_Foods_Fruits );
			ChatMessage(string.format(PF_REMOVEDFROMLIST,food,PF_FRUITS));
		end

		-- FUNGUS --
		ind = PetFeed_GetIndex(PF_FUNGUS, food);
		if not ( ind == 0 ) 
		then
			table.remove( PetFeed_Foods_Fungus, PetFeed_GetIndex(PF_FUNGUS, food) );
			table.sort( PetFeed_Foods_Fungus );
			ChatMessage(string.format(PF_REMOVEDFROMLIST,food,PF_FUNGUS));
		end
		return;
	end

	-- Show Lists
	if ( string.find(msg,PF_SHOW.." ") )
	then
		if ( string.find(msg,PF_MEAT) ) 
		then
			ChatMessage(PF_MEAT .. " " .. PF_LIST .. ":");
			for i=1, table.getn(PetFeed_Foods_Meat) 
			do
				ChatMessage(" - "..PetFeed_Foods_Meat[i]);
			end
			return;
		elseif ( string.find(msg,PF_FISH) ) 
		then
			ChatMessage(PF_FISH .. " " .. PF_LIST .. ":");
			for i=1, table.getn(PetFeed_Foods_Fish) 
			do
				ChatMessage(" - "..PetFeed_Foods_Fish[i]);
			end
			return;
		elseif ( string.find(msg,PF_BREAD) ) 
		then
			ChatMessage(PF_BREAD .. " " .. PF_LIST .. ":");
			for i=1, table.getn(PetFeed_Foods_Bread) 
			do
				ChatMessage(" - "..PetFeed_Foods_Bread[i]);
			end
			return;
		elseif ( string.find(msg,PF_CHEESE) ) 
		then
			ChatMessage(PF_CHEESE .. " " .. PF_LIST .. ":");
			for i=1, table.getn(PetFeed_Foods_Cheese) 
			do
				ChatMessage(" - "..PetFeed_Foods_Cheese[i]);
			end
			return;
		elseif ( string.find(msg,PF_FRUITS) ) 
		then
			ChatMessage(PF_FRUITS .. " " .. PF_LIST .. ":");
			for i=1, table.getn(PetFeed_Foods_Fruits) 
			do
				ChatMessage(" - "..PetFeed_Foods_Fruits[i]);
			end
			return;
		elseif ( string.find(msg,PF_ALL) ) 
		then
			PetFeed_ChatCommandHandler(PF_SHOW.." "..PF_MEAT);
			PetFeed_ChatCommandHandler(PF_SHOW.." "..PF_FISH);
			PetFeed_ChatCommandHandler(PF_SHOW.." "..PF_BREAD);
			PetFeed_ChatCommandHandler(PF_SHOW.." "..PF_CHEESE);
			PetFeed_ChatCommandHandler(PF_SHOW.." "..PF_FRUITS);
			PetFeed_ChatCommandHandler(PF_SHOW.." "..PF_FUNGUS);
			return;
		else
			ChatMessage(PF_USAGE_SHOW);
		end
		return;
	end
end
-- end of commandhandler

-- Check Happiness
function PetFeed_CheckHappiness()
	-- Get Pet Info
	local pet = UnitName("pet");
	local happiness, damage, loyalty = GetPetHappiness();
	local level;
	if ( PetFeed_Config.Level == "content" ) 
	then
		level = 2;
	elseif ( PetFeed_Config.Level == "happy" ) 
	then
		level = 3;
	end
	
	-- No Happiness, something wrong
	if ( happiness == 0 ) or ( happiness == nil ) 
	then
		return;
	end
	
	-- Check if Need Feeding
	if ( happiness < level ) 
	then
		PetFeed_Feed();
	end
end
-- end of Check Happiness

-- Feed Pet
function PetFeed_Feed()
	-- Assign Variable
	local pet = UnitName("pet");

	-- tell that it is searching
	if ( PetFeed_Config.Alert ) 
	then
		ChatMessage(string.format(PF_SEARCHINGPACK,pet));
	end
	
	-- Look for Food
	for m = 0, 4 do
		for n = 1, 16 do
			if ( PetFeed_IsInDiet(PetFeed_GetItemName(m,n)) ) 
			then
				-- Feed Item
				PickupContainerItem(m,n);
				if ( CursorHasItem() ) 
				then
					DropItemOnUnit("pet");
				end
				if ( CursorHasItem() ) 
				then
					PickupContainerItem(m,n);
				else
					-- tell that it is eating
					if ( PetFeed_Config.Alert ) 
					then
						ChatMessage(string.format(PF_EATS,pet,PetFeed_GetItemName(m,n)));
					end
				end
				return;
			end
		end
	end
	-- No Food Could be Found
	ChatMessage(string.format(PF_NOFOODFOUND,pet));
end

-- Parse Food with diet
function PetFeed_ParseFood(msg, action, diet)
	local _, _, food = string.find(msg, "^.*%[(.*)%].*$");
	if not (food) 
	then
		food = string.sub( msg, string.len(action) + 1 + string.len(diet) + 2 );
	end
	return food;
end

-- Parse Food without diet
function PetFeed_ParseFood2(msg, action)
	local _,_, food = string.find(msg, "^.*%[(.*)%].*$");
	if not (food) 
	then
		food = string.sub( msg, string.len(action) + 2 );
	end
	return food;
end

-- Check Feed Effect
function PetFeed_HasFeedEffect()
	local i = 1;
	local buff;
	buff = UnitBuff("pet", i);
	while buff do
		if ( string.find(buff, "Ability_Hunter_BeastTraining") ) 
		then
			return true;
		end
		i = i + 1;
		buff = UnitBuff("pet", i);
	end
	return false;
end

-- Check Food Types
function PetFeed_IsInDiet(food)
	local diet = BuildListString(GetPetFoodTypes());
	if (diet == nil) 
	then
		return false;
	end
	
	-- Check for meat
	if ( string.find(diet,PF_MEAT) ) 
	then
		for i=1, table.getn(PetFeed_Foods_Meat) 
		do
			if ( food == PetFeed_Foods_Meat[i] ) 
			then
				return true;
			end
		end
	end
	
	-- Check for fish
	if ( string.find(diet,PF_FISH) ) 
	then
		for i=1, table.getn(PetFeed_Foods_Fish) 
		do
			if ( food == PetFeed_Foods_Fish[i] ) 
			then
				return true;
			end
		end
	end
	
	-- Check for cheese
	if (string.find(diet,PF_CHEESE) ) 
	then
		for i=1, table.getn(PetFeed_Foods_Cheese) 
		do
			if ( food == PetFeed_Foods_Cheese[i] ) 
			then
				return true;
			end
		end
	end
	
	-- Check for bread
	if ( string.find(diet,PF_BREAD) ) 
	then
		for i=1, table.getn(PetFeed_Foods_Bread) 
		do
			if ( food == PetFeed_Foods_Bread[i] ) 
			then
				return true;
			end
		end
	end
	
	-- Check for fungus
	if ( string.find(diet,PF_FUNGUS) ) 
	then
		for i=1, table.getn(PetFeed_Foods_Fungus) 
		do
			if ( food == PetFeed_Foods_Fungus[i] ) 
			then
				return true;
			end
		end
	end
	
	-- Check for fruits
	if ( string.find(diet,PF_FRUITS) ) 
	then
		for i=1, table.getn(PetFeed_Foods_Fruits) 
		do
			if ( food == PetFeed_Foods_Fruits[i] ) 
			then
				return true;
			end
		end
	end
	return false;
end

-- sucht in allen Taschen nach <food>
function PetFeed_IsInPack(food)
	for bag = 0,4 
	do
		for slot = 1,16 
		do
			if ( PetFeed_GetItemName(bag,slot) == food ) 
			then
				return true;
			end
		end
	end
	return false;
end

-- Get List Index
function PetFeed_GetIndex(diet, food)
	if ( diet == PF_MEAT ) 
	then
		for i=1, table.getn(PetFeed_Foods_Meat) 
		do
			if ( food == PetFeed_Foods_Meat[i] ) 
			then
				return i;
			end
		end
	elseif ( diet == PF_FISH ) 
	then
		for i=1, table.getn(PetFeed_Foods_Fish) 
		do
			if ( food == PetFeed_Foods_Fish[i] ) 
			then
				return i;
			end
		end
	elseif ( diet == PF_BREAD ) 
	then
		for i=1, table.getn(PetFeed_Foods_Bread) 
		do
			if ( food == PetFeed_Foods_Bread[i] ) 
			then
				return i;
			end
		end
	elseif ( diet == PF_CHEESE ) 
	then
		for i=1, table.getn(PetFeed_Foods_Cheese) 
		do
			if ( food == PetFeed_Foods_Cheese[i] ) 
			then
				return i;
			end
		end
	elseif ( diet == PF_FRUITS ) 
	then
		for i=1, table.getn(PetFeed_Foods_Fruits) do
			if ( food == PetFeed_Foods_Fruits[i] ) 
			then
				return i;
			end
		end
	elseif ( diet == PF_FUNGUS ) 
	then
		for i=1, table.getn(PetFeed_Foods_Fungus) do
			if ( food == PetFeed_Foods_Fungus[i] ) 
			then
				return i;
			end
		end
	end
	return 0;
end

-- liefert den Namen des Items in Tasche <bag>, Stelle <slot>
function PetFeed_GetItemName(bag,slot)
	local name;
	getglobal("GameTooltipTextLeft1"):SetText("");
	GameTooltip:SetBagItem(bag,slot);
	name = getglobal("GameTooltipTextLeft1"):GetText();
	if (name == nil) 
	then
		name = "";
	end
	return name;
end

-- Send Message to Chat Frame
function ChatMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end

-- Send Message to Channel
function ChannelMessage(message, channel)
	SendChatMessage(message, channel);
end

-- Send Message to Error Frame
function ErrorMessage(message)
	UIErrorsFrame:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
end