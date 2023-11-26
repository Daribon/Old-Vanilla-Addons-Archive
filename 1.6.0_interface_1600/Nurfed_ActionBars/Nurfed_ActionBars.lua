--[[ *** Nurfed Action Bars *** ]]--

Nurfed_ButtonsMin = 1;
Nurfed_ButtonsMax = 12;
Nurfed_ButtonsStep = 1;

Nurfed_ActionBarScaleMin = 0.25;
Nurfed_ActionBarScaleMax = 1;
Nurfed_ActionBarScaleStep = 0.05;

local lUpdateTimer = 0;
local ACTIONBAR_UPDATE_TIME = 0.5;

function Nurfed_ActionBarsOnLoad()
	Nurfed_ActionBar:RegisterForDrag("LeftButton");
	Nurfed_Bags:RegisterForDrag("LeftButton");
	Nurfed_MicroButtons:RegisterForDrag("LeftButton");
	Nurfed_ShapeShiftBar:RegisterForDrag("LeftButton");
	Nurfed_PetBar:RegisterForDrag("LeftButton");
	Nurfed_CastingBar:RegisterForDrag("LeftButton");
	Nurfed_BGScore:RegisterForDrag("LeftButton");
	this:RegisterEvent("VARIABLES_LOADED");
	RegisterForSave("Nurfed_ActionBars");
end

