FRAMERATEDISPLAY_GOOD = 30;
FRAMERATEDISPLAY_POOR = 20;
FRAMERATEDISPLAY_BAD = 10;
FRAMERATEDISPLAY_FREQUENCY = 0.25;

function FramerateDisplay_OnLoad()
	FramerateDisplayFrame.fpsTime = 0;
end 

function FramerateDisplay_Update(elapsed)
	local timeLeft = this.fpsTime - elapsed
	if ( timeLeft <= 0 ) then
		this.fpsTime = FRAMERATEDISPLAY_FREQUENCY;

		local framerate = GetFramerate();
		if (framerate > FRAMERATEDISPLAY_GOOD) then
			FD_FramerateText:SetTextColor(0, 1, 0);									
		elseif (framerate > FRAMERATEDISPLAY_POOR) then
			FD_FramerateText:SetTextColor(1, 1, 0);
		else
			FD_FramerateText:SetTextColor(1, 0, 0);
		end

		FD_FramerateText:SetText("FPS: "..format("%.1f", framerate));
	else
		this.fpsTime = timeLeft;
	end

end


