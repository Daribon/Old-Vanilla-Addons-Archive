
function miConfig_OnLoad()
	tinsert(UISpecialFrames, "frmMIConfig"); -- Esc Closes Options Frame
  UIPanelWindows["frmMIConfig"] = {area = "center", pushable = 0};
end

function MI2_UpdateOptions()
  MI2_OptShowClass:SetChecked(MobInfoConfig.ShowClass);
  MI2_OptShowHealth:SetChecked(MobInfoConfig.ShowHealth);
  MI2_OptShowDamage:SetChecked(MobInfoConfig.ShowDamage);
  MI2_OptShowKills:SetChecked(MobInfoConfig.ShowKills);
  MI2_OptShowLooted:SetChecked(MobInfoConfig.ShowLoots);
  MI2_OptShowEmpty:SetChecked(MobInfoConfig.ShowEmpty);
  MI2_OptShowXP:SetChecked(MobInfoConfig.ShowXp);
  MI2_OptShowToLevel:SetChecked(MobInfoConfig.ShowNo2lev);
  MI2_OptShowQuality:SetChecked(MobInfoConfig.ShowQuality);
  MI2_OptShowCloth:SetChecked(MobInfoConfig.ShowCloth);
  MI2_OptShowCoin:SetChecked(MobInfoConfig.ShowCoin);
  MI2_OptShowIV:SetChecked( MobInfoConfig.ShowIV);
  MI2_OptShowMobValue:SetChecked(MobInfoConfig.ShowTotal);
  MI2_OptShowBlanks:SetChecked(MobInfoConfig.ShowBlankLines);
  MI2_OptSaveAll:SetChecked(MobInfoConfig.SaveAllValues);
  MI2_OptClearOnExit:SetChecked(MobInfoConfig.ClearOnExit);
  MI2_OptCombined:SetChecked(MobInfoConfig.CombinedMode);
  MI2_OptKeyMode:SetChecked(MobInfoConfig.KeypressMode);
  MI2_OptDisableMobHealth:SetChecked(MobInfoConfig.HealthOff);
  
  if  MobHealthConfig["unstablemax"]  then
    MI2_OptStableMax:SetChecked( 0 );
  else
    MI2_OptStableMax:SetChecked( 1 );
  end
  
  -- handle enabling/disabling MobHealth
  -- handle initialisation of Mob health position slider
  local sliderPos = tonumber(MobHealthConfig["position"] or 22);
  if  MobInfoConfig.HealthOff > 0  then
    MI2_OptStableMax:Disable();
    MI2_OptStableMaxText:SetTextColor( 0.5, 0.5, 0.5 );
    MI2_OptHealthPosText:SetTextColor( 0.5, 0.5, 0.5 );
    MI2_OptHealthPos:SetMinMaxValues( sliderPos, sliderPos );
  else
    MI2_OptStableMax:Enable();
    MI2_OptStableMaxText:SetTextColor( 1.0, 0.8, 0.0 );
    MI2_OptHealthPosText:SetTextColor( 1.0, 0.8, 0.0 );
    MI2_OptHealthPos:SetMinMaxValues( -30, 90 );
    MI2_OptHealthPos:SetValue( sliderPos );
  end
end

-----------------------------------------------------------------------------
-- MI2_ShowOptionHelpTooltip()
--
-- Show help text for current hovered option in options dialog
-- in the game tooltip window.
-----------------------------------------------------------------------------
function MI2_ShowOptionHelpTooltip()
  --GameTooltip_SetDefaultAnchor( GameTooltip, this );
  GameTooltip_SetDefaultAnchor( GameTooltip, UIParent );
  GameTooltip:SetText( mifontWhite..MI2_OPTIONS[this:GetName()].text );
  
  if  this:GetName() == "MI2_OptHealthPos" then
    GameTooltip:AddLine( mifontWhite.."Pos = "..this:GetValue() );
  end
  
  GameTooltip:AddLine(mifontYellow..MI2_OPTIONS[this:GetName()].help);
  if MI2_OPTIONS[this:GetName()].info then
    GameTooltip:AddLine(mifontYellow..MI2_OPTIONS[this:GetName()].info);
  end
  GameTooltip:Show();
end -- of MI2_ShowOptionHelpTooltip()


function miConfig_OnShow()
  txtMIConfigTitle:SetText( MI_TXT_CONFIG_TITLE );
  chattext(txtMIConfigTitle:GetText());

  -- Disable the button to enable built-in MobHealth if MobHealth
  -- has been automatically disabled
  if  MobInfoConfig.HealthOff == 2  then
    MI2_OptDisableMobHealth:Disable();
    MI2_OptDisableMobHealthText:SetTextColor( 0.5, 0.5, 0.5 );
  end
  
  MI2_OptHealthPos:SetValueStep( 1 );
  MI2_OptHealthPosLow:SetText( "-30" );
  MI2_OptHealthPosHigh:SetText( "90" );

  MI2_UpdateOptions();
end

function miConfig_OnMouseDown(arg1)
  if (arg1 == "LeftButton") then
		frmMIConfig:StartMoving();
	end
end

function miConfig_OnMouseUp(arg1)
  if (arg1 == "LeftButton") then
		frmMIConfig:StopMovingOrSizing();
  end
end

function miConfig_btnMIDone_OnClick()
  HideUIPanel(frmMIConfig);
	if MYADDONS_ACTIVE_OPTIONSFRAME then
    if (MYADDONS_ACTIVE_OPTIONSFRAME == this) then
      ShowUIPanel(myAddOnsFrame);
    end
  end
end


-----------------------------------------------------------------------------
-- MI2_OnSliderValueChanged()
--
-- Show help text for current hovered option in options dialog
-- in the game tooltip window.
-----------------------------------------------------------------------------
function MI2_OnSliderValueChanged()
  if  MobInfoConfig.HealthOff == 0  then
    MI2_MobHealth_CMD( (MI2_OPTIONS[this:GetName()].cmnd)..this:GetValue() ); 
    MI2_ShowOptionHelpTooltip();
  end
end  -- of MI2_OnSliderValueChanged()

