local targetname="";
local targethp=0;
local oldtarget="";
local oldhp=0;
----------------------
-- Loading Function --
----------------------

function Perl_TargetTarget_OnLoad()
	-- Events
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	
	this:Hide();
			
	table.insert(UnitPopupFrames,"Perl_TargetTarget_DropDown");
end

-------------------
-- Event Handler --
-------------------

function Perl_TargetTarget_OnEvent(event,unit)
	if (unit) then
		if (unit=="target") then
			Perl_TargetTarget_UpdateDisplay();
		end
	else
		Perl_TargetTarget_UpdateDisplay();
	end
end
-------------------------
-- The Update Function --
-------------------------
function Perl_TargetTarget_UpdateDisplay()	
	if (perl_loaded and (UnitName("targettarget")~=nil) and (UnitName("target")~=nil) and (Perl_Config.ShowTargetTarget==1) and (UnitIsVisible("targettarget"))) then
		Perl_TargetTarget_Frame:Show();
		if (UnitName("targettarget") ~= nil) then
			targetname=UnitName("targettarget");
			targethp=UnitHealth("targettarget");
			-- set common variables
			local TargetTargetname = UnitName("targettarget");
			local TargetTargetmana = UnitMana("targettarget");
			local TargetTargetmanamax = UnitManaMax("targettarget");
			local TargetTargethealth = UnitHealth("targettarget");
			local TargetTargethealthmax = UnitHealthMax("targettarget");
			local TargetTargetlevel = UnitLevel("targettarget");
			local TargetTargetclassification = UnitClassification("targettarget");
			local TargetTargetpower = UnitPowerType("targettarget");
			local TargetTargettype = UnitCreatureType("targettarget");
			if (perl_showTargetTargetportrait==1) then
				SetPortraitTexture(PerlTargetTargetPortrait, "targettarget");
				PerlTargetTargetPortrait:Show();
			end
			Perl_TargetTarget_Frame:Show();  
			
			-- Set name
			if (strlen(TargetTargetname) > 20) then
				TargetTargetname = strsub(TargetTargetname, 1, 19).."...";
			end
			
			Perl_TargetTarget_NameBarText:SetText(TargetTargetname);  
			
			
			if (UnitIsTapped("targettarget") and not UnitIsTappedByPlayer("targettarget")) then
				Perl_TargetTarget_NameBarText:SetTextColor(0.5,0.5,0.5);
			elseif (UnitIsPlayer("targettarget")) then
				if (UnitFactionGroup("player") == UnitFactionGroup("targettarget")) then
					if (UnitIsPVP("targettarget")) then
						Perl_TargetTarget_NameBarText:SetTextColor(0,1,0);
					else
						Perl_TargetTarget_NameBarText:SetTextColor(0.5,0.5,1);
					end
				else
					if (UnitIsPVP("targettarget")) then
						if (UnitIsPVP("player")) then
							Perl_Target_NameBarText:SetTextColor(1,0,0);
						else
							Perl_Target_NameBarText:SetTextColor(1,1,0);
						end
					else
						Perl_TargetTarget_NameBarText:SetTextColor(0.5,0.5,1);
					end
				end
			else
				if (UnitFactionGroup("player") == UnitFactionGroup("targettarget")) then
					Perl_TargetTarget_NameBarText:SetTextColor(0,1,0);
				elseif (UnitIsEnemy("player", "targettarget")) then			
					Perl_TargetTarget_NameBarText:SetTextColor(1,0,0);					
				else					
					Perl_TargetTarget_NameBarText:SetTextColor(1,1,0);
				end
			end
			
			Perl_TargetTarget_LevelBarText:SetText(TargetTargetlevel);
			-- Set Level
			if (perl_showTargetTargetlevel==1) then
				Perl_TargetTarget_LevelFrame:Show();
				Perl_TargetTarget_LevelFrame:SetWidth(27);
				if (TargetTargetlevel < 0) then
					Perl_TargetTarget_LevelBarText:SetTextColor(1, 0, 0);
					Perl_TargetTarget_LevelFrame:Hide();
				elseif (TargetTargetlevel > UnitLevel("player") + 4) then
					Perl_TargetTarget_LevelBarText:SetTextColor(1, 0, 0);
				elseif (TargetTargetlevel > UnitLevel("player") + 2) then
					Perl_TargetTarget_LevelBarText:SetTextColor(1, 0.5, 0);
				elseif (UnitIsTrivial("targettarget")) then
					Perl_TargetTarget_LevelBarText:SetTextColor(0.6, 0.6, 0.6);
				elseif (TargetTargetlevel < UnitLevel("player") - 2) then
					Perl_TargetTarget_LevelBarText:SetTextColor(0.5, 1, 0);
				else
					Perl_TargetTarget_LevelBarText:SetTextColor(1, 1, 0);
				end	
				if ((perl_showTargetTargetmobtype==0) and (UnitIsPlusMob("targettarget"))) then
					Perl_TargetTarget_LevelBarText:SetText(TargetTargetlevel.."+");
					Perl_TargetTarget_LevelFrame:SetWidth(33);
				end
			end
			
			-- Set mana bar color
			if ((TargetTargetmanamax == 0) or (perl_showTargetTargetmana==0)) then
				Perl_TargetTarget_ManaBar:Hide();
				Perl_TargetTarget_ManaBarBG:Hide();
				Perl_TargetTarget_StatsFrame:SetHeight(28);
				Perl_TargetTarget_Frame:SetHeight(28);
			elseif (TargetTargetpower == 1) then
				Perl_TargetTarget_ManaBar:SetStatusBarColor(1, 0, 0, 1);
				Perl_TargetTarget_ManaBarBG:SetStatusBarColor(1, 0, 0, 0.25);
				Perl_TargetTarget_ManaBar:Show();
				Perl_TargetTarget_ManaBarBG:Show();
				Perl_TargetTarget_ManaBarText:Hide();
				Perl_TargetTarget_StatsFrame:SetHeight(40);
				Perl_TargetTarget_Frame:SetHeight(50);
			elseif (TargetTargetpower == 2) then
				Perl_TargetTarget_ManaBar:SetStatusBarColor(1, 0.5, 0, 1);
				Perl_TargetTarget_ManaBarBG:SetStatusBarColor(1, 0.5, 0, 0.25);
				Perl_TargetTarget_ManaBar:Show();
				Perl_TargetTarget_ManaBarBG:Show();
				Perl_TargetTarget_StatsFrame:SetHeight(40);
				Perl_TargetTarget_ManaBarText:Hide();
				Perl_TargetTarget_Frame:SetHeight(50);
			elseif (TargetTargetpower == 3) then
				Perl_TargetTarget_ManaBar:SetStatusBarColor(1, 1, 0, 1);
				Perl_TargetTarget_ManaBarBG:SetStatusBarColor(1, 1, 0, 0.25);
				Perl_TargetTarget_ManaBar:Show();
				Perl_TargetTarget_ManaBarBG:Show();
				Perl_TargetTarget_StatsFrame:SetHeight(40);
				Perl_TargetTarget_ManaBarText:Hide();
				Perl_TargetTarget_Frame:SetHeight(50);
			else
				Perl_TargetTarget_ManaBar:SetStatusBarColor(0, 0, 1, 1);
				Perl_TargetTarget_ManaBarBG:SetStatusBarColor(0, 0, 1, 0.25);
				Perl_TargetTarget_ManaBar:Show();
				Perl_TargetTarget_ManaBarBG:Show();
				
				Perl_TargetTarget_ManaBarText:Show();
				Perl_TargetTarget_StatsFrame:SetHeight(40);
				Perl_TargetTarget_Frame:SetHeight(50);
			end
			
			Perl_TargetTarget_ManaBarPercent:Show();
			
			-- Set Statistics
			Perl_TargetTarget_HealthBar:SetMinMaxValues(0, TargetTargethealthmax);
			Perl_TargetTarget_ManaBar:SetMinMaxValues(0, TargetTargetmanamax);
			Perl_TargetTarget_HealthBar:SetValue(TargetTargethealth);
			Perl_TargetTarget_ManaBar:SetValue(TargetTargetmana);
			Perl_SetSmoothBarColor(Perl_TargetTarget_HealthBar);
			Perl_SetSmoothBarColor(Perl_TargetTarget_HealthBarBG, Perl_TargetTarget_HealthBar, 0.25);
			
			if (TargetTargethealthmax == 100) then
				Perl_TargetTarget_HealthBarPercent:SetText(TargetTargethealth.."%");
			else
				Perl_TargetTarget_HealthBarPercent:SetText(string.format("%d",(100*(TargetTargethealth / TargetTargethealthmax))+0.5).."%");
			end
			Perl_TargetTarget_ManaBarPercent:SetText(string.format("%d",(100*(TargetTargetmana / TargetTargetmanamax))+0.5).."%");
			
			if (TargetTargethealthmax ~= 100) then
				Perl_TargetTarget_HealthBarText:SetText(TargetTargethealth.."/"..TargetTargethealthmax);
			else
				if MobHealthFrame then MobHealthFrame:Hide(); end
				local index;
				if UnitIsPlayer("targettarget") then
					index = UnitName("targettarget");
				else
					index = UnitName("targettarget")..":"..UnitLevel("targettarget");
				end
				if (( MobHealthDB and MobHealthDB[index]) or (MobHealthPlayerDB and MobHealthPlayerDB[index])) then
					local s, e;
					local pts;
					local pct;
					if MobHealthDB[index] then
						if ( type(MobHealthDB[index]) ~= "string" ) then
							Perl_TargetTarget_HealthBarText:SetText(TargetTargethealth.."%");
						end
						s, e, pts, pct = string.find(MobHealthDB[index], "^(%d+)/(%d+)$");
					else
						if ( type(MobHealthPlayerDB[index]) ~= "string" ) then
							Perl_TargetTarget_HealthBarText:SetText(TargetTargethealth.."%");
						end
						s, e, pts, pct = string.find(MobHealthPlayerDB[index], "^(%d+)/(%d+)$");
					end
					if ( pts and pct ) then
						pts = pts + 0;
						pct = pct + 0;
						if( pct ~= 0 ) then
							pointsPerPct = pts / pct;
						else
							pointsPerPct = 0;
						end
					end
					local currentPct = UnitHealth("targettarget");
					if ( pointsPerPct > 0 ) then	
						Perl_TargetTarget_HealthBarText:SetText(string.format("%d", (currentPct * pointsPerPct) + 0.5).."/"..string.format("%d", (100 * pointsPerPct) + 0.5));
					end
				else
					Perl_TargetTarget_HealthBarText:SetText(TargetTargethealth.."%");
				end
			end
			Perl_TargetTarget_ManaBarText:SetText(TargetTargetmana.."/"..TargetTargetmanamax);
			if ((TargetTargethealth==0) and (TargetTargethealthmax==1)) then
				Perl_TargetTarget_ManaBarText:Hide();
				Perl_TargetTarget_HealthBarText:SetText("Offine");
			elseif ((TargetTargethealth==0) and ((TargetTargethealthmax>1) and (TargetTargethealthmax~=100))) then
				Perl_TargetTarget_ManaBarText:Hide();
			elseif ((TargetTargethealth==1) and ((TargetTargethealthmax>1) and (TargetTargethealthmax~=100))) then
				Perl_TargetTarget_ManaBarText:Hide();
				Perl_TargetTarget_HealthBarText:SetText("Ghost");
			end
			if ((TargetTargethealth==1) and ((TargetTargethealthmax==0) and (TargetTargethealthmax~=100))) then
				Perl_TargetTarget_ManaBarPercent:Hide();
				Perl_TargetTarget_HealthBarPercent:SetText("Ghost");
			elseif (TargetTargethealth==0) then
				Perl_TargetTarget_ManaBarPercent:Hide();
				Perl_TargetTarget_HealthBarPercent:SetText("Dead");
			end
		end
	else
		Perl_TargetTarget_Frame:Hide();
		Perl_TargetTarget_Frame:StopMovingOrSizing();
	end
