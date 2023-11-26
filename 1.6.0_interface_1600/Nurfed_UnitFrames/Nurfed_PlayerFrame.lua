--[[ ** Nurfed Player Frame ** ]]--

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

	-- Experience Events
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("UPDATE_EXHAUSTION");
	this:RegisterEvent("PLAYER_LEVEL_UP");

	table.insert(UnitPopupFrames,"Nurfed_playerDropDown");
end

function Nurfed_Player_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this.inCombat = nil;
		this.onHateList = nil;
		Nurfed_UpdateCurrentState();
		Nurfed_Player_XPUpdate();
		Nurfed_UpdateHealth("player");
		Nurfed_UpdateMana("player");
		Nurfed_UpdateManaType("player");
		return;
	end

	if ( event == "PLAYER_ENTER_COMBAT" ) then
		this.inCombat = 1;
		Nurfed_UpdateCurrentState();
		return;
	end

	if ( event == "PLAYER_UPDATE_RESTING" ) then
		Nurfed_UpdateCurrentState();
		return;
	end

	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		this.inCombat = nil;
		Nurfed_UpdateCurrentState();
		return;
	end

	if ( event == "PLAYER_REGEN_DISABLED" ) then
		this.onHateList = 1;
		Nurfed_UpdateCurrentState();
		return;
	end

	if ( event == "PLAYER_REGEN_ENABLED" ) then
		this.onHateList = nil;
		Nurfed_UpdateCurrentState();
		return;
	end

	if ( (event == "PLAYER_XP_UPDATE") or (event == "UPDATE_EXHAUSTION") or (event == "PLAYER_LEVEL_UP") ) then
		Nurfed_UnitUpdateName("player");
		Nurfed_Player_XPUpdate();
		return;
	end

	if ( event == "UNIT_COMBAT" ) then
		if ( arg1 == "player" and (Nurfed_UnitFrames[Nurfed_UnitPlayer].playerCombatFeedBack == 1) ) then
			CombatFeedback_OnCombatEvent(arg2, arg3, arg4, arg5);
		end
		return;
	end

	if (event == "UNIT_SPELLMISS") then
		if ( arg1 == "player" and (Nurfed_UnitFrames[Nurfed_UnitPlayer].playerCombatFeedBack == 1) ) then
			CombatFeedback_OnSpellMissEvent(arg2);
		end
		return;
	end
end

function Nurfed_UpdateCurrentState()
	if (this.inCombat == 1 or this.onHateList == 1) then
		Nurfed_playerName:SetTextColor(1, 0, 0);
		Nurfed_playerStatusIcon:Show();
		Nurfed_playerStatusIcon:SetTexCoord(.5625, .9375, .0625, .4375);
	elseif ( IsResting() ) then
		Nurfed_playerName:SetTextColor(1, 1, 0);
		Nurfed_playerStatusIcon:Show();
		Nurfed_playerStatusIcon:SetTexCoord(.0625, .4375, .0625, .4375);
	else
		Nurfed_playerName:SetTextColor(1, 1, 1);
		Nurfed_playerStatusIcon:Hide();
	end
end

function Nurfed_Player_XPUpdate()
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

function Nurfed_Player_OnUpdate(elapsed)
	CombatFeedback_OnUpdate(elapsed);
end
