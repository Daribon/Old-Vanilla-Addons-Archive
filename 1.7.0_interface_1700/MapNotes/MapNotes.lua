--[[ 
               ********** Map Notes **********
Adds the posibility of marking notes in the WorldMapFrame and more...

Author: Sir.Bender [Meog on WoW Forums]
Maintained by: Oystein
Date: 22. May 2005
Version: Map Notes (Cont.) 1.4a

Website: http://curse-gaming.com/mod.php?addid=1285
em@il:opium@geheb.com

Thanks to Jorol from the WoW-Beta forums, for updating the localization.lua
and some other small improvements...

Additional Note: Main idea: CTmod, requested on cosmosui.org
                 Coded from the scratch, only took one idea from CTmod
                 (how to determine when a click is useful) but coded
                 new in a little other way...
		Marsman 3/27/05 - Changed Player to Player notes to use Sky
		Oystein - Added ability to put notes on BG maps and misc fixes
		Sinaloit - Converted from Cosmos_RegisterChatCommand to Sky.registerSlashCommand, updated default slash commands
				fixed thottbot_replace, Sky users can now send notes to non Sky users (cannot receive though).

$Id: MapNotes.lua 2025 2005-07-02 23:51:34Z Sinaloit $
$Rev: 2025 $
$LastChangedBy: Sinaloit $
$Date: 2005-07-02 16:51:34 -0700 (Sat, 02 Jul 2005) $

]]

MapNotes_Mininote_UpdateRate = 0.01;
-- changing this may couse problems, if there are more notes in one zone while decreasing value
-- any number from 1 to 100 (otherwise there aren't enough templates for the POI's, but these can be simply added)
MapNotes_NotesPerZone = 100;
MapNotes_MinDiff = 7;
MAPNOTES_LINETEMPLATESIZE = 256;
MAPNOTES_MAXLINES = 20;

MapNotes_Options = {};
MapNotes_Data = {};
MapNotes_Data[1] = {};
MapNotes_Data[2] = {};
MapNotes_Lines = {};
MapNotes_Lines[1] = {};
MapNotes_Lines[2] = {};
MapNotes_MiniNote_Data = {};

MapNotes_MiniNote_IsInCity = false;
MapNotes_MiniNote_MapzoomInit = false;
MapNotes_SetNextAsMiniNote = 0;
MapNotes_AllowOneNote = 0;
MapNotes_LastReceivedNote_xPos = 0;
MapNotes_LastReceivedNote_yPos = 0;
MapNotes_ZoneNames = {};
MapNotes_LastClick = {};
MapNotes_LastClick.time = 0;
MapNotes_LastLineClick = {};
MapNotes_LastLineClick.time = 0;

MapNotes_TempData_Id = "";
MapNotes_TempData_Creator = "";
MapNotes_TempData_xPos = "";
MapNotes_TempData_yPos = "";
MapNotes_TempData_Icon = "";
MapNotes_TempData_TextColor = "";
MapNotes_TempData_Info1Color = "";
MapNotes_TempData_Info2Color = "";

MapNotes_PartyNoteData = {};
MapNotes_tloc_xPos = nil;
MapNotes_tloc_yPos = nil;

MapNotes_Colors = {};
MapNotes_Colors[0] = {r = 1.0, g = 0.82, b = 0.0};
MapNotes_Colors[1] = {r = 0.55, g = 0.46, b = 0.04};
MapNotes_Colors[2] = {r = 0.87, g = 0.06, b = 0.0};
MapNotes_Colors[3] = {r = 0.56, g = 0.0, b = 0.0};
MapNotes_Colors[4] = {r = 0.18, g = 0.7, b = 0.2};
MapNotes_Colors[5] = {r = 0.0, g = 0.39, b = 0.05};
MapNotes_Colors[6] = {r = 0.42, g = 0.47, b = 0.87};
MapNotes_Colors[7] = {r = 0.25, g = 0.35, b = 0.66};
MapNotes_Colors[8] = {r = 1.0, g = 1.0, b = 1.0};
MapNotes_Colors[9] = {r = 0.65, g = 0.65, b = 0.65};

-- some constant values...

MapNotes_Const[1] = {};
MapNotes_Const[2] = {};
MapNotes_Const[1][0] = { xscale = 11016.6, yscale = 7399.9 };
MapNotes_Const[1][1] = { scale = 0.15670371525706, xoffset = 0.41757282062541, yoffset = 0.33126468682991, xscale = 12897.3, yscale = 8638.1 };
MapNotes_Const[1][2] = { scale = 0.13779501505279, xoffset = 0.55282036918049, yoffset = 0.30400571307545, xscale = 15478.8, yscale = 10368.0 };
MapNotes_Const[1][3] = { scale = 0.17799008894522, xoffset = 0.38383175154516, yoffset = 0.18206216123156, xscale = 19321.8, yscale = 12992.7 };
MapNotes_Const[1][4] = { scale = 0.02876626176374, xoffset = 0.38392150175204, yoffset = 0.10441296545475, xscale = 25650.4, yscale = 17253.2 };
MapNotes_Const[1][5] = { scale = 0.12219839120669, xoffset = 0.34873187115693, yoffset = 0.50331046935371, xscale = 38787.7, yscale = 26032.1 };
MapNotes_Const[1][6] = { scale = 0.14368294970080, xoffset = 0.51709782709100, yoffset = 0.44802818134926 };
MapNotes_Const[1][7] = { scale = 0.14266384095509, xoffset = 0.49026338351379, yoffset = 0.60461876174686 };
MapNotes_Const[1][8] = { scale = 0.15625084006464, xoffset = 0.41995800144849, yoffset = 0.23097545880609 };
MapNotes_Const[1][9] = { scale = 0.18885970960818, xoffset = 0.31589651244686, yoffset = 0.61820581746798 };
MapNotes_Const[1][10] = { scale = 0.06292695969921, xoffset = 0.50130287793373, yoffset = 0.17560823085517 };
MapNotes_Const[1][11] = { scale = 0.13960673216274, xoffset = 0.40811854919226, yoffset = 0.53286226907346 };
MapNotes_Const[1][12] = { scale = 0.03811449638057, xoffset = 0.56378554142668, yoffset = 0.42905218646258 };
MapNotes_Const[1][13] = { scale = 0.18885969712845, xoffset = 0.33763582469211, yoffset = 0.75815224951929 };
MapNotes_Const[1][14] = { scale = 0.13272833611061, xoffset = 0.37556627748617, yoffset = 0.40285135292988 };
MapNotes_Const[1][15] = { scale = 0.18750104661175, xoffset = 0.46971301480866, yoffset = 0.76120931364891 };
MapNotes_Const[1][16] = { scale = 0.13836131003639, xoffset = 0.36011098024729, yoffset = 0.03948322979210 };
MapNotes_Const[1][17] = { scale = 0.27539211944292, xoffset = 0.39249347333450, yoffset = 0.45601063260257 };
MapNotes_Const[1][18] = { scale = 0.11956582877920, xoffset = 0.47554411191734, yoffset = 0.68342356389650 };
MapNotes_Const[1][19] = { scale = 0.02836291430658, xoffset = 0.44972878210917, yoffset = 0.55638479002362 };
MapNotes_Const[1][20] = { scale = 0.10054401185671, xoffset = 0.44927594451520, yoffset = 0.76494573629405 };
MapNotes_Const[1][21] = { scale = 0.19293573573141, xoffset = 0.47237382938446, yoffset = 0.17390990272233 };
MapNotes_Const[2][0] = { xscale = 10448.3, yscale = 7072.7, cityscale = 1.565 };
MapNotes_Const[2][1] = { scale = 0.07954563533736, xoffset = 0.43229874660542, yoffset = 0.25425926375262, xscale = 12160.5, yscale = 8197.8, cityscale = 1.687 };
MapNotes_Const[2][2] = { scale = 0.10227310921644, xoffset = 0.47916793249546, yoffset = 0.32386170078419, xscale = 14703.1, yscale = 9825.0, cityscale = 1.882 };
MapNotes_Const[2][3] = { scale = 0.07066771883566, xoffset = 0.51361415033147, yoffset = 0.56915717993261, xscale = 18568.7, yscale = 12472.2, cityscale = 2.210 };
MapNotes_Const[2][4] = { scale = 0.09517074521836, xoffset = 0.48982154167011, yoffset = 0.76846519986510, xscale = 24390.3, yscale = 15628.5, cityscale = 2.575 };
MapNotes_Const[2][5] = { scale = 0.08321525646393, xoffset = 0.04621224670174, yoffset = 0.61780780524905, xscale = 37012.2, yscale = 25130.6, cityscale = 2.651 };
MapNotes_Const[2][6] = { scale = 0.07102298961531, xoffset = 0.47822105868635, yoffset = 0.73863555048516 };
MapNotes_Const[2][7] = { scale = 0.13991525534426, xoffset = 0.40335096278072, yoffset = 0.48339696712179 };
MapNotes_Const[2][8] = { scale = 0.07670475476181, xoffset = 0.43087243362495, yoffset = 0.73224350550454 };
MapNotes_Const[2][9] = { scale = 0.10996723642661, xoffset = 0.51663255550387, yoffset = 0.15624753972085 };
MapNotes_Const[2][10] = { scale = 0.09860350595046, xoffset = 0.41092682316676, yoffset = 0.65651531970162 };
MapNotes_Const[2][11] = { scale = 0.09090931690055, xoffset = 0.42424361247460, yoffset = 0.30113436864162 };
MapNotes_Const[2][12] = { scale = 0.02248317426784, xoffset = 0.47481923366335, yoffset = 0.51289242617182 };
MapNotes_Const[2][13] = { scale = 0.07839152145224, xoffset = 0.51118749188138, yoffset = 0.50940913489577 };
MapNotes_Const[2][14] = { scale = 0.06170112311456, xoffset = 0.49917278340928, yoffset = 0.68359285304999 };
MapNotes_Const[2][15] = { scale = 0.06338794005823, xoffset = 0.46372051266487, yoffset = 0.57812379382509 };
MapNotes_Const[2][16] = { scale = 0.11931848806212, xoffset = 0.35653502290090, yoffset = 0.24715695496522 };
MapNotes_Const[2][17] = { scale = 0.03819701270887, xoffset = 0.41531450060561, yoffset = 0.67097280492581 };
MapNotes_Const[2][18] = { scale = 0.18128603034401, xoffset = 0.39145470225916, yoffset = 0.79412224886668 };
MapNotes_Const[2][19] = { scale = 0.06516347991404, xoffset = 0.51769795272070, yoffset = 0.72815974701615 };
MapNotes_Const[2][20] = { scale = 0.10937523495111, xoffset = 0.49929119700867, yoffset = 0.25567971676068 };
MapNotes_Const[2][21] = { scale = 0.12837403412087, xoffset = 0.36837217317549, yoffset = 0.15464954319582 };
MapNotes_Const[2][22] = { scale = 0.02727719546939, xoffset = 0.42973999245660, yoffset = 0.23815358517831 };
MapNotes_Const[2][23] = { scale = 0.12215946583965, xoffset = 0.44270955019641, yoffset = 0.17471356786018 };
MapNotes_Const[2][24] = { scale = 0.09943208435841, xoffset = 0.36884571674582, yoffset = 0.71874918595783 };
MapNotes_Const[2][25] = { scale = 0.11745423014662, xoffset = 0.46561438951659, yoffset = 0.40971063365152 };


