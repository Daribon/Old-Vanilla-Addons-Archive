--[[
	BOHooks
	 	Contains the hooked functions for BarOptions
	
	By: Mugendai
	
	$Id: BOHooks.lua 1441 2005-05-05 08:41:19Z Sinaloit $
	$Rev: 1441 $
	$LastChangedBy: Sinaloit $
	$Date: 2005-05-05 10:41:19 +0200 (Thu, 05 May 2005) $
]]--

--------------------------------------------------
--
-- Constants
--
--------------------------------------------------
ALT_BOTTOMLEFT_ACTIONBAR_PAGE = 2;
ALT_BOTTOMRIGHT_ACTIONBAR_PAGE = 6;
ALT_SIDEBAR_PAGE = 3;
DRUID_STANCE_PAGES = {BOTTOMLEFT_ACTIONBAR_PAGE, 8, 8, 10};
DRUID_ALT_STANCE_PAGES = {ALT_BOTTOMLEFT_ACTIONBAR_PAGE, 8, 8, 10};
WARRIOR_STANCE_PAGES = {BOTTOMLEFT_ACTIONBAR_PAGE, BOTTOMLEFT_ACTIONBAR_PAGE, 1, 10};
WARRIOR_ALT_STANCE_PAGES = {ALT_BOTTOMLEFT_ACTIONBAR_PAGE, ALT_BOTTOMLEFT_ACTIONBAR_PAGE, 1, 10};
ROGUE_STANCE_PAGES = {BOTTOMLEFT_ACTIONBAR_PAGE, 8, 8, 8};
ROGUE_ALT_STANCE_PAGES = {ALT_BOTTOMLEFT_ACTIONBAR_PAGE, 8, 8, 8};

--------------------------------------------------
--
-- Global Variables
--
--------------------------------------------------
--used to keep up with the last page the bar was on
Instant_ActionBar_Return = -1;

--------------------------------------------------
--
-- Hook Function
--
--------------------------------------------------
BarOptions.Hook = function ()
	--ID range mod hook functions
	--Several of these functions are commented out, and manually overriden.
	--The reason for this, is that these functions are called exceedingly often,
	--and when used with the hook handler function, it results in tons of extra
	--garbage collection, possibly as much as 100,000 more gc's per second.
	--Sea.util.hook("ActionButton_GetPagedID", "BO_ActionButton_GetPagedID", "replace");
	ActionButton_GetPagedID = BO_ActionButton_GetPagedID;
	Sea.util.hook("ActionBar_PageUp", "BO_ActionBar_PageUp", "replace");
	Sea.util.hook("ActionBar_PageDown", "BO_ActionBar_PageDown", "replace");
	Sea.util.hook("ChangeActionBarPage", "BO_ChangeActionBarPage", "before");
	
	--Empty button and button count hook functions
	--Sea.util.hook("ActionButton_Update", "BO_ActionButton_Update", "replace");
	ActionButton_Update = BO_ActionButton_Update;
	Sea.util.hook("ActionButton_ShowGrid", "BO_ActionButton_ShowGrid", "replace");
	Sea.util.hook("ActionButton_HideGrid", "BO_ActionButton_HideGrid", "replace");
	
	--Hotkey mods hook functions
	Sea.util.hook("ActionButton_UpdateHotkeys", "BO_ActionButton_UpdateHotkeys", "replace");
	Sea.util.hook("KeyBindingFrame_GetLocalizedName", "BO_KeyBindingFrame_GetLocalizedName", "replace");
	
	--Bonus Action Bar and Instant Action Bar hook functions
	Sea.util.hook("BonusActionBar_OnLoad", "BO_BonusActionBar_OnLoad", "replace");
	--Sea.util.hook("BonusActionBar_OnEvent", "BO_BonusActionBar_OnEvent", "replace");
	BonusActionBar_OnEvent = BO_BonusActionBar_OnEvent;
	--Sea.util.hook("BonusActionBar_OnUpdate", "BO_BonusActionBar_OnUpdate", "replace");
	BonusActionBar_OnUpdate = BO_BonusActionBar_OnUpdate;
	Sea.util.hook("ShowBonusActionBar", "BO_ShowBonusActionBar", "replace");
	Sea.util.hook("HideBonusActionBar", "BO_HideBonusActionBar", "replace");
	--Sea.util.hook("BonusActionButton_OnEvent", "BO_BonusActionButton_OnEvent", "replace");
	BonusActionButton_OnEvent = BO_BonusActionButton_OnEvent;
	Sea.util.hook("BonusActionBar_SetButtonTransitionState", "BO_BonusActionBar_SetButtonTransitionState", "replace");
	Sea.util.hook("ActionButtonDown", "BO_ActionButtonDown", "replace");
	Sea.util.hook("ActionButtonUp", "BO_ActionButtonUp", "replace");
	
	--Range Coloring hook functions
	--Sea.util.hook("ActionButton_UpdateUsable", "BO_ActionButton_UpdateUsable", "replace");
	ActionButton_UpdateUsable = BO_ActionButton_UpdateUsable;
	
	
	--We have an issue here.  For some reason when used with this function, a jitter is caused in the UI every
	--so many seconds.  This seems to be related to using unpack(args), as if I hook this up to simply call the
	--function straight using an unpack args, I still get the issue.  Only when I do this direct overload, does
	--this super odd jitter go away.
	--Sea.util.hook("ActionButton_OnUpdate", "BO_ActionButton_OnUpdate", "replace");
	oldActionButton_OnUpdate = ActionButton_OnUpdate;
	ActionButton_OnUpdate = BO_ActionButton_OnUpdate;
	
	--TOOLTIP_UPDATE_TIME = 20;
