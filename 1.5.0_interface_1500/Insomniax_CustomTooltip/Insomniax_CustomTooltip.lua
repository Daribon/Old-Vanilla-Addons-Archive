--[[

Note: This is a modified version of Custom Tooltip v.97e for the Insomniax Recompilation, tweaked by LedMirage 05/05/2005

Insomniax v1.3 (5/12/2005 by LedMirage)
*Fixed an annoying popup error when you moused over certain NPC's with a Title, for example summoned NPC pets or NPC with 3 lines of text in their tooltips 
 and the second one was a title / profession. This fix also allows NPC's that meet this circumstances to display their profession / title on their tooltip.

Insomniax v1.2 (5/05/2005 by LedMirage)
*Removed unnecessary text (race, PvP enabled) displayed when a target is dead
*Removed "PvP Disabled" text when using %f, "PvP Enabled" will only show when tooltip target is PvP Enabled
*Removed Tapped from showing on neutral critters
*Made the tooltip X,Y offset be more accurate (it was offset on some resolutions)
*Added a new code %P for showing friendly NPC profession
*Added a new code %k for showing the "Skinnable" text
*Title (%t) now returns honor rank titles
*Changed default load set to reflect fixes and changes, also added a new default load option for IX v1.56

Insomniax v1.1 (3/24/2005 by LedMirage)
*If level returned is -1 then the text shown will say "Hidden" instead of -1
*If a target is friendly/non-hostile then the text color for level (%l) will be the same yellow color blizzard specified.
*WorldBoss is now returned instead of a -1 when hovering over a worldboss


Insomniax v1.0 (3/16/2005 by LedMirage)
*Replaced function to get level text color with the correct one from blizzard
*Added Reset button
*Made the default scheme to be the Insomniax one
*Tweaked Text on buttons
*Fixed bug that didn't display other player's pets as such
*Fixed all pop up bugs found in original v.97e
*Added Insomniax Schemes to save/load list
*Moved saved variables to the .TOC file removing all register for save calls

]]

CustomTooltip_DEBUG = 0;
CustomTooltip_VERSION = "Insomniax 1.3";
CustomTooltip_LastVersion = nil;
CustomTooltip_Enabled = 1;
CustomTooltip_Text = "-1,n,0|%t %n %e\n-1,n,0|%G\n-1,n,0|%P\n-1,l,0|Level %l %r %p\n%d\n-1,k,0|%k\n%f\n%C %T\n-2,n,0|";

CustomTooltip_BGCOLOR = { r = 1; b = 1; g = 1; };
CustomTooltip_FONTSIZE = 16;
CustomTooltip_OLDSETANCHOR = nil;
CustomTooltip_BuiltInText = {
	["Insomniax v1.56"] = "-1,n,0|%t %n %e\n-1,n,0|%G\n-1,n,0|%P\n-1,l,0|Level %l %r %p\n%d\n-1,k,0|%k\n%f\n%C %T\n-2,n,0|",
	["Insomniax v1.53"] = "-1,n,0|%n %e\n-1,n,0|%G\n-1,l,0|Level %l %t\n%r %p %f\n%C %T\n-2,n,0|",
	["Insomniax v1.52"] = "-1,n,0|%n %e\n-1,l,0|Level %l %r %p\n-1,l,0|%t\n-1,g,0|%G\n%C %f %T\n-2,n,l|",
	["Insomniax v1.50"] = "-1,l,0|%n, %l %p\n-1,g,0|%G\n%C %t\n-1,g,0|%e %r %f %T\n-2,n,0|",
	["CTT Style"] = "-1,l,0|%n, %l %p\n-1,g,0|%G\n%C %t\n-2,n,0|";
	["WoW Old Style"] = "-2,f,0|\n%n\n%c %t\nLevel %l %r %p %h\n%f";
	["WoW New Style"] = "-1,n,0|%n\n%t\n-1,l,0|Level %l %r %p %h\n%C\n%f";
};

CustomTooltip_CustomText = {
};

CustomTooltip_DefOptions = {
	-- 0 = don't, 1 = mouse, 2 = position w/offset
	["relocateTooltip"] = 2;
	["relocateX"] = 0;
	["relocateY"] = 0.04;
	["relocatePos"] = "TOP";
};
CustomTooltip_Options = CustomTooltip_DefOptions;


