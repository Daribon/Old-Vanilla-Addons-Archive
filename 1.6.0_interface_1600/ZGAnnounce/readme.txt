Table of Contents:

1. Changes
2. Todo
3. Kudos

1. Changes
----------

I have extracted the locale-dependent strings to their own file (localization_en.lua).
In doing so, I have made a table that will make it easier to change/add stuff.
I have also added a constants.lua file, which contains constants, such as the default values of the Options variable.
The options variable allows you to store settings is a nice way. It also allows for new values to be added seamlessly.

--

Added autorolling

--

Added pass item list

--

Added auto roll greed on BoE (experimental)

2. Todo
-------

Make it more general. :)
This could be useful for BRS, Stratholme, Scholomance and Dire Maul drops, to say nothing of BWL/MC.

I would recommend creating a table where each item (or name if necessary, but it should be possible to get the item id somehow... rollId may be the id, but...) is bound to a list of classes. Each class is represented by a string - the second parameter returned by UnitClass (i.e. ROGUE, WARRIOR et cetera).

This would allow you to either show "Rolled on by class X, Y and Z" or "Rolled on by A, B, C and D." - names instead of classes.

Add the ability to use 
	/zgannounce item "item name" message
and
	/zgannounce itemlink {ItemLink] message

to easily add new stuff to the database... I recommend a subtable in Options for this. :)

3. Kudos
--------

It is a really neat addon - thanks for coding it!

I hope my suggested changes and stuff are not too onerous nor that they feel too much like "papa Sarf knows best."

