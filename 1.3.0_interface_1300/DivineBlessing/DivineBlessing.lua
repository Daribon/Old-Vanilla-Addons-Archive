--[[
	Divine Blessing

	Allows a paladin to choose a set of blessings, 
	and then sequentially buff his party with them.

	By Steve DeLong (CheshireKatt)
	
]]

-- Configuration variables
COS_DIVINE_BLESSING_ENABLE	= nil;			-- set this to non nil to enable the divine blessing buttons
COS_DIVINE_BLESSING_DELAY	= nil; 			-- default delay in seconds between blessings
--COS_DIVINE_BLESSING_IGNOREABSENT	= nil;	-- set this to non nil to cast blessings regardless of absent partymembers
COS_DIVINE_BLESSING_SHOWANNOUNCE	= 1;	-- set this to nil to remove all completion announcements
COS_DIVINE_BLESSING_BANNERANNOUNCE	= nil;	-- set this to non nil to announce completion as a banner rather than in chat
COS_DIVINE_BLESSING_OVERRIDETARGET	= nil;	-- set this to non nil to override blessings when targeting friendlies

-- Debug Values
DB_DEBUG = "DIVINE_BLESSING_DEBUG";			-- Specifies the name of the debug flag
DIVINE_BLESSING_DEBUG=0;					-- Sets the value of the debug flag

-- Blizzard Registrations
UIPanelWindows["DivineBlessingFrame"] = { area = "left", pushable = 11 };

-- Local data
local DivineBlessing_CurrentID = -1;
local DivineBlessing_CurrentSpellbook = "";

local DivineBlessingTabs = {"self","party"};
local DivineBlessing_CurrentTab = DivineBlessingTabs[1];
local DivineBlessing_ActiveSet = nil;

DivineBlessing_ButtonMap = {};
DivineBlessing_AllyButtonMap = {};

-- Constants
local DIVINEBLESSING_SET_COUNT = 5;
local DIVINEBLESSING_SET_SIZE = 5;
local DIVINEBLESSING_VERSION = 1;
local DIVINEBLESSING_TABS = 2;
local DIVINEBLESSING_TAG = "<DB"..DIVINEBLESSING_VERSION..">";

-- General Ideas stolen from Marek
-- Command Queue
local DB_CommQueue = {};
local TimePassed = 0;

-- Callback functions

function DivineBlessing_Enable(toggle)
	DebugPrint("Divine Blessing Enabled", DB_DEBUG);
	if(toggle == 1) then 
		COS_DIVINE_BLESSING_ENABLE = 1;
	else
		COS_DIVINE_BLESSING_ENABLE = nil;
	end
end

function DivineBlessing_Delay(toggle, value)
	if ( toggle == 0 ) then 
		COS_DIVINE_BLESSING_DELAY = nil;
	else
		COS_DIVINE_BLESSING_DELAY = value;
	end
		
end
--[[
function DivineBlessing_IgnoreAbsent(toggle, value)
	if ( toggle == 1 ) then
		COS_DIVINE_BLESSING_IGNOREABSENT = 1;
	else
		COS_DIVINE_BLESSING_IGNOREABSENT = nil;
	end
end
]]--
function DivineBlessing_ShowAnnounce(toggle, value)
	if ( toggle == 1 ) then
		COS_DIVINE_BLESSING_SHOWANNOUNCE = 1;
	else
		COS_DIVINE_BLESSING_SHOWANNOUNCE = nil;
	end
end

function DivineBlessing_BannerAnnounce(toggle, value)
	if ( toggle == 1 ) then
		COS_DIVINE_BLESSING_BANNERANNOUNCE = 1;
	else
		COS_DIVINE_BLESSING_BANNERANNOUNCE = nil;
	end
end

function DivineBlessing_OverrideTarget(toggle, value)
	if ( toggle == 1 ) then
		COS_DIVINE_BLESSING_OVERRIDETARGET = 1;
	else
		COS_DIVINE_BLESSING_OVERRIDETARGET = nil;
	end
end

-- This function handles all of the events
-- passed to this frame from the game
-- 
function DivineBlessing_OnEvent()
	if ( event == "SPELLS_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" ) then 
		DivineBlessing_ButtonUpdate(this);
	end
	if ( event == "VARIABLES_LOADED" or event == "UNIT_PORTRAIT_UPDATE" ) then 
		if ( event == "VARIABLES_LOADED" ) then
			-- Here to catch Error in the settings loader
			if ( DivineBlessing_ButtonMap == nil or DivineBlessing_ButtonMap[set] == nil ) then 
				--DivineBlessing_Reset();
			end
		end
		
		-- Refresh all sets
		for set=1,DIVINEBLESSING_SET_COUNT,1 do
			DivineBlessing_UpdateSet("DivineBlessingButtonSet",set,DIVINEBLESSING_SET_SIZE);		
		end
	end
end

-- Updates the sets
function DivineBlessing_OnShow()
	PanelTemplates_UpdateTabs(this);
	DivineBlessing_UpdateAllSets();
	DivineBlessing_ShowHelp();
end

function DivineBlessing_UpdateAllSets()
	for set=1,DIVINEBLESSING_SET_COUNT,1 do
		DivineBlessing_UpdateSet("DivineBlessingButtonSet",set,DIVINEBLESSING_SET_SIZE);		
	end
end

-- Handles gui updates ever frame
function DivineBlessing_Update()
end

