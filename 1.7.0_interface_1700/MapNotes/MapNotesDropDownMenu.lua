MapNotesDropDown = {};
MapNotesDropDown.registeredButtons = 0;

function MapNotes_RegisterDropDownButton(name, toggle, submenu)
	MapNotesDropDown.registeredButtons = MapNotesDropDown.registeredButtons+1;
	MapNotesDropDownList:SetHeight(16 * MapNotesDropDown.registeredButtons + 28);
	MapNotesDropDown[MapNotesDropDown.registeredButtons] = {};
	MapNotesDropDown[MapNotesDropDown.registeredButtons].toggle = toggle;
	if (submenu) then
		MapNotesDropDown[MapNotesDropDown.registeredButtons].submenu = submenu;
		getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."ExpandArrow"):Show();
		getglobal(submenu):SetPoint("TOPLEFT", "MapNotesDropDown"..MapNotesDropDown.registeredButtons, "TOPRIGHT", 3, 8);
	else
		getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."ExpandArrow"):Hide();
	end
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."NormalText"):SetText(name);
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."HighlightText"):SetText(name);
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."DisabledText"):SetText(name);
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."NormalText"):SetPoint("LEFT", "MapNotesDropDown"..MapNotesDropDown.registeredButtons, "LEFT", 27, 0);
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."HighlightText"):SetPoint("LEFT", "MapNotesDropDown"..MapNotesDropDown.registeredButtons, "LEFT", 27, 0);
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons.."DisabledText"):SetPoint("LEFT", "MapNotesDropDown"..MapNotesDropDown.registeredButtons, "LEFT", 27, 0);
	getglobal("MapNotesDropDown"..MapNotesDropDown.registeredButtons):Show();
end

function MapNotes_CloseDropDownMenu()
	MapNotesDropDownList:Hide();
	for i=1, MapNotesDropDown.registeredButtons, 1 do
		if (MapNotesDropDown[i].submenu) then
			getglobal(MapNotesDropDown[i].submenu):Hide();
		end
	end
end

function MapNotes_DropDownOnEvent()
	if (MapNotes_Options.shownotes == nil) then MapNotes_Options.shownotes = true; end
	for i=1, MapNotesDropDown.registeredButtons, 1 do
		RunScript("MapNotes_DropDownTempData = "..MapNotesDropDown[i].toggle..";");
		if (MapNotes_DropDownTempData) then
			getglobal("MapNotesDropDown"..i.."Check"):Show();
		else
			getglobal("MapNotesDropDown"..i.."Check"):Hide();
		end
	end
end

function MapNotes_DropDownOnClick(id)
	id = tonumber(id);
	RunScript("MapNotes_DropDownTempData = "..MapNotesDropDown[id].toggle..";");
	if (MapNotes_DropDownTempData) then
		RunScript(MapNotesDropDown[id].toggle.." = false;");
		getglobal("MapNotesDropDown"..id.."Check"):Hide();
	else
		RunScript(MapNotesDropDown[id].toggle.." = true;");
		getglobal("MapNotesDropDown"..id.."Check"):Show();
	end
end

function MapNotes_DropDownToggleSubMenu(id)
	id = tonumber(id);
	if (getglobal(MapNotesDropDown[id].submenu):IsVisible()) then
		getglobal(MapNotesDropDown[id].submenu):Hide();
	else
		getglobal(MapNotesDropDown[id].submenu):Show();
	end
end

function MapNotes_DropDownCloseSubMenuExcept(id)
	id = tonumber(id);
	for i=1, MapNotesDropDown.registeredButtons, 1 do
		if (MapNotesDropDown[i].submenu and i ~= id) then
			getglobal(MapNotesDropDown[i].submenu):Hide();
		end
	end
end

function MapNotes_DropDownExpandArrowOnEnter(id)
	id = tonumber(id);
	for i=1, MapNotesDropDown.registeredButtons, 1 do
		if (i == id) then
			getglobal(MapNotesDropDown[id].submenu):Show();
		elseif (MapNotesDropDown[i].submenu and i ~= id) then
			getglobal(MapNotesDropDown[i].submenu):Hide();
		end
	end
end

function MapNotes_ToggleDropDownMenu()
	if (MapNotesDropDownList:IsVisible()) then
		MapNotes_CloseDropDownMenu();
	else
		CloseDropDownMenus();
		MapNotesDropDownList:Show();
	end
end

if (Sea) then
	Sea.util.hook("CloseDropDownMenus", "MapNotes_CloseDropDownMenu", "after");
	Sea.util.hook("ToggleDropDownMenu", "MapNotes_CloseDropDownMenu", "before");
else
	old_CloseDropDownMenus = CloseDropDownMenus;
	CloseDropDownMenus = function(level) old_CloseDropDownMenus(level); MapNotes_CloseDropDownMenu(); end
	old_ToggleDropDownMenu = ToggleDropDownMenu;
	ToggleDropDownMenu = function(level, value, dropDownFrame, anchorName, xOffset, yOffset) MapNotes_CloseDropDownMenu(); old_ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset); end
end