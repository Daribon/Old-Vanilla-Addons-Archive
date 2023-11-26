-- PetMonitor for Cosmos
-- Written by Arys 01-19-05

PETMONITOR_VERSION = "v1.0";
PETMONITOR_DEBUG = false;
PM_DEBUG = "PETMONITOR_DEBUG";

local PetMonitor_Vars = {};
PetMonitor_Vars.Broadcast = false;
PetMonitor_Vars.Receive = true;
PetMonitor_Vars.ScheduleActive = false;
PetMonitor_Vars.Enabled = true;
PetMonitor_Vars.Attached = true;

PetMonitor_Vars.CombatInterval = 1;
PetMonitor_Vars.RegularInterval = 4;
PetMonitor_Vars.SlowInterval = 10;
PetMonitor_Vars.CurrentInterval = 4;

PetMonitor_Vars.HealthCall = true;
PetMonitor_Vars.Threshold = .3;
PetMonitor_Vars.HP = 0;
PetMonitor_Vars.LastHP = 0;

PetMonitor_Vars.DefaultScale = .6;
PetMonitor_Vars.PetFrameScale = .6;

PetMonitor_SavedVars = {};
PetMonitor_SavedVars.Locs = {};
PetMonitor_SavedVars.Locked = {};

function PetMonitor_ReceiveChat(type, info, message, user, language, channel)
	if (PetMonitor_Vars.Enabled and PetMonitor_Vars.Receive) then
		if (strsub(message, 1, 12) == "<PetMonitor>") then 
			PetMonitor_UpdateHealth(message, user);
		end
	end
end

-- Load Handler
function PetMonitor_OnLoad()
	Sea.io.print("PetMonitor Version "..PETMONITOR_VERSION.." loaded");
	Chronos.schedule(.5, PetMonitor_Initialize); 
end

function PetMonitor_Initialize()
	Sea.io.dprint(PM_DEBUG,"Debugging is ON");
	
	PetMonitor_RegisterCosmosOptions();
	PetMonitor_ResetOwners();
	
	local playerClass = UnitClass("player");	
	if (playerClass == "Hunter" or playerClass == "Warlock") then
		PetMonitor_Vars.Broadcast = true;
	end
	
	PetMonitor_Vars.Receive = true;

	if (PetMonitor_Vars.Broadcast or PetMonitor_Vars.Receive) then
		PetMonitorManagerFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
		PetMonitorManagerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");		
		if (PetMonitor_Vars.Broadcast) then
			Sea.io.dprint(PM_DEBUG,"PetMonitor Broadcasting is ON");
			-- send pet info and health on chat channel to other clients
			PetMonitorManagerFrame:RegisterEvent("PLAYER_PET_CHANGED");
			PetMonitorManagerFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
			PetMonitorManagerFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
			PetMonitor_ScheduleBroadcast();
		end		
		if (PetMonitor_Vars.Receive) then
			Sea.io.dprint(PM_DEBUG,"PetMonitor Receiving is ON");
			Cosmos_RegisterChatWatch("PETMONITORPARTY", {CHANNEL_PARTY}, PetMonitor_ReceiveChat);			
		end
	else
		return;
	end
end

function PetMonitor_BroadcastPetHealth(forced)
	Sea.io.dprint(PM_DEBUG,"Pet Monitor - Broadcasting");
	if ( UnitInParty("party1") ) then
		if (not forced) then
			PetMonitor_Vars.ScheduleActive = false;
		end		
		local petname, pethealth, petmax, focus, focusmax = "", "0", "0", "0", "0";
		if ( UnitName("pet") ) then
			petname = UnitName("pet");
		end
		if ( UnitHealth("pet") ) then
			health = UnitHealth("pet");
		end
		if ( UnitHealthMax("pet") ) then
			healthmax = UnitHealthMax("pet");
		end
		if ( UnitMana("pet") ) then
			focus = UnitMana("pet");
		end
		if ( UnitManaMax("pet") ) then
			focusmax = UnitManaMax("pet");
		end		
		local sendMsg = "<PetMonitor> n<"..petname.."> h<"..health.."> m<"..healthmax.."> f<"..focus.."> x<"..focusmax..">";		
		Cosmos_SendPartyMessage(sendMsg);
				
		if ( UnitHealthMax("pet") > 0 ) then
			if ( PetMonitor_Vars.HealthCall ) then
				local ratio = UnitHealth("pet")/UnitHealthMax("pet");
				local oldratio = PetMonitor_Vars.LastHP/UnitHealthMax("pet");		
				if ( (PetMonitor_Vars.HP < PetMonitor_Vars.LastHP) and 
				(ratio < PetMonitor_Vars.Threshold) and
				(oldratio > PetMonitor_Vars.Threshold) ) then
					PetMonitor_ShoutPetHealth(UnitName("pet"), UnitHealth("pet"), UnitHealthMax("pet"));
				end		
				PetMonitor_Vars.LastHP = PetMonitor_Vars.HP;
				PetMonitor_Vars.HP = UnitHealth("pet");
			end
					
			if ( UnitHealth("pet") == UnitHealthMax("pet") and UnitMana("pet") == UnitManaMax("pet") ) then
				if ( PetMonitor_Vars.CurrentInterval ~= PetMonitor_Vars.SlowInterval ) then
					PetMonitor_StartSlowBroadcast();
				end
			end
			if (not forced) then
				PetMonitor_ScheduleBroadcast();
			end
		else
			PetMonitor_Vars.ScheduleActive = false;
			Sea.io.dprint(PM_DEBUG,"No Pet - Stop Broadcast");
		end
	else
		PetMonitor_Vars.ScheduleActive = false;
		Sea.io.dprint(PM_DEBUG,"Player not in a group - Stop Broadcast");		
	end	
