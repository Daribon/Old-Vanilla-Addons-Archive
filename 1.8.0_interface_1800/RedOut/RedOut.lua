-- RedOut Script
-- by jINx of Purgatory LAN Organization

-- Description:
-- Shades Out the Action Bar buttons when they are out of range

-- Version 2.1
-- * Fixed an issue with loading multiple times	

-- Version 2.0
-- * Flicker was reduced or stopped for the most part
-- * Added support for Telo's Sidebar
-- * Changed load sequence to ensure it checks for other scripts last

-- Version 1.0
-- * First Released Version
-- * Created Options frame to allow Enable/Disable and Custom Color
-- * Fixed an Issue that was causing Usability to not take into account
-- * Verified and created functionality for the following bars:
-- * .... Standard Bar
-- * .... BiB Toolbars
-- * .... CT Bar Mod
-- * .... Gypsy Bars

local RedOutVersion = 2.0
local isLoaded = false;

function RedOut_OptionsCheckButtonOnClick()
	if (RedOutEnabled) then
		RedOutEnabled = false;
	else
		RedOutEnabled = true;
	end
end

function RedOutOptions_Defaults()
	RedOutEnabled = true;
	RedOutColor = { r = 1.0, g = 0.25, b = 0.25 };
	RedOutOptions_Show();
end

function RedOutOptions_Show()
	local string = getglobal("RedOutOptionsFrame_CheckButton1Text");
	string:SetText("Enable Red Out");

	local frame = getglobal("RedOutOptionsFrame1");
	local swatch = getglobal("RedOutOptionsFrame1_ColorSwatchNormalTexture");
	string = getglobal("RedOutOptionsFrame1_ColorSwatchText");
	string:SetText("Choose a Color to Fade To");

	frame.r = RedOutColor.r;
	frame.g = RedOutColor.g;
	frame.b = RedOutColor.b;
	frame.swatchFunc = RedOutOptions_SetColor;
	swatch:SetVertexColor(RedOutColor.r, RedOutColor.g, RedOutColor.b);
	
	local button = getglobal("RedOutOptionsFrame_CheckButton1");
	if (RedOutEnabled) then
		checked = 1;
	else
		checked = 0;
	end
	button:SetChecked(checked);
end

function RedOutOptions_SetColor()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	frame = getglobal("RedOutOptionsFrame1");
	swatch = getglobal("RedOutOptionsFrame1_ColorSwatchNormalTexture");
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	RedOutColor.r = r;
	RedOutColor.g = g;
	RedOutColor.b = b;
end

function RedOutOptions_Hide()
	RedOutOptions:Hide();
end

-- Command parser
function RedOut_Command(arg1)
	RedOutOptions:Show();
end

local function SetHook(myFunction, HookFunc)
	local oldFunction = getglobal(HookFunc);
	local newFunction =
		function(e)
			oldFunction(e);
			myFunction(e);
		end
	setglobal(HookFunc, newFunction);
end


function RedOutAction_OnLoad()
	-- Set Default
	if (not RedOutEnabled) then
		RedOutEnabled = true;
		RedOutColor = { r = 1.0, g = 0.25, b = 0.25 };
	end

	this:RegisterEvent("PLAYER_ENTERING_WORLD");

	SlashCmdList["REDOUTCMD"] = RedOut_Command;
	SLASH_REDOUTCMD1 = "/redout";
end

function RedOutAction_OnEvent(event)
	if( (event=="PLAYER_ENTERING_WORLD") ) then
		RedOutAction_Setup();
	end	
end

function RedOutAction_Setup()
	isLoaded = true;

	-- Hook Standard Buttons
	SetHook(RedOutAction_OnUpdate, "ActionButton_OnUpdate");
	SetHook(RedOutAction_UpdateUsable, "ActionButton_UpdateUsable");
	local hooks = "Standard Bar";
end

function RedOutAction_UpdateUsable(arg)
	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));

	if ( IsActionInRange(ActionButton_GetPagedID(this)) == 0 ) then
		icon:SetVertexColor(RedOutColor.r, RedOutColor.g, RedOutColor.b);
		normalTexture:SetVertexColor(RedOutColor.r, RedOutColor.g, RedOutColor.b);
	else
		if ( isUsable ) then
			icon:SetVertexColor(1.0, 1.0, 1.0);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		elseif ( notEnoughMana ) then
			icon:SetVertexColor(0.5, 0.5, 1.0);
			normalTexture:SetVertexColor(0.5, 0.5, 1.0);
		else
			icon:SetVertexColor(0.4, 0.4, 0.4);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		end
	end
end

-- Update Function, sent elapsed time since last update (ms)
function RedOutAction_OnUpdate(elapsed)
	
	if (not RedOutEnabled) then
		return;
	end

	-- Original Func is run in the inline function of SetHook

	-- Get the Icon and Normal Texture for the Action Button
	local icon = getglobal(this:GetName().."Icon");
	local normalTexture = getglobal(this:GetName().."NormalTexture");

	-- Check if its usable (from original func) no sense in range checking if its not
	local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this));

	if ( this.rangeTimer ) then
		if ( this.rangeTimer < 0 ) then
			if ( IsActionInRange(ActionButton_GetPagedID(this)) == 0 ) then
				icon:SetVertexColor(RedOutColor.r, RedOutColor.g, RedOutColor.b);
				normalTexture:SetVertexColor(RedOutColor.r, RedOutColor.g, RedOutColor.b);
			else
				if ( isUsable ) then
					icon:SetVertexColor(1.0, 1.0, 1.0);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				elseif ( notEnoughMana ) then
					icon:SetVertexColor(0.5, 0.5, 1.0);
					normalTexture:SetVertexColor(0.5, 0.5, 1.0);
				else
					icon:SetVertexColor(0.4, 0.4, 0.4);
					normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
		end
	end
end
