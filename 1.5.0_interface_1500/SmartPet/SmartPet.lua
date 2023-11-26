SMARTPET_VERSION = "v1.5";

-- Config Options
SmartPet_Config = {};

-- General Variables
SmartPet_Vars = {};
SmartPet_Vars.MainAction = "";
SmartPet_Vars.InCombat = false;
SmartPet_Vars.LastHealthWarning = 0;
SmartPet_Vars.LastHealthPercent = 0;
SmartPet_Vars.CombatStartTime = 0;
-- Debug Variables
SmartPet_Vars.FirstAttackTime = 0;
SmartPet_Vars.LastAttackTime = 0;
SmartPet_Vars.SpellDamage = 0;
SmartPet_Vars.SimSpellDamage = 0;

-- Pet Abilities
SmartPet_Actions = {};
SmartPet_Actions["Taunt"] = { name = "Growl", index = 0, cost = 15, lastTime = 0} ;
SmartPet_Actions["Detaunt"] = { name = "Cower", index = 0, cost = 15, lastTime = 0 };
SmartPet_Actions["Burst"] = { name = "Claw", index = 0, cost = 25, lastTime = 0 };
SmartPet_Actions["Sustain"] = { name = "Bite", index = 0, cost = 35, lastTime = 0 };

-- Slash Commands
SMARTPET_HELP			= "help";
SMARTPET_ENABLE			= "enable";
SMARTPET_DISABLE		= "disable";
SMARTPET_TAUNTMAN		= "tauntman";
SMARTPET_SMARTFOCUS		= "smartfocus";
SMARTPET_ON				= "on";
SMARTPET_OFF			= "off";
SMARTPET_AUTOWARN 		= "autowarn";
SMARTPET_WARNHEALTH		= "warnhealth";
SMARTPET_AUTOCOWER		= "autocower";
SMARTPET_COWERHEALTH	= "cowerhealth";
SMARTPET_CHANNEL		= "channel";
SMARTPET_NOCHASE		= "nochase";
SMARTPET_SHOWDEBUG		= "showdebug";

-- Misc
SMARTPET_FOCUSREGEN = 5;

COLOR_RED = "|cffff0000";
COLOR_YELLOW = "|cffffff00";
COLOR_GREEN = "|cff00ff00";
COLOR_GREY = "|caaaaaaaa";
COLOR_WHITE = "|cffffffff";
COLOR_BLUE = "|cff3366ff";
COLOR_CLOSE = "|r";


-- Load Handler
function SmartPet_OnLoad()
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
	this:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
	this:RegisterEvent("PET_ATTACK_START");
	this:RegisterEvent("PET_ATTACK_STOP");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PET_BAR_UPDATE");
	SmartPet_ResetConfig();

	SLASH_SMARTPET1 = "/smartpet";
	SLASH_SMARTPET2 = "/sp";
	SlashCmdList["SMARTPET"] = function(msg)
		SmartPet_OnSlashCommand(msg);
	end

	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage("SmartPet "..SMARTPET_VERSION.." Loaded: Type /smartpet or /sp for more information");
	end	
end

-- Slash Command Handler
function SmartPet_OnSlashCommand(msg)

	if (not msg) then
		return;
	end

	if (UnitClass("player") ~= "Hunter") then
		SmartPet_AddInfoMessage("This AddOn is for Hunter pets only.");
		return;
	end

	local command = string.lower(msg);
	
	-- Enable/Disable
	if (command == SMARTPET_ENABLE or command == SMARTPET_ON) then
		SmartPet_Config.Enabled = true;
		SmartPet_AddInfoMessage("SmartPet enabled");
	elseif (command == SMARTPET_DISABLE or command == SMARTPET_OFF  ) then
		SmartPet_Config.Enabled = false;
		SmartPet_AddInfoMessage("SmartPet disabled");
	-- Focus Management
	elseif (strsub(command, 1, strlen(SMARTPET_TAUNTMAN )) == SMARTPET_TAUNTMAN  ) then
		SmartPet_AddInfoMessage("SmartPet: Use the check buttons above Growl and Cower on your pet action bar to enable Taunt Management");