function Nurfed_ActionBarsOnEvent()
	if (event == "VARIABLES_LOADED") then
		if( not Nurfed_ActionBars ) then
			Nurfed_ActionBars = { };
			Nurfed_ActionBars.HotBar = 1;
			Nurfed_ActionBars.BottomBar = 1;
			Nurfed_ActionBars.SideBar = 1;
			Nurfed_ActionBars.SideBarLinked = 1;
			Nurfed_ActionBars.SideBar1 = 1;
			Nurfed_ActionBars.SideBar2 = 1;
			Nurfed_ActionBars.VerticalActionBar = 0;
			Nurfed_ActionBars.VerticalBags = 0;
			Nurfed_ActionBars.ActionBarScale = 1;
			Nurfed_ActionBars.BagScale = 1;
			Nurfed_ActionBars.ShowMicro = 0;
			Nurfed_ActionBars.SideBarScale = 1;
			Nurfed_ActionBars.VerticalPetBar = 0;
			Nurfed_ActionBars.VerticalStanceBar = 0;
		end
		if(NURFED_GENERAL == 1) then
			--Action Bar Options
			if (Nurfed_RetrieveSaved("enablehotbar") == nil) then
				Nurfed_ActionBars.HotBar = 1;
			else
				Nurfed_ActionBars.HotBar = Nurfed_RetrieveSaved("enablehotbar");
			end
			if (Nurfed_RetrieveSaved("verticalactionbar") == nil) then
				Nurfed_ActionBars.VerticalActionBar = 0;
			else
				Nurfed_ActionBars.VerticalActionBar = Nurfed_RetrieveSaved("verticalactionbar");
			end
			if (Nurfed_RetrieveSaved("verticalbags") == nil) then
				Nurfed_ActionBars.VerticalBags = 0;
			else
				Nurfed_ActionBars.VerticalBags = Nurfed_RetrieveSaved("verticalbags");
			end
			if (Nurfed_RetrieveSaved("actionbarscale") == nil) then
				Nurfed_ActionBars.ActionBarScale = 1;
			else
				Nurfed_ActionBars.ActionBarScale = Nurfed_RetrieveSaved("actionbarscale");
			end
			if (Nurfed_RetrieveSaved("bagscale") == nil) then
				Nurfed_ActionBars.BagScale = 1;
			else
				Nurfed_ActionBars.BagScale = Nurfed_RetrieveSaved("bagscale");
			end
			if (Nurfed_RetrieveSaved("showmicro") == nil) then
				Nurfed_ActionBars.ShowMicro = 0;
			else
				Nurfed_ActionBars.ShowMicro = Nurfed_RetrieveSaved("showmicro");
			end
			if (Nurfed_RetrieveSaved("verticalpetbar") == nil) then
				Nurfed_ActionBars.VerticalPetBar = 0;
			else
				Nurfed_ActionBars.VerticalPetBar = Nurfed_RetrieveSaved("verticalpetbar");
			end
			if (Nurfed_RetrieveSaved("verticalstancebar") == nil) then
				Nurfed_ActionBars.VerticalStanceBar = 0;
			else
				Nurfed_ActionBars.VerticalStanceBar = Nurfed_RetrieveSaved("verticalstancebar");
			end

			--BottomBar Options
			if (Nurfed_RetrieveSaved("enablebottombar") == nil) then
				Nurfed_ActionBars.BottomBar = 1;
			else
				Nurfed_ActionBars.BottomBar = Nurfed_RetrieveSaved("enablebottombar");
			end

			--SideBar Options
			if (Nurfed_RetrieveSaved("enablesidebar") == nil) then
				Nurfed_ActionBars.SideBar = 1;
			else
				Nurfed_ActionBars.SideBar = Nurfed_RetrieveSaved("enablesidebar");
			end
			if (Nurfed_RetrieveSaved("enablesidebarlinked") == nil) then
				Nurfed_ActionBars.SideBarLinked = 1;
			else
				Nurfed_ActionBars.SideBarLinked = Nurfed_RetrieveSaved("enablesidebarlinked");
			end
			if (Nurfed_RetrieveSaved("enablesidebar1") == nil) then
				Nurfed_ActionBars.SideBar1 = 1;
			else
				Nurfed_ActionBars.SideBar1 = Nurfed_RetrieveSaved("enablesidebar1");
			end
			if (Nurfed_RetrieveSaved("enablesidebar2") == nil) then
				Nurfed_ActionBars.SideBar2 = 1;
			else
				Nurfed_ActionBars.SideBar2 = Nurfed_RetrieveSaved("enablesidebar2");
			end
			if (Nurfed_RetrieveSaved("sidebarscale") == nil) then
				Nurfed_ActionBars.SideBarScale = 1;
			else
				Nurfed_ActionBars.SideBarScale = Nurfed_RetrieveSaved("sidebarscale");
			end

			Nurfed_RegisterOption(150, "category", nil, nil, nil, "Action Bar", "Settings for the Action Bars.");
			Nurfed_RegisterOption(151, "header", nil, nil, nil, "ActionBar Options", "Options relating to the Action Bar.");
			Nurfed_RegisterOption(152, "check", Nurfed_ActionBars.HotBar, "enablehotbar", Nurfed_UpdateActionBars, "Enable HotBar", "Toggle between the Nurfed\nand default action bars.");
			Nurfed_RegisterOption(153, "check", Nurfed_ActionBars.BottomBar, "enablebottombar", Nurfed_UpdateActionBars, "Enable BottomBar", "Enable BottomBar.");
			Nurfed_RegisterOption(154, "check", Nurfed_ActionBars.VerticalActionBar, "verticalactionbar", Nurfed_UpdateActionBars, "Vertical Main Bar", "Vertical Main Bar.");
			Nurfed_RegisterOption(155, "slider", Nurfed_ActionBars.ActionBarScale, "actionbarscale", Nurfed_UpdateActionBars, "Action Bar Scaling", "Scaling of the Action Bar", Nurfed_ActionBarScaleMin, Nurfed_ActionBarScaleMax, Nurfed_ActionBarScaleStep, "");
			Nurfed_RegisterOption(156, "check", Nurfed_ActionBars.ShowMicro, "showmicro", Nurfed_UpdateActionBars, "Show Menu Buttons", "Show Menu Buttons.");
			Nurfed_RegisterOption(157, "check", Nurfed_ActionBars.VerticalPetBar, "verticalpetbar", Nurfed_UpdateActionBars, "Vertical Pet Bar", "Vertical Pet Bar.");
			Nurfed_RegisterOption(158, "check", Nurfed_ActionBars.VerticalStanceBar, "verticalstancebar", Nurfed_UpdateActionBars, "Vertical Stance Bar", "Vertical Stance Bar.");
			Nurfed_RegisterOption(161, "header", nil, nil, nil, "SideBar Options", "Options relating to the SideBar.");
			Nurfed_RegisterOption(162, "check", Nurfed_ActionBars.SideBar, "enablesidebar", Nurfed_UpdateActionBars, "Enable SideBar", "Enable SideBar and Options.");
			Nurfed_RegisterOption(163, "check", Nurfed_ActionBars.SideBarLinked, "enablesidebarlinked", Nurfed_UpdateActionBars, "Link SideBars", "Link SideBars Together.");
			Nurfed_RegisterOption(164, "check", Nurfed_ActionBars.SideBar1, "enablesidebar1", Nurfed_UpdateActionBars, "Enable SideBar 1", "Enable SideBar 1.");
			Nurfed_RegisterOption(165, "check", Nurfed_ActionBars.SideBar2, "enablesidebar2", Nurfed_UpdateActionBars, "Enable SideBar 2", "Enable SideBar 2.");
			Nurfed_RegisterOption(166, "slider", Nurfed_ActionBars.SideBarScale, "sidebarscale", Nurfed_UpdateActionBars, "Side Bar Scaling", "Scaling of the Side Bar", Nurfed_ActionBarScaleMin, Nurfed_ActionBarScaleMax, Nurfed_ActionBarScaleStep, "");
			Nurfed_RegisterOption(171, "header", nil, nil, nil, "Bag Options", "Options relating to the Bags.");
			Nurfed_RegisterOption(172, "check", Nurfed_ActionBars.VerticalBags, "verticalbags", Nurfed_UpdateActionBars, "Vertical Bags", "Vertical Bags.");
			Nurfed_RegisterOption(173, "slider", Nurfed_ActionBars.BagScale, "bagscale", Nurfed_UpdateActionBars, "Bag Bar Scaling", "Scaling of the Bag Bar", Nurfed_ActionBarScaleMin, Nurfed_ActionBarScaleMax, Nurfed_ActionBarScaleStep, "");
		else
			Nurfed_ActionBars.HotBar = 1;
			Nurfed_ActionBars.BottomBar = 1;
			Nurfed_ActionBars.SideBar = 1;
			Nurfed_ActionBars.SideBarLinked = 1;
			Nurfed_ActionBars.SideBar1 = 1;
			Nurfed_ActionBars.SideBar2 = 1;
			Nurfed_ActionBars.VerticalActionBar = 0;
			Nurfed_ActionBars.VerticalBags = 0;
			Nurfed_ActionBars.ActionBarScale = 1;
			Nurfed_ActionBars.BagScale = 1;
			Nurfed_ActionBars.ShowMicro = 1;
			Nurfed_ActionBars.SideBarScale = 1;
			Nurfed_ActionBars.VerticalPetBar = 0;
			Nurfed_ActionBars.VerticalStanceBar = 0;
		end
	end
