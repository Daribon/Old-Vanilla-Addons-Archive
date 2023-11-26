--windows
UIPanelWindows["HxOptions"] = { area = "left", pushable = 10 };
UIPanelWindows["HxSpellOptions"] = { area = "left", pushable = 9 };

--Pop Ups
StaticPopupDialogs["ADD_SPELL"] = {
	text = Hx_ADD_SPELL_POPUP, button1 = TEXT(ACCEPT), button2 = TEXT(CANCEL), hasEditBox = 1, maxLetters = 30,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_AddSpell(editBox:GetText());
	end,
	OnShow = function() getglobal(this:GetName().."EditBox"):SetFocus(); end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then ChatFrameEditBox:SetFocus(); end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_AddSpell(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
	timeout = 0, exclusive = 1, whileDead = 1
};

StaticPopupDialogs["GET_CHANNEL"] = {
	text = Hx_GET_CHANNEL_POPUP, button1 = TEXT(ACCEPT), button2 = TEXT(CANCEL), hasEditBox = 1, maxLetters = 30,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Channel(editBox:GetText());
	end,
	OnShow = function() local eb = getglobal(this:GetName().."EditBox"); eb:SetFocus(); eb:SetText(HxSave[Class].Channel); end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then ChatFrameEditBox:SetFocus(); end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Channel(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
	timeout = 0,exclusive = 1,whileDead = 1
};
StaticPopupDialogs["GET_PREFIX"] = {
	text = Hx_GET_PREFIX_POPUP, button1 = TEXT(ACCEPT), button2 = TEXT(CANCEL), hasEditBox = 1, maxLetters = 30,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Prefix(editBox:GetText());
	end,
	OnShow = function() local eb = getglobal(this:GetName().."EditBox"); eb:SetFocus(); eb:SetText(HxSave[Class].Prefix);end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then ChatFrameEditBox:SetFocus(); end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Prefix(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
	timeout = 0,exclusive = 1,whileDead = 1
};
StaticPopupDialogs["GET_POSTFIX"] = {
	text = Hx_GET_POSTFIX_POPUP, button1 = TEXT(ACCEPT), button2 = TEXT(CANCEL), hasEditBox = 1, maxLetters = 30,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Postfix(editBox:GetText());
	end,
	OnShow = function() local eb = getglobal(this:GetName().."EditBox"); eb:SetFocus(); eb:SetText(HxSave[Class].Postfix);end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then ChatFrameEditBox:SetFocus();end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Postfix(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
	timeout = 0, exclusive = 1, whileDead = 1
};
StaticPopupDialogs["GET_SPELL_TEXT"] = {
	text = Hx_GET_SPELLTEXT_POPUP, button1 = TEXT(ACCEPT), button2 = TEXT(CANCEL), hasEditBox=1, hasWideEditBox = 1, maxLetters = 60,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."WideEditBox");
		Hx_Change_SpellText(editBox:GetText());
	end,
	OnShow = function() 
		local eb = getglobal(this:GetName().."WideEditBox"); 
		eb:SetFocus(); 
		eb:SetText(HxSave[Class].SpellText[Hx_SpellTextIndex]);
		this:SetWidth(420);
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then ChatFrameEditBox:SetFocus();end
		getglobal(this:GetName().."WideEditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."WideEditBox");
		Hx_Change_SpellText(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
	timeout = 0, exclusive = 1, whileDead = 1
};
StaticPopupDialogs["GET_INTERRUPT"] = {
	text = Hx_GET_INTERRUPT_POPUP, button1 = TEXT(ACCEPT), button2 = TEXT(CANCEL), hasEditBox = 1, maxLetters = 30,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Interrupt(editBox:GetText());
	end,
	OnShow = function() local eb = getglobal(this:GetName().."EditBox"); eb:SetFocus(); eb:SetText(HxSave[Class].Interrupt) end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then ChatFrameEditBox:SetFocus(); end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		Hx_Change_Interrupt(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
	timeout = 0, exclusive = 1, whileDead = 1
};

function Hx_Change_Channel(str) HxSave[Class].Channel = str; Hx_Print("Channel now is: "..str); end
function Hx_Change_Prefix(str) HxSave[Class].Prefix = str; Hx_Print("Prefix now is: "..str); end
function Hx_Change_Postfix(str) HxSave[Class].Postfix = str; Hx_Print("Postfix now is: "..str); end
function Hx_Change_Interrupt(str) HxSave[Class].Interrupt = str; Hx_Print("Interrupt now is: "..str); end
function Hx_Change_SpellText(str) HxSave[Class].SpellText[Hx_SpellTextIndex] = str; Hx_DemoConvertPercents(Hx_SpellTextIndex); end

-------------------
-- Button Events --
-------------------
function HxOptions_SpellTextDefault()
	for x=1, 20, 1 do
		HxSave[Class].SpellText[x] = Hx_DEFAULT_SPELLTEXT;
	end
	Hx_Print("Spells reset!");
end
----------------------------
--check boxes click events--
----------------------------
function HxOptions_CheckboxOnClick(check)
	local rent = check:GetParent():GetName(); local name = check:GetName();
	local mytog = 0;
	if (rent == "HxOptions") then	--NonSpell options
		if (check:GetChecked()) then mytog = 1;	end
		HxToggle[Class][name] = mytog;
		if (name == "SpellTell") then
			if (mytog == 1) then
				SpellTellFrame:Show();
			else
				SpellTellFrame:Hide();
			end		
		end
	elseif (rent == "HxSpellOptions") then
		name = SpellNum[Class][check:GetID()];
		if (check:GetChecked()) then mytog = 1; end
		SpellTog[Class][name] = mytog; 
	end
end
--------------------------
--When the menu is shown--
--------------------------
function HxOptions_CheckboxOnShow(check)
	local name = check:GetName();
	local labelString = getglobal(name.."Text");
	local msg; local x = 0;
	if (check:GetParent():GetName() == "HxSpellOptions") then
		msg = SpellNum[Class][tonumber(check:GetID())];
		x = SpellTog[Class][msg];
		if (msg == NIL_SPELL) then
			check:Hide();
		else
			check:Enable();
		end
	else
		Hx_DPrint("Hx options Name = "..name);
		msg = HxTXT[name].SHORT;
		x = HxToggle[Class][name];
	end
	if (x == 1) then check:SetChecked(1); else check:SetChecked(0); end
	labelString:SetText(msg);
end

function HxOptionsEditBox_OnEnterPressed()
end
----------------------------------------
--This desides if it must be displayed--
----------------------------------------
function HxOptionsDisplay()
	if ( HxOptions ) then 
		if ( HxOptions:IsVisible() ) then HideUIPanel(HxOptions); else ShowUIPanel(HxOptions); end
	end
end

function HxSpellOptionsDisplay()
	if ( HxSpellOptions ) then
		if ( HxSpellOptions:IsVisible() ) then HideUIPanel(HxSpellOptions); else ShowUIPanel(HxSpellOptions); end
	end
end

------------
--Tooltips--
------------
function HxOptions_CheckboxToolTip(check)
	local name = check:GetName();
	local msg = Hx_SPELL_INFO;
	if (strfind(name,"Spell") == nil) then msg = HxTXT[name].LONG; end
	GameTooltip:SetOwner(check, "ANCHOR_RIGHT");
	GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
	GameTooltip:SetText(msg, 1.0, 1.0, 1.0);
end
function HxOptions_ButtonToolTip(button)
	local name = button:GetName();
end
----------------
--Frame Onload--
----------------
--sets the frame title from the localisation
function Hx_Frame_OnLoad(object)
	local title = getglobal(object:GetName().."TitleText");
	if (title) then title:SetText("|cFFee9966"..getglobal(object:GetName().."_HEADER").."|r"); end
end