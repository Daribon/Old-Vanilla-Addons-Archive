function CardQI_Locals_frFR()
--------------------------------------------------------------------------------------

BINDING_HEADER_CARDQIBINDINGS = "Quick Inspect"
BINDING_NAME_CARDQISCANTARGET = "Scanner la cible"
BINDING_NAME_CARDQIINSPECT = "Inspecter la cible"

CARDQI_MAP = {[0]="|cffff5050Off|r",[1]="|cff00ff00On|r",class="|cfff5f530Class|r"}

--------------------------------------------------------------------------------------
--			Strings
--------------------------------------------------------------------------------------

CARDQI_STRINGS = {
	DESCRIPTION = "Scanne l'équipement d'une cible et affiche le total de ses bonus.",
	RELEASEDATE = "16/09",
	RESET_DISPLAY = "Les options d'affichage ont été réinitialisées.",
	RESET_LIST = "La liste a été réinitialisée.",
	RESET_HOSTILE = "Les options des joueurs ennemis ont été réinitialisées.",
	REMOVE_ERR = "Utilisation : /qi remove numero_de_l'objet",
	REMOVE = "\"%s\" a été retiré de la liste.",
	ADD_ERR = "Utilisation : /qi add nom_de_l'objet",
	RANK = "Affichage du rang",
	BONUS = "Affichage des bonus",
	WEAPONS = "Affichage des armes",
	SPECIAL = "Affichage des objets spéciaux",
	RARITY = "Affichage du compteur d'objets",
	SETS = "Affichage des objets de set",
	CUSTOMLIST = "Liste d'objets personnalisée",
	COMPARE = "Affichage de la tooltip de comparaison",
	FORHOSTILEPLAYERS = "des joueurs ennemis",
	INVALID_OPTION = "\"%s\" n'est pas une option valide.",
	LIST_IS_EMPTY = "Il n'y a aucun objet dans la liste.",
	NO_BONUS_DETECTED = "Aucun bonus détécté.",
	SPEED = "vitesse",
	TEXT_RANK = "rang",
	BLOCK = "bloquer",
	COMPAREBUTTON = "Comparer avec la cible",
}

--------------------------------------------------------------------------------------
--			Commandes slash
--------------------------------------------------------------------------------------

CARDQI_CMD_OPTIONS = {
	{option = "scan", desc = "Scanner la cible", method = "ScanInventory"},
	{option = "display", desc = "Regler les options d'affichage", method = "Display", input = TRUE,
		args = {
			{option = "rank", desc = CARDQI_STRINGS.RANK},
			{option = "bonus", desc = CARDQI_STRINGS.BONUS},
			{option = "weapons", desc = CARDQI_STRINGS.WEAPONS},
			{option = "special", desc = CARDQI_STRINGS.SPECIAL},
			{option = "rarity", desc = CARDQI_STRINGS.RARITY},
			{option = "sets", desc = CARDQI_STRINGS.SETS},
		}},
	{option = "hostile", desc = "Regler les options des joueurs ennemis", method = "Hostile", input = TRUE,
		args = {
			{option = "compare", desc = CARDQI_STRINGS.COMPARE},
			{option = "rank", desc = CARDQI_STRINGS.RANK},
			{option = "bonus", desc = CARDQI_STRINGS.BONUS},
			{option = "weapons", desc = CARDQI_STRINGS.WEAPONS},
			{option = "special", desc = CARDQI_STRINGS.SPECIAL},
			{option = "rarity", desc = CARDQI_STRINGS.RARITY},
			{option = "sets", desc = CARDQI_STRINGS.SETS},
		}},
	{option = "add", desc = "Ajouter un objet à rechercher", method = "AddSpecial"},
	{option = "list", desc = "Voir la liste des objets à rechercher", method = "ListSpecial"},
	{option = "remove", desc = "Retirer un objet de la liste", method = "RemoveSpecial"},
	{option = "reset", desc = "Réinitialiser les options ou la liste d'objets",
		args = {
			{option = "display", desc = "Réinitialiser les options d'affichage", method = "ResetDisplay"},
			{option = "hostile", desc = "Réinitialiser les options des joueurs ennemis", method = "ResetHostile"},
			{option = "list", desc = "Réinitialiser la liste d'objets", method = "ResetList"},
			{option = "all", desc = "Réinitialiser toutes les options", method = "ResetAll"},
		}},
	{option = "compare", desc = CARDQI_STRINGS.COMPARE, method = "Compare", input = TRUE,
		args = {
			{option = "on", desc = "Activer la comparaison"},
			{option = "off", desc = "Désactiver la comparaison"},
			{option = "class", desc = "Activer la comparaison uniquement pour les joueurs de votre classe"},
		}},
}