end

function PetMonitor_OnEvent()
	if (PetMonitor_Vars.Enabled) then	
		if (event == "PLAYER_ENTERING_WORLD") then		
			if ( PetMonitor_Vars.Broadcast ) then
				PetMonitor_ScheduleBroadcast(.5);
			end			
		end	
		if (event == "PARTY_MEMBERS_CHANGED") then		
			if ( PetMonitor_Vars.Broadcast ) then
				PetMonitor_ScheduleBroadcast(.5);
			end
			if ( PetMonitor_Vars.Receive ) then
				PetMonitor_CheckPetOwners();
			end
		end		
		if (event == "PLAYER_PET_CHANGED") then
			if ( PetMonitor_Vars.Broadcast ) then
				PetMonitor_ScheduleBroadcast(.5);
			end
		end		
		if (event == "PLAYER_REGEN_DISABLED") then
			if ( PetMonitor_Vars.Broadcast ) then
				PetMonitor_StartCombatBroadcast();
			end
		end		
		if (event == "PLAYER_REGEN_ENABLED") then
			if ( PetMonitor_Vars.Broadcast ) then
				PetMonitor_StartRegularBroadcast();
			end
		end		
	end
	
end

function PetMonitor_ScheduleBroadcast(override)
	if (PetMonitor_Vars.Enabled) then
		if (not PetMonitor_Vars.ScheduleActive) then
			PetMonitor_Vars.ScheduleActive = true;
			if (not override) then
				Chronos.schedule(PetMonitor_Vars.CurrentInterval, PetMonitor_BroadcastPetHealth); 
			else
				Chronos.schedule(override, PetMonitor_BroadcastPetHealth); 
			end
		end 
	end
end

function PetMonitor_StartCombatBroadcast()
	PetMonitor_Vars.CurrentInterval = PetMonitor_Vars.CombatInterval;
end

function PetMonitor_StartRegularBroadcast()
	PetMonitor_Vars.CurrentInterval = PetMonitor_Vars.RegularInterval;
end

function PetMonitor_StartSlowBroadcast()
	PetMonitor_Vars.CurrentInterval = PetMonitor_Vars.SlowInterval;
end

