

-- Saved Data

NuNData = {};
NuNSettings = {};




-- Arrays

local dfltHeadings = {
	"Guild : ",
	"Guild Rank : ",
	"Real Name : ",
	"e-mail : ",
	"WWW : "
};

local HRaces = {
	"Orc",
	"Tauren",
	"Troll",
	"Undead"
};
	
local ARaces = {
	"Dwarf",
	"Gnome",
	"Human",
	"Night Elf"
};

local Races = {};

local AllClasses = {
	"Druid",
	"Hunter",
	"Mage",
	"Paladin",
	"Priest",
	"Rogue",
	"Shaman",
	"Warlock",
	"Warrior"
};

local HClasses = {
	"Druid",
	"Hunter",
	"Mage",
	"Priest",
	"Rogue",
	"Shaman",
	"Warlock",
	"Warrior"
};

local AClasses = {
	"Druid",
	"Hunter",
	"Mage",
	"Paladin",
	"Priest",
	"Rogue",
	"Warlock",
	"Warrior"
};

local Classes = {};

local HRanks = {
	"Scout",
	"Grunt",
	"Sergeant",
	"Seniour Sergeant",
	"First Sergeant",
	"Stone Guard",
	"Blood Guard",
	"Legionnaire",
	"Centurion",
	"Champion",
	"Lieutenant General",
	"General",
	"Warlord",
	"High Warlord"
};

local ARanks = {
	"Private",
	"Corporal",
	"Sergeant",
	"Master Sergeant",
	"Sergeant Major",
	"Knight",
	"Knight-Lieutenant",
	"Knight-Captain",
	"Knight-Champion",
	"Lieutenant Commander",
	"Commander",
	"Marshal",
	"Field Marshal",
	"Grand Marshal"
};

local Ranks = {};

local Professions = {
	"Alchemist",
	"Blacksmith",
	"Blacksmith:Armoursmith",
	"Blacksmith:Weaponsmith:Axe",
	"Blacksmith:Weaponsmith:Hammer",
	"Blacksmith:Weaponsmith:Sword",
	"Enchanter",
	"Engineer",
	"Engineer: Gnomish",
	"Engineer: Goblin",
	"Herbalist",
	"Leatherworker",
	"Leatherworker: Elemental",
	"Leatherworker: Dragonscale",
	"Leatherworker: Tribal",
	"Miner",
	"Skinner",
	"Tailor"
};

local Sexes = {
	"Male",
	"Female"
};

local searchFor = {
	"All",
	"Class",
	"Notes",
	"Profession",
	"Text"
}

local foundNuN = {};
local c_continents = {};
local foundHNuN = {};
local foundANuN = {};
local foundNNuN = {};




-- Local Variables

NuN = "Hello ;)";
local bttnChanges = {};
local uBttns = getn(dfltHeadings);
local detlOffset = uBttns;
local hdngOffset = (uBttns * 2);
local pHead = "~Hdng";
local pDetl = "~Detl";
local discard;
local c_name;
local c_class;
local c_race;
local c_guild;
local c_route;
local pName;
local pKey;
local pFaction;
local hdNbr;
local nameHdNbr;
local nameDtNbr;
local oriTxt;
local isTitle;
local bttnNumb;
local lastDD;
local switch;
local parm1;
local Notes = "notes~";
local c_note;
local tryI;
local lastBttn;
local lastBttnIndex;
local deletedE;
local visibles;
local lastVisible;
local lastBttnDetl;
local importing;
local updateInterval = 10;
local timeSinceLastUpdate = 0;
local NuNRaceDropDown;
local NuNClassDropDown;
local NuNCRankDropDown;
local NuNHRankDropDown;
local unitTest;




-- Local Constants

MAX_PARTY_MEMBERS = 4;
NUN_AUTO_C = "A";
NUN_SELF_C = "S";
NUN_MANU_C = "M";
NUN_HORD_C = "H";
NUN_ALLI_C = "A";
NUN_NOTE_C = "N";






-- Mod Functions



function NuN_OnLoad()
	local continentID, zoneID, continent, zone;
	local c_zones = {};
	
	tryI = true;
	
	this:RegisterEvent("IGNORELIST_UPDATE");
	this:RegisterEvent("FRIENDLIST_UPDATE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEVEL_UP")
		      
	SlashCmdList["NOTEUN"] = function(pList)
		local gap = string.find(pList, " ");
		if ( gap ) then
			switch = string.sub(pList, 1, (gap - 1));
			parm1 = string.sub(pList, (gap + 1));
		else
			switch = pList;
			parm1 = nil;
		end
		NuN_CmdLine(switch, parm1);
	end
	SLASH_NOTEUN1 = "/nun";
	
	pKey = GetCVar("realmName");
	if (not NuNData[pKey]) then
		NuNData[pKey] = {};
		NuNSettings[pKey] = {};	
		NuNSettings[pKey].autoA = "1";
		NuNSettings[pKey].autoD = "1";
		NuNData[pKey][Notes] = {};	
	end	
	
	pName = UnitName("player");

	ClearButtonChanges();

	c_continents[1] = {};
	c_continents[2] = {};
	for continentID, continent in ipairs{GetMapContinents()} do
		c_zones = {};
		c_continents[continentID].name = continent;
		for zoneID, zone in ipairs{GetMapZones(continentID)} do
			c_zones[zoneID] = zone;
		end
		c_continents[continentID].zones = c_zones;
	end
end



function NuN_CmdLine(option, parm1)
	local index;
	local value;
	local initial;
	local remainder;
	local contactName;
	local switch;
	local theUnitID = "target";

	if ( ( option == "" ) or ( option == nil ) ) then
		NuN_Options();
	else
		switch = string.lower(option);
		if ( switch == "-h" ) then
			index = 0;
			value = getglobal("NUN_HELP_TEXT"..index);
			while( value ) do
				DEFAULT_CHAT_FRAME:AddMessage(value);
				index = index + 1;
				value = getglobal("NUN_HELP_TEXT"..index);
			end	
		elseif ( switch == "-a" ) then
			NuN_DisplayAll();	
		elseif ( switch == "-g" ) then
			if ( ( parm1 ~= nil ) and ( parm1 ~= "") ) then
				c_note = parm1;
				if ( NuNData[pKey][Notes][c_note] ) then
					NuN_ShowSavedGNote();
				else
					NuN_ShowTitledGNote();
				end
			else
				NuN_ShowNewGNote();
			end
		elseif ( switch == "-t" ) then
			NuN_CheckTarget();
			NuN_NewContact(theUnitID);
		else
			initial = string.upper( string.sub(switch, 1, 1) );
			remainder = string.lower( string.sub(switch,2) );
			contactName = initial..remainder;
			if ( NuNData[pKey][contactName] ) then
				if ( NuNFrame:IsVisible() ) then
					NuN_HideFrame();
				end
				NuN_ShowSavedNote(contactName);
			elseif ( NuNData[pKey][Notes][option] ) then
				c_note = option;
				NuN_ShowSavedGNote();
			else
				c_name = contactName;
				unitTest = true;
				theUnitID = NuN_Target();
				if ( theUnitID ~= nil ) then
					NuN_NewContact(theUnitID);
				else
					NuN_Options();
				end
			end
		end
	end
end



function NuN_CheckTarget()
	if ( ( ( UnitPlayerControlled("target") )  and (not UnitIsUnit("player", "target") ) ) or ( UnitInParty("target") ) or ( UnitInRaid("target") ) )then
		return true;
	else
		TargetUnit("player");
		return false;
	end
end



function NuN_DisplayAll()
	if ( NuNSearchFrame:IsVisible() ) then
		NuNSearchFrame:Hide();
	else
		NuNSearchFrameBackButton:Disable();
		ddSearch = 1;
		searchType = searchFor[ddSearch];
		NuNOptions_Search();
	end
end



function NuN_Options()
	if ( NuNOptionsFrame:IsVisible() ) then
		HideUIPanel(NuNOptionsFrame);
	else
		if ( NuNFrame:IsVisible() ) then
			NuN_HideFrame();
		end
		if ( NuNSearchFrame:IsVisible() ) then
			HideUIPanel(NuNSearchFrame);
		end
		if ( NuNGNoteFrame:IsVisible() ) then
			HideUIPanel(NuNGNoteFrame);
		end
		UIDropDownMenu_SetSelectedID(NuNOptionsSearchDropDown, 1);
		UIDropDownMenu_SetText(searchFor[1], NuNOptionsSearchDropDown);
		ddSearch = 1;
		if ( NuNSettings[pKey].autoG ) then
			NuNOptionsGuildCheckButton:SetChecked(1);
		else
			NuNOptionsGuildCheckButton:SetChecked(0);
		end
		if ( NuNSettings[pKey].autoA ) then
			NuNOptionsAddCheckButton:SetChecked(1);
		else
			NuNOptionsAddCheckButton:SetChecked(0);
		end
		if ( NuNSettings[pKey].autoD ) then
			NuNOptionsDeleteCheckButton:SetChecked(1);
		else
			NuNOptionsDeleteCheckButton:SetChecked(0);
		end
		NuNSearchFrameBackButton:Enable();
		ShowUIPanel(NuNOptionsFrame);
	end
end



function ClearButtonChanges()
	for i = 1, (uBttns * 2), 1 do
		bttnChanges[i] = "";
	end
end



function NuN_ShowFriendNote()
	local numFriends = GetNumFriends();
	if (numFriends ~= nil) and (numFriends > 0) then
		if ( FriendsFrame.selectedFriend ) then
			FriendsFrame.selectedFriend = GetSelectedFriend();
			c_name, discard, c_class, discard, connected = GetFriendInfo(FriendsFrame.selectedFriend);
			if ( c_class == "Unknown" ) then
				c_class = nil;
			end;
			c_race = nil;
			c_guild = nil;
			gRank = nil;
			gRankIndex = nil;
			gNote = nil;
			gOfficerNote = nil;
			c_route = "Friend";
			if ( horde ) then		
				NuN_HordeSetup();
			else
				NuN_AllianceSetup();	
			end
			NuN_ShowNote();
		end
	end
