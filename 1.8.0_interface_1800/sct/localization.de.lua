-- Version : German (by Endymion, StarDust, Sasmira)
-- Last Update : 09/16/2005

if ( GetLocale() == "deDE" ) then

		-- Static Messages
		SCT_DodgeMsg		= "Ausgewichen!";		-- Message to be displayed when you dodge
		SCT_ParryMsg		= "Pariert!";			-- Message to be displayed when you parry
		SCT_BlockMsg		= "Geblockt!";			-- Message to be displayed when you block
		SCT_MissMsg		= "Verfehlt!";			-- Message to be displayed when you are missed
		SCT_ResistMsg		= "Widerstanden!";		-- Message to be displayed when you resist
		SCT_DeflectMsg		= "Abgewehrt!"			-- Message to be displayed when you deflect
		SCT_Absorb		= "Absorbiert!";		-- Message to be displayed when you Absorb
		SCT_LowHP		= "Wenig Gesundheit!";		-- Message to be displayed when HP is low
		SCT_LowMana		= "Wenig Mana!";		-- Message to be displayed when Mana is Low
		SCT_SelfFlag		= "*";				-- Icon to show self hits
		SCT_Berserk		= "Berserk jetzt!";		-- Message to be displayed when Troll's Berserking ability is Available
		SCT_Combat		= "+Kampf";			-- Message to be displayed when entering combat
		SCT_NoCombat		= "-Kampf";			-- Message to be displayed when leaving combat
		SCT_ComboPoint		= "CP";				-- Message to be displayed when you become a combo point
		SCT_FiveCPMessage	= "Alle Combo Punkte!Mach ihn fertig!";	-- Message to be displayed when you have 5 combo points
		SCT_Honor		= "Ehre";	                	-- Message to be displayed when gaining hnor/contribution points
	
		--startup messages
		SCT_STARTUP		= "Scrollender Kampftext "..SCT_Version.." AddOn geladen. Gib /sctmenu f\195\188r Optionen ein.";
		SCT_Options		= "Einstellungen";
	
		--nouns
		SCT_YOU			= "Ihr ";
		SCT_YOU_GAIN		= "Ihr bekommt ";
		SCT_YOU_FADE		= " schwindet von Euch.";
		SCT_TARGET		= "Ziel ";
		SCT_AFFLICTED_BY	= "Ihr seid betroffen von ";
		SCT_PROFILE		= "SCT Profil geladen: |cff00ff00";
			
		--Search Messages
		SCT_ABSORB_AMOUNT_SEARCH		= "Schaden: (%d+) (.+)";
		SCT_BLOCK_AMOUNT_SEARCH			= "Schaden (%d+). (.+)";
		SCT_BLOCK_SEARCH			= "geblockt";
		SCT_DEBUFF_NAME_SEARCH			= "Ihr seid von (.+) betroffen.";
		SCT_YOU_GAIN_AMOUNT_SEARCH		= "Ihr (%w+) (%d+) (%w+)";
		SCT_YOU_GAIN_SEARCH			= "Ihr bekommt (.+).";
		SCT_HONOR_SEARCH			= "Gesch\195\164tzte Ehrenpunkte: (%d+)";
		SCT_FADE_SEARCH				= "(.+) schwindet von Euch.";
	
		--Usage
		SCT_DISPLAY_USEAGE			= "Benutzung: \n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'Nachricht' (f\195\188r wei\195\159en Text)\n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'Nachricht' red(0-10) green(0-10) blue(0-10)\n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Beispiel: /sctdisplay 'Heile Mich' 10 0 0\nDies stellt 'Heile Mich' in hellrot dar.\n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Einige Farben: Rot = 10 0 0, Gr\195\188n = 0 10 0, Blau = 0 0 10,\nGelb = 10 10 0, Magenta = 10 0 10, Zyan = 0 10 10";
			
		--Event and Damage option values
		SCT_OPTION_EVENT1  = {name = "Schaden anzeigen", tooltipText		= "Aktiviert die Anzeige von Nahkampf und\nsonstigem (Feuer, Fallen, etc...) Schaden."};
		SCT_OPTION_EVENT2  = {name = "Fehlschlag anzeigen", tooltipText		= "Aktiviert die Anzeige wenn verfehlt."};
		SCT_OPTION_EVENT3  = {name = "Ausweichen anzeigen", tooltipText		= "Aktiviert die Anzeige wenn ausweicht."};
		SCT_OPTION_EVENT4  = {name = "Parieren anzeigen", tooltipText		= "Aktiviert die Anzeige wenn pariert."};
		SCT_OPTION_EVENT5  = {name = "Blocken anzeigen", tooltipText		= "Aktiviert die Anzeige wenn blocken."};
		SCT_OPTION_EVENT6  = {name = "Zauberschaden anzeigen", tooltipText	= "Aktiviert die Anzeige von Zauberschaden."};
		SCT_OPTION_EVENT7  = {name = "Heilspr\195\188che anzeigen", tooltipText	= "Aktiviert die Anzeige von Heilsprucheffekten."};
		SCT_OPTION_EVENT8  = {name = "Widerstehen anzeigen", tooltipText	= "Aktiviert die Anzeige wenn widerstanden."};
		SCT_OPTION_EVENT9  = {name = "Debuffs anzeigen", tooltipText		= "Aktiviert die Anzeige von\nSchw\195\164chungszaubereffekten."};
		SCT_OPTION_EVENT10 = {name = "Absorbieren anzeigen", tooltipText	= "Aktiviert die Anzeige wenn Schaden absorbiert."};
		SCT_OPTION_EVENT11 = {name = "Niedrige Gesundheit", tooltipText		= "Aktiviert die Anzeige wenn geringe Gesundheit."};
		SCT_OPTION_EVENT12 = {name = "Niedriges Mana", tooltipText		= "Aktiviert die Anzeige wenn geringes Mana."};
		SCT_OPTION_EVENT13 = {name = "Kampfboni anzeigen", tooltipText		= "Aktiviert die Anzeige wenn du Gesundheit\ndurch Tr\195\164nke, Gegenst\195\164nde, Buffs, etc...\n(keine nat\195\188rliche Regeneration) erh\195\164lst."};
		SCT_OPTION_EVENT14 = {name = "Kampfein-/austritt anzeigen", tooltipText	= "Aktiviert die Anzeige wenn du einem\nKampf beitritts oder jenen verl\195\164sst."};
		SCT_OPTION_EVENT15 = {name = "Combopunkte anzeigen", tooltipText	= "Aktiviert die Anzeige von Combopunkten."};
		SCT_OPTION_EVENT16 = {name = "Ehrenpunkte anzeigen", tooltipText        = "Aktiviert die Anzeige von Ehrenpunkten."};
		SCT_OPTION_EVENT17 = {name = "St\195\164rkungszauber anzeigen", tooltipText = "Aktiviert die Anzeige von\nSt\195\164rkungszaubern"};
		SCT_OPTION_EVENT18 = {name = "Buff schwindet anzeigen", tooltipText	= "Aktiviert die Anzeige wenn Buffs schwinden"};
			
		--Check Button option values
		SCT_OPTION_CHECK1 = { name = "Scrollender Kampftext", tooltipText	= "Aktiviert den Scrollenden Kampftext."};
		SCT_OPTION_CHECK2 = { name = "Kampftext markieren", tooltipText		= "Legt fest, ob scrollende Kampftexte in * gesetzt werden sollen."};
		SCT_OPTION_CHECK3 = { name = "Ereignisse als Nachricht", tooltipText	= "Legt fest, ob Ereignisse (freizaubern, ausweichen, etc..)\nals Nachricht auf dem Bildschrim angezeigt werden sollen."};
		SCT_OPTION_CHECK4 = { name = "Text nach unten scrollen", tooltipText	= "Legt fest, ob der Text nach unten scrollen soll oder nicht."};
		SCT_OPTION_CHECK5 = { name = "Kritische anzeigen", tooltipText		= "Legt fest, ob kritische Treffer/Heilung angezeigt werden sollen."};
		SCT_OPTION_CHECK6 = { name = "Zauber schadens Typ anzeigen", tooltipText= "Aktiviert die Zauberschadens Typ Anzeige."};
			
		--Slider options values
		SCT_OPTION_SLIDER1 = { name="Scrollgeschwindigkeit", minText="Schneller", maxText="Langsamer", tooltipText = "Legt die Animationsgeschwindigkeit des dargestellten Textes fest."};
		SCT_OPTION_SLIDER2 = { name="Textgr\195\182\195\159e", minText="Kleiner", maxText="Gr\195\182\195\159er", tooltipText = "Legt die Gr\195\182\195\159e des dargestellten Textes fest."};
		SCT_OPTION_SLIDER3 = { name=" ", minText="10%", maxText="90%", tooltipText = "Legt fest ab wieviel Prozent Gesundheit\neine Warnung angezeigt werden soll."};
		SCT_OPTION_SLIDER4 = { name="  ",  minText="10%", maxText="90%", tooltipText = "Legt fest ab wieviel Prozent Mana\neine Warnung angezeigt werden soll."};
		SCT_OPTION_SLIDER5 = { name="Text Transparenz", minText="0%", maxText="100%", tooltipText = "Legt die Transparenz des Textes fest."};
	
		-- Cosmos button
		SCT_CB_NAME		= "Scrollender Kampftext".." "..SCT_Version;
		SCT_CB_SHORT_DESC	= "von Grayhoof";
		SCT_CB_LONG_DESC	= "Zeigt Kampfnachrichten \195\188ber dem Charakter an - probier es aus!";
		--SCT_CB_ICON		= "Interface\\Icons\\Spell_Shadow_EvilEye";

end
