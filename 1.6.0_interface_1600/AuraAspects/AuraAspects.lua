--[[
	Aura Aspects

	By sarf

	This mod allows you to get your aspects as shapeshift buttons.

	Thanks to dsdranor for reminding me that it should fail if you do not have a Hunter.
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=392
   ]]


AURAASPECTS_SPELL_STACKABLE = {
	AURAASPECTS_AURA_TRUESHOT
};

AURAASPECTS_SPELL_ACTIVE_TEXTURE = {
	[AURAASPECTS_ASPECT_MONKEY] = "",
	[AURAASPECTS_ASPECT_HAWK] = "",
	[AURAASPECTS_ASPECT_CHEETAH] = "",
	[AURAASPECTS_ASPECT_BEAST] = "",
	[AURAASPECTS_ASPECT_PACK] = "",
	[AURAASPECTS_ASPECT_WILD] = "",
};

-- Constants
AURAASPECTS_BOOK_TYPE_SPELL = "spell";
AURAASPECTS_TIME_BETWEEN_UPDATES = 0.5;


--AURAASPECTS_TOOLTIP = "GameTooltip";
AURAASPECTS_TOOLTIP = "AuraAspectsTooltip";

AURAASPECTS_POSITION_ON_TOP_OF_PET_BAR = 1;
AURAASPECTS_POSITION_TO_LEFT_OF_PET_BAR = 2;
AURAASPECTS_POSITION_BELOW_PET_BAR = 3;

AuraAspects_ValidClasses = {
	AURAASPECTS_HUNTER_CLASS,
	AURAASPECTS_SHAMAN_CLASS
};

-- Variables
AuraAspects_Loaded = 0;
AuraAspects_Enabled = 1;
AuraAspects_PreferredPositionOnTop = 2;
AuraAspects_UsePriorityBasedAspects = 0;
AuraAspects_AllowMove = 0;

AuraAspects_TimeLastUpdated = 0;
AuraAspects_X_Offset = 0;

-- /script PrintTable(AuraAspects_FunctionsCalled);
AuraAspects_FunctionsCalled = {};
AuraAspects_ShapeshiftBar_Update_OldForms = nil;
AuraAspects_PetActionBarCurrentState = nil;

AuraAspects_Saved_GameTooltip_SetShapeshift = nil;
AuraAspects_Saved_GetNumShapeshiftForms = nil;
AuraAspects_Saved_CastShapeshiftForm = nil;
AuraAspects_Saved_GetShapeshiftFormInfo = nil;
AuraAspects_Saved_GetShapeshiftFormCooldown = nil;
AuraAspects_Saved_ShapeshiftBar_Update = nil;
AuraAspects_Saved_ShowPetActionBar = nil;
AuraAspects_Saved_HidePetActionBar = nil;
AuraAspects_Saved_SecondBar_Toggle = nil;
AuraAspects_Saved_BottomBar_Toggle = nil;
AuraAspects_Cosmos_Registered = 0;

AuraAspects_List = {};
AuraAspects_SpellNames_Priority = {
	[AURAASPECTS_HUNTER_CLASS] = {
		[1] = {
			AURAASPECTS_ASPECT_PACK,
			AURAASPECTS_ASPECT_CHEETAH
		},
	},
};


AuraAspects_SpellNames =  {
	[AURAASPECTS_RACIAL_TRAITS] = { 
			AURAASPECTS_WAR_STOMP, 
			AURAASPECTS_BERZERKER,
			AURAASPECTS_SHADOWMELD,
		},
	[AURAASPECTS_HUNTER_CLASS] = { 
			AURAASPECTS_AURA_TRUESHOT,
			AURAASPECTS_ASPECT_MONKEY,
			AURAASPECTS_ASPECT_HAWK,
			AURAASPECTS_ASPECT_BEAST,
			AURAASPECTS_ASPECT_WILD,
		},
	[AURAASPECTS_SHAMAN_CLASS] = {
			AURAASPECTS_GHOST_WOLF,
			AURAASPECTS_LIGHTNING_SHIELD,
			AURAASPECTS_WEAPON_EARTH,
			AURAASPECTS_WEAPON_FIRE,
			AURAASPECTS_WEAPON_WATER,
			AURAASPECTS_WEAPON_WIND,
			AURAASPECTS_WATER_BREATH,
			AURAASPECTS_WATER_WALK,
		},
	[AURAASPECTS_PRIEST_CLASS] = {
			AURAASPECTS_SHADOWFORM,
			AURAASPECTS_SHADOWGUARD,
			AURAASPECTS_LEVITATE,
		},
 };


function AuraAspects_GetPreferredShapeshiftBarPosition()
	if ( AuraAspects_PreferredPositionOnTop == 0 ) then
		return AURAASPECTS_POSITION_TO_LEFT_OF_PET_BAR;
	else
		return AURAASPECTS_POSITION_ON_TOP_OF_PET_BAR;
	end
