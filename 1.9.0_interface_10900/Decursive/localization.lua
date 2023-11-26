-------------------------------------------------------------------------------
-- the constants for the mod (non localized)
-------------------------------------------------------------------------------
DCR_VERSION_STRING = "Decursive 1.9.0";
BINDING_HEADER_DECURSIVE = "Decursive";

DCR_MACRO_COMMAND  = "/decursive";
DCR_MACRO_SHOW     = "/dcrshow";

DCR_MACRO_PRADD    = "/dcrpradd";
DCR_MACRO_PRCLEAR  = "/dcrprclear";
DCR_MACRO_PRLIST   = "/dcrprlist";
DCR_MACRO_PRSHOW   = "/dcrprshow";

DCR_MACRO_SKADD    = "/dcrskadd";
DCR_MACRO_SKCLEAR  = "/dcrskclear";
DCR_MACRO_SKLIST   = "/dcrsklist";
DCR_MACRO_SKSHOW   = "/dcrskshow";


DCR_CLASS_DRUID   = 'DRUID';
DCR_CLASS_HUNTER  = 'HUNTER';
DCR_CLASS_MAGE    = 'MAGE';
DCR_CLASS_PALADIN = 'PALADIN';
DCR_CLASS_PRIEST  = 'PRIEST';
DCR_CLASS_ROGUE   = 'ROGUE';
DCR_CLASS_SHAMAN  = 'SHAMAN';
DCR_CLASS_WARLOCK = 'WARLOCK';
DCR_CLASS_WARRIOR = 'WARRIOR';

-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------
DCR_DISEASE = 'Disease';
DCR_MAGIC   = 'Magic';
DCR_POISON  = 'Poison';
DCR_CURSE   = 'Curse';
DCR_CHARMED = 'Charm';

DCR_PET_FELHUNTER = "Felhunter";
DCR_PET_DOOMGUARD = "Doomguard";
DCR_PET_FEL_CAST  = "Devour Magic";
DCR_PET_DOOM_CAST = "Dispel Magic";

DCR_SPELL_CURE_DISEASE        = 'Cure Disease';
DCR_SPELL_ABOLISH_DISEASE     = 'Abolish Disease';
DCR_SPELL_PURIFY              = 'Purify';
DCR_SPELL_CLEANSE             = 'Cleanse';
DCR_SPELL_DISPELL_MAGIC       = 'Dispel Magic';
DCR_SPELL_CURE_POISON         = 'Cure Poison';
DCR_SPELL_ABOLISH_POISON      = 'Abolish Poison';
DCR_SPELL_REMOVE_LESSER_CURSE = 'Remove Lesser Curse';
DCR_SPELL_REMOVE_CURSE        = 'Remove Curse';
DCR_SPELL_PURGE               = 'Purge';
DCR_SPELL_NO_RANK             = '';
DCR_SPELL_RANK_1              = 'Rank 1';
DCR_SPELL_RANK_2              = 'Rank 2';

BINDING_NAME_DCRCLEAN   = "Clean Group";
BINDING_NAME_DCRSHOW    = "Show or hide the afflicted list";

BINDING_NAME_DCRPRADD     = "Add target to priority list";
BINDING_NAME_DCRPRCLEAR   = "Clear the priority list";
BINDING_NAME_DCRPRLIST    = "Print the priority list";
BINDING_NAME_DCRPRSHOW    = "Show or hide the priority list";

BINDING_NAME_DCRSKADD   = "Add target to skip list";
BINDING_NAME_DCRSKCLEAR = "Clear the skip list";
BINDING_NAME_DCRSKLIST  = "Print the skip list";
BINDING_NAME_DCRSKSHOW  = "Show or hide the skip list";

DCR_PRIORITY_LIST  = "Decursive Priority List";
DCR_SKIP_LIST_STR  = "Decursive Skip List";
DCR_SKIP_OPT_STR   = "Decursive Options Menu";
DCR_POPULATE_LIST  = "Quickly populate the Decursive list";
DCR_RREMOVE_ID     = "Remove this player";
DCR_HIDE_MAIN      = "Hide live list";
DCR_RESHOW_MSG     = "To reshow the live list, type /dcrshow";

DCR_PRINT_CHATFRAME = "Print messages in default chat";
DCR_PRINT_CUSTOM    = "Print messages in the window";
DCR_PRINT_ERRORS    = "Print error messages";
DCR_AMOUNT_AFFLIC   = "The amount of afflicted to show : ";
DCR_BLACK_LENGTH    = "Seconds on the blacklist : ";
DCR_SCAN_LENGTH     = "Seconds in between live scans : ";
DCR_ABOLISH_CHECK   = "Check for Abolish before curing";
DCR_BEST_SPELL      = "Always use the highest spell rank.";
DCR_RANDOM_ORDER    = "Cure in a random order";
DCR_CURE_PETS       = "Scan and cure pets";
DCR_IGNORE_STEALTH  = "Ignore Stealthed Units";
DCR_ANCHOR          = "Decursive Text Anchor";