end
function Perl_TargetTarget_OnUpdate()
	oldtarget=targetname;
	oldhp=targethp;
	if (UnitName("targettarget")) then
		targetname=UnitName("targettarget");
		targethp=UnitHealth("targettarget");
	else
		targetname="";
		targethp=0;
	end
	if (oldtarget~=targetname) or (oldhp~=targethp) then
		Perl_TargetTarget_UpdateDisplay();
	end
end

--------------------
-- Buff Functions --
--------------------



function Perl_TargetTarget_PlayerTip()
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	GameTooltip:SetUnit("targettarget");
end

--------------------
-- Click Handlers --
--------------------

function Perl_TargetTargetDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Perl_TargetTargetDropDown_Initialize, "MENU");
end
				
function Perl_TargetTargetDropDown_Initialize()
	local menu = nil;
	if ( UnitIsEnemy("targettarget", "player") ) then
		return;
	end
	if ( UnitIsUnit("targettarget", "player") ) then
		menu = "SELF";
	elseif ( UnitIsUnit("targettarget", "pet") ) then
		menu = "PET";
	elseif ( UnitIsPlayer("targettarget") ) then
		if ( UnitInParty("targettarget") ) then
			menu = "PARTY";
		else
			menu = "PLAYER";
		end
	end
	if ( menu ) then
		UnitPopup_ShowMenu(Perl_TargetTarget_DropDown, menu, "targettarget");
	end
end

function Perl_TargetTarget_MouseUp(button)
	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("targettarget");
		elseif ( CursorHasItem() ) then
			DropItemOnUnit("targettarget");
		else
			TargetUnit("targettarget");
		end
	else
		ToggleDropDownMenu(1, nil, Perl_TargetTarget_DropDown, "Perl_TargetTarget_NameFrame", 40, -25);
	end
	
	Perl_TargetTarget_Frame:StopMovingOrSizing();
end

function Perl_TargetTarget_MouseDown(button)
	if ( button == "LeftButton" and perl_locked == 0) then
		Perl_TargetTarget_Frame:StartMoving();
	end
end
