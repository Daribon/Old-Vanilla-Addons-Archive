--[[
--
--	DamageMeters Localization Data (ENGLISH)
--
--]]

-- General --
DamageMeters_PRINTCOLOR = "|cFF8F8FFF"

-- Bindings --
BINDING_HEADER_DAMAGEMETERSHEADER 		= "DamageMeters";
BINDING_NAME_DAMAGEMETERS_TOGGLESHOW	= "Toggle Visible";
BINDING_NAME_DAMAGEMETERS_CYCLEQUANT	= "Cycle Visible Quantity";
BINDING_NAME_DAMAGEMETERS_CYCLEQUANTBACK= "Cycle Visible Quantity Backwards";
BINDING_NAME_DAMAGEMETERS_CLEAR			= "Clear Data";
BINDING_NAME_DAMAGEMETERS_TOGGLEPAUSED	= "Toggle Paused";
BINDING_NAME_DAMAGEMETERS_SHOWREPORTFRAME = "Show Report Frame";
BINDING_NAME_DAMAGEMETERS_SWAPMEMORY	= "Swap Memory";
BINDING_NAME_DAMAGEMETERS_TOGGLESHOWMAX	= "Toggle Show Max Bars";

-- Help --
DamageMeters_helpTable = {
		"The following commands can be entered into the console:",
		"/dmhelp : Lists available /dm (Damage Meters) commands.",
		"/dmshow : Toggles whether or not the meters are visible.  Note that data collection continues when meters are not visible.",
		"/dmhide : Hides the meters.",
		"/dmclear [#] : Removes entries from the bottom of the list, leaving #.  If # not specified, entire list is cleared.",
		"/dmreport [help] [total] [c/s/p/r/w/h/g/f[#]] [whispertarget/channelNAME] - Prints a report of the current data: use '/dmreport help' for details.",
		"/dmsort [#] - Sets sorting style.  Specify no number for a list of available styles.",
		"/dmcount [#] - Sets number of bars visible at once.  If # not given shows the maximum possible.",
		"/dmsave - Saves the current table internally.",
		"/dmrestore - Restores a previously saved table, overwriting any new data.",
		"/dmmerge - Merges a previously saved table with any existing data.",
		"/dmswap - Swaps the previously saved table with the current one.",
		"/dmmemclear - Clears the saved table.",
		"/dmresetpos - Resets the position of the window (helpful incase you lose it).",
		"/dmtext 0/<[r][n][p][l][v]> - Sets what text should be shown on the bars. r - Rank. n - Player name. p - Percentage of total. l - Percentage of leader. v - Value.",
		"/dmcolor # - Sets the color scheme for the bars.  Specify no # for a list of options.",
		"/dmquant # - Sets the quantity the bars should use.  Specify no # for a list of options.",
		"/dmvisinparty [y/n] - Sets whether or not the window should only be visible while you are in a party/raid.  Specify no argument to toggle.",
		"/dmautocount # - If # is greater than zero, then the window will show as many bars as it has information for up to #.  If # is zero, it turns off the auto-count function.",
		"/dmlistbanned - Lists all banned damage sources.",
		"/dmclearbanned - Clears list of all banned damage sources.",
		"/dmsync - Causes you to synchronize your data with other users using the same sync channel.  (Calls dmsyncsend and dmsyncrequest.)",
		"/dmsyncchan - Sets the name of the channel to use for synchronizing.",
		"/dmsyncsend - Sends sync information on the sync channel.",
		"/dmsyncrequest - Sends request for an automatic dmsync to other people using your sync channel.",
		"/dmsyncclear - Sends request for everyone to clear their data.",
		"/dmsyncmsg msg - Sends a message to other people in the same syncchan.  Can also use /dmm.",
		"/dmpop - Populates it with your current party/raid members (though will not remove any existing entries).",
		"/dmlock - Toggles whether or not the list is locked. New people cannot be added to a locked list, but people already in can are updated.",
		"/dmpause - Toggles whether or not the parsing of data is to occur.",
		"/dmlockpos - Toggles whether or not the position of the window is locked.",
		"/dmgrouponly - Toggles whether or not to reject anyone who is not in your raid/party.  (Your pet will be monitored regardless of this setting.)",
		"/dmaddpettoplayer - Toggles whether or not to consider pet's data as coming directly from the player.",
		"/dmresetoncombat = Toggles whether or not to reset data when combat starts.",
		"/dmversion - Shows version information.",
		"/dmtotal - Toggles display of the total display.",
		"/dmshowmax - Toggles whether or not to show the max number of bars."
};

