TITAN_ITEMBONUSES_ID = "ItemBonuses";

TitanItemBonuses_bonuses = {};
TitanItemBonuses_currentset = "";
TitanItemBonuses_sets = {};
TitanItemBonuses_active = nil;

function TitanPanelItemBonusesButton_OnLoad()
	this.registry = {
		id = TITAN_ITEMBONUSES_ID,
		menuText = TITAN_ITEMBONUSES_TEXT,
		buttonTextFunction = "TitanPanelItemBonusesButton_GetButtonText",
		tooltipTitle = TITAN_ITEMBONUSES_TEXT,
		tooltipTextFunction = "TitanPanelItemBonusesButton_GetTooltipText",
		icon = "Interface\\Icons\\Spell_Nature_EnchantArmor.blp";
		iconWidth = 16,
		savedVariables = {
			ShowLabelText = 1,
			ShowIcon = 1,
			shortdisplay = 0,
			displaybonuses = {},
		}
	};

	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
end

function TitanPanelItemBonusesButton_FormatShortText(short,val)
	local color = 'FFFFFF';
	local text = string.sub(short,2);
	local colorcode = string.sub(short,1,1);
	if(TitanItemBonuses_colors[colorcode]) then
		color = TitanItemBonuses_colors[colorcode];
	end;
	if(val) then
		return '|cff'.. color .. val .. FONT_COLOR_CODE_CLOSE
	else 
		return '|cff'.. color .. text .. FONT_COLOR_CODE_CLOSE
	end;
end


function TitanPanelItemBonusesButton_GetButtonText(id)
	local title = TITAN_ITEMBONUSES_TEXT;
	local text = "";
	local disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
	-- preventing getting inaccessible due to no display at all
	if(	(not disp or (table.getn(disp) == 0))
		and not TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowLabelText")
		and not TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowIcon")) then
		TitanSetVar(TITAN_ITEMBONUSES_ID, "ShowLabelText", 1);
		TitanPanelButton_UpdateButton(TITAN_ITEMBONUSES_ID);
	end;
	
	local i,d,e;
	local liste = {};
	for i,d in disp do
		e = TITAN_ITEMBONUSES_EFFECTS[d];
		if(TitanGetVar(TITAN_ITEMBONUSES_ID, "shortdisplay")) then
			title = TitanPanelItemBonusesButton_FormatShortText(e.short);
		else
			title = e.name..": ";
		end
		if(TitanItemBonuses_bonuses[e.effect]) then
			val = TitanItemBonuses_bonuses[e.effect];
		else
			val = 0;
		end
   		text = format(e.format,val);
		if(TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowColoredText")) then
			text = TitanPanelItemBonusesButton_FormatShortText(e.short,text);
		end;
		table.insert(liste,title);
		table.insert(liste,TitanUtils_GetHighlightText(text));
	end;

	if(table.getn(liste) == 0) then
		return TITAN_ITEMBONUSES_TEXT;
	end
	return unpack(liste);
end

function TitanPanelItemBonusesButton_isdisp(val)
	local disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
	local i,d;
	for i,d in disp do
		if(d==val) then
			return 1;
		end
	end
	return nil;
end

function TitanPanelItemBonusesButton_hasdisp()
	local disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
	if(not disp) then
		return nil;
	end
	return table.getn(disp) > 0;
end


function TitanPanelItemBonusesButton_GetTooltipText()
	local retstr,cat,val = "","","","";
	local i;

	for i,e in TITAN_ITEMBONUSES_EFFECTS do

		if(TitanItemBonuses_bonuses[e.effect]) then
			if(e.format) then
		   		val = format(e.format,TitanItemBonuses_bonuses[e.effect]);
			else
				val = TitanItemBonuses_bonuses[e.effect];
			end;
			if(e.cat ~= cat) then
				cat = e.cat;
				if(retstr ~= "") then
					retstr = retstr .. "\n"
				end
				retstr = retstr .. "\n" .. TitanUtils_GetGreenText(getglobal('TITAN_ITEMBONUSES_CAT_'..cat)..":");
			end
			
			retstr = retstr.. "\n".. e.name..":\t".. TitanUtils_GetHighlightText(val);
		end
	end
	return retstr;
end

function TitanPanelItemBonusesButton_OnEvent()
	if (event == "PLAYER_ENTERING_WORLD") then
		TitanItemBonuses_active = 1;
	end
	if (((event == "PLAYER_ENTERING_WORLD") or (event == "UNIT_INVENTORY_CHANGED")) and TitanItemBonuses_active) then
		TitanPanelItemBonuses_CalcValues();
		TitanPanelButton_UpdateButton(TITAN_ITEMBONUSES_ID);
	end
end

function TitanPanelRightClickMenu_PrepareItemBonusesMenu()
	local id = "ItemBonuses";
	local info = {};
	local i,cat,disp,val;

	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		for i,e in TITAN_ITEMBONUSES_EFFECTS do
			if(e.cat == this.value) then
				info = {};
				info.text = '[' .. TitanPanelItemBonusesButton_FormatShortText(e.short) .. '] ' .. e.name;
				if(TitanItemBonuses_bonuses[e.effect]) then
					val = TitanItemBonuses_bonuses[e.effect];
			   		info.text = info.text .. " (".. format(e.format,val).. ")";
			   	end
				info.value = i;
				info.func = TitanPanelItemBonuses_SetDisplay;
				info.checked = TitanPanelItemBonusesButton_isdisp(i);
				info.keepShownOnClick = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
		end
	else
		TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_ITEMBONUSES_ID].menuText);
		TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = TITAN_ITEMBONUSES_DISPLAY_NONE;
		info.value = 0;
		info.func = TitanPanelItemBonuses_SetDisplay;
		disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
		info.checked = not TitanPanelItemBonusesButton_hasdisp();
		UIDropDownMenu_AddButton(info);
		
		for i,cat in TITAN_ITEMBONUSES_CATEGORIES do
			info = {};
			info.text = getglobal('TITAN_ITEMBONUSES_CAT_'..cat);
			info.hasArrow = 1;
			info.value = cat;
			UIDropDownMenu_AddButton(info);
		end;

		TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);

		TitanPanelRightClickMenu_AddToggleIcon(TITAN_ITEMBONUSES_ID);
		TitanPanelRightClickMenu_AddToggleVar(TITAN_ITEMBONUSES_SHORTDISPLAY, TITAN_ITEMBONUSES_ID,'shortdisplay');
		TitanPanelRightClickMenu_AddToggleLabelText(TITAN_ITEMBONUSES_ID);
		TitanPanelRightClickMenu_AddToggleColoredText(TITAN_ITEMBONUSES_ID);
		TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, id, TITAN_PANEL_MENU_FUNC_HIDE);
	end
