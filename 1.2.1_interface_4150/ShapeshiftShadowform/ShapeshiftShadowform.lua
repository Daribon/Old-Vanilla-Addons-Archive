--[[
	Shapeshift Shadowform

	By sarf

	This mod allows you to shapeshift in/out of Shadowform using the shapeshift bar.

	Great thanks goes to shine-shine of the CosmosUI boards for suggesting this and helping me debug it!
	
	CosmosUI URL:
	http://www.cosmosui.org/forums/viewtopic.php?t=392
	
   ]]


-- Constants
SHAPESHIFTSHADOWFORM_BOOK_TYPE_SPELL = "spell";
SHAPESHIFTSHADOWFORM_SPELL_NAME = "Shadowform";
SHAPESHIFTSHADOWFORM_BUFF_NAME = "Shadowform";
SHAPESHIFTSHADOWFORM_ACTIVE_TEXTURE = "Interface\\Icons\\Spell_Shadow_ChillTouch";
SHAPESHIFTSHADOWFORM_NORMAL_TEXTURE = "Interface\\Icons\\Spell_Shadow_Shadowform";

--SHAPESHIFTSHADOWFORM_TOOLTIP = "GameTooltip";
SHAPESHIFTSHADOWFORM_TOOLTIP = "ShapeshiftShadowformTooltip";

-- Variables
ShapeshiftShadowform_Enabled = 0;
ShapeshiftShadowform_FormId = -1;
ShapeshiftShadowform_OldActionBar = -1;
ShapeshiftShadowform_WasActiveAtLastUpdate = false;

ShapeshiftShadowform_Saved_GetNumShapeshiftForms = nil;
ShapeshiftShadowform_Saved_CastShapeshiftForm = nil;
ShapeshiftShadowform_Saved_GetShapeshiftFormInfo = nil;
ShapeshiftShadowform_Saved_GetShapeshiftFormCooldown = nil;
ShapeshiftShadowform_Saved_ChangeActionBarPage = nil;
ShapeshiftShadowform_Cosmos_Registered = 0;

-- executed on load, calls general set-up functions
function ShapeshiftShadowform_OnLoad()
	ShapeshiftShadowform_Register();
end