end



function NuN_ShowIgnoreNote()
	local numIgnores = GetNumIgnores();
	if (numIgnores ~= nil) and (numIgnores > 0) then
		if ( FriendsFrame.selectedIgnore ) then
			FriendsFrame.selectedIgnore = GetSelectedIgnore();
			c_name = GetIgnoreName(FriendsFrame.selectedIgnore);
			c_class = nil;
			c_race = nil;
			c_guild = nil;
			gRank = nil;
			gRankIndex = nil;
			gNote = nil;
			gOfficerNote = nil;
			c_route = "Ignore";	
			if ( horde ) then		
				NuN_HordeSetup();
			else
				NuN_AllianceSetup();
			end	
			NuN_ShowNote();
		end
	end
end



function NuN_ShowGuildNote()
	local numGuildMembers = GetNumGuildMembers();
	if (numGuildMembers ~= nil) and (numGuildMembers > 0) then
		c_class = nil;
		c_race = nil;
		c_name, gRank, gRankIndex, discard, c_class, discard, discard, gNote, gOfficerNote, discard = GetGuildRosterInfo( GetGuildRosterSelection() );
		if ( c_name ~= nil ) then
			c_guild = GetGuildInfo("player");
			c_route = "Guild";
			if ( horde ) then		
				NuN_HordeSetup();
			else
				NuN_AllianceSetup();		
			end
			NuN_ShowNote();
		end
	end
end



function NuN_ShowSavedNote(cName)
	c_name = cName;
	c_class = nil;
	c_race = nil;
	c_guild = nil;
	gRank = nil;
	gRankIndex = nil;
	gNote = nil;
	gOfficerNote = nil;
	c_route = "Saved";
	if ( NuNData[pKey][c_name].faction == "Horde" ) then		
		NuN_HordeSetup();
	else
		NuN_AllianceSetup();	
	end
	NuN_ShowNote();
end




function NuN_ShowNote()
	local hText;
	local theText;
	
	if ( NuNOptionsFrame:IsVisible() ) then
		HideUIPanel(NuNOptionsFrame);
	end
	
	lastDD = nil;
	NuNButtonClrDD:Disable();
	
	ClearButtonChanges();
	
	NuNHeader:SetText(c_name);
	
	if ( NuNData[pKey][c_name] ) then
		NuNText:SetText( NuNData[pKey][c_name].txt );
		NuNButtonDelete:Enable();
		if ( c_name == pName ) then
			NuNHeader:SetText(NUN_PLAYER.." : "..c_name);
		elseif ( NuNData[pKey][c_name].type == NUN_AUTO_C ) then
			NuNHeader:SetText(NUN_AUTO.." : "..c_name);
		elseif (NuNData[pKey][c_name].type == NUN_MANU_C ) then
			NuNHeader:SetText(NUN_MANU.." : "..c_name);
		elseif ( NuNData[pKey][c_name].type == NUN_SELF_C ) then
			NuNHeader:SetText(NUN_SELF.." : "..c_name);
		else
			NuNHeader:SetText(c_name);
		end
	else
		theText = "";
		NuNHeader:SetText(NUN_NEW.." : "..c_name);
		if ( gNote ~= nil ) then
			theText = "\n"..gNote;
		end
		if ( gOfficerNote ~= nil ) then
			theText = theText.."\n"..gOfficerNote;
		end
		NuNText:SetText(theText);
		NuNButtonDelete:Disable();
	end	
		
	UserButtons_Initialise();
	DropDowns_Initialise();

	ddRace = nil;
	ddClass = nil;
	ddSex = nil;
	ddProf1 = nil;
	ddProf2 = nil;
	ddCRank = nil;
	ddHRank = nil;

	if ( NuNEditDetailsFrame:IsVisible() ) then
		HideUIPanel(NuNEditDetailsFrame);
	end
	ShowUIPanel(NuNFrame);
--	NuNText:ClearFocus();
end




function NuN_Update_Ignored()
	local index;
	local value;
	local x;
	local iName;
	
	
	if ( pFaction ~= nil ) then
	
		-- Check every Ignored player to make sure we have a Saved note
		
		if ( NuNSettings[pKey].autoA ) then
			for i = 1, GetNumIgnores(), 1 do
				iName = GetIgnoreName(i);
				if ( ( iName ~= nil ) and ( not NuNData[pKey][iName] ) ) then
					NuNData[pKey][iName] = {};
					NuNData[pKey][iName].type = NUN_AUTO_C;
					NuNData[pKey][iName].faction = pFaction;
					NuNData[pKey][iName].txt = NUN_AUTO_IGNORE..NuN_GetDateStamp();
					NuNData[pKey][iName].ignoreLst = {};
					NuNData[pKey][iName].ignoreLst[1] = pName;
				end
			end	
		end
		
		
		
		-- Check every Saved entry to see if it is ignored, and upated Saved inofrmation on that basis
			
		for index, value in NuNData[pKey] do
			if ( ( NuNData[pKey][index].faction) and ( NuNData[pKey][index].faction == pFaction ) and ( index ~= pName ) ) then		
				if ( NuN_Is_Ignored(index) ) then
					if ( not NuNData[pKey][index].ignoreLst ) then		-- Ignored but no ignore list currently
						x = 1;
						NuNData[pKey][index].ignoreLst = {};
						NuNData[pKey][index].ignoreLst[x] = pName;
					else								-- Ignored but not on ignore list yet
						if (not Get_TableID(NuNData[pKey][index].ignoreLst, pName) ) then
							x = getn( NuNData[pKey][index].ignoreLst ) + 1;
							NuNData[pKey][index].ignoreLst[x] = pName;
						end
					end
				else
					if ( NuNData[pKey][index].ignoreLst ) then
						x = Get_TableID(NuNData[pKey][index].ignoreLst, pName);
						if ( x ~= nil ) then					-- Not ignored, but on ignore list > come off list
						    local tmpTable = Remove_Entry(NuNData[pKey][index].ignoreLst, x);
						    NuNData[pKey][index].ignoreLst = tmpTable;
						    if ( getn(NuNData[pKey][index].ignoreLst) == 0 ) then	
						    	-- If no more ignore list, and auto-deleting, and Auto-note, then delete note entirely	
							if ((NuNData[pKey][index].type == NUN_AUTO_C) and (NuNSettings[pKey].autoD) and (not NuNData[pKey][index].friendLst)) then
							    NuNData[pKey][index] = nil;
							else
							    NuNData[pKey][index].ignoreLst = nil;
							end
						    end
						elseif ( getn(NuNData[pKey][index].ignoreLst) > 0 ) then
						
							-- If (Not Ignored) & (There is an Ignore List we are NOT On) & (Settings say we should try to Ignore) 
							--  & (Only 1 attempt per 'log on'  OR  Manual refresh ) then....
						
							if ( tryI == true ) then
								if ( AddIgnore(index) ) then
									x = getn(NuNData[pKey][index].ignoreLst) + 1;
									NuNData[pKey][index].ignoreLst[x] = pName;
								end
							end
						end
					end
				end
			end
		end	
	tryI = false;
	end
end



function NuN_Update_Friends()
	local index;
	local value;
	local x;
	local iName;
	
	if ( pFaction ~= nil ) then
		if ( NuNSettings[pKey].autoA ) then
			for i = 1, GetNumFriends(), 1 do
				iName = GetFriendInfo(i);
				if ( ( iName ~= nil ) and ( not NuNData[pKey][iName] ) ) then
					NuNData[pKey][iName] = {};
					NuNData[pKey][iName].type = NUN_AUTO_C;
					NuNData[pKey][iName].faction = pFaction;
					NuNData[pKey][iName].txt = NUN_AUTO_FRIEND..NuN_GetDateStamp();
					NuNData[pKey][iName].friendLst = {};
					NuNData[pKey][iName].friendLst[1] = pName;
				end
			end	
		end
		
		-- Check every Saved entry to see if it is friendly, and upated Saved inofrmation on that basis
	
		for index, value in NuNData[pKey] do
			if  ( index == pName ) then
				NuNData[pKey][index].type = NUN_SELF_C;
			elseif ( ( NuNData[pKey][index].faction ) and ( NuNData[pKey][index].faction == pFaction ) ) then		
				if ( NuN_Is_Friendly(index) ) then
					if ( not NuNData[pKey][index].friendLst ) then
						x = 1;
						NuNData[pKey][index].friendLst = {};
						NuNData[pKey][index].friendLst[x] = pName;
					else
						if (not Get_TableID(NuNData[pKey][index].friendLst, pName) ) then
							x = getn( NuNData[pKey][index].friendLst ) + 1;
							NuNData[pKey][index].friendLst[x] = pName;
						end
					end
				else
					if ( NuNData[pKey][index].friendLst ) then
						x = Get_TableID(NuNData[pKey][index].friendLst, pName);
						if ( x ~= nil ) then
						    local tmpTable = Remove_Entry(NuNData[pKey][index].friendLst, x);
						    NuNData[pKey][index].friendLst = tmpTable;
						    if ( getn(NuNData[pKey][index].friendLst) == 0 ) then
							if ((NuNData[pKey][index].type == NUN_AUTO_C) and (NuNSettings[pKey].autoD) and (not NuNData[pKey][index].ignoreLst)) then
								NuNData[pKey][index] = nil;
							else
								NuNData[pKey][index].friendLst = nil;
							end
						    end
						end
					end
				end
			end
		end			
		
	end
end



function Remove_Entry(table, entry)
	local sorted = {};
	local innerI = 0;
	for i = 1, getn(table), 1 do
		if ( i ~= entry ) then
			innerI = innerI + 1;
			sorted[innerI] = table[i];
		end
	end
	return sorted;
