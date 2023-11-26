tinsert(UISpecialFrames, "CT_RAMenuFrame");
CT_RA_BuffArray = {
	{ ["show"] = 1, ["name"] = CT_RA_POWERWORDFORTITUDE },
	{ ["show"] = 1, ["name"] = CT_RA_MARKOFTHEWILD },
	{ ["show"] = 1, ["name"] = CT_RA_ARCANEINTELLECT },
	{ ["show"] = 1, ["name"] = CT_RA_ADMIRALSHAT },
	{ ["show"] = 1, ["name"] = CT_RA_SHADOWPROTECTION },
	{ ["show"] = 1, ["name"] = CT_RA_POWERWORDSHIELD },
	{ ["show"] = 1, ["name"] = CT_RA_SOULSTONERESURRECTION },
	{ ["show"] = 1, ["name"] = CT_RA_DIVINESPIRIT },
	{ ["show"] = 1, ["name"] = CT_RA_THORNS },
	{ ["show"] = 1, ["name"] = CT_RA_FEARWARD },
	{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFMIGHT },
	{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFWISDOM },
	{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFKINGS },
	{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFSALVATION },
	{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFLIGHT },
	{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFSANCTUARY }
};

CT_RA_NotifyDebuffs = { 
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[4] = 1,
	[5] = 1,
	[6] = 1,
	[7] = 1,
	[8] = 1
};
CT_RA_MemberHeight = 40;
CT_RA_DefaultColor = {
	["r"] = 0,
	["g"] = 0.1,
	["b"] = 0.9,
	["a"] = 0.5
};
CT_RA_DefaultAlertColor = {
	["r"] = 1,
	["g"] = 1,
	["b"] = 1,
};
CT_RA_PercentColor = {
	["r"] = 1,
	["g"] = 1,
	["b"] = 1
};
CT_RA_ShowMTs = { 
	1, 1, 1, 1, 1
};
CT_RA_Ressers = { };
CT_RA_PartyFrame_IsShown = nil;
CT_RA_PlayRSSound = 1;
CT_RAMenu_Locked = 1;

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
	this:SetScale(0.8);
	CT_RAMenuFrameHomeButton1:SetScale(0.73);
	CT_RAMenuFrameHomeButton2:SetScale(0.73);
	CT_RAMenuFrameHomeButton3:SetScale(0.73);
	CT_RAMenuFrameHomeButton4:SetScale(0.73);
	CT_RAMenuFrameHomeButton5:SetScale(0.73);
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

