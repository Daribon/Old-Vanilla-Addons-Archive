CT_AddMovable("CT_HotbarLeft_Drag", "Left Hotbar", "BOTTOM", "TOP", "ActionButton1", -4, 58, function(status)
	if ( status and CT_HotbarLeft:IsVisible() ) then
		CT_HotbarLeft_Drag:Show()
	else
		CT_HotbarLeft_Drag:Hide();
	end
end);

CT_AddMovable("CT_HotbarRight_Drag", "Right Hotbar", "BOTTOM", "TOP", "ActionButton11", 85, 58, function(status)
	if ( status and CT_HotbarRight:IsVisible() ) then
		CT_HotbarRight_Drag:Show()
	else
		CT_HotbarRight_Drag:Hide();
	end
end);

CT_AddMovable("CT_SidebarLeft_Drag", "Left Sidebar", "TOPLEFT", "TOPLEFT", "UIParent", 15, -86, function(status)
	if ( status and CT_SidebarFrame:IsVisible() ) then
		CT_SidebarLeft_Drag:Show()
	else
		CT_SidebarLeft_Drag:Hide();
	end
end);

CT_AddMovable("CT_SidebarRight_Drag", "Right Sidebar", "TOPRIGHT", "TOPRIGHT", "UIParent", -15, -148, function(status)
	if ( status and CT_SidebarFrame2:IsVisible() ) then
		CT_SidebarRight_Drag:Show()
	else
		CT_SidebarRight_Drag:Hide();
	end
end);

CT_AddMovable("CT_HotbarTop_Drag", "Top Hotbar", "BOTTOM", "TOP", "ActionButton10", 84, 100, function(status)
	if ( status and CT_HotbarTop:IsVisible() ) then
		CT_HotbarTop_Drag:Show()
	else
		CT_HotbarTop_Drag:Hide();
	end
end);

CT_AddMovable("CT_PetBar_Drag", "Pet bar", "BOTTOMLEFT", "BOTTOMLEFT", "MainMenuBar", 51, 82, function(status)
	if ( status and PetActionBarFrame:IsVisible() ) then
		CT_PetBar_Drag:Show()
	else
		CT_PetBar_Drag:Hide();
	end
end, function()
	if ( CT_HotbarLeft:IsVisible() ) then
		local x = CT_PetBar_Drag:GetLeft()-MainMenuBar:GetLeft();
		local y = CT_PetBar_Drag:GetBottom()+40;
		CT_PetBar_Drag:ClearAllPoints();
		CT_PetBar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", x, y);
	end
end);

CT_AddMovable("CT_BABar_Drag", "Class bar (Rogue/Warrior/Paladin/Druid)", "BOTTOMLEFT", "BOTTOMLEFT", "MainMenuBar", 43, 88, function(status)
	if ( status and ShapeshiftBarFrame:IsVisible() ) then
		CT_BABar_Drag:Show()
	else
		CT_BABar_Drag:Hide();
	end
end, function()
	if ( CT_HotbarLeft:IsVisible() ) then
		local x = CT_BABar_Drag:GetLeft()-MainMenuBar:GetLeft();
		local y = CT_BABar_Drag:GetBottom()+40;
		CT_BABar_Drag:ClearAllPoints();
		CT_BABar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", x, y);
	end
end);

CT_oldPetActionBar_UpdatePosition = PetActionBar_UpdatePosition;
function CT_newPetActionBar_UpdatePosition()
	CT_oldPetActionBar_UpdatePosition();
	CT_LinkFrameDrag(PetActionButton1, CT_PetBar_Drag, "TOPLEFT", "BOTTOMRIGHT", 2, 2);
	if ( CT_Mods[BARMOD_MODNAME_PETTEX]["modStatus"] == "off" ) then
		SlidingActionBarTexture0:ClearAllPoints();
		SlidingActionBarTexture0:SetPoint("BOTTOMLEFT", "PetActionButton1", "BOTTOMLEFT", -36, -1);
	end
end
PetActionBar_UpdatePosition = CT_newPetActionBar_UpdatePosition;

CT_BarMod_HidePetBarTextures = 1;
local CT_Hotcast = 0;
CT_SelfCast = 0;
CT_FadeColor = { ["r"] = 1.0, ["g"] = 1.0, ["b"] = 1.0 };
CT_Actio77nBar_LockedPage = 1;
local CT_NextSelfCast;

RegisterForSave("CT_ActionBar_LockedPage");
CT_Hotbar = { };
CT_SidebarAxis = {
	[1] = 2,
	[2] = 2,
	[3] = 1,
	[4] = 1,
	[5] = 2
};
CT_HotbarAxises = { };
RegisterForSave("CT_SidebarAxis");

CT_LSidebar_Buttons = 12;
CT_RSidebar_Buttons = 12;
CT_Alt_Hotbar = 0;
CT_Hotbars_Locked = 0;
CT_HotbarButtons_Locked = 0;

CT_ShowGrid = 1;

function CT_LSidebar_Update(modid)
	local val = CT_Mods[modid];
	local modStatusleft;
	modStatusleft = val["modStatus"];
	if ( val["modStatus"] == "off" ) then
		CT_SidebarFrame:Hide();
	else
		CT_SidebarFrame:Show();
	end
end

function LCT_SidebarBtns_Update(modid)
	local val;
	if ( modid ) then
		val = CT_Mods[modid];
	else
		for key, v in CT_Mods do
			if ( v["modName"] and v["modName"] == BARMOD_MODNAME_LBB ) then
				val = CT_Mods[key];
			end
		end
	end
	CT_LSidebar_Buttons = tonumber(val["modValue"]); 
	for i=1, 12, 1 do
		if ( i > CT_LSidebar_Buttons ) then
			getglobal("CT3_ActionButton" .. i):Hide();
			--[[getglobal("CT3_ActionButton" .. i .. "Icon"):Hide();
			getglobal("CT3_ActionButton" .. i .. "HighlightTexture"):Hide();
			getglobal("CT3_ActionButton" .. i .. "CheckedTexture"):Hide();
			getglobal("CT3_ActionButton" .. i .. "PushedTexture"):Hide();
			getglobal("CT3_ActionButton" .. i .. "HotKey"):Hide();]]
		else
			getglobal("CT3_ActionButton" .. i):Show();
			--[[getglobal("CT3_ActionButton" .. i .. "Icon"):Show();
			getglobal("CT3_ActionButton" .. i .. "HighlightTexture"):Show();
			getglobal("CT3_ActionButton" .. i .. "HotKey"):Show();]]
		end
	end
end

function RCT_SidebarBtns_Update(modid)
	local val;
	if ( modid ) then
		val = CT_Mods[modid];
	else
		for key, v in CT_Mods do
			if ( v["modName"] and v["modName"] == BARMOD_MODNAME_RBB ) then
				val = CT_Mods[key];
			end
		end
	end
	CT_RSidebar_Buttons = tonumber(val["modValue"]); 
	for i=1, 12, 1 do
		if ( i > CT_RSidebar_Buttons ) then
			getglobal("CT4_ActionButton" .. i):Hide();
			--[[getglobal("CT4_ActionButton" .. i .. "Icon"):Hide();
			getglobal("CT4_ActionButton" .. i .. "HighlightTexture"):Hide();
			getglobal("CT4_ActionButton" .. i .. "CheckedTexture"):Hide();
			getglobal("CT4_ActionButton" .. i .. "PushedTexture"):Hide();
			getglobal("CT4_ActionButton" .. i .. "HotKey"):Hide();]]
		else
			getglobal("CT4_ActionButton" .. i):Show();
			--[[getglobal("CT4_ActionButton" .. i .. "Icon"):Show();
			getglobal("CT4_ActionButton" .. i .. "HighlightTexture"):Show();
			getglobal("CT4_ActionButton" .. i .. "HotKey"):Show();]]
		end
	end
