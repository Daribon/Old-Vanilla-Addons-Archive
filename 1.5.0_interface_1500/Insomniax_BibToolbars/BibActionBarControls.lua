function UpdateBibGreenButtons()
	local PlayerString = UnitName("player");
	if(GreenButtonsDisabled and GreenButtonsDisabled[PlayerString]) then
		for i = 1, BIB_ACTION_BAR_COUNT do
			getglobal("BibActionBar"..i.."DragButton"):Hide();
		end
		BibShapeshiftActionBarDragButton:Hide();
		BibPetActionBarDragButton:Hide();
		BibMicroBarDragButton:Hide();
		BibMenuDragButton:Hide();
		BibBagButtonsBarDragButton:Hide();
	else
		for i = 1, BIB_ACTION_BAR_COUNT do
			getglobal("BibActionBar"..i.."DragButton"):Show();
		end
		BibShapeshiftActionBarDragButton:Show();
		BibPetActionBarDragButton:Show();
		BibMicroBarDragButton:Show();
		BibMenuDragButton:Show();
		BibBagButtonsBarDragButton:Show();
	end
end

-- LedMirage 4/18/2005
function BibGreenButtons_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(GreenButtonsDisabled[PlayerString]) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Show Green Drag Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Drag Tabs", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently hiding all drag tabs", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to show all drag tabs", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("The Drag Tabs allow you to move the bar", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("or menu they are attached to by simply", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("left-clicking and dragging them.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Hide Green Drag Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Drag Tabs", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently showing all drag tabs", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to hide all drag tabs", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("The Drag Tabs allow you to move the bar", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("or menu they are attached to by simply", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("left-clicking and dragging them.", 80/255, 143/255, 148/255);
		GameTooltip:Show();		
	end
end


function UpdateBibGreenButtonsToggle()
	local PlayerString = UnitName("player");
	if(GreenButtonsDisabled and GreenButtonsDisabled[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibGreenButtonsDisabled");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibGreenButtonsEnabled");
	else
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibGreenButtonsEnabled");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibGreenButtonsDisabled");
	end
end

function UpdateBibButtonsLockToggle()
	local PlayerString = UnitName("player");
	if(BibActionBarButtonsLocked and BibActionBarButtonsLocked[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibLocked");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibUnlocked");
	else
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibUnlocked");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibLocked");
	end
end


-- LedMirage 4/18/2005
function BibButtonsLock_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(BibActionBarButtonsLocked[PlayerString]) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Unlock Action Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Lock", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently locked", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to unlock", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This lock prevents you from accidentally", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("moving an action button as well as locking", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("the Insomniax BibToolbars XP Bar.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Lock Action Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Lock", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently unlocked", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to lock", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This lock prevents you from accidentally", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("moving an action button as well as locking", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("the Insomniax BibToolbars XP Bar.", 80/255, 143/255, 148/255);
		GameTooltip:Show();		
	end
end


function UpdateBibButtonsGridModeToggle()
	local PlayerString = UnitName("player");
	if(BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_SHOW) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibShowGrid");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibHideGrid");
	elseif(BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_HIDE_AND_CASCADE) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibHideGrid");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibHideGridNoCascade");
	else
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibHideGridNoCascade");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibShowGrid");
	end
end

