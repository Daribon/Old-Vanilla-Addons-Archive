--[[

	Insomniax Kill Log shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	3/29/2005
	
	- Adds a button attached to the mini-map to access the Kill Log UI mod menu.

]]

nIX_DEFAULTANGLE = 343;

function Insomniax_KillLog_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the Kill Log Panel.", 1.0, 1.0, 1.0);
end


function Insomniax_KillLog_OptionsFrameToggle (arg1)
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_KillLog_Button,true,nIX_DEFAULTANGLE);
	else
		ToggleKillLog("KillLog_GeneralFrame");
	end
end
