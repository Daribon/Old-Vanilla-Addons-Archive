CT_RAMENU_HOME = "CT_RaidAssist is a mod designed to help your raid in various situations. It allows you to monitor health & mana/energy/rage of anyone/everyone in your raid, as well as the health & mana of up to 5 people's targets.  You can show up to 4 buffs of your choice, show when a player is debuffed, and have it notify you to cure or recast buffs.";

CT_RAMENU_STEP1 = "1) Register a channel\n|c00FFFFFFPress the General Options button below, and set a channel to monitor. Note that every user of this mod in the raid must choose the same channel. Also note that the mod chooses a default channel named |rCTGuildName |c00FFFFFF(with spaces removed).|r";

CT_RAMENU_STEP2 = "2) Join the channel\n|c00FFFFFFOnce your channel is set, hit the Join Channel button to make sure you are in the channel.  Leaders/promoted can broadcast the channel to the raid chat which will set everyone to the correct channel, all they need to do then is type |r/raidassist join|c00FFFFFF to join.|r";

CT_RAMENU_STEP3 = "3) Feel the magic!\n|c00FFFFFFThe mod should now be properly configured, and ready to use. You can select which groups to show by checking or unchecking groups on the CTRaid window. To configure additional settings, use the option sections below:";

CT_RAMENU_BUFFSDESCRIPT = "Select the buffs and debuffs you would like to show.  A max of 4 buffs can be shown at once. Debuffs will change the color of the window to the color you select. Use the arrows to move buffs and debuffs up or down. If more than the limit are shown, the top ones take priority.";
CT_RAMENU_GENERALDESCRIPT = "Below you will find options to change the way things are displayed. Turning on a Unit's Target will show you the target of players who are set to be Assist Targets. Leaders or promoted can right click a player in the CTRaid window and set them as an Assist Target. Up to 5 people can have their targets displayed at once. Raid leaders and promoted can press the Update Status button to update health, mana, and buffs for everyone in the raid.";
CT_RAMENU_MISCDESCRIPT = "Mana Conserve allows you to auto-cancel casting heals if the target has more than X% health when the spell is about to land |c00FFFFFFand you are in combat|r. Note that you must keep the same target the entire cast for this to work properly.";
CT_RAMENU_REPORTDESCRIPT = "Checking a button makes you report health and mana for the person you checked. If you or the person leaves the party, you will stop reporting automatically.";
CT_RAMENU_ADDITIONALDESCRIPT = "Spam control allows you to limit the number of messages you send out, both hp and mana.  MT's may want to set their 'mana' to 100% to completely block sending changes in their Rage. Setting your interval to 3% means you will send our updates when your hp hits 97%, then 94%, and 91% as opposed to an update every percent.";

BINDING_HEADER_CT_RAIDASSIST = "CT_RaidAssist";
BINDING_NAME_CT_CUREDEBUFF = "Cure Raid Debuffs"; 
BINDING_NAME_CT_RECASTRAIDBUFF = "Recast Raid Buffs";
BINDING_NAME_CT_SHOWHIDE = "Show/Hide Raid Windows";
BINDING_NAME_CT_RESMON = "Toggle Resurrection Monitor";
BINDING_NAME_CT_TOGGLEDEBUFFS = "Toggle Buff/Debuff view";
BINDING_NAME_CT_ASSISTMT1 = "Assist MT 1";
BINDING_NAME_CT_ASSISTMT2 = "Assist MT 2";
BINDING_NAME_CT_ASSISTMT3 = "Assist MT 3";
BINDING_NAME_CT_ASSISTMT4 = "Assist MT 4";
BINDING_NAME_CT_ASSISTMT5 = "Assist MT 5";

