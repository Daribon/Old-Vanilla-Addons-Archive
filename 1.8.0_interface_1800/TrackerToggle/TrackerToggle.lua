--------------------------------------------------------------------------
-- TrackerToggle.lua 
--------------------------------------------------------------------------
--[[
TrackerToggle
	Allows Right Click Selection of Tracking Mode/Left Click Cycling

v0.1
- MobileFrames Optional, if included can left-click on Tracking button to cycle tracking
- Added Keybinding for TrackerToggle_CycleTracking
- TrackerToggle_CycleTracking hides tooltip if mouse is over MiniMapTrackingFrame for now
  Possibly change tooltip to be accurate later.
- Right click brings up menu, current tracking checked, click to choose new one.
- SortTable created at startup based on values in TrackingAbilities for ordering
  Only have to add new abilities to 1 table now.

v0.2
- ReImplemented as a Class structure.
- Set default to disabled, initSpells will enable if needed. Prevents bringing up menu before it is ready.
- Fixed initSpells so that it re-enables TrackerToggle if 2 or more trackers available.
- Moved SortTable population/sorting to onLoad instead of afterInit to guarantee population before
  initSpells has happened.

v0.3
- cycleTracking now works if you only have 1 tracking ability. it will start up that 1 ability.
  This was done so you could use the key bound to cycleTracking for all characters even ones w/ just 1
  tracking mode.

v1.0
- Tooltip now changes when Tracking is cycled if mouse is still over
  MiniMapTrackingFrame

TODO : Consider having menu offset change based on where button is.

$Id: TrackerToggle.lua 2025 2005-07-02 23:51:34Z Sinaloit $
$Rev: 2025 $
$LastChangedBy: Sinaloit $
$Date: 2005-07-02 18:51:34 -0500 (Sat, 02 Jul 2005) $

]]--

TrackerToggleData = {
	-- Default to off.
	Disabled = true;
	-- false if numTrackers == 0 or > 2, spellNum otherwise
	oneTracking = false;
	-- Old GetTrackingTexture(), needed for tooltip updating.
	oldTracking = nil;

	-- Auto populated
	SortTable = { };
	-- Function to populate SortTable
	initSort = function()
		for k,v in TrackerToggleData.TrackingAbilities do
			local newOrderInfo = { name = k, order = v.spellNum };
			table.insert(TrackerToggleData.SortTable, newOrderInfo);
		end
		table.sort(TrackerToggleData.SortTable, function(a,b) return (a.order < b.order); end);
	end;

	-- Format: [SpellName from Localization] = { spellnum = orderNumber, header = trackingType }
	TrackingAbilities = {
		[TT_SPELL_TYPE_FIND]        = { spellNum = 1, header = nil },
		[TT_SPELL_FIND_HERBS]       = { spellNum = 2, header = TT_SPELL_TYPE_FIND },
		[TT_SPELL_FIND_MINERALS]    = { spellNum = 3, header = TT_SPELL_TYPE_FIND },
		[TT_SPELL_FIND_TREASURE]    = { spellNum = 4, header = TT_SPELL_TYPE_FIND },
		[TT_SPELL_TYPE_TRACK]       = { spellNum = 5, header = nil },
		[TT_SPELL_TRACK_BEASTS]     = { spellNum = 6, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_DEMONS]     = { spellNum = 7, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_DRAGONKIN]  = { spellNum = 8, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_ELEMENTALS] = { spellNum = 9, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_GIANTS]     = { spellNum = 10, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_HIDDEN]     = { spellNum = 11, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_HUMANOIDS]  = { spellNum = 12, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TRACK_UNDEAD]     = { spellNum = 13, header = TT_SPELL_TYPE_TRACK },
		[TT_SPELL_TYPE_SENSE]       = { spellNum = 14, header = nil },
		[TT_SPELL_SENSE_DEMONS]     = { spellNum = 15, header = TT_SPELL_TYPE_SENSE },
		[TT_SPELL_SENSE_UNDEAD]     = { spellNum = 16, header = TT_SPELL_TYPE_SENSE },
	};
}

