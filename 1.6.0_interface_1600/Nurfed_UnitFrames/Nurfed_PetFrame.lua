--[[***** Nurfed PetFrame *****]]--

function Nurfed_PetFrame_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this.attackModeCounter = 0;
	this.attackModeSign = -1;
	this:RegisterEvent("UNIT_PET");
	this:RegisterEvent("PET_ATTACK_START");
	this:RegisterEvent("PET_ATTACK_STOP");
	this:RegisterEvent("UNIT_HAPPINESS");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_PET_EXPERIENCE");
	this:RegisterEvent("UNIT_LEVEL");

	table.insert(UnitPopupFrames,"Nurfed_petDropDown");
end

function Nurfed_PetFrame_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Nurfed_PetFrame_Update();
		return;
	end
	if ( event == "UNIT_PET" ) then
		Nurfed_PetFrame_Update();
		return;
	end
	if ( event == "PET_ATTACK_START" ) then
		Nurfed_petBackdrop:SetBackdropColor(0.5, 0, 0, 1.0);
		return;
	end
	if ( event == "PET_ATTACK_STOP" ) then
		local info = {};
		info = Nurfed_UnitFrames[Nurfed_UnitPlayer]["petColor"];
		Nurfed_petBackdrop:SetBackdropColor(info.r, info.g, info.b, info.a);
		return;
	end
	if ( event == "UNIT_HAPPINESS" ) then
		Nurfed_PetFrame_SetHappiness();
		return;
	end
	if ( event == "UNIT_PET_EXPERIENCE" ) then
		Nurfed_PetExpBar_Update();
		return;
	end
	if ( event == "UNIT_LEVEL" ) then
		Nurfed_UnitUpdateName("pet");
		return;
	end
end

function Nurfed_PetFrame_Update()
	if (UnitExists("pet")) then
		if ( not this:IsVisible() ) then
			this:Show();
		end
		Nurfed_UpdateHealth("pet");
		Nurfed_UpdateMana("pet");
		Nurfed_UpdateManaType("pet");
		Nurfed_RefreshAuras("pet", 8, 8);
		Nurfed_PetFrame_SetHappiness();
		Nurfed_PetExpBar_Update();
	else
		this:Hide();
	end
end

function Nurfed_PetExpBar_Update()
	local currXP, nextXP = GetPetExperience();
	Nurfed_petXPBar:SetMinMaxValues(min(0, currXP), nextXP);
	Nurfed_petXPBar:SetValue(currXP);
end

function Nurfed_PetFrame_SetHappiness()
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness();
	local hasPetUI, isHunterPet = HasPetUI();
	if ( not happiness or not isHunterPet ) then
		Nurfed_petXPBar:Hide();
		Nurfed_pet:SetHeight(43);
		return;
	end
	if (nextXP and (nextXP < 54350)) then
		Nurfed_pet:SetHeight(53);
		Nurfed_petXPBar:Show();
	end
	local currHappiness = getglobal("PET_HAPPINESS"..happiness);
	local name = UnitLevel("pet")..UnitName("pet");
	if ( happiness == 1 ) then
		Nurfed_petName:SetTextColor(1, 0.5, 0);
		Nurfed_petHappinessIcon:SetTexCoord(0.375, 0.5625, 0, 0.359375);
	elseif ( happiness == 2 ) then
		Nurfed_petName:SetTextColor(1, 1, 0);
		Nurfed_petHappinessIcon:SetTexCoord(0.1875, 0.375, 0, 0.359375);
	elseif ( happiness == 3 ) then
		Nurfed_petName:SetTextColor(0, 1, 0);
		Nurfed_petHappinessIcon:SetTexCoord(0, 0.1875, 0, 0.359375);
	end
	if ( loyaltyRate < 0 ) then
		Nurfed_petName:SetText("-"..name.."-");
	elseif ( loyaltyRate > 0 ) then
		Nurfed_petName:SetText("+"..name.."+");
	else
		Nurfed_petName:SetText(name);
	end
end
