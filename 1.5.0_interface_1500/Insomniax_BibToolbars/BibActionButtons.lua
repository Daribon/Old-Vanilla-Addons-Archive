NUM_BIB_ACTION_BUTTONS = 84;

BINDING_HEADER_BIBACTIONBAR2 = "Action Bar #2 Buttons";
BINDING_NAME_BIBACTIONBUTTON13 = "Action Button 1";
BINDING_NAME_BIBACTIONBUTTON14 = "Action Button 2";
BINDING_NAME_BIBACTIONBUTTON15 = "Action Button 3";
BINDING_NAME_BIBACTIONBUTTON16 = "Action Button 4";
BINDING_NAME_BIBACTIONBUTTON17 = "Action Button 5";
BINDING_NAME_BIBACTIONBUTTON18 = "Action Button 6";
BINDING_NAME_BIBACTIONBUTTON19 = "Action Button 7";
BINDING_NAME_BIBACTIONBUTTON20 = "Action Button 8";
BINDING_NAME_BIBACTIONBUTTON21 = "Action Button 9";
BINDING_NAME_BIBACTIONBUTTON22 = "Action Button 10";
BINDING_NAME_BIBACTIONBUTTON23 = "Action Button 11";
BINDING_NAME_BIBACTIONBUTTON24 = "Action Button 12";

BINDING_HEADER_BIBACTIONBAR3 = "Action Bar #3 Buttons";
BINDING_NAME_BIBACTIONBUTTON25 = "Action Button 1";
BINDING_NAME_BIBACTIONBUTTON26 = "Action Button 2";
BINDING_NAME_BIBACTIONBUTTON27 = "Action Button 3";
BINDING_NAME_BIBACTIONBUTTON28 = "Action Button 4";
BINDING_NAME_BIBACTIONBUTTON29 = "Action Button 5";
BINDING_NAME_BIBACTIONBUTTON30 = "Action Button 6";
BINDING_NAME_BIBACTIONBUTTON31 = "Action Button 7";
BINDING_NAME_BIBACTIONBUTTON32 = "Action Button 8";
BINDING_NAME_BIBACTIONBUTTON33 = "Action Button 9";
BINDING_NAME_BIBACTIONBUTTON34 = "Action Button 10";
BINDING_NAME_BIBACTIONBUTTON35 = "Action Button 11";
BINDING_NAME_BIBACTIONBUTTON36 = "Action Button 12";

BINDING_HEADER_BIBACTIONBAR4 = "Action Bar #4 Buttons";
BINDING_NAME_BIBACTIONBUTTON37 = "Action Button 1";
BINDING_NAME_BIBACTIONBUTTON38 = "Action Button 2";
BINDING_NAME_BIBACTIONBUTTON39 = "Action Button 3";
BINDING_NAME_BIBACTIONBUTTON40 = "Action Button 4";
BINDING_NAME_BIBACTIONBUTTON41 = "Action Button 5";
BINDING_NAME_BIBACTIONBUTTON42 = "Action Button 6";
BINDING_NAME_BIBACTIONBUTTON43 = "Action Button 7";
BINDING_NAME_BIBACTIONBUTTON44 = "Action Button 8";
BINDING_NAME_BIBACTIONBUTTON45 = "Action Button 9";
BINDING_NAME_BIBACTIONBUTTON46 = "Action Button 10";
BINDING_NAME_BIBACTIONBUTTON47 = "Action Button 11";
BINDING_NAME_BIBACTIONBUTTON48 = "Action Button 12";

BINDING_HEADER_BIBACTIONBAR5 = "Action Bar #5 Buttons";
BINDING_NAME_BIBACTIONBUTTON49 = "Action Button 1";
BINDING_NAME_BIBACTIONBUTTON50 = "Action Button 2";
BINDING_NAME_BIBACTIONBUTTON51 = "Action Button 3";
BINDING_NAME_BIBACTIONBUTTON52 = "Action Button 4";
BINDING_NAME_BIBACTIONBUTTON53 = "Action Button 5";
BINDING_NAME_BIBACTIONBUTTON54 = "Action Button 6";
BINDING_NAME_BIBACTIONBUTTON55 = "Action Button 7";
BINDING_NAME_BIBACTIONBUTTON56 = "Action Button 8";
BINDING_NAME_BIBACTIONBUTTON57 = "Action Button 9";
BINDING_NAME_BIBACTIONBUTTON58 = "Action Button 10";
BINDING_NAME_BIBACTIONBUTTON59 = "Action Button 11";
BINDING_NAME_BIBACTIONBUTTON60 = "Action Button 12";

