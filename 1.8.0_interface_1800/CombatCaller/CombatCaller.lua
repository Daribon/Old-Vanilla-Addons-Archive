--[[

 Combat Caller
    By Alexander Brazie
  
  Automates Low-HP and Out-Of-Mana calls

  This was written for testing of the shared
  configuration module I'm writing. 
  (But first, I need a module to configure!) 
  
   Modded by Arys 02-02-05
   Changed limit sliders to move at 5% increments and range from 10%-90%
   Force a minimum cooldown of 1 second even when disabled

   fixed mana shout
   fixed khaos support of alex
   added pet support
   merged alot of function
   
   --! todo: chronos
]]--



-- These will be the values with checkboxes
CombatCaller =
{  player =
   {
      hp =
      {  active = true;
         ratio = .4;
      };
      mana =
      {  active = true;
         ratio = .3;
      };
   };
   pet =
   {
      hp =
      {  active = true;
         ratio = .4;
      };
   };
   cooldownTime = 30;
};

function CombatCaller_OnLoad()
   this:RegisterEvent("UNIT_HEALTH");
   this:RegisterEvent("UNIT_MANA");
   this:RegisterEvent("PLAYER_ENTER_COMBAT");
   this:RegisterEvent("PLAYER_LEAVE_COMBAT");
   
   this.hp = -1;
   this.mana = -1;
   this.lasthp = -1;
   this.lastmana = -1;
   this.InCombat = 0;
   this.IsGhost = 0;
   this.LastHPShout = 0;
   this.LastManaShout = 0;
   this.lastpethp = -1;
   this.LastPetHPShout = 0;

   if ( Khaos ) then
      Khaos.registerOptionSet(
         "combat", 
         {
            id = "CombatCaller";
            text = COMBATC_SEP;
            helptext = COMBATC_SEP_INFO;
            difficulty = 1;
            options = {
               {
                  id="CombatCallerHeader";
                  type=K_HEADER;
                  difficulty=1;
                  text=COMBATC_SEP;
                  helptext=COMBATC_SEP_INFO;
               };
               {
                  id="CombatCallerHealthLimit";
                  key="CombatCallerHealth";
                  check=true;
                  type=K_SLIDER;
                  difficulty=1;
                  text=COMBATC_HEALTH;
                  helptext=COMBATC_HEALTH_INFO;
                  callback=function(state) return CombatCaller_Khaos_ConfigUpdate("player", "hp", state); end;
                  feedback=function(state) return CombatCaller_Khaos_FeedBack("player","hp",state); end;
                  default={
                     checked = true;
                     slider = .25;
                  };
                  disabled={
                     checked = false;
                     slider = .25;
                  };
                  dependencies={
                     ["CombatCallerHealth"]={checked=true;match=true};
                  };
                  setup = {
                     sliderMin = .1;
                     sliderMax = .9;
                     sliderStep = .05;
                     sliderText = COMBATC_HEALTH_LIMIT;
                     sliderDisplayFunc = function (value) return string.format(COMBATC_SLIDER_STRING,math.floor(value*100)); end;
                  };
               };
               {
                  id="CombatCallerManaLimit";
                  key="CombatCallerMana";
                  check=true;
                  type=K_SLIDER;
                  text=COMBATC_MANA;
                  difficulty=1;
                  helptext=COMBATC_MANA_INFO;
                  callback=function(state) return CombatCaller_Khaos_ConfigUpdate("player", "mana", state); end;
                  feedback=function(state) return CombatCaller_Khaos_FeedBack("player","mana",state); end;
                  default={
                     checked = true;
                     slider = .25;
                  };
                  disabled={
                     checked = false;
                     slider = .25;
                  };
                  setup = {
                     sliderMin = .1;
                     sliderMax = .9;
                     sliderStep = .05;
                     sliderText = COMBATC_MANA_LIMIT;
                     sliderDisplayFunc = function (value) return string.format(COMBATC_SLIDER_STRING,math.floor(value*100)); end;
                  };
                  dependencies = {
                     ["CombatCallerMana"]={checked=true;match=true};
                  };
               };
               {
                  id="CombatCallerPetHealthLimit";
                  key="CombatCallerPetHealth";
                  check=true;
                  type=K_SLIDER;
                  difficulty=1;
                  text=COMBATC_PET_HEALTH;
                  helptext=COMBATC_PET_HEALTH_INFO;
                  callback=function(state) return CombatCaller_Khaos_ConfigUpdate("pet", "hp", state); end;
                  feedback=function(state) return CombatCaller_Khaos_FeedBack("pet","hp",state); end;
                  default={
                     checked = fals;
                     slider = .25;
                  };
                  disabled={
                     checked = false;
                     slider = .25;
                  };
                  dependencies={
                     ["CombatCallerPetHealth"]={checked=true;match=true};
                  };
                  setup = {
                     sliderMin = .1;
                     sliderMax = .9;
                     sliderStep = .05;
                     sliderText = COMBATC_PET_HEALTH_LIMIT;
                     sliderDisplayFunc = function (value) return string.format(COMBATC_SLIDER_STRING,math.floor(value*100)); end;
                  };
               };
               {
                  id="CombatCallerCooldownMin";
                  key="CombatCallerCooldown";
                  check=false;
                  type=K_SLIDER;
                  text=COMBATC_COOL;
                  difficulty=2;
                  helptext=COMBATC_COOL_INFO;
                  callback=CombatCaller_Khaos_CooldownUpdate;
                  feedback=CombatCaller_Khaos_CooldownFeedback;
                  default={
                     checked=true;
                     slider=10;
                  };
                  disabled={
                     checked=true;
                     slider=.5;
                  };
                  setup={
                     sliderMin = 1;
                     sliderMax = 90;
                     sliderStep = 1;
                     sliderText = COMBATC_COOL_LIMIT;
                     sliderDisplayFunc = function (value) return value..COMBATC_COOL_SEC; end;
                  };
                  --[[dependencies = {
                     ["CombatCallerCooldown"]={checked=true;match=true};
                  };                                                      ]]--
               };
            };
         }
      );
   elseif ( Cosmos_RegisterConfiguration ) then
   -- Register with the CosmosMaster
   Cosmos_RegisterConfiguration(
      "COS_COMCALLER",
      "SECTION",
      COMBATC_SEP,
      COMBATC_SEP_INFO
      );
   Cosmos_RegisterConfiguration(
      "COS_COMCALLER_HEADER",
      "SEPARATOR",
      COMBATC_SEP,
      COMBATC_SEP_INFO
      );
    Cosmos_RegisterConfiguration(
       "COS_COMCALLER_HEALTHSLIMIT", --CVar
       "BOTH",                   --Things to use
       COMBATC_HEALTH,           --Simple String
       COMBATC_HEALTH_INFO,      --Description
       function(toggle, value) local t = { slider = value; checked = (toggle == 1);}; return CombatCaller_Khaos_ConfigUpdate("player", "hp", t); end,       --Callback
       0,                        --Default Checked/Unchecked
       .2,                       --Default Value
       .1,                       --Min value
       .9,                       --Max value
       COMBATC_HEALTH_LIMIT,     --Slider Text
       .05,                      --Slider Increment
       1,                        --Slider state text on/off
       "\%",                     --Slider state text append
       100                       --Slider state text multiplier
       );
    Cosmos_RegisterConfiguration(
       "COS_COMCALLER_MANASLIMIT", 
       "BOTH", 
       COMBATC_MANA, 
       COMBATC_MANA_INFO,        --Description
       function(toggle, value) local t = { slider = value; checked = (toggle == 1);}; return CombatCaller_Khaos_ConfigUpdate("player", "mana", t); end,       --Callback
       0,
       .2, 
       .1, 
       .9, 
       COMBATC_MANA_LIMIT, 
       .05, 
       1, 
       "\%",
       100
       );
   Cosmos_RegisterConfiguration(
       "COS_COMCALLER_PET_HEALTHSLIMIT", --CVar
       "BOTH",                      --Things to use
       COMBATC_PET_HEALTH,          --Simple String
       COMBATC_PET_HEALTH_INFO,     --Description
       function(toggle, value) local t = { slider = value; checked = (toggle == 1);}; return CombatCaller_Khaos_ConfigUpdate("pet", "hp", t); end,       --Callback
       0,                               --Default Checked/Unchecked
       .2,                               --Default Value
       .1,                               --Min value
       .9,                            --Max value
       COMBATC_PET_HEALTH_LIMIT,                --Slider Text
       .05,                            --Slider Increment
       1,                               --Slider state text on/off
       "\%",                            --Slider state text append
       100                               --Slider state text multiplier
       );
    Cosmos_RegisterConfiguration(
       "COS_COMCALLER_COOLDOWN", 
       "SLIDER", 
       COMBATC_COOL, 
       COMBATC_COOL_INFO,              --Description
       function(toggle, value) local t = { slider = value}; return CombatCaller_Khaos_CooldownUpdate(t); end,       --Callback ----
       1,
       30, 
       1, 
       60, 
       COMBATC_COOL_LIMIT, 
       1, 
       1, 
       COMBATC_COOL_SEC,
       1   
       );
    end
