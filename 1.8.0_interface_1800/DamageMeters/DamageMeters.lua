--[[
DamageMeters.lua
See the Readme for author and permissions.


TODO:
 FEATURES
- Change commands to /dm command args
- Track honor (estimated)
- TEst party and friendly spell casting. 
- Finish "full" feature.
- time monitoring
- reject "unknown entity"s?
- crit count syncing
- Make border hidable.

- book of the dead
- mapradius

 KNOWN BUGS

]]--

-------------------------------------------------------------------------------

-- CONSTANTS ---
DamageMeters_BARCOUNT_MAX = 40;	-- Note this is also the table max size atm.
DamageMeters_TABLE_MAX = 50;
DamageMeters_BARWIDTH = 119;
DamageMeters_BARHEIGHT = 12;
DamageMeters_PULSE_TIME = 1.00;
DamageMeters_PULSE_REFRESH_TIME = 0.05;
DamageMeters_REFRESH_TIME = 1/3;
DamageMeters_VERSION = 2300;
DamageMeters_VERSIONSTRING = "2.3.0";
DamageMeters_SYNCMSGCOLOR = { r = 0.75, g = 0.75, b = 1.0 };

DMI_DAMAGE = 1;
DMI_HEALING = 2;
DMI_DAMAGED = 3;
DMI_HEALED = 4;
DMI_MAX = 4;

DM_DOT = 0;
DM_HIT = 1;
DM_CRIT = 2;

DamageMeters_Sort_DECREASING = 1;
DamageMeters_Sort_INCREASING = 2;
DamageMeters_Sort_ALPHABETICAL = 3;
DamageMeters_Sort_MAX = 3;

DamageMeters_Relation_SELF = 1;
DamageMeters_Relation_PET = 2;
DamageMeters_Relation_PARTY = 3;
DamageMeters_Relation_FRIENDLY = 4;
DamageMeters_Relation_MAX = 4;

DamageMeters_ReportQuantity_Total = -1;
DamageMeters_ReportQuantity_Leaders = -2;

DamageMeters_Quantity_DAMAGE = 1;
DamageMeters_Quantity_HEALING = 2;
DamageMeters_Quantity_DAMAGED = 3;
DamageMeters_Quantity_HEALINGRECEIVED = 4;
DamageMeters_Quantity_TIME = 5;
DamageMeters_Quantity_DPS = 6;
DamageMeters_Quantity_MAX = 6;

DamageMeters_Text_RANK = 1;
DamageMeters_Text_NAME = 2;
DamageMeters_Text_TOTALPERCENTAGE = 3;
DamageMeters_Text_LEADERPERCENTAGE = 4;
DamageMeters_Text_VALUE = 5;
DamageMeters_Text_MAX = 5;

DamageMeters_colorScheme_RELATIONSHIP = 1;
DamageMeters_colorScheme_CLASS = 2;
DamageMeters_colorScheme_MAX = 2;

DMSYNC_PREFIX = "SYNC_3_";
DamageMeters_SYNCREQUEST = "REQ_SYNC_3_";
DamageMeters_SYNCSTART = "SYNC_START_3_";
DamageMeters_SYNCCLEARREQUEST = "REQ_CLEAR_3_";
DamageMeters_SYNCMSG = "SYNC_MSG_3_";
DamageMeters_MINSYNCCOOLDOWN = 1.0;

DamageMeters_quantityColorDefault = {};
DamageMeters_quantityColorDefault[1] = {1.0, 0.0, 0.0, 0.8};
DamageMeters_quantityColorDefault[2] = {0.0, 1.0, 0.0, 0.8};
DamageMeters_quantityColorDefault[3] = {1.0, 0.5, 0.0, 0.8};
DamageMeters_quantityColorDefault[4] = {0.0, 0.7, 0.3, 0.8};
DamageMeters_quantityColorDefault[5] = {0.0, 0.0, 1.0, 0.8};
DamageMeters_quantityColorDefault[6] = {0.4, 0.0, 0.8, 0.8};

DamageMeters_TEXTSTATEDURATION = 6.0;
DamageMeters_BARFADEINMINTIME = 0.5;
DamageMeters_BARFADEINTIME = 0.01;
DamageMeters_BARCHARTIME = 0.02;
DamageMeters_QUANTITYSHOWDURATION = 6.0;

-- GLOBALS ---
DamageMeters_bars = {};
DamageMeters_text = {};
DamageMeters_table = {}; -- player, hitCount, critCount, lastTime, relationship, class, damageThisCombat
DamageMeters_savedTable = {};
DamageMeters_bannedTable = {};
DamageMeters_tooltipBarIndex = nil;
DamageMeters_frameNeedsToBeGenerated = true;
DamageMeters_clickedBarIndex = nil;
DamageMeters_lastSyncTime = 0;
DamageMeters_listLocked = false;
DamageMeters_startCombatOnNextValue = true;
DamageMeters_inCombat = false;
DamageMeters_combatStartTime = 0;
DamageMeters_combatEndTime = 0;
DamageMeters_reportBuffer = "";
DamageMeters_rankTable = {};
DamageMeters_fullTable = {};
DamageMeters_textStateStartTime = 0;
DamageMeters_currentQuantStartTime = -1;
DamageMeters_firstGeneration = true;

-- SETTINGS ---
DamageMeters_barCount = 10;
DamageMeters_quantity = DamageMeters_Quantity_DAMAGE;
DamageMeters_sort = DamageMeters_Sort_DECREASING;
DamageMeters_textOptions = {false, true, false, false};
DamageMeters_colorScheme = DamageMeters_colorScheme_CLASS;
DamageMeters_visibleOnlyInParty = false;
DamageMeters_autoCountLimit = 0;
DamageMeters_syncChannel = "";
DamageMeters_enableDebugPrint = false;	-- Debug: Enables display of various debug messages.
DamageMeters_loadedDataVersion = 0;
DamageMeters_paused = false;
DamageMeters_positionLocked = false;
DamageMeters_isVisible = true;
DamageMeters_groupMembersOnly = true;
DamageMeters_addPetToPlayer = false;
DamageMeters_showParse = false;	-- Debug: Shows what messages were parsed.
DamageMeters_showUnparsed = false; -- Debug: Shows which weren't parsed.
DamageMeters_quantityColor = {};
DamageMeters_resetWhenCombatStarts = false;
DamageMeters_haveContributors = false; -- For some reason this list can be non-empty but getn returns zero: thus this variable was added.
DamageMeters_contributorList = {}; 
DamageMeters_takeFullData = false;
DamageMeters_textState = 0;
DamageMeters_cycleVisibleQuantity = false;
DamageMeters_accumulateToMemory = false;
DamageMeters_showTotal = false;
DamageMeters_showMaxBars = false;
DamageMeters_savedBarCount = 1;
DamageMeters_resizeLeft = true;
DamageMeters_resizeUp = true;

-- DEBUG --
DamageMeters_msgCounts = {};
-- When true, allows you to parse your own sync messages.
DamageMeters_syncSelf = false;
-- When true, shows explicitly each value change.
DamageMeters_showValueChanges = false;
-- When true, each incoming message becomes instead a 1 point of damage message 
-- caused by a player by the name of the message.
DamageMeters_msgWatchMode = false;

-------------------------------------------------------------------------------

function DMPrint(msg, color, bSecondChatWindow)
	local r = 0.50;
	local g = 0.50;
	local b = 1.00;

	if (color) then
		r = color.r;
		g = color.g;
		b = color.b;
	end

	local frame = DEFAULT_CHAT_FRAME;
	if (bSecondChatWindow) then
		frame = ChatFrame2;
	end

	if (frame) then
		frame:AddMessage(msg,r,g,b);
	end
end

-- stolen from sky (assertEquals)
function DMASSERTEQUALS(expected, actual)
	if  actual ~= expected  then
		local function wrapValue( v )
			if type(v) == 'string' then return "'"..v.."'" end
			return tostring(v)
		end
		errorMsg = "expected: "..wrapValue(expected)..", actual: "..wrapValue(actual)
		DMPrintD( errorMsg, 2 )
	end
end
function DMASSERTNOTEQUALS(expected, actual)
	if  actual == expected  then
		local function wrapValue( v )
			if type(v) == 'string' then return "'"..v.."'" end
			return tostring(v)
		end
		errorMsg = "not expected: "..wrapValue(expected)..", actual: "..wrapValue(actual)
		DMPrintD( errorMsg, 2 )
	end
end

function DMPrintD(msg)
	if (DamageMeters_enableDebugPrint) then
		--SendChatMessage(msg, "CHANNEL", nil, GetChannelName("dmdebug"));
		DMPrint(msg);
	end
end

function DMVerbose(msg)
	--DMPrint(msg);
end

-------------------------------------------------------------------------------

function DamageMetersFrame_OnLoad()
	-- Initialize color table.
	DamageMeters_SetDefaultColors();

	local name = this:GetName();
	local i;
	for i = 1,DamageMeters_BARCOUNT_MAX do
		DamageMeters_bars[i] = getglobal(name.."Bar"..i);
		DamageMeters_bars[i]:SetID(i);
		DamageMeters_bars[i]:Hide();
		DamageMeters_text[i] = getglobal(name.."Text"..i);
		SetTextStatusBarText(DamageMeters_bars[i], DamageMeters_text[i]);
		-- Force text on always.
		ShowTextStatusBarText(DamageMeters_bars[i]);
	end

	-- Apparently this only works for buttons?
	--this:RegisterForClicks("RightButton");

	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PARTY_MEMBERS_CHANGED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");

	-- Messages to measure how much damage is dealt.
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");	-- Melee you do on things.
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");		-- Melee your pets do.
	this:RegisterEvent("CHAT_MSG_COMBAT_PARTY_HITS");	-- Melee done by part.
	this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS");	-- Melee done by friendlies.
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");	-- Your spells that damage other things.
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE");	-- Party member's spell hits.
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE"); -- Spells other people cast on things.
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"); -- Blah suffers # Arcane damage from #'s/your Spell.  Works on self, party, friendly.
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");		-- Thorns on self.
	this:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS");	-- Thorns on others.

	-- Messages to measure healing done and received.
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");

	-- Messages to measure damage taken.
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE");
	-- The HOSTILEPLAYER ones are for dueling and pvp.
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS");
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");

	-- For sync stuff.
	this:RegisterEvent("CHAT_MSG_CHANNEL");

	-- Console commands.
	SlashCmdList["DAMAGEMETERSHELP"] = DamageMeters_Help;
	SLASH_DAMAGEMETERSHELP1 = "/dmhelp";
	SlashCmdList["DAMAGEMETERSSHOW"] = DamageMeters_ToggleShow;
	SLASH_DAMAGEMETERSSHOW1 = "/dmshow";
	SlashCmdList["DAMAGEMETERSHIDE"] = DamageMeters_Hide;
	SLASH_DAMAGEMETERSHIDE1 = "/dmhide";
	SlashCmdList["DAMAGEMETERSCLEAR"] = DamageMeters_Clear;
	SLASH_DAMAGEMETERSCLEAR1 = "/dmclear";
	SlashCmdList["DAMAGEMETERSREPORT"] = DamageMeters_Report;
	SLASH_DAMAGEMETERSREPORT1 = "/dmreport";
	SlashCmdList["DAMAGEMETERSSORT"] = DamageMeters_SetSort;
	SLASH_DAMAGEMETERSSORT1 = "/dmsort";
	SlashCmdList["DAMAGEMETERSCOUNT"] = DamageMeters_SetCount;
	SLASH_DAMAGEMETERSCOUNT1 = "/dmcount";
	SlashCmdList["DAMAGEMETERSSAVE"] = DamageMeters_Save;
	SLASH_DAMAGEMETERSSAVE1 = "/dmsave";
	SlashCmdList["DAMAGEMETERSRESTORE"] = DamageMeters_Restore;
	SLASH_DAMAGEMETERSRESTORE1 = "/dmrestore";
	SlashCmdList["DAMAGEMETERSMERGE"] = DamageMeters_Merge;
	SLASH_DAMAGEMETERSMERGE1 = "/dmmerge";
	SlashCmdList["DAMAGEMETERSSWAP"] = DamageMeters_Swap;
	SLASH_DAMAGEMETERSSWAP1 = "/dmswap";
	SlashCmdList["DAMAGEMETERSMEMCLEAR"] = DamageMeters_MemClear;
	SLASH_DAMAGEMETERSMEMCLEAR1 = "/dmmemclear";
	SlashCmdList["DAMAGEMETERSRESETPOS"] = DamageMeters_ResetPos;
	SLASH_DAMAGEMETERSRESETPOS1 = "/dmresetpos";
	SlashCmdList["DAMAGEMETERSSHOWTEXT"] = DamageMeters_SetTextOptions;
	SLASH_DAMAGEMETERSSHOWTEXT1 = "/dmtext";
	SlashCmdList["DAMAGEMETERSCOLORSCHEME"] = DamageMeters_SetColorScheme;
	SLASH_DAMAGEMETERSCOLORSCHEME1 = "/dmcolor";
	SlashCmdList["DAMAGEMETERSQUANTITY"] = DamageMeters_SetQuantity;
	SLASH_DAMAGEMETERSQUANTITY1 = "/dmquant";
	SlashCmdList["DAMAGEMETERSVISINPARTY"] = DamageMeters_SetVisibleInParty;
	SLASH_DAMAGEMETERSVISINPARTY1 = "/dmvisinparty";
	SlashCmdList["DAMAGEMETERSAUTOCOUNT"] = DamageMeters_SetAutoCount;
	SLASH_DAMAGEMETERSAUTOCOUNT1 = "/dmautocount";
	SlashCmdList["DAMAGEMETERSLISTBANNED"] = DamageMeters_ListBanned;
	SLASH_DAMAGEMETERSLISTBANNED1 = "/dmlistbanned";
	SlashCmdList["DAMAGEMETERSCLEARBANNED"] = DamageMeters_ClearBanned;
	SLASH_DAMAGEMETERSCLEARBANNED1 = "/dmclearbanned";
	SlashCmdList["DAMAGEMETERSSYNC"] = DamageMeters_Sync;
	SLASH_DAMAGEMETERSSYNC1 = "/dmsync";
	SlashCmdList["DAMAGEMETERSSYNCCHAN"] = DamageMeters_SyncChan;
	SLASH_DAMAGEMETERSSYNCCHAN1 = "/dmsyncchan";
	SlashCmdList["DAMAGEMETERSSYNCSEND"] = DamageMeters_SyncReport;
	SLASH_DAMAGEMETERSSYNCSEND1 = "/dmsyncsend";
	SlashCmdList["DAMAGEMETERSSYNCREQUEST"] = DamageMeters_SyncRequest;
	SLASH_DAMAGEMETERSSYNCREQUEST1 = "/dmsyncrequest";
	SlashCmdList["DAMAGEMETERSSYNCCLEAR"] = DamageMeters_SyncClear;
	SLASH_DAMAGEMETERSSYNCCLEAR1 = "/dmsyncclear";
	SlashCmdList["DAMAGEMETERSSYNCMSG"] = DamageMeters_SendSyncMsg;
	SLASH_DAMAGEMETERSSYNCMSG1 = "/dmsyncmsg";
	SLASH_DAMAGEMETERSSYNCMSG2 = "/dmm";
	SlashCmdList["DAMAGEMETERSPOPULATE"] = DamageMeters_Populate;
	SLASH_DAMAGEMETERSPOPULATE1 = "/dmpop";
	SlashCmdList["DAMAGEMETERSTOGGLELOCK"] = DamageMeters_ToggleLock;
	SLASH_DAMAGEMETERSTOGGLELOCK1 = "/dmlock";
	SlashCmdList["DAMAGEMETERSTOGGLEPAUSE"] = DamageMeters_TogglePause;
	SLASH_DAMAGEMETERSTOGGLEPAUSE1 = "/dmpause";
	SlashCmdList["DAMAGEMETERSTOGGLELOCKPOS"] = DamageMeters_ToggleLockPos;
	SLASH_DAMAGEMETERSTOGGLELOCKPOS1 = "/dmlockpos";
	SlashCmdList["DAMAGEMETERSTOGGLEGROUPONLY"] = DamageMeters_ToggleGroupMembersOnly;
	SLASH_DAMAGEMETERSTOGGLEGROUPONLY1 = "/dmgrouponly";
	SlashCmdList["DAMAGEMETERSTOGGLEADDPETTOPLAYER"] = DamageMeters_ToggleAddPetToPlayer;
	SLASH_DAMAGEMETERSTOGGLEADDPETTOPLAYER1 = "/dmaddpettoplayer";
	SlashCmdList["DAMAGEMETERSTOGGLERESETWHENCOMBATSTARTS"] = DamageMeters_ToggleResetWhenCombatStarts;
	SLASH_DAMAGEMETERSTOGGLERESETWHENCOMBATSTARTS1 = "/dmresetoncombat";
	SlashCmdList["DAMAGEMETERSVERSION"] = DamageMeters_ShowVersion;
	SLASH_DAMAGEMETERSVERSION1 = "/dmversion";
	SlashCmdList["DAMAGEMETERSTOGGLETOTAL"] = DamageMeters_ToggleTotal;
	SLASH_DAMAGEMETERSTOGGLETOTAL1 = "/dmtotal";
	SlashCmdList["DAMAGEMETERSTOGGLESHOWMAX"] = DamageMeters_ToggleMaxBars;
	SLASH_DAMAGEMETERSTOGGLESHOWMAX1 = "/dmshowmax";

	-- Commands for testing.
	-- ["reset"] = "/dmreset - (For Testing) Forces a re-layout of the visual elements.",
	SlashCmdList["DAMAGEMETERSRESET"] = DamageMeters_Reset;
	SLASH_DAMAGEMETERSRESET1 = "/dmreset";
	-- ["test"] = "/dmtest [#] - (For Testing) Adds # test entries to the list.  If no number specified, adds one entry for each visible bar.",
	SlashCmdList["DAMAGEMETERSTEST"] = DamageMeters_Test;
	SLASH_DAMAGEMETERSTEST1 = "/dmtest";
	-- ["add"] = "/dmadd name - (For Testing) Simulates player 'name' doing 1 damage.",
	SlashCmdList["DAMAGEMETERSADD"] = DamageMeters_Add;
	SLASH_DAMAGEMETERSADD1 = "/dmadd";
	-- ["dumptable"] = "/dmdumptable - (For Testing) Dumps the entire internal data table."
	SlashCmdList["DAMAGEMETERSDUMPTABLE"] = DamageMeters_DumpTable;
	SLASH_DAMAGEMETERSDUMPTABLE1 = "/dmdumptable";
	SlashCmdList["DAMAGEMETERSDEBUGPRINT"] = DM_ToggleDMPrintD;
	SLASH_DAMAGEMETERSDEBUGPRINT1 = "/dmdebug";
	SlashCmdList["DAMAGEMETERSDUMPMSG"] = DM_DumpMsg;
	SLASH_DAMAGEMETERSDUMPMSG1 = "/dmdumpmsg";

	-- Saved variables
	RegisterForSave("DamageMeters_barCount");
	RegisterForSave("DamageMeters_quantity");
	RegisterForSave("DamageMeters_sort");
	RegisterForSave("DamageMeters_textOptions");
	RegisterForSave("DamageMeters_colorScheme");
	RegisterForSave("DamageMeters_visibleOnlyInParty");
	RegisterForSave("DamageMeters_autoCountLimit");
	RegisterForSave("DamageMeters_syncChannel");
	RegisterForSave("DamageMeters_enableDebugPrint");
	RegisterForSave("DamageMeters_loadedDataVersion");
	RegisterForSave("DamageMeters_paused");
	RegisterForSave("DamageMeters_positionLocked");
	RegisterForSave("DamageMeters_isVisible");
	RegisterForSave("DamageMeters_groupMembersOnly");
	RegisterForSave("DamageMeters_addPetToPlayer");
	RegisterForSave("DamageMeters_showParse");
	RegisterForSave("DamageMeters_showUnparsed");
	RegisterForSave("DamageMeters_quantityColor");
	RegisterForSave("DamageMeters_resetWhenCombatStarts");
	RegisterForSave("DamageMeters_contributorList");
	RegisterForSave("DamageMeters_takeFullData");
	RegisterForSave("DamageMeters_textState");
	RegisterForSave("DamageMeters_cycleVisibleQuantity");
	RegisterForSave("DamageMeters_accumulateToMemory");
	RegisterForSave("DamageMeters_showTotal");
	RegisterForSave("DamageMeters_showMaxBars");
	RegisterForSave("DamageMeters_savedBarCount");
	RegisterForSave("DamageMeters_resizeLeft");
	RegisterForSave("DamageMeters_resizeUp");
	RegisterForSave("DamageMeters_msgWatchMode");

	-- Might as well save both tables: you should see how much other mods save!
	RegisterForSave("DamageMeters_table");
	RegisterForSave("DamageMeters_savedTable");

	-- Tell the frame to rebuild itself.
	DamageMeters_UpdateVisibility();
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_UpdateVisibility()
	local inParty = false;
	local p = GetNumPartyMembers();
	local r = GetNumRaidMembers();

	if ((p + r) > 0) then
		inParty = true;
	end

	if (DamageMeters_visibleOnlyInParty) then
		if (inParty and not DamageMetersFrame:IsVisible()) then
			DMPrintD("DamageMeters_visibleOnlyInParty, inParty, and not DamageMetersFrame:IsVisible() - calling _Show()");
			DamageMeters_Show();
			DamageMeters_frameNeedsToBeGenerated = true;
		elseif (not inParty and DamageMetersFrame:IsVisible()) then
			DMPrintD("DamageMeters_visibleOnlyInParty, not inParty, and DamageMetersFrame:IsVisible() - calling _Hide()");
			DamageMeters_Hide();
		end
	end
