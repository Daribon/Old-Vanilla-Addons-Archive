---------------------------------
--Loading Function             --
---------------------------------
function Perl_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");

	-- Blizz Player Frame Events
	PlayerFrame:UnregisterEvent("UNIT_LEVEL");
	PlayerFrame:UnregisterEvent("UNIT_COMBAT");
	PlayerFrame:UnregisterEvent("UNIT_SPELLMISS");
	PlayerFrame:UnregisterEvent("UNIT_PVP_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_MAXMANA");
	PlayerFrame:UnregisterEvent("PLAYER_ENTER_COMBAT");
	PlayerFrame:UnregisterEvent("PLAYER_LEAVE_COMBAT");
	PlayerFrame:UnregisterEvent("PLAYER_UPDATE_RESTING");
	PlayerFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED");
	PlayerFrame:UnregisterEvent("PARTY_LEADER_CHANGED");
	PlayerFrame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED");
	PlayerFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	PlayerFrame:UnregisterEvent("PLAYER_REGEN_DISABLED");
	PlayerFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	PlayerFrameHealthBar:UnregisterEvent("UNIT_HEALTH");
	PlayerFrameHealthBar:UnregisterEvent("UNIT_MAXHEALTH");
	-- ManaBar Events
	PlayerFrameManaBar:UnregisterEvent("UNIT_MANA");
	PlayerFrameManaBar:UnregisterEvent("UNIT_RAGE");
	PlayerFrameManaBar:UnregisterEvent("UNIT_FOCUS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_ENERGY");
	PlayerFrameManaBar:UnregisterEvent("UNIT_HAPPINESS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXMANA");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXRAGE");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXFOCUS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXENERGY");
	PlayerFrameManaBar:UnregisterEvent("UNIT_MAXHAPPINESS");
	PlayerFrameManaBar:UnregisterEvent("UNIT_DISPLAYPOWER");
	-- UnitFrame Events
	PlayerFrame:UnregisterEvent("UNIT_NAME_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_DISPLAYPOWER");
	PlayerFrame:Hide();

	-- Blizz Pet Frame Events
	PetFrame:UnregisterEvent("UNIT_COMBAT");
	PetFrame:UnregisterEvent("UNIT_SPELLMISS");
	PetFrame:UnregisterEvent("UNIT_AURA");
	PetFrame:UnregisterEvent("PLAYER_PET_CHANGED");
	PetFrame:UnregisterEvent("PET_ATTACK_START");
	PetFrame:UnregisterEvent("PET_ATTACK_STOP");
	PetFrame:UnregisterEvent("UNIT_HAPPINESS");
	PetFrame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	PetFrame:Hide();

	-- Blizz Target Frame Events
	TargetFrame:UnregisterEvent("UNIT_HEALTH");
	TargetFrame:UnregisterEvent("UNIT_LEVEL");
	TargetFrame:UnregisterEvent("UNIT_FACTION");
	TargetFrame:UnregisterEvent("UNIT_DYNAMIC_FLAGS");
	TargetFrame:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED");
	TargetFrame:UnregisterEvent("PLAYER_PVPLEVEL_CHANGED");
	TargetFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	TargetFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED");
	TargetFrame:UnregisterEvent("PARTY_LEADER_CHANGED");
	TargetFrame:UnregisterEvent("PARTY_MEMBER_ENABLE");
	TargetFrame:UnregisterEvent("PARTY_MEMBER_DISABLE");
	TargetFrame:UnregisterEvent("UNIT_AURA");
	TargetFrame:UnregisterEvent("PLAYER_FLAGS_CHANGED");
	ComboFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	ComboFrame:UnregisterEvent("PLAYER_COMBO_POINTS");
	TargetFrameHealthBar:UnregisterEvent("UNIT_HEALTH");
	TargetFrameHealthBar:UnregisterEvent("UNIT_MAXHEALTH");
	-- ManaBar Events
	TargetFrameManaBar:UnregisterEvent("UNIT_MANA");
	TargetFrameManaBar:UnregisterEvent("UNIT_RAGE");
	TargetFrameManaBar:UnregisterEvent("UNIT_FOCUS");
	TargetFrameManaBar:UnregisterEvent("UNIT_ENERGY");
	TargetFrameManaBar:UnregisterEvent("UNIT_HAPPINESS");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXMANA");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXRAGE");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXFOCUS");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXENERGY");
	TargetFrameManaBar:UnregisterEvent("UNIT_MAXHAPPINESS");
	TargetFrameManaBar:UnregisterEvent("UNIT_DISPLAYPOWER");
	-- UnitFrame Events
	TargetFrame:UnregisterEvent("UNIT_NAME_UPDATE");
	TargetFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	TargetFrame:UnregisterEvent("UNIT_DISPLAYPOWER");
	TargetFrame:Hide();

	-- Blizz Party Events
	for num = 1, 4 do
		frame = getglobal("PartyMemberFrame"..num);
		HealthBar = getglobal("PartyMemberFrame"..num.."HealthBar");
		ManaBar = getglobal("PartyMemberFrame"..num.."ManaBar");
		frame:UnregisterEvent("PARTY_MEMBERS_CHANGED");
		frame:UnregisterEvent("PARTY_LEADER_CHANGED");
		frame:UnregisterEvent("PARTY_MEMBER_ENABLE");
		frame:UnregisterEvent("PARTY_MEMBER_DISABLE");
		frame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED");
		frame:UnregisterEvent("UNIT_PVP_UPDATE");
		frame:UnregisterEvent("UNIT_AURA");
		-- HealthBar Events
		HealthBar:UnregisterEvent("UNIT_HEALTH");
		HealthBar:UnregisterEvent("UNIT_MAXHEALTH");
		-- ManaBar Events
		ManaBar:UnregisterEvent("UNIT_MANA");
		ManaBar:UnregisterEvent("UNIT_RAGE");
		ManaBar:UnregisterEvent("UNIT_FOCUS");
		ManaBar:UnregisterEvent("UNIT_ENERGY");
		ManaBar:UnregisterEvent("UNIT_HAPPINESS");
		ManaBar:UnregisterEvent("UNIT_MAXMANA");
		ManaBar:UnregisterEvent("UNIT_MAXRAGE");
		ManaBar:UnregisterEvent("UNIT_MAXFOCUS");
		ManaBar:UnregisterEvent("UNIT_MAXENERGY");
		ManaBar:UnregisterEvent("UNIT_MAXHAPPINESS");
		ManaBar:UnregisterEvent("UNIT_DISPLAYPOWER");
		-- UnitFrame Events
		frame:UnregisterEvent("UNIT_NAME_UPDATE");
		frame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
		frame:UnregisterEvent("UNIT_DISPLAYPOWER");
	end
	HidePartyFrame();
	
