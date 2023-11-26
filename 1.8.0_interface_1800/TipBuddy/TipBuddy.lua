--[[

	TipBuddy: ---------
		copyright 2005 by Chester

]]

function TipBuddy_OnLoad()

	--RegisterForSave("TipBuddy_SavedVars");

	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE");
--	this:RegisterEvent("UI_INFO_MESSAGE");

	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_FACTION");
	this:RegisterEvent("UNIT_DYNAMIC_FLAGS");
	this:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
	this:RegisterEvent("PLAYER_PVPLEVEL_CHANGED");
	this:RegisterEvent("UNIT_AURA");
	this:RegisterEvent("PLAYER_FLAGS_CHANGED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_HAPPINESS");
	this:RegisterEvent("UNIT_MAXMANA");
	this:RegisterEvent("UNIT_MAXRAGE");
	this:RegisterEvent("UNIT_MAXFOCUS");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("UNIT_MAXHAPPINESS");
	this:RegisterEvent("UNIT_DISPLAYPOWER");
	this:RegisterEvent("UPDATE_SHAPESHIFT_FORMS");

	SLASH_TIPBUDDY1 = "/tipbuddy";
	SLASH_TIPBUDDY2 = "/tbuddy";
	SLASH_TIPBUDDY3 = "/tip";
	SlashCmdList["TIPBUDDY"] = function(msg)
		TipBuddy_SlashCommand(msg);
	end
	
	-- commented out cause it fucked up my buttons
	-- Add TipBuddy_OptionsFrame to the UIPanelWindows list
	--UIPanelWindows['TipBuddy_OptionsFrame'] = {area = 'center', pushable = 0};
end

