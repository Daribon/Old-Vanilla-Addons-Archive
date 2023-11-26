CT_RAMenu_Options = {
	["Default"] = {
		PlayRSSound = 1,
		MenuLocked = 1,
		ShowMTs = { 1, 1, 1, 1, 1 },
		NotifyDebuffsClass = { 1, 1, 1, 1, 1, 1, 1, 1 },
		NotifyDebuffs = { 1, 1, 1, 1, 1, 1, 1, 1 },
		DefaultColor = { r = 0, g = 0.1, b = 0.9, a = 0.5 },
		MemberHeight = 40,
		PercentColor = { r = 1, g = 1, b = 1 },
		DefaultAlertColor = { r = 1, g = 1, b = 1 },
		BuffArray = {
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
		},
		DebuffColors = {
			{ ["type"] = CT_RA_CURSE, ["r"] = 1, ["g"] = 0, ["b"] = 0.75, ["a"] = 0.5, ["id"] = 4 },
			{ ["type"] = CT_RA_MAGIC, ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 6 },
			{ ["type"] = CT_RA_POISON, ["r"] = 0, ["g"] = 0.5, ["b"] = 0, ["a"] = 0.5, ["id"] = 3 },
			{ ["type"] = CT_RA_DISEASE, ["g"] = 1, ["b"] = 0, ["a"] = 0.5, ["id"] = 5 },
			{ ["type"] = CT_RA_WEAKENEDSOUL, ["r"] = 1, ["g"] = 0, ["b"] = 1, ["a"] = 0.5, ["id"] = 2 },
			{ ["type"] = CT_RA_RECENTLYBANDAGED, ["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 0.5, ["id"] = 1 }
		},
		ShowGroups = { },
		ClassHealings = {
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
		},
		Geddon_Status = 1,
		Onyxia_Text = "ONYXIA FLAME AOE WILL BE INC, MOVE TO SIDES";
		Onyxia_Status = 0,
		SpellCastDelay = 0.5,
		SORTTYPE = "group"
	}
}

CT_RAMenu_CurrSet = "Default";

CT_RASets_ButtonPosition = 16;

function CT_RASets_MoveButton()
	CT_RASets_Button:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(CT_RASets_ButtonPosition)), (80 * sin(CT_RASets_ButtonPosition)) - 52);
end

function CT_RASets_ToggleDropDown()
	CT_RASets_DropDown.point = "TOPRIGHT";
	CT_RASets_DropDown.relativePoint = "BOTTOMLEFT";
	ToggleDropDownMenu(1, nil, CT_RASets_DropDown);
end

function CT_RASets_DropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	CT_RASets_DropDown_InitButtons();
end

function CT_RASets_DropDown_OnClick()
	local id = this:GetID();
	if ( id == 2 ) then
		ShowUIPanel(CT_RAMenuFrame);
	elseif ( id == 3 ) then
		ShowUIPanel(CT_RASetsEditFrame);
	elseif ( id >= 4 ) then
		local num = 0;
		for k, v in CT_RAMenu_Options do
			num = num + 1;
			if ( num == id-3 ) then
				CT_RAMenu_CurrSet = k;
				CT_RA_UpdateRaidGroup();
				CT_RA_UpdateMTs();
				CT_RAMenu_UpdateMenu();
				CT_RAOptions_Update();
				return;
			end
		end
	end
end

function CT_RASets_DropDown_InitButtons()
	local info = {};

	info.text = "Option Sets"
	info.isTitle = 1;
	info.justifyH = "CENTER";
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);
	
	info = { };
	info.text = "Open Options"
	info.notCheckable = 1;
	info.func = CT_RASets_DropDown_OnClick;
	UIDropDownMenu_AddButton(info);
	
	info = { };
	info.text = "Edit Sets"
	info.notCheckable = 1;
	info.func = CT_RASets_DropDown_OnClick;
	UIDropDownMenu_AddButton(info);

	for k, v in CT_RAMenu_Options do
		info = { };
		info.text = k;
		info.isTitle = nil;
		if ( CT_RAMenu_CurrSet == k ) then
			info.checked = 1;
		end
		info.func = CT_RASets_DropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function CT_RASets_DropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CT_RASets_DropDown_Initialize, "MENU");
end

tinsert(UISpecialFrames, "CT_RASetsEditFrame");
tinsert(UISpecialFrames, "CT_RASetsEditNewFrame");
CT_RASetsEditFrame_NumButtons = 7;