end

--Shrink the gaps in the default Action Bars
function Nurfed_SetActionBarsGap(bar, gap, actionbarscale)
	MultiBarLeft:SetPoint("TOPRIGHT", "MultiBarRight", "TOPLEFT", -2, 0);

	local n, buttonsize, texturesize;
	if ( bar == "ShapeshiftButton" or bar == "PetActionButton" ) then
		n=10;
		buttonsize = 30;
		texturesize = 58;
	else
		if ( bar == "SideBarButton" ) then
			n=24;
		else
			n=12;
		end
		buttonsize = 37;
		texturesize = 64;
	end

	if ( (Nurfed_ActionBars.VerticalActionBar == 1) and (Nurfed_ActionBars.HotBar == 1) and (bar == "ActionButton") ) then
		Nurfed_ActionBar:SetWidth(95*actionbarscale);
		Nurfed_ActionBar:SetHeight(485*actionbarscale);
		BottomBar:SetWidth(41*actionbarscale);
		BottomBar:SetHeight(974*actionbarscale);
		ActionButton1:ClearAllPoints();
		ActionButton1:SetPoint("TOPLEFT", "Nurfed_ActionBar", "TOPLEFT", 10*actionbarscale, -10*actionbarscale);
		BottomBar:SetPoint("BOTTOMLEFT", "ActionButton1", "BOTTOMRIGHT", -6, 0);
		MultiBarBottomLeft:SetPoint("LEFT", "ActionButton1", "RIGHT", gap, 0);
	elseif ( (Nurfed_ActionBars.VerticalActionBar == 0) and (Nurfed_ActionBars.HotBar == 1) and (bar == "ActionButton") ) then
		Nurfed_ActionBar:SetWidth(485*actionbarscale);
		Nurfed_ActionBar:SetHeight(95*actionbarscale);
		BottomBar:SetWidth(974*actionbarscale);
		BottomBar:SetHeight(41*actionbarscale);
		ActionButton1:ClearAllPoints();
		ActionButton1:SetPoint("BOTTOMLEFT", "Nurfed_ActionBar", "BOTTOMLEFT", 10*actionbarscale, 10*actionbarscale);
		BottomBar:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", -8, gap);
		MultiBarBottomLeft:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", 0, gap);
	end

	if ( bar == "ShapeshiftButton" ) then
		if ( Nurfed_ActionBars.VerticalStanceBar == 0 ) then
			Nurfed_ShapeShiftBar:SetWidth(250*actionbarscale);
			Nurfed_ShapeShiftBar:SetHeight(50*actionbarscale);
			ShapeshiftButton1:ClearAllPoints();
			ShapeshiftButton1:SetPoint("BOTTOMLEFT", "Nurfed_ShapeShiftBar", "BOTTOMLEFT", 10*actionbarscale, 10*actionbarscale);
		else
			Nurfed_ShapeShiftBar:SetWidth(50*actionbarscale);
			Nurfed_ShapeShiftBar:SetHeight(250*actionbarscale);
			ShapeshiftButton1:ClearAllPoints();
			ShapeshiftButton1:SetPoint("TOPLEFT", "Nurfed_ShapeShiftBar", "TOPLEFT", 10*actionbarscale, -10*actionbarscale);
		end
	end

	if ( bar == "PetActionButton" ) then
		if ( Nurfed_ActionBars.VerticalPetBar == 0 ) then
			Nurfed_PetBar:SetWidth(340*actionbarscale);
			Nurfed_PetBar:SetHeight(50*actionbarscale);
			PetActionButton1:ClearAllPoints();
			PetActionButton1:SetPoint("BOTTOMLEFT", "Nurfed_PetBar", "BOTTOMLEFT", 10*actionbarscale, 10*actionbarscale);
		else
			Nurfed_PetBar:SetWidth(50*actionbarscale);
			Nurfed_PetBar:SetHeight(340*actionbarscale);
			PetActionButton1:ClearAllPoints();
			PetActionButton1:SetPoint("TOPLEFT", "Nurfed_PetBar", "TOPLEFT", 10*actionbarscale, -10*actionbarscale);
		end
	end

	for i=1, n do
		-- Get current buttons
		local button = getglobal(bar..i);
		local buttonTexture = getglobal(bar..i.."NormalTexture");
		local buttonHotKey = getglobal(bar..i.."HotKey");
		local buttonCount = getglobal(bar..i.."Count");
		local buttonName = getglobal(bar..i.."Name");

		-- Change horizontal bars
		button:SetWidth(buttonsize*actionbarscale);
		button:SetHeight(buttonsize*actionbarscale);
		if ( bar ~= "PetActionButton" ) then
			buttonTexture:SetWidth(texturesize*actionbarscale);
			buttonTexture:SetHeight(texturesize*actionbarscale);
		else
			getglobal(bar..i.."NormalTexture2"):SetWidth(texturesize*actionbarscale);
			getglobal(bar..i.."NormalTexture2"):SetHeight(texturesize*actionbarscale);
			getglobal(bar..i.."AutoCastable"):SetWidth(texturesize*actionbarscale);
			getglobal(bar..i.."AutoCastable"):SetHeight(texturesize*actionbarscale);
		end
		buttonHotKey:SetWidth(32*actionbarscale);
		buttonHotKey:SetHeight(10*actionbarscale);
		buttonHotKey:SetTextHeight(12*actionbarscale);
		buttonHotKey:SetPoint("TOPLEFT", bar..i, "TOPLEFT", 2*actionbarscale, -2*actionbarscale);
		buttonCount:SetTextHeight(14*actionbarscale);
		buttonCount:SetPoint("BOTTOMRIGHT", bar..i, "BOTTOMRIGHT", -2*actionbarscale, 2*actionbarscale);
		buttonName:SetWidth(36*actionbarscale);
		buttonName:SetHeight(10*actionbarscale);
		buttonName:SetTextHeight(10*actionbarscale);
		buttonName:SetPoint("BOTTOMLEFT", bar..i, "BOTTOMLEFT", 0, 2*actionbarscale);

		-- Decrement the ID
		local lastID = i - 1;
		if( lastID > 0 and bar ~= "SideBarButton" ) then
			-- Get the last button
			local lastButton1 = bar..lastID;

			button:ClearAllPoints();
			if ( (  (Nurfed_ActionBars.VerticalActionBar == 1 and (bar =="ActionButton" or bar =="BottomBarButton" or bar =="BonusActionButton") ) or
				(Nurfed_ActionBars.VerticalPetBar == 1 and bar == "PetActionButton") or
				(Nurfed_ActionBars.VerticalStanceBar == 1 and bar == "ShapeshiftButton") ) and
				(Nurfed_ActionBars.HotBar == 1) ) then
				button:SetPoint("TOP", lastButton1, "BOTTOM", 0, -gap);
			else
				button:SetPoint("LEFT", lastButton1, "RIGHT", gap, 0);
			end
		end

		if ( bar == "SideBarButton" ) then
			local buttonsMax;
			local buttons1 = Nurfed_SideBarState.Buttons1;
			local buttons2 = Nurfed_SideBarState.Buttons2;
			if( buttons1 > buttons2 ) then
				buttonsMax = buttons1;
			else
				buttonsMax = buttons2;
			end
			SideBar:SetHeight( (buttonsMax * 38)*actionbarscale + 30);
			SideBar:SetWidth(98*actionbarscale);
			SideBar1:SetHeight( (buttons2 * 38)*actionbarscale - 4);
			SideBar1:SetWidth(38*actionbarscale);
			SideBar1:SetPoint("TOPLEFT", "SideBar", "TOPLEFT", 9*actionbarscale, -8*actionbarscale);
			SideBar2:SetHeight( (buttons2 * 38)*actionbarscale - 4);
			SideBar2:SetWidth(38*actionbarscale);
			SideBar2:SetPoint("TOPLEFT", "SideBar1", "TOPRIGHT", 0, 0);
		end
	end