BINDING_HEADER_BIBACTIONBAR6 = "Action Bar #6 Buttons";
BINDING_NAME_BIBACTIONBUTTON61 = "Action Button 1";
BINDING_NAME_BIBACTIONBUTTON62 = "Action Button 2";
BINDING_NAME_BIBACTIONBUTTON63 = "Action Button 3";
BINDING_NAME_BIBACTIONBUTTON64 = "Action Button 4";
BINDING_NAME_BIBACTIONBUTTON65 = "Action Button 5";
BINDING_NAME_BIBACTIONBUTTON66 = "Action Button 6";
BINDING_NAME_BIBACTIONBUTTON67 = "Action Button 7";
BINDING_NAME_BIBACTIONBUTTON68 = "Action Button 8";
BINDING_NAME_BIBACTIONBUTTON69 = "Action Button 9";
BINDING_NAME_BIBACTIONBUTTON70 = "Action Button 10";
BINDING_NAME_BIBACTIONBUTTON71 = "Action Button 11";
BINDING_NAME_BIBACTIONBUTTON72 = "Action Button 12";

BINDING_HEADER_BIBACTIONBAR7 = "Action Bar #7 Buttons";
BINDING_NAME_BIBACTIONBUTTON73 = "Action Button 1";
BINDING_NAME_BIBACTIONBUTTON74 = "Action Button 2";
BINDING_NAME_BIBACTIONBUTTON75 = "Action Button 3";
BINDING_NAME_BIBACTIONBUTTON76 = "Action Button 4";
BINDING_NAME_BIBACTIONBUTTON77 = "Action Button 5";
BINDING_NAME_BIBACTIONBUTTON78 = "Action Button 6";
BINDING_NAME_BIBACTIONBUTTON79 = "Action Button 7";
BINDING_NAME_BIBACTIONBUTTON80 = "Action Button 8";
BINDING_NAME_BIBACTIONBUTTON81 = "Action Button 9";
BINDING_NAME_BIBACTIONBUTTON82 = "Action Button 10";
BINDING_NAME_BIBACTIONBUTTON83 = "Action Button 11";
BINDING_NAME_BIBACTIONBUTTON84 = "Action Button 12";

--This overrides the normal ActionButton_GetPagedID to simply return the button's actual ID for BibActionButtons
function ActionButton_GetPagedID(button)
	return button:GetID();
end

--Overriding ActionButtonDown() and ActionButtonUp() too, but may change this later
function ActionButtonDown(id)
	PressBibActionButton(id);
end

function ActionButtonUp(id, onSelf)
	ReleaseBibActionButton(id, onSelf);
end

function BibActionButtons_ShowGrid()
	local button;
	for i=1, NUM_BIB_ACTION_BUTTONS do
		button = getglobal("BibActionButton"..i);
		button.showgrid = 1;
		getglobal(button:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0, 0.5);
		button:Show();
	end
end

function BibActionButtons_HideGrid()
	local button;
	for i=1, NUM_BIB_ACTION_BUTTONS do	
		button = getglobal("BibActionButton"..i);
		if (button.showgrid > 0) then
			button.showgrid = 0;
		end
		if ( button.showgrid == 0 and button:IsVisible() and not HasAction(ActionButton_GetPagedID(button)) ) then
			button:Hide();
		end
	end
end

function GetBibActionButtonName(button_num)
	return "BibActionButton"..button_num;	
end

function GetBibActionButtonBindingBindingName(button_num)
	if(button_num <= 12) then
		return "ACTIONBUTTON"..button_num;
	else
		return "BIBACTIONBUTTON"..button_num;
	end	
end

function PressBibActionButton(button_num)
	local button = getglobal(GetBibActionButtonName(button_num));
	if (button) then
		button:SetButtonState("PUSHED");
	end
end

function ReleaseBibActionButton(button_num, onSelf)
	local button = getglobal(GetBibActionButtonName(button_num));
	if (button) then
		button:SetButtonState("NORMAL");
	end
	UseAction(button:GetID(), 0, onSelf);
end

function BibUpdateActionButtonMapText(button_num)
	local maptext = getglobal(GetBibActionButtonName(button_num).."HotKey");
	local action = GetBibActionButtonBindingBindingName(button_num);
	local mapstr = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
	mapstr = gsub(mapstr, "ALT", "A");
	mapstr = gsub(mapstr, "CTRL", "C");
	mapstr = gsub(mapstr, "SHIFT", "S");
	mapstr = gsub(mapstr, "Num Pad ", "NP");
	maptext:SetText(mapstr);
end

function BibUpdateAllActionButtonMappings()
	local button;
	
	for button = 1, NUM_BIB_ACTION_BUTTONS do
		BibUpdateActionButtonMapText(button);
	end
end

function BibActionButton_OnUpdate(elapsed)
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
			local cover = getglobal(this:GetName().."Cover");
			if ( IsActionInRange( ActionButton_GetPagedID(this)) == 0 ) then
				-- LedMirage 5/03/2005
				-- cover:SetVertexColor(1.0, 0.0, 0.0, 0.6);
				cover:SetVertexColor(20/255, 106/255, 124/255, 0.6);
			else
				cover:SetVertexColor(0.0, 0.0, 0.0, 0.0);
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