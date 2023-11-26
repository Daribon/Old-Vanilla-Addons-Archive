
function Nurfed_StatusBar_OnLoad()
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MAXMANA");
	this:RegisterEvent("UNIT_MAXRAGE");
	this:RegisterEvent("UNIT_MAXFOCUS");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
end

function Nurfed_StatusBar_OnEvent(event)
	if (event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH") then
		Nurfed_UpdateHealth(arg1);
		return;
	end

	if ( (event == "UNIT_MANA") or (event == "UNIT_MAXMANA") or (event == "UNIT_RAGE") or (event == "UNIT_MAXRAGE") or (event == "UNIT_ENERGY") or (event == "UNIT_MAXENERGY") or (event == "UNIT_FOCUS") or (event == "UNIT_MAXFOCUS") ) then
		Nurfed_UpdateMana(arg1);
		return;
	end

	if (event == "UNIT_DISPLAYPOWER") then
		Nurfed_UpdateManaType(arg1);
		return;
	end
end

function Nurfed_UpdateHealth(unit)
	local healthbar = getglobal("Nurfed_"..unit.."HealthBar");
	if (not healthbar) then return; end
	local healthbartext = getglobal("Nurfed_"..unit.."HealthBarText");
	local healthtext = getglobal("Nurfed_"..unit.."HealthText");
	local healthperc = getglobal("Nurfed_"..unit.."HealthPerc");
	local currhp = UnitHealth(unit);
	local maxhp = UnitHealthMax(unit);
	local perchp = ceil((currhp / maxhp) * 100);
	local unitcheck, text, telo, value, r, g, b;
	if (unit == "target" or unit == "targettarget") then
		Telo = Nurfed_TargetGetTelosInfo(unit);
	end
	if (Telo and (unit == "target" or unit == "targettarget")) then
		currhp = telocurr;
		maxhp = telomax;
	end
	healthbar:SetMinMaxValues(0,maxhp);
	healthbar:SetValue(currhp);
	healthbartext:SetText(currhp.."/"..maxhp);

	if (strsub(unit,1,5) == "party") then
		unitcheck = "party";
	else
		unitcheck = unit;
	end

	if (Nurfed_UnitFrames[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 1) then
		text = " ";
	elseif (Nurfed_UnitFrames[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 2) then
		text = currhp - maxhp;
	elseif (Nurfed_UnitFrames[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 3) then
		text = currhp;
	end
	if (unit == "targettarget" and (Nurfed_UnitFrames[Nurfed_UnitPlayer]["targettargettarget"] ~= 1) ) then
		text = currhp;
	end
	healthtext:SetText(text);

	if ( UnitIsDead(unit) ) then
		healthbartext:SetText(NURFED_UNIT_DEAD);
		healthtext:SetText(NURFED_UNIT_DEAD);
		r = 1;
		g = 0;
		b = 0;
	elseif ( UnitIsGhost(unit) ) then
		healthbartext:SetText(NURFED_UNIT_GHOST);
		healthtext:SetText(NURFED_UNIT_GHOST);
		r = 1;
		g = 0;
		b = 0;
	elseif ( not UnitIsConnected(unit) ) then
		healthbartext:SetText(NURFED_UNIT_OFFLINE);
		healthtext:SetText(NURFED_UNIT_OFFLINE);
		healthbar:SetValue(0);
		r = 0.75;
		g = 0.75;
		b = 0.75;
	else
		if ( (maxhp - currhp) < 0 ) then
			value = 0;
		else
			value = currhp / maxhp;
		end
		if(value > 0.5) then
			r = (1.0 - value) * 2;
			g = 1.0;
		else
			r = 1.0;
			g = value * 2;
		end
		b = 0;
	end

	if (healthperc and (perchp < 101) ) then
		healthperc:SetText(perchp.."%");
		healthperc:SetTextColor(r, g, 0);
	end
	healthtext:SetTextColor(r, g, b);
end

function Nurfed_UpdateBarTextures()
	local textured = Nurfed_UnitFrames[Nurfed_UnitPlayer].texturedBars;
	for _,unit in Nurfed_Units do
		local healthbar = getglobal("Nurfed_"..unit.."HealthBarTex");
		local manabar = getglobal("Nurfed_"..unit.."ManaBarTex");
		local healthbarBG = getglobal("Nurfed_"..unit.."HealthBarBG");
		healthbarBG:SetVertexColor(1, 0, 0, 0.25);
		if (textured == 1) then
			healthbar:SetTexture("Interface\\AddOns\\Nurfed_UnitFrames\\images\\nurfed_statusbar.tga");
			if (manabar) then
				manabar:SetTexture("Interface\\AddOns\\Nurfed_UnitFrames\\images\\nurfed_statusbar.tga");
			end
			if (unit == "player") then
				Nurfed_playerXPBarTex:SetTexture("Interface\\AddOns\\Nurfed_UnitFrames\\images\\nurfed_statusbar.tga");
			end
		else
			healthbar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
			if (manabar) then
				manabar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
			end
			if (unit == "player") then
				Nurfed_playerXPBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
			end
		end
	end
end

function Nurfed_UpdateBarText()
	local showtext = Nurfed_UnitFrames[Nurfed_UnitPlayer].showTextOnBars;
	local showxptext = Nurfed_UnitFrames[Nurfed_UnitPlayer].showXPTextOnBars;
	for _,unit in Nurfed_Units do
		local healthbartext = getglobal("Nurfed_"..unit.."HealthBarText");
		local manabartext = getglobal("Nurfed_"..unit.."ManaBarText");
		local xpbartext = getglobal("Nurfed_"..unit.."XPBarText");
		if (showtext == 1) then
			healthbartext:Show();
			if (manabartext) then
				manabartext:Show();
			end
		else
			healthbartext:Hide();
			if (manabartext) then
				manabartext:Hide();
			end
		end
		if (xpbartext) then
			if (showxptext == 1) then
				xpbartext:Show();
			else
				xpbartext:Hide();
			end
		end
	end
end

function Nurfed_UpdateMana(unit)
	local manabar = getglobal("Nurfed_"..unit.."ManaBar");
	if (not manabar) then return; end
	local manabartext = getglobal("Nurfed_"..unit.."ManaBarText");
	local manatext = getglobal("Nurfed_"..unit.."ManaText");
	local maxmana = UnitManaMax(unit);
	local currmana = UnitMana(unit);
	manabar:SetMinMaxValues(0,maxmana);
	manabar:SetValue(currmana);
	if ( not UnitIsConnected(unit) ) then
		manabar:SetValue(0);
	end
	manabartext:SetText(currmana.."/"..maxmana);
	if (manatext) then
		manatext:SetText(currmana);
	end
end

function Nurfed_UpdateManaType(unit)
	local manabar = getglobal("Nurfed_"..unit.."ManaBar");
	if (not manabar) then return; end
	local manatext = getglobal("Nurfed_"..unit.."ManaText");
	local manabarbg = getglobal("Nurfed_"..unit.."ManaBarBG");
	local manabarcolor = Nurfed_ManaBarColor[UnitPowerType(unit)];
	local manabarbgcolor = ManaBarColor[UnitPowerType(unit)];
	manabar:SetStatusBarColor(manabarcolor.r,manabarcolor.g,manabarcolor.b);
	manabarbg:SetVertexColor(manabarbgcolor.r,manabarbgcolor.g,manabarbgcolor.b, 0.25);
	manatext:SetTextColor(manabarcolor.r,manabarcolor.g,manabarcolor.b);
end

function Nurfed_StatusTextEnter(frame)
	local framename = this:GetName();
	local text = getglobal(frame.."Text");
	if (framename == "Nurfed_playerXPBar" or framename == "Nurfed_petXPBar") then
		if (Nurfed_UnitFrames[Nurfed_UnitPlayer].showXPTextOnBars == 0) then
			text:Show();
		end
	end
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer].showTextOnBars ~= 1) then
		text:Show();
	end
end

function Nurfed_StatusTextLeave(frame)
	local framename = this:GetName();
	local text = getglobal(frame.."Text");
	if (framename == "Nurfed_playerXPBar" or framename == "Nurfed_petXPBar") then
		if (Nurfed_UnitFrames[Nurfed_UnitPlayer].showXPTextOnBars == 1) then
			return;
		else
			text:Hide();
		end
	end
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer].showTextOnBars ~= 1) then
		text:Hide();
	end
end