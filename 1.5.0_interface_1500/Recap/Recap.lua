--[[
		Recap 2.64 - Gello, Hyjal

		An AddOn for WoW to track and summarize all damage done around the user.

]]


Recap_Version = 2.64;

--[[ Saved Variables ]]

recap = {}; -- options and current data for all characters/servers
recap_set = {}; -- fight data sets, independent of character/server

--[[ Callback functions ]]

function Recap_OnLoad()

	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME_UPDATE");
end

function Recap_OnEvent()

	if event=="VARIABLES_LOADED" then

		SlashCmdList["RecapCOMMAND"] = Recap_SlashHandler;
		SLASH_RecapCOMMAND1 = "/Recap";

	elseif event=="PLAYER_ENTERING_WORLD" or event=="UNIT_NAME_UPDATE" then
		Recap_Initialize();

	elseif event=="PLAYER_REGEN_DISABLED" then
		if recap.Opt.LimitFights.value then
			Recap_StartFight();
		end

	elseif event=="PLAYER_REGEN_ENABLED" then
		Recap_EndFight();

	elseif event=="PARTY_MEMBERS_CHANGED" or event=="RAID_ROSTER_UPDATE" then
		Recap_MakeFriends();

	elseif event=="CHAT_MSG_COMBAT_FRIENDLY_DEATH" or event=="CHAT_MSG_COMBAT_HOSTILE_DEATH" then
		Recap_DeathEvent(arg1);

	elseif event=="UPDATE_MOUSEOVER_UNIT" then
		Recap_GetUnitInfo("mouseover");
	elseif event=="PLAYER_TARGET_CHANGED" then
		Recap_GetUnitInfo("target");

	elseif string.find(event,"BUFF") then
		Recap_HealEvent(arg1);

	else
		Recap_DamageEvent(arg1);
	end
end

function Recap_Idle_OnUpdate(arg1)

	-- timer to end idle fights if option checked
	if recap_temp.IdleTimer~=-1 and recap_temp.Loaded and recap.Opt.IdleFight.value then
		recap_temp.IdleTimer = recap_temp.IdleTimer + arg1;
		if recap_temp.IdleTimer > recap.Opt.IdleFightTimer.value then
			recap_temp.IdleTimer = -1;
			Recap_EndFight();
		end
	end

	-- if fighting and a plugin loaded or we're minimized, update min dps every half second
	if recap_temp.Loaded and recap_temp.UpdateTimer~=-1 and recap.Opt.State.value=="Active" and
	  ((IB_Recap_Update or TitanPanelRecap_Update) or recap.Opt.Minimized.value) then
		recap_temp.UpdateTimer = recap_temp.UpdateTimer + arg1;
		if recap_temp.UpdateTimer>.5 then
			recap_temp.UpdateTimer = 0;
			Recap_UpdateMinimizedDPS()
		end
	end
end

function Recap_OnUpdate(arg1)

	-- update fade timer if option checked
	if recap_temp.Loaded and recap.Opt.AutoFade.value and not recap.Opt.Minimized.value and MouseIsOver(RecapFrame) and recap_temp.FadeTimer<recap.Opt.AutoFadeTimer.value then
		recap_temp.FadeTimer = 0;
	elseif recap_temp.Loaded and recap_temp.FadeTimer~=-1 and recap.Opt.AutoFade.value and not recap.Opt.Minimized.value then
		recap_temp.FadeTimer = recap_temp.FadeTimer + arg1;
		if recap_temp.FadeTimer > recap.Opt.AutoFadeTimer.value then
			RecapFrame:SetAlpha( max(1-min(2*(recap_temp.FadeTimer-recap.Opt.AutoFadeTimer.value),1),.1));
			if recap_temp.FadeTimer > (recap.Opt.AutoFadeTimer.value+.5) then
				RecapFrame_Hide();
			end
		end
	end
end

function Recap_SlashHandler(arg1)

	Recap_Initialize();

	if arg1 and arg1=="reset" then
		RecapFrame:ClearAllPoints();
		RecapFrame:SetPoint("CENTER","UIParent","CENTER");
		RecapOptFrame:ClearAllPoints();
		RecapOptFrame:SetPoint("CENTER","UIParent","CENTER");
		Recap_SetView();
	elseif arg1=="debug" then
		if recap.debug then
			DEFAULT_CHAT_FRAME:AddMessage("recap.debug is ON. To turn it off: /recap debug off");
			for i=1,100 do
				if recap.debug_Filter[i] then
					DEFAULT_CHAT_FRAME:AddMessage("["..i.."] \""..recap.debug_Filter[i].pattern.."\" hits: "..recap.debug_Filter[i].hits..", total: "..recap.debug_Filter[i].total);
				end
			end
			DEFAULT_CHAT_FRAME:AddMessage("__ Damage/heals from self/pet __");
			Recap_ListEffects();
		else
			DEFAULT_CHAT_FRAME:AddMessage("recap.debug is OFF. To turn it on: /recap debug on");
		end
	elseif arg1=="debug on" then
		recap.debug = true;
		DEFAULT_CHAT_FRAME:AddMessage("recap.debug is now ON.");
	elseif arg1=="debug off" then
		recap.debug = false;
		DEFAULT_CHAT_FRAME:AddMessage("recap.debug is now OFF.");
	elseif arg1=="debug reset" then
		recap.debug_Filter = {};
		DEFAULT_CHAT_FRAME:AddMessage("recap.debug_Filter is RESET.");
	elseif string.find(arg1,"opt") then
		if RecapOptFrame:IsShown() then
			RecapOptFrame_Hide();
		else
			RecapOptFrame:Show();
		end
	elseif RecapFrame:IsShown() then
		RecapFrame_Hide();
		RecapOptFrame_Hide();
	else
		RecapFrame_Show();
		Recap_CheckWindowBounds();
		if recap.Opt.State.value == "Stopped" then
			Recap_SetState("Idle");
			recap.Opt.Paused.value = false;
			Recap_SetButtons();
		end
	end
end

--[[ Window appearance functions ]]

function Recap_SetState(arg1)
	if arg1 then
		recap.Opt.State.value = arg1;
	end
	if recap.Opt.State.value=="Stopped" then
		RecapStatusTexture:SetVertexColor(1,0,0);
	elseif recap.Opt.State.value=="Active" then
		RecapStatusTexture:SetVertexColor(0,1,0);
	else
		RecapStatusTexture:SetVertexColor(.5,.5,.5);
	end
	Recap_UpdatePlugins();
end		

function RecapFrame_Hide()

	if not recap_temp.Loaded then
		Recap_Initialize();
	end
	recap_temp.FadeTimer = -1;
	RecapFrame:SetAlpha(1);
	RecapFrame:Hide();
	recap.Opt.Visible.value = false;
end

function RecapFrame_Show()

	if not recap_temp.Loaded then
		Recap_Initialize();
	end
	RecapFrame:Show();
	recap.Opt.Visible.value = true;
end

function RecapOptFrame_Hide()
	RecapSetEditBox:SetText("");
	RecapSetEditBox:ClearFocus();
	RecapOptFrame:Hide();
end

function RecapFrame_Toggle()
    if RecapFrame:IsShown() then
        RecapFrame_Hide();
        RecapOptFrame_Hide();
    else
        RecapFrame_Show();
    end
end

function Recap_Shutdown()

	recap.Opt.Paused.value = true;
	Recap_EndFight();
	Recap_SetState("Stopped");
	Recap_SetButtons();
	RecapOptFrame_Hide();
	RecapFrame_Hide();
end
 
function Recap_ToggleView()

	if recap.Opt.View.value=="All" then
		Recap_SetView("Last");
	else
		Recap_SetView("All");
	end
end

-- changes button textures depending on their state
function Recap_SetButtons()

	if recap.Opt.Minimized.value then
		RecapMinimizeButton:SetNormalTexture("Interface\\AddOns\\Recap\\MinimizeButton-Down");
		RecapMinimizeButton:SetPushedTexture("Interface\\AddOns\\Recap\\MinimizeButton-Up");
	else
		RecapMinimizeButton:SetNormalTexture("Interface\\AddOns\\Recap\\MinimizeButton-Up");
		RecapMinimizeButton:SetPushedTexture("Interface\\AddOns\\Recap\\MinimizeButton-Down");
	end

	if recap.Opt.Pinned.value then
		RecapPinButton:SetNormalTexture("Interface\\AddOns\\Recap\\StickyButton-Down");
		RecapPinButton:SetPushedTexture("Interface\\AddOns\\Recap\\StickyButton-Up");
	else
		RecapPinButton:SetNormalTexture("Interface\\AddOns\\Recap\\StickyButton-Up");
		RecapPinButton:SetPushedTexture("Interface\\AddOns\\Recap\\StickyButton-Down");
	end

	if recap.Opt.Paused.value then
		RecapPauseButton:SetNormalTexture("Interface\\AddOns\\Recap\\Pause-Down");
		RecapPauseButton:SetPushedTexture("Interface\\AddOns\\Recap\\Pause-Up");
	else
		RecapPauseButton:SetNormalTexture("Interface\\AddOns\\Recap\\Pause-Up");
		RecapPauseButton:SetPushedTexture("Interface\\AddOns\\Recap\\Pause-Down");
	end

	if recap.Opt.View.value=="Last" then
		RecapShowAllButton:SetNormalTexture("Interface\\AddOns\\Recap\\ShowAllButton-Up");
		RecapShowAllButton:SetPushedTexture("Interface\\AddOns\\Recap\\ShowAllButton-Down");
	else
		RecapShowAllButton:SetNormalTexture("Interface\\AddOns\\Recap\\ShowAllButton-Down");
		RecapShowAllButton:SetPushedTexture("Interface\\AddOns\\Recap\\ShowAllButton-Up");
	end

	if recap.Opt.SelfView.value then
		RecapSelfViewButton:SetNormalTexture("Interface\\AddOns\\Recap\\SelfView-Down");
		RecapSelfViewButton:SetPushedTexture("Interface\\AddOns\\Recap\\SelfView-Up");
	else
		RecapSelfViewButton:SetNormalTexture("Interface\\AddOns\\Recap\\SelfView-Up");
		RecapSelfViewButton:SetPushedTexture("Interface\\AddOns\\Recap\\SelfView-Down");
	end
end

-- this resizes the window width to the columns defined in options
function Recap_SetColumns()

	local cx = 168; -- 8(edge)+120(name)+32(scroll)+8(edge)

	local i,j,icx,item;

  if recap.Opt.SelfView.value then

	cx = cx+8; -- details name is +10 width

	for i in recap.Opt do
		if recap.Opt[i].selfwidth then
			if recap.Opt[i].value then
				item = getglobal("RecapEffectsHeader_"..i);
				item:SetWidth(recap.Opt[i].selfwidth);
				item:Show();
				for j=1,15 do
					item = getglobal("RecapEffects"..j.."_"..i);
					item:SetWidth(recap.Opt[i].selfwidth);
					item:Show();
				end
				cx = cx + recap.Opt[i].selfwidth;
			else
				item = getglobal("RecapEffectsHeader_"..i);
				item:SetWidth(1);
				item:Hide();
				for j=1,15 do
					item = getglobal("RecapEffects"..j.."_"..i);
					item:SetWidth(1);
					item:Hide();
				end
				cx = cx + 1;
			end
		elseif recap.Opt[i].width then
			getglobal("RecapHeader_"..i):Hide();
		end
	end

	for i=1,15 do
		getglobal("RecapEffects"..i):Show();
		getglobal("RecapList"..i):Hide();
		getglobal("RecapEffects"..i):SetWidth(cx-48);
	end

	RecapHeader_Name:Hide();
	RecapTotals_DPSIn:Hide();
	RecapTotals:Hide();

  else

	RecapHeader_Name:Show();
	RecapTotals:Show();

	for i in recap.Opt do
		if recap.Opt[i].width then
			if recap.Opt[i].value then
				item = getglobal("RecapHeader_"..i);
				item:SetWidth(recap_temp.DefaultOpt[i].width);
				item:Show();
				item = getglobal("RecapTotals_"..i);
				item:SetWidth(recap_temp.DefaultOpt[i].width);
				item:Show();
				for j=1,15 do
					item = getglobal("RecapList"..j.."_"..i);
					item:SetWidth(recap_temp.DefaultOpt[i].width);
					item:Show();
				end
				cx = cx + recap_temp.DefaultOpt[i].width;
			else
				item = getglobal("RecapHeader_"..i);
				item:SetWidth(1);
				item:Hide();
				item = getglobal("RecapTotals_"..i);
				item:SetWidth(1);
				item:Hide();
				for j=1,15 do
					item = getglobal("RecapList"..j.."_"..i);
					item:SetWidth(1);
					item:Hide();
				end
				cx = cx + 1;
			end
		end
	end

	for i=1,15 do
		getglobal("RecapEffects"..i):Hide();
		getglobal("RecapList"..i):Show();
		getglobal("RecapList"..i):SetWidth(cx-48);
	end

	if recap.Opt.DPSIn.value then
		RecapTotals_DPSIn:Show();
	else
		RecapTotals_DPSIn:Hide();
	end

  end

	RecapTotals:SetWidth(cx-48);

	if recap.Opt.GrowLeftwards.value and RecapFrame then
		i = RecapFrame:GetRight();
		j = RecapFrame:GetTop();
		if i and j then
			RecapFrame:ClearAllPoints();
			RecapFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",i-cx,j); -- *** i not defined sometimes :( **
		end
	end

	RecapTopBar:SetWidth(cx-8);
	RecapBottomBar:SetWidth(cx-16);
	RecapFrame:SetWidth(cx);

	Recap_CheckWindowBounds();
	Recap_SetView();
	RecapScrollBar_Update();

