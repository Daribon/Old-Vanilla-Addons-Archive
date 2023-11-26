--------------------------------------------------------------------------
-- Modifier2Sell.lua
--------------------------------------------------------------------------
--[[
  Modifier2Sell
  -Force holding of modifier button while clicking when selling items to a
   vendor to help prevent accidental item sales.

  by Ryan Snook <rsnook@gryphonllc.com>

  This was mainly written to be used with Khaos, but was developed to work
  without it by providing slash commands when Khaos is not present:
    /modifier2sell help -- EN
    /modifier2sell aide -- FR
    /modifier2sell hilfe -- DE

  Version:
  20051017
  - Localization updates
  - Modifier2Sell_BagSlotButton_OnClick(button, ignoreShift, bag, slot) by sarf for addons such as AIOI, OneBag..
  - .toc to version 1800
  20050926
  - Added the ability to ignore split dialog when using shift.
  20050919
  - Changed the hook from hide to replace, thanks Mugendai.
  20050827
  - Thanks legrol for removing the spam.
  20050825
  - French Translation by Sasmiraa.
  20050824
  - Re-branded Shift2Sell to Modifier2Sell, added ability to use Shift, Alt or Ctrl modifier keys.
  20050823
  - Initial release of Shift2Sell enabled/disable shift key.

  $Id: Modifier2Sell.lua 2681 2005-10-22 06:21:16Z gryphon $
  $Rev: 2681 $
  $LastChangedBy: gryphon $
  $Date: 2005-10-22 01:21:16 -0500 (Sat, 22 Oct 2005) $
]]--

-- Default Config
Modifier2Sell_Config = {
  Enabled = 0; -- 1 enabled | 0 disabled
  Modifier = MODIFIER_KEY.SHIFT; -- MODIFIER_KEY.SHIFT | MODIFIER_KEY.ALT | MODIFIER_KEY.CTRL
  ShiftSplitStack = 1; -- 1 enabled | 0 disabled
}

function Modifier2Sell_ContainerFrameItemButton_OnClick(button, ignoreShift)
	if ((button == "RightButton") and MerchantFrame:IsVisible() and (Modifier2Sell_Config.Enabled == 1) and (Sea.list.isInList(MODIFIER_KEY, Modifier2Sell_Config.Modifier))) then
		--If the options are enabled, then only allow if the approriate key is pressed
		if (IsShiftKeyDown() and Modifier2Sell_Config.Modifier == MODIFIER_KEY.SHIFT) then
			return true;
		elseif (IsAltKeyDown() and Modifier2Sell_Config.Modifier == MODIFIER_KEY.ALT) then
			return true;
		elseif (IsControlKeyDown() and Modifier2Sell_Config.Modifier == MODIFIER_KEY.CTRL) then
			return true;
		end
		--Reject if the appropriate key is not pressed
		return false;
	end
	--Default to default behavior
	return true;
end
Sea.util.hook("ContainerFrameItemButton_OnClick", "Modifier2Sell_ContainerFrameItemButton_OnClick", "hide");

-- For bag-replacing addons such as AIOI, OneBag... et cetera. /sarf
-- Returns TRUE if the item should be SOLD / otherwise dealt with,
--  FALSE if NOTHING WHAT SO EVER should happen to the poor item.
function Modifier2Sell_BagSlotButton_OnClick(button, ignoreShift, bag, slot)
	if ((button == "RightButton") and MerchantFrame:IsVisible() and (Modifier2Sell_Config.Enabled == 1) and (Sea.list.isInList(MODIFIER_KEY, Modifier2Sell_Config.Modifier))) then
		--If it is shift and there is only one item to sell, then sell it like normal
		local _, itemCount = GetContainerItemInfo(bag, slot);
		if (IsShiftKeyDown() and (Modifier2Sell_Config.Modifier == MODIFIER_KEY.SHIFT) and ((not itemCount) or (itemCount <= 1) or (Modifier2Sell_Config.ShiftSplitStack == 0))) then
			UseContainerItem(bag, slot);
			StackSplitFrame:Hide();
			return false;
			--If it is control then sell it like normal
		elseif (IsControlKeyDown() and Modifier2Sell_Config.Modifier == MODIFIER_KEY.CTRL) then
			UseContainerItem(bag, slot);
			StackSplitFrame:Hide();
			return false;
		end
	end
	--For all other situations use default behavior
	return true;
end

function Modifier2Sell_Replace_ContainerFrameItemButton_OnClick(button, ignoreShift)
	return Modifier2Sell_BagSlotButton_OnClick(button, ignoreShift, this:GetParent():GetID(), this:GetID());
