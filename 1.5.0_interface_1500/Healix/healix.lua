------------------------------------------
--		Variables		--
------------------------------------------
--<<Strings>>
Class = "Shaman";		--this is the players class (Will be changed)
SName = "nil"; STime = "nil"; 
local SMana = "nil"; local SRank = "nil"; --global last used spell attributes
local SavedTarget = "nil";	--The saved last mouseover
--<<Bools>>
Hx_Initialized = nil;	--your first load.
--<<Ints>>
isSpellCast = nil;		-- if a spell has been cast but requires some one to click
Hx_Fetch_Timer=0;		--<<Fetch Var: watches on update and is a timer>>
Hx_InCombat = nil;		--weither or not they are in combat
Hx.NoTarget = {};

--------------------------------------------------
--		OnUpdate(Fetch)			--
--------------------------------------------------
function Hx_OnUpdate(arg1)
	Hx_Fetch_Timer = Hx_Fetch_Timer + arg1;
	if ((not Hx_Initialized) and (Hx_Fetch_Timer > 0.2)) then
		local pName=UnitName("player"); local pClass=UnitClass("player"); local pRace=UnitRace("player");
		if (pName==nil or pClass==nil or pRace==nil or pName=="Unknown Entity" or pName==UNKNOWNBEING or pName==UNKNOWNOBJECT) then
			return;
		else
			Hx_Init(); Hx_Fetch_Frame:Hide(); Hx_Fetch_Timer = 0;
		end
	end
end

------------------------------------
--            On Event            --
------------------------------------
function Hx_OnEvent (event, a, b)
	if (not Hx_Initialized) then Hx_DPrint("Not Initialized");  return; end
	if (not HxToggle[Class].Main) then return; end
	if (event == "SPELLCAST_STOP") then
		if (isSpellCast and (STime == "Instant" or STime == "Instant cast")) then
			Hx_DPrint("Spellcast Stop. With an instant spell");
			if (InstaCastTarget) then  
				Hx_OnSpellCast(SName,STime,InstaCastTarget);
				InstaCastTarget = nil;
			elseif (SavedTarget) then 
				Hx_OnSpellCast(SName,STime,SavedTarget);
				SavedTarget = nil;
			else
				Hx_OnSpellCast(SName,STime,UnitName("player")); 
			end	
		end
		isSpellCast = nil;
	elseif (event == "PLAYER_TARGET_CHANGED" and isSpellCast) then --this is for the F keys
		if (UnitExists("target") and not SpellIsTargeting()) then 
			Hx_OnSpellCast(SName,STime,UnitName("target")); 
		end
		isSpellCast = nil;
	elseif(event == "SPELLCAST_START" and isSpellCast) then
		Hx_DPrint("SPELLCAST_START Spell = "..a);
		if ((STime == "" or STime == "nil") and b) then STime = ((b/1000).."secs"); end
		if (InstaCastTarget) then
			if (SpellTellOnSpellcast) then
				SpellTellOnSpellcast(InstaCastTarget);
			end
			Hx_OnSpellCast(SName, STime, InstaCastTarget);
			InstaCastTarget = nil;
		elseif (SavedTarget) then
			if (SpellTellOnSpellcast) then
				SpellTellOnSpellcast(SavedTarget);
			end
			Hx_OnSpellCast(SName,STime,SavedTarget); 
			SavedTarget = nil;
		else
			if (SpellTellOnSpellcast) then
				SpellTellOnSpellcast(UnitName("player"));
			end
			Hx_OnSpellCast(SName,STime,UnitName("player")); 
		end
		isSpellCast = nil;
	elseif ((event == "SPELLCAST_INTERRUPTED") and HxToggle[Class].Interrupt == 1 and SpellTog[Class][SName] == 1 and (Hx_InCombat or HxToggle[Class].Combat == 0)) then
		if (HxToggle[Class].Channel == 1 and HxSave[Class].Channel) then
			Hx_SendChatMessage_Channel(HxSave[Class].Interrupt);
		elseif ( Hx_DoRaid() == 1) then SendChatMessage(HxSave[Class].Interrupt, "RAID");
		elseif ( Hx_DoParty() == 1 ) then SendChatMessage(HxSave[Class].Interrupt, "PARTY");
		else Hx_DPrint(HxSave[Class].Interrupt);
		end
		isSpellCast = nil; InstaCastTarget = nil; SavedTarget= nil;
	elseif (event == "SPELLCAST_FAILED") then
		isSpellCast = nil; InstaCastTarget = nil; SavedTarget = nil; Hx_DPrint("..SpellFailed..");
	elseif (event == "PLAYER_REGEN_ENABLED") then
		Hx_InCombat = nil; Hx_DPrint("Now out of combat");
	elseif (event == "PLAYER_REGEN_DISABLED") then
		Hx_InCombat = 1; Hx_DPrint("Now in combat");
	end
