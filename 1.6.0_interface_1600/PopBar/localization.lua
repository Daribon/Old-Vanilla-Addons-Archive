-- Version : English (by Mugendai)
-- Last Update : 02/17/2005

-- Binding Configuration
BINDING_HEADER_POPBARHEADER		= "PopBar Buttons (Row/Col)";
BINDING_NAME_TOGGLEPOPBAR		= "Toggle PopBar";

-- UltimateUI Configuration
POPBAR_BINDING_BUTTON 			= "PopBar Button ";
POPBAR_CONFIG_HEADER			= "PopBar"
POPBAR_CONFIG_HEADER_INFO		= "These options configure the PopBar.";
POPBAR_CONFIG_ONOFF			= "Enable/disable the PopBar";
POPBAR_CONFIG_ONOFF_INFO		= "If checked, the PopBar will display when appropriate.";
POPBAR_CONFIG_PAGES			= "Turn Pages"
POPBAR_CONFIG_PAGES_INFO		= "If checked, PopBar will change pages when the main bar does."
POPBAR_CONFIG_HIDEEMPTY			= "Hide empty buttons";
POPBAR_CONFIG_HIDEEMPTY_INFO		= "If checked, any buttons that dont have an action in them will be hidden.";
POPBAR_CONFIG_HIDEKEYS			= "Hide key bindings";
POPBAR_CONFIG_HIDEKEYS_INFO		= "If enabled, the buttons will not show the key bindings.";
POPBAR_CONFIG_HIDEKEYMOD		= "Hide key modifiers";
POPBAR_CONFIG_HIDEKEYMOD_INFO		= "Will hide the modifier keys, ex. 'ALT-1' would only show '1'";
POPBAR_CONFIG_ORIENT			= "Orient Pages Horizontally";
POPBAR_CONFIG_ORIENT_INFO		= "You should check this if you plan to use the bar like a sidebar.";
POPBAR_CONFIG_AREA			= "Open when in area";
POPBAR_CONFIG_AREA_INFO			= "Popbar will show when the mouse is in the area where the buttons should be.";
POPBAR_CONFIG_HANCHOR			= "Anchor Right";
POPBAR_CONFIG_HANCHOR_INFO		= "If checked the popbar will expand from the right instead of left.";
POPBAR_CONFIG_VANCHOR			= "Anchor Top";
POPBAR_CONFIG_VANCHOR_INFO		= "If checked the popbar will expand from the top instead of bottom.";
POPBAR_CONFIG_POPTIME			= "Popup Timeout";
POPBAR_CONFIG_POPTIME_INFO		= "Amount of time the mouse must hover over PopBar before it pops up.";
POPBAR_CONFIG_POPTIME_NAME		= "Hover Time to Popup";
POPBAR_CONFIG_POPTIME_SUFFIX		= " second(s)";
POPBAR_CONFIG_KNOBALPHA			= "Knob Opacity";
POPBAR_CONFIG_KNOBALPHA_INFO		= "Changes the opacity/transparence of the knob.";
POPBAR_CONFIG_KNOBALPHA_NAME		= "Opacity";
POPBAR_CONFIG_KNOBALPHA_SUFFIX		= "%";
POPBAR_CONFIG_BARALPHA			= "Bar Opacity";
POPBAR_CONFIG_BARALPHA_INFO		= "Changes the opacity/transparency of the bar.";
POPBAR_CONFIG_BARALPHA_NAME		= "Opacity";
POPBAR_CONFIG_BARALPHA_SUFFIX		= "%";
POPBAR_CONFIG_ROWS			= "Number of Rows";
POPBAR_CONFIG_ROWS_INFO			= "The number of rows to use in PopBar";
POPBAR_CONFIG_ROWS_NAME			= "Rows";
POPBAR_CONFIG_ROWS_SUFFIX		= " row(s)";
POPBAR_CONFIG_COLS			= "Number of Columns";
POPBAR_CONFIG_COLS_INFO			= "The number of columns to use in PopBar";
POPBAR_CONFIG_COLS_NAME			= "Columns";
POPBAR_CONFIG_COLS_SUFFIX		= " column(s)";
POPBAR_CONFIG_ROWSHOW			= "Always Show Rows";
POPBAR_CONFIG_ROWSHOW_INFO		= "The number of rows that should always be visible.";
POPBAR_CONFIG_ROWSHOW_NAME		= "Rows";
POPBAR_CONFIG_ROWSHOW_SUFFIX		= " row(s)";
POPBAR_CONFIG_COLSHOW			= "Always Show Columns";
POPBAR_CONFIG_COLSHOW_INFO		= "The number of columns that should always be visible.";
POPBAR_CONFIG_COLSHOW_NAME		= "Columns";
POPBAR_CONFIG_COLSHOW_SUFFIX		= " column(s)";
POPBAR_CONFIG_RESET			= "Default PopBar position";
POPBAR_CONFIG_RESET_INFO		= "Resets the PopBar to it's origional position.";
POPBAR_CONFIG_RESET_NAME		= "Reset";
POPBAR_CONFIG_IDUP			= "Button IDs Count Up";
POPBAR_CONFIG_IDUP_INFO			= "If enabled the button IDs in popbar will count up instead of the normal counting down.";
POPBAR_CONFIG_FLIPH			= "Flip Horizontal Axis";
POPBAR_CONFIG_FLIPH_INFO		= "Reverses the ID order horizontally.";
POPBAR_CONFIG_FLIPV			= "Flip Vertical Axis";
POPBAR_CONFIG_FLIPV_INFO		= "Reverses the ID order vertically.";
POPBAR_CONFIG_STARTPAGE			= "Button ID Start Page";
POPBAR_CONFIG_STARTPAGE_INFO		= "Which page the first button ID starts on.";
POPBAR_CONFIG_STARTPAGE_NAME		= "Page Number";
POPBAR_CONFIG_STARTPAGE_SUFFIX		= "";
POPBAR_CONFIG_STARTBUTTON		= "Button ID Start Button";
POPBAR_CONFIG_STARTBUTTON_INFO		= "Which button of the selected page the first button ID starts on.";
POPBAR_CONFIG_STARTBUTTON_NAME		= "Button Number";
POPBAR_CONFIG_STARTBUTTON_SUFFIX	= "";

