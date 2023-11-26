--[[
--	CastOptions Localization
--		"German Localization"
--	
--	By: StarDust
--	
--	$Id: localization.de.lua 2409 2005-09-09 06:39:02Z stardust $
--	$Rev: 2409 $
--	$LastChangedBy StarDust $
--	$Date: 2005-09-09 01:39:02 -0500 (Fri, 09 Sep 2005) $
--]]

if (GetLocale()=="deDE") then

	--------------------------------------------------
	--
	-- Binding Strings
	--
	--------------------------------------------------
	BINDING_HEADER_CASTOPTIONS		= "Zaubergehilfe";
	BINDING_NAME_CASTOPTIONS_SELF		= "Selbstzauber";
	BINDING_NAME_CASTOPTIONS_TOGGLESELF	= "Selbstzauber ein-/ausschalten";
	BINDING_NAME_CASTOPTIONS_PARTY1		= "Zauber Gruppenmitglied 1";
	BINDING_NAME_CASTOPTIONS_PARTY2		= "Zauber Gruppenmitglied 1";
	BINDING_NAME_CASTOPTIONS_PARTY3		= "Zauber Gruppenmitglied 1t";
	BINDING_NAME_CASTOPTIONS_PARTY4		= "Zauber Gruppenmitglied 1";
	BINDING_NAME_CASTOPTIONS_AIMED		= "Gezieltes Zaubern";

	--------------------------------------------------
	--
	-- Cosmos Configuration
	--
	--------------------------------------------------
	CASTOPTIONS_CONFIG_SECTION		= "Zaubergehilfe";
	CASTOPTIONS_CONFIG_SECTION_INFO		= "Erlaubt es erweiterte Einstellungen zum Zaubern festzulegen, wie zum Beispiel das automatische zaubern auf einen selbst.";
	CASTOPTIONS_CONFIG_MAIN_HEADER		= "Allgemeine Optionen";
	CASTOPTIONS_CONFIG_MAIN_HEADER_INFO	= "Allgemeine Optionen zum Zaubergehilfen.";
	CASTOPTIONS_CONFIG_ENABLED		= "Zaubergehilfe verwenden";
	CASTOPTIONS_CONFIG_ENABLED_INFO		= "Wenn aktiviert, wird der Zaubergehilfe und seine erweiterten Einstellungen verwendet.";
	CASTOPTIONS_CONFIG_SMARTRANK		= "Intelligentes Zaubern nach Rang";
	CASTOPTIONS_CONFIG_SMARTRANK_INFO	= "Wenn aktiviert, wird beim Zaubern eines Buffs das Ziel dahingehend \195\188berpr\195\188ft und sollte jenes zu niedrig f\195\188r den Buff sein so wird automatisch der selbe Buff mit einem niedrigeren Rang gezaubert.";
	CASTOPTIONS_CONFIG_CANCELWAND		= "Zauberstab beim Zaubern abbrechen";
	CASTOPTIONS_CONFIG_CANCELWAND_INFO	= "Wenn aktiviert, wird das Zaubern mit einem Zauberstab automatisch abgebrochen sobald das Zaubern eines Zauberspruchs ausgef\195\188hrt wird.";
	CASTOPTIONS_CONFIG_CANCELSHOT		= "Fernwaffe beim Bandagieren abbrechen";
	CASTOPTIONS_CONFIG_CANCELSHOT_INFO	= "Wenn aktiviert, wird das schie\195\159en mit einer Fernwaffe automatisch abgebrochen sobald du dich oder jemand anderen verbindest (bandagieren)."
	CASTOPTIONS_CONFIG_SHOWCANCELSHOT	= "Deaktivierung der Fernwaffe/Zauberstab melden";
	CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO	= "Wenn aktiviert, wird eine Meldung angezeigt sobald das Zaubern mit dem Zauberstab oder das Schie\195\159en mit einer Fernwaffe abgebrochen wird.";
	CASTOPTIONS_CONFIG_NODISPEL		= "Magiebannen auf Selbst/Gruppe verhindern";
	CASTOPTIONS_CONFIG_NODISPEL_INFO	= "Wenn aktiviert, wird Magiebannen nicht automatisch auf einen selbst oder ein Gruppenmitglied gezaubert.";
	CASTOPTIONS_CONFIG_MANACONTROL		= "Mana Kontrolle";
	CASTOPTIONS_CONFIG_MANACONTROL_INFO	= "Wenn aktiviert, werden Mana-Erh\195\182hen Zauber nicht auf Ziele gezaubert, wenn jene gar kein Mana besitzen/verwenden k\195\182nnen.";
	CASTOPTIONS_CONFIG_TOGGLESELF		= "Selbstzaubern aktivieren/deaktivieren";
	CASTOPTIONS_CONFIG_TOGGLESELF_INFO	= "Aktiviert oder deaktiviert das Selbstzaubern.";
	CASTOPTIONS_CONFIG_TOGGLESELF_TEXT	= "wechseln";
	CASTOPTIONS_CONFIG_KEYS_HEADER		= "Tasten f\195\188r das Selbstzaubern";
	CASTOPTIONS_CONFIG_KEYS_HEADER_INFO	= "Legt fest, welche Tasten f\195\188r das Selbstzaubern verwendet werden.";
	CASTOPTIONS_CONFIG_ALT			= "Benutzte 'Alt' f\195\188r das Selbstzaubern";
	CASTOPTIONS_CONFIG_ALT_INFO		= "Selbstzaubern wird durch dr\195\188cken der 'Alt' Taste aktiviert.";
	CASTOPTIONS_CONFIG_SHIFT		= "Benutzte 'Shift' f\195\188r das Selbstzaubern";
	CASTOPTIONS_CONFIG_SHIFT_INFO		= "Selbstzaubern wird durch dr\195\188cken der 'Shift' Taste aktiviert.";
	CASTOPTIONS_CONFIG_CTRL			= "Benutzte 'Strg' f\195\188r das Selbstzaubern";
	CASTOPTIONS_CONFIG_CTRL_INFO		= "Selbstzaubern wird durch dr\195\188cken der 'Strg' Taste aktiviert.";
	CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER	= "Gezieltes Zaubern";
	CASTOPTIONS_CONFIG_AIMEDKEYS_HEADER_INFO= "Erlaubt es Einstellungen zum Zaubern auf Ziele unter dem Mauszeiger festzulegen.";
	CASTOPTIONS_CONFIG_AIMEDCAST		= "Gezieltes Zaubern verwenden";
	CASTOPTIONS_CONFIG_AIMEDCAST_INFO	= "Wenn aktiviert, wird der gezielte Zauber auf jenes Ziel gewirkt, welches sich unter dem Mauszeiger befindet. Die Tastenk\195\188rzel zum Gezielten Zaubern erfordern nicht, da\195\159 diese Option aktiviert ist.";
	CASTOPTIONS_CONFIG_AIMEDWORLD		= "Gezieltes Welt-Zaubern";
	CASTOPTIONS_CONFIG_AIMEDWORLD_INFO	= "Wenn aktiviert, kann das Gezielte Zaubern auf alle Objekte am gesamten Bildschirm verwendet werden und nicht nur auf jene in einem Fenster.";
	CASTOPTIONS_CONFIG_AIMEDHOSTILE		= "Gezieltes Schadens-Zaubern";
	CASTOPTIONS_CONFIG_AIMEDHOSTILE_INFO	= "Wenn aktiviert, kann mittels Gezieltem Zaubern auch ein Schadenszauber gezaubert werden.";
	CASTOPTIONS_CONFIG_AIMEDALT		= "Benutzte 'Alt' f\195\188r das Gezielte Zaubern";
	CASTOPTIONS_CONFIG_AIMEDALT_INFO	= "Gezieltes Zaubern wird durch dr\195\188cken der 'Alt' Taste aktiviert.";
	CASTOPTIONS_CONFIG_AIMEDSHIFT		= "Benutzte 'Shift' f\195\188r das Gezielte Zaubern";
	CASTOPTIONS_CONFIG_AIMEDSHIFT_INFO	= "Gezieltes Zaubern wird durch dr\195\188cken der 'Shift' Taste aktiviert.";
	CASTOPTIONS_CONFIG_AIMEDCTRL		= "Benutzte 'Strg' f\195\188r das Gezielte Zaubern";
	CASTOPTIONS_CONFIG_AIMEDCTRL_INFO	= "Gezieltes Zaubern wird durch dr\195\188cken der 'Strg' Taste aktiviert.";
	CASTOPTIONS_CONFIG_SMART_HEADER		= "Intelligentes Selbstzaubern";
	CASTOPTIONS_CONFIG_SMART_HEADER_INFO	= "Legt Optionen f\195\188r das intelligente Selbstzaubern fest.";
	CASTOPTIONS_CONFIG_SMART		= "Intelligentes Selbstzaubern verwenden";
	CASTOPTIONS_CONFIG_SMART_INFO		= "Wenn aktiviert, werden positive Zauberspr\195\188che automatisch auf einen selbst gesprochen wenn kein Ziel angew\195\164hlt ist.";
	CASTOPTIONS_CONFIG_NOGROUP		= "Intelligentes Selbstzaubern in Gruppe deaktivieren";
	CASTOPTIONS_CONFIG_NOGROUP_INFO		= "Intelligentes Selbstzaubern deaktivieren wenn man sich in einer Gruppe befindet.";
	CASTOPTIONS_CONFIG_SMARTASSIST_HEADER	= "Intelligentes Unterst\195\188tzen";
	CASTOPTIONS_CONFIG_SMARTASSIST_HEADER_INFO = "Legt Optionen f\195\188r das intelligente Unterst\195\188tzen beim Zaubern fest.";
	CASTOPTIONS_CONFIG_SMARTASSIST		= "Intelligentes Unterst\195\188tzen verwenden";
	CASTOPTIONS_CONFIG_SMARTASSIST_INFO	= "Wenn aktiviert, wird beim Zaubern eines Schadens- oder Debuffzaubers auf ein befreundetes Ziel jener Zauber automatisch auf dessen Ziel gezaubert.";
	CASTOPTIONS_CONFIG_ASSISTTARGET		= "Ziel auf feindliches wechseln";
	CASTOPTIONS_CONFIG_ASSISTTARGET_INFO	= "Wenn aktiviert, wird beim 'Intelligenten Unterst\195\188tzen' das eigene Ziel auf das feindliche Ziel gewechselt.";
	CASTOPTIONS_CONFIG_CHAINASSIST		= "Fortlaufend Unterst\195\188tzen";
	CASTOPTIONS_CONFIG_CHAINASSIST_INFO	= "Wenn aktiviert, bleibt beim 'Intelligenten Unterst\195\188tzen' das freundliche Ziel auch weiter angw\195\164hlt bis ein feindliches oder kein Ziel gefunden wird.";
	CASTOPTIONS_CONFIG_SMARTGROUP_HEADER	= "Intelligentes Gruppenzaubern";
	CASTOPTIONS_CONFIG_SMARTGROUP_HEADER_INFO = "Legt Optionen f\195\188r das intelligente Gruppenzaubern fest.";
	CASTOPTIONS_CONFIG_SMARTGROUP		= "Intelligentes Gruppenzaubern verwenden";
	CASTOPTIONS_CONFIG_SMARTGROUP_INFO	= "Wenn aktiviert, werden positive Zauber automatisch auf Gruppenmitglieder gezaubert wenn kein oder ein feindliches Ziel ausgew\195\164hlt ist.";
	CASTOPTIONS_CONFIG_GROUPPETS		= "Pets von Gruppenmitgliedern ber\195\188cksichtigen";
	CASTOPTIONS_CONFIG_GROUPPETS_INFO	= "Wenn aktiviert, werden auch Pets von Gruppenmitgliedern beim Intelligenten Gruppenzaubern ber\195\188cksichtigt.";
	CASTOPTIONS_CONFIG_GROUPTARGET		= "Ziel auf Gruppenmitglied wechseln";
	CASTOPTIONS_CONFIG_GROUPTARGET_INFO	= "Wenn aktiviert, wird beim 'Intelligenten Gruppenzaubern' das eigene Ziel auf jenes Gruppenmitglied gewechselt auf welches der Zauber ausgef\195\188hrt wird.";
	CASTOPTIONS_CONFIG_GROUPGROUP		= "In Gruppenzauber umwandeln";
	CASTOPTIONS_CONFIG_GROUPGROUP_INFO	= "Wenn aktiviert, wird ein positiver Zauber, welcher auf ein Grupenmitglied gezaubert wird, automatisch als Gruppenzauber auf alle Gruppenmitglieder ausgef\195\188hrt.";
	CASTOPTIONS_CONFIG_GROUPSELF		= "Selbstzaubern in Gruppe";
	CASTOPTIONS_CONFIG_GROUPSELF_INFO	= "Wenn aktiviert, wird ein positiver Zauber welcher auf ein Gruppenmitglied gezaubert wird automatisch auf einen selbst gezaubert wenn m\195\182glich.";
	CASTOPTIONS_CONFIG_GROUPHEAL		= "Intelligente Gruppenheilung";
	CASTOPTIONS_CONFIG_GROUPHEAL_INFO	= "Wenn aktiviert, werden Heilzauber automatisch auf das Gruppenmitglied mit der niedrigsten Gesundheit gezaubert.";
	CASTOPTIONS_CONFIG_GROUPMANA		= "Intelligente Manakontrolle";
	CASTOPTIONS_CONFIG_GROUPMANA_INFO	= "Wenn aktiviert, werden Mana-Verst\195\164rkungszauber auf das Gruppenmitglied mit dem niedrigsten Mana gezaubert.";
	CASTOPTIONS_CONFIG_GROUPCURE		= "Intelligente Gruppenheilung (Gift,Magie,Fluch,Krankheit)";
	CASTOPTIONS_CONFIG_GROUPCURE_INFO	= "Wenn aktiviert, werden Zauber zur Heilung von Gift, Magie, Fluch und Krankheit automatisch auf die jeweiligen Gruppenmitglieder gezaubert.";
	CASTOPTIONS_CONFIG_GROUPBUFF		= "Intelligentes Gruppenbuffen";
	CASTOPTIONS_CONFIG_GROUPBUFF_INFO	= "Wenn aktiviert, wird ein Buff automatisch auf ein Gruppenmitglied gezaubert welches jenen noch nicht besitzt.";
	CASTOPTIONS_CONFIG_CANCELSPELL		= "Zauber bei keinem Ziel abbrechen";
	CASTOPTIONS_CONFIG_CANCELSPELL_INFO	= "Wenn aktiviert, werden Zauber abgebrochen wenn kein gutes Gruppenziel f\195\188r jene gefunden werden kann.";
	CASTOPTIONS_CONFIG_RECASTTIME		= "Zeit bis Zauberauffrischung";
	CASTOPTIONS_CONFIG_RECASTTIME_INFO	= "Gibt die Zeit in Sekunden an, welche mindestens vergehen mu\195\159 bevor der gleiche Zauber erneut auf das selbe Gruppenmitglied gezaubert werden kann.";
	CASTOPTIONS_CONFIG_RECASTTIME_SUFFIX	= " Sek.";
	CASTOPTIONS_CONFIG_BOUND_HEADER		= "Gebundenes Zaubern";
	CASTOPTIONS_CONFIG_BOUND_HEADER_INFO	= "Einstellungen zum Zaubern auf gebundene Ziele.";
	CASTOPTIONS_CONFIG_NOBOUNDCAST		= "Zaubern auf festgesetzte Ziele verhindern";
	CASTOPTIONS_CONFIG_NOBOUNDCAST_INFO	= "Wenn aktiviert, werden keine Zauber auf festgesetzte Ziele gezaubert, wenn jene das Ziel von Effekten wie Schlaf, Ranken, Untote fesseln oder Schaf befreien w\195\188rde.";
	CASTOPTIONS_CONFIG_BOUNDPOTENTIAL	= "Zaubern auf potenziell festgesetzte Ziele verhindern";
	CASTOPTIONS_CONFIG_BOUNDPOTENTIAL_INFO	= "Wenn aktiviert, werden keine Zauber auf gebundene Ziele gezaubert, wenn jene das Ziel nur m\195\182glicherweise wieder freisetzen.";
	CASTOPTIONS_CONFIG_BOUNDATTACK		= "Zaubern auf festgesetzte, angreifende Ziele verhindern";
	CASTOPTIONS_CONFIG_BOUNDATTACK_INFO	= "Wenn aktiviert, werden keine Zauber auf festgesetzte Ziele gezaubert die noch angreifen k\195\182nnen.";
	CASTOPTIONS_CONFIG_BOUNDDELAY		= "Zaubern auf festgesetzte Ziele\ndennoch zulassen";
	CASTOPTIONS_CONFIG_BOUNDDELAY_INFO	= "Wenn ein Zauber gewirkt wird, welcher ein festgesetztes Ziel in der angegebenen Zeit ein zweites mal freisetzen w\195\188rde, wird jener dennoch ausgef\195\188hrt.";
	CASTOPTIONS_CONFIG_BOUNDDELAY_SUFFIX	= " Sek.";
	CASTOPTIONS_CONFIG_TEXTURE_INFO		= "Wenn aktiviert, wird das Icon des Zaubers, welcher gerade ausgef\195\188hrt wurde, angezeigt.";

	--------------------------------------------------
	--
	-- Chat Configuration
	--
	--------------------------------------------------
	CASTOPTIONS_CHAT_ENABLED		= CASTOPTIONS_CONFIG_ENABLED;
	CASTOPTIONS_CHAT_SMARTRANK		= CASTOPTIONS_CONFIG_SMARTRANK;
	CASTOPTIONS_CHAT_CANCELWAND		= CASTOPTIONS_CONFIG_CANCELWAND;
	CASTOPTIONS_CHAT_SHOWCANCELWAND		= CASTOPTIONS_CONFIG_SHOWCANCELWAND;
	CASTOPTIONS_CHAT_NODISPEL		= CASTOPTIONS_CONFIG_NODISPEL;
	CASTOPTIONS_CHAT_MANACONTROL		= CASTOPTIONS_CONFIG_MANACONTROL;
	CASTOPTIONS_CHAT_NOBOUNDCAST		= CASTOPTIONS_CONFIG_NOBOUNDCAST;
	CASTOPTIONS_CHAT_BOUNDPOTENTIAL		= CASTOPTIONS_CONFIG_BOUNDPOTENTIAL;
	CASTOPTIONS_CHAT_BOUNDATTACK		= CASTOPTIONS_CONFIG_BOUNDATTACK;
	CASTOPTIONS_CHAT_BOUNDDELAY		= CASTOPTIONS_CONFIG_BOUNDDELAY;
	CASTOPTIONS_CHAT_ALT			= CASTOPTIONS_CONFIG_ALT;
	CASTOPTIONS_CHAT_SHIFT			= CASTOPTIONS_CONFIG_SHIFT;
	CASTOPTIONS_CHAT_CTRL			= CASTOPTIONS_CONFIG_CTRL;
	CASTOPTIONS_CHAT_SMART			= CASTOPTIONS_CONFIG_SMART;
	CASTOPTIONS_CHAT_NOGROUP		= CASTOPTIONS_CONFIG_NOGROUP;
	CASTOPTIONS_CHAT_SMARTASSIST		= CASTOPTIONS_CONFIG_SMARTASSIST;
	CASTOPTIONS_CHAT_NORETURN		= CASTOPTIONS_CONFIG_NORETURN;
	CASTOPTIONS_CHAT_CHAINASSIST		= CASTOPTIONS_CONFIG_CHAINASSIST;
	CASTOPTIONS_CHAT_SMARTGROUP		= CASTOPTIONS_CONFIG_SMARTGROUP;
	CASTOPTIONS_CHAT_GROUPPETS		= CASTOPTIONS_CONFIG_GROUPPETS;
	CASTOPTIONS_CHAT_SGNORETURN		= CASTOPTIONS_CONFIG_SGNORETURN;
	CASTOPTIONS_CHAT_GROUPGROUP		= CASTOPTIONS_CONFIG_GROUPGROUP;
	CASTOPTIONS_CHAT_GROUPSELF		= CASTOPTIONS_CONFIG_GROUPSELF;
	CASTOPTIONS_CHAT_GROUPHEAL		= CASTOPTIONS_CONFIG_GROUPHEAL;
	CASTOPTIONS_CHAT_GROUPMANA		= CASTOPTIONS_CONFIG_GROUPMANA;
	CASTOPTIONS_CHAT_GROUPCURE		= CASTOPTIONS_CONFIG_GROUPCURE;
	CASTOPTIONS_CHAT_GROUPBUFF		= CASTOPTIONS_CONFIG_GROUPBUFF;
	CASTOPTIONS_CHAT_CANCELSPELL		= CASTOPTIONS_CONFIG_CANCELSPELL;
	CASTOPTIONS_CHAT_RECASTTIME		= CASTOPTIONS_CONFIG_RECASTTIME;
	CASTOPTIONS_CHAT_TEXTURE		= "Icon des Zaubers anzeigen %s";

	--------------------------------------------------
	--
	-- DeBuff Types
	--
	--------------------------------------------------
	CASTOPTIONS_DEBUFF_POISEN		= "Gift";
	CASTOPTIONS_DEBUFF_CURSE		= "Fluch";
	CASTOPTIONS_DEBUFF_DISEASE		= "Krankheit";
	CASTOPTIONS_DEBUFF_MAGIC		= "Magie";

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
	CASTOPTIONS_RANK			= "Rang";
	CASTOPTIONS_RANK_PARSE			= "%("..CASTOPTIONS_RANK.." (%d+)%)";

	--------------------------------------------------
	--
	-- Error Messages
	--
	--------------------------------------------------
	CASTOPTIONS_ERROR_CANCELED_WAND		= "Schie\195\159en mit dem Zauberstab abgebrochen.";
	CASTOPTIONS_ERROR_BOUND			= "Das Ziel wird durch den Zauber m\195\182glicherweise freigesetzt.";
	CASTOPTIONS_ERROR_ASC			= "AddOn Selbstzauber (AltSelfCast) entdeckt, der Zaubergehilfe wurde daher deaktiviert.";
	CASTOPTIONS_ERROR_ASC_INFO		= "Der Zaubergehilfe ersetzt das AddOn Selbstzauber (AltSelfCast). Jene beiden k\195\182nnen daher nicht zugleich verwendet werden. Bitte entferne das AddOn Selbstzauber (AltSelfCast).";
	CASTOPTIONS_ERROR_NOTARG		= "Kein geeignetes Ziel f\195\188r diesen Zauber gefunden.";
	CASTOPTIONS_ERROR_NOMANA		= "Dieses Ziel profitiert nicht von Mana-Verst\195\164rkungszaubern.";

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
		CASTOPTIONS_CONFIG_SMARTRANK.." - "..CASTOPTIONS_CONFIG_SMARTRANK_INFO.."\n\n"..
		CASTOPTIONS_CONFIG_CANCELWAND.." - "..CASTOPTIONS_CONFIG_CANCELWAND_INFO.."\n\n"..
		CASTOPTIONS_CONFIG_CANCELSHOT.." - "..CASTOPTIONS_CONFIG_CANCELSHOT_INFO.."\n\n"..
		CASTOPTIONS_CONFIG_SHOWCANCELSHOT.." - "..CASTOPTIONS_CONFIG_SHOWCANCELSHOT_INFO.."\n\n"..
		CASTOPTIONS_CONFIG_NODISPEL.." - "..CASTOPTIONS_CONFIG_NODISPEL_INFO.."\n\n"..
		CASTOPTIONS_CONFIG_MANACONTROL.." - "..CASTOPTIONS_CONFIG_MANACONTROL_INFO.."\n\n"..
		"Alt/Ctrl/Shift Self Cast - If any of these are enabled, if they are pushed when you cast, the spell will be self cast.\n\n"..
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

end