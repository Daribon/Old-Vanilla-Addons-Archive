local incombat = false;
local combobarenabled = true;
local baseBorderY = -1;
local baseBarY = -3;
local MassoComboBar_Version = 12;
local MassoComboBar_DefaultConfig = {show = true,
					combat = false,
					targetpos = "below",
					version = MassoComboBar_Version
};


function MassoComboBar_MoveTargetBar(state)
    if (MassoComboBarFrame:IsVisible()) then
        local targetBorderY = baseBorderY;
        local targetBarY = baseBarY;
        local comboBorderY = baseBorderY;
        local comboBarY = baseBarY;
        
        if (state == "below") then
            targetBorderY = targetBorderY -5;
            targetBarY = targetBarY -5;
        else
            comboBorderY = comboBorderY -5;
            comboBarY = comboBarY -5;
        end
        
        MassoBorderTargetHealth:SetPoint("TOPLEFT", "MassoComboBarFrame", "TOPLEFT", 2, targetBorderY);
        MassoBorderTargetHealthTexture:SetPoint("TOPLEFT", "MassoBorderTargetHealth", "TOPLEFT", 2, targetBorderY);
        MassoTargetHealthText:SetPoint("CENTER", "MassoBorderTargetHealth", "CENTER", 2, targetBorderY);
        MassoTargetHealthBar:SetPoint("TOPLEFT", "MassoBorderTargetHealth", "TOPLEFT", 4, targetBarY);
        
        local i = 0;
        local width = 3;
        for i = 1, 5 do
            local obj = getglobal("MassoBorder" .. i);
            obj:SetPoint("TOPLEFT", "MassoComboBarFrame", "TOPLEFT", width, comboBorderY);
            
            obj = getglobal("MassoBorder" .. i .. "Texture");
            obj:SetPoint("TOPLEFT", "MassoBorder" .. i, "TOPLEFT", width, comboBorderY);
            
            obj = getglobal("MassoCombo" .. i);
            obj:SetPoint("TOPLEFT", "MassoBorder" .. i, "TOPLEFT", width + 2, comboBarY);
            
            width = width + 10;
        end
    end
end

function MassoComboBar_FlipTarget()
    if (MassoComboBar_Config.targetpos == "below") then
        MassoComboBar_MoveTargetBar("above");
        MassoComboBar_Config.targetpos = "above";
    else
        MassoComboBar_MoveTargetBar("below");
        MassoComboBar_Config.targetpos = "below";
    end
end

function MassoComboBar_OnLoad()
	for i = 1, 5, 1 do
		local barname = getglobal("MassoCombo"..i);
		barname:SetStatusBarColor(1, 0, 0);
		barname:SetMinMaxValues(0, 1);
		barname:SetValue(0);
	end
	local barname = getglobal("MassoEnergyBar");
	barname:SetStatusBarColor(1, 1, 0);
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MAXHEALTH");
	this:RegisterEvent("UNIT_ENERGY");
	this:RegisterEvent("UNIT_MAXENERGY");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	SlashCmdList["MASSOCOMBOBARCOMMAND"] = MassoComboBar_SlashHandler;
	SLASH_MASSOCOMBOBARCOMMAND1 = "/mcb";
	
	MassoTargetHealthBar:SetStatusBarColor(1, 0, 0);
	MassoUpdateTargetHealthBar();
end

function MassoComboBar_Toggle()
	local mainframe = getglobal("MassoComboBarFrame");
	if (not combobarenabled) then
		if (mainframe:IsVisible()) then
			mainframe:Hide();
		end
		return;
	end
	if (MassoComboBar_Config.show) then
		if (not mainframe:IsVisible()) then
			mainframe:Show();
		end
		return;
	else
		if (not MassoComboBar_Config.combat) then
			if (mainframe:IsVisible()) then
				mainframe:Hide();
			end
			return;
		else
			if incombat then
				if (not mainframe:IsVisible()) then
					mainframe:Show();
					return;
				end
			else
				if mainframe:IsVisible() then
					mainframe:Hide();
					return;
				end
			end
		end
	end
end

function MassoComboBar_SlashHandler(msg)
	local cmd = string.lower(msg);
	if (cmd == "show") then
		MassoComboBar_Config.show = true;
		MassoComboBar_Config.combat = false;
		MassoComboBar_Toggle();
		return;
	elseif (cmd == "hide") then
		MassoComboBar_Config.show = false;
		MassoComboBar_Config.combat = false;
		MassoComboBar_Toggle();
		return;
	elseif (cmd == "combat") then
		MassoComboBar_Config.show = false;
		MassoComboBar_Config.combat = true;
		MassoComboBar_Toggle();
		return;
	elseif (cmd == "fliptarget") then
		MassoComboBar_FlipTarget();
		return;
	end
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage("Masso's Combo Bar available commands:");
		DEFAULT_CHAT_FRAME:AddMessage("/mcb show -> to show the panel");
		DEFAULT_CHAT_FRAME:AddMessage("/mcb hide -> to hide the panel");
		DEFAULT_CHAT_FRAME:AddMessage("/mcb combat -> to show the panel only when you are in combat and hide it otherwise");
		DEFAULT_CHAT_FRAME:AddMessage("/mcb fliptarget -> toggle the position of the target bar (above or below the combo point bar)");
	end
