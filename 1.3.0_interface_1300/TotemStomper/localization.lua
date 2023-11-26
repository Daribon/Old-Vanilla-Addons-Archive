
-- Version : English - AlexYoshi, Sarf, Mugendai, Vjeux ...

-- <= == == == == == == == == == == == == =>
-- => Bindings Names
-- <= == == == == == == == == == == == == =>

BINDING_HEADER_TOTEMSTOMPER = "Totem Stomper";

BINDING_NAME_TOTEMSET1 = "Drop totem set A";
BINDING_NAME_TOTEMSET2 = "Drop totem set B";
BINDING_NAME_TOTEMSET3 = "Drop totem set C";
BINDING_NAME_TOTEMSET4 = "Drop totem set D";
BINDING_NAME_TOTEMSET5 = "Drop totem set E";

BINDING_NAME_TOTEMSHOW = "Toggle Totem Stomper";

-- <= == == == == == == == == == == == == =>
-- => Cosmos Settings
-- <= == == == == == == == == == == == == =>
COS_TS_SEPARATOR_TEXT = "Totem Stomper";
COS_TS_SEPARATOR_INFO = "Totem Stomper allows a shaman to group different totems together to be cast by one button.";
COS_TS_ENABLE_TEXT = "Enable Totem Stomper Keys";
COS_TS_ENABLE_INFO = "Checking here will allow the Stomper keys to work.";
COS_TS_DELAY_TEXT = "Modify Stomp Delay";
COS_TS_DELAY_INFO = "This allows you to tweak the time delay between allowed stomps. The default unchecked setting will attempt to calculate by cooldown.";
-- <= == == == == == == == == == == == == =>
-- => International Language Code
-- <= == == == == == == == == == == == == =>

TOTEMSTOMPER_HELP = " Use /stomp A-E or 1-5 (e.g. /stomp 2) to cast that Totem set. |cFFAA3333[Macro Only]|r";
TOTEMSTOMPER_INSTRUCTION = "Drag Totem spells from your\n spellbook into the boxes.\n Then press the set's keybind (x4)";
TOTEMSTOMPER_PARTY_INSTRUCTION = "Displays party Totem usage. \n Boxes remain empty until \na totem set is used.";
TOTEMSTOMPER_FULL_INSTRUCTIONS = "Instructions: \n Open the TotemStomper frame from the Cosmos menu, open your spellbook, then drag and drop or shift-click and drop the Totems you wish you use into the appropriate Set/Column. Then open the Keybindings and scroll to the bottom. Set a hotkey for Totem Sets A-E and then simply tap the totem set hotkey serveral times to drop the totems. It will cast the totems in the order they appear. (Open Totem Stomper and watch while you press the hotkeys if you don't understand how it is working)\nIt will default to waiting for the spell to cooldown before casting. If you want to skip spells you cannot cast yet, turn the 'wait' checkbox off. (not in the screenshot)\nYou can write the Totem Stomper action into a macro (for use with a normal action bar) with the /stomp command. Type /stomp A in a macro to try it out. "
TOTEMSTOMPER_TOTEMSHARE_INSTRUCTIONS = "Totem Share:\nTotem Share will now share the contents of your active TotemSet with all of your party members. It will then do cross-party Totem comparisons, then color the player with the Best totem of a particular type in green, players who are using the same totem & rank in red and players who are using inferior totems in grey.\nThis will only work if you're casting your Totems from Totem Stomper via the /stomp A macro command or the Totem Stomper hotkeys. ";
TOTEMSTOMPER_VERSION_TIP = "Made by AlexYoshi";
TOTEMSTOMPER_VERSION = "1.0";

TOTEMSTOMPER_WAIT_TIP = "Check here to wait for a spell \nto cooldown before cycling";
TOTEMSTOMPER_SKIP_TIP = "Check here to skip a spell \nand continue cycling";

VERSIONLABEL = "Version";
RESET = "Reset";


if ( GetLocale() == "frFR" ) then

elseif ( GetLocale() == "koKR" ) then

