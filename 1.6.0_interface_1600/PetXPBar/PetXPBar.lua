-- Arys Simplified Pet XP Bar Mod

local PetXPBar_Vars = {};
PetXPBar_Vars.Enabled = true;
PetXPBar_Vars.CurrentLevel = 0;
PetXPBar_Vars.CurrentLoyalty = 0;
PetXPBar_Vars.CurrentXP = 0;
PetXPBar_Vars.LevelXP = 0;
PetXPBar_Vars.RemainXP = 0;
PetXPBar_Vars.PetName = "";
PetXPBar_Vars.LastXP = 0;
PetXPBar_Vars.LastXPGained = 0;
PetXPBar_Vars.StatusUpdate = false;
PetXPBar_Vars.StatusDelay = 4;
	
function PetXPBar_OnLoad() 
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_PET_CHANGED");	
	this:RegisterEvent("PET_UI_UPDATE");
	this:RegisterEvent("PET_UI_CLOSE");
	this:RegisterEvent("UNIT_PET_EXPERIENCE");
	PetXPBar_RegisterUltimateUIOptions();		
end

function PetXPBar_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(format("Current Information for %s", PetXPBar_Vars.PetName), 1, 1, 1);
	GameTooltip:AddLine("Level "..PetXPBar_Vars.CurrentLevel, "", 1, 1, 1);
	GameTooltip:AddLine(PetXPBar_Vars.CurrentLoyalty, "", 1, 1, 1);
	GameTooltip:AddLine("XP: "..PetXPBar_Vars.CurrentXP, "", 1, 1, 1);
	GameTooltip:AddLine("XP To Level: "..PetXPBar_Vars.RemainXP, "", 1, 1, 1);
	if (PetXPBar_Vars.LastXPGained < 0) then
		GameTooltip:AddLine("Last XP Gained: -", "", 1, 1, 1);
	else
		GameTooltip:AddLine("Last XP Gained: "..PetXPBar_Vars.LastXPGained, "", 1, 1, 1);
	end
	GameTooltip:Show();
end

function PetXPBar_OnLeave()
	GameTooltip:Hide();
end

function PetXPBar_SetPos()
	PetDebuff1:SetPoint("TOPLEFT", "PetFrame","BOTTOM", -20, -8);
	PetXPBar:SetPoint("TOPLEFT", "PetFrame", "BOTTOM", -37, 11);
	PetXPBar:SetAlpha(.9);
end

function PetXPBar_OnEvent(event)
	if (event == "PLAYER_ENTERING_WORLD") then
		PetXPBar_SetPos();
	end
	PetXPBar_UpdateXP(event);
end

function PetXPBar_UpdateXP(event)
	if (PetXPBar_Vars.Enabled) then
		if (UnitExists("pet") and UnitHealth("pet") > 0 and UnitClass("player") == "Hunter") then
			if (not PetXPBar:IsVisible()) then
				PetXPBar:Show();
				PetXPBar_Status:Show();
				PetXPBar_Text:Show();
				PetXPBar_PercentageText:Show();
			end
		else
			if (PetXPBar:IsVisible()) then		
				PetXPBar:Hide();
				PetXPBar_Status:Hide();
				PetXPBar_Text:Hide();
				PetXPBar_PercentageText:Hide();
			end
		end
		
		if ( UnitExists("pet") ) then
			PetXPBar_Vars.CurrentXP, PetXPBar_Vars.LevelXP = GetPetExperience();
			PetXPBar_Vars.CurrentLoyalty = GetPetLoyalty();
			PetXPBar_Vars.RemainXP = (PetXPBar_Vars.LevelXP - PetXPBar_Vars.CurrentXP);
			PetXPBar_Status:SetMinMaxValues(min(0, PetXPBar_Vars.CurrentXP), PetXPBar_Vars.LevelXP);		
			PetXPBar_Status:SetValue(PetXPBar_Vars.CurrentXP);
			PetXPBar_Text:Show();
			
			local xpGained = 0;
			if (event == "UNIT_PET_EXPERIENCE") then
				xpGained = PetXPBar_Vars.CurrentXP - PetXPBar_Vars.LastXP;
				PetXPBar_Vars.LastXP = PetXPBar_Vars.CurrentXP;
			end
			
			if (xpGained < 0) then
				PetXPBar_Vars.StatusUpdate = true;
				PetXPBar_Vars.LastXPGained = xpGained;
				PetXPBar_Text:SetText("Level "..UnitLevel("pet"));
				Chronos.scheduleByName("PETXPBAR_DELAY", PetXPBar_Vars.StatusDelay, PetXPBar_StatusUpdateComplete);
			elseif (xpGained > 0 and xpGained ~= PetXPBar_Vars.CurrentXP) then
				PetXPBar_Vars.StatusUpdate = true;
				PetXPBar_Vars.LastXPGained = xpGained;
				PetXPBar_Text:SetText("+"..xpGained);
				Chronos.scheduleByName("PETXPBAR_DELAY", PetXPBar_Vars.StatusDelay, PetXPBar_StatusUpdateComplete);			
			elseif (xpGained == 0 and not PetXPBar_Vars.StatusUpdate) then
				PetXPBar_Text:SetText(format("%s / %s", PetXPBar_Vars.CurrentXP, PetXPBar_Vars.LevelXP));
			end
			
			PetXPBar_Vars.CurrentLevel = UnitLevel("pet");
			PetXPBar_Vars.PetName = UnitName("pet");	
		end
	else
		if (PetXPBar:IsVisible()) then		
			PetXPBar:Hide();
			PetXPBar_Status:Hide();
			PetXPBar_Text:Hide();
			PetXPBar_PercentageText:Hide();
		end
	end
end

function PetXPBar_StatusUpdateComplete()
	PetXPBar_Vars.StatusUpdate = false;
	PetXPBar_Text:SetText(format("%s / %s", PetXPBar_Vars.CurrentXP, PetXPBar_Vars.LevelXP));
end

function PetXPBar_OnEnableUpdate(toggle)
	if (toggle == 0) then
		PetXPBar_Vars.Enabled = false;
		PetXPBar_UpdateXP();
	else
		PetXPBar_Vars.Enabled = true;
		PetXPBar_UpdateXP();
	end
end

function PetXPBar_OnDelayUpdate(toggle, value)
	PetXPBar_Vars.StatusDelay = value;
end

function PetXPBar_RegisterUltimateUIOptions()
	if( UltimateUI_RegisterConfiguration ) then
		UltimateUI_RegisterConfiguration("UUI_PETXPBAR",
			"SECTION",
			PETXPBAR_SEP,
			PETXPBAR_SEP_INFO
		);
		UltimateUI_RegisterConfiguration("UUI_PETXPBAR_SECTION",
			"SEPARATOR",
			PETXPBAR_SEP,
			PETXPBAR_SEP_INFO
		);
		UltimateUI_RegisterConfiguration("UUI_PETXPBAR_ENABLE",
			"CHECKBOX",
			PETXPBAR_ENABLED, 
			PETXPBAR_ENABLED_INFO,
			PetXPBar_OnEnableUpdate,
			1,
			1
		);
		UltimateUI_RegisterConfiguration("UUI_PETXPBAR_DELAY",
			"SLIDER",					
			PETXPBAR_DELAY,			 
			PETXPBAR_DELAY_INFO,													  
			PetXPBar_OnDelayUpdate,
			1,		
			4,										
			1,
			5,
			PETXPBAR_DELAY_SLIDER,		
			1,
			1,
			"",
			1
 		);
	end
end