end

-- executed on load, calls general set-up functions
function AuraAspects_OnLoad()
	AuraAspects_Setup_Hooks(1);
	AuraAspects_Register();
--	AuraAspects_Update_Position();
end

-- registers the mod with Cosmos
function AuraAspects_Register_Cosmos()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( AuraAspects_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_AURAASPECTS",
			"SECTION",
			TEXT(AURAASPECTS_CONFIG_HEADER),
			TEXT(AURAASPECTS_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_AURAASPECTS_HEADER",
			"SEPARATOR",
			TEXT(AURAASPECTS_CONFIG_HEADER),
			TEXT(AURAASPECTS_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_AURAASPECTS_ENABLED",
			"CHECKBOX",
			TEXT(AURAASPECTS_ENABLED),
			TEXT(AURAASPECTS_ENABLED_INFO),
			AuraAspects_Toggle_Enabled,
			AuraAspects_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_AURAASPECTS_PREFERRED_POSITION_ON_TOP",
			"CHECKBOX",
			TEXT(AURAASPECTS_PREFERRED_POSITION_ON_TOP),
			TEXT(AURAASPECTS_PREFERRED_POSITION_ON_TOP_INFO),
			AuraAspects_Toggle_PreferredPositionOnTop,
			AuraAspects_PreferredPositionOnTop
		);
		Cosmos_RegisterConfiguration(
			"COS_AURAASPECTS_USEPRIORITYBASEDASPECTS",
			"CHECKBOX",
			TEXT(AURAASPECTS_USEPRIORITYBASEDASPECTS),
			TEXT(AURAASPECTS_USEPRIORITYBASEDASPECTS_INFO),
			AuraAspects_Toggle_UsePriorityBasedAspects,
			AuraAspects_UsePriorityBasedAspects
		);

		AuraAspects_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function AuraAspects_Register()
	if ( Cosmos_RegisterConfiguration ) and ( Cosmos_UpdateValue ) then
		AuraAspects_Register_Cosmos();
	else
		SlashCmdList["AURAASPECTSSLASHENABLE"] = AuraAspects_Enable_ChatCommandHandler;
		SLASH_AURAASPECTSSLASHENABLE1 = "/auraaspectstoggle";
		SLASH_AURAASPECTSSLASHENABLE2 = "/auraasptoggle";
		SLASH_AURAASPECTSSLASHENABLE3 = "/aatoggle";
		SLASH_AURAASPECTSSLASHENABLE4 = "/auraaspectsenable";
		SLASH_AURAASPECTSSLASHENABLE5 = "/auraaspenable";
		SLASH_AURAASPECTSSLASHENABLE6 = "/aaenable";
		SLASH_AURAASPECTSSLASHENABLE7 = "/auraaspectsdisable";
		SLASH_AURAASPECTSSLASHENABLE8 = "/auraaspdisable";
		SLASH_AURAASPECTSSLASHENABLE9 = "/aadisable";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local AuraAspectsEnableCommands = {"/auraaspectstoggle","/auraasptoggle","/aatoggle","/auraaspectenable","/auraaspenable","/aaenable","/auraaspectdisable","/auraaspdisable","/aadisable"};
		Cosmos_RegisterChatCommand (
			"AURAASPECTS_ENABLE_COMMANDS", -- Some Unique Group ID
			AuraAspectsEnableCommands, -- The Commands
			AuraAspects_Enable_ChatCommandHandler,
			AURAASPECTS_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
	end
	
	this:RegisterEvent("LEARNED_SPELL_IN_TAB");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	AuraAspectsTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
end

function AuraAspects_UpdateList()
	AuraAspects_List = AuraAspects_GenerateList();
	ShapeshiftBar_Update();
end

-- Handles chat - e.g. slashcommands - enabling/disabling the AuraAspects
function AuraAspects_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);

	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		AuraAspects_Toggle_Enabled(1, nil, true);
		-- force update if toggling on (for non cosmos users mainly)
		AuraAspects_Update_Position();
		AuraAspects_ShapeshiftBar_Update();
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			AuraAspects_Toggle_Enabled(0, nil, true);
		else
			if ( strlen(msg) > 0 ) then
				if ( string.find(msg, "ontop") ) then
					AuraAspects_Toggle_PreferredPositionOnTop(-1, nil, true);
					return;
				elseif ( string.find(msg, "priority") ) then
					AuraAspects_Toggle_UsePriorityBasedAspects(-1, nil, true);
					AuraAspects_GenerateList();
					return;
				end
			end
			AuraAspects_Toggle_Enabled(-1, nil, true);
		end
	end
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function AuraAspects_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( GameTooltip.SetShapeshift ~= AuraAspects_Saved_GameTooltip_SetShapeshift) and ( AuraAspects_Saved_GameTooltip_SetShapeshift == nil ) ) then
			AuraAspects_Saved_GameTooltip_SetShapeshift = GameTooltip.SetShapeshift;
			GameTooltip.SetShapeshift = AuraAspects_GameTooltip_SetShapeshift;
		end
		if ( ( GetNumShapeshiftForms ~= AuraAspects_GetNumShapeshiftForms ) and (AuraAspects_Saved_GetNumShapeshiftForms == nil) ) then
			AuraAspects_Saved_GetNumShapeshiftForms = GetNumShapeshiftForms;
			GetNumShapeshiftForms = AuraAspects_GetNumShapeshiftForms;
		end
		if ( ( CastShapeshiftForm ~= AuraAspects_CastShapeshiftForm ) and (AuraAspects_Saved_CastShapeshiftForm == nil) ) then
			AuraAspects_Saved_CastShapeshiftForm = CastShapeshiftForm;
			CastShapeshiftForm = AuraAspects_CastShapeshiftForm;
		end
		if ( ( GetShapeshiftFormInfo ~= AuraAspects_GetShapeshiftFormInfo ) and (AuraAspects_Saved_GetShapeshiftFormInfo == nil) ) then
			AuraAspects_Saved_GetShapeshiftFormInfo = GetShapeshiftFormInfo;
			GetShapeshiftFormInfo = AuraAspects_GetShapeshiftFormInfo;
		end
		if ( ( GetShapeshiftFormCooldown ~= AuraAspects_GetShapeshiftFormCooldown ) and (AuraAspects_Saved_GetShapeshiftFormCooldown == nil) ) then
			AuraAspects_Saved_GetShapeshiftFormCooldown = GetShapeshiftFormCooldown;
			GetShapeshiftFormCooldown = AuraAspects_GetShapeshiftFormCooldown;
		end
		if ( ( ShapeshiftBar_Update ~= AuraAspects_ShapeshiftBar_Update ) and (AuraAspects_Saved_ShapeshiftBar_Update == nil) ) then
			AuraAspects_Saved_ShapeshiftBar_Update = ShapeshiftBar_Update;
			ShapeshiftBar_Update = AuraAspects_ShapeshiftBar_Update;
		end
		if ( ( ShowPetActionBar ~= AuraAspects_ShowPetActionBar ) and (AuraAspects_Saved_ShowPetActionBar == nil) ) then
			AuraAspects_Saved_ShowPetActionBar = ShowPetActionBar;
			ShowPetActionBar = AuraAspects_ShowPetActionBar;
		end
		if ( ( HidePetActionBar ~= AuraAspects_HidePetActionBar ) and (AuraAspects_Saved_HidePetActionBar == nil) ) then
			AuraAspects_Saved_HidePetActionBar = HidePetActionBar;
			HidePetActionBar = AuraAspects_HidePetActionBar;
		end
		if ( ( SecondBar_Toggle ~= AuraAspects_SecondBar_Toggle ) and (AuraAspects_Saved_SecondBar_Toggle == nil) ) then
			AuraAspects_Saved_SecondBar_Toggle = SecondBar_Toggle;
			SecondBar_Toggle = AuraAspects_SecondBar_Toggle;
		end
		if ( ( BottomBar_Toggle ~= AuraAspects_BottomBar_Toggle ) and (AuraAspects_Saved_BottomBar_Toggle == nil) ) then
			AuraAspects_Saved_BottomBar_Toggle = BottomBar_Toggle;
			BottomBar_Toggle = AuraAspects_BottomBar_Toggle;
		end
	else
		if ( ( GameTooltip.SetShapeshift == AuraAspects_Saved_GameTooltip_SetShapeshift) ) then
			GameTooltip.SetShapeshift = AuraAspects_Saved_GameTooltip_SetShapeshift;
			AuraAspects_Saved_GameTooltip_SetShapeshift = nil;
		end
		if ( GetNumShapeshiftForms == AuraAspects_GetNumShapeshiftForms) then
			GetNumShapeshiftForms = AuraAspects_Saved_GetNumShapeshiftForms;
			AuraAspects_Saved_GetNumShapeshiftForms = nil;
		end
		if ( CastShapeshiftForm == AuraAspects_CastShapeshiftForm) then
			CastShapeshiftForm = AuraAspects_Saved_CastShapeshiftForm;
			AuraAspects_Saved_CastShapeshiftForm = nil;
		end
		if ( GetShapeshiftFormInfo == AuraAspects_GetShapeshiftFormInfo) then
			GetShapeshiftFormInfo = AuraAspects_Saved_GetShapeshiftFormInfo;
			AuraAspects_Saved_GetShapeshiftFormInfo = nil;
		end
		if ( GetShapeshiftFormCooldown == AuraAspects_GetShapeshiftFormCooldown) then
			GetShapeshiftFormCooldown = AuraAspects_Saved_GetShapeshiftFormCooldown;
			AuraAspects_Saved_GetShapeshiftFormCooldown = nil;
		end
		if ( ShapeshiftBar_Update == AuraAspects_ShapeshiftBar_Update) then
			ShapeshiftBar_Update = AuraAspects_Saved_ShapeshiftBar_Update;
			AuraAspects_Saved_ShapeshiftBar_Update = nil;
		end
		if ( ShowPetActionBar == AuraAspects_ShowPetActionBar) then
			ShowPetActionBar = AuraAspects_Saved_ShowPetActionBar;
			AuraAspects_Saved_ShowPetActionBar = nil;
		end
		if ( HidePetActionBar == AuraAspects_HidePetActionBar) then
			HidePetActionBar = AuraAspects_Saved_HidePetActionBar;
			AuraAspects_Saved_HidePetActionBar = nil;
		end
		if ( SecondBar_Toggle == AuraAspects_SecondBar_Toggle) then
			SecondBar_Toggle = AuraAspects_Saved_SecondBar_Toggle;
			AuraAspects_Saved_SecondBar_Toggle = nil;
		end
		if ( BottomBar_Toggle == AuraAspects_BottomBar_Toggle) then
			BottomBar_Toggle = AuraAspects_Saved_BottomBar_Toggle;
			AuraAspects_Saved_BottomBar_Toggle = nil;
		end
	end
end

-- Handles events
function AuraAspects_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( AuraAspects_Cosmos_Registered == 0 and AuraAspects_IsPlayerCorrectClass()) then
			local value = getglobal("AuraAspects_Enabled");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AuraAspects_Toggle_Enabled(value, nil, true);
			local value = getglobal("AuraAspects_PreferredPositionOnTop");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AuraAspects_Toggle_PreferredPositionOnTop(value, nil, true);
			local value = getglobal("AuraAspects_UsePriorityBasedAspects");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			AuraAspects_Toggle_UsePriorityBasedAspects(value, nil, true);
			AuraAspects_Print("AuraAspects Loaded (Stand Alone)!");
			AuraAspects_Loaded = 1;
		end
	elseif ( event == "LEARNED_SPELL_IN_TAB" ) then
		if ( AuraAspects_Loaded == 1 ) then
			AuraAspects_UpdateList();
		end
	elseif ( event == "PLAYER_AURAS_CHANGED" ) then
		if (AuraAspects_Loaded == 1 ) then
			AuraAspects_OnUpdate();
		end
	elseif (event == "UNIT_NAME_UPDATE") then
		if (AuraAspects_Loaded == 1 and (arg1) and (arg1 == "player") ) then
			local playerName = UnitName("player");
			if ( (playerName) and 
				( playerName ~= TEXT(UKNOWNBEING ) ) and 
				( playerName ~= TEXT(UNKNOWNOBJECT) ) ) then
				value = getglobal("AuraAspects_Enabled");
				AuraAspects_Toggle_Enabled(value, nil, true);
				value = getglobal("AuraAspects_PreferredPositionOnTop");
				AuraAspects_Toggle_PreferredPositionOnTop(value, nil, true);
				AuraAspects_UpdateList();
				AuraAspects_OnUpdate();
			end
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		if (AuraAspects_IsPlayerCorrectClass()) then
			myFrame = getglobal("ShapeshiftBarFrame");
			myFrame:Show();
			--AuraAspects_Setup_Hooks(1);
			if ( AuraAspects_Loaded == 0 and AuraAspects_Cosmos_Registered == 0) then
				local value = getglobal("AuraAspects_Enabled");
				if (value == nil ) then
					-- defaults to off
					value = 0;
				end
				AuraAspects_Toggle_Enabled(value, nil, true);
				local value = getglobal("AuraAspects_PreferredPositionOnTop");
				if (value == nil ) then
					-- defaults to off
					value = 0;
				end
				AuraAspects_Toggle_PreferredPositionOnTop(value, nil, true);
				AuraAspects_Print("AuraAspects Loaded (Stand Alone)!");
				AuraAspects_Loaded = 1;
			end
			AuraAspects_Update_Position()
		end
	end
end

-- Toggles the enabled/disabled state of the AuraAspects
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function AuraAspects_Toggle_Enabled(toggle, value, showChat)
	local oldvalue = AuraAspects_Enabled;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	AuraAspects_Enabled = newvalue;
--	AuraAspects_Setup_Hooks(newvalue);
	if ( newvalue == 1 ) then
		AuraAspects_UpdateList();
	end
	if ( newvalue ~= oldvalue ) and ( showChat ) then
		if ( newvalue == 1 ) then
			AuraAspects_Print(AURAASPECTS_CHAT_ENABLED);
		else
			AuraAspects_Print(AURAASPECTS_CHAT_DISABLED);
		end
		AuraAspects_UpdateList();
	end
--	if ( AuraAspects_Cosmos_Registered == 0 ) then 
		RegisterForSave("AuraAspects_Enabled");
--	end
end

function AuraAspects_Toggle_PreferredPositionOnTop(toggle, value, showChat)
	local oldvalue = AuraAspects_PreferredPositionOnTop;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	AuraAspects_PreferredPositionOnTop = newvalue;
	if ( newvalue ~= oldvalue ) and ( showChat ) then
		if ( newvalue == 1 ) then
			AuraAspects_Print(AURAASPECTS_CHAT_PREFERRED_POSITION_ON_TOP_ENABLED);
		else
			AuraAspects_Print(AURAASPECTS_CHAT_PREFERRED_POSITION_ON_TOP_DISABLED);
		end
		AuraAspects_UpdateList();
	end
--	if ( AuraAspects_Cosmos_Registered == 0 ) then 
		RegisterForSave("AuraAspects_PreferredPositionOnTop");
--	end
end

function AuraAspects_Toggle_UsePriorityBasedAspects(toggle, value, showChat)
	local oldvalue = AuraAspects_UsePriorityBasedAspects;
	local newvalue = toggle;
	if ( ( toggle ~= 1 ) and ( toggle ~= 0 ) ) then
		if (oldvalue == 1) then
			newvalue = 0;
		elseif ( oldvalue == 0 ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
	end
	AuraAspects_UsePriorityBasedAspects = newvalue;
	if ( newvalue == 1 ) then
		AuraAspects_UpdateList();
	end
	if ( newvalue ~= oldvalue ) and ( showChat ) then
		if ( newvalue == 1 ) then
			AuraAspects_Print(AURAASPECTS_CHAT_ENABLED);
		else
			AuraAspects_Print(AURAASPECTS_CHAT_DISABLED);
		end
		AuraAspects_UpdateList();
	end
	RegisterForSave("AuraAspects_UsePriorityBasedAspects");
end

-- does not care about ranks
function AuraAspects_GetSpellId(spellName)
	local i = 1;
	local name, rankName;
	name, rankName = GetSpellName(i, AURAASPECTS_BOOK_TYPE_SPELL)
	while name do
		if ( name == spellName) then
			return i;
		end
		i = i + 1;
		name, rankName = GetSpellName(i, AURAASPECTS_BOOK_TYPE_SPELL)
	end
	return -1;
end

function AuraAspects_GetAspectCooldown(aspect)
	return GetSpellCooldown(aspect.id, AURAASPECTS_BOOK_TYPE_SPELL);
end

function AuraAspects_GetAspectTexture(aspect)
	return GetSpellTexture(aspect.id, AURAASPECTS_BOOK_TYPE_SPELL);
end


function AuraAspects_GenerateList()
	local list = {};
	local spellId = -1;
	
	for k, v in AuraAspects_SpellNames[AURAASPECTS_RACIAL_TRAITS] do 
		spellId = AuraAspects_GetSpellId(v);
		if ( spellId > -1 ) then
			table.insert(list, { id = spellId, name = v } );
		end
	end

	if ( AuraAspects_SpellNames[UnitClass("player")] ) then
		for k, v in AuraAspects_SpellNames[UnitClass("player")] do
			spellId = AuraAspects_GetSpellId(v);
			if ( spellId > -1 ) then
				table.insert(list, { id = spellId, name = v } );
	
			end
		end
	end
	if ( AuraAspects_SpellNames_Priority[UnitClass("player")] ) then
		for k, spellList in AuraAspects_SpellNames_Priority[UnitClass("player")] do 
			for key, spellName in spellList do
				spellId = AuraAspects_GetSpellId(spellName);
				if ( spellId > -1 ) then
					table.insert(list, { id = spellId, name = spellName } );
					if ( AuraAspects_UsePriorityBasedAspects == 1 ) then
						break;
					end
				end
			end
		end
	end

	return list;
end

function AuraAspects_GetNumShapeshiftForms()
	local numForms = AuraAspects_Saved_GetNumShapeshiftForms();
	if ( AuraAspects_IsEnabled() ) then
		numForms = numForms + getn(AuraAspects_List);
	end
	return numForms;
end

function AuraAspects_IsPlayerCorrectClass()
	local charClass = UnitClass("player");
	for k, v in AuraAspects_ValidClasses do
		if ( v == charClass ) then
			return true;
		end
	end
	return false;
end

function AuraAspects_IsEnabled()
	if ( ( AuraAspects_Enabled == 1 ) and ( AuraAspects_IsPlayerCorrectClass() ) ) then
		return true;
	else
		return false;
	end
end

function AuraAspects_CastShapeshiftForm(id)
	local originalForms = AuraAspects_Saved_GetNumShapeshiftForms();
	if ( ( AuraAspects_IsEnabled() ) and (id > originalForms) ) then
		local aspect = AuraAspects_List[id - originalForms];
		if ( aspect ) then
			CastSpell(aspect.id, AURAASPECTS_BOOK_TYPE_SPELL);
		else	
			Print("INVALID AURAASPECT ID "..(id - originalForms));
		end
	else
		AuraAspects_Saved_CastShapeshiftForm(id);
	end
end

function AuraAspects_IsAspectActive(aspect)
	--return AuraAspects_HasPlayerEffect(AuraAspects_GetAspectTexture(aspect));
	return AuraAspects_PlayerHasSpellEnabled(aspect);
end

function AuraAspects_GetListedSpellId(name)
	for k, v in AuraAspects_List do
		if ( v.name == name ) then
			return v.id;
		end
	end
	return -1;
end

function AuraAspects_GetShapeshiftFormInfo(id)
	local originalForms = AuraAspects_Saved_GetNumShapeshiftForms();
	if ( ( AuraAspects_IsEnabled() ) and (id > originalForms) ) then
		local aspect = AuraAspects_List[id - originalForms];
		if ( not aspect ) then
			--Print("INVALID ASPECT ID "..(id - originalForms));
			return nil, nil, nil;
		end
		local texture, name, isActive, isCastable;
		texture = GetSpellTexture(aspect.id, AURAASPECTS_BOOK_TYPE_SPELL);
		if ( AuraAspects_IsAspectActive(aspect) ) then
			isActive = 1;
		else
			isActive = nil;
		end
--		isActive = AuraAspects_IsAspectActive(aspect);
		isCastable = true;
		name = aspect.name;
		return texture, name, isActive, isCastable;
	else
		return AuraAspects_Saved_GetShapeshiftFormInfo(id);
	end
end

function AuraAspects_GetShapeshiftFormCooldown(id)
	local originalForms = AuraAspects_Saved_GetNumShapeshiftForms();
	if ( ( AuraAspects_IsEnabled() ) and (id > originalForms) ) then
		local aspect = AuraAspects_List[id - originalForms];
		if ( not aspect ) then
			Print("INVALID ASPECT ID "..(id - originalForms));
			return nil, nil, nil;
		end
		local start, duration, enable = AuraAspects_GetAspectCooldown(aspect);
		return start, duration, enable;
	else
		return AuraAspects_Saved_GetShapeshiftFormCooldown(id);
	end
end

function AuraAspects_FixShapeshiftingActionBar(id, wasActive)
end

function AuraAspects_OnUpdate()
	-- make sure bar is updated if AuraAspects is enable, for non-cosmos users mainly
	if ( AuraAspects_IsEnabled() ) 
	then
		AuraAspects_Update_Position();
		AuraAspects_ShapeshiftBar_Update();
	end
end

function AuraAspects_HasBuffTexture(texture)
	local id = 1;
	for id = 1, 15 do
		if ( GetPlayerBuffTexture(id) == texture ) then
			return true;
		end
	end
	return false;
end

function AuraAspects_DumpBuffs()
	AuraAspects_DumpedBuffs = {};
	local i = 1;
	local buffName;
	RegisterForSave("AuraAspects_DumpedBuffs");
	AuraAspects_Print("Dumping buffs:");
	local buffs = {};
	buffName = AuraAspects_GetBuffName("player", i);
	while buffName do
		AuraAspects_Print(format("%d. [%s]", i, buffName));
		buffs[i] = buffName;
		i = i + 1;
		buffName = AuraAspects_GetBuffName("player", i);
	end
	
	AuraAspects_DumpedBuffs["buffs"] = buffs;
	RegisterForSave("AuraAspects_DumpedBuffs");
end


-- tooltip helper function
AURAASPECTS_TOOLTIPS_UNSAFE_FRAMES = { 
   "TaxiFrame", "MerchantFrame", "TradeSkillFrame", "SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
   }; 

-- use this to add unsafe frames 
function AuraAspects_TooltipsCanNotBeUsedWithFrame(frame) 
   table.insert(AURAASPECTS_TOOLTIPS_UNSAFE_FRAMES, frame); 
end 


-- will return 1 if it is "safe" to use tooltips, otherwise 0 
function AuraAspects_TooltipsCanBeUsed() 
   local frame = nil; 
   for k, v in AURAASPECTS_TOOLTIPS_UNSAFE_FRAMES do 
      frame = getglobal(v); 
      if ( ( frame ) and ( frame:IsVisible() ) ) then 
         return false; 
      end 
   end 
   return true; 
end

function AuraAspects_IsSpellStackable(name)
	for k, v in AURAASPECTS_SPELL_STACKABLE do
		if ( v == name ) then
			return true;
		end
	end
	return false;
end

function AuraAspects_IsSpellActive(name)
	local spellId = AuraAspects_GetListedSpellId(name);
	if ( spellId == -1 ) then
		return false;
	end
	local texture = GetSpellTexture(spellId, AURAASPECTS_BOOK_TYPE_SPELL);
	return ( AURAASPECTS_SPELL_ACTIVE_TEXTURE[name] == texture );
end

function AuraAspects_PlayerHasSpellEnabled(name)
	if ( AuraAspects_IsSpellStackable(name) ) then
		if ( AuraAspects_IsSpellActive(name) ) then
			return true;
		else
			return false;
		end
	elseif ( not AuraAspects_PlayerHasBuff(name) ) then
		return false;
	else
		return true;
	end
end


function AuraAspects_PlayerHasBuff(name)
	local i = 0;
	local buffName = AuraAspects_GetBuffName("player", i);
	while buffName do
		if ( buffName == name ) then
			return true;
		end
		i = i + 1;
		buffName = AuraAspects_GetBuffName("player", i);
	end
	return false;
end


function AuraAspects_Update_Position()
	if ( AuraAspects_AllowMove == 0 ) then
		return;
	end
	local curTime = GetTime();
	local timeLeftToNextUpdate = curTime - AuraAspects_TimeLastUpdated;
	if ( timeLeftToNextUpdate < AURAASPECTS_TIME_BETWEEN_UPDATES ) then
		if ( Cosmos_ScheduleByName ) then
			Cosmos_ScheduleByName("AURAASPECTS_POSITION", AURAASPECTS_TIME_BETWEEN_UPDATES - (timeLeftToNextUpdate), AuraAspects_Update_Position);
		end
		return;
	end
	if ( ShapeshiftBarFrame:IsVisible() ) then
		local attachFrame = "MainMenuBar";
		if ( SecondBar ) and ( SecondBar:IsVisible() ) then
			attachFrame = "SecondBar";
		elseif ( BottomBar ) and ( BottomBar:IsVisible() ) then
			attachFrame = "BottomBar";
		end
		local attachFrameHeightOffset = 0;
		local attachFrameObject = getglobal(attachFrame);
		if ( attachFrameObject ) then
			attachFrameHeightOffset = attachFrameHeightOffset+ceil(attachFrameObject:GetHeight());
		end
		ShapeshiftBarFrame:ClearAllPoints();
		if ( PetActionBarFrame:IsVisible() ) then
			--ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "TOPLEFT", 0, -10);
			local preferredPosition = AuraAspects_GetPreferredShapeshiftBarPosition();
			if ( preferredPosition == AURAASPECTS_POSITION_ON_TOP_OF_PET_BAR ) then
            	ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "TOPLEFT", 23, -5);
			elseif ( preferredPosition == AURAASPECTS_POSITION_TO_LEFT_OF_PET_BAR ) then
				ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", attachFrame, "TOPLEFT", 30, 0);
				
				local shapeShiftButtons = GetNumShapeshiftForms();
				local xOffset = AuraAspects_X_Offset;
				if ( shapeShiftButtons > 0 ) then
					xOffset = xOffset + 4;
				end
				xOffset = xOffset + shapeShiftButtons * 37;
				PetActionBarFrame:ClearAllPoints();
				PetActionBarFrame:SetPoint("BOTTOMLEFT", "ShapeshiftBarFrame", "BOTTOMLEFT", xOffset, 0);
			elseif ( preferredPosition == AURAASPECTS_POSITION_BELOW_PET_BAR ) then
				ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", attachFrame, "TOPLEFT", 30, 0);
				PetActionBarFrame:SetPoint("BOTTOMLEFT", "ShapeshiftBarFrame", "TOPLEFT", -10, 0);
			end
		else
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", attachFrame, "TOPLEFT", 30, 0);
		end
	end
	AuraAspects_TimeLastUpdated = curTime;
