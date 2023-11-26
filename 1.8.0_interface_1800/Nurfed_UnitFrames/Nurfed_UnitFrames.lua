-- Nurfed Unit Frames Events

local Nurfed_ToT_Elapsed;
local Nurfed_TargetSwitch = false;
local Nurfed_TargetInCombat = false;

local Nurfed_UnitAuras = {
	["player"] = { buffs = 0, debuffs = 8 },
	["pet"] = { buffs = 8, debuffs = 8 },
	["target"] = { buffs = 8, debuffs = 16 },
	["party1"] = { buffs = 8, debuffs = 4 },
	["party2"] = { buffs = 8, debuffs = 4 },
	["party3"] = { buffs = 8, debuffs = 4 },
	["party4"] = { buffs = 8, debuffs = 4 },
	["partypet1"] = { buffs = 0, debuffs = 4 },
	["partypet2"] = { buffs = 0, debuffs = 4 },
	["partypet3"] = { buffs = 0, debuffs = 4 },
	["partypet4"] = { buffs = 0, debuffs = 4 },
};

---------------------------------------------------------------------------
--			Nurfed Unit Functions
---------------------------------------------------------------------------

local function Nurfed_UnitUpdateName(unit)
	local text;
	local name = UnitName(unit);
	if (not name) then return; end
	local classcolor = Nurfed_UnitClass[UnitClass(unit)];
	if (not classcolor) then
		classcolor = "ffffff";
	end
	local label = getglobal("Nurfed_"..unit.."Name");
	if ( (unit == "player") or (unit == "pet") ) then
		text = UnitLevel(unit).." "..name;
	elseif (unit == "target" or string.find(unit, "partypet")) then
		text = name;
	elseif (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
		local id = this:GetID();
		local binding = GetBindingText(GetBindingKey("TARGETPARTYMEMBER"..id), "KEY_");
		text = binding.." |cff"..classcolor..name.."|r";
		--text = binding.." "..name;
	end
	if (label) then
		label:SetText(text);
	end
	local classicon = getglobal("Nurfed_"..unit.."ClassIcon");
	if (classicon) then
		local info = {};
		info = Nurfed_UnitsClassIcon[UnitClass(unit)];
		if (info) then
			classicon:SetTexCoord(info.right, info.left, info.top, info.bottom);
		end
	end
end

local function Nurfed_UpdatePvP(unit)
	local icon = getglobal("Nurfed_"..unit.."PVPIcon");
	if (not icon) then return; end
	local factionGroup = UnitFactionGroup(unit);
	if ( UnitIsPVPFreeForAll(unit) ) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		icon:Show();
	elseif ( factionGroup and UnitIsPVP(unit) ) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		icon:Show();
	else
		icon:Hide();
	end
end

local function Nurfed_UpdateRank(unit)
	local rankname, ranknumber = GetPVPRankInfo(UnitPVPRank(unit));
	if (ranknumber) then
		local icon = getglobal("Nurfed_"..unit.."RankIcon");
		icon:Show();
		if (ranknumber==0) then
			icon:Hide();
		elseif (ranknumber>9) then
			icon:SetTexture("Interface\\PVPRankBadges\\PVPRank"..ranknumber);
		else
			icon:SetTexture("Interface\\PVPRankBadges\\PVPRank0"..ranknumber);
		end
	else 
		icon:Hide();
	end
end

local function Nurfed_UpdatePartyLoot()
	local id = this:GetID();
	local lootMethod, lootMaster = GetLootMethod();
	local color = ITEM_QUALITY_COLORS[GetLootThreshold()];

	Nurfed_PartyLoot:SetText(string.gsub (UnitLootMethod[lootMethod].text, "Pl\195\188ndern:", "" , 1));
	Nurfed_PartyLoot:SetVertexColor(color.r, color.g, color.b);

	if (lootMaster == 0) then
		Nurfed_playerMasterIcon:Show();
	else
		Nurfed_playerMasterIcon:Hide();
	end

	if( (lootMaster == id) and (id > 0) ) then
		getglobal("Nurfed_party"..id.."MasterIcon"):Show();
	elseif (id > 0) then
		getglobal("Nurfed_party"..id.."MasterIcon"):Hide();
	end
end

local function Nurfed_Reaction(unit)
	local info = {};
	info.a = 0.7;
	if ( UnitPlayerControlled(unit) ) then
		if ( UnitCanAttack(unit, "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", unit) ) then
				info.r = 0.0;
				info.g = 0.0;
				info.b = 1.0;
			else
				info.r = UnitReactionColor[2].r;
				info.g = UnitReactionColor[2].g;
				info.b = UnitReactionColor[2].b;
			end
		elseif ( UnitCanAttack("player", unit) ) then
			-- Players we can attack but which are not hostile are yellow
			info.r = UnitReactionColor[4].r;
			info.g = UnitReactionColor[4].g;
			info.b = UnitReactionColor[4].b;
		elseif ( UnitIsPVP(unit) ) then
			-- Players we can assist but are PvP flagged are green
			info.r = UnitReactionColor[6].r;
			info.g = UnitReactionColor[6].g;
			info.b = UnitReactionColor[6].b;
		else
			-- All other players are blue (the usual state on the "blue" server)
			info.r = 0.0;
			info.g = 0.0;
			info.b = 1.0;
		end
	elseif ( UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) ) then
		info.r = 0.5;
		info.g = 0.5;
		info.b = 0.5;
	else
		local reaction = UnitReaction(unit, "player");
		if ( reaction ) then
			info.r = UnitReactionColor[reaction].r;
			info.g = UnitReactionColor[reaction].g;
			info.b = UnitReactionColor[reaction].b;
		else
			info.r = 0.0;
			info.g = 0.0;
			info.b = 1.0;
		end
	end
	return info;
