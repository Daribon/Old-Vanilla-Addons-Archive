function Perl_Player_Pet_HideLevel()
	Perl_Player_Pet_LevelBarText:Hide();
	Perl_Player_Pet_LevelFrame:SetWidth(30);
end
function Perl_Player_Pet_ShowLevel()
	Perl_Player_Pet_LevelBarText:Show();
	Perl_Player_Pet_LevelFrame:SetWidth(30);
end
function Perl_Player_Pet_HideHappiness()
	Perl_Player_PetHappiness:Hide();
	Perl_Player_Pet_LevelFrame:Hide();
	Perl_Player_PetHappinessTexture:Hide();
	Perl_Player_PetHappiness:SetWidth(1);
	Perl_Player_Pet_LevelFrame:SetWidth(1);
end
function Perl_Player_Pet_ShowHappiness()
	Perl_Player_PetHappiness:Show();
	Perl_Player_Pet_LevelFrame:Show();
	Perl_Player_PetHappinessTexture:Show();
	Perl_Player_PetHappiness:SetWidth(24);
	Perl_Player_Pet_LevelFrame:SetWidth(30);
end

function Perl_Player_Hide_Portrait()
	Perl_Player_PortraitFrame:Hide();
	Perl_Player_PortraitFrame:SetWidth(1);
	Perl_Player_Frame:SetWidth(160);
	Perl_Config.ShowPlayerPortrait=0;
end
function Perl_Player_Show_Portrait()
	Perl_Player_PortraitFrame:Show();
	Perl_Player_PortraitFrame:SetWidth(60);
	Perl_Player_Frame:SetWidth(220);
	Perl_Config.ShowPlayerPortrait=1;
end

function Perl_Player_Hide_Level()
	Perl_Player_LevelFrame:Hide();
end
function Perl_Player_Show_Level()
	Perl_Player_LevelFrame:Show();
end

function Perl_Player_Hide_Class()
	Perl_Player_ClassTexture:Hide();
end
function Perl_Player_Show_Class()
	Perl_Player_ClassTexture:Show();
end
function Perl_Player_Show_Rank()
	Perl_Player_PVPRankIcon:Show();
end
function Perl_Player_Hide_Rank()
	Perl_Player_PVPRankIcon:Hide();
end
function Perl_Player_Hide_XPBar()
	Perl_Player_XPBar:Hide();
	Perl_Player_XPRestBar:Hide();
	Perl_Player_XPBarBG:Hide();
	Perl_Player_StatsFrame:SetHeight(40);
end
function Perl_Player_Show_XPBar()
	Perl_Player_XPBar:Show();
	Perl_Player_XPRestBar:Show();
	Perl_Player_XPBarBG:Show();
	Perl_Player_StatsFrame:SetHeight(50);
end
function Perl_Target_Hide_Class()
	Perl_Target_ClassTexture:Hide();
end
function Perl_Target_Show_Class()
	Perl_Target_ClassTexture:Show();
end

function Perl_Target_Hide_Portrait()
	Perl_Target_PortraitFrame:Hide();
	Perl_Target_PortraitFrame:SetWidth(1);
	Perl_Target_Frame:SetWidth(160);
end
function Perl_Target_Show_Portrait()
	Perl_Target_PortraitFrame:Show();
	Perl_Target_PortraitFrame:SetWidth(60);
	Perl_Target_Frame:SetWidth(220);
end

function Perl_Target_Hide_Type()
	Perl_Target_TypeFrame:Hide();
end
function Perl_Target_Show_Type()
	Perl_Target_TypeFrame:Show();
end

function Perl_Target_Hide_Level()
	Perl_Target_LevelFrame:Hide();
end
function Perl_Target_Show_Level()
	Perl_Target_LevelFrame:Show();
end

function Perl_Target_Hide_Mana()
	Perl_Target_UpdateDisplay();
end
function Perl_Target_Show_Mana()
	Perl_Target_UpdateDisplay();
end

function Perl_Target_Hide_Distance()
	Perl_Target_DistanceFrame:Hide();
end
function Perl_Target_Show_Distance()
	Perl_Target_DistanceFrame:Show();
end

