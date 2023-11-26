--[[
--	DamageMeters Localization Data (FRENCH)

--  Initial translation by Kurty and eXess

-- Version : French ( by Sasmira )
-- Last Update : 06/28/2005

--]]

if ( GetLocale() == "frFR" ) then

-- General --
DamageMeters_PRINTCOLOR = "|cFF8F8FFF"

-- Bindings --
BINDING_HEADER_DAMAGEMETERSHEADER 		= "DamageMeters";
BINDING_NAME_DAMAGEMETERS_TOGGLESHOW		= "Afficher [ON|OFF]";
BINDING_NAME_DAMAGEMETERS_CYCLEQUANT		= "Cat\195\169gorie suivante";
BINDING_NAME_DAMAGEMETERS_CYCLEQUANTBACK	= "Cat\195\169gorie pr\195\169c\195\169dente";
BINDING_NAME_DAMAGEMETERS_CLEAR			= "Effacer liste";
BINDING_NAME_DAMAGEMETERS_TOGGLEPAUSED		= "Analyse [ON|OFF]";
BINDING_NAME_DAMAGEMETERS_SHOWREPORTFRAME 	= "Fen\195\170tre de Rapport";
BINDING_NAME_DAMAGEMETERS_SWAPMEMORY		= "Echanger m\195\169moire";
BINDING_NAME_DAMAGEMETERS_TOGGLESHOWMAX		= "Voir Barre Max";

-- Help --
DamageMeters_helpTable = {
		"Les commandes qui suivent peuvent \195\170tre entr\195\169es dans la console:",
		"/dmhelp : Liste des commandes disponibles avec /dm (Damage Meters).",
		"/dmshow : Affiche la fen\195\170tre de DamageMeters.  Notez que DM continue l\226\128\153analyse m\195\170me si la fen\195\170tre est cach\195\169e.",
		"/dmhide : Cache la fen\195\170tre de DamageMeters.",
		"/dmclear [#] : Efface la liste en partant du bas (# d\195\169finie le nombre).  Ne pas sp\195\169cifier # pour effacer toute la liste.",
		"/dmreport [c/s/p/r/w/h/g[#]] [nom-du-joueur/nom-du-canal] - Affiche un rapport des donn\195\169es actuelles.  c pour console, s pour dire (g\195\169n\195\169ral), p pour canal de groupe, r pour canal de raid, w pour chuchoter au joueur 'nom-du-joueur', g pour canal de guilde, et h pour le canal 'nom-du-canal'. En majuscule, inverse l\226\128\153ordre des donn\195\169es envoy\195\169es.  Si un nombre # est sp\195\169cifi\195\169, envoie seulement les donn\195\169es de # joueurs list\195\169s (en partant du haut).",
		"/dmsort [#] - D\195\169finie l\226\128\153ordre de tri.  Ne pas sp\195\169cifier # pour voir les options disponibles.",
		"/dmcount [#] - D\195\169finie le nombre de place dans la liste.  Ne pas sp\195\169cifier pour avoir le maximum possible.",
		"/dmsave - Sauvegarde la table actuelle en interne.",
		"/dmrestore - Restaure une table pr\195\169c\195\169demment sauvegard\195\169e, \195\169crasant toutes nouvelles donn\195\169es.",
		"/dmmerge - Fusionne une table pr\195\169c\195\169demment sauvegard\195\169e avec les donn\195\169es existantes.",
		"/dmswap - Echange une table pr\195\169c\195\169demment sauvegard\195\169e avec la table actuelle",
		"/dmresetpos - Replace la fen\195\170tre \195\160 sa position initiale (pratique si vous la perdez).",
		"/dmtext 0/<[n][p][v]> - D\195\169termine quels textes doivent etre affich\195\169s dans la barre. n - Nom du joueur. p - Pourcentage. v - Valeur.",
		"/dmcolor # - D\195\169finie la couleur des barres. Ne pas sp\195\169cifier # pour voir les options disponibles.",
		"/dmquant # - D\195\169termine le nombre de barre affich\195\169es. Ne pas sp\195\169cifier # pour voir les options disponibles.",
		"/dmvisinparty [y/n] - D\195\169termine si la fen\195\170tre ne sera affich\195\169e que en groupe/raid.  y - Oui. n - Non.",
		"/dmautocount # - Si # est plus grand que z\195\169ro, la taille de la fen\195\170tre sera automatiquement adapt\195\169e au nombre # de barres affich\195\169es.  Si # est a z\195\169ro, la fonction est desactiv\195\169e.",
		"/dmlistbanned - Liste toutes les sources de d\195\169gats bannies.",
		"/dmclearbanned - Efface la liste de toutes les sources de d\195\169gats bannis",
		"/dmsync - Synchronise vos donn\195\169es avec celles des autres utilisateurs du canal de synchro. (Appel\195\169 dmsyncsend et dmsyncrequest.)",
		"/dmsyncchan - D\195\169termine le nom du canal pour la synchronisation.",
		"/dmsyncsend - Envoie les information de synchro sur le canal de synchro.",
		"/dmsyncrequest - Envoie une requ\195\170te pour un dmsync automatique aux autres personnes utilisant le m\195\170me canal de synchro.",
		"/dmsyncclear - Envoie une requ\195\170te \195\160 tout les utilisateur du canal de synchro pour effacer les donn\195\169es.",
		"/dmpop - Affiche les membres de groupe/raid (sans effacer les données existantes).",
		"/dmlock - Bloque ou d\195\169bloque la liste. Aucune personne ne peut \195\170tre ajout\195\169e \195\160 une liste bloqu\195\169e.",
		"/dmpause - Stopper ou reprendre l\226\128\153analyse.",
		"/dmlockpos - Bloque ou d\195\169bloquer la position de la fen\195\170tre.",
		"/dmgrouponly - Bloque ou d\195\169bloque la fonction -Membres du groupe seulement- (Votre familier est toujours pris en compte).",
		"/dmaddpettoplayer - Cumule les donn\195\169es de votre familier aux votres (m\195\170me commande pour dissocier le familier de vos donn\195\169es).",
		"/dmresetoncombat - Efface la liste (et les donn\195\169es donc) au d\195\169but du combat (m\195\170me commande pour laisser les donn\195\169es se cumuler).",
		"/dmversion - Affiche le numéro de version.",
		"/dmtotal - Affiche la fen\195\170tre de Total.",
		"/dmshowmax - Affiche le nombre maximum de barres. (m\195\170me commande pour annuler)"
};