end

local function Nurfed_UpdateCurrentState(unit)
	name = getglobal("Nurfed_"..unit.."Name");
	icon = getglobal("Nurfed_"..unit.."StatusIcon");
	if (this.inCombat == 1 or this.onHateList == 1) then
		name:SetTextColor(1, 0, 0);
		icon:Show();
		icon:SetTexCoord(.5625, .9375, .0625, .4375);
	elseif ( IsResting() ) then
		name:SetTextColor(1, 1, 0);
		icon:Show();
		icon:SetTexCoord(.0625, .4375, .0625, .4375);
	else
		name:SetTextColor(1, 1, 1);
		icon:Hide();
	end
end

---------------------------------------------------------------------------
--			Nurfed ToT Functions
---------------------------------------------------------------------------
local function Nurfed_Update_ToT(unit)
	local info = {};
	if (UnitExists(unit) and (Nurfed_UnitConfig[Nurfed_UnitPlayer][unit] == 1)) then
		getglobal("Nurfed_"..unit):Show();
		getglobal("Nurfed_"..unit.."Name"):SetText(UnitName(unit));
		info = Nurfed_Reaction(unit);
		getglobal("Nurfed_"..unit.."BG"):SetVertexColor(info.r, info.g, info.b, info.a);
		Nurfed_UpdateHealth(unit);
		Nurfed_UpdateMana(unit);
		Nurfed_UpdateManaType(unit);

		if(UnitManaMax(unit) == 0) then
			getglobal("Nurfed_"..unit.."ManaBar"):Hide();
			getglobal("Nurfed_"..unit.."ManaText"):Hide();
			getglobal("Nurfed_"..unit):SetHeight(20);
		else
			getglobal("Nurfed_"..unit.."ManaBar"):Show();
			getglobal("Nurfed_"..unit):SetHeight(26);
		end
	else
		getglobal("Nurfed_"..unit):Hide();
	end
end

function Nurfed_ToT_OnUpdate(arg1)
	Nurfed_ToT_Elapsed = Nurfed_ToT_Elapsed + arg1;
	if (Nurfed_ToT_Elapsed > NURFED_TOT_UPDATERATE ) then
		Nurfed_ToT_Elapsed = 0;
		Nurfed_Update_ToT("targettarget");
		Nurfed_Update_ToT("targettargettarget");
		Nurfed_Update_ToT("pettarget");
	end

	Nurfed_UpdateScale = Nurfed_UpdateScale + arg1;
	if (Nurfed_UpdateScale > 5) then
		Nurfed_UpdateScale = 0;
		Nurfed_SetScale("player");
		Nurfed_SetScale("target");
		Nurfed_SetScale("party");
		Nurfed_SetScale("pet");
	end
end

---------------------------------------------------------------------------
--			Nurfed Aura Functions
---------------------------------------------------------------------------