-- $s is spell name
-- $a is affliction name/type
-- $t is target name
DCR_DISPELL_ENEMY    = "Casting '$s' on the enemy!";
DCR_NOT_CLEANED      = "Nothing cleaned";
DCR_CLEAN_STRING     = "Casting $s on $t to remove $a";
DCR_SPELL_FOUND      = "$s spell found!";
DCR_NO_SPELLS        = "No curative spells found!";
DCR_NO_SPELLS_RDY    = "No curative spells are ready to cast!";
DCR_OUT_OF_RANGE     = "$t is out of range and should be cured of $a!";
DCR_IGNORE_STRING    = "$a found on $t... ignoring";

DCR_INVISIBLE_LIST = {
	["Prowl"]       = true,
	["Stealth"]     = true,
	["Shadowmeld"]  = true,
}

-- this causes the target to be ignored!!!!
DCR_IGNORELIST = {
	["Banish"]      = true,
	["Phase Shift"] = true,
};

-- ignore this effect
DCR_SKIP_LIST = {
	["Dreamless Sleep"] = true,
	["Greater Dreamless Sleep"] = true,
	["Mind Vision"] = true,
};

-- ignore the effect bassed on the class
DCR_SKIP_BY_CLASS_LIST = {
	[DCR_CLASS_WARRIOR] = {
		["Ancient Hysteria"]   = true,
		["Ignite Mana"]        = true,
		["Tainted Mind"]       = true,
	};
	[DCR_CLASS_ROGUE] = {
		["Silence"]            = true;
		["Ancient Hysteria"]   = true,
		["Ignite Mana"]        = true,
		["Tainted Mind"]       = true,
	};
	[DCR_CLASS_HUNTER] = {
		["Magma Shackles"]     = true,
	};
	[DCR_CLASS_MAGE] = {
		["Magma Shackles"]     = true,
	};
};

-------------------------------------------------------------------------------
-- German localization
-------------------------------------------------------------------------------
if ( GetLocale() == "deDE" ) then

	DCR_DISEASE = 'Krankheit';
	DCR_MAGIC = 'Magie';
	DCR_POISON = 'Gift';
	DCR_CURSE = 'Fluch';

	DCR_PET_FELHUNTER = "Teufelsj\195\164ger";
	DCR_PET_DOOMGUARD = "Doomguard";
	DCR_PET_FEL_CAST  = "Magie verschlingen";
	DCR_PET_DOOM_CAST = "Magiebannung";

	DCR_SPELL_CURE_DISEASE        = 'Krankheit heilen';
	DCR_SPELL_ABOLISH_DISEASE     = 'Krankheit aufheben';
	DCR_SPELL_PURIFY              = 'L\195\164utern';
	DCR_SPELL_CLEANSE             = 'Reinigung des Glaubens';
	DCR_SPELL_DISPELL_MAGIC       = 'Magiebannung';
	DCR_SPELL_CURE_POISON         = 'Vergiftung heilen';
	DCR_SPELL_ABOLISH_POISON      = 'Vergiftung aufheben';
	DCR_SPELL_REMOVE_LESSER_CURSE = 'Geringen Fluch aufheben';
	DCR_SPELL_REMOVE_CURSE        = 'Fluch aufheben';
	DCR_SPELL_PURGE               = 'Reinigen';
	DCR_SPELL_RANK_1              = 'Rang 1';
	DCR_SPELL_RANK_2              = 'Rang 2';


	BINDING_NAME_DCRCLEAN = "Reinige Gruppe";

	BINDING_NAME_DCRPRADD     = "Ziel zur Priorit\195\164tenliste hinzufügen";
	BINDING_NAME_DCRPRCLEAR   = "Priorit\195\164tenliste leeren";
	BINDING_NAME_DCRPRLIST    = "Priorit\195\164tenliste ausgeben";
	BINDING_NAME_DCRPRSHOW    = "Zeige/Verstecke die Priorit\195\164tenliste UI";
	
	BINDING_NAME_DCRSKADD   = "Ziel zur Ignorierliste hinzufügen";
	BINDING_NAME_DCRSKCLEAR = "Ignorierliste leeren";
	BINDING_NAME_DCRSKLIST  = "Igorierliste ausgeben";
	BINDING_NAME_DCRSKSHOW  = "Zeige/Verstecke die Ignorierliste UI";

	DCR_PRIORITY_LIST  = "Decursive Priorit\195\164tsliste";
	DCR_SKIP_LIST_STR  = "Decursive Ignorierliste";
	DCR_POPULATE_LIST  = "Schnellbest\195\188cken der Decursive Liste";
	DCR_RREMOVE_ID     = "Entferne diesen Spieler";
	DCR_HIDE_MAIN      = "Live Liste verstecken";

	-- $s is spell name
	-- $a is affliction name/type
	-- $t is target name
	DCR_DISPELL_ENEMY    = "Kanalisiere '$s' auf den Gegner!";
	DCR_NOT_CLEANED      = "Nichts zu reinigen";
	DCR_CLEAN_STRING     = "Kanalisiere $s auf $t um $a zu entfernen";
	DCR_SPELL_FOUND      = "Spruch $s gefunden!";
	DCR_NO_SPELLS        = "Keine kurierenden Spr\195\188che gefunden!";
	DCR_NO_SPELLS_RDY    = "Keine Spr\195\188che bereit!";
	DCR_OUT_OF_RANGE     = "$t ist ausser Reichweite und sollte von $a geheilt werden!";
	DCR_IGNORE_STRING    = "$a auf $t gefunden... Ignoriert";


	DCR_IGNORELIST = {
		["Verbannen"] = true,
		["Phase Shift"] = true,
	};

	DCR_SKIP_LIST = {
		["Dreamless Sleep"] = true,
		["Greater Dreamless Sleep"] = true,
		["Mind Vision"] = true,
	};

	DCR_SKIP_BY_CLASS_LIST = {
	};
	-- for cut and paste ease
	-- DCR_CLASS_DRUID
	-- DCR_CLASS_HUNTER
	-- DCR_CLASS_MAGE
	-- DCR_CLASS_PALADIN
	-- DCR_CLASS_PRIEST
	-- DCR_CLASS_ROGUE
	-- DCR_CLASS_SHAMAN
	-- DCR_CLASS_WARLOCK
	-- DCR_CLASS_WARRIOR

