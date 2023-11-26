local FlashColorMax = 1;
local FlashColorMin = 0.10;
local FlashCycleTime = 0.75;
local FlashOnset = 0.3;
local FlashAlphaMax = 1;
local FlashAlphaMin = 0.3;
local thisid=nil;
local partyid=nil;
local feigning = {0,0,0,0};
local PartyName = {
	["Perl_party1"] = "party1",
	["Perl_party2"] = "party2",
	["Perl_party3"] = "party3",
	["Perl_party4"] = "party4",
};
----------------------
-- Loading Function --
----------------------

function Perl_Party_OnLoad()

	--Events
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	this:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	this:RegisterEvent("UNIT_PVP_UPDATE");
	this:RegisterEvent("UNIT_AURA");
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
	this:RegisterEvent("UNIT_MAXHAPPINESS");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	this:RegisterEvent("UNIT_DISPLAYPOWER");	
	
	
	table.insert(UnitPopupFrames,"Perl_party1_DropDown");
	table.insert(UnitPopupFrames,"Perl_party2_DropDown");
	table.insert(UnitPopupFrames,"Perl_party3_DropDown");
	table.insert(UnitPopupFrames,"Perl_party4_DropDown");
	
	
	getglobal("Perl_party"..this:GetID().."_StatsFrame_CastClickOverlay"):SetFrameLevel(getglobal("Perl_party"..this:GetID().."_StatsFrame"):GetFrameLevel() + 2);
	
	
	
	HidePartyFrame();
	
end

-------------------
-- Event Handler --
-------------------

function Perl_Party_OnEvent(event,unit)
	partyid = ("party"..this:GetID());
	if ((event=="PARTY_LEADER_CHANGED") or (event=="PARTY_MEMBERS_CHANGED") or (event=="PARTY_MEMBER_ENABLE") or (event=="PARTY_MEMBER_DISABLE") or (event=="PARTY_LOOT_METHOD_CHANGED")) then
		Perl_Party_UpdateDisplay();
		return;
	end
	if (unit) then
		if ((unit==partyid)) then
			if ((event=="UNIT_HEALTH") or (event=="UNIT_MAXHEALTH")) then
				Perl_Party_UpdateDisplay();
			elseif ((event=="UNIT_MANA") or (event=="UNIT_MAXMANA") or (event=="UNIT_RAGE") or (event=="UNIT_MAXRAGE") or (event=="UNIT_ENERGY") or (event=="UNIT_MAXENERGY") or (event=="UNIT_FOCUS") or (event=="UNIT_MAXFOCUS")) then
				Perl_Party_UpdateMana();
			elseif (event=="UNIT_DISPLAYPOWER") then
				Perl_Party_UpdateManaType();
			elseif (event=="UNIT_NAME_UPDATE") then
				Perl_Party_UpdateName();
			elseif (event=="UNIT_AURA") then
				Perl_Party_Buff_UpdateAll();
			elseif (event=="UNIT_PVP_UPDATE") then
				Perl_Party_UpdatePVP();
			else
				Perl_Party_UpdateDisplay();
			end
		elseif strfind(event, "UNIT") then
			if (UnitIsUnit(unit, partyid)) then
				if ((event=="UNIT_HEALTH") or (event=="UNIT_MAXHEALTH")) then
					Perl_Party_UpdateDisplay();
				elseif ((event=="UNIT_MANA") or (event=="UNIT_MAXMANA") or (event=="UNIT_RAGE") or (event=="UNIT_MAXRAGE") or (event=="UNIT_ENERGY") or (event=="UNIT_MAXENERGY") or (event=="UNIT_FOCUS") or (event=="UNIT_MAXFOCUS")) then
					Perl_Party_UpdateMana();
				elseif (event=="UNIT_DISPLAYPOWER") then
					Perl_Party_UpdateManaType();
				elseif (event=="UNIT_NAME_UPDATE") then
					Perl_Party_UpdateName();
				elseif (event=="UNIT_AURA") then
					Perl_Party_Buff_UpdateAll();
				elseif (event=="UNIT_PVP_UPDATE") then
					Perl_Party_UpdatePVP();
				else
					Perl_Party_UpdateDisplay();
				end
			end
		else
			Perl_Party_UpdateDisplay();
		end
	else
		Perl_Party_UpdateDisplay();
	end
	HidePartyFrame();
