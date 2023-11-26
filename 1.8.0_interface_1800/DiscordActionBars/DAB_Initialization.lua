function DAB_updateContainerFrameAnchors()
	-- Adjust the start anchor for bags depending on the multibars
	UIParent_ManageRightSideFrames();
	local xOffset = CONTAINER_OFFSET_X;
	local uiScale = GetCVar("uiscale") + 0;
	local screenHeight = 768;
	if ( GetCVar("useUiScale") == "1" ) then
		screenHeight = 768 / uiScale;
	end
	local freeScreenHeight = screenHeight - CONTAINER_OFFSET_Y;
	local index = 1;
	local column = 0;
	while ContainerFrame1.bags[index] do
		local frame = getglobal(ContainerFrame1.bags[index]);
		-- freeScreenHeight determines when to start a new column of bags
		if ( index == 1 ) then
			-- First bag
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", -xOffset + DAB_Settings[DAB_INDEX].BagOffsetX, CONTAINER_OFFSET_Y + DAB_Settings[DAB_INDEX].BagOffsetY);
		elseif ( freeScreenHeight < frame:GetHeight() ) then
			-- Start a new column
			column = column + 1;
			freeScreenHeight = UIParent:GetHeight() - CONTAINER_OFFSET_Y;
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset + DAB_Settings[DAB_INDEX].BagOffsetX, CONTAINER_OFFSET_Y + DAB_Settings[DAB_INDEX].BagOffsetY);
		else
			-- Anchor to the previous bag
			frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);	
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		index = index + 1;
	end
	-- This is used to position the unit tooltip
	local oldContainerPosition = OPEN_CONTAINER_POSITION;
	if ( index == 1 ) then
		DEFAULT_TOOLTIP_POSITION = -13;
	else
		DEFAULT_TOOLTIP_POSITION = -((column + 1) * CONTAINER_WIDTH) - xOffset;
	end
	if ( DEFAULT_TOOLTIP_POSITION ~= oldContainerPosition and GameTooltip.default and GameTooltip:IsVisible() ) then
		GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", DEFAULT_TOOLTIP_POSITION, 64);
	end
end

function DAB_HideMe()
	this:Hide();
end

function DAB_HideMainMenuArt()
	if (DAB_Settings[DAB_INDEX].ShowDefaultArt) then
		return;
	end
	
	MainMenuBar:EnableMouse();
	MainMenuBar:Hide();
	MainMenuBar:SetScript("OnShow", DAB_HideMe);
end

function DAB_Initialize()
	if (DAB_INITIALIZED) then return; end

	DAB_INDEX = UnitName("player").."::"..GetCVar("realmName");

	DAB_Old_PetActionBar_Update = PetActionBar_Update;
	PetActionBar_Update = DAB_PetActionBar_Update;
	DAB_Old_UpdateTalentButton = UpdateTalentButton;
	UpdateTalentButton = DAB_UpdateTalentButton;
	DAB_Old_ShapeshiftBar_Update = ShapeshiftBar_Update;
	ShapeshiftBar_Update = DAB_ShapeshiftBar_Update;
	--updateContainerFrameAnchors = DAB_updateContainerFrameAnchors;

	if (CT_PetBar_Drag) then
		DELAY_CT_WARNING = 10;
	end

	if (not DAB_Settings) then
		DAB_Settings = {};
	end

--	if (DAB_Settings[DAB_INDEX]) then
--		DAB_Settings["INITIALIZED2.0"] = true;
--	end
	if (not DAB_Settings["INITIALIZED2.0"]) then
		DAB_Settings = {nil};
		DAB_Settings["INITIALIZED2.0"] = true;
	end

	if (not DAB_Settings.SavedSettings) then
		DAB_Settings.SavedSettings = {};
	end
	
	if (not DAB_Settings[DAB_INDEX]) then
		DAB_Initialize_DefaultSettings();
	end

	for event, macro in DAB_Settings[DAB_INDEX].EventMacros do
		DAB_Settings[DAB_INDEX].EventMacros[event] = string.gsub(macro, "/script", "");
	end

	DAB_INITIALIZED = true;
	DAB_HideMainMenuArt();
	DAB_Initialize_AllSettings();

	if (DAB_Settings[DAB_INDEX].EventMacros["VARIABLES_LOADED"]) then
		RunScript(DAB_Settings[DAB_INDEX].EventMacros["VARIABLES_LOADED"]);
	end