function Perl_Target_Hide_Elite()
	Perl_Target_BossFrame:Hide();
end
function Perl_Target_Show_Elite()
	Perl_Target_BossFrame:Show();
end
function Perl_Target_Show_Rank()
	Perl_Target_PVPRankIcon:Show();
end
function Perl_Target_Hide_Rank()
	Perl_Target_PVPRankIcon:Hide();
end

function Perl_HidePartyDistance()
	for num=1,4 do
		getglobal("Perl_party"..num.."_DistanceFrame"):Hide();
	end
end
function Perl_ShowPartyDistance()
	for num=1,4 do
		getglobal("Perl_party"..num.."_DistanceFrame"):Show();
	end
end
function Perl_HidePartyLevel()
	for num=1,4 do
		getglobal("Perl_party"..num.."_LevelFrame_LevelBarText"):Hide();
		if (Perl_Config.ShowPartyLevel==1) then getglobal("Perl_party"..num.."_LevelFrame"):SetHeight(getglobal("Perl_party"..num.."_LevelFrame"):GetHeight()-10); end
		if (perl_showpartyicon==0) then 
			getglobal("Perl_party"..num.."_LevelFrame"):SetWidth(1); 
			getglobal("Perl_party"..num.."_LevelFrame"):Hide();
		end
	end
end
function Perl_ShowPartyLevel()
	for num=1,4 do
		getglobal("Perl_party"..num.."_LevelFrame_LevelBarText"):Show();
		getglobal("Perl_party"..num.."_LevelFrame"):Show();
		if (Perl_Config.ShowPartyLevel==0) then getglobal("Perl_party"..num.."_LevelFrame"):SetHeight(getglobal("Perl_party"..num.."_LevelFrame"):GetHeight()+10); end
		getglobal("Perl_party"..num.."_LevelFrame"):SetWidth(34);
	end
end
function Perl_HidePartyIcon()
	for num=1,4 do
		getglobal("Perl_party"..num.."_LevelFrame_ClassTexture"):Hide();
		if (perl_showpartyicon==1) then getglobal("Perl_party"..num.."_LevelFrame"):SetHeight(getglobal("Perl_party"..num.."_LevelFrame"):GetHeight()-20); end
		if (Perl_Config.ShowPartyLevel==0) then 
			getglobal("Perl_party"..num.."_LevelFrame"):SetWidth(1); 
			getglobal("Perl_party"..num.."_LevelFrame"):Hide();
		end
	end
end
function Perl_ShowPartyIcon()
	for num=1,4 do
		getglobal("Perl_party"..num.."_LevelFrame_ClassTexture"):Show();
		getglobal("Perl_party"..num.."_LevelFrame"):Show();
		if (perl_showpartyicon==0) then getglobal("Perl_party"..num.."_LevelFrame"):SetHeight(getglobal("Perl_party"..num.."_LevelFrame"):GetHeight()+20); end
		getglobal("Perl_party"..num.."_LevelFrame"):SetWidth(34);
	end
end

function Perl_HidePartyPercent()
	for num=1,4 do
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarPercentText"):Hide();
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarPercentText"):Hide();
		getglobal("Perl_party"..num.."_StatsFrame"):SetWidth(106);
	end
end
function Perl_ShowPartyPercent()
	for num=1,4 do
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarPercentText"):Show();
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarPercentText"):Show();
		getglobal("Perl_party"..num.."_StatsFrame"):SetWidth(136);
	end
end

function Perl_HidePartyNames()
	for num=1,4 do
		getglobal("Perl_party"..num.."_NameFrame"):Hide();
		getglobal("Perl_party"..num.."_NameFrame"):SetHeight(1);
	end
end
function Perl_ShowPartyNames()
	for num=1,4 do
		getglobal("Perl_party"..num.."_NameFrame"):Show();
		getglobal("Perl_party"..num.."_NameFrame"):SetHeight(24);
	end
end


function Perl_SetTransparency(num)
	Perl_Player_Frame:SetAlpha(num);
	Perl_Target_Frame:SetAlpha(num);
	Perl_party1:SetAlpha(num);
	Perl_party2:SetAlpha(num);
	Perl_party3:SetAlpha(num);
	Perl_party4:SetAlpha(num);
	Perl_Player_Pet_Frame:SetAlpha(num);
	Perl_ArcaneBarFrame:SetAlpha(num/2);