--		if (SmartPet_ToggleOption(command, SmartPet_Config.TauntMan)) then
--			SmartPet_Config.TauntMan = true;
--			SmartPet_AddInfoMessage("SmartPet: Taunt management enabled");
--		else
--			SmartPet_Config.TauntMan = false;
--			SmartPet_AddInfoMessage("SmartPet: Taunt management disabled");
--		end
	-- Focus Management
	elseif (strsub(command, 1, strlen(SMARTPET_SMARTFOCUS )) == SMARTPET_SMARTFOCUS  ) then
		if (SmartPet_ToggleOption(command, SmartPet_Config.SmartFocus)) then
			SmartPet_Config.SmartFocus = true;
			SmartPet_AddInfoMessage("SmartPet: Smart Focus management enabled");
		else
			SmartPet_Config.SmartFocus = false;
			SmartPet_AddInfoMessage("SmartPet: Smart Focus management disabled");
		end
	-- Health Warning
	elseif (strsub(command, 1, strlen(SMARTPET_AUTOWARN )) == SMARTPET_AUTOWARN  ) then
		if (SmartPet_ToggleOption(command, SmartPet_Config.AutoWarn)) then
			SmartPet_Config.AutoWarn = true;
			SmartPet_AddInfoMessage("SmartPet: Low health warning enabled");
		else
			SmartPet_Config.AutoWarn = false;
			SmartPet_AddInfoMessage("SmartPet: Low health warning disabled");
		end
	-- Health Warning Channel
	elseif (strsub(command, 1, strlen(SMARTPET_CHANNEL)) == SMARTPET_CHANNEL ) then
		if (strfind(command, "party")) then
			SmartPet_Config.Channel = "party";
		elseif (strfind(command, "say")) then
			SmartPet_Config.Channel = "say";
		elseif (strfind(command, "guild")) then
			SmartPet_Config.Channel = "guild";
		else
	        firsti, lasti, value = strfind(command, "(%d+)");
	        if (value) then
	        	SmartPet_Config.Channel = tonumber(value);
	        else
	        	SmartPet_Config.Channel = "say";
	        end
		end
		SmartPet_AddInfoMessage("SmartPet: Channel set to "..SmartPet_Config.Channel);
	-- Cower Mode
	elseif (strsub(command, 1, strlen(SMARTPET_AUTOCOWER)) == SMARTPET_AUTOCOWER ) then
		if (SmartPet_Config.AutoCower) then
			SmartPet_Config.AutoCower = false;
			SmartPet_AddInfoMessage("SmartPet: Cower when low health disabled");
		else
			SmartPet_Config.AutoCower = true;
			SmartPet_AddInfoMessage("SmartPet: Cower when low health enabled");
		end
	-- Health Warning Threshold
	elseif (strsub(command, 1, strlen(SMARTPET_WARNHEALTH)) == SMARTPET_WARNHEALTH ) then
        firsti, lasti, value = strfind(command, "(%d+)");
        if (value) then
        	SmartPet_Config.WarnHealth = tonumber(value);
    	else
    		SmartPet_Config.WarnHealth = 30;
    	end
		SmartPet_AddInfoMessage("SmartPet: Low health warning set to "..SmartPet_Config.WarnHealth.."%");
	-- Auto Cower Threshold
	elseif (strsub(command, 1, strlen(SMARTPET_COWERHEALTH)) == SMARTPET_COWERHEALTH ) then
		firsti, lasti, value = strfind(command, "(%d+)");
		if (value) then
        	SmartPet_Config.CowerHealth = tonumber(value);
    	else
    		SmartPet_Config.CowerHealth = 30;
    	end
		SmartPet_AddInfoMessage("SmartPet: Auto-cower health set to "..SmartPet_Config.CowerHealth.."%");
	-- No Chase
	elseif (strsub(command, 1, strlen(SMARTPET_NOCHASE)) == SMARTPET_NOCHASE ) then
		if (SmartPet_Config.NoChase) then
			SmartPet_Config.NoChase = false;
			SmartPet_AddInfoMessage("SmartPet: Your pet will chase fleeing targets");
		else
			SmartPet_Config.NoChase = true;
			SmartPet_AddInfoMessage("SmartPet: Your pet will stop attacking if your target flees");
		end		
	-- Debug Text
	elseif (strsub(command, 1, 9) == SMARTPET_SHOWDEBUG) then
		if (command == SMARTPET_SHOWDEBUG) then
			SmartPet_Config.ShowDebug = false;
			SmartPet_AddInfoMessage("SmartPet: Debug text display disabled");
		else
			SmartPet_Config.ShowDebug = true;
			SmartPet_Config.ShowDebugString = command;
			SmartPet_AddInfoMessage("SmartPet: Debug text display enabled");
		end
	-- Help Text
	elseif (command == SMARTPET_HELP) then
		SmartPet_AddInfoMessage("SmartPet command help:");
		SmartPet_AddHelpMessage("Taunt Management", "Enabling this will ensure that your pet always has enough focus to Cower or Growl.  Each time you enter combat, your pet will make use of the abilities that were set to Autocast when combat started, while maintaining enough focus to growl or cower every 5 seconds.");
		SmartPet_AddHelpMessage("Smart Focus Management", "Enabling this will attempt to maximize your pets DPS output by automatically enabling and disabling burst and sustained damage abilities at the appropriate time.");
		SmartPet_AddHelpMessage("Auto Health Warning", "Enabling this will send a message to your party if your pets health drops below the specified amount.");
		SmartPet_AddHelpMessage("Auto Cower", "Enabling this will cause your pet to cower when its health drops below the specified amount.");
	-- Typos and Default
	else
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		SmartPet_AddInfoMessage("SmartPet Status:");
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_GREEN.."Use "..COLOR_CLOSE..COLOR_WHITE.."/smartpet <command> "..COLOR_CLOSE..COLOR_GREEN.."or "..COLOR_CLOSE..COLOR_WHITE.."/sp <command> "..COLOR_CLOSE..COLOR_GREEN.."to perform the following commands:"..COLOR_CLOSE);
		SmartPet_AddHelpMessage(SMARTPET_ENABLE.."|"..SMARTPET_DISABLE, "enables or disables all SmartPet functionality", nil, SmartPet_Config.Enabled);
		SmartPet_AddHelpMessage(SMARTPET_TAUNTMAN, "toggles taunt management", nil, SmartPet_Config.TauntMan);
		SmartPet_AddHelpMessage(SMARTPET_SMARTFOCUS, "toggles smart focus management", nil, SmartPet_Config.SmartFocus);
		SmartPet_AddHelpMessage(SMARTPET_AUTOWARN, "toggles warning when pet health is low", nil, SmartPet_Config.AutoWarn);
		SmartPet_AddHelpMessage(SMARTPET_WARNHEALTH.." <percent>", "pet will inform party of health when below this level.", "("..SmartPet_Config.WarnHealth.."%)", SmartPet_Config.AutoWarn);
		SmartPet_AddHelpMessage(SMARTPET_CHANNEL.." <say|party|guild|#>", "pet health informs will go to this channel.", "("..SmartPet_Config.Channel..")", SmartPet_Config.AutoWarn);
		SmartPet_AddHelpMessage(SMARTPET_AUTOCOWER, "toggles auto cowering when health is low", nil, SmartPet_Config.AutoCower);
		SmartPet_AddHelpMessage(SMARTPET_COWERHEALTH.." <percent>", "pet will begin cowering when health below this level.", "("..SmartPet_Config.CowerHealth.."%)", SmartPet_Config.AutoCower);
		SmartPet_AddHelpMessage(SMARTPET_NOCHASE, "pet will stop combat if your target flees.", nil, SmartPet_Config.NoChase);
		SmartPet_AddHelpMessage(SMARTPET_HELP, "displays more detailed help information", nil, nil);
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_GREEN.."For example: "..COLOR_CLOSE..COLOR_WHITE.."/smartpet warnhealth 40 "..COLOR_CLOSE..COLOR_GREEN.."will make your pet warn the party when it's health is below 40%."..COLOR_CLOSE);
    end
	SmartPet_UpdateActionIcons(true);