-- Handles the OnClick event in the Spell Log
function DivineBlessing_WatchSpellbook(drag)
	local id = SpellBook_GetSpellID(this:GetID());
	if ( id > MAX_SPELLS ) then
		return;
	end
	if (  IsShiftKeyDown() ) then
		DebugPrint("id2: "..id.. " book: "..SpellBookFrame.bookType, DB_DEBUG );
		DivineBlessing_PickupSpell(id, SpellBookFrame.bookType );		
	elseif ( drag ) then
		DebugPrint("id: "..id.. " book: "..SpellBookFrame.bookType, DB_DEBUG );
		DivineBlessing_PickupSpell(id, SpellBookFrame.bookType );
	end

	-- Drop it in 60 seconds
	Cosmos_Schedule(60,DivineBlessing_DropSpell);
end

-- TS Button Load
function DivineBlessing_ButtonLoad()
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("SPELLS_CHANGED");
	this:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
	this:RegisterEvent("SPELL_UPDATE_COOLDOWN");	
end

--
-- [[ Logic Functions ]]
-- 
-- The Actual logic of Divine Blessing.
--
-- Cycle through a specified list. 
-- If the current spell has a cooldown > 0
--	If wait == 1 - do nothing
--	else - 	cycle to the next ready spell 
--		or the beginning of the spell list
-- end
-- If the selected spell is ready
-- 	Pick the next spell
-- 	Cast the spell
--	Change the spell index on the set
--	Notify allies of your next spell
-- end
-- 	
function DivineBlessing_Bless(set)
	if ( COS_DIVINE_BLESSING_ENABLE == nil ) then 
		return;
	end
	
	-- List the current set as the active set
	DivineBlessing_ActiveSet = set+0;
	
	local index = nil;

	set = set + 0;
	if ( DivineBlessing_ButtonMap[set].index ~= nil ) then 
		index = DivineBlessing_ButtonMap[set].index;
	else
		index = 1;
	end

	-- If the id < 0, get the next valid id
	if ( DivineBlessing_ButtonMap[set][index].id <= 0 ) then
		-- Increase the index
		index = DivineBlessing_NextAvailableSpell(set, DivineBlessing_ButtonMap[set].wait);

		-- Save the set index
		DivineBlessing_ButtonMap[set].index = index;
	end
	
	if ( DivineBlessing_ButtonMap[set][index].id > 0 ) then
		-- Get the first duration
		local id =  DivineBlessing_ButtonMap[set][index].id;
		local book =  DivineBlessing_ButtonMap[set][index].book;
		local start, duration, enable = GetSpellCooldown(id, book);
		
		DebugPrint ("Start: "..start.." Dur: "..duration.." Enable: "..enable, DB_DEBUG);

		-- If wait is uncheck and this spell is cooling down, jump ahead
		if ( duration > 0 and DivineBlessing_ButtonMap[set].wait == 0 ) then 
			index = DivineBlessing_NextAvailableSpell(set, DivineBlessing_ButtonMap[set].wait);

			-- Update the values
			id =  DivineBlessing_ButtonMap[set][index].id;
			book =  DivineBlessing_ButtonMap[set][index].book;
			start, duration, enable = GetSpellCooldown(id, book);
		end
		
		-- If the cooldown is all-clear
		if ( duration == 0 ) then 
			-- Queue up the announcement
			DivineBlessing_QueueSetAnnouncement(set);
			
			-- Save the index of the current spell, for use in determining target
			local castIndex = index;

			-- Go to the next spell
			index = DivineBlessing_NextAvailableSpell(set, DivineBlessing_ButtonMap[set].wait);
				
			-- Save the set index
			DivineBlessing_ButtonMap[set].index = index;
	
			-- Cast the spell on the appropriate target -- default is to clear the current one.
			if (COS_DIVINE_BLESSING_OVERRIDETARGET == nil) then
				if (UnitIsFriend("target", "player")) then
					ClearTarget();
				end
			end

			CastSpell(id, book);
			if (SpellIsTargeting(id)) then
				if (castIndex == 1) then
					SpellTargetUnit("player");
--					TargetUnitsPet("player");				
				else
					SpellTargetUnit("party"..(castIndex - 1));
--					TargetUnitsPet("party"..(castIndex - 1));				
				end
			end
		
			-- If index is 1, we just wrapped around.  Done with this set, so announce it.
			if ((index == 1) and (COS_DIVINE_BLESSING_SHOWANNOUNCE ~= nil)) then
				local setCompletionMessage = "Blessing Set "..set.." completed.";
				if (COS_DIVINE_BLESSING_BANNERANNOUNCE == nil) then
					Sea.IO.print(setCompletionMessage);
				else
					Sea.IO.banner(setCompletionMessage);
				end
			end
		end

		if ( DivineBlessing_CurrentTab == "self" ) then 
			DivineBlessing_UpdateSet("DivineBlessingButtonSet",set,DIVINEBLESSING_SET_SIZE);		
		elseif ( DivineBlessing_CurrentTab == "party" ) then 
			DivineBlessing_UpdateSet("DivineBlessingButtonSet",1,DIVINEBLESSING_SET_SIZE);		
		end			
	end
end

-- Find the next spell in the set, skipping spells with cooldown if wait is on
function DivineBlessing_NextAvailableSpell(set, wait) 
	if ( wait == nil ) then wait = 1; end
	DebugPrint("NAS: Set ("..set..") Wait: "..wait, DB_DEBUG);

	-- Find the current set index
	index = DivineBlessing_ButtonMap[set].index; 

	-- If it hasnt been started, start at the first slot (which is 1)
	if ( index == nil ) then index = 1; end
	
	-- Increase the index
	index = index + 1;
	if ( index > DIVINEBLESSING_SET_SIZE ) then
		index = 1;
	else --if ( COS_DIVINE_BLESSING_IGNOREABSENT == 1 ) then
		-- If we're set to ignore absent players, check to see if there is such a partymember
		if (not GetPartyMember(index - 1)) then
			index = 1;
		end
	end

	-- Get the id/book
	local id =  DivineBlessing_ButtonMap[set][index].id;
	local book =  DivineBlessing_ButtonMap[set][index].book;
	local duration = 0;
	
	-- Check the duration
	if ( id > 0 ) then 
		start, duration, enable = GetSpellCooldown(id, book);
	end

	-- Cycle through the remainder of the list to see if they've cooled down
	while ( id < 0 or (duration > 0 and wait == 0) ) do
		-- Increase the index
		index = index + 1; 

		--
		-- If we break the limits, crap out and start over
		-- Even if we have to wait for the first node
		-- 
		if ( index > DIVINEBLESSING_SET_SIZE ) then
			index = 1;
			break;
		end

		-- Get the id/book
		id =  DivineBlessing_ButtonMap[set][index].id;
		book =  DivineBlessing_ButtonMap[set][index].book;

		-- Update the duration
		if ( id > 0 ) then 
			start, duration, enable = GetSpellCooldown(id, book);
		end
	end

	return index;