end

function Perl_SetTextTransparency(num)
	Perl_Player_Pet_HealthBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_Pet_ManaBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_HealthBarTEXT:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_ManaBarTEXT:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_DruidBarTEXT:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Player_XPBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_TargetTarget_HealthBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_TargetTarget_ManaBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Target_HealthBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	Perl_Target_ManaBarText:SetTextColor(1,1,1,Perl_Config.TextTransparency);
	for num=1,4 do
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarText"):SetTextColor(1,1,1,Perl_Config.TextTransparency);
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarText"):SetTextColor(1,1,1,Perl_Config.TextTransparency);
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_HealthBar_HealthBarPercentText"):SetTextColor(1,1,1,Perl_Config.TextTransparency);
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_ManaBar_ManaBarPercentText"):SetTextColor(1,1,1,Perl_Config.TextTransparency);
	end
	for num=1,50 do
		getglobal("Perl_Raid"..num.."_StatsFrame_HealthBar_HealthBarText"):SetTextColor(1,1,1, Perl_Config.TextTransparency);
		getglobal("Perl_Raid"..num.."_StatsFrame_ManaBar_ManaBarText"):SetTextColor(1,1,1, Perl_Config.TextTransparency);
	end
end
function Perl_ShowBarTextures()
	Perl_Config.BarTextures=1;
	Perl_Player_Pet_HealthBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Player_Pet_ManaBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Player_Pet_XPBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_HealthBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Player_ManaBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Player_DruidBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Player_XPBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Player_XPRestBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Target_HealthBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Target_ManaBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_Target_CPMeterTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_TargetTarget_HealthBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_TargetTarget_ManaBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	Perl_ArcaneBarTex:SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	for num=1,4 do
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarTex"):SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarTex"):SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_HealthBar_HealthBarTex"):SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_ManaBar_ManaBarTex"):SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	end
	for num=1,50 do
		getglobal("Perl_Raid"..num.."_StatsFrame_HealthBar_HealthBarTex"):SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
		getglobal("Perl_Raid"..num.."_StatsFrame_ManaBar_ManaBarTex"):SetTexture("Interface\\AddOns\\Perl\\Images\\Perl_StatusBar.tga");
	end
end
function Perl_NoBarTextures()
	Perl_Player_Pet_HealthBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_Pet_ManaBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_Pet_XPBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_HealthBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_ManaBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_DruidBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_XPBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Player_XPRestBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Target_HealthBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Target_ManaBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_Target_CPMeterTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_TargetTarget_HealthBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_TargetTarget_ManaBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Perl_ArcaneBarTex:SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	for num=1,4 do
		getglobal("Perl_party"..num.."_StatsFrame_HealthBar_HealthBarTex"):SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
		getglobal("Perl_party"..num.."_StatsFrame_ManaBar_ManaBarTex"):SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_HealthBar_HealthBarTex"):SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
		getglobal("Perl_Party_Pet"..num.."_StatsFrame_ManaBar_ManaBarTex"):SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	end
	for num=1,50 do
		getglobal("Perl_Raid"..num.."_StatsFrame_HealthBar_HealthBarTex"):SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
		getglobal("Perl_Raid"..num.."_StatsFrame_ManaBar_ManaBarTex"):SetTexture("Interface\\TargetingFrame\\UI-StatusBar");
	end
end

function Perl_HidePartyInRaid()
	if (UnitName("raid1")) then
		Perl_party1:Hide();
		Perl_party2:Hide();
		Perl_party3:Hide();
		Perl_party4:Hide();
	end
end
function Perl_ShowCastParty()
	
	if (CastParty_constants) then
		CastPartyMainFrame:Show();
	end
end
function Perl_HideCastParty()
	if (CastParty_constants) then
		CastPartyMainFrame:Hide();
	end
