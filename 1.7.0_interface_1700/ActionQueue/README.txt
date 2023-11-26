NOTE: This document is a work in progress, and will change. 
If you have any suggestions for it, send them to sarf on cursegaming.

1. What is ActionQueue?
2. How does it do what it does?
3. How can I find out more?

1. What is ActionQueue?

ActionQueue is an AddOn that allows you to queue up actions that may be 
executed when the user uses a binding that does not perform an action
itself. This allows for semi-automatic spellcasting et cetera.


2. How does it do what it does?

ActionQueue hooks bindings that deal with player movement and camara 
change (ActionQueue_Hook.lua has a list of the functions that the 
bindings call). When these bindings are called, it first performs the 
hooked action, and then examines its queue and executes any action that 
is pending.


3. How can I find out more?

Check out the API.txt. 
Read through the (poorly documented) code.
Ask questions to sarf at cursegaming.