end

function AuraAspects_AddFunctionCall(func)
	if ( not AuraAspects_FunctionsCalled[func] ) then
		AuraAspects_FunctionsCalled[func] = 0;
	end
	AuraAspects_FunctionsCalled[func] = AuraAspects_FunctionsCalled[func] + 1;
end

function AuraAspects_SecondBar_Toggle(toggle)
	AuraAspects_Saved_SecondBar_Toggle(toggle);
	if ( AuraAspects_Enabled == 1 ) then
		AuraAspects_Update_Position();
	end
end

function AuraAspects_BottomBar_Toggle(toggle)
	AuraAspects_Saved_BottomBar_Toggle(toggle);
	if ( AuraAspects_Enabled == 1 ) then
		AuraAspects_Update_Position();
	end
end

function AuraAspects_ShapeshiftBar_Update()
	if ( AuraAspects_Enabled == 1 ) and ( AuraAspects_AllowMove == 1 ) then
		local oldFrame = getglobal("ShapeshiftBarFrame");
		AuraAspectsTempFrame.lastSelected = ShapeshiftBarFrame.lastSelected;
		setglobal("ShapeshiftBarFrame", getglobal("AuraAspectsTempFrame"));
		AuraAspects_Saved_ShapeshiftBar_Update();
		setglobal("ShapeshiftBarFrame", oldFrame);
		ShapeshiftBarFrame.lastSelected = AuraAspectsTempFrame.lastSelected;
		AuraAspects_Update_Position();
	else
		AuraAspects_Saved_ShapeshiftBar_Update();
	end