end

function DAB_PetActionBar_Update()
	DAB_Old_PetActionBar_Update();
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		petActionButton = getglobal("PetActionButton"..i);
		petActionButton:SetNormalTexture("");
	end
end

function DAB_ShapeshiftBar_Update()
	if (not DAB_Settings[DAB_INDEX].OtherBar[12].hide) then
		DAB_Old_ShapeshiftBar_Update();
	end
end

function DAB_UpdateTalentButton()
	if (not DAB_Settings[DAB_INDEX].OtherBar[14].hide) then
		DAB_Old_UpdateTalentButton();
	end
end

function DAB_Initialize_AllSettings()
	DAB_Initialize_NewSettings();
	DAB_Initialize_FrameLocations();
	DAB_Initialize_Bars();
	DAB_Initialize_ControlBoxes();
	DAB_UpdateKeybindingLabels();
	DAB_UpdateKeybindings();
	DAB_SetKeybindingBar(DAB_Settings[DAB_INDEX].DynamicKeybindingBar);
	DAB_Initialize_BarOptions();
	DAB_Initialize_NumButtonsOptions();
	DAB_Initialize_FreeButtons();
	DAB_Initialize_Floaters();
	DAB_Options_SetScale();
	DAB_Initialize_MiscOptions();
	DAB_Initialize_FormMenu();
	DAB_Initialize_SavedSettingsMenu()
	if (DAB_Settings[DAB_INDEX].ButtonsUnlocked) then
		DAB_ToggleButtonsLock_Button:SetText(DAB_TEXT.LockButtons);
	end
	for i=1,120 do
		this = getglobal("DAB_ActionButton_"..i);
		DAB_ActionButton_Update();
	end
	DAB_Bar_UpdateFormBars(DAB_Get_CurrentForm());
	if (UnitName("pet") and UnitExists("pet")) then
		if (not DAB_Settings[DAB_INDEX].OtherBar[11].hide) then
			DAB_OtherBar_Show(11);
		end
	else
		DAB_OtherBar_Hide(11);
	end
	DAB_CompileEventMacros();
	DAB_Initialize_XPBar();
end

function DAB_Initialize_Bars()
	for bar=1,DAB_NUMBER_OF_BARS do
		DAB_Bar_Initialize(bar);
	end
	for bar = 11, 14 do
		DAB_OtherBar_Initialize(bar);
	end
end

function DAB_Initialize_ControlBoxes()
	for bar=1,DAB_NUMBER_OF_BARS do
		DAB_ControlBox_Initialize(bar);
	end
end

