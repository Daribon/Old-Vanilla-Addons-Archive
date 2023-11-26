-------------------------------------------------------------------------------
-- TODO add mana check to the decursive... so it won't cast the spell if out of mana
-- TODO allow people to edit and store the debuffs them selves... to custimze the skip list
-- TODO add a debuff priority list... "IE look for these first"
-- TODO add warlock support
-- TODO make the main bar "hideable" instead of just closeable
-- TODO figure out a way to show that there is more than one debuff in the live list
-- TODO add more macro and keybidnings
-------------------------------------------------------------------------------
   
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
-- how many seconds... can be fractional... needs to be more than 0.4... 1.0 is optimal
local Dcr_SpellCombatDelay = 1.0;
-- print out a fuckload of info
local Dcr_Print_DEBUG = false;
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- here is the global variables, these should not be changed. These basically
-- are the limits of WoW client.
-------------------------------------------------------------------------------
DCR_MAXDEBUFFS = 16;
DCR_MAXBUFFS   = 32;
DCR_START_SLOT = 1;
DCR_END_SLOT   = 120;
-------------------------------------------------------------------------------
-- and any internal HARD settings for decursive
DCR_MAX_LIVE_SLOTS = 15;
DCR_TEXT_LIFETIME = 2;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- The stored variables
-------------------------------------------------------------------------------
Dcr_vars = {
	-- this is the items that are stored... I might later do this per account.                                               	
	
	-- this is the priority list of people to cure
	PriorityList = { };

	-- this is the people to skip
	SkipList = { };
	
	-- this is wiether or not to show the "live" list	
	Show_LiveList = true;
	
	-- This will turn on and off the sending of messages to the default chat frame
	Print_ChatFrame = true;

	-- this will send the messages to a custom frame that is moveable	
	Print_CustomFrame = false;
	
	-- this will disable error messages
	Print_Error = true;
	
	-- check for abolish XXX before curing poison or disease
	Check_For_Abolish = true;
	
	-- this is "fix" for the fact that rank 1 of dispell magic does not always remove
	-- the high level debuffs properly. This carrys over to other things.
	AlwaysUseBestSpell = true;
	
	-- should we do the orders randomly?
	Random_Order = false;
	
	-- should we scan pets
	Scan_Pets = true;
	
	-- should we scan pets
	Ingore_Stealthed = false;
	
	-- how many to show in the livelist
	Amount_Of_Afflicted = 5;

	-- how many seconds to "black list" someone with a failed spell
	CureBlacklist	= 5.0;
	
	-- how often to poll for afflictions in seconds
	ScanTime = 0.2;
	
};
-- this is something i use for remote debugging
DCR_DEBUG_STUFF = { };


-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- and the printing functions
-------------------------------------------------------------------------------
function Dcr_debug( Message)
	if (Dcr_Print_DEBUG) then
		table.insert(DCR_DEBUG_STUFF, Message);
		DEFAULT_CHAT_FRAME:AddMessage(Message, 0.1, 0.1, 1);
	end
end

function Dcr_println( Message)

	if (Dcr_vars.Print_ChatFrame) then
		DEFAULT_CHAT_FRAME:AddMessage(Message, 1, 1, 1);
	end
	if (Dcr_vars.Print_CustomFrame) then
		DecursiveTextFrame:AddMessage(Message, 1, 1, 1, 0.9, DCR_TEXT_LIFETIME);
	end
end

function Dcr_errln( Message)
	if (Dcr_vars.Print_Error) then
		if (Dcr_vars.Print_ChatFrame) then
			DEFAULT_CHAT_FRAME:AddMessage(Message, 1, 0.1, 0.1);
		end
		if (Dcr_vars.Print_CustomFrame) then
			DecursiveTextFrame:AddMessage(Message, 1, 0.1, 0.1, 0.9, DCR_TEXT_LIFETIME);
		end
	end
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- local variables
-------------------------------------------------------------------------------
local Dcr_Range_Icons = { };

-- the new spellbook (made it simpler due to localization problems)
local DCR_HAS_SPELLS = false;
local DCR_SPELL_MAGIC_1 = 0;
local DCR_SPELL_MAGIC_2 = 0;
local DCR_CAN_CURE_MAGIC = false;
local DCR_SPELL_ENEMY_MAGIC_1 = 0;
local DCR_SPELL_ENEMY_MAGIC_2 = 0;
local DCR_CAN_CURE_ENEMY_MAGIC = false;
local DCR_SPELL_DISEASE_1 = 0;
local DCR_SPELL_DISEASE_2 = 0;
local DCR_CAN_CURE_DISEASE = false;
local DCR_SPELL_POISON_1 = 0;
local DCR_SPELL_POISON_2 = 0;
local DCR_CAN_CURE_POISON = false;
local DCR_SPELL_CURSE = 0;
local DCR_CAN_CURE_CURSE = false;
local DCR_SPELL_COOLDOWN_CHECK = 0;

-- for the blacklist
local Dcr_Casting_Spell_On = nil;
local Dcr_Blacklist_Array = { };

