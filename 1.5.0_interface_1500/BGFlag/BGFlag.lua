--[[ Flisher mod are:
changed the onmouse call in the xml file
added keybinding to targetting ennemy/friendly
removed the onmouse function horde/alliance, replaced by a BGFlag_target, detail are in the function.
Replaced the relxy by a single varialble.  Important ntoe, there is a way to remove the use of code to save location, I'll investigate this next week, this is a new api feature, i dont remember the name.

I didn't perform a big variable revamp, but placing stuff in an array allow to diagnose easily by using myDebug and askign a display if the "BGFlag"

I didn't tested it as i'm not on a wow-enabled computer, there might be syntax error, but you get some improvement here.


]]--


--Version 2.0
local LightBlue			= "|c0033CCFF"; --Light Blue Text
local Green				= "|c0033FF66"; --Greenish Text
local BGFlag_Enabled		= true;
local HasHordeFlag			= BGFLAG_STATUS_ATBASE;
local HasAllianceFlag		= BGFLAG_STATUS_ATBASE;
local BGFlag_MiniEnabled		= false;
local BGFlag_IsLocked		= true;
local MainFrameHeight		= 0;
BGFlagConfig =
{ RelXPos			= WorldStateAlwaysUpFrame:GetLeft();
  RelYPos			= WorldStateAlwaysUpFrame:GetTop();
}

function BGFlag_OnLoad()
	SlashCmdList["BGFlag"] = BGFlag_SlashHandler;
	SLASH_BGFlag1 = "/bgflag"
	this:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	--this:RegisterEvent("CHAT_MSG_SAY");
	this:RegisterEvent("VARIABLES_LOADED");	
end

function BGFlag_OnUpdate()
	if (WorldStateAlwaysUpFrame.isMoving) then
		BGFlag:StartMoving();
		BGFlag.isMoving = true;
	elseif (not WorldStateAlwaysUpFrame.isMoving and BGFlag.isMoving) then
		BGFlag_StopMovingOrSizing();
	end
end

function BGFlag_RCChat(text)
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(LightBlue..text);
	end
end

function BGFlag_StartDrag()
	if (BGFlag_MiniEnabled and not BGFlag_IsLocked) then
	frame = getglobal("WorldStateAlwaysUpFrame");
	frame2 = getglobal("BGFlag");
	frame.isLocked = 0;
	frame2.isLocked = 0;
	frame:SetMovable(1);
	frame2:SetMovable(1);
	if (arg1 == "LeftButton") then
		frame:StartMoving();
		frame2:StartMoving();
		frame.isMoving = true;
		frame2.isMoving = true;
	end
	end
end
function BGFlag_StopDrag()
	frame = getglobal("WorldStateAlwaysUpFrame");
	frame2 = getglobal("BGFlag");
	if (frame.isMoving and frame2.isMoving) then
		frame:StopMovingOrSizing();
		frame.isMoving = false;
		frame2:StopMovingOrSizing();
		frame2.isMoving = false;
	end
	frame:SetMovable(0);
	frame2:SetMovable(0);
	BGFlag_GetPositions();
end

function BGFlag_SlashHandler(text)
	if (strlower(text) == "disable") then
		BGFlag_disable();
	elseif (strlower(text) == "enable") then
		BGFlag_Enabled = true;
		BGFlag_RCChat("BGFlag enabled...")
	elseif (strlower(text) == "clear") then
		BGFlag_clear();
	elseif (strlower(text) == "reset") then
		WorldStateAlwaysUpFrame:ClearAllPoints();
		WorldStateAlwaysUpFrame:SetPoint("TOP", "UIParent", "TOP", -5, -15);
		WorldStateAlwaysUpFrame:StopMovingOrSizing();
		BGFlag:StopMovingOrSizing();
		BGFlag_GetPositions();
	--for debug purposes mostly
	elseif (strlower(text) == "testdrag") then
		if (BGFlag_MiniEnabled) then
			BGFlag_MiniEnabled = false;
			WorldStateAlwaysUpFrame:Hide();
			AlwaysUpFrame1:Hide();
			AlwaysUpFrame2:Hide();
			AlwaysUpFrame1Text:SetText("");
			AlwaysUpFrame2Text:SetText("");
			getglobal("BGFlag"):Hide();
		else
			BGFlag_MiniEnabled = true;
			WorldStateAlwaysUpFrame:Show();
			AlwaysUpFrame1:Show();
			AlwaysUpFrame2:Show();
			AlwaysUpFrame1Text:SetText("0/3");
			AlwaysUpFrame2Text:SetText("0/3");
			getglobal("BGFlag"):Show();
			BGFlagAlliance:SetText("Thamos");
			BGFlagHorde:SetText("Grull Hawkwind");
		end

		
		BGFlag_RCChat("Testing, unlocked or locked for BG");
	--also for debug
	elseif (strlower(text) == "vars") then
		BGFlag_RCChat(BGFLAG_STATUS_PICKED.." "..BGFLAG_STATUS_DROPPED.." "..BGFLAG_STATUS_CAPTURED.." "..BGFLAG_STATUS_WIN.." "..BGFLAG_STATUS_RETURNED.." "..BGFLAG_STATUS_FACTION_HORDE.." "..BGFLAG_STATUS_FACTION_ALLIANCE.." "..BGFLAG_STATUS_ATBASE)
	elseif (strlower(text) == "lock") then
		BGFlag_IsLocked = true;
		BGFlagButtonAnchor:Hide();
		BGFlag_RCChat("Frame is locked...");
	elseif (strlower(text) == "unlock") then
		BGFlag_IsLocked = false;
		BGFlagButtonAnchor:Show();
		BGFlag_RCChat("Frame is movable...");
	elseif (strlower(text) == "help" or strlower(text) == "" or strlower(text) ~= "" ) then
		BGFlag_help();
	
	end