end

function NuN_Is_Ignored(aName)
	for i = 1, GetNumIgnores(), 1 do
		iName = GetIgnoreName(i);
		if ( aName == GetIgnoreName(i) ) then
			return true;
		end
	end
	return false;	
end

function NuN_Is_Friendly(aName)
	local iName;
	for i = 1, GetNumFriends(), 1 do
		iName = GetFriendInfo(i);
		if ( iName == aName ) then
			return true;
		end
	end
	return false;
end



function UserButtons_Initialise()
	for n = 1, uBttns, 1 do
		bttnHeadingText = getglobal("NuNTitleButton"..n.."ButtonTextHeading");
		bttnDetailText = getglobal("NuNInforButton"..n.."ButtonTextDetail");
		bttnDetail = getglobal("NuNInforButton"..n);
		hdNbr = pHead..n;
		nameHdNbr = c_name..hdNbr;
		nameDtNbr = c_name..pDetl..n;
		if ( NuNData[pKey][nameHdNbr] ) then
			bttnHeadingText:SetText(NuNData[pKey][nameHdNbr].txt);
		elseif (NuNSettings[pKey][hdNbr]) then
			bttnHeadingText:SetText(NuNSettings[pKey][hdNbr].txt);
		else
			bttnHeadingText:SetText(dfltHeadings[n]);
		end
		if ( bttnHeadingText:GetText() == nil ) then
			bttnDetailText:SetText("");
			bttnDetail:Disable();
		else
			bttnDetail:Enable();
			if ( NuNData[pKey][nameDtNbr] ) then
				bttnDetailText:SetText(NuNData[pKey][nameDtNbr].txt);
			else
				bttnDetailText:SetText("");
			end
		end

		if ( n == 1 ) and ( c_guild ~= nil ) then
			if ( bttnHeadingText:GetText() == dfltHeadings[n] ) and ( (bttnDetailText:GetText() == "") or (bttnDetailText:GetText() == nil) ) then
				bttnDetailText:SetText(c_guild);
				bttnChanges[n+detlOffset] = c_guild;
			end
		end
		if ( n == 2 ) and ( gRank ~= nil ) then
			if ( bttnHeadingText:GetText() == dfltHeadings[n] ) and ( (bttnDetailText:GetText() == "") or (bttnDetailText:GetText() == nil) ) then
				if ( gRankIndex == 0 ) then
					GuildRank = ("GM : "..gRank);
				else
					GuildRank = (gRankIndex.." : "..gRank);
				end
				bttnDetailText:SetText(GuildRank);
				bttnChanges[n+detlOffset] = GuildRank;
			end
		end
	end	
end



function DropDowns_Initialise()
	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].race ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNRaceDropDown, NuNData[pKey][c_name].race);
		UIDropDownMenu_SetText(Races[ (NuNData[pKey][c_name].race) ], NuNRaceDropDown);
	elseif ( c_race ~= nil ) then
		ddRace = Get_TableID(Races, c_race);
		UIDropDownMenu_SetSelectedID(NuNRaceDropDown, ddRace);
		UIDropDownMenu_SetText(c_race, NuNRaceDropDown);
	else
		UIDropDownMenu_ClearAll(NuNRaceDropDown);
	end
	
	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].cls ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNClassDropDown, NuNData[pKey][c_name].cls);
		UIDropDownMenu_SetText(Classes[ (NuNData[pKey][c_name].cls) ], NuNClassDropDown);
	elseif ( c_class ~= nil ) then
		ddClass = Get_TableID(Classes, c_class);
		UIDropDownMenu_SetSelectedID(NuNClassDropDown, ddClass);
		UIDropDownMenu_SetText(c_class, NuNClassDropDown);
	else
		UIDropDownMenu_ClearAll(NuNClassDropDown);
	end
		
	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].sex ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNSexDropDown, NuNData[pKey][c_name].sex);
		UIDropDownMenu_SetText(Sexes[ (NuNData[pKey][c_name].sex) ], NuNSexDropDown);
	else
		UIDropDownMenu_ClearAll(NuNSexDropDown);
	end
	
	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].prof1 ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNProf1DropDown, NuNData[pKey][c_name].prof1);
		UIDropDownMenu_SetText(Professions[ (NuNData[pKey][c_name].prof1) ], NuNProf1DropDown);
	else
		UIDropDownMenu_ClearAll(NuNProf1DropDown);
	end

	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].prof2 ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNProf2DropDown, NuNData[pKey][c_name].prof2);
		UIDropDownMenu_SetText(Professions[ (NuNData[pKey][c_name].prof2) ], NuNProf2DropDown);
	else
		UIDropDownMenu_ClearAll(NuNProf2DropDown);
	end
	
	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].crank ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNCRankDropDown, NuNData[pKey][c_name].crank);
		UIDropDownMenu_SetText(Ranks[ (NuNData[pKey][c_name].crank) ], NuNCRankDropDown);
	else
		UIDropDownMenu_ClearAll(NuNCRankDropDown);
	end
	
	if ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].hrank ~= nil ) then
		UIDropDownMenu_SetSelectedID(NuNHRankDropDown, NuNData[pKey][c_name].hrank);
		UIDropDownMenu_SetText(Ranks[ (NuNData[pKey][c_name].hrank) ], NuNHRankDropDown);
	else
		UIDropDownMenu_ClearAll(NuNHRankDropDown);
	end		
end



function Get_TableID(tab, txt)
	for i = 1, getn(tab), 1 do
		if ( tab[i] == txt ) then return i; end
	end
	return nil;
end



function NuN_WriteNote()
	if (not NuNData[pKey][c_name]) then
		NuNData[pKey][c_name] = {};
	end
	
	if ( c_name == pName ) then
		NuNData[pKey][c_name].type = NUN_SELF_C;
		NuNHeader:SetText(NUN_PLAYER.." : "..c_name);
	elseif ( ( not NuNData[pKey][c_name].type ) or ( NuNData[pKey][c_name].type == NUN_AUTO_C ) ) then
		NuNData[pKey][c_name].type = NUN_MANU_C;
		NuNHeader:SetText(NUN_MANU.." : "..c_name);
	end
	
	if ( not NuNData[pKey][c_name].faction ) then
		if ( c_route == "Target" ) then
			NuNData[pKey][c_name].faction = c_faction;
		else
			NuNData[pKey][c_name].faction = pFaction;
		end
	end
	
	if ( c_guild ~= nil ) then
		NuNData[pKey][c_name].guild = c_guild;
	end
	if ( not NuNData[pKey][c_name].guild ) then
		NuNData[pKey][c_name].guild = "";
	end
	
	if ( NuN_Is_Ignored(c_name) ) then
		if ( not NuNData[pKey][c_name].ignoreLst ) then
			NuNData[pKey][c_name].ignoreLst = {};
		end
		if (not Get_TableID(NuNData[pKey][c_name].ignoreLst, pName) ) then		
			local x = getn(NuNData[pKey][c_name].ignoreLst) + 1;
			NuNData[pKey][c_name].ignoreLst[x] = pName;
		end
	end

	if ( NuN_Is_Friendly(c_name) ) then
		if ( not NuNData[pKey][c_name].friendLst ) then
			NuNData[pKey][c_name].friendLst = {};
		end
		if ( not Get_TableID(NuNData[pKey][c_name].friendLst, pName) ) then
			local x = getn(NuNData[pKey][c_name].friendLst) + 1;
			NuNData[pKey][c_name].friendLst[x] = pName;
		end
	end

	if (ddRace) then
		if ( ddRace == -1 ) then
			NuNData[pKey][c_name].race = nil;
		else
			NuNData[pKey][c_name].race = ddRace;
		end
		ddRace = nil;
	elseif ( c_race ~= nil ) then
		NuNData[pKey][c_name].race = Get_TableID(Races, c_race);
	end
	if (ddClass) then 
		if ( ddClass == -1 ) then
			NuNData[pKey][c_name].cls = nil;
		else
			NuNData[pKey][c_name].cls = ddClass;
		end
		ddClass = nil;
	elseif ( c_class ~= nil )  then
		NuNData[pKey][c_name].cls = Get_TableID(Classes, c_class);
	end
	if (ddSex) then
		if ( ddSex == -1 ) then
			NuNData[pKey][c_name].sex = nil;
		else
			NuNData[pKey][c_name].sex = ddSex;
		end
		ddSex = nil;
	end
	if (ddProf1) then
		if ( ddProf1 == -1 ) then
			NuNData[pKey][c_name].prof1 = nil;
		else
			NuNData[pKey][c_name].prof1 = ddProf1;
		end
		ddProf1 = nil;
	end
	if (ddProf2) then
		if ( ddProf2 == -1 ) then
			NuNData[pKey][c_name].prof2 = nil;
		else
			NuNData[pKey][c_name].prof2 = ddProf2;
		end
		ddProf2 = nil;
	end
	if (ddCRank) then
		if ( ddCRank == -1 ) then
			NuNData[pKey][c_name].crank = nil;
		else
			NuNData[pKey][c_name].crank = ddCRank;
		end
		ddCRank = nil;
	end
	if (ddHRank) then
		if ( ddHRank == -1 ) then
			NuNData[pKey][c_name].hrank = nil;
		else
			NuNData[pKey][c_name].hrank = ddHRank;
		end
		ddHRank = nil;
	end
	NuNData[pKey][c_name].txt = NuNText:GetText();

	for n = 1, uBttns, 1 do
		if (bttnChanges[n] ~= "") and (bttnChanges[n] ~= nil) then
			hdNbr = pHead..n;
			nameHdNbr = c_name..hdNbr;
			if (not NuNData[pKey][nameHdNbr]) then
				NuNData[pKey][nameHdNbr] = {};
			end
			if (bttnChanges[n] == 1) then
				NuNData[pKey][nameHdNbr].txt = "";
			else
				NuNData[pKey][nameHdNbr].txt = bttnChanges[n];
			end
		end	
	end
	
	for n = 1, uBttns, 1 do
		b = n + detlOffset;
		if (bttnChanges[b] ~= "") and (bttnChanges[b] ~= nil) then
			nameDtNbr = c_name..pDetl..n;
			if (not NuNData[pKey][nameDtNbr]) then
				NuNData[pKey][nameDtNbr] = {};
			end
			if (bttnChanges[b] == 1) then
				NuNData[pKey][nameDtNbr].txt = nil;
			else
				NuNData[pKey][nameDtNbr].txt = bttnChanges[b];
			end
		end
	end

	ClearButtonChanges();
	NuNButtonDelete:Enable();	