local lGameTooltip_OnEvent_Orig;
function TipBuddy_OnEvent()
	if( event == "VARIABLES_LOADED" ) then
		TipBuddy_Variable_Initialize();
		
		--hooking GameTooltip's OnEvent
		lGameTooltip_OnEvent_Orig = GameTooltip:GetScript("OnEvent");
		GameTooltip:SetScript( "OnEvent", TipBuddy_GameTooltip_OnEvent );
		
		if (TipBuddy_SavedVars["general"].framepos_L or TipBuddy_SavedVars["general"].framepos_T) then
			TipBuddy_Header_Frame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", TipBuddy_SavedVars["general"].framepos_L, TipBuddy_SavedVars["general"].framepos_T);
		end
		if (not TipBuddy_SavedVars["general"].delaytime) then
			TipBuddy_SavedVars["general"].delaytime = "0.5";
		end
		if (not TipBuddy_SavedVars["general"].fadetime) then
			TipBuddy_SavedVars["general"].fadetime = "0.3";
		end
		if (not TipBuddy_SavedVars["general"].gtt_anchored) then
			TipBuddy_SavedVars["general"].gtt_anchored = 0;	
		end

		if (TipBuddy_SavedVars["general"].anchored == 1) then
			if (not TipBuddy_SavedVars["general"].anchor_vis_first or TipBuddy_SavedVars["general"].anchor_vis == 1) then
				TipBuddy_SavedVars["general"].anchor_vis_first = 1;
				TipBuddy_Header_Frame:Show();
			else
				TipBuddy_Header_Frame:Show();
				TipBuddy_Header_Frame:Hide();
			end
			TipBuddy.anchor, TipBuddy.fanchor, TipBuddy.offset = TipBuddy_GetFrameAnchorPos();
			this:SetPoint(TipBuddy.anchor, "TipBuddy_Header_Frame", TipBuddy.fanchor, 0, 1);
		else
			if (not TipBuddy_SavedVars["general"].anchor_vis_first) then
				TipBuddy_ResetAnchorPos();
				TipBuddy_Header_Frame:Hide();
			else
				TipBuddy_Header_Frame:Show();
				TipBuddy_Header_Frame:Hide();
			end
		end

		if( DEFAULT_CHAT_FRAME ) then
			--DEFAULT_CHAT_FRAME:AddMessage("|cffffd200TipBuddy |cffffff00v"..TIPBUDDY_VERSION.." loaded.");
		end

		TipBuddy_InitializeTextColors();

		-- Add TipBuddy to myAddOns addons list
		if (myAddOnsFrame) then	
			myAddOnsList.TipBuddy = {
					name = "|cff20ff20TipBuddy", 
					description = "Enhanced, configurable unit tooltip.", 
					version = "|cffffff00"..TIPBUDDY_VERSION, 
					category = MYADDONS_CATEGORY_OTHERS, 
					frame = "TipBuddy_OptionsFrame",
					optionsframe = "TipBuddy_OptionsFrame"
					};
		end
		--[[
		JoinChannelByName("BuddyChatChannel");
		TipBuddy.dataStartTime = GetTime();
		TipBuddy.dataEndTime = TipBuddy.dataStartTime + 300;
		TipBuddy.datasent = 1;
		]]
	end
	if ( event == "UNIT_LEVEL" ) then
		if ( arg1 == "mouseover" ) then
			TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
			TB_AddMessage("UNIT_LEVEL");
			TipBuddy_SetFrame_Visibility( TipBuddy.targetType, "mouseover", 1 );
		
			TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
			TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
			TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
		end
		return;
	end
	if ( event == "UNIT_FACTION" ) then
		if ( arg1 == "mouseover" ) then
			TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
			TB_AddMessage(TB_WHT_TXT.."UNIT_FACTION");
			TipBuddy_SetFrame_Visibility( TipBuddy.targetType, "mouseover", 1 );
		
			TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
			TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
			TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
		end
		return;
	end
	if ( event == "UNIT_DYNAMIC_FLAGS" ) then
		if ( arg1 == "mouseover" ) then
			TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
			TB_AddMessage(TB_WHT_TXT.."TB - UNIT_DYNAMIC_FLAGS");
			TipBuddy_SetFrame_Visibility( TipBuddy.targetType, "mouseover", 1 );
		
			TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
			TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
			TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
		end
		return;
	end
	if ( event == "UNIT_AURA" and arg1 == "mouseover" ) then
		TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
		TB_AddMessage(TB_WHT_TXT.."UNIT_AURA");
	
		TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
		TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
		TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
		return;
	end
	if ( event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" ) then
		if ( arg1 == "mouseover" or UnitIsPlayer("mouseover")) then
			TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
			TB_AddMessage(TB_WHT_TXT.."UNIT_HEALTH or UNIT_MAXHEALTH");

			TipBuddy_SetFrame_Visibility( TipBuddy.targetType, "mouseover", 1 );
		
			TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
			TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
			TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
			--TB_AddMessage(TipBuddy.targetType);
		end
		return;
	end
	if ( event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY" or event == "UNIT_HAPPINESS" or event == "UNIT_MAXMANA" or event == "UNIT_MAXRAGE" or event == "UNIT_MAXFOCUS" or event == "UNIT_MAXENERGY" or event == "UNIT_MAXHAPPINESS" or event == "UNIT_DISPLAYPOWER" or event == "UPDATE_SHAPESHIFT_FORMS") then
		if ( arg1 == "mouseover" or UnitIsPlayer("mouseover")) then
			TB_AddMessage("UNIT_MANA");
			TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
			if ( TipBuddy_SavedVars[TipBuddy.targetType].off == 1 ) then
				--TB_AddMessage(TB_WHT_TXT.."UNIT_MANA - go");
				TipBuddy_SetFrame_Visibility( TipBuddy.targetType, "mouseover", 1 );
		
				TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
				TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
				TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
			end
		end
		return;
	end
	--[[
	if (event == "CHAT_MSG_CHANNEL_NOTICE") then
		TipBuddy_SendData();
	end]]
end

--/script TB_AddMessage(TB_RED_TXT..UnitName("targettarget"));

function TipBuddy_SlashCommand(msg)
	if( not msg or msg == "" ) then
		TipBuddy_ToggleOptionsFrame();
	end
	if( msg == "rankname" ) then
		if (TipBuddy_SavedVars["general"].rankname == 1) then
			TipBuddy_SavedVars["general"].rankname = 0;
			DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: No longer showing full rank title in name.");
		else
			TipBuddy_SavedVars["general"].rankname = 1;
			DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Showing full rank titles in name.");
		end
	end
	if( msg == "resetanchor" ) then
		TipBuddy_ResetAnchorPos();
		DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Resetting TipBuddyAnchor position.");
	end
	if( msg == "report" ) then
		TipBuddy_ReportVarStats();
	end
	if( msg == "blizdefault" ) then
		if (TipBuddy_SavedVars["general"].blizdefault == 1) then
			TipBuddy_SavedVars["general"].blizdefault = 0;
			DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Default tooltips are now enhanced.");
		else
			TipBuddy_SavedVars["general"].blizdefault = 1;
			DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Default tooltips are no longer enhanced.");
		end
	end
	if (string.find(msg, "extras") ~= nil) then
		
		--if (damage) then
			--CSG_AddTargetToList(tonumber(j));
			local type;
		
			for type in string.gfind(msg, "extras%s(.+)") do
				if (type == "on") then
					TipBuddy_SavedVars["pc_friend"].xtr = 1;
					TipBuddy_SavedVars["pc_enemy"].xtr = 1;
					TipBuddy_SavedVars["pc_party"].xtr = 1;
					TipBuddy_SavedVars["pet_friend"].xtr = 1;
					TipBuddy_SavedVars["pet_enemy"].xtr = 1;
					TipBuddy_SavedVars["npc_friend"].xtr = 1;
					TipBuddy_SavedVars["npc_enemy"].xtr = 1;
					TipBuddy_SavedVars["npc_neutral"].xtr = 1;
					DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Extras for all target types are now ON");
					return;
				elseif (type == "off") then
					TipBuddy_SavedVars["pc_friend"].xtr = 0;
					TipBuddy_SavedVars["pc_enemy"].xtr = 0;
					TipBuddy_SavedVars["pc_party"].xtr = 0;
					TipBuddy_SavedVars["pet_friend"].xtr = 0;
					TipBuddy_SavedVars["pet_enemy"].xtr = 0;
					TipBuddy_SavedVars["npc_friend"].xtr = 0;
					TipBuddy_SavedVars["npc_enemy"].xtr = 0;
					TipBuddy_SavedVars["npc_neutral"].xtr = 0;
					DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Extras for all target types are now OFF");
					return;
				elseif (type ~= nil) then
					if (not TipBuddy_SavedVars[type]) then
						DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Could not recognize target type: "..type);
						return;
					else
						if (TipBuddy_SavedVars[type].xtr == 1) then
							TipBuddy_SavedVars[type].xtr = 0;
							DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: No longer showing extras for target type: "..type);
							return;
						else
							TipBuddy_SavedVars[type].xtr = 1;
							DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Now showing extras for target type: "..type);						
							return;
						end
					end
				end

			end
			if (not type) then
				DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Please specify a target type (ex: /tip extras pc_friend)");
				return;
			end
		--end
		return;
	end
	if (string.find(msg, "scale") ~= nil) then
		--local i, s = string.find(msg, "%d+");
		for scale in string.gfind(msg, "scale%s(%d.*)") do
			TipBuddy.s = tonumber(scale);
		end
		if (TipBuddy.s) then
			if (TipBuddy.s > 2) then
				TipBuddy.s = 2;
			elseif (TipBuddy.s < 0.25) then
				TipBuddy.s = 0.25;
			end
			GameTooltip:SetScale(2);
			GameTooltip:SetScale(UIParent:GetScale() * TipBuddy.s);
			TipBuddy_SavedVars["general"].gtt_scale = (UIParent:GetScale() * TipBuddy.s);
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff20ff20TipBuddy: Please type a scale number after 'scale' (valid numbers: 0.25-2)");
		end
		return;
	end

end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET TARGET TYPE
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_GetTargetType( unit )
	if (not unit) then
		return;
	end
	if ( ( UnitHealth(unit) <= 0 ) ) then
		return ( "corpse" );
	elseif ( ( UnitHealthMax(unit) > 0 ) ) then
		if (string.find(unit, "party.+")) then
			return ( "pc_party" );	
		end
		if (UnitPlayerControlled(unit)) then
			if (UnitIsFriend(unit, "player")) then
				if ( TipBuddy_TargetInfo_CheckPet() ) then
					return ( "pet_friend" );
				end
				
				if (UnitInParty(unit)) then
					return ( "pc_party" );
				else
					return ( "pc_friend" );
				end				
			elseif (UnitIsEnemy(unit, "player")) then
				if ( TipBuddy_TargetInfo_CheckPet() ) then
					return ( "pet_enemy" );
				else
					return ( "pc_enemy" );
				end
			else
				return ( "pet_friend" );
			end				
		else
			if (UnitIsFriend(unit, "player")) then
				if ( TipBuddy_TargetInfo_CheckPet() ) then
					return ( "pet_friend" );
				else
					return ( "npc_friend" );
				end
			elseif (UnitIsEnemy(unit, "player")) then
				if ( TipBuddy_TargetInfo_CheckPet() ) then
					return ( "pet_enemy" );
				else
					return ( "npc_enemy" );
				end
			else --neutral
				return ( "npc_neutral" );			
			end
		end	
	else
		TipBuddy_Hide( TipBuddy_Main_Frame );
		return;	
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH / MANA
--------------------------------------------------------------------------------------------------------------------------------------
ManaTextColor = {};
ManaTextColor[0] = { r = 0.50, g = 0.50, b = 1.00, prefix = TEXT(MANA) };
ManaTextColor[1] = { r = 1.00, g = 0.00, b = 0.00, prefix = TEXT(RAGE_POINTS) };
ManaTextColor[2] = { r = 1.00, g = 0.50, b = 0.25, prefix = TEXT(FOCUS_POINTS) };
ManaTextColor[3] = { r = 1.00, g = 1.00, b = 0.00, prefix = TEXT(ENERGY_POINTS) };
ManaTextColor[4] = { r = 0.00, g = 1.00, b = 1.00, prefix = TEXT(HAPPINESS_POINTS) };

function TipBuddy_UnitFrame_UpdateHealth( unit )
	UnitFrameHealthBar_Update(TipBuddy_TargetFrameHealthBar, unit);
end

function TipBuddy_UnitFrame_UpdateMana( unit )

	local manatype = UnitPowerType(unit);
	local info = ManaTextColor[manatype];

	info = ManaBarColor[manatype];
	TipBuddy_TargetFrameManaBar:SetStatusBarColor(info.r, info.g, info.b);	
	UnitFrameManaBar_Update(TipBuddy_TargetFrameManaBar, unit);
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET/SHOW BUFFS
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetBuffs_Initialize()
	local frame, bframe;
	for i=1, 8 do
		frame = "TipBuddy_BuffFrame";
		bframe = getglobal(frame.."B"..i);
		bframe:Hide();
		bframe = getglobal(frame.."D"..i);
		bframe:Hide();
		frame = "TipBuddy_BuffFrameGTT";
		bframe = getglobal(frame.."B"..i);
		bframe:Hide();
		bframe = getglobal(frame.."D"..i);
		bframe:Hide();
	end
end

function TipBuddy_TargetBuffs_Update( type, unit )
	if (not unit or not type) then
		TipBuddy_TargetBuffs_Initialize();
		return;	
	end
	local debuff, buff;
	local frame, bframe;
	local targettype = TipBuddy_SavedVars[type];
	if ( targettype.off == 0 ) then
		frame = "TipBuddy_BuffFrameGTT";
	else
		frame = "TipBuddy_BuffFrame";
	end
	for i=1, 8 do
		buff = UnitBuff(unit, i);
		bframe = getglobal(frame.."B"..i);
		if ( buff ) then
			if ( targettype.bff == 1 ) then
				getglobal(frame.."B"..i.."Icon"):SetTexture(buff);
				bframe:Show();
				bframe.id = i;				
			else
				bframe:Hide();	
			end
		else
			bframe:Hide();
		end
	end
	for i=1, 8 do
		debuff = UnitDebuff(unit, i);
		bframe = getglobal(frame.."D"..i);
		if ( debuff ) then
			if ( targettype.bff == 1 ) then
				getglobal(frame.."D"..i.."Icon"):SetTexture(debuff);
				bframe:Show();
			else
				bframe:Hide();
			end
		else
			bframe:Hide();
		end
		bframe.id = i;
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET LEVEL
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_GetLevel( type, unit )
	if (not unit) then
		return;	
	end
	local targetLevel = UnitLevel(unit);
	local targettype = TipBuddy_SavedVars[type];
	if ( targetLevel == -1 ) then
		targetLevel = 100;
	end

	-- Color level number
	local color;
	if (UnitHealth(unit) <= 0) then
		color = tbcolor_corpse;
		--TB_AddMessage("level color = corpse");
	elseif ( UnitCanAttack(unit, "player") or UnitCanAttack("player", unit) or UnitIsPVP(unit) ) then
		-- Hostile unit of friendly unit flagged for PvP
		color = TipBuddy_GetDifficultyColor(targetLevel);
		--TB_AddMessage("level color = hostile or pvp");
	else
		color = tbcolor_lvl_same_faction;
		--TB_AddMessage("level color = same fac");
	end
	
	if ( targetLevel == 100 ) then
		targetLevel = "??";
	end

	TipBuddy.classification = UnitClassification(unit);
	if ( not targetLevel or targetLevel == 0 ) then
		TipBuddy.gtt_level = ("");
		TipBuddy_TargetLevel_Text:SetText(TipBuddy.gtt_level);
	elseif ( TipBuddy.classification == "worldboss" ) then
		TipBuddy.gtt_level = (color..targetLevel..tbcolor_elite_worldboss.." ("..tb_translate_worldboss..")");
		TipBuddy_TargetLevel_Text:SetText(TipBuddy.gtt_level);
	elseif ( TipBuddy.classification == "rareelite"  ) then
		TipBuddy.gtt_level = (color.."+"..targetLevel..tbcolor_elite_rare.." ("..tb_translate_rare..")");
		TipBuddy_TargetLevel_Text:SetText(TipBuddy.gtt_level);
	elseif ( TipBuddy.classification == "elite"  ) then
		TipBuddy.gtt_level = (color.."+"..targetLevel);
		TipBuddy_TargetLevel_Text:SetText(TipBuddy.gtt_level);
	elseif ( TipBuddy.classification == "rare"  ) then
		TipBuddy.gtt_level = (color..targetLevel..tbcolor_elite_rare.." ("..tb_translate_rare..")");
		TipBuddy_TargetLevel_Text:SetText(TipBuddy.gtt_level);
	else
		TipBuddy.gtt_level = (color..targetLevel);
		TipBuddy_TargetLevel_Text:SetText(TipBuddy.gtt_level);
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET CLASS/TYPE
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_GetClass( type, unit )
	local targetLevel = UnitLevel(unit);
	TipBuddy.gtt_classlvlcolor = "";
	TipBuddy.gtt_classcorpse = "";
	TipBuddy.gtt_classcolor = "";
	if (TipBuddy_SavedVars["general"].classcolor == 1) then
		TipBuddy.gtt_classlvlcolor = "";
	elseif ( UnitCanAttack(unit, "player") or UnitCanAttack("player", unit) or UnitIsPVP(unit) ) then
		-- Hostile Units, use con color system
		TipBuddy.gtt_classlvlcolor = TipBuddy_GetDifficultyColor(targetLevel);
	else
		-- Friendly (non-PvP flagged) Units, we don't want to use the con color cause we don't care
		TipBuddy.gtt_classlvlcolor = tbcolor_lvl_same_faction;
	end
	if (UnitHealth(unit) <= 0) then
		TipBuddy.gtt_classlvlcolor = tbcolor_corpse;
		TipBuddy.gtt_classcorpse = " "..tb_translate_corpse;
	end
	local targettype = TipBuddy_SavedVars[type];
	if ( UnitPlayerControlled(unit) or UnitRace(unit)) then
		if (targettype.rac == 1 and UnitRace(unit) ~= nil) then
			TipBuddy.gtt_race = (tbcolor_race..UnitRace(unit).." ");
		else
			TipBuddy.gtt_race = "";
		end

		--coloring class text
		if (UnitClass(unit) == tb_translate_mage) then
			TipBuddy.gtt_classcolor = tbcolor_cls_mage;
		elseif (UnitClass(unit) == tb_translate_warlock) then
			TipBuddy.gtt_classcolor = tbcolor_cls_warlock;
		elseif (UnitClass(unit) == tb_translate_priest) then
			TipBuddy.gtt_classcolor = tbcolor_cls_priest;
		elseif (UnitClass(unit) == tb_translate_druid) then
			TipBuddy.gtt_classcolor = tbcolor_cls_druid;
		elseif (UnitClass(unit) == tb_translate_shaman) then
			TipBuddy.gtt_classcolor = tbcolor_cls_shaman;
		elseif (UnitClass(unit) == tb_translate_paladin) then
			TipBuddy.gtt_classcolor = tbcolor_cls_paladin;
		elseif (UnitClass(unit) == tb_translate_rogue) then
			TipBuddy.gtt_classcolor = tbcolor_cls_rogue;
		elseif (UnitClass(unit) == tb_translate_hunter) then
			TipBuddy.gtt_classcolor = tbcolor_cls_hunter;
		elseif (UnitClass(unit) == tb_translate_warrior) then
			TipBuddy.gtt_classcolor = tbcolor_cls_warrior;
		else
			TipBuddy.gtt_classcolor = tbcolor_cls_other;
		end
	end
	if (TipBuddy.refresh == 1) then
		return;	
	end
	--/script TB_AddMessage(UnitCreatureFamily("mouseover"));
	if ( TipBuddy_TargetInfo_CheckPet() ) then
		TipBuddy.gtt_race = "";
		if (UnitCreatureFamily(unit)) then
			TipBuddy.gtt_class = UnitCreatureFamily(unit);
			return;
		else
			TipBuddy.gtt_class = "";
		end
		return;
	end

	--TB_AddMessage("Get Class - "..unit);
--	/script TB_AddMessage(UnitCreatureType(unit));
	if ( UnitPlayerControlled(unit) or UnitRace(unit)) then
		TipBuddy.gtt_class = UnitClass(unit);
	elseif ( UnitCreatureFamily(unit) ) then
		TipBuddy.gtt_class = UnitCreatureFamily(unit);
	else
		if ( UnitCreatureType(unit) == tb_translate_notspecified) then
			TipBuddy.gtt_class = tb_translate_creature;
		else
			TipBuddy.gtt_class = UnitCreatureType(unit);
		end
	end
end

function TipBuddy_ShowRank( type, unit )
	--TB_AddMessage("TipBuddy_ShowRank");
	TipBuddy_RankFrameGTT:Hide();
	TipBuddy_RankFrame:Hide();

	if (not type or not unit or ( TipBuddy_SavedVars[type].rnk == 0 )) then
		return;				
	end

	local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank(unit));
	local rankFrame, srankFrame;
	if ( TipBuddy_SavedVars[type].off == 0 ) then
		rankFrame = getglobal("TipBuddy_RankFrameGTT");
		srankFrame = "TipBuddy_RankFrameGTT";
	else
		rankFrame = getglobal("TipBuddy_RankFrame");
		srankFrame = "TipBuddy_RankFrame";
	end
	local rankFrameIcon = getglobal(srankFrame.."Icon");
	
	-- /script DEFAULT_CHAT_FRAME:AddMessage(UnitPVPRank("target"));
	if (not UnitPlayerControlled(unit) or rankNumber == 0) then
		rankFrame:Hide();
		return;	
	end
	-- Set icon
	if ( rankNumber > 0 ) then
		rankFrameIcon:SetTexture(format("%s%02d","Interface\\PvPRankBadges\\PvPRank",rankNumber));
		rankFrame:Show();	
	else
		rankFrame:Hide();
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PET
--------------------------------------------------------------------------------------------------------------------------------------
--[[
UNITNAME_TITLE_CHARM = "%s's Minion"; -- %s is the name of the unit's charmer
UNITNAME_TITLE_CREATION = "%s's Creation";
UNITNAME_TITLE_GUARDIAN = "%s's Guardian";
UNITNAME_TITLE_MINION = "%s's Minion";
UNITNAME_TITLE_PET = "%s's Pet"; -- %s is the name of the unit's summoner
]]--
function TipBuddy_TargetInfo_CheckPet() 
	for i=1, (GameTooltip:NumLines()), 1 do
		local tipstring = getglobal("GameTooltipTextLeft"..i);
		if (not tipstring or not tipstring:GetText()) then
			return;
		end
		if ( string.find(tipstring:GetText(), tb_translate_minion) ) then
			return 1;
		end
		if ( string.find(tipstring:GetText(), tb_translate_creation) ) then
			return 1;
		end
		if ( string.find(tipstring:GetText(), tb_translate_guardian) ) then
			return 1;
		end
		if ( string.find(tipstring:GetText(), tb_translate_pet) ) then
			return 1;
		end
	end
	return;
end

--------------------------------------------------------------------------------------------------------------------------------------
-- CHECK CIVILIAN
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_CheckCivilian( unit ) 
	if (UnitPlayerControlled(unit)) then
		return;
	end
	for i=1, (GameTooltip:NumLines()), 1 do
		local tipstring = getglobal("GameTooltipTextLeft"..i);
		if (not tipstring or not tipstring:GetText()) then
			return;
		end
		if ( string.find(tipstring:GetText(), tb_translate_civilian) ) then
			TipBuddy.gtt_lastline = i;
			return 1;
		end
	end
	return;
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET GUILD
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_GetGuild( type, unit )
	if (not unit or not type) then
		return;	
	end
	if (TipBuddy.refresh == 1) then
		TB_AddMessage("REFRESH == 1");
		if (TipBuddy.gtt_guild == "" or TipBuddy.gtt_guild == nil) then
			return;	
		end
	end
	TipBuddy.gtt_guildcolor = "";
	if (GetGuildInfo("player") and GetGuildInfo(unit) == GetGuildInfo("player")) then
		TipBuddy.gtt_guildcolor = tbcolor_gld_mate;
	elseif ( UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) ) then
		TipBuddy.gtt_guildcolor = (tbcolor_gld_tappedother);
	elseif (UnitIsTappedByPlayer(unit)) then
		TipBuddy.gtt_guildcolor = (tbcolor_gld_tappedplayer);
	elseif (TipBuddy.reaction) then
		TipBuddy.gtt_guildcolor = getglobal("tbcolor_gld_"..TipBuddy.reaction);
	else
		TipBuddy.gtt_guildcolor = tbcolor_unknown;
	end
	if (TipBuddy.refresh == 1) then
		return;	
	end
	--/script GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);GameTooltip:SetUnit("partypet1"); TB_AddMessage(GameTooltipTextLeft2:GetText());
	local targettype = TipBuddy_SavedVars[type];
	if (unit == "party1" or unit == "partypet1" or unit == "party2" or unit == "partypet2" or unit == "party3" or unit == "partypet3" or unit == "party4" or unit == "partypet4" or unit == "party5" or unit == "partypet5" ) then
		if ( GetGuildInfo(unit) ) then
			TipBuddy.gtt_guild = (GetGuildInfo(unit));
			--TB_AddMessage(GetGuildInfo(unit));
		end
		if (not TipBuddy.gtt_guild) then
			TipBuddy.gtt_guild = "";	
		end
		return;
	elseif (UnitPlayerControlled(unit) or (GameTooltipTextLeft2:GetText() and string.find(GameTooltipTextLeft2:GetText(), tb_translate_player ) ) ) then
		if ( TipBuddy_TargetInfo_CheckPet() ) then
			TipBuddy.gtt_guild = (GameTooltipTextLeft2:GetText());
			--TB_AddMessage("player pet guild: "..TipBuddy.gtt_guild);
			return;
		elseif ( GetGuildInfo(unit) ) then
			TipBuddy.gtt_guild = (GetGuildInfo(unit));
			--TB_AddMessage("player guild: "..TipBuddy.gtt_guild);
		end
		return;
	else
		--TB_AddMessage("GUILD: npc, testing...");
		if (not GameTooltipTextLeft2:GetText()) then
			--TB_AddMessage("GUILD: npc, line 2 is blank");
			return;	
		end
		if ( TipBuddy_TargetInfo_CheckPet() ) then
			TipBuddy.gtt_guild = (GameTooltipTextLeft2:GetText());
			--TB_AddMessage("pet guild: "..TipBuddy.gtt_guild);
			return;
		end		
		if (string.find(GameTooltipTextLeft2:GetText(), tb_translate_level ) ) then
			--TB_AddMessage("GUILD: npc, line 2 is level");
			return;
		else
			TipBuddy.gtt_guild = (GameTooltipTextLeft2:GetText());
			--TB_AddMessage("title guild: "..TipBuddy.gtt_guild);
		end
	end

