--[[
--	CastOptions Localization
--		"English Localization"
--	
--	English By: Mugendai
--	Contact: mugekun@gmail.com
--	
--	$Id: localization.lua 2649 2005-10-19 02:20:11Z mugendai $
--	$Rev: 2649 $
--	$LastChangedBy: mugendai $
--	$Date: 2005-10-18 21:20:11 -0500 (Tue, 18 Oct 2005) $
--]]

--------------------------------------------------
--
-- Binding Strings
--
--------------------------------------------------
BINDING_HEADER_CASTOPTIONS = "Cast Options";
BINDING_NAME_CASTOPTIONS_SELF = "Self Cast";
BINDING_NAME_CASTOPTIONS_TOGGLESELF = "Self Cast Toggle";
BINDING_NAME_CASTOPTIONS_PARTY1 = "Group Member 1 Cast";
BINDING_NAME_CASTOPTIONS_PARTY2 = "Group Member 2 Cast";
BINDING_NAME_CASTOPTIONS_PARTY3 = "Group Member 3 Cast";
BINDING_NAME_CASTOPTIONS_PARTY4 = "Group Member 4 Cast";
BINDING_NAME_CASTOPTIONS_AIMED = "Aimed Cast";

--------------------------------------------------
--
-- UI Strings
--
--------------------------------------------------
CASTOPTIONS_CONFIG_SECTION = "Cast Options";
CASTOPTIONS_CONFIG_SECTION_INFO = "Provides enchanced casting options such as auto self casting.";
CASTOPTIONS_CONFIG_MAIN_HEADER = "General Options";
CASTOPTIONS_CONFIG_MAIN_HEADER_INFO = "Options in general for Cast Options";
CASTOPTIONS_CONFIG_ENABLED = "Enable Cast Options";
CASTOPTIONS_CONFIG_ENABLED_INFO = "This must be enabled, for any of Cast Options features to work, including key bindings.";
CASTOPTIONS_CONFIG_SMARTEQUIP = "Smart Equipment Buffing";
CASTOPTIONS_CONFIG_SMARTEQUIP_INFO = "If enabled when you use an equipment buff, your equipped item will be selected for you.";
CASTOPTIONS_CONFIG_CANCELWAND = "Cancel Wand";
CASTOPTIONS_CONFIG_CANCELWAND_INFO = "If enabled this will cancel casting of a wand when a spell is cast."
CASTOPTIONS_CONFIG_CANCELSHOT = "Cancel Auto Shot";
CASTOPTIONS_CONFIG_CANCELSHOT_INFO = "If enabled this will cancel auto shooting of a ranged weapon when when bandaging."
CASTOPTIONS_CONFIG_SHOWCANCELSHOT = "Show Shot Canceled";
CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO = "If enabled this will show a message when wand or range casting is canceled.";
CASTOPTIONS_CONFIG_NODISPEL = "No Dispel Magic";
CASTOPTIONS_CONFIG_NODISPEL_INFO = "If enabled this will prevent Dispel Magic from being automatically self or group cast.";
CASTOPTIONS_CONFIG_MANACONTROL = "Mana Control";
CASTOPTIONS_CONFIG_MANACONTROL_INFO = "If enabled, will not cast mana boosting spells on targets that don't use mana.";
CASTOPTIONS_CONFIG_TOGGLESELF = "Toggle self casting";
CASTOPTIONS_CONFIG_TOGGLESELF_INFO = "Toggles self casting, like the hotkey 'Self Cast Toggle'";
CASTOPTIONS_CONFIG_TOGGLESELF_TEXT = "Toggle";
CASTOPTIONS_CONFIG_KEYS_HEADER = "Self Cast Keys";
CASTOPTIONS_CONFIG_KEYS_HEADER_INFO = "Sets which keys enable self casting.";
CASTOPTIONS_CONFIG_RANK_HEADER = "Smart Rank Casting";
CASTOPTIONS_CONFIG_RANK_HEADER_INFO = "Options relating to casting spells at modified ranks";
CASTOPTIONS_CONFIG_SMARTRANK = "Smart Rank Casting";
CASTOPTIONS_CONFIG_SMARTRANK_INFO = "If enabled and your target is too low a level to have the current buff cast on them, a lower level will be cast.";
CASTOPTIONS_CONFIG_SMARTHEAL = "Smart Rank Healing";
CASTOPTIONS_CONFIG_SMARTHEAL_INFO = "If enabled, healing spells will be cast at the lowest rank to heal your target for the life they need.  Requires Smart Rank Casting.";
CASTOPTIONS_CONFIG_HEALBOOST = "Extra Healing";
CASTOPTIONS_CONFIG_HEALBOOST_INFO = "The percentage of extra health you want to heal when doing Smart Rank Healing.";
CASTOPTIONS_CONFIG_HEALBOOST_SUFFIX = "%";
CASTOPTIONS_CONFIG_ALT = "Alt Self Cast";
CASTOPTIONS_CONFIG_ALT_INFO = "If Alt key is held down self cast will occur.";
CASTOPTIONS_CONFIG_SHIFT = "Shift Self Cast";
CASTOPTIONS_CONFIG_SHIFT_INFO = "If Shift key is held down self cast will occur.";
CASTOPTIONS_CONFIG_CTRL = "Ctrl Self Cast";
CASTOPTIONS_CONFIG_CTRL_INFO = "If Ctrl key is held down self cast will occur.";
CASTOPTIONS_CONFIG_RIGHTSELF = "Right Click Self Cast";
CASTOPTIONS_CONFIG_RIGHTSELF_INFO = "If the action button is right clicked self cast will occur.";
CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER = "Aimed Casting";
CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER_INFO = "Sets options for casting at unit whose frame the mouse is over.";
CASTOPTIONS_CONFIG_AIMEDCAST = "Aimed Casting";
CASTOPTIONS_CONFIG_AIMEDCAST_INFO = "If enabled the spell will be cast at the unit whose frame the mouse is over.  The aimed cast keys do not need this enabled to work.";
CASTOPTIONS_CONFIG_AIMEDWORLD = "Aimed World Casting";
CASTOPTIONS_CONFIG_AIMEDWORLD_INFO = "If enabled you will be able to aimed cast at units anywhere on your screen, not just the frames.";
CASTOPTIONS_CONFIG_AIMEDHOSTILE = "Aimed Hostile Casting";
CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO = "If enabled you will be able to aimed cast hostile spell.";
CASTOPTIONS_CONFIG_AIMEDALT = "Alt Aimed Cast";
CASTOPTIONS_CONFIG_AIMEDALT_INFO = "If Alt key is held down an aimed cast will occur.";
CASTOPTIONS_CONFIG_AIMEDSHIFT = "Shift Aimed Cast";
CASTOPTIONS_CONFIG_AIMEDSHIFT_INFO = "If Shift key is held down an aimed cast will occur.";
CASTOPTIONS_CONFIG_AIMEDCTRL = "Ctrl Aimed Cast";
CASTOPTIONS_CONFIG_AIMEDCTRL_INFO = "If Ctrl key is held down an aimed cast will occur.";
CASTOPTIONS_CONFIG_SMART_HEADER = "Smart Self Casting";
CASTOPTIONS_CONFIG_SMART_HEADER_INFO = "Options for smart automatic self casting.";
CASTOPTIONS_CONFIG_SMART = "Smart Self Cast";
CASTOPTIONS_CONFIG_SMART_INFO = "If enabled, positive spells will be self cast if you have no target.";
CASTOPTIONS_CONFIG_NOGROUP = "Disable Smart Self Casting In Groups";
CASTOPTIONS_CONFIG_NOGROUP_INFO = "Disables Smart Self Casting when you are in a group.";
CASTOPTIONS_CONFIG_SMARTASSIST_HEADER = "Smart Assist Options";
CASTOPTIONS_CONFIG_SMARTASSIST_HEADER_INFO = "Options for smart assist casting.";
CASTOPTIONS_CONFIG_SMARTASSIST = "Smart Assist Casting";
CASTOPTIONS_CONFIG_SMARTASSIST_INFO = "If enabled and your target is friendly, and you cast a hostile spell, then it will be cast at your friends hostile target.";
CASTOPTIONS_CONFIG_ASSISTTARGET = "Target Chosen Hostile";
CASTOPTIONS_CONFIG_ASSISTTARGET_INFO = "If enabled, the target will change to the chosen hostile unit on an assist cast.";
CASTOPTIONS_CONFIG_CHAINASSIST = "Chain Assist";
CASTOPTIONS_CONFIG_CHAINASSIST_INFO = "If enabled, Smart Assist will keep targeting friendlies that have targets till it finds a hostile, or no target.";
CASTOPTIONS_CONFIG_SMARTGROUP_HEADER = "Smart Group Casting";
CASTOPTIONS_CONFIG_SMARTGROUP_HEADER_INFO = "Options for smart automatic group casting.";
CASTOPTIONS_CONFIG_SMARTGROUP = "Smart Group Casting";
CASTOPTIONS_CONFIG_SMARTGROUP_INFO = "When in a group casts friendly spells at appropriate group members when a hostile, or no target is selected.";
CASTOPTIONS_CONFIG_GROUPPETS = "Group Pet Casting";
CASTOPTIONS_CONFIG_GROUPPETS_INFO = "Does group casting on group pets as well.";
CASTOPTIONS_CONFIG_GROUPTARGET = "Target Chosen Unit";
CASTOPTIONS_CONFIG_GROUPTARGET_INFO = "If enabled, the target will change to the chosen target of a group cast.";
CASTOPTIONS_CONFIG_GROUPGROUP = "Group Target Casting";
CASTOPTIONS_CONFIG_GROUPGROUP_INFO = "When in a group if a friendly target is selected, then the spell will be group cast.";
CASTOPTIONS_CONFIG_GROUPSELF = "Group Self Casting";
CASTOPTIONS_CONFIG_GROUPSELF_INFO = "When in a group will allow group cast at yourself if appropriate.";
CASTOPTIONS_CONFIG_GROUPHEAL = "Group Heal Casting";
CASTOPTIONS_CONFIG_GROUPHEAL_INFO = "When in a group will cast healing spells at the member with the lowest life.";
CASTOPTIONS_CONFIG_GROUPMANA = "Group Mana Casting";
CASTOPTIONS_CONFIG_GROUPMANA_INFO = "When in a group will cast mana boosting spells at the member with the lowest mana.";
CASTOPTIONS_CONFIG_GROUPCURE = "Group Cure Casting";
CASTOPTIONS_CONFIG_GROUPCURE_INFO = "When in a group will cast curing spells on members that have poisen/curse/disease/magic debuffs.";
CASTOPTIONS_CONFIG_GROUPBUFF = "Group Buff Casting";
CASTOPTIONS_CONFIG_GROUPBUFF_INFO = "When in a group will cast buffs at a member who doesn't yet have the buff.";
CASTOPTIONS_CONFIG_GROUPBLESSING = "Group Blessing Casting";
CASTOPTIONS_CONFIG_GROUPBLESSING_INFO = "Will allow group casting of blessing spells.  Read help for details on usage.";
CASTOPTIONS_CONFIG_CANCELSPELL = "Cancel on No Target";
CASTOPTIONS_CONFIG_CANCELSPELL_INFO = "If enabled, then if no good target is found for a group cast, the spell will be canceled.";
CASTOPTIONS_CONFIG_RECASTTIME = "Delay Between Re-cast";
CASTOPTIONS_CONFIG_RECASTTIME_INFO = "When in a group won't cast a heal or a buff on a char that has had this spell cast on them in this time.";
CASTOPTIONS_CONFIG_RECASTTIME_SUFFIX = " second(s)";
CASTOPTIONS_CONFIG_BOUND_HEADER = "Bound Unit Casting";
CASTOPTIONS_CONFIG_BOUND_HEADER_INFO = "Options relating to casting at bound units";
CASTOPTIONS_CONFIG_NOBOUNDCAST = "No Cast on Bound Target";
CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO = "If enabled, will not cast spells that would free a target bound by effects such as sleep, polymorph, and turn undead.";
CASTOPTIONS_CONFIG_BOUNDPOTENTIAL = "No Potential Freedom";
CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO = "If enabled, will not cast spells that would free a target that would only be potentially freed, such as an entangled unit.";
CASTOPTIONS_CONFIG_BOUNDATTACK = "No Bound Attackers";
CASTOPTIONS_CONFIG_BOUNDATTACK_INFO = "If enabled, will not cast spells on bound units that can still attack.";
CASTOPTIONS_CONFIG_BOUNDDELAY = "Bound Override Time";
CASTOPTIONS_CONFIG_BOUNDDELAY_INFO = "If you use a spell that would break free a bound unit a second time, in this amount of time, you will cast it anyway.";
CASTOPTIONS_CONFIG_BOUNDDELAY_SUFFIX = " second(s)";

