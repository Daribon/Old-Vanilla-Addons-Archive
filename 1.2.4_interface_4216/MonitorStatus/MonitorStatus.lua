--[[
 MonitorStatus v1.0
 Originally made by wharvey 2004-2-23
 Currently maintained by David Hedbor <david@hedbor.org>
 Update to v0.5-0.7 by Joe "JoeFaust" Hartford <joefaust@cosmosui.org>
 Changes in version 1.0:
 	* now updates every .2 seconds with Chronos (by Arys 02-02-05)
 Changes in version 0.9:
  * fixes to show only during combat
 Changes in version 0.8:
  * Ability to show only during combat
  * Ability to hide mana
 Changes in version 0.7:
  * Ability to enable/disable Target, Player, Pet and/or Party stats
 Changes in version 0.6:
  * Ability to show stats as percentage or actual
 Changes in version 0.5:
	* Added Pet stats under the player's
 Updated to v0.4 by Anders "sarf" Kronquist <k@fukt.bth.se>
 Changes in version 0.4:
	* Added Cosmos compatibility
	* Added slash commands / toggle option
	* Refactored code to be slightly less redudant
 Changes in version 0.3:
	* Made into an addon, fixing one loading issue.
	* Fixed bug where info from removed targets / party members wasn't cleared
		correctly.
]]

MONITORSTATUS_SECONDS_TILL_REVERT = 5;

MonitorStatus_PlayerLastHealth = 0;
MonitorStatus_PlayerTimeStamp = 0;
MonitorStatus_PetLastHealth = 0;
MonitorStatus_PetTimeStamp = 0;
MonitorStatus_TargetLastHealth = 0;
MonitorStatus_TargetTimeStamp = 0;
MonitorStatus_PartyOneLastHealth = 0;
MonitorStatus_PartyOneTimeStamp = 0;
MonitorStatus_PartyTwoLastHealth = 0;
MonitorStatus_PartyTwoTimeStamp = 0;
MonitorStatus_PartyThreeLastHealth = 0;
MonitorStatus_PartyThreeTimeStamp = 0;
MonitorStatus_PartyFourLastHealth = 0;
MonitorStatus_PartyFourTimeStamp = 0;

-- added by sarf
MonitorStatus_CosmosRegistered = 0;
MonitorStatus_Enabled = 0;
MonitorStatus_ShowPercent = 1;
MonitorStatus_ShowTarget = 1;
MonitorStatus_ShowPlayer = 1;
MonitorStatus_ShowPet = 1;
MonitorStatus_ShowParty = 1;
MontiorStatus_OnlyDuringCombat = 0;
MonitorStatus_HideMana = 0;

local localInCombat = nil;
local playerRegenEnabled = 1;

function MonitorStatus_OnLoad()
	MonitorStatus_Register();
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PLAYER_PET_CHANGED");

	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");

	MonitorStatus_CalculateValues();
	if (not Cosmos_RegisterConfiguration) then
		MonitorStatus_Print("MonitorStatus v0.4 loaded.", 1, 1, 1);
	end
	
	Chronos.scheduleByName("MONITORSTATUS_UPDATE", 1, MonitorStatus_OnUpdate);
end

function MonitorStatus_OnUpdate()
	if ( MonitorStatus:IsVisible() ) then
		MonitorStatus_CalculateValues();
	end
	Chronos.scheduleByName("MONITORSTATUS_UPDATE", .2, MonitorStatus_OnUpdate); 	
end

function MonitorStatus_OnEvent()
	if (event == "PLAYER_TARGET_CHANGED") then
		targetLastHealth = 0;
		targetTimeStamp = 0;
		TargetStatusNameText:SetTextColor(1, 0.82, 0);
		TargetStatusConditionText:SetText("");
	elseif(event == "PLAYER_PET_CHANGED") then
		PetLastHealth = 0;
		PetTimestamp = 0;
		PetStatusNameText:SetTextColor(1, 0.82, 0);
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		PartyOneLastHealth = 0;
		PartyOneTimeStamp = 0;
		PartyOneStatusNameText:SetTextColor(1, 0.82, 0);
		PartyTwoLastHealth = 0;
		PartyTwoTimeStamp = 0;
		PartyTwoStatusNameText:SetTextColor(1, 0.82, 0);
		PartyThreeLastHealth = 0;
		PartyThreeTimeStamp = 0;
		PartyThreeStatusNameText:SetTextColor(1, 0.82, 0);
		PartyFourLastHealth = 0;
		PartyFourTimeStamp = 0;
		PartyFourStatusNameText:SetTextColor(1, 0.82, 0);
	end
