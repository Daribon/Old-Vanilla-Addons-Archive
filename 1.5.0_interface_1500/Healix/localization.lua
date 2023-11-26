NIL_SPELL		= "Nil Spell"; --a place holder in spell arays

--------
--Chat--
--------
Hx_CHAT_COMMAND_INFO	= "Command-Line support for Healix";
Hx_CHAT_COMMAND_USAGE	= "Usage:/hx or /Hx";
Hx_HELP			= "/hx menu = pulls up the menu. /hx spell = pulls up spell menu.";

----------
--Header--
----------
Hx_VERSION		= "4.3";
Hx_HEADER_SHORT		= "Healix!"..Hx_VERSION;
HxOptions_HEADER	= "Healix Options";
Hx_HEADER_LONG		= "Sends messages if you use certain actions.";
HxSpellOptions_HEADER	= "Spells for Healix";

-------------
--PopUpText--
-------------
Hx_ADD_SPELL_POPUP	= "Add which spell? \n Watch Caps";
Hx_REMOVE_SPELL_POPUP	= "Remove which spell?";
Hx_GET_CHANNEL_POPUP	= "Which Channel for display?";
Hx_GET_PREFIX_POPUP	= "Prefix when in a party?";
Hx_GET_POSTFIX_POPUP	= "Postfix when in a party?";
Hx_GET_INTERRUPT_POPUP	= "Say what when interrupted?";
Hx_GET_SPELLTEXT_POPUP	= "@t=target,@s=spell,@m=time,\n@r=rank,@pre=prefix,@post=postfix";

------------
-- output --
------------
Hx_ONSTAR		= "on ";
Hx_ONHIMSELF		= " "..Hx_ONSTAR.."himself";
Hx_ONHERSELF		= " "..Hx_ONSTAR.."herself";
Hx_SPELL_INTERRUPTED	= "<< Spell Interrupted! >>";
Hx_CHANNEL_ERROR	= "**Wrong Channel (Or Checkbox unchecked) for Healix! Channel is now nothing**";
Hx_DEFAULT_PREFIX	= "<< Casting";
Hx_DEFAULT_POSTFIX	= ">>";
Hx_EMOTE_PREFIX		= "begins ";
Hx_DEFAULT_SPELLTEXT	= "@pre @s @on_t @post";
Hx_DEFAULT_SPELLTEXT_NOTARGET = "@pre @s @post";

--------------------------
-- HealixButton(cosmos) --
--------------------------
Hx_COS_BUTTON_INFO	= "Options";

------------------
--Option Toggles--
------------------
Hx_SPELL_INFO		= "Announce when you cast this spell";
HxTXT = {Main= {}; Party= {}; NonParty= {}; Raid={}; Time= {}; EmoteSelf= {}; Smartparty= {}; Prefix= {}; Target={}; Interrupt= {};};
HxTXT.Main		= {SHORT= "Main"; LONG= "Enable or disable Healix!";};
HxTXT.Party		= {SHORT= "Party"; LONG= "Will display when in a party.";};
HxTXT.NonParty		= {SHORT= "NonParty"; LONG= "Will display when not in party.";};
HxTXT.Raid		= {SHORT= "Raid"; LONG= "Will raid chat instead of party ";};
HxTXT.Time		= {SHORT= "Time"; LONG= "Will display spell time when casting.";};
HxTXT.EmoteSelf		= {SHORT= "EmoteSelf"; LONG= "Will emote when you cast on yourself.";};
HxTXT.SmartParty	= {SHORT= "SmartParty"; LONG= "Will only party chat if more than one healer.";};
HxTXT.Prefix		= {SHORT= "Prefix"; LONG= "Will party chat without saying 'Casting' ";};
HxTXT.Target		= {SHORT= "Target"; LONG= "Will say who you are targeting";};
HxTXT.Channel		= {SHORT= "Channel"; LONG= "The channel to output";};
HxTXT.Interrupt		= {SHORT= "Interrupt"; LONG= "Says when you are interrupted or spell fails";};
HxTXT.Combat		= {SHORT= "Combat" ; LONG = "Will display only when in combat";};
HxTXT.SpellTell		= {SHORT= "SpellTell" ; LONG = "This enables spell bars (Need partycomm)";};
HxTog = {["Main"] = 1; ["Party"] = 1; ["NonParty"] = 1; ["Raid"] = 0; ["Time"] = 0; ["SmartParty"] = 0; ["EmoteSelf"] = 1; ["Prefix"] = 1; ["Target"] = 1; ["Channel"] = 1; ["Interrupt"] = 1; ["Combat"] = 0; ["SpellTell"] = 0};

