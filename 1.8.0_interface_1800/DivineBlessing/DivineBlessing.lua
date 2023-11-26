--[[
--		Divine Blessing 2.0
--			Provides an interface and keybindings to support sequential
--			buffing of parties / raids.
--
--		By: Steve DeLong
--
--		Divine Blessing provides a mechanism for assigning Paladin Blessings
--		or other spells to sets to easily buff parties or raid groups without
--		the hassle of tracking your target down and picking them out of a
--		pile of players.  Supports pets in both party and raid situations.
--
--		$Id: DivineBlessing.lua 2536 2005-09-28 18:20:49Z gryphon $
--		$Rev: 2536 $
--		$LastChangedBy: gryphon $
--		$Date: 2005-09-28 13:20:49 -0500 (Wed, 28 Sep 2005) $
--]]

-- Register the Divine Blessing Frame as a standard pane window
UIPanelWindows["DivineBlessing_ConfigFrame"] = { area = "left", pushable = 999, whileDead = 1 };

-- Constants
local DIVINEBLESSING_FONT_COLOR = { r = .95, g = .95, b = .95 };

local DIVINEBLESSING_NORMALSETCOUNT = 6;
local DIVINEBLESSING_CLASSSETCOUNT = 1;
local DIVINEBLESSING_RAIDSETCOUNT = 1;
local DIVINEBLESSING_SETCOUNT = DIVINEBLESSING_NORMALSETCOUNT + DIVINEBLESSING_CLASSSETCOUNT + DIVINEBLESSING_RAIDSETCOUNT;

local DIVINEBLESSING_PARTYSETSIZE = 5;
local DIVINEBLESSING_CLASSSETSIZE = 8;
local DIVINEBLESSING_RAIDSETSIZE = 40;
local DIVINEBLESSING_NUMPETSLOTS = 5;

-- These are the raw class names.  Do not localize this table.
local DIVINEBLESSING_CLASSMAP = {
		["DRUID"]		= 1,
		["HUNTER"]		= 2,
		["MAGE"]		= 3,
		["PALADIN"]		= 4,
		["SHAMAN"]		= 4,
		["PRIEST"]		= 5,
		["ROGUE"]		= 6,
		["WARLOCK"]		= 7,
		["WARRIOR"] 	= 8,
		["IMP"]			= 9,
		["VOIDWALKER"]	= 10,
		["SUCCUBUS"]	= 11,
		["FELHUNTER"]	= 12,
		["BEAST"]		= 13,
	};
	
local SETTYPE_PARTY	= "Party";
local SETTYPE_CLASS	= "Class";
local SETTYPE_RAID	= "Raid";

-- Local variables
local DivineBlessing_Config_Tab1_ScrollIndex = 1;

local DivineBlessing_CarriedID = -1;
local DivineBlessing_DropSpellTimer = nil;

local DivineBlessing_ActiveSet = nil;
local DivineBlessing_ActiveSpell = nil;

local DivineBlessing_Player = nil;

local DivineBlessing_Registered = false;
local DivineBlessing_EventDispatch = {};
local DivineBlessing_Saved_SpellButton_OnClick = nil;

----------------------------------------------------------------------
-- Library Functions
--	Divine Blessing has no Library functions -- all functionality
--	should be accessed either from the configuration frame, the
--	slash commands, or the keybindings.
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Normal Functions
----------------------------------------------------------------------

--[[
--	Print ( string message, int bannerOverride )
--		Prints a message
--
--	Args:
--		message - the message to display
--		bannerOverride - if present, override the player's bannerAnnounce setting.
--			1 = show as banner, 0 = show as normal chat message
--
--	Returns:
--		NO RETURN
--
--]]

local function Print(message, bannerOverride)
	local banner;
	if ( bannerOverride ) then
		banner = bannerOverride
	else
		banner = DivineBlessing_Config[DivineBlessing_Player].bannerAnnounce;	
	end
	
	if ( banner == 1 ) then
		if (( Sea ) and ( Sea.IO ) and ( Sea.IO.banner )) then
			Sea.IO.banner(message);
		else
			UIErrorsFrame:AddMessage(message, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1.0, UIERRORS_HOLD_TIME);
		end
	else
		if (( Sea ) and ( Sea.IO ) and ( Sea.IO.print )) then
			Sea.IO.printc(DIVINEBLESSING_FONT_COLOR, message);
		else
			ChatFrame1:AddMessage(message, DIVINEBLESSING_FONT_COLOR.r, DIVINEBLESSING_FONT_COLOR.g, DIVINEBLESSING_FONT_COLOR.b);
		end
	end
end

--[[
--	Debug ( string message )
--		Prints a message to the default chat window, only if DivineBlessing_Debug is set
--
--	Args:
--		message - the message to display
--
--	Returns:
--		NO RETURN
--
--]]

local function Debug(message)
	if ( DivineBlessing_Debug == true ) then Print(message, 0); end
end

--[[
--	PrintHelp ( table messageTable )
--		Prints a multi-line message
--
--	Args:
--		messageTable - the messages to display.  Table must contain strings.
--
--	Returns:
--		NO RETURN
--
--]]

local function PrintHelp(messageTable)
	if ( messageTable ) then
		for k, message in messageTable do
			Print(message, 0);
		end
	end
end

--[[
--	DivineBlessing_GetSetNumber ( string setName )
--		Returns the set number that best matches the provided setName
--
--	Args:
--		setName -- a name of the set to parse
--
--	Returns:
--		setNumber -- number - the parsed set number, or nil if it could not be parsed
--
--]]

local function DivineBlessing_GetSetNumber(setName)
	setName = string.upper(setName);
	local setNumber = nil;
	if (string.find(setName, "RAID") ~= nil or string.find(setName, "8") ~= nil) then
		setNumber = 8;
	elseif (string.find(setName, "CLASS") ~= nil or string.find(setName, "7") ~= nil) then 
		setNumber = 7;
	elseif (string.find(setName, "A") ~= nil or string.find(setName, "1") ~= nil) then 
		setNumber = 1;
	elseif (string.find(setName, "B") ~= nil or string.find(setName, "2") ~= nil) then 
		setNumber = 2;
	elseif (string.find(setName, "C") ~= nil or string.find(setName, "3") ~= nil) then 
		setNumber = 3;
	elseif (string.find(setName, "D") ~= nil or string.find(setName, "4") ~= nil) then 
		setNumber = 4;
	elseif (string.find(setName, "E") ~= nil or string.find(setName, "5") ~= nil) then 
		setNumber = 5;
	elseif (string.find(setName, "F") ~= nil or string.find(setName, "6") ~= nil) then 
		setNumber = 6;
	end
	return setNumber;
end

--[[
--	DivineBlessing_GetSetName ( number setNumber )
--		Returns the name of the set specified
--
--	Args:
--		setNumber -- the number of the set to return the name of
--
--	Returns:
--		setName -- string - name of the specified set, or nil if it did not correspond to one
--
--]]

local function DivineBlessing_GetSetName(setNumber)
	local name;
	if ((setNumber < 1) or (setNumber > DIVINEBLESSING_SETCOUNT)) then
		name = string.format(DIVINEBLESSING_UNKNOWN_SET, setNumber);
	elseif (setNumber <= DIVINEBLESSING_NORMALSETCOUNT) then
		name = DIVINEBLESSING_PARTY_SET;
		if (DIVINEBLESSING_NORMALSETCOUNT > 1) then name = name.." "..setNumber end
	elseif (setNumber <= DIVINEBLESSING_NORMALSETCOUNT + DIVINEBLESSING_CLASSSETCOUNT) then
		name = DIVINEBLESSING_CLASS_SET;
		if (DIVINEBLESSING_CLASSSETCOUNT > 1) then
			name = name.." "..(setNumber - DIVINEBLESSING_NORMALSETCOUNT);
		end
	else
		name = DIVINEBLESSING_RAID_SET;
		if (DIVINEBLESSING_RAIDSETCOUNT > 1) then
			name = name.." "..(setNumber - (DIVINEBLESSING_NORMALSETCOUNT + DIVINEBLESSING_CLASSSETCOUNT));
		end
	end
	return name;