function PetMonitor_UpdateHealth(message, user)
	if (user ~= UnitName("player")) then	
		local pet = gsub(message,".*<PetMonitor+> n<([^>]+)>.*","%1",1);
		local health = gsub(message,".*<PetMonitor+>%s+%w+.*h<([^>]+)>.*","%1",1);
		local max = gsub(message,".*<PetMonitor+>%s+%w+.*m<([^>]+)>.*","%1",1);
		local focus = gsub(message,".*<PetMonitor+>%s+%w+.*f<([^>]+)>.*","%1",1);
		local focusmax = gsub(message,".*<PetMonitor+>%s+%w+.*x<([^>]+)>.*","%1",1);
			
		local index = PetMonitor_GetPartyIndexByName(user);
		
		Sea.io.dprint(PM_DEBUG,index..": ["..user.."] "..pet.." "..health.." / "..max.."  "..focus.." / "..focusmax);
		
		if ( max ~= "0" ) then	
			if ( index > 0 ) then		
				PetMonitor_Vars["Owner"..index] = user;		
				local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);
				if (petMonitorPF) then
				
					if (PetMonitor_Vars.Attached) then
						PetMonitor_AttachPetFrame(index);
					else
						PetMonitor_DetachPetFrame(index);
					end
					
					if (not PetMonitor_Vars.PetFrameScale) then
						PetMonitor_Vars.PetFrameScale = PetMonitor_Vars.DefaultScale;
					end
					getglobal(petMonitorPF:GetName().."PetFrame"):SetScale(PetMonitor_Vars.PetFrameScale);
					petMonitorPF:Show();					
				end
				
				local petMonitorTX = getglobal("PetMonitorPartyFrame"..index.."PetFramePortrait");
				if (petMonitorTX) then
					if (not PetMonitor_Vars["PetTexture"..index]) then
						if ( not UnitExists("target") ) then
							if (not SpellIsTargeting() ) then
								ClearTarget();					
								TargetUnitsPet("party"..index);	
								if ( UnitExists("target") ) then					
									SetPortraitTexture(petMonitorTX, "target");
									PetMonitor_Vars["PetTexture"..index] = true;
								else
									petMonitorTX:SetTexture("Interface\\AddOns\\PetMonitor\\Skin\\NoPortrait");
									PetMonitor_Vars["PetTexture"..index] = false;
								end							
								ClearTarget();							
							end						
						end					
					end				
				end
							
				-- Show the pet name
				local petMonitorPN = getglobal("PetMonitorPartyFrame"..index.."PetFrameName");
				if (petMonitorPN) then
					petMonitorPN:SetText(pet);
					if (PetMonitor_Vars.PetFrameScale < .6) then
						petMonitorPN:Hide();
					end
				end
				
				-- Show the pet health text
				local petMonitorPH = getglobal("PetMonitorPartyFrame"..index.."PetFrameHealthBarText");
				if (petMonitorPH) then
					petMonitorPH:SetText(health.." / "..max);
					petMonitorPH:Hide();		
				end
							
				-- Draw the pet health bar
				local petMonitorHB = getglobal("PetMonitorPartyFrame"..index.."PetFrameHealthBar");
				if (petMonitorHB) then
					max = tonumber(max);
					health = tonumber(health);				
					petMonitorHB:SetMinMaxValues(0, max);
					petMonitorHB:SetValue(health);						
					local perc = 0;
					if ( max > 0 ) then
						perc = health / max;
					end				
					local r, g, b;
					if (perc > 0.5) then
						r = (1.0 - perc) * 2;
						g = 1.0;
					else
						r = 1.0;
						g = perc * 2;
					end
					b = 0.0;		
					petMonitorHB:SetStatusBarColor(r, g, b);
				end
							
				local petMonitorMB = getglobal("PetMonitorPartyFrame"..index.."PetFrameManaBar");
				if (petMonitorMB) then
					focus = tonumber(focus);
					focusmax = tonumber(focusmax);
					
					petMonitorMB:SetMinMaxValues(0, focusmax);
					petMonitorMB:SetValue(focus);
					
					local playerClass = UnitClass("party"..index);
					local r, g, b;	
					if (playerClass == "Hunter") then
							r = 1.00;
							g = 0.50;
							b = 0.25;
					elseif (playerClass == "Warlock") then
							r = 0.00;
							g = 0.00;
							b = 1.00;
					end
					petMonitorMB:SetStatusBarColor(r, g, b);
				end
				
			else
				Sea.io.dprint(PM_DEBUG,"PetMonitor could not find "..user.." in party");
				PetMonitor_Vars["Owner"..index] = "";
				PetMonitor_CheckPetOwners();
			end
		else
			Sea.io.dprint(PM_DEBUG,"PetMonitor cannot find pet for party "..index);
			PetMonitor_HidePetFrame(index);
		end
	end	
end

function PetMonitor_CheckPetOwners() 
	for i=1, MAX_PARTY_MEMBERS, 1 do
		if (PetMonitor_Vars["Owner"..i] ~= UnitName("party"..i)) then
			PetMonitor_Vars["Owner"..i] = "";
			PetMonitor_HidePetFrame(i);
		else
			PetMonitor_ShowPetFrame(i);
		end
	end	
end

function PetMonitor_HidePetFrame(index) 
	local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);
	if (petMonitorPF) then
		petMonitorPF:Hide();	
		PetMonitor_Vars["PetTexture"..index] = false;
	end
end

