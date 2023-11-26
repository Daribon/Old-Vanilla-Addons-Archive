--[[
        BetterKeyBinding
                a Better KeyBindings frame
        
        By: George A. Warner <geowar@apple.com>

	-- Last Update : 08/08/2005	- added slash commands & stripped cosmos dependencies
	-- Last Update : 08/10/2005	- replaced the blank actionbar section names
        
	$Id: BetterKeyBinding.lua 1024 2005-10-08 00:36:50Z geowar $
	$Rev: 1024 $
	$LastChangedBy: geowar $
	$Date: 2005-10-08 00:36:50 -0500 (Wed, 10 Aug 2005) $
]]--

--------------------------------------------------
--
-- Constants
--
--------------------------------------------------------------

local UPDATE_RATE = 0.25;

-- Added by sarf
-- This needs to be kept up to date with the Blizzard header section names.
local BKBF_WoWInternalSectionNames = {
	"MOVEMENT",
	"CHAT",
	"ACTIONBAR",
	"TARGETING",
	"INTERFACE",
	"MISC",
	"CAMERA",
	"MULTIACTIONBAR",	-- new section
	"BKBF_BOTTOM_LEFT_ACTION_BUTTONS",	-- these are faked
	"BKBF_BOTTOM_RIGHT_ACTION_BUTTONS",
	"BKBF_RIGHT_ACTION_BUTTONS",
	"BKBF_RIGHT_ACTIONBAR2_BUTTONS",
};

local KEY_BINDINGS_DISPLAYED = 17;
local KEY_BINDING_HEIGHT = 26;

--------------------------------------------------
--
-- Globals (local)
--
--------------------------------------------------------------

local localBKBF_SectionList = nil;
local localBKBF_ConfirmKeyInfo = nil;
local localBKBF_TimeSinceLastUpdate = 0;

--------------------------------------------------
--
-- Globals (external)
--
--------------------------------------------------------------

BKBF_IsSorted = false;
BKBF_IsMixed = false;

--------------------------------------------------
--
-- "On" functions
--
--------------------------------------------------------------

------------
-- BKBF_BindingButtonTemplate
------------

function BKBF_BindingButton_OnLoad(arg1)
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up");
end

function BKBF_BindingButton_OnClick(button)
	if ( BKBF.selected ) then
		-- Code to be able to deselect or select another key to bind
		if ( button == "LeftButton" or button == "RightButton" ) then
			-- Deselect button if it was the pressed previously pressed
			if (BKBF.buttonPressed == this) then
				BKBF.selected = nil;
				BKBF_OutputText:SetText("");
			else
				-- Select a different button
				BKBF.buttonPressed = this;
				BKBF.selected = this.commandName;
				BKBF.keyID = this:GetID();
				BKBF_OutputText:SetText(format(BIND_KEY_TO_COMMAND, BKBF_GetLocalizedName(this.commandName, "BINDING_NAME_")));
			end
		else
			BKBF_OnKeyDown(button);
		end
	else
		if (BKBF.buttonPressed) then
			BKBF.buttonPressed:UnlockHighlight();
		end
		BKBF.buttonPressed = this;
		BKBF.selected = this.commandName;
		BKBF.keyID = this:GetID();
		BKBF_OutputText:SetText(format(BIND_KEY_TO_COMMAND, BKBF_GetLocalizedName(this.commandName, "BINDING_NAME_")));
	end
	BKBF_Update();
end	-- BKBF_BindingButton_OnClick

-- BKBF_SectionButtonTemplate

function BKBF_SectionButton_OnClick()
	local value = this.bindingIndex;
	if (value) then

		-- FauxScrollFrame_SetOffset doesn't actually move the scrollbar, so do this instead
		local scrollBar = getglobal(BKBF_ScrollFrame:GetName().."ScrollBar");
		if (scrollBar) then
			local min, max = scrollBar:GetMinMaxValues();
			scrollBar:SetValue(min + ((max - min + (2 * KEY_BINDING_HEIGHT)) * (value - 1) / GetNumBindings()));
		end

		FauxScrollFrame_SetOffset(BKBF_ScrollFrame, value - 1);

		BKBF_Update();
	end
end

function BKBF_SectionButton_OnEnter(id)
	-- Sea.io.print(format("BKBF_SectionButton_OnEnter(%d).", id));