end

function DamageMeters_UpdateCount()
	local newCount = DamageMeters_barCount;
	if (DamageMeters_showMaxBars) then
		newCount = DamageMeters_BARCOUNT_MAX;
	else
		if (DamageMeters_autoCountLimit > 0) then
			newCount = table.getn(DamageMeters_table);
			if (newCount > DamageMeters_autoCountLimit) then
				newCount = DamageMeters_autoCountLimit;
			elseif (newCount == 0) then
				newCount = 1;
			end
		end
	end

	if (newCount ~= DamageMeters_barCount) then
		DamageMeters_barCount = newCount;
		DamageMeters_frameNeedsToBeGenerated = true;
	end
end

function DamageMetersFrame_OnUpdate()
	--Only update if the refresh time has passed
	if ( ( not DamageMeters_LastUpdate ) or ( DamageMeters_LastUpdate and ( ( GetTime() - DamageMeters_LastUpdate ) > DamageMeters_REFRESH_TIME ) ) ) then
		DamageMeters_LastUpdate = GetTime();
		
		local quantIndex;
		local totals = {};
		local totalValue = 0;
		local maxUnitIndex = 0;
		local maxUnitValue = 0;
		local currentTime = GetTime();
	
		-- Update visibility.
		DamageMeters_UpdateVisibility();
	
		-- Update count.
		DamageMeters_UpdateCount();
	
		-- Sort the table.
		DamageMeters_DoSort(DamageMeters_quantity);
	
		-- Generate the frame if needed.
		if (DamageMeters_frameNeedsToBeGenerated) then
			DamageMetersFrame_GenerateFrame();
		end
	
		if (DamageMeters_inCombat) then
			DamageMeters_combatEndTime = GetTime();
	
			if (DamageMeters_quantity == DamageMeters_Quantity_DPS) then
				DamageMeters_SetBackgroundColor();
			end
		end
	
		for quantIndex = 1, DMI_MAX do
			totals[quantIndex] = 0;
		end
	
		-- Update text state.
		if (DamageMeters_textState > 0) then
			local now = GetTime();
			if (now - DamageMeters_textStateStartTime > DamageMeters_TEXTSTATEDURATION) then
				local lastState = DamageMeters_textState;
				repeat
					DamageMeters_textState = DamageMeters_textState + 1;
	
					if (DamageMeters_textState > DamageMeters_Text_MAX) then
						DamageMeters_textState = 1;
						if (DamageMeters_cycleVisibleQuantity) then
							DamageMeters_ShowNextQuantity();
						end
					end
					
					-- This is a safety to keep us from looping forever.
					if (DamageMeters_textState == lastState) then
						DamageMeters_textOptions[DamageMeters_Text_NAME] = true;
						DMPrintD("DamageMeters_textState infinite loop protection activated.");
						DamageMeters_textState = DamageMeters_Text_NAME;
						break;
					end
				until (DamageMeters_textOptions[DamageMeters_textState])
				DamageMeters_textStateStartTime = now;			
			end
		end
	
		-- Update quant cycling.
		if (DamageMeters_cycleVisibleQuantity) then
			if (DamageMeters_textState < 1) then
				if (GetTime() - DamageMeters_currentQuantStartTime > DamageMeters_QUANTITYSHOWDURATION) then
					DamageMeters_ShowNextQuantity();
					DamageMeters_textStateStartTime = GetTime();
				end
			end
		end
	
		-- Value
		local index;
		local info;
		for index,info in DamageMeters_table do 
			local unitValue;
			
			if (DamageMeters_quantity == DamageMeters_Quantity_TIME) then
				unitValue = currentTime - info.lastTime;
			elseif (DamageMeters_quantity == DamageMeters_Quantity_DPS) then
				unitValue = DamageMeters_GetCombatDPS(info.damageThisCombat);
			else
				unitValue = info[DamageMeters_quantity];
			end
	
			if (unitValue > maxUnitValue) then
				maxUnitIndex = index;
				maxUnitValue = unitValue;
			end
	
			totalValue = totalValue + unitValue;
			
			for quantIndex = 1, DMI_MAX do
				totals[quantIndex] = totals[quantIndex] + info[quantIndex];
			end
		end
	
		local barIndex = 1;
	
		local i;
		for i = 1,DamageMeters_barCount do
			DamageMeters_bars[i]:SetMinMaxValues(0, maxUnitValue);
			DamageMeters_text[i]:SetText("");
		end
	
		-- Total Button
		if (DamageMeters_showTotal) then
			if (DamageMeters_quantity == DamageMeters_Quantity_TIME) then
				DamageMeters_TotalButtonText:SetText("-");
			elseif (DamageMeters_quantity == DamageMeters_Quantity_DPS) then
				DamageMeters_TotalButtonText:SetText(string.format("T=%.1f", totalValue));
			else
				DamageMeters_TotalButtonText:SetText(string.format("T=%d", totalValue));
			end
		end
	
		-- Tooltip
		if (DamageMetersTooltip:IsOwned(this)) then
			DamageMeters_SetTooltipText(totals);
		end
	
		barIndex = 1;
		local struct;
		for i,struct in DamageMeters_table do 
			DamageMetersFrame_SetBarInfo(barIndex, totalValue, maxUnitValue, p == maxUnitIndex);
	
			barIndex = barIndex + 1;
			if (barIndex > DamageMeters_barCount) then
				return;
			end
		end
	elseif ( didUpdate or ( not DamageMetersPulse_LastUpdate ) or ( DamageMetersPulse_LastUpdate and ( ( GetTime() - DamageMetersPulse_LastUpdate ) > DamageMeters_PULSE_REFRESH_TIME ) ) ) then
		--If the normal refresh time hasnt passed, but the pulse refresh time has, then update the pulse only
		DamageMetersPulse_LastUpdate = GetTime();

		barIndex = 1;
		local struct;
		for i,struct in DamageMeters_table do 
			DamageMetersFrame_SetBarInfo(barIndex, totalValue, maxUnitValue, p == maxUnitIndex, true);
	
			barIndex = barIndex + 1;
			if (barIndex > DamageMeters_barCount) then
				return;
			end
		end
	end
end

function DamageMetersFrame_GenerateFrame(frame)
	if (not frame) then
		frame = DamageMetersFrame;
		if (not frame) then
			return;
		end
	end

	-- Hide all bars: update will reshow those that need to be seen.
	local i;
	for i = 1,DamageMeters_BARCOUNT_MAX do
		DamageMeters_bars[i]:Hide();
		DamageMeters_bars[i]:SetValue(0);
		DamageMeters_text[i]:SetText("");
		-- Put all bars under the first bar.
		DamageMeters_bars[i]:SetPoint("TOPLEFT", frame:GetName(), "TOPLEFT", 5, -6);
	end

	--DMPrint("GenerateFrame : bar count = "..DamageMeters_barCount);

	-- Set the size of the frame.
	local rowCount = 0;
	local columnCount = 1;
	local newWidth = 0;
	if (DamageMeters_barCount > (DamageMeters_BARCOUNT_MAX / 2)) then
		rowCount = ceil(DamageMeters_barCount / 2);
		columnCount = 2;
		newWidth = DamageMeters_BARWIDTH * 2 + 10 + 2;
	else
		columnCount = 1;
		rowCount = DamageMeters_barCount;
		newWidth = DamageMeters_BARWIDTH + 10;
	end
	local newHeight = (DamageMeters_BARHEIGHT * rowCount) + 11;

	local oldWidth = frame:GetWidth();
	local oldHeight = frame:GetHeight();

	frame:SetWidth( newWidth );
	frame:SetHeight( newHeight );

	-- Update pos according to resize direction.
	if (not DamageMeters_firstGeneration) then
		if (DamageMeters_resizeLeft or DamageMeters_resizeUp) then
			local xPos = frame:GetLeft();
			local yPos = frame:GetTop();

			if (DamageMeters_resizeLeft) then
				xPos = xPos - (newWidth - oldWidth);
			end
			if (DamageMeters_resizeUp) then
				yPos = yPos + (newHeight - oldHeight);
			end

			-- Note: anchoring to bottomleft since apparently the GetLeft and GetTop
			-- values are relative to that point.
			frame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", xPos, yPos);
		end
	end

	--DMPrint("DamageMeters: "..rowCount.." rows, "..columnCount.." columns.");

	-- Position the bars.
	local name = frame:GetName();
	local row;
	local column;
	for row = 1, rowCount do
		for column = 1, columnCount do
			--DMPrint("Row = "..row..", column = "..column);
			local index = row + (column - 1) * rowCount;
			if (index <= DamageMeters_barCount) then
				local itemButton = DamageMeters_bars[index];
				local textButton = DamageMeters_text[index];

				local x = 5 + (column - 1) * (DamageMeters_BARWIDTH + 2);
				local y = -6 - (row - 1) * DamageMeters_BARHEIGHT;
				itemButton:SetPoint("TOPLEFT", name, "TOPLEFT", x, y);
				textButton:SetPoint("CENTER", itemButton:GetName(), "CENTER", 0, 0);
			end
		end
	end

	DamageMeters_SetBackgroundColor();

	DamageMeters_frameNeedsToBeGenerated = false;
	DamageMeters_firstGeneration = false;
end

