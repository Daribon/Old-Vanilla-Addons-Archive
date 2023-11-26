--[[
	Cast Options
	 	Provides enchanced casting options such as auto self casting
	
	By: Mugendai
	Special Thanks:
		Telo - Orgigional concept for Self Cast
		Sarf - For making the origional Addon
		Exi and Miravlix -	For doing some rewriting and initial implimentation of Smart Ranks,
												resulting in prompting me to go ahead and do the rewrite.
		Some Other People -	For the concept of smart ranks, and their implementations.
												The info on the spell ranks, and some of the code related to them
												is based on someone elses work.  I do not know who, but whoever
												they are, they deserve credit for it.  If you wanna claim credit
												for this, then let me, Mugendai know.
		Wh1sper -	For the concept of Smart Assist Casting, and for going through the trouble to
							workout the textures for allmsot all the hostile, and self cast spells.
	Contact: mugekun@gmail.com
	
	Cast Options is a mod to allow the user to customize the way in which they cast spells.  It
	allows the user to choose a key to press in combination with a key to cast a spell, and in
	turn, cast the spell on themselves.  It also adds a smart casting mode that will cast any
	positive spells on the caster if the caster doesn't have a friendly target selected.  It
	also adds an option to cast buffs that can't be cast on lower level characters at	a lower
	rank so that the highest rank spell that can be cast on that player is cast.  It allows the
	user to cast hostile spells at the target of their friends, without detargeting their
	friends.  It also allows has the ability pick the target of friendly spells when in a gruop
	based on the type of spell, and the current status of the group members, and do so without
	retargeting from their current target.
	
	$Id: CastOptions.lua 2683 2005-10-22 22:11:07Z mugendai $
	$Rev: 2683 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-22 17:11:07 -0500 (Sat, 22 Oct 2005) $
]]--

--------------------------------------------------
--
-- CastOptions Declaration
--
--------------------------------------------------
CastOptions = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.9;
	MAINTAINER = "mugekun@gmail.com";
	MAX_RECAST = 60;
	MAX_BOUNDDELAY = 5;
	MAX_ID = 120;
	SHOT_CANCELED_HOLD_TIME = 1;
	BOUND_HOLD_TIME = 1;
	NOTARG_HOLD_TIME = 1;

	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	Targ = {				--If any entry is 1, then the spell will be cast at that target
		player = 0; party1 = 0; party2 = 0; party3 = 0; party4 = 0;
	};
	Holding = 0; 		--true when the user has a spell held in their mouse cursor
	Texture = 0;		--if true will print the texture when a player casts a spell
	PrintLink = 0;	--if true will print the item link id when a player uses an item
};
--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
--Main Configuration variable
CastOptions_Config = {
	Enabled = 0;				--Whether the mod is enabled or not
	SmartEquip = 0;			--Whether or not to automatically pick a piece of equipment for an equipment buff
	CancelWand = 0;			--Whether or not to cancel casting of a wand when a new spell is cast
	CancelShot = 0;			--Whether or not to cancel casting of a ranged weapon when using a bandage
	ShowCancelShot = 1;	--Whether or not to show a warning to let you know that the wand or ranged shot has been canceled
	NoDispel = 0;				--Whether or not to not automatically self cast dispel magic
	NoBoundCast = 0;		--Whether or not to not cast spells that will free a unit bound by a stun type spell
	BoundPotential = 1;	--Whether or not to not cast on bound units that will only potentially be freed
	BoundAttack = 1;		--Whether or not to not cast on bound units that can still attack
	BoundDelay = 1;			--Amount of time to a spell must be recast to override the bindings protection
	ManaControl = 0;		--Whether or not to prevent casting of mana boosting spells on units that don't have mana
	SmartRank = 0;			--Whether or not to automatically cast lower rank spells when neccisary
	SmartHeal = 0;			--Whether or not to automatically cast lower rank heals when higher levels aren't neccisary
	HealBoost = 0.10;		--Percentage of extra life to heal when smart rank healing
	Alt = 0;						--Whether or not to self cast when alt is held down
	Shift = 0;					--Whether or not to self cast when shift is held down
	Ctrl = 0;						--Whether or not to self cast when ctrl is held down
	RightSelf = 0;			--Whether or not to self cast when the right mouse button is clicked
	AimedCast = 0;			--Whether or not to cast friendly spells at the group member that the mouse is over the frame of
	AimedWorld = 0;			--Whether or not to aimed cast at units in the world frame
	AimedHostile = 0;		--Whether or not to allow aimed casting of hostile spells
	AimedAlt = 0;				--Whether or not to aimed cast when alt is held down
	AimedShift = 0;			--Whether or not to aimed cast when shift is held down
	AimedCtrl = 0;			--Whether or not to aimed cast when ctrl is held down
	Smart = 0;					--Whether or not to automatically self cast friendly spells
	NoGroup = 0;				--Whether or not to disable smart self casting in groups
	SmartAssist = 0;		--Whether or not to cast hostile spells and friendly unit's target
	AssistTarget = 0;		--Whether or not to change to the hostile target selected in an assist
	ChainAssist = 0;		--Whether or not to keep targeting targets targets till a hostile is found
	SmartGroup = 0;			--Whether or not to do smaart group casting
	GroupPets = 0;			--Whether or not to do smaart group casting on pets
	GroupTarget = 0;		--Whether or not to change to the chosen target when group casting
	GroupGroup = 0;			--Whether or not to group cast when a group member is selected
	GroupSelf = 1;			--Whether or not to self cast when a group member is selected
	GroupHeal = 1;			--Whether or not to heal the lowest life party member
	GroupMana = 1;			--Whether or not to boost the lowest mana party members
	GroupCure = 1;			--Whether or not to cure party members with poisen/curse/disease/magic
	GroupBuff = 1;			--Whether or not to put buffs on those who don't have them yet, if your target already has it, or is invalid
	GroupBlessing = 1;	--Whether or not to group cast blessing spells
	CancelSpell = 0;		--Whether or not to cancel casting of the group spell, if no good target is found
	RecastTime = 3;			--Amount of time to wait till a spell can be recast on a character
};
--Store this config for safe load
MCom.safeLoad("CastOptions_Config");

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Hooks or unhooks needed functions ]]--
CastOptions.SetupHooks = function (toggle)
	if ( toggle == 1 ) then
		--Get the proper initial state of holding
		if (CursorHasItem() or CursorHasSpell()) then 
			CastOptions.Holding = 1; 
		else 
			CastOptions.Holding = 0; 
		end
		--Set up the use action hook
		MCom.util.hook("UseAction", "CastOptions.UseAction", "replace");
		--Set up the use container item hook
		MCom.util.hook("UseContainerItem", "CastOptions.UseContainerItem", "replace");
		--Set up the use book spell hook
		MCom.util.hook("CastSpell", "CastOptions.CastSpell", "replace");
		--Set up the by name hook
		MCom.util.hook("CastSpellByName", "CastOptions.CastSpellByName", "replace");
		--Set up the attack target hook
		MCom.util.hook("AttackTarget", "CastOptions.AttackTarget", "before");
		--Set up the pet attack hook
		MCom.util.hook("CastPetAction", "CastOptions.CastPetAction", "before");
		--These are hooked to let us know if something is held in the mouse cursor or not, to prevent some issues
		MCom.util.hook("PickupAction", "CastOptions.PickupAction", "after");
		MCom.util.hook("PlaceAction", "CastOptions.PlaceAction", "after");
	else
		--Unhook the functions
		MCom.util.unhook("UseAction", "CastOptions.UseAction", "replace");
		MCom.util.unhook("UseContainerItem", "CastOptions.UseContainerItem", "replace");
		MCom.util.unhook("CastSpell", "CastOptions.CastSpell", "replace");
		MCom.util.unhook("CastSpellByName", "CastOptions.CastSpellByName", "replace");
		MCom.util.unhook("AttackTarget", "CastOptions.AttackTarget", "before");
		MCom.util.unhook("CastPetAction", "CastOptions.CastPetAction", "before");
		MCom.util.unhook("PickupAction", "CastOptions.PickupAction", "after");
		MCom.util.unhook("PlaceAction", "CastOptions.PlaceAction", "after");
	end
end

--[[ Toggles the Self cast variable ]]--
CastOptions.ToggleSelf = function (toggle)
	--Toggle it if -1 or nothing was passed
	if ( (not toggle) or (toggle == -1) ) then
		if (CastOptions.Targ.player == 1) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	--Make sure its in range
	if (toggle > 1) then
		toggle = 1;
	end
	if (toggle < 0) then
		toggle = 0;
	end
	--Set it
	CastOptions.Targ.player = toggle;
end

--[[ Returns true if any keys are pressed to force a targeted cast ]]--
CastOptions.AnyKeysDown = function ()
	--See if any self key confitions are met
	if ( CastOptions.SelfKeysDown() ) then
		return true;
	end
	--See if any group key conditions are met
	for i = 1, GetNumPartyMembers() do
		if ( CastOptions.Targ["party"..i] == 1 ) then
			return true;
		end
	end
	--No targeting keys are pressed
	return false;
end

--[[ Returns true if appropriate keys are pressed to force self cast ]]--
CastOptions.SelfKeysDown = function ()
	--When the right conditions are met return to true to indicate spells should be self cast
	if ( CastOptions.Targ.player == 1 ) then
		return true;
	elseif ( IsAltKeyDown() and ( CastOptions_Config.Alt == 1) ) then
		return true;
	elseif ( IsShiftKeyDown() and ( CastOptions_Config.Shift == 1) ) then
		return true;
	elseif ( IsControlKeyDown() and ( CastOptions_Config.Ctrl == 1) ) then
		return true;
	elseif ( ( arg1 == "RightButton" ) and ( CastOptions_Config.RightSelf == 1) ) then
		return true;
	else
		--Nothing indicates that this should be self cast so return false
		return false;
	end
end

--[[ Returns false if the spell is dispel, and should not be cast on the player ]]--
CastOptions.SelfDispel = function (texture)
	--If this is dispel, then check to see if the player has something to dispel
	if ( (texture == "Interface\\Icons\\Spell_Holy_DispelMagic") ) then
		--If the player has something to be dispeled, return true
		if ( CastOptions.CheckForDeBuff("player", CASTOPTIONS_DEBUFF_MAGIC) ) then
			return true;
		end
		--If the player has no target, then we can do dispel
		if ( not UnitExists("target") ) then
			return true;
		end
		--If the player doesn't have something to be dispeled return false
		return false;
	end
	--If this isn't dispel, then return true
	return true;
end