end

function MonitorStatus_IsPlayerInCombat() 
	-- for now, remove the petInCombat check, cause it causes problems
	-- when you run away and lose your pet
	--if(localInCombat or petInCombat or spellAutorepeat) then
	if(localInCombat or not playerRegenEnabled) then
		return 1;
	else
		return nil;
	end
end

function MonitorStatus_CalculateValuesSpecific(unitName, prefix)
	local literalHealth, healthPct, healthColor, manaPct, manaColor, timeNow, conditionLine;
	
	local conditionText = getglobal(prefix.."StatusConditionText");
	local healthText = getglobal(prefix.."StatusHealthText");
	local nameText = getglobal(prefix.."StatusNameText");
	local manaText = getglobal(prefix.."StatusManaText");
	
	
	timeNow = GetTime();
	
	if((MonitorStatus_OnlyDuringCombat == 1) and not MonitorStatus_IsPlayerInCombat()) then
		nameText:SetText("");
		healthText:SetText("");
		manaText:SetText("");
		conditionText:SetText("");
		return;
	end
	

	if (UnitName(unitName)) then
		literalHealth = UnitHealth(unitName);
		nameText:SetText(UnitName(unitName));
		
		healthPct = (literalHealth * 100.0) / UnitHealthMax(unitName);
		healthColor = MonitorStatus_GetHealthColor(healthPct);
		conditionLine = MonitorStatus_GetConditionLine(healthPct);
		
		conditionText:SetText(conditionLine.name);
		conditionText:SetTextColor(conditionLine.r, conditionLine.g, conditionLine.b);
		
		if(MonitorStatus_ShowPercent == 1) then 
			healthPct = string.format("%4.0f", healthPct);
		else
			healthPct = string.format("%d/%d", literalHealth, UnitHealthMax(unitName));
		end
		healthText:SetText(healthPct);
		healthText:SetTextColor(healthColor.r, healthColor.g, healthColor.b);
		
		if (literalHealth < getglobal("MonitorStatus_"..prefix.."LastHealth")) then
			nameText:SetTextColor(1, 0.1, 0.1);
			setglobal(prefix.."TimeStamp", GetTime());
		else
			local timeStamp = getglobal("MonitorStatus_"..prefix.."TimeStamp");
			if (not timeStamp) or (timeStamp == 0) then
				-- Usual case.	Don't waste cycles on other clause
			elseif ( (timeNow - timeStamp) > MONITORSTATUS_SECONDS_TILL_REVERT ) then
				setglobal("MonitorStatus_"..prefix.."TimeStamp", 0);
				nameText:SetTextColor(1, 0.82, 0);
			end
		end
		setglobal(prefix.."LastHealth", literalHealth);
		
		if(MonitorStatus_HideMana == 0) then
			manaPct = (UnitMana(unitName) * 100.0) / UnitManaMax(unitName);
			manaColor = MonitorStatus_GetManaColor(manaPct);

			if(MonitorStatus_ShowPercent == 1) then
				manaPct = string.format("%4.0f", manaPct);
			else
				manaPct = string.format("%d/%d", UnitMana(unitName), UnitManaMax(unitName));
			end
			manaText:SetText(manaPct);
			manaText:SetTextColor(manaColor.r, manaColor.g, manaColor.b);
		else
			manaText:SetText("");		
		end
	else
		nameText:SetText("");
		healthText:SetText("");
		manaText:SetText("");
		conditionText:SetText("");
	end
end