function PetMonitor_ShowPetFrame(index) 
	local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);
	if (petMonitorPF) then
		petMonitorPF:Show();	
		PetMonitor_Vars["PetTexture"..index] = false;
	end
end

function PetMonitor_GetPartyIndexByName(name)
	for i=1, MAX_PARTY_MEMBERS, 1 do
		if (name == UnitName("party"..i)) then
			return i;
		end
	end
	return 0;
end

function PetMonitor_ResetOwners()
	PetMonitor_Vars.Owner1 = "";
	PetMonitor_Vars.Owner2 = "";
	PetMonitor_Vars.Owner3 = "";
	PetMonitor_Vars.Owner4 = "";
end

function PetMonitor_TargetPartyPet(id)
	if (id) then
		TargetUnitsPet("party"..id);
	end
end

function PetMonitor_ShoutPetHealth(n, h, m)
	if (n and h and m) then
		SendChatMessage("Heal pet "..n.."  "..h.." / "..m, "PARTY");
	else
		SendChatMessage("Heal pet", "PARTY");
	end
end

function PetMonitor_OnThresholdUpdate(toggle, value) 
	if ( toggle == 0 ) then
		PetMonitor_Vars.HealthCall = false;
	else 
		PetMonitor_Vars.HealthCall = true;
		PetMonitor_Vars.Threshold = value;
	end
end

function PetMonitor_SetPetFrameScale(index)
	local petMonitorPF = getglobal("PetMonitorPartyFrame"..index.."PetFrame");
	local petMonitorPN = getglobal("PetMonitorPartyFrame"..index.."PetFrameName");
	if (petMonitorPF) then
		petMonitorPF:SetScale(PetMonitor_Vars.PetFrameScale);		
		if (PetMonitor_Vars.PetFrameScale < .6) then			
			petMonitorPN:Hide();
		else
			petMonitorPN:Show();
		end
	end
end

function PetMonitor_OnScaleUpdate(toggle, value)
	if ( toggle == 0 ) then
		if (PetMonitor_Vars.PetFrameScale == PetMonitor_Vars.DefaultScale) then
			return;			
		else
			PetMonitor_Vars.PetFrameScale = PetMonitor_Vars.DefaultScale;
		end		
	else
		PetMonitor_Vars.PetFrameScale = value;
	end
	Sea.io.dprint(PM_DEBUG,"Set Pet Frame Scale = ",PetMonitor_Vars.PetFrameScale);
	for i=1, MAX_PARTY_MEMBERS, 1 do
		PetMonitor_SetPetFrameScale(i);
	end
end

function PetMonitor_OnReceiveUpdate(toggle) 
	if ( toggle == 0 ) then
		PetMonitor_Vars.Receive = false;
		PetMonitor_ResetOwners();
		PetMonitor_CheckPetOwners();
	else
		if (not PetMonitor_Vars.Receive) then
			PetMonitor_Vars.Receive = true;
			PetMonitor_ResetOwners();
			PetMonitor_CheckPetOwners();
		end
	end
end

function PetMonitor_OnEnableUpdate(toggle) 
	if ( toggle == 0 ) then
		PetMonitor_Vars.Enabled = false;
		PetMonitor_ResetOwners();
		PetMonitor_CheckPetOwners();
	else 
		if (not PetMonitor_Vars.Enabled) then
			PetMonitor_Vars.Enabled = true;
			PetMonitor_ResetOwners();
			PetMonitor_CheckPetOwners();
			if (PetMonitor_Vars.Broadcast) then
				PetMonitor_ScheduleBroadcast();
			end
		end
	end
end

function PetMonitor_OnAttachUpdate(toggle) 
	if ( toggle == 0 ) then
		PetMonitor_Vars.Attached = false;
		for i=1, MAX_PARTY_MEMBERS, 1 do
			PetMonitor_DetachPetFrame(i);
		end
		RegisterForSave("PetMonitor_SavedVars");
	else 
		PetMonitor_Vars.Attached = true;
		for i=1, MAX_PARTY_MEMBERS, 1 do
			PetMonitor_AttachPetFrame(i);
		end
		RegisterForSave("PetMonitor_SavedVars");
	end
end