end

-- Main Event Handler
function SmartPet_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (not SmartPet_Config.Version or SmartPet_Config.Version ~= SMARTPET_VERSION) then
			SmartPet_AddInfoMessage("SmartPet: Version changed, resetting all variables to default.");
			SmartPet_ResetConfig();
		end
		RegisterForSave("SmartPet_Config");
		SmartPet_UpdateActionIcons(false);
				
	end

	if (not SmartPet_Config.Enabled) then
		return;
	end

	if (UnitClass("player") ~= "Hunter") then
		return;
	end

	if (not UnitExists("pet") or UnitIsDead("pet")) then
		SmartPet_Vars.inCombat = false;
		return;
	end

	if ( event == "PET_BAR_UPDATE") then
		SmartPet_UpdateActionIcons(false);
	end

	if ( event == "PET_ATTACK_START") then
		SmartPet_InitActions();
		SmartPet_Vars.inCombat = true;
		SmartPet_Vars.CombatStartTime = GetTime();
		SmartPet_Vars.LastHealthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
		-- Debug Variables
		SmartPet_Vars.FirstAttackTime = 0;
		SmartPet_Vars.LastAttackTime = 0;
		SmartPet_Vars.SpellDamage = 0;
		SmartPet_Vars.SimSpellDamage = 0;
	end

	if (event == "PET_ATTACK_STOP") then
		SmartPet_Vars.inCombat = false;
		SmartPet_SetActionByUse("Taunt", SmartPet_Config.UseTaunt);
		SmartPet_SetActionByUse("Detaunt", SmartPet_Config.UseDetaunt);
		SmartPet_SetActionByUse("Burst", SmartPet_Config.UseBurst);
		SmartPet_SetActionByUse("Sustain", SmartPet_Config.UseSustain);
		SmartPet_AddDebugMessage("Combat Time: "..(SmartPet_Vars.LastAttackTime - SmartPet_Vars.FirstAttackTime), "dps");
		SmartPet_AddDebugMessage("Spell DPS: "..SmartPet_Vars.SpellDamage / (SmartPet_Vars.LastAttackTime - SmartPet_Vars.FirstAttackTime), "dps");
		SmartPet_AddDebugMessage("Sim Spell DPS: "..SmartPet_Vars.SimSpellDamage / (SmartPet_Vars.LastAttackTime - SmartPet_Vars.FirstAttackTime), "dps");
	end

	if (event == "CHAT_MSG_SPELL_PET_DAMAGE") then
		SmartPet_OnPetSpellEvent(arg1);
	end

	if (event == "CHAT_MSG_MONSTER_EMOTE") then
		SmartPet_OnMonsterEmote(arg1, arg2);
	end

	if (event == "UNIT_FOCUS" and arg1 == "pet" and (SmartPet_Config.TauntMan or SmartPet_Config.SmartFocus)) then
		SmartPet_OnFocusEvent(arg1, arg2);
	end

	if ((event == "UNIT_HEALTH") and (arg1 == "pet") and (SmartPet_Config.AutoWarn or SmartPet_Config.AutoCower)) then
		SmartPet_OnHealthEvent(arg1, arg2);
	end
	
