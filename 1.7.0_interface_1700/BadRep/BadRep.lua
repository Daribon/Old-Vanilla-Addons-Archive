-- -*- Mode: lua; lua-indent-level: 2; indent-tabs-mode: nil; -*-
--
--  BadRep
--

BadRep_SavedReputation = nil;
BadRep_ShowingDelta = false;

function BadRep_OnLoad()
  RegisterForSave("BadRep_SavedReputation");

  -- overwrite the ReputationFrame_Update
  ReputationFrame_Update = BadRep_RepFrame_Update;

end

function BadRep_OnSaveRepClick()
  local rep = {};
  for i=1, GetNumFactions(), 1 do
    local name, description, standing, value, rest = GetFactionInfo(i);
    local val = standing + value;
    -- save this as a string, because by default we only get
    -- 5 digits of precision in SavedVariables.lua
    rep[name] = string.format("%0.9f", val);
  end

  BadRep_SavedReputation = rep;
  if (BadRep_ShowingDelta) then
    BadRep_RepFrame_Update();
  end
end

function BadRep_OnToggleDeltaClick()
  -- if the data never got stored, then
  -- save it
  if (BadRep_SavedReputation == nil) then
    BadRep_OnSaveRepClick();
  end

  if (BadRep_ShowingDelta) then
    BadRep_ShowingDelta = false;
    BadRep_Reset:Hide();
    BadRep_ToggleButton:SetText(BADREP_SHOWCHANGE);
  else
    BadRep_ShowingDelta = true;
    BadRep_Reset:Show();
    BadRep_ToggleButton:SetText(BADREP_SHOWTOTAL);
  end

  BadRep_RepFrame_Update();
end

function BadRep_NumStringForRep(name, repval)
  if (BadRep_ShowingDelta and BadRep_SavedReputation ~= nil) then
    local oldval = BadRep_SavedReputation[name];
    if (oldval) then
      local delta = repval - oldval;
      if (math.abs(delta) > 0.0000001) then
	return string.format(" (%+0.5f)", delta);
      end
    end

    return "";
  else
    return string.format(" (%0.5f)", repval);
  end
end

--
--  This is ReputationFrame_Update, from ReputationFrame.lua,
--  with our changes to twiddle the text.  Note that we could
--  hook this function instead of replacing it in its entirety,
--  but it would require an extra set of faction info queries
--

function BadRep_RepFrame_Update()
  local numFactions = GetNumFactions();
  local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame);
  local factionIndex, factionStanding, factionBar, factionHeader, color;
  local name, description, standingID, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed;
  local checkbox, check, rightBarTexture;

  -- Update scroll frame
  FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, NUM_FACTIONS_DISPLAYED, REPUTATIONFRAME_FACTIONHEIGHT )
  
  for i=1, NUM_FACTIONS_DISPLAYED, 1 do
    factionIndex = factionOffset + i;
    factionBar = getglobal("ReputationBar"..i);
    factionHeader = getglobal("ReputationHeader"..i);
    if ( factionIndex <= numFactions ) then
      name, description, standingID, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed = GetFactionInfo(factionIndex);
      if ( isHeader ) then
	factionHeader:SetText(name .. BadRep_NumStringForRep(name, standingID+barValue));
        if ( isCollapsed ) then
          factionHeader:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
        else
          factionHeader:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up"); 
        end
        factionHeader.index = factionIndex;
        factionHeader.isCollapsed = isCollapsed;
        factionBar:Hide();
        factionHeader:Show();
      else
        factionStanding = getglobal("FACTION_STANDING_LABEL"..standingID);
        getglobal("ReputationBar"..i.."FactionName"):SetText(name);
	getglobal("ReputationBar"..i.."FactionStanding"):SetText(factionStanding .. BadRep_NumStringForRep(name, standingID+barValue));
        checkbox = getglobal("ReputationBar"..i.."AlliedCheckButton");
        check = getglobal("ReputationBar"..i.."AlliedCheckButtonCheck");
        rightBarTexture = getglobal("ReputationBar"..i.."ReputationBarRight");
        checkbox:SetChecked(atWarWith);
        if ( canToggleAtWar ) then
          checkbox:Enable();
          check:SetVertexColor(1.0, 1.0, 1.0);
          rightBarTexture:SetTexCoord(0, 0.14453125, 0.34375, 0.71875);
        else
          if ( atWarWith ) then
            check:SetVertexColor(1.0, 0.1, 0.1);
            rightBarTexture:SetTexCoord(0.1484375, 0.29296875, 0.34375, 0.71875);
          else
            check:SetVertexColor(1.0, 1.0, 1.0);
            rightBarTexture:SetTexCoord(0.296875, 0.44140625, 0.34375, 0.71875);
          end
          checkbox:Disable();
        end
        factionBar:SetValue(barValue);
        color = FACTION_BAR_COLORS[standingID];
        factionBar:SetStatusBarColor(color.r, color.g, color.b);
        factionBar:SetID(factionIndex);
        factionBar:Show();
        factionHeader:Hide();
      end
    else
      factionHeader:Hide();
      factionBar:Hide();
    end
  end
end