function CT_RAMenuBuffs_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		if ( not CT_RA_ModVersion or CT_RA_ModVersion ~= CT_RA_VersionNumber ) then
			if ( not CT_RA_ModVersion or CT_RA_ModVersion <= 1.08 ) then
				CT_RA_Stats = { };
			end
			if ( not CT_RA_ModVersion or CT_RA_ModVersion < 1.084 ) then
				-- First run this version
				CT_RA_BuffArray = {
					{ ["show"] = 1, ["name"] = CT_RA_POWERWORDFORTITUDE },
					{ ["show"] = 1, ["name"] = CT_RA_MARKOFTHEWILD },
					{ ["show"] = 1, ["name"] = CT_RA_ARCANEINTELLECT },
					{ ["show"] = 1, ["name"] = CT_RA_ADMIRALSHAT },
					{ ["show"] = 1, ["name"] = CT_RA_SHADOWPROTECTION },
					{ ["show"] = 1, ["name"] = CT_RA_POWERWORDSHIELD },
					{ ["show"] = 1, ["name"] = CT_RA_SOULSTONERESURRECTION },
					{ ["show"] = 1, ["name"] = CT_RA_DIVINESPIRIT },
					{ ["show"] = 1, ["name"] = CT_RA_THORNS },
					{ ["show"] = 1, ["name"] = CT_RA_FEARWARD },
					{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFMIGHT },
					{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFWISDOM },
					{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFKINGS },
					{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFSALVATION },
					{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFLIGHT },
					{ ["show"] = 1, ["name"] = CT_RA_BLESSINGOFSANCTUARY }
				};
				if ( not CT_RA_ModVersion or CT_RA_ModVersion < 1.079 ) then
					CT_RA_ClassHealings = {
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
						}
					};
					CT_RA_MemberHeight = 40;
				end
				DEFAULT_CHAT_FRAME:AddMessage("<CTRaid> New version loaded. Due to changes in how the options are saved, some options have been reset. Please look over your options.", 1, 0.5, 0);
			end
			if ( not CT_RA_ModVersion or CT_RA_ModVersion <= 1.083 ) then
				CT_RA_DebuffColors = {
					{ ["type"] = CT_RA_CURSE, ["r"] = 1, ["g"] = 0, ["b"] = 0.75, ["a"] = 0.5, ["id"] = 4 },
					{ ["type"] = CT_RA_MAGIC, ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 6 },

					{ ["type"] = CT_RA_POISON, ["r"] = 0, ["g"] = 0.5, ["b"] = 0, ["a"] = 0.5, ["id"] = 3 },
					{ ["type"] = CT_RA_DISEASE, ["g"] = 1, ["b"] = 0, ["a"] = 0.5, ["id"] = 5 },
					{ ["type"] = CT_RA_WEAKENEDSOUL, ["r"] = 1, ["g"] = 0, ["b"] = 1, ["a"] = 0.5, ["id"] = 2 },
					{ ["type"] = CT_RA_RECENTLYBANDAGED, ["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 1 }
				};
				DEFAULT_CHAT_FRAME:AddMessage("<CTRaid> Due to adding translations, the debuff colors table has been reset. Please look over your debuff options.", 1, 0.5, 0);
			end
			CT_RA_ModVersion = CT_RA_VersionNumber;
		end

		local i = 1;
		for i = 1, 6, 1 do
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "Text"):SetText(string.gsub(CT_RA_DebuffColors[i]["type"][CT_RA_GetLocale()], "_", " "));

			local val = CT_RA_DebuffColors[i];
			getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "SwatchNormalTexture"):SetVertexColor(val.r, val.g, val.b);

			if ( val["id"] ~= -1 ) then
				getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "CheckButton"):SetChecked(1);
			else
				getglobal("CT_RAMenuFrameBuffsDebuff" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			end

		end
		for key, val in CT_RA_BuffArray do
			if ( val["show"] ~= -1 ) then
				getglobal("CT_RAMenuFrameBuffsBuff" .. key .. "CheckButton"):SetChecked(1);
			else
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
		CT_RAMenuFrameBuffsNotify:SetChecked(CT_RA_NotifyDebuffs);

		for i = 1, 8, 1 do
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetText("Group " .. i);
			if ( not CT_RA_NotifyDebuffs or ( not CT_RA_NotifyDebuffs["main"] and CT_RA_NotifyDebuffs["hidebuffs"] ) ) then
				getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
				getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):Disable();
			else
				if ( CT_RA_NotifyDebuffs["main"] ) then
					getglobal("CT_RAMenuFrameBuffsNotify"):SetChecked(1);
				end
				if ( not CT_RA_NotifyDebuffs["hidebuffs"] ) then
					getglobal("CT_RAMenuFrameBuffsNotifyBuffs"):SetChecked(1);
				end
			end
			if ( CT_RA_NotifyDebuffs[i] ) then
				getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):SetChecked(1);
			end
		end
		if ( CT_RA_NotifyClasses ) then
			getglobal("CT_RAMenuFrameBuffsNotifyClassesCheckButton"):SetChecked(1);
			for k, v in CT_RA_ClassPositions do
				if ( k ~= CT_RA_SHAMAN or UnitFactionGroup("player") and UnitFactionGroup("player") == "Horde" ) then
					getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. v .. "Text"):SetText(k);
				end
			end
		else
			for i = 1, 8, 1 do
				getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetText("Group " .. i);
			end
		end
		CT_RAMenuFrameGeneralDisplayShowMPCB:SetChecked(CT_RA_HideMP);
		CT_RAMenuFrameGeneralDisplayShowRPCB:SetChecked(CT_RA_HideRP);
		if ( CT_RA_MemberHeight == 32 ) then
			CT_RAMenuFrameGeneralDisplayShowHealthCB:SetChecked(1)
		end

		if ( CT_RA_HideNames ) then
			CT_RAMenuFrameGeneralDisplayShowGroupsCB:SetChecked(nil);
		end
		if ( CT_RA_LockGroups ) then
			CT_RAMenuFrameGeneralDisplayLockGroupsCB:SetChecked(1);
		end
		CT_RAMenuFrameGeneralDisplayWindowColorSwatchNormalTexture:SetVertexColor(CT_RA_DefaultColor.r, CT_RA_DefaultColor.g, CT_RA_DefaultColor.b);
		CT_RAMenuFrameGeneralDisplayAlertColorSwatchNormalTexture:SetVertexColor(CT_RA_DefaultAlertColor.r, CT_RA_DefaultAlertColor.g, CT_RA_DefaultAlertColor.b);

		CT_RA_UpdateRaidGroupColors();
		CT_RA_UpdateRaidMovability();

		if ( CT_RAMenu_Locked == 0 ) then
			CT_RAMenuFrameHomeLock:SetText("Lock");
		end

		for i = 1, 5, 1 do
			getglobal("CT_RAMenuFrameGeneralTargetsTarget" .. i .. "CB"):SetChecked(CT_RA_ShowMTs[i]);
		end
		CT_RAMenu_CheckParty();
		if ( CT_RA_SORTTYPE == "class" ) then
			UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 2);
		elseif ( CT_RA_SORTTYPE == "custom" ) then
			UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 3);
		end
		if ( CT_RA_ShowHP ) then
			UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, CT_RA_ShowHP);
		else
			UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, 5);
		end
		local num = 0;
		if ( CT_RA_ShowGroups ) then
			for k, v in CT_RA_ShowGroups do
				num = num + 1;
				getglobal("CT_RAOptionsGroupCB" .. k):SetChecked(1);
			end
			if ( num > 0 ) then
				CT_RACheckAllGroups:SetChecked(1);
			else
				CT_RACheckAllGroups:SetChecked(nil);
			end
		end
		if ( CT_RA_HideOffline ) then
			CT_RAMenuFrameGeneralMiscHideOfflineCB:SetChecked(1);
		end
		if ( CT_RA_HideNA ) then
			CT_RAMenuFrameGeneralMiscHideNACB:SetChecked(1);
		end
		if ( CT_RA_HideShort ) then
			CT_RAMenuFrameGeneralMiscHideShortCB:SetChecked(1);
		end
		if ( CT_RA_ShowDebuffs ) then
			CT_RAMenuFrameBuffsShowDebuffsCheckButton:SetChecked(1);
		end
		if ( CT_RA_HideBorder ) then
			CT_RAMenuFrameGeneralMiscBorderCB:SetChecked(1);
		end
		if ( CT_RA_HideParty ) then
			CT_RAMenuFrameGeneralMiscHidePartyCB:SetChecked(1);
		end

		if ( CT_RA_ResFrame_Options["Shown"] and GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		end

		CT_RAMenuFrameGeneralMiscHidePartyRaidCB:SetChecked(CT_RA_HidePartyRaid);
		CT_RAMenuFrameMiscPlayRSSoundCB:SetChecked(CT_RA_PlayRSSound);
		CT_RAMenuFrameMiscMaintainTargetCB:SetChecked(CT_RA_MaintainTarget);
		CT_RAMenuFrameMiscLeaveChannelCB:SetChecked(CT_RA_LeaveChannelRaid);
		CT_RAMenuFrameMiscShowTooltipCB:SetChecked(not CT_RA_HideTooltip);
			
		if ( CT_RA_WindowScaling ) then
			CT_RAMenuGlobalFrame.scaleupdate = 0.1;
		end
		CT_RA_UpdateRaidGroup();
	elseif ( event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" ) then
		CT_RAMenu_CheckParty();
	end
end

function CT_RA_ChangeChannel(new, force)
	if ( ( GetChannelName(1) == 0 and not force ) ) then
		return;
	end
	if ( new == nil and CT_RA_LeaveChannelRaid and GetNumRaidMembers() == 0 ) then
		if ( CT_RA_Channel ) then
			LeaveChannelByName(CT_RA_Channel);
		end
	elseif ( new ) then
		local id = GetChannelName(new);
		if ( id == 0 ) then
			if ( CT_RA_Channel ) then
				local id = GetChannelName(CT_RA_Channel);
				if ( id ~= 0 ) then
					LeaveChannelByName(CT_RA_Channel);
				end
			end
		
			CT_RA_Channel = new;
			if ( GetNumRaidMembers() > 0 ) then
				CT_RAMenu_General_JoinChannel();
			end
		end
	elseif ( CT_RA_Channel and GetNumRaidMembers() > 0 ) then
		CT_RAMenu_General_JoinChannel();
	end
end
			

function CT_RAMenu_CheckParty()
	if (  ( CT_RA_HideParty and GetNumRaidMembers() > 0 ) or ( CT_RA_HidePartyRaid and GetNumRaidMembers() == 0 ) ) then
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
	if ( this == CT_RAMenuFrameBuffsNotify ) then
		CT_RA_NotifyDebuffs["main"] = this:GetChecked();
	else
		CT_RA_NotifyDebuffs["hidebuffs"] = not this:GetChecked();
	end
	for i = 1, 8, 1 do
		if ( not CT_RA_NotifyDebuffs["main"] and CT_RA_NotifyDebuffs["hidebuffs"] ) then
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetTextColor(0.3, 0.3, 0.3);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):Disable();
		else
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetTextColor(1, 1, 1);
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "CheckButton"):Enable();
		end
	end