end



function BGFlag_OnEvent()
	if (event == "PLAYER_ENTERING_WORLD") then
		if (GetNumWorldStateUI() == 0) then
			BGFlag_MiniEnabled = false;
			BGFlag_clear();
			getglobal("BGFlag"):Hide();

		else
			BGFlag_MiniEnabled = true;
			getglobal("BGFlag"):Show();
			
			--test to see if the flags already have statuses, eg if joined in the middle of the game	
			atext, aicon, aisFlashing, adynamicIcon, atooltip, adynamicTooltip = GetWorldStateUIInfo(1);
			
			if (aisFlashing) then
				aisFlashing = "true";
			else
				aisFlashing = "false";
			end
			DEFAULT_CHAT_FRAME:AddMessage(atext.." "..aicon.." "..aisFlashing.." "..adynamicIcon.." "..atooltip.." "..adynamicTooltip)
			
			if ( strfind(adynamicTooltip, BGFLAG_STATUS_FACTION_HORDE) and ( strfind(adynamicTooltip, BGFLAG_STATUS_PICKED) or strfind(adynamicTooltip, BGFLAG_STATUS_DROPPED) ) ) then
				HasHordeFlag = BGFLAG_STATUS_UNKNOWN;
			else
				HasHordeFlag = BGFLAG_STATUS_ATBASE;
			end
			htext, hicon, hisFlashing, hdynamicIcon, htooltip, hdynamicTooltip = GetWorldStateUIInfo(2);
			
			if (hisFlashing) then
				hisFlashing = "true";
			else
				hisFlashing = "false";
			end
			DEFAULT_CHAT_FRAME:AddMessage(htext.." "..hicon.." "..hisFlashing.." "..hdynamicIcon.." "..htooltip.." "..hdynamicTooltip)
			
			if ( strfind(hdynamicTooltip, BGFLAG_STATUS_FACTION_ALLIANCE) and ( strfind(hdynamicTooltip, BGFLAG_STATUS_PICKED) or strfind(hdynamicTooltip, BGFLAG_STATUS_DROPPED) ) ) then
				HasAllianceFlag = BGFLAG_STATUS_UNKNOWN;
			else
				HasAllianceFlag = BGFLAG_STATUS_ATBASE;
			end
			
			
			BGFlag_UpdateFrame();

		end
	elseif (event == "VARIABLES_LOADED") then		
		--set frame position
		WorldStateAlwaysUpFrame:ClearAllPoints();
		WorldStateAlwaysUpFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", BGFlagConfig.RelXPos, BGFlagConfig.RelYPos - UIParent:GetHeight() );
		WorldStateAlwaysUpFrame:StopMovingOrSizing();
		BGFlag:StopMovingOrSizing();
	elseif (event == "CHAT_MSG_MONSTER_YELL" and BGFlag_Enabled == true and BGFlag_MiniEnabled == true) then
		if (arg2 == BGFLAG_HERALD) then
			BGFlag_WhoHasFlag(arg1);
			BGFlag_UpdateFrame();
		end
	
	
	--[[
	--used as a Debugging since getting into the instance is tedious
	elseif (event == "CHAT_MSG_SAY") then
		if (arg2 == "Asthmo") then
			BGFlag_RCChat(arg1);
			BGFlag_WhoHasFlag(arg1);
			BGFlag_UpdateFrame();
		end
	]]

	end
	
			
end

function BGFlag_help()
	BGFlag_RCChat("\nCommands:\n" ..Green.. "/bgflag disable" ..LightBlue.. BGFLAG_HELP_DISABLE ..Green.. "/bgflag enable" ..LightBlue.. BGFLAG_HELP_ENABLE ..Green.. "/bgflag clear" ..LightBlue.. BGFLAG_HELP_CLEAR..Green.."/bgflag lock" .. LightBlue.. BGFLAG_HELP_LOCK .. Green.. "/bgflag unlock" .. LightBlue .. BGFLAG_HELP_UNLOCK .. Green .. "/bgflag reset" .. LightBlue .. BGFLAG_HELP_RESET)
end

