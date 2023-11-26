-- Comments are for sissies

local _VARIABLES_LOADED = false;
local _ENTERING_WORLD = false;

DAB_OLD_ShowBonusActionBar = ShowBonusActionBar;
ShowBonusActionBar = DAB_ShowBonusActionBar;

function ShowBonusActionBar()
	if (DAB_Settings[DAB_INDEX].OtherBar[12].hide) then return; end
	DAB_OLD_ShowBonusActionBar();
end

function DAB_Main_OnEvent()
	if (event == "VARIABLES_LOADED") then
		DAB_VARIABLES_LOADED = true;
		if ( DAB_ENTERING_WORLD ) then
			DAB_Initialize();
		end
	elseif (event == "PLAYER_ENTERING_WORLD") then
		DAB_ENTERING_WORLD = true;
		if ( DAB_VARIABLES_LOADED ) then
			DAB_Initialize();
		end
	elseif (event == "PLAYER_ENTER_COMBAT") then
		DAB_ATTACKING = true;
		DAB_INCOMBAT = true;
	elseif (event == "PLAYER_LEAVE_COMBAT") then
		DAB_ATTACKING = false;
		if (DAB_REGEN_ENABLED) then
			DAB_INCOMBAT = false;
		end
	elseif (event == "PLAYER_REGEN_ENABLED") then
		DAB_REGEN_ENABLED = true;
		DAB_INCOMBAT = false;
	elseif (event == "PLAYER_REGEN_DISABLED") then
		DAB_REGEN_ENABLED = false;
		DAB_INCOMBAT = true;
	elseif (event == "ACTIONBAR_SHOWGRID") then
		DAB_SHOWING_EMPTY = true;
		for i=1, DAB_NUMBER_OF_BARS do
			DAB_Bar_SetLayout(i);
		end
	elseif (event == "ACTIONBAR_HIDEGRID") then
		DiscordActionBarsFrame.updatenewactions = .1;
	elseif (event == "UPDATE_BINDINGS") then
		if (DAB_INITIALIZED) then
			DAB_UpdateKeybindings();
		end
	elseif (event == "UPDATE_BONUS_ACTIONBAR") then
		if (DAB_Settings[DAB_INDEX].OtherBar[12].hide) then
			DAB_OtherBar_Hide(12);
		end
		if (GetNumShapeshiftForms() > 0) then
			local currentform = DAB_Get_CurrentForm();
			if (currentform ~= DAB_LAST_FORM) then
				DAB_LAST_FORM = currentform;
				DAB_Bar_UpdateFormBars(currentform);
			end
		end
	elseif (event == "UPDATE_SHAPESHIFT_FORMS") then
		DAB_Initialize_FormMenu();
	end
end

function DAB_Update_NewActions(elapsed)
	if (CursorHasItem() or CursorHasSpell()) then
		DiscordActionBarsFrame.updatenewactions = nil;
		return;
	end
	DiscordActionBarsFrame.updatenewactions = DiscordActionBarsFrame.updatenewactions - elapsed;
	if (DiscordActionBarsFrame.updatenewactions < 0) then
		DiscordActionBarsFrame.updatenewactions = nil;
		DAB_SHOWING_EMPTY = nil;
		for i=1, DAB_NUMBER_OF_BARS do
			DAB_Bar_SetLayout(i);
		end
	end
end

function DAB_Main_OnLoad()
--	RegisterForSave("DAB_Settings");

	this:RegisterEvent("ACTIONBAR_HIDEGRID");
	this:RegisterEvent("ACTIONBAR_SHOWGRID");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("UPDATE_BINDINGS");
	this:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	this:RegisterEvent("UPDATE_SHAPESHIFT_FORMS");
	this:RegisterEvent("VARIABLES_LOADED");

	SlashCmdList["DAB"] = DAB_Slash_Handler;
	SLASH_DAB1 = "/dab";
	SLASH_DAB2 = "/discordactionbars";
end

