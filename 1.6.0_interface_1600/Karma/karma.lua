-- KARMA v0.7.1
--		* Fixed remaining nil evaluation errors.
--		* PopBar/Karma no longer conflict with one another.
--
-- KARMA v0.7
--		* Bug Fixes for NIL evaluation errors.
--
-- KARMA v0.6
--		* Fixed alphabetical sorting algorithms to work with names starting with accented characters.
--		* Fixed questlist xml, so it now positions the names correctly.
--		* Added tooltip for memberlist so moving over a member will now show the character's information.
--
-- KARMA v0.5
--		* Optimized the sorting functions (much, much, much faster now.)
--		* Upgraded database to version 4.
--		* Added autoignore functionality
--
-- KARMA v0.4
--		* Added new sorting functions:
--				name,xp,karma,played
--		* Added new color functions:
--				xp,karma,played
--		* Added new "playedtime" functions.
--		* Added functions for "playedtime"
--		* Added many more command line commands:
--			addmember,removemember,sortby,colorby,givekarma,takekarma
--
-- KARMA v0.3
-- 		* complete rewrite.
--
-- KARMA v0.2
--		* Karma now has a color reflecting the value.
--		* List now sorts according to the karma rating.
-- 		* names in the list are colored according to karma.
--		* new sorting function.
--
--
-- KARMA v0.1
--
-- How many times do you wish, you knew what people in your group, you had:
--		* Grouped with before
--		*	Completed Quests with before
--	  * Earned Experience with before
--		* Liked/Disliked grouping with before
--		* Noted why you like/disliked this person.


----------------------------------------------
-- GLOBALS
----------------------------------------------

KARMA_LOADED=0;

KarmaData = {};
-- Karma data is stored in the following tree:
--	KarmaData= {};
--		REALMS={};
--			FACTIONLIST={};
--				CHARACTERLIST={};
--				MEMBERBUCKETS={[A]={} ... [Z]={}};
--				QUESTNAMES={};


KarmaConfig = {};

KARMA_CURRENTMEMBER=nil;
KARMA_TOPMEMBER=0;
KARMA_INDENT=0;
KARMA_PROFILE_FRAME=nil;
KARMA_VERSION_TEXT="0.7.1";
KARMA_TEXT_LOG="";
KARMA_MEMBERLIST_SIZE=25;

--BINDING Names
BINDING_HEADER_KARMA = "Karma Keybindings";
BINDING_NAME_KARMAWINDOW ="Toggle Karma Window"; 

-- DEBUG
KARMA_ALWAYS_WATCH_EVENTS=false;

----------------------------------------------
-- CONSTS
----------------------------------------------

local		KARMA_SUPPORTEDDATABASEVERSION=7;


-- TOP LEVEL FIELDS
local		KARMA_FIELD_VERSION="VERSION";
local		KARMA_FIELD_REALMLIST="REALMS";


-- REALM LEVEL FIELDS
local		KARMA_REALMFIELD_FACTION="FACTIONLIST";

-- FACTION LEVEL FIELDS
local		KARMA_FACTIONFIELD_CHARACTERLIST="CHARACTERLIST";
local		KARMA_FACTIONFIELD_MEMBERLIST="MEMBERLIST"; -- No longer used after version 3 of the database
local		KARMA_FACTIONFIELD_MEMBERBUCKETS="MEMBERBUCKETS";
local		KARMA_FACTIONFIELD_QUESTNAMES="QUESTNAMES";
local		KARMA_FACTIONFIELD_ZONENAMES="ZONENAMES";


-- CHARACTER OBJECT FIELDS
local		KARMA_CHARACTERFIELD_NAME="NAME";
local		KARMA_CHARACTERFIELD_XPTOTAL="XPTOTAL";
local		KARMA_CHARACTERFIELD_XPLAST="XPLAST";
local		KARMA_CHARACTERFIELD_XPMAX="XPMAX";
local 		KARMA_CHARACTERFIELD_PLAYED="PLAYED";
local		KARMA_CHARACTERFIELD_PLAYEDLAST="PLAYEDLAST";

-- MEMBERLIST 
local		KARMA_MEMBERFIELD_NAME="NAME";
local		KARMA_MEMBERFIELD_LEVEL="LEVEL";
local		KARMA_MEMBERFIELD_CLASS="CLASS";
local		KARMA_MEMBERFIELD_GENDER="GENDER";
local		KARMA_MEMBERFIELD_GUILD="GUILD";
local		KARMA_MEMBERFIELD_NOTES="NOTES";
local		KARMA_MEMBERFIELD_KARMA="KARMA";
local		KARMA_MEMBERFIELD_RACE="RACE";
local		KARMA_MEMBERFIELD_CHARACTERS="CHARACTERSPECIFIC";
local		KARMA_MEMBERFIELD_CHARACTERS_QUESTIDLIST="QUESTIDLIST";
local		KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST="ZONEIDLIST";
local		KARMA_MEMBERFIELD_CHARACTERS_XP="XP";
local		KARMA_MEMBERFIELD_CHARACTERS_XPLAST="XPLAST";
local		KARMA_MEMBERFIELD_CHARACTERS_XPMAX="XPMAX";
local 		KARMA_MEMBERFIELD_CHARACTERS_PLAYED="PLAYED";
local		KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST="PLAYEDLAST";


-- CONFIG FIELDS
local		KARMA_CONFIG_SORTFUNCTION="SORTFUNCTION";
local		KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA ="KARMASORT";
local		KARMA_CONFIG_SORTFUNCTION_TYPE_NAME  ="NAMESORT";
local 		KARMA_CONFIG_SORTFUNCTION_TYPE_XP    ="XPSORT"
local		KARMA_CONFIG_SORTFUNCTION_TYPE_PLAYED="PLAYEDSORT";

local		KARMA_CONFIG_COLORFUNCTION="COLORFUNCTION";
local 		KARMA_CONFIG_COLORFUNCTION_TYPE_XP	 ="XPCOLOR";
local		KARMA_CONFIG_COLORFUNCTION_TYPE_KARMA="KARMACOLOR";
local 		KARMA_CONFIG_COLORFUNCTION_TYPE_PLAYED="PLAYEDCOLOR";

local		KARMA_CONFIG_AUTOIGNORE="AUTOIGNORE";
local		KARMA_CONFIG_AUTOIGNORE_THRESHOLD="AUTOIGNORE_THRESHOLD";
local		KARMA_CONFIG_AUTOIGNORE_INVITES="AUTOIGNORE_INVITES";

local		KARMA_CONFIG_AUTOBEFRIEND="AUTOBEFRIEND";
local		KARMA_CONFIG_AUTOBEFRIEND_THRESHOLD="AUTOBEFRIEND_THRESHOLD";
  

local		KARMA_ALPHACHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
local		KARMA_ALPHACHARS_ACCENT=
{
	["A"]={[1]=192,[2]=193,[3]=193,[4]=194,[5]=195,[6]=196,[7]=197,[8]=198},
	["C"]={[1]=199},
	["D"]={[1]=208},
	["E"]={[1]=200,[2]=201,[3]=202,[4]=203},
	["I"]={[1]=204,[2]=205,[3]=206,[4]=207},
	["N"]={[1]=209},
	["O"]={[1]=210,[2]=211,[3]=212,[4]=213,[5]=214,[6]=215,[7]=216},
	["U"]={[1]=217,[2]=218,[3]=219,[4]=220},
	["Y"]={[1]=221}
};

----------------------------------------------
--	Local variables
----------------------------------------------
local	KARMA_LastUpdateTime = 0;
local	KARMA_LastCommandTime =0;
local	KARMA_WhoElapsedTime  =0;
local 	KARMA_SortedNames=nil;
local   KARMA_PartyNames={};
local	KARMA_PlayerObjCache={};
local KARMA_CacheFriendListText=nil;
KARMA_QuestCache={};

-- Queues
Karma_Executing_Command=false;
Karma_CommandQueue={}
Karma_WhoQueue={};

-- Patch routine holders
KARMA_OriginalPlayerMenu={};
KARMA_KarmaPlayerMenu={};
KARMA_OriginalUnitPopupFunction=nil;
KARMA_OriginalTargetFrame_CheckFaction=nil;
KARMA_OriginalChatFrame_OnEvent=nil;
KARMA_Original_UIParent_OnEvent=nil;
KARMA_Original_Who_Update=nil;
KARMA_Original_Show_FriendsFrame=nil;

----------------------------------------------
-- FUNCTIONS
----------------------------------------------

function Toggle_Karma_UUI()
	if ( KarmaWindow:IsVisible() ) then 
		KarmaWindow:Hide();
		KarmaOptionsWindow:Hide();
		PlaySound("igMainMenuClose");
	else
		PlaySound("igMainMenuOpen");
		Karma_CreateDatabase();
		KarmaWindow:Show();
		KarmaWindow_DressUp();	
		KarmaWindow_Update();	
	end
end

function Karma_OnLoad()
	Karma_SetupDebug();
	ProfileStart("Karma_OnLoad");
	SLASH_KARMA1 = "/karma";
	SlashCmdList["KARMA"] = function(msg)
		Karma_SlashCommandHandler(msg);
	end

	if( DEFAULT_CHAT_FRAME ) then
		--DEFAULT_CHAT_FRAME:AddMessage("Karma "..KARMA_VERSION_TEXT.." Loaded"); -- We want this to show up in the main chat window.
	end

	this:RegisterEvent("VARIABLES_LOADED");
	
-- ======================================================
-- Start of Ultimate UI Spellbook Registration
-- ======================================================
   if ( UltimateUI_RegisterButton ) then
      UltimateUI_RegisterButton (
		"Karma",
		"Configure",
		"Show the karma settings window.",
		"Interface\\Icons\\Spell_Shadow_Shadowform",
		Toggle_Karma_UUI
	);
   end
-- ======================================================
-- End of Ultimate UI Spellbook Registration
-- ======================================================

	ProfileStop("Karma_OnLoad");
end

function Karma_OnEvent(event)
	ProfileStart("Karma_OnEvent");
	if  (DEFAULT_CHAT_FRAME) then
		local eventtext=""
		local count=0;
		eventtext = event;
		for count = 1,10 do
			local av=getglobal("arg"..count);
			if (av ~= nil and av~="") then
				eventtext=eventtext.."  arg"..count.."="..av;
			end
		end
		if (KARMA_ALWAYS_WATCH_EVENTS==false) then
			KarmaDebug(eventtext);
		else
			DEFAULT_CHAT_FRAME:AddMessage(eventtext,1.0,0,0.90);			
		end
	end

	if( event == "VARIABLES_LOADED" ) then		
		this:RegisterEvent("PARTY_MEMBERS_CHANGED");
		this:RegisterEvent("PLAYER_XP_UPDATE");
		this:RegisterEvent("QUEST_COMPLETE");
		this:RegisterEvent("QUEST_FINISHED");
		this:RegisterEvent("QUEST_ITEM_UPDATE");
		this:RegisterEvent("QUEST_PROGRESS");
		this:RegisterEvent("QUEST_DETAIL");
		this:RegisterEvent("QUEST_LOG_UPDATE");		
		this:RegisterEvent("INSTANCE_BOOT_START");
		this:RegisterEvent("INSTANCE_BOOT_STOP");
		this:RegisterEvent("UNIT_NAME_UPDATE");
		this:RegisterEvent("PLAYER_TARGET_CHANGED");
		this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH");
		this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	elseif (event=="PARTY_MEMBERS_CHANGED") then
		if (KARMA_LOADED==1) then
			if (Karma_EverythingLoaded()) then
				Karma_MemberList_CreatePartyNamesCache();
				Karma_MemberList_CreateMemberNamesCache(); 
				Karma_AddTimeToPartyMembers();					
				KarmaWindow_Update();
			end
		end
	elseif (event=="PLAYER_XP_UPDATE") then
		if (KARMA_LOADED==1) then
			if (Karma_EverythingLoaded()) then
				Karma_AddTimeToPartyMembers();
				Karma_AddXPToPartyMembers();		
				KarmaWindow_Update();			
			end
		end
	elseif (event=="QUEST_COMPLETE" or event=="QUEST_FINISHED" or event=="QUEST_LOG_UPDATE" or event=="QUEST_ITEM_UPDATE" or event=="QUEST_DETAIL" or event=="QUEST_PROGRESS" ) then
		if (KARMA_LOADED==1) then
			if (Karma_EverythingLoaded()) then
				for name,value in KARMA_QuestCache do 
					for i=1,GetNumQuestLogEntries() do
						local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
						if (isComplete==nil) then
							isComplete=0;
						end
						if (name==questLogTitleText and value.complete~=isComplete) then
							Karma_AddQuestToPartyMembers(name);
							KarmaWindow_Update();
						end
					end
				end
				Karma_CreateQuestCache();
			end
		end
	elseif (event=="INSTANCE_BOOT_START") then
		KARMA_LOADED=0;
	elseif (event=="INSTANCE_BOOT_STOP") then 
		KARMA_LOADED=1;
	elseif (event=="UNIT_NAME_UPDATE") then
		if (UnitName("player")~=nil and UnitName("player") ~= UNKNOWNOBJECT and UnitName("player") ~= "") then
			KARMA_LOADED=1;			
			Karma_InitializeConfig();		
			Karma_CreateDatabase();
			Karma_UpgradeDatabase();
			Karma_Faction_Cache();
			Karma_IntializePlayerObject();
			Karma_CleanDatabase(); -- Sometimes we get crap entries. Clear them
			Karma_InsertUnitPopupPatch();
			Karma_InsertTargetFramePatch();
			Karma_InsertUIParentPatch();
			Karma_InsertChatFramePatch();		
			Karma_InsertWhoUpdatePatch();
			Karma_CreateQuestCache();
			Karma_MemberList_CreatePartyNamesCache();
			Karma_MemberList_CreateMemberNamesCache(); 
			Karma_AddTimeToPartyMembers();	
		else
			Karma_MemberList_CreatePartyNamesCache();	
			Karma_LOADED=0;		
		end
	end
	ProfileStop("Karma_OnEvent");	