--------------------------------------------------
--
-- Chat Strings
--
--------------------------------------------------
CASTOPTIONS_CHAT_ENABLED = CASTOPTIONS_CONFIG_ENABLED;
CASTOPTIONS_CHAT_SMARTEQUIP = CASTOPTIONS_CONFIG_SMARTEQUIP;
CASTOPTIONS_CHAT_CANCELWAND = CASTOPTIONS_CONFIG_CANCELWAND;
CASTOPTIONS_CHAT_CANCELSHOT = CASTOPTIONS_CONFIG_CANCELSHOT;
CASTOPTIONS_CHAT_SHOWCANCELSHOT = CASTOPTIONS_CONFIG_SHOWCANCELSHOT;
CASTOPTIONS_CHAT_NODISPEL = CASTOPTIONS_CONFIG_NODISPEL;
CASTOPTIONS_CHAT_MANACONTROL = CASTOPTIONS_CONFIG_MANACONTROL;
CASTOPTIONS_CHAT_SMARTRANK = CASTOPTIONS_CONFIG_SMARTRANK;
CASTOPTIONS_CHAT_SMARTHEAL = CASTOPTIONS_CONFIG_SMARTHEAL;
CASTOPTIONS_CHAT_HEALBOOST = CASTOPTIONS_CONFIG_HEALBOOST;
CASTOPTIONS_CHAT_ALT = CASTOPTIONS_CONFIG_ALT;
CASTOPTIONS_CHAT_SHIFT = CASTOPTIONS_CONFIG_SHIFT;
CASTOPTIONS_CHAT_CTRL = CASTOPTIONS_CONFIG_CTRL;
CASTOPTIONS_CHAT_RIGHTSELF = CASTOPTIONS_CONFIG_RIGHTSELF;
CASTOPTIONS_CHAT_AIMEDCAST = CASTOPTIONS_CONFIG_AIMEDCAST;
CASTOPTIONS_CHAT_AIMEDWORLD = CASTOPTIONS_CONFIG_AIMEDWORLD;
CASTOPTIONS_CHAT_AIMEDHOSTILE = CASTOPTIONS_CONFIG_AIMEDHOSTILE;
CASTOPTIONS_CHAT_AIMEDALT = CASTOPTIONS_CONFIG_AIMEDALT;
CASTOPTIONS_CHAT_AIMEDSHIFT = CASTOPTIONS_CONFIG_AIMEDSHIFT;
CASTOPTIONS_CHAT_AIMEDCTRL = CASTOPTIONS_CONFIG_AIMEDCTRL;
CASTOPTIONS_CHAT_SMART = CASTOPTIONS_CONFIG_SMART;
CASTOPTIONS_CHAT_NOGROUP = CASTOPTIONS_CONFIG_NOGROUP;
CASTOPTIONS_CHAT_SMARTASSIST = CASTOPTIONS_CONFIG_SMARTASSIST;
CASTOPTIONS_CHAT_ASSISTTARGET = CASTOPTIONS_CONFIG_ASSISTTARGET;
CASTOPTIONS_CHAT_CHAINASSIST = CASTOPTIONS_CONFIG_CHAINASSIST;
CASTOPTIONS_CHAT_SMARTGROUP = CASTOPTIONS_CONFIG_SMARTGROUP;
CASTOPTIONS_CHAT_GROUPPETS = CASTOPTIONS_CONFIG_GROUPPETS;
CASTOPTIONS_CHAT_GROUPTARGET = CASTOPTIONS_CONFIG_GROUPTARGET;
CASTOPTIONS_CHAT_GROUPGROUP = CASTOPTIONS_CONFIG_GROUPGROUP;
CASTOPTIONS_CHAT_GROUPSELF = CASTOPTIONS_CONFIG_GROUPSELF;
CASTOPTIONS_CHAT_GROUPHEAL = CASTOPTIONS_CONFIG_GROUPHEAL;
CASTOPTIONS_CHAT_GROUPMANA = CASTOPTIONS_CONFIG_GROUPMANA;
CASTOPTIONS_CHAT_GROUPCURE = CASTOPTIONS_CONFIG_GROUPCURE;
CASTOPTIONS_CHAT_GROUPBUFF = CASTOPTIONS_CONFIG_GROUPBUFF;
CASTOPTIONS_CHAT_GROUPBLESSING = CASTOPTIONS_CONFIG_GROUPBLESSING;
CASTOPTIONS_CHAT_CANCELSPELL = CASTOPTIONS_CONFIG_CANCELSPELL;
CASTOPTIONS_CHAT_RECASTTIME = CASTOPTIONS_CONFIG_RECASTTIME;
CASTOPTIONS_CHAT_NOBOUNDCAST = CASTOPTIONS_CONFIG_NOBOUNDCAST;
CASTOPTIONS_CHAT_BOUNDPOTENTIAL = CASTOPTIONS_CONFIG_BOUNDPOTENTIAL;
CASTOPTIONS_CHAT_BOUNDATTACK = CASTOPTIONS_CONFIG_BOUNDATTACK;
CASTOPTIONS_CHAT_BOUNDDELAY = CASTOPTIONS_CONFIG_BOUNDDELAY;
CASTOPTIONS_CHAT_TEXTURE = "Texture Printing";
CASTOPTIONS_CHAT_TEXTURE_INFO	= "If enabled will print the texture of the spell that was just cast.";
CASTOPTIONS_CHAT_LINK = "Item Link ID Printing";
CASTOPTIONS_CHAT_LINK_INFO	= "If enabled will print the item link ID when you use an item.";