function DAB_Slash_Handler(msg)
	local command, param;
	local index = string.find(msg, " ");

	if( index) then
		command = string.sub(msg, 1, (index - 1));
		param = string.sub(msg, (index + 1)  );
	else
		command = msg;
	end
   
	if ( command == "" ) then
		DAB_Show_OptionsFrame("main");
	elseif (command == "clearbar") then
		param = tonumber(param);
		if (param) then
			for i=1,120 do
				if (DAB_Settings[DAB_INDEX].Button[i] == param) then
					PickupAction(i);
					CameraOrSelectOrMoveStart();
					CameraOrSelectOrMoveStop();
				end
			end
		end
	elseif (command == "barhide") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Bar[bar]) then
			DAB_Bar_Hide(bar);
		elseif (param == "pet" ) then
			DAB_OtherBar_Hide(11);
		elseif (param == "shapeshift" ) then
			DAB_OtherBar_Hide(12);
		elseif (param == "bag" ) then
			DAB_OtherBar_Hide(13);
		elseif (param == "menu" ) then
			DAB_OtherBar_Hide(14);
		end
	elseif (command == "barshow") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Bar[bar]) then
			DAB_Bar_Show(bar);
		elseif (param == "pet" ) then
			DAB_OtherBar_Show(11);
		elseif (param == "shapeshift" ) then
			DAB_OtherBar_Show(12);
		elseif (param == "bag" ) then
			DAB_OtherBar_Show(13);
		elseif (param == "menu" ) then
			DAB_OtherBar_Show(14);
		end
	elseif (command == "bartoggle") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Bar[bar]) then
			DAB_Bar_Toggle(bar);
		elseif (param == "pet" ) then
			DAB_OtherBar_Toggle(11);
		elseif (param == "shapeshift" ) then
			DAB_OtherBar_Toggle(12);
		elseif (param == "bag" ) then
			DAB_OtherBar_Toggle(13);
		elseif (param == "menu" ) then
			DAB_OtherBar_Toggle(14);
		end
	elseif (command == "barswap") then
		local _,_,bar1, bar2 = string.find(param, '(%d*) (%d*)');
		bar1 = tonumber(bar1);
		bar2 = tonumber(bar2);
		if (bar1 and bar2 and DAB_Settings[DAB_INDEX].Bar[bar1] and DAB_Settings[DAB_INDEX].Bar[bar2]) then
			DAB_Bar_Swap(bar1, bar2);
			DAB_Settings[DAB_INDEX].SwappedBars = { bar1, bar2 };
		end
	elseif (command == "unswap") then
		if (DAB_Settings[DAB_INDEX].SwappedBars and DAB_Settings[DAB_INDEX].SwappedBars[1]) then
			DAB_Bar_Swap(DAB_Settings[DAB_INDEX].SwappedBars[1], DAB_Settings[DAB_INDEX].SwappedBars[2]);
			DAB_Settings[DAB_INDEX].SwappedBars = nil;
		end
	elseif (command == "hideallbars") then
		for i=1,10 do
			DAB_Bar_Hide(i);
		end
	elseif (command == "showallbars") then
		for i=1,10 do
			DAB_Bar_Show(i);
		end
	elseif (command == "floaterhide") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Floaters[bar]) then
			DAB_Floater_Hide(bar);
		end
	elseif (command == "floatershow") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Floaters[bar]) then
			DAB_Floater_Show(bar);
		end
	elseif (command == "floatertoggle") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Floaters[bar]) then
			DAB_Floater_Toggle(bar);
		end
	elseif (command == "setkeybar") then
		local bar = tonumber(param);
		if (bar and DAB_Settings[DAB_INDEX].Bar[bar]) then
			DAB_SetKeybindingBar(bar);
		end
	else
		for _, line in DAB_HELP_TEXT do
			DAB_Feedback(line);
		end
	end
end

function DAB_Debug(msg)
	DEFAULT_CHAT_FRAME:AddMessage( msg, 1.0, 0.0, 0.0 );
end

function DAB_Feedback(msg)
	DEFAULT_CHAT_FRAME:AddMessage( msg, 1.0, 1.0, 0.0 );
end