CT_RAMENU_FAQ1 = "Q. Can you move CTRaid group positions?\n|c00FFFFFFA. Make sure \"Lock Group Positions\" is unchecked in the General options, as well as \"Show Group Names\" is turned on, then click and drag the 'Group#' text.|r";
CT_RAMENU_FAQ2 = "Q. How do I send CTRaid Alert Messages?\n|c00FFFFFFA. Raid leaders or promoted can send an on screen alert to all raid members using the mod by typing /rs <text> where <text> is your message. Each person can change the color their alert message shows up in.|r";
CT_RAMENU_FAQ3 = "Q. How can I use the invite features?\n|c00FFFFFFA. Raid leaders/promoted can /rainvite xx-yy (/rainvite 58-60) to invite all people in guild of the specified level.  /rakeyword sets a keyword so when someone sends you a tell with that keyword, they will automatically be invited.|r"
CT_RAMENU_FAQ4 = "Q. How do I quick recast fading buffs or cure debuffs?\n|c00FFFFFFA. Hit escape to bring up the game menu, then click key bindings.  Towards the bottom of the key bindings you will see options for CT_RaidAssist.  Set the keys you want to use for cures or buffs, then hit ok.|r";
CT_RAMENU_FAQ5 = "Q. People's names keep flashing different colors, why?\n|c00FFFFFFA. When a person is debuffed, it changes the background of their window to the color you selected in the Buff Options.  If you do not wish to see when someone is debuffed, simply uncheck the debuff options.|r";
CT_RAMENU_FAQ6 = "Q. When mass inviting, it doesn't invite everyone, how come?\n|c00FFFFFFA. The game does not get information about your guild members before you visit the guild tab. Try opening the guild tab and then try mass inviting again.|r";
CT_RAMENU_FAQ7 = "For more information on CT mods, or for suggestions, comments, or questions not answered here, please visit us at http://www.ctmod.net";

-- Spells

CT_RA_POWERWORDFORTITUDE = {
	["en"] = { "Power Word: Fortitude", "Prayer of Fortitude" },
}
CT_RA_MARKOFTHEWILD = {
	["en"] = { "Mark of the Wild", "Gift of the Wild" },
}
CT_RA_ARCANEINTELLECT = {
	["en"] = { "Arcane Intellect", "Arcane Brilliance" },
}
CT_RA_ADMIRALSHAT = {
	["en"] = "Admiral's Hat",
}
CT_RA_SHADOWPROTECTION = {
	["en"] = "Shadow Protection",
}
CT_RA_POWERWORDSHIELD = {
	["en"] = "Power Word: Shield",
}
CT_RA_SOULSTONERESURRECTION = {
	["en"] = "Soulstone Resurrection",
}
CT_RA_DIVINESPIRIT = {
	["en"] = "Divine Spirit",
}
CT_RA_THORNS = {
	["en"] = "Thorns",
}
CT_RA_FEARWARD = {
	["en"] = "Fear Ward",
}
CT_RA_BLESSINGOFMIGHT = {
	["en"] = "Blessing of Might",
}
CT_RA_BLESSINGOFWISDOM = {
	["en"] = "Blessing of Wisdom",
}
CT_RA_BLESSINGOFKINGS = {
	["en"] = "Blessing of Kings",
}
CT_RA_BLESSINGOFSALVATION = {
	["en"] = "Blessing of Salvation",
}
CT_RA_BLESSINGOFLIGHT = {
	["en"] = "Blessing of Light",
}
CT_RA_BLESSINGOFSANCTUARY = {
	["en"] = "Blessing of Sanctuary",
}

CT_RA_ClassHealings = {
	["en"] = {
		["Priest"] = {
			{ { "Heal", "Lesser Heal", "Greater Heal" }, "Lesser Heal, Heal and Greater Heal", 1 },
			{ "Flash Heal", "Flash Heal", 1 }
		},
		["Shaman"] = {
			{ "Healing Wave", "Healing Wave", 1 },
			{ "Lesser Healing Wave", "Lesser Healing Wave", 1 }
		},
		["Druid"] = {
			{ "Healing Touch", "Healing Touch", 1 },
			{ "Regrowth", "Regrowth", 1 }
		},
		["Paladin"] = {
			{ "Holy Light", "Holy Light", 1 },
			{ "Flash of Light", "Flash of Light", 1 }
		}
	}
};

CT_RA_WARRIOR = "Warrior";
CT_RA_ROGUE = "Rogue";
CT_RA_HUNTER = "Hunter";
CT_RA_MAGE = "Mage";
CT_RA_WARLOCK = "Warlock";
CT_RA_DRUID = "Druid";
CT_RA_PRIEST = "Priest";
CT_RA_SHAMAN = "Shaman";
CT_RA_PALADIN = "Paladin";

CT_RA_MAGIC = {
	["en"] = "Magic"
};
CT_RA_DISEASE = {
	["en"] = "Disease"
};
CT_RA_POISON = {
	["en"] = "Poison"
};
CT_RA_CURSE = {
	["en"] = "Curse"
};
CT_RA_WEAKENEDSOUL = {
	["en"] = "Weakened_Soul"
};
CT_RA_RECENTLYBANDAGED = {
	["en"] = "Recently_Bandaged"
};

CT_RA_FEIGNDEATH = {
	["en"] = "Feign Death"
};