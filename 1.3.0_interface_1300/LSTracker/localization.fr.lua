-- created by sarf

if ( GetLocale ) and ( GetLocale() == "frFR" ) then
	LSTRACKER_CLASS_SHAMAN							= "Chaman";


	LSTRACKER_PATTERN_LIGHTNING_SHIELD_HIT			= "Votre Bouclier de Foudre touche (.+) et inflige (%d+) points (.+)"; -- brutefix
	LSTRACKER_PATTERN_GAIN_LIGHTNING_SHIELD			= "Vous gagnez Bouclier de Foudre.";
	LSTRACKER_PATTERN_LOSE_LIGHTNING_SHIELD			= "Bouclier de Foudre vient de se dissiper.";
end