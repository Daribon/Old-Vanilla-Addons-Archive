SUPERMACRO_VERSION = "2.3";
--UIPanelWindows["MacroFrame"] ={ area = "doublewide", pushable = 0 };
UIPanelWindows["MacroFrame"] ={ area = "left", pushable = 7 };
MACRO_ROWS = 3;
MACRO_COLUMNS = 10;
MACROS_SHOWN = MACRO_ROWS*MACRO_COLUMNS;
MACRO_ROW_HEIGHT = 36;
MACRO_MAX_LETTERS = 1023;
SM_VARS = {};
SM_VARS.hideAction = "0";

function SuperMacro_OnLoad()
	MacroFrame:SetWidth(590);

	MacroFrameText:SetMaxLetters(MACRO_MAX_LETTERS); -- set to system limit. read readme.txt for more info

	MacroFrameText:SetWidth(491);
	MacroFrameText:SetHeight(100);

	MacroFrameTextButton:SetWidth(491);
	MacroFrameTextButton:SetHeight(100);

	MacroFrameTextBackground:SetWidth(530);
	MacroFrameTextBackground:SetHeight(112);
	MacroFrameTextBackground:SetPoint("TOPLEFT", "MacroFrame", "TOPLEFT", 18, -285);

	MacroFrameScrollFrame:SetWidth(493);
	MacroFrameScrollFrame:SetHeight(100);
	MacroFrameScrollFrame:SetPoint("TOPLEFT", "MacroFrameSelectedMacroBackground", "BOTTOMLEFT", 11, 0);

-- disable arts
	MacroHorizontalBarLeft:SetWidth(460);
	MacroFrameEnterMacroText:SetText("");
	MacroFrameTabText:SetText("SUPERMACRO "..SUPERMACRO_VERSION);

	MacroExitButton:SetPoint("CENTER", "MacroFrame", "TOPLEFT", 509, -422);
	MacroNewButton:SetPoint("CENTER", "MacroFrame", "TOPLEFT", 428, -422);

	MacroButton1:SetPoint("TOPLEFT", "MacroFrame", "TOPLEFT", 35, -83);
	MacroButton7:ClearAllPoints();
	MacroButton7:SetPoint("LEFT", "MacroButton6", "RIGHT", 13, 0);
	MacroButton11:ClearAllPoints();
	MacroButton11:SetPoint("TOP", "MacroButton1", "BOTTOM", 0, -10);
	MacroButton13:ClearAllPoints();
	MacroButton13:SetPoint("LEFT", "MacroButton12", "RIGHT", 13, 0);

	-- Update Macros on action bars
	local button, macroName;
	for i=1,72 do
		button = getglobal("ActionButton"..i);
		if ( button ) then
			macroName = getglobal(button:GetName().."Name"):GetText();
			if ( macroName ) then
				local macroID = GetMacroIndexByName(macroName);
				if ( macroID ) then
					local name, texture, body, isLocal = GetMacroInfo(macroID);
					EditMacro(macroID, nil, nil, body, isLocal);
				end
			end
		end
	end

	this:RegisterEvent("VARIABLES_LOADED");
end

function SuperMacro_OnEvent(event)
	if ( event=="VARIABLES_LOADED" ) then
		HideActionText();		
	end
end

function RunMacro(index)
	-- close edit boxes, then enter body line by line
	local name, texture, body, isLocal;
	if ( type(index) == "number" ) then
		name, texture, body, isLocal = GetMacroInfo(index);
	elseif ( type(index) == "string" ) then
		name, texture, body, isLocal = GetMacroInfo(GetMacroIndexByName(index));
	end
	if ( not body ) then return; end

	if ( ChatFrameEditBox:IsVisible() ) then
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end
	local length = string.len(body);
	local text="";
	for i = 1, length do
		text=text..string.sub(body,i,i);
		if ( string.sub(body,i,i) == "\n" or i == length ) then
			if ( string.find(text,"/cast") ) then
				local i, booktype = SM_CastSpell(gsub(text,"%s*/cast%s*(.*)%s;*.*","%1"));
				if ( i ) then
					RunScript("CastSpell("..i..",'"..booktype.."')");
				end
			else
				while ( string.find(text, "CastSpellByName")) do
					local spell = gsub(text,'.-CastSpellByName.-%(.-"(.-)".*','%1',1);
					local i, booktype = SM_CastSpell(spell);
					if ( i ) then
						text = gsub(text,'CastSpellByName.-%(.-".-"','CastSpell('..i..','..'"'..booktype..'"',1);
					else
						text = gsub(text,'CastSpellByName.-%(.-".-"%)','',1);
					end
				end
				if ( string.find(text,"/script")) then
					RunScript(gsub(text,"%s*/script%s*(.*)","%1"));
				else
					ChatFrameEditBox:SetText(text);
					ChatEdit_SendText(ChatFrameEditBox);
				end
			end
			text="";
		end
	end
end