-- Filters --
DamageMeters_Filter_STRING1 = "party members";
DamageMeters_Filter_STRING2 = "all friendly characters";

-- Relationships --
DamageMeters_Relation_STRING = {
		"Self",
		"Your Pet",
		"Party",
		"Friendly"};

-- Color Schemes -- 
DamageMeters_colorScheme_STRING = {
		"Relationship",
		"Class Colors"};

-- Quantities -- 
DamageMeters_Quantity_STRING = {
		"Damage Done",
		"Healing Done",
		"Damage Taken",
		"Healing Taken",
		"Idle Time",
		"DPS"};

-- Sort --
DamageMeters_Sort_STRING = {
		"Decreasing", 
		"Increasing",
		"Alphabetical"};

-- Class Names
function DamageMeters_GetClassColor(className)
	return RAID_CLASS_COLORS[string.upper(className)];
end

-- Errors --
DM_ERROR_INVALIDARG = "DamageMeters: Invalid argument(s).";
DM_ERROR_MISSINGARG = "DamageMeters: Argument(s) missing.";
DM_ERROR_NOSAVEDTABLE = "DamageMeters: No saved table.";
DM_ERROR_BADREPORTTARGET = "DamageMeters: Invalid report target = ";
DM_ERROR_MISSINGWHISPERTARGET = "DamageMeters: Whisper specified but no player given.";
DM_ERROR_MISSINGCHANNEL = "DamageMeters: Channel specified but no number given.";
DM_ERROR_NOSYNCCHANNEL = "DamageMeters: Sync channel must be specified with dmsyncchan before calling dmsync.";
DM_ERROR_JOINSYNCCHANNEL = "DamageMeters: You must join sync channel ('%s') before you can call dmsync.";
DM_ERROR_SYNCTOOSOON = "DamageMeters: Sync request too soon after last one; ignoring.";
DM_ERROR_POPNOPARTY = "DamageMeters: Cannot populate table; you are not in a party or raid.";
DM_ERROR_NOROOMFORPLAYER = "DamageMeters: Cannot merge pet data with players because cannot add player to list (list full?).";

