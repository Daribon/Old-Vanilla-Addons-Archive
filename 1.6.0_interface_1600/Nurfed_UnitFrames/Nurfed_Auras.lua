
function Nurfed_Auras_OnLoad()
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
end

function Nurfed_Auras_OnEvent(event)
	if (not Nurfed_UnitAuras[arg1]) then return; end
	if (arg1 == "target" or arg1 == "pet") then
		Nurfed_AuraUpdatePos(arg1);
	end
	Nurfed_RefreshAuras(arg1, Nurfed_UnitAuras[arg1].buffs, Nurfed_UnitAuras[arg1].debuffs);
end

function Nurfed_RefreshAuras(unit, maxbuffs, maxdebuffs)
	local debuff, buff, button, debuffborder, icon;
	for i=1, maxbuffs do
		buff = UnitBuff(unit, i);
		button = getglobal("Nurfed_"..unit.."Buff"..i);
		if ( buff ) then
			icon = getglobal(button:GetName().."Icon");
			icon:SetTexture(buff);
			button:Show();
			button.unit = unit;
			if (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
				if( Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBuffs ~=1)then
					button:Hide();
				else
					if (i == 1) then
						button:ClearAllPoints();
						button:SetPoint("TOPLEFT", "Nurfed_"..unit, "BOTTOMLEFT", 3, 0);
					end
				end
			end
		else
			button:Hide();
		end
	end

	for i=1, maxdebuffs do
		debuff = UnitDebuff(unit, i);
		button = getglobal("Nurfed_"..unit.."Debuff"..i);
		if ( debuff ) then
			icon = getglobal(button:GetName().."Icon");
			debuffborder = getglobal(button:GetName().."Border");
			icon:SetTexture(debuff);
			button:Show();
			button.isdebuff = 1;
			button.unit = unit;
			debuffborder:Show();
			if (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
				if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partyDeBuffs ~= 1) then
					button:Hide();
				else
					if (i == 1) then
						button:ClearAllPoints();
						button:SetPoint("TOPLEFT", "Nurfed_"..unit, "TOPRIGHT", 0, -5);
					end
					button:SetHeight(20);
					button:SetWidth(20);
					debuffborder:SetHeight(20);
					debuffborder:SetWidth(20);
				end
			elseif (unit == "partypet1" or unit == "partypet2" or unit == "partypet3" or unit == "partypet4") then
				if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partyPetShowDeBuffs ~= 1) then
					button:Hide();
				else
					if (i == 1) then
						button:ClearAllPoints();
						button:SetPoint("BOTTOMLEFT", "Nurfed_"..unit, "BOTTOMRIGHT", 0, -6);
					end
					button:SetHeight(20);
					button:SetWidth(20);
					debuffborder:SetHeight(20);
					debuffborder:SetWidth(20);
				end
			end
		else
			button:Hide();
		end
	end
end

--Set tooltip for auras
function Nurfed_SetAuraTooltip()
	if (not this:IsVisible()) then return; end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	local unit = this.unit;
	if (this.isdebuff == 1) then
		if (unit == "party") then
			GameTooltip:SetUnitDebuff("party"..this:GetParent():GetID(), this:GetID());
		else
			GameTooltip:SetUnitDebuff(unit, this:GetID());
		end
	else
		
		if (unit == "party") then
			GameTooltip:SetUnitBuff("party"..this:GetParent():GetID(), this:GetID());
		else
			GameTooltip:SetUnitBuff(unit, this:GetID());
		end
	end
end

function Nurfed_AuraUpdatePos(unit)
	if ( UnitIsFriend("player", "target") or unit == "pet" ) then
		getglobal("Nurfed_"..unit.."Buff1"):SetPoint("TOPLEFT", "Nurfed_"..unit, "BOTTOMLEFT", 3, 0);
		getglobal("Nurfed_"..unit.."Debuff1"):SetPoint("TOPLEFT", "Nurfed_"..unit.."Buff1", "BOTTOMLEFT", 0, -2);
	else
		getglobal("Nurfed_"..unit.."Debuff1"):SetPoint("TOPLEFT", "Nurfed_"..unit, "BOTTOMLEFT", 3, 0);
		getglobal("Nurfed_"..unit.."Buff1"):SetPoint("TOPLEFT", "Nurfed_"..unit.."Debuff1", "BOTTOMLEFT", 0, -2);
	end
end
