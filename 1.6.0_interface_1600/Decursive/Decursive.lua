--TODO add mana check to the decursive... so it won't cast the spell if out of mana

-------------------------------------------------------------------------------
-- Debug commands
--
-- These are commands to change any of the default actions of Decursive.
-- Change these to customize how you want things. The purpose of these flags
-- is for mod developers to customize the behavour, or for confidant people
-- to muck with things
-------------------------------------------------------------------------------

-- this will spam... really only use it for testing
local Dcr_Print_Spell_Found = false;
-- turning this off will disable all status messages except error
local Dcr_Print_Anything    = true;
-- this will disable error messages
local Dcr_Print_Error       = true;
-- check for abolish XXX before curing poison or disease
local Dcr_Check_For_Abolish = true;
-- this is the limit of items in which to cast abolish... 0... always 1, only when 2 or more
local Dcr_Abolish_Limit     = 0;
-- if nothign is cleaned... and we have an enemy selected... cast combat remove magic
local Dcr_CastDispellMagic  = false;
-- how many seconds... can be fractional... needs to be more than 0.4... 1.0 is optimal
local Dcr_SpellCombatDelay  = 1.0;
-- how many seconds to "black list" someone with a failed spell
local Dcr_CureBlacklist     = 3.0;
-- print out a fuckload of info
local Dcr_Print_DEBUG       = false;

-------------------------------------------------------------------------------
-- here is the global variables, these should not be changed. These basically
-- are the limits of WoW client.
-------------------------------------------------------------------------------
DCR_MAXDEBUFFS = 8;
DCR_MAXBUFFS   = 16;
DCR_START_SLOT = 1;
DCR_END_SLOT   = 120;


-------------------------------------------------------------------------------
-- and the printing functions
-------------------------------------------------------------------------------
function Dcr_debug( Message)
	if (Dcr_Print_DEBUG) then
		DEFAULT_CHAT_FRAME:AddMessage(Message, 0.1, 0.1, 1);
	end
end

function Dcr_println( Message)
	if (Dcr_Print_Anything) then
		DEFAULT_CHAT_FRAME:AddMessage(Message, 1, 1, 1);
	end
end

function Dcr_errln( Message)
	if (Dcr_Print_Error) then
		DEFAULT_CHAT_FRAME:AddMessage(Message, 1, 0.1, 0.1);
	end
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- variables
-------------------------------------------------------------------------------
local Dcr_Unit_Array = { };
local Dcr_Range_Icons = {
};
-- then the spells to be used
local DCR_SPELL_DISPELL_MAGIC_1 = DCR_SPELL_DISPELL_MAGIC.."("..DCR_SPELL_RANK_1..")";
local DCR_SPELL_DISPELL_MAGIC_2 = DCR_SPELL_DISPELL_MAGIC.."("..DCR_SPELL_RANK_2..")";
local DCR_SPELL_PURGE_1         = DCR_SPELL_PURGE.."("..DCR_SPELL_RANK_1..")";
local DCR_SPELL_PURGE_2         = DCR_SPELL_PURGE.."("..DCR_SPELL_RANK_2..")";

local Dcr_Spell_Book = nil;
-- this is the order for searching... to cast on a mob if we do it
local Dcr_Enemy_SpellArray = {
		[DCR_SPELL_DISPELL_MAGIC_2] = true,
		[DCR_SPELL_DISPELL_MAGIC_1] = true,
		[DCR_SPELL_PURGE_2]  = true,
		[DCR_SPELL_PURGE_1]  = true,
}

