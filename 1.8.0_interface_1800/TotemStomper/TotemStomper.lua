--[[
	Totem Stomper

	Allows a shaman to choose a set of totems, 
	then share those totem sets with his party. 

	By Alexander Brazie

	$Id: TotemStomper.lua 2025 2005-07-02 23:51:34Z Sinaloit $
	$Rev: 2025 $
	$LastChangedBy: Sinaloit $
	$Date: 2005-07-02 18:51:34 -0500 (Sat, 02 Jul 2005) $
	
]]--

-- Configuration variables
COS_TOTEM_STOMPER_ENABLE	= nil;	-- set this to non nil to enable the totem stomper buttons
COS_TOTEM_STOMPER_DELAY		= nil; 	-- default delay in seconds between stomps

-- Debug Values
TS_DEBUG = "TOTEM_STOMPER_DEBUG";	-- Specifies the name of the debug flag
TOTEM_STOMPER_DEBUG=0;			-- Sets the value of the debug flag

-- Blizzard Registrations
UIPanelWindows["TotemStomperFrame"] = { area = "left", pushable = 11 };

-- Local data
local TotemStomper_CurrentID = -1;
local TotemStomper_CurrentSpellbook = "";

local TotemStomperTabs = {"self","party"};
local TotemStomper_CurrentTab = TotemStomperTabs[1];
local TotemStomper_ActiveSet = nil;

TotemStomper_ButtonMap = {};
TotemStomper_AllyButtonMap = {};

-- Constants
local TOTEMSTOMPER_SET_COUNT = 5;
local TOTEMSTOMPER_SET_SIZE = 5;
local TOTEMSTOMPER_VERSION = 1;
local TOTEMSTOMPER_TABS = 2;
local TOTEMSTOMPER_TAG = "<TS"..TOTEMSTOMPER_VERSION..">";

-- General Ideas stolen from Marek
-- Command Queue
local TS_CommQueue = {};
local TimePassed = 0;

-- Callback functions

function TotemStomper_Enable(toggle)
	Sea.io.dprint(TS_DEBUG,"Totem Stomper Enabled");
	if(toggle == 1) then 
		COS_TOTEM_STOMPER_ENABLE = 1;
	else
		COS_TOTEM_STOMPER_ENABLE = nil;
	end
end

function TotemStomper_Delay(toggle, value)
	if ( toggle == 0 ) then 
		COS_TOTEM_STOMPER_DELAY = nil;
	else
		COS_TOTEM_STOMPER_DELAY = value;
	end
		
end


-- This function handles all of the events
-- passed to this frame from the game
-- 
function TotemStomper_OnEvent()
	if ( event == "SPELLS_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" ) then 
		TotemStomper_ButtonUpdate(this);
	end
	if ( event == "VARIABLES_LOADED" or event == "UNIT_PORTRAIT_UPDATE" ) then 
		if ( event == "VARIABLES_LOADED" ) then
			-- Here to catch Error in the settings loader
			if ( TotemStomper_ButtonMap == nil or TotemStomper_ButtonMap[set] == nil ) then 
				--TotemStomper_Reset();
			end
		end
		
		-- Refresh all sets
		for set=1,TOTEMSTOMPER_SET_COUNT,1 do
			TotemStomper_UpdateSet("TotemStomperButtonSet",set,TOTEMSTOMPER_SET_SIZE);		
		end
	end
end

-- Updates the sets
function TotemStomper_OnShow()
	PanelTemplates_UpdateTabs(this);
	TotemStomper_UpdateAllSets();
	TotemStomper_ShowHelp();
end

function TotemStomper_UpdateAllSets()
	for set=1,TOTEMSTOMPER_SET_COUNT,1 do
		TotemStomper_UpdateSet("TotemStomperButtonSet",set,TOTEMSTOMPER_SET_SIZE);		
	end

end
-- Handles gui updates ever frame
function TotemStomper_Update()
end