end



-------------------------
-- The Update Function --
-------------------------

function Perl_Party_UpdateDisplay ()
		partyid = ("party"..this:GetID());
		thisid=this:GetName();
		if (UnitName(partyid)) then
			Perl_Party_UpdateName();
			Perl_Party_UpdateLeader();
			Perl_Party_UpdatePVP();
			Perl_Party_UpdateClass();
			Perl_Party_UpdateManaType();
			Perl_Party_UpdateHealth();
			Perl_Party_UpdateMana();
			Perl_Party_UpdateLevel();
			if this:GetID()==1 then Perl_UpdatePartyDistance(); end
			if (UnitName("raid1")) then
				if (Perl_Config.ShowPartyRaid==1) then 
					this:Show();
				elseif (Perl_Config.ShowPartyRaid==0) then 
					this:Hide();
				end
			else
				this:Show();
			end
	
		else
			getglobal("Perl_Party_Pet"..this:GetID()):Hide();
			this:Hide();
			this:StopMovingOrSizing();
		end
		HidePartyFrame();
end
function Perl_Party_UpdateName()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	local Partyname = UnitName(partyid);
	if (Partyname) then
		if (strlen(Partyname) > 40) then
			Partyname = strsub(Partyname, 1, 39).."...";
		end
		if (Perl_Config.ShowPartyNames==1) then getglobal(this:GetName().."_NameFrame"):Show(); end
		getglobal(this:GetName().."_NameFrame_NameBarText"):SetText(Partyname);  
	
		if (UnitIsPVP(partyid)) then
			getglobal(this:GetName().."_NameFrame_NameBarText"):SetTextColor(0,1,0);
		else
			getglobal(this:GetName().."_NameFrame_NameBarText"):SetTextColor(0.5,0.5,1);
		end
	end
end
function Perl_Party_UpdateLeader()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	local id = this:GetID();
	local icon = getglobal(this:GetName().."_NameFrame_LeaderIcon");
	if (GetPartyLeaderIndex() == id ) then
		icon:Show();
	else
		icon:Hide();
	end
	icon = getglobal(this:GetName().."_NameFrame_MasterIcon");
	local lootMethod;
	local lootMaster;
	lootMethod, lootMaster = GetLootMethod();
	if ( id == lootMaster ) then
		icon:Show();
	else
		icon:Hide();
	end
end
function Perl_Party_UpdatePVP()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	if (UnitIsPVP(partyid)) then
		if (UnitFactionGroup(partyid) == "Alliance") then
			getglobal(this:GetName().."_NameFrame_PVPStatus"):SetTexture("Interface\\TargetingFrame\\UI-PVP-Alliance");
		elseif (UnitFactionGroup(partyid) == "Horde") then
			getglobal(this:GetName().."_NameFrame_PVPStatus"):SetTexture("Interface\\TargetingFrame\\UI-PVP-Horde");
		else
			getglobal(this:GetName().."_NameFrame_PVPStatus"):SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		end
		getglobal(this:GetName().."_NameFrame_PVPStatus"):Show();
	else
		getglobal(this:GetName().."_NameFrame_PVPStatus"):Hide();
	end		
end
function Perl_Party_UpdateLevel()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	local Partylevel = UnitLevel(partyid);
	local color = GetDifficultyColor(Partylevel);
	getglobal(this:GetName().."_LevelFrame_LevelBarText"):SetTextColor(color.r,color.g,color.b);
	getglobal(this:GetName().."_LevelFrame_LevelBarText"):SetText(Partylevel);
end
function Perl_Party_UpdateClass()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	if (UnitIsPlayer(partyid)) then
		local PlayerClass = UnitClass(partyid);
		getglobal(this:GetName().."_LevelFrame_ClassTexture"):SetTexCoord(Perl_ClassPosRight(PlayerClass), Perl_ClassPosLeft(PlayerClass), Perl_ClassPosTop(PlayerClass), Perl_ClassPosBottom(PlayerClass));
	end
	if (Perl_Config.ShowPartyClassIcon==1) then
		getglobal(this:GetName().."_LevelFrame_ClassTexture"):Show();
	else 
		getglobal(this:GetName().."_LevelFrame_ClassTexture"):Hide();
	end
