--[[
	TransNUI

	By Mugendai

	This mod lets you make many parts of your UI transparent.
   ]]

TRANSNUI_UPDATETIME = 0.2;
TRANSNUI_CONFIG_PREFIX = "COS_TUI_";
TRANSNUI_NAME = "name";
TRANSNUI_DESC = "desc";
TRANSNUI_CHAT = "chat";

TransNUI_Config = { };
TransNUI_Regs = {};
TransNUI_Initialized=0;
TransNUI_LastUpdate=0;

function TransNUI_SetUITrans(whichUI, Trans)
	if (whichUI) then
		local setTo = -1;
		if (Trans and (Trans > -1)) then
			if (Trans > 1) then
				setTo = 1;
			else
				setTo = Trans;
			end
		end
		
		if ((setTo > -1) and (whichUI == "UIParent") and (setTo < 0.10)) then
			setTo = 0.10;
		end
		
		if (TransNUI_Config[whichUI] ~= setTo) then
			TransNUI_Config[whichUI] = setTo;
			if(Cosmos_RegisterConfiguration) then
				if (setTo > -1) then
					Cosmos_UpdateValue(TRANSNUI_CONFIG_PREFIX..string.upper(whichUI), CSM_SLIDERVALUE, setTo);
				end
				if (setTo > -1) then
					setTo = 1;
				else
					setTo = 0;
				end
				Cosmos_UpdateValue(TRANSNUI_CONFIG_PREFIX..string.upper(whichUI), CSM_CHECKONOFF, setTo);
			end
		end
	end
end

function TransNUI_Toggle()
	if (TransNUI_Override) then
		TransNUI_Override = nil;
	else
		TransNUI_Override = true;
	end
end

function TransNUI_Save()
	RegisterForSave("TransNUI_Config");
end

function TransNUI_OnUpdate(elapsed)
	TransNUI_LastUpdate = TransNUI_LastUpdate + elapsed;
	if (TransNUI_LastUpdate >= TRANSNUI_UPDATETIME) then 
		TransNUI_LastUpdate = 0;
		
		for curUIName, curVal in TransNUI_Config do
			local curUI = getglobal(curUIName);
			local setTo;
			if (curUI) then
				if ((curVal < 0) or TransNUI_Override) then
					setTo = 1;
				else
					setTo = curVal;
				end

				if ((curUIName == "UIParent") and (setTo < 0.10)) then
					setTo = 0.10;
					TransNUI_Config["UIParent"] = setTo;
				end
				
				if ((TransNUI_Config["UIParent"] > -1) and (setTo > TransNUI_Config["UIParent"]) and (curVal < 0) and (not TransNUI_Override)) then
					setTo = TransNUI_Config["UIParent"];
				end
				
				if ((curUIName == "MainMenuBar") and (setTo > -1)) then
					local setAB = setTo;
					--local setBAB = setTo;
					if ( GetBonusBarOffset() > 0 ) then
						TransNUI_SetAlpha("BonusActionBarTexture0", 0);
						TransNUI_SetAlpha("BonusActionBarTexture1", 0);
						setAB = 0;
					else
						TransNUI_SetAlpha("BonusActionBarTexture0", setTo);
						TransNUI_SetAlpha("BonusActionBarTexture1", setTo);
					end
						
					TransNUI_SetAlpha("ActionButton1", setAB);
					TransNUI_SetAlpha("ActionButton2", setAB);
					TransNUI_SetAlpha("ActionButton3", setAB);
					TransNUI_SetAlpha("ActionButton4", setAB);
					TransNUI_SetAlpha("ActionButton5", setAB);
					TransNUI_SetAlpha("ActionButton6", setAB);
					TransNUI_SetAlpha("ActionButton7", setAB);
					TransNUI_SetAlpha("ActionButton8", setAB);
					TransNUI_SetAlpha("ActionButton9", setAB);
					TransNUI_SetAlpha("ActionButton10", setAB);
					TransNUI_SetAlpha("ActionButton11", setAB);
					TransNUI_SetAlpha("ActionButton12", setAB);
					
					--[[TransNUI_SetAlpha("BonusActionButton1", setBAB);
					TransNUI_SetAlpha("BonusActionButton2", setBAB);
					TransNUI_SetAlpha("BonusActionButton3", setBAB);
					TransNUI_SetAlpha("BonusActionButton4", setBAB);
					TransNUI_SetAlpha("BonusActionButton5", setBAB);
					TransNUI_SetAlpha("BonusActionButton6", setBAB);
					TransNUI_SetAlpha("BonusActionButton7", setBAB);
					TransNUI_SetAlpha("BonusActionButton8", setBAB);
					TransNUI_SetAlpha("BonusActionButton9", setBAB);
					TransNUI_SetAlpha("BonusActionButton10", setBAB);
					TransNUI_SetAlpha("BonusActionButton11", setBAB);
					TransNUI_SetAlpha("BonusActionButton12", setBAB);]]
				end
				
				
				if (curUI:GetAlpha() ~= setTo) then
					curUI:SetAlpha(setTo);
				end
				if (curUIName == "BuffFrame") then
					local curUI = getglobal("MooBuffFrame");
					if (curUI and (curUI:GetAlpha() ~= setTo)) then
						curUI:SetAlpha(setTo);
					end
				end
			end
		end
	end
