function Perl_Init() 
	Perl_Player_Pet_StatsFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_Pet_StatsFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_Pet_LevelFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_Pet_LevelFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_Pet_NameFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_Pet_NameFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_Pet_BuffFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_Pet_BuffFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_Pet_HealthBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_Pet_ManaBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_StatsFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_StatsFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_PortraitFrame:SetBackdropColor(0, 0, 0, 1);
	Perl_Player_PortraitFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_NameFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_NameFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_LevelFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Player_LevelFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Player_ClassTexture:SetAlpha(Perl_Config.Transparency);
	Perl_Player_HealthBarText:SetTextColor(1,1,1,1);
	Perl_Player_ManaBarText:SetTextColor(1,1,1,1);
	Perl_Player_DruidBarText:SetTextColor(1,1,1,1);
	Perl_Player_HealthBarTEXT:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_ManaBarTEXT:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_XPBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_PVPRankIcon:SetAlpha(0.3);
	Perl_TargetTarget_StatsFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_TargetTarget_StatsFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_TargetTarget_NameFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_TargetTarget_NameFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_TargetTarget_LevelFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_TargetTarget_LevelFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_TargetTarget_Frame:Hide();
	Perl_TargetTarget_HealthBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_TargetTarget_ManaBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_TargetTarget_ManaBarPercent:SetTextColor(1,1,1,1);
	Perl_TargetTarget_HealthBarPercent:SetTextColor(1,1,1,1);
	Perl_Target_StatsFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_StatsFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_Target_NameFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_NameFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_Target_PortraitFrame:SetBackdropColor(0, 0, 0, 1);
	Perl_Target_PortraitFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	Perl_Target_BuffFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_BuffFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_Target_LevelFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_LevelFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_Target_TypeFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_TypeFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_Target_BossFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_BossFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);

	Perl_Target_CPFrame:SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
	Perl_Target_CPFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, Perl_Config.Transparency);
	Perl_Target_Frame:Hide();
	Perl_Target_ClassTexture:SetAlpha(Perl_Config.Transparency);
	Perl_Target_HealthBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Target_ManaBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Target_ManaBarPercent:SetTextColor(1,1,1,1);
	Perl_Target_HealthBarPercent:SetTextColor(1,1,1,1);
	Perl_Target_PVPRankIcon:SetAlpha(0.3);
	for num=1,4 do
		getglobal("Perl_party"..num.."_StatsFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_party"..num.."_StatsFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_party"..num.."_NameFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_party"..num.."_NameFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_party"..num.."_LevelFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_party"..num.."_LevelFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_party"..num.."_BuffFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_party"..num.."_BuffFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_party"..num.."_LevelFrame_ClassTexture"):SetAlpha(Perl_Config.Transparency);
	
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarText"):SetTextColor(1,1,1,Perl_Config.TextTransparency);
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarText"):SetTextColor(1,1,1,Perl_Config.TextTransparency);
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarPercentText"):SetTextColor(1,1,1,1);
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarPercentText"):SetTextColor(1,1,1,1);
		
		getglobal("Perl_Party_Pet"..num.."_StatsFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_Party_Pet"..num.."_StatsFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_Party_Pet"..num.."_NameFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_Party_Pet"..num.."_NameFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_Party_Pet"..num.."_BuffFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_Party_Pet"..num.."_BuffFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_HealthBar_HealthBarPercentText"):SetTextColor(1,1,1,1);
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_ManaBar_ManaBarPercentText"):SetTextColor(1,1,1,1);
	end
	for num=1,50 do
		getglobal("Perl_Raid"..num.."_StatsFrame_HealthBar_HealthBarText"):SetTextColor(1,1,1, Perl_Config.TextTransparency);
		getglobal("Perl_Raid"..num.."_StatsFrame_ManaBar_ManaBarText"):SetTextColor(1,1,1, Perl_Config.TextTransparency);
		getglobal("Perl_Raid"..num.."_StatsFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_Raid"..num.."_StatsFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
		getglobal("Perl_Raid"..num.."_NameFrame"):SetBackdropColor(0, 0, 0, Perl_Config.Transparency);
		getglobal("Perl_Raid"..num.."_NameFrame"):SetBackdropBorderColor(0.5, 0.5, 0.5, 1);
	end
	Perl_Player_Frame:Show();
	Perl_Player_XPBarText:Hide();
	Perl_OptionActions();
	Perl_SlashOnLoad();
end


function Perl_OptionActions()
	if (Perl_Config.ShowPlayerPortrait==0) then
		Perl_Player_Hide_Portrait();
	elseif (Perl_Config.ShowPlayerPortrait==1) then
		Perl_Player_Show_Portrait();
	end
	if (Perl_Config.ShowPlayerLevel==0) then
		Perl_Player_Hide_Level();
	elseif (Perl_Config.ShowPlayerLevel==1) then
		Perl_Player_Show_Level();
	end
	if (Perl_Config.ShowPlayerClassIcon==0) then
		Perl_Player_Hide_Class();
	elseif (Perl_Config.ShowPlayerClassIcon==1) then
		Perl_Player_Show_Class();
	end
	if (Perl_Config.ShowPlayerXPBar==0) then
		Perl_Player_Hide_XPBar();
	elseif (Perl_Config.ShowPlayerXPBar==1) then
		Perl_Player_Show_XPBar();
	end
	if (Perl_Config.ShowTargetPortrait==0) then
		Perl_Target_Hide_Portrait();
	elseif (Perl_Config.ShowTargetPortrait==1) then
		Perl_Target_Show_Portrait();
	end
	if (Perl_Config.ShowTargetClassIcon==0) then
		Perl_Target_Hide_Class();
	elseif (Perl_Config.ShowTargetClassIcon==1) then
		Perl_Target_Show_Class();
	end
	if (Perl_Config.ShowTargetMobType==0) then
		Perl_Target_Hide_Type();
	elseif (Perl_Config.ShowTargetMobType==1) then
		Perl_Target_Show_Type();
	end
	if (Perl_Config.ShowTargetLevel==0) then
		Perl_Target_Hide_Level();
	elseif (Perl_Config.ShowTargetLevel==1) then
		Perl_Target_Show_Level();
	end
	if (Perl_Config.ShowTargetElite==0) then
		Perl_Target_Hide_Elite();
	elseif (Perl_Config.ShowTargetElite==1) then
		Perl_Target_Show_Elite();
	end
	if (Perl_Config.ShowTargetMana==0) then
		Perl_Target_Hide_Mana();
	elseif (Perl_Config.ShowTargetMana==1) then
		Perl_Target_Show_Mana();
	end
	if (Perl_Config.ShowPartyClassIcon==0) then
		Perl_HidePartyIcon();
	elseif (Perl_Config.ShowPartyClassIcon==1) then
		Perl_ShowPartyIcon();
	end
	if (Perl_Config.ShowPartyLevel==0) then
		Perl_HidePartyLevel();
	elseif (Perl_Config.ShowPartyLevel==1) then
		Perl_ShowPartyLevel();
	end
	if (Perl_Config.ShowPartyNames==0) then
		Perl_HidePartyNames();
	elseif (Perl_Config.ShowPartyNames==1) then
		Perl_ShowPartyNames();
	end
	if (Perl_Config.ShowPartyPercent==0) then
		Perl_HidePartyPercent();
	elseif (Perl_Config.ShowPartyPercent==1) then
		Perl_ShowPartyPercent();
	end
	if (Perl_Config.PetHappiness==0) then
		Perl_Player_Pet_HideHappiness();
	elseif (Perl_Config.PetHappiness==1) then
		Perl_Player_Pet_ShowHappiness();
	end
	if (Perl_Config.ShowPetLevel==0) then
		Perl_Player_Pet_HideLevel();
	elseif (Perl_Config.ShowPetLevel==1) then
		Perl_Player_Pet_ShowLevel();
	end
	if (Perl_Config.ShowTargetPVPRank==0) then
		Perl_Target_Hide_Rank();
	elseif (Perl_Config.ShowTargetPVPRank==1) then
		Perl_Target_Show_Rank();
	end
	if (Perl_Config.ShowPlayerPVPRank==0) then
		Perl_Player_Hide_Rank();
	elseif (Perl_Config.ShowPlayerPVPRank==1) then
		Perl_Player_Show_Rank();
	end
	if (Perl_Config.BarTextures==0) then
		Perl_NoBarTextures();
	elseif (Perl_Config.BarTextures==1) then
		Perl_ShowBarTextures();
	end
	Perl_SetTransparency(Perl_Config.Transparency);
	Perl_SetTextTransparency(Perl_Config.TextTransparency);
	Perl_ScalePlayer(Perl_Config.Scale_PlayerFrame);
	Perl_ScalePet(Perl_Config.Scale_PetFrame);
	Perl_ScaleParty(Perl_Config.Scale_PartyFrame);
	Perl_ScaleTarget(Perl_Config.Scale_TargetFrame);
	Perl_ScaleTargetTarget(Perl_Config.Scale_TargetTargetFrame);
	Perl_ScaleRaid(Perl_Config.Scale_Raid);
	if (Perl_Config.ArcaneBar==0) then
		Perl_ArcaneBar_Hide();
	elseif (Perl_Config.ArcaneBar==1) then
		Perl_ArcaneBar_Show();
	end
	if (Perl_Config.OldCastBar==0) then
		Perl_OldCastBar_Hide();
	elseif (Perl_Config.OldCastBar==1) then
		Perl_OldCastBar_Show();
	end
	if (Perl_Config.ShowOldPlayerFrame==0) then
		Perl_HideBlizzardPlayer();
	elseif (Perl_Config.ShowOldPlayerFrame==1) then
		Perl_ShowBlizzardPlayer();
	end
	if (Perl_Config.CastPartyShow==0) then
		Perl_HideCastParty();
	elseif (Perl_Config.CastPartyShow==1) then
		Perl_ShowCastParty();
	end
	if (Perl_Config.BarTextures==1) then
		Perl_ShowBarTextures();
	elseif (Perl_Config.BarTextures==0) then
		Perl_NoBarTextures();
	end
	Perl_Raid_Position();
	Perl_RaidTitles();
end