end

--[[
--	DivineBlessing_SlashCmd ( string message )
--		Parses /divineblessing slash commands
--
--	Args:
--		message -- the slash command message
--
--	Returns:
--		NO RETURN
--
--]]

function DivineBlessing_SlashCmd(message)
	local i, j, command, param = string.find(message, DIVINEBLESSING_REGEX_CHAT_COMMAND);
	if ( not i ) then command = message end
	command = string.lower(command);

	if (( not command ) or (string.len(command) == 0 )) then
		-- Toggle the window
		DivineBlessing_ConfigEdit();
	elseif ( command == DIVINEBLESSING_CMD_RESET ) then
		if ( not param ) then
			PrintHelp(DIVINEBLESSING_HELP_DEFAULT);
		else
			local setNumber = DivineBlessing_GetSetNumber(param);
			if ( setNumber ) then DivineBlessing_ResetSetIndex(setNumber); end
		end
	elseif ( command == DIVINEBLESSING_CMD_RESETALL ) then
		for set = 1, DIVINEBLESSING_SETCOUNT, 1 do
			DivineBlessing_ResetSetIndex(set);
		end
	else
		-- Display usage help
		PrintHelp(DIVINEBLESSING_HELP_DEFAULT);
	end
end

--[[
--	DivineBlessing_BlessCmd ( string message )
--		Parses /bless slash commands
--
--	Args:
--		message -- the slash command message
--
--	Returns:
--		NO RETURN
--
--]]

function DivineBlessing_BlessCmd(message)
	if (message == "") then
		PrintHelp(DIVINEBLESSING_HELP_DEFAULT);
	else
		local setNumber = DivineBlessing_GetSetNumber(message);
		if ( setNumber ) then DivineBlessing_Bless(setNumber); end
	end
end

--[[
--	DivineBlessing_Bless ( number setNumber )
--		Casts the next spell in the specified set on the appropriate target
--
--	Args:
--		setNumber -- the set to cast
--
--	Returns:
--		NO RETURN
--
--]]

function DivineBlessing_Bless(setNumber)
	if (setNumber == nil) then return end
	
	-- Make sure the set is a number
	local set = setNumber + 0;

	-- Make sure it's in range
	if (set < 1 or set > DIVINEBLESSING_SETCOUNT) then return end
	
	-- Get the target and spell
	local index = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index;
	local pet = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet;
	local target, spell;
	if (index) then 
		target, spell = DivineBlessing_GetSpell(set, index, pet);
	end
	
	local id;
	if ((not target) or (not spell)) then
		id = -1;
	else
		id = spell.id;
	end
	
	-- We don't have a valid current spell, so look for the next one to cast instead
	if (id < 0) then
		index, pet = DivineBlessing_NextAvailableSpell(set, DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].wait);
		if (( not index ) or ( index < 0 )) then return; end
		
		target, spell = DivineBlessing_GetSpell(set, index, pet);
		if ((not target) or (not spell)) then return; end

		id = spell.id;
		if (id < 0) then
			return;
		end
	end

	local start, duration, enable = GetSpellCooldown(id, BOOKTYPE_SPELL);	
	if (duration == 0) then 
		-- Cast the spell on the appropriate target -- default is to clear the current one if friendly
		if (not DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].override) then
			if (UnitCanCooperate("target", "player")) then
				ClearTarget();
			end
		end

		DivineBlessing_ActiveSet = set;
		DivineBlessing_ActiveSpell = spell;
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index = index;
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet = pet;
		
		local spellName = DivineBlessing_GetSpellName(spell);
		local targetName = DivineBlessing_GetTargetName(set, index, pet);
		Debug("[DivineBlessing] Casting "..spellName.." on "..target.." ("..targetName..")");
		CastSpell(id, BOOKTYPE_SPELL);
		if (SpellIsTargeting(id)) then SpellTargetUnit(target) end
	else
		DivineBlessing_ActiveSet = nil;
		DivineBlessing_ActiveSpell = nil;
	end
end

--[[
--	DivineBlessing_GetTarget ( number set, number targetIndex, number pet )
--		Returns the target identifier corresponding to the set, target index, and pet
--
--	Args:
--		set -- the set to look at
--		targetIndex -- the index of the target in the set
--		pet -- if 1, return the target's pet's id.  Otherwise, return the target's id.
--
--	Returns:
--		target -- string - the specified target id, or nil if there is no target at that index
--
--]]

function DivineBlessing_GetTarget(set, targetIndex, pet)
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return nil end

	local target;

	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].override) then
		if (UnitCanCooperate("target", "player")) then
			target = "target";
		end
	end
	if (target == nil) then
		if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_RAID) then
			if (targetIndex > GetNumRaidMembers()) then return nil end
			target = "raid"
			if (pet) then target = target.."pet" end
			target = target..targetIndex;
		elseif ((DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_PARTY) or 
				(DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_CLASS)) then
			if (targetIndex == 1) then
				if (pet) then
					target = "pet";
				else
					target = "player";
				end
			else
				if (not GetPartyMember(targetIndex - 1)) then return nil end
				target = "party";
				if (pet) then target = target.."pet" end
				target = target..(targetIndex - 1);
			end
		else
			-- Unknown set type
			if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type) then
				Debug("[DivineBlessing_GetTarget] Unknown set type.  Set: "..set..", type: "..DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type);
			else
				Debug("[DivineBlessing_GetTarget] Set "..set.."'s type is nil");
			end
			return nil;
		end
	end
--	local targetName = UnitName(target);
--	if (not targetName) then return nil; end
	if (not UnitExists(target)) then return nil; end

	return target;
end

--[[
--	DivineBlessing_GetTargetName ( number set, number targetIndex, number pet )
--		Returns the name of the unit corresponding to the set, target index, and pet
--
--	Args:
--		set -- the set to look at
--		targetIndex -- the index of the target in the set
--		pet -- if 1, return the target's pet's id.  Otherwise, return the target's id.
--
--	Returns:
--		targetName -- string - the specified unit's name, or "UNKNOWN TARGET" if there is no target at that index
--
--]]

function DivineBlessing_GetTargetName(set, index, pet)
	local target = DivineBlessing_GetTarget(set, index, pet);
	if ( not target ) then return "UNKNOWN TARGET"; end
	
	local targetName = UnitName(target);
	if ( not targetName ) then return "UNKNOWN TARGET"; end
	
	if ( pet ) then
		local owner = DivineBlessing_GetTarget(set, index, nil);
		if ( owner ) then
			local ownerName = UnitName(owner);
			if ( ownerName ) then
				targetName = targetName.." ("..ownerName.."'s pet)";
			end
		end
	end
	
	return targetName;
end

--[[
--	DivineBlessing_GetSpellName ( table spell )
--		Assembles a "pretty" version of the spell name
--
--	Args:
--		spell -- a table containing spell information:
--					{
--						name -- spell name
--						rank -- spell rank (optional)
--					}
--
--	Returns:
--		spellName -- string - the spell's name, in "name (rank)" format, or "" if no valid spell was provided
--
--]]

function DivineBlessing_GetSpellName(spell)
	if (( not spell ) or ( not spell.name )) then return ""; end

	local spellName = spell.name;
	if (( spell.rank ) and ( string.len(spell.rank) > 0 )) then
		spellName = spellName.." ("..spell.rank..")";
	end
	
	return spellName;
end

--[[
--	DivineBlessing_GetPetType ( string target )
--		Tries to determine the pet type of the target unit
--
--	Args:
--		target -- a valid target id
--
--	Returns:
--		petType -- string - the type of pet, the unit's class if the unit
--							is not a standard pet, or nil if the specified
--							unit does not exist, or is not targetable.
--
--]]

