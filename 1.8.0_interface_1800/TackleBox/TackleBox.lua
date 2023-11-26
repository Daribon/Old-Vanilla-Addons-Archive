--[[
	Tackle Box
		Makes the fishermans life much easer.

	By: Mugendai
	Special Thanks:
		Sinaloit: Origional use of textures to determine fishing skill and equipment
		Aalny:	Origional use of ItemLink's to store/recognize equipment.  As well as
						a few tweaks and fixes.  Oh and the Shift click option.  Aalny did a
						fair amount of good work.
		Groll: For asking for the Easy Lure feature
	Contact: mugekun@gmail.com

	This mod assists the fisherman by making it easy to cast,
	and easy to switch to the fishing poles and back.
	When a fishing pole is equipped, right clicking will cause
	the player to cast their line.
	
	$Id: TackleBox.lua 2598 2005-10-11 21:16:25Z mugendai $
	$Rev: 2598 $
	$LastChangedBy: mugendai $
	$Date: 2005-10-11 16:16:25 -0500 (Tue, 11 Oct 2005) $
]]--

--------------------------------------------------
--
-- TackleBox Declaration
--
--------------------------------------------------
TackleBox = {
	--------------------------------------------------
	--
	-- Constants
	--
	--------------------------------------------------
	VERSION = 1.46;
	DOWNWAIT = 0.2;															--The mouse must be pressed and released in less time than this, to be considered a cast
	MACRO_BODY = "/tb switch";									--The macro to switch the tackle equipment
	GENERAL_TAB = 1;														--The tab number of the General Spell Tab
	
	--Fishing lures
	Lures = {
		6533,			--Aquadynamic Fish Attractor
		6532,			--Bright Baubles
		6811,			--Aquadynamic Fish Lens
		6530,			--Nightcrawlers
		6529			--Shiny Bauble
	};
	
	--------------------------------------------------
	--
	-- Member Variables
	--
	--------------------------------------------------
	DownTime = nil;	--The last time the mouse was clicked down
	FishID = nil;		--The ID in the spellbook of the fishing skill
}
--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
--Main Configuration variable
TackleBox_Config = {
	EasyCast = 0;					--Set to 1 if right clicking should cast the pole when it is equiped
	FastCast = 0;					--Set to 1 if the next cast should be immediately cast when right clicking the cork
	EasyLure = 0;					--Set to 1 if lures should be put on the pole when available
	MakeMacro = 1;				--Set to 1 if the switch macro should be created on startup
	Alt = 0;							--Set to 1 to require pressing of alt to easy cast
	Shift = 0;						--Set to 1 to require pressing of shift to easy cast
	Ctrl = 0;							--Set to 1 to require pressing of ctrl to easy cast
};
--Store this config for safe load
MCom.safeLoad("TackleBox_Config");

--------------------------------------------------
--
-- Private Functions
--
--------------------------------------------------
--[[ Gets the ID of the Fishing skill, and puts it in TackleBox.FishID ]]--
TackleBox.GetFishID = function ()
	--Default the fish ID to nil in case the player doesn't have the fishing skill
	TackleBox.FishID = nil;

	--Get the index of the first and last spell in the general tab
	local _, _, first, last = GetSpellTabInfo(TackleBox.GENERAL_TAB);
	
	--Loop through the spells in the General tab looking for the one with the texture of the fishing skill
	local spellTexture = nil;	--This will hold the texture for the current spell
	for curSpell = (first + 1), (first + last) do
		--Get the texture for this spell
		spellTexture = GetSpellTexture(curSpell, BOOKTYPE_SPELL);
		--If the spell has a texture that matches the fishing texture, then we found the skill
		--We use the texture as the identifier to avoid working the tooltip, and guarantee compatability between languages
		if (spellTexture and spellTexture == "Interface\\Icons\\Trade_Fishing") then
			--We found the spell, so store the ID for use, and leave our loop
			TackleBox.FishID = curSpell;
			break;
		end
	end
end

--[[ Returns the ID of the fishing skill, if one is not known yet, it will try to find it ]]--
TackleBox.CheckFishID = function ()
	if (not TackleBox.FishID) then
		TackleBox.GetFishID();
	end
	return TackleBox.FishID;