end

--Shrink the gaps in the bags
function Nurfed_SetBagGap(gap, bagscale)
	getglobal("MainMenuBarBackpackButton"):SetWidth(37*bagscale);
	getglobal("MainMenuBarBackpackButton"):SetHeight(37*bagscale);
	getglobal("MainMenuBarBackpackButtonNormalTexture"):SetWidth(64*bagscale);
	getglobal("MainMenuBarBackpackButtonNormalTexture"):SetHeight(64*bagscale);
	MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", "Nurfed_Bags", "BOTTOMRIGHT", -9*bagscale, 10*bagscale);
	for i=0, 3 do
		-- Get current button
		local button = getglobal("CharacterBag"..i.."Slot");
		local buttonx = getglobal("CharacterBag"..i.."SlotNormalTexture");
		-- Decrement the ID
		local lastID = i - 1;
		-- Get the last button
		local lastBag = "CharacterBag"..lastID.."Slot";
		-- Change horizontal offset
		button:ClearAllPoints();
		button:SetWidth(37*bagscale);
		button:SetHeight(37*bagscale);
		buttonx:SetWidth(64*bagscale);
		buttonx:SetHeight(64*bagscale);
		if (i == 0) then
			if ( (Nurfed_ActionBars.VerticalBags == 1) and (Nurfed_ActionBars.HotBar == 1) ) then
				Nurfed_Bags:SetHeight(210*bagscale);
				Nurfed_Bags:SetWidth(60*bagscale);
				button:SetPoint("BOTTOM", "MainMenuBarBackpackButton", "TOP",0, gap);
			else
				Nurfed_Bags:SetHeight(60*bagscale);
				Nurfed_Bags:SetWidth(210*bagscale);
				button:SetPoint("RIGHT", "MainMenuBarBackpackButton", "LEFT",-gap, 0);
			end
		else
			if ( (Nurfed_ActionBars.VerticalBags == 1) and (Nurfed_ActionBars.HotBar == 1) ) then
				button:SetPoint("BOTTOM", lastBag, "TOP", 0, gap);
			else
				button:SetPoint("RIGHT", lastBag, "LEFT", -gap, 0);
			end
		end
	end