function MapNotes_OnLoad()
	for i=1, 21, 1 do
		MapNotes_Data[1][i] = {};
		MapNotes_Lines[1][i] = {};
	end
	for i=1, 26, 1 do
		MapNotes_Data[2][i] = {};
		MapNotes_Lines[2][i] = {};
	end
	MapNotes_RegisterDropDownButton(MAPNOTES_SHOWNOTES, "MapNotes_Options.shownotes", "MapNotesDropDownSubMenu");
	MiniNotePOI.TimeSinceLastUpdate = 0;
	MapNotes_LoadZones1(GetMapZones(1));
	MapNotes_LoadZones2(GetMapZones(2));
	WorldMapMagnifyingGlassButton:SetText(ZOOM_OUT_BUTTON_TEXT.."\n"..MAPNOTES_WORLDMAPHELP);
	if (Sky) then
		if ( ThottbotReplace_ReplaceIt ) then
			ThottbotReplace_ReplaceIt();
		end
		Sky.registerSlashCommand(
			{
				id = "MapNotesEnableCmd";
				commands = MAPNOTES_ENABLE_COMMANDS;
				onExecute = MapNotes_GetNoteBySlashCommand;
				helpText = MAPNOTES_CHAT_COMMAND_ENABLE_INFO;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesOneNoteCmd";
				commands = MAPNOTES_ONEOTE_COMMANDS;
				onExecute = MapNotes_OneNote;
				helpText = MAPNOTES_CHAT_COMMAND_ONENOTE_INFO;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesMiniNoteCmd";
				commands = MAPNOTES_MININOTE_COMMANDS;
				onExecute = MapNotes_NextMiniNote;
				helpText = MAPNOTES_CHAT_COMMAND_MININOTE_INFO;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesMiniNoteOnlyCmd";
				commands = MAPNOTES_MININOTEONLY_COMMANDS;
				onExecute = MapNotes_NextMiniNoteOnly;
				helpText = MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesMiniNoteOffCmd";
				commands = MAPNOTES_MININOTEOFF_COMMANDS;
				onExecute = MapNotes_ClearMiniNote;
				helpText = MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesMntlocCmd";
				commands = MAPNOTES_MNTLOC_COMMANDS;
				onExecute = MapNotes_mntloc;
				helpText = MAPNOTES_CHAT_COMMAND_MNTLOC_INFO;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesQuickNoteCmd";
				commands = MAPNOTES_QUICKNOTE_COMMANDS;
				onExecute = MapNotes_Quicknote;
				helpText = MAPNOTES_CHAT_COMMAND_QUICKNOTE;
			}
		);
		Sky.registerSlashCommand(
			{
				id = "MapNotesQuickTlocCmd";
				commands = MAPNOTES_QUICKTLOC_COMMANDS;
				onExecute = MapNotes_Quicktloc;
				helpText = MAPNOTES_CHAT_COMMAND_QUICKTLOC;
			}
		);
		Sky.registerAlert(
			{
				id = "MN";
				func = MapNotes_GetNoteFromChat;
				description = "MapNotes Listener"
			}
		);
	else
		SlashCmdList["MAPNOTE"] = MapNotes_GetNoteBySlashCommand;
		for i = 1, table.getn(MAPNOTES_ENABLE_COMMANDS) do setglobal("SLASH_MAPNOTE"..i, MAPNOTES_ENABLE_COMMANDS[i]); end
		SlashCmdList["ONENOTE"] = MapNotes_OneNote;
		for i = 1, table.getn(MAPNOTES_ONEOTE_COMMANDS) do setglobal("SLASH_ONENOTE"..i, MAPNOTES_ONEOTE_COMMANDS[i]); end
		SlashCmdList["MININOTE"] = MapNotes_NextMiniNote;
		for i = 1, table.getn(MAPNOTES_MININOTE_COMMANDS) do setglobal("SLASH_MININOTE"..i, MAPNOTES_MININOTE_COMMANDS[i]); end
		SlashCmdList["MININOTEONLY"] = MapNotes_NextMiniNoteOnly;
		for i = 1, table.getn(MAPNOTES_MININOTEONLY_COMMANDS) do setglobal("SLASH_MININOTEONLY"..i, MAPNOTES_MININOTEONLY_COMMANDS[i]); end
		SlashCmdList["MININOTEOFF"] = MapNotes_ClearMiniNote;
		for i = 1, table.getn(MAPNOTES_MININOTEOFF_COMMANDS) do setglobal("SLASH_MININOTEOFF"..i, MAPNOTES_MININOTEOFF_COMMANDS[i]); end
		SlashCmdList["MNTLOC"] = MapNotes_mntloc;
		for i = 1, table.getn(MAPNOTES_MNTLOC_COMMANDS) do setglobal("SLASH_MNTLOC"..i, MAPNOTES_MNTLOC_COMMANDS[i]); end
		SlashCmdList["QUICKNOTE"] = MapNotes_Quicknote;
		for i = 1, table.getn(MAPNOTES_QUICKNOTE_COMMANDS) do setglobal("SLASH_QUICKNOTE"..i, MAPNOTES_QUICKNOTE_COMMANDS[i]); end
		SlashCmdList["QUICKTLOC"] = MapNotes_Quicktloc;
		for i = 1, table.getn(MAPNOTES_QUICKTLOC_COMMANDS) do setglobal("SLASH_QUICKTLOC"..i, MAPNOTES_QUICKTLOC_COMMANDS[i]); end

		-- hooking the chat when Cosmos is not installed
		local old_ChatFrame_OnEvent = ChatFrame_OnEvent;
		function ChatFrame_OnEvent(event)
			if (strsub(event, 1, 16) == "CHAT_MSG_WHISPER" and strsub(arg1, 1, 6) == "<MapN>") then
				if (strsub(event, 17) == "_INFORM") then
					-- do nothing
				else
					MapNotes_GetNoteFromChat(arg1, arg2);
				end
			else
				old_ChatFrame_OnEvent(event);
			end
		end
		
	end

	MapNotes_CurrentZoneFix_SetupFix();
end

function MapNotes_CurrentZoneFix_SetupFix()
	-- CurrentZoneFix v2.0 by Legorol
	-- email: legorol@cosmosui.org
	
	local versionID = 20;
	local id = CurrentZoneFix_FixInPlace;
	
	if ( id ) then
		id = tonumber(id);
		if ( id and id >= versionID ) then
			return;
		elseif ( not SetMapToCurrentZone(true) ) then
			DEFAULT_CHAT_FRAME:AddMessage("Warning! Obsolete version "..
				"of CurrentZoneFix function detected. The old "..
				"version is being loaded either as a standalone "..
				"AddOn, or as code embedded inside another AddOn. "..
				"You must update it to avoid bugs with the map!",1,0,0)
			return;
		end
	end
	
	local continent,zone,name
	local zoneID={};
	local orig_SetMapToCurrentZone;
	
	for continent in ipairs{GetMapContinents()} do
		for zone,name in ipairs{GetMapZones(continent)} do
			zoneID[name] = zone;
		end
	end
	
	orig_SetMapToCurrentZone = SetMapToCurrentZone;
	SetMapToCurrentZone = function(deactivate)
		if (deactivate) then
			SetMapToCurrentZone = orig_SetMapToCurrentZone;
			CurrentZoneFix_FixInPlace = nil;
			return true;
		end
		
		orig_SetMapToCurrentZone();
		if ( GetCurrentMapZone()==0 and GetCurrentMapContinent()>0 ) then
			SetMapZoom(GetCurrentMapContinent(),zoneID[GetRealZoneText()]);
		else
			SetMapToCurrentZone = orig_SetMapToCurrentZone;
			CurrentZoneFix_FixInPlace = "Deactivated "..versionID;
		end
	end
	
	CurrentZoneFix_FixInPlace = versionID;
end


-- don't know how to get these in one function (hanvn't tried often)
function MapNotes_LoadZones1(...)
	MapNotes_ZoneNames[1] = {};
	for i=1, arg.n, 1 do
		MapNotes_ZoneNames[1][MapNotes_ZoneShift[1][i]] = arg[i];
	end
end

function MapNotes_LoadZones2(...)
	MapNotes_ZoneNames[2] = {};
	for i=1, arg.n, 1 do
		MapNotes_ZoneNames[2][MapNotes_ZoneShift[2][i]] = arg[i];
	end
end


function MapNotes_GetZone() --because of the bug in SetToCurrentZone();
      -- The texts of Ironforge don't match (Oystein). realzonetext returns the right one.
      local zonetext = GetRealZoneText();
     -- if( zonetext == "City of Ironforge") then
      --   zonetext = "Ironforge";
      --end

	for i=1, 2, 1 do
		local j = 1;
		for k, value in MapNotes_ZoneNames[i] do

			if (MapNotes_ZoneNames[i][j] == zonetext) then
				return i, j;
			end
			j = j + 1;
		end
	end
	return 0, 0;
end

function MapNotes_ImportCartoPlus()
	if (CartoPlus_PointList) then
		for z=101, 121, 1 do
			local j = 1;
			local continent = floor(z / 100);
			local zone = z - (continent * 100);
			if (CartoPlus_PointList[z] ~= nil) then
				for k, value in CartoPlus_PointList[z] do
					local i = 0;
					for h, value in MapNotes_Data[continent][zone] do
						i = i + 1;
					end
					if (i < MapNotes_NotesPerZone) then
						local infotemp = gsub(CartoPlus_PointList[z][j].expla, string.char(10), " ");
						local inf1temp;
						local inf2temp;
						if (strlen(infotemp) > 40) then
							inf1temp = strsub(infotemp, 1, floor(strlen(infotemp)/2));
							inf2temp = strsub(infotemp, floor(strlen(infotemp)/2 + 1));
						else
							inf1temp = infotemp;
							inf2temp = "";
						end
						if (inf1temp == nil) then inf1temp = ""; end
						if (inf2temp == nil) then inf2temp = ""; end
						inf1temp = strsub(inf1temp, 1, 80);
						inf2temp = strsub(inf2temp, 1, 80);
						if (CartoPlus_PointList[z][j].icon > 9) then CartoPlus_PointList[z][j].icon = CartoPlus_PointList[z][j].icon - 10; end
						MapNotes_TempData_Id = i + 1;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = CartoPlus_PointList[z][j].title;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = 0;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = inf1temp;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = 0;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = inf2temp;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = 0;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = UnitName("player");
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = CartoPlus_PointList[z][j].icon;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = CartoPlus_PointList[z][j].x;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = CartoPlus_PointList[z][j].y;
						CartoPlus_PointList[z][j] = nil;
					end
					j = j + 1;
				end
			end
		end
		for z=201, 225, 1 do
			local j = 1;
			local continent = floor(z / 100);
			local zone = z - (continent * 100);
			if (CartoPlus_PointList[z] ~= nil) then
				for k, value in CartoPlus_PointList[z] do
					local i = 0;
					for h, value in MapNotes_Data[continent][zone] do
						i = i + 1;
					end
					if (i < MapNotes_NotesPerZone) then
						local infotemp = gsub(CartoPlus_PointList[z][j].expla, string.char(10), " ");
						local inf1temp;
						local inf2temp;
						if (strlen(infotemp) > 40) then
							inf1temp = strsub(infotemp, 1, floor(strlen(infotemp)/2));
							inf2temp = strsub(infotemp, floor(strlen(infotemp)/2 + 1));
						else
							inf1temp = infotemp;
							inf2temp = "";
						end
						if (inf1temp == nil) then inf1temp = ""; end
						if (inf2temp == nil) then inf2temp = ""; end
						inf1temp = strsub(inf1temp, 1, 80);
						inf2temp = strsub(inf2temp, 1, 80);
						if (CartoPlus_PointList[z][j].icon > 9) then CartoPlus_PointList[z][j].icon = CartoPlus_PointList[z][j].icon - 10; end
						MapNotes_TempData_Id = i + 1;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = CartoPlus_PointList[z][j].title;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = 0;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = inf1temp;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = 0;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = inf2temp;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = 0;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = UnitName("player");
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = CartoPlus_PointList[z][j].icon;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = CartoPlus_PointList[z][j].x;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = CartoPlus_PointList[z][j].y;
						CartoPlus_PointList[z][j] = nil;
					end
					j = j + 1;
				end				
			end	
		end
	end
