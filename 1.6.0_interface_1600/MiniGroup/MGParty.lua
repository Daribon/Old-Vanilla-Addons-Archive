--[[****************************************************************
	MiniGroup vK0.4b (bugbash ver)

	Author: Kaitlin of Sargeras
	****************************************************************
	Description:
		A set of moveable, dockable, and configurable
		minimalistic, DAoC-esque mini-windows including
		Mini-Group, Mini-Target, and Mini-Group Buff windows.

	Thank you to:
		Lothero of Sargeras (my bro) for debuffing me instead
			of leveling
		ImageShack.us for hosting my pics

	Official Site:
		wow.jaslaughter.com
	
	K0.4a-Party
	****************************************************************]]

-- Local Vars
local MAX_PARTY_MEMBERS = 4;
local PARTY_FRAME_SHOWN = 1;
local MAX_PARTY_DEBUFFS = 4;
local MAX_PARTY_TOOLTIP_BUFFS = 16;
local MAX_PARTY_TOOLTIP_DEBUFFS = 8;
local TooltipMember = nil;

function MGParty_Member_OnLoad()
	this.statusCounter = 0;
	this.statusSign = -1;
	this.unitHPPercent = 1;
	MGParty_Member_UpdateMember();
	MGParty_Member_UpdateLeader();
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PARTY_LEADER_CHANGED");
	this:RegisterEvent("PARTY_MEMBER_ENABLE");
	this:RegisterEvent("PARTY_MEMBER_DISABLE");
	this:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	this:RegisterEvent("UNIT_PVP_UPDATE");
	if ( this:GetName() == "MGParty_Member0" ) then
		this:RegisterEvent("PLAYER_AURAS_CHANGED");
		this:RegisterEvent("PLAYER_UPDATE_RESTING");
	else
		this:RegisterEvent("UNIT_AURA");
	end

	-- ** Tell UIDropDownMenu to check my dropdowns
	for id = 0, 4 do
		table.insert(UnitPopupFrames,"MGParty_Member"..id.."DropDown");
	end
	MGParty_CheckResting();
end

function MGParty_Member_UpdateAllMembers()
	local prefix = "MGParty_Member";
	for id = 0, 4 do
		getglobal(prefix..id):Hide();
		if ( id == 0 or GetPartyMember(id) ) then
			getglobal(prefix..id):Show();
		end
	end
	MGParty_Frame_CheckSize();
	MGParty_FrameAutoHide();
end

function MGParty_FrameAutoHide()
	local partySize = 0;
	for num = 1, 4 do
		if ( GetPartyMember(num) ) then
			partySize = partySize + 1;
		end
	end
	if ( partySize == 0 and ( MGPlayer ~= nil and MG_Get("AutoHide") == 1 ) ) then
		MGParty_Frame:Hide();
		MGBuff_Frame:Hide();
	elseif ( partySize > 0 and MG_Get("ShowMGPartyFrame") == 1 ) then
		MGParty_Frame:Show();
	end
end

function MGParty_Member_UpdateMember()
	local id = this:GetID();
	if ( id == 0 or GetPartyMember(id) ) then
		this:Hide();
		this:Show();
	elseif ( id ~= 0 ) then
		this:Hide();
	end
	MGParty_FrameAutoHide();
end

function MGParty_Member_OnShow()
	local id = this:GetID();
	UnitFrame_UpdateManaType();
	UnitFrame_Update();
	if ( PARTY_FRAME_SHOWN == 1 ) then
		this:Show();
	end

	local lootMethod;
	local lootMaster;
	lootMethod, lootMaster = GetLootMethod();
	if ( id == lootMaster ) then
		getglobal(this:GetName().."MasterIcon"):Show();
	else
		getglobal(this:GetName().."MasterIcon"):Hide();
	end

	MGParty_Member_UpdatePvPStatus();
	MGParty_Member_RefreshBuffs();
	MGParty_Frame_CheckSize();
end

function MGParty_Member_OnHide()
	MGParty_Frame_CheckSize();
	MGBuff_RefreshBuffs();
end

