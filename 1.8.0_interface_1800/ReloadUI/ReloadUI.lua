--[[
   ReloadUI
       Restart your world
   
   By: Alexander Brazie
   
   This allows you to reload your interface with /rl
   
   $Id: ReloadUI.lua 2525 2005-09-26 19:05:29Z karlkfi $
   $Rev: 2525 $
   $LastChangedBy: karlkfi $
   $Date: 2005-09-26 14:05:29 -0500 (Mon, 26 Sep 2005) $

   Small changes by Daun:
      Added a message for when the countdown completes and implemented it as RELOAD_MESSAGE.
      Changed a timer that was only half a second to a second for a more consistant looking countdown.
      Completely rewrote the Bindings.xml.  Initiates a countdown on the keypress that is cancelled if you
      let go of the binding before the countdown has completed.
]]--

function TimedReloadUI(time)
   if ( time <= 1 ) then
      Sea.io.print(RELOAD_MESSAGE);
      ReloadUI();
   else
      Sea.io.print(string.format(RELOAD_WARNING,math.floor(time-1)));
      Chronos.scheduleByName("ReloadUI", 1, TimedReloadUI, time-1);
   end
end

function ReloadUIHandler(msg)
   local time = 2;
   if ( msg ~= "" ) then
      time = tonumber(msg);
   end
   Sea.io.print(string.format(RELOAD_WARNING,time));
   Chronos.scheduleByName("ReloadUI", 1, TimedReloadUI, time);
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