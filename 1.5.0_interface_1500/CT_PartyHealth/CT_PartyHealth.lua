-- // Global Variables // --

CT_PartyHealth_Positions = {
	[1] = { -- Numbers
		[1] = { "CENTER", "HealthBar", "CENTER", 0, 0 },
		[2] = { "CENTER", "HealthBar", "CENTER", 0, 0 },
		[3] = { }, -- Hidden
		[4] = { "LEFT", "HealthBar", "RIGHT", 3, 0 },
		[5] = { "LEFT", "HealthBar", "RIGHT", 3, 0 },
		[6] = { }, -- Hidden
		[7] = { } -- Hidden
	},
	[2] = { -- Percents
		[1] = { "LEFT", "HealthBar", "RIGHT", 3, 0 },
		[2] = { }, -- Hidden
		[3] = { "LEFT", "HealthBar", "RIGHT", 3, 0 },
		[4] = { "CENTER", "HealthBar", "CENTER", 0, 0 },
		[5] = { }, -- Hidden
		[6] = { "CENTER", "HealthBar", "CENTER", 0, 0 },
		[7] = { } -- Hidden
	}
};

CT_PartyColors = { ["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1, ["s"] = 3 };

CT_PartyHealth_CurrPosition = 1;
CT_PartyHealth_Status = 1;

-- // Functions related to color selection // --

function CT_PartyHealthFrame_SetColor()
	local r, g, b = ColorPickerFrame:GetColorRGB();
	CT_PartyColors["r"] = r;
	CT_PartyColors["g"] = g;
	CT_PartyColors["b"] = b;
	CT_PartyHealthGlobalFrame.r = r;
	CT_PartyHealthGlobalFrame.g = g;
	CT_PartyHealthGlobalFrame.b = b;

	for i = 1, 4, 1 do
		getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetVertexColor(r, g, b);
		getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetVertexColor(r, g, b);

		getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetVertexColor(r, g, b);
		getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetVertexColor(r, g, b);
	end

	CT_PartyHealthOptionsFrameEditColorButtonNormalTexture:SetVertexColor(r, g, b);
end


function CT_PartyHealthFrame_SetSize(size)

	CT_PartyColors["s"] = size;

	for i = 1, 4, 1 do
		getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetTextHeight(size+7);
		getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetTextHeight(size+7);

		getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetTextHeight(size+7);
		getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetTextHeight(size+7);
	end
end

function CT_PartyHealthFrame_SetOpacity()
	local a = OpacitySliderFrame:GetValue();
	CT_PartyColors["a"] = a;
	CT_PartyHealthGlobalFrame.opacity = a;

	for i = 1, 4, 1 do
		getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], a);
		getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], a);
	
		getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], a);
		getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], a);
	end
end

function CT_PartyHealthFrame_ShowColorPicker(frame)
	frame.r = CT_PartyColors["r"];
	frame.g = CT_PartyColors["g"];
	frame.b = CT_PartyColors["b"];
	frame.opacity = CT_PartyColors["a"];
	frame.opacityFunc = CT_PartyHealthFrame_SetOpacity;
	frame.swatchFunc = CT_PartyHealthFrame_SetColor;
	frame.hasOpacity = 1;
	UIDropDownMenuButton_OpenColorPicker(frame);
end



-- // OnFoo Functions // --

function CT_PartyHealthFrame_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		for i = 1, 4, 1 do
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], CT_PartyColors["a"]);
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetTextHeight(CT_PartyColors["s"]+7);

			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], CT_PartyColors["a"]);
			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetTextHeight(CT_PartyColors["s"]+7);

			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], CT_PartyColors["a"]);
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetTextHeight(CT_PartyColors["s"]+7);

			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"], CT_PartyColors["a"]);
			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetTextHeight(CT_PartyColors["s"]+7);
		end

		CT_PartyHealthOptionsFrameEditColorButtonNormalTexture:SetVertexColor(CT_PartyColors["r"], CT_PartyColors["g"], CT_PartyColors["b"]);
	end
end

