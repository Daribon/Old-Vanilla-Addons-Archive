MAX_PARTY_PETS = 4;
PARTYPET_FRAME_SHOWN = 1;
MAX_PARTYPET_DEBUFFS = 4;
MAX_PARTYPET_BUFFS = 4;
--MAX_PARTYPET_TOOLTIP_BUFFS = 16;
--MAX_PARTYPET_TOOLTIP_DEBUFFS = 8;
-- lowered until I can optimize the buff transmission code
MAX_PARTYPET_TOOLTIP_BUFFS = 4;
MAX_PARTYPET_TOOLTIP_DEBUFFS = 4;

function PartyPetFrame_OnLoad()
	this.statusCounter = 0;
	this.statusSign = -1;
	this.unitHPPercent = 1;
	this.needsUpdate = false;
	this.alpha = PartyPets_Config.Alpha;
	this:SetAlpha(PartyPets_Config.Alpha);
	PartyPetFrame_UpdateMember();
end

function PartyPetFrame_UpdateMember()
	local id = this:GetID();
	if ( GetPartyPet(id) ) then
--		PetUnitFrame_UpdateManaType();
		PetUnitFrame_Update();
		if ( PARTYPET_FRAME_SHOWN == 1 ) then
			this:Show();
		end
	else
		this:Hide();
	end
	this.alpha = PartyPets_Config.Alpha;
	PartyPetFrame_SetPositions();
	PartyPetFrame_RefreshBuffs();
end

function PartyPetFrame_SetPositions()
	if (PartyPets_Config.Layout ~= PARTYPETS_LAYOUTO) then
		local topLevelParent = getglobal("PartyPetsTextButton");
		local anchorPoint = "TOPLEFT";
		local relativePoint = "BOTTOMLEFT";
		local offsetX = -5;
		local offsetY = -5;
		local axis = "vertical";
		
		if (PartyPets_Config.Layout == PARTYPETS_LAYOUTVU) then
			relativePoint = "TOPLEFT";
			offsetY = 52;
			axis = "vertical";
		elseif (PartyPets_Config.Layout == PARTYPETS_LAYOUTHR) then
			relativePoint = "TOPLEFT";
			offsetX = 128;
			axis = "horizontal";
		elseif (PartyPets_Config.Layout == PARTYPETS_LAYOUTHL) then
			relativePoint = "TOPLEFT";
			offsetX = -128;
			axis = "horizontal";
		end

		for i=1, MAX_PARTY_PETS, 1 do
			if (not getglobal("PartyPetFrame"..i)) then
				return;
			elseif (getglobal("PartyPetFrame"..i):IsShown()) then
				getglobal("PartyPetFrame"..i):SetPoint(anchorPoint, topLevelParent:GetName(), relativePoint, offsetX, offsetY);
				topLevelParent = getglobal("PartyPetFrame"..i);
				if (axis == "horizontal") then
					offsetY = 0;
				elseif (axis == "vertical") then
					offsetX = 0;
				end
			end
		end
	else
		for i=1, MAX_PARTY_PETS, 1 do
			if (not getglobal("PartyPetFrame"..i)) then
				return;
			elseif (getglobal("PartyPetFrame"..i):IsShown()) then
				local partyUnit = PPClient_GetPartyUnit(PartyPets_Vars.ServerList[i]);
				local topLevelParent = getglobal("PartyPetsTextButton");
				if (partyUnit == "party1") then
					topLevelParent = getglobal("PartyMemberFrame1");
				elseif (partyUnit == "party2") then
					topLevelParent = getglobal("PartyMemberFrame2");
				elseif (partyUnit == "party3") then
					topLevelParent = getglobal("PartyMemberFrame3");
				elseif (partyUnit == "party4") then
					topLevelParent = getglobal("PartyMemberFrame4");
				end
				
				getglobal("PartyPetFrame"..i):SetPoint("TOPLEFT", topLevelParent:GetName(), "TOPRIGHT", PartyPets_Config.OffsetX, 0);
			end
		end
	end
end

function PartyPetFrame_UpdateMemberHealth(elapsed)
	if ( (this.unitHPPercent > 0) and (this.unitHPPercent <= 0.2) ) then
		local alpha = 255;
		local counter = this.statusCounter + elapsed;
		local sign    = this.statusSign;

		if ( counter > 0.5 ) then
			sign = -sign;
			this.statusSign = sign;
		end
		counter = mod(counter, 0.5);
		this.statusCounter = counter;

		if ( sign == 1 ) then
			alpha = (127  + (counter * 256)) / 255;
		else
			alpha = (255 - (counter * 256)) / 255;
		end
		getglobal(this:GetName().."Portrait"):SetAlpha(alpha);
	else
		this:SetAlpha(this.alpha);
	end
	
end

function PartyPetFrame_OnUpdate(elapsed)
	if (this.needsUpdate) then
		PartyPetFrame_UpdateMember();
		this.needsUpdate = false;
	end
end

function PartyPetFrame_OnEvent(event)
--	if (PetWatch_Config.ClientEnabled) then
--		if (event == "CHAT_MSG_WHISPER" and strfind(arg1, PWP_SERVERMSG)) then
--			PartyPetFrame_UpdateMember();
--			return;
--		end
--	end
end