function DamageMetersFrame_SetBarInfo(barIndex, totalDamage, maxValue, isMax, pulseOnly)
	local red = 0.00;
	local green = 0.00;
	local blue = 0.00;
	local barString = "";

	local player = DamageMeters_table[barIndex].player;
	local age = GetTime() - DamageMeters_table[barIndex].lastTime;

	local isPlayer = (DamageMeters_Relation_SELF == DamageMeters_table[barIndex].relationship);

	local relationship = DamageMeters_table[barIndex].relationship;
	if (DamageMeters_colorScheme == 1) then
		if (DamageMeters_Relation_SELF == relationship) then
			green = 1.00;
		elseif (DamageMeters_Relation_PET == relationship) then
			green = 0.80;
		elseif (DamageMeters_Relation_PARTY == relationship) then
			blue = 1.00;
		elseif (DamageMeters_Relation_FRIENDLY == relationship) then
			red = 1.00;
			green = 0.50;
		end
	else
		local class = DamageMeters_table[barIndex].class;
		if (class) then
			local color = DamageMeters_GetClassColor(class);
			red = color.r;
			green = color.g;
			blue = color.b;
		elseif (DamageMeters_Relation_PET == relationship) then
			red = 0.00;
			green = 0.80;
			blue = 0.00;
		else
			red = 0.70;
			green = 0.70;
			blue = 0.70;
		end
	end

	local pulseMag = 0.00;
	if (age < DamageMeters_PULSE_TIME) then
		pulseMag = 1.00 - age / DamageMeters_PULSE_TIME;
	end

	-- TEXT --
	local barAge;
	local value;
	if ( not pulseOnly ) then
		local textOptions = {};
		local stateAge = GetTime() - DamageMeters_textStateStartTime;
		local showTextFactor = 1;
		barAge = stateAge - (barIndex / DamageMeters_barCount) * (DamageMeters_BARFADEINMINTIME + DamageMeters_BARFADEINTIME * DamageMeters_barCount);
		if (barAge > 0) then
			if (DamageMeters_textState > 0) then
				textOptions[DamageMeters_textState] = true;
			else
				textOptions = DamageMeters_textOptions;
			end
		end
	
		-- Rank
		if (textOptions[DamageMeters_Text_RANK]) then
			barString = format("%d", barIndex);
		end
	
		-- Name
		if (textOptions[DamageMeters_Text_NAME]) then
			if (textOptions[DamageMeters_Text_RANK]) then
				barString = format("%s %s", barString, player);
			else
				barString = player;
			end
		end
	
		-- Calc value
		if (DamageMeters_quantity == DamageMeters_Quantity_TIME) then
			value = age;
		elseif (DamageMeters_quantity == DamageMeters_Quantity_DPS) then
			value = DamageMeters_GetCombatDPS(DamageMeters_table[barIndex].damageThisCombat);
		else
			value = DamageMeters_table[barIndex][DamageMeters_quantity];
		end
	
		-- Total Percentage
		if (DamageMeters_quantity <= DMI_MAX) then
			if (textOptions[DamageMeters_Text_TOTALPERCENTAGE]) then
				local percent = (totalDamage > 0) and ((value / totalDamage) * 100) or 0;
				barString = format("%s %.2f%%", barString, percent);
			end
		end
	
		-- Leader Percentage
		if (DamageMeters_quantity <= DMI_MAX) then
			if (textOptions[DamageMeters_Text_LEADERPERCENTAGE]) then
				local percent = (maxValue > 0) and ((value / maxValue) * 100) or 0;
				barString = format("%s %.2f%%", barString, percent);
			end
		end
	
		-- Value
		if (textOptions[DamageMeters_Text_VALUE]) then
			if (DamageMeters_quantity == DamageMeters_Quantity_TIME) then
				-- handled below
			elseif (DamageMeters_quantity == DamageMeters_Quantity_DPS) then
				-- handled below
			else
				barString = format("%s %d", barString, value);
			end
		end
		if (DamageMeters_quantity == DamageMeters_Quantity_TIME) then
			-- Don't want to force peopel to turn on value display: assuming
			-- they always want to see the idle numbers.
			barString = format("%s %d:%.2d", barString, value / 60, math.mod(value, 60));
		end
		if (DamageMeters_quantity == DamageMeters_Quantity_DPS) then
			-- Don't want to force peopel to turn on value display: assuming
			-- they always want to see the dps numbers.
			barString = format("%s %.1f", barString, value);
		end
	end
	
	if (DamageMeters_colorScheme == 1 or DamageMeters_colorScheme == 2) then
		if (red == 1.00 and green == 1.00 and blue == 1.00) then
			red = 0.5 + 0.5 * (1.0 - pulseMag);
			green = red;
			blue = red;
		else
			red = pulseMag > red and pulseMag or red;
			green = pulseMag > green and pulseMag or green;
			blue = pulseMag > blue and pulseMag or blue;
		end
	else	
		blue = pulseMag;
	end

	-------
	if ( not pulseOnly ) then
		if (barAge > 0) then
			local charsToShow = floor(barAge / DamageMeters_BARCHARTIME);
			local strLen = string.len(barString);
			if (strLen > charsToShow) then
				local charsToRemove = strLen - charsToShow;
				local leftToRemove = floor(charsToRemove / 2);
				local rightToRemove = charsToRemove - leftToRemove;
	
				barString = string.sub(barString, leftToRemove, -rightToRemove);
			end
		end
	
		DamageMeters_bars[barIndex]:Show();
		DamageMeters_bars[barIndex]:SetValue(value);
		DamageMeters_text[barIndex]:SetText(barString);
		-- After 1300 patch text wouldn't appear without this.
		DamageMeters_text[barIndex]:Show();
	end
	DamageMeters_bars[barIndex]:SetStatusBarColor(red, green, blue);
end

-------------------------------------------------------------------------------

function DamageMeters_Clear(leave, silent)
	-- Clear contributor list full: on a partical clear it is impossible to
	-- tell who contributed what.
	DamageMeters_contributorList = {};
	DamageMeters_haveContributors = false;

	DamageMeters_fullTable = {};

	local last = table.getn(DamageMeters_table);
	if (last == 0) then
		-- This line just to ensure its really wiped out.
		DamageMeters_table = {};
		return;
	end

	local first = 1;
	if (leave ~= nil) then
		--DMPrint("leave = '"..leave.."'");
		local c = tonumber(leave);
		if (c) then
			first = leave + 1;
			if (first < 1) then
				first = 1;
			end
		end
	end

	if (not silent) then
		DMPrint(format(DM_MSG_CLEAR, first, last));
	end
	local i;
	for i = last,first,-1 do
		if (DamageMeters_bars[i]) then
			DamageMeters_bars[i]:SetValue(0);
			DamageMeters_text[i]:SetText("");
		end

		table.remove(DamageMeters_table);
	end

	if (not silent) then
		DMPrint(format(DM_MSG_REMAINING, table.getn(DamageMeters_table)));
	end
end

function DamageMeters_Test(countArg)
	DamageMeters_Clear();

	local count = DamageMeters_barCount;
	if (countArg) then
		count = tonumber(countArg);
		if (not count) then
			count = DamageMeters_barCount
		end

		if (count > DamageMeters_barCount) then
			count = DamageMeters_barCount;
		end
	end

	DMPrintD("Adding "..count.." test entries...");
	local index;
	local groupMembersOnlySave = DamageMeters_groupMembersOnly;
	DamageMeters_groupMembersOnly = false;
	for index = 1,count do
		DamageMeters_AddValue("Test"..index, 1*index, DM_HIT, DamageMeters_Relation_FRIENDLY, DamageMeters_Quantity_DAMAGE, "[Test]");
		DamageMeters_AddValue("Test"..index, 2*index, DM_HIT, DamageMeters_Relation_FRIENDLY, DamageMeters_Quantity_HEALING, "[Test]");
		DamageMeters_AddValue("Test"..index, 3*(count - index), DM_HIT, DamageMeters_Relation_FRIENDLY, DamageMeters_Quantity_DAMAGED, "[Test]");
		DamageMeters_AddValue("Test"..index, 4*(count - index), DM_HIT, DamageMeters_Relation_FRIENDLY, DamageMeters_Quantity_HEALINGRECEIVED, "[Test]");
	end
	DamageMeters_groupMembersOnly = groupMembersOnlySave;
end

function DamageMeters_GetPlayerIndex(player, searchTable)
	if (nil == searchTable) then
		searchTable = DamageMeters_table;
	end

	local i;
	for i = 1, table.getn(searchTable) do
		if (searchTable[i].player == player) then
			return i;
		end
	end
	
	return nil;
end

function DamageMeters_Add(player)
	if (player) then
		DamageMeters_AddDamage(player, 0, DM_HIT, DamageMeters_Relation_FRIENDLY, "[Test]");
	end
end

function DamageMeters_SetSort(sortArg)
	local usage = true;
	if (sortArg) then
		local sort = tonumber(sortArg);
		if (sort) then
			if (sort >= 1 and sort <= DamageMeters_Sort_MAX) then
				DamageMeters_sort = sort;
				DMPrint(DM_MSG_SORT..DamageMeters_sort);
				usage = false;
			else
				DMPrint(DM_ERROR_INVALIDARG);
			end
		end
	end

	if (usage) then
		DMPrint(DM_MSG_CURRENTSORT..DamageMeters_Sort_STRING[DamageMeters_sort]);
		local i;
		for i=1,DamageMeters_Sort_MAX do
			DMPrint(" "..i..": "..DamageMeters_Sort_STRING[i]);
		end
	end
end

function DamageMeters_SetQuantity(quantArg, bSilent)
	local usage = true;
	if (quantArg) then
		local quant = tonumber(quantArg);
		if (quant) then
			if (quant >= 1 and quant <= DamageMeters_Quantity_MAX) then
				DamageMeters_quantity = quant;
				if (not bSilent) then
					DMPrint(DM_MSG_SETQUANT..DamageMeters_Quantity_STRING[DamageMeters_quantity]);
				end
				usage = false;
			else
				if (not bSilent) then
					DMPrint(DM_ERROR_INVALIDARG);
				end
			end
		end
	end

	if (usage) then
		DMPrint(DM_MSG_CURRENTQUANT..DamageMeters_Quantity_STRING[DamageMeters_quantity]);
		local i;
		for i=1,DamageMeters_Quantity_MAX do
			DMPrint(" "..i..": "..DamageMeters_Quantity_STRING[i]);
		end
	end

	DamageMeters_SetBackgroundColor();

	DamageMeters_currentQuantStartTime = GetTime();
end

function DamageMeters_SetBackgroundColor()
	local frame = DamageMetersFrame;
	if (frame) then
		local color = DamageMeters_quantityColor[DamageMeters_quantity];
		frame:SetBackdropColor(color[1], color[2], color[3], color[4]);
		if (DamageMeters_Quantity_DPS == DamageMeters_quantity) then
			local title;
			local combatTime = DamageMeters_combatEndTime - DamageMeters_combatStartTime;
			if (combatTime > 60) then
				title = format("%s %d:%.2d", DamageMeters_Quantity_STRING[DamageMeters_quantity], combatTime / 60, math.mod(combatTime, 60));
			else
				title = format("%s %.1fs", DamageMeters_Quantity_STRING[DamageMeters_quantity], combatTime);
			end
			DamageMeters_TitleButtonText:SetText(title);
		else
			DamageMeters_TitleButtonText:SetText(DamageMeters_Quantity_STRING[DamageMeters_quantity]);
		end

		if (DamageMeters_paused) then
			DamageMetersFrame_TitleButton:SetBackdropColor(0.0, 0.0, 0.0, 0.9);
		else	
			DamageMetersFrame_TitleButton:SetBackdropColor(color[1], color[2], color[3], color[4]);
		end
		DamageMetersFrame_TotalButton:SetBackdropColor(color[1], color[2], color[3], color[4]);
	end
end

function DamageMeters_SetRelationship(index, relationship)
	if (nil == relationship) then
		DMPrintD("DamageMeters_SetRelationship ("..DamageMeters_table[index].player.."), relationship = nil.");
		relationship = DamageMeters_Relation_FRIENDLY;
	end

	relationship = tonumber(relationship);

	if (relationship < 1 or relationship > DamageMeters_Relation_MAX) then
		DMPrintD("DamageMeters_SetRelationship ("..DamageMeters_table[index].player.."), relationship = "..relationship);
		relationship = DamageMeters_Relation_FRIENDLY;
	end
	DamageMeters_table[index].relationship = relationship;
	--Print("relationship = "..relationship);

	if (relationship == DamageMeters_Relation_SELF) then
		DamageMeters_table[index].class = UnitClass("player");
		--Print("Adding self, class = "..DamageMeters_table[index].class);
	elseif (relationship == DamageMeters_Relation_PARTY) then
		local i;
		for i=1,5 do
			local partyUnitName = "party"..i;
			local partyName = UnitName(partyUnitName);
			if (partyName == DamageMeters_table[index].player) then
				DamageMeters_table[index].class = UnitClass(partyUnitName);
				--Print("Party member found: index = "..i..", class = "..DamageMeters_table[index].class);
				return;
			end
		end
	else
		DamageMeters_UpdateRaidMemberClasses();
	end
end

function DamageMeters_AddValue(player, amount, crit, relationship, quantity, spell)
	if (DamageMeters_msgWatchMode) then
		if (spell ~= "[Msg]") then
			return;
		end
	end

	if (relationship == nil) then
		DMPrintD("Relationship = nil, player("..player.."), amount("..amount.."), quantity("..quantity..")");
		relationship = DamageMeters_Relation_FRIENDLY;
	end

	-- Fix pet relationship if necessary.
	if (DamageMeters_Relation_PET ~= relationship and player == UnitName("Pet")) then
		relationship = DamageMeters_Relation_PET;
	end

	-- Assign to self if it is a pet and the option is set.
	if (DamageMeters_addPetToPlayer and relationship == DamageMeters_Relation_PET) then
		relationship = DamageMeters_Relation_SELF;
		player = UnitName("Player");
	end

	amount = tonumber(amount);
	relationship = tonumber(relationship);
	local currentTime = GetTime();

	--DMPrint("DamageMeters_AddValue : relationship = "..relationship);

	local index = DamageMeters_GetPlayerIndex(player);
	local memIndex = DamageMeters_GetPlayerIndex(player, DamageMeters_savedTable);
	local found = (index ~= nil);
	if (nil == index) then

		-- Reject if list locked.
		if (DamageMeters_listLocked) then
			return;
		end
		
		-- Reject if list full.
		if (table.getn(DamageMeters_table) >= DamageMeters_TABLE_MAX) then
			return;
		end

		-- Reject if player is banned.
		if (DamageMeters_IsBanned(player)) then
			--DMPrintD("Rejecting banned player "..player);
			return;
		end

		-- Reject if we are excluding non-group members.
		-- This code lets the player's pets through, btw.
		if (DamageMeters_groupMembersOnly and 
				(DamageMeters_Relation_PARTY == relationship or DamageMeters_Relation_FRIENDLY == relationship)) then
			local foundRelation = DamageMeters_GetGroupRelation(player);
			if (foundRelation < 0) then
				--DMPrintD(player.." not in party or raid, rejecting.");
				return;
			end
		end

		if (DamageMeters_startCombatOnNextValue and quantity == DamageMeters_Quantity_DAMAGE and spell ~= "[Sync]") then
			DamageMeters_startCombatOnNextValue = false;
			if (DamageMeters_resetWhenCombatStarts) then
				DamageMeters_Clear(0, true);
			end
			DamageMeters_OnCombatStart();
		end

		-- OK: Add the new player.
		index = DamageMeters_AddNewPlayer(DamageMeters_table, player);
		DamageMeters_SetRelationship(index, relationship);

		if (index <= DamageMeters_barCount) then
			DamageMeters_bars[index]:Show();
		end
	else
		if (DamageMeters_startCombatOnNextValue and quantity == DamageMeters_Quantity_DAMAGE) then
			DamageMeters_startCombatOnNextValue = false;
			if (DamageMeters_resetWhenCombatStarts) then
				DamageMeters_Clear(0, true);
			end
			DamageMeters_OnCombatStart();

			-- Very dangerous!  Recursing here.
			DamageMeters_AddValue(player, amount, crit, relationship, quantity, spell);
			return;
		end

		if (relationship < DamageMeters_table[index].relationship) then
			DMPrintD("Updating "..player.."'s relationship from "..DamageMeters_table[index].relationship.." to "..relationship);
			DamageMeters_SetRelationship(index, relationship);
		end
	end

	-- Update quantity.
	DamageMeters_table[index][quantity] = DamageMeters_table[index][quantity] + amount;

	-- Update crit count.
	if (crit ~= DM_DOT) then
		DamageMeters_table[index].hitCount[quantity] = DamageMeters_table[index].hitCount[quantity] + 1;
		if (crit == DM_CRIT) then
			DamageMeters_table[index].critCount[quantity] = DamageMeters_table[index].critCount[quantity] + 1;
		end
	end

	local idle = currentTime - DamageMeters_table[index].lastTime;

	-- We use amount = 0 just to add empty people to the list.  
	-- Only update time if it was because of a player action.
	if (found and (amount > 0) and (quantity == DamageMeters_Quantity_DAMAGE or quantity == DamageMeters_Quantity_HEALING)) then
		DamageMeters_table[index].lastTime = currentTime;		
	end

	if (DamageMeters_inCombat and quantity == DamageMeters_Quantity_DAMAGE) then
		DamageMeters_table[index].damageThisCombat = DamageMeters_table[index].damageThisCombat + amount;
		--DMPrint("damageThisCombat = "..DamageMeters_table[index].damageThisCombat);
	end

	if (DamageMeters_accumulateToMemory) then
		if (nil == memIndex) then
			memIndex = DamageMeters_AddNewPlayer(DamageMeters_savedTable, player);
			-- Relationship is tricky: copy it directly from the main table.
			DamageMeters_savedTable[memIndex].relationship = DamageMeters_table[index].relationship;
		end
	
		-- Update quantity.
		DamageMeters_savedTable[memIndex][quantity] = DamageMeters_savedTable[memIndex][quantity] + amount;

		-- Update crit count.
		if (crit ~= DM_DOT) then
			DamageMeters_savedTable[memIndex].hitCount[quantity] = DamageMeters_savedTable[memIndex].hitCount[quantity] + 1;
			if (crit == DM_CRIT) then
				DamageMeters_savedTable[memIndex].critCount[quantity] = DamageMeters_savedTable[memIndex].critCount[quantity] + 1;
			end
		end

		-- Take time from master table.
		DamageMeters_savedTable[memIndex].lastTime = DamageMeters_table[index].lastTime;

		-- Ignore damage damageThisCombat field for mem table.
	end


	-- Full Data collection. --

	if (DamageMeters_takeFullData) then
		if (not DamageMeters_fullTable[player]) then
			DamageMeters_fullTable[player] = {};
		end
		if (not DamageMeters_fullTable[player][quantity]) then
			DamageMeters_fullTable[player][quantity] = {};
		end
		if (not DamageMeters_fullTable[player][quantity][spell]) then
			DamageMeters_fullTable[player][quantity][spell] = 0;
		end
		DamageMeters_fullTable[player][quantity][spell] = DamageMeters_fullTable[player][quantity][spell] + amount;
	end

	if (DamageMeters_showValueChanges) then
		DMPrint(format("Added %d %s to %s from %s.", amount, DamageMeters_Quantity_STRING[quantity], DamageMeters_table[index].player, spell));
	end
