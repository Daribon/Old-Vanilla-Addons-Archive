--[[
	CombatCaller Play Sound Functions
	Added to IX Combat Caller v2.2 by Reuben "Ascendant" Johnson
	
	These functions play the "/OOM" and "/HEALME" emote sounds without the text emote that's goes with them
	The functions are designed to play the sound bases on the char's race and sex
	Since there are at least 2 of each sound for every race and sex, the functions will pick one at random to play (supposedly :p)
	
]]
function IX_PlaySoundMaleHealth()
	-- Determines which sound file to play (at random) based on char's race
	
	local SoundFileID = nil;
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Human") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(HUM_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(HUM_MALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "NightElf") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(NE_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(NE_MALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Dwarf") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(DWARF_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(DWARF_MALE_HEAL_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(DWARF_MALE_HEAL_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Gnome") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(GNOME_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(GNOME_MALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Undead") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(UNDEAD_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(UNDEAD_MALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Orc") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(ORC_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(ORC_MALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Tauren") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TAUREN_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TAUREN_MALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Troll") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TROLL_MALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TROLL_MALE_HEAL_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(TROLL_MALE_HEAL_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end

end

function IX_PlaySoundFemaleHealth()
	-- Determines which sound file to play (at random) based on char's race
	
	local SoundFileID = nil;
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Human") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(HUM_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(HUM_FEMALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "NightElf") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(NE_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(NE_FEMALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Dwarf") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(DWARF_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(DWARF_FEMALE_HEAL_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(DWARF_FEMALE_HEAL_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Gnome") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(GNOME_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(GNOME_FEMALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Undead") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(UNDEAD_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(UNDEAD_FEMALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Orc") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(ORC_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(ORC_FEMALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Tauren") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TAUREN_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TAUREN_FEMALE_HEAL_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Troll") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TROLL_FEMALE_HEAL_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TROLL_FEMALE_HEAL_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(TROLL_FEMALE_HEAL_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end

end

function IX_PlaySoundMaleMana()
	-- Determines which sound file to play (at random) based on char's race

	local SoundFileID = nil;
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Human") then
	
		
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(HUM_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(HUM_MALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "NightElf") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(NE_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(NE_MALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Dwarf") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(DWARF_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(DWARF_MALE_MANA_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(DWARF_MALE_MANA_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Gnome") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(GNOME_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(GNOME_MALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Undead") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(UNDEAD_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(UNDEAD_MALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Orc") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(ORC_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(ORC_MALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Tauren") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TAUREN_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TAUREN_MALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Troll") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TROLL_MALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TROLL_MALE_MANA_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(TROLL_MALE_MANA_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end

end

function IX_PlaySoundFemaleMana()
	-- Determines which sound file to play (at random) based on char's race
	
	local SoundFileID = nil;
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Human") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(HUM_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(HUM_FEMALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "NightElf") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(NE_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(NE_FEMALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Dwarf") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(DWARF_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(DWARF_FEMALE_MANA_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(DWARF_FEMALE_MANA_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Gnome") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(GNOME_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(GNOME_FEMALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Undead") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(UNDEAD_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(UNDEAD_FEMALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Orc") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(ORC_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(ORC_FEMALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Tauren") then
	
		SoundFileID = math.random(1,2);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TAUREN_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TAUREN_FEMALE_MANA_02);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
	if (IX_CombatCaller_Config[ThisCharRealm].Race == "Troll") then
	
		SoundFileID = math.random(1,3);
		
		if (SoundFileID == 1) then
		
			PlaySoundFile(TROLL_FEMALE_MANA_01);
			
		elseif (SoundFileID == 2) then
		
			PlaySoundFile(TROLL_FEMALE_MANA_02);
			
		elseif (SoundFileID == 3) then
		
			PlaySoundFile(TROLL_FEMALE_MANA_03);
			
		else
		
			DCF:AddMessage(ERROR_RANDOM_FAILED);
			
		end
		
	end
	
end