local Dcr_Casting_Spell_On = nil;
Dcr_Blacklist_Array = { };
-------------------------------------------------------------------------------
-- configuration functions
-------------------------------------------------------------------------------
function Dcr_Init()
	-- Dcr_println(DCR_VERSION_STRING);
	-- Register our slash commands
	SLASH_DECURSIVE1 = DCR_MACRO_COMMAND;
	SlashCmdList["DECURSIVE"] = function(msg)
		Dcr_Commands(msg);
	end

	Dcr_Configure();

	-- create the array of curable items
	local i;
	table.insert(Dcr_Unit_Array, "player");
	for i = 1, 4 do
		table.insert(Dcr_Unit_Array,"party"..i);
	end
	for i = 1, 40 do
		table.insert(Dcr_Unit_Array,"raid"..i);
	end
	-- now the pets
	table.insert(Dcr_Unit_Array,"pet");
	for i = 1, 4 do
		table.insert(Dcr_Unit_Array,"partypet"..i);
	end
	for i = 1, 40 do
		table.insert(Dcr_Unit_Array,"raidpet"..i);
	end
end

function Dcr_Commands(msg)
	if( msg ) then
		local command = string.lower(msg);
		if( command == "" ) then
			Dcr_Clean();
		else
			Dcr_errln(DCR_MACRO_ERROR);
		end
	end
end

function Dcr_Configure()

	-- first empty out the old spellbook
	Dcr_Spell_Book = nil;

	-- parse through the entire library...
	-- look for known cleaning spells...
	-- this will be called everytime the spellbook changes

	-- this is just used to make things simpler in the spellbook
	local Dcr_Name_Array = {
		[DCR_SPELL_CURE_DISEASE]        = true,
		[DCR_SPELL_ABOLISH_DISEASE]     = true,
		[DCR_SPELL_PURIFY]              = true,
		[DCR_SPELL_CLEANSE]             = true,
		[DCR_SPELL_DISPELL_MAGIC]       = true,
		[DCR_SPELL_CURE_POISON]         = true,
		[DCR_SPELL_ABOLISH_POISON]      = true,
		[DCR_SPELL_REMOVE_LESSER_CURSE] = true,
		[DCR_SPELL_REMOVE_CURSE]        = true,
		[DCR_SPELL_PURGE]               = true,
	}
	local i = 1

	while (true) do
		local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
		if (not spellName) then
			do break end
		end

		if (Dcr_Name_Array[spellName]) then

			-- put it in the range icon array
			local icon = GetSpellTexture(i, BOOKTYPE_SPELL)
			Dcr_Range_Icons[icon] = spellName;

			-- now append the spell rank if it exists
			if (spellRank ~= DCR_SPELL_NO_RANK) then
				spellName = spellName.."("..spellRank..")";
			end

			-- print out the spell
			if (Dcr_Print_Spell_Found) then
		   		Dcr_println( string.gsub(DCR_SPELL_FOUND, "$s", spellName));
			end

			-- add it to the spellbook
			if (not Dcr_Spell_Book) then
				Dcr_Spell_Book = { };
			end
			Dcr_Spell_Book[spellName] = i;
		end

		i = i + 1
	end

end


-------------------------------------------------------------------------------
-- the combat saver functions and events. These keep us in combat mode
-------------------------------------------------------------------------------
local Dcr_CombatMode = false;
function Dcr_EnterCombat()
	Dcr_debug("Entering combat");
	Dcr_CombatMode = true;
end

function Dcr_LeaveCombat()
	Dcr_debug("Leaving combat");
	Dcr_CombatMode = false;
end


local Dcr_DelayTimer = 0;
function Dcr_OnUpdate(arg1)

	-- clean up the blacklist
	for unit in Dcr_Blacklist_Array do
		Dcr_Blacklist_Array[unit] = Dcr_Blacklist_Array[unit] - arg1;
		if (Dcr_Blacklist_Array[unit] < 0) then
			Dcr_Blacklist_Array[unit] = nil;
		end
	end

	-- wow the next command SPAMS alot
	-- Dcr_debug("got update "..arg1);

	-- this is the fix for the AttackTarget() bug
	if (Dcr_DelayTimer > 0) then
		Dcr_DelayTimer = Dcr_DelayTimer - arg1;
		if (Dcr_DelayTimer <= 0) then
			if (not Dcr_CombatMode) then
				Dcr_debug("trying to reset the combat mode");
				AttackTarget();
			else
				Dcr_debug("already in combat mode");
			end
		end;
	end
