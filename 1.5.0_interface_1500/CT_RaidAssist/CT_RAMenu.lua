tinsert(UISpecialFrames, "CT_RAMenuFrame");
CT_RA_Ressers = { };
CT_RA_PartyFrame_IsShown = nil;
CT_RAMenu_Locked = 1;
CT_RA_PartyMembers = { };
CT_RA_CurrCast = nil;
CT_RA_InCombat = nil;

function CT_RAMenu_OnLoad()
	CT_RAMenuFrameHomeButton1Text:SetText("General Options");
	CT_RAMenuFrameHomeButton2Text:SetText("Buff Options");
	CT_RAMenuFrameHomeButton3Text:SetText("Misc Options");
	CT_RAMenuFrameHomeButton4Text:SetText("Additional Options");
	CT_RAMenuFrameHomeButton5Text:SetText("Frequently Asked Questions");

	CT_RAMenuFrameHomeButton1Description:SetText("Change general stuff, such as whether to show mana bars, etc etc.");
	CT_RAMenuFrameHomeButton2Description:SetText("Change the way Buffs and Debuffs are displayed.");
	CT_RAMenuFrameHomeButton3Description:SetText("Things that do not fit in other categories go here.");
	CT_RAMenuFrameHomeButton4Description:SetText("Regulating message spam, scaling of windows, etc.");
	CT_RAMenuFrameHomeButton5Description:SetText("Have problems using the mod? Look here!");
end

function CT_RAMenu_OnShow()
	CT_RAMenu_ShowHome();
	if ( this:GetScale() <= 0.8 ) then
		this:SetScale(0.8);
	end
	CT_RAMenuFrameHomeButton1:SetScale(this:GetScale()/1.09758);
	CT_RAMenuFrameHomeButton2:SetScale(this:GetScale()/1.09758);
	CT_RAMenuFrameHomeButton3:SetScale(this:GetScale()/1.09758);
	CT_RAMenuFrameHomeButton4:SetScale(this:GetScale()/1.09758);
	CT_RAMenuFrameHomeButton5:SetScale(this:GetScale()/1.09758);
end

function CT_RAMenuButton_OnClick()
	CT_RAMenuFrameHome:Hide();
	if ( this:GetID() == 1 ) then
		CT_RAMenuFrameGeneral:Show();
	elseif ( this:GetID() == 2 ) then
		CT_RAMenuFrameBuffs:Show();
	elseif ( this:GetID() == 3 ) then
		CT_RAMenuFrameMisc:Show();
	elseif ( this:GetID() == 4 ) then
		CT_RAMenuFrameAdditional:Show();
	elseif ( this:GetID() == 5 ) then
		CT_RAMenuFrameSort:Show();
	end
end

function CT_RAMenu_ShowHome()
	CT_RAMenuFrameHome:Show();
	CT_RAMenuFrameGeneral:Hide();
	CT_RAMenuFrameBuffs:Hide();
	CT_RAMenuFrameSort:Hide();
	CT_RAMenuFrameMisc:Hide();
	CT_RAMenuFrameAdditional:Hide();
end