end

-- TS Button Event Handler
function DivineBlessing_ButtonEvent(event)
	if ( event == "SPELL_UPDATE_COOLDOWN" ) then
		DivineBlessing_ButtonUpdate(this);
	end
end

-- Move the Spell around if you're looking at your own tabs
function DivineBlessing_ButtonDragStart()
	local col, row = DivineBlessing_GetCurrentLocation(this);		

	if ( DivineBlessing_CurrentTab == "self" ) then 
		-- Pick up the current spell
		DivineBlessing_SwapButton(row,col);
	end
end

-- Update an entire set of buttons
function DivineBlessing_UpdateSet(setbasename,set,size) 
	if ( set == nil ) then return; end
	--DebugPrint("Setname: "..setbasename.." Set:"..set.. " ("..size..")", DB_DEBUG);
	for i=1,size,1 do
		DivineBlessing_ButtonUpdate(getglobal(setbasename..set..i));
	end

	-- Updates the gui elements based on the player's settings
	if ( DivineBlessing_CurrentTab == "self") then
		local check = DivineBlessing_ButtonMap[set].wait;
		if ( check == nil ) then check = 1; end
		getglobal(setbasename..set.."Wait"):SetChecked(check);
		getglobal(setbasename..set.."Wait"):Show();
		getglobal(setbasename..set.."WaitText"):Show();
		getglobal(setbasename..set.."Portrait"):Hide();
		getglobal(setbasename..set.."NameText"):Hide();
		getglobal(setbasename..set.."Label"):Show();
	-- Updates the gui elements based on the party settings
	elseif ( DivineBlessing_CurrentTab == "party" ) then 		
		getglobal(setbasename..set.."Wait"):Hide();
		getglobal(setbasename..set.."WaitText"):Hide();
		getglobal(setbasename..set.."Portrait"):Show();
		getglobal(setbasename..set.."Label"):Hide();	

		-- Select the correct party member.
		local portrait = "party";
		if ( set == 1 ) then 
			portrait = "player";
		else
			portrait = portrait..(set - 1);
		end
		
		-- Set the texture and color
		SetPortraitTexture(getglobal(setbasename..set.."Portrait"), portrait);	
		if ( UnitClass(portrait) ~= "Paladin" ) then 		
			getglobal(setbasename..set.."Portrait"):SetVertexColor(.4,.4,.4);
		else
			getglobal(setbasename..set.."Portrait"):SetVertexColor(1.0,1.0,1.0);
		end

		-- Set the name
		local playername = UnitName(portrait);
		if ( playername ) then 
			playername = string.sub(playername, 1, 10);
			getglobal(setbasename..set.."NameText"):Show();
			getglobal(setbasename..set.."NameText"):SetText(playername);
		else
			getglobal(setbasename..set.."NameText"):Hide();
			getglobal(setbasename..set.."Portrait"):Hide();				
		end		
	end
end
-- Cast the curernt button
function DivineBlessing_UseButton(row, col)
	local col, row = DivineBlessing_GetCurrentLocation(this);		
	if ( DivineBlessing_CurrentTab == "self" ) then 
		if ( DivineBlessing_ButtonMap[row][col].id > 0 ) then 
			CastSpell(DivineBlessing_ButtonMap[row][col].id,
				DivineBlessing_ButtonMap[row][col].book);
		end
	end
end

-- Erases the old button with the hand
function DivineBlessing_SetButton(row, col) 
	--DebugPrint("Row: "..row.." Col:"..col, DB_DEBUG);

	-- Set the new button
	DivineBlessing_ButtonMap[row][col] = {id=DivineBlessing_CurrentID,book=DivineBlessing_CurrentSpellbook};
	DivineBlessing_DropSpell();

	DivineBlessing_ButtonUpdate(this);	
end

-- Swaps the specified button into hand
function DivineBlessing_SwapButton(row,col)
	--DebugPrint("Row: "..row.." Col:"..col, DB_DEBUG);
	-- Store the old value if one exists
	local temp = nil;
	if ( DivineBlessing_ButtonMap[row][col].id > 0 ) then 
		temp = DivineBlessing_ButtonMap[row][col];
	end

	-- Drop the current button
	DivineBlessing_SetButton(row, col);
	
	-- Load the old one into the cursor
	if ( temp ) then 
		if ( temp.id > 0 ) then 
			DivineBlessing_PickupSpell(temp.id, temp.book);
			PickupSpell(temp.id, temp.book );
		end
	end
end

-- DivineBlessingTab_OnClick
function DivineBlessingTab_OnClick(button)
	DivineBlessing_CurrentTab = DivineBlessingTabs[button:GetID()];
	DivineBlessing_ShowHelp();
	DivineBlessing_UpdateAllSets();