end
-- <MapN> c<1> z<1> x<0.123123> y<0.123123> t<> i1<> i2<> cr<> i<8> tc<3> i1c<5> i2c<6>
-- limit to 50 chars in every line...
function MapNotes_GetNoteFromChat(note, who)
	if (who ~= UnitName("player")) then
		if (gsub(note,".*<MapN+>%s+%w+.*p<([^>]*)>.*","%1",1) == "1") then -- Party Note
			local continent = gsub(note,".*<MapN+> c<([^>]*)>.*","%1",1) + 0;
			local zone = gsub(note,".*<MapN+>%s+%w+.*z<([^>]*)>.*","%1",1) + 0;
			local xPos = gsub(note,".*<MapN+>%s+%w+.*x<([^>]*)>.*","%1",1) + 0;
			local yPos = gsub(note,".*<MapN+>%s+%w+.*y<([^>]*)>.*","%1",1) + 0;
			MapNotes_PartyNoteData.continent = continent;
			MapNotes_PartyNoteData.zone = zone;
			MapNotes_PartyNoteData.xPos = xPos;
			MapNotes_PartyNoteData.yPos = yPos;
			MapNotes_StatusPrint(format(MAPNOTES_PARTY_GET, who, MapNotes_ZoneNames[continent][zone]));
			if (MapNotes_MiniNote_Data.icon == "party" or MapNotes_Options[16] ~= "off") then
				MapNotes_MiniNote_Data.id = -1;
				MapNotes_MiniNote_Data.continent = continent;
				MapNotes_MiniNote_Data.zone = zone;
				MapNotes_MiniNote_Data.xPos = xPos;
				MapNotes_MiniNote_Data.yPos = yPos;
				MapNotes_MiniNote_Data.name = MAPNOTES_PARTYNOTE;
				MapNotes_MiniNote_Data.color = 0; 
				MapNotes_MiniNote_Data.icon = "party";
				MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
				MiniNotePOI:Show();
			end
		else
			local continent = gsub(note,".*<MapN+> c<([^>]*)>.*","%1",1) + 0;
			local zone = gsub(note,".*<MapN+>%s+%w+.*z<([^>]*)>.*","%1",1) + 0;
			local xPos = gsub(note,".*<MapN+>%s+%w+.*x<([^>]*)>.*","%1",1) + 0;
			local yPos = gsub(note,".*<MapN+>%s+%w+.*y<([^>]*)>.*","%1",1) + 0;
			local title = gsub(note,".*<MapN+>%s+%w+.*t<([^>]*)>.*","%1",1);
			local info1 = gsub(note,".*<MapN+>%s+%w+.*i1<([^>]*)>.*","%1",1);
			local info2 = gsub(note,".*<MapN+>%s+%w+.*i2<([^>]*)>.*","%1",1);
			local creator = gsub(note,".*<MapN+>%s+%w+.*cr<([^>]*)>.*","%1",1);
			local icon = gsub(note,".*<MapN+>%s+%w+.*i<([^>]*)>.*","%1",1)+0;
			local tcolor = gsub(note,".*<MapN+>%s+%w+.*tf<([^>]*)>.*","%1",1)+0;
			local i1color = gsub(note,".*<MapN+>%s+%w+.*i1f<([^>]*)>.*","%1",1)+0;
			local i2color = gsub(note,".*<MapN+>%s+%w+.*i2f<([^>]*)>.*","%1",1)+0;
			if (MapNotes_LastReceivedNote_xPos == xPos and MapNotes_LastReceivedNote_yPos == yPos) then
				-- do nothing, because the previous note is exactly the same as the current note
			else
			local checknote = MapNotes_CheckNearNotes(continent, zone, xPos, yPos);
				MapNotes_LastReceivedNote_xPos = xPos;
				MapNotes_LastReceivedNote_yPos = yPos;	
				if (checknote) then
					MapNotes_StatusPrint(format(MAPNOTES_DECLINE_NOTETONEAR, who, MapNotes_ZoneNames[continent][zone], MapNotes_Data[continent][zone][checknote].name));
					return;
				end
				local id = 0;
				local i = 0;
				for j, value in MapNotes_Data[continent][zone] do
					i = i + 1;
				end
				if (MapNotes_SetNextAsMiniNote ~= 2) then
					if ((MapNotes_AllowOneNote == 1 and i < MapNotes_NotesPerZone) or (MapNotes_Options[14] ~= "off" and MapNotes_Options[15] == "off" and i < MapNotes_NotesPerZone) or (MapNotes_Options[14] ~= "off" and MapNotes_Options[15] ~= "off" and i < MapNotes_NotesPerZone - 5)) then
						MapNotes_TempData_Id = i + 1;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = title;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = tcolor;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = info1;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = i1color;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = info2;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = i2color;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = creator;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = icon;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = xPos;
						MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = yPos;
						id = MapNotes_TempData_Id;
						MapNotes_StatusPrint(format(MAPNOTES_ACCEPT_GET, who, MapNotes_ZoneNames[continent][zone]));
					else
						MapNotes_StatusPrint(format(MAPNOTES_DECLINE_GET, who, MapNotes_ZoneNames[continent][zone]));
					end
				end
				if (MapNotes_SetNextAsMiniNote ~= 0) then
					MapNotes_MiniNote_Data.xPos = xPos;
					MapNotes_MiniNote_Data.yPos = xPos;
					MapNotes_MiniNote_Data.continent = continent;
					MapNotes_MiniNote_Data.zone = zone;
					MapNotes_MiniNote_Data.id = id; -- only shown if the note was written...
					MapNotes_MiniNote_Data.name = title;
					MapNotes_MiniNote_Data.color = tcolor;
					MapNotes_MiniNote_Data.icon = icon;
					MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..icon);
					MiniNotePOI:Show();
					MapNotes_SetNextAsMiniNote = 0;
					MapNotes_StatusPrint(MAPNOTES_SETMININOTE);
				end
				MapNotes_AllowOneNote = 0;
			end
		end
	end
end

function MapNotes_CheckNearNotes(continent, zone, xPos, yPos)
	local i = 1;
	if (zone == 0) then return false; end -- not in a valid zone, so no note in the way :)
	for j, value in MapNotes_Data[continent][zone] do
		if (abs(MapNotes_Data[continent][zone][i].xPos - xPos) <= 0.0009765625 * MapNotes_MinDiff and abs(MapNotes_Data[continent][zone][i].yPos - yPos) <= 0.0013020833 * MapNotes_MinDiff) then
			return i;
		end
		i = i + 1;
	end
	return false;
end

function MapNotes_GetNoteBySlashCommand(msg)
	if (msg ~= "" and msg ~= nil) then
		msg = "<MapN> "..msg;
		local continent = gsub(msg,".*<MapN+> c<([^>]*)>.*","%1",1) + 0;
		local zone = gsub(msg,".*<MapN+>%s+%w+.*z<([^>]*)>.*","%1",1) + 0;
		local xPos = gsub(msg,".*<MapN+>%s+%w+.*x<([^>]*)>.*","%1",1) + 0;
		local yPos = gsub(msg,".*<MapN+>%s+%w+.*y<([^>]*)>.*","%1",1) + 0;
		local title = gsub(msg,".*<MapN+>%s+%w+.*t<([^>]*)>.*","%1",1);
		local info1 = gsub(msg,".*<MapN+>%s+%w+.*i1<([^>]*)>.*","%1",1);
		local info2 = gsub(msg,".*<MapN+>%s+%w+.*i2<([^>]*)>.*","%1",1);
		local creator = gsub(msg,".*<MapN+>%s+%w+.*cr<([^>]*)>.*","%1",1);
		local icon = gsub(msg,".*<MapN+>%s+%w+.*i<([^>]*)>.*","%1",1)+0;
		local tcolor = gsub(msg,".*<MapN+>%s+%w+.*tf<([^>]*)>.*","%1",1)+0;
		local i1color = gsub(msg,".*<MapN+>%s+%w+.*i1f<([^>]*)>.*","%1",1)+0;
		local i2color = gsub(msg,".*<MapN+>%s+%w+.*i2f<([^>]*)>.*","%1",1)+0;
		local checknote = MapNotes_CheckNearNotes(continent, zone, xPos, yPos);
		local id = 0;
		local i = 0;
		for j, value in MapNotes_Data[continent][zone] do
			i = i + 1;
		end
		if (MapNotes_SetNextAsMiniNote ~= 2) then
			local checknote = MapNotes_CheckNearNotes(continent, zone, xPos, yPos);
			if (checknote) then
				MapNotes_StatusPrint(format(MAPNOTES_DECLINE_SLASH_NEAR, MapNotes_Data[continent][zone][checknote].name, MapNotes_ZoneNames[continent][zone]));
			else
				if (i < MapNotes_NotesPerZone) then
					MapNotes_TempData_Id = i + 1;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
					if (info1 == "") then print1("gut"); end
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = title;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = tcolor;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = info1;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = i1color;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = info2;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = i2color;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = creator;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = icon;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = xPos;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = yPos;
					id = MapNotes_TempData_Id;
					MapNotes_StatusPrint(format(MAPNOTES_ACCEPT_SLASH, MapNotes_ZoneNames[continent][zone]));
				else
					MapNotes_StatusPrint(format(MAPNOTES_DECLINE_SLASH, MapNotes_ZoneNames[continent][zone]));
				end
			end
		end
		if (MapNotes_SetNextAsMiniNote ~= 0) then
			MapNotes_MiniNote_Data.xPos = xPos;
			MapNotes_MiniNote_Data.yPos = yPos;
			MapNotes_MiniNote_Data.continent = continent;
			MapNotes_MiniNote_Data.zone = zone;
			MapNotes_MiniNote_Data.id = id; -- only shown if the note was written...
			MapNotes_MiniNote_Data.name = title;
			MapNotes_MiniNote_Data.color = tcolor;
			MapNotes_MiniNote_Data.icon = icon;
			MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..icon);
			MiniNotePOI:Show();
			MapNotes_SetNextAsMiniNote = 0;
			MapNotes_StatusPrint(MAPNOTES_SETMININOTE);
		end
	else
		MapNotes_StatusPrint(MAPNOTES_MAPNOTEHELP);
	end
end

function MapNotes_StringToArray(msg) --UNUSED AT THE MOMENT (I think)
	local temparray = {};
	local count = 1;
	local startvalue = 1;
	local stopvalue = 0;
	while (strfind(msg, "`", startvalue) ~= nil) do
		if (strfind(msg, "`", startvalue) > stopvalue + 1) then
			temparray[count] = strsub(msg, stopvalue + 1, strfind(msg, "`", startvalue)-1);
		else
			temparray[count] = nil;
		end
		count = count + 1;
		stopvalue = strfind(msg, "`", startvalue);
		startvalue = strfind(msg, "`", startvalue) + 1;
	end
	return temparray;
end

function MapNotes_StatusPrint(msg)
	msg = "<Map Notes>: "..msg;
	if ( DEFAULT_CHAT_FRAME ) then 
		DEFAULT_CHAT_FRAME:AddMessage(msg, 1.0, 0.5, 0.25);
	end
end

function MapNotes_mntloc(msg)
	if (msg == "") then
		MapNotes_tloc_xPos = nil;
		MapNotes_tloc_yPos = nil;
	else
		local i,j,x,y = string.find(msg,"(%d+),(%d+)");
		MapNotes_tloc_xPos = x / 100;
		MapNotes_tloc_yPos = y / 100;
	end
end

