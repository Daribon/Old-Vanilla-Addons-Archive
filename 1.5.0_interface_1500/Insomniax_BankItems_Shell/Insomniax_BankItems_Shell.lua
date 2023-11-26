--[[

	Insomniax BankItems shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	3/29/2005
	
	- Adds a button attached to the mini-map to access the BankItems panel.

]]

nIX_DEFAULTANGLE = 263;

function Insomniax_BankItems_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the Bank Items Panel.", 1.0, 1.0, 1.0);
end


function Insomniax_BankItems_OptionsFrameToggle ()
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_BankItems_Button,true,nIX_DEFAULTANGLE);
	else
		if (BankItems_Frame:IsVisible()) then
			BankItems_Frame:Hide();
			PlaySound("igMainMenuQuit");
		else
			BankItems_SlashHandler();
			PlaySound("igMainMenuOption");
		end
	end
end