end
function Perl_Party_UpdateManaType()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	local Partypower = UnitPowerType(partyid);
	if  (Partypower == 1) then
		getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(1, 0, 0, 1);
		getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 0, 0, 0.25);
	elseif (Partypower == 2) then
		getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(1, 0.5, 0, 1);
		getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 0.5, 0, 0.25);
	elseif (Partypower == 3) then
		getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(1, 1, 0, 1);
		getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 1, 0, 0.25);
	else
		getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(0, 0, 1, 1);
		getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(0, 0, 1, 0.25);
	end
end
function Perl_Party_UpdateHealth()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	local Partyhealth = UnitHealth(partyid);
	local Partyhealthmax = UnitHealthMax(partyid);
	if ((feigning[this:GetID()]==1) and (Partyhealth>1)) then
		feigning[this:GetID()]=0;
	end
	if  (feigning[this:GetID()]==1) then
		getglobal(this:GetName().."_StatsFrame_HealthBar"):SetMinMaxValues(0, 1);
		getglobal(this:GetName().."_StatsFrame_HealthBar"):SetValue(1);
		getglobal(this:GetName().."_StatsFrame_HealthBar"):SetStatusBarColor(0,1,0);
	else
		getglobal(this:GetName().."_StatsFrame_HealthBar"):SetValue(Partyhealth);
		getglobal(this:GetName().."_StatsFrame_HealthBar"):SetMinMaxValues(0, Partyhealthmax);
		Perl_SetSmoothBarColor(getglobal(this:GetName().."_StatsFrame_HealthBar"));
		Perl_SetSmoothBarColor(getglobal(this:GetName().."_StatsFrame_HealthBarBG"),getglobal(this:GetName().."_StatsFrame_HealthBar"), 0.25);
	end
	phealthPct = (Partyhealth * 100.0) / Partyhealthmax
	phealthPct = string.format("%3.0f", phealthPct);
	getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):SetText(string.format("%d",(100*(Partyhealth / Partyhealthmax))+0.5).."%");
	getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Show();
	if (Perl_Config.ShowPartyPercent==1) then getglobal(this:GetName().."_StatsFrame"):SetWidth(136); end
	getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText(Partyhealth.."/"..Partyhealthmax);
	if ((Partyhealth==0) and (Partyhealthmax==1)) then
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Offine");
		getglobal(this:GetName().."_StatsFrame"):SetWidth(106);
	elseif ((Partyhealth==0) and (Partyhealthmax>1)) then
		if (feigning[this:GetID()]==1) then
			getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Feign Death");
		else
			getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Dead");
		end
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarText"):Hide();
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame"):SetWidth(106);
	elseif ((Partyhealth==1) and (Partyhealthmax==1)) then
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarText"):Hide();
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Updating");
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame"):SetWidth(106);
	elseif ((Partyhealth==1) and (Partyhealthmax>1)) then
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarText"):Hide();
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Ghost");
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame"):SetWidth(106);
	end
	if (Perl_Config.ShowPartyPercent==0) then
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame"):SetWidth(106);
	end
	if (UnitIsConnected(partyid)) then
		this:SetAlpha(Perl_Config.Transparency);
		getglobal("Perl_Party_Pet"..this:GetID()):SetAlpha(Perl_Config.Transparency);
	else
		this:SetAlpha(Perl_Config.Transparency/2);
		getglobal("Perl_Party_Pet"..this:GetID()):SetAlpha(Perl_Config.Transparency/2);
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Offine");
	end