end

function SmartPet_OnMonsterEmote(arg1)
	if (not SmartPet_Config.NoChase) then
		return
	end
	
	if (arg2 == UnitName("target") and strfind (arg1, "attempts to run away in fear")) then
		SmartPet_AddInfoMessage(UnitName("pet").." breaking off from combat!");
		PetFollow();
	end
end

-- Spell Damage Event Handler
function SmartPet_OnPetSpellEvent(arg1)
	if (strfind (arg1, SmartPet_Actions["Taunt"].name)) then
		SmartPet_ProcessSpellEvent("Taunt");
	end
	if (strfind (arg1, SmartPet_Actions["Sustain"].name)) then
		SmartPet_ProcessSpellEvent("Sustain");
	end
	if (strfind (arg1, SmartPet_Actions["Burst"].name)) then
		SmartPet_ProcessSpellEvent("Burst");
	end
	if (strfind (arg1, SmartPet_Actions["Detaunt"].name)) then
		SmartPet_ProcessSpellEvent("Detaunt");
	end
end

function SmartPet_ProcessSpellEvent(action)
	SmartPet_AddDebugMessage(SmartPet_Actions[action].name..": Time Since Last: "..GetTime() - SmartPet_Actions[action].lastTime, "usage");
	if (SmartPet_Vars.FirstAttackTime == 0) then
		SmartPet_Vars.FirstAttackTime = GetTime();
	end
	SmartPet_Actions[action].lastTime = GetTime();
	SmartPet_Vars.LastAttackTime = SmartPet_Actions[action].lastTime;

	firsti, lasti, value = strfind(arg1, "(%d+)");
	if (value) then
		SmartPet_Vars.SpellDamage = SmartPet_Vars.SpellDamage + tonumber(value);
		if (action == "Burst") then
			SmartPet_Vars.SimSpellDamage = SmartPet_Vars.SimSpellDamage + 31;
		elseif (action == "Sustain") then
			SmartPet_Vars.SimSpellDamage = SmartPet_Vars.SimSpellDamage + 54;
		end
	end
end

-- Focus Event Handler
function SmartPet_OnFocusEvent(arg1, arg2)
	if (not SmartPet_Vars.inCombat) then
		return;
	end

	if (SmartPet_Config.SmartFocus and SmartPet_Config.UseSustain and SmartPet_Config.UseBurst) then
		if (GetTime() - SmartPet_Vars.CombatStartTime > 12.0) then
			SmartPet_DisableAction("Burst");
			SmartPet_SetActionByFocus("Sustain");
		else
			SmartPet_DisableAction("Sustain");
			SmartPet_SetActionByFocus("Burst");
		end
	elseif (SmartPet_Config.TauntMan) then
		if (SmartPet_Config.UseSustain) then
			SmartPet_SetActionByFocus("Sustain");
		end
	
		if (SmartPet_Config.UseBurst) then
			SmartPet_SetActionByFocus("Burst");
		end
	end
end

-- Health Event Handler
function SmartPet_OnHealthEvent(arg1, arg2)
	if (not SmartPet_Vars.inCombat) then
		SmartPet_AddDebugMessage("Not checking health because we're not in combat", "spew");
		return;
	end

	healthPercent = (100 * UnitHealth("pet") / UnitHealthMax("pet"));
	if (SmartPet_Config.AutoCower and SmartPet_Actions["Detaunt"].index > 0) then
		if (healthPercent < SmartPet_Config.CowerHealth) then
			SmartPet_AddDebugMessage("AutoCower Health Check Failed, switching to cower", "spew");
			SmartPet_DisableAction("Taunt");
			SmartPet_EnableAction("Detaunt");
			SmartPet_Vars.MainAction = "Detaunt";
		else
			SmartPet_SetActionByUse("Taunt", SmartPet_Config.UseTaunt);
			SmartPet_SetActionByUse("Detaunt", SmartPet_Config.UseDetaunt);
		end
	end
	
	if (SmartPet_Config.AutoWarn) then
		if (healthPercent >= 60) then
			warnTime = 10;
		elseif (healthPercent >= 50) then
			warnTime = 8;
		elseif (healthPercent >= 30) then
			warnTime = 6;
		else
			warnTime = 4;
		end
		if (healthPercent < SmartPet_Config.WarnHealth and ((GetTime() - SmartPet_Vars.LastHealthWarning) > warnTime) and SmartPet_Vars.LastHealthPercent > healthPercent ) then
			SmartPet_AddDebugMessage("AutoWarn Health Check Failed, sending message", "spew");
			SmartPet_Vars.LastHealthWarning = GetTime();
			SmartPet_SendChatMessage((UnitName("pet").." needs healing! ("..string.format("%3d", healthPercent).."% Health )"));
		end
	end
	SmartPet_Vars.LastHealthPercent = healthPercent;
