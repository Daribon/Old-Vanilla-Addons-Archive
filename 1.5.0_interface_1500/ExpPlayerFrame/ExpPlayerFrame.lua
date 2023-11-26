ExpPlayerFrameBarTemp = 0;
--ExpPlayerFrameArt = 1;
ExpPlayerFramePercentEnabled = nil;
ExpPlayerFramePercentShow = "&remainingxppercent%";
ExpPlayerFrameHover = "&percentxp% XP";
ExpPlayerFrameHoverRest = "&percentxp% XP";
ExpPlayerFrameHoverMain = "&playername";

function ExpPlayerFrame_OnLoad ()

	RegisterForSave("ExpPlayerFrameHover");
	RegisterForSave("ExpPlayerFrameHoverRest");
	RegisterForSave("ExpPlayerFrameHoverMain");
	RegisterForSave("ExpPlayerFramePercentEnabled");
	RegisterForSave("ExpPlayerFramePercentShow");
	--RegisterForSave("ExpPlayerFrameArt");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_EXHAUSTION");
	this:RegisterEvent("VARIABLES_LOADED");

	SlashCmdList["EPF"] = epfconfig;
	SLASH_EPF1 = "/epf";
end

function epfconfig (msg)
	local epfKeyword, epfParams;
	if (strfind(msg," ") == nil) then
		epfKeyword = msg;
		epfParams = nil;
	else
		epfKeyword = strsub(msg,0,strfind(msg," ")-1);
		epfParams = strsub(msg,strfind(msg," ")+1,strlen(msg));
		local epfParamsTemp = strsub(epfParams,0,1);
		if ((epfParams == "") or (epfParamsTemp == " ")) then
			epfParams = nil;
		end
	end
	if (epfKeyword == "toggle") then
		if (ExpPlayerFramePercentEnabled == 1) then
			ExpPlayerFramePercentEnabled = nil;
			DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar view disabled.");
			ExpPlayerFramePercent:Hide();
		else
			ExpPlayerFramePercentEnabled = 1;
			DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar view enabled.");
			ExpPlayerFramePercent:Show();
			local ExpPercentage = UnitXP("player") / UnitXPMax("player") * 100;
			ExpPlayerFramePercent:SetText(floor(ExpPercentage).."%");
		end
	--elseif (epfKeyword == "art") then
	--	if (ExpPlayerFrameArt == 1) then
	--		MainMenuBarLeftEndCap:Hide();
	--		MainMenuBarRightEndCap:Hide();
	--		DEFAULT_CHAT_FRAME:AddMessage("epf: Art is hidden");
	--		ExpPlayerFrameArt = 0;
	--	else
	--		MainMenuBarLeftEndCap:Show();
	--		MainMenuBarRightEndCap:Show();
	--		DEFAULT_CHAT_FRAME:AddMessage("epf: Art is visible");
	--		ExpPlayerFrameArt = 1;
	--	end
	elseif ((epfKeyword == "setnorm") and (epfParams ~= nil)) then
		ExpPlayerFrameHover = epfParams;
		DEFAULT_CHAT_FRAME:AddMessage("epf: Normal hover text set to ".."\""..ExpPlayerFrameHover.."\"");
		ExpPlayerFrameBar_UpdateIt();
	elseif ((epfKeyword == "setrest") and (epfParams ~= nil)) then
		ExpPlayerFrameHoverRest = epfParams;
		DEFAULT_CHAT_FRAME:AddMessage("epf: Rest hover text set to ".."\""..ExpPlayerFrameHoverRest.."\"");
		ExpPlayerFrameBar_UpdateIt();
	elseif ((epfKeyword == "setmain") and (epfParams ~= nil)) then
		ExpPlayerFrameHoverMain = epfParams;
		DEFAULT_CHAT_FRAME:AddMessage("epf: Main text set to ".."\""..ExpPlayerFrameHoverMain.."\"");
		ExpPlayerFrameBar_UpdateIt();
	elseif ((epfKeyword == "setxpbar") and (epfParams ~= nil)) then
		ExpPlayerFramePercentShow = epfParams;
		DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar text set to ".."\""..ExpPlayerFramePercentShow.."\"");
		ExpPlayerFrameBar_UpdateIt();
	elseif (epfKeyword == "reset") then
		ExpPlayerFramePercentShow = "&remainingxppercent%";
		DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar text set to ".."\""..ExpPlayerFramePercentShow.."\"");
		ExpPlayerFrameHover = "&percentxp% XP";
		DEFAULT_CHAT_FRAME:AddMessage("epf: Normal hover text set to ".."\""..ExpPlayerFrameHover.."\"");
		ExpPlayerFrameHoverRest = "&percentxp% XP";
		DEFAULT_CHAT_FRAME:AddMessage("epf: Rest hover text set to ".."\""..ExpPlayerFrameHoverRest.."\"");
		ExpPlayerFrameHoverMain= "&playername";
		DEFAULT_CHAT_FRAME:AddMessage("epf: Main text set to ".."\""..ExpPlayerFrameHoverMain.."\"");
		ExpPlayerFrameBar_UpdateIt();
	elseif (epfKeyword == "show") then
		DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar text set to ".."\""..ExpPlayerFramePercentShow.."\"");
		DEFAULT_CHAT_FRAME:AddMessage("epf: Normal hover text set to ".."\""..ExpPlayerFrameHover.."\"");
		DEFAULT_CHAT_FRAME:AddMessage("epf: Rest hover text set to ".."\""..ExpPlayerFrameHoverRest.."\"");
		DEFAULT_CHAT_FRAME:AddMessage("epf: Main text set to ".."\""..ExpPlayerFrameHoverMain.."\"");
		if (ExpPlayerFramePercentEnabled == 1) then
			DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar view is on");
		else
			DEFAULT_CHAT_FRAME:AddMessage("epf: XP bar view is off");
		end
		--if (MainMenuBarLeftEndCap:IsVisible() == 1) then
		--	DEFAULT_CHAT_FRAME:AddMessage("epf: Art is visible");
		--else
		--	DEFAULT_CHAT_FRAME:AddMessage("epf: Art is hidden");
		--end
	else
		DEFAULT_CHAT_FRAME:AddMessage("  USAGE: /epf <keyword> [args]");
		DEFAULT_CHAT_FRAME:AddMessage("    toggle - toggles text on the XP bar on and off");
		--DEFAULT_CHAT_FRAME:AddMessage("    art - toggles the displaying of art");
		DEFAULT_CHAT_FRAME:AddMessage("    show - displays all settings");
		DEFAULT_CHAT_FRAME:AddMessage("    reset - resets everything to default");
		DEFAULT_CHAT_FRAME:AddMessage("    setxpbar <text> - changes XP bar text on player frame");
		DEFAULT_CHAT_FRAME:AddMessage("    setnorm <text> - changes normal hover text on player frame");
		DEFAULT_CHAT_FRAME:AddMessage("    setrest <text> - changes rested hover text on player frame");
		DEFAULT_CHAT_FRAME:AddMessage("    setmain <text> - changes main text on player frame");
		DEFAULT_CHAT_FRAME:AddMessage("  VARIABLES (to be used with setxp, setnorm, setrest, and setmain):");
		DEFAULT_CHAT_FRAME:AddMessage("    &playername - returns player's name");
		DEFAULT_CHAT_FRAME:AddMessage("    &percentxp - returns xp in percent");
		DEFAULT_CHAT_FRAME:AddMessage("    &remainingxppercent - returns xp left to next level in percent");
		DEFAULT_CHAT_FRAME:AddMessage("    &currentxp - returns current xp");
		DEFAULT_CHAT_FRAME:AddMessage("    &maxxp - returns maximum xp possible for the level");
		DEFAULT_CHAT_FRAME:AddMessage("    &restxp - returns rest xp");
		DEFAULT_CHAT_FRAME:AddMessage("    &remainingxp - returns xp left to next level");
		DEFAULT_CHAT_FRAME:AddMessage("  EXAMPLES:");
		DEFAULT_CHAT_FRAME:AddMessage("    /epf toggle");
		DEFAULT_CHAT_FRAME:AddMessage("    /epf setxpbar &percentxp%");
		DEFAULT_CHAT_FRAME:AddMessage("    /epf setmain &playername (&percentxp%)");
		DEFAULT_CHAT_FRAME:AddMessage("    /epf setrest &restxp xp");
		DEFAULT_CHAT_FRAME:AddMessage("    /epf setnorm &currentxp / &maxxp");
	end