function MonitorStatus_CalculateValues()
	local literalHealth, healthPct, healthColor, manaPct, manaColor, timeNow, conditionLine;
	
	timeNow = GetTime();
	
	local unitList = { };
	local index = 0;
	if(MonitorStatus_ShowTarget == 1) then
		unitList[index] = { "target", "Target" };
		index = index + 1;
	end
	
	if(MonitorStatus_ShowPlayer == 1) then
		unitList[index] = { "player", "Player" };
		index = index + 1;
	end
	
	if(MonitorStatus_ShowPet == 1) then
		unitList[index] = { "pet", "Pet" };
		index = index + 1;
	end
	
	if(MonitorStatus_ShowParty == 1) then
		unitList[index] = { "party1", "PartyOne" };
		index = index + 1;
		unitList[index] = { "party2", "PartyTwo" };
		index = index + 1;
		unitList[index] = { "party3", "PartyThree" };
		index = index + 1;
		unitList[index] = { "party4", "PartyFour" };
		index = index + 1;
	end
		
	for k, v in unitList do
		MonitorStatus_CalculateValuesSpecific(v[1], v[2]);
	end
end

function MonitorStatus_GetConditionLine(health)
	local returnLine = {name = "", r = 0, g = 0, b = 0};
	if (health > 60) then
		return returnLine;
	end
	
	if (health > 40) then
		returnLine.name = TEXT(MONITORSTATUS_CONDITION_FAIR);
		returnLine.r = 1;
		returnLine.g = 1;
	elseif (health > 20) then
		returnLine.name = TEXT(MONITORSTATUS_CONDITION_POOR);
		returnLine.r = 1;
		returnLine.g = 0.45;
	elseif (health > 0) then
		returnLine.name = TEXT(MONITORSTATUS_CONDITION_CRITICAL);
		returnLine.r = 1;
		returnLine.g = 0.1;
		returnLine.b = 0.1;
	else
		returnLine.name = TEXT(MONITORSTATUS_CONDITION_SLAIN);
		returnLine.r = 0.5;
		returnLine.g = 0.5;
		returnLine.b = 0.5;
	end
	
	return returnLine;
end

function MonitorStatus_GetHealthColor(health)
	local returnColor = { r = 0, g = 0, b = 0 };
	if (health >= 100) then
		returnColor.r = 1;
		returnColor.g = 1;
		returnColor.b = 1;
	elseif (health > 80) then
		returnColor.g = 1;
	elseif (health > 60) then
		returnColor.g = 0.75;
	elseif (health > 40) then
		returnColor.r = 1;
		returnColor.g = 1;
	elseif (health > 20) then
		returnColor.r = 1;
		returnColor.g = 0.45;
	elseif (health > 0) then
		returnColor.r = 1;
		returnColor.g = 0.1;
		returnColor.b = 0.1;
	else
		returnColor.r = 0.5;
		returnColor.g = 0.5;
		returnColor.b = 0.5;
	end
	
	return returnColor;
end

function MonitorStatus_GetManaColor(mana)
	local returnColor = { r = 0, g = 0, b = 0 };
	if (mana >= 100) then
		returnColor.r = 1;
		returnColor.g = 1;
		returnColor.b = 1;		
	elseif (mana > 80) then
		returnColor.b = 1;
	elseif (mana > 60) then
		returnColor.b = 0.75;
	elseif (mana > 40) then
		returnColor.g = 1;
		returnColor.b = 1;
	elseif (mana > 20) then
		returnColor.g = 1;
		returnColor.b = 0.45;
	elseif (mana > 0) then	
		returnColor.r = 0.1;
		returnColor.g = 1;
		returnColor.b = 0.1;
	else
		returnColor.r = 1;
		returnColor.g = 1;
		returnColor.b = 1;
	end

	return returnColor;
end


-- added by sarf

function MonitorStatus_Print(msg,r,g,b,frame,id,unknown4th)
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


