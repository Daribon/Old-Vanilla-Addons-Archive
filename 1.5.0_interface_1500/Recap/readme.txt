
  Recap 2.64

  Revision history:

	2.64, 6/9/05  - bug fixed: when pets merge, party/raidmembers are shown correctly.
			added: in fight data sets, combatants are numbered x(y), y being
			friendly combatants in that set. toc changed to 1500
	2.63, 6/6/05  - changed: German heal localization reverted to 2.6. No other changes.
	2.61- 6/1/05  - bugs fixed: fixed total time reloading bug, added a few
			pixels back to max hit column, right-click menu works
			now with different scaling, French heal/death/icon
			localization by Fabinou.  German heal filter reordered by
			Maischter.
	2.6 - 5/22/05 - optimized: data restructured to take up less space with
			greater flexibility for changes.
			added: merge pets option (needs 1.5 client), faction, class,
			% heal/dmgin/dmgout columns, maximum rows option, auto-
			post of ranks each fight option, option to make backdrop
			transparent while minimized, titan plugin, 
			changed: right-click to toggle friends now a drop down to
			toggle friend, reset or ignore
			bugs fixed: effects with (x absorbed) won't be separate,
			infobar plugin will update in realtime always, effects that
			both damage and heal will be separate in details
	2.5 - 5/6/05  - bug fixed: report by rows will work for all clients/factions,
			added: details view to show crits and damage/healing/effect,
			colored titlebars for current view, changed: infobar updates
			in realtime
	2.43- 5/4/05  - bug fixed: Self for first time users, added: French healing
			and death localization by Fabinou
	2.42- 5/4/05  - added: option to shift+click header into rows or one line,
			preliminary effects tracking for self/pet for localization
	2.41- 5/4/05  - bug fixed: 11th+ entry will shift+click ok now
	2.4 - 5/3/05  - added: deaths and heals columns, option to hide yard trash,
			changed: if window hidden will remain hidden on login, reset
			button, shift+click of header will be much more readable,
			minimized dps values update in realtime, German localization
			update by Mojo, made data set edit box more noticable
	2.31- 4/29/05 - bug fixed: german localization string by IceH
	2.3 - 4/28/05 - bug fixed: verbose link. added: German localization by Mojo.
	2.2 - 4/27/05 - bugs fixed: missing You suffer filter, trailing damage in
			absorbed hits. added: French localization by Oxman
	2.0 - 4/24/05 - optimizations: data and fight flow restructured into separate
			tables so minimum calculations/allocations needed, changed
			sort method for drastic speed improvements, calculations
			performed only when needed. changed: window growth is no longer
			automatic but in options, pin button only serves to lock window
			now. removed: compact mode (obsolete), dps is always adjusted
			per combatant, reset totals for each fight removed.  added:
			fight data sets, idle timer to end fights, custom list views,
			more shift+click views, max hits, 
	1.42- 4/15/05 - changed: initialization delayed until UnitName("player") is
			valid.
	1.4 - 4/14/05 - added: option to fade window, option to show only friends,
			option to show only fights with duration, localization.lua,
			/recap reset, changed: if reset totals unchecked fights begin
			at first hit by anyone, enabled pause during Active mode,
			merged pets and owners in personal DPS (white DPS), friends
			checked more frequently, window will grow upwards if in bottom
			half of screen, if pinned recap will show at startup, switched
			logging method from chatframe event hook to registering for every
			damage event.
	1.3 - 4/12/05 - bugs fixed: client crash with gypsy general, infobar not updating
			on adjust dps change, added: myAddOn entry, fade on post-fight
			update, changed: made "pin" rules consistent across all views
	1.2 - 4/11/05 - added plugin for Telo's Infobar to show DPS
	1.1 - 4/10/05 - added option to let totals accumulate, added time column,
			overhauled list functionality, added shift+click to
			"link" DPS, added compact minimized view, added the
			ability to grab names from raid
	1.0 - 3/28/05 - initial release
