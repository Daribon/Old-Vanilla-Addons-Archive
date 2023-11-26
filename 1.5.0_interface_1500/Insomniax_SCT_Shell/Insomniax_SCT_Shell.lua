--[[

	Insomniax SCT shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	3/29/2005
	
	- Adds a button attached to the mini-map to access the SCT UI mod menu.

]]

nIX_DEFAULTANGLE = 359;

function Insomniax_SCT_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the Kill Log Panel.", 1.0, 1.0, 1.0);
end


function Insomniax_SCT_OptionsFrameToggle (arg1)
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_SCT_Button,true,nIX_DEFAULTANGLE);
	else
		if (SCTOptions:IsVisible()) then
			HideUIPanel(SCTOptions);
			PlaySound("igMainMenuQuit");
		else
			ShowUIPanel(SCTOptions);
			PlaySound("igMainMenuOption");
		end
	end
end