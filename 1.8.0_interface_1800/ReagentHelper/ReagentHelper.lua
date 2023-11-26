--[[
    Reagent Helper - Lets you see which reagents are needed by which professions
    TODO: Build the window that lets you see all reagents for a profession
    AUTHOR: Tuatara
  ]]

-- Configuration variables
local RH_TOOLTIP_ENABLE = false;  -- set this to non nil to enable Reagent Helper

-- Callback functions
function ReagentHelper_Tooltip_Enable(toggle)
	if (not toggle or toggle == 0) then 
		RH_TOOLTIP_ENABLE = false;
	else
		RH_TOOLTIP_ENABLE = true;
	end
end

function ReagentHelper_Tooltip_ToggleEnable()
	if (RH_TOOLTIP_ENABLE) then
		RH_TOOLTIP_ENABLE = false;
	else
		RH_TOOLTIP_ENABLE = true;
	end
	ReagentHelper_DisplayStatus();
end

function ReagentHelper_DisplayStatus()
	if (RH_TOOLTIP_ENABLE) then
		Sea.io.print(RH_TOOLTIP_TOGGLE_ENABLED);
	else
		Sea.io.print(RH_TOOLTIP_TOGGLE_DISABLED);
	end
end

function ReagentHelper_KhaosTextDisplay(state)
	if (state) then
		return
	else
		return
	end
end