function CT_RAMenu_UpdateMenu()
	for i = 1, 6, 1 do
		if ( type(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][i]["type"]) == "table" ) then
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "Text"):SetText(string.gsub(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][i]["type"][CT_RA_GetLocale()], "_", " "));
		else
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "Text"):SetText(string.gsub(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][i]["type"], "_", " "));
		end
		local val = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][i];
		getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "SwatchNormalTexture"):SetVertexColor(val.r, val.g, val.b);

		if ( val["id"] ~= -1 ) then
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "CheckButton"):SetChecked(1);
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "Text"):SetTextColor(1, 1, 1);
		else
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "CheckButton"):SetChecked(nil);
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
		end
	end
	for key, val in CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"] do
		if ( val["show"] ~= -1 ) then
			getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "CheckButton"):SetChecked(1);
			getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "Text"):SetTextColor(1, 1, 1);
		else
			getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "CheckButton"):SetChecked(nil);
			getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "Text"):SetTextColor(0.3, 0.3, 0.3);
		end
		local spell = val["name"][CT_RA_GetLocale()];
		if ( type(spell) == "table" ) then
			getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "Text"):SetText(spell[1]);
			getglobal("CT_RAMenuFrameBuffsBuff" .. key).tooltip = spell[1] .. " & " .. spell[2];
		else
			getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "Text"):SetText(spell);
			getglobal("CT_RAMenuFrameBuffsBuff" .. key).tooltip = nil;
		end
	end
	CT_RAMenuFrameBuffsNotifyDebuffs:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]);

	for i = 1, 8, 1 do
		getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetText("Group " .. i);
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"] or ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["main"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["hidebuffs"] ) ) then
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):Disable();
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "CheckButton"):Disable();
		end
		getglobal("CT_RAMenuFrameBuffsNotifyDebuffs"):SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["main"]);
		getglobal("CT_RAMenuFrameBuffsNotifyBuffs"):SetChecked(not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["hidebuffs"]);

		getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"][i]);
		getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "CheckButton"):SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffsClass"][i]);
	end
	for k, v in CT_RA_ClassPositions do
		if ( k ~= CT_RA_SHAMAN or ( UnitFactionGroup("player") and UnitFactionGroup("player") == "Horde" ) ) then
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. v .. "Text"):SetText(k);
		end
	end
	CT_RAMenuFrameGeneralDisplayShowMPCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"]);
	CT_RAMenuFrameGeneralDisplayShowRPCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"]);
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"] == 32 ) then
		CT_RAMenuFrameGeneralDisplayShowHealthCB:SetChecked(1);
	else
		CT_RAMenuFrameGeneralDisplayShowHealthCB:SetChecked(nil);
	end

	CT_RAMenuFrameGeneralDisplayShowGroupsCB:SetChecked(not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNames"]);
	CT_RAMenuFrameGeneralDisplayLockGroupsCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"]);
	CT_RAMenuFrameGeneralDisplayWindowColorSwatchNormalTexture:SetVertexColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"].b);
	CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].b);
	CT_RAMenuFrameGeneralDisplayAlertColorSwatchNormalTexture:SetVertexColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"].b);

	CT_RA_UpdateRaidGroupColors();
	CT_RA_UpdateRaidMovability();

	for i = 1, 5, 1 do
		getglobal("CT_RAMenuFrameGeneralTargetsTarget" .. i .. "CB"):SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTs"][i]);
	end
	CT_RAMenu_CheckParty();
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] ) then
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"]);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, 5);
	end
	local num = 0;
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] ) then
		for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowGroups"] do
			num = num + 1;
			getglobal("CT_RAOptionsGroupCB" .. k):SetChecked(1);
		end
		if ( num > 0 ) then
			CT_RACheckAllGroups:SetChecked(1);
		else
			CT_RACheckAllGroups:SetChecked(nil);
		end
	else
		for i = 1, 8, 1 do
			getglobal("CT_RAOptionsGroupCB" .. i):SetChecked(nil);
		end
	end
	CT_RAMenuFrameGeneralMiscHideOfflineCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideOffline"]);
	CT_RAMenuFrameGeneralMiscHideNACB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNA"]);
	CT_RAMenuFrameGeneralMiscHideShortCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideShort"]);
	CT_RAMenuFrameBuffsShowDebuffsCheckButton:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"]);
	CT_RAMenuFrameGeneralMiscBorderCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"]);
	CT_RAMenuFrameGeneralMiscHidePartyCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideParty"]);
	CT_RAMenuFrameGeneralMiscHidePartyRaidCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HidePartyRaid"]);
	CT_RAMenuFrameMiscPlayRSSoundCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["PlayRSSound"]);
	CT_RAMenuFrameMiscMaintainTargetCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"]);
	CT_RAMenuFrameMiscSendRARSCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["SendRARS"]);
	CT_RAMenuFrameMiscShowAFKCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowAFK"]);
	CT_RAMenuFrameMiscShowTooltipCB:SetChecked(not CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideTooltip"]);
	CT_RAMenuFrameMiscNotifyGroupChangeCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChange"]);
	CT_RAMenuFrameMiscNotifyGroupChangeCBSound:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChangeSound"]);
	CT_RAMenuFrameMiscNoColorChangeCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideColorChange"]);
	CT_RAMenuFrameMiscShowResMonitorCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"]);
	CT_RAMenuFrameMiscHideButtonCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideButton"]);
	CT_RAMenuFrameMiscShowMTTTCB:SetChecked(CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTTT"]);
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideButton"] ) then
		CT_RASets_Button:Hide();
	else
		CT_RASets_Button:Show();
	end
	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChange"] ) then
		CT_RAMenuFrameMiscNotifyGroupChangeCBSound:Disable();
		CT_RAMenuFrameMiscNotifyGroupChangeSound:SetTextColor(0.3, 0.3, 0.3);
	else
		CT_RAMenuFrameMiscNotifyGroupChangeCBSound:Enable();
		CT_RAMenuFrameMiscNotifyGroupChangeSound:SetTextColor(1, 1, 1);
	end
	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTTT"] ) then
		CT_RAMenuFrameMiscNoColorChangeCB:Disable();
		CT_RAMenuFrameMiscNoColorChange:SetTextColor(0.3, 0.3, 0.3);
	else
		CT_RAMenuFrameMiscNoColorChangeCB:Enable();
		CT_RAMenuFrameMiscNoColorChange:SetTextColor(1, 1, 1);
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"] ) then
		CT_RAMenuGlobalFrame.scaleupdate = 0.1;
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "class" ) then
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 2);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Class");
	elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "custom" ) then
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Custom");
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 3);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 1);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Group");
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] ) then
		local table = { "Show Values", "Show Percentages", "Show Deficit", "Show only MTT HP %" };
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"]);
		CT_RAMenuFrameGeneralDisplayHealthDropDownText:SetText(table[CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"]]);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, 5);
		CT_RAMenuFrameGeneralDisplayHealthDropDownText:SetText("Show None");
	end
	CT_RAMenuMisc_Slider_Update("CT_RAMenuFrameMiscMCSlider1");
	CT_RAMenuMisc_Slider_Update("CT_RAMenuFrameMiscMCSlider2");
	CT_RAMenuMisc_Slider_InitLagSlider("CT_RAMenuFrameMiscMCSlider3");
	CT_RAMenuAdditional_Scaling_OnShow(CT_RAMenuFrameAdditionalScalingSlider1);
	CT_RAMenuAdditional_ScalingMT_OnShow(CT_RAMenuFrameAdditionalScalingSlider2);
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
		CT_RAMenuFrameGeneralChannelChannelEB:SetText(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
	else
		CT_RAMenuFrameGeneralChannelChannelEB:SetText("");
	end
	CT_RAMenu_UpdateWindowPositions();
end

function CT_RAMenuBuffs_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		if ( not CT_RA_ModVersion or CT_RA_ModVersion ~= CT_RA_VersionNumber ) then
			if ( not CT_RA_ModVersion or CT_RA_ModVersion <= 1.08 ) then
				CT_RA_Stats = { };
			end
			if ( not CT_RA_ModVersion or CT_RA_ModVersion < 1.15 ) then
				CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"] = {
					{ show = 1, name = CT_RA_POWERWORDFORTITUDE },
					{ show = 1, name = CT_RA_MARKOFTHEWILD },
					{ show = 1, name = CT_RA_ARCANEINTELLECT },
					{ show = 1, name = CT_RA_ADMIRALSHAT },
					{ show = 1, name = CT_RA_SHADOWPROTECTION },
					{ show = 1, name = CT_RA_POWERWORDSHIELD },
					{ show = 1, name = CT_RA_SOULSTONERESURRECTION },
					{ show = 1, name = CT_RA_DIVINESPIRIT },
					{ show = 1, name = CT_RA_THORNS },
					{ show = 1, name = CT_RA_FEARWARD },
					{ show = 1, name = CT_RA_BLESSINGOFMIGHT },
					{ show = 1, name = CT_RA_BLESSINGOFWISDOM },
					{ show = 1, name = CT_RA_BLESSINGOFKINGS },
					{ show = 1, name = CT_RA_BLESSINGOFSALVATION },
					{ show = 1, name = CT_RA_BLESSINGOFLIGHT },
					{ show = 1, name = CT_RA_BLESSINGOFSANCTUARY },
					{ show = 1, name = CT_RA_RENEW },
					{ show = 1, name = CT_RA_REJUVENATION },
					{ show = 1, name = CT_RA_REGROWTH }
				};
				CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"] = {
					{ ["type"] = CT_RA_CURSE, ["r"] = 1, ["g"] = 0, ["b"] = 0.75, ["a"] = 0.5, ["id"] = 4 },
					{ ["type"] = CT_RA_MAGIC, ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 6 },
					{ ["type"] = CT_RA_POISON, ["r"] = 0, ["g"] = 0.5, ["b"] = 0, ["a"] = 0.5, ["id"] = 3 },
					{ ["type"] = CT_RA_DISEASE, ["g"] = 1, ["b"] = 0, ["a"] = 0.5, ["id"] = 5 },
					{ ["type"] = CT_RA_WEAKENEDSOUL, ["r"] = 1, ["g"] = 0, ["b"] = 1, ["a"] = 0.5, ["id"] = 2 },
					{ ["type"] = CT_RA_RECENTLYBANDAGED, ["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 1 }
				};
				CT_RAMenu_ImportOldSettings();
			end
			if ( not CT_RA_ModVersion or CT_RA_ModVersion < 1.152 ) then
				CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"] = {
					["en"] = {
						["Priest"] = {
							{ { "Heal", "Lesser Heal", "Greater Heal" }, "Lesser Heal, Heal and Greater Heal", 1 },
							{ "Flash Heal", "Flash Heal", 1 }
						},
						["Shaman"] = {
							{ "Healing Wave", "Healing Wave", 1 },
							{ "Lesser Healing Wave", "Lesser Healing Wave", 1 }
						},
						["Druid"] = {
							{ "Healing Touch", "Healing Touch", 1 },
							{ "Regrowth", "Regrowth", 1 }
						},
						["Paladin"] = {
							{ "Holy Light", "Holy Light", 1 },
							{ "Flash of Light", "Flash of Light", 1 }
						}
					},
					["de"] = {
						["Priester"] = {
							{ { "Heilen", "Geringes Heilen", "Gro\195\159e Heilung" }, "Geringes Heilen, Heilen und Gro\195\159e Heilung", 1 },
							{ "Blitzheilung", "Blitzheilung", 1 }
						},
						["Schamane"] = {
							{ "Welle der Heilung", "Welle der Heilung", 1 },
							{ "Geringe Welle der Heilung", "Geringe Welle der Heilung", 1 }
						},
						["Druide"] = {
							{ "Heilende Ber\195\188hrung", "Heilende Ber\195\188hrung", 1 },
							{ "Nachwachsen", "Nachwachsen", 1 }
						},
						["Paladin"] = {
							{ "Heiliges Licht", "Heiliges Licht", 1 },
							{ "Lichtblitz", "Lichtblitz", 1 }
						}
					},
					["fr"] = {
						["Pr\195\170tre"] = {
							{ { "Soins", "Soins mineurs", "Soins sup\195\169rieurs" }, "Soins mineurs, Soins et Soins sup\195\169rieurs", 1 },
							{ "Soins rapides", "Soins rapides", 1 }
						},
						["Chaman"] = {
							{ "Vague de soins", "Vague de soins", 1 },
							{ "Vague de soins mineurs", "Vague de soins mineurs", 1 }
						},
						["Druide"] = {
							{ "Toucher gu\195\169risseur", "Toucher gu\195\169risseur", 1 },
							{ "R\195\169tablissement", "R\195\169tablissement", 1 }
						},
						["Paladin"] = {
							{ "Lumi\195\168re sacr\195\169e", "Lumi\195\168re sacr\195\169e", 1 },
							{ "Eclair lumineux", "Eclair lumineux", 1 }   
						}
					}
				};
				if ( not CT_RA_ModVersion or CT_RA_ModVersion < 1.15 ) then
					DEFAULT_CHAT_FRAME:AddMessage("<CTRaid> Due to new options format, buffs, debuffs and mana conservation options have been reset, please look over your settings.", 1, 1, 0);
				elseif ( CT_RA_ModVersion < 1.153 ) then
					DEFAULT_CHAT_FRAME:AddMessage("<CTRaid> Due to new options format, mana conservation options have been reset, please look over your settings.", 1, 1, 0);
				end
			end
			CT_RA_ModVersion = CT_RA_VersionNumber;
		end
		CT_RAMenu_UpdateMenu();
		CT_RASets_Button:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(CT_RASets_ButtonPosition)), (80 * sin(CT_RASets_ButtonPosition)) - 52);
		if ( CT_RAMenu_Locked == 0 ) then
			CT_RAMenuFrameHomeLock:SetText("Lock");
		end

		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"] and GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		end
		
		CT_RA_UpdateRaidGroup();
	elseif ( event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" ) then
		CT_RAMenu_CheckParty();
	end
end

function CT_RA_Join(channel)
	if ( channel and GetChannelName(channel) == 0 ) then
		local name = channel;
		local zoneChannel, channelName = JoinChannelByName(name, nil, DEFAULT_CHAT_FRAME:GetID());
		if ( channelName ) then
			name = channelName;
		end
		if ( not zoneChannel ) then
			return;
		end
		
		local i = 1;

		while ( DEFAULT_CHAT_FRAME.channelList[i] ) do
			i = i + 1;
		end
		DEFAULT_CHAT_FRAME.channelList[i] = name;
		DEFAULT_CHAT_FRAME.zoneChannelList[i] = zoneChannel;
	end
end
			

function CT_RAMenu_CheckParty()
	if (  ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideParty"] and GetNumRaidMembers() > 0 ) or ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["HidePartyRaid"] and GetNumRaidMembers() == 0 ) ) then
		HidePartyFrame();
	else
		ShowPartyFrame();
	end
	if ( CT_CheckLSidebar ) then
		CT_CheckLSidebar();
	end
end

CT_oldShowPartyFrame = ShowPartyFrame;
function CT_newShowPartyFrame()
	CT_oldShowPartyFrame();
	if ( CT_RA_PartyFrame_IsShown ) then
		CT_RAMenu_CheckParty();
	end
end
ShowPartyFrame = CT_newShowPartyFrame;

function CT_RAMenuNotify_SetChecked()
	if ( this == CT_RAMenuFrameBuffsNotifyDebuffs ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["main"] = this:GetChecked();
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["hidebuffs"] = not this:GetChecked();
	end
	for i = 1, 8, 1 do
		if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["main"] and CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"]["hidebuffs"] ) then
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):Disable();
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "CheckButton"):Disable();
		else
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetTextColor(1, 1, 1);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):Enable();
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "Text"):SetTextColor(1, 1, 1);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. i .. "CheckButton"):Enable();
		end
	end