function CT_PartyHealthFrame_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

function CT_PartyHealthSlider_OnLoad()
	getglobal(this:GetName().."Text"):SetText(CT_PARTYHEALTH_TEXTSIZE);
	getglobal(this:GetName().."High"):SetText(CT_PARTYHEALTH_TEXTSIZE_LARGE);
	getglobal(this:GetName().."Low"):SetText(CT_PARTYHEALTH_TEXTSIZE_SMALL);
	this:SetMinMaxValues(1, 5);
	this:SetValueStep(1);
	this.tooltipText = "Allows you to change the text size of the party health & mana texts.";
end

-- // Register slash commands // --

SlashCmdList["PARTYHEALTH"] = function(msg)
	if ( msg == "help" or msg == "" ) then
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[1], 1, 1, 0);
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[2], 1, 1, 0);
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[3], 1, 1, 0);
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[4], 1, 1, 0);
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[5], 1, 1, 0);
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[6], 1, 1, 0);
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_SLASH[7], 1, 1, 0);
	elseif ( msg == "toggle" ) then
		CT_PartyHealth_CurrPosition = CT_PartyHealth_CurrPosition+1;
		CT_PartyHealth_Print("<CTMod> " .. format(CT_PARTYHEALTH_TOGGLE, CT_PartyHealth_CurrPosition), 1, 1, 0);
		if ( CT_SetModValue ) then
			CT_SetModValue(CT_PARTYHEALTH_MODNAME1, CT_PartyHealth_CurrPosition);
		end
		CT_PartyHealth_UpdatePositions();
	elseif ( string.find(msg, "^style %d$") ) then
		local useless, useless, style = string.find(msg, "^style (%d)$");
		CT_PartyHealth_CurrPosition = tonumber(style);
		if ( CT_SetModValue ) then
			CT_SetModValue(CT_PARTYHEALTH_MODNAME1, tonumber(style));
		end
		CT_PartyHealth_Print("<CTMod> " .. format(CT_PARTYHEALTH_TOGGLE, CT_PartyHealth_CurrPosition), 1, 1, 0);
		CT_PartyHealth_UpdatePositions();
	elseif ( msg == "edit" ) then
		CT_PartyHealthOptionsFrame:Show();
	elseif ( msg == "on" ) then
		CT_PartyHealth_Status = 1;
		CT_PartyHealth_UpdatePositions();
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_ON, 1, 1, 0);
	elseif ( msg == "off" ) then
		CT_PartyHealth_Status = 0;
		CT_PartyHealth_UpdatePositions();
		CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_OFF, 1, 1, 0);
	end
end

SLASH_PARTYHEALTH1 = "/partyhealth";
SLASH_PARTYHEALTH2 = "/phealth";

-- // CTMod Toggle functions // --

local function toggle(modId, text)
	CT_PartyHealth_CurrPosition = CT_PartyHealth_CurrPosition + 1;
	if ( CT_PartyHealth_CurrPosition == 8 ) then CT_PartyHealth_CurrPosition = 1; end
	CT_Mods[modId]["modValue"] = CT_PartyHealth_CurrPosition;

	CT_PartyHealth_Print("<CTMod> " .. format(CT_PARTYHEALTH_TOGGLE, CT_PartyHealth_CurrPosition), 1, 1, 0);

	CT_PartyHealth_UpdatePositions();

	if ( text ) then text:SetText(CT_PartyHealth_CurrPosition); end
end

local function showframe(modId, text)
	CT_PartyHealthOptionsFrame:Show();
	if ( text ) then text:SetText(""); end
end

local function inittoggle(modId)
	CT_PartyHealth_CurrPosition = CT_Mods[modId]["modValue"];
	CT_PartyHealth_UpdatePositions();
end