-- Handles the OnClick event in the Spell Log
function TotemStomper_WatchSpellbook(drag)
	local id = SpellBook_GetSpellID(this:GetID());
	if ( id > MAX_SPELLS ) then
		return;
	end
	if (  IsShiftKeyDown() ) then
		Sea.io.dprint(TS_DEBUG,"id2: "..id.. " book: "..SpellBookFrame.bookType);
		TotemStomper_PickupSpell(id, SpellBookFrame.bookType );		
	elseif ( drag ) then
		Sea.io.dprint(TS_DEBUG,"id: "..id.. " book: "..SpellBookFrame.bookType);
		TotemStomper_PickupSpell(id, SpellBookFrame.bookType );
	end

	-- Drop it in 60 seconds
	Chronos.schedule(60,TotemStomper_DropSpell);
end

-- TS Button Load
function TotemStomper_ButtonLoad()
	this:RegisterForDrag("LeftButton", "RightButton");
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	this:RegisterEvent("SPELLS_CHANGED");
	this:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
	this:RegisterEvent("SPELL_UPDATE_COOLDOWN");	
end

--
-- [[ Logic Functions ]]
-- 
-- The Actual logic of Totem Stomper.
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
function TotemStomper_Stomp(set)
	if ( COS_TOTEM_STOMPER_ENABLE == nil ) then 
		return;
	end
	
	-- List the current set as the active set
	TotemStomper_ActiveSet = set+0;
	
	local index = nil;

	set = set + 0;
	if ( TotemStomper_ButtonMap[set].index ~= nil ) then 
		index = TotemStomper_ButtonMap[set].index;
	else
		index = 1;
	end

	-- If the id < 0, get the next valid id
	if ( TotemStomper_ButtonMap[set][index].id <= 0 ) then
		-- Increase the index
		index = TotemStomper_NextAvailableSpell(set, TotemStomper_ButtonMap[set].wait);

		-- Save the set index
		TotemStomper_ButtonMap[set].index = index;
	end
	
	if ( TotemStomper_ButtonMap[set][index].id > 0 ) then
		-- Get the first duration
		local id =  TotemStomper_ButtonMap[set][index].id;
		local book =  TotemStomper_ButtonMap[set][index].book;
		local start, duration, enable = GetSpellCooldown(id, book);
		
		Sea.io.dprint(TS_DEBUG,"Start: "..start.." Dur: "..duration.." Enable: "..enable);

		-- If wait is uncheck and this spell is cooling down, jump ahead
		if ( duration > 0 and TotemStomper_ButtonMap[set].wait == 0 ) then 
			index = TotemStomper_NextAvailableSpell(set, TotemStomper_ButtonMap[set].wait);

			-- Update the values
			id =  TotemStomper_ButtonMap[set][index].id;
			book =  TotemStomper_ButtonMap[set][index].book;
			start, duration, enable = GetSpellCooldown(id, book);
		end

		-- If the cooldown is all-clear
		if ( duration == 0 ) then 
			-- Queue up the announcement
			TotemStomper_QueueSetAnnouncement(set);

			-- Go to the next spell
			index = TotemStomper_NextAvailableSpell(set, TotemStomper_ButtonMap[set].wait);
				
			-- Save the set index
			TotemStomper_ButtonMap[set].index = index;

			-- Cast the old spell
			CastSpell(id, book);
		end

		if ( TotemStomper_CurrentTab == "self" ) then 
			TotemStomper_UpdateSet("TotemStomperButtonSet",set,TOTEMSTOMPER_SET_SIZE);		
		elseif ( TotemStomper_CurrentTab == "party" ) then 
			TotemStomper_UpdateSet("TotemStomperButtonSet",1,TOTEMSTOMPER_SET_SIZE);		
		end			
	end
end

-- Find the next spell in the set, skipping spells with cooldown if wait is on
function TotemStomper_NextAvailableSpell(set, wait) 
	if ( wait == nil ) then wait = 1; end
	Sea.io.dprint(TS_DEBUG,"NAS: Set ("..set..") Wait: "..wait);

	-- Find the current set index
	index = TotemStomper_ButtonMap[set].index; 

	-- If it hasnt been started, start at the first slot (which is 1)
	if ( index == nil ) then index = 1; end
	
	-- Increase the index
	index = index + 1;
	if ( index > TOTEMSTOMPER_SET_SIZE ) then
		index = 1;
	end

	-- Get the id/book
	local id =  TotemStomper_ButtonMap[set][index].id;
	local book =  TotemStomper_ButtonMap[set][index].book;
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
		if ( index > TOTEMSTOMPER_SET_SIZE ) then
			index = 1;
			break;
		end

		-- Get the id/book
		id =  TotemStomper_ButtonMap[set][index].id;
		book =  TotemStomper_ButtonMap[set][index].book;

		-- Update the duration
		if ( id > 0 ) then 
			start, duration, enable = GetSpellCooldown(id, book);
		end
	end

	return index;