end

function CT_RAMenuBuff_NotifyClassDebuffs()
	CT_RA_NotifyClasses = this:GetChecked();
	if ( this:GetChecked() ) then
		for k, v in CT_RA_ClassPositions do
			if ( k ~= CT_RA_SHAMAN or ( UnitFactionGroup("player") and UnitFactionGroup("player") == "Horde" ) ) then
				getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. v .. "Text"):SetText(k);
			end
		end
	else
		for i = 1, 8, 1 do
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetText("Group " .. i);
		end
	end
end

function CT_RAMenuNotifyGroup_SetChecked()
	CT_RA_NotifyDebuffs[this:GetParent():GetID()] = this:GetChecked();
end

function CT_RAMenuDebuff_OnClick()
	local frame = this:GetParent();
	local type = getglobal(this:GetParent():GetName() .. "Text"):GetText();
	type = gsub(type, " ", "");
	frame.r = CT_RA_DebuffColors[frame:GetID()]["r"];
	frame.g = CT_RA_DebuffColors[frame:GetID()]["g"];
	frame.b = CT_RA_DebuffColors[frame:GetID()]["b"];
	frame.opacity = CT_RA_DebuffColors[frame:GetID()]["a"];
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
	CT_RA_DebuffColors[ColorPickerFrame.frame:GetID()]["r"] = r;
	CT_RA_DebuffColors[ColorPickerFrame.frame:GetID()]["g"] = g;
	CT_RA_DebuffColors[ColorPickerFrame.frame:GetID()]["b"] = b;
	getglobal(ColorPickerFrame.frame:GetName() .. "SwatchNormalTexture"):SetVertexColor(r, g, b);
