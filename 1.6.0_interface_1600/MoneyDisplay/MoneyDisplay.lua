-- MoneyDisplay v1.7.1 (Concept and original design by Sphinx)
-- Alpha and border functionality submitted by Rabbit
-- Implemented change of Command Line Call from /moneydisplay to /money as suggested by Rabbit
-- Implemented save window position based on code supplied by MentllyGuitarded

-- 
-------------------
-- Global variables
-------------------

MoneyDisplay_DEFAULT_ON = 1;
-- MoneyDisplay_DEFAULT_LOCKED = nil;
MoneyDisplay_DEFAULT_ALPHA = 255;
MoneyDisplay_DEFAULT_BORDER = 1;
MoneyDisplay_DEFAULT_dispX = GetScreenWidth()/2;
MoneyDisplay_DEFAULT_dispY = 740;

-------------------
-- OnLoad Function
-------------------

function MD_OnLoad()

	-- Set Variables if required
        MoneyDisplay_SetVariables();

	-- Register the events that need to be watched
	RegisterForSave("MoneyDisplaySettings");
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register the slash command
	SLASH_MONEY1 = "/money";
	SlashCmdList["MONEY"] = function(msg)
		MoneyDisplay_SlashCommand(msg);
	end

      if( DEFAULT_CHAT_FRAME ) then
         --DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay AddOn loaded");
      end
         --UIErrorsFrame:AddMessage("MoneyDisplay AddOn loaded", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	if ( UltimateUI_RegisterConfiguration ) then 
		UltimateUI_RegisterConfiguration(
			"UUI_MONEYDISPLAY",
			"SECTION",
			"Money Display",
			"Shows how much money you have in a small, moveable frame."
			);
		UltimateUI_RegisterConfiguration(
			"UUI_MONEY_TOGGLE", -- CVAr
			"CHECKBOX",
			"Toggle Money Display",
			"Check this box to enable Money Display.",
			MD_toggle,
			9
			);
		UltimateUI_RegisterConfiguration(
			"UUI_MDBORDER_TOGGLE", -- CVAr
			"CHECKBOX",
			"Toggle Border",
			"Check this box to enable the border on Money Display.",
			MD_Border_Toggle,
			0
			);
		UltimateUI_RegisterConfiguration("UUI_MD_RESET",   -- registered name
			"BUTTON",													-- register type
			"Reset Money Display",								-- short description
			"Click this button to reset the settings for Money Display.",						-- long description
			MD_Reset,										-- function
			0,						-- useless
			0,						-- useless
			0,						-- useless
			0,						-- useless
			"Reset"		-- button text
		);
	end

end

--------------------
-- OnEvent Event
--------------------

function MD_OnEvent()

	-- If the settings are loaded then update the display
	if(event == "VARIABLES_LOADED") then
		MoneyDisplay_Update();
	end

end

--------------------
-- Set Variables
--------------------

function MoneyDisplay_SetVariables()

	if not (MoneyDisplaySettings) then
		-- Default Settings
		MoneyDisplaySettings = { };
		MoneyDisplaySettings.on = MoneyDisplay_DEFAULT_ON;
		-- MoneyDisplaySettings.locked = MoneyDisplay_DEFAULT_LOCKED;
		MoneyDisplaySettings.alpha = MoneyDisplay_DEFAULT_ALPHA;
		MoneyDisplaySettings.border = MoneyDisplay_DEFAULT_BORDER;
		MoneyDisplaySettings.dispX = MoneyDisplay_DEFAULT_dispX;
		MoneyDisplaySettings.dispY = MoneyDisplay_DEFAULT_dispY;
	end
end

function MoneyDisplay_ResetVariables()

	-- Reset Settings
	MoneyDisplaySettings = { };
	MoneyDisplaySettings.on = MoneyDisplay_DEFAULT_ON;
	-- MoneyDisplaySettings.locked = MoneyDisplay_DEFAULT_LOCKED;
	MoneyDisplaySettings.alpha = MoneyDisplay_DEFAULT_ALPHA;
	MoneyDisplaySettings.border = MoneyDisplay_DEFAULT_BORDER;
	MoneyDisplaySettings.dispX = MoneyDisplay_DEFAULT_dispX;
	MoneyDisplaySettings.dispY = MoneyDisplay_DEFAULT_dispY;
end

--------------------
-- OnUpdate Function
--------------------

function MD_OnUpdate(arg1)
   -- Below code provided by Karmond of worldofwar.net forums
	local gold = floor(GetMoney()/10000);
	local silver = floor((GetMoney()-gold*10000)/100);
	local copper = GetMoney()-gold*10000-silver*100;
   -- End of used code.

        MD_GoldText:SetText(""..(gold).."    ");
	MD_SilverText:SetText(""..(silver).."    ");
	MD_CopperText:SetText(""..(copper).."    ");
end

function MD_toggle()
	if( MoneyDisplaySettings.on == nil ) then
		MoneyDisplaySettings.on = 1;
		MoneyDisplay_Update();
	else
		MoneyDisplaySettings.on = nil;
		MoneyDisplay_Update();
	end
end

function MD_Reset()
	MoneyDisplay_ResetVariables();
	MoneyDisplay_Update();
end

function MD_Border_Toggle()
	if( MoneyDisplaySettings.border == nil ) then
		MoneyDisplaySettings.border = 1;
		MoneyDisplay_Update();
	else
		MoneyDisplaySettings.border = nil;
		MoneyDisplay_Update();
	end
end

--------------------
-- Slash Commands
--------------------

function MoneyDisplay_SlashCommand(msg)

	-- Check the command
	if(msg) then
		local command = string.lower(msg);
		
		if(command == "show") then
			MoneyDisplaySettings.on = 1;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Show");

		elseif(command == "hide") then
			MoneyDisplaySettings.on = nil;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Hide");

		elseif(command == "reset") then
			MoneyDisplay_ResetVariables();
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Reset");

		-- elseif(command == "lock") then
		--	MoneyDisplaySettings.locked = 1;
		--	MoneyDisplay_Update();
		--	DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Locked");

		-- elseif(command == "unlock") then
		--	MoneyDisplaySettings.locked = nil;
		--	MoneyDisplay_Update();
		--	DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Unlocked");

		elseif(command == "hideborder") then
			MoneyDisplaySettings.border = nil;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Border Hidden");

		elseif(command == "showborder") then
			MoneyDisplaySettings.border = 1;
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Border Shown");

		elseif(string.find(command, "alpha") ~= nul) then
			local i, j = string.find(command, "%d+");
			if (i ~= nil) then
				MoneyDisplay_Alpha(tonumber(string.sub(command, i, j), 10));
			end
			MoneyDisplay_Update();
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Alpha Set");

		else
			DEFAULT_CHAT_FRAME:AddMessage("MoneyDisplay Command List");
			DEFAULT_CHAT_FRAME:AddMessage("");
			DEFAULT_CHAT_FRAME:AddMessage("/money reset - Reset all defaults");
			DEFAULT_CHAT_FRAME:AddMessage("/money show - Shows the mod");
			DEFAULT_CHAT_FRAME:AddMessage("/money hide - Hides the mod");
			DEFAULT_CHAT_FRAME:AddMessage("/money hideborder - Hides window border");
			DEFAULT_CHAT_FRAME:AddMessage("/money showborder - Shows window border");
			DEFAULT_CHAT_FRAME:AddMessage("/money alpha 0-255 - Set the background transparency (0 = transparent, 255 = solid)");
		end
	end

	MD_Frame:ClearAllPoints();
	MD_Frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", MoneyDisplaySettings.dispX, MoneyDisplaySettings.dispY);

end

function MoneyDisplay_Alpha(iAlpha)
	if (iAlpha >= 0 and iAlpha <= 255) then
		MoneyDisplaySettings.alpha = iAlpha;
	end
end

--------------------
-- Update Function
--------------------

function MoneyDisplay_Update()

	-- Apply the display settings
	if(MoneyDisplaySettings) then
		if(MoneyDisplaySettings.on) then
			MD_Frame:Show();
		else
			MD_Frame:Hide();
		end

		if (MoneyDisplaySettings.border) then
			MD_Frame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 1.0);
		else
			MD_Frame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0);
		end

		if (MoneyDisplaySettings.alpha) then
			MD_Frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, MoneyDisplaySettings.alpha / 255);
		else
			MD_Frame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1);
		end

		-- if(MoneyDisplaySettings.locked) then
			-- MD_Frame:SetHeight(0);
			-- MD_Frame:SetWidth(0);
		-- else
			-- MD_Frame:SetHeight(26);
			-- MD_Frame:SetWidth(155);
		-- end

	end
end

function MD_SavePosition()
    MoneyDisplaySettings.dispX = this:GetLeft();
    MoneyDisplaySettings.dispY = this:GetBottom();
end