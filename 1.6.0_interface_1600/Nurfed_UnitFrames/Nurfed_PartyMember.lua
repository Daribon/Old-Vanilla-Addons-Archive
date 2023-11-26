--[[***** Nurfed PartyFrame *****]]--

-- Low HP Flashing Health
local FlashColorMax = 1;
local FlashColorMin = 0.10;
local FlashCycleTime = 0.95;
local FlashAlphaMax = 1;
local FlashAlphaMin = 0.8;

function Nurfed_PartyMember_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	this:RegisterEvent("UNIT_PET");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function Nurfed_PartyMember_OnEvent(event)
	if (event == "PARTY_MEMBERS_CHANGED") then
		Nurfed_PartyMember_Update();
		return;
	end

	if (event == "PARTY_LEADER_CHANGED") then
		Nurfed_UpdatePartyLeader();
		return;
	end

	if (event == "PLAYER_TARGET_CHANGED") then
		Nurfed_PartyUpdateTarget();
		return;
	end

	if (event == "PARTY_LOOT_METHOD_CHANGED") then
		Nurfed_UpdatePartyLoot();
	end

	if (event == "UNIT_PET") then
		Nurfed_UpdatePartyPets();
		return;
	end
	
	if (event == "PLAYER_ENTERING_WORLD") then
		Nurfed_PartyMember_Update();
	end
end

function Nurfed_UpdatePartyLocation()
	if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partySeperate == 0) then
		for i=1, 4 do
			local frame = getglobal("Nurfed_party"..i);
			frame:ClearAllPoints();
			if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partyGrowUp == 0) then
				if (i == 1) then
					frame:SetPoint("TOP", "Nurfed_party", "BOTTOM", 0, 3);
				else
					local prev = i - 1;
					if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBuffs == 1) then
						frame:SetPoint("TOPLEFT", "Nurfed_party"..prev, "BOTTOMLEFT", 0, -17);
					else
						frame:SetPoint("TOPLEFT", "Nurfed_party"..prev, "BOTTOMLEFT", 0, 3);
					end
				end
			else
				local y;
				if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partyBuffs == 1) then
					y = 17;
				else
					y = -3;
				end
				if (i == 1) then
					frame:SetPoint("BOTTOM", "Nurfed_party", "TOP", 0, y);
				else
					local prev = i - 1;
					frame:SetPoint("BOTTOMLEFT", "Nurfed_party"..prev, "TOPLEFT", 0, y);
				end
			end
		end
	end
	Nurfed_PartySize();
end

function Nurfed_PartyMember_Update()
	local id = this:GetID();
	if ( GetPartyMember(id) ) then
		this:Show();
		Nurfed_UpdateHealth("party"..id);
		Nurfed_UpdateMana("party"..id);
		Nurfed_UpdateManaType("party"..id);
		Nurfed_UpdatePvP("party"..id);
		Nurfed_RefreshAuras("party"..id, 8, 4);
		Nurfed_UnitUpdateName("party"..id)
		Nurfed_UpdatePartyLeader();
		Nurfed_UpdatePartyPets();
		Nurfed_UpdatePartyLoot();
		Nurfed_PartyUpdateTarget();
		Nurfed_UpdatePartyLocation();
	else
		this:Hide();
	end
	Nurfed_PartySize();
end

function Nurfed_PartyUpdateTarget()
	local id = this:GetID();
	if ( UnitIsUnit("target", "party"..id) ) then
		getglobal("Nurfed_party"..id.."Highlight"):Show();
	else
		getglobal("Nurfed_party"..id.."Highlight"):Hide();
	end
end

function Nurfed_UpdatePartyLeader()
	local id = this:GetID();
	if ( IsPartyLeader() ) then
		Nurfed_playerLeaderIcon:Show();
	else
		Nurfed_playerLeaderIcon:Hide();
	end
	if ( GetPartyLeaderIndex() == id ) then
		getglobal("Nurfed_party"..id.."LeaderIcon"):Show();
	else
		getglobal("Nurfed_party"..id.."LeaderIcon"):Hide();
	end
end

function Nurfed_PartySize()
	local partySize = GetNumPartyMembers();
	if (partySize == 0) then
		Nurfed_party:Hide();
	else
		if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partySeperate == 1) then
			if ( Nurfed_UnitFrames[Nurfed_UnitPlayer].partyShowLoot == 1) then
				Nurfed_party:Show();
			else
				Nurfed_party:Hide();
			end
		else
			Nurfed_party:Show();
		end
	end
end

function Nurfed_UpdatePartyPets()
	for id = 1, 4 do
		local petframe = getglobal("Nurfed_partypet"..id);
		if (Nurfed_UnitFrames[Nurfed_UnitPlayer].partyShowPets == 1) then
			if ( UnitIsConnected("party"..id) and UnitExists("partypet"..id) ) then
				petframe:Show();
				petframe:ClearAllPoints();
				petframe:SetPoint("BOTTOMLEFT", "Nurfed_party"..id, "BOTTOMLEFT", 0, 10);
				Nurfed_UpdateHealth("partypet"..id);
				getglobal("Nurfed_party"..id):SetHeight(53);
			else
				petframe:Hide();
				getglobal("Nurfed_party"..id):SetHeight(43);
			end
		else
			petframe:Hide();
			getglobal("Nurfed_party"..id):SetHeight(43);
		end
	end
end

function Nurfed_PartyMember_OnUpdate()
	-- Low health flash.
	local partymember = "party"..this:GetID();
	local backdrop = getglobal(this:GetName().."Backdrop");
	if ( Nurfed_UnitFrames[Nurfed_UnitPlayer].partyLowHealthWarn == 1) then
		if ( (floor((UnitHealth(partymember) / UnitHealthMax(partymember)) * 100) < Nurfed_UnitFrames[Nurfed_UnitPlayer].partyLowHealthWarnPerc) and (not UnitIsGhost(partymember)) and (not UnitIsDead(partymember)) and UnitIsConnected(partymember)) then
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
			backdrop:Show();
			backdrop:SetBackdropColor(FlashColor, 0, 0, FlashAlpha);
		else
			local info = {};
			info = Nurfed_UnitFrames[Nurfed_UnitPlayer]["partyColor"];
			backdrop:SetBackdropColor(info.r, info.g, info.b, info.a);
		end
	end
end
