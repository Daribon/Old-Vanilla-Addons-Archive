--[[

	BetterKeyBinding: a Better BetterKeyBindings window

]]

------------
-- Constants
------------

local UPDATE_RATE = 0.25;

-- Added by sarf
-- This needs to be kept up to date with the Blizzard header section names.
local BetterKeyBinding_WoWInternalSectionNames = {
	"MOVEMENT",
	"CHAT",
	"ACTIONBAR",
	"TARGETING",
	"INTERFACE",
	"MISC",
	"CAMERA",
};

local KEY_BINDINGS_DISPLAYED = 17;
local KEY_BINDING_HEIGHT = 22;

------------
-- Globals
------------

local numSections = 0;

local BetterKeyBinding_SectionList = nil;

local BetterKeyBinding_ConfirmKeyInfo = nil;

BetterKeyBinding_IsSorted = false;
BetterKeyBinding_IsMixed = false;

function BetterKeyBinding_OnShow()
	BetterKeyBindingFrameRevertButton:Disable();
	BetterKeyBinding_Update();
end

function BetterKeyBinding_OnLoad()
	-- Print("BetterKeyBinding_OnLoad");

	this:RegisterForClicks("MiddleButtonUp", "Button4Up", "Button5Up");
	BetterKeyBindingFrame.selected = nil;
	BetterKeyBinding_Update();

	if(Cosmos_RegisterButton) then
		-- Print("BetterKeyBinding_OnLoad-Cosmos_RegisterButton");
		Cosmos_RegisterButton ( 
			TEXT(BKB_NAME), 
			TEXT(BKB_BUTTON), 
			TEXT(BKB_BUTTON_INFO), 
			"Interface\\Icons\\INV_Misc_Key_14", 
			ToggleBetterKeyBinding
		);
	end
end

function ToggleBetterKeyBinding()
	if (BetterKeyBindingFrame:IsVisible()) then
		HideUIPanel(BetterKeyBindingFrame);
	else
		ShowUIPanel(BetterKeyBindingFrame);
	end
end

function BetterKeyBinding_GetLocalizedName(name, prefix)
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
end

function BetterKeyBindingSection_OnEnter(id)
	--Print(format("BetterKeyBindingSection_OnEnter(%d).", id));
end

function BetterKeyBindingSectionButton_OnClick()
	local value = this.bindingIndex;
	if (value) then

		-- FauxScrollFrame_SetOffset doesn't actually move the scrollbar, so do this instead
		local scrollBar = getglobal(BetterKeyBindingFrameScrollFrame:GetName().."ScrollBar");
		if (scrollBar) then
			local min, max = scrollBar:GetMinMaxValues();
			scrollBar:SetValue(min + ((max - min + (2 * KEY_BINDING_HEIGHT)) * (value - 1) / GetNumBindings()));
		end

		FauxScrollFrame_SetOffset(BetterKeyBindingFrameScrollFrame, value - 1);

		BetterKeyBinding_Update();
	end
end

function BetterKeyBinding_Revert_OnClick()
	-- Print("BetterKeyBinding_Revert_OnClick");
	ResetBindings();
	this:Disable();
	BetterKeyBindingFrame.selected = nil;
	BetterKeyBindingFrameOutputText:SetText(BKB_KEYS_REVERTED);
	BetterKeyBinding_Update();
end

