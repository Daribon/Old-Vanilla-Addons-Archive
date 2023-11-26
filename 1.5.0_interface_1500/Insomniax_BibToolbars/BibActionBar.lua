--Number of Bib Action Bars
BIB_ACTION_BAR_COUNT = 7;

--Keeps track of which Bonus buttons were showing last time we checked
BONUS_BUTTONS_OFFSET = 0;

--Keeps track of our current action button page
CURRENT_BIB_ACTIONBAR_PAGE = 1;

--Keeps track of whether we have a pet with an action bar
PET_WITH_ACTION_BAR = nil;

BIB_BUTTON_GRID_SHOW = nil;
BIB_BUTTON_GRID_HIDE_AND_CASCADE = 1;
BIB_BUTTON_GRID_HIDE_NO_CASCADE = 2;

--Overrides and disables the normal paging functionality
function ChangeActionBarPage()
	ChangeBibActionBarPage(CURRENT_ACTIONBAR_PAGE);
end


function ChangeBibActionBarPage(page)
	if (page == nil) then
		page = CURRENT_BIB_ACTIONBAR_PAGE;
	else
		CURRENT_BIB_ACTIONBAR_PAGE = page;
	end

	--In Bibmod, we show the bonus actions by paging the toolbar
	--to page seven, instead of putting the bonus buttons in front of it
	if(BONUS_BUTTONS_OFFSET > 0 and page==1) then
		page = 6 + GetBonusBarOffset();
	end
	
	local offset = 12 * (page-1);
	local button;

	for i = 1, 12 do
		button = getglobal(GetBibActionButtonName(i));
		button:SetID(i + offset);
		button:SetChecked(false);
		if(HasAction(button:GetID())) then
			showOccupiedButton(button);
		else
			showEmptyButton(button);
		end
	end
	
	BibActionBarManagement.RedrawActionBars = true;
end


function showEmptyButton(button)
	getglobal(button:GetName().."Icon"):Hide();
	getglobal(button:GetName().."Count"):Hide();
	getglobal(button:GetName().."Name"):Hide();
	button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
	if(button.showgrid < 1) then
		button:Hide();
	end
end


function showOccupiedButton(button)
	getglobal(button:GetName().."Icon"):Show();
	getglobal(button:GetName().."Count"):Show();
	getglobal(button:GetName().."Name"):Show();	
	button:Hide();
	button:Show();
end


function BibActionBarOnEvent (event)
	if (EventIsPlayerNameLoaded(event)) then
		local orientationString = this:GetName().."Orientation";
		local orientation = getglobal(orientationString);
		LayoutBibActionBar(this:GetName());
	end
end


function BibRotateActionBar(bar_name)
	local PlayerString = UnitName("player");
	orientationString = bar_name.."Orientation";
	local orientation = getglobal(orientationString);

	if (orientation[PlayerString] == "1x12") then
		orientation[PlayerString] = "12x1";
	elseif (orientation[PlayerString] == "12x1") then
		orientation[PlayerString] = "2x6";
	elseif (orientation[PlayerString] == "2x6") then
		orientation[PlayerString] = "6x2";
	elseif (orientation[PlayerString] == "6x2") then
		orientation[PlayerString] = "3x4";
	elseif (orientation[PlayerString] == "3x4") then
		orientation[PlayerString] = "4x3";
	elseif (orientation[PlayerString] == "4x3") then
		orientation[PlayerString] = "INVISIBLE";
	else
		orientation[PlayerString] = "1x12";
	end
	LayoutBibActionBar(bar_name);
end


function RemoveMainActionBar()
	MainMenuBarTexture0:Hide();
	MainMenuBarTexture1:Hide();
	MainMenuBarTexture2:Hide();
	MainMenuBarTexture3:Hide();
	MainMenuBarLeftEndCap:Hide();
	MainMenuBarRightEndCap:Hide();
	MainMenuBarOverlayFrame:Hide();
	MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
	--PetActionBarFrame:ClearAllPoints();
	--PetActionBarFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOM", -220, 298);
	ActionBarUpButton:Hide();
	ActionBarDownButton:Hide();
	ExhaustionTick:Hide();
	BonusActionBarTexture0:ClearAllPoints();
	BonusActionBarTexture0:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
	BonusActionBarFrame:ClearAllPoints();
	BonusActionBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
	SlidingActionBarTexture0:ClearAllPoints();
	SlidingActionBarTexture0:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
	MainMenuExpBar:ClearAllPoints();
	MainMenuExpBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
	local actionbutton;
	for i = 1, 12 do
		actionbutton = getglobal("ActionButton"..i);
		actionbutton:ClearAllPoints();
		actionbutton:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100)
	end
end