end

function NuNGNote_WriteNote()
	if ( NuNGNoteTitleButton:IsVisible() ) then
		c_note = NuNGNoteTitleButtonText:GetText();
	else
		c_note = NuNGNoteTextBox:GetText();
	end
	c_note_txt = NuNGNoteTextScroll:GetText();
	if ( c_note_txt == nil ) then
		c_note_txt = "";
	end
	NuNData[pKey][Notes][c_note] = {};
	NuNData[pKey][Notes][c_note].txt = c_note_txt;
	NuNGNoteButtonDelete:Enable();
	NuNGNoteTitleButtonText:SetText(c_note);
	NuNGNoteTextBox:Hide();
	NuNGNoteTitleButton:Show();
	NuNGNoteHeader:SetText(NUN_SAVED_NOTE);
end


function NuN_HideFrame()
	HideUIPanel(NuNEditDetailsFrame);
	HideUIPanel(NuNFrame);
end

function NuNGNote_HideFrame()
	HideUIPanel(NuNGNoteFrame);
end



function NuN_OnEvent()
	if ( ( event == "IGNORELIST_UPDATE" ) and ( not importing ) )then
		NuN_Update_Ignored();
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		tryI = true;
		pFaction = UnitFactionGroup("player");
		if ( pFaction == "Horde" ) then
			horde = true;
		else
			horde = false;
		end
		pKey = GetCVar("realmName");
		if (not NuNData[pKey]) then
			NuNData[pKey] = {};
			NuNSettings[pKey] = {};	
			NuNSettings[pKey].autoA = "1";
			NuNSettings[pKey].autoD = "1";
			NuNData[pKey][Notes] = {};	
		end	
		if ( not NuNData[pKey][pName] ) then
			NuN_AutoNote();
		end
		NuN_Update_Friends();
		NuN_Update_Ignored();
	elseif ( ( event == "FRIENDLIST_UPDATE" ) and ( not importing ) ) then		
		NuN_Update_Friends();
	elseif( event == "PLAYER_LEVEL_UP" ) then
		local lvl = UnitLevel("player");
		NuNData[pKey][pName].txt = NuNData[pKey][pName].txt..NUN_LVL..lvl.." : ";
		NuNData[pKey][pName].txt = NuNData[pKey][pName].txt.."\n    "..NuN_GetDateStamp();
		NuNData[pKey][pName].txt = NuNData[pKey][pName].txt.."\n    "..NuN_GetLoc();
	end
end



function NuNHRaceDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNHRaceDropDown, NuNHRaceDropDown_Initialise);	
	UIDropDownMenu_SetWidth(75);
end

function NuNHRaceDropDown_Initialise()
	local info;
	for i=1, getn(HRaces), 1 do
		info = {};
		info.text = HRaces[i];
		info.func = NuNHRaceButton_OnClick;		
		UIDropDownMenu_AddButton(info);
	end
end

function NuNHRaceButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNHRaceDropDown, this:GetID());
	ddRace = this:GetID();
	lastDD = "Race";
	NuNButtonClrDD:Enable();
end

function NuNARaceDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNARaceDropDown, NuNARaceDropDown_Initialise);	
	UIDropDownMenu_SetWidth(75);
end

function NuNARaceDropDown_Initialise()
	local info;
	for i=1, getn(ARaces), 1 do
		info = {};
		info.text = ARaces[i];
		info.func = NuNARaceButton_OnClick;		
		UIDropDownMenu_AddButton(info);
	end
end

function NuNARaceButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNARaceDropDown, this:GetID());
	ddRace = this:GetID();
	lastDD = "Race";
	NuNButtonClrDD:Enable();
end



function NuNHClassDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNHClassDropDown, NuNHClassDropDown_Initialise);
	UIDropDownMenu_SetWidth(75);
end

function NuNHClassDropDown_Initialise()
	local info;
	for i=1, getn(HClasses), 1 do
		info = {};
		info.text = HClasses[i];
		info.func = NuNHClassButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNHClassButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNHClassDropDown, this:GetID());
	ddClass = this:GetID();
	lastDD = "Class";
	NuNButtonClrDD:Enable();
end

function NuNAClassDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNAClassDropDown, NuNAClassDropDown_Initialise);
	UIDropDownMenu_SetWidth(75);
end

function NuNAClassDropDown_Initialise()
	local info;
	for i=1, getn(AClasses), 1 do
		info = {};
		info.text = AClasses[i];
		info.func = NuNAClassButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNAClassButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNAClassDropDown, this:GetID());
	ddClass = this:GetID();
	lastDD = "Class";
	NuNButtonClrDD:Enable();
end



function NuNSexDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNSexDropDown, NuNSexDropDown_Initialise);
	UIDropDownMenu_SetWidth(75);
end

function NuNSexDropDown_Initialise()
	local info;
	for i=1, getn(Sexes), 1 do
		info = {};
		info.text = Sexes[i];
		info.func = NuNSexButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNSexButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNSexDropDown, this:GetID());
	ddSex = this:GetID();
	lastDD = "Sex";
	NuNButtonClrDD:Enable();
end



function NuNProf1DropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNProf1DropDown, NuNProf1DropDown_Initialise);
	UIDropDownMenu_SetWidth(210);
end

function NuNProf1DropDown_Initialise()
	local info;
	for i=1, getn(Professions), 1 do
		info = {};
		info.text = Professions[i];
		info.func = NuNProf1Button_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNProf1Button_OnClick()
	UIDropDownMenu_SetSelectedID(NuNProf1DropDown, this:GetID());
	ddProf1 = this:GetID();
	lastDD = "Prof1";
	NuNButtonClrDD:Enable();
end



function NuNProf2DropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNProf2DropDown, NuNProf2DropDown_Initialise);
	UIDropDownMenu_SetWidth(210);
end

function NuNProf2DropDown_Initialise()
	local info;
	for i=1, getn(Professions), 1 do
		info = {};
		info.text = Professions[i];
		info.func = NuNProf2Button_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNProf2Button_OnClick()
	UIDropDownMenu_SetSelectedID(NuNProf2DropDown, this:GetID());
	ddProf2 = this:GetID();
	lastDD = "Prof2";
	NuNButtonClrDD:Enable();
end



function NuNHCRankDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNHCRankDropDown, NuNHCRankDropDown_Initialise);
	UIDropDownMenu_SetWidth(125);
end

function NuNHCRankDropDown_Initialise()
	local info;
	for i=1, getn(HRanks), 1 do
		info = {};
		info.text = HRanks[i];
		info.func = NuNHCRankButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNHCRankButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNHCRankDropDown, this:GetID());
	ddCRank = this:GetID();
	lastDD = "CRank";
	NuNButtonClrDD:Enable();
end

function NuNACRankDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNACRankDropDown, NuNACRankDropDown_Initialise);
	UIDropDownMenu_SetWidth(125);
end

function NuNACRankDropDown_Initialise()
	local info;
	for i=1, getn(ARanks), 1 do
		info = {};
		info.text = ARanks[i];
		info.func = NuNACRankButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNACRankButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNACRankDropDown, this:GetID());
	ddCRank = this:GetID();
	lastDD = "CRank";
	NuNButtonClrDD:Enable();
end



function NuNHHRankDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNHHRankDropDown, NuNHHRankDropDown_Initialise);
	UIDropDownMenu_SetWidth(125);
end

function NuNHHRankDropDown_Initialise()
	local info;
	for i=1, getn(HRanks), 1 do
		info = {};
		info.text = HRanks[i];
		info.func = NuNHHRankButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNHHRankButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNHHRankDropDown, this:GetID());
	ddHRank = this:GetID();
	lastDD = "HRank";
	NuNButtonClrDD:Enable();
end

function NuNAHRankDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNAHRankDropDown, NuNAHRankDropDown_Initialise);
	UIDropDownMenu_SetWidth(125);
end

function NuNAHRankDropDown_Initialise()
	local info;
	for i=1, getn(ARanks), 1 do
		info = {};
		info.text = ARanks[i];
		info.func = NuNAHRankButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNAHRankButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNAHRankDropDown, this:GetID());
	ddHRank = this:GetID();
	lastDD = "HRank";
	NuNButtonClrDD:Enable();
end


function NuNOptionsSearchDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNOptionsSearchDropDown, NuNOptionsSearchDropDown_Initialise);
	UIDropDownMenu_SetWidth(165);
end

function NuNOptionsSearchDropDown_Initialise()
	local info;
	for i=1, getn(searchFor), 1 do
		info = {};
		info.text = searchFor[i];
		info.func = NuNOptionsSearchDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNOptionsSearchDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(NuNOptionsSearchDropDown, this:GetID());
	ddSearch = this:GetID();
end



function NuNSearchClassDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNSearchClassDropDown, NuNSearchClassDropDown_Initialise);
	UIDropDownMenu_SetWidth(204);
end

function NuNSearchClassDropDown_Initialise()
	local info;
	for i=1, getn(AllClasses), 1 do
		info = {};
		info.text = AllClasses[i];
		info.func = NuNSearchClassButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNSearchClassButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNSearchClassDropDown, this:GetID());
	ddClassSearch = this:GetID();
	NuNSearchFrameSearchButton:Enable();
end