end

function CT_RAMenuDebuff_SetOpacity()
	local type = getglobal(ColorPickerFrame.frame:GetName() .. "Text"):GetText();
	local a = OpacitySliderFrame:GetValue();
	CT_RA_DebuffColors[ColorPickerFrame.frame:GetID()]["a"] = a;
end

function CT_RAMenuBuff_Move(move)

	if ( string.find(this:GetParent():GetName(), "Debuff") ) then
		-- Debuff
		if ( not getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text") ) then return; end
		local temp = getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text"):GetText();
		local temp2 = getglobal(this:GetParent():GetName() .. "Text"):GetText();
		getglobal("CT_RAMenuFrameBuffsDebuff" .. (this:GetParent():GetID()+move) .. "Text"):SetText(temp2);
		getglobal(this:GetParent():GetName() .. "Text"):SetText(temp);

		local temparr = CT_RA_DebuffColors[this:GetParent():GetID()];
		local temparr2 = CT_RA_DebuffColors[this:GetParent():GetID()+move];
		CT_RA_DebuffColors[this:GetParent():GetID()] = temparr2;
		CT_RA_DebuffColors[this:GetParent():GetID()+move] = temparr;

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

		local temparr = CT_RA_BuffArray[this:GetParent():GetID()];
		local temparr2 = CT_RA_BuffArray[this:GetParent():GetID()+move];
		CT_RA_BuffArray[this:GetParent():GetID()] = temparr2;
		CT_RA_BuffArray[this:GetParent():GetID()+move] = temparr;
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
		CT_RA_DebuffColors[this:GetParent():GetID()].id = newid;
	else
		-- Buff
		if ( this:GetChecked() ) then
			CT_RA_BuffArray[this:GetParent():GetID()]["show"] = 1;
		else
			CT_RA_BuffArray[this:GetParent():GetID()]["show"] = -1;
		end
	end
	CT_RA_UpdateRaidGroup();
end


function CT_RAMenu_General_JoinChannel()
	if ( CT_RA_Channel and GetChannelName(CT_RA_Channel) == 0 ) then
		local name = CT_RA_Channel;
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
		if ( CT_RA_Channel ) then
			getglobal(this:GetParent():GetName() .. "ChannelEB"):SetText(CT_RA_Channel);
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
		
		CT_RA_ChangeChannel(new);
		getglobal(this:GetParent():GetName() .. "ChannelNameText"):Show();
	end
end

function CT_RAMenu_General_ChannelOnShow()
	if ( CT_RA_Channel ) then
		getglobal(this:GetName() .. "ChannelNameText"):SetText(CT_RA_Channel);
	else
		getglobal(this:GetName() .. "ChannelNameText"):SetText("<No Channel>");
	end
	local edit = getglobal(this:GetName() .. "EditChannel");
	getglobal(this:GetName() .. "BroadcastChannel"):Enable();
	edit:SetText("Edit Channel");
	edit.editing = nil;
	getglobal(this:GetName() .. "ChannelEB"):Hide();
	getglobal(this:GetName() .. "ChannelNameText"):Show();
	if ( CT_RA_NotifyClasses ) then
		getglobal("CT_RAMenuFrameBuffsNotifyClassesCheckButton"):SetChecked(1);
		for k, v in CT_RA_ClassPositions do
			if ( k ~= CT_RA_SHAMAN or ( UnitFactionGroup("player") and UnitFactionGroup("player") == "Horde" ) ) then
				getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. v .. "Text"):SetText(k);
			end
		end
	else
		for i = 1, 8, 1 do
			getglobal("CT_RAMenuFrameBuffsNotifyDebuffsGroup" .. i .. "Text"):SetText("Group " .. i);
		end
	end
	if ( CT_RA_SORTTYPE == "class" ) then
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 2);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Class");
	elseif ( CT_RA_SORTTYPE == "custom" ) then
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Custom");
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 3);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralMiscDropDown, 1);
		CT_RAMenuFrameGeneralMiscDropDownText:SetText("Group");
	end
	if ( CT_RA_ShowHP ) then
		local table = { "Show Values", "Show Percentages", "Show Deficit", "Show only MTT HP %" };
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, CT_RA_ShowHP);
		CT_RAMenuFrameGeneralDisplayHealthDropDownText:SetText(table[CT_RA_ShowHP]);
	else
		UIDropDownMenu_SetSelectedID(CT_RAMenuFrameGeneralDisplayHealthDropDown, 5);
		CT_RAMenuFrameGeneralDisplayHealthDropDownText:SetText("Show None");
	end
end

function CT_RAMenu_General_BroadcastChannel()
	SlashCmdList["RA"]("broadcast");
end

