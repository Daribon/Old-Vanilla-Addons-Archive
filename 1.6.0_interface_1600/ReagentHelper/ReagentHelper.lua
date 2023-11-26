--[[
    Reagent Helper - Lets you see which reagents are needed by which professions
    TODO: Build the window that lets you see all reagents for a profession
    AUTHOR: Tuatara
  ]]

-- Configuration variables
local RH_TOOLTIP_ENABLE = 1;  -- set this to non nil to enable Reagent Helper

-- Hook Saves
local SavedShowMerchantSellCursor = nil;

-- Callback functions
function ReagentHelper_Tooltip_Enable(toggle)
  if (toggle == 1) then 
    RH_TOOLTIP_ENABLE = 1;
  else
    RH_TOOLTIP_ENABLE = nil;
  end
end

function ReagentHelper_Tooltip_ToggleEnable()
  if (RH_TOOLTIP_ENABLE) then
    RH_TOOLTIP_ENABLE = nil;
  else
    RH_TOOLTIP_ENABLE = 1;
  end
  ReagentHelper_DisplayStatus();
end

function ReagentHelper_DisplayStatus()
  if (RH_TOOLTIP_ENABLE) then
    DEFAULT_CHAT_FRAME:AddMessage(RH_TOOLTIP_TOGGLE_ENABLED);
  else
    DEFAULT_CHAT_FRAME:AddMessage(RH_TOOLTIP_TOGGLE_DISABLED);
  end
end

function ReagentHelper_OnLoad()
	-- Hook ShowMerchantSellCursor on the end to modify tooptip
	if (ShowMerchantSellCursor ~= SavedShowMerchantSellCursor) then
		SavedShowMerchantSellCursor = ShowMerchantSellCursor;
		ShowMerchantSellCursor = ReagentHelper_ShowMerchantSellCursor;
	end
	
  -- Register with the UltimateUIMaster
  if(UltimateUI_RegisterConfiguration ~= nil) then
    UltimateUI_RegisterConfiguration(
      "UUI_REAGENT_HELPER",
      "SECTION",
      TEXT(RH_HEADER),
      TEXT(RH_INFO)
      );
    UltimateUI_RegisterConfiguration(
      "UUI_REAGENT_SEPARATOR",
      "SEPARATOR",
      TEXT(RH_HEADER),
      TEXT(RH_INFO)
      );
    UltimateUI_RegisterConfiguration(
      "UUI_RH_TOOLTIP_ENABLE",
      "CHECKBOX",
      TEXT(RH_TOOLTIP_ENABLE_TEXT),
      TEXT(RH_TOOLTIP_ENABLE_INFO),
      ReagentHelper_Tooltip_Enable,
      0
      );
  end

  -- Add Slash Commands
  if (UltimateUI_RegisterChatCommand) then
    UltimateUI_RegisterChatCommand("RH_TOGGLETOOLTIP", {"/RHToggleTooltip"}, ReagentHelper_Tooltip_ToggleEnable, RH_TOOLTIP_TOGGLE_CMD);
    UltimateUI_RegisterChatCommand("RH_TESTITEM", {"/RHTestItem"}, ReagentHelper_TestItem_Cmd, RH_TESTITEM_CMD);
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

function ReagentHelper_TestItem_Cmd(msg)
  if ( strlen(msg) > 0 ) then
    ReagentHelper_TestItem(msg);
  else
    DEFAULT_CHAT_FRAME:AddMessage(RH_TESTITEM_CMD_HELP);
  end
end

function ReagentHelper_TestItem(item)
  local professionList = ReagentHelper_FindProfessions(item);
  local professionString = "Item: "..item.."\nProfessions:";
  if (professionList) then
    for professionIndex, professionName in professionList do
      professionString = professionString.."\n  "..professionName
    end
  else
    professionString = professionString.."\n  "..RH_TESTITEM_NOPROFESSION;
  end
  DEFAULT_CHAT_FRAME:AddMessage(professionString);
end

function ReagentHelper_ModifyTooltip(tooltipName)
  if ( RH_TOOLTIP_ENABLE ) then
    local tooltip = getglobal(tooltipName);
    if ( not tooltip ) then
       return;
    end
    local tooltipInfo = Sea.wow.tooltip.scan(tooltipName);
    if ( tooltipInfo[1] ) then
      local professionList = ReagentHelper_FindProfessions(tooltipInfo[1].left);
      if (professionList) then
	    Sea.wow.tooltip.protectTooltipMoney();
        for professionIndex, professionName in professionList do
          tooltip:AddLine(professionName, "", 1, 1, 1);
        end
	    Sea.wow.tooltip.unprotectTooltipMoney();
        tooltip:Show();
      end
    end
  else
    -- No Labels
  end
end

function ReagentHelper_FindProfessions(item)
  local professionList = { };
  local professionName = nil;
  for reagentName, reagentType in Sea.data.item.reagent do
    if (Sea.list.isInTable(reagentType, item)) then
      professionName = strupper(strsub(reagentName, 1, 1))..strsub(reagentName, 2);
      table.insert(professionList, professionName);
    end
  end

  return professionList;
end

function ReagentHelper_ShowMerchantSellCursor(buttonID)
	SavedShowMerchantSellCursor(buttonID);
	ReagentHelper_ModifyGameTooltip();
end