end


function Karma_EverythingLoaded()
	if (UnitName("player")~=nil and UnitName("player") ~= "") then
		x=Karma_Faction_GetFactionObject();
		if (x~=nil) then
			return true;
		end
	end
	return false;
end

function Karma_SlashCommandHandler(msg)
	local args={};
	local counter=0;
	local i=0;	
	
	-- Split commands
	for w in string.gfind(msg, "%w+") do
		counter=counter+1;
		args[counter]=w;
	end
	
	if (args[1]=="window") then
		Karma_ToggleWindow();	
	end
	if (args[1]=="addmember") then
		if (counter>=2) then
			Karma_CommandQueue[getn(Karma_CommandQueue)+1]={name="addmembercheck - "..args[2], func=Karma_Command_AddMember_Start, args={name=args[2]}};
			Karma_CommandQueue[getn(Karma_CommandQueue)+1]={name="", func=Karma_Command_UpdateMembers, args={}};
		end
	end
	if (args[1]=="givekarma") then
		if (args[2] == nil) then
			args[2]=UnitName("target");
		end
		if (args[2] ~= nil) then
			Karma_MemberList_Add(args[2]);
			Karma_MemberList_Update(args[2]);
			for i=1,3 do
				Karma_IncreaseKarma(args[2],false);
			end			
			KARMA_CURRENTMEMBER=args[2];
			KarmaWindow_ScrollToCurrentMember();
			KarmaWindow_Update();
		end
	end
	if (args[1]=="takekarma") then
		if (args[2] == nil) then
			args[2]=UnitName("target");
		end
		if (args[2] ~= nil) then
			Karma_MemberList_Add(args[2]);
			Karma_MemberList_Update(args[2]);
			for i=1,3 do
				Karma_DecreaseKarma(args[2],false);
			end			
			KARMA_CURRENTMEMBER=args[2];
			KarmaWindow_ScrollToCurrentMember();
			KarmaWindow_Update();
		end
	end
	if (args[1]=="sortby") then
		if (counter>=2) then
			if (args[2]=="name") then
				KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_CONFIG_SORTFUNCTION_TYPE_NAME;
			elseif (args[2]=="xp" or args[2]=="exp") then
				KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_CONFIG_SORTFUNCTION_TYPE_XP;				
			elseif (args[2]=="karma") then
				KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA;
			elseif (args[2]=="played") then
				KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_CONFIG_SORTFUNCTION_TYPE_PLAYED;
			end
			KarmaWindow_Update();
		end
	end

	if (args[1]=="colorby") then
		if (counter>=2) then
			if (args[2]=="xp" or args[2]=="exp") then
				KarmaConfig[KARMA_CONFIG_COLORFUNCTION]=KARMA_CONFIG_COLORFUNCTION_TYPE_XP;				
			elseif (args[2]=="karma") then
				KarmaConfig[KARMA_CONFIG_COLORFUNCTION]=KARMA_CONFIG_COLORFUNCTION_TYPE_KARMA;
			elseif (args[2]=="played") then
				KarmaConfig[KARMA_CONFIG_COLORFUNCTION]=KARMA_CONFIG_COLORFUNCTION_TYPE_PLAYED;
			end
			KarmaWindow_Update();
		end
	end
	
	if (args[1]=="addignore") then
		if (counter>=2) then
			Karma_CommandQueue[getn(Karma_CommandQueue)+1]={name="addignorecheck - "..args[2], func=Karma_Command_AddIgnore_Start, args={name=args[2]}};
			Karma_CommandQueue[getn(Karma_CommandQueue)+1]={name="updatewindow", func=Karma_Command_UpdateMembers, args={}};
		end
	end	
	
	if (args[1]=="options") then
		if (KarmaOptionsWindow:IsVisible()) then
			KarmaOptionsWindow:Hide();
		else
			KarmaOptionsWindow:Show();
		end
	end
		
	if (args[1]=="removemember") then
		Karma_MemberList_Remove(args[2]);
		Karma_MemberList_CreateMemberNamesCache();
	end
	
	if (args[1]=="autoignore") then
		local onofftext={[0]="off",[1]="on"};
		local newconfig=Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE);

		if (counter==1) then
			if (newconfig==1) then 
				newconfig=0;
			else
				newconfig=1;
			end
			
			Karma_SetConfig(KARMA_CONFIG_AUTOIGNORE,newconfig);
		elseif (counter==2) then
			for key,value in onofftext do
				if (strupper(value)==strupper(args[2])) then
					newconfig=key;
				end
			end
		end

		DEFAULT_CHAT_FRAME:AddMessage("Autoignore is now "..(onofftext[newconfig]));
	end
	
	if (args[1]=="questcache") then
		for name,values in KARMA_QuestCache do
			DEFAULT_CHAT_FRAME:AddMessage(name.." "..values.complete);
		end
	end
	
	
	if (args[1]=="?" or args[1]=="help" or args[1]==nil) then
		DEFAULT_CHAT_FRAME:AddMessage("--Karma v"..KARMA_VERSION_TEXT.." Help Info");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	addmember <name> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	addignore <name> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	removemember <name> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	givekarma <name> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	takekarma <name> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	sortby <[name|played|exp|time]> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	colorby <[played|exp|time]> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	autoignore <[on|off]> ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	options ");
		DEFAULT_CHAT_FRAME:AddMessage("-- 	window ");		
	end
	
end

-----------------------------------------
-- Low Level Database Functions
-----------------------------------------
function Karma_FieldInitialize(dict,field,initialvalue)
	ProfileStart("Karma_FieldInitialize");
	KarmaDebug(field);
	if (dict[field]==nil) then
		dict[field]=initialvalue;
	end
	ProfileStop("Karma_FieldInitialize");
end