end

function DamageMeters_AddNewPlayer(destTable, player)
	local index = table.getn(destTable) + 1;
	table.setn(destTable, index);
	destTable[index] = {};
	destTable[index][DMI_DAMAGE] = 0;
	destTable[index][DMI_HEALING] = 0;
	destTable[index][DMI_DAMAGED] = 0;
	destTable[index][DMI_HEALED] = 0;
	destTable[index].hitCount = {};
	destTable[index].critCount = {};
	local quant;
	for quant = 1, DMI_MAX do
		destTable[index].hitCount[quant] = 0;
		destTable[index].critCount[quant] = 0;
	end
	destTable[index].player = player;
	destTable[index].lastTime = GetTime();
	destTable[index].damageThisCombat = 0;
	return index;
end

function DamageMeters_AddDamage(player, amount, crit, relationship, spell)
	DamageMeters_AddValue(player, amount, crit, relationship, DamageMeters_Quantity_DAMAGE, spell);
end

function DamageMeters_AddDamageReceived(player, amount, crit, relationship, spell)
	DamageMeters_AddValue(player, amount, crit, relationship, DamageMeters_Quantity_DAMAGED, spell);
end

function DamageMeters_AddHealing(player, target, amount, crit, relationship, spell)
	--DMPrint("AddHealing: "..player.." healed "..target.." for "..amount);
	DamageMeters_AddValue(player, amount, crit, relationship, DamageMeters_Quantity_HEALING, spell);
	DamageMeters_AddValue(target, amount, crit, DamageMeters_Relation_FRIENDLY, DamageMeters_Quantity_HEALINGRECEIVED, spell);
end

function DamageMeters_Report(arg1)
	local destChar = "c";
	local count = table.getn(DamageMeters_table);
	local tellTarget = "";
	local params = string.lower(arg1);
	local reportQuantity;
	
	local argsParsed = false;

	if ("help" == params) then
		DamageMeters_ShowReportHelp();
		return;
	end

	local totalStrLen = 5;
	if ("total" == string.sub(params, 1, 5)) then
		reportQuantity = DamageMeters_ReportQuantity_Total;
		if (string.len(params) > totalStrLen) then
			params = string.sub(params, totalStrLen + 1);
		else
			params = "";
		end
	else
		reportQuantity = DamageMeters_quantity;
	end

	if (params == "") then
		argsParsed = true;
	end

	local a, b, c;
	if (not argsParsed) then
		for a, b, c in string.gfind(params, "(.)(%d+) (.+)") do
			destChar = a;
			count = tonumber(b);
			tellTarget = c;
			--DMPrint(1);
			argsParsed = true;
		end
	end
	if (not argsParsed) then
		for a, c in string.gfind(params, "(.) (%d+)") do
			destChar = a;
			--tellTarget = c;
			tellTarget = format("%d", c);
			--DMPrint(2);
			argsParsed = true;
		end
	end
	if (not argsParsed) then
		for a, b in string.gfind(params, "(.)(%d+)") do
			destChar = a;
			count = tonumber(b);
			--DMPrint(3);
			argsParsed = true;
		end
	end
	if (not argsParsed) then
		for a, c in string.gfind(params, "(.) (.+)") do
			destChar = a;
			tellTarget = c;
			--DMPrint(4);
			argsParsed = true;
		end
	end
	if (not argsParsed) then
		for a in string.gfind(params, "(.)") do
			destChar = a;
			--DMPrint(5);
			argsParsed = true;
		end
	end
	--DMPrint("."..destChar.."."..count.."."..tellTarget..".");

	if (not argsParsed) then
		DMPrint(DM_ERROR_INVALIDARG);
		DamageMeters_PrintHelp("report");
	end

	local destination;
	local invert = false;
	if (destChar) then
		--DMPrint("DamageMeters_Report("..params..")");

		local lowerDestChar = string.lower(destChar);
		if (lowerDestChar ~= destChar) then
			invert = true;
			destChar = lowerDestChar;
		end

		if (destChar == "c") then
			destination = "CONSOLE";
		elseif (destChar == "p") then
			destination = "PARTY";
		elseif (destChar == "s") then
			destination = "SAY";
		elseif (destChar == "r") then
			destination = "RAID";
		elseif (destChar == "w") then
			destination = "WHISPER";
		elseif (destChar == "h") then
			destination = "CHANNEL";
		elseif (destChar == "g") then
			destination = "GUILD";
		elseif (destChar == "f") then
			destination = "BUFFER";

		else
			DMPrint(DM_ERROR_BADREPORTTARGET..destChar);
			return;
		end
	end

	if (destination == "WHISPER" and tellTarget == "") then
		DMPrint(DM_ERROR_MISSINGWHISPERTARGET);
		return;
	elseif (destination == "CHANNEL" and tellTarget == "") then
		DMPrint(DM_ERROR_MISSINGCHANNEL);
		return;
	end

	DamageMeters_DoReport(reportQuantity, destination, invert, count, tellTarget);

	if (destination == "BUFFER") then
		DamageMeters_OpenReportFrame();
	end
end

function DamageMeters_DumpTable()
	DMPrint(table.getn(DamageMeters_table).." elements:");

	local index;
	local info;
	for index,info in DamageMeters_table do 
		DMPrint(index..": "..info.player);
	end
end

function DamageMeters_DoReport(reportQuantity, destination, invert, count, tellTarget)
	local editBox = DEFAULT_CHAT_FRAME.editBox;
	local msg;

	if (destination == "BUFFER") then
		DamageMeters_reportBuffer = "";
	end

	-- Determine bounds.
	if (count > table.getn(DamageMeters_table)) then
		count = table.getn(DamageMeters_table);
	end

	local start = 1;
	local finish = table.getn(DamageMeters_table);
	if (count < finish) then
		finish = count;
	end

	local step = 1;
	if (invert) then
		start = finish;
		finish = 1;
		step = -1;
	end

	------------
	-- Header --
	------------
	if (reportQuantity == DamageMeters_ReportQuantity_Total) then
		msg = format(DM_MSG_FULLREPORTHEADER, count, table.getn(DamageMeters_table));
	elseif (reportQuantity == DamageMeters_ReportQuantity_Leaders) then
		local header = format(DM_MSG_LEADERREPORTHEADER, count, table.getn(DamageMeters_table));
		local q;
		for q = 1, DMI_MAX do
			header = format("%s| %-19s", header, DamageMeters_Quantity_STRING[q]);
		end
		msg = header.."\n-------------------------------------------------------------------------------";
	else
		msg = format(DM_MSG_REPORTHEADER, DamageMeters_Quantity_STRING[reportQuantity], count, table.getn(DamageMeters_table));
	end
	DamageMeters_SendReportMsg(msg, destination, tellTarget);

	if (reportQuantity > DamageMeters_ReportQuantity_Total) then
		DamageMeters_DoSort(reportQuantity);
	end

	-- Calculate totals.
	local totalValue = 0;
	local index;
	local info;
	local totals = {0, 0, 0, 0, 0, 0};
	if (reportQuantity > 0) then
		if (reportQuantity <= DMI_MAX) then
			for index,info in DamageMeters_table do 
				totalValue = totalValue + info[reportQuantity];
			end
		elseif(reportQuantity == DamageMeters_Quantity_DPS) then
			for index,info in DamageMeters_table do 
				totalValue = totalValue + DamageMeters_GetCombatDPS(info.damageThisCombat);
			end
		end
	elseif (reportQuantity == DamageMeters_ReportQuantity_Total or
			reportQuantity == DamageMeters_ReportQuantity_Leaders) then
		for index,info in DamageMeters_table do 
			totals[1] = totals[1] + info[1];
			totals[2] = totals[2] + info[2];
			totals[3] = totals[3] + info[3];
			totals[4] = totals[4] + info[4];
			totals[5] = totals[5] + info.hitCount[DMI_DAMAGE];
			totals[6] = totals[6] + info.critCount[DMI_DAMAGE];
		end

		DamageMeters_DetermineRanks();
	end

	---------------
	-- Main Loop --
	---------------
	local formatStrTotalMain_A = "%-12s %7d[%2d] %7d[%2d] %7d[%2d] %7d[%2d] %7d %7d";
	local formatStrTotalTotals = "%-12s %11d %11d %11d %11d %7d %7d";
	-- Careful here--if there isn't a space after each | it can lock up.
	local formatStrTotalMain_B = "%2d| %6d %-12s| %6d %-12s| %6d %-12s| %6d %-12s";
	local formatStrLeaderTotals= " =| %-18d | %-18d | %-18d | %-18d";
	local currentTime = GetTime();
	local i;
	local showThis;
	local visibleTotal = 0;
	for i = start, finish, step do
		local value;
		msg = "";

		if (reportQuantity == DamageMeters_ReportQuantity_Total) then
			msg = format(formatStrTotalMain_A, DamageMeters_table[i].player, 
					DamageMeters_table[i][1], DamageMeters_rankTable[DamageMeters_table[i].player][1], 
					DamageMeters_table[i][2], DamageMeters_rankTable[DamageMeters_table[i].player][2], 
					DamageMeters_table[i][3], DamageMeters_rankTable[DamageMeters_table[i].player][3], 
					DamageMeters_table[i][4], DamageMeters_rankTable[DamageMeters_table[i].player][4], 
					DamageMeters_table[i].hitCount[DMI_DAMAGE], DamageMeters_table[i].critCount[DMI_DAMAGE]);
		elseif(reportQuantity == DamageMeters_ReportQuantity_Leaders) then
			local leaders = {};
			local leaderIndexes = {};
			local qIx;
			for qIx = 2, DMI_MAX do
				local leaderName, rank;
				for leaderName, rank in DamageMeters_rankTable do
					--DMPrint(i.." "..leaderName.." "..rank[qIx]);
					if (rank[qIx] == i) then
						leaders[qIx] = leaderName;
						leaderIndexes[qIx] = DamageMeters_GetPlayerIndex(leaderName);
						break;
					end
				end
			end

			msg = format(formatStrTotalMain_B, i, DamageMeters_table[i][1], DamageMeters_table[i].player,	DamageMeters_table[leaderIndexes[2]][2], leaders[2], DamageMeters_table[leaderIndexes[3]][3], leaders[3], DamageMeters_table[leaderIndexes[4]][4], leaders[4]); 
		else
			if (DamageMeters_Quantity_TIME == reportQuantity) then
				local idleTime = currentTime - DamageMeters_table[i].lastTime;
				msg = format("#%.2d: %-16s  %d:%.02d", i, DamageMeters_table[i].player, idleTime / 60, math.mod(idleTime, 60));
			elseif (DamageMeters_Quantity_DPS == reportQuantity) then
				local dps = DamageMeters_GetCombatDPS(DamageMeters_table[i].damageThisCombat);
				visibleTotal = visibleTotal + dps;
				if (dps > 0) then
					msg = format("#%.2d: %-16s  %.1f", i, DamageMeters_table[i].player, dps);
				end
			else
				value = DamageMeters_table[i][reportQuantity];
				visibleTotal = visibleTotal + value;
				if (value > 0) then
					local percentage = (totalValue > 0) and (100 * value / totalValue) or 0;
					msg = format("#%.2d:  %.2f%%  %-16s  %d", i, percentage, DamageMeters_table[i].player, value);
				end
			end
		end
		
		if (msg ~= "") then
			DamageMeters_SendReportMsg(msg, destination, tellTarget);
		end
	end

	------------
	-- Totals --
	------------
	if (reportQuantity == DamageMeters_ReportQuantity_Total or
		reportQuantity == DamageMeters_ReportQuantity_Leaders) then

		if (reportQuantity == DamageMeters_ReportQuantity_Total) then
			msg = format(formatStrTotalTotals, DM_MSG_TOTAL, totals[1], totals[2], totals[3], totals[4], totals[5], totals[6]);
		else
			msg = format(formatStrLeaderTotals, totals[1], totals[2], totals[3], totals[4], totals[5], totals[6]);
		end
		DamageMeters_SendReportMsg(msg, destination, tellTarget);

		-- Print a list of contributors.
		if (DamageMeters_haveContributors) then
			msg = format(DM_MSG_COLLECTORS, UnitName("Player"));
			for contrib, unused in DamageMeters_contributorList do
				msg = msg..", "..contrib;
			end
			DamageMeters_SendReportMsg(msg, destination, tellTarget);
		end
	elseif (DamageMeters_Quantity_DPS == reportQuantity) then
		msg = format(DM_MSG_COMBATDURATION, DamageMeters_combatEndTime - DamageMeters_combatStartTime);
		DamageMeters_SendReportMsg(msg, destination, tellTarget);
	end

	if (reportQuantity > 0) then
		if (DamageMeters_Quantity_TIME == reportQuantity) then
			-- No total.
		elseif (DamageMeters_Quantity_DPS == reportQuantity) then
			msg = format(DM_MSG_REPORTTOTALDPS, totalValue, visibleTotal);
			DamageMeters_SendReportMsg(msg, destination, tellTarget);
		else
			msg = format(DM_MSG_REPORTTOTAL, totalValue, visibleTotal);
			DamageMeters_SendReportMsg(msg, destination, tellTarget);
		end
	end
end

function DamageMeters_DetermineRanks()

	local count = table.getn(DamageMeters_table);

	DamageMeters_rankTable = {};

	local quantity;
	for quantity = DMI_MAX, 1, -1 do
		DamageMeters_DoSort(quantity);

		local index;
		for index = 1, count do
			local playerName = DamageMeters_table[index].player;
			if (quantity == DMI_MAX) then
				--DMPrint("clearing for "..DamageMeters_table[index].player);
				DamageMeters_rankTable[playerName] = {};
			end	
			--DMPrint("quantity = "..quantity);
			DamageMeters_rankTable[playerName][quantity] = index;
		end
	end
end

function DamageMeters_SendReportMsg(msg, destination, tellTarget)
	local editBox = DEFAULT_CHAT_FRAME.editBox;
	if (destination == "CONSOLE") then
		DMPrint(msg);
	elseif (destination == "CHANNEL") then
		--DMPrint("Destination = "..destination..", tellTarget = "..tellTarget);
		SendChatMessage(msg, destination, editBox.language, GetChannelName(tellTarget));
	elseif (destination == "BUFFER") then
		DamageMeters_reportBuffer = DamageMeters_reportBuffer..msg.."\n";
	else
		SendChatMessage(msg, destination, editBox.language, tellTarget);
	end
end

function DamageMeters_SetCount(arg1)
	local count = 0;
	if (not arg1 or arg1 == "") then
		DMPrint(DM_MSG_SETCOUNTTOMAX);
		count = DamageMeters_BARCOUNT_MAX;
	else 
		count = tonumber(arg1);
		if (count > DamageMeters_BARCOUNT_MAX) then
			count = DamageMeters_BARCOUNT_MAX;
		end
	end
	
	DamageMeters_barCount = count;
	DMPrint(DM_MSG_SETCOUNT..DamageMeters_barCount);
	DamageMeters_frameNeedsToBeGenerated = true;
	DamageMeters_autoCountLimit = 0;
	DamageMeters_showMaxBars = false;
end