end

function AuraAspects_ShowPetActionBar()
	AuraAspects_Saved_ShowPetActionBar();
	if ( AuraAspects_Enabled == 1 ) then
		AuraAspects_Update_Position();
	end
end


function AuraAspects_HidePetActionBar()
	AuraAspects_Saved_HidePetActionBar();
	if ( AuraAspects_Enabled == 1 ) then
		AuraAspects_Update_Position();
	end
end

-- thanks to Munelear for this piece of code (somewhat modified but... credit where credit is due) !
function AuraAspects_GetBuffName(unit,i,debuff)
	local buffindex;
	local buff;
	
	local buffFilter = "HELPFUL|PASSIVE";
	
	if (debuff ~= nil) then
		buffFilter = "HARMFUL";
	end
	buffindex = i;
	if (buffindex < 24) then
		buff = GetPlayerBuff(buffindex, buffFilter);
		if (buff == -1) then
			buff = nil;
		end
	end
	
	if (buff) then
		local tooltip = getglobal(AURAASPECTS_TOOLTIP);
		if ( AuraAspects_TooltipsCanBeUsed() ) then
			local name = nil;
			if (unit == "player") then
				if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
					DynamicData.util.protectTooltipMoney();
				end
				tooltip:SetPlayerBuff(buff);
				if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.unprotectTooltipMoney ) then
					DynamicData.util.unprotectTooltipMoney();
				end
				local tooltiptext = getglobal(AURAASPECTS_TOOLTIP.."TextLeft1");
				name = tooltiptext:GetText();
			end
			if ( name ~= nil ) then
				return name;
			end
		else
		end
	end
	return nil;