function DAB_Copy_Table(src, dest)
	for index, value in src do
		if (type(value) == "table") then
			dest[index] = {};
			DAB_Copy_Table(value, dest[index]);
		else
			dest[index] = value;
		end
	end
end

function DAB_AttackTarget()
	if (UnitCanAttack("player","target")) then
		if (not DAB_ATTACKING) then
			AttackTarget(); 
		end
	end
end

function DAB_Get_MatchingButton(bar, button, bar2)
	local count = 0;
	for i=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == bar) then
			count = count + 1;
		end
		if (i == button) then break; end
	end
	local count2 = 0;
	for i=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == bar2) then
			count2 = count2 + 1;
		end
		if (count2 == count) then
			return i;
		end
	end
	return button;
end

function DAB_Update_FrameLocation(frame)
	getglobal(frame):StopMovingOrSizing();
	local x = getglobal(frame):GetLeft();
	local y = getglobal(frame):GetTop() - UIParent:GetTop();
	DAB_Settings[DAB_INDEX].FrameLocation[frame] = { x=x, y=y };
end

function DAB_StartMoving(override)
	if (DAB_DRAGGING_UNLOCKED or IsControlKeyDown() or override) then
		this.moving = true;
		this:StartMoving();
	end
end

function DAB_StopMoving()
	if (this.moving) then
		this.moving = nil;
		this:StopMovingOrSizing();
		DAB_Update_FrameLocation(this:GetName());
	end
end

function DAB_RunScript(body)
	body = gsub(body,"([^\n]*)\n","%1 ")
	RunScript(body);
end

function DAB_Run_Macro(macroname, eventmacro)
	local body;

	if (eventmacro) then
		body = macroname;
	else
		_, _, body = GetMacroInfo(GetMacroIndexByName(macroname));
	end

	if ( not body ) then return; end

	local length = string.len(body);
	local text="";
	for i = 1, length do
		text=text..string.sub(body,i,i);
		if ( string.sub(body,i,i) == "\n" or i == length ) then
			if ( string.find(text,"/cast") ) then
				local i, booktype = DAB_GetSpell(gsub(text,"%s*/cast%s*(.*)%s;*.*","%1"));
				if ( i ) then
					RunScript("CastSpell("..i..",'"..booktype.."')");
				end
			else
				while ( string.find(text, "CastSpellByName")) do
					local spell = gsub(text,'.-CastSpellByName.-%(.-"(.-)".*','%1',1);
					local i, booktype = DAB_GetSpell(spell);
					if ( i ) then
						text = gsub(text,'CastSpellByName.-%(.-".-"','CastSpell('..i..','..'"'..booktype..'"',1);
					else
						text = gsub(text,'CastSpellByName.-%(.-".-"%)','',1);
					end
				end
				if ( string.find(text,"/script")) then
					RunScript(gsub(text,"%s*/script%s*(.*)","%1"));
				else
					DAB_MacroBox:SetText(text);
					ChatEdit_SendText(DAB_MacroBox);
				end
			end
			text="";
		end
	end
end

function DAB_GetSpell(spell)
	local s = gsub(spell, "%s-(.-)%s*%(.*","%1");
	local r;
	if ( string.find(spell, "%(%s*[Rr]acial")) then
		r = "racial"
	elseif ( string.find(spell, "%(%s*[Ss]ummon")) then
		r = "summon"
	elseif ( string.find(spell, "%(%s*[Aa]pprentice")) then
		r = "apprentice"
	elseif ( string.find(spell, "%(%s*[Jj]ourneyman")) then
		r = "journeyman"
	elseif ( string.find(spell, "%(%s*[Ee]xpert")) then
		r = "expert"
	elseif ( string.find(spell, "%(%s*[Aa]rtisan")) then
		r = "artisan"
	elseif ( string.find(spell, "%(%s*[Mm]aster")) then
		r = "master"
	elseif ( not string.find(spell, "%(")) then
		r = ""
	else
		r = gsub(spell, ".*%(.*[Rr]ank%s*(%d+).*", "Rank %1");
	end
	return DAB_FindSpell(s,r);