end

-- changes view mode
function Recap_SetView(arg1)

	local text;


		if arg1 then
			recap.Opt.View.value = arg1;
		end

		Recap_SetButtons();
		Recap_ConstructList();

		cx = RecapFrame:GetWidth();

		-- change titlebar
		if cx and cx<230 or recap.Opt.Minimized.value then
			text = "";
			if cx>180 then
				text = recap.Opt.View.value;
			end		
		elseif cx and cx<260 then
			text = recap_temp.Local.LastAll[recap.Opt.View.value];
		else
			text = "Recap of "..recap_temp.Local.LastAll[recap.Opt.View.value];
		end
		if cx and cx>390 and recap_temp.ListSize>1 then
			text = text.." ("..(recap_temp.ListSize-1).." Combatants)";
		end

		if cx and recap.Opt.SelfView.value and not recap.Opt.Minimized.value then
			if cx<200 then
				text = "";
			elseif cx<350 then
				text = "Details";
			elseif cx<405 then
				text = "Damage and Healing Details";
			else
				text = "Recap of Damage and Healing Details";
			end
		end

		RecapTitle:SetText(text);
		RecapHeader_Name:SetText(recap.Opt.View.value.." Combatants");
		Recap_ChangeBack();
end

function Recap_SetColors()

	if recap.Opt.UseColor.value then
		recap_temp.ColorDmgIn = recap_temp.ColorRed;
		recap_temp.ColorDmgOut = recap_temp.ColorGreen;
		recap_temp.ColorHeal = recap_temp.ColorBlue;
	else
		recap_temp.ColorDmgIn = recap_temp.ColorWhite;
		recap_temp.ColorDmgOut = recap_temp.ColorNone;
		recap_temp.ColorHeal = recap_temp.ColorWhite;
	end

	RecapTotals_DmgIn:SetTextColor(recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
	RecapTotals_DmgOut:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
	RecapTotals_DPS:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
	RecapTotals_DPSIn:SetTextColor(recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
	RecapTotals_Heal:SetTextColor(recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b);
	RecapMinDPSIn_Text:SetTextColor(recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
	RecapMinDPSOut_Text:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
	for i=1,15 do
		getglobal("RecapList"..i.."_HealP"):SetTextColor(recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b);
		getglobal("RecapList"..i.."_DmgInP"):SetTextColor(recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
		getglobal("RecapList"..i.."_DmgOutP"):SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
	end
	Recap_ChangeBack();
end

function Recap_ChangeBack()

	if recap.Opt.UseColor.value and (recap.Opt.MinBack.value or not recap.Opt.Minimized.value) then

		if recap.Opt.SelfView.value and not recap.Opt.Minimized.value then
			RecapTitleBack:SetVertexColor(0,0,.8);
		elseif recap.Opt.View.value=="Last" then
			RecapTitleBack:SetVertexColor(0,.66,0);
		else
			RecapTitleBack:SetVertexColor(.66,0,0);
		end
		RecapTitleBack:Show();
	else
		RecapTitleBack:Hide();
	end
end


--[[ Initialization ]]

-- Can be called often, will immediately dump out if it ran through successfully
function Recap_Initialize()

	local i;
	local init_time;

	if not recap_temp.Loaded then

		if UnitName("player") and UnitName("player")~=UNKNOWNOBJECT and RecapFrame and RecapOptFrame then

			init_time = GetTime();

			recap_temp.Player = UnitName("player");
			recap_temp.Server = GetCVar("realmName");

			-- recap index for this player
			recap_temp.p = recap_temp.Player..recap_temp.Server;

			-- sources of damage/heals otherwise not declared in chat spam
			recap_temp.FilterIndex[5] = recap_temp.Player;
			recap_temp.FilterIndex[6] = "Melee";
			recap_temp.FilterIndex[7] = "Damage Shields";

			Recap_InitializeData();

			if not recap[recap_temp.p].WindowTop and RecapFrame then
				RecapFrame:ClearAllPoints();
				RecapFrame:SetPoint("CENTER","UIParent","CENTER");
				RecapOptFrame:ClearAllPoints();
				RecapOptFrame:SetPoint("CENTER", "UIParent", "CENTER");
			elseif recap[recap_temp.p].WindowTop and RecapFrame then
				RecapFrame:ClearAllPoints();
				RecapFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",recap[recap_temp.p].WindowLeft,recap[recap_temp.p].WindowTop);
				RecapFrame:SetWidth(recap[recap_temp.p].WindowWidth);
				RecapFrame:SetHeight(recap[recap_temp.p].WindowHeight);
			end

			for i in recap.Combatant do
				recap.Combatant[i].WasInLast = false;
				recap.Combatant[i].WasInCurrent = false;
			end
			recap[recap_temp.p].LastDuration = 0;

			Recap_SetColors();

			-- if we loaded out of stopped state, force into idle state
			if recap.Opt.State.value ~= "Stopped" then
				recap.Opt.State.value = "Idle";
			end
			Recap_SetState();

			RecapTotals_Name:SetWidth(82);

			Recap_InitDataSets();

			if recap.Opt.Minimized.value then
				Recap_SetButtons();
				Recap_ConstructList();
				Recap_Minimize();
			else
				Recap_Maximize();
			end


			-- we're in the world (in theory), register active events
			this:RegisterEvent("PLAYER_REGEN_DISABLED");
			this:RegisterEvent("PLAYER_REGEN_ENABLED");
			this:RegisterEvent("PARTY_MEMBERS_CHANGED");
			this:RegisterEvent("RAID_ROSTER_UPDATE");

			-- register damage events
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_PARTY_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_PARTY_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_PET_MISSES");
			this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
			this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
			this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS");
			this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");
			this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
			this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");

			-- register death events
			this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
			this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");

			-- register healing events
			this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS");
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
			this:RegisterEvent("CHAT_MSG_SPELL_PET_BUFF");
			this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");

			this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
			this:RegisterEvent("PLAYER_TARGET_CHANGED");

			recap_temp.Loaded = true;


			Recap_InitializeOptions();

			if recap.Opt.Visible.value then
				RecapFrame_Show();
			else
				RecapFrame_Hide();
			end

			if recap.Opt.Paused.value then
				RecapFrame_Hide();
			end

			if recap.debug then
				DEFAULT_CHAT_FRAME:AddMessage("[recap.debug] Time to initialize: "..string.format("%.4f",GetTime()-init_time).." seconds.");
			end

		end

	end
end

-- arg1==1 to hide buttons, 16 to show
function Recap_ShowButtons(arg1)

	RecapCloseButton:SetWidth(arg1);
	RecapPinButton:SetWidth(arg1);
	RecapPauseButton:SetWidth(arg1);
	RecapOptionsButton:SetWidth(arg1);
	RecapShowAllButton:SetWidth(arg1);

	if arg1==16 then
		RecapCloseButton:Show();
		RecapPinButton:Show();
		RecapPauseButton:Show();
		RecapOptionsButton:Show();
		RecapShowAllButton:Show();
	else
		RecapCloseButton:Hide();
		RecapPinButton:Hide();
		RecapPauseButton:Hide();
		RecapOptionsButton:Hide();
		RecapShowAllButton:Hide();
	end
end
		
function Recap_Minimize()

	local i,j;
	local cx = 20; -- 8(edge)+4(space right of status)+8

	recap.Opt.Minimized.value = true;

	for i in recap.Opt do
		if recap.Opt[i].minwidth then
			if recap.Opt[i].value then
				item = getglobal("Recap"..i);
				item:SetWidth(recap.Opt[i].minwidth);
				item:Show();
				cx = cx + recap.Opt[i].minwidth;
			else
				item = getglobal("Recap"..i);
				item:SetWidth(1);
				item:Hide();
				cx = cx + 1;
			end
		end
	end

	if recap.Opt.MinButtons.value then
		cx = cx + 108;
		Recap_ShowButtons(16);
	else
		Recap_ShowButtons(1);
		cx = cx + 23; -- 5 + 18
	end

	RecapTitle:SetText(recap.Opt.View.value);

	RecapTopBar:Hide();
	RecapBottomBar:Hide();
	RecapTotals_DPSIn:Hide();
	RecapResetButton:Hide();
	RecapSelfViewButton:Hide();
	for i=1,15 do
		getglobal("RecapList"..i):Hide();
		getglobal("RecapEffects"..i):Hide();
	end
	RecapTotals:Hide();
	for i in recap.Opt do
		if recap.Opt[i].width then
			getglobal("RecapHeader_"..i):Hide();
		elseif recap.Opt[i].selfwidth then
			getglobal("RecapEffectsHeader_"..i):Hide();
		end
	end
	RecapEffectsHeader_EffectName:Hide();
	RecapHeader_Name:Hide();
	RecapScrollBar:Hide();

	if recap.Opt.GrowLeftwards.value and RecapFrame then
		i = RecapFrame:GetRight();
		j = RecapFrame:GetTop();
		if i and j then
			RecapFrame:ClearAllPoints();
			RecapFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",i-cx,j);
		end
	end
	RecapFrame:SetWidth(cx);
	Recap_SetHeight(28);

	if recap.Opt.MinBack.value then
		RecapFrame:SetBackdropColor(1,1,1,1);
		RecapFrame:SetBackdropBorderColor(1,1,1,1);
	else
		RecapFrame:SetBackdropColor(0,0,0,0);
		RecapFrame:SetBackdropBorderColor(0,0,0,0);
	end

	Recap_ChangeBack();
end

function Recap_Maximize()

	recap.Opt.Minimized.value = false;

	for i in recap.Opt do
		if recap.Opt[i].minwidth then
			item = getglobal("Recap"..i);
			item:SetWidth(recap.Opt[i].minwidth);
			item:Hide();
		end
	end
	RecapMinStatus:Show();
	RecapMinView:Show();
	Recap_ShowButtons(16);

	RecapTopBar:Show();
	RecapBottomBar:Show();
	RecapResetButton:Show();
	RecapSelfViewButton:Show();

	if recap.Opt.SelfView.value then
		for i=1,15 do
			getglobal("RecapEffects"..i):Show();
		end
		RecapEffectsHeader_EffectName:Show();
		RecapEffectsHeader_SelfTotal:Show();
		RecapEffectsHeader_SelfRate:Show();
		RecapEffectsHeader_SelfHits:Show();
		RecapEffectsHeader_SelfMaxHit:Show();
		RecapEffectsHeader_SelfCrits:Show();
		RecapEffectsHeader_SelfMaxCrit:Show();
		RecapEffectsHeader_SelfCritRate:Show();
		RecapHeader_Name:Hide();
	else
		for i=1,15 do
			getglobal("RecapList"..i):Show();
		end
		RecapTotals:Show();
		RecapEffectsHeader_EffectName:Hide();
		RecapEffectsHeader_SelfTotal:Hide();
		RecapEffectsHeader_SelfRate:Hide();
		RecapEffectsHeader_SelfHits:Hide();
		RecapEffectsHeader_SelfMaxHit:Hide();
		RecapEffectsHeader_SelfCrits:Hide();
		RecapEffectsHeader_SelfMaxCrit:Hide();
		RecapEffectsHeader_SelfCritRate:Hide();
		RecapHeader_Name:Show();
	end

	RecapScrollBar:Show();
	Recap_SetColumns();

	RecapFrame:SetBackdropColor(1,1,1,1);
	RecapFrame:SetBackdropBorderColor(1,1,1,1);
end

function Recap_SetHeight(newcy)

	local i,j;

	if recap.Opt.GrowUpwards.value and RecapFrame then
		i = RecapFrame:GetBottom();
		j = RecapFrame:GetLeft();
		if i and j then
			RecapFrame:ClearAllPoints();
			RecapFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",j,i+newcy);
		end
	end

	RecapFrame:SetHeight(newcy);
	Recap_CheckWindowBounds();
end

function RecapScrollBar_Update()

	local i, index, item;

	if not recap.Opt.Minimized.value then

		if recap.Opt.SelfView.value then

			i = 72 + ( math.max( math.min(recap_temp.SelfListSize-1,recap.Opt.MaxRows.value),1 )*14 );
			Recap_SetHeight(i);
			RecapScrollBar:SetHeight(i-63);
			RecapScrollBarTop:SetHeight(i-63);
			FauxScrollFrame_Update(RecapScrollBar,recap_temp.SelfListSize-1,recap.Opt.MaxRows.value,10);

			for i=1,recap.Opt.MaxRows.value do
				index = i + FauxScrollFrame_GetOffset(RecapScrollBar);
				if index<recap_temp.SelfListSize then
					item = getglobal("RecapEffects"..i.."_EffectName");
					item:SetText(string.sub(recap_temp.SelfList[index].Effect,2));
					if recap_temp.SelfList[index].Type<3 then
						item:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
					else
						item:SetTextColor(recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b);
					end
					getglobal("RecapEffects"..i.."_SelfTotal"):SetText(recap_temp.SelfList[index].Total);
					getglobal("RecapEffects"..i.."_SelfRate"):SetText(recap_temp.SelfList[index].Rate);
					getglobal("RecapEffects"..i.."_SelfHits"):SetText(recap_temp.SelfList[index].Hits);
					getglobal("RecapEffects"..i.."_SelfMaxHit"):SetText(recap_temp.SelfList[index].MaxHit);
					getglobal("RecapEffects"..i.."_SelfCrits"):SetText(recap_temp.SelfList[index].Crits);
					getglobal("RecapEffects"..i.."_SelfMaxCrit"):SetText(recap_temp.SelfList[index].MaxCrit);
					getglobal("RecapEffects"..i.."_SelfCritRate"):SetText(recap_temp.SelfList[index].CritRate);
					getglobal("RecapEffects"..i):Show();
				else
					getglobal("RecapEffects"..i):Hide();
				end
			end
			for i=recap.Opt.MaxRows.value+1,15 do
				getglobal("RecapEffects"..i):Hide();
			end

			return;
		else

			i = 72 + ( math.max( math.min(recap_temp.ListSize-1,recap.Opt.MaxRows.value),1 )*14 ) 
			Recap_SetHeight(i);
			RecapScrollBar:SetHeight(i-63);
			RecapScrollBarTop:SetHeight(i-63);
			FauxScrollFrame_Update(RecapScrollBar,recap_temp.ListSize-1,recap.Opt.MaxRows.value,10);

			for i=1,recap.Opt.MaxRows.value do
				index = i + FauxScrollFrame_GetOffset(RecapScrollBar);

				if index < recap_temp.ListSize then


					Recap_SetFactionIcon(i,recap.Combatant[recap_temp.List[index].Name].Faction);
					Recap_SetClassIcon(i,recap.Combatant[recap_temp.List[index].Name].Class);

					item = getglobal("RecapList"..i.."_Name");
					item:SetText(recap_temp.List[index].Name);
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
					else
						item:SetTextColor(recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
					end

					getglobal("RecapList"..i.."_Kills"):SetText(recap_temp.List[index].Kills);

					getglobal("RecapList"..i.."_Time"):SetText(Recap_FormatTime(recap_temp.List[index].Time));

					item = getglobal("RecapList"..i.."_Heal");
					item:SetText(recap_temp.List[index].Heal);
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetTextColor(recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b);
					else
						item:SetTextColor(recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
					end

					item = getglobal("RecapList"..i.."_HealP");
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetText(recap_temp.List[index].HealP.."%");
					else
						item:SetText("");
					end

					getglobal("RecapList"..i.."_MaxHit"):SetText(recap_temp.List[index].MaxHit);

					item = getglobal("RecapList"..i.."_DmgIn");
					item:SetText(recap_temp.List[index].DmgIn);
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetTextColor(recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
					else
						item:SetTextColor(recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
					end

					item = getglobal("RecapList"..i.."_DmgInP");
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetText(recap_temp.List[index].DmgInP.."%");
					else
						item:SetText("");
					end

					item = getglobal("RecapList"..i.."_DmgOut");
					item:SetText(recap_temp.List[index].DmgOut);
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
					else
						item:SetTextColor(recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
					end

					item = getglobal("RecapList"..i.."_DmgOutP");
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetText(recap_temp.List[index].DmgOutP.."%");
					else
						item:SetText("");
					end

					item = getglobal("RecapList"..i.."_DPS");
					item:SetText(format("%.1f",recap_temp.List[index].DPS));
					if recap.Combatant[recap_temp.List[index].Name].Friend then
						item:SetTextColor(recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
					else
						item:SetTextColor(recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
					end

					getglobal("RecapList"..i):Show();

				else
					getglobal("RecapList"..i):Hide();
				end


			end

			for i=recap.Opt.MaxRows.value+1,15 do
				getglobal("RecapList"..i):Hide();
			end

		end

	end
end

--[[ Fight functions ]]

function Recap_CreateCombatant(arg1,is_source)

	if not arg1 then
		return;
	end

	-- if arg1 not a .Combatant, add an entry for them
	if not recap.Combatant[arg1] then
		Recap_CreateBlankCombatant(arg1);
	end
	-- if they haven't fought this session, add a .Last entry for them
	if not recap_temp.Last[arg1] then
		recap_temp.Last[arg1] = { Start = 0, End = 0, DmgIn = 0, DmgOut = 0, MaxHit = 0, Kills = 0, Heal = 0 };
	end
	-- if arg1 is hitting others, update their start or end time
	if is_source then

		if recap_temp.FightStart==0 then
			recap_temp.FightStart = GetTime();
			recap_temp.FightEnd = recap_temp.FightStart;
		else
			recap_temp.FightEnd = GetTime();
		end

		if recap_temp.Last[arg1].Start==0 then
			recap_temp.Last[arg1].Start = GetTime();
			recap_temp.Last[arg1].End = recap_temp.Last[arg1].Start;
		else
			recap_temp.Last[arg1].End = GetTime();
		end
	end

	recap.Combatant[arg1].WasInCurrent = true;
end

function Recap_StartFight()

	local i;

	if recap.Opt.State.value=="Idle" then
		if recap.Opt.AutoHide.value and not recap.Opt.Minimized.value then
			RecapFrame_Hide();
		end
		for i in recap.Combatant do
			recap.Combatant[i].WasInCurrent = false;
		end
		if not recap.Opt.LimitFights.value and recap.Opt.IdleFight.value then
			recap_temp.IdleTimer = 0;
		end
		Recap_SetState("Active");
	end
end

-- returns the current DPS of combatant named arg1 if it exists. UpdateDuration/DamageOut reused to save allocations
function Recap_GetCurrentDPS(arg1)

	if arg1 and recap_temp.Last[arg1] and recap_temp.Last[arg1].DmgOut>0 then
		recap_temp.UpdateDuration = recap_temp.Last[arg1].End - recap_temp.Last[arg1].Start;
		if recap.Opt.View.value=="All" then
			recap_temp.UpdateDuration = recap_temp.UpdateDuration + recap.Combatant[arg1].TotalTime;
		end
		recap_temp.UpdateDamageOut = recap_temp.Last[arg1].DmgOut;
		if recap.Opt.View.value=="All" then
			recap_temp.UpdateDamageOut = recap_temp.UpdateDamageOut + recap.Combatant[arg1].TotalDmgOut;
		end

		if recap_temp.UpdateDuration > recap_temp.MinTime then
			return (recap_temp.UpdateDamageOut / recap_temp.UpdateDuration);
		end
	end

	return 0;
end

function Recap_UpdateMinimizedDPS()

	if recap.Opt.State.value=="Active" then

		if recap_temp.Last[recap_temp.Player] and recap_temp.Last[recap_temp.Player].DmgOut>0 then
			i = Recap_GetCurrentDPS(recap_temp.Player)+Recap_GetCurrentDPS(UnitName("pet"));
			RecapMinYourDPS_Text:SetText(string.format("%.1f",i));
		end

		-- calculate running total DPS In and Out
		recap_temp.UpdateDuration = 0;
		if recap_temp.FightEnd>0 and recap_temp.FightStart>0 then
			recap_temp.UpdateDuration = recap_temp.FightEnd - recap_temp.FightStart;
		end
		if recap.Opt.View.value=="All" then
			recap_temp.UpdateDuration = recap_temp.UpdateDuration + recap[recap_temp.p].TotalDuration;
		end

		if recap_temp.UpdateDuration>recap_temp.MinTime then

			recap_temp.UpdateDmgIn = 0;
			recap_temp.UpdateDmgOut = 0;
			for i in recap_temp.Last do
				if recap.Combatant[i].Friend then
					recap_temp.UpdateDmgIn = recap_temp.UpdateDmgIn + recap_temp.Last[i].DmgIn;
					recap_temp.UpdateDmgOut = recap_temp.UpdateDmgOut + recap_temp.Last[i].DmgOut;
				end
			end

			if recap.Opt.View.value=="All" then
				for i in recap.Combatant do
					if recap.Combatant[i].Friend then
						recap_temp.UpdateDmgIn = recap_temp.UpdateDmgIn + recap.Combatant[i].TotalDmgIn;
						recap_temp.UpdateDmgOut = recap_temp.UpdateDmgOut + recap.Combatant[i].TotalDmgOut;
					end
				end
			end

			RecapMinDPSIn_Text:SetText(string.format("%.1f",recap_temp.UpdateDmgIn/recap_temp.UpdateDuration));
			RecapMinDPSOut_Text:SetText(string.format("%.1f",recap_temp.UpdateDmgOut/recap_temp.UpdateDuration));

		end

		Recap_UpdatePlugins();
	end
end

function Recap_AddPetToOwner(pet,owner)

	local earliest,latest;

	local text;

--[[	recap_temp.Last[pet].Start = (recap_temp.Last[pet].Start>0 and recap_temp.Last[pet].Start) or nil;
	recap_temp.Last[pet].End = (recap_temp.Last[pet].End>0 and recap_temp.Last[pet].End) or nil;
	recap_temp.Last[owner].Start = (recap_temp.Last[owner].Start>0 and recap_temp.Last[owner].Start) or nil;
	recap_temp.Last[owner].End = (recap_temp.Last[owner].End>0 and recap_temp.Last[owner].End) or nil;
]]
	-- times are only for DAMAGE
	if (recap.Combatant[pet].WasInCurrent and recap_temp.Last[pet].DmgOut>0) and (recap.Combatant[owner].WasInCurrent and recap_temp.Last[owner].DmgOut>0) then
		-- both pet and owner were in fight
		earliest = math.min(recap_temp.Last[pet].Start,recap_temp.Last[owner].Start);
		latest = math.max(recap_temp.Last[pet].End,recap_temp.Last[owner].End);
		recap_temp.Last[owner].Start = earliest;
		recap_temp.Last[owner].End = latest;
	elseif (recap.Combatant[pet].WasInCurrent and recap_temp.Last[pet].DmgOut>0) and (not recap.Combatant[owner].WasInCurrent or recap_temp.Last[owner].DmgOut==0) then
		-- just the pet was in fight
		recap_temp.Last[owner].Start = recap_temp.Last[pet].Start;
		recap_temp.Last[owner].End = recap_temp.Last[pet].End;
	end

	recap_temp.Last[owner].DmgIn = recap_temp.Last[owner].DmgIn + recap_temp.Last[pet].DmgIn;
	recap_temp.Last[owner].DmgOut = recap_temp.Last[owner].DmgOut + recap_temp.Last[pet].DmgOut;
	recap_temp.Last[owner].MaxHit = math.max(recap_temp.Last[owner].MaxHit,recap_temp.Last[pet].MaxHit);

	Recap_AccumulateCombatant(owner);

	recap_temp.Last[pet].Start = 0;
	recap_temp.Last[pet].End = 0;
	recap_temp.Last[pet].DmgIn = 0;
	recap_temp.Last[pet].DmgOut = 0;
	recap_temp.Last[pet].MaxHit = 0;
	recap_temp.Last[pet].Kills = 0;
	recap_temp.Last[pet].Heal = 0;
	recap.Combatant[pet].WasInLast = false;
	recap.Combatant[owner].WasInLast = true;
	recap.Combatant[pet].WasInCurrent = false;
	recap.Combatant[owner].WasInCurrent = false;

end

function Recap_AccumulateCombatant(i)

	recap.Combatant[i].LastDmgIn = recap_temp.Last[i].DmgIn;
	recap.Combatant[i].LastDmgOut = recap_temp.Last[i].DmgOut;
	recap.Combatant[i].LastTime = recap_temp.Last[i].End-recap_temp.Last[i].Start;
	recap.Combatant[i].LastMaxHit = recap_temp.Last[i].MaxHit;
	recap.Combatant[i].LastKills = recap_temp.Last[i].Kills;
	recap.Combatant[i].LastHeal = recap_temp.Last[i].Heal;

	recap_temp.Last[i].Start = 0;
	recap_temp.Last[i].End = 0;
	recap_temp.Last[i].DmgIn = 0;
	recap_temp.Last[i].DmgOut = 0;
	recap_temp.Last[i].MaxHit = 0;
	recap_temp.Last[i].Kills = 0;
	recap_temp.Last[i].Heal = 0;

	recap.Combatant[i].TotalDmgIn = recap.Combatant[i].TotalDmgIn + recap.Combatant[i].LastDmgIn;
	recap.Combatant[i].TotalDmgOut = recap.Combatant[i].TotalDmgOut + recap.Combatant[i].LastDmgOut;
	recap.Combatant[i].TotalTime = recap.Combatant[i].TotalTime + recap.Combatant[i].LastTime;
	recap.Combatant[i].TotalKills = recap.Combatant[i].TotalKills + recap.Combatant[i].LastKills;
	recap.Combatant[i].TotalHeal = recap.Combatant[i].TotalHeal + recap.Combatant[i].LastHeal;

	if recap.Combatant[i].LastTime > recap_temp.MinTime then
		recap.Combatant[i].LastDPS = recap.Combatant[i].LastDmgOut/recap.Combatant[i].LastTime;
	else
		recap.Combatant[i].LastDPS = 0;
	end
	if recap.Combatant[i].TotalTime > recap_temp.MinTime then
		recap.Combatant[i].TotalDPS = recap.Combatant[i].TotalDmgOut/recap.Combatant[i].TotalTime;
	else
		recap.Combatant[i].TotalDPS = 0;
	end

	recap.Combatant[i].TotalMaxHit = math.max(recap.Combatant[i].LastMaxHit,recap.Combatant[i].TotalMaxHit);

	recap.Combatant[i].WasInLast = true;
end

function Recap_EndFight()

	recap_temp.IdleTimer = -1;

	if recap.Opt.State.value=="Active" then

		recap.Opt.State.value = "Stopped"; -- suspend logging to calculate

		local debug_time = GetTime();

		Recap_MakeFriends();

		if recap_temp.FightEnd>recap_temp.FightStart then
			recap[recap_temp.p].LastDuration = recap_temp.FightEnd-recap_temp.FightStart;
		else
			recap[recap_temp.p].LastDuration = 0;
		end
		recap[recap_temp.p].TotalDuration = recap[recap_temp.p].TotalDuration + recap[recap_temp.p].LastDuration;
		recap_temp.FightStart = 0;
		recap_temp.FightEnd = 0;

		recap_temp.ListSize = 1;
		for i in recap_temp.Last do

			if recap.Combatant[i].WasInCurrent then
				if recap.Combatant[i].OwnedBy and recap.Opt.MergePets.value then
					Recap_AddPetToOwner(i,recap.Combatant[i].OwnedBy);
				elseif recap.Combatant[i].OwnsPet and recap.Opt.MergePets.value then
					Recap_AddPetToOwner(recap.Combatant[i].OwnsPet,i);
				else
					Recap_AccumulateCombatant(i)
				end
			else
				recap.Combatant[i].WasInLast = false;
			end

		end

		if recap.Opt.AutoPost.value then
			recap.Opt.SortBy.value = Recap_AutoPostGetStatID(recap.Opt.AutoPost.Stat);
			recap.Opt.SortDir.value = false;
		end

		Recap_ConstructList();
		Recap_SetState("Idle");

		if not recap.Opt.Minimized.value and recap.Opt.AutoHide.value then
			RecapFrame_Show();
			if recap.Opt.AutoFade.value then
				recap_temp.FadeTimer = 0;
			end
		end

		if recap.Opt.AutoPost.value then
			Recap_PostFight();
		end

		if recap.debug then
			DEFAULT_CHAT_FRAME:AddMessage("[recap.debug] Fight processed in "..string.format("%.4f",GetTime()-debug_time).." seconds for "..(recap_temp.ListSize-1).." combatants.");
		end

	end
end

-- parses CHAT_MSG_SPELL/COMBAT messages to .Last running totals
function Recap_DamageEvent(arg1)

	local i, source, dest, damage;
	local found = false;

	if recap.Opt.State.value~="Stopped" then

		arg1 = string.gsub(arg1,"%.$",""); -- strip trailing .'s
		arg1 = string.gsub(arg1,"%(.=%)",""); -- strip trailing ()'s we don't use

		for i=1,recap_temp.FilterSize do
			found,_,recap_temp.FilterIndex[1],recap_temp.FilterIndex[2],recap_temp.FilterIndex[3],recap_temp.FilterIndex[4] = string.find(arg1,recap_temp.Filter[i].pattern);
			if found then

				if not recap.Opt.LimitFights.value then
					if recap.Opt.IdleFight.value then
						recap_temp.IdleTimer = 0;
					end
					if recap.Opt.State.value=="Idle" then
						Recap_StartFight();
					end
				end

				source=recap_temp.FilterIndex[recap_temp.Filter[i].source];
				dest=recap_temp.FilterIndex[recap_temp.Filter[i].dest];
				if dest==recap_temp.Local.Pronoun then
					dest = recap_temp.Player;
				end
				damage=tonumber(recap_temp.FilterIndex[recap_temp.Filter[i].damage]);

				if recap.debug then
					if not recap.debug_Filter then
						recap.debug_Filter = {};
					end
					if not recap.debug_Filter[i] then
						recap.debug_Filter[i] = { hits=1, total=damage, pattern=recap_temp.Filter[i].pattern };
					else
						recap.debug_Filter[i].hits = recap.debug_Filter[i].hits + 1;
						recap.debug_Filter[i].total = recap.debug_Filter[i].total + damage;
					end
					if recap_temp.Filter[i].watch then
						DEFAULT_CHAT_FRAME:AddMessage("["..i.."] \""..recap_temp.Filter[i].pattern.."\" triggered!");
						DEFAULT_CHAT_FRAME:AddMessage("source="..tostring(source)..", dest="..tostring(dest)..", damage="..tostring(damage));
					end
				end

				Recap_CreateCombatant(source,1);
				recap_temp.Last[source].DmgOut = recap_temp.Last[source].DmgOut + damage;
				if damage > recap_temp.Last[source].MaxHit then
					recap_temp.Last[source].MaxHit = damage;
				end
				Recap_CreateCombatant(dest);
				recap_temp.Last[dest].DmgIn = recap_temp.Last[dest].DmgIn + damage;

				if recap_temp.Filter[i].effect and source==recap_temp.Player then
					Recap_CreateEffect(recap_temp.FilterIndex[recap_temp.Filter[i].effect], 1, damage, recap_temp.Filter[i].crit);
				end

				if recap_temp.Filter[i].effect and UnitName("pet") and source==UnitName("pet") then
					Recap_CreateEffect(source.."'s "..recap_temp.FilterIndex[recap_temp.Filter[i].effect], 2, damage, recap_temp.Filter[i].crit);
				end				

				i=recap_temp.FilterSize+1;

			end
		end
	end
end

-- type=1 for damage, 2 for pet, 3 for heals
function Recap_CreateEffect(effect,type,total,did_crit)

	effect = type..effect;

	if not recap[recap_temp.p].Self.Effect[effect] then
		recap[recap_temp.p].Self.Effect[effect] = { Type=type, Total=0, Hits=0, MaxHit=0, Crits=0, MaxCrit=0 };
	end

	recap[recap_temp.p].Self.Effect[effect].Total = recap[recap_temp.p].Self.Effect[effect].Total + total;
	if did_crit then
		recap[recap_temp.p].Self.Effect[effect].Crits = recap[recap_temp.p].Self.Effect[effect].Crits + 1;
		if total > recap[recap_temp.p].Self.Effect[effect].MaxCrit then
			recap[recap_temp.p].Self.Effect[effect].MaxCrit = total;
		end
	else
		recap[recap_temp.p].Self.Effect[effect].Hits = recap[recap_temp.p].Self.Effect[effect].Hits + 1;
		if total > recap[recap_temp.p].Self.Effect[effect].MaxHit then
			recap[recap_temp.p].Self.Effect[effect].MaxHit = total;
		end
	end

end

function Recap_DeathEvent(arg1)

	local i, victim;
	local found = false;

	if recap.Opt.State.value~="Stopped" then

		for i=1,recap_temp.DeathFilterSize do
			found,_,recap_temp.FilterIndex[1] = string.find(arg1,recap_temp.DeathFilter[i].pattern);

			if found then

				victim = recap_temp.FilterIndex[recap_temp.DeathFilter[i].victim];
				if victim and recap_temp.Last[victim] then
					recap_temp.Last[victim].Kills = recap_temp.Last[victim].Kills + 1;
				end

				if recap.debug then
					if not recap.debug_Filter then
						recap.debug_Filter = {};
					end
					if not recap.debug_Filter[i+60] then
						recap.debug_Filter[i+60] = { hits=1, total=1, pattern=recap_temp.DeathFilter[i].pattern };
					else
						recap.debug_Filter[i+60].hits = recap.debug_Filter[i+60].hits + 1;
						recap.debug_Filter[i+60].total = recap.debug_Filter[i+60].total + 1;
					end
					if recap_temp.Filter[i].watch then
						DEFAULT_CHAT_FRAME:AddMessage("["..i.."] \""..recap_temp.DeathFilter[i].pattern.."\" triggered!");
						DEFAULT_CHAT_FRAME:AddMessage("victim="..tostring(victim));
					end
				end

				i = recap_temp.DeathFilterSize+1;

			end
		end
	end
end

function Recap_HealEvent(arg1)

	local i, source, dest, heal;
	local found = false;

	if recap.Opt.State.value~="Stopped" then

		-- strip out period at end of chat line, if one exists
		arg1 = string.gsub(arg1,"%.$","");

		for i=1,recap_temp.HealFilterSize do
			found,_,recap_temp.FilterIndex[1],recap_temp.FilterIndex[2],recap_temp.FilterIndex[3],recap_temp.FilterIndex[4] = string.find(arg1,recap_temp.HealFilter[i].pattern);

			if found then

				source=recap_temp.FilterIndex[recap_temp.HealFilter[i].source];
				dest=recap_temp.FilterIndex[recap_temp.HealFilter[i].dest];
				if dest==recap_temp.Local.Pronoun then
					dest = recap_temp.Player;
				end
				heal=tonumber(recap_temp.FilterIndex[recap_temp.HealFilter[i].heal]);

				Recap_CreateCombatant(source);
				recap_temp.Last[source].Heal = recap_temp.Last[source].Heal + heal;

				if recap.debug then
					if not recap.debug_Filter then
						recap.debug_Filter = {};
					end
					if not recap.debug_Filter[i+75] then
						recap.debug_Filter[i+75] = { hits=1, total=heal, pattern=recap_temp.HealFilter[i].pattern };
					else
						recap.debug_Filter[i+75].hits = recap.debug_Filter[i+75].hits + 1;
						recap.debug_Filter[i+75].total = recap.debug_Filter[i+75].total + heal;
					end
					if recap_temp.Filter[i].watch then
						DEFAULT_CHAT_FRAME:AddMessage("["..i.."] \""..recap_temp.HealFilter[i].pattern.."\" triggered!");
						DEFAULT_CHAT_FRAME:AddMessage("source="..tostring(source)..", dest="..tostring(dest)..", heal="..tostring(heal));
					end
				end

				if recap_temp.HealFilter[i].effect and source==recap_temp.Player then
					Recap_CreateEffect(recap_temp.FilterIndex[recap_temp.HealFilter[i].effect], 3, heal, recap_temp.HealFilter[i].crit);
				end

				i = recap_temp.HealFilterSize+1;

			end
		end
	end
end

function Recap_ConstructSelf()

	 local i;

	 recap_temp.SelfListSize = 1;
	 recap[recap_temp.p].Self.TotalDmg = 0;
	 recap[recap_temp.p].Self.TotalHeal = 0;

	 for j=1,3 do  -- 1=dmg 2=pet 3=heal
		for i in recap[recap_temp.p].Self.Effect do
			if recap[recap_temp.p].Self.Effect[i].Type==j then
				recap_temp.SelfList[recap_temp.SelfListSize] = { Type=j, Effect=i,
												Total=recap[recap_temp.p].Self.Effect[i].Total,
												Hits=recap[recap_temp.p].Self.Effect[i].Hits,
												MaxHit=recap[recap_temp.p].Self.Effect[i].MaxHit,
												Crits=recap[recap_temp.p].Self.Effect[i].Crits,
												MaxCrit=recap[recap_temp.p].Self.Effect[i].MaxCrit,
												CritRate = 0 };
				if j<3 then
					recap[recap_temp.p].Self.TotalDmg = recap[recap_temp.p].Self.TotalDmg + recap[recap_temp.p].Self.Effect[i].Total;
				else
					recap[recap_temp.p].Self.TotalHeal = recap[recap_temp.p].Self.TotalHeal + recap[recap_temp.p].Self.Effect[i].Total;
				end
				if recap[recap_temp.p].Self.Effect[i].Hits>0 or recap[recap_temp.p].Self.Effect[i].Crits>0 then
					recap_temp.SelfList[recap_temp.SelfListSize].CritRate = string.format("%.1f",100*recap[recap_temp.p].Self.Effect[i].Crits / (recap[recap_temp.p].Self.Effect[i].Crits+recap[recap_temp.p].Self.Effect[i].Hits)).."%";
				end
				if recap[recap_temp.p].Self.Effect[i].Crits==0 then
					recap_temp.SelfList[recap_temp.SelfListSize].Crits = "-";
					recap_temp.SelfList[recap_temp.SelfListSize].MaxCrit = "-";
					recap_temp.SelfList[recap_temp.SelfListSize].CritRate = "-";
				end

				recap_temp.SelfListSize = recap_temp.SelfListSize + 1;
			end
		end
	end

	for i=1,recap_temp.SelfListSize-1 do
		if recap_temp.SelfList[i].Type==1 or recap_temp.SelfList[i].Type==2 then
			recap_temp.SelfList[i].Rate = string.format("%.0f",100*recap_temp.SelfList[i].Total/recap[recap_temp.p].Self.TotalDmg).."%";
		elseif recap_temp.SelfList[i].Type==3 then
			recap_temp.SelfList[i].Rate = string.format("%.0f",100*recap_temp.SelfList[i].Total/recap[recap_temp.p].Self.TotalHeal).."%";
		end
	end

	table.sort(recap_temp.SelfList,Recap_SortEffects); -- sort by total
	Recap_SortEffectTypes(); -- sort by effect type (dmg/pet/heal)
end


function Recap_ConstructList()

	local i, dpsin, dpsout, entry, duration;
	local maxhit = 0;
	local dmgin = 0;
	local dmgout = 0;
	local kills = 0;
	local heal = 0;

	Recap_ConstructSelf();

	recap_temp.ListSize = 1;

	for i in recap.Combatant do
		if not recap_temp.List[recap_temp.ListSize] then
			recap_temp.List[recap_temp.ListSize] = {};
		end
		entry = false;
		if (recap.Combatant[i].LastDmgIn==0 and recap.Combatant[i].LastDmgOut==0 and
			recap.Combatant[i].TotalDmgOut==0 and recap.Combatant[i].TotalDmgIn==0) or
		   (recap.Opt.HideFoe.value and not recap.Combatant[i].Friend) or
		   (recap.Opt.HideYardTrash.value and (not recap.Combatant[i].Friend and recap.Combatant[i].TotalKills~=1)) or
		   (recap.Combatant[i].Ignore) then
			entry = false; -- strip out unwanted combatants
		elseif recap.Opt.View.value=="Last" and recap.Combatant[i].WasInLast then
			if not recap.Opt.HideZero.value or recap.Combatant[i].LastTime>recap_temp.MinTime then
				recap_temp.List[recap_temp.ListSize].Name = i;
				recap_temp.List[recap_temp.ListSize].Time = recap.Combatant[i].LastTime;
				recap_temp.List[recap_temp.ListSize].MaxHit = recap.Combatant[i].LastMaxHit;
				recap_temp.List[recap_temp.ListSize].DmgIn = recap.Combatant[i].LastDmgIn;
				recap_temp.List[recap_temp.ListSize].DmgOut = recap.Combatant[i].LastDmgOut;
				recap_temp.List[recap_temp.ListSize].DPS = recap.Combatant[i].LastDPS;
				recap_temp.List[recap_temp.ListSize].Kills = recap.Combatant[i].LastKills;
				recap_temp.List[recap_temp.ListSize].Heal = recap.Combatant[i].LastHeal;
				entry = true;
			end
		elseif recap.Opt.View.value=="All" then
			if not recap.Opt.HideZero.value or recap.Combatant[i].TotalTime>recap_temp.MinTime then
				recap_temp.List[recap_temp.ListSize].Name = i;
				recap_temp.List[recap_temp.ListSize].Time = recap.Combatant[i].TotalTime;
				recap_temp.List[recap_temp.ListSize].MaxHit = recap.Combatant[i].TotalMaxHit;
				recap_temp.List[recap_temp.ListSize].DmgIn = recap.Combatant[i].TotalDmgIn;
				recap_temp.List[recap_temp.ListSize].DmgOut = recap.Combatant[i].TotalDmgOut;
				recap_temp.List[recap_temp.ListSize].DPS = recap.Combatant[i].TotalDPS;
				recap_temp.List[recap_temp.ListSize].Kills = recap.Combatant[i].TotalKills;
				recap_temp.List[recap_temp.ListSize].Heal = recap.Combatant[i].TotalHeal;
				entry = true;
			end
		end
		if entry then
			if recap.Combatant[recap_temp.List[recap_temp.ListSize].Name].Friend then
				if recap_temp.List[recap_temp.ListSize].MaxHit > maxhit then
					maxhit = recap_temp.List[recap_temp.ListSize].MaxHit;
				end
				dmgin = dmgin + recap_temp.List[recap_temp.ListSize].DmgIn;
				dmgout = dmgout + recap_temp.List[recap_temp.ListSize].DmgOut;
				kills = kills + recap_temp.List[recap_temp.ListSize].Kills;
				heal = heal + recap_temp.List[recap_temp.ListSize].Heal;
			end
			recap_temp.ListSize = recap_temp.ListSize + 1;
		end
	end

	if recap.Opt.View.value=="Last" then
		duration = recap[recap_temp.p].LastDuration;
	else
		duration = recap[recap_temp.p].TotalDuration;
	end

	if not recap_temp.List[recap_temp.ListSize] then
		recap_temp.List[recap_temp.ListSize] = {};
	end
	-- the final entry is the totals
	recap_temp.List[recap_temp.ListSize].Name = "Totals";
	recap_temp.List[recap_temp.ListSize].Time = duration;
	RecapTotals_Time:SetText(Recap_FormatTime(duration));
	recap_temp.List[recap_temp.ListSize].MaxHit = maxhit;
	RecapTotals_MaxHit:SetText(maxhit);
	recap_temp.List[recap_temp.ListSize].DmgIn = dmgin;
	RecapTotals_DmgIn:SetText(dmgin);
	recap_temp.List[recap_temp.ListSize].DmgOut = dmgout;
	RecapTotals_DmgOut:SetText(dmgout);
	recap_temp.List[recap_temp.ListSize].Kills = kills;
	RecapTotals_Kills:SetText(kills);
	recap_temp.List[recap_temp.ListSize].Heal = heal;
	RecapTotals_Heal:SetText(heal);
	if duration > recap_temp.MinTime then
		recap_temp.List[recap_temp.ListSize].DPSIn = dmgin/duration;
		recap_temp.List[recap_temp.ListSize].DPSOut = dmgout/duration;
	else
		recap_temp.List[recap_temp.ListSize].DPSIn = 0;
		recap_temp.List[recap_temp.ListSize].DPSOut = 0;
	end
	RecapTotals_DPS:SetText(string.format("%.1f",recap_temp.List[recap_temp.ListSize].DPSOut));
	RecapTotals_DPSIn:SetText(string.format("%.1f",recap_temp.List[recap_temp.ListSize].DPSIn));

	RecapMinDPSIn_Text:SetText(string.format("%.1f",recap_temp.List[recap_temp.ListSize].DPSIn));
	RecapMinDPSOut_Text:SetText(string.format("%.1f",recap_temp.List[recap_temp.ListSize].DPSOut));
	if recap.Combatant[recap_temp.Player] and recap.Opt.View.value=="Last" then
		i = recap.Combatant[recap_temp.Player].LastDPS;
		if UnitName("pet") and UnitName("pet")~=UNKNOWNOBJECT and recap.Combatant[UnitName("pet")] then
			i = i + recap.Combatant[UnitName("pet")].LastDPS;
		end
		RecapMinYourDPS_Text:SetText(string.format("%.1f",i));
	elseif recap.Combatant[recap_temp.Player] and recap.Opt.View.value=="All" then
		i = recap.Combatant[recap_temp.Player].TotalDPS;
		if UnitName("pet") and UnitName("pet")~=UNKNOWNOBJECT and recap.Combatant[UnitName("pet")] then
			i = i + recap.Combatant[UnitName("pet")].TotalDPS;
		end
		RecapMinYourDPS_Text:SetText(string.format("%.1f",i));
	else
		RecapMinYourDPS_Text:SetText("n/a");
	end

	-- calculate percentages
	for i=1,recap_temp.ListSize-1 do
		recap_temp.List[i].HealP = 0;
		recap_temp.List[i].DmgInP = 0;
		recap_temp.List[i].DmgOutP = 0;
		if recap.Combatant[recap_temp.List[i].Name].Friend then
			if recap_temp.List[recap_temp.ListSize].Heal>0 then
				recap_temp.List[i].HealP = math.floor(.5+100*recap_temp.List[i].Heal/recap_temp.List[recap_temp.ListSize].Heal);
			end
			if recap_temp.List[recap_temp.ListSize].DmgIn>0 then
				recap_temp.List[i].DmgInP = math.floor(.5+100*recap_temp.List[i].DmgIn/recap_temp.List[recap_temp.ListSize].DmgIn);
			end
			if recap_temp.List[recap_temp.ListSize].DmgOut>0 then
				recap_temp.List[i].DmgOutP = math.floor(.5+100*recap_temp.List[i].DmgOut/recap_temp.List[recap_temp.ListSize].DmgOut);
			end
		end
	end

	Recap_SortList();
	RecapScrollBar_Update();
	Recap_UpdatePlugins();

end

--[[ Sorting functions ]]

-- initial sort by field done with table.sort for speed, then
-- friends shifted to top with an insertion sort for "stable" list
function Recap_SortList()

	local temp;

	temp = recap_temp.List[recap_temp.ListSize];
	recap_temp.List[recap_temp.ListSize] = nil;

	if recap.Opt.SortDir.value then
		table.sort(recap_temp.List,Recap_SortDown);
	else
		table.sort(recap_temp.List,Recap_SortUp);
	end
	Recap_SortFriends();

	recap_temp.List[recap_temp.ListSize] = temp;
end

function Recap_SortDown(e1,e2)

	if e1 and e2 and ( e1[recap.Opt.SortBy.value] < e2[recap.Opt.SortBy.value] ) then
		return true;
	else
		return false;
	end
end

function Recap_SortUp(e1,e2)

	if e1 and e2 and ( e1[recap.Opt.SortBy.value] > e2[recap.Opt.SortBy.value] ) then
		return true;
	else
		return false;
	end
end

-- perform stable insertion sort on the list
function Recap_SortFriends()

	local i,j;
	local changed = true;
	local temp = {}

	if recap_temp.ListSize>2 then

		for i=2,(recap_temp.ListSize-1) do
			temp = recap_temp.List[i];
			j=i;
			while (j>1) and (not recap.Combatant[recap_temp.List[j-1].Name].Friend and recap.Combatant[temp.Name].Friend) do
				recap_temp.List[j] = recap_temp.List[j-1];
				j = j - 1;
			end
			recap_temp.List[j] = temp;
		end

	end
end

-- self view sort by effect total
function Recap_SortEffects(e1,e2)

	if e1 and e2 and ( e1.Total > e2.Total ) then
		return true;
	else
		return false;
	end
end

-- self view stable sort by effect type
function Recap_SortEffectTypes()

	local i,j;
	local changed = true;
	local temp = {};

	if recap_temp.SelfListSize>2 then

		for i=2,(recap_temp.SelfListSize-1) do
			temp = recap_temp.SelfList[i];
			j=i;
			while (j>1) and (recap_temp.SelfList[j-1].Type > temp.Type) do
				recap_temp.SelfList[j] = recap_temp.SelfList[j-1];
				j = j - 1;
			end
			recap_temp.SelfList[j] = temp;
		end

	end
end   

--[[ Window movement functions ]]

function Recap_OnMouseDown(arg1)

	if recap_temp.Loaded and arg1=="LeftButton" and not recap.Opt.Pinned.value then
		RecapFrame:StartMoving();
	end
end

function Recap_OnMouseUp(arg1)

	if recap_temp.Loaded and arg1=="LeftButton" and not recap.Opt.Pinned.value then
		RecapFrame:StopMovingOrSizing();
		Recap_CheckWindowBounds();
	elseif arg1=="RightButton" and recap.Opt.Minimized.value then
		recap.Opt.Pinned.value = not recap.Opt.Pinned.value;
		Recap_SetButtons();
		if recap.Opt.Pinned.value then
			Recap_OnTooltip("MinPinned");
		else
			Recap_OnTooltip("MinUnpinned");
		end
	end		
end

-- repositions RecapFrame if any part of it goes off the screen
function Recap_CheckWindowBounds()

	local x1, y1, x2, y2, cx, cy;
	local needs_moved = false;

	if recap_temp.Loaded and RecapFrame then

		x1 = RecapFrame:GetLeft();
		y1 = RecapFrame:GetTop();
		cx = RecapFrame:GetWidth();
		cy = RecapFrame:GetHeight();

		if x1 and y1 and cx and cy then

			x2 = RecapFrame:GetRight();
			y2 = RecapFrame:GetBottom();
			uix2 = UIParent:GetRight();
			uix1 = UIParent:GetLeft();
			uiy1 = UIParent:GetTop();
			uiy2 = UIParent:GetBottom();

			if x2 and uix2 and x2 > uix2 then
				x1 = x1 + uix2 - x2;
				needs_moved = true;
			elseif uix1 and uix1 > x1 then
				x1 = x1 + uix1 - x1;
				needs_moved = true;
			end

			if y1 and y1 > uiy1 then
				y1 = y1 + uiy1 - y1;
				needs_moved = true;
			elseif uiy2 and uiy2 > y2 then
				y1 = y1 + uiy2 - y2;
				needs_moved = true;
			end

			if needs_moved then
				RecapFrame:ClearAllPoints();
				RecapFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",x1,y1);
			end

			recap[recap_temp.p].WindowTop = RecapFrame:GetTop();
			recap[recap_temp.p].WindowLeft = RecapFrame:GetLeft();
			recap[recap_temp.p].WindowHeight = RecapFrame:GetHeight();
			recap[recap_temp.p].WindowWidth = RecapFrame:GetWidth();

		end

	end
end

--[[ Dialog control functions ]]

function Recap_OnClick(arg1)

	if not recap_temp.Loaded then
		return;
	end

	local fight_count = 0;
	local total_fight_count = 0;
	local filen = RecapSetEditBox:GetText();
	local set_friend, set_dmgin, set_dmgout, set_maxhit, set_kills, set_heal, set_time;

	PlaySound("GAMEGENERICBUTTONPRESS");

	if arg1=="Close" then
		RecapFrame_Hide();
	elseif arg1=="Minimize" then

		if recap.Opt.Minimized.value then
			Recap_Maximize();
		else
			Recap_Minimize();
		end
		RecapFrame:SetAlpha(1);
		recap_temp.FadeTimer = -1;
		Recap_SetButtons();
	elseif arg1=="Pin" then
		recap.Opt.Pinned.value = not recap.Opt.Pinned.value;
		Recap_SetButtons();
		Recap_OnTooltip("Pin");
	elseif arg1=="Pause" then
		if recap.Opt.Paused.value then
			recap.Opt.Paused.value = false;
			Recap_SetState("Idle");
		else
			recap.Opt.Paused.value = true;
			Recap_EndFight();
			Recap_SetState("Stopped");
		end
		Recap_SetButtons();
		Recap_OnTooltip("Pause");
	elseif arg1=="ShowAll" then
		if recap.Opt.View.value=="Last" then
			Recap_SetView("All");
		else
			Recap_SetView("Last");
		end
		Recap_OnTooltip("ShowAll");
		if recap.Opt.SelfView.value and not recap.Opt.Minimized.value then
			recap.Opt.SelfView.value = false;
			Recap_SetButtons();
			Recap_Maximize();
		end
	elseif arg1=="Options" then
		if RecapOptFrame:IsShown() then
			RecapOptFrame_Hide();
		else
			RecapOptFrame:Show();
		end
	elseif arg1=="SelfView" then
		recap.Opt.SelfView.value = not recap.Opt.SelfView.value;
		Recap_SetButtons();
		Recap_Maximize();
		Recap_OnTooltip("SelfView");
	elseif arg1=="Reset" then

		if recap.Opt.SelfView.value then
			recap[recap_temp.p].Self = { TotalDmg=0, TotalHeal=0, Effect={} };
			recap_temp.SelfList = {};
			recap_temp.SelfListSize = 0;
			Recap_Maximize();
		elseif recap.Opt.View.value=="All" then
			-- wipe everything --
			Recap_ResetAllCombatants();
			Recap_SetView();
			Recap_MakeFriends();
		elseif recap.Opt.View.value=="Last" then
			-- remove just the last fight --
			for i in recap.Combatant do
				if recap.Combatant[i].WasInLast then
					Recap_ResetLastFight(i)				
				end
			end
			recap[recap_temp.p].TotalDuration = recap[recap_temp.p].TotalDuration - recap[recap_temp.p].LastDuration;
			recap[recap_temp.p].LastDuration = 0;
			Recap_SetView();
		end

	elseif arg1=="SaveSet" then
		RecapSetEditBox:ClearFocus();
		if filen and filen~="" then
			filen = string.gsub(filen,"\"","'"); -- convert "s to 's
			filen = string.gsub(filen,"%[","("); -- convert [s to (s
			filen = string.gsub(filen,"%]",")"); -- convert ]s to )s
		end
		RecapSetEditBox:SetText("");
		Recap_SaveCombatants(filen,recap.Opt.ReplaceSet.value);
		Recap_BuildFightSets();
		recap_temp.FightSetSelected = 0;
		RecapFightSetsScrollBar_Update();

	elseif arg1=="LoadSet" then
		RecapSetEditBox:SetText("");
		RecapSetEditBox:ClearFocus();
		Recap_LoadCombatants(filen,recap.Opt.ReplaceSet.value);
		Recap_MakeFriends();
		Recap_SetView("All");

	elseif arg1=="DeleteSet" then
		RecapSetEditBox:SetText("");
		RecapSetEditBox:ClearFocus();
		recap_set[filen] = nil;
		Recap_BuildFightSets();

	end
end

-- removes combatant i from last fight
function Recap_ResetLastFight(i)
	recap.Combatant[i].TotalTime = recap.Combatant[i].TotalTime - recap.Combatant[i].LastTime;
	recap.Combatant[i].TotalDmgIn = recap.Combatant[i].TotalDmgIn - recap.Combatant[i].LastDmgIn;
	recap.Combatant[i].TotalDmgOut = recap.Combatant[i].TotalDmgOut - recap.Combatant[i].LastDmgOut;
	recap.Combatant[i].TotalHeal = recap.Combatant[i].TotalHeal - recap.Combatant[i].LastHeal;
	recap.Combatant[i].TotalKills = recap.Combatant[i].TotalKills - recap.Combatant[i].LastKills;
	if recap.Combatant[i].TotalTime> recap_temp.MinTime then
		recap.Combatant[i].TotalDPS = recap.Combatant[i].TotalDmgOut/recap.Combatant[i].TotalTime;
	else
		recap.Combatant[i].TotalDPS = 0;
	end
	recap.Combatant[i].WasInLast = false;
	recap.Combatant[i].LastTime = 0;
	recap.Combatant[i].LastDmgIn = 0;
	recap.Combatant[i].LastDmgOut = 0;
	recap.Combatant[i].LastDPS = 0;
	recap.Combatant[i].LastMaxHit = 0;
	recap.Combatant[i].LastKills = 0;
	recap.Combatant[i].LastHeal = 0;
end

-- sort column, toggle dir for new headers, name=ascending, rest=descending
function Recap_Header_OnClick(arg1)

	local text="";
	local channel = ""; -- "Guild" "Say" etc or "Channel"
	local chatnumber = 0; -- if channel is "Channel", this is the channel numbers

	if not IsShiftKeyDown() then
		if recap.Opt.SortBy.value==arg1 then
			recap.Opt.SortDir.value = not recap.Opt.SortDir.value;
		else
			recap.Opt.SortBy.value = arg1;
			if arg1=="Name" then
				recap.Opt.SortDir.value = true;
			else
				recap.Opt.SortDir.value = false;
			end
		end
		Recap_SortList();
		RecapScrollBar_Update();
	elseif ChatFrameEditBox:IsVisible() and recap_temp.ListSize>1 and arg1~="Name" then

		recap.Opt.SortBy.value = arg1;
		recap.Opt.SortDir.value = false;
		Recap_SortList();
		RecapScrollBar_Update();

		if recap.Opt.SpamRows.value then

			channel = ChatFrameEditBox.chatType;
			chatnumber = nil;

			if channel=="WHISPER" then
				chatnumber = ChatFrameEditBox.tellTarget;
			elseif channel=="CHANNEL" then
				chatnumber = ChatFrameEditBox.channelTarget;
			end

			Recap_PostSpamRows(arg1,channel,chatnumber)

		else
			ChatFrameEditBox:Insert(Recap_PostSpamLine(arg1));
		end

	elseif not ChatFrameEditBox:IsVisible() then
		DEFAULT_CHAT_FRAME:AddMessage(recap_temp.Local.RankUsage);
	end

end

function Recap_List_OnClick(arg1)

	local id, index;
	local text = "";

	id = this:GetID();
	index = id + FauxScrollFrame_GetOffset(RecapScrollBar);

	if arg1=="LeftButton" and index<recap_temp.ListSize and IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
		ChatFrameEditBox:Insert(recap_temp.List[index].Name.." "..getglobal("RecapList"..id.."_DPS"):GetText().." ");
	elseif arg1=="RightButton" and index<recap_temp.ListSize and IsShiftKeyDown() and ChatFrameEditBox:IsVisible() then
		ChatFrameEditBox:Insert(string.format(recap_temp.Local.VerboseLinkStart,		
								recap_temp.List[index].Name,
								getglobal("RecapList"..id.."_DmgIn"):GetText(),
								getglobal("RecapList"..id.."_DmgOut"):GetText(),
								getglobal("RecapList"..id.."_Time"):GetText(),
								getglobal("RecapList"..id.."_DPS"):GetText(),
								getglobal("RecapList"..id.."_MaxHit"):GetText() ).." for "..
								recap_temp.Local.LastAll[recap.Opt.View.value]);
	elseif arg1=="RightButton" and index<recap_temp.ListSize and not IsShiftKeyDown() then
		Recap_CreateMenu(recap_temp.List[index].Name,not recap.Combatant[recap_temp.List[index].Name].Friend);
	end
end

--[[ Tooltip functions ]]

function Recap_Tooltip(arg1,arg2)

	if recap_temp.Loaded and recap.Opt.ShowTooltips.value then
		if not recap.Opt.TooltipFollow.value then
			GameTooltip_SetDefaultAnchor(GameTooltip,this);
		else
			GameTooltip:SetOwner(this,Recap_TooltipAnchor());
		end
		GameTooltip:SetText(arg1);
		GameTooltip:AddLine(arg2, .75, .75, .75, 1);
		GameTooltip:Show();
	end
end

-- returns line1,line2 of a tooltip for arg1 in OptList (for generic static tooltips)
function Recap_GetTooltip(arg1)

	local i;

	if arg1 then
		for i in recap_temp.OptList do
			if recap_temp.OptList[i][1]==arg1 then
				return recap_temp.OptList[i][2],recap_temp.OptList[i][3];
			end
		end
	end
end

function Recap_OnTooltip(arg1)

	local line1, line2;

	if arg1=="Status" then
		Recap_Tooltip("Recap Status: "..recap.Opt.State.value,recap_temp.Local.StatusTooltip);
	elseif arg1=="Close" then
		if recap.Opt.State.value=="Stopped" then
			Recap_OnTooltip("ExitRecap");
		else
			Recap_OnTooltip("HideWindow");
		end
	elseif arg1=="Minimize" then
		if recap.Opt.Minimized.value then
			Recap_OnTooltip("ExpandWindow");
		else
			Recap_OnTooltip("MinimizeWindow");
		end
	elseif arg1=="Pin" then
		if recap.Opt.Pinned.value then
			Recap_OnTooltip("UnPinWindow");
		else
			Recap_OnTooltip("PinWindow");
		end
	elseif arg1=="Pause" then
		if recap.Opt.State.value=="Stopped" then
			Recap_OnTooltip("Resume");
		else
			Recap_OnTooltip("PauseMonitoring");
		end
	elseif arg1=="ShowAll" then
		if recap.Opt.View.value=="Last" then
			Recap_OnTooltip("ShowAllFights");
		else
			Recap_OnTooltip("ShowLastFight");
		end
	elseif arg1=="HeaderName" then
		if recap.Opt.View.value=="Last" then
			Recap_OnTooltip("CombatLast");
		else
			Recap_OnTooltip("CombatAll");
		end
	elseif arg1=="Reset" then
		if recap.Opt.SelfView.value then
			Recap_OnTooltip("ResetSelfView");
		elseif recap.Opt.View.value=="Last" then
			Recap_OnTooltip("ResetLastFight");
		else
			Recap_OnTooltip("ResetAllTotals");
		end
	elseif arg1=="SelfView" then
		if recap.Opt.SelfView.value then
			Recap_OnTooltip("HideDetails");
		else
			Recap_OnTooltip("ShowDetails");
		end
	else
		line1,line2 = Recap_GetTooltip(arg1);
		if line1 and line2 then
			Recap_Tooltip(line1, line2);
		end
		
	end
end

-- special tooltip for list - displays fight data in a tooltip
function Recap_List_OnEnter()

	local index, id;
	local r = recap_temp.ColorWhite.r;
	local g = recap_temp.ColorWhite.g;
	local b = recap_temp.ColorWhite.b;
	local p = "";

	id = this:GetID();

	if id and id>0 and recap.Opt.ShowTooltips.value then
		index = id + FauxScrollFrame_GetOffset(RecapScrollBar);
		if (index<recap_temp.ListSize) then

			if recap.Opt.TooltipFollow.value then
				GameTooltip:SetOwner(this,Recap_TooltipAnchor());
			else
				GameTooltip_SetDefaultAnchor(GameTooltip,this);
			end
			p = recap_temp.List[index].Name;
			if p==recap_temp.Player then
				GameTooltip:AddDoubleLine(p,"(You)",recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b,.75,.75,.75);
			elseif recap.Combatant[recap_temp.List[index].Name].Friend then
				GameTooltip:AddDoubleLine(p,"(Friend)",recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b,.75,.75,.75);
			else
				GameTooltip:AddLine(p,r,g,b);
			end
			GameTooltip:AddDoubleLine("Last Fight","All Fights",recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b,recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b);
			GameTooltip:AddDoubleLine("Time: "..Recap_FormatTime(recap.Combatant[p].LastTime),"Time: "..Recap_FormatTime(recap.Combatant[p].TotalTime),r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Max: "..recap.Combatant[p].LastMaxHit,"Max: "..recap.Combatant[p].TotalMaxHit,r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Deaths: "..recap.Combatant[p].LastKills,"Deaths: "..recap.Combatant[p].TotalKills,r,g,b,r,g,b);

			if recap.Combatant[recap_temp.List[index].Name].Friend then
				GameTooltip:AddDoubleLine("Heals: "..recap.Combatant[p].LastHeal,"Heals: "..recap.Combatant[p].TotalHeal,recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b,recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b);
				GameTooltip:AddDoubleLine("In: "..recap.Combatant[p].LastDmgIn,"In: "..recap.Combatant[p].TotalDmgIn,recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b,recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
				GameTooltip:AddDoubleLine("Out: "..recap.Combatant[p].LastDmgOut,"Out: "..recap.Combatant[p].TotalDmgOut,recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b,recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
				GameTooltip:AddDoubleLine("DPS: "..string.format("%.1f",recap.Combatant[p].LastDPS),"DPS: "..string.format("%.1f",recap.Combatant[p].TotalDPS),recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b,recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
			else
				GameTooltip:AddDoubleLine("Heals: "..recap.Combatant[p].LastHeal,"Heals: "..recap.Combatant[p].TotalHeal,r,g,b,r,g,b);
				GameTooltip:AddDoubleLine("In: "..recap.Combatant[p].LastDmgIn,"In: "..recap.Combatant[p].TotalDmgIn,r,g,b,r,g,b);
				GameTooltip:AddDoubleLine("Out: "..recap.Combatant[p].LastDmgOut,"Out: "..recap.Combatant[p].TotalDmgOut,r,g,b,r,g,b);
				GameTooltip:AddDoubleLine("DPS: "..string.format("%.1f",recap.Combatant[p].LastDPS),"DPS: "..string.format("%.1f",recap.Combatant[p].TotalDPS),r,g,b,r,g,b);
				if recap.Combatant[p].TotalKills>0 then
					GameTooltip:AddDoubleLine("Health/Death:",string.format("%d",recap.Combatant[p].TotalDmgIn/recap.Combatant[p].TotalKills),recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b,recap_temp.ColorNone.r,recap_temp.ColorNone.g,recap_temp.ColorNone.b);
				end
			end

			GameTooltip:Show();

		end
	end
end

function Recap_Totals_OnEnter()

	local r = recap_temp.ColorWhite.r;
	local g = recap_temp.ColorWhite.g;
	local b = recap_temp.ColorWhite.b;
	local other_kills = 0;

	if recap.Opt.ShowTooltips.value then

		if recap.Opt.TooltipFollow.value then
			GameTooltip:SetOwner(this,Recap_TooltipAnchor());
		else
			GameTooltip_SetDefaultAnchor(GameTooltip,this);
		end

		GameTooltip:AddLine("Totals for "..recap_temp.Local.LastAll[recap.Opt.View.value]);

		if recap_temp.ListSize>1 then

			for i=1,(recap_temp.ListSize-1) do
				if not recap.Combatant[recap_temp.List[i].Name].Friend then
					other_kills = other_kills + recap_temp.List[i].Kills;
				end
			end
			GameTooltip:AddDoubleLine("Combatants:",recap_temp.ListSize-1,r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Time Fighting:",Recap_FormatTime(recap_temp.List[recap_temp.ListSize].Time),r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Max Hit:",recap_temp.List[recap_temp.ListSize].MaxHit,r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Deaths:",recap_temp.List[recap_temp.ListSize].Kills,r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Kills:",other_kills,r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Heals:",recap_temp.List[recap_temp.ListSize].Heal,r,g,b,r,g,b);
			GameTooltip:AddDoubleLine("Damage In:",recap_temp.List[recap_temp.ListSize].DmgIn,recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b,recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
			GameTooltip:AddDoubleLine("DPS In:",string.format("%.1f",recap_temp.List[recap_temp.ListSize].DPSIn),recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b,recap_temp.ColorDmgIn.r,recap_temp.ColorDmgIn.g,recap_temp.ColorDmgIn.b);
			GameTooltip:AddDoubleLine("Damage Out:",recap_temp.List[recap_temp.ListSize].DmgOut,recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b,recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
			GameTooltip:AddDoubleLine("DPS Out:",string.format("%.1f",recap_temp.List[recap_temp.ListSize].DPSOut),recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b,recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
		else
			GameTooltip:AddLine("Combatants: none",r,g,b);
		end

		GameTooltip:Show();
	end
end

function Recap_EffectsHeader_OnEnter()

	local id = this:GetID();

	if id then
		Recap_OnTooltip("EffectsHeader"..id);
	end
end

function Recap_TooltipAnchor()

	local anchor = "ANCHOR_LEFT";

	if GetCursorPosition("UIParent")<(UIParent:GetWidth()/2) then
		anchor = "ANCHOR_RIGHT";
	end
	return anchor;
end

function Recap_Effects_OnEnter()

	local id = this:GetID();

	if id and id>0 and recap.Opt.ShowTooltips.value and recap.Opt.SelfView.value then
		index = id + FauxScrollFrame_GetOffset(RecapScrollBar);
		if (index<recap_temp.SelfListSize) then

			if recap.Opt.TooltipFollow.value then
				GameTooltip:SetOwner(this,Recap_TooltipAnchor());
			else
				GameTooltip_SetDefaultAnchor(GameTooltip,this);
			end

			if recap_temp.SelfList[index].Type<3 then
				GameTooltip:AddLine(string.sub(recap_temp.SelfList[index].Effect,2),recap_temp.ColorDmgOut.r,recap_temp.ColorDmgOut.g,recap_temp.ColorDmgOut.b);
				GameTooltip:AddLine("Damage: "..recap_temp.SelfList[index].Total.." ("..recap_temp.SelfList[index].Rate..")",recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);

			else
				GameTooltip:AddLine(string.sub(recap_temp.SelfList[index].Effect,2),recap_temp.ColorHeal.r,recap_temp.ColorHeal.g,recap_temp.ColorHeal.b);
				GameTooltip:AddLine("Heal: "..recap_temp.SelfList[index].Total.." ("..recap_temp.SelfList[index].Rate..")",recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
			end
			GameTooltip:AddLine("Hits: "..recap_temp.SelfList[index].Hits.." (Max "..recap_temp.SelfList[index].MaxHit..")",recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
			if recap_temp.SelfList[index].Crits~="-" then
				GameTooltip:AddLine("Crits: "..recap_temp.SelfList[index].Crits.." (Max "..recap_temp.SelfList[index].MaxCrit..")",recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
				GameTooltip:AddLine("Crit Rate: "..recap_temp.SelfList[index].CritRate,recap_temp.ColorWhite.r,recap_temp.ColorWhite.g,recap_temp.ColorWhite.b);
			end

			GameTooltip:Show();
		end
	end
end

--[[ Plug-in functions ]]

function Recap_GetIB_Tooltip()
	return recap_temp.Local.LastAll[recap.Opt.View.value]..":\nYour DPS: "..RecapMinYourDPS_Text:GetText().."\nMax hit: "..RecapTotals_MaxHit:GetText().."\nTotal DPS Out: "..RecapTotals_DPS:GetText().."\nTotal DPS In: "..RecapTotals_DPSIn:GetText();
end

function Recap_UpdatePlugins()

	local yourdps = RecapMinYourDPS_Text:GetText();
	local dpsin = RecapMinDPSIn_Text:GetText();
	local dpsout = RecapMinDPSOut_Text:GetText();
	
	if IB_Recap_Update then
		IB_Recap_Update("DPS: "..yourdps);
	end

	if TitanPanelRecap_Update then
		TitanPanelRecap_Update(recap.Opt.State.value,yourdps,dpsin,dpsout);
	end
end

--[[ Misc functions ]]

-- if this is a pet, pass owner's name to ownedby
function Recap_AddFriend(arg1,ownedby)

	if arg1 and arg~=UNKNOWNOBJECT and recap.Combatant[arg1] then
		recap.Combatant[arg1].Friend = true;
		if recap.Combatant[arg1] and ownedby then
			-- pet could potentially do damage without owner, add owner if so
			if not recap.Combatant[ownedby] then
				Recap_CreateBlankCombatant(ownedby);
				recap.Combatant[ownedby].Friend = true
			end
			if not recap_temp.Last[ownedby] then
				recap_temp.Last[ownedby] = { Start = 0, End = 0, DmgIn = 0, DmgOut = 0, MaxHit = 0, Kills = 0, Heal = 0 };
			end
			recap.Combatant[arg1].OwnedBy = ownedby;
			recap.Combatant[ownedby].OwnsPet = arg1;
		end
	end
end

function Recap_MakeFriends()

	local i,item,u;

	Recap_GetUnitInfo("player");
	Recap_AddFriend(recap_temp.Player);
	if UnitExists("pet") then
		Recap_GetUnitInfo("pet");
		Recap_AddFriend(UnitName("pet"),UnitName("player"));
	end
	for i=1,4 do
		if UnitExists("party"..i) then
			Recap_GetUnitInfo("party"..i);
			Recap_AddFriend(UnitName("party"..i));
			if UnitExists("partypet"..i) then
				Recap_GetUnitInfo("partypet"..i);
				Recap_AddFriend(UnitName("partypet"..i),UnitName("party"..i));
			end
		end
	end

	if (GetNumRaidMembers()>0) then
		for i=1,40 do
			item = getglobal("RaidGroupButton"..i.."Name"):GetText();
			if item then
				Recap_AddFriend(item);
			end
			if UnitExists("raid"..i) then
				Recap_GetUnitInfo("raid"..i);
				Recap_AddFriend(UnitName("raid"..i));
				if UnitExists("raidpet"..i) then
					Recap_GetUnitInfo("raidpet"..i);
					Recap_AddFriend(UnitName("raidpet"..i),UnitName("raid"..i));
				end
			end
		end
	end
end

-- returns a string of seconds converted to 0:00:00 format
function Recap_FormatTime(arg1)

	local hours, minutes, seconds;
	local text;

	seconds = math.floor(arg1+.5);
	hours = math.floor(seconds/3600);
	seconds = seconds - hours*3600;
	minutes = math.floor(seconds/60);
	seconds = seconds - minutes*60;

	text = "";
	if (hours>0) then text = text .. format("%d",hours) .. ":"; end
	text = text .. format("%02d",minutes) .. ":";
	text = text .. format("%02d",seconds);

	return text;
end

function Recap_SetClassIcon(id,class)
	if class and recap_temp.ClassIcons[class] then
		getglobal("RecapList"..id.."_Class"):SetTexCoord(recap_temp.ClassIcons[class].left,recap_temp.ClassIcons[class].right,recap_temp.ClassIcons[class].top,recap_temp.ClassIcons[class].bottom);
	else
		getglobal("RecapList"..id.."_Class"):SetTexCoord(.9,1,.9,1);
	end
end

function Recap_SetFactionIcon(id,faction)

	item = getglobal("RecapList"..id.."_Faction");

	if faction and recap_temp.FactionIcons[faction] then
		item:SetTexture(recap_temp.FactionIcons[faction]);
	else
		item:SetTexture("");
	end

end

function Recap_GetUnitInfo(unit)

	local u=UnitName(unit);

	if u then
		if recap.Combatant[u] then
			recap.Combatant[u].Class = UnitClass(unit);
			recap.Combatant[u].Faction = UnitFactionGroup(unit);
			if UnitCreatureFamily(unit) and recap.Combatant[u].Faction then
				recap.Combatant[u].Class = "Pet"
			end
		end
	end
end

-- creates a new .Combatant[arg1] that is a copy of DefaultCombatant
function Recap_CreateBlankCombatant(arg1)

	if not recap.Combatant[arg1] then
		recap.Combatant[arg1] = {};
		for i in recap_temp.DefaultCombatant do
			recap.Combatant[arg1][i] = recap_temp.DefaultCombatant[i];
		end
	end
end

-- populates .Opt with a copy of DefaultOpt
function Recap_LoadDefaultOpt()

	recap.Opt = {};
	for i in recap_temp.DefaultOpt do
		recap.Opt[i] = {};
		for j in recap_temp.DefaultOpt[i] do
			recap.Opt[i][j] = recap_temp.DefaultOpt[i][j];
		end
	end
end

function Recap_SaveOpt(user)

	if user and string.len(user)>0 then
		recap[user].Opt = {};
    	for i in recap.Opt do
			text = "";
			for j in recap.Opt[i] do
				text = text..tostring(j).."="..tostring(recap.Opt[i][j]).." ";
			end
			recap[user].Opt[i] = text;
		end
	end
end

function Recap_LoadOpt(user)

    if user and recap[user] and recap[user].Opt then
		for i in recap[user].Opt do
			for t,v in string.gfind(recap[user].Opt[i],"(%w+)=(%d-%--%w+) ") do
				if v=="true" then
					v = true;
				elseif v=="false" then
					v = false;
				elseif tonumber(v) then
					v = tonumber(v);
				end
				recap.Opt[i][t] = v;
			end
		end
	end
end

-- saves current data to data set "filen", overwrite~=nil to overwrite existing data
function Recap_SaveCombatants(filen,overwrite)

	if not filen or string.len(filen)<1 then
		return;
	end

	if not recap_set[filen] then
		recap_set[filen] = {};
		recap_set[filen].TimeStamp = date();
		recap_set[filen].TotalDuration = 0;
		recap_set[filen].Combatant = {};
	end

	if overwrite then
		recap_set[filen] = {};
		recap_set[filen].TimeStamp = date();
		recap_set[filen].TotalDuration = recap[recap_temp.p].TotalDuration;
		recap_set[filen].Combatant = {};
		for i in recap.Combatant do
			if (not recap.Opt.SaveFriends.value or recap.Combatant[i].Friend) and
			   (recap.Combatant[i].TotalDmgIn>0 or recap.Combatant[i].TotalDmgOut>0 or recap.Combatant[i].TotalHeal>0) then
				recap_set[filen].Combatant[i] = string.format("%s %d %d %d %d %d %.3f ~%d %d",
												tostring(recap.Combatant[i].Friend),
												recap.Combatant[i].TotalDmgIn,
												recap.Combatant[i].TotalDmgOut,
												recap.Combatant[i].TotalMaxHit,
												recap.Combatant[i].TotalHeal,
												recap.Combatant[i].TotalKills,
												recap.Combatant[i].TotalTime,
												Recap_MakeKey(recap.Combatant[i].Faction),
												Recap_MakeKey(recap.Combatant[i].Class));
			end
		end
	else
		recap_set[filen].TimeStamp = date();
		recap_set[filen].TotalDuration = recap_set[filen].TotalDuration + recap[recap_temp.p].TotalDuration;
		for i in recap.Combatant do
			if (not recap.Opt.SaveFriends.value or recap.Combatant[i].Friend) and
			   (recap.Combatant[i].TotalDmgIn>0 or recap.Combatant[i].TotalDmgOut>0 or recap.Combatant[i].TotalHeal>0) then
				if recap_set[filen].Combatant[i] then -- already exists
					found,_,set_friend,set_dmgin,set_dmgout,set_maxhit,set_heal,set_kills,set_time = string.find(recap_set[filen].Combatant[i],"(%w+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+%.?%d+)");
					if found then
						if recap.Combatant[i].Friend then
							set_friend = true;
						end
						set_dmgin = tonumber(set_dmgin) + recap.Combatant[i].TotalDmgIn;
						set_dmgout = tonumber(set_dmgout) + recap.Combatant[i].TotalDmgOut;
						set_heal = tonumber(set_heal) + recap.Combatant[i].TotalHeal;
						set_kills = tonumber(set_kills) + recap.Combatant[i].TotalKills;
						set_time = tonumber(set_time) + recap.Combatant[i].TotalTime;
						if recap.Combatant[i].TotalMaxHit > tonumber(set_maxhit) then
							set_maxhit = recap.Combatant[i].TotalMaxHit;
						end
						found,_,set_faction,set_class = string.find(recap_set[filen].Combatant[i],"~(%d+) (%d+)");
						if found then
							if not recap.Combatant[i].Faction then
								recap.Combatant[i].Faction = Recap_GetKey(set_faction);
							end
							if not recap.Combatant[i].Class then
								recap.Combatant[i].Class = Recap_GetKey(set_class);
							end
						end
						recap_set[filen].Combatant[i] = string.format("%s %d %d %d %d %d %.3f ~%d %d", tostring(set_friend),
								set_dmgin, set_dmgout, set_maxhit, set_heal, set_kills, set_time,
								Recap_MakeKey(recap.Combatant[i].Faction), Recap_MakeKey(recap.Combatant[i].Class))
					end
				else
					recap_set[filen].Combatant[i] = string.format("%s %d %d %d %d %d %.3f ~%d %d",
							tostring(recap.Combatant[i].Friend),
							recap.Combatant[i].TotalDmgIn,
							recap.Combatant[i].TotalDmgOut,
							recap.Combatant[i].TotalMaxHit,
							recap.Combatant[i].TotalHeal,
							recap.Combatant[i].TotalKills,
							recap.Combatant[i].TotalTime,
							Recap_MakeKey(recap.Combatant[i].Faction),
							Recap_MakeKey(recap.Combatant[i].Class));
				end
			end
		end
	end

	fight_count = 0;
	for i in recap_set[filen].Combatant do
		fight_count = fight_count + 1;
	end
	recap_set[filen].ListSize = fight_count;
end

function Recap_MakeKey(arg1)

	local key = 0;

	for i in recap_temp.Keys do
		if arg1==recap_temp.Keys[i] then
			key = i;
		end
	end
	return key;
end

function Recap_GetKey(arg1)

	local key = nil;

	if not arg1 or not tonumber(arg1) or arg1==0 then
		key=nil;
	else
		key=recap_temp.Keys[tonumber(arg1)]
	end
	return key;
end

function Recap_LoadCombatants(filen,overwrite)

	if not filen or string.len(filen)<1 or not recap_set[filen] then
		return;
	end

	if overwrite then
		Recap_ResetAllCombatants();
	end
	
	recap[recap_temp.p].TotalDuration = recap[recap_temp.p].TotalDuration + recap_set[filen].TotalDuration;
	
	for i in recap_set[filen].Combatant do
		if not recap.Combatant[i] then
			Recap_CreateBlankCombatant(i);
		end
		found,_,set_friend,set_dmgin,set_dmgout,set_maxhit,set_heal,set_kills,set_time = string.find(recap_set[filen].Combatant[i],"(%w+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+%.?%d+)");
		if found then
			if set_friend == "true" then
				recap.Combatant[i].Friend = true;
			end
			if tonumber(set_maxhit) > recap.Combatant[i].TotalMaxHit then
				recap.Combatant[i].TotalMaxHit = tonumber(set_maxhit);
			end
			recap.Combatant[i].TotalDmgIn = recap.Combatant[i].TotalDmgIn + tonumber(set_dmgin);
			recap.Combatant[i].TotalDmgOut = recap.Combatant[i].TotalDmgOut + tonumber(set_dmgout);
			recap.Combatant[i].TotalKills = recap.Combatant[i].TotalKills + tonumber(set_kills);
			recap.Combatant[i].TotalHeal = recap.Combatant[i].TotalHeal + tonumber(set_heal);
			recap.Combatant[i].TotalTime = recap.Combatant[i].TotalTime + tonumber(set_time);
			if recap.Combatant[i].TotalTime > recap_temp.MinTime then
				recap.Combatant[i].TotalDPS = recap.Combatant[i].TotalDmgOut/recap.Combatant[i].TotalTime;
			else
				recap.Combatant[i].TotalDPS = 0;
			end
		end

		found,_,set_faction,set_class = string.find(recap_set[filen].Combatant[i],"~(%d+) (%d+)");
		if found then
			recap.Combatant[i].Faction = Recap_GetKey(set_faction);
			recap.Combatant[i].Class = Recap_GetKey(set_class);
		end
	end

end

function Recap_ResetAllCombatants()

    local current_state = recap.Opt.State.value
	recap.Opt.State.value = "Stopped";

	recap.Combatant = {};
	recap_temp.IdleTimer = -1;
	recap_temp.Last = {};
	recap[recap_temp.p].LastDuration = 0;
	recap[recap_temp.p].TotalDuration = 0;
	recap_temp.FightStart = 0;
	recap_temp.FightEnd = 0;
	recap_temp.ListSize = 0;
	
	recap.Opt.State.value = current_state;
end

function Recap_InitializeData()

	local temp_user = recap_temp.p;

	if not recap.DataVersion then
		recap = {};
		recap.DataVersion = 2.6;
	end

	if not recap[recap_temp.p] then
		recap[recap_temp.p] = {};
		recap[recap_temp.p].TotalDuration = 0;
		recap[recap_temp.p].LastDuration = 0;
		recap[recap_temp.p].Self = { TotalDmg=0, TotalHeal=0, Effect={} };
	end

	if recap.User then
		recap_temp.p = recap.User;
		Recap_SaveCombatants("UserData:"..recap.User,1);
		Recap_SaveOpt(recap.User);
		recap_temp.p = temp_user;
	end
	recap.User = recap_temp.p
	
	Recap_LoadDefaultOpt();
	Recap_ResetAllCombatants();
	Recap_LoadCombatants("UserData:"..recap_temp.p,1);
	Recap_LoadOpt(recap_temp.p);

end

--[[ Context menu functions ]]

function Recap_CreateMenu(name,addfriend)

	recap_temp.SelectedName = name;
	recap_temp.SelectedAdd = addfriend;

	if addfriend then
		RecapMenu1_Text:SetText(recap_temp.Local.ListMenu.Add[1]);
	else
		RecapMenu1_Text:SetText(recap_temp.Local.ListMenu.Drop[1]);
	end
	RecapMenu2_Text:SetText(recap_temp.Local.ListMenu.Reset[1]);
	RecapMenu3_Text:SetText(recap_temp.Local.ListMenu.Ignore[1]);
	Recap_ContextMenu:ClearAllPoints();
	x,y = GetCursorPosition();
	Recap_ContextMenu:SetPoint("TOPRIGHT","UIParent","BOTTOMLEFT",(x/UIParent:GetScale())+20,(y/UIParent:GetScale())+8);
	Recap_ContextMenu:Show();
end

function RecapMenu_OnClick()

	id = this:GetID();

	response = getglobal("RecapMenu"..id.."_Text"):GetText();
	Recap_ContextMenu:Hide();

	if id==1 and recap_temp.SelectedName~=recap_temp.Player then
		recap.Combatant[recap_temp.SelectedName].Friend = not recap.Combatant[recap_temp.SelectedName].Friend;
	elseif id==2 and recap.Opt.View.value=="All" then
		recap.Combatant[recap_temp.SelectedName] = nil;
		Recap_CreateBlankCombatant(recap_temp.SelectedName);
		recap.Combatant[recap_temp.SelectedName].Friend = not recap_temp.SelectedAdd;
	elseif id==2 and recap.Opt.View.value=="Last" then
		if recap.Combatant[recap_temp.SelectedName].WasInLast then
			Recap_ResetLastFight(recap_temp.SelectedName)				
		end
	elseif id==3 and recap_temp.SelectedName~=recap_temp.Player then
		recap.Combatant[recap_temp.SelectedName] = nil;
		Recap_CreateBlankCombatant(recap_temp.SelectedName);
		recap.Combatant[recap_temp.SelectedName].Ignore = true;
	end

	Recap_SetView();
end

function RecapMenu_OnUpdate(arg1)

	if not recap_temp.MenuTimer or MouseIsOver(Recap_ContextMenu) then
		recap_temp.MenuTimer = 0;
	end

	recap_temp.MenuTimer = recap_temp.MenuTimer + arg1;
	if recap_temp.MenuTimer > .25 then
		recap_temp.MenuTimer = 0;
		Recap_ContextMenu:Hide();
	end
end

function RecapMenu_OnEnter()

	id = this:GetID();

	if recap_temp.SelectedName then
		if id==1 and recap_temp.SelectedAdd then
			id = "Add";
		elseif id==1 then
			id = "Drop";
		elseif id==2 then
			id = "Reset";
		elseif id==3 then
			id = "Ignore";
		end
		Recap_Tooltip(string.format(recap_temp.Local.ListMenu[id][2],recap_temp.SelectedName),string.format(recap_temp.Local.ListMenu[id][3],recap_temp.SelectedName));
	end
end

--[[ Fight report functions ]]

function Recap_AutoPostGetStatID(arg1)

	if arg1=="Damage" then
		return "DmgOut";
	elseif arg1=="Tanking" then
		return "DmgIn";
	elseif arg1=="Healing" then
		return "Heal";
	end
	return "DPS";
end

function Recap_PostFight()

	local print_chat = SendChatMessage;
	local chatchan, chatnum, text;

	if recap.Opt.SpamRows.value then
		Recap_PostSpamRows(Recap_AutoPostGetStatID(recap.Opt.AutoPost.Stat),"recap auto");
	else
		chatchan = recap.Opt.AutoPost.Channel;
		_,_,chatnum = string.find(chatchan,"(%d+)");
		if chatnum then
			chatchan = "CHANNEL";
		end
		if chatchan=="Self" then
			print_chat = Recap_Print;
		end
		text = Recap_PostSpamLine(Recap_AutoPostGetStatID(recap.Opt.AutoPost.Stat));
		if string.find(text,"%d") then
			print_chat(Recap_PostSpamLine(Recap_AutoPostGetStatID(recap.Opt.AutoPost.Stat)),chatchan,nil,chatnum);
		end
	end

end

-- returns 'text' to be spammed in autopost or linked in chat
function Recap_PostSpamLine(arg1)

	local text,i;

	text = recap_temp.Local.LinkRank[arg1].." for "..recap_temp.Local.LastAll[recap.Opt.View.value]..":";
	for i=1,recap.Opt.MaxRank.value do
		if i<recap_temp.ListSize and recap.Combatant[recap_temp.List[i].Name].Friend then
			if recap_temp.List[i][arg1]>0 then
				text = text.." ["..i.."."..recap_temp.List[i].Name.." ";
				if arg1=="DPS" then
					text = text..string.format("%.1f",recap_temp.List[i][arg1]).."]";
				elseif arg1=="Time" then
					text = text..Recap_FormatTime(recap_temp.List[i][arg1]).."]";
				elseif arg1=="HealP" or arg1=="DmgInP" or arg1=="DmgOutP" then
					text = text..recap_temp.List[i][arg1].."%]";
				elseif arg1=="Heal" or arg1=="DmgIn" or arg1=="DmgOut" then
					text = text..recap_temp.List[i][arg1].." "..recap_temp.List[i][arg1.."P"].."%]";
				else
					text = text..recap_temp.List[i][arg1].."]";
				end
			end
		end
	end
	return text;
end

-- arg1 = stat to report by (DPS, DmgOut, etc)
function Recap_PostSpamRows(arg1,chatchan,chatnum)

	local headertext = nil;
	local print_chat = SendChatMessage;

	if chatchan=="recap auto" then
		chatchan = recap.Opt.AutoPost.Channel;
	end

	arg1 = string.gsub(arg1,"P$",""); -- strip trailing P from % id's

	if not chatnum then
		_,_,chatnum = string.find(chatchan,"(%d+)");
		if chatnum then
			chatchan = "CHANNEL";
		end
	end
	if chatchan=="Self" then
		print_chat = Recap_Print;
	end
	headertext = "__ "..recap_temp.Local.LinkRank[arg1].." for "..recap_temp.Local.LastAll[recap.Opt.View.value].." __";
	for i=1,recap.Opt.MaxRank.value do
		if i<recap_temp.ListSize and recap.Combatant[recap_temp.List[i].Name].Friend then
			text = i..". "..recap_temp.List[i].Name..": ";
			if arg1=="DPS" then
				text = text..string.format("%.1f",recap_temp.List[i].DPS);
			elseif arg1=="Time" then
				text = text..Recap_FormatTime(recap_temp.List[i][arg1]);
			elseif arg1=="DmgOut" then
				text = text..recap_temp.List[i].DmgOut.." ("..recap_temp.List[i].DmgOutP.."%)";
			elseif arg1=="DmgIn" then
				text = text..recap_temp.List[i].DmgIn.." ("..recap_temp.List[i].DmgInP.."%)";
			elseif arg1=="Heal" then
				text = text..recap_temp.List[i].Heal.." ("..recap_temp.List[i].HealP.."%)";
			else
				text = text..recap_temp.List[i][arg1];
			end
			if recap_temp.List[i][arg1] > 0 then
				if headertext then
					print_chat(headertext,chatchan,nil,chatnum);
					headertext = nil;
				end
				print_chat(text,chatchan,nil,chatnum);
			end
		end
	end
end

function Recap_Print(arg1)
	DEFAULT_CHAT_FRAME:AddMessage(tostring(arg1));
end