-- Messages --
DM_MSG_SETQUANT = "DamageMeters: Setting visible quantity to ";
DM_MSG_CURRENTQUANT = "DamageMeters: Current quantity = ";
DM_MSG_CURRENTSORT = "DamageMeters: Current sort = ";
DM_MSG_SORT = "DamageMeters: Setting sort to ";
DM_MSG_CLEAR = "DamageMeters: Removing %d to %d.";
DM_MSG_REMAINING = "DamageMeters: %d items remaining.";
DM_MSG_REPORTHEADER = "Damage Meters: <%s> report on %d/%d sources:";
DM_MSG_SETCOUNTTOMAX = "DamageMeters: No count argument specified, setting to max.";
DM_MSG_SETCOUNT = "DamageMeters: New bar count = ";
DM_MSG_RESETFRAMEPOS = "DamageMeters: Resetting frame position.";
DM_MSG_SAVE = "DamageMeters: Saving table.";
DM_MSG_RESTORE = "DamageMeters: Restoring saved table.";
DM_MSG_MERGE = "DamageMeters: Merging saved table with current.";
DM_MSG_SWAP = "DamageMeters: Swapping normal (%d) and saved (%d) table.";
DM_MSG_SETCOLORSCHEME = "DamageMeters: Setting color scheme to ";
DM_MSG_TRUE = "true";
DM_MSG_FALSE = "false";
DM_MSG_SETVISINPARTY = "DamageMeters: Visible-only-in-party is set to ";
DM_MSG_SETAUTOCOUNT = "DamageMeters: Setting new autocount limit to ";
DM_MSG_LISTBANNED = "DamageMeters: Listing banned damage sources:";
DM_MSG_CLEARBANNED = "DamageMeters: Clearing all banned damage sources.";
DM_MSG_HOWTOSHOW = "DamageMeters: Hiding window.  Use /dmshow to make it visible again.";
DM_MSG_SYNCCHAN = "DamageMeters: Synchronization channel name set to ";
DM_MSG_SYNCREQUESTACK = "DamageMeters: Sync requested from player ";
DM_MSG_SYNC = "DamageMeters: Sending sync information.";
DM_MSG_LOCKED = "DamageMeters: List now locked.";
DM_MSG_NOTLOCKED = "DamageMeters: List unlocked.";
DM_MSG_PAUSED = "DamageMeters: Parsing paused.";
DM_MSG_UNPAUSED = "DamageMeters: Parsing resumed.";
DM_MSG_POSLOCKED = "DamageMeters: Position locked.";
DM_MSG_POSNOTLOCKED = "DamageMeters: Position unlocked.";
DM_MSG_CLEARRECEIVED = "DamageMeters: Clear request received from player ";
DM_MSG_ADDINGPETTOPLAYER = "DamageMeters: Now treating pet data as though it was yours.";
DM_MSG_NOTADDINGPETTOPLAYER = "DamageMeters: Pet data now treated separately from yours.";
DM_MSG_PETMERGE = "DamageMeters: Merging pet's (%s) information into your's.";
DM_MSG_RESETWHENCOMBATSTARTSCHANGE = "DamageMeters: Reset when combat starts = ";
DM_MSG_COMBATDURATION = "Combat duration = %.2f seconds.";
DM_MSG_RECEIVEDSYNCDATA = "DamageMeters: Receiving Sync data from %s.";
DM_MSG_TOTAL = "TOTAL";
DM_MSG_VERSION = "DamageMeters Version %s Active.";
DM_MSG_REPORTHELP = "The /dmreport command consists of three parts:\n\n1) The destination character.  This can be one of the following letters:\n  c - Console (only you can see it).\n  s - Say\n  p - Party chat\n  r - Raid chat\n  g - Guild chat\n  h - Chat cHannel. /dmreport h mychannel\n  w - Whisper to player.  /dmreport w dandelion\n  f - Frame: Shows the report in this window.\n\nIf the letter is lower case the report will be in reverse order (lowest to highest).\n\n2) Optionally, the number of people to limit it to.  This number goes right after the destination character.\nExample: /dmreport p5.\n\n3) By default, reports are on the currently visible quantity only.  If the word 'total' is specified before the destination character, though, the report will be on the totals for every quantity. 'Total' reports are formatted so that they look good when cut-and-paste into a text file, and so work best with the Frame destination.\nExample: /dmreport total f\n\nExample: Whisper to player 'dandelion' the top three people in the list:\n/dmreport w3 dandelion";
DM_MSG_COLLECTORS = "Data collectors: (%s)";
DM_MSG_ACCUMULATING = "DamageMeters: Accumulating data in memory register.";
DM_MSG_REPORTTOTALDPS = "Total = %.1f (%.1f visible)";
DM_MSG_REPORTTOTAL = "Total = %d (%d visible)";
DM_MSG_SYNCMSG = "[%s] sends: %s";
DM_MSG_MEMCLEAR = "DamageMeters: Saved table cleared.";
DM_MSG_MAXBARS = "DamageMeters: Setting show-max-bars to %s.";
DM_MSG_LEADERREPORTHEADER = "DamageMeters: Leaders Report on %d/%d Sources:\n #";
DM_MSG_FULLREPORTHEADER = "DamageMeters: Full Report on %d/%d Sources:\n\nPlayer        Damage     Healing     Damaged      Healed        Hits   Crits\n_______________________________________________________________________________";

