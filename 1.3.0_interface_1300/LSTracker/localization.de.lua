-- created by sarf

if ( GetLocale ) and ( GetLocale() == "deDE" ) then
	LSTRACKER_CLASS_SHAMAN							= "Schamane";


	LSTRACKER_PATTERN_LIGHTNING_SHIELD_HIT			= "Blitzschlagschild von Euch trifft (.+) fuer (%d+) Schaden.";
	LSTRACKER_PATTERN_GAIN_LIGHTNING_SHIELD			= "Ihr bekommt Blitzschlagschild.";
	LSTRACKER_PATTERN_LOSE_LIGHTNING_SHIELD			= "Blitzschlagschild schwindet von Euch.";
end