end

function DAB_FindSpell(spell, rank)
	local i = 1;
	local booktype = "spell";
	local s,r;
	local ys, yr;
	while true do
		s, r = GetSpellName(i,"spell");
		if ( not s ) then break; end
		if ( string.lower(s) == string.lower(spell)) then ys=true; end
		if ( (r == rank) or (r and rank and string.lower(r) == string.lower(rank))) then yr=true; end
		if ( ys and yr ) then
			return i,booktype;
		end
		i=i+1;
		ys = nil;
		yr = nil;
	end
	i = 1;
	while true do
		s, r = GetSpellName(i,"pet");
		if ( not s) then break; end
		if ( string.lower(s) == string.lower(spell)) then ys=true; end
		if ( (r == rank) or (r and rank and string.lower(r) == string.lower(rank))) then yr=true; end
		if ( ys and yr ) then
			booktype = "pet";
			return i,booktype;
		end
		i=i+1;
		ys = nil;
		yr = nil;
	end
	return nil, booktype;
end

function DAB_DiscordMacroEventsFrame_OnLoad()
	this.timer = .033333333;
	for _,event in DAB_MENU_EVENTS do
		if (event.value ~= "OnUpdate") then
			this:RegisterEvent(event.value);
		end
	end
end

function DAB_CompileEventMacros()
	DAB_EVENTMACROS = {};
	for event, script in DAB_Settings[DAB_INDEX].EventMacros do
		if (script) then
			RunScript("function DAB_"..event.."Macro() "..script.." end");
			DAB_EVENTMACROS[event] = getglobal("DAB_"..event.."Macro");
		else
			DAB_EVENTMACROS[event] = function() end
		end
	end
end

function DAB_DiscordMacroEventsFrame_OnEvent(event)
	if (not DAB_INITIALIZED) then return; end
	if (event == "UPDATE_BONUS_ACTIONBAR") then
		local currentform = DAB_Get_CurrentForm();
		if (currentform == DAB_LAST_FORM2) then return; end
		DAB_LAST_FORM2 = currentform;
	end
	if (DAB_Settings[DAB_INDEX].EventMacros[event]) then
		DAB_EVENTMACROS[event]();
	end
end

function DAB_DiscordMacroEventsFrame_OnUpdate(elapsed)
	if (DAB_EDITING_MACRO) then return; end
	if (DELAY_CT_WARNING) then
		DELAY_CT_WARNING = DELAY_CT_WARNING - elapsed;
		if (DELAY_CT_WARNING < 0) then
			DELAY_CT_WARNING = nil;
			for i=1,5 do
				DAB_Debug("Disable CT_BarMod if you want to get your pet bar/shapeshift bar/bag bar back.");
			end
		end
	end
	if (this.timer) then
		this.timer = this.timer - elapsed;
		if (this.timer < 0) then
			this.timer = .03333333333;
			if (DAB_Settings[DAB_INDEX].EventMacros["OnUpdate"]) then
				DAB_EVENTMACROS["OnUpdate"]();
			end
			local isUsable, enoughMana;
			for button in DAB_SHOWWHENUSABLE do
				isUsable, notEnoughMana = IsUsableAction(button);
				if (GetActionCooldown(button) == 0 and isUsable and (not notEnoughMana) and IsActionInRange(button) ~= 0) then
					DAB_SHOWWHENUSABLE[button] = nil;
					DAB_Floater_Show(button);
				end
			end
		end
	end
end