end

-- 
-- General Functions
--

-- Enables the specified pet ability based on available focus
function SmartPet_SetActionByFocus(action)
	if (SmartPet_Vars.MainAction == "") then
		SmartPet_EnableAction(action);
		return;
	end
	
	if ((UnitMana("pet") + SmartPet_FocusRegen(SmartPet_Vars.MainAction)) - SmartPet_Actions[action].cost < SmartPet_Actions[SmartPet_Vars.MainAction].cost) then
		SmartPet_DisableAction(action);
	else
		SmartPet_EnableAction(action);
	end
end

-- Enables the specified pet ability
function SmartPet_EnableAction(action)
	if (SmartPet_Actions[action].index < 1) then
		return;
	end
	name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(SmartPet_Actions[action].index);
	if (not autoCastEnabled) then
		SmartPet_AddDebugMessage("Enabling Action: "..SmartPet_Actions[action].name, "spew");		
		TogglePetAutocast(SmartPet_Actions[action].index);
	end
end

-- Disables the specified pet ability
function SmartPet_DisableAction(action)
	name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(SmartPet_Actions[action].index);
	if (autoCastEnabled) then
		SmartPet_AddDebugMessage("Disabling Action: "..SmartPet_Actions[action].name, "spew");		
		TogglePetAutocast(SmartPet_Actions[action].index);
	end
end

-- Returns the estimated amount of focus that will be regen'd during this actions cooldown
function SmartPet_FocusRegen(action)
	startTime, duration, enable = GetActionCooldown(SmartPet_Actions[action].index);
	if (startTime == 0) then
		return 0;
	else
		return SMARTPET_FOCUSREGEN * (duration);
	end
end

-- Initialize the pet actions for combat
function SmartPet_InitActions()
	SmartPet_UpdateActionIcons(true);

	SmartPet_SetActionByUse("Taunt", SmartPet_Config.UseTaunt);	
	SmartPet_SetActionByUse("Detaunt", SmartPet_Config.UseDetaunt);

	if (SmartPet_Config.UseTaunt) then
		SmartPet_Vars.MainAction = "Taunt";
	elseif (SmartPet_Config.UseDetaunt) then
		SmartPet_Vars.MainAction = "Detaunt";
	else
		SmartPet_Vars.MainAction = "";
	end
	
	if (SmartPet_Config.SmartFocus and SmartPet_Config.UseBurst and SmartPet_Config.UseSustain) then
		SmartPet_DisableAction("Sustain");
		SmartPet_EnableAction("Burst");
	end
end

-- Determine if an action is to be used during this combat session

-- Enables/Disables the specified pet ability based on it's .use setting
function SmartPet_SetActionByUse(action, enabled)
	if (enabled) then
		SmartPet_EnableAction(action);		
	else
		SmartPet_DisableAction(action);
	end
end

-- Decide to toggle a variable based on its current state, or the command string
function SmartPet_ToggleOption(command, enabled)
	if (strfind(command, "on") or strfind(command, "enable")) then
		return true;
	elseif (strfind(command, "off") or strfind(command, "disable")) then
		return false;
	else
		if (enabled) then
			return false;
		else
			return true;
		end
	end
end

-- Sends a message to the specified channel
function SmartPet_SendChatMessage(message, channel)
	channelNumber = 0;
	if (channel == nil or channel == "") then
		firsti, lasti, value = strfind(SmartPet_Config.Channel, "(%d+)");
		if (value) then
			channel = "CHANNEL";
			channelNumber = tonumber(value);
		else
			channel = string.upper(SmartPet_Config.Channel);
		end
	end
	-- add additional invalid channel error checking
	if (channelNumber > 0) then
		SendChatMessage(message, channel, nil, channelNumber);
	else
		SendChatMessage(message, channel);
	end
end