end

-------------------------------------------------------------------------------
-- Scanning functionalty... this scans the parties and groups
-------------------------------------------------------------------------------
function Dcr_Clean()
	-----------------------------------------------------------------------
	-- first we do the setup, make sure we can cast the spells
	-----------------------------------------------------------------------
	if ( not Dcr_Spell_Book) then
	   	Dcr_errln(DCR_NO_SPELLS);
	   	return false;
	end

	local canCastSpell = false;

	local spellName, spellID;
	for spellName, spellID in Dcr_Spell_Book do
		local last_cast, cooldown;
		last_cast, cooldown = GetSpellCooldown(spellID, SpellBookFrame.bookType)
		if (cooldown ~= 0) then
	   		Dcr_debug(  "Spell not ready... "..spellName);
	   	else
	   		canCastSpell = true;
		end
	end

	if (not canCastSpell) then
		-- this used to be an errline... changed it to debugg
		Dcr_debug(DCR_NO_SPELLS_RDY);
		return false;
	end

	-----------------------------------------------------------------------
	-----------------------------------------------------------------------
	-- then we see what our target looks like, if freindly, check them
	-----------------------------------------------------------------------

	local targetEnemy = false;
	local targetName = nil;
	local cleaned = false;
	local resetCombatMode = false;
	Dcr_Casting_Spell_On = nil;

	if (UnitExists("target")) then
		-- if we are currently targeting something

		if (Dcr_CombatMode) then
			Dcr_debug("when done scanning... if switched target reset the mode!");
			resetCombatMode = true;
		end

		if (UnitIsFriend("target", "player")) then

			-- try cleanign the current target first
			cleaned = Dcr_CureUnit("target");

			-- we are targeting a player, save the name to switch back later
			targetName = UnitName("target");

		else
			-- we are targeting an enemy... switch back when done
			targetEnemy = true;

			if ( UnitIsCharmed("target")) then
				-- try cleanign mind controlled person first
				cleaned = Dcr_CureUnit("target");
			end
		end
	end;

	-----------------------------------------------------------------------
	-----------------------------------------------------------------------
	-- now we check the partys (raid and local)
	-----------------------------------------------------------------------

	-- this is the cleaning loops...
	if( not cleaned) then
		for _, unit in Dcr_Unit_Array do
			-- all of the units...
			-- the order is player, party1-4, raid1-40, pet, partypet1-4, raidpet1-40
			if (UnitExists(unit)) then
				-- if the unit is there
				if (not Dcr_Blacklist_Array[unit]) then
					-- if the unit is not black listed
					if (UnitIsVisible(unit)) then
						-- if the unit is even close by
						if (Dcr_CureUnit(unit)) then
							cleaned = true;
							break;
						end
					end
				end
			end
		end
	end

	if ( not cleaned) then
		for unit in Dcr_Blacklist_Array do
			-- now... all of the black listed units
			if (UnitExists(unit)) then
				-- if the unit is not black listed
				if (UnitIsVisible(unit)) then
					-- if the unit is even close by
					if (Dcr_CureUnit(unit)) then
						-- hey... we cleaned it... remove from the black list
						Dcr_Blacklist_Array[unit] = nil;
						cleaned = true;
						break;
					end
				end
			end
		end
	end

	-----------------------------------------------------------------------
	-----------------------------------------------------------------------
	-- ok... done with the cleaning... lets try to clean this up
	-- basically switch targets back if they were changed
	-----------------------------------------------------------------------

	if (targetEnemy) then
		-- we had somethign "bad" targeted
		if (not UnitIsEnemy("target", "player")) then
			-- and we scanned a pet, cast dispell magic, or some how broke target... switch back
			Dcr_debug("targeting enemy");
			TargetLastEnemy();
			if (resetCombatMode) then
				-- resetCombatMode is the fix
				Dcr_DelayTimer = Dcr_SpellCombatDelay;
				Dcr_debug("done... now we wait for the leave combat event");
			end
		end
		-- now that we are back on the enemy....
		-- lets see if we want to cast dispell magic if nothing was cleaned
		if (Dcr_CastDispellMagic and (not cleaned)) then
			if (not UnitIsFriend("target", "player")) then
				-- becasue neaturals can be attacked

				local spellName;
				for spellName in Dcr_Enemy_SpellArray do
					if (Dcr_Spell_Book[spellName]) then
						Dcr_println(string.gsub(DCR_DISPELL_ENEMY, "$s", spellName));
						local spellID = Dcr_Spell_Book[key];
						CastSpell(spellID, SpellBookFrame.bookType);
						cleaned = true;
					end
				end
			end
		end

	elseif (targetName) then
		-- we had a freindly targeted... switch back if not still targeted
		if ( targetName ~= UnitName("target") ) then
			TargetByName(targetName);
		end
	else
		-- we had nobody targeted originally
		if (UnitExists("target")) then
			-- we scanned a pet
			ClearTarget();
		end
	end

	if (not cleaned) then
		Dcr_println( DCR_NOT_CLEANED);
		Dcr_LastUnitChecked = 0;
		Dcr_LastPetChecked = 0;
	end

	return cleaned;
