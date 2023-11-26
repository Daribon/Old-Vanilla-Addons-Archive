TrinketMenu 2.23

This is a mod to make swapping trinkets easier.  It will display your two equipped trinkets in a bar.  Mouseover on either trinket will display a menu of up to 30 trinkets in your bags to swap.

__ New in 2.2 __

- Swapping trinkets while dead will 'queue' trinkets to swap on revive
- Option to notify only if trinket was actually used
- Option to send notify to chat also
- Option to turn off the toggle effect of the minimap icon
- Hopeful fix for the window/unwindowed movement some see

__ Swapping trinkets __

Left click a trinket in the menu to equip it to the top trinket slot.
Right click a trinket in the menu to equip it to the bottom trinket slot.

__ Customizing display __

The main and menu windows are independently scalable and rotatable.  While the windows are unlocked:
- Move either window by dragging its edge.
- Rotate either window by right-clicking its edge.
- Scale/resize either window by dragging the lower-right corner to the desired size.

If you're having problems grabbing the edge of the menu window to move/rotate/resize it, hold Shift down while it's open and the menu won't go away when the mouse leaves the menu's edge.

If you right-click the gear icon around the minimap (or /trinket options) a small options window will appear under the minimap.  Here you can customize the display further by showing cooldowns as numbers and keeping the menu always open.

Once you're settled on a setup you like, you can lock the windows in options.

__ Docking __

While 'Keep Menu Docked' is checked (default), the menu will always be docked to one corner of the main window.  To change the corner where it's docked, drag the menu window so that a corner of the main and menu windows meet.  White brackets will appear at the corners that will dock as you drag.

If you uncheck 'Keep Menu Docked', remember the menu goes away when the mouse leaves your trinkets.  Feel free to experiment if you'd like.  Remember that /trinket reset will restore positions/docking, or you can hold Shift down to keep the menu open.  Or you can turn on 'Keep Menu Open' in options.

__ Queued Trinkets __

We can't swap trinkets during combat or when we're dead.  If you attempt to swap trinkets during combat or while dead it will put the trinket on hold and automatically swap them once you leave combat:

- The queued trinket will appear as a small icon inset into the slot it's heading to.
- If you want to unqueue the trinket, reselect it again for that slot (left or right click).
- If you want to queue the trinket to the other slot, reselect it again for the other slot (left or right click).
- The "queue" is only one-trinket deep right now.  Meaning, once a queued trinket is equipped that queue is emptied.
- Selecting a series of trinkets for a slot will only change the queued trinket, it won't set up an order to them yet.

__ Misc __

- Left-click the minimap icon to toggle the trinket windows.  Right-click to toggle options.
- You can drag the minimap icon around the minimap directly.
- You can Shift+click the trinkets to link them to chats just as you would from your bags or inventory.
- If you log in to a character with no trinkets in bags or on their person, the trinket window will not be displayed.
- You can hold Shift while swapping trinkets or manipulating the windows to prevent the menu from disappearing.
- You can set up key bindings to use whatever trinket is in the top or bottom slot.
- If you have Scrolling Combat Text installed, and 'Notify When Ready' checked, it will send a message via SCT when a trinket is ready.

__ Optional Slash Commands __

/trinket or /trinketmenu : toggle the window
/trinket reset : reset window
/trinket opt : summons options window
/trinket lock or unlock : toggles window lock
/trinket help : lists the above commands

__ Users of CooldownCount __

I wasn't aware that CooldownCount even supported TrinketMenu until recently.  Thanks Sarf that was a pleasant surprise.  While this version of TrinketMenu has numerical counters built in, users of CooldownCount would probably want it to look and act the same as the rest of their cooldowns.  So I've thrown together a new TrinketMenu CooldownCount as a separate download.  Those who don't use CooldownCount but want to try it, you'll need the core CooldownCount mod by Sarf here: http://www.wowwiki.com/CooldownCount

The numbers are bigger and more customizable so it's a great option if you don't like the basic cooldown numbers in this mod.

You will need to use the new CooldownCountTrinketMenu with TrinketMenu 2.0+.  Unfortunately the old one will not work.  However it won't create any conflicts or errors if you do have the old one running.

__ FAQ __

Q: How do I move the minimap icon?
A: Drag it like a normal window.  Left click and drag it around and it will slide around the edge.

Q: I'm trying to swap trinkets, but instead of swapping it put a tiny trinket icon over my equipped one.
A: This means you're in combat mode.  You won't be able to swap trinkets until you leave combat.  The tiny trinket is the one that will swap in once you leave combat.