function MapNotes_Quicktloc(msg)
	if (msg == "") then
		MapNotes_StatusPrint(MAPNOTES_QUICKTLOC_NOARGUMENT);	
	else
		local data = strsub(msg, 1, 5);
		msg = strsub(msg, 7);
		local i,j,x,y = string.find(data,"(%d+),(%d+)");
		local continent, zone = MapNotes_GetZone();
		x = x / 100; y = y / 100;
		local checknote = MapNotes_CheckNearNotes(continent, zone, x, y);
		if (checknote) then
			MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETONEAR, MapNotes_Data[continent][zone][checknote].name));
		elseif (zone == 0) then
			MapNotes_StatusPrint(MAPNOTES_QUICKTLOC_NOZONE);
		else
			local id = 0;
			local icon = 0;
			local name = MAPNOTES_THOTTBOTLOC;
			if (msg ~= "" and msg ~= nil) then
				local icheck = strsub(msg, 1, 2);
				if (strlen(icheck) == 1) then icheck = icheck.." "; end
				if (icheck == "0 " or icheck == "1 " or icheck == "2 " or icheck == "3 " or icheck == "4 " or icheck == "5 " or icheck == "6 " or icheck == "7 " or icheck == "8 " or icheck == "9 ") then icon = strsub(msg, 1, 1)+0; msg = strsub(msg, 3); end
				if (msg ~= "" and msg ~= nil) then name = strsub(msg, 1, 80); end
			end
			if (MapNotes_SetNextAsMiniNote ~= 2) then
				local i = 0;
				for j, value in MapNotes_Data[continent][zone] do
					i = i + 1;
				end
				if (i < MapNotes_NotesPerZone) then
					MapNotes_TempData_Id = i + 1;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = name;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = 0;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = "";
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = 0;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = "";
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = 0;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = UnitName("player");
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = icon;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = x;
					MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = y;
					id = MapNotes_TempData_Id;
					MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_OK, MapNotes_ZoneNames[continent][zone]));
				else
					MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_TOOMANY, MapNotes_ZoneNames[continent][zone]));
				end
			end
			if (MapNotes_SetNextAsMiniNote ~= 0) then
				MapNotes_MiniNote_Data.xPos = x;
				MapNotes_MiniNote_Data.yPos = y;
				MapNotes_MiniNote_Data.continent = continent;
				MapNotes_MiniNote_Data.zone = zone;
				MapNotes_MiniNote_Data.id = id; -- only shown if the note was written...
				MapNotes_MiniNote_Data.name = name;
				MapNotes_MiniNote_Data.color = 0;
				MapNotes_MiniNote_Data.icon = icon;
				MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..icon);
				MiniNotePOI:Show();
				MapNotes_SetNextAsMiniNote = 0;
				MapNotes_StatusPrint(MAPNOTES_SETMININOTE);
			end
		end
	end
end

function MapNotes_Quicknote(msg)
	local continent, zone = MapNotes_GetZone();
	SetMapToCurrentZone();
	local x, y = GetPlayerMapPosition("player");
	local checknote = MapNotes_CheckNearNotes(continent, zone, x, y);
	if (checknote) then
		MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETONEAR, MapNotes_Data[continent][zone][checknote].name));
	elseif ((x == 0 and y == 0) or zone == 0) then
		MapNotes_StatusPrint(MAPNOTES_QUICKNOTE_NOPOSITION);
	else
		local id = 0;
		local icon = 0;
		local name = MAPNOTES_QUICKNOTE_DEFAULTNAME;
		if (msg ~= "" and msg ~= nil) then
			local icheck = strsub(msg, 1, 2);
			if (icheck == "0 " or icheck == "1 " or icheck == "2 " or icheck == "3 " or icheck == "4 " or icheck == "5 " or icheck == "6 " or icheck == "7 " or icheck == "8 " or icheck == "9 ") then icon = strsub(msg, 1, 1)+0; msg = strsub(msg, 3); end
			if (msg ~= "" and msg ~= nil) then name = strsub(msg, 1, 80); end
		end
		if (MapNotes_SetNextAsMiniNote ~= 2) then
			local i = 0;
			for j, value in MapNotes_Data[continent][zone] do
				i = i + 1;
			end
			if (i < MapNotes_NotesPerZone) then
				MapNotes_TempData_Id = i + 1;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = name;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = 0;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = "";
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = 0;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = "";
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = 0;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = UnitName("player");
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = icon;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = x;
				MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = y;
				id = MapNotes_TempData_Id;
				MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_OK, MapNotes_ZoneNames[continent][zone]));
			else
				MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_TOOMANY, MapNotes_ZoneNames[continent][zone]));
			end
		end
		if (MapNotes_SetNextAsMiniNote ~= 0) then
			MapNotes_MiniNote_Data.xPos = x;
			MapNotes_MiniNote_Data.yPos = y;
			MapNotes_MiniNote_Data.continent = continent;
			MapNotes_MiniNote_Data.zone = zone;
			MapNotes_MiniNote_Data.id = id; -- only shown if the note was written...
			MapNotes_MiniNote_Data.name = name;
			MapNotes_MiniNote_Data.color = 0;
			MapNotes_MiniNote_Data.icon = icon;
			MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..icon);
			MiniNotePOI:Show();
			MapNotes_SetNextAsMiniNote = 0;
			MapNotes_StatusPrint(MAPNOTES_SETMININOTE);
		end
	end	
end

function MapNotes_Misc_OnClick(arg1)
	CloseDropDownMenus();

	if (this:GetID() == 0) then
		if (arg1 == "LeftButton") then
			if (MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()] ~= 0) then
				MapNotesButtonNewNote:Enable();
				MapNotes_ShowNewFrame(MapNotes_tloc_xPos, MapNotes_tloc_yPos);
				if (MapNotes_BlockingFrame()) then MapNotes_TempData_Id = 0; end
			end
		elseif (arg1 == "RightButton") then
			local x, y = this:GetCenter();
			x = x / WorldMapButton:GetScale();
			y = y / WorldMapButton:GetScale();
			local centerX, centerY = WorldMapButton:GetCenter();
			local width = WorldMapButton:GetWidth();
			local height = WorldMapButton:GetHeight();
			local ay = (centerY + (height/2) - y) / height;
			local ax = (x - (centerX - (width/2))) / width;
			if (ax*1002 >= (1002 - 195)) then xOffset = -176; else xOffset = 0;	end
			if (ay*668 <= (668 - 156)) then yOffset = -75; else yOffset = 113; end
			if (MapNotes_BlockingFrame()) then
				MapNotesPOIMenuFrame:SetPoint("TOPLEFT", "WorldMapFrame", "TOPLEFT", ax * WorldMapButton:GetWidth() + xOffset, -(ay * WorldMapButton:GetHeight()) + yOffset);
				MapNotesNewMenuFrame:Hide();
				MapNotesButtonEditNote:Disable();
				MapNotesButtonSendNote:Disable();
				WorldMapTooltip:Hide();
				MapNotesPOIMenuFrame:Show();
				MapNotes_TempData_Id = 0;
			end
		end
	elseif (this:GetID() == 1) then
		if (arg1 == "LeftButton") then
			local x, y = this:GetCenter();
			x = x / WorldMapButton:GetScale();
			y = y / WorldMapButton:GetScale();
			local centerX, centerY = WorldMapButton:GetCenter();
			local width = WorldMapButton:GetWidth();
			local height = WorldMapButton:GetHeight();
			local adjustedY = (centerY + (height/2) - y) / height;
			local adjustedX = (x - (centerX - (width/2))) / width;
			if (MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()] ~= 0) then
				MapNotesButtonNewNote:Disable();
				MapNotes_ShowNewFrame(adjustedX, adjustedY);
				if (MapNotes_BlockingFrame()) then MapNotes_TempData_Id = -1; end
			end
		elseif (arg1 == "RightButton") then
			local x, y = this:GetCenter();
			x = x / WorldMapButton:GetScale();
			y = y / WorldMapButton:GetScale();
			local centerX, centerY = WorldMapButton:GetCenter();
			local width = WorldMapButton:GetWidth();
			local height = WorldMapButton:GetHeight();
			local ay = (centerY + (height/2) - y) / height;
			local ax = (x - (centerX - (width/2))) / width;
			if (ax*1002 >= (1002 - 195)) then xOffset = -176; else xOffset = 0;	end
			if (ay*668 <= (668 - 156)) then yOffset = -75; else yOffset = 113; end
			if (MapNotes_BlockingFrame()) then
				MapNotesPOIMenuFrame:SetPoint("TOPLEFT", "WorldMapFrame", "TOPLEFT", ax * WorldMapButton:GetWidth() + xOffset, -(ay * WorldMapButton:GetHeight()) + yOffset);
				MapNotesNewMenuFrame:Hide();
				MapNotesButtonEditNote:Disable();
				MapNotesButtonSendNote:Disable();
				WorldMapTooltip:Hide();
				MapNotesPOIMenuFrame:Show();
				MapNotes_TempData_Id = -1;
			end
		end
	end
end

function MapNotes_NextMiniNote(msg)
	if (msg == "on" or msg == "ON") then
		MapNotes_SetNextAsMiniNote = 1;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_1);
	elseif (msg == "off" or msg == "OFF") then
		MapNotes_SetNextAsMiniNote = 0;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_0);
	elseif (MapNotes_SetNextAsMiniNote == 1) then
		MapNotes_SetNextAsMiniNote = 0;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_0);
	else
		MapNotes_SetNextAsMiniNote = 1;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_1);
	end
end

function MapNotes_NextMiniNoteOnly(msg)
	if (msg == "on" or msg == "ON") then
		MapNotes_SetNextAsMiniNote = 2;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_2);
	elseif (msg == "off" or msg == "OFF") then
		MapNotes_SetNextAsMiniNote = 0;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_0);
	elseif (MapNotes_SetNextAsMiniNote == 2) then
		MapNotes_SetNextAsMiniNote = 0;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_0);
	else
		MapNotes_SetNextAsMiniNote = 2;
		MapNotes_StatusPrint(MAPNOTES_MININOTE_SHOW_2);
	end
end

function MapNotes_OneNote(msg)
	if (msg == "on" or msg == "ON") then
		MapNotes_AllowOneNote = 1;
		MapNotes_StatusPrint(MAPNOTES_ONENOTE_ON);
	elseif (msg == "off" or msg == "OFF") then
		MapNotes_AllowOneNote = 0;
		MapNotes_StatusPrint(MAPNOTES_ONENOTE_OFF);
	elseif (MapNotes_AllowOneNote == 1) then
		MapNotes_AllowOneNote = 0;
		MapNotes_StatusPrint(MAPNOTES_ONENOTE_OFF);
	else
		MapNotes_AllowOneNote = 1;
		MapNotes_StatusPrint(MAPNOTES_ONENOTE_ON);
	end
end

function MapNotes_OnEvent(event)

  if (event == "MINIMAP_UPDATE_ZOOM") then
		if (MapNotes_MiniNote_MapzoomInit) then
			if (MapNotes_MiniNote_IsInCity) then
				MapNotes_MiniNote_IsInCity = false;
			else
				MapNotes_MiniNote_IsInCity = true;
			end
		else
			local tempzoom = 0;
			if (GetCVar("minimapZoom") == GetCVar("minimapInsideZoom")) then
				if (GetCVar("minimapInsideZoom")+0 >= 3) then
					Minimap:SetZoom(Minimap:GetZoom() - 1);
					tempzoom = 1;
				else
					Minimap:SetZoom(Minimap:GetZoom() + 1);
					tempzoom = -1;
				end
			end
			if (GetCVar("minimapInsideZoom")+0 == Minimap:GetZoom()) then
				MapNotes_MiniNote_IsInCity = true;
			else
				MapNotes_MiniNote_IsInCity = false;
			end
			Minimap:SetZoom(Minimap:GetZoom() + tempzoom);
			MapNotes_MiniNote_MapzoomInit = true;
		end			
	elseif (event == "VARIABLES_LOADED") then
		if (MapNotes_MiniNote_Data.icon == "party") then
			MapNotes_ClearMiniNote();
		end
		if (MapNotes_MiniNote_Data.icon ~= nil) then
			if (MapNotes_MiniNote_Data.id == -2) then
				MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotesGathering\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
			else
				MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
			end
		end
		if (not MapNotes_Options["MapVersion"]) then
			MapNotes_Options["MapVersion"] = 1;
		end
		MapNotes_ImportCartoPlus(); -- for testin only, doesn't work correctly, because of the word wraps...

                if (Sea) then
                       	Sea.util.hook("WorldMapButton_OnUpdate", "MapNotes_WorldMapButton_OnUpdate", "after");
                 	Sea.util.hook("WorldMapButton_OnClick", "MapNotes_WorldMapButton_OnClick", "hide");
                  	Sea.util.hook("Minimap_OnClick", "MapNotes_Minimap_OnClick", "after");
                  	Sea.util.hook("ToggleWorldMap", "MapNotes_OnToggleWorldMap", "after");
                  	Sea.util.hook("WorldMapZoomOutButton_OnClick", "MapNotes_ZoomOutButton_OnClick", "after");
                else

                   local old_WorldMapButton_OnUpdate = WorldMapButton_OnUpdate;
                   WorldMapButton_OnUpdate = function() 
				   MapNotes_WorldMapButton_OnUpdate();
                                   old_WorldMapButton_OnUpdate();
                     		 end

                  local old_MapNotes_Minimap_OnClick = Minimap_OnClick;
                  Minimap_OnClick = function()
		                       MapNotes_Minimap_OnClick();
				       old_MapNotes_Minimap_OnClick();
				    end

                  local old_MapNotes_WorldMapButton_OnClick = WorldMapButton_OnClick;
               	  WorldMapButton_OnClick = function(mouseButton, button)
		                              if( MapNotes_WorldMapButton_OnClick(mouseButton, button)) then
					         old_MapNotes_WorldMapButton_OnClick(mouseButton, button);
				              end
					   end

                  local old_ToggleWorldMap = ToggleWorldMap;
                  ToggleWorldMap = function() 
		                    old_ToggleWorldMap(); 
				    MapNotes_OnToggleWorldMap(); 
				   end

                  old_WorldMapZoomOutButton_OnClick = WorldMapZoomOutButton_OnClick;
          	  WorldMapZoomOutButton_OnClick = function() 
		                                     old_WorldMapZoomOutButton_OnClick();
						     MapNotes_ZoomOutButton_OnClick();
						  end
                end

	elseif (event == "WORLD_MAP_UPDATE") then
		MapNotes_HideFrames();
	end
