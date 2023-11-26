-- This function handles events for the XP bar we're using
-- to replace the one we removed in RemoveMainActionBar()


function BibXPBar_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	if(ChatFrame2) then
		ChatFrame2:AddMessage("|cff8CAFFFInsomniax BibToolbars v3.3 Loaded|r");
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage("|cff8CAFFFInsomniax Insomniax BibToolbars v3.3 Loaded|r");
		end
	end	
end


function BibmodXPBarOnEvent (event)
	if (event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_ENTERING_WORLD") then
		local currXP = UnitXP("player");
		local nextlevelXP = UnitXPMax("player");
		local restXP = GetXPExhaustion();
		
		this:SetMinMaxValues(min(0, currXP), nextlevelXP);
		BibFatigueBar:SetMinMaxValues(min(0, currXP), nextlevelXP);
		this:SetValue(currXP);
		if(restXP == nil) then
			BibFatigueBar:SetValue(currXP);
		else
			BibFatigueBar:SetValue(currXP + (tonumber(restXP) / 2));
		end	
		UpdateBibXPBarText();
		return;
	end
end

function UpdateBibXPBarText()
		local currXP = UnitXP("player");
		local nextlevelXP = UnitXPMax("player");
		local restXP = GetXPExhaustion();
		
		local neededXP = nextlevelXP - currXP;
		local currlevel = UnitLevel("player");
		local nextlevel = (UnitLevel("player") + 1);
		local currXPpercent = ceil(currXP / nextlevelXP * 100);
		local neededXPpercent = 100 - currXPpercent;
		
		if(restXP == nil) then
			BibXPBarText:SetText(currXP.." ("..currXPpercent.."%) / "..nextlevelXP.."xp | "..neededXPpercent.."% ("..neededXP.."xp) to level "..nextlevel);
		else
			BibXPBarText:SetText(currXP.." ("..currXPpercent.."%) / "..nextlevelXP.."xp | "..neededXPpercent.."% ("..neededXP.."xp) to level "..nextlevel.." | "..(tonumber(restXP) / 2).."xp bonus");
		end
end


function BibXPBar_OnMouseDown(arg1)
	local PlayerString = UnitName("player");
	if ( (arg1 == "LeftButton") and (not BibActionBarButtonsLocked[PlayerString]) ) then
		BibmodXPFrame:StartMoving()
	end
end

function UpdateBibXPBarVisibility()
	local PlayerString = UnitName("player");
	if(BibXPBarInvisible and BibXPBarInvisible[PlayerString]) then
		BibmodXPFrame:Hide();
	else
		BibmodXPFrame:Show();
	end
end


function BibXPBar_OnMouseUp(arg1)
	if (arg1 == "LeftButton") then
		BibmodXPFrame:StopMovingOrSizing()
	end
end

function BibXPBar_OnEnter()
	-- put the tool tip in the default position
	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	
	-- set the tool tip text
	GameTooltip:SetText("Insomniax BibToolbars XP Bar v3.3", 255/255, 209/255, 0/255);
	GameTooltip:AddLine("Left-click to move", 1.00, 1.00, 1.00);
	GameTooltip:AddLine("This experience bar is divided into twenty", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("segments each representing five percent of", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("the total experience needed to reach the next", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("level. To move the experience bar make sure", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("that the action buttons are unlocked on the", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("bibmod control panel; to hide it simply click", 80/255, 143/255, 148/255);
	GameTooltip:AddLine("on the XP bar button to toggle it on or off.", 80/255, 143/255, 148/255);	
	GameTooltip:Show();
end