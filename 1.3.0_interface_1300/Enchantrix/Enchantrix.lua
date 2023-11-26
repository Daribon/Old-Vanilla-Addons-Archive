-- Enchantrix
ENCHANTRIX_VERSION = "1.14";
-- Written by Norganna
--
-- This is an addon for World of Warcraft that works in combination with 
-- LootLink to add an item breaks down into list to the items that you 
-- mouse-over in the game
--
-- (LootLink is an in-game item database)
--

-- Function hooks
local lOriginalGameTooltip_OnHide;
local lOriginalGameTooltip_ClearMoney;
local lOriginalSetItemRef;

-- If non-nil, check for appearance of GameTooltip for adding information
local lEnchantrixCheckTooltip;

-- Timer for frequency of tooltip checks
local lEnchantrixCheckTimer = 0;

-- Current Tooltip frame
local lEnchantrixTooltip = nil;

EnchantedLocal = {};

ElementNames = {};
ElementNames["DustDream"] = "Dream Dust";
ElementNames["DustIllusion"] = "Illusion Dust";
ElementNames["DustSoul"] = "Soul Dust";
ElementNames["DustStrange"] = "Strange Dust";
ElementNames["DustVision"] = "Vision Dust";
ElementNames["EssenceAstralLarge"] = "Greater Astral Essence";
ElementNames["EssenceAstralSmall"] = "Lesser Astral Essence";
ElementNames["EssenceEternalLarge"] = "Greater Eternal Essence";
ElementNames["EssenceEternalSmall"] = "Lesser Eternal Essence";
ElementNames["EssenceMagicLarge"] = "Greater Magic Essence";
ElementNames["EssenceMagicSmall"] = "Lesser Magic Essence";
ElementNames["EssenceMysticLarge"] = "Greater Mystic Essence";
ElementNames["EssenceMysticSmall"] = "Lesser Mystic Essence";
ElementNames["EssenceNetherLarge"] = "Greater Nether Essence";
ElementNames["EssenceNetherSmall"] = "Lesser Nether Essence";
ElementNames["ShardBrilliantLarge"] = "Large Brilliant Shard";
ElementNames["ShardBrilliantSmall"] = "Small Brilliant Shard";
ElementNames["ShardGlimmeringLarge"] = "Large Glimmering Shard";
ElementNames["ShardGlimmeringSmall"] = "Small Glimmering Shard";
ElementNames["ShardGlowingLarge"] = "Large Glowing Shard";
ElementNames["ShardGlowingSmall"] = "Small Glowing Shard";
ElementNames["ShardRadientLarge"] = "Large Radiant Shard";
ElementNames["ShardRadientSmall"] = "Small Radiant Shard";

function Enchantrix_CheckTooltipInfo(frame)
	-- If we've already added our information, no need to do it again
	if ( not frame or frame.eDone ) then
		return nil;
	end

	lEnchantrixTooltip = frame;

	if( frame:IsVisible() ) then
		local field = getglobal(frame:GetName().."TextLeft1");
		if( field and field:IsVisible() ) then
			local name = field:GetText();
			if( name ) then
				Enchantrix_AddTooltipInfo(frame, name);
				return nil;
			end
		end
	end
	
	return 1;
end

function Enchantrix_AddTooltipInfo(frame, name, count, data)
	if ((EnchantedItems[name]) or (EnchantedLocal[name])) then
		local total = 0;
		local disenchantsTo = {};
		if (EnchantedItems[name]) then
			for dname, count in EnchantedItems[name] do
				disenchantsTo[dname] = {};
				disenchantsTo[dname].inBuilt = count;
				disenchantsTo[dname].myCount = 0;
				total = total + count;
			end
		end
		if (EnchantedLocal[name]) then
			for dname, count in EnchantedLocal[name] do
				name = string.gsub(name, "Radient", "Radiant");
				if (not disenchantsTo[dname]) then
					disenchantsTo[dname] = {};
					disenchantsTo[dname].inBuilt = 0;
				end
				disenchantsTo[dname].myCount = count;
				total = total + count;
			end
		end

		if (total > 0) then
			frame.eDone = 1;
			frame:AddLine("Disenchants into:", 0.7,0.7,0.2);
			for name, counts in disenchantsTo do
				local count = counts.inBuilt + counts.myCount;
				local pct = math.floor(count / total * 100);
				frame:AddLine(" " .. name .. ": " .. pct .. "%; " .. count .. " (" .. counts.myCount .. " by me)", 0.7,0.7,0.2);
			end
		end
		frame:Show();
	end