function PetMonitor_AttachPetFrame(index)
	local partyPF = getglobal("PartyMemberFrame"..index);
	local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);	
	if (index > 0) then
		if (petMonitorPF:GetLeft() and partyPF:GetLeft()) then
			local xDif = petMonitorPF:GetLeft() - partyPF:GetLeft();
			if (not xDif) then
				petMonitorPF:SetPoint("TOPLEFT", "PartyMemberFrame"..index, "TOPRIGHT");
			else				
				local yDif = petMonitorPF:GetTop() - partyPF:GetTop();
				--Sea.io.dprint(PM_DEBUG, "xDif,yDif = "..round(xDif)..", "..round(yDif));
				petMonitorPF:SetPoint("TOPLEFT", "PartyMemberFrame"..index, "TOPLEFT", xDif, yDif);				
			end
			PetMonitor_SavePetFramePos(index);
		else
			Sea.io.dprint(PM_DEBUG, "PetFrame Has not been set before");
			petMonitorPF:SetPoint("TOPLEFT", "PartyMemberFrame"..index, "TOPRIGHT");
			PetMonitor_SavePetFramePos(index);
		end
	end
end

function PetMonitor_DetachPetFrame(index)	
	local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);
	if (index > 0) then
		if (petMonitorPF:GetLeft()) then		
			if (PetMonitor_SavedVars.Locs["Frame"..index.."x"]) then
				Sea.io.dprint(PM_DEBUG," X,Y saved as = "..round(PetMonitor_SavedVars.Locs["Frame"..index.."x"])..", "..round(PetMonitor_SavedVars.Locs["Frame"..index.."y"]));
				petMonitorPF:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", PetMonitor_SavedVars.Locs["Frame"..index.."x"], PetMonitor_SavedVars.Locs["Frame"..index.."y"]);
			else
				Sea.io.dprint(PM_DEBUG, "X,Y not set");
				petMonitorPF:SetPoint("TOPLEFT", "PartyMemberFrame"..index, "TOPRIGHT");
				petMonitorPF:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", petMonitorPF:GetLeft(), petMonitorPF:GetTop());
				PetMonitor_SavePetFramePos(index);
			end	
		else
			Sea.io.dprint(PM_DEBUG, "PetFrame Has not been positioned before");
			petMonitorPF:SetPoint("TOPLEFT", "PartyMemberFrame"..index, "TOPRIGHT");
			petMonitorPF:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", petMonitorPF:GetLeft(), petMonitorPF:GetTop());
			PetMonitor_SavePetFramePos(index);
		end
	end
end

function PetMonitor_LockPetFrame(index)
	if (PetMonitor_SavedVars.Locked["Frame"..index]) then
		PetMonitor_SavedVars.Locked["Frame"..index] = false;
	else
		PetMonitor_SavedVars.Locked["Frame"..index] = true;
	end
end

function PetMonitor_LockPetFrames()
	PetMonitor_SavedVars.Locked = {};
	for i=1, MAX_PARTY_MEMBERS, 1 do
		PetMonitor_ResetPetFrame(index);
	end
	RegisterForSave("PetMonitor_SavedVars");
end

function PetMonitor_ResetPositions()
	PetMonitor_Vars.PetFrameScale = PetMonitor_Vars.DefaultScale;
	PetMonitor_SavedVars.Locs = {};
	for i=1, MAX_PARTY_MEMBERS, 1 do
		PetMonitor_SetPetFrameScale(i);
		PetMonitor_ResetPetFrame(i);
	end
	RegisterForSave("PetMonitor_SavedVars");
end

function PetMonitor_ResetPetFrame(index)
	if (index > 0) then
		local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);
		petMonitorPF:SetPoint("TOPLEFT", "PartyMemberFrame"..index, "TOPRIGHT");
		PetMonitor_SavePetFramePos(index);
	end
end

function PetMonitor_SavePetFramePos(index)
	local petMonitorPF = getglobal("PetMonitorPartyFrame"..index);
	if (petMonitorPF) then
		PetMonitor_SavedVars.Locs["Frame"..index.."x"] = petMonitorPF:GetLeft();
		PetMonitor_SavedVars.Locs["Frame"..index.."y"] = petMonitorPF:GetTop();
	end
end

function PetMonitor_StartDrag()
	local index = this:GetID();
	if (not PetMonitor_SavedVars.Locked["Frame"..index]) then
		this:GetParent():StartMoving();
		this.isMoving = true;
	end
end

function PetMonitor_StopDrag()
	local index = this:GetID();
	if (not PetMonitor_SavedVars.Locked["Frame"..index]) then
		this:GetParent():StopMovingOrSizing();
		this.isMoving = false;
		if (PetMonitor_Vars.Attached) then
			PetMonitor_AttachPetFrame(index);
		end
		PetMonitor_SavePetFramePos(index);
		RegisterForSave("PetMonitor_SavedVars");
	end
