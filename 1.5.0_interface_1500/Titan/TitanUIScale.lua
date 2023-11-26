TITAN_UISCALE_ID = "UIScale";
TITAN_UISCALE_FRAME_SHOW_TIME = 0.5;

TITAN_UISCALE_MIN = 0.64;
TITAN_UISCALE_MAX = 1;
TITAN_UISCALE_STEP = 0.01;

TITAN_PANELSCALE_MIN = 0.75;
TITAN_PANELSCALE_MAX = 1.25;
TITAN_PANELSCALE_STEP = 0.01;

function TitanPanelUIScaleButton_OnLoad()
	this.registry = {
		id = TITAN_UISCALE_ID,
		builtIn = 1,
		menuText = TITAN_UISCALE_MENU_TEXT, 
		tooltipTitle = TITAN_UISCALE_TOOLTIP, 
		tooltipTextFunction = "TitanPanelUIScaleButton_GetTooltipText", 
		icon = TITAN_ARTWORK_PATH.."TitanUIScale",
	};
end

function TitanPanelUIScaleButton_GetTooltipText()
	local panelScaleText = TitanPanelUIScale_GetSCaleText(TitanPanelGetVar("Scale"));
	local uiScaleText = TitanPanelUIScale_GetSCaleText(UIParent:GetScale());
	
	return ""..
		TITAN_UISCALE_TOOLTIP_VALUE_UI.."\t"..TitanUtils_GetHighlightText(uiScaleText).."\n"..
		TITAN_UISCALE_TOOLTIP_VALUE_PANEL.."\t"..TitanUtils_GetHighlightText(panelScaleText).."\n"..
		TitanUtils_GetGreenText(TITAN_UISCALE_TOOLTIP_HINT1).."\n"..
		TitanUtils_GetGreenText(TITAN_UISCALE_TOOLTIP_HINT2);
end

function TitanPanelUIScaleControlSlider_OnEnter()
	local uiScale = UIParent:GetScale();
	
	this.tooltipText = TitanOptionSlider_TooltipText(TITAN_UISCALE_CONTROL_TOOLTIP_UI, TitanPanelUIScale_GetSCaleText(uiScale));
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(this:GetParent());
end

function TitanPanelUIScaleControlSlider_OnLeave()
	this.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(this:GetParent(), TITAN_UISCALE_FRAME_SHOW_TIME);
end

function TitanPanelUIScaleControlSlider_OnShow()	
	local uiScale = UIParent:GetScale();
	local min = TITAN_UISCALE_MIN;
	local max = TITAN_UISCALE_MAX;
	local step = TITAN_UISCALE_STEP;
	
	getglobal(this:GetName().."Text"):SetText(TitanPanelUIScale_GetSCaleText(uiScale));
	getglobal(this:GetName().."High"):SetText(TITAN_UISCALE_CONTROL_LOW_UI);
	getglobal(this:GetName().."Low"):SetText(TITAN_UISCALE_CONTROL_HIGH_UI);
	this:SetMinMaxValues(min, max);
	this:SetValueStep(step);
	this:SetValue(min + max - uiScale);
	this.previousValue = this:GetValue();
end

function TitanPanelUIScaleControlSlider_OnValueChanged()
	if (this:GetValue() ~= this.previousValue) then
		this.previousValue = this:GetValue();
		
		-- Set UI scale
		local min = TITAN_UISCALE_MIN;
		local max = TITAN_UISCALE_MAX;
		local uiScale = min + max - this:GetValue();
		SetCVar("useUiScale", 1, USE_UISCALE);
		SetCVar("uiScale", uiScale);
		
		-- Adjust panel scale
		TitanPanel_SetScale();
		TitanPanel_RefreshPanelButtons();

		-- Update slider value text
		getglobal(this:GetName().."Text"):SetText(TitanPanelUIScale_GetSCaleText(uiScale));

		-- Update GameTooltip
		if (this.tooltipText) then  
			this.tooltipText = TitanOptionSlider_TooltipText(TITAN_UISCALE_CONTROL_TOOLTIP_UI, TitanPanelUIScale_GetSCaleText(uiScale));
			GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
		end
	end
