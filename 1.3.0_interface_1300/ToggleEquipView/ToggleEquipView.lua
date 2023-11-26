
old_PaperDollItemSlotButton_OnClick = PaperDollItemSlotButton_OnClick;

function PaperDollItemSlotButton_OnClick(button, ignoreShift)
	old_PaperDollItemSlotButton_OnClick(button, ignoreShift);
	if (this:GetName() == "CharacterBackSlot") then
		ToggleEquipView_ToggleCloak();
	elseif (this:GetName() == "CharacterHeadSlot") then
		ToggleEquipView_ToggleHelm();
	end
end

old_PaperDollItemSlotButton_Update = PaperDollItemSlotButton_Update;

function PaperDollItemSlotButton_Update(cooldown) 
	old_PaperDollItemSlotButton_Update(cooldown);
	UIOptionsFrame_Load();

	local state = ToggleEquipView_GetState("SHOW_CLOAK");
	ToggleEquipView_SetButtonState(CharacterBackSlot, state);
	
	state = ToggleEquipView_GetState("SHOW_HELM");
	ToggleEquipView_SetButtonState(CharacterHeadSlot, state);
end
	

function ToggleEquipView_SetHelmValue(value)
	UIOptionsFrame_Load();
	UIOptionsFrameCheckButtons["SHOW_HELM"].setFunc(value);
	UIOptionsFrameCheckButtons["SHOW_HELM"].func = function () return value end;
	UIOptionsFrameCheckButtons["SHOW_HELM"].value = value;
	UIOptionsFrameCheckButton31:SetChecked(value);
	UIOptionsFrame_Save();
	CharacterModelFrame:SetUnit("player");
end

function ToggleEquipView_SetCloakValue(value)
	UIOptionsFrame_Load();
	UIOptionsFrameCheckButtons["SHOW_CLOAK"].setFunc(value);
	UIOptionsFrameCheckButtons["SHOW_CLOAK"].func = function () return value end;
	UIOptionsFrameCheckButtons["SHOW_CLOAK"].value = value;
	UIOptionsFrameCheckButton30:SetChecked(value);
	UIOptionsFrame_Save();
	CharacterModelFrame:SetUnit("player");
end


function ToggleEquipView_ToggleCloak()
	local newState = ToggleEquipView_GetToggledState("SHOW_CLOAK");
	ToggleEquipView_SetButtonState(CharacterBackSlot, newState);
	ToggleEquipView_SetCloakValue(newState);
end

function ToggleEquipView_ToggleHelm()
	local newState = ToggleEquipView_GetToggledState("SHOW_HELM");
	ToggleEquipView_SetButtonState(CharacterHeadSlot, newState);
	ToggleEquipView_SetHelmValue(newState);
end

function ToggleEquipView_GetState(slotName)
	if (UIOptionsFrameCheckButtons[slotName].value == "1") then
		return 1;
	else
		return 0;
	end
end

function ToggleEquipView_GetToggledState(slotName)
	if ( ToggleEquipView_GetState(slotName) == 1 ) then
		return 0;
	else
		return 1;
	end
end

function ToggleEquipView_SetButtonState(button, state)
	if ( state == 1 ) then
		SetItemButtonNormalTextureVertexColor(button, 0.0, 1.0, 0.0, 1.0);
	else
		SetItemButtonNormalTextureVertexColor(button, 1.0, 0.0, 0.0, 1.0);
	end
end

function ToggleEquipViewFrame_OnLoad()
	ToggleEquipViewFrame_RegisterSlashCommands();
end

function ToggleEquipViewFrame_RegisterSlashCommands()
	if ( Cosmos_RegisterChatCommand ) then
		local ToggleEquipView_CloakCommands = {"/togglecloak","/tcloak"};
		Cosmos_RegisterChatCommand (
			"TOGGLEEQUIPVIEW_CLOAK_COMMANDS",
			ToggleEquipView_CloakCommands,
			ToggleEquipView_CloakSlashCommand,
			TOGGLEEQUIPVIEW_CHAT_CLOAK_COMMAND_INFO
		);
		local ToggleEquipView_HelmCommands = {"/togglehelm","/thelm"};
		Cosmos_RegisterChatCommand (
			"TOGGLEEQUIPVIEW_HELM_COMMANDS",
			ToggleEquipView_HelmCommands,
			ToggleEquipView_HelmSlashCommand,
			TOGGLEEQUIPVIEW_CHAT_HELM_COMMAND_INFO
		);
	else
		SlashCmdList["TOGGLEEQUIPVIEWSLASHCLOAK"] = ToggleEquipView_CloakSlashCommand;
		SLASH_TOGGLEEQUIPVIEWSLASHCLOAK1 = "/togglecloak";
		SLASH_TOGGLEEQUIPVIEWSLASHCLOAK2 = "/tcloak";
		SlashCmdList["TOGGLEEQUIPVIEWSLASHHELM"] = ToggleEquipView_HelmSlashCommand;
		SLASH_TOGGLEEQUIPVIEWSLASHHELM1 = "/togglehelm";
		SLASH_TOGGLEEQUIPVIEWSLASHHELM2 = "/thelm";
	end
end


function ToggleEquipViewFrame_OnEvent(event)
	-- strictly for future development, if any is deemed necessary
end

function ToggleEquipView_CloakSlashCommand(cmd)
	ToggleEquipView_ToggleCloak();
end

function ToggleEquipView_HelmSlashCommand(cmd)
	ToggleEquipView_ToggleHelm();
end