end-- BKBF_SectionButton_OnEnter

------------
-- BKBF_SortCheckButton
------------

function BKBF_SortCheckButton_OnLoad()
	BKBF_IsSorted = false;
	this:SetChecked(0);
	this:RegisterEvent("VARIABLES_LOADED");	
end

function BKBF_SortCheckButton_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (BKBF_IsSorted) then
			this:SetChecked(1);
			localBKBF_SectionList = false;
			BKBF_Update();
		end
		RegisterForSave("BKBF_IsSorted");
	end
end

function BKBF_SortCheckButton_OnClick()
	if (BKBF_IsSorted) then
		BKBF_IsSorted = false;
		this:SetChecked(0);
	else
		BKBF_IsSorted = true;
		this:SetChecked(1);
	end
	-- Print(format("BKBF_SortCheckButton_OnClick(%s)", asText(BKBF_IsSorted)));
	localBKBF_SectionList = false;
	BKBF_Update();
	RegisterForSave("BKBF_IsSorted");
end	-- BKBF_SortCheckButton_OnClick

------------
-- BKBF_MixCheckButton
------------

function BKBF_MixCheckButton_OnLoad()
	BKBF_IsMixed = false;
	this:SetChecked(0);
	this:RegisterEvent("VARIABLES_LOADED");	
end	-- BKBF_MixCheckButton_OnLoad

function BKBF_MixCheckButton_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (BKBF_IsMixed) then
			this:SetChecked(1);
			localBKBF_SectionList = false;
			BKBF_Update();
		end
		RegisterForSave("BKBF_IsMixed");
	end
end	-- BKBF_MixCheckButton_OnEvent

function BKBF_MixCheckButton_OnClick()
	if (BKBF_IsMixed) then
		BKBF_IsMixed = false;
		this:SetChecked(0);
	else
		BKBF_IsMixed = true;
		this:SetChecked(1);
	end
	-- Print(format("BKBF_MixCheckButton_OnClick(%s)", asText(BKBF_IsMixed)));
	localBKBF_SectionList = false;
	BKBF_Update();
	RegisterForSave("BKBF_IsMixed");
end	-- BKBF_MixCheckButton_OnClick

------------
-- BKBF_RevertButton
------------

function BKBF_Revert_OnClick()
	-- Sea.io.print("BKBF_Revert_OnClick");
	ResetBindings();
	this:Disable();
	BKBF.selected = nil;
	BKBF_OutputText:SetText(BKBF_KEYS_REVERTED);
	BKBF_Update();
end	-- BKBF_Revert_OnClick

------------
-- BKBF_UnBindButton
------------

function BKBF_UnBindButton_OnClick()
	local key1, key2 = GetBindingKey(BKBF.selected);
	if ( key1 ) then
		SetBinding(key1);
	end
	if ( key2 ) then
		SetBinding(key2);
	end
	if ( BKBF.keyID == 1 ) then
		BKBF_SetBinding(key1, nil, key1);
		if ( key2 ) then
			SetBinding(key2, BKBF.selected);
		end
	else
		if ( key1 ) then
			BKBF_SetBinding(key1, BKBF.selected);
		end
		BKBF_SetBinding(key2, nil, key2);
	end
	BKBF_Update();
	-- Button highlighting stuff
	BKBF.selected = nil;
	BKBF.buttonPressed:UnlockHighlight();
	BKBF_RevertButton:Enable();
end	-- BKBF_UnBindButton_OnClick

------------
-- BKBF_ConfirmButton
------------

function BKBF_Confirm_OnClick()
	if (localBKBF_ConfirmKeyInfo and BKBF.selected) then
		BKBF_OutputText:SetText(KEY_BOUND);
		local key1, key2 = GetBindingKey(BKBF.selected);
		if ( key1 ) then
			SetBinding(key1);
		end
		if ( key2 ) then
			SetBinding(key2);
		end
		if ( BKBF.keyID == 1 ) then
			BKBF_SetBinding(localBKBF_ConfirmKeyInfo, BKBF.selected, key1);
			if ( key2 ) then
				SetBinding(key2, BKBF.selected);
			end
		else
			if ( key1 ) then
				BKBF_SetBinding(key1, BKBF.selected);
			end
			BKBF_SetBinding(localBKBF_ConfirmKeyInfo, BKBF.selected, key2);
		end
		-- Button highlighting stuff
		BKBF_OutputText:SetText(KEY_BOUND);
		BKBF.selected = nil;
		BKBF.buttonPressed:UnlockHighlight();

		BKBF_ConfirmButton:Disable();
		BKBF_RevertButton:Enable();

		localBKBF_ConfirmKeyInfo = nil;

		BKBF_Update();
	end
	-- update the unbind key
	BKBF_UpdateUnbindKey();
