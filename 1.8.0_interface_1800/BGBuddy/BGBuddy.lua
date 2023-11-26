BGBUDDY_TITLE = "BGBuddy";
BGBUDDY_VERSION = "v1.55";
local sessionhonor=0;
local lastkill=0;
local estimatedhonor=0;
local estimatedlastkill=0;
local playerlist = {};

function BGBuddy_OnLoad()
	this:RegisterForDrag("LeftButton");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_WORLD_STATES");
	this:RegisterEvent("BATTLEFIELDS_SHOW");
	this:RegisterEvent("BATTLEFIELDS_CLOSED");
	this:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	this:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	this:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	this:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	this:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	this:RegisterEvent("PLAYER_DEAD");
end

function BGBuddy_OnEvent()
	if ( event == "VARIABLES_LOADED" ) then

		if(myAddOnsFrame) then
			myAddOnsList.BGBuddy = {name = 'BGBuddy', description = 'A battleground aid with many helpful features.', version = BGBUDDY_VERSION, category = MYADDONS_CATEGORY_OTHERS, frame = 'BGBuddy_StandardFrame', optionsframe = 'BGBuddy_ConfigPanel'};
		end

		SLASH_BGBuddy1 = "/bgbuddy";
		SLASH_BGBuddy2 = "/bgb";
		SlashCmdList["BGBuddy"] = BGBuddy_HandleSlashes;

		if (BGBuddy_SavedVars == nil) then
			BGBuddy_SavedVars = { };
		end	
		if (BGBuddy_SavedVars["isEnabled"] == nil) then
			BGBuddy_SavedVars["isEnabled"] = 1;
		end
		if (BGBuddy_SavedVars["isLocked"] == nil) then
			BGBuddy_SavedVars["isLocked"] = 0;
		end
		if (BGBuddy_SavedVars["isAlwaysVisible"] == nil) then
			BGBuddy_SavedVars["isAlwaysVisible"] = 0;
		end
		if (BGBuddy_SavedVars["playSound"] == nil) then
			BGBuddy_SavedVars["playSound"] = 1;
		end
		if (BGBuddy_SavedVars["backgroundAlpha"] == nil) then
			BGBuddy_SavedVars["backgroundAlpha"] = 100;
		end
		if (BGBuddy_SavedVars["borderAlpha"] == nil) then
			BGBuddy_SavedVars["borderAlpha"] = 100;
		end
		if (BGBuddy_SavedVars["hideBGIcon"] == nil) then
			BGBuddy_SavedVars["hideBGIcon"] = 0;
		end
		if (BGBuddy_SavedVars["AutoJoin"] == nil) then
			BGBuddy_SavedVars["AutoJoin"] = 1;
		end
		if (BGBuddy_SavedVars["AutoRes"] == nil) then
			BGBuddy_SavedVars["AutoRes"] = 1;
		end
		if (BGBuddy_SavedVars["AutoRelease"] == nil) then
			BGBuddy_SavedVars["AutoRelease"] = 1;
		end
		if (BGBuddy_SavedVars["displayRank"] == nil) then
			BGBuddy_SavedVars["displayRank"] = 1;
		end
		if (BGBuddy_SavedVars["hideDisplay"] == nil) then
			BGBuddy_SavedVars["hideDisplay"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine1"] == nil) then
			BGBuddy_SavedVars["customizeLine1"] = 1;
		end
		if (BGBuddy_SavedVars["customizeLine2"] == nil) then
			BGBuddy_SavedVars["customizeLine2"] = 1;
		end
		if (BGBuddy_SavedVars["customizeLine3"] == nil) then
			BGBuddy_SavedVars["customizeLine3"] = 1;
		end
		if (BGBuddy_SavedVars["customizeLine4"] == nil) then
			BGBuddy_SavedVars["customizeLine4"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine5"] == nil) then
			BGBuddy_SavedVars["customizeLine5"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine6"] == nil) then
			BGBuddy_SavedVars["customizeLine6"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine1ws"] == nil) then
			BGBuddy_SavedVars["customizeLine1ws"] = 1;
		end
		if (BGBuddy_SavedVars["customizeLine2ws"] == nil) then
			BGBuddy_SavedVars["customizeLine2ws"] = 1;
		end
		if (BGBuddy_SavedVars["customizeLine3ws"] == nil) then
			BGBuddy_SavedVars["customizeLine3ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine4ws"] == nil) then
			BGBuddy_SavedVars["customizeLine4ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine5ws"] == nil) then
			BGBuddy_SavedVars["customizeLine5ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeLine6ws"] == nil) then
			BGBuddy_SavedVars["customizeLine6ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeText1"] == nil) then
			BGBuddy_SavedVars["customizeText1"] = "#: ~S K: ~K KB: ~KB D: ~D";
		end
		if (BGBuddy_SavedVars["customizeText2"] == nil) then
			BGBuddy_SavedVars["customizeText2"] = "GYA: ~GYA GYD: ~GYD TA: ~TA TD: ~TD";
		end
		if (BGBuddy_SavedVars["customizeText3"] == nil) then
			BGBuddy_SavedVars["customizeText3"] = "Honor: ~SH Last Kill: ~LKH";
		end
		if (BGBuddy_SavedVars["customizeText4"] == nil) then
			BGBuddy_SavedVars["customizeText4"] = "MC: ~MC LDK: ~LDK SO: ~SO";
		end
		if (BGBuddy_SavedVars["customizeText5"] == nil) then
			BGBuddy_SavedVars["customizeText5"] = "Lifetime Kills: ~LK";
		end
		if (BGBuddy_SavedVars["customizeText6"] == nil) then
			BGBuddy_SavedVars["customizeText6"] = 0;
		end
		if (BGBuddy_SavedVars["customizeText1ws"] == nil) then
			BGBuddy_SavedVars["customizeText1ws"] = "#: ~S K: ~K KB: ~KB D: ~D";
		end
		if (BGBuddy_SavedVars["customizeText2ws"] == nil) then
			BGBuddy_SavedVars["customizeText2ws"] = "Honor: ~SH Last Kill: ~LKH";
		end
		if (BGBuddy_SavedVars["customizeText3ws"] == nil) then
			BGBuddy_SavedVars["customizeText3ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeText4ws"] == nil) then
			BGBuddy_SavedVars["customizeText4ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeText5ws"] == nil) then
			BGBuddy_SavedVars["customizeText5ws"] = 0;
		end
		if (BGBuddy_SavedVars["customizeText6ws"] == nil) then
			BGBuddy_SavedVars["customizeText6ws"] = 0;
		end

		BGBuddy_SavedVars["version"] = BGBUDDY_VERSION;
		return;
	end

	if ( BGBuddy_SavedVars["isEnabled"] == 0 ) then return end

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		RequestBattlefieldScoreData();
		BGBuddy_Initialize();
	end
	if ( event == "UPDATE_BATTLEFIELD_SCORE" ) then
		RequestBattlefieldScoreData();
	end
	
	if ( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		RequestBattlefieldScoreData();
	end
	if ( event == "AREA_SPIRIT_HEALER_IN_RANGE" ) then
		BGBuddy_AutoRes();
	end
	if ( event == "PLAYER_DEAD" ) then
		BGBuddy_AutoRelease();
	end
	if ( event == "PLAYER_PVP_KILLS_CHANGED" ) then
		RequestBattlefieldScoreData();
	end
	if ( event == "CHAT_MSG_COMBAT_HONOR_GAIN" ) then
		local s, e;
		local results = {};
		s, e, results[0], results[1], results[2] = string.find(arg1, "^(.+) ([^:]+:[^:]+): (%d+)"); 
		local honor = results[2];

		if ( honor == nil ) then
			return;
		else
			sessionhonor = sessionhonor + honor;
			lastkill = honor;
		end

		if ( not playerlist[results[0]] ) then
			playerlist[results[0]] = 1;
			estimatedhonor = estimatedhonor + results[2];
			estimatedlastkill = results[2];
		else
			if ( playerlist[results[0]] <= 4 ) then
				playerlist[results[0]] = playerlist[results[0]] + 1;
				if (playerlist[results[0]] == 2) then
					estimatedlastkill = results[2] * (0.75);
					estimatedhonor = estimatedhonor + estimatedlastkill;
				elseif (playerlist[results[0]] == 3) then
					estimatedlastkill = results[2] * (0.50);
					estimatedhonor = estimatedhonor + estimatedlastkill;
				elseif (playerlist[results[0]] == 4) then
					estimatedlastkill = results[2] * (0.25);
					estimatedhonor = estimatedhonor + estimatedlastkill;
				else
					estimatedlastkill = 0;
					estimatedhonor = estimatedhonor + estimatedlastkill;
				end
			end
		end
	end
end

function BGBuddy_OnUpdate()
	if ( BGBuddy_SavedVars["isEnabled"] == 1 ) then 
		BGBuddy_UpdateDisplay();
		if ( UnitIsDeadOrGhost("player") ) then
			BGBuddy_AutoRes();
			BGBuddy_AutoRelease();
		end
	else
		BGBuddy_StandardFrame:Hide();
	end
end

function BGBuddy_DropDown_OnLoad()
	UIDropDownMenu_Initialize(this, BGBuddy_DropDown_Initialize, "MENU");
end

function BGBuddy_DropDown_Initialize()
	local status, _, _ = GetBattlefieldStatus();
	local info;
	if ( status == "queued" ) then
		info = {};
		info.text = "Change Instance";
		info.func = ShowBattlefieldList;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
		info = {};
		info.text = "Leave Queue";
		info.func = AcceptBattlefieldPort;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
	elseif ( status == "confirm" ) then
		info = {};
		info.text = "Enter Battle";
		info.func = BattlefieldFrame_EnterBattlefield;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
		info = {};
		info.text = "Leave Queue";
		info.func = AcceptBattlefieldPort;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
	end
end

function BGBuddy_OnEnter()
	local status, _, _ = GetBattlefieldStatus();

	GameTooltip_SetDefaultAnchor(GameTooltip, this);
	GameTooltip:SetText(BGBUDDY_TITLE.." "..BGBUDDY_VERSION, 255/255, 209/255, 0/255);
	GameTooltip:AddLine("Left-click to move, Right-click to configure", 1.00, 1.00, 1.00);	
	GameTooltip:Show();

end

function BGBuddy_OnEnterScoreFrame()
	if ( BGBuddy_StandardFrame.status == "queued" or BGBuddy_StandardFrame.status == "confirm" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
		GameTooltip:SetText("Click for options.", 1, 1, 1);
		GameTooltip:Show();
	elseif ( BGBuddy_StandardFrame.status == "active" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, this);
		GameTooltip:SetText("You are in "..BGBuddy_StandardFrame.mapName.." "..BGBuddy_StandardFrame.instanceID, 255/255, 209/255, 0/255);
		GameTooltip:AddLine("Click to display scores.", 1.00, 1.00, 1.00);	
		GameTooltip:Show();
	end	
end

function BGBuddy_Initialize()
	if ( BGBuddy_SavedVars["customizeLine1"] == 1 ) then
		line1checked = 1;
	else
		line1checked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine2"] == 1 ) then
		line2checked = 1;
	else
		line2checked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine3"] == 1 ) then
		line3checked = 1;
	else
		line3checked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine4"] == 1 ) then
		line4checked = 1;
	else
		line4checked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine5"] == 1 ) then
		line5checked = 1;
	else
		line5checked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine6"] == 1 ) then
		line6checked = 1;
	else
		line6checked = 0;
	end

	if ( BGBuddy_SavedVars["customizeLine1ws"] == 1 ) then
		line1wschecked = 1;
	else
		line1wschecked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine2ws"] == 1 ) then
		line2wschecked = 1;
	else
		line2wschecked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine3ws"] == 1 ) then
		line3wschecked = 1;
	else
		line3wschecked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine4ws"] == 1 ) then
		line4wschecked = 1;
	else
		line4wschecked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine5ws"] == 1 ) then
		line5wschecked = 1;
	else
		line5wschecked = 0;
	end
	if ( BGBuddy_SavedVars["customizeLine6ws"] == 1 ) then
		line6wschecked = 1;
	else
		line6wschecked = 0;
	end
	BGBuddy_SetRankInfo(GetPVPRankInfo(UnitPVPRank("player")));
	BGBuddy_UpdateDisplay();
	BGBuddy_Config_SetAlpha();

	if ( BGBuddy_SavedVars["displayRank"] == 1 ) then
		BGBuddy_RankFrame:Show();
	else
		BGBuddy_RankFrame:Hide();
	end
	if ( BGBuddy_SavedVars["hideDisplay"] == 1 ) then
		BGBuddy_StandardFrame:Hide();
	else
		BGBuddy_StandardFrame:Show();
	end
end

function BGBuddy_HandleSlashes(arg1)
	--arg1 = string.lower(arg1);
	ShowUIPanel(BGBuddy_ConfigPanel);
end

function BGBuddy_SetRankInfo(rankName, rankNumber)
	if ( rankNumber < 1 ) then
		BGBuddy_RankName:SetText("Unranked");
		BGBuddy_RankFrameIcon:Hide();
	else
		BGBuddy_RankName:SetText(rankName);
		BGBuddy_RankFrameIcon:SetTexture(format("%s%02d","Interface\\PvPRankBadges\\PvPRank", rankNumber));
	end
end

function BGBuddy_UpdateDisplay()
	--RequestBattlefieldScoreData();

	local playerName = UnitName("player");
	local status, mapName, instanceID = GetBattlefieldStatus();

	line1 = BGBuddy_SavedVars["customizeText1"];
	line2 = BGBuddy_SavedVars["customizeText2"];
	line3 = BGBuddy_SavedVars["customizeText3"];
	line4 = BGBuddy_SavedVars["customizeText4"];
	line5 = BGBuddy_SavedVars["customizeText5"];
	line6 = BGBuddy_SavedVars["customizeText6"];

	line1ws = BGBuddy_SavedVars["customizeText1ws"];
	line2ws = BGBuddy_SavedVars["customizeText2ws"];
	line3ws = BGBuddy_SavedVars["customizeText3ws"];
	line4ws = BGBuddy_SavedVars["customizeText4ws"];
	line5ws = BGBuddy_SavedVars["customizeText5ws"];
	line6ws = BGBuddy_SavedVars["customizeText6ws"];

	line1show = 0;
	line2show = 0;
	
	BGName = 0;
	BGBuddy_StandardFrame.status = status;
	BGBuddy_StandardFrame.mapName = mapName;
	BGBuddy_StandardFrame.instanceID = instanceID;

	if ( instanceID ~= 0 ) then
		mapName = mapName.." "..instanceID;
	else
		mapName = "First Available";
	end

	if ( status == "none" ) then
		local soundplayed=0;
		line1 = GRAY_FONT_COLOR_CODE.."You are not in the queue."..FONT_COLOR_CODE_CLOSE;
		line1show = 1;
		if ( BGBuddy_SavedVars["isAlwaysVisible"] == 0 ) then
			BGBuddy_StandardFrame:Hide();
		else
			if ( BGBuddy_SavedVars["hideDisplay"] == 0 ) then
				BGBuddy_StandardFrame:Show();
			end
		end
		BGBuddy_EnterFrame:Hide();
		BGBuddy_LeaveFrame:Hide();
		BGBuddy_SwitchFrame:Hide();
		BGBuddy_ScoreFrame:Hide();
	elseif ( status == "queued" ) then
		soundplayed=0;
		line1show=1;
		line2show=1;
		local waitTime = GetBattlefieldEstimatedWaitTime();
		local timeInQueue = GetBattlefieldTimeWaited()/1000;
		timeInQueue = SecondsToTime(timeInQueue);

		if ( waitTime == 0 ) then
			waitTime = UNAVAILABLE;
		elseif ( waitTime < 60000 ) then
			waitTime = LESS_THAN_ONE_MINUTE;
		else
			waitTime = SecondsToTime(waitTime/1000, 1);
		end

		line1 = NORMAL_FONT_COLOR_CODE.."In Queue: "..FONT_COLOR_CODE_CLOSE..GREEN_FONT_COLOR_CODE..mapName..FONT_COLOR_CODE_CLOSE;
		line2 = HIGHLIGHT_FONT_COLOR_CODE..waitTime.." ( "..GRAY_FONT_COLOR_CODE..timeInQueue..FONT_COLOR_CODE_CLOSE..")"..FONT_COLOR_CODE_CLOSE;

		if ( BGBuddy_SavedVars["hideBGIcon"] == 1 ) then
			MiniMapBattlefieldFrame:Hide();
		else
			MiniMapBattlefieldFrame:Show();
		end
		BGBuddy_EnterFrame:Hide();
		BGBuddy_LeaveFrame:Hide();
		BGBuddy_SwitchFrame:Hide();
		if ( BGBuddy_SavedVars["hideDisplay"] == 0 ) then
			BGBuddy_StandardFrame:Show();
			BGBuddy_ScoreFrame:Show();
		end
	elseif ( status == "confirm" ) then
		if ( BGBuddy_SavedVars["playSound"] == 1 and soundplayed == 0) then
			PlaySoundFile("Interface\\AddOns\\BGBuddy\\BGBuddy_BattlegroundReady.wav");
			soundplayed = 1;
		end
		line1show=1;
		line2show=1;
		line1 = GREEN_FONT_COLOR_CODE..mapName..FONT_COLOR_CODE_CLOSE..HIGHLIGHT_FONT_COLOR_CODE.." is ready!"..FONT_COLOR_CODE_CLOSE;
		line2 = NORMAL_FONT_COLOR_CODE.."Expires In: "..FONT_COLOR_CODE_CLOSE..RED_FONT_COLOR_CODE..SecondsToTime(GetBattlefieldPortExpiration()/1000)..FONT_COLOR_CODE_CLOSE;
	
		BGBuddy_AutoJoin();
		StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY");
		if ( BGBuddy_SavedVars["hideBGIcon"] == 1 ) then
			MiniMapBattlefieldFrame:Hide();
		else
			MiniMapBattlefieldFrame:Show();
		end
		
		BGBuddy_LeaveFrame:Hide();
		BGBuddy_SwitchFrame:Hide();
		
		if ( BGBuddy_SavedVars["hideDisplay"] == 0 ) then
			BGBuddy_StandardFrame:Show();
			BGBuddy_EnterFrame:Show();
			BGBuddy_ScoreFrame:Show();
		end
	elseif ( status == "active" ) then
		local numScores = GetNumBattlefieldScores();
		local name, kills, killingblows, deaths, honorgained, faction, rank, race, class;
		local totalplayers = 0;
		local playerstanding = 0;
		local playerkills = 0;
		local playerkillingblows = 0;
		local playerdeaths = 0;
		local playerhonorgained = 0;
		local playerfaction = 0;
		local playerrank = 0;
		local playerrace = 0;
		local playerclass = 0;

		for i=1, 80 do
			name, killingblows, kills, deaths, honorgained, faction, rank, race, class = GetBattlefieldScore(i);
			if ( class ~= nil ) then
				totalplayers = totalplayers + 1;
			else
				break;
			end
			if ( name == playerName ) then
				playerstanding = i;
				playername = name;
				playerkills = kills;
				playerdeaths = deaths;
				playerkillingblows = killingblows;
				playerhonorgained = honorgained;
				playerfaction = faction;
				playerrank = rank;
				playerrace = race;
				playerclass = class;
				playerlifetimekills,_,_ = GetPVPLifetimeStats();
			end
		end

		local numStatColumns = GetNumBattlefieldStats();
		for j=1, MAX_NUM_STAT_COLUMNS do
			if ( j <= numStatColumns ) then
				columnData = GetBattlefieldStatData(playerstanding, j);
				if (j==1) then 
					playergraveyardsassaulted = columnData; 
				end
				if (j==2) then 
					playergraveyardsdefended = columnData; 
				end
				if (j==3) then 
					playertowersassaulted = columnData; 
				end
				if (j==4) then 
					playertowersdefended = columnData; 
				end
				if (j==5) then 
					playerminescaptured = columnData; 
				end
				if (j==6) then 
					playerleaderskilled = columnData; 
				end
				if (j==7) then 
					playersecondaryobjectives = columnData; 
				end				
			end
		end
		
		if (playerlifetimekills == nil) then
			playerlifetimekills = "N/A";
		end
		if (playergraveyardsassaulted == nil) then
			playergraveyardsassaulted = "N/A";
			BGName = "Warsong Gulch";
		else
			BGName = "Alterac Valley";
		end
		if (playergraveyardsdefended == nil) then
			playergraveyardsdefended = "N/A";
		end
		if (playertowersassaulted == nil) then
			playertowersassaulted = "N/A";
		end
		if (playertowersdefended == nil) then
			playertowersdefended = "N/A";
		end
		if (playerminescaptured == nil) then
			playerminescaptured = "N/A";
		end
		if (playerleaderskilled == nil) then
			playerleaderskilled = "N/A";
		end
		if (playersecondaryobjectives == nil) then
			playersecondaryobjectives = "N/A";
		end

		if (playername == nil) then
			playername = "N/A";
		end
		if (playerkills == nil) then
			playerkills = "N/A";
		end
		if (playerdeaths == nil) then
			playerdeaths = "N/A";
		end
		if (playerkillingblows == nil) then
			playerkillingblows = "N/A";
		end
		if (playerhonorgained == nil) then
			playerhonorgained = "N/A";
		end
		if (playerfaction == nil) then
			playerfaction = "N/A";
		end
		if (playerrank == nil) then
			playerrank = "N/A";
		end
		if (playerrace == nil) then
			playerrace = "N/A";
		end
		if (playerclass == nil) then
			playerclass = "N/A";
		end
		if (playerlifetimekills == nil) then
			playerlifetimekills = "N/A";
		end

		sSub   = HIGHLIGHT_FONT_COLOR_CODE..playerstanding.."/"..totalplayers..NORMAL_FONT_COLOR_CODE;
		kSub   = GRAY_FONT_COLOR_CODE..playerkills..NORMAL_FONT_COLOR_CODE;
		kbSub  = GREEN_FONT_COLOR_CODE..playerkillingblows..NORMAL_FONT_COLOR_CODE;
		lkSub  = HIGHLIGHT_FONT_COLOR_CODE..playerlifetimekills..NORMAL_FONT_COLOR_CODE;
		dSub   = RED_FONT_COLOR_CODE..playerdeaths..NORMAL_FONT_COLOR_CODE;
		shSub  = HIGHLIGHT_FONT_COLOR_CODE..floor(estimatedhonor).."/"..sessionhonor..NORMAL_FONT_COLOR_CODE;
		lkhSub = HIGHLIGHT_FONT_COLOR_CODE..floor(estimatedlastkill).."/"..lastkill..NORMAL_FONT_COLOR_CODE;
		bhSub  = HIGHLIGHT_FONT_COLOR_CODE..playerhonorgained..NORMAL_FONT_COLOR_CODE;
		gyaSub = RED_FONT_COLOR_CODE..playergraveyardsassaulted..NORMAL_FONT_COLOR_CODE;
		gydSub = GREEN_FONT_COLOR_CODE..playergraveyardsdefended..NORMAL_FONT_COLOR_CODE;
		taSub  = RED_FONT_COLOR_CODE..playertowersassaulted..NORMAL_FONT_COLOR_CODE;
		tdSub  = GREEN_FONT_COLOR_CODE..playertowersdefended..NORMAL_FONT_COLOR_CODE;
		mcSub  = HIGHLIGHT_FONT_COLOR_CODE..playerminescaptured..NORMAL_FONT_COLOR_CODE;
		ldkSub = HIGHLIGHT_FONT_COLOR_CODE..playerleaderskilled..NORMAL_FONT_COLOR_CODE;
		soSub  = HIGHLIGHT_FONT_COLOR_CODE..playersecondaryobjectives..NORMAL_FONT_COLOR_CODE;

		if ( line1checked == 1  or line1wschecked == 1 ) then

			if ( BGName == "Alterac Valley" ) then
				newString = BGBuddy_SavedVars["customizeText1"];
			elseif ( BGName == "Warsong Gulch" ) then
				newString = BGBuddy_SavedVars["customizeText1ws"];
			end
			newString = gsub(newString,"~LKH",lkhSub);
			newString = gsub(newString,"~LDK",ldkSub);
			newString = gsub(newString,"~GYA",gyaSub);
			newString = gsub(newString,"~GYD",gydSub);
			newString = gsub(newString,"~KB",kbSub);
			newString = gsub(newString,"~LK",lkSub);
			newString = gsub(newString,"~SH",shSub);
			newString = gsub(newString,"~BH",bhSub);
			newString = gsub(newString,"~TA",taSub);
			newString = gsub(newString,"~TD",tdSub);
			newString = gsub(newString,"~MC",mcSub);
			newString = gsub(newString,"~SO",soSub);
			newString = gsub(newString,"~K",kSub);
			newString = gsub(newString,"~D",dSub);
			newString = gsub(newString,"~S",sSub);
	
			line1 = NORMAL_FONT_COLOR_CODE..newString;
		end

		if ( line2checked == 1 or line2wschecked == 1 ) then

			if ( BGName == "Alterac Valley" ) then
				newString = BGBuddy_SavedVars["customizeText2"];
			elseif ( BGName == "Warsong Gulch" ) then
				newString = BGBuddy_SavedVars["customizeText2ws"];
			end
			
			newString = gsub(newString,"~LKH",lkhSub);
			newString = gsub(newString,"~LDK",ldkSub);
			newString = gsub(newString,"~GYA",gyaSub);
			newString = gsub(newString,"~GYD",gydSub);
			newString = gsub(newString,"~KB",kbSub);
			newString = gsub(newString,"~LK",lkSub);
			newString = gsub(newString,"~SH",shSub);
			newString = gsub(newString,"~BH",bhSub);
			newString = gsub(newString,"~TA",taSub);
			newString = gsub(newString,"~TD",tdSub);
			newString = gsub(newString,"~MC",mcSub);
			newString = gsub(newString,"~SO",soSub);
			newString = gsub(newString,"~K",kSub);
			newString = gsub(newString,"~D",dSub);
			newString = gsub(newString,"~S",sSub);
	
			line2 = NORMAL_FONT_COLOR_CODE..newString;
		end
		
		if ( line3checked == 1 or line3wschecked == 1 ) then

			if ( BGName == "Alterac Valley" ) then
				newString = BGBuddy_SavedVars["customizeText3"];
			elseif ( BGName == "Warsong Gulch" ) then
				newString = BGBuddy_SavedVars["customizeText3ws"];
			end
			
			newString = gsub(newString,"~LKH",lkhSub);
			newString = gsub(newString,"~LDK",ldkSub);
			newString = gsub(newString,"~GYA",gyaSub);
			newString = gsub(newString,"~GYD",gydSub);
			newString = gsub(newString,"~KB",kbSub);
			newString = gsub(newString,"~LK",lkSub);
			newString = gsub(newString,"~SH",shSub);
			newString = gsub(newString,"~BH",bhSub);
			newString = gsub(newString,"~TA",taSub);
			newString = gsub(newString,"~TD",tdSub);
			newString = gsub(newString,"~MC",mcSub);
			newString = gsub(newString,"~SO",soSub);
			newString = gsub(newString,"~K",kSub);
			newString = gsub(newString,"~D",dSub);
			newString = gsub(newString,"~S",sSub);
	
			line3 = NORMAL_FONT_COLOR_CODE..newString;
		end

		if ( line4checked == 1 or line4wschecked == 1 ) then

			if ( BGName == "Alterac Valley" ) then
				newString = BGBuddy_SavedVars["customizeText4"];
			elseif ( BGName == "Warsong Gulch" ) then
				newString = BGBuddy_SavedVars["customizeText4ws"];
			end
			
			newString = gsub(newString,"~LKH",lkhSub);
			newString = gsub(newString,"~LDK",ldkSub);
			newString = gsub(newString,"~GYA",gyaSub);
			newString = gsub(newString,"~GYD",gydSub);
			newString = gsub(newString,"~KB",kbSub);
			newString = gsub(newString,"~LK",lkSub);
			newString = gsub(newString,"~SH",shSub);
			newString = gsub(newString,"~BH",bhSub);
			newString = gsub(newString,"~TA",taSub);
			newString = gsub(newString,"~TD",tdSub);
			newString = gsub(newString,"~MC",mcSub);
			newString = gsub(newString,"~SO",soSub);
			newString = gsub(newString,"~K",kSub);
			newString = gsub(newString,"~D",dSub);
			newString = gsub(newString,"~S",sSub);
	
			line4 = NORMAL_FONT_COLOR_CODE..newString;
		end

		if ( line5checked == 1 or line5wschecked == 1 ) then

			if ( BGName == "Alterac Valley" ) then
				newString = BGBuddy_SavedVars["customizeText5"];
			elseif ( BGName == "Warsong Gulch" ) then
				newString = BGBuddy_SavedVars["customizeText5ws"];
			end
			
			newString = gsub(newString,"~LKH",lkhSub);
			newString = gsub(newString,"~LDK",ldkSub);
			newString = gsub(newString,"~GYA",gyaSub);
			newString = gsub(newString,"~GYD",gydSub);
			newString = gsub(newString,"~KB",kbSub);
			newString = gsub(newString,"~LK",lkSub);
			newString = gsub(newString,"~SH",shSub);
			newString = gsub(newString,"~BH",bhSub);
			newString = gsub(newString,"~TA",taSub);
			newString = gsub(newString,"~TD",tdSub);
			newString = gsub(newString,"~MC",mcSub);
			newString = gsub(newString,"~SO",soSub);
			newString = gsub(newString,"~K",kSub);
			newString = gsub(newString,"~D",dSub);
			newString = gsub(newString,"~S",sSub);
	
			line5 = NORMAL_FONT_COLOR_CODE..newString;
		end

		if ( line6checked == 1 or line6wschecked == 1 ) then

			if ( BGName == "Alterac Valley" ) then
				newString = BGBuddy_SavedVars["customizeText6"];
			elseif ( BGName == "Warsong Gulch" ) then
				newString = BGBuddy_SavedVars["customizeText6ws"];
			end
			
			newString = gsub(newString,"~LKH",lkhSub);
			newString = gsub(newString,"~LDK",ldkSub);
			newString = gsub(newString,"~GYA",gyaSub);
			newString = gsub(newString,"~GYD",gydSub);
			newString = gsub(newString,"~KB",kbSub);
			newString = gsub(newString,"~LK",lkSub);
			newString = gsub(newString,"~SH",shSub);
			newString = gsub(newString,"~BH",bhSub);
			newString = gsub(newString,"~TA",taSub);
			newString = gsub(newString,"~TD",tdSub);
			newString = gsub(newString,"~MC",mcSub);
			newString = gsub(newString,"~SO",soSub);
			newString = gsub(newString,"~K",kSub);
			newString = gsub(newString,"~D",dSub);
			newString = gsub(newString,"~S",sSub);
	
			line6 = NORMAL_FONT_COLOR_CODE..newString;
		end

		if ( BGBuddy_SavedVars["hideBGIcon"] == 1 ) then
			MiniMapBattlefieldFrame:Hide();
		else
			MiniMapBattlefieldFrame:Show();
		end
		BGBuddy_EnterFrame:Hide();
		BGBuddy_LeaveFrame:Hide();
		BGBuddy_SwitchFrame:Hide();
		if ( BGBuddy_SavedVars["hideDisplay"] == 0 ) then
			BGBuddy_ScoreFrame:Show();
			BGBuddy_StandardFrame:Show();
		end
	end

	baseHeight = 0;
	
	if ( BGBuddy_RankFrame:IsShown() ) then
		rankHeight = 0;
		BGBuddy_RankFrame:SetHeight(16);
	else
		rankHeight = -26;
		BGBuddy_RankFrame:SetHeight(1);
	end

	BGBuddy_Line1:SetText(" ");
	BGBuddy_Line2:SetText(" ");
	BGBuddy_Line3:SetText(" ");
	BGBuddy_Line4:SetText(" ");
	BGBuddy_Line5:SetText(" ");
	BGBuddy_Line6:SetText(" ");

	if ( line1show == 1 ) then
		BGBuddy_Line1:SetText(line1);
		baseHeight = 38 + rankHeight;
	else
		if ( line1checked == 1 and BGName == "Alterac Valley" ) then
			BGBuddy_Line1:SetText(line1);
			baseHeight = 38 + rankHeight;
		end
		if ( line1wschecked == 1 and BGName == "Warsong Gulch" ) then
			BGBuddy_Line1:SetText(line1);
			baseHeight = 38 + rankHeight;
		end
	end

	if ( line2show == 1 ) then
		BGBuddy_Line2:SetText(line2);
		baseHeight = 50 + rankHeight;
	else
		if ( line2checked == 1 and line1show == 0 and BGName == "Alterac Valley") then
			BGBuddy_Line2:SetText(line2);
			baseHeight = 50 + rankHeight;
		end
		if ( line2wschecked == 1 and line1show == 0 and BGName == "Warsong Gulch") then
			BGBuddy_Line2:SetText(line2);
			baseHeight = 50 + rankHeight;
		end
	end

	if ( line3checked == 1 and line1show == 0 and BGName == "Alterac Valley") then
		BGBuddy_Line3:SetText(line3);
		baseHeight = 62 + rankHeight;
	end
	if ( line3wschecked == 1 and line1show == 0 and BGName == "Warsong Gulch") then
		BGBuddy_Line3:SetText(line3);
		baseHeight = 62 + rankHeight;
	end

	if ( line4checked == 1 and line1show == 0 and BGName == "Alterac Valley") then
		BGBuddy_Line4:SetText(line4);
		baseHeight = 74 + rankHeight;
	end
	if ( line4wschecked == 1 and line1show == 0 and BGName == "Warsong Gulch") then
		BGBuddy_Line4:SetText(line4);
		baseHeight = 74 + rankHeight;
	end

	if ( line5checked == 1 and line1show == 0 and BGName == "Alterac Valley") then
		BGBuddy_Line5:SetText(line5);
		baseHeight = 86 + rankHeight;
	end
	if ( line5wschecked == 1 and line1show == 0 and BGName == "Warsong Gulch") then
		BGBuddy_Line5:SetText(line5);
		baseHeight = 86 + rankHeight;
	end

	if ( line6checked == 1 and line1show == 0 and BGName == "Alterac Valley") then
		BGBuddy_Line6:SetText(line6);
		baseHeight = 98 + rankHeight;
	end
	if ( line6wschecked == 1 and line1show == 0 and BGName == "Warsong Gulch") then
		BGBuddy_Line6:SetText(line6);
		baseHeight = 98 + rankHeight;
	end
	
	baseHeight = baseHeight + 7;

	maxWidth = 0;
	
	if ( BGBuddy_Line1:GetWidth() > maxWidth ) then
		maxWidth = BGBuddy_Line1:GetWidth();
	end
	if ( BGBuddy_Line2:GetWidth() > maxWidth ) then
		maxWidth = BGBuddy_Line2:GetWidth();
	end
	if ( BGBuddy_Line3:GetWidth() > maxWidth ) then
		maxWidth = BGBuddy_Line3:GetWidth();
	end
	if ( BGBuddy_Line4:GetWidth() > maxWidth ) then
		maxWidth = BGBuddy_Line4:GetWidth();
	end
	if ( BGBuddy_Line5:GetWidth() > maxWidth ) then
		maxWidth = BGBuddy_Line5:GetWidth();
	end
	if ( BGBuddy_Line6:GetWidth() > maxWidth ) then
		maxWidth = BGBuddy_Line6:GetWidth();
	end
	if ( (BGBuddy_RankName:GetWidth()+40) > maxWidth ) then
		maxWidth = BGBuddy_RankName:GetWidth() + 40;
	end

	if ( BGBuddy_ScoreFrame:IsVisible() ) then
		maxWidth = maxWidth + 17;
	end

	maxWidth = maxWidth + 15;

	if ( BGBuddy_RankFrame:IsShown() == nil ) then
		baseHeight = baseHeight + 13;
	end

	BGBuddy_StandardFrame:SetHeight(baseHeight);
	BGBuddy_StandardFrame:SetWidth(maxWidth);

	BGBuddy_EnterFrame:SetHeight(25);
	BGBuddy_EnterFrame:SetWidth(maxWidth);
end

function BGBuddy_OnMouseDown(arg1)
	if (arg1 == "LeftButton" and BGBuddy_SavedVars["isLocked"] == 0) then
		BGBuddy_StandardFrame:StartMoving();
	end

	if (arg1 == "RightButton") then
		ShowUIPanel(BGBuddy_ConfigPanel);
	end
end

function BGBuddy_OnMouseUp(arg1)
	if (arg1 == "LeftButton") then
		BGBuddy_StandardFrame:StopMovingOrSizing();
	end
end

function BGBuddy_Config_SetCustomDisplay()
	BGBuddy_SavedVars["customizeText1"] = BGBuddy_ConfigPanel_Customize_Box1:GetText();
	BGBuddy_SavedVars["customizeText2"] = BGBuddy_ConfigPanel_Customize_Box2:GetText();
	BGBuddy_SavedVars["customizeText3"] = BGBuddy_ConfigPanel_Customize_Box3:GetText();
	BGBuddy_SavedVars["customizeText4"] = BGBuddy_ConfigPanel_Customize_Box4:GetText();
	BGBuddy_SavedVars["customizeText5"] = BGBuddy_ConfigPanel_Customize_Box5:GetText();
	BGBuddy_SavedVars["customizeText6"] = BGBuddy_ConfigPanel_Customize_Box6:GetText();

	BGBuddy_SavedVars["customizeText1ws"] = BGBuddy_ConfigPanel_Customize_Box1ws:GetText();
	BGBuddy_SavedVars["customizeText2ws"] = BGBuddy_ConfigPanel_Customize_Box2ws:GetText();
	BGBuddy_SavedVars["customizeText3ws"] = BGBuddy_ConfigPanel_Customize_Box3ws:GetText();
	BGBuddy_SavedVars["customizeText4ws"] = BGBuddy_ConfigPanel_Customize_Box4ws:GetText();
	BGBuddy_SavedVars["customizeText5ws"] = BGBuddy_ConfigPanel_Customize_Box5ws:GetText();
	BGBuddy_SavedVars["customizeText6ws"] = BGBuddy_ConfigPanel_Customize_Box6ws:GetText();

	if ( BGBuddy_ConfigPanel_Customize_Line1:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine1"] = 1;
		line1checked = 1;
	else	
		BGBuddy_SavedVars["customizeLine1"] = 0;
		line1checked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line2:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine2"] = 1;
		line2checked = 1;
	else
		BGBuddy_SavedVars["customizeLine2"] = 0;
		line2checked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line3:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine3"] = 1;
		line3checked = 1;
	else
		BGBuddy_SavedVars["customizeLine3"] = 0;
		line3checked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line4:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine4"] = 1;
		line4checked = 1;
	else
		BGBuddy_SavedVars["customizeLine4"] = 0;
		line4checked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line5:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine5"] = 1;
		line5checked = 1;
	else
		BGBuddy_SavedVars["customizeLine5"] = 0;
		line5checked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line6:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine6"] = 1;
		line6checked = 1;
	else
		BGBuddy_SavedVars["customizeLine6"] = 0;
		line6checked = 0;
	end

	if ( BGBuddy_ConfigPanel_Customize_Line1ws:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine1ws"] = 1;
		line1wschecked = 1;
	else	
		BGBuddy_SavedVars["customizeLine1ws"] = 0;
		line1wschecked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line2ws:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine2ws"] = 1;
		line2wschecked = 1;
	else
		BGBuddy_SavedVars["customizeLine2ws"] = 0;
		line2wschecked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line3ws:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine3ws"] = 1;
		line3wschecked = 1;
	else
		BGBuddy_SavedVars["customizeLine3ws"] = 0;
		line3wschecked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line4ws:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine4ws"] = 1;
		line4wschecked = 1;
	else
		BGBuddy_SavedVars["customizeLine4ws"] = 0;
		line4wschecked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line5ws:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine5ws"] = 1;
		line5wschecked = 1;
	else
		BGBuddy_SavedVars["customizeLine5ws"] = 0;
		line5wschecked = 0;
	end
	if ( BGBuddy_ConfigPanel_Customize_Line6ws:GetChecked() == 1 ) then
		BGBuddy_SavedVars["customizeLine6ws"] = 1;
		line6wschecked = 1;
	else
		BGBuddy_SavedVars["customizeLine6ws"] = 0;
		line6wschecked = 0;
	end
end

function BGBuddy_Config_SetAlpha()
	BGBuddy_ConfigPanel_Slider1:SetValue(BGBuddy_SavedVars["backgroundAlpha"]);
	BGBuddy_ConfigPanel_Slider2:SetValue(BGBuddy_SavedVars["borderAlpha"]);
end

function BGBuddy_Config_SetBackgroundAlpha()
	BGBuddy_SavedVars["backgroundAlpha"] = BGBuddy_ConfigPanel_Slider1:GetValue();
	BGBuddy_ConfigPanel_Slider1ValueText:SetText(BGBuddy_SavedVars["backgroundAlpha"].."%");
	
	alpha = BGBuddy_SavedVars["backgroundAlpha"];
	alpha = alpha * 0.01;

	BGBuddy_StandardFrame:SetBackdropColor(0, 0, 0, alpha);
end

function BGBuddy_Config_SetBorderAlpha()
	BGBuddy_SavedVars["borderAlpha"] = BGBuddy_ConfigPanel_Slider2:GetValue();
	BGBuddy_ConfigPanel_Slider2ValueText:SetText(BGBuddy_SavedVars["borderAlpha"].."%");
	
	alpha = BGBuddy_SavedVars["borderAlpha"];
	alpha = alpha * 0.01;

	BGBuddy_StandardFrame:SetBackdropBorderColor(1, 1, 1, alpha);
end

function BGBuddy_Config_SetEnabled() 
	if ( BGBuddy_ConfigPanel_EnableBGBuddy:GetChecked() == 1 ) then
		BGBuddy_SavedVars["isEnabled"] = 1;
		BGBuddy_Initialize();
		BGBuddy_Config_SetVisibilityStatus();
	else
		DEFAULT_CHAT_FRAME:AddMessage(BGBUDDY_TITLE.." "..BGBUDDY_VERSION.." is disabled. If you want to re-enable, type '/bgbuddy' for the options menu.");
		BGBuddy_SavedVars["isEnabled"] = 0;
		BGBuddy_StandardFrame:Hide();
	end
end

function BGBuddy_Config_SetVisibility() 
	if ( BGBuddy_ConfigPanel_Customize_HideDisplay:GetChecked() == 1 ) then
		BGBuddy_SavedVars["hideDisplay"] = 1;
		BGBuddy_StandardFrame:Hide();
		DEFAULT_CHAT_FRAME:AddMessage(BGBUDDY_TITLE.." "..BGBUDDY_VERSION.." is now hidden. Use '/bgbuddy' to display the options menu.");
	else
		BGBuddy_SavedVars["hideDisplay"] = 0;
		BGBuddy_StandardFrame:Show();
	end
end

function BGBuddy_Config_SetLockStatus() 
	if ( BGBuddy_ConfigPanel_Lock:GetChecked() == 1 ) then
		BGBuddy_SavedVars["isLocked"] = 1;
	else
		BGBuddy_SavedVars["isLocked"] = 0;
	end
end

function BGBuddy_Config_SetDisplayRank() 
	if ( BGBuddy_ConfigPanel_Customize_DisplayRank:GetChecked() == 1 ) then
		BGBuddy_SavedVars["displayRank"] = 1;
		BGBuddy_RankFrame:Show();
	else
		BGBuddy_SavedVars["displayRank"] = 0;
		BGBuddy_RankFrame:Hide();
	end
end

function BGBuddy_Config_SetVisibilityStatus() 
	if ( BGBuddy_ConfigPanel_AlwaysShow:GetChecked() == 1 ) then
		BGBuddy_SavedVars["isAlwaysVisible"] = 1;
		if ( BGBuddy_SavedVars["hideDisplay"] == 0 ) then
			BGBuddy_StandardFrame:Show();
		end
	else
		BGBuddy_SavedVars["isAlwaysVisible"] = 0;
	end
end

function BGBuddy_Config_SetSound()
	if ( BGBuddy_ConfigPanel_PlaySound:GetChecked() == 1 ) then
		BGBuddy_SavedVars["playSound"] = 1;
	else
		BGBuddy_SavedVars["playSound"] = 0;
	end
end

function BGBuddy_Config_SetBGIcon()
	if ( BGBuddy_ConfigPanel_HideBGIcon:GetChecked() == 1 ) then
		BGBuddy_SavedVars["hideBGIcon"] = 1;
	else
		BGBuddy_SavedVars["hideBGIcon"] = 0;
	end
end

function BGBuddy_AutoJoin()
	if ( BGBuddy_ConfigPanel_AutoJoin:GetChecked() == 1) then
		BGBuddy_SavedVars["AutoJoin"] = 1;
		BGBuddy_UnAFK();
		BattlefieldFrame_EnterBattlefield();
		StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY");
	else
		BGBuddy_SavedVars["AutoJoin"] = 0;
	end
end

function BGBuddy_AutoRes()
	local status, _, _ = GetBattlefieldStatus();
	if ( BGBuddy_ConfigPanel_AutoRes:GetChecked() == 1) then
		BGBuddy_SavedVars["AutoRes"] = 1;
		if ( status == "active" ) then

			if ( UnitIsGhost("player") ) then
				AcceptAreaSpiritHeal();
				getglobal("StaticPopup1Button1"):Hide();
				getglobal("StaticPopup1Button2"):Hide();
			end
		end
	else 
		BGBuddy_SavedVars["AutoRes"] = 0;
	end
end
			
function BGBuddy_UnAFK()
	MoveBackwardStart();
	MoveBackwardStop();
end

function BGBuddy_AutoRelease()
	if ( BGBuddy_ConfigPanel_AutoRelease:GetChecked() == 1) then
		BGBuddy_SavedVars["AutoRelease"] = 1;
		local _, _, instanceID = GetBattlefieldStatus();
		if ( instanceID ~= 0 ) then
			RepopMe();
		end
	else
		BGBuddy_SavedVars["AutoRelease"] = 0;
	end
end