-------------------------------------------------------------------------------
-- init functions and configuration functions
-------------------------------------------------------------------------------
function Dcr_Init()
	Dcr_println(DCR_VERSION_STRING);

	Dcr_debug( "Registering the slash commands");
	SLASH_DECURSIVE1 = DCR_MACRO_COMMAND;
	SlashCmdList["DECURSIVE"] = function(msg)
		Dcr_Clean();
	end

	SLASH_DECURSIVEPRADD1 = DCR_MACRO_PRADD;
	SlashCmdList["DECURSIVEPRADD"] = function(msg)
		Dcr_AddTargetToPriorityList();
	end
	SLASH_DECURSIVEPRCLEAR1 = DCR_MACRO_PRCLEAR;
	SlashCmdList["DECURSIVEPRCLEAR"] = function(msg)
		Dcr_ClearPriorityList();
	end
	SLASH_DECURSIVEPRLIST1 = DCR_MACRO_PRLIST;
	SlashCmdList["DECURSIVEPRLIST"] = function(msg)
		Dcr_PrintPriorityList();
	end
	SLASH_DECURSIVEPRSHOW1 = DCR_MACRO_PRSHOW;
	SlashCmdList["DECURSIVEPRSHOW"] = function(msg)
		Dcr_ShowHidePriorityListUI();
	end

	SLASH_DECURSIVESKADD1 = DCR_MACRO_SKADD;
	SlashCmdList["DECURSIVESKADD"] = function(msg)
		Dcr_AddTargetToSkipList();
	end
	SLASH_DECURSIVESKCLEAR1 = DCR_MACRO_SKCLEAR;
	SlashCmdList["DECURSIVESKCLEAR"] = function(msg)
		Dcr_ClearSkipList();
	end
	SLASH_DECURSIVESKLIST1 = DCR_MACRO_SKLIST;
	SlashCmdList["DECURSIVESKLIST"] = function(msg)
		Dcr_PrintSkipList();
	end
	SLASH_DECURSIVESKSHOW1 = DCR_MACRO_SKSHOW;
	SlashCmdList["DECURSIVESKSHOW"] = function(msg)
		Dcr_ShowHideSkipListUI();
	end
	
	SLASH_DECURSIVESHOW1 = DCR_MACRO_SHOW;
	SlashCmdList["DECURSIVESHOW"] = function(msg)
		Dcr_ShowHideAfflictedListUI()
	end
	
	if (Dcr_vars.Show_LiveList) then
		DecursiveAfflictedListFrame:Show();
	else
		DecursiveAfflictedListFrame:Hide();
	end

	-- check the spellbook once
	Dcr_Configure();
end

-- this gets an array of units for us to check
function Dcr_GetUnitArray()
	local Dcr_Unit_Array = { };
	-- create the array of curable units

	-- first... the priority list... names that go first!
	-- these are not skipped... even if they are in the skip list
	local pname;
	for _, pname in Dcr_vars.PriorityList do
		local unit = Dcr_NameToUnit( pname);
		if (unit) then
			table.insert(Dcr_Unit_Array,unit);
		end
	end

	-- then everything else
	local i;
	local raidnum = GetNumRaidMembers();
	local temp_table = { };

	-- add your self (you are never skipped)
	table.insert(Dcr_Unit_Array, "player");

	-- add the party members... if they exist
	for i = 1, 4 do
		if (UnitExists("party"..i)) then
			pname = UnitName("party"..i);
			-- check the name to see if we skip
			if (not Dcr_IsInSkipList(pname)) then
				-- we don't skip them
				if (Dcr_vars.Random_Order) then
					table.insert(temp_table,"party"..i);
				else
					table.insert(Dcr_Unit_Array,"party"..i);
				end
			end
		end
	end
	if (Dcr_vars.Random_Order) then
		local temp_max = table.getn(temp_table);
		for i = 1, temp_max do
			table.insert(Dcr_Unit_Array,table.remove(temp_table,random(1, table.getn(temp_table))));
		end
	end

	-- add the raid IDs that are valid...
	-- add it from the sub group after yours... and then loop
	-- around to the group right before yours
	if ( raidnum > 0 ) then
		local currentGroup = 0;
		local name = UnitName( "player");

		for i = 1, raidnum do
			local rName, _, rGroup = GetRaidRosterInfo(i);
			if (rName == name) then
				currentGroup = rGroup;
				break;
			end
		end

		-- first the groups that are after yours
		for i = 1, raidnum do
			local pname, _, rGroup = GetRaidRosterInfo(i);
			-- get the group and name
			if (rGroup > currentGroup) then
				-- group is after ours
				if (not Dcr_IsInSkipList(pname)) then
					-- and we are not skipping this name
					if (Dcr_vars.Random_Order) then
						table.insert(temp_table,"raid"..i);
					else
						table.insert(Dcr_Unit_Array,"raid"..i);
					end
				end
			end
		end
		-- the the ones that are before yours
		for i = 1, raidnum do
			local pname, _, rGroup = GetRaidRosterInfo(i);
			-- get the group and name
			if (rGroup < currentGroup) then
				-- its before our group
				if (not Dcr_IsInSkipList(pname)) then
					-- and we are not skipping this name
					if (Dcr_vars.Random_Order) then
						table.insert(temp_table,"raid"..i);
					else
						table.insert(Dcr_Unit_Array,"raid"..i);
					end
				end
			end
		end
		-- don't bother with your own group... since its also party 1-4

		if (Dcr_vars.Random_Order) then
			local temp_max = table.getn(temp_table);
			for i = 1, temp_max do
				table.insert(Dcr_Unit_Array,table.remove(temp_table,random(1, table.getn(temp_table))));
			end
		end
	end

	if (not Dcr_vars.Scan_Pets) then
		-- we are not doing pets... leave here
		return Dcr_Unit_Array;
	end
	-- now the pets

	-- your own pet
	if (UnitExists("pet")) then
		table.insert(Dcr_Unit_Array,"pet");
	end

	-- the perties pets if they have them
	for i = 1, 4 do
		if (UnitExists("partypet"..i)) then
			pname = UnitName("partypet"..i);
			-- get the pet name
			if (not Dcr_IsInSkipList(pname)) then
				-- to see if we skip it
				if (Dcr_vars.Random_Order) then
					table.insert(temp_table,"partypet"..i);
				else
					table.insert(Dcr_Unit_Array,"partypet"..i);
				end
			end
		end
	end
	if (Dcr_vars.Random_Order) then
		local temp_max = table.getn(temp_table);
		for i = 1, temp_max do
			table.insert(Dcr_Unit_Array,table.remove(temp_table,random(1, table.getn(temp_table))));
		end
	end

	-- and then the raid pets if they are out
	-- don't worry about the fancier logic with the pets
	if ( raidnum > 0 ) then
		for i = 1, raidnum do
			if (UnitExists("raidpet"..i)) then
				pname = UnitName("raidpet"..i);
				-- get pet name
				if (not Dcr_IsInSkipList(pname)) then
					-- to see if we skip it
					if (Dcr_vars.Random_Order) then
						table.insert(temp_table,"raidpet"..i);
					else
						table.insert(Dcr_Unit_Array,"raidpet"..i);
					end
				end
			end
		end
		if (Dcr_vars.Random_Order) then
			local temp_max = table.getn(temp_table);
			for i = 1, temp_max do
				table.insert(Dcr_Unit_Array,table.remove(temp_table,random(1, table.getn(temp_table))));
			end
		end
	end

	return Dcr_Unit_Array;
