--constanst
mifontBlue = "|cff00ccff";
mifontGreen = "|cff00ff00";
mifontRed = "|cffff0000";
mifontGold = "|cffffcc00";
mifontGray = "|cff888888";
mifontWhite = "|cffffffff";
mifontSubWhite = "|cffbbbbbb";
mifontMageta = "|cffff00ff";
mifontYellow  = "|cffffff00";
mifontCyan   = "|cff00ffff";

miVersionNo = ' 2.12'

miVersion = mifontYellow..'MobInfo-2 Version '..miVersionNo..mifontGreen..' http://dizzarian.com';
miPatchNotes = mifontYellow..
  'MobInfo-2 Version '..miVersionNo..'\n\n'..
  '  ver 2.12\n'..
  '    - show separate MobHealth found warning only once\n'..
  '    - event handling code restructured\n'..
  '    - slight compatibility improvement with DUF\n'..
  '    - added documentation: ReadMe_External_AddOns.txt\n\n'..
  '  ver 2.11\n'..
  '    - separate MobHealth existance check fixed\n\n'..
  '  ver 2.1\n'..
  '    - integrated MobHealth-2 into MobInfo\n'..
  '    - added option to disable built-in MobHealth\n'..
  '    - slash commands changed to /mobinfo2 and /mi2\n'..
  '    - added help texts to all options in options dialog\n'..
  '    - redesigned options dialog and integrated MobHealth options\n\n'..
  '  ver 1.9 - 1.93\n'..
  '    - new feature: option to show MobInfo only when ALT key is pressed\n'..
  '    - updated the French translation\n'..
  '    - quality text corrected in french translation\n'..
  '    - changed: combined mode now supports up to 4 levels per Mob\n'..
  '    - changed: calculate item rarity percentage relative to looted counter\n'..
  '    - new feature: option to combine data for Mobs with same name\n'..
  '    - new feature: dont show XP values grey Mobs\n'..
  '    - new feature: dont increase quality counter for quest items\n'..
  '    - redesigned options dialog layout\n'..
  '    - improved accuracy of kill and looted counting\n'..
  '    - improved accuracy of empty loot counting\n'..
  '    - improved corpse reopen detection\n'..
  '  For all previous patch notes and to report bugs please visit http://www.dizzarian.com/forums/viewforum.php?f=16';

miSlashCommands = 
  mifontYellow.. 'Usage /mobinfo <cmd> or /mi <cmd>\n'..
  'Where <cmd> is any of the following\n'..
  mifontGreen..'  help - '..mifontYellow..'This information screen\n'..
  mifontGreen..'  config - '..mifontYellow..'Shows the MobInfo Config Screen\n'..
  mifontGreen..'  clear - '..mifontYellow..'Clears the mobinfo database\n'..
  mifontGreen..'  version - '..mifontYellow..'Displays the current version of the mod\n'..
  mifontGreen..'  notes - '..mifontYellow..'Displays the current patch notes\n'..
  mifontGreen..'  addcustom - '..mifontYellow..'Add Custom tracking item. This is case sensitive\n'..
  mifontGreen..'  removecustom - '..mifontYellow..'Remove Custom tracking item. This is case sensitive\n'..
  mifontGreen..'  listcustom - '..mifontYellow..'List all custom items that you are tracking\n'..
  mifontGreen..'  showclass - '..mifontYellow..'Toggles the mob\'s health on and off\n'..
  mifontGreen..'  showhealth - '..mifontYellow..'Toggles the mob\'s health on and off\n'..
  mifontGreen..'  showdamage - '..mifontYellow..'Toggles the mob\'s damage range on and off\n'..
  mifontGreen..'  showkills - '..mifontYellow..'Toggles the total kills on and off\n'..
  mifontGreen..'  showlooted - '..mifontYellow..'Toggles the number of times you looted the mob on and off\n'..
  mifontGreen..'  showempty - '..mifontYellow..'Toggles the number of times you looted an empty corpse on and off\n'..
  mifontGreen..'  showxp - '..mifontYellow..'Toggles the last mob xp amount on and off\n'..
  mifontGreen..'  show2level - '..mifontYellow..'Toggles the number of kills needed to level on and off\n'..
  mifontGreen..'  showcoin - '..mifontYellow..'Toggles the average coin drop from mob on and off\n'..
  mifontGreen..'  showiv - '..mifontYellow..'Toggles the average total item value drop on and off\n'..
  mifontGreen..'  showmv - '..mifontYellow..'Toggles the total mob value on and off\n'..
  mifontGreen..'  showquality - '..mifontYellow..'Toggles the quality of loot drops on and off\n'..
  mifontGreen..'  showcloth - '..mifontYellow..'Toggles cloth drops on and off\n'..
  mifontGreen..'  showblanklines - '..mifontYellow..'Toggles the extra blank lines onand off\n'..
  mifontGreen..'  showCombined - '..mifontYellow..'combine data for Mobs with same name\n'..
  mifontGreen..'  showOnAlt - '..mifontYellow..'show mob info only when ALT key is pressed\n'..
  mifontGreen..'  saveallvalues - '..mifontYellow..'Saves all values reguardless of if they are shown or not\n'..
  mifontGreen..'  clearonexit - '..mifontYellow..'Clears mobinfo all data on exit so that nothing is stored in your savedvariables\n'..
  mifontGreen..'  healthoff - '..mifontYellow..'completely disable built-in MobHealth functionality\n'..
  mifontGreen..'  default - '..mifontYellow..'Sets mobinfo to it\'s default values\n'..
  mifontGreen..'  allOn - '..mifontYellow..'Sets mobinfo to all values on\n'..
  mifontGreen..'  allOff - '..mifontYellow..'Sets mobinfo to all values on\n'..
  mifontGreen..'  minimal - '..mifontYellow..'Sets mobinfo to minimal values\n';