end
function Perl_Party_UpdateMana()
	partyid = ("party"..this:GetID());
	thisid=this:GetName();
	local Partymana = UnitMana(partyid);
	local Partymanamax = UnitManaMax(partyid);
	getglobal(this:GetName().."_StatsFrame_ManaBar"):SetMinMaxValues(0, Partymanamax);
	getglobal(this:GetName().."_StatsFrame_ManaBar"):SetValue(Partymana);
	pmanaPct = (Partymana * 100.0) / Partymanamax
	pmanaPct =  string.format("%3.0f", pmanaPct);
	if (getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):IsVisible()) then getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Show(); end
	if (UnitPowerType(partyid)>=1) then 
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):SetText(Partymana);
	else
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):SetText(string.format("%d",(100*(Partymana / Partymanamax))+0.5).."%");
	end
	getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarText"):Show();
	getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarText"):SetText(Partymana.."/"..Partymanamax);
	if (Perl_Config.ShowPartyPercent==0) then
		getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Hide();
		getglobal(this:GetName().."_StatsFrame"):SetWidth(106);
	end
	if (UnitIsConnected(partyid)) then
		this:SetAlpha(Perl_Config.Transparency);
		getglobal("Perl_Party_Pet"..this:GetID()):SetAlpha(Perl_Config.Transparency);
	else
		this:SetAlpha(Perl_Config.Transparency/2);
		getglobal("Perl_Party_Pet"..this:GetID()):SetAlpha(Perl_Config.Transparency/2);
		getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarText"):SetText("Offine");
	end
end
function Perl_Party_OnUpdate()
	if (CastParty_constants and (Perl_Config.CastPartyShow==0)) then
		CastPartyMainFrame:Hide();
	end
	local partymember = "party"..this:GetID();
	if ((UnitHealth(partymember)/UnitHealthMax(partymember) < FlashOnset) and (not UnitIsDead(partymember))) then
		local FlashColor = FlashColorMin + 0.5*(FlashColorMax - FlashColorMin)*(1 + math.sin(2*math.pi*FlashCycleTime*GetTime()));
		local FlashAlpha = FlashAlphaMin + 0.5*(FlashAlphaMax - FlashAlphaMin)*(1 + math.sin(2*math.pi*FlashCycleTime*GetTime()));
		if (FlashColor > 1) then
			FlashColor = 1;
		elseif (FlashColor < 0) then
			FlashColor = 0;
		end
		if (FlashAlpha > 1) then
			FlashAlpha = 1;
		elseif (FlashAlpha < 0) then
			FlashAlpha = 0;
		end
		getglobal(this:GetName().."_NameFrame"):SetBackdropColor(FlashColor, 0, 0, FlashAlpha);
	else
		getglobal(this:GetName().."_NameFrame"):SetBackdropColor(0, 0, 0, 1);
	end
	
end

--------------------
-- Buff Functions --
--------------------

function Perl_Party_Buff_UpdateAll ()
	local partyid = "party"..this:GetID();
	if (UnitName(partyid)) then
		Perl_Party_SetDebuffLoc();
		for buffnum=1,10 do
			local button = getglobal(this:GetName().."_BuffFrame_Buff"..buffnum);
			local icon = getglobal(button:GetName().."Icon");
			if (UnitBuff(partyid, buffnum)) then
				icon:SetTexture(UnitBuff(partyid, buffnum));
				if (strfind(strlower(UnitBuff(partyid, buffnum)), "feigndeath")) then
					feigning[this:GetID()]=1;
				end
				button:Show();
			else
				button:Hide();
			end
		end
		for buffnum=1,8 do
			local button = getglobal(this:GetName().."_BuffFrame_DeBuff"..(buffnum));
			local icon = getglobal(button:GetName().."Icon");
			if (UnitDebuff(partyid, buffnum)) then
				local type = GameTooltipTextRight1:GetText();
				icon:SetTexture(UnitDebuff(partyid, buffnum));
				button:Show();
			else
				button:Hide();
			end
		end
	end