function NuNSearchProfDropDown_OnLoad()
	UIDropDownMenu_Initialize(NuNSearchProfDropDown, NuNSearchProfDropDown_Initialise);
	UIDropDownMenu_SetWidth(204);
end

function NuNSearchProfDropDown_Initialise()
	local info;
	for i=1, getn(Professions), 1 do
		info = {};
		info.text = Professions[i];
		info.func = NuNSearchProfButton_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function NuNSearchProfButton_OnClick()
	UIDropDownMenu_SetSelectedID(NuNSearchProfDropDown, this:GetID());
	ddProfSearch = this:GetID();
	NuNSearchFrameSearchButton:Enable();
end



function NuNEditDetails()
	local prntObj;
	local prntTxtObj;

	newTxt = (NuNEditDetailsBox:GetText());

	if (newTxt ~= oriTxt) then
		chldObj = getglobal("NuNInforButton"..bttnNumb);
		if ((newTxt == "") and (isTitle)) or ((newTxt == nil) and (isTitle)) then
			chldTxtObj = getglobal("NuNInforButton"..bttnNumb.."ButtonTextDetail");
			chldTxt = chldTxtObj:SetText("");
			chldObj:Disable();			
		else
			chldObj:Enable();
		end		
		bttnTxtObj:SetText(newTxt);
		
		if (isTitle) then
			if ( NuNEditDetail_CheckButton:GetChecked() ) then
				hdNbr = pHead..bttnNumb;
				nameHdNbr = c_name..hdNbr;
				if (not NuNSettings[pKey][hdNbr]) then	
					NuNSettings[pKey][hdNbr] = {};
				end			
				NuNSettings[pKey][hdNbr].txt = newTxt;
				if ( NuNData[pKey][nameHdNbr] ) then
					NuNData[pKey][nameHdNbr] = nil;
				end
			else
				index = tonumber(bttnNumb);
				if ( ( newTxt == "" ) or ( newTxt == nil ) )then
					bttnChanges[index] = 1;
				else
					bttnChanges[index] = newTxt;
				end
			end
		else		
			index = bttnNumb + detlOffset;
			if ( newTxt == "" ) then
				bttnChanges[index] = 1;
			else
				bttnChanges[index] = newTxt;
			end
			if ( index == (detlOffset + 1) ) then
				prntTxtObj = getglobal("NuNTitleButton"..bttnNumb.."ButtonTextHeading");
				if ( prntTxtObj:GetText() == dfltHeadings[1] ) then
					c_guild = newTxt;
				end
			end
		end
		NuNEditDetails_HideFrame();		
	else
		NuNEditDetails_HideFrame();
	end
end



function NuNEditDetails_HideFrame()
	NuNButtonSaveNote:Enable();
	HideUIPanel(NuNEditDetailsFrame);
end



function NuNEditDetails_ShowFrame(isTitle)
	NuNButtonSaveNote:Disable();

	NuNText:ClearFocus();
	if (oriTxt == nil) then
		NuNEditDetailsBox:SetText("");
	else
		NuNEditDetailsBox:SetText(oriTxt);
	end
	if (isTitle) then
		NuNCheckBoxLabel:SetText("Save as Default");
		NuNEditDetail_CheckButton:SetChecked(0);
		NuNEditDetailsRestoreButton:Enable();
		NuNEditDetail_CheckButton:Show();
		NuNEditDetailsRestoreButton:Show();
	else
		NuNCheckBoxLabel:SetText("");
		NuNEditDetail_CheckButton:Hide();
		NuNEditDetailsRestoreButton:Hide();
	end
	ShowUIPanel(NuNEditDetailsFrame);
	NuNEditDetailsBox:SetFocus();
end



function NuNUserButton_OnClick(bttn)
	local bttnName = bttn:GetName();
	
	local prfx = (string.sub(bttnName,  1, 8));
	bttnNumb = (string.sub(bttnName, 15,  15));
	
	if (prfx == "NuNTitle") then
		isTitle = true;
		bttnTxtObj = getglobal(bttnName.."ButtonTextHeading");
	else
		isTitle = false;
		bttnTxtObj = getglobal(bttnName.."ButtonTextDetail");
	end
	oriTxt = bttnTxtObj:GetText();
	
	NuNEditDetails_ShowFrame(isTitle);
end



function NuN_EditDetailCheckButtonOnClick()
	if ( NuNEditDetail_CheckButton:GetChecked() ) then
		NuNEditDetailsRestoreButton:Disable();
	else
		NuNEditDetailsRestoreButton:Enable();
	end
end



function NuNEditDetailsRestore()
	nameHdNbr = c_name..pHead..bttnNumb;
	if ( NuNData[pKey][nameHdNbr] ) then
		NuNData[pKey][nameHdNbr] = nil;
	end
	NuNEditDetails_HideFrame();
	NuN_HideFrame();
	NuN_ShowNote();
end