end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET/COLOR NAME
--------------------------------------------------------------------------------------------------------------------------------------

function TipBuddy_TargetInfo_CheckName( type, unit )

	TipBuddy.gtt_namecolor = "";
	if (not type or not unit) then
		TipBuddy.gtt_namecolor = tbcolor_unknown;
		if (UnitName(unit)) then
			TipBuddy.gtt_name = UnitName(unit);
		else
			TipBuddy.gtt_name = "";
		end
		return;	
	end
	local targettype = TipBuddy_SavedVars[type];
	if (UnitHealth(unit) <= 0) then
		TipBuddy.gtt_namecolor = tbcolor_corpse;	
	elseif (TipBuddy.reaction) then
		TipBuddy.gtt_namecolor = getglobal("tbcolor_nam_"..TipBuddy.reaction);
	elseif ( UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) ) then
		TipBuddy.gtt_namecolor = (tbcolor_nam_tappedother.." >");
	elseif (UnitIsTappedByPlayer(unit)) then
		TipBuddy.gtt_namecolor = (tbcolor_nam_tappedplayer);
	else
		TipBuddy.gtt_namecolor = tbcolor_unknown;
	end
	
	if (TipBuddy.refresh == 1 and TipBuddy.gtt_name ~= nil) then
		return;
	end

	if (not UnitPlayerControlled(unit)) then
		if (UnitName(unit)) then
			TipBuddy.gtt_name = UnitName(unit);
		else
			TipBuddy.gtt_name = "";
		end
	elseif (TipBuddy_SavedVars["general"].rankname == 1) then
		if (unit == "player" or unit == "mouseover" or unit == "target" ) then
			TipBuddy.gtt_name = UnitPVPName(unit);
		else
			if (getglobal("GameTooltipTextLeft1"):GetText()) then
				TipBuddy.gtt_name = getglobal("GameTooltipTextLeft1"):GetText();
			else
				if (UnitName(unit)) then
					TipBuddy.gtt_name = UnitName(unit);
				else
					TipBuddy.gtt_name = "";
				end
			end	 
		end
	else
		if (UnitName(unit)) then
			TipBuddy.gtt_name = UnitName(unit);
		else
			TipBuddy.gtt_name = "";
		end
	end

	if (not TipBuddy.gtt_name or TipBuddy.gtt_name == "") then
		TipBuddy.gtt_name = tb_translate_notspecified;	
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET TARGET's TARGET
--------------------------------------------------------------------------------------------------------------------------------------

function TipBuddy_TargetInfo_TargetsTarget( type, unit )
	if (not TipBuddy.gtt_target) then
		TipBuddy.gtt_target = "";	
	end
	if (TipBuddy_SavedVars[type].trg == 0) then
		TB_AddMessage("TT for "..type.." is turned off");
		return;	
	end
	local tunit = unit.."target";
	if (UnitName(tunit)) then
		local treaction = TipBuddy_GetUnitReaction( tunit );
		local tcolor = "";
		if (UnitName(tunit) == UnitName("player")) then
			tcolor = TB_WHT_TXT;
			TipBuddy.gtt_target = tcolor.." : [YOU]";
			TB_AddMessage("target = "..tcolor.." [YOU]");
			return;
		elseif (UnitName(tunit) == UnitInParty(tunit)) then
			if (TipBuddy_SavedVars[type].trg_pa == 0) then
				return;
			else
				tcolor = TB_PNK_TXT;
			end
		elseif (UnitHealth(tunit) <= 0) then
			tcolor = TB_DGY_TXT;	
		--elseif (treaction) then
		elseif ( UnitPlayerControlled(tunit) ) then
		--[[
TB_NML_TXT = "|cffffd200"
TB_WHT_TXT = "|cffffffff"
TB_GRY_TXT = "|cffC0C0C0"
TB_DGY_TXT = "|cff585858"
TB_RED_TXT = "|cffff2020"
TB_GRN_TXT = "|cff20ff20"
TB_YLW_TXT = "|cffffff00"
TB_BLE_TXT = "|cff3366ff"
TB_PNK_TXT = "|cffff00ff"
TB_DBL_TXT = "|cff3399ff"
TB_DGN_TXT = "|cff339900"
TB_DRD_TXT = "|cffcc0000"
]]
			if ( UnitCanAttack(tunit, "player") or UnitCanAttack("player", tunit) ) then
				if (TipBuddy_SavedVars[type].trg_en == 0) then
					return;
				else
					tcolor = TB_RED_TXT;
				end
				--return "hostile";
			else
				-- All other players are green
				if (TipBuddy_SavedVars[type].trg_pl == 0) then
					return;
				else
					tcolor = TB_GRN_TXT;	
					--return "friendly";
				end
			end
		elseif ( UnitIsEnemy(tunit, "player") ) then
			if (TipBuddy_SavedVars[type].trg_en == 0) then
				return;
			else
				tcolor = TB_RED_TXT;	
				--return "pvp";
			end
		else
			if (TipBuddy_SavedVars[type].trg_np == 0) then
				return;
			else
				tcolor = TB_BLE_TXT;
			end
		end
		--TipBuddy.gtt_target = tcolor.."  ["..TB_WHT_TXT..UnitName(unit.."target")..tcolor.."]";
		TipBuddy.gtt_target = TB_WHT_TXT.." : "..tcolor.."["..UnitName(unit.."target").."]";
		TB_AddMessage("target = "..tcolor.."["..UnitName(unit.."target").."]");
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET/SHOW CITY FACTION
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_ShowCityFaction( type, unit )
	if (UnitPlayerControlled(unit) or unit == "player" or unit == "party1" or unit == "partypet1" or unit == "party2" or unit == "partypet2" or unit == "party3" or unit == "partypet3" or unit == "party4" or unit == "partypet4" or unit == "party5" or unit == "partypet5" ) then
		--TB_AddMessage("CityFac: found a player");
		return;
	end
	local line;
	for i=1, (GameTooltip:NumLines()), 1 do
		local tipline = getglobal("GameTooltipTextLeft"..i);
		if (not tipline or not tipline:GetText()) then
			TB_AddMessage("tipline: "..i.." is empty");
			return;	
		end
		if ( string.find(tipline:GetText(), tb_translate_level..".+") or string.find(tipline:GetText(), TipBuddy.gtt_level..".+") ) then
			line = getglobal("GameTooltipTextLeft"..(i + 1));
			if (line:GetText() == "\n" or line:GetText() == nil) then
				TB_AddMessage("Line after Level is empty");
				break;
			end

			if (type == "corpse") then
				--TB_AddMessage("CityFac: found corpse");
				break;
			elseif (string.find(line:GetText(), tb_translate_pvp) or line:GetText() == nil or string.find(line:GetText(), tb_translate_civilian)) then
				TB_AddMessage("CityFac: found PvP or something");
				break;
			else
				TB_AddMessage("found cityfac: ("..line:GetText()..")  Line: "..(i+1));
				TipBuddy.gtt_lastline = i+1;
				TipBuddy.gtt_cityfac = line:GetText();
				break;				
			end				
		end	
	end
end

function TipBuddy_ConfirmLastLine(unit)
	local line;
	for i=TipBuddy.gtt_numlines, 1, -1 do
		line = getglobal("GameTooltipTextLeft"..i);
		if (not line or not line:GetText()) then
			return;	
		end
		--TB_AddMessage("LASTLINE: i = "..i..", text: "..line:GetText());
		if (string.find(line:GetText(), tb_translate_pvp) 
		or string.find(line:GetText(), tb_translate_civilian) 
		or string.find(line:GetText(), tb_translate_level ) 
		or (TipBuddy.gtt_cityfac ~= "" and string.find(line:GetText(), TipBuddy.gtt_cityfac ) ) ) then
			if (i > TipBuddy.gtt_lastline) then
				TipBuddy.gtt_lastline = i;
				--TB_AddMessage("i>LL: "..TipBuddy.gtt_lastline);
				break;
			else
				--TB_AddMessage("i!>LL: "..TipBuddy.gtt_lastline);
				break;
			end
		end
	end
end

