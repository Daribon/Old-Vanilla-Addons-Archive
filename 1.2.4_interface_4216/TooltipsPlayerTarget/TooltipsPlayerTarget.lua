TooltipsPlayerTarget_ENABLE=1;

function TooltipsPlayerTarget_Handler(type)
	if (TooltipsPlayerTarget_ENABLE == 1) then
		if(UnitExists(type)) then
			local originalText = GameTooltipTextLeft2:GetText();
			if (originalText ~= nil) then
				-- remove elite and boss designations
				local newText = string.gsub(originalText, " [(]"..PLAYERTARGET_SEARCHPATTERN.."[)]", "");
				GameTooltipTextLeft2:SetText(newText);
			end
		end
	end
end

function TooltipsPlayerTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsPlayerTarget_ENABLE = 1;
	else
		TooltipsPlayerTarget_ENABLE = nil;
	end
end


function TooltipsPlayerTarget_OnLoad()
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
			"COS_PLAYERTARGET_C",
			"CHECKBOX",
			PLAYERTARGET_ENABLE,
			PLAYERTARGET_ENABLE_INFO,
			TooltipsPlayerTarget_Toggle,
			0
			);
	else
		-- add stand alone here
	end
   Sea.util.hook("TooltipsBase_UnitHandler","TooltipsPlayerTarget_Handler","after");
end