end

function ExpPlayerFrame_OnEvent (event)
	if (event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "UPDATE_EXHAUSTION" or event == "PLAYER_ENTERING_WORLD") then
		ExpPlayerFrameBar:SetMinMaxValues(min(0, UnitXP("player")), UnitXPMax("player"));
		ExpPlayerFrameBar:SetValue(UnitXP("player"));
		ExpPlayerFrameBarExhaust:SetMinMaxValues(min(0, UnitXP("player")), UnitXPMax("player"));
		local ExpBarexhaustionTickSet;
		if (GetXPExhaustion() ~= nil) then
			ExpBarexhaustionTickSet = max(((UnitXP("player") + GetXPExhaustion()) / UnitXPMax("player")) * ExpPlayerFrameBar:GetWidth(), 0);
		else
			ExpBarexhaustionTickSet = max(UnitXP("player") / UnitXPMax("player") * ExpPlayerFrameBar:GetWidth(), 0);
		end
		if (ExpBarexhaustionTickSet > ExpPlayerFrameBar:GetWidth()) then
			ExpPlayerFrameBarExhaust:SetValue(UnitXPMax("player"));
		else
			ExpPlayerFrameBarExhaust:SetValue(ExpBarexhaustionTickSet / ExpPlayerFrameBar:GetWidth() * UnitXPMax("player"));
		end
		ExpPlayerFrameBarExhaust:SetStatusBarColor(0.75,0.75,0.75,1.0);
		if (GetRestState() ~= nil) then
			if (GetRestState() == 1) then
				ExpPlayerFrameBar:SetStatusBarColor(1.00, 0.50, 0.00, 1.0);
			elseif (GetRestState() == 2) then
				ExpPlayerFrameBar:SetStatusBarColor(1.00, 0.50, 0.00, 1.0);
			end
		end

		ExpPlayerFrameBar_UpdateIt();

		--if (ExpPlayerFrameArt == 1) then
		--	MainMenuBarLeftEndCap:Show();
		--	MainMenuBarRightEndCap:Show();
		--else
		--	MainMenuBarLeftEndCap:Hide();
		--	MainMenuBarRightEndCap:Hide();
		--end
	end
