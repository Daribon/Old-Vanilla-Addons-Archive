-- Version : German (by DrVanGogh, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Cosmos Configuration
	COMBATSTATS_CONFIG_HEADER		= "Kampfstatistik";
	COMBATSTATS_CONFIG_HEADER_INFO		= "Zeigt eine Kampfstatistik im oberen Bereich des Bildschirms an.";
	COMBATSTATS_CONFIG_ONOFF		= "Kampfstatistik ein-/ausschalten";
	COMBATSTATS_CONFIG_ONOFF_INFO		= "Wenn aktiviert, wird die Kampfstatistik im oberen Bereich des Bildschirms angezeigt.";
	COMBATSTATS_CHAT_COMMAND_INFO		= "Speichert Kampfstatistiken und generiert Daten.";
	COMBATSTATS_CONFIG_HIDEONNOTARGET	= "Ausblenden wenn kein Ziel ausgew\195\164hlt ist";
	COMBATSTATS_CONFIG_HIDEONNOTARGET_INFO	= "Wenn aktiviert, wird das Fenster mit der Kampfstatistik nur angezeigt falls ein Ziel angew\195\164hlt ist.";
	COMBATSTATS_CONFIG_USEMOUSEOVER		= "Anzeigen bei Mouseover";
	COMBATSTATS_CONFIG_USEMOUSEOVER_INFO	= "Wenn aktiviert, wird das Fenster mit der Kampfstatistik angezeigt, wenn der Mauszeiger \195\188ber den Titel bewegt wird. Anderenfalls wird die Kampfstatistik bei einem Klick auf den Titel angezeigt.";
	COMBATSTATS_CONFIG_ENDOFFIGHT		= "Kampfstatistiken nach einem Kampf anzeigen";
	COMBATSTATS_CONFIG_ENDOFFIGHT_INFO	= "Wenn aktiviert, weden nach Ende eines Kampfes DPS/Schaden Statistiken angezeigt.";

	COMBATSTATS_CONFIG_DPS_LENGTH		= "DPS Zeitbasis f\195\188r Durchschnitt";
	COMBATSTATS_CONFIG_DPS_LENGTH_INFO	= "Dies gibt an, wieviele vorherigen Sekunden zur Berechnung des Durchschnitts-DPS herangezogen werden. (-1 f\195\188r die gesamte Sitzung)";
	COMBATSTATS_CONFIG_DPS_LENGTH_TEXT	= "Dauer";
	COMBATSTATS_CONFIG_DPS_LENGTH_APPEND	= " Sek.";

	-- Chat Configuration
	COMBSTATS_CHAT_COMMAND_RESET		= "Gesammelte Daten der Kampfstatistik zur\195\188cksetzen";
	CS_CHAT_COMMAND_INFO			= "/cs oder /combatstats eingeben, um eine Hilfe angezeigt zu bekommen.";

	-- Interface Configuration
	DPS_DISPLAY				= "DPS Gesamt :: %.2f";
	DPS_DISPLAY_INITIAL			= "DPS Gesamt :: ---";
	CS_FRAME_GEN_ATTACK_NAME		= "Angriffsart:";
	CS_FRAME_TICKS_TEXT			= "DOT Ticks.";
	CS_FRAME_HITS_TEXT			= "Treffer v.";
	CS_FRAME_SWINGS_TEXT			= "Schl\195\164ge:";
	CS_FRAME_MISSES_TEXT			= "Verfehlt";
	CS_FRAME_DODGES_TEXT			= "Ausgew.";
	CS_FRAME_PARRIES_TEXT			= "Parriert";
	CS_FRAME_BLOCKS_TEXT			= "Geblockt";
	CS_FRAME_RESISTS_TEXT			= "Widerst.";
	CS_FRAME_IMMUNE_TEXT			= "Immun";
	CS_FRAME_EVADES_TEXT			= "Entkom.";
	CS_FRAME_DEFLECTS_TEXT			= "Abgelenkt";
	CS_FRAME_PERCENT_OVERALL_TEXT		= "Anteil am Gesamtschaden:";
	CS_FRAME_TIME_LASTCRIT_TEXT		= "Zeit seit letz. Krit.:";
	CS_FRAME_TOTAL_TEXT			= "Gesamt:";
	CS_FRAME_DAMAGE_TEXT			= "Schaden:";
	CS_FRAME_MINMAX_TEXT			= "Min/Max:";
	CS_FRAME_AVGDMG_TEXT			= "Mittl. Schaden:";
	CS_FRAME_PERCENTDMG_TEXT		= "% v. Schaden:";
	    
	CS_DROPDOWN_SELECT_TEXT			= "Angriff w\195\164hlen";
   
	CS_TT_OVERALLPCT_TEXT			= "Kritische Treffer insgesamt in Prozenz.";
	CS_TT_OVERALLDMGPCT_TEXT		= "Gesamtschaden f\195\188r alle Angriffe dieser Art in Prozent.";
	CS_TT_NONCRIT_HITSPCT_TEXT		= "Nichtkritische Treffer dieses Angriffs in Prozent.";
	CS_TT_CRIT_HITSPCT_TEXT			= "Kritischen Treffer dieses Angriffs in Prozent.";
	CS_TT_NONCRIT_DMGPCT_TEXT		= "Schaden durch nichtkritische Treffer dieses Angriffs in Prozent.";
	CS_TT_CRIT_DMGPCT_TEXT			= "Schaden durch kritische Treffer dieses Angriffs in Prozent.";

	CS_TEXT_RESET				= "Zur\195\188cksetzen";
	CS_TEXT_NA				= "k.A.";
	CS_TEXT_GENERAL				= "Angriffsdaten";
	CS_TEXT_NONCRIT				= "Normal";
	CS_TEXT_CRIT				= "Kritisch";

	CS_TEXT_ATTACK_DEFAULT			= "Standard";
	CS_TEXT_ATTACK_TOTAL			= "Gesamt";
	    
	CLOCK_TIME_DAY				= "%d Tag";
	CLOCK_TIME_DAYS				= "%d Tage";
	CLOCK_TIME_HOUR				= "%d Stunde";
	CLOCK_TIME_HOURS			= "%d Stunden";
	CLOCK_TIME_MINUTE			= "%d Minute";
	CLOCK_TIME_MINUTES			= "%d Minuten";
	CLOCK_TIME_SECOND			= "%d Sekunde";
	CLOCK_TIME_SECONDS			= "%d Sekunden";
	
	-- Localisation Strings
	--  --------------------------------
	--  HOWTO: localize Combat messages
	--  --------------------------------
	--  1) localize the regular expression for the combat chat message 
	--     for each type of attack in the "match" field 
	--  2) give the order of arguments as it appears in the chat message
	--     in the "args" field. 
	--     Valid entries are:
	--     - CS_ARG_CREATURE
	--     - CS_ARG_DAMAGE 
	--     - CS_ARG_DAMAGETYPE
	--     - CS_ARG_SPELL 
	--     - CS_ARG_PET
	--     
	--     Note: There must be a corresponding arg entry for each group
	--           in the regular expression. Don't give more or less args
	--           than there are groups in the expression (will cause an 
	--           error)
	--     
	--  Do _NOT_ change the name of the attack ;)

	CS_MSG_XP_GAIN		= "(.+) stirbt, Ihr bekommt (%d+) Erfahrung.";
	CS_MSG_SLAIN_YOU	= "Ihr sterbt.";
			
	CombatStats_ChatMessages = {
		default = {
			player = {
				hit = {
					match = "Ihr trefft (.+)%. Schaden: (%d+)";
					args = {CS_ARG_CREATURE, CS_ARG_DAMAGE};
				};
				crit= {
					match = "Ihr trefft (.+) kritisch f\195\188r (%d+)  Schaden%.";
					args = {CS_ARG_CREATURE, CS_ARG_DAMAGE};
				};
				miss = {
					match = "Ihr verfehlt (.+)%.";
					args = {CS_ARG_CREATURE};
				};
				parry = {
					match = "Ihr greift an%. (.+) pariert%."; 	
					args = {CS_ARG_CREATURE};
				};
				evade= {
					match = "Ihr greift an%. (.+) entkommt%.";
					args = {CS_ARG_CREATURE};
				};
				dodge = {
					match = "Ihr greift an%. (.+) weicht aus%.";	
					args = {CS_ARG_CREATURE};
				};
				deflect = {
					match = "Ihr greift an%. (.+) wehrt ab%.";
					args = {CS_ARG_CREATURE};
				};
				block = {
					match = "Ihr greift an%. (.+) blockt ab%.";
					args = {CS_ARG_CREATURE};
				};
			};
			pet = {
				hit = {
					match = "(.+) trifft (.+)%. f\195\188r (%d+) Schaden%.";
					args = {CS_ARG_PET, CS_ARG_CREATURE, CS_ARG_DAMAGE};
				};
				crit= {
					match = "(.+) trifft (.+) kritisch f\195\188r (%d+)%.";
					args = {CS_ARG_PET, CS_ARG_CREATURE, CS_ARG_DAMAGE};
				};
				miss = {
					match = "(.+) verfehlt (.+)%.";
					args = {CS_ARG_PET, CS_ARG_CREATURE};
				};
				parry = {
					match = "(.+) greift an. (.+) parriert.";
					args = {CS_ARG_PET, CS_ARG_CREATURE};
				};
				evade= {
					match = "(.+) greift an. (.+) entkommt.";
					args = {CS_ARG_PET, CS_ARG_CREATURE};
				};
				dodge = {
					match = "(.+) greift an. (.+) weicht aus.";
					args = {CS_ARG_PET, CS_ARG_CREATURE};
				};
				deflect = {
					match = "(.+) greift an%. (.+) wehrt ab%.";
					args = {CS_ARG_PET, CS_ARG_CREATURE};
				};
				block = {
					match = "(.+) greift an. (.+) blockt ab%.";	
					args = {CS_ARG_PET, CS_ARG_CREATURE};
				}
			}
		};
		spell = {
			player = {				
				hit = {
					match = "(.+) von Euch trifft (.+) f\195\188r (%d+) Schaden%.";
					args = {CS_ARG_SPELL, CS_ARG_CREATURE, CS_ARG_DAMAGE};							
				};
				crit = {
					match = "Eu%. (.+) trifft (.+) kritisch%. Schaden: (%d+).";
					args = {CS_ARG_SPELL, CS_ARG_CREATURE, CS_ARG_DAMAGE};							
				};
				dot = {
					match = "(.+) erleidet (%d+) (.+)schaden %(durch (.+)%)%.";
					args = {CS_ARG_CREATURE, CS_ARG_DAMAGE, CS_ARG_DAMAGETYPE, CS_ARG_SPELL};							
				};
				miss = {
					match = "Eu%. (.+) hat (.+) verfehlt%.";
					args = {CS_ARG_SPELL, CS_ARG_CREATURE};							
				};
				parry = {
					match = "(.+) von (.+) wurde von (.+) pariert%.";
					args = {CS_ARG_SPELL, CS_ARG_PET, CS_ARG_CREATURE};							
				};
				evade = {
					match = "(.+) ist (.+) ausgewichen%.";
					args = {CS_ARG_CREATURE, CS_ARG_SPELL};							
				};
				dodge = {
					match = "(.+) ist (.+) entkommen.";
					args = {CS_ARG_CREATURE, CS_ARG_SPELL};							
				};
				deflect = {
					match = "(.+) wurde von (.+) abgewehrt%.";
					args = {CS_ARG_SPELL, CS_ARG_CREATURE};							
				};
				block = {
					match = " (.+) wurde von (.+) geblockt%.";			
					args = {CS_ARG_SPELL, CS_ARG_CREATURE};							
				};
				resist = {
					match = "Ihr habt es mit (.+) versucht, aber (.+) hat widerstanden.";			
					args = {CS_ARG_SPELL, CS_ARG_CREATURE};							
				};
				immune = {
					match = "Eu%. (.+) war ein Fehlschlag%. (.+) ist immun.";	
					args = {CS_ARG_SPELL, CS_ARG_CREATURE};							
				}
			};			
			pet = {
				hit = {
					match = "(.+)s (.+) trifft (.+) f\195\188r (%d+) Schaden%.";
					args = {CS_ARG_PET, CS_ARG_SPELL, CS_ARG_CREATURE, CS_ARG_DAMAGE};
				};
				crit= {
					match = "(.+)s (.+) trifft (.+) kritisch f\195\188r (%d+) Schaden%.";
					args = {CS_ARG_PET, CS_ARG_SPELL, CS_ARG_CREATURE, CS_ARG_DAMAGE};
				};
				miss = {
					match = "(.+) von (.+) verfehlt (.+)%.";
					args = {CS_ARG_SPELL, CS_ARG_PET, CS_ARG_CREATURE};
				};
				resist = {
					match = "(.+)s (.+) wurde von (.+) widerstanden.";
					args = {CS_ARG_PET, CS_ARG_SPELL, CS_ARG_CREATURE};
				};
				dot = {
					match = "";		-- TODO: localize
					args = {};
				};
				parry = {
					match = "(.+) von (.+) wurde von (.+) pariert.";	-- TODO: verify, but parrying spells should be impossible
					args = {CS_ARG_SPELL, CS_ARG_PET, CS_ARG_CREATURE};
				};
				dodge = {
					match = "(.+) ist (.+) von (.+) ausgewichen.";
					args = {CS_ARG_CREATURE, CS_ARG_SPELL, CS_ARG_PET};
				};
				block = {
					match = "(.+)s (.+) wurde geblockt von (.+)%.";		
					args = {CS_ARG_PET, CS_ARG_SPELL, CS_ARG_CREATURE};
				};
				evade = {
					match = "(.+) ist (.+) von (.+) entkommen%.";
					args = {CS_ARG_CREATURE, CS_ARG_SPELL, CS_ARG_PET};
				};
				deflect = {
					match = "(.+) versuchte es mit (.+) %.%.%. (.+) konnte abwehren%.";		
					args = {CS_ARG_PET, CS_ARG_SPELL, CS_ARG_CREATURE};
				};
				immune = {
					match = "(.+) versucht es mit (.+)%. Ein Fehlschlag, denn (.+) ist immun%.";		
					args = {CS_ARG_PET, CS_ARG_SPELL, CS_ARG_CREATURE};
				};
			};
		};
	};

end