end;

--------------------------------------------------
--
-- Hooks, BonusActionBar
--
--------------------------------------------------
function BO_BonusActionBar_OnLoad()
	BOBonusActionBar_OnLoad();
end
function BO_BonusActionBar_OnEvent()
	BOBonusActionBar_OnEvent();
end
function BO_BonusActionBar_OnUpdate(elapsed)
end

function BO_ShowBonusActionBar()
	BOShowBonusActionBar();
end

function BO_HideBonusActionBar()
	BOHideBonusActionBar();
end

function BO_BonusActionButton_OnEvent()
end
function BO_BonusActionBar_SetButtonTransitionState(state)
end

--------------------------------------------------
--
-- Hooks, ActionButton
--
--------------------------------------------------
function BO_ActionButton_UpdateHotkeys(actionButtonType, button)
	if (not button) then
		button = this;
	end
	local hotkey = getglobal(button:GetName().."HotKey");
	if ( not actionButtonType ) then
		--Set the actionButtonType based on which bar this button is associated with
		if (string.find(button:GetName(), "MultiBarBottomLeft")) then
			actionButtonType = "MULTIACTIONBAR1BUTTON";
		elseif (string.find(button:GetName(), "MultiBarBottomRight")) then
			actionButtonType = "MULTIACTIONBAR2BUTTON";
		elseif (string.find(button:GetName(), "MultiBarRight")) then
			actionButtonType = "MULTIACTIONBAR3BUTTON";
		elseif (string.find(button:GetName(), "MultiBarLeft")) then
			actionButtonType = "MULTIACTIONBAR4BUTTON";
		else
			actionButtonType = "ACTIONBUTTON";
		end
	end
	local action = actionButtonType..button:GetID();
	
	if (hotkey) then
		--If hiding key bindings is enabled then dont show the binding
		if (BarOptions_Config.HideKeys==1) then
			hotkey:SetText("");
		else
			if (action) then
				local keyText = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
				if (BarOptions_Config.HideKeyMod==1) then
					--If we are supposed ot hide the key modifier, then do so
					while ( ( keyText ) and ( strlen(keyText) > 1 ) and (string.find(keyText, "-")) and (keyText ~= "KP -") and (keyText ~= "Num Pad -")) do
						firsti, lasti, keyText = string.find (keyText, "-(.+)");
					end
				end
				if ( ( not keyText ) or ( strlen(keyText) <= 0 ) ) then keyText = ""; end
				hotkey:SetText(keyText);
			else
				hotkey:SetText("");
			end
		end
	end
end