-- Chat Configuration
POPBAR_CHAT_COMMAND_INFO		= "Type /pb or /popbar for usage instructions.";
POPBAR_CHAT_COMMAND_HELP		= {};
POPBAR_CHAT_COMMAND_HELP[1]		= "All slash command can start with either /pb or /popbar example: /pb enable or /popbar enable";
POPBAR_CHAT_COMMAND_HELP[2]		= "Then you can pass on or off to them, or pass a number for ones that need a number ex.";
POPBAR_CHAT_COMMAND_HELP[3]		= "/pb enable on";
POPBAR_CHAT_COMMAND_HELP[4]		= "/pb enable off";
POPBAR_CHAT_COMMAND_HELP[5]		= "/pb rows 2";
POPBAR_CHAT_COMMAND_HELP[6]		= "If it's already on and you don't pass on or off it will flip to the opposite, if on, it turs off, if off it turns on.\n";
POPBAR_CHAT_COMMAND_HELP[7]		= "enable - 'Enable/disable PopBar, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[8]		= "pages - 'Set whether or not PopBar changed buttons when the main bar does, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[9]		= "hideempty - 'If enabled buttons with no action will be hidden, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[10]		= "hidekeys - 'If enabled the buttons will not show the key bindings, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[11]		= "hidekeymod - 'Will hide the modifier keys, ex. 'ALT-1' would only show '1', pass on or off'";
POPBAR_CHAT_COMMAND_HELP[12]		= "rows - 'Set number of PopBar rows'";
POPBAR_CHAT_COMMAND_HELP[13]		= "cols - 'Set number of PopBar columns'";
POPBAR_CHAT_COMMAND_HELP[14]		= "area - 'Set whether popbar should open when the mouse is in the area PopBar would show in, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[15]		= "vanchor - 'Set the vertical anchor, bottom or top'";
POPBAR_CHAT_COMMAND_HELP[16]		= "hanchor - 'Set the horizontal anchor, left or right'";
POPBAR_CHAT_COMMAND_HELP[17]		= "srows - 'Set the number of rows to always show'";
POPBAR_CHAT_COMMAND_HELP[18]		= "scols - 'Set the number of columns to always show'";
POPBAR_CHAT_COMMAND_HELP[19]		= "orient - 'Set the orientation of the pages in PopBar, pass h for horizontal, v for vertical(default)'";
POPBAR_CHAT_COMMAND_HELP[20]		= "knobalpha - 'Sets the alpha transparency of the knob, pass something from 0.00 to 1.00'";
POPBAR_CHAT_COMMAND_HELP[21]		= "alpha - 'Sets the alpha transparency of the bar, pass something from 0.00 to 1.00'";
POPBAR_CHAT_COMMAND_HELP[22]		= "idup - 'If enabled button IDs count up from the first, instead of down, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[23]		= "fliph - 'Flips the button ID's on the horizontal axis, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[24]		= "flipv - 'Flips the button ID's on the vertical axis, pass on or off'";
POPBAR_CHAT_COMMAND_HELP[25]		= "startpage - 'The page the first button ID starts on.'";
POPBAR_CHAT_COMMAND_HELP[26]		= "startbut - 'The button in the page that the first button ID starts on.'";
POPBAR_CHAT_COMMAND_HELP[27]		= "reset - 'Resets PopBar back to its default location.'";

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