end

-- Raid/Party Name Check Function
-- this returns the UnitID that the Name points to
-- this does not check "target" or "mouseover"
function Dcr_NameToUnit( Name)
	if (not Name) then
		return false;
	elseif (Name == UnitName("player")) then
		return "player";
	elseif (Name == UnitName("pet")) then
		return "pet";
	elseif (Name == UnitName("party1")) then
		return "party1";
	elseif (Name == UnitName("party2")) then
		return "party2";
	elseif (Name == UnitName("party3")) then
		return "party3";
	elseif (Name == UnitName("party4")) then
		return "party4";
	elseif (Name == UnitName("partypet1")) then
		return "partypet1";
	elseif (Name == UnitName("partypet2")) then
		return "partypet2";
	elseif (Name == UnitName("partypet3")) then
		return "partypet3";
	elseif (Name == UnitName("partypet4")) then
		return "partypet4";
	else
		local numRaidMembers = GetNumRaidMembers();
		if (numRaidMembers > 0) then
			-- we are in a raid
			local i;
			for i=1, numRaidMembers do
				local RaidName = GetRaidRosterInfo(i);
				if ( Name == RaidName) then
					return "raid"..i;
				end
				if ( Name == UnitName("raidpet"..i)) then
					return "raidpet"..i;
				end
			end
		end
	end
	return false;
end

function Dcr_Configure()

	-- first empty out the old "spellbook"
	DCR_HAS_SPELLS = false;
	DCR_SPELL_MAGIC_1 = 0;
	DCR_SPELL_MAGIC_2 = 0;
	DCR_CAN_CURE_MAGIC = false;
	DCR_SPELL_ENEMY_MAGIC_1 = 0;
	DCR_SPELL_ENEMY_MAGIC_2 = 0;
	DCR_CAN_CURE_ENEMY_MAGIC = false;
	DCR_SPELL_DISEASE_1 = 0;
	DCR_SPELL_DISEASE_2 = 0;
	DCR_CAN_CURE_DISEASE = false;
	DCR_SPELL_POISON_1 = 0;
	DCR_SPELL_POISON_2 = 0;
	DCR_CAN_CURE_POISON = false;
	DCR_SPELL_CURSE = 0;
	DCR_CAN_CURE_CURSE = false;


	-- parse through the entire library...
	-- look for known cleaning spells...
	-- this will be called everytime the spellbook changes

	-- this is just used to make things simpler in the checking
	local Dcr_Name_Array = {
		[DCR_SPELL_CURE_DISEASE] = true,
		[DCR_SPELL_ABOLISH_DISEASE] = true,
		[DCR_SPELL_PURIFY] = true,
		[DCR_SPELL_CLEANSE] = true,
		[DCR_SPELL_DISPELL_MAGIC] = true,
		[DCR_SPELL_CURE_POISON] = true,
		[DCR_SPELL_ABOLISH_POISON] = true,
		[DCR_SPELL_REMOVE_LESSER_CURSE] = true,
		[DCR_SPELL_REMOVE_CURSE] = true,
		[DCR_SPELL_PURGE] = true,
	}

	local i = 1

	while (true) do
		local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
		if (not spellName) then
			do break end
		end

		Dcr_debug( "Checking spell - "..spellName);

		if (Dcr_Name_Array[spellName]) then
			Dcr_debug( "Its one we care about");
			DCR_HAS_SPELLS = true;

			-- any of them will work for the cooldown... we store the last
			DCR_SPELL_COOLDOWN_CHECK = i;

			-- put it in the range icon array
			local icon = GetSpellTexture(i, BOOKTYPE_SPELL)
			Dcr_Range_Icons[icon] = spellName;

			-- print out the spell
			Dcr_debug( string.gsub(DCR_SPELL_FOUND, "$s", spellName));
			if (Dcr_Print_Spell_Found) then
		   		Dcr_println( string.gsub(DCR_SPELL_FOUND, "$s", spellName));
			end

			-- big ass if statement... due to the way that the different localizations work
			-- I used to do this more elegantly... but the german WoW broke it

			if ((spellName == DCR_SPELL_CURE_DISEASE) or (spellName == DCR_SPELL_ABOLISH_DISEASE) or
					(spellName == DCR_SPELL_PURIFY) or (spellName == DCR_SPELL_CLEANSE)) then
				DCR_CAN_CURE_DISEASE = true;
				if ((spellName == DCR_SPELL_CURE_DISEASE) or (spellName == DCR_SPELL_PURIFY)) then
					Dcr_debug( "Adding to disease 1");
					DCR_SPELL_DISEASE_1 = i;
				else
					Dcr_debug( "Adding to disease 2");
					DCR_SPELL_DISEASE_2 = i;
				end
			end
			
			if ((spellName == DCR_SPELL_CURE_POISON) or (spellName == DCR_SPELL_ABOLISH_POISON) or
					(spellName == DCR_SPELL_PURIFY) or (spellName == DCR_SPELL_CLEANSE)) then
				DCR_CAN_CURE_POISON = true;
				if ((spellName == DCR_SPELL_CURE_POISON) or (spellName == DCR_SPELL_PURIFY)) then
					Dcr_debug( "Adding to poison 1");
					DCR_SPELL_POISON_1 = i;
				else
					Dcr_debug( "Adding to poison 2");
					DCR_SPELL_POISON_2 = i;
				end
			end
			
			if ((spellName == DCR_SPELL_REMOVE_CURSE) or (spellName == DCR_SPELL_REMOVE_LESSER_CURSE)) then
				Dcr_debug( "Adding to curse");
				DCR_CAN_CURE_CURSE = true;
				DCR_SPELL_CURSE = i;
			end
			
			if ((spellName == DCR_SPELL_DISPELL_MAGIC) or (spellName == DCR_SPELL_CLEANSE)) then
				DCR_CAN_CURE_MAGIC = true;
				if (spellName == DCR_SPELL_CLEANSE) then
					Dcr_debug( "Adding to magic 1");
					DCR_SPELL_MAGIC_1 = i;
				else
					if (spellRank == DCR_SPELL_RANK_1) then
						Dcr_debug( "Adding to magic 1");
						DCR_SPELL_MAGIC_1 = i;
					else
						Dcr_debug( "adding to magic 2");
						DCR_SPELL_MAGIC_2 = i;
					end
				end
			end
			
			if ((spellName == DCR_SPELL_DISPELL_MAGIC) or (spellName == DCR_SPELL_PURGE)) then
				DCR_CAN_CURE_ENEMY_MAGIC = true;
				if (spellRank == DCR_SPELL_RANK_1) then
					Dcr_debug( "Adding to enemy magic 1");
					DCR_SPELL_ENEMY_MAGIC_1 = i;
				else
					Dcr_debug( "Adding to enemy magic 2");
					DCR_SPELL_ENEMY_MAGIC_2 = i;
				end
			end

		end

		i = i + 1
	end