local function Nurfed_AuraUpdatePos(unit)
	if ( UnitIsFriend("player", "target") or unit == "pet" ) then
		getglobal("Nurfed_"..unit.."Buff1"):SetPoint("TOPLEFT", "Nurfed_"..unit, "BOTTOMLEFT", 3, 0);
		getglobal("Nurfed_"..unit.."Debuff1"):SetPoint("TOPLEFT", "Nurfed_"..unit.."Buff1", "BOTTOMLEFT", 0, -2);
		getglobal("Nurfed_"..unit.."Debuff9"):SetPoint("TOPLEFT", "Nurfed_"..unit.."Debuff1", "BOTTOMLEFT", 0, -2);
	else
		getglobal("Nurfed_"..unit.."Debuff1"):SetPoint("TOPLEFT", "Nurfed_"..unit, "BOTTOMLEFT", 3, 0);
		getglobal("Nurfed_"..unit.."Debuff9"):SetPoint("TOPLEFT", "Nurfed_"..unit.."Debuff1", "BOTTOMLEFT", 0, -2);
		getglobal("Nurfed_"..unit.."Buff1"):SetPoint("TOPLEFT", "Nurfed_"..unit.."Debuff9", "BOTTOMLEFT", 0, -2);
	end
end

function Nurfed_RefreshAuras(unit)
	local maxbuffs = Nurfed_UnitAuras[unit].buffs
	local maxdebuffs = Nurfed_UnitAuras[unit].debuffs
	local debuff, buff, buffname, button, debuffborder, debuffcount, icon, debuffname, debufftype;
	local class = UnitClass("player");
	local shown = 1;
	for i=1, 16 do
		buff = UnitBuff(unit, i);
		button = getglobal("Nurfed_"..unit.."Buff"..shown);
		if (buff and shown <= maxbuffs) then
			NurfedUnitBuffTooltipTextLeft1:SetText(nil);
			NurfedUnitBuffTooltip:SetUnitBuff(unit, i);
			buffname = NurfedUnitBuffTooltipTextLeft1:GetText();
			if (Nurfed_UnitConfig[Nurfed_UnitPlayer].unitClassBuffs == 0) then
				icon = getglobal(button:GetName().."Icon");
				icon:SetTexture(buff);
				button:Show();
				button.unit = unit;
				shown = shown + 1;
				button:SetID(i);
			elseif (Nurfed_UnitConfig[Nurfed_UnitPlayer].unitClassBuffs == 1 and Nurfed_UnitBuffs[class][buffname]) then
				icon = getglobal(button:GetName().."Icon");
				icon:SetTexture(buff);
				button:Show();
				button.unit = unit;
				shown = shown + 1;
				button:SetID(i);
			end
			if (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
				if( Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBuffs ~=1)then
					button:Hide();
				else
					if (i == 1) then
						button:ClearAllPoints();
						button:SetPoint("TOPLEFT", "Nurfed_"..unit, "BOTTOMLEFT", 3, 0);
					end
				end
			end
		else
			if (button) then
				button:Hide();
			end
		end
	end

	if (shown < maxbuffs) then
		for i=(shown + 1), maxbuffs do
			button = getglobal("Nurfed_"..unit.."Buff"..i);
			button:Hide();
		end
	end

	for i=1, maxdebuffs do
		debuff, debuffApplications = UnitDebuff(unit, i);
		button = getglobal("Nurfed_"..unit.."Debuff"..i);
		if ( debuff ) then
			NurfedUnitBuffTooltipTextLeft1:SetText(nil);
			NurfedUnitBuffTooltip:SetUnitBuff(unit, i);
			debuffname = NurfedUnitBuffTooltipTextLeft1:GetText();
			if (NurfedUnitBuffTooltipTextRight1:GetText()) then
				debufftype = NurfedUnitBuffTooltipTextRight1:GetText();
			end
			icon = getglobal(button:GetName().."Icon");
			debuffborder = getglobal(button:GetName().."Border");
			debuffcount = getglobal(button:GetName().."Count");
			icon:SetTexture(debuff);
			button:Show();
			button.isdebuff = 1;
			button.unit = unit;
			debuffborder:Show();
			if (debuffApplications > 1) then
				debuffcount:SetText(debuffApplications);
				debuffcount:Show();
			else
				debuffcount:Hide();
			end
			if (unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4") then
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyDeBuffs ~= 1) then
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
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyPetShowDeBuffs ~= 1) then
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
			elseif (unit == "player" and Nurfed_UnitConfig[Nurfed_UnitPlayer].playerDeBuffs ~= 1) then
				button:Hide();
			end
		else
			button:Hide();
		end
	end