end

--[[ Gets the starting time of a cast ]]--
TackleBox.ThrowStart = function ()
	--Checks if ClickToMove is enabled, and if it is, then we temporarily disable it
	if ( GetCVar("autointeract") == "1" ) then
		--We set this so we know we disabled it, and can re-enable it later
		TackleBox.ClickToMove = true;
		--Turn off click to move
		SetCVar("autointeract", "0");
	end

	--If FastCast isn't on, and we right clicked while casting, then reset the timer so we don't try to throw again yet
	if ( TackleBox.luring or ( (TackleBox_Config.FastCast ~= 1) and TackleBox.casting ) ) then
		TackleBox.DownTime = 0;
	else
		--Get the current time
		TackleBox.DownTime = GetTime();
	end
end

--[[ Checks to see if the mouse has been released in short enough of a time to consider it a castable click, then casts if needed ]]--
TackleBox.ThrowStop = function ()
	--If down time is empty, then set it to 0
	if ( not TackleBox.DownTime ) then
		TackleBox.DownTime = 0;
	end
	--Calculate how long it has been beetween the mouse going down, and up
	local pressTime = GetTime() - TackleBox.DownTime;

	--If we have recorded a click, and it's been within the time considered a castable click, then cast
	if ( ( not SpellIsTargeting() ) and (TackleBox.DownTime > 0) and (TackleBox.DOWNWAIT >= pressTime) and TackleBox.CastKeysDown()) then
		--Either put a lure on the pole, or cast the line
		if ( not TackleBox.Lure() ) then
			CastSpell(TackleBox.FishID, BOOKTYPE_SPELL);
		end
	end
	
	--If we disabled ClickToMove, then we re-enable it here
	if (TackleBox.ClickToMove and ( GetCVar("autointeract") == "0" ) ) then
		--Turn ClickToMove back on
		SetCVar("autointeract", "1");
		--Clear our C2M variable
		TackleBox.ClickToMove = nil;
	end
end

