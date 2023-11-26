--[[***** Nurfed General *****]]--
--[[***** General UI Modifications *****]]--

Nurfed_AutoRepairMin = 0;
Nurfed_AutoRepairMax = 100;
Nurfed_AutoRepairStep = 1;

Nurfed_QuestLog_Update = QuestLog_Update;
Nurfed_QuestWatch_Update = QuestWatch_Update;

local Original_ChatFrame_OnEvent;
local Nurfed_TIMESTAMPSEC = "%d:%02d:%02d";

-- Setup variable loading for general options without a frame
function Nurfed_GeneralOnLoad ()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("MERCHANT_SHOW");
	this:RegisterEvent("MINIMAP_PING");
	this:RegisterEvent("TRAINER_SHOW");

	RegisterForSave("Nurfed_General");

	Original_ChatFrame_OnEvent = ChatFrame_OnEvent;
	ChatFrame_OnEvent = ChatTimestamp_ChatFrame_OnEvent;
end

function Nurfed_GeneralOnEvent ()
	if (event == "VARIABLES_LOADED") then
		if( not Nurfed_General ) then
			Nurfed_General = {};
			Nurfed_General.AutoRepair = 1;
			Nurfed_General.AutoRepairGold = 20;
			Nurfed_General.PingWarning = 1;
			Nurfed_General.TrainerAvailable = 1;
			Nurfed_General.Nurfed_TimeStamps = 1;
		end

		if (Nurfed_RetrieveSaved("autorepair") ~= nil) then
			Nurfed_General.AutoRepair = Nurfed_RetrieveSaved("autorepair");
		else
			Nurfed_General.AutoRepair = 1;
		end

		if (Nurfed_RetrieveSaved("autorepairgold") ~= nil) then
			Nurfed_General.AutoRepairGold = Nurfed_RetrieveSaved("autorepairgold");
		else
			Nurfed_General.AutoRepairGold = 20;
		end

		if (Nurfed_RetrieveSaved("pingwarning") ~= nil) then
			Nurfed_General.PingWarning = Nurfed_RetrieveSaved("pingwarning");
		else
			Nurfed_General.PingWarning = 1;
		end

		if (Nurfed_RetrieveSaved("traineravailable") ~= nil) then
			Nurfed_General.TrainerAvailable = Nurfed_RetrieveSaved("traineravailable");
		else
			Nurfed_General.TrainerAvailable = 1;
		end

		if (Nurfed_RetrieveSaved("timestamps") ~= nil) then
			Nurfed_General.Nurfed_TimeStamps = Nurfed_RetrieveSaved("timestamps");
		else
			Nurfed_General.Nurfed_TimeStamps = 1;
		end

		Nurfed_RegisterOption(50, "category", nil, nil, nil, "General", "General UI Settings.");
		Nurfed_RegisterOption(51, "header", nil, nil, nil, "General", "General UI Settings.");
		Nurfed_RegisterOption(52, "check", Nurfed_General.AutoRepair, "autorepair", Nurfed_GeneralUpdate, "Enable Auto Repair", "Auto Repair.");
		Nurfed_RegisterOption(53, "slider", Nurfed_General.AutoRepairGold, "autorepairgold", Nurfed_GeneralUpdate, "Min Gold for Repair", "Amount Of Gold Needed\nFor AutoRepair", Nurfed_AutoRepairMin, Nurfed_AutoRepairMax, Nurfed_AutoRepairStep, " G");
		Nurfed_RegisterOption(54, "check", Nurfed_General.PingWarning, "pingwarning", Nurfed_GeneralUpdate, "Enable Ping Warning", "Ping Warning.");
		Nurfed_RegisterOption(55, "check", Nurfed_General.TrainerAvailable, "traineravailable", Nurfed_GeneralUpdate, "Trainer Available", "Show Only Available Abilities At Trainer");
		Nurfed_RegisterOption(56, "check", Nurfed_General.Nurfed_TimeStamps, "timestamps", Nurfed_GeneralUpdate, "Enable Time Stamps", "Chat Time Stamps.");
		Nurfed_NoQFade();
		SecondsToTimeAbbrev = Nurfed_SecondsToTimeAbbrev;
		Nurfed_LinkFrame(dQuestWatchDragButton:GetName(), QuestWatchFrame:GetName(), "RIGHT");
	end

	if (event == "MERCHANT_SHOW") then
		Nurfed_Repair();
		return;
	end

	if (event == "MINIMAP_PING") then
		if(Nurfed_General.PingWarning == 1) then
			local name = UnitName(arg1);
			if (name ~= UnitName("player")) then
				DEFAULT_CHAT_FRAME:AddMessage((name.." Pinged the minimap"), 1, 1, 0);
			end
		end
		return;
	end

	if (event == "TRAINER_SHOW") then
		if(Nurfed_General.TrainerAvailable == 1) then
			SetTrainerServiceTypeFilter("unavailable",0);
		end
		return;
	end
end

function Nurfed_GeneralUpdate(init)
	if (init == nil) then
		init = 0;
	end
	if (Nurfed_RetrieveOption ~= nil) then
		if (Nurfed_RetrieveOption(52) ~= nil) then
			Nurfed_General.AutoRepair = Nurfed_RetrieveOption(52)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(53) ~= nil) then
			Nurfed_General.AutoRepairGold = Nurfed_RetrieveOption(53)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(54) ~= nil) then
			Nurfed_General.PingWarning = Nurfed_RetrieveOption(54)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(55) ~= nil) then
			Nurfed_General.TrainerAvailable = Nurfed_RetrieveOption(55)[NURFED_VALUE];
		end
		if (Nurfed_RetrieveOption(56) ~= nil) then
			Nurfed_General.Nurfed_TimeStamps = Nurfed_RetrieveOption(56)[NURFED_VALUE];
		end
	end