end

function CT_RAMenuNotifyGroup_SetChecked()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffs"][this:GetParent():GetID()] = this:GetChecked();
end

function CT_RAMenuNotifyClass_SetChecked()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyDebuffsClass"][this:GetParent():GetID()] = this:GetChecked();
end

function CT_RAMenuDebuff_OnClick()
	local frame = this:GetParent();
	local type = getglobal(this:GetParent():GetName() .. "Text"):GetText();
	type = gsub(type, " ", "");
	frame.r = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][frame:GetID()]["r"];
	frame.g = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][frame:GetID()]["g"];
	frame.b = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][frame:GetID()]["b"];
	frame.opacity = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][frame:GetID()]["a"];
	frame.opacityFunc = CT_RAMenuDebuff_SetColor;
	frame.swatchFunc = CT_RAMenuDebuff_SetOpacity;
	frame.hasOpacity = 1;
	ColorPickerFrame.frame = frame;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function CT_RAMenuDebuff_SetColor()
	local type = getglobal(ColorPickerFrame.frame:GetName() .. "Text"):GetText();
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][ColorPickerFrame.frame:GetID()]["r"] = r;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][ColorPickerFrame.frame:GetID()]["g"] = g;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][ColorPickerFrame.frame:GetID()]["b"] = b;
	getglobal(ColorPickerFrame.frame:GetName() .. "SwatchNormalTexture"):SetVertexColor(r, g, b);
end

function CT_RAMenuDebuff_SetOpacity()
	local type = getglobal(ColorPickerFrame.frame:GetName() .. "Text"):GetText();
	local a = OpacitySliderFrame:GetValue();
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][ColorPickerFrame.frame:GetID()]["a"] = a;
end

function CT_RAMenuBuff_Move(move)

	if ( string.find(this:GetParent():GetName(), "Debuff") ) then
		-- Debuff
		if ( not getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text") ) then return; end
		local temp = getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text"):GetText();
		local temp2 = getglobal(this:GetParent():GetName() .. "Text"):GetText();
		getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text"):SetText(temp2);
		getglobal(this:GetParent():GetName() .. "Text"):SetText(temp);

		local temparr = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][this:GetParent():GetID()];
		local temparr2 = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][this:GetParent():GetID()+move];
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][this:GetParent():GetID()] = temparr2;
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][this:GetParent():GetID()+move] = temparr;

		getglobal("CT_RAMenuFrameBuffsDebuff" .. this:GetParent():GetID()+move .. "SwatchNormalTexture"):SetVertexColor(temparr.r, temparr.g, temparr.b);
		getglobal("CT_RAMenuFrameBuffsDebuff" .. this:GetParent():GetID() .. "SwatchNormalTexture"):SetVertexColor(temparr2.r, temparr2.g, temparr2.b);

		if ( temparr2["id"] ~= -1 ) then
			getglobal(this:GetParent():GetName() .. "CheckButton"):SetChecked(1);
			getglobal(this:GetParent():GetName() .. "Text"):SetTextColor(1, 1, 1);
		else
			getglobal(this:GetParent():GetName() .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal(this:GetParent():GetName() .. "CheckButton"):SetChecked(nil);
		end
		if ( temparr["id"] ~= -1 ) then
			getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "CheckButton"):SetChecked(1);
			getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text"):SetTextColor(1, 1, 1);
		else
			getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "CheckButton"):SetChecked(nil);
		end

	else
		-- Buff
		if ( not getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "Text") ) then return; end
		local temp = getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "Text"):GetText();
		local temp2 = getglobal(this:GetParent():GetName() .. "Text"):GetText();
		getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "Text"):SetText(temp2);
		getglobal(this:GetParent():GetName() .. "Text"):SetText(temp);

		local temparr = CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"][this:GetParent():GetID()];
		local temparr2 = CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"][this:GetParent():GetID()+move];
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"][this:GetParent():GetID()] = temparr2;
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"][this:GetParent():GetID()+move] = temparr;
		if ( temparr2["show"] ~= -1 ) then
			getglobal(this:GetParent():GetName() .. "CheckButton"):SetChecked(1);
			getglobal(this:GetParent():GetName() .. "Text"):SetTextColor(1, 1, 1);
		else
			getglobal(this:GetParent():GetName() .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal(this:GetParent():GetName() .. "CheckButton"):SetChecked(nil);
		end
		if ( temparr["show"] ~= -1 ) then
			getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "CheckButton"):SetChecked(1);
			getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "Text"):SetTextColor(1, 1, 1);
		else
			getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsBuff" .. (this:GetParent():GetID()+move) .. "CheckButton"):SetChecked(nil);
		end
	end
	CT_RA_UpdateRaidGroup();