CustomTooltip_DefColors = {
	-- default is white 
	["default"] = { r = 1; g = 1; b = 1; };

	["partymate"] = { r = 0.5; g = 0.9; b = 1.0; };
	["guildmate"] = { r = 0.5; g = 1.0; b = 0.75; };

	["friendpc"] = { r = 0.5; g = 0.65; b = 1.0; };
	["friendnpc"] = { r = 0.3; g = 0.9; b = 0.3; };
	["pet"] = { r = .45; g = 0.45; b = 0.9; };

	-- enemies are red
	["enemypc"] = { r = 0.8; g = 0.2; b = 0.75; };
	["enemynpc"] = { r = 0.9; g = 0.3; b = 0.3; };

	-- neutral are yellow
	["neutral"] = { r = 1.0; g = 0.85; b = 0.0; };

	-- used for %f color
	-- hostile is red
	["hostile"] = { r = .9; g = 0.3; b = 0.3; };
	-- nopvp (friends and enemies) is blue
	["nopvp"] = { r = .3; g = 0.3; b = 0.9; };
	-- friends with pvp on is green
	["friendpvp"] = { r = 0.1; g = 0.9; b = 0.1; };
};


CustomTooltip_Colors = CustomTooltip_DefColors;

CustomTooltip_CodeCallback = {};
CustomTooltip_CodeColorCallback = {};
CustomTooltip_CodeInfo = {};
CustomTooltip_CodeColorInfo = {};

CustomTooltip_TITLE = "";
CustomTooltip_CITY = "";
CustomTooltip_BEASTLORE = "";
CustomTooltip_PROFESSION = "";
CustomTooltip_SKINNABLE = "";

--[[ Removed by LedMirage and added to TOC file 3/01/2005
RegisterForSave("CustomTooltip_Enabled");
RegisterForSave("CustomTooltip_Text");
RegisterForSave("CustomTooltip_Options");
RegisterForSave("CustomTooltip_Colors");
RegisterForSave("CustomTooltip_CustomText");
RegisterForSave("CustomTooltip_LastVersion");
]]

-- I really like sea, its too bad not everyone has it
function CustomTooltip_debug(...)
	if(CustomTooltip_DEBUG ~= 1) then
		return;
	end
	
	for i=1, table.getn(arg), 1 do
		if(arg[i] == nil) then
			arg[i] = "(nil)";
		end	
	end
	ChatFrame1:AddMessage("Custom Tooltip: "..table.concat(arg), 1, 1, 0);
end