end

function TitanPanelPanelScaleControlSlider_OnEnter()
	local scale = TitanPanelGetVar("Scale");
	
	this.tooltipText = TitanOptionSlider_TooltipText(TITAN_UISCALE_CONTROL_TOOLTIP_PANEL, TitanPanelUIScale_GetSCaleText(scale));
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
	TitanUtils_StopFrameCounting(this:GetParent());
end

function TitanPanelPanelScaleControlSlider_OnLeave()
	this.tooltipText = nil;
	GameTooltip:Hide();
	TitanUtils_StartFrameCounting(this:GetParent(), TITAN_UISCALE_FRAME_SHOW_TIME);
end

function TitanPanelPanelScaleControlSlider_OnShow()	
	local scale = TitanPanelGetVar("Scale");
	local min = TITAN_PANELSCALE_MIN;
	local max = TITAN_PANELSCALE_MAX;
	local step = TITAN_PANELSCALE_STEP;
	
	getglobal(this:GetName().."Text"):SetText(TitanPanelUIScale_GetSCaleText(scale));
	getglobal(this:GetName().."High"):SetText(TITAN_UISCALE_CONTROL_LOW_PANEL);
	getglobal(this:GetName().."Low"):SetText(TITAN_UISCALE_CONTROL_HIGH_PANEL);
	this:SetMinMaxValues(min, max);
	this:SetValueStep(step);
	this:SetValue(min + max - scale);
	this.previousValue = this:GetValue();
end

function TitanPanelPanelScaleControlSlider_OnValueChanged()
	if (this:GetValue() ~= this.previousValue) then
		this.previousValue = this:GetValue();
		
		TitanMovableFrame_CheckFrames(TitanPanelGetVar("Position"));

		-- Set panel scale
		local min = TITAN_PANELSCALE_MIN;
		local max = TITAN_PANELSCALE_MAX;
		local scale = min + max - this:GetValue();
		TitanPanelSetVar("Scale", scale);
		
		-- Adjust panel scale
		TitanPanel_SetScale();
		TitanPanel_RefreshPanelButtons();
		
		-- Adjust frame positions
--		TitanMovableFrame_MoveBlizzardFrames(TitanPanelGetVar("Position"));
--		TitanMovableFrame_MoveThirdPartyFrames(TitanPanelGetVar("Position"));
		TitanMovableFrame_MoveFrames(TitanPanelGetVar("Position"));
		TitanMovableFrame_AdjustBlizzardFrames();
		
		-- Update slider value text
		getglobal(this:GetName().."Text"):SetText(TitanPanelUIScale_GetSCaleText(scale));

		-- Update GameTooltip
		if (this.tooltipText) then  --??
			this.tooltipText = TitanOptionSlider_TooltipText(TITAN_UISCALE_CONTROL_TOOLTIP_PANEL, TitanPanelUIScale_GetSCaleText(scale));
			GameTooltip:SetText(this.tooltipText, nil, nil, nil, nil, 1);
		end
	end
end

function TitanPanelUIScale_GetSCaleText(scale)
	return tostring(floor(100 * scale + 0.5)) .. "%";
end

function TitanPanelUIScaleControlFrame_OnLoad()
	getglobal(this:GetName().."UITitle"):SetText(TITAN_UISCALE_CONTROL_TITLE_UI);
	getglobal(this:GetName().."PanelTitle"):SetText(TITAN_UISCALE_CONTROL_TITLE_PANEL);
	this:SetBackdropBorderColor(1, 1, 1);
	this:SetBackdropColor(0, 0, 0, 1);
end

function TitanPanelUIScaleControlFrame_OnShow()
	this:SetScale(UIParent:GetScale());
end

function TitanPanelUIScaleControlFrame_OnUpdate(elapsed)
	TitanUtils_CheckFrameCounting(this, elapsed);
end

function TitanPanelRightClickMenu_PrepareUIScaleMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_UISCALE_ID].menuText);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_UISCALE_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end