end
--
-- Swap or pick up if clicked with or without a full hand
--   Set the index if you're an alt press
-- 
function DivineBlessing_ButtonClick()
	local col, row = DivineBlessing_GetCurrentLocation(this);		
	this:SetChecked("false");
	
	if ( DivineBlessing_CurrentTab == "self" ) then 
		-- Pick up the current spell
		if( IsShiftKeyDown() ) then 
			DivineBlessing_SwapButton(row,col);
		-- Set the next spell
		elseif( IsAltKeyDown() ) then 
			DivineBlessing_ButtonMap[row].index = col;
			DivineBlessing_UpdateSet("DivineBlessingButtonSet",row,DIVINEBLESSING_SET_SIZE);		
		-- Drop the new spell
		elseif( DivineBlessing_CurrentID > 0 ) then
			DivineBlessing_SwapButton(row,col);
		-- Use the stored spell
		else 	
			DivineBlessing_UseButton(row,col);		
		end
	elseif ( DivineBlessing_CurrentTab == "party" ) then 
		-- Uses the spell if its yours
		if ( row == 1 and DivineBlessing_ActiveSet ) then 
			DivineBlessing_UseButton(DivineBlessing_ActiveSet,col);		
		end
	end
end

function DivineBlessing_ButtonDragEnd()
	if ( DivineBlessing_CurrentTab == "self" ) then 
		if( DivineBlessing_CurrentID > 0 ) then
			local col, row = DivineBlessing_GetCurrentLocation(this);		
			DivineBlessing_SwapButton(row,col);
		end
	end
end

-- Displays the tooltip of the spell in the box.
function DivineBlessing_ButtonEnter()
	local col, row = DivineBlessing_GetCurrentLocation(this);		

	if ( DivineBlessing_CurrentTab == "self" ) then 
		local id = DivineBlessing_ButtonMap[row][col].id;
		local spellbook = DivineBlessing_ButtonMap[row][col].book;

		if ( id > 0 ) then 
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
			Sea.wow.tooltip.protectTooltipMoney();
			if ( GameTooltip:SetSpell(id, spellbook) ) then
				this.updateTooltip = TOOLTIP_UPDATE_TIME;
			else
				this.updateTooltip = nil;
			end	
			Sea.wow.tooltip.unprotectTooltipMoney();
		end
	elseif ( DivineBlessing_CurrentTab == "party" ) then 
		-- displays full tooltip
		if ( row == 1 and DivineBlessing_ActiveSet ) then 
			local id = DivineBlessing_ButtonMap[DivineBlessing_ActiveSet][col].id;
			local spellbook = DivineBlessing_ButtonMap[DivineBlessing_ActiveSet][col].book;

			if ( id > 0 ) then 
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				Sea.wow.tooltip.protectTooltipMoney();
				if ( GameTooltip:SetSpell(id, spellbook) ) then
					this.updateTooltip = TOOLTIP_UPDATE_TIME;
				else
					this.updateTooltip = nil;
				end	
				Sea.wow.tooltip.unprotectTooltipMoney();
			end
		else 
			-- Display the party tooltip data
			if ( DivineBlessing_AllyButtonMap[row] ) then 
				if ( DivineBlessing_AllyButtonMap[row][col].name ~= "" ) then
					GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
					local tooltip = DivineBlessing_AllyButtonMap[row][col].name;
					if ( DivineBlessing_AllyButtonMap[row][col].rank ~= "" ) then
						tooltip = tooltip.."\n |cFFDDDDDD("..DivineBlessing_AllyButtonMap[row][col].rank..")|r";
					end
					GameTooltip:SetText(tooltip);
				end
			end
		end
	end
end

function DivineBlessing_WaitButtonEnter()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(DIVINEBLESSING_WAIT_TIP);
end
function DivineBlessing_WaitButtonLeave()
	GameTooltip:Hide();
end
function DivineBlessing_SetWait(set,state)
	if ( state == true or state == 1 ) then 
		DivineBlessing_ButtonMap[set].wait = 1;	
	else
		DivineBlessing_ButtonMap[set].wait = 0;	
	end
end

function DivineBlessing_ButtonLeave()
	GameTooltip:Hide();
end

function DivineBlessing_ButtonLoad()
end

-- Divine Blessing Self Texture Button
function DivineBlessing_SetSelfTexture(button, row, col) 
	local name = button:GetName();	
	local icon = getglobal(name.."Icon");
	local cooldown = getglobal(name.."Cooldown");

	if (  DivineBlessing_ButtonMap[row] == nil ) then return end
	local id = DivineBlessing_ButtonMap[row][col].id;
	local spellbook = DivineBlessing_ButtonMap[row][col].book;

	if ( id > 0 ) then 
		-- Set the index to checked if true
		if ( DivineBlessing_ButtonMap[row].index == col ) then 
			button:SetChecked("true");
		end
	
		-- Set the pretty texture
		local texture = GetSpellTexture(id, spellbook);
		if ( texture ) then
			icon:SetTexture(texture);
			icon:Show();
		else
			icon:Hide();
		end
		
		-- Update the cooldown device
		local start, duration, enable = GetSpellCooldown(id, spellbook);
		--DebugPrint ("Start: "..start.." Dur: "..duration.." Enable: "..enable, DB_DEBUG);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
	
		-- Check if an ally is using the same spell
		local spellName, spellRank = GetSpellName(id, spellbook);	

		-- Compare this spell rank to your allies
		compare = DivineBlessing_CompareSpells(spellName, spellRank, 1);

		if ( compare ) then 
			if ( compare == -1 ) then 
				icon:SetVertexColor(.4,.4,.4);
			elseif ( compare == 0 ) then 
				icon:SetVertexColor(.8,.4,.4);
			elseif ( compare == 1 ) then 
				icon:SetVertexColor(.4,.8,.4);
			end
		else
			-- Show disabled textures if we're ignoring absent partymembers
