--[[
	Tackle Box
		Makes the fishermans life much easer.

	By: Mugendai
	Special Thanks:
		Sinaloit: Origional use of textures to determine fishing skill and equipment
		Aalny:	Origional use of ItemLink's to store/recognize equipment.  As well as
						a few tweaks and fixes.  Oh and the Shift click option.  Aalny did a
						fair amount of good work.
	Contact: mugekun@gmail.com

	This mod assists the fisherman by making it easy to cast,
	and easy to switch to the fishing poles and back.
	When a fishing pole is equipped, right clicking will cause
	the player to cast their line.
	
	$Id: TackleBox.lua 2143 2005-07-17 05:28:41Z mugendai $
	$Rev: 2143 $
	$LastChangedBy: mugendai $
	$Date: 2005-07-17 00:28:41 -0500 (Sun, 17 Jul 2005) $
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
	VERSION = 1.2;
	DOWNWAIT = 0.2;															--The mouse must be pressed and released in less time than this, to be considered a cast
	MACRO_BODY = "/tb switch";									--The macro to switch the tackle equipment
	GENERAL_TAB = 1;														--The tab number of the General Spell Tab
	
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
TackleBox_Config = {};
TackleBox_Config.EasyCast = 0;					--Set to 1 if right clicking should cast the pole when it is equiped
TackleBox_Config.FastCast = 0;					--Set to 1 if the next cast should be immediately cast when right clicking the cork
TackleBox_Config.MakeMacro = 0;					--Set to 1 if the switch macro should be created on startup
TackleBox_Config.Alt = 0;								--Set to 1 to require pressing of alt to easy cast
TackleBox_Config.Shift = 0;							--Set to 1 to require pressing of shift to easy cast
TackleBox_Config.Ctrl = 0;							--Set to 1 to require pressing of ctrl to easy cast

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
	if ( (TackleBox_Config.FastCast ~= 1) and TackleBox.casting ) then
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
	if ((TackleBox.DownTime > 0) and (TackleBox.DOWNWAIT >= pressTime) and TackleBox.CastKeysDown()) then
		CastSpell(TackleBox.FishID, BOOKTYPE_SPELL);
	end
	
	--If we disabled ClickToMove, then we re-enable it here
	if (TackleBox.ClickToMove and ( GetCVar("autointeract") == "0" ) ) then
		--Turn ClickToMove back on
		SetCVar("autointeract", "1");
		--Clear our C2M variable
		TackleBox.ClickToMove = nil;
	end
end

--[[ Returns true if appropriate keys are pressed to for easy casting ]]--
function TackleBox.CastKeysDown()
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
	return mainHand, secondaryHand, hat, glove;
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
		
	Returns:
		(number) foundBag - the ID of the bag the item is in
		(number) foundSlot - the ID of the slot the item is in
]]--
TackleBox.FindContainerItem = function (itemLink)
	--Only go through the trouble if an itemLink was passed
	if (itemLink) then
		local curLink = nil;	--This will hold the link of the current item we are checking out
		--Go through all the bags
		for bag = 0, NUM_CONTAINER_FRAMES, 1 do
			--Go through all the slots in this bag
			for slot = 1, GetContainerNumSlots(bag) do
				--Get the link for the current item
				curLink = GetContainerItemLink(bag, slot);
				--If the current item is the one we are looking for, then return the item position
				if (curLink == itemLink) then
					return bag, slot;
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
			Sea.io.printc(ChatTypeInfo["SYSTEM"], format(itemOutput, itemLink));
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
		Sea.io.printc(ChatTypeInfo["SYSTEM"], itemOutput);
	end
	return shouldSave;
end

--[[ Switches from normal to fishing gear, or visa versa ]]--
--Support old switch command for compatability
TackleBox_Switch = function ()
	--Let user know to update the switch method
	Sea.io.printc(ChatTypeInfo["SYSTEM"], "Warning: "..TACKLEBOX_OUTPUT_OLD_SWITCH_WARN);
	--Call proper function
	TackleBox.Switch();
