
-- Titan Regen v1.2
-- color mods by Justin, aka Mandingo

TITAN_REGEN_ID			= "Regen"
TITAN_REGEN_MENU_TEXT 		= "Regen"
TITAN_REGEN_MENU_TOOLTIP_TITLE	= "Regen Rates"
TITAN_REGEN_MENU_SHOW1 		= "Show"
TITAN_REGEN_MENU_SHOW2 		= "HP"
TITAN_REGEN_MENU_SHOW3 		= "MP"
TITAN_REGEN_MENU_SHOW4		= "As Percentage"

TITAN_REGEN_HP_FORMAT = "%d";
TITAN_REGEN_HP_FORMAT_PERCENT = "%.2f";
TITAN_REGEN_MP_FORMAT = "%d";
TITAN_REGEN_MP_FORMAT_PERCENT = "%.2f";

TITAN_REGEN_BUTTON_TEXT_HP 		= "HP: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_BUTTON_TEXT_HP_PERCENT 	= "HP: "..HIGHLIGHT_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_BUTTON_TEXT_MP 		= " MP: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_BUTTON_TEXT_MP_PERCENT 	= " MP: "..HIGHLIGHT_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_TOOLTIP1 		= "Health: \t"..GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." / " ..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..RED_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE..")";
TITAN_REGEN_TOOLTIP2 		= "Mana: \t"..GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." / " ..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..RED_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE..")";
TITAN_REGEN_TOOLTIP3 		= "Best HP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_TOOLTIP4 		= "Worst HP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_TOOLTIP5 		= "Best MP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_TOOLTIP6 		= "Worst MP Regen: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
TITAN_REGEN_TOOLTIP7		= "MP Regen in Last Fight: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..GREEN_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE.."%%)";

TITAN_Regen_FREQUENCY = 1;
TITAN_RegenCurrHealth = 0;
TITAN_RegenCurrMana = 0;
TITAN_RegenMP	    = 0;
TITAN_RegenHP	    = 0;
TITAN_RegenCheckedManaState = 0;
TITAN_RegenMaxHPRate = 0;
TITAN_RegenMinHPRate = 9999;
TITAN_RegenMaxMPRate = 0;
TITAN_RegenMinMPRate = 9999;
TITAN_RegenMPDuringCombat = 0;
TITAN_RegenMPCombatTrack = 0;

function TitanPanelRegenButton_OnLoad()
	this.registry = { 
		id = TITAN_REGEN_ID,
		menuText = TITAN_REGEN_MENU_TEXT, 
		buttonTextFunction = "TitanPanelRegenButton_GetButtonText",
		tooltipTitle = TITAN_REGEN_MENU_TOOLTIP_TITLE, 
		tooltipTextFunction = "TitanPanelRegenButton_GetTooltipText",
		savedVariables = {
			ShowLabelText = 1,
			ShowMPRegen = 1,
			ShowHPRegen = 1,
			ShowPercentage = TITAN_NIL,
			ShowColoredText = TITAN_NIL
		}

	};

	this.timer = 0;	
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function TitanPanelRegenButton_OnEvent()
	if ( event == "PLAYER_ENTERING_WORLD") then
		if (UnitManaMax("player") == 0) then
			TitanSetVar(TITAN_REGEN_ID, "ShowMPRegen", 0);
		end
	end
	
	if ( event == "PLAYER_REGEN_DISABLED") then
		TITAN_RegenMPDuringCombat = 0;
		TITAN_RegenMPCombatTrack = 1;
	end

	if ( event == "PLAYER_REGEN_ENABLED") then
		TITAN_RegenMPCombatTrack = 0;
	end
	
	local currHealth = 0;
	local currMana = 0;
	local runUpdate = 0;
	
	if (TitanGetVar(TITAN_REGEN_ID,"ShowHPRegen") == 1) then
		if ( event == "UNIT_HEALTH" and arg1 == "player" ) then
			currHealth = UnitHealth("player");
			runUpdate = 1;
			if ( currHealth > TITAN_RegenCurrHealth and TITAN_RegenCurrHealth ~= 0 ) then
				TITAN_RegenHP = currHealth-TITAN_RegenCurrHealth;
				
				if (TITAN_RegenHP > TITAN_RegenMaxHPRate) then 
					TITAN_RegenMaxHPRate = TITAN_RegenHP;
				end
				if (TITAN_RegenHP < TITAN_RegenMinHPRate or TITAN_RegenMinHPRate == 9999) then 
					TITAN_RegenMinHPRate = TITAN_RegenHP;
				end				
			end
			TITAN_RegenCurrHealth = currHealth;
		end
	end

	if (TitanGetVar(TITAN_REGEN_ID,"ShowMPRegen") == 1) then
		if ( event == "UNIT_MANA" and arg1 == "player" ) then
			currMana = UnitMana("player");
			runUpdate = 1;
			if ( currMana  > TITAN_RegenCurrMana and TITAN_RegenCurrMana ~= 0 ) then
				TITAN_RegenMP = currMana-TITAN_RegenCurrMana;

				if (TITAN_RegenMPCombatTrack == 1) then
					TITAN_RegenMPDuringCombat = TITAN_RegenMPDuringCombat + TITAN_RegenMP;
				end 

				if (TITAN_RegenMP > TITAN_RegenMaxMPRate) then 
					TITAN_RegenMaxMPRate = TITAN_RegenMP;
				end
				if (TITAN_RegenMP < TITAN_RegenMinMPRate or TITAN_RegenMinMPRate == 9999) then 
					TITAN_RegenMinMPRate = TITAN_RegenMP;
				end								
			end
			TITAN_RegenCurrMana = currMana;
		end
	end			
	
	if (runUpdate == 1) then
		TitanPanelButton_UpdateButton(TITAN_REGEN_ID);
		TitanPanelButton_UpdateTooltip();
	end