end

function ExpPlayerFrameBar_OnClick(button)
	if ( SpellIsTargeting() and button == "RightButton" ) then
		SpellStopTargeting();
		return;
	end
	if ( button == "LeftButton" ) then
		if ( SpellIsTargeting() ) then
			SpellTargetUnit("player");
		elseif ( CursorHasItem() ) then
			AutoEquipCursorItem();
		else
			TargetUnit("player");
		end
	else
		ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "PlayerFrame", 106, 27);
		return;
	end
end

function ExpPlayerFrameBar_UpdateIt()
	if (ExpPlayerFrameBarTemp == 1) then
		if (GetRestState() == 1) then
			PlayerName:SetText(epfReplaceAll(ExpPlayerFrameHoverRest));
		elseif (GetRestState() == 2) then
			PlayerName:SetText(epfReplaceAll(ExpPlayerFrameHover));
		end
	else
		PlayerName:SetText(epfReplaceAll(ExpPlayerFrameHoverMain));
	end
	if (ExpPlayerFramePercentEnabled == 1) then
		ExpPlayerFramePercent:Show();
		ExpPlayerFramePercent:SetText(epfReplaceAll(ExpPlayerFramePercentShow));
	else
		ExpPlayerFramePercent:Hide();
	end
end

function epfReplaceAll (str)
	local epfProcessed = str;
	epfProcessed = gsub(epfProcessed,"&playername",UnitName("player"));
	epfProcessed = gsub(epfProcessed,"&percentxp",floor(UnitXP("player")/UnitXPMax("player")*100));
	epfProcessed = gsub(epfProcessed,"&remainingxppercent",floor((UnitXPMax("player") - UnitXP("player"))/UnitXPMax("player")*100));
	epfProcessed = gsub(epfProcessed,"&currentxp",UnitXP("player"));
	epfProcessed = gsub(epfProcessed,"&maxxp",UnitXPMax("player"));
	epfProcessed = gsub(epfProcessed,"&remainingxp",UnitXPMax("player")-UnitXP("player"));
	if (GetXPExhaustion() ~= nil) then
		epfProcessedTemp = GetXPExhaustion()/2;
	else
		epfProcessedTemp = "0";
	end
	epfProcessed = gsub(epfProcessed,"&restxp",epfProcessedTemp);
	return epfProcessed;
end

function ExpPlayerFrame_OnUpdate (delay)
	--ExpPlayerFrameBar_UpdateIt();
end