end

function TransNUI_SetAlpha(curUIName, setTo)
	local curUI = getglobal(curUIName);
	if (curUI) then
		if (curUI:GetAlpha() ~= setTo) then
			curUI:SetAlpha(setTo);
		end
	end
end

function TransNUI_BuffButton_OnUpdate()	
	local buffIndex = this.buffIndex;
	local timeLeft = GetPlayerBuffTimeLeft(buffIndex);
	if ((this:IsVisible()) and ( timeLeft >= BUFF_WARNING_TIME ) or (timeLeft == 0)) then
		local setTo;
		if (TransNUI_Config["BuffFrame"] < 0) then
			setTo = 1;
		else
			setTo = TransNUI_Config["BuffFrame"];
		end
		
		if ((TransNUI_Config["UIParent"] > -1) and (setTo > TransNUI_Config["UIParent"]) and (TransNUI_Config["BuffFrame"] < 0)) then
			setTo = TransNUI_Config["UIParent"];
		end
		
		if (this:GetAlpha() ~= setTo) then
			this:SetAlpha(setTo);
		end
	end	
end

function TransNUI_MooBuffButton_OnUpdate()
	local buffIndex = this.buffIndex;
	if (buffIndex) then
		local timeLeft = GetPlayerBuffTimeLeft(buffIndex);
		if ((this:IsVisible()) and ( timeLeft >= BUFF_WARNING_TIME ) or (timeLeft == 0)) then
			local setTo;
			if (TransNUI_Config["BuffFrame"] < 0) then
				setTo = 1;
			else
				setTo = TransNUI_Config["BuffFrame"];
			end
			
			if ((TransNUI_Config["UIParent"] > -1) and (setTo > TransNUI_Config["UIParent"]) and (TransNUI_Config["BuffFrame"] < 0)) then
				setTo = TransNUI_Config["UIParent"];
			end
			
			if (this:GetAlpha() ~= setTo) then
				this:SetAlpha(setTo);
			end
		end	
	end
end

function TransNUI_OnLoad()
	if ( TransNUI_Initialized == 0) then
		Sea.util.hook("BuffButton_OnUpdate", "TransNUI_BuffButton_OnUpdate", "after");
		if (MooBuffButton_OnUpdate) then
			Sea.util.hook("MooBuffButton_OnUpdate", "TransNUI_MooBuffButton_OnUpdate", "after");
		end
		
		TransNUI_RegisterUI("UIParent",				"global",						TRANSNUI_CONFIG_GLOBAL,			TRANSNUI_CONFIG_GLOBAL_INFO,		0.1);
		TransNUI_RegisterUI("MainMenuBar",			"main",							TRANSNUI_CONFIG_MAINBAR,		TRANSNUI_CONFIG_MAINBAR_INFO		);
		TransNUI_RegisterUI("ShapeshiftBarFrame",	{"shape", "stance", "aura", "stealth"},	TRANSNUI_CONFIG_SHAPEBAR,		TRANSNUI_CONFIG_SHAPEBAR_INFO		);
		TransNUI_RegisterUI("PetActionBarFrame",	"pet",							TRANSNUI_CONFIG_PETBAR,			TRANSNUI_CONFIG_PETBAR_INFO			);
		TransNUI_RegisterUI("SecondBar",			"second",						TRANSNUI_CONFIG_SECONDBAR,		TRANSNUI_CONFIG_SECONDBAR_INFO		);
		TransNUI_RegisterUI("SideBar2",				{"left", "leftsidebar"},		TRANSNUI_CONFIG_LEFTSIDEBAR,	TRANSNUI_CONFIG_LEFTSIDEBAR_INFO	);
		TransNUI_RegisterUI("SideBar",				{"right", "rightsidebar"},		TRANSNUI_CONFIG_RIGHTSIDEBAR,	TRANSNUI_CONFIG_RIGHTSIDEBAR_INFO	);
		TransNUI_RegisterUI("MinimapCluster",		{"map", "minimap"},				TRANSNUI_CONFIG_MINIMAP,		TRANSNUI_CONFIG_MINIMAP_INFO		);
		TransNUI_RegisterUI("BuffFrame",			"buffs",						TRANSNUI_CONFIG_BUFFS,			TRANSNUI_CONFIG_BUFFS_INFO			);
		TransNUI_RegisterUI("PlayerFrame",			"stats",						TRANSNUI_CONFIG_STATS,			TRANSNUI_CONFIG_STATS_INFO			);
		TransNUI_RegisterUI("QuestTooltip",			"minion",						TRANSNUI_CONFIG_MINION,			TRANSNUI_CONFIG_MINION_INFO			);
		
		if (not (Cosmos_RegisterConfiguration == nil)) then		
			if ( Cosmos_RegisterChatCommand ) then
				local TransNUICommands = {"/transnui","/tui"};
				Cosmos_RegisterChatCommand (
					"TRANSNUI_COMMANDS", -- Some Unique Group ID
					TransNUICommands, -- The Commands
					TransNUI_ChatCommandHandler,
					TRANSNUI_CHAT_COMMAND_INFO -- Description String
				);
			end
		else
			SlashCmdList["TRANSNUISLASH"] = TransNUI_ChatCommandHandler;
			SLASH_TRANSNUISLASH1 = "/transnui";
			SLASH_TRANSNUISLASH2 = "/tui";
			TransNUI_Save();
		end
		TransNUI_Initialized = 1;
	end