-- Configs
function miDefaultConfig()
    MobInfoConfig.ShowClass = 1;
    MobInfoConfig.ShowHealth = 1;
    MobInfoConfig.ShowDamage = 1;
    MobInfoConfig.ShowKills = 0;
    MobInfoConfig.ShowLoots = 1;
    MobInfoConfig.ShowEmpty = 0;
    MobInfoConfig.ShowXp = 1;
    MobInfoConfig.ShowNo2lev = 1;
    MobInfoConfig.ShowQuality = 1;
    MobInfoConfig.ShowCloth = 0;
    MobInfoConfig.ShowCoin = 0;
    MobInfoConfig.ShowIV = 0;
    MobInfoConfig.ShowTotal = 1;
end
function miAllConfig()
    MobInfoConfig.ShowHealth = 1;
    MobInfoConfig.ShowClass = 1;
    MobInfoConfig.ShowKills = 1;
    MobInfoConfig.ShowDamage = 1;
    MobInfoConfig.ShowXp = 1;
    MobInfoConfig.ShowNo2lev = 1;
    MobInfoConfig.ShowLoots = 1;
    MobInfoConfig.ShowEmpty = 1;
    MobInfoConfig.ShowCoin = 1;
    MobInfoConfig.ShowIV = 1;
    MobInfoConfig.ShowTotal = 1;
    MobInfoConfig.ShowQuality = 1;
    MobInfoConfig.ShowCloth = 1;
end
function miNoneConfig()
    MobInfoConfig.ShowHealth = 0;
    MobInfoConfig.ShowClass = 0;
    MobInfoConfig.ShowKills = 0;
    MobInfoConfig.ShowDamage = 0;
    MobInfoConfig.ShowXp = 0;
    MobInfoConfig.ShowNo2lev = 0;
    MobInfoConfig.ShowLoots = 0;
    MobInfoConfig.ShowEmpty = 0;
    MobInfoConfig.ShowCoin = 0;
    MobInfoConfig.ShowIV = 0;
    MobInfoConfig.ShowTotal = 0;
    MobInfoConfig.ShowQuality = 0;
    MobInfoConfig.ShowCloth = 0;
end
function miMinimalConfig()
    MobInfoConfig.ShowHealth = 1;
    MobInfoConfig.ShowClass = 1;
    MobInfoConfig.ShowKills = 0;
    MobInfoConfig.ShowDamage = 0;
    MobInfoConfig.ShowXp = 0;
    MobInfoConfig.ShowNo2lev = 1;
    MobInfoConfig.ShowLoots = 0;
    MobInfoConfig.ShowEmpty = 0;
    MobInfoConfig.ShowCoin = 0;
    MobInfoConfig.ShowIV = 0;
    MobInfoConfig.ShowTotal = 1;
    MobInfoConfig.ShowQuality = 0;
    MobInfoConfig.ShowCloth = 0;
end


-----------------------------------------------------------------------------
-- MI2_SlashInit()
--
-- Add all Slash Commands
-----------------------------------------------------------------------------
function MI2_SlashInit()
  SlashCmdList["MOBINFO"] = MI2_SlashParse;
  SLASH_MOBINFO1 = "/mobinfo2"; 
  SLASH_MOBINFO2 = "/mi2"; 
  
  if  MobInfoConfig.HealthOff < 2  then
	SlashCmdList["MOBHEALTH2"] = MI2_MobHealth_CMD;
	SLASH_MOBHEALTH21 = "/mobhealth2";
  end