TrackerToggle = {
	-- Initialize spellName to spellNum table, headers = -1 * (number of spells known for that header)
	initSpells = function()
		local i, numTrackers = 1,0;
		local headerRef = nil;
		local ttAbil = TrackerToggleData.TrackingAbilities;

		-- Reset Tracking List
		for k,v in ttAbil do
			ttAbil[k].spellNum = 0;
		end

		-- Add Tracking Spells
		while (true) do
			local spellName, spellRank = GetSpellName(i, SpellBookFrame.bookType);
			if (not spellName) then
				do break end;
			elseif (ttAbil[spellName]) then
				numTrackers = numTrackers + 1;
				if (not TrackerToggleData.oneTracking) then
					TrackerToggleData.oneTracking = i;
				end
				ttAbil[spellName].spellNum = i;
				ttAbil[ttAbil[spellName].header].spellNum = ttAbil[ttAbil[spellName].header].spellNum - 1;
			end
			i = i + 1;
		end

		if (numTrackers < 2) then
			TrackerToggleData.Disabled = true;
			if (not numTrackers) then
				TrackerToggleData.oneTracking = false;
			end
		else
			TrackerToggleData.Disabled = false;
			TrackerToggleData.oneTracking = false;
		end
	end;

	Init = function()
		TrackerToggle.initSpells()
	end;

	openMenu = function()
		local menulist = TrackerToggle.createMenu();
		EarthMenu_MenuOpen(menulist, this:GetName(), 0, 0, "MENU");
	end;

	-- Creates menu, spellNum > 0 = known spell, < 0 = header, =0 = not known or no known spells under header.
	createMenu = function()
		local info = {};
		local trackingTexture = GetTrackingTexture();
		local ttAbil = TrackerToggleData.TrackingAbilities;

		info[1] = { text = TRACKERTOGGLE_MENU_CLOSE, func = function () end; };
		info[2] = { text = "|cFFCCCCCC------------|r", disabled = 1, notClickable = 1 };

		local i = 3
		for k,v in TrackerToggleData.SortTable do
			if ( ttAbil[v.name].spellNum < 0 ) then
				if (i > 3) then
					info[i] = { text = "", notClickable = 1 };
					i = i + 1;
				end
				info[i] = { text = v.name, isTitle = 1, notClickable = 1 };
				i = i + 1;
			elseif ( ttAbil[v.name].spellNum > 0 ) then
				info[i] = { text = v.name, value = ttAbil[v.name].spellNum, func = TrackerToggle.castSpell };
				info[i].checked = (trackingTexture == GetSpellTexture(ttAbil[v.name].spellNum, 1));
				i = i + 1;
			end
		end

		info[i] = { text = "|cFFCCCCCC------------|r", disabled = 1, notClickable = 1 };
		i = i + 1;
		info[i] = { text = TRACKERTOGGLE_STOP_TRACKING, func = CancelTrackingBuff };

		return info;
	end;

	-- EarthMenu passes info.checked and info.value to info.func, we only need the
	-- info.value, so here is an intermediary function to use it.
	castSpell = function(checked, spellNum)
		CastSpell(spellNum, 1);
		TrackerToggleData.oldTracking = GetTrackingTexture();
		Chronos.scheduleByName("TrackerToggleTooltip", .5, TrackerToggle.changeTooltip, 10);
	end;

	-- Check every .5 seconds for 5 seconds, if the tracking texture changes 
	-- update the tooltip if the mouse is over the tracking button still.
	changeTooltip = function(count)
		if (TrackerToggleData.oldTracking) then
			if (GetTrackingTexture() ~= TrackerToggleData.oldTracking) then
				TrackerToggleData.oldTracking = nil;
				if (MouseIsOver(MiniMapTrackingFrame)) then
					GameTooltip:Hide();
					GameTooltip:SetOwner(MiniMapTrackingFrame, "ANCHOR_BOTTOMLEFT");
					GameTooltip:SetTrackingSpell();
				end
				return;
			end
			if (count) then
				Chronos.scheduleByName("TrackerToggleTooltip", .5, TrackerToggle.changeTooltip, (count - 1));
			end
		end
	end;

	cycleTracking = function()
		if (TrackerToggleData.Disabled) then
			local spellNum = TrackerToggleData.oneTracking;
			if (spellNum) then
				-- Dont cast if its already up.
				if (GetTrackingTexture() ~= GetSpellTexture(spellNum, 1)) then
					CastSpell(spellNum, 1);
				end
			end
			return; 
		end
		local foundTracking = false;
		local firstTracking = nil;
		local trackingTexture = GetTrackingTexture();
		local ttAbil = TrackerToggleData.TrackingAbilities;

		for k,v in TrackerToggleData.SortTable do
			if ( ttAbil[v.name].spellNum > 0 ) then
				if (not firstTracking) then
					-- First Tracking mode found.
					firstTracking = v.name;
				end
				if (foundTracking) then
					CastSpell(ttAbil[v.name].spellNum, 1);
					if (MouseIsOver(MiniMapTrackingFrame)) then
						TrackerToggleData.oldTracking = trackingTexture;
						Chronos.scheduleByName("TrackerToggleTooltip", .5, TrackerToggle.changeTooltip, 10);
					end
					return;
				elseif (trackingTexture == GetSpellTexture(ttAbil[v.name].spellNum, 1)) then
					foundTracking = true;
				end
			end
		end

		-- Either nothing was found, or the last one was found, so start at top.
		if (firstTracking) then
			CastSpell(ttAbil[firstTracking].spellNum, 1);
			if (MouseIsOver(MiniMapTrackingFrame)) then
				TrackerToggleData.oldTracking = trackingTexture;
				Chronos.scheduleByName("TrackerToggleTooltip", .5, TrackerToggle.changeTooltip, 10);
			end
		end
	end;

	onLoad = function()
		-- Populate and sort SortTable before anything else is done.
		TrackerToggleData.initSort();

		-- Right click tracking functionality
		Sea.util.hook( "CancelTrackingBuff", "TrackerToggle_CancelTrackingBuff", "replace" );
		-- If MobileFrames is present we can hook OnClick for left click functionality
		if (MobileFrames_MobileMinimapButton_OnClick) then
			Sea.util.hook( "MobileFrames_MobileMinimapButton_OnClick", "TrackerToggle_TrackButton_OnClick", "replace");
		end
		Chronos.afterInit(TrackerToggle.Init);

		this:RegisterEvent("SPELLS_CHANGED");
		this:RegisterEvent("LEARNED_SPELL_IN_TAB");
	end;

	onEvent = function(event)
		if (event == "SPELLS_CHANGED" or event == "LEARNED_SPELL_IN_TAB") then
			-- Learned a new spell, need to re-initialize spellNums.
			TrackerToggle.initSpells()
		end
	end;
}

function TrackerToggle_CancelTrackingBuff()
	if (not MouseIsOver(MiniMapTrackingFrame)) then 
		return true;
	end
	if (TrackerToggleData.Disabled) then return true; end;
	GameTooltip:Hide();
	TrackerToggle.openMenu();
	return false;
end

function TrackerToggle_TrackButton_OnClick(buttonFrame, clickFunction)
	if (not MouseIsOver(MiniMapTrackingFrame)) then return true; end;
	if (TrackerToggleData.Disabled) then return true; end;
	if (not IsShiftKeyDown()) then
		if (arg1 == "LeftButton") then
			TrackerToggle.cycleTracking();
			return false;
		end
	end
	return true;
end
