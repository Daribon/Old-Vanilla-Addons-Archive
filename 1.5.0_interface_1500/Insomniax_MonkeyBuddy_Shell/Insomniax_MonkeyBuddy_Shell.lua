--[[

	Insomniax MonkeyBuddy shell v1.1
	by LedMirage and Ramdor, http://www.insomniax.net
	3/29/2005
	
	- Adds a button attached to the mini-map to access the MonkeyBuddy panel.

]]

nIX_DEFAULTANGLE = 327;

function Insomniax_MonkeyBuddy_ButtonOnEnter ()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("Opens the MonkeyBuddy Panel.", 1.0, 1.0, 1.0);
end


function Insomniax_MonkeyBuddy_OptionsFrameToggle (arg1)
	if (arg1=="RightButton") then
		Insomniax_InitialiseIconMover(Insomniax_MonkeyBuddy_Button,true,nIX_DEFAULTANGLE);
	else
		if (MonkeyBuddyFrame:IsVisible()) then
			HideUIPanel(MonkeyBuddyFrame);
			PlaySound("igMainMenuQuit");
		else
			ShowUIPanel(MonkeyBuddyFrame);
			-- MonkeyBuddyQuestFrame:Show();
			PlaySound("igMainMenuOption");
		end
	end
end