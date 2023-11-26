--Version
SCT_Version = "v3.0";

--Everything From here on would need to be translated and put
--into if statements for each specific language.

--***********
--ENGLISH
--***********

-- Static Messages
SCT_DodgeMsg = "Dodge!";					-- Message to be displayed when you dodge
SCT_ParryMsg = "Parry!";					-- Message to be displayed when you parry
SCT_BlockMsg = "Block!";					-- Message to be displayed when you block
SCT_MissMsg = "Missed!";					-- Message to be displayed when you are missed
SCT_ResistMsg = "Resisted!";			-- Message to be displayed when you resist
SCT_DeflectMsg = "Deflected!" 		-- Message to be displayed when you deflect
SCT_Absorb= "Absorbed!";					-- Message to be displayed when you Absorb
SCT_LowHP= "Low Health!";					-- Message to be displayed when HP is low
SCT_LowMana= "Low Mana!";					-- Message to be displayed when Mana is Low
SCT_SelfFlag = "*";								-- Icon to show self hits
SCT_Berserk = "Berserk Now!";			-- Message to be displayed when Troll's Berserking ability is Available
SCT_Combat = "+Combat";						-- Message to be displayed when entering combat
SCT_NoCombat = "-Combat";					-- Message to be displayed when leaving combat
SCT_ComboPoint = "CP";			  		-- Message to be displayed when gaining a combo point
SCT_FiveCPMessage = "Finish It!"; -- Message to be displayed when you have 5 combo points
SCT_Honor = "Honor";							-- Message to be displayed when gaining hnor/contribution points

--startup messages
SCT_STARTUP = "Scrolling Combat Text "..SCT_Version.." AddOn loaded. Type /sct for options.";

--nouns
SCT_YOU = "You ";
SCT_TARGET = "Target ";
SCT_AFFLICTED_BY = "You are afflicted by ";
SCT_PROFILE = "SCT Profile Loaded: |cff00ff00";

--Search Messages
SCT_ABSORB_AMOUNT_SEARCH = "hits you for (%d+) (.+)";
SCT_BLOCK_AMOUNT_SEARCH = "hits you for (%d+). (.+)";
SCT_DEBUFF_NAME_SEARCH = "You are afflicted by (.+).";
SCT_YOU_GAIN_AMOUNT_SEARCH = "You gain (%d+) (%w+)";
SCT_HONOR_SEARCH = "Estimated Honor Points: (%d+)";

--Useage
SCT_DISPLAY_USEAGE = "Useage: \n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' (for white text)\n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' red(0-10) green(0-10) blue(0-10)\n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Example: /sctdisplay 'Heal Me' 10 0 0\nThis will display 'Heal Me' in bright red\n";
SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Some Colors: red = 10 0 0, green = 0 10 0, blue = 0 0 10,\nyellow = 10 10 0, magenta = 10 0 10, cyan = 0 10 10";

--Event and Damage option values
SCT_OPTION_EVENT1 = {name = "Show Damage", tooltipText = "Enables or Disables melee and misc. (fire, fall, etc...) damage"};
SCT_OPTION_EVENT2 = {name = "Show Misses", tooltipText = "Enables or Disables melee misses"};
SCT_OPTION_EVENT3 = {name = "Show Dodges", tooltipText = "Enables or Disables melee dodges"};
SCT_OPTION_EVENT4 = {name = "Show Parries", tooltipText = "Enables or Disables melee parries"};
SCT_OPTION_EVENT5 = {name = "Show Blocks", tooltipText = "Enables or Disables melee blocks and partial blocks"};
SCT_OPTION_EVENT6 = {name = "Show Spells Damage", tooltipText = "Enables or Disables spell damage"};
SCT_OPTION_EVENT7 = {name = "Show Spell Heals", tooltipText = "Enables or Disables spell heals"};
SCT_OPTION_EVENT8 = {name = "Show Spell Resists", tooltipText = "Enables or Disables spell resists"};
SCT_OPTION_EVENT9 = {name = "Show Debuffs", tooltipText = "Enables or Disables showing when you get debuffs"};
SCT_OPTION_EVENT10 = {name = "Show Absorb", tooltipText = "Enables or Disables showing when monsters damage is absorbed"};
SCT_OPTION_EVENT11 = {name = "Show Low HP", tooltipText = "Enables or Disables showing when you have low health"};
SCT_OPTION_EVENT12 = {name = "Show Low Mana", tooltipText = "Enables or Disables showing when you have low mana"};
SCT_OPTION_EVENT13 = {name = "Show Power Gains", tooltipText = "Enables or Disables showing when you gain Mana, Rage, Energy\nfrom potions, items, buffs, etc...(Not regular regen)"};
SCT_OPTION_EVENT14 = {name = "Show Combat Flags", tooltipText = "Enables or Disables showing when you enter or leave combat"};
SCT_OPTION_EVENT15 = {name = "Show Combo Point Gains", tooltipText = "Enables or Disables showing when you gain combo points"};
SCT_OPTION_EVENT16 = {name = "Show Honor Contribution", tooltipText = "Enables or Disables showing when you gain Honor Contribution points"};

