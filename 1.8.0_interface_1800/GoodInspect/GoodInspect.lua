--
--	GoodInspect increases inspect range and allows inspection of opposing faction members.
--	also adds guild info to inspect window a la your character sheet.
--	version 1.0.2 by usea - 2005
--
BINDING_NAME_GOODINSPECT = "Inspect Target";
BINDING_HEADER_GOODINSPECT = "Good Inspect";

function GoodInspect_OnLoad()
	InspectFrame_LoadUI();
	InspectFrame_OnUpdate = GoodInspect_InspectFrame_OnUpdate;

	GoodInspect_Original_InspectPaperDollFrame_SetLevel = InspectPaperDollFrame_SetLevel;
	InspectPaperDollFrame_SetLevel = GoodInspect_InspectPaperDollFrame_SetLevel;

	InspectUnit = GoodInspect_InspectUnit;

-- stops the Inspect option in the unit dropdown menu from greying out
	UnitPopupButtons["INSPECT"] = { text = TEXT(INSPECT), dist = 0 };
end


-- left empty to stop distance checking on inspect
function GoodInspect_InspectFrame_OnUpdate()
--	do nothing
end


-- allows inspection of opposing faction members
function GoodInspect_InspectUnit(unit)
	HideUIPanel(InspectFrame);
	if ( UnitExists(unit) and UnitIsPlayer(unit) ) then
		NotifyInspect(unit);
		InspectFrame.unit = unit;
		ShowUIPanel(InspectFrame);
	end
end


-- adds guild info to a line in the inspect frame
function GoodInspect_InspectPaperDollFrame_SetLevel()
	GoodInspect_Original_InspectPaperDollFrame_SetLevel();
	local guildname = nil;
	local guildtitle = nil;
	local guildrank = nil;	
	guildname, guildtitle, guildrank = GetGuildInfo("target");
	if(guildname ~= nil and guildtitle ~= nil and guildrank ~= nil) then
		InspectTitleText:SetText(format(TEXT(GUILD_TITLE_TEMPLATE), guildtitle, guildname));
		InspectTitleText:Show();
	else
		InspectTitleText:Hide();
	end
end