function BO_ActionButtonDown(id)
	if ( BOBonusActionBarFrame:IsVisible() ) then
		local button = getglobal("BOBonusActionButton"..id);
		if ( button:GetButtonState() == "NORMAL" ) then
			button:SetButtonState("PUSHED");
		end
		return;
	end
	
	local button = getglobal("ActionButton"..id);
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function BO_ActionButtonUp(id, onSelf)
	if ( BOBonusActionBarFrame:IsVisible() ) then
		local button = getglobal("BOBonusActionButton"..id);
		if ( button:GetButtonState() == "PUSHED" ) then
			button:SetButtonState("NORMAL");
			-- Used to save a macro
			MacroFrame_EditMacro();
			UseAction(ActionButton_GetPagedID(button), 0);
			if ( IsCurrentAction(ActionButton_GetPagedID(button)) ) then
				button:SetChecked(1);
			else
				button:SetChecked(0);
			end
-- Instant Action Bar START
			if ( Instant_ActionBar_Return ~= -1 ) then
				CURRENT_ACTIONBAR_PAGE = Instant_ActionBar_Return;
				Instant_ActionBar_Return = -1;
				ChangeActionBarPage();
			end
-- Instant Action Bar end
		end
		return;
	end

	local button = getglobal("ActionButton"..id);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction(ActionButton_GetPagedID(button), 0, onSelf);
		if ( IsCurrentAction(ActionButton_GetPagedID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
-- Instant Action Bar START
		if ( Instant_ActionBar_Return ~= -1 ) then
			CURRENT_ACTIONBAR_PAGE = Instant_ActionBar_Return;
			Instant_ActionBar_Return = -1;
			ChangeActionBarPage();
		end
-- Instant Action Bar END
	end
end

function BO_ActionButton_UpdateUsable()
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));
	if ( isUsable ) then
		if (BarOptions_Config.RangeColor == 1) then
			local inRange = true;
			if ( this.rangeTimer and (IsActionInRange(ActionButton_GetPagedID(this)) == 0)) then
				inRange = false;
			end
			if ( inRange ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			else
				icon:SetVertexColor(BarOptions_Config.RangeColorRed, BarOptions_Config.RangeColorGreen, BarOptions_Config.RangeColorBlue);
				normalTexture:SetVertexColor(BarOptions_Config.RangeColorRed, BarOptions_Config.RangeColorGreen, BarOptions_Config.RangeColorBlue);
			end
		else
			icon:SetVertexColor(1.0, 1.0, 1.0);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		end
	elseif ( notEnoughMana ) then
		icon:SetVertexColor(0.5, 0.5, 1.0);
		normalTexture:SetVertexColor(0.5, 0.5, 1.0);
	else
		icon:SetVertexColor(0.4, 0.4, 0.4);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function BO_ActionButton_OnUpdate(elapsed)
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
	
	-- Handle range indicator
	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			if (BarOptions_Config.RangeColor == 1) then
				ActionButton_UpdateUsable();
			end
			local count = getglobal(this:GetName().."HotKey");
			if ( IsActionInRange( ActionButton_GetPagedID(this)) == 0 ) then
				count:SetVertexColor(1.0, 0.1, 0.1);
			else
				count:SetVertexColor(0.6, 0.6, 0.6);
			end
			this.rangeTimer = TOOLTIP_UPDATE_TIME;
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
		ActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end
end

function BO_ActionButton_GetPagedID(button)
	if( button == nil ) then
		message("nil button passed into ActionButton_GetPagedID(), contact Jeff");
		return 0;
	end

	local temp, pClass = UnitClass("player");
	if (not pClass) then
		pClass = "nothing";
	end
	local curStancePage = nil;
	local stanceOffset = GetBonusBarOffset();
	if ((BarOptions_Config.StanceBar == 1) and (stanceOffset >= 0) and (stanceOffset <= 3)) then
		if (pClass == "DRUID") then
			if (BarOptions_Config.AlternateIDs == 0) then
				curStancePage = DRUID_STANCE_PAGES[stanceOffset + 1];
			else
				curStancePage = DRUID_ALT_STANCE_PAGES[stanceOffset + 1];
			end
			if (BarOptions_Config.CustomStances == 1) then
				curStancePage = MCom.stringToVar("BarOptions_Config.Stance"..stanceOffset);
			end
		elseif (pClass == "WARRIOR") then
			if (BarOptions_Config.AlternateIDs == 0) then
				curStancePage = WARRIOR_STANCE_PAGES[stanceOffset + 1];
			else
				curStancePage = WARRIOR_ALT_STANCE_PAGES[stanceOffset + 1];
			end
			if (BarOptions_Config.CustomStances == 1) then
				curStancePage = MCom.stringToVar("BarOptions_Config.Stance"..stanceOffset);
			end
		elseif (pClass == "ROGUE") then
			if (BarOptions_Config.AlternateIDs == 0) then
				curStancePage = ROGUE_STANCE_PAGES[stanceOffset + 1];
			else
				curStancePage = ROGUE_ALT_STANCE_PAGES[stanceOffset + 1];
			end
			if (BarOptions_Config.CustomStances == 1) then
				curStancePage = MCom.stringToVar("BarOptions_Config.Stance"..stanceOffset);
			end
		end
	end
	
	local buttonID = 0;
	if ( button.isBonus and CURRENT_ACTIONBAR_PAGE == 1 ) then
		local offset = GetBonusBarOffset();
		if ( offset == 0 and BonusActionBarFrame and BonusActionBarFrame.lastBonusBar ) then
			offset = BonusActionBarFrame.lastBonusBar;
		end
		buttonID = (button:GetID() + ((NUM_ACTIONBAR_PAGES + offset - 1) * NUM_ACTIONBAR_BUTTONS));
	elseif ( button:GetParent():GetName() == "MultiBarBottomLeft" ) then
		if ((BarOptions_Config.AlternateIDs == 0) or curStancePage) then
			--Using normal IDs
			local usePage = BOTTOMLEFT_ACTIONBAR_PAGE;
			if (curStancePage) then
				usePage = curStancePage;
			end
			buttonID = (button:GetID() + ((usePage - 1) * NUM_ACTIONBAR_BUTTONS));
		else
			--Using alternate ID, but not stances
			if (BarOptions_Config.TurnPages == 0) then
				--Don't turn pages
				buttonID = (button:GetID() + ((ALT_BOTTOMLEFT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
			elseif (BarOptions_Config.GroupPages == 0) then
				--Not using grouped paging, but turning pages
				if (CURRENT_ACTIONBAR_PAGE < NUM_ACTIONBAR_PAGES) then
					buttonID = (button:GetID() + ((CURRENT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS)) + NUM_ACTIONBAR_BUTTONS;
				else
					buttonID = button:GetID();
				end
			else
				--Using grouped paging
				buttonID = (button:GetID() + ((CURRENT_ACTIONBAR_PAGE - 1) * (NUM_ACTIONBAR_BUTTONS * 2))) + NUM_ACTIONBAR_BUTTONS;
			end
		end
	elseif ( button:GetParent():GetName() == "MultiBarBottomRight" ) then
		if (BarOptions_Config.AlternateIDs == 0) then
			--Using normal IDs
			buttonID = (button:GetID() + ((BOTTOMRIGHT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
		else
			--Using alternate IDs
			buttonID = (button:GetID() + ((ALT_BOTTOMRIGHT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
		end
	elseif ( button:GetParent():GetName() == "MultiBarLeft" ) then
		if (BarOptions_Config.AlternateIDs == 0) then
			--Using normal IDs
			buttonID = (button:GetID() + ((LEFT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
		elseif (button:GetID() <= 6) then
			--Using alternate IDs
			--Use the first 6 of the last 12 ID ranges for the first 6 buttons
			buttonID = (button:GetID() + 114);
		else
			--Use the last 6 of the range specified for alternate sidebars for the last 6 buttons
			buttonID = (button:GetID() + ((ALT_SIDEBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
		end
	elseif ( button:GetParent():GetName() == "MultiBarRight" ) then
		if (BarOptions_Config.AlternateIDs == 0) then
			buttonID = (button:GetID() + ((RIGHT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
		elseif (button:GetID() <= 6) then
			--Using alternate IDs
			--Use the first 6 of the last 12 ID ranges for the first 6 buttons
			buttonID = (button:GetID() + 108);
		else
			--Use the first 6 of the range specified for alternate sidebars for the last 6 buttons
			buttonID = (button:GetID() + ((ALT_SIDEBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS)) - (NUM_ACTIONBAR_BUTTONS / 2);
		end
	else
		if ((BarOptions_Config.AlternateIDs == 0) or (BarOptions_Config.TurnPages == 0) or (BarOptions_Config.GroupPages == 0)) then
			--Using normal IDs
			buttonID = (button:GetID() + ((CURRENT_ACTIONBAR_PAGE - 1) * NUM_ACTIONBAR_BUTTONS));
		else
			--Using grouped IDs
			buttonID = (button:GetID() + ((CURRENT_ACTIONBAR_PAGE - 1) * (NUM_ACTIONBAR_BUTTONS * 2)));
		end
	end
	
	return buttonID;
end

function BO_ActionButton_Update()
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local pagedID = ActionButton_GetPagedID(this);
	if ( IsAttackAction(pagedID) and IsCurrentAction(pagedID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(pagedID);
	
	-- Special case code for bonus bar buttons
	-- Prevents the button from updating if the bonusbar is still in an animation transition

	-- Derek, I had to comment this out because it was causing them all to be grayed out after a cinematic...
	if ( this.isBonus and this.inTransition ) then
		ActionButton_UpdateUsable();
		ActionButton_UpdateCooldown();
		return;
	end
	
	local icon = getglobal(this:GetName().."Icon");
	local buttonCooldown = getglobal(this:GetName().."Cooldown");
	local texture = GetActionTexture(ActionButton_GetPagedID(this));
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		this.rangeTimer = TOOLTIP_UPDATE_TIME;
		this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
		-- Save texture if the button is a bonus button, will be needed later
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
	ActionButton_UpdateCount();
	if ( HasAction(ActionButton_GetPagedID(this)) ) then
		BarOptions.ShowButton(this);
		ActionButton_UpdateUsable();
		ActionButton_UpdateCooldown();
	elseif ( this.showgrid == 0 ) then
		if (BarOptions_Config.HideEmpty == 1) then
			this:Hide();
		else
			BarOptions.ShowButton(this);
		end
	else
		getglobal(this:GetName().."Cooldown"):Hide();
	end
	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		ActionButton_StartFlash();
	else
		ActionButton_StopFlash();
	end
	if ( GameTooltip:IsOwned(this) ) then
		ActionButton_SetTooltip();
	else
		this.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(this:GetName().."Name");
	macroName:SetText(GetActionText(ActionButton_GetPagedID(this)));
end

function BO_ActionButton_ShowGrid(button)
	if ( not button ) then
		button = this;
	end
	button.showgrid = button.showgrid+1;
	getglobal(button:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0, 0.5);
	
	BarOptions.ShowButton(button);
end

function BO_ActionButton_HideGrid(button)	
	if ( not button ) then
		button = this;
	end
	--if (not button.showgrid) then
		--button.showgrid = 0;
	--end
	
	button.showgrid = button.showgrid-1;
	--if ( ((button.showgrid == 0) or (button:IsVisible() and button.showgrid < 0)) and (not HasAction(ActionButton_GetPagedID(button))) ) then
	if ( button.showgrid == 0 and not HasAction(ActionButton_GetPagedID(button)) ) then
		if (BarOptions_Config.HideEmpty == 1) then
			button:Hide();
		else
			BarOptions.ShowButton(button);
		end
	end
end

function BO_ActionBar_PageUp()
	CURRENT_ACTIONBAR_PAGE = CURRENT_ACTIONBAR_PAGE + 1;
	local nextPage;
	
	if ((BarOptions_Config.AlternateIDs == 0) or ((BarOptions_Config.AlternateIDs == 0) and (BarOptions_Config.GroupPages == 0))) then
		--If no effecting options are enabled, behave normal
		for i=CURRENT_ACTIONBAR_PAGE, NUM_ACTIONBAR_PAGES do
			if ( VIEWABLE_ACTION_BAR_PAGES[i] ) then
				nextPage = i;
				break;
			end
		end
	elseif ((BarOptions_Config.AlternateIDs == 1) and (BarOptions_Config.GroupPages == 1)) then
		--If grouping is enabled, then simply don't exceed 3 pages
		if (CURRENT_ACTIONBAR_PAGE <= (NUM_ACTIONBAR_PAGES / 2)) then
			nextPage = CURRENT_ACTIONBAR_PAGE;
		end
	else
		--If alternate is enabled, then simply don't exceed 6 pages
		if (CURRENT_ACTIONBAR_PAGE <= NUM_ACTIONBAR_PAGES) then
			nextPage = CURRENT_ACTIONBAR_PAGE;
		end
	end
	
	if ( not nextPage ) then
		CURRENT_ACTIONBAR_PAGE = 1;
	else
		CURRENT_ACTIONBAR_PAGE = nextPage;
	end
	ChangeActionBarPage();
end

function BO_ActionBar_PageDown()
	CURRENT_ACTIONBAR_PAGE = CURRENT_ACTIONBAR_PAGE - 1;
	local prevPage;
	
	if ((BarOptions_Config.AlternateIDs == 0) or ((BarOptions_Config.AlternateIDs == 0) and (BarOptions_Config.GroupPages == 0))) then
		--If no effecting options are enabled, behave normal
		if (CURRENT_ACTIONBAR_PAGE < 1) then
			CURRENT_ACTIONBAR_PAGE = NUM_ACTIONBAR_PAGES;
		end
		
		for i=CURRENT_ACTIONBAR_PAGE, 1, -1 do
			if ( VIEWABLE_ACTION_BAR_PAGES[i] ) then
				prevPage = i;
				break;
			end
		end
	else
		--Simply don't go below page 1
		if (CURRENT_ACTIONBAR_PAGE > 0) then
			prevPage = CURRENT_ACTIONBAR_PAGE;
		end
	end
	
	if ( not prevPage ) then
		if ((BarOptions_Config.AlternateIDs == 0) or (BarOptions_Config.GroupPages == 0)) then
			--If we aren't grouping behave normal
			CURRENT_ACTIONBAR_PAGE = NUM_ACTIONBAR_PAGES;
		elseif (BarOptions_Config.AlternateIDs == 1) then
			--If we are grouping flip to page 3, if we go below 1
			CURRENT_ACTIONBAR_PAGE = (NUM_ACTIONBAR_PAGES / 2);
		end
	else
		CURRENT_ACTIONBAR_PAGE = prevPage;
	end
	ChangeActionBarPage();
end

function BO_ChangeActionBarPage()
	if (this) then
		if (this:GetName() == "ActionBarDownButton") then
			if ((BarOptions_Config.AlternateIDs == 1) and (BarOptions_Config.GroupPages == 1)) then
				if (CURRENT_ACTIONBAR_PAGE > (NUM_ACTIONBAR_PAGES / 2)) then
					CURRENT_ACTIONBAR_PAGE = 1;
				end
			end
		end
		if (this:GetName() == "ActionBarUpButton") then
			if ((BarOptions_Config.AlternateIDs == 1) and (BarOptions_Config.GroupPages == 1)) then
				if (CURRENT_ACTIONBAR_PAGE > (NUM_ACTIONBAR_PAGES / 2)) then
					CURRENT_ACTIONBAR_PAGE = (NUM_ACTIONBAR_PAGES / 2);
				end
			end
		end
	end
end

--------------------------------------------------
--
-- Hooks, KeyBindingsFrame
--
--------------------------------------------------
--If Cosmos has hooked the origional function, then unhook it
if (old_KeyBindingFrame_GetLocalizedName) then
	KeyBindingFrame_GetLocalizedName = old_KeyBindingFrame_GetLocalizedName;
end
function BO_KeyBindingFrame_GetLocalizedName(name, prefix)
	-- call the origional function
	local text = Sea.util.Hooks["KeyBindingFrame_GetLocalizedName"].orig(name, prefix);
	
	--Shorten the names
	if ( text and (BarOptions_Config.ShortKeys == 1) ) then
		for str, repl in BO_SHORTHOTKEYS do
			text = string.gsub(text, str, repl);
		end
	end
	
	if (not text) then
		text = "";
	end

	return nil, { text };
end