end
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- the priority and skip list function... stuff to manage the lists
-------------------------------------------------------------------------------
function Dcr_ShowHideAfflictedListUI()
	if (DecursiveAfflictedListFrame:IsVisible()) then
		Dcr_vars.Show_LiveList = false;
		DecursiveAfflictedListFrame:Hide();
	else
		Dcr_vars.Show_LiveList = true;
		DecursiveAfflictedListFrame:Show();
	end
end

-- priority list stuff
function Dcr_ShowHidePriorityListUI()
	if (DecursivePriorityListFrame:IsVisible()) then
		DecursivePriorityListFrame:Hide();
	else
		DecursivePriorityListFrame:Show();
	end
end

function Dcr_AddTargetToPriorityList()
	Dcr_debug( "Adding the target to the priority list");
	DcrAddUnitToPriorityList("target");
end

function DcrAddUnitToPriorityList( unit)
	if (UnitExists(unit)) then
		if (UnitIsPlayer(unit)) then
			local name = UnitName( unit);
			for _, pname in Dcr_vars.PriorityList do
				if (name == pname) then
					return;
				end
			end
			table.insert(Dcr_vars.PriorityList,name);
		end
	end
end

function Dcr_RemoveIDFromPriorityList(id)
	table.remove( Dcr_vars.PriorityList,id);
end

function Dcr_ClearPriorityList()
	local i;
	local max = table.getn(Dcr_vars.PriorityList);
	for i = 1, max do
		table.remove( Dcr_vars.PriorityList);
	end
end

function Dcr_PrintPriorityList()
	for id, name in Dcr_vars.PriorityList do
		Dcr_println( id.." - "..name);
	end
end

-- skip list stuff
function Dcr_ShowHideSkipListUI()
	if (DecursiveSkipListFrame:IsVisible()) then
		DecursiveSkipListFrame:Hide();
	else
		DecursiveSkipListFrame:Show();
	end
end

function Dcr_ShowHideOptionsUI()
	if (DcrOptionsFrame:IsVisible()) then
		DcrOptionsFrame:Hide();
	else
		DcrOptionsFrame:Show();
	end
end

function Dcr_ShowHideTextAnchor()
	if (DecursiveAnchor:IsVisible()) then
		DecursiveAnchor:Hide();
	else
		DecursiveAnchor:Show();
	end
end


function Dcr_AddTargetToSkipList()
	Dcr_debug( "Adding the target to the Skip list");
	DcrAddUnitToSkipList("target");
end

function DcrAddUnitToSkipList( unit)
	if (UnitExists(unit)) then
		if (UnitIsPlayer(unit)) then
			local name = UnitName( unit);
			for _, pname in Dcr_vars.SkipList do
				if (name == pname) then
					return;
				end
			end
			table.insert(Dcr_vars.SkipList,name);
		end
	end
end

function Dcr_RemoveIDFromSkipList(id)
	table.remove( Dcr_vars.SkipList,id);
end

function Dcr_ClearSkipList()
	local i;
	local max = table.getn(Dcr_vars.SkipList);
	for i = 1, max do
		table.remove( Dcr_vars.SkipList);
	end
end

function Dcr_PrintSkipList()
	for id, name in Dcr_vars.SkipList do
		Dcr_println( id.." - "..name);
	end
end

function Dcr_IsInSkipList( name)
	if (name) then
		for _, SkipName in Dcr_vars.SkipList do
			if (SkipName == name) then
				return true;
			end
		end
	end
	return false;