end
TackleBox.Switch = function ()
	--Get the current equipment
	local mainHand, secondaryHand, hat, glove = TackleBox.GetEquipped();
	local shouldSave = false;	--Set true if any equipment needs to be saved
	--If we have a fishing pole equiped then switch to normal, otherwise, switch to fishing
	if (TackleBox.EquippedPole()) then
		--Store our currently equipped gear as fishing gear
		shouldSave = TackleBox.StoreItem("UsePole", mainHand, shouldSave, TACKLEBOX_OUTPUT_SET_POLE);
		shouldSave = TackleBox.StoreItem("UseFishingHat", hat, shouldSave, TACKLEBOX_OUTPUT_SET_FISHING_HAT);
		shouldSave = TackleBox.StoreItem("UseFishingGlove", glove, shouldSave, TACKLEBOX_OUTPUT_SET_FISHING_GLOVE);

		--Switch to normal equipment
		shouldSave = TackleBox.SwitchItem("UseMainHand", TackleBox.slotID.mainHand, shouldSave, TACKLEBOX_OUTPUT_NEED_SET_HAND);
		shouldSave = TackleBox.SwitchItem("UseSecondaryHand", TackleBox.slotID.secondaryHand, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseHat", TackleBox.slotID.hat, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseGlove", TackleBox.slotID.glove, shouldSave);
	else
		--Store our currently equipped gear as normal gear
		shouldSave = TackleBox.StoreItem("UseMainHand", mainHand, shouldSave, TACKLEBOX_OUTPUT_SET_MAIN);
		shouldSave = TackleBox.StoreItem("UseSecondaryHand", secondaryHand, shouldSave, TACKLEBOX_OUTPUT_SET_SECONDARY);
		shouldSave = TackleBox.StoreItem("UseHat", hat, shouldSave, TACKLEBOX_OUTPUT_SET_HAT);
		shouldSave = TackleBox.StoreItem("UseGlove", glove, shouldSave, TACKLEBOX_OUTPUT_SET_GLOVE);
		
		--Switch to fishing gear
		shouldSave = TackleBox.SwitchItem("UsePole", TackleBox.slotID.mainHand, shouldSave, TACKLEBOX_OUTPUT_NEED_SET_POLE);
		shouldSave = TackleBox.SwitchItem("UseFishingHat", TackleBox.slotID.hat, shouldSave);
		shouldSave = TackleBox.SwitchItem("UseFishingGlove", TackleBox.slotID.glove, shouldSave);
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
		forceList = {	"UseMainHand", "UseSecondaryHand", "UseHat", "UseGlove",
									"UsePole", "UseFishingHat", "UseFishingGlove"	};
	});
end

--[[ Loads the current configuration from a per realm/per character variable set ]]--
TackleBox.LoadConfig = function ()
	--Use MCom's load function to load the config
	MCom.loadConfig( {
		configVar = "TackleBox_Config";
		uiList = {"EasyCast", "FastCast", "MakeMacro", "Alt", "Ctrl", "Shift"};
		--Because we want to be able to clear out stored vars, we use the forced list
		forceList = {	"UseMainHand", "UseSecondaryHand", "UseHat", "UseGlove",
									"UsePole", "UseFishingHat", "UseFishingGlove"	};
	});
end

--[[ Creates a Macro for the switch function ]]--
TackleBox.MakeMacro = function ()
	if (TackleBox_Config.MakeMacro ~= 0) then
		--Get the number of macros
		local numMacros	= GetNumMacros();
		local name = nil;	--The name of the current macro
		local id = nil;		--The ID of the TackleBox macro
		--Go through all the macros to see if the TackleBox macro is already there
		for curMacro = 1, numMacros do
			--Get the name of the current macro
			name = GetMacroInfo(curMacro);
			--If this is the TackleBox macro, the store it's ID, and stop looking
			if (name == TACKLEBOX_MACRO_NAME) then
				id = curMacro;
				break;
			end
		end
		
		--If we found the TackleBox macro, then update it, otherwise, create it
		if (name and id) then
			EditMacro(id, TACKLEBOX_MACRO_NAME, 8, TackleBox.MACRO_BODY, 1);	
		else
			CreateMacro(TACKLEBOX_MACRO_NAME, 8, TackleBox.MACRO_BODY, 1);
		end
	end
end

--------------------------------------------------
--
-- Hooked Functions
--
--------------------------------------------------
function TackleBox_TurnOrActionStart (arg1)
	--Only test for a throw if the options are enabled, and we have a fishing pole, and fishing
	if ( (TackleBox_Config.EasyCast == 1) and TackleBox.EquippedPole() and TackleBox.CheckFishID() ) then
		TackleBox.ThrowStart();
	end
end

function TackleBox_TurnOrActionStop (arg1)
	--Only test for a throw if the options are enabled, and we have a fishing pole, and fishing
	if ( (TackleBox_Config.EasyCast == 1) and TackleBox.EquippedPole() and TackleBox.CheckFishID() ) then
		TackleBox.ThrowStop();
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
end

