function DAB_Floater_Initialize(button)
	local settings = DAB_Settings[DAB_INDEX].Floaters[button];
	local buttonname = "DAB_ActionButton_"..button;
	local buttonframe = getglobal(buttonname);

	buttonframe:ClearAllPoints();
	if (settings.attachbutton) then
		buttonframe:SetPoint(settings.attachpoint, "DAB_ActionButton_"..settings.attachbutton, settings.attachto, settings.attachoffsetx, settings.attachoffsety);
	elseif (settings.attachframe) then
		buttonframe:SetPoint(settings.attachpoint, settings.attachframe, settings.attachto, settings.attachoffsetx, settings.attachoffsety);
	else
		buttonframe:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", DAB_Settings[DAB_INDEX].FrameLocation[buttonname].x, DAB_Settings[DAB_INDEX].FrameLocation[buttonname].y);
	end

	buttonframe:SetAlpha(settings.alpha);
	buttonframe:SetHeight(settings.size);
	buttonframe:SetWidth(settings.size);

	local scale = settings.size / 36 * UIParent:GetScale();
	local cooldownscale = settings.size / 36 * .85;
	if (DAB_Settings[DAB_INDEX].ModifyCooldownByUIScale) then
		cooldownscale = cooldownscale * UIParent:GetScale();
	end
	getglobal("DAB_ActionButton_"..button).scale = scale;
	getglobal("DAB_ActionButton_"..button.."TextFrame"):SetScale(scale);
	getglobal("DAB_ActionButton_"..button.."Cooldown"):SetScale(cooldownscale);
	getglobal("DAB_ActionButton_"..button.."Cooldown").cdscale = cooldownscale;

	local border = getglobal(buttonname.."Border");
	border:SetAlpha(settings.borderalpha);
	border:SetVertexColor(settings.bordercolor.r, settings.bordercolor.g, settings.bordercolor.b);
	local borderoffset = 12 / 36 * settings.size + settings.borderpadding;
	border:ClearAllPoints();
	border:SetPoint("TOPLEFT", "DAB_ActionButton_"..button, "TOPLEFT", -borderoffset, borderoffset);
	border:SetPoint("BOTTOMRIGHT", "DAB_ActionButton_"..button, "BOTTOMRIGHT", borderoffset + 1, -borderoffset - 1);

	if (settings.hide) then
		buttonframe:Hide();
	else
		buttonframe:Show();
	end

	if (settings.showonkeypress) then
		buttonframe:Hide();
	end

	buttonframe:UnregisterEvent("PLAYER_TARGET_CHANGED");
	buttonframe:UnregisterEvent("PLAYER_REGEN_ENABLED");
	buttonframe:UnregisterEvent("PLAYER_REGEN_DISABLED");

	if (settings.hostiletarget or settings.friendlytarget) then
		buttonframe:RegisterEvent("PLAYER_TARGET_CHANGED");
		if (UnitName("target")) then
			if (UnitCanAttack("player", "target")) then
				if (settings.friendlytarget) then
					buttonframe:Hide();
				end
			elseif (settings.hostiletarget) then
				buttonframe:Hide();
			end
		else
			buttonframe:Hide();
		end
	end

	if (settings.incombat or settings.notincombat) then
		buttonframe:RegisterEvent("PLAYER_REGEN_ENABLED");
		buttonframe:RegisterEvent("PLAYER_REGEN_DISABLED");
		if (DAB_INCOMBAT) then
			if (settings.notincombat) then
				buttonframe:Hide();
			end
		elseif (settings.incombat) then
			buttonframe:Hide();
		end
	end
end

function DAB_Floater_InitializeSettings(button)
	DAB_Settings[DAB_INDEX].Floaters[button] = {
		alpha = 1,
		attachframe = nil,
		attachoffsetx = 0,
		attachoffsety = 0,
		attachpoint = "TOPLEFT",
		attachto = "TOPLEFT",
		borderalpha = 1,
		bordercolor = {r=1, g=1, b=0},
		borderpadding = 0,
		form = nil,
		friendlytarget = nil,
		hide = false,
		hideonclick = false,
		hostiletarget = nil,
		incombat = nil,
		keybinding = nil,
		middleclick = button,
		notincombat = nil,
		rightclick = button,
		showonkeypress = nil,
		size = 35,
		target = nil
	};
end

function DAB_Floater_Hide(button)
	if (not DAB_Settings[DAB_INDEX].Floaters[button]) then
		DAB_Debug("Attempt to hide a floater that doesn't exist: "..button);
		return;
	end
	DAB_Settings[DAB_INDEX].Floaters[button].hide = true;
	getglobal("DAB_ActionButton_"..button):Hide();
end

function DAB_Floater_Show(button)
	if (not DAB_Settings[DAB_INDEX].Floaters[button]) then
		DAB_Debug("Attempt to show a floater that doesn't exist: "..button);
		return;
	end
	DAB_Settings[DAB_INDEX].Floaters[button].hide = nil;
	getglobal("DAB_ActionButton_"..button):Show();
end

function DAB_Floater_ShowWhenUsable(button)
	if (not DAB_Settings[DAB_INDEX].Floaters[button]) then
		DAB_Debug("Attempt to call ShowWhenUsable on a floater that doesn't exist: "..button);
		return;
	end
	local isUsable, notEnoughMana = IsUsableAction(button);
	if (GetActionCooldown(button) > 0 or (not isUsable) or notEnoughMana or IsActionInRange(button) == 0) then
		DAB_Floater_Hide(button);
		DAB_SHOWWHENUSABLE[button] = true;
	end
end

function DAB_Floater_TimeToHide(button, sec)
	if (not DAB_Settings[DAB_INDEX].Floaters[button]) then
		DAB_Debug("Attempt to call TimeToHide on a floater that doesn't exist: "..button);
		return;
	end
	if (DAB_Settings[DAB_INDEX].Floaters[button]) then
		getglobal("DAB_ActionButton_"..button).timetohide = sec;
	end
end

function DAB_Floater_Toggle(button)
	if (not DAB_Settings[DAB_INDEX].Floaters[button]) then
		DAB_Debug("Attempt to toggle a floater that doesn't exist: "..button);
		return;
	end
	if (getglobal("DAB_ActionButton_"..button):IsVisible()) then
		DAB_Floater_Hide(button);
	else
		DAB_Floater_Show(button);
	end
end