-- Version : English - Mugendai

BINDING_HEADER_POPBARHEADER			= "PopBar Buttons (Row/Col)";
BINDING_NAME_TOGGLEPOPBAR			= "Toggle PopBar";
POPBAR_BINDING_BUTTON 				= "PopBar Button ";
POPBAR_CONFIG_HEADER				= "PopBar"
POPBAR_CONFIG_HEADER_INFO			= "These options configure the PopBar.";
POPBAR_CONFIG_ONOFF					= "Enable/disable the PopBar";
POPBAR_CONFIG_ONOFF_INFO			= "If checked the PopBar will display when appropriate.";
POPBAR_CONFIG_PAGES					= "Turn Pages"
POPBAR_CONFIG_PAGES_INFO			= "If checked then PopBar will change pages when the main bar does."
POPBAR_CONFIG_HIDEEMPTY				= "Hide empty buttons";
POPBAR_CONFIG_HIDEEMPTY_INFO		= "If this is checked then any buttons that dont have an action in them will be hidden.";
POPBAR_CONFIG_HIDEKEYS				= "Hide key bindings";
POPBAR_CONFIG_HIDEKEYS_INFO			= "If enabled the buttons will not show the key bindings.";
POPBAR_CONFIG_HIDEKEYMOD			= "Hide key modifiers";
POPBAR_CONFIG_HIDEKEYMOD_INFO		= "Will hide the modifier keys, ex. 'ALT-1' would only show '1'";
POPBAR_CONFIG_ORIENT				= "Orient Pages Horizontally";
POPBAR_CONFIG_ORIENT_INFO			= "You should check this if you plan to use the bar like a sidebar.";
POPBAR_CONFIG_AREA					= "Open when in area";
POPBAR_CONFIG_AREA_INFO				= "Popbar will show when the mouse is in the area where the buttons should be.";
POPBAR_CONFIG_HANCHOR				= "Anchor Right";
POPBAR_CONFIG_HANCHOR_INFO			= "If checked the popbar will expand from the right instead of left.";
POPBAR_CONFIG_VANCHOR				= "Anchor Top";
POPBAR_CONFIG_VANCHOR_INFO			= "If checked the popbar will expand from the top instead of bottom.";
POPBAR_CONFIG_KNOBALPHA				= "Knob Opacity";
POPBAR_CONFIG_KNOBALPHA_INFO		= "Changes the opacity/transparence of the knob.";
POPBAR_CONFIG_KNOBALPHA_NAME		= "Opacity";
POPBAR_CONFIG_KNOBALPHA_SUFFIX		= "%";
POPBAR_CONFIG_BARALPHA				= "Bar Opacity";
POPBAR_CONFIG_BARALPHA_INFO			= "Changes the opacity/transparence of the bar.";
POPBAR_CONFIG_BARALPHA_NAME			= "Opacity";
POPBAR_CONFIG_BARALPHA_SUFFIX		= "%";
POPBAR_CONFIG_ROWS					= "Number of Rows";
POPBAR_CONFIG_ROWS_INFO				= "The number of rows to use in PopBar";
POPBAR_CONFIG_ROWS_NAME				= "Rows";
POPBAR_CONFIG_ROWS_SUFFIX			= " row(s)";
POPBAR_CONFIG_COLS					= "Number of Columns";
POPBAR_CONFIG_COLS_INFO				= "The number of columns to use in PopBar";
POPBAR_CONFIG_COLS_NAME				= "Columns";
POPBAR_CONFIG_COLS_SUFFIX			= " column(s)";
POPBAR_CONFIG_ROWSHOW				= "Always Show Rows";
POPBAR_CONFIG_ROWSHOW_INFO			= "The number of rows that should always be visible.";
POPBAR_CONFIG_ROWSHOW_NAME			= "Rows";
POPBAR_CONFIG_ROWSHOW_SUFFIX		= " row(s)";
POPBAR_CONFIG_COLSHOW				= "Always Show Columns";
POPBAR_CONFIG_COLSHOW_INFO			= "The number of columns that should always be visible.";
POPBAR_CONFIG_COLSHOW_NAME			= "Columns";
POPBAR_CONFIG_COLSHOW_SUFFIX		= " column(s)";
POPBAR_CONFIG_RESET					= "Default PopBar position";
POPBAR_CONFIG_RESET_INFO			= "Resets the PopBar to it's origional position.";
POPBAR_CONFIG_RESET_NAME			= "Reset";
POPBAR_CONFIG_IDUP					= "Button IDs Count Up";
POPBAR_CONFIG_IDUP_INFO				= "If enabled the button IDs in popbar will count up instead of the normal counting down.";
POPBAR_CONFIG_FLIPH					= "Flip Horizontal Axis";
POPBAR_CONFIG_FLIPH_INFO			= "Reverses the ID order horizontally.";
POPBAR_CONFIG_FLIPV					= "Flip Vertical Axis";
POPBAR_CONFIG_FLIPV_INFO			= "Reverses the ID order vertically.";
POPBAR_CONFIG_STARTPAGE				= "Button ID Start Page";
POPBAR_CONFIG_STARTPAGE_INFO		= "Which page the first button ID starts on.";
POPBAR_CONFIG_STARTPAGE_NAME		= "Page Number";
POPBAR_CONFIG_STARTPAGE_SUFFIX		= "";
POPBAR_CONFIG_STARTBUTTON			= "Button ID Start Button";
POPBAR_CONFIG_STARTBUTTON_INFO		= "Which button of the selected page the first button ID starts on.";
POPBAR_CONFIG_STARTBUTTON_NAME		= "Button Number";
POPBAR_CONFIG_STARTBUTTON_SUFFIX	= "";