end



-------------------------------------------------------------------------------
-- these are the spells used to clean a "unit" given
-------------------------------------------------------------------------------
function Dcr_CureUnit(Unit)
	Dcr_debug( "Curing - "..Unit);

	local Magic_Count = 0;
	local Disease_Count = 0;
	local Poison_Count = 0;
	local Curse_Count = 0;
	local TClass, UClass = UnitClass(Unit);


	for i = 1, DCR_MAXDEBUFFS do
		local debuff_texture = UnitDebuff(Unit, i);

		if debuff_texture then

			Dcr_TooltipTextRight1:SetText(nil);
			Dcr_Tooltip:SetUnitDebuff(Unit, i);
			local debuff_type = Dcr_TooltipTextRight1:GetText();
			local debuff_name = Dcr_TooltipTextLeft1:GetText();

			Dcr_debug( debuff_name.." found!");

			if (DCR_IGNORELIST[debuff_name]) then
				-- these are the BAD ones... the ones that make the target immune... abort the user
		   		Dcr_println( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
				return false;
			end

			if (DCR_SKIP_LIST[debuff_name]) then
				-- these are just ones you don't care about
	   		Dcr_println( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
				break;
			end
			if (DCR_SKIP_BY_CLASS_LIST[UClass]) then
				if (DCR_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
					-- these are just ones you don't care about by class
		   		Dcr_println( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
					break;
				end
			end

			if (debuff_type) then
				if (debuff_type == DCR_MAGIC) then
					Magic_Count = Magic_Count + 1;
				elseif (debuff_type == DCR_DISEASE) then
					Disease_Count = Disease_Count + 1;
				elseif (debuff_type == DCR_POISON) then
					Poison_Count = Poison_Count + 1;
				elseif (debuff_type == DCR_CURSE) then
					Curse_Count = Curse_Count + 1
				end
			end

		end
	end

  local res = false;
  -- order these in the way you find most important
	if (not res) then
		res = Dcr_Cure_Magic(Magic_Count, Unit);
	end
	if (not res) then
		res = Dcr_Cure_Curse( Curse_Count, Unit);
	end
	if (not res) then
		res = Dcr_Cure_Poison( Poison_Count, Unit);
	end
	if (not res) then
		res = Dcr_Cure_Disease( Disease_Count, Unit);
	end

	return res;
end

function Dcr_Cure_Magic(Magic_Count, Unit)
	if (
		(
			(not Dcr_Spell_Book[DCR_SPELL_DISPELL_MAGIC_1]) and
			(not Dcr_Spell_Book[DCR_SPELL_DISPELL_MAGIC_2]) and
			(not Dcr_Spell_Book[DCR_SPELL_PURGE_1]) and
			--(not Dcr_Spell_Book[DCR_SPELL_PURGE_2]) and
			(not Dcr_Spell_Book[DCR_SPELL_CLEANSE])
		) or (Magic_Count == 0)
	) then
		-- here is no magical effects... or
		-- we can't cure magic don't bother going forward
		return false;
	end
	if (UnitIsCharmed(Unit)) then
		-- unit is charmed... and has magic debuffs on them
		-- there is a good chance that it is the mind controll
		if (Dcr_Spell_Book[DCR_SPELL_PURGE_1]) then
			return Dcr_Cast_CureSpell( DCR_SPELL_PURGE_1, Unit, DCR_CHARMED);
		elseif (Dcr_Spell_Book[DCR_SPELL_DISPELL_MAGIC_1])then
			return Dcr_Cast_CureSpell( DCR_SPELL_DISPELL_MAGIC_1, Unit, DCR_CHARMED);
		end
	else
		if ((Magic_Count > 1) and Dcr_Spell_Book[DCR_SPELL_DISPELL_MAGIC_2]) then
			return Dcr_Cast_CureSpell( DCR_SPELL_DISPELL_MAGIC_2, Unit, DCR_MAGIC);
		elseif (Dcr_Spell_Book[DCR_SPELL_CLEANSE]) then
			return Dcr_Cast_CureSpell( DCR_SPELL_CLEANSE, Unit, DCR_MAGIC);
		elseif (Dcr_Spell_Book[DCR_SPELL_DISPELL_MAGIC_1]) then
			return Dcr_Cast_CureSpell( DCR_SPELL_DISPELL_MAGIC_1, Unit, DCR_MAGIC);
		end
	end
	return false;
end

function Dcr_Cure_Curse( Curse_Count, Unit)
	if (
		(
			(not Dcr_Spell_Book[DCR_SPELL_REMOVE_LESSER_CURSE]) and
			(not Dcr_Spell_Book[DCR_SPELL_REMOVE_CURSE])
		) or (Curse_Count == 0)
	) then
		-- no curses or no curse curing spells
		return false;
	end

	if (UnitIsCharmed(Unit)) then
		-- we can not cure a mind contorolled player
		return;
	end

	if Dcr_Spell_Book[DCR_SPELL_REMOVE_CURSE] then
		return Dcr_Cast_CureSpell(DCR_SPELL_REMOVE_CURSE, Unit, DCR_CURSE);
	else
		return Dcr_Cast_CureSpell(DCR_SPELL_REMOVE_LESSER_CURSE, Unit, DCR_CURSE);
	end
end

function Dcr_Cure_Poison(Poison_Count, Unit)
	if (
		(
			(not Dcr_Spell_Book[DCR_SPELL_CURE_POISON]) and
			(not Dcr_Spell_Book[DCR_SPELL_ABOLISH_POISON]) and
			(not Dcr_Spell_Book[DCR_SPELL_PURIFY]) and
			(not Dcr_Spell_Book[DCR_SPELL_CLEANSE])
		) or (Poison_Count == 0)
	) then
		-- here is no magical effects... or
		-- we can't cure magic don't bother going forward
		return false;
	end

	if (UnitIsCharmed(Unit)) then
		-- we can not cure a mind contorolled player
		return;
	end

	if (Dcr_Check_For_Abolish) then
		if (Dcr_CheckUnitForBuff(Unit, DCR_SPELL_ABOLISH_POISON)) then
			return false;
		end
	end

	if ((Poison_Count > Dcr_Abolish_Limit) and Dcr_Spell_Book[DCR_SPELL_ABOLISH_POISON]) then
		return Dcr_Cast_CureSpell( DCR_SPELL_ABOLISH_POISON, Unit, DCR_POISON);
	elseif (Dcr_Spell_Book[DCR_SPELL_PURIFY]) then
		return Dcr_Cast_CureSpell( DCR_SPELL_PURIFY, Unit, DCR_POISON);
	elseif (Dcr_Spell_Book[DCR_SPELL_CLEANSE]) then
		return Dcr_Cast_CureSpell( DCR_SPELL_CLEANSE, Unit, DCR_POISON);
	else
		return Dcr_Cast_CureSpell( DCR_SPELL_CURE_POISON, Unit, DCR_POISON);
	end
end

function Dcr_Cure_Disease(Disease_Count, Unit)
	if (
		(
			(not Dcr_Spell_Book[DCR_SPELL_CURE_DISEASE]) and
			(not Dcr_Spell_Book[DCR_SPELL_ABOLISH_DISEASE]) and
			(not Dcr_Spell_Book[DCR_SPELL_PURIFY]) and
			(not Dcr_Spell_Book[DCR_SPELL_CLEANSE])
		) or (Disease_Count == 0)
	) then
		-- here is no magical effects... or
		-- we can't cure magic don't bother going forward
		return false;
	end

	if (UnitIsCharmed(Unit)) then
		-- we can not cure a mind contorolled player
		return;
	end

	if (Dcr_Check_For_Abolish) then
		if (Dcr_CheckUnitForBuff(Unit, DCR_SPELL_ABOLISH_DISEASE)) then
			return false;
		end
	end

	if ((Disease_Count > Dcr_Abolish_Limit) and Dcr_Spell_Book[DCR_SPELL_ABOLISH_DISEASE]) then
		return Dcr_Cast_CureSpell( DCR_SPELL_ABOLISH_DISEASE, Unit, DCR_DISEASE);
	elseif (Dcr_Spell_Book[DCR_SPELL_PURIFY]) then
		return Dcr_Cast_CureSpell( DCR_SPELL_PURIFY, Unit, DCR_DISEASE);
	elseif (Dcr_Spell_Book[DCR_SPELL_CLEANSE]) then
		return Dcr_Cast_CureSpell( DCR_SPELL_CLEANSE, Unit, DCR_DISEASE);
	else
		return Dcr_Cast_CureSpell( DCR_SPELL_CURE_DISEASE, Unit, DCR_DISEASE);
	end
end

function Dcr_Cast_CureSpell( spellName, Unit, AfflictionType)
	local name = UnitName(Unit);
	-- check to see if we are in range
	if (not Dcr_UnitInRange(Unit)) then
		Dcr_errln( string.gsub( string.gsub(DCR_OUT_OF_RANGE, "$t", name), "$a", AfflictionType));
		return false;
	end

	-- clear the target if it will interfear
	if (Dcr_Enemy_SpellArray[spellName]) then
		-- it can target enemys... do don't target ANYTHING else
		if ( not UnitIsUnit( "target", Unit) ) then
			ClearTarget();
		end
	elseif ( UnitIsFriend( "player", "target") ) then
		-- we can accedenally cure friendly targets...
		if ( not UnitIsUnit( "target", Unit) ) then
			-- and we want to cure someone else who is not targeted
			ClearTarget();
		end
	end

	Dcr_Casting_Spell_On = Unit;
	Dcr_println( string.gsub( string.gsub( string.gsub(DCR_CLEAN_STRING, "$t", name), "$a", AfflictionType), "$s", spellName));
	CastSpell(Dcr_Spell_Book[spellName], SpellBookFrame.bookType);
	SpellTargetUnit(Unit);

	return true;
end


function Dcr_SpellCastFailed()
	if (Dcr_Casting_Spell_On) then
		Dcr_Blacklist_Array[Dcr_Casting_Spell_On] = Dcr_CureBlacklist;
	end
end

function Dcr_SpellWasCast()
	Dcr_Casting_Spell_On = nil;
end

function Dcr_CheckUnitForBuff(Unit, BuffName)
	if (Dcr_Check_For_Abolish) then
		for i = 1, DCR_MAXBUFFS do
			local buff_texture = UnitBuff(Unit, i);

			if buff_texture then

				Dcr_TooltipTextRight1:SetText(nil);
				Dcr_Tooltip:SetUnitBuff(Unit, i);

				if (Dcr_TooltipTextLeft1:GetText() == BuffName) then
					return true;
				end
			end
		end
	end
	return false;
end

-------------------------------------------------------------------------------
-- now the range functions....
-------------------------------------------------------------------------------
function Dcr_UnitInRange(Unit)
	-- this means that we are not even fraking close...
	-- don't bother going further
	if (not UnitIsVisible(Unit)) then
		return false;
	end

	local Dcr_Range_Slot = Dcr_FindCureingActionSlot();

	if (Dcr_Range_Slot ~= 0) then
		TargetUnit(Unit);
		if UnitIsUnit("target", Unit) then
			return (IsActionInRange(Dcr_Range_Slot) == 1);
		else
			return false; -- if we can't target... then its out of range
		end
	end

	-- we don't know... return true just in case
	return true;

end

function Dcr_FindCureingActionSlot()
	local i = 0;
	for i = DCR_START_SLOT, DCR_END_SLOT do
		if (HasAction(i)) then
			icon = GetActionTexture(i);
			if (Dcr_Range_Icons[icon]) then
				if (GetActionText(i) == nil) then
					local spellName = Dcr_Range_Icons[icon];
					Dcr_Tooltip:ClearLines();
					Dcr_Tooltip:SetAction(i);
					local slotName = Dcr_TooltipTextLeft1:GetText();
					if (spellName == slotName) then
						return i;
					end
				end
			end
		end
	end
	return 0;
end

-- THIS FUNCTION IS NOT USED
-- I am leaving this function here... as a just in case
-- I don't use it anymore... but the numbers are pretty cool
function Dcr_UnitRangeOutdoors(Unit)
	-- logic and numbers borrowed from buffbot
	-- this is in case we can't find a debuff on the list

	SetMapToCurrentZone();
	local continent = GetCurrentMapContinent();
	if (continent == 0) then
		-- we are in an instance....
		return -1;
	end

	if GetCurrentMapZone() > 0 then
		-- ok... we are on the right contenent... now zoom to our map
		-- there is a bug with reloadui... its on the wowwiki... need to set the zoom level
		SetMapZoom(continent)
	end

	local px, py = GetPlayerMapPosition("player");
	local ux, uy = GetPlayerMapPosition(Unit);

	if (ux == 0 and uy == 0) or (px == 0 and py == 0) then
		-- um... something not working... forget about it ^_^
		return -1;
	end

	-- the following numbers are taken from faith from buffbot

	local mapFileName, textureHeight, textureWidth = GetMapInfo();
	local xdelta = ((ux - px) * textureWidth)   * 1.47167;
	local ydelta = ((uy - py) * textureHeight);
	local distance;

	if  continent == 2 then

		distance = sqrt(xdelta*xdelta + ydelta*ydelta) * 11.65;

	elseif continent == 1 then

		distance = sqrt(xdelta*xdelta + ydelta*ydelta) * 12.13;

	else

		return -1;

	end

	return (math.floor(distance*100)/100)
end

function DecursiveUUIReg()
	if(UltimateUI_RegisterButton) then
		UltimateUI_RegisterButton ( 
			"Decursive", 
			"Cleanse", 
			"Cleanse", 
			"Interface\\Icons\\Spell_Holy_MindVision", 
			Dcr_Clean
		);
	end
end