--[[

	TipBuddy: ---------
		copyright 2005 by Chester

]]

function TB_AddMessage( text )
	if (not text) then
		return;	
	end
	if (TipBuddy_SavedVars.debug) then
		ChatFrame3:AddMessage(GREEN_FONT_COLOR_CODE..""..text.."");
	end
end

--/script TipBuddy_SavedVars["textcolors"].nam_fri = TipBuddy_RGBToHexColor( 1, 0, 1 ); TipBuddy_InitializeTextColors();
function TipBuddy_RGBToHexColor( r, g, b, text )
	--local num = 220;
	if (not text) then
		text = "";	
	end
	r = string.format("%x", (format("%.1f", r))*255);
	g = string.format("%x", (format("%.1f", g))*255);
	b = string.format("%x", (format("%.1f", b))*255);
	if (not r or r == "0" or r == 0) then
		r = "00";	
	end
	if (not g or g == "0" or g == 0) then
		g = "00";	
	end
	if (not b or b == "0" or b == 0) then
		b = "00";	
	end
	local hex = ("|cff"..r..g..b..text);
	TB_AddMessage(hex);
	return hex;
end

function TipBuddy_ReportVarStats()
	if (TipBuddy_Main_Frame:IsVisible()) then
		TB_AddMessage("MainFrame Visible, alpha: "..TipBuddy_Main_Frame:GetAlpha());
	else
		TB_AddMessage("MainFrame NOT Visible");
	end
	if (GameTooltip:IsVisible()) then
		TB_AddMessage("GTT Visible");
		TB_AddMessage("GTT Bottom = "..GameTooltip:GetBottom());
	else
		TB_AddMessage("GTT NOT Visible");
	end
	if (TipBuddy.hasTarget == 1) then
		TB_AddMessage("TB has target");
	else
		TB_AddMessage("TB does NOT have target");
	end
end

function TipBuddy_GetUIScale()
	local uiScale;
	if ( GetCVar("useUiScale") == "1" ) then
		uiScale = tonumber(GetCVar("uiscale"));
		if ( uiScale > 0.9 ) then
			uiScale = 0.9;	
		end
	else
		uiScale = 0.9;
	end
	return uiScale;
end

function TipBuddy_GetDifficultyColor(level)
	local levelDiff = level - UnitLevel("player");
	local color, text;
	if ( levelDiff >= 5 ) then
		color = tbcolor_lvl_impossible;
		text = "Impossible";
	elseif ( levelDiff >= 3 ) then
		color = tbcolor_lvl_verydifficult;
		text = "Very Difficult";
	elseif ( levelDiff >= -2 ) then
		color = tbcolor_lvl_difficult;
		text = "Difficult";
	elseif ( -levelDiff <= GetQuestGreenRange() ) then
		color = tbcolor_lvl_standard;
		text = "Standard";
	else
		color = tbcolor_lvl_trivial;
		text = "Trivial";
	end
	return color, text;
end

function TB_NoNegative(num)
	if (num < 0) then
		num = 0;
		return num;
	else
		return num;
	end
end

-- Start the countdown on a frame
function TipBuddyPopup_StartCounting(frame)
	if ( frame.parent ) then
		TipBuddyPopup_StartCounting(frame.parent);
	else
		frame.showTimer = TB_POPUP_TIMER;
		frame.isCounting = 1;
	end
end

-- Stop the countdown on a frame
function TipBuddyPopup_StopCounting(frame)
	if ( frame.parent ) then
		TipBuddyPopup_StopCounting(frame.parent);
	else
		frame.isCounting = nil;
	end
end

function TipBuddy_GetUnitReaction( unit )
	if ( UnitPlayerControlled(unit) ) then
		if ( UnitCanAttack(unit, "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", unit) ) then
				return "caution";
			else
				return "hostile";
			end
		elseif ( UnitCanAttack("player", unit) ) then
			-- Players we can attack but which are not hostile are yellow
				return "neutral";
		elseif ( UnitIsPVP(unit) ) then
			-- Players we can assist but are PvP flagged are green
				return "pvp";
		else
			-- All other players are blue (the usual state on the "blue" server)
				return "friendly";
		end
	elseif ( UnitIsFriend(unit, "player") and UnitIsPVP(unit) ) then
		return "pvp";
	elseif ( UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) ) then
		return "tappedother";
	elseif ( UnitIsTappedByPlayer(unit) ) then
		return "tappedplayer";
	else
		local reaction = UnitReaction(unit, "player");
		--/script DEFAULT_CHAT_FRAME:AddMessage(UnitReaction("target", "player"));
		--/script DEFAULT_CHAT_FRAME:AddMessage(TipBuddyUnitReaction[4].r);
		if ( reaction ) then
			return TipBuddyUnitReaction[reaction].r;
		else
				return "friendly";
		end
	end
end