--[[ Returns true if smart self casting should be used ]]--
CastOptions.UseSmart = function (texture, localSelfCast)
	--Check if the option is enabled
	if ( CastOptions_Config.Smart == 1 ) then
		--if we are supposed to disable when in a group, and are in a group then return false
		if ( CastOptions_Config.NoGroup == 1 ) then
			if ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0 ) ) then
				return false;
			end
		end
		if ( UnitExists("target") ) then
			--Only return true if the target isn't friendly
			if ( not UnitCanAttack("player", "target") ) then
				if ( texture and localSelfCast[texture] and localSelfCast[texture].g ) then
					if ( CastOptions.UnitInGroup("target") ) then
						return false;
					end
				elseif ( not CastOptions.ManaTest("target", texture) ) then
					return true;
				else
					return false;
				end
			end
		end
		return true;
	else
		return false;
	end
end

--[[ Returns true if smart group casting should be used ]]--
CastOptions.UseGroup = function (texture)
	--If this is a blessing spell, and we aren't allowing group blessing, then abort now
	local _, pClass = UnitClass("player");
	if	( CastOptions.SpellData.Self[pClass] and CastOptions.SpellData.Self[pClass][texture] and CastOptions.SpellData.Self[pClass][texture].l and ( CastOptions_Config.GroupBlessing ~= 1 ) ) then
		return false;
	end

	--Check if the option is enabled
	if ( (CastOptions_Config.SmartGroup == 1) and ( ( GetNumPartyMembers() > 0 ) or ( GetNumRaidMembers() > 0 ) or UnitExists("pet") ) ) then
		--If we have a target that is in our group, and group casting is enabled, then return true
		if ( UnitExists("target") ) then
			if ( (CastOptions_Config.GroupGroup == 1) and CastOptions.UnitInGroup("target") ) then
				local goodBless = true;
				if ( ( CastOptions_Config.GroupBlessing == 1 ) and CastOptions.SpellData.Self[pClass] and CastOptions.SpellData.Self[pClass][texture] and CastOptions.SpellData.Self[pClass][texture].l ) then
					--If we are supposed to be checking blessing learning, then default goodBless to false
					goodBless = false;
					--If the blessing does have this player in its list, then set goodBless true
					if ( CastOptions_Config.blessingCasts and CastOptions_Config.blessingCasts[texture] and CastOptions_Config.blessingCasts[texture][curUnitName] ) then
						goodBless = true;
					end
				end
				return goodBless;
			elseif ( UnitCanAttack("player", "target") )	then
				return true;
			elseif ( not CastOptions.ManaTest("target", texture) ) then
				return true;
			end
		else
			--If we have no target, then group cast
			return true;
		end
	end
	return false;
end

--[[ Returns true if this was an item buff ]]--
CastOptions.UseSmartEquip = function (byName, bookType, container, spell, spellName)
	--Only proceed if smart equiping is enabled, and we have the needed data
	if ( ( CastOptions_Config.SmartEquip == 1 ) and (not byName) and (not bookType) and (container or spellName) and spell ) then
		local itemLink;
		--If it's a container item, then simply get the link
		if (container) then
			itemLink = GetContainerItemLink(container, spell)
		elseif (spellName) then
			--If it is an action then get the action name, find the container item with that name, and get the link from it
			if ( CastOptions.BagData ) then
				for curBag in CastOptions.BagData do
					if ( CastOptions.BagData[curBag][spellName] ) then
						itemLink = CastOptions.BagData[curBag][spellName];
						break;
					end
				end
			end
		end
		--Only proceed if we got an item link
		if (itemLink) then
			--Get just the ID portion of the item link
			_, _, itemLink = string.find(itemLink, "Hitem:(.+):%d+%\124");

			--If enabled, then print the item's link, for debugging
			if (CastOptions.PrintLink == 1) then
				Sea.io.print(itemLink);
			end

			--Make sure that this item link is one of our equipment buffs
			if ( itemLink and CastOptions.SpellData.Equipment[itemLink] ) then
				--Get the data for this item
				local itemData = CastOptions.SpellData.Equipment[itemLink];
				local equipTarg;
				--If it is a weapon or fishing pole, deal with the weapon slots
				if ( itemData.b or itemData.s or itemData.f ) then
					local hasMain, hasOff;
					--Find out if the player has a main hand item equipped
					if ( GetInventoryItemTexture( "player", GetInventorySlotInfo( "MainHandSlot" ) ) ) then
						hasMain = true;
					end
					--Find out if the player has a secondary hand item equipped, but only if this is not a fishing pole
					if ( itemData.b or itemData.s and GetInventoryItemTexture( "player", GetInventorySlotInfo( "SecondaryHandSlot" ) ) ) then
						local _, offHandSpeed = UnitAttackSpeed("player");
						if (offHandSpeed) then
							hasOff = true;
						end
					end
					--Make sure a weapon is equipped
					if ( hasMain or hasOff ) then
						--Get info on the weapons buff, if any
						local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo();
						--If there are two weapons equipped then pick one
						if ( hasMain and hasOff ) then
							if ( not hasMainHandEnchant ) then
								--If the main hand doesn't have a buff, then choose it
								equipTarg = "MainHandSlot";
							elseif ( not hasOffHandEnchant ) then
								--If the secondary hand doesn't have a buff, then choose it
								equipTarg = "SecondaryHandSlot";
							elseif ( mainHandExpiration <= offHandExpiration ) then
								--If main hand was buffed further back in time than the second hand, then choose the main
								equipTarg = "MainHandSlot";
							else
								--If second hand was buffed further back in time than the main hand, then choose the secondary
								equipTarg = "SecondaryHandSlot";
							end
						elseif (hasMain) then
							--If the main hand is the only weapon, then choose it
							equipTarg = "MainHandSlot";
							if ( itemData.f ) then
								--If this buff only applies to fishing poles, then if this isnt a fishing pole, dont choose anything
								local texture = GetInventoryItemTexture( "player", GetInventorySlotInfo( "MainHandSlot" ) );
								if ( itemTexture and ( not string.find( itemTexture, "INV_Fishingpole" ) ) ) then
									equipTarg = nil;
								end
							end
						elseif ( not itemData.f ) then
							--If a secondary is equipped, and this isn't for fishing only, then choose the secondary weapon
							equipTarg = "SecondaryHandSlot";
						end
					end
				end
	
				--Begin using the item
				CastOptions.DoCast(nil, nil, container, spell, nil);
	
				--If we have found a piece of equipment to use the item buff on, then do so
				if ( equipTarg ) then
					--Get the slot ID
					equipTarg = GetInventorySlotInfo(equipTarg);
					--If we are targeting as we should be, then select the chosen equipment slot
					if ( equipTarg and SpellIsTargeting() ) then
						PickupInventoryItem(equipTarg);
					end
				end
				return true;
			end
		end
	end
end

--[[ Gets the self cast table ]]--
CastOptions.GetSelfTable = function (container)
	local _, pClass = UnitClass("player");
	local _, pRace = UnitRace("player");
	if (pClass) then
		--Default the self cast table to empty
		local selfCastTable = {};
		if (not container) then
			--Get the self cast table
			selfCastTable = CastOptions.SpellData.Self[pClass];
			if (pClass == "PRIEST") then
				--remove dispel from the list if we arent supposed to self cast it, otherwise make sure its in the list
				if (CastOptions_Config.NoDispel == 1) then
					selfCastTable["Interface\\Icons\\Spell_Holy_DispelMagic"] = nil;
				else
					selfCastTable["Interface\\Icons\\Spell_Holy_DispelMagic"] = {m=1;};
				end
			end
			
			if (pRace and CastOptions.SpellData.Self[pRace]) then
				--Add the racial self cast list to the table
				for curSpell in CastOptions.SpellData.Self[pRace] do
					selfCastTable[curSpell] = CastOptions.SpellData.Self[pRace][curSpell];
				end
			end
		end
		
		--Add the container self cast list to the table
		for curItem in CastOptions.SpellData.Self.Container do
			selfCastTable[curItem] = CastOptions.SpellData.Self.Container[curItem];
		end

		return selfCastTable;
	end
end

--[[ Gets the hostile cast table ]]--
CastOptions.GetHostileTable = function (container)
	local _, pClass = UnitClass("player");
	local _, pRace = UnitRace("player");
	if (pClass) then
		--Default the hostile cast table to empty
		local hostileCastTable = {};
		if (not container) then
			--Get the hostile cast table
			hostileCastTable = CastOptions.SpellData.Hostile[pClass];
			
			if (pRace and CastOptions.SpellData.Self[pRace]) then
				--Add the racial hostile cast list to the table
				for curSpell in CastOptions.SpellData.Hostile[pRace] do
					hostileCastTable[curSpell] = CastOptions.SpellData.Hostile[pRace][curSpell];
				end
			end
		end
		
		--Add the container hostile cast list to the table
		for curItem in CastOptions.SpellData.Hostile.Container do
			hostileCastTable[curItem] = CastOptions.SpellData.Hostile.Container[curItem];
		end

		--Add the ranged texture to the list if there is one
		local rangedTexture = GetInventoryItemTexture("player", GetInventorySlotInfo("RangedSlot"));
		if (rangedTexture) then
			hostileCastTable[rangedTexture] = true;
		end
		return hostileCastTable;
	end
end

--[[ Gets the highest level rank of the spell for the target ]]--
CastOptions.GetRank = function (unit, buff, rank, texture)
	if (unit and buff and rank and texture) then
		local castRank = tonumber(rank);	--The rank to cast

		--Get the player class
		local _, pClass = UnitClass("player");
		--Get the data for the buff
		local curBuff = CastOptions.SpellData.Ranks[pClass][texture];
		--Get the targets level
		local targetLevel = UnitLevel(unit);

		--Make sure we have the buff data, and the targets level
		if ( curBuff and (targetLevel and targetLevel > 0) ) then
			--Make sure the passed rank is found
			if (curBuff[castRank]) then
				--Keep lowering the rank till one that can be cast on the target is found
				while ( ((curBuff[castRank] - 10) > targetLevel) and (castRank > 1) ) do
					castRank = castRank - 1;
				end
			else
				--We didn't find the requested rank, so pop out an error
				Sea.io.printc(ChatTypeInfo["SYSTEM"], "ERROR: Spell rank "..castRank.." not found for "..buff..", please contact "..CastOptions.MAINTAINER);
			end
		end
		return castRank;
	else
		return;
	end
end