end


-- Prints out text to a chat box.
function AuraAspects_Print(msg,r,g,b,frame,id,unknown4th)
	if(unknown4th) then
		local temp = id;
		id = unknown4th;
		unknown4th = id;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 1.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id,unknown4th);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id,unknown4th);
		end
	end
end

function AuraAspects_HasPlayerEffect(texture)
	if ( texture ) then
		for id = 0, 24 do
			if ( GetPlayerBuffTexture(id) == texture ) then
				return true;
			end
		end
		local icon = GetTrackingTexture();
		if ( icon == texture ) then 
			return true;
		end
	end
	return false;
end



function AuraAspects_GetRankAsNumber(rankName)
	if ( rankName ) then
		local index, index2 = strfind(rankName, AURAASPECTS_RANK);
		if ( ( index ) and (index2 ) ) then
			local tmpStr = strsub(rankName, index2+1);
			while ( ( tmpStr) and ( strlen(tmpStr) > 1 ) and ( strsub(tmpStr, 1, 1) == " " ) ) do
				tmpStr = strsub(tmpStr, 2);
			end
			local i = tonumber(tmpStr);
			if ( i ) then
				return i;
			else
				return 0;
			end
		else
			return 0;
		end
	else
		return 0;
	end
end


function AuraAspects_GetSpellId(spellName, spellRank, spellBook)
	local i = 1;
	local highestId = -1;
	local highestRankSoFar = -1;
	local rank;
	local spellRankNumber = 0;
	if (spellRank) then
		spellRankNumber = tonumber(spellRank);
		if (spellRankNumber) then
			spellRankNumber = 0;
		end
	end
	if ( not spellBook ) then
		spellBook = AURAASPECTS_BOOK_TYPE_SPELL;
	end
	local name, rankName;
	name, rankName = GetSpellName(i, spellBook);
	while name do
		if ( name == spellName) then
			if ( spellRank == nil ) then
				rank = AuraAspects_GetRankAsNumber(rankName);
				if ( rank ) then
					if ( rank > highestRankSoFar ) then
						highestRankSoFar = rank;
						highestId = i;
					end
				else
					return i;
				end
			else
				rank = AuraAspects_GetRankAsNumber(rankName);
				if ( rank == spellRankNumber ) then
					highestId = i;
					break;
				elseif ( rank > highestRankSoFar ) then
					highestRankSoFar = rank;
					highestId = i;
				end
			end
		end
		i = i + 1;
		name, rankName = GetSpellName(i, spellBook)
	end
	return highestId;
end

function AuraAspects_GameTooltip_SetShapeshift(tooltip, id)
	local originalForms = AuraAspects_Saved_GetNumShapeshiftForms();
	if ( ( AuraAspects_IsEnabled() ) and (id > originalForms) ) then
		local aspect = AuraAspects_List[id - originalForms];
		if ( not aspect ) then
			--Print("INVALID ASPECT ID "..(id - originalForms));
			return;
		end
		return tooltip:SetSpell(aspect.id, AURAASPECTS_BOOK_TYPE_SPELL);
	else
		return AuraAspects_Saved_GameTooltip_SetShapeshift(tooltip, id);
	end
end