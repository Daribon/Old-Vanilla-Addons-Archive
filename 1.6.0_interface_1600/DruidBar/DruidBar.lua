--[[
Command for the experimental Kaitlin's MiniGroup Suite support is: kmg. Don't use if you don't have it.
Problems that could arise is druidbar getting hidden behind the player frame, or even worse,
they fight to see who comes out on top, thus increasing each frame level higher, causing an insane amount of lag. T.T
still looking for solutions to this, other than changing the xml file. @_@.
Speaking of which, notice the MiniGroup.xml file in this folder? that's my fix to stop it from doing all that lag crap.
(I just removed the toplevel=true from a few key files. it still runs perfect, just not ALWAYS on top)
You're welcome to drag and drop that file into your KMG folder just for trial reasons, but i still need
a better solution. if anyone has any suggestions, please feel free. ^^
and PLEASE, if you're trying this experimental KMG mod, AIM me! (Ska Demon X) I want to hear what you think so far.
]]--
local pre_ShapeshiftBar_ChangeForm, pre_UseAction, pre_MiniGroup_StatusBars_UpdateMana;
local DruidBar_RegenScale = 15;
local regenMultiplier = 1;
local regens, icastbearform = 0;
local Loaded, firstEZ = nil;
--OnLoad. Defines slash commands, Registers events, hooks into the Shapeshift and UseAction functions, and sets up the saved vars for their first run.
function DruidBar_OnLoad()
	SlashCmdList["DBARMENU"] = DruidBar_Main_ChatCommandHandler;
	SLASH_DBARMENU1 = "/DruidBar";
	SLASH_DBARMENU2 = "/dbar";
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_MAXMANA");
	this:RegisterEvent("SPELLCAST_STOP");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	RegisterForSave("DruidBar_Pos");
	RegisterForSave("DruidBarKey");
	RegisterForSave("DruidBarColor");
	pre_ShapeshiftBar_ChangeForm = ShapeshiftBar_ChangeForm;
	ShapeshiftBar_ChangeForm = DruidBar_ChangeForm;
	DruidBar_Print("DruidBar 2.3 - Because nature calls.", 1,1,0);
end
--Hooks into the original UseAction. Passes ChangeForm to shift out of caster.
function DruidBar_UseAction(id, ex, theSelf)
	local texture = GetActionTexture(id);
	local a, b, c, d;
	a = "Interface\\Icons\\Ability_Druid_AquaticForm";
	b = "Interface\\Icons\\Ability_Racial_BearForm";
	c = "Interface\\Icons\\Ability_Druid_CatForm";
	d = "Interface\\Icons\\Ability_Druid_TravelForm";
	e = ".blp";
	if (texture == a or texture == b or texture == c or texture == d or texture == a..e or texture == b..e or texture == c..e or texture == d..e) then
		local fix = DruidBar_ChangeForm(nil);
		if (GetActionText(id) or fix) then
			pre_UseAction(id, ex, theSelf);
		end
	else
		pre_UseAction(id, ex, theSelf);
	end
end
--Change form! whatever you cast, if you're shifted, you'll shift back to caster.
function DruidBar_ChangeForm(id)
	local const = "Interface\\Icons\\Spell_Nature_WispSplode";
	local x = 0;
	for i = 1, 10 do
		if (i <= GetNumShapeshiftForms()) then
			x = GetShapeshiftFormInfo(i);
			if (x == const) then
				id = i;
			end
		end
	end	
	if (id) then
		pre_ShapeshiftBar_ChangeForm(id);
		return nil;
	else
		return true;
	end