-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------
elseif ( GetLocale() == "frFR" ) then

	DCR_DISEASE = 'Maladie';
	DCR_MAGIC   = 'Magie';
	DCR_POISON  = 'Poison';
	DCR_CURSE   = 'Mal\195\169diction';

	DCR_PET_FELHUNTER = "Felhunter";
	DCR_PET_DOOMGUARD = "Doomguard";
	DCR_PET_FEL_CAST  = "Festin magique";
	DCR_PET_DOOM_CAST = "Dissiper Magie";

	DCR_SPELL_CURE_DISEASE        = 'Gu\195\169rison des maladies';
	DCR_SPELL_ABOLISH_DISEASE     = 'Abolir maladie';
	DCR_SPELL_PURIFY              = 'Purification';
	DCR_SPELL_CLEANSE             = 'Epuration';
	DCR_SPELL_DISPELL_MAGIC       = 'Dissiper la magie';
	DCR_SPELL_CURE_POISON         = 'Gu\195\169rison du poison';
	DCR_SPELL_ABOLISH_POISON      = 'Abolir le Poison';
	DCR_SPELL_REMOVE_LESSER_CURSE = 'D\195\169livrance de la mal\195\169diction mineure';
	DCR_SPELL_REMOVE_CURSE        = 'D\195\169livrance de la mal\195\169diction';
	DCR_SPELL_PURGE               = 'Expiation';
	DCR_SPELL_RANK_1              = 'Rang 1';
	DCR_SPELL_RANK_2              = 'Rang 2';

	BINDING_NAME_DCRCLEAN     = "Nettoyage des poisons et maledictions";

	-- $s is spell name
	-- $a is affliction name/type
	-- $t is target name
	DCR_DISPELL_ENEMY    = "Lance '$s' sur l'ennemie!";
	DCR_NOT_CLEANED      = "Rien a nettoyer";
	DCR_CLEAN_STRING     = "Lance $s sur $t pour enlever $a.";
	DCR_SPELL_FOUND      = "$t trouv\195\169";
	DCR_NO_SPELLS        = "Aucune antidote trouv\195\169";
	DCR_NO_SPELLS_RDY    = "Auncune antidotes sont pr\195\170tes a utiliser";
	DCR_OUT_OF_RANGE     = "$t est hors de port\195\169e et devrait \195\170tre soign\195\169 de $a!";
	DCR_IGNORE_STRING    = "$a trouve sur $t est ignor\195\169";

	DCR_IGNORELIST = {
		["Bannir"] = true,
	};

	DCR_SKIP_LIST = {
	};

	DCR_SKIP_BY_CLASS_LIST = {
	};
	-- for cut and paste ease
	-- DCR_CLASS_DRUID
	-- DCR_CLASS_HUNTER
	-- DCR_CLASS_MAGE
	-- DCR_CLASS_PALADIN
	-- DCR_CLASS_PRIEST
	-- DCR_CLASS_ROGUE
	-- DCR_CLASS_SHAMAN
	-- DCR_CLASS_WARLOCK
	-- DCR_CLASS_WARRIOR
end