end	-- BKBF_Confirm_OnClick

------------
-- BKBF 
------------
function BKBF_OnLoad()
	-- Sea.io.print("BKBF_OnLoad");
	this:RegisterForClicks("MiddleButtonUp", "Button4Up", "Button5Up");
	BKBF.selected = nil;

	localBKBF_SectionList = false;
	BKBF_Update();

	if (Earth) then
		-- Sea.io.print("BKBF_OnLoad-EarthFeature_AddButton");
		EarthFeature_AddButton (
			{
				id = "BKB";
				name = TEXT(BKBF_NAME);
				subtext = TEXT(BKBF_BindingButton);
				tooltip = TEXT(BKBF_BindingButton_INFO);
				icon = "Interface\\Icons\\INV_Misc_Key_14";
				callback = BKBF_Toggle;
			}
		);
	end

	-- Create slash commands (as defined in localization.lua):
	SlashCmdList["BETTERKEYBINDING"] = BKBF_Toggle;
end

function BKBF_OnUpdate()
	localBKBF_TimeSinceLastUpdate = localBKBF_TimeSinceLastUpdate + arg1;
	if(localBKBF_TimeSinceLastUpdate > UPDATE_RATE) then
		BKBF_Update();
		localBKBF_TimeSinceLastUpdate = 0;
	end
end

function BKBF_OnShow()
	BKBF_RevertButton:Disable();
	localBKBF_SectionList = false;
	BKBF_Update();
end

function BKBF_OnKeyDown(button)
	if ( arg1 == "PRINTSCREEN" ) then
		Screenshot();
		return;
	end

	-- Convert the mouse button names
	if ( button == "LeftButton" ) then
		button = "BUTTON1";
	elseif ( button == "RightButton" ) then
		button = "BUTTON2";
	elseif ( button == "MiddleButton" ) then
		button = "BUTTON3";
	elseif ( button == "Button4" ) then
		button = "BUTTON4"
	elseif ( button == "Button5" ) then
		button = "BUTTON5"
	end
	if ( BKBF.selected ) then
		local keyPressed = arg1;
		if ( button ) then
			if ( button == "BUTTON1" or button == "BUTTON2" ) then
				return;
			end
			keyPressed = button;
		else
			keyPressed = arg1;
		end
		if ( keyPressed == "UNKNOWN" ) then
			return;
		end
		if ( keyPressed == "SHIFT" or keyPressed == "CTRL" or keyPressed == "ALT") then
			return;
		end
		if ( IsShiftKeyDown() ) then
			keyPressed = "SHIFT-"..keyPressed;
		end
		if ( IsControlKeyDown() ) then
			keyPressed = "CTRL-"..keyPressed;
		end
		if ( IsAltKeyDown() ) then
			keyPressed = "ALT-"..keyPressed;
		end

		-- We have to ignore case (since SHIFT is part of the string)
		keyPressed = string.upper(keyPressed);

		local oldAction = GetBindingAction(keyPressed);

		-- Sea.io.print(format("GetBindingAction(%s) == %s.", asText(keyPressed), asText(oldAction)));

		if ( oldAction ~= "" and oldAction ~= BKBF.selected ) then
			local key1, key2 = GetBindingKey(oldAction);

			-- Sea.io.print(format("GetBindingKey(%s) == %s, %s.", asText(oldAction), asText(key1), asText(key2)));

			-- Fixed WACKY inverted logic here!
			if ( (key1 and (key1 == keyPressed)) or (key2 and (key2 == keyPressed)) ) then
				-- Error message
				-- BKBF_OutputText:SetText(format(KEY_UNBOUND_ERROR, BKBF_GetLocalizedName(oldAction, "BINDING_NAME_")));
				BKBF_OutputText:SetText(format(BKBF_KEY_ALREADY_BOUND_ERROR, BKBF_GetLocalizedName(oldAction, "BINDING_NAME_")));
				localBKBF_ConfirmKeyInfo = keyPressed;
				BKBF_Update();
				return;
			end
		else
			BKBF_OutputText:SetText(KEY_BOUND);
		end
		local key1, key2 = GetBindingKey(BKBF.selected);
		if ( key1 ) then
			SetBinding(key1);
		end
		if ( key2 ) then
			SetBinding(key2);
		end
		if ( BKBF.keyID == 1 ) then
			BKBF_SetBinding(keyPressed, BKBF.selected, key1);
			if ( key2 ) then
				SetBinding(key2, BKBF.selected);
			end
		else
			if ( key1 ) then
				BKBF_SetBinding(key1, BKBF.selected);
			end
			BKBF_SetBinding(keyPressed, BKBF.selected, key2);
		end
		BKBF_Update();
		-- Button highlighting stuff
		BKBF.selected = nil;
		BKBF.buttonPressed:UnlockHighlight();

		BKBF_RevertButton:Enable();

	else
		if ( arg1 == "ESCAPE" ) then
			ResetBindings();
			BKBF_OutputText:SetText("");
			BKBF.selected = nil;
			HideUIPanel(this);
		end
	end
	-- update the unbind key
	BKBF_UpdateUnbindKey();