end

function MapNotes_MiniNote_OnUpdate(arg1)
   
   if ( MapNotes_MiniNote_Data.xPos ~= nil ) then

      MiniNotePOI.TimeSinceLastUpdate = MiniNotePOI.TimeSinceLastUpdate + arg1;
      if( MiniNotePOI.TimeSinceLastUpdate > MapNotes_Mininote_UpdateRate ) then
         local x, y = GetPlayerMapPosition("player");

         local currentZone;
         local continent = GetCurrentMapContinent();
         local zone;
	 local zoneText;

         if( continent == -1 ) then
	    zoneText = GetZoneText();
       	    zone = -1;
         else
            zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
         end
   

	if ((x == 0 and y == 0 and (zone > 0 or 
	     continent ~= MapNotes_MiniNote_Data.continent)) or 
	     continent == 0) then 
	        SetMapToCurrentZone();
		continent = GetCurrentMapContinent();
		if( continent > 0 ) then
		   zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
		end
		x, y = GetPlayerMapPosition("player"); 
        end

        local currentConst;

        if( continent == -1 ) then
           currentConst = MapNotes_Const[zoneText];
	elseif( continent > 0 ) then
	   currentConst = MapNotes_Const[MapNotes_MiniNote_Data.continent][MapNotes_MiniNote_Data.zone];

	end

        local currentZoom = Minimap:GetZoom();


	if (currentConst and x ~= 0 and y ~= 0 and currentConst.scale ~= 0) then
	        local xscale;
		local yscale;

                if (zone > 0) then
		   xscale = MapNotes_Const[MapNotes_MiniNote_Data.continent][currentZoom].xscale;
		   yscale = MapNotes_Const[MapNotes_MiniNote_Data.continent][currentZoom].yscale;
                else
                   xscale = MapNotes_Const[2][currentZoom].xscale;
		   yscale = MapNotes_Const[2][currentZoom].yscale;
		end

		if (MapNotes_MiniNote_IsInCity) then
			xscale = xscale * MapNotes_Const[2][currentZoom].cityscale;
			yscale = yscale * MapNotes_Const[2][currentZoom].cityscale;
		end

		local xpos = MapNotes_MiniNote_Data.xPos * currentConst.scale + currentConst.xoffset;
		local ypos = MapNotes_MiniNote_Data.yPos * currentConst.scale + currentConst.yoffset;

		if (zone > 0) then
			x = x * MapNotes_Const[continent][zone].scale + MapNotes_Const[continent][zone].xoffset;
			y = y * MapNotes_Const[continent][zone].scale + MapNotes_Const[continent][zone].yoffset;
		elseif( zone == -1 ) then
			x = x * MapNotes_Const[zoneText].scale + MapNotes_Const[zoneText].xoffset;
			y = y * MapNotes_Const[zoneText].scale + MapNotes_Const[zoneText].yoffset;
		end

		local deltax = (xpos - x) * xscale;
		local deltay = (ypos - y) * yscale;
		if (sqrt( (deltax * deltax) + (deltay * deltay) ) > 56.5) then
			local adjust = 1;
			if (deltax == 0) then
				deltax = deltax + 0.0000000001;
			elseif (deltax < 0) then
				adjust = -1;
			end
			local m = math.atan(deltay / deltax);
			deltax = math.cos(m) * 57 * adjust;
			deltay = math.sin(m) * 57 * adjust;
		end
		MiniNotePOI:SetPoint("CENTER", "MinimapCluster", "TOPLEFT", 105 + deltax, -93 - deltay);
		MiniNotePOI:Show();
	else
		MiniNotePOI:Hide();
	end
     end
     MiniNotePOI.TimeSinceLastUpdate = 0;

     else
	MiniNotePOI:Hide();
     end
end

function MapNotes_ShowNewFrame(ax, ay)
	if (MapNotes_BlockingFrame()) then
		MapNotes_TempData_xPos = ax;
		MapNotes_TempData_yPos = ay;
		MapNotes_TempData_Id = nil;
		if (ax*1002 >= (1002 - 195)) then xOffset = -176; else xOffset = 0;	end
		if (ay*668 <= (668 - 156)) then yOffset = -75; else yOffset = 87; end
		MapNotesNewMenuFrame:SetPoint("TOPLEFT", "WorldMapFrame", "TOPLEFT", ax * WorldMapButton:GetWidth() + xOffset, -(ay * WorldMapButton:GetHeight()) + yOffset);
		if (MapNotes_MiniNote_Data.xPos == nil) then
			MapNotesButtonMiniNoteOff:Disable();
		else
			MapNotesButtonMiniNoteOff:Enable();
		end
		if (MapNotes_NewNoteSlot() >= MapNotes_NotesPerZone + 1) then
			MapNotesButtonNewNote:Disable();
		end
		MapNotesPOIMenuFrame:Hide();
		MapNotesSpecialActionMenuFrame:Hide();
		MapNotesNewMenuFrame:Show();
	end
end

function MapNotes_ShowSpecialActionsFrame()
	local ax;
	local ay;
	if (MapNotes_TempData_Id == 0) then
		ax = MapNotes_tloc_xPos;
		ay = MapNotes_tloc_yPos;
	elseif (MapNotes_TempData_Id == -1) then
		ax = MapNotes_PartyNoteData.xPos;
		ay = MapNotes_PartyNoteData.yPos;
	else
		local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
		local continent = GetCurrentMapContinent();
		ax = MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos;
		ay = MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos;
	end
	MapNotesPOIMenuFrame:Hide();
	if (ax*1002 >= (1002 - 195)) then xOffset = -176; else xOffset = 0;	end
	if (ay*668 <= (668 - 156)) then yOffset = -75; else yOffset = 61; end
	MapNotesSpecialActionMenuFrame:SetPoint("TOPLEFT", "WorldMapFrame", "TOPLEFT", ax * WorldMapButton:GetWidth() + xOffset, -(ay * WorldMapButton:GetHeight()) + yOffset);
	if ( MapNotes_TempData_Id <= 0 ) then
		MapNotesButtonToggleLine:Disable();
	else
		MapNotesButtonToggleLine:Enable();
	end
	MapNotesSpecialActionMenuFrame:Show();
end

function MapNotes_Edit_SetIcon(icon)
	MapNotes_TempData_Icon = icon;
	IconOverlay:SetPoint("TOPLEFT", "EditIcon"..icon, "TOPLEFT", -3, 3);
end

function MapNotes_Edit_SetTextColor(color)
	MapNotes_TempData_TextColor = color;
	TextColorOverlay:SetPoint("TOPLEFT", "TextColor"..color, "TOPLEFT", -3, 3);
end

function MapNotes_Edit_SetInfo1Color(color)
	MapNotes_TempData_Info1Color = color;
	Info1ColorOverlay:SetPoint("TOPLEFT", "Info1Color"..color, "TOPLEFT", -3, 3);
end

function MapNotes_Edit_SetInfo2Color(color)
	MapNotes_TempData_Info2Color = color;
	Info2ColorOverlay:SetPoint("TOPLEFT", "Info2Color"..color, "TOPLEFT", -3, 3);
end

function MapNotes_OpenEditForExistingNote(id)
	MapNotes_HideFrames();

        local currentZone;
        local continent = GetCurrentMapContinent();
 
        if( continent == -1 ) then
           currentZone = MapNotes_Data[GetZoneText()];
        else
           local zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
           currentZone = MapNotes_Data[continent][zone];
        end

	MapNotes_TempData_Id = id;
	MapNotes_TempData_Creator = currentZone[MapNotes_TempData_Id].creator;
	MapNotes_TempData_xPos = currentZone[MapNotes_TempData_Id].xPos;
	MapNotes_TempData_yPos = currentZone[MapNotes_TempData_Id].yPos;
	MapNotes_Edit_SetIcon(currentZone[MapNotes_TempData_Id].icon);
	MapNotes_Edit_SetTextColor(currentZone[MapNotes_TempData_Id].ncol);
	MapNotes_Edit_SetInfo1Color(currentZone[MapNotes_TempData_Id].in1c);
	MapNotes_Edit_SetInfo2Color(currentZone[MapNotes_TempData_Id].in2c);
	TitleWideEditBox:SetText(currentZone[MapNotes_TempData_Id].name);
	Info1WideEditBox:SetText(currentZone[MapNotes_TempData_Id].inf1);
	Info2WideEditBox:SetText(currentZone[MapNotes_TempData_Id].inf2);
	MapNotesEditMenuFrame:Show();
end

function MapNotes_ShowSendFrame(number)
	if (number == 1) then
		MapNotesSendPlayer:Enable();
		if (Sky) then
			MapNotesSendParty:Enable();
		else
			MapNotesSendParty:Disable();
		end
		MapNotesChangeSendMenu:SetText(MAPNOTES_SLASHCOMMAND);
		SendWideEditBox:SetText("");
		if ( UnitCanCooperate("player", "target") ) then
			SendWideEditBox:SetText(UnitName("target"));
		end
		MapNotes_SendFrame_Title:SetText(MAPNOTES_SEND_COSMOSTITLE);
		MapNotes_SendFrame_Tip:SetText(MAPNOTES_SEND_COSMOSTIP);
		MapNotes_SendFrame_Player:SetText(MAPNOTES_SEND_PLAYER);
		MapNotes_ToggleSendValue = 2;
	elseif (number == 2) then
		MapNotesSendPlayer:Disable();
		MapNotesSendParty:Disable();
		MapNotesChangeSendMenu:SetText(MAPNOTES_SHOWSEND);
		SendWideEditBox:SetText("/mapnote"..MapNotes_GenerateSendString(2));
		MapNotes_SendFrame_Title:SetText(MAPNOTES_SEND_SLASHTITLE);
		MapNotes_SendFrame_Tip:SetText(MAPNOTES_SEND_SLASHTIP);
		MapNotes_SendFrame_Player:SetText(MAPNOTES_SEND_SLASHCOMMAND);
		MapNotes_ToggleSendValue = 1;
	end
	if (not MapNotesSendFrame:IsVisible()) then MapNotes_HideFrames(); MapNotesSendFrame:Show(); end
end