function CustomTooltip_OnLoad()

	if(ChatFrame2) then
		ChatFrame2:AddMessage("|cff748BFFInsomniax Custom Tooltip v1.3 Loaded|r");
	else
		if ( DEFAULT_CHAT_FRAME ) then 
			DEFAULT_CHAT_FRAME:AddMessage("|cff748BFFInsomniax Custom Tooltip v1.3 Loaded|r");
		end
	end

	if(CustomTooltip_DEBUG == 1) then
		CustomTooltip_debug("CustomTooltip Debug Mode enabled");
	end
	
	-- add codes
	CustomTooltip_AddCode("n", CustomTooltip_getName, "Name");
	CustomTooltip_AddCode("l", CustomTooltip_getLevel, "Level");
	CustomTooltip_AddCode("c", CustomTooltip_getClass, "Class");
	CustomTooltip_AddCode("g", CustomTooltip_getGuild, "Guild");
	CustomTooltip_AddCode("G", CustomTooltip_getFormattedGuild, "Guild, with <>");
	CustomTooltip_AddCode("r", CustomTooltip_getRace, "Race");
	CustomTooltip_AddCode("C", CustomTooltip_getCity, "City");
	CustomTooltip_AddCode("t", CustomTooltip_getTitle, "Title");
	CustomTooltip_AddCode("p", CustomTooltip_getPlayerClass, "Class (if PC)");
	CustomTooltip_AddCode("m", CustomTooltip_getManaPct, "Mana Percent, with %");
	CustomTooltip_AddCode("h", CustomTooltip_getIsPlayer, "(Player) Text");
	CustomTooltip_AddCode("f", CustomTooltip_getIsPvP, "PvP Enabled Text");
	CustomTooltip_AddCode("e", CustomTooltip_getElite, "(Elite) Text");
	CustomTooltip_AddCode("T", CustomTooltip_getTapped, "(Tapped) if tapped");
	CustomTooltip_AddCode("d", CustomTooltip_getIsCorpse, "Corpse Text");
	-- LedMirage 5/03/2005
	CustomTooltip_AddCode("P", CustomTooltip_getProfession, "NPC Profession Title");
	CustomTooltip_AddCode("k", CustomTooltip_getSkinnable, "Skinnable text");
	
	
	
	-- add color callbacks
	CustomTooltip_AddCodeColor("n", CustomTooltip_getNameColor, "Enhanced coloring based on reaction (enemy, guild, etc)");
	CustomTooltip_AddCodeColor("f", CustomTooltip_getPVPColor, "Default coloring: red, green, yellow, blue");
	CustomTooltip_AddCodeColor("l", CustomTooltip_getLevelColor, "Color by level difference");
	--CustomTooltip_AddCodeColor("c", CustomTooltip_getClassColor, "Color by class, );
	CustomTooltip_AddCodeColor("g", CustomTooltip_getGuildColor, "Color by guild (KoS, allies, own)");
	-- LedMirage 5/03/2005
	CustomTooltip_AddCodeColor("k", CustomTooltip_getSkinnableColor, "Color by Skinning skill");
	
	SlashCmdList["CUSTOMTTSTATE"] = function(...) if(arg[1] == "on") then CustomTooltip_Enabled = 1; else CustomTooltip_Enabled = 0; end end
	SLASH_CUSTOMTTSTATE1 = "/ctt";
	
	SlashCmdList["CUSTOMTTDISPTEXT"] = function(...) if(strlen(arg[1]) == 0) then CustomTooltipFrame:Show(); else CustomTooltip_Text = CustomTooltip_fixInput(arg[1]); end end
	SLASH_CUSTOMTTDISPTEXT1 = "/tooltip";
	
	-- redirect the tooltip set anchor function to use ours
	CustomTooltip_OLDSETANCHOR = GameTooltip_SetDefaultAnchor;
	GameTooltip_SetDefaultAnchor = CustomTooltip_SetDefaultAnchor;
	
	--CustomTooltip_setRelocate(CustomTooltip_Options.relocateTooltip);
end

function CustomTooltip_fixInput(msg)
	msg = string.gsub(msg, "\\n", "\n");
	return msg;
end

function CustomTooltip_OnVarLoad()
	CustomTooltip_debug("vars loaded");
	if(CustomTooltip_VERSION ~= CustomTooltip_LastVersion) then
		ChatFrame1:AddMessage("CustomTooltip: Fixing version mismatch, some of your Colors or Options may be lost", 1, 1, 0);
		table.foreach(CustomTooltip_DefColors, 
					function(i, v) if(CustomTooltip_Colors[i] == nil) then
						CustomTooltip_Colors[i] = v;
					end
					end
		);
		
		table.foreach(CustomTooltip_DefOptions,
					function(i, v) if(CustomTooltip_Options[i] == nil) then
						CustomTooltip_Options[i] = v;
					end
					end
		);
		
		CustomTooltip_LastVersion = CustomTooltip_VERSION;
	end
	--CustomTooltip_setRelocate(CustomTooltip_Options.relocateTooltip);
end

function CustomTooltip_OnEvent()
	
	local processedline, text, matched;
	CustomTooltip_findBeastLore();
	CustomTooltip_findCity();
	CustomTooltip_findTitle();
	-- LedMirage
	CustomTooltip_findProfession();
	CustomTooltip_findSkinnable();
	GameTooltip:ClearLines();
	processedline = string.gsub(CustomTooltip_Text, "%%(.)", CustomTooltip_processCode);
	string.gsub(processedline.."\n", "(.-)\n", CustomTooltip_dispLine);
	
	if(CustomTooltip_BEASTLORE ~= nil) then
		table.foreach(CustomTooltip_BEASTLORE, function(i,v) GameTooltip:AddLine(v, CustomTooltip_Colors["default"].r, CustomTooltip_Colors["default"].g, CustomTooltip_Colors["default"].b); end );
	end
	
	CustomTooltip_resize();
	
end

function CustomTooltip_SetDefaultAnchor(tooltip, parent)
	if(CustomTooltip_Options.relocateTooltip ~= 0 ) then
		GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		if(CustomTooltip_Options.relocateTooltip == 1) then
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		elseif(CustomTooltip_Options.relocateTooltip == 2) then
			-- LedMirage 5/02/2005
			
			GameTooltip:SetPoint(CustomTooltip_Options.relocatePos, "UIParent", CustomTooltip_Options.relocatePos, ( (GetScreenWidth() / 200) * (CustomTooltip_Options.relocateX) ), -( (GetScreenHeight() / 200) * (CustomTooltip_Options.relocateY) ) );
			-- GameTooltip:SetPoint(CustomTooltip_Options.relocatePos, "UIParent", CustomTooltip_Options.relocatePos, ((CustomTooltip_Options.relocateX) * 1024), -(CustomTooltip_Options.relocateY * 1024));
		end
	else
		CustomTooltip_OLDSETANCHOR(tooltip, parent);
	end
end


function CustomTooltip_AddCode(code, callback, info)
	CustomTooltip_CodeCallback[code] = callback;
	CustomTooltip_CodeInfo[code] = "%"..code..": "..info;
end

function CustomTooltip_AddCodeColor(code, callback, info)
	CustomTooltip_CodeColorCallback[code] = callback;
	CustomTooltip_CodeColorInfo[code] = code..": "..info;
end

function CustomTooltip_processCode(code)
	if(CustomTooltip_CodeCallback[code] == nil) then
		return "%"..code;
	end
	return CustomTooltip_CodeCallback[code]();
end

function CustomTooltip_dispLine(line)
	--CustomTooltip_debug("Line: ", line);
	if(strlen(line) == 0) then
		return;
	end;
	
	local r,g,b, text, matched;
	local code;
	
	text, matched = string.gsub(line, "(%S-),(%S-),(%S-)|(.*)", "%4");
	if(matched == 0) then
		--CustomTooltip_debug("Using defaults");
		r = CustomTooltip_Colors["default"].r;
		g = CustomTooltip_Colors["default"].g;
		b = CustomTooltip_Colors["default"].b;
	else
		-- fix odd trailing character bug.  Only happens when you
		-- input from within the game...
		text = string.gsub(text, "^|", "");
		
		r, matched = string.gsub(line, "(%S-),(%S-),(%S-)|(.*)", "%1");
		g, matched = string.gsub(line, "(%S-),(%S-),(%S-)|(.*)", "%2");
		b, matched = string.gsub(line, "(%S-),(%S-),(%S-)|(.*)", "%3");
		--CustomTooltip_debug("Got Colors: ",r,",",g,",",b);
		if(text == "bg") then
			CustomTooltip_setBG(r, g, b);
			return;
		elseif(text == "border") then
			CustomTooltip_setBGBorder(r, g, b);
			return;
		end
		
		if(r == "-1") then
			code = g;
			--fontsize = b;
			fontsize = 0;
			r, g, b = CustomTooltip_getCodeColor(code);
			
		elseif(r == "-2") then
			-- background
			code = g;
			if(code ~= "0") then	
				CustomTooltip_setBG(CustomTooltip_getCodeColor(code));
			end
			
			-- border
			code = b;
			if(code ~= "0") then
				CustomTooltip_setBGBorder(CustomTooltip_getCodeColor(code));
			end
			
			-- text color
			r = CustomTooltip_Colors["default"].r;
			g = CustomTooltip_Colors["default"].g;
			b = CustomTooltip_Colors["default"].b;
		end
	end
	
	empty = string.gsub(text, "%s", "");
	
	if(strlen(empty) ~= 0) then
		-- remove preceeding whitespace
		text = string.gsub(text, "^%s+", "");
		--CustomTooltip_debug("Adding: ",r,",",g,",",b," ", text);
		GameTooltip:AddLine(text, r, g, b);
				
		if(fontsize ~= nil and fontsize ~= 0) then
			--("GameTooltipTextLeft"..GameTooltip:NumLines()):SetTextHeight(fontsize);
		end
	end
end

function CustomTooltip_findCity()
	CustomTooltip_CITY = nil;
	-- if its dead, doesn't exist, is a player,
	-- an enemy, (not a player but player controlled (pet)), or there are less
	-- than 2 lines, it has no city.
	
	local city, matched;
	if(UnitIsDead("mouseover") or not UnitExists("mouseover") or UnitIsPlayer("mouseover") or UnitIsEnemy("mouseover", "player")
		or (not UnitIsPlayer("mouseover") and UnitPlayerControlled("mouseover")) or GameTooltip:NumLines() <= 2
	) then
		CustomTooltip_CITY = nil;
		return nil;
	end
	
	-- AFAIK, city is always after level, and before PVP status
	city, matched = string.gsub(GameTooltipTextLeft3:GetText(), "Level.*", "");
	if(matched == 1) then
		if ( GameTooltip:NumLines() >= 4 ) then
			city, matched = string.gsub(GameTooltipTextLeft4:GetText(), "PvP.*", "");
			-- if it didn't match, then its the city OR lore info
			if(matched == 1) then
				city = nil;
			end
			-- if it didn't match, it must be a city
			city, matched = string.gsub(GameTooltipTextLeft4:GetText(), ".* Damage", "");
			if(matched == 1) then
				city = nil;
			end
		end
	else
		city, matched = string.gsub(GameTooltipTextLeft3:GetText(), "PvP.*", "");
		if(matched == 1) then
			city = nil;
		end
	end
	CustomTooltip_CITY = city;
	return city;
end

function CustomTooltip_findTitle()
	CustomTooltip_TITLE = nil;
	-- local title, matched;
	
	-- LedMirage 5/05/2005
	local title = GetPVPRankInfo(UnitPVPRank("mouseover"));
	if ( not title ) then
		title = "";
	elseif UnitIsPlayer("mouseover") then
			CustomTooltip_TITLE = title;
			return CustomTooltip_TITLE;
	end
	
	if(not UnitExists("mouseover") or UnitIsPlayer("mouseover") or UnitIsEnemy("mouseover", "player")) then
		CustomTooltip_TITLE = nil;
		return nil;
	end

	CustomTooltip_TITLE = title;
	return title;
end

function CustomTooltip_findSkinnable()
	CustomTooltip_SKINNABLE = nil;
	if(UnitIsDead("mouseover") and GameTooltip:NumLines() >= 3) then
		if(GameTooltipTextLeft3:GetText() == "Skinnable") then
			CustomTooltip_SKINNABLE = "Skinnable";
			return CustomTooltip_SKINNABLE;
		end
	end
end

function CustomTooltip_findProfession()
	CustomTooltip_PROFESSION = nil;
	local profession, matched;

	-- or UnitIsEnemy("mouseover", "player")
	if(not UnitExists("mouseover") or UnitIsPlayer("mouseover") ) then
		CustomTooltip_PROFESSION = nil;
		return nil;
	end
		
	profession, matched = string.gsub(GameTooltipTextLeft2:GetText(), "Level.*", "");
	if(matched == 1) then
		profession = "";
	end

	CustomTooltip_PROFESSION = profession;
	return profession;
end




function CustomTooltip_findBeastLore()
	CustomTooltip_BEASTLORE = {};
	local text, matched, starti;
	-- 8 = 6 info + level + name, at minimum
	--[[
		Damage starts on line 3-5
		and lore info is anywhere from 5-6 lines (it seems)	
	]]
	if(UnitCreatureType("mouseover") == "Beast" and GameTooltip:NumLines() >= 3) then
		-- it could start on 3 (untamed), 4 (player pet), or 5 (faction name w/title)
		-- not sure on 5th, but we'll check to make sure
				
		for i=3, 5, 1 do
			-- if(getglobal("GameTooltipTextLeft"..i) ~= nil) then
			if(getglobal("GameTooltipTextLeft"..i):GetText() ~= nil) then
				text, matched = string.gsub(getglobal("GameTooltipTextLeft"..i):GetText(), ".* Damage", "");
				if(matched == 1) then
					starti = i;
					CustomTooltip_debug("Found damage on line ", i);
					break;
				end
			else
				break;
			end
			
			CustomTooltip_debug("No damage match on line ", i);
		end
		
		-- no lore info
		if(not starti) then
			return;
		end
		
		CustomTooltip_debug("Getting lines ", starti, " to ", GameTooltip:NumLines());
		-- we have the lore info
		for i=starti, GameTooltip:NumLines(), 1 do
			CustomTooltip_debug("Adding lore line: ",getglobal("GameTooltipTextLeft"..i):GetText());
			table.insert(CustomTooltip_BEASTLORE, getglobal("GameTooltipTextLeft"..i):GetText());
		end
		return;

	end
	CustomTooltip_BEASTLORE = nil;
	return;
end

function CustomTooltip_getCodeColor(code)
	if(CustomTooltip_CodeColorCallback[code] == nil) then
		return 1, 1, 1;
	else
		return CustomTooltip_CodeColorCallback[code]();
	end
end


function CustomTooltip_getCity()
	return CustomTooltip_CITY;
end

function CustomTooltip_getTitle()
	return CustomTooltip_TITLE;
end

function CustomTooltip_getProfession()
	return CustomTooltip_PROFESSION;
end

function CustomTooltip_getSkinnable()
	return CustomTooltip_SKINNABLE;
end

function CustomTooltip_getName()
	return UnitName("mouseover");
end

-- LedMirage 3/24/2005
function CustomTooltip_getLevel()
	local targetlevel = UnitLevel("mouseover");
	local playerlevel = UnitLevel("player");
	
	if(UnitIsPlusMob("mouseover") or UnitClassification("mouseover") == "elite") then 
			
		if ( targetlevel == -1 ) then	
			targetlevel = "Hidden";
		else
			targetlevel = targetlevel.."+";
		end

	elseif (UnitClassification("mouseover") == "worldboss")
		then targetlevel = "WorldBoss";
	end

	if ( targetlevel == -1 ) then	
		targetlevel = "Hidden";
	end

	return targetlevel;
end

function CustomTooltip_getClass()
	return UnitClass("mouseover");
end

function CustomTooltip_getRace()
	if(not UnitIsDead("mouseover")) then
		if(UnitIsPlayer("mouseover")) then
			return UnitRace("mouseover");
		elseif(UnitIsEnemy("mouseover", "player") or (not UnitIsPlayer("mouseover")) ) then
			return UnitCreatureType("mouseover");
		end
	else
		return "";
	end
end

function CustomTooltip_getPlayerClass()
	if(UnitIsPlayer("mouseover")) then
		return UnitClass("mouseover");
	end
	return nil;
end

function CustomTooltip_getGuild()
	if(GetGuildInfo("mouseover") == nil) then
		return "Unguilded";
	else
		return GetGuildInfo("mouseover");
	end
end

function CustomTooltip_getFormattedGuild()
	if(GetGuildInfo("mouseover") == nil) then
		return "";
	else
		return "<"..GetGuildInfo("mouseover")..">";
	end
end

function CustomTooltip_getManaPct()
	if(UnitPowerType("mouseover") ~= 0) then
		return nil;
	end

	local curmana = UnitMana("mouseover");
	local maxmana = UnitManaMax("mouseover");
	if(maxmana == 0) then
		return nil;
	end
	return (math.floor(curmana / maxmana) * 100) .. "%";
end

function CustomTooltip_getIsPlayer()
	if(UnitIsPlayer("mouseover")) then
		return "(Player)";
	end
	return nil;
end

function CustomTooltip_getIsPvP()

	if(not UnitIsDead("mouseover")) then
		if(UnitIsPVP("mouseover")) then
			return "PvP Enabled";
		else
			return nil;
		end
	end
end

function CustomTooltip_getElite()
	if(UnitIsPlusMob("mouseover") or UnitClassification("mouseover") == "elite" or 
		UnitClassification("mouseover") == "worldboss") then
		return "(Elite)";
	end
	return nil;
end

function CustomTooltip_getTapped()
	if(not UnitExists("mouseover") or UnitIsDead("mouseover") or UnitIsPlayer("mouseover") or UnitIsFriend("mouseover", "player")) then
		return nil;
	end
	if(UnitIsTappedByPlayer("mouseover")) then
		return "Tapped by You";
	elseif(UnitIsTapped("mouseover")) then	
		return "Tapped";
	elseif(UnitIsEnemy("mouseover", "player")) then
		return "Untapped";
	end
	
	return nil;
	
end

function CustomTooltip_getIsCorpse()
	if(UnitIsDead("mouseover")) then
		return "Corpse";
	else
		return "";		
	end
end 

function CustomTooltip_getNameColor()
	local r = 1
	local g = 1;
	local b = 1;

	if(UnitIsFriend("mouseover", "player")) then
		-- its a friendly...
		if(UnitIsPlayer("mouseover")) then
			-- friendly player
			if(UnitInParty("mouseover")) then
				--CustomTooltip_debug("party");
				r = CustomTooltip_Colors["partymate"].r;
				g = CustomTooltip_Colors["partymate"].g;
				b = CustomTooltip_Colors["partymate"].b;
			
			elseif(GetGuildInfo("player") ~= nil and GetGuildInfo("player") == GetGuildInfo("mouseover")) then
				--CustomTooltip_debug("guild");
				r = CustomTooltip_Colors["guildmate"].r;
				g = CustomTooltip_Colors["guildmate"].g;
				b = CustomTooltip_Colors["guildmate"].b;
			else
				-- we're "just friends" ;)
				r = CustomTooltip_Colors["friendpc"].r;
				g = CustomTooltip_Colors["friendpc"].g;
				b = CustomTooltip_Colors["friendpc"].b;
			end
		else
			-- its a friendly npc
			if(UnitIsUnit("mouseover", "pet")) then
				--CustomTooltip_debug("pet");	
				r = CustomTooltip_Colors["pet"].r;
				g = CustomTooltip_Colors["pet"].g;
				b = CustomTooltip_Colors["pet"].b;
			-- LedMirage	
			elseif(UnitCreatureType("mouseover") == "Beast") then
				--CustomTooltip_debug("pet");	
				r = CustomTooltip_Colors["pet"].r;
				g = CustomTooltip_Colors["pet"].g;
				b = CustomTooltip_Colors["pet"].b;
			elseif(UnitCreatureType("mouseover") == "Demon") then
				--CustomTooltip_debug("pet");	
				r = CustomTooltip_Colors["pet"].r;
				g = CustomTooltip_Colors["pet"].g;
				b = CustomTooltip_Colors["pet"].b;	
			elseif(UnitCreatureType("mouseover") == "Mechanical") then
				--CustomTooltip_debug("pet");	
				r = CustomTooltip_Colors["pet"].r;
				g = CustomTooltip_Colors["pet"].g;
				b = CustomTooltip_Colors["pet"].b;				
			else
				--CustomTooltip_debug("friend NPC");
				r = CustomTooltip_Colors["friendnpc"].r;
				g = CustomTooltip_Colors["friendnpc"].g;
				b = CustomTooltip_Colors["friendnpc"].b;
			end
		end
		
	elseif(UnitIsEnemy("mouseover", "player")) then
		if(UnitIsPlayer("mouseover")) then
			r = CustomTooltip_Colors["enemypc"].r;
			g = CustomTooltip_Colors["enemypc"].g;
			b = CustomTooltip_Colors["enemypc"].b;
		else
			r = CustomTooltip_Colors["enemynpc"].r;
			g = CustomTooltip_Colors["enemynpc"].g;
			b = CustomTooltip_Colors["enemynpc"].b;
		end
	else
		-- neutral
		r = CustomTooltip_Colors["neutral"].r;
		g = CustomTooltip_Colors["neutral"].g;
		b = CustomTooltip_Colors["neutral"].b;
	end
	
	return r,g,b;
end

function CustomTooltip_getPVPColor()
	local r,g,b;
	
	if(UnitIsEnemy("mouseover", "player") and ((UnitIsPlayer("mouseover") and UnitIsPVP("mouseover")) or not UnitIsPlayer("mouseover") )) then
		-- red
		r = CustomTooltip_Colors["hostile"].r;
		g = CustomTooltip_Colors["hostile"].g;
		b = CustomTooltip_Colors["hostile"].b;
	elseif((UnitIsFriend("mouseover", "player") and not UnitIsPVP("mouseover")) or (UnitIsEnemy("mouseover", "player") and UnitIsPlayer("mouseover") and not UnitIsPVP("mouseover")    )) then
		-- blue
		r = CustomTooltip_Colors["nopvp"].r;
		g = CustomTooltip_Colors["nopvp"].g;
		b = CustomTooltip_Colors["nopvp"].b;
	elseif(UnitIsFriend("mouseover", "player") and UnitIsPVP("mouseover")) then
		-- green
		r = CustomTooltip_Colors["friendpvp"].r;
		g = CustomTooltip_Colors["friendpvp"].g;
		b = CustomTooltip_Colors["friendpvp"].b;
	else
		-- yellow
		r = CustomTooltip_Colors["neutral"].r;
		g = CustomTooltip_Colors["neutral"].g;
		b = CustomTooltip_Colors["neutral"].b;
	end
	
	return r,g,b;
end


function CustomTooltip_getLevelColor()
	-- LedMirage 3/24/2005 proper level colors	
	local targetLevel = UnitLevel("mouseover");
	
	if ( UnitCanAttack("player", "mouseover") ) then
		local color = GetDifficultyColor(targetLevel);
		r = color.r;
		g = color.g;
		b = color.b;
	else
		r = 1.0;
		g = 0.82;
		b = 0.0;
	end


	return r,g,b; 

end

function CustomTooltip_getSkinnableColor()
	local targetLevel = UnitLevel("mouseover");
	local color = GetDifficultyColor(targetLevel);
	r = color.r;
	g = color.g;
	b = color.b;
	
	return r,g,b;
end

function CustomTooltip_getClassColor()
	return 1, 1, 1;
end

function CustomTooltip_getGuildColor()
	local r = 1;
	local g = 1;
	local b = 1;

	if(GetGuildInfo("player") ~= nil and GetGuildInfo("player") == GetGuildInfo("mouseover")) then
		r = CustomTooltip_Colors["guildmate"].r;
		g = CustomTooltip_Colors["guildmate"].g;
		b = CustomTooltip_Colors["guildmate"].b;
	end
	
	-- TODO:  Add KOS and Alliance types
	
	return r,g,b;
end
	

function CustomTooltip_resize()
	
	
	-- set the width, taken from Props.lua, by Alexander Yoshi 2 Oct. 2004.
	local newWidth = 0;
	local numlines = GameTooltip:NumLines();
	
	-- set the height
	GameTooltip:SetHeight((numlines*16)+20);
	
	for i = 1, numlines do
		local checkText = getglobal("GameTooltipTextLeft"..i);
		if (checkText and ((checkText:GetWidth() + 24) > newWidth)) then
			newWidth = (checkText:GetWidth() + 24);
		end
	end
	GameTooltip:SetWidth(newWidth);
end

function CustomTooltip_setBG(r, g, b)
	GameTooltip:SetBackdropColor(r, g, b);	
end

function CustomTooltip_setBGBorder(r, g, b)
	GameTooltip:SetBackdropBorderColor(r, g, b);	
end

-- TODO: figure out a way to restore the correct font sizes for the tooltips
--		as the sizes persist for all of them
function CustomTooltip_restoreFontSizes()

end

function CustomTooltip_getCodeInfo()
	local info = "Code Reference:\nDo NOT use negative values or non-number values for normal RGB values.\nIt will crash your game.";
	info = info.."\n\nColor Syntax:\n('code', 'bg', and 'border' are color codes)\nStatic Line: r,g,b|Text\nStatic BG: r,g,b|bg\nStatic border: r,g,b|border\nDynamic Line: -1,code,0|Text\nDynamic BG/Border-2,code,code|Text";
	info = info.."\n\n**Color Codes:"
	
	table.foreach(CustomTooltip_CodeColorInfo, function(i,v) info = info.."\n"..v; return nil; end);
	
	info = info.."\n\n**Text Codes:";
	
	table.foreach(CustomTooltip_CodeInfo, function(...) info = info.."\n"..arg[2]; return nil; end );

	return info;
end