-- Filters --
DamageMeters_Filter_STRING1 = "Membres du Groupe";
DamageMeters_Filter_STRING2 = "Tous les Alli\195\169s";

-- Relationships --
DamageMeters_Relation_STRING = {
		"Moi M\195\170me",
		"Familier",
		"Groupe",
		"Alli\195\169"};

-- Color Schemes -- 
DamageMeters_colorScheme_STRING = {
		"Par Status",
		"Par Couleur de Classes"};

-- Quantities -- 
DamageMeters_Quantity_STRING = {
		"D\195\169g\195\162ts faits",
		"Soins faits",
		"D\195\169g\195\162ts re\195\167us",
		"Soins re\195\167us",
		"Temps mort",
		"DPS"};

-- Sort --
DamageMeters_Sort_STRING = {
		"D\195\169croissant", 
		"Croissant",
		"Alphab\195\169tique"};

-- Class Names --
DamageMeters_classTranslationTable = {
			["CHASSEUR"] = "HUNTER",
			["DEMONISTE"] = "WARLOCK",
			["PRETRE"] = "PRIEST",
			["PALADIN"] = "PALADIN",
			["MAGE"] = "MAGE",
			["VOLEUR"] = "ROGUE",
			["DRUIDE"] = "DRUID",
			["CHAMAN"] = "SHAMAN",
			["GUERRIER"] = "WARRIOR",
		};
function DamageMeters_GetClassColor(className)
	local lookup = DamageMeters_classTranslationTable[string.upper(className)];
	if (lookup) then
		return RAID_CLASS_COLORS[ lookup ];	
	end

	-- This is a workaround because we had trouble doing a string compare
	-- for words with special characters.
	if ("P" == string.sub(className, 1, 1)) then
		return RAID_CLASS_COLORS["PRIEST"];
	else
		return RAID_CLASS_COLORS["WARLOCK"];
	end
end

-- Errors --
DM_ERROR_INVALIDARG = "DamageMeters: Argument(s) invalide(s).";
DM_ERROR_MISSINGARG = "DamageMeters: Argument(s) manquant(s).";
DM_ERROR_NOSAVEDTABLE = "DamageMeters: Aucune table sauvegard\195\169e.";
DM_ERROR_BADREPORTTARGET = "DamageMeters: Cible du rapport invalide = ";
DM_ERROR_MISSINGWHISPERTARGET = "DamageMeters: Cible du whisper manquante.";
DM_ERROR_MISSINGCHANNEL = "DamageMeters: Canal sp\195\169cifi\195\169 mais aucun num\195\169ro donn\195\169.";
DM_ERROR_NOSYNCCHANNEL = "DamageMeters: Canal de Synchro doit \195\170tre sp\195\169cifi\195\169 avec /dmsyncchan avant d\226\128\153utiliser /dmsync.";
DM_ERROR_JOINSYNCCHANNEL = "DamageMeters: Vous devez joindre le canal de synchro ('%s') avant de pouvoir utiliser /dmsync.";
DM_ERROR_SYNCTOOSOON = "DamageMeters: Requ\195\170te de synchro trop tot apr\195\168s la derni\195\168re; commande ignor\195\169e.";
DM_ERROR_POPNOPARTY = "DamageMeters: Ne peut pas renseigner la table; Il faut \195\170tre dans un groupe ou en raid.";
DM_ERROR_NOROOMFORPLAYER = "DamageMeters: Ne peut pas fusionner les donn\195\169es des familiers avec les autres joueurs car la liste est peut-\195\170tre pleine.";