end

---------------------------------------------------------------------------
--			Nurfed Player Functions
---------------------------------------------------------------------------

function Nurfed_Player_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this.statusCounter = 0;
	this.statusSign = -1;
	CombatFeedback_Initialize(Nurfed_playerHealthBarCombatText, 16);

	-- PlayerFrame events
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("UNIT_SPELLMISS");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_UPDATE_RESTING");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("RAID_ROSTER_UPDATE");

	-- Experience Events
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("UPDATE_EXHAUSTION");
	this:RegisterEvent("PLAYER_LEVEL_UP");

	table.insert(UnitPopupFrames,"Nurfed_playerDropDown");
end

local function Nurfed_Player_XPUpdate()
	if ( UnitLevel("player") == 60 ) then
		Nurfed_playerXPBar:Hide();
		Nurfed_player:SetHeight(43);
		return;
	end
	local unitmaxxp, unitcurxp, unitrestxp, xpstring, xpbarstring, exhaustionStateID;

	unitcurxp = UnitXP("player");
	unitmaxxp = UnitXPMax("player");
	Nurfed_playerXPBar:SetMinMaxValues(min(0, unitcurxp), unitmaxxp);
	Nurfed_playerXPBar:SetValue(unitcurxp);
	Nurfed_playerXPBar:Show();
	xpstring = string.format("%d", ((unitcurxp / unitmaxxp) * 100));
	Nurfed_playerXPBarText:SetText(xpstring.."%");

	exhaustionStateID = GetRestState();

	if(exhaustionStateID ~= nil) then
		if (exhaustionStateID == 1) then
			unitrestxp = GetXPExhaustion();
			xpbarstring = string.format("%d/%d (%d)", unitcurxp, unitmaxxp, unitrestxp);
			Nurfed_playerXPBar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0);
			Nurfed_playerXPBarBG:SetVertexColor(0.0, 0.39, 0.88, 0.25);
		elseif (exhaustionStateID == 2) then
			xpbarstring = string.format("%d / %d", unitcurxp, unitmaxxp);
			Nurfed_playerXPBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0);
			Nurfed_playerXPBarBG:SetVertexColor(0.58, 0.0, 0.55, 0.25);
		end
	end
	Nurfed_playerXPBarText:SetText(xpbarstring);
end

local function Nurfed_UpdateGroupIndicator()
	Nurfed_playerGroupIndicator:Hide();
	local name, rank, subgroup;
	if ( GetNumRaidMembers() == 0 ) then
		Nurfed_playerGroupIndicator:Hide();
		return;
	end
	local numRaidMembers = GetNumRaidMembers();
	for i=1, MAX_RAID_MEMBERS do
		if ( i <= numRaidMembers ) then
			name, rank, subgroup = GetRaidRosterInfo(i);
			-- Set the player's group number indicator
			if ( name == UnitName("player") ) then
				Nurfed_playerGroupIndicatorText:SetText(GROUP.." "..subgroup);
				Nurfed_playerGroupIndicator:SetWidth(Nurfed_playerGroupIndicatorText:GetWidth()+40);
				Nurfed_playerGroupIndicator:Show();
			end
		end
	end
end