--Check Button option values
SCT_OPTION_CHECK1 = { name = "Enable Scrolling Combat Text", tooltipText = "Enables or Disables the Scrolling Combat Text"};
SCT_OPTION_CHECK2 = { name = "Flag Combat Text", tooltipText = "Enables or Disables placing a * around all Scrolling Combat Text"};
SCT_OPTION_CHECK3 = { name = "Show Events as Message", tooltipText = "Enables or Disables making events display (dodge, etc...)\nas static text messages on screen (not scrolling)"};
SCT_OPTION_CHECK4 = { name = "Scroll Text Down", tooltipText = "Enables or Disables scrolling text downwards"};
SCT_OPTION_CHECK5 = { name = "Sticky Crits", tooltipText = "Enables or Disables having crtical hits/heals stick above your head"};

--Slider options values
SCT_OPTION_SLIDER1 = { name="Text Animation Speed", minText="Faster", maxText="Slower", tooltipText = "Controls the speed at which the text animation scrolls"};
SCT_OPTION_SLIDER2 = { name="Text Size", minText="Smaller", maxText="Larger", tooltipText = "Controls the size of the scrolling text"};
SCT_OPTION_SLIDER3 = { name=" ", minText="10%", maxText="90%", tooltipText = "Controls the % of health needed to give a warning"};
SCT_OPTION_SLIDER4 = { name="  ",  minText="10%", maxText="90%", tooltipText = "Controls the % of mana needed to give a warning"};
SCT_OPTION_SLIDER5 = { name="Text Opacity", minText="0%", maxText="100%", tooltipText = "Controls the opacity of the text"};