TackleBox.OnVarsLoaded = function ()
	if (not TackleBox.ConfigLoaded) then
		TackleBox.ConfigLoaded = true;
		--Load the configuration
		TackleBox.LoadConfig();
		--Store the configuration for this character
		TackleBox.SaveConfig();
		--Make the macro if we should
		TackleBox.MakeMacro();
	end;
end

TackleBox.OnLoad = function ()
	if (TackleBox.Initialized ~= true) then
		--Don't initialize again
		TackleBox.Initialized = true;
		
		--Register our configuration variable to be saved
		RegisterForSave("TackleBox_Config");
		
		--Hook these functions as they are called when the right mouse button is pressed, and released
		Sea.util.hook("TurnOrActionStart", "TackleBox_TurnOrActionStart", "before");
		Sea.util.hook("TurnOrActionStop", "TackleBox_TurnOrActionStop", "after");
	
		--Get the equipment slot IDs that TackleBox needs
		TackleBox.slotID = {};
		TackleBox.slotID.mainHand = GetInventorySlotInfo("MainHandSlot");
		TackleBox.slotID.secondaryHand = GetInventorySlotInfo("SecondaryHandSlot");
		TackleBox.slotID.hat = GetInventorySlotInfo("HeadSlot");
		TackleBox.slotID.glove = GetInventorySlotInfo("HandsSlot");
	
		--Register a header
		MCom.registerSmart( {
			uifolder = "other";																--The Khaos folder to put the option in
			uisec = "TackleBox";															--The section for the UI
			uiseclabel = TACKLEBOX_CONFIG_SECTION;						--The label for the section in the UI
			uisecdesc = TACKLEBOX_CONFIG_SECTION_INFO;				--The description for the section in the UI
			uisecdiff = 1;																		--The section's difficulty in Khaos
			uisecdef = false;																	--Whether the section should be default enabled or not in Khaos
			uivar = "TackleBoxHeader";												--The option name for the UI
			uitype = K_HEADER;																--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_SECTION;								--The label to use for the seperator in the UI
			uidesc = TACKLEBOX_CONFIG_SECTION_INFO;						--The description to use for the seperator in the UI
			uidiff = 1;																				--The option's difficulty in Khaos
			uiver = TackleBox.VERSION;												--The version number to display in the UI
			uiframe = "TackleBoxFrame";												--The frame to identify this addon by
			supercom = {"/tacklebox", "/tb"};									--The main slash command, and any aliases for it
			comaction = "before";															--See Sky for info on this
			comsticky = false;																--See Sky for info on this
			name = TACKLEBOX_CONFIG_SECTION;									--The name of the addon, for display in the info text
			infotext = TACKLEBOX_CONFIG_INFOTEXT;							--The text to show when the help function is called
		} );
		--Register a checkbox
		MCom.registerSmart( {
			hasbool = true;																		--True if the option has a boolean portion
			uivar = "TackleBoxEasyCast";											--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_EASYCAST_ONOFF;				--The label to use for the checkbox in the UI
			uidesc = TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;		--The description to use for the checkbox in the UI
			uidiff = 1;																				--The option's difficulty in Khaos
			varbool = "TackleBox_Config.EasyCast";						--The boolean variable associate with this option
			update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
			textname = TACKLEBOX_OUTPUT_EASYCAST;							--What to say when the command is successfully updated, and there is no GUI
			uicheck = TackleBox_Config.EasyCast;							--The default value for the checkbox in the UI
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"easycast", "easy", "ec"};							--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_EASYCAST_ONOFF_INFO;		--The help text for the sub slash command
		} );
		--Register a checkbox
		MCom.registerSmart( {
			hasbool = true;																		--True if the option has a boolean portion
			uivar = "TackleBoxFastCast";											--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_FASTCAST_ONOFF;				--The label to use for the checkbox in the UI
			uidesc = TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;		--The description to use for the checkbox in the UI
			uidiff = 2;																				--The option's difficulty in Khaos
			varbool = "TackleBox_Config.FastCast";						--The boolean variable associate with this option
			update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
			textname = TACKLEBOX_OUTPUT_FASTCAST;							--What to say when the command is successfully updated, and there is no GUI
			uicheck = TackleBox_Config.FastCast;							--The default value for the checkbox in the UI
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"fastcast", "fast", "fc"};							--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_FASTCAST_ONOFF_INFO;		--The help text for the sub slash command
		} );
		--Register a checkbox
		MCom.registerSmart( {
			hasbool = true;																		--True if the option has a boolean portion
			uivar = "TackleBoxAlt";														--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_ALT_ONOFF;							--The label to use for the checkbox in the UI
			uidesc = TACKLEBOX_CONFIG_ALT_ONOFF_INFO;					--The description to use for the checkbox in the UI
			uidiff = 2;																				--The option's difficulty in Khaos
			varbool = "TackleBox_Config.Alt";									--The boolean variable associate with this option
			update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
			textname = TACKLEBOX_OUTPUT_ALT;									--What to say when the command is successfully updated, and there is no GUI
			uicheck = TackleBox_Config.Alt;										--The default value for the checkbox in the UI
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"alt"};																	--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_ALT_ONOFF_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox
		MCom.registerSmart( {
			hasbool = true;																		--True if the option has a boolean portion
			uivar = "TackleBoxCtrl";													--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_CTRL_ONOFF;						--The label to use for the checkbox in the UI
			uidesc = TACKLEBOX_CONFIG_CTRL_ONOFF_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																				--The option's difficulty in Khaos
			varbool = "TackleBox_Config.Ctrl";								--The boolean variable associate with this option
			update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
			textname = TACKLEBOX_OUTPUT_CTRL;									--What to say when the command is successfully updated, and there is no GUI
			uicheck = TackleBox_Config.Ctrl;									--The default value for the checkbox in the UI
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"control", "ctrl"};											--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_CTRL_ONOFF_INFO;				--The help text for the sub slash command
		} );
		--Register a checkbox
		MCom.registerSmart( {
			hasbool = true;																		--True if the option has a boolean portion
			uivar = "TackleBoxShift";													--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_SHIFT_ONOFF;						--The label to use for the checkbox in the UI
			uidesc = TACKLEBOX_CONFIG_SHIFT_ONOFF_INFO;				--The description to use for the checkbox in the UI
			uidiff = 2;																				--The option's difficulty in Khaos
			varbool = "TackleBox_Config.Shift";								--The boolean variable associate with this option
			update = TackleBox.SaveConfig;										--A command to perform when the option is succesfully updated
			textname = TACKLEBOX_OUTPUT_SHIFT;								--What to say when the command is successfully updated, and there is no GUI
			uicheck = TackleBox_Config.Shift;									--The default value for the checkbox in the UI
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"shift"};																--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_SHIFT_ONOFF_INFO;			--The help text for the sub slash command
		} );
		--Register a checkbox
		MCom.registerSmart( {
			hasbool = true;																		--True if the option has a boolean portion
			uivar = "TackleBoxSwitch";												--The option name for the UI
			uitype = K_TEXT;																	--The option type for the UI
			uilabel = TACKLEBOX_CONFIG_SWITCH_ONOFF;					--The label to use for the checkbox in the UI
			uidesc = TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO;			--The description to use for the checkbox in the UI
			uidiff = 1;																				--The option's difficulty in Khaos
			varbool = "TackleBox_Config.MakeMacro";						--The boolean variable associate with this option
			update = function()	TackleBox.SaveConfig();				--A command to perform when the option is succesfully updated
													TackleBox.MakeMacro(); end;
			textname = TACKLEBOX_OUTPUT_SWITCH;								--What to say when the command is successfully updated, and there is no GUI
			uicheck = TackleBox_Config.MakeMacro;							--The default value for the checkbox in the UI
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"makemacro", "macro"};									--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO;			--The help text for the sub slash command
		} );
		--Register a slash com for switching equipment
		MCom.registerSmart( {
			supercom = "/tacklebox";													--The main(super) slash command associated with this subommand
			subcom = {"switch", "swap", "sw"};								--The sub slash command and any aliases for this option
			subhelp = TACKLEBOX_CONFIG_SWITCH_ONOFF_INFO;			--The help text for the sub slash command
			func = TackleBox.Switch;
		} );

		--Register to keep up with the spells as they change, so we know the ID of fishing
		this:RegisterEvent( "SPELLS_CHANGED" );
		--Register to keep up with whether we are casting or not
		this:RegisterEvent("SPELLCAST_CHANNEL_START");
		this:RegisterEvent("SPELLCAST_CHANNEL_UPDATE");
		--Register to be informed when the vars needed for config are loaded
		MCom.registerVarsLoaded(TackleBox.OnVarsLoaded);
	end
end
