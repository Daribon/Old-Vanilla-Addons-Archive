--[[

	Insomniax  v1.0
	by Ramdor, http://www.insomniax.net
	3/29/2005
	- 

]]

IX_sButtonID = "";
IX_nIconPosition = 0;

local function getIconPos(sButtonID, nDefaultAngle)
	-- get pos for a button, add it to the array if not there
	local oIconPos = IX_IconPositions[sButtonID]

	if (oIconPos) then
		return oIconPos.nPosition;
	else
		-- add
		IX_IconPositions[sButtonID] = { };
		IX_IconPositions[sButtonID].nPosition = nDefaultAngle;
		return nDefaultAngle;
	end
end

local function moveButton (oButton, nAngle)
	oButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 57 - (80 * cos(nAngle)), (80 * sin(nAngle)) - 58);
end

function Insomniax_IconMover_MoveButton (nIconPos,sButtonID)
	local oButton = getglobal(sButtonID);

	if (oButton) then
		IX_IconPositions[sButtonID].nPosition = nIconPos;
		moveButton(oButton, nIconPos);
	end
end

function Insomniax_InitialiseIconMover (oButton, bShowFrame, nDefaultAngle)
	if( not IX_IconPositions ) then
		IX_IconPositions = { };
	end

	local sButtonID = oButton:GetName();

	IX_sButtonID = sButtonID;
	IX_nIconPosition = getIconPos(sButtonID, nDefaultAngle);
	Insomniax_IconMover_MoveButton(IX_nIconPosition,IX_sButtonID);

	if bShowFrame then
		if (not IX_IconSettingsFrame:IsVisible()) then
			IX_IconSettingsFrame:Show();
		end
		IX_Slider:SetValue(IX_nIconPosition);
	end
end

function Insomniax_HideIconMover ()
	if (IX_IconSettingsFrame:IsVisible()) then
		IX_IconSettingsFrame:Hide();
	end
end

function Insomniax_OnEvent ()
	local oIconPos;
	local nIndex;

	if(event=="VARIABLES_LOADED") then
		-- DEFAULT_CHAT_FRAME:AddMessage(">>>MOVEMOD<<< Variables Loaded!!!!!!!!!!");

		if( IX_IconPositions ) then
			-- position all icons
			for sIndex, oIconPos in IX_IconPositions do
				Insomniax_IconMover_MoveButton (oIconPos.nPosition,sIndex);
			end
		end
	end
end