function BGFlag_WhoHasFlag(text)
	local player
	local faction
	local flagStatus
	local strlength
	local index
	
	--first get flag status
	--flagStatus will be picked, captured, wins, returned, Dropped
	index = strfind(text, BGFLAG_STATUS_PICKED)
	if (index) then
		flagStatus = strlower(BGFLAG_STATUS_PICKED)
	end
	index = strfind(text, BGFLAG_STATUS_CAPTURED);
	if (index) then
		flagStatus = strlower(BGFLAG_STATUS_CAPTURED);
	end
	index = strfind(text, BGFLAG_STATUS_WIN)
	if (index) then
		flagStatus = strlower(BGFLAG_STATUS_WIN);
	end
	index = strfind(text, BGFLAG_STATUS_RETURNED)
	if (index) then
		flagStatus = strlower(BGFLAG_STATUS_RETURNED);
	end
	index = strfind(text, strlower(BGFLAG_STATUS_DROPPED) )
	if (index) then
		flagStatus = strlower(BGFLAG_STATUS_DROPPED);
	end
	

	--now get the faction if one of those words were found, except captured
	if (flagStatus and flagStatus ~= strlower(BGFLAG_STATUS_CAPTURED) ) then 
		--faction is going to be Alliance or Horde
		index = strfind(text, BGFLAG_STATUS_FACTION_HORDE);
		if ( index ) then
			faction = BGFLAG_STATUS_FACTION_HORDE;
		else
			faction = BGFLAG_STATUS_FACTION_ALLIANCE;
		end
		strlength = strlen(text)
	end
	--if the status is Captured
	if (flagStatus and flagStatus == strlower(BGFLAG_STATUS_CAPTURED) ) then
		--faction is going to be Alliance or Horde
		index = strfind(text, BGFLAG_STATUS_FACTION_HORDE);
		if ( index ) then
			faction = BGFLAG_STATUS_FACTION_HORDE;
		else
			faction = BGFLAG_STATUS_FACTION_ALLIANCE;
		end
	end

	--get the player who has the flag, only if the status is picked
	if (flagStatus == strlower(BGFLAG_STATUS_PICKED) ) then
		--to be added for localization
		if ( GetLocale() == "frFR") then
			index = strfind(text, " par ");
			if (index) then
				player = strsub(text, index+5, strlength-1);
			end
		elseif ( GetLocale() == "deDE") then
		--more stuff
		else
			index = strfind(text, " by ")
			if (index) then
				player = strsub(text, index+4, strlength-1);
			end
		end
	end
	
	--if the flagged is dropped, make it say that it's dropped
	if (flagStatus == strlower(BGFLAG_STATUS_DROPPED) ) then
		player = BGFLAG_STATUS_DROPPED;
	end
	
	--if the flag is captured or returned, make it say "At Base"
	if (flagStatus == BGFLAG_STATUS_CAPTURED or flagStatus == BGFLAG_STATUS_RETURNED or flagStatus == nil or flagStatus == "") then
		player = BGFLAG_STATUS_ATBASE;
	end
	if (faction == BGFLAG_STATUS_FACTION_ALLIANCE) then
		HasAllianceFlag = player;
	elseif (faction == BGFLAG_STATUS_FACTION_HORDE) then
		HasHordeFlag = player;
	end
	if (flagStatus == BGFLAG_STATUS_WIN) then
		BGFlag_HideFrame()
	end
end

function BGFlag_UpdateFrame()
	getglobal("BGFlagHorde"):SetText(HasHordeFlag)
	getglobal("BGFlagAlliance"):SetText(HasAllianceFlag)
end

function BGFlag_HideFrame()
	HasHordeFlag = ""
	HasAllianceFlag = ""
end

function BGFlag_disable()
	BGFlag_clear();
	BGFlag_Enabled = false;
	getglobal("BGFlag"):Hide();
end

function BGFlag_clear()
	BGFlag_HideFrame();
	BGFlag_UpdateFrame();
end

function BGFlag_GetPositions()
	BGFlagConfig.RelXPos = WorldStateAlwaysUpFrame:GetLeft();
	BGFlagConfig.RelYPos = WorldStateAlwaysUpFrame:GetTop();
end

function BGFlag_target(input)
	--if (not this) then
	--BGFlag_RCChat("No this");
	--else

	-- input: horde flagbearer=false, alliance flagbearer=true
	if (input) then
		BGFlag.target = getglobal("BGFlagAlliance"):GetText();
	else
		BGFlag.target = getglobal("BGFlagHorde"):GetText();
	end

	-- Keep the current target name
	BGFlag.oldtarget = UnitName("target");		-- Required until patch 1.6 where there will be an efficient FoE last target

	-- Get the current Flag carrier name
	if (BGFlag.target ~= BGFLAG_STATUS_DROPPED and BGFlag.target ~= BGFLAG_STATUS_ATBASE and BGFlag.target ~= nil and BGFlag.target ~= "") then
		TargetByName(BGFlag.target);
	end

	-- Checking if the targe was acquired
	if (BGFlag.target ~= UnitName("target") ) then
		-- Check if we had something targeted before
		if (BGFlag.oldtarget) then
			-- Retarget the old target
			TargetByName(BGFlag.oldtarget);
			-- Clear the target if the old isn't available
			if (BGFlag.oldtarget ~= UnitName("target") ) then
				ClearTarget();
			end
		else
			-- Had no target, clearing it.
			ClearTarget();
		end
	end
	--end
end