--			if ((col > 1) and (COS_DIVINE_BLESSING_IGNOREABSENT == 1)) then
			if (col > 1) then
				if (GetPartyMember(col - 1)) then		
					icon:SetVertexColor(1,1,1);
				else
					icon:SetVertexColor(.4,.4,.4);
				end
			else
				icon:SetVertexColor(1,1,1);
			end
		end
	else
		icon:Hide();
	end
end	

-- Divine Blessing Ally Texture Button
function DivineBlessing_SetAllyTexture(button, row, col) 
	local name = button:GetName();	
	local icon = getglobal(name.."Icon");
	local cooldown = getglobal(name.."Cooldown");

	-- Remember we're going to change the ally textures.

	if (  DivineBlessing_AllyButtonMap[row] == nil ) then return end

	if ( icon ~= "" ) then 
		-- Set the index to checked if true
		if ( DivineBlessing_AllyButtonMap[row].index == col ) then 
			button:SetChecked("true");
		end
	
		-- Set the pretty texture
		local texture = DivineBlessing_AllyButtonMap[row][col].icon;
		if ( texture and texture ~= "") then
			icon:SetTexture(texture);
			icon:Show();
		else
			icon:Hide();
		end
		
		--[[ 
		--
		-- If someday someone figures out how to send the cooldown
		-- Add it here
		
		-- Update the cooldown device
		local start, duration, enable = GetSpellCooldown(id, spellbook);
		--DebugPrint ("Start: "..start.." Dur: "..duration.." Enable: "..enable, DB_DEBUG);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
		]]

		-- Compare this spell rank to your allies
		compare = DivineBlessing_CompareSpells(DivineBlessing_AllyButtonMap[row][col].name, DivineBlessing_AllyButtonMap[row][col].rank, row);
		
		if ( compare ) then 
			if ( compare == -1 ) then 
				icon:SetVertexColor(.4,.4,.4);
			elseif ( compare == 0 ) then 
				icon:SetVertexColor(.8,.4,.4);
			elseif ( compare == 1 ) then 
				icon:SetVertexColor(.4,.8,.4);
			end
		else
			icon:SetVertexColor(1,1,1);
		end
		
	else
		icon:Hide();
	end
end	

-- Divine Blessing Spell Comparator
function DivineBlessing_CompareSpells(name, rank, skiprow)
	local spellCompare = nil; -- nil means no conflict, -1 means its weak, 1 means its the best, 0 means its the same
	
	for i=1,5,1 do 
		-- Send skip row 
		if ( i == skiprow ) then 
		else 
			for j=1,DIVINEBLESSING_SET_SIZE,1 do
				spellName = nil;
				spellRank = nil;
				if ( i == 1 ) then 
					if ( DivineBlessing_ActiveSet and DivineBlessing_ActiveSet > 0 ) then
						tid = DivineBlessing_ButtonMap[DivineBlessing_ActiveSet][j].id;
						if ( tid > 0 ) then
							tbook = DivineBlessing_ButtonMap[DivineBlessing_ActiveSet][j].book;
							spellName, spellRank = GetSpellName(tid, tbook);	
						end
					end
					
				else 
					spellName = DivineBlessing_AllyButtonMap[i][j].name;	
					spellRank = DivineBlessing_AllyButtonMap[i][j].rank;	
				end
				
				-- If another user is casting the same spell as you
				if ( spellName and name == spellName ) then
					local newCompare = nil;

					-- Decide if the specified spell rank 
					-- is weaker than the displayed spell
					if ( rank == spellRank ) then 
						newCompare = 0;
					elseif ( rank > spellRank ) then
						newCompare = 1;
					elseif ( rank < spellRank ) then 
						newCompare = -1;
					end

					-- If the spell compare result is bad
					-- it takes priority
					if ( spellCompare == nil or newCompare < spellCompare ) then 
						spellCompare = newCompare;
					end
				end
			end
		end
	end

	return spellCompare;
end

-- Divnie Blessing Button Update
function DivineBlessing_ButtonUpdate(button)
	-- Check the button
	if ( button == nil ) then return; end
	
	-- Uncheck it
	button:SetChecked("false");
	local col, row = DivineBlessing_GetCurrentLocation(button);

	-- Check for errors
	if ( col == nil or row == nil ) then return; end
	
	-- Handle Tabs
	if ( DivineBlessing_CurrentTab == "self" ) then 
		-- Enable the button
		button:Enable();
		DivineBlessing_SetSelfTexture(button, row, col);
	elseif ( DivineBlessing_CurrentTab == "party" ) then
		-- Select the correct party member.
		local character = "party";
		if ( row == 1 ) then 
			character = "player";
		else
			character = character..(row - 1);
		end
		
		-- Set the button
		if ( UnitClass(character) == "Paladin" ) then 		
			button:Enable();
		else
			button:Disable();
		end	

		-- Set the texture
		if ( row == 1 ) then 
			if ( not DivineBlessing_ActiveSet ) then
				button:Disable();
				getglobal(button:GetName().."Icon"):Hide();
			else
				DivineBlessing_SetSelfTexture(button, DivineBlessing_ActiveSet, col);	
			end
		else 
			local pName = UnitName(character);

			if ( pName == nil or UnitClass(character) ~= "Paladin" ) then 
				getglobal(button:GetName().."Icon"):Hide();
			end
	
			-- Sets an allied texture
			DivineBlessing_SetAllyTexture(button, row, col);				
		end
	end
end
-- Shows help text
function DivineBlessing_ShowHelp()
	local helptext = getglobal("DivineBlessingFrameHelpText");
	if ( helptext ) then 
		if ( DivineBlessing_CurrentTab == "self" ) then
			helptext:SetText(DIVINEBLESSING_INSTRUCTION);
		elseif ( DivineBlessing_CurrentTab == "party" ) then
			helptext:SetText(DIVINEBLESSING_PARTY_INSTRUCTION);
		end
	end
	
