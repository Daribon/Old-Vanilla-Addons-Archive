TooltipsColorTarget_ENABLE=1;

function TooltipsColorTarget_UnitHandler(type)
	if (TooltipsColorTarget_ENABLE == 1) then
		if(UnitExists(type)) then
			local r, g, b = GameTooltip_UnitColor(type);
			-- Set it back to blue for players
			if(r == 1 and g == 1 and b == 1) then
				r = 0;
				g = 0;
			end
			GameTooltip:SetBackdropColor(r, g, b);
			GameTooltipTextLeft1:SetTextColor(1, 1, 1);	
		end
	end
end

function TooltipsColorTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsColorTarget_ENABLE = 1;
	else
		TooltipsColorTarget_ENABLE = nil;
	end
end


function TooltipsColorTarget_OnLoad()
	if(Cosmos_RegisterConfiguration) then
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPSBASE",
			"SECTION",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_TOOLTIPSBASE_SEP",
			"SEPARATOR",
			TOOLTIPSBASE_SEP,
			TOOLTIPSBASE_SEP_INFO
			);
		Cosmos_RegisterConfiguration(
			"COS_COLORTARGET_C",
			"CHECKBOX",
			COLORTARGET_ENABLE,
			COLORTARGET_ENABLE_INFO,
			TooltipsColorTarget_Toggle,
			0
			);
	else
		-- add stand alone here
	end
   HookFunction("TooltipsBase_UnitHandler","TooltipsColorTarget_UnitHandler","after");
end