end

---------------------------------
--Smooth Health Bar Color      --
---------------------------------
function Perl_SetSmoothBarColor (bar, refbar, alpha)
	if (not refbar) then
		refbar = bar;
	end
	if (not alpha) then
		alpha = 1;
	end
	if (bar) then
		local barmin, barmax = refbar:GetMinMaxValues();
		if (barmin == barmax) then
			return false;
		end
		local percentage = refbar:GetValue()/(barmax-barmin);
		local red;
		local green;
		if (percentage < 0.5) then
			red = 1;
			green = 2*percentage;
		else
			green = 1;
			red = 2*(1 - percentage);
		end
		if ((red>=0) and (green>=0) and (alpha>=0) and (red<=1) and (green<=1) and (alpha<=1)) then
			bar:SetStatusBarColor(red, green, 0, alpha);
		end
	else
		return false;
	end
end

---------------------
--Party Distance Function--
---------------------

function Perl_UpdatePartyDistance()
	
	if ((not MapLibrary) or (not Chronos)) then
		for num=1,4 do
			getglobal("Perl_party"..num.."_DistanceFrame"):Hide();
		end
		return;
	end
	for num=1,4 do
		oldposx, oldposy = posx, posy;
		posx, posy = MapLibrary.GetWorldPosition("player", nil, 1);
	
		local target_distance = nil;
		local partyid="party"..num;
		local tx, ty = MapLibrary.GetWorldPosition(partyid, nil, 1);
		if posx and tx then
			target_distance = MapLibrary.YardDistance(posx, posy, tx, ty);
		end 
		if ((target_distance) and (Perl_Config.ShowPartyDistance==1)) then
			if (target_distance<100) then
				getglobal("Perl_party"..num.."_DistanceFrame_DistanceText"):SetText(format("%.1f", target_distance));
				getglobal("Perl_party"..num.."_DistanceFrame"):Show();
			else
				getglobal("Perl_party"..num.."_DistanceFrame"):Hide();
			end
			if (target_distance<5.1) then
				getglobal("Perl_party"..num.."_DistanceFrame_DistanceText"):SetTextColor(1,0,0);
			elseif (target_distance<20.1) then
				getglobal("Perl_party"..num.."_DistanceFrame_DistanceText"):SetTextColor(1,0.5,0);
			elseif (target_distance<30.1) then
				getglobal("Perl_party"..num.."_DistanceFrame_DistanceText"):SetTextColor(0.5,1,0);
			elseif (target_distance<41.1) then
				getglobal("Perl_party"..num.."_DistanceFrame_DistanceText"):SetTextColor(0,1,0);
			else
				getglobal("Perl_party"..num.."_DistanceFrame_DistanceText"):SetTextColor(1,1,1);
			end
		else
			getglobal("Perl_party"..num.."_DistanceFrame"):Hide();
		end
	end
	if (perl_partydistancespeed and not Chronos.isScheduledByName("partydist")) then
		Chronos.scheduleByName("partydist", perl_partydistancespeed,Perl_UpdatePartyDistance);
	end