function TipBuddy_GTT_GetExtraLines( numlines )
	--TB_AddMessage("getting extra lines");
	TipBuddy.gtt_xtra = {};
	TipBuddy.gtt_xtraR = {};
	if (numlines > TipBuddy.gtt_lastline) then
		--TB_AddMessage("numlines > TipBuddy.gtt_lastline");
		local line;
		local j = 1;
		for i=TipBuddy.gtt_lastline + 1, numlines, 1 do
			line = getglobal("GameTooltipTextLeft"..i);
			lineR = getglobal("GameTooltipTextRight"..i);
			if (not line or not line:GetText() or string.find(line:GetText(), tb_translate_pvp)) then
				return;
			end
			TipBuddy.gtt_xtra[j] = line:GetText();
			if (lineR:GetText()) then
				TipBuddy.gtt_xtraR[j] = lineR:GetText();
			else
				TipBuddy.gtt_xtraR[j] = "";
			end
			--TB_AddMessage(line:GetText());
			j = j + 1;
		end		
	else
		return;
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH TEXT
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_UpdateHealthText( frame, type, unit )
	if (TipBuddy_SavedVars[type].txt_hth == 0) then
		frame:Hide();
		return;	
	end
	--TipBuddy_HealthTextGTT, TipBuddy_UpdateHealthTextGTT( TipBuddy_HealthTextGTT, unit )
	--TipBuddy_HealthText
	local health = UnitHealth(unit);
	--local percent = tonumber(format("%.0f", ( (health / UnitHealthMax(unit)) * 100 ) ));
	local text = getglobal(frame:GetName().."Text");
	if ( unit == "player" or UnitInParty(unit) or UnitInRaid(unit)) then
		text:SetText( health.." / "..UnitHealthMax(unit) );	
	else
		if (MobHealthDB) then
			local ppp = MobHealth_PPP(UnitName(unit)..":"..UnitLevel(unit));
			local curHP = math.floor(health * ppp + 0.5);
			local maxHP = math.floor(100 * ppp + 0.5);

			if (curHP and maxHP and maxHP ~= 0) then
				text:SetText( curHP.." / "..maxHP );
				TB_AddMessage(curHP.." / "..maxHP);
			else
				text:SetText( health.."%" );
			end
		else
			text:SetText( health.."%" );
		end
	end
	frame:Show();
end

function TipBuddy_UpdateManaText( frame, type, unit )
	frame:Hide();
	if (not unit or TipBuddy_SavedVars[type].txt_mna == 0) then
		return;
	end
	--local percent = (UnitMana(unit) / UnitManaMax(unit)) * 100;
	--local mana = UnitMana(unit);
	local text = getglobal(frame:GetName().."Text");
	if (UnitMana(unit) and UnitMana(unit) > 0) then
		frame:Show();
		text:SetText( UnitMana(unit).." / "..UnitManaMax(unit) );	
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET EXTRAS
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_FindExtrasStart(unit)
	if (TipBuddy_Xtra_Frame:IsVisible() and TipBuddy.gtt_name == UnitName(unit)) then
		--TB_AddMessage("XTRA - returning");
		return;	
	end
	--TB_AddMessage("FIND_START");
	TipBuddy_Main_Frame.xtraStart = GetTime();
	TipBuddy_Main_Frame.xtraEnd = (TipBuddy_Main_Frame.xtraStart + 0.01);
	TipBuddy_Main_Frame.xtraTimer = 1;
	for i=1, 10, 1 do
		lineL = getglobal("TipBuddy_Xtra"..i.."_Text");
		lineL:SetText("");
		lineL:Hide();					
	end
end


function TipBuddy_TargetInfo_FindExtras()
	TipBuddy_GTT_GetExtraLines(10);	
	TipBuddy_TargetInfo_ShowExtras();
end

function TipBuddy_TargetInfo_ShowExtras()
	TB_AddMessage("SHOWING_EXTRAS");
	if (TipBuddy.gtt_xtra) then
		local lineL;
		for i=1, table.getn(TipBuddy.gtt_xtra), 1 do
			lineL = getglobal("TipBuddy_Xtra"..i.."_Text");
			TB_AddMessage(TipBuddy.gtt_xtra[i])
			lineL:SetText(TipBuddy.gtt_xtra[i]);
			TipBuddy_Xtra_Frame:Show();
			lineL:Show();					
		end
	end
	TipBuddy_Xtras_FrameSize();
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GET/SHOW FACTION
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_TargetInfo_ShowFaction( type, unit )
	TipBuddy_FactionFrameGTT:Hide();
	TipBuddy_FactionFrame:Hide();
	if (not unit) then
		return;
	end

	local factionGroup = UnitFactionGroup(unit);
	if (not factionGroup) then
		return;
	end

	local frame, sframe;
	if ( TipBuddy_SavedVars[TipBuddy.targetType].off == 0 ) then
		frame = getglobal("TipBuddy_FactionFrameGTT");
		sframe = "TipBuddy_FactionFrameGTT";
	else
		frame = getglobal("TipBuddy_FactionFrame");
		sframe = "TipBuddy_FactionFrame";
	end
	local frameIcon = getglobal(sframe.."Icon");
	local frameText = getglobal(sframe.."Text");
	--how in the world does this happen?

	if ( UnitIsPVPFreeForAll(unit) ) then
		frameIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		frame:Show();
		if (TipBuddy_SavedVars[TipBuddy.targetType].txt_pvp == 1) then
			frameIcon:Hide();
			frameText:Show();
			frameText:SetText("FFA");
		else
			frameIcon:Show();
			frameText:Hide();			
		end
	elseif ( UnitIsPVP(unit) ) then
		TB_AddMessage("txt_pvp = "..TipBuddy_SavedVars[TipBuddy.targetType].txt_pvp);
		frameIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		frame:Show();
		if (TipBuddy_SavedVars[TipBuddy.targetType].txt_pvp == 1) then
			frameIcon:Hide();
			frameText:Show();
			frameText:SetText("PvP");
		else
			frameIcon:Show();
			frameText:Hide();			
		end
	else
		frame:Hide();
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- SET BACKGROUND COLOR
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_SetFrame_BackgroundColor( type, unit )
	if (not unit or not type) then
		GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
		return;
	end
	local targettype = TipBuddy_SavedVars["general"];
	local r, g, b;
	if (targettype.diff_bg == 1) then
	--[[
	tbcolor_lvl_impossible =		TipBuddy_RGBToHexColor(colors.lvl_imp.r, colors.lvl_imp.g, colors.lvl_imp.b);
	tbcolor_lvl_verydifficult =		TipBuddy_RGBToHexColor(colors.lvl_vdf.r, colors.lvl_vdf.g, colors.lvl_vdf.b);
	tbcolor_lvl_difficult =			TipBuddy_RGBToHexColor(colors.lvl_dif.r, colors.lvl_dif.g, colors.lvl_dif.b);
	tbcolor_lvl_standard =			TipBuddy_RGBToHexColor(colors.lvl_stn.r, colors.lvl_stn.g, colors.lvl_stn.b);
	tbcolor_lvl_trivial =			TipBuddy_RGBToHexColor(colors.lvl_trv.r, colors.lvl_trv.g, colors.lvl_trv.b);
	]]		
		local levelDiff = UnitLevel("mouseover") - UnitLevel("player");
		local colors = TipBuddy_SavedVars["textcolors"];
		if ( levelDiff >= 5 ) then
			r, g, b = colors.lvl_imp.r, colors.lvl_imp.g, colors.lvl_imp.b; 
		elseif ( levelDiff >= 3 ) then
			r, g, b = colors.lvl_vdf.r, colors.lvl_vdf.g, colors.lvl_vdf.b; 
		elseif ( levelDiff >= -2 ) then
			r, g, b = colors.lvl_dif.r, colors.lvl_dif.g, colors.lvl_dif.b; 
		elseif ( -levelDiff <= GetQuestGreenRange() ) then
			r, g, b = colors.lvl_stn.r, colors.lvl_stn.g, colors.lvl_stn.b; 
		else
			r, g, b = colors.lvl_trv.r, colors.lvl_trv.g, colors.lvl_trv.b; 
		end
		r, g, b = TB_NoNegative(r - 0.4), TB_NoNegative(g - 0.4), TB_NoNegative(b - 0.4); 
	else
		if (GetGuildInfo("player")) then
			if ( GetGuildInfo(unit) == GetGuildInfo("player") ) then
				type = "guild";
			end		
		end

		targettype = TipBuddy_SavedVars[type];
		r, g, b = targettype.bgcolor.r, targettype.bgcolor.g, targettype.bgcolor.b; 	
	end

	TipBuddy_Main_Frame:SetBackdropColor( r, g, b );

	if (TipBuddy_SavedVars["general"].blizdefault == 1) then
		GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);		
	else
		GameTooltip:SetBackdropColor( r, g, b );
	end
	TB_AddMessage(r.." - "..g.." - "..b);
end

--------------------------------------------------------------------------------------------------------------------------------------
-- VISIBILITY
--------------------------------------------------------------------------------------------------------------------------------------
-- Target Types are:
-- pc_friend
-- pc_party
-- pc_enemy
-- npc_friend
-- npc_neutral
-- npc_enemy
-- pet_friend
-- pet_enemy

function TipBuddy_CheckValid_TargetType( type, unit )
	if (not type) then
		TB_AddMessage("BUG! NO TYPE FOUND!");
		return 1;
	end

	local targettype = TipBuddy_SavedVars[type];
	
	if (not TipBuddy_SavedVars[type]) then
		TB_AddMessage("BUG! NO SAVED VARS FOR: "..type);
		TipBuddy_SetFrame_BackgroundColor( "corpse", unit );
		return 1;			
	end
end