function Karma_CreateDatabase()
	if (GetCVar("realmName")==nil or UnitName("player")==nil or UnitFactionGroup("player")==nil) then
		return;
	end
	-- This creates fields in the database as we need them.  Thus it is perfectly
	-- safe to call this function over and over again, as it only adds fields as they
	-- are required.	
	-- At the end of this function, we will have an empty skeleton database setup.
	
	--	ROOT
	Karma_FieldInitialize(KarmaData,KARMA_FIELD_VERSION,KARMA_SUPPORTEDDATABASEVERSION);
	Karma_FieldInitialize(KarmaData,KARMA_FIELD_REALMLIST,{});

	--	ROOT/REALMS
	Karma_FieldInitialize(KarmaData[KARMA_FIELD_REALMLIST],GetCVar("realmName"),{});
	Karma_FieldInitialize(KarmaData[KARMA_FIELD_REALMLIST][GetCVar("realmName")],KARMA_REALMFIELD_FACTION,{});

	--	ROOT/REALMS["realmName"]/FACTIONS
	local factionlist=KarmaData[KARMA_FIELD_REALMLIST][GetCVar("realmName")][KARMA_REALMFIELD_FACTION];
	Karma_FieldInitialize(factionlist,UnitFactionGroup("player"),{});
	
	--  ROOT/REALMS["realmName"]/FACTIONS["factionname]/
	local factionobj=factionlist[UnitFactionGroup("player")];
	Karma_FieldInitialize(factionobj,KARMA_FACTIONFIELD_CHARACTERLIST,{});
	Karma_FieldInitialize(factionobj,KARMA_FACTIONFIELD_QUESTNAMES,{});
	Karma_FieldInitialize(factionobj,KARMA_FACTIONFIELD_ZONENAMES,{});
	
	--	ROOT/REALMS["realmName"]/FACTIONS["factionname]/CHARACTERLIST
	local characterlist=factionobj[KARMA_FACTIONFIELD_CHARACTERLIST];
	Karma_FieldInitialize(characterlist,UnitName("player"),{});
	
	--	ROOT/REALMS["realmName"]/FACTIONS["factionname]/CHARACTERLIST["player"]
	characterlist=characterlist[UnitName("player")];
	Karma_FieldInitialize(characterlist,KARMA_CHARACTERFIELD_NAME,UnitName("player"));
	Karma_FieldInitialize(characterlist,KARMA_CHARACTERFIELD_XPTOTAL,0);
	Karma_FieldInitialize(characterlist,KARMA_CHARACTERFIELD_XPLAST,UnitXP("player"));
	Karma_FieldInitialize(characterlist,KARMA_CHARACTERFIELD_XPMAX,UnitXPMax("player"));

	-- Create Mmeber Buckets

	Karma_FieldInitialize(factionobj,KARMA_FACTIONFIELD_MEMBERBUCKETS,{});
	
	local buckets={};
	local result={};
	local i=0;
	local key,value;
	
	for i=1,strlen(KARMA_ALPHACHARS) do
		local bucketname=strsub(KARMA_ALPHACHARS,i,i);
		Karma_FieldInitialize(factionobj[KARMA_FACTIONFIELD_MEMBERBUCKETS],bucketname,{});
	end


end

function 	Karma_UpgradeDatabase()
--	Loop until the database has been upgraded all the iterations of the formats between.
	if (KarmaData[KARMA_FIELD_VERSION]==KARMA_SUPPORTEDDATABASEVERSION) then 
		return;
	end
	while (KarmaData[KARMA_FIELD_VERSION] ~= KARMA_SUPPORTEDDATABASEVERSION) do
		--
		--	Upgrade from version 2 --> version 3
		--
		if (KarmaData[KARMA_FIELD_VERSION]==2) then
			realmlist=KarmaData[KARMA_FIELD_REALMLIST];
			if (realmlist==nil) then
				return;
			end
			for realmname,realmdata in realmlist do
				-- Update to the version 3 database.
				-- Changes are only mandatory field additions to the
				-- 	Characterlist entries
				-- 	Memberlist Entries
				local factionlist=realmdata[KARMA_REALMFIELD_FACTION];
				if (factionlist==nil) then
					return;
				end
				for factionname,factiondata in factionlist do
					if (factionname ~=nil) then
						for ckey,cvalue in factiondata[KARMA_FACTIONFIELD_CHARACTERLIST] do
							if (cvalue~=nil) then
								cvalue[KARMA_CHARACTERFIELD_PLAYED]=0;
								cvalue[KARMA_CHARACTERFIELD_PLAYEDLAST]=0;
							end
						end		
						for mkey,mvalue in factiondata[KARMA_FACTIONFIELD_MEMBERLIST] do
							if (mvalue~=nil) then						
								Karma_FieldInitialize(mvalue,KARMA_MEMBERFIELD_CHARACTERS,{});
								for key,value in mvalue[KARMA_MEMBERFIELD_CHARACTERS] do
									if (value~=nil) then
										cspecificobject=value;
										cspecificobject[KARMA_MEMBERFIELD_CHARACTERS_PLAYED]=0;		
										cspecificobject[KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST]=0;		
									end
								end
							end 
						end
					end
				end
			end
			KarmaData[KARMA_FIELD_VERSION]=3;
		end
		---
		---	End upgrade version 2 --> version 3
		---
		
		if (KarmaData[KARMA_FIELD_VERSION]==3) then
			realmlist=KarmaData[KARMA_FIELD_REALMLIST];
			if (realmlist==nil) then
				return;
			end
			for realmname,realmdata in realmlist do
				-- put memberlist into buckets for quicker sorting, and accessing.
				local factionlist=realmdata[KARMA_REALMFIELD_FACTION];
				if (factionlist==nil) then
					return;
				end
				
				for factionname,factiondata in factionlist do
					if (factionname ~=nil) then
						local buckets={};
						local result={};
						local i=0;
						local key,value;
						
						for i=1,strlen(KARMA_ALPHACHARS) do
							local bucketname=strsub(KARMA_ALPHACHARS,i,i);
							buckets[bucketname]={};
						end
						factiondata[KARMA_FACTIONFIELD_MEMBERBUCKETS]=buckets;

						for mkey,mvalue in factiondata[KARMA_FACTIONFIELD_MEMBERLIST] do
							if (mvalue~=nil) then						
								bucketname=Karma_AccentedToPlain(strsub(mkey,1,1));
								factiondata[KARMA_FACTIONFIELD_MEMBERBUCKETS][bucketname][mkey]=mvalue;
							end 
						end
					end
					factiondata[KARMA_FACTIONFIELD_MEMBERLIST]=nil; -- no longer used get rid of the extra data
				end
			end
			KarmaData[KARMA_FIELD_VERSION]=4;
		end
		---
		---	End upgrade version 3 --> version 4;
		---


		if (KarmaData[KARMA_FIELD_VERSION]==4) then
			realmlist=KarmaData[KARMA_FIELD_REALMLIST];
			if (realmlist==nil) then
				return;
			end
			for realmname,realmdata in realmlist do
				-- put memberlist into buckets for quicker sorting, and accessing.
				local factionlist=realmdata[KARMA_REALMFIELD_FACTION];
				if (factionlist==nil) then
					return;
				end
				
				for factionname,factiondata in factionlist do
					if (factionname ~=nil) then

						for bkey,bvalue in factiondata[KARMA_FACTIONFIELD_MEMBERBUCKETS] do						
							for mkey,mvalue in bvalue do
								if (mvalue~=nil) then						
									for ckey,cvalue in mvalue[KARMA_MEMBERFIELD_CHARACTERS] do
										cvalue[KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST]={};
									end
								end 
							end
						end
					end
				end
			end
			KarmaData[KARMA_FIELD_VERSION]=5;
		end
		---
		---	End upgrade version 4 --> version 5;
		---

		if (KarmaData[KARMA_FIELD_VERSION]==5) then
			realmlist=KarmaData[KARMA_FIELD_REALMLIST];
			if (realmlist==nil) then
				return;
			end
			for realmname,realmdata in realmlist do
				-- put memberlist into buckets for quicker sorting, and accessing.
				local factionlist=realmdata[KARMA_REALMFIELD_FACTION];
				if (factionlist==nil) then
					return;
				end
				
				for factionname,factiondata in factionlist do
					if (factionname ~=nil) then
						for bkey,bvalue in factiondata[KARMA_FACTIONFIELD_MEMBERBUCKETS] do						
							for mkey,mvalue in bvalue do
								if (mvalue~=nil) then						
									for ckey,cvalue in factiondata[KARMA_FACTIONFIELD_CHARACTERLIST] do
										if (ckey~=nil and ckey~="") then
											Karma_MemberList_Add(mkey,factiondata);
										end
									end
								end 
							end
						end
					end
				end
			end
			KarmaData[KARMA_FIELD_VERSION]=6;
		end
		---
		---	End upgrade version 5 --> version 6;
		---

		if (KarmaData[KARMA_FIELD_VERSION]==6) then
			realmlist=KarmaData[KARMA_FIELD_REALMLIST];
			if (realmlist==nil) then
				return;
			end
			for realmname,realmdata in realmlist do
				-- put memberlist into buckets for quicker sorting, and accessing.
				local factionlist=realmdata[KARMA_REALMFIELD_FACTION];
				if (factionlist==nil) then
					return;
				end
				
				for factionname,factiondata in factionlist do
					if (factionname ~=nil) then
						for bkey,bvalue in factiondata[KARMA_FACTIONFIELD_MEMBERBUCKETS] do						
							for mkey,mvalue in bvalue do
								if (mvalue~=nil) then						
									mvalue[KARMA_MEMBERFIELD_GENDER]=-1;
								end 
							end
						end
					end
				end
			end
			KarmaData[KARMA_FIELD_VERSION]=7;
		end
		---
		---	End upgrade version 6 --> version 7;
		---


	end
end

function KarmaWindow_OnUpdateEvent(arg)
	if (GetTime()-KARMA_LastCommandTime >= 0.3) then
		if (Karma_Executing_Command==false) then
			local elem=Karma_CommandQueue[1];
			local i;
			if (getn(Karma_CommandQueue)>1) then
				for i=2,getn(Karma_CommandQueue) do
					if (Karma_CommandQueue[i] ~= nil) then
						Karma_CommandQueue[i-1]=Karma_CommandQueue[i];
						Karma_CommandQueue[i]=nil;
					end
				end
			else
				Karma_CommandQueue={};			
			end
			if (elem ~=nil) then
				if (elem.func) then
					elem.func(elem.args);
				end
			end
		end
		KARMA_LastCommandTime=GetTime();
	end
	if (GetTime()-KARMA_LastUpdateTime >=10) then
		if (KARMA_LOADED==1) then
			Karma_AddTimeToPartyMembers();
			KarmaWindow_Update();
		end
		KARMA_LastUpdateTime=GetTime();
	end
end

function Karma_IntializePlayerObject()
	local playerobj=Karma_GetPlayerObject();
	
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_PLAYED,0);
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_PLAYEDLAST,0);
	playerobj[KARMA_CHARACTERFIELD_PLAYEDLAST]=GetTime();
end

function Karma_GetPlayerObject()
	ProfileStart("Karma_GetPlayerObject");	
	local charlist=Karma_Faction_GetCharacterList();
	local playerobj=charlist[UnitName("player")];

	ProfileStop("Karma_GetPlayerObject");		
	return playerobj;
end

function Karma_GetMemberObject(membername)
	local memberlist,memberobj

	ProfileStart("Karma_GetMemberObject");
	if (membername=="" or membername==nil) then
		KarmaDebug("Membername == nil");
		ProfileStop("Karma_GetMemberObject");
		return nil;
	end
	KarmaDebug("membername=="..membername);
	memberobj=KARMA_PartyNames[membername];
	if (memberobj ~=nil) then
		return memberobj;
	end
	
	memberlist=Karma_Faction_GetMemberList();
	local bucketname=Karma_AccentedToPlain(strsub(membername,1,1));
	memberobj=memberlist[bucketname][membername];
	if (memberobj==nil) then
		Karma_MemberList_Add(membername);
		Karma_MemberList_Update(membername);
		memberobj=memberlist[bucketname][membername];		
		Karma_MemberList_CreateMemberNamesCache();
	end
			
	ProfileStop("Karma_GetMemberObject");
	return memberobj;
end



-----------------------------------------
-- Faction Object
-----------------------------------------
function Karma_Faction_GetMemberList(factionobj)
	if (factionobj==nil) then
		factionobj=Karma_Faction_GetFactionObject();
	end
	local memberlist=factionobj[KARMA_FACTIONFIELD_MEMBERBUCKETS];
	return memberlist;
end

function Karma_Faction_GetQuestList()
	ProfileStart("Karma_Faction_GetQuestList");
	local factionobj=Karma_Faction_GetFactionObject();
	local questlist=factionobj[KARMA_FACTIONFIELD_QUESTNAMES];
	ProfileStop("Karma_Faction_GetQuestList");
	return questlist;	
end

function Karma_Faction_GetZoneList()
	ProfileStart("Karma_Faction_GetZoneList");
	local factionobj=Karma_Faction_GetFactionObject();
	local zonelist=factionobj[KARMA_FACTIONFIELD_ZONENAMES];
	ProfileStop("Karma_Faction_GetZoneList");
	return zonelist;	
end


function Karma_Faction_GetCharacterList()
	local factionobj=Karma_Faction_GetFactionObject();
	local characterlist=factionobj[KARMA_FACTIONFIELD_CHARACTERLIST];
	return characterlist;	
end

function Karma_Faction_GetFactionObject()
	ProfileStart("Karma_GetFactionObject");
	ProfileStop("Karma_GetFactionObject");
	return KARMA_CachedFactionObject;
end

function Karma_Faction_Cache()
	local factionobj=KarmaData[KARMA_FIELD_REALMLIST][GetCVar("realmName")][KARMA_REALMFIELD_FACTION][UnitFactionGroup("player")];
	KARMA_CachedFactionObject=factionobj;
end

-----------------------------------------
--	Cacheing routines
-----------------------------------------
function Karma_MemberList_CreateMemberNamesCache()
	KARMA_SortedNames={};
	local membernames={};
	local memberlist=Karma_Faction_GetMemberList();		
	local numEntries=getn(memberlist);
	local bucketvalue,bucketname;

	i=0;
	for bucketname,bucketvalue in memberlist do
		for key,value in bucketvalue do
			membernames[i]=key;
			i=i+1;
		end
	end
	numEntries=i;

	KARMA_SortedNames=Karma_AlphaBucketSort(membernames);
end

function	Karma_MemberList_CreatePartyNamesCache()
	local i=0;
	
	KARMA_PartyNames={};
	
	for i = 1,GetNumPartyMembers() do
		name=UnitName("party"..i);
		if (name ~= nil) then
			KARMA_PartyNames[name]=Karma_GetMemberObject(name);
			Karma_MemberList_Add(name);
			Karma_MemberList_Update(name);
		end
	end
end

function	Karma_CreateQuestCache()
	KARMA_QuestCache={};
	local numEntries = GetNumQuestLogEntries();
	local i=0;
	for i=1,numEntries do 
		local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		if (questLogTitleText ~=nil and questLogTitleText ~="" and isHeader ~=1) then
			if (isComplete) then
				isComplete=1;
			else
				isComplete=0;
			end
			KARMA_QuestCache[questLogTitleText]={complete=isComplete};
		end
	end
end


-----------------------------------------
-- QuestList routines
-----------------------------------------
-- Adds the quest to the quest list, then returns the uniqueid for that quest.
-- If the quest is already in the list then this will return the uniqueid already in existance.

function	Karma_QuestList_AddQuest(questname)
	ProfileStart("Karma_QuestList_AddQuest");
	local questlist;
	questlist=Karma_Faction_GetQuestList();
	if (questlist==nil) then
		KarmaDebug("questlist==nil");
	else
		KarmaDebug("questlist ~=nil");
	end
	for key,value in questlist do
		if (value==questname) then
			ProfileStop("Karma_QuestList_AddQuest");
			return key;
		end
	end
	local newid=getn(questlist)+1;
	questlist[newid]=questname;
	ProfileStop("Karma_QuestList_AddQuest");
	return newid;
end

-- Generates a list of names, based on the input of a list of quest ids.
function	Karma_QuestList_GetListOfNames(questids)
	local	questnames={};
	local	questlist=Karma_Faction_GetQuestList();
	local 	x=1;
	
	for key,value in questids do
		if (questlist[value]~="") then
			questnames[x]=questlist[value];
			x=x+1;
		end
	end
	GenericSort(questnames,nil);
	return questnames;	
end


-----------------------------------------
-- QuestList routines
-----------------------------------------
-- Adds the quest to the quest list, then returns the uniqueid for that quest.
-- If the quest is already in the list then this will return the uniqueid already in existance.

function	Karma_ZoneList_AddZone(zonename)
	ProfileStart("Karma_ZoneList_AddQuest");
	local zonelist;
	zonelist=Karma_Faction_GetZoneList();
	if (zonelist==nil) then
		KarmaDebug("zonelist==nil");
	else
		KarmaDebug("zonelist ~=nil");
	end
	for key,value in zonelist do
		if (value==zonename) then
			ProfileStop("Karma_ZoneList_AddQuest");
			return key;
		end
	end
	local newid=getn(zonelist)+1;
	zonelist[newid]=zonename;
	ProfileStop("Karma_QuestList_AddQuest");
	return newid;
end

-- Generates a list of names, based on the input of a list of zone ids.
function	Karma_ZoneList_GetListOfNames(zoneids)
	local	zonenames={};
	local	zonelist=Karma_Faction_GetZoneList();
	local 	x=1;
	
	for key,value in zoneids do
		if (zonelist[value]~="") then
			zonenames[x]=zonelist[value];
			x=x+1;
		end
	end
	GenericSort(zonenames,nil);
	return zonenames;	
end




-----------------------------------------
-- MEMBERLIST FUNCTIONS
-----------------------------------------


function	Karma_MemberList_GetMemberNames()
	local	returnlist={};
	local key,name;
	for key,name in KARMA_SortedNames do
		returnlist[key]=name;
	end
	return returnlist;
end


function Karma_MemberList_MemberNameToUnitName(membername)
	local membercount,counter;
	if (membername==UnitName("target")) then
		return "target";
	end
	if (membername==UnitName("mouseover")) then
		return "mouseover";
	end
	membercount=GetNumPartyMembers();
	for counter = 1,membercount do
		local curmember=UnitName("party"..counter);
		if (curmember==membername) then
			return ("party"..counter);
		end
	end
	return nil;	
end

function Karma_MemberList_Add(membername,factionobj)
	if (membername==nil or membername=="") then
		return;
	end

	if (factionobj==nil) then
		factionobj=Karma_Faction_GetFactionObject();				
	end
	
	local playername=nil;
	local	memberlist=Karma_Faction_GetMemberList(factionobj);
	
	if (memberlist==nil) then
		return;
	end
	
	local   bucketname=Karma_AccentedToPlain(strsub(membername,1,1));
	Karma_FieldInitialize(memberlist[bucketname],membername,{});
	local memberobj=memberlist[bucketname][membername];
	
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_NAME,membername);
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_LEVEL,0);
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_CLASS,"");
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_GENDER,"");
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_GUILD,"");
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_NOTES,"");
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_KARMA,50);
	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_RACE,"");
	
	if (UnitName("player")~="" and UnitName("player")~=nil) then
		for ckey,cvalue in factionobj[KARMA_FACTIONFIELD_CHARACTERLIST] do
			if (ckey~=nil and ckey~="") then
				playername=ckey;
				Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_CHARACTERS,{});
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS],playername,{});
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_PLAYED,0);
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST,GetTime());
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_XP,0);
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_XPLAST,0);
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_XPMAX,0);
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_QUESTIDLIST,{});
				Karma_FieldInitialize(memberobj[KARMA_MEMBERFIELD_CHARACTERS][playername],KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST,{});
			end
		end
	end
end

function Karma_MemberList_Remove(membername)
	local	memberlist=Karma_Faction_GetMemberList();
	local   bucketname=Karma_AccentedToPlain(strsub(membername,1,1));
	local memberobj=memberlist[bucketname][membername];
	if (memberobj) then
		memberlist[bucketname][membername]=nil;
	end	
end

function	 Karma_MemberList_GetFieldHighLow(fieldname)
	local	memberlist=Karma_Faction_GetMemberList();
	local 	perbuckets={};
	local	lowfield=999999999;
	local	highfield=0;
	local   average=0;
	local 	counter=0;
	for mbname,mbvalue in memberlist do
		if (mbvalue ~= nil) then
			for name,record in mbvalue do
				if (record ~= nil) then
					counter=counter+1;
					pobj=Karma_MemberObject_GetCharacterObject(record,UnitName("player"));
					if (pobj[fieldname] < lowfield) then
						lowfield=pobj[fieldname];
					end
					if (pobj[fieldname] > highfield) then
						highfield=pobj[fieldname];
					end
				end
			end
		end
	end
	average=(highfield-lowfield)/counter;
	
	return lowfield,highfield,average;
end

--
-- Update parts of the member record which might have changed.
-- Also set the parts which might not yet have been set.
--
function Karma_MemberList_Update(membername)
	if (membername=="" or membername==nil) then
		return;
	end
	local	memberlist=Karma_Faction_GetMemberList();
	local   bucketname=Karma_AccentedToPlain(strsub(membername,1,1));
	local 	memberobj=memberlist[bucketname][membername];
	local 	unitname=Karma_MemberList_MemberNameToUnitName(membername);
	
	if (unitname==nil) then
		-- This is perfectly fine, if the unit isn't in the party, then don't handle
		-- this request. 
		return;
	end
	
	memberobj[KARMA_MEMBERFIELD_LEVEL]=UnitLevel(unitname);
	memberobj[KARMA_MEMBERFIELD_CLASS]=UnitClass(unitname);
	memberobj[KARMA_MEMBERFIELD_GENDER]=UnitSex(unitname);
	memberobj[KARMA_MEMBERFIELD_RACE]=UnitRace(unitname);
	memberobj[KARMA_MEMBERFIELD_GUILD]=GetGuildInfo(unitname);
	if (memberobj[KARMA_MEMBERFIELD_GUILD]==nil) then
		memberobj[KARMA_MEMBERFIELD_GUILD]="";
	end
	if (UnitName("player")~="" and UnitName("player")~=nil) then
		memberobj[KARMA_MEMBERFIELD_CHARACTERS][UnitName("player")][KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST]=GetTime();
		memberobj[KARMA_MEMBERFIELD_CHARACTERS][UnitName("player")][KARMA_MEMBERFIELD_CHARACTERS_XPLAST]=UnitXP("player");
		memberobj[KARMA_MEMBERFIELD_CHARACTERS][UnitName("player")][KARMA_MEMBERFIELD_CHARACTERS_XPMAX]=UnitXPMax("player");
	end