end
---------------------------------
--Class Icon Location Functions--
---------------------------------

function Perl_ClassPosRight (class)

	if(class==PERL_LOC_CLASS_WARRIOR) then return 0; end
	if(class==PERL_LOC_CLASS_MAGE) then return 0.25; end
	if(class==PERL_LOC_CLASS_ROGUE) then return 0.5; end
	if(class==PERL_LOC_CLASS_DRUID) then return 0.75; end
	if(class==PERL_LOC_CLASS_HUNTER) then return 0; end
	if(class==PERL_LOC_CLASS_SHAMAN) then return 0.25; end
	if(class==PERL_LOC_CLASS_PRIEST) then return 0.5; end
	if(class==PERL_LOC_CLASS_WARLOCK) then return 0.75; end
	if(class==PERL_LOC_CLASS_PALADIN) then return 0; end
	return nil;
end
function Perl_ClassPosLeft (class)

	if(class==PERL_LOC_CLASS_WARRIOR) then return 0.25; end
	if(class==PERL_LOC_CLASS_MAGE) then return 0.5; end
	if(class==PERL_LOC_CLASS_ROGUE) then return 0.75; end
	if(class==PERL_LOC_CLASS_DRUID) then return 1; end
	if(class==PERL_LOC_CLASS_HUNTER) then return 0.25; end
	if(class==PERL_LOC_CLASS_SHAMAN) then return 0.5; end
	if(class==PERL_LOC_CLASS_PRIEST) then return 0.75; end
	if(class==PERL_LOC_CLASS_WARLOCK) then return 1; end
	if(class==PERL_LOC_CLASS_PALADIN) then return 0.25; end
	return nil;
end
function Perl_ClassPosTop (class)
	if(class==PERL_LOC_CLASS_WARRIOR) then return 0; end
	if(class==PERL_LOC_CLASS_MAGE) then return 0; end
	if(class==PERL_LOC_CLASS_ROGUE) then return 0; end
	if(class==PERL_LOC_CLASS_DRUID) then return 0; end
	if(class==PERL_LOC_CLASS_HUNTER) then return 0.25; end
	if(class==PERL_LOC_CLASS_SHAMAN) then return 0.25; end
	if(class==PERL_LOC_CLASS_PRIEST) then return 0.25; end
	if(class==PERL_LOC_CLASS_WARLOCK) then return 0.25; end
	if(class==PERL_LOC_CLASS_PALADIN) then return 0.5; end
	return nil;

end
function Perl_ClassPosBottom (class)

	if(class==PERL_LOC_CLASS_WARRIOR) then return 0.25; end
	if(class==PERL_LOC_CLASS_MAGE) then return 0.25; end
	if(class==PERL_LOC_CLASS_ROGUE) then return 0.25; end
	if(class==PERL_LOC_CLASS_DRUID) then return 0.25; end
	if(class==PERL_LOC_CLASS_HUNTER) then return 0.5; end
	if(class==PERL_LOC_CLASS_SHAMAN) then return 0.5; end
	if(class==PERL_LOC_CLASS_PRIEST) then return 0.5; end
	if(class==PERL_LOC_CLASS_WARLOCK) then return 0.5; end
	if(class==PERL_LOC_CLASS_PALADIN) then return 0.75; end
	return nil;
end