-- Function Hooks - WARNING:following 4 functions are rewrites of originals.
--  Sorry, could find no way to use typical function hooking with the following functions
--  so there may be compatibility issues with other mods that have made use of them.
--  Also, tried to update the Note frame based on FRIENDLIST_UPDATE event, but no luck :(

function FriendsFrameFriendButton_OnClick()
 	SetSelectedFriend(this:GetID());
 	FriendsList_Update();
 	if ( NuNFrame:IsVisible() ) then
 		NuN_HideFrame();
 		NuN_ShowFriendNote();
 	end
end

function FriendsFrameIgnoreButton_OnClick()
	SetSelectedIgnore(this:GetID());
	IgnoreList_Update();
	if ( NuNFrame:IsVisible() ) then
		NuN_HideFrame();
		NuN_ShowIgnoreNote();
	end
end

function FriendsFrameGuildPlayerStatusButton_OnClick()
	GuildFrame.selectedGuildMember = getglobal("GuildFrameButton"..this:GetID()).guildIndex;
	GuildFrame.selectedName = getglobal("GuildFrameButton"..this:GetID().."Name"):GetText();
	SetGuildRosterSelection(GuildFrame.selectedGuildMember);
	GuildPlayerStatus_Update();
	if ( NuNFrame:IsVisible() ) then
		NuN_HideFrame();
		NuN_ShowGuildNote();
	end	
end

function FriendsFrameGuildStatusButton_OnClick()
	GuildFrame.selectedGuildMember = getglobal("GuildFrameGuildStatusButton"..this:GetID()).guildIndex;
	GuildFrame.selectedName = getglobal("GuildFrameGuildStatusButton"..this:GetID().."Name"):GetText();
	SetGuildRosterSelection(GuildFrame.selectedGuildMember);
	GuildStatus_Update();
	if ( NuNFrame:IsVisible() ) then
		NuN_HideFrame();
		NuN_ShowGuildNote();
	end
end




function NuN_Who()
	local wName = nil;
	local wGuildName = nil;
	local wRace = nil;
	local wClass = nil;
	local bttnHeadingText1;
	local bttnDetailText1;
	
	SendWho(c_name);
	
	local n = GetNumWhoResults();
	for i = 1, n, 1 do
		wName = GetWhoInfo(i);
		if ( wName == c_name ) then	
			wName, wGuildName, wLvl, wRace, wClass, wZone = GetWhoInfo(i);
			if ( wGuildName ~= nil ) then
				c_guild = wGuildName;
			end
			bttnHeadingText1 = getglobal("NuNTitleButton1ButtonTextHeading");
			bttnDetailText1 = getglobal("NuNInforButton1ButtonTextDetail");
			if ( bttnHeadingText1:GetText() == dfltHeadings[1] ) and ( wGuildName ~= nil) then
				bttnDetailText1:SetText(wGuildName);
				c_guild = wGuildName;
				if ( wGuildName == "" ) then
					bttnChanges[6] = 1;
				else
					bttnChanges[6] = wGuildName;
				end
			end
			if ( wClass ~= nil ) then
				c_class = wClass;
				ddClass = Get_TableID(Classes, c_class);
				UIDropDownMenu_SetSelectedID(NuNClassDropDown, ddClass);
				UIDropDownMenu_SetText(c_class, NuNClassDropDown);
			end
			if ( wRace ~= nil ) then
				c_race = wRace;
				ddRace = Get_TableID(Races, c_race);
				UIDropDownMenu_SetSelectedID(NuNRaceDropDown, ddRace);
				UIDropDownMenu_SetText(c_race, NuNRaceDropDown);
			end
		end
	end
end



function NuN_Target()
	local lName;
	local lRace;
	local lClass;
	local lSex;
	local lPvPRank;
	local lPvPRankID;
	local lgName;
	local lgRank;
	local lgRankIndex;
	local theUnitID = nil;

	if ( ( UnitInParty("target") ) or ( UnitInRaid("target") ) ) then
		theUnitID = "target";
	end

	if ( theUnitID == nil ) then
		theUnitID = NuN_CheckPartyByName(c_name);
	end
	
	if ( theUnitID ==  nil ) then
		theUnitID = NuN_CheckRaidByName(c_name);
	end
	
	if ( theUnitID == nil ) then
		TargetByName(c_name);
		lName = UnitName("target");
		if ( lName == c_name ) then
			theUnitID = "target";
		else
			ClearTarget();
		end
	end

	if ( unitTest == true ) then
		unitTest = false;
	else
		if ( theUnitID ~= nil ) then
			lRace = UnitRace(theUnitID);
			if ( lRace ~= nil ) then
				c_race = lRace;
				ddRace = Get_TableID(Races, c_race);
				UIDropDownMenu_SetSelectedID(NuNRaceDropDown, ddRace);
				UIDropDownMenu_SetText(c_race, NuNRaceDropDown);
			end		
	
			lClass = UnitClass(theUnitID);
			if ( lClass ~= nil ) then
				c_class = lClass;
				ddClass = Get_TableID(Classes, c_class);
				UIDropDownMenu_SetSelectedID(NuNClassDropDown, ddClass);
				UIDropDownMenu_SetText(c_class, NuNClassDropDown);
			end
	
			lSex = UnitSex(theUnitID);
			if ( lSex ~= nil ) then
				if ( lSex == 0 ) then
					lsex = "Male";
				else
					lsex = "Female";
				end
				ddSex = Get_TableID(Sexes, lsex);
				UIDropDownMenu_SetSelectedID(NuNSexDropDown, ddSex);
				UIDropDownMenu_SetText(lsex, NuNSexDropDown);
			end
	
			lPvPRankID = UnitPVPRank(theUnitID);
			if ( lPvPRankID ~= nil ) and ( lPvPRankID > 0 ) then
				lPvPRank = GetPVPRankInfo(lPvPRankID);
				ddCRank = Get_TableID(Ranks, lPvPRank);
				UIDropDownMenu_SetSelectedID(NuNCRankDropDown, ddCRank);
				UIDropDownMenu_SetText(lPvPRank, NuNCRankDropDown);
			end
	
			lgName, lgRank, lgRankIndex = GetGuildInfo(theUnitID);
			if ( lgName ~= nil ) then
				c_guild = lgName;
			end
			bttnHeadingText1 = getglobal("NuNTitleButton1ButtonTextHeading");
			bttnDetailText1 = getglobal("NuNInforButton1ButtonTextDetail");
			bttnHeadingText2 = getglobal("NuNTitleButton2ButtonTextHeading");
			bttnDetailText2 = getglobal("NuNInforButton2ButtonTextDetail");		
			if ( lgName ~= "" ) and ( lgName ~= nil ) then
				if ( bttnHeadingText1:GetText() == dfltHeadings[1] ) then
					bttnDetailText1:SetText(lgName);
					bttnChanges[6] = lgName;
				end
				if ( bttnHeadingText2:GetText() == dfltHeadings[2] ) then
					if ( lgRankIndex == 0 ) then
						lgRankTxt = ( "GM : "..lgRank );
					else
						lgRankTxt = ( lgRankIndex.." : "..lgRank );
					end
					bttnDetailText2:SetText(lgRankTxt);
					bttnChanges[7] = lgRankTxt;
				end
			else
				
			end
		end
	end
	return theUnitID;
end



function NuN_Delete()
	if ( NuNData[pKey][c_name] ) then
		NuNData[pKey][c_name] = nil;
	end	

	for n = 1, uBttns, 1 do
		nameHdNbr = c_name..pHead..n;
		nameDtNbr = c_name..pDetl..n;
		if ( NuNData[pKey][nameHdNbr] ) then
			NuNData[pKey][nameHdNbr] = nil;
		end
		if ( NuNData[pKey][nameDtNbr] ) then
			NuNData[pKey][nameDtNbr] = nil;
		end
	end
	NuN_HideFrame();
	if ( NuNSearchFrame:IsVisible() ) then
		deletedE = true;
		NuNSearch_Search();
	end
end

function NuNGNote_Delete()
	local c_note = NuNGNoteTitleButtonText:GetText();
	if ( NuNData[pKey][Notes][c_note] ) then
		NuNData[pKey][Notes][c_note] = nil;
	end
	HideUIPanel(NuNGNoteFrame);
	if ( NuNSearchFrame:IsVisible() ) then
		deletedE = true;
		NuNSearch_Search();
	end
end



function NuNOptions_ResetDefaults()
	if ( NuNSettings[pKey] ) then
		NuNSettings[pKey] = nil;
		NuNSettings[pKey] = {};
	end
end



function NuNOptions_Import()
	local x;
	local index;
	local value;
	local isInGuild = false;
	local lGuild = GetGuildInfo("player");
	if ( lGuild ~= nil ) then
		isInGuild = true;
	end
	
	importing = true;
	for index, value in NuNData[pKey] do
		if ( ( NuNData[pKey][index].faction ) and ( index == pName ) ) then
			NuNData[pKey][index].type = NUN_SELF_C;
		elseif ( ( NuNData[pKey][index].faction == pFaction ) and ( index ~= pName ) ) then
			if ( NuNData[pKey][index].ignoreLst ) then
				if ( not NuN_Is_Ignored(index) ) then
					if ( AddIgnore(index) ) then
						x = getn(NuNData[pKey][index].ignoreLst) + 1;
						NuNData[pKey][index].ignoreLst[x] = pName;
					end
				end
			elseif  ( ( isInGuild ) and ( NuNData[pKey][index].guild == lGuild ) and ( not NuNSettings[pKey].autoG ) ) then
				-- Forget this entry as they are guild mates with current player and settings say not to add as friend
			else
				if ( not NuN_Is_Friendly(index) ) then
					AddFriend(index);
					if ( not NuNData[pKey][index].friendLst ) then
						NuNData[pKey][index].friendLst = {};
					end
					if ( not Get_TableID(NuNData[pKey][index].friendLst, pName) ) then
						x = getn( NuNData[pKey][index].friendLst) + 1;
						NuNData[pKey][index].friendLst[x] = pName;
					end
				end
			end
		end
	end
	importing = false;
end

function NuNOptions_Export()
	local iName;
	for i = 1, GetNumFriends(), 1 do
		iName = GetFriendInfo(i);
		if ( not NuNData[pKey][iName] ) then
			NuNData[pKey][iName] = {};
			NuNData[pKey][iName].type = NUN_AUTO_C;
			NuNData[pKey][iName].faction = pFaction;
			NuNData[pKey][iName].txt = NUN_AUTO_FRIEND..NuN_GetDateStamp();
			NuNData[pKey][iName].friendLst = {};
			NuNData[pKey][iName].friendLst[1] = pName;
		end
	end	
	for i = 1, GetNumIgnores(), 1 do
		iName = GetIgnoreName(i);
		if ( not NuNData[pKey][iName] ) then
			NuNData[pKey][iName] = {};
			NuNData[pKey][iName].type = NUN_AUTO_C;
			NuNData[pKey][iName].faction = pFaction;
			NuNData[pKey][iName].txt = NUN_AUTO_IGNORE..NuN_GetDateStamp();
			NuNData[pKey][iName].ignoreLst = {};
			NuNData[pKey][iName].ignoreLst[1] = pName;
		end
	end	
end



function NuNOptions_Search()
	ddClassSearch = nil;
	ddProfSearch = nil;
	ddText = nil;
	lastBttnIndex = 0;
	lastBttn = nil;
	lastBttnDetl = nil;
	foundNuN = {};
	ShowUIPanel(NuNSearchFrame);
	HideUIPanel(NuNOptionsFrame);
	if ( ( ddSearch == 1 ) or ( ddSearch == 3 ) ) then
		NuNSearchFrameSearchButton:Disable();
		NuNSearchClassDropDown:Hide();
		NuNSearchProfDropDown:Hide();
		NuNSearchTextBox:Hide();
		NuNSearch_Search();
	elseif ( ddSearch == 2 ) then
		NuNSearchFrameSearchButton:Disable();
		UIDropDownMenu_ClearAll(NuNSearchClassDropDown);
		NuNSearchClassDropDown:Show();
		NuNSearchProfDropDown:Hide();
		NuNSearchTextBox:Hide();
		NuNSearch_Update();
	elseif ( ddSearch == 4 ) then
		NuNSearchFrameSearchButton:Disable();
		NuNSearchClassDropDown:Hide();
		UIDropDownMenu_ClearAll(NuNSearchProfDropDown);
		NuNSearchProfDropDown:Show();
		NuNSearchTextBox:Hide();
		NuNSearch_Update();
	else
		NuNSearchFrameSearchButton:Enable();
		NuNSearchClassDropDown:Hide();
		NuNSearchProfDropDown:Hide();
		NuNSearchTextBox:SetText("");
		NuNSearchTextBox:Show();	
		NuNSearch_Update();
	end		
end



function NuNSearch_Search()
	local index;
	local value;
	local countH = 0;
	local countA = 0;
	local countN = 0;
	local classType;
	local searchType = searchFor[ddSearch];
	if ( searchType == "Class" ) then
		classType = AllClasses[ddClassSearch];
	end
	foundNuN = {};
	foundHNuN = {};
	foundANuN = {};
	foundNNuN = {};

	NuN_HideFrame();
	
	for index, value in NuNData[pKey] do
		if ( searchType == "All" ) then
			if ( NuNData[pKey][index].faction == "Horde" ) then
				countH = countH + 1;
				foundHNuN[countH] = index;
			elseif ( NuNData[pKey][index].faction == "Alliance" ) then
				countA = countA + 1;
				foundANuN[countA] = index;
			end
		elseif ( searchType == "Class" ) then
			if ( NuNData[pKey][index].faction == "Horde" ) then
				if ( HClasses[NuNData[pKey][index].cls] == classType ) then
					countH = countH + 1;
					foundHNuN[countH] = index;
				end
			elseif ( NuNData[pKey][index].faction == "Alliance" ) then
				if ( AClasses[NuNData[pKey][index].cls] == classType ) then
					countA = countA + 1;
					foundANuN[countA] = index;	
				end
			end
		elseif ( searchType == "Profession" ) then
			if ( NuNData[pKey][index].faction == "Horde" ) then
				if ( ( NuNData[pKey][index].prof1 == ddProfSearch ) or ( NuNData[pKey][index].prof2 == ddProfSearch ) ) then
					countH = countH + 1;
					foundHNuN[countH] = index;
				end
			elseif ( NuNData[pKey][index].faction == "Alliance" ) then
				if ( ( NuNData[pKey][index].prof1 == ddProfSearch ) or ( NuNData[pKey][index].prof2 == ddProfSearch ) ) then
					countA = countA + 1;
					foundANuN[countA] = index;
				end			
			end			
		elseif ( searchType == "Text" ) then
			local tstTxt = NuNSearchTextBox:GetText();
			if ( NuNData[pKey][index].txt ) then
				if ( ( string.find(NuNData[pKey][index].txt, tstTxt) ) or ( string.find(index, tstTxt) ) ) then
					local tName = index;
					if ( not NuNData[pKey][index].faction ) then
						tName = nil;
						local pos = string.find(index, pDetl);
						if ( pos == nil ) then
							pos = string.find(index, pHead);
							if ( pos ~= nil ) then
								tName = string.sub(index, 1, (pos - 1));
							end
						else
							tName = string.sub(index, 1, (pos - 1));
						end
					end
					if ( tName ~= nil ) then
						if ( NuNData[pKey][tName].faction == "Horde" ) then
							if ( Get_TableID(foundHNuN, tName) == nil ) then
								countH = countH + 1;
								foundHNuN[countH] = tName;								
							end
						else
							if ( Get_TableID(foundANuN, tName) == nil ) then
								countA = countA + 1;
								foundANuN[countA] = tName;								
							end
						end
					end
				end
			end
		end
	end

	for index, value in NuNData[pKey][Notes] do
		if ( ( searchType == "All" ) or ( searchType == "Notes" ) ) then
			countN = countN + 1;
			foundNNuN[countN] = index;
		elseif ( searchType == "Text" ) then
			local tstTxt = NuNSearchTextBox:GetText();
			if ( ( string.find(NuNData[pKey][Notes][index].txt, tstTxt)) or ( string.find(index, tstTxt ) ) ) then
				countN = countN + 1;
				foundNNuN[countN] = index;
			end
		end
	end
	
	table.sort(foundANuN);
	table.sort(foundHNuN);
	table.sort(foundNNuN);
	NuN_DefaultSort();

	NuNSearch_Update();
	if ( ( deletedE ) and ( visibles > 0 ) and ( lastBttn ~= nil ) ) then
		deletedE = false;
		if ( lastBttnIndex > visibles ) then
			NuNSearch_HighlightRefresh(lastVisible);
			NuNSearchNote_OnClick(lastVisible);
		else
			NuNSearch_HighlightRefresh(lastBttn);
			NuNSearchNote_OnClick(lastBttn);
		end
	else
		NuNSearch_HighlightRefresh(nil);
	end
end



function NuN_DefaultSort()
	if ( horde ) then
		NuN_copyT(foundNuN, foundHNuN, NUN_HORD_C);
		NuN_copyT(foundNuN, foundANuN, NUN_ALLI_C);
		NuN_copyT(foundNuN, foundNNuN, NUN_NOTE_C);
	else
		NuN_copyT(foundNuN, foundANuN, NUN_ALLI_C);
		NuN_copyT(foundNuN, foundHNuN, NUN_HORD_C);
		NuN_copyT(foundNuN, foundNNuN, NUN_NOTE_C);
	end
end



function NuN_copyT(t1, t2, c_prefix)
	local i1 = getn(t1);
	for i2=1, getn(t2), 1 do
		i1 = i1 + 1;
		t1[i1] = c_prefix..t2[i2];
	end
end



function NuNSearch_Back()
	if ( NuNFrame:IsVisible() ) then
		NuN_HideFrame();
	end
	if ( NuNGNoteFrame:IsVisible() ) then
		HideUIPanel(NuNGNoteFrame);
	end
	HideUIPanel(NuNSearchFrame);
	ShowUIPanel(NuNOptionsFrame);
end



function NuNSearch_Update()
	local theNoteIndex;
	local theOffsetNoteIndex;
	local theNote;
	local theNoteHFlag;
	local theNoteAFlag;
	local theNoteNFlag;
	local numNuNFound = getn(foundNuN);
	
	visibles = 0;
	FauxScrollFrame_Update(NuNSearchListScrollFrame, numNuNFound, NUN_SHOWN, NUN_NOTE_HEIGHT);
	for theNoteIndex=1, NUN_SHOWN, 1 do
		theOffsetNoteIndex = theNoteIndex + FauxScrollFrame_GetOffset(NuNSearchListScrollFrame);
		theNote = getglobal( "NuNSearchNote"..theNoteIndex );
		theNoteHFlag = getglobal( "NuNSearchNote"..theNoteIndex.."FrameHFlag" );
		theNoteAFlag = getglobal( "NuNSearchNote"..theNoteIndex.."FrameAFlag" );
		theNoteNFlag = getglobal( "NuNSearchNote"..theNoteIndex.."FrameNFlag" );
		if ( theOffsetNoteIndex > numNuNFound ) then
			theNote:Hide();
		else
			theNote:SetText( string.sub(foundNuN[theOffsetNoteIndex], 2) );
			if ( string.sub(foundNuN[theOffsetNoteIndex], 1, 1) == NUN_HORD_C ) then
				theNoteAFlag:Hide();
				theNoteNFlag:Hide();
				theNoteHFlag:Show();
			elseif ( string.sub(foundNuN[theOffsetNoteIndex], 1, 1) == NUN_ALLI_C ) then
				theNoteHFlag:Hide();
				theNoteNFlag:Hide();
				theNoteAFlag:Show();
			else
				theNoteHFlag:Hide();
				theNoteAFlag:Hide();
				theNoteNFlag:Show();
			end
			theNote:Show();
			visibles = visibles + 1;
			lastVisible = theNote;
			if ( theOffsetNoteIndex == lastBttnDetl ) then
				theNote:LockHighlight();
			else
				theNote:UnlockHighlight();
			end
		end
	end
end



function NuNSearchNote_OnClick(bttnNote)
	local noteName;
	local lclNote;
	local lclNoteHFlag;
	local lclNoteAFlag;
	local lclNoteNFlag;
	local lastBttnDetlN;
	local nType;

	noteName = bttnNote:GetText();	
	lastBttn = bttnNote;
	for i = 1, NUN_SHOWN, 1 do
		lclNote = getglobal("NuNSearchNote"..i);
		if ( lclNote == bttnNote ) then
			lclNoteHFlag = getglobal( "NuNSearchNote"..i.."FrameHFlag" );
			lclNoteAFlag = getglobal( "NuNSearchNote"..i.."FrameAFlag" );
			if ( lclNoteHFlag:IsVisible() ) then
				lastBttnDetlN = NUN_HORD_C..noteName;
				nType = "C";
			elseif ( lclNoteAFlag:IsVisible() ) then
				lastBttnDetlN = NUN_ALLI_C..noteName;
				nType = "C";
			else
				lastBttnDetlN = NUN_NOTE_C..noteName;
				nType = "G";
			end
			lastBttnIndex = i;
			lastBttnDetl = Get_TableID(foundNuN, lastBttnDetlN);
			break;
		end
	end
	
	NuNSearch_HighlightRefresh(bttnNote);
	if ( NuNFrame:IsVisible() ) then
		NuN_HideFrame();
	end
	if ( NuNGNoteFrame:IsVisible() ) then
		HideUIPanel(NuNGNoteFrame);
	end

	if ( nType == "C" ) then	
		c_name = noteName;
		NuN_ShowSavedNote( c_name );
	else
		c_note = noteName;
		NuN_ShowSavedGNote();
	end
end



function NuNSearch_HighlightRefresh(tstNote)
	local theNote;
	for i=1, NUN_SHOWN, 1 do
		theNote = getglobal("NuNSearchNote"..i);
		if ( ( theNote == tstNote ) and ( theNote:IsVisible() ) ) then
			theNote:LockHighlight();
		else
			theNote:UnlockHighlight();
		end
	end
end



function NuN_DateStamp()
	NuNText:SetText(NuNText:GetText().."\n"..NuN_GetDateStamp());
end

function NuNGNote_DateStamp()
	NuNGNoteTextScroll:SetText(NuNGNoteTextScroll:GetText().."\n"..NuN_GetDateStamp());
end

function NuN_GetDateStamp()
	local dateStamp = date("%A, %d %B %Y  %H:%M:%S");
	return dateStamp;
end



function NuN_Loc()
	NuNText:SetText(NuNText:GetText().."\n"..NuN_GetLoc());
end

function NuNGNote_Loc()
	NuNGNoteTextScroll:SetText(NuNGNoteTextScroll:GetText().."\n"..NuN_GetLoc());
end

function NuN_GetLoc()
	local locData = pName.."'s "..NUN_LOC.." : ";
	local myCID, myC, mySubZ, myZID, myZ, px, py, coords;
	local loc = false;
	
	myCID = GetCurrentMapContinent();
	if ( ( myCID ~= nil) and ( myCID > 0 ) ) then
		myC = c_continents[myCID].name;
	end
	if ( myC ~= nil ) then
		locData = locData..myC..", ";
		loc = true;
	end
	
	myZ = GetZoneText();
	if ( ( myZ == nil ) or ( myZ == "" ) ) then
		myZID = GetCurrentMapZone();
		if ( ( myZID ~= nil ) and ( myCID ~= nil ) and ( myCID > 0 ) ) then
			myZ = c_continents[myCID].zones[myZID];
		end
	end
	if ( ( myZ ~= nil ) and ( myZ ~= "" ) ) then
		locData = locData..myZ..", ";
	end


	mySubZ = GetSubZoneText();
	if ( ( mySubZ == nil ) or ( mySubZ == "" ) ) then
		mySubZ = GetMinimapZoneText();
	end
	if ( mySubZ ~= nil ) then
		locData = locData..mySubZ..", ";
		loc = true;
	end

	px, py = GetPlayerMapPosition("player");
    	if ( ( px ~= nil ) and ( py ~= nil ) ) then
        	coords = format("(%d, %d)", px * 100.0, py * 100.0);
		locData = locData..coords;
		loc = true; 
    	end
    	if ( loc == true ) then
		return locData;
	else
		return "";
	end
end



function NuN_AutoNote()
	local lName;
	local lRace;
	local lClass;
	local lSex;
	local lPvPRank;
	local lPvPRankID;
	local lgName;
	local lgRank;
	local lgRankIndex;
	local bttnKey;
	
	if ( pFaction ~= nil ) then	
		NuNData[pKey][pName] = {};
		NuNData[pKey][pName].type = NUN_SELF_C;
		NuNData[pKey][pName].faction = pFaction;
		NuNData[pKey][pName].txt = "";
		lRace = UnitRace("player");
		if ( lRace ~= nil ) then
			ddRace = Get_TableID(Races, lRace);
			NuNData[pKey][pName].race = ddRace;
		end		
		lClass = UnitClass("player");
		if ( lClass ~= nil ) then
			ddClass = Get_TableID(Classes, lClass);
			NuNData[pKey][pName].cls = ddClass;
		end
		lSex = UnitSex("player");
		if ( lSex ~= nil ) then
			NuNData[pKey][pName].sex = lSex + 1;
		end
		lPvPRankID = UnitPVPRank("player");
		if ( lPvPRankID ~= nil ) and ( lPvPRankID > 0 ) then
			lPvPRank = GetPVPRankInfo(lPvPRankID);
			ddCRank = Get_TableID(Ranks, lPvPRank);
			NuNData[pKey][pName].crank = ddCRank;
		end
		lgName, lgRank, lgRankIndex = GetGuildInfo("player");
		if ( lgName ~= "" ) and ( lgName ~= nil ) then
			bttnKey = pName..pDetl.."1";
			NuNData[pKey][bttnKey] = {};
			NuNData[pKey][bttnKey].txt = lgName;
			bttnKey = pName..pDetl.."2";
			NuNData[pKey][bttnKey] = {};
			if ( lgRankIndex == 0 ) then
				NuNData[pKey][bttnKey].txt = ( "GM : "..lgRank );
			else
				NuNData[pKey][bttnKey].txt = ( lgRankIndex.." : "..lgRank );
			end
		end
	end
end



function NuN_ClrDD()
	if ( lastDD == "Race" ) then
		UIDropDownMenu_ClearAll(NuNRaceDropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].race ) ) then
			ddRace = -1;
		else
			ddRace = nil;	
		end
	elseif ( lastDD == "Class" ) then
		UIDropDownMenu_ClearAll(NuNClassDropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].cls ) ) then
			ddClass = -1;
		else
			ddClass = nil;
		end
	elseif ( lastDD == "Sex" ) then
		UIDropDownMenu_ClearAll(NuNSexDropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].sex ) ) then
			ddSex = -1;
		else
			ddSex = nil;
		end
	elseif ( lastDD == "Prof1" ) then
		UIDropDownMenu_ClearAll(NuNProf1DropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].prof1 ) ) then
			ddProf1 = -1;
		else
			ddProf1 = nil;
		end
	elseif ( lastDD == "Prof2" ) then
		UIDropDownMenu_ClearAll(NuNProf2DropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].prof2 ) ) then
			ddProf2 = -1;
		else
			ddProf2 = nil;
		end
	elseif ( lastDD == "CRank" ) then
		UIDropDownMenu_ClearAll(NuNCRankDropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].crank ) ) then
			ddCRank = -1;
		else
			ddCRank = nil;
		end
	elseif ( lastDD == "HRank" ) then
		UIDropDownMenu_ClearAll(NuNHRankDropDown);
		if ( ( NuNData[pKey][c_name] ) and ( NuNData[pKey][c_name].hrank ) ) then
			ddHRank = -1;
		else
			ddHRank = nil;
		end
	end
	lastDD = nil;
	NuNButtonClrDD:Disable();