end

function CT_RSidebar_Update(modid)
	local val = CT_Mods[modid];
	if ( val["modStatus"] == "off" ) then
		CT_SidebarFrame2:Hide();
	else
		CT_SidebarFrame2:Show();
	end
	if ( modStatusLock == "off" ) then
		CT_Hotbars_Locked = 0;
	else
		CT_Hotbars_Locked = 1;
	end
	if ( modStatusButLock == "off" ) then
		CT_HotbarButtons_Locked = 0;
	else
		CT_HotbarButtons_Locked = 1;
	end
end

function CT_SidebarLock_Update(modid)
	local val = CT_Mods[modid];
	if ( val["modStatus"] == "off" ) then
		CT_Hotbars_Locked = 0;
	else
		CT_Hotbars_Locked = 1;
	end
	if ( modStatusButLock == "off" ) then
		CT_HotbarButtons_Locked = 0;
	else
		CT_HotbarButtons_Locked = 1;
	end
end

function CT_ButtonLock_Update(modid)
	local val = CT_Mods[modid];
	if ( val["modStatus"] == "off" ) then
		CT_HotbarButtons_Locked = 0;
	else
		CT_HotbarButtons_Locked = 1;
	end
end

function CT_Sidebar_ButtonInUse(btn)
	if ( ( strsub(btn:GetName(), 1, 3) == "CT3" and btn:GetID() <= CT_LSidebar_Buttons ) or ( strsub( btn:GetName(), 1, 3) == "CT4" and btn:GetID() <= CT_RSidebar_Buttons ) ) then
		return 1;
	else
		return nil;
	end
end

function CT_HotbarcastUp(id)
	CT_Hotbar[id] = nil;
end

function CT_HotbarcastDown(id)
	CT_Hotbar[id] = 1;
end

function CT_ActionButton_Update()
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local pagedID = CT_ActionButton_GetPagedID(this);
	if ( IsAttackAction(pagedID) and IsCurrentAction(pagedID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(pagedID);

	if ( this.isBonus and this.inTransition ) then
		CT_ActionButton_UpdateUsable();
		CT_ActionButton_UpdateCooldown();
		return;
	end
	
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(pagedID);
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		this.rangeTimer = TOOLTIP_UPDATE_TIME;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
		if ( this.isBonus ) then
			this.texture = texture;
		end
		
	else
		icon:Hide();
		buttonCooldown:Hide();
		this.rangeTimer = nil;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
		getglobal(this:GetName().."HotKey"):SetVertexColor(0.6, 0.6, 0.6);
	end
	CT_ActionButton_UpdateCount();
	if ( ( ( strsub( this:GetName(), 1, 3) == "CT3" and this:GetID() <= CT_LSidebar_Buttons ) or ( strsub( this:GetName(), 1, 3) == "CT4" and this:GetID() <= CT_RSidebar_Buttons ) ) or ( strsub ( this:GetName(), 1, 3 ) ~= "CT3" and strsub ( this:GetName(), 1, 3 ) ~= "CT4" ) ) then
		this:Show();
	end
	if ( HasAction(pagedID) ) then
		CT_ActionButton_UpdateUsable();
		CT_ActionButton_UpdateCooldown();
	elseif ( this.showgrid == 0 ) then
		if ( CT_ShowGrid == 0 ) then 
			this:Hide();
		end
	else
		getglobal(this:GetName().."Cooldown"):Hide();
	end
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		CT_ActionButton_StartFlash();
	else
		CT_ActionButton_StopFlash();
	end
	if ( GameTooltip:IsOwned(this) ) then
		CT_ActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	macroName:SetText(GetActionText(pagedID));
end

function CT_ActionButton_HideGrid(button)
	local btn;
	if ( button ) then
		btn = button;
	else
		btn = this;
	end
	if ( CT_ShowGrid == 1 ) then return; end
	btn.showgrid = 0;
	if ( not HasAction(CT_ActionButton_GetPagedID(btn)) ) then
		btn:Hide();
	end
end

function CT_ActionButton_OnLoad()
	if ( ( ( strsub( this:GetName(), 1, 3) == "CT3" and this:GetID() <= CT_LSidebar_Buttons ) or ( strsub( this:GetName(), 1, 3) == "CT4" and this:GetID() <= CT_RSidebar_Buttons ) ) and ( strsub( this:GetName(), 1, 3 ) == "CT3" or strsub( this:GetName(), 1, 3 ) == "CT4" ) ) then
		this:Hide();
	else
		this:Show();
	end
	this.flashing = 0;
	this.flashtime = 0;
	ActionButton_Update();
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("ACTIONBAR_SHOWGRID");
	this:RegisterEvent("ACTIONBAR_HIDEGRID");
	this:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("ACTIONBAR_UPDATE_STATE");
	this:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	this:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("UNIT_AURASTATE");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("CRAFT_SHOW");
	this:RegisterEvent("CRAFT_CLOSE");
	this:RegisterEvent("TRADE_SKILL_SHOW");
	this:RegisterEvent("TRADE_SKILL_CLOSE");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_FOCUS");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterEvent("START_AUTOREPEAT_SPELL");
	this:RegisterEvent("STOP_AUTOREPEAT_SPELL");
	CT_ActionButton_UpdateHotkeys();
	this.showgrid = 2;
end

function CT_ActionButton_UpdateHotkeys(actionbtn)
	if ( not actionbtn ) then actionbtn = this; end
	if ( CT_ShowHotkeys == -1 ) then
		getglobal(actionbtn:GetName() .. "HotKey"):Hide();
		return;
	end
	getglobal(actionbtn:GetName() .. "HotKey"):Show();
	if ( not CT_ShowHotkeys ) then
		local key = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" };
		getglobal(actionbtn:GetName() .. "HotKey"):SetText(key[actionbtn:GetID()]);
		return;
	end
	local prefix;
	if ( strsub(actionbtn:GetName(), 0, 3) == "CT_" ) then
		prefix = "CT_HOTBAR1";
	else
		prefix = "CT_HOTBAR" .. strsub(actionbtn:GetName(), 3, 3);
	end
	local hotkey = getglobal(actionbtn:GetName().."HotKey");

	local action = prefix .. "BUTTON"..actionbtn:GetID();
	local text = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");

	text = string.gsub(text, "CTRL%-", "C-");
	text = string.gsub(text, "ALT%-", "A-");
	text = string.gsub(text, "SHIFT%-", "S-");
	text = string.gsub(text, "Num Pad", "NP");
	text = string.gsub(text, "Backspace", "Bksp");
	text = string.gsub(text, "Spacebar", "Space");
	text = string.gsub(text, "Page", "Pg");
	text = string.gsub(text, "Down", "Dn");
	text = string.gsub(text, "Arrow", "");
	text = string.gsub(text, "Insert", "Ins");
	text = string.gsub(text, "Delete", "Del");

	hotkey:SetText(text);
end

function CT_ActionButton_UpdateState()
	if ( IsCurrentAction(CT_ActionButton_GetPagedID(this)) ) then
		this:SetChecked(1);
	else
		this:SetChecked(0);
	end
end

function CT_ActionButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(CT_ActionButton_GetPagedID(this));
	if ( isUsable ) then
		if ( this.inRange and this.inRange == 0 ) then
			icon:SetVertexColor(CT_FadeColor.r, CT_FadeColor.g, CT_FadeColor.b);
			if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(CT_FadeColor.r, CT_FadeColor.g, CT_FadeColor.b); end
		else
			icon:SetVertexColor(1.0, 1.0, 1.0);
			if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(1.0, 1.0, 1.0); end
		end
	elseif ( notEnoughMana ) then
		icon:SetVertexColor(0.5, 0.5, 1.0);
		if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(0.5, 0.5, 1.0); end
	else
		icon:SetVertexColor(0.4, 0.4, 0.4);
		if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(0.4, 0.4, 0.4); end
	end
end

function CT_ActionButton_UpdateCount()
	local text = getglobal(this:GetName().."Count");
	local count = GetActionCount(CT_ActionButton_GetPagedID(this));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function CT_ActionButton_UpdateCooldown()
	local cooldown = getglobal(this:GetName().."Cooldown");
	local start, duration, enable = GetActionCooldown(CT_ActionButton_GetPagedID(this));
	CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function CT_ActionButton_OnEvent(event)
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == CT_ActionButton_GetPagedID(this) ) then
			CT_ActionButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" ) then
		CT_ActionButton_Update();
		CT_ActionButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		CT_ActionButton_ShowGrid();
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		CT_ActionButton_HideGrid();
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		CT_ActionButton_UpdateHotkeys();
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not this:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		CT_ActionButton_UpdateUsable();
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			CT_ActionButton_UpdateUsable();
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			CT_ActionButton_Update();
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		CT_ActionButton_UpdateState();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" ) then
		CT_ActionButton_UpdateUsable();
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		CT_ActionButton_UpdateCooldown();
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		CT_ActionButton_UpdateState();
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		CT_ActionButton_UpdateUsable();
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(CT_ActionButton_GetPagedID(this)) ) then
			CT_ActionButton_StartFlash();
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = 0;
		if ( IsAttackAction(CT_ActionButton_GetPagedID(this)) ) then
			CT_ActionButton_StopFlash();
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		CT_ActionButton_UpdateUsable();
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(CT_ActionButton_GetPagedID(this)) ) then
			CT_ActionButton_StartFlash();
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( ActionButton_IsFlashing() and not IsAttackAction(CT_ActionButton_GetPagedID(this)) ) then
			CT_ActionButton_StopFlash();
		end
		return;
	end