end

-- TS Button Event Handler
function TotemStomper_ButtonEvent(event)
	if ( event == "SPELL_UPDATE_COOLDOWN" ) then
		TotemStomper_ButtonUpdate(this);
	end
end

-- Move the Spell around if you're looking at your own tabs
function TotemStomper_ButtonDragStart()
	local col, row = TotemStomper_GetCurrentLocation(this);		

	if ( TotemStomper_CurrentTab == "self" ) then 
		-- Pick up the current spell
		TotemStomper_SwapButton(row,col);
	end
end

-- Update an entire set of buttons
function TotemStomper_UpdateSet(setbasename,set,size) 
	if ( set == nil ) then return; end
	--Sea.io.dprint(TS_DEBUG,"Setname: "..setbasename.." Set:"..set.. " ("..size..")");
	for i=1,size,1 do
		TotemStomper_ButtonUpdate(getglobal(setbasename..set..i));
	end

	-- Updates the gui elements based on the player's settings
	if ( TotemStomper_CurrentTab == "self") then
		local check = nil;
		if ( TotemStomper_ButtonMap[set] ) then
			check = TotemStomper_ButtonMap[set].wait;
		end
		if ( check == nil ) then check = 1; end
		getglobal(setbasename..set.."Wait"):SetChecked(check);
		getglobal(setbasename..set.."Wait"):Show();
		getglobal(setbasename..set.."WaitText"):Show();
		getglobal(setbasename..set.."Portrait"):Hide();
		getglobal(setbasename..set.."NameText"):Hide();
		getglobal(setbasename..set.."Label"):Show();	
	-- Updates the gui elements based on the party settings
	elseif ( TotemStomper_CurrentTab == "party" ) then 		
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
		if ( UnitClass(portrait) ~= "Shaman" ) then 		
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
function TotemStomper_UseButton(row, col)
	local col, row = TotemStomper_GetCurrentLocation(this);		
	if ( TotemStomper_CurrentTab == "self" ) then 
		if ( TotemStomper_ButtonMap[row][col].id > 0 ) then 
			CastSpell(TotemStomper_ButtonMap[row][col].id,
				TotemStomper_ButtonMap[row][col].book);
		end
	end
end

-- Erases the old button with the hand
function TotemStomper_SetButton(row, col) 
	--Sea.io.dprint(TS_DEBUG,"Row: "..row.." Col:"..col);

	-- Set the new button
	TotemStomper_ButtonMap[row][col] = {id=TotemStomper_CurrentID,book=TotemStomper_CurrentSpellbook};
	TotemStomper_DropSpell();

	TotemStomper_ButtonUpdate(this);	
end

-- Swaps the specified button into hand
function TotemStomper_SwapButton(row,col)
	--Sea.io.dprint(TS_DEBUG,"Row: "..row.." Col:"..col);
	-- Store the old value if one exists
	local temp = nil;
	if ( TotemStomper_ButtonMap[row][col].id > 0 ) then 
		temp = TotemStomper_ButtonMap[row][col];
	end

	-- Drop the current button
	TotemStomper_SetButton(row, col);
	
	-- Load the old one into the cursor
	if ( temp ) then 
		if ( temp.id > 0 ) then 
			TotemStomper_PickupSpell(temp.id, temp.book);
			PickupSpell(temp.id, temp.book );
		end
	end
end

-- TotemStomperTab_OnClick
function TotemStomperTab_OnClick(button)
	TotemStomper_CurrentTab = TotemStomperTabs[button:GetID()];
	TotemStomper_ShowHelp();
	TotemStomper_UpdateAllSets();
