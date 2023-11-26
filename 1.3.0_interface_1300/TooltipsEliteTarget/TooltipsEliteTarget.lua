TooltipsEliteTarget_ENABLE=1;
TooltipsEliteTarget_TEXT="+";


-- TargetLevelFrame mod
function TooltipsEliteTarget_TargetFrame_Update()
	if ( UnitExists("target") ) then
		if (TooltipsEliteTarget_ENABLE == 1) then
			local targetLevel = UnitLevel("target");
			local classification = UnitClassification("target");
			if ( classification == "worldboss" or
				  classification == "rareelite" or
				  classification == "elite") then
				TargetLevelText:SetText(TargetLevelText:GetText()..TooltipsEliteTarget_TEXT);
			end
		end
	end
end


function TooltipsEliteTarget_UnitHandler(type)
   -- can be on either line 2 or 3
	if (TooltipsEliteTarget_ENABLE == 1) then
		if(UnitExists(type)) then
			local classification = UnitClassification(type);
			local eliteText = nil;
			if ( classification == "worldboss" ) then
				eliteText = TooltipsEliteTarget_TEXT..TooltipsEliteTarget_TEXT..TooltipsEliteTarget_TEXT;
			elseif ( classification == "rareelite"  ) then
				eliteText = TooltipsEliteTarget_TEXT..TooltipsEliteTarget_TEXT;
			elseif ( classification == "elite"  ) then
				eliteText = TooltipsEliteTarget_TEXT;
			elseif ( classification == "rare"  ) then
				eliteText = TooltipsEliteTarget_TEXT;
			end
			if (eliteText ~= nil) then
				local originalText = GameTooltipTextLeft2:GetText();
				if (originalText ~= nil) then
					-- remove elite and boss designations
					local newText = string.gsub(originalText, " [(]"..ELITE.."[)]", "");
					newText = string.gsub(newText, " [(]"..BOSS.."[)]", "");
					-- put the tag next to the level
					newText = string.gsub(newText, "Level ([%d?]+)(.*)", "Level %1"..eliteText.."%2"); 
					GameTooltipTextLeft2:SetText(newText);
				end
				originalText = GameTooltipTextLeft3:GetText();
				if (originalText ~= nil) then
					-- remove elite and boss designations
					local newText = string.gsub(originalText, " [(]"..ELITE.."[)]", "");
					newText = string.gsub(newText, " [(]"..BOSS.."[)]", "");
					-- put the tag next to the level
					newText = string.gsub(newText, "Level ([%d?]+)(.*)", "Level %1"..eliteText.."%2"); 
					GameTooltipTextLeft3:SetText(newText);
				end
			end
		end
	end
end

function TooltipsEliteTarget_Toggle(toggle)
	if(toggle == 1) then
		TooltipsEliteTarget_ENABLE = 1;
	else
		TooltipsEliteTarget_ENABLE = nil;
	end
end

function TooltipsEliteTarget_SetText(text)
	TooltipsEliteTarget_TEXT=text;
end

function TooltipsEliteTarget_OnLoad()
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
			"COS_ELITETARGET_C",
			"CHECKBOX",
			ELITETARGET_ENABLE,
			ELITETARGET_ENABLE_INFO,
			TooltipsEliteTarget_Toggle,
			0
			);
	else
		-- add stand alone here
	end
	HookFunction("TargetFrame_Update","TooltipsEliteTarget_TargetFrame_Update","after");
   HookFunction("TooltipsBase_UnitHandler","TooltipsEliteTarget_UnitHandler","after");
end