function DivineBlessing_GetPetType(target)
	if ( not target ) then return nil end
	if ( not UnitCanCooperate("player", target) ) then return nil end
	if ( UnitIsCharmed(target) ) then return nil end
	
	local creatureType = UnitCreatureType(target)
	if ( creatureType == DIVINEBLESSING_CREATURE_BEAST ) then
		return "BEAST"
	elseif ( creatureType == DIVINEBLESSING_CREATURE_DEMON ) then
		local _, unitClass = UnitClass(target)
		
		if ( unitClass == "PALADIN" ) then
			local unitSex = UnitSex(target)
			if ( unitSex == 0 ) then
				return "VOIDWALKER"
			elseif ( unitSex == 1 ) then
				return "SUCCUBUS"
			elseif ( unitSex == 2 ) then
				return "FELHUNTER"
			else
				return nil
			end
		elseif ( unitClass == "MAGE" ) then
			return "IMP"
		else
			return unitClass;
		end
	end

	local _, unitClass = UnitClass(target)
	return unitClass
end

--[[
--	DivineBlessing_GetSetSize ( number set, number actual )
--		Returns the size of the specified set
--
--	Args:
--		set -- the set
--		actual -- if non-nil, returns the actual size, not the max size
--
--	Returns:
--		setSize -- number - the number of targets (not including pets) in the set,
--							or nil if the set does not exist
--]]

function DivineBlessing_GetSetSize(set, actual)
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return nil end
	local setType = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type;
	if (setType == SETTYPE_RAID) then
		if (actual) then
			return GetNumRaidMembers();
		else
			return DIVINEBLESSING_RAIDSETSIZE;
		end
	elseif (setType == SETTYPE_CLASS) then
		if (actual) then
			return GetNumPartyMembers() + 1;
		else
			return DIVINEBLESSING_CLASSSETSIZE;
		end
	else
		if (actual) then
			return GetNumPartyMembers() + 1;
		else
			return DIVINEBLESSING_PARTYSETSIZE;
		end
	end
end

--[[
--	DivineBlessing_GetSetNumSlots ( number set, number includePets )
--		Returns the size of the specified set
--
--	Args:
--		set -- the set
--		includePets -- if non-nil, includes the number of pet slots in the count
--
--	Returns:
--		setSize -- number - the number of spell slots in the set, 
--							or nil if the set does not exist
--]]

function DivineBlessing_GetSetNumSlots(set, includePets)
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return nil end
	local setType = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type;

	local setSize = 0;
	if ((setType == SETTYPE_CLASS) or (setType == SETTYPE_RAID)) then
		setSize = DIVINEBLESSING_CLASSSETSIZE;
	else
		setSize = DIVINEBLESSING_PARTYSETSIZE;
	end

	if (includePets) then
		setSize = setSize + DIVINEBLESSING_NUMPETSLOTS;
	end
	
	return setSize;
end

--[[
--	DivineBlessing_GetSpell ( number set, number index, number pet )
--		Returns the spell information for the specified set, target, and pet
--
--	Args:
--		set -- the set
--		index -- the index in that set of the target
--		pet -- if non-nil, the spell for the target's pet should be returned instead
--
--	Returns:
--		target -- the target identifier for the spell, or nil if there is no spell for the specified target
--		spell -- table containing information on the spell, or nil if there is no spell for the specified target:
--				{
--					id -- the spell's id
--					name -- the spell's name
--					rank -- the spell's rank
--				}
--]]

function DivineBlessing_GetSpell(set, index, pet)
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return nil, nil end
	if (index > DivineBlessing_GetSetSize(set, true)) then
		return nil, nil;
	end
	
	-- If we're a raid set, make sure we're supposed to be targeting the group the target
	-- is in.
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_RAID) then
		local _, _, subGroup = GetRaidRosterInfo(index);
		if (not DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].targetGroup[subGroup]) then
			return nil, nil;
		end
	end

	local target = DivineBlessing_GetTarget(set, index, pet);
	if (not target) then return nil, nil end
	
	local spellIndex;
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_PARTY) then
		if ( pet ) then
			spellIndex = index + DIVINEBLESSING_PARTYSETSIZE;
		else
			spellIndex = index;
		end
	else
		local targetClass = nil;
		if ( pet ) then
			targetClass = DivineBlessing_GetPetType(target);
		end
		
		if ( not targetClass ) then
			local localizedClass;
			localizedClass, targetClass = UnitClass(target);
		end
		if ( not targetClass ) then return nil, nil; end

		spellIndex = DIVINEBLESSING_CLASSMAP[targetClass];
		if (not spellIndex) then
			return nil, nil;
		end
	end
	
	if (UnitIsDead(target) or (not UnitIsConnected(target))) then
		-- If the target is dead or is offline (not connected), they're not valid,
		-- so return no spell (as there's no valid spell to cast on them)
		return nil, nil;
	end
	
	local spell = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][spellIndex];
	return target, spell;
end

--[[
--	DivineBlessing_NextAvailableSpell ( number set, number wait )
--		Returns the index of the next available spell in the specified set
--
--	Args:
--		set -- the set
--		wait -- 1 if cooldowns should be waited on, 0 if not
--
--	Returns:
--		index -- number - the index of the next available spell
--		pet -- number - 1 if the next available spell is targeted on a pet, nil if not
--]]

function DivineBlessing_NextAvailableSpell(set, wait)
	if ( not set ) then
		Debug("[DivineBlessing] Next Available Spell: index = nil, pet = 1 (set is nil)");
		return nil, 1;
	end
	if ( not DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] ) then
		Debug("[DivineBlessing] Next Available Spell: set = "..set..", index = nil, pet = 1 (no set found)");
		return nil, 1;
	end
--	if (wait == nil) then wait = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].wait end
	if (wait == nil) then wait = 0; end

	-- Find the current set index
	local index = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index; 
	local pet = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet;

	-- If it hasnt been started, start right before the first slot
	if ((not index) or (index < 1)) then
		index = 0;
		pet = 1;
	end

	-- Determine what the next spell should be	
	local setActualSize = DivineBlessing_GetSetSize(set, true);
	repeat
		-- Increase the index
		if ( pet ) then
			index = index + 1;
			pet = nil;
		else
			pet = 1;
		end

		-- If we've passed the last entry, reset to the beginning and exit		
		if (index > setActualSize) then
			index = 1;
			pet = nil;
			break;
		end

		-- Get the info on the appropriate spell for the current index
		target, spell = DivineBlessing_GetSpell(set, index, pet);
		id = -1;
		if (( target ) and ( spell )) then
			id = spell.id;
		end
		
		-- If we're supposed to wait on cooldowns, see if we're cooling down
		if (( wait == 1 ) and ( id > 0 )) then
			-- Check the duration
			local start, duration, enable = GetSpellCooldown(id, BOOKTYPE_SPELL);
			if ( duration > 0 ) then
				id = -1;
			end
		end

	until (id > 0);

	if ( pet ) then
		Debug("[DivineBlessing] Next Available Spell: set = "..set..", index = "..index..", pet = "..pet);
	else
		Debug("[DivineBlessing] Next Available Spell: set = "..set..", index = "..index..", pet = nil");
	end
	return index, pet;
end

--[[
--	DivineBlessing_Init ()
--		Perform basic initialization
--]]

