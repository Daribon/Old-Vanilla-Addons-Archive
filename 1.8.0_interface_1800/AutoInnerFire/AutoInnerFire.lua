--[[
	AutoInnerFire 1.33
	base by Gello
	mod by deto
		
	This mod piggyback's the movement keys to automatically
	cast the best rank of Inner Fire if you are a priest, you
	do not have the buff, you are not on a mount, you are not using
	Mind Control or you are in combat, and your mana is above a certain
	percentage threshold.
		
	Help:
		Configurate with /autoinnerfire or /aif
		- on (enables AutoInnerFire)
		- off (disables AutoInnerFire)
		- threshold (mana threshold)
		- combat (toggles buff in combat)
		- button (toggles minimap button)
		- position (changes minimap Button position)
		- options (options frame)
		
		Examples:
		/autoinnerfire on (aktivate AutoInnerFire)
		/autoinnerfire off (deaktivate AutoInnerFire)
		/aif threshold 50 (change the mana threshold to 50%)
		
		
	Authors:	
		- Gello (AutoInnerFire 1.0)
		- Hyjal (AutoInnerFire 1.1)
		- deto (AutoInnerFire 1.2x & 1.3x) - www.mydeto.de
		
	ToDo 1.4
		- don't know ^^
		
	Revision 1.33 (by deto)
		- added check to make sure you are not having 'inner focus'
		
	Revision 1.32 (by deto)
		- added check to make sure you are not having 'spirit tap'
		- disabled the addon for non-priests
		
	Revision 1.31 (by deto)
		- fixed a bug in the save profile routine
		- support for UltimateUI UI & CT_Mod
		
	Revision 1.3 (by deto)
		- Localization some texts to FR - thx to Fue of the curse-gaming comments
		- added minimap button
		- added configuration menu
		- added the other movement keys for the buff
		- added feature - buff in combat on/off
		- also added autowalk as buffmethod
		
	Revision 1.22 (by deto)
		- bugfix at the slash events
		- colored the help msgs
		- updated the .toc file
		
	Revision 1.21 (by deto)
		- some changes at the slash events
		- changed the 'mymana' check (ceil(); instead of round();)
		- updated the .toc file
		
	Revision 1.2 (by deto)
		- Slash Commands
		- Help File
		- Localization (EN & DE)
		- Profiling
		
	Revision 1.1 (by Hyjal)
		- Added check to make sure that mana is above a certain percentage threshold.
		- Added check to make sure you are not using Mind Control.
		
	Revsion 1.0 (by Gello)
		- first release
		- mother addon
		
	Thanks to...
		... myBank Team (for some great functions)
		... myClock Team (for the configmenu template)
		... Atlas Team (for the Minimap-Button templat)
		... Gello (for AutoInnerFire 1.0)
		... Hyjal (for AutoInnerFire 1.1)
		... wowwiki.com (for some help)
		... EasyPriest-Team (for the frence 'Inner Fire' name ^^)
		... Fue of the curse-gaming comments (for the frence localization)
]]

--------------------------------------------------------------------------------------------------
-- Default Settings & Vars
--------------------------------------------------------------------------------------------------
AutoInnerFireProfile = {}
local PlayerName = nil; -- Logged in player name

old_MoveForwardStart = nil;
old_MoveBackwardStart = nil;
old_StrafeRightStart = nil;
old_StrafeLeftStart = nil;
old_ToggleAutoRun = nil;

AutoInnerFire = 1;
AutoInnerFireThreshold = 20;
AutoInnerFireCombat = 0;
AutoInnerFireButtonShown = 1;
AutoInnerFireButtonPosition = 325;

local playerClass, englishClass = UnitClass("player");


--------------------------------------------------------------------------------------------------
-- Useful functions
--------------------------------------------------------------------------------------------------
function AutoInnerFire_Trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"));
end

function AutoInnerFire_SaveVar(varname, value)
	if ( PlayerName ) then
		if ( AutoInnerFireProfile[PlayerName] ) then
			AutoInnerFireProfile[PlayerName][varname] = value;
		end
	end
end



--------------------------------------------------------------------------------------------------
-- Initialize functions
--------------------------------------------------------------------------------------------------
-- If Player's profile is not found, it makes a new one from defaults
-- If Player's profile is found, it loads the values from AutoInnerFireProfile
function AutoInnerFire_InitializeProfile()
	if ( UnitName("player") ) then
		PlayerName = UnitName("player").."|"..AutoInnerFire_Trim(GetCVar("realmName"));
		AutoInnerFire_LoadSettings();
	end
