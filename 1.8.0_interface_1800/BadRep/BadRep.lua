-- -*- Mode: lua; lua-indent-level: 4; indent-tabs-mode: true; -*-
--
--  BadRep
--

BadRep_SavedReputation = nil;
BadRep_Options = {};
BADREP_DELTA = false;

function BadRep_OnLoad()
	-- overwrite the ReputationFrame_Update
	BadRep_RepFrame_Update_Old = ReputationFrame_Update;
	ReputationFrame_Update = BadRep_RepFrame_Update;

	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("ADDON_LOADED");

	-- Because we might (someday) be Loaded On Demand, we'll try to register 
	-- with Khaos... again, and again and again. :) /sarf
	BadRep_Options_Khaos();
end

function BadRep_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then
		BadRep_VariablesLoaded();
	elseif ( event == "ADDON_LOADED" ) then
		if ( arg1 == "Khaos" ) then
			BadRep_Options_Khaos();
		elseif( arg1 == "BadRep" ) then
			-- added this entry due to the stuff in patch.txt re: 1.8.0 stuff
			BadRep_VariablesLoaded();
		end
	end
end

function BadRep_VariablesLoaded()
	-- compatible with old variables
	if ( BadRep_Options.showing ) then
		BadRep_Options.showing = BadRep_Options.showing;
		BadRep_Options.showing = nil;
	end
	for k, v in pairs(BADREP_OPTIONS_DEFAULT) do
		if ( BadRep_Options[k] == nil ) then
			BadRep_Options[k] = v;
		end
	end
	if ( BadRep_SavedReputation ) then
		local db_version = BadRep_SavedReputation[BADREP_VERSION_INDEX];
		if ( not db_version ) or ( db_version ~= BADREP_VERSION_VALUE ) then
			if ( ChatFrame1 ) and ( ChatFrame1.AddMessage ) then
				ChatFrame1:AddMessage(BADREP_MSG_VERSION);
			end
			if ( UIErrorsFrame ) and ( UIErrorsFrame.AddMessage ) then
				UIErrorsFrame:AddMessage(BADREP_MSG_VERSION, 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
			end
			BadRep_SavedReputation = nil;
		end
	end
end


function BadRep_OnSaveRepClick()
	local rep = {};
	local name, description, standing, barMin, barMax, value, rest;
	local val;
	for i=1, GetNumFactions(), 1 do
		name, description, standing, barMin, barMax, value, rest = GetFactionInfo(i);
		val = value;
		-- save this as a string, because by default we only get
		-- 5 digits of precision in SavedVariables.lua
		-- I do not know if this is needed anymore, but hey, it can't hurt... much. /sarf
		rep[name] = string.format("%0.9f", val);
	end
	
	BadRep_SavedReputation = rep;
	BadRep_SavedReputation[BADREP_VERSION_INDEX] = BADREP_VERSION_VALUE;
	if (BADREP_DELTA) then
		BadRep_RepFrame_Update();
	end
end

function BadRep_OnToggleDeltaClick()
	-- if the data never got stored, then
	-- save it
	if (BadRep_SavedReputation == nil) then
		BadRep_OnSaveRepClick();
	end
	
	if (BadRep_Options.showing == BADREP_TOTAL and not BADREP_DELTA) then
		BadRep_Options.showing = BADREP_TOTAL;
		BADREP_DELTA = true;
	elseif (BadRep_Options.showing == BADREP_TOTAL and BADREP_DELTA) then
		BadRep_Options.showing = BADREP_ABS;
		BADREP_DELTA = false;
	elseif (BadRep_Options.showing == BADREP_ABS and not BADREP_DELTA) then
		BadRep_Options.showing = BADREP_ABS;
		BADREP_DELTA = true;
	else
		BadRep_Options.showing = BADREP_TOTAL;
		BADREP_DELTA = false;
	end
	
	BadRep_RepFrame_Update();
end

function BadRep_NumStringForRep(name, standingID, repval, barMax, barMin)
	if (BadRep_Options.showing == BADREP_TOTAL and BADREP_DELTA and BadRep_SavedReputation ~= nil) then
		local oldval = BadRep_SavedReputation[name];
		if (oldval) then
			local delta = (repval - oldval)/(barMax-barMin)*100;
			if (math.abs(delta) > 0.0000001) then
				if ( delta > 0 ) then
					return string.format(" (%+0.3f%%)", delta);
				else
					return string.format(" (%0.3f%%)", delta);
				end
			end
		end
		return " ("..BADREP_NOCHANGE..")";
	elseif BadRep_Options.showing == BADREP_TOTAL and not BADREP_DELTA then
		return string.format(" (%0.3f%%)", (repval-barMin)/(barMax-barMin)*100);
	elseif BadRep_Options.showing == BADREP_ABS and BADREP_DELTA then
		local oldval = BadRep_SavedReputation[name];
		if (oldval) then
			local delta = (repval) - oldval;
			if (math.abs(delta) > 0.0000001) then
				if ( delta > 0 ) then
					return string.format(" (+%d)", delta);
				else
					return string.format(" (%d)", delta);
				end
			end
		end
		return " ("..BADREP_NOCHANGE..")";
	else
		return string.format(" (%d/%d)", repval-barMin, barMax-barMin);
	end
end

--
--  This is ReputationFrame_Update, from ReputationFrame.lua,
--  with our changes to twiddle the text.  Note that we could
--  hook this function instead of replacing it in its entirety,
--  but it would require an extra set of faction info queries
--

function BadRep_RepFrame_Update()
	if ( not BadRep_Options.enabled ) and ( BadRep_RepFrame_Update_Old ) then
		BadRep_RepFrame_Update_Old();
	end
	local numFactions = GetNumFactions();
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame);
	local factionIndex, factionStanding, factionBar, factionHeader, color, tooltipStanding;
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed;
	local checkbox, check, rightBarTexture;