function DAB_UpdateKeybindingLabels()
	if (not DAB_INITIALIZED) then return; end
	local buttontype, kblabel;
	local count = {};
	for i = 1, 10 do
		count[i] = 0;
	end
	DAB_KB_MAP = {};
	local keys = {};
	for i=1, 120 do
		buttontype = DAB_Settings[DAB_INDEX].Button[i];
		if (tonumber(buttontype)) then
			count[buttontype] = count[buttontype] + 1;
			if (not keys[buttontype]) then keys[buttontype] = {}; end
			local label = DAB_TEXT.Bar..buttontype;
			if (DAB_Settings[DAB_INDEX].Bar[buttontype].label.text) then
				label = "["..buttontype.."] "..DAB_Settings[DAB_INDEX].Bar[buttontype].label.text
			end
			keys[buttontype][count[buttontype]] = { v=i, l="     "..DAB_BAR_COLOR[buttontype]..label.." :: "..DAB_TEXT.Button..count[buttontype] };
		elseif (buttontype == "floater") then
			if (not keys.floaters) then keys.floaters = {}; end
			keys.floaters[i] = "     |cFFFFFF00"..DAB_TEXT.Floater..i;
		else
			if (not keys.undefined) then keys.undefined = {}; end
			keys.undefined[i] = "     |cFF666666"..DAB_TEXT.Undefined;
		end
	end

	local low, high;
	for i in keys do
		if (tonumber(i)) then
			if (not low) then
				low = i;
			elseif (i < low) then
				low = i;
			end
			if (not high) then
				high = i;
			elseif (i > high) then
				high = i;
			end
		end
	end

	count = 0;
	local bindingname;

	if (low) then
		for i=low, high do
			if (keys[i]) then
				for button,value in keys[i] do
					count = count + 1;
					DAB_KB_MAP[count] = value.v;
					bindingname = "DABBUTTON"..count;
					setglobal("BINDING_NAME_DABBUTTON"..count, value.l);
					local key1, key2 = GetBindingKey(bindingname);
					if (key1) then SetBinding(key1); end
					if (key2) then SetBinding(key2); end
					if (DAB_Settings[DAB_INDEX].Bar[i].keybindings[button]) then
						if (DAB_Settings[DAB_INDEX].Bar[i].keybindings[button].key1) then
							SetBinding(DAB_Settings[DAB_INDEX].Bar[i].keybindings[button].key1);
							SetBinding(DAB_Settings[DAB_INDEX].Bar[i].keybindings[button].key1, bindingname);
						end
						if (DAB_Settings[DAB_INDEX].Bar[i].keybindings[button].key2) then
							SetBinding(DAB_Settings[DAB_INDEX].Bar[i].keybindings[button].key2);
							SetBinding(DAB_Settings[DAB_INDEX].Bar[i].keybindings[button].key2, bindingname);
						end
					end
				end
			end
		end	
	end

	if (keys.floaters) then
		for i,v in keys.floaters do
			count = count + 1;
			DAB_KB_MAP[count] = i;
			setglobal("BINDING_NAME_DABBUTTON"..count, v);
			bindingname = "DABBUTTON"..count;
			local key1, key2 = GetBindingKey(bindingname);
			if (key1) then SetBinding(key1); end
			if (key2) then SetBinding(key2); end
			if (DAB_Settings[DAB_INDEX].Floaters[i].keybinding) then
				if (DAB_Settings[DAB_INDEX].Floaters[i].keybinding.key1) then
					SetBinding(DAB_Settings[DAB_INDEX].Floaters[i].keybinding.key1);
					SetBinding(DAB_Settings[DAB_INDEX].Floaters[i].keybinding.key1, bindingname);
				end
				if (DAB_Settings[DAB_INDEX].Floaters[i].keybinding.key2) then
					SetBinding(DAB_Settings[DAB_INDEX].Floaters[i].keybinding.key2);
					SetBinding(DAB_Settings[DAB_INDEX].Floaters[i].keybinding.key2, bindingname);
				end
			end
		end
	end
	
	if (keys.undefined) then
		for i,v in keys.undefined do
			count = count + 1;
			DAB_KB_MAP[count] = i;
			setglobal("BINDING_NAME_DABBUTTON"..count, v);
			bindingname = "DABBUTTON"..count;
			local key1, key2 = GetBindingKey(bindingname);
			if (key1) then SetBinding(key1); end
			if (key2) then SetBinding(key2); end
		end
	end

	SaveBindings();
end

