local FlashColorMax = 1;
local FlashColorMin = 0.10;
local FlashCycleTime = 0.75;
local FlashOnset = 0.3;
local FlashAlphaMax = 1;
local FlashAlphaMin = 0.3;
local thisid=nil;
local partyid=nil;
local PartyPetName = {
	["Perl_Party_Pet1"] = "partypet1",
	["Perl_Party_Pet2"] = "partypet2",
	["Perl_Party_Pet3"] = "partypet3",
	["Perl_Party_Pet4"] = "partypet4",
};
----------------------
-- Loading Function --
----------------------

function Perl_Party_Pet_OnLoad()

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
	this:RegisterEvent("UNIT_PET");
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
	
	
	table.insert(UnitPopupFrames,"Perl_Party_Pet1_DropDown");
	table.insert(UnitPopupFrames,"Perl_Party_Pet2_DropDown");
	table.insert(UnitPopupFrames,"Perl_Party_Pet3_DropDown");
	table.insert(UnitPopupFrames,"Perl_Party_Pet4_DropDown");
	
	HidePartyFrame();
	
end

-------------------
-- Event Handler --
-------------------

function Perl_Party_Pet_OnEvent(event,unit)
	if unit then
		if (unit=="partypet"..this:GetID() or unit=="party"..this:GetID()) then
			Perl_Party_Pet_UpdateDisplay();
		else
			return;
		end
	else
		Perl_Party_Pet_UpdateDisplay();
	end
end



-------------------------
-- The Update Function --
-------------------------