end
	
function Nurfed_UpdateActionBars(init)
	if (init == nil) then
		init = 0;
	end
	if (Nurfed_RetrieveOption ~= nil) then
		if (Nurfed_RetrieveOption(152) ~= nil) then
			Nurfed_ActionBars.HotBar = Nurfed_RetrieveOption(152)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(153) ~= nil) then
			Nurfed_ActionBars.BottomBar = Nurfed_RetrieveOption(153)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(154) ~= nil) then
			Nurfed_ActionBars.VerticalActionBar = Nurfed_RetrieveOption(154)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(155) ~= nil) then
			Nurfed_ActionBars.ActionBarScale = Nurfed_RetrieveOption(155)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(156) ~= nil) then
			Nurfed_ActionBars.ShowMicro = Nurfed_RetrieveOption(156)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(157) ~= nil) then
			Nurfed_ActionBars.VerticalPetBar = Nurfed_RetrieveOption(157)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(158) ~= nil) then
			Nurfed_ActionBars.VerticalStanceBar = Nurfed_RetrieveOption(158)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(162) ~= nil) then
			Nurfed_ActionBars.SideBar = Nurfed_RetrieveOption(162)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(163) ~= nil) then
			Nurfed_ActionBars.SideBarLinked = Nurfed_RetrieveOption(163)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(164) ~= nil) then
			Nurfed_ActionBars.SideBar1 = Nurfed_RetrieveOption(164)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(165) ~= nil) then
			Nurfed_ActionBars.SideBar2 = Nurfed_RetrieveOption(165)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(166) ~= nil) then
			Nurfed_ActionBars.SideBarScale = Nurfed_RetrieveOption(166)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(172) ~= nil) then
			Nurfed_ActionBars.VerticalBags = Nurfed_RetrieveOption(172)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(173) ~= nil) then
			Nurfed_ActionBars.BagScale = Nurfed_RetrieveOption(173)[NURFED_VALUE];
		end

	end
	if (Nurfed_ActionBars.HotBar == 1) then
		BottomBar:ClearAllPoints();
		BottomBar:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", -9, 4);
		MainMenuBarBackpackButton:ClearAllPoints();
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", "Nurfed_Bags", "BOTTOMRIGHT", -10, 10);
		ActionButton1:ClearAllPoints();
		ActionButton1:SetPoint("BOTTOMLEFT", "Nurfed_ActionBar", "BOTTOMLEFT", 10, 10);
		ShapeshiftButton1:ClearAllPoints();
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", "Nurfed_ShapeShiftBar", "BOTTOMLEFT", 10, 10);
		PetActionButton1:ClearAllPoints();
		PetActionButton1:SetPoint("BOTTOMLEFT", "Nurfed_PetBar", "BOTTOMLEFT", 10, 10);
		CastingBarFrame:ClearAllPoints();
		CastingBarFrame:SetPoint("BOTTOM", "Nurfed_CastingBar", "BOTTOM", 0, 5);
		WorldStateAlwaysUpFrame:ClearAllPoints();
		WorldStateAlwaysUpFrame:SetPoint("BOTTOMLEFT", "Nurfed_BGScore", "BOTTOMLEFT", 10, 10);

		Nurfed_SetActionBarsGap("ActionButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("BonusActionButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("BottomBarButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("MultiBarBottomLeftButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("MultiBarBottomRightButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("PetActionButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("ShapeshiftButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetBagGap(2, Nurfed_ActionBars.BagScale);
		Nurfed_UpdateMicro();
		Nurfed_ActionBarGraphics();
	else
		ActionButton1:ClearAllPoints();
		ActionButton1:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4);
		MainMenuBar:ClearAllPoints();
		MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 0);
		BottomBar:ClearAllPoints();
		BottomBar:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 0, 0);
		MainMenuBarBackpackButton:ClearAllPoints();
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -6, 2);
		CharacterMicroButton:ClearAllPoints();
		CharacterMicroButton:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 546, 2);

		Nurfed_SetActionBarsGap("ActionButton", 6, 1);
		Nurfed_SetActionBarsGap("BonusActionButton", 6, 1);
		Nurfed_SetActionBarsGap("BottomBarButton", 6, 1);
		Nurfed_SetActionBarsGap("MultiBarBottomLeftButton", 6, 1);
		Nurfed_SetActionBarsGap("MultiBarBottomRightButton", 6, 1);
		Nurfed_SetActionBarsGap("PetActionButton", 6, 1);
		Nurfed_SetActionBarsGap("ShapeshiftButton", 6, 1);
		Nurfed_SetBagGap(6, 1);
		if( BottomBar:IsVisible() ) then
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "BottomBar", "TOPLEFT", 30, -3);
		else
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
		end
		Nurfed_UpdateMicro();
		Nurfed_ActionBarGraphics();
	end

	if( Nurfed_ActionBars.BottomBar == 1 and not BottomBar:IsVisible() ) then
		BottomBar:Show();
	elseif( Nurfed_ActionBars.BottomBar == 0 and BottomBar:IsVisible() ) then
		BottomBar:Hide();
	end

	if( Nurfed_ActionBars.SideBar == 1) then
		SideBar:Show();
		if( NURFED_GENERAL == 1)then
			Nurfed_Option163:Enable();
			Nurfed_Option163Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
			Nurfed_Option164:Enable();
			Nurfed_Option164Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
			Nurfed_Option165:Enable();
			Nurfed_Option165Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end
		Nurfed_SetActionBarsGap("SideBarButton", 2, Nurfed_ActionBars.SideBarScale);
	elseif( Nurfed_ActionBars.SideBar == 0) then
		SideBar:Hide();
		if( NURFED_GENERAL == 1)then
			Nurfed_Option163:Disable();
			Nurfed_Option163Text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
			Nurfed_Option164:Disable();
			Nurfed_Option164Text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
			Nurfed_Option165:Disable();
			Nurfed_Option165Text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
	end

	if( Nurfed_ActionBars.SideBarLinked == 1 )then
		local previous = Nurfed_SideBarState.Unlinked;
		Nurfed_SideBarState.Unlinked = nil;
		SideBar_SetState(previous);
	else
		local previous = Nurfed_SideBarState.Unlinked;
		Nurfed_SideBarState.Unlinked = 1;
		SideBar_SetState(previous);
	end

	if( (Nurfed_ActionBars.SideBar == 1 and Nurfed_ActionBars.SideBar1 == 1) and not SideBar1:IsVisible() )then
		SideBar1:Show();
	elseif( (Nurfed_ActionBars.SideBar == 0 or Nurfed_ActionBars.SideBar1 == 0) and SideBar1:IsVisible() )then
		SideBar1:Hide();
	end

	if( (Nurfed_ActionBars.SideBar == 1 and Nurfed_ActionBars.SideBar2 == 1) and not SideBar2:IsVisible() )then
		SideBar2:Show();
	elseif( (Nurfed_ActionBars.SideBar == 0 or Nurfed_ActionBars.SideBar2 == 0) and SideBar2:IsVisible() )then
		SideBar2:Hide();
	end
	
	if ( (Nurfed_ActionBars.VerticalBags == 1) and (Nurfed_ActionBars.HotBar == 1) ) then
		Nurfed_SetBagGap(2, Nurfed_ActionBars.BagScale);
	else
		if (Nurfed_ActionBars.HotBar == 1) then
			Nurfed_SetBagGap(2, Nurfed_ActionBars.BagScale);
		else
			Nurfed_SetBagGap(6, 1);
		end
	end
	
	if ( (Nurfed_ActionBars.VerticalActionBar == 1) or (Nurfed_ActionBars.HotBar == 1) ) then
		Nurfed_SetActionBarsGap("ActionButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("BonusActionButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("BottomBarButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("MultiBarBottomLeftButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("MultiBarBottomRightButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("PetActionButton", 2, Nurfed_ActionBars.ActionBarScale);
		Nurfed_SetActionBarsGap("ShapeshiftButton", 2, Nurfed_ActionBars.ActionBarScale);
	end

end

function Nurfed_UpdateMicro()
	if ( Nurfed_ActionBars.ShowMicro == 0 and Nurfed_ActionBars.HotBar == 1 ) then
		CharacterMicroButton:ClearAllPoints();
		CharacterMicroButton:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -50);
		CharacterMicroButton:Hide();
		SpellbookMicroButton:Hide();
		TalentMicroButton:Hide();
		QuestLogMicroButton:Hide();
		SocialsMicroButton:Hide();
		WorldMapMicroButton:Hide();
		MainMenuMicroButton:Hide();
		HelpMicroButton:Hide();
	else
		CharacterMicroButton:ClearAllPoints();
		CharacterMicroButton:SetPoint("BOTTOMLEFT", "Nurfed_MicroButtons", "BOTTOMLEFT", 10, 10);
		CharacterMicroButton:Show();
		SpellbookMicroButton:Show();
		TalentMicroButton:Show();
		QuestLogMicroButton:Show();
		SocialsMicroButton:Show();
		WorldMapMicroButton:Show();
		MainMenuMicroButton:Show();
		HelpMicroButton:Show();
	end
end

function Nurfed_ActionBarGraphics()
	if ( Nurfed_ActionBars.HotBar == 1 ) then
		BonusActionBarFrame:SetWidth(1);
		ActionBarUpButton:Hide();
		ActionBarDownButton:Hide();
		MainMenuBarTexture0:Hide();
		MainMenuBarTexture1:Hide();
		MainMenuBarTexture2:Hide();
		MainMenuBarTexture3:Hide();
		MainMenuBarLeftEndCap:Hide();
		MainMenuBarRightEndCap:Hide();
		MainMenuBarOverlayFrame:Hide();
		MainMenuBarPerformanceBarFrame:Hide();
		MainMenuExpBar:ClearAllPoints();
		MainMenuExpBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -50);
		ExhaustionTick:Hide();
		BonusActionBarTexture0:ClearAllPoints();
		BonusActionBarTexture0:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -50);
		ShapeshiftBarLeft:Hide();
		ShapeshiftBarMiddle:Hide();
		ShapeshiftBarRight:Hide();
		SlidingActionBarTexture0:ClearAllPoints();
		SlidingActionBarTexture0:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -50);
		if (PetHasActionBar()) then
			PetActionBar_Update();
			UnlockPetActionBar();
			HidePetActionBar();
			ShowPetActionBar();
			LockPetActionBar();
		end
		MainMenuBarPageNumber:Hide();
		ShapeshiftBarFrame:ClearAllPoints();
		ShapeshiftBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -50);
		MainMenuBar:ClearAllPoints();
		MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -150);
	else
		BonusActionBarFrame:SetWidth(505);
		ActionBarUpButton:Show();
		ActionBarDownButton:Show();
		MainMenuBarTexture0:Show();
		MainMenuBarTexture1:Show();
		MainMenuBarTexture2:Show();
		MainMenuBarTexture3:Show();
		MainMenuBarLeftEndCap:Show();
		MainMenuBarRightEndCap:Show();
		MainMenuBarOverlayFrame:Show();
		MainMenuBarPerformanceBarFrame:Show();
		MainMenuExpBar:ClearAllPoints();
		MainMenuExpBar:SetPoint("TOP", "MainMenuBar", "TOP", 0, 0);
		ExhaustionTick_Update();
		BonusActionBarTexture0:ClearAllPoints();
		BonusActionBarTexture0:SetPoint("TOPLEFT", "BonusActionBarFrame", "TOPLEFT", 0, 0);
		ShapeshiftBarLeft:Show();
		ShapeshiftBarMiddle:Show();
		ShapeshiftBarRight:Show();
		SlidingActionBarTexture0:ClearAllPoints();
		SlidingActionBarTexture0:SetPoint("TOPLEFT", "PetActionBarFrame", "TOPLEFT", 0, 0);
		if (PetHasActionBar()) then	
			PetActionBar_Update();
			UnlockPetActionBar();
			HidePetActionBar();
			ShowPetActionBar();
			LockPetActionBar();
		end

	end