function MapNotes_GenerateSendString(version)
-- <MapN> c<1> z<1> x<0.123123> y<0.123123> t<> i1<> i2<> cr<> i<8> tc<3> i1c<5> i2c<6>


	local text = "";
	if (version == 1) then
		text = "<MapN>";
	end
        local currentZone;
        local continent = GetCurrentMapContinent();
        local zone;


        if( continent == -1 ) then
           currentZone = MapNotes_Data[GetZoneText()];
	   zone = -1;
        else
           zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
           currentZone = MapNotes_Data[continent][zone];
        end
   
      	if(  not currentZone) then
           return;
        end


	text = text.." c<"..continent.."> z<"..zone..">";
	local xPos = floor(currentZone[MapNotes_TempData_Id].xPos * 1000000)/1000000; --cut to six digits behind the 0
	local yPos = floor(currentZone[MapNotes_TempData_Id].yPos * 1000000)/1000000;
	text = text.." x<"..xPos.."> y<"..yPos..">";
	text = text.." t<"..MapNotes_EliminateUsedChars(currentZone[MapNotes_TempData_Id].name)..">";
	text = text.." i1<"..MapNotes_EliminateUsedChars(currentZone[MapNotes_TempData_Id].inf1)..">";
	text = text.." i2<"..MapNotes_EliminateUsedChars(currentZone[MapNotes_TempData_Id].inf2)..">";
	if ( not currentZone[MapNotes_TempData_Id].creator ) then 
		currentZone[MapNotes_TempData_Id].creator = UnitName("player");
	end
	text = text.." cr<"..currentZone[MapNotes_TempData_Id].creator..">";
	text = text.." i<"..currentZone[MapNotes_TempData_Id].icon..">";
	text = text.." tf<"..currentZone[MapNotes_TempData_Id].ncol..">";
	text = text.." i1f<"..currentZone[MapNotes_TempData_Id].in1c..">";
	text = text.." i2f<"..currentZone[MapNotes_TempData_Id].in2c..">"; 
	
	if( continent == -1 and currentZone[MapNotes_TempData_Id].zname) then
 	   text = text.." zn<"..currentZone[MapNotes_TempData_Id].zname..">"; 
	end
	return text;
end


function MapNotes_EliminateUsedChars(text) --ok, this has to be reworked with a simple replace or something like this
	while ( strfind(text, "<", 1) ~= nil ) do
		if (strfind(text, "<", 1) == 1) then
			text = strsub(text, 2);
		else
			text = strsub(text, 1, strfind(text, "<", 1) - 1)..strsub(text, strfind(text, "<", 1) + 1);
		end
	end
	while ( strfind(text, ">", 1) ~= nil ) do
		if (strfind(text, ">", 1) == 1) then
			text = strsub(text, 2);
		else
			text = strsub(text, 1, strfind(text, ">", 1) - 1)..strsub(text, strfind(text, ">", 1) + 1);
		end
	end
	return text;
end


function MapNotes_SendNote(type)

   if( Sky ) then
	if (type == 1) then
                --  Marsman 3/27/05 changed Player to Player notes to use Sky [added sending to non sky users, - Sinaloit]
		if (Sky.isSkyUser(SendWideEditBox:GetText())) then
			Sky.sendAlert(MapNotes_GenerateSendString(1), SKY_PLAYER, "MN", SendWideEditBox:GetText());
		else
			SendChatMessage(MapNotes_GenerateSendString(1), "WHISPER", this.language, SendWideEditBox:GetText());
		end
		MapNotes_HideFrames();
	elseif (type == 2) then
		Sky.sendAlert(MapNotes_GenerateSendString(1), SKY_PARTY, "MN");
		MapNotes_HideFrames();
	end
   else
	if (type == 1) then
		SendChatMessage(MapNotes_GenerateSendString(1), "WHISPER", this.language, SendWideEditBox:GetText());
		MapNotes_HideFrames();
	else
		MapNotes_HideFrames();
	end
   end
end


function MapNotes_OpenOptionsMenuFrame()
	MapNotes_HideFrames();
	for i=0, 16, 1 do
		if (MapNotes_Options[i] ~= "off") then
			getglobal("MapNotesOptionsCheckbox"..i):SetChecked(1);
		else
			getglobal("MapNotesOptionsCheckbox"..i):SetChecked(0);
		end
	end
	MapNotesOptionsMenuFrame:Show();
end

function MapNotes_WriteOptions()
	for i=0, 16, 1 do
		if ( getglobal("MapNotesOptionsCheckbox"..i):GetChecked() ) then
			MapNotes_Options[i] = nil;
		else
			MapNotes_Options[i] = "off";
		end
	end
	MapNotesOptionsMenuFrame:Hide();
end

function MapNotes_SetAsMiniNote(id)
        local currentZone;
        local continent = GetCurrentMapContinent();
        local zone;


        if( continent == -1 ) then
           currentZone = MapNotes_Data[GetZoneText()];
	   zone = -1;
        else
           zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
           currentZone = MapNotes_Data[continent][zone];
        end
   
      	if(  not currentZone) then
           return;
        end


	MapNotes_MiniNote_Data.continent = continent;
	MapNotes_MiniNote_Data.zone = zone;
	MapNotes_MiniNote_Data.zonetext = GetZoneText();

	MapNotes_MiniNote_Data.id = id; -- able to show, because there wasn't a delete and its not received for showing on MiniMap only
	if (id == 0) then
		MapNotes_MiniNote_Data.xPos = MapNotes_tloc_xPos;
		MapNotes_MiniNote_Data.yPos = MapNotes_tloc_yPos;
		MapNotes_MiniNote_Data.name = MAPNOTES_THOTTBOTLOC;
		MapNotes_MiniNote_Data.color = 0;
		MapNotes_MiniNote_Data.icon = "tloc";
		MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
		MiniNotePOI:Show();
	elseif (id == -1) then
		MapNotes_MiniNote_Data.xPos = MapNotes_PartyNoteData.xPos;
		MapNotes_MiniNote_Data.yPos = MapNotes_PartyNoteData.yPos;
		MapNotes_MiniNote_Data.name = MAPNOTES_PARTYNOTE;
		MapNotes_MiniNote_Data.color = 0;
		MapNotes_MiniNote_Data.icon = "party";
		MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
		MiniNotePOI:Show();
	else
		MapNotes_MiniNote_Data.xPos = currentZone[id].xPos;
		MapNotes_MiniNote_Data.yPos = currentZone[id].yPos;
		MapNotes_MiniNote_Data.name = currentZone[id].name;
		MapNotes_MiniNote_Data.color = currentZone[id].ncol;
		MapNotes_MiniNote_Data.icon = currentZone[id].icon;
		MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
		MiniNotePOI:Show();
	end
end

function MapNotes_ClearMiniNote()
	MapNotes_MiniNote_Data.xPos = nil;
	MapNotes_MiniNote_Data.yPos = nil;
	MapNotes_MiniNote_Data.continent = nil;
	MapNotes_MiniNote_Data.zone = nil;
	MapNotes_MiniNote_Data.id = 0; -- nothing to show on the zone map
	MapNotes_MiniNote_Data.name = nil;
	MapNotes_MiniNote_Data.color = nil;
	MapNotes_MiniNote_Data.icon = nil;
	MiniNotePOI:Hide();
end

function MapNotes_ShowPOIFrame(ax, ay)
	if (MapNotes_BlockingFrame()) then
		MapNotesPOIMenuFrame:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", ax * WorldMapButton:GetWidth(), -(ay * WorldMapButton:GetHeight()));
		MapNotesNewMenuFrame:Hide();
		MapNotesPOIMenuFrame:Show();
	end
end

function MapNotes_WriteNote()
	MapNotes_HideFrames();

   local currentZone;
   local continent = GetCurrentMapContinent();
   local zone;

   if( continent == -1 ) then
      zone = GetZoneText();
      if( not MapNotes_Data[zone] ) then
         MapNotes_Data[zone] = { };
      end
      currentZone = MapNotes_Data[zone];
      zone = -1;
   else
      zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
      currentZone = MapNotes_Data[continent][zone];
   end


	currentZone[MapNotes_TempData_Id] = {};
	currentZone[MapNotes_TempData_Id].name = TitleWideEditBox:GetText();
	currentZone[MapNotes_TempData_Id].ncol = MapNotes_TempData_TextColor;
	currentZone[MapNotes_TempData_Id].inf1 = Info1WideEditBox:GetText();
	currentZone[MapNotes_TempData_Id].in1c = MapNotes_TempData_Info1Color;
	currentZone[MapNotes_TempData_Id].inf2 = Info2WideEditBox:GetText();
	currentZone[MapNotes_TempData_Id].in2c = MapNotes_TempData_Info2Color;
	currentZone[MapNotes_TempData_Id].creator = MapNotes_TempData_Creator;
	currentZone[MapNotes_TempData_Id].icon = MapNotes_TempData_Icon;
	currentZone[MapNotes_TempData_Id].xPos = MapNotes_TempData_xPos;
	currentZone[MapNotes_TempData_Id].yPos = MapNotes_TempData_yPos;

	if( continent == -1 ) then
   	   currentZone[MapNotes_TempData_Id].zname = GetZoneText();
	end

	if (continent == MapNotes_MiniNote_Data.continent and MapNotes_MiniNote_Data.zone == zone and MapNotes_MiniNote_Data.id == MapNotes_TempData_Id) then
		MapNotes_MiniNote_Data.name = TitleWideEditBox:GetText();
		MapNotes_MiniNote_Data.icon = MapNotes_TempData_Icon;
		MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
		MapNotes_MiniNote_Data.color = MapNotes_TempData_TextColor;
	end

end


function MapNotes_HideFrames()
	MapNotesNewMenuFrame:Hide();
	MapNotesPOIMenuFrame:Hide();
	MapNotesSpecialActionMenuFrame:Hide();
	MapNotesEditMenuFrame:Hide();
	MapNotesOptionsMenuFrame:Hide();
	MapNotesSendFrame:Hide();
	MapNotes_ClearGUI();
end

function MapNotes_BlockingFrame()
	if (MapNotesEditMenuFrame:IsVisible()) then
		return false;
	elseif (MapNotesOptionsMenuFrame:IsVisible()) then
		return false;
	elseif (MapNotesSendFrame:IsVisible()) then
		return false;
	else
		return true;
	end
end

function MapNotes_DeleteNote(id)
	if (id == 0) then
		MapNotes_tloc_xPos = nil;
		MapNotes_tloc_yPox = nil;
		return;
	elseif (id == -1) then
		MapNotes_PartyNoteData.xPos = nil;
		MapNotes_PartyNoteData.yPos = nil;
		MapNotes_PartyNoteData.continent = nil;
		MapNotes_PartyNoteData.zone = nil;
		return;
	end
	local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
	local continent = GetCurrentMapContinent();
	local lastEntry = MapNotes_NewNoteSlot() - 1;
	MapNotes_DeleteLines(continent, zone, MapNotes_Data[continent][zone][id].xPos, MapNotes_Data[continent][zone][id].yPos);
	if ((lastEntry ~= 0) and (id <= lastEntry)) then
		MapNotes_Data[continent][zone][id].name = MapNotes_Data[continent][zone][lastEntry].name;
		MapNotes_Data[continent][zone][lastEntry].name = nil;
		MapNotes_Data[continent][zone][id].ncol = MapNotes_Data[continent][zone][lastEntry].ncol;
		MapNotes_Data[continent][zone][lastEntry].ncol = nil;
		MapNotes_Data[continent][zone][id].inf1 = MapNotes_Data[continent][zone][lastEntry].inf1;
		MapNotes_Data[continent][zone][lastEntry].inf1 = nil;
		MapNotes_Data[continent][zone][id].in1c = MapNotes_Data[continent][zone][lastEntry].in1c;
		MapNotes_Data[continent][zone][lastEntry].in1c = nil;
		MapNotes_Data[continent][zone][id].inf2 = MapNotes_Data[continent][zone][lastEntry].inf2;
		MapNotes_Data[continent][zone][lastEntry].inf2 = nil;
		MapNotes_Data[continent][zone][id].in2c = MapNotes_Data[continent][zone][lastEntry].in2c;
		MapNotes_Data[continent][zone][lastEntry].in2c = nil;
		MapNotes_Data[continent][zone][id].creator = MapNotes_Data[continent][zone][lastEntry].creator;
		MapNotes_Data[continent][zone][lastEntry].creator = nil;
		MapNotes_Data[continent][zone][id].icon = MapNotes_Data[continent][zone][lastEntry].icon;
		MapNotes_Data[continent][zone][lastEntry].icon = nil;
		MapNotes_Data[continent][zone][id].xPos = MapNotes_Data[continent][zone][lastEntry].xPos;
		MapNotes_Data[continent][zone][lastEntry].xPos = nil;
		MapNotes_Data[continent][zone][id].yPos = MapNotes_Data[continent][zone][lastEntry].yPos;
		MapNotes_Data[continent][zone][lastEntry].yPos = nil;
		MapNotes_Data[continent][zone][lastEntry] = nil;
	end
	if (continent == MapNotes_MiniNote_Data.continent and zone == MapNotes_MiniNote_Data.zone) then
		if (MapNotes_MiniNote_Data.id > id) then
			MapNotes_MiniNote_Data.id = id - 1;
		elseif (MapNotes_MiniNote_Data.id == id) then
			MapNotes_MiniNote_Data.id = 0;
		end
	end
	WorldMapButton_OnUpdate();