end

function Karma_MemberList_GetObject(membername)
	local	memberlist=Karma_Faction_GetMemberList();
	local   bucketname=Karma_AccentedToPlain(strsub(membername,1,1));
	local 	memberobj=memberlist[bucketname][membername];
	return memberobj;	
end

function Karma_MemberList_GetSelectedMember()
	local	memberlist=Karma_Faction_GetMemberList();
	local   bucketname=strsub(KARMA_CURRENTMEMBER,1,1);
	local 	memberobj=memberlist[bucketname][KARMA_CURRENTMEMBER];
	return memberobj;		
end

-----------------------------------------
-- MEMBEROBJECT FUNCTIONS
-----------------------------------------
function	Karma_MemberObject_GetName(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_NAME];
	else
		return nil;
	end
end

function	Karma_MemberObject_GetXP(memberobj)
	if (type(memberobj)=="table") then
		local charobj=Karma_MemberObject_GetCharacterObject(memberobj);
		if (charobj==nil) then
			return 0;
		end
		return charobj[KARMA_MEMBERFIELD_CHARACTERS_XP];
	else
		return nil;
	end
end

function 	Karma_MemberObject_GetTimePlayed(memberobj)
	if (type(memberobj)=="table") then
		local charobj=Karma_MemberObject_GetCharacterObject(memberobj);
		if (charobj==nil) then
			return 0;
		end
		local totalseconds=charobj[KARMA_MEMBERFIELD_CHARACTERS_PLAYED];
		
		local days=tonumber(string.format("%d",((totalseconds/86400))));
		local	hours=tonumber(string.format("%d",((totalseconds-(days*86400))/3600)));
		local mins=tonumber(string.format("%d",((totalseconds-(days*86400)-(hours*3600))/60)));
		local seconds=tonumber(string.format("%d",((totalseconds-(days*86400)-(hours*3600)-(mins*60)))));
		return totalseconds,days,hours,mins,seconds;
	else
		return nil;
	end
end

function	Karma_MemberObject_GetKarma(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_KARMA];
	else
		return nil;
	end
end

function	Karma_MemberObject_GetLevel(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_LEVEL];
	else
		return nil;
	end
end

function	Karma_MemberObject_GetRace(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_RACE];
	else
		return nil;
	end
end


function  	Karma_MemberObject_GetClass(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_CLASS];
	else
		return nil;
	end
end

function	Karma_MemberObject_GetGuild(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_GUILD];
	else
		return nil;
	end
end

function  	Karma_MemberObject_GetNotes(memberobj)
	if (type(memberobj)=="table") then
		return memberobj[KARMA_MEMBERFIELD_NOTES];
	else
		return nil;
	end
end

function  	Karma_MemberObject_GetGender(memberobj)
	if (type(memberobj)=="table") then
		local GENDER=FEMALE;
		if (memberobj[KARMA_MEMBERFIELD_GENDER]==-1 or memberobj[KARMA_MEMBERFIELD_GENDER]==nil) then
			return "";
		end
		if (memberobj[KARMA_MEMBERFIELD_GENDER]==0) then
			GENDER=MALE;
		end
		return GENDER;
	else
		return nil;
	end
end

function 	Karma_MemberObject_GetQuestList(memberobj)
	if (type(memberobj)=="table") then
		charobj=Karma_MemberObject_GetCharacterObject(memberobj);
		return charobj[KARMA_MEMBERFIELD_CHARACTERS_QUESTIDLIST];
	else
		return nil;
	end
end

function 	Karma_MemberObject_GetZoneList(memberobj)
	if (type(memberobj)=="table") then
		charobj=Karma_MemberObject_GetCharacterObject(memberobj);
		return charobj[KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST];
	else
		return nil;
	end
end

function	Karma_MemberObject_GetCharacterObject(memberobj,charactername)
	if (charactername==nil) then
		charactername=UnitName("player");
	end
	if (memberobj[KARMA_MEMBERFIELD_CHARACTERS]==nil or
		  memberobj[KARMA_MEMBERFIELD_CHARACTERS][charactername]==nil) then
			-- Create all the fields required for this particular character/member.
		  Karma_MemberList_Add(Karma_MemberObject_GetName(memberobj));
		  Karma_MemberList_Update(Karma_MemberObject_GetName(memberobj));
	end
	return memberobj[KARMA_MEMBERFIELD_CHARACTERS][charactername];
end


-- Set Functions

function 	Karma_MemberObject_SetTimePlayed(memberobj,played)
	if (type(memberobj)=="table") then
		charobj=Karma_MemberObject_GetCharacterObject(memberobj);
		Karma_FieldInitialize(charobj,KARMA_MEMBERFIELD_CHARACTERS_PLAYED,0);
		charobj[KARMA_MEMBERFIELD_CHARACTERS_PLAYED]=played;		
	else
		return nil;
	end
end


function	Karma_MemberObject_SetKarma(memberobj,karmarating)
	if (type(memberobj)=="table") then
		memberobj[KARMA_MEMBERFIELD_KARMA]=karmarating;	
  else
		return nil;
	end
end

function  	Karma_MemberObject_SetNotes(memberobj,text)
	if (type(memberobj)=="table") then
		memberobj[KARMA_MEMBERFIELD_NOTES]=text;	
  else
		return nil;
	end
end



-----------------------------------------
-- ACCESSOR FUNCTIONS
-----------------------------------------

function	Karma_AddCharacterToDatabase(memberobj)
	ProfileStart("Karma_AddCharacterToDatabase");
	Karma_MemberList_Add(memberobj[KARMA_MEMBERFIELD_NAME]);
	Karma_MemberList_Update(memberobj[KARMA_MEMBERFIELD_NAME]);
	ProfileStop("Karma_AddCharacterToDatabase");	
end

function  Karma_CleanDatabase()
end

function 	Karma_AddCurrentPartyToDatabase()
	ProfileStart("Karma_AddCurrentPartyToDatabase");
	-- This goes through the current party members and adds them to the
	-- database.  
	Karma_VisitAllGroupMembers(Karma_AddCharacterToDatabase,nil);
	ProfileStop("Karma_AddCurrentPartyToDatabase");
end

function 	Karma_AddXPToPartyMember(memberobj)
	ProfileStart("Karma_AddXPToPartyMember");
	local newxp=UnitXP("player");
	local accrued=0;

	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_CHARACTERS,{});
	local memberfield_characterlist=memberobj[KARMA_MEMBERFIELD_CHARACTERS];
	
	Karma_FieldInitialize(memberfield_characterlist,UnitName("player"),{});
	local memberfield_character=memberfield_characterlist[UnitName("player")];
	
	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_QUESTIDLIST,{});
	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST,{});
	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_XP,0);
	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_XPLAST,UnitXP("player"));
	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_XPMAX,UnitXPMax("player"));
		

	if (newxp < (memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XPLAST])) then 
		accrued=memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XPMAX]-(memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XPLAST])+newxp;
	else
		accrued=newxp-(memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XPLAST]);
	end
	
	local found=false;
	for index,value in 	memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST] do
		if (value==Karma_ZoneList_AddZone(GetMinimapZoneText())) then
			found=true;
		end
	end
	if (found==false) then
		memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST][getn(memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_ZONEIDLIST])+1]=Karma_ZoneList_AddZone(GetMinimapZoneText());
	end
	
	memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XPLAST]=UnitXP("player");
	memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XPMAX]=UnitXPMax("player");	
	memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XP]=	memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_XP]+accrued;
	ProfileStop("Karma_AddXPToPartyMember");
end

function	Karma_AddXPToPlayer()
	ProfileStart("Karma_AddXPToPlayer");
	local newxp=UnitXP("player");
	local accrued=0;

	local playerobj=Karma_GetPlayerObject();
	
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_XPTOTAL,0);
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_XPLAST,UnitXP("player"));
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_XPMAX,UnitXPMax("player"));
		
	if (newxp < (playerobj[KARMA_CHARACTERFIELD_XPLAST])) then 
		accrued=playerobj[KARMA_CHARACTERFIELD_XPMAX]-(playerobj[KARMA_CHARACTERFIELD_XPLAST])+newxp;
	else
		accrued=newxp-(playerobj[KARMA_CHARACTERFIELD_XPLAST]);
	end
	playerobj[KARMA_CHARACTERFIELD_XPLAST]=UnitXP("player");
	playerobj[KARMA_CHARACTERFIELD_XPMAX]=UnitXPMax("player");	
	playerobj[KARMA_CHARACTERFIELD_XPTOTAL]=	playerobj[KARMA_CHARACTERFIELD_XPTOTAL]+accrued;

	ProfileStop("Karma_AddXPToPlayer");
end


function 	Karma_AddTimeToPartyMember(memberobj)
	ProfileStart("Karma_AddTimeToPartyMember");
	local newtime=GetTime();
	local timebetween=0;

	Karma_FieldInitialize(memberobj,KARMA_MEMBERFIELD_CHARACTERS,{});
	local memberfield_characterlist=memberobj[KARMA_MEMBERFIELD_CHARACTERS];
	
	Karma_FieldInitialize(memberfield_characterlist,UnitName("player"),{});
	local memberfield_character=memberfield_characterlist[UnitName("player")];

	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_PLAYED,0);
	Karma_FieldInitialize(memberfield_character,KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST,newtime);

	if (memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST]==0) then
		memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST]=newtime;
	end	

	timebetween=newtime-memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST];
	if (timebetween >=0) then
		memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_PLAYED]=memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_PLAYED]+timebetween;
	end
	memberfield_character[KARMA_MEMBERFIELD_CHARACTERS_PLAYEDLAST]=newtime;

	ProfileStop("Karma_AddTimeToPartyMember");
end


function	Karma_AddTimeToPlayer()
	ProfileStart("Karma_AddTimeToPlayer");
	local newtime=GetTime();
	local timebetween=0;

	local playerobj=Karma_GetPlayerObject();
	
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_PLAYED,0);
	Karma_FieldInitialize(playerobj,KARMA_CHARACTERFIELD_PLAYEDLAST,newtime);
	
	if (playerobj[KARMA_CHARACTERFIELD_PLAYEDLAST]==0) then
		playerobj[KARMA_CHARACTERFIELD_PLAYEDLAST]=newtime;
	end	
	timebetween=newtime-playerobj[KARMA_CHARACTERFIELD_PLAYEDLAST];
	playerobj[KARMA_CHARACTERFIELD_PLAYED]=playerobj[KARMA_CHARACTERFIELD_PLAYED]+timebetween;
	playerobj[KARMA_CHARACTERFIELD_PLAYEDLAST]=newtime;

	ProfileStop("Karma_AddTimeToPlayer");
end

function	Karma_AddXPToPartyMembers()
	ProfileStart("Karma_AddXPToPartyMembers");
	
	Karma_AddXPToPlayer();
	-- Calculate and add the appropriate amount of xp to each character in the party.
	Karma_VisitAllGroupMembers(Karma_AddXPToPartyMember,nil);
	 
	ProfileStop("Karma_AddXPToPartyMembers");
end


function	Karma_AddTimeToPartyMembers()
	ProfileStart("Karma_AddTimeToPartyMembers");
	Karma_AddTimeToPlayer();
	Karma_VisitAllGroupMembers(Karma_AddTimeToPartyMember,nil);
	ProfileStart("Karma_AddTimeToPartyMembers");	
end

function Karma_UpdateCurrentTargetNameColor()
	local i
	local membername,membernameobj,memberobj
	
	if (TargetFrame:IsVisible()) then
		local targetname=UnitName("target");		
		if (targetname ~= nil) then
			if (UnitFactionGroup("player")==UnitFactionGroup("target") and UnitIsPlayer("target")) then
				local memberlist=Karma_Faction_GetMemberList();
				local red,green,blue
				if (memberlist[Karma_AccentedToPlain(strsub(targetname,1,1))][targetname]~=nil) then
					red,green,blue= Karma_MemberList_GetColors(targetname);
				else
					red=0.80;green=0.80;blue=0.80;
				end
				TargetName:SetTextColor(1,1,1);
				TargetFrameNameBackground:SetVertexColor(red,green,blue);
			end
		end
	end			
end

function	Karma_AdjustPartyMemberNameColors()
	local i
	local partymembers;
	local membername,membernameobj,memberobj
	
	partymembers=GetNumPartyMembers();
	if (partymembers==0) then
		return;
	end

	if (TargetFrame:IsVisible()) then
		local targetname=UnitName("target");		
		if (targetname ~= nil) then
			if (UnitFactionGroup("player")==UnitFactionGroup("target") and UnitIsPlayer("target")) then
				local red,green,blue = Karma_MemberList_GetColors(Karma_MemberObject_GetName(targetname));
				TargetName:SetTextColor(red,green,blue);
			end
		end
	end
	
	for i=1,partymembers do
		membernameobject=getglobal("PartyMemberFrame"..i.."Name");
		membername=membernameobject:GetText();
		memberobj=Karma_GetMemberObject(membername);
		if (memberobj) then
			local red,green,blue
			red,green,blue=Karma_MemberList_GetColors(Karma_MemberObject_GetName(memberobj));
			membernameobject:SetTextColor(red,green,blue);
		end
	end
end