function CT_RAMenuDisplay_ShowMP()
	CT_RA_HideMP = this:GetChecked();
	for i = 1, GetNumRaidMembers(), 1 do
		if ( CT_RA_Stats[UnitName("raid" .. i)] ) then
			CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), CT_RA_Stats[UnitName("raid" .. i)]["Health"], CT_RA_Stats[UnitName("raid" .. i)]["Healthmax"]);
		end
	end
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowRP()
	CT_RA_HideRP = this:GetChecked();
	for i = 1, GetNumRaidMembers(), 1 do
		if ( CT_RA_Stats[UnitName("raid" .. i)] ) then
			CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), CT_RA_Stats[UnitName("raid" .. i)]["Health"], CT_RA_Stats[UnitName("raid" .. i)]["Healthmax"]);
		end
	end
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowHealth()
	if ( not this:GetChecked() ) then
		CT_RA_MemberHeight = CT_RA_MemberHeight+8;
	else
		CT_RA_MemberHeight = CT_RA_MemberHeight-8;
	end
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
end

function CT_RAMenuDisplay_ShowHP()
	if ( this:GetChecked() ) then
		if ( CT_RAMenuFrameGeneralDisplayShowHPPercentCB:GetChecked() ) then
			CT_RA_ShowHP = 2;
		else
			CT_RA_ShowHP = 1;
		end
	else
		CT_RA_ShowHP = nil;
	end
	if ( this:GetChecked() ) then
		CT_RAMenuFrameGeneralDisplayHealthPercentsText:SetTextColor(1, 1, 1);
		CT_RAMenuFrameGeneralDisplayShowHPPercentCB:Enable();
		CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(CT_RA_PercentColor.r, CT_RA_PercentColor.g, CT_RA_PercentColor.b);
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
		CT_RA_ShowHP = 2;
	else
		CT_RA_ShowHP = 1;
	end
	for i = 1, GetNumRaidMembers(), 1 do
		if ( CT_RA_Stats[UnitName("raid" .. i)] ) then
			CT_RA_UpdateUnitHealth(getglobal("CT_RAMember" .. i), CT_RA_Stats[UnitName("raid" .. i)]["Health"], CT_RA_Stats[UnitName("raid" .. i)]["Healthmax"]);
		end
	end
end

function CT_RAMenuDisplay_ShowGroupNames()
	CT_RA_HideNames = not this:GetChecked();
	CT_RA_UpdateVisibility();
end