function DivineBlessing_Init()
	if (DivineBlessing_Player == nil) then
		Print("[DivineBlessing_Init] No player was found.");
		return;
	end
	if (DivineBlessing_Config == nil) then 
		DivineBlessing_Config = {};
	end
	if (DivineBlessing_Config[DivineBlessing_Player] == nil) then
		DivineBlessing_Config[DivineBlessing_Player] = {};
		DivineBlessing_Config[DivineBlessing_Player].autoUpgradeSpells = 1;
		DivineBlessing_Config[DivineBlessing_Player].announceRaidProgress = 1;
		DivineBlessing_Config[DivineBlessing_Player].announceSetCompletion = 1;
		DivineBlessing_Config[DivineBlessing_Player].announceFailures = 1;
		DivineBlessing_Config[DivineBlessing_Player].bannerAnnounce = 1;
	end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap == nil) then
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap = {};
		 
		local startSet;
		local endSet;
		local set;
		
		startSet = 1;
		endSet = DIVINEBLESSING_NORMALSETCOUNT;
		for set = startSet, endSet, 1 do
			DivineBlessing_InitSet(set, SETTYPE_PARTY);
		end
		
		-- Now initialize the class sets
		startSet = endSet + 1;
		endSet = startSet + DIVINEBLESSING_CLASSSETCOUNT - 1;
		for set = startSet, endSet, 1 do
			DivineBlessing_InitSet(set, SETTYPE_CLASS);
		end
	
		-- Now initialize the raid sets
		startSet = endSet + 1;
		endSet = startSet + DIVINEBLESSING_RAIDSETCOUNT - 1;
		for set = startSet, endSet, 1 do
			DivineBlessing_InitSet(set, SETTYPE_RAID);
		end
	end
end

--[[
--	DivineBlessing_InitSet ( number set, number type )
--		Initializes the specified set to defaults
--
--	Args:
--		set -- the set
--		type -- the type to initialize the set to (party, class, or raid)
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_InitSet(set, type)
	DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] = {
		index = 1;
		pet = nil;
		wait = 1;
		type = type;
		
		targetGroup = nil;
	};
	if (type == SETTYPE_RAID) then
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].targetGroup = {
				[1] = 1,
				[2] = 1,
				[3] = 1,
				[4] = 1,
				[5] = 1,
				[6] = 1,
				[7] = 1,
				[8] = 1,
			};
	end

	local size = DivineBlessing_GetSetSize(set);

	-- All of our sets have 5 slots for pets (party has 1 per partymember,
	-- and class / raid have 5 pet types), so add 5 slots to store buffs in
	size = size + 5;
	for index = 1, size, 1 do
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index] = {
			id = -1;
			name = "";
			rank = "";
		};
	end
end

--[[
--	DivineBlessing_SetAll ( number set, number id )
--		Sets all spells in the specified set to the specified spell, or clears all
--		spells in the specified set if the spell is invalid or nil
--
--	Args:
--		set -- the set
--		id -- the spell id
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_SetAll(set, newid)
	local slots = DivineBlessing_GetSetNumSlots(set, true);

	-- Pick up and drop the spell into each button in the set	
	for index = 1, slots, 1 do
		if (DivineBlessing_Button_ValidPos(set, index)) then
			-- Drop the spell into the button	
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index] =
				{
					id = newid
				}
			DivineBlessing_UpdateSpell(DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index]);
		end
	end

	-- Update the class buttons
	slots = DivineBlessing_GetSetNumSlots(set);
	for index = 1, slots, 1 do
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set..index.."Button"));
	end
	
	-- Update the pet buttons
	DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."ImpButton"));
	DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."VoidwalkerButton"));
	DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."SuccubusButton"));
	DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."FelhunterButton"));
	DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."BeastButton"));
end

--[[
--	DivineBlessing_UpdateSetIndex ( boolean success )
--		Processes the end-spellcasting events (stop, interripted, failed),
--		updates the next set index, and displays messages as appropriate.
--
--	Args:
--		success -- whether the casting failed or succeeded
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_UpdateSetIndex(success)
	if (not DivineBlessing_ActiveSet) then return end

	local set = DivineBlessing_ActiveSet;
	local spell = DivineBlessing_ActiveSpell;
	DivineBlessing_ActiveSet = nil;
	DivineBlessing_ActiveSpell = nil;

	-- If success is false, stop the targeting so the cursor doesn't stay active
	if (success == false) then
		SpellStopTargeting();
	end
	
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].wait == nil) then
		success = true;
	end
	
 	if (success == true) then
 		if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_RAID) then
 			if (DivineBlessing_Config[DivineBlessing_Player].announceRaidProgress) then
 				local index = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index;
 				local pet = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet;
 				local remaining = DivineBlessing_GetRemainingCount(set);
				local target = DivineBlessing_GetTarget(set, index, pet);
				if ( target ) then
					local targetName = DivineBlessing_GetTargetName(set, index, pet);
					local spellName = DivineBlessing_GetSpellName(spell);
					
					if ( remaining == 1 ) then
						Print(spellName.." cast on "..targetName..".  "..remaining.." more cast until set completion.");
					else
						Print(spellName.." cast on "..targetName..".  "..remaining.." more casts until set completion.");
					end
				end
			end
		end

 		if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return end
 		
 		local oldIndex = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index;
 		local oldPet = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet;
 		if ( not oldIndex ) then oldIndex = 1; end
 		Debug("[DivineBlessing] oldIndex: "..oldIndex);
 		local index, pet = DivineBlessing_NextAvailableSpell(set, 0);
 		
 		-- We have wrapped around if:
 		--  1) index is < oldIndex (we've gone to a lower #)
 		--  2) index and pet are the same (this is the only valid spell we have)
 		-- If our next spell less than or equal to the current one, we've wrapped around
 		if (( index < oldIndex ) or (( index == oldIndex ) and ( pet == oldPet ))) then
 			index = 1;
 			pet = nil;
 		end
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index = index;
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet = pet;

		if (( index == 1 ) and ( not pet )) then
			if (DivineBlessing_Config[DivineBlessing_Player].announceSetCompletion) then
				Print(DivineBlessing_GetSetName(set).." completed.");
			end
		end
	else
		if (spell == nil) then
			local activeIndex = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index;
			local spell = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][activeIndex];
		end
		if (DivineBlessing_Config[DivineBlessing_Player].announceFailures) then
			local index = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index;
			local pet = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].pet;
			local target = DivineBlessing_GetTarget(set, index, pet);
			if (target) then
				Print(spell.name.."("..spell.rank..") did not cast successfully on "..UnitName(target)..".");
			end
		end
	end
	DivineBlessing_UpdateSet(set);
end

