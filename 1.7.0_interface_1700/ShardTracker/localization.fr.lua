-- Version     : French
-- Translation : Riswaaq, Sasmira, Algent)
-- Last Update : 04/18/2005


if (GetLocale() == "frFR") then

    BINDING_HEADER_SHARDTRACKERHEADER       = "ShardTracker";
    BINDING_NAME_SHARDTRACKER               = "ShardTracker Toggle";

    -- cosmos variables
    SHARDTRACKER_CONFIG_HEADER              = "ShardTracker";
    SHARDTRACKER_CONFIG_HEADER_INFO         = "ShardTracker Permet aux d\195\169monistes de garder un oeil sur leurs diff\195\169rentes pierres et leurs fragments d\'\195\162me via de petits boutons attach\195\169s \195\160 la minimap.";
    SHARDTRACKER_CONFIG_ENABLED             = "Activer ShardTracker";
    SHARDTRACKER_CONFIG_ENABLED_INFO        = "Active/D\195\169sactive le plugin.";
    SHARDTRACKER_CONFIG_FLASH_HEALTH        = "Fait clignoter l\'icone de pierre de soin.";
    SHARDTRACKER_CONFIG_FLASH_HEALTH_INFO   = "Fait clignoter l\'icone de pierre de soin quand vous n\'en avez pas dans votre inventaire.";
    SHARDTRACKER_CONFIG_SOUND               = "Activer les sons d\'alerte.";
    SHARDTRACKER_CONFIG_SOUND_INFO          = "Lance un son quand une pierre d\'\195\162me a expir\195\169e et quand un membre du groupe a besoin d\'une autre pierre de soin.";
    SHARDTRACKER_CONFIG_SOULPOP             = "Autoriser les fen\195\170tres d\'alerte pour les pierres d\'\195\162me.";
    SHARDTRACKER_CONFIG_SOULPOP_INFO        = "Affiche une fen\195\170tres d\'alerte lorsque la minuterie de votre pierre d\'\195\162me \195\160 expir\195\169e.";
    SHARDTRACKER_CONFIG_MONITOR_PARTY       = "G\195\169rer les pierres de soin de votre groupe";
    SHARDTRACKER_CONFIG_MONITOR_PARTY_INFO  = "Autoriser la gestion des pierres de soin de votre groupe et des alertes en cas de besoin de pierre.";
    SHARDTRACKER_CONFIG_RESTRICT            = "Restreindre les messages du groupe.";
    SHARDTRACKER_CONFIG_RESTRICT_INFO       = "Restreindre les messages de gestion des pierres de soin \195\160 une liste de joueurs.";
    SHARDTRACKER_RESET                      = "R\195\169initialiser la position des boutons";
    SHARDTRACKER_RESET_INFO                 = "D\195\169place les boutons du ShardTracker \195\160 leur position initiale.";
    SHARDTRACKER_RESET_NAME                 = "R\195\169initialiser";
    SHARDTRACKER_CENTER                     = "Centrer la position des boutons";
    SHARDTRACKER_CENTER_INFO                = "D\195\169place les boutons du ShardTracker au centre de l\'\195\169cran.";
    SHARDTRACKER_CENTER_NAME                = "Centrer";

    -- slash commands 
    -- NOTE: if translating these, make sure they remain single-word only
    SHARDTRACKER_DEBUG_CMD       = "debug";
    SHARDTRACKER_TOGGLE_CMD      = "toggle";
    SHARDTRACKER_ON_CMD          = "on";
    SHARDTRACKER_OFF_CMD         = "off";
    SHARDTRACKER_BAG_CMD         = "bag";
    SHARDTRACKER_SORT_CMD        = "sort";
    SHARDTRACKER_LIMIT_CMD       = "limit";
    SHARDTRACKER_SOUND_CMD       = "sound";
    SHARDTRACKER_MONITOR_CMD     = "monitor";
    SHARDTRACKER_HELP_CMD        = "help";
    SHARDTRACKER_FLASH_CMD       = "flash";
    SHARDTRACKER_LOCK_CMD        = "lock";
    SHARDTRACKER_UNLOCK_CMD      = "unlock";
    SHARDTRACKER_INFO_CMD        = "info";
    SHARDTRACKER_RESET_CMD       = "reset";
    SHARDTRACKER_CENTER_CMD      = "center";
    SHARDTRACKER_TOGGLE_CMD      = "toggle";
    SHARDTRACKER_SCALE_CMD       = "scale";
    SHARDTRACKER_SCALE_1_CMD     = "regular";
    SHARDTRACKER_SCALE_2_CMD     = "large";
    SHARDTRACKER_SCALE_3_CMD     = "biggie";
    SHARDTRACKER_SCALE_4_CMD     = "supersizeme";
    SHARDTRACKER_SOUL_POPUP_CMD  = "soulpopup";
    SHARDTRACKER_SHARDBG_CMD     = "shardbg";
    SHARDTRACKER_RESTRICT_CMD    = "restrict";
    SHARDTRACKER_ADD_CMD         = "add";
    SHARDTRACKER_REMOVE_CMD      = "remove";
    SHARDTRACKER_LIST_CMD        = "list";
    SHARDTRACKER_SOULSOUND_CMD   = "soulsound";
    SHARDTRACKER_HEALTHSOUND_CMD = "healthsound";
    SHARDTRACKER_FLASHY_CMD      = "flashy";
    SHARDTRACKER_NAGSOUL_CMD     = "healthnag";
    SHARDTRACKER_NAGHEALTH_CMD   = "soulnag";
    SHARDTRACKER_NAGCOUNT_CMD    = "nagcount";
    SHARDTRACKER_NAGFREQ_CMD     = "nagfrequency";
    SHARDTRACKER_MAXSHARDS_CMD   = "maxshards";
    
    -- Messages used to sync healthstone status
    SHARDTRACKER_GOT_HEALTHSTONE_MSG            = "Pierre de soin recue!";
    SHARDTRACKER_NEED_HEALTHSTONE_MSG           = "Besoin de pierre de soin!";
    SHARDTRACKER_REQUEST_HEALTHSTONE_STATUS_MSG = "ShardTracker n\195\169c\195\169ssite une mise \195\160 jour de synchronisation.";
    SHARDTRACKER_SYNC_HEALTHSTONE_YES_MSG       = "a une pierre de soin.";
    SHARDTRACKER_SYNC_HEALTHSTONE_NO_MSG        = "n\'a pas de pierre de soin.";
    SHARDTRACKER_CHAT_PREFIX                    = "<ST>";

    -- tooltip text
    SHARDTRACKER_SHARDBUTTON_TIP1           = "Bouton des fragments d\'\195\162me";
    SHARDTRACKER_SHARDBUTTON_TIP2           = "Montre le nombre de fragments d\'\195\162me dans votre sac.";
    SHARDTRACKER_SHARDBUTTON_TIP3           = "Cliquez pour trier vos fragments d\'\195\162me dans votre sac";
    SHARDTRACKER_SHARDBUTTON_TIP4           = "specifié par /shardtracker bag [0-4].";

    SHARDTRACKER_HEALTHBUTTON_TIP1          = "Bouton des pierres de soin";
    SHARDTRACKER_HEALTHBUTTON_TIP2          = "Cliquez pour cr\195\169er votre pierre de soin de plus haut rang.";
    SHARDTRACKER_HEALTHBUTTON_TIP3          = "Cliquez encore pour utiliser la pierre de soin, ou selectionnez un";
    SHARDTRACKER_HEALTHBUTTON_TIP4          = "joueur et cliquez pour lui donner la pierre de soin.";
    SHARDTRACKER_HEALTHBUTTON_TIP5          = "Cliquez pour utiliser votre pierre de soin.";

    SHARDTRACKER_SOULBUTTON_TIP1            = "Bouton des pierres d\'\195\162me";
    SHARDTRACKER_SOULBUTTON_TIP2            = "Cliquez pour cr\195\169er votre pierre d\'\195\162me de plus haut rang.";
    SHARDTRACKER_SOULBUTTON_TIP3            = "Cliquez encore pour utiliser la pierre d\'\195\162me sur le joueur selectionn\195\169.";
    SHARDTRACKER_SOULBUTTON_TIP4            = "Ce compteur indique le temps n\195\169cessaire avant de pouvoir utiliser";
    SHARDTRACKER_SOULBUTTON_TIP5            = "une autre pierre d\'\195\162me (\195\160 ce moment la, le bouton clignotera).";

    SHARDTRACKER_SPELLBUTTON_TIP1           = "Bouton des pierres de sort";
    SHARDTRACKER_SPELLBUTTON_TIP2           = "Cliquez pour cr\195\169er votre pierre de sort de plus haut rang.";
    SHARDTRACKER_SPELLBUTTON_TIP3           = "Cliquez encore pour \195\169quiper la pierre de sort. Une fois la";
    SHARDTRACKER_SPELLBUTTON_TIP4           = "minuterie termin\195\169e, cliquer utilisera la pierre";
    SHARDTRACKER_SPELLBUTTON_TIP5           = "et re-\195\169quipera automatiquement votre pr\195\169c\195\169dent objet tenu dans cette main.";

    SHARDTRACKER_FIREBUTTON_TIP1            = "ShardTracker Firestone Button";
    SHARDTRACKER_FIREBUTTON_TIP2            = "Click to create your highest rank Firestone.";
    SHARDTRACKER_FIREBUTTON_TIP3            = "Click again to equip your Firestone.  Clicking";
    SHARDTRACKER_FIREBUTTON_TIP4            = "again will unequip your Firestone and automatically";
    SHARDTRACKER_FIREBUTTON_TIP5            = "re-equip your previous off-hand item.";

    SHARDTRACKER_PARTYHEALTH_TIP1           = "Pierre de soin du groupe";
    SHARDTRACKER_PARTYHEALTH_TIP2           = "Quand cette icone est solide, le joueur a une pierre de soin";
    SHARDTRACKER_PARTYHEALTH_TIP3           = "Quand elle clignote, le joueur a besoin d\'une pierre de soin";

    SHARDTRACKER_SHARDBUTTON_STATUS1        = "(Click to Sort)";
    SHARDTRACKER_HEALTHBUTTON_STATUS1       = "(Click to Use)";
    SHARDTRACKER_HEALTHBUTTON_STATUS2       = "(Click to Create)";
    SHARDTRACKER_SOULBUTTON_STATUS1         = "(Click to Use)";
    SHARDTRACKER_SOULBUTTON_STATUS2         = "(Waiting for Cooldown)";
    SHARDTRACKER_SOULBUTTON_STATUS3         = "(Click to Create)";
    SHARDTRACKER_SPELLBUTTON_STATUS1        = "(Click to Use)";
    SHARDTRACKER_SPELLBUTTON_STATUS2        = "(Waiting for Cooldown)";
    SHARDTRACKER_SPELLBUTTON_STATUS3        = "(Click to Equip)";
    SHARDTRACKER_SPELLBUTTON_STATUS4        = "(Click to Create)";
    SHARDTRACKER_FIREBUTTON_STATUS1         = "(Click to Equip)";
    SHARDTRACKER_FIREBUTTON_STATUS2         = "(Click to Un-Equip)";
    SHARDTRACKER_FIREBUTTON_STATUS3         = "(Click to Create)";
    SHARDTRACKER_BUTTON_CTRLCLICKTEXT       = "(Ctrl-Click to Set Text Color)";

    -- popup messages
    SHARDTRACKERSORT_SORTING                = "Trie des pierres";
    SHARDTRACKER_SOULSTONEREADYMSG          = "La Pierre d\'\195\162me est pr\195\170te !";

    -- key bindings
    BINDING_HEADER_SHARDTRACKER_HEADER      = "ShardTracker";
    BINDING_NAME_SHARDBUTTON_BINDING        = "Bouton des fragments d\'\195\162me";
    BINDING_NAME_HEALTHBUTTON_BINDING       = "Bouton des pierres de soin";
    BINDING_NAME_SOULBUTTON_BINDING         = "Bouton des pierres d\'\195\162me";
    BINDING_NAME_SPELLBUTTON_BINDING        = "Bouton des pierres de sort";
    BINDING_NAME_FIREBUTTON_BINDING         = "Bouton des pierres de Firestone";

    -- localization / translation text
    SHARDTRACKER_WARLOCK                  = "D\195\169moniste";     
    SHARDTRACKER_SPELLSTONE               = "Pierre de sort";  
    SHARDTRACKER_FIRESTONE                = "Firestone";  
    SHARDTRACKER_SOULSHARD                = "Fragment d'\195\162me";  
    SHARDTRACKER_SOULSTONE                = "Pierre d'\195\162me";  
    SHARDTRACKER_HEALTHSTONE              = "Pierre de soins";     
    SHARDTRACKER_CREATEHEALTHSTONEMINOR   = "Cr\195\169ation de Pierre de soins (mineure)";
    SHARDTRACKER_CREATEHEALTHSTONELESSER  = "Cr\195\169ation de Pierre de soins (inf\195\169rieure)"; 
    SHARDTRACKER_CREATEHEALTHSTONE        = "Cr\195\169ation de Pierre de soins";
    SHARDTRACKER_CREATEHEALTHSTONEGREATER = "Cr\195\169ation de Pierre de soins (sup\195\169rieure)"; 
    SHARDTRACKER_CREATEHEALTHSTONEMAJOR   = "Cr\195\169ation de Pierre de soins (majeure)"; 
    SHARDTRACKER_CREATESOULSTONEMINOR     = "Cr\195\169ation de Pierre d\'\195\162me (mineure)"; 
    SHARDTRACKER_CREATESOULSTONELESSER    = "Cr\195\169ation de Pierre d\'\195\162me (inf\195\169rieure)"; 
    SHARDTRACKER_CREATESOULSTONE          = "Cr\195\169ation de Pierre d\'\195\162me"; 
    SHARDTRACKER_CREATESOULSTONEGREATER   = "Cr\195\169ation de Pierre d\'\195\162me (sup\195\169rieure)"; 
    SHARDTRACKER_CREATESOULSTONEMAJOR     = "Cr\195\169ation de Pierre d\'\195\162me (majeure)"; 
    SHARDTRACKER_CREATESPELLSTONE         = "Cr\195\169ation de Pierre de sort"; 
    SHARDTRACKER_CREATESPELLSTONEGREATER  = "Cr\195\169ation de Pierre de sort (sup\195\169rieure)"; 
    SHARDTRACKER_CREATESPELLSTONEMAJOR    = "Cr\195\169ation de Pierre de sort (majeure)"; 
    SHARDTRACKER_CREATEFIRESTONELESSER    = "Cr\195\169ation de Pierre de feu (inf\195\169rieure)"; 
    SHARDTRACKER_CREATEFIRESTONE          = "Cr\195\169ation de Pierre de feu"; 
    SHARDTRACKER_CREATEFIRESTONEGREATER   = "Cr\195\169ation de Pierre de feu (sup\195\169rieure)"; 
    SHARDTRACKER_CREATEFIRESTONEMAJOR     = "Cr\195\169ation de Pierre de feu (majeure)";     
    SHARDTRACKER_JOINSTHEPARTY            = "joins the party"; 
    SHARDTRACKER_LEAVESTHEPARTY           = "leaves the party";
    SHARDTRACKER_GROUPDISBANDED           = "Your group has been disbanded";
    SHARDTRACKER_YOULEAVEGROUP            = "You leave the group";
    SHARDTRACKER_SOULSTONERES             = "R\195\169surrection de Pierre d'\195\162me";
    SHARDTRACKER_COOLDOWN                 = "Temps de recharge";
    SHARDTRACKER_COMMON                   = "Commun";
    SHARDTRACKER_ORCISH                   = "Orcish";
    SHARDTRACKER_HUMAN                    = "Human";
    SHARDTRACKER_DWARF                    = "Dwarf";
    SHARDTRACKER_NIGHTELF                 = "Night Elf";
    SHARDTRACKER_GNOME                    = "Gnome";
    SHARDTRACKER_SSREADYTOCAST            = "Soulstone Resurrection is ready to recast!";
    ST_LIMITANSWER                        = "ShardTracker : Nombre minimum de fragments en-dessous duquel le bouton se met a clignoter mis a ";
    ST_LIMITUSAGE                         = "Utilisation : /st limit [0-20]";
    ST_ONLYFORWARLOCKS                    = "Cette fonction n'est accessible qu'aux d\195\169monistes.";
    ST_SPELLSTONEERROR                    = "ShardTracker : Impossible d'\195\169quiper la Pierre de Sort !  Peut-etre n'y a-t-il pas assez de place dans les sacs pour y placer l'arme dans votre main principale ?";
    ST_DRAGERROR                          = "Pour repositionner les boutons du ShardTracker, vous devez d'abord les d\195\169verrouill\195\169s avec la commande \"/st unlock\".";
    ST_LOCKMSG                            = "Les boutons du ShardTracker sont maintenant verrouill\195\169s a leur position et sont utilisables.  Pour les repositionner, d\195\169verrouillez les avec la commande \"/st unlock\".";
    ST_UNLOCKMSG                          = "Les boutons du ShardTracker sont maintenant d\195\169verrouill\195\169s.  Vous pouvez les positionner n'importe ou sur l'\195\169cran.  Quand ils sont d\195\169verrouill\195\169s, ils ne FONCTIONNENT PAS.  Pour les verrouill\195\169s a leur position, utilisez la commande \"/st lock\".";
    ST_SCALECHANGE                        = "Les boutons du ShardTracker ont leur taille mise a ";
    ST_SCALEUSAGE                         = "Utilisation : /shardtracker scale ";
    ST_HEALTHSTONEFLASH                   = "ShardTracker: le bouton de pierre de soin clignotera lorsque vous devez en faire une nouvelle.";
    ST_HEALTHSTONEFLASHOFF                = "ShardTracker: le bouton de la pierre de soin ne clignotera plus.";
    ST_TOGGLEUSAGE                        = "Utilisation : /shardtracker toggle \[shards\|healthstone\|soulstone\|spellstone\]";
    ST_SOUNDON                            = "ShardTracker: Son activ\195\169";
    ST_SOUNDOFF                           = "ShardTracker: Son d\195\169sactiv\195\169";
    ST_POPUPENABLED                       = "ShardTracker: message popup de la pierre d'\195\162me activ\195\169Enabled.";
    ST_POPUPDISABLED                      = "ShardTracker: message popup de la pierre d'\195\162me d\195\169sactiv\195\169Enabled.";
    ST_MONITORINGON                       = "ShardTracker ne communiquera qu'avec les membres de votre groupe se trouvant dans votre liste.";
    ST_MONITORINGOFF                      = "ShardTracker communiquera avec tous les membres de votre groupe.";
    ST_BGENABLED                          = "ShardTracker: le fond du bouton de fragments est activ\195\169.";
    ST_BGDISABLED                         = "ShardTracker: le fond du bouton de fragments est d\195\169sactiv\195\169.";
    ST_PARTYMONITORINGON                  = "ShardTracker monitore les pierres de soin de votre groupe.  Pour que cela fonctionne, les membres de votre groupe doivent aussi utiliser le ShardTracker.  Pour le d\195\169saciver, utilisez la commande \"/st monitor off\".";
    ST_PARTYMONITORINGOFF                 = "ShardTracker ne monitore pas les pierres de soin de votre groupe.  Pour l'activer, utilisez la commande \"/st monitor on\" et soyez sur que les membres de votre groupe utilisent aussi le ShardTracker.";
    ST_FLASHYGRAPHICSON                   = "ShardTracker: Advanced graphics enabled.";
    ST_FLASHYGRAPHICSOFF                  = "ShardTracker: Advanced graphics disabled.";
    ST_SOULNAGON                          = "ShardTracker will now nag you about re-casting Soulstone Resurrection.";
    ST_SOULNAGOFF                         = "ShardTracker will no longer nag you about re-casting Soulstone Resurrection.";
    ST_HEALTHNAGON                        = "ShardTracker will now nag you when party members need a new Healthstone.";
    ST_HEALTHNAGOFF                       = "ShardTracker will no longer nag you when party members need a new Healthstone.";
    ST_NAGINTERVAL1                       = "ShardTracker will nag you every ";
    ST_NAGINTERVAL2                       = " second(s) about Healthstones and Soulstones.";
    ST_NAGCOUNT1                          = "ShardTracker will nag you ";
    ST_NAGCOUNT2                          = " time(s) before giving up.";
    ST_NAGCOUNT3                          = "infinitely (or until you go insane).";
    ST_NEEDCHRONOS                        = "Note: You must install Chronos for this function to work.  Please see www.wowwiki.com/Chronos for details.";
    ST_MAXSHARDSSET1                      = "ShardTracker: Maximum Soul Shards allowed in inventory set to ";
    ST_MAXSHARDSSET2                      = "Any additional shards will automatically be destroyed.  To allow unlimited shards, set this to 0.";
    ST_MAXSHARDSSETUNLIMITED              = "ShardTracker: You may now have unlimited Soul Shards in your inventory.";
    ST_MAXSHARDSERROR                     = "Usage: /shardtracker maxshards <n>, where n is the maximum number of Soul Shards you want to keep in inventory.  Set n to 0 to allow unlimited Soul Shards.";
    ST_DELETEDASHARD                      = "ShardTracker: Soul Shard deleted!";

    -- info messages
    ST_SHOWINFO_MSG1    = "ShardTracker est un outil de gestion de fragments d'\195\162me pour les d\195\169monistes.";
    ST_SHOWINFO_MSG2    = "Il a deux fonctions principales : vous informer sur vos fragments et vous informer sur la possession de pierres de soin des membres de votre groupe.  Dans la premiere fonctionnalit\195\169, vos fragments sont g\195\169r\195\169s par 4 petits boutons.  Ils sont initiallement group\195\169s pres du radar, mais vous pouvez les positionner ou vous le voulez en utilisant les fonctions "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_LOCK_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." et "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.."unlock"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".";
    ST_SHOWINFO_MSG3    = "(Note: les boutons ne fonctionnent plus s'ils ne sont pas v\195\169rouill\195\169s.)";
    ST_SHOWINFO_MSG4    = "Vous pouvez aussi changer la taille des boutons en utilisant la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SCALE_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".  Quatre tailles sont possibles : regular, large, biggie et supersizeme.";
    ST_SHOWINFO_MSG5    = "Vous pouvez aussi inverser la couleur de fond pour le bouton des fragments en utilisant la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SHARDBG_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".  Enfin, vous pouvez "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_RESET_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." la position de vos boutons a leurs positions initiales, ou si d'autres objets genent la position initiale, vous pouvez utiliser la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_CENTER_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." pour les centrer a l'\195\169cran pour les replacer.";
    ST_SHOWINFO_MSG6    = "Le Bouton des Fragments d'\195\162me"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." vous indique combien de fragments vous avez dans votre inventaire.  Ce bouton deviendra rouge et clignotera quand le nombre de fragments descendra sous une certaine valeur.  Actuellement cette valeur est de ";
    ST_SHOWINFO_MSG6a   = ", mais vous pouvez la modifier et mettre la valeur que vous voulez en utilisant la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_LIMIT_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".";
    ST_SHOWINFO_MSG7    = "En cliquant sur ce bouton vos fragments seront tri\195\169s (ainsi que les pierres de soin, les pierres d'\195\162me et les pierres de sort) dans le sac de votre choix.  Pour l'instant, le sac est le num\195\169ro ";
    ST_SHOWINFO_MSG7a   = ", mais vous pouvez changer ce numero en utilisant la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_BAG_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".";
    ST_SHOWINFO_MSG8    = "Le bouton des pierres de soin"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." vous fait savoir si vous avez une pierre de soin.  Si vous n'en avez pas, en cliquant sur ce bouton vous cr\195\169erez la pierre de soin de plus haut rang.";
    ST_SHOWINFO_MSG9    = "En cliquant de nouveau vous utiliserez la pierre de soin.  De plus, si vous avez un un joueur ami en cible, en cliquant sur le bouton cela placera la pierre de soin dans la fenetre d'\195\169change avec ce joueur.";
    ST_SHOWINFO_MSG10   = "Le bouton de pierre d'\195\162me"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." vous informe de l'\195\169tat de votre pierre d'\195\162me.";
    ST_SHOWINFO_MSG11   = "Quand vous n'avez plus de pierre d'\195\162me, le bouton deviendra gris\195\169.  En cliquant sur ce bouton cela cr\195\169era la pierre d'\195\162me de plus haut rang.";
    ST_SHOWINFO_MSG12   = "En cliquant de nouveau cela lancera le sort de la piere d'\195\162me sur le joueur alli\195\169 que vous avez en cible.  Une fois lanc\195\169, le bouton de pierre d'\195\162me montrera un compteur repr\195\169sentant le nombre de minutes avant que vous puissiez lancer le prochain sort de r\195\169surrection.";
    ST_SHOWINFO_MSG13   = "Quand ce compteur atteindra 0, une alarme retentira et le bouton clignotera pour vous rappeler de relancer le sort de r\195\169surrection.  Vous pouvez d\195\169sactiver le son de l'alarme en utilisant la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SOUND_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".";
    ST_SHOWINFO_MSG14   = "Pour d\195\169sactiver la fenetre de notification, utilisez la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SOUL_POPUP_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..".";
    ST_SHOWINFO_MSG15   = "Le bouton de pierre de sort"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." vous montrera l'\195\169tat de votre pierre de sort.  En cliquant dessus cela cr\195\169era la pierre de sort de plus haut rang.";
    ST_SHOWINFO_MSG16   = "En cliquant de nouveau dessus cela \195\169quipera la pierre de sort et affichera le nombre de secondes avant que vous puissiez utiliser votre pierre de sort. Une fois le compteur a 0, en cliquant vous activerez votre pierre de sort et l'arme que vous utilisiez avant la pierre de sort sera automatiquement re\195\169quip\195\169e.";
    ST_SHOWINFO_MSG15a  = "The Firestone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." shows your Firestone status.  Clicking this button will create your highest rank Firestone.";
    ST_SHOWINFO_MSG16a  = "Clicking again will equip your Firestone.  When equipped, clicking will unequip your Firestone and automatically re-equip whatever weapon you were wielding before you equipped the Spellstone.";
    ST_SHOWINFO_MSG17   = "La seconde fonctionnalit\195\169 (ne marchant pas sur la traduction francaise) vous informe sur la pr\195\169sence de pierre de soin chez les membres de votre groupe.  Quand un membre du groupe recoit une pierre de soin, une icone apparait au-dessus de son portrait. Quand un membre du groupe utilise sa pierre de soin, cette icone se met a clignoter et une alarme se fait entendre.";
    ST_SHOWINFO_MSG18   = "Pour que cette fonctionnalit\195\169 fonctionne, les membres du groupe doivent aussi avoir le ShardTracker d'install\195\169.";
    ST_SHOWINFO_MSG19   = "Vous pouvez d\195\169sactiver cette fonctionnalit\195\169 en utilisant la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_MONITOR_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN..". De plus, vous pouvez cr\195\169er une liste de joueurs a monitorer. Seuls les joueurs dans cette liste recevront une communication de votre ShardTracker.";
    ST_SHOWINFO_MSG20   = "Vous pouvez "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_ADD_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." ou "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_REMOVE_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." des joueurs de cette liste, et utiliser la commande "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_RESTRICT_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." pour activer ou d\195\169sactiver cette liste.  Les joueurs utilisant Cosmos qui ne sont pas sur votre liste auront quand meme leur pierre de soin monitor\195\169e, mais ShardTracker le fera de facon silencieuse.";
    ST_SHOWINFO_MSG21   = "Pour plus d'informations sur les commandes sp\195\169fiques, utilisez la commande /shardtracker help.";

    -- help messages
    ST_HELP_MSG1    = "ShardTracker, un AddOn par Cragganmore.  Traduction et compatibilit\195\169 FR par Riswaaq.  ";
    ST_HELP_MSG1A    = "\"Votre \195\162me est la mienne!\"";
    ST_HELP_MSG2    = "Bas\195\169e sur le code de Kithador et Ryu";
    ST_HELP_MSG3    = "Utilisation : ";
    ST_HELP_MSG4    = "/shardtracker <commande>";
    ST_HELP_MSG5    = " ou ";
    ST_HELP_MSG6    = "/st <commande>";
    ST_HELP_MSG7    = "Active ou d\195\169sactive le ShardTracker.";
    ST_HELP_MSG8    = "Active ou non le bouton respectif.";
    ST_HELP_MSG9    = "Active le fait de monitorer les pierres de soin du groupe.";
    ST_HELP_MSG10   = "Pour choisir le sac par d\195\169faut pour mettre les fragments au moment du tri (0 = sac a dos, 4 = sac le plus a gauche).";
    ST_HELP_MSG11   = "Place tous les fragments dans votre sac par d\195\169faut (s\195\169lectionn\195\169 avec la commande \"bag\").";
    ST_HELP_MSG12   = "Lorsque le nombre de vos fragments passe sous cette valeur, le bouton de fragments se met a clignoter pour vous alerter.";
    ST_HELP_MSG13   = "Active ou non le son lors des alertes.";
    ST_HELP_MSG14   = "Active ou non l'alerte popup de la pierre d'\195\162me.";
    ST_HELP_MSG15   = "Active ou non l'image de fond du bouton de fragments.";
    ST_HELP_MSG16   = "Active ou non le clignotement du bouton de pierre de soin lorsque vous devez en faire une nouvelle.";
    ST_HELP_MSG17   = "Lorsqu'ils sont d\195\169verrouill\195\169s, les boutons ne sont plus utilisables mais peuvent etre d\195\169plac\195\169s sur l'\195\169cran.";
    ST_HELP_MSG18   = "Lorsqu'ils sont verrouill\195\169s, les boutons sont utilisables mais ne peuvent plus etre d\195\169plac\195\169s.";
    ST_HELP_MSG19   = "R\195\169initialise les boutons a leur position par d\195\169faut.";
    ST_HELP_MSG20   = "Place les boutons au centre de l\195\169cran, dans le cas ou ils sont inaccessibles a cause d'autres boutons pres de la minimap.";
    ST_HELP_MSG21   = "S\195\169lectionne la taille des boutons.";
    ST_HELP_MSG22   = "Quand cette option est activ\195\169e, le ShardTracker ne communiquera qu'avec les membres du groupe se trouvant sur votre liste des \"personnes autoris\195\169es\".  Note : le ShardTracker communiquera quand meme avec les membres du groupe utilisant Cosmos mais le fera silencieusement.";
    ST_HELP_MSG23   = "Ajoute un joueur a votre liste de \"personnes autoris\195\169es\".";
    ST_HELP_MSG24   = "Enleve un joueur a votre liste de \"personnes autoris\195\169es\".";
    ST_HELP_MSG25   = "Afiche votre liste de \"personnes autoris\195\169es\".";
    ST_HELP_MSG26   = "Affiche une escription d\195\169taill\195\169e du ShardTracker.";
    ST_HELP_MSG27   = "Affiche ce message.";
    ST_HELP_MSG28   = "Exemple : \"/st flash off\" d\195\169sactivera le clignotement de l'icone de la pierre de soin.";
    ST_HELP_MSG29    = "Set the sound to play when Soulstone is ready to re-cast.";
    ST_HELP_MSG30    = "Set the sound to play when a player needs a new Healthstone.";
    ST_HELP_MSG31    = "Toggles advanced graphics effects.";
    ST_HELP_MSG32    = "Toggles Soulstone nagging.";
    ST_HELP_MSG33    = "Toggles Healthstone nagging.";
    ST_HELP_MSG34    = "Sets the number of seconds between each nag.";
    ST_HELP_MSG35    = "Sets the number of times to nag before giving up (set to 0 for infinite nagginess!).";
    ST_HELP_MSG36    = "Sets the maximum number of Soul Shards allowed in your inventory (extra Shards will be automatically deleted).  Set this to 0 to allow unlimited Shards.";
    ST_HELP_ENABLED  = " (enabled)";
    ST_HELP_DISABLED = " (disabled)";

end