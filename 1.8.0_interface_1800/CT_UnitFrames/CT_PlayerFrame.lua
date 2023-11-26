CT_AddMovable("CT_PlayerFrame_Drag", CT_PLAYERFRAME_MOVABLE, "TOPLEFT", "TOPLEFT", "UIParent", 97, -25, function(status)
	if ( status ) then
		CT_PlayerFrame_Drag:Show();
	else
		CT_PlayerFrame_Drag:Hide();
	end
end);

CT_PlayerHealthTextVar = "";
CT_PlayerManaTextVar = "";
CT_PlayerFrame_ShowNumber = nil;
CT_PlayerFrame_ShowPercent = nil;

function CT_PlayerFrame_UpdateNow()
	CT_ShowPlayerHealth();
	CT_ShowPlayerMana();
	CT_ShowPlayerHealthPercent();
	CT_ShowPlayerManaPercent();
	CT_PlayerFrame_UpdateSBT();
end

function CT_PlayerFrame_Update(modid)
	local val = CT_Mods[modid]["modValue"];
	if ( not val ) then return; end
	if ( val == "1" ) then
		CT_PlayerFrame_ShowNumber = nil;
		CT_PlayerFrame_ShowPercent = nil;
	elseif ( val == "2" ) then
		CT_PlayerFrame_ShowNumber = 1;
		CT_PlayerFrame_ShowPercent = 1;
	elseif ( val == "3" ) then
		CT_PlayerFrame_ShowNumber = 1;
		CT_PlayerFrame_ShowPercent = nil;
	elseif ( val == "4" ) then
		CT_PlayerFrame_ShowNumber = nil;
		CT_PlayerFrame_ShowPercent = 1;
	end

	CT_PlayerFrame_UpdateNow();
end

function CT_PlayerFrameOnLoad()

	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_SHAPESHIFT_FORMS");

	CT_PlayerHealthText:SetTextColor(1, 1, 1);
	CT_PlayerManaText:SetTextColor(1, 1, 1);
end