end
--Event! Cleaner than the last versions, at least.
function DruidBar_OnEvent(event, a, b)
	if (event == "UNIT_MANA" and a == "player") then
		if (DruidBarKey.Toggle and UnitClass("player") == DRUIDBAR_DRUIDCLASS) then
			DruidBar_GetMultiplier();
			if (dbar_check()) then
				DruidBar_CasterFormUpdate(a);
			else
				DruidBar_ShapeshiftFormUpdate(a);
			end
			DruidBar_SetBarValues();
		end
	elseif (event == "UNIT_MAXMANA" and a == "player") then
		if (DruidBarKey.Toggle and UnitClass("player") == DRUIDBAR_DRUIDCLASS) then
			if (dbar_check()) then
				DruidBarKey.maxmana = UnitManaMax(a);
			end
			DruidBar_GetSpi();
			DruidBar_GetShapeshiftCost();
			DruidBar_SetBarValues();
		end
	elseif (event == "SPELLCAST_STOP") then
		DruidBar_Shift();
		if (not firstEZ) then
			if (DruidBarKey.EZShift) then
				pre_UseAction = UseAction;
				UseAction = DruidBar_UseAction;
			end
			firstEZ = true;
		end
	elseif (event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE") then
		--x drains -20 Mana and bla bla
		if (not dbar_check()) then
			if (strfind(arg1, "drains -.+ Mana")) then
				local x1, x2, x3;
				x1 = strfind(arg1, "-");
				x2 = strfind(arg1, " Mana");
				x3 = strsub(arg1, x1+1, x2 - 1);
				DruidBarKey.keepthemana = DruidBarKey.keepthemana - x3;
			end
		end
	elseif (event == "VARIABLES_LOADED") then
		DruidBar_config();
		DruidBar_setx(DruidBar_Pos.PosX);
		DruidBar_sety(DruidBar_Pos.PosY);
		if(myAddOnsList) then
			myAddOnsList.DruidBar = {name = "Druid Bar", description = "Shows your mana even when shapeshifted", version = "2.2", category = MYADDONS_CATEGORY_CLASS, frame = "DruidBarFrame"};
		end
	end
end
--Print function. Cause every good addon needs one?
function DruidBar_Print(msg,r,g,b,frame,id)
	if ( Print ) then
		Print(msg, r, g, b, frame, id);
		return;
	end
				
	if (not r) then r = 1.0; end
	if (not g) then g = 1.0; end
	if (not b) then b = 0.0; end
	if ( frame ) then 
		frame:AddMessage(msg,r,g,b,id);
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b,id);
		end
	end
end
--Splits stuff up. um. yeah.
function DruidBar_Extract_NextParameter(msg)
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
--Sets the bar width.
function DruidBar_setx(plx)
		local check = tonumber(plx);
		if (DruidBar_Pos.Kaitlin) then
			DruidBarFrame:SetWidth(1);
			PlayerDruidBar:SetWidth(plx);
			PlayerFrameDruidBarLowerBackground1:SetWidth(1);
			DruidBar_Pos.PosX = plx;
		else
			if (check and check > 20) then
				local sillycalc = floor(check / 16);
				DruidBarFrame:SetWidth(check);
				PlayerDruidBar:SetWidth(check - sillycalc);
				PlayerFrameDruidBarLowerBackground1:SetWidth(check - sillycalc);
				DruidBar_Pos.PosX = check;
			else
				DruidBarFrame:SetWidth(160);
				PlayerDruidBar:SetWidth(150);
				PlayerFrameDruidBarLowerBackground1:SetWidth(150);
				DruidBar_Pos.PosX = 160;
			end
		end
end
--Sets the bar height.
function DruidBar_sety(plx)
		local check = tonumber(plx);
		if (DruidBar_Pos.Kaitlin) then
			DruidBarFrame:SetHeight(1);
			PlayerDruidBar:SetHeight(plx);
			PlayerFrameDruidBarLowerBackground1:SetHeight(1);
		else
			if (check and check > 6) then
				local sillycalc = floor(check / 3);
				DruidBarFrame:SetHeight(check);
				PlayerDruidBar:SetHeight(check - sillycalc);
				PlayerFrameDruidBarLowerBackground1:SetHeight(check - sillycalc);
				DruidBar_Pos.PosY = check;
			else
				DruidBarFrame:SetHeight(18);
				PlayerDruidBar:SetHeight(12);
				PlayerFrameDruidBarLowerBackground1:SetHeight(12);
				DruidBar_Pos.PosY = 18;
			end
		end
end
--Innervate multiplier. fun stuff.
function DruidBar_GetMultiplier()
	for j = 1, 10 do
		if (UnitBuff("player",j)) then
			if (not GameTooltipMoneyFrame:IsVisible()) then
				DruidBarSpellCatcher:SetUnitBuff("player", j);
				local msg = DruidBarSpellCatcherTextLeft1:GetText();
				if (strfind(msg,DRUIDBAR_INNERVATE)) then
					regenMultiplier = 5;
					break;
				end
			end
		elseif (not UnitBuff("player",j)) then
			regenMultiplier = 1
			break;
		end
	end