function Nurfed_Player_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this.inCombat = nil;
		this.onHateList = nil;
		Nurfed_UpdateCurrentState("player");
		Nurfed_Player_XPUpdate();
		Nurfed_UpdateHealth("player");
		Nurfed_UpdateMana("player");
		Nurfed_UpdateManaType("player");
		Nurfed_UnitUpdateName("player");
		Nurfed_UpdateGroupIndicator();
		return;
	end

	if ( event == "PLAYER_ENTER_COMBAT" ) then
		this.inCombat = 1;
		Nurfed_UpdateCurrentState("player");
		return;
	end

	if ( event == "PLAYER_UPDATE_RESTING" ) then
		Nurfed_UpdateCurrentState("player");
		Nurfed_UpdateCurrentState("pet");
		return;
	end

	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		this.inCombat = nil;
		Nurfed_UpdateCurrentState("player");
		return;
	end

	if ( event == "PLAYER_REGEN_DISABLED" ) then
		this.onHateList = 1;
		Nurfed_TargetInCombat = true;
		Nurfed_UpdateCurrentState("player");
		return;
	end

	if ( event == "PLAYER_REGEN_ENABLED" ) then
		this.onHateList = nil;
		Nurfed_TargetInCombat = false;
		Nurfed_UpdateCurrentState("player");
		return;
	end

	if ( (event == "PLAYER_XP_UPDATE") or (event == "UPDATE_EXHAUSTION") or (event == "PLAYER_LEVEL_UP") ) then
		Nurfed_UnitUpdateName("player");
		Nurfed_Player_XPUpdate();
		return;
	end

	if ( event == "UNIT_COMBAT" ) then
		if ( arg1 == "player" and (Nurfed_UnitConfig[Nurfed_UnitPlayer].playerCombatFeedBack == 1) ) then
			CombatFeedback_OnCombatEvent(arg2, arg3, arg4, arg5);
		end
		return;
	end

	if (event == "UNIT_SPELLMISS") then
		if ( arg1 == "player" and (Nurfed_UnitConfig[Nurfed_UnitPlayer].playerCombatFeedBack == 1) ) then
			CombatFeedback_OnSpellMissEvent(arg2);
		end
		return;
	end

	if ( event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED" or event == "RAID_ROSTER_UPDATE" ) then
		Nurfed_UpdateGroupIndicator();
	end
end

function Nurfed_Player_OnUpdate(elapsed)
	CombatFeedback_OnUpdate(elapsed);
end

---------------------------------------------------------------------------
--			Nurfed Party Functions
---------------------------------------------------------------------------

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

local function Nurfed_PartyUpdateTarget()
	local id = this:GetID();
	if ( UnitIsUnit("target", "party"..id) ) then
		getglobal("Nurfed_party"..id.."Highlight"):Show();
	else
		getglobal("Nurfed_party"..id.."Highlight"):Hide();
	end
end

local function Nurfed_UpdatePartyLeader()
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
		if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate == 1) then
			if ( Nurfed_UnitConfig[Nurfed_UnitPlayer].partyShowLoot == 1) then
				Nurfed_party:Show();
			else
				Nurfed_party:Hide();
			end
			for i = 1, partySize do
				getglobal("Nurfed_party"..i.."Backdrop"):Show();
			end
			Nurfed_party:SetHeight(20);
		else
			local partyheight = 0;
			Nurfed_party:Show();
			for i = 1, partySize do
				getglobal("Nurfed_party"..i.."Backdrop"):Hide();
				local height = getglobal("Nurfed_party"..i):GetHeight() - 1;
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBuffs == 1) then
					height = height + 17;
				end
				partyheight = partyheight + height;
			end
			Nurfed_party:SetHeight(20 + partyheight);
		end
	end
end

function Nurfed_UpdatePartyPets()
	for id = 1, 4 do
		local petframe = getglobal("Nurfed_partypet"..id);
		if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyShowPets == 1) then
			if ( UnitIsConnected("party"..id) and UnitExists("partypet"..id) ) then
				petframe:Show();
				petframe:ClearAllPoints();
				petframe:SetPoint("BOTTOMLEFT", "Nurfed_party"..id, "BOTTOMLEFT", 0, 10);
				Nurfed_UpdateHealth("partypet"..id);
				getglobal("Nurfed_party"..id):SetHeight(53);
				Nurfed_UnitUpdateName("partypet"..id);
			else
				petframe:Hide();
				getglobal("Nurfed_party"..id):SetHeight(43);
			end
		else
			petframe:Hide();
			getglobal("Nurfed_party"..id):SetHeight(43);
		end
	end
	Nurfed_PartySize();
end

function Nurfed_UpdatePartyLocation()
	if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate == 0) then
		for i=1, 4 do
			local frame = getglobal("Nurfed_party"..i);
			frame:ClearAllPoints();
			if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyGrowUp == 0) then
				if (i == 1) then
					frame:SetPoint("TOP", "Nurfed_PartyLoot", "BOTTOM", 0, 3);
				else
					local prev = i - 1;
					if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBuffs == 1) then
						frame:SetPoint("TOPLEFT", "Nurfed_party"..prev, "BOTTOMLEFT", 0, -15);
					else
						frame:SetPoint("TOPLEFT", "Nurfed_party"..prev, "BOTTOMLEFT", 0, 0);
					end
				end
				Nurfed_PartyLoot:ClearAllPoints();
				Nurfed_PartyLoot:SetPoint("TOP", "Nurfed_party", "TOP", 0, -3);
			else
				local y;
				if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partyBuffs == 1) then
					y = 15;
				else
					y = 0;
				end
				if (i == 1) then
					Nurfed_PartyLoot:ClearAllPoints();
					Nurfed_PartyLoot:SetPoint("BOTTOM", "Nurfed_party", "BOTTOM", 0, 3);
					frame:SetPoint("BOTTOM", "Nurfed_PartyLoot", "TOP", 0, y);
				else
					local prev = i - 1;
					frame:SetPoint("BOTTOMLEFT", "Nurfed_party"..prev, "TOPLEFT", 0, y);
				end
			end
		end
	end
	Nurfed_PartySize();