function DamageMeters_Reset()
	DamageMeters_UpdateVisibility();
	DamageMeters_UpdateCount();
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_ResetPos()
	local frame = DamageMetersFrame;
	if (not frame) then
		DMPrintD("DamageMetersFrame_Reset : Error getting frame.");
		return;
	end

	DMPrint(DM_MSG_RESETFRAMEPOS);
	local frameWidth = frame:GetWidth();
	local frameHeight = frame:GetHeight();
	frame:ClearAllPoints();
	frame:SetPoint("TOPLEFT", "UIParent", "RIGHT", -frameWidth, floor(frameHeight / 2));

	CloseMenus();
end

function DamageMetersFrame_OnClick(arg1)
	if ( arg1 == "RightButton" ) then
		DamageMeters_Clear();
	end
end

-- In the case of a tie, sort alphabetically.
function DamageMeters_DoSort(quantity)
	if (DamageMeters_Sort_ALPHABETICAL == DamageMeters_sort) then
		table.sort(DamageMeters_table, 
				function(a,b) 
					return a.player < b.player;
				end
				);
		return;
	end

	if (quantity == DamageMeters_Quantity_TIME) then
		table.sort(DamageMeters_table, 
				function(a,b) 
					local result;
					if (a.lastTime == b.lastTime) then
						result = a.player < b.player;
					else
						result = a.lastTime < b.lastTime;
					end

					if (DamageMeters_sort == DamageMeters_Sort_INCREASING) then
						result = not result;
					end
					return result;
				end
				);
	elseif (quantity == DamageMeters_Quantity_DPS) then
		table.sort(DamageMeters_table, 
				function(a,b) 
					local result;
					if (a.damageThisCombat == b.damageThisCombat) then
						result = a.player < b.player;
					else
						result = a.damageThisCombat > b.damageThisCombat;
					end

					if (DamageMeters_sort == DamageMeters_Sort_INCREASING) then
						result = not result;
					end
					return result;
				end
				);
	else
		table.sort(DamageMeters_table, 
				function(a,b) 
					local result;
					if (a[quantity] == b[quantity]) then
						result = a.player < b.player;
					else
						result = a[quantity] > b[quantity];
					end

					if (DamageMeters_sort == DamageMeters_Sort_INCREASING) then
						result = not result;
					end
					return result;
				end
				);
	end
end

function DamageMeters_ToggleShow()
	local frame = getglobal("DamageMetersFrame");
	if (frame:IsVisible()) then
		DMPrintD("ToggleShow called - calling _Hide()");
		DamageMeters_Hide();
	else
		DamageMeters_visibleOnlyInParty = false;
		DMPrintD("ToggleShow called - calling _Show()");
		DamageMeters_Show();
	end
end

function DamageMeters_Show()
	DMPrintD("DamageMeters_Show called.");
	DamageMetersFrame:Show();
	DamageMetersFrame_TitleButton:Show();
	if (DamageMeters_showTotal) then
		DamageMetersFrame_TotalButton:Show();
	end
	DamageMeters_isVisible = true;
end

function DamageMeters_Hide()
	DamageMetersFrame:Hide();
	DamageMetersFrame_TitleButton:Hide();
	DamageMetersFrame_TotalButton:Hide();
	DamageMeters_isVisible = false;
end

function DM_CountMsg(arg1, desc, event, filter)
	local filterOn = false;
	if (DamageMeters_showParse) then
		if (not filterOn or filter) then
			event = string.sub(event, 10);
			DMPrint("Parsed("..event..") "..arg1.." ["..desc.."]", nil, true);
		end
	end

	if (DamageMeters_msgCounts[desc]) then
		DamageMeters_msgCounts[desc] = DamageMeters_msgCounts[desc] + 1;
	else
		DamageMeters_msgCounts[desc] = 1;
	end

	if (DamageMeters_msgWatchMode) then
		DamageMeters_AddValue(desc, 1, DM_HIT, DamageMeters_Relation_PET, DamageMeters_Quantity_DAMAGE, "[Msg]");
	end
end

function DM_DumpMsg()
	local i;
	local desc;
	for key,count in DamageMeters_msgCounts do
		DMPrintD(key.." : "..count)
	end;
end

function DM_ToggleDMPrintD()
	DamageMeters_enableDebugPrint = not DamageMeters_enableDebugPrint;
	DMPrint("Debug print enabled = "..(DamageMeters_enableDebugPrint and "true" or "false"));

	--[[
	local arg1 = "Le (spell) de Exess soigne avec un effet critique Dandelion, pour 1000 points de vie.";
	local spell, player, creatureName, damage;
	for spell, player, creatureName, damage in string.gfind(arg1, "Le (.+) de (.+) soigne avec un effet critique (.+)%, pour (%d+) points de vie.") do
		DMPrint("creatureName = "..creatureName);
		return;
	end
	DMPrint("Didn't catch.");
	]]--
end

-------------------------------------------------------------------------------

function DamageMetersBarTemplate_OnEnter()
	if (not DamageMetersFrame:IsVisible()) then
		return;
	end
	-- Getting onenters for invisible bars.  This doesn't seem to work :/
	if (not this:IsVisible()) then
		return;
	end
	-- This to work around above condition not working.
	if (this:GetID() > DamageMeters_barCount) then
		return;
	end

	-- no workee
	if (DamageMetersTooltip:IsVisible()) then
		return;
	end

	-- no workee
	if (DamageMetersFrameBarDropDown:IsVisible()) then
		--DMPrint("Not showing because drop down visible");
		return;
	end

	-- constant
	--DMPrint("Showing dropdown.");

	local index;
	local info;
	local totals = {};
	for quantIndex = 1, DMI_MAX do
		totals[quantIndex] = 0;
	end
	for index,info in DamageMeters_table do 
		local quantIndex;
		for quantIndex = 1, DMI_MAX do
			totals[quantIndex] = totals[quantIndex] + info[quantIndex];
		end
	end

	DamageMeters_tooltipBarIndex = this:GetID();

	DamageMetersTooltip:SetOwner(DamageMetersFrame, "ANCHOR_LEFT");
	DamageMeters_SetTooltipText(totals);

	DamageMetersTooltip:ClearAllPoints();
	local anchorPoint = "RIGHT";
	local relativePoint = "LEFT";
	local xOffset = -4;

	local x,y = DamageMetersFrame:GetCenter();
	local screenWidth = UIParent:GetWidth();
	if (x~=nil and screenWidth~=nil) then
		if (x < (screenWidth / 2)) then
			anchorPoint = "LEFT";
			relativePoint = "RIGHT";
			xOffset = 4;
		end
	end

	DamageMetersTooltip:SetPoint(anchorPoint, this:GetName(), relativePoint, xOffset, 0);
	
	-- added 2005-01-13 by arys
	-- makes clock tooltip scale correctly
	DamageMetersTooltip:SetScale(this:GetScale());
end

function DamageMetersBarTemplate_OnLeave()
	DamageMeters_tooltipBarIndex = nil;
	DamageMetersTooltip:Hide();
end

function DamageMetersBarTemplate_OnClick()
	local index = this:GetID();
	
	--DMPrint("Click '"..arg1.."'");
	if ( arg1 == "LeftButton" ) then
		if (index <= table.getn(DamageMeters_table)) then
			--Print("Targetting "..DamageMeters_table[index].player);
			TargetByName(DamageMeters_table[index].player);
		end
	elseif ( arg1 == "RightButton" ) then
		if (index <= table.getn(DamageMeters_table)) then
			local frame = DamageMetersFrame;

			local distance;
			distance = ( UIParent:GetWidth() - frame:GetRight() );
			
			DamageMeters_clickedBarIndex = index;

			--DMPrint("distance = "..distance);
			local menuMoveDist = -75;
			if ( distance <= menuMoveDist ) then
				local newOffset = distance - menuMoveDist;
				--DMPrint("Too close, new offset = "..newOffset);
				ToggleDropDownMenu(1, nil, DamageMetersFrameBarDropDown, "DamageMetersFrameBarDropDown", newOffset, 0);
			else
				ToggleDropDownMenu(1, nil, DamageMetersFrameBarDropDown, "DamageMetersFrameBarDropDown", 0, 0);
			end
		end
	end
end

function DamageMeters_SetTooltipText(totals)
	local struct = DamageMeters_table[DamageMeters_tooltipBarIndex];

	if ((nil == struct) or (not DamageMeters_tooltipBarIndex) or (DamageMeters_tooltipBarIndex > table.getn(DamageMeters_table))) then
		-- (nil == struct.player) or 
		DamageMeters_tooltipBarIndex = nil;
		DamageMetersTooltip:Hide();
		return;
	end

	DamageMetersTooltip:SetText(struct.player, 1.00, 1.00, 1.00);

	local percentages = {};
	local quantIndex;
	for quantIndex = 1, DMI_MAX do
		percentages[quantIndex] = (totals[quantIndex] > 0) and (100 * struct[quantIndex] / totals[quantIndex]) or 0;
	end

	local text = "";
	for quantIndex = 1, DMI_MAX do
		text = text..(format("%s = %d (%.2f%%)\n", DamageMeters_Quantity_STRING[quantIndex], struct[quantIndex], percentages[quantIndex]));
		local critPercentage = (struct.hitCount[quantIndex] > 0) and (struct.critCount[quantIndex] / struct.hitCount[quantIndex]) * 100 or 0;
		text = text..(format("    %d/%d (%.2f%%) %s\n", struct.critCount[quantIndex], struct.hitCount[quantIndex], critPercentage, DM_CRITSTR));
	end

	--DMPrint("relationship = "..struct.relationship);

	text = text..format(DM_TOOLTIP, 
			GetTime() - struct.lastTime,
			DamageMeters_Relation_STRING[struct.relationship]);
	if (struct.class) then
		text = text.."\n"..DM_CLASS.." = "..struct.class;
	end

	DamageMetersTooltip:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	DamageMetersTooltip:Show();
end

function DamageMeters_PrintHelp(command)
	local index, help;
	for index, help in DamageMeters_helpTable do
		if (1 == string.find(help, "dm"..command)) then
			DMPrint(help);
			return;
		end
	end
end

function DamageMeters_Help()
	local index, help;
	for index, help in DamageMeters_helpTable do
		DMPrint(help);
	end
end

function DamageMeters_Save()
	DamageMeters_savedTable = {};

	DMPrint(DM_MSG_SAVE);
	local index,struct;
	for index,struct in DamageMeters_table do
		DamageMeters_savedTable[index] = DamageMeters_table[index];
	end
end

function DamageMeters_Restore()
	if (DamageMeters_savedTable and (table.getn(DamageMeters_savedTable) > 0)) then
		DMPrint(DM_MSG_RESTORE);
		DamageMeters_table = DamageMeters_savedTable;
		DamageMeters_savedTable = {};
	else
		DMPrint(DM_ERROR_NOSAVEDTABLE);
	end
end

function DamageMeters_Merge()
	DMPrint(DM_MSG_MERGE);

	local index,struct;
	local targetLength = table.getn(DamageMeters_table);
	for index,struct in DamageMeters_savedTable do
		local player = struct.player;

		local existingIndex = DamageMeters_GetPlayerIndex(player);
		if (nil == existingIndex) then
			if (targetLength < DamageMeters_TABLE_MAX) then
				-- Copy entire entry over.
				local newIndex = targetLength + 1;
				DMPrintD("  "..player.." not found, creating new entry at index = "..newIndex);
				DMASSERTEQUALS(nil, DamageMeters_table[newIndex]);
				DamageMeters_table[newIndex] = {};
				DamageMeters_table[newIndex] = struct;
				targetLength = targetLength + 1;
				DMASSERTEQUALS(player, DamageMeters_table[newIndex].player);
				DMASSERTEQUALS(newIndex, table.getn(DamageMeters_table));
			end
		else
			-- Merge with existing data.
			DMPrintD("  "..player.." found, merging data.");
			local target = DamageMeters_table[existingIndex];

			local quantIndex;
			for quantIndex = 1, DMI_MAX do
				target[quantIndex] = target[quantIndex] + struct[quantIndex];
				target.hitCount[quantIndex] = target.hitCount[quantIndex] + struct.hitCount[quantIndex];
				target.critCount[quantIndex] = target.critCount[quantIndex] + struct.critCount[quantIndex];
			end
			
			target.lastTime = (target.lastTime > struct.lastTime) and target.lastTime or struct.lastTime;
			-- Leave relationship.
			if (not target.class) then
				target.class = struct.class;
			end
		end
	end
end

function DamageMeters_Swap(silent)
	local tempTable = {};

	if (not silent) then
		DMPrint(format(DM_MSG_SWAP, table.getn(DamageMeters_table), table.getn(DamageMeters_savedTable)));
	end

	-- Save table to temp.
	local index,struct;
	for index,struct in DamageMeters_table do
		tempTable[index] = struct;
	end

	-- Copy saved to table.
	DamageMeters_table = {};
	for index,struct in DamageMeters_savedTable do
		DamageMeters_table[index] = struct;
	end

	-- Copy temp to saved.
	DamageMeters_savedTable = {};
	for index,struct in tempTable do
		DamageMeters_savedTable[index] = struct;
	end

	-- Regen frame to hide any buttons now not needed.
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_MemClear()
	DMPrint(DM_MSG_MEMCLEAR);
	DamageMeters_savedTable = {};
end

function DamageMeters_SetTextOptions(arg1)
	if (arg1 == "") then
		DMPrint(DM_ERROR_MISSINGARG);
		DamageMeters_PrintHelp("text");
		return;
	end

	DamageMeters_textOptions[DamageMeters_Text_RANK] = false;
	DamageMeters_textOptions[DamageMeters_Text_NAME] = false;
	DamageMeters_textOptions[DamageMeters_Text_TOTALPERCENTAGE] = false;
	DamageMeters_textOptions[DamageMeters_Text_LEADERPERCENTAGE] = false;
	DamageMeters_textOptions[DamageMeters_Text_VALUE] = false;		

	if (arg1 == "0") then
		return;	
	end

	local i;
	for i = 1, string.len(arg1) do
		local char = string.lower(string.sub(arg1, i, i));

		if (char == "n") then
			DamageMeters_textOptions[DamageMeters_Text_NAME] = true;
		elseif (char == "p") then
			DamageMeters_textOptions[DamageMeters_Text_TOTALPERCENTAGE] = true;
		elseif (char == "l") then
			DamageMeters_textOptions[DamageMeters_Text_LEADERPERCENTAGE] = true;
		elseif (char == "v") then
			DamageMeters_textOptions[DamageMeters_Text_VALUE] = true;
		elseif (char == "r") then
			DamageMeters_textOptions[DamageMeters_Text_RANK] = true;
		end
	end
end

function DamageMeters_SetColorScheme(arg1)
	local showUsage = false;
	local colorScheme;
	if (not arg1 or arg1 == "") then
		showUsage = true;
	else
		colorScheme = tonumber(arg1);
		if (colorScheme < 1 or colorScheme > DamageMeters_colorScheme_MAX) then
			showUsage = true;
		end	
	end
	
	if (showUsage) then
		DamageMeters_PrintHelp("color");

		local i;
		for i=1, DamageMeters_colorScheme_MAX do
			DMPrint(i..": "..DamageMeters_colorScheme_STRING[i]);
		end

		return;
	end

	DMPrint(DM_MSG_SETCOLORSCHEME..DamageMeters_colorScheme_STRING[colorScheme]);
	DamageMeters_colorScheme = colorScheme;
end

function DamageMeters_UpdateRaidMemberClasses()
	local numRaidMembers = GetNumRaidMembers();
	local name, rank, subgroup, level, class, fileName, zone, online, isDead;
	local i;
	for i = 1,numRaidMembers do
		name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);

		local tableIndex = DamageMeters_GetPlayerIndex(name);
		if (tableIndex) then
			DamageMeters_table[tableIndex].class = class;
		end
	end
end

function DamageMeters_GetGroupRelation(player)
	
	local numPartyMembers = GetNumPartyMembers();
	if (numPartyMembers > 0) then
		for i=1,5 do
			local partyUnitName = "party"..i;
			local partyName = UnitName(partyUnitName);
			if (partyName == player) then
				return DamageMeters_Relation_PARTY;
			end
		end			
	end

	local numRaidMembers = GetNumRaidMembers();
	if (numRaidMembers > 0) then
		local name, rank, subgroup, level, class, fileName, zone, online, isDead;
		local i;
		for i = 1,numRaidMembers do
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
			if (name == player) then
				return DamageMeters_Relation_FRIENDLY;
			end
		end
	end

	return -1;
end