-- registers the mod with Cosmos
function ShapeshiftShadowform_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( ShapeshiftShadowform_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_SS_SHADOWFORM",
			"SECTION",
			TEXT(SHAPESHIFTSHADOWFORM_CONFIG_HEADER),
			TEXT(SHAPESHIFTSHADOWFORM_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_SS_SHADOWFORM_HEADER",
			"SEPARATOR",
			TEXT(SHAPESHIFTSHADOWFORM_CONFIG_HEADER),
			TEXT(SHAPESHIFTSHADOWFORM_CONFIG_HEADER_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_SS_SHADOWFORM_ENABLED",
			"CHECKBOX",
			TEXT(SHAPESHIFTSHADOWFORM_ENABLED),
			TEXT(SHAPESHIFTSHADOWFORM_ENABLED_INFO),
			ShapeshiftShadowform_Toggle_Enabled,
			ShapeshiftShadowform_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_SS_SHADOWFORM_RESET_ACTIONBAR",
			"BUTTON",
			TEXT(SHAPESHIFTSHADOWFORM_RESET_ACTIONBAR),
			TEXT(SHAPESHIFTSHADOWFORM_RESET_ACTIONBAR_INFO),
			ShapeshiftShadowform_Reset_ActionBar,
			0,
			0,
			0,
			0,
			SHAPESHIFTSHADOWFORM_RESET_ACTIONBAR_NAME
		);
		ShapeshiftShadowform_Cosmos_Registered = 1;
	end
end

-- registers the mod with the system, integrating it with slash commands and "master" AddOns
function ShapeshiftShadowform_Register()
	if ( Cosmos_RegisterConfiguration ) then
		ShapeshiftShadowform_Register_Cosmos();
	else
		SlashCmdList["SHAPESHIFTSHADOWFORMSLASHENABLE"] = ShapeshiftShadowform_Enable_ChatCommandHandler;
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE1 = "/shapeshiftshadowformtoggle";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE2 = "/ssshadowformtoggle";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE3 = "/sssftoggle";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE4 = "/shapeshiftshadowformenable";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE5 = "/ssshadowformenable";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE6 = "/sssfenable";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE7 = "/shapeshiftshadowformdisable";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE8 = "/ssshadowformdisable";
		SLASH_SHAPESHIFTSHADOWFORMSLASHENABLE9 = "/sssfdisable";
		SlashCmdList["SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR"] = ShapeshiftShadowform_Reset_ActionBar_ChatCommandHandler;
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR1 = "/shapeshiftshadowformresetactionbar";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR2 = "/sshadowformresetactionbar";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR3 = "/sssfresetactionbar";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR4 = "/sssfrab";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR5 = "/shapeshiftshadowformresetbar";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR6 = "/sshadowformresetbar";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR7 = "/sssfresetbar";
		SLASH_SHAPESHIFTSHADOWFORMSLASHRESETACTIONBAR8 = "/sssfrb";
		this:RegisterEvent("VARIABLES_LOADED");
	end

	if ( Cosmos_RegisterChatCommand ) then
		local ShapeshiftShadowformEnableCommands = {"/shapeshiftshadowformtoggle","/ssshadowformtoggle","/sssftoggle","/shapeshiftShadowformenable","/ssshadowformenable","/sssfenable","/shapeshiftShadowformdisable","/ssshadowformdisable","/sssfdisable"};
		Cosmos_RegisterChatCommand (
			"SHAPESHIFTSHADOWFORM_ENABLE_COMMANDS", -- Some Unique Group ID
			ShapeshiftShadowformEnableCommands, -- The Commands
			ShapeshiftShadowform_Enable_ChatCommandHandler,
			SHAPESHIFTSHADOWFORM_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
		local ShapeshiftShadowformResetActionBarCommands = {"/shapeshiftshadowformresetactionbar","/sshadowformresetactionbar","/sssfresetactionbar","/sssfrab","/shapeshiftshadowformresetbar","/sshadowformresetbar","/sssfresetbar","/sssfrb"};
		Cosmos_RegisterChatCommand (
			"SHAPESHIFTSHADOWFORM_RESET_ACTIONBAR_COMMANDS", -- Some Unique Group ID
			ShapeshiftShadowformResetActionBarCommands, -- The Commands
			ShapeshiftShadowform_Reset_ActionBar_ChatCommandHandler,
			SHAPESHIFTSHADOWFORM_CHAT_COMMAND_RESET_ACTIONBAR_INFO -- Description String
		);
	end
	
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	ShapeshiftShadowformTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
end


function ShapeshiftShadowform_Reset_ActionBar()
	ShapeshiftShadowform_OldActionBar = -1;
	if ( CURRENT_ACTIONBAR_PAGE ~= 1 ) then
		CURRENT_ACTIONBAR_PAGE = 1;
		ChangeActionBarPage();
	end
	ShapeshiftShadowform_Print(SHAPESHIFTSHADOWFORM_CHAT_RESET_ACTIONBAR);
end

function ShapeshiftShadowform_Reset_ActionBar_ChatCommandHandler()
	ShapeshiftShadowform_Reset_ActionBar();
end

-- Handles chat - e.g. slashcommands - enabling/disabling the ShapeshiftShadowform
function ShapeshiftShadowform_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		ShapeshiftShadowform_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			ShapeshiftShadowform_Toggle_Enabled(0);
		else
			ShapeshiftShadowform_Toggle_Enabled(-1);
		end
	end
end

-- Hooks/unhooks functions. If toggle is 1, hooks functions, otherwise it unhooks functions.
--  Hooking functions mean that you replace them with your own functions and then call the 
--  original function at your leisure.
function ShapeshiftShadowform_Setup_Hooks(toggle)
	if ( toggle == 1 ) then
		if ( ( ChangeActionBarPage ~= ShapeshiftShadowform_ChangeActionBarPage ) and (ShapeshiftShadowform_Saved_ChangeActionBarPage == nil) ) then
			ShapeshiftShadowform_Saved_ChangeActionBarPage = ChangeActionBarPage;
			ChangeActionBarPage = ShapeshiftShadowform_ChangeActionBarPage;
		end
		if ( ( GetNumShapeshiftForms ~= ShapeshiftShadowform_GetNumShapeshiftForms ) and (ShapeshiftShadowform_Saved_GetNumShapeshiftForms == nil) ) then
			ShapeshiftShadowform_Saved_GetNumShapeshiftForms = GetNumShapeshiftForms;
			GetNumShapeshiftForms = ShapeshiftShadowform_GetNumShapeshiftForms;
		end
		if ( ( CastShapeshiftForm ~= ShapeshiftShadowform_CastShapeshiftForm ) and (ShapeshiftShadowform_Saved_CastShapeshiftForm == nil) ) then
			ShapeshiftShadowform_Saved_CastShapeshiftForm = CastShapeshiftForm;
			CastShapeshiftForm = ShapeshiftShadowform_CastShapeshiftForm;
		end
		if ( ( GetShapeshiftFormInfo ~= ShapeshiftShadowform_GetShapeshiftFormInfo ) and (ShapeshiftShadowform_Saved_GetShapeshiftFormInfo == nil) ) then
			ShapeshiftShadowform_Saved_GetShapeshiftFormInfo = GetShapeshiftFormInfo;
			GetShapeshiftFormInfo = ShapeshiftShadowform_GetShapeshiftFormInfo;
		end
		if ( ( GetShapeshiftFormCooldown ~= ShapeshiftShadowform_GetShapeshiftFormCooldown ) and (ShapeshiftShadowform_Saved_GetShapeshiftFormCooldown == nil) ) then
			ShapeshiftShadowform_Saved_GetShapeshiftFormCooldown = GetShapeshiftFormCooldown;
			GetShapeshiftFormCooldown = ShapeshiftShadowform_GetShapeshiftFormCooldown;
		end

	else

		if ( ChangeActionBarPage == ShapeshiftShadowform_ChangeActionBarPage) then
			ChangeActionBarPage = ShapeshiftShadowform_Saved_ChangeActionBarPage;
			ShapeshiftShadowform_Saved_ChangeActionBarPage = nil;
		end
		if ( GetNumShapeshiftForms == ShapeshiftShadowform_GetNumShapeshiftForms) then
			GetNumShapeshiftForms = ShapeshiftShadowform_Saved_GetNumShapeshiftForms;
			ShapeshiftShadowform_Saved_GetNumShapeshiftForms = nil;
		end
		if ( CastShapeshiftForm == ShapeshiftShadowform_CastShapeshiftForm) then
			CastShapeshiftForm = ShapeshiftShadowform_Saved_CastShapeshiftForm;
			ShapeshiftShadowform_Saved_CastShapeshiftForm = nil;
		end
		if ( GetShapeshiftFormInfo == ShapeshiftShadowform_GetShapeshiftFormInfo) then
			GetShapeshiftFormInfo = ShapeshiftShadowform_Saved_GetShapeshiftFormInfo;
			ShapeshiftShadowform_Saved_GetShapeshiftFormInfo = nil;
		end
		if ( GetShapeshiftFormCooldown == ShapeshiftShadowform_GetShapeshiftFormCooldown) then
			GetShapeshiftFormCooldown = ShapeshiftShadowform_Saved_GetShapeshiftFormCooldown;
			ShapeshiftShadowform_Saved_GetShapeshiftFormCooldown = nil;
		end

	end
end

-- Handles events
function ShapeshiftShadowform_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if ( ShapeshiftShadowform_Cosmos_Registered == 0 ) then
			local value = getglobal("COS_SS_SHADOWFORM_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			ShapeshiftShadowform_Toggle_Enabled(value);
		end
		return;
	end
	if ( event == "PLAYER_AURAS_CHANGED" ) then
		ShapeshiftShadowform_OnUpdate();
		return;
	end
end

-- Toggles the enabled/disabled state of the ShapeshiftShadowform
--  if toggle is 1, it's enabled
--  if toggle is 0, it's disabled
--   otherwise, it's toggled
function ShapeshiftShadowform_Toggle_Enabled(toggle)
	local oldvalue = ShapeshiftShadowform_Enabled;
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
	ShapeshiftShadowform_Enabled = newvalue;
	setglobal("COS_SS_SHADOWFORM_ENABLED_X", newvalue);
	ShapeshiftShadowform_Setup_Hooks(newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			ShapeshiftShadowform_Print(SHAPESHIFTSHADOWFORM_CHAT_ENABLED);
		else
			ShapeshiftShadowform_Print(SHAPESHIFTSHADOWFORM_CHAT_DISABLED);
		end
		-- force update so that buttons get updated
		ShapeshiftBar_Update();
	end
	if ( ShapeshiftShadowform_Cosmos_Registered == 0 ) then 
		RegisterForSave("COS_SS_SHADOWFORM_ENABLED_X");
	end
end

-- does not care about ranks
function ShapeshiftShadowform_GetSpellId(spellName)
	local i = 1;
	local name, rankName;
	name, rankName = GetSpellName(i, SHAPESHIFTSHADOWFORM_BOOK_TYPE_SPELL)
	while name do
		if ( name == spellName) then
			return i;
		end
		i = i + 1;
		name, rankName = GetSpellName(i, SHAPESHIFTSHADOWFORM_BOOK_TYPE_SPELL)
	end
	return -1;
end

function ShapeshiftShadowform_GetShadowformId()
	-- this should be cached and only updated on spellbook update
	return ShapeshiftShadowform_GetSpellId(SHAPESHIFTSHADOWFORM_SPELL_NAME);
end

function ShapeshiftShadowform_HasPlayerShadowform()
	if ( ShapeshiftShadowform_GetShadowformId() > -1 ) then
		return true;
	else
		return false;
	end
end

function ShapeshiftShadowform_GetShadowformCooldown()
	return GetSpellCooldown(ShapeshiftShadowform_GetShadowformId(), SHAPESHIFTSHADOWFORM_BOOK_TYPE_SPELL);
end

function ShapeshiftShadowform_GetShadowformTexture()
	return GetSpellTexture(ShapeshiftShadowform_GetShadowformId(), SHAPESHIFTSHADOWFORM_BOOK_TYPE_SPELL);
end


function ShapeshiftShadowform_GetShadowformShapeshiftId()
	return ShapeshiftShadowform_FormId;
end

function ShapeshiftShadowform_GetNumShapeshiftForms()
	local numForms = ShapeshiftShadowform_Saved_GetNumShapeshiftForms();
	if ( ( ShapeshiftShadowform_Enabled == 1 ) and ( ShapeshiftShadowform_HasPlayerShadowform() ) ) then
		numForms = numForms + 1;
		ShapeshiftShadowform_FormId = numForms;
	end
	return numForms;
end

function ShapeshiftShadowform_CastShapeshiftForm(id)
	if ( ( ShapeshiftShadowform_Enabled == 1 ) and (ShapeshiftShadowform_GetShadowformShapeshiftId() == id) ) then
		--ShapeshiftShadowform_Saved_CastShapeshiftForm(id);
		CastSpell(ShapeshiftShadowform_GetShadowformId(), SHAPESHIFTSHADOWFORM_BOOK_TYPE_SPELL);
	else
		ShapeshiftShadowform_Saved_CastShapeshiftForm(id);
	end
end

function ShapeshiftShadowform_IsShadowformActive()
	return ShapeshiftShadowform_HasBuffTexture(SHAPESHIFTSHADOWFORM_NORMAL_TEXTURE);
	--return ShapeshiftShadowform_PlayerHasBuff(SHAPESHIFTSHADOWFORM_BUFF_NAME);
end

function ShapeshiftShadowform_ChangeActionBarPage()
	if ( ( ShapeshiftShadowform_Enabled == 1 ) and (ShapeshiftShadowform_IsShadowformActive()) ) then
		if ( CURRENT_ACTIONBAR_PAGE == 1 ) then
			CURRENT_ACTIONBAR_PAGE = ShapeshiftShadowform_GetShadowformShapeshiftId() + 6;
			ShapeshiftShadowform_Saved_ChangeActionBarPage()
			--CURRENT_ACTIONBAR_PAGE = 1;
			return;
		end
	end
	ShapeshiftShadowform_Saved_ChangeActionBarPage()
end

function ShapeshiftShadowform_GetShapeshiftFormInfo(id)
	if ( ( ShapeshiftShadowform_Enabled == 1 ) and (ShapeshiftShadowform_GetShadowformShapeshiftId() == id) ) then
		local texture, name, isActive, isCastable;
		texture = ShapeshiftShadowform_GetShadowformTexture();
		isActive = ShapeshiftShadowform_IsShadowformActive();
		-- fix to darken it while active
		if ( isActive ) then
			texture = SHAPESHIFTSHADOWFORM_ACTIVE_TEXTURE;
			isCastable = false;
		else
			isCastable = true;
		end
		name = SHAPESHIFTSHADOWFORM_SPELL_NAME;
		return texture, name, isActive, isCastable;
	else
		return ShapeshiftShadowform_Saved_GetShapeshiftFormInfo(id);
	end
end

function ShapeshiftShadowform_GetShapeshiftFormCooldown(id)
	if ( ( ShapeshiftShadowform_Enabled == 1 ) and (ShapeshiftShadowform_GetShadowformShapeshiftId() == id) ) then
		local start, duration, enable = ShapeshiftShadowform_GetShadowformCooldown();
		return start, duration, enable;
	else
		return ShapeshiftShadowform_Saved_GetShapeshiftFormCooldown(id);
	end
end

function ShapeshiftShadowform_FixShapeshiftingActionBar(id, wasActive)
	local tempOldActionBar = CURRENT_ACTIONBAR_PAGE;
	if ( wasActive ) then
		-- switch back to old action bar
		if ( ShapeshiftShadowform_OldActionBar > -1 ) then
			CURRENT_ACTIONBAR_PAGE = ShapeshiftShadowform_OldActionBar;
		else
			CURRENT_ACTIONBAR_PAGE = 1;
		end
	else
		-- switch to action bar id+6
		ShapeshiftShadowform_OldActionBar = CURRENT_ACTIONBAR_PAGE;
		CURRENT_ACTIONBAR_PAGE = id+6;
	end
	if ( tempOldActionBar ~= CURRENT_ACTIONBAR_PAGE ) then
		ChangeActionBarPage();
	end
end

function ShapeshiftShadowform_OnUpdate()
	if ( ( ShapeshiftShadowform_Enabled == 1 ) ) then
		local id = ShapeshiftShadowform_GetShadowformShapeshiftId();
		local isActive = ShapeshiftShadowform_IsShadowformActive();
		if ( ShapeshiftShadowform_WasActiveAtLastUpdate ) then
			if ( not isActive ) then
				if ( CURRENT_ACTIONBAR_PAGE == (id + 6) ) then
					ShapeshiftShadowform_FixShapeshiftingActionBar(id, true);
				end
			end
		else
			if ( isActive ) then
				ShapeshiftShadowform_FixShapeshiftingActionBar(id, false);
			end
		end
		ShapeshiftShadowform_WasActiveAtLastUpdate = isActive;
	end

end

function ShapeshiftShadowform_HasBuffTexture(texture)
	local id = 1;
	for id = 1, 15 do
		if ( GetPlayerBuffTexture(id) == texture ) then
			return true;
		end
	end
	return false;
end

function ShapeshiftShadowform_DumpBuffs()
	ShapeshiftShadowform_DumpedBuffs = {};
	local i = 1;
	local buffName;
	RegisterForSave("ShapeshiftShadowform_DumpedBuffs");
	ShapeshiftShadowform_Print("Dumping buffs:");
	local buffs = {};
	buffName = ShapeshiftShadowform_GetBuffName("player", i);
	while buffName do
		ShapeshiftShadowform_Print(format("%d. [%s]", i, buffName));
		buffs[i] = buffName;
		i = i + 1;
		buffName = ShapeshiftShadowform_GetBuffName("player", i);
	end
	
	ShapeshiftShadowform_DumpedBuffs["buffs"] = buffs;
	RegisterForSave("ShapeshiftShadowform_DumpedBuffs");
end


-- tooltip helper function
SHAPESHIFTSHADOWFORM_TOOLTIPS_UNSAFE_FRAMES = { 
   "TaxiFrame", "MerchantFrame", "TradeSkillFrame", "SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
   }; 

-- use this to add unsafe frames 
function ShapeshiftShadowform_TooltipsCanNotBeUsedWithFrame(frame) 
   table.insert(SHAPESHIFTSHADOWFORM_TOOLTIPS_UNSAFE_FRAMES, frame); 
end 


-- will return 1 if it is "safe" to use tooltips, otherwise 0 
function ShapeshiftShadowform_TooltipsCanBeUsed() 
   local frame = nil; 
   for k, v in SHAPESHIFTSHADOWFORM_TOOLTIPS_UNSAFE_FRAMES do 
      frame = getglobal(v); 
      if ( ( frame ) and ( frame:IsVisible() ) ) then 
         return false; 
      end 
   end 
   return true; 
end

function ShapeshiftShadowform_PlayerHasBuff(name)
	local i = 0;
	local buffName = ShapeshiftShadowform_GetBuffName("player", i);
	while buffName do
		if ( buffName == name ) then
			return true;
		end
		i = i + 1;
		buffName = ShapeshiftShadowform_GetBuffName("player", i);
	end
	return false;
end

-- thanks to Munelear for this piece of code (somewhat modified but... credit where credit is due) !
function ShapeshiftShadowform_GetBuffName(unit,i,debuff)
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
		local tooltip = getglobal(SHAPESHIFTSHADOWFORM_TOOLTIP);
		if ( ShapeshiftShadowform_TooltipsCanBeUsed() ) then
			local name = nil;
			if (unit == "player") then
				if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
					DynamicData.util.protectTooltipMoney();
				elseif ( Sea ) and ( Sea.wow ) and ( Sea.wow.tooltip ) and ( Sea.wow.tooltip.protectTooltipMoney ) then
					Sea.wow.tooltip.protectTooltipMoney();
				end 
				tooltip:SetPlayerBuff(buff);
				if ( DynamicData ) and ( DynamicData.util ) and ( DynamicData.util.protectTooltipMoney ) then
					DynamicData.util.unprotectTooltipMoney();
				elseif ( Sea ) and ( Sea.wow ) and ( Sea.wow.tooltip ) and ( Sea.wow.tooltip.unprotectTooltipMoney ) then
					Sea.wow.tooltip.unprotectTooltipMoney();
				end 
				local tooltiptext = getglobal(SHAPESHIFTSHADOWFORM_TOOLTIP.."TextLeft1");
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
function ShapeshiftShadowform_Print(msg,r,g,b,frame,id,unknown4th)
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
