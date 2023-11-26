--[[

	Insomniax Atlas shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	3/29/2005
	
	- Adds a button attached to the mini-map to access the Atlas panel.

]]

nIX_DEFAULTANGLE = 279;

function Insomniax_Atlas_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the Atlas Panel.", 1.0, 1.0, 1.0);
end


function Insomniax_Atlas_OptionsFrameToggle (arg1)
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_Atlas_Button,true,nIX_DEFAULTANGLE);
	else
		if (AtlasFrame:IsVisible()) then
			HideUIPanel(AtlasFrame);
			PlaySound("igMainMenuQuit");
		else
			ShowUIPanel(AtlasFrame);
			PlaySound("igMainMenuOption");
		end
	end
end