end

function MapNotes_OnEnter(id)
	if ((not MapNotesPOIMenuFrame:IsVisible()) and (not MapNotesNewMenuFrame:IsVisible()) and MapNotes_BlockingFrame()) then
		local x, y = this:GetCenter();
		local x2, y2 = WorldMapButton:GetCenter();
		local anchor = "";
		if (x > x2) then anchor = "ANCHOR_LEFT"; else anchor = "ANCHOR_RIGHT"; end


                local currentZone;
                local continent = GetCurrentMapContinent();

                if( continent == -1 ) then
                   currentZone = MapNotes_Data[GetZoneText()];
                elseif( continent > 0 ) then
                   local zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
                  currentZone = MapNotes_Data[continent][zone];
                end
   
         	if(  not currentZone) then
             	   return;
          	end

--		--local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];


		local cNr = currentZone[id].ncol;
		WorldMapTooltip:SetOwner(this, anchor);
		WorldMapTooltip:SetText(currentZone[id].name, MapNotes_Colors[cNr].r, MapNotes_Colors[cNr].g, MapNotes_Colors[cNr].b);
		if ((currentZone[id].inf1 ~= nil) and (currentZone[id].inf1 ~= "")) then
			cNr = currentZone[id].in1c;
			WorldMapTooltip:AddLine(currentZone[id].inf1, MapNotes_Colors[cNr].r, MapNotes_Colors[cNr].g, MapNotes_Colors[cNr].b);
		end
		if ((currentZone[id].inf2 ~= nil) and (currentZone[id].inf2 ~= "")) then
			cNr = currentZone[id].in2c;
			WorldMapTooltip:AddLine(currentZone[id].inf2, MapNotes_Colors[cNr].r, MapNotes_Colors[cNr].g, MapNotes_Colors[cNr].b);
		end
		WorldMapTooltip:AddDoubleLine(MAPNOTES_CREATEDBY, currentZone[id].creator, 0.79, 0.69, 0.0, 0.79, 0.69, 0.0);
		WorldMapTooltip:Show();
	else
		WorldMapTooltip:Hide();
	end
end

function MapNotes_OnLeave(id)
	WorldMapTooltip:Hide();
end

function MapNotes_Note_OnClick(arg1, id)
	CloseDropDownMenus();

        local currentZone;
        local continent = GetCurrentMapContinent();
        local zone;

        if( continent == -1 ) then
           currentZone = MapNotes_Data[GetZoneText()];
	   zone = -1;
        else
           zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
           currentZone = MapNotes_Data[continent][zone];
        end
   
        if(  not currentZone) then
          return;
        end
	
	if ( MapNotes_LastLineClick.GUIactive ) then
		id = id + 0;

		local ax = currentZone[id].xPos;
		local ay = currentZone[id].yPos;
		if (MapNotes_LastLineClick.x ~= ax and MapNotes_LastLineClick.y ~= ay and MapNotes_LastLineClick.continent == continent and MapNotes_LastLineClick.zone == zone) then
			MapNotes_ToggleLine(continent, zone, ax, ay, MapNotes_LastLineClick.x, MapNotes_LastLineClick.y);
		end
		MapNotes_ClearGUI();
	elseif ( arg1 == "RightButton" ) then
		if (MapNotes_BlockingFrame()) then
			id = id + 0;
			MapNotes_TempData_Id = id;


			local ax = currentZone[id].xPos;
			local ay = currentZone[id].yPos;
			if (ax*1002 >= (1002 - 195)) then xOffset = -176; else xOffset = 0;	end
			if (ay*668 <= (668 - 156)) then yOffset = -75; else yOffset = 113; end
			MapNotesPOIMenuFrame:SetPoint("TOPLEFT", "WorldMapFrame", "TOPLEFT", ax * WorldMapButton:GetWidth() + xOffset, -(ay * WorldMapButton:GetHeight()) + yOffset);
			MapNotesNewMenuFrame:Hide();
			MapNotesSpecialActionMenuFrame:Hide();
			MapNotesButtonEditNote:Enable();
			MapNotesButtonSendNote:Enable();
			WorldMapTooltip:Hide();
			MapNotesPOIMenuFrame:Show();
		end
	elseif ( arg1 == "LeftButton" and IsAltKeyDown() ) then
		id = id + 0;
		local ax = currentZone[id].xPos;
		local ay = currentZone[zone][id].yPos;
		if (MapNotes_LastLineClick.x ~= ax and MapNotes_LastLineClick.y ~= ay and MapNotes_LastLineClick.continent == continent and MapNotes_LastLineClick.zone == zone and MapNotes_LastLineClick.time > GetTime() - 4) then
			MapNotes_ToggleLine(continent, zone, ax, ay, MapNotes_LastLineClick.x, MapNotes_LastLineClick.y);
		else
			MapNotes_LastLineClick.x = ax;
			MapNotes_LastLineClick.y = ay;
			MapNotes_LastLineClick.continent = continent;
			MapNotes_LastLineClick.zone = zone;
			MapNotes_LastLineClick.time = GetTime();
		end
	elseif ( arg1 == "LeftButton" ) then
		local ax = currentZone[id].xPos;
		local ay = currentZone[id].yPos;
		MapNotesButtonNewNote:Disable();
		WorldMapTooltip:Hide();
		MapNotes_ShowNewFrame(ax, ay);
	end
end

function MapNotes_StartGUIToggleLine()
	WorldMapMagnifyingGlassButton:SetText(ZOOM_OUT_BUTTON_TEXT.."\n"..MAPNOTES_CLICK_ON_SECOND_NOTE);
	MapNotes_LastLineClick.GUIactive = true;
	local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
	local continent = GetCurrentMapContinent();
	MapNotes_LastLineClick.x = MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos
	MapNotes_LastLineClick.y = MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos
	MapNotes_LastLineClick.zone = zone;
	MapNotes_LastLineClick.continent = continent;
end

function MapNotes_ClearGUI()
	WorldMapMagnifyingGlassButton:SetText(ZOOM_OUT_BUTTON_TEXT.."\n"..MAPNOTES_WORLDMAPHELP);
	MapNotes_LastLineClick.GUIactive = false;
end

function MapNotes_DrawLine(id, x1, y1, x2, y2)
	if (id > MAPNOTES_MAXLINES) then return; end
	if (x1 == nil or x2 == nil or y1 == nil or y2 == nil) then
		getglobal("MapNotesLines_"..id):SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight());
		return;
	end
	local deltax = abs((x1 - x2) * WorldMapDetailFrame:GetWidth());
	local deltay = abs((y1 - y2) * WorldMapDetailFrame:GetHeight());
	local lowerpixel = deltax;
	if ( deltay < deltax ) then lowerpixel = deltay; end
	lowerpixel = lowerpixel / MAPNOTES_LINETEMPLATESIZE;
	if (lowerpixel > 1) then lowerpixel = 1; end
	if (x2 - x1 < 0) then 
		if (y1 - y2 < 0) then
			getglobal("MapNotesLines_"..id):SetTexture("Interface\\AddOns\\MapNotes\\MiscGFX\\LineTemplateUp"..MAPNOTES_LINETEMPLATESIZE);
			getglobal("MapNotesLines_"..id):SetTexCoord(0, lowerpixel, 1-lowerpixel, 1);
			getglobal("MapNotesLines_"..id):SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", x1*WorldMapDetailFrame:GetWidth()-deltax, -(y1*WorldMapDetailFrame:GetHeight()));
		else
			getglobal("MapNotesLines_"..id):SetTexture("Interface\\AddOns\\MapNotes\\MiscGFX\\LineTemplateDown"..MAPNOTES_LINETEMPLATESIZE);
			getglobal("MapNotesLines_"..id):SetTexCoord(0, lowerpixel, 0, lowerpixel);
			getglobal("MapNotesLines_"..id):SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", x1*WorldMapDetailFrame:GetWidth()-deltax, -(y1*WorldMapDetailFrame:GetHeight()-deltay));
		end
	else
		if (y1 - y2 < 0) then
			getglobal("MapNotesLines_"..id):SetTexture("Interface\\AddOns\\MapNotes\\MiscGFX\\LineTemplateDown"..MAPNOTES_LINETEMPLATESIZE);
			getglobal("MapNotesLines_"..id):SetTexCoord(0, lowerpixel, 0, lowerpixel);
			getglobal("MapNotesLines_"..id):SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", x1*WorldMapDetailFrame:GetWidth(), -(y1*WorldMapDetailFrame:GetHeight()));
		else
			getglobal("MapNotesLines_"..id):SetTexture("Interface\\AddOns\\MapNotes\\MiscGFX\\LineTemplateUp"..MAPNOTES_LINETEMPLATESIZE);
			getglobal("MapNotesLines_"..id):SetTexCoord(0, lowerpixel, 1-lowerpixel, 1);
			getglobal("MapNotesLines_"..id):SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", x1*WorldMapDetailFrame:GetWidth(), -(y1*WorldMapDetailFrame:GetHeight()-deltay));
		end
	end
	getglobal("MapNotesLines_"..id):SetWidth(deltax);
	getglobal("MapNotesLines_"..id):SetHeight(deltay);
	getglobal("MapNotesLines_"..id):Show();
end

function MapNotes_DeleteLines(continent, zone, x, y)
	local linecount = 0;
	for i, value in MapNotes_Lines[continent][zone] do
		linecount = linecount + 1;
	end
	local offset = 0;
	for i = 1, linecount, 1 do
		if ((MapNotes_Lines[continent][zone][i-offset].x1 == x and MapNotes_Lines[continent][zone][i-offset].y1 == y) or (MapNotes_Lines[continent][zone][i-offset].x2 == x and MapNotes_Lines[continent][zone][i-offset].y2 == y)) then
			for j = i, linecount-1, 1 do
				MapNotes_Lines[continent][zone][j-offset].x1 = MapNotes_Lines[continent][zone][j+1-offset].x1;
				MapNotes_Lines[continent][zone][j-offset].x2 = MapNotes_Lines[continent][zone][j+1-offset].x2;
				MapNotes_Lines[continent][zone][j-offset].y1 = MapNotes_Lines[continent][zone][j+1-offset].y1;
				MapNotes_Lines[continent][zone][j-offset].y2 = MapNotes_Lines[continent][zone][j+1-offset].y2;
			end
			MapNotes_Lines[continent][zone][linecount-offset].x1 = nil;
			MapNotes_Lines[continent][zone][linecount-offset].x2 = nil;
			MapNotes_Lines[continent][zone][linecount-offset].y1 = nil;
			MapNotes_Lines[continent][zone][linecount-offset].y2 = nil;
			MapNotes_Lines[continent][zone][linecount-offset] = nil;
			offset = offset + 1;
		end
	end
	MapNotes_LastLineClick.zone = 0;
end