end

function MassoUpdateComboBar()
	local combo = GetComboPoints();
	local combobar = {0, 0, 0, 0, 0};
	local barcolor = {[0] = {1, 0, 0}, {1, 0, 0}, {1, 0, 0}, {1, 1, 0}, {1, 1, 0}, {0, 1, 0}};
	for i = 1, combo, 1 do
		combobar[i] = 1;
	end
	for i = 1, 5, 1 do
		local barname = getglobal("MassoCombo"..i);
		barname:SetStatusBarColor(barcolor[combo][1], barcolor[combo][2], barcolor[combo][3]);
		barname:SetValue(combobar[i]);
	end
end

function MassoUpdateHealthBar()
	local value, max = UnitHealth("player"), UnitHealthMax("player");
	local healthcolor;
	if ((value / max) <= 0.1) then
		healthcolor = {1, 0, 0};
	elseif ((value / max) >= 0.9) then
		healthcolor = {0, 1, 0};
	else
		healthcolor = {1 - ((value / max) - 0.1) / 0.8, ((value / max) - 0.1) / 0.8, 0};
	end
	local healthbar = getglobal("MassoHealthBar");
	healthbar:SetStatusBarColor(healthcolor[1], healthcolor[2], healthcolor[3]);
	healthbar:SetMinMaxValues(0, max);
	healthbar:SetValue(value);
	local healthtext = value.."/"..max;
	MassoHealthText:SetText(healthtext);
end

function MassoUpdateTargetHealthBar()
	local text = "No Target";
	local min = 0;
	local max = 0;
	local value = 0;

	-- This little snippet is pretty much straight from CTMod.
	-- Thanks go to Ts and Cide, two of the best interface scripters
	-- around.
	if (TargetFrame:IsVisible()) then
    	min, max = TargetFrameHealthBar:GetMinMaxValues();
    	value = TargetFrameHealthBar:GetValue();
    
    	if (max > 100) then
			text = value .. " / " .. max;
    	else
			text = ceil(value / max * 100) .. "%";
    	end
	end

	MassoTargetHealthBar:SetMinMaxValues(min, max);
	MassoTargetHealthBar:SetValue(value);
	MassoTargetHealthText:SetText(text);
end

function MassoUpdateEnergyBar()
	local value, max = UnitMana("player"), UnitManaMax("player");
	local energybar = getglobal("MassoEnergyBar");
	energybar:SetMinMaxValues(0, max);
	energybar:SetValue(value);
	local energytext = value.."/"..max;
	MassoEnergyText:SetText(energytext);
end

function MassoComboBar_OnEvent(event)
	if (event == "PLAYER_COMBO_POINTS") then
		MassoUpdateComboBar();
	elseif ((event == "UNIT_HEALTH") or (event == "UNIT_MAXHEALTH")) then
	    if arg1 == "player" then
		    MassoUpdateHealthBar();
		elseif arg1 == "target" then
		    MassoUpdateTargetHealthBar();
		end
	elseif ((event == "UNIT_ENERGY") and (arg1 == "player")) then
		MassoUpdateEnergyBar();
	elseif (event == "PLAYER_ENTER_COMBAT") then
		incombat = true;
		MassoComboBar_Toggle();
	elseif (event == "PLAYER_LEAVE_COMBAT") then
		incombat = false;
		MassoComboBar_Toggle();
	elseif (event == "PLAYER_TARGET_CHANGED") then
	    MassoUpdateTargetHealthBar();
	elseif (event == "VARIABLES_LOADED") then
		if ((not MassoComboBar_Config) or (not MassoComboBar_Config.version) or (MassoComboBar_Config.version ~= MassoComboBar_Version)) then
			MassoComboBar_Config = MassoComboBar_DefaultConfig;
		end
		RegisterForSave("MassoComboBar_Config");
		MassoComboBar_Toggle();
    	MassoComboBar_MoveTargetBar(MassoComboBar_Config.targetpos);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		if (not (UnitClass("player") == "Rogue")) then
			this:UnregisterEvent("PLAYER_COMBO_POINTS");
			this:UnregisterEvent("UNIT_HEALTH");
			this:UnregisterEvent("UNIT_MAXHEALTH");
			this:UnregisterEvent("UNIT_ENERGY");
			this:UnregisterEvent("UNIT_MAXENERGY");
			this:UnregisterEvent("PLAYER_ENTER_COMBAT");
			this:UnregisterEvent("PLAYER_LEAVE_COMBAT");
			combobarenabled = false;
			MassoComboBar_Toggle();
		end
	end
end