end
function Perl_ScaleParty(num)
	Perl_party4:SetScale(num);
	Perl_party3:SetScale(num);
	Perl_party2:SetScale(num);
	Perl_party1:SetScale(num);
	Perl_Party_Pet4:SetScale(num);
	Perl_Party_Pet3:SetScale(num);
	Perl_Party_Pet2:SetScale(num);
	Perl_Party_Pet1:SetScale(num);
end
function Perl_ScaleRaid(num)
	for frame=1,9 do
		getglobal("Perl_Raid_Grp"..frame):SetScale(num);
	end
	for frame=1,50 do
		getglobal("Perl_Raid"..frame):SetScale(num);
	end
end
function Perl_ScalePlayer(num)
	Perl_ArcaneBarFrame:SetScale(num);
	Perl_Player_Frame:SetScale(num);
end
function Perl_ScaleTarget(num)
	Perl_Target_Frame:SetScale(num);
end
function Perl_ScaleTargetTarget(num)
	Perl_TargetTarget_Frame:SetScale(num);
end
function Perl_ScalePet(num)
	Perl_Player_Pet_Frame:SetScale(num);
end
function Perl_ArcaneBar_Show()
	Perl_ArcaneBar_EnableToggle(1);
end
function Perl_ArcaneBar_Hide()
	Perl_ArcaneBar_EnableToggle(0);
end

function Perl_OldCastBar_Show()
	Perl_ArcaneBar_OverrideToggle(0);
end
function Perl_OldCastBar_Hide()
	Perl_ArcaneBar_OverrideToggle(1);
end
function Perl_RaidTitles()
	if perl_locked==1 then
		for num=1,9 do
	 		getglobal("Perl_Raid_Grp"..num):Hide();
		end
	else
		for num=1,9 do
			getglobal("Perl_Raid_Grp"..num):Show();
		end
	end
end
function Perl_ShowBlizzardPlayer()
	PlayerFrame:RegisterEvent("UNIT_LEVEL");
	PlayerFrame:RegisterEvent("UNIT_COMBAT");
	PlayerFrame:RegisterEvent("UNIT_SPELLMISS");
	PlayerFrame:RegisterEvent("UNIT_PVP_UPDATE");
	PlayerFrame:RegisterEvent("UNIT_MAXMANA");
	PlayerFrame:RegisterEvent("PLAYER_ENTER_COMBAT");
	PlayerFrame:RegisterEvent("PLAYER_LEAVE_COMBAT");
	PlayerFrame:RegisterEvent("PLAYER_UPDATE_RESTING");
	PlayerFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
	PlayerFrame:RegisterEvent("PARTY_LEADER_CHANGED");
	PlayerFrame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	PlayerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	PlayerFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	PlayerFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	PlayerFrameHealthBar:RegisterEvent("UNIT_HEALTH");
	PlayerFrameHealthBar:RegisterEvent("UNIT_MAXHEALTH");
	PlayerFrameManaBar:RegisterEvent("UNIT_MANA");
	PlayerFrameManaBar:RegisterEvent("UNIT_RAGE");
	PlayerFrameManaBar:RegisterEvent("UNIT_FOCUS");
	PlayerFrameManaBar:RegisterEvent("UNIT_ENERGY");
	PlayerFrameManaBar:RegisterEvent("UNIT_HAPPINESS");
	PlayerFrameManaBar:RegisterEvent("UNIT_MAXMANA");
	PlayerFrameManaBar:RegisterEvent("UNIT_MAXRAGE");
	PlayerFrameManaBar:RegisterEvent("UNIT_MAXFOCUS");
	PlayerFrameManaBar:RegisterEvent("UNIT_MAXENERGY");
	PlayerFrameManaBar:RegisterEvent("UNIT_MAXHAPPINESS");
	PlayerFrameManaBar:RegisterEvent("UNIT_DISPLAYPOWER");
	PlayerFrame:RegisterEvent("UNIT_NAME_UPDATE");
	PlayerFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	PlayerFrame:RegisterEvent("UNIT_DISPLAYPOWER");
	PlayerFrame:Show();
end
function Perl_HideBlizzardPlayer()
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
	PlayerFrame:UnregisterEvent("UNIT_NAME_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE");
	PlayerFrame:UnregisterEvent("UNIT_DISPLAYPOWER");
	PlayerFrame:Hide();
end