function MacroFrame_Update()
	local numMacros	= GetNumMacros();
	local macroOffset;
	local macroButton, macroIcon, macroName;
	local name, texture, body, isLocal;

	-- Macro List
	macroOffset = FauxScrollFrame_GetOffset(SuperMacroFrameScrollFrame);
	local firstmacro = macroOffset*MACRO_COLUMNS+1;
	local lastmacro = firstmacro + MACRO_ROWS*MACRO_COLUMNS -1;
	for i=1, MACROS_SHOWN do
		getglobal("MacroButton"..i.."ID"):SetText(firstmacro+i-1);
		macroButton = getglobal("MacroButton"..i);
		macroIcon = getglobal("MacroButton"..i.."Icon");
		macroName = getglobal("MacroButton"..i.."Name");
		local macroID = firstmacro+i-1;
		if ( macroID <= numMacros ) then
			name, texture, body, isLocal = GetMacroInfo(macroID);
			macroButton:SetID(macroID);
			macroIcon:SetTexture(texture);
			macroName:SetText(name);
			macroButton:Enable();
			-- Highlight Selected Macro
			if ( macroID == MacroFrame.selectedMacro ) then
				macroButton:SetChecked(1);
				MacroFrameSelectedMacroName:SetText(name);
				MacroFrameText:SetText(body);
				MacroFrameSelectedMacroButtonIcon:SetTexture(texture);
			else
				macroButton:SetChecked(0);
			end
		else
			macroButton:SetChecked(0);
			macroIcon:SetTexture("");
			macroName:SetText("");
			macroButton:Disable();
		end
	end

	-- Macro Details
	if ( MacroFrame.selectedMacro ~= nil ) then
		MacroFrame_ShowDetails();
		MacroDeleteButton:Enable();
	else
		MacroFrame_HideDetails();
		MacroDeleteButton:Disable();
	end

	-- Disable Buttons
	if ( MacroPopupFrame:IsVisible() ) then
		MacroNewButton:Disable();
		MacroEditButton:Disable();
		MacroDeleteButton:Disable();
	else
		MacroNewButton:Enable();
		MacroEditButton:Enable();
		MacroDeleteButton:Enable();
	end

	if ( not MacroFrame.selectedMacro ) then
		MacroDeleteButton:Disable();
	end

	-- Scroll frame stuff
	FauxScrollFrame_Update(SuperMacroFrameScrollFrame, ceil(numMacros/10), MACRO_ROWS, MACRO_ROW_HEIGHT );
end

function SM_CastSpell(spell)
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
	return FindSpell(s,r);
end

function FindSpell(spell, rank)
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

function HideActionText()
	local func=ActionButton1Name.Show;
	if ( SM_VARS.hideAction == "1" ) then
		func = ActionButton1Name.Hide;
	elseif ( SM_VARS.hideAction == "0" ) then
		func = ActionButton1Name.Show;
	end
	for i = 1,72 do
		if ( getglobal("ActionButton"..i) ) then
			func(getglobal("ActionButton"..i.."Name"));
		else
			break;
		end
		if ( getglobal("BonusActionButton"..i.."Name")) then
			func(getglobal("BonusActionButton"..i.."Name"));
		end
		if ( getglobal("MultiBarBottomLeftButton"..i.."Name") ) then
			func(getglobal("MultiBarBottomLeftButton"..i.."Name"));
			func(getglobal("MultiBarBottomRightButton"..i.."Name"))
			func(getglobal("MultiBarLeftButton"..i.."Name"));
			func(getglobal("MultiBarRightButton"..i.."Name"));
		end
	end
end

SlashCmdList["SUPERMACRO"] = function(msg)
	local text;
	local cmd = gsub(msg,"^%s*(%a*)%s*(.*)%s*$","%1" );
	local param = gsub(msg,"^%s*(%a*)%s*([%w %p]*)%s*$","%2" );
	if ( cmd=="hideaction") then
		text = param;
		if ( text == "0" or text=="false") then
			SM_VARS.hideAction = "0";
			HideActionText();
		elseif ( text == "1" or text=="true") then
			SM_VARS.hideAction = "1";
			HideActionText();
		else
			ChatFrame_DisplaySlashHelp("SUPERMACRO",1,1);
		end
		if ( not SM_VARS.hideAction ) then SM_VARS.hideAction = "0"; end
		local info = ChatTypeInfo["SYSTEM"];
		text = "SM_VARS.hideAction is "..SM_VARS.hideAction;
		DEFAULT_CHAT_FRAME:AddMessage( text, info.r, info.g, info.b, info.id);
		return;
	end
	
	ChatFrame_DisplaySlashHelp("SUPERMACRO");
	return;
end

SlashCmdList["MACRO"] = function(msg)
	if(msg == "") then
		ShowMacroFrame();
	else
		RunMacro(msg);
	end
end

if ( not ChatFrame_DisplaySlashHelp ) then
function ChatFrame_DisplaySlashHelp(pre, start, last, frame)
	if ( not frame ) then
		frame=DEFAULT_CHAT_FRAME;
	end
	local info = ChatTypeInfo["SYSTEM"];
	local i = 1;
	if ( type(start) =="number" ) then i = start; end
	if ( i < 1 ) then i =1; end
	local text = TEXT(getglobal(pre.."_HELP_LINE"..i));
	while text do
		frame:AddMessage(text, info.r, info.g, info.b, info.id);
		i = i + 1;
		text = TEXT(getglobal(pre.."_HELP_LINE"..i));
		if ( last and i > last ) then break; end
	end
end
end -- if