function  Karma_AddQuestToIndividualPartyMember(memberobj,questname)
	ProfileStart("Karma_AddQuestToIndividualPartyMember");
	local questlist;
	questlist=Karma_MemberObject_GetQuestList(memberobj);
	local questid;
	questid=Karma_QuestList_AddQuest(questname);
	local key,value;
	local duplicate=false;
	duplicate=false;
	
	for key,value in questlist do
		if (questid==value) then 
			duplicate=true;
			break;
		end
	end
	if (duplicate==false) then
		questlist[getn(questlist)+1]=questid;
	end
	ProfileStop("Karma_AddQuestToIndividualPartyMember");
end

function 	Karma_AddQuestToPartyMembers(questname)
	ProfileStart("Karma_AddXPToPartyMembers");
	if (questname==nil) then
		KarmaDebug(" QuestName="..GetTitleText());
		questname=GetTitleText();
	end
	Karma_VisitAllGroupMembers(Karma_AddQuestToIndividualPartyMember,questname);
	ProfileStop("Karma_AddXPToPartyMembers");
end


-- For each group member, either retrieve, or create a member object, and then pass it
-- to the specified function.
function Karma_VisitAllGroupMembers(func,user)
	ProfileStart("Karma_VisitAllGroupMembers");
	-- Now update the list of players that this character is grouped with.
	local memberobj=nil;
	local memberlist=nil;

	for membername,memberobj in KARMA_PartyNames do
		func(memberobj,user);					
	end
	
	ProfileStop("Karma_VisitAllGroupMembers");	
end  


-----------------------------------------
-- COLOR FUNCTIONS
-----------------------------------------

function	Karma_MemberList_GetColors(membername)
	if (KarmaConfig[KARMA_CONFIG_COLORFUNCTION] == nil) then
		KarmaConfig[KARMA_CONFIG_COLORFUNCTION]=KARMA_CONFIG_COLORFUNCTION_TYPE_KARMA;
	end
	local colorfunction=KarmaConfig[KARMA_CONFIG_COLORFUNCTION];
	if (colorfunction==KARMA_CONFIG_COLORFUNCTION_TYPE_KARMA) then
		return Karma_GetColors_Karma(membername);
	elseif (colorfunction==KARMA_CONFIG_COLORFUNCTION_TYPE_XP) then
		return Karma_GetColors_XP(membername);
	elseif (colorfunction==KARMA_CONFIG_COLORFUNCTION_TYPE_PLAYED) then
		return Karma_GetColors_Played(membername);
	end
	return 1,1,1;
end


function 	Karma_GetColors_Played(membername)
	ProfileStart("Karma_GetColors_Time");
	local memberobj=Karma_GetMemberObject(membername);
	if (memberobj==nil) then
		return 1,1,1;
	end

	local 	low,high,average;	
	local 	membertime=Karma_MemberObject_GetTimePlayed(memberobj);
	low,high,average=Karma_MemberList_GetFieldHighLow(KARMA_MEMBERFIELD_CHARACTERS_PLAYED);

	local percentage=(membertime/((high-low)+1))*100;
		
	percentstep=percentage/5;
	local green=percentstep*0.08;
	local blue=(1.0-(percentstep*0.09));
	if (blue < 0) then 
		blue=0;
	end
	if (green > 1.0) then
		green=1.0
	end
	local red=0.0;


	KarmaDebug("red=="..red.." green=="..green.." blue=="..blue);
	ProfileStop("Karma_GetColors_Time");	
	return red, green, blue;	
end


function 	Karma_GetColors_XP(membername)
	ProfileStart("Karma_GetColors_XP");
	local memberobj=Karma_GetMemberObject(membername);
	if (memberobj==nil) then
		return 1,1,1;
	end

	local low,high,average;	
	local memberxp=Karma_MemberObject_GetXP(memberobj);
	
	low,high,average=Karma_MemberList_GetFieldHighLow(KARMA_MEMBERFIELD_CHARACTERS_XP);	
	 
	local percentage=(memberxp/((high-low)+1))*100;

	
	percentstep=percentage/5;
	local green=percentstep*0.08;
	local blue=(1.0-(percentstep*0.09));
	if (blue < 0) then 
		blue=0;
	end
	if (green > 1.0) then
		green=1.0
	end
	local red=0.0;
	

	KarmaDebug("red=="..red.." green=="..green.." blue=="..blue);
	ProfileStop("Karma_GetColors_XP");	
	return red, green, blue;	
end

function  Karma_GetColors_Karma(membername)
	ProfileStart("Karma_GetKarmaColors");
		-- Calculate the color of the karma bar.  
	-- The better the person the greener the karma.
	-- The worse the person the redder the karma.
	local memberobj=Karma_GetMemberObject(membername);
	if (memberobj==nil) then
		return 1,1,1;
	end
	local KARMA=Karma_MemberObject_GetKarma(memberobj);
	
	local green=0.01*KARMA;
	local red=(1.0-(0.01*KARMA));
	local blue=((100-KARMA)*0.02);
	if (KARMA < 50) then
		blue=(50-(50-KARMA))*0.02;
	end
	if (KARMA <= 10) then
		blue=(50-(50-KARMA))*0.01;
	end
	if (KARMA >= 90) then
		blue=((100-KARMA)*0.01);
	end
	KarmaDebug("red=="..red.." green=="..green.." blue=="..blue);
	ProfileStop("Karma_GetKarmaColors");	
	return red, green, blue;
end

------------------------------------------------------
--		SORTING FUNCTIONS
------------------------------------------------------
function	Karma_MemberList_GetSortFunction()
	if (KarmaConfig[KARMA_CONFIG_SORTFUNCTION] == nil) then
		KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA;
	end
	sortfunction=KarmaConfig[KARMA_CONFIG_SORTFUNCTION];
	if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA) then
		return Karma_MemberSort_CompareKarma;
	elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_NAME) then
		return Karma_MemberSort_CompareName;
	elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_XP) then
		return Karma_MemberSort_CompareXP;
	elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_PLAYED) then
		return Karma_MemberSort_ComparePlayed;
	end
	return nil;
end

function	Karma_MemberList_GetSortField()
	if (KarmaConfig[KARMA_CONFIG_SORTFUNCTION] == nil) then
		KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA;
	end
	sortfunction=KarmaConfig[KARMA_CONFIG_SORTFUNCTION];
	if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA) then
		return Karma_MemberSort_CompareKarma;
	elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_NAME) then
		return Karma_MemberSort_CompareName;
	elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_XP) then
		return Karma_MemberSort_CompareXP;
	elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_PLAYED) then
		return Karma_MemberSort_ComparePlayed;
	end
	return nil;
end

function 	Karma_MemberSort_CompareKarma(memname1, memname2)
	if (memname1==nil or memname2==nil or memname1=="" or memname2=="") then
		return false;
	end
	mem1=Karma_GetMemberObject(memname1);
	mem2=Karma_GetMemberObject(memname2);
	if (mem1==nil or mem2==nil) then
		return false;
	end
	if (mem1[KARMA_MEMBERFIELD_KARMA] < mem2[KARMA_MEMBERFIELD_KARMA]) then
		return false;
	end
	return true;
end


function 	Karma_MemberSort_ComparePlayed(memname1, memname2)
	if (memname1==nil or memname2==nil or memname1=="" or memname2=="") then
		return false;
	end
	mem1=Karma_GetMemberObject(memname1);
	mem2=Karma_GetMemberObject(memname2);
	if (mem1==nil or mem2==nil) then
		return false;
	end
	if (Karma_MemberObject_GetTimePlayed(mem1) < Karma_MemberObject_GetTimePlayed(mem2)) then
		return false;
	end
	return true;
end

function 	Karma_MemberSort_CompareXP(memname1, memname2)
	if (memname1==nil or memname2==nil or memname1=="" or memname2=="") then
		return false;
	end
	mem1=Karma_GetMemberObject(memname1);
	mem2=Karma_GetMemberObject(memname2);
	if (mem1==nil or mem2==nil) then
		return false;
	end
	if (Karma_MemberObject_GetXP(mem1) < Karma_MemberObject_GetXP(mem2)) then
		return false;
	end
	return true;
end

function 	Karma_MemberSort_CompareName(memname1, memname2)
	if (memname1==nil or memname2==nil) then
		return false;
	end
	if (memname1 < memname2) then
		return true;
	end
	return false;
end

function GenericSort(table1,cmpfunc)
-- The following method is Lua's built in sort library sort(table1)
  local lo,hi,min,j,count
  lo = 1 
	hi = getn(table1)
	for count = lo,hi do 
    min = count
    for j = count,hi do
    	if (cmpfunc ==nil) then
	      if table1[j] < table1[min] then 
	        min = j;
		    end
		  else
		  	if (cmpfunc(table1[j],table1[min])) then
		  		min = j
		  	end 
	    end
  	end 
    temp = table1[min]
    table1[min] = table1[count]
    table1[count] = temp 
	end 
	return table1 
end 


--
--	Turn accented characters into plain non accented characters
--	this is very useful for the purpose of sorting, so that all
--	A's regardless of accent get sorted into the same bucket.
--
function	Karma_AccentedToPlain(thechar)
	asccode=string.byte(thechar);
	if (asccode < 127) then
		return thechar;
	end
	for index,value in KARMA_ALPHACHARS_ACCENT do
		for i=1,getn(value) do
			if value[i]==asccode then
				return index;
			end
		end
	end
	return thechar;
end


-- This function returns a new table of the sorted table
-- For large amounts of data this is faster that the generic
-- sorting.  for instance in a list which contains 676 evenly
-- distribued values (across the alphabet, using the first character),
-- this function only  requires 17000 compares, where a straight
-- comparison requires 500000.
function Karma_AlphaBucketSort(table1)
	buckets={};
	local result={};
	local i=0;
	local key,value;
	
	for i=1,strlen(KARMA_ALPHACHARS) do
		local bucketname=strsub(KARMA_ALPHACHARS,i,i);
		buckets[bucketname]={};
	end
	
	for key,value in table1 do
		if (value ~=nil  and value~="") then
			local bucketname=Karma_AccentedToPlain(strsub(value,1,1));
			buckets[bucketname][getn(buckets[bucketname])+1]=value;
		end
	end
	
	for key,value in buckets do
		buckets[key]=GenericSort(value,Karma_MemberSort_CompareName);
	end

	local counter=1;
	for i=1,strlen(KARMA_ALPHACHARS) do
		local bucketname=strsub(KARMA_ALPHACHARS,i,i);
		local curbucket=buckets[bucketname];
		local item=nil;
		local index=0;
		for index,item in curbucket do
			result[counter]=item;
			counter=counter+1;
		end
	end
		
	return result;
end

--
--	This function does a sort based on some numeric field in the 
--	memberobj.  Because we are now using version 4 of the database
--	GetMemberObject is now on par with AlphaBucketSort routine. 
--	This sorts into numbered buckets, which always come in order.
--

local   LARGE_NUMERIC_SORTING_BUCKETS={
    [1]={minimum=0, max=0, records={}},
    [2]={minimum=1, max=1000, records={}},
    [3]={minimum=1001, max=5000, records={}},
    [4]={minimum=5001, max=10000, records={}},
    [5]={minimum=10001, max=20000, records={}},
    [6]={minimum=20001, max=40000, records={}},
    [7]={minimum=40001, max=80000, records={}},
    [8]={minimum=80001, max=160000, records={}},
    [9]={minimum=160001, max=320000, records={}},
    [10]={minimum=320001, max=640000, records={}},
    [12]={minimum=640001, max=1280000, records={}},
    [13]={minimum=1280001, max=3000000, records={}},
    [14]={minimum=3000001, max=9000000, records={}},
    [15]={minimum=9000001, max=-1, records={}}
};

function Karma_SortNameValuePairs(table1,cmpfunc)
-- The following method is Lua's built in sort library sort(table1)
  local lo,hi,min,j,count
  lo = 1 
	hi = getn(table1)
	for count = lo,hi do 
    min = count
    for j = count,hi do
	  if table1[j].sortvalue < table1[min].sortvalue then 
		min = j 
	  end
  	end 
    temp = table1[min]
    table1[min] = table1[count]
    table1[count] = temp 
	end 
	return table1 
end 


function Karma_MemberFieldNumericSort(table1)
	local i=0;
	local key,value;
	local result={};
	local buckets={};
	local tempbuckets={};
	local temp={};
	local index,name;
		
	local sortfunction=KarmaConfig[KARMA_CONFIG_SORTFUNCTION];
	if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_NAME) then
		return table1;
	end


	if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA) then
		for i=1,100 do
			buckets[i]={};
		end
    else    -- Okay we need to create buckets for the other sort values.
        for i=1,getn(LARGE_NUMERIC_SORTING_BUCKETS) do
            buckets[i]=LARGE_NUMERIC_SORTING_BUCKETS[i];
            buckets[i].records={};
            tempbuckets[i]={};
        end
	end

		
	for key,value in table1 do
		if (value ~=nil  and value~="") then
			local memberobj=Karma_GetMemberObject(value);
			local bucketname=0;
			if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA) then
				bucketname=memberobj[KARMA_MEMBERFIELD_KARMA];
			elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_XP) then
				bucketname=memberobj[KARMA_MEMBERFIELD_CHARACTERS][Karma_GetPlayerObject()["NAME"]][KARMA_MEMBERFIELD_CHARACTERS_XP];
			elseif (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_PLAYED) then
				bucketname=memberobj[KARMA_MEMBERFIELD_CHARACTERS][Karma_GetPlayerObject()["NAME"]][KARMA_MEMBERFIELD_CHARACTERS_PLAYED];
			end

            if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA) then
				if (buckets[bucketname] == nil) then
					buckets[bucketname]={};
				end
    			buckets[bucketname][getn(buckets[bucketname])+1]=value;
            else
                for i=1,getn(buckets) do
                    if (bucketname >= buckets[i].minimum and bucketname <= buckets[i].max) then
                        buckets[i].records[getn(buckets[i].records)+1]={name=value,sortvalue=bucketname};
                    elseif (buckets[i].max==-1) then
						buckets[i].records[getn(buckets[i].records)+1]={name=value,sortvalue=bucketname};
                    end
                end            
            end
		end
	end	

    if (sortfunction==KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA) then
        tempbuckets=buckets;

    else
        for i=1,getn(buckets) do
            if (i>1) then -- special case the first bucket is for those you've never gotten any time/exp with.
                Karma_SortNameValuePairs(buckets[i].records);
            end
            
            local x=0;
            for x=getn(buckets[i].records),1,-1 do
                tempbuckets[i][getn(tempbuckets[i])+1]=buckets[i].records[x].name;
            end 
        end                
    end
		
    -- this does a complete reversal of all the results.
	local  counter=1;
	for i=1,getn(tempbuckets) do
		local name=""
		for index,name in tempbuckets[(getn(tempbuckets)+1)-i] do
			result[counter]=name;
			counter=counter+1;
		end		
	end
	
	return result;
