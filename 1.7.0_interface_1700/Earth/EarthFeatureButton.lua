--[[
--
--	The Earth Feature Window
--
--		Vjeux and Alexander Brazie
--
--	These are functions to allow a user to register a button
--	for their feature to appear within the frame here. 
--	
--	$Id: EarthFeatureButton.lua 2025 2005-07-02 23:51:34Z Sinaloit $
--	$Rev: 2025 $
--	$LastChangedBy: Sinaloit $
--	$Date: 2005-07-02 18:51:34 -0500 (Sat, 02 Jul 2005) $
--
--]]


-- Inform the default UI of our existence...
UIPanelWindows["EarthFeatureFrame"] = { area = "left",	pushable = 3 };

-- Max Objects
EARTHFEATURE_MAX = 14;

-- Data objects:
EarthFeature_Buttons = { };
EarthFeature_CurrentOffset = 0;

-- Just for fun, not an important value
RegisterForSave("EarthFeature_CurrentOffset");

-- Registration

--[[
	RegisterButton

	Allow you to create a button of your mod in the Earth Features Frame.

	Usage:

		EarthFeature_AddButton ( EarthRegistrationObject[name,subtext,tooltip,icon,callback,testfunction] )

	Example:

		EarthFeature_AddButton (
			{ 
				id = "MyAddOnID";
				name = "My AddOn";
				subtext = "Is very cool";
				tooltip = "Long Tool\n Tip Text";
				icon = "Interface\\Icons\\Spell_Holy_BlessingOfStrength";
				callback = function()
					if (MinimapFrameFrame:IsVisible()) then
						HideUIPanel(MinimapFrame);
					else
						ShowUIPanel(MinimapFrame);
					end
				end;
				test = 	function()
					if (UnitInParty("party1")) then
						return true; -- The button is enabled
					else
						return false; -- The button is disabled
					end
				end
			}
			);

		A button will be created in the Features Frame.

		Description must not be more than 2 words, you should put a longer description in the tooltip.

	]]--

function EarthFeature_AddButton ( newButton )
	if ( newButton.name == nil ) then
		Sea.io.error ( "EarthFeature_AddButton: ","Missing a name for the button. From ",this:GetName());
		return false;
	end
	if ( newButton.icon == nil ) then
		Sea.io.error ( "EarthFeature_AddButton: ","Missing an icon path for the Earth Feature Button. (",newButton.name,")", " from ", this:GetName());
		return false;
	end
	if ( newButton.callback == nil ) then
		Sea.io.error ( "EarthFeature_AddButton: ","Missing a callback for the Earth Feature Button. (",newButton.name,")", " from ", this:GetName());
		return false;
	end
	if ( newButton.test == nil ) then
		newButton.test = function () return true; end;
	end

	table.insert ( EarthFeature_Buttons, newButton );

	EarthFeature_UpdateButtons();

	return true;
end


function ToggleEarthFeatureFrame()
	if (EarthFeatureFrame:IsVisible()) then
		HideUIPanel(EarthFeatureFrame);
	else
		ShowUIPanel(EarthFeatureFrame);
	end
end

function EarthFeatureFrame_OnHide()
	UpdateMicroButtons();
	PlaySound("igSpellBookClose");
end

function EarthButtons_UpdateColor()
	local root =  "EarthFeatureFrame";
	for i=1, EARTHFEATURE_MAX do
		local icon = getglobal(root.."Button"..i);
		local iconTexture = getglobal(root.."Button"..i.."IconTexture");
			
		local id = EarthFeatureButton_GetOffset() + i;
		if ( EarthFeature_Buttons[id] ) then
			if ( EarthFeature_Buttons[id].test() == false) then
				icon:Disable();
				iconTexture:SetVertexColor(1.00, 0.00, 0.00);
			else
				icon:Enable();
				iconTexture:SetVertexColor(1.00, 1.00, 1.00);
			end
		end
	end
end

function EarthFeatureFrame_OnShow()
	EarthFeatureFrameTitleText:SetText(TEXT(EARTH_FEATURES_TITLE));
	PlaySound("igSpellBookOpen");
	EarthFeature_UpdateButtons();
end

function EarthFeatureButton_OnEnter()	
	local id = this:GetID() + EarthFeatureButton_GetOffset();
	
	if ( EarthFeature_Buttons[id] ) then 
		local tooltip = EarthFeature_Buttons[id].tooltip;
		if ( type ( tooltip ) == "function" ) then 
			tooltip = tooltip();
		end
		if ( tooltip ) then 
			EarthTooltip:SetOwner(this, "ANCHOR_RIGHT");
			EarthTooltip:SetText(tooltip, 1.0, 1.0, 1.0);
		end
	end
end

function EarthFeatureButton_OnLeave()
	EarthTooltip:Hide();
end

function EarthFeatureButton_OnClick()	
	local id = this:GetID() + EarthFeatureButton_GetOffset();
	
	if ( EarthFeature_Buttons[id] ) then 
		this:SetChecked(0);
		EarthFeature_Buttons[id].callback();
	end
end

function EarthFeatureButton_GetOffset()
	return EarthFeature_CurrentOffset;
end

function EarthFeature_NextPage()
	if ( table.getn(EarthFeature_Buttons) > EarthFeature_CurrentOffset + EARTHFEATURE_MAX ) then 
		EarthFeature_CurrentOffset = EarthFeature_CurrentOffset + EARTHFEATURE_MAX;
	end
	EarthFeature_UpdateButtons();