end
-- Tracks the last spell picked up
function DivineBlessing_PickupSpell(id, bookType) 
	DivineBlessing_CurrentID = id;
	DivineBlessing_CurrentSpellbook = bookType;
end

function DivineBlessing_DropSpell()
	DivineBlessing_CurrentID = -1;
	DivineBlessing_CurrentSpellbook = "";
	PickupSpell(511,"spell");
end

-- Returns the current button location
function DivineBlessing_GetCurrentLocation(object)
	--DebugPrint(this:GetName()..""..object:GetID().." "..object:GetParent():GetName()..": "..object:GetParent():GetID(), DB_DEBUG);
	return object:GetID(), object:GetParent():GetID();
end

-- Show/hide the Divine Blessing Frame
function DivineBlessing_Toggle()
	if ( DivineBlessingFrame ) then 
		if ( DivineBlessingFrame:IsVisible() ) then 
			HideUIPanel(DivineBlessingFrame);
		else	
			ShowUIPanel(DivineBlessingFrame);
		end
	else
		Print("DivineBlessing did not load. Please check your logs/FrameXML.log file and report this error");
	end
end

--
--   [[ Chat Communication section ]]
--
-- The following functions deal with handling communication of your 
-- current settings and state to your allies.
--
--
--

-- Processes the party chat information to find useful data
function DivineBlessing_WatchCosmos(type, info, message, user, language, channel)
	DebugPrint("TS Message: "..message.." ("..user..")", DB_DEBUG);
	
	if ( type == "COSMOS_CHANNEL" or type == "COSMOS_PARTY" ) then
		local command = gsub(message,".*<TS%d+>%s+(%w+).*","%1",1);

		if ( command == "TSCANNOUNCE" ) then 
			local name = gsub(message,".*<TS%d+>%s+%w+.*n<([^>]+)>.*","%1",1);
			local rank = gsub(message,".*<TS%d+>%s+%w+.*r<([^>]*)>.*","%1",1);
			local index = gsub(message,".*<TS%d+>%s+%w+.*i<([^>]+)>.*","%1",1);
			local current = gsub(message,".*<TS%d+>%s+%w+.*c<([^>]+)>.*","%1",1);
			local texture = gsub(message,".*<TS%d+>%s+%w+.*t<([^>]*)>.*","%1",1);
			
			local playerName = user;

			DebugPrint("TSC: n("..name..") r("..rank..") t("..texture..")",DB_DEBUG);			
			
			-- Update the party list
			DivineBlessing_UpdatePartyList(playerName,name,rank,current,index,texture);

			return 0;
		else
		end
	end
end

-- Updates another player's list
function DivineBlessing_UpdatePartyList(player,spellname,spellrank,spellindex,activeindex,texture)
	local p = nil;

	if ( type(spellindex) ~= "Number" ) then spellindex = Sea.string.toInt(spellindex); end
	if ( activeindex == "" ) then activeindex = 1; end
	if ( type(activeindex) ~= "Number" ) then activeindex = Sea.string.toInt(activeindex); end

	-- check if the player is a party member
	for i=1,4,1 do 
		if ( UnitName("party"..i) ) then 
			DebugPrint (" Player: "..player.." "..UnitName("party"..i),DB_DEBUG);
		end
		if ( UnitName ("party"..i) == player ) then
			p = i;
			break;
		end
	end

	-- If the player exists as a party member
	if ( p ) then 
		p = p + 1;
		DebugPrint(p.. "!!"..type(spellindex),DB_DEBUG);
		DivineBlessing_AllyButtonMap[p][spellindex].icon = texture;
		DivineBlessing_AllyButtonMap[p][spellindex].name = spellname;
		DivineBlessing_AllyButtonMap[p][spellindex].rank = spellrank;
		DivineBlessing_AllyButtonMap[p].index = activeindex;
		
		-- Notify the gui
		DivineBlessing_UpdateSet("DivineBlessingButtonSet",p,DIVINEBLESSING_SET_SIZE);
	end
end

-- Sent Updates
function DivineBlessing_SendNextMessage()
	-- Cycle through the queue
	if ( table.getn(DB_CommQueue) > 0 ) then 
		if ( DB_CommQueue[1].type == "DBCANNOUNCE" ) then 
			DivineBlessing_SendCastAnnouncement(DB_CommQueue[1]);
		end
		table.remove(DB_CommQueue, 1);
	end

	if ( Cosmos_ScheduleByName ~= nil) then 
		Cosmos_ScheduleByName("DIVINEBLESSING_SEND",.5, DivineBlessing_SendNextMessage);
	end
end

-- Queues a Cast announcement
function DivineBlessing_QueueSetAnnouncement(set)
	local id = -1;
	local book = "";
	set = set + 0;
	if ( DivineBlessing_ButtonMap[set] ) then 
		index = DivineBlessing_ButtonMap[set].index;
		if ( index == nil ) then index = ""; end

		for j=1,DIVINEBLESSING_SET_SIZE,1 do
			id =  DivineBlessing_ButtonMap[set][j].id;
			book =  DivineBlessing_ButtonMap[set][j].book;

			DivineBlessing_QueueCastAnnouncement(id, book, j, index);
		end
	end
end	
-- Queues a Cast announcement
function DivineBlessing_QueueCastAnnouncement(id, book, spellindex, active_index)
	local spellName, subSpellName;
	local spellTexture;

	spellName = "";
	subSpellName = "";
	spellTexture = "";

	if ( id > 0 ) then
		spellName, subSpellName = GetSpellName(id, book);	
		spellTexture = GetSpellTexture(id, book);
	end
	
	local command = { 
		type="TSCANNOUNCE"; 
		name=spellName; 
		rank=subSpellName; 
		spellindex=spellindex;
		activeindex=active_index;
		texture = spellTexture;
	};

	table.insert(DB_CommQueue, command);