end
	
function CT_RAMenuBuff_ShowToggle()
	local newid;
	if ( this:GetChecked() ) then
		newid = this:GetParent():GetID();
		getglobal(this:GetParent():GetName() .. "Text"):SetTextColor(1, 1, 1);
	else
		getglobal(this:GetParent():GetName() .. "Text"):SetTextColor(0.3, 0.3, 0.3);
		newid = -1;
	end
	local type = getglobal(this:GetParent():GetName() .. "Text"):GetText();
	if ( string.find(this:GetParent():GetName(), "Debuff") ) then
		-- Debuff
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["DebuffColors"][this:GetParent():GetID()].id = newid;
	else
		-- Buff
		if ( this:GetChecked() ) then
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"][this:GetParent():GetID()]["show"] = 1;
		else
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["BuffArray"][this:GetParent():GetID()]["show"] = -1;
		end
	end
	CT_RA_UpdateRaidGroup();
end


function CT_RAMenu_General_JoinChannel()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) == 0 ) then
		local name = CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"];
		local zoneChannel, channelName = JoinChannelByName(name, nil, DEFAULT_CHAT_FRAME:GetID());
		if ( channelName ) then
			name = channelName;
		end
		if ( not zoneChannel ) then
			return;
		end
		
		local i = 1;

		while ( DEFAULT_CHAT_FRAME.channelList[i] ) do
			i = i + 1;
		end
		DEFAULT_CHAT_FRAME.channelList[i] = name;
		DEFAULT_CHAT_FRAME.zoneChannelList[i] = zoneChannel;
	end
end

function CT_RAMenu_General_EditChannel()
	if ( not this.editing ) then
		this.editing = 1;
		this:SetText("Set and Join Channel");
		getglobal(this:GetParent():GetName() .. "ChannelEB"):Show();
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
			getglobal(this:GetParent():GetName() .. "ChannelEB"):SetText(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
			getglobal(this:GetParent():GetName() .. "ChannelEB"):HighlightText();
		else
			getglobal(this:GetParent():GetName() .. "ChannelEB"):SetText("");
		end
		getglobal(this:GetParent():GetName() .. "ChannelNameText"):Hide();
		getglobal(this:GetParent():GetName() .. "BroadcastChannel"):Disable();
	else
		this:SetText("Edit Channel");
		getglobal(this:GetParent():GetName() .. "BroadcastChannel"):Enable();
		this.editing = nil;

		local name = getglobal(this:GetParent():GetName() .. "ChannelEB"):GetText();
		if ( strsub(name, strlen(name)) == " " ) then
			name = strsub(name, 1, strlen(name)-1);
		end
		getglobal(this:GetParent():GetName() .. "ChannelEB"):Hide();
		
		local new;
		if ( strlen(name) > 0 ) then
			new = name;
			getglobal(this:GetParent():GetName() .. "ChannelNameText"):SetText(name);
		else
			new = nil;
			getglobal(this:GetParent():GetName() .. "ChannelNameText"):SetText("<No Channel>");
		end
		if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ~= new or ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] and GetChannelName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]) == 0 ) ) then
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
				LeaveChannelByName(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
			end
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] = new;
			CT_RA_Join(new);
		end
		getglobal(this:GetParent():GetName() .. "ChannelNameText"):Show();
	end
end

function CT_RAMenu_General_ChannelOnShow()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"] ) then
		getglobal(this:GetName() .. "ChannelNameText"):SetText(CT_RAMenu_Options[CT_RAMenu_CurrSet]["Channel"]);
	else
		getglobal(this:GetName() .. "ChannelNameText"):SetText("<No Channel>");
	end
	local edit = getglobal(this:GetName() .. "EditChannel");
	getglobal(this:GetName() .. "BroadcastChannel"):Enable();
	edit:SetText("Edit Channel");
	edit.editing = nil;
	getglobal(this:GetName() .. "ChannelEB"):Hide();
	getglobal(this:GetName() .. "ChannelNameText"):Show();
	for k, v in CT_RA_ClassPositions do
		if ( k ~= CT_RA_SHAMAN or ( UnitFactionGroup("player") and UnitFactionGroup("player") == "Horde" ) ) then
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsClass" .. v .. "Text"):SetText(k);
		end
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "class" ) then
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 2);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Class");
	elseif ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] == "custom" ) then
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Custom");
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 3);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 1);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Group");
	end
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] ) then
		local table = { "Show Values", "Show Percentages", "Show Deficit", "Show only MTT HP %" };
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"]);
		CT_RAMenuFrameGeneralDisplayHealthDropDownText:SetText(table[CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"]]);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, 5);
		CT_RAMenuFrameGeneralDisplayHealthDropDownText:SetText("Show None");
	end
end

function CT_RAMenu_General_BroadcastChannel()
	SlashCmdList["RA"]("broadcast");
end

function CT_RAMenuDisplay_ShowMP()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideMP"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowRP()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideRP"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowHealth()
	if ( not this:GetChecked() ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"] = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"]+8;
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"] = CT_RAMenu_Options[CT_RAMenu_CurrSet]["MemberHeight"]-8;
	end
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowHP()
	if ( this:GetChecked() ) then
		if ( CT_RAMenuFrameGeneralDisplayShowHPPercentCB:GetChecked() ) then
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = 2;
		else
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = 1;
		end
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = nil;
	end
	if ( this:GetChecked() ) then
		CT_RAMenuFrameGeneralDisplayHealthPercentsText:SetTextColor(1, 1, 1);
		CT_RAMenuFrameGeneralDisplayShowHPPercentCB:Enable();
		CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].r, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].g, CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"].b);
		CT_RAMenuFrameGeneralDisplayShowHPSwatchBG:SetVertexColor(1, 1, 1);
	else
		CT_RAMenuFrameGeneralDisplayHealthPercentsText:SetTextColor(0.3, 0.3, 0.3);
		CT_RAMenuFrameGeneralDisplayShowHPPercentCB:Disable();
		CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(0.3, 0.3, 0.3);
		CT_RAMenuFrameGeneralDisplayShowHPSwatchBG:SetVertexColor(0.3, 0.3, 0.3);
	end
	for i = 1, GetNumRaidMembers(), 1 do
		if ( CT_RA_Stats[UnitName("raid" .. i)] ) then
			CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), CT_RA_Stats[UnitName("raid" .. i)]["Health"], CT_RA_Stats[UnitName("raid" .. i)]["Healthmax"]);
		end
	end
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowHPPercents()
	if ( this:GetChecked() ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = 2;
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = 1;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		if ( CT_RA_Stats[UnitName("raid" .. i)] ) then
			CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), CT_RA_Stats[UnitName("raid" .. i)]["Health"], CT_RA_Stats[UnitName("raid" .. i)]["Healthmax"]);
		end
	end