function TipBuddy_SetFrame_Visibility( type, unit, refresh )
	if (not unit) then
		return;	
	end

	if (TipBuddy_CheckValid_TargetType( type, unit )) then
		return 1;	
	end

	local targettype = TipBuddy_SavedVars[type];

	if ( targettype.off == 0 ) then
		TipBuddy_ForceHide( TipBuddy_Main_Frame );
		--/script TipBuddy_SavedVars["general"].blizdefault = 1;
		if (TipBuddy_SavedVars["general"].blizdefault == 1) then
			return;
		else
			TipBuddy_SetFrame_TargetType( type, unit, refresh );
		end
	else
		GameTooltip:Hide();
		--This sets the tooltip back to its default state (Don't use this anymore)
		--TB_AddMessage("*********");
		--if (targettype.off == 1 and type ~= "corpse" ) then
			--GameTooltip:SetUnit(unit);	
			--TB_AddMessage("---setting unit: "..unit);
		--end

		TipBuddy_ForceHide(TipBuddy_Main_Frame);
		TipBuddy_Main_Frame:Show();
		TipBuddy_Main_Frame:SetAlpha(1);
		TipBuddy_SetFrame_TargetType( type, unit, refresh );
	end
end

function TipBuddy_SetFrame_TargetType( type, unit, refresh )
	if (not unit 
	--or TipBuddy.unitname == getglobal("GameTooltipTextLeft1"):GetText() 
	or not UnitExists(unit)) then
		return;	
	end
	--TB_AddMessage(unit);
	TipBuddy.uiScale = TipBuddy_GetUIScale();
	TipBuddy.xpoint, TipBuddy.xpos, TipBuddy.ypos = TipBuddy_GetFrameCursorOffset();
	TipBuddy.anchor, TipBuddy.fanchor, TipBuddy.offset = TipBuddy_GetFrameAnchorPos();			

	TipBuddy.reaction = TipBuddy_GetUnitReaction( unit );

	local targettype = TipBuddy_SavedVars[type];

	--/script TipBuddy.uiScale = TipBuddy_GetUIScale();TipBuddy.xpoint, TipBuddy.xpos, TipBuddy.ypos = TipBuddy_GetFrameCursorOffset();TipBuddy.anchor, TipBuddy.fanchor, TipBuddy.offset = TipBuddy_GetFrameAnchorPos();GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);GameTooltip:SetUnit(PlayerFrame.unit); TB_AddMessage(PlayerFrame.unit);
	if (TipBuddy_SavedVars.debug == 1 and TipBuddy.unitname) then
		TB_AddMessage(TipBuddy.unitname.." == TT: "..GameTooltipTextLeft1:GetText());	
	end

	--if (TipBuddy.unitname ~= nil and getglobal("GameTooltipTextLeft1"):GetText() ~= nil and
	--string.find(getglobal("GameTooltipTextLeft1"):GetText(), TipBuddy.gtt_name)) then
	if (refresh) then
		--TB_AddMessage("!! lastline: "..TipBuddy.gtt_lastline..", numlines (stored): "..TipBuddy.gtt_numlines..", numlines (real): "..GameTooltip:NumLines());
		TipBuddy.refresh = 1;
		TB_AddMessage("!! REFRESH");
	else
		TB_AddMessage("CLEARING ALL DATA");
		TipBuddy.refresh = nil;
		TipBuddy.gtt_numlines = GameTooltip:NumLines();
		TipBuddy.gtt_lastline = 1;
		TipBuddy.gtt_xtra = nil;
		TipBuddy.gtt_name = "";
		TipBuddy.gtt_target = "";
		TipBuddy.gtt_guild = "";
		TipBuddy.gtt_level = "";
		TipBuddy.gtt_race = "";
		TipBuddy.gtt_class = "";
		TipBuddy.gtt_cityfac = "";
		--TB_AddMessage("!! lastline: "..TipBuddy.gtt_lastline..", numlines (stored): "..TipBuddy.gtt_numlines..", numlines (real): "..GameTooltip:NumLines());
	end

	if (not TipBuddy.gtt_numlines) then
		TipBuddy.gtt_numlines = 0;	
	end

	TipBuddy_TargetInfo_CheckName( type, unit );
	TipBuddy_TargetInfo_TargetsTarget( type, unit );
	TipBuddy_TargetInfo_GetGuild( type, unit );
	TipBuddy_TargetInfo_GetClass( type, unit );
	TipBuddy_TargetInfo_GetLevel( type, unit );
	if (TipBuddy.refresh ~= 1) then
		TipBuddy_TargetInfo_ShowCityFaction( type, unit );
		TipBuddy.gtt_civ = TipBuddy_TargetInfo_CheckCivilian( unit );
		TipBuddy_ConfirmLastLine(unit);
		if ( targettype.off == 0 ) then
			TipBuddy_GTT_GetExtraLines(TipBuddy.gtt_numlines);
		end
		TipBuddy_Xtra_Frame:Hide();
	end

	TipBuddy.unitname = (TipBuddy.gtt_namecolor..TipBuddy.gtt_name..TipBuddy.gtt_target);

	if ( targettype.off == 1 ) then
		TipBuddy_TargetName_Text:SetText(TipBuddy.gtt_namecolor..TipBuddy.gtt_name..TipBuddy.gtt_target);
		TipBuddy_TargetName_Text:Show();

		if ( targettype.gld == 1 ) then
			if (TipBuddy.gtt_guildcolor and TipBuddy.gtt_guild and TipBuddy.gtt_guild ~= "" ) then
				--TB_AddMessage(TB_RED_TXT.."Guild text = "..TB_YLW_TXT..TipBuddy.gtt_guild);
				TipBuddy_TargetGuild_Text:SetText(TipBuddy.gtt_guildcolor.."<"..TipBuddy.gtt_guild..TipBuddy.gtt_guildcolor..">");
				TipBuddy_TargetGuild_Text:Show();				
			else
				TipBuddy_TargetGuild_Text:Hide();
			end
		else
			TipBuddy_TargetGuild_Text:Hide();
		end
		if ( targettype.cls == 1 ) then
			if (TipBuddy.gtt_class == "" and TipBuddy.gtt_level == "") then
				TipBuddy_TargetClass_Text:Hide();
				TipBuddy_TargetLevel_Text:Hide();				
			elseif (TipBuddy.gtt_class and TipBuddy.gtt_class ~= "" ) then
				TipBuddy_TargetClass_Text:SetText(TipBuddy.gtt_race..TipBuddy.gtt_classcolor..TipBuddy.gtt_classlvlcolor..TipBuddy.gtt_class..TipBuddy.gtt_classcorpse);		
				TipBuddy_TargetClass_Text:Show();			
			else
				TipBuddy_TargetClass_Text:Hide();
				TipBuddy_TargetLevel_Text:Hide();			
			end

			TipBuddy_TargetLevel_Text:Show();
		else
			TipBuddy_TargetClass_Text:Hide();
			TipBuddy_TargetLevel_Text:Hide();
		end
		if ( targettype.hth == 1 ) then
			if (TipBuddy_TargetGuild_Text:IsVisible()) then
				TipBuddy_TargetFrameHealthBar:SetPoint("TOPLEFT", "TipBuddy_TargetGuild_Text", "BOTTOMLEFT", 2, -3);
			else
				TipBuddy_TargetFrameHealthBar:SetPoint("TOPLEFT", "TipBuddy_TargetName_Text", "BOTTOMLEFT", 2, -3);
			end
			TipBuddy_TargetFrameHealthBar:Show();
			--TB_AddMessage(unit);
			if (UnitMana( unit ) > 0) then
				TipBuddy_TargetFrameManaBar:Show();
			else
				TipBuddy_TargetFrameManaBar:Hide();
			end
			TipBuddy_UnitFrame_UpdateHealth( unit );
			TipBuddy_UnitFrame_UpdateMana( unit );
			TipBuddy_UpdateHealthText( TipBuddy_HealthText, type, unit );
			TipBuddy_UpdateManaText( TipBuddy_ManaText, type, unit );
		else
			TipBuddy_TargetFrameHealthBar:Hide();
			TipBuddy_TargetFrameManaBar:Hide();
		end
		if ( targettype.cfc == 1 and TipBuddy.gtt_cityfac ~= "" ) then
			TipBuddy_TargetCityFac_Text:SetText(tbcolor_cityfac..TipBuddy.gtt_cityfac);
			TipBuddy_TargetCityFac_Text:Show();
		else
			TipBuddy_TargetCityFac_Text:Hide();
		end
		if (TipBuddy.gtt_civ == 1) then
			TipBuddy_TargetCivilian_Text:SetText(TB_GRN_TXT..tb_translate_civilian.." |r");
			TipBuddy_TargetCivilian_Text:Show();
		else
			TipBuddy_TargetCivilian_Text:Hide();
		end
		
		TipBuddy_FrameHeights_Initialize();
		TipBuddy_SetFrame_Width();
		if (TipBuddy.refresh ~= 1 and targettype.xtr == 1) then
			TipBuddy_TargetInfo_FindExtrasStart(unit);
		end
	else
		--/script TB_AddMessage(GameTooltipTextLeft1:GetHeight());
		--if (TipBuddy_SavedVars.debug == 1) then
		--	for i=1, 12, 1 do
		--		if (getglobal("GameTooltipTextLeft"..i):GetText()) then
		--			TB_AddMessage(TB_WHT_TXT..getglobal("GameTooltipTextLeft"..i):GetText())
		--		else
		--			TB_AddMessage(TB_BLE_TXT..i..": no")
		--		end			
		--	end			
		--end

		if (TipBuddy.refresh ~= 1) then
			if (targettype.adv and targettype.adv == 1) then
				GameTooltip:SetText(" ");
			else
				for i=2, TipBuddy.gtt_numlines, 1 do
					local line = getglobal("GameTooltipTextLeft"..i);
					--local liner = getglobal("GameTooltipTextRight"..i);
					line:SetText("");
					line:Hide();
					--liner:SetText("");
					--liner:Hide();
				end
			end
		end
		
		--/script TB_AddMessage(getglobal("GameTooltipTextLeft2"):GetText());

		local tipnum = 2;
		local tip = getglobal("GameTooltipTextLeft"..tipnum);

		--/script TipBuddy_SavedVars.npc_friend.adv = 1
		if (targettype.adv and targettype.adv == 1) then
			GameTooltip.variables = {};
			local ebtext = targettype.ebx;
			for variable, value in TB_VARIABLE_FUNCTIONS do
				if (string.find(ebtext, variable)) then
					GameTooltip.variables[variable] = true;			
				end
			end
			
			local maxchar = 1024;
			if ((not ebtext) or ebtext == "") then return; end

				for var in GameTooltip.variables do
					ebtext = TB_VARIABLE_FUNCTIONS[var].func(ebtext, unit);
				end
			if (not ebtext) then ebtext = ""; end
			if (maxchar and string.len(ebtext) > maxchar) then
				text = string.sub(ebtext, 1, maxchar);
			end
			GameTooltipTextLeft1:SetText(ebtext.."\n");
		else

			GameTooltipTextLeft1:SetText(TipBuddy.gtt_namecolor..TipBuddy.gtt_name..TipBuddy.gtt_target);

			if ( targettype.gld == 1 and TipBuddy.gtt_guild and TipBuddy.gtt_guild ~= "" ) then
				if (TipBuddy.gtt_guild == nil) then
					return;	
				end
				tip = getglobal("GameTooltipTextLeft"..tipnum);
				if (tipnum > TipBuddy.gtt_numlines) then
					GameTooltip:AddLine(TipBuddy.gtt_guildcolor.."<"..TipBuddy.gtt_guild..TipBuddy.gtt_guildcolor..">".."|r");
				else
					tip:SetText(TipBuddy.gtt_guildcolor.."<"..TipBuddy.gtt_guild..TipBuddy.gtt_guildcolor..">".."|r");
				end
				tip:Show();
				tipnum = tipnum + 1;

			end
			if ( targettype.cls == 1 ) then
				tip = getglobal("GameTooltipTextLeft"..tipnum);
				if (TipBuddy.gtt_class == nil) then
					TipBuddy.gtt_class = "";	
				end
				if (TipBuddy.gtt_class == "" and TipBuddy.gtt_level == "") then
					
				else
					if (tipnum > TipBuddy.gtt_numlines) then
						GameTooltip:AddLine(TipBuddy.gtt_level.."|r  "..TipBuddy.gtt_race..TipBuddy.gtt_classcolor..TipBuddy.gtt_classlvlcolor..TipBuddy.gtt_class..TipBuddy.gtt_classcorpse.."|r");
					else
						tip:SetText(TipBuddy.gtt_level.."|r  "..TipBuddy.gtt_race..TipBuddy.gtt_classcolor..TipBuddy.gtt_classlvlcolor..TipBuddy.gtt_class..TipBuddy.gtt_classcorpse.."|r");
					end				
					tip:Show();
					tipnum = tipnum + 1;
				end

			end
			if ( targettype.cfc == 1 and TipBuddy.gtt_cityfac ~= "" ) then
				tip = getglobal("GameTooltipTextLeft"..tipnum);
				if (tipnum > TipBuddy.gtt_numlines) then
					GameTooltip:AddLine(TipBuddy.gtt_cityfac.."|r");
				else
					tip:SetText(TipBuddy.gtt_cityfac.."|r");	
				end
				tip:Show();
				tipnum = tipnum + 1;

			end
				
			if (TipBuddy.gtt_civ == 1) then
				tip = getglobal("GameTooltipTextLeft"..tipnum);
				if (tipnum > TipBuddy.gtt_numlines) then
					GameTooltip:AddLine(TB_GRN_TXT..tb_translate_civilian.." |r");	
				else
					tip:SetText(TB_GRN_TXT..tb_translate_civilian.." |r");	
				end
				tip:Show();
				tipnum = tipnum + 1;
			end
		end

		if (TipBuddy.gtt_xtra) then
			for i=1, table.getn(TipBuddy.gtt_xtra), 1 do
				tip = getglobal("GameTooltipTextLeft"..tipnum);
				tipR = getglobal("GameTooltipTextRight"..tipnum);
				--TB_AddMessage(TipBuddy.gtt_xtra[i])
				if (tipnum > TipBuddy.gtt_numlines) then
					if (TipBuddy.gtt_xtraR) then
						GameTooltip:AddDoubleLine(TipBuddy.gtt_xtra[i], TipBuddy.gtt_xtraR[i]);
					else
						GameTooltip:AddLine(TipBuddy.gtt_xtra[i]);
					end	
				else
						
					if (TipBuddy.gtt_xtraR) then
						tip:SetText(TipBuddy.gtt_xtra[i]);
						tipR:SetText(TipBuddy.gtt_xtraR[i]);
					else
						tip:SetText(TipBuddy.gtt_xtra[i]);
					end
				end
				tip:Show();
				tipnum = tipnum + 1;				
			end
		end
		
		GameTooltip:Show();
		TipBuddy_UpdateHealthText( TipBuddy_HealthTextGTT, type, unit );
		--TipBuddy_UpdateManaText( TipBuddy_ManaTextGTT, unit );
		TipBuddy.gtt_numlines = tipnum - 1;
		tipnum = nil;
		--TB_AddMessage("TB");
		--[[
		if (TipBuddy_SavedVars.debug == 1) then
			for i=1, 12, 1 do
				if (getglobal("GameTooltipTextLeft"..i):GetText()) then
					TB_AddMessage(TB_WHT_TXT.."!!"..getglobal("GameTooltipTextLeft"..i):GetText())
				else
					TB_AddMessage(TB_BLE_TXT..i..": no")
				end			
			end			
		end]]
		--/script TB_AddMessage(getglobal("GameTooltipTextLeft2"):GetText());
	end
	if ( targettype.fac == 1 ) then
		TipBuddy_TargetInfo_ShowFaction( type, unit );
	else
		TipBuddy_FactionFrame:Hide();
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- GAMETOOLTIP
--------------------------------------------------------------------------------------------------------------------------------------
--hook
local originalGameTooltip_SetDefaultAnchor;
originalGameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;
function GameTooltip_SetDefaultAnchor(tooltip, parent)
	originalGameTooltip_SetDefaultAnchor( tooltip, parent );
	TB_AddMessage("GTT SETANCHOR");
	if (parent) then
		TipBuddy.anchorparent = parent:GetName();
		TB_AddMessage("GTT_PARENT = "..parent:GetName());
	else
		TB_AddMessage("GTT HAS NO PARENT ");
	end

	GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
	if (not TipBuddy.uiScale or not TipBuddy.xpoint or not TipBuddy.anchor) then
		TipBuddy.uiScale = TipBuddy_GetUIScale();
		TipBuddy.xpoint, TipBuddy.xpos, TipBuddy.ypos = TipBuddy_GetFrameCursorOffset();
		TipBuddy.anchor, TipBuddy.fanchor, TipBuddy.offset = TipBuddy_GetFrameAnchorPos();				
	end

	if (UnitExists("mouseover")) then
		if ( TipBuddy_SavedVars["general"].anchored == 1) then
			TB_AddMessage("GTT-ANCHORED = 1");
			tooltip:SetOwner(parent, "ANCHOR_NONE");
			tooltip:SetPoint(TipBuddy.anchor, "TipBuddy_Parent_Frame", TipBuddy.fanchor, 0, TipBuddy.offset);	
			tooltip.default = nil;
		else
			tooltip:SetOwner(parent, "ANCHOR_NONE");
			tooltip:SetPoint(TipBuddy.xpoint, "TipBuddy_Parent_Frame", "CENTER", 0, 0);
			tooltip.default = nil;	
			TB_AddMessage("GTT-ANCHORED = 0");
		end
	else
		if (parent == getglobal("UIParent")) then
			--tooltip:SetOwner(parent, "ANCHOR_CURSOR");
			--tooltip.default = nil;
			if ( TipBuddy_SavedVars["general"].anchored == 1) then
				TB_AddMessage("GTT-ANCHORED = 1");
				tooltip:SetOwner(parent, "ANCHOR_NONE");
				tooltip:SetPoint(TipBuddy.anchor, "TipBuddy_Parent_Frame", TipBuddy.fanchor, 0, TipBuddy.offset);	
				tooltip.default = nil;
			else
				if (TipBuddy_SavedVars["general"].gtt_fade == 1) then
					tooltip:SetOwner(parent, "ANCHOR_NONE");
					tooltip:SetPoint(TipBuddy.xpoint, "TipBuddy_Parent_Frame", "CENTER", 0, 0);
					tooltip.default = nil;	
					TB_AddMessage("GTT-ANCHORED = 0");
				else
					tooltip:SetOwner(parent, "ANCHOR_CURSOR");
					tooltip.default = nil;
				end
			end
		elseif (TipBuddy_SavedVars["general"].nonunit_anchor == 0) then
	--		-- Or to the cursor
			tooltip:SetOwner(parent, "ANCHOR_NONE");
			tooltip:SetPoint(TipBuddy.xpoint, "TipBuddy_Parent_Frame", "CENTER", 0, 0);
			tooltip.default = nil;	
			TB_AddMessage("GTT-NONUNIT_ANCHOR = 0");
		elseif (TipBuddy_SavedVars["general"].nonunit_anchor == 1) then
			tooltip:SetOwner(parent, "ANCHOR_NONE");
			tooltip:SetPoint(TipBuddy.anchor, "TipBuddy_Parent_Frame", TipBuddy.fanchor, 0, TipBuddy.offset);	
			tooltip.default = nil;				
		elseif (TipBuddy_SavedVars["general"].nonunit_anchor == 2) then
			local oanchor, ganchor, panchor = TipBuddy_GetIconAnchorPos(parent);
			tooltip:ClearAllPoints();
			tooltip:SetOwner(parent, oanchor);
			tooltip:SetPoint(ganchor, parent:GetName(), panchor, 0, 0);
			tooltip.default = nil;	
		end			
	end
	if (TipBuddy_SavedVars["general"].gtt_scale) then
		GameTooltip:SetScale(2);
		GameTooltip:SetScale(TipBuddy_SavedVars["general"].gtt_scale);	
		TB_AddMessage("SCALE = "..TipBuddy_SavedVars["general"].gtt_scale);
	end