function DAB_Initialize_DefaultSettings()
	DAB_Settings[DAB_INDEX] = {
		AutoAttack = nil,
		Bar = {},
		Button = {},
		ButtonsUnlocked = true,
		CurrentBarInMainBar = nil,
		DisableTooltips = nil,
		DynamicKeybindingBar = nil,
		EventMacros = {},
		Floaters = {},
		FrameLocation = {},
		GhostBar = nil,
		HideDynamicKeybindings = nil,
		HideKeybindings = nil,
		MainBar = nil,
		ModifyCooldownByUIScale = true,
		OptionsScale = 100,
		OtherBar = {},
		OutOfManaColor = { r=.5, g=.5, b=1 },
		OutOfRangeColor = {r=1, g=.1, b=.1 },
		ShowCooldownCount = nil,
		Timeout = .5,
		UnusableColor = { r=.4, g=.4, b=.4 }
	};
	local bar;
	for bar=1,DAB_NUMBER_OF_BARS do
		DAB_Settings[DAB_INDEX].FrameLocation["DAB_ActionBar_"..bar] = { x=300, y=bar * -50 };
		DAB_Settings[DAB_INDEX].FrameLocation["DAB_ControlBox_"..bar] = { x=150, y=bar * -50 };
		DAB_Settings[DAB_INDEX].Bar[bar] = {
			alpha = 1,
			attachframe = nil,
			attachoffsetx = 0,
			attachoffsety = 0,
			attachpoint = "TOPLEFT",
			attachto = "TOPLEFT",
			background = {
				alpha = 0,
				borderalpha = 0,
				bordercolor = { r=1, g=1, b=0 },
				bordertexture = nil,
				color = { r=.7, g=0, b=0 },
				style = 1,
				texture = nil;
			},
			buttonborderalpha = 1,
			buttonborderpadding = 0,
			buttonbordercolor = { r=1, g=1, b=0 },
			collapse = nil,
			form = nil,
			formmethod = nil,
			friendlytarget = nil,
			hide = nil,
			hideempty = nil,
			hidelabel = true,
			hideonclick = nil,
			hostiletarget = nil,
			incombat = nil,
			keybindings = {},
			label = {
				alpha = 1,
				attachoffsetx = 0,
				attachoffsety = 0,
				attachpoint = "BOTTOMLEFT",
				attachto = "TOPLEFT",
				bgalpha = 1,
				bgcolor = { r=.7, g=0, b=0 },
				borderalpha = 1,
				bordercolor = { r=.7, g=.7, b=0 },
				color = { r=1, g=1, b=0 },
				text = DAB_TEXT.Bar..bar,
				textsize = 12
			},
			middleclick = bar,
			mouseoverbar = nil,
			notincombat = nil,
			numbuttons = 12,
			padding = 10,
			rightclick = bar,
			rows = 1,
			showonkeypress = nil,
			size = 35,
			target = nil,
			spacingh = 0,
			spacingv = 0,
			controlbox = {
				alpha = 1,
				attachframe = nil,
				attachoffsetx = 0,
				attachoffsety = 0,
				attachpoint = "TOPLEFT",
				attachto = "TOPLEFT",
				baronclick = true,
				bgalpha = 1,
				bgcolor = { r=.7, g=0, b=0 },
				borderalpha = 1,
				bordercolor = { r=.7, g=.7, b=0 },
				bottom = true,
				fontheight = 12,
				height = 26,
				hide = true,
				hideotherbars = nil,
				left = true,
				mouseovercolor = { r=1, g=1, b=0 },
				mouseovershowbar = nil,
				macroonclick = nil,
				recolor = true,
				right = true,
				text = "Cbox "..DAB_TEXT.Bar..bar,
				textcolor = { r=1, g=1, b=0 },
				textmouseovercolor = { r=0, g=0, b=0 },
				textrecolor = true,
				top = true,
				width = 100
			}
		};
	end
	for bar=11,14 do
		local barname = DAB_Get_OtherBar(bar);
		DAB_Settings[DAB_INDEX].FrameLocation["DAB_OtherBar_"..barname] = { x=300, y=bar * -50 };
		DAB_Settings[DAB_INDEX].OtherBar[bar] = {
			alpha = 1,
			attachframe = nil,
			attachoffsetx = 0,
			attachoffsety = 0,
			attachpoint = "TOPLEFT",
			attachto = "TOPLEFT",
			background = {
				alpha = 0,
				borderalpha = 0,
				bordercolor = { r=1, g=1, b=0 },
				bordertexture = nil,
				color = { r=.7, g=0, b=0 },
				style = 1,
				texture = nil;
			},
			hide = nil,
			hidelabel = nil,
			label = {
				alpha = 1,
				attachoffsetx = 0,
				attachoffsety = 0,
				attachpoint = "BOTTOMLEFT",
				attachto = "TOPLEFT",
				bgalpha = 1,
				bgcolor = { r=.7, g=0, b=0 },
				borderalpha = 1,
				bordercolor = { r=.7, g=.7, b=0 },
				color = { r=1, g=1, b=0 },
				text = DAB_TEXT[barname],
				textsize = 12
			},
			layout = 1,
			mouseoverbar = nil,
			padding = 10,
			size = 30,
			spacingh = 0,
			spacingv = 0
		};
	end
	bar = 1;
	local count = 0;
	for i=1,120 do
		DAB_Settings[DAB_INDEX].Button[i] = bar;
		count = count + 1;
		if (count == 12) then
			count = 0;
			bar = bar + 1;
		end
	end