function MonitorStatus_Register_Cosmos()
	if ( ( Cosmos_RegisterConfiguration ) and ( MonitorStatus_CosmosRegistered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS",
			"SECTION",
			MONITORSTATUS_CONFIG_HEADER,
			MONITORSTATUS_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_HEADER",
			"SEPARATOR",
			MONITORSTATUS_CONFIG_HEADER,
			MONITORSTATUS_CONFIG_HEADER_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_ENABLED",
			"CHECKBOX",
			MONITORSTATUS_ENABLED,
			MONITORSTATUS_ENABLED_INFO,
			MonitorStatus_Toggle_Enabled,
			MonitorStatus_Enabled
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_ONLYDURINGCOMBAT",
			"CHECKBOX",
			MONITORSTATUS_ONLYDURINGCOMBAT,
			MONITORSTATUS_ONLYDURINGCOMBAT_INFO,
			MonitorStatus_Toggle_OnlyDuringCombat,
			MonitorStatus_OnlyDuringCombat
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_HIDEMANA",
			"CHECKBOX",
			MONITORSTATUS_HIDEMANA,
			MONITORSTATUS_HIDEMANA_INFO,
			MonitorStatus_Toggle_HideMana,
			MonitorStatus_HideMana
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_SHOWPERCENT",
			"CHECKBOX",
			MONITORSTATUS_SHOWPERCENT,
			MONITORSTATUS_SHOWPERCENT_INFO,
			MonitorStatus_Toggle_ShowPercent,
			MonitorStatus_ShowPercent
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_SHOWTARGET",
			"CHECKBOX",
			MONITORSTATUS_SHOWTARGET,
			MONITORSTATUS_SHOWTARGET_INFO,
			MonitorStatus_Toggle_ShowTarget,
			MonitorStatus_ShowTarget
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_SHOWPLAYER",
			"CHECKBOX",
			MONITORSTATUS_SHOWPLAYER,
			MONITORSTATUS_SHOWPLAYER_INFO,
			MonitorStatus_Toggle_ShowPlayer,
			MonitorStatus_ShowPlayer
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_SHOWPET",
			"CHECKBOX",
			MONITORSTATUS_SHOWPET,
			MONITORSTATUS_SHOWPET_INFO,
			MonitorStatus_Toggle_ShowPet,
			MonitorStatus_ShowPet
		);
		Cosmos_RegisterConfiguration(
			"COS_MONITORSTATUS_SHOWPARTY",
			"CHECKBOX",
			MONITORSTATUS_SHOWPARTY,
			MONITORSTATUS_SHOWPARTY_INFO,
			MonitorStatus_Toggle_ShowParty,
			MonitorStatus_ShowParty
		);
		
		MonitorStatus_CosmosRegistered = 1;
	end
end


function MonitorStatus_Register()
	if ( Cosmos_RegisterConfiguration ) then
		MonitorStatus_Register_Cosmos();
	else
		SlashCmdList["MONITORSTATUSSLASHENABLE"] = MonitorStatus_Enable_ChatCommandHandler;
		SLASH_MONITORSTATUSSLASHENABLE1 = "/monitorstatusenable";
		SLASH_MONITORSTATUSSLASHENABLE2 = "/msenable";
		SLASH_MONITORSTATUSSLASHENABLE3 = "/monitorstatusdisable";
		SLASH_MONITORSTATUSSLASHENABLE4 = "/msdisable";
		SLASH_MONITORSTATUSSLASHENABLE5 = "/monitorstatustoggle";
		SLASH_MONITORSTATUSSLASHENABLE6 = "/mstoggle";
		this:RegisterEvent("VARIABLES_LOADED");
	end
	if ( Cosmos_RegisterChatCommand ) then
		local MonitorStatusEnableCommands = {"/monitorstatusenable","/msenable","/monitorstatusdisable","/msdisable", "/monitorstatustoggle", "/mstoggle"};
		Cosmos_RegisterChatCommand (
			"MONITORSTATUS_ENABLE_COMMANDS", -- Some Unique Group ID
			MonitorStatusEnableCommands, -- The Commands
			MonitorStatus_Enable_ChatCommandHandler,
			MONITORSTATUS_CHAT_COMMAND_ENABLE_INFO -- Description String
		);
	end

	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
end


function MonitorStatus_Enable_ChatCommandHandler(msg)
	msg = string.lower(msg);
	
	-- Toggle appropriately
	if ( (string.find(msg, 'on')) or ((string.find(msg, '1')) and (not string.find(msg, '-1')) ) ) then
		MonitorStatus_Toggle_Enabled(1);
	else
		if ( (string.find(msg, 'off')) or (string.find(msg, '0')) ) then
			MonitorStatus_Toggle_Enabled(0);
		else
			MonitorStatus_Toggle_Enabled(-1);
		end
	end
end

function MonitorStatus_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		if(MonitorStatus_CosmosRegistered == 0) then
			local value = getglobal("COS_MONITORSTATUS_ENABLED_X");
			if (value == nil ) then
				-- defaults to off
				value = 0;
			end
			MonitorStatus_Toggle_Enabled(value);
			
			value = getglobal("COS_MONITORSTATUS_ONLYDURINGCOMBAT_X");
			if(value == nil) then
				-- default to off
				value = 0;
			end
			MonitorStatus_Toggle_OnlyDuringCombat(value);
			
			value = getglobal("COS_MONITORSTATUS_HIDEMANA_X");
			if(value == nil) then
				-- default to off
				value = 0;
			end
			MonitorStatus_Toggle_HideMana(value);

			value = getglobal("COS_MONITORSTATUS_SHOWPERCENT_X");
			if (value == nil) then
				-- default to true
				value = 1;
			end
			MonitorStatus_Toggle_ShowPercent(value);

			value = getglobal("COS_MONITORSTATUS_SHOWTARGET_X");
			if (value == nil) then
				-- default to true
				value = 1;
			end
			MonitorStatus_Toggle_ShowTarget(value);

			value = getglobal("COS_MONITORSTATUS_SHOWPLAYER_X");
			if (value == nil) then
				-- default to true
				value = 1;
			end
			MonitorStatus_Toggle_ShowPlayer(value);

			value = getglobal("COS_MONITORSTATUS_SHOWPET_X");
			if (value == nil) then
				-- default to true
				value = 1;
			end
			MonitorStatus_Toggle_ShowPet(value);

			value = getglobal("COS_MONITORSTATUS_SHOWPARTY_X");
			if (value == nil) then
				-- default to true
				value = 1;
			end
			MonitorStatus_Toggle_ShowParty(value);

		end
		return;
	elseif( event == "PLAYER_ENTER_COMBAT") then
		localInCombat = 1;
	elseif( event == "PLAYER_LEAVE_COMBAT" ) then
		localInCombat = nil;
	elseif( event == "PLAYER_REGEN_ENABLED") then
		playerRegenEnabled = 1;
	elseif( event == "PLAYER_REGEN_DISABLED") then
		playerRegenEnabled = nil;
	end
end

function MonitorStatus_Update_Window_State(toggle)
	if ( toggle == 1 ) then
		MonitorStatus:Show();
	else
		MonitorStatus:Hide();
	end
end

function MonitorStatus_Toggle_Enabled(toggle)
	local oldvalue = MonitorStatus_Enabled;
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
	MonitorStatus_Enabled = newvalue;
	MonitorStatus_Update_Window_State(newvalue);
	setglobal("COS_MONITORSTATUS_ENABLED_X", newvalue);
	if ( newvalue ~= oldvalue ) then
		if ( newvalue == 1 ) then
			MonitorStatus_Print(MONITORSTATUS_CHAT_ENABLED);
		else
			MonitorStatus_Print(MONITORSTATUS_CHAT_DISABLED);
		end
	end
	MonitorStatus_Register_Cosmos();
	--if ( MonitorStatus_CosmosRegistered == 0 ) then 
		RegisterForSave("COS_MONITORSTATUS_ENABLED_X");	
	--end
end


function MonitorStatus_Toggle_OnlyDuringCombat(toggle)
	local oldvalue = MonitorStatus_OnlyDuringCombat;
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
	MonitorStatus_OnlyDuringCombat = newvalue;
	setglobal("COS_MONITORSTATUS_ONLYDURINGCOMBAT_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_ONLYDURINGCOMBAT_X");	
end

function MonitorStatus_Toggle_HideMana(toggle)
	local oldvalue = MonitorStatus_HideMana;
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
	MonitorStatus_HideMana = newvalue;
	setglobal("COS_MONITORSTATUS_HIDEMANA_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_HIDEMANA_X");	
end

function MonitorStatus_Toggle_ShowPercent(toggle)
	local oldvalue = MonitorStatus_ShowPercent;
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
	MonitorStatus_ShowPercent = newvalue;
	setglobal("COS_MONITORSTATUS_SHOWPERCENT_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_SHOWPERCENT_X");	
end

function MonitorStatus_Toggle_ShowTarget(toggle)
	local oldvalue = MonitorStatus_ShowTarget;
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
	MonitorStatus_ShowTarget = newvalue;
	if(newvalue == 0) then
		local prefix = "Target";
		local conditionText = getglobal(prefix.."StatusConditionText");
		local healthText = getglobal(prefix.."StatusHealthText");
		local nameText = getglobal(prefix.."StatusNameText");
		local manaText = getglobal(prefix.."StatusManaText");
		if(nameText) then
			nameText:SetText("");
			healthText:SetText("");
			manaText:SetText("");
			conditionText:SetText("");
		end
	end
	
	setglobal("COS_MONITORSTATUS_SHOWTARGET_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_SHOWTARGET_X");	
end

function MonitorStatus_Toggle_ShowPlayer(toggle)
	local oldvalue = MonitorStatus_ShowPlayer;
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
	MonitorStatus_ShowPlayer = newvalue;
	if(newvalue == 0) then
		local prefix = "Player";
		local conditionText = getglobal(prefix.."StatusConditionText");
		local healthText = getglobal(prefix.."StatusHealthText");
		local nameText = getglobal(prefix.."StatusNameText");
		local manaText = getglobal(prefix.."StatusManaText");
		if(nameText) then
			nameText:SetText("");
			healthText:SetText("");
			manaText:SetText("");
			conditionText:SetText("");
		end
	end
	setglobal("COS_MONITORSTATUS_SHOWPLAYER_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_SHOWPLAYER_X");	
end

function MonitorStatus_Toggle_ShowPet(toggle)
	local oldvalue = MonitorStatus_ShowPet;
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
	MonitorStatus_ShowPet = newvalue;
	if(newvalue == 0) then
		local prefix = "Pet";
		local conditionText = getglobal(prefix.."StatusConditionText");
		local healthText = getglobal(prefix.."StatusHealthText");
		local nameText = getglobal(prefix.."StatusNameText");
		local manaText = getglobal(prefix.."StatusManaText");
		if(nameText) then
			nameText:SetText("");
			healthText:SetText("");
			manaText:SetText("");
			conditionText:SetText("");
		end
	end
	setglobal("COS_MONITORSTATUS_SHOWPET_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_SHOWPET_X");	
end

function MonitorStatus_Toggle_ShowParty(toggle)
	local oldvalue = MonitorStatus_ShowParty;
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
	MonitorStatus_ShowParty = newvalue;
	if(newvalue == 0) then
		local nameList = { "PartyOne", "PartyTwo", "PartyThree", "PartyFour" };
		for i,v in ipairs(nameList) do
			local prefix = v;
			local conditionText = getglobal(prefix.."StatusConditionText");
			local healthText = getglobal(prefix.."StatusHealthText");
			local nameText = getglobal(prefix.."StatusNameText");
			local manaText = getglobal(prefix.."StatusManaText");
			if(nameText) then
				nameText:SetText("");
				healthText:SetText("");
				manaText:SetText("");
				conditionText:SetText("");
			end
		end
	end
	setglobal("COS_MONITORSTATUS_SHOWPARTY_X", newvalue);
	MonitorStatus_Register_Cosmos();
	RegisterForSave("COS_MONITORSTATUS_SHOWPARTY_X");	
end
