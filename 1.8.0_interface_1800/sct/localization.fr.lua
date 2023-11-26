-- SCT localization information
-- French Locale
-- Initial translation by Juki <Unskilled>
-- Translation by Sasmira
-- Date 09/16/2005

if ( GetLocale() == "frFR" ) then
    
    -- Static Messages
    SCT_DodgeMsg = " esquivez !";         	-- Message to be displayed when you dodge
    SCT_ParryMsg = " parrez !";          	-- Message to be displayed when you parry
    SCT_BlockMsg = " bloquez !";   	-- Message to be displayed when you block
    SCT_MissMsg = " rate !";       		-- Message to be displayed when you are missed
    SCT_ResistMsg = " r\195\169sistez !"; 	-- Message to be displayed when you resist
    SCT_DeflectMsg = " r\195\169viez !" 		-- Message to be displayed when you deflect
    SCT_Absorb= " Absorb\195\169 !";     	-- Message to be displayed when you Absorb
    SCT_LowHP= "Vie Faible !";          	-- Message to be displayed when HP is low
    SCT_LowMana= "Mana Faible !";       	-- Message to be displayed when Mana is Low
    SCT_SelfFlag = "*";                 	-- Icon to show self hits
    SCT_Berserk= "Berserk Now!";		-- Message to be displayed when Troll\'s Berserking ability is Available
    SCT_Combat = "+ Combat";			-- Message to be displayed when entering combat
    SCT_NoCombat = "- Combat";			-- Message to be displayed when leaving combat
    SCT_ComboPoint = "Points de Combo ";    	-- Message to be displayed when gaining a combo point
    SCT_FiveCPMessage = " ... A Mooort !!!";    -- Message to be displayed when you have 5 combo points
    SCT_Honor = "Honneur";			-- Message to be displayed when gaining hnor/contribution points
    
    --startup messages
    SCT_STARTUP = "Scrolling Combat Text "..SCT_Version.." charg\195\169. Tapez /sctmenu pour les options.";
    SCT_Options = "SCT Options";
    
    --nouns
    SCT_YOU = "Vous";
    SCT_YOU_GAIN = "Vous gagnez ";
    SCT_YOU_FADE = " vient de se dissiper";
    SCT_TARGET = "La cible";
    SCT_AFFLICTED_BY = "Vous \195\170tes afflig\195\169 par ";
    SCT_PROFILE = "SCT Profil charg\195\169 : |cff00ff00";
    
    --Search Messages
		SCT_ABSORB_AMOUNT_SEARCH = "vous inflige (%d+) points de d\195\169g\195\162ts (.+)";
		SCT_BLOCK_AMOUNT_SEARCH = "vous touche et inflige (%d+) points de d\195\169g\195\162ts. (.+)";
        SCT_BLOCK_SEARCH = "bloqu\195\169";
        SCT_DEBUFF_NAME_SEARCH = "Vous subissez les effets de (.+).";
		SCT_YOU_GAIN_AMOUNT_SEARCH = "Vous (%w+) (%d+) (%w+)";
		SCT_YOU_GAIN_SEARCH = "Vous gagnez (.+).";
		SCT_HONOR_SEARCH = "Points d\'Honneur : (%d+)";
        SCT_FADE_SEARCH = "(.+) vient de se dissiper.";
    
    --Useage
    SCT_DISPLAY_USEAGE = "Utilisation : \n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' (pour du texte blanc)\n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "/sctdisplay 'message' rouge(0-10) vert(0-10) bleu(0-10)\n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Exemple : /sctdisplay 'Soignez Moi' 10 0 0\nCela affichera 'Soignez Moi' en rouge vif\n";
    SCT_DISPLAY_USEAGE = SCT_DISPLAY_USEAGE .. "Quelques Couleurs : rouge = 10 0 0, vert = 0 10 0, bleu = 0 0 10,\njaune = 10 10 0, violet = 10 0 10, cyan = 0 10 10";
    
    --Event and Damage option values
		SCT_OPTION_EVENT1 = {name = "Montrer D\195\169g\195\162ts", tooltipText = "Activer/D\195\169sactiver les d\195\169g\195\162ts de m\195\169l\195\169e et divers (feu, chute, etc...)."};
		SCT_OPTION_EVENT2 = {name = "Montrer Rat\195\169s", tooltipText = "Activer/D\195\169sactiver les coups rat\195\169s"};
		SCT_OPTION_EVENT3 = {name = "Montrer D\195\169vi\195\169s", tooltipText = "Activer/D\195\169sactiver les coups d\195\169vi\195\169s"};
		SCT_OPTION_EVENT4 = {name = "Montrer Parades", tooltipText = "Activer/D\195\169sactiver les coups par\195\169s"};
		SCT_OPTION_EVENT5 = {name = "Montrer Bloqu\195\169s", tooltipText = "Activer/D\195\169sactiver les coups bloqu\195\169s"};
		SCT_OPTION_EVENT6 = {name = "Montrer D\195\169g\195\162ts Sorts", tooltipText = "Activer/D\195\169sactiver les d\195\169g\195\162ts de sorts"};
		SCT_OPTION_EVENT7 = {name = "Montrer Sorts Soins", tooltipText = "Activer/D\195\169sactiver les sorts de soins"};
		SCT_OPTION_EVENT8 = {name = "Montrer Sorts Resist\195\169s", tooltipText = "Activer/D\195\169sactiver les sorts r\195\169sist\195\169s"};
		SCT_OPTION_EVENT9 = {name = "Montrer Debuffs", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque vous \195\170tes debuffs"};
		SCT_OPTION_EVENT10 = {name = "Montrer Absorb\195\169s", tooltipText = "Activer/D\195\169sactiver les d\195\169g\195\162ts absorb\195\169s"};
		SCT_OPTION_EVENT11 = {name = "Montrer Vie Faible", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque votre vie est faible"};
		SCT_OPTION_EVENT12 = {name = "Montrer Mana Faible", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque votre mana est faible"};
		SCT_OPTION_EVENT13 = {name = "Montrer Gains d\'Energie", tooltipText = "Activer/D\195\169sactiver l\'affichage des gains de Mana, Rage, Energie\ndes potions, obejts, buffs, etc...(pas des r\195\169g\195\169ration naturelle)"};
		SCT_OPTION_EVENT14 = {name = "Montrer Mode Combat", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque vous rentrez ou sortez d\'un combat"};
		SCT_OPTION_EVENT15 = {name = "Montrer Points de Combo", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque vous gagnez des points de combo"};
		SCT_OPTION_EVENT16 = {name = "Montrer les Points d\'Honneur", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque vous gagnez des points d\'Honneur"};
		SCT_OPTION_EVENT17 = {name = "Montrer Buffs", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque vous \195\170tes buffs"};
        SCT_OPTION_EVENT18 = {name = "Dissipation des Buffs", tooltipText = "Activer/D\195\169sactiver l\'affichage lorsque les buffs se dissipent"};
		
		--Check Button option values
		SCT_OPTION_CHECK1 = { name = "Scrolling Combat Text", tooltipText = "Activer/D\195\169sactiver Scrolling Combat Text"};
		SCT_OPTION_CHECK2 = { name = "Mode Combat", tooltipText = "Activer/D\195\169sactiver l\'affichage de * autour de tous les Scrolling Combat Text"};
		SCT_OPTION_CHECK3 = { name = "Montrer Ev\195\169nements", tooltipText = "Activer/D\195\169sactiver l\'affichage des \195\169v\195\169nements (Parade, etc...) comme message à l\'\195\169cran"};
		SCT_OPTION_CHECK4 = { name = "Affichage vers le Bas", tooltipText = "Activer/D\195\169sactiver le d\195\169roulement du texte vers le bas"};
		SCT_OPTION_CHECK5 = { name = "Critiques", tooltipText = "Activer/D\195\169sactiver les coups/soins critiques au dessus de votre t\195\170te"};
        SCT_OPTION_CHECK6 = { name = "Type de Sorts", tooltipText = "Activer/D\195\169sactiver l\'affichage du type de dommage caus\195\169 par les Sorts"};
		
		--Slider options values
		SCT_OPTION_SLIDER1 = { name="Vitesse du Texte", minText="Rapide", maxText="Lent", tooltipText = "Contr\195\180le la vitesse d\'animation du texte d\195\169roulant"};
		SCT_OPTION_SLIDER2 = { name="Taille Texte", minText="Petit", maxText="Grand", tooltipText = "Contr\195\180le la taille du texte d\195\169roulant"};
		SCT_OPTION_SLIDER3 = { name=" ", minText="10%", maxText="90%", tooltipText = "Contr\195\180le le % de vie n\195\169cessaire pour donner un avertissement"};
		SCT_OPTION_SLIDER4 = { name="  ",  minText="10%", maxText="90%", tooltipText = "Contr\195\180le le % de mana n\195\169cessaire pour donner un avertissement"};
		SCT_OPTION_SLIDER5 = { name="Transparence", minText="0%", maxText="100%", tooltipText = "Contr\195\180le la transparence du texte"};

		-- Cosmos button
		SCT_CB_NAME		= "Scrolling Combat Text".." "..SCT_Version;
		SCT_CB_SHORT_DESC	= "Par Grayhoof";
		SCT_CB_LONG_DESC	= "Affiche les messages de combat au dessus du personnage";
		SCT_CB_ICON		= "Interface\\Icons\\Spell_Shadow_EvilEye"; -- "Interface\\Icons\\Spell_Shadow_FarSight"
	
end