--[[ Note: This is only to help construct the DM_MSG_REPORTHELP string.
The /dmreport command consists of three parts:

1) The destination character.  This can be one of the following letters:
  c - Console (only you can see it).
  s - Say
  p - Party chat
  r - Raid chat
  g - Guild chat
  h - Chat cHannel. /dmreport h mychannel
  w - Whisper to player.  /dmreport w dandelion
  f - Frame: Shows the report in this window.

If the letter is lower case the report will be in reverse order (lowest to highest).

2) Optionally, the number of people to limit it to.  This number goes right after the destination character.
Example: /dmreport p5

3) By default, reports are on the currently visible quantity only.  If the word 'total' is specified before the destination character, though, the report will be on the totals for every quantity. 'Total' reports are formatted so that they look good when cut-and-paste into a text file, and so work best with the Frame destination.
Example: /dmreport total f

Example: Whisper to player "dandelion" the top three people in the list:
/dmreport w3 dandelion
]]--

-- Menu Options --
DM_MENU_CLEAR = "Clear";
DM_MENU_RESETPOS = "Reset Position";
DM_MENU_HIDE = "Hide Window";
DM_MENU_SHOW = "Show Window";
DM_MENU_VISINPARTY = "Visible Only While In A Party";
DM_MENU_REPORT = "Report";
DM_MENU_BARCOUNT = "Bar Count";
DM_MENU_AUTOCOUNTLIMIT = "Auto Count Limit";
DM_MENU_SORT = "Sort Type";
DM_MENU_VISIBLEQUANTITY = "Visible Quantity";
DM_MENU_COLORSCHEME = "Color Scheme";
DM_MENU_MEMORY = "Memory Register";
DM_MENU_SAVE = "Save";
DM_MENU_RESTORE = "Restore";
DM_MENU_MERGE = "Merge";
DM_MENU_SWAP = "Swap";
DM_MENU_DELETE = "Delete";
DM_MENU_BAN = "Ban";
DM_MENU_CLEARABOVE = "Clear Above";
DM_MENU_CLEARBELOW = "Clear Below";
DM_MENU_LOCK = "Lock List";
DM_MENU_UNLOCK = "Unlock List";
DM_MENU_PAUSE = "Pause Parsing";
DM_MENU_UNPAUSE = "Resume Parsing";
DM_MENU_LOCKPOS = "Lock Position";
DM_MENU_UNLOCKPOS = "Unlock Position";
DM_MENU_GROUPMEMBERSONLY = "Only Monitor Group Members";
DM_MENU_ADDPETTOPLAYER = "Treat Pet Data As Your Data";
DM_MENU_TEXT = "Text Options";
DM_MENU_TEXTRANK = "Rank";
DM_MENU_TEXTNAME = "Name";
DM_MENU_TEXTPERCENTAGE = "% of Total";
DM_MENU_TEXTPERCENTAGELEADER = "% of Leader's";
DM_MENU_TEXTVALUE = "Value";
DM_MENU_SETCOLORFORALL = "Set Color For All";
DM_MENU_DEFAULTCOLORS = "Restore Default Colors";
DM_MENU_RESETONCOMBATSTARTS = "Reset Data When Combat Starts";
DM_MENU_REFRESHBUTTON = "Refresh";
DM_MENU_TOTAL = "Total";
DM_MENU_CHOOSEREPORT = "Choose Report";
-- Note reordered this list in version 2.2.0
DM_MENU_REPORTNAMES = {"Frame", "Console", "Say", "Party", "Raid", "Guild"};
DM_MENU_TEXTCYCLE = "Cycle";
DM_MENU_QUANTCYCLE = "Cycle";
DM_MENU_HELP = "Help";
DM_MENU_ACCUMULATEINMEMORY = "Accumulate Data";
DM_MENU_POSITION = "Position";
DM_MENU_RESIZELEFT = "Resize Left";
DM_MENU_RESIZEUP = "Resize Up";
DM_MENU_SHOWMAX = "Show Max";
DM_MENU_SHOWTOTAL = "Show Total";
DM_MENU_LEADERS = "Leaders";

