--
-- EquipCompare by Legorol
-- Version: 2.9.3
-- Email: legorol@cosmosui.org
--
-- Equipment comparison tooltips, not just at the merchant. If you hover over
-- any item in places like your bag, quest reward page or loot window, you
-- get a comparison tooltip showing the item of that type that you currently
-- have equipped.
--
-- Usage:
-- To get usage information, type /equipcompare help in-game.
-- 
-- Cosmos version: $Revision: 2437 $
-- Last changed on: $Date: 2005-09-13 09:34:46 -0500 (Tue, 13 Sep 2005) $
-- Last changed by: $LastChangedBy: legorol $
--
-- Development Change Notes:
-- 2.9.3
--  * Some patch 1.7 compatible updates
--  * Changed the way Blizzard's Shopping tooltips are disabled
--  * Fixed a very minor bug involving the interacion of slash commands and
--    Khaos options
-- 2.9.2
--  * Load message dependent on whether running Cosmos or Standalone
-- 2.9.1
--  * Added WeaponButton slots to exclusion list
--  * ShoppingTooltip overtake less aggressive, only happens over Merchant/Auction frames
-- 2.9
--  * Added API: EC_RegisterExclusion, EC_UnregisterExclusion
--  * Added ability to not show comparison tooltips over registered components
--  * Initial Khaos support (not used for slash-command registration yet)
--  * Sky support for slash-command registration
--  * CharactersViewer minimum version increased to 55
--  * Minor bugfixes in CV minimum version checking code
--  * Minor bugfixes when toggling Alt-mode
--  * Tidying up of the registrations and variable synching between Cosmos/Khaos<->EC
--    (Cosmos/Khaos do call my handlers once they have loaded, so no need to grab
--     the info from them.)
-- 2.8
--  * Added API: EC_RegisterTooltip, EC_UnregisterTooltip, EC_GetComparisonAnchor(),
--    EquipCompare_RequestShift, EquipCompare_CancelShift
--  * Various changes to support the API
--  * Always override shopping tooltip
--  * Shifting up as an option
--  * GC reductions
--  * Crossbows/Thrown weapons at last
-- 2.7.1
--  * Memory leak reduction
--  * Partial French localization for new settings (Sasmiraa)
--  * Feedback on slash commands
-- 2.7:
--  * Added option to disable CV integration
--  * Alt-key mode.
--  * Usage text broken up into loop instead of using new-lines
-- 2.6.4:
--  * Split localization files (sarf)
--  * German text fixes (StarDust)
--  * CV-selected player name obtained via global index variable
-- 2.6.2:
--  * German localization
--  * Added version ID in various places
--  * Tooltip widens if the "Currently Equipped" label is long
--  * Learnt a lot about how tooltips lay out their contents
--  * Neater way of adding a label, no need for invisible dummy line anymore! This
--    means that AddLine can be called on the tooltip even after AddLabel.
-- 2.6.1:
--  * French localization
--  * Minor hange in localization scheme, only so that bonus type names
--    are more prominently visible to those translating.
--  * Typo in ShowComparisonTooltip : "parent == GameToolTip" should be
--    small t in tip! D'oh!
-- 2.6:
--  * Have a mode in which hold Ctrl to make comparison tooltips show
-- 2.5:
--  * Introduced private comparison tooltip, lots of modifications related to this
--  * Added the Equipped in: slot labels
--  * Some tooltip placement improvements: with leftAlign, get Main Hand on left
--  * Core logic improvements: e.g. CLEAR_TOOLTIP only enables Recheck, but doesn't Hide
--  * ItemRef tooltips stick
--  * Charactersviewer comparisons are shown for PaperDollFrame
-- 2.1.1:
--  * Fixed a bug introduced in 2.1 causing 2nd comparison tooltip not to appear correctly
--    Learned that I need to anchor a tooltip before calling SetInventoryItem, even if later
--    I change its points.
--  * 2H weapons show shield as well now
-- 2.1:
--  * fix potential bug in overriding AH or Merchant tips (HideTip call wasn't actually done)
--  * tooltip now stands for object rather than string
--  * tooltip arrangement improvements
--
-- Development Todo:
--  * If you view an off-hand item, and you have 2H item equipped, show it.
--  * If the current target tooltip doesn't create comparisons, then allow
--    others to do so.
--  * Review leftAlign placement policy
--  * Review main/off-hand showing policy
--  * Refactoring
--  * Modernise Khaos registration, base Cosmos on it
--

--
-- Global variables
--

-- Configuration settings
-- Default values when neither Khaos nor Cosmos are present
EquipCompare_Enabled = true;
EquipCompare_ControlMode = false;
EquipCompare_UseCV = true;
EquipCompare_AltMode = false;
EquipCompare_Shiftup = false;

-- Values for private use
EquipCompare_Recheck = true;
EquipCompare_Protected = false;
EquipCompare_CharactersViewer = false;
EquipCompare_TargetTooltip = nil;
EquipCompare_Alignment = nil;
EquipCompare_ShiftupObject = nil;
EquipCompare_ShiftupSide = nil;
EquipCompare_ShiftupMargin = 0;
EquipCompare_TooltipList = nil;
EquipCompare_BarList = nil;

-- Data
INVTYPE_WEAPON_OTHER = INVTYPE_WEAPON.."_other";
INVTYPE_FINGER_OTHER = INVTYPE_FINGER.."_other";
INVTYPE_TRINKET_OTHER = INVTYPE_TRINKET.."_other";

EquipCompare_ItemTypes = {
	[INVTYPE_WEAPONMAINHAND] = 16, -- Main Hand
	[INVTYPE_2HWEAPON] = 16, -- Two-Hand
	[INVTYPE_WEAPON] = 16, -- One-Hand
	[INVTYPE_WEAPON_OTHER] = 17, -- One-Hand_other
	[INVTYPE_SHIELD] = 17, -- Off Hand
	[INVTYPE_WEAPONOFFHAND] = 17, -- Off Hand
	[INVTYPE_HOLDABLE] = 17, -- Held In Off-hand
	[INVTYPE_HEAD] = 1, -- Head
	[INVTYPE_WAIST] = 6, -- Waist
	[INVTYPE_SHOULDER] = 3, -- Shoulder
	[INVTYPE_LEGS] = 7, -- Legs
	[INVTYPE_CLOAK] = 15, -- Back
	[INVTYPE_FEET] = 8, -- Feet
	[INVTYPE_CHEST] = 5, -- Chest
	[INVTYPE_ROBE] = 5, -- Chest
	[INVTYPE_WRIST] = 9, -- Wrist
	[INVTYPE_HAND] = 10, -- Hands
	[INVTYPE_RANGED] = 18, -- Ranged
	[INVTYPE_BODY] = 4, -- Shirt
	[INVTYPE_TABARD] = 19, -- Tabard
	[INVTYPE_FINGER] = 11, -- Finger
	[INVTYPE_FINGER_OTHER] = 12, -- Finger_other
	[INVTYPE_NECK] = 2, -- Neck
	[INVTYPE_TRINKET] = 13, -- Trinket
	[INVTYPE_TRINKET_OTHER] = 14, -- Trinket_other
	[INVTYPE_WAND] = 18, -- Wand
	[INVTYPE_GUN] = 18, -- Gun
	[INVTYPE_GUNPROJECTILE] = 0, -- Projectile
	[INVTYPE_BOWPROJECTILE] = 0, -- Projectile
	[INVTYPE_CROSSBOW] = 18, -- Crossbow
	[INVTYPE_THROWN] = 18, -- Thrown
};

EquipCompare_SlotIDtoSlotName = {
	[0] = AMMOSLOT,		-- 0
	HEADSLOT,			-- 1
	NECKSLOT,			-- 2
	SHOULDERSLOT,		-- 3
	SHIRTSLOT,			-- 4
	CHESTSLOT,			-- 5
	WAISTSLOT,			-- 6
	LEGSSLOT,			-- 7
	FEETSLOT,			-- 8
	WRISTSLOT,			-- 9
	HANDSSLOT,			-- 10
	FINGER0SLOT,		-- 11
	FINGER1SLOT,		-- 12
	TRINKET0SLOT,		-- 13
	TRINKET1SLOT,		-- 14
	BACKSLOT,			-- 15
	MAINHANDSLOT,		-- 16
	SECONDARYHANDSLOT,	-- 17
	RANGEDSLOT,			-- 18
	TABARDSLOT,			-- 19
};

--
-- Public API
--

--[[
  success = EquipCompare_RegisterTooltip(object, priority)
  
  Call this to register a tooltip object that you would like EquipCompare
  to show comparison tooltips for.
  
  Arguments:
  * object: [Reference] The object to register with EquipeCompare
  * priority (optional): [String] Permitted values are "high" and "low".
    If not present, defaults to "low". Specifies whether you would like
	to show comparison tooltips for this object in preference to the
	game's main tooltip, if both are showing.
  Returns:
  * success: [Boolean] True if the registration was successful or the
    object is already registered, false otherwise.
  Note:
   GameTooltip and ItemRefTooltip are registered by default. You only
   need to register your own custom tooltips using this function. It is
   permissible to call this function multiple times with the same object,
   but it will result in a single registration.
  ]]
function EquipCompare_RegisterTooltip(object, priority)
	local i;
	
	if ( not priority ) then
		priority = "low";
	end
	if ( not object or priority ~= "high" and priority ~= "low" ) then
		return false;
	end
	
	if ( not EquipCompare_TooltipList ) then
		EquipCompare_InitializeTooltipList();
	end
	
	for i = 1, table.getn(EquipCompare_TooltipList) do
		if ( EquipCompare_TooltipList[i] == object ) then
			return true;
		end
	end
	
	if ( priority == "high" ) then
		table.insert(EquipCompare_TooltipList, 1, object);
	else
		table.insert(EquipCompare_TooltipList, object);
	end
	
	return true;
end

--[[
  success = EquipCompare_UnregisterTooltip(object)
  
  Call this to unregister a tooltip object that you would no longer like
  EquipCompare to show comparison tooltips for.
  
  Arguments:
  * object: [Reference] The object to unregister with EquipeCompare
  Returns:
  * success: [Boolean] True if the object was successfully unregistered,
    false otherwise (for example because the object was not found in the
	list of registered tooltips).
  Note:
   You will not be able to unregister GameTooltip and ItemRefTooltip,
   and will receive a return value of false if you try. You should only
   use this function to unregister your custom tooltips.
  ]]
function EquipCompare_UnregisterTooltip(object)
	local i;
	
	if ( not object or not EquipCompare_TooltipList ) then
		return false;
	end
	
	for i = 1, table.getn(EquipCompare_TooltipList) do
		if ( EquipCompare_TooltipList[i] == object ) then
			table.remove(EquipCompare_TooltipList, i);
			return true;
		end
	end
	
	return false;
end
  
--[[
  success = EquipCompare_RegisterExclusion(pattern)

  Call this to register an object or set of objects which, when you hover
  over it or them, you don't want EquipCompare to show comparison tooltips.
  
  Arguments:
  * pattern: [String] A standard Lua regexp pattern. Any object whose name
    matches this pattern will not show comparison tooltips when hovered
	over. Example: "^ActionButton", which avoids comparison tooltips when
	hovering over any action bar buttons.
  Returns:
  * success: [Boolean] True if the pattern was successfully registered,
    or if it has been registered before.
  Note:
   It is permissible to call this function multiple times with the exact
   same pattern. It will however result in a single registration for that
   pattern. The following patterns are registered by EquipCompare by
   default: "^Character.*Slot","^CharactersViewer_Frame","^TempEnchant",
   "^MultiBar","^ActionButton"
  
  ]]
function EquipCompare_RegisterExclusion(barname)
	local i;
	
	if ( type(barname) ~= "string" ) then
		return false;
	end
	
	if ( not EquipCompare_BarList ) then
		EquipCompare_InitializeBarList();
	end
	
	for i = 1, table.getn(EquipCompare_BarList) do
		if ( EquipCompare_BarList[i] == barname ) then
			return true;
		end
	end
	
	table.insert(EquipCompare_BarList, barname);
	return true;
end

--[[
  success = EquipCompare_UnregisterExclusion(pattern)

  Call this to unregister an exclusion pattern registered with
  EquipCompare_RegisterExclusion. Use a standard Lua regular
  expression pattern to specify the name(s) of the object(s).
  
  Arguments:
  * pattern: [String] The exact same pattern that was registered.
  Returns:
  * success: [Boolean] True if the pattern was successfully unregistered,
    false if some error occurred, e.g. it wasn't in the registered list.
  
  ]]
function EquipCompare_UnregisterExclusion(barname)
	local i;
	
	if ( type(barname) ~= "string" or not EquipCompare_BarList ) then
		return false;
	end
	
	for i = 1, table.getn(EquipCompare_BarList) do
		if ( EquipCompare_BarList[i] == barname ) then
			table.remove(EquipCompare_BarList, i);
			return true;
		end
	end
	
	return false;
end

--[[
  object, alignment = EquipCompare_GetComparisonAnchor()
  
  Call this when you need to know which side the comparison tooltips are on,
  or would be on, relative to the object that EquipCompare currently prefers
  to attach comparison tooltips to.
  
  Returns:
   * object: [Reference] The object (e.g. GameTooltip or ItemRefTooltip) that
     EC currently is attaching to or would be attaching to if it was
	 displaying comparison tooltips. Set to nil if EC can't see any object to
	 attach to.
   * alignment: [String] "left" or "right", depending on which side the
     comparison tooltips are showing or would show up on for that object.
	 Set to nil if EC wouldn't show comparison tooltips for the object at the
	 moment.
]]
function EquipCompare_GetComparisonAnchor()
	EquipCompare_CheckCompare();
	if ( EquipCompare_ControlMode and not IsControlKeyDown() ) then
		EquipCompare_HideTips();
	end
	return EquipCompare_TargetTooltip, EquipCompare_Alignment;
end

--[[
  EquipCompare_RequestShift(object, side, margin)

  Call this when you want to request EquipCompare to shift its tooltips if
  necessary to make space under and to the side of an object, for example because
  you want to occupy that space.
  Arguments:
   * object: [Reference] The object you are requesting a shift around
     (e.g. GameTooltip or ItemRefTooltip).
   * side: [String] Indicates which side under the object you need space.
     Takes value "left" or "right".
   * margin: [Integer] Indicates how much space in game-pixels you need.
  Note:
   It is permissible to call EquipCompare_RequestShift multiple types, even
   without corresponding calls to EquipCompare_CancelShift(), for example,
   to change the object or the margin. It is always the last call that
   takes effect.
]]
function EquipCompare_RequestShift(object, side, margin)
	-- error checking
	if ( side ~= "left" and side ~= "right" or type(margin) ~= "number" ) then
		EquipCompare_ShiftupObject = nil;
		EquipCompare_ShiftupSide = nil;
		EquipCompare_ShiftupMargin = 0;
		return;
	end
	
	EquipCompare_ShiftupObject = object;
	EquipCompare_ShiftupSide = side;
	EquipCompare_ShiftupMargin = margin;
	
	EquipCompare_Recheck = true;
	EquipCompare_OnUpdate();
end

--[[
  EquipCompare_CancelShift(object)
  
  Call this when you no longer require EquipCompare to make space under
  and to the side of an object.
  
  Arguments:
   * object: [Reference] The object you no longer need space around.
  Note:
   It is permissible to call this function multiple times, even without
   corresponding calls to EquipCompare_RequestShift(). It is also
   permissible to call this with a different object that you called
   EquipCompare_RequestShift() with, or an object that EquipCompare
   is not actually attaching to.
]]
function EquipCompare_CancelShift(object)
	if ( object == EquipCompare_ShiftupObject ) then
		EquipCompare_Recheck = true;
	end
	
	EquipCompare_ShiftupObject = nil;
	EquipCompare_ShiftupSide = nil;
	EquipCompare_ShiftupMargin = 0;
	
	EquipCompare_OnUpdate();
end

--
-- Some local functions that are used throughout
--

-- CharactersViewer compatibility check

local function IsCharactersViewer()
	if ( CharactersViewer and CharactersViewer.version and
		type(CharactersViewer.version.number) == "number" and
		CharactersViewer.version.number >= 55 and
		type(CharactersViewer_Tooltip_SetInventoryItem)=="function" and
		EquipCompare_UseCV ) then
		return true;
	else
		return false;
	end
end

-- Registration and configuration

function EquipCompare_Register_Khaos()
	-- Note: Default to disabled if Khaos is present
	Khaos.registerOptionSet (
		"tooltip",
		{
			id = "EquipCompareConfigSet";
			text = EQUIPCOMPARE_COSMOS_SECTION;
			helptext = EQUIPCOMPARE_COSMOS_SECTION_INFO;
			difficulty = 1;
			callback = EquipCompare_Toggle;
			default = false;
			options = {
				{
					id = "EquipCompareOptionHeader";
					type = K_HEADER;
					difficulty = 1;
					text = EQUIPCOMPARE_COSMOS_HEADER;
					helptext = EQUIPCOMPARE_COSMOS_HEADER_INFO;
				},{
					id = "EquipCompareOptionControlMode";
					type = K_TEXT;
					difficulty = 3;
					text = EQUIPCOMPARE_COSMOS_CONTROLMODE;
					helptext = EQUIPCOMPARE_COSMOS_CONTROLMODE_INFO;
					callback = function(state) EquipCompare_ToggleControl(state.checked); end;
					feedback = function(state)
						if (state.checked) then
							return EQUIPCOMPARE_TOGGLECONTROL_ON;
						else
							return EQUIPCOMPARE_TOGGLECONTROL_OFF;
						end
					end;
					check = true;
					default = { checked = false; };
					disabled = { checked = false; };
				},{
					id = "EquipCompareOptionCVIntegration";
					type = K_TEXT;
					difficulty = 2;
					text = EQUIPCOMPARE_COSMOS_CVMODE;
					helptext = EQUIPCOMPARE_COSMOS_CVMODE_INFO;
					callback = function(state) EquipCompare_ToggleCV(state.checked); end;
					feedback = function(state)
						if (state.checked) then
							return EQUIPCOMPARE_TOGGLECV_ON;
						else
							return EQUIPCOMPARE_TOGGLECV_OFF;
						end
					end;
					check = true;
					default = { checked = true; };
					disabled = { checked = false; };
				},{
					id = "EquipCompareOptionAltMode";
					type = K_TEXT;
					difficulty = 3;
					text = EQUIPCOMPARE_COSMOS_ALTMODE;
					helptext = EQUIPCOMPARE_COSMOS_ALTMODE_INFO;
					callback = function(state) EquipCompare_ToggleAlt(state.checked); end;
					feedback = function(state)
						if (state.checked) then
							return EQUIPCOMPARE_TOGGLEALT_ON;
						else
							return EQUIPCOMPARE_TOGGLEALT_OFF;
						end
					end;
					check = true;
					default = { checked = false; };
					disabled = { checked = false; };
				},{
					id = "EquipCompareOptionShiftupMode";
					type = K_TEXT;
					difficulty = 2;
					text = EQUIPCOMPARE_COSMOS_SHIFTUP;
					helptext = EQUIPCOMPARE_COSMOS_SHIFTUP_INFO;
					callback = function(state) EquipCompare_ToggleShiftup(state.checked); end;
					feedback = function(state)
						if (state.checked) then
							return EQUIPCOMPARE_SHIFTUP_ON;
						else
							return EQUIPCOMPARE_SHIFTUP_OFF;
						end
					end;
					check = true;
					default = { checked = false; };
					disabled = { checked = false; };
				}
			}
		}
	)
end

function EquipCompare_Register_Cosmos()
	-- Note: Default to disabled if Cosmos is present
	Cosmos_RegisterConfiguration(
		"COS_EQC",
		"SECTION",
		EQUIPCOMPARE_COSMOS_SECTION,
		EQUIPCOMPARE_COSMOS_SECTION_INFO
	);
	Cosmos_RegisterConfiguration(
		"COS_EQC_SEPARATOR",
		"SEPARATOR",
		EQUIPCOMPARE_COSMOS_HEADER,
		EQUIPCOMPARE_COSMOS_HEADER_INFO
		
	);
	Cosmos_RegisterConfiguration(
		"COS_EQC_ENABLED",
		"CHECKBOX",
		EQUIPCOMPARE_COSMOS_ENABLE,
		EQUIPCOMPARE_COSMOS_ENABLE_INFO,
		EquipCompare_Toggle,
		0
	);
	Cosmos_RegisterConfiguration(
		"COS_EQC_CONTROLMODE",
		"CHECKBOX",
		EQUIPCOMPARE_COSMOS_CONTROLMODE,
		EQUIPCOMPARE_COSMOS_CONTROLMODE_INFO,
		EquipCompare_ToggleControl,
		0
	);
	Cosmos_RegisterConfiguration(
		"COS_EQC_CVMODE",
		"CHECKBOX",
		EQUIPCOMPARE_COSMOS_CVMODE,
		EQUIPCOMPARE_COSMOS_CVMODE_INFO,
		EquipCompare_ToggleCV,
		1
	);
	Cosmos_RegisterConfiguration(
		"COS_EQC_ALTMODE",
		"CHECKBOX",
		EQUIPCOMPARE_COSMOS_ALTMODE,
		EQUIPCOMPARE_COSMOS_ALTMODE_INFO,
		EquipCompare_ToggleAlt,
		0
	);
	Cosmos_RegisterConfiguration(
		"COS_EQC_SHIFTUP",
		"CHECKBOX",
		EQUIPCOMPARE_COSMOS_SHIFTUP,
		EQUIPCOMPARE_COSMOS_SHIFTUP_INFO,
		EquipCompare_ToggleShiftup,
		0
	);
end

--
-- XML Event handlers
--

function EquipCompare_OnLoad()
	-- Hook into various methods of ShoppingTooltips
	EquipCompare_SetupHooks();
	
	-- Initialize lists
	EquipCompare_InitializeTooltipList();
	EquipCompare_InitializeBarList();
	
	-- Event registration
	this:RegisterEvent("CLEAR_TOOLTIP");
	
	-- GUI configuration registration
	-- Check for Khaos. If available, register with it.
	if ( Khaos ) then
		EquipCompare_Register_Khaos();
	elseif ( Cosmos_RegisterConfiguration ) then
	-- Check for Cosmos. If available, register with it.
		EquipCompare_Register_Cosmos()
	end
	
	-- Slash command registration - for now, don't use Khaos
	-- If Sky is present, use it to register slash commands
	if ( Sky ) then
		Sky.registerSlashCommand {
			id = "EquipCompare";
			commands = { "/equipcompare", "/eqc" };
			onExecute = EquipCompare_SlashCommand;
			helpText = EQUIPCOMPARE_COSMOS_SLASH_DESC;
		}
	-- If Cosmos allows chat command registration, do so
	elseif ( Cosmos_RegisterChatCommand ) then
		local comlist = { "/equipcompare", "/eqc" };
		local desc = EQUIPCOMPARE_COSMOS_SLASH_DESC;
		local id = "EQUIPCOMPARE";
		local func = EquipCompare_SlashCommand
		Cosmos_RegisterChatCommand ( id, comlist, func, desc, CSM_CHAINNONE );
	else
	-- otherwise, just register slash commands manually
		SlashCmdList["EQUIPCOMPARE"] = EquipCompare_SlashCommand;
		SLASH_EQUIPCOMPARE1 = "/equipcompare";
		SLASH_EQUIPCOMPARE2 = "/eqc";
	end

	-- Check to see if CharactersViewer is installed, has the right version
	-- and has the required interface. If so, enable support for it.
	if ( IsCharactersViewer() ) then
		EquipCompare_CharactersViewer = true;
	end
	
	-- Welcome!
	if ( not Khaos and not Cosmos_RegisterChatCommand ) then
		ChatFrame1:AddMessage(EQUIPCOMPARE_GREETING);
	end
end

function EquipCompare_OnEvent(event)
	if ( event == "CLEAR_TOOLTIP" and not EquipCompare_Protected ) then
		EquipCompare_Recheck = true;
	end
end

local lastAltState = "undefined";

-- This function is called on every OnUpdate. This is the only way to detect if a
-- game tooltip has been displayed, without overriding FrameXML files or hooking
-- millions of functions.
-- So that this function doesn't hog resources, the EquipCompare_Recheck flag is
-- set to false, until the game tooltip changes.
function EquipCompare_OnUpdate()
	if ( not EquipCompare_Enabled ) then
		return;
	end
	
	if ( EquipCompare_ControlMode and not IsControlKeyDown() ) then
		if (EquipCompare_TargetTooltip) then
			EquipCompare_Recheck = true;
			EquipCompare_TargetTooltip = nil;
			EquipCompare_HideTips();
		end
		return;
	end
	
	if ( EquipCompare_AltMode and lastAltState ~= IsAltKeyDown() ) then
		local changed;
		lastAltState = IsAltKeyDown();
		if ( lastAltState ) then
			if ( IsCharactersViewer() ) then
				EquipCompare_CharactersViewer = true;
				changed = true;
			end
		else
			if ( EquipCompare_CharactersViewer ) then
				EquipCompare_CharactersViewer = false;
				changed = true;
			end
		end
		if ( changed ) then
			EquipCompare_Recheck = true;
			EquipCompare_TargetTooltip = nil;
			EquipCompare_HideTips();
		end
	end
	
	-- If we currently have a target that has since become
	-- hidden, hide the comparison tooltips too.
	if ( EquipCompare_TargetTooltip and
	     not EquipCompare_TargetTooltip:IsVisible() ) then
		EquipCompare_Recheck = true;
		EquipCompare_TargetTooltip = nil;
		EquipCompare_HideTips();
	end
	
	if ( not EquipCompare_Recheck ) then
	 	return;
	end
	
	EquipCompare_CheckCompare();
end

--
-- Other functions
--

function EquipCompare_SetupHooks()
	EquipCompare_old_SetAuctionCompareItem1 = ShoppingTooltip1.SetAuctionCompareItem;
	EquipCompare_old_SetAuctionCompareItem2 = ShoppingTooltip2.SetAuctionCompareItem;
	
	ShoppingTooltip1.SetAuctionCompareItem = function(a1,a2,a3,a4,a5)
		if ( EquipCompare_Enabled ) then
			return false;
		else
			return EquipCompare_old_SetAuctionCompareItem1(a1,a2,a3,a4,a5);
		end
	end
	ShoppingTooltip2.SetAuctionCompareItem = function(a1,a2,a3,a4,a5)
		if ( EquipCompare_Enabled ) then
			return false;
		else
			return EquipCompare_old_SetAuctionCompareItem2(a1,a2,a3,a4,a5);
		end
	end
	
	EquipCompare_old_SetMerchantCompareItem1 = ShoppingTooltip1.SetMerchantCompareItem;
	EquipCompare_old_SetMerchantCompareItem2 = ShoppingTooltip2.SetMerchantCompareItem;
	
	ShoppingTooltip1.SetMerchantCompareItem = function(a1,a2,a3,a4,a5)
		if ( EquipCompare_Enabled ) then
			return false;
		else
			return EquipCompare_old_SetMerchantCompareItem1(a1,a2,a3,a4,a5);
		end
	end
	ShoppingTooltip2.SetMerchantCompareItem = function(a1,a2,a3,a4,a5)
		if ( EquipCompare_Enabled ) then
			return false;
		else
			return EquipCompare_old_SetMerchantCompareItem2(a1,a2,a3,a4,a5);
		end
	end
end

local function EquipCompare_EmptyFunction() end;

function EquipCompare_InitializeTooltipList()
	if ( not EquipCompare_TooltipList ) then
		EquipCompare_TooltipList = {};
	end
	EquipCompare_RegisterTooltip(ItemRefTooltip, "high");
	EquipCompare_RegisterTooltip(LootLinkTooltip);
	EquipCompare_RegisterTooltip(GameTooltip, "low");
end

function EquipCompare_InitializeBarList()
	if ( not EquipCompare_BarList ) then
		EquipCompare_BarList = {};
	end
	EquipCompare_RegisterExclusion("^Character.*Slot");
	EquipCompare_RegisterExclusion("^CharactersViewer_Frame");
	EquipCompare_RegisterExclusion("^TempEnchant");
	EquipCompare_RegisterExclusion("^MultiBar");
	EquipCompare_RegisterExclusion("^ActionButton");
	EquipCompare_RegisterExclusion("^WeaponButton.*Slot");
end

local showedTip = false;

function EquipCompare_SlashCommand(msg)
	local setlevel = false;
	if (not msg or msg == "") then
		-- toggle
		EquipCompare_Toggle(not EquipCompare_Enabled);
		if (EquipCompare_Enabled) then
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLE_ON);
		else
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLE_OFF);
		end
		if (not showedTip) then
			showedTip = true;
			ChatFrame1:AddMessage(EQUIPCOMPARE_HELPTIP);
		end
		setlevel = true;
	elseif (msg == "on") then
		-- turn on
		EquipCompare_Toggle(true);
		ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLE_ON);
		setlevel = true;
	elseif (msg == "off") then
		-- turn off
		EquipCompare_Toggle(false);
		ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLE_OFF);
		setlevel = true;
	elseif (msg == "control") then
		-- toggle Control Key Mode
		EquipCompare_ToggleControl(not EquipCompare_ControlMode);
		if (EquipCompare_ControlMode) then
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLECONTROL_ON);
		else
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLECONTROL_OFF);
		end
	elseif (msg == "cv") then
		-- toggle CharactersViewer integration
		EquipCompare_ToggleCV(not EquipCompare_UseCV);
		if (EquipCompare_UseCV) then
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLECV_ON);
		else
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLECV_OFF);
		end
	elseif (msg == "alt") then
		-- toggle Alt Key Mode
		EquipCompare_ToggleAlt(not EquipCompare_AltMode);
		if (EquipCompare_AltMode) then
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLEALT_ON);
		else
			ChatFrame1:AddMessage(EQUIPCOMPARE_TOGGLEALT_OFF);
		end
	elseif (msg == "shift") then
		-- toggle Alt Key Mode
		EquipCompare_ToggleShiftup(not EquipCompare_Shiftup);
		if (EquipCompare_Shiftup) then
			ChatFrame1:AddMessage(EQUIPCOMPARE_SHIFTUP_ON);
		else
			ChatFrame1:AddMessage(EQUIPCOMPARE_SHIFTUP_OFF);
		end
	else
		-- usage
		for i, s in EQUIPCOMPARE_USAGE_TEXT do
			ChatFrame1:AddMessage(s);
		end
	end
	-- update Khaos configuration settings
	if ( Khaos ) then
		-- Note: only do the set enabling if that's what was changed,
		-- since enabling the set causes all the callbacks to be run.
		if (setlevel) then
			Khaos.setSetEnabled("EquipCompareConfigSet", EquipCompare_Enabled);
		else
			Khaos.setSetKey("EquipCompareConfigSet", "EquipCompareOptionControlMode",
				{ checked = EquipCompare_ControlMode });
			Khaos.setSetKey("EquipCompareConfigSet", "EquipCompareOptionCVIntegration",
				{ checked = EquipCompare_UseCV });
			Khaos.setSetKey("EquipCompareConfigSet", "EquipCompareOptionAltMode",
				{ checked = EquipCompare_AltMode });
			Khaos.setSetKey("EquipCompareConfigSet", "EquipCompareOptionShiftupMode",
				{ checked = EquipCompare_ShiftupMode });
		end
		Khaos.refresh();
	-- update Cosmos configuration settings
	elseif ( Cosmos_RegisterConfiguration ) then
		local newvalue;
		-- Enabled check box
		if ( EquipCompare_Enabled ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		Cosmos_UpdateValue("COS_EQC_ENABLED", CSM_CHECKONOFF, newvalue);
		
		-- Control mode check box
		if ( EquipCompare_ControlMode ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		Cosmos_UpdateValue("COS_EQC_CONTROLMODE", CSM_CHECKONOFF, newvalue);
		
		-- CV integration check box
		if ( EquipCompare_UseCV ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		Cosmos_UpdateValue("COS_EQC_CVMODE", CSM_CHECKONOFF, newvalue);
		
		-- Alt mode check box
		if ( EquipCompare_AltMode ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		Cosmos_UpdateValue("COS_EQC_ALTMODE", CSM_CHECKONOFF, newvalue);
		
		-- Shift up check box
		if ( EquipCompare_Shiftup ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		Cosmos_UpdateValue("COS_EQC_SHIFTUP", CSM_CHECKONOFF, newvalue);
		
		-- Save and synchronize the new values
		CosmosMaster_Save()
	end
end

function EquipCompare_Toggle(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle and not EquipCompare_Enabled ) then
		EquipCompare_Enabled = true;
		EquipCompare_Recheck = true;
		-- In case Blizzard's ShoppingTooltips are visible, hide them
		ShoppingTooltip1:Hide();
		ShoppingTooltip2:Hide();
	end
	-- turn off
	if ( not toggle and EquipCompare_Enabled ) then
		EquipCompare_Enabled = false;
		EquipCompare_HideTips();
	end
end

function EquipCompare_ToggleControl(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle ) then
		EquipCompare_ControlMode = true;
	end
	-- turn off
	if ( not toggle ) then
		EquipCompare_ControlMode = false;
	end
end

function EquipCompare_ToggleCV(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle ) then
		EquipCompare_UseCV = true;
		if ( IsCharactersViewer() ) then
			if ( EquipCompare_AltMode ) then
				EquipCompare_CharactersViewer = lastAltState;
			else
				EquipCompare_CharactersViewer = true;
			end
		else
			EquipCompare_CharactersViewer = false;
		end
	end
	-- turn off
	if ( not toggle ) then
		EquipCompare_UseCV = false;
		EquipCompare_CharactersViewer = false;
	end
end

function EquipCompare_ToggleAlt(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle ) then
		EquipCompare_AltMode = true;
	end
	-- turn off
	if ( not toggle ) then
		EquipCompare_AltMode = false;
		if ( IsCharactersViewer() ) then
			EquipCompare_CharactersViewer = true;
			EquipCompare_Recheck = true;
		end
	end
end

function EquipCompare_ToggleShiftup(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle ) then
		EquipCompare_Shiftup = true;
	end
	-- turn off
	if ( not toggle ) then
		EquipCompare_Shiftup = false;
	end
	EquipCompare_Recheck = true;
end

function EquipCompare_HideTips()
	ComparisonTooltip1:Hide();
	ComparisonTooltip2:Hide();
end

--
-- Local functions for ShowCompare()
--

-- Add a label at the top of the tooltip saying "Currently Equipped"
local function AddLabel(tooltip, slot)
	local tLabel, tLabel1;
	
	if (not tooltip or not tooltip:IsVisible()) then
		return;
	end
	
	tLabel = getglobal(tooltip:GetName().."TextLeft0");
	tLabel:SetText(EQUIPCOMPARE_EQUIPPED_LABEL);
	tLabel:SetTextColor(0.5, 0.5, 0.5);
	tLabel:Show();
	
	tLabel1 = getglobal(tooltip:GetName().."TextLeft1");
	if ( tLabel:IsVisible() and tLabel1:IsVisible() ) then
		if ( tLabel:GetWidth() > tLabel1:GetWidth() ) then
			tLabel1:SetWidth(tLabel:GetWidth());
			tooltip:Show();
		end
	end
end

-- Display a comparison tooltip and set its contents to currently equipped item
-- occupying slotid
local function ShowComparisonTooltip(parent, slotid)
	local leftAlign, donePlacing;
	local left, right, i;
	
	-- Set contents of tooltip.
	
	-- Note: you can't set a tooltip's contents before specifying at least
	-- one point. Hence anchor it to whatever, even if you later change
	-- its placement.
	ComparisonTooltip1:SetOwner(parent, "ANCHOR_LEFT");
	if ( EquipCompare_CharactersViewer ) then
		CharactersViewer_Tooltip_SetInventoryItem(ComparisonTooltip1, slotid);
	else
		ComparisonTooltip1:SetInventoryItem("player", slotid);
	end
	AddLabel(ComparisonTooltip1, slotid);
	
	if ( not ComparisonTooltip1:IsVisible() ) then
		return;
	end;
	
	-- Set placement of tooltip
	
	leftAlign = false;
	if ( parent == GameTooltip and GetMouseFocus() and
		 string.find(GetMouseFocus():GetName(),"^ContainerFrame.*Item") ) then
		leftAlign = true;
	end
	
	donePlacing = true;
	repeat
		ComparisonTooltip1:ClearAllPoints();
		if (leftAlign) then
			ComparisonTooltip1:SetPoint("TOPRIGHT", parent:GetName(), "TOPLEFT", 0, -10);
		else
			ComparisonTooltip1:SetPoint("TOPLEFT", parent:GetName(), "TOPRIGHT", 0, -10);
		end
		
		local left = ComparisonTooltip1:GetLeft();
		local right = ComparisonTooltip1:GetRight();
		
		if ( left and right ) then
			left, right = left - (right-left), right + (right-left);
		end
		
		-- If the comparison tooltip would be off the screen, place it on other 
		-- side instead. Only perform this check once to avoid endless loop.
		if ( donePlacing ) then
			if ( left and left<0 ) then
				leftAlign = false;
				donePlacing = false;
			elseif ( right and right>UIParent:GetRight() ) then
				leftAlign = true;
				donePlacing = false;
			end
		else
			donePlacing = true;
		end
	until donePlacing;
	
	return leftAlign;
end

function EquipCompare_CheckCompare()
	local tooltip = nil;
	local i = 1;
	
	if ( not EquipCompare_TooltipList ) then
		EquipCompare_InitializeTooltipList();
	end
	
	-- Check which tooltip we are intersted in, in order of priority
	repeat
		tooltip = EquipCompare_TooltipList[i];
		if ( not tooltip:IsVisible() ) then
			tooltip = nil;
		end
		i = i + 1;
	until tooltip or i > table.getn(EquipCompare_TooltipList)
	
	EquipCompare_TargetTooltip = tooltip;
	EquipCompare_Alignment = nil;
	
	if ( tooltip ) then
		EquipCompare_ShowCompare(tooltip);
	end
end

function EquipCompare_ShowCompare(tooltip)
	--
	-- Main code of EquipCompare_ShowCompare starts here
	--
	
	local OverrideTooltips = nil;
	local ttext, itype, slotid, other, leftAlign;
	local i, cvplayer;
	local shift, comptipclose, comptipfar, point, relative;
	local mfocus;
	
	-- Start processing
	
	EquipCompare_Recheck = false;
	EquipCompare_HideTips();
	
	-- In some cases it is desirable to override the restrictions on showing
	-- comparison tooltips, and show them anyway. Check for that here.
	
	if ( EquipCompare_CharactersViewer ) then
		cvplayer = CharactersViewer.index;
		if ( cvplayer == nil ) then
			cvplayer = UnitName("player");
		end
		if ( UnitName("player") ~= cvplayer ) then
			OverrideTooltips = true;
		end
		if ( CharactersViewer_Frame:IsVisible() and
			MouseIsOver(CharactersViewer_Frame) and tooltip == GameTooltip ) then
			OverrideTooltips = false;
		end
	end
	
	-- Special checks when we are attaching to GameTooltip. For some frames, we do
	-- not want to provide comparison tooltips.
	if ( tooltip == GameTooltip ) then
		if ( GetMouseFocus() ) then 
			mfocus = GetMouseFocus():GetName();
		end
		if ( not OverrideTooltips and mfocus ) then
			for i=1, table.getn(EquipCompare_BarList) do
				if ( string.find(mfocus, EquipCompare_BarList[i]) ) then
					return;
				end
			end
		end
	end
	
	-- Infer the type of the item from one of the 2nd to 5th line of its tooltip description
	-- Match this type against the appropriate slot
	slotid = nil;
	i = 2;
	repeat
		ttext = getglobal(tooltip:GetName().."TextLeft"..i);
		if ( ttext and ttext:IsVisible() ) then
			itype = ttext:GetText();
			if ( itype ) then
				slotid = EquipCompare_ItemTypes[itype];
			end
		end
		i = i + 1;
	until (slotid or i > 5)
	
	if ( slotid ) then
		-- Whilst we are in the process of displaying additional tooltips, we don't
		-- want to reset the EquipCompare_Recheck flag. This protection is necessary
		-- because calling SetOwner or SetxxxItem on any tooltip causes a
		-- CLEAR_TOOLTIP event.
	    EquipCompare_Protected = true;
		
		-- In case money line is visible on GameTooltip, must protect it by overriding
		-- GameTooltip_ClearMoney. This is because calling SetOwner or SetxxxItem on
		-- any tooltip causes money line of GameTooltip to be cleared.
		local oldFunction = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = EquipCompare_EmptyFunction;
		
		-- Display a comparison tooltip and set its contents to currently equipped item
		leftAlign = ShowComparisonTooltip(tooltip, slotid);
		
		other = false;
		-- If this is an item that can go into multiple slots, display additional
		-- tooltips as appropriate
		if ( itype == INVTYPE_FINGER ) then
			other = EquipCompare_ItemTypes[INVTYPE_FINGER_OTHER];
		end
		if ( itype == INVTYPE_TRINKET ) then
			other = EquipCompare_ItemTypes[INVTYPE_TRINKET_OTHER];
		end
		if ( itype == INVTYPE_WEAPON ) then
			other = EquipCompare_ItemTypes[INVTYPE_WEAPON_OTHER];
		end
		
		if ( itype == INVTYPE_2HWEAPON ) then
			other = EquipCompare_ItemTypes[INVTYPE_SHIELD];
		end
		
		if ( other ) then
			if ( ComparisonTooltip1:IsVisible() ) then
				-- First set the contents of the 2nd tooltip.
				-- Note that we must use either at least an anchor or SetPoint
				-- to be able to set the contents.
				ComparisonTooltip2:SetOwner(ComparisonTooltip1, "ANCHOR_LEFT");
				if ( EquipCompare_CharactersViewer ) then
					CharactersViewer_Tooltip_SetInventoryItem(ComparisonTooltip2, other);
				else
					ComparisonTooltip2:SetInventoryItem("player", other);
				end
				AddLabel(ComparisonTooltip2, other);
				
				if ( ComparisonTooltip2:IsVisible() ) then
					-- Now place it in its rightful place
					ComparisonTooltip2:ClearAllPoints();
					if ( leftAlign ) then
						ComparisonTooltip1:ClearAllPoints();
						ComparisonTooltip2:SetPoint("TOPRIGHT", tooltip:GetName(), "TOPLEFT", 0, -10);
						ComparisonTooltip1:SetPoint("TOPRIGHT", "ComparisonTooltip2", "TOPLEFT", 0, 0);
					else
						ComparisonTooltip2:SetPoint("TOPLEFT", "ComparisonTooltip1", "TOPRIGHT", 0, 0);
					end
				end
			else
				ShowComparisonTooltip(tooltip, other);
			end
		end
		
		-- Record side of alignment
		if ( leftAlign ) then
			EquipCompare_Alignment = "left";
		else
			EquipCompare_Alignment = "right";
		end
		
		-- If shifting upwards is set by user or requested by an AddOn, deal with it here
		if ( ComparisonTooltip1:IsVisible() and ( EquipCompare_Shiftup or
			( EquipCompare_ShiftupObject == tooltip and EquipCompare_ShiftupSide ==
			EquipCompare_Alignment and EquipCompare_ShiftupMargin > 0 ) ) ) then
			
			if ( leftAlign ) then
				if ( ComparisonTooltip2:IsVisible() ) then
					comptipclose = ComparisonTooltip2;
					comptipfar = ComparisonTooltip1;
				else
					comptipclose = ComparisonTooltip1;
					comptipfar = ComparisonTooltip2;
				end
				point = "TOPRIGHT";
				relative = "TOPLEFT";
			else
				comptipclose = ComparisonTooltip1;
				comptipfar = ComparisonTooltip2;
				point = "TOPLEFT";
				relative = "TOPRIGHT";
			end
				
			shift = comptipclose:GetHeight()+10 - tooltip:GetHeight();
			if ( shift > 0 ) then
				comptipclose:ClearAllPoints();
				comptipclose:SetPoint(point, tooltip:GetName(), relative, 0, -10+shift);
			else
				shift = 0;
			end
			
			if ( comptipfar:IsVisible() and ( EquipCompare_Shiftup or
				EquipCompare_ShiftupMargin > comptipclose:GetWidth() ) ) then
				shift = comptipfar:GetHeight()+10 - tooltip:GetHeight() - shift;
				if ( shift > 0 ) then
					comptipfar:ClearAllPoints();
					comptipfar:SetPoint(point, comptipclose:GetName(), relative, 0, shift);
				end
			end
		end
		
		-- Restore GameTooltip_ClearMoney overriding.
		GameTooltip_ClearMoney = oldFunction;
		
		EquipCompare_Protected = false;
	end
end
