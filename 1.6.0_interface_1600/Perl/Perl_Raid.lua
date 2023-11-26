local FlashColorMax = 1;
local FlashColorMin = 0.10;
local FlashCycleTime = 0.75;
local FlashOnset = 0.3;
local FlashAlphaMax = 1;
local FlashAlphaMin = 0.3;
local thisid=nil;
local partyid=nil;
local feigning = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
local showing={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
local id=0;
local Warriors = {};
local updnum=41;
----------------------
-- Loading Function --
----------------------

function Perl_Raid_OnLoad()

	--Events
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_HAPPINESS");
	this:RegisterEvent("UNIT_MAXMANA");
	this:RegisterEvent("UNIT_MAXRAGE");
	this:RegisterEvent("UNIT_MAXFOCUS");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
	this:RegisterEvent("RAID_ROSTER_UPDATE");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("VARIABLES_LOADED");
	--for num=1,40 do
	--	getglobal("Perl_Raid"..num.."_StatsFrame_CastClickOverlay"):SetFrameLevel(getglobal("Perl_Raid"..num.."_StatsFrame"):GetFrameLevel() + 2);
	--end

end

-------------------
-- Event Handler --
-------------------

function Perl_Raid_OnEvent(event,unit)
	
	if event=="TARGET" then
		if unit then
			if Warriors[unit-40] then
				if UnitName("raid"..Warriors[unit-40].."target") then
					Perl_Raid_UpdateDisplay(unit, "Perl_Raid"..unit);	
				else
					getglobal("Perl_Raid"..unit):Hide();
				end
			end
		end
		return;
	end
	if ((event=="RAID_ROSTER_UPDATE") or (event=="VARIABLES_LOADED") or (event=="PARTY_MEMBERS_CHANGED") or (event=="PARTY_LEADER_CHANGED") or (event=="PARTY_LEADER_CHANGED")) then
		Perl_Raid_Position();
		for num=1,50 do
			Perl_Raid_UpdateDisplay(num, "Perl_Raid"..num);
		end
		return;
	end
	if unit then
		if UnitExists(unit) then
			id=Perl_Raid_FindNum(unit);
			if id then
				if UnitIsUnit(unit, "raid"..id) then
					if ((event=="UNIT_HEALTH") or (event=="UNIT_MAXHEALTH")) then
						Perl_Raid_UpdatePartyID(id);
						Perl_Raid_UpdateHealth(partyid, "Perl_Raid"..id);
					elseif ((event=="UNIT_MANA") or (event=="UNIT_MAXMANA") or (event=="UNIT_RAGE") or (event=="UNIT_MAXRAGE") or (event=="UNIT_ENERGY") or (event=="UNIT_MAXENERGY") or (event=="UNIT_FOCUS") or (event=="UNIT_MAXFOCUS")) then
						Perl_Raid_UpdatePartyID(id);
						Perl_Raid_UpdateMana(partyid, "Perl_Raid"..id);
					elseif (event=="UNIT_NAME_UPDATE") then
						Perl_Raid_UpdatePartyID(id);
						Perl_Raid_UpdateName(partyid, "Perl_Raid"..id);
					elseif (event=="UNIT_AURA") then
						Perl_Raid_UpdatePartyID(id);
						Perl_Raid_UpdateBuffs(partyid, "Perl_Raid"..id);
					elseif (event=="UNIT_DISPLAYPOWER") then
						Perl_Raid_UpdatePartyID(id);
						Perl_Raid_UpdateManaType(partyid, "Perl_Raid"..id);
						Perl_Raid_UpdateMana(partyid, "Perl_Raid"..id);
					else
						Perl_Raid_UpdateDisplay(id, "Perl_Raid"..id);
					end
				end
			end
			return;
		else
			for num=1,50 do
				Perl_Raid_UpdateDisplay(num, "Perl_Raid"..num);
			end
		end
	else
		for num=1,50 do
			Perl_Raid_UpdateDisplay(num, "Perl_Raid"..num);
		end
	end
end



-------------------------
-- The Update Function --
-------------------------
function Perl_Raid_UpdateDisplay(id, objectname)	
	Perl_Raid_UpdatePartyID(id);
	if ((UnitName(partyid) ~= nil) and (showing[id]==1)) then
		if (Perl_Config.ShowRaid==1 and showing[id]) then
			getglobal(objectname):Show();
		else
			getglobal(objectname):Hide();
			return;
		end
		if (UnitIsConnected(partyid)) then
			getglobal(objectname):SetAlpha(Perl_Config.Transparency);

		else
			getglobal(objectname):SetAlpha(Perl_Config.Transparency/2);
			getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText"):SetText("Offine");
		end
		
		if (Perl_Config.ShowRaidPercents==0) then
			getglobal(objectname.."_StatsFrame_ManaBar_ManaBarText"):Hide();
			getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText"):Hide();
		else 
			getglobal(objectname.."_StatsFrame_ManaBar_ManaBarText"):Show();
			getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText"):Show();
		end
		Perl_Raid_UpdateManaType(partyid, objectname);
		Perl_Raid_UpdateHealth(partyid, objectname);
		Perl_Raid_UpdateMana(partyid, objectname);
		Perl_Raid_UpdateName(partyid, objectname);
		
		
	else
		getglobal(objectname):Hide();
		getglobal(objectname):StopMovingOrSizing();
	end
end
function Perl_Raid_UpdatePartyID(id)
	if (id<=40) then
		partyid = ("raid"..id);
	else
		if Warriors[id-40] then
			partyid = ("raid"..Warriors[id-40].."target");
		else return;
		end
	end
end

function Perl_Raid_UpdateName(partyid,objectname)
	local name = UnitName(partyid);
	if ((objectname) and (name)) then
		if (strlen(name) > 10) then
			name = strsub(name, 1, 9).."...";
		end
		getglobal(objectname.."_NameFrame_NameBarText"):SetText(name);  
	end
end
function Perl_Raid_UpdateManaType(partyid, objectname)
	if(objectname) then
		local power = UnitPowerType(partyid);
		if  (power == 1) then
			getglobal(objectname.."_StatsFrame_ManaBar"):SetStatusBarColor(1, 0, 0, 1);
			getglobal(objectname.."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 0, 0, 0.25);
		elseif (power == 2) then
			getglobal(objectname.."_StatsFrame_ManaBar"):SetStatusBarColor(1, 0.5, 0, 1);
			getglobal(objectname.."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 0.5, 0, 0.25);
		elseif (power == 3) then
			getglobal(objectname.."_StatsFrame_ManaBar"):SetStatusBarColor(1, 1, 0, 1);
			getglobal(objectname.."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 1, 0, 0.25);
		else
			getglobal(objectname.."_StatsFrame_ManaBar"):SetStatusBarColor(0, 0, 1, 1);
			getglobal(objectname.."_StatsFrame_ManaBarBG"):SetStatusBarColor(0, 0, 1, 0.25);
		end
	end
end
function Perl_Raid_UpdateHealth(partyid, objectname)
	if(objectname) then
		local health = UnitHealth(partyid);
		local healthmax = UnitHealthMax(partyid);
		phealthPct = (health * 100.0) / healthmax;
		phealthPct = string.format("%3.0f", phealthPct);
		if (UnitIsConnected(partyid)) then
			getglobal(objectname.."_StatsFrame_HealthBar_HealthBarText"):SetText(phealthPct.."%");
		end
		getglobal(objectname.."_StatsFrame_HealthBar"):SetValue(health);
		getglobal(objectname.."_StatsFrame_HealthBar"):SetMinMaxValues(0, healthmax);
		Perl_SetSmoothBarColor(getglobal(objectname.."_StatsFrame_HealthBar"));
		Perl_SetSmoothBarColor(getglobal(objectname.."_StatsFrame_HealthBarBG"),getglobal(objectname.."_StatsFrame_HealthBar"), 0.25);
	end
end
function Perl_Raid_UpdateMana(partyid, objectname)
	if(objectname) then
		local mana = UnitMana(partyid);
		local manamax = UnitManaMax(partyid);
		pmanaPct = (mana * 100.0) / manamax;
		pmanaPct =  string.format("%3.0f", pmanaPct);
		
		getglobal(objectname.."_StatsFrame_ManaBar_ManaBarText"):SetText(pmanaPct.."%");
		getglobal(objectname.."_StatsFrame_ManaBar"):SetMinMaxValues(0, manamax);
		getglobal(objectname.."_StatsFrame_ManaBar"):SetValue(mana);
	end
end
function Perl_Raid_OnUpdate()
	updnum=(1+updnum);
	if (updnum==60) then updnum=41; end
	if (updnum<51) then Perl_Raid_OnEvent("TARGET", updnum); end
end

function Perl_Raid_UpdateBuffs(partyid, objectname)
	local class=UnitClass("player");
	if BuffStatusTooltip then
		if class==PERL_LOC_CLASS_MAGE then
			if (UnitDebuffType(partyid, "Curse")) then
				getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1,0,0);  
			else
				if UnitClass(partyid)==PERL_LOC_CLASS_WARRIOR then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_MAGE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_ROGUE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_DRUID then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_HUNTER then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_SHAMAN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PRIEST then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_WARLOCK then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PALADIN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				end
			end
		elseif class==PERL_LOC_CLASS_DRUID then
			if (UnitDebuffType(partyid, "Curse") or UnitDebuffType(partyid, "Poison")) then
				getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1,0,0);  
			else
				if UnitClass(partyid)==PERL_LOC_CLASS_WARRIOR then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_MAGE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_ROGUE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_DRUID then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_HUNTER then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_SHAMAN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PRIEST then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_WARLOCK then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PALADIN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				end
			end
		elseif class==PERL_LOC_CLASS_PRIEST then
			if (UnitDebuffType(partyid, "Magic")) then
				getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1,0,0);  
			else
				if UnitClass(partyid)==PERL_LOC_CLASS_WARRIOR then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_MAGE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_ROGUE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_DRUID then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_HUNTER then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_SHAMAN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PRIEST then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_WARLOCK then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PALADIN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				end
			end
		elseif class==PERL_LOC_CLASS_WARLOCK then
			if (UnitDebuffType(partyid, "Magic")) then
				getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1,0,0);  
			else
				if UnitClass(partyid)==PERL_LOC_CLASS_WARRIOR then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_MAGE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_ROGUE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_DRUID then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_HUNTER then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_SHAMAN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PRIEST then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_WARLOCK then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PALADIN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				end
			end
		elseif class==PERL_LOC_CLASS_PALADIN then
			if (UnitDebuffType(partyid, "Magic") or UnitDebuffType(partyid, "Poison") or UnitDebuffType(partyid, "Disease")) then
				getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1,0,0);  
			else
				if UnitClass(partyid)==PERL_LOC_CLASS_WARRIOR then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_MAGE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_ROGUE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_DRUID then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_HUNTER then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_SHAMAN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PRIEST then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_WARLOCK then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PALADIN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				end
			end
		elseif class==PERL_LOC_CLASS_SHAMAN then
			if (UnitDebuffType(partyid, "Poison") or UnitDebuffType(partyid, "Disease")) then
				getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1,0,0);  
			else
				if UnitClass(partyid)==PERL_LOC_CLASS_WARRIOR then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_MAGE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_ROGUE then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_DRUID then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_HUNTER then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_SHAMAN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PRIEST then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_WARLOCK then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
				elseif UnitClass(partyid)==PERL_LOC_CLASS_PALADIN then
					getglobal(objectname.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
				end
			end
		else return; end
	end
end	
--------------------
-- Raid Functions --
--------------------
function Perl_Raid_Position()
	Perl_Raid_Grp1:Show();
	Perl_Raid_Grp2:Show();
	Perl_Raid_Grp3:Show();
	Perl_Raid_Grp4:Show();
	Perl_Raid_Grp5:Show();
	Perl_Raid_Grp6:Show();
	Perl_Raid_Grp7:Show();
	Perl_Raid_Grp8:Show();
	Perl_Raid_Grp9:Show();
	local p=1;
	if (Perl_Config.SortRaidByClass==1) then
		Perl_Raid_Classes();
	else
		Perl_Raid_Groups();
	end
	Perl_Raid_Grp9_NameFrame_NameBarText:SetText("Targets");
	-- put target ones under their lineup frames
	for num=41,50 do
		getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp9", "BOTTOMLEFT", 0,(2-((num-41)*44)));
		if (Warriors[num-40]) then
			if (UnitName("raid"..Warriors[num-40].."target")) then
				getglobal("Perl_Raid"..num):Show();
			else
				getglobal("Perl_Raid"..num):Hide();
			end
			if (Perl_Config.ShowGroup9==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		else
			getglobal("Perl_Raid"..num):Hide();
			showing[num]=0;
		end
		
	end
	
	if Perl_Config.ShowRaid==0 then 
		Perl_Raid_Frame:UnregisterEvent("UNIT_HEALTH");
		Perl_Raid_Frame:UnregisterEvent("UNIT_MAXHEALTH");
		Perl_Raid_Frame:UnregisterEvent("UNIT_MANA");
		Perl_Raid_Frame:UnregisterEvent("UNIT_RAGE");
		Perl_Raid_Frame:UnregisterEvent("UNIT_FOCUS");
		Perl_Raid_Frame:UnregisterEvent("UNIT_ENERGY");
		Perl_Raid_Frame:UnregisterEvent("UNIT_HAPPINESS");
		Perl_Raid_Frame:UnregisterEvent("UNIT_MAXMANA");
		Perl_Raid_Frame:UnregisterEvent("UNIT_MAXRAGE");
		Perl_Raid_Frame:UnregisterEvent("UNIT_MAXFOCUS");
		Perl_Raid_Frame:UnregisterEvent("UNIT_MAXENERGY");
		Perl_Raid_Frame:UnregisterEvent("UNIT_DISPLAYPOWER");
		Perl_Raid_Frame:UnregisterEvent("RAID_ROSTER_UPDATE");
		Perl_Raid_Frame:UnregisterEvent("PARTY_LEADER_CHANGED");
		Perl_Raid_Frame:UnregisterEvent("UNIT_AURA");
		for num=1,50 do
			getglobal("Perl_Raid"..num):Hide();
			Perl_Raid_UpdateDisplay(num, "Perl_Raid"..num);
			showing[num]=0;
		end
	else
		Perl_Raid_Frame:RegisterEvent("UNIT_HEALTH");
		Perl_Raid_Frame:RegisterEvent("UNIT_MAXHEALTH");
		Perl_Raid_Frame:RegisterEvent("UNIT_MANA");
		Perl_Raid_Frame:RegisterEvent("UNIT_RAGE");
		Perl_Raid_Frame:RegisterEvent("UNIT_FOCUS");
		Perl_Raid_Frame:RegisterEvent("UNIT_ENERGY");
		Perl_Raid_Frame:RegisterEvent("UNIT_HAPPINESS");
		Perl_Raid_Frame:RegisterEvent("UNIT_MAXMANA");
		Perl_Raid_Frame:RegisterEvent("UNIT_MAXRAGE");
		Perl_Raid_Frame:RegisterEvent("UNIT_MAXFOCUS");
		Perl_Raid_Frame:RegisterEvent("UNIT_MAXENERGY");
		Perl_Raid_Frame:RegisterEvent("UNIT_DISPLAYPOWER");
		Perl_Raid_Frame:RegisterEvent("RAID_ROSTER_UPDATE");
		Perl_Raid_Frame:RegisterEvent("PARTY_LEADER_CHANGED");
		Perl_Raid_Frame:RegisterEvent("UNIT_AURA");
		for num=1,50 do
			if (showing[num]==1) then
				getglobal("Perl_Raid"..num):Show();
			else
				getglobal("Perl_Raid"..num):Hide();
			end
			Perl_Raid_UpdateDisplay(num, "Perl_Raid"..num);
		end
		for num=1,40 do
			if UnitClass("raid"..num)==PERL_LOC_CLASS_WARRIOR then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(0.78, 0.61, 0.43);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_MAGE then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(0.41, 0.8, 0.94);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_ROGUE then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(1, 0.96, 0.41);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_DRUID then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(1, 0.49, 0.04);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_HUNTER then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(0.67, 0.83, 0.45);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_SHAMAN then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_PRIEST then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(1, 1, 1);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_WARLOCK then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(0.58, 0.51, 0.79);
			elseif UnitClass("raid"..num)==PERL_LOC_CLASS_PALADIN then
				getglobal("Perl_Raid"..num.."_NameFrame_NameBarText"):SetTextColor(0.96, 0.55, 0.73);
			end
		end
	end
	if perl_locked==1 then 
		Perl_Raid_Grp1:Hide();
		Perl_Raid_Grp2:Hide();
		Perl_Raid_Grp3:Hide();
		Perl_Raid_Grp4:Hide();
		Perl_Raid_Grp5:Hide();
		Perl_Raid_Grp6:Hide();
		Perl_Raid_Grp7:Hide();
		Perl_Raid_Grp8:Hide();
		Perl_Raid_Grp9:Hide();
	end
end
function Perl_Raid_Classes()
	Warriors={};
	local wpos=1;
	local wa=0;
	local m=0;
	local p=0;
	local wr=0;
	local d=0;
	local r=0;
	local h=0;
	local ps=0;
	Perl_Raid_Grp1_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_WARRIOR);
	Perl_Raid_Grp2_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_MAGE);
	Perl_Raid_Grp3_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_PRIEST);
	Perl_Raid_Grp4_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_WARLOCK);
	Perl_Raid_Grp5_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_DRUID);
	Perl_Raid_Grp6_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_ROGUE);
	Perl_Raid_Grp7_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_HUNTER);
	Perl_Raid_Grp8_NameFrame_NameBarText:SetText(PERL_LOC_CLASS_PALADIN.."/"..PERL_LOC_CLASS_SHAMAN);
	for num=1,40 do
		if (UnitClass("raid"..num)==PERL_LOC_CLASS_WARRIOR) then
			Warriors[wpos]=num;
			wpos=wpos+1;
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp1", "BOTTOMLEFT", 0,(2-(wa*44)));
			wa=wa+1;
			if (Perl_Config.ShowGroup1==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_MAGE) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp2", "BOTTOMLEFT", 0,(2-(m*44)));
			m=m+1;
			if (Perl_Config.ShowGroup2==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_PRIEST) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp3", "BOTTOMLEFT", 0,(2-(p*44)));
			p=p+1;
			if (Perl_Config.ShowGroup3==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_WARLOCK) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp4", "BOTTOMLEFT", 0,(2-(wr*44)));
			wr=wr+1;
			if (Perl_Config.ShowGroup4==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_DRUID) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp5", "BOTTOMLEFT", 0,(2-(d*44)));
			d=d+1;
			if (Perl_Config.ShowGroup5==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_ROGUE) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp6", "BOTTOMLEFT", 0,(2-(r*44)));
			r=r+1;
			if (Perl_Config.ShowGroup6==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_HUNTER) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp7", "BOTTOMLEFT", 0,(2-(h*44)));
			h=h+1;
			if (Perl_Config.ShowGroup7==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_PALADIN) then
			if ps==0 then Perl_Raid_Grp8_NameFrame_NameBarText:SetText("Paladin"); end
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp8", "BOTTOMLEFT", 0,(2-(ps*44)));
			ps=ps+1;
			if (Perl_Config.ShowGroup8==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (UnitClass("raid"..num)==PERL_LOC_CLASS_SHAMAN) then
			if ps==0 then Perl_Raid_Grp8_NameFrame_NameBarText:SetText("Shaman"); end
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp8", "BOTTOMLEFT", 0,(2-(ps*44)));
			ps=ps+1;
			if (Perl_Config.ShowGroup8==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		else
			getglobal("Perl_Raid"..num):Hide();
			showing[num]=0;
		end
	end
end
function Perl_Raid_Groups()
	Warriors={};
	local wpos=1;
	local ga=0;
	local gb=0;
	local gc=0;
	local gd=0;
	local ge=0;
	local gf=0;
	local gg=0;
	local gh=0;
	Perl_Raid_Grp1_NameFrame_NameBarText:SetText("Group 1");
	Perl_Raid_Grp2_NameFrame_NameBarText:SetText("Group 2");
	Perl_Raid_Grp3_NameFrame_NameBarText:SetText("Group 3");
	Perl_Raid_Grp4_NameFrame_NameBarText:SetText("Group 4");
	Perl_Raid_Grp5_NameFrame_NameBarText:SetText("Group 5");
	Perl_Raid_Grp6_NameFrame_NameBarText:SetText("Group 6");
	Perl_Raid_Grp7_NameFrame_NameBarText:SetText("Group 7");
	Perl_Raid_Grp8_NameFrame_NameBarText:SetText("Group 8");
	for num=1,40 do
		local name, rank, subgroup= GetRaidRosterInfo(num);
		if (UnitClass("raid"..num)=="Warrior") then
			Warriors[wpos]=num;
			wpos=wpos+1;
		end
		if ((subgroup==1) and (name)) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp1", "BOTTOMLEFT", 0,(2-(ga*44)));
			ga=ga+1;
			if (Perl_Config.ShowGroup1==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==2) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp2", "BOTTOMLEFT", 0,(2-(gb*44)));
			gb=gb+1;
			if (Perl_Config.ShowGroup2==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==3) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp3", "BOTTOMLEFT", 0,(2-(gc*44)));
			gc=gc+1;
			if (Perl_Config.ShowGroup3==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==4) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp4", "BOTTOMLEFT", 0,(2-(gd*44)));
			gd=gd+1;
			if (Perl_Config.ShowGroup4==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==5) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp5", "BOTTOMLEFT", 0,(2-(ge*44)));
			ge=ge+1;
			if (Perl_Config.ShowGroup5==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==6) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp6", "BOTTOMLEFT", 0,(2-(gf*44)));
			gf=gf+1;
			if (Perl_Config.ShowGroup6==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==7) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp7", "BOTTOMLEFT", 0,(2-(gg*44)));
			gg=gg+1;
			if (Perl_Config.ShowGroup7==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		elseif (subgroup==8) then
			getglobal("Perl_Raid"..num):SetPoint("TOPLEFT", "Perl_Raid_Grp8", "BOTTOMLEFT", 0,(2-(gh*44)));
			gh=gh+1;
			if (Perl_Config.ShowGroup8==0) then
				showing[num]=0;
			else
				showing[num]=1;
			end
		else
			getglobal("Perl_Raid"..num):Hide();
			showing[num]=0;
		end
		
	end
end
--------------------
-- Click Handlers --
--------------------
function Perl_Raid_FindID(object)
	local name=object:GetName();
	for num=10,50 do
		if (strfind(name, num)) then
			return num;
		end
	end
	for num=1,9 do
		if (strfind(name, num)) then
			return num;
		end
	end
	return nil;
end
function Perl_Raid_FindNum(partyid)
	
	for num=10,50 do
		if (strfind(partyid, num)) then
			return num;
		end
	end
	for num=1,9 do
		if (strfind(partyid, num)) then
			return num;
		end
	end
	return nil;
end
function Perl_RaidDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_RaidDropDown_Initialize, "MENU");
end
				
function Perl_RaidDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	UnitPopup_ShowMenu(dropdown, "PARTY", "party"..this:GetID());
end
function Perl_Raid_OnClick(button)
	if (CastParty_constants and (Perl_Config.CastParty==1) and (this:GetID()<=40)) then
		local id=Perl_Raid_FindID(this);
		this:SetID(id+4);
		CastParty_OnClick(button);
		this:SetID(id);
	end
end
function Perl_Raid_MouseUp(button)
		local id=Perl_Raid_FindID(this);
		this:SetID(id);
		if (this:GetID()<=40) then
			partyid = ("raid"..this:GetID());
		else
			if Warriors[this:GetID()-40] then
				partyid = ("raid"..Warriors[this:GetID()-40].."target");
			else return;
			end
		end
			
			if ( SpellIsTargeting() and button == "RightButton" ) then
				SpellStopTargeting();
				return;
			end
			if ( button == "LeftButton" ) then
				if ( SpellIsTargeting() ) then
					SpellTargetUnit(partyid);
				elseif ( CursorHasItem() ) then
					DropItemOnUnit(partyid);
				else
					TargetUnit(partyid);
				end
			else
				if ((this:GetName())==("Perl_Raid"..id)) then ToggleDropDownMenu(1, nil, getglobal(this:GetName().."_DropDown"), this:GetName(), 0, 0); end
			end
		getglobal("Perl_Raid"..id):StopMovingOrSizing();
end

function Perl_Raid_TitleMouseUp(button)
	
		this:StopMovingOrSizing();
end

function Perl_Raid_MouseDown(button)
	if ( button == "LeftButton" and perl_locked == 0) then
		this:StartMoving();
	end
end

function Perl_Raid_PlayerTip()
	local id=Perl_Raid_FindID(this);
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	partyid=nil;
	if (this:GetID()<=40) then
		partyid = ("raid"..this:GetID());
	else
		if Warriors[this:GetID()-40] then
			partyid = ("raid"..Warriors[this:GetID()-40].."target");
		else return;
		end
	
	end
	if partyid then GameTooltip:SetUnit(partyid); end
end