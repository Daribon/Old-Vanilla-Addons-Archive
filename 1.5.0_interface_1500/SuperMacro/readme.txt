SuperMacro v2.3 by Aquendyn

This addon provides a very much improved interface for macros. Its special functions includes the following, and probably more:
Unlimited macros.**
Increases maximum macro character length to 1023 characters (system limit).*
New macro frame lets you scroll through all your macros.**
Run macros through keybinds*** and call other macros with RunMacro()****.

* The letter limit for the entire macro is 1023. However, there is a limit of 255 letters for /script lines if you put the macro on the action bar and use that directly. You can get around that if you use keybinds or call it through another macro.
Suppose macro 1 has a /script line longer than 255. If you put this directly on your action bar and try to activate it, you will get an error because the rest of the line beyond the 255th character will be cut off when you log off. What you can do is make break up the long macro into smaller parts, and have them call each other, like so (where macro 1 is named Macro1):
<code>
/script RunMacro("Macro1"); --more scripting here
</code>
Then put this new macro on your action bar.

** The new macro interface includes a scroll frame which lets you conveniently scroll through all your macros. You can make more than the 18 that Blizzard allows. Even though the new macro frame shows only 30 macros at a time, you can make as many as you want. The scroll frame will adjust accordingly.

*** The default bindings for this addon provides entries for Macros #1 through #36. In addition, there are two special bindings for Attack and PetAttack. To use these two macros, you must first create macros for them.

For Attack, follow these instructions.
Make a macro called Attack (note caps) with this body:
<code>
/script if ( not PlayerFrame.inCombat ) then CastSpellByName("Attack"); end;
</code>
Now, you can assign a keybind for attack, and you can call this macro when executing other macros. For instance, suppose you want a macro to attack and to cast a spell. You can make a macro with this body:
<code>
/script RunMacro("Attack");
/cast Shadow Bolt
</code>

For PetAttack, do the following.
Make a macro called PetAttack (note caps) with this body:
<code>
/script CastPetAction(1);
</code>
Put the pet attack icon in the first slot on your pet action bar (should be there by default).
Now, you can assign a keybind to tell your pet to attack, and you can call this macro when executing other macros. For example, we can change the above example to this:
<code>
/script RunMacro("Attack");
/script RunMacro("PetAttack");
/cast Shadow Bolt
<code>

**** SuperMacro lets your macros call other macros with the special function RunMacro(index) or RunMacro("name"). If index is a number without quotes, it will call the macro in the order as shown in the macro frame. If you instead provide a name of the macro within quotes, you can call the macro if you know its name.
In Bindings.xml for this addon, you will notice bindings for RunMacro(1) through RunMacro(36). They will run the respective macro in the order that you see in the macro frame. If you add or delete macros, their order may change, so be careful here. You are free to edit those bindings to call your own macros.
You can use a macro to call other macros simply by providing the name of the other macro. When writing a macro, you will have something like this:
<code>
/script RunMacro("Attack");
</code>
where Attack is the name of another macro.

***** Slash commands
Supermacro changes the /macro command so that you can run a macro from the chat line. Use /macro <macro_name>. This is equivalent to /script RunMacro("macro_name").
Ex. /macro Attack
Running a macro from the chat line will not cast spells.

Another slash cammond is /supermacro. Just /supermacro shows help for slash commands.
There is only one option for now, which is hideaction 1 or 0. For instance,
/supermacro hideaction 1
/supermacro hideaction 0
Setting it to 1 hides the macro names on action buttons, and 0 shows them. This option is saved between sessions under SM_VARS.hideAction.

Miscellaneous:
SuperMacro does NOT modify the files in FrameXML directory. If you have another macro addon that modifies those files directly, you might have to disable them.

Installing SuperMacro:
Unzip the files into WoW/Interface/Addons . A new directory called SuperMacro will be automatically created.

## 2.3 changes
can keep spellbook open to allow shift-clicking spellnames into macro
type /supermacro to show slash command help
/supermacro hideaction 1 or 0 to hide or show names on your action bar; works for this patch's multibars
updated slash command to run macro
/macro <macro_name> (will not cast spells if run from chat)
better support for casting tradeskills as spells
fixed header for betterkeybindings
## SavedVariables: SM_VARS
Changed interface to 1300