end

function CT_RAMenuDisplay_ShowGroupNames()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNames"] = not this:GetChecked();
	CT_RA_UpdateVisibility();
end

function CT_RAMenuDisplay_ChangeWC()
	local frame = this:GetParent();
	frame.r = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["r"];
	frame.g = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["g"];
	frame.b = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["b"];
	frame.opacity = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["a"];
	frame.opacityFunc = CT_RAMenuDisplay_SetOpacity;
	frame.swatchFunc = CT_RAMenuDisplay_SetColor;
	frame.cancelFunc = CT_RAMenuDisplay_CancelColor;
	frame.hasOpacity = 1;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function CT_RAMenuDisplay_SetColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["r"] = r;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["g"] = g;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["b"] = b;
	CT_RAMenuFrameGeneralDisplayWindowColorSwatchNormalTexture:SetVertexColor(r, g, b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplay_SetOpacity()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["a"] = OpacitySliderFrame:GetValue();
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplay_CancelColor(val)
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["r"] = val.r;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["g"] = val.g;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["b"] = val.b;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultColor"]["a"] = val.opacity;
	CT_RAMenuFrameGeneralDisplayWindowColorSwatchNormalTexture:SetVertexColor(val.r, val.g, val.b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplay_LockGroups()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["LockGroups"] = this:GetChecked();
	CT_RA_UpdateVisibility();
end

function CT_RAMenuTarget_Toggle()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTs"][this:GetID()] = this:GetChecked();
	CT_RA_UpdateMTs();
end

function CT_RAMenuFrameGeneralMiscDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CT_RAMenuFrameGeneralMiscDropDown_Initialize);
	UIDropDownMenu_SetWidth(130);
	UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 1);
end

function CT_RAMenuFrameGeneralMiscDropDown_Initialize()
	local info = {};
	info.text = "Group";
	info.func = CT_RAMenuFrameGeneralMiscDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Class";
	info.func = CT_RAMenuFrameGeneralMiscDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Custom";
	info.func = CT_RAMenuFrameGeneralMiscDropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end


function CT_RAMenuFrameGeneralMiscDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, this:GetID());
	if ( this:GetID() == 1 ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "group";
	elseif ( this:GetID() == 2 ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "class";
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["SORTTYPE"] = "custom";
	end
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
	CT_RAOptions_Update();
end

function CT_RAMenuFrameGeneralDisplayHealthDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CT_RAMenuFrameGeneralDisplayHealthDropDown_Initialize);
	UIDropDownMenu_SetWidth(130);
	UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, 1);
end

function CT_RAMenuFrameGeneralDisplayHealthDropDown_Initialize()
	local info = {};
	info.text = "Show Values";
	info.func = CT_RAMenuFrameGeneralDisplayHealthDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Show Percentages";
	info.func = CT_RAMenuFrameGeneralDisplayHealthDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Show Deficit";
	info.func = CT_RAMenuFrameGeneralDisplayHealthDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Show only MTT HP %";
	info.func = CT_RAMenuFrameGeneralDisplayHealthDropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Show None";
	info.func = CT_RAMenuFrameGeneralDisplayHealthDropDown_OnClick;
	UIDropDownMenu_AddButton(info);
end


function CT_RAMenuFrameGeneralDisplayHealthDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, this:GetID());
	if ( this:GetID() < 5 ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = this:GetID();
	else
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] = nil;
	end
	CT_RA_UpdateRaidGroup();
	CT_RAOptions_Update();
end

function CT_RAMenu_General_ResetWindows()
	CT_RAGroupDrag1:ClearAllPoints();
	CT_RAGroupDrag2:ClearAllPoints();
	CT_RAGroupDrag3:ClearAllPoints();
	CT_RAGroupDrag4:ClearAllPoints();
	CT_RAGroupDrag5:ClearAllPoints();
	CT_RAGroupDrag6:ClearAllPoints();
	CT_RAGroupDrag7:ClearAllPoints();
	CT_RAGroupDrag8:ClearAllPoints();
	CT_RAMTGroupDrag:ClearAllPoints();

	CT_RAGroupDrag1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 950, -35);
	CT_RAGroupDrag2:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 950, -275);
	CT_RAGroupDrag3:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 855, -35);
	CT_RAGroupDrag4:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 855, -275);
	CT_RAGroupDrag5:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 760, -35);
	CT_RAGroupDrag6:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 760, -275);
	CT_RAGroupDrag7:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 665, -35);
	CT_RAGroupDrag8:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 665, -275);
	CT_RAMTGroupDrag:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 570, -35);
end

function CT_RAMenuGeneral_HideParty()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideParty"] = this:GetChecked();
	CT_RAMenu_CheckParty();
end

function CT_RAMenuGeneral_HidePartyOutOfRaid()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HidePartyRaid"] = this:GetChecked();
	CT_RAMenu_CheckParty();
end

function CT_RAMenuDisplay_ChangeAC()
	local frame = this:GetParent();
	frame.r = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["r"];
	frame.g = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["g"];
	frame.b = CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["b"];
	frame.swatchFunc = CT_RAMenuDisplay_SetAlertColor;
	frame.cancelFunc = CT_RAMenuDisplay_CancelAlertColor;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function CT_RAMenuDisplay_SetAlertColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["r"] = r;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["g"] = g;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["b"] = b;
	CT_RAMenuFrameGeneralDisplayAlertColorSwatchNormalTexture:SetVertexColor(r, g, b);
end

function CT_RAMenuDisplay_CancelAlertColor(val)
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["r"] = val.r;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["g"] = val.g;
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["DefaultAlertColor"]["b"] = val.b;
	CT_RAMenuFrameGeneralDisplayAlertColorSwatchNormalTexture:SetVertexColor(val.r, val.g, val.b);
end

function CT_RAMenuDisplay_ChangeTC()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowHP"] ) then
		local frame = this:GetParent();
		frame.r = CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"]["r"];
		frame.g = CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"]["g"];
		frame.b = CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"]["b"];
		frame.swatchFunc = CT_RAMenuDisplayPercent_SetColor;
		frame.cancelFunc = CT_RAMenuDisplayPercent_CancelColor;
		CloseMenus();
		UIDropDownMenuButton_OpenColorPicker(frame);
	end
end