-- BadRep insert code START

	if (BadRep_Options.showing == BADREP_TOTAL and not BADREP_DELTA) then
		BadRep_Reset:Hide();
		BadRep_ToggleButton:SetText(BADREP_SHOWCHANGE);
	elseif (BadRep_Options.showing == BADREP_TOTAL and BADREP_DELTA) then
		BadRep_Reset:Show();
		BadRep_ToggleButton:SetText(BADREP_SHOWABS);
	elseif (BadRep_Options.showing == BADREP_ABS and not BADREP_DELTA) then
		BadRep_Reset:Hide();
		BadRep_ToggleButton:SetText(BADREP_SHOWCHANGENUM);
	else
		BadRep_Reset:Show();
		BadRep_ToggleButton:SetText(BADREP_SHOWTOTAL);
	end

-- BadRep insert code END

	-- Update scroll frame
	FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, NUM_FACTIONS_DISPLAYED, REPUTATIONFRAME_FACTIONHEIGHT )
		
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		factionIndex = factionOffset + i;
		factionBar = getglobal("ReputationBar"..i);
		factionHeader = getglobal("ReputationHeader"..i);
		if ( factionIndex <= numFactions ) then
			name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed = GetFactionInfo(factionIndex);

-- BadRep insert code START

			local oldBarMin = barMin;
			local badRepStr = BadRep_NumStringForRep(name, standingID, barValue, barMax, barMin)

-- BadRep insert code END

			if ( isHeader ) then

-- BadRep replace code START

				factionHeader:SetText(name .. badRepStr);
				--factionHeader:SetText(name);

-- BadRep replace code END

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

-- BadRep replace code START

				getglobal("ReputationBar"..i.."FactionStanding"):SetText(factionStanding .. ":" .. badRepStr);
				--getglobal("ReputationBar"..i.."FactionStanding"):SetText(factionStanding);

-- BadRep replace code END
				
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
				
				-- Normalize values
				barMax = barMax - barMin;
				barValue = barValue - barMin;
				barMin = 0;
				
				--[[
				-- Don't show standing anymore
				tooltipStanding = "";
				if ( standingID < 8 ) then
					tooltipStanding = " ("..getglobal("FACTION_STANDING_LABEL"..standingID+1)..")";
				end
				]]

-- BadRep replace code START

				--factionBar.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
				factionBar.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;


				factionBar.standingText = factionStanding .. ":" .. badRepStr;
				--factionBar.standingText = factionStanding;

-- BadRep replace code END

				factionBar:SetMinMaxValues(0, barMax);
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
