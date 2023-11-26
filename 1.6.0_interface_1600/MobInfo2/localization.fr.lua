-- 
-- Localisation for MobInfo
-- 
-- created by Sasmira ( Cosmos Team )
-- (with help from Halrik)
--
-- Last Update : 24-Aug-2005
-- 

-- 
-- French localization
-- 

if ( GetLocale() == "frFR" ) then

miSkinLoot = { };
miSkinLoot["Lani\195\168res de cuir d\195\169chir\195\169es"]=1;
miSkinLoot["Cuir L\195\169ger"]=1;
miSkinLoot["Cuir moyen"]=1;
miSkinLoot["Cuir lourd"]=1;
miSkinLoot["Cuir \195\169pais"]=1;
miSkinLoot["Cuir grossier"]=1;

miSkinLoot["Peau l\195\169g\195\168re"]=1;
miSkinLoot["Peau moyenne"]=1;
miSkinLoot["Peau lourde"]=1;
miSkinLoot["Peau \195\169paisse"]=1;
miSkinLoot["Peau rugueuse"]=1;

miSkinLoot["Cuir de Chim\195\168re"]=1;
miSkinLoot["Cuir de Diablosaure"]=1;
miSkinLoot["Cuir de Dent de sabre blanc"]=1;
miSkinLoot["Cuir de grand Ours"]=1;

miClothLoot = { };
miClothLoot["Tissu en lin"]=1;
miClothLoot["Tissu en laine"]=1;
miClothLoot["Etoffe de soie"]=1;
miClothLoot["Tissu de mage"]=1;
miClothLoot["Etoffe corrompue"]=1;
miClothLoot["Etoffe runique"]=1;

MI_DESCRIPTION = "Ajoute une pr\195\169cision d\'information sur un monstre dans la bulle d\'aide";

MI_MOB_DIES_WITH_XP = "(.+) succombe, vous gagnez (%d+) points d\'exp\195\169rience";
MI_MOB_DIES_WITHOUT_XP = " meurt";
MI_PARSE_SPELL_DMG = "(.+) de (.+) vous inflige (%d+) points de d\195\169g\195\162ts";
MI_PARSE_COMBAT_DMG = "(.+) vous touche et inflige (%d+) points de d\195\169g\195\162ts";

MI_TXT_GOLD = " Or";
MI_TXT_SILVER = " Argent";
MI_TXT_COPPER = " Cuivre";

MI_TXT_CLASS = "Classe ";
MI_TXT_HEALTH = "Vie ";
MI_TXT_KILLS = "Nbre de fois tu\195\169 ";
MI_TXT_DAMAGE = "Dommages ";
MI_TXT_TIMES_LOOTED = "Nbre de fois loot\195\169 ";
MI_TXT_EMPTY_LOOTS  = "Loots vides ";
MI_TXT_TO_LEVEL = "# pour level ";
MI_TXT_QUALITY = "Qualit\195\169 ";
MI_TXT_CLOTH_DROP = "Tissu ramass\195\169 ";
MI_TXT_COIN_DROP = "Argent Moyen ";
MI_TEXT_ITEM_VALUE = "Valeur Moyenne ";
MI_TXT_MOB_VALUE = "Valeur Totale ";
MI_TXT_COMBINED     = "Combin\195\169:";

MI_TXT_CONFIG_TITLE = "MobInfo-2 Options";

MI2_FRAME_TEXTS = {};
MI2_FRAME_TEXTS["MI2_FrmTooltipOptions"] = "Tooltip Options";
MI2_FRAME_TEXTS["MI2_FrmGeneralOptions"] = "General Options";
MI2_FRAME_TEXTS["MI2_FrmHealthOptions"]  = "Mob Health Options";

--
-- This section defines all buttons in the options dialog
--   text : the text displayed on the button
--   cmnd : the command which is executed when clicking the button
--          cmnd must not be given for the translated texts
--   help : the (short) one line help text for the button
--   info : additional multi line info text for button
--          info is displayed in the help tooltip below the "help" line
--          info is optional and can be omitted if not required
--

MI2_OPTIONS["MI2_OptShowClass"] = 
  { text = "Voir: Classes"; cmnd = "showclass";  help = "Show Mob class info"; }
  
MI2_OPTIONS["MI2_OptShowHealth"] = 
  { text = "Voir: Vie"; cmnd = "showhealth";  help = "Show Mob health info (current/max)"; }
  
MI2_OPTIONS["MI2_OptShowKills"] = 
  { text = "Voir: Nbre de fois tu\195\169"; cmnd = "showkills";  help = "Show number of times you killed the Mob";
    info = "The kill count is calculated and stored\nseparately per char." }
  
MI2_OPTIONS["MI2_OptShowDamage"] = 
  { text = "Voir: Zone d\'effet"; cmnd = "showdamage";  help = "Show Mob damage range (Min/Max)"; 
    info = "Damage range is calculated and stored\nseparately per char." }
    
MI2_OPTIONS["MI2_OptShowLooted"] = 
  { text = "Voir: Nbre de fois loot\195\169"; cmnd = "showlooted";  help = "Show number of times a Mob has been looted"; }
  
MI2_OPTIONS["MI2_OptShowEmpty"] = 
  { text = "Voir: Loots vides"; cmnd = "showempty";  help = "Show number of empty corpses found (num/percent)";
    info = "This counter gets incremented when you open\n a corpse that has no loot." }
  