--------------------------------------------------------------------------------------
--			Patterns des scans
--------------------------------------------------------------------------------------

CardQI_Scan = {
	Misc = {
		desc = {"Divers"},
		Mana5s = {desc = {"Mana/5s"},
			bonus = {"Equipé : Rend (%d+) points de mana toutes les 5 secondes.","%+(%d+) points de mana toutes les 5 sec."}},
		Mana10s = {desc = {"Mana/10s"},
			bonus = {"Equipé : Rend (%d+) points de mana toutes les 10 secondes.","%+(%d+) points de mana toutes les 10 sec."}},
		HP5s = {desc = {"Vie/5s"}, bonus = {"Equipé : Rend (%d+) points de vie toutes les 5 sec"}},
		Fishing = {desc = {"Pêche"}, bonus = {"Equipé : Pêche augmentée de (%d+)"}},
	},
	Stats = {
		desc = {"Statistiques"},
		Spirit = {desc = {"Esprit"}, bonus = {"%+(%d+) Esprit"}, enchant = {"Esprit %+(%d+)"}},
		Intell = {desc = {"Intelligence"}, bonus = {"%+(%d+) Intelligence"}, enchant = {"Intelligence %+(%d+)"}},
		Stam = {desc = {"Endurance"}, bonus = {"%+(%d+) Endurance"}, enchant = {"Endurance %+(%d+)"}},
		Agi = {desc = {"Agilité"}, bonus = {"%+(%d+) Agilité"}, enchant = {"Agilité %+(%d+)"}},
		Str = {desc = {"Force"}, bonus = {"%+(%d+) Force"}, enchant = {"Force %+(%d+)"}},
		Mana = {desc = {"Mana"}, bonus = {"%+(%d+) Mana"}, enchant = {"Mana %+(%d+)"}},
		Armor = {desc = {"Armure"}, bonus = {"Armure : (%d+)","Equipé : %+(%d+) en Armure."}, enchant = {"Armure renforcée %+(%d+)"}},
		HP = {desc = {"Points de vie"}, enchant = {"Points de vie %+(%d+)", "PV %+(%d+)"}},
		AllStats = {desc = {"Toutes les carac."}, enchant = {"Toutes les caractéristiques %+(%d+)"}},
	},
	Spells = {
		desc = {"Sorts"},
		Heal = {desc = {"Soins"}, enchant = {"Sorts de soin %+(%d+)"},
			bonus = {"Equipé : Augmente les effets des sorts de soins de (%d+) au maximum.",
				"Equipé : Augmente les sorts et effets de guérison d'un max%. de (%d+)",
				"%+(%d+) aux sorts de soins"}},
		HealAndDmg = {
			desc = {"Dégâts et soins"},
			bonus = {"Equipé : Augmente les dégâts et les soins prodigués par les sorts et les effets magiques de (%d+) au maximum."}},
		SpellToHit = {desc = {"Chances de toucher avec les sorts","%"},
			bonus = {"Equipé : Augmente vos chances de toucher avec des sorts de (%d+)%%"}},
		SpellCrit = {desc = {"Sorts critiques","%"},
			bonus = {"Equipé : Augmente vos chances d'infliger des coups critiques avec vos sorts de (%d+)%%"}},
		SpellDmg = {desc = {"Dégâts"}, enchant = {"Dégâts des sorts %+(%d+)"}},
		FireDmg = {desc = {"Dégâts de feu"},
			bonus = {"Equipé : Augmente les points de dégâts infligés par vos sorts et effets de Feu de (%d+) au maximum"}},
		FrostDmg = {desc = {"Dégâts de givre"},
			bonus = {"Equipé : Augmente les points de dégâts infligés par les sorts et les effets de givre de (%d+) au maximum"}},
		ShadowDmg = {desc = {"Dégâts d'ombre"},
			bonus = {"Equipé : Augmente les points de dégâts infligés par les sorts et les effets d'ombre de (%d+) au maximum","Equipé : Augmente les dégâts des sorts et effets de l'Ombre de (%d+)"}},
		ArcaneDmg = {desc = {"Dégâts des arcane"},
			bonus = {"Equipé : Augmente les points de dégâts infligés par les effets et les sorts des Arcanes de (%d+) au maximum"}},
	},
	Resist = {
		desc = {"Résistances"},
		ResistAll = {desc = {"Toutes les résistances"}, enchant = {"Toutes les résistances %+(%d+)"}},
		Fire = {desc = {"Feu"},bonus = {"%+(%d+) à la résistance Feu","%+(%d+) Résistance au feu"}, enchant = {"Résistance au feu %+(%d+)"}},
		Nature = {desc = {"Nature"}, bonus = {"%+(%d+) à la résistance Nature"}},
		Frost = {desc = {"Givre"}, bonus = {"%+(%d+) à la résistance Givre"}},
		Arcane = {desc = {"Arcane"}, bonus = {"%+(%d+) à la résistance Arcane"}},
		Shadow = {desc = {"Ombre"}, bonus = {"%+(%d+) à la résistance Ombre"}},
	},
	Combat = {
		desc = {"Combat"},
		Crit = {desc = {"Coups critiques","%"}, bonus = {"Equipé : Augmente vos chances d'infliger un coup critique de (%d+)%%"}},
		Dodge = {desc = {"Esquive","%"}, bonus = {"Equipé : Augmente vos chances d'esquiver une attaque de (%d+)%%"}},
		ToHit = {desc = {"Chances de toucher","%"}, bonus = {"Equipé : Augmente vos chances de toucher de (%d+)%%"}},
		APower = {desc = {"Puissance d'attaque"}, bonus = {"Equipé : %+(%d+) à la puissance d'attaque%."}},
		Def = {desc = {"Défense"}, bonus = {"Equipé : Augmente la défense de %+(%d+)"}},
		Dagger = {desc = {"Dagues"}, bonus = {"Equipé : Dagues augmentées de (%d+)"}},
		Axe = {desc = {"Haches"}, bonus = {"Equipé : Haches augmentées %+(%d+)"}},
		Sword = {desc = {"Epées"}, bonus = {"Equipé : Epées augmentées de (%d+)"}},
	},
}