--[[ Put's a Lure on the pole if the player has one, and needs one ]]--
TackleBox.Lure = function ()
	--If the pole is enchanted, that should mean it has a lure on it
	if ( ( TackleBox_Config.EasyLure == 1 ) and TackleBox.EquippedPole() and ( not GetWeaponEnchantInfo() ) ) then
		--Check for a lure in the bags, starting with the highest power one
		local bag, slot;
		for curLure = 1, table.getn(TackleBox.Lures) do
			--If we find this lure in the bag, then use it
			bag, slot = TackleBox.FindContainerItem(nil, "Hitem:"..TackleBox.Lures[curLure]..":");
			if (bag and slot) then
				--We need to temporarily disable the cant use item error, incase this item is too high of a level to use
				TackleBox.NoItemErr = true;
				--Temporarily disable error message sounds, incase this item is too high of a level to use
				local soundState = GetCVar("EnableErrorSpeech");
				if ( soundState == "1" ) then
					SetCVar("EnableErrorSpeech", 0);
				end
				--Try to use the item
				UseContainerItem(bag, slot);
				--Re-enable the cant use item error message
				TackleBox.NoItemErr = nil;
				--Re-enable error message sounds
				if ( soundState == "1" ) then
					SetCVar("EnableErrorSpeech", 1);
				end
				--If we have a targeting cursor, then we succesfully used the item
				if ( SpellIsTargeting() ) then
					--Apply the lure to the fishing pole
					PickupInventoryItem(TackleBox.slotID.mainHand);
					return true;
				end
			end
		end
	end
end

--[[ Returns true if appropriate keys are pressed to for easy casting ]]--
TackleBox.CastKeysDown = function ()
	--If none of the system buttons need to be pressed, then return true
	if ((TackleBox_Config.Alt ~= 1) and (TackleBox_Config.Shift ~= 1) and (TackleBox_Config.Ctrl ~= 1)) then
		return true;
	end
	
	--If any of the system keys require press to cast, and are being pressed, then return true
	if ( (TackleBox_Config.Alt == 1) and IsAltKeyDown() ) then
		return true;
	end
	if ( (TackleBox_Config.Shift == 1) and IsShiftKeyDown() ) then
		return true;
	end
	if ( (TackleBox_Config.Ctrl == 1) and IsControlKeyDown() ) then
		return true;
	end
	--Some requirement was not met, so return false
	return false;
end

--[[ Gets ItemLinks for the currently equipped gear ]]--
TackleBox.GetEquipped = function ()
	--Get the item link for each fishing related item
	local mainHand = GetInventoryItemLink("player", TackleBox.slotID.mainHand);
	local secondaryHand = GetInventoryItemLink("player", TackleBox.slotID.secondaryHand);
	local hat = GetInventoryItemLink("player", TackleBox.slotID.hat);
	local glove = GetInventoryItemLink("player", TackleBox.slotID.glove);
	local boots = GetInventoryItemLink("player", TackleBox.slotID.boots);
	return mainHand, secondaryHand, hat, glove, boots;
end

--[[ Checks to see if a fishing pole is equipped ]]--
TackleBox.EquippedPole = function ()
	--Get the main hand item texture
	local itemTexture = GetInventoryItemTexture("player", TackleBox.slotID.mainHand);
	--If there is infact an item in the main hand, and it's texture matches the fishing pole texture,
	--then we have a fishing pole
	if ( itemTexture and string.find(itemTexture, "INV_Fishingpole") ) then
		return true;
	end
end

--[[
	Looks through all the bags to find the item passed
	
	Args:
		(string) itemLink - an item link to search for the item by
		(string) linkExp - a regular expression to use to find the item, instead of itemLink
		
	Returns:
		(number) foundBag - the ID of the bag the item is in
		(number) foundSlot - the ID of the slot the item is in
]]--
TackleBox.FindContainerItem = function (itemLink, linkExp)
	--Only go through the trouble if an itemLink was passed
	if (itemLink or linkExp) then
		local curLink = nil;	--This will hold the link of the current item we are checking out
		--Go through all the bags
		for bag = 0, NUM_CONTAINER_FRAMES, 1 do
			--Go through all the slots in this bag
			for slot = 1, GetContainerNumSlots(bag) do
				--Get the link for the current item
				curLink = GetContainerItemLink(bag, slot);
				--Make sure there was something in the slot
				if (curLink) then
					--Only do a striaght check, if we dont have a link regular expression
					if (not linkExp) then
						--If the current item is the one we are looking for, then return the item position
						if (curLink == itemLink) then
							return bag, slot;
						end
					else
						--We have a link regular expression, so check by it
						if ( string.find(curLink, linkExp) ) then
							return bag, slot;
						end
					end
				end
			end
		end
	end
end

--[[
	Equips the item into the passed equipment slot
	
	Args:
		(string) itemLink - an item link to the item you want equiped
		(number) equipSlot - the ID of the equipment slot you want the item equipped in
]]--
TackleBox.Equip = function (itemLink, equipSlot)
	--If we are holding something, than this function can not work, so we quit, now
	if (CursorHasItem()) then
		--Consider this a failed equipping
		return false;
	end
	
	--If the item is already equipped, we shouldn't bother trying to equip it
	local curLink = GetInventoryItemLink("player", equipSlot);
	if (curLink == itemLink) then
		--Consider this a succesful equipping
		return true;
	end
	
	--Get the bag and slot of the item
	local bag, slot = TackleBox.FindContainerItem(itemLink);
	--If we got the bag and the slot of the item, then equip it
	if (bag and slot) then
		--Pickup the item to equip
		PickupContainerItem(bag, slot);
		--If a slot to equip it in was passed, then put it in that slot
		--otherwise let the game figure out which slot to put it in
		if (equipSlot) then
			PickupInventoryItem(equipSlot);
		else
			AutoEquipCursorItem();
		end
		--Consider this a succesful equipping
		return true;
	end
	--Consider this a failed equipping
	return false;
end

--[[
	Stores the passed item in the slot if not already there, and lets the user know
	
	Args:
		(string) itemVar - name of the Config variable to store the item in
		(string) itemLink - the item link to store
		(bool) shouldSave - returned if the item was stored
		(string) itemOutput - the string to print if the item is stored
		
	Returns:
		true - the item was stored
		shouldSave - the item was not stored
]]--
TackleBox.StoreItem = function (itemVar, itemLink, shouldSave, itemOutput)
	--If the item is already stored, don't bother
	if (TackleBox_Config[itemVar] ~= itemLink) then
		--Store the item
		TackleBox_Config[itemVar] = itemLink;
		--Let the user know the item was stored
		if (itemLink and itemOutput) then
			MCom.IO.printc(ChatTypeInfo["SYSTEM"], format(itemOutput, itemLink));
		end
		--We should save because the config has changed
		shouldSave = true;
	end
	return shouldSave;
end

--[[
	Switches the passed item into the equipment slot if not already there, and lets the user know
	if nothing is set in the slot
	
	Args:
		(string) itemVar - name of the Config variable to load the item from
		(string) itemSlot - the equipment slot to equip the item in to
		(bool) shouldSave - returned if the item was cleared
		(string) itemOutput - the string to print if there is no item equipped
		
	Returns:
		true - the item was cleared
		shouldSave - the item was not stored
]]--
TackleBox.SwitchItem = function (itemVar, itemSlot, shouldSave, itemOutput)
	--If we have a stored item, then equip it
	if (TackleBox_Config[itemVar]) then
		--Equip it, and if we fail to do so, then clear the item slot
		if (not TackleBox.Equip(TackleBox_Config[itemVar], itemSlot)) then
			TackleBox_Config[itemVar] = nil;
			--We cleared the slot, so we need to save
			shouldSave = true;
		end
	elseif (itemOutput) then
		--There was no item stored, so tell the user we need one
		MCom.IO.printc(ChatTypeInfo["SYSTEM"], itemOutput);
	end
	return shouldSave;
end

--[[ Switches from normal to fishing gear, or visa versa ]]--
--Support old switch command for compatability
TackleBox_Switch = function ()
	--Let user know to update the switch method
	MCom.IO.printc(ChatTypeInfo["SYSTEM"], "Warning: "..TACKLEBOX_OUTPUT_OLD_SWITCH_WARN);
	--Call proper function
	TackleBox.Switch();
end
TackleBox.Switch = function ()
	--Get the current equipment
	local mainHand, secondaryHand, hat, glove, boots = TackleBox.GetEquipped();
	local shouldSave = false;	--Set true if any equipment needs to be saved
	--If we have a fishing pole equiped then switch to normal, otherwise, switch to fishing
	if (TackleBox.EquippedPole()) then
		--Store our currently equipped gear as fishing gear
		shouldSave = TackleBox.StoreItem("UsePole", mainHand, shouldSave, TACKLEBOX_OUTPUT_SET_POLE);
		shouldSave = TackleBox.StoreItem("UseFishingHat", hat, shouldSave, TACKLEBOX_OUTPUT_SET_FISHING_HAT);
		shouldSave = TackleBox.StoreItem("UseFishingGlove", glove, shouldSave, TACKLEBOX_OUTPUT_SET_FISHING_GLOVE);
		shouldSave = TackleBox.StoreItem("UseFishingBoots", boots, shouldSave, TACKLEBOX_OUTPUT_SET_FISHING_BOOTS);

		--Switch to normal equipment
		shouldSave = TackleBox.SwitchItem("UseMainHand", TackleBox.slotID.mainHand, shouldSave, TACKLEBOX_OUTPUT_NEED_SET_HAND);
		shouldSave = TackleBox.SwitchItem("UseSecondaryHand", TackleBox.slotID.secondaryHand, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseHat", TackleBox.slotID.hat, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseGlove", TackleBox.slotID.glove, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseBoots", TackleBox.slotID.boots, shouldSave);
	else
		--Store our currently equipped gear as normal gear
		shouldSave = TackleBox.StoreItem("UseMainHand", mainHand, shouldSave, TACKLEBOX_OUTPUT_SET_MAIN);
		shouldSave = TackleBox.StoreItem("UseSecondaryHand", secondaryHand, shouldSave, TACKLEBOX_OUTPUT_SET_SECONDARY);
		shouldSave = TackleBox.StoreItem("UseHat", hat, shouldSave, TACKLEBOX_OUTPUT_SET_HAT);
		shouldSave = TackleBox.StoreItem("UseGlove", glove, shouldSave, TACKLEBOX_OUTPUT_SET_GLOVE);
		shouldSave = TackleBox.StoreItem("UseBoots", boots, shouldSave, TACKLEBOX_OUTPUT_SET_BOOTS);
		
		--Switch to fishing gear
		shouldSave = TackleBox.SwitchItem("UsePole", TackleBox.slotID.mainHand, shouldSave, TACKLEBOX_OUTPUT_NEED_SET_POLE);
		shouldSave = TackleBox.SwitchItem("UseFishingHat", TackleBox.slotID.hat, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseFishingGlove", TackleBox.slotID.glove, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseFishingBoots", TackleBox.slotID.boots, shouldSave);
	end
	--If we have changed the config, then save it
	if (shouldSave) then
		TackleBox.SaveConfig();
	end
end

--[[ Saves the current configuration on a per realm/per character basis ]]--
TackleBox.SaveConfig = function ()
	--Use MCom's save function to save the config
	MCom.saveConfig( {
		configVar = "TackleBox_Config";
		--Because we want to be able to clear out stored vars, we use the forced list
		forceList = {	"UseMainHand", "UseSecondaryHand", "UseHat", "UseGlove", "UseBoots",
									"UsePole", "UseFishingHat", "UseFishingGlove", "UseFishingBoots"	};
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
TackleBox.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "TackleBox_Config";
		uiList = {"EasyCast", "FastCast", "MakeMacro", "Alt", "Ctrl", "Shift"};
		--Because we want to be able to clear out stored vars, we use the forced list
		forceList = {	"UseMainHand", "UseSecondaryHand", "UseHat", "UseGlove", "UseBoots",
									"UsePole", "UseFishingHat", "UseFishingGlove", "UseFishingBoots"	};
	});
end

--[[ Creates a Macro for the switch function ]]--
TackleBox.MakeMacro = function ()
	if (TackleBox_Config.MakeMacro ~= 0) then
		--Get the number of macros
		local numMacros	= GetNumMacros();
		local name = nil;	--The name of the current macro
		local id = nil;		--The ID of the TackleBox macro
		local body = nil;	--Will be used to get the body of the macro
		--Go through all the macros to see if the TackleBox macro is already there
		for curMacro = 1, numMacros do
			--Get the name of the current macro
			name, _, body = GetMacroInfo(curMacro);
			--If this is the TackleBox macro, the store it's ID, and stop looking
			if (name == TACKLEBOX_MACRO_NAME) then
				--If there is more than one copy of the macro, delete the extras
				if (id) then
					if (body == TackleBox.MACRO_BODY) then
						DeleteMacro(curMacro);
					end
				else
					id = curMacro;
				end
			end
		end

		--If we found the TackleBox macro, then update it, otherwise, create it
		if (name and id) then
			EditMacro(id, TACKLEBOX_MACRO_NAME, 24, TackleBox.MACRO_BODY, 1);
		else
			CreateMacro(TACKLEBOX_MACRO_NAME, 24, TackleBox.MACRO_BODY, 1);
		end
	end
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------
TackleBox.TurnOrActionStart = function (arg1)
	--Only test for a throw if the options are enabled, and we have a fishing pole, and fishing
	if ( (TackleBox_Config.EasyCast == 1) and TackleBox.EquippedPole() and TackleBox.CheckFishID() ) then
		TackleBox.ThrowStart();
	end
end

TackleBox.TurnOrActionStop = function (arg1)
	--Only test for a throw if the options are enabled, and we have a fishing pole, and fishing
	if ( (TackleBox_Config.EasyCast == 1) and TackleBox.EquippedPole() and TackleBox.CheckFishID() ) then
		TackleBox.ThrowStop();
	end
end

TackleBox.UIErrorsFrame = { AddMessage = function ( _, msg )
	--If we should be hiding the cant use item error, then do so
	if (TackleBox.NoItemErr) then
		if (msg == ERR_CANT_USE_ITEM) then
			--We have the cant use item error, so abort
			return;
		end
	end
	--Call the origional
	return true;
end }

--Used to hook OnShow if MacroFrame is not loaded at start
TackleBox.MacroFrame_LoadUI = function ()
	--Make sure the addon is loaded
	if ( IsAddOnLoaded("Blizzard_MacroUI") ) then
		--Unhook the LoadUI hook
		MCom.util.unhook("MacroFrame_LoadUI", "TackleBox.MacroFrame_LoadUI", "after");

		--When opening the macro frame, make the macro if we should
		MCom.util.hook("MacroFrame_OnShow", "TackleBox.MakeMacro", "before");
	end
end

--------------------------------------------------
--
-- Event Handlers
--
--------------------------------------------------
TackleBox.OnEvent = function ()
	if ( event == "SPELLS_CHANGED" ) then
		--Get the ID of the fishing skill
		TackleBox.GetFishID();
	end
	--Keep up with whether or not we are casting
	if ( event == "SPELLCAST_CHANNEL_START" ) then
		TackleBox.casting = true;
	elseif ( ( event == "SPELLCAST_CHANNEL_UPDATE" ) and ( arg1 == 0 ) ) then
		TackleBox.casting = nil;
	end
	--Keep up with whether we are luring the line(or casting a normal spell) or not
	if ( event == "SPELLCAST_START" ) then
		TackleBox.luring = true;
	elseif ( ( event == "SPELLCAST_STOP" ) or ( event == "SPELLCAST_INTERRUPTED" ) or ( event == "SPELLCAST_FAILED" ) ) then
		TackleBox.luring = nil;
	end
end

TackleBox.OnVarsLoaded = function ()
	if (not TackleBox.ConfigLoaded) then
		TackleBox.ConfigLoaded = true;
		--Load the configuration
		TackleBox.LoadConfig();
		--Store the configuration for this character
		TackleBox.SaveConfig();
	end;
end

TackleBox.OnLoad = function ()
	if (TackleBox.Initialized ~= true) then
		--Don't initialize again
		TackleBox.Initialized = true;

		--Hook these functions as they are called when the right mouse button is pressed, and released
		MCom.util.hook("TurnOrActionStart", "TackleBox.TurnOrActionStart", "before");
		MCom.util.hook("TurnOrActionStop", "TackleBox.TurnOrActionStop", "after");
		--Hook this to prevent showing an error when trying to use a lure that is too high level
		MCom.util.hook("UIErrorsFrame.AddMessage", "TackleBox.UIErrorsFrame.AddMessage", "hide");
		--Hook the macro frame OnShow as the time to setup the TackleBox macro
		if ( IsAddOnLoaded("Blizzard_MacroUI") ) then
			--If the addon was loaded already, then hook the OnShow
			MCom.util.hook("MacroFrame_OnShow", "TackleBox.MakeMacro", "before");
		else
			--If the addon has not yet been loaded, then hook it's loader so we can hook OnShow after it loads
			MCom.util.hook("MacroFrame_LoadUI", "TackleBox.MacroFrame_LoadUI", "after");
		end

		--Get the equipment slot IDs that TackleBox needs
		TackleBox.slotID = {};
		TackleBox.slotID.mainHand = GetInventorySlotInfo("MainHandSlot");
		TackleBox.slotID.secondaryHand = GetInventorySlotInfo("SecondaryHandSlot");
		TackleBox.slotID.hat = GetInventorySlotInfo("HeadSlot");
		TackleBox.slotID.glove = GetInventorySlotInfo("HandsSlot");
		TackleBox.slotID.boots = GetInventorySlotInfo("FeetSlot");

		--Register the configuration options
		TackleBox.Register();

		--Register to keep up with the spells as they change, so we know the ID of fishing
		this:RegisterEvent( "SPELLS_CHANGED" );
		--Register to keep up with whether we are casting or not
		this:RegisterEvent("SPELLCAST_CHANNEL_START");
		this:RegisterEvent("SPELLCAST_CHANNEL_UPDATE");
		this:RegisterEvent("SPELLCAST_START");
		this:RegisterEvent("SPELLCAST_STOP");
		this:RegisterEvent("SPELLCAST_FAILED");
		this:RegisterEvent("SPELLCAST_INTERRUPTED");
		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(TackleBox.OnVarsLoaded);
	end
end