end

function CT_ActionButton_StartFlash()
	this.flashing = 1;
	this.flashtime = 0;
	CT_ActionButton_UpdateState();
end

function CT_ActionButton_StopFlash()
	this.flashing = 0;
	getglobal(this:GetName().."Flash"):Hide();
	CT_ActionButton_UpdateState();
end

function CT_ActionButton_SetTooltip()
	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
	else
		if ( this:GetCenter() < UIParent:GetCenter() ) then
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		else
			GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		end
	end
	
	if ( GameTooltip:SetAction(CT_ActionButton_GetPagedID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end

function CT_ActionButton_GetPagedID(button)
	if( button == nil ) then
		message("nil button passed into CT_ActionButton_GetPagedID(), contact Mod Author(cide/TS)");
		return 0;
	end
	local page = CURRENT_ACTIONBAR_PAGE;
	if ( CT_Hotbars_Locked == 1 ) then
		page = CT_ActionBar_LockedPage;
	end
	if ( not page ) then page = 1; end
	if ( strsub( button:GetName(), 1, 3 ) == "CT2" ) then
		page = page + 1;
	elseif ( strsub( button:GetName(), 1, 3 ) == "CT3" ) then
		page = page + 2;
	elseif ( strsub( button:GetName(), 1, 3 ) == "CT4" ) then
		page = page + 3;
	elseif ( strsub( button:GetName(), 1, 3 ) == "CT5" ) then
		page = page + 4;
	end
	if ( page >= 6 ) then
		page = page - 6;
	end
	return (button:GetID() + ((page) * NUM_ACTIONBAR_BUTTONS));
end

function CT_ActionButtonDown(bar, id)
	if ( bar == 1 ) then bar = ""; end -- First bar's buttons aren't named CT1
	local button = getglobal("CT" .. bar .. "_ActionButton" .. id);
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end

	if ( CT_SelfCastModifier ) then
		CT_NextSelfCast = 1;
	end
end

function CT_ActionButtonUp(bar, id)
	if ( bar == 1 ) then bar = ""; end -- First bar's buttons aren't named CT1
	local button = getglobal("CT" .. bar .. "_ActionButton" .. id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();

		if ( CT_NextSelfCast ) then
			UseAction(CT_ActionButton_GetPagedID(button), 0, 1);
		else
			UseAction(CT_ActionButton_GetPagedID(button), 1, nil);
			if ( SpellIsTargeting() and CT_SelfCast == 1 and SpellCanTargetUnit("player") ) then
				SpellTargetUnit("player");
			end
		end
		if ( CT_DebuffTimers_AddDebuff ) then
			CT_DebuffTimers_AddDebuff(CT_ActionButton_GetPagedID(button));
		end
		if ( IsCurrentAction(CT_ActionButton_GetPagedID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
	CT_NextSelfCast = nil;
end

CT_oldActionButtonUp = ActionButtonUp;

function CT_newActionButtonUp(id, onSelf)
	if ( CT_NextSelfCast ) then
		CT_oldActionButtonUp(id, 1);
	else
		CT_oldActionButtonUp(id, onSelf);
		if ( SpellIsTargeting() and CT_SelfCast == 1 and SpellCanTargetUnit("player") ) then
			SpellTargetUnit("player");
		end
	end
	CT_NextSelfCast = nil;
end

ActionButtonUp = CT_newActionButtonUp;

CT_oldActionButtonDown = ActionButtonDown;

function CT_newActionButtonDown(id)
	CT_oldActionButtonDown(id);
	if ( CT_SelfCastModifier or ( CT_SelfCastModKey and CT_SelfCastModKey() ) ) then
		CT_NextSelfCast = 1;
	end
end

ActionButtonDown = CT_newActionButtonDown;

function CT_LHotbar_Update()
	local modStatusLeft = "on";
	for key, val in CT_Mods do
		if ( val["modName"] == BARMOD_MODNAME_LEFTHB ) then
			modStatusLeft = val["modStatus"];
		end
	end
	if ( modStatusLeft == "off" ) then
		CT_HotbarLeft:Hide();
	else
		CT_HotbarLeft:Show();
		if ( not CT_BABar_Drag:IsUserPlaced() ) then
			CT_BABar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", 43, 128);
		end
		if ( not CT_PetBar_Drag:IsUserPlaced() ) then
			CT_PetBar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", 51, 122);
		end
	end
end
function CT_RHotbar_Update()
	local modStatusRight = "on";
	for key, val in CT_Mods do
		if ( val["modName"] == BARMOD_MODNAME_RIGHTHB ) then
			modStatusRight = val["modStatus"];
		end
	end
	if ( modStatusRight == "off" ) then
		CT_HotbarRight:Hide();
	else
		CT_HotbarRight:Show();
	end
end
function CT_THotbar_Update()
	local modStatusTop = "on";
	for key, val in CT_Mods do
		if ( val["modName"] == BARMOD_MODNAME_TOPHB ) then
			modStatusTop = val["modStatus"];
		end
	end
	if ( modStatusTop == "off" ) then
		CT_HotbarTop:Hide();
	else
		CT_HotbarTop:Show();
	end
end

function CT_GetRank(buttonid)
	CTTooltip:SetAction(buttonid);
	local text = getglobal("CTTooltipTextLeft" .. CTTooltip:NumLines()):GetText();
	local rank;
	if ( strfind( text, "Rank ") ) then
		rank = strsub( text, strfind( text, "Rank " )+5 );
	end
	return rank;
end

function CT_GetAvailableRanks(buttonid)
	local currrank = CT_GetRank(buttonid);
	local currspell = CTTooltipTextLeft1:GetText();
	local availableranks = "";
	for i=1, NUM_ACTIONBAR_BUTTONS*NUM_ACTIONBAR_PAGES, 1 do
		CTTooltip:SetAction(i);
		if ( CTTooltipTextLeft1:GetText() == currspell ) then
			availableranks = availableranks .. "," .. CT_GetRank(i);
		end
	end
	return availableranks;
end

function CT_ActionButton_ShowGrid()
	if ( CT_Sidebar_ButtonInUse(this) or ( strsub( this:GetName(), 1, 3 ) ~= "CT3" and strsub( this:GetName(), 1, 3 ) ~= "CT4" ) ) then
		this.showgrid = this.showgrid+1;
		getglobal(this:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
		this:Show();
	end
end

function CT_GetBagColumns()
	local freeScreenHeight = GetScreenHeight() - CONTAINER_OFFSET;
	local index = 1;
	local column = 0;
	for i=1, NUM_CONTAINER_FRAMES, 1 do
		if ( getglobal("ContainerFrame" .. i):IsVisible() ) then
			column = 1; break;
		end
	end
	while ContainerFrame1.bags[index] do
		local frame = getglobal(ContainerFrame1.bags[index]);
		-- freeScreenHeight determines when to start a new column of bags
		if ( freeScreenHeight < frame:GetHeight() and index > 1 ) then
			column = column + 1;
			freeScreenHeight = UIParent:GetHeight() - CONTAINER_OFFSET;	
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		index = index + 1;
	end
	return column;
end

function CT_HideButtons(buttonname, unt, stop, hidebefore)
	for i=1, stop, 1 do
		local button = getglobal(buttonname .. i);
		if ( i <= unt ) then
			if ( hidebefore == 1 ) then
				button:Hide();
			else
				button:Show();
			end
		else
			if ( hidebefore == 1 ) then
				button:Show();
			else
				button:Hide();
			end
		end
	end
end

CT_oldActionButton_OnUpdate = ActionButton_OnUpdate;

function CT_newActionButton_OnUpdate(elapsed)
	if ( this.rangeTimer and this.rangeTimer < 0 ) then
		if ( IsActionInRange( ActionButton_GetPagedID(this)) == 0 ) then
			this.inRange = 0;
		else
			this.inRange = 1;
		end
		ActionButton_UpdateUsable();
	end
	CT_oldActionButton_OnUpdate(elapsed);
end

ActionButton_OnUpdate = CT_newActionButton_OnUpdate;

CT_oldActionButton_UpdateUsable = ActionButton_UpdateUsable;

function CT_newActionButton_UpdateUsable()
	CT_oldActionButton_UpdateUsable();
	local icon = getglobal(this:GetName().."Icon");
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));
	if ( isUsable ) then
		if ( this.inRange and this.inRange == 0 ) then
			icon:SetVertexColor(CT_FadeColor.r, CT_FadeColor.g, CT_FadeColor.b);
		end
	end
end

ActionButton_UpdateUsable = CT_newActionButton_UpdateUsable;

function CT_ActionButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(CT_ActionButton_GetPagedID(this));
	if ( isUsable ) then
		if ( this.inRange and this.inRange == 0 ) then
			icon:SetVertexColor(CT_FadeColor.r, CT_FadeColor.g, CT_FadeColor.b);
			if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(CT_FadeColor.r, CT_FadeColor.g, CT_FadeColor.b); end
		else
			icon:SetVertexColor(1.0, 1.0, 1.0);
			if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(1.0, 1.0, 1.0); end
		end
	elseif ( notEnoughMana ) then
		icon:SetVertexColor(0.5, 0.5, 1.0);
		if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(0.5, 0.5, 1.0); end
	else
		icon:SetVertexColor(0.4, 0.4, 0.4);
		if ( CT_ShowGrid == 0 ) then normalTexture:SetVertexColor(0.4, 0.4, 0.4); end
	end
end

function CT_ActionButton_OnUpdate(elapsed)
	if ( ActionButton_IsFlashing() ) then
		this.flashtime = this.flashtime - elapsed;
		if ( this.flashtime <= 0 ) then
			local overtime = -this.flashtime;
			if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
				overtime = 0;
			end
			this.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;

			local flashTexture = getglobal(this:GetName().."Flash");
			if ( flashTexture:IsVisible() ) then
				flashTexture:Hide();
			else
				flashTexture:Show();
			end
		end
	end
	

	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			local count = getglobal(this:GetName().."HotKey");
			if ( IsActionInRange( CT_ActionButton_GetPagedID(this)) == 0 ) then
				count:SetVertexColor(1.0, 0.1, 0.1);
				this.inRange = 0;
			else
				count:SetVertexColor(1.0, 1.0, 1.0);
				this.inRange = 1;
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
			CT_ActionButton_UpdateUsable();
		else
			this.rangeTimer = this.rangeTimer - elapsed;
		end
	end

	if ( not this.updateTooltip ) then
		return;
	end

	this.updateTooltip = this.updateTooltip - elapsed;
	if ( this.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(this) ) then
		CT_ActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function CT_Sidebar_ChangeAxis(bar, force)
	local i, barstring;
	local types = {
		{ "LEFT", "RIGHT", 6, 0 },
		{ "TOP", "BOTTOM", 0, -6 }
	};
	local curraxis = CT_SidebarAxis[bar];
	if ( force ) then
		curraxis = force;
	end
	if ( tonumber(bar) == 1 ) then
		barstring = "";
	else
		barstring = tonumber(bar);
	end
	for i=2, 12, 1 do
		local btn = getglobal("CT" .. barstring .. "_ActionButton" .. i);
		if ( not btn ) then
			CT_Print("Failed at " .. "CT" .. barstring .. "_ActionButton" .. i .. " = " .. this:GetName());
		else
			btn:ClearAllPoints();
			btn:SetPoint(types[curraxis][1], "CT" .. barstring .. "_ActionButton" .. (i-1), types[curraxis][2], types[curraxis][3], types[curraxis][4]);
		end
	end
	if ( curraxis == 1 ) then
		CT_SidebarAxis[tonumber(bar)] = 2;
	else
		CT_SidebarAxis[tonumber(bar)] = 1;
	end
end

-- dbrong
-- Hook into Blizzard's function to reposition bag frames if the 
-- right hotbar or sidebars are turned on.

-- Anyone know an easier way?

BLIZZARD_Original_updateContainerFrameAnchors = updateContainerFrameAnchors;

function updateContainerFrameAnchors()
	CT_Bag_Update();
end

function CT_updateContainerFrameAnchors()
	local freeScreenHeight = GetScreenHeight() - CONTAINER_OFFSET;
	local index = 1;
	local column = 0;
	while ContainerFrame1.bags[index] do
		local frame = getglobal(ContainerFrame1.bags[index]);
		-- freeScreenHeight determines when to start a new column of bags
		if ( index == 1 ) then
			-- First bag
-- dbrong											was 0
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", -40, CONTAINER_OFFSET);
		elseif ( freeScreenHeight < frame:GetHeight() ) then
			-- Start a new column
			column = column + 1;
			freeScreenHeight = UIParent:GetHeight() - CONTAINER_OFFSET;
-- dbrong												              added + 40
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", -(column * CONTAINER_WIDTH + 40), CONTAINER_OFFSET);
		else
			-- Anchor to the previous bag
			frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);	
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		index = index + 1;
	end
	return column;
end

function CT_Bag_Update()
	if ( CT_HotbarTop:IsVisible() ) then	
		CONTAINER_OFFSET = 110;
	elseif ( CT_HotbarRight:IsVisible() ) then
		CONTAINER_OFFSET = 90;
	else
		CONTAINER_OFFSET = 70;
	end

	if ( CT_SidebarFrame2:IsVisible() ) then
		CT_updateContainerFrameAnchors();		
	else
		BLIZZARD_Original_updateContainerFrameAnchors();
	end

end

CT_oldFCF_UpdateDockPosition = FCF_UpdateDockPosition;
CT_newFCF_UpdateDockPosition = function() end;

function CT_GlobalFrame_OnUpdate(elapsed)
	this.update = this.update + elapsed;
	if ( this.elapsed ) then
		this.elapsed = this.elapsed + elapsed;
		if ( this.elapsed > 0.1 ) then
			if ( not CT_MovableParty_IsInstalled ) then
				CT_CheckLSidebar();
			end
			this.elapsed = nil;
		end
	end
	if ( SIMPLE_CHAT == "1" and this.update > 0.05 ) then
		FCF_UpdateDockPosition = CT_newFCF_UpdateDockPosition;
		this.update = this.update - 0.05;
		ChatFrame2:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -32, 95);
		if ( ShapeshiftBarFrame:IsVisible() ) then
			ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 138);
		elseif ( PetActionBarFrame:IsVisible() ) then
			ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 130);
		else
			ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 95);
		end
	else
		FCF_UpdateDockPosition = CT_oldFCF_UpdateDockPosition;
	end