end

function CombatCaller_OnEvent(event) 
   if ( UnitIsDeadOrGhost("player") ) then
      this.IsGhost = 1;
      return;
   elseif ( this.IsGhost == 1 ) then
      this.hp = UnitHealth("player");
      this.lasthp = this.hp;
      this.mana = UnitMana("player");
      this.lastmana = this.mana;
      this.pethp = UnitHealth("pet");
      this.lastpethp = UnitHealth("pet");
      this.IsGhost = 0;
      this.InCombat = 0;
      return;
   end
   if (event == "PLAYER_ENTER_COMBAT") then
      this.InCombat = 1;
   elseif (event == "PLAYER_LEAVE_COMBAT") then
      this.InCombat = 0;
   end
   if( this.InCombat == 0 ) then
      return;
   end
   if ( event == "UNIT_HEALTH" ) then
      this.lasthp = this.hp;
      this.hp = UnitHealth("player");
      local maxhp = UnitHealthMax("player")
      local ratio = UnitHealth("player")/maxhp;
      local oldratio = this.lasthp/maxhp;


      if ( (this.hp < this.lasthp) and
           (ratio < CombatCaller.player.hp.ratio) and
           (GetTime() - this.LastHPShout > CombatCaller.cooldownTime)) then
               CombatCaller_ShoutLowHealth();
         this.LastHPShout = GetTime();
      end
      

      if (UnitHealthMax("pet") > 0) then
         this.lastpethp = this.pethp;
         this.pethp = UnitHealth("pet");
         local maxhp = UnitHealthMax("pet");
         local ratio = this.pethp/maxhp;
         local oldratio = this.lasthp/maxhp;
         if ( this.pethp and this.lastpethp and (this.pethp < this.lastpethp) and
              (ratio < CombatCaller.pet.hp.ratio) and
              (GetTime() - this.LastPetHPShout > CombatCaller.cooldownTime)) then
                  CombatCaller_ShoutLowPetHealth();
                  this.LastPetHPShout = GetTime();
         end
      end
   end
   if ( event == "UNIT_MANA" ) then
      if(UnitPowerType("player") ~= 0) then
        this.mana = 0;
        this.lastmana = 0;
      else 
        this.lastmana = this.mana;
        this.mana = UnitMana("player");
        local ratio = UnitMana("player")/UnitManaMax("player");
        local oldratio = this.lastmana/UnitManaMax("player");

        if ( (this.mana < this.lastmana) and
             (ratio < CombatCaller.player.mana.ratio) and
             (GetTime() - this.LastManaShout > CombatCaller.cooldownTime)) then
                  CombatCaller_ShoutLowMana();
                  this.LastManaShout = GetTime();
        end
      end
   end
