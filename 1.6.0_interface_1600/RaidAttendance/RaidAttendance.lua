function RaidAttendance_OnLoad()
	SlashCmdList["RAIDATTENDANCE"] = RaidAttendance_SlashCommandHandler;
	SLASH_RAIDATTENDANCE1 = "/attendance";
end

function RaidAttendance_SlashCommandHandler(msg)
	if( RaidAttendanceFrame:IsVisible() ) then
		HideUIPanel(RaidAttendanceFrame);
	else
		ShowUIPanel(RaidAttendanceFrame);
	end
end

function RaidAttendance_OnShow()
	RaidAttendance_Refresh();
end

function RaidAttendance_Refresh()
	local onlineText = "Online:\r\n";
	local offlineText = "Offline:\r\n";

	for i = 1, GetNumRaidMembers() do
		name, _, _, _, _, _, _, online, _ = GetRaidRosterInfo(i);

		if (online) then
			onlineText = onlineText..name.."\r\n";
		else
			offlineText = offlineText..name.."\r\n";
		end
	end

	RaidAttendanceEditBox:SetText(onlineText.."\r\n"..offlineText);
end