-- Messages --
DM_MSG_SETQUANT = "DamageMeters: Nouvelle cat\195\169gorie d\226\128\153analyse = ";
DM_MSG_CURRENTQUANT = "DamageMeters: Nombre de place actuelle = ";
DM_MSG_CURRENTSORT = "DamageMeters: Classement actuel = ";
DM_MSG_SORT = "DamageMeters: Configuration du tri dans l\226\128\153ordre ";
DM_MSG_CLEAR = "DamageMeters: Effacement de %d \195\160 %d.";
DM_MSG_REMAINING = "DamageMeters: %d objets restants.";
DM_MSG_REPORTHEADER = "Damage Meters: <%s> rapport de %d/%d sources:";
DM_MSG_SETCOUNTTOMAX = "DamageMeters: Aucun nombre sp\195\169cifi\195\169, configuration au max.";
DM_MSG_SETCOUNT = "DamageMeters: Nombre de place passe \195\160 ";
DM_MSG_RESETFRAMEPOS = "DamageMeters: Remise \195\160 z\195\169ro de la position.";
DM_MSG_SAVE = "DamageMeters: Sauvegarde de la table.";
DM_MSG_RESTORE = "DamageMeters: Chargement de la table sauvegard\195\169e.";
DM_MSG_MERGE = "DamageMeters: Fusion de la table sauvegard\195\169e avec l\226\128\153actuelle.";
DM_MSG_SWAP = "DamageMeters: Echange de la table normale (%d) et de la table sauvegard\195\169e (%d).";
DM_MSG_SETCOLORSCHEME = "DamageMeters: Couleurs des barres ";
DM_MSG_TRUE = "Vrai";
DM_MSG_FALSE = "Faux";
DM_MSG_SETVISINPARTY = "DamageMeters: Visible-seulement-en-groupe est configur\195\169 \195\160 ";
DM_MSG_SETAUTOCOUNT = "DamageMeters: Configuration de la limite auto \195\160 ";
DM_MSG_LISTBANNED = "DamageMeters: Liste des sources de d\195\169g\195\162ts bannies:";
DM_MSG_CLEARBANNED = "DamageMeters: Effacement de toutes les sources de d\195\169g\195\162ts bannies.";
DM_MSG_HOWTOSHOW = "DamageMeters: Fen\195\170tre masqu\195\169e.  Utilisez /dmshow pour la faire apparaitre \195\160 nouveau.";
DM_MSG_SYNCCHAN = "DamageMeters: Le nom du canal de synchro est ";
DM_MSG_SYNCREQUESTACK = "DamageMeters: Requ\195\170te de synchro faite par le joueur ";
DM_MSG_SYNC = "DamageMeters: Envoie des informations de synchro.";
DM_MSG_LOCKED = "DamageMeters: Liste bloqu\195\169e.";
DM_MSG_NOTLOCKED = "DamageMeters: Liste d\195\169bloqu\195\169e.";
DM_MSG_PAUSED = "DamageMeters: Analyse stopp\195\169e.";
DM_MSG_UNPAUSED = "DamageMeters: Analyse reprise.";
DM_MSG_POSLOCKED = "DamageMeters: Position bloqu\195\169e.";
DM_MSG_POSNOTLOCKED = "DamageMeters: Position d\195\169bloqu\195\169e.";
DM_MSG_CLEARRECEIVED = "DamageMeters: Requ\195\170te d\226\128\153effacement re\195\167u du joueur ";
DM_MSG_ADDINGPETTOPLAYER = "DamageMeters: Traitement des donn\195\169es du familier comme \195\169tant les votre.";
DM_MSG_NOTADDINGPETTOPLAYER = "DamageMeters: Traitement des donn\195\169es du familier s\195\169par\195\169ment des votre.";
DM_MSG_PETMERGE = "DamageMeters: Fusion des informations du familier de (%s) avec les votre.";
DM_MSG_RESETWHENCOMBATSTARTSCHANGE = "DamageMeters: Effacer la liste en d\195\169but de combat = ";
DM_MSG_COMBATDURATION = "Dur\195\169e du combat = %.2f secondes.";
DM_MSG_RECEIVEDSYNCDATA = "DamageMeters: Donn\195\169es de synchro recues de la part de %s.";
DM_MSG_TOTAL = "TOTAL";
DM_MSG_VERSION = "DamageMeters Version %s Actif.";
DM_MSG_REPORTHELP = "La commande /dmreport est compos\195\169e de 3 parties:\n\n1) Le canal de destination.  Cela peut \195\170tre une des lettres qui suit :\n  c - Console (pour vous uniquement).\n  s - Dire\n  p - Groupe\n  r - Raid\n  g - Guilde\n  h - Canal de discussion. Exemple: /dmreport h mychannel\n  w - Chuchoter au joueur. Exemple: /dmreport w dandelion\n  f - Fen\195\170tre de chat: Affiche le rapport dans cette fen\195\170tre.\n\nSi la lettre est en minuscule, le rapport sera dans l'ordre inverse (plus petit au plus grand).\n\n2) Optionellement, la limite du nombre de personne.  Ce nombre est a mettre juste apres la lettre du canal de destination.\nExemple: /dmreport p5.\n\n3) Par d\195\169faut, les rapports affichent seulement la cat\195\169gorie actuelle.  Si le mot -total- est specifi\195\169 devant la lettre de destination, le rapport affichera le total de toutes les cat\195\169gories. les rapports -Total- sont format\195\169s pour \195\170tre facilement copi\195\169-coll\195\169 dans un fichier texte, ce qui est donc tr\195\169s utile pour la fen\195\170tre de destination.\nExemple: /dmreport total f\n\nExemple: Chuchoter au joueur Dandelion le rapport des 3 premieres personnes dans la liste :\n/dmreport w3 dandelion";
DM_MSG_COLLECTORS = "Collecteurs de donn\195\169es: (%s)";
DM_MSG_ACCUMULATING = "DamageMeters: Accumulation des donn\195\169es dans la m\195\169moire.";
DM_MSG_REPORTTOTALDPS = "Total = %.1f (%.1f visible)";
DM_MSG_REPORTTOTAL = "Total = %d (%d visible)";
DM_MSG_SYNCMSG = "[%s] envoie: %s";
DM_MSG_MEMCLEAR = "DamageMeters: Table sauvegard\195\169e effac\195\169e.";
DM_MSG_MAXBARS = "DamageMeters: Voir Barres Max d\195\169finis \195\160 %s.";
DM_MSG_LEADERREPORTHEADER = "DamageMeters: Rapport Leaders sur %d/%d Sources:\n #";
DM_MSG_FULLREPORTHEADER = "DamageMeters: Rapport Compl\195\170t sur %d/%d Sources:\n\nJoueurs      Dommage      Soins      Endommag\195\169      Soign\195\169      Coups      Critiques\n_______________________________________________________________________________";