--[[
--	DivineBlessing_Register ()
--		Initialize the user interface
--
--	Args:
--		NO ARGS
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_Register()
	if (not DivineBlessing_Player) then return end
	if (DivineBlessing_Registered == true) then return end

	DivineBlessing_Init();
	Print(string.format(DIVINEBLESSING_LOADED_FORMAT_STRING, DivineBlessing_Player), 0);
		
	local group, subgroup = UnitFactionGroup("player");
	if (group == "Horde") then
		for set = DIVINEBLESSING_NORMALSETCOUNT + 1, DIVINEBLESSING_SETCOUNT, 1 do
			getglobal("DivineBlessing_ButtonSet"..set.."4Text"):SetText("Shaman");
		end
	end
	
	-- Update the config settings in the dialog
	local config = DivineBlessing_Config[DivineBlessing_Player];
	if (config.autoUpgradeSpells) then DivineBlessing_AutoUpgradeSpells:SetChecked("true"); end
	if (config.announceRaidProgress) then DivineBlessing_AnnounceRaidProgress:SetChecked("true"); end
	if (config.announceSetCompletion) then DivineBlessing_AnnounceSetCompletion:SetChecked("true"); end
	if (config.announceFailures) then DivineBlessing_AnnounceFailures:SetChecked("true"); end
	if (config.bannerAnnounce) then DivineBlessing_BannerAnnounce:SetChecked("true"); end
	if (DivineBlessing_Debug == true) then DivineBlessing_Debug:SetChecked("true"); end
	
	-- Update the config settings for the sets
	local set;
	for set = 1, DIVINEBLESSING_SETCOUNT, 1 do
		DivineBlessing_UpdateSet(set);
	end

	-- Done
	DivineBlessing_Registered = true;
end

--[[
--	DivineBlessing_ConfigEdit ()
--		Toggle the config pane
--
--	Args:
--		success -- whether the casting failed or succeeded
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_ConfigEdit()
	if (DivineBlessing_ConfigFrame:IsVisible()) then
		HideUIPanel(DivineBlessing_ConfigFrame);
	else
		DivineBlessing_ConfigFrame_Title:SetText(DIVINEBLESSING_TITLE);
		ShowUIPanel(DivineBlessing_ConfigFrame);
		DivineBlessing_Tab_OnClick(DivineBlessing_ConfigFrame.selectedTab);
	end
end

--[[
--	DivineBlessing_ResetSetIndex ( number setOverride )
--		Resets the specified set to the beginning
--
--	Args:
--		setOverride -- specify the set to reset (as opposed to calling it from a button)
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_ResetSetIndex(setOverride)
	local set;
	if (setOverride) then
		set = setOverride;
	else
		set = this:GetParent():GetID();
	end
	if (set == nil) then return end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return end
	DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index = 1;
	Print(string.format(DIVINEBLESSING_RESET_FORMAT, DivineBlessing_GetSetName(set)), 0);
	DivineBlessing_UpdateSet(set);	
end

--[[
--	DivineBlessing_ClearSet ( number setOverride )
--		Clear all settings for the specified set
--
--	Args:
--		setOverride -- specify the set to clear (as opposed to calling it from a button)
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_ClearSet(setOverride)
	local set;
	if (setOverride) then
		set = setOverride;
	else
		set = this:GetParent():GetID();
	end
	if (set == nil) then return end

	local type;
	if ((set >= 1) and (set <= DIVINEBLESSING_NORMALSETCOUNT)) then
		type = SETTYPE_PARTY;
	elseif ((set > DIVINEBLESSING_NORMALSETCOUNT) and
			(set <= DIVINEBLESSING_NORMALSETCOUNT + DIVINEBLESSING_CLASSSETCOUNT)) then
		type = SETTYPE_CLASS;
	elseif ((set > DIVINEBLESSING_NORMALSETCOUNT + DIVINEBLESSING_CLASSSETCOUNT) and
			(set <= DIVINEBLESSING_SETCOUNT)) then
		type = SETTYPE_RAID;
	end

	DivineBlessing_InitSet(set, type);
	DivineBlessing_UpdateSet(set);
end

--[[
--	DivineBlessing_SetByClass ( number setOverride )
--		Set the buffs associated with the specified party set using the class set as a guide
--
--	Args:
--		setOverride -- specify the set to update
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_SetByClass(setOverride)
	local set;
	if (setOverride) then
		set = setOverride;
	else
		set = this:GetParent():GetID();
	end
	if (set == nil) then return; end
	DivineBlessing_ClearSet(set);

	local classSet = DIVINEBLESSING_NORMALSETCOUNT + 1;
	for playerNum = 1, 5, 1 do
		local target = nil
		if (playerNum == 1) then
			target = "player";
		else
			target = "party"..playerNum;
		end
		
		local target, spell = DivineBlessing_GetSpell(classSet, playerNum, nil);
		if (spell ~= nil) then
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][playerNum].id = spell.id;
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][playerNum].name = spell.name;
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][playerNum].rank = spell.rank;
		end
		
		target, spell = DivineBlessing_GetSpell(classSet, playerNum, 1);
		if (spell ~= nil) then
			local petNum = playerNum + 5;
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][petNum].id = spell.id;
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][petNum].name = spell.name;
			DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][petNum].rank = spell.rank;
		end
	end

	DivineBlessing_UpdateSet(set);
end

--[[
--	DivineBlessing_SwapButton ( number set, number index )
--		Swap the "carried" spell with the button at set, index
--
--	Args:
--		set -- the set to swap with
--		index -- the index in the set to swap with
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_SwapButton(set, index)
	if (DivineBlessing_Button_ValidPos(set, index) == false) then return end
	
	local temp = nil;
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index].id > 0) then 
		temp = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index];
	end

	-- Drop the current button
	DivineBlessing_SetButton(set, index);
	
	-- Load the old one into the cursor
	if (temp) then 
		if (temp.id > 0) then 
			DivineBlessing_PickupSpell(temp.id);
			PickupSpell(temp.id, BOOKTYPE_SPELL);
		end
	end
end

--[[
--	DivineBlessing_PickupSpell ( number id )
--		Carry the specified spell
--
--	Args:
--		id -- the spell id
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_PickupSpell(id)
	DivineBlessing_CarriedID = id;
end

--[[
--	DivineBlessing_DropSpell ()
--		Drop the "carried" spell
--
--	Args:
--		NO ARGS
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_DropSpell()
	DivineBlessing_CarriedID = -1;
	PickupSpell(511, "spell");
end

--[[
--	DivineBlessing_SetButton ( number set, number index )
--		Drop the "carried" spell into the button at set, index
--
--	Args:
--		set -- the set to drop the carried spell into
--		index -- the index in the set to drop the carried spell into
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_SetButton(set, index)
	if (DivineBlessing_Button_ValidPos(set, index) == false) then return end

	-- Drop the spell into the button	
	DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index] =
		{
			id = DivineBlessing_CarriedID
		}
	
	DivineBlessing_UpdateSpell(DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index]);
	DivineBlessing_DropSpell();
	DivineBlessing_Button_OnUpdate(this);	
end

--[[
--	DivineBlessing_UseButton ( number set, number index )
--		Use the spell at the specified position
--
--	Args:
--		set -- the set
--		index -- the index in the set
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_UseButton(set, index)
	if (DivineBlessing_Button_ValidPos(set, index) == false) then return end

	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index].id > 0) then 
		CastSpell(DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index].id, BOOKTYPE_SPELL);
	end
end

--[[
--	DivineBlessing_GetRemainingCount ( number set )
--		Return the number of casts remaining to complete the set
--
--	Args:
--		set -- the set
--
--	Returns:
--		count -- number - the number of casts remaining until the set is completely cast
--]]

function DivineBlessing_GetRemainingCount(set)
	if (not DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set]) then return 0; end
	
	local index = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index;
	if (index < 1) then return 0; end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type == SETTYPE_RAID) then
		local count = 0;
		for targetIndex = index, GetNumRaidMembers(), 1 do
			local _, _, subGroup = GetRaidRosterInfo(targetIndex);
			if ( DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].targetGroup[subGroup] ) then
				local target, spell;
				
				target, spell = DivineBlessing_GetSpell(set, targetIndex, nil);
				if (( spell ) and ( spell.id > -1 )) then count = count + 1; end
				
				target, spell = DivineBlessing_GetSpell(set, targetIndex, 1);
				-- When counting Pets, we need to verify that the pet exists currently
				if (( spell ) and ( spell.id > -1 ) and ( UnitExists(target) )) then count = count + 1; end
			end
		end
		return count;
	else
		local count = 0;
		for targetIndex = index, GetNumPartyMembers() + 1, 1 do
			local target, spell;
			
			target, spell = DivineBlessing_GetSpell(set, targetIndex, nil);
			if (( spell ) and ( spell.id > -1 )) then count = count + 1; end
			
			target, spell = DivineBlessing_GetSpell(set, targetIndex, 1);
			-- When counting Pets, we need to verify that the pet exists currently
			if (( spell ) and ( spell.id > -1 ) and ( UnitExists(target) )) then count = count + 1; end
		end
		
		return count;
	end
end

--[[
--	DivineBlessing_GetSpellID ( table spell )
--		Look up the id for the provided spell
--
--	Args:
--		spell -- the spell's information:
--				{
--					name -- string - the spell name
--					rank -- string - the spell rank
--				}
--
--	Returns:
--		id -- number - the spell's id, or -1 if it was not found
--]]

function DivineBlessing_GetSpellID(spell)
	if (spell.name == nil) then return -1 end
	
	local i = 1;
	local name, rankName;
	name, rankName = GetSpellName(i, BOOKTYPE_SPELL)
	while name do
		while name == spell.name do
			if (not DivineBlessing_Config[DivineBlessing_Player].autoUpgradeSpells) then
				if (rankName == spell.rank) then return i end
			end
			name, rankName = GetSpellName(i + 1, BOOKTYPE_SPELL)
			if (name ~= spell.name) then return i end
			i = i + 1;
		end
		i = i + 1;
		name, rankName = GetSpellName(i, BOOKTYPE_SPELL)
	end
	return -1;
end

--[[
--	DivineBlessing_UpdateSpells ()
--		Look up the name or id for all spells
--
--	Args:
--		NO ARGS
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_UpdateSpells()
	for set = 1, DIVINEBLESSING_SETCOUNT, 1 do
		for spellIndex = 1, DivineBlessing_GetSetNumSlots(set, true), 1 do
			DivineBlessing_UpdateSpell(DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][spellIndex]);
		end
	end
end

--[[
--	DivineBlessing_UpdateSpell ( table spell )
--		Look up the name or id for the specified spell
--
--	Args:
--		spell -- looks up the name, or id, depending on which is missing
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_UpdateSpell(spell)
	if (spell == nil) then return; end
	
	if (( not spell.name ) or ( string.len(spell.name) == 0 )) then
		if (spell.id == -1) then
			spell.name = nil;
			spell.rank = nil;
			return;
		end
		
		-- Look up the spell's name information based on its ID
		spell.name, spell.rank = GetSpellName(spell.id, BOOKTYPE_SPELL);
	else
		-- Reload the ID based on the name
		local id = DivineBlessing_GetSpellID(spell);
		if ( id == -1 ) then
			-- We didn't find this spell's id, so it doesn't exist anymore.  Clear it.
			spell.id = -1;
			spell.name = nil;
			spell.rank = nil;
		else
			-- Update the ID to the new one, and make sure the name / rank are correct
			spell.id = id;
			spell.name, spell.rank = GetSpellName(spell.id, BOOKTYPE_SPELL);
		end
	end
end

--[[
--	DivineBlessing_WatchSpellbook ( bool drag )
--		Watches spellbook activity to grab dragged spells
--
--	Args:
--		drag -- provided by the original event handler.  Currently unused.
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_WatchSpellbook(drag)
	-- We only care about spells in the BOOKTYPE_SPELL book
	if (SpellBookFrame.bookType ~= BOOKTYPE_SPELL) then return; end
	
	local id = SpellBook_GetSpellID(this:GetID());
	if (id > MAX_SPELLS) then
		return;
	end
	if (IsShiftKeyDown()) then
		DivineBlessing_PickupSpell(id, BOOKTYPE_SPELL);		
	elseif (drag) then
		DivineBlessing_PickupSpell(id, BOOKTYPE_SPELL);
	end

	-- Drop it in 30 seconds
	DivineBlessing_DropSpellTimer = 30;
	DivineBlessing_UpdateFrame:Show();
end

--[[
--	DivineBlessing_UpdateSet ( number set )
--		Update the user interface for the specified set
--
--	Args:
--		set -- the set number
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_UpdateSet(set) 
	if (set == nil) then return end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return end

	local size = DivineBlessing_GetSetNumSlots(set);
	for i=1, size, 1 do
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set..i.."Button"));
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."Pet"..i.."Button"));
	end

	-- Class and Raid pet slots are named, not numbered, so we need to update them specifically
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].type ~= SETTYPE_PARTY) then
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."ImpButton"));
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."VoidwalkerButton"));
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."SuccubusButton"));
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."FelhunterButton"));
		DivineBlessing_Button_OnUpdate(getglobal("DivineBlessing_ButtonSet"..set.."BeastButton"));
	end
	
	-- Update the config settings for this set
	local buttonSet = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set];
	if (buttonSet.wait) then
		getglobal("DivineBlessing_ButtonSet"..set.."WaitButton"):SetChecked("true");
	end
	if (buttonSet.override) then
		getglobal("DivineBlessing_ButtonSet"..set.."OverrideButton"):SetChecked("true");
	end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].targetGroup) then
		for group = 1, 8, 1 do
			if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].targetGroup[group]) then
				getglobal("DivineBlessing_GroupTarget"..set.."_GroupTarget"..group):SetChecked("true");
			end
		end
	end