end
--
-- Swap or pick up if clicked with or without a full hand
--   Set the index if you're an alt press
-- 
function TotemStomper_ButtonClick()
	local col, row = TotemStomper_GetCurrentLocation(this);		
	this:SetChecked("false");
	
	if ( TotemStomper_CurrentTab == "self" ) then 
		-- Pick up the current spell
		if( IsShiftKeyDown() ) then 
			TotemStomper_SwapButton(row,col);
		-- Set the next spell
		elseif( IsAltKeyDown() ) then 
			TotemStomper_ButtonMap[row].index = col;
			TotemStomper_UpdateSet("TotemStomperButtonSet",row,TOTEMSTOMPER_SET_SIZE);		
		-- Drop the new spell
		elseif( TotemStomper_CurrentID > 0 ) then
			TotemStomper_SwapButton(row,col);
		-- Use the stored spell
		else 	
			TotemStomper_UseButton(row,col);		
		end
	elseif ( TotemStomper_CurrentTab == "party" ) then 
		-- Uses the spell if its yours
		if ( row == 1 and TotemStomper_ActiveSet ) then 
			TotemStomper_UseButton(TotemStomper_ActiveSet,col);		
		end
	end
end

function TotemStomper_ButtonDragEnd()
	if ( TotemStomper_CurrentTab == "self" ) then 
		if( TotemStomper_CurrentID > 0 ) then
			local col, row = TotemStomper_GetCurrentLocation(this);		
			TotemStomper_SwapButton(row,col);
		end
	end
end

-- Displays the tooltip of the spell in the box.
function TotemStomper_ButtonEnter()
	local col, row = TotemStomper_GetCurrentLocation(this);		

	if ( TotemStomper_CurrentTab == "self" ) then 
		local id = TotemStomper_ButtonMap[row][col].id;
		local spellbook = TotemStomper_ButtonMap[row][col].book;

		if ( id > 0 ) then 
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
			if ( GameTooltip:SetSpell(id, spellbook) ) then
				this.updateTooltip = TOOLTIP_UPDATE_TIME;
			else
				this.updateTooltip = nil;
			end	
		end
	elseif ( TotemStomper_CurrentTab == "party" ) then 
		-- displays full tooltip
		if ( row == 1 and TotemStomper_ActiveSet ) then 
			local id = TotemStomper_ButtonMap[TotemStomper_ActiveSet][col].id;
			local spellbook = TotemStomper_ButtonMap[TotemStomper_ActiveSet][col].book;

			if ( id > 0 ) then 
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
				if ( GameTooltip:SetSpell(id, spellbook) ) then
					this.updateTooltip = TOOLTIP_UPDATE_TIME;
				else
					this.updateTooltip = nil;
				end	
			end
		else 
			-- Display the party tooltip data
			if ( TotemStomper_AllyButtonMap[row] ) then 
				if ( TotemStomper_AllyButtonMap[row][col].name ~= "" ) then
					GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
					local tooltip = TotemStomper_AllyButtonMap[row][col].name;
					if ( TotemStomper_AllyButtonMap[row][col].rank ~= "" ) then
						tooltip = tooltip.."\n |cFFDDDDDD("..TotemStomper_AllyButtonMap[row][col].rank..")|r";
					end
					GameTooltip:SetText(tooltip);
				end
			end
		end
	end
end

function TotemStomper_WaitButtonEnter()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	GameTooltip:SetText(TOTEMSTOMPER_WAIT_TIP);
end
function TotemStomper_WaitButtonLeave()
	GameTooltip:Hide();
end
function TotemStomper_SetWait(set,state)
	if ( state == true or state == 1 ) then 
		TotemStomper_ButtonMap[set].wait = 1;	
	else
		TotemStomper_ButtonMap[set].wait = 0;	
	end
end

function TotemStomper_ButtonLeave()
	GameTooltip:Hide();
end

function TotemStomper_ButtonLoad()
end