end

local function Nurfed_PartyMember_Update()
	local id = this:GetID();
	if ( GetPartyMember(id) ) then
		this:Show();
		Nurfed_UpdateHealth("party"..id);
		Nurfed_UpdateMana("party"..id);
		Nurfed_UpdateManaType("party"..id);
		Nurfed_UpdatePvP("party"..id);
		Nurfed_RefreshAuras("party"..id);
		Nurfed_UnitUpdateName("party"..id);
		Nurfed_UpdatePartyLeader();
		Nurfed_UpdatePartyPets();
		Nurfed_UpdatePartyLoot();
		Nurfed_PartyUpdateTarget();
		Nurfed_UpdatePartyLocation();
	else
		this:Hide();
		Nurfed_UpdatePartyPets();
	end
	Nurfed_PartySize();
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

function Nurfed_PartyMember_OnUpdate()
	-- Low health flash.
	local partymember = "party"..this:GetID();
	local backdrop = getglobal(this:GetName().."Backdrop");
	if ( Nurfed_UnitConfig[Nurfed_UnitPlayer].partyLowHealthWarn == 1) then
		if ( (floor((UnitHealth(partymember) / UnitHealthMax(partymember)) * 100) < Nurfed_UnitConfig[Nurfed_UnitPlayer].partyLowHealthWarnPerc) and (not UnitIsGhost(partymember)) and (not UnitIsDead(partymember)) and UnitIsConnected(partymember)) then
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
			info = Nurfed_UnitConfig[Nurfed_UnitPlayer]["partyColor"];
			backdrop:SetBackdropColor(info.r, info.g, info.b, info.a);
			if (Nurfed_UnitConfig[Nurfed_UnitPlayer].partySeperate ~= 1) then
				backdrop:Hide();
			end
		end
	end
end

---------------------------------------------------------------------------
--			Nurfed Pet Functions
---------------------------------------------------------------------------

function Nurfed_PetFrame_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this.attackModeCounter = 0;
	this.attackModeSign = -1;
	this:RegisterEvent("UNIT_PET");
	this:RegisterEvent("PET_ATTACK_START");
	this:RegisterEvent("PET_ATTACK_STOP");
	this:RegisterEvent("UNIT_HAPPINESS");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_PET_EXPERIENCE");
	this:RegisterEvent("UNIT_LEVEL");

	table.insert(UnitPopupFrames,"Nurfed_petDropDown");
end

local function Nurfed_PetExpBar_Update()
	local currXP, nextXP = GetPetExperience();
	Nurfed_petXPBar:SetMinMaxValues(min(0, currXP), nextXP);
	Nurfed_petXPBar:SetValue(currXP);
end

local function Nurfed_PetFrame_SetHappiness()
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness();
	local hasPetUI, isHunterPet = HasPetUI();
	if ( not happiness or not isHunterPet ) then
		Nurfed_petXPBar:Hide();
		Nurfed_pet:SetHeight(43);
		return;
	end
	local currXP, nextXP = GetPetExperience();
	if (nextXP and (nextXP < 54350)) then
		Nurfed_pet:SetHeight(53);
		Nurfed_petXPBar:Show();
	end
	local currHappiness = getglobal("PET_HAPPINESS"..happiness);
	local name = UnitLevel("pet")..UnitName("pet");
	Nurfed_petHappinessIcon:Show();
	if ( happiness == 1 ) then
		Nurfed_petName:SetTextColor(1, 0.5, 0);
		Nurfed_petHappinessIcon:SetTexCoord(0.375, 0.5625, 0, 0.359375);
	elseif ( happiness == 2 ) then
		Nurfed_petName:SetTextColor(1, 1, 0);
		Nurfed_petHappinessIcon:SetTexCoord(0.1875, 0.375, 0, 0.359375);
	elseif ( happiness == 3 ) then
		Nurfed_petName:SetTextColor(0, 1, 0);
		Nurfed_petHappinessIcon:SetTexCoord(0, 0.1875, 0, 0.359375);
	end
	if ( loyaltyRate < 0 ) then
		Nurfed_petName:SetText("-"..name.."-");
	elseif ( loyaltyRate > 0 ) then
		Nurfed_petName:SetText("+"..name.."+");
	else
		Nurfed_petName:SetText(name);
	end
