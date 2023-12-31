-- Reagent Info Localization File
-- English Strings by GDI

-- General Strings
REAGENTINFO					= "Reagent Info";
REAGENTINFO_CREATINGPLAYER			= "Creating a new player:";
REAGENTINFO_DESC				= "Shows tradeskill usage in item tooltips";
REAGENTINFO_DISABLED				= "Reagent Info Disabled";
REAGENTINFO_LOADED				= "Loaded";
REAGENTINFO_ENABLED				= "Reagent Info Enabled";
REAGENTINFO_SERVER				= "Server:";
REAGENTINFO_UPGRADE				= "Previous version detected.  Updating your configuration.";

-- Key Binding Strings
BINDING_HEADER_REAGENTINFO			= "Reagent Info";
BINDING_NAME_REAGENTINFO_CONFIG			= "Show Configuration Window";

-- Configuration Screen Strings
REAGENTINFO_CONFIGFRAME_HELP			= "Help";
REAGENTINFO_CONFIGFRAME_MISCINFO		= "Miscellaneous Options";
REAGENTINFO_GATHEREDBY				= "Gathered By";
REAGENTINFO_OPTIONS				= "Reagent Info Options";
REAGENTINFO_PROFESSIONS				= "Professions";
REAGENTINFO_SPELLREAGENT			= "Spell Reagent";

REAGENTINFO_COLORNAMES				= {
     ["UsedByColor"] = "Professions",
     ["GatheredByColor"] = "Gather Skills",
     ["SpellReagentColor"] = "Spell Reagent",
     ["QuestItemsColor"] = "Quest Items",
};

-- Dropdown Strings
REAGENTINFO_DROPDOWN_TOP			= "Top";
REAGENTINFO_DROPDOWN_BOTTOM			= "Bottom";
REAGENTINFO_TOOLTIPLOCTEXT			= "Tooltip Information Location (LootLink only)";
REAGENTINFO_DROPDOWN_OPTIMAL			= "Orange";
REAGENTINFO_DROPDOWN_MEDIUM			= "Yellow";
REAGENTINFO_DROPDOWN_EASY			= "Green";
REAGENTINFO_DROPDOWN_TRIVIAL			= "Gray";

-- Recipe Strings
REAGENTINFO_NUMRECIPES				= "Number of recipes to display";
REAGENTINFO_RECIPES				 = "Recipes";
REAGENTINFO_RECIPETHRESHOLDTEXT			= "Minimum color recipe to display";
REAGENTINFO_TRADESKILLWARNING			= "Reagent Info: Displaying tradeskill recipe information in tooltips will not function until you open each of your tradeskill windows at least once.";
REAGENTINFO_USEDIN				= "Used in recipes: " ;

-- Help Strings
ReagentInfo_CheckButton_GatheredBy_Label	= "Gather Skills";
ReagentInfo_CheckButton_GatheredBy_HelpText	= "Reagent Info will show what gather skills produce items on mouseover";
ReagentInfo_CheckButton_SpellReagents_Label	= "Spell Reagents";
ReagentInfo_CheckButton_SpellReagents_HelpText	= "Reagent Info will show what classes use items as spell reagents on mouseover";
ReagentInfo_CheckButton_UsedBy_Label		= "Professions";
ReagentInfo_CheckButton_UsedBy_HelpText		= "Reagent Info will show what professions use items on mouseover";

ReagentInfo_Profession_alchemy_HelpText		= "If checked, Reagent Info will display reagents used by the Alchemy profession";
ReagentInfo_Profession_blacksmithing_HelpText	= "If checked, Reagent Info will display reagents used by the Blacksmithing profession";
ReagentInfo_Profession_cooking_HelpText		= "If checked, Reagent Info will display reagents used by the Cooking profession";
ReagentInfo_Profession_enchanting_HelpText	= "If checked, Reagent Info will display reagents used by the Enchanting profession";
ReagentInfo_Profession_engineering_HelpText	= "If checked, Reagent Info will display reagents used by the Engineering profession";
ReagentInfo_Profession_firstaid_HelpText	= "If checked, Reagent Info will display reagents used by the First Aid profession";
ReagentInfo_Profession_leatherworking_HelpText	= "If checked, Reagent Info will display reagents used by the Leatherworking profession";
ReagentInfo_Profession_tailoring_HelpText	= "If checked, Reagent Info will display reagents used by the Tailoring profession";