function MapNotes_ToggleLine(continent, zone, x1, y1, x2, y2)
	local newline = true;
	local linecount = 0;
	for i, value in MapNotes_Lines[continent][zone] do
		linecount = linecount + 1;
	end
	for i = 1, linecount, 1 do
		if (i <= linecount) then
			if ((MapNotes_Lines[continent][zone][i].x1 == x1 and MapNotes_Lines[continent][zone][i].y1 == y1 and MapNotes_Lines[continent][zone][i].x2 == x2 and MapNotes_Lines[continent][zone][i].y2 == y2) or (MapNotes_Lines[continent][zone][i].x1 == x2 and MapNotes_Lines[continent][zone][i].y1 == y2 and MapNotes_Lines[continent][zone][i].x2 == x1 and MapNotes_Lines[continent][zone][i].y2 == y1)) then
				for j = i, linecount-1, 1 do
					MapNotes_Lines[continent][zone][j].x1 = MapNotes_Lines[continent][zone][j+1].x1;
					MapNotes_Lines[continent][zone][j].x2 = MapNotes_Lines[continent][zone][j+1].x2;
					MapNotes_Lines[continent][zone][j].y1 = MapNotes_Lines[continent][zone][j+1].y1;
					MapNotes_Lines[continent][zone][j].y2 = MapNotes_Lines[continent][zone][j+1].y2;
				end
				MapNotes_Lines[continent][zone][linecount].x1 = nil;
				MapNotes_Lines[continent][zone][linecount].x2 = nil;
				MapNotes_Lines[continent][zone][linecount].y1 = nil;
				MapNotes_Lines[continent][zone][linecount].y2 = nil;
				MapNotes_Lines[continent][zone][linecount] = nil;
				newline = false;
				linecount = linecount - 1;
			end
		end
	end
	if (newline and linecount < MAPNOTES_MAXLINES) then
		MapNotes_Lines[continent][zone][linecount+1] = {};
		MapNotes_Lines[continent][zone][linecount+1].x1 = x1;
		MapNotes_Lines[continent][zone][linecount+1].x2 = x2;
		MapNotes_Lines[continent][zone][linecount+1].y1 = y1;
		MapNotes_Lines[continent][zone][linecount+1].y2 = y2;
	end
	MapNotes_LastLineClick.zone = 0;
end

function MapNotes_OpenEditForNewNote()
	if (MapNotes_NewNoteSlot() < MapNotes_NotesPerZone + 1) then
		if (MapNotes_TempData_Id == 0) then
			MapNotes_tloc_xPos = nil;
			MapNotes_tloc_yPos = nil;
		end
		MapNotes_TempData_Id = MapNotes_NewNoteSlot();
		MapNotes_TempData_Creator = UnitName("player");
		MapNotes_Edit_SetIcon(0);
		MapNotes_Edit_SetTextColor(0);
		MapNotes_Edit_SetInfo1Color(0);
		MapNotes_Edit_SetInfo2Color(0);
		TitleWideEditBox:SetText("");
		Info1WideEditBox:SetText("");
		Info2WideEditBox:SetText("");
		MapNotes_HideFrames();
		MapNotesEditMenuFrame:Show();
	else
		MapNotes_HideFrames();
	end
end

function MapNotes_NewNoteSlot()
   local currentZone;
   local continent = GetCurrentMapContinent();

   if( continent == -1 ) then
      currentZone = MapNotes_Data[GetZoneText()];
   else
      local zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
      currentZone = MapNotes_Data[continent][zone];
   end

   if( not currentZone ) then
      return 1;
   end

	local i = 0;
	for j, value in currentZone do
		i = i + 1;
	end
	return (i + 1);
end

function MapNotes_SetPartyNote(xPos, yPos)
	xPos = floor(xPos * 1000000) / 1000000;
	yPos = floor(yPos * 1000000) / 1000000;
	local continent = GetCurrentMapContinent();
	local zone = MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()];
	MapNotes_PartyNoteData.continent = continent;
	MapNotes_PartyNoteData.zone = zone;
	MapNotes_PartyNoteData.xPos = xPos;
	MapNotes_PartyNoteData.yPos = yPos;

	if (Sky) then
		Sky.sendAlert("<MapN> c<"..continent.."> z<"..zone.."> x<"..xPos.."> y<"..yPos.."> p<1>", SKY_PARTY, "MN");
	end

	if (MapNotes_MiniNote_Data.icon == "party" or MapNotes_Options[16] ~= "off") then
		MapNotes_MiniNote_Data.id = -1;
		MapNotes_MiniNote_Data.continent = continent;
		MapNotes_MiniNote_Data.zone = zone;
		MapNotes_MiniNote_Data.xPos = xPos;
		MapNotes_MiniNote_Data.yPos = yPos;
		MapNotes_MiniNote_Data.name = MAPNOTES_PARTYNOTE;
		MapNotes_MiniNote_Data.color = 0;
		MapNotes_MiniNote_Data.icon = "party";
		MiniNotePOITexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon);
		MiniNotePOI:Show();
	end
end

-- changed functions from WorldMapFrame.lua & MinimapFrame.lua
function MapNotes_Minimap_OnClick() -- function changed to be able to ping through the MiniNote (mostly direct copy) (only change: this -> Minimap)
	local x, y = GetCursorPosition();
	x = x / Minimap:GetScale();
	y = y / Minimap:GetScale();

	local cx, cy = Minimap:GetCenter();
	x = x + CURSOR_OFFSET_X - cx;
	y = y + CURSOR_OFFSET_Y - cy;
	if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
		Minimap:PingLocation(x, y);
	end
end

function MapNotes_ZoomOutButton_OnClick()
	MapNotes_HideFrames();
end

function MapNotes_WorldMapButton_OnClick(mouseButton, button)
	CloseDropDownMenus();
        local callOriginal = false;
  
	if ( mouseButton == "LeftButton" ) then
		if ( not button ) then
			button = this;
		end
		local x, y = GetCursorPosition();
		x = x / button:GetScale();
		y = y / button:GetScale();
 
		local centerX, centerY = button:GetCenter();
		local width = button:GetWidth();
		local height = button:GetHeight();
		local adjustedY = (centerY + (height/2) - y) / height;
		local adjustedX = (x - (centerX - (width/2))) / width;
                local continent = GetCurrentMapContinent();
		local zone      = GetCurrentMapZone();

                if( continent == -1 ) then
  		   MapNotesButtonNewNote:Enable();
		   MapNotes_ShowNewFrame(adjustedX, adjustedY);
		   return true;
		end

		local oldzone = MapNotes_ZoneShift[continent][zone];

		if (MapNotes_BlockingFrame()) then



			if( (continent == 2 and zone == 12) or        -- Ironforge
			    (continent == 2 and zone == 22) or        -- Undercity
			    (continent == 1 and zone == 19) ) then    -- Thunder Bluff
                               callOriginal = false; 
			else
			   callOriginal = true;
			end

			-- Dirty hack to fix capital cities, by Oystein
			--if( not isCapital ) then
                        --   ProcessMapClick(adjustedX, adjustedY); 
			--end
		end

		if (MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()] ~= 0 and 
		      oldzone == MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()] and 
		      IsShiftKeyDown()) then
			MapNotes_SetPartyNote(adjustedX, adjustedY);
		elseif (MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()] ~= 0 and 
		  oldzone == MapNotes_ZoneShift[GetCurrentMapContinent()][GetCurrentMapZone()] and 
		  GetTime() < MapNotes_LastClick.time + 0.5 and 
		  abs(MapNotes_LastClick.yPos - adjustedY) < 0.01 and 
		  abs(MapNotes_LastClick.xPos - adjustedX) < 0.005) then		        
			MapNotesButtonNewNote:Enable();
			MapNotes_ShowNewFrame(adjustedX, adjustedY);
			callOriginal = false;
		else
			MapNotes_HideFrames();
		end
		MapNotes_LastClick.time = GetTime();
		MapNotes_LastClick.xPos = adjustedX;
		MapNotes_LastClick.yPos = adjustedY;
-- Map Notes End Insert [ 3/ 5]
	else

		WorldMapZoomOutButton_OnClick();
	end

	return callOriginal;
	--return false;

end



-- Removed updating of player positions, corpse, map highlights, etc... letting WoW take care of that.
-- (Oystein)

function MapNotes_WorldMapButton_OnUpdate()
   local currentZone;
   local continent = GetCurrentMapContinent();

   if( continent == -1 ) then
      currentZone = MapNotes_Data[GetZoneText()];
   elseif( continent > 0 ) then
      local zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
      currentZone = MapNotes_Data[continent][zone];
   end

	if (currentZone and continent ~= 0 and MapNotes_Options.shownotes) then
		local n = 1;
		for i, value in currentZone do
			local temp = getglobal("MapNotesPOI"..i);
				temp:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", (currentZone[i].xPos)*WorldMapButton:GetWidth(), -(currentZone[i].yPos)*WorldMapButton:GetHeight());
				getglobal("MapNotesPOI"..i.."Texture"):SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..currentZone[i].icon);
				if ( MapNotes_Options[currentZone[i].icon] ~= "off" and ((MapNotes_Options[10] ~= "off" and currentZone[i].creator == UnitName("player")) or (MapNotes_Options[11] ~= "off" and currentZone[i].creator ~= UnitName("player")))) then
					temp:Show();
				else
					temp:Hide();
				end
			n = n + 1;
		end
		local lastnote = n - 1;
		if (MapNotes_Options[12] ~= "off" and lastnote ~= 0) then
			if (getglobal("MapNotesPOI"..lastnote):IsVisible()) then
				getglobal("MapNotesPOI"..lastnote.."Texture"):SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..currentZone[lastnote].icon.."red");
			end
		end
		if (MapNotes_Options[13] ~= "off" and MapNotes_MiniNote_Data.continent == continent and MapNotes_MiniNote_Data.zone == zone and MapNotes_MiniNote_Data.id > 0) then
			getglobal("MapNotesPOI"..MapNotes_MiniNote_Data.id.."Texture"):SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Icon"..MapNotes_MiniNote_Data.icon.."blue");
		end
		for i=n, MapNotes_NotesPerZone, 1 do
			getglobal("MapNotesPOI"..i):Hide();
		end

		-- lines
		local currentLineZone;
               if( continent == -1 ) then
                  currentLineZone = MapNotes_Lines[GetZoneText()];
               else
                  local zone = MapNotes_ZoneShift[continent][GetCurrentMapZone()];
                  currentLineZone = MapNotes_Lines[continent][zone];
               end

                if( currentLineZone ) then
   		  local n = 1;
		   for i, value in currentLineZone do
		  	   MapNotes_DrawLine(n, currentLineZone[n].x1, currentLineZone[n].y1, currentLineZone[n].x2, currentLineZone[n].y2);
			   n = n + 1;
		   end
		   for i = n, MAPNOTES_MAXLINES, 1 do
			   MapNotes_DrawLine(i, nil, nil, nil, nil);
		   end
		end
	else
		for i=1, MapNotes_NotesPerZone, 1 do
			getglobal("MapNotesPOI"..i):Hide();
		end
		for i = 1, MAPNOTES_MAXLINES, 1 do
			MapNotes_DrawLine(i, nil, nil, nil, nil, false);
		end
	end

        if( not currentZone ) then
          return;
        end

	-- tloc button...
	if (MapNotes_tloc_xPos ~= nil and zone ~= 0) then
		MapNotesPOItloc:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", MapNotes_tloc_xPos*WorldMapButton:GetWidth(), -MapNotes_tloc_yPos*WorldMapButton:GetHeight());
		MapNotesPOItloc:Show();
	else
		MapNotesPOItloc:Hide();
	end



	-- party note...
	if (MapNotes_PartyNoteData.xPos ~= nil and zone == MapNotes_PartyNoteData.zone and continent == MapNotes_PartyNoteData.continent) then
		if (MapNotes_Options[13] ~= "off" and MapNotes_MiniNote_Data.icon == "party") then
			MapNotesPOIpartyTexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Iconpartyblue");
		else
			MapNotesPOIpartyTexture:SetTexture("Interface\\AddOns\\MapNotes\\POIIcons\\Iconparty");
		end
		MapNotesPOIparty:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", MapNotes_PartyNoteData.xPos*WorldMapButton:GetWidth(), -MapNotes_PartyNoteData.yPos*WorldMapButton:GetHeight());
		MapNotesPOIparty:Show();
	else
		MapNotesPOIparty:Hide();
	end
-- Map Notes End Insert [ 7/ 8]
end



function MapNotes_OnToggleWorldMap()
	MapNotes_HideFrames();

end