--[[ Note: This is only to help construct the DM_MSG_REPORTHELP string.
The /dmreport command consists of three parts:

1) The destination character.  This can be one of the following letters:
  c - Console (only you can see it).
  s - Say
  p - Party chat
  r - Raid chat
  g - Guild chat
  h - Chat cHannel. /dmreport h mychannel
  w - Whisper to player.  /dmreport w dandelion
  f - Frame: Shows the report in this window.

If the letter is lower case the report will be in reverse order (lowest to highest).

2) Optionally, the number of people to limit it to.  This number goes right after the destination character.
Example: /dmreport p5

3) By default, reports are on the currently visible quantity only.  If the word 'total' is specified before the destination character, though, the report will be on the totals for every quantity. 'Total' reports are formatted so that they look good when cut-and-paste into a text file, and so work best with the Frame destination.
Example: /dmreport total f

Example: Whisper to player "dandelion" the top three people in the list:
/dmreport w3 dandelion
]]--

-- Menu Options --
DM_MENU_CLEAR = "Effacer la Liste";
DM_MENU_RESETPOS = "Position initiale";
DM_MENU_HIDE = "Cacher";
DM_MENU_SHOW = "Afficher";
DM_MENU_VISINPARTY = "Afficher seulement en groupe";
DM_MENU_REPORT = "Rapport";
DM_MENU_BARCOUNT = "Nombre de place";
DM_MENU_AUTOCOUNTLIMIT = "Limite auto";
DM_MENU_SORT = "Trier par Ordre";
DM_MENU_VISIBLEQUANTITY = "Cat\195\169gorie";
DM_MENU_COLORSCHEME = "Couleurs des barres";
DM_MENU_MEMORY = "M\195\169moriser";
DM_MENU_SAVE = "Sauver";
DM_MENU_RESTORE = "Restaurer";
DM_MENU_MERGE = "Combiner";
DM_MENU_SWAP = "Echanger";
DM_MENU_DELETE = "Effacer";
DM_MENU_BAN = "Bannir";
DM_MENU_CLEARABOVE = "Effacer au dessus";
DM_MENU_CLEARBELOW = "Effacer en dessous";
DM_MENU_LOCK = "Bloquer la Liste";
DM_MENU_UNLOCK = "D\195\169bloquer Liste";
DM_MENU_PAUSE = "Stopper l\'analyse";
DM_MENU_UNPAUSE = "Reprendre analyse";
DM_MENU_LOCKPOS = "Bloquer position";
DM_MENU_UNLOCKPOS = "D\195\169bloquer Position";
DM_MENU_GROUPMEMBERSONLY = "Membre du groupe uniquement";
DM_MENU_ADDPETTOPLAYER = "Cumuler votre familier \195\160 vos coups";
DM_MENU_TEXT = "Texte affich\195\169";
DM_MENU_TEXTRANK = "Rang";
DM_MENU_TEXTNAME = "Nom";
DM_MENU_TEXTPERCENTAGE = "Pourcentage";
DM_MENU_TEXTPERCENTAGELEADER = "% du Leader";
DM_MENU_TEXTVALUE = "Valeur";
DM_MENU_SETCOLORFORALL = "D\195\169finie la couleur pour tous";
DM_MENU_DEFAULTCOLORS = "Couleurs par d\195\169faut";
DM_MENU_RESETONCOMBATSTARTS = "Liste r\195\169initialis\195\169e \195\160 chaque combat";
DM_MENU_REFRESHBUTTON = "Rafraichir";
DM_MENU_TOTAL = "Total";
DM_MENU_CHOOSEREPORT = "Choisir Rapport";
-- Note reordered this list in version 2.2.0
DM_MENU_REPORTNAMES = {"Fen\195\170tre", "Console", "Dire", "Groupe", "Raid", "Guilde"};
DM_MENU_TEXTCYCLE = "Cycle";
DM_MENU_QUANTCYCLE = "Cycle";
DM_MENU_HELP = "Aide";
DM_MENU_ACCUMULATEINMEMORY = "Accumuler les donn\195\169es";
DM_MENU_POSITION = "Position";
DM_MENU_RESIZELEFT = "Ajuster \195\160 Gauche";
DM_MENU_RESIZEUP = "Ajuste Vers le Haut";
DM_MENU_SHOWMAX = "Afficher Barres Max";
DM_MENU_SHOWTOTAL = "Afficher le Total";
DM_MENU_LEADERS = "Leaders";

