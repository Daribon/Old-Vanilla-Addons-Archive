PartyPets
An AddOn that adds fully functional party member frames for pets currently in your party.

History:
v0.94 (1/27/05)
added multiple layout options
added alpha option
now saves the shown/hidden state
buffs now displayed on the right side of the pet frame instead of requiring rollover

v0.93 (1/22/05)
added health number display to rollover
PartyPets button is now much easier to drag
PartyPets button no longer displays on top of other windows

v0.92 (1/21/05)
initial beta release

Description
PartyPets attempts to recreate the standard party member frames for the pets of your party members. Nearly all of the normal party member frame functionality works for PartyPets, including:

* Pet name, health, buffs and debuffs, just like a regular party member
* Selection of pet by clicking the frame
* Casting of spells on the pet via the frame
* Standard tooltip on rollover (containing name, level, and pet owner)
* Portrait display

In addition, the PartyPets frame can be positioned anywhere you like, simply drag the PartyPets to do so.  The default position is just below the mini-map.
PartyPets has been tested to the best of my ability but some bugs likely still exist.  Please post any issues you run into to this thread and I will try to address them as quickly as possible.

Important: PartyPets is a client/server AddOn.  Because of this you will only see the pets of other players that are using PartyPets, and only they will see your pet.  PartyPets communicates invisibly between party members using the PartyComm addon (see below).  You may notice a channel in your chatlist with the name "PartyComm<Your Group Leader>".  You will not see any messages from this channel, but you must not leave it in order for PartyPets to function.  The number of the channel is currently the first available, but I am working on a way to move it further down the channel list.  PartyPets inclues PartyComm.

Slash Commands
All PartyPet commands can be accessed by typing /partypets or /pp.
/partypets on - enable PartyPets. (on by default)
/partypets off - disable PartyPets.
/partypets clienton - set yourself as a PartyPet client. (on by default)
/partypets clientoff - disable the PartyPet client functions. (no pets will be displayed or updated on your screen)
/partypets serveron - set yourself as a PartyPet server.  Defaults to on for Hunters and Warlocks.
/partypets serveroff - disable the PartyPet server functionality.
/partypets refresh - request an update of all pet information from your party members.
/partypets reset - remove all current pets and request an update of all pet information from your party members.
/partypets show - show the PartyPet button and party pet frames.
/partypets hide - hide the PartyPet button and party pet frames.
/partypets layout vu|vd|hr|hl|owner - sets PartyPets layout (vertical/horizontal, up/down/left/right, or owner)
/partypets offsetx # - allows you to add an additional offset to PartyPet frames when using owner mode.
/partypets alpha % - sets PartyPets pet frame alpha. This will change to 100% if the pet drops below 20% health. 

Installation
Unzip into your World of Warcraft install directory.
