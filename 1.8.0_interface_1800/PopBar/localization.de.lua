-- Version : German (by pc, StarDust)
-- Last Update : 02/17/2005

if ( GetLocale() == "deDE" ) then

	-- Binding Configuration
	BINDING_HEADER_POPBARHEADER		= "Pop Bar (Zeile/Spalte)";
	BINDING_NAME_TOGGLEPOPBAR		= "Pop Bar ein-/ausschalten";

	-- Cosmos Configuration
	POPBAR_BINDING_BUTTON			= "Pop Bar Button";
	POPBAR_CONFIG_HEADER			= "Pop Bar"
	POPBAR_CONFIG_HEADER_INFO		= "Diese Einstellungen konfigurieren Pop Bar.";
	POPBAR_CONFIG_ONOFF			= "Pop Bar aktivieren";
	POPBAR_CONFIG_ONOFF_INFO		= "Wenn aktiviert, wird die Pop Bar dargestellt.";
	POPBAR_CONFIG_PAGES			= "Seite mit Aktionsleiste wechsel"
	POPBAR_CONFIG_PAGES_INFO		= "Wenn aktiviert, wechselt die Pop Bar die dargestellte Seite wenn die Aktionsleiste jene wechselt."
	POPBAR_CONFIG_HIDEEMPTY			= "Leere Buttons verbergen";
	POPBAR_CONFIG_HIDEEMPTY_INFO		= "Wenn aktiviert, werden Buttons denen keine Aktion zugeweisen ist automatisch ausgeblendet.";
	POPBAR_CONFIG_HIDEKEYS			= "Tastenbelegung verbergen";
	POPBAR_CONFIG_HIDEKEYS_INFO		= "Wenn aktiviert, werden auf den Buttons die Tastenbelegungen nicht angezeigt.";
	POPBAR_CONFIG_HIDEKEYMOD		= "Zusatztasten verbergen";
	POPBAR_CONFIG_HIDEKEYMOD_INFO		= "Wenn aktiviert, werden die Zusatztasten der Tastenbelegung nicht angezeigt. So wird zum Beispiel anstatt 'ALT-1' nur '1' angezeigt.";
	POPBAR_CONFIG_ORIENT			= "Leiste horizontal anordnen";
	POPBAR_CONFIG_ORIENT_INFO		= "Sollte aktiviert werden wenn man die Pop Bar als Seitenleiste benutzen will.";
	POPBAR_CONFIG_AREA			= "Anzeigen wenn Mauszeiger im Berich";
	POPBAR_CONFIG_AREA_INFO			= "Zeigt die Pop Bar an, wenn der Mauszeiger \195\188ber den Bereich bewegt wird in dem die Pop Bar angezeigt werden w\195\188rde.";
	POPBAR_CONFIG_HANCHOR			= "Nach links expandieren";
	POPBAR_CONFIG_HANCHOR_INFO		= "Wenn aktiviert, expandiert die Pop Bar nicht nach rechts sondern nach links.";
	POPBAR_CONFIG_VANCHOR			= "Nach unten expandieren";
	POPBAR_CONFIG_VANCHOR_INFO		= "Wenn aktiviert, expandiert die Pop Bar nicht nach oben sondern nach unten.";
	POPBAR_CONFIG_POPTIME			= "PopUp Zeitverz\195\182gerung";
	POPBAR_CONFIG_POPTIME_INFO		= "Setzt die Verz\195\182gerung, wielange die Maus auf der Pop Bar verweilen mu\195\159, damit jene erscheint.";
	POPBAR_CONFIG_POPTIME_NAME		= "Verz\195\182gerung";
	POPBAR_CONFIG_POPTIME_SUFFIX		= " Sek.";
	POPBAR_CONFIG_KNOBALPHA			= "Transparenz des Ankerpunkt";
	POPBAR_CONFIG_KNOBALPHA_INFO		= "Legt die Transparenz/Durchsichtigkeit des Anchor-Buttons (zum Verschieben der Pop Bar) fest.";
	POPBAR_CONFIG_KNOBALPHA_NAME		= "Transparenz";
	POPBAR_CONFIG_KNOBALPHA_SUFFIX		= "%";
	POPBAR_CONFIG_BARALPHA			= "Pop Bar Transparenz";
	POPBAR_CONFIG_BARALPHA_INFO		= "Legt die Transparenz/Durchsichtigkeit der Pop Bar fest.";
	POPBAR_CONFIG_BARALPHA_NAME		= "Transparenz";
	POPBAR_CONFIG_BARALPHA_SUFFIX		= "%";
	POPBAR_CONFIG_ROWS			= "Anzahl der Zeilen";
	POPBAR_CONFIG_ROWS_INFO			= "Die Anzahl der Zeilen, welche die Pop Bar besitzen soll.";
	POPBAR_CONFIG_ROWS_NAME			= "Zeilen";
	POPBAR_CONFIG_ROWS_SUFFIX		= "";
	POPBAR_CONFIG_COLS			= "Anzahl der Spalten";
	POPBAR_CONFIG_COLS_INFO			= "Die Anzahl der Spalten, welche die Pop Bar besitzen soll.";
	POPBAR_CONFIG_COLS_NAME			= "Spalten";
	POPBAR_CONFIG_COLS_SUFFIX		= "";
	POPBAR_CONFIG_ROWSHOW			= "Immer angezeigte Zeilen";
	POPBAR_CONFIG_ROWSHOW_INFO		= "Die Anzahl der Zeilen, welche immer sichtbar sein sollen.";
	POPBAR_CONFIG_ROWSHOW_NAME		= "Zeilen";
	POPBAR_CONFIG_ROWSHOW_SUFFIX		= "";
	POPBAR_CONFIG_COLSHOW			= "Immer angezeigte Spalten";
	POPBAR_CONFIG_COLSHOW_INFO		= "Die Anzahl der Spalten, welche immer sichtbar sein sollen.";
	POPBAR_CONFIG_COLSHOW_NAME		= "Spalten";
	POPBAR_CONFIG_COLSHOW_SUFFIX		= "";
	POPBAR_CONFIG_RESET			= "Position zur\195\188cksetzen";
	POPBAR_CONFIG_RESET_INFO		= "Versetzt die Pop Bar an ihre urspr\195\188ngliche Position zur\195\188ck.";
	POPBAR_CONFIG_RESET_NAME		= "Zur\195\188cksetzen";
	POPBAR_CONFIG_IDUP			= "Button IDs aufw\195\164rts z\195\164hlen";
	POPBAR_CONFIG_IDUP_INFO			= "Wenn aktiviert, werden die Button IDs aufw\195\164rts gez\195\164hlt und nicht wie normal abw\195\164rts.";
	POPBAR_CONFIG_FLIPH			= "Horizontale Axe umkehren";
	POPBAR_CONFIG_FLIPH_INFO		= "Wenn aktiviert, wird die Anordnung der IDs horizontal umgekehrt.";
	POPBAR_CONFIG_FLIPV			= "Vertikale Axe umkehren";
	POPBAR_CONFIG_FLIPV_INFO		= "Wenn aktiviert, wird die Anordnung der IDs vertikal umgekehrt.";
	POPBAR_CONFIG_STARTPAGE			= "Startleiste der Button IDs";
	POPBAR_CONFIG_STARTPAGE_INFO		= "Die Leiste auf der sich die erste Button ID befindet.";
	POPBAR_CONFIG_STARTPAGE_NAME		= "Leisten Nummer";
	POPBAR_CONFIG_STARTPAGE_SUFFIX		= "";
	POPBAR_CONFIG_STARTBUTTON		= "Startbutton der Button IDs";
	POPBAR_CONFIG_STARTBUTTON_INFO		= "Der Button auf der Startleiste, bei dem es sich um die erste Button ID handelt.";
	POPBAR_CONFIG_STARTBUTTON_NAME		= "Button Nummer";
	POPBAR_CONFIG_STARTBUTTON_SUFFIX	= "";
	
	-- Chat Configuration
	POPBAR_CHAT_COMMAND_INFO		= "Gib /pb oder /popbar ein um Hilfe zur Benutzung zu bekommen.";
	POPBAR_CHAT_COMMAND_HELP		= {};
	POPBAR_CHAT_COMMAND_HELP[1]		= "Alle Slash-Befehle starten entweder mit /pb oder /popbar\nBeispiel: /pb enable oder /popbar enable";
	POPBAR_CHAT_COMMAND_HELP[2]		= "Danach kann on oder off angegeben werden oder eine Nummer.\nBeispiel:";
	POPBAR_CHAT_COMMAND_HELP[3]		= "/pb enable on";
	POPBAR_CHAT_COMMAND_HELP[4]		= "/pb enable off";
	POPBAR_CHAT_COMMAND_HELP[5]		= "/pb rows 2";
	POPBAR_CHAT_COMMAND_HELP[6]		= "Wenn nicht on oder off angegeben wird, wird der Zustand der PopBar umgekehrt. Das bedeutet, da\195\159 wenn die Pop Bar aktiviert war wird sie deaktiviert und umgekehrt.";
	POPBAR_CHAT_COMMAND_HELP[7]		= "enable - 'Pop Bar aktivieren/deaktivieren, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[8]		= "pages - 'Wenn aktiviert, wechselt die Popbar die dargestellte Leiste wenn die Aktionsleiste gewechselt wird, on oder off angeben";
	POPBAR_CHAT_COMMAND_HELP[9]		= "hideempty - 'Wenn aktiviert, werden leere Buttons automatisch ausgeblendet, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[10]		= "hidekeys - 'Wenn aktiviert, werden auf den Buttons die Tastenbelegungen nicht angezeigt, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[11]		= "hidekeymod - 'Wenn aktiviert, werden die Zusatztasten der Tastenbelegung nicht angezeigt. So wird zum Beispiel anstatt 'ALT-1' nur '1' angezeigt, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[12]		= "rows - 'Anzahl der Pop Bar Zeilen'";
	POPBAR_CHAT_COMMAND_HELP[13]		= "cols - 'Anzahl der Pop Bar Spalten'";
	POPBAR_CHAT_COMMAND_HELP[14]		= "area - 'Zeigt die PopBar an, wenn der Mauszeiger \195\188ber den Bereich bewegt wird in dem die Pop Bar angezeigt werden w\195\188rde, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[15]		= "vanchor - 'Legt die vertikale Expandierung fest, bottom oder top angeben'";
	POPBAR_CHAT_COMMAND_HELP[16]		= "hanchor - 'Legt die horizontale Expandierung fest, left oder right angeben'";
	POPBAR_CHAT_COMMAND_HELP[17]		= "srows - 'Legt die Anzahl der Zeilen fest, welche immer sichtbar sein sollen'";
	POPBAR_CHAT_COMMAND_HELP[18]		= "scols - 'Legt die Anzahl der Spalten fest, welche immer sichtbar sein sollen'";
	POPBAR_CHAT_COMMAND_HELP[19]		= "orient - 'Legt die Orientierung der Deiten der PopBar fest, h f\195\188r horizontaloder v f\195\188r vertikal (Standard) angeben'";
	POPBAR_CHAT_COMMAND_HELP[20]		= "knobalpha - 'Legt die Transparenz des Anchor-Buttons (zum verschieben der Pop Bar) fest, Zahl zwischen 0.00 und 1.00 angeben'";
	POPBAR_CHAT_COMMAND_HELP[21]		= "alpha - 'Legt die Transparenz der PopBar fest, Zahl zwischen 0.00 und 1.00 angeben'";
	POPBAR_CHAT_COMMAND_HELP[22]		= "idup - 'Wenn aktiviert, werden die Button IDs aufw\195\164rts gez\195\164hlt und nicht wie normal abw\195\164rts, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[23]		= "fliph - 'Wenn aktiviert, wird die Anordnung der IDs horizontal umgekehrt, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[24]		= "flipv - 'Wenn aktiviert, wird die Anordnung der IDs vertikal umgekehrt, on oder off angeben'";
	POPBAR_CHAT_COMMAND_HELP[25]		= "startpage - 'Die Leiste auf der sich die erste Button ID befindet'";
	POPBAR_CHAT_COMMAND_HELP[26]		= "startbut - 'Der Button auf der Startleiste, bei dem es sich um die erste Button ID handelt'";
	POPBAR_CHAT_COMMAND_HELP[27]		= "reset - 'Versetzt die Pop Bar an ihre urspr\195\188ngliche Position zur\195\188ck'";

	-- Setup key binding localizations
	for row = 1, 12 do
		for col = 1, 12 do
			if ((row > 11) and (col > 7)) then break; end
			if ((row > 10) and (col > 8)) then break; end
			if ((row > 9) and (col > 9)) then break; end
			if ((row > 8) and (col > 10)) then break; end
			local butName = "BINDING_NAME_POPBARBUTTON"..row..col;
			if (col < 10) then
				butName = "BINDING_NAME_POPBARBUTTON"..row.."0"..col;
			end
			setglobal(butName, POPBAR_BINDING_BUTTON.."("..row.."/"..col..")");
		end	
	end
end