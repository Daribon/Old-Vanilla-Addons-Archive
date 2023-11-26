UIPanelWindows["CT_CPFrame"] = { area = "left", pushable = 1 };

CT_CPMovable = nil;

local CT_CPTabs = {
	{ "General", "General", "Interface\\Icons\\Spell_Shadow_SoulGem" },
	{ "Hotbar Mods", "Hotbar Mods", "Interface\\Icons\\Ability_Rogue_SliceDice" },
	{ "Party Mods", "Party Mods", "Interface\\Icons\\Spell_Nature_Invisibilty" },
	{ "Player Mods", "Player Mods", "Interface\\Icons\\Ability_Warrior_Revenge" },
	{ "Misc. Mods", "Misc. Mods", "Interface\\Icons\\Spell_Frost_Stun" }
};

function CT_UnlockCP(movable)
	CT_CPMovable = movable;
	HideUIPanel(CT_CPFrame);
	if ( movable ) then
		tinsert(UISpecialFrames, "CT_CPFrame");
		UIPanelWindows["CT_CPFrame"] = nil;
		CT_CPMoveButton:Show();
	else
		CT_CPMoveButton:Hide();
		for key, val in UISpecialFrames do
			if ( val == "CT_CPFrame" ) then val = nil; end
		end
		UIPanelWindows["CT_CPFrame"] = { area = "left", pushable = 1 };
	end
	ShowUIPanel(CT_CPFrame);
end
local NUM_CP_TABS = getn(CT_CPTabs);
local MAX_CP_TABS = 8;
local MAX_CP_ICONS = 14;

function CT_CPSetTab(id)
	if ( id == 1 ) then
		CT_CPGeneralSlider:Show();
		CT_CPGeneralMoveText:Show();
		CT_CPGeneralMoveCB:Show();
	else
		CT_CPGeneralSlider:Hide();
		CT_CPGeneralMoveText:Hide();
		CT_CPGeneralMoveCB:Hide();
	end
	if ( CT_CPFrame.currTab) then
		getglobal("CT_CPTab" .. CT_CPFrame.currTab):SetChecked(nil);
	end
	getglobal("CT_CPTab" .. id):SetChecked(1);

	CT_CPFrame.currTab = id;
	CT_CPTabText:SetText(CT_CPTabs[id][1]);
	CT_CPFrame_UpdateButtons();
end

function CT_CPFrame_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	CT_CPTab_OnClick(1);
	for i = 1, NUM_CP_TABS, 1 do
		getglobal("CT_CPTab" .. i).tooltiptext = CT_CPTabs[i][2];
		getglobal("CT_CPTab" .. i):SetNormalTexture(CT_CPTabs[i][3]);
		getglobal("CT_CPTabButton" .. i).tooltiptext = CT_CPTabs[i][2];
	end
	CT_CPFrame_UpdateButtons();
	CT_CPWelcomeText:SetText(CT_MASTERMOD_CPWELCOMETEXT);
end

function CT_CPFrame_OnShow()
	PlaySound("igSpellBookOpen");
end

function CT_CPFrame_Update()
	for i = 1, MAX_CP_TABS, 1 do
		if ( i > NUM_CP_TABS ) then
			getglobal("CT_CPTab" .. i):Hide();
		else
			getglobal("CT_CPTab" .. i):Show();
		end
	end
end

function CT_CPFrame_OnHide()
	PlaySound("igSpellBookClose");
end