end

local function Enchantrix_Tooltip_Hook(frame, name, count, data)
	Enchantrix_AddTooltipInfo(frame, name, count, data);
	Enchantrix_Old_Tooltip_Hook(frame, name, count, data);
end


function Enchantrix_NameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end

function Enchantrix_TakeInventory()
	local bagid, slotid, size;
	local inventory = {};

	for bagid = 0, 4, 1 do
		inventory[bagid] = {};

		size = GetContainerNumSlots(bagid);
		if( size ) then
			for slotid = size, 1, -1 do
				inventory[bagid][slotid] = {};

				local link = GetContainerItemLink(bagid, slotid);
				if( link ) then
					local name = Enchantrix_NameFromLink(link);
					local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bagid, slotid);
					if ((not itemCount) or (itemCount < 1)) then
						itemCount = 1;
					end
					if (name) then
						inventory[bagid][slotid].name = name;
						inventory[bagid][slotid].count = itemCount;
					end
				end
			end
		end
	end
	return inventory;
end

function Enchantrix_DiffInventory(invA, invB)
	local bagid, slotid, size;
	for bagid = 0, 4, 1 do
		size = GetContainerNumSlots(bagid);
		if( size ) then
			for slotid = size, 1, -1 do
				if ((invA[bagid][slotid]) and (invA[bagid][slotid].name)) then
					if (invA[bagid][slotid].name ~= invB[bagid][slotid].name) then
						return invA[bagid][slotid];
					elseif (invA[bagid][slotid].count > invB[bagid][slotid].count) then
						return invA[bagid][slotid];
					end
				end
			end
		end
	end
	return nil;
end

function Enchantrix_OnEvent(event)
	if ((event == "SPELLCAST_START") and (arg1 == "Disenchant")) then
		Enchantrix_Disenchanting = true;
		Enchantrix_WaitingPush = false;
		Enchantrix_StartInv = Enchantrix_TakeInventory();
		Enchantrix_DisenchantCount = 0;
		Enchantrix_DisenchantResult = {};

		return;
	end
	if ((event == "SPELLCAST_FAILED") or (event == "SPELLCAST_INTERRUPTED")) then
		Enchantrix_Disenchanting = false;
		Enchantrix_WaitingPush = false;
		return;
	end
	if ((event == "SPELLCAST_STOP") and (Enchantrix_Disenchanting)) then
		Enchantrix_Disenchanting = false;
		Enchantrix_WaitingPush = true;
		return;
	end
	if ((event == "ITEM_PUSH") and (Enchantrix_WaitingPush)) then
		local textureType = strsub(arg2, 1, 28);
		local receivedItem = strsub(arg2, 29);
		if (not receivedItem) then return; end
		if (textureType == "Interface\\Icons\\INV_Enchant_") then
			local receivedName = ElementNames[receivedItem];
			if (not receivedName) then return; end
			Enchantrix_DisenchantCount = Enchantrix_DisenchantCount + 1;
			Enchantrix_DisenchantResult[Enchantrix_DisenchantCount] = receivedName;
		end
	end
	if ((event == "UNIT_INVENTORY_CHANGED") and (arg1 == "player") and (Enchantrix_DisenchantCount > 0)) then
		local nowInv = Enchantrix_TakeInventory();
		local disenchantedItem = Enchantrix_DiffInventory(Enchantrix_StartInv, nowInv);

		if (not disenchantedItem) then
			return;
		end

		if (not EnchantedLocal[disenchantedItem.name]) then
			EnchantedLocal[disenchantedItem.name] = {};
		end

		local message = "Found that "..disenchantedItem.name.." disenchants into ";
		for i=1, Enchantrix_DisenchantCount, 1 do
			local disenchantResult = Enchantrix_DisenchantResult[i];
			local prevCount = EnchantedLocal[disenchantedItem.name][disenchantResult];
			if (not prevCount) then prevCount = 0; end
			EnchantedLocal[disenchantedItem.name][disenchantResult] = prevCount + 1;
			if (i == 1) then
				message = message..disenchantResult;
			elseif (i == Enchantrix_DisenchantResult) then
				message = message.." and "..disenchantResult;
			else
				message = message..", "..disenchantResult;
			end
		end
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(message, 0.8, 0.8, 0.2);
		end
		Enchantrix_DisenchantCount = 0;
		Enchantrix_DisenchantResult = {};
		Enchantrix_Disenchanting = false;
		Enchantrix_WaitingPush = false;
	end
