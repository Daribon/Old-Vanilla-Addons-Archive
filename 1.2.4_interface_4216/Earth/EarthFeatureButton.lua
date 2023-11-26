--[[
--
--	The Earth Feature Window
--
--		Vjeux and Alexander Brazie
--
--	These are functions to allow a user to register a button
--	for their feature to appear within the frame here. 
--	
--
--]]


-- Inform the default UI of our existence...
UIPanelWindows["EarthFeatureFrame"] = { area = "left",	pushable = 10 };

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

		EarthFeature_AddButton ( EarthRegistrationObject[name,description,tooltip,icon,callback,testfunction] )

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
				end
				testfunction = 	function()
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
		Sea.io.error ( "Missing a name for the Button.");
		return false;
	end
	if ( newButton.icon == nil ) then
		Sea.io.error ( "Missing an icon path for the Earth Feature Button. (",newButton.name,")");
		return false;
	end
	if ( newButton.callback == nil ) then
		Sea.io.error ( "Missing a callback for the Earth Feature Button. (",newButton.name,")");
		return false;
	end
	if ( newButton.testfunction == nil ) then
		newButton.testFunction = function () return true; end;
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
	local id = EarthFeatureButton_GetOffset();
	local root =  "EarthFeatureFrame";
	for i=1, EARTHFEATURE_MAX do
		local icon = getglobal(root.."Button"..i);
		local iconTexture = getglobal(root.."Button"..i.."IconTexture");
			
		if ( EarthFeature_Buttons[id] ) then
			if ( EarthFeature_Buttons[id].testfunction() == false) then
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
	EarthButtons_UpdateColor();
end

function EarthFeatureButton_OnEnter()	
	local id = this:GetID() + EarthFeatureButton_GetOffset();
	
	if ( EarthFeature_Buttons[id] ) then 
		EarthTooltip:SetOwner(this, "ANCHOR_RIGHT");
		EarthTooltip:SetText(EarthFeature_Buttons[id].tooltip, 1.0, 1.0, 1.0);
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


function EarthFeature_NextPage()
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
end
