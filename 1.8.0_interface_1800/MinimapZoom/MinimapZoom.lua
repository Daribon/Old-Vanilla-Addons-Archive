--[[
 MinimapZoom
    By AnduinLothar
  
    Hide the + and - zoom buttons and zoom using the mouse wheel.
  
]]--

MinimapZoom_Enabled = true;

-- Print to chat
function MinimapZoom_Print_Chat(s)
	DEFAULT_CHAT_FRAME:AddMessage(s)
end

function MinimapZoom_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	
	local level = this:GetParent():GetFrameLevel() - 1;
	if (level < 1) then
		level = 1;
	end
	this:SetFrameLevel(level);
end


function MinimapZoom_OnEvent()
	if (event == "VARIABLES_LOADED") then
		if (Khaos) then
			MinimapZoom_RegisterWithKhaos();
		end
		if (Sky) then
			MinimapZoom_Register_Sky();
		else
			SlashCmdList["SLASH_MINIMAPZOOM"] = MinimapZoom_Enable_ChatCommandHandler;
			for index, command in MinimapZoomSlashCommands do
				setglobal("SLASH_MINIMAPZOOM"..index, command);
			end
		end
	end
end

function MinimapZoom_OnMouseWheel(value)
	if (MinimapZoom_Enabled) then
		if ( value > 0 ) then
			if (MinimapZoomIn:IsEnabled() == 1) then
				Minimap_ZoomInClick();
			end
		elseif ( value < 0 ) then
			if (MinimapZoomOut:IsEnabled() == 1) then
				Minimap_ZoomOutClick();
			end
		end
	end
end

function MinimapZoom_Enable_SetStatus(state)
	if (not state) then
		return;
	elseif (state.checked) then
		MinimapZoom_Enabled = true;
	else
		MinimapZoom_Enabled = nil;
	end
end

function MinimapZoom_HideButtons_SetStatus(state)
	if (not state) then
		return;
	elseif (state.checked) then
		MinimapZoomIn:Hide();
		MinimapZoomOut:Hide();
	else
		MinimapZoomIn:Show();
		MinimapZoomOut:Show();
	end
end

function MinimapZoom_Enable_ChatCommandHandler(msg)
	if (not (msg)) then
		return;
	end
	msg = strlower(msg);
	if (msg == MINIMAP_ZOOM_ON) then
		MinimapZoom_Enable_SetStatus({checked = true});
		MinimapZoom_UpdateKhaosOption("MinimapZoomEnable", true);
		DEFAULT_CHAT_FRAME:AddMessage(MINIMAP_ZOOM_ENABLED_TEXT);
	elseif (msg == MINIMAP_ZOOM_OFF) then
		MinimapZoom_Enable_SetStatus({checked = false});
		MinimapZoom_UpdateKhaosOption("MinimapZoomEnable", false);
		DEFAULT_CHAT_FRAME:AddMessage(MINIMAP_ZOOM_DISABLED_TEXT);
	elseif (msg == MINIMAP_ZOOM_SHOW) then
		MinimapZoom_HideButtons_SetStatus({checked = false});
		MinimapZoom_UpdateKhaosOption("MinimapZoomHideButtons", false);
		DEFAULT_CHAT_FRAME:AddMessage(MINIMAP_ZOOM_SHOW_BUTTONS_TEXT);
	elseif (msg == MINIMAP_ZOOM_HIDE) then
		MinimapZoom_HideButtons_SetStatus({checked = true});
		MinimapZoom_UpdateKhaosOption("MinimapZoomHideButtons", true);
		DEFAULT_CHAT_FRAME:AddMessage(MINIMAP_ZOOM_HIDE_BUTTONS_TEXT);
	else
		DEFAULT_CHAT_FRAME:AddMessage(MINIMAP_ZOOM_CHAT_COMMAND_INFO);
	end
end

function MinimapZoom_UpdateKhaosOption(id, checked)
	if (Khaos) and (Khaos.getSetKey("MinimapZoom", id)) then
		Khaos.setSetKeyParameter("MinimapZoom", id, "checked", checked);
		if (KhaosFrame:IsVisible()) then
			Khaos.refresh(false, false, true);
		end
	end
end

function MinimapZoom_RegisterWithKhaos()
	
	local optionSet = {
		id="MinimapZoom";
		text=MINIMAP_ZOOM_HEADER;
		helptext=MINIMAP_ZOOM_HEADER_INFO;
		difficulty=1;
		options={
			{
				id="Header";
				text=MINIMAP_ZOOM_HEADER;
				helptext=MINIMAP_ZOOM_HEADER_INFO;
				type=K_HEADER;
				difficulty=1;
			};
			{
				id="MinimapZoomEnable";
				type=K_TEXT;
				text=MINIMAP_ZOOM_ENABLE;
				helptext=MINIMAP_ZOOM_ENABLE_INFO;
				callback=MinimapZoom_Enable_SetStatus;
				feedback=function(state) if (state.checked) then return MINIMAP_ZOOM_ENABLED_TEXT; else return MINIMAP_ZOOM_DISABLED_TEXT; end; end;
				check=true;
				default={checked=true};
				disabled={checked=false};
			};
			{
				id="MinimapZoomHideButtons";
				type=K_TEXT;
				text=MINIMAP_ZOOM_HIDE_BUTTONS;
				helptext=MINIMAP_ZOOM_HIDE_BUTTONS_INFO;
				callback=MinimapZoom_HideButtons_SetStatus;
				feedback=function(state) if (state.checked) then return MINIMAP_ZOOM_HIDE_BUTTONS_TEXT; else return MINIMAP_ZOOM_SHOW_BUTTONS_TEXT; end; end;
				check=true;
				default={checked=false};
				disabled={checked=false};
			};
		};
	};
	Khaos.registerOptionSet(
		"maps",
		optionSet
	);
	MinimapZoom_Khaos_IsLoaded = true;
end

function MinimapZoom_Register_Sky()
	Sky.registerSlashCommand(
		{
			id="MinimapZoomStatus";
			commands = MinimapZoomSlashCommands;
			onExecute = MinimapZoom_Enable_ChatCommandHandler;
			helpText = MINIMAP_ZOOM_CHAT_COMMAND_INFO;
		}
	);
	MinimapZoom_Sky_Registered = true;
end