function MGParty_Member_UpdateLeader()
	local id = this:GetID();
	local icon = getglobal("MGParty_Member"..id.."LeaderIcon");
	if( (GetPartyLeaderIndex() == id) and (PARTY_FRAME_SHOWN == 1) ) then
		icon:Show();
	else
		icon:Hide();
	end
	if ( MGPlayer ~= nil and MG_Get("ShowPartyFrames") == 0 ) then
		HidePartyFrame();
	end
end

function MGParty_Member_UpdatePvPStatus()
	local id = this:GetID();
	local unit;
	if ( id == 0 ) then
		unit = "player";
	else
		unit = "party"..id;
	end
	local icon = getglobal("MGParty_Member"..id.."PVPIcon");
	local factionGroup = UnitFactionGroup(unit);
	if ( UnitIsPVPFreeForAll(unit) ) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		icon:Show();	
	elseif ( factionGroup and UnitIsPVP(unit) ) then
		icon:SetTexture("Interface\\GroupFrame\\UI-Group-PVP-"..factionGroup);
		icon:Show();
	else
		icon:Hide();
	end
end

function MGParty_Member_OnEvent(event)
	if ( event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED" or event == "PARTY_MEMBER_ENABLE" or event == "PARTY_MEMBER_DISABLE") then
		if ( MG_Get("ShowTargetFrame") == 0 and TargetFrame:IsVisible() ) then
			TargetFrame:Hide();
			if (getglobal("MobHealthFrame")) then
				MobHealthFrame:Hide();
			end
		end
	end
	if ( arg1 and arg1 == "target" ) then
		return;
	end
	if ( this:GetID() ~= 0 and not GetPartyMember(this:GetID()) ) then
		getglobal("MGParty_Member"..this:GetID()):Hide();
		return;
	end

	UnitFrame_OnEvent(event);

	if ( event == "PARTY_MEMBERS_CHANGED" ) then
		MGParty_Member_UpdateMember();
		return;
	end
	
	if ( event == "PARTY_LEADER_CHANGED" ) then
		MGParty_Member_UpdateLeader();
		return;
	end

	if ( event == "PARTY_MEMBER_ENABLE" or event == "PARTY_MEMBER_DISABLE" ) then
		if ( arg1 == this:GetID() ) then
			UnitFrame_Update();
			MGParty_Member_RefreshBuffs();
			if ( MGPlayer ~= nil and MG_Get("ShowPartyFrames") == 0 ) then
				HidePartyFrame();
			end
		end
		return;
	end

	if ( event == "PARTY_LOOT_METHOD_CHANGED" ) then
		local lootMethod;
		local lootMaster;
		lootMethod, lootMaster = GetLootMethod();
		if ( this:GetID() == lootMaster ) then
			getglobal(this:GetName().."MasterIcon"):Show();
		else
			getglobal(this:GetName().."MasterIcon"):Hide();
		end
		return;
	end

	if ( event == "UNIT_PVP_UPDATE" ) then
		local unit = "party"..this:GetID();
		if ( this:GetID() == 0 or arg1 == unit ) then
			MGParty_Member_UpdatePvPStatus();
		end
		return;
	end

	if ( event == "PLAYER_AURAS_CHANGED" ) then
		MGParty_Member_RefreshBuffs();
		return;
	end

	if ( event == "UNIT_AURA" ) then
		MGParty_Member_RefreshBuffs();
		if ( ( MGPlayer ~= nil and MG_Get("ShowMGPartyTips") ~= 0 ) and TooltipMember == this:GetID() ) then
			MGParty_BuffTooltip_Update(this);
		end
		return;
	end

	if ( event == "PLAYER_UPDATE_RESTING" ) then
		MGParty_CheckResting();
	end
end

function MGParty_Member_OnClick(partyFrame)
	local unit;
	if ( SpellIsTargeting() and arg1 == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( not partyFrame ) then
		partyFrame = this;
	end

	if ( partyFrame:GetID() == 0 ) then
		unit = "player";
	else
		unit = "party"..partyFrame:GetID();
	end

	if ( arg1 == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit(unit);
		elseif ( CursorHasItem() ) then
			if ( partyFrame:GetID() == 0 ) then
				AutoEquipCursorItem();
			else
				DropItemOnUnit(unit);
			end
		else
			TargetUnit(unit);
		end
	else
		if ( this:GetName() == "MGParty_Member"..partyFrame:GetID() ) then
			MGParty_BuffTooltip:Hide();
			ToggleDropDownMenu(1, nil, getglobal("MGParty_Member"..partyFrame:GetID().."DropDown"), partyFrame:GetName(), 47, 15);
		end
	end
end

function MGParty_Member_RefreshBuffs()
	MGBuff_RefreshBuffs();
	MiniGroup_RefreshBuffs();
end

function MGParty_BuffTooltip_Update(frame)
	local buff, buffButton;
	local numBuffs = 0;
	local numDebuffs = 0;
	local index = 1;
	local unit;
	local TipStyle = MG_Get("MGToolTipStyle");

	if ( not frame ) then
		frame = this;
	end

	if ( isPet ) then
		unit = "pet";
	elseif ( frame:GetID() == 0 ) then
		unit = "player";
	else
		unit = "party"..frame:GetID();
	end

	if ( TipStyle == 1 or TipStyle == 3 ) then
		index = 1;
		for i=1, MAX_PARTY_TOOLTIP_BUFFS do
			buff = nil;
			buff = UnitBuff(unit,i);
			if ( buff ) then
				getglobal("MGParty_BuffTooltip_Buff"..index.."Icon"):SetTexture(buff);
				getglobal("MGParty_BuffTooltip_Buff"..index.."Overlay"):Hide();
				getglobal("MGParty_BuffTooltip_Buff"..index):Show();
				index = index + 1;
				numBuffs = numBuffs + 1;
			end
		end
	end
	for i=index, MAX_PARTY_TOOLTIP_BUFFS do
		getglobal("MGParty_BuffTooltip_Buff"..i):Hide();
	end

	if ( numBuffs == 0 ) then
		MGParty_BuffTooltip_Debuff1:SetPoint("TOP", "MGParty_BuffTooltip_Buff1", "TOP", 0, 0);
	elseif ( numBuffs <= 8 ) then
		MGParty_BuffTooltip_Debuff1:SetPoint("TOP", "MGParty_BuffTooltip_Buff1", "BOTTOM", 0, -2);
	else
		MGParty_BuffTooltip_Debuff1:SetPoint("TOP", "MGParty_BuffTooltip_Buff9", "BOTTOM", 0, -2);
	end

	if ( TipStyle == 2 or TipStyle == 3 ) then
		index = 1;
		for i=1, MAX_PARTY_TOOLTIP_DEBUFFS do
			buff = nil;
			buff = UnitDebuff(unit, i);
			if ( buff ) then
				getglobal("MGParty_BuffTooltip_Debuff"..index.."Icon"):SetTexture(buff);
				getglobal("MGParty_BuffTooltip_Debuff"..index.."Overlay"):Show();
				getglobal("MGParty_BuffTooltip_Debuff"..index):Show();
				index = index + 1;
				numDebuffs = numDebuffs + 1;
			end
		end
	end
	for i=index, MAX_PARTY_TOOLTIP_DEBUFFS do
		getglobal("MGParty_BuffTooltip_Debuff"..i):Hide();
	end

	-- Size the tooltip
	local rows = ceil(numBuffs / 8) + ceil(numDebuffs / 8);
	local columns = min(8, max(numBuffs, numDebuffs));
	if ( (rows > 0) and (columns > 0) ) then
		MGParty_BuffTooltip:SetWidth( (columns * 17) + 15 );
		MGParty_BuffTooltip:SetHeight( (rows * 17) + 15 );
		MGParty_BuffTooltip:Show();
	else
		if ( frame.unit ) then
			GameTooltip:SetUnit(frame.unit);
			local myStr = GameTooltipTextLeft3:GetText();
			if ( myStr and strfind(myStr,"PvP",1,true) == nil ) then
				GameTooltip_SetDefaultAnchor(GameTooltip, frame);
				GameTooltip:SetText(NORMAL_FONT_COLOR_CODE..UnitName("party"..frame:GetID())..HIGHLIGHT_FONT_COLOR_CODE.."\n"..myStr..FONT_COLOR_CODE_CLOSE, 1.0, 0.82, 0);
			else
				GameTooltip:Hide();
			end
		end	
		MGParty_BuffTooltip:Hide();
	end
end

function MGPartyMember_HealthCheck()
	local prefix = this:GetParent():GetName();
	local unitMinHP, unitMaxHP, unitCurrHP, unitPercentHP;
	unitHPMin, unitHPMax = this:GetMinMaxValues();
	unitCurrHP = this:GetValue();
	if ( unitHPMax > 0 ) then
		this:GetParent().unitHPPercent = unitCurrHP / unitHPMax;
	else
		this:GetParent().unitHPPercent = 0;
	end

	unitPercentHP = ""..((unitCurrHP/unitHPMax)*100);
	unitPercentHP = string.gsub(unitPercentHP, "(%d+)(%.)(%d+)", "%1");
	unitHealthText = getglobal(prefix.."HealthText");

	if ( unitHPMax == 0 ) then
		unitHealthText:SetText("Offline");
	else
		if ( MG_Get("ShowHealthType") == 1 ) then
			unitHealthText:SetText(unitCurrHP.."/"..unitHPMax);
		else
			unitHealthText:SetText(unitPercentHP.."%")
		end
	end

	local info = ManaBarColor[UnitPowerType(this:GetParent().unit)];
	getglobal(prefix.."ManaBarBG"):SetStatusBarColor(info.r, info.g, info.b, 0.25);

	if ( UnitIsDead(this:GetParent().unit) or UnitIsGhost(this:GetParent().unit) ) then
		getglobal(prefix.."DeadText"):Show();
	else
		getglobal(prefix.."DeadText"):Hide();
	end
end

function MGParty_MemberDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, MGParty_MemberDropDown_Initialize, "MENU");
end

function MGParty_MemberDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	if ( this:GetID() == 0 ) then
		UnitPopup_ShowMenu(dropdown, "SELF", "player");
	else
		UnitPopup_ShowMenu(dropdown, "PARTY", "party"..this:GetID());
	end
end

function MGParty_Frame_CheckSize()
	if ( MGParty_Frame and MGBuff_Frame ) then
		if ( MG_Get("MGMemberScaling") == 1 ) then
			local partySize = 0;
			for id = 0, 4 do
				if ( id == 0 or GetPartyMember(id) ) then
					partySize = partySize + 1;
					if ( MG_Get("ShowMGPartyBuffs") == 1 ) then
						MGParty_Frame:SetHeight(40 + ( 47 * partySize ) );
						MGBuff_Frame:SetHeight(40 + (47 * partySize));
						getglobal("MGParty_Member"..id):SetHeight(47);
						getglobal("MGBuffMember"..id):SetHeight(47);
					else
						MGParty_Frame:SetHeight(40 + ( 28 * partySize ) );
						MGBuff_Frame:SetHeight(40 + (28 * partySize));
						getglobal("MGParty_Member"..id):SetHeight(28);
						getglobal("MGBuffMember"..id):SetHeight(28);
					end
				end
			end
		else
			for id = 0, 4 do
				if ( MG_Get("ShowMGPartyBuffs") == 1 ) then
					MGParty_Frame:SetHeight(275);
					MGBuff_Frame:SetHeight(275);
					getglobal("MGParty_Member"..id):SetHeight(47);
					getglobal("MGBuffMember"..id):SetHeight(47);
				else
					MGParty_Frame:SetHeight(180);
					MGBuff_Frame:SetHeight(180);
					getglobal("MGParty_Member"..id):SetHeight(28);
					getglobal("MGBuffMember"..id):SetHeight(28);
				end
			end
		end
	end
end

function MGParty_Member_OnEnter(frame)
	if ( not frame ) then
		frame = this;
	end
	if ( MG_Get("ShowMGPartyTips") ~= 0 ) then
		TooltipMember = frame:GetID();
		MGParty_BuffTooltip:SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 60, -25);
		MGParty_BuffTooltip_Update(frame);
	end
	getglobal(frame:GetName().."Highlight"):Show();
end

function MGParty_Member_OnLeave(frame)
	if ( not frame ) then
		frame = this;
	end
	if ( MG_Get("ShowMGPartyTips") ~= 0 ) then
		MGParty_BuffTooltip:Hide();
	end
	GameTooltip:Hide();
	TooltipMember = nil;
	getglobal(frame:GetName().."Highlight"):Hide();
end

function MGParty_CheckResting()
	if ( IsResting() ) then
		MGParty_TitleBarText:SetText("MG (Resting)");
	else
		MGParty_TitleBarText:SetText("Mini-Group");
	end
end
