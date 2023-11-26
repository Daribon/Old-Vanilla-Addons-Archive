CT_AddMovable("CT_TargetFrame_Drag", CT_TARGETFRAME_MOVABLE, "TOPLEFT", "TOPLEFT", "UIParent", 278, -25, function(status)
	if ( status ) then
		CT_TargetFrame_Drag:Show();
	else
		CT_TargetFrame_Drag:Hide();
	end
end);

CT_TargetFrame_ShowHealth = 0;
CT_TargetFrame_ShowMana = 0;

function CT_TargetFrame_UpdateNow()
	if ( CT_TargetFrame_ShowHealth == 0 ) then
		CT_TargetHealthText:Hide();
	else
		CT_TargetHealthText:Show();
	end

	if ( CT_PlayerFrame_ShowMana == 0 ) then
		CT_TargetManaText:Hide();
	else
		CT_TargetManaText:Show();
	end
end

function CT_TargetFrame_Update(modid)
	local stat = CT_Mods[modid]["modValue"];
	if ( stat == "1" ) then
		CT_TargetFrame_ShowHealth = 0;
		CT_TargetFrame_ShowMana = 0;
	elseif ( stat == "2" ) then
		CT_TargetFrame_ShowHealth = 1;
		CT_TargetFrame_ShowMana = 1;
	elseif ( stat == "3" ) then
		CT_TargetFrame_ShowHealth = 1;
		CT_TargetFrame_ShowMana = 0;
	elseif ( stat == "4" ) then
		CT_TargetFrame_ShowHealth = 0;
		CT_TargetFrame_ShowMana = 1;
	end
	CT_TargetFrame_UpdateNow();
end

function CT_TargetFrameOnLoad ()

	CT_TargetHealthText:SetTextColor(1, 1, 1);
	CT_TargetManaText:SetTextColor(1, 1, 1);
	
end


function CT_TargetFrame_OnUpdate()
	if ( CT_TargetFrame_ShowHealth == 0 ) then
		CT_TargetHealthText:Hide();
	else
		CT_TargetHealthText:Show();
	end
	if ( CT_TargetFrame_ShowMana == 0 or UnitPowerType("target") > 0 ) then
		CT_TargetManaText:Hide();
	else
		CT_TargetManaText:Show();
	end

	if ( TargetFrame:IsVisible() ) then
		local min, max = TargetFrameHealthBar:GetMinMaxValues();
		local curr = TargetFrameHealthBar:GetValue();

		local hp = curr / max;
		if ( curr == 0 or max == 0 ) then
			hp = 1;
		end
		local r, g = 1, 1;
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
		if ( r < 0 ) then r = 0; elseif ( r > 1 ) then r = 1; end
		if ( g < 0 ) then g = 0; elseif ( g > 1 ) then g = 1; end
		TargetFrameHealthBar:SetStatusBarColor(r, g, 0);

		local hptext = ceil(curr / max * 100);

		if (max > 100) then 
			CT_TargetHealthText:SetText( curr .. "/" .. max );
		else 
			CT_TargetHealthText:SetText( hptext .. "%" ); 
		end
		
		if ( UnitPowerType("target") == 0 ) then
			min, max = TargetFrameManaBar:GetMinMaxValues();
			curr = TargetFrameManaBar:GetValue();
			CT_TargetManaText:SetText( curr .. "/" .. max );
		end
		TargetDeadText:Hide();
	end
end

TargetFrameModeFunction = function (modID, text)
	local val = CT_Mods[modID]["modValue"];
	if (val == "4" ) then
		val = "1";
		CT_TargetFrame_ShowHealth = 0;
		CT_TargetFrame_ShowMana = 0;
	elseif ( val == "1" ) then
		val = "2";
		CT_TargetFrame_ShowHealth = 1;
		CT_TargetFrame_ShowMana = 1;
	elseif ( val == "2" ) then
		val = "3";
		CT_TargetFrame_ShowHealth = 1;
		CT_TargetFrame_ShowMana = 0;
	elseif ( val == "3" ) then
		val = "4";
		CT_TargetFrame_ShowHealth = 0;
		CT_TargetFrame_ShowMana = 1;
	else
		val = "1";
		CT_TargetFrame_ShowHealth = 0;
		CT_TargetFrame_ShowMana = 0;
	end

	CT_Print("<CTMod> " .. CT_TARGETSTATS_MODNAME .. " - " .. ( CT_TARGETSTATS_VAL[tonumber(val)] or "" ) , 1.0, 1.0, 0.0);
	if ( text ) then text:SetText(val); end
	CT_Mods[modID]["modValue"] = val;
end

CT_RegisterMod(CT_TARGETSTATS_MODNAME, CT_STATS_SUBNAME, 4, "Interface\\Icons\\INV_Scroll_01", CT_TARGETSTATS_TOOLTIP, "switch", "1", TargetFrameModeFunction, CT_TargetFrame_Update);