end		

-- TransNUI Chat Command Handler
function TransNUI_ChatCommandHandler(msg)
	if (msg) then
		msg = string.lower(msg);
		local command, setStr = unpack(Sea.string.split(msg, " "));
		if ((not command) and msg) then
			command = msg;
		end
		if (command) then
			local whichUI = nil;
			for checkMode = 1, 2 do
				for curReg in TransNUI_Regs do
					local curCommand = TransNUI_Regs[curReg][TRANSNUI_CHAT];
					if ((type(curCommand) == "table")) then
						for k, inCommand in curCommand do
							if (checkMode == 1) then
								if (command == inCommand) then
									whichUI = curReg;
									break;
								end
							else
								if (string.find(command, inCommand)) then
									whichUI = curReg;
									break;
								end
							end
						end
					else
						if (checkMode == 1) then
							if (command == curCommand) then
								whichUI = curReg;
								break;
							end
						else
							if (string.find(command, curCommand)) then
								whichUI = curReg;
								break;
							end
						end
					end
				end
			end
			if (whichUI) then
				local setNum = -1;
				-- Toggle appropriately
				if (setStr) then
					if (string.find(setStr, "%d") or string.find(setStr, "%d.%d+") or string.find(setStr, ".%d+")) then
						setNum = setStr+0;
						if (setNum < 0) then
							setNum = -1;
						elseif (setNum > 1) then
							setNum = 1;
						end
					end
				end
				
				TransNUI_SetUITrans(whichUI, setNum);
				return;
			end
		end
	end
	local chatList = "";
	for curReg in TransNUI_Regs do
		local curChatEntry = TransNUI_Regs[curReg][TRANSNUI_CHAT];
		if (chatList ~= "") then
			chatList = chatList..", ";
		else
			chatList = "";
		end
		if ((type(curChatEntry) == "table")) then
			local chatSet = "";
			for curChat in curChatEntry do
				if (chatSet ~= "") then
					chatSet = chatSet.."/";
				else
					chatSet = "";
				end
				chatSet = chatSet..curChatEntry[curChat];
			end
			chatList = chatList..chatSet;
		else
			chatList = chatList..curChatEntry;
		end
	end
	for i = 1, getn(TRANSNUI_CHAT_COMMAND_HELP) do
		local chatLine = string.format(TRANSNUI_CHAT_COMMAND_HELP[i], chatList);
		Sea.io.printc(ChatTypeInfo["SYSTEM"], chatLine);
	end
end

--Use this to add a UI element to be transparentized.
--whichUI - Which UI element, be sure to pass the exact name.
--chatComm - the chat command to use to control the options, don't pass a / or tui.. just the nickname for your UI element.  This can be a single command or a list of commands.
--confName - the name to show in Cosmos' UI config
--confDesc - the description to show in Cosmos' UI config
--confMin - the minimum value that this can be set to
function TransNUI_RegisterUI(whichUI, chatComm, confName, confDesc, confMin)
	if (whichUI and chatComm) then
		if (not TransNUI_Config[whichUI]) then
			TransNUI_Config[whichUI] = -1;
		end
		TransNUI_Regs[whichUI] = {};
		TransNUI_Regs[whichUI][TRANSNUI_CHAT] = chatComm;
		
		if (Cosmos_RegisterConfiguration and confName and confDesc) then
			TransNUI_Regs[whichUI][TRANSNUI_NAME] = confName;
			TransNUI_Regs[whichUI][TRANSNUI_DESC] = confDesc;
			
			local confVarName = TRANSNUI_CONFIG_PREFIX..string.upper(whichUI);
			
			Cosmos_RegisterConfiguration(
				"COS_UIVIS",
				"SECTION",
				TRANSNUI_CONFIG_SECTION,
				TRANSNUI_CONFIG_SECTION_INFO
				);
			Cosmos_RegisterConfiguration(
				"COS_TUI_SEP",
				"SEPARATOR",
				TRANSNUI_CONFIG_HEADER,
				TRANSNUI_CONFIG_HEADER_INFO
				);
			Cosmos_RegisterConfiguration(
				confVarName,
				"BOTH",
				confName,
				confDesc,
				function (checked, value) TransNUI_SetFromCos(whichUI, checked, value); end,
				0,
				1,
				confMin,
				1,
				TRANSNUI_CONFIG_SLIDER,
				0.01,
				1,
				TRANSNUI_CONFIG_SUFFIX,
				100
			);
		end
	end
end

function TransNUI_SetFromCos(passedUI, checked, value)
	if (checked==1) then
		TransNUI_SetUITrans(passedUI, value);
	else
		TransNUI_SetUITrans(passedUI, -1);
	end
end