end

function TitanPanelItemBonuses_SetDisplay()
	local db = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
	local i,d,found;
	if(this.value == 0) then
		TitanSetVar(TITAN_ITEMBONUSES_ID, "displaybonuses", {});
	else
		found = 0;
		for i,d in db do
			if(d == this.value)then
				found = i;
			end
		end
		if(found > 0) then
			table.remove(db,found)
		else
			while(table.getn(db)>3) do
				table.remove(db);
			end;
			table.insert(db,this.value);
		end
		TitanSetVar(TITAN_ITEMBONUSES_ID, "displaybonuses", db);
	end;
	TitanPanelButton_UpdateButton(TITAN_ITEMBONUSES_ID);
end

function TitanPanelItemBonuses_AddValue(effect, value)
	local i,e;
	if(type(effect) == "string") then
		if(TitanItemBonuses_bonuses[effect]) then
			TitanItemBonuses_bonuses[effect] = TitanItemBonuses_bonuses[effect] + value;
		else
			TitanItemBonuses_bonuses[effect] = value;
		end
	else 
	-- list of effects
		for i,e in effect do
			if(TitanItemBonuses_bonuses[e]) then
				TitanItemBonuses_bonuses[e] = TitanItemBonuses_bonuses[e] + value;
			else
				TitanItemBonuses_bonuses[e] = value;
			end
		end
	end
end;

