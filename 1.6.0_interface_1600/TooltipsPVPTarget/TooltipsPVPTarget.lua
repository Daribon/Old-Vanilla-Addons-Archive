TooltipsPVPTarget_ENABLE=1;

function TooltipsPVPTarget_Handler(type)
	if (TooltipsPVPTarget_ENABLE == 1) then
		if(UnitExists(type)) then
			for i = 3, 5 do
				local tooltipTextLeft = getglobal("GameTooltipTextLeft"..i);
				local originalText = tooltipTextLeft:GetText();
				if (originalText ~= nil) then
					-- remove elite and boss designations
					local newText = string.gsub(originalText, PVPTARGET_SEARCHPATTERN, "");
					if (newText == "") then
						tooltipTextLeft:SetText(nil);
						tooltipTextLeft:Hide();
					end
				end
			end
		end
	end
end


function TooltipsPVPTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsPVPTarget_ENABLE = 1;
	else
		TooltipsPVPTarget_ENABLE = nil;
	end
end

function TooltipsPVPTarget_OnLoad()
	if(UltimateUI_RegisterConfiguration) then
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPSBASE",
			"SECTION",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		UltimateUI_RegisterConfiguration(
			"UUI_TOOLTIPSBASE_SEP",
			"SEPARATOR",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		UltimateUI_RegisterConfiguration(
			"UUI_PVPTARGET_C",
			"CHECKBOX",
			PVPTARGET_ENABLE,
			PVPTARGET_ENABLE_INFO,
			TooltipsPVPTarget_Toggle,
			0
			);
	else
		-- add stand alone here
	end
   Sea.util.hook("TooltipsBase_UnitHandler","TooltipsPVPTarget_Handler","before");
end