-- Totem Stomper Self Texture Button
function TotemStomper_SetSelfTexture(button, row, col) 
	local name = button:GetName();	
	local icon = getglobal(name.."Icon");
	local cooldown = getglobal(name.."Cooldown");

	if (  TotemStomper_ButtonMap[row] == nil ) then return end
	local id = TotemStomper_ButtonMap[row][col].id;
	local spellbook = TotemStomper_ButtonMap[row][col].book;

	if ( id > 0 ) then 
		-- Set the index to checked if true
		if ( TotemStomper_ButtonMap[row].index == col ) then 
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
		--Sea.io.dprint(TS_DEBUG,"Start: "..start.." Dur: "..duration.." Enable: "..enable);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
	
		-- Check if an ally is using the same spell
		local spellName, spellRank = GetSpellName(id, spellbook);	

		-- Compare this spell rank to your allies
		compare = TotemStomper_CompareSpells(spellName, spellRank, 1);

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
-- Totem Stomper Self Texture Button
function TotemStomper_SetAllyTexture(button, row, col) 
	local name = button:GetName();	
	local icon = getglobal(name.."Icon");
	local cooldown = getglobal(name.."Cooldown");

	-- Remember we're going to change the ally textures.

	if (  TotemStomper_AllyButtonMap[row] == nil ) then return end

	if ( icon ~= "" ) then 
		-- Set the index to checked if true
		if ( TotemStomper_AllyButtonMap[row].index == col ) then 
			button:SetChecked("true");
		end
	
		-- Set the pretty texture
		local texture = TotemStomper_AllyButtonMap[row][col].icon;
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
		--Sea.io.dprint(TS_DEBUG,"Start: "..start.." Dur: "..duration.." Enable: "..enable);
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
		]]

		-- Compare this spell rank to your allies
		compare = TotemStomper_CompareSpells(TotemStomper_AllyButtonMap[row][col].name, TotemStomper_AllyButtonMap[row][col].rank, row);
		
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

-- Totem Stomper Spell Comparator
function TotemStomper_CompareSpells(name, rank, skiprow)
	local spellCompare = nil; -- nil means no conflict, -1 means its weak, 1 means its the best, 0 means its the same
	
	for i=1,5,1 do 
		-- Send skip row 
		if ( i == skiprow ) then 
		else 
			for j=1,TOTEMSTOMPER_SET_SIZE,1 do
				spellName = nil;
				spellRank = nil;
				if ( i == 1 ) then 
					if ( TotemStomper_ActiveSet and TotemStomper_ActiveSet > 0 ) then
						tid = TotemStomper_ButtonMap[TotemStomper_ActiveSet][j].id;
						if ( tid > 0 ) then
							tbook = TotemStomper_ButtonMap[TotemStomper_ActiveSet][j].book;
							spellName, spellRank = GetSpellName(tid, tbook);	
						end
					end
					
				else 
					spellName = TotemStomper_AllyButtonMap[i][j].name;	
					spellRank = TotemStomper_AllyButtonMap[i][j].rank;	
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
-- Totem Stomper Button Update
function TotemStomper_ButtonUpdate(button)
	-- Check the button
	if ( button == nil ) then return; end
	
	-- Uncheck it
	button:SetChecked("false");
	local col, row = TotemStomper_GetCurrentLocation(button);

	-- Check for errors
	if ( col == nil or row == nil ) then return; end
	
	-- Handle Tabs
	if ( TotemStomper_CurrentTab == "self" ) then 
		-- Enable the button
		button:Enable();
		TotemStomper_SetSelfTexture(button, row, col);
	elseif ( TotemStomper_CurrentTab == "party" ) then
		-- Select the correct party member.
		local character = "party";
		if ( row == 1 ) then 
			character = "player";
		else
			character = character..(row - 1);
		end
		
		-- Set the button
		if ( UnitClass(character) == "Shaman" ) then 		
			button:Enable();
		else
			button:Disable();
		end	

		-- Set the texture
		if ( row == 1 ) then 
			if ( not TotemStomper_ActiveSet ) then
				button:Disable();
				getglobal(button:GetName().."Icon"):Hide();
			else
				TotemStomper_SetSelfTexture(button, TotemStomper_ActiveSet, col);	
			end
		else 
			local pName = UnitName(character);

			if ( pName == nil or UnitClass(character) ~= "Shaman" ) then 
				getglobal(button:GetName().."Icon"):Hide();
			end
	
			-- Sets an allied texture
			TotemStomper_SetAllyTexture(button, row, col);				
		end
	end
end
-- Shows help text
function TotemStomper_ShowHelp()
	local helptext = getglobal("TotemStomperFrameHelpText");
	if ( helptext ) then 
		if ( TotemStomper_CurrentTab == "self" ) then
			helptext:SetText(TOTEMSTOMPER_INSTRUCTION);
		elseif ( TotemStomper_CurrentTab == "party" ) then
			helptext:SetText(TOTEMSTOMPER_PARTY_INSTRUCTION);
		end
	end
	
