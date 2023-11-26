-- Version : 
--		* English - vjeux
--		* French - Elzix
--		* German - DoctorVanGogh

IMCMD_EQUIP_COMM					= {"/equip"};
IMCMD_EQUIP_COMM_INFO				= "/equip <item name>, equips the named item";
IMCMD_EQUIP_OH_COMM					= {"/equipoffhand", "/equipoh", "/equipshield"};
IMCMD_EQUIP_OH_COMM_INFO			= "/equipoffhand <item name>, equips the named item in your off-hand";
IMCMD_UNEQUIP_COMM					= {"/unequip"};
IMCMD_UNEQUIP_COMM_INFO				= "/unequip <item name>, unequips the named item";
IMCMD_SSET_COMM						= {"/saveset"};
IMCMD_SSET_COMM_INFO				= "/saveset <number (1-9)>, saves the current equipment set";
IMCMD_LSET_COMM						= {"/loadset"};
IMCMD_LSET_COMM_INFO				= "/loadset <number (1-9)>, loads the named equipment set";
IMCMD_USE_COMM						= {"/use"};
IMCMD_USE_COMM_INFO					= "/use <item name>, uses the named item";
IMCMD_USETYPE_COMM					= {"/usetype"};
IMCMD_USETYPE_COMM_INFO				= "/usetype <item type>, uses the first item corresponding to the named type. Types are : Gem, Ore, Herb, Engineering, First Aid, Leather, Thread, Potion, Fishing, Food, Drink, Shaman, Warlock, QuestItem, Weapon, Armor, Shield, Ranged, Ammo, Clothing.";
IMCMD_USECLASSIFICATION_COMM		= {"/useclassification", "/useclass"};
IMCMD_USECLASSIFICATION_COMM_INFO	= "/useclassification <item classification>, uses the first item that is classified as the specified classification.";
IMCMD_RUNMACRO_COMM					= {"/runmacro"};
IMCMD_RUNMACRO_COMM_INFO			= "/runmacro <number>, run the macro.";

IMCMD_ERROR_UNKITEM					= "Item '%s' not found!";
IMCMD_ERROR_NOITEM					= "There's no items corresponding to the '%s' type !";
IMCMD_ERROR_SAVED					= "Set %s saved";
IMCMD_ERROR_LOADED					= "Set %s loaded";
IMCMD_ERROR_HOLDING					= "It looks like you're already holding something.";
IMCMD_ERROR_SPACE					= "Not enough space in your bags !";
IMCMD_ERROR_UNKSET					= "Set '%s' doesn't exist!";

IMCMD_ERROR_MACRO					= "The #%s macro doesn't exist!";
IMCMD_ERROR_MACRO1					= "One empty slot is required!";

