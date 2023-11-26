TooltipsLevelTarget_ENABLE=1;


-- TargetLevelFrame mod
function TooltipsLevelTarget_TargetFrame_Update()
	if ( UnitExists("target") ) then
		if (TooltipsLevelTarget_ENABLE == 1) then
			local targetLevel = UnitLevel("target");
			if (targetLevel) then
				local targetLevelText = TargetLevelText:GetText();
				-- replace ?? Blah with 65 Blah
				if (targetLevelText) then
					targetLevelText = string.gsub(targetLevelText, "([?]+)(.*)", targetLevel.."%2");
					TargetLevelText:SetText(targetLevelText);
					TargetLevelText:Show();
					TargetHighLevelTexture:Hide();
				end
			end
		end
	end
end


function TooltipsLevelTarget_UnitHandler(type)
   -- can be on either line 2 or 3
	if (TooltipsLevelTarget_ENABLE == 1) then
		if(UnitExists(type)) then
			local targetLevel = UnitLevel(type);
			if (targetLevel) then
				local targetLevelText = GameTooltipTextLeft2:GetText();
				if (targetLevelText) then
					-- replace ?? Blah with 65 Blah
					targetLevelText = string.gsub(targetLevelText, "([?]+)(.*)", targetLevel.."%2");
					GameTooltipTextLeft2:SetText(targetLevelText);
				end
				targetLevelText = GameTooltipTextLeft3:GetText();
				if (targetLevelText) then
					-- replace ?? Blah with 65 Blah
					targetLevelText = string.gsub(targetLevelText, "([?]+)(.*)", targetLevel.."%2");
					GameTooltipTextLeft3:SetText(targetLevelText);
				end
			end
		end
	end
end

function TooltipsLevelTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsLevelTarget_ENABLE = 1;
	else
		TooltipsLevelTarget_ENABLE = nil;
	end
end

function TooltipsLevelTarget_SetText(text)
	TooltipsLevelTarget_TEXT=text;
end

function TooltipsLevelTarget_OnLoad()
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
			"COS_COS_SEELEVEL",
			"CHECKBOX",
			LEVELTARGET_ENABLE,
			LEVELTARGET_ENABLE_INFO,
			TooltipsLevelTarget_Toggle,
			1
			);
	else
		-- add stand alone here
	end
	Sea.util.hook("TargetFrame_Update","TooltipsLevelTarget_TargetFrame_Update","after");
    Sea.util.hook("TooltipsBase_UnitHandler","TooltipsLevelTarget_UnitHandler","after");
end