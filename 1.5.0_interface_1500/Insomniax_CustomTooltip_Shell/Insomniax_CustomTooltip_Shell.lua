--[[

	Insomniax Custom Tooltip shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	03/29/2005
	
	- Adds a button attached to the mini-map to access the Custom Tooltips UI mod menu.

]]

nIX_DEFAULTANGLE = 311;

function Insomniax_CustomTooltip_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the Custom Tooltips options menu.", 1.0, 1.0, 1.0);
end


function Insomniax_CustomTooltip_OptionsFrameToggle (arg1)
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_CustomTooltip_Button,true,nIX_DEFAULTANGLE);
	else
		if (CustomTooltipFrame:IsVisible()) then
		
			HideUIPanel(CustomTooltipFrame);
			PlaySound("igMainMenuQuit");
		else
			ShowUIPanel(CustomTooltipFrame);
			CustomTooltip_showFrame(CustomTooltipMouse);
			PlaySound("igMainMenuOption");
		end
	end
end