end

---------------------------------------------------
--		Display Function		 --
---------------------------------------------------
--Purpose: To display out: what the play is casting, on whom, and possibly when. If lua hade a Main() this would be it
--Recieve: String event, String SpellName, String SpellCastTime, String Spell_Target --Returns: Void
function Hx_OnSpellCast(SpellName, SpellCastTime, Spell_Target)
	SavedTarget = nil; --this was one time use
	Hx_DPrint("Hx_OnSpellCast: Target = "..Spell_Target.." SpellName = "..SpellName, 1, 0, 1);	--debug message
	--if we havent seen this spell registered dont dont do Hx
	if (SpellTog[Class][SpellName] ~= 1) then Hx_DPrint("Spelltog = nil"); return; end 
	--<<Variable Declaration and intialization>>--
	local Star = Spell_Target;	--the on is for display
	local OutTime = " ";			--this is the spells time if they want to display it
	local NumRaid = GetNumRaidMembers();
	local OnSelf = nil; 	--boolean if they are casting on themself
	if (Hx.SelfCast[SpellName]) then
		if (UnitExists("target") and UnitIsUnit("target","player")) then
			OnSelf = true; Hx_DPrint("OnSelf = true target is player");		
		elseif (Spell_Target == UnitName("player")) then
			OnSelf = true; Hx_DPrint("OnSelf = true Spell_Target == unitname('player')");
		elseif (Spell_Target == "nil") then
			OnSelf = true; Hx_DPrint("OnSelf = true spelltarget == nil");
		end
	end
	if (Spell_Target == "nil" or (OnSelf == true)) then Star = " "..Hx_ONSTAR..UnitName("player"); end
	--If the spell is one without a target or we arent displaying targets
	if (Hx.NoTarget[SpellName] or HxToggle[Class].Target == 0) then Star = ""; OnSelf = nil; end
	if (SpellCastTime ~= "nil" and HxToggle[Class].Time == 1) then OutTime = "("..SpellCastTime..")"; end
	--these will fail this from displaying
	if (Hx_SmartParty() ~= 1) then return; end
	if (HxToggle[Class].Combat == 1 and not Hx_InCombat) then return; end
	--these will set up the prefix from the checkboxes
	if (HxToggle[Class].Prefix ~= 1 and HxSave[Class].Prefix ~= "") then HxSave[Class].Prefix = ""; Hx_Print('Prefix now ""'); end
	
	--<<display>>--
	if (HxToggle[Class].Channel == 1 and HxSave[Class].Channel) then
		Hx_SendChatMessage_Channel(Hx_ConvertPercents(Spell_Target));
	elseif ( Hx_DoRaid() == 1) then
		Hx_SendChatMessage_Channel(Hx_ConvertPercents(Spell_Target),"RAID");
	elseif ( Hx_DoParty() == 1 ) then  --if in a party
		Hx_SendChatMessage_Channel(Hx_ConvertPercents(Spell_Target),"PARTY");
	elseif (HxToggle[Class].NonParty == 1 ) then
		if (OnSelf) then
			if (HxToggle[Class].EmoteSelf == 1) then
				if (UnitSex("player") == 1 ) then
					Star = Hx_ONHERSELF; --if they are a girl..
				else
					Star = Hx_ONHIMSELF; --if they are a guy (guy's = 0!... but of course thats false)
				end
				SendChatMessage(Hx_EMOTE_PREFIX..SpellName..Star..OutTime ,"EMOTE" );
			end
		else
			if (not Hx.NoTarget[SpellName]) then
				Star = Hx_ONSTAR..Star;
			end
			SendChatMessage(Hx_EMOTE_PREFIX..SpellName.." "..Star..OutTime ,"EMOTE" );
		end
	else
		Hx_DPrint("Error in selecting channel");
	end
	Spell_Target = "nil"; --this is only one time use 
end

function Hx_SendChatMessage_Channel(mess,chan)
	local Channel_Index = nil;
	if (not HxSave[Class].Channel and not chan) then return; end
	if (not chan) then chan = HxSave[Class].Channel; end
	for x=1, 20, 1 do
		local cnumb,cname = GetChannelName(x);
		if (cnumb and cname) then
			Hx_DPrint("Cnumb and cname = "..cnumb.." "..cname);
		end
		if (cname == chan) then Channel_Index = cnumb; end
	end
	UppercaseChan = strupper(chan);
	if (Channel_Index) then SendChatMessage(mess,"CHANNEL",nil,Channel_Index);
	elseif (UppercaseChan == "SAY") then SendChatMessage(mess,"SAY");
	elseif (UppercaseChan == "YELL") then SendChatMessage(mess,"YELL");
	elseif (UppercaseChan == "RAID") then SendChatMessage(mess,"RAID");
	elseif (UppercaseChan == "PARTY") then SendChatMessage(mess,"PARTY");
	elseif (UppercaseChan == "GUILD") then SendChatMessage(mess,"GUILD");
	elseif (UppercaseChan == "OFFICER") then SendChatMessage(mess,"OFFICER");
	elseif (UppercaseChan == "EMOTE") then SendChatMessage(mess,"EMOTE");
	else
		Hx_Print(Hx_CHANNEL_ERROR);
		HxToggle[Class].Channel = 0;
		ShowUIPanel(HxOptions);
	end
end
function Hx_DoWisper(S_Target)
	if (HxToggle[Class].Wisper ~= 1 or S_Target == "") then return nil; end
	return strsub(S_Target, 1+getn(Hx_ONSTAR));
end
function Hx_DoRaid()
	local NumRaid = GetNumRaidMembers();
	if (NumRaid > 0) and HxToggle[Class].Raid == 1 then return 1; end
	return nil;
end
function Hx_DoParty()
	local NumParty = GetNumPartyMembers();
	Hx_DPrint("NumParty = "..NumParty);
	if ((NumParty > 0) and (HxToggle[Class].Party == 1)) then return 1; end
	return nil;
end
function Hx_SmartParty()
	local Healers = 0; local NumParty = GetNumPartyMembers();
	if (Hx_CanHeal(Class)) then Healers = 1; end
	if (NumParty > 0 and HxToggle[Class].SmartParty == 1) then
		for z = 1, NumParty, 1 do
			if (UnitExists("party"..z) and Hx_CanHeal(UnitClass("party"..z))) then
				Healers = Healers + 1;
			end 
		end
		if (Healers == 1) then Hx_DPrint("Smart Party Stops it"); return nil; end
	end
	return (1);
end
function Hx_DemoConvertPercents(Spell_ID)
	local ms_string = HxSave[Class].SpellText[Spell_ID];
	ms_string = gsub( ms_string, "@pre", HxSave[Class].Prefix);
	ms_string = gsub( ms_string, "@post", HxSave[Class].Postfix);
	ms_string = gsub( ms_string, "@s", SpellNum[Class][Spell_ID]);
	ms_string = gsub( ms_string, "@t", "TargetsName");
	ms_string = gsub( ms_string, "@mana", "Mana");
	ms_string = gsub( ms_string, "@m", "SpellTime");
	ms_string = gsub( ms_string, "@r", "SpellRank");
	ms_string = gsub( ms_string, "@on_t", "on TargetsName");
	Hx_Print("New string ="..ms_string);
end
function Hx_ConvertPercents(Starg) --This converts the @commands from the format string to the information
	if (Starg) then Hx_DPrint("Hx_ConvertPercents: Starg="..Starg); end
	local S_Index = nil;
	for x=1,getn(SpellNum[Class]), 1 do
		if (SpellNum[Class][x] == SName) then
			S_Index = x;
			break;
		end
	end
	if (S_Index == nil) then
		Hx_DPrint("S_Index = nil!");
	else
		Hx_DPrint("S_Index = "..S_Index);
	end
	local ms = HxSave[Class].SpellText[S_Index];
	if (not ms) then
		return "nil";
	end
	if (Starg and Starg ~= "nil") then
		ms = gsub(ms,"@on_t",Hx_ONSTAR..Starg);
		ms = gsub(ms, "@t", Starg);
	else
		ms = gsub(ms, "@on_t","");
		ms = gsub(ms,"@t","");
	end
	player_mana_percent = floor(UnitMana("player")/UnitManaMax("player")*100+0.5)
	ms = gsub(ms, "@mana", "("..player_mana_percent.."%% Mana)");
	if (strfind(ms,"@m")) then
		ms = gsub(ms, "@m", STime);
	elseif (HxToggle[Class].Time==1) then
		if (strfind(ms,"@post")) then
			ms = gsub(ms,"@post",STime.." @post");
		else
			ms = ms.." "..STime;
		end
	end
	ms = gsub(ms, "@r", SRank);
	ms = gsub(ms, "@s", SName);
	ms = gsub(ms, "@pre", HxSave[Class].Prefix);
	ms = gsub(ms, "@post", HxSave[Class].Postfix);
	if (ms == "" or ms == nil) then return(HxSave[Class].Prefix..SName..Starg..STime..HxSave[Class].Postfix);end
	return (ms);
end
-------------------------------
--      Hooked Functions     --
-------------------------------
function Hx_SpellTargetUnit(sunit)
	if (sunit) then 
		Hx_DPrint("Hooked spell target unit = "..sunit);
		SavedTarget = UnitName(sunit);
		isSpellCast = true;
	else 
		Hx_DPrint("Hooked spell target unit but no unit!?!"); 
	end
end
function Hx_CastSpell(id, book) 
	local spell, rank = GetSpellName(id,book); 
	Hx_DPrint("CastSpell = "..spell.." Rank = "..rank); 
	SName = spell; STime = "";
	Hx_UnitFinder();
end
function Hx_CastSpellByName(spell)
	Hx_DPrint("CastSpellByName = "..spell);
end
function Hx_CameraOrSelectOrMoveStop(argu)
	-- trying to parse out name... (remember: corpse of ...)
	if (SpellIsTargeting() and GameTooltip:IsVisible() ) then
		local field = getglobal("GameTooltipTextLeft1");
		if( field and field:IsVisible() ) then
			local name = field:GetText();
			Hx_DPrint("Cameraorselectormovestop name= "..name);
			local index = string.find(name, "Corpse of ");
			if (index ~= nil) then
				-- casting on a corpse...
				name = string.sub(name, 11); -- remove "Corpse of " from name...
			end
			isSpellCast = true;
			SavedTarget= name;
		end
	end
end

------------------------------------------
--		OnLoad			--
------------------------------------------
function Hx_OnLoad()
	this:RegisterEvent("SPELLCAST_STOP"); 
	this:RegisterEvent("SPELLCAST_START");
	this:RegisterEvent("SPELLCAST_INTERRUPTED"); 
	this:RegisterEvent("SPELLCAST_FAILED");
	this:RegisterEvent("SPELLCAST_DELAYED");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED"); 
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	RegisterForSave( "SpellTog" );			--Spell tog = saved spells for the class
	RegisterForSave( "HxToggle" );			--HxToggle[Class] = saved
	RegisterForSave( "SpellNum" );			--SpellNum[number] = spellname
	RegisterForSave( "HxSave" );
end

--------------------------
-- Init Loads the addon --
--------------------------
function Hx_Init()
	if ( not Hx_Initialized ) then
		--Hooks
		Hx_Hook("CastSpell", "Hx_CastSpell", "before"); --Hx_Hook("CastSpellByName", "Hx_CastSpellByName", "before");
		Hx_Hook("UseAction", "Hx_UseAction", "before");
		Hx_Hook("CameraOrSelectOrMoveStop","Hx_CameraOrSelectOrMoveStop","before");
		Hx_Hook("SpellTargetUnit","Hx_SpellTargetUnit", "before");
		Class = UnitClass("player");
		--added myAddOns support
		if(myAddOnsList) then myAddOnsList.Hx = {name = Hx_HEADER_SHORT, description = Hx_HEADER_LONG, version = Hx_VERSION, category = MYADDONS_CATEGORY_COMBAT, frame = "healix", optionsframe = "HxOptions" }; end
		--init HxSave[Class] the save place for the prefix postfix and channel
		Hx_BuildTables();
		--register cosmos
		if (Cosmos_RegisterConfiguration) then
			if ( Cosmos_RegisterButton ) then 
				Cosmos_RegisterButton("Healix", Hx_COS_BUTTON_INFO, Hx_HEADER_LONG, "Interface\\AddOns\\Healix\\HealixIcon", HxOptionsDisplay);
			end
		else
			SlashCmdList["HxSLASH"] = Hx_Main_ChatCommandHandler;
			SLASH_HxSLASH1 = "/healix";
			SLASH_HxSLASH2 = "/hx";
		end
		if ( Cosmos_RegisterChatCommand ) then
			local Hx_MainCommands = {"/healix","/hx"};
			Cosmos_RegisterChatCommand ("Hx_MAIN_COMMANDS",Hx_MainCommands,	Hx_Main_ChatCommandHandler, Hx_HELP);
			-- Some Unique Group ID,The Commands,Function to Use,Help String
		end
		Hx_Initialized = 1;
	end
end
function Hx_BuildTables()
	--init HxSave (This stores Healix's non boolean Options.)
	if (not HxSave) then HxSave = {}; end
	if (not HxSave[Class]) then HxSave[Class] = {}; end
	if (not HxSave[Class].Prefix) then HxSave[Class].Prefix = Hx_DEFAULT_PREFIX; end
	if (not HxSave[Class].Postfix) then HxSave[Class].Postfix = Hx_DEFAULT_POSTFIX ; end
	if (not HxSave[Class].Channel) then HxSave[Class].Channel = ""; end
	if (not HxSave[Class].Interrupt) then HxSave[Class].Interrupt = Hx_SPELL_INTERRUPTED; end
	if (not HxSave[Class].SpellText) then HxSave[Class].SpellText = {}; end
	if (not HxSave[Class].Debug) then HxSave[Class].Debug = nil; end
	--init HxToggle (This stores Healix's boolean options)
	if (not HxToggle) then HxToggle = {}; end
	if (not HxToggle[Class]) then HxToggle[Class] = {}; end
	for index, bool in HxTog do
		if (not HxToggle[Class][index]) then HxToggle[Class][index] = bool; end
	end
	--init spellnum (This stores the spells name based upon our number system)
	if (not SpellNum) then SpellNum = {}; end
	if (not SpellNum[Class]) then SpellNum[Class] = {};	end
	for x = 1, 20, 1 do							--this number sets how big spellnum is
		if (not SpellNum[Class][x]) then SpellNum[Class][x] = NIL_SPELL; end --sets spells that arent saved to nil
	end
	--init spelltog (this stores if the spell should be displayed or not.)
	if (not SpellTog) then SpellTog = {}; end
	if (not SpellTog[Class]) then SpellTog[Class] = {}; end
	if (not Hx) then Hx = {}; end
	if (not Hx.Class) then Hx.Class = { Shaman = {}; Druid = {}; Priest = {}; Paladin = {}; Mage = {}; Hunter = {}; Rogue = {}; Warlock = {}; Warrior = {};}; end
	for index, Spell in Hx.Class[Class] do
		Hx_DPrint("Hx Init : Registering("..Spell..")"); 
		SpellNum[Class][index] = Spell;
		if (not SpellTog[Class][Spell]) then SpellTog[Class][Spell] = 1; end
	end
	--Init Spelltext ( Which is the format string for how the spell is displayed )
	for x=1, 20, 1 do
		getglobal("SpellTextButton_"..x):SetText(SpellNum[Class][x]);
		if (SpellNum[Class][x] == NIL_SPELL) then
			getglobal("SpellTextButton_"..x):Hide();
		end
		local temp_spell = SpellNum[Class][x];
		if (not HxSave[Class].SpellText[x] or HxSave[Class].SpellText[x] == "" ) then	
			if (Hx.NoTarg[temp_spell]) then
				HxSave[Class].SpellText[x] = Hx_DEFAULT_SPELLTEXT_NOTARGET; --if the spell needs no target
			else			
				HxSave[Class].SpellText[x] = Hx_DEFAULT_SPELLTEXT; --if the spell is innatly targeting.
			end
		end
		if (HxSave[Class].SpellText[x] == Hx_DEFAULT_SPELLTEXT and Hx.NoTarg[temp_spell]) then --fix for previous healix's with target
			HxSave[Class].SpellText[x] = Hx_DEFAULT_SPELLTEXT_NOTARGET;
		end
	end
end

-- Resets all saves
function Hx_Reset()
	SpellTog = nil;
	HxToggle = nil;
	SpellNum = nil;
	HxSave = nil;
	Hx_BuildTables();
end

-- Add Spell --
function Hx_AddSpell(Spell)
	if (SpellTog[Class][Spell]) then Hx_Print("That spell is already in Hx!"); return; end
	if (Spell == nil) then Hx_Print("Nil was passed to Hx_AddSpell!"); return; end
	local index;	--index of first nil in SpellNum
	for i=1, 20, 1 do
		if (strfind(SpellNum[Class][i],NIL_SPELL)) then index = i; break; end
	end
	--protect going over our number of checkboxes
	if (index>getn(SpellNum[Class])) then Hx_Print("Too Many spells"); return; end
	--Add the spell
	SpellTog[Class][Spell] = 1; RegisterForSave("SpellTog");
	SpellNum[Class][index] = Spell;
	Hx_Print("Spell added! Spell = "..Spell.." at index="..index);
	--these access the gui
	local check = getglobal("HxSpell_"..index);
	check:Enable(); check:Show(); check:SetChecked(1);
	getglobal("SpellTextButton_"..index):SetText(Spell);
	getglobal("SpellTextButton_"..index):Show();
	local labelString = getglobal(check:GetName().."Text");
	labelString:SetText(Spell);
	ShowUIPanel(HxSpellOptions);
end
-- Remove Spell --
function Hx_RemoveSpell()
	SpellNum = nil; SpellTog = nil;
	Hx_BuildTables();
	ShowUIPanel(HxSpellOptions);	--pull up the new spell menu (also refreshes it)
	Hx_Print("Spells removed!");
end

-- Check if a unit can heal
function Hx_CanHeal(class) --checks if a unit is a healer
	if ( (class=="Shaman") or (class=="Paladin") or (class=="Druid") or (class=="Priest") ) then return true; end
	return nil;
end -- END: function Hx_CanHeal(string class) :: returns bool

--------------------------------------------------
--			Chat			--
--------------------------------------------------
function Hx_Main_ChatCommandHandler(msg) --Handles basic slash commands.
	if (not(msg)) then return; end
	-- <<Extract Next Param>> --
	local Command = msg; local Params = msg; local index = strfind(Command, " "); --the index is the position of the first space, nul if there isnt a space
	if ( index ) then Command = strsub(Command, 1, index-1); Params = strsub(Params, index+1); else	Params = ""; end 
	if ((Command) and (strlen(Command) > 0)) then Command = string.lower(Command); else Command = ""; end 
	Tog2 = function (Option) --toggles an option
		if HxToggle[Class][Option] == 1 then HxToggle[Class][Option] = 0; else HxToggle[Class][Option] = 1; end 
	end
	-- <<chat commands>> --
	if strfind(Command, "toggle") then Tog2("Main");
	elseif strfind(Command, "menu") then HxOptionsDisplay();
	elseif strfind(Command, "spell") then ShowUIPanel(HxSpellOptions);
	elseif strfind(Command, "add") then if (Params) then Hx_AddSpell(Params); end
	elseif strfind(Command, "party") then Tog2("Party");
	elseif strfind(Command, "nonparty") then Tog2("NonParty");
	elseif strfind(Command, "time") then Tog2("Time");
	elseif strfind(Command, "emoteself") then Tog2("EmoteSelf");
	elseif strfind(Command, "smartparty") then Tog2("SmartParty");
	elseif strfind(Command, "prefix") then Tog2("Prefix");
	elseif strfind(Command, "debug") then 
		if (HxSave[Class].Debug) then HxSave[Class].Debug = nil; Hx_Print("Debug OFF!"); else HxSave[Class].Debug = true; Hx_Print("DEBUG ON!"); end
	elseif strfind(Command, "macro") then Hx_Macro_ChatCommandHandler(Params);
	elseif strfind(Command, "reset") then Hx_Reset();
	else Hx_Print(Hx_HELP);
	end
end --function Hx_Main_ChatCommandHandler(string msg) :: void

function Hx_Macro_ChatCommandHandler(msg) --this is for macro users you can type something like /hx macro Healing Wave or /hx_macro Rejuvination, 1
	local indix = nil; local SpTime = "0";
	msg = gsub(msg, " ,", ","); --if they used spaces
	msg = gsub(msg, ", ", ","); --"" ""
	if (strfind(msg, ",")) then
		indix = strfind(msg,",");
		SpTime = strsub(msg, indix+1);
		SpName = strsub(msg, 1, indix-1);
	else
		SpName = msg;
	end
	Hx_UnitFinder(SpName,SpTime);
end

-- Add something to a table
function Hx_Push (table,val)
	if(not table or not table.n) then return nil; end	--if table or table's number of elements = nil return nil;
	table.n = table.n+1;					--Add one to the tables elements
	table[table.n] = val;					--Add the new val to the table
end

--Remove white spaces, ":", and "'" for spells to use them as vars
function Hx_RemoveChar(str)
	gsub(str, " ", ""); gsub(str, ":", ""); gsub(str, "'", "");
	return str;
end

--------------
--Use action--
--------------
function Hx_UseAction(id, number, onSelf)
	if (HxToggle[Class].Main == 1) then				--if the main toggle is triped
		Hx_DPrint("Use action triped!", 1, 0, 1);
		Hx_Tooltip:SetAction(id);				--set our tooltip equal to the spell being cast
		local tip = Hx_TooltipScan("Hx_Tooltip");	--sets tip equal to the parts of the tooltip
		if (tip and tip[1] and tip[1]["left"]) then		--Check for nil values in the spell name
			SName = tip[1]["left"];		--Set SName(Global) from the tooltip 
			STime = "nil";			--Set STime(Global) = "nil" so we dont have a non string
			SMana = "nil"; SRank = "nil";
			if (tip[1]["right"] and strfind(tip[1]["right"],"Rank")) then SRank = tip[1]["right"]; end
			if (tip[2] and tip[2]["left"]) then
				local temp = tip[2]["left"];
				if (strfind(temp, "mana")) then
					SMana = temp;
				elseif (temp == "Instant" or temp == "Instant cast" or strfind(temp,"sec cast")) then
					STime = temp;
				end
			end
			if (STime == "nil" and tip[3] and tip[3]["left"]) then STime = tip[3]["left"]; end
			--check if there is range on the spell otherwise it wont take a target.
			if (tip[2] and tip[2]["right"] and strfind(tip[2]["right"],"range")) then	--range probley need to be localized
				Hx.NoTarget[SName] = nil;
			elseif (tip[2] and tip[2]["left"] and strfind(tip[2]["left"],"range")) then
				Hx.NoTarget[SName] = nil;
			else
				Hx.NoTarget[SName] = 1; Hx_DPrint("Use Action: No target ");
			end
			if (STime and SName) then Hx_DPrint("UseAction: Spell= "..SName.." Spelltime= "..STime); end
			if (IsActionInRange(id) == 0) then Hx_DPrint("Actions not in range!"); return; end
			if (IsActionInRange(id) == nil) then Hx_DPrint("Action is not a ranged action"); end
			Hx_DPrint("Number = "..number.." Id= "..id);
			local isusable, notenoughmana = IsUsableAction(id);
			if (notenoughmana == 1) then Hx_DPrint("Not enough mana"); end
			if (not isusable) then Hx_DPrint("Is not useable."); return; end
			Hx_UnitFinder();
		end
	end
end

function Hx_UnitFinder(Sn, St)
	if (not Sn) then Sn=SName; else SName=Sn; end
	if (not St) then St=STime; elseif (St == "1") then St = "Instant"; else St="nil"; end
	isSpellCast = 1; InstaCastTarget = nil;
	if (Hx.NoTarget[Sn]) then IsNoTargetCast = 1; return; end
	--this handles anyspell when the player has a target and the spell already target someone
	if (UnitExists("target") and not SpellIsTargeting()) then
		--casting on a friend
		if (UnitIsFriend("target","player")) then	
			Hx_DPrint("Instacast fired friend");
			InstaCastTarget = UnitName("target");
		else
			Hx_DPrint("Instacast fired nonfriend");
			if (Hx.SelfCast[Sn]) then
				InstaCastTarget = UnitName("player");--A healing spell is being cast on a enemy? The player must have selfCast
			else
				InstaCastTarget = UnitName("target");--A non heal must be on that target then
			end
		end
	else
		--instant casts dont need to check for when the spell casts
		if (St == "Instant cast" or St == "Instant" and not SpellIsTargeting()) then
			if (Hx.SelfCast[Sn]) then	--the spell can be cast on the player
				InstaCastTarget = nil;
			end
		end
	end
end

function Hx_UnitLevel(Type)
	if (not Type) then return; end
	if (Type == "nil") then
		TargetLevel = "";
	elseif (UnitLevel(Type) > 0) then
		TargetLevel = UnitLevel(Type);
	else
		TargetLevel = "?Lvl";
	end
end

-----------------------------------------------------
-- Print to chatscreen (Only the player can see it)--
-----------------------------------------------------
--Regular printing
function Hx_Print(msg,HXr,HXy,HXb) 
	if (not HXr) then 
		local HXr=1; local HXy=2; local HXb=0; 
	end
	if (msg) then DEFAULT_CHAT_FRAME:AddMessage(msg, HXr, HXy, HXb); end 
end
--Debug printing
function Hx_DPrint(msg,HXr,HXy,HXb)
	if (not HXr) then 
		local HXr=1; local HXy=0; local HXb=0; 
	end
	if (msg and HxSave and HxSave[Class] and HxSave[Class].Debug) then DEFAULT_CHAT_FRAME:AddMessage(msg, HXr, HXy, HXb); end 
end

----------------------------------------
-- Tool Tip Scanning (taken from sea) --
----------------------------------------
function Hx_TooltipScan( tooltipBase )
	if ( tooltipBase == nil ) then tooltipBase = "GameTooltip"; end
	local strings = {};
	for idx = 1, 10 do
		local textLeft = nil; local textRight = nil;
		ttext = getglobal(tooltipBase.."TextLeft"..idx);
		if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil) then textLeft = ttext:GetText(); end
		ttext = getglobal(tooltipBase.."TextRight"..idx);
		if(ttext and ttext:IsVisible() and ttext:GetText() ~= nil) then	textRight = ttext:GetText(); end
		if (textLeft or textRight) then
			strings[idx] = {}; strings[idx].left = textLeft; strings[idx].right = textRight;
		end
	end
	return strings;
end;

function InitTog(tg,value)	--If a toggle is nil set its inital value
	if (tg ~= nil) then	--the toggle already has a value we dont need to set it
		return (tg);	
	elseif ((value == nil) or (tg == nil and value == 1)) then --default return a 1 --if the toggel doesnt have a value and we were passed a 1
		return 1;
	end
	return 0; --we must have been passed a 0
end --END InitTog(bool tog, bool val) :: returns bool

--------------
--From RA--
---------------
Hx_ClassSpells = { };

function Hx_GetClassSpells()
	Hx_ClassSpells = { };
	for i = 1, GetNumSpellTabs(), 1 do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
		for y = 1, numSpells, 1 do
			local spellName, rankName = GetSpellName(offset+y, BOOKTYPE_SPELL);
			local useless, useless, rank = string.find(rankName, "(%d+)");
			if ( not Hx_ClassSpells[spellName] or Hx_ClassSpells[spellName]["rank"] < tonumber(rank) ) then
				Hx_ClassSpells[spellName] = { ["rank"] = tonumber(rank), ["tab"] = i, ["spell"] = y+offset };
			end
		end
	end
end

function Hx_ClassSpells_OnEvent(event)
	if ( event == "SPELLS_CHANGED" ) then
		Hx_GetClassSpells();
	end
end

------------------------------------
-- Hook Function : Taken from Sea --
------------------------------------
Hx_Hook = function (orig,new,type)
	if (Sea) then
		if (Sea.util) then
			if (Sea.util.hook) then Sea.util.hook(orig,new,type); return; end
		end
	end
	if(not type) then type = "before"; end
	if(not Hx_Hooks) then Hx_Hooks = {}; end
	if(not Hx_Hooks[orig]) then
		Hx_Hooks[orig] = {}; Hx_Hooks[orig].before = {}; Hx_Hooks[orig].before.n = 0; Hx_Hooks[orig].after = {}; Hx_Hooks[orig].after.n = 0; Hx_Hooks[orig].hide = {}; Hx_Hooks[orig].hide.n = 0; Hx_Hooks[orig].replace = {}; Hx_Hooks[orig].replace.n = 0; Hx_Hooks[orig].orig = getglobal(orig);
	else
		for key,value in Hx_Hooks[orig][type] do if(value == getglobal(new)) then return; end end
	end
	Hx_Push(Hx_Hooks[orig][type],getglobal(new)); setglobal(orig,function(...) Hx_hookHandler(orig,arg); end);
end
Hx_hookHandler = function (name,arg)
	local called = false; local continue = true; local retval;
	for key,value in Hx_Hooks[name].hide do
		if(type(value) == "function") then if(not value(unpack(arg))) then continue = false; end called = true; end
	end
	if(not continue) then return; end
	for key,value in Hx_Hooks[name].before do
		if(type(value) == "function") then value(unpack(arg)); called = true; end
	end
	continue = false;
	local replacedFunction = false;
	for key,value in Hx_Hooks[name].replace do
		if(type(value) == "function") then
			replacedFunction = true; if(value(unpack(arg))) then continue = true; end called = true;
		end
	end
	if(continue or (not replacedFunction)) then retval = Hx_Hooks[name].orig(unpack(arg)); end
	for key,value in Hx_Hooks[name].after do
		if(type(value) == "function") then value(unpack(arg)); called = true;end
	end
	if(not called) then setglobal(name,Hx_Hooks[name].orig); Hx_Hooks[name] = nil; end
	return retval;
end