end


function EarthFeature_PrevPage()
	if ( EarthFeature_CurrentOffset - EARTHFEATURE_MAX < 0 ) then 
		EarthFeature_CurrentOffset = 0;
	else 
		EarthFeature_CurrentOffset = EarthFeature_CurrentOffset - EARTHFEATURE_MAX;
	end
	EarthFeature_UpdateButtons();	
end

function EarthFeature_UpdateButtons()
	local root = "EarthFeatureFrame";
	for i = 1, EARTHFEATURE_MAX, 1 do
		local icon = getglobal(root.."Button"..i);
		local iconTexture = getglobal(root.."Button"..i.."IconTexture");
		local iconName = getglobal(root.."Button"..i.."Name");
		local iconDescription = getglobal(root.."Button"..i.."OtherName");

		local id = EarthFeatureButton_GetOffset() + i;
		if ( EarthFeature_Buttons[id] ) then		
			icon:Show();
			icon:Enable();
			iconTexture:Show();
			iconTexture:SetTexture(EarthFeature_Buttons[id].icon);
			iconName:Show();
			iconName:SetText(EarthFeature_Buttons[id].name);
			iconDescription:Show();
			iconDescription:SetText(EarthFeature_Buttons[id].subtext);
		else
			icon:Hide();
			iconTexture:Hide();
			iconName:Hide();
			iconDescription:Hide();			
		end
	end
	EarthFeature_UpdatePageArrows();
	EarthButtons_UpdateColor();
end

function EarthFeature_UpdatePageArrows()
	local root = "EarthFeatureFrame";
	local currentPage, maxPages = EarthFeature_GetCurrentPage();
	if ( currentPage== 1 ) then
		getglobal(root.."PrevPageButton"):Disable();
	else
		getglobal(root.."PrevPageButton"):Enable();
	end
	if ( currentPage == maxPages ) then
		getglobal(root.."NextPageButton"):Disable();
	else
		getglobal(root.."NextPageButton"):Enable();
	end
end

function EarthFeature_GetCurrentPage()
	local currentPage = (EarthFeatureButton_GetOffset()/EARTHFEATURE_MAX) + 1;
	local maxPages = ceil(table.getn(EarthFeature_Buttons)/EARTHFEATURE_MAX);
	return currentPage, maxPages;
end

--[[
--	Minimap Button Mobility Code
--]]

function EarthMinimapButton_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	EarthMinimapButton:SetFrameLevel(MinimapZoomIn:GetFrameLevel());
	--EarthMinimapButton_Reset();
end

function EarthMinimapButton_Reset()
	--fixes a mysterious frame level problem that would hide the EarthMinimapButton behind some unknown minimap frame.
	ToggleWorldMap();
	ToggleWorldMap(); 
end

function EarthMinimapButton_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		RegisterForSave("EarthMinimapButton_OffsetX");
		RegisterForSave("EarthMinimapButton_OffsetY");
		if (EarthMinimapButton_OffsetX) and (EarthMinimapButton_OffsetY) then
			this:SetPoint("CENTER", "Minimap", "CENTER", EarthMinimapButton_OffsetX, EarthMinimapButton_OffsetY);
		end
	end
end

function EarthMinimapButton_OnMouseDown()
	if (IsShiftKeyDown()) then
		if ( arg1 == "RightButton" ) then
			--wait for reset
		else
			this.isMoving = true;
		end
	end
end

function EarthMinimapButton_OnMouseUp()
	if (this.isMoving) then
		this.isMoving = false;
		EarthMinimapButton_OffsetX = this.currentX;
		EarthMinimapButton_OffsetY = this.currentY;
	elseif (MouseIsOver(EarthMinimapButton)) then
		if (IsShiftKeyDown()) and ( arg1 == "RightButton" ) then
			EarthMinimapButton_Reset();
		else
			ToggleEarthFeatureFrame();
		end
	end
end

function EarthMinimapButton_OnHide()
	this.isMoving = false;
end

function EarthMinimapButton_OnUpdate()
	if (this.isMoving) then
		local mouseX, mouseY = GetCursorPosition();
		local centerX, centerY = Minimap:GetCenter();
		local scale = Minimap:GetScale();
		mouseX = mouseX / scale;
		mouseY = mouseY / scale;
		local radius = (Minimap:GetWidth()/2) + (this:GetWidth()/3);
		local x = math.abs(mouseX - centerX);
		local y = math.abs(mouseY - centerY);
		local xSign = 1;
		local ySign = 1;
		if not (mouseX >= centerX) then
			xSign = -1;
		end
		if not (mouseY >= centerY) then
			ySign = -1;
		end
		--Sea.io.print(xSign*x,", ",ySign*y);
		local angle = math.atan(x/y);
		x = math.sin(angle)*radius;
		y = math.cos(angle)*radius;
		this.currentX = xSign*x;
		this.currentY = ySign*y;
		this:SetPoint("CENTER", "Minimap", "CENTER", this.currentX, this.currentY);
	end
end

function EarthMinimapButton_Reset()
	EarthMinimapButton:ClearAllPoints();
	EarthMinimapButton_OffsetX = -65;
	EarthMinimapButton_OffsetY = -49;
	EarthMinimapButton:SetPoint("CENTER", "Minimap", "CENTER", EarthMinimapButton_OffsetX, EarthMinimapButton_OffsetY);
end
