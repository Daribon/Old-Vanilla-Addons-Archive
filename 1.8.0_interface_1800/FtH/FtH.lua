TITAN_FTHRIGHT_ID = "FtH";
TITAN_FTH_TOOLTIP = "Display For the Horde Menu";
TITAN_FTHRIGHT_MENU_TEXT = "For the Horde Menu";

function FtH_OnLoad()
	SlashCmdList["RELOADUI"] = ReloadUI;
	SLASH_RELOADUI1	=	"/rl";
	SLASH_RELOADUI2	=	"/reload";
end

function TitanPanelFtHRightButton_OnLoad()
	this.registry = {
		id = TITAN_FTHRIGHT_ID,
		--builtIn = 1,
		menuText = TITAN_FTHRIGHT_MENU_TEXT, 
		tooltipTitle = TITAN_FTH_TOOLTIP,
	};
end

function TitanPanelFtHRightButton_OnShow()
	TitanPanelFtHButton_SetIcon();
end

function TitanPanelFtHRightButton_OnClick(button)
	if( FtHButtonFrame:IsVisible() ) then
	   HideUIPanel(FtHButtonFrame);
	   PlaySound("igSpellBookClose");
	else				
	   ShowUIPanel(FtHButtonFrame);
	   PlaySound("igSpellBookOpen");
	end
end

function TitanPanelFtHButton_SetIcon()
    local icon = TitanPanelFtHButtonIcon;
	icon:SetTexture("Interface\\Addons\\FtH\\Images\\fth.tga");	
end

function TitanPanelRightClickMenu_PrepareFtHMenu()
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_FTHRIGHT_ID].menuText);
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_FTH_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end