end	-- BKBF_OnKeyDown

------------
-- Callback functions
------------

function BKBF_Toggle()
	-- Sea.io.print("BKBF_Toggle");
	if (BKBF:IsVisible()) then
		HideUIPanel(BKBF);
	else
		ShowUIPanel(BKBF);
	end
end

function BKBF_GetLocalizedName(name, prefix)
	if ( not name ) then
		return "";
	end
	local tempName = name;
	local i = strfind(name, "-");
	local dashIndex = nil;
	while ( i ) do
		if ( not dashIndex ) then
			dashIndex = i;
		else
			dashIndex = dashIndex + i;
		end
		tempName = strsub(tempName, i + 1);
		i = strfind(tempName, "-");
	end

	local modKeys = '';
	if ( not dashIndex ) then
		dashIndex = 0;
	else
		modKeys = strsub(name, 1, dashIndex);
	end

	local variablePrefix = prefix;
	if ( not variablePrefix ) then
		variablePrefix = "";
	end
	local localizedName = nil;
	if ( IsMacClient() ) then
		localizedName = getglobal(variablePrefix..tempName.."_MAC");
	end
	if ( not localizedName ) then
		localizedName = getglobal(variablePrefix..tempName);
	end
	if ( localizedName ) then
		return modKeys..localizedName;
	else 
		return name;
	end
end	-- BKBF_GetLocalizedName