end

function Enchantrix_ChatPrint(str)
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(str, 1.0, 0.5, 0.25);
	end
end

function Enchantrix_GameTooltip_ClearMoney()
	lOriginalGameTooltip_ClearMoney();
	lEnchantrixCheckTooltip = Enchantrix_CheckTooltipInfo(GaeTooltip);
end

function Enchantrix_GameTooltip_OnHide()
	lOriginalGameTooltip_OnHide();
	GameTooltip.eDone = nil;
	if ( lEnchantrixTooltip ) then
		lEnchantrixTooltip.eDone = nil;
		lEnchantrixTooltip = nil;
	end
end

function Enchantrix_OnUpdate(elapsed)
	lEnchantrixCheckTimer = lEnchantrixCheckTimer + elapsed;
	if( lEnchantrixCheckTimer >= 0.2 ) then
		if( lEnchantrixCheckTooltip ) then
			lEnchantrixCheckTooltip = Enchantrix_CheckTooltipInfo(lEnchantrixTooltip);
		end
		lEnchantrixCheckTimer = 0;
	end
end

function Enchantrix_SetItemRef(link)
	lOriginalSetItemRef(link);
	lEnchantrixCheckTooltip = Enchantrix_CheckTooltipInfo(ItemRefTooltip);
end

function Enchantrix_OnLoad()
	lOriginalGameTooltip_ClearMoney = GameTooltip_ClearMoney;
	GameTooltip_ClearMoney = Enchantrix_GameTooltip_ClearMoney;

	lOriginalGameTooltip_OnHide = GameTooltip_OnHide;
	GameTooltip_OnHide = Enchantrix_GameTooltip_OnHide;

	lOriginalSetItemRef = SetItemRef;
	SetItemRef = Enchantrix_SetItemRef;

	Enchantrix_Old_Tooltip_Hook = LootLink_AddExtraTooltipInfo;
	LootLink_AddExtraTooltipInfo = Enchantrix_Tooltip_Hook;

	this:RegisterEvent("SPELLCAST_FAILED");
	this:RegisterEvent("SPELLCAST_INTERRUPTED");
	this:RegisterEvent("SPELLCAST_START");
	this:RegisterEvent("SPELLCAST_STOP");
	this:RegisterEvent("ITEM_PUSH");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	
	RegisterForSave("EnchantedLocal");

	Enchantrix_DisenchantCount = 0;
	Enchantrix_DisenchantResult = {};
	Enchantrix_Disenchanting = false;
	Enchantrix_WaitingPush = false;

	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage("Enchantrix v"..ENCHANTRIX_VERSION.." loaded", 0.8, 0.8, 0.2);
	end
end