end

-----------------------------------------
--	GUI FUNCTIONS
-----------------------------------------

function Karma_ToggleWindow()
	if ( KarmaWindow:IsVisible() ) then 
		KarmaWindow:Hide();
		KarmaOptionsWindow:Hide();
	else
		Karma_CreateDatabase();
		KarmaWindow:Show();
	  	KarmaWindow_DressUp();	
	  	KarmaWindow_Update();	
	end	
end

function KarmaWindowKeyDown(index)
	-- nothing
end

function KarmaWindowKeyUp(index)
	Karma_ToggleWindow()
end

function	KarmaWindow_DressUp()
	ProfileStart("KarmaWindowDressUp");	
	KarmaWindow_Title:SetText("Karma v"..KARMA_VERSION_TEXT);	
	ProfileStop("KarmaWindowDressUp");	
end


--
--	This function should always be safe to call. 
--
function	KarmaWindow_Update()
	if (KarmaWindow:IsVisible()) then
		KarmaWindow_UpdateCurrentMember();
		KarmaWindow_UpdateMemberList();
		KarmaWindow_UpdateQuestList();
		KarmaWindow_UpdateKarmaBar();
		KarmaWindow_UpdatePartyList();
		KarmaWindow_UpdateZoneList();
	end
	Karma_AdjustPartyMemberNameColors();
	Karma_UpdateCurrentTargetNameColor();
end


--
--	Handler for clicks in the partylist
--
function	KarmaWindow_PartyList_OnClick(button,buttonobject)
	ProfileStart("KarmaWindow_PartyList_OnClick")
	local id=buttonobject:GetID();
	button=getglobal("PartyList_GlobalButton"..id.."_Text");
	if (button:GetText() ~=nil and button:GetText() ~="") then
		KARMA_CURRENTMEMBER=button:GetText();
	end
	FauxScrollFrame_SetOffset(KarmaWindow_QuestList_ScrollFrame,0);
	KarmaWindow_Update();
	KarmaWindow_NotesInitializeText();
	if (KARMA_CURRENTMEMBER) then
		KarmaDebug("KARMA_CURRENTMEMBER=="..KARMA_CURRENTMEMBER);
	end
	ProfileStop("KarmaWindow_PartyList_OnClick")
end

--
--	Handler for clicks in the memberlist
--
function	KarmaWindow_MemberList_OnClick(button,buttonobject)
	ProfileStart("KarmaWindow_MemberList_OnClick")
	local id=buttonobject:GetID();
	button=getglobal("MemberList_GlobalButton"..id.."_Text");
	KARMA_CURRENTMEMBER=button:GetText();
	FauxScrollFrame_SetOffset(KarmaWindow_QuestList_ScrollFrame,0);
	KarmaWindow_Update();
	KarmaWindow_NotesInitializeText();
	if (KARMA_CURRENTMEMBER) then
		KarmaDebug("KARMA_CURRENTMEMBER=="..KARMA_CURRENTMEMBER);
	end
	ProfileStop("KarmaWindow_MemberList_OnClick")
end

-- Scrolls to the current member in the memberlist.
-- This is not done every update.  This is just so that the
-- current member is always visible when certain operations
-- have been done.  Namely increases and decreases in the 
-- karma value.
function  KarmaWindow_ScrollToCurrentMember()
	local memberlist,button,i,numEntries
	local membernames={};

	if (KARMA_CURRENTMEMBER == nil or KARMA_CURRENTMEMBER == "") then
		return;
	end 
		
	membernames=Karma_MemberList_GetMemberNames();
	membernames=Karma_MemberFieldNumericSort(membernames);

	i=0;
	for key,value in membernames do
		i=i+1;
	end
	numEntries=i;

	if (numEntries <= 25) then
		FauxScrollFrame_SetOffset(KarmaWindow_MemberList_ScrollFrame,0);
		KarmaWindow_MemberList_ScrollFrameScrollBar:SetValue(0);
		return;
	end		
	
	i=0;
	for key,membername in membernames do
		i=i+1;
		if (membername==KARMA_CURRENTMEMBER) then
			FauxScrollFrame_SetOffset(KarmaWindow_MemberList_ScrollFrame,i-1);
			KarmaWindow_MemberList_ScrollFrameScrollBar:SetValue(i-1);
			break;
		end
	end	
end

function 	KarmaWindow_UpdatePartyList()
	ProfileStart("KarmaWindow_UpdatePartyList");
	local memberlist,button,i,numEntries
	local membername;
	local memberobj;
		
	numEntries=GetNumPartyMembers();

	for i = 1,4 do
		local buttontext=getglobal("PartyList_GlobalButton"..i.."_Text");
		buttontext:SetText("");

		local button=getglobal("PartyList_GlobalButton"..i);
		button:UnlockHighlight();
	end	
	
	for i = 1,numEntries do
		local button=getglobal("PartyList_GlobalButton"..i);
		local buttontext=getglobal("PartyList_GlobalButton"..i.."_Text");
		membername=UnitName("party"..i);
		if (KARMA_CURRENTMEMBER==membername) then
			button:LockHighlight();
		end
		buttontext:SetText(membername);
		red,green,blue=Karma_MemberList_GetColors(membername);
		buttontext:SetTextColor(red,green,blue);
	end
			
	ProfileStop("KarmaWindow_UpdatePartyList");	
end

function  KarmaWindow_UpdateMemberList()
	ProfileStart("KarmaWindowUpdateMemberList");
	local memberlist,button,i,numEntries
	local membernames={};
		
	membernames=Karma_MemberList_GetMemberNames();
	membernames=Karma_MemberFieldNumericSort(membernames);

	i=0;
	for key,value in membernames do
		i=i+1;
	end
	numEntries=i;

	for i=1,KARMA_MEMBERLIST_SIZE do
		local buttontext=getglobal("MemberList_GlobalButton"..i.."_Text");
		buttontext:SetText("");
		
		local button=getglobal("MemberList_GlobalButton"..i);
		button:UnlockHighlight();
	end


	local 	counter=1;
	local 	nindex=1;
	for key,value in membernames do
		--search the index of the array for the current users name
		if (nindex-FauxScrollFrame_GetOffset(KarmaWindow_MemberList_ScrollFrame) >=0) then
			if (counter <=KARMA_MEMBERLIST_SIZE) then
				local buttontext=getglobal("MemberList_GlobalButton"..counter.."_Text");
				buttontext:SetText(value);
				
				local button=getglobal("MemberList_GlobalButton"..counter);
				if (KARMA_CURRENTMEMBER==value) then
					button:LockHighlight();
				end
				local memberobj;
				memberobj=Karma_GetMemberObject(value);
				if (memberobj) then
					local karma,red,green,blue;
					karma=Karma_MemberObject_GetKarma(memberobj);
					red,green,blue=Karma_MemberList_GetColors(Karma_MemberObject_GetName(memberobj));
					buttontext:SetTextColor(red,green,blue);
				end
				counter=counter+1;
			end
		end
		nindex=nindex+1;
	end
		
	FauxScrollFrame_Update(KarmaWindow_MemberList_ScrollFrame, numEntries*2, KARMA_MEMBERLIST_SIZE, 13, nil, 0, 0);		
	ProfileStop("KarmaWindowUpdateMemberList");	
end


function	KarmaWindow_UpdateCurrentMember()
	ProfileStart("KarmaWindow_UpdateCurrentMember");	
	local memberobj,playerobj;

	KarmaWindow_ChosenPlayerXPPercentage:SetText("");
	KarmaWindow_ChosenPlayerXPAccrued:SetText("");

	memberobj=Karma_GetMemberObject(KARMA_CURRENTMEMBER);
	if (memberobj==nil) then
		return -- Perfectly reasonable.
	end

	playerobj=Karma_GetPlayerObject();

	local memberaccrue=Karma_MemberObject_GetXP(memberobj);
	local playeraccrue=playerobj[KARMA_CHARACTERFIELD_XPTOTAL];
	
	if (memberaccrue==nil or playeraccrue==nil) then
		KarmaWindow_ChosenPlayerXPPercentage:SetText("0.0");
		KarmaWindow_ChosenPlayerXPAccrued:SetText("0");
		KarmaWindow_ChosenPlayer:SetText(KARMA_CURRENTMEMBER);
		ProfileStop("KarmaWindow_UpdateCurrentMember")	
		return		
	end  
	
	local per=(100*(tonumber(memberaccrue)))/tonumber(playeraccrue);
	KarmaWindow_ChosenPlayerXPPercentage:SetText(string.format("%.2f",per));
	KarmaWindow_ChosenPlayerXPAccrued:SetText(Karma_MemberObject_GetXP(memberobj));
	KarmaWindow_ChosenPlayer:SetText(KARMA_CURRENTMEMBER);

	local membertotal,memberdays,memberhours,membermins,memberseconds;
	
	membertotal,memberdays,memberhours,membermins,memberseconds=Karma_MemberObject_GetTimePlayed(memberobj);
	
	per=(100*(membertotal/playerobj["PLAYED"]));
	KarmaWindow_ChosenPlayerTimePercentage:SetText(string.format("%.2f",per));
	KarmaWindow_ChosenPlayerTimeAccrued:SetText(""..memberdays.."d "..memberhours.."h "..membermins.."m "..memberseconds.."s");
	

	ProfileStop("KarmaWindow_UpdateCurrentMember")	
end

function  KarmaWindow_UpdateQuestList()
	ProfileStart("KarmaWindowUpdateQuestList")
	local playerobj,questidlist,questlist,index,value,key
	local button
	local memberobj,i
		
	for i=1,10 do
		button=getglobal("QuestList_GlobalButton"..i.."_Text");
		button:SetText("");
	end
	
	if (KARMA_CURRENTMEMBER == "" or KARMA_CURRENTMEMBER==nil) then
		ProfileStop("KarmaWindowUpdateQuestList")
		return;
	end 
	
	memberobj=Karma_GetMemberObject(KARMA_CURRENTMEMBER);
	playerobj=Karma_GetPlayerObject();
	questidlist=Karma_MemberObject_GetQuestList(memberobj);
	
	i=0;
	for key,value in questidlist do
		i=i+1;
	end
	numEntries=i;		

	local 	counter=1;
	local 	nindex=0;
	
	questlist=Karma_QuestList_GetListOfNames(questidlist);

	for key,value in questlist do
		--search the index of the array for the current users name

		if (nindex-FauxScrollFrame_GetOffset(KarmaWindow_QuestList_ScrollFrame) >=0) then
			if (counter <=10) then
				button=getglobal("QuestList_GlobalButton"..counter.."_Text");
				button:SetText(value);
				counter=counter+1;
			end
		end
		nindex=nindex+1;
	end
	
	FauxScrollFrame_Update(KarmaWindow_QuestList_ScrollFrame, numEntries, 10, 13, nil, 0, 0);	
	ProfileStop("KarmaWindowUpdateQuestList")
end


function  KarmaWindow_UpdateZoneList()
	ProfileStart("KarmaWindowUpdateZoneList")
	local playerobj,zoneidlist,zonelist,index,value,key
	local button
	local memberobj,i
		
	for i=1,10 do
		local button=getglobal("ZoneList_GlobalButton"..i.."_Text");
		button:SetText("");
	end
	
	if (KARMA_CURRENTMEMBER == "" or KARMA_CURRENTMEMBER==nil) then
		ProfileStop("KarmaWindowUpdateZoneList")
		return;
	end 
	
	memberobj=Karma_GetMemberObject(KARMA_CURRENTMEMBER);
	playerobj=Karma_GetPlayerObject();
	zoneidlist=Karma_MemberObject_GetZoneList(memberobj);
	
	i=0;
	for key,value in zoneidlist do
		i=i+1;
	end
	numEntries=i;		

	local 	counter=1;
	local 	nindex=0;
	
	zonelist=Karma_ZoneList_GetListOfNames(zoneidlist);

	for key,value in zonelist do
		--search the index of the array for the current users name

		if (nindex-FauxScrollFrame_GetOffset(KarmaWindow_ZoneList_ScrollFrame) >=0) then
			if (counter <=10) then
				button=getglobal("ZoneList_GlobalButton"..counter.."_Text");
				button:SetText(value);
				counter=counter+1;
			end
		end
		nindex=nindex+1;
	end
	
	FauxScrollFrame_Update(KarmaWindow_ZoneList_ScrollFrame, numEntries, 10, 13, nil, 0, 0);	
	ProfileStop("KarmaWindowUpdateZoneList")
end


function	KarmaWindow_NotesInitializeText()
	ProfileStart("KarmaWindow_NotesInitializeText")
	local memberobj;
	memberobj=Karma_GetMemberObject(KARMA_CURRENTMEMBER);
	
	if (KARMA_CURRENTMEMBER == "" or KARMA_CURRENTMEMBER == nil or memberobj==nil) then
		KarmaWindow_Notes_EditBox:SetText("");
		ProfileStop("KarmaWindow_NotesInitializeText")
		return;
	end	

	local scrollBar = getglobal(KarmaWindow_Notes_EditBox:GetParent():GetParent():GetName().."ScrollBar")
	scrollBar:SetValue(0);
	KarmaWindow_Notes_EditBox:GetParent():GetParent():UpdateScrollChildRect();

	KarmaWindow_Notes_EditBox:SetText(Karma_MemberObject_GetNotes(memberobj));
	ProfileStop("KarmaWindow_NotesInitializeText")