function LayoutBibActionBar(ActionBarName)
	local action_button;
	local ActionBar = getglobal(ActionBarName);
	local ActionBarID = ActionBar:GetID();
	local orientationString = ActionBarName.."Orientation";
	local orientation = getglobal(orientationString);
	local PlayerString = UnitName("player");
	local n = 0;
	local x_offset = 0;
	local y_offset = 0;
	local max_x_offset = 0;
	local max_y_offset = 0;
	local visible_buttons_exist = false;
	
	if(not (orientation[PlayerString])) then
		orientation[PlayerString] = "1x12";
	end
	
	i = 1;	
	for j=1, 12 do
		action_button = getglobal(GetBibActionButtonName(j + (ActionBarID-1)*12));
		action_button:ClearAllPoints();
		if(orientation[PlayerString] == "INVISIBLE") then
			action_button:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, -100);
		else
			action_button:SetPoint("TOPLEFT", ActionBarName, "TOPLEFT", x_offset , -y_offset);
			if(action_button:IsVisible()) then
				if(x_offset > max_x_offset) then
					max_x_offset = x_offset;
				end
				if(y_offset > max_y_offset) then
					max_y_offset = y_offset;
				end
				if(not visible_buttons_exist) then
					visible_buttons_exist = true;
				end
			end
		end
		
		if(action_button:IsVisible() or BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_HIDE_NO_CASCADE) then
		i = i + 1;
		if(orientation[PlayerString] == "12x1") then
			y_offset = (i - 1) * 40;
			x_offset = 0;
		elseif(orientation[PlayerString] == "2x6") then
			x_offset = (math.mod(i-1, 6)) * 40;
			n = (i-1)/6;
			y_offset = (n - math.mod(n, 1)) * 40;
		elseif(orientation[PlayerString] == "6x2") then
			x_offset = (math.mod(i-1, 2)) * 40;
			n = (i-1)/2;
			y_offset = (n - math.mod(n, 1)) * 40;
		elseif(orientation[PlayerString] == "3x4") then
			x_offset = (math.mod(i-1, 4)) * 40;
			n = (i-1)/4;
			y_offset = (n - math.mod(n, 1)) * 40;
		elseif(orientation[PlayerString] == "4x3") then
			x_offset = (math.mod(i-1, 3)) * 40;
			n = (i-1)/3;
			y_offset = (n - math.mod(n, 1)) * 40;
		elseif(orientation[PlayerString] == "1x12") then
			x_offset = (i - 1) * 40;
			y_offset = 0;
		else
			x_offset = 0;
			y_offset = 0;
		end
		end
	end
	
	if (not visible_buttons_exist) then
		ActionBar:SetWidth(12);
		ActionBar:SetHeight(20);
	else
		ActionBar:SetWidth(max_x_offset + 36);
		ActionBar:SetHeight(max_y_offset + 36);
	end
end

--Keeps track of UI changes that should affect the main action bar, and changes it accordingly
function UpdateBibMainActionBar()
	local button;
	local bonusButtonsOffset = GetBonusBarOffset();
	
	if (BONUS_BUTTONS_OFFSET ~= bonusButtonsOffset) then
		BONUS_BUTTONS_OFFSET = bonusButtonsOffset;
		ChangeBibActionBarPage();
	end
end


function ConstructBibMicroBar()
	CharacterMicroButton:ClearAllPoints();
	CharacterMicroButton:SetPoint("TOPLEFT", "MainMenuBarArtFrame", "TOPLEFT", -2, 22);
end


function ConstructBibBagBar()
	CharacterBag3Slot:ClearAllPoints();
	CharacterBag3Slot:SetPoint("BOTTOMLEFT", this:GetName());
	CharacterBag2Slot:ClearAllPoints();
	CharacterBag2Slot:SetPoint("LEFT", "CharacterBag3Slot", "RIGHT", 2, 0);
	CharacterBag1Slot:ClearAllPoints();
	CharacterBag1Slot:SetPoint("LEFT", "CharacterBag2Slot", "RIGHT", 2, 0);
	CharacterBag0Slot:ClearAllPoints();
	CharacterBag0Slot:SetPoint("LEFT", "CharacterBag1Slot", "RIGHT", 2, 0);
	MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("LEFT", "CharacterBag0Slot", "RIGHT", 2, 0);
end


function BibConstructPetBar()
	for i=1, 10 do
		pet_button = getglobal("PetActionButton"..i);
		if (pet_button ~= nil) then
			pet_button:ClearAllPoints();
			pet_button:SetPoint("TOPLEFT", "PetActionBarFrame", "TOPLEFT", 2 + ((i - 1) * 33), -1);
		end
	end
end

function ConstructBibShapeshiftBar()
	for i=1, 10 do
		shapeshift_button = getglobal("ShapeshiftButton"..i);
		shapeshift_button:ClearAllPoints();
		shapeshift_button:SetPoint("TOPLEFT", "ShapeshiftBarFrame", "TOPLEFT", 4 + ((i - 1) * 40), -4);
	end
