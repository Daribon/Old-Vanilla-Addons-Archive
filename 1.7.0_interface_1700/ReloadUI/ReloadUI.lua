--[[
	ReloadUI
	 	Restart your world
	
	By: Alexander Brazie
	
	This allows you to reload your interface with /rl
	
	$Id: ReloadUI.lua 2053 2005-07-07 01:25:49Z Sinaloit $
	$Rev: 2053 $
	$LastChangedBy: Sinaloit $
	$Date: 2005-07-06 20:25:49 -0500 (Wed, 06 Jul 2005) $
]]--

function TimedReloadUI(time)
	Sea.io.print(math.floor(time-1));
	if ( time <= 1 ) then 
		ReloadUI();
	else
		Chronos.scheduleByName("ReloadUI", 1, TimedReloadUI, time-1);
	end
end

function ReloadUIHandler(msg)
	local time = 2;
	if ( msg ~= "" ) then
		time = tonumber(msg);
	end
	Sea.io.print(string.format(RELOAD_WARNING,time));
	Chronos.scheduleByName("ReloadUI", .5, 
		TimedReloadUI, 
		time
	);
end

function ReloadUICancelHandler(msg)
	Chronos.scheduleByName("ReloadUI", 0, function() Sea.io.print(RELOAD_CANCEL) end );
end

if ( Sky ) then 
       Sky.registerSlashCommand(
            {
                id = "ReloadUI";
                commands = RELOAD_COMMANDS;
                onExecute = ReloadUIHandler;
		helpText=RELOAD_COMMANDS_DESC;
            }
	);
       Sky.registerSlashCommand(
            {
                id = "ReloadUICancel";
                commands = RELOAD_CANCEL_COMMANDS;
                onExecute = ReloadUICancelHandler;
		helpText=RELOADUI_CANCEL_COMMANDS_DESC;
            }
	);
else
	SlashCmdList["RELOADUI_SLASHENABLE"] = ReloadUIHandler;
	for i = 1, table.getn(RELOAD_COMMANDS) do
		setglobal("SLASH_RELOADUI_SLASHENABLE"..i, RELOAD_COMMANDS[i]);
	end;

	SlashCmdList["RELOADUI_CANCEL_SLASHENABLE"] = ReloadUICancelHandler;
	for i = 1, table.getn(RELOAD_CANCEL_COMMANDS) do
		setglobal("SLASH_RELOADUI_CANCEL_SLASHENABLE"..i, RELOAD_CANCEL_COMMANDS[i]);
	end;
end
