if ( GetLocale() == "frFR" ) then
    -- Version : French ( by Sasmira, Juki )
    -- Last Update : 06/01/2005
    
    CT_RAMENU_HOME = "CT_RaidAssist est un mod con\195\167u pour vous aider dans la gestion de raid. Il permet de surveiller la vie & la mana/energie/rage de n\'importe quel membre du raid, ainsi que de jusqu\'\195\160 5 cibles d\'unit\195\169. Vous pouvez montrer jusqu\'\195\160 4 buffs de votre choix, montrer les debuffs, et vous faire informer de cure les debuffs ou relancer les buffs.";
    
    CT_RAMENU_STEP1 = "1) Enregistrer un canal\n|c00FFFFFFAppuyer sur le bouton 'Options G\195\169n\195\169rales' ci-dessous et choisissez un canal. Notez que chaque utilisateur de ce mod dans le raid doit choisir le m\195\170me canal. Notez aussi que le mod choisi un canal par d\195\169faut nomm\195\169 |rCTNomGuilde |c00FFFFFF(sans les espaces).|r";
    
    CT_RAMENU_STEP2 = "2) Joindre le canal\n|c00FFFFFFUne fois que votre canal est choisi, appuyez sur 'Joindre Canal\' pour \195\170tre sur d\'\195\170tre dans le canal. Les leaders/promus peuvent broadcast le canal au raid, ce qui choisira le bon canal pour tout le monde, tout ce qui leur reste \195\160 faire est de taper |r/raidassist join|c00FFFFFF.|r";
    
    CT_RAMENU_STEP3 = "3) Sentez la magie !\n|c00FFFFFFLe mod devrait \195\170tre maintenant correctement configur\195\169, et pr\195\170t \195\160 l\'emploi. Vous pouvez s\195\169lectionner quels groupes montrer en les cochant ou d\195\169cochant sur la fen\195\170tre CTRaid. Pour configurer des param\195\168tres additionnels, utilisez les options ci-dessous :";
    
    CT_RAMENU_BUFFSDESCRIPT = "Selectionnez les buffs et debuffs que vous voulez montrer.\nUn max de 4 buffs peut \195\170tre montr\195\169.\nLes debuffs changeront la couleur de la fen\195\170tre avec celle que vous avez choisi.";
	CT_RAMENU_BUFFSTOOLTIP = "Utilisez les fl\195\170ches pour d\195\169placer les buffs.\nSi la limite est d\195\169pass\195\169e, ceux du haut sont prioritaires.";
	CT_RAMENU_DEBUFFSTOOLTIP = "Utilisez les fl\195\170ches pour d\195\169placer les debuffs.\nSi la limite est d\195\169pass\195\169e, ceux du haut sont prioritaires.";
    CT_RAMENU_GENERALDESCRIPT = "Ci-dessous vous trouverez les options pour changer la fa\195\167on dont les choses sont affich\195\169es. Activer une cible d\'unit\195\169 vous montrera la cible des joueurs d\195\169sign\195\169s comme Main Tank (MT). Les leaders ou les promus peuvent faire un clic droit sur un joueur dans la fen\195\170tre CTRaid et les d\195\169signer comme Main Tank (MT). Il peut y avoir jusqu\'\195\160 5 Main Tank et donc 5 cibles d\'unit\195\169. Les leaders ou les promus du raid peuvent aussi appuyer sur le bouton 'Mettre \195\160 Jour Statut' pour mettre \195\160 jour la vie, mana, et buffs pour tout le monde dans le raid.";
    CT_RAMENU_MISCDESCRIPT = "'Rapporter pour les Autres' vous permet de rapporter la vie et la mana d\'un autre joueur de votre groupe qui n\'a pas CT_RaidAssist d\'install\195\169. Leur vie et mana seront rapport\195\169s comme si ils utilisaient le mod, cependant les buffs et debuffs ne seront pas fonctionnels. Il est recommand\195\169 que tout le monde dans le raid poss\195\168de le mod.\n\nMana Conserve vous permet de auto-annuler le lancement de soins si la cible a plus de X% de vie quand le sort est sur le point d\'aboutir |c00FFFFFFet que vous \195\170tes en combat|r. Notez que vous devez garder la m\195\170me cible tout au long du lancement pour que \195\167\195\160 marche.";
    CT_RAMENU_REPORTDESCRIPT = "Cocher une case vous fait rapporter la vie et la mana pour la personne correspondante. Si vous ou la personne quitte le groupe, vous arreterez de rapporter.";
    
    BINDING_HEADER_CT_RAIDASSIST = "CT_RaidAssist";
    BINDING_NAME_CT_CUREDEBUFF = "Cure Debuffs Raid"; 
    BINDING_NAME_CT_RECASTRAIDBUFF = "Relancer Buffs Raid";
    BINDING_NAME_CT_SHOWHIDE = "Montrer/Cacher Fen\195\170tre Raid";
    BINDING_NAME_CT_TOGGLEDEBUFFS = "Afficher/Masquer Buff/Debuff";
    BINDING_NAME_CT_ASSISTMT1 = "Assister MT 1";
    BINDING_NAME_CT_ASSISTMT2 = "Assister MT 2";
    BINDING_NAME_CT_ASSISTMT3 = "Assister MT 3";
    BINDING_NAME_CT_ASSISTMT4 = "Assister MT 4";
    BINDING_NAME_CT_ASSISTMT5 = "Assister MT 5";
    
    CT_RAMENU_FAQ1 = "Q. Peut-on d\195\169placer les groupes CTRaid?";
	CT_RAMENU_FAQANSWER1 = "Assurez vous que \"Bloquer Positions Groupes\" est d\195\169coch\195\169 et que \"Montrer Noms Groupes\" est coch\195\169, ensuite faites glisser en cliquant sur 'Groupe #'.";
    CT_RAMENU_FAQ2 = "Q. Comment envoyer un message d\'alerte CTRaid?";
	CT_RAMENU_FAQANSWER2 = "Les leaders ou les promus du raid peuvent envoyer une alerte sur l\'\195\169cran \195\160 tous les membres du raid utilisant le mod en tapant /rs <texte> où <text> est votre message. Chaque personne peut changer la couleur d\'affichage de ces alertes.";
    CT_RAMENU_FAQ3 = "Q. Comment utiliser les options d\'invite?";
	CT_RAMENU_FAQANSWER3 = "Les leaders ou les promus du raid peuvent /rainvite xx-yy (/rainvite 58-60) pour inviter tous les membres de la guilde avec le level sp\195\169cifi\195\169.  /rakeyword affecte un mot de passe, si quelqu\'un vous l\'envoi (/tell), il sera automatiquement invit\195\169.";
    CT_RAMENU_FAQ4 = "Q. Certains membres du raid sont montr\195\169s comme N/A, qu\'est ce que cel\195\160 veut dire?";
	CT_RAMENU_FAQANSWER4 = "Si quelqu\'un est montr\195\169 comme N/A, c'est qu\'il ne poss\195\168de pas le mod ou qu\'il n\'est pas bien configur\195\169. Un leader ou un promu du raid peut broadcast le canal pour que tout le monde ait le m\195\170me. Ils doivent ensuite joindre le canal.";
    CT_RAMENU_FAQ5 = "Q. Le nom des membres du raid change de couleur, pourquoi?";
	CT_RAMENU_FAQANSWER5 = "Quand une personne est debuff, cel\195\160 change la couleur de fond de leur case avec la couleur que vous avez choisi dans les 'Options Buffs'. Si vous ne voulez pas voir quand quelqu\'un est debuff, d\195\169cochez simplement l\'option debuff.";
    CT_RAMENU_FAQ6 = "Q. Quand j'invite en masse, il n\'invite pas tout le monde, comment ca se fait?";
	CT_RAMENU_FAQANSWER6 = "Le jeu n\'obtient pas d\'informations \195\160 propos des membres de votre guilde avant que vous visitiez l\'onglet de guilde. Ouvrez l\'onglet de guilde et r\195\169essayez d\'inviter en masse.";
    CT_RAMENU_FAQ12 = "Pour plus d\'informations sur les mods CT, des suggestions, des commentaires, ou pour des questions sans r\195\169ponses, rendez vous sur http://www.ctmod.net";
	
	-- Class
	CT_RA_WARRIOR = "Guerrier";
	CT_RA_ROGUE = "Voleur";
	CT_RA_HUNTER = "Chasseur";
	CT_RA_MAGE = "Mage";
	CT_RA_WARLOCK = "D\195\169moniste";
	CT_RA_SHAMAN = "Chaman";
	CT_RA_PALADIN = "Paladin";
	CT_RA_DRUID = "Druide";
	CT_RA_PRIEST = "Pr\195\170tre";
	
	CT_RA_AFKMESSAGE = "Vous \195\170tes maintenant ABS : .+";
	CT_RA_DNDMESSAGE = "Vous \195\170tes maintenant en mode Ne pas d\195\169ranger : .+%.";