end


HotbarsLockFunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "off" ) then
		CT_Hotbars_Locked = 0;
		CT_Print(BARMOD_OFF_HOTBARLOCK, 1.0, 1.0, 0.0);
	else
		CT_Hotbars_Locked = 1;
		CT_ActionBar_LockedPage = CURRENT_ACTIONBAR_PAGE;
		CT_Print(BARMOD_ON_HOTBARLOCK, 1.0, 1.0, 0.0);
	end
end

HotbarsLockInitFunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "off" ) then
		CT_Hotbars_Locked = 0;
	else
		CT_Hotbars_Locked = 1;
		--CT_ActionBar_LockedPage = CURRENT_ACTIONBAR_PAGE;
	end
end

HotbarButtonsLockFunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "off" ) then
		CT_HotbarButtons_Locked = 0;
		CT_Print(BARMOD_OFF_HOTBARBUTTONS, 1.0, 1.0, 0.0);
	else
		CT_HotbarButtons_Locked = 1;
		CT_Print(BARMOD_ON_HOTBARBUTTONS, 1.0, 1.0, 0.0);
	end
end
sidebarfunction = function()
	if ( CT_SidebarFrame:IsVisible() ) then
		CT_SidebarFrame:Hide();
		CT_SetModStatus(BARMOD_MODNAME_LEFTSB, "off");
		CT_Print(BARMOD_OFF_LEFTSBAR, 1.0, 1.0, 0.0);
	else
		if ( CT_MF_ShowFrames ) then
			CT_SidebarLeft_Drag:Show();
		end
		CT_SidebarFrame:Show();
		CT_SetModStatus(BARMOD_MODNAME_LEFTSB, "on");
		CT_Print(BARMOD_ON_LEFTSBAR, 1.0, 1.0, 0.0);
	end
	CT_CheckLSidebar();