end

function	KarmaWindow_NotesUpdateText()
	ProfileStart("KarmaWindow_NotesUpdateText")
	local memberobj;
	if (KARMA_CURRENTMEMBER == "" or KARMA_CURRENTMEMBER == nil) then
		ProfileStop("KarmaWindow_NotesUpdateText")
		return;
	end	
	memberobj=Karma_GetMemberObject(KARMA_CURRENTMEMBER);
	Karma_MemberObject_SetNotes(memberobj,KarmaWindow_Notes_EditBox:GetText());	
	ProfileStop("KarmaWindow_NotesUpdateText")
end

function	KarmaWindow_UpdateKarmaBar()
	ProfileStart("KarmaWindow_UpdateKarmaBar")
	local memberobj;
	memberobj=Karma_GetMemberObject(KARMA_CURRENTMEMBER);

	if (KARMA_CURRENTMEMBER == "" or KARMA_CURRENTMEMBER == nil) then
		ProfileStop("KarmaWindow_UpdateKarmaBar")
		return;
	end	
	
	KarmaDebug(KARMA_CURRENTMEMBER.." karmarating="..Karma_MemberObject_GetKarma(memberobj));
	KarmaWindow_KarmaIndicator:SetValue(Karma_MemberObject_GetKarma(memberobj));
	
	local red,green,blue;
	red,green,blue=Karma_GetColors_Karma(Karma_MemberObject_GetName(memberobj));
	
	KarmaWindow_KarmaIndicator:SetStatusBarColor(red,green,blue);
	ProfileStop("KarmaWindow_UpdateKarmaBar")
end

function 	Karma_DecreaseKarma(membername,scroll)
	ProfileStart("Karma_DecreaseKarma")	
	memberobj=Karma_GetMemberObject(membername);
	
	if (memberobj==nil) then
		ProfileStop("Karma_DecreaseKarma")	
		return;
	end

	local curkarma=Karma_MemberObject_GetKarma(memberobj);
	curkarma=curkarma-1;
	if (curkarma<=0) then
		curkarma=1;
	end
	Karma_MemberObject_SetKarma(memberobj,curkarma);
	if (scroll) then
		KarmaWindow_ScrollToCurrentMember();			
		KarmaWindow_Update();	
	end
	ProfileStop("Karma_DecreaseKarma")	
end

function 	Karma_IncreaseKarma(membername,scroll)
	ProfileStart("Karma_IncreaseKarma")	
	memberobj=Karma_GetMemberObject(membername);

	if (memberobj==nil) then
		ProfileStop("Karma_IncreaseKarma")	
		return;
	end

	local curkarma=Karma_MemberObject_GetKarma(memberobj);
	curkarma=curkarma+1;
	if (curkarma>100) then
		curkarma=100;
	end
	Karma_MemberObject_SetKarma(memberobj,curkarma);
	if (scroll) then
		KarmaWindow_ScrollToCurrentMember();			
		KarmaWindow_Update();	
	end
	ProfileStop("Karma_IncreaseKarma")	
end

function KarmaWindow_MemberList_OnEnter(button)
	id=this:GetID();
	button=getglobal("MemberList_GlobalButton"..id.."_Text");
	
	local name=button:GetText();

	if (name ~="" and name ~=nil) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		local mo=Karma_GetMemberObject(name);
		local red,green,blue
		
		red,green,blue=Karma_GetColors_Karma(name);
		GameTooltip:SetText(name,red,green,blue);		
		-- tooltip text has the form:
		--	Guild
		--	Gender, Race, Class, Level
		local guild=Karma_MemberObject_GetGuild(mo);
		if (guild ~="") then
			GameTooltip:AddLine("<"..guild..">",1,1,1);
		end
		local temptext=""
		local gender,race,class,level
		
		gender=Karma_MemberObject_GetGender(mo);
		race=Karma_MemberObject_GetRace(mo);
		class=Karma_MemberObject_GetClass(mo);		
		level=Karma_MemberObject_GetLevel(mo);
		if (level >0) then
			temptext=string.format("Level %s %s %s %s",level,gender,race,class);
			GameTooltip:AddLine(temptext,1,1,1);
		end
		
		GameTooltip:Show();
	end
end

function KarmaWindow_MemberList_OnLeave(button)
	GameTooltip:Hide();
end

function KarmaWindow_QuestList_OnEnter(button)
	id=this:GetID();
	button=getglobal("QuestList_GlobalButton"..id.."_Text");
	
	local name=button:GetText();

	if (name ~="" and name ~=nil) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");		
		GameTooltip:SetText(name,red,green,blue);		
		GameTooltip:Show();
	end
end

function KarmaWindow_QuestList_OnLeave(button)
	GameTooltip:Hide();
end

function KarmaWindow_ZoneList_OnEnter(button)
	id=this:GetID();
	button=getglobal("ZoneList_GlobalButton"..id.."_Text");
	
	local name=button:GetText();

	if (name ~="" and name ~=nil) then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");		
		GameTooltip:SetText(name,red,green,blue);		
		GameTooltip:Show();
	end
end

function KarmaWindow_ZoneList_OnLeave(button)
	GameTooltip:Hide();
end



-----------------------------------------
--	UNITPopUp Patch
-----------------------------------------

function KARMA_popuppatch()
	local index = this.value;
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button = UnitPopupMenus[this.owner][index];
	local unit = dropdownFrame.unit;
	local i=0;

	if ( button == "KARMA_GIVE" ) then
		for i=1,3 do
			Karma_IncreaseKarma(UnitName(unit),false);
		end
		KarmaWindow_Update();
	elseif (button=="KARMA_TAKE") then
		for i=1,3 do
			Karma_DecreaseKarma(UnitName(unit),false);
		end
		KarmaWindow_Update();
	end
	
	return KARMA_OriginalUnitPopupFunction();
end

function Karma_InsertUnitPopupPatch()
	if (KARMA_OriginalUnitPopupFunction==nil) then
		UnitPopupButtons["KARMA_GIVE"] = { text = "Karma++", dist = 0 };
		UnitPopupButtons["KARMA_TAKE"] = { text = "Karma--", dist = 0 };
		table.insert(UnitPopupMenus["PARTY"],"KARMA_GIVE");
		table.insert(UnitPopupMenus["PARTY"],"KARMA_TAKE");

		table.insert(UnitPopupMenus["PLAYER"],"KARMA_GIVE");
		table.insert(UnitPopupMenus["PLAYER"],"KARMA_TAKE");
		
		
		KARMA_OriginalUnitPopupFunction=UnitPopup_OnClick;
		UnitPopup_OnClick=KARMA_popuppatch;
	end
end


function Karma_TargetFrame_CheckFaction()
	if (UnitName("target") ~=nil and UnitName("target")~="" and (UnitFactionGroup("target")==UnitFactionGroup("player"))
		and UnitIsPlayer("target")) then
		local targetname=UnitName("target");
		local memberlist=Karma_Faction_GetMemberList();
		if (memberlist[Karma_AccentedToPlain(strsub(targetname,1,1))][targetname] ~= nil) then 
			KARMA_CURRENTMEMBER=targetname;
		end
		KarmaWindow_Update();
	else
		KARMA_OriginalTargetFrame_CheckFaction();
	end
end

function Karma_InsertTargetFramePatch()
	if (KARMA_OriginalTargetFrame_CheckFaction==nil) then
		KARMA_OriginalTargetFrame_CheckFaction=TargetFrame_CheckFaction;
		TargetFrame_CheckFaction=Karma_TargetFrame_CheckFaction;
	end
end

function Karma_InsertChatFramePatch()
	if (KARMA_OriginalChatFrame_OnEvent==nil) then
		KARMA_OriginalChatFrame_OnEvent=ChatFrame_OnEvent;
		ChatFrame_OnEvent=Karma_ChatFrame_OnEvent;
	end
end

function Karma_InsertUIParentPatch()
	if (KARMA_Original_UIParent_OnEvent==nil) then
		KARMA_Original_UIParent_OnEvent=UIParent_OnEvent;
		UIParent_OnEvent=Karma_AutoIgnore_Invites;
	end
end

function Karma_InsertWhoUpdatePatch()
	if (KARMA_Original_Who_Update==nil) then
		KARMA_Original_Who_Update=FriendsFrame_OnEvent
		FriendsFrame_OnEvent=Karma_Who_Update;
	end
end


-----------------------------------------
--	Karma_Who_Update
-----------------------------------------


function	Karma_Command_AddIgnore_Start(args)
	Karma_Executing_Command=true;
	-- Create a who command and send it to the server for processing
	whotext=WHO_TAG_NAME.."\""..args.name.."\""
	Karma_WhoQueue[getn(Karma_WhoQueue)+1]={func=Karma_AddIgnore_Complete,name=args.name};
	SetWhoToUI(1);
	SendWho(whotext);
end

function	Karma_AddIgnore_Complete(addname)
	local numWhos, totalCount = GetNumWhoResults();
	local name, guild, level, race, class, zone, group
	local i=0;
	local found=false;
	addname=string.upper(Karma_AccentedToPlain(strsub(addname,1,1)))..strsub(addname,2)
	for i=1,totalCount do
		name, guild, level, race, class, zone, group = GetWhoInfo(i);
		if (name==addname) then
			Karma_MemberList_Add(addname);
			Karma_MemberList_Update(addname);
			mo=Karma_GetMemberObject(addname);
			Karma_MemberObject_SetKarma(mo,1);
			DEFAULT_CHAT_FRAME:AddMessage(addname.." was added to your Karma list, and ignored.");
			found=true;
		end
	end
	if (found==false) then
		DEFAULT_CHAT_FRAME:AddMessage(addname.." was not found. They may not be currently logged on.");
	end
	if (FriendsFrame:IsVisible()) then
		SetWhoToUI(1);
	else
		SetWhoToUI(0);
	end
	Karma_Executing_Command=false;
end


function	Karma_Command_AddMember_Start(args)
	Karma_Executing_Command=true;
	-- Create a who command and send it to the server for processing
	local whotext=WHO_TAG_NAME.."\""..args.name.."\""
	Karma_WhoQueue[getn(Karma_WhoQueue)+1]={func=Karma_AddMember_Complete,name=args.name};
	SetWhoToUI(1);
	SendWho(whotext);
end

function	Karma_AddMember_Complete(addname)
	local numWhos, totalCount = GetNumWhoResults();
	local name, guild, level, race, class, zone, group
	local i=0;
	local found=false;
	addname=string.upper(Karma_AccentedToPlain(strsub(addname,1,1)))..strsub(addname,2)
	for i=1,totalCount do
		name, guild, level, race, class, zone, group = GetWhoInfo(i);
		if (name==addname) then
			Karma_MemberList_Add(addname);
			Karma_MemberList_Update(addname);
			DEFAULT_CHAT_FRAME:AddMessage(addname.." was added to your Karma list.");
			found=true;
		end
	end
	if (found==false) then
		DEFAULT_CHAT_FRAME:AddMessage(addname.." was not found. They may not be currently logged on.");
	end
	if (FriendsFrame:IsVisible()) then
		SetWhoToUI(1);
	else
		SetWhoToUI(0);
	end
	Karma_Executing_Command=false;
end

function	Karma_Command_UpdateMembers(args)
	Karma_MemberList_CreateMemberNamesCache();
	KarmaWindow_Update();			
end

function	Karma_Who_Update(event)
	if (getn(Karma_WhoQueue)==0) then
		KARMA_Original_Who_Update(event);
		return;
	end
	if (event==nil) then 
		event="NIL";
	end
	
	local elem=Karma_WhoQueue[1];
	local i;
	if (getn(Karma_WhoQueue)>1) then
		for i=2,getn(Karma_WhoQueue) do
			if (Karma_WhoQueue[i] ~= nil) then
				Karma_WhoQueue[i-1]=Karma_WhoQueue[i];
				Karma_WhoQueue[i]=nil;
			end
		end
	else
		Karma_WhoQueue={};
	end
	if (elem ~=nil) then
		elem.func(elem.name);
	else
		KARMA_Original_Who_Update(event);
	end
end



-----------------------------------------
-- Invite patch
-----------------------------------------