function ReagentHelper_OnLoad()
	Sea.util.hook("GameTooltip.SetMerchantItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetInboxItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetInventoryItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetBagItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetTradeTargetItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetTradePlayerItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetAuctionItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetQuestLogItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetQuestItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("GameTooltip.SetLootItem", "ReagentHelper_ModifyGameTooltip", "after");
	Sea.util.hook("ItemRefTooltip.SetHyperlink", "ReagentHelper_ModifyItemRefTooltip", "after");
	
	if (Khaos) then
		Khaos.registerOptionSet("tooltip",
			{
				id = "ReagentHelper";
				text = RH_HEADER;
				helptext = RH_INFO;
				difficulty = 1;
				default = false;
				callback = function(state)
					ReagentHelper_Tooltip_Enable(state);
				end;
				options = {
					{
						id = "ReagentHelperHeader";
						text = RH_HEADER;
						helptext = RH_INFO;
						type = K_HEADER;
						difficulty = 1;
						default = {
							checked = true;
						};
						disabled = {
							checked = false;
						};
					};
				};
				commands = {
					{
						id = "ReagentHelperCommand";
						commands = { "/RHToggleTooltip", "/RHToggle" };
						helpText = RH_TOOLTIP_TOGGLE_CMD;
						parseTree = {
							["default"] = {
								[1] = {
									callback = function(msg)
										if (msg == RH_ON) then
											ReagentHelper_Tooltip_Enable(true);
											Sea.io.print(RH_TOOLTIP_TOGGLE_ENABLED);
										elseif (msg == RH_OFF) then
											ReagentHelper_Tooltip_Enable(false);
											Sea.io.print(RH_TOOLTIP_TOGGLE_DISABLED);
										else
											ReagentHelper_Tooltip_ToggleEnable();
										end
										Khaos.setSetKey("sets", "ReagentHelper", RH_TOOLTIP_ENABLE)
									end;
								};
							};
						};
					};
				};
			}
		);
	-- Register with the CosmosMaster
	elseif (Cosmos_RegisterConfiguration ~= nil) then
		Cosmos_RegisterConfiguration(
			"COS_REAGENT_HELPER",
			"SECTION",
			TEXT(RH_HEADER),
			TEXT(RH_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_REAGENT_SEPARATOR",
			"SEPARATOR",
			TEXT(RH_HEADER),
			TEXT(RH_INFO)
		);
		Cosmos_RegisterConfiguration(
			"COS_RH_TOOLTIP_ENABLE",
			"CHECKBOX",
			TEXT(RH_TOOLTIP_ENABLE_TEXT),
			TEXT(RH_TOOLTIP_ENABLE_INFO),
			ReagentHelper_Tooltip_Enable,
			0
		);
	end

	-- Add Slash Commands
	if (Sky) then
		if (not Khaos) then
			Sky.registerSlashCommand(
				{
					id = "RH_TOGGLETOOLTIP";
					commands = {"/RHToggleTooltip"};
					onExecute = ReagentHelper_Tooltip_ToggleEnable;
					helpText = RH_TOOLTIP_TOGGLE_CMD;
				}
			);
		end
		Sky.registerSlashCommand(
			{
				id = "RH_TESTITEM";
				commands = {"/RHTestItem"};
				onExecute = ReagentHelper_TestItem_Cmd;
				helpText = RH_TESTITEM_CMD;
			}
		);
	elseif (Cosmos_RegisterChatCommand) then
		Cosmos_RegisterChatCommand("RH_TOGGLETOOLTIP", {"/RHToggleTooltip"}, ReagentHelper_Tooltip_ToggleEnable, RH_TOOLTIP_TOGGLE_CMD);
		Cosmos_RegisterChatCommand("RH_TESTITEM", {"/RHTestItem"}, ReagentHelper_TestItem_Cmd, RH_TESTITEM_CMD);
	else
		SlashCmdList["RH_TOGGLETOOLTIP"] = ReagentHelper_Tooltip_ToggleEnable;
		SlashCmdList["RH_TESTITEM"] = ReagentHelper_TestItem_Cmd;
		SLASH_RH_TOGGLETOOLTIP1 = "/RHToggleTooltip";
		SLASH_RH_TESTITEM1 = "/RHTestItem";
	end
end

function ReagentHelper_ModifyGameTooltip()
	ReagentHelper_ModifyTooltip("GameTooltip");
end

function ReagentHelper_ModifyItemRefTooltip()
	ReagentHelper_ModifyTooltip("ItemRefTooltip");
end

function ReagentHelper_TestItem_Cmd(msg)
	if ( strlen(msg) > 0 ) then
		ReagentHelper_TestItem(msg);
	else
		Sea.io.print(RH_TESTITEM_CMD_HELP);
	end
end

function ReagentHelper_TestItem(item)
	ReagentHelper_ProffesionList = ReagentHelper_FindProfessions(item, ReagentHelper_ProffesionList);
	local professionString = "Item: "..item.."\nProfessions:";
	if (ReagentHelper_ProffesionList) then
		for professionIndex, professionName in ReagentHelper_ProffesionList do
			professionString = professionString.."\n  "..professionName
		end
	else
		professionString = professionString.."\n  "..RH_TESTITEM_NOPROFESSION;
	end
	Sea.io.print(professionString);
end

function ReagentHelper_ModifyTooltip(tooltipName)
	if ( RH_TOOLTIP_ENABLE and tooltipName ) then
		local tooltip = getglobal(tooltipName);
		if ( not tooltip ) then
			return;
		end
		local tooltipInfo = getglobal(tooltipName.."TextLeft1");
		if( tooltipInfo and tooltipInfo:IsVisible() ) then
			tooltipInfo = tooltipInfo:GetText();
		else
			tooltipInfo = nil;
		end
		
		if ( tooltipInfo and ( tooltipInfo ~= "" ) ) then
			ReagentHelper_ProffesionList = ReagentHelper_FindProfessions(tooltipInfo, ReagentHelper_ProffesionList);
			if (ReagentHelper_ProffesionList) then
				for professionIndex, professionName in ReagentHelper_ProffesionList do
					tooltip:AddLine(professionName, "", 1, 1, 1);
				end
				tooltip:Show();
			end
		end
	else
		-- No Labels
	end
end

function ReagentHelper_FindProfessions(item, list)
	local professionList = list;
	if (not professionList) then
		professionList = {};
	end
	for curItem in professionList do
		professionList[curItem] = nil;
	end
	table.setn(professionList, 0);
	local professionName = nil;
	for reagentName, reagentType in Sea.data.item.reagent do
		if (Sea.list.isInTable(reagentType, item)) then
			professionName = strupper(strsub(reagentName, 1, 1))..strsub(reagentName, 2);
			table.insert(professionList, professionName);
		end
	end

	return professionList;
end