end

------------------------------------------------------------------------------
-- Button Methods
------------------------------------------------------------------------------

--[[
--	DivineBlessing_Button_ValidPos ( number set, number index )
--		Checks to see if there is a valid button at the specified index
--
--	Args:
--		set -- the set number
--		index -- the set index
--
--	Returns:
--		boolean -- true if the position is valid, false if not
--]]

function DivineBlessing_Button_ValidPos(set, index)
	if (set == nil or index == nil) then return false end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return false end
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index] == nil) then return false end
	return true;
end

--[[
--	DivineBlessing_Button_GetPos ( object button )
--		Gets the set and index for the specified button
--
--	Args:
--		button -- the button to get the position of
--
--	Returns:
--		set, index
--		set -- number - the set the button is in
--		index -- number - the index of the button
--]]

function DivineBlessing_Button_GetPos(button)
	if (button == nil) then return 0, 0 end
	local textButton = button:GetParent();
	return textButton:GetParent():GetID(), textButton:GetID();
end

--[[
--	DivineBlessing_Button_SetTexture ( object button )
--		Sets the texture for the button
--
--	Args:
--		button -- the button
--
--	Returns:
--		NO RETURN
--]]

function DivineBlessing_Button_SetTexture(button)
	local set, index = DivineBlessing_Button_GetPos(button);
	if (DivineBlessing_Button_ValidPos(set, index) == false) then return end

	local buttonInfo = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index];
	local id = buttonInfo.id;

	local name = button:GetName();	
	local icon = getglobal(name.."Icon");
	local cooldown = getglobal(name.."Cooldown");
	
	local enable = true;
	if (set <= DIVINEBLESSING_NORMALSETCOUNT) then
		if (( index > 1 ) and ( index < 6 )) then
			if ( not GetPartyMember(index - 1) ) then enable = false; end
		elseif ( index == 6 ) then
			if ( not UnitExists("pet") ) then enable = false; end
		elseif ( index > 6 ) then
			if ( not UnitExists("partypet"..index - 6) ) then enable = false; end
		end
	end

	if (id > 0) then 
		-- Set the index to checked if true
		if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == index) then 
			button:SetChecked("true");
		end
	
		-- Get the spell texture
		local texture = GetSpellTexture(id, BOOKTYPE_SPELL);
		if ( texture ) then
			icon:SetTexture(texture);
			icon:Show();
		else
			icon:Hide();
		end
		
		-- Update the cooldown
		local start, duration, enable = GetSpellCooldown(id, BOOKTYPE_SPELL);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
		
		if (set <= DIVINEBLESSING_NORMALSETCOUNT) then
			if ( enable ) then
				icon:SetVertexColor(1, 1, 1);
			else
				icon:SetVertexColor(.4, .4, .4);
			end
		end
	else
		icon:Hide();
	end

	-- Disable labels for absent members	
	local label = getglobal(button:GetParent():GetName().."Text");
	if ( enable ) then
		label:SetTextColor(1, 1, 1);
	else
		label:SetTextColor(.4, .4, .4);
	end
end

----------------------------------------------------------------------
-- Event Handlers
----------------------------------------------------------------------