--[[ Gets a rank where the heal wont heal the unit for more than they have life ]]--
CastOptions.GetHealRank = function (unit, spellName, spellRank, texture)
	if ( ( CastOptions_Config.SmartHeal == 1 ) and unit and spellName and spellRank and texture) then
		local castRank = tonumber(spellRank);	--The rank to cast

		--Get the player class
		local _, pClass = UnitClass("player");
		--Get the data for the heal
		local curHeal = CastOptions.SpellData.HealRanks[pClass][texture];

		--Make sure we have the buff data, and the targets level
		if (curHeal) then
			--Get the targets health
			local targetHealth = UnitHealth(unit);
			if ( targetHealth and ( targetHealth > 0 ) ) then
				local healthBoost = CastOptions_Config.HealBoost * UnitHealthMax(unit);
				targetHealth = ( UnitHealthMax(unit) - targetHealth ) + healthBoost;
				--Make sure the passed rank is found
				if ( curHeal.ranks[castRank] ) then
					local boost = 1;
					--Add in the value boosted by all talents
					if ( ( curHeal.talents ) and CastOptions.TalentData ) then
						for curTalent in curHeal.talents do
							if ( CastOptions.TalentData[curHeal.talents[curTalent].texture] and ( CastOptions.TalentData[curHeal.talents[curTalent].texture] > 0 ) ) then
								boost = boost + ( curHeal.talents[curTalent].boost * CastOptions.TalentData[curHeal.talents[curTalent].texture] );
							end
						end
					end
					--Keep lowering the rank until we find one that heals for less than the needed life
					while ( curHeal.ranks[castRank - 1] and ( ( curHeal.ranks[castRank] * boost ) > targetHealth ) and ( ( curHeal.ranks[castRank - 1] * boost ) >= targetHealth ) and ( castRank > 1 ) ) do
						castRank = castRank - 1;
					end
				else
					--We didn't find the requested rank, so pop out an error
					Sea.io.printc(ChatTypeInfo["SYSTEM"], "ERROR: Spell rank "..castRank.." not found for "..spellName..", please contact "..CastOptions.MAINTAINER);
				end
			end
		end
		return castRank;
	end
	return spellRank;
end

--[[ Gets the rank that we should be casting the spell at ]]--
CastOptions.GetCastRank = function (unit, spellName, spellRank, texture)
	local _, pClass = UnitClass("player");
	--Default the new rank to the normal rank
	local newRank = spellRank;
	if (	( CastOptions_Config.SmartRank == 1 ) and spellName and spellRank and texture and pClass and
				UnitExists(unit) and UnitIsFriend("player", unit) and (not UnitCanAttack("player", unit) ) ) then
		--if there is a buff entry for this spell, and the target isn't the player, then check to see if we need to cast a lower rank
		if ( ( UnitName(unit) ~= UnitName("player") ) and CastOptions.SpellData.Ranks[pClass][texture] ) then
			--See if we need to cast at a lower rank
			newRank = CastOptions.GetRank(unit, spellName, spellRank, texture);
		end

		--See if we should cast at a lower rank if the spell is a healing spell
		if (not newRank) then
			newRank = spellRank;
		end
		newRank = CastOptions.GetHealRank(unit, spellName, newRank, texture);
	end
	--Return the cast rank
	return newRank;
end

--[[ Returns true if this spell either requires no range check, or passes a range check ]]--
CastOptions.SpellHasRange = function (texture, spellName)
	--Get the player class
	local _, pClass = UnitClass("player");
	--Make sure we have a texture that matches a spell
	if (texture and spellName and CastOptions.SpellData.Player[spellName] and CastOptions.SpellData.Self[pClass] and CastOptions.SpellData.Self[pClass][texture] and CastOptions.SpellData.Self[pClass][texture].r) then
		--Get the ID of this spell
		local spellID = CastOptions.SpellData.Player[spellName];
		--Setup the tooltip with this spell
		CastOptionsTooltip:SetSpell(spellID, BOOKTYPE_SPELL);
		local tip = MCom.wow.tooltip.get("CastOptionsTooltip", 2, "right");
		--If the tooltip has a range string, then this spell can target
		if ( tip and ( tip ~= "" ) ) then
			return true;
		end
		return false;
	end
	return true;
end

--[[ Allows casting a spell by a name from scripts ]]--
CastOptions.DoCastSpellByName = function (spellname)
	--Make sure we have the spell data
	if (not CastOptions.SpellData.Player) then
		CastOptions.GetSpellInfo();
	end
	--if the spell is found then cast it
	if CastOptions.SpellData.Player[spellname] then
		MCom.callHook("CastSpell", CastOptions.SpellData.Player[spellname], BOOKTYPE_SPELL);
	elseif CastOptions.SpellData.Pet[spellname] then
		MCom.callHook("CastSpell", CastOptions.SpellData.Pet[spellname], BOOKTYPE_PET);
	else
		Sea.io.dprint("ERROR: Attempt to cast non-existent spell");
	end
end

--[[ Makes a table of all the spells a player and their pet can cast ]]--
CastOptions.GetSpellInfo = function ()
	--Clear/Create the player spells table
	CastOptions.SpellData.Player = {};
	
	local index = 1;	--The current index in the spell book
	local spellname, spellrank;	--The current spells name and rank
	local texture;  --The current spells rank
	--Go through all the spells in the players spellbook
	repeat
		--Get the spell name and rank
		spellname, spellrank = GetSpellName(index, BOOKTYPE_SPELL);
		--Get the spell texture
		spellname, spellrank = GetSpellName(index, BOOKTYPE_SPELL);
		texture = GetSpellTexture(index, BOOKTYPE_SPELL);
		--Make sure we have the spells name, otherwise we've gone through all spells
		if (spellname) then
			--if we have a rank for this spell, then make a ranked spell entry for it
			if (spellrank) then
				CastOptions.SpellData.Player[spellname.."("..spellrank..")"] = index;
			end
			--Make a non ranked spell entry to the highest rank of the spell
			CastOptions.SpellData.Player[spellname] = index;
			if (texture) then
				--Make a texture based spell entry to the highest rank of the spell
				CastOptions.SpellData.Player[texture] = index;
			end
		end
		index = index + 1;
	until (spellname == nil)
	
	--Clear/Create the pet spells table
	CastOptions.SpellData.Pet = {};
	
	--Make sure the pet has spells
	if ( not HasPetSpells() ) then
		return;
	end
	
	index = 1;	--Reset the index
	--Go through all the spells in the pets spellbook
	repeat
		--Get the spell name and rank
		spellname, spellrank = GetSpellName(index, BOOKTYPE_PET);
		texture = GetSpellTexture(index, BOOKTYPE_SPELL);
		--Make sure we have the spells name, otherwise we've gone through all spells
		if (spellname) then
			--if we have a rank for this spell, then make a ranked spell entry for it
			if (spellrank) then
				CastOptions.SpellData.Pet[spellname.."("..spellrank..")"] = index;
			end
			--Make a non ranked spell entry to the highest rank of the spell
			CastOptions.SpellData.Pet[spellname] = index;
			if (texture) then
				--Make a texture based spell entry to the highest rank of the spell
				CastOptions.SpellData.Pet[texture] = index;
			end
		end
		index = index + 1;
	until (spellname == nil)
end

--[[ Gets the textures and ranks of the players talents ]]--
CastOptions.GetTalentInfo = function ()
	--If we dont have a talent data table yet, then make one
	if ( not CastOptions.TalentData ) then
		CastOptions.TalentData = {};
	end

	--Clear the table
	for curEntry in CastOptions.TalentData do
		CastOptions.TalentData[curEntry] = nil;
	end

	--Get all the talents
	local iconTexture, rank;
	local maxTalents = 5;
	if ( MAX_TALENT_TABS ) then
		maxTalents = MAX_TALENT_TABS;
	end
	for curPage = 1, maxTalents do
		for curTalent = 1, GetNumTalents(curPage) do
			--Get Talent info
			_, iconTexture, _, _, rank = GetTalentInfo(curPage, curTalent);
			if (iconTexture and rank) then
				--Store the talent info in the table
				CastOptions.TalentData[iconTexture] = rank;
			end
		end
	end
end

--[[ Gets the name and link ID of any equipment buffing items in this bag ]]--
CastOptions.GetBagBuffs = function (bag)
	--If we don't have the bag info table yet, make it
	if ( not CastOptions.BagData ) then
		CastOptions.BagData = {};
	end
	--If this bag is not yet in our data, then add it
	if ( not CastOptions.BagData[bag] ) then
		CastOptions.BagData[bag] = {};
	end
	--Clear all entries for this bag
	for slot in CastOptions.BagData[bag] do
		CastOptions.BagData[bag][slot] = nil;
	end
	--Find the equipment buffs in this bag
	local curLink;
	for slot = 1, GetContainerNumSlots(bag) do
		--Get the link for the current item
		curLink = GetContainerItemLink(bag, slot);
		--Make sure there was something in the slot
		if (curLink) then
			--Make sure it is an equipment buff
			local _, _, slotLink = string.find(curLink, "Hitem:(.+):%d+%\124");
			if (slotLink) then
				for curBuff in CastOptions.SpellData.Equipment do
					if (slotLink == curBuff) then
						--Get the name of the item
						local _, _, curName = string.find(curLink, "%[(.+)%]");
						--Store this link for this item
						if (curName) then
							CastOptions.BagData[bag][curName] = curLink;
						end
						break;
					end
				end
			end
		end
	end
end

--[[
	Selects the target by name and or unit type
	
	Args:
		(string) name - the name of the unit to target
		(string) unit - the unit type to target, such as player, party1, raid1, etc..
		
		NOTE: Either name or unit can be passed.  If both are passed then it will first try
					to target by unit, and if that unit's name doesn't match name, then it will
					try a name search.
					
	Returns:
		true - if the unit was targeted
		false - if the unit was not targeted
]]--
CastOptions.TargetUnit = function (name, unit)
	--Get the current target so we can switch back to it, if we fail to find the right target
	local prevTarg = nil;
	if ( UnitExists("target") ) then
		prevTarg = UnitName("target");
	end
	--Make sure we have a name to work with
	if (name) then
		--If we already have the target, targeted then return true
		if ( UnitExists("target") and (UnitName("target") == name) ) then
			return true;
		end
		--If the passed unit has the same name, as name, then target it
		if ( unit and UnitExists(unit) and ( UnitName(unit) == name ) ) then
			TargetUnit(unit);
			--If the selected target is the one we wanted, then return true
			if ( UnitExists("target") and ( UnitName("target") == name ) ) then
				return true;
			end
		end
		--A list of targets that we have checked, if we end up checking the same target twice,
		--then we abort our search to avoid needless loops
		local targetList = {};
		--First search for friendly units, then hostile units
		for curType = 1, 2 do
			--Switch targets till we find out unit, if we check more than 100 units, then give up
			for curTry = 1, 100 do
				--Do the appropriate targeting type
				if (curType == 1) then
					TargetNearestFriend();
				else
					TargetNearestEnemy();
				end
				--If we failed to target anything then quit looking
				if ( UnitExists("target") and UnitName("target") ) then
					--If the unit we targeted is the one we wanted, then return true
					if (UnitName("target") == name) then
						return true;
					else
						--We didn't find the desired unit
						if (targetList[UnitName("target")]) then
							--If we've targeted this unit before, then stop looking
							break;
						else
							--Add this target to the list of checked targets
							targetList[UnitName("target")] = true;
						end
					end
				else
					break;
				end
			end
		end
	elseif ( unit and UnitExists(unit) ) then
		--If we don't have a name, but do have a unit type that exists, then target it
		TargetUnit(unit);
		return true;
	end
	--We failed to find the right target, so switch back to the previous one
	if (prevTarg) then
		if (CastOptions.TargetUnit(prevTarg)) then
			return false;
		end
	end
	--If we failed to switch back to the previous target, then target nothing
	ClearTarget();
	return false;