function DAB_SaveKeybindings()
	local barcount = {};
	for i=1, 10 do
		barcount[i] = 0;
	end	
	for button = 1, 120 do
		local bar = DAB_Settings[DAB_INDEX].Button[button];
		if (tonumber(bar)) then
			barcount[bar] = barcount[bar] + 1;
		end
		local kbnum;
		for i, v in DAB_KB_MAP do
			if (v == button) then
				kbnum = i;
				break;
			end
		end
		if (kbnum) then
			local kblabel = "DABBUTTON"..kbnum;
			local key1, key2 = GetBindingKey(kblabel);
			if (tonumber(bar)) then
				DAB_Settings[DAB_INDEX].Bar[bar].keybindings[barcount[bar]] = {};
				DAB_Settings[DAB_INDEX].Bar[bar].keybindings[barcount[bar]].key1 = key1;
				DAB_Settings[DAB_INDEX].Bar[bar].keybindings[barcount[bar]].key2 = key2;
			elseif (bar == "floater") then
				DAB_Settings[DAB_INDEX].Floaters[button].keybinding = {};
				DAB_Settings[DAB_INDEX].Floaters[button].keybinding.key1 = key1;
				DAB_Settings[DAB_INDEX].Floaters[button].keybinding.key2 = key2;
			end
		end
	end
end

function DAB_KeyBindingFrame_GetLocalizedName(name, prefix)
	if ( not name ) then
		return "";
	end
	local tempName = name;
	local i = strfind(name, "-");
	local dashIndex = nil;
	while ( i ) do
		if ( not dashIndex ) then
			dashIndex = i;
		else
			dashIndex = dashIndex + i;
		end
		tempName = strsub(tempName, i + 1);
		i = strfind(tempName, "-");
	end

	local modKeys = '';
	if ( not dashIndex ) then
		dashIndex = 0;
	else
		modKeys = strsub(name, 1, dashIndex);
		if ( GetLocale() == "deDE") then
			modKeys = gsub(modKeys, "CTRL", "STRG");
		end
	end

	local variablePrefix = prefix;
	if ( not variablePrefix ) then
		variablePrefix = "";
	end
	local localizedName = nil;
	if ( IsMacClient() ) then
		-- see if there is a mac specific name for the key
		localizedName = getglobal(variablePrefix..tempName.."_MAC");
	end
	if ( not localizedName ) then
		localizedName = getglobal(variablePrefix..tempName);
	end
	if ( not localizedName ) then
		localizedName = tempName;
	end
	return modKeys..localizedName;
end

function DAB_UpdateKeybindings()
	if (not DAB_INITIALIZED) then return; end
	for button = 1, 120 do
		local buttontext = getglobal("DAB_ActionButton_"..button.."TextFrameHotKey");
		local kbnum;
		for i, v in DAB_KB_MAP do
			if (v == button) then
				kbnum = i;
				break;
			end
		end
		if (kbnum) then
			local kblabel = "DABBUTTON"..kbnum;
			local kbtext = DAB_KeyBindingFrame_GetLocalizedName(GetBindingKey(kblabel), "KEY_");
			kbtext = string.upper(kbtext);
			kbtext = string.gsub(kbtext, "SHIFT", "S");
			kbtext = string.gsub(kbtext, "CTRL", "C");
			kbtext = string.gsub(kbtext, "ALT", "A");
			kbtext = string.gsub(kbtext, "MOUSE BUTTON", "MB");
			kbtext = string.gsub(kbtext, "BUTTON1", "MB1");
			kbtext = string.gsub(kbtext, "BUTTON2", "MB2");
			kbtext = string.gsub(kbtext, "BUTTON3", "MB3");
			kbtext = string.gsub(kbtext, "BUTTON4", "MB4");
			kbtext = string.gsub(kbtext, "BUTTON5", "MB5");
			kbtext = string.gsub(kbtext, "MIDDLE MOUSE", "MM");
			kbtext = string.gsub(kbtext, "NUM PAD", "NP");
			if (DAB_Settings[DAB_INDEX].HideKeybindings) then
				buttontext:SetText("");
			else
				buttontext:SetText(kbtext);
			end
		else
			buttontext:SetText("");
		end
	end
	DAB_SaveKeybindings();