function DivineBlessing_OnLoad()
	PanelTemplates_SetNumTabs(this, 4);
	this.selectedTab = 1;
	PanelTemplates_UpdateTabs(this);
	
	-- Hook the spellbook being opened so we can drag spells from it
	if (( Sea ) and ( Sea.util ) and ( Sea.util.hook )) then
		Sea.util.hook("SpellButton_OnClick", "DivineBlessing_WatchSpellbook", "before");
	else
		DivineBlessing_Saved_SpellButton_OnClick = SpellButton_OnClick;
		SpellButton_OnClick = DivineBlessing_SpellButton_OnClick;
	end

	-- Update the raid set text
	local startSet = DIVINEBLESSING_NORMALSETCOUNT + DIVINEBLESSING_CLASSSETCOUNT + 1;
	local endSet = startSet + DIVINEBLESSING_RAIDSETCOUNT - 1;
	for set = startSet, endSet, 1 do
		getglobal("DivineBlessing_ButtonSet"..set.."BlessingLabel"):SetText("Raid Blessing");
	end

	-- Register events
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("LEARNED_SPELL_IN_TAB");
	this:RegisterEvent("SPELLCAST_STOP");
	this:RegisterEvent("SPELLCAST_INTERRUPTED");
	this:RegisterEvent("SPELLCAST_FAILED");
	
	-- Register slash commands
	SlashCmdList["DIVINEBLESSING"] = DivineBlessing_SlashCmd;
	SlashCmdList["BLESS"] = DivineBlessing_BlessCmd;

	DivineBlessing_RegisterCosmos();
	DivineBlessing_RegisterKhaos();	
end

function DivineBlessing_RegisterCosmos()
	if (Cosmos_RegisterButton) then
		Cosmos_RegisterButton(
			DIVINEBLESSING_BUTTON_NAME,
			DIVINEBLESSING_BUTTON_SUBTITLE,
			DIVINEBLESSING_BUTTON_DESCRIPTION,
			DIVINEBLESSING_BUTTON_ICON,
			DivineBlessing_ConfigEdit,
			function() return true end
		);
	end
end

function DivineBlessing_RegisterKhaos()
	if (EarthFeature_AddButton) then
		EarthFeature_AddButton(
			{
				id = DIVINEBLESSING_KHAOS_ID;
				name = DIVINEBLESSING_BUTTON_NAME;
				subtext = DIVINEBLESSING_BUTTON_SUBTITLE;
				tooltip = DIVINEBLESSING_BUTTON_DESCRIPTION;
				icon = DIVINEBLESSING_BUTTON_ICON;
				callback = DivineBlessing_ConfigEdit;
				test = nil;
			}
		);
	end
end	

function DivineBlessing_UpdateFrame_OnUpdate(elapsed)
	if (DivineBlessing_DropSpellTimer == nil) then return end
	DivineBlessing_DropSpellTimer = DivineBlessing_DropSpellTimer - elapsed;
	if (DivineBlessing_DropSpellTimer < 0) then
		DivineBlessing_DropSpell();
		DivineBlessing_DropSpellTimer = nil;
		-- We don't need to watch for events now, so hide the frame until it's needed
		DivineBlessing_UpdateFrame:Hide();
	end
end

function DivineBlessing_SpellButton_OnClick(drag)
	DivineBlessing_WatchSpellbook(drag);
	if (DivineBlessing_Saved_SpellButton_OnClick) then
		DivineBlessing_Saved_SpellButton_OnClick(drag);
	end
end

function DivineBlessing_OnEvent()
	if ( event == "ADDON_LOADED" and arg1 == DIVINEBLESSING_ADDON_NAME ) then
		DivineBlessing_Player = UnitName("player").." of "..GetRealmName();
		DivineBlessing_Register();
	elseif (event == "LEARNED_SPELL_IN_TAB") then
		DivineBlessing_UpdateSpells();
	elseif (event == "SPELLCAST_STOP") then
		DivineBlessing_UpdateSetIndex(true);
	elseif ((event == "SPELLCAST_FAILED") or (event == "SPELLCAST_INTERRUPTED")) then
		DivineBlessing_UpdateSetIndex(false);
	end
end

function DivineBlessing_Config_Tab1_ScrollUp_OnClick()
	DivineBlessing_Config_Tab1_ScrollIndex = DivineBlessing_Config_Tab1_ScrollIndex - 1;
	if (DivineBlessing_Config_Tab1_ScrollIndex < 1) then
		DivineBlessing_Config_Tab1_ScrollIndex = 1;
	end
	DivineBlessing_Config_Tab1_ShowSets();
end

function DivineBlessing_Config_Tab1_ScrollDown_OnClick()
	DivineBlessing_Config_Tab1_ScrollIndex = DivineBlessing_Config_Tab1_ScrollIndex + 1;
	if (DivineBlessing_Config_Tab1_ScrollIndex > DIVINEBLESSING_NORMALSETCOUNT / 2) then
		DivineBlessing_Config_Tab1_ScrollIndex = DIVINEBLESSING_NORMALSETCOUNT / 2;
	end
	DivineBlessing_Config_Tab1_ShowSets();
end

function DivineBlessing_Config_Tab1_ShowSets()
	for set = 1, DIVINEBLESSING_NORMALSETCOUNT, 1 do
		getglobal("DivineBlessing_ButtonSet"..set):Hide();
	end

	local showIndex = DivineBlessing_Config_Tab1_ScrollIndex * 2;

	getglobal("DivineBlessing_ButtonSet"..showIndex - 1):Show();
	DivineBlessing_UpdateSet(showIndex - 1);

	getglobal("DivineBlessing_ButtonSet"..showIndex):Show();
	DivineBlessing_UpdateSet(showIndex);
end

function DivineBlessing_Tab_OnClick(override)
	local oldTab = DivineBlessing_ConfigFrame.selectedTab;
	local newTab;
	if (override) then
		newTab = override;
	else
		if (this and this:GetID()) then
			newTab = this:GetID();
			PanelTemplates_Tab_OnClick(DivineBlessing_ConfigFrame);
		else
			newTab = oldTab;
		end
	end
	
	if (newTab ~= 1) then
		DivineBlessing_Config_Tab1:Hide();
	end
	if (newTab ~= 2) then
		DivineBlessing_Config_Tab2:Hide();
	end
	if (newTab ~= 3) then
		DivineBlessing_Config_Tab3:Hide();
	end
	if (newTab ~= 4) then
		DivineBlessing_Config_Tab4:Hide();
	end

	if (newTab == 1) then
		DivineBlessing_Config_Tab1:Show();
	elseif (newTab == 2) then
		DivineBlessing_Config_Tab2:Show();
	elseif (newTab == 3) then
		DivineBlessing_Config_Tab3:Show();
	elseif (newTab == 4) then
		DivineBlessing_Config_Tab4:Show();
	end
end

function DivineBlessing_WaitButton_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Wait");
	this.tooltipText="Wait until the spell is successfully cast to continue the sequence";
end

function DivineBlessing_OverrideTarget_OnClick(set, override)
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return end
	DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].override = override;
end

function DivineBlessing_OverrideTargetButton_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Override friendly target");
	this.tooltipText="If a friendly unit is targeted, cast the blessing on that unit instead of the next in sequence";
end


function DivineBlessing_GroupTargetButton_OnLoad()
	local group = this:GetID();
	local checkText = getglobal(this:GetName().."Text");
	checkText:SetText("Group "..group);
	checkText:SetTextColor(1, 1, 1);
	this.tooltipText="";
end

function DivineBlessing_GroupTargetButton_OnClick()
	local set = this:GetParent():GetID();
	local group = this:GetID();
	local value;
	if (this:GetChecked()) then
		value = 1;
	else
		value = nil;
	end
	DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].targetGroup[group] = value;
end

function DivineBlessing_ClassSet_OnLoad()
	local name = this:GetName();
	getglobal(name.."1Text"):SetText("Druid");
	getglobal(name.."2Text"):SetText("Hunter");
	getglobal(name.."3Text"):SetText("Mage");
	getglobal(name.."4Text"):SetText("Paladin");
	getglobal(name.."5Text"):SetText("Priest");
	getglobal(name.."6Text"):SetText("Rogue");
	getglobal(name.."7Text"):SetText("Warlock");
	getglobal(name.."8Text"):SetText("Warrior");
	
	getglobal(name.."ImpText"):SetText("Imp");
	getglobal(name.."VoidwalkerText"):SetText("Void");
	getglobal(name.."SuccubusText"):SetText("Succ");
	getglobal(name.."FelhunterText"):SetText("Fel");
	getglobal(name.."BeastText"):SetText("Beast");
	
	getglobal(name.."SetAllText"):SetText("Set All");