end

-- Shows help text
function TotemStomper_PrintHelp()
	if ( TotemStomper_CurrentTab == "self" ) then
		Sea.io.print(TOTEMSTOMPER_FULL_INSTRUCTIONS);
	elseif ( TotemStomper_CurrentTab == "party" ) then
		Sea.io.print(TOTEMSTOMPER_TOTEMSHARE_INSTRUCTIONS);
	end
end
-- Tracks the last spell picked up
function TotemStomper_PickupSpell(id, bookType) 
	TotemStomper_CurrentID = id;
	TotemStomper_CurrentSpellbook = bookType;
end

function TotemStomper_DropSpell()
	TotemStomper_CurrentID = -1;
	TotemStomper_CurrentSpellbook = "";
	PickupSpell(511,"spell");
end

-- Returns the current button location
function TotemStomper_GetCurrentLocation(object)
	--Sea.io.dprint(TS_DEBUG,this:GetName()..""..object:GetID().." "..object:GetParent():GetName()..": "..object:GetParent():GetID());
	return object:GetID(), object:GetParent():GetID();
end

-- Show/hide the Totem Stomper Frame
function TotemStomper_Toggle()
	if ( TotemStomperFrame ) then 
		if ( TotemStomperFrame:IsVisible() ) then 
			HideUIPanel(TotemStomperFrame);
		else	
			ShowUIPanel(TotemStomperFrame);
		end
	else
		Sea.io.print("TotemStomper did not load. Please check your logs/FrameXML.log file and report this error");
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
function TotemStomper_GetAlert(message, user, system, time)
	Sea.io.dprint(TS_DEBUG,"TS Message: ",message," (",user,")");
	
	local command = gsub(message,".*<TS%d+>%s+(%w+).*","%1",1);

	if ( command == "TSCANNOUNCE" ) then 
		local name = gsub(message,".*<TS%d+>%s+%w+.*n<([^>]+)>.*","%1",1);
		local rank = gsub(message,".*<TS%d+>%s+%w+.*r<([^>]*)>.*","%1",1);
		local index = gsub(message,".*<TS%d+>%s+%w+.*i<([^>]+)>.*","%1",1);
		local current = gsub(message,".*<TS%d+>%s+%w+.*c<([^>]+)>.*","%1",1);
		local texture = gsub(message,".*<TS%d+>%s+%w+.*t<([^>]*)>.*","%1",1);
		
		local playerName = user;
		Sea.io.dprint(TS_DEBUG,"TSC: n("..name..") r("..rank..") t("..texture..")");			
		
		-- Update the party list
		TotemStomper_UpdatePartyList(playerName,name,rank,current,index,texture);
		return 0;
	else
	end
end

-- Updates another player's list
function TotemStomper_UpdatePartyList(player,spellname,spellrank,spellindex,activeindex,texture)
	local p = nil;
	
	if ( type(spellindex) ~= "Number" ) then spellindex = spellindex + 0; end
	if ( activeindex == "" ) then activeindex = 1; end
	if ( type(activeindex) ~= "Number" ) then activeindex = Sea.string.toInt(activeindex); end

	-- check if the player is a party member
	for i=1,4,1 do 
		if ( UnitName("party"..i) ) then 
			Sea.io.dprint(TS_DEBUG," Player: "..player.." "..UnitName("party"..i));
		end
		if ( UnitName ("party"..i) == player ) then
			p = i;
			break;
		end
	end

	-- If the player exists as a party member
	if ( p ) then 
		p = p + 1;
		Sea.io.dprint(TS_DEBUG,p.. "!!"..type(spellindex));
		TotemStomper_AllyButtonMap[p][spellindex].icon = texture;
		TotemStomper_AllyButtonMap[p][spellindex].name = spellname;
		TotemStomper_AllyButtonMap[p][spellindex].rank = spellrank;
		TotemStomper_AllyButtonMap[p].index = activeindex;
		
		-- Notify the gui
		TotemStomper_UpdateSet("TotemStomperButtonSet",p,TOTEMSTOMPER_SET_SIZE);
	end
end