end

-- Spells
CT_RA_POWERWORDFORTITUDE["fr"] = { "Mot de pouvoir : Robustesse", "Pri\195\168re de robustesse" };
CT_RA_MARKOFTHEWILD["fr"] = { "Marque de la nature", "Cadeau de la nature" };
CT_RA_ARCANEINTELLECT["fr"] = { "Intelligence des arcanes", "Illumination des arcanes" };
CT_RA_ADMIRALSHAT["fr"] = "Chapeau d\'amiral";
CT_RA_SHADOWPROTECTION["fr"] = "Protection contre l\'ombre";
CT_RA_POWERWORDSHIELD["fr"] = "Mot de pouvoir : Bouclier";
CT_RA_SOULSTONERESURRECTION["fr"] = "R\195\169surrection de Pierre d\'\195\162me";
CT_RA_DIVINESPIRIT["fr"] = "Esprit divin";
CT_RA_THORNS["fr"] = "Epines";
CT_RA_FEARWARD["fr"] = "Gardien de peur";
CT_RA_BLESSINGOFMIGHT["fr"] = "B\195\169n\195\169diction de puissance";
CT_RA_BLESSINGOFWISDOM["fr"] = "B\195\169n\195\169diction de sagesse";
CT_RA_BLESSINGOFKINGS["fr"] = "B\195\169n\195\169diction des rois";  
CT_RA_BLESSINGOFSALVATION["fr"] = "B\195\169n\195\169diction de salut";
CT_RA_BLESSINGOFLIGHT["fr"] = "B\195\169n\195\169diction de lumi\195\168re";
CT_RA_BLESSINGOFSANCTUARY["fr"] = "B\195\169n\195\169diction du Sanctuaire";
CT_RA_REGROWTH["fr"] = "R\195\169tablissement";
CT_RA_REJUVENATION["fr"] = "R\195\169cup\195\169ration";
CT_RA_RENEW["fr"] = "R\195\169novation";
CT_RA_FEIGNDEATH["fr"] = "Feindre la Mort";
-- Debuffs
CT_RA_MAGIC["fr"] = "Magie";
CT_RA_DISEASE["fr"] = "Maladie";
CT_RA_POISON["fr"] = "Poison";
CT_RA_CURSE["fr"] = "Mal\195\169diction";
CT_RA_WEAKENEDSOUL["fr"] = "Ame_affaiblie";
CT_RA_RECENTLYBANDAGED["fr"] = "Un_bandage_a_\195\169t\195\169_appliqu\195\169_r\195\169cemment";

-- Cures
CT_RA_DISPELMAGIC["fr"] = "Dissiper Magie";
CT_RA_ABOLISHDISEASE["fr"] = "Abolir Maladie";
CT_RA_ABOLISHPOISON["fr"] = "Abolir le Poison";
CT_RA_CLEANSE["fr"] = "Epuration";
CT_RA_PURIFY["fr"] = "Purification";
CT_RA_CUREDISEASE["fr"] = "Gu\195\169rison des Maladies";
CT_RA_CUREPOISON["fr"] = "Gu\195\169rison du Poison";
CT_RA_REMOVECURSE["fr"] = "D\195\169livrance de la Mal\195\169diction";
CT_RA_REMOVELESSERCURSE["fr"] = "D\195\169livrance de la Mal\195\169diction Mineure";

-- Resurrections
CT_RA_RESURRECTION["fr"] = "R\195\169surrection";
CT_RA_REDEMPTION["fr"] = "R\195\169demption";
CT_RA_REBIRTH["fr"] = "Renaissance";
CT_RA_ANCESTRALSPIRIT["fr"] = "Esprit Ancestral";