end


function PetActionBarFrame_OnUpdate(elapsed)
	local yPos;
	if ( this.slideTimer and (this.slideTimer < this.timeToSlide) ) then
		this.completed = nil;
		if ( this.mode == "show" ) then
			yPos = (this.slideTimer/this.timeToSlide) * this.yTarget;
			this.state = "showing";
			this:Show();
		elseif ( this.mode == "hide" ) then
			yPos = (1 - (this.slideTimer/this.timeToSlide)) * this.yTarget;
			this.state = "hiding";
		end
		this.slideTimer = this.slideTimer + elapsed;
	else
		this.completed = 1;
		if ( this.mode == "show" ) then
			this.state = "top";
		elseif ( this.mode == "hide" ) then
			this.state = "bottom";
			this:Hide();
		end
		this.mode = "none";
	end
end


function ShapeshiftBar_Update()
	local numForms = GetNumShapeshiftForms();
	local fileName, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;

	if ( numForms > 0 ) then
		ShapeshiftBarFrame:Show();
	else
		ShapeshiftBarFrame:Hide();
	end
	
	for i=1, NUM_SHAPESHIFT_SLOTS do
		button = getglobal("ShapeshiftButton"..i);
		icon = getglobal("ShapeshiftButton"..i.."Icon");
		if ( i <= numForms ) then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i);
			icon:SetTexture(texture);
			
			--Cooldown stuffs
			cooldown = getglobal("ShapeshiftButton"..i.."Cooldown");
			if ( texture ) then
				cooldown:Show();
			else
				cooldown:Hide();
			end
			start, duration, enable = GetShapeshiftFormCooldown(i);
			CooldownFrame_SetTimer(cooldown, start, duration, enable);
			
			if ( isActive ) then
				ShapeshiftBarFrame.lastSelected = button:GetID();
				button:SetChecked(1);
			else
				button:SetChecked(0);
			end

			if ( isCastable ) then
				icon:SetVertexColor(1.0, 1.0, 1.0);
			else
				icon:SetVertexColor(0.4, 0.4, 0.4);
			end

			button:Show();
		else
			button:Hide();
		end
	end
end

function ShowPetActionBar()
	if ( PetHasActionBar() and PetActionBarFrame.showgrid == 0 and (PetActionBarFrame.mode ~= "show") and not PetActionBarFrame.locked and not PetActionBarFrame.ctrlPressed ) then
		PetActionBarFrame:Show();
		if ( PetActionBarFrame.completed ) then
			PetActionBarFrame.slideTimer = 0;
		end
		PetActionBarFrame.timeToSlide = PETACTIONBAR_SLIDETIME;
		PetActionBarFrame.yTarget = PETACTIONBAR_YPOS;
		PetActionBarFrame.mode = "show";
	end
end

function HidePetActionBar()
	if ( PetActionBarFrame.showgrid == 0 and PetActionBarFrame:IsVisible() and not PetActionBarFrame.locked and not PetActionBarFrame.ctrlPressed ) then
		if ( PetActionBarFrame.completed ) then
			PetActionBarFrame.slideTimer = 0;
		end
		PetActionBarFrame.timeToSlide = PETACTIONBAR_SLIDETIME;
		PetActionBarFrame.yTarget = PETACTIONBAR_YPOS;
		PetActionBarFrame.mode = "hide";
	end
end

-- LedMirage 4/18/2005
function BibDragButton_OnEnter()
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);

	GameTooltip:SetText("Insomniax BibToolbars Drag Tab", 255/255, 209/255, 0/255);
	GameTooltip:AddLine("Left-click and drag to move", 1.00, 1.00, 1.00);
	GameTooltip:AddLine("This drag tab allows you to move the", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("element it's attached to anywhere on", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("your screen. Don't try to hide unused", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("empty buttons off-screen, instead use", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("the Grid Mode display toggle or the", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("rotate button to hide them.", 80/255, 143/255, 148/255);	
	GameTooltip:Show();
end

-- LedMirage 4/18/2005
function BibRotateButton_OnEnter()
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);

	GameTooltip:SetText("Insomniax BibToolbars Rotate Button", 255/255, 209/255, 0/255);
	GameTooltip:AddLine("Left-click to change the bar configuration", 1.00, 1.00, 1.00);
	GameTooltip:AddLine("This button allows you to change the button", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("layout of the bar it's attached to by cycling", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("between seven modes including a mode to hide", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("the bar entirely. The seven modes available", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("are: 1x12, 12x1, 2x6, 6x2, 3x4, 4x3 and the", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("hidden mode. It is strongly recommended that", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("you hide unused bars this way to avoid other", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("problems by moving bars off-screen.", 80/255, 143/255, 148/255);
	GameTooltip:Show();
end