function CT_SetTargetClass()
	if ( not UnitExists("target") ) then return; end
	local r, g, b;
	r = 0; g = 0; b = 1;
	if ( UnitPlayerControlled("target") ) then
		if ( UnitCanAttack("target", "player") ) then
			-- Hostile players are red
			if ( not UnitCanAttack("player", "target") ) then
				r = 0.0;
				g = 0.0;
				b = 1.0;
			else
				r = UnitReactionColor[2].r;
				g = UnitReactionColor[2].g;
				b = UnitReactionColor[2].b;
			end
		elseif ( UnitCanAttack("player", "target") ) then
			-- Players we can attack but which are not hostile are yellow
			r = UnitReactionColor[4].r;
			g = UnitReactionColor[4].g;
			b = UnitReactionColor[4].b;
		elseif ( UnitIsPVP("target") ) then
			-- Players we can assist but are PvP flagged are green
			r = UnitReactionColor[6].r;
			g = UnitReactionColor[6].g;
			b = UnitReactionColor[6].b;
		else
			-- All other players are blue (the usual state on the "blue" server)
			r = 0.0;
			g = 0.0;
			b = 1.0;
		end
	else
		local reaction = UnitReaction("target", "player");
		if ( reaction ) then
			r = UnitReactionColor[reaction].r;
			g = UnitReactionColor[reaction].g;
			b = UnitReactionColor[reaction].b;
		else
			r = 0; g = 0; b = 1;
		end
	end
	if ( r < 0 ) then r = 0; elseif ( r > 1 ) then r = 1; end
	if ( g < 0 ) then g = 0; elseif ( g > 1 ) then g = 1; end
	if ( b < 0 ) then b = 0; elseif ( b > 1 ) then b = 1; end
	if ( r == 1 and g == 0 and b == 0 ) then
		CT_TargetFrameClassFrame:SetBackdropColor(1, 0, 0, 1);
	else
		CT_TargetFrameClassFrame:SetBackdropColor(r, g, b, 0.5);
	end
	if ( UnitClass("target") ) then
		CT_TargetFrameClassFrameText:SetText(UnitClass("target"));
	end
end

function CT_TargetClassFunc(modId)
	local status = CT_Mods[modId]["modStatus"];
	if ( status == "on" ) then
		CT_TargetFrameClassFrame:Show();
		CT_Print(CT_TARGETCLASS_ON, 1, 1, 0);
	else
		CT_TargetFrameClassFrame:Hide();
		CT_Print(CT_TARGETCLASS_OFF, 1, 1, 0);
	end
end

function CT_TargetClassInitFunc(modId)
	local status = CT_Mods[modId]["modStatus"];
	if ( status == "on" ) then
		CT_TargetFrameClassFrame:Show();
	else
		CT_TargetFrameClassFrame:Hide();
	end
end

CT_RegisterMod(CT_TARGETCLASS_MODNAME, CT_TARGETCLASS_SUBNAME, 4, "Interface\\Icons\\Ability_Hunter_SniperShot", CT_TARGETCLASS_TOOLTIP, "off", nil, CT_TargetClassFunc, CT_TargetClassInitFunc);

MAX_TARGET_BUFFS = 20;
CT_UnitFrames_oldTargetDebuffButton_Update = TargetDebuffButton_Update;
function CT_UnitFrames_newTargetDebuffButton_Update()
	CT_UnitFrames_oldTargetDebuffButton_Update();
	
	local numBuffs = 0;
	while ( numBuffs < MAX_TARGET_BUFFS and UnitBuff("target", numBuffs+1) ) do
		numBuffs = numBuffs + 1;
	end
	if ( UnitIsFriend("player", "target") ) then
		TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32);
		 if ( numBuffs > 6 ) then
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff7", "BOTTOMLEFT", 0, -2);
		else
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff1", "BOTTOMLEFT", 0, -2);
		end
		TargetFrameBuff7:ClearAllPoints();
		TargetFrameBuff7:SetPoint("TOPLEFT", "TargetFrameBuff1", "BOTTOMLEFT", 0, -2);
		TargetFrameBuff11:ClearAllPoints();
		TargetFrameBuff11:SetPoint("LEFT", "TargetFrameBuff10", "RIGHT", 3, 0);
	else
		TargetFrameBuff7:ClearAllPoints();
		TargetFrameBuff7:SetPoint("LEFT", "TargetFrameBuff6", "RIGHT", 3, 0);
		TargetFrameBuff11:ClearAllPoints();
		TargetFrameBuff11:SetPoint("TOPLEFT", "TargetFrameBuff1", "BOTTOMLEFT", 0, -2);
	end
	
	local buffSize, button = 21;
	if ( numBuffs > 5 ) then
		buffSize = 17;
	end
	for i = 1, 5, 1 do
		button = getglobal("TargetFrameBuff" .. i);
		button:SetWidth(buffSize);
		button:SetHeight(buffSize);
	end
end
TargetDebuffButton_Update = CT_UnitFrames_newTargetDebuffButton_Update;