end

local function Nurfed_PetFrame_Update()
	if (UnitExists("pet")) then
		if ( not this:IsVisible() ) then
			this:Show();
		end
		Nurfed_UpdateHealth("pet");
		Nurfed_UpdateMana("pet");
		Nurfed_UpdateManaType("pet");
		Nurfed_RefreshAuras("pet");
		Nurfed_UnitUpdateName("pet");
		Nurfed_PetFrame_SetHappiness();
		Nurfed_PetExpBar_Update();
		Nurfed_UpdateCurrentState("pet");
	else
		this:Hide();
	end
end

function Nurfed_PetFrame_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Nurfed_PetFrame_Update();
		return;
	end
	if ( event == "UNIT_PET" ) then
		Nurfed_PetFrame_Update();
		return;
	end
	if ( event == "PET_ATTACK_START" ) then
		this.inCombat = 1;
		Nurfed_UpdateCurrentState("pet");
		return;
	end
	if ( event == "PET_ATTACK_STOP" ) then
		this.inCombat = nil;
		Nurfed_UpdateCurrentState("pet");
		return;
	end
	if ( event == "UNIT_HAPPINESS" ) then
		Nurfed_PetFrame_SetHappiness();
		return;
	end
	if ( event == "UNIT_PET_EXPERIENCE" ) then
		Nurfed_PetExpBar_Update();
		return;
	end
	if ( event == "UNIT_LEVEL" ) then
		Nurfed_UnitUpdateName("pet");
		return;
	end
end

---------------------------------------------------------------------------
--			Nurfed Target Functions
---------------------------------------------------------------------------

function NurfedTarget_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this.statusCounter = 0;
	this.statusSign = -1;
	this.unitHPPercent = 1;

	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_FACTION");
	this:RegisterEvent("UNIT_DYNAMIC_FLAGS");
	this:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_FLAGS_CHANGED");
	this:RegisterEvent("PLAYER_COMBO_POINTS");

	table.insert(UnitPopupFrames,"Nurfed_targetDropDown");
	this.unit = "target";
end

local function NurfedTarget_CheckFaction()
	local info = Nurfed_Reaction("target");
	Nurfed_targetBG:SetVertexColor(info.r, info.g, info.b, info.a);
	Nurfed_UpdateRank("target");
end

local function NurfedTarget_GetMobType()
	local classification = UnitClassification("target");
	if ( classification == "worldboss" ) then
		return "Boss";
	elseif ( classification == "rareelite"  ) then
		return "Rare-Elite";
	elseif ( classification == "elite"  ) then
		return "Elite";
	elseif ( classification == "rare"  ) then
		return "Rare";
	else
		return nil;
	end
end

local function NurfedTarget_CheckLevel()
	local playerLevel = UnitLevel("player");
	local targetLevel = UnitLevel("target");
	local targetMobType = NurfedTarget_GetMobType();
	local displayText;

	if ( UnitIsPlusMob("target") ) then
		displayText = targetLevel.."+";
	elseif ( targetLevel == 0 ) then
		displayText = "";
	elseif ( targetLevel < 0 ) then
		displayText = "??";
	else
		displayText = targetLevel;
	end

	if ( targetMobType ) then
		if (targetMobType == "Boss") then
			displayText = targetMobType;
		else
			displayText = targetMobType.." "..displayText;
		end
	else
		displayText = "Level "..displayText;
	end

	if ( UnitIsCorpse("target") ) then
		displayText = "Corpse";
	end

	Nurfed_targetInfo:SetText(displayText);
	-- Color level number
	local color = GetDifficultyColor(targetLevel);
	Nurfed_targetInfo:SetVertexColor(color.r, color.g, color.b);
end