function TotemStomper_ScheduleNextMessage()
	if ( table.getn(TS_CommQueue) <= 0 ) then 
		return;
	end
	if ( Chronos.scheduleByName ~= nil) then 
		Chronos.scheduleByName("TOTEMSTOMPER_SEND",.5, TotemStomper_SendNextMessage);
	else
		TotemStomper_SendNextMessage();
	end
end

-- Sent Updates
function TotemStomper_SendNextMessage()
	-- Cycle through the queue
	if ( table.getn(TS_CommQueue) > 0 ) then 
		if ( TS_CommQueue[1].type == "TSCANNOUNCE" ) then 
			TotemStomper_SendCastAnnouncement(TS_CommQueue[1]);
		end
		table.remove(TS_CommQueue, 1);
	end

	TotemStomper_ScheduleNextMessage();
end

-- Queues a Cast announcement
function TotemStomper_QueueSetAnnouncement(set)
	local id = -1;
	local book = "";
	set = set + 0;
	if ( TotemStomper_ButtonMap[set] ) then 
		index = TotemStomper_ButtonMap[set].index;
		if ( index == nil ) then index = ""; end

		for j=1,TOTEMSTOMPER_SET_SIZE,1 do
			id =  TotemStomper_ButtonMap[set][j].id;
			book =  TotemStomper_ButtonMap[set][j].book;

			TotemStomper_QueueCastAnnouncement(id, book, j, index);
		end
	end
end	
-- Queues a Cast announcement
function TotemStomper_QueueCastAnnouncement(id, book, spellindex, active_index)
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

	TotemStomper_AddCommand(command);
end

function TotemStomper_AddCommand(command)
	table.insert(TS_CommQueue, command);
	TotemStomper_ScheduleNextMessage();
end

-- Send a cast announcement
function TotemStomper_SendCastAnnouncement(command)
	local msg="";
	
	msg = TOTEMSTOMPER_TAG;
	msg = msg.." ";
	msg = msg.."TSCANNOUNCE";
	msg = msg.." ";
	msg = msg.." n<"..command.name..">";
	msg = msg.." r<"..command.rank..">";
	msg = msg.." c<"..command.spellindex..">";
	msg = msg.." i<"..command.activeindex..">";
	msg = msg.." t<"..command.texture..">";

	if ( Sky ) then
		Sky.sendAlert(msg, SKY_PARTY, "TS");
	end