function CT_CPButton_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	if ( GameTooltip:SetText(this.tooltiptext) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function CT_CPButton_OnUpdate(elapsed)
	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		CT_CPButton_OnEnter();
	else
		this.updateTooltip = nil;
	end
end

function CT_CPButton_OnLoad()
	local buttonid = this:GetID();
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	CT_CPButton_UpdateButton();
end

function CT_CPButton_OnClick() 
	local value = CT_Mods[this.id];
	if ( not value or not value["modStatus"] ) then return; end
	if ( value["modStatus"] == "switch" ) then
		value["modFunc"](this.id, getglobal("CT_CPButton" .. this:GetID() .. "Count"));
		CT_SaveInfoName(value["modName"]);
		this:SetChecked("false");
		return;
	end

	if ( value["modStatus"] == "off" ) then
		CT_SetModStatus(value["modName"], "on");
		this:SetChecked("true");
	else
		this:SetChecked("false");
		CT_SetModStatus(value["modName"], "off");
	end
	if ( value["modFunc"] ) then
		value["modFunc"](this.id);
	end
end

function CT_CPButton_OnShow()
	CT_CPButton_UpdateButton();
end

function CT_CPButton_UpdateButton(btn)
	local button;
	if ( btn ) then
		button = btn;
	else
		button = this;
	end
	local i = button:GetID();
	local icon = getglobal("CT_CPButton"..i .. "NormalTexture");
	local iconTexture = getglobal("CT_CPButton"..i.."IconTexture");
	local iconName = getglobal("CT_CPButton"..i.."Name");
	local iconDescription = getglobal("CT_CPButton"..i.."SubName");
	local highlightTexture = getglobal("CT_CPButton"..i.."Highlight");
	local normalTexture = getglobal("CT_CPButton"..i.."NormalTexture");
	local iconCount = getglobal("CT_CPButton"..i.."Count");
		
	local modString = getglobal("CT_CPButton"..i.."Name");
	local descriptString = getglobal("CT_CPButton"..i.."SubName");
	local modName, modDescript, modIcon, modValue;
	local modId = CT_CPFrame_GetModID(i);
	local val = CT_Mods[modId];
	if ( not val ) then
		button:Hide();
		return;
	else
		button:Show();
	end

	if ( icon ) then icon:Show(); end
	if ( iconTexture ) then iconTexture:Show(); iconTexture:SetVertexColor(1.0, 1.0, 1.0); end
	if ( highlightTexture ) then highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square"); end
	if ( modString ) then modString:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b); end
	modStatus = val["modStatus"];
	modName = val["modName"];
	modDescript = val["modDescript"];
	modIcon = val["modIcon"];
	modValue = val["modValue"];
	button.tooltiptext = val["modTooltip"];
	button.id = modId;

	if ( val["modOnDisplay"] and type(val["modOnDisplay"]) == "function" and this:IsVisible() ) then
		val["modOnDisplay"](modName, modStatus, modValue, iconCount);
	end

	if ( iconTexture ) then iconTexture:SetTexture(modIcon); end
	if ( modString ) then modString:SetText(modName); end
	if ( descriptString ) then descriptString:SetText(modDescript); end
	if ( iconCount ) then iconCount:SetText(modValue); end
	if ( modString ) then modString:Show(); end
	if ( descriptString ) then descriptString:Show(); end
	if ( modStatus == "disabled" ) then
		if ( iconTexture ) then iconTexture:SetVertexColor(0.5, 0.5, 0.5); end
	end
	if ( btn ) then
		CT_CPButton_UpdateSelection(btn);
	else
		CT_CPButton_UpdateSelection();
	end
end

function CT_CPTab_OnClick(id)
	local update;
	if ( not id ) then
		id = this:GetID();
	end
	CT_CPSetTab(id);
	if ( id == 1 ) then
		-- Show Welcome Text
		CT_CPWelcomeText:Show();
	else
		-- Hide Welcome Text
		CT_CPWelcomeText:Hide();
	end

	CT_CPFrame_Update();
end

function CT_CPButton_UpdateSelection(btn)
	local button;
	if ( btn ) then
		button = btn;
	else
		button = this;
	end
	local i = button.id;
	local status = CT_Mods[i];
	if ( not status ) then
		return;
	else
		status = status["modStatus"];
		if ( not status ) then
			return;
		end
	end
	if ( status == "on" ) then
		button:SetChecked("true");
	else
		button:SetChecked("false");
	end
end

function CT_CPFrame_UpdateButtons()
	for i = 1, 14, 1 do
		CT_CPButton_UpdateButton(getglobal("CT_CPButton" .. i));
	end
end

function CT_CPFrame_HideButton(btn)
	local name = btn:GetName();
	btn:Hide();
	--[[getglobal(name .. "NormalTexture"):Hide();
	getglobal(name .. "IconTexture"):Hide();
	getglobal(name .. "Name"):SetText("");
	getglobal(name .. "SubName"):SetText("");
	getglobal(name .. "Highlight"):Hide();
	getglobal(name .. "NormalTexture"):Hide();
	getglobal(name .. "Count"):SetText("");]]
end

function CT_CPFrame_GetModID(num)
	local counter = 1;
	for key, val in CT_Mods do
		if ( key ~= "version" ) then
			if ( val["modType"] == CT_CPFrame.currTab and val["modOrder"] == num ) then
				return key;
			end
		end
	end
	return -1;
end

SlashCmdList["CTCP"] = function()
	if ( CT_CPFrame:IsVisible() ) then
		CT_CPFrame:Hide();
	else
		CT_CPFrame:Show();
	end
end

SLASH_CTCP1 = "/ctcp";