end
function Perl_Party_SetDebuffLoc()
	getglobal(this:GetName().."_BuffFrame_DeBuff1"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff2"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff3"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff4"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff5"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff6"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff7"):ClearAllPoints();
	getglobal(this:GetName().."_BuffFrame_DeBuff8"):ClearAllPoints();
	if (Perl_Config.PartyDebuffsBelow==0) then
		if ((getglobal("Perl_Party_Pet"..this:GetID())):IsVisible()) then
			getglobal(this:GetName().."_BuffFrame_DeBuff1"):SetPoint("LEFT", ("Perl_party"..this:GetID().."_StatsFrame"), "RIGHT", 75, 0);
		else
			getglobal(this:GetName().."_BuffFrame_DeBuff1"):SetPoint("LEFT", ("Perl_party"..this:GetID().."_StatsFrame"), "RIGHT", 0, 0);
		end
	else
		getglobal(this:GetName().."_BuffFrame_DeBuff1"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_Buff1"), "BOTTOMLEFT", 0, -2);
	end
	getglobal(this:GetName().."_BuffFrame_DeBuff2"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff1"), "TOPRIGHT", 1, 0);
	getglobal(this:GetName().."_BuffFrame_DeBuff3"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff2"), "TOPRIGHT", 1, 0);
	getglobal(this:GetName().."_BuffFrame_DeBuff4"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff3"), "TOPRIGHT", 1, 0);
	getglobal(this:GetName().."_BuffFrame_DeBuff5"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff4"), "TOPRIGHT", 1, 0);
	getglobal(this:GetName().."_BuffFrame_DeBuff6"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff5"), "TOPRIGHT", 1, 0);
	getglobal(this:GetName().."_BuffFrame_DeBuff7"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff6"), "TOPRIGHT", 1, 0);
	getglobal(this:GetName().."_BuffFrame_DeBuff8"):SetPoint("TOPLEFT", ("Perl_party"..this:GetID().."_BuffFrame_DeBuff7"), "TOPRIGHT", 1, 0);
end
function Perl_Party_SetBuffTooltip ()
	local partyid = "party"..this:GetParent():GetParent():GetID();
	GameTooltip:SetOwner(this,"ANCHOR_BOTTOMRIGHT",30,0);
	GameTooltip:SetUnitBuff(partyid, this:GetID());	
end
function Perl_Party_SetDeBuffTooltip ()
	local partyid = "party"..this:GetParent():GetParent():GetID();
	GameTooltip:SetOwner(this,"ANCHOR_BOTTOMRIGHT",30,0);
	GameTooltip:SetUnitDebuff(partyid, this:GetID());
end

--------------------
-- Click Handlers --
--------------------
function Perl_Party_FindID(object)
	local name=object:GetName();
	if (strfind(name, "1")) then
		return 1;
	elseif (strfind(name, "2")) then
		return 2;
	elseif (strfind(name, "3")) then
		return 3;
	elseif (strfind(name, "4")) then
		return 4;
	else
		return nil;
	end
end
function Perl_PartyDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_PartyDropDown_Initialize, "MENU");
end
				
function Perl_PartyDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	UnitPopup_ShowMenu(dropdown, "PARTY", "party"..this:GetID());
end
function Perl_Party_OnClick(button)
	local id=Perl_Party_FindID(this);
	this:SetID(id);
	if (CastParty_constants and (Perl_Config.CastParty==1) and (strfind(this:GetName(), ("Perl_party"..id.."_StatsFrame")))) then
		CastParty_OnClick(button);
	end
end
function Perl_Party_MouseUp(button)
	
	local id=Perl_Party_FindID(this);
	this:SetID(id);
	if (not (CastParty_constants and (Perl_Config.CastParty==1) and (strfind(this:GetName(), ("Perl_party"..id.."_StatsFrame"))))) then
		
		if ( SpellIsTargeting() and button == "RightButton" ) then
			SpellStopTargeting();
			return;
		end
		if ( button == "LeftButton" ) then
			if ( SpellIsTargeting() ) then
				SpellTargetUnit("party"..id);
			elseif ( CursorHasItem() ) then
				DropItemOnUnit("party"..id);
			else
				TargetUnit("party"..id);
			end
		else
			if ((this:GetName())==("Perl_party"..id)) then ToggleDropDownMenu(1, nil, getglobal(this:GetName().."_DropDown"), this:GetName(), 0, 0); end
		end
	end
	getglobal("Perl_party"..id):StopMovingOrSizing();
end

function Perl_Party_MouseDown(button)
	local id=Perl_Party_FindID(this);
	if ( button == "LeftButton" and perl_locked == 0) then
		getglobal("Perl_party"..id):StartMoving();
	end
end

function Perl_Party_PlayerTip()
	local id=Perl_Party_FindID(this);
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	GameTooltip:SetUnit("party"..id);
end