function BetterKeyBinding_Update()
	local numBindings = GetNumBindings();
	local keyOffset;
	local BetterKeyBindingButton1, BetterKeyBindingButton2, commandName, binding1, binding2;
	local BetterKeyBindingName, BetterKeyBindingDescription;
	local BetterKeyBindingButton1NormalTexture, BetterKeyBindingButton1PushedTexture;

	BetterKeyBinding_GenerateSections();

	local sectionOffset = FauxScrollFrame_GetOffset(BetterKeyBindingSectionScrollFrame)+1;
	local sectionButtonIndex = 1;
	local sectionButton = nil;
	local displayedButtons = 0;
	local id = 0;
	for id = 1, KEY_BINDINGS_DISPLAYED do
		local i = id + sectionOffset - 1;
		sectionButton = getglobal("BetterKeyBindingSectionButton"..id);
		if (sectionButton) then
			local section = BetterKeyBinding_SectionList[i];
			if ( section ) then
				sectionButton:SetText(section.name);
				if (BetterKeyBinding_IsWoWInternalSectionName(section.name)) then
					sectionButton:SetTextColor(1.0, 1.0, 1.0);
				else
					sectionButton:SetTextColor(0.3, 0.6, 1.0);
				end
				sectionButton:Show();
				sectionButton.bindingIndex = section.bindingIndex;
				displayedButtons = displayedButtons + 1;
			else
				Print("index "..i.." did not correspond to a section.");
				break;
			end
		end
	end
	for i = displayedButtons+1, KEY_BINDINGS_DISPLAYED do
		sectionButton = getglobal("BetterKeyBindingSectionButton"..i);
		if (sectionButton) then
			sectionButton:Hide();
		end
	end
	-- Scroll frame stuff
	FauxScrollFrame_Update(BetterKeyBindingSectionScrollFrame, numSections + 1, KEY_BINDINGS_DISPLAYED, KEY_BINDING_HEIGHT );

	if (BetterKeyBinding_ConfirmKeyInfo) then
		BetterKeyBindingFrameConfirmButton:Enable();
	else
		BetterKeyBindingFrameConfirmButton:Disable();
	end

	for i=1, KEY_BINDINGS_DISPLAYED, 1 do
		keyOffset = FauxScrollFrame_GetOffset(BetterKeyBindingFrameScrollFrame) + i;
		if ( keyOffset <= numBindings) then
			BetterKeyBindingButton1 = getglobal("BetterKeyBindingFrameBinding"..i.."Key1Button");
			BetterKeyBindingButton1NormalTexture = getglobal("BetterKeyBindingFrameBinding"..i.."Key1ButtonNormalTexture");
			BetterKeyBindingButton1PushedTexture = getglobal("BetterKeyBindingFrameBinding"..i.."Key1ButtonPushedTexture");
			BetterKeyBindingButton2NormalTexture = getglobal("BetterKeyBindingFrameBinding"..i.."Key2ButtonNormalTexture");
			BetterKeyBindingButton2PushedTexture = getglobal("BetterKeyBindingFrameBinding"..i.."Key2ButtonPushedTexture");
			BetterKeyBindingButton2 = getglobal("BetterKeyBindingFrameBinding"..i.."Key2Button");
			BetterKeyBindingDescription = getglobal("BetterKeyBindingFrameBinding"..i.."Description");
			-- Set binding text
			commandName, binding1, binding2 = GetBinding(keyOffset);
			-- Handle header
			local headerText = getglobal("BetterKeyBindingFrameBinding"..i.."Header");
			if ( strsub(commandName, 1, 6) == "HEADER" ) then
				local text = getglobal("BINDING_"..commandName);
				headerText:SetText(text);

				if (BetterKeyBinding_IsWoWInternalSectionName(text)) then
					headerText:SetTextColor(1.0, 1.0, 1.0);
				else
					headerText:SetTextColor(0.3, 0.6, 1.0);
				end
				headerText:Show();

				BetterKeyBindingButton1:Hide();
				BetterKeyBindingButton2:Hide();
				BetterKeyBindingDescription:Hide();
			else
				headerText:Hide();
				BetterKeyBindingButton1:Show();
				BetterKeyBindingButton2:Show();
				BetterKeyBindingDescription:Show();
				BetterKeyBindingButton1.commandName = commandName;
				BetterKeyBindingButton2.commandName = commandName;
				if ( binding1 ) then
					BetterKeyBindingButton1:SetText(BetterKeyBinding_GetLocalizedName(binding1, "KEY_"));
					--BetterKeyBindingButton1:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up");
					--BetterKeyBindingButton1:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down");
					BetterKeyBindingButton1NormalTexture:SetAlpha(1);
					BetterKeyBindingButton1PushedTexture:SetAlpha(1);
				else
					BetterKeyBindingButton1:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
					--BetterKeyBindingButton1:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up");
					--BetterKeyBindingButton1:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down");
					BetterKeyBindingButton1NormalTexture:SetAlpha(0.8);
					BetterKeyBindingButton1PushedTexture:SetAlpha(0.8);
				end
				if ( binding2 ) then
					BetterKeyBindingButton2:SetText(BetterKeyBinding_GetLocalizedName(binding2, "KEY_"));
					BetterKeyBindingButton2NormalTexture:SetAlpha(1);
					BetterKeyBindingButton2PushedTexture:SetAlpha(1);
				else
					BetterKeyBindingButton2:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
					BetterKeyBindingButton2NormalTexture:SetAlpha(0.8);
					BetterKeyBindingButton2PushedTexture:SetAlpha(0.8);
				end
				-- Set description
				BetterKeyBindingDescription:SetText(BetterKeyBinding_GetLocalizedName(commandName, "BINDING_NAME_"));
				-- Handle highlight
				BetterKeyBindingButton1:UnlockHighlight();
				BetterKeyBindingButton2:UnlockHighlight();
				if ( BetterKeyBindingFrame.selected == commandName ) then
					if ( BetterKeyBindingFrame.keyID == 1 ) then
						BetterKeyBindingButton1:LockHighlight();
					else
						BetterKeyBindingButton2:LockHighlight();
					end
				end
				getglobal("BetterKeyBindingFrameBinding"..i):Show();
			end
		else
			getglobal("BetterKeyBindingFrameBinding"..i):Hide();
		end
	end
	
	-- Scroll frame stuff
	FauxScrollFrame_Update(BetterKeyBindingFrameScrollFrame, numBindings, KEY_BINDINGS_DISPLAYED, KEY_BINDING_HEIGHT );

