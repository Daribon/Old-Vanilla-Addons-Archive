--[[** Nurfed Buttons **]]--

Nurfed_AddOns = {};
Nurfed_AddOns[1] = {text = NURFEDADDONHEADER.."\nVers. "..NURFED_VERSION, isTitle = 1, nurfed = 1 };
Nurfed_AddOns[2] = {text = NURFEDOTHERADDONS, isTitle = 1, level = 2 };
Nurfed_AddOns[3] = {text = NURFEDGENERAL, func = Nurfed_OptionsFrameToggle, nurfed = 1 };

Nurfed_MicroMenu = {};
Nurfed_MicroMenu[1] = {text = NURFEDMICROHEADER, isTitle = 1, level = 2 };
Nurfed_MicroMenu[2] = {text = NURFEDTALENTS, func = ToggleTalentFrame, level = 2 };
Nurfed_MicroMenu[3] = {text = NURFEDQUESTLOG, func = ToggleQuestLog, level = 2 };
Nurfed_MicroMenu[4] = {text = NURFEDFRIENDS, func = ToggleFriendsFrame, level = 2 };
Nurfed_MicroMenu[5] = {text = NURFEDHELPMENU, func = ToggleHelpFrame, level = 2 };

-- Setup variable loading for our lock button
function Nurfed_LockButtonOnLoad ()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("VARIABLES_LOADED");

	local MenuPos = 270;
	Nurfed_LockButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(MenuPos)), (80 * sin(MenuPos)) - 52);
end

-- Setup our lock variable and register it for saving
function Nurfed_LockButtonOnEvent (event)
	if (event == "VARIABLES_LOADED") then
		if (NURFED_LOCKALL == nil) then
			NURFED_LOCKALL = 1;
		end
		if (NURFED_LOCKALL == 1) then
			Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedlocked");
		else
			Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedunlocked");
		end
		Nurfed_OptionsInit();
		return;
	end
end

function Nurfed_MenuDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Nurfed_Menu_Initialize, "MENU");
end

function Nurfed_OptionsInit()
	if (AUTOBAR_VERSION) then
		Nurfed_AddMenuItem("Autobar Config", AutoBar_EditConfig);
	end
	if (SCT_Version) then
		Nurfed_AddMenuItem("SCT Menu", SCT_showMenu);
	end
	if (AF_ToolTip) then
		Nurfed_AddMenuItem("Aftooltip Menu", aftt_toggleFrames);
	end
end

function Nurfed_Menu_Initialize()
	local info = {};

	if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
		for k, v in Nurfed_AddOns do
			if (v.nurfed == 1) then
				info = {};
				info.text = v.text;
				info.func = v.func;
				info.isTitle = v.isTitle;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info);
			end
		end

		Nurfed_Menu_AddSpacer();

		info = {};
		info.text = NURFEDOTHERADDONS;
		info.value = "Other AddOns";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);

		info = {};
		info.text = NURFEDMICROHEADER;
		info.value = "Micro Buttons";
		info.hasArrow = 1;
		UIDropDownMenu_AddButton(info);
		return;
	end

	if (UIDROPDOWNMENU_MENU_VALUE == "Micro Buttons") then
		for k, v in Nurfed_MicroMenu do
			info = {};
			info.text = v.text;
			info.func = v.func;
			info.isTitle = v.isTitle;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info, v.level);
		end
		return;
	end

	if (UIDROPDOWNMENU_MENU_VALUE == "Other AddOns") then
		for k, v in Nurfed_AddOns do
			if (v.nurfed ~= 1) then
				info = {};
				info.text = v.text;
				info.func = v.func;
				info.isTitle = v.isTitle;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info, v.level);
			end
		end
		return;
	end
end

function Nurfed_Menu_AddSpacer(level)
	local info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info, level);
end

function Nurfed_AddMenuItem(text, func, nurfed)
	local index = Nurfed_Menu_GetIndex(text);
	local found = (index ~= nil);
	if (nil == index) then
		index = table.getn(Nurfed_AddOns) + 1;
		table.setn(Nurfed_AddOns, index);
		Nurfed_AddOns[index] = {};
		Nurfed_AddOns[index].text = text;
		Nurfed_AddOns[index].func = func;
		if (nurfed == 1) then
			Nurfed_AddOns[index].nurfed = 1;
		else
			Nurfed_AddOns[index].level = 2;
		end
	end
end

function Nurfed_Menu_GetIndex(text)
	local i;
	for i = 1, table.getn(Nurfed_AddOns) do
		if (Nurfed_AddOns[i].text == text) then
			return i;
		end
	end

	return nil;
end

function Nurfed_LockButtonOnClick(button)
	if (Nurfed_LockButtonDropDown:IsVisible()) then
		Nurfed_LockButtonDropDown:Hide();
	end

	if (button == "LeftButton") then
		Nurfed_ToggleLock();
	elseif (button == "RightButton") then
		GameTooltip:Hide();
		ToggleDropDownMenu(1, nil, Nurfed_LockButtonDropDown, "Nurfed_LockButton", 0, 0);
		local listFrame = getglobal("DropDownList"..UIDROPDOWNMENU_MENU_LEVEL);
		if (UIDROPDOWNMENU_MENU_LEVEL == 1) then
			listFrame:ClearAllPoints();
			listFrame:SetPoint("TOPRIGHT", "Nurfed_LockButton", "BOTTOMLEFT", 0, 0);
		end
	end
end

function Nurfed_ToggleLock()
	if (NURFED_LOCKALL == 1) then
		NURFED_LOCKALL = 0;
		Nurfed_LockButton:SetChecked(0);
		PlaySound("igMainMenuQuit");
		GameTooltip:SetText("Left Click - Lock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
		Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedunlocked");
	else
		NURFED_LOCKALL = 1;
		Nurfed_LockButton:SetChecked(1);
		PlaySound("igMainMenuOption");
		GameTooltip:SetText("Left Click - Unlock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
		Nurfed_LockButtonIconTexture:SetTexture("Interface\\AddOns\\Nurfed_General\\images\\nurfedlocked");
	end
end

function Nurfed_LockButtonOnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	if (this:GetChecked()) then
		GameTooltip:SetText("Left Click - Unlock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
	else
		GameTooltip:SetText("Left Click - Lock UI \nRight Click - Options Menu", 1.0, 1.0, 1.0);
	end
end

old_PickupAction = PickupAction;
function PickupAction(id)
	if ( NURFED_LOCKALL == 0 ) then
		old_PickupAction(id);
	end
end

function Nurfed_UIMenu()
end