end
sidebarRfunction = function()
	if ( CT_SidebarFrame2:IsVisible() ) then
		CT_SidebarFrame2:Hide();
		CT_SetModStatus(BARMOD_MODNAME_RIGHTSB, "off");
		CT_Print(BARMOD_OFF_RIGHTSBAR, 1.0, 1.0, 0.0);
	else
		if ( CT_MF_ShowFrames ) then
			CT_SidebarRight_Drag:Show();
		end
		CT_SidebarFrame2:Show();
		CT_SetModStatus(BARMOD_MODNAME_RIGHTSB, "on");
		CT_Print(BARMOD_ON_RIGHTSBAR, 1.0, 1.0, 0.0);
	end
-- dbrong
	CT_Bag_Update();
end
lsidebarbuttonsfunction = function(modID, text)
	local val = CT_Mods[modID]["modValue"];
	if ( val == "6" or val == 6 ) then
		val = "9";
	elseif ( val == "9" or val == 9 ) then
		val = "12";
	elseif ( val == "12" or val == 12 ) then
		val = "6";
	end
	if ( text ) then text:SetText(val); end
	CT_Mods[modID]["modValue"] = val;
	LCT_SidebarBtns_Update(modID);
end
rsidebarbuttonsfunction = function(modID, text)
	local val = CT_Mods[modID]["modValue"];
	if ( val == "6" or val == 6 ) then
		val = "9";
	elseif ( val == "9" or val == 9 ) then
		val = "12";
	elseif ( val == "12" or val == 12 ) then
		val = "6";
	end
	if ( text ) then text:SetText(val); end
	CT_Mods[modID]["modValue"] = val;
	RCT_SidebarBtns_Update(modID);
end
hotbarleftfunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "off" ) then
		CT_HotbarLeft:Hide();
		CT_LeftHotbar_OnHide();
		CT_Print(BARMOD_OFF_LEFTHBAR, 1.0, 1.0, 0.0);
	else
		if ( CT_MF_ShowFrames ) then
			CT_HotbarLeft_Drag:Show();
		end
		local x = CT_PetBar_Drag:GetLeft()-MainMenuBar:GetLeft();
		local y = CT_PetBar_Drag:GetBottom()+40;
		CT_PetBar_Drag:ClearAllPoints();
		CT_PetBar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", x, y);


		x = CT_BABar_Drag:GetLeft()-MainMenuBar:GetLeft();
		y = CT_BABar_Drag:GetBottom()+40;
		CT_BABar_Drag:ClearAllPoints();
		CT_BABar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", x, y);
		CT_HotbarLeft:Show();
		CT_Print(BARMOD_ON_LEFTHBAR, 1.0, 1.0, 0.0);
	end
end
hotbarrightfunction = function (modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "off" ) then
		CT_HotbarRight:Hide();
		CT_Print(BARMOD_OFF_RIGHTHBAR, 1.0, 1.0, 0.0);
	else
		if ( CT_MF_ShowFrames ) then
			CT_HotbarRight_Drag:Show();
		end
		CT_HotbarRight:Show();
		CT_Print(BARMOD_ON_RIGHTHBAR, 1.0, 1.0, 0.0);
	end
	CT_Bag_Update();
end

hotbartopfunction = function ()
	if ( CT_HotbarTop:IsVisible() ) then
		CT_HotbarTop:Hide();
		CT_SetModStatus(BARMOD_MODNAME_TOPHB, "off");
		CT_Print(BARMOD_OFF_TOPBAR, 1.0, 1.0, 0.0);
	else
		if ( CT_MF_ShowFrames ) then
			CT_HotbarTop_Drag:Show();
		end
		CT_HotbarTop:Show();
		CT_SetModStatus(BARMOD_MODNAME_TOPHB, "on");
		CT_Print(BARMOD_ON_TOPBAR, 1.0, 1.0, 0.0);
	end
	CT_Bag_Update();
end

function HotbarPositionLockFunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_SidebarLeft_Drag:Hide();
		CT_SidebarRight_Drag:Hide();
		CT_HotbarLeft_Drag:Hide();
		CT_HotbarRight_Drag:Hide();
		CT_HotbarTop_Drag:Hide();
		CT_Show_PetBarDrag = 0;
	else
		CT_SidebarLeft_Drag:Show();
		CT_SidebarRight_Drag:Show();
		CT_HotbarLeft_Drag:Show();
		CT_HotbarRight_Drag:Show();
		CT_HotbarTop_Drag:Show();
		CT_Show_PetBarDrag = 1;
	end
	if ( val == "on" ) then
		CT_Print(BARMOD_ON_HOTBARLOCK, 1, 1, 0);
	else
		CT_Print(BARMOD_OFF_HOTBARLOCK, 1, 1, 0);
	end
end

function HotbarPositionLockInitFunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_SidebarLeft_Drag:Hide();
		CT_SidebarRight_Drag:Hide();
		CT_HotbarLeft_Drag:Hide();
		CT_HotbarRight_Drag:Hide();
		CT_HotbarTop_Drag:Hide();
		CT_Show_PetBarDrag = 0;
	else
		CT_SidebarLeft_Drag:Show();
		CT_SidebarRight_Drag:Show();
		CT_HotbarLeft_Drag:Show();
		CT_HotbarRight_Drag:Show();
		CT_HotbarTop_Drag:Show();
		CT_Show_PetBarDrag = 1;
	end