--------------------------------------------------
--
-- DeBuff Types
--
--------------------------------------------------
CASTOPTIONS_DEBUFF_POISEN = "Poison";
CASTOPTIONS_DEBUFF_CURSE = "Curse";
CASTOPTIONS_DEBUFF_DISEASE = "Disease";
CASTOPTIONS_DEBUFF_MAGIC = "Magic";

--------------------------------------------------
--
-- Bound Names
--
--------------------------------------------------
--CASTOPTIONS_BOUND_GOUGE = "Gouge";

--------------------------------------------------
--
-- Other Spell Locale
--
--------------------------------------------------
CASTOPTIONS_RANK = "Rank";
CASTOPTIONS_RANK_PARSE = "%("..CASTOPTIONS_RANK.." (%d+)%)";

--------------------------------------------------
--
-- Error Messages
--
--------------------------------------------------
CASTOPTIONS_ERROR_CANCELED_WAND = "Canceled shooting of wand";
CASTOPTIONS_ERROR_CANCELED_SHOT = "Canceled Auto Shot";
CASTOPTIONS_ERROR_BOUND = "The unit may be freed if attacked";
CASTOPTIONS_ERROR_ASC = "AltSelfCast found, disabling CastOptions";
CASTOPTIONS_ERROR_ASC_INFO = "CastOptions is a replacement of AltSelfCast, and these two addons can not be used at the same time.  Please delete AltSelfCast.  CastOptions will not function until you do.";
CASTOPTIONS_ERROR_NOTARG = "No good target found for this spell";
CASTOPTIONS_ERROR_NOMANA = "Mana spells will not benifit this unit";