function DamageMeters_SetVisibleInParty(arg1)
	if (arg1 and arg1 ~= "") then
		local arg = string.lower(arg1);
		if (arg == "y") then
			DamageMeters_visibleOnlyInParty = true;
			DamageMeters_UpdateVisibility();
		elseif (arg == "n") then
			DamageMeters_visibleOnlyInParty = false;
			DamageMeters_UpdateVisibility();
		else
			DMPrint(DM_ERROR_INVALIDARGS);
			DamageMeters_PrintHelp("visinparty");
		end
	end

	DMPrint(DM_MSG_SETVISINPARTY..(DamageMeters_visibleOnlyInParty and DM_MSG_TRUE or DM_MSG_FALSE));
end

function DamageMeters_SetAutoCount(arg1)
	if (not arg1 or arg1 == "") then
		DMPrint(DM_ERROR_MISSINGARG);
		DamageMeters_PrintHelp("autocount");
		return;
	end

	local newAutoCountLimit = tonumber(arg1);
	if (not newAutoCountLimit or newAutoCountLimit <= 0 or newAutoCountLimit > DamageMeters_BARCOUNT_MAX) then
		DMPrint(DM_ERROR_INVALIDARG);
		return;
	end

	DMPrint(DM_MSG_SETAUTOCOUNT..newAutoCountLimit);
	DamageMeters_autoCountLimit = newAutoCountLimit;
	DamageMeters_showMaxBars = false;
end

-----------------------------------------

function DamageMeters_FrameDropDown_OnLoad()
	--DMPrint("this = "..this:GetName());
	UIDropDownMenu_Initialize(this, DamageMeters_FrameDropDown_Initialize, "MENU");
end

function DamageMeters_FrameDropDown_Initialize()

	-- If level 2
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		-- If this is the sort style menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_SORT ) then
			local index;
			for index = 1,DamageMeters_Sort_MAX do
				info = {};
				info.text = DamageMeters_Sort_STRING[index];
				info.value = index;
				info.func = DamageMetersFrame_TitleButton_SetSort;
				if ( index == DamageMeters_sort ) then
					info.checked = 1;
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;	
		end

		-- If this is the quantity menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_VISIBLEQUANTITY ) then
			local index;
			for index = 1,DamageMeters_Quantity_MAX do
				info = {};
				info.text = DamageMeters_Quantity_STRING[index];
				info.value = index;
				info.func = DamageMetersFrame_TitleButton_SetQuantity;
				if ( index == DamageMeters_quantity ) then
					info.checked = 1;
				end
				info.swatchFunc = DamageMeters_SetQuantityColor;
				-- Set the swatch color info
				info.hasColorSwatch = 1;
				info.r = DamageMeters_quantityColor[index][1];
				info.g = DamageMeters_quantityColor[index][2];
				info.b = DamageMeters_quantityColor[index][3];
				info.opacity = 1.0 - DamageMeters_quantityColor[index][4];
				info.cancelFunc = DamageMeters_CancelQuantityColorSettings;
				info.hasOpacity = 1;
				info.opacityFunc = DamageMeters_SetQuantityColorOpacity;
				--info.keepShownOnClick = 1;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- Spacer
			info = {};
			info.disabled = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Set for all
			info = {};
			info.text = DM_MENU_SETCOLORFORALL;
			info.func = DamageMeters_SetQuantityColorAllOnClick;
			info.swatchFunc = DamageMeters_SetQuantityColorAll;
			info.hasColorSwatch = 1;
			info.r = DamageMeters_quantityColor[DamageMeters_quantity][1];
			info.g = DamageMeters_quantityColor[DamageMeters_quantity][2];
			info.b = DamageMeters_quantityColor[DamageMeters_quantity][3];
			info.hasOpacity = 1;
			info.opacity = 1.0 - DamageMeters_quantityColor[DamageMeters_quantity][4];
			info.opacityFunc = DamageMeters_SetQuantityColorOpacityAll;
			info.notCheckable = 1;
			info.keepShownOnClick = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Default Colors
			info = {};
			info.text = DM_MENU_DEFAULTCOLORS;
			info.notCheckable = 1;
			info.func = DamageMeters_SetDefaultColors;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Spacer
			info = {};
			info.disabled = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Cycle text
			info = {};
			info.text = DM_MENU_QUANTCYCLE;
			if (DamageMeters_cycleVisibleQuantity) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleCycleVisibleQuant;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Show Total
			info = {};
			info.text = DM_MENU_SHOWTOTAL;
			if (DamageMeters_showTotal) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleTotal;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			return;	
		end

		-- If this is the color scheme menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_COLORSCHEME ) then
			local index;
			for index = 1, DamageMeters_colorScheme_MAX do
				info = {};
				info.text = DamageMeters_colorScheme_STRING[index];
				info.value = index;
				info.func = DamageMetersFrame_TitleButton_SetColorScheme;
				if ( index == DamageMeters_colorScheme ) then
					info.checked = 1;
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;	
		end

		local barCounts = {3,5,10,20,40};

		-- If this is the Bar count menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_BARCOUNT ) then
			local index;
			for index = 1, table.getn(barCounts) do
				info = {};
				info.text = barCounts[index];
				info.value = barCounts[index];
				info.func = DamageMetersFrame_TitleButton_SetCount;
				if ( info.value == DamageMeters_barCount ) then
					info.checked = 1;
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- Spacer
			info = {};
			info.disabled = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Show Max
			info = {};
			info.text = DM_MENU_SHOWMAX;
			if (DamageMeters_showMaxBars) then
				info.checked = 1;
			end
			info.func = DamageMeters_ToggleMaxBars;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			return;	
		end

		-- If this is the Bar auto count menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_AUTOCOUNTLIMIT ) then
			local index;
			for index = 1, table.getn(barCounts) do
				info = {};
				info.text = barCounts[index];
				info.value = barCounts[index];
				info.func = DamageMetersFrame_TitleButton_SetAutoCount;
				if ( info.value == DamageMeters_autoCountLimit ) then
					info.checked = 1;
				end
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;	
		end

		-- If this is the Bar auto count menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_REPORT ) then
			local reportTypes = {"f", "c", "s", "p", "r", "g"};
			local index;
			for index = 1, table.getn(reportTypes) do
				info = {};
				info.text = DM_MENU_REPORTNAMES[index];
				info.value = reportTypes[index];
				info.func = DamageMetersFrame_TitleButton_Report;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end

			-- Spacer
			info = {};
			info.disabled = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Reset Pos
			info = {};
			info.text = DM_MENU_HELP;
			info.notCheckable = 1;
			info.func = DamageMeters_ShowReportHelp;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			return;
		end

		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_MEMORY ) then
			-- Save
			info = {};
			info.text = DM_MENU_SAVE;
			info.notCheckable = 1;
			info.func = DamageMeters_Save;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Clear
			info = {};
			info.text = DM_MENU_CLEAR;
			info.notCheckable = 1;
			info.func = DamageMeters_MemClear;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Restore
			info = {};
			info.text = DM_MENU_RESTORE;
			info.notCheckable = 1;
			info.func = DamageMeters_Restore;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Merge
			info = {};
			info.text = DM_MENU_MERGE;
			info.notCheckable = 1;
			info.func = DamageMeters_Merge;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Swap
			info = {};
			info.text = DM_MENU_SWAP;
			info.notCheckable = 1;
			info.func = DamageMeters_Swap;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Accumulate
			info = {};
			info.text = DM_MENU_ACCUMULATEINMEMORY;
			if (DamageMeters_accumulateToMemory) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleAccumulateToMemory;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			return;
		end

		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_POSITION ) then
			-- Reset Pos
			info = {};
			info.text = DM_MENU_RESETPOS;
			info.notCheckable = 1;
			info.func = DamageMeters_ResetPos;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Lock Pos
			info = {};
			if (DamageMeters_positionLocked) then
				info.text = DM_MENU_UNLOCKPOS;
			else
				info.text = DM_MENU_LOCKPOS;
			end
			info.notCheckable = 1;
			info.func = DamageMeters_ToggleLockPos;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Resize left
			info = {};
			info.text = DM_MENU_RESIZELEFT;
			info.value = DamageMeters_Text_RANK;
			if (DamageMeters_resizeLeft) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleResizeLeft;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Resize left
			info = {};
			info.text = DM_MENU_RESIZEUP;
			info.value = DamageMeters_Text_RANK;
			if (DamageMeters_resizeUp) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleResizeUp;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			return;
		end

		if ( UIDROPDOWNMENU_MENU_VALUE == DM_MENU_TEXT ) then
			-- Rank
			info = {};
			info.text = DM_MENU_TEXTRANK;
			info.value = DamageMeters_Text_RANK;
			if (DamageMeters_textOptions[DamageMeters_Text_RANK]) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleTextOption;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Name
			info = {};
			info.text = DM_MENU_TEXTNAME;
			info.value = DamageMeters_Text_NAME;
			if (DamageMeters_textOptions[DamageMeters_Text_NAME]) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleTextOption;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Total %
			info = {};
			info.text = DM_MENU_TEXTPERCENTAGE;
			info.value = DamageMeters_Text_TOTALPERCENTAGE;
			if (DamageMeters_textOptions[DamageMeters_Text_TOTALPERCENTAGE]) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleTextOption;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Leader %
			info = {};
			info.text = DM_MENU_TEXTPERCENTAGELEADER;
			info.value = DamageMeters_Text_LEADERPERCENTAGE;
			if (DamageMeters_textOptions[DamageMeters_Text_LEADERPERCENTAGE]) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleTextOption;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Value
			info = {};
			info.text = DM_MENU_TEXTVALUE;
			info.value = DamageMeters_Text_VALUE;
			if (DamageMeters_textOptions[DamageMeters_Text_VALUE]) then
				info.checked = 1;
			end
			info.keepShownOnClick = 1;
			info.func = DamageMeters_ToggleTextOption;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

	
			-- Spacer
			info = {};
			info.disabled = 1;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			-- Cycle text
			info = {};
			info.text = DM_MENU_TEXTCYCLE;
			if (DamageMeters_textState > 0) then
				info.checked = 1;
			end
			info.func = DamageMeters_ToggleTextState;
			UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

			return;
		end
	end

	info = {};
	info.isTitle =  true;
	info.text = "DamageMeters "..DamageMeters_VERSIONSTRING;
	UIDropDownMenu_AddButton(info);

	-- Hide
	info = {};
	if (DamageMetersFrame:IsVisible()) then
		info.text = DM_MENU_HIDE;
	else
		info.text = DM_MENU_SHOW;
	end
	info.notCheckable = 1;
	info.func = DamageMetersBar_ToggleShow;
	UIDropDownMenu_AddButton(info);

	-- Pause
	info = {};
	if (DamageMeters_paused) then
		info.text = DM_MENU_UNPAUSE;
	else
		info.text = DM_MENU_PAUSE;
	end
	info.notCheckable = 1;
	info.func = DamageMeters_TogglePause;
	UIDropDownMenu_AddButton(info);

	-- Clear
	info = {};
	info.text = DM_MENU_CLEAR;
	info.notCheckable = 1;
	info.func = DamageMeters_Clear;
	UIDropDownMenu_AddButton(info);

	-- Lock
	info = {};
	if (DamageMeters_listLocked) then
		info.text = DM_MENU_UNLOCK;
	else
		info.text = DM_MENU_LOCK;
	end
	info.notCheckable = 1;
	info.func = DamageMeters_ToggleLock;
	UIDropDownMenu_AddButton(info);

	-- visible in party
	info = {};
	info.text = DM_MENU_VISINPARTY;
	if (DamageMeters_visibleOnlyInParty) then
		info.checked = 1;
	end
	info.keepShownOnClick = 1;
	info.func = DamageMeters_ToggleVisibleInParty;
	UIDropDownMenu_AddButton(info);

	-- Group members only
	info = {};
	info.text = DM_MENU_GROUPMEMBERSONLY;
	if (DamageMeters_groupMembersOnly) then
		info.checked = 1;
	end
	info.keepShownOnClick = 1;
	info.func = DamageMeters_ToggleGroupMembersOnly;
	UIDropDownMenu_AddButton(info);

	-- Add pet to player
	info = {};
	info.text = DM_MENU_ADDPETTOPLAYER;
	if (DamageMeters_addPetToPlayer) then
		info.checked = 1;
	end
	info.keepShownOnClick = 1;
	info.func = DamageMeters_ToggleAddPetToPlayer;
	UIDropDownMenu_AddButton(info);

	-- Reset on combat
	info = {};
	info.text = DM_MENU_RESETONCOMBATSTARTS;
	if (DamageMeters_resetWhenCombatStarts) then
		info.checked = 1;
	end
	info.keepShownOnClick = 1;
	info.func = DamageMeters_ToggleResetWhenCombatStarts;
	UIDropDownMenu_AddButton(info);


	-- Spacer
	info = {};
	info.disabled = 1;
	UIDropDownMenu_AddButton(info);

	-- Report
	info = {};
	info.text = DM_MENU_REPORT;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Position
	info = {};
	info.text = DM_MENU_POSITION;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Count
	info = {};
	info.text = DM_MENU_BARCOUNT;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Count
	info = {};
	info.text = DM_MENU_AUTOCOUNTLIMIT;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Sort
	info = {};
	info.text = DM_MENU_SORT;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Quantity
	info = {};
	info.text = DM_MENU_VISIBLEQUANTITY;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Bar Colors
	info = {};
	info.text = DM_MENU_COLORSCHEME;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- Bar Colors
	info = {};
	info.text = DM_MENU_MEMORY;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);

	-- text optionss
	info = {};
	info.text = DM_MENU_TEXT;
	--info.notClickable = 1;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);
end

--------------------------------------------

function DamageMetersFrame_TitleButton_OnLoad()
	DamageMeters_TitleButtonText:SetText("Damage Meters");
	-- Color tables not initialized yet.
	--local color = DamageMeters_quantityColor[DamageMeters_quantity];
	--DamageMetersFrame_TitleButton:SetBackdropColor(color[1], color[2], color[3], color[4]);
	this:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonUp");
end

function DamageMetersFrame_TitleButton_OnClick()
	local button = arg1;	

	--DMPrint("DamageMetersFrame_TitleButton_OnClick : "..button);

	if ( button  == "LeftButton" ) then
		if ( this:GetButtonState() == "PUSHED" ) then
			DamageMetersFrame:StopMovingOrSizing();
		else
			if (not DamageMeters_positionLocked and not DamageMetersFrame.isLocked) then
				DamageMetersFrame:StartMoving();
			end
		end
	elseif ( button == "RightButton" ) then
		local frame = this;

		local distance;
		distance = ( UIParent:GetWidth() - frame:GetRight() );
		
		--DMPrint("distance = "..distance);
		local menuMoveDist = 250;
		if ( distance <= menuMoveDist ) then
			local newOffset = distance - menuMoveDist;
			--DMPrint("Too close, new offset = "..newOffset);
			ToggleDropDownMenu(1, nil, DamageMetersFrameDropDown, "DamageMetersFrameDropDown", newOffset, 0);
		else
			ToggleDropDownMenu(1, nil, DamageMetersFrameDropDown, "DamageMetersFrameDropDown", 0, 0);
		end
	end
end

function DamageMetersFrame_TitleButton_SetSort()
	DamageMeters_SetSort(this.value);
end

function DamageMetersFrame_TitleButton_SetQuantity()
	DamageMeters_SetQuantity(this.value, true);
end

function DamageMetersFrame_TitleButton_SetColorScheme()
	DamageMeters_SetColorScheme(this.value);
end

function DamageMetersFrame_TotalButton_OnLoad()
	DamageMeters_TotalButtonText:SetText("Damage Meters");
end

function DamageMeters_ToggleTextOption()
	DamageMeters_textOptions[this.value] = not DamageMeters_textOptions[this.value];

	if (DamageMeters_textState > 0) then
		-- If we have turned off all text options, make sure we stop cycling.
		local option;
		for option = 1, DamageMeters_Text_MAX do
			if (DamageMeters_textOptions[option]) then
				return;
			end
		end
		-- Fell through...turn off cycling.
		DMPrintD("Turned off all text options: disabling text cycling.");
		DamageMeters_textState = 0;
	end
end