function CT_PlayerFrameOnEvent (event)

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		CT_ShowPlayerHealth();
		CT_ShowPlayerHealthPercent();
		CT_ShowPlayerMana();
		CT_ShowPlayerManaPercent();
		return;
	end

	if( event == "UNIT_HEALTH" and arg1 == "player" ) then
		CT_ShowPlayerHealth();
		CT_ShowPlayerHealthPercent();
		return;
	elseif ( event == "UNIT_HEALTH" and arg1 == "pet" ) then
		CT_ChangePetHealthBar();
		return;
	end
	
	if( event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY" or event == "UPDATE_SHAPESHIFT_FORMS") then
		CT_ShowPlayerMana();
		CT_ShowPlayerManaPercent();
		return;
	end

	if ( event == "VARIABLES_LOADED" ) then
		CT_PlayerFrame_UpdateSBT();
	end
end

function CT_ShowPlayerHealth()
	if ( not UnitExists("player") ) then
		return;
	end
	local hp = UnitHealth("player") / UnitHealthMax("player");
	local r, g = 1, 1;
	if ( hp > 0.5 ) then
		r = (1.0 - hp) * 2;
		g = 1.0;
	else
		r = 1.0;
		g = hp * 2;
	end
	if ( r < 0 ) then r = 0; elseif ( r > 1 ) then r = 1; end
	if ( g < 0 ) then g = 0; elseif ( g > 1 ) then g = 1; end
	PlayerFrameHealthBar:SetStatusBarColor(r, g, 0);
	if ( not CT_PlayerFrame_ShowNumber ) then
		CT_PlayerHealthText:Hide();
		return;
	else
		CT_PlayerHealthText:Show();
	end
	CT_PlayerHealthText:SetText(UnitHealth("player") .. "/" .. UnitHealthMax("player"));
end

function CT_ChangePetHealthBar()
	if ( not UnitExists("pet") ) then
		return;
	end
	local hp = UnitHealth("pet") / UnitHealthMax("pet");
	local r, g = 1, 1;
	if ( hp ) then
		if ( hp > 0 ) then
			if ( hp > 0.5 ) then
				r = (1.0 - hp) * 2;
				g = 1.0;
			else
				r = 1.0;
				g = hp * 2;
			end
		else
			r = 0; g = 1;
		end
	else
		r = 0; g = 1;
	end
	if ( r < 0 ) then r = 0; elseif ( r > 1 ) then r = 1; end
	if ( g < 0 ) then g = 0; elseif ( g > 1 ) then g = 1; end
	PetFrameHealthBar:SetStatusBarColor(r, g, 0);
end


function CT_ShowPlayerMana()
	if ( not CT_PlayerFrame_ShowNumber ) then
		CT_PlayerManaText:Hide();
		return;
	else
		CT_PlayerManaText:Show();
	end
	CT_PlayerManaText:SetText(UnitMana("player") .. "/" .. UnitManaMax("player"));
end



function CT_ShowPlayerHealthPercent()
	if ( not CT_PlayerFrame_ShowPercent ) then
		CT_PlayerHealthPercent:Hide();
		return;
	else
		CT_PlayerHealthPercent:Show();
	end
	local percent = floor(UnitHealth("player")/UnitHealthMax("player")*100+0.5);
	CT_PlayerHealthPercent:SetText(percent .. "%");
end

function CT_ShowPlayerManaPercent()
	if ( not CT_PlayerFrame_ShowPercent ) then
		CT_PlayerManaPercent:Hide();
		return;
	else
		CT_PlayerManaPercent:Show();
	end
	local percent = floor(UnitMana("player")/UnitManaMax("player")*100+0.5);

	CT_PlayerManaPercent:SetText(percent .. "%");
	
end

PlayerFrameModeFunction = function (modID, text)
	local val = CT_Mods[modID]["modValue"];
	if (val == "4" ) then
		val = "1";
		CT_PlayerFrame_ShowNumber = nil;
		CT_PlayerFrame_ShowPercent = nil;
	elseif ( val == "1" ) then
		val = "2";
		CT_PlayerFrame_ShowNumber = 1;
		CT_PlayerFrame_ShowPercent = 1;
	elseif ( val == "2" ) then
		val = "3";
		CT_PlayerFrame_ShowNumber = 1;
		CT_PlayerFrame_ShowPercent = nil;
	elseif ( val == "3" ) then
		val = "4";
		CT_PlayerFrame_ShowNumber = nil;
		CT_PlayerFrame_ShowPercent = 1;
	end
	CT_PlayerFrame_UpdateNow();
	CT_PlayerFrame_UpdateSBT();
	CT_Print("<CTMod> " .. CT_PLAYERSTATS_MODNAME .. " - " .. CT_PLAYERSTATS_VAL[tonumber(val)], 1, 1, 0);

	if ( text ) then text:SetText(val); end
	CT_Mods[modID]["modValue"] = val;
end

CT_RegisterMod(CT_PLAYERSTATS_MODNAME, CT_STATS_SUBNAME, 4, "Interface\\Icons\\INV_Scroll_01", CT_PLAYERSTATS_TOOLTIP, "switch", "1", PlayerFrameModeFunction, CT_PlayerFrame_Update);

	local func = function(modId)
		local val = CT_Mods[modId]["modStatus"];
		if ( val == "on" ) then
			CT_Print("<CTMod> " .. CT_STATS_LOCK_ON, 1, 1, 0);
			if ( CT_TargetFrame_Drag ) then
				CT_TargetFrame_Drag:Show();
			end
			if ( CT_PlayerFrame_Drag ) then
				CT_PlayerFrame_Drag:Show();
			end
		else
			CT_Print("<CTMod> " .. CT_STATS_LOCK_OFF, 1, 1, 0);
			if ( CT_TargetFrame_Drag ) then
				CT_TargetFrame_Drag:Hide();
			end
			if ( CT_PlayerFrame_Drag ) then
				CT_PlayerFrame_Drag:Hide();
			end
		end
	end

	local initfunc = function(modId)
		local val = CT_Mods[modId]["modStatus"];
		if ( val == "on" ) then
			if ( CT_TargetFrame_Drag ) then
				CT_TargetFrame_Drag:Show();
			end
			if ( CT_PlayerFrame_Drag ) then
				CT_PlayerFrame_Drag:Show();
			end
		else
			if ( CT_TargetFrame_Drag ) then
				CT_TargetFrame_Drag:Hide();
			end
			if ( CT_PlayerFrame_Drag ) then
				CT_PlayerFrame_Drag:Hide();
			end
		end
	end

	local resetfunc = function()
		CT_Print("<CTMod> " .. CT_STATS_RESETFRAMES, 1, 1, 0);
		CT_PlayerFrame_Drag:ClearAllPoints();
		CT_TargetFrame_Drag:ClearAllPoints();
		CT_TargetFrame_Drag:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 278, -25);
		CT_PlayerFrame_Drag:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 97, -25);
	end

	--CT_RegisterMod(CT_STATS_MODNAME_RESET, CT_STATS_SUBNAME_RESETUNLOCK, 4, "Interface\\Icons\\INV_Box_01", CT_STATS_TOOLTIP_RESET, "switch", "", resetfunc);
	--CT_RegisterMod(CT_STATS_MODNAME_UNLOCK, CT_STATS_SUBNAME_RESETUNLOCK, 4, "Interface\\Icons\\INV_Misc_Key_07", CT_STATS_TOOLTIP_UNLOCK, "off", nil, func, initfunc);

CT_oldTSB_OE = TextStatusBar_OnEvent;

function CT_TextStatusBar_OnEvent(cvar, value)
	if ( event == "CVAR_UPDATE" and cvar == "STATUS_BAR_TEXT" and ( this == PlayerFrameHealthBar or this == PlayerFrameManaBar ) ) then
		CT_PlayerFrame_UpdateSBT();
		return;
	end
	CT_oldTSB_OE(cvar, value);
end

TextStatusBar_OnEvent = CT_TextStatusBar_OnEvent;

function CT_PlayerFrame_UpdateSBT()
	local bar1 = PlayerFrameHealthBar;
	local bar2 = PlayerFrameManaBar;

	if ( CT_PlayerFrame_ShowNumber or GetCVar("STATUSBARTEXT") == "0" ) then

		bar1.textLockable = nil;
		bar2.textLockable = nil;

		bar1.TextString:Hide();
		bar2.TextString:Hide();

	elseif ( GetCVar("STATUSBARTEXT") == "1" ) then

		bar1.textLockable = 1;
		bar2.textLockable = 1;

		bar1.TextString:Show();
		bar2.TextString:Show();

	end
end

CT_OldShowTextStatusBarText = ShowTextStatusBarText;
function CT_ShowTextStatusBarText(bar)
	if ( (bar ~= PlayerFrameManaBar and bar ~= PlayerFrameHealthBar ) or not CT_PlayerFrame_ShowNumber ) then
		CT_OldShowTextStatusBarText(bar);
	end
end
ShowTextStatusBarText = CT_ShowTextStatusBarText;