end
-------------------------------------------------------------------------------

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

	if (not DCR_HAS_SPELLS) then
	   	Dcr_errln(DCR_NO_SPELLS);
	   	return false;
	end

	local canCastSpell = false;

	local _, cooldown = GetSpellCooldown(DCR_SPELL_COOLDOWN_CHECK, SpellBookFrame.bookType)
	if (cooldown ~= 0) then
		-- this used to be an errline... changed it to debugg
		Dcr_debug(DCR_NO_SPELLS_RDY);
		return false;
	end

	-----------------------------------------------------------------------
	-----------------------------------------------------------------------
	-- then we see what our target looks like, if freindly, check them
	-----------------------------------------------------------------------

	local targetEnemy = false;
	local targetName = nil; -- if freindly
	local cleaned = false;
	local resetCombatMode = false;
	Dcr_Casting_Spell_On = nil;

	if (UnitExists("target")) then
		Dcr_debug("We have a target");
		-- if we are currently targeting something

		if (Dcr_CombatMode) then
			Dcr_debug("when done scanning... if switched target reset the mode!");
			resetCombatMode = true;
		end

		if (UnitIsFriend("target", "player")) then
			Dcr_debug(" It is friendly");

			-- try cleanign the current target first
			cleaned = Dcr_CureUnit("target");

			-- we are targeting a player, save the name to switch back later
			targetName = UnitName("target");

		else
			Dcr_debug(" It is not friendly");
			-- we are targeting an enemy... switch back when done
			targetEnemy = true;

			if ( UnitIsCharmed("target")) then
				Dcr_debug( "Unit is enemey... and charmed... so its a mind controlled friendly");
				-- try cleanign mind controlled person first
				cleaned = Dcr_CureUnit("target");
			end
		end
	end;

	-----------------------------------------------------------------------
	-----------------------------------------------------------------------
	-- now we check the partys (raid and local)
	-----------------------------------------------------------------------
	Dcr_debug( "Checking the arrays");

	-- this is the cleaning loops...
	local Dcr_Unit_Array = Dcr_GetUnitArray();
	-- the order is player, party1-4, raid, pet, partypet1-4, raidpet1-40
	-- the raid is current party + 1 to 8... then 1 to current party - 1

	-- mind control first
	if( not cleaned) then
		Dcr_debug(" looking for mind controll");
		if (DCR_CAN_CURE_ENEMY_MAGIC) then
			for _, unit in Dcr_Unit_Array do
				-- all of the units...
				if (not Dcr_Blacklist_Array[unit]) then
					-- if the unit is not black listed
					if (UnitIsVisible(unit)) then
						-- if the unit is even close by
						if (UnitIsCharmed(unit)) then
							-- if the unit is mind controlled
							if (Dcr_CureUnit(unit)) then
								cleaned = true;
								break;
							end
						end
					end
				end
			end
		end
	end

	-- normal cleaning
	if( not cleaned) then
		Dcr_debug(" normal loop");
		for _, unit in Dcr_Unit_Array do
			-- all of the units...
			if (not Dcr_Blacklist_Array[unit]) then
				-- if the unit is not black listed
				if (UnitIsVisible(unit)) then
					-- if the unit is even close by
					if (not UnitIsCharmed(unit)) then
						-- we can't cure mind controlled people
						if (not Dcr_CheckUnitStealth(unit)) then
							-- we are either not ignoring the stealthed people,
							-- or it's not stealthed
							if (Dcr_CureUnit(unit)) then
								cleaned = true;
								break;
							end
						end
					end
				end
			end
		end
	end

	if ( not cleaned) then
		Dcr_debug(" double check the black list");
		for unit in Dcr_Blacklist_Array do
			-- now... all of the black listed units
			if (UnitExists(unit)) then
				-- if the unit still exists
				if (UnitIsVisible(unit)) then
					-- if the unit is even close by
					if (not Dcr_CheckUnitStealth(unit)) then
						-- we are either not ignoring the stealthed people,
						-- or it's not stealthed
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
	elseif (targetName) then
		-- we had a freindly targeted... switch back if not still targeted
		if ( targetName ~= UnitName("target") ) then
			TargetByName(targetName);
		end
	else
		-- we had nobody targeted originally
		if (UnitExists("target")) then
			-- we checked for range
			ClearTarget();
		end
	end

	if (not cleaned) then
		Dcr_println( DCR_NOT_CLEANED);
	end

	return cleaned;
end