end

function CombatCaller_Khaos_FeedBack(who, stats, state)
   value = math.floor(state.slider*100);
   local feedback = COMBATC_FEEDBACK[who][stats];
   local sub;
   if ( state.checked ) then
       sub = string.format(COMBATC_FEEDBACK.INSERT, value);
   else
      sub = COMBATC_FEEDBACK.NEVER;
   end
   feedback = string.format(feedback, sub, CombatCaller.cooldownTime);
   return feedback;
end

function CombatCaller_Khaos_CooldownFeedback(state)
   return string.format(COMBATC_FEEDBACK.COOLDOWN, CombatCaller.cooldownTime);
end

function CombatCaller_Khaos_ConfigUpdate(who, stats, status)
   if ( not status.checked ) then
      CombatCaller[who][stats] =
      {
         active = false;
         ratio = status.slider;
      }
   else
      CombatCaller[who][stats] =
      {
         active = true;
         ratio = status.slider;
      };
   end
end



function CombatCaller_Khaos_CooldownUpdate(status)
   CombatCaller.cooldownTime = status.slider;
end

function CombatCaller_ShoutLowHealth()
   if ( CombatCaller.player.hp.active and this.InCombat == 1 ) then
      DoEmote("HEALME");
   end
end

function CombatCaller_ShoutLowMana()
   if ( CombatCaller.player.mana.active and this.InCombat == 1 ) then
      DoEmote("OOM");
   end
end

function CombatCaller_ShoutLowPetHealth()
   if ( CombatCaller.pet.hp.active and this.InCombat == 1 ) then
      SendChatMessage(COMBATC_PET_SHOUT1 .. UnitName("pet") .. COMBATC_PET_SHOUT2, "EMOTE");
   end
end


function CombatCaller_TurnOff()
   this.player.hp.active = false;
   this.player.mana.active = false;
   this.pet.healt.active = false;
end

function CombatCaller_TurnOn()
   this.player.hp.active = true;
   this.player.mana.active = true;
   this.pet.healt.active = true;
end








