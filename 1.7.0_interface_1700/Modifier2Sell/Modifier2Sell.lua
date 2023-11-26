--------------------------------------------------------------------------
-- Modifier2Sell.lua
--------------------------------------------------------------------------
--[[
  Modifier2Sell
  -Force holding of modifier button while clicking when selling items to a
   vendor to help prevent accidental item sales.

  by Ryan Snook <rsnook@gryphonllc.com> based on code from CosmosGuiConfig.lua

  This was mainly written to be used with Khaos, to replace old Cosmos functionality,
  but was developed to work without it using:
    /modifier2sell shift
    /modifier2sell alt
    /modifier2sell ctrl
    /modifier2sell disable
    /modifier2sell help

  Version:
  2.0
    - Rebranded Shift2Sell to Modifier2Sell, added ability to use
    Shift, Alt or Ctrl modifier keys.
  1.0
    - Initial release of Shift2Sell enabled/disable shift key.

  $Id: Modifier2Sell.lua 2353 2005-08-27 20:23:19Z legorol $
  $Rev: 2353 $
  $LastChangedBy: legorol $
  $Date: 2005-08-27 15:23:19 -0500 (Sat, 27 Aug 2005) $
]]--

Modifier2Sell_Enabled = false;

function Modifier2Sell_ContainerFrameItemButton_OnClick(button, ignoreShift)
  if (button == "RightButton") then
    if (Modifier2Sell_Enabled == true) then
      if (MerchantFrame:IsVisible() and Modifier2Sell_Modifier == "shift") then
        if (IsShiftKeyDown()) then
          UseContainerItem(this:GetParent():GetID(), this:GetID());
        end
      elseif (MerchantFrame:IsVisible() and Modifier2Sell_Modifier == "alt") then
        if (IsAltKeyDown()) then
          UseContainerItem(this:GetParent():GetID(), this:GetID());
        end
      elseif (MerchantFrame:IsVisible() and Modifier2Sell_Modifier == "ctrl") then
        if (IsControlKeyDown()) then
          UseContainerItem(this:GetParent():GetID(), this:GetID());
        end
      else
        UseContainerItem(this:GetParent():GetID(), this:GetID());
      end
    else
      UseContainerItem(this:GetParent():GetID(), this:GetID());
    end
  else
    return true;
  end
  return false;
end

Sea.util.hook("ContainerFrameItemButton_OnClick", "Modifier2Sell_ContainerFrameItemButton_OnClick", "hide");

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
	if (cmd == "shift" or cmd == "alt" or cmd == "ctrl") then
    Modifier2Sell_Enabled = true;
    Modifier2Sell_Modifier = cmd;
    Modifier2Sell_Print(string.format(MODIFIER2SELL_RADIO_FEEDBACK_STRING, Sea.string.capitalizeWords(cmd)));
  elseif (cmd == "disable") then
    Modifier2Sell_Enabled = nil;
    Modifier2Sell_Modifier = nil;
    Modifier2Sell_Print(MODIFIER2SELL_CONFIG_HEADER.." "..MODIFIER2SELL_MSG_DISABLED);
	end
	if (cmd == "" or cmd == "help") then
    Modifier2Sell_Print(MODIFIER2SELL_SLASH_HELP..": "..SLASH_MODIFIER2SELL1.." or "..SLASH_MODIFIER2SELL2.." [ shift | alt | ctrl | disable | help ]");
	end
end

function Modifier2Sell_Print(msg)
  Sea.io.print(msg);
end

function Modifier2Sell_Register_Khaos()
  local radiom2sCallback = function (state)
    if (state.value == "shift" or state.value == "alt" or state.value == "ctrl") then
      Modifier2Sell_Modifier = state.value;
    end
  end;

  local radiom2sFeedback = function(state)
    if (state.value == "shift" or state.value == "alt" or state.value == "ctrl") then
      return string.format(MODIFIER2SELL_RADIO_FEEDBACK_STRING, Sea.string.capitalizeWords(state.value));
    end
  end;

  local radiom2sDefault = {
    value = "shift";
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
            Modifier2Sell_Enabled = true;
          else
            Modifier2Sell_Enabled = nil;
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
          checked = true
        };
        disabled = {
          checked = false
        };
      };
      {
        id = "m2sRadio1";
        text = string.format(MODIFIER2SELL_RADIO_TEXT_STRING, "Shift");
        helptext = string.format(MODIFIER2SELL_RADIO_HELPTEXT_STRING, "Shift");
        key = "m2sRadio";
        value = "shift";
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
        text = string.format(MODIFIER2SELL_RADIO_TEXT_STRING, "Alt");
        helptext = string.format(MODIFIER2SELL_RADIO_HELPTEXT_STRING, "Alt");
        key = "m2sRadio";
        value = "alt";
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
        text = string.format(MODIFIER2SELL_RADIO_TEXT_STRING, "Ctrl");
        helptext = string.format(MODIFIER2SELL_RADIO_HELPTEXT_STRING, "Ctrl");
        key = "m2sRadio";
        value = "ctrl";
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
    };
    default = true;
  };
  Khaos.registerOptionSet(
    "inventory",
    optionSet
 );
end;