Q: What if I don't have Scrolling Combat Text, will it still notify me when trinket cooldowns expire?
A: If you don't have SCT, it will notify in the "errors" overhead, where you get "Insufficient mana", "Out of range", etc type errors.

Q: I don't have many trinkets and because of this I'm having problems docking to some corners.  Any way to make it easier?
A: Temporarily resize (drag lower-right corner) either window to make the differences greater so it's easier to dock to an exact corner.

Q: My menu is docked to the left of my main window, when I resize it by dragging the lower right corner, it's not behaving as I expect.
A: You likely expect the topleft corner of the menu to remain and the bottomright corner to follow the pointer as you drag.  If it worked this way, the window would then "snap" to dock position after you're done resizing, and it'd be difficult to know exactly how it'd look while resizing.  A better solution would've been to make all corners resizable, but it was kept in this awkward state for simplicity's sake.  If there's demand for it, I can make all corners resizable.

Q: Any plans for a trinket queue system?  So that you can set up an order of trinkets to equip and it will automatically swap new ones in when you leave combat with equipped trinkets on a cooldown?
A: Yep I'd like to.

Q: Is it safe to put the menu on the edge of the screen?
A: Yes it's safe now.  WoW freezes for some when cooldown spinners are started off the right edge of the screen, and causes black verticle lines going above the top.  This version will not attempt to draw any cooldown spinners that are not completely in the visible screen.

Q: I was looking at the XML and there are 7 OnUpdates!  Isn't that going to kill performance?
A: Actually, they're done that way to improve performance and lower overhead.  Two examples:

1. Over 200 BAG_UPDATE events can happen when you log in or zone into an instance.  Instead of reacting to all of them or checking every so often, when the first BAG_UPDATE occurs, the inventory OnUpdate starts and waits until the game is done sending BAG_UPDATES.  Once a period has gone by without new BAG_UPDATEs, it processes the changes needed and then quietly shuts down the inventory OnUpdate.

2. For visual feedback while docking (the corners that will dock light up), it needs to continually monitor the window positions relative to each other.  Since docking is only done a handful of times for the lifetime of this mod's use, the OnUpdate that monitors those positions will only be active when you're docking.

The only OnUpdate that runs continuously is the cooldown counters if "Cooldown Numbers" or "Notify When Ready" is on, and the menu frame if "Keep Menu Open" is checked.  If neither are checked, no OnUpdates happen unless you start manipulating the mod.

You'll find that this mod's processing time and memory churn is far less than your usual "action bar" type addon.

Q: It's not showing all my trinkets, I have over 30 of them in my bags.
A: This version can handle only up to 32 trinkets.  Two equipped and 30 in bags.  If you exceed this amount, post how many trinkets you have and I'll up the limit.  30 seemed a reasonable number, but as the screenshots show it's not very difficult to get 30 trinkets if you're an engineer.  In the meantime the mod will lift trinkets from right bag to left if you want to control which 30 are displayed.

Q: I can't rotate, resize, move or do anything with the windows.
A: That sounds like the windows are locked.  Enter: /trinket unlock

__ Changes __
2.23 9/3/05 - bug fixed: hunter fd won't queue a trinket that can ordinarily swap, if the mod is hidden on logout it will be hidden on login
2.22 9/2/05 - bug fixed: if res'ed before releasing your spirit with trinkets in queue, they'll swap on revive normally
2.21 8/21/05 - bug fixed: window scaling bug definitively fixed, and error when clicking an empty trinket slot
2.2 8/20/05 - added: swap attempts while dead will queue trinkets to swap on revive, options to disable toggle, notify used only, and notify chats also, bugs fixed: error for more than 30 trinkets, notify corrected, hopeful fix for location bug some have: forced start/stopmove to save to layout-cache.txt, move the window to saved point going in/out of windowed mode
2.11 8/17/05 - changed: swap attempts won't happen if anything on cursor, bug fixed: options window will appear on screen irregardless where minimap is, added: /trinket debug to help find location bug issue some see
2.1 8/17/05 - added: a resize grip to lower right corner, trinket queue, option to dock/undock, notification when trinket cooldown ends (via SCT or overhead), bugs fixed: cooldown update made less frequent, 
2.0 8/14/05 - rewritten from scratch, added up to 30+2 trinkets, menu grows outward, cooldown numbers, keep menu open option, minimap icon and scaling, far better handling of bag/inventory updates, cooldown models won't update if they're off the screen
1.1 7/20/05 - only react to BAG_UPDATE every second (by Thelgar), made lock/unlock more visually apparent and moved menu closer to main window
1.0 4/8/05 - initial release