function CT_RASetsEditFrame_Update()
	local numEntries = 0;
	for k, v in CT_RAMenu_Options do
		numEntries = numEntries + 1;
	end
	FauxScrollFrame_Update(CT_RASetsEditFrameScrollFrame, numEntries, CT_RASetsEditFrame_NumButtons , 32);

	for i = 1, CT_RASetsEditFrame_NumButtons, 1 do
		local button = getglobal("CT_RASetsEditFrameBackdropButton" .. i);
		local index = i + FauxScrollFrame_GetOffset(CT_RASetsEditFrameScrollFrame);
		local num, name = 0, nil;
		if ( i <= numEntries ) then
			
			for k, v in CT_RAMenu_Options do
				num = num + 1;
				if ( num == index ) then
					name = k;
					break;
				end
			end
			if ( name ) then
				button:Show();
				if ( CT_RASetsEditFrame.selected == name ) then
					getglobal(button:GetName() .. "CheckButton"):SetChecked(1);
				else
					getglobal(button:GetName() .. "CheckButton"):SetChecked(nil);
				end
				getglobal(button:GetName() .. "Name"):SetText(name);
			end
		else
			button:Hide();
		end
	end
end

function CT_RASetsEditCB_Check(id)
	for i = 1, CT_RASetsEditFrame_NumButtons, 1 do
		getglobal("CT_RASetsEditFrameBackdropButton" .. i .. "CheckButton"):SetChecked(nil);
	end
	if ( not id ) then
		return;
	end
	getglobal("CT_RASetsEditFrameBackdropButton" .. id .. "CheckButton"):SetChecked(1);
	local num = 0;
	for k, v in CT_RAMenu_Options do
		num = num + 1;
		if ( num == id+FauxScrollFrame_GetOffset(CT_RASetsEditFrameScrollFrame) ) then
			CT_RASetsEditFrame.selected = k;
			if ( k == "Default" ) then
				CT_RASetsEditFrame_EnableDelete(nil);
			else
				CT_RASetsEditFrame_EnableDelete(1);
			end
			return;
		end
	end
	CT_RASetsEditFrame_EnableDelete(nil);
end

function CT_RASetsEditFrame_EnableDelete(enable)
	if ( enable ) then
		CT_RASetsEditFrameDeleteButton:Enable();
	else
		CT_RASetsEditFrameDeleteButton:Disable();
	end
end

function CT_RASetsEdit_Delete()
	if ( CT_RASetsEditFrame.selected ) then
		CT_RAMenu_Options[CT_RASetsEditFrame.selected] = nil;
		if ( CT_RASetsEditFrame.selected == CT_RAMenu_CurrSet ) then
			CT_RAMenu_CurrSet = "Default";
			CT_RA_UpdateRaidGroup();
			CT_RAOptions_Update();
			CT_RA_UpdateMTs();
			CT_RAMenu_UpdateMenu();
		end
	end
	CT_RASetsEditFrame.selected = nil;
	CT_RASetsEditFrame_Update();
	CT_RASetsEditFrame_EnableDelete(nil);
end

function CT_RASetsEditNewDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, CT_RASetsEditNew_DropDown_Initialize);
	UIDropDownMenu_SetWidth(180);
	UIDropDownMenu_SetSelectedName(CT_RASetsEditNew_DropDown, "Default");
end

function CT_RASetsEditNew_DropDown_Initialize()
	local info = {};
	for k, v in CT_RAMenu_Options do
		info = { };
		info.text = k;
		info.func = CT_RASetsEditNew_DropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function CT_RASetsEditNew_DropDown_OnClick()
	local num = 0;
	for k, v in CT_RAMenu_Options do
		num = num + 1;
		if ( num == this:GetID() ) then
			CT_RASetsEditNewFrame.set = k;
			UIDropDownMenu_SetSelectedName(CT_RASetsEditNew_DropDown, k);
			return;
		end
	end
	CT_RASetsEditNewFrame.set = "Default";
	UIDropDownMenu_SetSelectedName(CT_RASetsEditNew_DropDown, "Default");
end

function CT_RASet_New()
	local name = CT_RASetsEditNewFrameNameEB:GetText();
	if ( strlen(name) > 0 and CT_RASetsEditNewFrame.set and CT_RAMenu_Options[CT_RASetsEditNewFrame.set] and not CT_RAMenu_Options[name] ) then
		CT_RAMenu_Options[name] = { };
		for k, v in CT_RAMenu_Options[CT_RASetsEditNewFrame.set] do
			CT_RAMenu_Options[name][k] = v;
		end
	end
	CT_RASetsEditFrame_Update();
end