function BKBF_Update()
	local numBindings = GetNumBindings();
	local keyOffset;
	local BKBF_BindingButton1, BKBF_BindingButton2, commandName, binding1, binding2;
	local keyBindingDescription;
	local BKBF_BindingButton1NormalTexture, BKBF_BindingButton1PushedTexture;

	if (not localBKBF_SectionList) then
		BKBF_GenerateSections();
	end

	local sectionOffset = FauxScrollFrame_GetOffset(BKBF_SectionScrollFrame)+1;
	local sectionButtonIndex = 1;
	local sectionButton = nil;
	local numSections = table.getn(localBKBF_SectionList);
	local id = 0;
	for id = 1, KEY_BINDINGS_DISPLAYED do
		local i = id + sectionOffset - 1;
		sectionButton = getglobal("BKBF_SectionButton"..id);
		if (sectionButton) then
			if (i <= numSections) then
				local section = localBKBF_SectionList[i];
				if ( section ) then
					sectionButton:SetText(section.name);
					if (BKBF_IsWoWInternalSectionName(section.name)) then
						sectionButton:SetTextColor(1.0, 1.0, 1.0);
					else
						sectionButton:SetTextColor(0.3, 0.6, 1.0);
					end
					sectionButton:Show();
					sectionButton.bindingIndex = section.bindingIndex;
				else
					sectionButton:Hide();
				end
			else
				sectionButton:Hide();
			end
		end
	end

	-- Scroll frame stuff
	FauxScrollFrame_Update(BKBF_SectionScrollFrame, numSections + 1, KEY_BINDINGS_DISPLAYED, KEY_BINDING_HEIGHT );

	if (localBKBF_ConfirmKeyInfo) then
		BKBF_ConfirmButton:Enable();
	else
		BKBF_ConfirmButton:Disable();
	end

	for i=1, KEY_BINDINGS_DISPLAYED, 1 do
		keyOffset = FauxScrollFrame_GetOffset(BKBF_ScrollFrame) + i;
		if ( keyOffset <= numBindings) then
			BKBF_BindingButton1 = getglobal("BKBF_Binding"..i.."Key1Button");
			BKBF_BindingButton1NormalTexture = getglobal("BKBF_Binding"..i.."Key1ButtonNormalTexture");
			BKBF_BindingButton1PushedTexture = getglobal("BKBF_Binding"..i.."Key1ButtonPushedTexture");
			BKBF_BindingButton2NormalTexture = getglobal("BKBF_Binding"..i.."Key2ButtonNormalTexture");
			BKBF_BindingButton2PushedTexture = getglobal("BKBF_Binding"..i.."Key2ButtonPushedTexture");
			BKBF_BindingButton2 = getglobal("BKBF_Binding"..i.."Key2Button");
			keyBindingDescription = getglobal("BKBF_Binding"..i.."Description");
			-- Set binding text
			commandName, binding1, binding2 = GetBinding(keyOffset);
			-- Handle header
			local headerText = getglobal("BKBF_Binding"..i.."Header");
			if ( strsub(commandName, 1, 6) == "HEADER" ) then
				local text = getglobal("BINDING_"..commandName);
				headerText:SetText(text);

				if (BKBF_IsWoWInternalSectionName(text)) then
					headerText:SetTextColor(1.0, 1.0, 1.0);
				else
					headerText:SetTextColor(0.3, 0.6, 1.0);
				end
				headerText:Show();

				BKBF_BindingButton1:Hide();
				BKBF_BindingButton2:Hide();
				keyBindingDescription:Hide();
			else
				headerText:Hide();
				BKBF_BindingButton1:Show();
				BKBF_BindingButton2:Show();
				keyBindingDescription:Show();
				BKBF_BindingButton1.commandName = commandName;
				BKBF_BindingButton2.commandName = commandName;
				if ( binding1 ) then
					BKBF_BindingButton1:SetText(BKBF_GetLocalizedName(binding1, "KEY_"));
					--BKBF_BindingButton1:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up");
					--BKBF_BindingButton1:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down");
					BKBF_BindingButton1NormalTexture:SetAlpha(1);
					BKBF_BindingButton1PushedTexture:SetAlpha(1);
				else
					BKBF_BindingButton1:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
					--BKBF_BindingButton1:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up");
					--BKBF_BindingButton1:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down");
					BKBF_BindingButton1NormalTexture:SetAlpha(0.8);
					BKBF_BindingButton1PushedTexture:SetAlpha(0.8);
				end
				if ( binding2 ) then
					BKBF_BindingButton2:SetText(BKBF_GetLocalizedName(binding2, "KEY_"));
					BKBF_BindingButton2NormalTexture:SetAlpha(1);
					BKBF_BindingButton2PushedTexture:SetAlpha(1);
				else
					BKBF_BindingButton2:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
					BKBF_BindingButton2NormalTexture:SetAlpha(0.8);
					BKBF_BindingButton2PushedTexture:SetAlpha(0.8);
				end
				-- Set description
				keyBindingDescription:SetText(BKBF_GetLocalizedName(commandName, "BINDING_NAME_"));
				-- Handle highlight
				BKBF_BindingButton1:UnlockHighlight();
				BKBF_BindingButton2:UnlockHighlight();
				if ( BKBF.selected == commandName ) then
					if ( BKBF.keyID == 1 ) then
						BKBF_BindingButton1:LockHighlight();
					else
						BKBF_BindingButton2:LockHighlight();
					end
				end
				getglobal("BKBF_Binding"..i):Show();
			end
		else
			getglobal("BKBF_Binding"..i):Hide();
		end
	end

	-- Scroll frame stuff
	FauxScrollFrame_Update(BKBF_ScrollFrame, numBindings, KEY_BINDINGS_DISPLAYED, KEY_BINDING_HEIGHT );

	-- update the unbind key
	BKBF_UpdateUnbindKey();
end	-- BKBF_Update