BINDING_HEADER_RUNMACRO = "Run Macro";
BINDING_NAME_RUNMACRO1				= "Run Macro 1";
BINDING_NAME_RUNMACRO2				= "Run Macro 2";
BINDING_NAME_RUNMACRO3				= "Run Macro 3";
BINDING_NAME_RUNMACRO4				= "Run Macro 4";
BINDING_NAME_RUNMACRO5				= "Run Macro 5";
BINDING_NAME_RUNMACRO6				= "Run Macro 6";
BINDING_NAME_RUNMACRO7				= "Run Macro 7";
BINDING_NAME_RUNMACRO8				= "Run Macro 8";
BINDING_NAME_RUNMACRO9				= "Run Macro 9";
BINDING_NAME_RUNMACRO10				= "Run Macro 10";
BINDING_NAME_RUNMACRO11				= "Run Macro 11";
BINDING_NAME_RUNMACRO12				= "Run Macro 12";
BINDING_NAME_RUNMACRO13				= "Run Macro 13";
BINDING_NAME_RUNMACRO14				= "Run Macro 14";
BINDING_NAME_RUNMACRO15				= "Run Macro 15";
BINDING_NAME_RUNMACRO16				= "Run Macro 16";
BINDING_NAME_RUNMACRO17				= "Run Macro 17";
BINDING_NAME_RUNMACRO18				= "Run Macro 18";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Elzix

	IMCMD_EQUIP_COMM					= {"/equip"};
	IMCMD_EQUIP_COMM_INFO				= "/equip <nom de l'objet>, équipe l'objet";
	IMCMD_UNEQUIP_COMM					= {"/desequip", "/unequip"};
	IMCMD_UNEQUIP_COMM_INFO				= "/desequip <nom de l'objet>, retire l'objet";
	IMCMD_EQUIP_OH_COMM					= {"/equipoffhand", "/equipoh", "/equipshield"};
	IMCMD_EQUIP_OH_COMM_INFO= "/equipoffhand <nom de l'objet>, équipe l'objet nommé dans votre offhand";
	IMCMD_SSET_COMM						= {"/sauveset", "/saveset"};
	IMCMD_SSET_COMM_INFO				= "/sauveset <nombre (1-9)>, Enregistre l'équipement actuel dans le numéro selectioné";
	IMCMD_LSET_COMM						= {"/chargeset", "/loadset"};
	IMCMD_LSET_COMM_INFO				= "/chargeset (1-9)>, Charge l'équipement du numéro selectionné";
	IMCMD_USE_COMM						= {"/use", "/utiliser"};
	IMCMD_USE_COMM_INFO					= "/utiliser <nom de l'objet>, utiliser l'objet nommé";
	IMCMD_USETYPE_COMM					= {"/usetype", "/utilisertype"};
	IMCMD_USETYPE_COMM_INFO				= "/utilisertype <type d'objet>, utilise le premier objet de type trouvé. Les types sont : Gem, Ore, Herb, Engineering, First Aid, Leather, Thread, Potion, Fishing, Food, Drink, Shaman, Warlock, QuestItem, Weapon, Armor, Shield, Ranged, Ammo, Clothing.";
	IMCMD_RUNMACRO_COMM					= {"/runmacro"};
	IMCMD_RUNMACRO_COMM_INFO= "/runmacro <numéro>, lance la macro.";
	
	IMCMD_ERROR_UNKITEM					= "'%s' non trouvé !";
	IMCMD_ERROR_NOITEM					= "Il n'y a aucun objet correspondant au type '%s' !";
	IMCMD_ERROR_SAVED					= "Set %s sauvegardé";
	IMCMD_ERROR_LOADED					= "Set %s chargé";
	IMCMD_ERROR_HOLDING					= "Veuillez déposé l'objet que vous avec sur le curseur.";
	IMCMD_ERROR_SPACE					= "Vous n'avez pas assez de place dans votre sac, veuillez libérer un slot !";
	IMCMD_ERROR_UNKSET					= "Le set '%s' n'existe pas !";
	
	IMCMD_ERROR_MACRO					= "La macro n°%s n'existe pas !";
	IMCMD_ERROR_MACRO1					= "Un slot libre est requis !";
	
	BINDING_HEADER_RUNMACRO = "Utiliser Macro";
	BINDING_NAME_RUNMACRO1				= "Utiliser Macro 1";
	BINDING_NAME_RUNMACRO2				= "Utiliser Macro 2";
	BINDING_NAME_RUNMACRO3				= "Utiliser Macro 3";
	BINDING_NAME_RUNMACRO4				= "Utiliser Macro 4";
	BINDING_NAME_RUNMACRO5				= "Utiliser Macro 5";
	BINDING_NAME_RUNMACRO6				= "Utiliser Macro 6";
	BINDING_NAME_RUNMACRO7				= "Utiliser Macro 7";
	BINDING_NAME_RUNMACRO8				= "Utiliser Macro 8";
	BINDING_NAME_RUNMACRO9				= "Utiliser Macro 9";
	BINDING_NAME_RUNMACRO10				= "Utiliser Macro 10";
	BINDING_NAME_RUNMACRO11				= "Utiliser Macro 11";
	BINDING_NAME_RUNMACRO12				= "Utiliser Macro 12";
	BINDING_NAME_RUNMACRO13				= "Utiliser Macro 13";
	BINDING_NAME_RUNMACRO14				= "Utiliser Macro 14";
	BINDING_NAME_RUNMACRO15				= "Utiliser Macro 15";
	BINDING_NAME_RUNMACRO16				= "Utiliser Macro 16";
	BINDING_NAME_RUNMACRO17				= "Utiliser Macro 17";
	BINDING_NAME_RUNMACRO18				= "Utiliser Macro 18";

elseif ( GetLocale() == "deDE" ) then
	-- Translation by DoctorVanGogh

    IMCMD_EQUIP_COMM        = {"/equip"};
    IMCMD_EQUIP_COMM_INFO   = "/equip <Gegenstandsname>, zieht den genannten Gegenstand an";
    IMCMD_UNEQUIP_COMM      = {"/unequip"};
    IMCMD_UNEQUIP_COMM_INFO = "/unequip <Gegenstandsname>, zieht den genannten Gegenstand aus";
    IMCMD_SSET_COMM         = {"/saveset"};
    IMCMD_SSET_COMM_INFO    = "/saveset <Nummer (1-9)>, speichert das momentane Ausrüstungsset";
    IMCMD_LSET_COMM         = {"/loadset"};
    IMCMD_LSET_COMM_INFO    = "/loadset <Nummer (1-9)>, läd das genannte Ausrüstungsset";
    IMCMD_USE_COMM_INFO     = "/use <item name>, benutze den genannten Gegenstand";
    IMCMD_USETYPE_COMM      = {"/usetype"};
    IMCMD_USETYPE_COMM_INFO = "/usetype <Gegenstandstyp>, uses the first item corresponding to the named type. Types are : Gem, Ore, Herb, Engineering, First Aid, Leather, Thread, Potion, Fishing, Food, Drink, Shaman, Warlock, QuestItem, Weapon, Armor, Shield, Ranged, Ammo, Clothing."; -- TODO: Translate once localized names for types are decided upon and implemented !!! 
    
    IMCMD_ERROR_UNKITEM     = "Gegenstand '%s' nicht gefunden!";
    IMCMD_ERROR_NOITEM      = "Keine Gegenstände des Typs '%s' gefunden !";
    IMCMD_ERROR_SAVED       = "Set %s gespeichert";
    IMCMD_ERROR_LOADED      = "Set %s geladen";
    IMCMD_ERROR_HOLDING     = "Es sieht so aus, als hättest Du schon etwas in der Hand.";
    IMCMD_ERROR_SPACE       = "Nicht genug Platz in den Taschen !";
    IMCMD_ERROR_UNKSET      = "Set '%s' existiert nicht!";
    
    IMCMD_EQUIP_OH_COMM     = {"/equipoffhand", "/equipoh", "/equipshield"};
    IMCMD_EQUIP_OH_COMM_INFO= "/equipoffhand <Gegenstandsname>, zieht den genannten Gegenstand in die Zweithand";
end