end

--hook
local originalGameTooltip_OnHide;
originalGameTooltip_OnHide = GameTooltip_OnHide;
function GameTooltip_OnHide()
	originalGameTooltip_OnHide();
	this:SetAlpha(1);
	TipBuddy_TargetBuffs_Update();
	TipBuddy_ShowRank( TipBuddy.targetType, this.unit );
	TipBuddy_TargetInfo_ShowFaction( TipBuddy.targetType, this.unit );
	if (not TipBuddy.uiScale or not TipBuddy.xpoint or not TipBuddy.anchor) then
		TipBuddy.uiScale = TipBuddy_GetUIScale();
		TipBuddy.xpoint, TipBuddy.xpos, TipBuddy.ypos = TipBuddy_GetFrameCursorOffset();
		TipBuddy.anchor, TipBuddy.fanchor, TipBuddy.offset = TipBuddy_GetFrameAnchorPos();				
	end

	--	this.default = nil;
end

-- hook for GameTooltip_OnEvent
function TipBuddy_GameTooltip_OnEvent()
	lGameTooltip_OnEvent_Orig(event);
	if (event ~= "CLEAR_TOOLTIP" and UnitExists("mouseover")) then
		if (event == "TOOLTIP_ADD_MONEY") then
			return;
		end
		--TB_AddMessage("UPDATE_MOUSEOVER_UNIT -- gtt_OnEvent");
		local text = getglobal("GameTooltipTextLeft1");
		if (not text or TipBuddy.unitname ~= text:GetText() or not string.find(text:GetText(), TipBuddy.gtt_name) ) then
			TB_AddMessage("GTT_0NEVENT: (updating) ");
			TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( "mouseover" );
			
			TipBuddy_SetFrame_Visibility( TipBuddy.targetType, "mouseover" );
		
			TipBuddy_ShowRank( TipBuddy.targetType, "mouseover" );
			TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
			TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
		end
		return;
	elseif (event == "CLEAR_TOOLTIP" and UnitExists("mouseover")) then
		return;
	else
		if (not TipBuddy.hasTarget == 1) then
			TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, "mouseover" );
		end
	end
end

--hook
local originalUnitFrame_OnEnter;
originalUnitFrame_OnEnter = UnitFrame_OnEnter;
function UnitFrame_OnEnter()
	originalUnitFrame_OnEnter();

	TipBuddy.unitframe = 1;
	TB_AddMessage("entering unit frame: "..this.unit);
	TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( this.unit );

	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	GameTooltip:SetUnit(this.unit);
	TipBuddy_SetFrame_Visibility( TipBuddy.targetType, this.unit );
	-- hiding health and mana bars because they won't update
	if ( TipBuddy_SavedVars[TipBuddy.targetType].off == 1 ) then
		TipBuddy_TargetFrameHealthBar:Hide();
		TipBuddy_TargetFrameManaBar:Hide();
		-- setting frame size again
		TipBuddy_FrameHeights_Initialize();
		TipBuddy_SetFrame_Width();
	end

	TipBuddy_ShowRank( TipBuddy.targetType, this.unit );
	TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, this.unit );
	TipBuddy_TargetBuffs_Update( TipBuddy.targetType, this.unit );
end

--hook
local originalUnitFrame_OnLeave;
originalUnitFrame_OnLeave = UnitFrame_OnLeave;
function UnitFrame_OnLeave()
	originalUnitFrame_OnLeave();
	TipBuddy.unitframe = 0;

	TB_AddMessage("leaving unit frame");
	TipBuddy.unitname = nil;
	TipBuddy_TargetBuffs_Update();
	TipBuddy_RankFrame:Hide();
	TipBuddy_FactionFrame:Hide();
end

--hook
local originalUnitFrame_OnUpdate;
originalUnitFrame_OnUpdate = UnitFrame_OnUpdate;
function UnitFrame_OnUpdate(elapsed)
	originalUnitFrame_OnUpdate(elapsed);
	if ( TipBuddy.unitframe == 1 and GameTooltip:IsOwned(this)) then
		TB_AddMessage(this.unit);
		TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( this.unit );

		TipBuddy_SetFrame_Visibility( TipBuddy.targetType, this.unit, 1 );
		-- hiding health and mana bars because they won't update
		TipBuddy_TargetFrameHealthBar:Hide();
		TipBuddy_TargetFrameManaBar:Hide();
		-- setting frame size again
		TipBuddy_FrameHeights_Initialize();
		TipBuddy_SetFrame_Width();

		TipBuddy_ShowRank( TipBuddy.targetType, this.unit );
		TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, this.unit );
		TipBuddy_TargetBuffs_Update( TipBuddy.targetType, this.unit );

		TipBuddy.hasTarget = 1;
	end
end

--hook
local originalPlayerFrame_OnUpdate;
originalPlayerFrame_OnUpdate = PlayerFrame_OnUpdate;
function PlayerFrame_OnUpdate(elapsed)
	originalPlayerFrame_OnUpdate(elapsed);
	if ( TipBuddy.unitframe == 1 and GameTooltip:IsOwned(this) ) then
		TB_AddMessage(this.unit);
		TipBuddy.targetType = TipBuddy_TargetInfo_GetTargetType( this.unit );

		TipBuddy_SetFrame_Visibility( TipBuddy.targetType, this.unit, 1 );
		-- hiding health and mana bars because they won't update
		TipBuddy_TargetFrameHealthBar:Hide();
		TipBuddy_TargetFrameManaBar:Hide();
		-- setting frame size again
		TipBuddy_FrameHeights_Initialize();
		TipBuddy_SetFrame_Width();

		TipBuddy_ShowRank( TipBuddy.targetType, this.unit );
		TipBuddy_SetFrame_BackgroundColor( TipBuddy.targetType, this.unit );
		TipBuddy_TargetBuffs_Update( TipBuddy.targetType, this.unit );

		TipBuddy.hasTarget = 1;
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- SET ANCHOR
--------------------------------------------------------------------------------------------------------------------------------------
-- if it is set to be anchored, anchor it to TipBuddyAnchor
-- otherwise, set it to the cursor
function TipBuddy_SetFrame_Anchor( frame )
	frame:ClearAllPoints();
	if (TipBuddy_SavedVars["general"].anchored == 1) then
		frame:SetPoint(TipBuddy.anchor, "TipBuddy_Parent_Frame", TipBuddy.fanchor, 0, TipBuddy.offset);
	else
		frame:SetPoint(TipBuddy.xpoint, "TipBuddy_Parent_Frame", "CENTER", 0, 0);
	end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- SET HEIGHTS
--------------------------------------------------------------------------------------------------------------------------------------
-- /script TipBuddy_SavedVars["general"].scalemod = "1";
-- /script TipBuddy_SavedVars["general"].scalemod = "0";