-- Misc
DM_CLASS = "Class"; -- The word for player class, like Druid or Warrior.
DM_TOOLTIP = "\nTime since last action = %.1fs\nRelationship = %s";
DM_YOU = "you"
DM_CRITSTR = "Crit";

--[[
-------------------------------------------------------------------------------
THIS IS WHERE COMBAT MESSAGES GET PARSED
-------------------------------------------------------------------------------

Notes:
- Using %a+ for player names is very risk as totems are pets and have spaces in their names.
- Leave .'s off the end as a rule to save us from having to put in (%d absorbed) cases.

-----------------
THE EVENT MATRIX:
-----------------
					(S)Self		(E)Pet		(P)Party		(F)Friendly
01 Hit				x			x			x				x
02 Crit				x			x			0				x
03 Spell			x			x			x				x
04 SpellCrit		x			x			x				x
05 Dot				x			A			A				A
06 DmgShield		x			B			B				B
07 SplitDmg						0			0				0

10 IncHit			x			x			x				x
11 IncCrit			x			x			x				x
12 IncSpell			x			x			x				x
13 IncSpellCrit		x			0			x				x
14 IncDot			x			x			x				x

20 Heal				x			0			x				x
21 HealCrit			x			0			x				x
22 Hot				x			0			x				x
23 NDB				-			0			0				x
24 JD				-			0			0				0


x : Confirmed
0 : Case exists, but unconfirmed.
- : Irrelevant.
A - Ambiguous: Dots messages come from the creature being hit, not the player.
B - Damage shield messags are only self and "other".
NDB - "Night Dragon's Blossom" : English special-case because of the "'s".
JD - "Julie's Dagger" : English special-case because of the "'s".

]]--