end

function DAB_Initialize_Floaters()
	for i in DAB_Settings[DAB_INDEX].Floaters do
		DAB_Floater_Initialize(i);
	end
end

function DAB_Initialize_FormMenu()
	DAB_MENU_FORMS = {};
	DAB_MENU_FORMS[1] = { text = "", value = nil };
	local offset = 1;
	if (UnitClass("player") == DAB_TEXT.Druid or UnitClass("player") == DAB_TEXT.Rogue) then
		DAB_MENU_FORMS[2] = { text = DAB_TEXT.Humanoid, value = 0 };
		offset = 2;
	end
	for i=1, GetNumShapeshiftForms() do
		local _, name = GetShapeshiftFormInfo(i);
		DAB_MENU_FORMS[i + offset] = { text=name, value=i };
	end
end

function DAB_Initialize_FrameLocations()
	for frame, offset in DAB_Settings[DAB_INDEX].FrameLocation do
		getglobal(frame):ClearAllPoints();
		getglobal(frame):SetPoint("TOPLEFT", "UIParent", "TOPLEFT", offset.x, offset.y);
	end
end

function DAB_Initialize_FreeButtons()
	DAB_FREE_BUTTONS = {};
	for i=1, 120 do
		if (not DAB_Settings[DAB_INDEX].Button[i]) then
			DAB_FREE_BUTTONS[i] = true;
		end
	end
end

function DAB_Initialize_MiscOptions()
	DAB_Checkbox_Initialize(DAB_MiscOptions_UseOnDown, DAB_Settings[DAB_INDEX].useondown);
	DAB_Checkbox_Initialize(DAB_MiscOptions_RecolorButtonBorder, DAB_Settings[DAB_INDEX].RecolorBorder);
	DAB_Checkbox_Initialize(DAB_MiscOptions_ShowDefaultArt, DAB_Settings[DAB_INDEX].ShowDefaultArt);
	DAB_Checkbox_Initialize(DAB_MiscOptions_ShowXPBar, DAB_Settings[DAB_INDEX].ShowXPBar);
	DAB_Checkbox_Initialize(DAB_MiscOptions_DisableTooltips, DAB_Settings[DAB_INDEX].DisableTooltips);
	DAB_Checkbox_Initialize(DAB_MiscOptions_HideKeybindings, DAB_Settings[DAB_INDEX].HideKeybindings);
	DAB_Checkbox_Initialize(DAB_MiscOptions_ModifyCooldownScale, DAB_Settings[DAB_INDEX].ModifyCooldownByUIScale);
	DAB_Checkbox_Initialize(DAB_MiscOptions_HideDynamicKeybindings, DAB_Settings[DAB_INDEX].HideDynamicKeybindings);
	DAB_Checkbox_Initialize(DAB_MiscOptions_ShowCooldownCount, DAB_Settings[DAB_INDEX].ShowCooldownCount);
	DAB_Checkbox_Initialize(DAB_MiscOptions_OnlyClickedButtons, DAB_Settings[DAB_INDEX].OnlyClickedButtons);
	DAB_Checkbox_Initialize(DAB_MiscOptions_DoNotShowCooldownCountSec, DAB_Settings[DAB_INDEX].DoNotShowS);
	DAB_ColorPicker_Initialize(DAB_MiscOptions_OutOfRangeColor, DAB_Settings[DAB_INDEX].OutOfRangeColor);
	DAB_ColorPicker_Initialize(DAB_MiscOptions_OutOfManaColor, DAB_Settings[DAB_INDEX].OutOfManaColor);
	DAB_ColorPicker_Initialize(DAB_MiscOptions_UnusableColor, DAB_Settings[DAB_INDEX].UnusableColor);
	DAB_MenuControl_Initialize(DAB_MiscOptions_MainBar, DAB_Settings[DAB_INDEX].MainBar);
	DAB_MenuControl_Initialize(DAB_MiscOptions_GhostBar, DAB_Settings[DAB_INDEX].GhostBar);
	DAB_MenuControl_Initialize(DAB_MiscOptions_OptionsScale, DAB_Settings[DAB_INDEX].OptionsScale);
	DAB_Slider_Initialize(DAB_MiscOptions_Timeout, DAB_Settings[DAB_INDEX].Timeout);
	DAB_Slider_Initialize(DAB_MiscOptions_CCThreshold, DAB_Settings[DAB_INDEX].MinCooldownCount);
	DAB_Slider_Initialize(DAB_MiscOptions_BagOffsetX, DAB_Settings[DAB_INDEX].BagOffsetX);
	DAB_Slider_Initialize(DAB_MiscOptions_BagOffsetY, DAB_Settings[DAB_INDEX].BagOffsetY);
