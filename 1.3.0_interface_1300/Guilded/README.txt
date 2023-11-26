Description : 
Guilded allows multiple independant players to create a channel for chatting, crafting, trading and instance/raid organisation. It is effectively a second Guild chat channel, without any of the Guild restrictions. Anyone with the channel name and (if required) the password can join. Further, it allows channel members to advertise their professions, advertise items for Buying, look at other members items for Selling and setup raid type events that others can register an interest in.

Don't know anyone to use Guilded with? Join the channel 'guildedglobal' with no password and see who else is there.

Commands: #### IMPORTANT 1 ####
/ga <message> is the default chat system slash command. It acts the same as the Guild channel, so it will be sticky and allow item links, etc. This can be configured in the config screen.
/guilded for some minor commands, nothing really needed.

Bindings: #### IMPORTANT 2 ####
You will need to bind the Guilded GUI to a key. I would suggest Shift-o since it is similar to the default Social GUI which is usually bound to the o key.

Setup/Installation: #### IMPORTANT 3 ####
1. Install the AddOn as per usual and log in to World of Warcraft.
2. Check that Guilded has loaded correctly by looking in your default chat window messages for 'Guilded loaded. v0.8'
3. Enter the Main Menu -> Key Bindings menu and bind the Guilded GUI to the Shift-o key or any other key you choose.
4. Close the Key Bindings and Main menu and bring up the Guilded GUI with your bound key (Shift-o or whatever you set it to)
5. Change the Channel Alias as you like, it is only for your personal chat window. eg Type /ga then a space will replace it with [Guilded] or whatever your alias is.
6. Enter a channel to connect to. Use 'guildedglobal' if you don't know another channel to try.
7. Enter a password if it is required. Leave this blank if you are joining 'guildedglobal'.
8. Press the Accept button. You should see a message in the default chat window that says 'Guilded: Joined channel guildedglobal' or whatever channel name you choose.
9. If you get a popup message about Guilded giving up, try hitting the accept button again. This will be improved next release.

Traders Usage: #### IMPORTANT 4 ####
The crafters window displays all users advertising their crafts within the channel. Click a crafter and whisper then for your needs.

The Stock window is where you add items that can then be flaged as WTS and WTB. To add items to the Stock window, hold down the Control Key (Ctrl) while left clicking on any item in the normal backpacks, Merchant Screens, Inventory, Inspect Inventory (other players), Bank Items. (AllInOneInventory and some similar AddOns are not currently compatible with this, just open your normal packs up.)
Next version will allow Control-Left Mouse Button clicking for pretty much any item you can see. (Auction, Quests Item/Rewards, Spell Book for advertising Teleports/Buffs etc will come in the next version)

Within the Stock window, 
 - Click the yellow item highlighs to change the price on an item.
 - Click the item button (with the item picture) to selected the item (and permanently highlight it) for removal.
 - Tick the WTS and WTB tickboxs to advertise the item as something you 'Want To Sell' (WTS) or 'Want To Buy' (WTB) this item will then appear in every channel members WTS or WTB screen.

Within the WTS and WTB windows,
 - Click the item button (with the item picture) to selected the item, then hit the whisper button to discuss exchanging the item and cash. (COD is your friend)

Some suggested uses:
1. Multiple Guild alliance channel. Chat, Trade, Raid with other Guilds without having to merge your Guilds together. Especially useful for a number of smaller Guilds to pool resources.

2. Create an underground Guild. No one will know you are in the underground Guild as there is no way to detect what channels you choose to join. Infiltrate other Guilds, become an assasin Guild, or perhaps a horde/alliance illuminati. However, be prepared to reap what you sow.

3. Create a black market. Organise your shifty deals, advertise bounties, request hard to find items, trade in all that is dark and scorned; but beware, your fellow shifty blackmarket members may not be so quick to pay up.

Current state of the AddOn:
- Main AddOn GUI is working fine.
- Channel configuration and Chatting works fine.
- Channel member profession advertising works fine.
- Buying/Selling items is still under minor construction but functionally works fine.
- Raiders (Raid/Instance organisation) is still under construction so is disabled.

Known issues/ToDo:
- At log off, Guilded leaves the Guilded channel, if you cancel the log off during the 20 seconds timer, Guilded will not rejoin the channel.
- Improve auto channel unjoining
- The graphics of the column headers for the member and professions lists look a bit dodgy.
- Make the chat message redirect to the user defined chat window
- Finish the Traders GUI (add sorting to Sell/Buy/Stock items, fix graphics, etc)
- Start the Raiders GUI.
- Fix channel number order checking as channel 2 may not exist
- Clean up the Buy/Sell GUI code/templates
- Clean up the command parsing code and compress the control data transmission
- Can't put items into Stock window from AllInOneInventory

Code Credits:
- To the Fetch library for a great idea that has been used by Guilded and also extended to detect when the global channels are joined.
- To the the PartyComm library for my initial ChanComm inspiration. 

Changes : 
v0.9 - Minor bug fixes and finished the initial version of the Buy/Sell feature.
- Improved channel joining
- Added notification of players joining/leaving channel.
- Now not allowing user to join Guilded to default system channels (General, Trade, etc)
- Fixed crafting updates for people just joining
- Added slash command configuration
- Added Guilded version difference warning
- Added Buy/Sell/Stock GUI's
- Added Ctrl-Left Mouse Button to add items to stock for Backpacks, Inventory, Inspect Inventory, Merchants and Bank items.
 
v0.8 - Initial public release. (Public Beta)

v0.1 to v0.7 - Development, Alpha and initial Beta testing. 