function Karma_AutoIgnore_Invites(event)

	if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==0) then
		KARMA_Original_UIParent_OnEvent(event);	
		return;
	end
	
	if (event ~= "PARTY_INVITE_REQUEST" and event ~="DUEL_REQUESTED" and event~="GUILD_INVITE_REQUEST" and
		event ~= "TRADE_REQUEST") then
		KARMA_Original_UIParent_OnEvent(event);
		return;
	end

	if (event == "GUILD_INVITE_REQUEST" ) then
		local memberlist=nil;
		if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==1 and Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_INVITES)==1) then
			memberlist=Karma_Faction_GetMemberList();
			if (memberlist[Karma_AccentedToPlain(strsub(arg1,1,1))][arg1]==nil) then
				KARMA_Original_UIParent_OnEvent(event);
			else
				local memberobj=Karma_GetMemberObject(arg1);
				local karma=Karma_MemberObject_GetKarma(memberobj);
				local threshold=tonumber(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_THRESHOLD));
				if (karma <= threshold) then
					DeclineGuild();
				else
					KARMA_Original_UIParent_OnEvent(event);
				end
			end
		else
			KARMA_Original_UIParent_OnEvent(event);
		end		
		return;
	end
	if ( event == "PARTY_INVITE_REQUEST" ) then
		local memberlist=nil;
		if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==1 and Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_INVITES)==1) then
			memberlist=Karma_Faction_GetMemberList();
			if (memberlist[Karma_AccentedToPlain(strsub(arg1,1,1))][arg1]==nil) then
				KARMA_Original_UIParent_OnEvent(event);
			else
				local memberobj=Karma_GetMemberObject(arg1);
				local karma=Karma_MemberObject_GetKarma(memberobj);
				local threshold=tonumber(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_THRESHOLD));
				if (karma <= threshold) then
					DeclineGroup();
				else
					KARMA_Original_UIParent_OnEvent(event);
				end
			end
		else
			KARMA_Original_UIParent_OnEvent(event);
		end		
		return;
	end
	if ( event == "TRADE_REQUEST" ) then
		local memberlist=nil;
		if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==1 and Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_INVITES)==1) then
			memberlist=Karma_Faction_GetMemberList();
			if (memberlist[Karma_AccentedToPlain(strsub(arg1,1,1))][arg1]==nil) then
				KARMA_Original_UIParent_OnEvent(event);
			else
				local memberobj=Karma_GetMemberObject(arg1);
				local karma=Karma_MemberObject_GetKarma(memberobj);
				local threshold=tonumber(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_THRESHOLD));
				if (karma <= threshold) then
					CancelTrade();
				else
					KARMA_Original_UIParent_OnEvent(event);
				end
			end
		else
			KARMA_Original_UIParent_OnEvent(event);
		end		
		return;
	end	

	if ( event == "DUEL_REQUESTED" ) then
		local memberlist=nil;
		if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==1 and Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_INVITES)==1) then
			memberlist=Karma_Faction_GetMemberList();
			if (memberlist[Karma_AccentedToPlain(strsub(arg1,1,1))][arg1]==nil) then
				KARMA_Original_UIParent_OnEvent(event);
			else
				local memberobj=Karma_GetMemberObject(arg1);
				local karma=Karma_MemberObject_GetKarma(memberobj);
				local threshold=tonumber(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_THRESHOLD));
				if (karma <= threshold) then
					CancelDuel();
				else
					KARMA_Original_UIParent_OnEvent(event);
				end
			end
		else
			KARMA_Original_UIParent_OnEvent(event);
		end		
		return;
	end
	
end


-----------------------------------------
-- CHAT FUNCTIONS
-----------------------------------------

function Karma_ChatFrame_OnEvent(event)
	if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==0) then
		KARMA_OriginalChatFrame_OnEvent(event);	
		return;
	end

	if (arg2==nil or arg2=="") then
		if (KARMA_OriginalChatFrame_OnEvent) then
			KARMA_OriginalChatFrame_OnEvent(event);
		end
		return;
	end

	if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		
		local channelLength = strlen(arg4);
		if ( (strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and (arg1 ~= "INVITE") ) then
			local memberlist=nil;
			if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==1) then
				memberlist=Karma_Faction_GetMemberList();
				if (memberlist[Karma_AccentedToPlain(strsub(arg2,1,1))][arg2]==nil) then
					KARMA_OriginalChatFrame_OnEvent(event);
				else
					local memberobj=Karma_GetMemberObject(arg2);
					local karma=Karma_MemberObject_GetKarma(memberobj);
					local threshold=tonumber(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_THRESHOLD));
					if (karma <= threshold) then
						-- ignore else do the normal thing
					else
						KARMA_OriginalChatFrame_OnEvent(event);			
					end
				end
			else
				KARMA_OriginalChatFrame_OnEvent(event);
			end
			return;
		end

		if ( type == "SYSTEM") then
				KARMA_OriginalChatFrame_OnEvent(event);
		elseif (type == "TEXT_EMOTE" or type == "SKILL" or type == "LOOT" ) then
			KARMA_OriginalChatFrame_OnEvent(event);
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			KARMA_OriginalChatFrame_OnEvent(event);
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			KARMA_OriginalChatFrame_OnEvent(event);
		elseif ( type == "IGNORED" ) then
			KARMA_OriginalChatFrame_OnEvent(event);
		elseif ( type == "CHANNEL_LIST") then
			KARMA_OriginalChatFrame_OnEvent(event);
		elseif (type == "CHANNEL_NOTICE_USER") then
			KARMA_OriginalChatFrame_OnEvent(event);
		elseif (type == "CHANNEL_NOTICE") then
			KARMA_OriginalChatFrame_OnEvent(event);
		else
			local memberlist=nil;
			if (Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE)==1) then
				memberlist=Karma_Faction_GetMemberList();
				if (memberlist[Karma_AccentedToPlain(strsub(arg2,1,1))][arg2]==nil) then
					KARMA_OriginalChatFrame_OnEvent(event);
				else
					local memberobj=Karma_GetMemberObject(arg2);
					local karma=Karma_MemberObject_GetKarma(memberobj);
					local threshold=tonumber(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_THRESHOLD));
					if (karma <= threshold) then
						-- ignore else do the normal thing
					else
						KARMA_OriginalChatFrame_OnEvent(event);			
					end
				end
			else
				KARMA_OriginalChatFrame_OnEvent(event);
			end
		end
 
		return;
	else
		KARMA_OriginalChatFrame_OnEvent(event);
	end
end


-----------------------------------------
-- CONFIG FUNCTIONS
-----------------------------------------


function	Karma_InitializeConfig()
	if (KarmaConfig==nil) then
		KarmaConfig={};
	end
	Karma_FieldInitialize(KarmaConfig,KARMA_CONFIG_AUTOIGNORE,0);
	Karma_FieldInitialize(KarmaConfig,KARMA_CONFIG_AUTOIGNORE_THRESHOLD,10);
	Karma_FieldInitialize(KarmaConfig,KARMA_CONFIG_AUTOIGNORE_INVITES,1);

	Karma_FieldInitialize(KarmaConfig,KARMA_CONFIG_SORTFUNCTION,KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA);
	Karma_FieldInitialize(KarmaConfig,KARMA_CONFIG_COLORFUNCTION,KARMA_CONFIG_COLORFUNCTION_TYPE_KARMA);
end

function 	Karma_GetConfig(config)
	return KarmaConfig[config];
end

function 	Karma_SetConfig(config,value)
	KarmaConfig[config]=value;
end

-----------------------------------------
--	Karma Options Window
-----------------------------------------
KARMA_OPTIONS_SORTTYPE_DROPDOWN={
	{name= "Karma", sortType=KARMA_CONFIG_SORTFUNCTION_TYPE_KARMA},
	{name= "Experience", sortType=KARMA_CONFIG_SORTFUNCTION_TYPE_XP},
	{name= "Time", sortType=KARMA_CONFIG_SORTFUNCTION_TYPE_PLAYED},
	{name= "Name", sortType=KARMA_CONFIG_SORTFUNCTION_TYPE_NAME}
};

KARMA_OPTIONS_COLORTYPE_DROPDOWN={
	{name= "Karma", sortType=KARMA_CONFIG_COLORFUNCTION_TYPE_KARMA},
	{name= "Experience", sortType=KARMA_CONFIG_COLORFUNCTION_TYPE_XP},
	{name= "Time", sortType=KARMA_CONFIG_COLORFUNCTION_TYPE_PLAYED}
};



function KarmaWindowOptions_SortByDropDown_Initialize()
	local info;
	for i=1, getn(KARMA_OPTIONS_SORTTYPE_DROPDOWN), 1 do
		info = {};
		info.text = KARMA_OPTIONS_SORTTYPE_DROPDOWN[i].name;
		info.func = KarmaWindowOptions_SortByDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function KarmaWindowOptions_SortByDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, KarmaWindowOptions_SortByDropDown_Initialize);
	UIDropDownMenu_SetWidth(110);
	UIDropDownMenu_SetButtonWidth(24);
end

function KarmaWindowOptions_SortByDropDown_OnShow()
	local i
	for i=1,getn(KARMA_OPTIONS_SORTTYPE_DROPDOWN) do
		local info={};
		if (KARMA_OPTIONS_SORTTYPE_DROPDOWN[i].sortType==Karma_GetConfig(KARMA_CONFIG_SORTFUNCTION)) then
			UIDropDownMenu_SetSelectedID(KarmaOptionsWindow_SortType_DropDown,i);					
		end
	end
end

function KarmaWindowOptions_SortByDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(KarmaOptionsWindow_SortType_DropDown, this:GetID());
	if ( KARMA_OPTIONS_SORTTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_SortType_DropDown)].sortType ) then
		KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_OPTIONS_SORTTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_SortType_DropDown)].sortType;
		KarmaWindow_Update();
	end		
end

function KarmaWindowOptions_SortByDropDown_OnMouseUp()
	if ( KARMA_OPTIONS_SORTTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_SortType_DropDown)].sortType ) then
		KarmaConfig[KARMA_CONFIG_SORTFUNCTION]=KARMA_OPTIONS_SORTTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_SortType_DropDown)].sortType;
		KarmaWindow_Update();
	end
end



function KarmaWindowOptions_ColorByDropDown_Initialize()
	local info;
	for i=1, getn(KARMA_OPTIONS_COLORTYPE_DROPDOWN), 1 do
		info = {};
		info.text = KARMA_OPTIONS_COLORTYPE_DROPDOWN[i].name;
		info.func = KarmaWindowOptions_ColorByDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function KarmaWindowOptions_ColorByDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, KarmaWindowOptions_ColorByDropDown_Initialize);
	UIDropDownMenu_SetWidth(110);
	UIDropDownMenu_SetButtonWidth(24);
end

function KarmaWindowOptions_ColorByDropDown_OnShow()
	local i
	for i=1,getn(KARMA_OPTIONS_COLORTYPE_DROPDOWN) do
		local info={};
		if (KARMA_OPTIONS_COLORTYPE_DROPDOWN[i].sortType==Karma_GetConfig(KARMA_CONFIG_COLORFUNCTION)) then
			UIDropDownMenu_SetSelectedID(KarmaOptionsWindow_ColorType_DropDown,i);					
		end
	end
end


function KarmaWindowOptions_ColorByDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(KarmaOptionsWindow_ColorType_DropDown, this:GetID());
	if ( KARMA_OPTIONS_COLORTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_ColorType_DropDown)].sortType ) then
		KarmaConfig[KARMA_CONFIG_COLORFUNCTION]=KARMA_OPTIONS_COLORTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_ColorType_DropDown)].sortType;
		KarmaWindow_Update();
	end
end

function KarmaWindowOptions_ColorByDropDown_OnMouseUp()
	if ( KARMA_OPTIONS_COLORTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_ColorType_DropDown)].sortType ) then
		KarmaConfig[KARMA_CONFIG_COLORFUNCTION]=KARMA_OPTIONS_COLORTYPE_DROPDOWN[UIDropDownMenu_GetSelectedID(KarmaOptionsWindow_ColorType_DropDown)].sortType;
		KarmaWindow_Update();
	end
end



function	KarmaOptionWindow_AutoignoreEnabled_Checkbox_OnLoad()
	this:SetChecked(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE));
end


function	KarmaOptionWindow_AutoignoreEnabled_Checkbox_OnClick()
	KarmaConfig[KARMA_CONFIG_AUTOIGNORE]=this:GetChecked();
end



function	KarmaOptionWindow_IgnoreInvites_Checkbox_OnLoad()
	this:SetChecked(Karma_GetConfig(KARMA_CONFIG_AUTOIGNORE_INVITES));	
end


function	KarmaOptionWindow_IgnoreInvites_Checkbox_OnClick()
	KarmaConfig[KARMA_CONFIG_AUTOIGNORE_INVITES]=this:GetChecked();
end

function	KarmaOptionWindow_AutoIgnoreThreshold_OnShow()
	this:SetText(KarmaConfig[KARMA_CONFIG_AUTOIGNORE_THRESHOLD]);
end

function	KarmaOptionWindow_AutoIgnoreThreshold_OnChanged()
	KarmaConfig[KARMA_CONFIG_AUTOIGNORE_THRESHOLD]=this:GetText();
end


function	KarmaOptionsWindow_OnLoad()
	
end

function	KarmaOptionsWindow_OnUpdate()

end

function	KarmaOptionsWindow_OnEvent()

end

-----------------------------------------
-- DEBUG FUNCTIONS
-----------------------------------------
function KarmaDebug(text)
	if (KARMA_PROFILE_FRAME == nil) then
		return;
	end
	local counter=KARMA_INDENT;
	indenttext=""
	while (counter > 0) do
		indenttext=indenttext.."  "
		counter=counter-1
	end
	KARMA_PROFILE_FRAME:AddMessage(indenttext.."=== "..text);
end

function ProfileStart(funcname)
	if (KARMA_PROFILE_FRAME == nil) then
		return;
	end
	local counter=KARMA_INDENT;
	indenttext=""
	while (counter > 0) do
		indenttext=indenttext.."  "
		counter=counter-1
	end
	KARMA_PROFILE_FRAME:AddMessage(indenttext..">>> "..funcname);	
	KARMA_INDENT=KARMA_INDENT+1;
end 

function ProfileStop(funcname)
	if (KARMA_PROFILE_FRAME == nil) then
		return;
	end
	indenttext=""
	KARMA_INDENT=KARMA_INDENT-1;
	if (KARMA_INDENT <0) then
		KARMA_INDENT=0;
	end
	local counter=KARMA_INDENT;
	while (counter > 0) do
		indenttext=indenttext.."  "
		counter=counter-1
	end
	KARMA_PROFILE_FRAME:AddMessage(indenttext.."<<< "..funcname);	
end

function Karma_NilToString(value)
	if (value==nil) then 
		return "";
	end
	return value;
end

function Karma_SetupDebug()
	-- Search for the Profiler's Chat Frame, the tab of the window must be named... "Karma"
	local count = 0;
	local i,temp,name;
	for i=1, NUM_CHAT_WINDOWS do
		temp, temp, temp, temp, temp, temp, shown, temp = GetChatWindowInfo(i);
		chatFrame = getglobal("ChatFrame"..i);
		if ( chatFrame ) then
			if ( shown or chatFrame.isDocked ) then
				local tab = getglobal(chatFrame:GetName().."Tab");
				name=tab:GetText();
				if (name=="Karma") then
					KARMA_PROFILE_FRAME=chatFrame;
				end
			end
		end
	end
end