end

function DivineBlessing_BlessingSet_OnLoad()
	local name = this:GetName();
	getglobal(name.."1Text"):SetText("Self");
	getglobal(name.."2Text"):SetText("Party1");
	getglobal(name.."3Text"):SetText("Party2");
	getglobal(name.."4Text"):SetText("Party3");
	getglobal(name.."5Text"):SetText("Party4");
	getglobal(name.."Pet1Text"):SetText("Pet1");
	getglobal(name.."Pet2Text"):SetText("Pet2");
	getglobal(name.."Pet3Text"):SetText("Pet3");
	getglobal(name.."Pet4Text"):SetText("Pet4");
	getglobal(name.."Pet5Text"):SetText("Pet5");
	getglobal(name.."Label"):SetText(this:GetID());
end

function DivineBlessing_WaitButton_OnClick(set, wait)
	if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set] == nil) then return end
	DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].wait = wait;
end

function DivineBlessing_AutoUpgradeSpells_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Auto Upgrade Spells");
	this.tooltipText="Automatically upgrade spells blessing sets when higher ranks are purchased.";
end

function DivineBlessing_AutoUpgradeSpells_OnClick()
	if (this:GetChecked()) then
		DivineBlessing_Config[DivineBlessing_Player].autoUpgradeSpells = 1;
	else
		DivineBlessing_Config[DivineBlessing_Player].autoUpgradeSpells = nil;
	end
end

function DivineBlessing_AnnounceRaidProgress_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Announce Raid Progress");
	this.tooltipText="Shows status messages about raid buffing progress.";
end

function DivineBlessing_AnnounceRaidProgress_OnClick()
	if (this:GetChecked()) then
		DivineBlessing_Config[DivineBlessing_Player].announceRaidProgress = 1;
	else
		DivineBlessing_Config[DivineBlessing_Player].announceRaidProgress = nil;
	end
end

function DivineBlessing_AnnounceSetCompletion_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Announce Set Completion");
	this.tooltipText="Shows status messages about set completion.";
end

function DivineBlessing_AnnounceSetCompletion_OnClick()
	if (this:GetChecked()) then
		DivineBlessing_Config[DivineBlessing_Player].announceSetCompletion = 1;
	else
		DivineBlessing_Config[DivineBlessing_Player].announceSetCompletion = nil;
	end
end

function DivineBlessing_AnnounceFailures_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Announce Casting Failures");
	this.tooltipText="When a blessing set is configured to wait and a spell fails to cast, print a warning message.";
end

function DivineBlessing_AnnounceFailures_OnClick()
	if (this:GetChecked()) then
		DivineBlessing_Config[DivineBlessing_Player].announceFailures = 1;
	else
		DivineBlessing_Config[DivineBlessing_Player].announceFailures = nil;
	end
end

function DivineBlessing_BannerAnnounce_OnLoad()
	getglobal(this:GetName().."Text"):SetText("Announce Events in Center Screen");
	this.tooltipText="Display Divine Blessing events in center screen, as opposed to the chat window.";
end

function DivineBlessing_BannerAnnounce_OnClick()
	if (this:GetChecked()) then
		DivineBlessing_Config[DivineBlessing_Player].bannerAnnounce = 1;
	else
		DivineBlessing_Config[DivineBlessing_Player].bannerAnnounce = nil;
	end
end

function DivineBlessing_Debug_OnLoad()
	getglobal(this:GetName().."Text"):SetText("|cFFff3333Debug Messages|r");
	this.tooltipText="Display debug messages";
	if (DivineBlessing_Debug == true) then this:SetChecked("true"); end
end

function DivineBlessing_Debug_OnClick()
	if (this:GetChecked()) then
		DivineBlessing_Debug = true;
	else
		DivineBlessing_Debug = nil;
	end
end

----------------------------------------------------------------------
-- Button Events
----------------------------------------------------------------------

function DivineBlessing_Button_OnLoad()
end

function DivineBlessing_Button_OnUpdate(button)
	if (button == nil) then return; end
	
	button:SetChecked("false");
	local set, index = DivineBlessing_Button_GetPos(button);
	if (set == nil or index == nil) then return end
	DivineBlessing_Button_SetTexture(button);

	if (set <= DIVINEBLESSING_NORMALSETCOUNT) then
		if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index == index) then
			if (DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index].id > 0) then
				button:SetChecked("true");
			end
		end
	end
	
	if (set > DIVINEBLESSING_NORMALSETCOUNT) then return end
	
	-- Update the button's label
	for index = 1, DivineBlessing_GetSetSize(set), 1 do
		local unitName = nil;
		local unitPetName = nil;
		if (index == 1) then
			unitName = UnitName("player");
			unitPetName = UnitName("pet");
		else
			unitName = UnitName("party"..index - 1);
			unitPetName = UnitName("partypet"..index - 1);
		end
		
		local rootName = button:GetParent():GetParent():GetName();
		local label;
		
		label = getglobal(rootName..index.."Text");
		if (label ~= nil) then
			if (unitName == nil) then
				if (index == 1) then
					label:SetText("Self");
				else
					label:SetText("Party"..index - 1);
				end
			else
				label:SetText(unitName);
			end
		end
		
		label = getglobal(rootName.."Pet"..index.."Text");
		if (label ~= nil) then
			if (unitPetName == nil) then
				if (index == 1) then
					label:SetText("Pet");
				else
					label:SetText("Pet"..index - 1);
				end
			else
				label:SetText(unitPetName);
			end
		end
	end
end

function DivineBlessing_Button_OnDragStart()
	local set, index = DivineBlessing_Button_GetPos(this);
	DivineBlessing_SwapButton(set, index);
end

function DivineBlessing_Button_OnDragEnd()
	local set, index = DivineBlessing_Button_GetPos(this);
	DivineBlessing_SwapButton(set, index);
end

function DivineBlessing_Button_OnSetAll()
	local set = DivineBlessing_Button_GetPos(this);
	DivineBlessing_SetAll(set, DivineBlessing_CarriedID);
	DivineBlessing_DropSpell();
end

function DivineBlessing_Button_OnClick()
	local set, index = DivineBlessing_Button_GetPos(this);		
	if (DivineBlessing_Button_ValidPos(set, index) == false) then return end

	this:SetChecked("false");

	-- Pick up the current spell
	if (IsShiftKeyDown()) then 
		DivineBlessing_SwapButton(set, index);
	-- Set the next spell
	elseif (IsAltKeyDown()) then 
		DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set].index = index;
		DivineBlessing_UpdateSet(set);
	-- Drop the new spell
	elseif( DivineBlessing_CarriedID > 0 ) then
		DivineBlessing_SwapButton(set, index);
	-- Use the stored spell
	else 	
		DivineBlessing_UseButton(set, index);		
	end
end

function DivineBlessing_Button_OnEnter()
	-- Update the tooltip
	local set, index = DivineBlessing_Button_GetPos(this);
	if (DivineBlessing_Button_ValidPos(set, index) == false) then return end

	local id = DivineBlessing_Config[DivineBlessing_Player].ButtonMap[set][index].id;

	if (id > 0) then 
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		if ( GameTooltip:SetSpell(id, BOOKTYPE_SPELL) ) then
			this.updateTooltip = TOOLTIP_UPDATE_TIME;
		else
			this.updateTooltip = nil;
		end	
	end
end

function DivineBlessing_Button_OnLeave()
	GameTooltip:Hide();
end

function DivineBlessing_Button_OnEvent(event)
	if (event == "SPELL_UPDATE_COOLDOWN") then
		DivineBlessing_Button_OnUpdate(this);
	end
end