function DamageMeters_ToggleTextState()
	if (DamageMeters_textState < 1) then
		DamageMeters_textStateStartTime = GetTime();

		-- Set the text state to the first set option.
		local nextState;
		for nextState = 1, DamageMeters_Text_MAX do
			if (DamageMeters_textOptions[nextState]) then
				DamageMeters_textState = nextState;
				DMPrintD("Setting text state to "..DamageMeters_textState);
				return;
			end
		end

		-- Cycling enabled but no text options turned on: turn on the name option.
		DamageMeters_textOptions[DamageMeters_Text_NAME] = true;
		DamageMeters_textState = DamageMeters_Text_NAME;
		DMPrintD("Setting text state to (and enabling) "..DamageMeters_textState);
	else
		DamageMeters_textState = 0;
		DMPrintD("Setting text state to 0.");
	end
end

function DamageMeters_ToggleCycleVisibleQuant()
	if (DamageMeters_cycleVisibleQuantity) then
		DamageMeters_cycleVisibleQuantity = false;
	else
		DamageMeters_cycleVisibleQuantity = true;
		DamageMeters_currentQuantStartTime = GetTime();
	end
end

function DamageMeters_ShowNextQuantity()
	local newQuant = DamageMeters_quantity + 1;
	if (newQuant > DMI_MAX) then
		newQuant = 1;
	end
	DamageMeters_SetQuantity(newQuant, true);
end

function DamageMeters_ToggleVisibleInParty()
	DamageMeters_visibleOnlyInParty = not DamageMeters_visibleOnlyInParty;
	DamageMeters_UpdateVisibility();
end

function DamageMeters_ToggleGroupMembersOnly()
	DamageMeters_groupMembersOnly = not DamageMeters_groupMembersOnly;
end

function DamageMeters_ToggleAddPetToPlayer()
	DamageMeters_addPetToPlayer = not DamageMeters_addPetToPlayer;
	if (DamageMeters_addPetToPlayer) then
		DMPrint(DM_MSG_ADDINGPETTOPLAYER);
	else
		DMPrint(DM_MSG_NOTADDINGPETTOPLAYER);
		return;
	end

	-- This code automatically merges pet information into player's.

	local playerName = UnitName("Player");
	local playerIndex = DamageMeters_GetPlayerIndex(playerName);
	if (not playerIndex or playerIndex < 1) then
		DamageMeters_AddValue(playerName, 0, DM_DOT, DamageMeters_Relation_SELF, DamageMeters_Quantity_DAMAGE, "[Pet]");
		playerIndex = DamageMeters_GetPlayerIndex(playerName);
		if (not playerIndex or playerIndex < 1) then
			DMPrint(DM_ERROR_NOROOMFORPLAYER);
			return;
		end
	end
	local target = DamageMeters_table[playerIndex];

	local index;
	local tableN = table.getn(DamageMeters_table);
	for index = tableN, 1, -1 do
		local struct = DamageMeters_table[index];
		if (DamageMeters_Relation_PET == struct.relationship) then
			DMPrint(format(DM_MSG_PETMERGE, struct.player));

			local quantIndex;
			for quantIndex = 1, DMI_MAX do
				target[quantIndex] = target[quantIndex] + struct[quantIndex];
				target.hitCount[quantIndex] = target.hitCount[quantIndex] + struct.hitCount[quantIndex];
				target.critCount[quantIndex] = target.critCount[quantIndex] + struct.critCount[quantIndex];
			end
			
			target.lastTime = (target.lastTime > struct.lastTime) and target.lastTime or struct.lastTime;

			table.remove(DamageMeters_table, index);
			DamageMeters_frameNeedsToBeGenerated = true;
		end
	end
end

function DamageMetersFrame_TitleButton_SetCount()
	DamageMeters_SetCount(this.value);
end

function DamageMetersFrame_TitleButton_SetAutoCount()
	DamageMeters_SetAutoCount(this.value);
end

function DamageMetersFrame_TitleButton_Report()
	local command = format("%s%d", this.value, DamageMeters_barCount);
	DamageMeters_Report(command);
	CloseMenus();
end

--------------------------------------------

function DamageMeters_BarDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, DamageMeters_BarFrameDropDown_Initialize, "MENU");
end

function DamageMeters_BarFrameDropDown_Initialize()
	DamageMetersTooltip:Hide();

	-- Header
	info = {};
	if (DamageMeters_clickedBarIndex) then
		info.text = DamageMeters_table[DamageMeters_clickedBarIndex].player;
	else
		info.text = "";
	end
	info.notClickable = 1;
	info.isTitle = 1;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

	-- Delete
	info = {};
	info.text = DM_MENU_DELETE;
	info.notCheckable = 1;
	info.func = DamageMetersBar_DeleteEntry;
	UIDropDownMenu_AddButton(info);	

	-- Ban
	info = {};
	info.text = DM_MENU_BAN;
	info.notCheckable = 1;
	info.func = DamageMetersBar_BanEntry;
	UIDropDownMenu_AddButton(info);	

	-- Clear above
	info = {};
	info.text = DM_MENU_CLEARABOVE;
	info.notCheckable = 1;
	info.func = DamageMetersBar_ClearAboveEntry;
	UIDropDownMenu_AddButton(info);	

	-- Clear below
	info = {};
	info.text = DM_MENU_CLEARBELOW;
	info.notCheckable = 1;
	info.func = DamageMetersBar_ClearBelowEntry;
	UIDropDownMenu_AddButton(info);	
end

function DamageMetersBar_DeleteEntry()
	--DMPrint("DamageMetersBar_DeleteEntry "..this:GetName());

	DamageMeters_DoDelete(DamageMeters_clickedBarIndex);
end

function DamageMetersBar_BanEntry()
	--DMPrint("DamageMetersBar_BanEntry "..this:GetID());
	DamageMeters_DoBan(DamageMeters_clickedBarIndex);
	DamageMeters_clickedBarIndex = nil;
end

function DamageMetersBar_ClearAboveEntry()
	--DMPrint("DamageMetersBar_ClearAboveEntry "..this:GetID());

	local index;
	for index = 1, (DamageMeters_clickedBarIndex - 1) do
		table.remove(DamageMeters_table, 1);
	end

	DamageMeters_frameNeedsToBeGenerated = true;
	DamageMeters_clickedBarIndex = nil;
end

function DamageMetersBar_ClearBelowEntry()
	--DMPrint("DamageMetersBar_ClearBelowEntry");
	DamageMeters_Clear(DamageMeters_clickedBarIndex);
	DamageMeters_clickedBarIndex = nil;
end

function DamageMeters_DoDelete(index)
	table.remove(DamageMeters_table, index);
	DamageMeters_frameNeedsToBeGenerated = true;
	DamageMeters_clickedBarIndex = nil;
end

function DamageMeters_DoBan(index)
	if (index <= 0 or index > table.getn(DamageMeters_table)) then
		DMPrint(DM_ERROR_INVALIDARG);
		return;
	end

	DamageMeters_bannedTable[DamageMeters_table[index].player] = 1;
	DamageMeters_DoDelete(index);
end

function DamageMeters_ListBanned()
	local index, name, unused;
	index = 1;
	DMPrint(DM_MSG_LISTBANNED);
	for name, unused in DamageMeters_bannedTable do
		DMPrint(index..": "..name);
		index = index + 1;
	end
end

function DamageMeters_ClearBanned()
	DMPrint(DM_MSG_CLEARBANNED);
	DamageMeters_bannedTable = {};
end

function DamageMeters_IsBanned(newPlayer)
	local name, unused;
	for name, unused in DamageMeters_bannedTable do
		if (name == newPlayer) then
			return true;
		end
	end	

	return false;
end

function DamageMeters_CycleQuant()
	DamageMeters_quantity = DamageMeters_quantity + 1;
	if (DamageMeters_quantity > DamageMeters_Quantity_MAX) then
		DamageMeters_quantity = 1;
	end
	DamageMeters_SetBackgroundColor();
end

function DamageMeters_CycleQuantBack()
	DamageMeters_quantity = DamageMeters_quantity - 1;
	if (DamageMeters_quantity <= 0) then
		DamageMeters_quantity = DamageMeters_Quantity_MAX;
	end
	DamageMeters_SetBackgroundColor();
end

function DamageMetersBar_ToggleShow()
	if (DamageMetersFrame:IsVisible()) then
		DMPrint(DM_MSG_HOWTOSHOW);
	end

	DamageMeters_ToggleShow();
end

function DamageMeters_Sync()
	if (not DamageMeters_syncChannel or DamageMeters_syncChannel == "") then
		DMPrint(DM_ERROR_NOSYNCCHANNEL);
		return;
	end

	if (not DamageMeters_CheckSyncChan()) then
		return;
	end

	DamageMeters_SyncReport();
	DamageMeters_SyncRequest();
end

function DamageMeters_SyncReport()
	if (not DamageMeters_syncChannel or DamageMeters_syncChannel == "") then
		DMPrint(DM_ERROR_NOSYNCCHANNEL);
		return;
	end

	if (not DamageMeters_CheckSyncChan()) then
		return;
	end

	DMPrint(DM_MSG_SYNC);
	local channelName = GetChannelName(DamageMeters_syncChannel)
	
	SendChatMessage(DamageMeters_SYNCSTART, "CHANNEL", nil, channelName);

	--                                     1  2  3  4  5  6  7  8  9 10 11 12
	local formatStr = DMSYNC_PREFIX.." %s %d %d %d %d %d %d %d %d %d %d %d %d";
	for index, info in DamageMeters_table do

		local msg = format(formatStr, info.player, 
			info[DMI_DAMAGE], info[DMI_HEALING], info[DMI_DAMAGED], info[DMI_HEALED], 
			info.hitCount[DMI_DAMAGE], info.critCount[DMI_DAMAGE], 
			info.hitCount[DMI_HEALING], info.critCount[DMI_HEALING], 
			info.hitCount[DMI_DAMAGED], info.critCount[DMI_DAMAGED], 
			info.hitCount[DMI_HEALED], info.critCount[DMI_HEALED]);

		--[[ Can use this to test syncing by yourself
		local msg = format(formatStr, info.player.."X", 
			2 * info[DMI_DAMAGE], 2 * info[DMI_HEALING], 2 * info[DMI_DAMAGED], 2 * info[DMI_HEALED], 
			2 * info.hitCount[DMI_DAMAGE], 2 * info.critCount[DMI_DAMAGE], 
			2 * info.hitCount[DMI_HEALING], 2 * info.critCount[DMI_HEALING], 
			2 * info.hitCount[DMI_DAMAGED], 2 * info.critCount[DMI_DAMAGED], 
			2 * info.hitCount[DMI_HEALED], 2 * info.critCount[DMI_HEALED]);
		--]]--

		SendChatMessage(msg, "CHANNEL", nil, channelName);
	end
end

function DamageMeters_SyncChan(arg1)
	if (not arg1 or arg1 == "") then
		DMPrint(DM_ERROR_MISSINGARG);
	else
		DamageMeters_syncChannel = arg1;
		DMPrint(DM_MSG_SYNCCHAN..DamageMeters_syncChannel);
		-- Autojoin the channel.
		JoinChannelByName(DamageMeters_syncChannel, nil, DEFAULT_CHAT_FRAME:GetID());
	end
end

function DamageMeters_SyncRequest()
	if (not DamageMeters_CheckSyncChan()) then
		return;
	end

	local msg = DamageMeters_SYNCREQUEST;
	SendChatMessage(msg, "CHANNEL", nil, GetChannelName(DamageMeters_syncChannel));
end

function DamageMeters_SyncClear()
	if (not DamageMeters_CheckSyncChan()) then
		return;
	end	

	local msg = DamageMeters_SYNCCLEARREQUEST;
	SendChatMessage(msg, "CHANNEL", nil, GetChannelName(DamageMeters_syncChannel));
	DamageMeters_Clear();
end

function DamageMeters_CheckSyncChan()
	local channelName = GetChannelName(DamageMeters_syncChannel);
	--DMPrint("channelName = "..channelName);
	if (channelName == 0) then
		DMPrint(format(DM_ERROR_JOINSYNCCHANNEL, DamageMeters_syncChannel));
		return false;
	end

	return true;
end

function DamageMeters_Populate()
	local numPartyMembers = GetNumPartyMembers();
	local numRaidMembers = GetNumRaidMembers();

	local oldLocked = DamageMeters_listLocked;
	DamageMeters_listLocked = false;

	if (numRaidMembers > 0) then
		DamageMeters_AddDamage(UnitName("Player"), 0, false, DamageMeters_Relation_SELF);

		local name, rank, subgroup, level, class, fileName, zone, online, isDead;
		local i;
		for i = 1,numRaidMembers do
			name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);

			-- player, amount, crit, relationship, silent, healing)
			DamageMeters_AddDamage(name, 0, DM_DOT, DamageMeters_Relation_FRIENDLY);
		end
	elseif (numPartyMembers > 0) then
		DamageMeters_AddDamage(UnitName("Player"), 0, DM_DOT, DamageMeters_Relation_SELF);

		for i=1,5 do
			local partyUnitName = "party"..i;
			local partyName = UnitName(partyUnitName);
			if (partyName and partyName ~= "") then
				DamageMeters_AddDamage(partyName, 0, DM_DOT, DamageMeters_Relation_PARTY);
			end
		end	
	else
		DMPrint(DM_ERROR_POPNOPARTY);
	end

	DamageMeters_listLocked = oldLocked;
end

function DamageMeters_ToggleLock()
	DamageMeters_listLocked = not DamageMeters_listLocked;
	if (DamageMeters_listLocked) then
		DMPrint(DM_MSG_LOCKED);
	else
		DMPrint(DM_MSG_NOTLOCKED);
	end
end

function DamageMeters_TogglePause(silent)
	DamageMeters_paused = not DamageMeters_paused;
	if (not silent) then
		if (DamageMeters_paused) then
			DMPrint(DM_MSG_PAUSED);
		else
			DMPrint(DM_MSG_UNPAUSED);
		end
	end
	DamageMeters_SetBackgroundColor();
end

function DamageMeters_ToggleLockPos()
	DamageMeters_positionLocked = not DamageMeters_positionLocked;
	if (DamageMeters_positionLocked) then
		DamageMetersFrame:StopMovingOrSizing();
		DMPrint(DM_MSG_POSLOCKED);
	else
		DMPrint(DM_MSG_POSNOTLOCKED);
	end
end

function DamageMeters_SetQuantityColor()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][1] = r;
	DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][2] = g;
	DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][3] = b;
	DamageMeters_cycleVisibleQuantity = false;
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_SetQuantityColorOpacity()
	local alpha = 1.0 - OpacitySliderFrame:GetValue();
	DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][4] = alpha;
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_CancelQuantityColorSettings(previousValues)
	if ( previousValues.r ) then
		DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][1] = previousValues.r;
		DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][2] = previousValues.g;
		DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][3] = previousValues.b;
		if (previousValues.opacity) then
			--DMPrint("previousValues.opacity = "..previousValues.opacity);
			DamageMeters_quantityColor[UIDROPDOWNMENU_MENU_VALUE][4] = 1.0 - previousValues.opacity
		end
	end
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_SetQuantityColorAllOnClick()
	local frame = this:GetParent();

	frame.text = DM_MENU_SETCOLORFORALL;
	frame.func = DamageMeters_SetQuantityColorAll;
	frame.swatchFunc = DamageMeters_SetQuantityColorAll;
	frame.hasColorSwatch = 1;
	frame.r = DamageMeters_quantityColor[DamageMeters_quantity][1];
	frame.g = DamageMeters_quantityColor[DamageMeters_quantity][2];
	frame.b = DamageMeters_quantityColor[DamageMeters_quantity][3];
	frame.hasOpacity = 1;
	frame.opacity = 1.0 - DamageMeters_quantityColor[DamageMeters_quantity][4];
	frame.opacityFunc = DamageMeters_SetQuantityColorOpacityAll;
	frame.notCheckable = 1;

	ColorPickerFrame.frame = frame;
	CloseMenus();
	UIDropDownMenuButton_OpenColorPicker(frame);
end

function DamageMeters_SetDefaultColors()
	DamageMeters_quantityColor = {};
	local index, value;
	for index, value in DamageMeters_quantityColorDefault do
		DamageMeters_quantityColor[index] = {};
		local index2, value2;
		for index2, value2 in value do
			DamageMeters_quantityColor[index][index2] = value2;
			--DMPrint("DamageMeters_quantityColor["..index.."]["..index2.."] = "..value2);
		end
	end
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_SetQuantityColorAll()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local index;
	for index = 1, DamageMeters_Quantity_MAX do
		DamageMeters_quantityColor[index][1] = r;
		DamageMeters_quantityColor[index][2] = g;
		DamageMeters_quantityColor[index][3] = b;
	end
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_SetQuantityColorOpacityAll()
	local alpha = 1.0 - OpacitySliderFrame:GetValue();
	local index;
	for index = 1, DamageMeters_Quantity_MAX do
		DamageMeters_quantityColor[index][4] = alpha;
	end
	DamageMeters_frameNeedsToBeGenerated = true;
