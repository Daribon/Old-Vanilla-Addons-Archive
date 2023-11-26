-- Version : French ( by Sasmira )
-- Last Update : 03/31/2005


if ( GetLocale() == "frFR" ) then

CT_PLAYERSTATS_VAL = { };
CT_TARGETSTATS_VAL = { };

-- Translate everything within ""-characters (for example Target Stats in the text "Target Stats")

CT_TARGETSTATS_VAL[1] = "Tout Cacher.";
CT_TARGETSTATS_VAL[2] = "Tout Afficher.";
CT_TARGETSTATS_VAL[3] = "Afficher que la Vie.";
CT_TARGETSTATS_VAL[4] = "Afficher que la Mana.";

CT_PLAYERSTATS_VAL[1] = "Tout Cacher.";
CT_PLAYERSTATS_VAL[2] = "Tout Afficher.";
CT_PLAYERSTATS_VAL[3] = "Valeur num\195\169rique seulement.";
CT_PLAYERSTATS_VAL[4] = "Valeur en Pourcentage.";

CT_TARGETSTATS_MODNAME = "Stats Cible";
CT_PLAYERSTATS_MODNAME = "Stats Joueur";

CT_TARGETSTATS_TOOLTIP = "4 mani\195\168res de montrer la Vie & Mana de la Cible.";
CT_PLAYERSTATS_TOOLTIP = "4 mani\195\168res de montrer la Vie & Mana du Joueur.";

CT_STATS_SUBNAME = "Vie & Mana";

CT_STATS_RESETFRAMES = "La fen\195\170tre du Joueur & de la Cible sont r\195\169initialis\195\169es.";

CT_STATS_MODNAME_RESET = "R\195\169initialiser";
CT_STATS_MODNAME_UNLOCK = "D\195\169bloquer";

CT_STATS_SUBNAME_RESETUNLOCK = "Joueur & Cible";

CT_STATS_TOOLTIP_RESET = "R\195\169initialiser la position de La fen\195\170tre du Joueur & de la Cible.";
CT_STATS_TOOLTIP_UNLOCK = "D\195\169bloquer La fen\195\170tre du Joueur & de la Cible.";

CT_STATS_LOCK_ON = "La fen\195\170tre du Joueur & de la Cible sont maintenant d\195\169bloqu\195\169es.";
CT_STATS_LOCK_OFF = "La fen\195\170tre du Joueur & de la Cible sont maintenant bloqu\195\169es.";

end