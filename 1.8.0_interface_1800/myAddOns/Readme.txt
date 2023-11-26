myAddOns v2.4


Description
===========

myAddOns is a World of Warcraft AddOn. It's an AddOn Manager accessible from
the Main Menu. It lists your AddOns per category. You can view details and help
for the supporting AddOns and open their options window if they have one. You
can also load the load on demand AddOns and setup myAddOns to load these AddOns
automatically.


Install
=======

Extract the files into your World of Warcraft Directory.


Features
========

* AddOns list per category
* Automatic AddOns loading (automatic, per class, per character)
* Personal notes for each AddOn
* Localization (english, french, german)

For supporting AddOns:
* AddOns details
* AddOns help
* Link to the options window

* Compatibility with World of Warcraft v1.8
* Low memory usage (<0.2MB)


Usage
=====

- Players -

To access the AddOn manager, click on the "AddOns" button in the Main Menu.
The AddOns list is automatic. The AddOns that don't support myAddOns are listed
in the "Unknown" category. The loaded AddOns are yellow while the load on demand
AddOns not yet loaded are grey.

You can see details and help for the AddOns in the "Details" and "Help" tabs. You
can setup the automatic load for a load on demand AddOn in the "Load" tab.

- Developpers -

Here is a small tutorial to add myAddOns support to your AddOns. I'll take the
HelloWorld AddOn as example.

Step 1
First, add an optional dependency to myAddOns. To do so, add the following line
to your .toc file:

	## OptionalDeps: myAddOns

Step 2
Create a table for your AddOn's details. To do so, add the following lines to
your lua script:

	HelloWorldDetails = {
		name = "HelloWorld",
		version = "1.0",
		releaseDate = "September 26, 2005",
		author = "Anyone",
		email = "anyone@anywhere.com",
		website = "http://www.anywhere.com",
		category = MYADDONS_CATEGORY_OTHERS,
		optionsframe = "HelloWorldOptionsFrame"
	};

The only required field is the name. It has to match the name of the directory/.toc
file of your AddOn or its title in the .toc file. If it doesn't an error will be
printed in the chat and the registration will fail. The title in your .toc file is
used to display your AddOn in the list.

You should use one of these global variables to populate the category field.
They are localized in english, french and german:

	- MYADDONS_CATEGORY_AUDIO
	- MYADDONS_CATEGORY_BARS
	- MYADDONS_CATEGORY_BATTLEGROUNDS
	- MYADDONS_CATEGORY_CHAT
	- MYADDONS_CATEGORY_CLASS
	- MYADDONS_CATEGORY_COMBAT
	- MYADDONS_CATEGORY_COMPILATIONS
	- MYADDONS_CATEGORY_DEVELOPMENT
	- MYADDONS_CATEGORY_GUILD
	- MYADDONS_CATEGORY_INVENTORY
	- MYADDONS_CATEGORY_MAP
	- MYADDONS_CATEGORY_OTHERS
	- MYADDONS_CATEGORY_PLUGINS
	- MYADDONS_CATEGORY_PROFESSIONS
	- MYADDONS_CATEGORY_QUESTS
	- MYADDONS_CATEGORY_RAID

If you don't use one of these, your AddOn will be listed in the "Unknown" category.

The optionsframe field is used to detect if your AddOn has an options frame and
make a link to it. myAddOns will use its Show() function.

Step 3
If you want to add an help for your AddOn, create an additional table. Each
element of the table is a page in the help frame:

	HelloWorldHelp = {};
	HelloWorldHelp[1] = "Help Page1 line1\nline2\nline3...";
	HelloWorldHelp[2] = "Help Page2 line1\nline2\nline3...";

Step 4
Then catch the "ADDON_LOADED" event and register your AddOn in myAddOns. To do
so, add the following lines to your OnEvent event function, for the
"ADDON_LOADED" event:

	-- Register the addon in myAddOns
	if(myAddOnsFrame_Register) then
		myAddOnsFrame_Register(HelloWorldDetails, HelloWorldHelp);
	end

The second parameter is not required. So if you don't have any help for your AddOn
don't use the second parameter.

Now you are all set! You can download my HelloWorld example to test all this.


FAQ
===

Q: My AddOn XYZ is not listed! Why??

A: Check if you enabled it at the character selection screen. Check if it has a
required dependency that is missing.

Q: I get the following error in my chat: "Error during the registration of <addon>
in myAddOns.". What does it mean?

A: This error message means that the AddOn named "<addon>" is trying to register
with an unknown name/title. Check with the author if he can update his AddOn to
make it compatible with the new registration method. Anyway this has no impact on
the gameplay or on myAddOns so everything should be working okay.


Known Issues
============

* None


Versions
========

2.4 - October 15, 2005

* Updated load on demand AddOns detection

2.3 - October 1, 2005

* Fixed compatibility with old registration method
* Added "Audio" category

2.2 - September 27, 2005

* Fixed error popups during registration
* Fixed bug with options windows blocking all other windows when closed

2.1 - September 26, 2005

* Fixed localization
* Fixed wordwrap
* Added automatic AddOns list
* Added "Load" button
* Added automatic AddOns loading
* Added click on address to copy it
* Added "Development" and "Unknown" categories
* Removed "Remove" button

2.0 - July 16, 2005

* Added new interface
* Added registration function
* Added AddOns details and help
* Added "Battlegrounds" and "Plugins" categories

1.2 - March 25, 2005

* Fixed highlight display
* Added "Guild" category

1.1 - March 8, 2005

* Fixed Main Menu width
* Fixed display of options windows in area other than "center"
* Added categories
* Removed slash commands

1.0 - February 4, 2005

* First version released


Contact
=======

Author : Scheid (scheid@free.fr)
Website : http://scheid.free.fr