end

function DAB_SetKeybindingBar(bar)
	if (not bar) then return; end
	if (DAB_Settings[DAB_INDEX].DynamicKeybindingBar) then
		for i=1,120 do
			if (DAB_Settings[DAB_INDEX].Button[i] == DAB_Settings[DAB_INDEX].DynamicKeybindingBar) then
				getglobal("DAB_ActionButton_"..i.."TextFrameDynamicHotKey"):SetText("");
			end
		end
	end
	DAB_Settings[DAB_INDEX].DynamicKeybindingBar = bar;
	local count = 0;
	for button = 1, 120 do
		if ( DAB_Settings[DAB_INDEX].Button[button] == bar ) then
			count = count + 1;
			local buttontext = getglobal("DAB_ActionButton_"..button.."TextFrameDynamicHotKey");
			local kblabel = "DAB3_"..count;
			local kbtext = DAB_KeyBindingFrame_GetLocalizedName(GetBindingKey(kblabel), "KEY_");
			kbtext = string.upper(kbtext);
			kbtext = string.gsub(kbtext, "SHIFT", "S");
			kbtext = string.gsub(kbtext, "CTRL", "C");
			kbtext = string.gsub(kbtext, "ALT", "A");
			kbtext = string.gsub(kbtext, "MOUSE BUTTON", "MB");
			kbtext = string.gsub(kbtext, "BUTTON1", "MB1");
			kbtext = string.gsub(kbtext, "BUTTON2", "MB2");
			kbtext = string.gsub(kbtext, "BUTTON3", "MB3");
			kbtext = string.gsub(kbtext, "BUTTON4", "MB4");
			kbtext = string.gsub(kbtext, "BUTTON5", "MB5");
			kbtext = string.gsub(kbtext, "MIDDLE MOUSE", "MM");
			kbtext = string.gsub(kbtext, "NUM PAD", "NP");
			if (DAB_Settings[DAB_INDEX].HideDynamicKeybindings) then
				buttontext:SetText("");
			else
				buttontext:SetText(kbtext);
			end
			if (count == 20) then break; end
		end
	end
end

function DAB_KeybindingButtonDown(kbnum)
	if (ChatFrameEditBox:IsVisible()) then return; end
	local id = DAB_KB_MAP[kbnum];
	getglobal("DAB_ActionButton_"..id):SetChecked(1);
	getglobal("DAB_ActionButton_"..id).clicked = true;
	getglobal("DAB_ActionButton_"..id).keydown = true;
	if (DAB_Settings[DAB_INDEX].useondown) then
		DAB_KeybindingUseAction(kbnum, 1);
	end
end

function DAB_KeybindingUseAction(kbnum, override)
	if (ChatFrameEditBox:IsVisible()) then return; end
	if (not override) then
		if (DAB_Settings[DAB_INDEX].useondown) then return; end
	end
	local id = DAB_KB_MAP[kbnum];
	local bar = DAB_Settings[DAB_INDEX].Button[id];
	if (not bar) then return; end
	local target, hideonclick, autoattack, forcetarget;
	if (bar == "floater") then
		target = DAB_Settings[DAB_INDEX].Floaters[id].target;
		hideonclick = DAB_Settings[DAB_INDEX].Floaters[id].hideonclick;
		autoattack = DAB_Settings[DAB_INDEX].Floaters[id].AutoAttack;
		forcetarget = DAB_Settings[DAB_INDEX].Floaters[id].ForceTarget;
	else
		target = DAB_Settings[DAB_INDEX].Bar[bar].target;
		hideonclick = DAB_Settings[DAB_INDEX].Bar[bar].hideonclick;
		autoattack = DAB_Settings[DAB_INDEX].Bar[bar].AutoAttack;
		forcetarget = DAB_Settings[DAB_INDEX].Bar[bar].ForceTarget;
	end
	if (not IsAttackAction(id)) then
		if (autoattack) then
			DAB_AttackTarget();
		end
	end
	if (target and forcetarget) then
		TargetUnit(target);
	end
	UseAction(id);
	if (SpellIsTargeting() and target) then
			SpellTargetUnit(target);
	end
	if (hideonclick) then
		if (bar == "floater") then
			DAB_Floater_Hide(id);
		else
			DAB_Bar_Hide(bar);
		end
	end
	this = getglobal("DAB_ActionButton_"..id);
	this.keydown = nil;
	if (this:IsVisible()) then
		DAB_ActionButton_UpdateState();
	end