function SmartPet_ToggleUse(id)
	if (id == SmartPet_Actions["Taunt"].index) then
		if (SmartPet_Config.UseTaunt or SmartPet_Config.UseDetaunt) then
			if (SmartPet_Config.UseTaunt) then
				SmartPet_Config.TauntMan = false; -- disable tauntman
				SmartPet_Config.UseTaunt = false; -- disable taunt
			else
				SmartPet_Config.TauntMan = true; -- enable tauntman
				SmartPet_Config.UseTaunt = true; -- enable taunt
				SmartPet_Config.UseDetaunt = false;-- disable detaunt
			end
		else
			SmartPet_Config.TauntMan = true; -- enable tauntman
			SmartPet_Config.UseTaunt = true;-- set tauntman to taunt
			SmartPet_Config.UseDetaunt = false;
		end
		SmartPet_SetActionByUse("Taunt", SmartPet_Config.UseTaunt);
		SmartPet_SetActionByUse("Detaunt", SmartPet_Config.UseDetaunt);
	elseif (id == SmartPet_Actions["Detaunt"].index) then
		if (SmartPet_Config.UseTaunt or SmartPet_Config.UseDetaunt) then
			if (SmartPet_Config.UseDetaunt) then
				SmartPet_Config.TauntMan = false; -- disable tauntman
				SmartPet_Config.UseDetaunt = false; -- disable taunt
			else
				SmartPet_Config.TauntMan = true; -- enable tauntman
				SmartPet_Config.UseDetaunt = true; -- enable taunt
				SmartPet_Config.UseTaunt = false;-- disable detaunt
			end
		else
			SmartPet_Config.TauntMan = true; -- enable tauntman
			SmartPet_Config.UseDetaunt = true;-- set tauntman to taunt
			SmartPet_Config.UseTaunt = false;
		end
		SmartPet_SetActionByUse("Taunt", SmartPet_Config.UseTaunt);
		SmartPet_SetActionByUse("Detaunt", SmartPet_Config.UseDetaunt);
	elseif (id == SmartPet_Actions["Burst"].index) then
		if (SmartPet_Config.UseBurst) then
			SmartPet_Config.UseBurst = false;
		else
			SmartPet_Config.UseBurst = true;
		end
		SmartPet_SetActionByUse("Burst", SmartPet_Config.UseBurst);
	elseif (id == SmartPet_Actions["Sustain"].index) then
		if (SmartPet_Config.UseSustain) then
			SmartPet_Config.UseSustain = false;
		else
			SmartPet_Config.UseSustain = true;
		end
		SmartPet_SetActionByUse("Sustain", SmartPet_Config.UseSustain);
	end
	SmartPet_UpdateActionIcons(true);
end

function SmartPet_SetupAction(name, index, enabled)
	local l_smartPetActionButton = getglobal("SmartPetActionButton"..index);
	if (enabled) then
		l_smartPetActionButton:SetChecked(1);
	else
		l_smartPetActionButton:SetChecked(nil);
	end
	SmartPet_Actions[name].index = index;
end

function SmartPet_UpdateActionIcons(resetIDs)
	if (resetIDs) then
		SmartPet_Actions["Taunt"].index = -1;
		SmartPet_Actions["Detaunt"].index = -1;
		SmartPet_Actions["Burst"].index = -1;
		SmartPet_Actions["Sustain"].index = -1;
	end

	for index=1, NUM_PET_ACTION_SLOTS, 1 do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(index);
		local l_petActionButton = getglobal("SmartPetActionButton"..index);

		if (not SmartPet_Config.Enabled) then
			l_petActionButton:Hide();
		elseif (name == SmartPet_Actions["Taunt"].name) then
			l_petActionButton:Show();
			SmartPet_SetupAction("Taunt", index, SmartPet_Config.UseTaunt);
		elseif (name == SmartPet_Actions["Detaunt"].name) then
			l_petActionButton:Show();
			SmartPet_SetupAction("Detaunt", index, SmartPet_Config.UseDetaunt);
		elseif (name == SmartPet_Actions["Burst"].name) then
			if (SmartPet_Config.TauntMan or SmartPet_Config.SmartFocus) then
				l_petActionButton:Show();
			else
				l_petActionButton:Hide();
			end
			SmartPet_SetupAction("Burst", index, SmartPet_Config.UseBurst);
		elseif (name == SmartPet_Actions["Sustain"].name) then
			if (SmartPet_Config.TauntMan or SmartPet_Config.SmartFocus) then
				l_petActionButton:Show();
			else
				l_petActionButton:Hide();
			end
			SmartPet_SetupAction("Sustain", index, SmartPet_Config.UseSustain);
		else
			l_petActionButton:Hide();
		end
	end
	
	if (resetIDs) then
		if (SmartPet_Actions["Taunt"].index < 1) then
			SmartPet_Config.UseTaunt = false;
		end
		if (SmartPet_Actions["Detaunt"].index < 1) then
			SmartPet_Config.UseDetaunt = false;
		end
		if (SmartPet_Actions["Burst"].index < 1) then
			SmartPet_Config.UseBurst = false;
		end
		if (SmartPet_Actions["Sustain"].index < 1) then
			SmartPet_Config.UseSustain = false;
		end
		if (not SmartPet_Config.UseTaunt and not SmartPet_Config.UseDetaunt) then
			SmartPet_Config.TauntMan = false;
		end
	end
end