CARDQI_SCAN_DEFAULT_ITEM_LIST = {"Insigne de l'Alliance","Insigne de la Horde","Carotte et bâton","Montre de lenteur"}
CARDQI_SCAN_SPECIAL_ENCHANTS = {"(Augmentation mineure de vitesse)","(Eperons en mithril)","Equipé : (Immunisé au désarmement)",
	"Augmentation mineure de la (vitesse de la monture)"}
CARDQI_SCAN_WEAPONS  = {
	desc = {"Armes"},
	weaponType = {"(Deux mains)","(A une main)","(Main droite)","(Main gauche)","(A distance)","(Tenu%(e%) en main gauche)",
		"(Armes de jet)"},
	weaponSubType = {"(Masse)","(Epée)","(Dague)","(Bâton)","(Baguette)","(Arme d'hast)","(Canne à pêche)","(Hache)","(Arc)$",
		"(Arbalète)","(Arme de pugilat)","(Arme à feu)","(Bouclier)","(Armes de jet)"},
	speed = {"Vitesse (.+)"},
	dps = {"%((.+) dégâts par seconde%)"},
	block = {"Bloquer : (%d+)"},
	enchant = {"(Croisé)","(Dégâts de l'arme %+%d+)","(Dégâts d'arme %+%d+)","(%+%d+ %(Bêtes%))","(Lunette %(%+%d+ point. de dégâts%))",
		"(Tueur de Démons)","(Arme glacée)"},
}

--------------------------------------------------------------------------------------
end