function BKBF_SetBinding(key, selectedBinding, oldKey)
	if ( SetBinding(key, selectedBinding) ) then
		return;
	else
		if ( oldKey ) then
			SetBinding(oldKey, selectedBinding);
		end
		--Error message
		BKBF_OutputText:SetText(TEXT(BKBF_NO_MOUSEWHEEL_TO_UP_AND_DOWN));
	end
end

-- will generate localBKBF_SectionList, a list of all sections
function BKBF_GenerateSections()
	localBKBF_SectionList = {};

	local numBindings = GetNumBindings();

	local commandName, binding1, binding2;
	local sectionButtonIndex = 1;
	local section = nil;

	for bindingIndex=1, numBindings, 1 do
		commandName, binding1, binding2 = GetBinding(bindingIndex);
		if ( strsub(commandName, 1, 6) == "HEADER" ) then
			local text = getglobal("BINDING_"..commandName);

			if (commandName == "HEADER_MULTIACTIONBAR") then
				text = BKBF_BOTTOM_LEFT_ACTION_BUTTONS;
			elseif (commandName == "HEADER_BLANK") then
				text = BKBF_BOTTOM_RIGHT_ACTION_BUTTONS;
			elseif (commandName == "HEADER_BLANK2") then
				text = BKBF_RIGHT_ACTION_BUTTONS;
			elseif (commandName == "HEADER_BLANK3") then
				text = BKBF_RIGHT_ACTIONBAR2_BUTTONS;
			end

			-- Sea.io.print(format("bindingIndex: %d, commandName: %s, text: %s.", bindingIndex, asText(commandName), asText(text)));

			if (text) then
				section = {};
				section.name = text;
				section.bindingIndex = bindingIndex;
				table.insert(localBKBF_SectionList, section);
				sectionButtonIndex = sectionButtonIndex + 1;
			end
		end
	end
	if (BKBF_IsSorted) then
		table.sort(localBKBF_SectionList, BKBF_SectionComparator);
	end
end

function BKBF_GetWoWInternalSectionNameIndex(name)
	for k, v in BKBF_WoWInternalSectionNames do
		if ( getglobal("BINDING_HEADER_"..v) == name ) then
			return k;
		end
	end
	return -1;
end

function BKBF_IsWoWInternalSectionName(name)
	if ( BKBF_GetWoWInternalSectionNameIndex(name) > -1 ) then
		return true;
	else
		return false;
	end
end

function BKBF_CompareWoWInternalSectionName(name1, name2)
	if ( name1 ) and ( name2 ) then
		local index1 = BKBF_GetWoWInternalSectionNameIndex(name1);
		local index2 = BKBF_GetWoWInternalSectionNameIndex(name2);
		if (BKBF_IsMixed or (index1 <= -1 ) and ( index2 <= -1 )) then
			return (name1 < name2);
		elseif ( index1 > -1 ) and ( index2 > -1 ) then
			if ( index1 >= index2 ) then
				return false;
			else
				return true;
			end
		elseif ( index1 <= -1 ) then
			return false;
		elseif ( index2 <= -1 ) then
			return true;
		end
	elseif ( name1 ) then
		return false;
	elseif ( name2 ) then
		return true;
	else
		return false;
	end
end

-- Helper function to sort the list of the sections
function BKBF_SectionComparator(section1, section2)
	-- Sea.io.print(format("BKBF_SectionComparator(%s, %s)", asText(section1), asText(section2)));
	if ( ( section1 ) and ( section2 ) ) then
		return BKBF_CompareWoWInternalSectionName(section1.name, section2.name);
	elseif ( section1 ) then
		return false;
	elseif ( section2 ) then
		return true;
	end
end

function BKBF_UpdateUnbindKey()
	local enableUnbind = false;
	if (BKBF.selected) then
		local key1, key2 = GetBindingKey(BKBF.selected);
		-- Sea.io.print(format("GetBindingKey(%s) == %s, %s.", asText(BKBF.selected), asText(key1), asText(key2)));
		-- Sea.io.print(format("BKBF.keyID == %d.", asText(BKBF.keyID)));
		if ( BKBF.keyID == 1 ) then
			if ( key1 ) then
				enableUnbind = true;
			end
		else
			if ( key2 ) then
				enableUnbind = true;
			end
		end
	end

	if (enableUnbind) then
		BKBF_UnBindButton:Enable();
	else
		BKBF_UnBindButton:Disable();
	end
end