--------------------------------------------------
--
-- Help Text
--
--------------------------------------------------
CASTOPTIONS_CONFIG_INFOTEXT = {
	"[NOTE: If you are using Khaos, you may not be "..
	"seeing all of the options available.  For more "..
	"advanced options, increase the difficulty setting.]\n"..
	"\n"..
	"  CastOptions is an addon that allows you to "..
	"take control over how you cast your spells.\n\n"..
	"It lets you configure system keys to be held "..
	"when casting a spell to cause you to cast the "..
	"spell on yourself, instead of your target.\n"..
	"It can make you automatically cast spells at "..
	"yourself if you don't have a valid target selected.\n"..
	"It can make you cast hostile spells at the target of "..
	"the player you have targeted.\n"..
	"And it can be set to choose your target for you, by "..
	"picking the most elligable group member, when "..
	"you are casting a friendly spell.\n\n"..
	"Option Explaination:\n"..
	CASTOPTIONS_CONFIG_ENABLED.." - "..CASTOPTIONS_CONFIG_ENABLED_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_SMARTEQUIP.." - "..CASTOPTIONS_CONFIG_SMARTEQUIP_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_CANCELWAND.." - "..CASTOPTIONS_CONFIG_CANCELWAND_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_CANCELSHOT.." - "..CASTOPTIONS_CONFIG_CANCELSHOT_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_SHOWCANCELSHOT.." - "..CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_NODISPEL.." - "..CASTOPTIONS_CONFIG_NODISPEL_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_MANACONTROL.." - "..CASTOPTIONS_CONFIG_MANACONTROL_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_SMARTRANK.." - "..CASTOPTIONS_CONFIG_SMARTRANK_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_SMARTHEAL.." - "..CASTOPTIONS_CONFIG_SMARTHEAL_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_HEALBOOST.." - "..CASTOPTIONS_CONFIG_HEALBOOST_INFO.."\n\n"..
		"Alt/Ctrl/Shift Self Cast - If any of these are enabled, if they are pushed when you cast, the spell will be self cast.\n\n"..
	CASTOPTIONS_CONFIG_RIGHTSELF.." - "..CASTOPTIONS_CONFIG_RIGHTSELF_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_AIMEDCAST.." - "..CASTOPTIONS_CONFIG_AIMEDCAST_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_AIMEDWORLD.." - "..CASTOPTIONS_CONFIG_AIMEDWORLD_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_AIMEDHOSTILE.." - "..CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO.."\n\n"..
		"Alt/Ctrl/Shift Aimed Cast - If any of these are enabled, if they are pushed when you cast, the spell will be aimed cast.  "..
		"Aimed Casting does not need to be enabled for this to work.\n\n"..
	CASTOPTIONS_CONFIG_SMART.." - "..CASTOPTIONS_CONFIG_SMART_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_NOGROUP.." - "..CASTOPTIONS_CONFIG_NOGROUP_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_SMARTASSIST.." - "..CASTOPTIONS_CONFIG_SMARTASSIST_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_ASSISTTARGET.." - "..CASTOPTIONS_CONFIG_ASSISTTARGET_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_CHAINASSIST.." - "..CASTOPTIONS_CONFIG_CHAINASSIST_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_SMARTGROUP.." - "..CASTOPTIONS_CONFIG_SMARTGROUP_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPPETS.." - "..CASTOPTIONS_CONFIG_GROUPPETS_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPTARGET.." - "..CASTOPTIONS_CONFIG_GROUPTARGET_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPGROUP.." - "..CASTOPTIONS_CONFIG_GROUPGROUP_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPSELF.." - "..CASTOPTIONS_CONFIG_GROUPSELF_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPHEAL.." - "..CASTOPTIONS_CONFIG_GROUPHEAL_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPMANA.." - "..CASTOPTIONS_CONFIG_GROUPMANA_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPCURE.." - "..CASTOPTIONS_CONFIG_GROUPCURE_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPBUFF.." - "..CASTOPTIONS_CONFIG_GROUPBUFF_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_GROUPBLESSING.." - If you want to group cast blessing spells, this must be enabled.  You must also enable "..
		CASTOPTIONS_CONFIG_GROUPBUFF.." for this to work.  Group casting of blessing can not be handled as well as other buffs, "..
		"due to the fact that a player can only have one blessing per paladin.  CastOptions has no way of knowing if you want to "..
		"rebuff a particular player, or change one of the players to a different blessing, or which blessing you prefer on each "..
		"player.  So you have to teach Cast Options who you want to cast what at.  At first it assumes no targets are good for group "..
		"cast.  You must select the party member, pet, or yourself to cast the blessing.  Once you cast a blessing at a unit, "..
		"Cast Options will remember that you want that blessing cast at that unit, and will group cast it at that unit from now on. "..
		"You can put as many people on the same blessing as you wish, and Cast Options will pick between them.  If you cast a diffent "..
		"blessing on a unit that you've already cast one on, then that unit will get that blessing from now on instead.  The blessing "..
		"targets are remembered per character, across sessions.\n\n"..
	CASTOPTIONS_CONFIG_NOBOUNDCAST.." - "..CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_BOUNDPOTENTIAL.." - "..CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_BOUNDATTACK.." - "..CASTOPTIONS_CONFIG_BOUNDATTACK_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_BOUNDDELAY.." - "..CASTOPTIONS_CONFIG_BOUNDDELAY_INFO.."\n\n"..
	CASTOPTIONS_CONFIG_RECASTTIME.." - "..CASTOPTIONS_CONFIG_RECASTTIME_INFO.."\n"..
	"\n"..
	"See page 3 for a list of slash commands.",
	
	"Cast Options\n"..
	"\n"..
	"By: Mugendai\n"..
	"Special Thanks:\n"..
	"    Telo - Origional concept for Self Cast\n\n"..
	"    Sarf - For making the origional Addon\n\n"..
	"    Exi and Miravlix - For doing some rewriting and initial implimentation of Smart Ranks, "..
												"resulting in prompting me to go ahead and do the rewrite.\n\n"..
	"    Some Other People - For the concept of smart ranks, and their implementations. "..
												"The info on the spell ranks, and some of the code related to them "..
												"is based on someone elses work.  I do not know who, but whoever "..
												"they are, they deserve credit for it.  If you wanna claim credit "..
												"for this, then let me, Mugendai know.\n\n"..
	"    Wh1sper - For the concept of Smart Assist Casting, and for going through the trouble to "..
							"workout the textures for allmsot all the hostile, and self cast spells.\n\n"..
	"Contact: mugekun@gmail.com"
}
