Addon:    MyBags
Author:   Ramble
Version:  0.3.0 (TOC: 1600)
Released: 8/21/05

Contact Me:
	Curse-Gaming: PM Ramble or post a comment at
	  MyBags: http://www.curse-gaming.com/mod.php?addid=1838
	
--DESCRIPTION-------------------------------------------------------------
MyBags is a replacement to the default interface's Inventory and Bank
features.  It replaces smaller individual frames and places them into a
larger frame showing all your inventory or bank slots.

It is really three addons in one, MyInventory, MyBank, and MyBagsCache. 
Each addon can be disabled entirely if you don't wish to have the features
of it.  

In the MyBags Folder there are 3 folders:
MyBagsCore: This is for things common to both MyInventory and MyBank
MyBank: This is for things specific to MyBank.  Remove this folder to 
   disable MyBank
MyInventory: This is for things specific to MyInventory.  Remove this 
   folder to disable MyInventory
MyBagsCache: This saves your inventory and bank items for offline viewing.
	**note**: DISABLE MyBagsCache IF:
	  1. You use KC_Items
	  2. You don't wish to have offline (or away from bank) viewing (it 
		  will bloat your saved vars)

--FEATURES----------------------------------------------------------------
Features:
* Toggle to completely replace default UI.  MyBags can be used with or 
   instead of the default UI
* Bag Slots are shown in the bag window and can be toggled
* Item Borders reflect their rarity
* Frame can be resized by changing the columns
* Frame background is configurable:default background, graphical 
   background, or no background

MyInventory Specific Features:
* You can disable specific bags in MyInventory by shift+right clicking 
   the bag slot.  This will remove it from the MyInventory frame and 
	allow the default UI to handle just the bags you disable.

MyBank Specific Features:
* When at bank, click an unbought bag to buy a slot.  It asks you to
	confirm before you actually purchase it.

Additional Features:
* Bank and inventory Viewing is possible with one of the following addons:
	- KC_Items (KC_Bank for bank, KC_Inventory for Inventory)
	- MyBagsCache (Included in this package)
	
--TODO--------------------------------------------------------------------
**NOTE** MyBags is in beta release. Many features from MyInventory and 
			MyBank exist, but there are several things I'm still working on.
Known Bugs/Issues:
* All realms check doesn't function.  Possibly request a more versatile
   KC_Items:GetCharList()
* KC_Items will eventually save a Soulbound flag and a MadeBy flag like
   MyBank.  Cooldown information will probably never be reimplemented by
	me, it was flaky before.
* CooldownCount does not support MyBags yet

Todo:
* Save money, display total money in either bank or inventory frame, I'm
   not sure exactly where I'm gonna stick it.
* Patch 1.7 will allow me to hook into the mouseover of default bag 
   buttons with relative ease.  Then I'll implement mouseonver for these
	buttons.

Wishlist/Comminity requests:
* GUI config window (this is close to being moved to my todo list)
* Rather than 1 big MyInventory frame, 5 seperate minimal MyInventory
   style frames (req by stevef)
* Sorting of items

--DEPENDANCY NOTES--------------------------------------------------------
Ace: Required for a simpler, more efficent MyBags.
KC_Items:  KC_Inventory and KC_Bank allow for offline viewing of character
  Bank and Inventory.  KC_Bank allows you to also view your bank when not
  at Bank.
--SLASH COMMANDS----------------------------------------------------------
/(myinventory|mi) [OPTION [ARGUMENTS]]: change MyInventory options
/(mybank|mb)      [OPTION [ARGUMENTS]]: change MyBank options

Options:

aioi    - Enables AIOI style item ordering.
anchor  - Sets the anchor point for the frame
	bottomleft	- Frame grows from bottom left, tooltips open right
	bottomright	- Frame grows from bottom right, tooltips open left
	topleft		- Frame grows from top left, tooltips open right
	topright		- Frame grows from top right, tooltips open left
back    - toggle window background options
    default  - translucent minimilistic frame
	 art      - blizzard style artwork
	 none     - background disabled 
bag     - toggle between bag button view options
    bar      - Bags are displayed on a bar at the top of the frame
	 before   - Bags start their own row and the first slot shows the bag
	 none     - Bags are not shown in the frame
buttons - Show/Hide the close and lock buttons
cash    - Show/Hide the money display
cols    - set the number of columns
count   - toggle between the item count options
    free     - Show Free Slots
	 used     - Show Used slots
	 none     - Disable slots display
freeze  - keep window from closing when you leave vendors or bank
highlight - highlight options
	items - highlight items when you mouse over bag slots
	bag   - highlight bag when you mouse over an item
lock    - keep the window from moving
title   - Show/Hide the title
player  - Show/Hide the offline player selection box
quality - Highlight items based on quality
replace - toggle replacing of default bags
reset   - Resets elements of the addon
	settings - resets settings tod efault
	anchor   - moves frame back to it's origional position
scale   - Set the farmel scale (between 0.2 and 2.0, blank resets to default)
tog     - toggle the frame