function TipBuddy_FrameHeights_Initialize()
	local scale = TipBuddy_SavedVars["general"].scalemod;

	TipBuddy_FactionFrameIcon:SetHeight( 30 + (scale * 1.5) );
	TipBuddy_FactionFrameIcon:SetWidth( 30 + (scale * 1.5) );

	TipBuddy_TargetName_Text:SetTextHeight( 11 + scale );
	TipBuddy_TargetName_Text:SetHeight( 11 + scale );

	TipBuddy_TargetGuild_Text:SetTextHeight( 8 + scale );
	TipBuddy_TargetGuild_Text:SetHeight( 8 + scale );

	TipBuddy_TargetCivilian_Text:SetTextHeight( 7 + scale );
	TipBuddy_TargetCivilian_Text:SetHeight( 7 + scale );

	TipBuddy_TargetLevel_Text:SetTextHeight( 10 + scale );
	TipBuddy_TargetLevel_Text:SetHeight( 10 + scale );
	TipBuddy_TargetClass_Text:SetTextHeight( 10 + scale );
	TipBuddy_TargetClass_Text:SetHeight( 10 + scale );

	TipBuddy_TargetCityFac_Text:SetTextHeight( 8 + scale );
	TipBuddy_TargetCityFac_Text:SetHeight( 8 + scale );

	TipBuddy_TargetFrameHealthBar:SetHeight( 5 + scale );
	TipBuddy_TargetFrameManaBar:SetHeight( 3 + scale );
	TipBuddy_HealthTextText:SetTextHeight( TipBuddy_TargetFrameHealthBar:GetHeight() + 6 );
	TipBuddy_ManaTextText:SetTextHeight( TipBuddy_TargetFrameManaBar:GetHeight() + 3.5 );

	TipBuddy_TargetLevel_Text:SetTextHeight( 8 + scale );
	TipBuddy_TargetLevel_Text:SetHeight( 8 + scale );

	TipBuddy_RankFrameIcon:SetHeight( 12 + scale );
	TipBuddy_RankFrameIcon:SetWidth( 12 + scale );

-- hack to fix the fonts scaling badly
	TipBuddy_Main_Frame:SetScale(2);
	TipBuddy_Main_Frame:SetScale(UIParent:GetScale());

	TipBuddy_SetFrame_Height();
end

function TipBuddy_SetFrame_Width()
	local scale = TipBuddy_SavedVars["general"].scalemod;
	
	local targetNameLength = TipBuddy_TargetName_Text:GetStringWidth() + (4 + scale); 
	local targetClassLength = (TipBuddy_TargetClass_Text:GetStringWidth() + TipBuddy_TargetLevel_Text:GetStringWidth() + (scale + 10)); 
	local targetGuildLength = TipBuddy_TargetGuild_Text:GetStringWidth() + (4 + scale); 

	if (not TipBuddy_TargetClass_Text:IsVisible()) then
		targetClassLength = 1;	
	end
	if (not TipBuddy_TargetGuild_Text:IsVisible()) then
		targetGuildLength = 1;	
	end

	if (targetNameLength > targetGuildLength) then
		if (targetNameLength < targetClassLength) then
			targetNameLength = targetClassLength;
		end
	elseif (targetGuildLength > targetClassLength) then
		targetNameLength = targetGuildLength;
	else
		targetNameLength = targetClassLength;
	end
	if (targetNameLength < 72) then
		targetNameLength = 72;
	end
	TipBuddy_Main_Frame:SetWidth(targetNameLength + scale);

	TipBuddy_TargetFrameHealthBar:SetWidth(TipBuddy_Main_Frame:GetWidth() - 6);
	TipBuddy_TargetFrameManaBar:SetWidth(TipBuddy_Main_Frame:GetWidth() - 6);
end

--/script foc = GetMouseFocus(); DEFAULT_CHAT_FRAME:AddMessage(foc:GetName());

function TipBuddy_SetFrame_Height()
	local scale = TipBuddy_SavedVars["general"].scalemod;
	local nameFrame = TipBuddy_TargetName_Text:GetHeight();
	local guildFrame = TipBuddy_TargetGuild_Text:GetHeight();
	local classFrame = TipBuddy_TargetLevel_Text:GetHeight();
	local healthFrame = TipBuddy_TargetFrameHealthBar:GetHeight();
	local manaFrame = TipBuddy_TargetFrameManaBar:GetHeight();
	local cityfacFrame = TipBuddy_TargetCityFac_Text:GetHeight();
	local civFrame = TipBuddy_TargetCivilian_Text:GetHeight();

	if (TipBuddy_TargetName_Text:IsVisible()) then
		nameFrame = TipBuddy_TargetName_Text:GetHeight();
	else
		nameFrame = 0;	
	end

	if (TipBuddy_TargetGuild_Text:IsVisible()) then
		guildFrame = TipBuddy_TargetGuild_Text:GetHeight();
	else
		guildFrame = 0;	
	end

	if (TipBuddy_TargetLevel_Text:IsVisible()) then
		classFrame = (TipBuddy_TargetLevel_Text:GetHeight() + 1);
	else
		classFrame = 0;	
	end

	if (TipBuddy_TargetFrameHealthBar:IsVisible()) then
		healthFrame = (TipBuddy_TargetFrameHealthBar:GetHeight() + 5);
	else
		healthFrame = 0;	
	end

	if (TipBuddy_TargetFrameManaBar:IsVisible()) then
		manaFrame = (TipBuddy_TargetFrameManaBar:GetHeight() + 4);
	else
		manaFrame = 0;	
	end

	if (TipBuddy_TargetCityFac_Text:IsVisible()) then
		cityfacFrame = TipBuddy_TargetCityFac_Text:GetHeight();
	else
		cityfacFrame = 0;	
	end

	if (TipBuddy_TargetCivilian_Text:IsVisible()) then
		TipBuddy_TargetCityFac_Text:SetPoint("BOTTOMLEFT", "TipBuddy_TargetCivilian_Text", "TOPLEFT", 1, 1);
		civFrame = TipBuddy_TargetCivilian_Text:GetHeight();
	elseif ( TipBuddy_TargetLevel_Text:IsVisible() ) then
		TipBuddy_TargetCityFac_Text:SetPoint( "BOTTOMLEFT", "TipBuddy_TargetLevel_Text", "TOPLEFT", 1, 1);
		civFrame = 0;
	else
		TipBuddy_TargetCityFac_Text:SetPoint( "BOTTOMLEFT", "TipBuddy_Main_Frame", "BOTTOMLEFT", 1, 3);
		civFrame = 0;
	end

	local tipFrameHeight = ((nameFrame + guildFrame + classFrame + healthFrame + manaFrame + cityfacFrame + civFrame) + 4);
	TipBuddy_Main_Frame:SetHeight(tipFrameHeight);
end

function TipBuddy_Xtras_FrameSize()
	local scale = TipBuddy_SavedVars["general"].scalemod;

	local xtra1 = (getglobal("TipBuddy_Xtra1_Text"):GetStringWidth() + getglobal("TipBuddy_XtraR1_Text"):GetStringWidth());
	local xtra2;
	for i=2, 10, 1 do
		--TB_AddMessage("WTF");
		local xtraLineL = getglobal("TipBuddy_Xtra"..i.."_Text");
		local xtraLineR = getglobal("TipBuddy_XtraR"..i.."_Text");
		xtra2 = (xtraLineL:GetStringWidth() + xtraLineR:GetStringWidth())
		if (xtra1 > xtra2) then
			xtra1 = xtra1;
		else
			xtra1 = xtra2;
		end
	end

	TipBuddy_Xtra_Frame:SetWidth(xtra1 + 16);

	local xtraHeightL = 2;
	local xtraHeightR = 2;
	for i=1, 10, 1 do
		local xtraLineL = getglobal("TipBuddy_Xtra"..i.."_Text");
		local xtraLineR = getglobal("TipBuddy_XtraR"..i.."_Text");
		if (xtraLineL:GetText()) then
			xtraLineL:SetTextHeight( 7 + scale );
			xtraLineL:SetHeight( 7 + scale );
			xtraHeightL = ( xtraHeightL + xtraLineL:GetHeight() + 1 );
		end
		if (xtraLineR:GetText()) then
			xtraLineR:SetTextHeight( 7 + scale );
			xtraLineR:SetHeight( 7 + scale );
			xtraHeightR = ( xtraHeightR + xtraLineL:GetHeight() + 1);
		end
	end
	TipBuddy_Xtra_Frame:SetHeight( xtraHeightL + 6 );

	if (TipBuddy_Xtra_Frame:GetWidth() > TipBuddy_Main_Frame:GetWidth()) then
		TipBuddy_Main_Frame:SetWidth(TipBuddy_Xtra_Frame:GetWidth())
	else
		TipBuddy_Xtra_Frame:SetWidth(TipBuddy_Main_Frame:GetWidth())
	end

-- hack to fix the fonts scaling badly
	TipBuddy_Xtra_Frame:SetScale(2);
	TipBuddy_Xtra_Frame:SetScale(UIParent:GetScale());
end

--------------------------------------------------------------------------------------------------------------------------------------
-- PARENT ON UPDATE
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_ParentTip_OnUpdate()
	if (TipBuddy_Main_Frame:IsVisible() or GameTooltip:IsVisible()) then
		this:ClearAllPoints();

		local x, y = TipBuddy_PositionFrameToCursor();

--		TB_AddMessage(GetCVar("TipBuddy.uiScale"));


		if ( UnitExists("mouseover") or TipBuddy.anchorparent == "UIParent") then
			if (TipBuddy_SavedVars["general"].anchored == 1) then
				this:SetPoint(TipBuddy.anchor, "TipBuddy_Header_Frame", TipBuddy.fanchor, 0, 0);
			else
				this:SetPoint(TipBuddy.xpoint, "UIParent", "BOTTOMLEFT", x, y);
			end
		else
			if (TipBuddy_SavedVars["general"].nonunit_anchor == 0) then
				this:SetPoint(TipBuddy.xpoint, "UIParent", "BOTTOMLEFT", x, y);				
			elseif (TipBuddy_SavedVars["general"].nonunit_anchor == 1) then
				this:SetPoint(TipBuddy.anchor, "TipBuddy_Header_Frame", TipBuddy.fanchor, 0, 0);
			else
				this:SetPoint(TipBuddy.xpoint, "UIParent", "BOTTOMLEFT", x, y);	
			end
		end

		if ( UnitExists("mouseover") or TipBuddy.unitframe == 1) then
			TipBuddy.hasTarget = 1;
			--TB_AddMessage(TipBuddy.hasTarget);
		elseif (TipBuddy.hasTarget == 1 or (TipBuddy.hasTarget == 1 and TipBuddy.unitframe == 0)) then
			local text1 = getglobal("GameTooltipTextLeft1"):GetText();
			--TB_AddMessage(TipBuddy.unitname..getglobal("GameTooltipTextLeft1"):GetText());
			if (text1 == nil or TipBuddy.gtt_name == nil or string.find(text1, TipBuddy.gtt_name)) then
				if (TipBuddy_SavedVars["general"].gtt_fade == 1) then
					GameTooltip:FadeOut();
					--TB_AddMessage("fading tt");
				else
					GameTooltip:Hide();
					--TB_AddMessage("hiding tt");
				end
			end

			if (TipBuddy_Main_Frame:IsVisible()) then
				TipBuddy_Hide( TipBuddy_Main_Frame );	
			end

			TipBuddy.hasTarget = 0;
			TipBuddy.unitname = nil;
		end
		
		if (not TipBuddy.first) then
			--GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
			GameTooltip:ClearAllPoints();
			GameTooltip:SetPoint(TipBuddy.xpoint, "TipBuddy_Parent_Frame", "CENTER", 0, 0);
			GameTooltip.default = nil;
			TipBuddy_TargetBuffs_Update( TipBuddy.targetType, "mouseover" );
			TipBuddy.first = 1;	
			--TB_AddMessage("first time");
		end

	end
	--[[
	if (TipBuddy.datasent and TipBuddy.datasent == 1) then
		local fraction = (GetTime() - TipBuddy.dataStartTime) / (TipBuddy.dataEndTime - TipBuddy.dataStartTime);
		--CSG_AddMessage(CSG_WHT_TXT..this:GetName().." : fraction = "..fraction);
		if ( fraction >= 1.0 ) then
			TipBuddy_SendData();
		end			
	end]]
end

--------------------------------------------------------------------------------------------------------------------------------------
-- MAIN ON UPDATE
--------------------------------------------------------------------------------------------------------------------------------------
function TipBuddy_MainTip_OnUpdate()
	--/script TipBuddy_SavedVars["general"].cursorpos = 1;
	--/script TipBuddy_SavedVars["general"].cursorpos = 0;

	if ( this.fadingout ) then
		if ( this:GetAlpha() <= 0 ) then
			TipBuddy_FadeOut_Finished();
		end
	elseif ( this.fadingin ) then
		if ( this:GetAlpha() >= 1 ) then
			TipBuddy_FadeIn_Finished();
		end
	end
	if (this:IsVisible()) then
		this:ClearAllPoints();
		TipBuddy_SetFrame_Anchor( TipBuddy_Main_Frame );

		if ((TipBuddy.hasTarget == 0) and (not this.fadingout)) then
			--/script TB_AddMessage(TipBuddy_Main_Frame.fadingout);
			if (not this.startTime or not this.endTime) then
				GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
				TipBuddy_ForceHide( this );
				return;
			end
			local fraction = (GetTime() - this.startTime) / (this.endTime - this.startTime);
			if ( fraction >= 1.0 ) then
				TipBuddy_FadeOut( this );
			elseif (GameTooltip:IsVisible()) then	
				GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
				TipBuddy_ForceHide( this );
			end	
		elseif (GameTooltip:IsVisible()) then	
			GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
			TipBuddy_ForceHide( this );
		end

		if (TipBuddy_Main_Frame.xtraTimer == 1) then
			local fraction = (GetTime() - this.xtraStart) / (this.xtraEnd - this.xtraStart);
			if ( fraction >= 1.0 ) then
				TipBuddy_Main_Frame.xtraTimer = 0;
				TipBuddy_TargetInfo_FindExtras();
			else
				return;
			end	
		end
	end