function CT_RAMenuDisplayPercent_SetColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"] = { ["r"] = r, ["g"] = g, ["b"] = b };
	CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(r, g, b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplayPercent_CancelColor(val)
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["PercentColor"] = { r = val.r, g = val.g, b = val.b };
	CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(val.r, val.g, val.b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuGeneral_HideOffline()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideOffline"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuGeneral_HideNA()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideNA"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuGeneral_HideShort()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideShort"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuBuff_ShowDebuffs()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowDebuffs"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuGeneral_HideBorder()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideBorder"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
end


function CT_RAMenuMisc_Slider_OnChange()
	local spell = CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")][this:GetID()];
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")][this:GetID()][3] = this:GetValue()/100;
	if ( type(spell[1]) == "table" ) then
		getglobal(this:GetName() .. "Text"):SetText(spell[1][1] .. " - " .. this:GetValue() .. "%");
	else
		getglobal(this:GetName() .. "Text"):SetText(spell[1] .. " - " .. this:GetValue() .. "%");
	end
end

function CT_RAMenuMisc_Slider_OnShow()

end

function CT_RAMenuMisc_Slider_Update(slider)
	slider = getglobal(slider);
	if ( UnitClass("player") and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")] ) then -- Assumes there are two heals/healing class
		getglobal(slider:GetName().."High"):SetText("100%");
		getglobal(slider:GetName().."Low"):SetText("0%");
		slider.tooltipText = CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")][slider:GetID()][2];
		slider:SetMinMaxValues(0, 100);
		slider:SetValueStep(1);
		slider:Show();
		getglobal(slider:GetParent():GetName() .. "NoHealer"):Hide();
		getglobal(slider:GetParent():GetName() .. "Healer"):Show();

		local spell = CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")][slider:GetID()];
		slider:SetValue(spell[3]*100);
		if ( type(spell[1]) == "table" ) then
			getglobal(slider:GetName() .. "Text"):SetText(spell[1][1] .. " - " .. slider:GetValue() .. "%");
		else
			getglobal(slider:GetName() .. "Text"):SetText(spell[1] .. " - " .. slider:GetValue() .. "%");
		end
	else
		getglobal(slider:GetParent():GetName() .. "NoHealer"):Show();
		getglobal(slider:GetParent():GetName() .. "Healer"):Hide();
		slider:Hide();
	end
end

function CT_RAMenuMisc_Slider_InitLagSlider(slider)
	slider = getglobal(slider);
	if ( UnitClass("player") and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")] ) then
		slider:Show();
		getglobal(slider:GetName().."High"):SetText("1.5 sec");
		getglobal(slider:GetName().."Low"):SetText("0.5 sec");
		getglobal(slider:GetName() .. "Text"):SetText("Check Time - " .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["SpellCastDelay"] .. " sec");
		slider.tooltipText = "Adjust the time when the 'mana conserve' point checks your targets health.  If you set 0.5 sec, the heal will cancel 0.5 seconds before it would cast. However if you lag, you may want to set it higher, so it would check earlier before the cast would occur.";
		slider:SetMinMaxValues(0.5, 1.5);
		slider:SetValueStep(0.05);
		slider:SetValue(CT_RAMenu_Options[CT_RAMenu_CurrSet]["SpellCastDelay"]);
		slider:Show();
	else
		slider:Hide();
	end
end

function CT_RAMenuMisc_LagSlider_OnValueChanged()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["SpellCastDelay"] = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("Check Time - " .. CT_RAMenu_Options[CT_RAMenu_CurrSet]["SpellCastDelay"] .. " sec");
end

function CT_RAMenuMisc_Schedule(time)
	this.update = time;
end

function CT_RAMenuMisc_OnUpdate(elapsed)
	if ( this.scaleupdate ) then
		this.scaleupdate = this.scaleupdate - elapsed;
		if ( this.scaleupdate <= 0 ) then
			this.scaleupdate = nil;
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"] ) then
				for i = 1, 40, 1 do
					if ( i <= 8 ) then
						getglobal("CT_RAGroupDrag" .. i):SetWidth(CT_RAGroup1:GetWidth()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]+(22*CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]));
						getglobal("CT_RAGroupDrag" .. i):SetHeight(CT_RAMember1:GetHeight()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]/2);
						getglobal("CT_RAGroup" .. i):SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]);
					end
					getglobal("CT_RAMember" .. i):SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]);
				end
			end
			if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"] ) then
				for i = 1, 5, 1 do
					getglobal("CT_RAMTGroupMember" .. i):SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]);
				end
				CT_RAMTGroup:SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]);
				CT_RAMTGroupDrag:SetWidth(CT_RAMTGroup:GetWidth()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]+(22*CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]));
				CT_RAMTGroupDrag:SetHeight(CT_RAMTGroupMember1:GetHeight()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]/2);
			end
		end
	end

	if ( this.update ) then
		this.update = this.update - elapsed;
		if ( this.update <= 0 ) then
			this.update = nil;
			CT_RAMenuMisc_CheckTargetHealth();
			CT_RA_CurrCast = nil;
		end
	end
end

function CT_RAMenuMisc_CheckTargetHealth()
	if ( not CT_RA_CurrCast or IsControlKeyDown() or not CT_RA_InCombat ) then return; end
	for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")] do
		if ( type(v[1]) == "table" and v[3] < 1 ) then
			for key, val in v[1] do
				if ( val == CT_RA_CurrCast[1] ) then
					if ( CT_RA_CurrCast[2] == "target" ) then
						if ( not UnitExists("target") or CT_RA_CurrCast[3] ~= UnitName("target") ) then
							return; -- Can't process health here
						end
					end
					if ( UnitExists(CT_RA_CurrCast[2]) and UnitHealth(CT_RA_CurrCast[2])/UnitHealthMax(CT_RA_CurrCast[2]) >= v[3] ) then
						CT_RA_Print("<CTRaid> Aborted spell '|c00FFFFFF" .. CT_RA_CurrCast[1] .. "|r'.", 1, 0.5, 0);
						SpellStopCasting();
						return;
					end
				end
			end
		elseif ( v[1] == CT_RA_CurrCast[1] and v[3] < 1 ) then
			if ( CT_RA_CurrCast[2] == "target" ) then
				if ( not UnitExists("target") or CT_RA_CurrCast[3] ~= UnitName("target") ) then
					return; -- Can't process health here
				end
			end
			if ( UnitExists(CT_RA_CurrCast[2]) and UnitHealth(CT_RA_CurrCast[2])/UnitHealthMax(CT_RA_CurrCast[2]) >= v[3] ) then
				CT_RA_Print("<CTRaid> Aborted spell '|c00FFFFFF" .. CT_RA_CurrCast[1] .. "|r'.", 1, 0.5, 0);
				SpellStopCasting();
				return;
			end
		end
	end
end

function CT_RA_SpellStartCast(spell)
	if ( spell[1] == CT_RA_RESURRECTION[CT_RA_GetLocale()] or spell[1] == CT_RA_ANCESTRALSPIRIT[CT_RA_GetLocale()] or spell[1] == CT_RA_REBIRTH[CT_RA_GetLocale()] or spell[1] == CT_RA_REDEMPTION[CT_RA_GetLocale()] ) then
		CT_RA_AddMessage("RES " .. spell[2]);
		CT_RA_Ressers[UnitName("player")] = spell[2];
		CT_RA_UpdateResFrame();
	end
end

function CT_RA_SpellEndCast()
	if ( CT_RA_Ressers[UnitName("player")] ) then
		CT_RA_AddMessage("RESNO");
	end
end