end

function AutoInnerFire_LoadSettings()
	if englishClass == "PRIEST" then
		if ( AutoInnerFireProfile[PlayerName] == nil ) then
			AutoInnerFireProfile[PlayerName] = {};
			AutoInnerFireProfile[PlayerName]["AutoInnerFire"] = 1;
			AutoInnerFireProfile[PlayerName]["AutoInnerFireThreshold"] = 20;
			AutoInnerFireProfile[PlayerName]["AutoInnerFireCombat"] = 0;
			AutoInnerFireProfile[PlayerName]["AutoInnerFireButtonShown"] = 1;
			AutoInnerFireProfile[PlayerName]["AutoInnerFireButtonPosition"] = 325;
			
			-- DEFAULT_CHAT_FRAME:AddMessage(AIF_PROFILE_CREATING..PlayerName);
		else
			AutoInnerFire = AutoInnerFireProfile[PlayerName]["AutoInnerFire"];
			AutoInnerFireThreshold = AutoInnerFireProfile[PlayerName]["AutoInnerFireThreshold"];
			AutoInnerFireCombat = AutoInnerFireProfile[PlayerName]["AutoInnerFireCombat"];
			AutoInnerFireButtonShown = AutoInnerFireProfile[PlayerName]["AutoInnerFireButtonShown"];
			AutoInnerFireButtonPosition = AutoInnerFireProfile[PlayerName]["AutoInnerFireButtonPosition"];
			
			-- DEFAULT_CHAT_FRAME:AddMessage(AIF_PROFILE_LOADED_1..PlayerName..AIF_PROFILE_LOADED_2);
		end
	else
		AutoInnerFire = 0;
		AutoInnerFireThreshold = 101;
		AutoInnerFireCombat = 0;
		AutoInnerFireButtonShown = 0;
		AutoInnerFireButtonPosition = 325;
		
		-- DEFAULT_CHAT_FRAME:AddMessage(AIF_DISABLED);
	end
end

function AutoInnerFire_SavedOrDefault(varname)
	if PlayerName == nil or varname == nil then
		return nil;
	end
	if AutoInnerFireProfile[PlayerName][varname] == nil then -- Setting not set
		AutoInnerFireProfile[PlayerName][varname] = getglobal(varname); -- Load Default
	end
	return AutoInnerFireProfile[PlayerName][varname];  -- Return Setting.
end


--------------------------------------------------------------------------------------------------
-- Event functions
--------------------------------------------------------------------------------------------------
-- OnLoad
function AutoInnerFireFrame_OnLoad()
	if englishClass == "PRIEST" then
		-- register Slash Commands
		AutoInnerFire_Register();
		
		-- Movement Variable
		old_MoveForwardStart = MoveForwardStart;
		MoveForwardStart = new_MoveForwardStart;
		
		old_MoveBackwardStart = MoveBackwardStart;
		MoveBackwardStart = new_MoveBackwardStart;
		
		old_StrafeRightStart = StrafeRightStart;
		StrafeRightStart = new_StrafeRightStart;
		
		old_StrafeLeftStart = StrafeLeftStart;
		StrafeLeftStart = new_StrafeLeftStart;
		
		old_ToggleAutoRun = ToggleAutoRun;
		ToggleAutoRun = new_ToggleAutoRun;
	end	
	
	-- Vars Loaded
	this:RegisterEvent("VARIABLES_LOADED");
		
	-- Loaded Output
	-- DEFAULT_CHAT_FRAME:AddMessage(AIF_LOADED);
end

-- Register
function AutoInnerFire_Register()
	SlashCmdList["AIFSLASH"] = AutoInnerFire_SlashCommandHandler;
	SLASH_AIFSLASH1 = "/autoinnerfire";
	SLASH_AIFSLASH2 = "/aif";
end