end

function TitanPanelRegenButton_GetButtonText(id)
	local labelTextHP = "";
	local valueTextHP = "";
	local labelTextMP = "";
	local valueTextMP = "";
	local OutputStr = "";
	
	if UnitHealth("player") == UnitHealthMax("player") then
		TITAN_RegenHP = 0;
	end
	if UnitMana("player") == UnitManaMax("player") then
		TITAN_RegenMP = 0;
	end	
			
	-- safety in case both are off, then cant ever turn em on
	if (TitanGetVar(TITAN_REGEN_ID,"ShowHPRegen") == nil and TitanGetVar(TITAN_REGEN_ID,"ShowMPRegen") == nil) then
		TitanSetVar(TITAN_REGEN_ID,"ShowHPRegen",1);
	end
	
	if (TitanGetVar(TITAN_REGEN_ID,"ShowHPRegen") == 1) then
		labelTextHP = "HP: ";
		if (TitanGetVar(TITAN_REGEN_ID,"ShowPercentage") == 1) then
			valueTextHP = format(TITAN_REGEN_HP_FORMAT_PERCENT, (TITAN_RegenHP/UnitHealthMax("player"))*100);
		else
			valueTextHP = format(TITAN_REGEN_HP_FORMAT, TITAN_RegenHP);	
		end
		if (TitanGetVar(TITAN_REGEN_ID, "ShowColoredText")) then
			valueTextHP = TitanUtils_GetGreenText(valueTextHP);
		else
			valueTextHP = TitanUtils_GetHighlightText(valueTextHP);
		end		
	end
	
	if (TitanGetVar(TITAN_REGEN_ID,"ShowMPRegen") == 1) then
		labelTextMP = "MP: ";
		if (TitanGetVar(TITAN_REGEN_ID,"ShowPercentage") == 1) then
			valueTextMP = format(TITAN_REGEN_MP_FORMAT_PERCENT, (TITAN_RegenMP/UnitManaMax("player"))*100);
		else
			valueTextMP = format(TITAN_REGEN_MP_FORMAT, TITAN_RegenMP);			
		end
		if (TitanGetVar(TITAN_REGEN_ID, "ShowColoredText")) then
			valueTextMP = TitanRegenTemp_GetColoredTextRGB(valueTextMP, 0.0, 0.0, 1.0);
		else
			valueTextMP = TitanUtils_GetHighlightText(valueTextMP);
		end			
	end

	-- supports turning off labels
	return labelTextHP, valueTextHP, labelTextMP, valueTextMP;
end