end
Sea.util.hook("ContainerFrameItemButton_OnClick", "Modifier2Sell_Replace_ContainerFrameItemButton_OnClick", "replace");

function Modifier2Sell_OnLoad()
  if (Khaos) then
    Modifier2Sell_Register_Khaos();
  else
    SLASH_MODIFIER2SELL1 = "/modifier2sell";
    SLASH_MODIFIER2SELL2 = "/m2s";
    SlashCmdList["MODIFIER2SELL"] = Modifier2Sell_Slash;
  end
end

function Modifier2Sell_Slash(msg)
  local cmd = string.lower(msg)
  if (Sea.list.isInList(MODIFIER_KEY, cmd)) then
    Modifier2Sell_Config.Enabled = 1;
    Modifier2Sell_Config.Modifier = cmd;
    Sea.io.print(string.format(MODIFIER2SELL_RADIO_FEEDBACK_STRING, Sea.string.capitalizeWords(cmd)));
  elseif (cmd == "shiftsplit") then
    Modifier2Sell_SlashToggle_ShiftSplit();
  elseif (cmd == MODIFIER2SELL_SLASHMSG_OPTION_DISABLE) then
    Modifier2Sell_Config.Enabled = 0;
    Modifier2Sell_Config.ShiftSplitStack = 1;
    Sea.io.print(MODIFIER2SELL_CONFIG_HEADER.." "..MODIFIER2SELL_MSG_DISABLED);
  elseif (cmd == MODIFIER2SELL_SLASHMSG_OPTION_STATUS) then
    if (Modifier2Sell_Config.Enabled == 1) then
      if (Modifier2Sell_Config.ShiftSplitStack == 1) then
        m2ssplitstack = MODIFIER2SELL_MSG_ENABLED;
      else
        m2ssplitstack = MODIFIER2SELL_MSG_DISABLED;
      end
      Sea.io.print(MODIFIER2SELL_SLASHMSG_STATUS.." "..MODIFIER2SELL_MSG_ENABLED..", "..MODIFIER2SELL_SLASHMSG_STATUS_MODIFIER.." "..Modifier2Sell_Config.Modifier..", "..MODIFIER2SELL_SLASHMSG_STATUS_SPLIT.." "..m2ssplitstack..".");
    else
      Sea.io.print(MODIFIER2SELL_SLASHMSG_STATUS.." "..MODIFIER2SELL_MSG_DISABLED..".");
    end
  elseif (cmd == "" or cmd == MODIFIER2SELL_SLASHMSG_OPTION_HELP) then
    Sea.io.print(MODIFIER2SELL_SLASHMSG_OPTIONS..": "..SLASH_MODIFIER2SELL1.." "..MODIFIER2SELL_SLASHMSG_OR.." "..SLASH_MODIFIER2SELL2.." [ "..MODIFIER_KEY.SHIFT.." | "..MODIFIER_KEY.ALT.." | "..MODIFIER_KEY.CTRL.." | "..MODIFIER2SELL_SLASHMSG_OPTION_DISABLE.." | shiftsplit | "..MODIFIER2SELL_SLASHMSG_OPTION_STATUS.." | "..MODIFIER2SELL_SLASHMSG_OPTION_HELP.." ]");
  end
end

function Modifier2Sell_SlashToggle_ShiftSplit()
  if (Modifier2Sell_Config.ShiftSplitStack ~= 1) then
    Modifier2Sell_Config.ShiftSplitStack = 1;
    Sea.io.print(string.format(MODIFIER2SELL_SPLITSTACK_FEEDBACK, MODIFIER2SELL_MSG_ENABLED));
  else
    Modifier2Sell_Config.ShiftSplitStack = 0;
    Sea.io.print(string.format(MODIFIER2SELL_SPLITSTACK_FEEDBACK, MODIFIER2SELL_MSG_DISABLED));
  end
end