end

function HotbarResetFunction()
	CT_HotbarLeft_Drag:ClearAllPoints();
	CT_HotbarRight_Drag:ClearAllPoints();
	CT_HotbarTop_Drag:ClearAllPoints();
	CT_SidebarLeft_Drag:ClearAllPoints();
	CT_SidebarRight_Drag:ClearAllPoints();
	CT_PetBar_Drag:ClearAllPoints();
	CT_HotbarLeft_Drag:SetPoint("BOTTOM", "ActionButton1", "TOP", 0, 58);
	CT_HotbarRight_Drag:SetPoint("BOTTOM", "ActionButton11", "TOP", 84, 58);
	CT_HotbarTop_Drag:SetPoint("BOTTOM", "ActionButton10", "TOP", 84, 100);
	CT_SidebarLeft_Drag:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 15, -86);
	CT_SidebarRight_Drag:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -15, -148);
	CT_PetBar_Drag:SetPoint("TOPLEFT", "MainMenuBar", "BOTTOMLEFT", 48, 143);
	CT_Sidebar_ChangeAxis(1, 1);
	CT_Sidebar_ChangeAxis(2, 1);
	CT_Sidebar_ChangeAxis(3, 2);
	CT_Sidebar_ChangeAxis(4, 2);
	CT_Sidebar_ChangeAxis(5, 1);
end

function gridfunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	local i;
	if ( val == "off" ) then
		CT_Print("<CTMod> Button grid is now shown.", 1, 1, 0);
		CT_ShowGrid = 1;
		for i=1, 12, 1 do
			getglobal("CT_ActionButton" .. i):Show();
			getglobal("CT2_ActionButton" .. i):Show();
			getglobal("CT5_ActionButton" .. i):Show();
			if ( CT_Sidebar_ButtonInUse(getglobal("CT3_ActionButton" .. i)) ) then
				getglobal("CT3_ActionButton" .. i):Show();
			end
			if ( CT_Sidebar_ButtonInUse(getglobal("CT4_ActionButton" .. i)) ) then
				getglobal("CT4_ActionButton" .. i):Show();
			end
		end
	else
		CT_Print("<CTMod> Button grid is now hidden.", 1, 1, 0);
		CT_ShowGrid = 0;
		for i=1, 12, 1 do
			CT_ActionButton_HideGrid(getglobal("CT_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT2_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT3_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT4_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT5_ActionButton" .. i));
		end
	end
end
function gridinitfunction(modId)
	local val = CT_Mods[modId]["modStatus"];
	local i;
	if ( val == "off" ) then
		CT_ShowGrid = 1;
	else
		CT_ShowGrid = 0;
		for i=1, 12, 1 do
			CT_ActionButton_HideGrid(getglobal("CT_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT2_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT3_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT4_ActionButton" .. i));
			CT_ActionButton_HideGrid(getglobal("CT5_ActionButton" .. i));
		end
	end
end

CT_oldPickupAction = PickupAction;
CT_PickupAction = function(x)
	if ( CT_HotbarButtons_Locked == 0 or IsShiftKeyDown() ) then
		CT_oldPickupAction(x);
	end
end
PickupAction = CT_PickupAction;

CT_RegisterMod(BARMOD_MODNAME_LEFTSB, BARMOD_ONOFFTOGGLE, 2, "Interface\\Icons\\Spell_Holy_MindVision", BARMOD_TOOLTIP_LEFTSB, "off", nil, sidebarfunction, CT_LSidebar_Update);
CT_RegisterMod(BARMOD_MODNAME_RIGHTSB, BARMOD_ONOFFTOGGLE, 2, "Interface\\Icons\\Spell_Holy_MindVision", BARMOD_TOOLTIP_RIGHTSB, "off", nil, sidebarRfunction, CT_RSidebar_Update);
CT_RegisterMod(BARMOD_MODNAME_LEFTHB, BARMOD_ONOFFTOGGLE, 2, "Interface\\Icons\\Spell_Holy_MindVision", BARMOD_TOOLTIPLEFTHB, "off", nil, hotbarleftfunction, CT_LHotbar_Update);
CT_RegisterMod(BARMOD_MODNAME_RIGHTHB, BARMOD_ONOFFTOGGLE, 2, "Interface\\Icons\\Spell_Holy_MindVision", BARMOD_TOOLTIP_RIGHTHB, "off", nil, hotbarrightfunction, CT_RHotbar_Update);
CT_RegisterMod(BARMOD_MODNAME_TOPHB, BARMOD_ONOFFTOGGLE, 2, "Interface\\Icons\\Spell_Holy_MindVision", BARMOD_TOOLTIP_TOPHB, "off", nil, hotbartopfunction, CT_THotbar_Update);

CT_RegisterMod(BARMOD_MODNAME_PAGELOCK, BARMOD_SUB_PAGELOCK, 2, "Interface\\Icons\\INV_Misc_Key_03", BARMOD_TOOLTIP_PAGELOCK, "off", nil, HotbarsLockFunction, HotbarsLockInitFunction);
CT_RegisterMod(BARMOD_MODNAME_BUTTONLOCK, BARMOD_SUB_BUTTONLOCK, 2, "Interface\\Icons\\INV_Misc_Key_13", BARMOD_TOOLTIP_BUTTONLOCK, "off", nil, HotbarButtonsLockFunction, CT_ButtonLock_Update);

CT_RegisterMod(BARMOD_MODNAME_LBB, BARMOD_NUMBUTTONS, 2, "Interface\\Icons\\Trade_Engineering", BARMOD_TOOLTIP_LBB, "switch", 9, lsidebarbuttonsfunction, LCT_SidebarBtns_Update);
CT_RegisterMod(BARMOD_MODNAME_RBB, BARMOD_NUMBUTTONS, 2, "Interface\\Icons\\Trade_Engineering", BARMOD_TOOLTIP_RBB, "switch", 9, rsidebarbuttonsfunction, RCT_SidebarBtns_Update);
CT_RegisterMod(BARMOD_MODNAME_HIDEGRID, BARMOD_SUB_HIDEGRID, 2, "Interface\\Icons\\Ability_Vanish", BARMOD_TOOLTIP_HIDEGRID, "off", nil, gridfunction, gridinitfunction);

CT_PetBar_DragFrame_Orientation = "H";
CT_BABar_DragFrame_Orientation = "H";
CT_Show_PetBarDrag = 0;

function CT_Bar_DragFrame_OnMD(force)
	local var, type;
	if ( this == CT_PetBar_Drag ) then
		var = CT_PetBar_DragFrame_Orientation;
		type = "PetAction";
	else
		var = CT_BABar_DragFrame_Orientation;
		type = "Shapeshift";
	end
	if ( arg1 == "LeftButton" ) then
			this:StartMoving();
	else
		if ( var == "H" or force ) then
			var = "V";
		else
			var = "H";
		end
		local i;
		for i = 2, 10, 1 do
			getglobal(type .. "Button" .. i):ClearAllPoints();
			if ( var == "H" ) then
				getglobal(type .. "Button" .. i):SetPoint("LEFT", type .. "Button" .. (i-1), "RIGHT", 8, 0);
			else
				getglobal(type .. "Button" .. i):SetPoint("TOP", type .. "Button" .. (i-1), "BOTTOM", 0, -8);
			end
		end
	end
	if ( this == CT_PetBar_Drag ) then
		CT_PetBar_DragFrame_Orientation = var;
	else
		CT_BABar_DragFrame_Orientation = var;
	end
end