end
--
--
--  [[ Slash Commands and Cosmos Registers
--
--
--
-- Converts the letters A-E into numbers 1-5
function TotemStomper_StompProcess(msg)
	if (string.find(string.upper(msg), "A") ~= nil or string.find(msg, "1") ~= nil ) then 
		TotemStomper_Stomp("1");
	elseif (string.find(string.upper(msg), "B") ~= nil or string.find(msg, "2") ~= nil ) then 
		TotemStomper_Stomp("2");
	elseif (string.find(string.upper(msg), "C") ~= nil or string.find(msg, "3") ~= nil ) then 
		TotemStomper_Stomp("3");
	elseif (string.find(string.upper(msg), "D") ~= nil or string.find(msg, "4") ~= nil ) then 
		TotemStomper_Stomp("4");
	elseif (string.find(string.upper(msg), "E") ~= nil or string.find(msg, "5") ~= nil ) then 
		TotemStomper_Stomp("5");
	else
	end
end

-- Reset TotemStomper
function TotemStomper_Reset()
	for i=1,TOTEMSTOMPER_SET_COUNT,1 do
		TotemStomper_ButtonMap[i]={index=nil;};
			for j=1,TOTEMSTOMPER_SET_SIZE,1 do
			TotemStomper_ButtonMap[i][j]= {id=-1;book="";name="";subname="";wait=1};
		end
	end
	for i=1,TOTEMSTOMPER_SET_COUNT,1 do
		TotemStomper_AllyButtonMap[i]={index=nil;};
		for j=1,TOTEMSTOMPER_SET_SIZE,1 do
			TotemStomper_AllyButtonMap[i][j]= {icon="";name="";rank="";wait=0};
		end
	end

	-- Set the shaman default (Done entirely by guesswork ) -- Alex
	if ( UnitClass("player") == "Shaman" ) then 
		TotemStomper_ButtonMap[1].wait = 0;
		for id=1,180,1 do 
			spellName, subSpellName = GetSpellName(id, "spell");
			
			if (spellName == "Stoneclaw Totem") then 
				TotemStomper_ButtonMap[1][1].id = id;
				TotemStomper_ButtonMap[1][1].book = "spell";
			end
			if (spellName == "Searing Totem") then 
				TotemStomper_ButtonMap[1][2].id = id;
				TotemStomper_ButtonMap[1][2].book = "spell";
			end
			if (spellName == "Healing Stream Totem") then 
				TotemStomper_ButtonMap[1][3].id = id;
				TotemStomper_ButtonMap[1][3].book = "spell";
			end			
			if (spellName == "Grace of Air Totem") then 
				TotemStomper_ButtonMap[1][4].id = id;
				TotemStomper_ButtonMap[1][4].book = "spell";
			end
			
		end
	end	
end

--
-- Cosmos OnLoad registration
--
function TotemStomper_OnLoad()
	-- Start the timer
	--if (Chronos) then
		Chronos.scheduleByName("TOTEMSTOMPER_SEND",10, TotemStomper_SendNextMessage);
	--end

	-- Set the header
	local name = this:GetName();
	local header = getglobal(name.."TitleText");
	
	-- Set the number of tabs
	this.numTabs = TOTEMSTOMPER_TABS;
	this.selectedTab = 1;

	if ( header ) then 
		header:SetText("|cFFee9966"..TOTEMSTOMPER_BUTTON_TITLE.."|r");
	end
	
	-- Reset the array
	TotemStomper_Reset();
	Sea.io.dprint(TS_DEBUG,"TotemStomper_OnLoad called.");
	
	RegisterForSave("TotemStomper_ButtonMap");

	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	--
	-- Hook the SpellButton_OnClick function
	Sea.util.hook("SpellButton_OnClick", "TotemStomper_WatchSpellbook", "before");
	
	if ( Sky ) then 
		Sky.registerAlert(
			{
				id="TS";
				func=TotemStomper_GetAlert;
				description="TotemStomper";
			}
			);
	end
	
	if ( Khaos ) then
	-- Register with the CosmosMaster
	elseif(Cosmos_RegisterConfiguration ~= nil) then
		Cosmos_RegisterConfiguration(
			"COS_TS",
			"SECTION",
			TEXT(COS_TS_SEPARATOR_TEXT),
			TEXT(COS_TS_SEPARATOR_INFO)
			);
		Cosmos_RegisterConfiguration(
			"COS_TS_SEPARATOR",
			"SEPARATOR",
			TEXT(COS_TS_SEPARATOR_TEXT),
			TEXT(COS_TS_SEPARATOR_INFO)
			);

		Cosmos_RegisterConfiguration(
			"COS_TS_ENABLE",	--CVar
			"CHECKBOX",						--Things to use
			TEXT(COS_TS_ENABLE_TEXT),
			TEXT(COS_TS_ENABLE_INFO),
			TotemStomper_Enable,		--Callback
			1							--Default Checked/Unchecked
			);
	
		Cosmos_RegisterConfiguration(
			"COS_TS_DELAY",		--CVar
			"BOTH",					--Things to use
			TEXT(COS_TS_DELAY_TEXT),
			TEXT(COS_TS_DELAY_INFO),
			TotemStomper_Delay,			--Callback
			0,	--Default Checked/Unchecked
			3.1, 
			.5, -- Min
			10, -- Max
			.1, -- Interval
			1, -- Display slider value
			" s" -- Appended text
			);

		-- Register /stomp
		local myCommands = {"/stomp"};
		Cosmos_RegisterChatCommand(
			"TOTEM_STOMPER",
			myCommands,
			TotemStomper_StompProcess,
			TOTEMSTOMPER_HELP
			);
		Sea.io.dprint(TS_DEBUG,"TotemStomper_OnLoad, Cosmos Registered.");

		Cosmos_RegisterButton (
			TOTEMSTOMPER_BUTTON_TITLE,
			TOTEMSTOMPER_BUTTON_SUBTITLE,
			TOTEMSTOMPER_BUTTON_TIP,
			"Interface\\Icons\\Spell_Totem_WardOfDraining",
			TotemStomper_Toggle,
			function()
				return true;
				--[[
				if (UnitClass("player")=="Shaman") then
					return true; -- The button is enabled
				else
					return false; -- The button is disabled
				end
				]]
			end
			);		
	end
end