end

--[[ Checks the unit for the passed debuff type ]]--
CastOptions.CheckForDeBuff = function (unit, debuff)
	--Make sure the unit exists
	if ( unit and UnitExists(unit) ) then
		--Check all of the unit's debuffs for this type of debuff
		for index = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
			--If we have a debuff
			if ( UnitDebuff(unit, index) ) then
				--Setup the tooltip with the debuff info
				CastOptionsTooltip:SetUnitDebuff(unit, index);
				local tip = MCom.wow.tooltip.get("CastOptionsTooltip", 1, "right");
				--If the top right of the tooltip is the passed debuff, then return true
				if ( tip and ( tip == debuff ) ) then
					return true;
				end
			end
		end
	end
	return false;
end

--[[ Checks the target unit for a buff called spellName ]]--
CastOptions.CheckForBuff = function (unit, spellName, buffTexture)
	--Make sure the unit exists
	if ( unit and UnitExists(unit) ) then
		--Check all of the unit's buffs for the passed buff
		for index = 1, MAX_PARTY_TOOLTIP_BUFFS do
			--If we have a buff
			local buff = UnitBuff(unit, index);
			if ( buff ) then
				--If the buff's texture matches the passed buff texture, then return true
				if (buff == buffTexture) then
					return true;
				end				
				--Setup the tooltip with the buff info
				CastOptionsTooltip:SetUnitBuff(unit, index);
				local tip = MCom.wow.tooltip.get("CastOptionsTooltip", 1, "left");
				--If the top left of the tooltip is the passed spellname, then return true
				if ( tip and ( tip == spellName ) ) then
					return true;
				end
			end
		end
	end
	return false;
end

--[[ Returns true if mana control is disabled, or the target is elligable for the mana spell, or the spell isn't a mana spell ]]--
CastOptions.ManaTest = function (unit, texture)
	if ( ( CastOptions.ManaControl == 1 ) ) then
		local localSelfCast = CastOptions.GetSelfTable();
		if ( texture and localSelfCast and localSelfCast[texture] and localSelfCast[texture].n and ( UnitPowerType(unit) ~= 0 ) ) then
			return false;
		end
	end
	return true;
end

--[[ Tells if the target unit can receive this spell level wise ]]--
CastOptions.CanReceiveSpell = function (unit, spellName, texture, spellRank)
	--Get the player class
	local _, pClass = UnitClass("player");
	--Make sure we have the needed data, and that the unit exists
	if ( unit and UnitExists(unit) and texture and spellRank ) then
		--Get the unit's level
		local tLevel = UnitLevel(unit);
		--If SmartRanking is not enabled, then check the spell at this rank
		if (CastOptions_Config.SmartRank ~= 1) then
			if (CastOptions.SpellData.Ranks[pClass][texture] and spellRank and ( spellRank > 0 ) and CastOptions.SpellData.Ranks[pClass][texture][spellRank] and ( ( CastOptions.SpellData.Ranks[pClass][texture][spellRank] - 10 ) > tLevel ) ) then
				--If no suitable rank was found, then return false
				return false;
			end
		else
			--Get the smart ranked rank
			local newRank = CastOptions.GetRank(unit, spellName, spellRank, texture);
			if (CastOptions.SpellData.Ranks[pClass][texture] and newRank and ( newRank > 0 ) and CastOptions.SpellData.Ranks[pClass][texture][newRank] and ( ( CastOptions.SpellData.Ranks[pClass][texture][newRank] - 10 ) > tLevel ) ) then
				--If no suitable rank was found, then return false
				return false;
			end
		end
	end
	return true;
end

--[[ Checks to see if this unit has had this buff cast on them longer ago than the current unit ]]--
CastOptions.CheckBuffTime = function (unit, curUnit, spellName)
	--Make sure we have all the data we need, and can get the bufftime table for this spell
	if ( unit and curUnit and spellName and CastOptions.recentCasts ) then
		--Get the names of the units
		local unitName = UnitName(unit);
		local curUnitName = UnitName(curUnit);

		--If we have the names of these unit's and and their buff times, then see if the new unit's time is newer
		if (	unitName and curUnitName and CastOptions.recentCasts[unitName] and CastOptions.recentCasts[unitName][spellName] and
					CastOptions.recentCasts[curUnitName] and CastOptions.recentCasts[curUnitName][spellName] ) then
			--See how long it has been since each unit last had the buff cast on them
			local unitTime = GetTime() - CastOptions.recentCasts[unitName][spellName];
			local curUnitTime = GetTime() - CastOptions.recentCasts[curUnitName][spellName];
			--If the new unit has had the buff cast on them more recently than the current unit, then return false
			if (unitTime <= curUnitTime) then
				return false;
			end
		elseif ( curUnitName and ( ( not CastOptions.recentCasts[curUnitName] ) or ( not CastOptions.recentCasts[curUnitName][spellName] ) ) ) then
			--If the current unit doesn't have a buff time, then consider it older
			return false;
		end
		return true;
	end
end

--[[ Checks to see if the unit is the most suitable for this spell ]]--
CastOptions.CheckCastUnit = function (unit, curUnit, health, mana, debuffs, buff, texture, spellName, spellRank, spellType, ignoreList)
	--Make sure we have all the needed info, and that the unit can receive this spell
	if (	unit and ( not ( ignoreList and ignoreList[unit] ) ) and UnitExists(unit) and SpellCanTargetUnit(unit) and
				CastOptions.CanReceiveSpell(unit, spellName, texture, spellRank) and ( not UnitIsDead(unit) ) and 
				( not UnitCanAttack("player", unit) ) and ( type(spellType) == "table" ) and ( UnitHealth(unit) > 0 ) and
				UnitIsVisible(unit) and CastOptions.ManaTest(unit, texture) ) then			
		--Get the player class
		local _, pClass = UnitClass("player");
		--Get the current unit name
		local curUnitName = UnitName(unit);
		--If this is a blessing then check if this unit is valid for the blessing
		local goodBless = true;
		local isBless = false;
		if ( ( CastOptions_Config.GroupBlessing == 1 ) and CastOptions.SpellData.Self[pClass] and CastOptions.SpellData.Self[pClass][texture] and CastOptions.SpellData.Self[pClass][texture].l ) then
			isBless = true;
			--If we are supposed to be checking blessing learning, then default goodBless to false
			goodBless = false;
			--If the blessing does have this player in its list, then set goodBless true
			if ( CastOptions_Config.blessingCasts and CastOptions_Config.blessingCasts[texture] and CastOptions_Config.blessingCasts[texture][curUnitName] ) then
				goodBless = true;
			end
		end

		--Only proceed if blessing requirements are met
		if (goodBless) then
			--Check to see if this spell has been cast on this char recently
			local tooSoon = false;
			if ( ( CastOptions_Config.RecastTime > 0 ) and curUnitName and (not isBless) ) then
				if ( CastOptions.recentCasts and CastOptions.recentCasts[curUnitName] and CastOptions.recentCasts[curUnitName][spellName] ) then
					if ( ( GetTime() - CastOptions.recentCasts[curUnitName][spellName] ) <= CastOptions_Config.RecastTime ) then
						tooSoon = true;
					end
				end
			end
	
			--If it isn't too soon to cast this spell on this char again yet, then go ahead and check it out
			if (not tooSoon) then
				local maxDeBuffs = 0;		--The total number of debuffs we check for for this spell
				local curDeBuffs = 0;		--The number of debuffs this character could have
				--For each type of debuff, increment the maxDeBuffs, and increment curDeBuffs if they have that DeBuff
				if (spellType.p) then
					maxDeBuffs = maxDeBuffs + 1;
					if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_POISEN) ) then
						curDeBuffs = curDeBuffs + 1;
					end
				end
				if (spellType.c) then
					maxDeBuffs = maxDeBuffs + 1;
					if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_CURSE) ) then
						curDeBuffs = curDeBuffs + 1;
					end
				end
				if (spellType.d) then
					maxDeBuffs = maxDeBuffs + 1;
					if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_DISEASE) ) then
						curDeBuffs = curDeBuffs + 1;
					end
				end
				if (spellType.m) then
					maxDeBuffs = maxDeBuffs + 1;
					if ( CastOptions.CheckForDeBuff(unit, CASTOPTIONS_DEBUFF_MAGIC) ) then
						curDeBuffs = curDeBuffs + 1;
					end
				end
				--Convert debuffs to a percentage
				curDeBuffs = (100 * curDeBuffs) / maxDeBuffs;
				
				--If this is a healing spell, and group healing is enabled, then check out healing
				if ( ( CastOptions_Config.GroupHeal == 1 ) and spellType.h and (not spellType.l) ) then
					--Get the players health as a percentage
					local curHealth = (100 * UnitHealth(unit)) / UnitHealthMax(unit);
					--If we have a buff with this heal then prefer players that dont already have the buff
					if (spellType.b) then
						--If we don't already have a unit, then simply check health
						if ( not curUnit ) then
							--If this player has lost any life, make them the current player to heal
							health = curHealth;
							buff = CastOptions.CheckForBuff(unit, spellName, buffTexture);
							curUnit = unit;
						else
							--If we have a unit set already, then compare this one, to that one
							if ( buff ) then
								--If the current one has the buff, then use this one, if it doesn't have the buff
								if ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) then
									health = curHealth;
									buff = false;
									curUnit = unit;
								elseif (curHealth < health) then
									--If this one also has the buff, then use it if this one has less life
									health = curHealth;
									buff = true;
									curUnit = unit;
								end
							elseif ( ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) and (curHealth < health) ) then
								--If the current one doesn't have a buff, then only replace it, if this one has less life
								health = curHealth;
								buff = false;
								curUnit = unit;
							end
						end
					elseif (curHealth < health) then
						--If there is no buff with this heal, then just compare health
						health = curHealth;
						curUnit = unit;
					end
				elseif ( ( CastOptions_Config.GroupMana == 1 ) and spellType.n and (not spellType.l) ) then
					--Make sure the current unit has a mana bar
					if ( UnitPowerType(unit) == 0 ) then
						--Get the players mana as a percentage
						local curMana = (100 * UnitMana(unit)) / UnitManaMax(unit);
						--If we have a buff with this mana spell then prefer players that dont already have the buff
						if (spellType.b) then
							--If we don't already have a unit, then simply check health
							if ( not curUnit ) then
								--If this player has lost any mana, make them the current player to cast at
								mana = curMana;
								buff = CastOptions.CheckForBuff(unit, spellName, buffTexture);
								curUnit = unit;
							else
								--If we have a unit set already, then compare this one, to that one
								if ( buff ) then
									--If the current one has the buff, then use this one, if it doesn't have the buff
									if ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) then
										mana = curMana;
										buff = false;
										curUnit = unit;
									elseif (curMana < mana) then
										--If this one also has the buff, then use it if this one has less mana
										mana = curMana;
										buff = true;
										curUnit = unit;
									end
								elseif ( ( not CastOptions.CheckForBuff(unit, spellName, buffTexture) ) and (curMana < mana) ) then
									--If the current one doesn't have a buff, then only replace it, if this one has less life
									mana = curMana;
									buff = false;
									curUnit = unit;
								end
							end
						elseif (curMana < mana) then
							--If there is no buff with this heal, then just compare health
							mana = curMana;
							curUnit = unit;
						end
					end
				elseif ( ( CastOptions_Config.GroupBuff == 1 ) and spellType.b ) then
					--If this is a buff spell, then find a player who doesn't have the buff
					local curHasBuff = CastOptions.CheckForBuff(unit, spellName, buffTexture);
					--If we don't already have a unit set, and this player doesn't have the buff yet, then set them as the target
					if ( not curUnit ) then
						if (not curHasBuff) then
							buff = false;
							debuffs = curDeBuffs;
							curUnit = unit;
						else
							--If the current and previous unit have the buff, then if this one was buffed less recently, nail it
							buff = true;
							debuffs = curDeBuffs;
							curUnit = unit;
						end
					elseif ( buff ) then
						if ( ( not curHasBuff ) or ( curDeBuffs > debuffs ) ) then
							--If the current unit has a buff and the new unit doesn't, or the new unit has better debuffs, then use the new unit
							buff = false;
							debuffs = curDeBuffs;
							curUnit = unit;
						elseif ( CastOptions.CheckBuffTime(unit, curUnit, spellName) ) then
							--If this unit has had this buff cast on them longer than the current unit, then replace the current unit
							buff = true;
							debuffs = curDeBuffs;
							curUnit = unit;
						end
					elseif ( ( not curHasBuff ) and ( curDeBuffs > debuffs ) ) then
						--If the current and new unit don't have the buff, and the new unit has more debuffs, then use the new one
						buff = false;
						debuffs = curDeBuffs;
						curUnit = unit;
					end
				elseif ( ( CastOptions_Config.GroupCure == 1 ) and ( maxDeBuffs > 0 ) ) then
					--If this is a curing spell, then use this unit if they have more debuffs to be nuked
					if ( curDeBuffs > debuffs ) then
						debuffs = curDeBuffs;
						curUnit = unit;
					end
				end
			end
		end
	end
	return curUnit, health, debuffs, buff;