end

--/script TB_AddMessage(UIParent:GetWidth()..", "..UIParent:GetHeight()); local x, y = GetCursorPosition(UIParent); TB_AddMessage(x..", "..y);
function TipBuddy_PositionFrameToCursor()

	local x, y = GetCursorPosition(UIParent);

	if (not TipBuddy.uiScale or not TipBuddy.xpoint or not TipBuddy.anchor) then
		TipBuddy.uiScale = TipBuddy_GetUIScale();
		TipBuddy.xpoint, TipBuddy.xpos, TipBuddy.ypos = TipBuddy_GetFrameCursorOffset();
		TipBuddy.anchor, TipBuddy.fanchor, TipBuddy.offset = TipBuddy_GetFrameAnchorPos();				
	end

	x = (x / TipBuddy.uiscale) + TipBuddy.xpos;
	y = (y / TipBuddy.uiscale) + TipBuddy.ypos;

	local x1, x2, y1, y2, tip;
	if (GameTooltip:IsVisible()) then
		tip = getglobal("GameTooltip");
	else
		tip = getglobal("TipBuddy_Main_Frame");
	end

	if ( TipBuddy.xpoint == "LEFT" ) then
		x1 = 0;
		x2 = (TipBuddy.uiwidth - tip:GetWidth());
	elseif ( TipBuddy.xpoint == "RIGHT" ) then
		x1 = tip:GetWidth();
		x2 = TipBuddy.uiwidth;
	else
		x1 = tip:GetWidth() * 0.5;
		x2 = (TipBuddy.uiwidth - x1);
	end

	y1 = (TipBuddy.uiheight - tip:GetHeight());
	if ( TipBuddy.xpoint == "TOP" ) then
		y2 = tip:GetHeight();
	elseif ( xpoint == "BOTTOM" ) then
		y2 = 0;
	else
		y2 = (tip:GetHeight() * 0.5);
	end

--TB_AddMessage(x1..", "..y2);
	if ( x < x1 ) then
		x = x1;
	end
	if ( x > x2 ) then
		x = x2;
	end
	if ( y > y1 ) then
		y = y1;
	end
	if ( y < y2 ) then
		y = y2;
	end
	
	return x, y;
end

function TipBuddy_GetIconAnchorPos( frame )
	local x, y = TipBuddy_PositionFrameToCursor();

--:SetPoint(TipBuddy.xpoint, "TipBuddy_Parent_Frame", "CENTER", 0, 0);
	
	if (y > (TipBuddy.uiheight * 0.75)) then
		--topright
		if (x > (TipBuddy.uiwidth * 0.75)) then
			if (frame and frame:GetLeft() <= (TipBuddy.uiwidth * 0.2)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_BOTTOMLEFT");
			return "ANCHOR_BOTTOMLEFT", "TOPRIGHT", "BOTTOMLEFT";
		--topmidright
		elseif (x > (TipBuddy.uiwidth * 0.5)) then
			if (frame and frame:GetLeft() <= (TipBuddy.uiwidth * 0.2)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_BOTTOMLEFT");
			return "ANCHOR_BOTTOMLEFT", "TOPRIGHT", "BOTTOMRIGHT";
		--cursor is topmidleft
		elseif (x > (TipBuddy.uiwidth * 0.25)) then
			if (frame and frame:GetRight() >= (TipBuddy.uiwidth * 0.8)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_BOTTOMRIGHT");
			return "ANCHOR_BOTTOMRIGHT", "TOPLEFT", "BOTTOMLEFT";
		--cursor is topleft
		else
			if (frame and frame:GetRight() >= (TipBuddy.uiwidth * 0.8)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_BOTTOMRIGHT");
			return "ANCHOR_BOTTOMRIGHT", "TOPLEFT", "BOTTOMRIGHT";
		end

	elseif (y > (TipBuddy.uiheight * 0.25)) then
		--midright
		if (x > (TipBuddy.uiwidth * 0.75)) then
			if (frame and frame:GetLeft() <= (TipBuddy.uiwidth * 0.2)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_NONE");
			return "ANCHOR_NONE", "BOTTOMRIGHT", "BOTTOMLEFT";
		else
			if (frame and frame:GetRight() >= (TipBuddy.uiwidth * 0.8)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_NONE");
			return "ANCHOR_NONE", "BOTTOMLEFT", "BOTTOMRIGHT";
		end
	else

		if (x > (TipBuddy.uiwidth * 0.75)) then
			if (frame and frame:GetLeft() <= (TipBuddy.uiwidth * 0.2)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_LEFT");
			return "ANCHOR_LEFT", "BOTTOMRIGHT", "TOPLEFT";
		else
			if (frame and frame:GetRight() >= (TipBuddy.uiwidth * 0.8)) then
				--TB_AddMessage("ANCHOR_NONE");
				return "ANCHOR_NONE", "BOTTOM", "TOP";
			end
			--TB_AddMessage("ANCHOR_RIGHT");
			return "ANCHOR_RIGHT", "BOTTOMLEFT", "TOPRIGHT";
		end		
	end
end

function TipBuddy_GetFrameCursorOffset()
	local curpos = TipBuddy_SavedVars["general"].cursorpos;
	TipBuddy.uiscale = UIParent:GetScale();
	TipBuddy.uiwidth = UIParent:GetWidth() / TipBuddy.uiscale;
	TipBuddy.uiheight = UIParent:GetHeight() / TipBuddy.uiscale;

	-- set the position of the tooltip in relation to the cursor
	if (curpos == "Top") then
		xpoint = "BOTTOM";
	elseif (curpos == "Right") then
		xpoint = "LEFT";		
	elseif (curpos == "Left") then
		xpoint = "RIGHT";
	elseif (curpos == "Bottom") then
		xpoint = "TOP";
	end
	return xpoint, TipBuddy_SavedVars["general"].offset_x, TipBuddy_SavedVars["general"].offset_y;
end

function TipBuddy_GetFrameAnchorPos()
	local anchorpos = TipBuddy_SavedVars["general"].anchor_pos;
	-- if the options checkbox is checked, set the tip to be on top of the cursor
	-- if not, use the default position (to the right)
	if (anchorpos == "Top Right") then
		anchor = "BOTTOMRIGHT";
		fanchor = "TOPRIGHT";
		offset = -2;
	elseif (anchorpos == "Top Left") then
		anchor = "BOTTOMLEFT";
		fanchor = "TOPLEFT";
		offset = -2;
	elseif (anchorpos == "Bottom Right") then
		anchor = "TOPRIGHT";
		fanchor = "BOTTOMRIGHT";
		offset = 2;
	elseif (anchorpos == "Bottom Left") then
		anchor = "TOPLEFT";
		fanchor = "BOTTOMLEFT";
		offset = 2;
	elseif (anchorpos == "Top Center") then
		anchor = "BOTTOM";
		fanchor = "TOP";
		offset = -2;
	elseif (anchorpos == "Bottom Center") then
		anchor = "TOP";
		fanchor = "BOTTOM";
		offset = 2;
	end
	return anchor, fanchor, offset;
end

--------------------------------------------------------------------------------------------------------------------------------------
-- FADING
--------------------------------------------------------------------------------------------------------------------------------------

function TipBuddy_Hide( frame )
	--TB_AddMessage("TipBuddy_Hide");
	TipBuddy.hasTarget = 0;

	if (GameTooltip:IsVisible() and not UnitExists("mouseover")) then
		TipBuddy_ForceHide(frame);
		return;
	elseif (UnitExists("mouseover")) then
		TipBuddy_ForceHide(frame);
		return;
	elseif ( frame.fadingout ) then
		return;
	end

	local delayTime;
	if (TipBuddy_SavedVars["general"].delaytime) then
		delayTime = TipBuddy_SavedVars["general"].delaytime;
	else
		delayTime = 0;
	end
	TipBuddy.unitname = nil;

	frame.startTime = GetTime();
	frame.endTime = frame.startTime + (0.01 + delayTime);
end

function TipBuddy_ForceHide(frame)
	--TB_AddMessage("TipBuddy_ForceHide");
	UIFrameFadeRemoveFrame(frame);
	frame.fadingout = nil;
	frame.fadingin = nil;
	frame:SetAlpha(0);
	frame:Hide();
end


function TipBuddy_FadeOut( frame, func )
	--TB_AddMessage("TipBuddy_FadeOut");
	if (GameTooltip:IsVisible()) then
		TipBuddy_ForceHide(frame);
		return;
	end
	if ( frame.fadingout ) then
		return;
	end

	frame.fadingout = 1;
	frame.fadingin = nil;
	frame.targetalpha = 0;
	frame.animfunc_fade = func;

	local fadeTime;
	if (TipBuddy_SavedVars["general"].fadetime) then
		fadeTime = TipBuddy_SavedVars["general"].fadetime;
	else
		fadeTime = 0;
	end
	UIFrameFadeRemoveFrame(frame);
	UIFrameFadeOut( frame, (0.01 + fadeTime), frame:GetAlpha(), frame.targetalpha );
end

function TipBuddy_FadeOut_Finished()
	--TB_AddMessage("TipBuddy_FadeOut_Finished");
	this:Hide();
	this:SetAlpha( 1 );

	this.fadingout = nil;
	if ( this.animfunc_fade ) then
		this.animfunc_fade();
	end
end

function TipBuddy_FadeIn( frame, func )
	--TB_AddMessage("TipBuddy_FadeIn");
	if ( frame.fadingin ) then
		return;
	end
	if ( frame.fadingout ) then
		UIFrameFadeRemoveFrame(frame);
	end

	frame.fadingin = 1;
	frame.fadingout = nil;
	frame.targetalpha = 1;
	frame.animfunc_fade = func;
	UIFrameFadeRemoveFrame(frame);
	UIFrameFadeIn( frame, 0.01, 0.9, frame.targetalpha );
end

function TipBuddy_FadeIn_Finished()
	--TB_AddMessage("TipBuddy_FadeIn_Finished");
	this:SetAlpha( 1 );

	this.fadingin = nil;
	if ( this.animfunc_fade ) then
		this.animfunc_fade();
	end
end
--/script TB_AddMessage(TipBuddy_Main_Frame:IsVisible());


--/script TipBuddy_SendData();
--/script TipBuddy_SendData( "WTF MATE" );
--[[
function TipBuddy_SendData( message )
	if (not message and TipBuddy.datasent and TipBuddy.datasent == 2) then
		return
	end
	JoinChannelByName("BuddyChatChannel");
	local index = GetChannelName("BuddyChatChannel");
	if (index and index ~= 0) then
		if (not message) then
			message = "REALM:"..GetCVar("realmName")..": PLAYER:"..UnitName("player")..": MOD:TipBuddy: VER:"..TIPBUDDY_VERSION..": ";	
		end
		SendChatMessage( message , "CHANNEL", nil, index);
		TB_AddMessage("SENDING DATA");

		TipBuddy.datasent = 2;
		if (not TipBuddy_SavedVars.chatdebug) then
			--while(GetChannelName("BuddyChatChannel") > 0) do
				LeaveChannelByName("BuddyChatChannel");
			--end
		end
	end	
end

local originalChatFrame_OnEvent;
originalChatFrame_OnEvent = ChatFrame_OnEvent;
function ChatFrame_OnEvent(event)
	if( event == "CHAT_MSG_CHANNEL" ) then
		if (not arg1) then
			originalChatFrame_OnEvent(event);
			return;	
		end

		if ( string.find(arg1, "BuddyChatChannel") ) then
			if (TipBuddy_SavedVars.debug ~= 1) then
				return;
			end
		end
	end
	originalChatFrame_OnEvent(event);
end
]]
