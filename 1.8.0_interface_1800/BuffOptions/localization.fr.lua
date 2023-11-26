if ( GetLocale() == "frFR" ) then

--------------------------------------------------
--
-- UI Strings
--
--------------------------------------------------
BUFFOPTIONS_CONFIG_SECTION = "Buff Options";
BUFFOPTIONS_CONFIG_SECTION_INFO = "Options pour changer le placement des D\195\169/Buffs";
BUFFOPTIONS_CONFIG_MAIN_HEADER = "Buff Options";
BUFFOPTIONS_CONFIG_MAIN_HEADER_INFO = "Options g\195\169n\195\169rales de Buff Options";
BUFFOPTIONS_CONFIG_REVERSE = "Inverser l\'ordre";
BUFFOPTIONS_CONFIG_REVERSE_INFO = "Active l\'ordre inverse d\'affichage des buffs";
BUFFOPTIONS_CONFIG_SWAP = "Echanger les Buffs/Debuffs";
BUFFOPTIONS_CONFIG_SWAP_INFO = "Active le changement de position des buffs et des d\195\169buffs";
BUFFOPTIONS_CONFIG_BORDER = "Afficher le tour";
BUFFOPTIONS_CONFIG_BORDER_INFO = "Active l\'affichage du font et de la bordure de chaque buff";
BUFFOPTIONS_CONFIG_SIZE = "Taille des Buffs";
BUFFOPTIONS_CONFIG_SIZE_INFO = "Change la taille des buffs";
BUFFOPTIONS_CONFIG_SIZE_TEXT = "Pourcentage";
BUFFOPTIONS_CONFIG_SIZE_SUFFIX = "%";
BUFFOPTIONS_CONFIG_VERTICAL_HEADER = "Options Verticales des Buffs";
BUFFOPTIONS_CONFIG_VERTICAL_HEADER_INFO = "Options applicable sur les buffs affich\195\169s verticalement";
BUFFOPTIONS_CONFIG_VERTICAL = "Buffs Verticaux";
BUFFOPTIONS_CONFIG_VERTICAL_INFO = "Affiche les buffs de haut en bas.";
BUFFOPTIONS_CONFIG_SIDETIME = "Temps sur le c\195\180t\195\169";
BUFFOPTIONS_CONFIG_SIDETIME_INFO = "Affiche la dur\195\169e du Buffs sur le c\195\180t\195\169 plut\195\180t qu\'en dessous";
BUFFOPTIONS_CONFIG_TEXT = "Text du Buff";
BUFFOPTIONS_CONFIG_TEXT_INFO = "Affiche le nom du buff sur le c\195\180t\195\169";
BUFFOPTIONS_CONFIG_DEBUFFTYPE = "Type du d\195\169buff";
BUFFOPTIONS_CONFIG_DEBUFFTYPE_INFO = "Affiche le type du debuff au lieu de son nom";
BUFFOPTIONS_CONFIG_NORIGHT = "Ne pas d\195\169placer \195\160 droite";
BUFFOPTIONS_CONFIG_NORIGHT_INFO = "Ne d\195\169place pas les buffs sur la droite de l\'\195\169cran en affichage vertical";
BUFFOPTIONS_CONFIG_TEXT_HEADER = "Affichage du texte des Buffs";
BUFFOPTIONS_CONFIG_TEXT_HEADER_INFO = "Affiche les options pour le texte du buff";
BUFFOPTIONS_CONFIG_LONGTIME = "Temps lettr\195\169";
BUFFOPTIONS_CONFIG_LONGTIME_INFO = "Affiche le temps en toutes lettres, ex. \'29 Minutes 14 Secondes\'";
BUFFOPTIONS_CONFIG_SHORTTIME = "Temps court";
BUFFOPTIONS_CONFIG_SHORTTIME_INFO = "Affiche le temps raccourci, ex. \'29:14\'";
BUFFOPTIONS_CONFIG_FADETIME = "Fondu";
BUFFOPTIONS_CONFIG_FADETIME_INFO = "Active le fondu lors d\'un expiration prochaine d\'un buff";
BUFFOPTIONS_CONFIG_TEXTCOLOR = "Couleur du texte";
BUFFOPTIONS_CONFIG_TEXTCOLOR_INFO = "R\195\168gle la couleur de la dur\195\169e et du texte du buff";
BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR = "Couleur du texte \195\169xpir\195\169";
BUFFOPTIONS_CONFIG_TEXTSHORTCOLOR_INFO = "R\195\168gle la couleur de la dur\195\169e et du texte du buff lorsqu\'il va expirer";
BUFFOPTIONS_CONFIG_TEXTSIZE = "Taille du texte";
BUFFOPTIONS_CONFIG_TEXTSIZE_INFO = "R\195\168gle la teille du texte et de la dur\195\169e du buff";
BUFFOPTIONS_CONFIG_TEXTSIZE_TEXT = "Pourcentage";
BUFFOPTIONS_CONFIG_TEXTSIZE_SUFFIX = "%";
BUFFOPTIONS_CONFIG_REMINDER_HEADER = "Options de Rappel";
BUFFOPTIONS_CONFIG_REMINDER_HEADER_INFO = "Options pour configurer les alertes lors de l\'exiration des buffs";
BUFFOPTIONS_CONFIG_REMINDER = "Rappel du Buff";
BUFFOPTIONS_CONFIG_REMINDER_INFO = "Envois une alerte lorsqu\'un buff va expirer";
BUFFOPTIONS_CONFIG_REMINDER_TEXT = "Temps limite";
BUFFOPTIONS_CONFIG_REMINDER_SUFFIX = " s";
BUFFOPTIONS_CONFIG_REMINDERSOUND = "Son de rappel";
BUFFOPTIONS_CONFIG_REMINDERSOUND_INFO = "Active un signal sonore pour rappeler l\'expiration d'un buff";
BUFFOPTIONS_CONFIG_REMINDERCOLOR = "Couleur du rappel";
BUFFOPTIONS_CONFIG_REMINDERCOLOR_INFO = "R\195\168gle la couleur de rapelle du buff";
BUFFOPTIONS_CONFIG_REMINDEROSD = "Rappel \195\160 l\'\195\169cran";
BUFFOPTIONS_CONFIG_REMINDEROSD_INFO = "Affiche le rappel a l\'\195\169cran plut\195\180t que dans le chat";
BUFFOPTIONS_CONFIG_EQUIPMENTONLY = "Equipement seulement";
BUFFOPTIONS_CONFIG_EQUIPMENTONLY_INFO = "Seul les buffs d\'\195\169quipement seront rappel\195\169s";
BUFFOPTIONS_CONFIG_NOSHORT = "Seulement les longs";
BUFFOPTIONS_CONFIG_NOSHORT_INFO = "Rappel des buffs ayant une dur\195\169e sup\195\169rieur a celle sp\195\169cifi\195\169e";
BUFFOPTIONS_CONFIG_NOSHORT_TEXT = "Temps minimum";
BUFFOPTIONS_CONFIG_NOSHORT_SUFFIX = " s";