end

function DAB_DynamicKeybindingButtonDown(button)
	if (ChatFrameEditBox:IsVisible()) then return; end
	local bar = DAB_Settings[DAB_INDEX].DynamicKeybindingBar;
	if (not bar) then return; end
	local count = 0;
	for i=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == bar) then
			count = count + 1;
			if (count == button) then
				getglobal("DAB_ActionButton_"..i).keydown = true;
				getglobal("DAB_ActionButton_"..i):SetChecked(1);
				break;
			end
		end
	end
end

function DAB_DynamicKeybindingUseAction(button)
	if (ChatFrameEditBox:IsVisible()) then return; end
	local bar = DAB_Settings[DAB_INDEX].DynamicKeybindingBar;
	if (not bar) then return; end
	local count = 0;
	for i=1,120 do
		if (DAB_Settings[DAB_INDEX].Button[i] == bar) then
			count = count + 1;
			if (count == button) then
				UseAction(i);
				if (SpellIsTargeting() and DAB_Settings[DAB_INDEX].Bar[bar].target) then
					SpellTargetUnit(DAB_Settings[DAB_INDEX].Bar[bar].target);
				end
				if (DAB_Settings[DAB_INDEX].Bar[bar].hideonclick) then
					DAB_Bar_Hide(bar);
				end
				this = getglobal("DAB_ActionButton_"..i);
				this.keydown = nil;
				if (this:IsVisible()) then
					DAB_ActionButton_UpdateState();
				end
				break;
			end
		end
	end
end

function DAB_Get_CurrentForm()
	for i=1,GetNumShapeshiftForms() do
		local _, name, isActive = GetShapeshiftFormInfo(i);
		if isActive == 1 then return i, name; end
	end
	return 0;
end

function DAB_Check_Mouseover(frame)
	local lowx = frame:GetLeft();
	local highx = frame:GetRight();
	local lowy = frame:GetBottom();
	local highy = frame:GetTop();
	local x, y = GetCursorPosition();
	x = x / UIParent:GetScale();
	y = y / UIParent:GetScale();
	if (x < lowx or x > highx) then
		return nil;
	end
	if (y < lowy or y > highy) then
		return nil;
	end
	return true;
end

function DAB_IsInContext(friendlytarget, hostiletarget, combat, notincombat, form, onetrue)
	if (friendlytarget) then
		if (UnitName("target")) then
			if (not UnitCanAttack("player", "target")) then
				if (onetrue) then return true; end
			elseif (not onetrue) then
				return;
			end
		elseif (not onetrue) then
			return;
		end
	end

	if (hostiletarget) then
		if (UnitName("target")) then
			if (UnitHealth("target") > 0) then
				if (UnitCanAttack("player", "target")) then
					if (onetrue) then return true; end
				elseif (not onetrue) then
					return;
				end
			elseif (not onetrue) then
				return;
			end
		elseif (not onetrue) then
			return;
		end
	end

	if (combat) then
		if (onetrue) then
			if (DAB_INCOMBAT) then return true; end
		elseif (not DAB_INCOMBAT) then
			return;
		end
	end
	if (notincombat) then
		if (onetrue) then
			if (not DAB_INCOMBAT) then return true; end
		elseif (DAB_INCOMBAT) then
			return;
		end
	end
	if (form) then
		if (form ~= DAB_Get_CurrentForm()) then
			return;
		elseif (onetrue) then
			return true;
		end
	end
	if (onetrue) then
		return;
	else
		return true;
	end
end

function DAB_UsePetAction(id)
	getglobal("PetActionButton"..id):SetChecked(0);
	CastPetAction(id);
end
