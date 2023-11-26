QuickHeal offers healers one-button access to their direct healing spells for healing party/raid members and themselves. It lets you heal the people who need it, without having to target them manually, or even having to deselect the enemy you're fighting. It also gives maximum mana efficiency, and will automatically use a lower rank of healing if the target doesn't need your biggest heal, or if your mana is running low. This also works when not in a party or a raid, and this will save you mana and precious time by automatically selecting the healing target and healing spell that does the necessary healing.

[b]QuickStart:[/b]
Use the standard key bindings interface (in the menu) to bind a key to the command 'Heal'. Whenever you think anyone (or yourself) need healing, push the button, and QuickHeal will automatically decide who to heal and which healing spell and rank to use.

[b]Features:[/b]
[ul][li] Heals the player who needs healing most.
[li] Uses the spell and rank that gives the right amount of healing for the target.
[li] When in combat, it prefers the spells and ranks that maximises healing/time.
[li] When out of combat, it prefers the spells and ranks that maximises healing/mana.
[li] Automatically selects a lower rank if mana is low.
[li] Can be configured to heal everyone (default) or only the local group when in a raid.
[li] Considers talents to adjust spell and rank selection.
[li] Considers the health lost during casting of the healing spell and adjust the healing needed accordingly.
[li] On screen messages can individually be configured to be shown in either the chat window, the center of the screen, both places or nowhere.
[li] Healing notifications can be sent by whisper to the healing target, to party-chat, raid-chat or to a user-definable channel.
[li] Will display a warning above the casting bar, if the current healing spell will cause a significant overheal on the healing target. A yellow warning indicates that between 10% and 50% of the healing spell will be wasted, while a red warning indicates that more than 50% of the healing spell will be wasted. In case of a red warning message, reactivating QuickHeal will interrupt the spell casting.
[li] Detects if [link='http://www.thottbot.com/?sp=16188']Nature's Swiftness[/link] (Shaman and Druid only) or the proc of [link='http://www.thottbot.com/?i=21012']Hand of Edward the Odd[/link] is active and uses the spell and rank that maximises healing/mana (as if out of combat).
[li] Detects if [link='http://www.thottbot.com/?sp=13583']Curse of the Deadwood[/link], the warrior ability [link='http://www.thottbot.com/?sp=12294']Mortal Strike[/link] or the Orc racial ability [link='http://www.thottbot.com/?sp=23230']Blood Fury[/link] is active on the healing target and adjust the healing needed accordingly.
[li] If a target is out of range or not in line of sight, that player will be blacklisted for 5 or 2 seconds respectively.
[li] Target a player who is not in your party/raid, and he will be the target of the heal, if no one in the party/raid or yourself needs healing.
[li] Configuration panel with build-in help function to configure options that affect the decisions. Type '/qh cfg' to open.
[li] Optional support for [link='http://ui.worldofwar.net/ui.php?id=1461']BonusScanner[/link]. Will take the healing bonus from equipment into consideration when choosing spell rank.
[li] Additional keybindings and commands for healing yourself ('Heal Self'), your current target ('Heal Target'), your current target's target ('Heal Target's Target') and for healing only the local group in a raid ('Heal Party').[/ul]
[b]Supported Classes:[/b]
[ul][li] Shaman (Spells: Healing Wave and Lesser Healing Wave. Talents: Purification, Tidal Focus, Improved Healing Wave and Nature's Swiftness)
[li] Priest (Spells: Lesser Heal, Heal, Greater Heal and Flash Heal. Talents: Spiritual Healing, Spiritual Guidance, Divine Fury and Improved Healing)
[li] Paladin (Spells: Holy Light and Flash of Light. Talents: Healing Light)
[li] Druid (Spells Healing Touch and Regrowth. Talents: Moonglow, Gift of Nature, Tranquil Spirit and Nature's Swiftness)[/ul]
[b]Usage:[/b]
The key binding 'Heal' will heal any party/raid member or yourself, while the key binding 'Heal Party' will heal any party member or the local group when in a raid or yourself. The key binding 'Heal Self' will always heal yourself, and the key binding 'Heal Target' will always heal your current target (regardless of whether this target is in the party/raid or not). The key binding 'Heal Target's Target' will heal your current target's target (which is useful if the mob is changing targets often). I recommend binding 'Heal' or 'Heal Party' to SHIFT-W, 'Heal Target' to CTRL-W and 'Heal Target's Target' to ALT-W. This way, you can access the most important healing commands from a single key, where you have your hand most of the time anyway.

Alternatively, if you want an action bar button that can be triggered with the mouse, bind the command '/qh' (Heal), '/qh party' (Heal Party), '/qh self' (Heal Self), '/qh target' (Heal Target) or '/qh targettarget' (Heal Target's Target) to a macro button (type '/macro' in chat to open the macro interface).

To change any configuration options open up the configuration panel by typing '/qh cfg'.

[b]Advanced Usage:[/b]
[ul][li] Targeting someone who is not in the party/raid, will temporarily include them in the party/raid with lowest priority for as long as they remain targeted. That is, they will only be healed if no one in the party/raid needs healing. Because health can only be determined for party/raid members, the healing needed will be estimated and the appropriate spell and rank will be used. This is very useful for casually healing strangers that seems to be in over their head, without inviting them into the party, or using dedicated healing spells on the action bar.
[li] Targeting a party members pet, will temporarily raise it's priority for as long as it remain targeted, so that it is considered equal to party members, regardless of the setting in the configuration panel. This is useful if you don't normally heal pets, but need to heal a dying pet. Simply target it, and it will get the same priority as party members and hence be healed if it is the one with lowest health.
[li] Targeting yourself, will temporarily raise your priority, for as long as you remain targeted, so that you take precedence over everyone else. If you don't need healing, anyone else who needs healing will be healed as if you didn't target yourself. This behaviour is off by default and must be enabled in the configuration panel.[/ul]

[b]In depth details:[/b]
The system that decides which spell to use is based on analysis of the efficiency (healing/mana) and healing rate (healing/time). When in combat, it prefers the spells and ranks that maximises healing/time. When out-of-combat, it prefers the spells and ranks that maximises healing/mana.

The decision system first selects the player who needs the healing most. Then the appropriate spell and rank for that player is selected:
[ol][li] Find the party/raid member, party/raid pet or external target with the lowest health if anyone has less than the General Healing Threshold (Default: 90%). By default pets will only be healed, if no party members need healing (can be changed in the configuration panel), and external targets will only be healed if no party members or pets need healing.
[li] Select the most suitable spell and rank based on: If in combat, use the spell that maximises healing/time. The use of slow and big heals (cast time > 2.5sec) is restricted when in combat so that they are only used if the player has more health than the Healthy Threshold (Default: 60%). If out of combat, it uses the spell that maximises healing/mana.[/ol]In all cases, if the player has less health than the Self Preservation Threshold (Default: 40%) the player takes precedence and becomes the target of the heal.

For each of the classes this translates to the following use of the available spells:

[b]Shaman[/b]: Healing Wave and Lesser Healing Wave have the same mana efficiency, and hence Lesser Healing Wave is preferred for small heals, meaning that the lower ranks of Healing Wave will not be used at all when the player starts to acquire ranks of Lesser Healing Wave. Out of combat, either one is used depending on the healing needed. In combat, Lesser Healing Wave is used, unless Lesser Healing Wave is not available (sub level 20 characters) or the player has more life than the Healthy Threshold AND the Healing Wave gives a bigger heal than the biggest Lesser Healing Wave. Use the Healthy Threshold to adjust the use of the slower Healing Wave in combat. The recommended Healthy Threshold for Shamans is 60% which gives a good compromise between security and mana efficiency. If the Shaman is the main healer or a healbot (does not participate in combat), the Healthy Threshold should be set to 20-40% to enable QuickHeal to use the really big ranks of Healing Wave in more situations.

[b]Priest[/b]: Lesser Heal, Heal and Greater Heal are the standard healing spells of the priest. In addition the very fast Flash Heal gives a faster heal at the expense of mana. Because of this, Flash Heal will only be used when the player is considered unhealthy. In all other situations Lesser Heal, Heal or Greater Heal will be used, including out of combat. Because priests are very powerful healers that rarely involve themselves in combat and because the Flash Heal is quite expensive the recommended percentage for the Healthy Threshold is 30%. For solo play it can be set higher, around 50%, for better security. Renew is not used by QuickHeal, since it heals over time and depends heavily on the situation, always keep the highest rank of Renew on your toolbar to complement QuickHeal.

[b]Paladin[/b]: Holy Light is a moderately fast healing spell, which is relatively mana expensive. In addition, the Paladin also has the Flash of Light spell which is not only considerably faster, but is also massively more mana efficient (yes, this is completely opposite of the situation of the priest!). Unfortunately the highest rank of Flash of Light does not heal very much, so it won't deliver enough healing in combat situations. Besides, the higher ranks of Holy Light actually gives higher healing/time than even the highest ranks of Flash of Light. Even rank 6 of Holy Light is faster (healing/time) than the highest rank of Flash of Light! The use of Holy Light is controlled by the Healthy Threshold, and Holy Light will only be used in combat if the target is considered healthy. Because of this, it is recommended that the Healthy Threshold is set to 10%, to allow QuickHeal to use Holy Light in most combat situations. In addition as is the case for Shamans, when the player acquires ranks of Flash of Light the lower ranks of Holy Light are disqualified, and will never be used, because they have worse mana efficiency and healing rate than Flash of Light which is available in the same sizes (in terms of amount healed) at the lower ranks.

[b]Druid[/b]: Healing Touch is a very slow, but mana efficient spell and can only be used safely on targets that are healthy, or when out of combat. In addition the Druid has the Regrowth spell, which also includes a healing over time element. However, considering only the direct healing, the Regrowth spell acts in the same way as Flash Heal for priests; that is, a fast but mana inefficient alternative. Because of this, Regrowth will only be used when the player is considered unhealthy. In all other situations Healing Touch will be used, including out of combat. Because the Regrowth is quite mana inefficient the recommended percentage for the Healthy Threshold is 40%. Rejuvenation is not used by QuickHeal, since it heals over time and depends heavily on the situation, always keep the highest rank of Rejuvenation on your toolbar to complement QuickHeal.

[b]Tips:[/b]
The threshold parameters can be set to other values in the configuration panel which can be brought up by typing '/qh cfg' in chat. If the Healthy Threshold is set to 100% (or simply larger than the General Healing Threshold), the fastest heals will always be used in combat since the target is never considered healthy. Additionally, if the Self Preservation Threshold is set to 100%, the target for the healing will always be yourself ('permanent self preservation').

Supported Commands:
/qh - Heals the party member that most need it with the best suited healing spell.
/qh self - Forces the target of the healing to be yourself.
/qh target - Forces the target of the healing to be your current target.
/qh targettarget - Forces the target of the healing to be your current target's target.
/qh party - Restricts the healing to the party, even when in a raid.
/qh cfg - Opens up the configuration panel.
/qh reset - Reset configuration to default parameters.

[b]How to help[/b]
You can help improve QuickHeal by supplying icon names for buffs and debuffs that affect healing. Also talents that result in a buff/debuff are identified by an icon name. To retrieve the icon name create two macros with the following text (type '/macro' to open the macro creation interface):

Macro 1: '/qh listplayereffects'
Macro 2: '/qh listtargeteffects'

The first macro will list the buffs and debuffs of the player, and the second macro will list the buffs and debuffs of the current target. If you encounter any buff or debuff that affects healing, execute the macro, and write down the name of the buff/debuff, the icon name printed by the macro and the number appearing in parantheses.

Known talents/curses/poisons, that we need icon names for:
- Paladin talent Divine Favor 
- Shaman talent Healing Way
- Druid talent Omen of Clarity
- Curses/debuffs/buffs: Mortal Wound, Viel of Shadow, Mortal Cleave, Hex of Weakness, Gehenna's Curse, Brood Affliction, [link='http://www.thottbot.com/?sp=19703']Lucifron's Curse[/link], [link='http://www.thottbot.com/?sp=23620']Burning Adrenaline[/link], [link='http://www.thottbot.com/?sp=23513']Essence of the Red[/link].
- I you know any other talents/buffs/debuffs/curses/poison etc. please submit them in the comments section below.

TODO:
- Make it possible to heal only selected groups of a raid.
- Priest: Support for talent Spirit of Redemption (Icon name: Spell_Holy_GreaterHeal)
- RP-style whispers
- Optionally show the healing targets health bar (before and after spell) above the casting bar while casting a spell.
- Add optional sound when more than 50% of the healing spell will be wasted (overheal warning).
- Add configurable excessive overhealing threshold.

NOT TODO:
- Support for curse/poison/disease removal. Check out [link='http://ui.worldofwar.net/ui.php?id=2506']Decursive[/link].