function CT_PartyHealth_UpdatePositions()
	local number, percent;
	if ( CT_PartyHealth_Status == 0 ) then
		number = {};
		percent = {};
	else
		number = CT_PartyHealth_Positions[1][tonumber(CT_PartyHealth_CurrPosition)];
		percent = CT_PartyHealth_Positions[2][tonumber(CT_PartyHealth_CurrPosition)];
	end

	if ( not number[1] ) then
		for i = 1, 4, 1 do
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):Hide();
			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):Hide();
		end
	else
		for i = 1, 4, 1 do
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):Show();
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):ClearAllPoints();
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetPoint(number[1], "PartyMemberFrame" .. i .. number[2], number[3], number[4], number[5]);

			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):Show();
			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):ClearAllPoints();
			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetPoint(number[1], "PartyMemberFrame" .. i .. number[2], number[3], number[4], number[5]-8);
		end
	end

	if ( not percent[1] ) then
		for i = 1, 4, 1 do
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):Hide();
			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):Hide();
		end
	else
		for i = 1, 4, 1 do
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):Show();
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):ClearAllPoints();
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetPoint(percent[1], "PartyMemberFrame" .. i .. percent[2], percent[3], percent[4], percent[5]);

			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):Show();
			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):ClearAllPoints();
			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetPoint(percent[1], "PartyMemberFrame" .. i .. percent[2], percent[3], percent[4], percent[5]-8);
		end
	end
end

function CT_PartyHealth_Print(msg, r, g, b)
	if ( CT_Print ) then
		CT_Print(msg, r, g, b);
	else
		DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
	end
end

if ( CT_RegisterMod ) then
	CT_RegisterMod(CT_PARTYHEALTH_MODNAME1, CT_PARTYHEALTH_SUBNAME1, 3, "Interface\\Icons\\INV_Stone_04", CT_PARTYHEALTH_TOOLTIP1, "switch", "1", toggle, inittoggle);
	CT_RegisterMod(CT_PARTYHEALTH_MODNAME2, CT_PARTYHEALTH_SUBNAME2, 3, "Interface\\Icons\\Spell_Nature_Rejuvenation", CT_PARTYHEALTH_TOOLTIP2, "switch", "", showframe);
else
	CT_PartyHealth_Print("<CTMod> " .. CT_PARTYHEALTH_LOADED, 1, 0.5, 0);
end

-- // Update Party Health // --
function CT_PartyHealth_UpdateMember(unit, health)
	local i = strsub(unit, 6, 6);
	if ( health ) then
		local hp = getglobal("PartyMemberFrame" .. i).unitHPPercent;
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
		getglobal("PartyMemberFrame" .. i .. "HealthBar"):SetStatusBarColor(r, g, 0);
		if ( UnitHealthMax(unit) > 0 ) then
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetText(UnitHealth(unit) .. "/" .. UnitHealthMax(unit));
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetText(floor(UnitHealth(unit)/UnitHealthMax(unit)*100+0.5) .. "%");
		else
			getglobal("CT_PartyHealthFrame" .. i .. "HealthText"):SetText("");
			getglobal("CT_PartyHealthFrame" .. i .. "HealthPercent"):SetText("");
		end
	else
		if ( UnitManaMax(unit) > 0 ) then
			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetText(UnitMana(unit) .. "/" .. UnitManaMax(unit));
			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetText(floor(UnitMana(unit)/UnitManaMax(unit)*100+0.5) .. "%");
		else
			getglobal("CT_PartyHealthFrame" .. i .. "ManaText"):SetText("");
			getglobal("CT_PartyHealthFrame" .. i .. "ManaPercent"):SetText("");
		end
	end
end

function CT_PartyHealth_Update(unit, event)
	if ( event == "PARTY_MEMBERS_CHANGED" or event == "VARIABLES_LOADED" ) then
		for i = 1, GetNumPartyMembers(), 1 do
			CT_PartyHealth_UpdateMember("party" .. i, 1);
			CT_PartyHealth_UpdateMember("party" .. i, nil);
		end
		CT_PartyHealth_UpdatePositions();
	elseif ( string.find(unit, "^party%d$") ) then
		if ( event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" ) then
			CT_PartyHealth_UpdateMember(unit, 1);
		else
			CT_PartyHealth_UpdateMember(unit, nil);
		end
	end
end