POPBAR_CHAT_COMMAND_INFO			= "Type /pb or /popbar for usage instructions.";
POPBAR_CHAT_COMMAND_HELP = {};
table.insert(POPBAR_CHAT_COMMAND_HELP, "All slash command can start with either /pb or /popbar example: /pb enable or /popbar enable");
table.insert(POPBAR_CHAT_COMMAND_HELP, "Then you can pass on or off to them, or pass a number for ones that need a number ex.");
table.insert(POPBAR_CHAT_COMMAND_HELP, "/pb enable on");
table.insert(POPBAR_CHAT_COMMAND_HELP, "/pb enable off");
table.insert(POPBAR_CHAT_COMMAND_HELP, "/pb rows 2");
table.insert(POPBAR_CHAT_COMMAND_HELP, "If it's already on and you don't pass on or off it will flip to the opposite, if on, it turs off, if off it turns on.\n");
table.insert(POPBAR_CHAT_COMMAND_HELP, "enable - 'Enable/disable PopBar, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "pages - 'Set whether or not PopBar changed buttons when the main bar does, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "hideempty - 'If enabled buttons with no action will be hidden, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "hidekeys - 'If enabled the buttons will not show the key bindings, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "hidekeymod - 'Will hide the modifier keys, ex. 'ALT-1' would only show '1', pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "rows - 'Set number of PopBar rows'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "cols - 'Set number of PopBar columns'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "area - 'Set whether popbar should open when the mouse is in the area PopBar would show in, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "vanchor - 'Set the vertical anchor, bottom or top'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "hanchor - 'Set the horizontal anchor, left or right'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "srows - 'Set the number of rows to always show'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "scols - 'Set the number of columns to always show'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "orient - 'Set the orientation of the pages in PopBar, pass h for horizontal, v for vertical(default)'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "knobalpha - 'Sets the alpha transparency of the knob, pass something from 0.00 to 1.00'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "alpha - 'Sets the alpha transparency of the bar, pass something from 0.00 to 1.00'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "idup - 'If enabled button IDs count up from the first, instead of down, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "fliph - 'Flips the button ID's on the horizontal axis, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "flipv - 'Flips the button ID's on the vertical axis, pass on or off'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "startpage - 'The page the first button ID starts on.'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "startbut - 'The button in the page that the first button ID starts on.'");
table.insert(POPBAR_CHAT_COMMAND_HELP, "reset - 'Resets PopBar back to its default location.'");

if ( GetLocale() == "frFR" ) then
	
	--This whole section needs translation
	BINDING_HEADER_POPBARHEADER			= "PopBar Buttons (Row/Col)";
	BINDING_NAME_TOGGLEPOPBAR			= "Toggle PopBar";
	POPBAR_BINDING_BUTTON 				= "PopBar Button ";
	POPBAR_CONFIG_HEADER				= "PopBar"
	POPBAR_CONFIG_HEADER_INFO			= "These options configure the PopBar.";
	POPBAR_CONFIG_ONOFF					= "Enable/disable the PopBar";
	POPBAR_CONFIG_ONOFF_INFO			= "If checked the PopBar will display when appropriate.";
	POPBAR_CONFIG_PAGES					= "Turn Pages"
	POPBAR_CONFIG_PAGES_INFO			= "If checked then PopBar will change pages when the main bar does."
	POPBAR_CONFIG_HIDEEMPTY				= "Hide empty buttons";
	POPBAR_CONFIG_HIDEEMPTY_INFO		= "If this is checked then any buttons that dont have an action in them will be hidden.";
	POPBAR_CONFIG_HIDEKEYS				= "Hide key bindings";
	POPBAR_CONFIG_HIDEKEYS_INFO			= "If enabled the buttons will not show the key bindings.";
	POPBAR_CONFIG_ORIENT				= "Orient Pages Horizontally";
	POPBAR_CONFIG_ORIENT_INFO			= "You should check this if you plan to use the bar like a sidebar.";
	POPBAR_CONFIG_AREA					= "Open when in area";
	POPBAR_CONFIG_AREA_INFO				= "Popbar will show when the mouse is in the area where the buttons should be.";
	POPBAR_CONFIG_HANCHOR				= "Anchor Right";
	POPBAR_CONFIG_HANCHOR_INFO			= "If checked the popbar will expand from the right instead of left.";
	POPBAR_CONFIG_VANCHOR				= "Anchor Top";
	POPBAR_CONFIG_VANCHOR_INFO			= "If checked the popbar will expand from the top instead of bottom.";
	POPBAR_CONFIG_KNOBALPHA				= "Knob Opacity";
	POPBAR_CONFIG_KNOBALPHA_INFO		= "Changes the opacity/transparence of the knob.";
	POPBAR_CONFIG_KNOBALPHA_NAME		= "Opacity";
	POPBAR_CONFIG_KNOBALPHA_SUFFIX		= "%";
	POPBAR_CONFIG_ROWS					= "Number of Rows";
	POPBAR_CONFIG_ROWS_INFO				= "The number of rows to use in PopBar";
	POPBAR_CONFIG_ROWS_NAME				= "Rows";
	POPBAR_CONFIG_ROWS_SUFFIX			= " row(s)";
	POPBAR_CONFIG_COLS					= "Number of Columns";
	POPBAR_CONFIG_COLS_INFO				= "The number of columns to use in PopBar";
	POPBAR_CONFIG_COLS_NAME				= "Columns";
	POPBAR_CONFIG_COLS_SUFFIX			= " column(s)";
	POPBAR_CONFIG_ROWSHOW				= "Always Show Rows";
	POPBAR_CONFIG_ROWSHOW_INFO			= "The number of rows that should always be visible.";
	POPBAR_CONFIG_ROWSHOW_NAME			= "Rows";
	POPBAR_CONFIG_ROWSHOW_SUFFIX		= " row(s)";
	POPBAR_CONFIG_COLSHOW				= "Always Show Columns";
	POPBAR_CONFIG_COLSHOW_INFO			= "The number of columns that should always be visible.";
	POPBAR_CONFIG_COLSHOW_NAME			= "Columns";
	POPBAR_CONFIG_COLSHOW_SUFFIX		= " column(s)";
	POPBAR_CONFIG_RESET					= "Default PopBar position";
	POPBAR_CONFIG_RESET_INFO			= "Resets the PopBar to it's origional position.";
	POPBAR_CONFIG_RESET_NAME			= "Reset";
	POPBAR_CONFIG_IDUP					= "Button IDs Count Up";
	POPBAR_CONFIG_IDUP_INFO				= "If enabled the button IDs in popbar will count up instead of the normal counting down.";
	POPBAR_CONFIG_STARTPAGE				= "Button ID Start Page";
	POPBAR_CONFIG_STARTPAGE_INFO		= "Which page the first button ID starts on.";
	POPBAR_CONFIG_STARTPAGE_NAME		= "Page Number";
	POPBAR_CONFIG_STARTPAGE_SUFFIX		= "";
	POPBAR_CONFIG_STARTBUTTON			= "Button ID Start Button";
	POPBAR_CONFIG_STARTBUTTON_INFO		= "Which button of the selected page the first button ID starts on.";
	POPBAR_CONFIG_STARTBUTTON_NAME		= "Button Number";
	POPBAR_CONFIG_STARTBUTTON_SUFFIX	= "";
	
	POPBAR_CHAT_COMMAND_INFO			= "Type /pb or /popbar for usage instructions.";

elseif ( GetLocale() == "koKR" ) then

	--This whole section needs translation
	BINDING_HEADER_POPBARHEADER			= "PopBar Buttons (Row/Col)";
	BINDING_NAME_TOGGLEPOPBAR			= "Toggle PopBar";
	POPBAR_BINDING_BUTTON 				= "PopBar Button ";
	POPBAR_CONFIG_HEADER				= "PopBar"
	POPBAR_CONFIG_HEADER_INFO			= "These options configure the PopBar.";
	POPBAR_CONFIG_ONOFF					= "Enable/disable the PopBar";
	POPBAR_CONFIG_ONOFF_INFO			= "If checked the PopBar will display when appropriate.";
	POPBAR_CONFIG_PAGES					= "Turn Pages"
	POPBAR_CONFIG_PAGES_INFO			= "If checked then PopBar will change pages when the main bar does."
	POPBAR_CONFIG_HIDEEMPTY				= "Hide empty buttons";
	POPBAR_CONFIG_HIDEEMPTY_INFO		= "If this is checked then any buttons that dont have an action in them will be hidden.";
	POPBAR_CONFIG_HIDEKEYS				= "Hide key bindings";
	POPBAR_CONFIG_HIDEKEYS_INFO			= "If enabled the buttons will not show the key bindings.";
	POPBAR_CONFIG_ORIENT				= "Orient Pages Horizontally";
	POPBAR_CONFIG_ORIENT_INFO			= "You should check this if you plan to use the bar like a sidebar.";
	POPBAR_CONFIG_AREA					= "Open when in area";
	POPBAR_CONFIG_AREA_INFO				= "Popbar will show when the mouse is in the area where the buttons should be.";
	POPBAR_CONFIG_HANCHOR				= "Anchor Right";
	POPBAR_CONFIG_HANCHOR_INFO			= "If checked the popbar will expand from the right instead of left.";
	POPBAR_CONFIG_VANCHOR				= "Anchor Top";
	POPBAR_CONFIG_VANCHOR_INFO			= "If checked the popbar will expand from the top instead of bottom.";
	POPBAR_CONFIG_KNOBALPHA				= "Knob Opacity";
	POPBAR_CONFIG_KNOBALPHA_INFO		= "Changes the opacity/transparence of the knob.";
	POPBAR_CONFIG_KNOBALPHA_NAME		= "Opacity";
	POPBAR_CONFIG_KNOBALPHA_SUFFIX		= "%";
	POPBAR_CONFIG_ROWS					= "Number of Rows";
	POPBAR_CONFIG_ROWS_INFO				= "The number of rows to use in PopBar";
	POPBAR_CONFIG_ROWS_NAME				= "Rows";
	POPBAR_CONFIG_ROWS_SUFFIX			= " row(s)";
	POPBAR_CONFIG_COLS					= "Number of Columns";
	POPBAR_CONFIG_COLS_INFO				= "The number of columns to use in PopBar";
	POPBAR_CONFIG_COLS_NAME				= "Columns";
	POPBAR_CONFIG_COLS_SUFFIX			= " column(s)";
	POPBAR_CONFIG_ROWSHOW				= "Always Show Rows";
	POPBAR_CONFIG_ROWSHOW_INFO			= "The number of rows that should always be visible.";
	POPBAR_CONFIG_ROWSHOW_NAME			= "Rows";
	POPBAR_CONFIG_ROWSHOW_SUFFIX		= " row(s)";
	POPBAR_CONFIG_COLSHOW				= "Always Show Columns";
	POPBAR_CONFIG_COLSHOW_INFO			= "The number of columns that should always be visible.";
	POPBAR_CONFIG_COLSHOW_NAME			= "Columns";
	POPBAR_CONFIG_COLSHOW_SUFFIX		= " column(s)";
	POPBAR_CONFIG_RESET					= "Default PopBar position";
	POPBAR_CONFIG_RESET_INFO			= "Resets the PopBar to it's origional position.";
	POPBAR_CONFIG_RESET_NAME			= "Reset";
	POPBAR_CONFIG_IDUP					= "Button IDs Count Up";
	POPBAR_CONFIG_IDUP_INFO				= "If enabled the button IDs in popbar will count up instead of the normal counting down.";
	POPBAR_CONFIG_STARTPAGE				= "Button ID Start Page";
	POPBAR_CONFIG_STARTPAGE_INFO		= "Which page the first button ID starts on.";
	POPBAR_CONFIG_STARTPAGE_NAME		= "Page Number";
	POPBAR_CONFIG_STARTPAGE_SUFFIX		= "";
	POPBAR_CONFIG_STARTBUTTON			= "Button ID Start Button";
	POPBAR_CONFIG_STARTBUTTON_INFO		= "Which button of the selected page the first button ID starts on.";
	POPBAR_CONFIG_STARTBUTTON_NAME		= "Button Number";
	POPBAR_CONFIG_STARTBUTTON_SUFFIX	= "";
	
	POPBAR_CHAT_COMMAND_INFO			= "Type /pb or /popbar for usage instructions.";

elseif ( GetLocale() == "deDE" ) then

	-- Translation by pc

	BINDING_HEADER_POPBARHEADER			= "PopBar Buttons (Zeile/Spalte)";
	BINDING_NAME_TOGGLEPOPBAR			= "PopBar Ein-/Ausschalten";
	POPBAR_BINDING_BUTTON				= "PopBar Button";
	POPBAR_CONFIG_HEADER				= "PopBar"
	POPBAR_CONFIG_HEADER_INFO			= "Diese Einstellungen diesen der Konfiguration vonPopBar.";
	POPBAR_CONFIG_ONOFF					= "Aktivieren der Popbar";
	POPBAR_CONFIG_ONOFF_INFO			= "Wenn aktiviert, wird die PopBar dargestellt.";
	POPBAR_CONFIG_PAGES					= "Leistenwechsel"
	POPBAR_CONFIG_PAGES_INFO			= "Wenn aktiviert, wechselt die Popbar die dargestellte Leiste wenn die Hauptaktionsleiste gewechselt wird."
	POPBAR_CONFIG_HIDEEMPTY				= "Verstecke leere Buttons";
	POPBAR_CONFIG_HIDEEMPTY_INFO		= "Wenn aktiviert, werden Buttons denen keine Aktion zugeweisen ist ausgeblendet.";
	POPBAR_CONFIG_HIDEKEYS				= "Verstecke Tastenbelegung";
	POPBAR_CONFIG_HIDEKEYS_INFO			= "Wenn aktiviert, werden auf den Buttons die Tastenbelegungen nicht angezeigt.";
	POPBAR_CONFIG_HIDEKEYMOD			= "Hide key modifiers"; --NEEDS TRANSLATION
	POPBAR_CONFIG_HIDEKEYMOD_INFO		= "Will hide the modifier keys, ex. 'ALT-1' would only show '1'"; --NEEDS TRANSLATION
	POPBAR_CONFIG_ORIENT				= "Leiste Horizontal orientieren";
	POPBAR_CONFIG_ORIENT_INFO			= "Sollte aktiviert werden wenn man die PopBar also Seitenleiste benutzen will.";
	POPBAR_CONFIG_AREA					= "Öffne wenn Zeiger im Berich";
	POPBAR_CONFIG_AREA_INFO				= "PopBar öffnet sich wenn die Maus über den Bereich bewegt wird in dem die PopBar angezeigt werden würde.";
	POPBAR_CONFIG_HANCHOR				= "Expandiere nach links";
	POPBAR_CONFIG_HANCHOR_INFO			= "Wenn aktiviert, expandiert die PopBar nicht nach rechts sondern nach links.";
	POPBAR_CONFIG_VANCHOR				= "Expandiere nach unten";
	POPBAR_CONFIG_VANCHOR_INFO			= "Wenn aktiviert, expandiert die PopBar nicht nach oben sondern nach unten.";
	POPBAR_CONFIG_KNOBALPHA				= "Knopf Sichtbarkeit";
	POPBAR_CONFIG_KNOBALPHA_INFO		= "Verändert die Sichtbarkeit des Knopfes.";
	POPBAR_CONFIG_KNOBALPHA_NAME		= "Sichtbarkeit";
	POPBAR_CONFIG_KNOBALPHA_SUFFIX		= "%";
	POPBAR_CONFIG_BARALPHA				= "Bar Opacity"; --NEEDS TRANSLATION
	POPBAR_CONFIG_BARALPHA_INFO			= "Changes the opacity/transparence of the bar."; --NEEDS TRANSLATION
	POPBAR_CONFIG_BARALPHA_NAME			= "Opacity"; --NEEDS TRANSLATION
	POPBAR_CONFIG_BARALPHA_SUFFIX		= "%"; --NEEDS TRANSLATION
	POPBAR_CONFIG_ROWS					= "Anzahl der Zeilen";
	POPBAR_CONFIG_ROWS_INFO				= "Die Anzahl der Zeilen die die PopBar besitzen soll.";
	POPBAR_CONFIG_ROWS_NAME				= "Zeilen";
	POPBAR_CONFIG_ROWS_SUFFIX			= " Zeile(n)";
	POPBAR_CONFIG_COLS					= "Anzahl der Spalten";
	POPBAR_CONFIG_COLS_INFO				= "Die Anzahl der Spalten die die PopBar besitzen soll.";
	POPBAR_CONFIG_COLS_NAME				= "Spalten";
	POPBAR_CONFIG_COLS_SUFFIX			= " Spalte(n)";
	POPBAR_CONFIG_ROWSHOW				= "Immer angezeigte Zeilen";
	POPBAR_CONFIG_ROWSHOW_INFO			= "Die Anzahl der Zeilen die immer Sichtbar sein sollen.";
	POPBAR_CONFIG_ROWSHOW_NAME			= "Zeilen";
	POPBAR_CONFIG_ROWSHOW_SUFFIX		= " Zeile(n)";
	POPBAR_CONFIG_COLSHOW				= "Immer angezeigte Spalten";
	POPBAR_CONFIG_COLSHOW_INFO			= "Die Anzahl der Spalten die immer Sichtbar sein sollen.";
	POPBAR_CONFIG_COLSHOW_NAME			= "Spalten";
	POPBAR_CONFIG_COLSHOW_SUFFIX		= " Spalte(n)";
	POPBAR_CONFIG_RESET					= "Position der PopBar zurücksetzen";
	POPBAR_CONFIG_RESET_INFO			= "Versetzt die PopBar an ihre originale Position.";
	POPBAR_CONFIG_RESET_NAME			= "Zurücksetzen";
	POPBAR_CONFIG_IDUP					= "Button IDs heraufzählen";
	POPBAR_CONFIG_IDUP_INFO				= "Wenn aktiviert, werden die Button IDs heraufgezählt statt wie normal herunter.";
	POPBAR_CONFIG_FLIPH					= "Flip Horizontal Axis"; --NEEDS TRANSLATION
	POPBAR_CONFIG_FLIPH_INFO			= "Reverses the ID order horizontally."; --NEEDS TRANSLATION
	POPBAR_CONFIG_FLIPV					= "Flip Vertical Axis"; --NEEDS TRANSLATION
	POPBAR_CONFIG_FLIPV_INFO			= "Reverses the ID order vertically."; --NEEDS TRANSLATION
	POPBAR_CONFIG_STARTPAGE				= "Startleiste der Button IDs";
	POPBAR_CONFIG_STARTPAGE_INFO		= "Die Leiste auf der sich die erste Button ID befindet.";
	POPBAR_CONFIG_STARTPAGE_NAME		= "Leisten Nummer";
	POPBAR_CONFIG_STARTPAGE_SUFFIX		= "";
	POPBAR_CONFIG_STARTBUTTON			= "Startbutton der Button IDs";
	POPBAR_CONFIG_STARTBUTTON_INFO		= "Der Button auf der Startleiste bei dem es sich um die erste Button ID handelt.";
	POPBAR_CONFIG_STARTBUTTON_NAME		= "Button Nummer";
	POPBAR_CONFIG_STARTBUTTON_SUFFIX	= "";
	
	POPBAR_CHAT_COMMAND_INFO			= "Type /pb or /popbar for usage instructions.";

end

--Set up key binding localizations
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