end

--[[ Finds a unit to group cast on ]]--
CastOptions.FindCastUnit = function (texture, spellName, spellRank, spellType, ignoreList, firstUnit)
	local castUnit = nil;		--The unit to cast on
	local curHealth = 100;	--The current lowest health percentage
	local curMana = 100;		--The current lowest mana percentage
	local curDeBuffs = 0;		--The current debuff percentage
	local curBuff = false;	--Whether or not the current unit has the buff already
	--If the selected target is in the group, then consider it first
	if ( firstUnit and UnitExists(firstUnit) and CastOptions.UnitInGroup(firstUnit) ) then
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit(firstUnit, castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	--If the option is enabled, then check the player as a candidate
	if (CastOptions_Config.GroupSelf == 1) then
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("player", castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	--Check all party and raid members as candidates
	for index = 1, GetNumPartyMembers() do
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("party"..index, castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	for index = 1, GetNumRaidMembers() do
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("raid"..index, castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
	end
	--If the option is enabled, then check the group pets as candidates
	if (CastOptions_Config.GroupPets == 1) then
		--Check the player's pet as a candidate
		castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("pet", castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
		--Check the group's pets as candidates
		for index = 1, GetNumPartyMembers() do
			castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("partypet"..index, castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
		end
		for index = 1, GetNumRaidMembers() do
			castUnit, curHealth, curDeBuffs, curBuff = CastOptions.CheckCastUnit("raidpet"..index, castUnit, curHealth, curMana, curDeBuffs, curBuff, texture, spellName, spellRank, spellType, ignoreList);
		end
	end
	--Return the unit we decided on
	return castUnit;
end

--[[ Returns true if the passed unit is in the players group ]]--
CastOptions.UnitInGroup = function (target)
	--If the unit exists
	if ( target and UnitExists(target) and UnitName(target) ) then
		local name = UnitName(target);		--Get the units name
		--Check to see if it is the player
		if ( (CastOptions_Config.GroupSelf == 1) and (name == UnitName("player") ) ) then
			return true;
		end
		--Check to see if it is a party or raid member
		local curName = "party";
		for index = 1, GetNumPartyMembers() do
			if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
				return true;
			end
		end
		curName = "raid";
		for index = 1, GetNumRaidMembers() do
			if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
				return true;
			end
		end
		--If we are allowing pets, then check to see if it's anyones pet
		if (CastOptions_Config.GroupPets == 1) then
			--Check to see if it is the pet
			if ( UnitExists("pet") and (name == UnitName("pet") ) ) then
				return true;
			end
			--Check to see if it is one of the group's pets
			curName = "partypet";
			for index = 1, GetNumPartyMembers() do
				if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
					return true;
				end
			end
			curName = "raidpet";
			for index = 1, GetNumRaidMembers() do
				if ( UnitExists(curName..index) and ( name == UnitName(curName..index) ) ) then
					return true;
				end
			end
		end
	end
	--If we didn't find the unit as any of the group members, then return false
	return false;
end

--[[ If the current target has a unit type this will return it ]]--
CastOptions.GetUnitType = function ()
	local unit = nil;
	--Only proceed if the target is friendly
	if ( UnitExists("target") and UnitIsFriend("player", "target") ) then
		--Get the name of the friend that is currently targeted
		local friendName = UnitName("target");
		--Only proceed if we don't have ourselves targeted
		if (friendName ~= UnitName("player")) then
			--Check to see if the target is one of the party members
			if (not unit) then
				for i = 1, GetNumPartyMembers() do
					if ( UnitExists("party"..i) and (UnitName("party"..i) == friendName) ) then
						unit = "party"..i;
						break;
					end
				end
			end
			--Check to see if the target is one of the raid members
			if (not unit) then
				for i = 1, GetNumRaidMembers() do
					if ( UnitExists("raid"..i) and (UnitName("raid"..i) == friendName) ) then
						unit = "raid"..i;
						break;
					end
				end
			end
			--Check to see if it is anyones pet
			if (not unit) then
				if ( UnitExists("pet") and (UnitName("pet") == friendName) ) then
					unit = "pet";
				end
			end
			if (not unit) then
				for i = 1, GetNumPartyMembers() do
					if ( UnitExists("partypet"..i) and (UnitName("partypet"..i) == friendName) ) then
						unit = "partypet"..i;
						break;
					end
				end
			end
			if (not unit) then
				for i = 1, GetNumRaidMembers() do
					if ( UnitExists("raidpet"..i) and (UnitName("raidpet"..i) == friendName) ) then
						unit = "raidpet"..i;
						break;
					end
				end
			end
		else
			--We have ourselves targeted
			unit = "player";
		end
	end
	return unit;
end

--[[ Checks to see if any of the units debuffs match this texture ]]--
CastOptions.CheckForDeBuffTex = function (unit, texture)
	--Make sure the unit exists
	if ( unit and UnitExists(unit) and texture ) then
		--Check all of the unit's debuffs for this debuff
		for index = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
			--If we have a debuff
			local debuff = UnitDebuff(unit, index);
			if ( debuff == texture ) then
				return true;
			end
		end
	end
	return false;
end

--[[ Checks the unit for any binding type debuffs ]]--
CastOptions.CheckForBound = function (unit)
	--Make sure the unit exists
	if ( ( CastOptions_Config.NoBoundCast == 1 ) and unit and UnitExists(unit) ) then
		--Check all of the unit's debuffs for a boinding debuff
		for index = 1, MAX_PARTY_TOOLTIP_DEBUFFS do
			--If we have a debuff
			local debuff = UnitDebuff(unit, index);
			if ( debuff ) then
				local bindInfo = CastOptions.SpellData.Bindings[debuff];
				if (bindInfo) then
					local isValid = true;
					if (bindInfo.n or bindInfo.d) then
						--Setup the tooltip with the debuff info
						CastOptionsTooltip:SetUnitDebuff(unit, index);
						if (bindInfo.n) then
							--Get the first tooltip
							local tip = MCom.wow.tooltip.get("CastOptionsTooltip", 1, "left");
							--If the top left of the tooltip is not the name specified, then go on to the next debuff
							if ( tip ~= bindInfo.n ) then
								isValid = false;
							end
						end
						--If this must have, or must not have, a digit in the seccond left tooltip, then check for one
						if (bindInfo.d) then
							--Get the second tooltip
							local tip = MCom.wow.tooltip.get("CastOptionsTooltip", 2, "left");
							if ( tip ) then
								--If it must not have a digit, but does, then it is not valid
								if (bindInfo.d == 0) then
									if ( string.find( tip, "%d" ) ) then
										isValid = false;
									end
								elseif (bindInfo.d == 1) then
									--If it must have a digit, but does not, then it is not valid
									if ( not string.find( tip, "%d" ) ) then
										isValid = false;
									end
								end
							end
						end
					end
					--Only continue if this is validified as the right debuff
					if (isValid) then
						if ( bindInfo.p and ( CastOptions_Config.BoundPotential == 1 ) ) then
							return true;
						end
						if ( bindInfo.a and ( CastOptions_Config.BoundAttack == 1 ) ) then
							return true;
						end
						if ( ( not bindInfo.a ) and ( not bindInfo.p ) ) then
							return true;
						end
					end
				end
			end
		end
	end
	return false;
end

--[[ If the spell is hostile, and the target is bound, will return true ]]--
CastOptions.SpellBound = function (texture, isHostile)
	--Initialize the bound spells table
	if (not CastOptions.SpellData.BoundSpells) then
		CastOptions.SpellData.BoundSpells = {};
	end
	--If we are going to be casting the origional spell, don't do so if the unit is mean and bound, if the option is enabled
	if (	texture and ( not CastOptions.CheckForDeBuffTex("target", texture) ) and UnitExists("target") and UnitCanAttack("player", "target") and
				CastOptions.CheckForBound("target") and isHostile[texture] ) then
		if (	( not CastOptions.SpellData.BoundSpells[texture] ) or
					(CastOptions.SpellData.BoundSpells[texture] and ( ( GetTime() - CastOptions.SpellData.BoundSpells[texture] ) >= CastOptions_Config.BoundDelay ) ) ) then
			UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_BOUND, 1.0, 0.1, 0.1, 1.0, CastOptions.BOUND_HOLD_TIME);
			CastOptions.SpellData.BoundSpells[texture] = GetTime();
			return true;
		else
			--Make sure the spell is no longer bound
			CastOptions.SpellData.BoundSpells[texture] = nil;
		end
	elseif (texture) then
		--Make sure the spell is no longer bound
		CastOptions.SpellData.BoundSpells[texture] = nil;
	end
end

--[[ Checks to see if the spell is in an action slot, and returns the ID if it is ]]--
CastOptions.GetSpellActionID = function (spellName)
	--Make sure we have the spell name
	if ( spellName ) then
		--Check all of the action ID's
		for index = 1, CastOptions.MAX_ID do
			--If we have an action in the slot
			if ( HasAction(index) ) then
				--Setup the tooltip with the action info
				CastOptionsTooltip:SetAction(index);
				local tip = MCom.wow.tooltip.get("CastOptionsTooltip");
				--If the top left of the tooltip is the passed spellname, then return true
				if ( tip and ( tip == spellName ) ) then
					return index;
				end
			end
		end
	end
end

--[[ Stores the spell cast on the unit in the recent cast table ]]--
CastOptions.StoreRecentCast = function (unit, spellName, texture, selfCastList)
	if (	unit and UnitExists(unit) and spellName and UnitName(unit) and CastOptions.UnitInGroup(unit) and
				texture and selfCastList and selfCastList[texture] and UnitIsFriend("player", unit) ) then
		local curUnitName = UnitName(unit);
		--If we have a spell name, then add the spell to the recent cast list, for this unit
		if (curUnitName) then
			if (not CastOptions.recentCasts) then
				CastOptions.recentCasts = {};
			end
			if (not CastOptions.recentCasts[curUnitName])  then
				CastOptions.recentCasts[curUnitName] = {};
			end
			CastOptions.recentCasts[curUnitName][spellName] = GetTime();

			--Get the player class
			local _, pClass = UnitClass("player");
			--If this is a blessing, then add this player to that blessings list of players
			if ( CastOptions.SpellData.Self[pClass] and CastOptions.SpellData.Self[pClass][texture] and CastOptions.SpellData.Self[pClass][texture].l ) then
				if (not CastOptions_Config.blessingCasts) then
					CastOptions_Config.blessingCasts = {};
				end
				if (not CastOptions_Config.blessingCasts[texture])  then
					CastOptions_Config.blessingCasts[texture] = {};
				end
				--If the player is already in a blessings list, then remove it
				for curBless in CastOptions_Config.blessingCasts do
					if ( CastOptions_Config.blessingCasts[curBless][curUnitName] ) then
						CastOptions_Config.blessingCasts[curBless][curUnitName] = nil;
					end
				end
				--Add the player to the blessings list
				CastOptions_Config.blessingCasts[texture][curUnitName] = true;
			end
		end
	end
end

--[[ Returns true if the frame is visible and the mouse is over it ]]--
CastOptions.FrameHasMouse = function (frameName ,xPos, yPos)
	--Make sure a frame name was passed
	if (frameName) then
		--Get the frame itself
		local curFrame = getglobal(frameName);
		--Make sure we got the frame, and that it is visible
		if ( curFrame and curFrame:IsVisible() ) then
			--If the mouse position was not passed, then lets get it ourself
			if ( (not xPos) or (not yPos) ) then
				xPos, yPos = GetCursorPosition();
			end

			--Get the scale of the frame
			local scale = curFrame:GetScale();
			--Make sure we have the scale
			if (scale) then
				--Scale the mouse coordinates
				xPos = xPos / scale;
				yPos = yPos / scale;
				--Get the frame edges
				local left = curFrame:GetLeft();
				local right = curFrame:GetRight();
				local top = curFrame:GetTop();
				local bottom = curFrame:GetBottom();
				--Make sure we have all of the frame edges
				if (left and right and top and bottom) then
					--If the mouse is over the frame, then return true
					if ( ( ( xPos >= left ) and ( xPos < right ) ) and ( ( yPos >= bottom ) and ( yPos <= top ) ) ) then
						return true;
					end
				end
			end
		end
	end
end

--[[ Returns true if appropriate keys are pressed to force aimed cast ]]--
CastOptions.AimedKeysDown = function ()
	--When the right conditions are met return to true to indicate spells should be aimed cast
	if ( CastOptions.Aimed == 1 ) then
		return true;
	elseif ( IsAltKeyDown() and ( CastOptions_Config.AimedAlt == 1) ) then
		return true;
	elseif ( IsShiftKeyDown() and ( CastOptions_Config.AimedShift == 1) ) then
		return true;
	elseif ( IsControlKeyDown() and ( CastOptions_Config.AimedCtrl == 1) ) then
		return true;
	else
		--Nothing indicates that this should be aimed cast so return false
		return false;
	end
end

--[[ Gets the unit aimed at by the mouse ]]--
CastOptions.GetAimedUnit = function (texture, localSelfCast, localHostileCast, attack)
	--Only return a unit if aimed casting is enabled, and this is a friendly spell
	if ( ( (CastOptions_Config.AimedCast == 1) or CastOptions.AimedKeysDown() ) and ( ( CastOptions_Config.AimedHostile == 1 ) or ( texture and localSelfCast[texture] ) ) ) then
		--Default to no target
		local target;
		--If world frame aiming is enabled, then if a unit is aimed at, then cast the spell at it
		if ( ( CastOptions_Config.AimedWorld == 1 ) and UnitExists("mouseover") ) then
			target = "mouseover";
		end

		--Get the cursor position now, so we don't have to do it for every frame
		local xPos, yPos = GetCursorPosition();

		--See if the mouse is over the pet frame
		if ( CastOptions.FrameHasMouse("PetFrame", xPos, yPos) ) then
			target = "pet";
		end
		--See if the mouse is over any of the party members pet frame
		for curPet = 1, GetNumPartyMembers() do
			if ( CastOptions.FrameHasMouse("PartyMemberFrame"..curPet.."PetFrame", xPos, yPos) ) then
				target = "partypet"..curPet;
			end
		end
		--See if the mouse is over the player frame
		if ( CastOptions.FrameHasMouse("PlayerFrame", xPos, yPos) ) then
			target = "player";
		end
		--See if the mouse is over any of the party members frames
		for curParty = 1, GetNumPartyMembers() do
			if ( CastOptions.FrameHasMouse("PartyMemberFrame"..curParty, xPos, yPos) ) then
				target = "party"..curParty;
			end
		end

		--Check that the target is valid
		if (target and ( texture or attack ) ) then
			if (attack) then
				--If it is an attack, then return the target
				return target;
			elseif ( localSelfCast[texture] ) then
				--If the spell is friendly only return the target if the target is friendly, and passes other qualifications
				if (	( ( not UnitCanAttack("player", target) ) and ( ( not localSelfCast[texture].g ) or ( localSelfCast[texture].g and CastOptions.UnitInGroup("target") ) )
							and CastOptions.ManaTest(target, texture) ) or ( localHostileCast[texture] and UnitCanAttack("player", target) ) ) then
					return target;
				end
			elseif ( UnitCanAttack("player", target) or ( CastOptions_Config.SmartAssist == 1 ) ) then
				--If the spell is not friendly then only return the target if the target is not friendly
				return target;
			end
		end
	end
end

--[[
	Casts a spell at a lower rank if needed
	
	Args:
		(string) spellName - The name of the spell to cast
		(string) spellRank - The rank of the spell to cast
		(string) texture - The tecture of the spell to cast
		
	Returns:
		true - The spell was cast at a different rank than passed
		false - The spell was not cast at a different rank than passed
]]--
CastOptions.RankCast = function (spellName, spellRank, texture)
	local newRank = CastOptions.GetCastRank("target", spellName, spellRank, texture);

	--if we need to cast a lower rank then do so
	if (newRank and (newRank ~= spellRank)) then
		CastOptions.DoCastSpellByName(spellName.."("..CASTOPTIONS_RANK.." "..newRank..")");
		return true;
	end
	return false;
end

--[[ Casts the passed spell at the passed unit ]]--
CastOptions.CastAtUnit = function (unit, byName, bookType, container, spell, number, onSelf, localSelfCast, spellName, spellRank, texture)
	local _, pClass = UnitClass("player");
	local castSelf = nil;
	if ( ( onSelf == 1 ) or ( unit == "player" ) ) then
		castSelf = 1;
	end
	
	--Only cast if the target exists
	if ( UnitExists(unit) ) then
		local clearedTarget = nil;
		local targtedHostile = nil;
		if ( UnitIsFriend("player", unit) ) then
			if ( UnitExists("target") ) then
				--If the current target is friendly, or a hostile and the spell is dispel, then select no target, so we can get a targeting cursor
				if (	( UnitName(unit) ~= UnitName("target") ) and ( ( not UnitCanAttack("player", "target") ) or
							( pClass and ( pClass == "PRIEST" ) and texture == "Interface\\Icons\\Spell_Holy_DispelMagic" ) ) ) then
					ClearTarget();
					clearedTarget = true;
				end
			end
		else
			--If the target unit is not a friend, then we have to target it first
			TargetUnit(unit);
			targtedHostile = true;
		end
		
		--If we need to lower the rank of the spell, then do so now
		local doneCast = nil;
		if ( ( CastOptions_Config.SmartRank == 1 ) and spellName and spellRank and pClass and texture ) then
			--if we need to cast a lower rank then do so
			local newRank = CastOptions.GetCastRank(unit, spellName, spellRank, texture);
			if ( newRank and (newRank ~= spellRank) ) then
				CastOptions.DoCastSpellByName(spellName.."("..CASTOPTIONS_RANK.." "..newRank..")");
				doneCast = true;
			end
		end

		if (not doneCast) then
			--Begin casting the spell
			CastOptions.DoCast(byName, bookType, container, spell, number, castSelf);
		end

		--If we had targeted a hostile unit, then return to the prvious target
		if (targtedHostile) then
			TargetLastTarget();
		else
			if (SpellIsTargeting()) then
				--Record this spell cast, if the spell is actually going to hit the target
				if ( SpellCanTargetUnit(unit) ) then
					CastOptions.StoreRecentCast(unit, spellName, texture, localSelfCast);
				end

				--If the spell is waiting for a target, give it one
				SpellTargetUnit(unit);
			else
				--Record this spell cast
				CastOptions.StoreRecentCast(unit, spellName, texture, localSelfCast);
			end

			--If we cleared the target early, then retarget now
			if (clearedTarget) then
				TargetLastTarget();
			end
		end
	else
		--If the desired unit does not exist, then give an error
		UIErrorsFrame:AddMessage(SPELL_FAILED_BAD_TARGETS, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
	end
end

--[[ Does the actual casting part of the casting function ]]--
CastOptions.DoCast = function (byName, bookType, container, spell, number, onSelf)
	--Cast the spell via appropriate mechanism
	if (byName) then
		--Cast by spell name
		CastOptions.DoCastSpellByName(spell);
	else
		if (not container) then
			if (not bookType) then
				--call the default handler
				MCom.callHook("UseAction", spell, number, onSelf);
			else
				--call the default handler
				MCom.callHook("CastSpell", spell, bookType);
			end
		else
			--call the default handler
			MCom.callHook("UseContainerItem", container, spell);
		end
	end

	--self cast by targeting ourself, if needed
	if( ( onSelf == 1 ) and SpellIsTargeting() ) then
		SpellTargetUnit("player");
	end
end

--[[ Does the actual casting procedure ]]--
CastOptions.Cast = function (byName, bookType, container, spell, number, onSelf, attack)
	--if we Cast Options is not enabled, or if we are holding something, then use the default handler
	if ( (CastOptions_Config.Enabled ~= 1) or (CastOptions.Holding == 1) ) then 
		return true;
	end
	--If we should call the origional this will become false
	local callOrig = true;
	--Make sure we have the spell data
	if (not CastOptions.SpellData.Player) then
		CastOptions.GetSpellInfo();
	end
	--Make sure we have the talent data
	if (not CastOptions.TalentData) then
		CastOptions.GetTalentInfo();
	end	
	
	--If this is by name and not coming from ChatFrame1, then don't proccess it
	local validCast = true;
	if ( byName ) then
		validCast = false;
		if ( this and ( this:GetName() == "ChatFrame1" ) ) then
			validCast = true;
		end
	end
	--If this is by book and not coming from SpellBookFrame, then don't proccess it
	if ( bookType ) then
		validCast = false;
		if ( this and this:GetParent() and ( this:GetParent():GetName() == "SpellBookFrame" ) ) then
			validCast = true;
		end
	end
	--If this is a macro, then don't proccess it
	if ( ( not byName ) and ( not bookType ) and ( not container ) and spell ) then
		--We identify this as a macro by seing if it has text, only macros have text
		local macroName = GetActionText(spell);
		if ( macroName and ( macroName ~= "" ) ) then
			validCast = false;
		end
	end

	--Make sure we have spell
	if ( attack or (spell and validCast) ) then
		--Get the self cast table
		local localSelfCast = CastOptions.GetSelfTable(container);
		--Get the hostile cast table
		local localHostileCast = CastOptions.GetHostileTable(container);
		
		local spellRank = nil;
		local spellName = nil;
		
		--If we are supposed to cast by name, then get the name from the passed spell name
		--otherwise get it from the tooltip
		if (byName) then
			--Find the rank portion of the spell name
			local nameStart, nameStop;
			nameEnd, _, spellRank = string.find(spell, CASTOPTIONS_RANK_PARSE);
			--Default the spell name to all of spell, incase we didn't find the rank portion
			spellName = spell;
			if (nameEnd) then
				spellName = string.sub(spell, 1, nameEnd - 1);
			end
			spellRank = tonumber(spellRank);
		elseif (not attack) then
			if (not container) then
				--If it's not a book spell, then get the action info
				if (not bookType) then
					--Setup the invisible cast options tooltip with the spell, so we can get info on the spell
					CastOptionsTooltip:SetAction(spell);
					local tip, tipRight = MCom.wow.tooltip.get("CastOptionsTooltip");
					
					--Make sure we have the info we need from the tooltip
					if (tip) then
						--Get the spell name
						spellName = tip;
		
						--Get the spell rank
						if ( tipRight and (tipRight ~= "") ) then
							local first, last;
							first, last, spellRank = string.find(tipRight, "[^%d]*(%d+)");
							spellRank = tonumber(spellRank);
						end
					end
				else
					--Get the spell name and rank from the book
					spellName, spellRank = GetSpellName(spell, bookType);
					if (spellRank) then
						local _, _, spellRankNum = string.find(spellRank, "(%d+)");
						
						if (spellRankNum) then
							spellRank = tonumber(spellRankNum);
						end
					end
				end
			end
		end

		--Get the texture for the spell
		local texture = nil;
		--Only look up the texture if this isn't a simple attack
		if (not attack) then
			--If this isn't a container item then get the texture from the spell book
			if (not container) then
				--If the spell is passed by name, then look it up in the list
				if (byName) then
					if (spellName and CastOptions.SpellData.Player[spellName]) then
						texture = GetSpellTexture(CastOptions.SpellData.Player[spellName], BOOKTYPE_SPELL);
					end
				elseif (not bookType) then
					--If the spell is passed by action id, then get the texture from that
					texture = GetActionTexture(spell);
				else
					--If the spell is a spell book type, then get the texture from it
					texture = GetSpellTexture(spell, bookType);
				end
			else
				--Get the texture from the container slot
				texture = GetContainerItemInfo(container, spell);
			end
	
			--If enabled then print the spell texture
			if ( (CastOptions.Texture == 1) and texture) then
				Sea.io.print(texture);
			end
		end

		--Get the player class
		local _, pClass = UnitClass("player");

		--Only proceed if we havent just done a smart equipment buffing of an item
		if ( not CastOptions.UseSmartEquip(byName, bookType, container, spell, spellName) ) then
			--Cancel the wand if need be
			if (CastOptions_Config.CancelWand == 1) then
				--Get the wand texture, if there is one
				local rangedTexture = GetInventoryItemTexture("player", GetInventorySlotInfo("RangedSlot"));
				--If we are casting a wand, then stop doing so now
				if ( ( ( pClass == "MAGE" ) or ( pClass == "PRIEST" ) or ( pClass == "WARLOCK" ) ) and
							rangedTexture and CastOptions.SpellData.Player[rangedTexture] and ( texture ~= rangedTexture ) and
							CastOptions.IsAutoRepeating ) then
					--Get the wand spell ID
					local shootID = CastOptions.SpellData.Player[rangedTexture];
					--Get the name of the wand spell
					local shotName = GetSpellName(shootID, BOOKTYPE_SPELL);
					--If the wand action is in the action bar, get its ID
					local shootAID = CastOptions.GetSpellActionID(shotName);
					if (shootAID) then
						--Cast the wand action, to stop it
						MCom.callHook("UseAction", shootAID);
					else
						--Cast the wand spell, to stop it
						MCom.callHook("CastSpell", shootID, BOOKTYPE_SPELL);
					end
	
					--Let the user know that we canceled the wand shot
					if (CastOptions_Config.ShowCancelShot == 1) then
						UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_CANCELED_WAND, 1.0, 0.1, 0.1, 1.0, CastOptions.SHOT_CANCELED_HOLD_TIME);
					end
				end
			end

			--Cancel auto shot if need be
			if (CastOptions_Config.CancelShot == 1) then
				--Get the bow/gun texture, if there is one
				local rangedTexture = GetInventoryItemTexture("player", GetInventorySlotInfo("RangedSlot"));
				--If we are firing a ranged weapon, then stop doing so now
				if ( ( ( pClass == "HUNTER" ) or ( pClass == "ROGUE" ) or ( pClass == "WARRIOR" ) ) and
							rangedTexture and CastOptions.SpellData.Player[rangedTexture] and ( texture ~= rangedTexture ) and
							CastOptions.IsAutoRepeating and texture and localSelfCast and localSelfCast[texture] and localSelfCast[texture].f ) then
					--Get the auto shot spell ID
					local shootID = CastOptions.SpellData.Player[rangedTexture];
					--Get the name of the auto shot spell
					local shotName = GetSpellName(shootID, BOOKTYPE_SPELL);
					--If auto shot is in the action bar, get its ID
					local shootAID = CastOptions.GetSpellActionID(shotName);
					if (shootAID) then
						--Cast the auto shot action, to stop it
						MCom.callHook("UseAction", shootAID);
					else
						--Cast the auto shot spell, to stop it
						MCom.callHook("CastSpell", shootID, BOOKTYPE_SPELL);
					end

					--Let the user know that we canceled the auto shot
					if (CastOptions_Config.ShowCancelShot == 1) then
						UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_CANCELED_SHOT, 1.0, 0.1, 0.1, 1.0, CastOptions.SHOT_CANCELED_HOLD_TIME);
					end
				end
			end

			--If this spell requires checking for a range indicator to be sure it is the right spell, then check now
			local hasRange = true;
			if ( not CastOptions.SpellHasRange(texture, spellName) ) then
				hasRange = false;
			end
			if (hasRange) then
				--Get the aimed unit, if there is one
				local aimedUnit = CastOptions.GetAimedUnit(texture, localSelfCast, localHostileCast, attack);

				--Cast at the key targeted unit if there is one
				if ( ( not attack ) and ( CastOptions.AnyKeysDown() or ( onSelf == 1 ) ) ) then
					--Default to player as the target
					local curUnit = "player";
					local castSelf = 1;
					--If any of the other possible targets is selected, then use it instead
					for curTarg in CastOptions.Targ do
						if ( ( curTarg ~= "player" ) and ( CastOptions.Targ[curTarg] == 1 ) ) then
							curUnit = curTarg;
							castSelf = nil;
							break;
						end
					end

					--Cast the spell at the unit
					CastOptions.CastAtUnit(curUnit, byName, bookType, container, spell, number, castSelf, localSelfCast, spellName, spellRank, texture);

					--We cast our spell, so dont call the origional
					callOrig = false;
				elseif ( aimedUnit and ( not ( ( CastOptions_Config.SmartAssist == 1 ) and ( attack or localHostileCast[texture] ) and ( not UnitCanAttack("player", aimedUnit) ) ) ) ) then
					--If it is a normal attack, then attack the aimed unit
					if ( attack and UnitExists(aimedUnit) and UnitCanAttack("player", aimedUnit) ) then
						TargetUnit(aimedUnit);
					else
						--Cast the spell at the aimed unit, if there is one
						CastOptions.CastAtUnit(aimedUnit, byName, bookType, container, spell, number, onSelf, localSelfCast, spellName, spellRank, texture);
					end

					--We cast our spell, so dont call the origional
					callOrig = false;
				elseif (	texture and localSelfCast[texture] and CastOptions.UseGroup(texture) and
									( not ( (UnitExists("target") and UnitCanAttack("player", "target") and UnitIsFriend("player", "target") ) ) ) ) then
					--Cast this on the most elligable group member if it is a heal or a buff or a cure
					--Get the type of spell we are casting
					local spellType = localSelfCast[texture];

					--If there is a target, the get the name of it
					local clearedTarget = nil;
					local prevTarget = nil;
					if ( UnitExists("target") ) then
						--If the target is friendly, or a hostile and the spell is dispel, then select no target, so we can get a targeting cursor
						if ( ( not UnitCanAttack("player", "target") ) or ( pClass and ( pClass == "PRIEST" ) and texture == "Interface\\Icons\\Spell_Holy_DispelMagic" ) ) then
							prevTarget = CastOptions.GetUnitType();
							ClearTarget();
							clearedTarget = true;
						end
					end

					--Begin casting the spell
					CastOptions.DoCast(byName, bookType, container, spell, number);

					--Find the most eligable unit to cast on
					local curUnit = CastOptions.FindCastUnit(texture, spellName, spellRank, spellType, nil, prevTarget);

					if ( (not curUnit) and CastOptions.UseSmart(texture, localSelfCast) and CastOptions.SelfDispel(texture) ) then
						curUnit = "player";
					end

					if (curUnit) then
						--If we need to lower the rank of the spell, then do so now
						if ( ( CastOptions_Config.SmartRank == 1 ) and spellName and spellRank and pClass and texture ) then
							--if we need to cast a lower rank then do so
							local newRank = CastOptions.GetCastRank(curUnit, spellName, spellRank, texture);
							if (newRank and (newRank ~= spellRank)) then
								SpellStopTargeting();
								CastOptions.DoCastSpellByName(spellName.."("..CASTOPTIONS_RANK.." "..newRank..")");
							end
						end

						--Cast the spell at the unit
						if (SpellIsTargeting()) then
							SpellTargetUnit(curUnit);
						end
						if (CastOptions_Config.GroupTarget == 1) then
							--Target the unit
							TargetUnit(curUnit);
							clearedTarget = nil;
						end
						--Record this spell cast
						CastOptions.StoreRecentCast(curUnit, spellName, texture, localSelfCast);
					end

					if( SpellIsTargeting() ) then
						--If no target was found, then show an error
						UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_NOTARG, 1.0, 0.1, 0.1, 1.0, CastOptions.NOTARG_HOLD_TIME);
						--If the spell is still targeting, and we have spell canceling enabled, then cancel the spell now
						if ( CastOptions_Config.CancelSpell == 1 ) then
							SpellStopTargeting();
						end
					end

					--If we cleared the target early, then retarget now
					if (clearedTarget) then
						--If we didn't pick a target to cast at, but already had an elligible target
						--then when we retarget it, it will get cast at, but not selected, so we need
						--to target once for the cast, and again for the retargeting
						if ( SpellIsTargeting() ) then
							TargetLastTarget();
						end
						TargetLastTarget();
					end

					--We cast our spell, so dont call the origional
					callOrig = false;
				elseif ( texture and localSelfCast[texture] and CastOptions.UseSmart(texture, localSelfCast) and CastOptions.SelfDispel(texture) ) then
					--Smart Self Cast this if we should
					CastOptions.CastAtUnit("player", byName, bookType, container, spell, number, 1, localSelfCast, spellName, spellRank, texture);
					--CastOptions.DoCast(byName, bookType, container, spell, number, 1);
					--Record this spell cast
					CastOptions.StoreRecentCast("player", spellName, texture, localSelfCast);
					--We cast our spell, so dont call the origional
					callOrig = false;
				elseif ( CastOptions.RankCast(spellName, spellRank, texture) ) then
					--Record this spell cast
					CastOptions.StoreRecentCast("target", spellName, texture, localSelfCast);
					--If we have cast the spell at a lower rank, then don't do the default function
					callOrig = false;
				elseif ( (CastOptions_Config.SmartAssist == 1) and attack or ( texture and localHostileCast[texture] ) ) then
					--Use the aimed unit if there is one
					if (not aimedUnit) then
						aimedUnit = "target";
					end
					--If smart assist casting is enabled, and this spell is hostile, then do so now
					--Only proceed if the target is friendly
					if ( UnitExists(aimedUnit) and UnitIsFriend("player", aimedUnit) and (not UnitCanAttack("player", aimedUnit) ) ) then
						--Only proceed if we don't have ourselves targeted
						if ( UnitName(aimedUnit) ~= UnitName("player") ) then
							--Start by pointing at target, so we can look at targets target on first loop
							local curTarg = aimedUnit;
							local changedTarget = false;
							for count = 1, 100 do
								--Add target on the end
								curTarg = curTarg.."target";
								--If we've targeted a hostile, then try casting the hostile spell at it
								if ( UnitExists(curTarg) and UnitCanAttack("player", curTarg) ) then
									--Target the unit
									TargetUnit(curTarg);
									changedTarget = true;

									--Only cast if the target is not bound
									if ( ( not attack ) and ( not CastOptions.SpellBound(texture, localHostileCast) ) ) then
										CastOptions.DoCast(byName, bookType, container, spell, number);
										callOrig = false;
									end
									break;
								elseif (CastOptions_Config.ChainAssist ~= 1) then
									--If chain assist is off, then stop now
									break;
								end
							end
							--If we want to return to the friendly target, then do so now
							if ( (not attack) and changedTarget and ( CastOptions_Config.AssistTarget ~= 1) ) then
								TargetLastTarget();
							end
						end
					end
				end
			end
	
			--If we are going to be calling the origonal, but the spell is bound, don't call it
			if ( callOrig and CastOptions.SpellBound(texture, localHostileCast) ) then
				callOrig = false;
			end

			--If we are going to be calling the origonal, but the spell is a mana spell, and the target shouldn't be getting a mana spell, then don't call it
			if ( callOrig and ( not CastOptions.ManaTest("target", texture) ) ) then
				callOrig = false;
				UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_NOMANA, 1.0, 0.1, 0.1, 1.0, CastOptions.NOMANA_HOLD_TIME);
			end

			if (callOrig and not attack) then
				--Record this spell cast
				CastOptions.StoreRecentCast("target", spellName, texture, localSelfCast);
			end
		end
	end
	
	--call the default handler if neccisary
	return callOrig;
end

--[[ Saves the current configuration on a per realm/per character basis ]]--
CastOptions.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "CastOptions_Config";
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
CastOptions.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "CastOptions_Config";
		nonUIList = {};
	});
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------
function CastOptions.PlaceAction(id)
	AltSelfCast_Holding = 0;