end
--Simple check to return true or false if you're in caster form.
function dbar_check()
	if (UnitPowerType("player") == 0) then
		return true;
	else
		return nil;
	end
end
--Bar color. Lovely shades of purple and blue, but if you see red, your mana's dead!
function DruidBar_SetBarColor()
		local per = (DruidBarKey.keepthemana / DruidBarKey.maxmana);
		local r = 0;
		local b = 1.0;
		if (DruidBarKey.manaColor) then
			r = 1.0 - per;
			if (r < 0) then r = 0; end
			if (r > 1) then r = 1; end
			b = per;
			if (b < 0) then b = 0; end
			if (b > 1) then b = 1; end
		end
		PlayerDruidBar:SetStatusBarColor(r, 0, b);
		PlayerFrameDruidBar:SetStatusBarColor(r, 0, b);
		--[[HEY GUYS! If you're reading the lua, you get a superspecialsecret thinggie!
		Want to change the mana color to one of the values you set your text to show up as?
		do /script DruidBarKey.OptionalKMGManaColor = true;
		That'll make the below line evaluate true, and set the color to be whatever you want on the fly.
		So much fun ^^;
		]]
		if (DruidBarKey.OptionalKMGManaColor) then
			KMGDruidBar:SetStatusBarColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
		else
			KMGDruidBar:SetStatusBarColor(r, 0, b);
		end
		local g = 0;
		if (UnitPowerType("player") == 3) then
			r = 1;
			g = 1;
		elseif (UnitPowerType("player") == 1) then
			r = 1;
			g = 0;
		end
		PlayerFrameREBar:SetStatusBarColor(r, g, 0);
		PlayerFrameREText:SetTextColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
		PlayerFrameDruidText:SetTextColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
		PlayerFrameREText1:SetTextColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
		PlayerFrameDruidText1:SetTextColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
		DruidBarText:SetTextColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
		DruidBarText1:SetTextColor(DruidBarColor.r,DruidBarColor.g,DruidBarColor.b);
end
--What to do when you regen in caster form.
function DruidBar_CasterFormUpdate(a)
	if (not DruidBarKey.Hide and not DruidBarKey.Replace) then
		DruidBarFrame:Show();
	end
	DruidBarKey.keepthemana = UnitMana(a);
	DruidBarKey.maxmana = UnitManaMax(a);
	PlayerDruidBar:SetValue(DruidBarKey.keepthemana);
	PlayerDruidBar:SetMinMaxValues(0,DruidBarKey.maxmana);
	DruidBar_SetBarColor();
	regens = 0;
	icastbearform = 0;
end
--Just a simple Spirit call. so I wouldn't keep typing it.
function DruidBar_GetSpi()
	DruidBarKey.MaxRegen = floor(UnitStat("player",5) / 5) + DruidBar_RegenScale;
end
--Gets the mana cost of your shapeshifting spells.
function DruidBar_GetShapeshiftCost()
	a, b, c, d = GetSpellTabInfo(4);
	for i = 1, c+d, 1 do
		spellname = GetSpellName(i, 1);
		if (spellname ~= nil and strfind(spellname, DRUIDBAR_FORM) and not strfind(spellname, DRUIDBAR_FORMX) and not strfind(spellname, DRUIDBAR_FORMX2)) then
			if (not GameTooltipMoneyFrame:IsVisible()) then
				DruidBarSpellCatcher:SetSpell(i, 1);
				local msg = DruidBarSpellCatcherTextLeft2:GetText();
				local params = msg;
				local index = strfind(params, " ");
				if ( index ) then
					params = strsub(params, 1, index-1);
					msg = strsub(msg, index+1);
					if (strfind(msg, ":")) then
						msg = strsub(msg, strfind(msg, ":") + 1);
					end
				end
				if (GetLocale() == "frFR") then
					DruidBarKey.subtractmana = tonumber(msg);
				else
					DruidBarKey.subtractmana = tonumber(params);
				end
				break;
			end
		end
	end
end
--Enter.
function DruidBar_OnEnter()
	if (DruidBarKey.TextType) then
		DruidBarText1:Show();
	else
		DruidBarText:Show();
	end
end
--Leave
function DruidBar_OnLeave()
	if (not DruidBarKey.Show) then
		DruidBarText:Hide();
		DruidBarText1:Hide();
	end
