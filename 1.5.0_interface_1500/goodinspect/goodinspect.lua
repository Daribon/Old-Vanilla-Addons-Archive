--
--	GoodInspect increases inspect range and adds guild info to the inspect window
--	version 1.0.1 by Ross - 2005
--
BINDING_NAME_GOODINSPECT = "Inspect Target";
BINDING_HEADER_GOODINSPECT = "Good Inspect";

function GoodInspect_OnLoad()
	InspectFrame_OnUpdate = GoodInspect_InspectFrame_OnUpdate;

	GoodInspect_Original_InspectPaperDollFrame_SetLevel = InspectPaperDollFrame_SetLevel;
	InspectPaperDollFrame_SetLevel = GoodInspect_InspectPaperDollFrame_SetLevel;


-- stops the Inspect option in the unit dropdown menu from greying out
	UnitPopupButtons["INSPECT"] = { text = TEXT(INSPECT), dist = 0 };
end


-- left empty to stop distance checking on inspect
function GoodInspect_InspectFrame_OnUpdate()
--	do nothing
end


-- adds guild info to a line in the inspect frame
function GoodInspect_InspectPaperDollFrame_SetLevel()
	GoodInspect_Original_InspectPaperDollFrame_SetLevel();
	local guildname = nil;
	local guildtitle = nil;
	local guildrank = nil;	
	guildname, guildtitle, guildrank = GetGuildInfo("target");
	if(guildname ~= nil) then
		InspectTitleText:Show();
		InspectTitleText:SetText(format(TEXT(GUILD_TITLE_TEMPLATE), guildtitle, guildname));
	else
		InspectTitleText:Hide();
	end
end