end

function CastOptions.PickupAction(id)
	AltSelfCast_Holding = 1;
end

function CastOptions.UseAction(id, number, onSelf)
	--Cast the spell by id using CastOptions methods
	return CastOptions.Cast(false, nil, nil, id, number, onSelf);
end

function CastOptions.UseContainerItem(container, id)
	--Cast the container item by container and id using CastOptions methods
	return CastOptions.Cast(false, nil, container, id);
end

function CastOptions.CastSpell(id, bookType)
	--Cast the book spell by book type and id using CastOptions methods
	return CastOptions.Cast(false, bookType, nil, id);
end

function CastOptions.CastSpellByName(spell)
	--Trim off any trailing semicolons
	while ( string.sub( spell, -1 ) == ";" ) do
		spell = string.sub( spell, 1, string.len(spell) - 1 );
	end
	--Cast the spell by name using CastOptions methods
	if (CastOptions.Cast(true, nil, nil, spell)) then
		CastOptions.DoCastSpellByName(spell);
	end
end

function CastOptions.AttackTarget()
	--Retarget to targets target if smart assist is on
	CastOptions.Cast(nil, nil, nil, nil, nil, nil, true);
end

function CastOptions.CastPetAction(spell)
	--Retarget to targets target if smart assist is on
	local _, _, texture = GetPetActionInfo(spell);
	if (texture == "PET_ATTACK_TEXTURE") then
		CastOptions.Cast(nil, nil, nil, nil, nil, nil, true);
	end
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
CastOptions.OnEvent = function (event)
	--When the info on the spells change, we need to update our tables
	if (event == "SPELLS_CHANGED") then
		CastOptions.GetSpellInfo();
		CastOptions.GetTalentInfo();
	end
	--When the info on the talents change, we need to update our tables
	if (event == "CHARACTER_POINTS_CHANGED") then
		CastOptions.GetTalentInfo();
	end

	--If this is a wand casting or ranged auto shot, then record the state
	if (event == "START_AUTOREPEAT_SPELL") then
		CastOptions.IsAutoRepeating = true;
	end
	if (event == "STOP_AUTOREPEAT_SPELL") then
		CastOptions.IsAutoRepeating = nil;
	end

	--If this is a bag update, then find any items in the bag that buffs equipment
	if ( ( event == "BAG_UPDATE" ) and arg1 ) then
		CastOptions.GetBagBuffs(arg1);
	end