end

-- Send a cast announcement
function DivineBlessing_SendCastAnnouncement(command)
	local msg="";
	
	msg = DIVINEBLESSING_TAG;
	msg = msg.." ";
	msg = msg.."DBCANNOUNCE";
	msg = msg.." ";
	msg = msg.." n<"..command.name..">";
	msg = msg.." r<"..command.rank..">";
	msg = msg.." c<"..command.spellindex..">";
	msg = msg.." i<"..command.activeindex..">";
	msg = msg.." t<"..command.texture..">";

	if ( Cosmos_SendPartyMessage ) then
		Cosmos_SendPartyMessage(msg);
	end
end
--
--
--  [[ Slash Commands and Cosmos Registers
--
--
--
-- Converts the letters A-E into numbers 1-5
function DivineBlessing_BlessProcess(msg)
	if (string.find(string.upper(msg), "A") ~= nil or string.find(msg, "1") ~= nil ) then 
		DivineBlessing_Bless("1");
	elseif (string.find(string.upper(msg), "B") ~= nil or string.find(msg, "2") ~= nil ) then 
		DivineBlessing_Bless("2");
	elseif (string.find(string.upper(msg), "C") ~= nil or string.find(msg, "3") ~= nil ) then 
		DivineBlessing_Bless("3");
	elseif (string.find(string.upper(msg), "D") ~= nil or string.find(msg, "4") ~= nil ) then 
		DivineBlessing_Bless("4");
	elseif (string.find(string.upper(msg), "E") ~= nil or string.find(msg, "5") ~= nil ) then 
		DivineBlessing_Bless("5");
	else
	end
end

function DivineBlessing_TogglePane(msg)
	DivineBlessing_Toggle();	
end

-- Reset DivineBlessing
function DivineBlessing_Reset()
	for i=1,DIVINEBLESSING_SET_COUNT,1 do
		DivineBlessing_ButtonMap[i]={index=nil;};
			for j=1,DIVINEBLESSING_SET_SIZE,1 do
			DivineBlessing_ButtonMap[i][j]= {id=-1;book="";name="";subname="";wait=1};
		end
	end
	for i=1,DIVINEBLESSING_SET_COUNT,1 do
		DivineBlessing_AllyButtonMap[i]={index=nil;};
		for j=1,DIVINEBLESSING_SET_SIZE,1 do
			DivineBlessing_AllyButtonMap[i][j]= {icon="";name="";rank="";wait=0};
		end
	end

	-- Set the paladin default (Done entirely by guesswork ) -- CK
	if ( UnitClass("player") == "Paladin" ) then 
--		DivineBlessing_ButtonMap[1].wait = 0;
		for id=1,180,1 do 
			spellName, subSpellName = GetSpellName(id, "spell");
			
			if (spellName == "Blessing of Might") then 
				DivineBlessing_ButtonMap[1][1].id = id;
				DivineBlessing_ButtonMap[1][1].book = "spell";
				DivineBlessing_ButtonMap[1][2].id = id;
				DivineBlessing_ButtonMap[1][2].book = "spell";
				DivineBlessing_ButtonMap[1][3].id = id;
				DivineBlessing_ButtonMap[1][3].book = "spell";
				DivineBlessing_ButtonMap[1][4].id = id;
				DivineBlessing_ButtonMap[1][4].book = "spell";
				DivineBlessing_ButtonMap[1][5].id = id;
				DivineBlessing_ButtonMap[1][5].book = "spell";
			end
			
		end
	end	
end

--
-- Cosmos OnLoad registration
--
	
function DivineBlessing_LoadSettings()
	if (Cosmos_GetCVar) then
		DivineBlessing_ButtonMap = Cosmos_GetCVar("COS_DIVINEBLESSING_BUTTONMAP");
		if (DivineBlessing_ButtonMap == nil) then
			DivineBlessing_ButtonMap = {};
			DivineBlessing_Reset();
		end
	else
		DivineBlessing_ButtonMap = {};
		DivineBlessing_Reset();
	end
	Cosmos_RegisterCVar("COS_DIVINEBLESSING_BUTTONMAP", DivineBlessing_ButtonMap);
end

function DivineBlessing_OnLoad()
	-- Start the timer
	--if (Cosmos_ScheduleByName) then
		Cosmos_ScheduleByName("DIVINEBLESSING_SEND",10, DivineBlessing_SendNextMessage);
	--end

	-- Set the header
	local name = this:GetName();
	local header = getglobal(name.."TitleText");
	
	-- Set the number of tabs
	this.numTabs = DIVINEBLESSING_TABS;
	this.selectedTab = 1;

	if ( header ) then 
		header:SetText("|cFFee9966Divine Blessing|r");
	end
	
	-- Reset the array
	DivineBlessing_Reset();
	DebugPrint("DivineBlessing_OnLoad called.", DB_DEBUG);
	
--	RegisterForSave("DivineBlessing_ButtonMap");

--	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	--
	-- Hook the SpellButton_OnClick function
	HookFunction("SpellButton_OnClick", "DivineBlessing_WatchSpellbook", "before");

	-- Character-specific saving for the blessings
--	Cosmos_RegisterCVar("COS_DIVINEBLESSING_BUTTONMAP", DivineBlessing_ButtonMap);
--	Cosmos_SetCVar("COS_DIVINEBLESSING_BUTTONMAP", DivineBlessing_ButtonMap);
	Cosmos_RegisterVarsLoaded(DivineBlessing_LoadSettings);

	-- Register with the CosmosMaster
	if(Cosmos_RegisterConfiguration ~= nil) then
		Cosmos_RegisterConfiguration(
			"COS_DB",
			"SECTION",
			TEXT(COS_DB_SEPARATOR_TEXT),
			TEXT(COS_DB_SEPARATOR_INFO)
			);
			
		Cosmos_RegisterConfiguration(
			"COS_DB_SEPARATOR",
			"SEPARATOR",
			TEXT(COS_DB_SEPARATOR_TEXT),
			TEXT(COS_DB_SEPARATOR_INFO)
			);

		Cosmos_RegisterCVar("COS_DB_ENABLE", "1");
		Cosmos_SetCVar("COS_DB_ENABLE", "1");
		Cosmos_RegisterConfiguration(
			"COS_DB_ENABLE",					--CVar
			"CHECKBOX",							--Things to use
			TEXT(COS_DB_ENABLE_TEXT),
			TEXT(COS_DB_ENABLE_INFO),
			DivineBlessing_Enable,				--Callback
			1									--Default Checked/Unchecked
			);
	
		Cosmos_RegisterCVar("COS_DB_DELAY", "0");
		Cosmos_SetCVar("COS_DB_DELAY", "0");
		Cosmos_RegisterConfiguration(
			"COS_DB_DELAY",						--CVar
			"BOTH",								--Things to use
			TEXT(COS_DB_DELAY_TEXT),
			TEXT(COS_DB_DELAY_INFO),
			DivineBlessing_Delay,				--Callback
			0,									--Default Checked/Unchecked
			3.1, 
			.5, -- Min
			10, -- Max
			.1, -- Interval
			1, -- Display slider value
			" s" -- Appended text
			);
			
--		Cosmos_RegisterCVar("COS_DIVINE_BLESSING_IGNOREABSENT", "1");
--		Cosmos_SetCVar("COS_DIVINE_BLESSING_IGNOREABSENT", "1");
--		Cosmos_RegisterConfiguration(
--			"COS_DIVINE_BLESSING_IGNOREABSENT",	--CVar
--			"CHECKBOX",							--Things to use
--			TEXT(COS_DB_IGNOREABSENT_TEXT),
--			TEXT(COS_DB_IGNOREABSENT_INFO),
--			DivineBlessing_IgnoreAbsent,		--Callback
--			1									--Default Checked/Unchecked
--			);

		Cosmos_RegisterCVar("COS_DIVINE_BLESSING_SHOWANNOUNCE", "1");
		Cosmos_SetCVar("COS_DIVINE_BLESSING_SHOWANNOUNCE", "1");
		Cosmos_RegisterConfiguration(
			"COS_DIVINE_BLESSING_SHOWANNOUNCE",	--CVar
			"CHECKBOX",							--Things to use
			TEXT(COS_DB_SHOWANNOUNCE_TEXT),
			TEXT(COS_DB_SHOWANNOUNCE_INFO),
			DivineBlessing_ShowAnnounce,		--Callback
			1									--Default Checked/Unchecked
			);

		Cosmos_RegisterCVar("COS_DB_BANNERANNOUNCE", "1");
		Cosmos_SetCVar("COS_DB_BANNERANNOUNCE", "1");
		Cosmos_RegisterConfiguration(
			"COS_DB_BANNERANNOUNCE",			--CVar
			"CHECKBOX",							--Things to use
			TEXT(COS_DB_BANNERANNOUNCE_TEXT),
			TEXT(COS_DB_BANNERANNOUNCE_INFO),
			DivineBlessing_BannerAnnounce,		--Callback
			1									--Default Checked/Unchecked
			);

		Cosmos_RegisterCVar("COS_DIVINE_BLESSING_OVERRIDETARGET", "0");
		Cosmos_SetCVar("COS_DIVINE_BLESSING_OVERRIDETARGET", "0");
		Cosmos_RegisterConfiguration(
			"COS_DIVINE_BLESSING_OVERRIDETARGET",	--CVar
			"CHECKBOX",								--Things to use
			TEXT(COS_DB_OVERRIDETARGET_TEXT),
			TEXT(COS_DB_OVERRIDETARGET_INFO),
			DivineBlessing_OverrideTarget,			--Callback
			0
			);
			
		-- Register Cosmos Party Messages
		Cosmos_RegisterChatWatch(
			"DIVINEBLESSING_WATCHES_COSMOS", 	-- A reminder for you when you have to debug this!
			{CHANNEL_PARTY, CHANNEL_COSMOS, "WHISPER", "WHISPER_INFORM"}, -- Chat types to watch
			DivineBlessing_WatchCosmos  		-- The parser function (return 1 if the message is displayed)
			);
		
		-- Register /bless, /blessings, /divineblessing, /db
		local myCommands = {"/bless" };
		Cosmos_RegisterChatCommand(
			"DIVINE_BLESSING",
			myCommands,
			DivineBlessing_BlessProcess,
			DIVINEBLESSING_HELP
			);
			
		myCommands = {"/blessings", "/divineblessing", "/db" };
		Cosmos_RegisterChatCommand(
			"TOGGLE_DIVINE_BLESSING_PANE",
			myCommands,
			DivineBlessing_TogglePane,
			DIVINEBLESSING_HELP
			);
			
		DebugPrint("DivineBlessing_OnLoad, Cosmos Registered.", DB_DEBUG);

		Cosmos_RegisterButton (
			"Divine Blesing",
			"Blessing Sets",
			"This allows you to organize \nblessings into one button sets",
			"Interface\\Icons\\Spell_Holy_SealOfFury",
			DivineBlessing_Toggle,
			function()
-- Let's just enable this for anyone that wants a party buff tool.
--				if (UnitClass("player")=="Paladin") then
					return true; -- The button is enabled
--				else
--					return false; -- The button is disabled
--				end
			end
			);		
	end
end