------------------
-- Class spells --
------------------
Hx = {};
--Note the class names(Shaman, Druid, ...) would have to be changed to fit german classes if you are translating
Hx.Class = { Shaman = {}; Druid = {}; Priest = {}; Paladin = {}; Mage = {}; Hunter = {}; Rogue = {}; Warlock = {}; Warrior = {};};
Hx.Class.Shaman = { "Ancestral Spirit","Healing Wave","Lesser Healing Wave","Chain Heal", "Lightning Bolt",
			"Chain Lightning", "Mana Tide Totem", "Astral Recall"};
Hx.Class.Druid = {"Rebirth","Regrowth","Healing Touch", "Rejuvenation", "Entangling Roots", "Hibernate", "Tranquility"};
Hx.Class.Priest = { "Resurrection","Flash Heal","Greater Heal","Lesser Heal","Prayer of Healing", 
			"Heal","Power Word: Shield", "Renew", "Fade", "Psychic Scream", "Shackle Undead";};
Hx.Class.Paladin = {"Redemption","Holy Light","Flash of Light"};
Hx.Class.Mage = {"Polymorph","Arcane Explosion"};
Hx.Class.Hunter = {"Hunter's Mark","Scare Beast", "Feign Death" };
Hx.Class.Rogue = { "Sap", "Gouge" };
Hx.Class.Warlock = { "Fear", "Hellfire", "Enslave Demon", "Rain of Fire", "Howl of Terror"};
Hx.Class.Warrior = { "Charge" };

Hx.Rez = { ["Ancestral Spirit"] = 1; ["Rebirth"] = 1; ["Resurrection"] = 1; ["Redemption"] = 1; };

--------List of no target spells
Hx.NoTarg = {	
	["Fear"] = 1; ["Hellfire"]=1; ["Rain of Fire"]=1; ["Howl of Terror"]=1;		--warlock
	["Psychic Scream"]=1; ["Prayer of Healing"]=1; ["Fade"]=1;			--priest
	["Tranquility"]=1;								--druid
	["Astral Recall"]=1; ["Mana Tide Totem"]=1;					--shaman
	["Arcane Explosion"]=1;								--mage
	["Feign Death"]=1;								--hunter
};

-------------------------------------------------
--Constant Self castable spell list (From sea) --
-------------------------------------------------
Hx.SelfCast = {
	-- Druid
	["Abolish Poison"] = 1;
	["Cure Poison"] = 1;
	["Healing Touch"] = 1;
	["Mark of the Wild"] = 1;
	["Regrowth"] = 1;
	["Rejuvenation"] = 1;
	["Remove Curse"] = 1;
	["Thorns"] = 1;
	-- Mage
	["Amplify Magic"] = 1;
	["Arcane Intellect"] = 1;
	["Dampen Magic"] = 1;
	["Remove Lesser Curse"] = 1;
	-- Paladin
	["Cleanse"] = 1;
	["Flash of Light"] = 1;
	["Holy Light"] = 1;
	["Purify"] = 1;
	["Lay on Hands"] = 1;
	["Blessing of Freedom"] = 1;
	["Blessing of Kings"] = 1;
	["Blessing of Light"] = 1;
	["Blessing of Might"] = 1;
	["Blessing of Protection"] = 1;
	["Blessing of Sacrifice"] = 1;
	["Blessing of Salvation"] = 1;
	["Blessing of Sanctuary"] = 1;
	["Blessing of Wisdom"] = 1;
	-- Priest
	["Abolish Disease"] = 1;
	["Cure Disease"] = 1;
	["Dispel Magic"] = 1;
	["Divine Spirit"] = 1;
	["Flash Heal"] = 1;
	["Greater Heal"] = 1;
	["Lesser Heal"] = 1;
	["Heal"] = 1;
	["Power Word: Fortitude"] = 1;
	["Power Word: Shield"] = 1;
	["Renew"] = 1;
	["Shadow Protection"] = 1;
	-- Shaman
	["Chain Heal"] = 1;
	["Cure Disease"] = 1;
	["Cure Poison"] = 1;
	["Healing Wave"] = 1;
	["Lesser Healing Wave"] = 1;
	["Water Breathing"] = 1;
	["Water Walking"] = 1;
	-- Warlock
	["Detect Greater Invisibility"] = 1;
	["Detect Invisibility"] = 1;
	["Detect Lesser Invisibility"] = 1;
	["Unending Breath"] = 1;
	-- First Aid
	["Linen Bandage"] = 1;
	["Heavy Linen Bandage"] = 1;
	["Wool Bandage"] = 1;
	["Heavy Wool Bandage"] = 1;
	["Silk Bandage"] = 1;
	["Heavy Silk Bandage"] = 1;
	["Mageweave Bandage"] = 1;
	["Heavy Mageweave Bandage"] = 1;
	["Runecloth Bandage"] = 1;
	["Heavy Runecloth Bandage"] = 1;
	["Anti-Venom"] = 1;
	["Strong Anti-Venom"] = 1
};