end


function NuN_ShowSavedGNote()
	NuNGNoteHeader:SetText(NUN_SAVED_NOTE);
	ShowUIPanel(NuNGNoteFrame);
	NuNGNoteTextBox:Hide();
	NuNGNoteTextScroll:SetText(NuNData[pKey][Notes][c_note].txt);
	NuNGNoteTitleButtonText:SetText(c_note);
	NuNGNoteTitleButton:Show();
	NuNGNoteTextScroll:SetFocus("true");
	NuNGNoteButtonSaveNote:Enable();
	NuNGNoteButtonDateStamp:Enable();
	NuNGNoteButtonLoc:Enable();
	NuNGNoteButtonDelete:Enable();
end

function NuN_ShowTitledGNote()
	NuNGNoteHeader:SetText(NUN_NEW_NOTE);
	ShowUIPanel(NuNGNoteFrame);
	NuNGNoteTextScroll:SetText("");
	NuNGNoteTextBox:Hide();
	NuNGNoteTitleButtonText:SetText(c_note);
	NuNGNoteTitleButton:Show();
	NuNGNoteTextScroll:SetFocus("true");
	NuNGNoteButtonSaveNote:Enable();
	NuNGNoteButtonDateStamp:Enable();
	NuNGNoteButtonLoc:Enable();
	NuNGNoteButtonDelete:Disable();