ReagentInfo_Gathering_fishing_HelpText		= "If checked, Reagent Info will display reagents gathered by the Fishing profession";
ReagentInfo_Gathering_herbalism_HelpText	= "If checked, Reagent Info will display reagents gathered by the Herbalism profession";
ReagentInfo_Gathering_mining_HelpText		= "If checked, Reagent Info will display reagents gathered by the Mining profession";
ReagentInfo_Gathering_skinning_HelpText		= "If checked, Reagent Info will display reagents gathered by the Skinning profession";

ReagentInfo_DropDown_TooltipLoc_HelpText	= "Determines where the tooltip information will appear when using LootLink/ItemsMatrix";

ReagentInfo_DropDown_RecipeThreshold_HelpText	= "Determines the lowest 'level' of recipe displayed in tooltips";

ReagentInfo_NumRecipes_HelpText			= "Determines the number of recipes Reagent Info will display in the tooltip per level (max 9)";

ReagentInfo_CheckButton_Recurse_Label		= "Show recipe tree";
ReagentInfo_CheckButton_Recurse_HelpText	= "If checked, Reagent Info will show the 'recipe tree' for an item, displaying what can be make from the sub items (up to four levels)";
ReagentInfo_CheckButton_ShowRecipes_Label	= "Show Recipes";
ReagentInfo_CheckButton_ShowRecipes_HelpText	= "If checked, Reagent Info will show what recipes you know that use a given item";

REAGENTINFO_USAGE = "Usage: |cffffffff/ri enable|r - Enables Reagent Info\n|cffffffff/ri disable|r - Disables Reagent Info\n|cffffffff/ri config|r - Opens the Reagent Info configuration screen\n|cffffffff/ri clear|r - Reset the current character's configuration settings\n|cffffffff/ri clearall|r - Reset all character's configuration settings";

-- New strings in 1.4
REAGENTINFO_USEDBY				= "Used by";
ReagentInfo_CheckButton_ShowOther_Label		= "Show Alt Recipes";
ReagentInfo_CheckButton_ShowOther_HelpText	= "Show what recipes your other characters have that can use the current item";

-- New strings in 1.5
ReagentInfo_CheckButton_QuestItems_Label	= "Quest Items";
ReagentInfo_CheckButton_QuestItems_HelpText	= "Reagent Info will show usage information for special quest items (like those in Zul\'Gurub) on mouseover";

------------------------
-- German Translation --
------------------------

-- String translation provided by jth

if (GetLocale() == "deDE") then -- deDE

-- General Strings
REAGENTINFO = "Reagenz Info";
REAGENTINFO_CREATINGPLAYER = "Erstelle neuen Charakter:";
REAGENTINFO_DESC = "Zeigt im Tooltip die verwendeten Berufe an.";
REAGENTINFO_DISABLED = "Reagenz Info deaktiviert";
REAGENTINFO_LOADED = "Geladen";
REAGENTINFO_ENABLED = "Reagenz Info aktiviert";
REAGENTINFO_SERVER = "Server:";
REAGENTINFO_UPGRADE = "\195\132ltere Version gefunden. Konfiguration wird aktualisiert.";

-- Key Binding Strings
BINDING_HEADER_REAGENTINFO = "Reagenz Info";
BINDING_NAME_REAGENTINFO_CONFIG = "Zeigt das Konfigurationsmenu";

-- Configuration Screen Strings
REAGENTINFO_CONFIGFRAME_HELP = "Hilfe";
REAGENTINFO_CONFIGFRAME_MISCINFO = "Sonstige Optionen";
REAGENTINFO_GATHEREDBY = "Gesammelt durch";
REAGENTINFO_OPTIONS = "Reagenz Info Optionen";
REAGENTINFO_PROFESSIONS = "Berufe";
REAGENTINFO_SPELLREAGENT = "Zauberreagenz";

REAGENTINFO_COLORNAMES = {
["UsedByColor"] = "Berufe",
["GatheredByColor"] = "Sammelberufe",
["SpellReagentColor"] = "Zauberreagenzen",
};

-- Dropdown Strings
REAGENTINFO_DROPDOWN_TOP = "dar\195\188ber";
REAGENTINFO_DROPDOWN_BOTTOM = "darunter";
REAGENTINFO_DROPDOWN_OPTIMAL = "Orange";
REAGENTINFO_DROPDOWN_MEDIUM = "Gelb";
REAGENTINFO_DROPDOWN_EASY = "Gr\195\188n";
REAGENTINFO_DROPDOWN_TRIVIAL = "Grau";
REAGENTINFO_TOOLTIPLOCTEXT = "Reagenz Info Position (LootLink/ItemsMatrix)";

