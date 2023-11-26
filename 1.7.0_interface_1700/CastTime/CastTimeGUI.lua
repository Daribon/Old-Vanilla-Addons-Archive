function CastTime_Register()
	-- Prefer Khaos over Cosmos
	if (Khaos) then
		CastTime_Khaos_Register()
	elseif (Cosmos_RegisterConfiguration) then
		CastTime_Cosmos_Register()
	else
	end

	SlashCmdList["CASTTIME"] = CastTime_SlashHandler;
	SLASH_CASTTIME1 = "/castt";
end

function CastTime_OnVLoad()
	CastTime_Toggle_flock(CastTime.flock);
	CastTime_Toggle_mf(CastTime.mf);
end

function CastTime_Toggle_display(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.display = 0;
		CastTime_Print(CASTTIME_STATUS_DISPLAY..CASTTIME_OFF);
	else
		CastTime.display = 1;
		CastTime_Print(CASTTIME_STATUS_DISPLAY..CASTTIME_ON);
	end
end

function CastTime_Toggle_il(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.inline = 0;
		CastingBarText:SetText(CastTime.spellname);
		CastTime_Print(CASTTIME_STATUS_IL..CASTTIME_OFF);
	else
		CastTime.inline = 1;
		CastTime_Print(CASTTIME_STATUS_IL..CASTTIME_ON);
	end
end

function CastTime_Toggle_ol(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.outline = 0;
		CastTime_Print(CASTTIME_STATUS_OL..CASTTIME_OFF);
	else
		CastTime.outline = 1;
		CastTime_Print(CASTTIME_STATUS_OL..CASTTIME_ON);
	end
end

function CastTime_Toggle_delay(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.delay = 0;
		CastTime_Print(CASTTIME_STATUS_DELAY..CASTTIME_OFF);
	else
		CastTime.delay = 1;
		CastTime_Print(CASTTIME_STATUS_DELAY..CASTTIME_ON);
	end
end

function CastTime_Toggle_hun(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.hun = 0;
		CastTime_Print(CASTTIME_STATUS_HUN..CASTTIME_OFF);
	else
		CastTime.hun = 1;
		CastTime_Print(CASTTIME_STATUS_HUN..CASTTIME_ON);
	end
end

function CastTime_Toggle_flock(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.flock = 0;
		CastTimeMF:SetBackdropColor(0, 0.1, 0.9, 0.5);
		CastTimeMF:SetBackdropBorderColor(0, 0.6, 0.8, 0.8);
		local z1, z2;
		if (CastTime.hun == 0) then
			z1=4.5;
			z2=3.2;
		else
			z1=4.53;
			z2=3.29;
		end
		CastTimeMFText:SetText("|cffcc0000+"..z1.."|r "..z2);
		CastTime_Print(CASTTIME_STATUS_FLOCK..CASTTIME_OFF);
	else
		CastTime.flock = 1;
		CastTimeMF:SetBackdropColor(0, 0, 0, 0);
		CastTimeMF:SetBackdropBorderColor(0, 0, 0, 0);
		CastTimeMFText:SetText("");
		CastTime_Print(CASTTIME_STATUS_FLOCK..CASTTIME_ON);
	end
end

function CastTime_Toggle_mf(toggle)
	if (type(toggle) == "table") then
		--Convert Khaos table to checked value
		if (toggle.checked == false) then
			toggle = 0;
		else
			toggle = 1;
		end
	end
	if (toggle == 0) then
		CastTime.mf = 0;
		CastTimeMF:Hide();
		CastTime_Print(CASTTIME_STATUS_MF..CASTTIME_OFF);
	else
		CastTime.mf = 1;
		CastTimeMF:Show();
		CastTime_Print(CASTTIME_STATUS_MF..CASTTIME_ON);
	end
end

function CastTime_SlashHandler(msg)
	CastTime.print = 1;
	if (not msg) then
		return;
	end
	msg = string.lower(msg);

	local _, _, command, value = string.find (msg, "(%w+) (%w+)");
	if (command == nil) then
		_, _, command = string.find(msg, "(%w+)");
	end

	if (command) then
		if (value == CASTTIME_ON) then
			value = 1;
		elseif (value == CASTTIME_OFF) then
			value = 0;
		else
			CastTime_SlashHandler_PrintStatus(command);
			return;
		end
		if (command == CASTTIME_STAT) then
			CastTime_SlashHandler_PrintStatus();
		elseif (command == CASTTIME_DISPLAY) then
			CastTime_Toggle_display(value);
		elseif (command == CASTTIME_DELAY) then
			CastTime_Toggle_delay(value);
		elseif (command == CASTTIME_HUN) then
			CastTime_Toggle_hun(value);
		elseif (command == CASTTIME_FLOCK) then
			CastTime_Toggle_flock(value);
		elseif (command == CASTTIME_MF) then
			CastTime_Toggle_mf(value);
		elseif (command == CASTTIME_IL) then
			CastTime_Toggle_il(value);
		elseif (command == CASTTIME_OL) then
			CastTime_Toggle_ol(value);
		end
	else
		CastTime_SlashHandler_help();
	end
	-- sync our vars to khaos (to cosmos never worked)
	if (Khaos) then
		Khaos.setSetKeyParameter("CastTime", "EnableDisplay", "checked", CastTime.display);
		Khaos.setSetKeyParameter("CastTime", "EnableDelay", "checked", CastTime.delay);
		Khaos.setSetKeyParameter("CastTime", "EnableHun", "checked", CastTime.hun);
		Khaos.setSetKeyParameter("CastTime", "EnableFlock", "checked", CastTime.flock);
		Khaos.setSetKeyParameter("CastTime", "EnableMf", "checked", CastTime.mf);
		Khaos.setSetKeyParameter("CastTime", "EnableIl", "checked", CastTime.inline);
		Khaos.setSetKeyParameter("CastTime", "EnableOl", "checked", CastTime.outline);
	end
--	if (Cosmos_RegisterConfiguration) then
--		Cosmos_UpdateValue("COS_CASSTTIME_DISPLAY_TOGGLE", CSM_CHECKONOFF, CastTime.display);
--		Cosmos_UpdateValue("COS_CASSTTIME_DELAY_TOGGLE", CSM_CHECKONOFF, CastTime.delay);
--		Cosmos_UpdateValue("COS_CASSTTIME_HUN_TOGGLE", CSM_CHECKONOFF, CastTime.hun);
--		CosmosMaster_Save();
--	end
	CastTime.print = 0;
end

function CastTime_SlashHandler_help()
	CastTime_Print(CASTTIME_HELP1);
	CastTime_Print(CASTTIME_HELP2);
	CastTime_Print(CASTTIME_HELP3);
	CastTime_Print(CASTTIME_HELP4);
	CastTime_Print(CASTTIME_HELP5);
	CastTime_Print(CASTTIME_HELP6);
	CastTime_Print(CASTTIME_HELP7);
	CastTime_Print(CASTTIME_HELP8);
	CastTime_Print(CASTTIME_HELP9);
end

function CastTime_SlashHandler_PrintStatus(command)
	CastTime.print = 1;
	local status;
	if (command == nil) then
		command = CASTTIME_STAT;
	end

	if (command == CASTTIME_DISPLAY or command == CASTTIME_STAT) then
		if (CastTime.display == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_DISPLAY..status);
	end
	if (command == CASTTIME_DELAY or command == CASTTIME_STAT) then
		if (CastTime.delay == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_DELAY..status);
	end
	if (command == CASTTIME_HUN or command == CASTTIME_STAT) then
		if (CastTime.hun == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_HUN..status);
	end
	if (command == CASTTIME_FLOCK or command == CASTTIME_STAT) then
		if (CastTime.flock == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_FLOCK..status);
	end
	if (command == CASTTIME_MF or command == CASTTIME_STAT) then
		if (CastTime.mf == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_MF..status);
	end
	if (command == CASTTIME_IL or command == CASTTIME_STAT) then
		if (CastTime.inline == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_IL..status);
	end
	if (command == CASTTIME_OL or command == CASTTIME_STAT) then
		if (CastTime.outline == 1) then
			status = CASTTIME_ON;
		else
			status = CASTTIME_OFF;
		end
		CastTime_Print(CASTTIME_STATUS_OL..status);
	end
	CastTime.print = 0;
end

function CastTime_Print(msg)
    if (DEFAULT_CHAT_FRAME and CastTime.print == 1) then
        DEFAULT_CHAT_FRAME:AddMessage(msg);
    end
end

function CastTime_Cosmos_Register()
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME",
			"SECTION",
			CASTTIME,
			CASTTIME_INFO
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_SEP",
			"SEPARATOR",
			CASTTIME,
			CASTTIME_INFO
			);
	Cosmos_RegisterConfiguration(
			"COS_CASSTTIME_DISPLAY_TOGGLE",
			"CHECKBOX",
			CASTTIME_DISPLAY_TOGGLE,
			CASTTIME_DISPLAY_TOGGLE_INFO,
			CastTime_Toggle_display,
			CastTime.display
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_DELAY_TOGGLE",
			"CHECKBOX",
			CASTTIME_DELAY_TOGGLE,
			CASTTIME_DELAY_TOGGLE_INFO,
			CastTime_Toggle_delay,
			CastTime.delay
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_HUN_TOGGLE",
			"CHECKBOX",
			CASTTIME_HUN_TOGGLE,
			CASTTIME_HUN_TOGGLE_INFO,
			CastTime_Toggle_hun,
			CastTime.hun
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_FRAME_LOCK",
			"CHECKBOX",
			CASTTIME_FLOCK_TOGGLE,
			CASTTIME_FLOCK_TOGGLE_INFO,
			CastTime_Toggle_flock,
			CastTime.flock
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_FRAME_USE",
			"CHECKBOX",
			CASTTIME_MF_TOGGLE,
			CASTTIME_MF_TOGGLE_INFO,
			CastTime_Toggle_mf,
			CastTime.mf
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_INLINE_USE",
			"CHECKBOX",
			CASTTIME_IL_TOGGLE,
			CASTTIME_IL_TOGGLE_INFO,
			CastTime_Toggle_il,
			CastTime.inline
			);
	Cosmos_RegisterConfiguration(
			"COS_CASTTIME_OUTLINE_USE",
			"CHECKBOX",
			CASTTIME_OL_TOGGLE,
			CASTTIME_OL_TOGGLE_INFO,
			CastTime_Toggle_ol,
			CastTime.outline
			);
end

function CastTime_Khaos_Register()
	local optionSet = {
		id="CastTime";
		text=CASTTIME;
		helptext=CASTTIME_INFO;
		difficulty=1;
		options={
			{
				id="Header";
				text=CASTTIME;
				helptext=CASTTIME_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="EnableDisplay";
				type=K_TEXT;
				text=CASTTIME_DISPLAY_TOGGLE;
				helptext=CASTTIME_DISPLAY_TOGGLE_INFO;
				callback=CastTime_Toggle_display;
				feedback=function(state) return CASTTIME_DISPLAY_TOGGLE_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableDelay";
				type=K_TEXT;
				text=CASTTIME_DELAY_TOGGLE;
				helptext=CASTTIME_DELAY_TOGGLE_INFO;
				callback=CastTime_Toggle_delay;
				feedback=function(state) return CASTTIME_DELAY_TOGGLE_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableHun";
				type=K_TEXT;
				text=CASTTIME_HUN_TOGGLE;
				helptext=CASTTIME_HUN_TOGGLE_INFO;
				callback=CastTime_Toggle_hun;
				feedback=function(state) return CASTTIME_HUN_TOGGLE_INFO end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="EnableFlock";
				type=K_TEXT;
				text=CASTTIME_FLOCK_TOGGLE;
				helptext=CASTTIME_FLOCK_TOGGLE_INFO;
				callback=CastTime_Toggle_flock;
				feedback=function(state) return CASTTIME_FLOCK_TOGGLE_INFO end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
			{
				id="EnableMf";
				type=K_TEXT;
				text=CASTTIME_MF_TOGGLE;
				helptext=CASTTIME_MF_TOGGLE_INFO;
				callback=CastTime_Toggle_mf;
				feedback=function(state) return CASTTIME_MF_TOGGLE_INFO end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
			{
				id="EnableIl";
				type=K_TEXT;
				text=CASTTIME_IL_TOGGLE;
				helptext=CASTTIME_IL_TOGGLE_INFO;
				callback=CastTime_Toggle_il;
				feedback=function(state) return CASTTIME_IL_TOGGLE_INFO end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
			{
				id="EnableOl";
				type=K_TEXT;
				text=CASTTIME_OL_TOGGLE;
				helptext=CASTTIME_OL_TOGGLE_INFO;
				callback=CastTime_Toggle_ol;
				feedback=function(state) return CASTTIME_OL_TOGGLE_INFO end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"bars",
		optionSet
	);
end