end

local TimeSinceLastUpdate = 0;
function BetterKeyBinding_OnUpdate()
	TimeSinceLastUpdate = TimeSinceLastUpdate + arg1;
	if(TimeSinceLastUpdate > UPDATE_RATE) then
		BetterKeyBinding_Update();
		TimeSinceLastUpdate = 0;
	end
end

function BetterKeyBinding_Confirm_OnClick()
	if (BetterKeyBinding_ConfirmKeyInfo and BetterKeyBindingFrame.selected) then
		BetterKeyBindingFrameOutputText:SetText(KEY_BOUND);
		local key1, key2 = GetBindingKey(BetterKeyBindingFrame.selected);
		if ( key1 ) then
			SetBinding(key1);
		end
		if ( key2 ) then
			SetBinding(key2);
		end
		if ( BetterKeyBindingFrame.keyID == 1 ) then
			BetterKeyBinding_SetBinding(BetterKeyBinding_ConfirmKeyInfo, BetterKeyBindingFrame.selected, key1);
			if ( key2 ) then
				SetBinding(key2, BetterKeyBindingFrame.selected);
			end
		else
			if ( key1 ) then
				BetterKeyBinding_SetBinding(key1, BetterKeyBindingFrame.selected);
			end
			BetterKeyBinding_SetBinding(BetterKeyBinding_ConfirmKeyInfo, BetterKeyBindingFrame.selected, key2);
		end
		-- Button highlighting stuff
		BetterKeyBindingFrameOutputText:SetText(KEY_BOUND);
		BetterKeyBindingFrame.selected = nil;
		BetterKeyBindingFrame.buttonPressed:UnlockHighlight();

		BetterKeyBindingFrameConfirmButton:Disable();
		BetterKeyBindingFrameRevertButton:Enable();

		BetterKeyBinding_ConfirmKeyInfo = nil;

		BetterKeyBinding_Update();
	end
end

function BetterKeyBinding_OnKeyDown(button)
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
	if ( BetterKeyBindingFrame.selected ) then
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

		-- Print(format("GetBindingAction(%s) == %s.", asText(keyPressed), asText(oldAction)));

		if ( oldAction ~= "" and oldAction ~= BetterKeyBindingFrame.selected ) then
			local key1, key2 = GetBindingKey(oldAction);

			-- Print(format("GetBindingKey(%s) == %s, %s.", asText(oldAction), asText(key1), asText(key2)));

			-- Fixed WACKY inverted logic here!
			if ( (key1 and (key1 == keyPressed)) or (key2 and (key2 == keyPressed)) ) then
				-- Error message
				-- BetterKeyBindingFrameOutputText:SetText(format(KEY_UNBOUND_ERROR, BetterKeyBinding_GetLocalizedName(oldAction, "BINDING_NAME_")));
				BetterKeyBindingFrameOutputText:SetText(format(BKB_KEY_ALREADY_BOUND_ERROR, BetterKeyBinding_GetLocalizedName(oldAction, "BINDING_NAME_")));
				BetterKeyBinding_ConfirmKeyInfo = keyPressed;
				BetterKeyBinding_Update();
				return;
			end
		else
			BetterKeyBindingFrameOutputText:SetText(KEY_BOUND);
		end
		local key1, key2 = GetBindingKey(BetterKeyBindingFrame.selected);
		if ( key1 ) then
			SetBinding(key1);
		end
		if ( key2 ) then
			SetBinding(key2);
		end
		if ( BetterKeyBindingFrame.keyID == 1 ) then
			BetterKeyBinding_SetBinding(keyPressed, BetterKeyBindingFrame.selected, key1);
			if ( key2 ) then
				SetBinding(key2, BetterKeyBindingFrame.selected);
			end
		else
			if ( key1 ) then
				BetterKeyBinding_SetBinding(key1, BetterKeyBindingFrame.selected);
			end
			BetterKeyBinding_SetBinding(keyPressed, BetterKeyBindingFrame.selected, key2);
		end
		BetterKeyBinding_Update();
		-- Button highlighting stuff
		BetterKeyBindingFrame.selected = nil;
		BetterKeyBindingFrame.buttonPressed:UnlockHighlight();

		BetterKeyBindingFrameRevertButton:Enable();

	else
		if ( arg1 == "ESCAPE" ) then
			ResetBindings();
			BetterKeyBindingFrameOutputText:SetText("");
			BetterKeyBindingFrame.selected = nil;
			HideUIPanel(this);
		end
	end
