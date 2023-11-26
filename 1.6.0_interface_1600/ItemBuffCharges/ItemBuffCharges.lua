--[[

	ItemBuffCharges: Adding charges to the item buff icons.

	Created by sarf.
	
	History:
	
	v0.05 - 2005-07-03 - sarf
	
	* Twiddled with the Khaos settings. Should now default correctly.
	* Checked out the slashcommand thingy. May work better with Khaos&Sky now.
	
	v0.04 - 2005-07-03 - sarf
	
	* *Really* fixed the time bug (only fixed the color in previous fixes).
	
	v0.03 - 2005-07-03 - sarf
	
	* Fixed the time bug.
	* Will not show charges if zero.
	
	v0.02 - 2005-07-03 - sarf
	
	* Fixed the error with Khaos registration, slash command registration and such.
	* Made own duration update function.
	
	v0.01 - 2005-07-03 - sarf
	
	* Created with Cosmos, Khaos and slash configuration.
	
]]

ITEMBUFFCHARGES_VERSION = "v0.05";
ITEMBUFFCHARGES_WARNING_VALUE = 5;

ItemBuffCharges_Options_Default = {
	enable = true;
	chargesLow = ITEMBUFFCHARGES_WARNING_VALUE;
};

ItemBuffCharges_Options = {
};

function ItemBuffCharges_UpdateDuration(buffButton, timeLeft, charges)
	local duration = getglobal(buffButton:GetName().."Duration");
	local str = nil;
	if ( timeLeft ) then
		str = SecondsToTimeAbbrev(timeLeft);
	end
	if ( charges ) and (charges > 0) then
		if ( not str ) then
			str = "";
		else
			str = str.."\n";
		end
		str = str..string.format(ITEMBUFFCHARGES_FORMAT_CHARGE, charges);
	end
	if ( str ) and ( strlen(str) > 0 ) then
		duration:SetText(str);
		local color = NORMAL_FONT_COLOR;
		if ( SHOW_BUFF_DURATIONS == "1" and timeLeft ) then
			if ( timeLeft < BUFF_DURATION_WARNING_TIME ) then
				color = HIGHLIGHT_FONT_COLOR;
			end
		end
		if ( charges ) and ( charges > 0 ) then
			if ( ItemBuffCharges_Options ) and ( ItemBuffCharges_Options.chargesLow ) then
				local chargesLow = ItemBuffCharges_Options.chargesLow;
				if ( chargesLow > 0 ) and ( charges < chargesLow ) then
					color = HIGHLIGHT_FONT_COLOR;
				end
			end
		end
		duration:SetVertexColor(color.r, color.g, color.b);
		duration:Show();
	else
		duration:Hide();
	end
end


function ItemBuffCharges_UpdateEnchant(enchant)
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
	
	local charges, expiration = nil, nil;
	local str = nil;
	local id = nil;
	
	if ( enchant:IsVisible() ) then
		id = enchant:GetID();
		if ( id == 17 ) then
			charges = offHandCharges;
			expiration = offHandExpiration;
		elseif ( id == 16 ) then
			charges = mainHandCharges;
			expiration = mainHandExpiration;
		else
			charges = nil;
			expiration = nil;
		end
		if ( expiration ) or ( charges ) then
			ItemBuffCharges_UpdateDuration(enchant, expiration/1000, charges);
		end
	end
end

function ItemBuffCharges_BuffFrame_Enchant_OnUpdate(elapsed)
	ItemBuffCharges_Saved_BuffFrame_Enchant_OnUpdate(elapsed);
	if ( not ItemBuffCharges_Options.enable ) then
		return;
	end
	ItemBuffCharges_UpdateEnchant(TempEnchant1);
	ItemBuffCharges_UpdateEnchant(TempEnchant2);
end


function ItemBuffCharges_Register_Slash()
	local sName = "ITEMBUFFCHARGES";
	SlashCmdList[sName] = ItemBuffCharges_SlashCommand;
	for k, v in ITEMBUFFCHARGES_SLASH_CMDS do
		setglobal("SLASH_"..sName..k, v);
	end
end

function ItemBuffCharges_OnLoad()
	local f = ItemBuffChargesFrame;
	f:RegisterEvent("VARIABLES_LOADED");
	ItemBuffCharges_Saved_BuffFrame_Enchant_OnUpdate = BuffFrame_Enchant_OnUpdate;
	BuffFrame_Enchant_OnUpdate = ItemBuffCharges_BuffFrame_Enchant_OnUpdate;

	if ( not ItemBuffCharges_Register_Khaos() ) then
		ItemBuffCharges_Register_Cosmos();
		ItemBuffCharges_Register_Slash();
	elseif ( not Sky ) then
		ItemBuffCharges_Register_Slash();
	end
	
	if ( ITEMBUFFCHARGES_INIT ) and ( strlen(ITEMBUFFCHARGES_INIT) > 0 ) then
		ItemBuffCharges_Print(string.format(ITEMBUFFCHARGES_INIT, ITEMBUFFCHARGES_VERSION));
	end
end

function ItemBuffCharges_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		for k, v in ItemBuffCharges_Options_Default do
			if ( ItemBuffCharges_Options[k] == nil ) then
				ItemBuffCharges_Options[k] = v;
			end
		end
		return;
	end
end

function ItemBuffCharges_SetEnabled(value)
	if ( not value ) then
		ItemBuffCharges_Options.enable = false;
	else
		ItemBuffCharges_Options.enable = true;
	end
end


function ItemBuffCharges_Print(msg)
	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0.1);
	end
end

function ItemBuffCharges_SlashCommand_Usage()
	for k, v in ITEMBUFFCHARGES_SLASH_USAGE do
		ItemBuffCharges_Print(v);
	end
	ItemBuffCharges_SlashCommand_ShowState();
end

function ItemBuffCharges_SlashCommand_ShowState()
	ItemBuffCharges_Print(string.format(ITEMBUFFCHARGES_SLASH_STATE, v));
end

function ItemBuffCharges_SlashCommand_Enable(value)
	ItemBuffCharges_SetEnabled(value);
	local v = ITEMBUFFCHARGES_SLASH_ENABLED;
	if ( not value ) then
		v = ITEMBUFFCHARGES_SLASH_DISABLED;
	end
	ItemBuffCharges_SlashCommand_ShowState();
end

function ItemBuffCharges_SlashCommand(msg)
	if ( not msg ) or ( strlen(msg) <= 0 ) then
		ItemBuffCharges_SlashCommand_Usage();
		return;
	end
	for k, v in ITEMBUFFCHARGES_SLASH_ENABLE do
		if ( string.find(msg, v) ) then
			ItemBuffCharges_SlashCommand_Enable(true);
			return;
		end
	end
	for k, v in ITEMBUFFCHARGES_SLASH_DISABLE do
		if ( string.find(msg, v) ) then
			ItemBuffCharges_SlashCommand_Enable(false);
			return;
		end
	end

	ItemBuffCharges_SlashCommand_Usage();
end
