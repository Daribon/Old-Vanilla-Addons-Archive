
--Mana Color
local Nurfed_ManaBarColor = {
	[0] = { r = 0.00, g = 1.00, b = 1.00 },
	[1] = { r = 1.00, g = 0.00, b = 0.00 },
	[2] = { r = 1.00, g = 0.50, b = 0.25 },
	[3] = { r = 1.00, g = 1.00, b = 0.00 },
	[4] = { r = 0.00, g = 1.00, b = 1.00 },
};

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

local function Nurfed_TargetGetTelosInfo(unit)
	if ( UnitName(unit) and UnitLevel(unit) ) then
		local index = UnitName(unit)..":"..UnitLevel(unit);
		local text = "";

		if ( MobHealthDB and MobHealthDB[index] ) then
			local s, e;
			local pts;
			local pct;

			if ( type(MobHealthDB[index]) ~= "string" ) then
				return;
			end
			s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
			if ( pts and pct ) then
				pts = pts + 0;
				pct = pct + 0;
				if( pct ~= 0 ) then
					pointsPerPct = pts / pct;
				else
					pointsPerPct = 0;
				end
			end

			local currentPct = UnitHealth(unit);

			if ( pointsPerPct > 0 ) then	
				if ( currentPct ) then
					telocurr = string.format("%d", (currentPct * pointsPerPct) + 0.5);
					telomax = string.format("%d", (100 * pointsPerPct) + 0.5);
				else
					telocurr = string.format("%d", (100 * pointsPerPct) + 0.5);
					telomax = string.format("%d", (100 * pointsPerPct) + 0.5);
				end
			end
			return telocurr, telomax;
		else
			return nil;
		end
	else
		return nil;
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
	if (unit == "target" or unit == "targettarget" and not UnitIsPlayer(unit)) then
		Telo = Nurfed_TargetGetTelosInfo(unit);
	end
	if (Telo and (unit == "target" or unit == "targettarget" or unit == "targettargettarget" or unit == "pettarget" )) then
		currhp = telocurr;
		maxhp = telomax;
	end
	healthbar:SetMinMaxValues(0,maxhp);
	healthbar:SetValue(currhp);

	if (strsub(unit,1,5) == "party") then
		unitcheck = "party";
	else
		unitcheck = unit;
	end

	if (Nurfed_UnitConfig[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 1) then
		text = " ";
	elseif (Nurfed_UnitConfig[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 2) then
		text = currhp - maxhp;
	elseif (Nurfed_UnitConfig[Nurfed_UnitPlayer][unitcheck.."HPStyle"] == 3) then
		text = currhp;
	end
	if (unit == "pettarget" or unit == "targettarget" or unit == "targettargettarget") then
		text = currhp;
	end
	if (healthtext) then
		local layoutID = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout;
		if (layoutID == 3) then
			healthtext:SetText(text.."/"..maxhp);
		else
			healthtext:SetText(text);
		end
	end
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer].unitForceBarCurrent == 1) then
		text = currhp;
	end
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer].unitCurrentRedHP == 1) then
		text = "|cffff3333"..text.."|r";
	end
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer].unitBarMaxHP == 1) then
		healthbartext:SetText(text.."/"..maxhp);
	else
		healthbartext:SetText(text);
	end

	if ( UnitIsDead(unit) ) then
		healthbartext:SetText(NURFED_UNIT_DEAD);
		if (healthtext) then
			healthtext:SetText(NURFED_UNIT_DEAD);
		end
		r = 1;
		g = 0;
		b = 0;
	elseif ( UnitIsGhost(unit) ) then
		healthbartext:SetText(NURFED_UNIT_GHOST);
		if (healthtext) then
			healthtext:SetText(NURFED_UNIT_GHOST);
		end
		r = 1;
		g = 0;
		b = 0;
	elseif ( not UnitIsConnected(unit) ) then
		healthbartext:SetText(NURFED_UNIT_OFFLINE);
		if (healthtext) then
			healthtext:SetText(NURFED_UNIT_OFFLINE);
		end
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

	if (healthperc and (perchp < 101) and unit ~= "targettarget" and unit ~= "targettargettarget" and unit ~= "pettarget" ) then
		healthperc:SetText(perchp.."%");
		healthperc:SetTextColor(r, g, 0);
	end
	if (healthtext) then
		healthtext:SetTextColor(r, g, b);
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
	if (unit == "targettarget" and (Nurfed_UnitConfig[Nurfed_UnitPlayer]["targettargettarget"] ~= 1) ) then
		manatext:Show();
	end
	manabartext:SetText(currmana.."/"..maxmana);
	if (manatext) then
		local layoutID = Nurfed_UnitConfig[Nurfed_UnitPlayer].unitLayout;
		if (layoutID == 3) then
			manatext:SetText(currmana.."/"..maxmana);
		else
			manatext:SetText(currmana);
		end
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
		if (Nurfed_UnitConfig[Nurfed_UnitPlayer].showXPTextOnBars == 0) then
			text:Show();
		end
	end
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer].showTextOnBars ~= 1) then
		text:Show();
	end
end

function Nurfed_StatusTextLeave(frame)
	local framename = this:GetName();
	local text = getglobal(frame.."Text");
	if (framename == "Nurfed_playerXPBar" or framename == "Nurfed_petXPBar") then
		if (Nurfed_UnitConfig[Nurfed_UnitPlayer].showXPTextOnBars == 1) then
			return;
		else
			text:Hide();
		end
	end
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer].showTextOnBars ~= 1) then
		text:Hide();
	end
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
