--[[
Auto Dismount
Automatically dismounts you at a flight master.
By: Sithy aka Bavaria of Icecrown
   ]]
   
AutoMount_Mount_List={
"Spell_Nature_Swiftness",
"Ability_Mount",
"INV_Misc_Foot_Kodo",
}
	
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

AutoMount_Update = false;
AutoMount_Texture = nil;
AutoMount_Mount = nil;

function AutoMount_GetItemName(bag, slot)
	local bagNumber = bag;
	if ( type(bagNumber) ~= "number" ) then
		bagNumber = tonumber(bag);
	end
	if (bagNumber <= -1) then
		GameTooltip:SetInventoryItem("player", slot);
	else
		GameTooltip:SetBagItem(bag, slot);
	end
	return GameTooltipTextLeft1:GetText();
end

function AutoMount_OnEvent(event)
	if event == "TAXIMAP_OPENED" then
		local i, j;
		for i = 0, 15 do
			if not AutoMount_Texture then
				for j = 1, table.getn(AutoMount_Mount_List) do
					if GetPlayerBuffTexture(i) ~= nil then
						if (string.find(GetPlayerBuffTexture(i),AutoMount_Mount_List[j])) then
							CancelPlayerBuff(i);
							AutoMount_Texture = GetPlayerBuffTexture(i);
							break;
						end
					end
				end
			else
				if GetPlayerBuffTexture(i) == AutoMount_Texture then
					CancelPlayerBuff(i);
					break;
				end
			end
		end
	end
end

AutoMount_SpellName = nil;
AutoMount_HasMount = nil;
function AutoMount_ButtonSetup()
	AutoMountButton:Show();
	--local x, y = GetCursorPosition()
	--AutoMountButton:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", x, -y);
end

function AutoMount_OnUpdate(arg1)
	if not AutoMount_Update then
		if UnitOnTaxi("player") then AutoMount_Update = true; end
	end
	if AutoMount_Update then
		if not UnitOnTaxi("player") then
			local class,_ = UnitClass("player");
			local level = UnitLevel("player");
			for i = 0, 4, 1 do
				local numSlot = GetContainerNumSlots(i);
				for y = 1, numSlot, 1 do
						if not AutoMount_Mount then
							for z = 1, table.getn(AutoMount_Mount_Items), 1 do
								if (strupper(AutoMount_GetItemName(i, y)) == strupper(AutoMount_Mount_Items[z])) then
									UseContainerItem(i, y);
									AutoMount_Mount = AutoMount_Mount_Items[z];
									AutoMount_Update = false;
									break;
								end
							end
						else
							if (strupper(AutoMount_GetItemName(i, y)) == strupper(AutoMount_Mount)) then
								UseContainerItem(i, y);
								AutoMount_Update = false;
								break;
							end
						end
					--end
				end
			end
		end
	end
end
  
function AutoMount_OnClick()
	CastSpellByName(AutoMount_SpellName);
	AutoMountButton:Hide();
end