--***********
--FRENCH
--***********
if ( GetLocale() == "frFR" ) then
    -- Traduit par Juki <Unskilled>
    
    -- Static Messages
    SCT_DodgeMsg = "Esquive !";         -- Message to be displayed when you dodge
    SCT_ParryMsg = "Parade !";          -- Message to be displayed when you parry
    SCT_BlockMsg = "Bloqu� !";          -- Message to be displayed when you block
    SCT_MissMsg = "Cible Rate !";       -- Message to be displayed when you are missed
    SCT_ResistMsg = "Resist� !";        -- Message to be displayed when you resist
    SCT_DeflectMsg = "Devier !" 				-- Message to be displayed when you deflect
    SCT_Absorb= "Absorb� !";            -- Message to be displayed when you Absorb
    SCT_LowHP= "Vie Faible !";          -- Message to be displayed when HP is low
    SCT_LowMana= "Mana Faible !";       -- Message to be displayed when Mana is Low
    SCT_SelfFlag = "*";                 -- Icon to show self hits
    SCT_Berserk= "Berserk Now!";				-- Message to be displayed when Troll's Berserking ability is Available
		SCT_Combat = "+Combat";							-- Message to be displayed when entering combat
		SCT_NoCombat = "-Combat";						-- Message to be displayed when leaving combat
		SCT_ComboPoint = "CP";			  			-- Message to be displayed when gaining a combo point
		SCT_FiveCPMessage = "Finish It!"; 	-- Message to be displayed when you have 5 combo points
		SCT_Honor = "Honor";								-- Message to be displayed when gaining hnor/contribution points
    
    --startup messages
    SCT_STARTUP = "Scrolling Combat Text "..SCT_Version.." AddOn charg�. Tapez /sct pour les options.";
    
    --nouns
    SCT_YOU = "";
    SCT_TARGET = "";
    SCT_AFFLICTED_BY = "Vous �tes afflig�s par ";
    SCT_PROFILE = "SCT Profile Loaded: |cff00ff00";
    
    --Search Messages

		SCT_ABSORB_AMOUNT_SEARCH = "vous inflige (%d+) points de d�g�ts (.+)";
		SCT_BLOCK_AMOUNT_SEARCH = "vous touche et inflige (%d+) points de d�g�ts. (.+)";
		SCT_DEBUFF_NAME_SEARCH = "Vous subissez les effets de (.+).";
		SCT_YOU_GAIN_AMOUNT_SEARCH = "Vous gagnez (%d+) (%w+)";
		SCT_HONOR_SEARCH = "Estimated Honor Points: (%d+)";
    
    --Useage
    SCT_DISPLAY_USEAGE = "Utilisation : \n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' (pour du texte blanc)\n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' rouge(0-10) vert(0-10) bleu(0-10)\n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Exemple : /sctdisplay 'Soignez Moi' 10 0 0\nCela affichera 'Soignez Moi' en rouge vif\n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Quelques Couleurs : rouge = 10 0 0, vert = 0 10 0, bleu = 0 0 10,\njaune = 10 10 0, violet = 10 0 10, cyan = 0 10 10";
    
    --Event and Damage option values
		SCT_OPTION_EVENT1 = {name = "Montrer D�g�ts", tooltipText = "Activer/D�sactiver les d�g�ts de melee et divers (feu, chute, etc...)."};
		SCT_OPTION_EVENT2 = {name = "Montrer Rat�s", tooltipText = "Activer/D�sactiver les coups rat�s"};
		SCT_OPTION_EVENT3 = {name = "Montrer D�vi�s", tooltipText = "Activer/D�sactiver les coups d�vi�s"};
		SCT_OPTION_EVENT4 = {name = "Montrer Parades", tooltipText = "Activer/D�sactiver les coups par�s"};
		SCT_OPTION_EVENT5 = {name = "Montrer Bloqu�s", tooltipText = "Activer/D�sactiver les coups bloqu�s"};
		SCT_OPTION_EVENT6 = {name = "Montrer D�g�ts Sorts", tooltipText = "Activer/D�sactiver les d�g�ts de sorts"};
		SCT_OPTION_EVENT7 = {name = "Montrer Sorts Soins", tooltipText = "Activer/D�sactiver les sorts de soins"};
		SCT_OPTION_EVENT8 = {name = "Montrer Sorts Resist�s", tooltipText = "Activer/D�sactiver les sorts resist�s"};
		SCT_OPTION_EVENT9 = {name = "Montrer Debuffs", tooltipText = "Activer/D�sactiver l'affichage lorsque vous �tes debuffs"};
		SCT_OPTION_EVENT10 = {name = "Montrer Absorb�s", tooltipText = "Activer/D�sactiver les d�g�ts absorb�s"};
		SCT_OPTION_EVENT11 = {name = "Montrer Vie Faible", tooltipText = "Activer/D�sactiver l'affichage lorsque votre vie est faible"};
		SCT_OPTION_EVENT12 = {name = "Montrer Mana Faible", tooltipText = "Activer/D�sactiver l'affichage lorsque votre mana est faible"};
		SCT_OPTION_EVENT13 = {name = "Show Power Gains", tooltipText = "Enables or Disables showing when you gain Mana, Rage, Energy\nfrom potions, items, buffs, etc...(Not regular regen)"};
		SCT_OPTION_EVENT14 = {name = "Show Combat Flags", tooltipText = "Enables or Disables showing when you enter or leave combat"};
		SCT_OPTION_EVENT15 = {name = "Montrer Points de Combo", tooltipText = "Enables or Disables showing when you gain combo points"};
		SCT_OPTION_EVENT16 = {name = "Show Honor Contribution", tooltipText = "Enables or Disables showing when you gain Honor Contribution points"};
		
		--Check Button option values
		SCT_OPTION_CHECK1 = { name = "Scrolling Combat Text", tooltipText = "Activer/D�sactiver Scrolling Combat Text"};
		SCT_OPTION_CHECK2 = { name = "Flag Texte Combat", tooltipText = "Activer/D�sactiver l'affichage de * autour de tous les Scrolling Combat Text"};
		SCT_OPTION_CHECK3 = { name = "Montrer Ev�nements", tooltipText = "Activer/D�sactiver l'affichage des �v�nements (Parade, etc...) comme message � l'�cran"};
		SCT_OPTION_CHECK4 = { name = "D�roulement Texte Bas", tooltipText = "Activer/D�sactiver le d�roulement du texte vers le bas"};
		SCT_OPTION_CHECK5 = { name = "Sticky Crits", tooltipText = "Enables or Disables having crtical hits/heals stick above your head"};
		
		--Slider options values
		SCT_OPTION_SLIDER1 = { name="Vitesse Animation Texte", minText="Rapide", maxText="Lent", tooltipText = "Contr�le la vitesse d'animation du texte d�roulant"};
		SCT_OPTION_SLIDER2 = { name="Taille Texte", minText="Petit", maxText="Grand", tooltipText = "Contr�le la taille du texte d�roulant"};
		SCT_OPTION_SLIDER3 = { name=" ", minText="10%", maxText="90%", tooltipText = "Contr�le le % de vie n�cessaire pour donner un avertissement"};
		SCT_OPTION_SLIDER4 = { name="  ",  minText="10%", maxText="90%", tooltipText = "Contr�le le % de mana n�cessaire pour donner un avertissement"};
		SCT_OPTION_SLIDER5 = { name="Text Opacity", minText="0%", maxText="100%", tooltipText = "Controls the opacity of the text"};
		