function Perl_Party_Pet_UpdateDisplay()	
		

		partyid = ("partypet"..this:GetID());
		thisid=this:GetName();
		if ((UnitName(partyid)) and (Perl_Config.ShowPartyPets==1) and (UnitName("party"..this:GetID()))) then
			-- set common variables
			local Partypetname = UnitName(partyid);
			local Partypetmana = UnitMana(partyid);
			local Partypetmanamax = UnitManaMax(partyid);
			local Partypethealth = UnitHealth(partyid);
			local Partypethealthmax = UnitHealthMax(partyid);
			local Partypetlevel = UnitLevel(partyid);
			local PartypetClassification = UnitClassification(partyid);
			local power = UnitPowerType(partyid);
			
			-- show it
			if (UnitName(partyid)) then
				if (UnitName("raid1")) then
					if (Perl_Config.ShowPartyRaid==1) then 
						getglobal(this:GetName()):Show();
					else
						getglobal(this:GetName()):Hide();
					end
				else
					getglobal(this:GetName()):Show();
				end
			else
				getglobal(this:GetName()):Hide();
			end
			-- Set name
			if (strlen(Partypetname) > 40) then
				Partypetname = strsub(Partypetname, 1, 39).."...";
			end
			if (Perl_Config.ShowPartyPetNames==1) then getglobal(this:GetName().."_NameFrame"):Show(); end
			getglobal(this:GetName().."_NameFrame_NameBarText"):SetText(Partypetname);  
			
			if (UnitIsPVP(partyid)) then
				getglobal(this:GetName().."_NameFrame_NameBarText"):SetTextColor(0,1,0);
			else
				getglobal(this:GetName().."_NameFrame_NameBarText"):SetTextColor(0.5,0.5,1);
			end
			
		
			-- Set Level
			local color = GetDifficultyColor(Partypetlevel);
			getglobal(this:GetName().."_NameFrame_LevelBarText"):SetTextColor(color.r,color.g,color.b);
		
			getglobal(this:GetName().."_NameFrame_LevelBarText"):SetText(Partypetlevel);
			
			
			if  (power == 1) then
				getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(1, 0, 0, 1);
				getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 0, 0, 0.25);
			elseif (power == 2) then
				getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(1, 0.5, 0, 1);
				getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 0.5, 0, 0.25);
			elseif (power == 3) then
				getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(1, 1, 0, 1);
				getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(1, 1, 0, 0.25);
			else
				getglobal(this:GetName().."_StatsFrame_ManaBar"):SetStatusBarColor(0, 0, 1, 1);
				getglobal(this:GetName().."_StatsFrame_ManaBarBG"):SetStatusBarColor(0, 0, 1, 0.25);
			end
			
			getglobal(this:GetName().."_StatsFrame_HealthBar"):SetValue(Partypethealth);
			getglobal(this:GetName().."_StatsFrame_HealthBar"):SetMinMaxValues(0, Partypethealthmax);
			Perl_SetSmoothBarColor(getglobal(this:GetName().."_StatsFrame_HealthBar"));
			Perl_SetSmoothBarColor(getglobal(this:GetName().."_StatsFrame_HealthBarBG"),getglobal(this:GetName().."_StatsFrame_HealthBar"), 0.25);
		
			getglobal(this:GetName().."_StatsFrame_ManaBar"):SetMinMaxValues(0, Partypetmanamax);
			getglobal(this:GetName().."_StatsFrame_ManaBar"):SetValue(Partypetmana);
			
			
			
			phealthPct = (Partypethealth * 100.0) / Partypethealthmax
			phealthPct = string.format("%3.0f", phealthPct);
			pmanaPct = (Partypetmana * 100.0) / Partypetmanamax
			pmanaPct =  string.format("%3.0f", pmanaPct);
			getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):SetText(string.format("%d",(100*(Partypethealth / Partypethealthmax))+0.5).."%");
			getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Show();
			getglobal(this:GetName().."_StatsFrame_HealthBar_HealthBarPercentText"):Show();
			if (UnitPowerType(partyid)>=1) then 
				getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):SetText(Partypetmana);
			else
				getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):SetText(string.format("%d",(100*(Partypetmana / Partypetmanamax))+0.5).."%");
			end
			if ((Partypethealth==0) or (Partypethealth==1)) then
				getglobal(this:GetName()):Hide();
			end
			if (Perl_Config.ShowPartyPetPercent==0) then
				getglobal(this:GetName().."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
			end
			Perl_Party_Pet_Buff_UpdateAll();
		else
			this:Hide();
			this:StopMovingOrSizing();
		end
		
end




--------------------
-- Buff Functions --
--------------------

function Perl_Party_Pet_Buff_UpdateAll ()
	local partyid = "partypet"..this:GetID();
	if (UnitName(partyid)) then
		for buffnum=1,10 do
			local button = getglobal(this:GetName().."_BuffFrame_Buff"..buffnum);
			local icon = getglobal(button:GetName().."Icon");
			if (UnitBuff(partyid, buffnum)) then
				icon:SetTexture(UnitBuff(partyid, buffnum));
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

function Perl_Party_Pet_SetBuffTooltip ()
	local partyid = "partypet"..this:GetParent():GetParent():GetID();
	GameTooltip:SetOwner(this,"ANCHOR_BOTTOMRIGHT",30,0);
	GameTooltip:SetUnitBuff(partyid, this:GetID());	
end
function Perl_Party_Pet_SetDeBuffTooltip ()
	local partyid = "partypet"..this:GetParent():GetParent():GetID();
	GameTooltip:SetOwner(this,"ANCHOR_BOTTOMRIGHT",30,0);
	GameTooltip:SetUnitDebuff(partyid, this:GetID());
end

--------------------
-- Click Handlers --
--------------------
function Perl_Party_Pet_FindID(object)
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
function Perl_Party_PetDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_Party_PetDropDown_Initialize, "MENU");
end
				
function Perl_Party_PetDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	UnitPopup_ShowMenu(dropdown, "PARTY", "partypet"..this:GetID());
end

function Perl_Party_Pet_MouseUp(button)
	
	local id=Perl_Party_Pet_FindID(this);
	this:SetID(id);
	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("partypet"..id);
		elseif ( CursorHasItem() ) then
			DropItemOnUnit("partypet"..id);
		else
			TargetUnit("partypet"..id);
		end
	else
		if ((this:GetName())==("Perl_Party_Pet"..id)) then ToggleDropDownMenu(1, nil, getglobal(this:GetName().."_DropDown"), this:GetName(), 0, 0); end
	end
	
	getglobal("Perl_Party_Pet"..id):StopMovingOrSizing();
end

function Perl_Party_Pet_MouseDown(button)
	
end

function Perl_Party_Pet_PlayerTip()
	local id=Perl_Party_Pet_FindID(this);
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	GameTooltip:SetUnit("partypet"..id);
end