function TitanPanelItemBonuses_ScanLine(line)
	local i,p,tmpStr,value,token;
	
	-- Check for "Equip: "
	if(string.sub(line,0,string.len(TITAN_ITEMBONUSES_EQUIP_PREFIX)) == TITAN_ITEMBONUSES_EQUIP_PREFIX) then

		tmpStr = string.sub(line,string.len(TITAN_ITEMBONUSES_EQUIP_PREFIX)+1);
			for i,p in TITAN_ITEMBONUSES_EQUIP_PATTERNS do
			_, _, value = string.find(tmpStr, "^" .. p.pattern);
			if(value) then
				TitanPanelItemBonuses_AddValue(p.effect, value)
			end
		end
	-- Check for "Set: "
	elseif(string.sub(line,0,string.len(TITAN_ITEMBONUSES_SET_PREFIX)) == TITAN_ITEMBONUSES_SET_PREFIX
			and TitanItemBonuses_currentset ~= "" 
			and not TitanItemBonuses_sets[TitanItemBonuses_currentset]) then

		tmpStr = string.sub(line,string.len(TITAN_ITEMBONUSES_SET_PREFIX)+1);
		for i,p in TITAN_ITEMBONUSES_EQUIP_PATTERNS do
			_, _, value = string.find(tmpStr, "^" .. p.pattern);
			if(value) then
				TitanPanelItemBonuses_AddValue(p.effect, value)
			end
		end
	-- any other line (standard stats, enchantment, set name, etc.)
	else
		-- Check for set name
		_, _, tmpStr = string.find(line, TITAN_ITEMBONUSES_SETNAME_PATTERN);
		if(tmpStr) then
			TitanItemBonuses_currentset = tmpStr;
		else
			_, _, value, token = string.find(line, TITAN_ITEMBONUSES_PREFIX_PATTERN);
			if(not value) then
				_, _,  token, value = string.find(line, TITAN_ITEMBONUSES_SUFFIX_PATTERN);
			end
			if(token and value) then
				-- trim token
			    token = string.gsub( token, "^%s+", "" )
                token = string.gsub( token, "%s+$", "" )
				TitanPanelItemBonuses_ScanToken(token,value);
			end
		end
	end
end;

function TitanPanelItemBonuses_ScanToken(token, value)
	local i,p,s1,s2;
	if(TITAN_ITEMBONUSES_TOKEN_EFFECT[token]) then
		TitanPanelItemBonuses_AddValue(TITAN_ITEMBONUSES_TOKEN_EFFECT[token], value);
	else
		s1 = nil;
		s2 = nil;
		for i,p in TITAN_ITEMBONUSES_S1 do
			if(string.find(token,p.pattern,1,1)) then
				s1 = p.effect;
			end
		end	
		for i,p in TITAN_ITEMBONUSES_S2 do
			if(string.find(token,p.pattern,1,1)) then
				s2 = p.effect;
			end
		end	
		if(s1 and s2) then
			TitanPanelItemBonuses_AddValue(s1..s2, value);
		end 
	end
end


function TitanPanelItemBonuses_CalcValues()

	local slotnames = {
		"Head",
  		"Neck",
  		"Shoulder",
  		"Shirt",
  		"Chest",
  		"Waist",
  		"Legs",
  		"Feet",
  		"Wrist",
  		"Hands",
  		"Finger0",
  		"Finger1",
  		"Trinket0",
  		"Trinket1",
  		"Back",
  		"MainHand",
  		"SecondaryHand",
  		"Ranged",
  		"Tabard",
	};

	local id, hasItem;
	local itemName, tmpText, tmpStr, tmpSet, val, lines, set;

	TitanItemBonuses_bonuses = {};
	TitanItemBonuses_sets = {};

	for i,slotName in slotnames do
		id, _ = GetInventorySlotInfo(slotName.. "Slot");
		TPIBonTooltip:Hide()
		TPIBonTooltip:SetOwner(this, "ANCHOR_LEFT");
		hasItem = TPIBonTooltip:SetInventoryItem("player", id);
		TitanItemBonuses_currentsets = {};
	
		if ( not hasItem ) then
			TPIBonTooltip:ClearLines()
		else
			itemName = TPIBonTooltipTextLeft1:GetText();
			lines = TPIBonTooltip:NumLines();

			for i=2, lines, 1 do
				tmpText = getglobal("TPIBonTooltipTextLeft"..i);
				val = nil;
				if (tmpText:GetText()) then
					tmpStr = tmpText:GetText();
					TitanPanelItemBonuses_ScanLine(tmpStr);
				end
			end
			-- if set item, mark set as already scanned
			if(set ~= "") then
				TitanItemBonuses_sets[TitanItemBonuses_currentset] = 1;
			end;
		end
	end
	TPIBonTooltip:Hide()
end