end

function DAB_Initialize_NewSettings()
	if (not DAB_Settings[DAB_INDEX].MinCooldownCount) then
		DAB_Settings[DAB_INDEX].MinCooldownCount = 0;
	end
	if (not DAB_Settings[DAB_INDEX]["INITIALIZED2.1"]) then
		for i,v in DAB_Settings[DAB_INDEX].Button do
			if (v == "floater") then
				if (not DAB_Settings[DAB_INDEX].Floaters[i]) then
					DAB_Settings[DAB_INDEX].Button[i] = nil;
				end
			end
		end
		for i=1,10 do
			DAB_Settings[DAB_INDEX].Bar[i].keybindings = {};
		end
		for i,v in DAB_Settings[DAB_INDEX].Floaters do
			DAB_Settings[DAB_INDEX].Floaters[i].keybinding = nil;
		end
		DAB_Settings[DAB_INDEX]["INITIALIZED2.1"] = true;
	end
	if (not DAB_Settings[DAB_INDEX]["INITIALIZED2.2"]) then
		DAB_Settings[DAB_INDEX].BagOffsetX = 0;
		DAB_Settings[DAB_INDEX].BagOffsetY = 0;
		DAB_Settings[DAB_INDEX]["INITIALIZED2.2"] = true;
	end
	if (not DAB_Settings[DAB_INDEX]["INITIALIZED2.3"]) then
		for i=1,10 do
			DAB_Settings[DAB_INDEX].Bar[i].AutoAttack = DAB_Settings[DAB_INDEX].AutoAttack;
			DAB_Settings[DAB_INDEX].Bar[i].ccfontsize = 16;
		end
		for i in DAB_Settings[DAB_INDEX].Floaters do
			DAB_Settings[DAB_INDEX].Floaters[i].AutoAttack = DAB_Settings[DAB_INDEX].AutoAttack;
		end
		DAB_Settings[DAB_INDEX].AutoAttack = nil;
		DAB_Settings[DAB_INDEX]["INITIALIZED2.3"] = true;
	end
end

function DAB_Initialize_NumButtonsOptions()
	local freebuttons = 120;
	for i=1, DAB_NUMBER_OF_BARS do
		freebuttons = freebuttons - DAB_Settings[DAB_INDEX].Bar[i].numbuttons;
		getglobal("DAB_NumButtonsOptions_Bar_"..i.."_Text"):SetText(DAB_Settings[DAB_INDEX].Bar[i].numbuttons);
	end
	for i in DAB_Settings[DAB_INDEX].Floaters do
		freebuttons = freebuttons - 1;
	end
	DAB_FloaterFreeButtons_Text:SetText(freebuttons);
	DAB_FreeButtons_Text:SetText(freebuttons);
end

function DAB_Initialize_SavedSettingsMenu()
	DAB_MENU_SAVEDSETTINGS = {};
	local i = 0;
	for index in DAB_Settings.SavedSettings do
		i = i + 1;
		DAB_MENU_SAVEDSETTINGS[i] = { text = index, value = index };
	end
end

function DAB_Initialize_XPBar()
	if (DAB_Settings[DAB_INDEX].ShowXPBar and (not DAB_Settings[DAB_INDEX].ShowDefaultArt)) then
		
	end
end