TooltipsGuildTarget_ENABLE=1;

function TooltipsGuildTarget_Handler(type)
	if (TooltipsGuildTarget_ENABLE == 1) then
		if (not TooltipsBase_IsNewbieTip()) then
			if(UnitExists(type)) then
				local guild = GetGuildInfo(type);
				if (guild) then
					GameTooltip:AddLine("<"..guild..">",1.0,1.0,1.0);
				end
			end
		end
	end
end
function TooltipsGuildTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsGuildTarget_ENABLE = 1;
	else
		TooltipsGuildTarget_ENABLE = nil;
	end
end

function TooltipsGuildTarget_OnLoad()
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
			"UUI_PROPS_GENABLE",
			"CHECKBOX",
			GUILDTARGET_ENABLE,
			GUILDTARGET_ENABLE_INFO,
			TooltipsGuildTarget_Toggle,
			0
			);
	else
		-- add stand alone here
	end
   Sea.util.hook("TooltipsBase_UnitHandler","TooltipsGuildTarget_Handler","after");
end