-- Misc
DM_CLASS = "Classe"; -- The word for player class, like Druid or Warrior.
DM_TOOLTIP = "\nTemps mort = %.1fs\nStatus = %s";
DM_YOU = "Moi M\195\170me"
DM_CRITSTR = "Critique";

--[[
-------------------------------------------------------------------------------
THIS IS WHERE COMBAT MESSAGES GET PARSED
-------------------------------------------------------------------------------

Notes:
- Using %a+ for player names is very risk as totems are pets and have spaces in their names.
- Leave .'s off the end as a rule to save us from having to put in (%d absorbed) cases.

-----------------
THE EVENT MATRIX:
-----------------
					(S)Self		(E)Pet		(P)Party		(F)Friendly
01 Hit				x			x			x				x
02 Crit				x			x			0				x
03 Spell			x			x			x				x
04 SpellCrit		x			x			x				x
05 Dot				x			A			A				A
06 DmgShield		x			B			B				B
07 SplitDmg						0			0				0

10 IncHit			x			x			x				x
11 IncCrit			x			x			x				x
12 IncSpell			x			x			x				x
13 IncSpellCrit		x			0			x				x
14 IncDot			x			x			x				x

20 Heal				x			0			x				x
21 HealCrit			x			0			x				x
22 Hot				x			0			x				x
23 NDB				-			0			0				x
24 JD				-			0			0				0


x : Confirmed
0 : Case exists, but unconfirmed.
- : Irrelevant.
A - Ambiguous: Dots messages come from the creature being hit, not the player.
B - Damage shield messags are only self and "other".
NDB - "Night Dragon's Blossom" : English special-case because of the "'s".
JD - "Julie's Dagger" : English special-case because of the "'s".

]]--