function TitanPanelRegenButton_GetTooltipText()

	local minHP = TITAN_RegenMinHPRate;
	local minMP = TITAN_RegenMinMPRate;
	
	if minHP == 9999 then minHP = 0 end;
	if minMP == 9999 then minMP = 0 end;	

	if (TitanGetVar(TITAN_REGEN_ID,"ShowMPRegen") == 1) then
		local regenPercent;		
		regenPercent = (TITAN_RegenMPDuringCombat/UnitManaMax("player"))*100;
		
		return ""..
			format(TITAN_REGEN_TOOLTIP1, UnitHealth("player"),UnitHealthMax("player"),UnitHealthMax("player")-UnitHealth("player")).."\n"..
			format(TITAN_REGEN_TOOLTIP2, UnitMana("player"),UnitManaMax("player"),UnitManaMax("player")-UnitMana("player")).."\n"..
			format(TITAN_REGEN_TOOLTIP3, TITAN_RegenMaxHPRate).."\n"..
			format(TITAN_REGEN_TOOLTIP4, minHP).."\n"..
			format(TITAN_REGEN_TOOLTIP5, TITAN_RegenMaxMPRate).."\n"..
			format(TITAN_REGEN_TOOLTIP6, minMP).."\n"..
			format(TITAN_REGEN_TOOLTIP7, TITAN_RegenMPDuringCombat, regenPercent).."\n"			
			;				
	else
		return ""..
			format(TITAN_REGEN_TOOLTIP1, UnitHealth("player"),UnitHealthMax("player"),UnitHealthMax("player")-UnitHealth("player")).."\n"..
			format(TITAN_REGEN_TOOLTIP3, TITAN_RegenMaxHPRate).."\n"..
			format(TITAN_REGEN_TOOLTIP4, minHP).."\n"
			;				
	end
end

function TitanPanelRightClickMenu_PrepareRegenMenu()
	local id = TITAN_REGEN_ID;
	local info;

	TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_CUSTOMIZE..TITAN_PANEL_MENU_POPUP_IND, id, TITAN_PANEL_MENU_FUNC_CUSTOMIZE);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, id, TITAN_PANEL_MENU_FUNC_HIDE);	
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleLabelText("Regen");
	
	TitanPanelRightClickMenu_AddTitle(TITAN_REGEN_MENU_SHOW1);
				
	info = {};
	info.text = TITAN_REGEN_MENU_SHOW2;
	info.func = TitanRegen_ShowHPRegen;
	info.checked = TitanGetVar(TITAN_REGEN_ID,"ShowHPRegen");
	UIDropDownMenu_AddButton(info);
	
	info = {};
	info.text = TITAN_REGEN_MENU_SHOW3;
	info.func = TitanRegen_ShowMPRegen;
	info.checked = TitanGetVar(TITAN_REGEN_ID,"ShowMPRegen");
	UIDropDownMenu_AddButton(info);
	
	info = {};
	info.text = TITAN_REGEN_MENU_SHOW4;
	info.func = TitanRegen_ShowPercentage;
	info.checked = TitanGetVar(TITAN_REGEN_ID,"ShowPercentage");
	UIDropDownMenu_AddButton(info);
	
	info = {};
	info.text = TITAN_PANEL_MENU_SHOW_COLORED_TEXT;
	info.func = TitanRegen_ShowColoredText;
	info.checked = TitanGetVar(TITAN_REGEN_ID, "ShowColoredText");
	UIDropDownMenu_AddButton(info);		
	
end

function TitanRegen_UpdateSettings()	
	-- safety in case both are off, then cant ever turn em on
	if (TitanGetVar(TITAN_REGEN_ID,"ShowHPRegen") == nil and TitanGetVar(TITAN_REGEN_ID,"ShowMPRegen") == nil) then
		TitanSetVar(TITAN_REGEN_ID,"ShowHPRegen",1);
	end
	TitanPanelButton_UpdateButton(TITAN_REGEN_ID);
end

function TitanRegen_ShowHPRegen()
	TitanToggleVar(TITAN_REGEN_ID, "ShowHPRegen");
	TitanRegen_UpdateSettings();
end

function TitanRegen_ShowMPRegen()
	TitanToggleVar(TITAN_REGEN_ID, "ShowMPRegen");
	TitanRegen_UpdateSettings();
end

function TitanRegen_ShowPercentage()
	TitanToggleVar(TITAN_REGEN_ID, "ShowPercentage");
	TitanRegen_UpdateSettings();
end

function TitanRegen_ShowColoredText()
	TitanToggleVar(TITAN_REGEN_ID, "ShowColoredText");
	TitanRegen_UpdateSettings();
end

-----------------------------------------------------------------------------
--TitanRegenTemp_GetColoredTextRGB
--    added: 5/1/2005 by Mandingo
--    Purpose - Get the appropriate text formatting codes baed on RGB values
--    Parameters - r red code
--		   b blue code
--		   g green code
--    Returns - Color format code for the text item (red, green, blue)
function TitanRegenTemp_GetColoredTextRGB(text, r, g, b)
	if (text and r and g and b) then
		local redColorCode = format("%02x", r * 255);		
		local greenColorCode = format("%02x", g * 255);
		local blueColorCode = format("%02x", b * 255);		
		local colorCode = "|cff"..redColorCode..greenColorCode..blueColorCode;
		return colorCode..text..FONT_COLOR_CODE_CLOSE;
	end
end