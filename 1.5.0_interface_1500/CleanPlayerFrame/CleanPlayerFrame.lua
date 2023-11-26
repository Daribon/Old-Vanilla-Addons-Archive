--
-- Clean Player Frame
--
-- by Bastian Pflieger <wb@illogical.de>
--
-- Last update: 27.03.05
--
-- supports "myAddOns": http://www.curse-gaming.com/mod.php?addid=358
--

function CleanPlayerFrame_OnLoad()
  CleanPlayerFrame_IsEnabled = true;
  this:RegisterEvent("VARIABLES_LOADED");
end

function CleanPlayerFrame_Setup(bEnabled)
  CleanPlayerFrame_IsEnabled = bEnabled;
  if bEnabled then
    ManaBarColor[0].prefix = "";
    ManaBarColor[1].prefix = "";
    ManaBarColor[2].prefix = "";
    ManaBarColor[3].prefix = "";
    ManaBarColor[4].prefix = "";
    SetTextStatusBarTextPrefix(PlayerFrameHealthBar, "");
  else
    ManaBarColor[0].prefix = MANA;
    ManaBarColor[1].prefix = RAGE_POINTS;
    ManaBarColor[2].prefix = FOCUS_POINTS;
    ManaBarColor[3].prefix = ENERGY_POINTS;
    ManaBarColor[4].prefix = HAPPINESS_POINTS;
    SetTextStatusBarTextPrefix(PlayerFrameHealthBar, HEALTH);
  end
  SetTextStatusBarTextPrefix(PlayerFrameManaBar, ManaBarColor[UnitPowerType("player")].prefix);
  TextStatusBar_UpdateTextString(PlayerFrameHealthBar);
  TextStatusBar_UpdateTextString(PlayerFrameManaBar);
end

function CleanPlayerFrame_OnEvent(event)
  local VERSION = "4284";

  CleanPlayerFrame_Setup(CleanPlayerFrame_IsEnabled);

  if myAddOnsList and GetLocale() == "deDE" then
    myAddOnsList.CleanPlayerFrame = { name = "Spielerportr\195\164t aufger\195\164umt",
                                      description = "Entfernt den Text \"Gesundheit\" sowie \"Mana\"",
                                      version = VERSION,
                                      frame = "CleanPlayerFrameFrame",
                                      optionsframe = "CleanPlayerFrameOptionsFrame" };
  elseif myAddOnsList then
    myAddOnsList.CleanPlayerFrame = { name = "Clean Player Frame",
                                      description = "Removes text \"Health\" and \"Mana\"",
                                      version = VERSION,
                                      frame = "CleanPlayerFrameFrame",
                                      optionsframe = "CleanPlayerFrameOptionsFrame" };
  end
end