function Modifier2Sell_Register_Khaos()
  local radiom2sCallback = function (state)
    if (Sea.list.isInList(MODIFIER_KEY, state.value)) then
      Modifier2Sell_Config.Modifier = state.value;
    end
  end;

  local radiom2sFeedback = function(state)
    if (Sea.list.isInList(MODIFIER_KEY, state.value)) then
      return string.format(MODIFIER2SELL_RADIO_FEEDBACK_STRING, Sea.string.capitalizeWords(state.value));
    end
  end;

  local radiom2sDefault = {
    value = MODIFIER_KEY.SHIFT;
  };

  local radiom2sDisabled = {
    value = false;
  };

  local optionSet = {
    id = "Modifier2Sell";
    text = MODIFIER2SELL_CONFIG_HEADER;
    helptext = MODIFIER2SELL_CONFIG_HEADER_INFO;
    difficulty = 1;
    options = {
      {
        id = "Header";
        text = MODIFIER2SELL_CONFIG_HEADER;
        helptext = MODIFIER2SELL_CONFIG_HEADER_INFO;
        type = K_HEADER;
        difficulty = 1;
      };
      {
        id = "Modifier2SellEnable";
        type = K_TEXT;
        text = MODIFIER2SELL_ENABLE_TEXT;
        helptext = MODIFIER2SELL_ENABLE_HELPTEXT;
        callback = function(state)
          if (state.checked) then
            Modifier2Sell_Config.Enabled = 1;
          else
            Modifier2Sell_Config.Enabled = 0;
          end
        end;
        feedback = function(state)
          if (state.checked) then
            return string.format(MODIFIER2SELL_ENABLE_FEEDBACK, MODIFIER2SELL_MSG_ENABLED);
          else
            return string.format(MODIFIER2SELL_ENABLE_FEEDBACK, MODIFIER2SELL_MSG_DISABLED);
          end
        end;
        check = true;
        default = {
          checked = false
        };
        disabled = {
          checked = false
        };
      };
      {
        id = "m2sRadio1";
        text = string.format(MODIFIER2SELL_RADIO_TEXT_STRING, Sea.string.capitalizeWords(MODIFIER_KEY.SHIFT));
        helptext = string.format(MODIFIER2SELL_RADIO_HELPTEXT_STRING, Sea.string.capitalizeWords(MODIFIER_KEY.SHIFT));
        key = "m2sRadio";
        value = MODIFIER_KEY.SHIFT;
        radio = true;
        type = K_TEXT;
        default = radiom2sDefault;
        disabled = radiom2sDisabled;
        callback = radiom2sCallback;
        feedback = radiom2sFeedback;
        setup = {
          selectedColor={r=0,g=1,b=0};
          disabledColor={r=.5,g=.5,b=.5};
        }
      };
      {
        id = "m2sRadio2";
        text = string.format(MODIFIER2SELL_RADIO_TEXT_STRING, Sea.string.capitalizeWords(MODIFIER_KEY.ALT));
        helptext = string.format(MODIFIER2SELL_RADIO_HELPTEXT_STRING, Sea.string.capitalizeWords(MODIFIER_KEY.ALT));
        key = "m2sRadio";
        value = MODIFIER_KEY.ALT;
        radio = true;
        type = K_TEXT;
        default = radiom2sDefault;
        disabled = radiom2sDisabled;
        callback = radiom2sCallback;
        feedback = radiom2sFeedback;
        setup = {
          selectedColor={r=1,g=0,b=0};
          disabledColor={r=.5,g=.5,b=.5};
        }
      };
      {
        id = "m2sRadio3";
        text = string.format(MODIFIER2SELL_RADIO_TEXT_STRING, Sea.string.capitalizeWords(MODIFIER_KEY.CTRL));
        helptext = string.format(MODIFIER2SELL_RADIO_HELPTEXT_STRING, Sea.string.capitalizeWords(MODIFIER_KEY.CTRL));
        key = "m2sRadio";
        value = MODIFIER_KEY.CTRL;
        radio = true;
        type = K_TEXT;
        default = radiom2sDefault;
        disabled = radiom2sDisabled;
        callback = radiom2sCallback;
        feedback = radiom2sFeedback;
        setup = {
          selectedColor={r=.2,g=2,b=1};
          disabledColor={r=.5,g=.5,b=.5};
        }
      };
      {
        id = "Modifier2SellShiftSplitStack";
        type = K_TEXT;
        text = MODIFIER2SELL_SPLITSTACK_TEXT;
        helptext = MODIFIER2SELL_SPLITSTACK_HELPTEXT;
        callback = function(state)
          if (state.checked) then
            Modifier2Sell_Config.ShiftSplitStack = 1;
          else
            Modifier2Sell_Config.ShiftSplitStack = 0;
          end
        end;
        feedback = function(state)
          if (state.checked) then
            return string.format(MODIFIER2SELL_SPLITSTACK_FEEDBACK, MODIFIER2SELL_MSG_ENABLED);
          else
            return string.format(MODIFIER2SELL_SPLITSTACK_FEEDBACK, MODIFIER2SELL_MSG_DISABLED);
          end
        end;
        check = true;
        default = {
          checked = true
        };
        disabled = {
      	  checked = true
        };
      };
    };
    default = false;
  };
  Khaos.registerOptionSet(
    "inventory",
    optionSet
);
end;