function CT_RAMenuMisc_OnEvent(event)
	if ( event == "SPELLCAST_START" and CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")] ) then
		if ( not CT_RA_SpellTarget and UnitExists("target") and UnitIsFriend("player", "target") ) then
			CT_RA_SpellTarget = "target";
		elseif ( not CT_RA_SpellTarget and UnitExists("mouseover") ) then
			return; -- Can't check on mouseover :(
		end
		if ( not CT_RA_SpellTarget ) then return; end
		for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["ClassHealings"][CT_RA_GetLocale()][UnitClass("player")] do
			if ( type(v[1]) == "table" ) then
				for key, val in v[1] do
					if ( val == arg1 ) then
						CT_RA_CurrCast = { arg1, CT_RA_SpellTarget, UnitName(CT_RA_SpellTarget) };

						local time = (arg2/1000)-CT_RAMenu_Options[CT_RAMenu_CurrSet]["SpellCastDelay"];
						if ( time < 0 ) then
							time = 0;
						end
						CT_RAMenuMisc_Schedule(time);
						return;
					end
				end
			elseif ( v[1] == arg1 ) then
				CT_RA_CurrCast = { arg1, CT_RA_SpellTarget, UnitName(CT_RA_SpellTarget) };
				local time = (arg2/1000)-CT_RAMenu_Options[CT_RAMenu_CurrSet]["SpellCastDelay"];
				if ( time < 0 ) then
					time = 0;
				end
				CT_RAMenuMisc_Schedule(time);
				return;
			end
		end
	elseif ( event == "SPELLCAST_INTERRUPTED" or event == "SPELLCAST_STOP" or event == "SPELLCAST_FAILED" ) then
		CT_RA_CurrCast = nil;
		CT_RA_SpellTarget = nil;
	elseif ( event == "PLAYER_REGEN_ENABLED" ) then
		CT_RA_InCombat = nil;
	elseif ( event == "PLAYER_REGEN_DISABLED" ) then
		CT_RA_InCombat = 1;
	end
end

function CT_RAMenuAdditional_Scaling_OnShow(slider)
	if ( not slider ) then
		slider = this;
	end
	getglobal(slider:GetName().."High"):SetText("150%");
	getglobal(slider:GetName().."Low"):SetText("50%");
	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"] ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"] = floor(CT_RAGroup1:GetScale()*100+0.5)/100;
	end
	getglobal(slider:GetName() .. "Text"):SetText("Group Scaling - " .. floor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]*100+0.5) .. "%");

	slider:SetMinMaxValues(0.5, 1.5);
	slider:SetValueStep(0.01);
	slider:SetValue(CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]);
end

function CT_RAMenuAdditional_Scaling_OnValueChanged()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"] = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("Group Scaling - " .. floor(this:GetValue()*100+0.5) .. "%");
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i):SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]);
			getglobal("CT_RAGroupDrag" .. i):SetWidth(CT_RAGroup1:GetWidth()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]+(22*CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]));
			getglobal("CT_RAGroupDrag" .. i):SetHeight(CT_RAMember1:GetHeight()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]/2);
		end
		getglobal("CT_RAMember" .. i):SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowScaling"]);
	end
end

function CT_RAMenuAdditional_ScalingMT_OnShow(slider)
	if ( not slider ) then
		slider = this;
	end
	getglobal(slider:GetName().."High"):SetText("150%");
	getglobal(slider:GetName().."Low"):SetText("50%");
	if ( not CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"] ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"] = floor(CT_RAMTGroup:GetScale()*100+0.5)/100;
	end
	getglobal(slider:GetName() .. "Text"):SetText("MT Scaling - " .. floor(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]*100+0.5) .. "%");

	slider:SetMinMaxValues(0.5, 1.5);
	slider:SetValueStep(0.01);
	slider:SetValue(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]);
end

function CT_RAMenuAdditional_ScalingMT_OnValueChanged()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"] = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("MT Scaling - " .. floor(this:GetValue()*100+0.5) .. "%");
	for i = 1, 5, 1 do
		getglobal("CT_RAMTGroupMember" .. i):SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]);
	end
	CT_RAMTGroup:SetScale(CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]);

	CT_RAMTGroupDrag:SetWidth(CT_RAMTGroup:GetWidth()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]+(22*CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]));
	CT_RAMTGroupDrag:SetHeight(CT_RAMTGroupMember1:GetHeight()*CT_RAMenu_Options[CT_RAMenu_CurrSet]["MTScaling"]/2);
end

function CT_RA_GetLocale()
	--return "en";
	local locale = strsub(GetLocale(), 1, 2);
	if ( locale == "fr" or locale == "de" ) then
		return locale;
	else
		return "en";
	end
end

function CT_RAMenu_Misc_PlaySound()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["PlayRSSound"] = this:GetChecked();
end

function CT_RAMenu_Misc_MaintainTarget()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["MaintainTarget"] = this:GetChecked();
end

function CT_RAMenu_Misc_SendRARS()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["SendRARS"] = this:GetChecked();
end

function CT_RAMenu_Misc_ShowAFK()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowAFK"] = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenu_Misc_ShowMTTT()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMTTT"] = this:GetChecked();
	if ( not this:GetChecked() ) then
		CT_RAMenuFrameMiscNoColorChangeCB:Disable();
		CT_RAMenuFrameMiscNoColorChange:SetTextColor(0.3, 0.3, 0.3);
	else
		CT_RAMenuFrameMiscNoColorChangeCB:Enable();
		CT_RAMenuFrameMiscNoColorChange:SetTextColor(1, 1, 1);
	end
	CT_RA_UpdateMTs();
end

function CT_RAMenu_Misc_NoColorChange()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideColorChange"] = this:GetChecked();
end

function CT_RAMenu_Misc_ShowTooltip()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideTooltip"] = not this:GetChecked();
end