function SmartPet_BuildTooltip(id)
	SmartPet_UpdateActionIcons(true);
	if (id == SmartPet_Actions["Taunt"].index) then
		SmartPet_BuildGrowlTooltip();
	elseif (id == SmartPet_Actions["Detaunt"].index) then
		SmartPet_BuildCowerTooltip();
	elseif (id == SmartPet_Actions["Burst"].index) then
		SmartPet_BuildClawTooltip();
	elseif (id == SmartPet_Actions["Sustain"].index) then
		SmartPet_BuildBiteTooltip();
	end
end

function SmartPet_BuildGrowlTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(COLOR_WHITE.."Taunt Management"..COLOR_CLOSE);
	
	if (SmartPet_Config.TauntMan) then
		if (SmartPet_Config.UseTaunt) then
			GameTooltip:AddLine("SmartPet will ensure that your pet has enough");
			GameTooltip:AddLine("focus to cast Growl every 5 seconds.");
			if (SmartPet_Config.AutoCower) then
				if (SmartPet_Actions["Detaunt"].index < 1) then					
					GameTooltip:AddLine(COLOR_RED.."You must have Cower on your Pet Action Bar"..COLOR_CLOSE);
					GameTooltip:AddLine(COLOR_RED.."for AutoCower to work."..COLOR_CLOSE);
				else
					GameTooltip:AddLine(COLOR_GREEN.."Because AutoCower is enabled SmartPet will"..COLOR_CLOSE);
					GameTooltip:AddLine(COLOR_GREEN.."enable Cower if your pets health drops"..COLOR_CLOSE);
					GameTooltip:AddLine(COLOR_GREEN.."below "..SmartPet_Config.CowerHealth.."%."..COLOR_CLOSE);
					GameTooltip:AddLine(COLOR_GREEN.."If Growl is enabled when this happens"..COLOR_CLOSE);
					GameTooltip:AddLine(COLOR_GREEN.."SmartPet will automatically disable it."..COLOR_CLOSE);
				end
			end
		elseif (SmartPet_Config.UseDetaunt) then
			GameTooltip:AddLine(COLOR_RED.."SmartPet will disable Growl during combat."..COLOR_CLOSE);
		end
	else
		if (SmartPet_Config.AutoCower) then
			GameTooltip:AddLine(COLOR_GREEN.."Because AutoCower is enabled SmartPet will"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."enable Cower if your pets health drops"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."below "..SmartPet_Config.CowerHealth.."%."..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."If Growl is enabled when this happens"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."SmartPet will automatically disable it."..COLOR_CLOSE);
		else
			GameTooltip:AddLine("SmartPet will not change the Autocast state of");
			GameTooltip:AddLine("Growl during combat.");
		end
	end
	GameTooltip:Show();
end

function SmartPet_BuildCowerTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(COLOR_WHITE.."Taunt Management"..COLOR_CLOSE);
	
	if (SmartPet_Config.TauntMan) then
		if (SmartPet_Config.UseDetaunt) then
			GameTooltip:AddLine("SmartPet will ensure that your pet has enough");
			GameTooltip:AddLine("focus to cast Cower every 5 seconds.");
		elseif (SmartPet_Config.UseTaunt) then
			GameTooltip:AddLine(COLOR_RED.."SmartPet will disable Cower during combat."..COLOR_CLOSE);
			if (SmartPet_Config.AutoCower) then
				GameTooltip:AddLine(COLOR_GREEN.."Because AutoCower is enabled SmartPet will"..COLOR_CLOSE);
				GameTooltip:AddLine(COLOR_GREEN.."enable Cower if your pets health drops"..COLOR_CLOSE);
				GameTooltip:AddLine(COLOR_GREEN.."below "..SmartPet_Config.CowerHealth.."%."..COLOR_CLOSE);
				GameTooltip:AddLine(COLOR_GREEN.."If Growl is enabled when this happens"..COLOR_CLOSE);
				GameTooltip:AddLine(COLOR_GREEN.."SmartPet will automatically disable it."..COLOR_CLOSE);
			end
		end
	else
		if (SmartPet_Config.AutoCower) then
			GameTooltip:AddLine(COLOR_GREEN.."Because AutoCower is enabled SmartPet will"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."enable Cower if your pets health drops"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."below "..SmartPet_Config.CowerHealth.."%."..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."If Growl is enabled when this happens"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_GREEN.."SmartPet will automatically disable it."..COLOR_CLOSE);
		else
			GameTooltip:AddLine("SmartPet will not change the Autocast state of");
			GameTooltip:AddLine("Cower during combat.");
		end
	end
	GameTooltip:Show();
end