end

function NuN_ShowNewGNote()
	if ( NuNGNoteFrame:IsVisible() ) then
		NuNGNoteFrame:Hide();
	else
		NuNGNoteHeader:SetText(NUN_NEW_NOTE);
		ShowUIPanel(NuNGNoteFrame);
		NuNGNoteTextScroll:SetText("");
		NuNGNoteTitleButton:Hide();
		NuNGNoteTextBox:SetText("");
		NuNGNoteTextBox:Show();
		NuNGNoteTextBox:SetFocus("true");
		NuNGNoteButtonDelete:Disable();
	end
end



function NuN_OptionsGuildCheckBox_OnClick()
	if ( NuNOptionsGuildCheckButton:GetChecked() ) then
		NuNSettings[pKey].autoG = "1";
	else
		NuNSettings[pKey].autoG = nil;
	end
end

function NuN_OptionsAddCheckBox_OnClick()
	if ( NuNOptionsAddCheckButton:GetChecked() ) then
		NuNSettings[pKey].autoA = "1";
	else
		NuNSettings[pKey].autoA = nil;
	end
end

function NuN_OptionsDeleteCheckBox_OnClick()
	if ( NuNOptionsDeleteCheckButton:GetChecked() ) then
		NuNSettings[pKey].autoD = "1";
	else
		NuNSettings[pKey].autoD = nil;
	end
end



function NuN_OnUpdate(arg1)		    	
	if ( MouseIsOver(NuNMicroFrame) ) then
		NuNMicroBorder:Show();
	else
		NuNMicroBorder:Hide();
	end
	timeSinceLastUpdate = timeSinceLastUpdate + arg1;
	if ( timeSinceLastUpdate > updateInterval ) then
		if ( not NuNData[pKey][pName] ) then
			NuN_AutoNote();
		end
		NuN_Update_Friends();
		NuN_Update_Ignored();
		timeSinceLastUpdate = 0;
	end
end



function NuN_NewContact(unitType)
	local Friendly;
	
	if ( NuNFrame:IsVisible() ) then
		NuNFrame:Hide();
	else
		if ( unitType == "target" ) then
			if ( UnitIsFriend("player", "target") ) then
				Friendly = true;
			else
				Friendly = false;
			end
			c_name = UnitName("target");		
		else
			Friendly = true;		
		end
		if ( ((horde) and (Friendly))  or  ((not horde) and (not Friendly)) ) then
			c_faction = "Horde";
			NuN_HordeSetup();
		else
			c_faction = "Alliance";
			NuN_AllianceSetup();
		end
		c_route = "Target";
		c_race = nil;
		c_class = nil;
		c_guild = nil;
		gRank = nil;
		gRankIndex = nil;
		gNote = nil;
		gOfficerNote = nil;	
		NuN_ShowNote();
		NuN_Target();
		if ( c_name == pName ) then
			ClearTarget();
		end
	end
end


function NuN_HordeSetup()
	NuNRaceDropDown = NuNHRaceDropDown;
	NuNClassDropDown = NuNHClassDropDown;
	NuNCRankDropDown = NuNHCRankDropDown;
	NuNHRankDropDown = NuNHHRankDropDown;
	NuNARaceDropDown:Hide();
	NuNHRaceDropDown:Show();
	NuNAClassDropDown:Hide();
	NuNHClassDropDown:Show();
	NuNACRankDropDown:Hide();
	NuNHCRankDropDown:Show();
	NuNAHRankDropDown:Hide();
	NuNHHRankDropDown:Show();
	Classes = HClasses;
	Races = HRaces;
	Ranks = HRanks;
	NuNAFlag:Hide();
	NuNHFlag:Show();
end

function NuN_AllianceSetup()
	NuNRaceDropDown = NuNARaceDropDown;
	NuNClassDropDown = NuNAClassDropDown;
	NuNCRankDropDown = NuNACRankDropDown;
	NuNHRankDropDown = NuNAHRankDropDown;
	NuNHRaceDropDown:Hide();
	NuNARaceDropDown:Show();
	NuNHClassDropDown:Hide();
	NuNAClassDropDown:Show();
	NuNHCRankDropDown:Hide();
	NuNACRankDropDown:Show();
	NuNHHRankDropDown:Hide();
	NuNAHRankDropDown:Show();
	Classes = AClasses;
	Races = ARaces;
	Ranks = ARanks;		
	NuNHFlag:Hide();
	NuNAFlag:Show();	
end


function NuN_CheckPartyByName(parmN)
	local partym;
	
	for groupIndex = 1, MAX_PARTY_MEMBERS, 1 do
 		if (GetPartyMember(groupIndex)) then
 			partym = "party"..groupIndex;
 			lName = UnitName(partym);
 			if ( lName == parmN) then 
 				return partym;
 			end
 		end
	end
	return nil;
end

function NuN_CheckRaidByName(parmN)
	local raidm;
	local lclName;
	local numRaid = GetNumRaidMembers();

	for raidIndex = 1, numRaid, 1 do
		lclName = GetRaidRosterInfo(raidIndex);
		if ( lclName == parmN ) then
			raidm = "raid"..raidIndex;
			return raidm;
		end
	end
	return nil;
end

-------------------------------------------------------------------------------