function CT_RAMenu_Misc_ShowResMonitor()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["ShowMonitor"] = this:GetChecked();
		if ( this:GetChecked() and GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		else
			CT_RA_ResFrame:Hide();
		end
end

function CT_RAMenu_Misc_HideButton()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["HideButton"] = this:GetChecked();
	if ( this:GetChecked() ) then
		CT_RASets_Button:Hide();
	else
		CT_RASets_Button:Show();
	end
end

function CT_RAMenu_Misc_NotifyGroupChange()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChange"] = this:GetChecked();
	if ( not this:GetChecked() ) then
		CT_RAMenuFrameMiscNotifyGroupChangeCBSound:Disable();
		CT_RAMenuFrameMiscNotifyGroupChangeSound:SetTextColor(0.3, 0.3, 0.3);
	else
		CT_RAMenuFrameMiscNotifyGroupChangeCBSound:Enable();
		CT_RAMenuFrameMiscNotifyGroupChangeSound:SetTextColor(1, 1, 1);
	end
end

function CT_RAMenu_Misc_NotifyGroupChangeSound()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["NotifyGroupChangeSound"] = this:GetChecked();
end

function CT_RA_UpdateResFrame()
	local text = "";
	for key, val in CT_RA_Ressers do
		if ( strlen(text) > 0 ) then
			text = text .. "\n";
		end
		text = text .. key .. ": " .. val;
	end
	if ( text == "" ) then
		text = "No current resurrections";
	end
	CT_RA_ResFrameText:SetText(text);
	CT_RA_ResFrame:SetWidth(max(CT_RA_ResFrameText:GetWidth()+15, 175));
	CT_RA_ResFrame:SetHeight(max(CT_RA_ResFrameText:GetHeight()+25, 50));
end

function CT_RAMenuHelp_LoadText()
	local texts = {
		"|c00FFFFFFShow Group Names -|r Turns on/off the headers for each group\n\n|c00FFFFFFLock Group Poisitions -|r Locks all CTRA windows in place\n\n|c00FFFFFFHide Mana Bars -|r Hides all players mana bars\n\n|c00FFFFFFHide Health Bars -|r Hides all players health bars\n\n|c00FFFFFFHide Rage/Energy Bars -|r Hides all players rage and energy bars\n\n|c00FFFFFFHealth Type -|r Allows you to show players health as a percentage,\nactual value, missing hp, only the percentage on MainTank targets,\nor not at all. You can also customize the color the text is shown in\n\n|c00FFFFFFWindow BG Color -|r Changes the color of CTRA window\nbackgrounds, dragging the slider all the way to 100%\nmakes them transparent\n\n|c00FFFFFFAlert Message Color -|r Sets the color the /rs alert messages\nshow in the middle of your screen",
		"|c00FFFFFFHide party frame -|r Hides your group members when in a raid\n\n|c00FFFFFFHide party frame out of raid -|r Hides your party frame when\nout of raids, primarily used for users of UI mods that use\nalternate party frames\n\n|c00FFFFFFHide offline members -|r Allows you to hide members who\nare offline, so they don't show in CTRA groups\n\n|c00FFFFFFHide short duration debuffs -|r Allows you to hide debuffs with\na duration under 10 seconds\n\n|c00FFFFFFHide border -|r Allows you to hide the border of each CTRA window\n\n|c00FFFFFFSort Type -|r Sort by either group, class, or custom.Sorting\nby Class displays each member in a class category, sorting\nby Custom allows you to change who shows up in which groups",
		"|c00FFFFFFEdit Channel -|r Allows you to change the CTRaid channel.\nClicking the button again will set and join the new channel,\nleaving any old channels\n\n|c00FFFFFFBroadcast Channel -|r Broadcasts your CTRaid channel to the\nCTRA users in your raid. This will automatically join the channel\nfor these users. Requires a status of promoted or leader",
		"Turning on a unit's target allows you to see\nwhat that player has targeted. Raid Leaders\nand Promoted can set MTs (Main Tanks) via\nthe CTRaid tab by right clicking and setting\nthat player as a MT",
		"Allows you to be notified via chat when someone\nbecomes debuffed with the types listed above,\nas well as allows you to be notified when someone\nloses a buff you are able to recast\n\n|c00FFFFFFNOTE:|r To quickly debuff a cured player, or recast a\nfaded buff, map a hotkey via the game key bindings\nmenu (|c00FFFFFFEscape|r > |c00FFFFFFKey Bindings|r > |c00FFFFFFCT_RaidAssist section|r)\nto one-click recast or cure";
		"Allows you to have CTRA cancel healing spells\nif the target has above a certain percentage of health.\n\n|c00FFFFFFCheck Time -|r Sets the amount of time before\n a healing spell lands to perform the health check.\n\n|c00FFFFFFNOTE:|r Only visible if you have any healing spells.",
		"Allows you to control how often CTRA sends messages.",
		"Allows you to scale the CTRA group and MT windows.",
		CT_RAMENU_BUFFSDESCRIPT,
		"Various Additional Options settings",
		"Frequently Asked Questions about CTRA and its uses",
		CT_RAMENU_FAQANSWER1,
		CT_RAMENU_FAQANSWER2,
		CT_RAMENU_FAQANSWER3,
		CT_RAMENU_FAQANSWER4,
		CT_RAMENU_FAQANSWER5,
		CT_RAMENU_FAQANSWER6,
		CT_RAMENU_FAQANSWER7,
		CT_RAMENU_FAQANSWER8,
		CT_RAMENU_FAQANSWER9,
		CT_RAMENU_FAQANSWER10,
		CT_RAMENU_FAQANSWER11,
		CT_RAMENU_BUFFSTOOLTIP,
		CT_RAMENU_DEBUFFSTOOLTIP
	};
	this.text = texts[this:GetID()];
end

function CT_RAMenuHelp_SetTooltip()
	local uiX, uiY = UIParent:GetCenter();
	local thisX, thisY = this:GetCenter();

	local anchor = "";
	if ( thisY > uiY ) then
		anchor = "BOTTOM";
	else
		anchor = "TOP";
	end
	
	if ( thisX < uiX  ) then
		if ( anchor == "TOP" ) then
			anchor = "TOPLEFT";
		else
			anchor = "BOTTOMRIGHT";
		end
	else
		if ( anchor == "TOP" ) then
			anchor = "TOPRIGHT";
		else
			anchor = "BOTTOMLEFT";
		end
	end
	GameTooltip:SetOwner(this, "ANCHOR_" .. anchor);
end

function CT_RAMenu_Set(name, check)
	CT_RAMenu_Options[CT_RAMenu_CurrSet][name] = check;
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
	CT_RAOptions_Update();
end

function CT_RAMenu_ImportOldSettings()
	local tbl = {
		Channel = CT_RA_Channel,
		DebuffColors = CT_RA_DebuffColors,
		MemberHeight = CT_RA_MemberHeight,
		HideNames = CT_RA_MemberHeight,
		DefaultColor = CT_RA_DefaultColor,
		LockGroups = CT_RA_LockGroups,
		ShowMTs = CT_RA_ShowMTs,
		HideParty = CT_RA_HideParty,
		DefaultAlertColor = CT_RA_DefaultAlertColor,
		SORTTYPE = CT_RA_SORTTYPE,
		ShowGroups = CT_RA_ShowGroups,
		HiddenGroups = CT_RA_HiddenGroups,
		ShowHP = CT_RA_ShowHP,
		PercentColor = CT_RA_PercentColor,
		HideOffline = CT_RA_HideOffline,
		HideNA = CT_RA_HideNA,
		HideShort = CT_RA_HideShort,
		ShowDebuffs = CT_RA_ShowDebuffs,
		HideBorder = CT_RA_HideBorder,
		KeyWord = CT_RA_KeyWord,
		WindowScaling = CT_RA_WindowScaling,
		MTScaling = CT_RA_MTScaling,
		NotifyClasses = CT_RA_NotifyClasses,
		HideMP = CT_RA_HideMP,
		HideRP = CT_RA_HideRP,
		PlayRSSound = CT_RA_PlayRSSound,
		MaintainTarget = CT_RA_MaintainTarget,
		HidePartyRaid = CT_RA_HidePartyRaid,
		HideTooltip = CT_RA_HideTooltip,
		SendRARS = CT_RA_SendRARS,
		ShowAFK = CT_RA_ShowAFK,
		NotifyDebuffsClass = CT_RA_NotifyDebuffsClass,
		NotifyGroupChange = CT_RA_NotifyGroupChange,
		NotifyGroupChangeSound = CT_RA_NotifyGroupChangeSound
	};
	
	for k, v in tbl do
		CT_RAMenu_Options[CT_RAMenu_CurrSet][k] = v;
	end
end

function CT_RAMenu_SaveWindowPositions()
	CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowPositions"] = { };
	local left, top;
	for i = 1, 8, 1 do
		local frame = getglobal("CT_RAGroupDrag" .. i);
		left, top = frame:GetLeft(), frame:GetTop();
		if ( left and top ) then
			CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowPositions"][frame:GetName()] = { left, top };
		end
	end
	left, top = CT_RAMTGroupDrag:GetLeft(), CT_RAMTGroupDrag:GetTop();
	if ( left and top ) then
		CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowPositions"]["CT_RAMTGroupDrag"] = { left, top };
	end
end

function CT_RAMenu_UpdateWindowPositions()
	if ( CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowPositions"] ) then
		for k, v in CT_RAMenu_Options[CT_RAMenu_CurrSet]["WindowPositions"] do
			getglobal(k):ClearAllPoints();
			getglobal(k):SetPoint("TOPLEFT", "UIParent", "TOPLEFT", v[1], v[2]-UIParent:GetTop());
		end
	end
end