function PartyPetFrame_OnClick(partyFrame)
	if ( SpellIsTargeting() and arg1 == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( not partyFrame ) then
		partyFrame = this;
	end
	local unit = PPClient_GetPartyUnit(PartyPets_Vars.ServerList[this:GetID()])
	if ( arg1 == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			PartyPets_ActionOnTargetPet(unit, SpellTargetUnit);
		else
			TargetUnitsPet(unit);
		end
	else
		ToggleDropDownMenu(1, nil, getglobal("PartyPetFrame"..partyFrame:GetID().."DropDown"), partyFrame:GetName(), 47, 15);
	end
end

function PartyPetFrame_RefreshBuffs()
	local debuff, debuffButton;
	for i=1, MAX_PARTYPET_DEBUFFS do
		debuff = PetUnitDebuff("partypet"..this:GetID(), i);
		if ( debuff ) then
			getglobal(this:GetName().."Debuff"..i.."Icon"):SetTexture(debuff);
			getglobal(this:GetName().."Debuff"..i):Show();
		else
			getglobal(this:GetName().."Debuff"..i):Hide();
		end
	end

	local buff, buffButton;
	for i=1, MAX_PARTYPET_BUFFS do
		buff = PetUnitBuff("partypet"..this:GetID(), i);
		if ( buff ) then
			getglobal(this:GetName().."Buff"..i.."Icon"):SetTexture(buff);
			getglobal(this:GetName().."Buff"..i):Show();
		else
			getglobal(this:GetName().."Buff"..i):Hide();
		end
	end
end

function PartyPetBuffTooltip_Update()
	local buff, buffButton;
	local numBuffs = 0;
	local numDebuffs = 0;
	local index = 1;
	for i=1, MAX_PARTYPET_TOOLTIP_BUFFS do
		buff = PetUnitBuff("partypet"..this:GetID(), i);
		if ( buff ) then
			getglobal("PartyPetBuffTooltipBuff"..index.."Icon"):SetTexture(buff);
			getglobal("PartyPetBuffTooltipBuff"..index.."Overlay"):Hide();
			getglobal("PartyPetBuffTooltipBuff"..index):Show();
			index = index + 1;
			numBuffs = numBuffs + 1;
		end
	end
	for i=index, MAX_PARTYPET_TOOLTIP_BUFFS do
		getglobal("PartyPetBuffTooltipBuff"..i):Hide();
	end

	if ( numBuffs == 0 ) then
		PartyPetBuffTooltipDebuff1:SetPoint("TOP", "PartyPetBuffTooltipBuff1", "TOP", 0, 0);
	elseif ( numBuffs <= 8 ) then
		PartyPetBuffTooltipDebuff1:SetPoint("TOP", "PartyPetBuffTooltipBuff1", "BOTTOM", 0, -2);
	else
		PartyPetBuffTooltipDebuff1:SetPoint("TOP", "PartyPetBuffTooltipBuff9", "BOTTOM", 0, -2);
	end

	index = 1;
	for i=1, MAX_PARTYPET_TOOLTIP_DEBUFFS do
		buff = PetUnitDebuff("partypet"..this:GetID(), i);
		if ( buff ) then
			getglobal("PartyPetBuffTooltipDebuff"..index.."Icon"):SetTexture(buff);
			getglobal("PartyPetBuffTooltipDebuff"..index.."Overlay"):Show();
			getglobal("PartyPetBuffTooltipDebuff"..index):Show();
			index = index + 1;
			numDebuffs = numDebuffs + 1;
		end
	end
	for i=index, MAX_PARTYPET_TOOLTIP_DEBUFFS do
		getglobal("PartyPetBuffTooltipDebuff"..i):Hide();
	end

	-- Size the tooltip
	local rows = ceil(numBuffs / 8) + ceil(numDebuffs / 8);
	local columns = min(8, max(numBuffs, numDebuffs));
	if ( (rows > 0) and (columns > 0) ) then
		PartyPetBuffTooltip:SetWidth( (columns * 17) + 15 );
		PartyPetBuffTooltip:SetHeight( (rows * 17) + 15 );
		PartyPetBuffTooltip:Show();
	else
		PartyPetBuffTooltip:Hide();
	end
end

function PartyPetHealthCheck()
	local prefix = this:GetParent():GetName();
	local unitMinHP, unitMaxHP, unitCurrHP;
	unitHPMin, unitHPMax = this:GetMinMaxValues();
	unitCurrHP = this:GetValue();
	if ( unitHPMax > 0 ) then
		this:GetParent().unitHPPercent = unitCurrHP / unitHPMax;
	else
		this:GetParent().unitHPPercent = 0;
	end
	if ( PetUnitIsDead("partypet"..this:GetParent():GetID()) ) then
		getglobal(prefix.."Portrait"):SetVertexColor(0.35, 0.35, 0.35, 1.0);
	elseif ( (this:GetParent().unitHPPercent > 0) and (this:GetParent().unitHPPercent <= 0.2) ) then
		getglobal(prefix):SetAlpha(1.0);
		getglobal(prefix.."Portrait"):SetVertexColor(1.0, 0.0, 0.0);
	else
		local alpha = getglobal(prefix).alpha;
		if (alpha) then
			getglobal(prefix):SetAlpha(alpha);
		end
		getglobal(prefix.."Portrait"):SetVertexColor(1.0, 1.0, 1.0, 1.0);
	end
end

function PartyPetDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, PartyPetDropDown_Initialize, "MENU");
end

function PartyPetDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	UnitPopup_ShowMenu(dropdown, "PARTY", "partypet"..this:GetID());
end