end

local originalMultiActionBar_Update = MultiActionBar_Update;
function MultiActionBar_Update ()
	-- Hooking the default multibar update function so it can run our HotBar update function and keep things tidy
	originalMultiActionBar_Update();
	Nurfed_UpdateActionBars();
end

local originalShowBonusActionBar = ShowBonusActionBar;
function ShowBonusActionBar()
	originalShowBonusActionBar();
	BonusActionButton1:ClearAllPoints();
	BonusActionButton1:SetPoint("TOPLEFT", "ActionButton1", "TOPLEFT", 0, 0);
	for i=1, 12 do
		getglobal("ActionButton"..i):Hide();
	end
end

local originalHideBonusActionBar = HideBonusActionBar;
function HideBonusActionBar()
	originalHideBonusActionBar();
	for i=1, 12 do
		getglobal("BonusActionButton"..i):Hide();
		getglobal("ActionButton"..i):Show();
	end
end

function ActionBar_OnUpdate(elapsed)
	lUpdateTimer = lUpdateTimer + elapsed;
	if( lUpdateTimer >= ACTIONBAR_UPDATE_TIME ) then
		ActionBar_HandleWidgets();
	end
end

function ActionBar_MouseIsOver(frame)
	local x, y = GetCursorPosition();
	
	if( not frame ) then
		return nil;
	end
	
	x = x / frame:GetScale();
	y = y / frame:GetScale();

	local left = frame:GetLeft();
	local right = frame:GetRight();
	local top = frame:GetTop();
	local bottom = frame:GetBottom();
	
	if( not left or not right or not top or not bottom ) then
		return nil;
	end
	
	if( (x > left and x < right) and (y > bottom and y < top) ) then
		return 1;
	else
		return nil;
	end