local function NurfedTarget_UpdateCombos()
	local points = GetComboPoints();
	if ( ComboFrame:IsVisible() ) then
		ComboFrame:Hide();
	end
	if ( points > 0 ) then
		Nurfed_targetClassComboText:Show();
		Nurfed_targetClassComboText:SetText(points);
		Nurfed_targetCombo:SetText("Combo: "..NORMAL_FONT_COLOR_CODE..points..FONT_COLOR_CODE_CLOSE);
	elseif ( UnitIsPlayer("target") ) then
		Nurfed_targetClassComboText:Hide();
		local classcolor = Nurfed_UnitClass[UnitClass("target")];
		if (not classcolor) then classcolor = "FFFFFF"; end
		Nurfed_targetCombo:SetText("|cff"..classcolor..UnitClass("target").."|r");
	elseif ( UnitCreatureType("target") == "Humanoid" and UnitIsFriend("player", "target") ) then
		Nurfed_targetClassComboText:Hide();
		Nurfed_targetCombo:SetText( "NPC" );
	else
		Nurfed_targetClassComboText:Hide();
		Nurfed_targetCombo:SetText(UnitCreatureType("target"));
	end
end

local function Nurfed_targetUpdate()
	if ( UnitExists("target") ) then
		this:Show();
		Nurfed_UnitUpdateName("target");
		NurfedTarget_CheckLevel();
		NurfedTarget_CheckFaction();
		NurfedTarget_UpdateCombos();
		Nurfed_UpdatePvP("target");
		if (getglobal("MobHealthFrame")) then
			MobHealthFrame:Hide();
		end
		Nurfed_RefreshAuras("target");
		Nurfed_UpdateHealth("target");
		Nurfed_UpdateMana("target");
		Nurfed_UpdateManaType("target");
		Nurfed_AuraUpdatePos("target");
		if (Nurfed_UnitConfig[Nurfed_UnitPlayer]["targetPreserve"] == 1) then
			if (not UnitIsDead("target")) then
				Nurfed_TargetSwitch = true;
			end
		end
	else
		this:Hide();
		Nurfed_targettarget:Hide();
		Nurfed_targettargettarget:Hide();

		if (Nurfed_TargetSwitch) then
			if (Nurfed_TargetInCombat) then
				Nurfed_TargetSwitch = false;
				TargetLastTarget();
			else
				Nurfed_TargetSwitch = false;
			end
		end
	end
end

function NurfedTarget_OnEvent(event)
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		Nurfed_targetUpdate();
		return;
	end
	if ( event == "UNIT_FACTION" ) then
		if ( arg1 == "target" or arg1 == "player" ) then
			NurfedTarget_CheckFaction();
			NurfedTarget_CheckLevel();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		NurfedTarget_UpdateCombos();
		return;
	end
	if ( arg1 ~= "target" ) then
		return;
	end
	if ( event == "UNIT_LEVEL" ) then
		NurfedTarget_CheckLevel();
		return;
	end
	if ( event == "UNIT_DYNAMIC_FLAGS" ) then
		NurfedTarget_CheckFaction();
		return;
	end
	if ( event == "UNIT_CLASSIFICATION_CHANGED" ) then
		NurfedTarget_CheckLevel();
		return;
	end
end

function Nurfed_TargetOnShow()
	if ( UnitIsEnemy("target", "player") ) then
		PlaySound("igCreatureAggroSelect");
	elseif ( UnitIsFriend("player", "target") ) then
		PlaySound("igCharacterNPCSelect");
	else
		PlaySound("igCreatureNeutralSelect");
	end
end

function NurfedTarget_OnHide()
	PlaySound("INTERFACESOUND_LOSTTARGETUNIT");
	this:StopMovingOrSizing();
	CloseDropDownMenus();
end

---------------------------------------------------------------------------
--			Nurfed Unit Events
---------------------------------------------------------------------------

function Nurfed_UnitFrames_OnLoad()
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("UNIT_PVP_UPDATE");
	this:RegisterEvent("UNIT_NAME_UPDATE");

	Nurfed_UpdateScale = 0;
	Nurfed_ToT_Elapsed = 0;
end

function Nurfed_UnitFrames_OnEvent(event)
	if (event == "UNIT_PVP_UPDATE") then
		Nurfed_UpdatePvP(arg1);
		return;
	end
	if (event == "UNIT_NAME_UPDATE") then
		Nurfed_UnitUpdateName(arg1);
		return;
	end
	if ( (event == "UNIT_AURA" or event == "PLAYER_AURAS_CHANGED") and Nurfed_UnitAuras[arg1]) then
		if (arg1 == "target" or arg1 == "pet") then
			Nurfed_AuraUpdatePos(arg1);
		end
		Nurfed_RefreshAuras(arg1);
		return;
	end
end