-- Recipe Strings
REAGENTINFO_NUMRECIPES = "Anzahl der Rezepte:";
REAGENTINFO_RECIPES = "Rezepte";
REAGENTINFO_RECIPETHRESHOLDTEXT = "Mininmalfarbe der Rezepte";
REAGENTINFO_TRADESKILLWARNING = "Reagenz Info: Die Anzeige der Rezepte funktioniert erst, nachdem das jeweilige Berufsfenster mindestens einmal ge\195\182ffnet wurde.";
REAGENTINFO_USEDIN = "Ben\195\182tigt f\195\188r Rezepte: " ;

-- Help Strings
ReagentInfo_CheckButton_GatheredBy_Label = "Sammelberufe";
ReagentInfo_CheckButton_GatheredBy_HelpText = "Reagenz Info zeigt die Berufe an welche diesen Gegestand sammeln";
ReagentInfo_CheckButton_SpellReagents_Label = "Zauberreagenzen";
ReagentInfo_CheckButton_SpellReagents_HelpText = "Reagenz Info zeigt die Klassen an, welche den Gegenstand f\195\188r Zauber ben\195\182tigen";
ReagentInfo_CheckButton_UsedBy_Label = "Berufe";
ReagentInfo_CheckButton_UsedBy_HelpText = "Reagenz Info zeigt die Berufe an f\195\188r welche dieser Gegenstand benutzt wird";

ReagentInfo_Profession_alchemy_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Alchimie genutzt werden";
ReagentInfo_Profession_blacksmithing_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Schmiedekunst genutzt werden"
ReagentInfo_Profession_cooking_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Kochkunst genutzt werden"
ReagentInfo_Profession_enchanting_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Verzaubern genutzt werden"
ReagentInfo_Profession_engineering_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Ingenieurskunst genutzt werden"
ReagentInfo_Profession_firstaid_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Erste Hilfe genutzt werden"
ReagentInfo_Profession_leatherworking_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Lederverarbeitung genutzt werden"
ReagentInfo_Profession_tailoring_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Schneiderei genutzt werden"

ReagentInfo_Gathering_fishing_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche beim Fischen geangelt werden";
ReagentInfo_Gathering_herbalism_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche bei Kr\195\164uterkunde gesammelt werden";
ReagentInfo_Gathering_mining_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von Bergbau abgebaut";
ReagentInfo_Gathering_skinning_HelpText = "Wenn aktiviert, zeigt Reagenz Info Reagenzen an welche von K\195\188rschnerei abgezogen";

ReagentInfo_DropDown_TooltipLoc_HelpText = "Bestimmt wo die Reagenz Info Informationen angezeigt werden wenn LootLink/ItemsMatrix benutzt wird";

ReagentInfo_NumRecipes_HelpText = "Die Anzahl der Rezepte welche im Tooltip angeigt werden (maximal 9)";

ReagentInfo_DropDown_RecipeThreshold_HelpText = "Bestimmt den niedrigsten Level der Rezepte, welche im Tooltip angezeigt werden.";

ReagentInfo_CheckButton_Recurse_Label = "Rezeptbaum anzeigen";
ReagentInfo_CheckButton_Recurse_HelpText = "Der 'Rezeptbaum' listet weitere Rezepte unter dem Rezept auf bei denen die damit erstellte Reagenz ben�tigt wird (bis zu 4 Ebenen).";
ReagentInfo_CheckButton_ShowRecipes_Label = "Zeige Rezepte";
ReagentInfo_CheckButton_ShowRecipes_HelpText = "Wenn aktiviert, zeigt Regenz Info die Rezepte an, f\195\188r welche dieser Gegenstand ben\195\182tigt wird";
REAGENTINFO_USAGE = "Benutzen: |cffffffff/ri enable|r - Aktiviert Reagenz Info\n|cffffffff/ri disable|r - Deaktiviert Reagenz Info\n|cffffffff/ri config|r - Zeigt das Konfigurationsmen\195\188\n|cffffffff/ri clear|r - Setzt die Einstellungen vom aktuellen Charakter zur\195\188ck\n|cffffffff/ri clearall|r - Setzt die Einstellungen vom allen Charakteren zur\195\188ck";

end