--[[
Auto Dismount
Automatically dismounts you at a flight master.
By: Sithy aka Bavaria of Icecrown
Patched by sarf.
   ]]
   
if ( not AutoMount_Mount_List ) then
AutoMount_Mount_List={
"Spell_Nature_Swiftness",
"Ability_Mount",
"INV_Misc_Foot_Kodo",
}
end

if ( not AutoMount_Mount_Items ) then
AutoMount_Mount_Items={
"Black Ram",
"Brown Ram",
"Frost Ram",
"Gray Ram",
"Swift Brown Ram",
"Swift Gray Ram",
"Swift White Ram",
"White Ram",
"Blue Mechanostrider",
"Green Mechanostrider",
"Icy Blue Mechanostrider Mod A",
"Red Mechanostrider",
"Swift Green Mechanostrider",
"Swift White Mechanostrider",
"Swift Yellow Mechanostrider",
"Unpainted Mechanostrider",
"White Mechanostrider Mod A",
"Black Stallion Bridle",
"Brown Horse Bridle",
"Chestnut Mare Bridle",
"Palomino Bridle",
"Pinto Bridle",
"White Stallion Bridle",
"Reins of the Frostsaber",
"Reins of the Nightsaber",
"Reins of the Spotted Frostsaber",
"Reins of the Striped Frostsaber",
"Reins of the Striped Nightsaber",
"Reins of the Swift Frostsaber",
"Reins of the Swift Mistsaber",
"Reins of the Swift Stormsaber",
"Reins of the Winterspring Frostsaber",
"Reins of the Bengal Tiger",
"Reins of the Leopard",
"Reins of the Night Saber",
"Reins of the Spotted Panther",
"Deathcharger's Reins",
"Blue Skeletal Horse",
"Brown Skeletal Horse",
"Green Skeletal Warhorse",
"Red Skeletal Horse",
"Brown Kodo",
"Gray Kodo",
"Great Brown Kodo",
"Great Gray Kodo",
"Great White Kodo",
"Green Kodo",
"Teal Kodo",
"Swift Blue Raptor",
"Swift Green Raptor",
"Swift Orange Raptor",
"Whistle of the Emerald Raptor",
"Whistle of the Ivory Raptor",
"Whistle of the Mottled Red Raptor",
"Whistle of the Turquoise Raptor",
"Whistle of the Violet Raptor",
"Horn of the Arctic Wolf",
"Horn of the Brown Wolf",
"Horn of the Dire Wolf",
"Horn of the Red Wolf",
"Horn of the Swift Brown Wolf",
"Horn of the Swift Gray Wolf",
"Horn of the Swift Timber Wolf",
"Horn of the Timber Wolf",
"Horn of the Winter Wolf",
"Horn of the Black Wolf",
"Horn of the Gray Wolf",
}

end

AutoMount_Update = nil;
AutoMount_Texture = nil;
AutoMount_Mount = nil;

if ( not AutoMount_GetItemNameFromLink ) then
function AutoMount_GetItemNameFromLink(link)
	local name;
	if( not link ) then
		return nil;
	end
	for name in string.gfind(link, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[(.-)%]|h|r") do
		return name;
	end
	return nil;
end;
end

if ( not AutoMount_GetItemName ) then
function AutoMount_GetItemName(bag, slot)
	return AutoMount_GetItemNameFromLink(GetContainerItemLink(bag, slot));
end
end

if ( not AutoMount_GetMountBuffPosition ) then
function AutoMount_GetMountBuffPosition()
	for i = 0, 15 do
		if not AutoMount_Texture then
			for j = 1, table.getn(AutoMount_Mount_List) do
				if GetPlayerBuffTexture(i) ~= nil then
					if (string.find(GetPlayerBuffTexture(i),AutoMount_Mount_List[j])) then
						AutoMount_Texture = GetPlayerBuffTexture(i);
						return i;
					end
				end
			end
		else
			if GetPlayerBuffTexture(i) == AutoMount_Texture then
				return i;
			end
		end
	end
	return -1;
end
end

if ( not AutoMount_Dismount ) then
function AutoMount_Dismount()
	local buffPos = AutoMount_GetMountBuffPosition();
	if ( buffPos > -1 ) then
		CancelPlayerBuff(buffPos);
	end
end
end


if ( not AutoMount_GetMountItemName ) then
function AutoMount_GetMountItemName()
	if ( not AutoMount_Mount ) then
		local itemName = nil;
		for i = 0, 4, 1 do
			local numSlot = GetContainerNumSlots(i);
			for y = 1, numSlot, 1 do
				itemName = AutoMount_GetItemName(i, y)
				for k, v in AutoMount_Mount_Items do
					if (itemName == v) then
						AutoMount_Mount = v;
						return AutoMount_Mount, i, y;
					end
				end
			end
		end
	end
	return AutoMount_Mount;
end
end

if ( not AutoMount_GetMountItemBagSlot ) then
function AutoMount_GetMountItemBagSlot(noLoop)
	if ( AutoMount_HasNoMount ) then
		return nil, nil;
	end
	local itemName, bag, slot = AutoMount_GetMountItemName();
	if ( not itemName ) then
		return nil, nil;
	end 
	if ( bag ) and ( slot ) then
		local serverName = GetCVar("realmName");
		if ( not AutoMountVars ) then
			AutoMountVars = {};
		end
		if ( not AutoMountVars[serverName] ) then
			AutoMountVars[serverName] = {};
		end
		if ( not AutoMountVars[serverName][UnitName("player")] ) then
			AutoMountVars[serverName][UnitName("player")] = {};
		end
		AutoMountVars[serverName][UnitName("player")].bag = bag;
		AutoMountVars[serverName][UnitName("player")].slot = slot;
		return bag, slot;
	end
	if ( AutoMountVars ) then
		local serverName = GetCVar("realmName");
		if ( AutoMountVars ) then
			if ( AutoMountVars[serverName] ) then
				if ( AutoMountVars[serverName][UnitName("player")] ) then
					bag = AutoMountVars[serverName][UnitName("player")].bag;
					slot = AutoMountVars[serverName][UnitName("player")].slot;
					if (AutoMount_GetItemName(bag, slot) == itemName) then
						return bag, slot;
					end
				end
			end
		end
	end
	for i = 0, 4, 1 do
		local numSlot = GetContainerNumSlots(i);
		for y = 1, numSlot, 1 do
			if (AutoMount_GetItemName(i, y) == itemName) then
				if ( not AutoMountVars ) then
					AutoMountVars = {};
				end
				if ( not AutoMountVars[serverName] ) then
					AutoMountVars[serverName] = {};
				end
				if ( not AutoMountVars[serverName][UnitName("player")] ) then
					AutoMountVars[serverName][UnitName("player")] = {};
				end
				AutoMountVars[serverName][UnitName("player")].bag = i;
				AutoMountVars[serverName][UnitName("player")].slot = y;
				return i, y;
			end
		end
	end
	AutoMount_Mount = nil;
	if ( not noLoop ) then
		return AutoMount_GetMountItemBagSlot(true);
	end
	AutoMount_HasNoMount = true;
	return nil, nil;
end
end