end

-----------------------------------------------------------------------------------------------
--				Buff Timers
-----------------------------------------------------------------------------------------------

function Nurfed_SecondsToTimeAbbrev(seconds)
	local time = "";
	local tempTime;
	local tempTime2;
	if ( seconds > 86400  ) then
		tempTime = ceil(seconds / 86400);
		time = tempTime.." "..DAY_ONELETTER_ABBR;
		return time;
	end
	if ( seconds > 3600  ) then
		tempTime = ceil(seconds / 3600);
		time = tempTime.." "..HOUR_ONELETTER_ABBR;
		return time;
	end
	if ( seconds > 60  ) then
		tempTime = floor(seconds / 60);
		tempTime2 = floor(seconds-(tempTime)*60);
		time = format("%02d:%02d", tempTime, tempTime2);
		return time;
	end
	time = format("00:%02d", seconds);
	return time;
end

-----------------------------------------------------------------------------------------------
--				Quest Log
-----------------------------------------------------------------------------------------------

--Disable quest text fading
function Nurfed_NoQFade()
	QUEST_FADING_ENABLE = nil;
end

--Show quest levels
function QuestLog_Update()
	local nEntries, nQuests = GetNumQuestLogEntries();
	Nurfed_QuestLog_Update();
	for i=1, QUESTS_DISPLAYED, 1 do
		if ( i <= nEntries ) then
			local qTitle, qLevel, qTag, isHeader, isCollapsed = GetQuestLogTitle(i + FauxScrollFrame_GetOffset(QuestLogListScrollFrame));
			local qLogTitle = getglobal("QuestLogTitle"..i);
			local qCheck = getglobal("QuestLogTitle"..i.."Check");
			local qTitleTag = getglobal("QuestLogTitle"..i.."Tag");
			Nurfed_tempWidth = 275 - 5 - qTitleTag:GetWidth();
			qCheck:SetPoint("LEFT", qLogTitle:GetName(), "LEFT", Nurfed_tempWidth+24, 0);
			if (not isHeader) then
				if ( qTitle ) then
					qLogTitle:SetText(" ["..qLevel.."] "..qTitle.."  ");
				end
			end
		end
	end

end

function QuestWatch_Update()
	Nurfed_QuestWatch_Update();
	if ( QuestWatchFrame:IsVisible() ) then
		dQuestWatchDragButton:Show();
	else
		dQuestWatchDragButton:Hide();
	end
end

function Nurfed_DragFrameStart(frame)
	if (NURFED_LOCKALL == 0) then
		frame:StartMoving();
	end
end

function Nurfed_DragFrameStop(frame)
	frame:StopMovingOrSizing();
end

function Nurfed_LinkFrame(dButton, pFrame)
	getglobal(pFrame):ClearAllPoints();
	getglobal(pFrame):SetPoint("TOPLEFT", dButton, "TOPRIGHT");
end

-----------------------------------------------------------------------------------------------
--				General Functions
-----------------------------------------------------------------------------------------------

function Nurfed_Repair()
	local repairAllCost, canRepair = GetRepairAllCost();
	local money = GetMoney();
	if (Nurfed_General.AutoRepair == 1) then

		local g = math.floor(money / COPPER_PER_GOLD);
		
		local gold = floor(repairAllCost / (COPPER_PER_SILVER * SILVER_PER_GOLD));
		local silver = floor((repairAllCost - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
		local copper = mod(repairAllCost, COPPER_PER_SILVER);

		if ( canRepair and g >= Nurfed_General.AutoRepairGold ) then
			RepairAllItems();
			DEFAULT_CHAT_FRAME:AddMessage(("Spent "..gold.."g "..silver.."s "..copper.."c".." On Repairs."), 1, 1, 0);
		end
	end
end

-----------------------------------------------------------------------------------------------
--				Chat Timestamps
-----------------------------------------------------------------------------------------------

function ChatTimestamp_ChatFrame_OnEvent(event)
	Original_ChatFrame_OnEvent(event);
	if(not this.Original_AddMessage) then
		this.Original_AddMessage = this.AddMessage;
		this.AddMessage = ChatTimestamp_AddMessage;
	end
end

function ChatTimestamp_AddMessage(this, msg, r, g, b, id)
	local hour, minute = GetGameTime();
	local second, newmsg, timestamp;
	if ( NURFED_TIME ) then
		if ( TitanGetVar(TITAN_CLOCK_ID, "OffsetHour") ) then
			hour = hour + TitanGetVar(TITAN_CLOCK_ID, "OffsetHour");
		end
		second=GetTime() - NURFED_TIME;
	else
		second=00;
	end

	if(Nurfed_General.Nurfed_TimeStamps == 1) then
		if ( NURFED_TIME ) then
			if (TitanGetVar(TITAN_CLOCK_ID, "Format") == TITAN_CLOCK_FORMAT_12H) then
				if tonumber(hour) >12 then
					hour=hour-12;
				else
					hour=tonumber(hour)
					if hour==0 then
						hour=12;
					end
				end
			end
		end

		if msg == nil then
			msg="The value was nil";
		end

		timestamp = format("%d:%02d:%02d", hour, minute, second);
		newmsg = "["..timestamp.."]".." "..msg;
		this:Original_AddMessage(newmsg, r, g, b, id);
	else
		this:Original_AddMessage(msg, r, g, b, id);
	end
end