MI2_OPTIONS["MI2_OptShowXP"] = 
  { text = "Voir: Exp\195\169rience"; cmnd = "showxp";  help = "Show number of experience points this Mob gives";
    info = "This is the actual last XP value that the Mob \ngave you. \n(not shown for Mobs that are grey to you)" }
  
MI2_OPTIONS["MI2_OptShowToLevel"] = 
  { text = "Voir: Nbre de mobs pour level"; cmnd = "show2level";  help = "Show number of kills needed to level";
    info = "This tells you how often you must kill the \nsame Mob you just killed to reacht he next level\n(not shown for Mobs that are grey to you)" }
      
MI2_OPTIONS["MI2_OptShowQuality"] = 
  { text = "Voir: Qualit\195\169 du Butin"; cmnd = "showquality";  help = "Show loot quality counters and percentage";
    info = "This counts how many items out of the 5 rarity\ncategories the Mob has given as loot. Categories\nwith 0 drops dont get shown\n" }
  
MI2_OPTIONS["MI2_OptShowCloth"] = 
  { text = "Voir: Tissu ramass\195\169"; cmnd = "showcloth";  help = "Show how often the Mob has given cloth loot"; }
  
MI2_OPTIONS["MI2_OptShowCoin"] = 
  { text = "Voir: Moyenne Argent ramass\195\169"; cmnd = "showcoin";  help = "Show average coin drop per Mob";
    info = "The total coin value is accumulated and divided\nby the looted counter.\n(does not get shown if coin count is 0)" }
  
MI2_OPTIONS["MI2_OptShowIV"] = 
  { text = "Voir: Valeur Moyenne des objets"; cmnd = "showiv";  help = "Show average item value per Mob";
    info = "The total item value is accumulated and divided\nby the looted counter.\n(does not get shown if item value is 0)" }
  
MI2_OPTIONS["MI2_OptShowMobValue"] = 
  { text = "Voir: Valeur Totale des monstres"; cmnd = "showmv";  help = "Show total average Mob value";
    info = "This is the sum of average coin drop and \naverage item value." }
  
MI2_OPTIONS["MI2_OptShowBlanks"] = 
  { text = "Voir: ligne blanche"; cmnd = "showblanklines";  help = "Show Blank lines in ToolTip";
    info = "Blank lines are meant to improve readability by\ncreating sections in the tooltip" }
  
MI2_OPTIONS["MI2_OptSaveAll"] = 
  { text = "Sauver toutes les valeurs"; cmnd = "saveallvalues";  help = "Always save all Mob data in database";
    info = "Always saving all Mob data allows you to change\nYour display option at any time and have the other\ndata available for showing. If not selected only\nthe data you choose to display will get stored in\nthe database. " }
  
MI2_OPTIONS["MI2_OptCombined"] = 
  { text = "Combinez les m\195\170mes monstres"; cmnd = "showCombined";  help = "Combine data for Mob with same name";
    info = "Combined mode will accumulate the data for Mobs with\nthe same name but different level. When enabled a\nindicator gets displayed in the tooltip" }
  
MI2_OPTIONS["MI2_OptKeyMode"] = 
  { text = "Press ALT Key for Mob Info"; cmnd = "showOnAlt";  help = "Only Show MobInfo in tooltip when ALT key is pressed"; }
  
MI2_OPTIONS["MI2_OptClearOnExit"] = 
  { text = "Suppr. les Data \195\160 la D\195\169co"; cmnd = "clearonexit";  help = "Clear entire MobInfo database each time you logout"; }

MI2_OPTIONS["MI2_OptDisableMobHealth"] = 
  { text = "Disable Mob Health"; help = "Disable all integrated Mob health functionality";
    info = "The MobHelath functionality built into MobInfo can be\n disabled entirely. This is necessary to run an external\nMobHealth AddOn"; }
  
MI2_OPTIONS["MI2_OptStableMax"] = 
  { text = "Show Stable Health Max"; cmnd = "stablemax";  help = "Show a stable health maximum in target frame";
    info = "When enabled the health maximum displayed in the \nMob target frame is not changed during a fight\nThe updated value is show when the next fight begins."; }
  
MI2_OPTIONS["MI2_OptHealthPos"] = 
  { text = "Mob Health Position"; cmnd = "pos ";  help = "Position of health value in target frame"; }

MI2_OPTIONS["MI2_OptAllOn"] = 
  { text = "Tous ON"; cmnd = "allOn";  help = "Switch all MobInfo show options to ON"; }
  
MI2_OPTIONS["MI2_OptAllOff"] = 
  { text = "Tous OFFF"; cmnd = "allOff";  help = "Switch all MobInfo show options to OFF"; }
  
MI2_OPTIONS["MI2_OptMinimal"] = 
  { text = "Minimum"; cmnd = "minimal";  help = "Show a minimum of useful Mob info"; }
  
MI2_OPTIONS["MI2_OptDefault"] = 
  { text = "D\195\169faut"; cmnd = "default";  help = "Show a default set of useful Mob info"; }
  
MI2_OPTIONS["MI2_OptBtnDone"] = 
  { text = "Appliquer"; cmnd = "";  help = "Close MobInfo options dialog";  }

end
