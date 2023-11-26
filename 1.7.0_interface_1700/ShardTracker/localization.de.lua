-- Version : German (by StarDust)
-- Last Update : 06/07/2005

if ( GetLocale() == "deDE" ) then

    BINDING_HEADER_SHARDTRACKERHEADER       = "SeelenW\195\164chter";
    BINDING_NAME_SHARDTRACKER               = "SeelenW\195\164chter ein-/ausschalten";

    -- cosmos variables
    SHARDTRACKER_CONFIG_HEADER              = "SeelenW\195\164chter";
    SHARDTRACKER_CONFIG_HEADER_INFO         = "Der SeelenW\195\164chter erlaubt es Hexenmeistern leichter verschieden Aspekte derer Seelensplitter und Gesundheitssteine zu \195\188berwachen, indem entsprechende kleine Icons rund um die Minikarte angezeigt werden.";
    SHARDTRACKER_CONFIG_ENABLED             = "SeelenW\195\164chter aktivieren";
    SHARDTRACKER_CONFIG_ENABLED_INFO        = "SeelenW\195\164chter aktivieren oder deaktivieren.";
    SHARDTRACKER_CONFIG_FLASH_HEALTH        = "Icon des Gesundheitssteins blinkend wenn keiner im Inventar";
    SHARDTRACKER_CONFIG_FLASH_HEALTH_INFO   = "Wenn aktiviert, blinkt das Icon des Gesundheitssteins wenn keiner mehr in den Taschen vorhanden ist.";
    SHARDTRACKER_CONFIG_SOUND               = "Akustische benachrichtigung";
    SHARDTRACKER_CONFIG_SOUND_INFO          = "Wenn aktiviert, wird ein Ger\195\164usch wiedergegeben sobald die Abklingzeit eines Seelensplitters abgelaufen ist und andere Gruppenmitglieder neue Gesundheitssteine ben\195\182tigen.";
    SHARDTRACKER_CONFIG_SOULPOP             = "Gruppenwarnung f\195\188r Seelensplitter aktivieren";
    SHARDTRACKER_CONFIG_SOULPOP_INFO        = "Wenn aktiviert, wird eine Warnung am Bildschirm angezeigt sobald die Abklingzeit des Seelensplitters abgelaufen ist.";
    SHARDTRACKER_CONFIG_MONITOR_PARTY       = "Gesundheitssteine von Gruppenmitgliedern \195\188berwachen";
    SHARDTRACKER_CONFIG_MONITOR_PARTY_INFO  = "Wenn aktiviert, wird die Anzahl der Gesundheitssteine von Gruppenmitgliedern \195\188berwacht und eine Warnung angezeigt sobald jemand weitere ben\195\182tigt.";
    SHARDTRACKER_CONFIG_RESTRICT            = "\195\156berwachung innerhalb der Gruppe einschr\195\164nken";
    SHARDTRACKER_CONFIG_RESTRICT_INFO       = "Wenn aktiviert, wird die \195\156berwachung der Gesundheitssteine innerhalb der Gruppe auf eine bestimmte Liste an Spielern beschr\195\164nkt.";
    SHARDTRACKER_RESET                      = "Position der Icons zur\195\188cksetzen";
    SHARDTRACKER_RESET_INFO                 = "Bewegt die Icons des SeelenW\195\164chters wieder zur\195\188ck an ihre urspr\195\188ngliche Position.";
    SHARDTRACKER_RESET_NAME                 = "Zur\195\188cksetzen";
    SHARDTRACKER_CENTER                     = "Icons zentriert anzeigen";
    SHARDTRACKER_CENTER_INFO                = "Bewegt die Icons des SeelenW\195\164chters in die Mitte des Bildschirms.";
    SHARDTRACKER_CENTER_NAME                = "Zentrieren";

    -- slash commands
    -- NOTE: if translating these, make sure they remain single-word only
    SHARDTRACKER_DEBUG_CMD       = "debug";
    SHARDTRACKER_TOGGLE_CMD      = "wechseln";
    SHARDTRACKER_ON_CMD          = "ein";
    SHARDTRACKER_OFF_CMD         = "aus";
    SHARDTRACKER_BAG_CMD         = "tasche";
    SHARDTRACKER_SORT_CMD        = "sortieren";
    SHARDTRACKER_LIMIT_CMD       = "limit";
    SHARDTRACKER_SOUND_CMD       = "sound";
    SHARDTRACKER_MONITOR_CMD     = "\195\188berwachen";
    SHARDTRACKER_HELP_CMD        = "hilfe";
    SHARDTRACKER_FLASH_CMD       = "blinken";
    SHARDTRACKER_LOCK_CMD        = "fixieren";
    SHARDTRACKER_UNLOCK_CMD      = "freigeben";
    SHARDTRACKER_INFO_CMD        = "info";
    SHARDTRACKER_RESET_CMD       = "r\195\188cksetzen";
    SHARDTRACKER_CENTER_CMD      = "zentrieren";
    SHARDTRACKER_TOGGLE_CMD      = "wechseln";
    SHARDTRACKER_SCALE_CMD       = "skalieren";
    SHARDTRACKER_SCALE_1_CMD     = "standard";
    SHARDTRACKER_SCALE_2_CMD     = "gro\195\159";
    SHARDTRACKER_SCALE_3_CMD     = "gewaltig";
    SHARDTRACKER_SCALE_4_CMD     = "supergr\195\182\195\159e";
    SHARDTRACKER_SOUL_POPUP_CMD  = "seelenpopup";
    SHARDTRACKER_SHARDBG_CMD     = "scherbehg";
    SHARDTRACKER_RESTRICT_CMD    = "einschr\195\164nken";
    SHARDTRACKER_ADD_CMD         = "hinzuf\195\188gen";
    SHARDTRACKER_REMOVE_CMD      = "entfernen";
    SHARDTRACKER_LIST_CMD        = "auflisten";
    SHARDTRACKER_SOULSOUND_CMD   = "seelensound";
    SHARDTRACKER_HEALTHSOUND_CMD = "heilensound";
    SHARDTRACKER_FLASHY_CMD      = "blinkend";
    SHARDTRACKER_NAGSOUL_CMD     = "heilenerinnern";
    SHARDTRACKER_NAGHEALTH_CMD   = "seelenerinnern";
    SHARDTRACKER_NAGCOUNT_CMD    = "seelenerinnerndauer";
    SHARDTRACKER_NAGFREQ_CMD     = "seelenerinnernfrequenz";
    SHARDTRACKER_MAXSHARDS_CMD   = "maxsplitter";
    SHARDTRACKER_NIGHTFALL_CMD   = "nightfall";
    SHARDTRACKER_SHARDEFFECT_CMD = "splittereffekt";
    SHARDTRACKER_AUTOSORT_CMD    = "autosort";

    -- Messages used to sync healthstone status
    SHARDTRACKER_GOT_HEALTHSTONE_MSG            = "hat einen Gesundheitsstein erhalten!";
    SHARDTRACKER_NEED_HEALTHSTONE_MSG           = "ben\195\182tigt einen weiteren Gesundheitsstein!";
    SHARDTRACKER_REQUEST_HEALTHSTONE_STATUS_MSG = "SeelenW\195\164chter synchronisiert die Gruppeninformationen.";
    SHARDTRACKER_SYNC_HEALTHSTONE_YES_MSG       = "besitzt einen Gesundheitsstein.";
    SHARDTRACKER_SYNC_HEALTHSTONE_NO_MSG        = "besitzt keinen Gesundheitsstein.";
    SHARDTRACKER_CHAT_PREFIX                    = "<SW>";

    -- tooltip text
    SHARDTRACKER_SHARDBUTTON_TIP1           = "SeelenW\195\164chter : Seelensplitter";
    SHARDTRACKER_SHARDBUTTON_TIP2           = "Zeigt die Anzahl der Seelensplitter in den eigenen Taschen. ";
    SHARDTRACKER_SHARDBUTTON_TIP3           = "Hier klicken, um die Seelensplitter in den eigenen Taschen entsprechend ";
    SHARDTRACKER_SHARDBUTTON_TIP4           = "der Einstellung '/shardtracker bag [0-4]'  zu sortieren.";

    SHARDTRACKER_HEALTHBUTTON_TIP1          = "SeelenW\195\164chter : Gesundheitsstein";
    SHARDTRACKER_HEALTHBUTTON_TIP2          = "Hier klicken um den h\195\182chsten verf\195\188gbaren Gesundheitsstein zu erschaffen.";
    SHARDTRACKER_HEALTHBUTTON_TIP3          = "Erneut klicken um den Gesundheitsstein zu benutzen oder einen Spieler anw\195\164hlten ";
    SHARDTRACKER_HEALTHBUTTON_TIP4          = "und klicken um den Gesundheitsstein an jenen Spieler zu geben. ";
    SHARDTRACKER_HEALTHBUTTON_TIP5          = "Hier klicken um den Gesundheitsstein zu benutzen.";

    SHARDTRACKER_SOULBUTTON_TIP1            = "SeelenW\195\164chter : Seelensteine";
    SHARDTRACKER_SOULBUTTON_TIP2            = "Hier klicken um den h\195\182chsten verf\195\188gbaren Seelenstein zu erschaffen. ";
    SHARDTRACKER_SOULBUTTON_TIP3            = "Erneut klicken um den Seelenstein auf den anw\195\164hlten Spieler zu benutzen. ";
    SHARDTRACKER_SOULBUTTON_TIP4            = "Die Zahl zeigt die Abklingzeit an, wann ein Seelenstein erneut benutzt wrerden kann. ";
    SHARDTRACKER_SOULBUTTON_TIP5            = "(zu diesem Zeitpunkt blinkt dieses Icon).";

    SHARDTRACKER_SPELLBUTTON_TIP1           = "SeelenW\195\164chter : Zaubersteine";
    SHARDTRACKER_SPELLBUTTON_TIP2           = "Hier klicken um den h\195\182chsten verf\195\188gbaren Zauberstein zu erschaffen. ";
    SHARDTRACKER_SPELLBUTTON_TIP3           = "Erneut klicken um den Zauberstein anzulegen. Sobald die Abklingzeit abgelaufen ist ";
    SHARDTRACKER_SPELLBUTTON_TIP4           = "wird durch ein Klicken der Zauberstein verwendet und der zuvor benutzte Gegenstand ";
    SHARDTRACKER_SPELLBUTTON_TIP5           = "aus der Schildhand wieder angelegt.";

    SHARDTRACKER_FIREBUTTON_TIP1            = "SeelenW\195\164chter : Feuersteine";
    SHARDTRACKER_FIREBUTTON_TIP2            = "Hier klicken um den h\195\182chsten verf\195\188gbaren Feuerstein zu erschaffen. ";
    SHARDTRACKER_FIREBUTTON_TIP3            = "Erneut klicken um den Feuerstein anzulegen. Durch erneutes klicken ";
    SHARDTRACKER_FIREBUTTON_TIP4            = "wird der Feuerstein wieder abgelegt und der zuvor benutzte Gegenstand ";
    SHARDTRACKER_FIREBUTTON_TIP5            = "aus der Schildhand wieder angelegt.";

    SHARDTRACKER_PARTYHEALTH_TIP1           = "SeelenW\195\164chter : Gesundheitssteine der Gruppe";
    SHARDTRACKER_PARTYHEALTH_TIP2           = "Wenn dieses Icon nicht blinkt, hat das betroffene Gruppenmitglied einen Gesundheitsstein. ";
    SHARDTRACKER_PARTYHEALTH_TIP3           = "Wenn dieses icon blinkt, ben\195\182tigt das betroffene Gruppenmitglied einen Gesundheitsstein.";

    SHARDTRACKER_SHARDBUTTON_STATUS1        = "(Klicken zum Sortieren)";
    SHARDTRACKER_HEALTHBUTTON_STATUS1       = "(Klicken zum Benutzen)";
    SHARDTRACKER_HEALTHBUTTON_STATUS2       = "(Klicken zum Erschaffen)";
    SHARDTRACKER_SOULBUTTON_STATUS1         = "(Klicken zum Benutzen)";
    SHARDTRACKER_SOULBUTTON_STATUS2         = "(Warte bis abgeklungen)";
    SHARDTRACKER_SOULBUTTON_STATUS3         = "(Klicken zum Erschaffen)";
    SHARDTRACKER_SPELLBUTTON_STATUS1        = "(Klicken zum Benutzen)";
    SHARDTRACKER_SPELLBUTTON_STATUS2        = "(Warte bis abgeklungen)";
    SHARDTRACKER_SPELLBUTTON_STATUS3        = "(Klicken zum Anlegen)";
    SHARDTRACKER_SPELLBUTTON_STATUS4        = "(Klicken zum Erschaffen)";
    SHARDTRACKER_FIREBUTTON_STATUS1         = "(Klicken zum Anlegen)";
    SHARDTRACKER_FIREBUTTON_STATUS2         = "(Klicken zum Ablegen)";
    SHARDTRACKER_FIREBUTTON_STATUS3         = "(Klicken zum Erschaffen)";
    SHARDTRACKER_BUTTON_CTRLCLICKTEXT       = "(Strg-Klick zum Festlegen der Textfarbe)";
    SHARDTRACKER_BUTTON_SHIFTCLICKTEXT1     = "(Shift-Klick zum ";
    SHARDTRACKER_BUTTON_SHIFTCLICKTEXT2     = "nicht ";
    SHARDTRACKER_BUTTON_SHIFTCLICKTEXT3     = "Stummschalten)";

    -- popup messages
    SHARDTRACKERSORT_SORTING                = "Sortierung des SeelenW\195\164chters";
    SHARDTRACKER_SOULSTONEREADYMSG          = "Seelenstein ist bereit!";

    -- key bindings
    BINDING_HEADER_SHARDTRACKER_HEADER      = "SeelenW\195\164chter";
    BINDING_NAME_SHARDBUTTON_BINDING        = "Seelensplitter Icon";
    BINDING_NAME_HEALTHBUTTON_BINDING       = "Gesundheitsstein Icon";
    BINDING_NAME_SOULBUTTON_BINDING         = "Seelenstein Icon";
    BINDING_NAME_SPELLBUTTON_BINDING        = "Zauberstein Icon";
    BINDING_NAME_FIREBUTTON_BINDING         = "Feuerstein Icon";

    -- localization / translation text
    SHARDTRACKER_LOCALIZATION_WARLOCK                  = "Hexenmeister";     
    SHARDTRACKER_LOCALIZATION_SPELLSTONE               = "Zauberstein";  
    SHARDTRACKER_LOCALIZATION_FIRESTONE                = "Feuerstein";  
    SHARDTRACKER_LOCALIZATION_SOULSHARD                = "Seelensplitter";  
    SHARDTRACKER_LOCALIZATION_SOULSTONE                = "Seelenstein";  
    SHARDTRACKER_LOCALIZATION_HEALTHSTONE              = "Gesundheitsstein"; 
    SHARDTRACKER_LOCALIZATION_CREATEHEALTHSTONEMINOR   = "Gesundheitsstein herstellen (schwach)";
    SHARDTRACKER_LOCALIZATION_CREATEHEALTHSTONELESSER  = "Gesundheitsstein herstellen (gering)"; 
    SHARDTRACKER_LOCALIZATION_CREATEHEALTHSTONE        = "Gesundheitsstein herstellen";
    SHARDTRACKER_LOCALIZATION_CREATEHEALTHSTONEGREATER = "Gesundheitsstein herstellen (gro\195\159)"; 
    SHARDTRACKER_LOCALIZATION_CREATEHEALTHSTONEMAJOR   = "Gesundheitsstein herstellen (erheblich)"; 
    SHARDTRACKER_LOCALIZATION_CREATESOULSTONEMINOR     = "Seelenstein herstellen (schwach)"; 
    SHARDTRACKER_LOCALIZATION_CREATESOULSTONELESSER    = "Seelenstein herstellen (gering)";
    SHARDTRACKER_LOCALIZATION_CREATESOULSTONE          = "Seelenstein herstellen";
    SHARDTRACKER_LOCALIZATION_CREATESOULSTONEGREATER   = "Seelenstein herstellen (gro\195\159)";
    SHARDTRACKER_LOCALIZATION_CREATESOULSTONEMAJOR     = "Seelenstein herstellen (erheblich)";
    SHARDTRACKER_LOCALIZATION_CREATESPELLSTONE         = "Zauberstein herstellen";
    SHARDTRACKER_LOCALIZATION_CREATESPELLSTONEGREATER  = "Zauberstein herstellen (gro\195\159)";
    SHARDTRACKER_LOCALIZATION_CREATESPELLSTONEMAJOR    = "Zauberstein herstellen (erheblich)";
    SHARDTRACKER_LOCALIZATION_CREATEFIRESTONELESSER    = "Feuerstein herstellen (gering)";
    SHARDTRACKER_LOCALIZATION_CREATEFIRESTONE          = "Feuerstein herstellen";
    SHARDTRACKER_LOCALIZATION_CREATEFIRESTONEGREATER   = "Feuerstein herstellen (gro\195\159)"; 
    SHARDTRACKER_LOCALIZATION_CREATEFIRESTONEMAJOR     = "Feuerstein herstellen (erheblich)"; 
    SHARDTRACKER_LOCALIZATION_JOINSTHEPARTY            = "ist der Gruppe beigetreten."; 
    SHARDTRACKER_LOCALIZATION_LEAVESTHEPARTY           = "hat die Gruppe verlassen.";
    SHARDTRACKER_LOCALIZATION_GROUPDISBANDED           = "Deine Gruppe wurde aufgel\195\182st.";
    SHARDTRACKER_LOCALIZATION_YOULEAVEGROUP            = "Du hast die Gruppe verlassen.";
    SHARDTRACKER_SOULSTONERES                          = "Seelenstein Wiederbelebung";
    SHARDTRACKER_COOLDOWN                              = "Verbleibende Abklingzeit";
    SHARDTRACKER_COMMON                                = "Gemeinsprache";
    SHARDTRACKER_ORCISH                                = "Orcisch";
    SHARDTRACKER_HUMAN                                 = "Menschlich";
    SHARDTRACKER_DWARF                                 = "Zwergisch";
    SHARDTRACKER_NIGHTELF                              = "Nachtelfisch";
    SHARDTRACKER_GNOME                                 = "Gnomisch";
    SHARDTRACKER_SSREADYTOCAST                         = "Seelenstein Wiederbelebung kann jetzt benutzt werden!";
    ST_LIMITANSWER                                     = "SeelenW\195\164chter: Mindestanzahl der Splitter bevor der Splitterbutton blinkt gesetzt auf ";
    ST_LIMITUSAGE                                      = "Benutzung: /st limit [0-20]";
    ST_ONLYFORWARLOCKS                                 = "Diese Funktion ist nur f\195\188r Hexenmeister verf\195\188gbar.";
    ST_SPELLSTONEERROR                                 = "SeelenW\195\164chter: Kann Zauber- oder Feuerstein nicht anlegen! M\195\182glicherweise ist in den Taschen kein freier Platz mehr frei um die momentate Waffe der Haupthand abzulegen?";
    ST_DRAGERROR                                       = "Um die Buttons des SeelenW\195\164chters neu anzuordnen, m\195\188ssen jene zuvor mittels \"/st freigeben\" freigegeben werden.";
    ST_LOCKMSG                                         = "SeelenW\195\164chter auf der momentanen Position fixiert. Um jene neu anzuordnen, m\195\188ssen sie zuerst mittels des \"/st freigeben\" Befehls wieder freigegeben werden.";
    ST_UNLOCKMSG                                       = "SeelenW\195\164chter wieder freigegeben. Jene k\195\182nnen jetzt wieder frei auf dem Bildschirm angeordnet werden. Wenn freigegeben, sind die Buttons NICHT FUNKTIONSF\195\132HIG. Um jene auf der momentanen Position zu fixieren, benutze den \"/st fixieren\" Befehl.";
    ST_SCALECHANGE                                     = "SeelenW\195\164chter Button Skalierung gesetzt auf ";
    ST_SCALEUSAGE                                      = "Benutzung: /st skalieren ";
    ST_HEALTHSTONEFLASH                                = "SeelenW\195\164chter: Gesundheitssteinbutton blinkt jetzt wenn ein neuer ben\195\182tigt wird.";
    ST_HEALTHSTONEFLASHOFF                             = "SeelenW\195\164chter: Gesundheitssteinbutton blinkt nicht mehr wenn ein neuer ben\195\182tigt wird.";
    ST_TOGGLEUSAGE                                     = "Benutzung: /st wechseln \[shards\|healthstone\|soulstone\|spellstone\|firestone\]";
    ST_SOUNDON                                         = "SeelenW\195\164chter: Sound Ein";
    ST_SOUNDOFF                                        = "SeelenW\195\164chter: Sound Aus";
    ST_POPUPENABLED                                    = "SeelenW\195\164chter: Seelenstein Popup-Benachrichtigung aktiviert.";
    ST_POPUPDISABLED                                   = "SeelenW\195\164chter: Seelenstein Popup-Benachrichtigung deaktiviert.";
    ST_MONITORINGON                                    = "SeelenW\195\164chter wird nur mit Gruppenmitgliedern auf deiner Kommunikationsliste kommunizieren.";
    ST_MONITORINGOFF                                   = "SeelenW\195\164chter wird versuchen mit allen Gruppenmitgliedern zu kommunizieren.";
    ST_BGENABLED                                       = "SeelenW\195\164chter: Seelensplitter Button Hintergrund aktiviert.";
    ST_BGDISABLED                                      = "SeelenW\195\164chter: Seelensplitter Button Hintergrund deaktiviert.";
    ST_PARTYMONITORINGON                               = "SeelenW\195\164chter \195\188berwacht die Gesundheitssteine der Gruppenmitglieder. Damit dies funktioniert, m\195\188ssen die anderen Gruppenmitglieder ebenfalls den SeelenW\195\164chter installiert haben. Um dies zu deaktivieren benutze \"/st \195\188berwachen aus\".";
    ST_PARTYMONITORINGOFF                              = "SeelenW\195\164chter \195\188berwacht nicht die Gesundheitssteine der Gruppenmitglieder. Um dies zu aktivieren benutze \"/st \195\188berwachen an\" - funktioniert nur bei Gruppenmitgliedern welche ebenfalls den SeelenW\195\164chter installiert haben.";
    ST_FLASHYGRAPHICSON                                = "SeelenW\195\164chter: Erweiterte Grafik aktiviert.";
    ST_FLASHYGRAPHICSOFF                               = "SeelenW\195\164chter: Erweiterte Grafik deaktiviert.";
    ST_SOULNAGON                                       = "SeelenW\195\164chter wird dich nun erinnern um Seelenstein Wiederbelebung erneut zu zaubern.";
    ST_SOULNAGOFF                                      = "SeelenW\195\164chter wird dich nicht mehr erinnern um Seelenstein Wiederbelebung erneut zu zaubern.";
    ST_HEALTHNAGON                                     = "SeelenW\195\164chter wird dich nun erinnern, wenn Gruppenmitglieder einen neuen Gesundheitsstein ben\195\182tigen.";
    ST_HEALTHNAGOFF                                    = "SeelenW\195\164chter wird dich nicht mehr erinnern, wenn Gruppenmitglieder einen neuen Gesundheitsstein ben\195\182tigen.";
    ST_NAGINTERVAL1				       = "SeelenW\195\164chter wird dich alle ";
    ST_NAGINTERVAL2                                    = " Sekunde(n) wegen Gesundheits- und Seelensteinen erinnern.";
    ST_NAGCOUNT1                                       = "SeelenW\195\164chter wird dich ";
    ST_NAGCOUNT2                                       = " mal erinnern bevor er aufgibt.";
    ST_NAGCOUNT3                                       = "unendlich (oder bis du wahnsinnig wirst) erinnern.";
    ST_NEEDCHRONOS                                     = "Hinweis: Chronos mu\195\159 installiert sein damit dies funktioniert. Falls nicht, schaue bitte unter www.wowwiki.com/Chronos nach um Details zu erhalten.";
    ST_MAXSHARDSSET1				       = "SeelenW\195\164chter: Maximal erlaubte Anzahl an Seelensplittern im Inventar festgelegt auf ";
    ST_MAXSHARDSSET2                                   = "Jeder weitere Splitter wird automatisch vernichtet. Benutzung auf eigene Gefahr! Um die Anzahl auf unendlich zu setzen einfach 0 eingeben.";
    ST_MAXSHARDSSETUNLIMITED                           = "SeelenW\195\164chter: Du kannst jetzt unendlich (soweit Taschenpl\195\164tze verf\195\188gbar sind) viele Splitter im Inventar halten.";
    ST_MAXSHARDSERROR                                  = "Benutzung: /shardtracker maxsplitter <n>, wobei n die maximal erlaubte Anzahl an Seelensplittern, welche du im Inventar halten m\195\182chtest. Gib f\195\188r n 0 ein um diese Anzahl auf unendlich zu setzen.";
    ST_DELETEDASHARD                                   = "SeelenW\195\164chter: Seelensplitter gel\195\182scht!";
    ST_NIGHTFALLEFFECTON                               = "SeelenW\195\164chter: Nightfall Effect aktiviert.";
    ST_NIGHTFALLEFFECTOFF                              = "SeelenW\195\164chter: Nightfall Effect deaktiviert.";
    ST_SHARDEFFECTON                                   = "SeelenW\195\164chter: Splitter-Erstellunseffekt aktiviert.";
    ST_SHARDEFFECTOFF                                  = "SeelenW\195\164chter: Splitter-Erstellunseffekt deaktiviert.";
    ST_BUTTONSARELOCKED                                = "Um diesen Button zu benutzen, mu\195\159 das Fenster des SeelenW\195\164chters mittels \"/st lock\" fixiert werden.";
    ST_AUTOSORTON                                      = "SeelenW\195\164chter: Splitter werden jetzt automatisch entsprechend dem \"/st bag\" Befehl im Inventar sortiert, sobald du einen Spiltter bekommst.";
    ST_AUTOSORTOFF                                     = "SeelenW\195\164chter: Automatische Sortierung deaktiviert. Um die Splitter manuell zu sortieren, klicke bitte auf den Seelensplitter-Button.";

    -- info messages
    ST_SHOWINFO_MSG1    = "SeelenW\195\164chter hilft dem Hexenmeister beim Verwalten von Seelensplittern.";
    ST_SHOWINFO_MSG2    = "Dieses AddOn hat 2 grundlegende Funktionen: selbst informiert zu bleiben \195\188ber eigene Splitter und \195\188ber Gesundheitssteine der Gruppenmitglieder. Zuerst werden die eigenen Splitter mit Hilfe von 4 kleinen Buttons \195\188berwacht, welche standardm\195\164\195\159ig oben rund um die Minikarte angepordnet sind aber \195\182berall hin mittels der Befehle "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_LOCK_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." und "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET.."freigeben"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." verschoben werden k\195\182nnen.";
    ST_SHOWINFO_MSG3    = "(Note: grabbing onto the buttons to drag can be hit and miss.)";
    ST_SHOWINFO_MSG4    = "You can also scale the buttons using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SCALE_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.  Four scales are available: regular, large, biggie, and supersizeme.";
    ST_SHOWINFO_MSG5    = "You may toggle the background image of the Shard button using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SHARDBG_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.  Finally, you can "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_RESET_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." the positions of the buttons to their original locations, or if other objects are blocking the original locations, you can use the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_CENTER_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.."command to center them onscreen for your placement.";
    ST_SHOWINFO_MSG6    = "The Soul Shard button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." lets you know how many shards you have in your inventory.  This button will turn red and flash when the number of shards drops below a certain level.  Currently this level is set to ";
    ST_SHOWINFO_MSG6a   = ", but you may set it to any number you like using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_LIMIT_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
    ST_SHOWINFO_MSG7    = "Clicking on this button will sort your shards (including Healthstone, Soulstone, and Spellstones) into the pack of your choice.  Right now, this is set to pack number ";
    ST_SHOWINFO_MSG7a   = ", but you may change this using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_BAG_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
    ST_SHOWINFO_MSG8    = "The Healthstone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." lets you know if you have a Healthstone.  If you don't have one, clicking on this button will create your highest rank Healthstone.";
    ST_SHOWINFO_MSG9    = "Clicking again will use your Healthstone.  Additionally, if you have a friendly player selected, clicking will place the Healthstone into a trade window with that player.";
    ST_SHOWINFO_MSG10   = "The Soulstone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." informs you about the status of your Soulstone.";
    ST_SHOWINFO_MSG11   = "When you have no Soulstone, the button will be greyed.  Clicking on this button will create your highest rank Soulstone.";
    ST_SHOWINFO_MSG12   = "Clicking again will cast Soulstone Resurrection on any friendly target you have selected.  Once cast, the Soulstone button will show a counter representing the number of minutes until you can cast your next Soulstone Resurrection spell.";
    ST_SHOWINFO_MSG13   = "When this countdown ends, an alarm will sound and the button will flash to remind you to re-cast Soulstone Resurrection.  You can optionally disable the audible alarm using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SOUND_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
    ST_SHOWINFO_MSG14   = "To disable the popup notification, use the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_SOUL_POPUP_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.";
    ST_SHOWINFO_MSG15   = "The Spellstone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." shows your Spellstone status.  Clicking this button will create your highest rank Spellstone.";
    ST_SHOWINFO_MSG16   = "Clicking again will equip your spellstone and display the number of seconds until you can use your Spellstone.  Once the timer ends, clicking will activate your Spellstone as well as automatically re-equip whatever weapon you were wielding before you equipped the Spellstone.";
    ST_SHOWINFO_MSG15a  = "The Firestone button"..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." shows your Firestone status.  Clicking this button will create your highest rank Firestone.";
    ST_SHOWINFO_MSG16a  = "Clicking again will equip your Firestone.  When equipped, clicking will unequip your Firestone and automatically re-equip whatever weapon you were wielding before you equipped the Spellstone.";
    ST_SHOWINFO_MSG17   = "The second functionally of the AddOn involves notifying you of your party members' Healthstone status.  Whenever a party member gains a Healthstone, an icon will appear over her party portrait.  When a party member uses her Healthstone, this icon will flash and an alarm will sound.";
    ST_SHOWINFO_MSG18   = "For this functionality to work, party members must also be running the Shardtracker AddOn.";
    ST_SHOWINFO_MSG19   = "You may optionally disable this functionality using the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_MONITOR_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command.   In addition, you may create a list of players to monitor.  Only those players in your list will receive communication from ShardTracker.";
    ST_SHOWINFO_MSG20   = "You can "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_ADD_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." or "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_REMOVE_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." players from this list, and use the "..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_VIOLET..SHARDTRACKER_RESTRICT_CMD..SHARDTRACKER_COLOR_CLOSE..SHARDTRACKER_COLOR_GREEN.." command to enable or disable the list.  Players running Cosmos that aren't on your list will still have their Healthstones monitored, but ShardTracker will do so silently.";
    ST_SHOWINFO_MSG21   = "For specific commands, please see /shardtracker help.";

    -- help messages
    ST_HELP_MSG1     = "SeelenW\195\164chter, ein AddOn von Cragganmore. ";
    ST_HELP_MSG1A    = "\"Deine Seele geh\195\182rt mir!\"";
    ST_HELP_MSG2     = "Basierend auf Code von Kithador und Ryu";
    ST_HELP_MSG3     = "Benutzung: ";
    ST_HELP_MSG4     = "/shardtracker <Befehl>";
    ST_HELP_MSG5     = " oder ";
    ST_HELP_MSG6     = "/st <Befehl>";
    ST_HELP_MSG7     = "Aktiviert/Deaktiviert den SeelenW\195\164chter.";
    ST_HELP_MSG8     = "\195\182 den jeweiligen Button.";
    ST_HELP_MSG9     = "Aktiviert/Deaktiviert die \195\156berwachung der Gesundheitssteine von Gruppenmitgliedern.";
    ST_HELP_MSG10    = "Legt die Standardtasche f\195\188r Sortierung der Steine fest (0 = Rucksack, 4 = linkeste Tasche).";
    ST_HELP_MSG11    = "Sortiert die Steine in der Standardtasche (welche mit dem \"tasche\" Befehl festgelegt wurde).";
    ST_HELP_MSG12    = "Wenn die Gesamtanzahl der Steine kleiner als diese Nummer wird, f\195\164ngt der Button zur Warnung an zu blinken.";
    ST_HELP_MSG13    = "Aktiviert/Deaktiviert akustische Warnungen.";
    ST_HELP_MSG14    = "Aktiviert/Deaktiviert die Seelenstein Popup-Benachrichtigung.";
    ST_HELP_MSG15    = "Aktiviert/Deaktiviert Button Hintergrundgrafik.";
    ST_HELP_MSG16    = "Legt fest, ob der Gesundheitsstein Button blinken soll sobald weitere ben\195\182tigt werden.";
    ST_HELP_MSG17    = "Wenn offen, werden alle Buttons des SeelenW\195\164chters deaktiviert und jene k\195\182nnen dann frei am Bildschirm positioniert werden.";
    ST_HELP_MSG18    = "Wenn gesperrt,sind alle Buttons des SeelenW\195\164chters aktiv und jene k\195\182nnen nicht verschoben werden.";
    ST_HELP_MSG19    = "Setzt alle Buttons des SeelenW\195\164chters auf deren Standardposition zur\195\188ck.";
    ST_HELP_MSG20    = "Plaziert die Buttons des SeelenW\195\164chters in der Mitte des Bildschirms falls jene wegen anderer Buttons in der N\195\164he der Minikarte nicht erreichbar sind.";
    ST_HELP_MSG21    = "Legt die Gr\195\182\195\159e/Skalierung der Buttons des SeelenW\195\164chters fest.";
    ST_HELP_MSG22    = "Wenn aktiviert, kommuniziert der SeelenW\195\164chters nur mit Gruppenmitgliedern die auf der \"zur Kommunikation freigegeben\" Liste stehen. Hinweis: Gruppenmitglieder welche Cosmos installiert haben werden immer \195\188berwacht, aber still im Hintergrund.";
    ST_HELP_MSG23    = "F\195\188gt einen Spieler zur \"zur Kommunikation freigegeben\" Liste hinzu.";
    ST_HELP_MSG24    = "Entfernt einen Spieler von der \"zur Kommunikation freigegeben\" Liste.";
    ST_HELP_MSG25    = "Zeigt die \"zur Kommunikation freigegeben\" Liste an.";
    ST_HELP_MSG26    = "Zeigt eine genaue Beschreibung des SeelenW\195\164chters an.";
    ST_HELP_MSG27    = "Zeigt diese Nachricht an.";
    ST_HELP_MSG28    = "Beispiel: \"/st blinkend aus\" deaktiviert das Blinken des Gesundheitsstein Buttons.";
    ST_HELP_MSG29    = "Legt das Ger\195\164usch fest, welches abgespielt wird sobald ein Seelenstein erneut gezaubert werden kann.";
    ST_HELP_MSG30    = "Legt das Ger\195\164usch fest, welches abgespielt wird sobald ein Mitspieler einen weiteren Gesundheitsstein ben\195\182tigt.";
    ST_HELP_MSG31    = "Aktiviert/Deaktiviert erweiterte Grafikeffekte.";
    ST_HELP_MSG32    = "Aktiviert/Deaktiviert Erinnerung f\195\188r Seelensteine.";
    ST_HELP_MSG33    = "Aktiviert/Deaktiviert Erinnerung f\195\188r Gesundheitssteine.";
    ST_HELP_MSG34    = "Legt den Abstand in Sekunden zwischen jeder Erinnerung fest.";
    ST_HELP_MSG35    = "Legt die Anzahl der Erinnerungen fest (0 = unendlich!).";
    ST_HELP_MSG36    = "Legt die maximal erlaubte Anzahl an Seelensplittern im Inventar fest (extra Splitter werden automatisch erkannt). Setze dies auf 0 um unendlich viele Splitter zu erlauben.";
    ST_HELP_MSG37    = "Wenn aktiviert, gl\195\188ht dein Bildschirm violett sobald du die Nightfall Aura bekommst. (Ben\195\182tigt das ColorCycle AddOn.)"
    ST_HELP_MSG38    = "Wenn aktiviert, blitzt dein Bildschirm sobald du einen Seelensplitter bekommst. (Ben\195\182tigt das ColorCycle AddOn.)"
    ST_HELP_MSG39    = "Wenn aktiviert, sortiert der SeelenW\195\164chter automatisch deine Splitter in den Taschen entsprechend dem \"bag\" Befehl."
    ST_HELP_ENABLED  = " (aktiviert)";
    ST_HELP_DISABLED = " (deaktiviert)";

end