-- LedMirage 4/18/2005
function BibButtonsGridMode_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_SHOW) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Hide Empty Action Buttons With Cascading");
		GameTooltip:SetText("Insomniax BibToolbars Grid Mode", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently showing all empty buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to hide empty buttons and cascade", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("The grid mode toggle allows you to configure", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("your action bars to display or hide unused", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("action buttons in three different ways.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
		
	elseif (BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_HIDE_AND_CASCADE) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Hide Empty Action Buttons Without Cascading");
		GameTooltip:SetText("Insomniax BibToolbars Grid Mode", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently hiding all empty buttons and cascading", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to hide empty buttons without cascade", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("The grid mode toggle allows you to configure", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("your action bars to display or hide unused", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("action buttons in three different ways.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Show Empty Action Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Grid Mode", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently hiding all empty buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to show all empty buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("The grid mode toggle allows you to configure", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("your action bars to display or hide unused", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("action buttons in three different ways.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	end
end


function UpdateBibXPBarVisibility()
	local PlayerString = UnitName("player");
	if(BibXPBarInvisible and BibXPBarInvisible[PlayerString]) then
		BibmodXPFrame:Hide();
	else
		BibmodXPFrame:Show();
	end
end

function UpdateBibXPBarToggle()
	local PlayerString = UnitName("player");
	if(BibXPBarInvisible and BibXPBarInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibHideXPBar");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibShowXPBar");
	else
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibShowXPBar");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibHideXPBar");
	end
end

-- LedMirage 4/18/2005
function UpdateBibXPBar_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(BibXPBarInvisible[PlayerString]) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Show BibMod XP Bar");
		GameTooltip:SetText("Insomniax BibToolbars XP Bar", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently hiding the XP Bar", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to show the XP Bar", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This will toggle displaying the Insomniax", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbars XP Bar. Use the BibMenu lock", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("toggle to lock or unlock the XP bar.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Hide BibMod XP Bar");
		GameTooltip:SetText("Insomniax BibToolbars XP Bar", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently showing the XP Bar", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to hide the XP Bar", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This will toggle displaying the Insomniax", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbars XP Bar. Use the BibMenu lock", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("toggle to lock or unlock the XP bar.", 80/255, 143/255, 148/255);
		GameTooltip:Show();		
	end
end



function UpdateBibBagBarVisibility()
	local PlayerString = UnitName("player");
	if(BibBagBarInvisible and BibBagBarInvisible[PlayerString]) then
		BibBagButtonsBar:Hide();
	else
		BibBagButtonsBar:Show();
	end
end

function UpdateBibBagBarToggle()
	local PlayerString = UnitName("player");
	if(BibBagBarInvisible and BibBagBarInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibBagBarInvisible");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibBagBarVisible");
	else
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibBagBarVisible");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibBagBarInvisible");
	end
end


-- LedMirage 4/18/2005
function UpdateBibBagBar_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(BibBagBarInvisible[PlayerString]) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Show Bag Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Bag Buttons", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently hiding the bag buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to show the bag buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This will toggle displaying the Insomniax", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbars Bag Buttons.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Hide Bag Buttons");
		GameTooltip:SetText("Insomniax BibToolbars Bag Buttons", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently showing the bag buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to  hide the bag buttons", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This will toggle displaying the Insomniax", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbars Bag Buttons.", 80/255, 143/255, 148/255);
		GameTooltip:Show();		
	end
end


function UpdateBibMicroBarVisibility()
	local PlayerString = UnitName("player");
	if(BibMicroBarInvisible and BibMicroBarInvisible[PlayerString]) then
		MainMenuBarArtFrame:Hide();
	else
		MainMenuBarArtFrame:Show();
	end
end

function UpdateBibMicroBarToggle()
	local PlayerString = UnitName("player");
	if(BibMicroBarInvisible and BibMicroBarInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibMicroBarInvisible");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibMicroBarVisible");
	else
		this:SetNormalTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibMicroBarVisible");
		this:SetPushedTexture("Interface\\AddOns\\Insomniax_BibToolbars\\Images\\BibMicroBarInvisible");
	end
end

-- LedMirage 4/18/2005
function UpdateBibMicroBar_OnEnter()
	local PlayerString = UnitName("player");
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	if(BibMicroBarInvisible[PlayerString]) then
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Show Main Menu Bar");
		GameTooltip:SetText("Insomniax BibToolbars Main Menu", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently hiding the main menu", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to show the main menu", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This will toggle displaying the Insomniax", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbars Main Menu.", 80/255, 143/255, 148/255);
		GameTooltip:Show();
	else
		-- GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE.."Hide Main Menu Bar");
		GameTooltip:SetText("Insomniax BibToolbars Main Menu", 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Currently showing the main menu", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("Left-click to hide the main menu", 1.00, 1.00, 1.00);
		GameTooltip:AddLine("This will toggle displaying the Insomniax", 80/255, 143/255, 148/255);
		GameTooltip:AddLine("BibToolbars Main Menu.", 80/255, 143/255, 148/255);
		GameTooltip:Show();		
	end
end