end

--***********
--GERMAN
--***********
if ( GetLocale() == "deDE" ) then
    -- By Endymion
    
    -- Static Messages
    SCT_DodgeMsg = "Ausweichen !";      -- Message to be displayed when you dodge
    SCT_ParryMsg = "Parieren !";        -- Message to be displayed when you parry
    SCT_BlockMsg = "Blocken !";         -- Message to be displayed when you block
    SCT_MissMsg = "Fehlschlag !";       -- Message to be displayed when you are missed
    SCT_ResistMsg = "Widerstehen !";    -- Message to be displayed when you resist
    SCT_Absorb= "Absorbiert !";         -- Message to be displayed when you Absorb
    SCT_DeflectMsg = "Abwehren !"				-- Message to be displayed when you deflect
    SCT_LowHP= "Wenig Gesundheit !";    -- Message to be displayed when HP is low
    SCT_LowMana= "Wenig Mana !";       	-- Message to be displayed when Mana is Low
    SCT_SelfFlag = "*";                 -- Icon to show self hits
    SCT_Berserk= "Berserk Now!";				-- Message to be displayed when Troll's Berserking ability is Available
    SCT_Combat = "+Kampf";							-- Message to be displayed when entering combat
		SCT_NoCombat = "-Kampf";						-- Message to be displayed when leaving combat
		SCT_ComboPoint = "CP";			  			-- Message to be displayed when gaining a combo point
		SCT_FiveCPMessage = "Finish It!"; 	-- Message to be displayed when you have 5 combo points
		SCT_Honor = "Honor";								-- Message to be displayed when gaining hnor/contribution points
    
    --startup messages
    SCT_STARTUP = "Scrolling Combat Text "..SCT_Version.." AddOn loaded. Type /sct for options.";
    
    --nouns
    SCT_YOU = "";
    SCT_TARGET = "";
    SCT_AFFLICTED_BY = "Ihr seid von ";
    SCT_PROFILE = "SCT Profile Loaded: |cff00ff00";
    
    --Search Messages

		SCT_ABSORB_AMOUNT_SEARCH = "Schaden: (%d+) (.+)";
		SCT_BLOCK_AMOUNT_SEARCH = "Schaden (%d+). (.+)";
		SCT_DEBUFF_NAME_SEARCH = "Ihr seid von (.+) betroffen.";
		SCT_YOU_GAIN_AMOUNT_SEARCH = "Ihr bekommt (%d+) (%w+)";
		SCT_HONOR_SEARCH = "Estimated Honor Points: (%d+)";
    
    SCT_DISPLAY_USEAGE = "Useage: \n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' (for white text)\n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' red(0-10) green(0-10) blue(0-10)\n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Example: /sctdisplay 'Heal Me' 10 0 0\nThis will display 'Heal Me' in bright red\n";
		SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Some Colors: red = 10 0 0, green = 0 10 0, blue = 0 0 10,\nyellow = 10 10 0, magenta = 10 0 10, cyan = 0 10 10";
		
		--Event and Damage option values
		SCT_OPTION_EVENT1 = {name = "Show Damage", tooltipText = "Aktiviert oder Deaktiviert Nahkampf und sonstigen (Feuer, fallen, etc...) Schaden"};
		SCT_OPTION_EVENT2 = {name = "Show Fehlschlag", tooltipText = "Aktiviert oder Deaktiviert Nahkampf Verfehlungen"};
		SCT_OPTION_EVENT3 = {name = "Show Ausweichen", tooltipText = "Aktiviert oder Deaktiviert Nahkampf ausweichen"};
		SCT_OPTION_EVENT4 = {name = "Show Parieren", tooltipText = "Aktiviert oder Deaktiviert Nahkampf parieren"};
		SCT_OPTION_EVENT5 = {name = "Show Blocks", tooltipText = "Aktiviert oder Deaktiviert blocken"};
		SCT_OPTION_EVENT6 = {name = "Show Zauberschaden", tooltipText = "Aktiviert oder Deaktiviert Zauberschaden"};
		SCT_OPTION_EVENT7 = {name = "Show Heilspr�che", tooltipText = "Aktiviert oder Deaktiviert Heilspr�che"};
		SCT_OPTION_EVENT8 = {name = "Show Widerstehen", tooltipText = "Aktivert oder Deaktiviert widerstehen"};
		SCT_OPTION_EVENT9 = {name = "Show Debuffs", tooltipText = "Aktiviert oder Deaktiviert ob Schw�chungszauber angezeigt werden sollen"};
		SCT_OPTION_EVENT10 = {name = "Show Absorbiert", tooltipText = " Aktiviert oder Deaktiviert ob absorbieren von Schaden angezeigt werden soll"};
		SCT_OPTION_EVENT11 = {name = "Show Low Gesundheit", tooltipText = "Aktiviert oder Deaktiviert ob geringe Gesundheit angezeigt werden soll "};
		SCT_OPTION_EVENT12 = {name = "Show Low Mana", tooltipText = "Aktiviert oder Deaktiviert ob geringes Mana angezeigt werden soll"};
		SCT_OPTION_EVENT13 = {name = "Show Power Gains", tooltipText = "Aktiviert oder Deaktiviert on angezeigt werden soll wenn du Gesundheit von Tr�nken, Items, Buffs, etc...(keine nat�rliche Regeneration) erh�lst"};
		SCT_OPTION_EVENT14 = {name = "Show Combat Flags", tooltipText = "Enables or Disables showing when you enter or leave combat"};
		SCT_OPTION_EVENT15 = {name = "Show Combopunkte", tooltipText = "Aktivert oder Deaktiviert Combopunkte"};
		SCT_OPTION_EVENT16 = {name = "Show Honor Contribution", tooltipText = "Enables or Disables showing when you gain Honor Contribution points"};
		
		--Check Button option values
		SCT_OPTION_CHECK1 = { name = "Scrolling Combat Text", tooltipText = "Aktiviert oder Deaktiviert Scrolling Combat Text"};
		SCT_OPTION_CHECK2 = { name = "Flag Combat Text", tooltipText = "Aktiviert oder Deaktiviert ob Scrolling Combat Text in * gesetzt werden soll"};
		SCT_OPTION_CHECK3 = { name = "Show Events as Message", tooltipText = "Aktiviert oder Deaktiviert ob Ereignisse (Freizaubern, ausweichen, etc..) als Nachricht auf dem Bildschrim angezeigt werden sollen"};
		SCT_OPTION_CHECK4 = { name = "Scroll Text Down", tooltipText = "Aktiviert oder Deaktiviert Text runter scrollen zu lassen"};
		SCT_OPTION_CHECK5 = { name = "Sticky Crits", tooltipText = "Aktiviert oder Deaktiviert ob kritische Treffer/Heilung �ber deinem Kopf angezeigt werden sollen"};
		
		--Slider options values
		SCT_OPTION_SLIDER1 = { name="Text Animation Speed", minText="Faster", maxText="Slower", tooltipText = "Kontrolliert die Animationsgeschwindigkeit des dargestellten Textes"};
		SCT_OPTION_SLIDER2 = { name="Text Size", minText="Smaller", maxText="Larger", tooltipText = "Kontrolliert die Gr��e des dargestellten Textes"};
		SCT_OPTION_SLIDER3 = { name=" ", minText="10%", maxText="90%", tooltipText = "Kontrolliert ab wieviel % Gesundheit eine Warnung angezeigt wird"};
		SCT_OPTION_SLIDER4 = { name="  ",  minText="10%", maxText="90%", tooltipText = "Kontrolliert ab wieviel % Mana eine Warnung angezeigt wird"};
		SCT_OPTION_SLIDER5 = { name="Text Opacity", minText="0%", maxText="100%", tooltipText = "Controls the opacity of the text"};
		
end