function CT_RAMenuDisplay_ChangeWC()
	local frame = this:GetParent();
	frame.r = CT_RA_DefaultColor["r"];
	frame.g = CT_RA_DefaultColor["g"];
	frame.b = CT_RA_DefaultColor["b"];
	frame.opacity = CT_RA_DefaultColor["a"];
	frame.opacityFunc = CT_RAMenuDisplay_SetOpacity;
	frame.swatchFunc = CT_RAMenuDisplay_SetColor;
	frame.cancelFunc = CT_RAMenuDisplay_CancelColor;
	frame.hasOpacity = 1;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function CT_RAMenuDisplay_SetColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RA_DefaultColor["r"] = r;
	CT_RA_DefaultColor["g"] = g;
	CT_RA_DefaultColor["b"] = b;
	CT_RAMenuFrameGeneralDisplayWindowColorSwatchNormalTexture:SetVertexColor(r, g, b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplay_SetOpacity()
	CT_RA_DefaultColor["a"] = OpacitySliderFrame:GetValue();
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplay_CancelColor(val)
	CT_RA_DefaultColor["r"] = val.r;
	CT_RA_DefaultColor["g"] = val.g;
	CT_RA_DefaultColor["b"] = val.b;
	CT_RA_DefaultColor["a"] = val.opacity;
	CT_RAMenuFrameGeneralDisplayWindowColorSwatchNormalTexture:SetVertexColor(val.r, val.g, val.b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplay_LockGroups()
	CT_RA_LockGroups = this:GetChecked();
	CT_RA_UpdateVisibility();
end

function CT_RAMenuTarget_Toggle()
	CT_RA_ShowMTs[this:GetID()] = this:GetChecked();
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
		CT_RA_SORTTYPE = "group";
	elseif ( this:GetID() == 2 ) then
		CT_RA_SORTTYPE = "class";
	else
		CT_RA_SORTTYPE = "custom";
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
		CT_RA_ShowHP = this:GetID();
	else
		CT_RA_ShowHP = nil;
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
	CT_RA_HideParty = this:GetChecked();
	CT_RAMenu_CheckParty();
end

function CT_RAMenuGeneral_HidePartyOutOfRaid()
	CT_RA_HidePartyRaid = this:GetChecked();
	CT_RAMenu_CheckParty();
end

function CT_RAMenuDisplay_ChangeAC()
	local frame = this:GetParent();
	frame.r = CT_RA_DefaultAlertColor["r"];
	frame.g = CT_RA_DefaultAlertColor["g"];
	frame.b = CT_RA_DefaultAlertColor["b"];
	frame.swatchFunc = CT_RAMenuDisplay_SetAlertColor;
	frame.cancelFunc = CT_RAMenuDisplay_CancelAlertColor;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function CT_RAMenuDisplay_SetAlertColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RA_DefaultAlertColor["r"] = r;
	CT_RA_DefaultAlertColor["g"] = g;
	CT_RA_DefaultAlertColor["b"] = b;
	CT_RAMenuFrameGeneralDisplayAlertColorSwatchNormalTexture:SetVertexColor(r, g, b);
end

function CT_RAMenuDisplay_CancelAlertColor(val)
	CT_RA_DefaultAlertColor["r"] = val.r;
	CT_RA_DefaultAlertColor["g"] = val.g;
	CT_RA_DefaultAlertColor["b"] = val.b;
	CT_RAMenuFrameGeneralDisplayAlertColorSwatchNormalTexture:SetVertexColor(val.r, val.g, val.b);
end

function CT_RAMenuDisplay_ChangeTC()
	if ( CT_RA_ShowHP ) then
		local frame = this:GetParent();
		frame.r = CT_RA_PercentColor["r"];
		frame.g = CT_RA_PercentColor["g"];
		frame.b = CT_RA_PercentColor["b"];
		frame.swatchFunc = CT_RAMenuDisplayPercent_SetColor;
		frame.cancelFunc = CT_RAMenuDisplayPercent_CancelColor;
		CloseMenus();
		UIDropDownMenuButton_OpenColorPicker(frame);
	end
end

function CT_RAMenuDisplayPercent_SetColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_RA_PercentColor["r"] = r;
	CT_RA_PercentColor["g"] = g;
	CT_RA_PercentColor["b"] = b;
	CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(r, g, b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuDisplayPercent_CancelColor(val)
	CT_RA_PercentColor["r"] = val.r;
	CT_RA_PercentColor["g"] = val.g;
	CT_RA_PercentColor["b"] = val.b;
	CT_RAMenuFrameGeneralDisplayShowHPSwatchNormalTexture:SetVertexColor(val.r, val.g, val.b);
	CT_RA_UpdateRaidGroupColors();
end

function CT_RAMenuGeneral_HideOffline()
	CT_RA_HideOffline = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuGeneral_HideNA()
	CT_RA_HideNA = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuGeneral_HideShort()
	CT_RA_HideShort = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuBuff_ShowDebuffs()
	CT_RA_ShowDebuffs = this:GetChecked();
	CT_RA_UpdateRaidGroup();
end

function CT_RAMenuGeneral_HideBorder()
	CT_RA_HideBorder = this:GetChecked();
	CT_RA_UpdateRaidGroup();
	CT_RA_UpdateMTs();
end

-- Handle Misc section
CT_RA_PartyMembers = { };
CT_RA_CurrCast = nil;
CT_RA_InCombat = nil;
CT_RA_SpellCastDelay = 0.5;

function CT_RAMenuMisc_Slider_OnChange()
	local spell = CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")][this:GetID()];
	CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")][this:GetID()][3] = this:GetValue()/100;
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
	if ( UnitClass("player") and CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")] ) then -- Assumes there are two heals/healing class
		getglobal(slider:GetName().."High"):SetText("100%");
		getglobal(slider:GetName().."Low"):SetText("0%");
		slider.tooltipText = CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")][slider:GetID()][2];
		slider:SetMinMaxValues(0, 100);
		slider:SetValueStep(1);
		slider:Show();
		getglobal(slider:GetParent():GetName() .. "NoHealer"):Hide();
		getglobal(slider:GetParent():GetName() .. "Healer"):Show();

		local spell = CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")][slider:GetID()];
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
	if ( UnitClass("player") and CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")] ) then
		slider:Show();
		getglobal(slider:GetName().."High"):SetText("1.5 sec");
		getglobal(slider:GetName().."Low"):SetText("0.5 sec");
		getglobal(slider:GetName() .. "Text"):SetText("Check Time - " .. CT_RA_SpellCastDelay .. " sec");
		slider.tooltipText = "Adjust the time when the 'mana conserve' point checks your targets health.  If you set 0.5 sec, the heal will cancel 0.5 seconds before it would cast. However if you lag, you may want to set it higher, so it would check earlier before the cast would occur.";
		slider:SetMinMaxValues(0.5, 1.5);
		slider:SetValueStep(0.05);
		slider:SetValue(CT_RA_SpellCastDelay);
		slider:Show();
	else
		slider:Hide();
	end
end

function CT_RAMenuMisc_LagSlider_OnValueChanged()
	CT_RA_SpellCastDelay = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("Check Time - " .. CT_RA_SpellCastDelay .. " sec");
end

function CT_RAMenuMisc_Schedule(time)
	this.update = time;
end

function CT_RAMenuMisc_OnUpdate(elapsed)
	if ( this.scaleupdate ) then
		this.scaleupdate = this.scaleupdate - elapsed;
		if ( this.scaleupdate <= 0 ) then
			this.scaleupdate = nil;
			if ( CT_RA_WindowScaling ) then
				for i = 1, 40, 1 do
					if ( i <= 8 ) then
						getglobal("CT_RAGroupDrag" .. i):SetWidth(CT_RAGroup1:GetWidth()*CT_RA_WindowScaling+(22*CT_RA_WindowScaling));
						getglobal("CT_RAGroupDrag" .. i):SetHeight(CT_RAMember1:GetHeight()*CT_RA_WindowScaling/2);
						getglobal("CT_RAGroup" .. i):SetScale(CT_RA_WindowScaling);
					end
					getglobal("CT_RAMember" .. i):SetScale(CT_RA_WindowScaling);
				end
			end
			if ( CT_RA_MTScaling ) then
				for i = 1, 5, 1 do
					getglobal("CT_RAMTGroupMember" .. i):SetScale(CT_RA_MTScaling);
				end
				CT_RAMTGroup:SetScale(CT_RA_MTScaling);
				CT_RAMTGroupDrag:SetWidth(CT_RAMTGroup:GetWidth()*CT_RA_MTScaling+(22*CT_RA_MTScaling));
				CT_RAMTGroupDrag:SetHeight(CT_RAMTGroupMember1:GetHeight()*CT_RA_MTScaling/2);
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
	for k, v in CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")] do
		if ( type(v[1]) == "table" and v[3] < 1 ) then
			for key, val in v[1] do
				if ( val == CT_RA_CurrCast[1] ) then
					if ( CT_RA_CurrCast[2] == "target" ) then
						if ( not UnitExists("target") or CT_RA_CurrCast[3] ~= UnitName("target") ) then
							return; -- Can't process health here
						end
					end
					if ( UnitExists(CT_RA_CurrCast[2]) and UnitHealth(CT_RA_CurrCast[2])/UnitHealthMax(CT_RA_CurrCast[2]) >= v[3] ) then
						CT_RA_Print("<CTMod> Aborted spell '|c00FFFFFF" .. CT_RA_CurrCast[1] .. "|r'.", 1, 0.5, 0);
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
				CT_RA_Print("<CTMod> Aborted spell '|c00FFFFFF" .. CT_RA_CurrCast[1] .. "|r'.", 1, 0.5, 0);
				SpellStopCasting();
				return;
			end
		end
	end
end

function CT_RA_SpellStartCast(spell)
	if ( spell[1] == "Resurrection" or spell[1] == "Ancestral Spirit" ) then
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
	if ( event == "SPELLCAST_START" and CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")] ) then
		if ( not CT_RA_SpellTarget and UnitExists("target") and UnitIsFriend("player", "target") ) then
			CT_RA_SpellTarget = "target";
		elseif ( not CT_RA_SpellTarget and UnitExists("mouseover") ) then
			return; -- Can't check on mouseover :(
		end
		if ( not CT_RA_SpellTarget ) then return; end
		for k, v in CT_RA_ClassHealings[CT_RA_GetLocale()][UnitClass("player")] do
			if ( type(v[1]) == "table" ) then
				for key, val in v[1] do
					if ( val == arg1 ) then
						CT_RA_CurrCast = { arg1, CT_RA_SpellTarget, UnitName(CT_RA_SpellTarget) };

						local time = (arg2/1000)-CT_RA_SpellCastDelay;
						if ( time < 0 ) then
							time = 0;
						end
						CT_RAMenuMisc_Schedule(time);
						return;
					end
				end
			elseif ( v[1] == arg1 ) then
				CT_RA_CurrCast = { arg1, CT_RA_SpellTarget, UnitName(CT_RA_SpellTarget) };
				local time = (arg2/1000)-CT_RA_SpellCastDelay;
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


-- Scaling

function CT_RAMenuAdditional_Scaling_OnShow()
	getglobal(this:GetName().."High"):SetText("150%");
	getglobal(this:GetName().."Low"):SetText("50%");
	if ( not CT_RA_WindowScaling ) then
		CT_RA_WindowScaling = floor(CT_RAGroup1:GetScale()*100+0.5)/100;
	end
	getglobal(this:GetName() .. "Text"):SetText("Group Scaling - " .. floor(CT_RA_WindowScaling*100+0.5) .. "%");

	this:SetMinMaxValues(0.5, 1.5);
	this:SetValueStep(0.01);
	this:SetValue(CT_RA_WindowScaling);
end

function CT_RAMenuAdditional_Scaling_OnValueChanged()
	CT_RA_WindowScaling = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("Group Scaling - " .. floor(this:GetValue()*100+0.5) .. "%");
	for i = 1, 40, 1 do
		if ( i <= 8 ) then
			getglobal("CT_RAGroup" .. i):SetScale(CT_RA_WindowScaling);
			getglobal("CT_RAGroupDrag" .. i):SetWidth(CT_RAGroup1:GetWidth()*CT_RA_WindowScaling+(22*CT_RA_WindowScaling));
			getglobal("CT_RAGroupDrag" .. i):SetHeight(CT_RAMember1:GetHeight()*CT_RA_WindowScaling/2);
		end
		getglobal("CT_RAMember" .. i):SetScale(CT_RA_WindowScaling);
	end
end

function CT_RAMenuAdditional_ScalingMT_OnShow()
	getglobal(this:GetName().."High"):SetText("150%");
	getglobal(this:GetName().."Low"):SetText("50%");
	if ( not CT_RA_MTScaling ) then
		CT_RA_MTScaling = floor(CT_RAMTGroup:GetScale()*100+0.5)/100;
	end
	getglobal(this:GetName() .. "Text"):SetText("MT Scaling - " .. floor(CT_RA_MTScaling*100+0.5) .. "%");

	this:SetMinMaxValues(0.5, 1.5);
	this:SetValueStep(0.01);
	this:SetValue(CT_RA_MTScaling);
end

function CT_RAMenuAdditional_ScalingMT_OnValueChanged()
	CT_RA_MTScaling = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("MT Scaling - " .. floor(this:GetValue()*100+0.5) .. "%");
	for i = 1, 5, 1 do
		getglobal("CT_RAMTGroupMember" .. i):SetScale(CT_RA_MTScaling);
	end
	CT_RAMTGroup:SetScale(CT_RA_MTScaling);

	CT_RAMTGroupDrag:SetWidth(CT_RAMTGroup:GetWidth()*CT_RA_MTScaling+(22*CT_RA_MTScaling));
	CT_RAMTGroupDrag:SetHeight(CT_RAMTGroupMember1:GetHeight()*CT_RA_MTScaling/2);
end

-- Spam Control
CT_RA_Comm_HPChangeThreshold = 3;
CT_RA_Comm_MPChangeThreshold = 10;
CT_RA_Comm_MinMessageInterval = 0.1;
CT_RA_Comm_MTHPChangeThreshold = 3;
CT_RA_Comm_MTMPChangeThreshold = 10;

function CT_RAMenuAdditional_SC_OnShow()
	local vars = { CT_RA_Comm_HPChangeThreshold, CT_RA_Comm_MPChangeThreshold, CT_RA_Comm_MTHPChangeThreshold, CT_RA_Comm_MTMPChangeThreshold };
	local type = { "Health", "Mana", "Health", "Mana" };
	getglobal(this:GetName().."High"):SetText("100%");
	getglobal(this:GetName().."Low"):SetText("1%");
	getglobal(this:GetName() .. "Text"):SetText(type[this:GetID()] .. " - " .. vars[this:GetID()] .. "%");
	this:SetMinMaxValues(1, 100);
	this:SetValueStep(1);
	this:SetValue(vars[this:GetID()]);
	if ( this:GetID() <= 2 ) then
		this.tooltipText = "This also affects party members you report health and mana for.";
	end
end

function CT_RAMenuAdditional_SC_OnValueChanged()
	if ( this:GetID() == 1 ) then
		CT_RA_Comm_HPChangeThreshold = this:GetValue();
	elseif ( this:GetID() == 2 ) then
		CT_RA_Comm_MPChangeThreshold = this:GetValue();
	elseif ( this:GetID() == 3 ) then
		CT_RA_Comm_MTHPChangeThreshold = this:GetValue();
	else
		CT_RA_Comm_MTMPChangeThreshold = this:GetValue();
	end
	local type = { "Health", "Mana", "Health", "Mana" };
	getglobal(this:GetName() .. "Text"):SetText(type[this:GetID()] .. " - " .. this:GetValue() .. "%");
end

function CT_RAMenuAdditional_SpamControl_OnShow()
	getglobal(this:GetName().."High"):SetText("5 sec");
	getglobal(this:GetName().."Low"):SetText("0.1 sec");
	getglobal(this:GetName() .. "Text"):SetText("Minimum Interval - " .. CT_RA_Comm_MinMessageInterval .. " sec");

	this:SetMinMaxValues(0.1, 5);
	this:SetValueStep(0.1);
	this:SetValue(CT_RA_Comm_MinMessageInterval);
end

function CT_RAMenuAdditional_SpamControl_OnValueChanged()
	CT_RA_Comm_MinMessageInterval = floor(this:GetValue()*100+0.5)/100;
	getglobal(this:GetName() .. "Text"):SetText("Minimum Interval  - " .. CT_RA_Comm_MinMessageInterval .. " sec");
end

function CT_RA_GetLocale()
	return "en";
	-- To be used when everything's translated
	-- return strsub(GetLocale(), 1, 2);
end

function CT_RAMenu_Misc_PlaySound()
	CT_RA_PlayRSSound = this:GetChecked();
end

function CT_RAMenu_Misc_MaintainTarget()
	CT_RA_MaintainTarget = this:GetChecked();
end

function CT_RAMenu_Misc_ShowTooltip()
	CT_RA_HideTooltip = not this:GetChecked();
end

function CT_RAMenu_Misc_LeaveChannel()
	CT_RA_LeaveChannelRaid = this:GetChecked();
	CT_RA_ChangeChannel();
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

SlashCmdList["RARES"] = function(msg)
	if ( msg == "show" ) then
		if ( GetNumRaidMembers() > 0 ) then
			CT_RA_ResFrame:Show();
		end
		CT_RA_ResFrame_Options["Shown"] = 1;
	elseif ( msg == "hide" ) then
		CT_RA_ResFrame:Hide();
		CT_RA_ResFrame_Options["Shown"] = nil;
	else
		CT_RA_Print("<CTMod> Usage: |c00FFFFFF/rares [show/hide]|r - Shows/hides the Resurrection Monitor.", 1, 0.5, 0);
	end
end

SLASH_RARES1 = "/rares";