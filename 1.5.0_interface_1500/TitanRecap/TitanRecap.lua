--[[
	Titan Panel [Recap] v1.0: Titan plugin for Recap stats
	copyright 2005 by Gello (gello_biafra@hotmail.com)
	and chicogrande (jluzier@gmail.com)
	for use with Recap 2.6+
]]

-- globals
TITAN_RECAP_ID = "Recap";
TITAN_RECAP_BUTTON_ARTWORK_PATH = "Interface\\AddOns\\Recap\\";
TITAN_RECAP_PAUSE_ACTION_ARG = "Pause";
TITAN_RECAP_BUTTON_TOGGLE_MONITOR = "TitanPanelRecap_TogglePause";

local titan_recap = {};
-- the multi-array is no longer necessary, primitive types could be used
titan_recap.state = { value="Idle" };
titan_recap.yourdps = { value=0 };
titan_recap.dpsin = { value=0 };
titan_recap.dpsout = { value=0 };

function TitanPanelRecapButton_OnLoad()
	this.registry = { 
		id = "Recap",
		menuText = "Recap", 
		buttonTextFunction = "TitanPanelRecapButton_GetButtonText", 
		tooltipTitle = "Recap v"..tostring(Recap_Version),
		tooltipTextFunction = "TitanPanelRecapButton_GetTooltipText";
		icon = TITAN_RECAP_BUTTON_ARTWORK_PATH.."Recap-Status";
		iconWidth = 16;
		savedVariables = {
			ShowLabelText = 1,  -- Default to 1
			ShowDpsIn = 1;
			ShowDpsOut = 1;
			ShowYourDps = 1;
			ShowIcon = 1;
		}
	};
end

function TitanPanelRecapButton_GetButtonText(id)
	-- If id not nil, return corresponding plugin button
	-- Otherwise return this button and derive the real id
	local button, id = TitanUtils_GetButton(id, true);
	local recapRichText = "";
	-- format the colored status bubble
	if (TitanGetVar(TITAN_RECAP_ID, "ShowIcon")) then
		recapIcon =	getglobal(button:GetName().."Icon");
		if titan_recap.state.value=="Idle" then
			recapIcon:SetVertexColor(.5,.5,.5)
		elseif titan_recap.state.value=="Active" then
			recapIcon:SetVertexColor(0,1,0)
		elseif titan_recap.state.value=="Stopped" then
			recapIcon:SetVertexColor(1,0,0)
		end
	end
		
	-- create the string to return to the display
	if (TitanGetVar(TITAN_RECAP_ID, "ShowYourDps")) then
		recapRichText = TitanUtils_GetHighlightText(titan_recap.yourdps.value).." "
	end
	if (TitanGetVar(TITAN_RECAP_ID, "ShowDpsIn")) then
		recapRichText = recapRichText..TitanUtils_GetRedText(titan_recap.dpsin.value).." "
	end
	if (TitanGetVar(TITAN_RECAP_ID, "ShowDpsOut")) then
		recapRichText = recapRichText..TitanUtils_GetGreenText(titan_recap.dpsout.value).." ";
	end
	-- adding some space if the user elects to not show label text	
	if (TitanGetVar(TITAN_RECAP_ID, "ShowLabelText")) then
		return TITAN_RECAP_BUTTON_LABEL, recapRichText;
	else
		recapRichText = TITAN_RECAP_BUTTON_NO_LABEL..recapRichText;	
		return TITAN_RECAP_BUTTON_LABEL, recapRichText;
	end
end

function TitanPanelRecap_Update(state,yourdps,dpsin,dpsout)

	titan_recap.state.value = state;
	titan_recap.yourdps.value = yourdps;
	titan_recap.dpsin.value = dpsin;
	titan_recap.dpsout.value = dpsout;
	
	TitanPanelButton_UpdateButton(TITAN_RECAP_ID);
end

