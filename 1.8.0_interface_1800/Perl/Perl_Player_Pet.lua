

----------------------
-- Loading Function --
----------------------

function Perl_Player_Pet_OnLoad()

	-- Events
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
	this:RegisterEvent("UNIT_PET");
	this:RegisterEvent("UNIT_HAPPINESS");
	

	table.insert(UnitPopupFrames,"Perl_Player_Pet_DropDown");
end


-------------------
-- Event Handler --
-------------------

function Perl_Player_Pet_OnEvent(event, unit)
	if (event == "UNIT_AURA") then
		if arg1=="pet" then
			Perl_Player_Pet_Buff_UpdateAll();
		end
	elseif (event==UNIT_RAGE or event=="UNIT_ENERGY" or event=="UNIT_MANA" or event=="UNIT_HEALTH" or event=="UNIT_LEVEL" or event=="UNIT_DISPLAYPOWER" or event=="UNIT_HAPPINESS") then
		if arg1=="pet" then
			Perl_Player_Pet_UpdateDisplay();	
		end
	else
		Perl_Player_Pet_UpdateDisplay();
	end
end

-------------------------
-- The Update Function --
-------------------------

function Perl_Player_Pet_UpdateDisplay ()

	-- set common variables
	local petmana = UnitMana("pet");
	local petmanamax = UnitManaMax("pet");
	local pethealth = UnitHealth("pet");
	local pethealthmax = UnitHealthMax("pet");
	local petlevel = UnitLevel("pet");
	local petpower = UnitPowerType("pet");
	local petxp, petxpmax = GetPetExperience();
	Perl_Player_Pet_NameBarText:SetText(UnitName("pet"));
	if UnitName("pet") then
		Perl_Player_Pet_Frame:Show();
	else
		Perl_Player_Pet_Frame:Hide();
	end
	-- Set mana bar color
	if (petpower == 1) then
		Perl_Player_Pet_ManaBar:SetStatusBarColor(1, 0, 0, 1);
		Perl_Player_Pet_ManaBarBG:SetStatusBarColor(1, 0, 0, 0.25);
	elseif (petpower == 2) then
		Perl_Player_Pet_ManaBar:SetStatusBarColor(1, 0.5, 0, 1);
		Perl_Player_Pet_ManaBarBG:SetStatusBarColor(1, 0.5, 0, 0.25);
	elseif (petpower == 3) then
		Perl_Player_Pet_ManaBar:SetStatusBarColor(1, 1, 0, 1);
		Perl_Player_Pet_ManaBarBG:SetStatusBarColor(1, 1, 0, 0.25);
	else
		Perl_Player_Pet_ManaBar:SetStatusBarColor(0, 0, 1, 1);
		Perl_Player_Pet_ManaBarBG:SetStatusBarColor(0, 0, 1, 0.25);
	end
	
	Perl_Player_Pet_XPBar:SetStatusBarColor(0.3, 0.3, 1, 1);
	Perl_Player_Pet_XPBarBG:SetStatusBarColor(0.3, 0.3, 1, 0.25);
	
	-- Set Statistics
	Perl_Player_Pet_HealthBar:SetMinMaxValues(0, pethealthmax);
	Perl_Player_Pet_ManaBar:SetMinMaxValues(0, petmanamax);
	Perl_Player_Pet_XPBar:SetMinMaxValues(0, petxpmax);
	Perl_Player_Pet_XPBar:SetValue(petxp);
	Perl_Player_Pet_HealthBar:SetValue(pethealth);
	Perl_Player_Pet_ManaBar:SetValue(petmana);
	Perl_SetSmoothBarColor(Perl_Player_Pet_HealthBar);
	Perl_SetSmoothBarColor(Perl_Player_Pet_HealthBarBG, Perl_Player_Pet_HealthBar, 0.25);
	
	
	if (Perl_Config.ShowPetXP==0) then
		Perl_Player_Pet_XPBar:Hide();
		Perl_Player_Pet_StatsFrame:SetHeight(34);
	else
		Perl_Player_Pet_XPBar:Show();
		Perl_Player_Pet_StatsFrame:SetHeight(44);
	end
	
	-- Set Level

	Perl_Player_Pet_LevelBarText:SetText(petlevel);
	
	-- Set Happiness
	
	Perl_Player_PetFrame_SetHappiness();
	Perl_Player_Pet_ManaBarText:Show();
	if (pethealth>0) then 
		Perl_Player_Pet_HealthBarText:SetText(pethealth.."/"..pethealthmax);
		Perl_Player_Pet_ManaBarText:SetText(petmana.."/"..petmanamax);
	else
		Perl_Player_Pet_HealthBarText:SetText("Dead");
		Perl_Player_Pet_ManaBarText:Hide();
	end
	