end

function PetMonitor_OpenPetMenu()
	local index = this:GetID();			
	local lockText = "Lock";
	if (PetMonitor_SavedVars.Locked["Frame"..index]) then
		lockText = "Unlock";
	end
	local info = {};	
	info[1] = { text = "Pet Health", isTitle = 1 };
	info[2] = { text = lockText, func = function() PetMonitor_LockPetFrame(index); RegisterForSave("PetMonitor_SavedVars"); end };
	info[3] = { text = "Reset", func = function() PetMonitor_ResetPetFrame(index); RegisterForSave("PetMonitor_SavedVars"); end };
	info[4] = { text = "|cFFCCCCCC------------|r", disabled = 1, notClickable = 1 };
	info[5] = { text = "Cancel", func = function () end };	
	CosmosMaster_MenuOpen(info, 0, this:GetName(), 0, 0);
end

function PetMonitor_OnClick(button) 
	if (this.isMoving) then
		this:GetParent():StopMovingOrSizing();
		this.isMoving = false;
	else
		if ( button == "RightButton" ) then
			PetMonitor_OpenPetMenu();						
		else
			PetMonitor_TargetPartyPet(this:GetID());
		end
	end
end

function PetMonitor_MouseUp()
	if (this.isMoving) then
		this:GetParent():StopMovingOrSizing();
		this.isMoving = false;
	end
end

function PetMonitor_HealthBarRollover(bool)
	local index = this:GetParent():GetID();
	local petMonitorPH = getglobal("PetMonitorPartyFrame"..index.."PetFrameHealthBarText");
	if (bool) then
		petMonitorPH:Show();
	else
		petMonitorPH:Hide();
	end
end

function PetMonitor_RegisterCosmosOptions()
	if( Cosmos_RegisterConfiguration ~= nil ) then
		Cosmos_RegisterConfiguration("COS_PETMONITOR",
			"SECTION",
			PETMONITOR_SEP,
			PETMONITOR_SEP_INFO
		);
		Cosmos_RegisterConfiguration("COS_PETMONITOR_SECTION",
			"SEPARATOR",
			PETMONITOR_SEP,
			PETMONITOR_SEP_INFO
		);
		Cosmos_RegisterConfiguration("COS_PETMONITOR_ENABLE",
			"CHECKBOX",
			PETMONITOR_ENABLED, 
			PETMONITOR_ENABLED_INFO,
			PetMonitor_OnEnableUpdate,
			1,
			1
		);
		local playerClass = UnitClass("player");	
		if (playerClass == "Hunter" or playerClass == "Warlock") then
			Cosmos_RegisterConfiguration("COS_PETMONITOR_RECEIVER",
				"CHECKBOX",
				PETMONITOR_RECEIVER, 
				PETMONITOR_RECEIVER_INFO,
				PetMonitor_OnReceiveUpdate,
				1,
				1
			);
		end
		Cosmos_RegisterConfiguration("COS_PETMONITOR_ATTACHED",
			"CHECKBOX",
			PETMONITOR_ATTACHED,
			PETMONITOR_ATTACHED_INFO,
			PetMonitor_OnAttachUpdate,
			1,
			1
		);
		Cosmos_RegisterConfiguration("COS_PETMONITOR_HEALTHLIMIT",
			"BOTH",					
			PETMONITOR_HEALTH,			 
			PETMONITOR_HEALTH_INFO,													  
			PetMonitor_OnThresholdUpdate,
			1,		
			.2,										
			0,
			1,
			PETMONITOR_HEALTH_LIMIT,		
			.01,
			1,
			"\%",
			100
 		);
		Cosmos_RegisterConfiguration("COS_PETMONITOR_SCALE",
			"BOTH",
			PETMONITOR_SCALE,
			PETMONITOR_SCALE_INFO,
			PetMonitor_OnScaleUpdate,
			0,
			.6,
			.4,
			1,
			PETMONITOR_SCALE_TITLE,
			.1,
			1,
			"\%",
			100
		);		
		Cosmos_RegisterConfiguration("COS_PETMONITOR_RESET_POSITIONS",
			"BUTTON",
			PETMONITOR_RESET_POSITIONS,
			PETMONITOR_RESET_POSITIONS_INFO,
			PetMonitor_ResetPositions,
			0,
			0,
			0,
			0,
			PETMONITOR_RESET_POSITIONS_NAME
		);
	end
end