end;

CastOptions.OnVarsLoaded = function ()
	if (not CastOptions.ConfigLoaded) then
		CastOptions.ConfigLoaded = true;
		--Load the configuration
		CastOptions.LoadConfig();
		--Store the configuration for this character
		CastOptions.SaveConfig();

		--Update all the bag info
		for bag = 0,  NUM_CONTAINER_FRAMES do
			CastOptions.GetBagBuffs(bag);
		end
		--Update the spell and talent info
		CastOptions.GetSpellInfo();
		CastOptions.GetTalentInfo();
	end;
end

CastOptions.OnLoad = function ()
	--If AltSelfCast is around, then get out, and get out NOW!
	if (AltSelfCast_OnLoad) then
		UIErrorsFrame:AddMessage(CASTOPTIONS_ERROR_ASC, 1.0, 0.1, 0.1, 1.0, 30);
		Sea.io.printc({r=1;g=0;b=0;}, CASTOPTIONS_ERROR_ASC_INFO);
		PlaySoundFile("Sound\\interface\\Error.wav");
		CastOptions = nil;
		return;
	end

	if ( CastOptions.Initialized ~= 1) then
		--When the info on the spells change, we need to update our tables
		this:RegisterEvent("SPELLS_CHANGED");
		--When the info on the talent points change, we need to update our tables
		this:RegisterEvent("CHARACTER_POINTS_CHANGED");
		--Track wheater we are autorepeating or not
		this:RegisterEvent("START_AUTOREPEAT_SPELL");
		this:RegisterEvent("STOP_AUTOREPEAT_SPELL");
		--Track updates to the bags, so we can keep up with the item links of buffy items
		this:RegisterEvent("BAG_UPDATE");

		--Hook functions
		CastOptions.SetupHooks(1);

		--Register the configuration options
		CastOptions.Register();

		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(CastOptions.OnVarsLoaded);

		CastOptions.Initialized = 1;
	end
end;