end
--Enter
function DruidBar1_OnEnter()
	PlayerFrameHealthBarText:Show();
	if (DruidBarKey.TextType) then
		PlayerFrameREText1:Show();
		PlayerFrameDruidText1:Show();
	else
		PlayerFrameREText:Show();
		PlayerFrameDruidText:Show();
	end
end
--Leave. So fun.
function DruidBar1_OnLeave()
	if (not DruidBarKey.Show) then
		PlayerFrameREText:Hide();
		PlayerFrameDruidText:Hide();
		PlayerFrameREText1:Hide();
		PlayerFrameDruidText1:Hide();
	end
	if (UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"].value == "0") then
		PlayerFrameHealthBarText:Hide();
	end
end
--Bar values. bahaha.
function DruidBar_SetBarValues()
	PlayerDruidBar:SetMinMaxValues(0,DruidBarKey.maxmana);
	PlayerDruidBar:SetValue(DruidBarKey.keepthemana);
	PlayerFrameDruidBar:SetMinMaxValues(0,DruidBarKey.maxmana);
	PlayerFrameDruidBar:SetValue(DruidBarKey.keepthemana);
	PlayerFrameREBar:SetMinMaxValues(0,UnitManaMax("player"));
	PlayerFrameREBar:SetValue(UnitMana("player"));
	KMGDruidBar:SetMinMaxValues(0, DruidBarKey.maxmana);
	KMGDruidBar:SetValue(DruidBarKey.keepthemana);
	local persentyesiknowispeltitwrong = DruidBarKey.keepthemana / DruidBarKey.maxmana * 100;
	local rawdata = floor(DruidBarKey.keepthemana).." / "..DruidBarKey.maxmana;
	if (DruidBarKey.Percent) then
	rawdata = rawdata.." - "..floor(persentyesiknowispeltitwrong).."%"
	end
	DruidBarText:SetText(rawdata);
	DruidBarText1:SetText(DruidBarText:GetText());
	local a, b;
	if (DruidBarKey.Percent) then
		a = floor(persentyesiknowispeltitwrong).."%";
		b = floor(UnitMana("player") / UnitManaMax("player") * 100).."%";
	else
		a = floor(DruidBarKey.keepthemana);
		b = floor(UnitMana("player"));
	end
	PlayerFrameDruidText:SetText(a);
	PlayerFrameREText:SetText(b);
	PlayerFrameDruidText1:SetText(a);
	PlayerFrameREText1:SetText(b);
end
--The work done when you're shifted.
function DruidBar_ShapeshiftFormUpdate(a)
	DruidBar_Shift();
	local name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(3, 9);
	local div
	if (DruidBarKey.keepthemana < DruidBarKey.maxmana) then
		if (regens < 3) then
			regens = regens + 1;
			if (rank > 0 and regenMultiplier == 1) then
				div = DruidBarKey.MaxRegen / (rank * 3);
			elseif (rank == 0 or regenMultiplier ~= 1) then
				div = DruidBarKey.MaxRegen;
				if (regenMultiplier == 5) then
					regens = regens + 3;
					div = div + DruidBarKey.MaxRegen;
				end
			end
			DruidBarKey.keepthemana = DruidBarKey.keepthemana + div;
		elseif (regens >= 3) then
			DruidBarKey.keepthemana = DruidBarKey.keepthemana + (DruidBarKey.MaxRegen * regenMultiplier);
		end
	end
	
	if (DruidBarKey.Hide and not DruidBarKey.Replace) then
		DruidBarFrame:Show();
	end
	
	if (DruidBarKey.keepthemana >= DruidBarKey.maxmana - 20) then
		DruidBarKey.keepthemana = DruidBarKey.maxmana;
		if (DruidBarKey.Hide) then
			DruidBarFrame:Hide();
		end
	end
	DruidBar_SetBarColor();
	DruidBar_SetBarValues();
end
--Subtracting mana costs.
function DruidBar_Shift()
	if (not dbar_check() and icastbearform == 0) then
		DruidBarKey.keepthemana = DruidBarKey.keepthemana - DruidBarKey.subtractmana;
		icastbearform = 1;
	elseif (dbar_check()) then
		icastbearform = 0;
	end
end
--Slash commands.
function DruidBar_Main_ChatCommandHandler(msg)
	local commandName, params = DruidBar_Extract_NextParameter(msg);
	if ((commandName) and (strlen(commandName) > 0)) then
		commandName = string.lower(commandName);
	else
		commandName = "";
	end

	if (strfind(commandName,"toggle")) then
		local dyendis = "";
		if (DruidBarKey.Toggle) then
			DruidBarKey.Toggle = nil;
			dyendis = "Disabled";
			DruidBarFrame:Hide();
		else
			DruidBarKey.Toggle = true;
			dyendis = "Enabled";
			DruidBarFrame:Show();
		end
		DruidBar_Print("Druid Bar is "..dyendis);
	elseif (strfind(commandName, "showtext")) then
		local dyendis = "";
		if (DruidBarKey.Show) then
			DruidBarKey.Show = nil;
			dyendis = "Disabled";
		else
			DruidBarKey.Show = true;
			dyendis = "Enabled";
		end
		DruidBar_Print("Permanant Text "..dyendis);
	elseif (strfind(commandName, "update")) then
		DruidBar_GetSpi();
		DruidBar_GetShapeshiftCost();
		DruidBar_GetMultiplier();
		DruidBar_SetBarValues();
		DruidBar_SetBarColor();
	elseif (strfind(commandName, "lock")) then
		if (DruidBarKey.Lock) then
			DruidBarKey.Lock = nil;
			DruidBarDontMove:Hide();
			DruidBar_Print("Druid Bar Unlocked!",1,1,0);
		else
			DruidBarKey.Lock = true;
			DruidBarDontMove:Show();
			DruidBar_Print("Druid Bar Locked!",1,1,0);
		end
	elseif (strfind(commandName, "hide")) then
		if (DruidBarKey.Hide) then
			DruidBarKey.Hide = nil;
			DruidBar_Print("Druid Bar shown all the time",1,1,0);
		else
			DruidBarKey.Hide = true;
			DruidBarFrame:Show();
			DruidBar_Print("Druid Bar hidden in Caster form",1,1,0);
		end
	elseif (strfind(commandName, "replace")) then
		if (DruidBarKey.Replace) then
			DruidBarKey.Replace = nil;
			DruidBar_Print("Druid Bar will replace the mana bar when shifted",1,1,0);
		else
			DruidBarKey.Replace = true;
			DruidBar_Print("Using draggable manabar",1,1,0);
		end
	elseif (strfind(commandName, "percent")) then
		if (DruidBarKey.Percent) then
			DruidBarKey.Percent = nil;
			DruidBar_Print("Replace will now display in raw numbers",1,1,0);
		else
			DruidBarKey.Percent = true;
			DruidBar_Print("Replace will now display in percent",1,1,0);
		end
	elseif (strfind(commandName, "changex")) then
		DruidBar_setx(params);
	elseif (strfind(commandName, "changey")) then
		DruidBar_sety(params);
	elseif (strfind(commandName, "playerframe")) then
		if (DruidBar_Pos.On) then
			DruidBar_setx(150);
			DruidBar_sety(18);
			DruidBarFrame:ClearAllPoints();
			DruidBarFrame:SetPoint("TOPLEFT","PlayerFrame","TOPLEFT", 80, -63);
			DruidBarFrame:SetFrameLevel("1");
			PlayerDruidBar:SetFrameLevel("1");
			DruidBarKey.Lock = true;
			DruidBarDontMove:Show();
			DruidBar_Pos.On = nil;
			DruidBar_Print("Docking to the PlayerFrame");
		else
			DruidBar_setx(160);
			DruidBar_sety(18);
			DruidBarFrame:ClearAllPoints();
			DruidBarFrame:SetPoint("CENTER","UIParent","CENTER", 0, 0);
			DruidBarFrame:SetFrameLevel("16");
			PlayerDruidBar:SetFrameLevel("15");
			DruidBarKey.Lock = nil;
			DruidBarDontMove:Hide();
			DruidBar_Pos.On = true;
			DruidBar_Print("Undocking from the PlayerFrame");
		end
	elseif (strfind(commandName, "texttype")) then
		if (DruidBarKey.TextType) then
			DruidBarKey.TextType = nil;
			DruidBar_Print("Original Text");
		else
			DruidBarKey.TextType = true;
			DruidBar_Print("Outlined text.");
		end
		DruidBar_TypeShow();
	elseif (strfind(commandName, "textcolor")) then
		DruidBar_SetTextColors(params);
	elseif (strfind(commandName, "kmg")) then
		if (DruidBar_Pos.Kaitlin) then
			DruidBar_Pos.Kaitlin = nil;
			if (MGplayer_ManaBar) then
				MGplayer_ManaBar:SetWidth(MGplayer_HealthBar:GetWidth());
				MGplayer_ManaBar:ClearAllPoints();
				MGplayer_ManaBar:SetPoint("TOP","MGplayer_HealthBar","BOTTOM",0,-2);
			end
			DruidBarKey.Lock = nil;
			DruidBarKey.Hide = nil;
			DruidBarKey.Show = true;
			DruidBarDontMove:Hide();
			DruidBarKMG:Hide();
			DruidBarFrame:Show();
			DruidBar_Print("Using normal bar",1,1,0);
		else
			if (MGplayer_ManaBar) then
				DruidBarKey.Hide = nil;
				DruidBarKey.Lock = true;
				DruidBarKey.Show = nil;
				DruidBarDontMove:Hide();
				DruidBarFrame:Hide();
				DruidBar_Pos.Kaitlin = true;
				DruidBar_Print("Replacing Kaitlin's MiniGroup Suite",1,1,0);
			else
				DruidBar_Print("KMG not detected? Don't use if you don't have!",1,1,0);
			end
		end
	elseif(strfind(commandName, "ezshift")) then
		if (DruidBarKey.EZShift) then
			DruidBar_Print("Removing fast shapeshift functionality from the actionbar",1,1,0);
			DruidBarKey.EZShift = nil;
			UseAction = pre_UseAction;
		else
			DruidBar_Print("Moving fast shapeshift functionality to the actionbar",1,1,0);
			DruidBarKey.EZShift = true;
			pre_UseAction = UseAction;
			UseAction = DruidBar_UseAction;
		end
	elseif (strfind(commandName, "barcolor")) then
		if (DruidBarKey.manaColor) then
			DruidBarKey.manaColor = nil;
			DruidBar_Print("Mana bar will stay blue all the time",1,1,0);
		else
			DruidBarKey.manaColor = true;
			DruidBar_Print("Mana bar will change color depending on how low your mana is.",1,1,0);
		end
	elseif (strfind(commandName, "function")) then
		DruidBar_Print(DRUIDBAR_CHAT_FUNCTIONAL_USAGE,1,1,0);
	elseif (strfind(commandName, "cosmetic")) then
		DruidBar_Print(DRUIDBAR_CHAT_COSMETIC_USAGE,1,1,0);
	else
		DruidBar_Print(DRUIDBAR_CHAT_COMMAND_USAGE,1,1,0);
	end
end
--To make sure variables are configured properly.
function DruidBar_config()
	if (DruidBarKey and DruidBar_Pos and DruidBarColor) then
	else
		DruidBarKey = {Toggle, Show, Lock, MaxRegen, subtractmana, keepthemana, maxmana, Hide, Replace, Percent, TextType, EZShift, manaColor};
		DruidBarKey.Toggle = true;
		DruidBarKey.Show = nil;
		DruidBarKey.Lock = nil;
		DruidBarKey.MaxRegen = 0;
		DruidBarKey.subtractmana = 0;
		DruidBarKey.keepthemana = 1;
		DruidBarKey.maxmana = 10;
		DruidBarKey.Hide = true;
		DruidBarKey.Replace = true;
		DruidBarKey.Percent = true;
		DruidBarKey.TextType = nil;
		DruidBarKey.EZShift = nil;
		DruidBarKey.manaColor = true;
		DruidBar_Pos = {On, PosX,PosY,Kaitlin};
		DruidBar_Pos.On = true;
		DruidBar_Pos.PosX = 160;
		DruidBar_Pos.PosY = 18;
		DruidBarColor = {r, g, b};
		DruidBarColor.r = 1;
		DruidBarColor.g = 1;
		DruidBarColor.b = 1;
	end
	Loaded = true;
end
--For text bars.
function DruidBar_TypeShow()
	if (DruidBarKey.TextType) then
		PlayerFrameDruidText:Hide();
		PlayerFrameREText:Hide();
		PlayerFrameDruidText1:Show();
		PlayerFrameREText1:Show();
	else
		PlayerFrameDruidText:Show();
		PlayerFrameREText:Show();
		PlayerFrameDruidText1:Hide();
		PlayerFrameREText1:Hide();
	end
end
--OnUpdate. I hate this function, for reasons noone shall ever know.
function DruidBar_OnUpdate(elapsed)
		if (DruidBarKey.Toggle and UnitClass("player") == DRUIDBAR_DRUIDCLASS) then
			DruidBar_SetBarValues();
			DruidBar_SetBarColor();
			DruidBar_TypeShow();
			if (DruidBarKey.Replace and not DruidBar_Pos.Kaitlin) then
				DruidBarReplacetheManaBar:Hide();
				DruidBarKMG:Hide();
				PlayerFrameManaBar:Show();
				DruidBarFrame:SetScale(PlayerFrameManaBar:GetScale());
				if (not DruidBarKey.Hide) then
					DruidBarFrame:Show();
				else
					if (dbar_check()) then
						DruidBarFrame:Hide();
					else
						if (DruidBarKey.keepthemana == DruidBarKey.maxmana) then
							DruidBarFrame:Hide();
						else
							DruidBarFrame:Show();
						end
					end
				end
			elseif (DruidBar_Pos.Kaitlin) then
				if (MGplayer_ManaBar) then
					DruidBarReplacetheManaBar:Hide();
					DruidBarFrame:Hide();
					if (dbar_check()) then
						MGplayer_ManaBar:SetWidth(MGplayer_HealthBar:GetWidth());
						MGplayer_ManaBar:ClearAllPoints();
						MGplayer_ManaBar:SetPoint("TOP","MGplayer_HealthBar","BOTTOM",0,-2);
						DruidBarKMG:Hide();
					else
						KMGDruidBar:SetWidth(MGplayer_HealthBar:GetWidth() / 2);
						KMGDruidBar:SetHeight(MGplayer_ManaBar:GetHeight());
						MGplayer_ManaBar:SetWidth(MGplayer_HealthBar:GetWidth() / 2);
						DruidBarKMG:Show();
						DruidBarKMG:ClearAllPoints();
						MGplayer_ManaBar:ClearAllPoints();
						MGplayer_ManaBar:SetPoint("TOPLEFT","MGplayer_HealthBar","BOTTOMLEFT",0,-2);
						local points = MGplayer_HealthBar:GetWidth() / 4 * 3;
						if (MGplayer_HealthBar:GetWidth() <= 92) then points = points - 2; else points = points - 1; end
						DruidBarKMG:SetScale(MGplayer_HealthBar:GetScale());
						DruidBarKMG:SetPoint("LEFT","MGplayer_ManaBar","LEFT", points, 0);
						DruidBarKMG:SetFrameLevel("1");
						KMGDruidBar:SetFrameLevel(MGplayer_ManaBar:GetFrameLevel());
						--local x = MGplayer_ManaText:GetText();
						if (DruidBarKey.Percent and MGplayer_HealthBar:GetWidth() <= 92) then
							local curstat = (UnitMana("player") / UnitManaMax("player") * 100);
							local manstat = (floor(DruidBarKey.keepthemana / DruidBarKey.maxmana * 100)).."%";
							MGplayer_ManaText:SetText(curstat.."/"..manstat);
						elseif (MGplayer_HealthBar:GetWidth() <= 92) then
							local curstat = UnitMana("player");
							MGplayer_ManaText:SetText(curstat.."/"..floor(DruidBarKey.keepthemana));
						end
					end
				else
					DruidBar_Pos.Kaitlyn = nil;
				end
			elseif (not DruidBar_Pos.On) then
				DruidBar_setx(150);
				DruidBar_sety(18);
				DruidBarFrame:ClearAllPoints();
				DruidBarFrame:SetPoint("TOPLEFT","PlayerFrame","TOPLEFT", 80, -63);
				DruidBarFrame:SetFrameLevel("1");
				PlayerDruidBar:SetFrameLevel("1");
				DruidBarDontMove:Show();
				DruidBarFrame:Show();
				DruidBarFrame:SetScale(PlayerFrameManaBar:GetScale());
			else
				DruidBarFrame:Hide();
				DruidBarKMG:Hide();
				if (dbar_check()) then
					DruidBarReplacetheManaBar:Hide();
					PlayerFrameManaBar:Show();
					if (UIOptionsFrameCheckButtons["STATUS_BAR_TEXT"].value == "1") then
						PlayerFrameManaBarText:Show();
					end
				else
					DruidBarReplacetheManaBar:Show();
					PlayerFrameManaBar:Hide();
					PlayerFrameManaBarText:Hide();
					if (DruidBarKey.Show) then
						DruidBar_TypeShow();
					end
				end
			end
			if (DruidBarKey.Lock) then
				DruidBarDontMove:Show();
			elseif (not DruidBarKey.Lock) then
				DruidBarDontMove:Hide();
			end
			if (DruidBarKey.TextType) then
				DruidBarText:Hide();
				if (DruidBarFrame:IsVisible() and DruidBarKey.Show) then
					DruidBarText1:Show();
				elseif (not DruidBarKey.Show and DruidBarText1:IsVisible() and not MouseIsOver(DruidBarFrame)) then
					DruidBarText1:Hide();
				end
			else
				DruidBarText1:Hide();
				if (DruidBarFrame:IsVisible() and DruidBarKey.Show) then
					DruidBarText:Show();
				elseif (not DruidBarKey.Show and DruidBarText:IsVisible() and not MouseIsOver(DruidBarFrame)) then
					DruidBarText:Hide();
				end
			end
		else
		DruidBarFrame:Hide();
		DruidBarReplacetheManaBar:Hide();
		end
end

function DruidBar_SetTextColors(par)
	if (strfind(par, "red")) then
	DruidBarColor.r = 1;
	DruidBarColor.g = 0;
	DruidBarColor.b = 0;
	elseif (strfind(par, "orange")) then
	DruidBarColor.r = 1;
	DruidBarColor.g = 0.5;
	DruidBarColor.b = 0;
	elseif (strfind(par, "yellow")) then
	DruidBarColor.r = 1;
	DruidBarColor.g = 1;
	DruidBarColor.b = 0;
	elseif (strfind(par, "green")) then
	DruidBarColor.r = 0;
	DruidBarColor.g = 1;
	DruidBarColor.b = 0;
	elseif (strfind(par, "blue")) then
	DruidBarColor.r = 0;
	DruidBarColor.g = 0;
	DruidBarColor.b = 1;
	elseif (strfind(par, "purple")) then
	DruidBarColor.r = 0.5;
	DruidBarColor.g = 0;
	DruidBarColor.b = 1;
	elseif (strfind(par, "pink")) then
	DruidBarColor.r = 1;
	DruidBarColor.g = 0;
	DruidBarColor.b = 1;
	elseif (strfind(par, "brown")) then
	DruidBarColor.r = 0.7;
	DruidBarColor.g = 0.5;
	DruidBarColor.b = 0.6;
	elseif (strfind(par, "white")) then
	DruidBarColor.r = 1;
	DruidBarColor.g = 1;
	DruidBarColor.b = 1;
	elseif (strfind(par, "black")) then
	DruidBarColor.r = 0;
	DruidBarColor.g = 0;
	DruidBarColor.b = 0;
	elseif (strfind(par, "original")) then
	DruidBarColor.r = 1;
	DruidBarColor.g = 0.82;
	DruidBarColor.b = 0;
	elseif (strfind(par, "r")) then
		local letter, number = DruidBar_Extract_NextParameter(par);
		number = tonumber(number);
		if (number and number >= 0 and number <= 1) then
			DruidBarColor.r = number;
		end
	elseif (strfind(par, "g")) then
		local letter, number = DruidBar_Extract_NextParameter(par);
		number = tonumber(number);
		if (number and number >= 0 and number <= 1) then
			DruidBarColor.g = number;
		end
	elseif (strfind(par, "b")) then
		local letter, number = DruidBar_Extract_NextParameter(par);
		number = tonumber(number);
		if (number and number >= 0 and number <= 1) then
			DruidBarColor.b = number;
		end
	elseif (strfind(par, "set")) then
		local theset, red = DruidBar_Extract_NextParameter(par);
		local red, green = DruidBar_Extract_NextParameter(red);
		local green, blue = DruidBar_Extract_NextParameter(green);
		red = tonumber(red);
		green = tonumber(green);
		blue = tonumber(blue);
		if (red and red >= 0 and red <= 1) then
			DruidBarColor.r = red;
		end
		if (green and green >= 0 and green <= 1) then
			DruidBarColor.g = green;
		end
		if (blue and blue >= 0 and blue <= 1) then
			DruidBarColor.b = blue;
		end
	else
		DruidBar_Print(DRUIDBAR_CHAT_TEXTCOLOR_USE,1,1,0);
	end
	DruidBar_SetBarColor();
end