-------------------------------------------------------------------------------
-- these are the spells used to clean a "unit" given
-------------------------------------------------------------------------------
function Dcr_CureUnit(Unit)
	Dcr_debug( "Scanning for cure - "..Unit);

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
		   		Dcr_debug( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
				return false;
			end

			if (UnitAffectingCombat("player")) then
				if (DCR_SKIP_LIST[debuff_name]) then
					-- these are just ones you don't care about
					Dcr_debug( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
					break;
				end
				if (DCR_SKIP_BY_CLASS_LIST[UClass]) then
					if (DCR_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
						-- these are just ones you don't care about by class
						Dcr_debug( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
						break;
					end
				end
			end

			if (debuff_type) then
				if (debuff_type == DCR_MAGIC) then
					Dcr_debug( "it's magic");
					Magic_Count = Magic_Count + 1;
				elseif (debuff_type == DCR_DISEASE) then
					Dcr_debug( "it's disease");
					Disease_Count = Disease_Count + 1;
				elseif (debuff_type == DCR_POISON) then
					Dcr_debug( "it's poison");
					Poison_Count = Poison_Count + 1;
				elseif (debuff_type == DCR_CURSE) then
					Dcr_debug( "it's curse");
					Curse_Count = Curse_Count + 1
				else
					Dcr_debug( "it's unknown - "..debuff_type);
				end
			else
				Dcr_debug( "it's untyped");
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
	Dcr_debug( "magic count "..Magic_Count);
	if (DCR_CAN_CURE_MAGIC) then
		Dcr_debug( "Can cure magic");
	end
	if (DCR_CAN_CURE_ENEMY_MAGIC) then
		Dcr_debug( "Can cure enemy magic");
	end
	
	if ( (not (DCR_CAN_CURE_MAGIC or DCR_CAN_CURE_ENEMY_MAGIC)) or (Magic_Count == 0) ) then
		-- here is no magical effects... or
		-- we can't cure magic don't bother going forward
		Dcr_debug( "no magic");
		return false;
	end
	Dcr_debug( "curing magic");

	if (UnitIsCharmed(Unit) and DCR_CAN_CURE_ENEMY_MAGIC) then
		-- unit is charmed... and has magic debuffs on them
		-- there is a good chance that it is the mind controll
		if (DCR_SPELL_ENEMY_MAGIC_2 ~= 0 ) and (Dcr_vars.AlwaysUseBestSpell or (Magic_Count > 1)) then
			return Dcr_Cast_CureSpell( DCR_SPELL_ENEMY_MAGIC_2, Unit, DCR_CHARMED, true);
		else
			return Dcr_Cast_CureSpell( DCR_SPELL_ENEMY_MAGIC_1, Unit, DCR_CHARMED, true);
		end
	elseif (DCR_CAN_CURE_MAGIC) then
		if (DCR_SPELL_MAGIC_2 ~= 0 ) and (Dcr_vars.AlwaysUseBestSpell or (Magic_Count > 1)) then
			return Dcr_Cast_CureSpell( DCR_SPELL_MAGIC_2, Unit, DCR_MAGIC, DCR_CAN_CURE_ENEMY_MAGIC);
		else
			return Dcr_Cast_CureSpell( DCR_SPELL_MAGIC_1, Unit, DCR_MAGIC, DCR_CAN_CURE_ENEMY_MAGIC);
		end
	end
	return false;
end

function Dcr_Cure_Curse( Curse_Count, Unit)
	if ( (not DCR_CAN_CURE_CURSE) or (Curse_Count == 0)) then
		-- no curses or no curse curing spells
		Dcr_debug( "no curse");
		return false;
	end
	Dcr_debug( "curing curse");

	if (UnitIsCharmed(Unit)) then
		-- we can not cure a mind contorolled player
		return;
	end

	if (DCR_SPELL_CURSE ~= 0) then
		return Dcr_Cast_CureSpell(DCR_SPELL_CURSE, Unit, DCR_CURSE, false);
	end
	return false;
end

function Dcr_Cure_Poison(Poison_Count, Unit)
	if ( (not DCR_CAN_CURE_POISON) or (Poison_Count == 0)) then
		-- here is no magical effects... or
		-- we can't cure magic don't bother going forward
		Dcr_debug( "no poison");
		return false;
	end
	Dcr_debug( "curing poison");

	if (UnitIsCharmed(Unit)) then
		-- we can not cure a mind contorolled player
		return;
	end

	if (Dcr_CheckUnitForBuff(Unit, DCR_SPELL_ABOLISH_POISON)) then
		return false;
	end

	if (DCR_SPELL_POISON_2 ~= 0 ) and (Dcr_vars.AlwaysUseBestSpell or (Poison_Count > 1)) then
		return Dcr_Cast_CureSpell( DCR_SPELL_POISON_2, Unit, DCR_POISON, false);
	else
		return Dcr_Cast_CureSpell( DCR_SPELL_POISON_1, Unit, DCR_POISON, false);
	end
end

function Dcr_Cure_Disease(Disease_Count, Unit)
	if ( (not DCR_CAN_CURE_DISEASE) or (Disease_Count == 0)	) then
		-- here is no magical effects... or
		-- we can't cure magic don't bother going forward
		Dcr_debug( "no disease");
		return false;
	end
	Dcr_debug( "curing disease");

	if (UnitIsCharmed(Unit)) then
		-- we can not cure a mind contorolled player
		return;
	end

	if (Dcr_CheckUnitForBuff(Unit, DCR_SPELL_ABOLISH_DISEASE)) then
		return false;
	end

	if (DCR_SPELL_DISEASE_2 ~= 0 ) and (Dcr_vars.AlwaysUseBestSpell or (Disease_Count > 1)) then
		return Dcr_Cast_CureSpell( DCR_SPELL_DISEASE_2, Unit, DCR_DISEASE, false);
	else
		return Dcr_Cast_CureSpell( DCR_SPELL_DISEASE_1, Unit, DCR_DISEASE, false);
	end
end

function Dcr_Cast_CureSpell( spellID, Unit, AfflictionType, ClearCurrentTarget)
	local name = UnitName(Unit);
	-- check to see if we are in range
	if (not Dcr_UnitInRange(Unit)) then
		Dcr_errln( string.gsub( string.gsub(DCR_OUT_OF_RANGE, "$t", name), "$a", AfflictionType));
		return false;
	end
	local spellName = GetSpellName(spellID, SpellBookFrame.bookType);
	Dcr_debug( "casting - "..spellName);

	-- clear the target if it will interfear
	if (ClearCurrentTarget) then
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
	CastSpell(spellID, SpellBookFrame.bookType);
	SpellTargetUnit(Unit);

	return true;
end


function Dcr_SpellCastFailed()
	if (Dcr_Casting_Spell_On) then
		Dcr_Blacklist_Array[Dcr_Casting_Spell_On] = Dcr_vars.CureBlacklist;
	end
end

function Dcr_SpellWasCast()
	Dcr_Casting_Spell_On = nil;
end

function Dcr_CheckUnitForBuff(Unit, BuffName)
	if (Dcr_vars.Check_For_Abolish) then
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

function Dcr_CheckUnitStealth(Unit)
	if (Dcr_vars.Ingore_Stealthed) then
		for BuffName in DCR_INVISIBLE_LIST do
			if Dcr_CheckUnitForBuff(Unit, BuffName) then
				return true;
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
	-- EDIT: added 28 yard detection
	if (not UnitIsVisible(Unit)) or ( not CheckInteractDistance(Unit, 4) ) then
		return false;
	else
		return true;
	end
end

function Dcr_UnitInRange_Old(Unit)

	local Dcr_Range_Slot = Dcr_FindCureingActionSlot(Dcr_Range_Icons);

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

function Dcr_FindCureingActionSlot( iconArray)
	local i = 0;
	for i = DCR_START_SLOT, DCR_END_SLOT do
		if (HasAction(i)) then
			icon = GetActionTexture(i);
			if (iconArray[icon]) then
				if (GetActionText(i) == nil) then
					local spellName = iconArray[icon];
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

-------------------------------------------------------------------------------
-- the UI code
-------------------------------------------------------------------------------

function Dcr_PriorityListEntryTemplate_OnClick()
	local id = this:GetID();
	if (id) then
		if (this.Priority) then
			Dcr_RemoveIDFromPriorityList(id);
		else
			Dcr_RemoveIDFromSkipList(id);
		end
	end
end

function Dcr_PriorityListEntryTemplate_OnUpdate()
	local baseName = this:GetName();
	local NameText = getglobal(baseName.."Name");

	local id = this:GetID();
	if (id) then
		local name
		if (this.Priority) then
			name = Dcr_vars.PriorityList[id];
		else
			name = Dcr_vars.SkipList[id];
		end
		if (name) then
			NameText:SetText(id.." - "..name);
		else
			NameText:SetText("Error - ID Invalid!");
		end
	else
		NameText:SetText("Error - No ID!");
	end
end

function Dcr_PriorityListFrame_Update()
	local baseName = this:GetName();
	local up = getglobal(baseName.."Up");
	local down = getglobal(baseName.."Down");


	local size = table.getn(Dcr_vars.PriorityList);

	if (size < 11 ) then
		this.Offset = 0;
		up:Hide();
		down:Hide();
	else
		if (this.Offset <= 0) then
			this.Offset = 0;
			up:Hide();
			down:Show();
		elseif (this.Offset >= (size - 10)) then
			this.Offset = (size - 10);
			up:Show();
			down:Hide();
		else
			up:Show();
			down:Show();
		end
	end

	local i;
	for i = 1, 10 do
		local id = ""..i;
		if (i < 10) then
			id = "0"..i;
		end
		local btn = getglobal(baseName.."Index"..id);

		btn:SetID( i + this.Offset);

		if (i <= size) then
			btn:Show();
		else
			btn:Hide();
		end
	end

end

function Dcr_SkipListFrame_Update()
	local baseName = this:GetName();
	local up = getglobal(baseName.."Up");
	local down = getglobal(baseName.."Down");


	local size = table.getn(Dcr_vars.SkipList);

	if (size < 11 ) then
		this.Offset = 0;
		up:Hide();
		down:Hide();
	else
		if (this.Offset <= 0) then
			this.Offset = 0;
			up:Hide();
			down:Show();
		elseif (this.Offset >= (size - 10)) then
			this.Offset = (size - 10);
			up:Show();
			down:Hide();
		else
			up:Show();
			down:Show();
		end
	end

	local i;
	for i = 1, 10 do
		local id = ""..i;
		if (i < 10) then
			id = "0"..i;
		end
		local btn = getglobal(baseName.."Index"..id);

		btn:SetID( i + this.Offset);

		if (i <= size) then
			btn:Show();
		else
			btn:Hide();
		end
	end

end

function Dcr_DisplayTooltip( Message)
	DcrDisplay_Tooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	DcrDisplay_Tooltip:ClearLines();
	DcrDisplay_Tooltip:SetText(Message);
	DcrDisplay_Tooltip:Show();
end

function Dcr_PopulateButtonPress()
	local addFunction = this:GetParent().addFunction;

	if (this.ClassType) then
		-- for the class type stuff... we do party

		local _, pclass = UnitClass("player");
		if (pclass == this.ClassType) then
			addFunction("player");
		end

		_, pclass = UnitClass("party1");
		if (pclass == this.ClassType) then
			addFunction("party1");
		end
		_, pclass = UnitClass("party2");
		if (pclass == this.ClassType) then
			addFunction("party2");
		end
		_, pclass = UnitClass("party3");
		if (pclass == this.ClassType) then
			addFunction("party3");
		end
		_, pclass = UnitClass("party4");
		if (pclass == this.ClassType) then
			addFunction("party4");
		end
	end
	
	local max = GetNumRaidMembers();
	local i;
	if (max > 0) then
		for i = 1, max do
			local _, _, pgroup, _, _, pclass = GetRaidRosterInfo(i);

			if (this.ClassType) then
				if (pclass == this.ClassType) then
					addFunction("raid"..i);
				end
			end
			if (this.GroupNumber) then
				if (pgroup == this.GroupNumber) then
					addFunction("raid"..i);
				end
			end
		end
	end

end

function Dcr_DebuffTemplate_OnEnter()
	DcrDisplay_Tooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	DcrDisplay_Tooltip:ClearLines();
	DcrDisplay_Tooltip:SetUnitDebuff(this.unit,this.debuff);
	DcrDisplay_Tooltip:Show();
end

function Dcr_LiveListItem_OnUpdate()
	local texture = UnitDebuff(this.unit,this.debuff);
	if (texture) then
		local baseFrame = this:GetName();
		getglobal(baseFrame.."DebuffIcon"):SetTexture(texture);

		getglobal(baseFrame.."Name"):SetText(UnitName(this.unit));

		Dcr_Tooltip:SetUnitDebuff(this.unit,this.debuff);
		getglobal(baseFrame.."Affliction"):SetText(Dcr_TooltipTextLeft1:GetText());
	end
end

local timeLeft = 0;
function Dcr_AfflictedListFrame_Update(arg1)
	timeLeft = timeLeft - arg1;
	if Dcr_vars.Amount_Of_Afflicted < 1 then
		Dcr_vars.Amount_Of_Afflicted = 1;
	elseif Dcr_vars.Amount_Of_Afflicted > DCR_MAX_LIVE_SLOTS then
		Dcr_vars.Amount_Of_Afflicted = DCR_MAX_LIVE_SLOTS;
	end
	if (timeLeft <= 0) then
		timeLeft = Dcr_vars.ScanTime;
		local index = 1;
		local Dcr_Unit_Array = Dcr_GetUnitArray();

		if (DCR_CAN_CURE_ENEMY_MAGIC) then
			for _, unit in Dcr_Unit_Array do
				if (index > Dcr_vars.Amount_Of_Afflicted) then
					break;
				end
				if (UnitIsVisible(unit)) then
					-- if the unit is even close by
					if (UnitIsCharmed(unit)) then
						-- if the unit is mind controlled
						if (Dcr_ScanUnit(unit, index)) then
							index = index + 1;
						end
					end
				end
			end
		end
	
		Dcr_debug(" normal loop");
		for _, unit in Dcr_Unit_Array do
			if (index > Dcr_vars.Amount_Of_Afflicted) then
				break;
			end
			if (UnitIsVisible(unit)) then
				if (not UnitIsCharmed(unit)) then
					-- if the unit is even close by
					if (Dcr_ScanUnit(unit, index)) then
						index = index + 1;
					end
				end
			end
		end
		
		for i = index, DCR_MAX_LIVE_SLOTS do
			local item = getglobal("DecursiveAfflictedListFrameListItem"..i);
			item.unit = "player";
			item.debuff = 0;
			item:Hide();
		end

		-- for testing only		
		-- Dcr_UpdateLiveDisplay( 1, "player", 1)
		
	end
end

function Dcr_ScanUnit( Unit, Index)
	for i = 1, DCR_MAXDEBUFFS do
		local debuff_texture = UnitDebuff(Unit, i);

		if debuff_texture then

			Dcr_TooltipTextRight1:SetText(nil);
			Dcr_Tooltip:SetUnitDebuff(Unit, i);
			local debuff_type = Dcr_TooltipTextRight1:GetText();
			local debuff_name = Dcr_TooltipTextLeft1:GetText();


			if (DCR_IGNORELIST[debuff_name]) then
				-- these are the BAD ones... the ones that make the target immune... abort the user
		   		Dcr_debug( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
				return false;
			end

			if (UnitAffectingCombat("player")) then
				if (DCR_SKIP_LIST[debuff_name]) then
					-- these are just ones you don't care about
					Dcr_debug( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
					break;
				end
				if (DCR_SKIP_BY_CLASS_LIST[UClass]) then
					if (DCR_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
						-- these are just ones you don't care about by class
						Dcr_debug( string.gsub( string.gsub(DCR_IGNORE_STRING, "$t", UnitName(Unit)), "$a", debuff_name));
						break;
					end
				end
			end

			if (debuff_type) then
				if (debuff_type == DCR_MAGIC) then
					if (UnitIsCharmed(Unit)) then
						if (DCR_CAN_CURE_ENEMY_MAGIC) then
							Dcr_UpdateLiveDisplay(Index, Unit, i);
							return true;
						end
					else
						if (DCR_CAN_CURE_MAGIC) then
							Dcr_UpdateLiveDisplay(Index, Unit, i);
							return true;
						end
					end
				elseif (debuff_type == DCR_DISEASE) then
					if (DCR_CAN_CURE_DISEASE) then
						Dcr_UpdateLiveDisplay(Index, Unit, i);
						return true;
					end
				elseif (debuff_type == DCR_POISON) then
					if (DCR_CAN_CURE_POISON) then
						Dcr_UpdateLiveDisplay(Index, Unit, i);
						return true;
					end
				elseif (debuff_type == DCR_CURSE) then
					if (DCR_CAN_CURE_CURSE) then
						Dcr_UpdateLiveDisplay(Index, Unit, i);
						return true;
					end
				end
			end

		end
	end
end

function Dcr_UpdateLiveDisplay( Index, Unit, DebuffIndex)
	local item = getglobal("DecursiveAfflictedListFrameListItem"..Index);
	item.unit = Unit;
	item.debuff = DebuffIndex;
	item:Show();

	item = getglobal("DecursiveAfflictedListFrameListItem"..Index.."Debuff");
	item.unit = Unit;
	item.debuff = DebuffIndex;

	item = getglobal("DecursiveAfflictedListFrameListItem"..Index.."ClickMe");
	item.unit = Unit;
	item.debuff = DebuffIndex;
end

function Dcr_AmountOfAfflictedSlider_OnShow()
	getglobal(this:GetName().."High"):SetText("15");
	getglobal(this:GetName().."Low"):SetText("5");

	getglobal(this:GetName() .. "Text"):SetText(DCR_AMOUNT_AFFLIC .. Dcr_vars.Amount_Of_Afflicted);

	this:SetMinMaxValues(1, 15);
	this:SetValueStep(1);
	this:SetValue(Dcr_vars.Amount_Of_Afflicted);
end

function Dcr_AmountOfAfflictedSlider_OnValueChanged()
	Dcr_vars.Amount_Of_Afflicted = this:GetValue();
	getglobal(this:GetName() .. "Text"):SetText(DCR_AMOUNT_AFFLIC .. Dcr_vars.Amount_Of_Afflicted);
end

function Dcr_CureBlacklistSlider_OnShow()
	getglobal(this:GetName().."High"):SetText("20");
	getglobal(this:GetName().."Low"):SetText("1");

	getglobal(this:GetName() .. "Text"):SetText(DCR_BLACK_LENGTH .. Dcr_vars.CureBlacklist);

	this:SetMinMaxValues(1, 20);
	this:SetValueStep(0.1);
	this:SetValue(Dcr_vars.CureBlacklist);
end

function Dcr_CureBlacklistSlider_OnValueChanged()
	Dcr_vars.CureBlacklist = this:GetValue() * 10;
	if (Dcr_vars.CureBlacklist < 0) then
		Dcr_vars.CureBlacklist = ceil(Dcr_vars.CureBlacklist - 0.5)
	else
		Dcr_vars.CureBlacklist = floor(Dcr_vars.CureBlacklist + 0.5)
	end
	Dcr_vars.CureBlacklist = Dcr_vars.CureBlacklist / 10;
	getglobal(this:GetName() .. "Text"):SetText(DCR_BLACK_LENGTH .. Dcr_vars.CureBlacklist);
end

function Dcr_ScanTimeSlider_OnShow()
	getglobal(this:GetName().."High"):SetText("1");
	getglobal(this:GetName().."Low"):SetText("0.1");

	getglobal(this:GetName() .. "Text"):SetText(DCR_SCAN_LENGTH .. Dcr_vars.ScanTime);

	this:SetMinMaxValues(0.1, 1);
	this:SetValueStep(0.1);
	this:SetValue(Dcr_vars.ScanTime);
end

function Dcr_ScanTimeSlider_OnValueChanged()
	Dcr_vars.ScanTime = this:GetValue() * 10;
	if (Dcr_vars.ScanTime < 0) then
		Dcr_vars.ScanTime = ceil(Dcr_vars.ScanTime - 0.5)
	else
		Dcr_vars.ScanTime = floor(Dcr_vars.ScanTime + 0.5)
	end
	Dcr_vars.ScanTime = Dcr_vars.ScanTime / 10;
	getglobal(this:GetName() .. "Text"):SetText(DCR_SCAN_LENGTH .. Dcr_vars.ScanTime);
end
