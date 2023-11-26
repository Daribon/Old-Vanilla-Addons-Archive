--[[

	Insomniax LootLink shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	3/29/2005
	
	- Adds a button attached to the mini-map to access the LootLink panel.

]]

nIX_DEFAULTANGLE = 295;

function Insomniax_LootLink_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the Kill Log Panel.", 1.0, 1.0, 1.0);
end


function Insomniax_LootLink_OptionsFrameToggle (arg1)
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_LootLink_Button,true,nIX_DEFAULTANGLE);
	else
		if (LootLinkFrame:IsVisible()) then
			HideUIPanel(LootLinkFrame);
			PlaySound("igMainMenuQuit");
		else
			ShowUIPanel(LootLinkFrame);
			PlaySound("igMainMenuOption");
		end
	end
end