-- OnEvent
function AutoInnerFire_OnEvent()
	if( event == "VARIABLES_LOADED" ) then
		if englishClass == "PRIEST" then
			---------------------
			-- support for myAddons
			---------------------
			if(myAddOnsFrame) then
				myAddOnsList.AutoInnerFire = {
					name = AIF_MYADDONS_NAME,
					description = AIF_MYADDONS_DESCRIPTION,
					version = AIF_SHORTVERSION,
					category = MYADDONS_CATEGORY_CLASS,
					frame = "AutoInnerFireFrame",
					optionsframe = "AutoInnerFireOptionsFrame"
				};
			end
			
			---------------------
			-- support for UltimateUI
			---------------------
			if(EarthFeature_AddButton) then
				EarthFeature_AddButton(
				{
					id = AIF_MYADDONS_NAME;
					name = AIF_MYADDONS_NAME;
					subtext = AIF_MYADDONS_DESCRIPTION;
					tooltip = AIF_MYADDONS_DESCRIPTION;
					icon = "Interface\\Icons\\Spell_Holy_InnerFire";
					callback = AutoInnerFireOptionsFrame_Toggle;
					test = nil;
				}
			);
			elseif(UltimateUI_RegisterButton) then
				UltimateUI_RegisterButton(
					AIF_MYADDONS_NAME,
					AIF_MYADDONS_DESCRIPTION,
					AIF_MYADDONS_DESCRIPTION,
					"Interface\\Icons\\Spell_Holy_InnerFire",
					AutoInnerFireOptionsFrame_Toggle
				);
			end
			
			--------------------
			-- support for CTMod
			--------------------
			if(CT_RegisterMod) then
				CT_RegisterMod(
					AIF_MYADDONS_NAME,
					AIF_MYADDONS_DESCRIPTION,
					5,
					"Interface\\Icons\\Spell_Holy_InnerFire",
					AIF_MYADDONS_DESCRIPTION,
					"switch",
					"",
					AutoInnerFireOptionsFrame_Toggle
				);
			end
		end
		
		AutoInnerFire_InitializeProfile();
		AutoInnerFireButton_Init();
		AutoInnerFireButton_UpdatePosition();
	end
end


--------------------------------------------------------------------------------------------------
-- Slash functions
--------------------------------------------------------------------------------------------------
function AutoInnerFire_SlashCommandHandler(msg)
	if ( (not msg) or (strlen(msg) <= 0) ) then
		ShowUIPanel(AutoInnerFireOptionsFrame);
		return
	end
	
	local commandName, params = AutoInnerFire_Extract_NextParameter(msg);
	
	if ( (commandName) and (strlen(commandName) > 0) ) then
		commandName = string.lower(msg);
	else
		commandName = "";
	end
	
	if( commandName == "on" ) then
		AutoInnerFire = 1;
		AutoInnerFire_SaveVar("AutoInnerFire", 1);
		AutoInnerFireOptionsFrame_Update();
		DEFAULT_CHAT_FRAME:AddMessage(AIF_ON);
	elseif( commandName == "off" ) then
		AutoInnerFire = 0;
		AutoInnerFire_SaveVar("AutoInnerFire", 0);
		AutoInnerFireOptionsFrame_Update();
		DEFAULT_CHAT_FRAME:AddMessage(AIF_OFF);
	elseif( commandName == "combat") then
		if(AutoInnerFireCombat == 1) then
			AutoInnerFireCombat = nil;
			AutoInnerFire_SaveVar("AutoInnerFireCombat", 0);
			DEFAULT_CHAT_FRAME:AddMessage(AIF_COMBAT_OFF);
		elseif(AutoInnerFireCombat == nil) then
			AutoInnerFireCombat = 1;
			AutoInnerFire_SaveVar("AutoInnerFireCombat", 1);
			DEFAULT_CHAT_FRAME:AddMessage(AIF_COMBAT_ON);
		end
		AutoInnerFireOptionsFrame_Update();
	elseif( commandName == "button" ) then
		if(AutoInnerFireButtonFrame:IsVisible()) then
			DEFAULT_CHAT_FRAME:AddMessage(AIF_BUTTON_OFF);
			AutoInnerFire_SaveVar("AutoInnerFireButtonShown", 0);
		else
			DEFAULT_CHAT_FRAME:AddMessage(AIF_BUTTON_ON);
			AutoInnerFire_SaveVar("AutoInnerFireButtonShown", 1);
		end
		AutoInnerFireButton_Toggle();
		AutoInnerFireOptionsFrame_Update();
	elseif( strfind(commandName, "position") ) then
		pos, params = AutoInnerFire_Extract_NextParameter(params);
		pos = tonumber(pos);
		AutoInnerFireButtonPosition = pos;
		AutoInnerFire_SaveVar("AutoInnerFireButtonPosition", pos);
		AutoInnerFireButton_UpdatePosition();
		DEFAULT_CHAT_FRAME:AddMessage(AIF_POS..pos.."\194\176");
	elseif( strfind(commandName, "threshold") ) then
		manapercent, params = AutoInnerFire_Extract_NextParameter(params);
		manapercent = tonumber(manapercent);
		AutoInnerFireThreshold = manapercent;
		AutoInnerFire_SaveVar("AutoInnerFireThreshold", manapercent);
		AutoInnerFireOptionsFrame_Update();
		DEFAULT_CHAT_FRAME:AddMessage(AIF_THRESHOLD..manapercent.."%");
	elseif ( commandName == "options" ) then
		ShowUIPanel(AutoInnerFireOptionsFrame);
	elseif ( commandName == "help" ) then
		AutoInnerFire_Help();
	else
		ShowUIPanel(AutoInnerFireOptionsFrame);
		return;
	end