function DamageMeters_ParseMessage(arg1, event)
	local creatureName;
	local damage;
	local spell;
	local spell2;
	local petName;
	local partialBlock;
	local damageType;

	---------------------
	-- DAMAGE MESSAGES --
	---------------------

	-- English: The following require special cases in English:
	-- Ramstein's Lightning Bolts - the 's breaks the patterns.  Known bug, as-is.

	if(	event == "CHAT_MSG_COMBAT_SELF_HITS" ) then
		for creatureName, damage in string.gfind(arg1, "You hit (.+) for (%d+)") do
			DM_CountMsg(arg1, "S01 Self Hit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
		for creatureName, damage in string.gfind(arg1, "You crit (.+) for (%d+)") do
			DM_CountMsg(arg1, "S02 Self Crit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
	end

	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" )then
		for spell, creatureName, damage in string.gfind(arg1, "Your (.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "S03 Self Spell Hit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, "Your (.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "S04 Self Spell Crit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end
	end

	if ( event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" ) then	
		for creatureName, damage, damageType, spell in string.gfind(arg1, "(.+) suffers (%d+) (.+) damage from your (.+)") do
			DM_CountMsg(arg1, "S05 Self DOT", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end		
		for creatureName, damage, damageType, playerName, spell in string.gfind(arg1, "(.+) suffers (%d+) (.+) damage from (.+)'s (.+)") do
			DM_CountMsg(arg1, "F05 Friendly DOT", event);
			DamageMeters_AddDamage(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end	
	end

	if (event == "CHAT_MSG_COMBAT_PARTY_HITS" or
		event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS" or
		event == "CHAT_MSG_COMBAT_PET_HITS") then

		local relationship = DamageMeters_Relation_PARTY;
		local relationshipName = "P";
		if (event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS") then
			relationship = DamageMeters_Relation_FRIENDLY;
			relationshipName = "F";
		elseif (event == "CHAT_MSG_COMBAT_PET_HITS") then
			relationship = DamageMeters_Relation_PET;
			relationshipName = "E";
		end
			
		for playerName, creatureName, damage in string.gfind(arg1, "(.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, relationshipName.."01 Hit", event);
			DamageMeters_AddDamage(playerName, damage, DM_HIT, relationship, "[Melee]");
			return;
		end
		for playerName, creatureName, damage in string.gfind(arg1, "(.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, relationshipName.."02 Crit", event);
			DamageMeters_AddDamage(playerName, damage, DM_CRIT, relationship, "[Melee]");
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_PARTY_DAMAGE" or
		event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE" or
		event == "CHAT_MSG_SPELL_PET_DAMAGE") then

		local relationship = DamageMeters_Relation_PARTY;
		local relationshipName = "P";
		if (event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE") then
			relationship = DamageMeters_Relation_FRIENDLY;
			relationshipName = "F";
		elseif (event == "CHAT_MSG_SPELL_PET_DAMAGE") then
			relationship = DamageMeters_Relation_PET;
			relationshipName = "E";
		end

		for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)'s (.+) hits (.+) for (%d+)") do		
			DM_CountMsg(arg1, relationshipName.."03 Spell", event);
			DamageMeters_AddDamage(playerName, damage, DM_HIT, relationship, spell);
			return;
		end
		for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)'s (.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, relationshipName.."04 SpellCrit", event);
			DamageMeters_AddDamage(playerName, damage, DM_CRIT, relationship, spell);
			return;
		end

		-- For soul link
		-- SPELLSPLITDAMAGEOTHEROTHER
		--! todo SPELLSPLITDAMAGEOTHERSELF
		--! todo SPELLSPLITDAMAGESELFOTHER
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) causes (.+) (%d+) damage") do
			DM_CountMsg(arg1, relationshipName.."07 SplitDmg", event);
			DamageMeters_AddDamage(playerName, damage, DM_DOT, relationship, spell);
			return;
		end
	end

	-- Damage Shields --

	if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then
		for damage, damageType, creatureName in string.gfind(arg1, "You reflect (%d+) (.+) to (.+)") do
			DM_CountMsg(arg1, "S06 DmgShield", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, "[DmgShield]");
			return;
		end
	end
	if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS") then
		for playerName, damage, damageType, creatureName in string.gfind(arg1, "(.+) reflects (%d+) (.+) to (.+)") do
			DM_CountMsg(arg1, "F06 DmgShield", event);
			DamageMeters_AddDamage(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, "[DmgShield]");
			return;
		end
	end

	------------------------------
	-- DAMAGE-RECEIVED MESSAGES --
	------------------------------

	-- TODO: Reflected spells.  "you are affected by YOUR spell."

	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") then
		for creatureName, damage in string.gfind(arg1, "(.+) hits you for (%d+)") do
			DM_CountMsg(arg1, "S10 IncHit", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
		for creatureName, damage in string.gfind(arg1, "(.+) crits you for (%d+)") do
			DM_CountMsg(arg1, "S11 IncCrit", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end

		-- These are for your pet:
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "E10 IncHit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PET, "[Melee]");
			return;
		end
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "E11 IncCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PET, "[Melee]");
			return;
		end
	end

	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS") then
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "P10 IncHit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PARTY, "[Melee]");
			return;
		end
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "P11 IncCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PARTY, "[Melee]");
			return;
		end
	end
	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS" or
		event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS") then
		for creatureName, damage in string.gfind(arg1, "(.+) hits you for (%d+)") do
			DM_CountMsg(arg1, "S10 IncHit PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
		for creatureName, damage in string.gfind(arg1, "(.+) crits you for (%d+)") do
			DM_CountMsg(arg1, "S11 IncCrit PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end

		for creatureName, playerName, damage in string.gfind(arg1, "(.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "F10 IncHit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, "[Melee]");
			return;
		end
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "F11 IncCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, "[Melee]");
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE") then
		for creatureName, spell, damage in string.gfind(arg1, "(.+)'s (.+) hits you for (%d+)") do
			DM_CountMsg(arg1, "S12 IncSpell", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for creatureName, spell, damage in string.gfind(arg1, "(.+)'s (.+) crits you for (%d+)") do
			DM_CountMsg(arg1, "S13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end

		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "E12 IncSpell", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PET, spell);
			return;
		end
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "E13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PET, spell);
			return;
		end
	end
	
	if (event == "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") then
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "P12 IncSpell", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PARTY, spell);
			return;
		end
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "P13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PARTY, spell);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") then
			for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "F12 IncSpell", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "F13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE") then
		for creatureName, spell, damage in string.gfind(arg1, "(.+)'s (.+) hits you for (%d+)") do
			DM_CountMsg(arg1, "S12 IncSpell PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for creatureName, spell, damage in string.gfind(arg1, "(.+)'s (.+) crits you for (%d+)") do
			DM_CountMsg(arg1, "S13 IncSpellCrit PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end

		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) hits (.+) for (%d+)") do
			DM_CountMsg(arg1, "F12 IncSpell PVP", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) crits (.+) for (%d+)") do
			DM_CountMsg(arg1, "F13 IncSpellCrit PVP", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	-- Periodic.
	if (event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE") then
		for damage, damageType, creatureName, spell in string.gfind(arg1, "You suffer (%d+) (.+) damage from (.+)'s (.+)") do
			DM_CountMsg(arg1, "S14 IncDot", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end

		-- For reflected dots: 
		for damage, damageType, creatureName, spell in string.gfind(arg1, "You suffer (%d+) (.+) damage from your (.+)") do
			DM_CountMsg(arg1, "S14 IncDot", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end

		-- Pet
		for playerName, damage, damageType, creatureName, spell in string.gfind(arg1, "(.+) suffers (%d+) (.+) damage from (.+)'s (.+)") do
			DM_CountMsg(arg1, "E14 IncDot", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_PET, spell);
			return;
		end
	end
	if (event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE") then
		for playerName, damage, damageType, creatureName, spell in string.gfind(arg1, "(.+) suffers (%d+) (.+) damage from (.+)'s (.+)") do
			DM_CountMsg(arg1, "P14 IncDot", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_DOT, DamageMeters_Relation_PARTY, spell);
			return;
		end
	end
	if (event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" or
		event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") then
		-- For pvp.
		for damage, damageType, creatureName, spell in string.gfind(arg1, "You suffer (%d+) (.+) damage from (.+)'s (.+)") do
			DM_CountMsg(arg1, "S14 IncDot PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end

		for playerName, damage, damageType, creatureName, spell in string.gfind(arg1, "(.+) suffers (%d+) (.+) damage from (.+)'s (.+)") do
			DM_CountMsg(arg1, "F14 IncDot", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end

		--! This happens in bg right after you die.
		--! "Bob takes 100 Arcane damage from your Moonfire."
	end


	----------------------
	-- HEALING MESSAGES --
	----------------------

	-- NOTE: There is a kind of bug here--we cannot tell the relationship of the 
	-- healer from the message, so if the group filter is on healing pets (healing totems particularly)
	-- won't be added into the list until some other quantity puts them in.
	-- NOTE: Inexplicably, HOSTILEPLAYER_BUFF messages report for party members.
	-- Note: In English, the following things require special healing cases:
	-- Night Dragon's Breath, Julie's Dagger.

	if (event == "CHAT_MSG_SPELL_SELF_BUFF" or
		event == "CHAT_MSG_SPELL_PARTY_BUFF" or
		event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF" or
		event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"
		) then

		for spell, creatureName, damage in string.gfind(arg1, "Your (.+) critically heals (.+) for (%d+)") do
			DM_CountMsg(arg1, "S21 HealCrit", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, "Your (.+) heals (.+) for (%d+)") do
			DM_CountMsg(arg1, "S20 Heal", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)'s (.+) critically heals (.+) for (%d+)") do
			DM_CountMsg(arg1, "F21 HealCrit", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end

		-- English-only special cases. (Assuming these effects cannot crit.)
		for playerName, creatureName, damage in string.gfind(arg1, "(.+)'s Night Dragon's Breath heals (.+) for (%d+)") do
			spell = "Other's Night Dragon's Breath";
			DM_CountMsg(arg1, "F23 NDB", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for playerName, creatureName, damage in string.gfind(arg1, "(.+)'s Julie's Dagger heals (.+) for (%d+)") do
			spell = "Julie's Dagger";
			DM_CountMsg(arg1, "F24 JD", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end

		for playerName, spell, creatureName, damage in string.gfind(arg1, "(.+)'s (.+) heals (.+) for (%d+)") do
			DM_CountMsg(arg1, "F20 Heal", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or
		event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" or
		event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" or
		event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" -- why?
		) then

		for damage, playerName, spell in string.gfind(arg1, "You gain (%d+) health from (.+)'s (.+)") do
			DM_CountMsg(arg1, "F22 Hot2", event);
			DamageMeters_AddHealing(playerName, UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for damage, spell in string.gfind(arg1, "You gain (%d+) health from (.+)") do
			DM_CountMsg(arg1, "S22 Hot1", event);
			DamageMeters_AddHealing(UnitName("Player"), UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for creatureName, damage, spell in string.gfind(arg1, "(.+) gains (%d+) health from your (.+)") do		
			DM_CountMsg(arg1, "S22 Hot2", event);
			DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for creatureName, damage, playerName, spell in string.gfind(arg1, "(.+) gains (%d+) health from (.+)'s (.+)") do
			DM_CountMsg(arg1, "F22 Hot2", event);
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	----------------------

	-- Check the message to see if it is the kind of thing we should have caught.
	if (DamageMeters_enableDebugPrint and arg1) then
		local sub = string.sub(event, 1, 8);
		if (sub == "CHAT_MSG") then			
			-- We only care about messages with numbers in them.
			for amount in string.gfind(arg1, "(%d+)") do

				--DMPrint("UNPARSED NUMERIC ["..event.."] : "..arg1);

				-- GENERICPOWERGAIN_OTHER 
				-- GENERICPOWERGAIN_SELF 
				for player, amount, type in string.gfind(arg1, "(.+) gains (%d+) (.+).") do	return;	end
				for player, amount, type in string.gfind(arg1, "You gain (%d+) (.+).") do return; end
				-- SPELLEXTRAATTACKSOTHER_SINGULAR etc
				if (string.find(arg1, "extra attack")) then return; end
				-- ITEMENCHANTMENTADDOTHEROTHER, etc
				for player in string.gfind(arg1, "(.+) casts (.+) on (.+)'s (.+).") do return; end
				for player in string.gfind(arg1, "(.+) casts (.+) on your (.+).") do return; end
				for player in string.gfind(arg1, "You cast (.+) on (.+)'s (.+).") do return; end
				for player in string.gfind(arg1, "You cast (.+) on your (.+).") do return; end
				-- VSENVIRONMENTALDAMAGE_DROWNING_OTHER etc.
				for player in string.gfind(arg1, "You are drowning and lose (%d+) health.") do return; end
				for player in string.gfind(arg1, "(.+) falls and loses (%d+) health.") do return; end
				for player in string.gfind(arg1, "You fall and lose (%d+) health.") do return; end
				for player in string.gfind(arg1, "(.+) is exhausted and and loses (%d+) health.") do return; end
				for player in string.gfind(arg1, "You are exhausted and lose (%d+) health.") do return; end
				for player in string.gfind(arg1, "(.+) suffers (%d+) points of fire damage.") do return; end
				for player in string.gfind(arg1, "You suffer (%d+) points of fire damage.") do return; end
				for player in string.gfind(arg1, "(.+) loses (%d+) health for swimming in (.+).") do return; end
				for player in string.gfind(arg1, "You lose (%d+) health for swimming in (.+).") do return; end
				-- SPELLPOWERDRAINOTHEROTHER etc
				for player in string.gfind(arg1, "(.+) drains (%d+) Mana from you.") do return; end
				for player in string.gfind(arg1, "(.+) drains (%d+) Mana from (.+).") do return; end
				for player in string.gfind(arg1, "You drain (%d+) Mana from (.+).") do return; end
				for player in string.gfind(arg1, "(.+) drains (%d+) Mana from you and gains (%d+).") do return; end
				for player in string.gfind(arg1, "You drain (%d+) Mana from (.+) and gain (%d+).") do return; end


				-- blah casts field repair bot 74a
				-- blah begins to cast armor +40
				---------------

				DMPrint("Numeric message missed! ["..event.."]");
				DMPrint(arg1);
				return;
			end
		end
	end
end