elseif ( GetLocale() == "deDE" ) then

   -- Thanks to DoctorVanGogh for this translation!
   -- last localization update: R211, 12/08/04
   BINDING_HEADER_TOTEMSTOMPER = "Totem Stomper";
   
   BINDING_NAME_TOTEMSET1 = "Totemgruppe A setzen";
   BINDING_NAME_TOTEMSET2 = "Totemgruppe B setzen";
   BINDING_NAME_TOTEMSET3 = "Totemgruppe C setzen";
   BINDING_NAME_TOTEMSET4 = "Totemgruppe D setzen";
   BINDING_NAME_TOTEMSET5 = "Totemgruppe E setzen";
   
   BINDING_NAME_TOTEMSHOW = "Totem Stomper ein-/ausschalten";
   
   -- <= == == == == == == == == == == == == =>
   -- => Cosmos Settings
   -- <= == == == == == == == == == == == == =>
   COS_TS_SEPARATOR_TEXT = "Totem Stomper";
   COS_TS_SEPARATOR_INFO = "Ein Schamane kann mit Totem Stomper verschiedene Totems zu Gruppen zusammenfassen, die dann mit einer Taste gezaubert werden können.";
   COS_TS_ENABLE_TEXT = "Totem Stomper Tasten aktivieren";
   COS_TS_ENABLE_INFO = "Falls aktiviert, so funktionieren die Totem Stomper Tastenbindungen.";
   COS_TS_DELAY_TEXT = "Zauber-Verzögerung ändern";
   COS_TS_DELAY_INFO = "Hiermit kann die Wartezwit zwischen zulässigen Zaubern verändert werden. Die deaktivierte Standardeinstellung versucht dies aus den Cooldowns zu errechnen."

   -- <= == == == == == == == == == == == == =>
   -- => International Language Code
   -- <= == == == == == == == == == == == == =>
   
   TOTEMSTOMPER_HELP = " Gebrauch: /stomp A-E oder 1-5 (z.B. /stomp 2) um diese Totemgruppe zu zaubern. |cFFAA3333[nur in Makros]|r";
   TOTEMSTOMPER_INSTRUCTION = "Totemsprüche aus dem Zauber-\n buch in die Kästchen ziehen.\n Dann das Kürzel der Gruppe drücken (4x)";
   TOTEMSTOMPER_PARTY_INSTRUCTION = "Gruppen Totemgebrauch anzeigen.\nKästchen bleiben leer \nbis eine Gruppe benutzt wird.";
   TOTEMSTOMPER_FULL_INSTRUCTIONS = "Anleitung: \n Über die Cosmos Einstellungen die TotemStomper Seite öffnen, die Spruchliste öffnen, danach per Drag & Drop oder Shift-Klick die Totems, die man benutzen möchte, in die entprechende Gruppe/Spalte ziehen. Nun die Tastenbelegung öffnen und nach unten scrollen. Eine Taste für die Gruppen A-E festlegen und anschließend einfach die zugewiesene Taste für die Gruppe mehrfach drücken, um die Totems zu setzen. Die Totems werden in der Reihenfolge gesetzt, wie sie angezeigt werden (Falls das unverständlich ist: TotemStomper öffnen und zuschauen, während man die Tasten drückt)\nStandardmässig wird der Cooldown jedes Totems abgewartet, bevor es gezaubert wird. Um Sprüche, die man noch zaubern kann, zu überspringen einfach das 'warten' Kontrollkästchen deaktivieren. (nicht im Bild)\nTotem Stomper Aktionen können per /stomp Befehl in Makros verwendet werden (zum Gebrauch mit den normalen Aktioneleisten). Zum Beispiel einmal /stomp A testweise in ein Makro einfügen und ausprobieren. ";
   TOTEMSTOMPER_TOTEMSHARE_INSTRUCTIONS = "Totem Share:\nTotem Share teilt jetzt die Inhalte der aktiven Totemgruppe allen Partymitgliedern mit. Es führt dann einen gruppeninternen Totemvergleich durch und nimmt folgende Farbcodierung vor: Der Spieler mit dem besten Totem einer bestimmten Art wird grün eingefärbt, Spieler, die ein Totem mit gleicher Art und Rang benutzen, werden rot und Spieler, die minderwertige Totems benutzen, grau eingefärbt.\nDies funktioniert nur, falls die Totems per /stomp Makro oder TotemStomper Tastenkürzel gesetzt wurden. ";
   TOTEMSTOMPER_VERSION_TIP = "Made by AlexYoshi";
   TOTEMSTOMPER_VERSION = "1.0";
   
   TOTEMSTOMPER_WAIT_TIP = "Hier klicken, um auf den Cool-\ndown eines Zaubers zu warten,\n bevor der nächste gewählt wird.";
   TOTEMSTOMPER_SKIP_TIP = "Hier klicken, um einen Zauber\nzu überspringen und direkt mit\n dem nächsten fortzufahren.";
   
   VERSIONLABEL = "Version";
   RESET = "Zurücksetzen"; 
end