end

function Nurfed_ActionBar_ShowWidgets(framename)
	local frame = getglobal(framename);
	local framebg = getglobal(framename.."Backdrop");
	frame:EnableMouse(1);
	framebg:Show();
end

function Nurfed_ActionBar_HideWidgets()
	Nurfed_ActionBar:EnableMouse(nil);
	Nurfed_ActionBarBackdrop:Hide();
	Nurfed_Bags:EnableMouse(nil);
	Nurfed_BagsBackdrop:Hide();
	Nurfed_MicroButtons:EnableMouse(nil);
	Nurfed_MicroButtonsBackdrop:Hide();
	Nurfed_ShapeShiftBar:EnableMouse(nil);
	Nurfed_ShapeShiftBarBackdrop:Hide();
	Nurfed_PetBar:EnableMouse(nil);
	Nurfed_PetBarBackdrop:Hide();
	Nurfed_CastingBar:EnableMouse(nil);
	Nurfed_CastingBarBackdrop:Hide();
	Nurfed_BGScore:EnableMouse(nil);
	Nurfed_BGScore:Hide();
end

function ActionBar_HandleWidgets()
	if ( NURFED_LOCKALL == 0 ) then
		if( (ActionBar_MouseIsOver(Nurfed_ActionBar) or Nurfed_ActionBar.BeingDragged) ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_ActionBar");
		elseif( (ActionBar_MouseIsOver(Nurfed_Bags) or Nurfed_Bags.BeingDragged) ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_Bags");
		elseif( (ActionBar_MouseIsOver(Nurfed_MicroButtons) or Nurfed_MicroButtons.BeingDragged) and Nurfed_ActionBars.ShowMicro == 1 ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_MicroButtons");
		elseif( (ActionBar_MouseIsOver(Nurfed_ShapeShiftBar) and ShapeshiftButton1:IsVisible() ) or Nurfed_ShapeShiftBar.BeingDragged ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_ShapeShiftBar");
		elseif( (ActionBar_MouseIsOver(Nurfed_PetBar) and PetActionButton1:IsVisible() ) or Nurfed_PetBar.BeingDragged ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_PetBar");
		elseif( (ActionBar_MouseIsOver(Nurfed_CastingBar) or Nurfed_CastingBar.BeingDragged) ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_CastingBar");
		elseif( (ActionBar_MouseIsOver(Nurfed_BGScore) or Nurfed_BGScore.BeingDragged) ) then
			Nurfed_ActionBar_ShowWidgets("Nurfed_BGScore");
		else
			Nurfed_ActionBar_HideWidgets();
		end
	else
		Nurfed_ActionBar_HideWidgets();
	end
end

function ActionBar_OnDragStart(frame)
	if( NURFED_LOCKALL == 1 ) then
		return;
	end
	frame.BeingDragged = 1;
	ActionBar_HandleWidgets();
	frame:StartMoving();
end

function ActionBar_OnDragStop(frame)
	frame:StopMovingOrSizing();
	frame.BeingDragged = nil;
	ActionBar_HandleWidgets();
end

function ActionButton_SetTooltip()
	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	else
		if ( this:GetParent() == MultiBarBottomRight or this:GetParent() == MultiBarRight or this:GetParent() == MultiBarLeft ) then
			GameTooltip:SetOwner(this, "ANCHOR_LEFT");
		else
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		end
		
	end
	
	if ( GameTooltip:SetAction(ActionButton_GetPagedID(this)) ) then
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		this.updateTooltip = nil;
	end
end