end

function DamageMeters_ToggleResetWhenCombatStarts()
	DamageMeters_resetWhenCombatStarts = not DamageMeters_resetWhenCombatStarts;
	-- Only print message if we weren't called from the menu option.
	if (not this.value) then
		DMPrint(DM_MSG_RESETWHENCOMBATSTARTSCHANGE..(DamageMeters_resetWhenCombatStarts and DM_MSG_TRUE or DM_MSG_FALSE));
	end
end

function DamageMeters_OnCombatStart()
	DamageMeters_combatStartTime = GetTime();
	DamageMeters_combatEndTime = DamageMeters_combatStartTime;
	DamageMeters_inCombat = true;
	--DMPrintD("Starting combat...");

	local index, value;
	for index, value in DamageMeters_table do
		value.damageThisCombat = 0;
	end
end

function DamageMeters_OnCombatEnd()
	DamageMeters_combatEndTime = GetTime();
	--DMPrintD("Ending combat, duration = "..(DamageMeters_combatEndTime - DamageMeters_combatStartTime));
	DamageMeters_inCombat = false;
end

function DamageMeters_GetCombatDPS(combatDamage)
	local combatTime = DamageMeters_combatEndTime - DamageMeters_combatStartTime;
	if (combatTime <= 1.0) then
		combatTime = 1.0;
	end
	return combatDamage / combatTime;
end

function DamageMeters_OpenReportFrame()
	CloseDropDownMenus();

	ShowUIPanel(DMReportFrame);
	DMReportFrame:SetBackdropColor(0, 0, 0, 1);
	DMSendMailScrollFrame:SetBackdropColor(0, 0, 0, 1);
	DamageMeters_UpdateReportText();
end

function DamageMeters_UpdateReportText()
	DMReportFrame_SendMailBodyEditBox:SetText(DamageMeters_reportBuffer);
	DMReportFrame_SendMailBodyEditBox:SetFocus("");
	DMReportFrame_SendMailBodyEditBox:HighlightText();
end

function DamageMeters_ReportTypeDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, DamageMeters_ReportTypeDropDown_Initialize, "MENU");
end

function DamageMeters_ReportTypeDropDown_Initialize()
	local index;
	for index = 1,DamageMeters_Quantity_MAX do
		info = {};
		info.text = DamageMeters_Quantity_STRING[index];
		info.value = index;
		info.func = DamageMeters_ReportFrame_DoReport;
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info);
	end	

	info = {};
	info.text = DM_MENU_TOTAL;
	info.value = DamageMeters_ReportQuantity_Total;
	info.func = DamageMeters_ReportFrame_DoReport;
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = DM_MENU_LEADERS;
	info.value = DamageMeters_ReportQuantity_Leaders;
	info.func = DamageMeters_ReportFrame_DoReport;
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info);
end

function DamageMeters_ReportFrame_DoReport()
	DamageMeters_DoReport(this.value, "BUFFER", false, DamageMeters_TABLE_MAX, "");
	DamageMeters_UpdateReportText();
end

function DamageMeters_ReportTypeButton_OnClick()
	ToggleDropDownMenu(1, nil, DMReportTypeDropDown, "DMReportTypeDropDown", 0, 0);
end

function DamageMeters_ShowReportFrame()
	DamageMeters_Report("f");
end

function DamageMeters_DumpContributors()
	local playerName, unused;
	DMPrint(table.getn(DamageMeters_contributorList).." contributors:");
	for playerName, unused in DamageMeters_contributorList do
		DMPrint(" "..playerName);
	end
end

--ToDo: localize, add command.
function DamageMeters_DumpFull(arg1)
	local playerName, struct, quantity, list, spell, value;
	local str;

	local destination = "BUFFER";
	local tellTarget = "";
	if (arg1 ~= "") then
		destination = arg1;
		DMPrint("Destination = "..destination);
	end

	DamageMeters_reportBuffer = "";

	for playerName, struct in DamageMeters_fullTable do
		str = "Player "..playerName;
		DamageMeters_SendReportMsg(str, destination, tellTarget);
		
		for quantity, list in struct do
			str = "  "..DamageMeters_Quantity_STRING[quantity];
			DamageMeters_SendReportMsg(str, destination, tellTarget);

			local total = 0;
			for spell, value in list do
				str = "    "..spell.." = "..value;
				total = total + value;
				DamageMeters_SendReportMsg(str, destination, tellTarget);
			end

			str = "  TOTAL = "..total;
			DamageMeters_SendReportMsg(str, destination, tellTarget);
		end
	end

	if (destination == "BUFFER") then
		DamageMeters_OpenReportFrame();
	end
end

function DamageMeters_ShowVersion()
	DMPrint(string.format(DM_MSG_VERSION, DamageMeters_VERSIONSTRING));
end

function DamageMeters_ShowReportHelp()
	DamageMeters_reportBuffer = DM_MSG_REPORTHELP;
	DamageMeters_OpenReportFrame();
	DMReportFrame_SendMailBodyEditBox:HighlightText(0, 0)
end

function DamageMeters_ToggleAccumulateToMemory()
	DamageMeters_accumulateToMemory = not DamageMeters_accumulateToMemory;	
	DMPrintD("Accumulate = "..(DamageMeters_accumulateToMemory and "true" or "false"));
end

function DamageMeters_ToggleTotal()
	if (DamageMeters_showTotal) then
		DamageMeters_showTotal = false;
		DamageMetersFrame_TotalButton:Hide();
	else
		DamageMeters_showTotal = true;
		DamageMetersFrame_TotalButton:Show();
	end
end

function DamageMeters_SendSyncMsg(arg1)
	if (not DamageMeters_CheckSyncChan()) then
		return;
	end

	if (not arg1 or arg1 == "") then
		DMPrint(DM_ERROR_MISSINGARG);
		return;
	end

	DMPrint(format(DM_MSG_SYNCMSG, UnitName("Player"), arg1), DamageMeters_SYNCMSGCOLOR);

	local msg = DamageMeters_SYNCMSG..arg1;
	SendChatMessage(msg, "CHANNEL", nil, GetChannelName(DamageMeters_syncChannel));
end

function DamageMeters_ToggleMaxBars(bSilent)
	DamageMeters_showMaxBars = not DamageMeters_showMaxBars;
	if (DamageMeters_showMaxBars) then
		DamageMeters_savedBarCount = DamageMeters_barCount;
	else
		DamageMeters_barCount = DamageMeters_savedBarCount;
	end
	DamageMeters_frameNeedsToBeGenerated = true;
	if (not bSilent) then
		DMPrint(format(DM_MSG_MAXBARS, (DamageMeters_showMaxBars and DM_MSG_TRUE or DM_MSG_FALSE)));
	end
end

function DamageMeters_ToggleResizeLeft()
	DamageMeters_resizeLeft = not DamageMeters_resizeLeft;
end

function DamageMeters_ToggleResizeUp()
	DamageMeters_resizeUp = not DamageMeters_resizeUp;
end

function DamageMetersFrame_OnEvent()

	if (event == "VARIABLES_LOADED") then
		-- If the saved data is of a different version clear the table.
		if (DamageMeters_loadedDataVersion ~= DamageMeters_VERSION) then
			DamageMeters_table = {};
			DamageMeters_savedTable = {};
			DamageMeters_loadedDataVersion = DamageMeters_VERSION;
		end

		-- Reset the ages, as age values from old sessions are pointless.
		-- Reset the combat dmg too.
		local index, value;
		local now = GetTime();
		for index, value in DamageMeters_table do
			value.lastTime = now;
			value.damageThisCombat = 0;
		end
		for index, value in DamageMeters_savedTable do
			value.lastTime = now;
		end

		DamageMeters_Reset();

		DamageMeters_textStateStartTime = GetTime();
		DamageMeters_currentQuantStartTime = DamageMeters_textStateStartTime;

		if (not DamageMeters_isVisible) then
			DamageMeters_Hide();
		elseif (not DamageMeters_showTotal) then
			DamageMetersFrame_TotalButton:Hide();
		end

		-- Intro text.
		DamageMeters_ShowVersion();
		if (DamageMeters_accumulateToMemory) then
			DMPrint(DM_MSG_ACCUMULATING);
		end
		if (DamageMeters_enableDebugPrint) then
			DMPrintD("DamageMeters: Debug enabled.");
		end

		-- This is a hack--if the frame is initially hidden the stupid dropdown 
		-- menu doesn't work right and needs to be opened twice to be seen the first
		-- time.
		DMReportFrame:Hide();
		
		return;
	end

	-----------------------

	if ( event == "PARTY_MEMBERS_CHANGED" ) then
		DamageMeters_UpdateVisibility();
		return;
	end

	if ( event == "RAID_ROSTER_UPDATE" ) then
		DamageMeters_UpdateVisibility();
		DamageMeters_UpdateRaidMemberClasses();
		return;
	end

	if ( event == "PLAYER_REGEN_DISABLED" ) then
		--DamageMeters_startCombatOnNextValue = true;
		return;
	end
	if ( event == "PLAYER_REGEN_ENABLED" ) then
		if (DamageMeters_inCombat) then
			DamageMeters_OnCombatEnd();
		end
		DamageMeters_startCombatOnNextValue = true;
		return;
	end

	-----------------------

	if (event == "CHAT_MSG_CHANNEL") then
		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];
		
		--DMPrint("CHAT_MSG_CHANNEL: "..info.id);

		local channelLength = strlen(arg4);
		if ( (strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and (arg1 ~= "INVITE") ) then

			if (info and (arg9 == DamageMeters_syncChannel)) then
				-- arg2 = source, arg9 = channel name
				--DMPrint("arg2 = "..arg2..", arg3 = "..arg3..", arg4 = "..arg4);
				--DMPrint("arg5 = "..arg5..", arg6 = "..arg6..", arg7 = "..arg7);
				--DMPrint("arg8 = "..arg8..", arg9 = "..arg9);
				--DMPrint("arg7 = "..arg7..", arg9 = "..arg9);

				local sender = string.lower(arg2);

				-- Ignore messages from ourself.
				if (not DamageMeters_syncSelf) then
					if (arg2 == UnitName("Player")) then
						return;
					end
				end
				
				local msg = arg1;
				if (msg == DamageMeters_SYNCREQUEST) then
					local now = GetTime();
					if (now - DamageMeters_lastSyncTime > DamageMeters_MINSYNCCOOLDOWN) then
						DMPrint(DM_MSG_SYNCREQUESTACK..arg2);
						DamageMeters_lastSyncTime = now;
						DamageMeters_SyncReport();
					else
						DMPrint(DM_ERROR_SYNCTOOSOON);
					end
					return;
				elseif (msg == DamageMeters_SYNCCLEARREQUEST) then
					DMPrint(DM_MSG_CLEARRECEIVED..arg2);
					DamageMeters_Clear();
					return;
				elseif (msg == DamageMeters_SYNCSTART) then
					DMPrint(format(DM_MSG_RECEIVEDSYNCDATA, arg2));
				elseif (strsub(msg, 1, string.len(DamageMeters_SYNCMSG)) == DamageMeters_SYNCMSG) then
					local syncMsg = strsub(msg, string.len(DamageMeters_SYNCMSG) + 1);
					DMPrint(format(DM_MSG_SYNCMSG, arg2, syncMsg), DamageMeters_SYNCMSGCOLOR);
				elseif (strsub(msg, 1, string.len(DMSYNC_PREFIX)) == DMSYNC_PREFIX) then
					local player, damage, damaged, healing, healed, hitCountDmg, critCountDmg, hitCountHeal, critCountHeal, hitCountDamaged, critCountDamaged, hitCountHealed, critCountHealed;
					--                                 name dmg   dmged  heal  hld  dmgh  dmgc  hlh   hlc   dmdh  dmdc  hldh  hldc
					local formatStr = DMSYNC_PREFIX.." (.+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)";
					for		player, 
							damage, healing, damaged, healed, 
							hitCountDmg, critCountDmg, 
							hitCountHeal, critCountHeal, 
							hitCountDamaged, critCountDamaged, 
							hitCountHealed, critCountHealed 
								in string.gfind(msg, formatStr) do
						local incQuant = {};
						local incHitCount = {};
						local incCritCount = {};
						incQuant[DMI_DAMAGE] = tonumber(damage);
						incQuant[DMI_HEALING] = tonumber(healing);
						incQuant[DMI_DAMAGED] = tonumber(damaged);
						incQuant[DMI_HEALED] = tonumber(healed);
						incHitCount[DMI_DAMAGE] = tonumber(hitCountDmg);
						incCritCount[DMI_DAMAGE] = tonumber(critCountDmg);
						incHitCount[DMI_HEALING] = tonumber(hitCountHeal);
						incCritCount[DMI_HEALING] = tonumber(critCountHeal);
						incHitCount[DMI_DAMAGED] = tonumber(hitCountDamaged);
						incCritCount[DMI_DAMAGED] = tonumber(critCountDamaged);
						incHitCount[DMI_HEALED] = tonumber(hitCountHealed);
						incCritCount[DMI_HEALED] = tonumber(critCountHealed);

						--[[
						DMPrint("S: "..msg);
						DMPrint(format("O: %s %s %d %d %d %d %d %d %d %d %d %d %d %d", 
							DMSYNC_PREFIX,
							player, 
							incQuant[1], incQuant[2], incQuant[3], incQuant[4], 
							incHitCount[1], incCritCount[1], 
							incHitCount[2], incCritCount[2], 
							incHitCount[3], incCritCount[3], 
							incHitCount[4], incCritCount[4]));
						]]--

						-- We have recieved data from a contributor: add him/her to the list.
						DamageMeters_contributorList[arg2] = true;
						DamageMeters_haveContributors = true;

						local index = DamageMeters_GetPlayerIndex(player);
						if (index) then
							local localStruct = DamageMeters_table[index];

							local quantIndex;
							for quantIndex = 1, DMI_MAX do
								if (incQuant[quantIndex] > localStruct[quantIndex]) then
									DMPrintD("DMSYNC: "..player.."["..DamageMeters_Quantity_STRING[quantIndex].."] "..localStruct[quantIndex].." -> "..incQuant[quantIndex]);
									localStruct[quantIndex] = incQuant[quantIndex];
								end

								if (incHitCount[quantIndex] > localStruct.hitCount[quantIndex]) then
									DMPrintD("DMSYNC: "..player.."["..DamageMeters_Quantity_STRING[quantIndex].." hits] "..localStruct.hitCount[quantIndex].." -> "..incHitCount[quantIndex]);
									localStruct.hitCount[quantIndex] = incHitCount[quantIndex];
								end
								if (incCritCount[quantIndex] > localStruct.critCount[quantIndex]) then
									DMPrintD("DMSYNC: "..player.."["..DamageMeters_Quantity_STRING[quantIndex].." crits] "..localStruct.critCount[quantIndex].." -> "..incCritCount[quantIndex]);
									localStruct.critCount[quantIndex] = incCritCount[quantIndex];
								end
							end
						else
							-- There is a problem: if the other player is parsing damage for our pet
							-- we could erroneously add it again to our own if we have the option turned 
							-- on.  This condition attempts to fix that problem.
							if (DamageMeters_addPetToPlayer and player == UnitName("Pet")) then
								return;
							end

							DamageMeters_AddValue(player, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, DamageMeters_Quantity_DAMAGE, "[Sync]");
							index = DamageMeters_GetPlayerIndex(player);
							if (index) then
								local quantIndex;
								for quantIndex = 1, DMI_MAX do
									DamageMeters_table[index][quantIndex] = incQuant[quantIndex];
									DamageMeters_table[index].hitCount[quantIndex] = incHitCount[quantIndex];
									DamageMeters_table[index].critCount[quantIndex] = incCritCount[quantIndex];
								end
							end
							DMPrintD("DMSYNC: Added new player, "..player..".");
						end
					end
				end
			end
		end

		return;
	end

	---------------------------

	if (DamageMeters_paused) then
		return;
	end

	DamageMeters_ParseMessage(arg1, event);

	---------------------------
end

--[[ 


]]--