function TitanPanelRecap_OnMouseUp(arg1)
	if arg1=="LeftButton" then
		RecapFrame_Toggle();
	end
end

function TitanPanelRightClickMenu_PrepareRecapMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_RECAP_ID].menuText);

	-- dps
	local info = {};
	info.text = TITAN_RECAP_BUTTON_SHOWDPS;
	info.func = TitanPanelRecap_ToggleYourDPS;
	info.checked = TitanGetVar(TITAN_RECAP_ID, "ShowYourDps");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);
	
	-- dps in
	info.text = TITAN_RECAP_BUTTON_SHOWDPS_IN;
	info.func = TitanPanelRecap_ToggleDPSIn;
	info.checked = TitanGetVar(TITAN_RECAP_ID, "ShowDpsIn");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);
	
	-- dps out
	info.text = TITAN_RECAP_BUTTON_SHOWDPS_OUT;
	info.func = TitanPanelRecap_ToggleDPSOut;
	info.checked = TitanGetVar(TITAN_RECAP_ID, "ShowDpsOut");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);						

	TitanPanelRightClickMenu_AddSpacer();

	-- toggle monitoring
	if (recap.Opt.Paused.value == true) then
		TitanPanelRightClickMenu_AddCommand(TITAN_RECAP_BUTTON_START_TEXT, TITAN_RECAP_ID, TITAN_RECAP_BUTTON_TOGGLE_MONITOR);
	-- LedMirage 6/19/2005 Fix for Nil error start [1/1]
	elseif (recap.Opt.Paused.value == nil) then
		TitanPanelRightClickMenu_AddCommand(TITAN_RECAP_BUTTON_PAUSE_TEXT, TITAN_RECAP_ID, TITAN_RECAP_BUTTON_TOGGLE_MONITOR);
	-- LedMirage 6/19/2005 Fix for Nil error end [1/1]
	else
		TitanPanelRightClickMenu_AddCommand(TITAN_RECAP_BUTTON_PAUSE_TEXT, TITAN_RECAP_ID, TITAN_RECAP_BUTTON_TOGGLE_MONITOR);
	end

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddToggleIcon(TITAN_RECAP_ID);	
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_RECAP_ID);	
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_RECAP_ID, TITAN_PANEL_MENU_FUNC_HIDE);

end

function TitanPanelRecapButton_GetTooltipText()
	local richTooltipText = "";
	richTooltipText = titan_recap.state.value.."\n"..recap_temp.Local.LastAll[recap.Opt.View.value]..":\nYour DPS: ".."\t"..TitanUtils_GetHighlightText(RecapMinYourDPS_Text:GetText()).."\nMax hit: ".."\t"..TitanUtils_GetHighlightText(RecapTotals_MaxHit:GetText()).."\nTotal DPS Out: ".."\t"..TitanUtils_GetHighlightText(RecapTotals_DPS:GetText()).."\nTotal DPS In: ".."\t"..TitanUtils_GetHighlightText(RecapTotals_DPSIn:GetText());
	richTooltipText = richTooltipText.."\n"..TitanUtils_GetGreenText(TITAN_RECAP_BUTTON_HINT_TEXT);
	return richTooltipText;
end

function TitanPanelRecap_ToggleYourDPS()
	TitanToggleVar(TITAN_RECAP_ID, "ShowYourDps");
	TitanPanelButton_UpdateButton(TITAN_RECAP_ID);
end

function TitanPanelRecap_ToggleDPSIn()
	TitanToggleVar(TITAN_RECAP_ID, "ShowDpsIn");
	TitanPanelButton_UpdateButton(TITAN_RECAP_ID);
end

function TitanPanelRecap_ToggleDPSOut()
	TitanToggleVar(TITAN_RECAP_ID, "ShowDpsOut");
	TitanPanelButton_UpdateButton(TITAN_RECAP_ID);
end

function TitanPanelRecap_TogglePause()
	Recap_OnClick("Pause");
end