end

--------------------
-- Buff Functions --
--------------------

function Perl_Player_Pet_Buff_UpdateAll ()
	if (UnitName("pet")) then
		for buffnum=1,10 do
			local button = getglobal("Perl_Player_Pet_Buff"..buffnum);
			local icon = getglobal(button:GetName().."Icon");
			if (UnitBuff("pet", buffnum)) then
				icon:SetTexture(UnitBuff("pet", buffnum));
				button:Show();
			else
				button:Hide();
			end
		end
		for buffnum=1,8 do
			local button = getglobal("Perl_Player_Pet_DeBuff"..buffnum);
			local icon = getglobal(button:GetName().."Icon");
			if (UnitDebuff("pet", buffnum)) then
				GameTooltip:SetUnitDebuff("pet", buffnum);
				icon:SetTexture(UnitDebuff("pet", buffnum));
				button:Show();
			else
				button:Hide();
			end
		end
	end
end

function Perl_Player_Pet_SetBuffTooltip ()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetUnitBuff("pet", this:GetID());
end

function Perl_Player_Pet_SetDeBuffTooltip ()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:SetUnitDebuff("pet", this:GetID());
end

---------------
-- Happiness --
---------------

function Perl_Player_PetFrame_SetHappiness()
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness();
	
	if ( happiness == 1 ) then
		Perl_Player_PetHappinessTexture:SetTexCoord(0.375, 0.5625, 0, 0.359375);
	elseif ( happiness == 2 ) then
		Perl_Player_PetHappinessTexture:SetTexCoord(0.1875, 0.375, 0, 0.359375);
	elseif ( happiness == 3 ) then
		Perl_Player_PetHappinessTexture:SetTexCoord(0, 0.1875, 0, 0.359375);
	end
	if ( happiness ~= nil ) then
		Perl_Player_PetHappiness.tooltip = getglobal("PET_HAPPINESS"..happiness);
		Perl_Player_PetHappiness.tooltipDamage = format(PET_DAMAGE_PERCENTAGE, damagePercentage);
		if ( loyaltyRate < 0 ) then
			Perl_Player_PetHappiness.tooltipLoyalty = getglobal("LOSING_LOYALTY");
		elseif ( loyaltyRate > 0 ) then
			Perl_Player_PetHappiness.tooltipLoyalty = getglobal("GAINING_LOYALTY");
		else
			Perl_Player_PetHappiness.tooltipLoyalty = nil;
		end
	end
end

--------------------
-- Click Handlers --
--------------------

function Perl_Player_Pet_DropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_Player_Pet_DropDown_Initialize, "MENU");
end
				
function Perl_Player_Pet_DropDown_Initialize ()
		UnitPopup_ShowMenu(Perl_Player_Pet_DropDown, "PET", "pet");
end

function Perl_Player_Pet_MouseUp(button)

	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("pet");
		else
			TargetUnit("pet");
		end
	else
		ToggleDropDownMenu(1, nil, Perl_Player_Pet_DropDown, "Perl_Player_Pet_NameFrame", 40, 0);
	end
	
	Perl_Player_Pet_Frame:StopMovingOrSizing();
end

function Perl_Player_Pet_MouseDown(button)
	if ( button == "LeftButton" and perl_locked == 0) then
		Perl_Player_Pet_Frame:StartMoving();
	end
end
