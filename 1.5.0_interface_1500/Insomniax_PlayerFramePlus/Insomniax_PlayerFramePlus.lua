--[[

	Insomniax PlayerFramePlus v1.2
	by LedMirage, http://www.insomniax.net
	04/28/2005

]]

function IX_PlayerFrameOnLoad ()
	-- Experience registrations
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("UPDATE_EXHAUSTION");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	-- Register for variable loading to run our configuration registrations
	-- this:RegisterEvent("VARIABLES_LOADED");
end

function IX_PlayerFrameOnEvent (event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		-- We need to do an initial display of	all our values when the player first logs in.
		IX_ShowPlayerExp();
		return;
	end
	-- Added unit exp handles to update the player displayed experience numbers.
	if(event == "PLAYER_XP_UPDATE" or event == "UPDATE_EXHAUSTION" or event == "PLAYER_LEVEL_UP") then
		IX_ShowPlayerExp();
		return;
	end
	
end


function IX_ShowPlayerExp()
	local currXP = UnitXP("player");
	local nextXP = UnitXPMax("player");
	local restXP = GetXPExhaustion();

	if(restXP == nil) then
		local str = format("%s / %s", currXP, nextXP);
		IX_ExpAmount:SetText(str);
	else
		-- Divide the rested # in half because
		-- (a) that's the exp you really end up getting
		-- (b) it isn't such an absurdly huge number taking up a lot of space on the UI.

		local str = format("%s / %sxp  (+%sxp)", currXP, nextXP, (tonumber(restXP) / 2));
		IX_ExpAmount:SetText(str);
	end
end

-- ** EXPERIENCE BAR FUNCTIONS ** --

function IX_PlayerFrameExpBarOnLoad ()
	-- Experience bar registrations
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- Can not be any higher, should not be lower
	this:SetFrameLevel("1");
end

function IX_PlayerFrameExpBarOnEvent (event)
	-- Setup our experience bar when the player logs in, when experience changes, or when the player levels up
	if (event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_ENTERING_WORLD") then
		local currXP = UnitXP("player");
		local nextXP = UnitXPMax("player");
		this:SetMinMaxValues(min(0, currXP), nextXP);
		this:SetValue(currXP);
		return;
	end
end



-- ** PET BAR RELOCATION FUNCTION ** --


function IX_UpdatePetFrame()

	if(PetFrame:IsVisible()) then

		local petAnchor = {point = "TOPLEFT", rel = "PlayerFrame", relPoint="TOPLEFT", x = "80", y = "-75"};

		PetFrame:ClearAllPoints();
		PetFrame:SetPoint(petAnchor.point, petAnchor.rel, petAnchor.relPoint, petAnchor.x, petAnchor.y);
	end
end