end

function AutoInnerFire_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end


--------------------------------------------------------------------------------------------------
-- Movement functions
--------------------------------------------------------------------------------------------------
-- Move Forward
function new_MoveForwardStart(arg1)
    AutoInnerFire_Cast();
	old_MoveForwardStart(arg1);
end

-- Move Backward
function new_MoveBackwardStart(arg1)
    AutoInnerFire_Cast();
	old_MoveBackwardStart(arg1);
end

-- Strafe Right
function new_StrafeRightStart(arg1)
    AutoInnerFire_Cast();
	old_StrafeRightStart(arg1);
end

-- Strafe Left
function new_StrafeLeftStart(arg1)
    AutoInnerFire_Cast();
	old_StrafeLeftStart(arg1);
end

-- AutoWalk
function new_ToggleAutoRun(arg1)
    AutoInnerFire_Cast();
	old_ToggleAutoRun(arg1);
end


--------------------------------------------------------------------------------------------------
-- Casting functions
--------------------------------------------------------------------------------------------------
function AutoInnerFire_Cast()
	if AutoInnerFire == 1 then
		local found, mounted, MindControl, mymana, buff, combatbuff, i=false,false;
		mymana = ceil((UnitMana("player") / UnitManaMax("player")) * 100);
			
		for i=1,16 do
			buff = UnitBuff("player", i);
			
			-- Already buffed with Inner Fire
			if buff=="Interface\\Icons\\Spell_Holy_InnerFire" then
				found = true;
				
			-- Spirit Tap, so don't buff
			elseif buff == "Interface\\Icons\\Spell_Shadow_Requiem" then
				found = true;
				
			-- Inner Focus, so don't buff
			elseif buff == "Interface\\Icons\\Spell_Frost_WindWalkOn" then
				found = true;
				
			-- Mounted, so can't cast
			elseif buff and string.find(buff,"Mount_") then
				found = true;
				
			-- Casting Inner Fire while using Mind Control will break MC.
			elseif buff == "Interface\\Icons\\Spell_Shadow_ShadowWordDominate" then
				found = true;
			end
		end
		
		-- Combat check
		if ( AutoInnerFireCombat == 0 ) then
			if ( UnitAffectingCombat("player") == 1 ) then
				combatbuff = 1;
			else
				combatbuff = nil;
			end
		elseif ( AutoInnerFireCombat == 1 ) then
			combatbuff = nil;
		end
		
		if ( not found ) and ( mymana >= AutoInnerFireThreshold ) and ( combatbuff == nil ) then
			local i,done,name,id=1,false;
			
			while not done do
				name = GetSpellName(i,BOOKTYPE_SPELL);
				if not name then
					done=true;
				elseif name==AIF_SPELLNAME then
					id = i;
				end
				i = i+1;
			end
			
			if id then
				CastSpell(id,BOOKTYPE_SPELL);
			end
		end
	end
end


--------------------------------------------------------------------------------------------------
--- OptionsFrame Toggle functions
--------------------------------------------------------------------------------------------------
function AutoInnerFireOptionsFrame_Toggle()
	if(AutoInnerFireOptionsFrame:IsVisible()) then
		AutoInnerFireOptionsFrame:Hide();
	else
		AutoInnerFireOptionsFrame:Show();
	end
end


--------------------------------------------------------------------------------------------------
--- Help functions
--------------------------------------------------------------------------------------------------
function AutoInnerFire_Help()
	DEFAULT_CHAT_FRAME:AddMessage(AIF_VERSION);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP1);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP2);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP3);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP4);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP5);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP6);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP7);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP8);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP9);
	DEFAULT_CHAT_FRAME:AddMessage(AIF_HELP10);
end


--------------------------------------------------------------------------------------------------
-- AutoInnerFire - END OF FILE
--------------------------------------------------------------------------------------------------