--------------------------------------------------
--
-- Weapon Buff Strings
--
--------------------------------------------------
BUFFOPTIONS_CHARGE_STRINGS = {
	"%d+ Charges",
	"%d+ Charge"
};
BUFFOPTIONS_ENCHANT_STRINGS = {
	".+ %(%d+ jour%)",
	".+ %(%d+ jours%)",
	".+ %(%d+ hr%)",
	".+ %(%d+ hrs%)",
	".+ %(%d+ min%)",
	".+ %(%d+ sec%)"
};
BUFFOPTIONS_CHARGE = "%((%d+) Charge";
BUFFOPTIONS_ENCHANT = "(.+) %(";
BUFFOPTIONS_WEAPONBUFF = "%s";
BUFFOPTIONS_WEAPONBUFF_CHARGE = "%s (%s)";
--If this is defined it will be used instead of BUFFOPTIONS_WEAPONBUFF_CHARGE,
--and the charge will be the first variable and buff name the second
--BUFFOPTIONS_CHARGE_WEAPONBUFF = "(%s) %s";

--------------------------------------------------
--
-- Other Strings
--
--------------------------------------------------
BUFFOPTIONS_EXPIRESOON = "%s va se terminer";
BUFFOPTIONS_EXPIRESOON_ENCHANT = "le buff sur votre %s va se terminer"

end