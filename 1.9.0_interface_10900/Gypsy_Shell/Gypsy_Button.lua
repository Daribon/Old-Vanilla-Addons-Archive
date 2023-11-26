--[[
	Gypsy_Button.lua
	GypsyVersion++2004.10.26++
]]


-- Function to hide or show our options frame, simply determine which by it's current state
function Gypsy_OptionsFrameToggle()
	if (Gypsy_OptionsFrame:IsVisible()) then
		HideUIPanel(Gypsy_OptionsFrame);
	else
		ShowUIPanel(Gypsy_OptionsFrame);
	end
end

-- Setup variable loading for our lock button
function Gypsy_LockButtonOnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

-- Setup our lock variable and register it for saving
function Gypsy_LockButtonOnEvent()
	if (event == "VARIABLES_LOADED") then
		if (GYPSY_LOCKALL == nil) then
			GYPSY_LOCKALL = 0;
		end
		if (GYPSY_LOCKALL == 1) then
			this:SetChecked(1);
		else
			this:SetChecked(0);
		end
		RegisterForSave("GYPSY_LOCKALL");
	end
end

-- Change our lock variable depending on the state of the check button
function Gypsy_LockButtonOnClick()
	if (this:GetChecked()) then
		GYPSY_LOCKALL = 1;
	else
		GYPSY_LOCKALL = 0;
	end
end