function CT_BarMod_CheckRotations()
	for key, val in CT_SidebarAxis do
		if ( val == 1 ) then val = 2; else val = 1; end
		CT_Sidebar_ChangeAxis(tonumber(key), val);
	end
end

local oorfunc = function(modId, text)
	local val = CT_Mods[modId]["modValue"];
	if ( val == "1" ) then
		val = "2"
		CT_FadeColor = { ["r"] = 0.5, ["g"] = 0.5, ["b"] = 0.5 };
		CT_Print("<CTMod> The hotbar buttons now turn grey when out of range.", 1, 1, 0);
	elseif ( val == "2" ) then
		val = "3";
		CT_FadeColor = { ["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.4 };
		CT_Print("<CTMod> The hotbar buttons now turn red when out of range.", 1, 1, 0);
	elseif ( val == "3" ) then
		val = "1";
		CT_FadeColor = { ["r"] = 1, ["g"] = 1, ["b"] = 1 };
		CT_Print("<CTMod> The hotbar buttons no longer change color when out of range.", 1, 1, 0);
	end
	if ( text ) then text:SetText(val); end
	CT_Mods[modId]["modValue"] = val;
	CT_Mods[modId]["modStatus"] = "switch";
end

local oorinitfunc = function(modId)
	local val = CT_Mods[modId]["modValue"];
	if ( val == "2" ) then
		CT_FadeColor = { ["r"] = 0.5, ["g"] = 0.5, ["b"] = 0.5 };
	elseif ( val == "3" ) then
		CT_FadeColor = { ["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.4 };
	elseif ( val == "1" ) then
		CT_FadeColor = { ["r"] = 1, ["g"] = 1, ["b"] = 1 };
	end
end

local selffunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_SelfCast = 1;
		CT_Print("<CTMod> Self Cast is now turned on.", 1, 1, 0);
	else
		CT_Print("<CTMod> Self Cast is now turned off.", 1, 1, 0);
		CT_SelfCast = 0;
	end
end

local selfinitfunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		CT_SelfCast = 1;
	else
		CT_SelfCast = 0;
	end
end


local pettexfunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		ShapeshiftBarLeft:ClearAllPoints();
		SlidingActionBarTexture0:ClearAllPoints();
		ShapeshiftBarLeft:SetPoint("TOPRIGHT", "UIParent", "TOPLEFT", -500, 0);
		SlidingActionBarTexture0:SetPoint("TOPRIGHT", "UIParent", "TOPLEFT", -500, 0); -- Hide
		CT_Print("<CTMod> Pet bar textures are no longer shown.", 1, 1, 0);
	else
		SlidingActionBarTexture0:ClearAllPoints();
		SlidingActionBarTexture0:SetPoint("BOTTOMLEFT", "PetActionButton1", "BOTTOMLEFT", -36, -1);
		ShapeshiftBarLeft:ClearAllPoints();
		ShapeshiftBarLeft:SetPoint("BOTTOMLEFT", "ShapeshiftButton1", "BOTTOMLEFT", -14, -4);
		CT_Print("<CTMod> Pet bar textures are now shown.", 1, 1, 0);
	end
end

local pettexinitfunc = function(modId)
	local val = CT_Mods[modId]["modStatus"];
	if ( val == "on" ) then
		ShapeshiftBarLeft:ClearAllPoints();
		ShapeshiftBarLeft:SetPoint("TOPRIGHT", "UIParent", "TOPLEFT", -500, 0); -- Hide
		SlidingActionBarTexture0:SetPoint("LEFT", "PetActionBarFrame", "LEFT", 0, -5000);
	else
		SlidingActionBarTexture0:ClearAllPoints();
		SlidingActionBarTexture0:SetPoint("BOTTOMLEFT", "PetActionButton1", "BOTTOMLEFT", -36, -1);
		ShapeshiftBarLeft:ClearAllPoints();
		ShapeshiftBarLeft:SetPoint("BOTTOMLEFT", "ShapeshiftButton1", "BOTTOMLEFT", -14, -4);
	end
end

local hotkeyfunc = function(modId, text)
	local val = CT_Mods[modId]["modValue"];
	if ( val == "3" ) then
		val = "1";
		CT_ShowHotkeys = nil;
		CT_Print("<CTMod> Hotkeys now show numbers.", 1, 1, 0);
	elseif ( val == "1" ) then
		val = "2";
		CT_ShowHotkeys = 1;
		CT_Print("<CTMod> Hotkeys now show actual bindings.", 1, 1, 0);
	elseif ( val == "2" ) then
		val = "3";
		CT_ShowHotkeys = -1;
		CT_Print("<CTMod> Hotkeys no longer show bindings.", 1, 1, 0);
	end
	CT_BarMod_UpdateAllHotkeys();
	if ( text ) then
		text:SetText(val);
	end
	CT_Mods[modId]["modValue"] = val;
end

local hotkeyinitfunc = function(modId)
	local val = CT_Mods[modId]["modValue"];
	if ( val == "1" ) then
		CT_ShowHotkeys = nil;
	elseif ( val == "2" ) then
		CT_ShowHotkeys = 1;
	elseif ( val == "3" ) then
		CT_ShowHotkeys = -1;
	end
	CT_BarMod_UpdateAllHotkeys();
	CT_Mods[modId]["modStatus"] = "switch";
end

function cskeyfunc(modId, text)
	local val = CT_Mods[modId]["modValue"];
	if ( val == "Ctrl" ) then
		val = "Alt";
		CT_SelfCastModKey = IsAltKeyDown;
		CT_Print("<CTMod> Self Cast Key is now set to Alt.", 1, 1, 0);
	elseif ( val == "Alt" ) then
		val = "Shift";
		CT_SelfCastModKey = IsShiftKeyDown;
		CT_Print("<CTMod> Self Cast Key is now set to Shift.", 1, 1, 0);
	elseif ( val == "Shift" ) then
		val = "None";
		CT_SelfCastModKey = nil;
		CT_Print("<CTMod> Self Cast Key is now set to none.", 1, 1, 0);
	elseif ( val == "None" ) then
		val = "Ctrl";
		CT_SelfCastModKey = IsControlKeyDown;
		CT_Print("<CTMod> Self Cast Key is now set to Control.", 1, 1, 0);
	end
	CT_Mods[modId]["modValue"] = val;
	if ( text ) then text:SetText(val); end
end

function cskeyinitfunc(modId, text)
	local val = CT_Mods[modId]["modValue"];
	if ( val == "Alt" ) then
		CT_SelfCastModKey = IsAltKeyDown;
	elseif ( val == "Shift" ) then
		CT_SelfCastModKey = IsShiftKeyDown;
	elseif ( val == "Ctrl" ) then
		CT_SelfCastModKey = IsControlKeyDown;
	end
end

CT_RegisterMod(BARMOD_MODNAME_OOR, BARMOD_SUB_OOR, 2, "Interface\\Icons\\Ability_TownWatch", BARMOD_TOOLTIP_OOR, "switch", "1", oorfunc, oorinitfunc);
CT_RegisterMod(BARMOD_MODNAME_HOTKEYS, BARMOD_SUB_HOTKEYS, 2, "Interface\\Icons\\INV_Misc_Key_09", BARMOD_TOOLTIP_HOTKEYS, "switch", "1", hotkeyfunc, hotkeyinitfunc);
CT_RegisterMod(BARMOD_MODNAME_PETTEX, BARMOD_SUB_PETTEX, 5, "Interface\\Icons\\Ability_Mount_WhiteTiger", BARMOD_TOOLTIP_PETTEX, "off", nil, pettexfunc, pettexinitfunc);
--CT_SelfCastModKey
--CT_RegisterMod(BARMOD_MODNAME_TTPOS, BARMOD_SUB_TTPOS, 5, "Interface\\Icons\\Ability_Mount_WhiteTiger", BARMOD_TOOLTIP_TTPOS, "off", nil, ttfunc, ttinitfunc);
CT_RegisterMod(BARMOD_MODNAME_SCKEY, BARMOD_SUB_SCKEY, 4, "Interface\\Icons\\Spell_Holy_GreaterHeal", BARMOD_TOOLTIP_SCKEY, "switch", "None", cskeyfunc, cskeyinitfunc);
CT_RegisterMod(BARMOD_MODNAME_SELFCAST, BARMOD_SUB_SELFCAST, 4, "Interface\\Icons\\Spell_Holy_GreaterHeal", BARMOD_TOOLTIP_SELFCAST, "off", nil, selffunc, selfinitfunc);

function CT_ActionButton_OnClick()
	if ( ( strsub( this:GetName(), 1, 3 ) ~= "CT3" and strsub( this:GetName(), 1, 3 ) ~= "CT4" ) or CT_Sidebar_ButtonInUse(this) ) then

		if ( IsShiftKeyDown() ) then
			PickupAction(CT_ActionButton_GetPagedID(this));
		else
			MacroFrame_EditMacro();
			if ( CT_NextSelfCast ) then
				UseAction(CT_ActionButton_GetPagedID(this), 0, 1);
			else
				UseAction(CT_ActionButton_GetPagedID(this), 1, nil);
				if ( SpellIsTargeting() and CT_SelfCast == 1 and not SpellCanTargetUnit("target") and SpellCanTargetUnit("player") ) then
					SpellTargetUnit("player");
				end
			end
		end
		CT_ActionButton_UpdateState();
	end
end

CT_oldUseAction = UseAction;

function CT_newUseAction(id, cursor, onSelf)
	if ( CT_SelfCastModifier and CT_SelfCast == 1 ) then
		onSelf = 1;
	end
	CT_oldUseAction(id, cursor, onSelf);
	if ( SpellIsTargeting() and CT_SelfCast == 1 and not SpellCanTargetUnit("target") and SpellCanTargetUnit("player") ) then
		SpellTargetUnit("player");
	end
end

UseAction = CT_newUseAction;

function CT_BarMod_UpdateAllHotkeys()
	local key = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" };
	local i;
	for i = 1, 12, 1 do
		CT_ActionButton_UpdateHotkeys(getglobal("CT_ActionButton" .. i));
		CT_ActionButton_UpdateHotkeys(getglobal("CT2_ActionButton" .. i));
		CT_ActionButton_UpdateHotkeys(getglobal("CT3_ActionButton" .. i));
		CT_ActionButton_UpdateHotkeys(getglobal("CT4_ActionButton" .. i));
		CT_ActionButton_UpdateHotkeys(getglobal("CT5_ActionButton" .. i));

		if ( CT_ShowHotkeys and CT_ShowHotkeys == -1 ) then
			getglobal("ActionButton" .. i .. "HotKey"):Hide();
		else
			getglobal("ActionButton" .. i .. "HotKey"):Show();
			if ( not CT_ShowHotkeys ) then
				getglobal("ActionButton" .. i .. "HotKey"):SetText(key[i]);
			else
				getglobal("ActionButton" .. i .. "HotKey"):SetText(KeyBindingFrame_GetLocalizedName(GetBindingKey("ACTIONBUTTON" .. i), "KEY_"));
			end
		end
	end
end

CT_oldActionButton_UpdateHotkeys = ActionButton_UpdateHotkeys;

function CT_newActionButton_UpdateHotkeys()
	local key = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" };
	if ( not CT_ShowHotkeys ) then
		getglobal(this:GetName() .. "HotKey"):SetText(key[this:GetID()]);
	else
		CT_oldActionButton_UpdateHotkeys();
	end
end

ActionButton_UpdateHotkeys = CT_newActionButton_UpdateHotkeys;

CT_oldPickupPetAction = PickupPetAction;
function CT_newPickupPetAction(arg)
	if ( CT_HotbarButtons_Locked == 0 or IsShiftKeyDown() ) then
		CT_oldPickupPetAction(arg);
	end
end
PickupPetAction = CT_newPickupPetAction;

function CT_HotbarToggle(num)
	local arr = {
		"CT_HotbarLeft",
		"CT_HotbarRight",
		"CT_SidebarFrame",
		"CT_SidebarFrame2",
		"CT_HotbarTop"
	};

	if ( getglobal(arr[num]):IsVisible() ) then
		getglobal(arr[num]):Hide();
	else
		getglobal(arr[num]):Show();
	end
	CT_CheckLSidebar();
end

CT_oldSPAB = ShowPetActionBar;
function CT_newSPAB()
	CT_oldSPAB();
	if ( PetActionBarFrame:IsVisible() and CT_MF_ShowFrames ) then
		CT_PetBar_Drag:Show();
	else
		CT_PetBar_Drag:Hide();
	end
end
ShowPetActionBar = CT_newSPAB;

function CT_LeftHotbar_OnHide()
	local x = CT_BABar_Drag:GetLeft()-MainMenuBar:GetLeft();
	local y = CT_BABar_Drag:GetBottom()-40;
	CT_BABar_Drag:ClearAllPoints();
	CT_BABar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", x, y);

	x = CT_PetBar_Drag:GetLeft()-MainMenuBar:GetLeft();
	y = CT_PetBar_Drag:GetBottom()-40;
	CT_PetBar_Drag:ClearAllPoints();
	CT_PetBar_Drag:SetPoint("BOTTOMLEFT", "MainMenuBar", "BOTTOMLEFT", x, y);
end

CT_BarMod_SidebarMoved = 0;
function CT_CheckLSidebar()
	local shown = 0;
	local parent = "UIParent";
	if ( CT_MovableParty_IsInstalled ) then
		parent = "CT_MovableParty1_Drag";
	end
	if ( PARTY_FRAME_SHOWN == 1 and GetNumPartyMembers() > 0 and CT_SidebarFrame:IsVisible() ) then
		shown = 1;
	end
	if ( CT_BarMod_SidebarMoved ~= shown ) then
		CT_BarMod_SidebarMoved = shown;
		if ( shown == 1 ) then
			if ( CT_MovableParty_IsInstalled ) then
				for i = 1, 4, 1 do
					if ( getglobal("CT_MovableParty" .. i .. "_Drag"):GetLeft() ) then
						getglobal("CT_MovableParty" .. i .. "_Drag"):SetPoint("TOPLEFT", "UIParent", "TOPLEFT", getglobal("CT_MovableParty" .. i .. "_Drag"):GetLeft()+40, getglobal("CT_MovableParty" .. i .. "_Drag"):GetTop()-UIParent:GetTop());
					end
				end
			elseif ( PartyMemberFrame1:GetRight() ) then
				PartyMemberFrame1:SetPoint("TOPLEFT", parent, "TOPLEFT", PartyMemberFrame1:GetLeft()+40, PartyMemberFrame1:GetTop()-UIParent:GetTop());
			end
		else
			if ( CT_MovableParty_IsInstalled ) then
				for i = 1, 4, 1 do
					if ( getglobal("CT_MovableParty" .. i .. "_Drag"):GetLeft() ) then
						getglobal("CT_MovableParty" .. i .. "_Drag"):SetPoint("TOPLEFT", "UIParent", "TOPLEFT", getglobal("CT_MovableParty" .. i .. "_Drag"):GetLeft()-40, getglobal("CT_MovableParty" .. i .. "_Drag"):GetTop()-UIParent:GetTop());
					end
				end
			elseif ( PartyMemberFrame1:GetLeft() ) then
				PartyMemberFrame1:SetPoint("TOPLEFT", parent, "TOPLEFT", PartyMemberFrame1:GetLeft()-40, PartyMemberFrame1:GetTop()-UIParent:GetTop());
			end
		end
	end
end