end

function BetterKeyBindingButton_OnClick(button)
	if ( BetterKeyBindingFrame.selected ) then
		-- Code to be able to deselect or select another key to bind
		if ( button == "LeftButton" or button == "RightButton" ) then
			-- Deselect button if it was the pressed previously pressed
			if (BetterKeyBindingFrame.buttonPressed == this) then
				BetterKeyBindingFrame.selected = nil;
				BetterKeyBindingFrameOutputText:SetText("");
			else
				-- Select a different button
				BetterKeyBindingFrame.buttonPressed = this;
				BetterKeyBindingFrame.selected = this.commandName;
				BetterKeyBindingFrame.keyID = this:GetID();
				BetterKeyBindingFrameOutputText:SetText(format(BIND_KEY_TO_COMMAND, BetterKeyBinding_GetLocalizedName(this.commandName, "BINDING_NAME_")));
			end
			BetterKeyBinding_Update();
			return;
		end
		BetterKeyBinding_OnKeyDown(button);
	else
		if (BetterKeyBindingFrame.buttonPressed) then
			BetterKeyBindingFrame.buttonPressed:UnlockHighlight();
		end
		BetterKeyBindingFrame.buttonPressed = this;
		BetterKeyBindingFrame.selected = this.commandName;
		BetterKeyBindingFrame.keyID = this:GetID();
		BetterKeyBindingFrameOutputText:SetText(format(BIND_KEY_TO_COMMAND, BetterKeyBinding_GetLocalizedName(this.commandName, "BINDING_NAME_")));
		BetterKeyBinding_Update();
	end
end

function BetterKeyBinding_SetBinding(key, selectedBinding, oldKey)
	if ( SetBinding(key, selectedBinding) ) then
		return;
	else
		if ( oldKey ) then
			SetBinding(oldKey, selectedBinding);
		end
		--Error message
		BetterKeyBindingFrameOutputText:SetText(TEXT(BKB_NO_MOUSEWHEEL_TO_UP_AND_DOWN));
	end
end

-- will generate BetterKeyBinding_SectionList, a list of all sections
function BetterKeyBinding_GenerateSections()
	BetterKeyBinding_SectionList = {};
	numSections = 0;

	local numBindings = GetNumBindings();

	local commandName, binding1, binding2;
	local sectionButtonIndex = 1;
	local section = nil;

	for bindingIndex=1, numBindings, 1 do
		commandName, binding1, binding2 = GetBinding(bindingIndex);
		if ( strsub(commandName, 1, 6) == "HEADER" ) then
			local text = getglobal("BINDING_"..commandName);
			if (text) then
				numSections = numSections + 1;
				section = {};
				section.name = text;
				section.bindingIndex = bindingIndex;
				table.insert(BetterKeyBinding_SectionList, section);
				sectionButtonIndex = sectionButtonIndex + 1;
			end
		end
	end
	if (BetterKeyBinding_IsSorted) then
		table.sort(BetterKeyBinding_SectionList, BetterKeyBinding_SectionComparator);
	end
end

function BetterKeyBinding_GetWoWInternalSectionNameIndex(name)
	for k, v in BetterKeyBinding_WoWInternalSectionNames do
		if ( getglobal("BINDING_HEADER_"..v) == name ) then
			return k;
		end
	end
	return -1;
end

function BetterKeyBinding_IsWoWInternalSectionName(name)
	if ( BetterKeyBinding_GetWoWInternalSectionNameIndex(name) > -1 ) then
		return true;
	else
		return false;
	end
end

function BetterKeyBinding_CompareWoWInternalSectionName(name1, name2)
	if ( name1 ) and ( name2 ) then
		local index1 = BetterKeyBinding_GetWoWInternalSectionNameIndex(name1);
		local index2 = BetterKeyBinding_GetWoWInternalSectionNameIndex(name2);
		if (BetterKeyBinding_IsMixed or (index1 <= -1 ) and ( index2 <= -1 )) then
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
function BetterKeyBinding_SectionComparator(section1, section2)
	-- Print(format("BetterKeyBinding_SectionComparator(%s, %s)", asText(section1), asText(section2)));
	if ( ( section1 ) and ( section2 ) ) then
		return BetterKeyBinding_CompareWoWInternalSectionName(section1.name, section2.name);
	elseif ( section1 ) then
		return false;
	elseif ( section2 ) then
		return true;
	end
end