function DamageMeters_ParseMessage(arg1, event)
	local creatureName;
	local damage;
	local spell;
	local spell2;
	local petName;
	local partialBlock;
	local damageType;

	---------------------
	-- DAMAGE MESSAGES --
	---------------------

    -- In French : the order in which the variables spell and damage appear on that line must match the order in which those things occur in the sentence
    
	-- English: The following require special cases in English:
	-- Ramstein's Lightning Bolts - the 's breaks the patterns.  Known bug, as-is.

	if(	event == "CHAT_MSG_COMBAT_SELF_HITS" ) then
		for creatureName, damage in string.gfind(arg1, "Vous touchez (.+) avec un coup critique et infligez (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S02 Self Crit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
		for creatureName, damage in string.gfind(arg1, "Vous touchez (.+) et infligez (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S01 Self Hit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
	end

	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" )then
		for spell, creatureName, damage in string.gfind(arg1, "Votre (.+) touche (.+) avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S04 Self Spell Crit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, "Votre (.+) touche (.+) et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S03 Self Spell Hit", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
	end

	if ( event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" ) then	
		for spell, damage, damageType, creatureName in string.gfind(arg1, "Votre (.+) inflige (%d+) points de d\195\169g\195\162ts de (.+) \195\160 (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "S05 Self DOT", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end		
		for spell, playerName, creatureName, damage, damageType in string.gfind(arg1, "(.+) de (.+) inflige \195\160 (.+) (%d+) points de d\195\169g\195\162ts de (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "F05 Friendly DOT", event);
			DamageMeters_AddDamage(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end	
	end

	if (event == "CHAT_MSG_COMBAT_PARTY_HITS" or
		event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS" or
		event == "CHAT_MSG_COMBAT_PET_HITS") then

		local relationship = DamageMeters_Relation_PARTY;
		local relationshipName = "P";
		if (event == "CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS") then
			relationship = DamageMeters_Relation_FRIENDLY;
			relationshipName = "F";
		elseif (event == "CHAT_MSG_COMBAT_PET_HITS") then
			relationship = DamageMeters_Relation_PET;
			relationshipName = "E";
		end
			
		for playerName, creatureName, damage in string.gfind(arg1, "(.+) de (.+) touche (.+) pour (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, relationshipName.."01 Hit", event);
			DamageMeters_AddDamage(playerName, damage, DM_HIT, relationship, "[Melee]");
			return;
		end
		for playerName, creatureName, damage in string.gfind(arg1, "(.+) touche (.+) avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, relationshipName.."02 Crit", event);
			DamageMeters_AddDamage(playerName, damage, DM_CRIT, relationship, "[Melee]");
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_PARTY_DAMAGE" or
		event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE" or
		event == "CHAT_MSG_SPELL_PET_DAMAGE") then

		local relationship = DamageMeters_Relation_PARTY;
		local relationshipName = "P";
		if (event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE") then
			relationship = DamageMeters_Relation_FRIENDLY;
			relationshipName = "F";
		elseif (event == "CHAT_MSG_SPELL_PET_DAMAGE") then
			relationship = DamageMeters_Relation_PET;
			relationshipName = "E";
		end

		for spell, playerName, creatureName, damage in string.gfind(arg1, "(.+) de (.+) touche (.+) pour (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version		
			DM_CountMsg(arg1, relationshipName.."03 Spell", event);
			DamageMeters_AddDamage(playerName, damage, DM_HIT, relationship, spell);
			return;
		end
		for spell, playerName, creatureName, damage in string.gfind(arg1, "(.+) touche (.+) avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, relationshipName.."04 SpellCrit", event);
			DamageMeters_AddDamage(playerName, damage, DM_CRIT, relationship, spell);
			return;
		end

		-- For soul link
		-- SPELLSPLITDAMAGEOTHEROTHER
		--! todo SPELLSPLITDAMAGEOTHERSELF
		--! todo SPELLSPLITDAMAGESELFOTHER
		for creatureName, spell, playerName, damage in string.gfind(arg1, "(.+)'s (.+) causes (.+) (%d+) damage") do
			DM_CountMsg(arg1, relationshipName.."07 SplitDmg", event);
			DamageMeters_AddDamage(playerName, damage, DM_DOT, relationship, spell);
			return;
		end
	end

	-- Damage Shields --

	if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF") then
		for damage, damageType, creatureName in string.gfind(arg1, "Vous renvoyez (%d+) points de d\195\169g\195\162ts de (.+) \195\160 (.+).") do
			DM_CountMsg(arg1, "S06 DmgShield", event);
			DamageMeters_AddDamage(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, "[DmgShield]");
			return;
		end
	end
	if (event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_OTHERS") then
		for playerName, damage, damageType, creatureName in string.gfind(arg1, "(.+) renvoie (%d+) points de d\195\169g\195\162ts de (.+) sur (.+).") do
			DM_CountMsg(arg1, "F06 DmgShield", event);
			DamageMeters_AddDamage(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, "[DmgShield]");
			return;
		end
	end

	------------------------------
	-- DAMAGE-RECEIVED MESSAGES --
	------------------------------

	-- TODO: Reflected spells.  "you are affected by YOUR spell."

	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS") then
		for creatureName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S11 IncCrit", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
		for creatureName, damage in string.gfind(arg1, "(.+) vous touche et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S10 IncHit", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end

		-- These are for your pet:
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) touche (.+) avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "E11 IncCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PET, "[Melee]");
			return;
		end
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) touche (.+) et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "E10 IncHit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PET, "[Melee]");
			return;
		end
	end

	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS") then
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) touche (.+) avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "P11 IncCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PARTY, "[Melee]");
			return;
		end
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) touche (.+) et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "P10 IncHit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PARTY, "[Melee]");
			return;
		end
	end
	if (event == "CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS" or
		event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS") then
		for creatureName, damage in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S10 IncHit PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end
		for creatureName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "S11 IncCrit PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, "[Melee]");
			return;
		end

		for creatureName, playerName, damage in string.gfind(arg1, "(.+) touche (.+) avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "F11 IncCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, "[Melee]");
			return;
		end
		for creatureName, playerName, damage in string.gfind(arg1, "(.+) touche (.+) et inflige (%d+) points de d\195\169g\195\162ts.") do
			DM_CountMsg(arg1, "F10 IncHit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, "[Melee]");
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE") then
		for spell, creatureName, damage in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "S12 IncSpell", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "S13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end

		for spell, creatureName, playerName, damage in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "E12 IncSpell", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PET, spell);
			return;
		end
		for spell, creatureName, playerName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "E13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PET, spell);
			return;
		end
	end
	
	if (event == "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") then
		for spell, creatureName, playerName, damage in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "P12 IncSpell", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_PARTY, spell);
			return;
		end
		for spell, creatureName, playerName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "P13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_PARTY, spell);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") then
			for spell, creatureName, playerName, damage in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "F12 IncSpell", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for spell, creatureName, playerName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "F13 IncSpellCrit", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE") then
		for spell, creatureName, damage in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "S12 IncSpell PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, creatureName, damage in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "S13 IncSpellCrit PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end

		for spell, creatureName, damage, playerName in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "F12 IncSpell PVP", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for spell, creatureName, damage, playerName in string.gfind(arg1, "(.+) vous touche avec un coup critique et inflige (%d+) points de d\195\169g\195\162ts.") do -- Modified for French Version
			DM_CountMsg(arg1, "F13 IncSpellCrit PVP", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	-- Periodic.
	if (event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE") then
		for spell, creatureName, damage, damageType in string.gfind(arg1, "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts de (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "S14 IncDot", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end

		-- For reflected dots: 
		for spell, damage, damageType, creatureName in string.gfind(arg1, "Votre (.+) inflige (%d+) points de d\195\169g\195\162ts de (.+) \195\160 (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "S14 IncDot", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end

		-- Pet
		for spell, creatureName, playerName, damage, damageType in string.gfind(arg1, "(.+) de (.+) inflige \195\160 (.+) (%d+) points de d\195\169g\195\162ts de (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "E14 IncDot", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_PET, spell);
			return;
		end
	end
	if (event == "CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE") then
		for spell, creatureName, playerName, damage, damageType in string.gfind(arg1, "(.+) de (.+) inflige \195\160 (.+) (%d+) points de d\195\169g\195\162ts de (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "P14 IncDot", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_DOT, DamageMeters_Relation_PARTY, spell);
			return;
		end
	end
	if (event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE" or
		event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE") then
		-- For pvp.
		for spell, creatureName, damage, damageType in string.gfind(arg1, "Votre (.+) inflige (%d+) points de d\195\169g\195\162ts de (.+) \195\160 (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "S14 IncDot PVP", event);
			DamageMeters_AddDamageReceived(UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end

		for spell, creatureName, playerName, damage, damageType in string.gfind(arg1, "(.+) de (.+) inflige \195\160 (.+) (%d+) points de d\195\169g\195\162ts de (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "F14 IncDot", event);
			DamageMeters_AddDamageReceived(playerName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end

		--! This happens in bg right after you die.
		--! "Bob takes 100 Arcane damage from your Moonfire."
	end


	----------------------
	-- HEALING MESSAGES --
	----------------------

	-- NOTE: There is a kind of bug here--we cannot tell the relationship of the 
	-- healer from the message, so if the group filter is on healing pets (healing totems particularly)
	-- won't be added into the list until some other quantity puts them in.
	-- NOTE: Inexplicably, HOSTILEPLAYER_BUFF messages report for party members.
	-- Note: In English, the following things require special healing cases:
	-- Night Dragon's Breath, Julie's Dagger.

	if (event == "CHAT_MSG_SPELL_SELF_BUFF" or
		event == "CHAT_MSG_SPELL_PARTY_BUFF" or
		event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF" or
		event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"
		) then

		for spell, creatureName, damage in string.gfind(arg1, "Votre (.+) soigne (.+) avec un effet critique et lui rend (%d+) points de vie.") do
			DM_CountMsg(arg1, "S21 HealCrit", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_CRIT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, damage in string.gfind(arg1, "Votre (.+) vous soigne pour (%d+) points de vie.") do
			DM_CountMsg(arg1, "S20 Heal", event);
			DamageMeters_AddHealing(UnitName("Player"), UnitName("Player"), damage, DM_HIT, DamageMeters_Relation_SELF, spell);
			return;
		end
        for spell, playerName, creatureName, damage in string.gfind(arg1, "Le (.+) de (.+) soigne avec un effet critique (.+), pour (%d+) points de vie.") do -- Modified for French Version
			DM_CountMsg(arg1, "F21 HealCrit", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_CRIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end

		--[[ English-only special cases. (Assuming these effects cannot crit.)
		for playerName, creatureName, damage in string.gfind(arg1, "(.+)'s Night Dragon's Breath heals (.+) for (%d+)") do
			spell = "Other's Night Dragon's Breath";
			DM_CountMsg(arg1, "F23 NDB", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for playerName, creatureName, damage in string.gfind(arg1, "(.+)'s Julie's Dagger heals (.+) for (%d+)") do
			spell = "Julie's Dagger";
			DM_CountMsg(arg1, "F24 JD", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end]]

		for spell, playerName, creatureName, damage in string.gfind(arg1, "(.+) de (.+) gu\195\169rit (.+) de (%d+) points de vie.") do -- Modified for French Version
			DM_CountMsg(arg1, "F20 Heal", event);
			if (creatureName == DM_YOU) then creatureName = UnitName("Player"); end
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_HIT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	if (event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or
		event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" or
		event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" or
		event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" -- why?
		) then

		for spell, playerName, damage in string.gfind(arg1, "Le (.+) de (.+) vous fait gagner (%d+) points de vie.") do -- Modified for French Version
			DM_CountMsg(arg1, "F22 Hot2", event);
			DamageMeters_AddHealing(playerName, UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
		for spell, damage in string.gfind(arg1, "(.+) vous rend (%d+) points de vie.") do
			DM_CountMsg(arg1, "S22 Hot1", event);
			DamageMeters_AddHealing(UnitName("Player"), UnitName("Player"), damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, damage, creatureName in string.gfind(arg1, "Votre (.+) rend (%d+) points de vie \195\160 (.+).") do -- Modified for French Version		
			DM_CountMsg(arg1, "S22 Hot2", event);
			DamageMeters_AddHealing(UnitName("Player"), creatureName, damage, DM_DOT, DamageMeters_Relation_SELF, spell);
			return;
		end
		for spell, playerName, damage, creatureName in string.gfind(arg1, "(.+) de (.+) rend (%d+) points de vie \195\160 (.+).") do -- Modified for French Version
			DM_CountMsg(arg1, "F22 Hot2", event);
			DamageMeters_AddHealing(playerName, creatureName, damage, DM_DOT, DamageMeters_Relation_FRIENDLY, spell);
			return;
		end
	end

	----------------------

	-- Check the message to see if it is the kind of thing we should have caught.
	if (DamageMeters_enableDebugPrint and arg1) then
		local sub = string.sub(event, 1, 8);
		if (sub == "CHAT_MSG") then			
			-- We only care about messages with numbers in them.
			for amount in string.gfind(arg1, "(%d+)") do

				--DMPrint("UNPARSED NUMERIC ["..event.."] : "..arg1);

				-- GENERICPOWERGAIN_OTHER 
				-- GENERICPOWERGAIN_SELF 
				for player, amount, type in string.gfind(arg1, "(.+) gagne (%d+) (.+).") do	return;	end
				for player, amount, type in string.gfind(arg1, "Vous gagnez (%d+) (.+).") do return; end
				-- SPELLEXTRAATTACKSOTHER_SINGULAR etc
				if (string.find(arg1, "attaques suppl\195\169mentaires")) then return; end
				-- ITEMENCHANTMENTADDOTHEROTHER, etc
				for player in string.gfind(arg1, "(.+) utilise (.+) sur (.+) de (.+).") do return; end
				for player in string.gfind(arg1, "(.+) utilise (.+) sur votre (.+).") do return; end
				for player in string.gfind(arg1, "Vous utilisez (.+) sur (.+) de (.+).") do return; end
				for player in string.gfind(arg1, "Vous utilisez (.+) sur votre (.+).") do return; end
				-- VSENVIRONMENTALDAMAGE_DROWNING_OTHER etc.
				for player in string.gfind(arg1, "Vous vous noyez et perdez (%d+) points de vie.") do return; end
				for player in string.gfind(arg1, "(.+) se noie et perd (%d+) points de vie.") do return; end
				for player in string.gfind(arg1, "Vous faites une chute et perdez (%d+) points de vie.") do return; end
				for player in string.gfind(arg1, "(.+) tombe et perd (%d+) points de vie.") do return; end
				for player in string.gfind(arg1, "(.+) fr\195\180le l\226\128\153\195\169puisement et perd (%d+) points de vie.") do return; end
				for player in string.gfind(arg1, "Vous \195\170tes \195\169puis\195\169 (%d+) points de vie.") do return; end
				for player in string.gfind(arg1, "(.+) perd (%d+) points de vie \195\160 cause du feu.") do return; end
				for player in string.gfind(arg1, "Vous perdez (%d+) points de vie \195\160 cause du feu.") do return; end
				for player in string.gfind(arg1, "(.+) perd (%d+) points de vie en nageant dans la (.+).") do return; end
				for player in string.gfind(arg1, "Vous perdez (%d+) points de vie en nageant dans la (.+).") do return; end
				-- SPELLPOWERDRAINOTHEROTHER etc
				for player in string.gfind(arg1, "(.+) vous draine (%d+) points de (.+).") do return; end
				for player in string.gfind(arg1, "(.+) draine (%d+) points de (.+) \195\160 (.+).") do return; end
				for player in string.gfind(arg1, "Vous drainez (%d+) points de (.+) \195\160 (.+).") do return; end
				for player in string.gfind(arg1, "(.+) vous prend (%d+) points de (.+) et gagne (%d+).") do return; end
				for player in string.gfind(arg1, "Vous prenez (%d+) points de (.+) \195\160 (.+) et gagnez (%d+).") do return; end


				-- blah casts field repair bot 74a
				-- blah begins to cast armor +40
				---------------

				DMPrint("Message num\195\169rique manqu\195\169 ! ["..event.."]");
				DMPrint(arg1);
				return;
			end
		end
	end
end

end -- if fench version
