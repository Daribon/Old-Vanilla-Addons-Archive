function ZGAnnounceGUI_Update()
	if ( ZGAnnounceGUI_PassDatabaseFrame:IsShown() ) then
		ZGAnnounceGUI_PassDatabase_InitiatePass(ZGAnnounce_PassItemList);
	end
end

function ZGAnnounceGUI_PassItemListUpdated(item)
	ZGAnnounceGUI_Update();
	return ZGAnnounceGUI_Saved_PassItemListUpdated(item);
end

function ZGAnnounceGUI_Pass()
	local arr = ZGAnnounce_PassItemList;
	if (ZGAnnounceGUI_PassDatabaseFrame:IsVisible()) and ( ZGAnnounceGUI_PassDatabase_CurrentArr == arr ) then
		HideUIPanel(ZGAnnounceGUI_PassDatabaseFrame);
	else
		ZGAnnounceGUI_PassDatabase_InitiatePass(arr);
		ShowUIPanel(ZGAnnounceGUI_PassDatabaseFrame);
	end
end

function ZGAnnounceGUI_OnLoad()
	if ( EarthFeature_AddButton ) then
		EarthFeature_AddButton (
			{ 
				id = "ZGANNOUNCE_GUI_PASS";
				name = ZGANNOUNCE_GUI_BUTTON_PASS_NAME;
				subtext = ZGANNOUNCE_GUI_BUTTON_PASS_SUBTEXT;
				tooltip = ZGANNOUNCE_GUI_BUTTON_PASS_TOOLTIP;
				icon = ZGANNOUNCE_GUI_BUTTON_PASS_ICON;
				callback = ZGAnnounceGUI_Pass;
				test = 	function()
					return true;
				end
			});
	end
	local cmd = "ZGANNOUNCE_GUI_GUICOMMAND";
	SlashCmdList[cmd] = ZGAnnounceGUI_SlashCommand;
	for k, v in ZG_ANNOUNCE_GUI_SLASHCOMMANDS do
		setglobal("SLASH_"..cmd..k, v);
	end
	ZGAnnounceGUI_Saved_PassItemListUpdated = ZGAnnounce_PassItemListUpdated;
	ZGAnnounce_PassItemListUpdated = ZGAnnounceGUI_PassItemListUpdated;
end

function ZGAnnounceGUI_OnEvent()
end

function ZGAnnounceGUI_SlashCommand(msg)
	if ( msg ) and ( strlen(msg) > 0 ) then
		msg = strlower(msg);
		for k, v in ZG_ANNOUNCE_GUI_AVOID_PASS_COMMANDS do
			if ( v == msg ) then
				return ZGAnnounceGUI_Pass();
			end
		end
	end
	for k, v in AQ_ARC_GUI_SLASH_COMMAND_USAGE do
		ChatFrame1:AddMessage(v, 1, 1, 0.1, 1);
	end
end
