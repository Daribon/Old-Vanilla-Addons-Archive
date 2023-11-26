Custom Hide Bar is World of Warcraft user interface AddOn which splits the
main bar into 4 separate toolbars (actionbar, bagbar, microbar and petbar
or shapeshiftbar) while hiding rest of the original mainbar. The 4 new
toolbars are fully dragable so you can position them whenever you want and
then lock them in place. You can also hide the bars you don't want to see
on the screen.

I made this addon mainly for users who replace the original mainbar with
alternatives like flexbar but still need some of the mainbar
functionality present (petbar for example).

The code is heavily inspired by excelent BibToolbar Addon so all credits
goes to it's author.

Feedback is welcome, you can contact me on miceke@valachnet.cz

Emil Micek (author)


Usage:
When you first load this addon, all 4 toolbars should be present in the
bottom right corner of the screen. You can drag them by the green circle
button. You can lock and unlock the bars and show and hide them using
following slash commands:

/chb lock|unlock - locks or unlocks toolbars
/chb <toolbar> hide|show - hides or shows specified toolbar. Toolbar must be
one of actionbar, bagbar, microbar, petbar or shapeshiftbar
/chb help - ingame help

Example usage:
/chb microbar hide - hides microbar
/chb lock - locks all toolbars in place

Changelog:
v0.3: Changing warriors stances, druids forms or entering stealth mode with
      rogue should now update the ActionBar appropriately.
      Added TODO list (see TODO file)

v0.2a: fixed bug which caused shapeshiftbar not to lock/unlock properly

v0.2: Added shapeshiftbar support

v0.1: Initial release


