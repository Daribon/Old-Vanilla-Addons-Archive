--[[
 MonitorStatus v1.1
 Originally made by wharvey 2004-2-23
 Currently maintained by David Hedbor <david@hedbor.org>
 Update to v0.5-0.7 by Joe "JoeFaust" Hartford <joefaust@cosmosui.org>
 Changes in version 1.1 by <zespri@mail.ru>:
 	* Removed Cosmos compatibility code, added Khaos comatibility instead
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

MonitorStatus_Enabled = false;
MonitorStatus_ShowPercent = true;
MonitorStatus_ShowTarget = true;
MonitorStatus_ShowPlayer = true;
MonitorStatus_ShowPet = true;
MonitorStatus_ShowParty = true;
MontiorStatus_OnlyDuringCombat = false;
MonitorStatus_HideMana = false;

local localInCombat = nil;
local playerRegenEnabled = 1;

function MonitorStatus_OnLoad()
	
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");

	MonitorStatus_CalculateValues();
	
	Chronos.scheduleByName("MONITORSTATUS_UPDATE", 1, MonitorStatus_OnUpdate);
end

function MonitorStatus_OnUpdate()
	if ( MonitorStatus:IsVisible() ) then
		MonitorStatus_CalculateValues();
	end
	Chronos.scheduleByName("MONITORSTATUS_UPDATE", .2, MonitorStatus_OnUpdate); 	
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
	
	if((MonitorStatus_OnlyDuringCombat ) and not MonitorStatus_IsPlayerInCombat()) then
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
		
		if(MonitorStatus_ShowPercent ) then 
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
		
		if(not MonitorStatus_HideMana ) then
			manaPct = (UnitMana(unitName) * 100.0) / UnitManaMax(unitName);
			manaColor = MonitorStatus_GetManaColor(manaPct);

			if(MonitorStatus_ShowPercent ) then
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
	if(MonitorStatus_ShowTarget ) then
		unitList[index] = { "target", "Target" };
		index = index + 1;
	end
	
	if(MonitorStatus_ShowPlayer ) then
		unitList[index] = { "player", "Player" };
		index = index + 1;
	end
	
	if(MonitorStatus_ShowPet ) then
		unitList[index] = { "pet", "Pet" };
		index = index + 1;
	end
	
	if(MonitorStatus_ShowParty ) then
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

function MonitorStatus_Register_Khaos()
	local optionSet = {
		id="MonitorStatus";
		text=MONITORSTATUS_CONFIG_HEADER;
		helptext=MONITORSTATUS_CONFIG_HEADER_INFO;
		difficulty=1;
		options={
			{
				id="Header";
				text=MONITORSTATUS_CONFIG_HEADER;
				helptext=MONITORSTATUS_CONFIG_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="Enable";
				type=K_TEXT;
				text=MONITORSTATUS_ENABLED;
				helptext=MONITORSTATUS_ENABLED_INFO;
				callback=MonitorStatus_Toggle_Enabled;
				feedback=function(state) return MONITORSTATUS_ENABLED_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableCombatOnly";
				type=K_TEXT;
				text=MONITORSTATUS_ONLYDURINGCOMBAT;
				helptext=MONITORSTATUS_ONLYDURINGCOMBAT_INFO;
				callback=function(toggle) MonitorStatus_OnlyDuringCombat = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_ONLYDURINGCOMBAT_INFO end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
			{
				id="EnableHideMana";
				type=K_TEXT;
				text=MONITORSTATUS_HIDEMANA;
				helptext=MONITORSTATUS_HIDEMANA_INFO;
				callback=function(toggle) MonitorStatus_HideMana = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_HIDEMANA_INFO end;
				check=true;
				default={checked=fasle};
				disabled={checked=false};
			};
			{
				id="EnablePercent";
				type=K_TEXT;
				text=MONITORSTATUS_SHOWPERCENT;
				helptext=MONITORSTATUS_SHOWPERCENT_INFO;
				callback=function(toggle) MonitorStatus_ShowPercent = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_SHOWPERCENT_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableTarget";
				type=K_TEXT;
				text=MONITORSTATUS_SHOWTARGET;
				helptext=MONITORSTATUS_SHOWTARGET_INFO;
				callback=function(toggle) MonitorStatus_ShowTarget = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_SHOWTARGET_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnablePlayer";
				type=K_TEXT;
				text=MONITORSTATUS_SHOWPLAYER;
				helptext=MONITORSTATUS_SHOWPLAYER_INFO;
				callback=function(toggle) MonitorStatus_ShowPlayer = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_SHOWPLAYER_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnablePet";
				type=K_TEXT;
				text=MONITORSTATUS_SHOWPET;
				helptext=MONITORSTATUS_SHOWPET_INFO;
				callback=function(toggle) MonitorStatus_ShowPet = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_SHOWPET_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableParty";
				type=K_TEXT;
				text=MONITORSTATUS_SHOWPARTY;
				helptext=MONITORSTATUS_SHOWPARTY_INFO;
				callback=function(toggle) MonitorStatus_ShowParty = (toggle.checked) end;
				feedback=function(state) return MONITORSTATUS_SHOWPARTY_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"combat",
		optionSet
	);
	MonitorStatus_KhaosRegistered = true;
end

function MonitorStatus_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		MonitorStatus_Register_Khaos();
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
	if ( toggle ) then
		MonitorStatus:Show();
	else
		MonitorStatus:Hide();
	end
end

function MonitorStatus_Toggle_Enabled(toggle)
	MonitorStatus_Enabled = (toggle.checked);
	MonitorStatus_Update_Window_State(toggle.checked);
end