function SmartPet_BuildClawTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(COLOR_WHITE.."Claw Management"..COLOR_CLOSE);
	if (SmartPet_Config.TauntMan) then
		if (SmartPet_Config.UseBurst) then
			local mainAction;
			if (SmartPet_Config.UseTaunt) then
				mainAction = SmartPet_Actions["Taunt"].name;
			else
				mainAction = SmartPet_Actions["Detaunt"].name;
			end
			GameTooltip:AddLine("SmartPet will disable Claw during combat if");
			GameTooltip:AddLine("using it would not leave your pet with enough");
			GameTooltip:AddLine("focus to cast "..mainAction..". It will be re-enabled if");
			GameTooltip:AddLine("your pet gains enough focus to use both "..mainAction);
			GameTooltip:AddLine("and Claw.");
		else
			GameTooltip:AddLine(COLOR_RED.."SmartPet will disable Claw during combat."..COLOR_CLOSE);
		end
	end
	if (SmartPet_Config.SmartFocus) then
		if (not SmartPet_Config.UseBurst or not SmartPet_Config.UseSustain) then
			GameTooltip:AddLine(COLOR_RED.."You must enable both Claw and Bite for SmartFocus "..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_RED.."to work."..COLOR_CLOSE);
		else
			GameTooltip:AddLine(COLOR_BLUE.."Because SmartFocus is enabled SmartPet will"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."attempt to optimize your pets DPS by enabling"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."Claw and disabling Bite for the first 12 seconds"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."of combat. After that time your pet will switch"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."to Bite."..COLOR_CLOSE);
		end
	end
	GameTooltip:Show();
end

function SmartPet_BuildBiteTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(COLOR_WHITE.."Bite Management"..COLOR_CLOSE);
	if (SmartPet_Config.TauntMan) then
		if (SmartPet_Config.UseSustain) then
			local mainAction;
			if (SmartPet_Config.UseTaunt) then
				mainAction = SmartPet_Actions["Taunt"].name;
			else
				mainAction = SmartPet_Actions["Detaunt"].name;
			end
			GameTooltip:AddLine("SmartPet will disable Bite during combat if");
			GameTooltip:AddLine("using it would not leave your pet with enough");
			GameTooltip:AddLine("focus to cast "..mainAction..". It will be re-enabled if");
			GameTooltip:AddLine("your pet gains enough focus to use both "..mainAction);
			GameTooltip:AddLine("and Bite.");
		else
			GameTooltip:AddLine(COLOR_RED.."SmartPet will disable Bite during combat."..COLOR_CLOSE);
		end
	end
	if (SmartPet_Config.SmartFocus) then
		if (not SmartPet_Config.UseBurst or not SmartPet_Config.UseSustain) then
			GameTooltip:AddLine(COLOR_RED.."You must enable both Claw and Bite for SmartFocus "..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_RED.."to work."..COLOR_CLOSE);
		else
			GameTooltip:AddLine(COLOR_BLUE.."Because SmartFocus is enabled SmartPet will"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."attempt to optimize your pets DPS by enabling"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."Claw and disabling Bite for the first 12 seconds"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."of combat. After that time your pet will switch"..COLOR_CLOSE);
			GameTooltip:AddLine(COLOR_BLUE.."to Bite."..COLOR_CLOSE);
		end
	end
	GameTooltip:Show();
end

-- Adds a formatted informational message
function SmartPet_AddInfoMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(COLOR_YELLOW..message..COLOR_CLOSE);
end

-- Adds a formatted help message
function SmartPet_AddHelpMessage(command, detail, status, enabled)
	message = COLOR_WHITE..command..": "..COLOR_CLOSE..COLOR_GREEN..detail..COLOR_CLOSE;

	if (enabled == nil) then
		DEFAULT_CHAT_FRAME:AddMessage(message);
		return;
	end
	
	if (status == "" or status == nil) then
		if (enabled) then
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_WHITE.." (enabled)"..COLOR_CLOSE);
		else
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_GREY.." (disabled)"..COLOR_CLOSE);
		end
	else
		if (enabled) then
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_WHITE..status..COLOR_CLOSE);
		else
			DEFAULT_CHAT_FRAME:AddMessage(message..COLOR_GREY..status..COLOR_CLOSE);
		end		
	end
end

function SmartPet_AddDebugMessage(message, style)
	if (not SmartPet_Config.ShowDebug) then
		return;
	end
	
	if (strfind (SmartPet_Config.ShowDebugString, style)) then
		DEFAULT_CHAT_FRAME:AddMessage(COLOR_RED..message..COLOR_CLOSE);
	end
end

function SmartPet_ResetConfig()
	SmartPet_Config.Enabled = true;
	SmartPet_Config.TauntMan = true;
	SmartPet_Config.SmartFocus = true;
	SmartPet_Config.WarnHealth = 30;
	SmartPet_Config.AutoWarn = false;
	SmartPet_Config.CowerHealth = 30;
	SmartPet_Config.AutoCower = false;
	SmartPet_Config.ShowDebug = false;
	SmartPet_Config.Channel = "say";
	SmartPet_Config.NoChase = false;
	SmartPet_Config.UseTaunt = false;
	SmartPet_Config.UseDetaunt = false;
	SmartPet_Config.UseBurst = false;
	SmartPet_Config.UseSustain = false;
	SmartPet_Config.Version = SMARTPET_VERSION;
	SmartPet_Config.ShowDebugString = "";
end