end


-----------------------------------------------------------------------------
-- MI2_SlashInit()
--
-- Parses the msg sent from the command line
-----------------------------------------------------------------------------
function MI2_SlashParse(msg)
  if (string.lower(msg) == "help") then
    chattext(miSlashCommands)
  end
  if (msg == "") or (string.lower(msg) == "config") then
    if(frmMIConfig:IsVisible()) then
		  frmMIConfig:Hide();
	  else
		  frmMIConfig:Show();
	  end
  end
  if (string.lower(msg) == "clear") then
    --for index, value in MobInfoDB do
    --  MobInfoDB[index] = { };
    --end
    MobInfoDB = { };
    lMobInfoDB = { };
    chattext('MobInfoDB Cleared');
  end

  if (string.lower(msg) == 'version') then
    chattext( miVersion);
  end

  if (string.lower(msg) == 'notes') then
    chattext(miPatchNotes);
  end
  
  if (string.lower(msg) == 'default') then
    miDefaultConfig();
    chattext('Mobinfo defaults loaded.');
  end
  if (string.lower(msg) == 'allon') then
    miAllConfig();
    chattext('Mobinfo all items on.');
  end
  if (string.lower(msg) == 'alloff') then
    miNoneConfig();
    chattext('Mobinfo all items off.');
  end
  if (string.lower(msg) == 'minimal') then
    miMinimalConfig();
    chattext('Mobinfo minimal items on');
  end

  if (string.lower(msg) == 'showclass') then
    if MobInfoConfig.ShowClass == 1 then
      MobInfoConfig.ShowClass = 0;
      chattext('Show mob class set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowClass = 1;
      chattext('Show mob class set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'showhealth') then
    if MobInfoConfig.ShowHealth == 1 then
      MobInfoConfig.ShowHealth = 0;
      chattext('Show mob health set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowHealth = 1;
      chattext('Show mob health set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'showkills') then
    if MobInfoConfig.ShowKills == 1 then
      MobInfoConfig.ShowKills = 0;
      chattext('Show kills set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowKills = 1;
      chattext('Show kills set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'showdamage') then
    if MobInfoConfig.ShowDamage == 1 then
      MobInfoConfig.ShowDamage = 0;
      chattext('Show damage set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowDamage = 1;
      chattext('Show damage set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'showxp') then
    if MobInfoConfig.ShowXp == 1 then
      MobInfoConfig.ShowXp = 0;
      chattext('Show mob xp set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowXp = 1;
      chattext('Show mob xp set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'show2level') then
    if MobInfoConfig.ShowNo2lev == 1 then
      MobInfoConfig.ShowNo2lev = 0;
      chattext('Show mobs to level set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowNo2lev = 1;
      chattext('Show mobs to level set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'showlooted') then
    if MobInfoConfig.ShowLoots == 1 then
      MobInfoConfig.ShowLoots = 0;
      chattext('Show looted set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowLoots = 1;
      chattext('Show looted set to'..mifontGreen..' -ON-');
    end
  end

  if (string.lower(msg) == 'showempty') then
    if MobInfoConfig.ShowEmpty == 1 then
      MobInfoConfig.ShowEmpty = 0;
      chattext('Show empty loots set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowEmpty = 1;
      chattext('Show empty loots set to'..mifontGreen..' -ON-');
    end
  end

 if (string.lower(msg) == 'showcoin') then
    if MobInfoConfig.ShowCoin == 1 then
      MobInfoConfig.ShowCoin = 0;
      chattext('Show avg coin drop set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowCoin = 1;
      chattext('Show avg coin drop set to'..mifontGreen..' -ON-');
    end
  end
 
  if (string.lower(msg) == 'showiv') then
    if MobInfoConfig.ShowIV == 1 then
      MobInfoConfig.ShowIV = 0;
      chattext('Show avg item value set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowIV = 1;
      chattext('Show avg item value set to'..mifontGreen..' -ON-');
    end
  end
  
  if (string.lower(msg) == 'showmv') then
    if MobInfoConfig.ShowTotal == 1 then
      MobInfoConfig.ShowTotal = 0;
      chattext('Show mob value set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowTotal = 1;
      chattext('Show mob value set to'..mifontGreen..' -ON-');
    end
  end
  
  if (string.lower(msg) == 'showquality') then
    if MobInfoConfig.ShowQuality == 1 then
      MobInfoConfig.ShowQuality = 0;
      chattext('Show loot quality set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowQuality = 1;
      chattext('Show loot quality set to'..mifontGreen..' -ON-');
    end
  end
  
  if (string.lower(msg) == 'showcloth') then
    if MobInfoConfig.ShowCloth == 1 then
      MobInfoConfig.ShowCloth = 0;
      chattext('Show cloth drops set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowCloth = 1;
      chattext('Show cloth drops set to'..mifontGreen..' -ON-');
    end
  end
  
  if (string.lower(msg) == 'showblanklines') then
    if MobInfoConfig.ShowBlankLines == 1 then
      MobInfoConfig.ShowBlankLines = 0;
      chattext('Show blank lines set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ShowBlankLines = 1;
      chattext('Show blank lines value set to'..mifontGreen..' -ON-');
    end
  end
  
  if (string.lower(msg) == 'showcombined') then
    if MobInfoConfig.CombinedMode == 1 then
      MobInfoConfig.CombinedMode = 0;
      chattext('Combine same Mobs set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.CombinedMode = 1;
      chattext('Combine same Mobs set to'..mifontGreen..' -ON-');
    end
  end  
  
  if (string.lower(msg) == 'showonalt') then
    if MobInfoConfig.KeypressMode == 1 then
      MobInfoConfig.KeypressMode = 0;
      chattext('Mob info on keypress set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.KeypressMode = 1;
      chattext('Mob info on keypress set to'..mifontGreen..' -ON-');
    end
  end  
  
  if (string.lower(msg) == 'saveallvalues') then
    if MobInfoConfig.SaveAllValues == 1 then
      MobInfoConfig.SaveAllValues = 0;
      chattext('Save all values set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.SaveAllValues = 1;
      chattext('Save all values set to'..mifontGreen..' -ON-');
    end
  end  
  
  if (string.lower(msg) == 'clearonexit') then
    if MobInfoConfig.ClearOnExit == 1 then
      MobInfoConfig.ClearOnExit = 0;
      chattext('Clear all data on exit set to'..mifontGreen..' -OFF-');
    else
      MobInfoConfig.ClearOnExit = 1;
      chattext('Clear all data on exit set to'..mifontGreen..' -ON-');
    end
  end

  if (string.find(string.lower(msg), 'addcustom')) then
    for c in string.gfind(msg, "addcustom (.+)") do
      if (c ~= nil) then
        if MobInfoConfig.CustomTracks[c]==1 then
         chattext(c .. ' is already added to mobinfo')
        else
         MobInfoConfig.CustomTracks[c]=1;
         chattext(c .. ' has been added to mobinfo tracking');
        end
      end
    end
  end

  if (string.find(string.lower(msg), 'removecustom')) then
    for c in string.gfind(msg, "removecustom (.+)") do
      if (c ~= nil) then
        if MobInfoConfig.CustomTracks[c]==1 then
          MobInfoConfig.CustomTracks[c]=nil

          -- go through entire mobinfodb to remove values since they no longer want
          -- it tracked.
          for k, v in MobInfoDB do 
            if MobInfoDB[k][c] then
              MobInfoDB[k][c] = nil
            end
          end
    
          chattext(c .. ' tracking has been removed from mobinfo')
        else
          chattext(c .. ' could not be found');
        end
      end
    end
  end 

  if (string.find(string.lower(msg), 'listcustom')) then
    chattext('Mob Info custom tracks:')
    for key, value in MobInfoConfig.CustomTracks do
      chattext(mifontGreen..key);
    end
  end   
  
  if  string.lower(msg) == 'stablemax'  and  MobInfoConfig.HealthOff == 0 then
    if MobHealthConfig["unstablemax"] then
      MI2_MobHealth_CMD( "stablemax" );
    else
      MI2_MobHealth_CMD( "unstablemax" );
    end
  end

  if  string.lower(msg) == 'healthoff'  then
    if MobInfoConfig.HealthOff == 1 then
      MobInfoConfig.HealthOff = 0;
      MI2_MobHealthFrame:Show();
      chattext('Built-In MobHealth functionality has been'..mifontGreen..' -ENABLED-');
    else
      if MobInfoConfig.HealthOff == 0 then
        MobInfoConfig.HealthOff = 1;
        MI2_MobHealthFrame:Hide();
        chattext('Built-In MobHealth functionality has been'..mifontGreen..' -DISABLED-');
      end
    end
  end

end

function miReloadUI() 
  ConsoleExec("ReloadUI"); 
end  
